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
//  Created     :  01-Dec-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
//  Float to Fixed Point Conversion for U and V
//  Convert Float to 23.9 - 2's complement
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
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 10 ps

module flt_fx_uv
	(
	input 		clk,
	input [31:0]	float,

	output reg [31:0]	fixed_out
	);

  reg [31:0]	fixed;
  wire [30:0]	fixed_pos;
  reg [30:0]	fixed_pos_bar;

  wire [31:0]	fixed_pos_2;
  wire [31:0]	fixed_pos_3;
  wire [8:0]	shift;
  wire		big,tiny;

  wire		cin;
  reg		cin_bar;
  wire		cout;
  reg		neg_ovfl_mask;
  /*
   * Rounding accomplished as follows:
   * b = a + r
   * -b = -(a + r)
   * -b = -a -r
   * -b = ~a +1 -r
   * -b = ~a + (1-r)
   * but 1-r = ~r, when r is one bit, so...
   * -b = ~a + ~r
   */

  /*
   * determine amount to shift mantissa, and if this float fits into 23.9TC
   * note: h7e+h22=h94
   */
  assign	shift = 8'h94 - float[30:23];
  assign	big = shift[8];
  assign	tiny = |(shift[7:5]);

  /*
   * shift the mantissa
   */
  assign {fixed_pos, cin} = lsr32({1'b1, float[22:0],8'b0}, shift[4:0]);

  /*
   * round the result, and convert to two's complement
   */
  always @(fixed_pos or cin or big or tiny or float) begin
    cin_bar = ~cin;
    fixed_pos_bar = ~fixed_pos;
    casex ({float[31],big,tiny}) /* synopsys full_case parallel_case */
      3'b000: begin // positive, in range
	fixed = fixed_pos + cin;
	if (fixed[31])
	  fixed = 32'h7fffffff;
      end // case: 3'b000
      3'b100: begin // negative, in range
	fixed = fixed_pos_bar + cin_bar;
	fixed[31] = ~fixed[31];
      end // case: 3'b100
      3'b01x: // positive big
	fixed = 32'h7fffffff;
      3'b11x: // negative big
	fixed = 32'h80000000;
      3'bxx1: // tiny
	fixed = 32'h0;
    endcase // casex ({float[31],big,tiny})
  end // always @ (fixed_pos or cin or big or tiny or float)

  always @(posedge clk) fixed_out <= fixed;

  function [31:0] lsr32;
  // shift a 32-bit input vector to the right, by 0 to 31 places.
  // fill in zeros's from the left
    input [31:0] a;
    input [4:0]	 s;
    reg [4:0]	 s1;
    reg [31:0]	 a1;
    reg [31:0]	 a2;
    reg [31:0]	 a4;
    reg [31:0]	 a8;
    reg [31:0]	 a16;
  begin

    if (s[0])
      a1 = {1'b0, a[31:1]};
    else
      a1 = a;

    if (s[1])
      a2 = {{2{1'b0}}, a1[31:2]};
    else
      a2 = a1;

    if (s[2])
      a4 = {{4{1'b0}}, a2[31:4]};
    else
      a4 = a2;

    if (s[3])
      a8 = {{8{1'b0}}, a4[31:8]};
    else
      a8 = a4;

    if (s[4])
      a16 = {{16{1'b0}}, a8[31:16]};
    else
      a16 = a8;

    lsr32 = a16;
    
  end
  endfunction // lsr32

endmodule // DED_FL_FX_UV
