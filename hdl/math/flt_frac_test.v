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

module flt_frac_test
	(
	input	      	clk,
	input	      	rstn,
	input	[31:0]	afl,
	output reg	frac_flag
	);

	reg [47:0]	mant;
	always @* begin
		if(afl[30]) mant = {1'b1, afl[22:0]} << (afl[30:23] - 127);
		else        mant = {1'b1, afl[22:0]} >> (127 - afl[30:23]);
	end

	always @(posedge clk, negedge rstn) begin
		if(!rstn) frac_flag <= 1'b0;
		else begin
			if(|mant[23:0]) frac_flag <= 1'b1;
			else frac_flag <= 1'b0;
			
			/*
			casex(afl[30:23])
			8'b0111_1011: frac_flag <= 1'b1;	// .0001
			8'b0111_1100: frac_flag <= 1'b1;	// .001x
			8'b0111_1101: frac_flag <= 1'b1;	// .01xx
			8'b0111_1110: frac_flag <= 1'b1;	// .1xxx
			8'b0111_1111: frac_flag <= |afl[22:19];	// 1.xxxx
			8'b1000_0000: frac_flag <= |afl[21:18];	// 1x.xxxx
			8'b1000_0001: frac_flag <= |afl[20:17];	// 1xx.xxxx
			8'b1000_0010: frac_flag <= |afl[19:16]; // 1xxx.xxxx
			8'b1000_0011: frac_flag <= |afl[18:15];
			8'b1000_0100: frac_flag <= |afl[17:14];
			8'b1000_0101: frac_flag <= |afl[16:13];
			8'b1000_0110: frac_flag <= |afl[15:12];
			8'b1000_0111: frac_flag <= |afl[14:11];
			8'b1000_1000: frac_flag <= |afl[13:10];
			8'b1000_1001: frac_flag <= |afl[12:9];
			8'b1000_1010: frac_flag <= |afl[11:8];
			8'b1000_1011: frac_flag <= |afl[10:7];
			8'b1000_1100: frac_flag <= |afl[9:6];
			8'b1000_1101: frac_flag <= |afl[8:5];
			8'b1000_1110: frac_flag <= |afl[7:4];
			8'b1000_1111: frac_flag <= |afl[6:3];
			8'b1001_0000: frac_flag <= |afl[5:2];
			8'b1001_0001: frac_flag <= |afl[4:1];
			8'b1001_0010: frac_flag <= |afl[3:0];
			8'b1001_0011: frac_flag <= |afl[2:0];
			8'b1001_0100: frac_flag <= |afl[1:0];
			8'b1001_0101: frac_flag <= afl[0];
			8'b1001_011x: frac_flag <= 1'b0;
			8'b101x_xxxx: frac_flag <= 1'b0;
			8'b11xx_xxxx: frac_flag <= 1'b0;
			default:      frac_flag <= 1'b0;
			endcase
			*/
		end
	end

endmodule
