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
//  Title       :  MC write enable generation
//  File        :  de3d_tc_mc_we.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This module is used to generate the write enable for each RAM.      
//  One of these is instatiated for each RAM and should be placed next  
//  to that RAM.    
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
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

/************************************************************************/
/************************************************************************/
module de3d_tc_mc_we
	(
	input		mclock,		// Memory controller clock		*/
	input		rstn,
	input		tex_push_en,	// Memory controller push enable.	*/
	input		ram_sel,	// Which ram to write first.   		*/

	output reg	ram_wen_lo,	// write enable for RAM. 		*/
	output reg	ram_wen_hi	// write enable for RAM. 		*/
	);

reg 	cs;

always @(posedge mclock, negedge rstn) begin
	if(!rstn) cs <= 1'b0;
	else begin
	case(cs)
		1'b0: 	if(tex_push_en) cs <= 1'b1;
		 	else cs = 1'b0;

		1'b1: 	if(tex_push_en) cs <= 1'b0;
		 	else cs = 1'b1;

	endcase
	end
end

always @* ram_wen_lo = tex_push_en & ((~cs & ~ram_sel) | ( cs & ram_sel));
always @* ram_wen_hi = tex_push_en & (( cs & ~ram_sel) | (~cs & ram_sel));

endmodule
