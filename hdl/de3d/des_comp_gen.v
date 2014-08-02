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
//  File        :  des_comp_gen.v
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
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module des_comp_gen
	(
	input		clk,
	input		rstn,
	input	[31:0]	dx_fx,		// 16.16
	input	[31:0]	dy_fx,		// 16.16
	input	[95:0]	cmp_i,

	output	[31:0]	curr_i
	);


wire	[31:0]	ix;
wire	[31:0]	iy;
wire	[31:0]	ixy;

flt_fx1616_mult u_flt_fx_mult_dx
	(
	.clk		(clk),
	.rstn		(rstn),
	.fx		(dx_fx),
	.bfl		(cmp_i[63:32]),
	.fl		(ix)
	);

flt_fx1616_mult u_flt_fx_mult_dy
	(
	.clk		(clk),
	.rstn		(rstn),
	.fx		(dy_fx),
	.bfl		(cmp_i[31:0]),
	.fl		(iy)
	);

flt_add_sub u_flt_add_subf_xy
	(
	.clk		(clk),
	.sub		(1'b0),
	.afl		(ix),
	.bfl		(iy),
	.fl		(ixy)
	);

flt_add_sub u_flt_add_subf_curr
	(
	.clk		(clk),
	.sub		(1'b0),
	.afl		(cmp_i[95:64]),
	.bfl		(ixy),
	.fl		(curr_i)
	);

endmodule
