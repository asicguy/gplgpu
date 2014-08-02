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
//  Title       :  Avalon memory interface functional model
//  File        :  borealis_stim.v
//  Author      :  Frank Bruno
//  Created     :  10-19-2010
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : This models a memory based on the avalon interface to
//                speed up simulations.
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
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
module fast_mem_tasks;
  // These tasks are for 128 bit version of the memory, 16 BYTES only
  /**************************************************************************/
  /* Behavioral tasks to move data to or from the RAMs */
  task ram_fill32;

    // This tasks initialize display buffer memory by writing requested number 
    // of 32 bit words of data with a initial location  at start_addr.
    // Start address is specifed for a 32bit word. (IT is not page_address as 
    // for EDO, and it is NOT byte address). The task can fill 8MB display 
    // buffer switching automaticaly to the proper 4MB bank.
    // Data is placed in memories assuming an upgradable 2MB@64 ->4MB@128 board
    // The amount of data written to the buffer is the same for 64 bit bus and
    // 128 bit bus if the number of words passed to the task stays the same.

    input [31:0] start_adr; // address in 32bit words
    input [31:0] words;
    input [31:0] data;
    
    reg [31:0]   i;
    begin
      // for (i = start_adr; i < (start_adr+words)<<2; i = i + 1) begin
      for (i = start_adr; i < (start_adr+words); i = i + 1) begin
	// U0.U_DDR3.mem[i] = data[i[1:0]*8+:8];
	U0.U_DDR3.mem[{i, 2'b00}] = data[7:0];
	U0.U_DDR3.mem[{i, 2'b01}] = data[15:8];
	U0.U_DDR3.mem[{i, 2'b10}] = data[23:16];
	U0.U_DDR3.mem[{i, 2'b11}] = data[31:24];
      end
    end
  endtask  // ram_fill32
  
  /**************************************************************************/
  task ram_loadh;
    input [22:0] start_adr;
    input [127:0] datar;
    input [15:0]  ben;

    reg [31:0]     indxw; // pointer to SGRAM buffer

    begin
      indxw = start_adr<<4;
      for (int i = 0; i < 16; i++) begin
	// $display("Writing %h: %h", indxw, datar[i[3:0]*8+:8]);
	U0.U_DDR3.mem[indxw] = datar[i[3:0]*8+:8];
	indxw++;
	// #100 $stop;
      end
      // Read next line
      //status_in = $fscanf(file_in, "%h\n", datar);
    end
  endtask  // ram_loadh
      
  /**************************************************************************/
  task ram_floadh;

    // This task  loads a requested number of 128bit words of data  from 
    // a file and places it in the display SGRAM buffer starting at start_addr.
    // The start addr is in 32bit words.
    // Written by Jack and _copied_ by hk for sgram
    input [8*64:1] image_file;
    input [21:0]   start_adr; //start address in memory [32bit words]
    input [16:0]   lines;     /* number of 128bit words to be read from temp
                               * buffer/into SGRAM models.
                               * In most cases this will be
                               * number of lines in a file , 
                               * But it can be smaller */

    reg [127:0]    datar; // data read from temp buffer      
    reg [31:0]     indxw; // pointer to SGRAM buffer
    integer 	   file_in; // File pointer
    integer 	   status_in; // Status of file
    
    begin
      $display ("reading file %s", image_file);
      file_in   = $fopen(image_file, "r");
      $display ("loading image into SGRAM RAM DISPLAY BUFFER ");
      // indxw = start_adr<<4;
      indxw = start_adr<<2;
      while (!$feof(file_in)) begin
	status_in = $fscanf(file_in, "%h\n", datar);
	for (int i = 0; i < 16; i++) begin
	  // $display("Writing %h: %h", indxw, datar[i[3:0]*8+:8]);
	  U0.U_DDR3.mem[indxw] = datar[i[3:0]*8+:8];
	  indxw++;
	  // #100 $stop;
	end
	// Read next line
	//status_in = $fscanf(file_in, "%h\n", datar);
      end
    end
  endtask  // ram_floadh

  /**************************************************************************/
  task ram_floadh2;

    // This task  loads a requested number of 128bit words of data  from 
    // a file and places it in the display SGRAM buffer starting at start_addr.
    // The start addr is in 32bit words.
    input [8*64:1] image_file;

    reg [127:0]    datar; // data read from temp buffer      
    reg [22:0]     adr; //start address in memory [32bit words]
    reg [31:0]     indxw; // pointer to SGRAM buffer
    reg [15:0] 	   mask;
    
    integer 	   file_in; // File pointer
    integer 	   status_in; // Status of file
    
    begin
      $display ("reading file %s", image_file);
      file_in   = $fopen(image_file, "r");
      $display ("loading data into RAM\n");

      while (!$feof(file_in)) begin
	status_in = $fscanf(file_in, "%h %h %h\n", adr, datar, mask);
	indxw = adr<<4;
	for (int i = 0; i < 16; i++) begin
	  // $display("Writing %h: %h", indxw, datar[i[3:0]*8+:8]);
	  if (~mask[i]) U0.U_DDR3.mem[indxw] = datar[i[3:0]*8+:8];
	  indxw++;
	  // #100 $stop;
	end
	// Read next line
	//status_in = $fscanf(file_in, "%h\n", datar);
      end
    end
  endtask  // ram_floadh

  /**************************************************************************/
  task ram_floadh_32_to_565;

    // This task  loads a requested number of 128bit words of data  from 
    // a file and places it in the display SGRAM buffer starting at start_addr.
    // The start addr is in 32bit words.
    // Written by Jack and _copied_ by hk for sgram
    input [8*64:1] image_file;
    input [21:0]   start_adr; //start address in memory [32bit words]
    input [16:0]   lines;     /* number of 128bit words to be read from temp
                               * buffer/into SGRAM models.
                               * In most cases this will be
                               * number of lines in a file , 
                               * But it can be smaller */

    reg [255:0]    datar; // data read from temp buffer      
    reg [127:0]    datar1; // data read from temp buffer      
    reg [31:0]     indxw; // pointer to SGRAM buffer
    integer 	   file_in; // File pointer
    integer 	   status_in; // Status of file
    
    begin
      $display ("reading file %s", image_file);
      file_in   = $fopen(image_file, "r");
      status_in = $fscanf(file_in, "%h\n", datar[127:0]);
      status_in = $fscanf(file_in, "%h\n", datar[255:128]);

		datar1[15:0]    = {datar[(0*32)+23:(0*32)+19], datar[(0*32)+15:(0*32)+10], datar[(0*32)+7:(0*32)+3]};
		datar1[31:16]   = {datar[(1*32)+23:(1*32)+19], datar[(1*32)+15:(1*32)+10], datar[(1*32)+7:(1*32)+3]};
		datar1[47:32]   = {datar[(2*32)+23:(2*32)+19], datar[(2*32)+15:(2*32)+10], datar[(2*32)+7:(2*32)+3]};
		datar1[63:48]   = {datar[(3*32)+23:(3*32)+19], datar[(3*32)+15:(3*32)+10], datar[(3*32)+7:(3*32)+3]};
		datar1[79:64]   = {datar[(4*32)+23:(4*32)+19], datar[(4*32)+15:(4*32)+10], datar[(4*32)+7:(4*32)+3]};
		datar1[95:80]   = {datar[(5*32)+23:(5*32)+19], datar[(5*32)+15:(5*32)+10], datar[(5*32)+7:(5*32)+3]};
		datar1[111:96]  = {datar[(6*32)+23:(6*32)+19], datar[(6*32)+15:(6*32)+10], datar[(6*32)+7:(6*32)+3]};
		datar1[127:112] = {datar[(7*32)+23:(7*32)+19], datar[(7*32)+15:(7*32)+10], datar[(7*32)+7:(7*32)+3]};

      $display ("loading image into SGRAM RAM DISPLAY BUFFER ");
      // indxw = start_adr<<4;
      indxw = start_adr<<2;
      while (!$feof(file_in)) begin
	for (int i = 0; i < 16; i++) begin
	  // $display("Writing %h: %h", indxw, datar[i[3:0]*8+:8]);
	  U0.U_DDR3.mem[indxw] = datar1[i[3:0]*8+:8];
	  indxw++;
	  // #100 $stop;
	end
	// Read next line
        status_in = $fscanf(file_in, "%h\n", datar[127:0]);
        status_in = $fscanf(file_in, "%h\n", datar[255:128]);
		datar1[15:0]    = {datar[(0*32)+23:(0*32)+19], datar[(0*32)+15:(0*32)+10], datar[(0*32)+7:(0*32)+3]};
		datar1[31:16]   = {datar[(1*32)+23:(1*32)+19], datar[(1*32)+15:(1*32)+10], datar[(1*32)+7:(1*32)+3]};
		datar1[47:32]   = {datar[(2*32)+23:(2*32)+19], datar[(2*32)+15:(2*32)+10], datar[(2*32)+7:(2*32)+3]};
		datar1[63:48]   = {datar[(3*32)+23:(3*32)+19], datar[(3*32)+15:(3*32)+10], datar[(3*32)+7:(3*32)+3]};
		datar1[79:64]   = {datar[(4*32)+23:(4*32)+19], datar[(4*32)+15:(4*32)+10], datar[(4*32)+7:(4*32)+3]};
		datar1[95:80]   = {datar[(5*32)+23:(5*32)+19], datar[(5*32)+15:(5*32)+10], datar[(5*32)+7:(5*32)+3]};
		datar1[111:96]  = {datar[(6*32)+23:(6*32)+19], datar[(6*32)+15:(6*32)+10], datar[(6*32)+7:(6*32)+3]};
		datar1[127:112] = {datar[(7*32)+23:(7*32)+19], datar[(7*32)+15:(7*32)+10], datar[(7*32)+7:(7*32)+3]};
      end
    end
  endtask  // ram_floadh

  task vga_floadh;

    // This task loads a VGA memory image into the I128 Memory system
    input [8*64:1] image_file;
    input [21:0]   start_adr; // start address in memory [32bit words]
    input [15:0]   lines;     /* number of 128bit words to be read from temp
                               * buffer/into SGRAM models.
                               * In most cases this will be number of lines 
                               * in a file , But it can be smaller */

    reg [32:0]     tempbuff[0:131071]; // TWO meg !!, always loaded from addr=0
    reg [127:0]    datar; // data read from temp buffer      
    reg [16:0]     indxr; // pointer to temp buffer
    reg [1:0]      indxwr;// Index write

    reg [31:0]     dataw; // data writen into SGRAM
    reg [21:0]     indxw; // pointer to SGRAM buffer


    begin
      $display ("reading file %s", image_file);
      $readmemh(image_file, tempbuff);  //load temp. buffer from a file

      $display ("loading image into SGRAM RAM DISPLAY BUFFER ");
      indxw = start_adr;
      for (indxr = 0; indxr < lines; indxr = indxr + 1) begin
        datar = tempbuff[indxr];

        for (indxwr = 0; indxwr < 2; indxwr = indxwr + 1) begin
          VR.ram_fill32(indxw, 1, datar);
          indxw = indxw + 1;
        end
      end
    end
  endtask  // ram_floadh

  
  /**************************************************************************/
  task save_fbmp;
    //This task saves a bitmap in DISPLAY buffer to a file.

    input [31:0]  bitmap_address;    // Byte address in DISPLAY buffer
    input [15:0]  x_size;            /* X size (in pixels) of the image
                                      * in the output file */ 
    input [15:0]  y_size;            /* Y size (in pixels) of the image
                                      * in the output file */
    input [240:1] file_name;         // name of the output file
    input [31:0]  i_pitch;           /* Image pitch (in bytes) in the display
                                      * buffer
                                      * This may be set in local tasks
                                      * arbitrarily or passed to this task
                                      * as the result of testing of e.g. 
                                      * xx_DPTCH register, or other internal
                                      * registers. */
                                      
    input [1:0]   i_psize;           /* Image bpp in the display buffer
                                      * This may be set in local tasks
                                      * arbitrarily or passed to this task
                                      * as the result of testing of e.g. 
                                      * xx_PSIZE register or other internal
                                      * registers */

    integer       index;
    integer       x;
    integer       y;
    integer       pageindex;
    integer       dump_file;
    integer       data_file;
    integer       pitch;
    integer       bpp;
    reg [15:0]    temp_mem;
    reg [32:0]    data;
    reg [7:0]     c8;
    reg [15:0]    c16;
    reg [31:0]    c32;
    integer       i;
    
    reg [127:0]   data_0, data_1, data_2, data_3, data_4, data_5, data_6,
                  data_7;
    
    begin
      $display("Saving file '%s' ...", file_name);
      dump_file = $fopen(file_name);
      data_file = $fopen("data.bmp");
      pitch = i_pitch ;
      $display("pitch = %h ", pitch);
      bpp = 8;
      if (i_psize==2'b10)
        bpp = 32;
      else if (i_psize==2'b01 | i_psize==2'b11)
        bpp = 16;
      
      if (bpp == 8)       index = bitmap_address;
      else if (bpp == 16) index = bitmap_address >> 1;
      else if (bpp == 32) index = bitmap_address >> 2;

      // Write Bitmap Header information to file.
      $fwrite(dump_file,"\nVerilog Simulation Data\n\n");
      $fwrite(dump_file,"BitmapDX\t%d\n", x_size);
      $fwrite(dump_file,"BitmapDY\t%d\n", y_size);
      $fwrite(dump_file,"BitsPerPixel\t%d\n", bpp);
      $fwrite(dump_file,"WidthBytes\t%d\n\n", x_size * bpp/8);
      $fwrite(dump_file,"X\tY\tPixelValue\n");
      
      for (y = 0; y < y_size; y = y + 1) begin
        for (x = 0; x < x_size; x = x + 1) begin
          pageindex = (index + x);
          //if (bpp == 8) pageindex = (index + x);
          //else if (bpp == 16) pageindex = (index + (x * 2));
          //else if (bpp == 32) pageindex = (index + (x * 4));
          //    $display ("Direct Read %h", pageindex[20:0]);
          
          if (bpp == 8) begin
            c8 = U0.U_DDR3.mem[pageindex];
            $display("Saving from %h", pageindex);
            $fwrite(dump_file,"%d\t%d\t0x%0h\n", x, y, c8);
            $fwrite(data_file,"%c", c8);
          end else if (bpp == 16) begin
            c16 = {U0.U_DDR3.mem[{pageindex,1'b1}],
		   U0.U_DDR3.mem[{pageindex,1'b0}]};
            $fwrite(dump_file,"%d\t%d\t0x%0h\n", x, y, c16);
            $fwrite(data_file,"%c", c16[7:0]);
            $fwrite(data_file,"%c", c16[15:8]);
          end else if (bpp == 32) begin
            data = {U0.U_DDR3.mem[{pageindex,2'b11}],
		    U0.U_DDR3.mem[{pageindex,2'b10}],
		    U0.U_DDR3.mem[{pageindex,2'b01}],
		    U0.U_DDR3.mem[{pageindex,2'b00}]};
            $fwrite(dump_file,"%d\t%d\t0x%0h\n", x, y, data);
            $fwrite(data_file,"%c", data[7:0]);
            $fwrite(data_file,"%c", data[15:8]);
            $fwrite(data_file,"%c", data[23:16]);
            $fwrite(data_file,"%c", data[31:24]);
            $display("Saving %h from %h", U0.U_DDR3.mem[pageindex], pageindex>>2);
          end
          //$display("saving address %h,: %h", pageindex[20:2], c8);
        end // for (x = 0; x < x_size; x = x + 1)
        //index = index + pitch;
        if (bpp == 8)      index = index + pitch;
        else if (bpp == 16)index = index + (pitch >> 1);
        else               index = index + (pitch >> 2);

      end // for (y = 0; y < y_size; y = y + 1)
      
      $fclose(dump_file);
      $fclose(data_file);
      $display("Done saving file '%s' ...", file_name);
    end
  endtask // save_fbmp
  
  /****************************************************************/
  /* For future reference, these are the commands availible     */
  /* for dynamic memory allocation.                             */
  //    $damem_read("MEM",adr,data_reg);
  //    $damem_write("MEM",adr,data_val);
  //    $damem_initb("MEM","file_name",addr_from,addr_to); //formatted for the readmemb system task.
  //    $damem_inith("MEM","file_name",addr_from,addr_to); //formatted for the readmemh system task.
  /****************************************************************/
  task rr;
    input [19:0] start_adr;
    input [19:0] words;
    reg [31:0]   i;
    reg [127:0]  ram_reg;
    
    begin
      $display("start addr= %h   quan words= %h",start_adr,i);
      for(i=start_adr;i<(start_adr+words*4);i=i+4) begin
        ram_reg = {U0.U_DDR3.mem[{start_adr[19:0]+3, 2'b0}],
                   U0.U_DDR3.mem[{start_adr[19:0]+2, 2'b0}],
                   U0.U_DDR3.mem[{start_adr[19:0]+1, 2'b0}],
                   U0.U_DDR3.mem[{start_adr[19:0], 2'b0}]};
        $display("addr= %h data= %h",i,ram_reg);
      end
    end
  endtask
  
  /****************************************************************/
  task ram_dump;                      // modif
    input [19:0] start_adr;
    input [19:0] words;
    input [80:1] file_name;
    reg [31:0]   i;
    reg [127:0]  ram_reg;
    integer      dump_file;
    
    begin
      dump_file = $fopen(file_name);
      for(i=start_adr;i<(start_adr+words*4);i=i+4) begin
        ram_reg = {U0.U_DDR3.mem[{start_adr[19:0]+3, 2'b0}],
                   U0.U_DDR3.mem[{start_adr[19:0]+2, 2'b0}],
                   U0.U_DDR3.mem[{start_adr[19:0]+1, 2'b0}],
                   U0.U_DDR3.mem[{start_adr[19:0], 2'b0}]};
        $fdisplay(dump_file,"addr= %h data= %h",i,ram_reg);
      end
      $fclose(dump_file);
    end
  endtask


  /****************************************************************/
  task ram_fill;                      // modif
    input [19:0] start_adr;
    input [19:0] words;
    input [31:0] data;
    reg [31:0]   i;
    
    
    begin
      for(i=start_adr;i<(start_adr+words*4);i=i+1) begin
        U0.U_DDR3.mem[{start_adr[19:0], 2'b0}] = data;
      end
    end
    
  endtask
  
  
  /****************************************************************/
  task wide_fill;                      // modif
    input [17:0]  start_adr;
    input [17:0]  words;
    input [128:0] data;
    reg [31:0]    i, j;
    reg [127:0]   temp_0, temp_1, temp_2, temp_3;
    
    begin
      for (i=start_adr;i<(start_adr+words);i=i+4) begin
        for (j = 0; j < 4; j = j + 1) begin
          U0.U_DDR3.mem[{start_adr[17:0], 2'b0}]   = data[31:0];
          U0.U_DDR3.mem[{start_adr[17:0]+1, 2'b0}] = data[63:32];
          U0.U_DDR3.mem[{start_adr[17:0]+2, 2'b0}] = data[95:64];
          U0.U_DDR3.mem[{start_adr[17:0]+3, 2'b0}] = data[127:96];
        end
      end // for (i=start_adr;i<(start_adr+words);i=i+1)
    end
  endtask

endmodule

