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
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  the TAG portion is the actual tag storage of the cache.     
//  outputs are always available for reading, however the inputs
//  are latched when de_clk is low, and the load signal is high 
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

/****************************************************************/
/****************************************************************/

module de3d_read_addr_in
	(
	// Inputs
	input		de_clk,		// drawing engine clock
	input	[2:0]	bpt,		// bits per texel.       
	input	[14:0]	ul_tag_adr_rd,	// Upper left tag address.
	input	[14:0]	ll_tag_adr_rd,	// Lower left tag address.
	input	[14:0]	ur_tag_adr_rd,	// Upper right tag address.
	input	[14:0]	lr_tag_adr_rd,	// Lower right tag address.
	// Outputs
	output reg	[4:0]	ee_tag_adr_rd,
	output reg	[4:0]	eo_tag_adr_rd,
	output reg	[4:0]	oe_tag_adr_rd,
	output reg	[4:0]	oo_tag_adr_rd
	);

// Registers
reg	[6:0]	ul_tag_adr_bpt;
reg	[6:0]	ll_tag_adr_bpt;
reg	[6:0]	ur_tag_adr_bpt;
reg	[6:0]	lr_tag_adr_bpt;

reg	[14:0]	ul_tag_adr;	/* Upper left tag address.	*/
reg	[14:0]	ll_tag_adr;	/* Lower left tag address.	*/
reg	[14:0]	ur_tag_adr;	/* Upper right tag address.	*/
reg	[14:0]	lr_tag_adr;	/* Lower right tag address.	*/


//
// xx_tag_adr = {u[8:3],v[8:0]}
//               [14:9], [8:0] 
//
always @* begin
	case(bpt)
	3'b011:	// 8 bits per texel.
		begin
			ul_tag_adr_bpt = {ul_tag_adr_rd[5:1],ul_tag_adr_rd[11]};
			ll_tag_adr_bpt = {ll_tag_adr_rd[5:1],ll_tag_adr_rd[11]};
			ur_tag_adr_bpt = {ur_tag_adr_rd[5:1],ur_tag_adr_rd[11]};
			lr_tag_adr_bpt = {lr_tag_adr_rd[5:1],lr_tag_adr_rd[11]};
		end
	3'b100:	// 16 bits per texel.
		begin
			ul_tag_adr_bpt = {ul_tag_adr_rd[4:1],ul_tag_adr_rd[11:10]};
			ll_tag_adr_bpt = {ll_tag_adr_rd[4:1],ll_tag_adr_rd[11:10]};
			ur_tag_adr_bpt = {ur_tag_adr_rd[4:1],ur_tag_adr_rd[11:10]};
			lr_tag_adr_bpt = {lr_tag_adr_rd[4:1],lr_tag_adr_rd[11:10]};
		end
	default: // 32 bits per texel.
		begin
			ul_tag_adr_bpt = {ul_tag_adr_rd[3:1],ul_tag_adr_rd[11:9]};
			ll_tag_adr_bpt = {ll_tag_adr_rd[3:1],ll_tag_adr_rd[11:9]};
			ur_tag_adr_bpt = {ur_tag_adr_rd[3:1],ur_tag_adr_rd[11:9]};
			lr_tag_adr_bpt = {lr_tag_adr_rd[3:1],lr_tag_adr_rd[11:9]};
		end
	endcase
	end

always @(posedge de_clk) begin
  		casex ({ul_tag_adr_bpt[0],ul_tag_adr[0],ur_tag_adr_bpt[0]})
    		3'b01x:
			begin
				 ee_tag_adr_rd <= ll_tag_adr_bpt[5:1];
				 oe_tag_adr_rd <= lr_tag_adr_bpt[5:1];
				 eo_tag_adr_rd <= ul_tag_adr_bpt[5:1];
				 oo_tag_adr_rd <= ur_tag_adr_bpt[5:1];
			end
    		3'b10x:
			begin
				 ee_tag_adr_rd <= ur_tag_adr_bpt[5:1];
				 oe_tag_adr_rd <= ul_tag_adr_bpt[5:1];
				 eo_tag_adr_rd <= lr_tag_adr_bpt[5:1];
				 oo_tag_adr_rd <= ll_tag_adr_bpt[5:1];
			end
    		3'b11x:
			begin
				 ee_tag_adr_rd <= lr_tag_adr_bpt[5:1];
				 oe_tag_adr_rd <= ll_tag_adr_bpt[5:1];
				 eo_tag_adr_rd <= ur_tag_adr_bpt[5:1];
				 oo_tag_adr_rd <= ul_tag_adr_bpt[5:1];
			end
    		default:
			begin
				 ee_tag_adr_rd = ul_tag_adr_bpt[5:1];
				 oe_tag_adr_rd = ur_tag_adr_bpt[5:1];
				 eo_tag_adr_rd = ll_tag_adr_bpt[5:1];
				 oo_tag_adr_rd = lr_tag_adr_bpt[5:1];
			end
  		endcase
	end

endmodule



