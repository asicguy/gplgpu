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
//  Title       :  Tag
//  File        :  de3d_tc_tag.v
//  Author      :  Jim MacLeod
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

module de3d_tc_tag
	(
	// Inputs
	input		de_clk,		// drawing engine clock
	input		de_rstn,	// drawing engine reset
	input		load_tag,	// load tag	
	input		tag_ads,	// tag address strobe.
	input	[3:0]	tc_op_store,	// texture cache op.	
	input	[2:0]	bpt,		// bits per texel.       
	input	[4:0]	ee_tag_adr_rd,	// Upper left tag address.
	input	[4:0]	eo_tag_adr_rd,	// Lower left tag address.
	input	[4:0]	oe_tag_adr_rd,	// Upper right tag address.
	input	[4:0]	oo_tag_adr_rd,	// Lower right tag address.
	input	[14:0]	ul_tag_adr_rd,	// Upper left tag address.
	input	[14:0]	ll_tag_adr_rd,	// Lower left tag address.
	input	[14:0]	ur_tag_adr_rd,	// Upper right tag address.
	input	[14:0]	lr_tag_adr_rd,	// Lower right tag address.
	input	[14:0]	ul_tag_adr_wr,	// Upper left tag address.
	input	[14:0]	ll_tag_adr_wr,	// Lower left tag address.
	input	[14:0]	ur_tag_adr_wr,	// Upper right tag address.
	input	[14:0]	lr_tag_adr_wr,	// Lower right tag address.
	input		invalidate,	// invalidate cache signal
	input   [3:0]   cur_mipmap,     // Current mip map # 
	input	[3:0]   set_sel,     	// Least recently used.
	input	[7:0]   hit_bus,     	// Hits.              
	input	        tc_fetch,    	// Texture Cache fetch.
	// Outputs
	output	[26:0]	ul_tag,		/* Current tag Upper left  {LRU,VAL1,MM1,TAG1,VAL0,MM0,TAG0} */
	output	[26:0]	ll_tag,		/* Current tag Lower left  {LRU,VAL1,MM1,TAG1,VAL0,MM0,TAG0} */
	output	[26:0]	ur_tag,		/* Current tag Upper right {LRU,VAL1,MM1,TAG1,VAL0,MM0,TAG0} */
	output	[26:0]	lr_tag,		/* Current tag Lower right {LRU,VAL1,MM1,TAG1,VAL0,MM0,TAG0} */
	output		exception	/* Exception Code.        	*/
	);

// Registers
reg	[6:0]	ul_tag_adr_bpt;
reg	[6:0]	ll_tag_adr_bpt;
reg	[6:0]	ur_tag_adr_bpt;
reg	[6:0]	lr_tag_adr_bpt;
reg	[1:0]	ul_val, ll_val, ur_val, lr_val;
reg	[7:0]	ul_tag_dat_bpt;
reg	[7:0]	ll_tag_dat_bpt;
reg	[7:0]	ur_tag_dat_bpt;
reg	[7:0]	lr_tag_dat_bpt;
reg	[4:0]	ee_tag_adr;
reg	[4:0]	eo_tag_adr;
reg	[4:0]	oe_tag_adr;
reg	[4:0]	oo_tag_adr;
reg	[7:0]	ee_tag_dat_in;
reg	[7:0]	eo_tag_dat_in;
reg	[7:0]	oe_tag_dat_in;
reg	[7:0]	oo_tag_dat_in;
reg	[3:0]	load_sel;
reg	[3:0]	lru_sel;

reg	[14:0]	ul_tag_adr;	/* Upper left tag address.	*/
reg	[14:0]	ll_tag_adr;	/* Lower left tag address.	*/
reg	[14:0]	ur_tag_adr;	/* Upper right tag address.	*/
reg	[14:0]	lr_tag_adr;	/* Lower right tag address.	*/

wire		tag_ram_csn = ~(tc_fetch | tag_ads);

always @* begin
		if(tag_ads)ul_tag_adr = ul_tag_adr_wr;
		else ul_tag_adr = ul_tag_adr_rd;
end

always @* begin
		if(tag_ads)ll_tag_adr = ll_tag_adr_wr;
		else ll_tag_adr = ll_tag_adr_rd;
end

always @* begin
		if(tag_ads)ur_tag_adr = ur_tag_adr_wr;
		else ur_tag_adr = ur_tag_adr_rd;
end

always @* begin
		if(tag_ads)lr_tag_adr = lr_tag_adr_wr;
		else lr_tag_adr = lr_tag_adr_rd;
end

wire            inv;            /* invalidate tags of cache     */

wire	[23:0]	ee_tag_dat_out;
wire	[23:0]	eo_tag_dat_out;
wire	[23:0]	oe_tag_dat_out;
wire	[23:0]	oo_tag_dat_out;
wire	[1:0]	ee_val;
wire	[1:0]	eo_val;
wire	[1:0]	oe_val;
wire	[1:0]	oo_val;
wire 		ee_s0_loadn;
wire 		ee_s1_loadn;
wire 		oe_s0_loadn;
wire 		oe_s1_loadn;
wire 		eo_s0_loadn;
wire 		eo_s1_loadn;
wire 		oo_s0_loadn;
wire 		oo_s1_loadn;
wire		tc_op_r_ul;
wire		tc_op_r_ll;
wire		tc_op_r_ur;
wire		tc_op_r_lr;
wire		lru_r_ul;
wire		lru_r_ll;
wire		lru_r_ur;
wire		lru_r_lr;
wire	      	ee_lru;
wire	      	eo_lru;
wire	      	oe_lru;
wire	      	oo_lru;
reg	[23:0]	ul_itag;
reg	[23:0]	ll_itag;
reg	[23:0]	ur_itag;
reg	[23:0]	lr_itag;
reg	      	ul_lru;
reg	      	ll_lru;
reg	      	ur_lru;
reg	      	lr_lru;
reg	[7:0]	hit_sel;

wire		ee_s1_hit = hit_sel[7] | ~ee_s1_loadn;
wire		ee_s0_hit = hit_sel[6] | ~ee_s0_loadn;
wire		oe_s1_hit = hit_sel[5] | ~oe_s1_loadn;
wire		oe_s0_hit = hit_sel[4] | ~oe_s0_loadn;
wire		eo_s1_hit = hit_sel[3] | ~eo_s1_loadn;
wire		eo_s0_hit = hit_sel[2] | ~eo_s0_loadn;
wire		oo_s1_hit = hit_sel[1] | ~oo_s1_loadn;
wire		oo_s0_hit = hit_sel[0] | ~oo_s0_loadn;

assign tc_op_r_ul = tc_op_store[3];
assign tc_op_r_ll = tc_op_store[2];
assign tc_op_r_ur = tc_op_store[1];
assign tc_op_r_lr = tc_op_store[0];

assign lru_r_ul = set_sel[3];
assign lru_r_ll = set_sel[2];
assign lru_r_ur = set_sel[1];
assign lru_r_lr = set_sel[0];

assign ul_tag = {ul_lru,ul_val[1],ul_itag[23:12],ul_val[0],ul_itag[11:0]};
assign ll_tag = {ll_lru,ll_val[1],ll_itag[23:12],ll_val[0],ll_itag[11:0]};
assign ur_tag = {ur_lru,ur_val[1],ur_itag[23:12],ur_val[0],ur_itag[11:0]};
assign lr_tag = {lr_lru,lr_val[1],lr_itag[23:12],lr_val[0],lr_itag[11:0]};
//
// xx_tag_adr = {u[8:3],v[8:0]}
//               [14:9], [8:0] 
//
always @* begin
	case(bpt)
	3'b011:	// 8 bits per texel.
		begin
			ul_tag_adr_bpt = {ul_tag_adr[5:1],ul_tag_adr[11]};
			ll_tag_adr_bpt = {ll_tag_adr[5:1],ll_tag_adr[11]};
			ur_tag_adr_bpt = {ur_tag_adr[5:1],ur_tag_adr[11]};
			lr_tag_adr_bpt = {lr_tag_adr[5:1],lr_tag_adr[11]};
			ul_tag_dat_bpt = {2'b0,ul_tag_adr[8:6],ul_tag_adr[14:12]};
			ll_tag_dat_bpt = {2'b0,ll_tag_adr[8:6],ll_tag_adr[14:12]};
			ur_tag_dat_bpt = {2'b0,ur_tag_adr[8:6],ur_tag_adr[14:12]};
			lr_tag_dat_bpt = {2'b0,lr_tag_adr[8:6],lr_tag_adr[14:12]};
		end
	3'b100:	// 16 bits per texel.
		begin
			ul_tag_adr_bpt = {ul_tag_adr[4:1],ul_tag_adr[11:10]};
			ll_tag_adr_bpt = {ll_tag_adr[4:1],ll_tag_adr[11:10]};
			ur_tag_adr_bpt = {ur_tag_adr[4:1],ur_tag_adr[11:10]};
			lr_tag_adr_bpt = {lr_tag_adr[4:1],lr_tag_adr[11:10]};
			ul_tag_dat_bpt = {1'b0,ul_tag_adr[8:5],ul_tag_adr[14:12]};
			ll_tag_dat_bpt = {1'b0,ll_tag_adr[8:5],ll_tag_adr[14:12]};
			ur_tag_dat_bpt = {1'b0,ur_tag_adr[8:5],ur_tag_adr[14:12]};
			lr_tag_dat_bpt = {1'b0,lr_tag_adr[8:5],lr_tag_adr[14:12]};
		end
	default: // 32 bits per texel.
		begin
			ul_tag_adr_bpt = {ul_tag_adr[3:1],ul_tag_adr[11:9]};
			ll_tag_adr_bpt = {ll_tag_adr[3:1],ll_tag_adr[11:9]};
			ur_tag_adr_bpt = {ur_tag_adr[3:1],ur_tag_adr[11:9]};
			lr_tag_adr_bpt = {lr_tag_adr[3:1],lr_tag_adr[11:9]};
			ul_tag_dat_bpt = {ul_tag_adr[8:4],ul_tag_adr[14:12]};
			ll_tag_dat_bpt = {ll_tag_adr[8:4],ll_tag_adr[14:12]};
			ur_tag_dat_bpt = {ur_tag_adr[8:4],ur_tag_adr[14:12]};
			lr_tag_dat_bpt = {lr_tag_adr[8:4],lr_tag_adr[14:12]};
		end
	endcase
	end

always @* begin
  		casex ({ul_tag_adr_bpt[0],ul_tag_adr[0],ur_tag_adr_bpt[0]})
    		3'b01x:
			begin
				 ee_tag_adr = ll_tag_adr_bpt[5:1];
				 oe_tag_adr = lr_tag_adr_bpt[5:1];
				 eo_tag_adr = ul_tag_adr_bpt[5:1];
				 oo_tag_adr = ur_tag_adr_bpt[5:1];
				 ee_tag_dat_in = ll_tag_dat_bpt;
				 oe_tag_dat_in = lr_tag_dat_bpt;
				 eo_tag_dat_in = ul_tag_dat_bpt;
				 oo_tag_dat_in = ur_tag_dat_bpt;
				 load_sel = {tc_op_r_ll,tc_op_r_lr,tc_op_r_ul,tc_op_r_ur};
				 lru_sel = {lru_r_ll,lru_r_lr,lru_r_ul,lru_r_ur};
				 hit_sel = {hit_bus[5:4],hit_bus[1:0],hit_bus[7:6],hit_bus[3:2]};
				 ll_itag = ee_tag_dat_out;
				 ul_itag = eo_tag_dat_out;
				 lr_itag = oe_tag_dat_out;
				 ur_itag = oo_tag_dat_out;
				 ll_val = ee_val;
				 ul_val = eo_val;
				 lr_val = oe_val;
				 ur_val = oo_val;
				 ll_lru = ee_lru;
				 ul_lru = eo_lru;
				 lr_lru = oe_lru;
				 ur_lru = oo_lru;
			end
    		3'b10x:
			begin
				 ee_tag_adr = ur_tag_adr_bpt[5:1];
				 oe_tag_adr = ul_tag_adr_bpt[5:1];
				 eo_tag_adr = lr_tag_adr_bpt[5:1];
				 oo_tag_adr = ll_tag_adr_bpt[5:1];
				 ee_tag_dat_in = ur_tag_dat_bpt;
				 oe_tag_dat_in = ul_tag_dat_bpt;
				 eo_tag_dat_in = lr_tag_dat_bpt;
				 oo_tag_dat_in = ll_tag_dat_bpt;
				 load_sel = {tc_op_r_ur,tc_op_r_ul,tc_op_r_lr,tc_op_r_ll};
				 lru_sel = {lru_r_ur,lru_r_ul,lru_r_lr,lru_r_ll};
				 hit_sel = {hit_bus[3:2],hit_bus[7:6],hit_bus[1:0],hit_bus[5:4]};
				 ur_itag = ee_tag_dat_out;
				 lr_itag = eo_tag_dat_out;
				 ul_itag = oe_tag_dat_out;
				 ll_itag = oo_tag_dat_out;
				 ur_val = ee_val;
				 lr_val = eo_val;
				 ul_val = oe_val;
				 ll_val = oo_val;
				 ur_lru = ee_lru;
				 lr_lru = eo_lru;
				 ul_lru = oe_lru;
				 ll_lru = oo_lru;
			end
    		3'b11x:
			begin
				 ee_tag_adr = lr_tag_adr_bpt[5:1];
				 oe_tag_adr = ll_tag_adr_bpt[5:1];
				 eo_tag_adr = ur_tag_adr_bpt[5:1];
				 oo_tag_adr = ul_tag_adr_bpt[5:1];
	
				 ee_tag_dat_in = lr_tag_dat_bpt;
				 oe_tag_dat_in = ll_tag_dat_bpt;
				 eo_tag_dat_in = ur_tag_dat_bpt;
				 oo_tag_dat_in = ul_tag_dat_bpt;

				 load_sel = {tc_op_r_lr,tc_op_r_ll,tc_op_r_ur,tc_op_r_ul};
				 lru_sel = {lru_r_lr,lru_r_ll,lru_r_ur,lru_r_ul};
				 hit_sel = {hit_bus[1:0],hit_bus[5:4],hit_bus[3:2],hit_bus[7:6]};

				 lr_itag = ee_tag_dat_out;
				 ur_itag = eo_tag_dat_out;
				 ll_itag = oe_tag_dat_out;
				 ul_itag = oo_tag_dat_out;
				 lr_val = ee_val;
				 ur_val = eo_val;
				 ll_val = oe_val;
				 ul_val = oo_val;
				 lr_lru = ee_lru;
				 ur_lru = eo_lru;
				 ll_lru = oe_lru;
				 ul_lru = oo_lru;
			end
    		default:
			begin
				 ee_tag_adr = ul_tag_adr_bpt[5:1];
				 oe_tag_adr = ur_tag_adr_bpt[5:1];
				 eo_tag_adr = ll_tag_adr_bpt[5:1];
				 oo_tag_adr = lr_tag_adr_bpt[5:1];
				 ee_tag_dat_in = ul_tag_dat_bpt;
				 oe_tag_dat_in = ur_tag_dat_bpt;
				 eo_tag_dat_in = ll_tag_dat_bpt;
				 oo_tag_dat_in = lr_tag_dat_bpt;
				 load_sel = {tc_op_r_ul,tc_op_r_ur,tc_op_r_ll,tc_op_r_lr};
				 lru_sel = {lru_r_ul,lru_r_ur,lru_r_ll,lru_r_lr};
				 hit_sel = {hit_bus[7:6],hit_bus[3:2],hit_bus[5:4],hit_bus[1:0]};
				 ul_itag = ee_tag_dat_out;
				 ll_itag = eo_tag_dat_out;
				 ur_itag = oe_tag_dat_out;
				 lr_itag = oo_tag_dat_out;
				 ul_val = ee_val;
				 ll_val = eo_val;
				 ur_val = oe_val;
				 lr_val = oo_val;
				 ul_lru = ee_lru;
				 ll_lru = eo_lru;
				 ur_lru = oe_lru;
				 lr_lru = oo_lru;
			end
  		endcase
	end

// FIX ME.
//			X 0,1,2		    Y0			X 0,1,2
assign exception = (~ul_tag_adr_bpt[0] & ~ul_tag_adr[0] & ~ur_tag_adr_bpt[0]) |
 		   (~ul_tag_adr_bpt[0] &  ul_tag_adr[0] & ~ur_tag_adr_bpt[0]) |
		   ( ul_tag_adr_bpt[0] & ~ul_tag_adr[0] &  ur_tag_adr_bpt[0]) |
		   ( ul_tag_adr_bpt[0] &  ul_tag_adr[0] &  ur_tag_adr_bpt[0]);

assign ee_s0_loadn = ~(load_sel[3] & load_tag & ~lru_sel[3]);
assign ee_s1_loadn = ~(load_sel[3] & load_tag &  lru_sel[3]);
assign oe_s0_loadn = ~(load_sel[2] & load_tag & ~lru_sel[2]);
assign oe_s1_loadn = ~(load_sel[2] & load_tag &  lru_sel[2]);
assign eo_s0_loadn = ~(load_sel[1] & load_tag & ~lru_sel[1]);
assign eo_s1_loadn = ~(load_sel[1] & load_tag &  lru_sel[1]);
assign oo_s0_loadn = ~(load_sel[0] & load_tag & ~lru_sel[0]);
assign oo_s1_loadn = ~(load_sel[0] & load_tag &  lru_sel[0]);


assign inv = invalidate;

de3d_tc_tag_ram RAM	
	(
	// Inputs.
	.de_clk			(de_clk),
	.de_rstn		(de_rstn), 
	.cur_mipmap		(cur_mipmap), 
	.ee_s0_loadn		(ee_s0_loadn), 
	.ee_s1_loadn		(ee_s1_loadn), 
	.eo_s0_loadn		(eo_s0_loadn), 
	.eo_s1_loadn		(eo_s1_loadn), 
	.oe_s0_loadn		(oe_s0_loadn), 
	.oe_s1_loadn		(oe_s1_loadn), 
	.oo_s0_loadn		(oo_s0_loadn), 
	.oo_s1_loadn		(oo_s1_loadn),
        .ee_tag_adr_rd		(ee_tag_adr_rd), 
	.eo_tag_adr_rd		(eo_tag_adr_rd), 
	.oe_tag_adr_rd		(oe_tag_adr_rd), 
	.oo_tag_adr_rd		(oo_tag_adr_rd),
        .ee_tag_adr_wr		(ee_tag_adr), 
	.eo_tag_adr_wr		(eo_tag_adr), 
	.oe_tag_adr_wr		(oe_tag_adr), 
	.oo_tag_adr_wr		(oo_tag_adr),
        .ee_tag_dat_in		(ee_tag_dat_in), 
	.eo_tag_dat_in		(eo_tag_dat_in),
        .oe_tag_dat_in		(oe_tag_dat_in), 
	.oo_tag_dat_in		(oo_tag_dat_in),
	.tag_ram_csn		(tag_ram_csn),
	// Outputs.
        .ee_tag_dat_out		(ee_tag_dat_out), 
	.eo_tag_dat_out		(eo_tag_dat_out),
	.oe_tag_dat_out		(oe_tag_dat_out), 
	.oo_tag_dat_out		(oo_tag_dat_out)
	);

de3d_tc_tag_val VAL	
	(
	// Inputs.
	.de_clk			(de_clk), 
	.de_rstn		(de_rstn), 
	.invalidate		(inv), 
	.ee_s0_loadn		(ee_s0_loadn), 
	.ee_s1_loadn		(ee_s1_loadn),
	.eo_s0_loadn		(eo_s0_loadn), 
	.eo_s1_loadn		(eo_s1_loadn),
	.oe_s0_loadn		(oe_s0_loadn), 
	.oe_s1_loadn		(oe_s1_loadn),
	.oo_s0_loadn		(oo_s0_loadn), 
	.oo_s1_loadn		(oo_s1_loadn),
        .ee_tag_adr_rd		(ee_tag_adr_rd), 
	.eo_tag_adr_rd		(eo_tag_adr_rd),
        .oe_tag_adr_rd		(oe_tag_adr_rd), 
	.oo_tag_adr_rd		(oo_tag_adr_rd),
        .ee_tag_adr_wr		(ee_tag_adr), 
	.eo_tag_adr_wr		(eo_tag_adr),
        .oe_tag_adr_wr		(oe_tag_adr), 
	.oo_tag_adr_wr		(oo_tag_adr),
	// Outputs.
        .ee_val			(ee_val), 
	.eo_val			(eo_val),
        .oe_val			(oe_val), 
	.oo_val			(oo_val)
	);

de3d_tc_tag_set SET	
	(
	// Inputs.
	.de_clk			(de_clk), 
	.de_rstn		(de_rstn),
	.ee_s0_hit		(ee_s0_hit), 
	.ee_s1_hit		(ee_s1_hit),
	.eo_s0_hit		(eo_s0_hit), 
	.eo_s1_hit		(eo_s1_hit),
	.oe_s0_hit		(oe_s0_hit), 
	.oe_s1_hit		(oe_s1_hit),
	.oo_s0_hit		(oo_s0_hit), 
	.oo_s1_hit		(oo_s1_hit),
        .ee_tag_adr_rd		(ee_tag_adr_rd), 
	.eo_tag_adr_rd		(eo_tag_adr_rd),
        .oe_tag_adr_rd		(oe_tag_adr_rd), 
	.oo_tag_adr_rd		(oo_tag_adr_rd),
        .ee_tag_adr_wr		(ee_tag_adr), 
	.eo_tag_adr_wr		(eo_tag_adr),
        .oe_tag_adr_wr		(oe_tag_adr), 
	.oo_tag_adr_wr		(oo_tag_adr),
	// Outputs.
        .ee_lru			(ee_lru), 
	.eo_lru			(eo_lru),
        .oe_lru			(oe_lru), 
	.oo_lru			(oo_lru)
	);


endmodule



