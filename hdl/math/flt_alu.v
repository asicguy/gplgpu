
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

module flt_alu
	(
	input		clk,
	input		rstn,
	input	[64:0]	sum_0,
	input	[64:0]	sum_1,
	input	[64:0]	sum_2,
	input	[64:0]	sum_3,
	input	[128:0]	det,
	input	[63:0]	div,

	output	[31:0]	s0_s,
	output	[31:0]	s1_s,
	output	[31:0]	s2_s,
	output	[31:0]	s3_s,
	output	[31:0]	det_s,
	output	[31:0]	div_result,
	output	[31:0]	int0_s,
	output	[31:0]	int1_s
	);

/////////////////////////////////////////////////////////////////////
//                    FLOAT ALU
//
// Float Subtracts (Three Clock Cycles).
flt_add_sub u0_flt_add_sub(clk, sum_0[64], sum_0[63:32], sum_0[31:0], s0_s);
flt_add_sub u1_flt_add_sub(clk, sum_1[64], sum_1[63:32], sum_1[31:0], s1_s);
flt_add_sub u2_flt_add_sub(clk, sum_2[64], sum_2[63:32], sum_2[31:0], s2_s);
flt_add_sub u3_flt_add_sub(clk, sum_3[64], sum_3[63:32], sum_3[31:0], s3_s);
// Float Determinant(Six Clock Cycles).
flt_det u0_flt_det(clk, rstn, det, det_s);
// Float Divide (Seven Clock Cycles).
flt_div u0_flt_div(.clk(clk), .rstn(rstn), .numer_denom(div), .div_result(div_result));
// Float INT (Two Clock Cycles).
flt_int u0_flt_int(clk, s0_s, int0_s);
flt_int u1_flt_int(clk, s1_s, int1_s);

endmodule
