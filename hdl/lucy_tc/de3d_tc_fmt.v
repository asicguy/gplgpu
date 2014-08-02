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
//  Title       :  TC Format
//  File        :  de3d_tc_fmt.v
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

`timescale 1 ps / 1 ps 

module de3d_tc_fmt
	(
	input		de_clk,
	input	[5:0]	tsize,	// Texture map format:	000000 1bpt 1555, pal16_no32, pal_fmt = X
                                //                      000001 1bpt 0565, pal16_no32, pal_fmt = X
				//                      000010 1bpt 4444, pal16_no32, pal_fmt = X
				// 			000011 1bpt 8888, filt_8888,  pal_fmt = X
                                //                      000100 2bpt 1555, pal16_no32, pal_fmt = X
				//                      000101 2bpt 0565, pal16_no32, pal_fmt = X
				//                      000110 2bpt 4444, pal16_no32, pal_fmt = X
				// 			000111 2bpt 8888, filt_8888,  pal_fmt = X 
				//                      001000 4bpt 1555, pal16_no32, pal_fmt = X
				//                      001001 4bpt 0565, pal16_no32, pal_fmt = X
				//                      001010 4bpt 4444, pal16_no32, pal_fmt = X
				// 			001011 4bpt 8888, filt_8888,  pal_fmt = X
				//                      001100 8bpt 1232
				//                      001101 8bpt 0332
				// 			001110 8bpt 1555, pal16_no32, pal_fmt = X
				// 			001111 8bpt 0565, pal16_no32, pal_fmt = X
				// 			011100 8bpt 4444, pal16_no32, pal_fmt = X
				// 			011101 8bpt 8888 (exact), pal8_exact, pal_fmt = X
				// 			111110 8bpt 8888 (16-4444), cvt_4444, pal_fmt = X
				// 			111111 8bpt 8888 (16-0565), cvt_0565, pal_fmt = X
				//			011110 8bpt 8332, pal16_no32, pal_fmt = X
				//                      010000 16bpt 4444
				//                      010001 16bpt 1555
				//                      010010 16bpt 0565
				//			010011 16bpt 8332
				//                      010100 32bpt 8888*
				//                      011000 1bpt 8332, pal16_no32, pal_fmt = X
				//			011001 2bpt 8332, pal16_no32, pal_fmt = X
				//			011010 4bpt 8332, pal16_no32, pal_fmt = X
				// OpenGL modes		100000 Alpha4 
				//			100001 Alpha8
				//			100100 Luminance4
				//			100101 Luminance8
				//			101000 Luminance4_alpha4
				//			101001 Luminance6_alpha2
				//			101010 Luminance8_alpha8
				//			101100 Intensity4
				//			101101 Intensity8
				//			110000 RGBA2

	output reg  	[2:0]   bpt,            // bits per texel: 	0	=1
				// 			1	=2
				//			2	=4
				//			3	=8
				//			4	=16
				//			5	=32
	output reg	[4:0]	tfmt,		// format of texture:	0	=1555
				//			1	=0565
				//			2	=4444
				//			3	=8888
				//			4	=8332
				//			5	=1232
				//			6	=0332
				// See below for OPENGL formats	
	 output                 pal_mode   // palette mode
	/*
	output	[2:0]		pal_fmt;	// 0 = 8888 exact
						// 1 = 4444 conversion, filtered
						// 2 = 0565 conversion, filtered
						// 3 = 16bpt filtered
						// 4 = 8888 filtered
	output  [2:0]   	load_count; 	// coutner for palette loading
	output	[2:0]		page_count;
	*/
	);


parameter	ONE		=	3'h0,
		TWO		=	3'h1,
		FOUR		=	3'h2,
		EIGHT		=	3'h3,
		SIXTEEN		=	3'h4,
		THIRTY_TWO	=	3'h5,
		//
		FMT_1555	=	5'd0,
		FMT_0565	=	5'd1,
		FMT_4444	=	5'd2,
		FMT_8888	=	5'd3,
		FMT_8332	=	5'd4,
		FMT_1232	=	5'd5,
		FMT_0332	=	5'd6,
 		ALPHA4		=	5'd7,
		ALPHA8		=	5'd8,
		LUM4		=	5'd9,
		LUM8		=	5'd10,
		LUM4_ALPHA4	=	5'd11,
		LUM6_ALPHA2	=	5'd12,
		LUM8_ALPHA8	=	5'd13,
		INT4		=	5'd14,
		INT8		=	5'd15,
		RGBA2		=	5'd16;

/*************************************************************/
/* Bits per texel selector				     */
/*************************************************************/
always @(posedge de_clk) begin
  casex (tsize) /* synopsys parallel_case */
    6'b000000, 6'b000001, 6'b000010, 6'b000011, 
    6'b011000:					bpt = ONE;
    6'b000100, 6'b000101, 6'b000110, 6'b000111,
    6'b011001:					bpt = TWO;
    6'b100000, 6'b100100, 6'b101100, 6'b001000,
    6'b001001, 6'b001010, 6'b001011, 6'b011010:	bpt = FOUR;
    6'b100001, 6'b100101, 6'b101000, 6'b101001,
    6'b101101, 6'b110000, 6'b001100, 6'b001101,
    6'b001110, 6'b001111, 6'b011100, 6'b011101,
    6'b111110, 6'b111111, 6'b011110: 		bpt = EIGHT;
    6'b101010, 6'b010000, 6'b010001, 6'b010010,
    6'b010011:					bpt = SIXTEEN;
    default: bpt = THIRTY_TWO;
  endcase
end

/*************************************************************/
/* Texel Format Selector				     */
/*************************************************************/
always @(posedge de_clk) begin
  casex (tsize) /* synopsys parallel_case */
    6'b000000, 6'b000100, 6'b001000, 6'b001110, 
    6'b010001: 					tfmt = FMT_1555;
    6'b000001, 6'b000101, 6'b001001, 6'b001111, 
    6'b010010:           			tfmt = FMT_0565;
    6'b000010, 6'b000110, 6'b001010, 6'b011100, 
    6'b010000: 			                tfmt = FMT_4444;
    6'b000011, 6'b000111, 6'b001011, 6'b011101, 
    6'b010100, 6'b111110, 6'b111111:   		tfmt = FMT_8888;
    6'b011110, 6'b010011, 6'b011000, 6'b011001, 
    6'b011010:					tfmt = FMT_8332;
    6'b001100:					tfmt = FMT_1232;
    6'b001101:					tfmt = FMT_0332;
    6'b100000:					tfmt = ALPHA4;
    6'b100001:					tfmt = ALPHA8;
    6'b100100:					tfmt = LUM4;
    6'b100101:					tfmt = LUM8;
    6'b101000:					tfmt = LUM4_ALPHA4;
    6'b101001:					tfmt = LUM6_ALPHA2;
    6'b101010:					tfmt = LUM8_ALPHA8;
    6'b101100:					tfmt = INT4;
    6'b101101:					tfmt = INT8;
    default:					tfmt = RGBA2;
  endcase
end

/*
wire            pal16_no32;     // 16 bit palette mode w/o 32->16
wire            cvt_4444;       // convert incoming 32 bit palette to 4444
wire            cvt_0565;       // convert incoming 32 bit palette to 8888
wire		pal8_exact;
wire		filt_8888;

//////////////////////////////////////////////////////////////////////////
// Determine palette number of pages to load and number of iter's 
//                Texture depth					
// pal depth 	\ 	1	2	4	8	
// -------------+----------------------------------------------------
//	16	|	1	1	2	4x8 pgs 
//	32	|	1	1	4	8x8 pgs		
//////////////////////////////////////////////////////////////////////////
always @(tsize) begin
  casex (tsize) // synopsys full_case parallel_case

    // 1 or 2 bpt, only load 1 page of data regardless
    6'b000000, 6'b000001, 6'b000010, 6'b000011, 
    6'b011000, 6'b000100, 6'b000101, 6'b000110, 
    6'b000111, 6'b011001: begin
      load_count = 0;
      page_count = 0;
    end
    // 4 bpt expanded to 16, load 2 pages
    6'b001000, 6'b001001, 6'b001010, 6'b011010: begin
      load_count = 0;
      page_count = 1;
    end
    // 4bpt expanded to 32, load 4 pages
    6'b001011: begin
      load_count = 0;
      page_count = 3;
    end
    // 8 bpt expanded to 16, load 32 pages (4 x 8)
    6'b00111x, 6'b011100, 6'b011110: begin
      load_count = 3;
      page_count = 7;
    end
    // 8 bpt expanded to 32, load 64 pages (8 x 8)
    6'b011101, 6'b111110, 6'b111111: begin
      load_count = 7;
      page_count = 7;
    end
    default: begin
      load_count = 0;
      page_count = 0;
    end
  endcase
end

// Conversion turned on for palette load
assign cvt_4444 = 	(tsize==6'b111110);
assign cvt_0565 = 	(tsize==6'b111111);
assign pal8_exact = 	(tsize==6'b011101);

// Any palette formats which are only 16bpt
assign pal16_no32 = (tsize==6'h0) || (tsize==6'h1) || (tsize==6'h2) || 
		(tsize==6'h4) || (tsize==6'h5) || (tsize==6'h6) ||
		(tsize==6'h8) || (tsize==6'h9) || (tsize==6'ha) || 
		(tsize==6'he) || (tsize==6'hf) || (tsize==6'h1c)||
 		(tsize==6'h1e)|| (tsize==6'h18)|| (tsize==6'h19)||
		(tsize==6'h1a);
assign filt_8888 = (tsize=='h3) || (tsize=='h7) || (tsize=='hb);

always @(pal16_no32 or cvt_4444 or cvt_0565 or pal8_exact or filt_8888) begin
  casex({pal8_exact,cvt_4444,cvt_0565,pal16_no32,filt_8888}) //synopsys full_case parallel_case
    5'b1xxxx: pal_fmt = 0;
    5'b01xxx: pal_fmt = 1;
    5'b001xx: pal_fmt = 2;
    5'b0001x: pal_fmt = 3;
    default:  pal_fmt = 4;
  endcase
end
*/

  assign pal_mode = (tsize == 6'h00) | |(tsize == 6'h01) || (tsize == 6'h02) || (tsize == 6'h03) ||
		    (tsize == 6'h04) | |(tsize == 6'h05) || (tsize == 6'h06) || (tsize == 6'h07) ||
		    (tsize == 6'h08) | |(tsize == 6'h09) || (tsize == 6'h0A) || (tsize == 6'h0B) ||
		    (tsize == 6'h18) | |(tsize == 6'h19) || (tsize == 6'h1A) || (tsize == 6'h0E) ||
		    (tsize == 6'h1A) | |(tsize == 6'h0F) || (tsize == 6'h1C) || (tsize == 6'h1D) ||		  
		    (tsize == 6'h3E) | |(tsize == 6'h3F) || (tsize == 6'h1E);
		    
endmodule
