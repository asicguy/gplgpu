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
//  Title       :  CRT Controller Data out
//  File        :  dc_adout.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps

  module dc_adout
    (
     input             pixclock,
     input             dcnreset,
     input             hnreset,
     input             vsync,
     input             cblank, 
     input             rsuppr,
     input [9:0]       ff_stp,
     input [9:0]       ff_rls,
     input [10:0]      ovtl_y, 
     input [10:0]      ovbr_y,
     input [1:0]       bpp,
     input [127:0]     crt_data,
     input [7:0]       vga_din,
     input             vga_en,
     
     output reg [23:0] datdc_out,
     output            pop
     );

  reg [3:0] counter;         // Cycle counter
  reg [3:0] out_sel0, out_sel; // Delayed cycle count
  reg [3:0] inc;             // Increment value
  reg 	    cblankd;         // Delayed cblank
  reg [11:0] lcount;          // Line Count
  reg [9:0]  pcount;          // Page Counter
  reg 	     hdisbl;
  reg 	     vdisbl;
  reg [31:0] crt_dat;
  reg [7:0]   vga_store;      // Need one extra VGA storage cycle
  
  wire [11:0] ff_yrls;
  wire        active;         // High when we are actively counting

  assign pop = cblank & (counter == 0);

  assign active = ~(hdisbl & vdisbl & cblank & rsuppr);
  
  // Determine the increment value - Registered so we won't multicycle
  always @(posedge pixclock or negedge hnreset )
    if(!hnreset) begin
      inc     <= 4'b0;
    end else if (active)
      casex (bpp)
	2'b01:   inc <= 4'h1; // 8 Bpp (unpacked)  
	2'b10:   inc <= 4'h2; // 16 Bpp
	default: inc <= 4'h4; // 32 Bpp
      endcase // casex({greyscale_8bpp, bpp})
  
  // Cycle Counter
  always @(posedge pixclock or negedge hnreset )
    if(!hnreset) begin
      counter     <= 4'b0;
    end else if (!(vsync && cblank)) begin
      counter     <= 4'b0;
    end else if (active) begin
      counter     <= counter + inc;
    end

  // Isolate data output so it will run even if all else is off
  always @(posedge pixclock or negedge hnreset )
    if(!hnreset) begin
      vga_store   <= 8'h0;
      datdc_out   <= 24'b0;
    end else begin
      
      // Delay the VGA data one cycle
      vga_store <= vga_din;

      // Data muxing from RAM 
      casex ({vga_en, bpp, out_sel[1:0]})
	// VGA mode
	5'b1_xx_xx: datdc_out <= {3{vga_store}};
	// 8 bits per pixel.
	5'b0_01_00: datdc_out <= {3{crt_dat[7:0]}};
	5'b0_01_01: datdc_out <= {3{crt_dat[15:8]}};
	5'b0_01_10: datdc_out <= {3{crt_dat[23:16]}};
	5'b0_01_11: datdc_out <= {3{crt_dat[31:24]}};
	// 16 bits per pixel.
	5'b0_10_0x: datdc_out <= {8'h0, crt_dat[15:0]};
	5'b0_10_1x: datdc_out <= {8'h0, crt_dat[31:16]};
	// 32 bits per pixel.
	5'b0_00_xx, 6'b0_0_11_xx: datdc_out <= crt_dat[23:0];
      endcase // casex({greyscale_8bpp, bpp, out_sel})
      
    end
  
  always @(posedge pixclock or negedge hnreset )
    if(!hnreset) begin
      cblankd     <= 1'b0;
      lcount      <= 12'b0;
      pcount      <= 10'b0;
      hdisbl      <= 1'b0;
      vdisbl      <= 1'b0;
      out_sel0    <= 2'b0;
      out_sel     <= 2'b0;
    end else if(!dcnreset) begin
      cblankd     <= 1'b0;
      lcount      <= 12'b0;
      pcount      <= 10'b0;
      hdisbl      <= 1'b0;
      vdisbl      <= 1'b0;
      out_sel0    <= 2'b0;
      out_sel     <= 2'b0;
      crt_dat     <= 32'b0;
    end else begin

      // Delay the out select for muxing
      out_sel0  <= counter;
      out_sel   <= out_sel0;

      case (out_sel0[3:2])
	2'd0: crt_dat <= crt_data[31:0];
	2'd1: crt_dat <= crt_data[63:32];
	2'd2: crt_dat <= crt_data[95:64];
	2'd3: crt_dat <= crt_data[127:96];
      endcase // case(out_sel0[3:2])
      
      // Delay cblank for edge detection
      cblankd     <= cblank;

      //count actual scan lines and pages to find where the output address
      //should be held inside video overlay window. When the window ends,
      //addresses have to point already to page where a valid data is stored.

      // Line Counter
      if (!(vsync & rsuppr))      lcount <= 12'b0;      // unecessary tog supr
      else if (cblankd & ~cblank) lcount <= lcount + 12'h1; // Count begin blank

      // Page Counter
      if(!(vsync & cblank & rsuppr)) pcount <= 10'b0;   // don't toggle unnec
      else if (pop)                  pcount <= pcount + 10'h1;

      // Disable address increments
      if (pcount == ff_stp)                   // Was Pcount_next. Fixme????
	hdisbl <= 1'b1;
      else if ((pcount == ff_rls) || !cblank) // Was Pcount_next. Fixme????
        hdisbl <= 1'b0;

      if (lcount == {1'b0,ovtl_y}) 
	vdisbl <= 1'b1;
      else if ((lcount == ff_yrls)|| !vsync)
	vdisbl <= 1'b0;
   end

  assign ff_yrls = ovbr_y +1'b1;

endmodule
