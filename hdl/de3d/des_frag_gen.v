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
//  Title       :  Drawing Engine Setup Fragment Generation
//  File        :  des_frag_gen.v
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

module des_frag_gen
  (
   input 		clk,
   input 		rstn,
   input 		ld_frag,
   input 		last_frag,
   input 		msk_last_frag,
   input 		scan_dir_2,
   input [2:0] 		clp_2,
   input [31:0] 	clptl_2,
   input [31:0] 	clpbr_2,
   input [31:0] 	tex_2,
   input [31:0] 	c3d_2,
   input [31:0] 	start_x_fp_2,
   input [31:0] 	start_y_fp_2,
   input [31:0] 	end_x_fp_2,
   input [31:0] 	end_y_fp_2,
   input [15:0] 	current_x_fx, // 16.0 
   input [15:0] 	current_y_fx, // 16.0
   input [95:0] 	z_cmp_fp, 
   input [95:0] 	w_cmp_fp, 
   input [95:0] 	uw_cmp_fp, 
   input [95:0] 	vw_cmp_fp, 
   input [95:0] 	a_cmp_fp,
   input [95:0] 	r_cmp_fp, 
   input [95:0] 	g_cmp_fp, 
   input [95:0] 	b_cmp_fp, 
   input [95:0] 	f_cmp_fp, 
   input [95:0] 	rs_cmp_fp, 
   input [95:0] 	gs_cmp_fp, 
   input [95:0] 	bs_cmp_fp, 
   input [31:0] 	hith_2,
   input [31:0] 	yon_2,
   input 		fg_bgn,

   output 		last_pixel,
   output 		msk_last_pixel,
   output 		valid_z_col_spec,
   output 		valid_uv,
   output [15:0] 	x_cur_o,
   output [15:0] 	y_cur_o, 
   output [31:0] 	z_cur_fx, 
   output [19:0] 	current_u, 
   output [19:0] 	current_v, 
   output [31:0] 	current_argb,
   output [23:0] 	current_spec,
   output [7:0] 	current_fog,
   output [3:0] 	lod_num,
   output [5:0] 	lod_gamma,
   output 		clip_xy,
   output 		clip_uv,
   output reg 		addr_exact,
   output reg [8:0] 	bit_mask_x,
   output reg [8:0] 	bit_mask_y,
   // Start/End Point for 3D line.
   output [15:0] 	l3_cpx0,
   output [15:0] 	l3_cpy0,
   output [15:0] 	l3_cpx1,
   output [15:0] 	l3_cpy1,
   output 		current_fg_bgn,
   // Signal tap.
   output signed [15:0] x_cur_e,
   output signed [15:0] y_cur_e 
   );

`include "define_3d.h"

  // Hither and Yon Comparisons
  parameter       
    NEVER    = 3'b000,	// If Z_Enabled, CLIP
    ALWAYS   = 3'b001,	// Always Draw, so NOT_CLIP
    LESS     = 3'b010,	// Z <  Hither or Yon
    LEQUAL   = 3'b011,	// Z <= Hither or Yon
    EQUAL    = 3'b100,	// Z == Hiter or Yon
    GEQUAL   = 3'b101,	// Z >= Hiter or Yon
    GREATER  = 3'b110,	// Z >  Hiter or Yon
    NOTEQUAL = 3'b111;	// Z != Hiter or Yon


  wire [3:0] 		lod_num_a;
  reg [3:0] 		lod_num_d;
  reg [3:0] 		lod_num_dd;
  reg [5:0] 		lod_gamma_d;
  reg [5:0] 		lod_gamma_dd;
  reg 			magnification_d; 
  reg 			magnification_dd; 
  
  reg [31:0] 		dx_fx;
  reg [31:0] 		dy_fx;
  wire [31:0] 		dx_fx_d;
  wire [31:0] 		dy_fx_d;
  reg [8:0] 		largest_u_size;
  reg [8:0] 		largest_v_size;
  reg [24:0] 		frag_pipe;
  reg [15:0] 		last_frag_pipe;
  reg [15:0] 		msk_last_frag_pipe;
  reg [13:0] 		uv_clip_pipe;
  reg [8:0] 		fg_bgn_pipe;
  
  wire [31:0] 		start_x_fx;
  wire [31:0] 		start_y_fx;
  wire [31:0] 		end_x_fx;
  wire [31:0] 		end_y_fx;
  
  assign l3_cpx0 = start_x_fx[31:16];
  assign l3_cpy0 = start_y_fx[31:16];
  assign l3_cpx1 = end_x_fx[31:16];
  assign l3_cpy1 = end_y_fx[31:16];
  
  // T2R4 Calculation.
  // 11.9
  wire [31:0] 		uwx_cur_fp;
  wire [31:0] 		uwy_cur_fp;
  wire [31:0] 		vwx_cur_fp;
  wire [31:0] 		vwy_cur_fp;
  
  wire [31:0] 		ux_cur_fp;
  wire [31:0] 		uy_cur_fp;
  wire [31:0] 		vx_cur_fp;
  wire [31:0] 		vy_cur_fp;
  
  reg [31:0] 		u_cur_fp_1; 
  reg [31:0] 		u_cur_fp_0; 
  reg [31:0] 		v_cur_fp_1; 
  reg [31:0] 		v_cur_fp_0; 
  
  wire [31:0] 		wx_cur_fp;
  wire [31:0] 		wy_cur_fp;
  wire [31:0] 		rwx_cur_fp;
  wire [31:0] 		rwy_cur_fp;
  
  wire [31:0] 		u_cur_fx_d; 
  wire [31:0] 		v_cur_fx_d; 
  // 
  // 23.9
  reg [31:0] 		u_cur_fx; 
  reg [31:0] 		v_cur_fx; 
  reg [31:0] 		ux_cur_fx; 
  reg [31:0] 		uy_cur_fx; 
  reg [31:0] 		vx_cur_fx; 
  reg [31:0] 		vy_cur_fx; 
  reg [31:0] 		udx_fx;
  reg [31:0] 		udy_fx;
  reg [31:0] 		vdx_fx;
  reg [31:0] 		vdy_fx;
  reg [31:0] 		udx_a;
  reg [31:0] 		udy_a;
  reg [31:0] 		vdx_a;
  reg [31:0] 		vdy_a;
  
  reg signed [31:0] 	max_x;		// 23.9
  reg signed [31:0] 	max_y;		// 23.9
  reg [31:0] 		fCoverage;	// 23.9
  reg [31:0] 		u_addr_shifted;
  reg [31:0] 		v_addr_shifted;
  reg [31:0] 		u_final_address;
  reg [31:0] 		v_final_address;
  wire [31:0] 		w_cur_fp; 
  wire [31:0] 		rw_cur_fp; 
  wire [31:0] 		uw_cur_fp_d; 
  wire [31:0] 		vw_cur_fp_d; 
  wire [31:0] 		u_cur_fp; 
  wire [31:0] 		v_cur_fp; 
  //
  // reg [33:0]	lenx;
  // reg [33:0]	leny;
  // reg [33:0] 	lenx_a;		// 12.10
  // reg [33:0]	lenx_b;		// 12.10
  // reg [33:0] 	leny_a;		// 12.10
  // reg [33:0]	leny_b;		// 12.10
  wire [9:0] 		fLOD;		// 12.10
  wire [31:0] 		z_cur_fp; 
  wire [31:0] 		uw_cur_fp; 
  wire [31:0] 		vw_cur_fp; 
  wire [31:0] 		a_cur_fp;
  wire [31:0] 		r_cur_fp; 
  wire [31:0] 		g_cur_fp; 
  wire [31:0] 		b_cur_fp; 
  wire [31:0] 		f_cur_fp; 
  wire [31:0] 		rs_cur_fp; 
  wire [31:0] 		gs_cur_fp; 
  wire [31:0] 		bs_cur_fp; 
  
  wire [7:0] 		a_cur_fx;
  wire [7:0] 		r_cur_fx; 
  wire [7:0] 		g_cur_fx; 
  wire [7:0] 		b_cur_fx; 
  wire [7:0] 		f_cur_fx; 
  wire [7:0] 		rs_cur_fx; 
  wire [7:0] 		gs_cur_fx; 
  wire [7:0] 		bs_cur_fx; 
  
  wire signed [15:0] 	xmin; 
  wire signed [15:0] 	ymin; 
  wire signed [15:0] 	xmax; 
  wire signed [15:0] 	ymax; 
  // wire signed [15:0]	x_cur_e;
  // wire signed [15:0]	y_cur_e; 
  wire 			clip; 
  
  reg 			xl_xmin; 
  reg 			xmaxl_x;
  reg 			ymaxl_y; 
  reg 			yl_ymin;
  wire [3:0] 		out_code;
  
  reg signed [15:0] 	xmin_uv; 
  reg signed [15:0] 	ymin_uv; 
  reg signed [15:0] 	xmax_uv; 
  reg signed [15:0] 	ymax_uv; 
  wire 			uv_clip; 
  
  reg 			xl_xmin_uv; 
  reg 			xmaxl_x_uv;
  reg 			ymaxl_y_uv; 
  reg 			yl_ymin_uv;
  wire [3:0] 		out_code_uv;
  
  
  flt_fx u0_flt_fx(start_x_fp_2, start_x_fx); // 16.16
  flt_fx u1_flt_fx(start_y_fp_2, start_y_fx); // 16.16
  flt_fx u2_flt_fx(end_x_fp_2, end_x_fx); // 16.16
  flt_fx u3_flt_fx(end_y_fp_2, end_y_fx); // 16.16
  

  always @(posedge clk, negedge rstn)
    if(!rstn) begin
      dx_fx <= 32'h0;
      dy_fx <= 32'h0;
      frag_pipe <= 25'h0;
      last_frag_pipe <= 16'h0;
      msk_last_frag_pipe <= 16'h0;
      uv_clip_pipe <= 14'h0;
      fg_bgn_pipe <= 11'h0;
    end else begin
      dx_fx <= {current_x_fx, 16'h0} - start_x_fx;
      dy_fx <= {current_y_fx, 16'h0} - start_y_fx;
      frag_pipe <= {frag_pipe[23:0], ld_frag};
      last_frag_pipe <= {last_frag_pipe[14:0], (last_frag & ld_frag)};
      msk_last_frag_pipe <= {msk_last_frag_pipe[14:0], msk_last_frag};
      uv_clip_pipe <= {uv_clip_pipe[12:0], uv_clip};
      fg_bgn_pipe <= {fg_bgn_pipe[7:0], fg_bgn};
    end
  
  assign last_pixel = last_frag_pipe[8];
  assign msk_last_pixel = msk_last_frag_pipe[8];
  assign valid_z_col_spec = frag_pipe[8];
  assign valid_uv = frag_pipe[24];
  assign clip_xy = clip;
  assign clip_uv = uv_clip_pipe[13];
  assign current_fg_bgn = fg_bgn_pipe[8];
  
  gen_pipe_1 #(32, 9) xy_gen_pipe
    (
     .clk	(clk), 
     .din	({current_x_fx, current_y_fx}), 
     .dout_1	({x_cur_e, y_cur_e}),	// One cycle early.
     .dout	({x_cur_o, y_cur_o})
     );
  
  /////////////////// 2D Clipping ///////////////////////////////////
      //
  assign xmin = clptl_2[31:16];
  assign ymin = clptl_2[15:0];
  assign xmax = clpbr_2[31:16];
  assign ymax = clpbr_2[15:0];
  
  always @(posedge clk) begin
    if(x_cur_e < xmin)	xl_xmin <= 1'b1;
    else 		xl_xmin <= 1'b0;
    if(xmax < x_cur_e)	xmaxl_x <= 1'b1;
    else 		xmaxl_x <= 1'b0;
    if(ymax < y_cur_e)	ymaxl_y <= 1'b1;
    else 		ymaxl_y <= 1'b0;
    if(y_cur_e < ymin)	yl_ymin <= 1'b1;
    else 		yl_ymin <= 1'b0;
  end
  
  assign out_code = {xl_xmin, xmaxl_x, ymaxl_y, yl_ymin};
  
  assign clip = ((clp_2[1:0] == 2'b10) && (out_code != 4'b0000)) ? 1'b1 :
		((clp_2[1:0] == 2'b11) && (out_code == 4'b0000)) ? 1'b1 : 1'b0;
  
  // UV must have additional space
  always @(posedge clk)
    if(clp_2[1:0] == 2'b10) begin
      xmin_uv <= clptl_2[31:16] - 16'h1;
      ymin_uv <= clptl_2[15:0]  - 16'h1;
      xmax_uv <= clpbr_2[31:16] + 16'h1;
      ymax_uv <= clpbr_2[15:0]  + 16'h1;
    end else begin
      xmin_uv <= clptl_2[31:16] + 16'h1;
      ymin_uv <= clptl_2[15:0]  + 16'h1;
      xmax_uv <= clpbr_2[31:16] - 16'h1;
      ymax_uv <= clpbr_2[15:0]  - 16'h1;
    end

  always @(posedge clk) begin
    if(x_cur_e < xmin_uv)	xl_xmin_uv <= 1'b1;
    else 			xl_xmin_uv <= 1'b0;
    if(xmax_uv < x_cur_e)	xmaxl_x_uv <= 1'b1;
    else 			xmaxl_x_uv <= 1'b0;
    if(ymax_uv < y_cur_e)	ymaxl_y_uv <= 1'b1;
    else 			ymaxl_y_uv <= 1'b0;
    if(y_cur_e < ymin_uv)	yl_ymin_uv <= 1'b1;
    else 			yl_ymin_uv <= 1'b0;
  end
  
  assign out_code_uv = {xl_xmin_uv, xmaxl_x_uv, ymaxl_y_uv, yl_ymin_uv};
  
  assign uv_clip = ((clp_2[1:0] == 2'b10) && (out_code_uv != 4'b0000)) ? 1'b1 :
	           ((clp_2[1:0] == 2'b11) && (out_code_uv == 4'b0000)) ? 1'b1 : 1'b0;
  
  /////////////////// 3D ///////////////////////////////////
  des_comp_gen u_des_comp_gen_w
    (
     // Inputs.
     .clk		(clk),
     .rstn		(rstn),
     .dx_fx		(dx_fx),
     .dy_fx		(dy_fx),
     .cmp_i		(w_cmp_fp), 
     // Outputs.
     .curr_i		(rw_cur_fp) 
     );
  
  des_comp_gen u_des_comp_gen_u
    (
     // Inputs.
     .clk		(clk),
     .rstn		(rstn),
     .dx_fx		(dx_fx),
     .dy_fx		(dy_fx),
     .cmp_i		(uw_cmp_fp), 
     // Outputs.
     .curr_i		(uw_cur_fp) 
     );
  
des_comp_gen u_des_comp_gen_v
  (
   // Inputs.
   .clk		(clk),
   .rstn		(rstn),
   .dx_fx		(dx_fx),
   .dy_fx		(dy_fx),
   .cmp_i		(vw_cmp_fp),
   // Outputs.
   .curr_i		(vw_cur_fp) 
   );
  
  des_comp_gen u_des_comp_gen_z
    (
     // Inputs.
     .clk		(clk),
     .rstn		(rstn),
     .dx_fx		(dx_fx),
     .dy_fx		(dy_fx),
     .cmp_i		(z_cmp_fp), 
     // Outputs.
     .curr_i		(z_cur_fp) 
     );
  
  /*
   // These Do not need to be floats (CHANGE).
   des_comp_gen u_des_comp_gen_argbf_spec[3:0]
   (
   // Inputs.
   .clk		(clk),
   .rstn		(rstn),
   .dx_fx		(dx_fx),
   .dy_fx		(dy_fx),
   .cmp_i		({
   a_cmp_fp,
   r_cmp_fp, 
   g_cmp_fp, 
   b_cmp_fp 
   // f_cmp_fp, 
   // rs_cmp_fp, 
   // gs_cmp_fp, 
   // bs_cmp_fp 
   }),
   // Outputs.
   .curr_i		({
   a_cur_fp,
   r_cur_fp, 
   g_cur_fp, 
   b_cur_fp 
   // f_cur_fp, 
   // rs_cur_fp, 
   // gs_cur_fp, 
   // bs_cur_fp 
   }) 
   );
   
   */
  gen_pipe #(64, 5) argb_gen_pipe(.clk(clk), .din({dx_fx, dy_fx}), .dout({dx_fx_d, dy_fx_d}));
  
  des_comp_gen_fx_color u_des_comp_gen_argb_fspec[7:0]
    (
     // Inputs.
     .clk		(clk),
     .rstn		(rstn),
     .dx_fx		(dx_fx_d),
     .dy_fx		(dy_fx_d),
     .cmp_i		({
			  a_cmp_fp,
			  r_cmp_fp, 
			  g_cmp_fp, 
			  b_cmp_fp, 
			  f_cmp_fp, 
			  rs_cmp_fp, 
			  gs_cmp_fp, 
			  bs_cmp_fp 
			  }),
     // Outputs.
     .curr_i		({
			  a_cur_fx,
			  r_cur_fx, 
			  g_cur_fx, 
			  b_cur_fx, 
			  f_cur_fx, 
			  rs_cur_fx, 
			  gs_cur_fx, 
			  bs_cur_fx 
			  }) 
     );
  
  // Convert to Fixed point.
  // FIXME Check Conversions, FOG
  flt_fx_24p8 u4_flt_fx(z_cur_fp, z_cur_fx);
  
  // flt_fx 	    u5_flt_fx(a_cur_fp, a_cur_fx);
  // flt_fx 	    u6_flt_fx(r_cur_fp, r_cur_fx);
  // flt_fx 	    u7_flt_fx(g_cur_fp, g_cur_fx);
  // flt_fx 	    u8_flt_fx(b_cur_fp, b_cur_fx);
  // flt_fx 	    u9_flt_fx(f_cur_fp, f_cur_fx);
  // flt_fx 	   u10_flt_fx(rs_cur_fp, rs_cur_fx);
  // flt_fx 	   u11_flt_fx(gs_cur_fp, gs_cur_fx);
  // flt_fx 	   u12_flt_fx(bs_cur_fp, bs_cur_fx);
  // assign current_argb = {a_cur_fx[23:16], r_cur_fx[23:16], g_cur_fx[23:16], b_cur_fx[23:16]}; 
  
  
  assign current_argb = {a_cur_fx, r_cur_fx, g_cur_fx, b_cur_fx}; 
  assign current_spec = {rs_cur_fx, gs_cur_fx, bs_cur_fx}; 
  assign current_fog  = f_cur_fx;
  
  //////////////////////////////////////////////////////////////////////////////
  // LOD calculations.
  //
  // Computes level of detail for standard trilinear mipmapping, in which
  // the four texture index gradients are consolidated into a single number
  // to select level of detail.
  //
  // The basic approach is to compute the lengths of the pixel coverage for
  // the X and Y extent of the approximate pixel coverage area.  These two
  // lengths are then combined in for the single LOD result.
  //
  //
  
  // Take the reciprical of RW (6 clocks).
  flt_recip u_flt_recip(.clk(clk), .denom(rw_cur_fp), .recip(w_cur_fp));
  gen_pipe #(64, 6) uv_gen_pipe(.clk(clk), .din({uw_cur_fp, vw_cur_fp}), .dout({uw_cur_fp_d, vw_cur_fp_d}));
  // Multiply UW and VW by 1/W(3 clocks).
  flt_mult u0_flt_mult(clk, rstn, w_cur_fp, uw_cur_fp_d, u_cur_fp);
  flt_mult u1_flt_mult(clk, rstn, w_cur_fp, vw_cur_fp_d, v_cur_fp);
  
  // Calculate previous WX, (3 cycles).
  flt_add_sub u_flt_add_sub_rwx
    (
     .clk		(clk),
     .sub		(~scan_dir_2),
     .afl		(rw_cur_fp), 
     .bfl		(w_cmp_fp[63:32]), 
     .fl		(rwx_cur_fp) 
     );
  
  // Calculate previous WY, (3 cycles).
  flt_add_sub u_flt_add_sub_rwy
    (
     .clk		(clk),
     .sub		(1'b1),
     .afl		(rw_cur_fp), 
     .bfl		(w_cmp_fp[31:0]), 
     .fl		(rwy_cur_fp) 
     );
  
  // Calculate previous UX, (3 cycles).
  flt_add_sub u_flt_add_sub_uwx
    (
     .clk		(clk),
     .sub		(~scan_dir_2),
     .afl		(uw_cur_fp_d), 
     .bfl		(uw_cmp_fp[63:32]), 
     .fl		(uwx_cur_fp) 
     );
  
  // Calculate previous UY, (3 cycles).
  flt_add_sub u_flt_add_sub_uwy
    (
     .clk		(clk),
     .sub		(1'b1),
     .afl		(uw_cur_fp_d), 
     .bfl		(uw_cmp_fp[31:0]), 
     .fl		(uwy_cur_fp) 
     );
  
  // Calculate previous VX, (3 cycles).
  flt_add_sub u_flt_add_sub_vwx
    (
     .clk		(clk),
     .sub		(~scan_dir_2),
     .afl		(vw_cur_fp_d), 
     .bfl		(vw_cmp_fp[63:32]), 
     .fl		(vwx_cur_fp) 
     );
  
  // Calculate previous VY, (3 cycles).
  flt_add_sub u_flt_add_sub_vwy
    (
     .clk		(clk),
     .sub		(1'b1),
     .afl		(vw_cur_fp_d), 
     .bfl		(vw_cmp_fp[31:0]), 
     .fl		(vwy_cur_fp) 
     );
  
  // Six Cycles.
  // 1/WX and 1/WY.
  flt_recip u_flt_recip_wx(.clk(clk), .denom(rwx_cur_fp), .recip(wx_cur_fp));
  flt_recip u_flt_recip_wy(.clk(clk), .denom(rwy_cur_fp), .recip(wy_cur_fp));
  
  // Multiply UW and VW by 1/W(3 clocks).
  flt_mult u_flt_mult_ux(clk, rstn, wx_cur_fp, uwx_cur_fp, ux_cur_fp);
  flt_mult u_flt_mult_uy(clk, rstn, wy_cur_fp, uwy_cur_fp, uy_cur_fp);
  flt_mult u_flt_mult_vx(clk, rstn, wx_cur_fp, vwx_cur_fp, vx_cur_fp);
  flt_mult u_flt_mult_vy(clk, rstn, wy_cur_fp, vwy_cur_fp, vy_cur_fp);
  
  // Convert to Fixed Point (24.24).
  // Need 3 pipline delays.
  always @(posedge clk) begin
    u_cur_fx   <= flt_fx_23p9(u_cur_fp_1); // 24.24
    u_cur_fp_1 <= u_cur_fp_0;
    u_cur_fp_0 <= u_cur_fp;
    v_cur_fx   <= flt_fx_23p9(v_cur_fp_1); // 24.24
    v_cur_fp_1 <= v_cur_fp_0;
    v_cur_fp_0 <= v_cur_fp;
  end
  
  always @* 	      ux_cur_fx = flt_fx_23p9(ux_cur_fp); // 23.9
  always @* 	      uy_cur_fx = flt_fx_23p9(uy_cur_fp); // 23.9
  always @* 	      vx_cur_fx = flt_fx_23p9(vx_cur_fp); // 23.9
  always @* 	      vy_cur_fx = flt_fx_23p9(vy_cur_fp); // 23.9
  
  always @* begin
    // 23.9 - 23.9 = 23.9
    // Calculate the Perspective distance to previous U and V.
    udx_fx = u_cur_fx  - ux_cur_fx;
    udy_fx = u_cur_fx  - uy_cur_fx;
    vdx_fx = v_cur_fx  - vx_cur_fx;
    vdy_fx = v_cur_fx  - vy_cur_fx;
  end
  
  always @(posedge clk) begin
    if(udx_fx[31]) udx_a <= ~udx_fx + 1;
    else udx_a <= udx_fx;
    if(udy_fx[31]) udy_a <= ~udy_fx + 1;
    else udy_a <= udy_fx;
    if(vdx_fx[31]) vdx_a <= ~vdx_fx + 1;
    else vdx_a <= vdx_fx;
    if(vdy_fx[31]) vdy_a <= ~vdy_fx + 1;
    else vdy_a <= vdy_fx;
  end
  
  
  //////////////////////////////////////////////////////////////////////////////
  // Find the largest (T2R4 Method).
  // always @(posedge clk) begin
  always @* begin
    max_x        = (udx_a > vdx_a) ? udx_a : vdx_a;		// 23.9
    max_y        = (udy_a > vdy_a) ? udy_a : vdy_a;		// 23.9
    fCoverage    = (max_x > max_y) ? max_x : max_y;		// 23.9
  end
  
  //////////////////////////////////////////////////////////////////////////////
  // 22.18
  
  // tex_2`T_MLM // trilinear enable.
  // tex_2`T_MLP // trilinear pass.
  
  log2_table u_log2_table
    (
     .clk			(clk), 
     .val			(fCoverage), 	// i[23:9], f[8:0]
     .trilinear_en		(tex_2`T_MLM), 	// Trilinear Enable
     .log2			(fLOD)
     );
  
  reg [3:0] new_mm_no;
  
  // Trilinear Pass Select.
  always @* begin
    if ( (tex_2`T_MLM) & (tex_2`T_MLP) & (|(fLOD[9:6]))) new_mm_no = fLOD[9:6] - 1;
    else new_mm_no = fLOD[9:6];
  end
  
  assign lod_num_a = (tex_2`T_MM & (new_mm_no > tex_2`T_MMN)) ? tex_2`T_MMN :
         	     (tex_2`T_MM) ? new_mm_no : 4'b0000;
  
  /////////////////////////////////////////////////////////////////////////////
  // Shift according to LOD.
  // always @* begin
  
  // Match the delays.
  gen_pipe #(64, 2) uv_cur_gen_pipe(.clk(clk), .din({u_cur_fx, v_cur_fx}), .dout({u_cur_fx_d, v_cur_fx_d}));
  
  always @(posedge clk) begin
    lod_num_d	<= lod_num_a;
    lod_gamma_d	<= (tex_2`T_MM) ? fLOD[5:0] : 6'b000000;
    // lod_gamma_d	<= (tex_2`T_MM) ? 5'b10000 : 5'b00000;
    magnification_d	<= ~|lod_num_a & ~(tex_2`T_MLM);
    u_addr_shifted	<= u_cur_fx_d >> lod_num_a;
    v_addr_shifted	<= v_cur_fx_d >> lod_num_a;
  end
  
  //////////////////////////////////////////////////////////////////////////////
  // Adjust u,v address.
  // always @* begin
  always @(posedge clk) begin
    lod_num_dd	<= lod_num_d;
    lod_gamma_dd	<= lod_gamma_d;
    magnification_dd <= magnification_d;
    casex ({tex_2`T_NMM, tex_2`T_NMG, magnification_d, c3d_2`D3_RSC}) /* synopsys parallel_case full_case */
      // For Bilinear Mode and spac_cent at 0.5, subtract 0.5.
      4'b0x01, 4'bx011:	begin
	u_final_address <= u_addr_shifted - 9'h100;
	v_final_address <= v_addr_shifted - 9'h100;
      end
      // For Bilinear Mode and spac_cent at 1.0, leave address alone.
      4'b0x00, 4'bx010:	begin
	u_final_address <= u_addr_shifted;
	v_final_address <= v_addr_shifted;
      end
      // For Nearest Mode and spac_cent at 0.5, leave address alone.
      4'bx111, 4'b1x01:	begin
	u_final_address <= u_addr_shifted;
	v_final_address <= v_addr_shifted;
      end
      // For Nearest Mode and spac_cent at 1.0, add 0.5
      4'bx110, 4'b1x00:	begin
	u_final_address <= u_addr_shifted + 9'h100;
	v_final_address <= v_addr_shifted + 9'h100;
      end
    endcase
  end
  
  //////////////////////////////////////////////////////////////////////////////
  //
  always @* begin
    if ((tex_2`T_NMM & !magnification_dd) | (tex_2`T_NMG & magnification_dd) | 
	!((|(u_final_address[8:0])) | (|(v_final_address[8:0]))))
      addr_exact = 1'b1;
    else    addr_exact = 1'b0;
  end
  

  //////////////////////////////////////////////////////////////////////////////
  //
  //		Clamping.
  // Decode tex size.
  always @* begin
    casex(tex_2`T_MMSZX) /* synopsys parallel_case */
      4'b0000: largest_u_size = 9'b000000001;
      4'b0001: largest_u_size = 9'b000000001;
      4'b0010: largest_u_size = 9'b000000011;
      4'b0011: largest_u_size = 9'b000000111;
      4'b0100: largest_u_size = 9'b000001111;
      4'b0101: largest_u_size = 9'b000011111;
      4'b0110: largest_u_size = 9'b000111111;
      4'b0111: largest_u_size = 9'b001111111;
      4'b1000: largest_u_size = 9'b011111111;
      4'b1001: largest_u_size = 9'b111111111;
      default: largest_u_size = 9'b111111111;
    endcase
    
    casex(tex_2`T_MMSZY) /* synopsys parallel_case */
      4'b0000: largest_v_size = 9'b000000001;
      4'b0001: largest_v_size = 9'b000000001;
      4'b0010: largest_v_size = 9'b000000011;
      4'b0011: largest_v_size = 9'b000000111;
      4'b0100: largest_v_size = 9'b000001111;
      4'b0101: largest_v_size = 9'b000011111;
      4'b0110: largest_v_size = 9'b000111111;
      4'b0111: largest_v_size = 9'b001111111;
      4'b1000: largest_v_size = 9'b011111111;
      4'b1001: largest_v_size = 9'b111111111;
      default: largest_v_size = 9'b111111111;
    endcase
    
  end
  
  // Bitmask generation
  always @* begin
    bit_mask_x = largest_u_size >> lod_num_dd;
    bit_mask_y = largest_v_size >> lod_num_dd;
  end
  
  //////////////////////////////////////////////////////////////////////////////
  //
  // Speed up u and v final address: 20 bit address 11.9 format
  assign current_u = {u_final_address[31], |(u_final_address[30:18]), u_final_address[17:0]};
  assign current_v = {v_final_address[31], |(v_final_address[30:18]), v_final_address[17:0]};
  assign lod_gamma = lod_gamma_dd;
  assign lod_num   = lod_num_dd;
  
  //////////////////////////////////////////////////////////////////
  // Float to fixed converts floating point numbers to 16.16 sign
  //
  //
  function [47:0] flt_fx_24p24;
    
    input	[31:0]	fp_in;         // Floating point in IEEE fmt
    
    //
    //  23.9, UV.
    //
    reg [7:0] 		bias_exp;       /* Real exponent -127 - 128     */
    reg [7:0] 		bias_exp2;      /* Real exponent 2's comp       */
    reg [47:0] 		bias_mant;      /* mantissa expanded to 16.16 fmt */
    reg [48:0] 		fixed_out;
    
    begin
      bias_mant = {25'h0001, fp_in[22:0]};
      bias_exp = fp_in[30:23] - 'd127;
      bias_exp2 = ~bias_exp + 1;
      
      // infinity or NaN - Don't do anything special, will overflow
      // zero condition
      if (fp_in[30:0] == 31'b0) fixed_out = 0;
      // negative exponent
      else if (bias_exp[7]) fixed_out = bias_mant >> bias_exp2;
      // positive exponent
      else fixed_out = bias_mant << bias_exp;
      flt_fx_24p24 = (fp_in[31]) ? ~{fixed_out[46:0],1'b0} + 1 : {fixed_out[46:0],1'b0};
    end
    
  endfunction
  
  //////////////////////////////////////////////////////////////////
  // Float to fixed converts floating point numbers to 16.16 sign
  //
  //
  function [31:0] flt_fx_23p9;
    
    input	[31:0]	fp_in;         // Floating point in IEEE fmt
    
    //
    //  23.9, UV.
    //
    reg [7:0] 		bias_exp;       /* Real exponent -127 - 128     */
    reg [7:0] 		bias_exp2;      /* Real exponent 2's comp       */
    reg [47:0] 		bias_mant;      /* mantissa expanded to 16.16 fmt */
    reg [47:0] 		int_fixed_out;
    reg [31:0] 		fixed_out;
    
    begin
      bias_mant = {25'h0001, fp_in[22:0]};
      bias_exp = fp_in[30:23] - 8'd127;
      bias_exp2 = ~bias_exp + 8'h1;
      
      // infinity or NaN - Don't do anything special, will overflow
      // zero condition
      if (fp_in[30:0] == 31'b0) int_fixed_out = 0;
      // negative exponent
      else if (bias_exp[7]) int_fixed_out = bias_mant >> bias_exp2;
      // positive exponent
      else int_fixed_out = bias_mant << bias_exp;
      
      fixed_out = int_fixed_out[45:14];
      flt_fx_23p9 = (fp_in[31]) ? ~fixed_out + 1 : fixed_out;
    end
    
  endfunction
  /////////////////////// Hither and Yon Compares ///////////////////////////////
  // Z Stuff
  /*
   always @* begin
   new_z[15:0] = znew[15:0];
   new_hither[15:0] = hither[15:0];
   new_yon[15:0] = yon[15:0];
   
   // 24bpz = 32bpp & zfloat_2
   if (ps32_2) begin
   new_z[23:16] = znew[23:16];			
   new_hither[23:16] = hither[23:16];
   new_yon[23:16] = yon[23:16];
	end
   else begin
   new_z[23:16] = 8'h00;
   new_hither[23:16] = 8'h00;
   new_yon[23:16] = 8'h00;
	end
   
end
   
   //
   // Z Hither and Yon Comparisons
   //
   always @* begin
   if ((z_buf_en) && ((hither_comp_op == NEVER) || (yon_comp_op == NEVER))) begin
   z_clip = 1'b1;
	end
   // else if (hith AND yon ALWAYS OR z_enable_OFF), NOT_clip
   else if ((!z_buf_en) || ((hither_comp_op == ALWAYS) && (yon_comp_op == ALWAYS))) begin
   z_clip = 1'b0;
	end
   // else now check individually:
   // 	start with clip for hith and yon
   // 	if (always) NOT_clip
   //
   else begin
   if (hither_comp_op == ALWAYS) begin		
   hith_1clip = 1'b0;
		end
   else begin
   hith_1clip = 1'b1;
		end
   
   if (yon_comp_op == ALWAYS) begin		
   yon_1clip = 1'b0;
		end
   else begin
   yon_1clip = 1'b1;
		end
   //
   // 	Generate residue value (pos, zero, or neg)
   // 	if (zero && 3 or 4 or 5) NOT_clip
   //
   if ((new_z == new_hither) && ((hither_comp_op >= LEQUAL) && (hither_comp_op) <= GEQUAL)) begin
   hith_345clip = 1'b0;
		end
   else begin
   hith_345clip = 1'b1;
		end			
   if ((new_z == new_yon) && ((yon_comp_op >= LEQUAL) && (yon_comp_op) <= GEQUAL)) begin
   yon_345clip = 1'b0;
		end
   else begin
   yon_345clip = 1'b1;
		end			
   //
   // 	if (pos && 5 or 6 or 7 ) NOT_clip
   //
   if ((new_z > new_hither) && ((hither_comp_op >= GEQUAL) && (hither_comp_op) <= NOTEQUAL)) begin
   hith_567clip = 1'b0;
		end
   else begin
   hith_567clip = 1'b1;
		end			
   if ((new_z > new_yon) && ((yon_comp_op >= GEQUAL) && (yon_comp_op) <= NOTEQUAL)) begin
   yon_567clip = 1'b0;
		end
   else begin
   yon_567clip = 1'b1;
		end			
   
   //
   // 	if (neg && 2 or 3 or 7 ) NOT_clip
   //
   if ((new_z < new_hither) && ((hither_comp_op == LESS) || 
   (hither_comp_op == LEQUAL) || 
   (hither_comp_op) == NOTEQUAL)) begin
   hith_237clip = 1'b0;
		end
   else begin
   hith_237clip = 1'b1;
		end			
   if ((new_z < new_yon) && ((yon_comp_op == LESS) ||
   (yon_comp_op == LEQUAL) || (yon_comp_op) == NOTEQUAL)) begin
   yon_237clip = 1'b0;
		end
   else begin
   yon_237clip = 1'b1;
		end			
   
   //
   // 	if (1clip AND 345clip AND 567clip AND 237clip) 
   //		clip
   //	else	NOT_clip			
   //
   if ( hith_1clip && hith_345clip && hith_567clip && hith_237clip)
   begin
   hither_clip = 1'b1;	
		end
   else begin	
   hither_clip = 1'b0;	
		end
   
   if ( yon_1clip && yon_345clip && yon_567clip && yon_237clip)
   begin
   yon_clip = 1'b1;	
		end
   else begin	
   yon_clip = 1'b0;	
		end
   
   //
   // 	if (NOT_clip_h AND NOT_clip_y) NOT_CLIP
   //
   if ( hither_clip || yon_clip ) begin
   z_clip = 1'b1;	
		end
   else begin	
   z_clip = 1'b0;	
		end
	end
end
   */
  
  
  /////////////////////////// Fog Table /////////////////////////////////////////
  
  
  /*
   /////////////////////////////////////////////////////////////////////////////////////
   // Correct Method.
   // ((11.0f/32.0f)*(uwx_a + vwx_a) + (21.0f/32.0f)*max(uwx_a, vwx_a));
   // 11/32 = 0.34375, 32'h5800.
   // 21/32 = 0.65625, 32'hA800.
   //
   always @* begin
   max_x = (udx_fx > vdx_fx) ? udx_fx : vdx_fx;		// 22.18
   max_y = (udy_fx > vdy_fx) ? udy_fx : vdy_fx;		// 22.18
   sum_x = udx_fx + vdx_fx;				// 22.18
   sum_y = udy_fx + vdy_fx;				// 22.18
   lenx  = lenx_a + lenx_b;				// 24.10
   leny  = leny_a + leny_b;				// 24.10
   fCoverage = (lenx + leny) >> 1; // AVERAGE		// 24.10
	end
   // 24.5 * 0.5 = 24.10
   always @(posedge clk) begin
   begin
   lenx_a <= max_x[33:5] * 5'b10101;
   lenx_b <= sum_x[33:5] * 5'b01011;
   leny_a <= max_y[33:5] * 5'b10101;
   leny_b <= sum_y[33:5] * 5'b01011;
    	end
end
   */
  
endmodule
