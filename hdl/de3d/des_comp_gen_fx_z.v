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

module des_comp_gen_fx
	(
	input		clk,
	input		rstn,
	input 	[23:0]	dx_fx,		// 16.8
	input 	[23:0]	dy_fx,		// 16.8
	input	[95:0]	cmp_i,

	output reg signed	[31:0]	curr_i
	);

wire 	[31:0]	sp_fx;
wire 	[31:0]	idx_fx;
wire 	[31:0]	idy_fx;

reg [63:0]	ix;
reg [63:0]	iy;
reg [25:0]	ixy;

flt_fx	u0_flt_fx(cmp_i[95:64], sp_fx);		// flt -> 16.16.
flt_fx	u1_flt_fx(cmp_i[63:32], idx_fx); 	// flt -> 16.16.
flt_fx	u2_flt_fx(cmp_i[31:0],  idy_fx); 	// flt -> 16.16.

always @(posedge clk) begin
	ix        <= {dx_fx, 8'h0} * idx_fx;	// 16.16 * 16.16 = 32.32
	iy        <= {dy_fx, 8'h0} * idy_fx;	// 16.16 * 16.16 = 32.16
	ixy       <= iy[31:8] + ix[31:8];	// 16.8 + 16.8 = 17.8
	curr_i    <= ixy[24:0] + sp_fx[31:8];	// 16.8 * 16.8 = 32.16
end

wire [47:0] ix_test = ~ix + 1;
wire [47:0] iy_test = ~iy + 1;
wire [47:0] ixy_test = ~ixy + 1;
wire [47:0] curr_i_test = ~curr_i + 1;

endmodule
