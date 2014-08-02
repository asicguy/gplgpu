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

module flt_int
	(
	input	      	clk,
	input	[31:0]	afl,
	output reg	[31:0]	fl
	);

reg	[22:0]	mask_1;
reg	[31:0]	afl_1;



always @(posedge clk)
	begin
		afl_1 <= afl;
		casex(afl[30:23]) /* synopsys parallel_case */
		8'b1000_0000:mask_1 <= 23'b10000000000000000000000;
		8'b1000_0001:mask_1 <= 23'b11000000000000000000000;
		8'b1000_0010:mask_1 <= 23'b11100000000000000000000;
		8'b1000_0011:mask_1 <= 23'b11110000000000000000000;
		8'b1000_0100:mask_1 <= 23'b11111000000000000000000;
		8'b1000_0101:mask_1 <= 23'b11111100000000000000000;
		8'b1000_0110:mask_1 <= 23'b11111110000000000000000;
		8'b1000_0111:mask_1 <= 23'b11111111000000000000000;
		8'b1000_1000:mask_1 <= 23'b11111111100000000000000;
		8'b1000_1001:mask_1 <= 23'b11111111110000000000000;
		8'b1000_1010:mask_1 <= 23'b11111111111000000000000;
		8'b1000_1011:mask_1 <= 23'b11111111111100000000000;
		8'b1000_1100:mask_1 <= 23'b11111111111110000000000;
		8'b1000_1101:mask_1 <= 23'b11111111111111000000000;
		8'b1000_1110:mask_1 <= 23'b11111111111111100000000;
		8'b1000_1111:mask_1 <= 23'b11111111111111110000000;
		8'b1001_0000:mask_1 <= 23'b11111111111111111000000;
		8'b1001_0001:mask_1 <= 23'b11111111111111111100000;
		8'b1001_0010:mask_1 <= 23'b11111111111111111110000;
		8'b1001_0011:mask_1 <= 23'b11111111111111111111000;
		8'b1001_0100:mask_1 <= 23'b11111111111111111111100;
		8'b1001_0101:mask_1 <= 23'b11111111111111111111110;
		8'b1001_011x:mask_1 <= 23'b11111111111111111111111;
		8'b101x_xxxx:mask_1 <= 23'b11111111111111111111111;
		8'b11xx_xxxx:mask_1 <= 23'b11111111111111111111111;
		default: mask_1 <= 23'b11111111111111111111111;
		endcase
	end

always @(posedge clk)
	begin
		if(afl_1[30]) fl <= {afl_1[31:23],(mask_1 & afl_1[22:0])};
		else if(&afl_1[29:23]) fl <= {afl_1[31:23],23'h0};
		else fl <= 0;
	end

endmodule
