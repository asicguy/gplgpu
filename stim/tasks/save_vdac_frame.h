///////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2014 Francis Bruno, All Rights Reserved
// 
//  This program is free software; you can redistribute it and/or modify it 
//  under the terms of the GNU General Public License as published by the Free 
//  Software Foundation; either version 3 of the License, or (at your option) 
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but 
//  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
//  or FITNESS FOR A PARTICULAR PURPOSE. 
//  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with
//  this program; if not, see <http://www.gnu.org/licenses>.
//
//  This code is available under licenses for commercial use. Please contact
//  Francis Bruno for more information.
//
//  http://www.gplgpu.com
//  http://www.asicsolutions.com
//
//  Title       :  
//  File        :  
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
//
///////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// This task will capture one frame (including blanks) of data on input to the
// VDAC module.The captured data has passed LUT so it always seen as 24 bit
// RGB, regardless the depth set or VGA mode.
// Blanks may shift by one pixel and/or line depending on polarity of syncs. 
// The task assumes negative syncs, but will work with positve syncs too
// shifting a black frame around the frame
// Active portion should not be affected.
// syncs signals used here are the ones connected to IO buffers inside
// the chip (a delay through the buffers are practically don't care in real life
// but for purpose of this task the delay might shift the results)  
// I assumme that all delays in syncs paths and data path after the very
// last flip_flops are less then one clock which
// may not be true !!
// Pixel clock is probed in  module "ram_ctl"
// (path:  U0.u_ramdac.RDAC.rambo_int.rrstuff.pixclk )
// this is a convienient point to probe the pixel clock
// because the real pixel data and syncs are generated from
// two differrent versions of this clock (both in rambo_i module )
// syncs_pixclk=pixclk & !sync_pwr & !iclk_pwr ; 
// pixclk_pwr = pixclk &  !iclk_pwr ;



reg [15:0] vdac_xcnt;
reg [15:0] vdac_ycnt;
reg [15:0] dac_xsize;
reg [15:0] dac_ysize;
reg        hold_to_hsync;
reg vdac_save_enable;
reg active_frame_vdac;
integer vdac_file;
event start_frame_vdac;
wire [23:0] vdac_data_i_p0;
wire [23:0] vdac_data_i_p1;

assign vdac_data_i_p0 = { dvo_data[23:16],
                          dvo_data[15:8],
                          dvo_data[7:0]
                       };

initial
begin
vdac_save_enable = 0;
active_frame_vdac =0;
vdac_xcnt=0;
vdac_ycnt=0;
hold_to_hsync=0;
end

always @(posedge VSYNC) //using posedge may speed up capture  
        hold_to_hsync<=1; 		 // address synchr. on negedge

always @(negedge HSYNC) 
//always @(negedge U0.HSYNC0n) 
begin
  if(hold_to_hsync==1)
     begin
        hold_to_hsync<=0;
        vdac_ycnt<=0;

        if(vdac_save_enable)
          begin
            if (active_frame_vdac)
               begin
                 vdac_save_enable<=0;
                 active_frame_vdac<=0;
               end
           else
               begin
                 active_frame_vdac = 1;
                 -> start_frame_vdac;
               end
          end
     end
  else  vdac_ycnt<=vdac_ycnt+1;
vdac_xcnt=0;
end

always @(posedge pixclk)
     // if (U0.crtclock) vdac_xcnt <=vdac_xcnt+1;
     vdac_xcnt <=vdac_xcnt+1;

always
  @ start_frame_vdac
   begin
    // Write Bitmap Header information to file.
    $fwrite(vdac_file,"\nVerilog Simulation Data\n\n");
    $fwrite(vdac_file,"BitmapDX\t%d\n",dac_xsize );
    $fwrite(vdac_file,"BitmapDY\t%d\n",dac_ysize);
    $fwrite(vdac_file,"BitsPerPixel\t   24\n");
    $fwrite(vdac_file,"WidthBytes\t%d\n\n", (dac_xsize*4) );
    $fwrite(vdac_file,"    X\t    Y\tPixelValue\n");
     
    while (active_frame_vdac)
      begin
      		// $display("you are here");
      		// $stop;
	@(posedge pixclk)
			begin
          			if(active_frame_vdac) //  && U0.crtclock) 
					$fwrite(vdac_file,"%d\t%d\t0x%0h\n", vdac_xcnt, vdac_ycnt, vdac_data_i_p0);  //pixel data
			end
       end
    $display("CLosing file:\ '%s' ",vdac_file );
    $fclose(vdac_file);
   end


task save_vdac_frame;
input [240:1]  file_name; 
begin

$display ("START task save_vdac_frame ");
$display ("checking crt and ramdac settings ");

pci_burst_data(rbase_g+32'h1C,4'h0,32'h0); //Index control = Auto inc off
//read misc2 register to verify if in vga mode
pci_burst_data(rbase_g+32'h14,4'h0,32'h0); //Index high =>0
pci_burst_data(rbase_g+32'h10,4'h0,32'h71); //Index low=0x71 (misc2)
rd(MEM_RD,rbase_g+32'h18, 1); //read Index data
if(test_reg[0]===1'bx)
    begin
     $display("port select VGA/64bits mode in ramdac is unknown");
     $stop;
    end
 else if(test_reg[0]==1'b0)
        begin // add VGA registers reads later
        $display("Setting VGA output size via test"); 
          $display("x: %d", dac_xsize); 
          $display("y: %d", dac_ysize); 
        end
 else begin //not VGA mode, check CRT settings
      rd (MEM_RD, rbase_g+CRT_VBL, 1);
      dac_ysize=test_reg;
      rd (MEM_RD, rbase_g+CRT_VAC, 1);
      dac_ysize=dac_ysize + test_reg;

      rd (MEM_RD, rbase_g+CRT_HAC, 1);
      dac_xsize=test_reg;
      rd (MEM_RD, rbase_g+CRT_HBL, 1);
      dac_xsize=dac_xsize + test_reg;

      if(^dac_xsize ===1'bx || ^dac_ysize===1'bx )
        begin
        $display("Silver Hammer CRT registers return unknown value !! "); 
        $stop;
        end

      pci_burst_data(rbase_g+32'h10,4'h0,32'ha); //Index low=a (pix.represent)
      rd(MEM_RD,rbase_g+32'h18, 1); //read Index data
      if(test_reg[2:0]==3'b011) //8bpp
          dac_xsize=8*dac_xsize;
      else if(test_reg[2:0]==3'b100) //16/15bpp
          dac_xsize=4*dac_xsize;
      else if(test_reg[2:0]==3'b110) //32bpp
          dac_xsize=2*dac_xsize;
      else begin
           $display("uknown pixel format in RAMDAC!!!");
           $stop;
           end
      end 
 
   begin
     $display("Opening save_vdac_frame file:\n '%s' ", file_name);
     vdac_file = $fopen(file_name);
     vdac_save_enable=1;
     #(hclk);
     wait (!vdac_save_enable);
   end

end
endtask




