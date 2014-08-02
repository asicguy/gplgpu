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
//  Title       :  Tag RAM
//  File        :  de3d_tc_tag_ram.v
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

module de3d_tc_tag_ram
	(
	// Inputs 
	input		de_clk,		/* DE clock.	*/
	input		de_rstn,	/* DE reset.	*/
	input	[3:0]	cur_mipmap,	/* Current mipmap level		*/
	input		ee_s0_loadn,	/* Load even, even, set 0 RAM.	*/
	input		ee_s1_loadn,	/* Load even, even , set 1 RAM.	*/
	input		eo_s0_loadn,	/* Load even, odd, set 0 RAM.	*/
	input		eo_s1_loadn,	/* Load even, odd, set 1 RAM.	*/
	input		oe_s0_loadn,	/* Load odd, even, set 0 RAM.	*/
	input		oe_s1_loadn,	/* Load odd, even, set 1 RAM.	*/
	input		oo_s0_loadn,	/* Load odd, odd, set 0 RAM.	*/
	input		oo_s1_loadn,	/* Load odd, odd, set 1 RAM.	*/
	input	[4:0]	ee_tag_adr_rd,	/* Address for even, even RAM.	*/
	input	[4:0]	eo_tag_adr_rd,	/* Address for even, odd RAM.	*/
	input	[4:0]	oe_tag_adr_rd,	/* Address for odd, even RAM.	*/
	input	[4:0]	oo_tag_adr_rd,	/* Address for odd, odd RAM.	*/
	input	[4:0]	ee_tag_adr_wr,	/* Address for even, even RAM.	*/
	input	[4:0]	eo_tag_adr_wr,	/* Address for even, odd RAM.	*/
	input	[4:0]	oe_tag_adr_wr,	/* Address for odd, even RAM.	*/
	input	[4:0]	oo_tag_adr_wr,	/* Address for odd, odd RAM.	*/
	input	[7:0]	ee_tag_dat_in,	/* Data in for even, even RAM.	*/
	input	[7:0]	eo_tag_dat_in,	/* Data in for even, odd RAM.	*/
	input	[7:0]	oe_tag_dat_in,	/* Data in for odd, even RAM.	*/
	input	[7:0]	oo_tag_dat_in,	/* Data in for odd, odd RAM.	*/
	input	     	tag_ram_csn,	/* Enable Tag RAM for read or write.	*/
	// Outputs
	output 	[23:0]	ee_tag_dat_out,	/* Data out for even, even RAM.	*/
	output 	[23:0]	eo_tag_dat_out,	/* Data out for even, odd RAM.	*/
	output 	[23:0]	oe_tag_dat_out,	/* Data out for odd, even RAM.	*/
	output 	[23:0]	oo_tag_dat_out	/* Data out for odd, odd RAM.	*/
	);

// reg	[11:0]	ram_ee_0	[0:31];
// reg	[11:0]	ram_ee_1	[0:31];
// reg	[11:0]	ram_eo_0	[0:31];
// reg	[11:0]	ram_eo_1	[0:31];
// reg	[11:0]	ram_oe_0	[0:31];
// reg	[11:0]	ram_oe_1	[0:31];
// reg	[11:0]	ram_oo_0	[0:31];
// reg	[11:0]	ram_oo_1	[0:31];

/*
`ifdef RTL_SIM
	reg [5:0]	clear_count;
	initial begin
		for(clear_count = 0; clear_count < 32; clear_count = clear_count + 1) begin
			ram_ee_0[clear_count] = 12'h0;
			ram_ee_1[clear_count] = 12'h0;
			ram_eo_0[clear_count] = 12'h0;
			ram_eo_1[clear_count] = 12'h0;
			ram_oe_0[clear_count] = 12'h0;
			ram_oe_1[clear_count] = 12'h0;
			ram_oo_0[clear_count] = 12'h0;
			ram_oo_1[clear_count] = 12'h0;
		end
	end
`endif
*/

// Set 0.
// always @(posedge de_clk) if(!ee_s0_loadn & !tag_ram_csn) ram_ee_0[ee_tag_adr] <= {cur_mipmap,ee_tag_dat_in};
// always @* ee_tag_dat_out[11:0] = ram_ee_0[ee_tag_adr];
// Set 1.
// always @(posedge de_clk) if(!ee_s1_loadn & !tag_ram_csn) ram_ee_1[ee_tag_adr] <= {cur_mipmap,ee_tag_dat_in};
// always @* ee_tag_dat_out[23:12] = ram_ee_1[ee_tag_adr];
// Set 0, 1.
ram_tag s0_s1_ee_tag
	(
	.de_clk		(de_clk),
	.de_rstn	(de_rstn),
	.tag_s0_loadn	(ee_s0_loadn),
	.tag_s1_loadn	(ee_s1_loadn),
	.tag_ram_csn	(tag_ram_csn),
	.tag_adr_wr	(ee_tag_adr_wr),
	.tag_adr_rd	(ee_tag_adr_rd),
	.tag_dat_in	({cur_mipmap, ee_tag_dat_in}),
	.tag_dat_out	(ee_tag_dat_out)
	);


// Set 0.
// always @(posedge de_clk) if(!eo_s0_loadn & !tag_ram_csn) ram_eo_0[eo_tag_adr] <= {cur_mipmap,eo_tag_dat_in};
// always @* eo_tag_dat_out[11:0] = ram_eo_0[ee_tag_adr];
// Set 1.
// always @(posedge de_clk) if(!eo_s1_loadn & !tag_ram_csn) ram_eo_1[eo_tag_adr] <= {cur_mipmap,eo_tag_dat_in};
// always @* eo_tag_dat_out[23:12] = ram_eo_1[eo_tag_adr];
// Set 0, 1.
ram_tag s0_s1_eo_tag
	(
	.de_clk		(de_clk),
	.de_rstn	(de_rstn),
	.tag_s0_loadn	(eo_s0_loadn),
	.tag_s1_loadn	(eo_s1_loadn),
	.tag_ram_csn	(tag_ram_csn),
	.tag_adr_wr	(eo_tag_adr_wr),
	.tag_adr_rd	(eo_tag_adr_rd),
	.tag_dat_in	({cur_mipmap, eo_tag_dat_in}),
	.tag_dat_out	(eo_tag_dat_out)
	);


// Set 0.
// always @(posedge de_clk) if(!oe_s0_loadn & !tag_ram_csn) ram_oe_0[oe_tag_adr] <= {cur_mipmap,oe_tag_dat_in};
// always @* oe_tag_dat_out[11:0] = ram_oe_0[oe_tag_adr];
// Set 1.
// always @(posedge de_clk) if(!oe_s1_loadn & !tag_ram_csn) ram_oe_1[oe_tag_adr] <= {cur_mipmap,oe_tag_dat_in};
// always @* oe_tag_dat_out[23:12] = ram_oe_1[oe_tag_adr];
ram_tag s0_s1_oe_tag
	(
	.de_clk		(de_clk),
	.de_rstn	(de_rstn),
	.tag_s0_loadn	(oe_s0_loadn),
	.tag_s1_loadn	(oe_s1_loadn),
	.tag_ram_csn	(tag_ram_csn),
	.tag_adr_wr	(oe_tag_adr_wr),
	.tag_adr_rd	(oe_tag_adr_rd),
	.tag_dat_in	({cur_mipmap, oe_tag_dat_in}),
	.tag_dat_out	(oe_tag_dat_out)
	);



// Set 0.
// always @(posedge de_clk) if(!oo_s0_loadn & !tag_ram_csn) ram_oo_0[oo_tag_adr] <= {cur_mipmap,oo_tag_dat_in};
// always @* oo_tag_dat_out[11:0] = ram_oo_0[oo_tag_adr];
// Set 1.
// always @(posedge de_clk) if(!oo_s1_loadn & !tag_ram_csn) ram_oo_1[oo_tag_adr] <= {cur_mipmap,oo_tag_dat_in};
// always @* oo_tag_dat_out[23:12] = ram_oo_1[oo_tag_adr];
ram_tag s0_s1_oo_tag
	(
	.de_clk		(de_clk),
	.de_rstn	(de_rstn),
	.tag_s0_loadn	(oo_s0_loadn),
	.tag_s1_loadn	(oo_s1_loadn),
	.tag_ram_csn	(tag_ram_csn),
	.tag_adr_wr	(oo_tag_adr_wr),
	.tag_adr_rd	(oo_tag_adr_rd),
	.tag_dat_in	({cur_mipmap, oo_tag_dat_in}),
	.tag_dat_out	(oo_tag_dat_out)
	);

endmodule

module ram_tag
	(
	input	de_clk,
	input	de_rstn,
	input	tag_s0_loadn,
	input	tag_s1_loadn,
	input	tag_ram_csn,
	input	[4:0]	tag_adr_wr,
	input	[4:0]	tag_adr_rd,
	input	[11:0]	tag_dat_in,

	output reg	[23:0]	tag_dat_out
	);

reg	[11:0]	ram_tag0_s0;	
reg	[11:0]	ram_tag1_s0;	
reg	[11:0]	ram_tag2_s0;	
reg	[11:0]	ram_tag3_s0;	
reg	[11:0]	ram_tag4_s0;	
reg	[11:0]	ram_tag5_s0;	
reg	[11:0]	ram_tag6_s0;	
reg	[11:0]	ram_tag7_s0;	
reg	[11:0]	ram_tag8_s0;	
reg	[11:0]	ram_tag9_s0;	
reg	[11:0]	ram_tag10_s0;	
reg	[11:0]	ram_tag11_s0;	
reg	[11:0]	ram_tag12_s0;	
reg	[11:0]	ram_tag13_s0;	
reg	[11:0]	ram_tag14_s0;	
reg	[11:0]	ram_tag15_s0;	
reg	[11:0]	ram_tag16_s0;	
reg	[11:0]	ram_tag17_s0;	
reg	[11:0]	ram_tag18_s0;	
reg	[11:0]	ram_tag19_s0;	
reg	[11:0]	ram_tag20_s0;	
reg	[11:0]	ram_tag21_s0;	
reg	[11:0]	ram_tag22_s0;	
reg	[11:0]	ram_tag23_s0;	
reg	[11:0]	ram_tag24_s0;	
reg	[11:0]	ram_tag25_s0;	
reg	[11:0]	ram_tag26_s0;	
reg	[11:0]	ram_tag27_s0;	
reg	[11:0]	ram_tag28_s0;	
reg	[11:0]	ram_tag29_s0;	
reg	[11:0]	ram_tag30_s0;	
reg	[11:0]	ram_tag31_s0;	
reg	[11:0]	ram_tag0_s1;	
reg	[11:0]	ram_tag1_s1;	
reg	[11:0]	ram_tag2_s1;	
reg	[11:0]	ram_tag3_s1;	
reg	[11:0]	ram_tag4_s1;	
reg	[11:0]	ram_tag5_s1;	
reg	[11:0]	ram_tag6_s1;	
reg	[11:0]	ram_tag7_s1;	
reg	[11:0]	ram_tag8_s1;	
reg	[11:0]	ram_tag9_s1;	
reg	[11:0]	ram_tag10_s1;	
reg	[11:0]	ram_tag11_s1;	
reg	[11:0]	ram_tag12_s1;	
reg	[11:0]	ram_tag13_s1;	
reg	[11:0]	ram_tag14_s1;	
reg	[11:0]	ram_tag15_s1;	
reg	[11:0]	ram_tag16_s1;	
reg	[11:0]	ram_tag17_s1;	
reg	[11:0]	ram_tag18_s1;	
reg	[11:0]	ram_tag19_s1;	
reg	[11:0]	ram_tag20_s1;	
reg	[11:0]	ram_tag21_s1;	
reg	[11:0]	ram_tag22_s1;	
reg	[11:0]	ram_tag23_s1;	
reg	[11:0]	ram_tag24_s1;	
reg	[11:0]	ram_tag25_s1;	
reg	[11:0]	ram_tag26_s1;	
reg	[11:0]	ram_tag27_s1;	
reg	[11:0]	ram_tag28_s1;	
reg	[11:0]	ram_tag29_s1;	
reg	[11:0]	ram_tag30_s1;	
reg	[11:0]	ram_tag31_s1;	

always @(posedge de_clk, negedge de_rstn) begin
	if(!de_rstn) begin
		ram_tag0_s0 <= 12'h0;	
		ram_tag1_s0 <= 12'h0;	
		ram_tag2_s0 <= 12'h0;	
		ram_tag3_s0 <= 12'h0;	
		ram_tag4_s0 <= 12'h0;	
		ram_tag5_s0 <= 12'h0;	
		ram_tag6_s0 <= 12'h0;	
		ram_tag7_s0 <= 12'h0;	
		ram_tag8_s0 <= 12'h0;	
		ram_tag9_s0 <= 12'h0;	
		ram_tag10_s0 <= 12'h0;	
		ram_tag11_s0 <= 12'h0;	
		ram_tag12_s0 <= 12'h0;	
		ram_tag13_s0 <= 12'h0;	
		ram_tag14_s0 <= 12'h0;	
		ram_tag15_s0 <= 12'h0;	
		ram_tag16_s0 <= 12'h0;	
		ram_tag17_s0 <= 12'h0;	
		ram_tag18_s0 <= 12'h0;	
		ram_tag19_s0 <= 12'h0;	
		ram_tag20_s0 <= 12'h0;	
		ram_tag21_s0 <= 12'h0;	
		ram_tag22_s0 <= 12'h0;	
		ram_tag23_s0 <= 12'h0;	
		ram_tag24_s0 <= 12'h0;	
		ram_tag25_s0 <= 12'h0;	
		ram_tag26_s0 <= 12'h0;	
		ram_tag27_s0 <= 12'h0;	
		ram_tag28_s0 <= 12'h0;	
		ram_tag29_s0 <= 12'h0;	
		ram_tag30_s0 <= 12'h0;	
		ram_tag31_s0 <= 12'h0;	
	end
	else if(!tag_s0_loadn & !tag_ram_csn) begin
		case(tag_adr_wr) 
		5'd0:  ram_tag0_s0  <= tag_dat_in;
		5'd1:  ram_tag1_s0  <= tag_dat_in;
		5'd2:  ram_tag2_s0  <= tag_dat_in;
		5'd3:  ram_tag3_s0  <= tag_dat_in;
		5'd4:  ram_tag4_s0  <= tag_dat_in;
		5'd5:  ram_tag5_s0  <= tag_dat_in;
		5'd6:  ram_tag6_s0  <= tag_dat_in;
		5'd7:  ram_tag7_s0  <= tag_dat_in;
		5'd8:  ram_tag8_s0  <= tag_dat_in;
		5'd9:  ram_tag9_s0  <= tag_dat_in;
		5'd10: ram_tag10_s0 <= tag_dat_in;
		5'd11: ram_tag11_s0 <= tag_dat_in;
		5'd12: ram_tag12_s0 <= tag_dat_in;
		5'd13: ram_tag13_s0 <= tag_dat_in;
		5'd14: ram_tag14_s0 <= tag_dat_in;
		5'd15: ram_tag15_s0 <= tag_dat_in;
		5'd16: ram_tag16_s0 <= tag_dat_in;
		5'd17: ram_tag17_s0 <= tag_dat_in;
		5'd18: ram_tag18_s0 <= tag_dat_in;
		5'd19: ram_tag19_s0 <= tag_dat_in;
		5'd20: ram_tag20_s0 <= tag_dat_in;
		5'd21: ram_tag21_s0 <= tag_dat_in;
		5'd22: ram_tag22_s0 <= tag_dat_in;
		5'd23: ram_tag23_s0 <= tag_dat_in;
		5'd24: ram_tag24_s0 <= tag_dat_in;
		5'd25: ram_tag25_s0 <= tag_dat_in;
		5'd26: ram_tag26_s0 <= tag_dat_in;
		5'd27: ram_tag27_s0 <= tag_dat_in;
		5'd28: ram_tag28_s0 <= tag_dat_in;
		5'd29: ram_tag29_s0 <= tag_dat_in;
		5'd30: ram_tag30_s0 <= tag_dat_in;
		5'd31: ram_tag31_s0 <= tag_dat_in;
		endcase
	end
end

always @(posedge de_clk, negedge de_rstn) begin
	if(!de_rstn) begin
		ram_tag0_s1 <= 12'h0;	
		ram_tag1_s1 <= 12'h0;	
		ram_tag2_s1 <= 12'h0;	
		ram_tag3_s1 <= 12'h0;	
		ram_tag4_s1 <= 12'h0;	
		ram_tag5_s1 <= 12'h0;	
		ram_tag6_s1 <= 12'h0;	
		ram_tag7_s1 <= 12'h0;	
		ram_tag8_s1 <= 12'h0;	
		ram_tag9_s1 <= 12'h0;	
		ram_tag10_s1 <= 12'h0;	
		ram_tag11_s1 <= 12'h0;	
		ram_tag12_s1 <= 12'h0;	
		ram_tag13_s1 <= 12'h0;	
		ram_tag14_s1 <= 12'h0;	
		ram_tag15_s1 <= 12'h0;	
		ram_tag16_s1 <= 12'h0;	
		ram_tag17_s1 <= 12'h0;	
		ram_tag18_s1 <= 12'h0;	
		ram_tag19_s1 <= 12'h0;	
		ram_tag20_s1 <= 12'h0;	
		ram_tag21_s1 <= 12'h0;	
		ram_tag22_s1 <= 12'h0;	
		ram_tag23_s1 <= 12'h0;	
		ram_tag24_s1 <= 12'h0;	
		ram_tag25_s1 <= 12'h0;	
		ram_tag26_s1 <= 12'h0;	
		ram_tag27_s1 <= 12'h0;	
		ram_tag28_s1 <= 12'h0;	
		ram_tag29_s1 <= 12'h0;	
		ram_tag30_s1 <= 12'h0;	
		ram_tag31_s1 <= 12'h0;	
	end
	else if(!tag_s1_loadn & !tag_ram_csn) begin
		case(tag_adr_wr) 
		5'd0:  ram_tag0_s1  <= tag_dat_in;
		5'd1:  ram_tag1_s1  <= tag_dat_in;
		5'd2:  ram_tag2_s1  <= tag_dat_in;
		5'd3:  ram_tag3_s1  <= tag_dat_in;
		5'd4:  ram_tag4_s1  <= tag_dat_in;
		5'd5:  ram_tag5_s1  <= tag_dat_in;
		5'd6:  ram_tag6_s1  <= tag_dat_in;
		5'd7:  ram_tag7_s1  <= tag_dat_in;
		5'd8:  ram_tag8_s1  <= tag_dat_in;
		5'd9:  ram_tag9_s1  <= tag_dat_in;
		5'd10: ram_tag10_s1 <= tag_dat_in;
		5'd11: ram_tag11_s1 <= tag_dat_in;
		5'd12: ram_tag12_s1 <= tag_dat_in;
		5'd13: ram_tag13_s1 <= tag_dat_in;
		5'd14: ram_tag14_s1 <= tag_dat_in;
		5'd15: ram_tag15_s1 <= tag_dat_in;
		5'd16: ram_tag16_s1 <= tag_dat_in;
		5'd17: ram_tag17_s1 <= tag_dat_in;
		5'd18: ram_tag18_s1 <= tag_dat_in;
		5'd19: ram_tag19_s1 <= tag_dat_in;
		5'd20: ram_tag20_s1 <= tag_dat_in;
		5'd21: ram_tag21_s1 <= tag_dat_in;
		5'd22: ram_tag22_s1 <= tag_dat_in;
		5'd23: ram_tag23_s1 <= tag_dat_in;
		5'd24: ram_tag24_s1 <= tag_dat_in;
		5'd25: ram_tag25_s1 <= tag_dat_in;
		5'd26: ram_tag26_s1 <= tag_dat_in;
		5'd27: ram_tag27_s1 <= tag_dat_in;
		5'd28: ram_tag28_s1 <= tag_dat_in;
		5'd29: ram_tag29_s1 <= tag_dat_in;
		5'd30: ram_tag30_s1 <= tag_dat_in;
		5'd31: ram_tag31_s1 <= tag_dat_in;
		endcase
	end
end

	always @* begin
		case(tag_adr_rd)
		5'd0: tag_dat_out  = {ram_tag0_s1, ram_tag0_s0};
		5'd1: tag_dat_out  = {ram_tag1_s1, ram_tag1_s0};
		5'd2: tag_dat_out  = {ram_tag2_s1, ram_tag2_s0};
		5'd3: tag_dat_out  = {ram_tag3_s1, ram_tag3_s0};
		5'd4: tag_dat_out  = {ram_tag4_s1, ram_tag4_s0};
		5'd5: tag_dat_out  = {ram_tag5_s1, ram_tag5_s0};
		5'd6: tag_dat_out  = {ram_tag6_s1, ram_tag6_s0};
		5'd7: tag_dat_out  = {ram_tag7_s1, ram_tag7_s0};
		5'd8: tag_dat_out  = {ram_tag8_s1, ram_tag8_s0};
		5'd9: tag_dat_out  = {ram_tag9_s1, ram_tag9_s0};
		5'd10: tag_dat_out = {ram_tag10_s1, ram_tag10_s0};
		5'd11: tag_dat_out = {ram_tag11_s1, ram_tag11_s0};
		5'd12: tag_dat_out = {ram_tag12_s1, ram_tag12_s0};
		5'd13: tag_dat_out = {ram_tag13_s1, ram_tag13_s0};
		5'd14: tag_dat_out = {ram_tag14_s1, ram_tag14_s0};
		5'd15: tag_dat_out = {ram_tag15_s1, ram_tag15_s0};
		5'd16: tag_dat_out = {ram_tag16_s1, ram_tag16_s0};
		5'd17: tag_dat_out = {ram_tag17_s1, ram_tag17_s0};
		5'd18: tag_dat_out = {ram_tag18_s1, ram_tag18_s0};
		5'd19: tag_dat_out = {ram_tag19_s1, ram_tag19_s0};
		5'd20: tag_dat_out = {ram_tag20_s1, ram_tag20_s0};
		5'd21: tag_dat_out = {ram_tag21_s1, ram_tag21_s0};
		5'd22: tag_dat_out = {ram_tag22_s1, ram_tag22_s0};
		5'd23: tag_dat_out = {ram_tag23_s1, ram_tag23_s0};
		5'd24: tag_dat_out = {ram_tag24_s1, ram_tag24_s0};
		5'd25: tag_dat_out = {ram_tag25_s1, ram_tag25_s0};
		5'd26: tag_dat_out = {ram_tag26_s1, ram_tag26_s0};
		5'd27: tag_dat_out = {ram_tag27_s1, ram_tag27_s0};
		5'd28: tag_dat_out = {ram_tag28_s1, ram_tag28_s0};
		5'd29: tag_dat_out = {ram_tag29_s1, ram_tag29_s0};
		5'd30: tag_dat_out = {ram_tag30_s1, ram_tag30_s0};
		5'd31: tag_dat_out = {ram_tag31_s1, ram_tag31_s0};
	endcase
	end

	endmodule



