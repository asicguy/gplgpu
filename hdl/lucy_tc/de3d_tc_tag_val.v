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
//  Title       :  Tag Valid
//  File        :  de3d_tc_tag_val.v
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

module de3d_tc_tag_val
	(
	// Inputs
	input		de_clk,		/* drawing engine clock		*/
	input		de_rstn,	/* drawing engine reset		*/
	input		invalidate,	/* Invalidate cache.   		*/
	input		ee_s0_loadn,	/* load even, even valid	*/
	input		ee_s1_loadn,	/* load even, even valid	*/
	input		eo_s0_loadn,	/* load even, odd valid		*/
	input		eo_s1_loadn,	/* load even, odd valid		*/
	input		oe_s0_loadn,	/* load odd, even valid		*/
	input		oe_s1_loadn,	/* load odd, even valid		*/
	input		oo_s0_loadn,	/* load odd, odd valid		*/
	input		oo_s1_loadn,	/* load odd, odd valid		*/
	input	[4:0]	ee_tag_adr_wr,	/* val bit address even, even.	*/
	input	[4:0]	eo_tag_adr_wr,	/* val bit address even, odd.	*/
	input	[4:0]	oe_tag_adr_wr,	/* val bit address odd, even.	*/
	input	[4:0]	oo_tag_adr_wr,	/* val bit address odd, odd.	*/
	input	[4:0]	ee_tag_adr_rd,	/* val bit address even, even.	*/
	input	[4:0]	eo_tag_adr_rd,	/* val bit address even, odd.	*/
	input	[4:0]	oe_tag_adr_rd,	/* val bit address odd, even.	*/
	input	[4:0]	oo_tag_adr_rd,	/* val bit address odd, odd.	*/
	// Outputs
	output	[1:0]	ee_val,		/* valid bit for even, even. 	*/
	output	[1:0]	eo_val,		/* valid bit for even, odd. 	*/
	output	[1:0]	oe_val,		/* valid bit for odd, even.	*/
	output	[1:0]	oo_val		/* valid bit for odd, odd.	*/
	);

/* Registers ****************************************************/
reg	[31:0]	ee_val_s0_reg;	/* valid bit for (even, even),s0*/
reg	[31:0]	ee_val_s1_reg;	/* valid bit for (even, even),s1*/
reg	[31:0]	eo_val_s0_reg;	/* valid bit for (even, odd),s0 */
reg	[31:0]	eo_val_s1_reg;	/* valid bit for (even, odd),s1 */
reg	[31:0]	oe_val_s0_reg;	/* valid bit for (odd, even),s0	*/
reg	[31:0]	oe_val_s1_reg;	/* valid bit for (odd, even),s1	*/
reg	[31:0]	oo_val_s0_reg;	/* valid bit for (odd, odd),s0	*/
reg	[31:0]	oo_val_s1_reg;	/* valid bit for (odd, odd),s1	*/

assign ee_val[0] = ee_val_s0_reg[ee_tag_adr_rd];
assign ee_val[1] = ee_val_s1_reg[ee_tag_adr_rd];
assign eo_val[0] = eo_val_s0_reg[eo_tag_adr_rd];
assign eo_val[1] = eo_val_s1_reg[eo_tag_adr_rd];
assign oe_val[0] = oe_val_s0_reg[oe_tag_adr_rd];
assign oe_val[1] = oe_val_s1_reg[oe_tag_adr_rd];
assign oo_val[0] = oo_val_s0_reg[oo_tag_adr_rd];
assign oo_val[1] = oo_val_s1_reg[oo_tag_adr_rd];

wire		inv;
assign inv = invalidate;

wire	[31:0]	set_s0_ee;
wire	[31:0]	set_s1_ee;
wire	[31:0]	set_s0_eo;
wire	[31:0]	set_s1_eo;
wire	[31:0]	set_s0_oe;
wire	[31:0]	set_s1_oe;
wire	[31:0]	set_s0_oo;
wire	[31:0]	set_s1_oo;

assign set_s0_ee = {31'b0,~ee_s0_loadn} << (ee_tag_adr_wr & {5{~ee_s0_loadn}});
assign set_s1_ee = {31'b0,~ee_s1_loadn} << (ee_tag_adr_wr & {5{~ee_s1_loadn}});
assign set_s0_eo = {31'b0,~eo_s0_loadn} << (eo_tag_adr_wr & {5{~eo_s0_loadn}});
assign set_s1_eo = {31'b0,~eo_s1_loadn} << (eo_tag_adr_wr & {5{~eo_s1_loadn}});
assign set_s0_oe = {31'b0,~oe_s0_loadn} << (oe_tag_adr_wr & {5{~oe_s0_loadn}});
assign set_s1_oe = {31'b0,~oe_s1_loadn} << (oe_tag_adr_wr & {5{~oe_s1_loadn}});
assign set_s0_oo = {31'b0,~oo_s0_loadn} << (oo_tag_adr_wr & {5{~oo_s0_loadn}});
assign set_s1_oo = {31'b0,~oo_s1_loadn} << (oo_tag_adr_wr & {5{~oo_s1_loadn}});


always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)ee_val_s0_reg <= 0;
		else if(inv)ee_val_s0_reg <= 0;
		else ee_val_s0_reg <= ee_val_s0_reg | set_s0_ee;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)ee_val_s1_reg <= 0;
		else if(inv)ee_val_s1_reg <= 0;
		else ee_val_s1_reg <= ee_val_s1_reg | set_s1_ee;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eo_val_s0_reg <= 0;
		else if(inv)eo_val_s0_reg <= 0;
		else eo_val_s0_reg <= eo_val_s0_reg | set_s0_eo;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eo_val_s1_reg <= 0;
		else if(inv)eo_val_s1_reg <= 0;
		else eo_val_s1_reg <= eo_val_s1_reg | set_s1_eo;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oe_val_s0_reg <= 0;
		else if(inv)oe_val_s0_reg <= 0;
		else oe_val_s0_reg <= oe_val_s0_reg | set_s0_oe;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oe_val_s1_reg <= 0;
		else if(inv)oe_val_s1_reg <= 0;
		else oe_val_s1_reg <= oe_val_s1_reg | set_s1_oe;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oo_val_s0_reg <= 0;
		else if(inv)oo_val_s0_reg <= 0;
		else oo_val_s0_reg <= oo_val_s0_reg | set_s0_oo;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oo_val_s1_reg <= 0;
		else if(inv)oo_val_s1_reg <= 0;
		else oo_val_s1_reg <= oo_val_s1_reg | set_s1_oo;
	end

endmodule



