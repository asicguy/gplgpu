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
//  Title       :  Address Input
//  File        :  de3d_tc_addr_in.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This module handles clamping situations, as well as texture 
//  mirroring. It takes the UL texel address in, and generates  
//  the addresses for the 4 texels to the tag. It also generates
//  the clip signal to overide the texels out.			
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//    U_HBI         hbi_top        Host interface (PCI)
//    U_VGA         vga_top        IBM(TM) Compatible VGA core
//    U_DE          de_top         Drawing engine
//    U_DLP         dlp_top        Display List Processor
//    U_DDR3        DDR3           DDR3 Memory interface
//    u_crt         crt_top        Display interface
//    u_ramdac      ramdac         Digital DAC
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

module de3d_tc_addr_in
	(
	input		de_clk,		// DE clock.
	input	[2:0]	bpt_d,		// bits per texel.       
	input	[4:0]	tfmt_d,		// bits per texel.       
	 input          pal_mode_d,     // Palette mode
	input		push_uv,	// Push uv.
	input	[10:0]	ul_u,		/* Upper left texel X			*/
	input	[10:0]	ul_v,		/* Upper left texel Y			*/
	input		clamp_x,	/* Clamp in X				*/
	input		clamp_y,	/* Clamp in Y				*/
	input	[8:0]	bitmask_x,	/* X valid bitmask			*/
	input	[8:0]	bitmask_y,	/* Y valid bitmask			*/
	input		current_clip,	// CLipping.
	input	[3:0]	current_mipmap,	// Current MIPMAP #
	input		current_exact,	// Exact.

	output reg		push_uv_dd,	// Push uv delayed.
	output reg	[2:0]	bpt_dd,		// bits per texel.       
	output reg	[4:0]	tfmt_dd,	// bits per texel.       
	 output reg             pal_mode_dd,    // Palette mode
	 output	[8:0]	ul_x,		/* Addresses to the tag			*/
	output	[8:0]	ul_y,		/* Addresses to the tag			*/
	output	[8:0]	ur_x,		/* Addresses to the tag			*/
	output	[8:0]	ur_y,		/* Addresses to the tag			*/
	output	[8:0]	ll_x,		/* Addresses to the tag			*/
	output	[8:0]	ll_y,		/* Addresses to the tag			*/
	output	[8:0]	lr_x,		/* Addresses to the tag			*/
	output	[8:0]	lr_y,		/* Addresses to the tag			*/
	output		clamp_ul,	/* clamping override			*/
	output		clamp_ur,	/* clamping override			*/
	output		clamp_ll,	/* clamping override			*/
	output		clamp_lr,	/* clamping override			*/
	output reg		current_clip_dd,		// CLipping.
	output reg	[3:0]	current_mipmap_dd,	// Current MIPMAP #
	output reg		current_exact_dd,		// Exact.
	output reg	[4:0]	ee_tag_adr_rd,
	output reg	[4:0]	eo_tag_adr_rd,
	output reg	[4:0]	oe_tag_adr_rd,
	output reg	[4:0]	oo_tag_adr_rd
	);

// Registers
reg	[10:0]	ulx_int;	/* ul_x going out			*/
reg	[10:0]	uly_int;	/* ul_y going out			*/
reg	[6:0]	ul_tag_adr_bpt;
reg	[6:0]	ll_tag_adr_bpt;
reg	[6:0]	ur_tag_adr_bpt;
reg	[6:0]	lr_tag_adr_bpt;

reg		push_uv_d;
reg		current_clip_d;
reg	[3:0]	current_mipmap_d;
reg		current_exact_d;

wire	[10:0]	clamp_mask_x;	/* mask for determining clamp in X 	*/
wire	[10:0]	clamp_mask_y;	/* mask for determining clamp in Y 	*/
wire		outside_x;	/* Outside of 0 - 1 in X		*/
wire		outside_y;	/* Outside of 0 - 1 in Y		*/
wire		right_edge;	/* Right on final column, treat outside */
wire		bottom_edge; 	/* Right on last row, treat outside	*/
wire    [10:0]  ulx_inc;        /* incremented UL X coordinate          */
wire    [10:0]  uly_inc;        /* incremented UL Y coordinate          */

wire	[8:0]	ul_x_d;
wire	[8:0]	ul_y_d;
wire	[8:0]	ur_x_d;
wire	[8:0]	ur_y_d;
wire	[8:0]	ll_x_d;
wire	[8:0]	ll_y_d;
wire	[8:0]	lr_x_d;
wire	[8:0]	lr_y_d;

// Generate the mask to only show bits outside of range, note
// that bit 10 is the sign bit, and bit 9 is the overflow, they
// are never masked
assign clamp_mask_x[10:9] = (clamp_x) ? 2'b11		: 2'b00;
assign clamp_mask_x[8:0] =  (clamp_x) ? ~bitmask_x	: 9'h0;
assign clamp_mask_y[10:9] = (clamp_y) ? 2'b11		: 2'b00;
assign clamp_mask_y[8:0] =  (clamp_y) ? ~bitmask_y	: 9'h0;

/* non-mirroring */
/* Compute addresses */
// If it is biggest positive #, and clamping, must clamp value to make
// up for missed precision bits in renderer
assign ulx_inc = (clamp_x & (&ul_u[9:0] & ~ul_u[10])) ? ul_u : ul_u + 11'h1;
assign uly_inc = (clamp_y & (&ul_v[9:0] & ~ul_v[10])) ? ul_v : ul_v + 11'h1;

de3d_tc_clamp	u0_de3d_tc_clamp_ul	
	(
	.de_clk		(de_clk),
	.clamp_x	(clamp_x), 
	.clamp_y	(clamp_y), 
	.x		(ul_u), 
	.y		(ul_v), 
	.clamp_mask_x	(clamp_mask_x), 
	.clamp_mask_y	(clamp_mask_y), 
	.bitmask_x	(bitmask_x), 
	.bitmask_y	(bitmask_y),
	// Outputs.
	.clamp		(clamp_ul), 
	.new_x		(ul_x), 
	.new_y		(ul_y),
	.new_x_d	(ul_x_d), 
	.new_y_d	(ul_y_d)
	);

de3d_tc_clamp	u1_de3d_tc_clamp_ur	
	(
	.de_clk		(de_clk),
	.clamp_x	(clamp_x), 
	.clamp_y	(clamp_y), 
	.x		(ulx_inc), 
	.y		(ul_v), 
	.clamp_mask_x	(clamp_mask_x), 
	.clamp_mask_y	(clamp_mask_y), 
	.bitmask_x	(bitmask_x), 
	.bitmask_y	(bitmask_y),
	// Outputs.
	.clamp		(clamp_ur), 
	.new_x		(ur_x), 
	.new_y		(ur_y),
	.new_x_d	(ur_x_d), 
	.new_y_d	(ur_y_d)
	);

de3d_tc_clamp	u2_de3d_tc_clamp_ll	
	(
	.de_clk		(de_clk),
	.clamp_x	(clamp_x), 
	.clamp_y	(clamp_y), 
	.x		(ul_u), 
	.y		(uly_inc), 
	.clamp_mask_x	(clamp_mask_x), 
	.clamp_mask_y	(clamp_mask_y), 
	.bitmask_x	(bitmask_x), 
	.bitmask_y	(bitmask_y),
	// Outputs.
	.clamp		(clamp_ll), 
	.new_x		(ll_x), 
	.new_y		(ll_y),
	.new_x_d	(ll_x_d), 
	.new_y_d	(ll_y_d)
	);

de3d_tc_clamp	u3_de3d_tc_clamp_lr	
	(
	.de_clk		(de_clk),
	.clamp_x	(clamp_x), 
	.clamp_y	(clamp_y), 
	.x		(ulx_inc), 
	.y		(uly_inc), 
	.clamp_mask_x	(clamp_mask_x), 
	.clamp_mask_y	(clamp_mask_y), 
	.bitmask_x	(bitmask_x), 
	.bitmask_y	(bitmask_y),
	// Outputs.
	.clamp		(clamp_lr), 
	.new_x		(lr_x), 
	.new_y		(lr_y),
	.new_x_d	(lr_x_d), 
	.new_y_d	(lr_y_d)
	);

wire	[14:0]	ul_tag_adr_rd;	// Upper left tag address.
wire	[14:0]	ll_tag_adr_rd;	// Lower left tag address.
wire	[14:0]	ur_tag_adr_rd;	// Upper right tag address.
wire	[14:0]	lr_tag_adr_rd;	// Lower right tag address.

assign	ul_tag_adr_rd = {ul_x_d[8:3], ul_y_d};
assign	ll_tag_adr_rd = {ll_x_d[8:3], ll_y_d};
assign	ur_tag_adr_rd = {ur_x_d[8:3], ur_y_d};
assign	lr_tag_adr_rd = {lr_x_d[8:3], lr_y_d};


//
// xx_tag_adr = {u[8:3],v[8:0]}
//               [14:9], [8:0] 
//
always @* begin
	case(bpt_d)
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
  		casex ({ul_tag_adr_bpt[0],ul_tag_adr_rd[0],ur_tag_adr_bpt[0]})
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

  // Delay the uv push by one cycle.
  // and clip, mipmap, exact.
  always @(posedge de_clk) begin
    push_uv_dd        <= push_uv_d;
    push_uv_d         <= push_uv;
    current_clip_dd   <= current_clip_d;
    current_clip_d    <= current_clip;
    current_mipmap_dd <= current_mipmap_d;
    current_mipmap_d  <= current_mipmap;
    current_exact_dd  <= current_exact_d;
    current_exact_d   <= current_exact;
    bpt_dd 	      <= bpt_d;
    tfmt_dd 	      <=tfmt_d;
    pal_mode_dd       <= pal_mode_d;       
  end

endmodule



