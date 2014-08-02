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
//  File        :  de3d_tc_tag_set.v
//  Author      :  Frank Bruno
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

module de3d_tc_tag_set
	(
	// Inputs
	input		de_clk,		/* drawing engine clock		*/
	input		de_rstn,	/* drawing engine reset		*/
	input		ee_s0_hit,	/* load even, even set s0	*/
	input		ee_s1_hit,	/* load even, even set s1	*/
	input		eo_s0_hit,	/* load even, odd set s0	*/
	input		eo_s1_hit,	/* load even, odd set s1	*/
	input		oe_s0_hit,	/* load odd, even set s0	*/
	input		oe_s1_hit,	/* load odd, even set s1	*/
	input		oo_s0_hit,	/* load odd, odd set s0		*/
	input		oo_s1_hit,	/* load odd, odd set s1		*/
	input	[4:0]	ee_tag_adr_wr,	/* set bit address even, even.	*/
	input	[4:0]	eo_tag_adr_wr,	/* set bit address even, odd.	*/
	input	[4:0]	oe_tag_adr_wr,	/* set bit address odd, even.	*/
	input	[4:0]	oo_tag_adr_wr,	/* set bit address odd, odd.	*/
	input	[4:0]	ee_tag_adr_rd,	/* set bit address even, even.	*/
	input	[4:0]	eo_tag_adr_rd,	/* set bit address even, odd.	*/
	input	[4:0]	oe_tag_adr_rd,	/* set bit address odd, even.	*/
	input	[4:0]	oo_tag_adr_rd,	/* set bit address odd, odd.	*/
	// Outputs
	output		ee_lru,		/* set bit for even, even. 	*/
	output		eo_lru,		/* set bit for even, odd. 	*/
	output		oe_lru,		/* set bit for odd, even.	*/
	output		oo_lru		/* set bit for odd, odd.	*/
	);

/* Registers ****************************************************/

reg	[31:0]	ee_set_reg;	/* set bit for (even, even)	*/
reg	[31:0]	eo_set_reg;	/* set bit for (even, odd) 	*/
reg	[31:0]	oe_set_reg;	/* set bit for (odd, even)	*/
reg	[31:0]	oo_set_reg;	/* set bit for (odd, odd)	*/

assign ee_lru = ee_set_reg[ee_tag_adr_rd];
assign eo_lru = eo_set_reg[eo_tag_adr_rd];
assign oe_lru = oe_set_reg[oe_tag_adr_rd];
assign oo_lru = oo_set_reg[oo_tag_adr_rd];

wire	[31:0]	sel_ee;
wire	[31:0]	sel_eo;
wire	[31:0]	sel_oe;
wire	[31:0]	sel_oo;

assign sel_ee = 32'b1 << (ee_tag_adr_wr);
assign sel_eo = 32'b1 << (eo_tag_adr_wr);
assign sel_oe = 32'b1 << (oe_tag_adr_wr);
assign sel_oo = 32'b1 << (oo_tag_adr_wr);


always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)ee_set_reg <= 0;
		else if(ee_s0_hit)ee_set_reg <= ee_set_reg | sel_ee;
		else if(ee_s1_hit)ee_set_reg <= ee_set_reg & ~sel_ee;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eo_set_reg <= 0;
		else if(eo_s0_hit)eo_set_reg <= eo_set_reg | sel_eo;
		else if(eo_s1_hit)eo_set_reg <= eo_set_reg & ~sel_eo;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oe_set_reg <= 0;
		else if(oe_s0_hit)oe_set_reg <= oe_set_reg | sel_oe;
		else if(oe_s1_hit)oe_set_reg <= oe_set_reg & ~sel_oe;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oo_set_reg <= 0;
		else if(oo_s0_hit)oo_set_reg <= oo_set_reg | sel_oo;
		else if(oo_s1_hit)oo_set_reg <= oo_set_reg & ~sel_oo;
	end

endmodule



