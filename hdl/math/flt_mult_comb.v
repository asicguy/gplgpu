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

module flt_mult_comb
	(
	input	    [31:0]	afl,
	input	    [31:0]	bfl,
	output	reg [31:0]	fl
	);

reg	[47:0]	mfl_0;		// Mantisa of the Float
reg		sfl_0;		// Sign of the Float
reg	[7:0]	efl_0;		// Exponent of the Float
reg		zero_out_0;
reg		sfl_1;		// Sign of the Float
reg	[7:0]	efl_1;		// Exponent of the Float
reg		zero_out_1;
reg		mfl47_1;	// Mantisa of the Float
reg	[24:0]	nmfl_1;		// Normalized Mantisa of the Float
reg 		not_mfl_47;

always @* not_mfl_47 = (~mfl47_1 & ~nmfl_1[24]);

always @* begin
		// Pipe 0.
		// Multiply the mantisa.
		mfl_0 = {1'b1,afl[22:0]} * {1'b1,bfl[22:0]};
		// Calulate the Sign.
		sfl_0 = afl[31] ^ bfl[31];
		efl_0 = afl[30:23] + bfl[30:23] - 8'h7E;
		// If a or b equals zero, return zero.
		if((afl[30:0] == 0) || (bfl[30:0] == 0))zero_out_0 <= 1'b1;
		else zero_out_0 <= 1'b0;
		// Pipe 1.
		efl_1 = efl_0;	
		sfl_1 = sfl_0;	
		zero_out_1 = zero_out_0;
		mfl47_1  = mfl_0[47];
		if(mfl_0[47]) nmfl_1 = mfl_0[47:24] + mfl_0[23];
		else 	      nmfl_1 = mfl_0[47:23] + mfl_0[22];
		// Pipe 2.
		if(zero_out_1) fl = 32'h0;
		else 	       fl = {sfl_1,(efl_1 - not_mfl_47),nmfl_1[22:0]};
end


endmodule
