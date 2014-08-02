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
//  Title       :  TC Top Level
//  File        :  de3d_tc_top.v
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

`timescale 1 ps / 1ps

module de3d_tc_top 
  #(parameter BYTES = 4)
  (
   // DE SIGNALS
   input		de_clk,			// Clock for Drawing Engine
   input		de_rstn,		// Reset for Drawing Engine
   input		pc_busy,		// Pixel cache busy.
   input		push_uv,		// Push UV.
   input [31:0]	tex_2,			// texture control register.
   // 
   input           current_clip_g1,        // When high, return a de_ack
   input	[8:0]	current_bit_mask_x_g1,	// Mask for X size of bitmap
   input	[8:0]	current_bit_mask_y_g1,	// Mask for Y size of bitmap
   input   [3:0]   current_mipmap_g1,      // mipmap we are currently on
   input		current_exact_g1,	// only fetch one texel at ul_x,ul_y
   input	[10:0]	current_u_g1,		// Upper left texel (U)
   input	[10:0]	current_v_g1,		// Upper left texel (V)
   // 
   
   input	[209:0] lod_2,		// LOD origin.
   input                pal_load,       // Load palette
	input		tc_inv,		// Invalidate texel cache
                                //                      000001 1bpt 0565
				//                      000010 1bpt 4444
				// 			000011 1bpt 8888
                                //                      000100 2bpt 1555
				//                      000101 2bpt 0565
				//                      000110 2bpt 4444
				// 			000111 2bpt 8888
				//                      001000 4bpt 1555
				//                      001001 4bpt 0565
				//                      001010 4bpt 4444
				// 			001011 4bpt 8888
				//                      001100 8bpt 1232
				//                      001101 8bpt 0332
				// 			001110 8bpt 1555
				// 			001111 8bpt 0565
				// 			011100 8bpt 4444
				// 			011101 8bpt 8888 (exact)
				// 			111110 8bpt 8888 (16-4444)
				// 			111111 8bpt 8888 (16-0565)
				//			011110 8bpt 8332
				//                      010000 16bpt 4444
				//                      010001 16bpt 1555
				//                      010010 16bpt 0565
				//			010011 16bpt 8332
				//                      010100 32bpt 8888
				//                      011000 1bpt 8332
				//			011001 2bpt 8332
				//			011010 4bpt 8332
				// OpenGL modes		100000 Alpha4
				//			100001 Alpha8
				//			100100 Luminance4
				//			100101 Luminance8
				//			101000 Luminance4_alpha4
				//			101001 Luminance6_alpha2
				//			101010 Luminance8_alpha8
				//			101100 Intensity4
				//			101101 Intensity8
				//			110000 RGBA2
	input   [11:0]  tptch,          // Texture pitch to be sent to DEM
	// input   [31:0]  torg,           // Texture pitch to be sent to DEM
	input	[31:0]	boarder_color,	// boarder color (3rd pipe stage)
	// DE SIGNALS
	output	[7:0]	usedw_tc,
	output		full_tc,
	output		tc_ack,		// load input values into lvl 2 register
	output		tc_ready,	// Texture cache ack's uv load
	output		tc_ready_e,	// Texture cache ack's uv load
	output          tc_busy,        // Texel cache is busyto DE during load
	output  [31:0]  ul_tex,         // Upper left texel
	output	[31:0]	ll_tex,         // Lower left texel
	output	[31:0]	ur_tex,         // Upper right texel
	output	[31:0]	lr_tex,         // Lower right texel
	// MC Input
	input		mclock,		// Memory controller clock.
	input		mc_tc_push,
	input		mc_tc_ack,
	input [(BYTES<<3)-1:0] mc_tc_data,       // for level 2 cache
        input           mc_pal_ack,
        input           mc_pal_push,
	// MC Outputs.
	output		mc_tc_req,	// Texture memory request.
	output  [5:0]   mc_tc_page,     // Number of Pages.
	output  [31:0]  mc_tc_address,  // Memory Address.
        output          mc_pal_req,
   	output 		mc_pal_half
	);

`include "define_3d.h"

  assign mc_tc_page = 6'b0001;
//////////////////////////////////////////////////////////////////////////

wire		tex_en;		// Texture Mode Enable
wire	[5:0]	tsize;		// Texture map format:	000000 1bpt 1555
wire		clamp_u;	// clamp u
wire		clamp_v;	// clamp v
wire		ccs;		// clamp color selector (3rd pipe stage)
  
assign tex_en  = tex_2`T_TM;
assign tsize   = tex_2`T_SIZE;
assign clamp_u = tex_2`T_TCU;
assign clamp_v = tex_2`T_TCV;
assign ccs     = tex_2`T_CCS;

wire            exact_out;

wire	[31:0]	ul_tex_i;
wire	[31:0]	ll_tex_i;
wire	[31:0]	ur_tex_i;
wire	[31:0]	lr_tex_i;

wire	[8:0]	ul_x;
wire	[8:0]	ul_y;
wire	[8:0]	ll_x;
wire	[8:0]	ll_y;
wire	[8:0]	ur_x;
wire	[8:0]	ur_y;
wire	[8:0]	lr_x;
wire	[8:0]	lr_y;

wire    [26:0]  ul_tag;
wire    [26:0]  ll_tag;
wire    [26:0]  ur_tag;
wire    [26:0]  lr_tag;

wire    [8:0]   ul_store_x;
wire    [8:0]   ul_store_y;
wire    [8:0]   ll_store_x;
wire    [8:0]   ll_store_y;
wire    [8:0]   ur_store_x;
wire    [8:0]   ur_store_y;
wire    [8:0]   lr_store_x;
wire    [8:0]   lr_store_y;
wire    [31:0]  do0, do1, 
		do2, do3, 
		do4, do5, 
		do6, do7; /* Data out from RAM cells     */
wire            load_tag;
wire    [7:0]   ram_addr;
wire		ld_push_count;
wire	[3:0]	push_count;
wire	[3:0]	tc_op;		/* TC operations to preform:		*/
				/* 0000:Loaded 				*/
				/* 0001:Load lr				*/
				/* 0010:Load ur				*/
				/* 0011:Load ur, lr    			*/
				/* 0100:Load ll                    	*/
				/* 0101:Load ll, lr                     */
				/* 0110:Load ll, ur                     */
				/* 0111:Load ll, ur, lr                 */
				/* 1000:Load ul                 	*/
				/* 1001:Load ul, lr			*/
				/* 1010:Load ul, ur			*/
				/* 1011:Load ul, ur, lr			*/
				/* 1100:Load ul, ll			*/
				/* 1101:Load ul, ll, lr			*/
				/* 1110:Load ul, ll, ur			*/
				/* 1111:Load ul, ll, ur, lr		*/
wire		clamp_ur;	/* clamp data out of the cache		*/
wire		clamp_ul;	/* clamp data out of the cache		*/
wire		clamp_lr;	/* clamp data out of the cache		*/
wire		clamp_ll;	/* clamp data out of the cache		*/
wire		clamp_ul_r;	/* one cycle delayed clamp_ovd;		*/
wire		clamp_ur_r;	/* one cycle delayed clamp_ovd;		*/
wire		clamp_ll_r;	/* one cycle delayed clamp_ovd;		*/
wire		clamp_lr_r;	/* one cycle delayed clamp_ovd;		*/
wire		invalidate;	/* signal to invalidate the tags	*/
wire    [2:0]   bpt_r;          /* bits per texel 1 cycle delay		*/
				/* 			1	=2	*/
				/*			2	=4	*/
				/*			3	=8	*/
				/*			4	=16	*/
				/*			5	=32	*/
wire	[4:0]	tfmt_r;		/* format of texture 1 cycle delay	*/
  wire 		pal_mode_r;
wire	[4:0]	tfmt;		/* format of texture:	0	=1555	*/
				/*			1	=0565	*/
				/*			2	=4444	*/
				/*			3	=8888	*/
				/*			4	=8332	*/
				/*			5	=1232	*/
				/*			6	=0332	*/
				/* See below for OPENGL formats		*/
wire            ram_sel;
wire    [3:0]   tc_op_store;
wire	[3:0]	mipmap_store;   /* Pipelined mipmap number              */
wire    [7:0]   adr0_i, adr1_i, /* Addresses to memory RAMS             */
                adr2_i, adr3_i,
		adr4_i, adr5_i,
		adr6_i, adr7_i;
wire		exception;
wire	[3:0]	set_sel;   	/* Set to be updated.                   */
wire	[3:0]	set_read;   	/* Set to be read.                   	*/
wire	[7:0]	hit_bus;   	/* Hits.	                   	*/
wire	     	ram_wen_lo;
wire	     	ram_wen_hi;
wire	[11:0]	tex_ptch;
wire	[20:0]	tex_org;
wire	[31:0]	tex_address;
wire		tc_fifo_empty;
wire		tex_req;
wire	[7:0]	tex_fifo_wrused;
wire	[1:0]	req_count;
wire		exact_r; 
wire		tag_ads; 
wire		done; 
wire		tc_fetch; 
wire [4:0]	ee_tag_adr_rd;
wire [4:0]	eo_tag_adr_rd;
wire [4:0]	oe_tag_adr_rd;
wire [4:0]	oo_tag_adr_rd;
wire          	pop_uv;         // Pop The UV fifo.
wire          	tc_fetch_n;

wire [2:0]	bpt_d; 
wire [4:0]	tfmt_d;
  wire          pal_mode_d;
wire [2:0]	bpt_dd; 
wire [4:0]	tfmt_dd;
  wire          pal_mode_dd;
wire		push_uv_dd;
wire		current_clip_dd;
wire		current_exact_dd;
wire [3:0]	current_mipmap_dd;

wire		tc_clip_in;
wire [3:0]	tc_mipmap;
wire		tc_exact;
wire [8:0]	tc_ul_x;
wire [8:0]	tc_ul_y;
wire [8:0]	tc_ur_x;
wire [8:0]	tc_ur_y;
wire [8:0]	tc_ll_x;
wire [8:0]	tc_ll_y;
wire [8:0]	tc_lr_x;
wire [8:0]	tc_lr_y;
wire		tc_clamp_ul;
wire		tc_clamp_ur;
wire		tc_clamp_ll;
wire		tc_clamp_lr;
wire [2:0]	tc_bpt;
wire [4:0]	tc_tfmt;
  wire 		tc_pal_mode;
wire [4:0]	tc_ee_tag_adr_rd;
wire [4:0]	tc_eo_tag_adr_rd;
wire [4:0]	tc_oe_tag_adr_rd;
wire [4:0]	tc_oo_tag_adr_rd;

  // Palette RAM signals
  wire [127:0] 	pal_mux;
  wire 		pal_we;
  wire [7:0] 	pal_addr_0;
  wire [7:0] 	pal_addr_1;
  wire [7:0] 	pal_addr_2;
  wire [7:0] 	pal_addr_3;
  reg [31:0] 	pal_ram0[255:0];
  reg [31:0] 	pal_ram1[255:0];
  reg [31:0] 	pal_ram2[255:0];
  reg [31:0] 	pal_ram3[255:0];
  reg [31:0] 	pal_lookup[3:0];
  wire [7:0] 	pal_rdaddr_0;
  wire [7:0] 	pal_rdaddr_1;
  wire [7:0] 	pal_rdaddr_2;
  wire [7:0] 	pal_rdaddr_3;

/* Instantiations */
// The fog table generator has 3 pipeline stages. This corresponds to the three stages
// in the texel cache. The texel cache stages are:
// 1) generate the opcodes and store them, plus RAM addresses
// REGISTER - pc_busy
// 2) get texel value and swizzle to 32 bit texels
// REGISTER - busy2
// 3) lookup palette entry
// REGISTER - busy3
// 4) format data and output to renderer
//
//
assign tc_fetch = ~tc_fetch_n & tex_en & ~pc_busy;

de3d_tc_fmt      u_de3d_tc_fmt
	(
	.de_clk			(de_clk),
	.tsize			(tsize),
	.bpt			(bpt_d), 
	.tfmt			(tfmt_d),
	 .pal_mode              (pal_mode_d)
	);

de3d_tc_addr_in u_de3d_tc_addr_in
	(
	// Inputs.
	.de_clk			(de_clk),
	.bpt_d			(bpt_d), 
	.tfmt_d			(tfmt_d),
	 .pal_mode_d            (pal_mode_d),
	.push_uv		(push_uv & tex_en),
	.current_clip		(current_clip_g1),
        .bitmask_x		(current_bit_mask_x_g1), 
	.bitmask_y		(current_bit_mask_y_g1), 
	.current_mipmap		(current_mipmap_g1),
	.current_exact		(current_exact_g1),
	.ul_u			(current_u_g1), 
	.ul_v			(current_v_g1),
        .clamp_x		(clamp_u),		// clamp u		
	.clamp_y		(clamp_v),		// clamp v	
	// Outputs.
	.push_uv_dd		(push_uv_dd),
	.current_clip_dd	(current_clip_dd),
	.current_mipmap_dd	(current_mipmap_dd),
	.current_exact_dd	(current_exact_dd),
        .ul_x			(ul_x), 
        .ul_y			(ul_y), 
	.ur_x			(ur_x), 
	.ur_y			(ur_y), 
	.ll_x			(ll_x), 
	.ll_y			(ll_y), 
	.lr_x			(lr_x),
	.lr_y			(lr_y),
        .clamp_ul		(clamp_ul), 
	.clamp_ur		(clamp_ur),
        .clamp_ll		(clamp_ll), 
	.clamp_lr		(clamp_lr),
	.bpt_dd			(bpt_dd),
	.tfmt_dd		(tfmt_dd),
	 .pal_mode_dd           (pal_mode_dd),
	.ee_tag_adr_rd		(ee_tag_adr_rd),
	.eo_tag_adr_rd		(eo_tag_adr_rd),
	.oe_tag_adr_rd		(oe_tag_adr_rd),
	.oo_tag_adr_rd		(oo_tag_adr_rd)
	);

// Current UV for Texture Cache..
// This needs to be a look ahead fifo.
sfifo_112x256_la u_sfifo_112x256_uv_tc
	(
	.aclr			(~de_rstn),
	.clock			(de_clk),
	.data			({ 
				1'b0,			// Spare bits.
				   pal_mode_dd,
				current_clip_dd,	// 1 bit 
				current_mipmap_dd,	// 4 bits		 
				current_exact_dd, 	// 1 bit
        			ul_x, 			// 9 bits
        			ul_y, 			// 9 bits
				ur_x, 			// 9 bits
				ur_y, 			// 9 bits
				ll_x, 			// 9 bits
				ll_y, 			// 9 bits
				lr_x,			// 9 bits
				lr_y,			// 9 bits
        			clamp_ul,		// 1 bit
				clamp_ur,		// 1 bit
        			clamp_ll, 		// 1 bit
				clamp_lr,		// 1 bit
				bpt_dd,			// 3 bits
				tfmt_dd,		// 5 bits
				ee_tag_adr_rd,		// 5 bits
				eo_tag_adr_rd,		// 5 bits
				oe_tag_adr_rd,		// 5 bits
				oo_tag_adr_rd		// 5 bits
				}),
	.wrreq			(push_uv_dd & tex_en),
	.rdreq			(pop_uv), // tc_ready), // tc_ack),
	.q			({
				  tc_pal_mode,          // 1 bit
				tc_clip_in,		// 1  bit.
				tc_mipmap, 		// 4  bits.
				tc_exact,		// 1  bit. 
        			tc_ul_x, 		// 9 bits
        			tc_ul_y, 		// 9 bits
				tc_ur_x, 		// 9 bits
				tc_ur_y, 		// 9 bits
				tc_ll_x, 		// 9 bits
				tc_ll_y, 		// 9 bits
				tc_lr_x,		// 9 bits
				tc_lr_y,		// 9 bits
        			tc_clamp_ul,		// 1 bits
				tc_clamp_ur,		// 1 bits
        			tc_clamp_ll, 		// 1 bits
				tc_clamp_lr,		// 1 bits
				tc_bpt,			// 3 bits
				tc_tfmt,		// 5 bits
				tc_ee_tag_adr_rd,	// 5 bits
				tc_eo_tag_adr_rd,	// 5 bits
				tc_oe_tag_adr_rd,	// 5 bits
				tc_oo_tag_adr_rd	// 5 bits
			       	}),
	.empty			(tc_fetch_n),
	.usedw			(usedw_tc),
	.full			(),
	.almost_full		(full_tc)
	);

de3d_tc_tag u_de3d_tc_tag
	(
	.de_clk			(de_clk), 
	.de_rstn		(de_rstn),
	.load_tag		(load_tag), 
	.tag_ads		(tag_ads), 
	.bpt			(tc_bpt), 
	.tc_op_store		(tc_op_store),
	.ee_tag_adr_rd		(tc_ee_tag_adr_rd),
	.eo_tag_adr_rd		(tc_eo_tag_adr_rd),
	.oe_tag_adr_rd		(tc_oe_tag_adr_rd),
	.oo_tag_adr_rd		(tc_oo_tag_adr_rd),
	.ul_tag_adr_rd		({tc_ul_x[8:3], tc_ul_y}), 
	.ll_tag_adr_rd		({tc_ll_x[8:3], tc_ll_y}),
	.ur_tag_adr_rd		({tc_ur_x[8:3], tc_ur_y}),
	.lr_tag_adr_rd		({tc_lr_x[8:3], tc_lr_y}),
	.ul_tag_adr_wr		({ul_store_x[8:3],ul_store_y[8:0]}), 
	.ll_tag_adr_wr		({ll_store_x[8:3],ll_store_y[8:0]}),
	.ur_tag_adr_wr		({ur_store_x[8:3],ur_store_y[8:0]}),
	.lr_tag_adr_wr		({lr_store_x[8:3],lr_store_y[8:0]}),
     	.invalidate		(invalidate), 
	.cur_mipmap		(mipmap_store),
	.set_sel		(set_sel), 
	.hit_bus		(hit_bus), 
	.tc_fetch		(tc_fetch),
	// Outputs
	.ul_tag			(ul_tag), 
	.ll_tag			(ll_tag),
	.ur_tag			(ur_tag), 
	.lr_tag			(lr_tag),
	.exception		(exception)
	);
		     
de3d_tc_store u_de3d_tc_store
	(
	.de_clk			(de_clk), 
	.de_rstn		(de_rstn), 
	.tc_ack			(tc_ack),
	.mipmap			(tc_mipmap), 
	.lod_2			(lod_2),
	.ul			({tc_ul_x, tc_ul_y}), 
	.ur			({tc_ur_x, tc_ur_y}), 
	.ll			({tc_ll_x, tc_ll_y}), 
	.lr			({tc_lr_x, tc_lr_y}), 
	.clamp_ur		(tc_clamp_ur), 
	.clamp_ul		(tc_clamp_ul), 
	.clamp_lr		(tc_clamp_lr), 
	.clamp_ll		(tc_clamp_ll),
	.bpt			(tc_bpt), 
	.tfmt			(tc_tfmt), 
	 .pal_mode              (tc_pal_mode),
	.tc_op			(tc_op), 
	.tptch			(tptch),
	.exact			(tc_exact),
	// Outputs.
	.mipmap_store		(mipmap_store),
	.clamp_ul_r		(clamp_ul_r),
	.clamp_ll_r		(clamp_ll_r), 
	.clamp_ur_r		(clamp_ur_r),
	.clamp_lr_r		(clamp_lr_r), 
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bpt_r			(bpt_r), 
	.tfmt_r			(tfmt_r), 
	 .pal_mode_r            (pal_mode_r),
	 .exact_r		(exact_r), 
	.tc_op_store		(tc_op_store),
	.tex_org		(tex_org),
	.tex_ptch		(tex_ptch)
	);

de3d_tc_compare  u_de3d_tc_compare  
	(
	// Inputs.
	.de_clk			(de_clk), 
	.de_rstn		(de_rstn), 
	.tc_ack			(tc_ack),
	.ur			({tc_ur_x, tc_ur_y}), 
	.ul			({tc_ul_x, tc_ul_y}), 
	.lr			({tc_lr_x, tc_lr_y}), 
	.ll			({tc_ll_x, tc_ll_y}), 
	.mipmap_in		(tc_mipmap),
        .ul_tag			(ul_tag), 
	.ll_tag			(ll_tag),
        .ur_tag			(ur_tag), 
	.lr_tag			(lr_tag),
	.exception		(exception),
        .bpt			(tc_bpt),
       	.tc_exact		(tc_exact),
	.clip			(tc_clip_in),
	// Outputs.
        .tc_op			(tc_op), 
	.set_sel		(set_sel), 
	.set_read		(set_read), 
	.hit_bus		(hit_bus)
	);

de3d_tc_sm	u_de3d_tc_sm	
	(
	// Inputs.
	.de_clk			(de_clk), 
	.mc_clk			(mclock), 
	.de_rstn		(de_rstn),
	.tc_op			(tc_op), 
	.tc_fetch		(tc_fetch), 
	.clip_in		(1'b0), 
	.pc_busy		(pc_busy), 
	.pal_load		(pal_load), 
	.tc_inv			(tc_inv), 
	.done			(done),
	.tex_fifo_wrused	(tex_fifo_wrused),
	.tex_en			(tex_en),
	 .pal_ack               (mc_pal_ack),
	 .mc_pal_push           (mc_pal_push),
	 .mc_data               (mc_tc_data),
	 
	// Outputs.
	.invalidate		(invalidate), 
	.tc_busy		(tc_busy),
	.load_tag		(load_tag), 
	.tag_ads		(tag_ads),
	.tex_req		(tex_req), 
	 .pal_req               (mc_pal_req),
	 .pal_half              (mc_pal_half),
	.tc_ack			(tc_ack), 
	.tc_ready		(tc_ready),
	.tc_ready_e		(tc_ready_e),
	.ld_push_count		(ld_push_count), 
	.push_count		(push_count),
	.req_count		(req_count),
	.pop_uv			(pop_uv),
	 .pal_mux               (pal_mux),
	 .pal_we                (pal_we),
	 .pal_addr_0            (pal_addr_0),
	 .pal_addr_1            (pal_addr_1),
	 .pal_addr_2            (pal_addr_2),
	 .pal_addr_3            (pal_addr_3)
	);

  // infer 4 32x256 simple dual port RAMs
  always @(posedge mclock) begin
    if (pal_we) pal_ram0[pal_addr_0] <= pal_mux[31:0];
    if (pal_we) pal_ram1[pal_addr_1] <= pal_mux[63:32];
    if (pal_we) pal_ram2[pal_addr_2] <= pal_mux[95:64];
    if (pal_we) pal_ram3[pal_addr_3] <= pal_mux[127:96];
  end
  
  always @(posedge de_clk) begin
    pal_lookup[0] <= pal_ram0[pal_rdaddr_0];
    pal_lookup[1] <= pal_ram1[pal_rdaddr_1];
    pal_lookup[2] <= pal_ram2[pal_rdaddr_2];
    pal_lookup[3] <= pal_ram3[pal_rdaddr_3];
  end
    
de3d_tc_load_gen    
	#(.BYTES (BYTES))
	u_de3d_tc_load_gen    
	(
	// Inputs.
	.de_clk			(de_clk),
	.tex_org		(tex_org),
	.tptch			(tex_ptch),
	.tc_op_store		(tc_op_store),
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y), 
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y), 
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y), 
	.bpt			(bpt_r), 
	.req_count		(req_count),
	// Outputs.
	.tex_address		(tex_address)
	);

de3d_tc_mc_sigs	u_de3d_tc_mc_sigs	
	(
	// Inputs.
	.de_clk			(de_clk), 
	.de_rstn		(de_rstn),
        .ld_push_count		(ld_push_count), 
	.push_count		(push_count),
	.mclock			(mclock), 
	.tex_push_en		(mc_tc_push),
	.tc_op_store		(tc_op_store),
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y), 
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y), 
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y), 
	.bpt			(bpt_r), 
	.set_read		(set_read),
	// Outputs
	.done			(done), 
	.ram_sel		(ram_sel),
	.ram_addr		(ram_addr)
	);

/* generate address for RAMs *****************************************/

de3d_tc_mem_if_addr u0_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h0), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr0_i)
	);

de3d_tc_mem_if_addr u1_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h1), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr1_i)
	);

de3d_tc_mem_if_addr u2_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h2), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr2_i)
	);
de3d_tc_mem_if_addr u3_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h3), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr3_i)
	);

de3d_tc_mem_if_addr u4_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h4), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr4_i)
	);

de3d_tc_mem_if_addr u5_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h5), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr5_i)
	);

de3d_tc_mem_if_addr u6_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h6), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr6_i)
	);

de3d_tc_mem_if_addr u7_de3d_tc_mem_if_addr 
	(
	.ul_store_x		(ul_store_x), 
	.ul_store_y		(ul_store_y),
	.ll_store_x		(ll_store_x), 
	.ll_store_y		(ll_store_y),
	.ur_store_x		(ur_store_x), 
	.ur_store_y		(ur_store_y),
	.lr_store_x		(lr_store_x), 
	.lr_store_y		(lr_store_y),
	.bank			(3'h7), 
	.bpt			(bpt_r), 
	.tc_ready		(1'b1), // tc_ready),
	.set_read		(set_read),
	 // Output.
	.addr_out		(adr7_i)
	);

/* RAM write enable generators. ****************************************/

de3d_tc_mc_we u_de3d_tc_mc_we
	(
	.mclock		(mclock), 
	.rstn		(de_rstn), 
	.tex_push_en	(mc_tc_push), 
	.ram_sel	(ram_sel), 
        .ram_wen_lo	(ram_wen_lo), 
        .ram_wen_hi	(ram_wen_hi) 
	);

// RAM Instantiations - 256x32 RAMS 
dpram_256x32 u0_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_lo),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[31:0]),
	.rdclock		(de_clk),
	.rdaddress		(adr0_i),
	.q			(do0)
	);

dpram_256x32 u1_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_lo),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[63:32]),
	.rdclock		(de_clk),
	.rdaddress		(adr1_i),
	.q			(do1)
	);

dpram_256x32 u2_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_lo),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[95:64]),
	.rdclock		(de_clk),
	.rdaddress		(adr2_i),
	.q			(do2)
	);

dpram_256x32 u3_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_lo),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[127:96]),
	.rdclock		(de_clk),
	.rdaddress		(adr3_i),
	.q			(do3)
	);

dpram_256x32 u4_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_hi),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[31:0]),
	.rdclock		(de_clk),
	.rdaddress		(adr4_i),
	.q			(do4)
	);

dpram_256x32 u5_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_hi),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[63:32]),
	.rdclock		(de_clk),
	.rdaddress		(adr5_i),
	.q			(do5)
	);

dpram_256x32 u6_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_hi),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[95:64]),
	.rdclock		(de_clk),
	.rdaddress		(adr6_i),
	.q			(do6)
	);

dpram_256x32 u7_dpram_256x32
	(
	.wrclock		(mclock),
	.wren			(ram_wen_hi),
	.wraddress		(ram_addr),
	.data			(mc_tc_data[127:96]),
	.rdclock		(de_clk),
	.rdaddress		(adr7_i),
	.q			(do7)
	);


/* Mux data to outputs ***********************************************/

de3d_tc_mem_if_out ul_de3d_tc_mem_if_out
	(
	.de_clk			(de_clk), 
	.store_x		(ul_store_x), 
	.store_y		(ul_store_y),
	.din0			(do0), 
	.din1			(do1), 
	.din2			(do2), 
	.din3			(do3), 
	.din4			(do4), 
	.din5			(do5), 
	.din6			(do6), 
	.din7			(do7),
	 .pal_lookup            (pal_lookup[0]),
	.bpt			(bpt_r), 
	.tfmt			(tfmt_r), 
	 .pal_mode              (pal_mode_r),
	.exact			(exact_r), 
	.clamp_ovd		(clamp_ul_r), 
	.ccs_dd			(ccs), 
	.boarder_color_dd	(boarder_color), 
	.tex_en			(tex_en),
	.exact_out		(exact_out), 
	.dout			(ul_tex_i),
	 .pal_addr              (pal_rdaddr_0)
	 ); 

  de3d_tc_mem_if_out  ll_de3d_tc_mem_if_out
    (
     .de_clk			(de_clk), 
     .store_x		(ll_store_x), 
     .store_y		(ll_store_y),
     .din0			(do0), 
     .din1			(do1), 
     .din2			(do2), 
     .din3			(do3), 
     .din4			(do4), 
     .din5			(do5), 
     .din6			(do6), 
     .din7			(do7),
	 .pal_lookup            (pal_lookup[1]),
     .bpt			(bpt_r), 
     .tfmt			(tfmt_r), 
	 .pal_mode              (pal_mode_r),
     .exact			(exact_r), 
     .clamp_ovd		(clamp_ll_r), 
     .ccs_dd			(ccs), 
     .boarder_color_dd	(boarder_color), 
     .tex_en			(tex_en),
     .exact_out		(), 
     .dout			(ll_tex_i),
	 .pal_addr              (pal_rdaddr_1)
     ); 

  de3d_tc_mem_if_out  ur_de3d_tc_mem_if_out
    (
     .de_clk			(de_clk), 
     .store_x		(ur_store_x), 
     .store_y		(ur_store_y),
     .din0			(do0), 
     .din1			(do1), 
     .din2			(do2), 
     .din3			(do3), 
     .din4			(do4), 
     .din5			(do5), 
     .din6			(do6), 
     .din7			(do7),
	 .pal_lookup            (pal_lookup[2]),
     .bpt			(bpt_r), 
     .tfmt			(tfmt_r), 
	 .pal_mode              (pal_mode_r),
     .exact			(exact_r), 
     .clamp_ovd		(clamp_ur_r), 
     .ccs_dd			(ccs), 
     .boarder_color_dd	(boarder_color), 
     .tex_en			(tex_en),
     .exact_out		(), 
     .dout			(ur_tex_i),
	 .pal_addr              (pal_rdaddr_2)
     ); 

  de3d_tc_mem_if_out  lr_de3d_tc_mem_if_out
    (
     .de_clk			(de_clk), 
     .store_x		(lr_store_x), 
     .store_y		(lr_store_y),
     .din0			(do0), 
     .din1			(do1), 
     .din2			(do2), 
     .din3			(do3), 
     .din4			(do4), 
     .din5			(do5), 
     .din6			(do6), 
     .din7			(do7),
	 .pal_lookup            (pal_lookup[3]),
     .bpt			(bpt_r), 
     .tfmt			(tfmt_r), 
	 .pal_mode              (pal_mode_r),
     .exact			(exact_r), 
     .clamp_ovd		(clamp_lr_r), 
     .ccs_dd			(ccs), 
     .boarder_color_dd	(boarder_color), 
     .tex_en			(tex_en),
     .exact_out		(), 
     .dout			(lr_tex_i),
	 .pal_addr              (pal_rdaddr_3)
     ); 

  afifo_32x256 u_tex_req_fifo
    (
     .aclr		(~de_rstn),
     .wrclk		(de_clk),
     .wrreq		(tex_req),
     .data		(tex_address),
     .rdclk		(mclock),
     .rdreq		(mc_tc_ack),
     .q		(mc_tc_address),
     .rdempty	(tc_fifo_empty),
     .wrfull		(),
     .wrusedw	(tex_fifo_wrused)
     );

  assign mc_tc_req = ~tc_fifo_empty;

  
  // Outputs based on palette or non
  assign	ul_tex = (exact_out) ? ul_tex_i : ul_tex_i;
  assign	ll_tex = (exact_out) ? ul_tex_i : ll_tex_i;
  assign	ur_tex = (exact_out) ? ul_tex_i : ur_tex_i;
  assign	lr_tex = (exact_out) ? ul_tex_i : lr_tex_i;

  
endmodule
