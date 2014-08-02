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
//  Title       :  Float to int converter.
//  File        :  flt2int.v
//  Author      :  Jim MacLeod
//  Created     :  31-Dec-2012
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
//  
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

`timescale 1 ps / 1 ps

module flt2int
  (
   input 	     clk,
   input [31:0]      afl,
   output reg [15:0] fx_int
   );

  reg [14:0] 	     int_out;

  always @* begin
    if(afl[30:23] == 8'h7f) int_out = 16'h1;		// 1
    else begin
      casex(afl[30:23])
	8'b0xxx_xxxx: int_out = 15'h0;			// 0
	8'b1000_0000: int_out = {14'h1, afl[22]};	// 2 - 3
	8'b1000_0001: int_out = {13'h1, afl[22:21]};	// 4 - 7
	8'b1000_0010: int_out = {12'h1, afl[22:20]};	// 8 - 15
	8'b1000_0011: int_out = {11'h1, afl[22:19]};	// 16 - 31
	8'b1000_0100: int_out = {10'h1, afl[22:18]};	// 32 - 63
	8'b1000_0101: int_out =  {9'h1, afl[22:17]};	// 64 - 127
	8'b1000_0110: int_out =  {8'h1, afl[22:16]};	// 128 - 255
	8'b1000_0111: int_out =  {7'h1, afl[22:15]};	// 256 - 511
	8'b1000_1000: int_out =  {6'h1, afl[22:14]};	// 512 - 1023
	8'b1000_1001: int_out =  {5'h1, afl[22:13]};	// 1024 - 2047
	8'b1000_1010: int_out =  {4'h1, afl[22:12]};	// 2048 - 4095
	8'b1000_1011: int_out =  {3'h1, afl[22:11]};	// 4096 - 8191
	8'b1000_1100: int_out =  {2'h1, afl[22:10]};	// 8192 - 16383
	8'b1000_1101: int_out =  {1'h1, afl[22: 9]};	// 16384 - 32767
	default:      int_out = 15'h7fff;		// Overflow
      endcase
    end
  end
  
  
  always @(posedge clk) begin
    if(afl[31]) fx_int <= ~int_out + 16'h1;
    else        fx_int <=  {1'b0, int_out};
  end
  
endmodule
