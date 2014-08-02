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
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps

module gen_pipe_1
	#(
	parameter PIPE_WIDTH   = 9'd32,
		  PIPE_DEPTH   = 5'd4
	)
	(
	input				clk,
	input	[PIPE_WIDTH -1 :0]	din,
	output	[PIPE_WIDTH -1 :0]	dout_1,
	output	[PIPE_WIDTH -1 :0]	dout
	);

	reg	[PIPE_WIDTH - 1:0]	pipe_reg [PIPE_DEPTH - 1:0];
	reg	[9:0]	n;



	always @(posedge clk) begin
		for(n=(PIPE_DEPTH[9:0] - 10'h1); n!=10'h0; n=n-10'h1)
			pipe_reg[n] <= pipe_reg[n-1];
		pipe_reg[0] <= din;;
	end

	assign dout = pipe_reg[PIPE_DEPTH - 1];
	assign dout_1 = pipe_reg[PIPE_DEPTH - 2];

endmodule
