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
//  Title       :  3D Top Level
//  File        :  de3d_top.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This is the top level of the 3D logic.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//  u_de3d_reg          de3d_reg        3D Register Block
//  u_des_top           des_top         Setup Engine
//  u_sfifo_32x256_xy   ssi_sfifo       Synchronous FIFO
//  u_sfifo_32x256_argb ssi_sfifo       Synchronous FIFO
//  u_sfifo_32x256_spec ssi_sfifo       Synchronous FIFO
//  u_sfifo_32x256_fog  ssi_sfifo       Synchronous FIFO
//  u_sfifo_32x256_z    ssi_sfifo       Synchronous FIFO
//  u_sfifo_32x256_uv   ssi_sfifo       Synchronous FIFO
//  u_de3d_tc_top       de3d_tc_top     Texture Cache Top Level
//  u_ded_texel_pipe    de3d_texel_pipe Texel Pipeline
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

module de3d_top
  #
  (
   parameter fract = 9,
   parameter BYTES = 4
   )	
  (
   input 		  hb_clk,
   input 		  hb_rstn,
   input [31:0] 	  hb_din,
   input [8:2] 		  dlp_adr,
   input [8:2] 		  hb_adr_r,
   input 		  hb_wstrb,
   input [3:0] 		  hb_ben,
   input 		  hb_cp_csn,
   output [31:0] 	  cp_hb_dout,

   input 		  de_clk,  // setup engine clock.
   input 		  de_rstn, // setup engine reset.
   // 2D Engine Interface.
   input [31:0] 	  back_2,
   input [31:0] 	  fore_2,
   input 		  solid_2,
   input [1:0] 		  ps_15,
   input [1:0] 		  ps_2,
   input 		  trnsp_2,
   input 		  mcrdy,
   input [1:0] 		  stpl_2,
   input 		  stpl_pk_1,
   input 		  apat32_2,
   input 		  nlst_2,
   input 		  mw_fip,
   input 		  pal_load,
   input 		  tc_inv_cmd,
   input [2:0] 		  clp_2,
   input [31:0] 	  clptl_2,
   input [31:0] 	  clpbr_2,
   input 		  load_15,
   input 		  load_actvn,
   input 		  l3_fg_bgn,
   // Setup Engine control.
   input 		  go_sup,
   input 		  load_actv_3d,
   input 		  line_actv_3d,
   output 		  sup_done,
   output 		  abort_cmd,
   // 
   // Pixel Cache Interface.
   input 		  pc_busy,
   output 		  pc_valid,
   output 		  pc_fg_bgn,
   output [15:0] 	  pc_x_out,
   output [15:0] 	  pc_y_out,
   output 		  pc_last,
   output 		  pc_msk_last,
   output [31:0] 	  pc_formatted_pixel,
   output reg [31:0] 	  pc_formatted_z,
   output [4:0] 	  pc_z_ctrl,
   output 		  pc_active_3d_2,
   output [7:0] 	  pc_current_alpha,
   output [27:0] 	  pc_zorg_2,
   output [11:0] 	  pc_zptch_2,
   output [20:0] 	  tporg_2, // Texture palette origin

   // MC SIGNALS
   input 		  mclock,
   input 		  mc_tc_ack,
   input 		  mc_tc_push,
   input [(BYTES<<3)-1:0] mc_tc_data,
   input 		  mc_pal_ack,
   input 		  mc_pal_push,
   output 		  mc_tc_req,
   output [5:0] 	  mc_tc_page,
   output [31:0] 	  mc_tc_address,
   output 		  mc_pal_req,
   output 		  mc_pal_half,
   output 		  last_pixel_g0,
   // 3D line increment pattern, to the line pattern register.
   output 		  l3_incpat
   );
  
`include "define_3d.h"
  
  wire		  tc_ready_e;
  
  wire [7:0] 	  tri_wrt;
  wire [31:0] 	  tri_dout;
  
  wire 		  color_mode_15;		// Color Mode 0 = 8888, 1 = float.
  wire 		  rect_15;		// Rectangular Mode.
  wire 		  line_3d_actv_15;
  wire 		  bce_15;			// Back face culling enable.
  wire 		  bc_pol_15;		// Back face culling polarity.
  
  wire [351:0] 	  vertex0_15;
  wire [351:0] 	  vertex1_15;
  wire [351:0] 	  vertex2_15;
  
  wire [15:0] 	  current_x;
  wire [15:0] 	  current_x_g0;
  wire [15:0] 	  current_y;
  wire [15:0] 	  current_y_g0;
  wire [23:0] 	  current_z;
  wire [31:0] 	  current_z_g0;
  wire [(fract-1):0] current_u_fract;
  wire [(fract-1):0] current_v_fract;
  wire [19:0] 	     current_u_g1;
  wire [19:0] 	     current_v_g1;
  wire [31:0] 	     current_argb;
  wire [31:0] 	     current_argb_g0;
  wire [23:0] 	     current_spec;
  wire [23:0] 	     current_spec_g0;
  wire [7:0] 	     current_fog;
  wire [7:0] 	     current_fog_g0;
  wire [3:0] 	     lod_num;
  wire [3:0] 	     lod_num_g2;
  wire [5:0] 	     lod_gamma;
  wire [5:0] 	     lod_gamma_g2;

  wire 		     pop_fog;
  wire 		     pop_xy;
  wire 		     pop_spec;
  wire 		     pop_argb;
  wire 		     pop_z;
  
  wire 		     pipe_busy;
  wire 		     full_argb;

  wire [209:0] 	     lod_2;	// LOD 9, 8, 7, 6, 5, 4, 3, 2, 1, 0  origin
  wire [11:0] 	     tptch_2;	// Texture pitch register output
  wire [31:0] 	     hith_2;	// clipping hither.
  wire [31:0] 	     yon_2;	// clipping yon.
  wire [31:0] 	     fcol_2;	// Fog color
  wire [31:0] 	     texbc_2;	// Texture Boarder Color
  wire [23:0] 	     key3dlo_2;	// Alpha value   register
  wire [23:0] 	     key3dhi_2;	// Alpha value   register
  wire [31:0] 	     c3d_2;	// 3D Control Register
  wire [31:0] 	     tex_2;	// Texture Control Register
  wire [31:0] 	     blendc_2;	// OpenGL blending constant
  wire [23:0] 	     alpha_2;
  wire [17:0] 	     acntrl_2;
  wire [31:0] 	     pptr3d_2;
  wire [7:0] 	     fog_value;
  wire 		     clip;
  wire 		     fg_bgn;
  wire 		     empty_xy;
  wire 		     empty_spec;
  wire 		     empty_argb;
  wire 		     empty_z;
  wire 		     empty_uv;
  wire 		     empty_fog;
  wire [7:0] 	     usedw_xy;
  wire [7:0] 	     usedw_spec;
  wire [7:0] 	     usedw_argb;
  wire [7:0] 	     usedw_z;
  wire [7:0] 	     usedw_uvf;
  wire [7:0] 	     usedw_fog;
  wire [7:0] 	     usedw_tc;
  wire 		     push_xyz_argb_spec;
  wire 		     push_uv;
  // wire		last_pixel_g0;
  wire 		     last_pixel_out;
  wire 		     msk_last_pixel_g0;
  wire 		     msk_last_pixel_out;
  wire 		     fg_bgn_g0;
  wire 		     full_tc;
  wire 		     full_xy;
  wire 		     full_spec;
  wire 		     full_z;
  wire 		     full_fog;
  wire 		     full_uv_g1;
  wire [5:0] 	     current_lod_gamma;
  wire [5:0] 	     current_lod_gamma_g1;
  
  ////////////////////// Texel Cache /////////////////////////////////
  wire [31:0] 	     ul_tex; 	// Texels: 00 == UL
  wire [31:0] 	     ur_tex; 	// Texels: 01 == UR
  wire [31:0] 	     ll_tex; 	// Texels: 10 == LL
  wire [31:0] 	     lr_tex; 	// Texels: 11 == LR
  
  wire [8:0] 	     current_bit_mask_x_g1; 
  wire [8:0] 	     current_bit_mask_y_g1; 
  wire [3:0] 	     current_mipmap_g1; 
  wire 		     current_exact_g1; 
  wire 		     current_clip_g1; 
  
  wire 		     tc_clip;	
  wire [8:0] 	     tc_bit_mask_x; 
  wire [8:0] 	     tc_bit_mask_y; 
  wire [3:0] 	     tc_mipmap; 
  wire 		     tc_exact; 
  wire [10:0] 	     tc_ul_x; 
  wire [10:0] 	     tc_ul_y;
  wire 		     tc_ack; 
  wire 		     texel_pipe_valid;
  wire 		     clip_g0;
  wire 		     tc_fetch_n;
  wire 		     tc_ready;
  wire 		     tc_busy;
  wire [4:0] 	     z_ctrl;
  
  /////////////////// FIX ME /////////////////////

  de3d_reg u_de3d_reg 
    (
     // Host Interface.
     .hb_rstn		(hb_rstn),
     .hb_clk		(hb_clk),
     .hb_din_p		(hb_din),
     .hb_adr_p		(dlp_adr),
     .hb_adr_r		(hb_adr_r),
     .hb_wstrb_p	(hb_wstrb),
     .hb_ben_p		(hb_ben),
     .hb_cp_csn		(hb_cp_csn),
     .de_clk		(de_clk),
     .de_rstn		(de_rstn),
     .go_sup		(go_sup),
     .load_actv_3d	(load_actv_3d),		// Transfer parameters from level 15 to level 2.
     .ps_15		(ps_15),
     // Outputs.
     // Level 1.5 signals to the setup engine.
     .vertex0_15	(vertex0_15),		// Vertex 0.
     .vertex1_15	(vertex1_15),		// Vertex 1.
     .vertex2_15	(vertex2_15),		// Vertex 2.
     .bc_pol_15		(bc_pol_15),
     .color_mode_15	(color_mode_15),	// 0 = ARGB, 1 = Float.
     .bce_15		(bce_15),		// Backface Cull enable
     .rect_15		(rect_15),
     .line_3d_actv_15	(line_3d_actv_15),
     .load_15		(load_15),
     .load_actvn	(load_actvn),
     // Level 2 signals to the pipe line.
     .lod_2		(lod_2),		// LOD 9, 8, 7, 6, 5, 4, 3, 2, 1, 0  origin
     .zorg_2		(pc_zorg_2),        	// Z origin pointer
     .zptch_2		(pc_zptch_2),		// Z pitch register output
     .tporg_1		(tporg_2),       	// Texture palette origin
     .tptch_2		(tptch_2),		// Texture pitch register output
     .hith_2		(hith_2),		// clipping hither.
     .yon_2		(yon_2),		// clipping yon.
     .fcol_2		(fcol_2),        	// Fog color
     .texbc_2		(texbc_2),       	// Texture Boarder Color
     .key3dlo_2		(key3dlo_2),     	// Alpha value   register
     .key3dhi_2		(key3dhi_2),     	// Alpha value   register
     .c3d_2		(c3d_2),         	// 3D Control Register
     .tex_2		(tex_2),         	// Texture Control Register
     .blendc_2		(blendc_2),		// OpenGL blending constant
     .alpha_2		(alpha_2),
     .acntrl_2		(acntrl_2),
     .pptr3d_2		(pptr3d_2),		// Pattern Pointer 3D output XY1 or CP1
     .actv_3d_2		(pc_active_3d_2),
     // Host read back data.
     .cp_hb_dout	(cp_hb_dout)
     );

  des_top u_des_top
    (
     .se_clk		(de_clk),
     .se_rstn		(de_rstn),
     .go_sup		(go_sup),
     .color_mode_15	(color_mode_15),
     .solid_2		(solid_2),
     .stpl_2		(stpl_2),
     .stpl_pk_1		(stpl_pk_1),
     .apat32_2		(apat32_2),
     .nlst_2		(nlst_2),
     .l3_fg_bgn	        (l3_fg_bgn),
     .mw_fip		(mw_fip),
     .pipe_busy		(pipe_busy),
     .mcrdy		(mcrdy),
     .load_actv_3d	(load_actv_3d),
     .vertex0_15	(vertex0_15),
     .vertex1_15	(vertex1_15),
     .vertex2_15	(vertex2_15),
     .rect_15		(rect_15),
     .line_3d_actv_15	(line_3d_actv_15),
     .bce_15		(bce_15),
     .bc_pol_15		(bc_pol_15),
     // Level 2 Signals, post setup.
     .c3d_2		(c3d_2),         	// 3D Control Register
     .tex_2		(tex_2),         	// Texture Control Register
     .hith_2		(hith_2),		// clipping hither.
     .yon_2		(yon_2),		// clipping yon.
     .clp_2		(clp_2),
     .clptl_2		(clptl_2),
     .clpbr_2		(clpbr_2),
     // Outputs.
     .tri_wrt		(tri_wrt),
     .tri_dout		(tri_dout),
     .sup_done		(sup_done),
     .abort_cmd		(abort_cmd),
     // Output to FIFOs
     // FIFO input group zero
     .valid_z_col_spec	(push_xyz_argb_spec),
     .last_pixel	(last_pixel_g0),
     .msk_last_pixel	(msk_last_pixel_g0),
     .current_x		(current_x_g0),
     .current_y		(current_y_g0),
     .current_z		(current_z_g0),
     .current_argb	(current_argb_g0),
     .current_spec	(current_spec_g0),
     .current_fog	(current_fog_g0),
     .clip_xy		(clip_g0),
     .clip_uv		(current_clip_g1), 
     .current_fg_bgn	(fg_bgn_g0),
     // FIFO input group one
     .valid_uv		(push_uv),
     .current_u		(current_u_g1),
     .current_v		(current_v_g1),
     .current_bit_mask_x(current_bit_mask_x_g1), 
     .current_bit_mask_y(current_bit_mask_y_g1), 
     .current_exact	(current_exact_g1), 
     .lod_num		(current_mipmap_g1), 
     .lod_gamma		(current_lod_gamma_g1),
     // 3D line increment pattern, to the line pattern register.
     .l3_incpat		(l3_incpat)
     );

  // Current X and Current Y FIFO.
  ssi_sfifo 
    #
    (
     .WIDTH		(36),
     .DEPTH		(256),
     .DLOG2		(8),
     .AFULL		(192)
     )
  u_sfifo_32x256_xy
    (
     .data		({clip_g0, fg_bgn_g0, last_pixel_g0, 
			  msk_last_pixel_g0, current_x_g0, current_y_g0}),
     .wrreq		(push_xyz_argb_spec),
     .rdreq		(pop_xy),
     .clock		(de_clk),
     .aclr		(~de_rstn),
     .q			({clip, fg_bgn, last_pixel_out, 
			  msk_last_pixel_out, current_x, current_y}),
     .full		(),
     .empty		(empty_xy),
     .usedw		(usedw_xy),
     .almost_full	(full_xy)
     );
  
  // Current ARGB.
  ssi_sfifo 
    #
    (
     .WIDTH		(32),
     .DEPTH		(256),
     .DLOG2		(8),
     .AFULL		(192)
     )
  u_sfifo_32x256_argb
    (
     .data		(current_argb_g0),
     .wrreq		(push_xyz_argb_spec),
     .rdreq		(pop_argb),
     .clock		(de_clk),
     .aclr		(~de_rstn),
     .q			(current_argb),
     .full		(),
     .empty		(empty_argb),
     .usedw		(usedw_argb),
     .almost_full	(full_argb)
     );

  // Current Fog and Specular.
  ssi_sfifo 
    #
    (
     .WIDTH		(24),
     .DEPTH		(256),
     .DLOG2		(8),
     .AFULL		(192)
     )
  u_sfifo_24x256_spec
    (
     .data		(current_spec_g0),
     .wrreq		(push_xyz_argb_spec),
     .rdreq		(pop_spec),
     .clock		(de_clk),
     .aclr		(~de_rstn),
     .q			(current_spec),
     .full		(),
     .empty		(empty_spec),
     .usedw		(usedw_spec),
     .almost_full	(full_spec)
     );

  // Current Fog
  ssi_sfifo 
    #
    (
     .WIDTH		(8),
     .DEPTH		(256),
     .DLOG2		(8),
     .AFULL		(192)
     )
  u_sfifo_8x256_fog
    (
     .data		(current_fog_g0),
     .wrreq		(push_xyz_argb_spec),
     .rdreq		(pop_fog),
     .clock		(de_clk),
     .aclr		(~de_rstn),
     .q			(current_fog),
     .full		(),
     .empty		(empty_fog),
     .usedw		(usedw_fog),
     .almost_full	(full_fog)
     );
  
  always @* pc_formatted_z = {8'h0, current_z};

  // Current Z FIFO.
  ssi_sfifo 
    #
    (
     .WIDTH		(29),
     .DEPTH		(256),
     .DLOG2		(8),
     .AFULL		(192)
     )
  u_sfifo_32x256_z
    (
     .data		({c3d_2[1], c3d_2[0], c3d_2[7:5], current_z_g0[31:8]}),
     .wrreq		(push_xyz_argb_spec),
     .rdreq		(pop_z),
     .clock		(de_clk),
     .aclr		(~de_rstn),
     .q			({ z_ctrl, current_z}),
     .full		(),
     .empty		(empty_z),
     .usedw		(usedw_z),
     .almost_full	(full_z)
     );

  assign pc_z_ctrl = {5{pc_active_3d_2}} & z_ctrl;
  // assign pc_z_ctrl = (z_ctrl[2:0] == 3'b000) ? {5{pc_active_3d_2}} & {z_ctrl[4:3], 3'b001} :
  //					     {5{pc_active_3d_2}} & z_ctrl;
  
  // Current UV fraction.
  ssi_sfifo 
    #
    (
     .WIDTH		((6+(2*fract))),
     .DEPTH		(256),
     .DLOG2		(8),
     .AFULL		(192)
     )
  u_sfifo_uv
    (
     .wrreq		(push_uv & tex_2`T_TM),
     .data		({ current_lod_gamma_g1, current_u_g1[(fract-1):0], 
			   current_v_g1[(fract-1):0]}),
     //
     .rdreq		(tc_ready_e),
     .clock		(de_clk),
     .aclr		(~de_rstn),
     .q			({ current_lod_gamma, current_u_fract, 
			   current_v_fract}),
     .empty		(empty_uv),
     .usedw		(usedw_uvf),
     .full		(),
     .almost_full	(full_uv_g1)
     );

  assign pipe_busy = full_xy | full_spec | full_argb | full_z | 
		     full_uv_g1 | full_tc | full_fog;

  // Texture Cache.
  de3d_tc_top 
    #(.BYTES (BYTES))
  u_de3d_tc_top
    (
     // Inputs.
     .de_clk		(de_clk),		// Clock for Drawing Engine
     .de_rstn		(de_rstn),		// Reset for Drawing Engine
     .pc_busy		(pc_busy),		// Pixel Cache Busy.
     .push_uv		(push_uv),		// push UV.
     .tex_2		(tex_2),		// Texture Control register.
     .current_clip_g1	(current_clip_g1), 	// When high, return a de_ack   
     .current_bit_mask_x_g1 (current_bit_mask_x_g1),	// Mask for X size of bitmap
     .current_bit_mask_y_g1(current_bit_mask_y_g1),	// Mask for Y size of bitmap	
     .current_mipmap_g1	(current_mipmap_g1),     // mipmap we are currently on      
     .current_exact_g1	(current_exact_g1),	 // only fetch one texel at ul_x,ul_y
     .current_u_g1	(current_u_g1[19:9]),	// Upper left texel (U) x
     .current_v_g1	(current_v_g1[19:9]),	// Upper left texel (V) y, allows for 512x512 texels
     .lod_2		(lod_2),		// LOD [9:0]
     .tc_inv		(tc_inv_cmd),		// Invalidate texel cache	
     .pal_load		(pal_load),     	// Load the palette                    
     .tptch		(tptch_2),        	// Texture pitch to be sent to DEM
     .boarder_color	(texbc_2),		// boarder color (3rd pipe stage)
     // Outputs.
     .usedw_tc		(usedw_tc),
     .full_tc		(full_tc),
     .tc_ack		(tc_ack),		// Texture cache ack's uv load
     .tc_ready		(tc_ready),		// Texture cache ack's uv load
     .tc_ready_e	(tc_ready_e),		// Texture cache ack's uv load
     .tc_busy		(tc_busy),      	// Texel cache is busyto DE during load
     .ul_tex		(ul_tex),       	// Upper left texel
     .ll_tex		(ll_tex),       	// Lower left texel
     .ur_tex		(ur_tex),       	// Upper right texel
     .lr_tex		(lr_tex),       	// Lower right texel
     // 
     .mclock		(mclock),		// Memory Clock
     .mc_tc_ack		(mc_tc_ack),
     .mc_tc_push	(mc_tc_push),		// Texture Push from MC
     .mc_tc_data	(mc_tc_data),     	// for level 2 cache
     .mc_pal_push       (mc_pal_push),
     .mc_pal_ack        (mc_pal_ack),
     // Outputs.
     .mc_tc_req		(mc_tc_req),
     .mc_tc_page	(mc_tc_page),
     .mc_tc_address	(mc_tc_address),
     .mc_pal_req        (mc_pal_req),
     .mc_pal_half       (mc_pal_half)
     );
  
  assign texel_pipe_valid = (tex_2`T_TM) ? tc_ready : (~empty_argb & ~pc_busy); 

  de3d_texel_pipe
    #(.fract (fract))
  u_ded_texel_pipe
    (
     .de_clk		(de_clk),
     .de_rstn		(de_rstn),
     .pix_valid		(texel_pipe_valid), // tc_ready),
     .clip		(clip),
     .last		(last_pixel_out),
     .msk_last		(msk_last_pixel_out),
     .fg_bgn		(fg_bgn),
     .current_x		(current_x),
     .current_y		(current_y),
     .current_argb	(current_argb),
     .current_spec	(current_spec),
     .current_fog	(current_fog),
     .c3d_2		(c3d_2),         	// 3D Control Register
     .tex_2		(tex_2),         	// Texture Control Register
     .current_u		(current_u_fract),
     .current_v		(current_v_fract),
     .current_gamma	(current_lod_gamma),
     .ul_tex		(ul_tex),
     .ur_tex		(ur_tex),
     .ll_tex		(ll_tex),
     .lr_tex		(lr_tex),
     // From the 2D Core.
     .ps_2		(ps_2),
     .alpha_2		(alpha_2),
     .acntrl_2		(acntrl_2),
     .fog_value		(fcol_2),
     .key_low		(key3dlo_2),
     .key_hi		(key3dhi_2),
     .pc_busy		(pc_busy),
     // 3D Control.
     // Outputs.
     // These will go to the pixel cache.
     .formatted_pixel	(pc_formatted_pixel),
     .current_alpha	(pc_current_alpha),
     .x_out		(pc_x_out),
     .y_out		(pc_y_out), 
     .pc_valid		(pc_valid),
     .pc_last		(pc_last),
     .pc_msk_last	(pc_msk_last),
     .pc_fg_bgn		(pc_fg_bgn),
     // Pop Fragments..
     .pop_xy		(pop_xy),
     .pop_spec		(pop_spec),
     .pop_argb		(pop_argb),
     .pop_z		(pop_z),
     .pop_fog		(pop_fog)
     );
  
  /*
   reg failed_sig;
   always @(posedge de_clk) begin
   failed_sig = 0;
   if(pc_valid & ((pc_x_out == 16'd128) & (pc_y_out == 16'd118))) begin
   $display("FAILED");
   failed_sig = 1;
   $stop;
		end
	end
   */
  
endmodule
