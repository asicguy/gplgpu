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

//////////////////////////////////////////////////////////////////
// Float to fixed converts floating point numbers to 16.16 sign
//
//
module flt_fx_23p9
	(
	input	[31:0]	fp_in,         // Floating point in IEEE fmt
	output reg [31:0] int_out      // Fixed point integer out
	);
//
//  23.9, UV.
//
wire    [7:0]   bias_exp;       /* Real exponent -127 - 128     */
wire    [7:0]   bias_exp2;      /* Real exponent 2's comp       */
wire    [39:0]  fixed_out2;     /* 2's complement of fixed out  */
wire    [47:0]  bias_mant;      /* mantissa expanded to 16.16 fmt */
reg     [47:0]  int_fixed_out;

reg    [31:0]  fixed_out;

assign bias_mant = {25'h0001, fp_in[22:0]};
assign bias_exp = fp_in[30:23] - 'd127;
assign bias_exp2 = ~bias_exp + 1;

// infinity or NaN - Don't do anything special, will overflow
always @* begin
	// zero condition
  	if (fp_in[30:0] == 31'b0) int_fixed_out = 0;
  	// negative exponent
	else if (bias_exp[7]) int_fixed_out = bias_mant >> bias_exp2;
  	// positive exponent
	else int_fixed_out = bias_mant << bias_exp;

	fixed_out = int_fixed_out[45:14];
	int_out = (fp_in[31]) ? ~fixed_out + 1 : fixed_out;
end

endmodule



