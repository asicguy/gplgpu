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
//  Author      :  Frank Bruno
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

`timescale 1 ps / 1 ps

module de3d_tc_mem_if_out
  (
   input		de_clk,		// Drawing engine clock	
   input [8:0]	        store_x,	// Address of data to be selected
   input [8:0]	        store_y,	// Address of data to be selected
   input [31:0]	        din0,		// output data from Ram's
   input [31:0]	        din1,		// output data from Ram's
   input [31:0]	        din2,		// output data from Ram's
   input [31:0]	        din3,		// output data from Ram's
   input [31:0]	        din4,		// output data from Ram's
   input [31:0]	        din5,		// output data from Ram's
   input [31:0]	        din6,		// output data from Ram's
   input [31:0]	        din7,		// output data from Ram's
   input [31:0]         pal_lookup,     // Data from palette lookup
   input   [2:0]	bpt,		// Texel format	
   input   [4:0]	tfmt,		// Texel format
   input                pal_mode,       // palettized mode
   input		exact,
   input		clamp_ovd,	// Clamp override to final pixel
   input		ccs_dd,		// Clamp color selector	
   input	[31:0]	boarder_color_dd,// The boarder color we may clamp to
   input		tex_en,		// Texture Enable.
   
   output reg		exact_out,
   output reg	[31:0]	dout,	// data back to real world
   output reg [7:0] pal_addr
   );

reg	[31:0]	mem_interp;	/* mux data to one signal		*/
reg	[31:0]	mem_interp_d;	/* mux data to one signal		*/
reg	[31:0]	mem_interp_dd;	/* mux data to one signal		*/
reg	[31:0]	mem_interp_ddd;	/* mux data to one signal		*/
reg     [2:0]   lookup_addr;
reg	[2:0]	bpt_d, bpt_dd, bpt_ddd;
reg	[4:0]	tfmt_d, tfmt_dd, tfmt_ddd;
reg	[4:0]	store_x_d, store_x_dd, store_x_ddd;
  reg		clamp_ovd_d;
  reg		clamp_ovd_dd;
  reg 		clamp_ovd_ddd;
reg	[31:0]	dout_int;
reg		exact_d, exact_dd;
  reg 		pal_mode_d, pal_mode_dd, pal_mode_ddd;
  reg 		ccs_ddd;
  reg 		sel16_d, sel16_dd, sel16_ddd;
  reg 		bit_select_ddd;
  
  wire [15:0] 	sixteen;	/* result of get sixteen function	*/
  wire 		one_dd;	/* result of get_four function		*/
  wire [1:0] 	two_dd;	/* result of get_four function		*/
  wire [3:0] 	four_dd;	/* result of get_four function		*/
  wire [7:0] 	eight_dd;	/* result of get_four function		*/

  wire [3:0] 	four_ddd;	/* result of get_four function		*/
  wire [7:0] 	eight_ddd;	/* result of get eight function		*/
  wire [15:0] 	sixteen_ddd;	/* result of get sixteen function	*/
  
  parameter BPT_1 = 3'h0,
	      BPT_2 = 3'h1,
	      BPT_4 = 3'h2,
	      BPT_8 = 3'h3,
	      BPT_16 = 3'h4,
	      BPT_32 = 3'h5;

  always @(posedge de_clk) begin
    case (bpt) /* synopsys parallel_case */
      3'h0: lookup_addr <= {(store_y[0] ^ store_x[7]), store_x[6:5]};
      3'h1: lookup_addr <= {(store_y[0] ^ store_x[6]), store_x[5:4]};
      3'h2: lookup_addr <= {(store_y[0] ^ store_x[5]), store_x[4:3]};
      3'h3: lookup_addr <= {(store_y[0] ^ store_x[4]), store_x[3:2]};
      3'h4: lookup_addr <= {(store_y[0] ^ store_x[3]), store_x[2:1]};
      3'h5: lookup_addr <= {(store_y[0] ^ store_x[2]), store_x[1:0]};
      default: lookup_addr <= 0;
    endcase
  end
  
  always @* begin
    case (lookup_addr) /* synopsys parallel_case full_case */
      3'b000: mem_interp = din0;
      3'b001: mem_interp = din1;
      3'b010: mem_interp = din2;
      3'b011: mem_interp = din3;
      3'b100: mem_interp = din4;
      3'b101: mem_interp = din5;
      3'b110: mem_interp = din6;
      3'b111: mem_interp = din7;
    endcase
  end

  /************************************************************************/
  /* Pipelining								*/
  /************************************************************************/
  always @(posedge de_clk) begin
    // mem_interp_dd <= mem_interp_d;
    mem_interp_dd <= mem_interp;
    mem_interp_ddd<= mem_interp_dd;
    
    bpt_d 	  <= bpt;
    tfmt_d        <= tfmt;
    pal_mode_d    <= pal_mode;
    store_x_d     <= store_x[4:0];
    clamp_ovd_d   <= clamp_ovd;
    exact_d       <= exact;
    sel16_d       <= ~((tfmt == 6'h03) || (tfmt == 6'h07) || (tfmt == 6'h0B) ||
		       (tfmt == 6'h1D) || (tfmt == 6'h3E) || (tfmt == 6'h3F));

    store_x_dd    <= store_x_d;
    bpt_dd        <= bpt_d;
    tfmt_dd       <= tfmt_d;
    pal_mode_dd   <= pal_mode_d;
    exact_dd      <= exact_d;
    clamp_ovd_dd  <= clamp_ovd_d;
    sel16_dd      <= sel16_d;

    store_x_ddd    <= store_x_dd;
    bpt_ddd        <= bpt_dd;
    tfmt_ddd       <= tfmt_dd;
    pal_mode_ddd   <= pal_mode_dd;
    exact_out      <= exact_dd;
    clamp_ovd_ddd  <= clamp_ovd_dd;
    bit_select_ddd <= pal_addr[0];
    sel16_ddd      <= sel16_dd;
    ccs_ddd        <= ccs_dd;
    
  end

  assign one_dd		=	get_one(store_x_dd[4:0],mem_interp_dd);
  assign two_dd		=	get_two(store_x_dd[3:0],mem_interp_dd);
  assign four_dd	=	get_four(store_x_dd[2:0],mem_interp_dd);
  assign eight_dd	= 	get_eight(store_x_dd[1:0],mem_interp_dd);

  assign four_ddd	=	get_four(store_x_ddd[2:0],mem_interp_ddd);
  assign eight_ddd	= 	get_eight(store_x_ddd[1:0],mem_interp_ddd);
  assign sixteen_ddd 	=	get_sixteen(store_x_ddd[0],mem_interp_ddd);

  always @*
    case (bpt_dd)
      BPT_1:   pal_addr = one_dd >> sel16_dd;
      BPT_2:   pal_addr = two_dd >> sel16_dd;
      BPT_4:   pal_addr = four_dd >> sel16_dd;
      default: pal_addr = eight_dd >> sel16_dd;
    endcase // case (bpt_dd)
    
  always @* begin
    if (pal_mode_ddd) begin
      if (sel16_ddd) begin
	case (tfmt_ddd)
	  5'b00000: dout_int = format1555(pal_lookup[16*bit_select_ddd+:16]);	// 16bpt	1555
	  5'b00001: dout_int = format0565(pal_lookup[16*bit_select_ddd+:16]);	// 16bpt	0565
	  5'b00010: dout_int = format4444(pal_lookup[16*bit_select_ddd+:16]);	// 16bpt	4444
	  default:  dout_int = format8332(pal_lookup[16*bit_select_ddd+:16]);	// 16bpt	8332
	endcase // case (tfmt_ddd)
      end else 
	dout_int = pal_lookup;
    end else begin
  
      casex ({bpt_ddd,tfmt_ddd}) /* synopsys parallel_case */
	// Non-palette modes
	8'bxxx_00000: dout_int = format1555(sixteen_ddd);				// 16bpt	1555
	8'b011_00101: dout_int = format1232(eight_ddd);					// 8bpt		1232
	8'b011_00110: dout_int = format0332(eight_ddd);					// 8bpt		0332
	8'b100_00000: dout_int = format1555(sixteen_ddd);				// 16bpt	1555
	8'b100_00001: dout_int = format0565(sixteen_ddd);				// 16bpt	0565
	8'b100_00010: dout_int = format4444(sixteen_ddd);				// 16bpt	4444
	8'b100_00100: dout_int = format8332(sixteen_ddd);				// 16bpt	8332
	8'bxxx_00111: dout_int = {{2{four_ddd}}, 24'h0};					// ALPHA4
	8'bxxx_01000: dout_int = {eight_ddd, 24'h0};					// ALPHA8
	8'bxxx_01001: dout_int = {8'hFF, {6{four_ddd}}};					// Luminance4
	8'bxxx_01010: dout_int = {8'hFF, {3{eight_ddd}}};				// Luminance8
	8'bxxx_01011: dout_int = {{2{eight_ddd[7:4]}},{6{eight_ddd[3:0]}}}; 		// Lum4 Alpha4
	8'bxxx_01100: dout_int = {{4{eight_ddd[7:6]}},{3{eight_ddd[5:0],eight_ddd[5:4]}}}; // Lum6_alpha2
	8'bxxx_01101: dout_int = {sixteen_ddd[15:8], {3{sixteen_ddd[7:0]}}}; 		// Lum8_alpha8
	8'bxxx_01110: dout_int = {8{four_ddd}};						// Intensity 4
	8'bxxx_01111: dout_int = {4{eight_ddd}};						// Intensity 8
	8'bxxx_10000: dout_int = {{4{eight_ddd[7:6]}}, {4{eight_ddd[5:4]}},		// RGBA2
				  {4{eight_ddd[3:2]}}, {4{eight_ddd[1:0]}}};
	
	default: dout_int = mem_interp_ddd;						// 32bpt	8888
      endcase
    end
  end // always @ *
  
always @* begin
  casex ({tex_en, clamp_ovd_ddd,ccs_ddd}) /* synopsys full_case parallel_case */
    3'b0xx: dout = 32'h0;		// No texture.
    3'b10x: dout = dout_int;		// No clamping
    3'b110: dout = dout_int;		// Clamp to last pixel, is UL
    3'b111: dout = boarder_color_dd;	// Clamp to boarder color
  endcase
end

/* get four returns the four bit index from 4 bit palette mode	*/
function	[3:0]	get_four;
  input	[2:0]	nibble_select;
  input	[31:0]	mem_in;

  begin
    case (nibble_select) /* synopsys parallel_case full_case */
      3'b000:	get_four = mem_in[3:0];
      3'b001: 	get_four = mem_in[7:4];
      3'b010:   get_four = mem_in[11:8];
      3'b011:   get_four = mem_in[15:12];	
      3'b100:	get_four = mem_in[19:16];
      3'b101: 	get_four = mem_in[23:20];
      3'b110:   get_four = mem_in[27:24];
      3'b111:   get_four = mem_in[31:28];	
    endcase
  end
endfunction

/* get one returns the one bit index from 4 bit palette mode	*/
function	get_one;
  input	[4:0]	nibble_select;
  input	[31:0]	mem_in;

  begin
    get_one = mem_in[nibble_select];
  end
endfunction

/* get two returns the four bit index from 4 bit palette mode	*/
function	[1:0]	get_two;
  input	[3:0]	nibble_select;
  input	[31:0]	mem_in;

  begin
    get_two = mem_in[2*nibble_select+:2];
  end
endfunction

/* get eight returns the 8 bit color value from 8bpp mode	*/
function 	[7:0]	get_eight;
  input	[1:0]	byte_select;
  input	[31:0]	mem_in;

  begin
    case (byte_select) /* synopsys parallel_case full_case */
      2'b00:	get_eight = mem_in[7:0];
      2'b01:  	get_eight = mem_in[15:8];
      2'b10:	get_eight = mem_in[23:16];
      2'b11:	get_eight = mem_in[31:24];
    endcase
  end
endfunction

/* get sixteen returns the 16 bit color value from 16bpp mode	*/
function	[15:0]	get_sixteen;
  input		word_select;
  input	[31:0]	mem_in;

  begin
    case (word_select) /* synopsys parallel_case full_case */
      1'b0: 	get_sixteen = mem_in[15:0];
      1'b1: 	get_sixteen = mem_in[31:16];
    endcase
  end
endfunction

/* format1555 formats incoming 16 bit data to 1555 mode	*/
function	[31:0]	format1555;
  input	[15:0]	data;
  begin
    format1555=	{{8{data[15]}},			// Alpha
		data[14:10],data[14:12],	// Red
		data[9:5],data[9:7],		// Green
		data[4:0],data[4:2]};		// Blue
  end
endfunction

/* format0565 formats incoming 16 bit data to 0565 mode	*/
function	[31:0]	format0565;
  input	[15:0]	data;
  begin
    format0565= {8'hFF,				// Alpha
		data[15:11],data[15:13],	// Red
		data[10:5],data[10:9],		// Green
		data[4:0],data[4:2]};		// Blue
  end
endfunction

/* format1232 formats incoming 8 bit data to 1232 mode	*/
function	[31:0]	format1232;
  input	[7:0]	data;
  begin
    format1232=	{{8{data[7]}},			// Alpha
		{4{data[6:5]}},			// Red
		{2{data[4:2]}},data[4:3],	// Green	
		{4{data[1:0]}}};		// Blue
  end
endfunction

/* format0332 formats incoming 8 bit data to 0332 mode	*/
function	[31:0]	format0332;
  input	[7:0]	data;
  begin
    format0332= {8'hFF,				// Alpha
		{2{data[7:5]}},data[7:6],	// Red
		{2{data[4:2]}},data[4:3],	// Green
		{4{data[1:0]}}};		// Blue
  end
endfunction

/* format8332 formats incoming 16 bit data to 8332 mode	*/
function	[31:0]	format8332;
  input	[15:0]	data;
  begin
    format8332= {data[15:8],			// Alpha
		{2{data[7:5]}},data[7:6],	// Red
		{2{data[4:2]}},data[4:3],	// Green
		{4{data[1:0]}}};		// Blue
  end
endfunction

/* format4444 formats incoming 16 bit data to 4444 mode	*/
function	[31:0]	format4444;
  input	[15:0]	data;
  begin
    format4444=	{{2{data[15:12]}},		// Alpha
		{2{data[11:8]}},		// Red
		{2{data[7:4]}},			// Green
		{2{data[3:0]}}};		// Blue
  end
endfunction
endmodule
