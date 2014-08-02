
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

module flt_det
	(
	input		clk,
	input		rstn,
	input [128:0]	data_in,

	output [31:0]	det_fp
	);

wire [31:0] m0_s_fp;
wire [31:0] m1_s_fp;
reg [2:0]   sub_pipe;

always @(posedge clk, negedge rstn)
	if(!rstn) sub_pipe <= 3'b000;
	else sub_pipe <= {sub_pipe[1:0], data_in[128]};

flt_mult u0_flt_mult(clk, rstn, data_in[127:96], data_in[95:64], m0_s_fp);

flt_mult u1_flt_mult(clk, rstn, data_in[63:32],  data_in[31:0],  m1_s_fp);

flt_add_sub u4_flt_add_sub(clk, sub_pipe[2], m0_s_fp, m1_s_fp, det_fp);

endmodule

