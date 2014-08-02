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
//  Title       :  Texture Clamp
//  File        :  de3d_tc_clamp.v
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

`timescale 1 ps / 1 ps

module de3d_tc_clamp
	(
	input		de_clk,		// DE clock.
	input		clamp_x,	/* Clamp in X direction			*/
	input		clamp_y,	/* Clamp in Y direction			*/
	input	[10:0]	x,		/* X coordinate				*/
	input	[10:0]	y,		/* Y coordinate				*/
	input	[10:0]	clamp_mask_x,	/* clamping mask in X			*/
	input	[10:0]	clamp_mask_y,	/* clamping mask in Y			*/
	input	[8:0]	bitmask_x,	/* bitmask for X			*/
	input	[8:0]	bitmask_y,	/* bitmask for Y			*/

	output reg		clamp,		/* Clamping signal for texel		*/
	output reg	[8:0]	new_x,		/* X coordinate out			*/
	output reg	[8:0]	new_y,		/* Y coordinate out			*/
	output reg	[8:0]	new_x_d,	/* X coordinate out			*/
	output reg	[8:0]	new_y_d		/* Y coordinate out			*/
	);

reg		clamp_d;

wire		outside_x,	/* outside of the X extent of texture	*/
		outside_y;	/* outside of the Y extent of texture	*/

// The upper left texel is outside if the bits not masked are set
assign outside_x = |(x & clamp_mask_x);
assign outside_y = |(y & clamp_mask_y);

always @(posedge de_clk) begin
	clamp <= clamp_d;
	clamp_d <= outside_x & clamp_x | outside_y & clamp_y;
	new_x <= new_x_d;
	new_y <= new_y_d;
end

always @(posedge de_clk) begin
  casex ({clamp_x, outside_x, x[10]}) /*synopsys full_case parallel_case */
    3'b0xx,3'b10x: 	new_x_d <= x[8:0] & bitmask_x; 	// straight through
    3'b110: 		new_x_d <= bitmask_x;		// outside, positive
    3'b111: 		new_x_d <= 0;			// Neg, outsid
  endcase
end

always @(posedge de_clk) begin
  casex ({clamp_y, outside_y, y[10]}) /*synopsys full_case parallel_case */
    3'b0xx, 3'b10x: 	new_y_d <= y[8:0] & bitmask_y; 	// straight through
    3'b110: 		new_y_d <= bitmask_y;		// outside, positive
    3'b111: 		new_y_d <= 0;			// Neg, outsid
  endcase
end

endmodule
