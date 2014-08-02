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
//  Title       :  des_top.v
//  File        :  Drawing Engine Setup top.
//  Author      :  Jim MacLeod
//  Created     :  01-Dec-2012
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
//  
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
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module des_top
	(
	input		se_clk,			// setup engine clock.
	input		se_rstn,		// setup engine reset.
	input		go_sup,			// Start setup engine.
	input		color_mode_15,		// Color Mode 0 = 8888, 1 = float.
	input		solid_2,
	input [1:0]	stpl_2,			// [1:0]
	input		stpl_pk_1,
	input		apat32_2,
	input		nlst_2,			// No last for 3D line.
	input		l3_fg_bgn,		// From Line pattern register.
	input		mw_fip,
	input		pipe_busy,
	input		mcrdy,
	input		load_actv_3d,
	// Vertex Buffer Interface.
	input	[351:0]	vertex0_15,
	input	[351:0]	vertex1_15,
	input	[351:0]	vertex2_15,
	input		rect_15,		// Rectangular Mode.
	input		line_3d_actv_15,
	input		bce_15,			// Back face culling enable.
	input		bc_pol_15,		// Back face culling polarity.
	// Post setup parameters.
	input	[31:0]	c3d_2,			// 3D Command Register.
	input	[31:0]	tex_2,			// Texture Command Register.
	input	[31:0]	hith_2,			// Hither.
	input	[31:0]	yon_2,			// Yon.
	input	[2:0]	clp_2,			// Clip Control.
	input	[31:0]	clptl_2,		// Clip Top Left.
	input	[31:0]	clpbr_2,		// Clip Bottom Right.

	output	[7:0]	tri_wrt,		// [7:0]
	output	[31:0]	tri_dout,		// [31:0]
	output 		sup_done,		// Load active triangle command.      
	output 		abort_cmd,		// If ns1 and ns2 = 0 abort command.  

	output		last_pixel,
	output		msk_last_pixel,
	output		valid_z_col_spec,	// Z, Color, and Specular are valid.
	output	[15:0]	current_x,
	output	[15:0]	current_y,
	output	[31:0]	current_z,
	output	[31:0]	current_argb,
	output	[23:0]	current_spec,
	output	[7:0]	current_fog,
	output		clip_xy,
	output		clip_uv,
	output		current_fg_bgn,		// Pattern.
	output		valid_uv,		// Z, Color, and Specular are valid.
	output	[19:0]	current_u,
	output	[19:0]	current_v,
	output	[8:0]	current_bit_mask_x,
	output	[8:0]	current_bit_mask_y,
	output		current_exact,
	output	[3:0]	lod_num,
	output	[5:0]	lod_gamma,
	// Back to line pattern register.	
	output		l3_incpat
	);

	`include "define_3d.h"

	wire	[15:0]	l3_cpx0;		// Line 3D destination x
	wire	[15:0]	l3_cpy0;		// Line 3D destination y
	wire	[15:0]	l3_cpx1;		// Line 3D source x
	wire	[15:0]	l3_cpy1;		// Line 3D source y
	wire	      	fg_bgn;			// Pattern.

	wire	[447:0]	vertex0;
	wire	[447:0]	vertex1;
	wire	[447:0]	vertex2;

	wire	[95:0]	cmp_z_fp;
	wire	[95:0]	cmp_w_fp;
	wire	[95:0]	cmp_uw_fp;
	wire	[95:0]	cmp_vw_fp;
	wire	[95:0]	cmp_a_fp;
	wire	[95:0]	cmp_r_fp;
	wire	[95:0]	cmp_g_fp;
	wire	[95:0]	cmp_b_fp;
	wire	[95:0]	cmp_f_fp;
	wire	[95:0]	cmp_rs_fp;
	wire	[95:0]	cmp_gs_fp;
	wire	[95:0]	cmp_bs_fp;

	wire	      	scan_dir;		// Scan direction.
	wire	      	scan_dir_2;		// Scan direction.
	wire	      	y_major_15;		// Y major.
	wire	      	ns1_eqz_15;		// Number of scan lines edge one equals zero.
	wire	      	ns2_eqz_15;		// Number of scan lines edge two equals zero.

	wire		ld_frag;		// Load Fragment from Execution Unit.
	wire		t3_pixreq;
	wire		l3_pixreq;
	wire		last_frag;
	wire		t3_last_frag;
	wire		l3_last_pixel;

	wire		msk_last_frag;
	wire		t3_msk_last_frag;
	wire		l3_pc_msk_last;

	wire		l3_active;
	wire	[15:0]	current_x_fx;		// Current X position from Execution Unit.
	wire	[15:0]	current_y_fx;		// Current Y position from Execution Unit.
	wire	[15:0]	t3_cpx;			// Current X position from triangle SM.
	wire	[15:0]	t3_cpy;			// Current Y position from triangle SM.
	wire	[15:0]	l3_cpx;			// Current X position from 3D Line SM.
	wire	[15:0]	l3_cpy;			// Current Y position from 3D Line SM.

	wire	[23:0]	y0f;			// Y0 fraction.
	wire	[23:0]	y1f;			// Y1 fraction.
	wire	[23:0]	y2f;			// Y2 fraction.
	wire		y1f_lt_y0f;		// Y1 fraction is less than Y0 fraction.
	wire		y2f_lt_y0f;		// Y1 fraction is less than Y0 fraction.
	wire	[2:0]	ystat;
	wire		ymajor_15;		// Y1 fraction is less than Y0 fraction.
	wire	[31:0]	start_x_fp_2;
	wire	[31:0]	start_y_fp_2;
	wire	[31:0]	end_x_fp_2;
	wire	[31:0]	end_y_fp_2;
	
	assign y1f_lt_y0f = y1f < y0f;
	assign y2f_lt_y0f = y2f < y0f;
	assign ystat[0] = |y0f;
	assign ystat[1] = |y1f;
	assign ystat[2] = |y2f;

	// Vertex 0.
	assign vertex0`VXW = flt_snap_x(vertex0_15`VXW);	// Snap to 1/16.
	assign {y0f, vertex0`VYW} = flt_snap_y(vertex0_15`VYW);	// Snap to 1/16.
	// assign vertex0`VXW = vertex0_15`VXW;	// No Snap
	// assign vertex0`VYW = vertex0_15`VYW;	// No Snap
	// assign y0f = flt_frac(vertex0`VYW);
	//
	assign vertex0`VZW  = vertex0_15`VZW;
	assign vertex0`VWW  = vertex0_15`VWW;
	assign vertex0`VUW  = vertex0_15`VUW;
	assign vertex0`VVW  = vertex0_15`VVW;
	// Vertex 1.
	assign vertex1`VXW = flt_snap_x(vertex1_15`VXW);	// Snap to 1/16.
	assign {y1f, vertex1`VYW} = flt_snap_y(vertex1_15`VYW);	// Snap to 1/16.
	// assign vertex1`VXW = vertex1_15`VXW;	// No Snap
	// assign vertex1`VYW = vertex1_15`VYW;	// No Snap
	// assign y1f = flt_frac(vertex1`VYW);
	//
	assign vertex1`VZW  = vertex1_15`VZW;
	assign vertex1`VWW  = vertex1_15`VWW;
	assign vertex1`VUW  = vertex1_15`VUW;
	assign vertex1`VVW  = vertex1_15`VVW;
	// Vertex 2.
	assign vertex2`VXW = flt_snap_x(vertex2_15`VXW);	// Snap to 1/16.
	assign {y2f, vertex2`VYW} = flt_snap_y(vertex2_15`VYW);	// Snap to 1/16.
	// assign vertex2`VXW = vertex2_15`VXW;	// No Snap
	// assign vertex2`VYW = vertex2_15`VYW;	// No Snap
	// assign y2f = flt_frac(vertex2`VYW);
	//
	assign vertex2`VZW  = vertex2_15`VZW;
	assign vertex2`VWW  = vertex2_15`VWW;
	assign vertex2`VUW  = vertex2_15`VUW;
	assign vertex2`VVW  = vertex2_15`VVW;

/*****************SWAPS FOR 3D LINES*********************************/
// assign p1x_fp = (line_3d_actv_15) ? p0x_fp : p1xi_fp;
// assign p1y_fp = (line_3d_actv_15) ? p2y_fp : p1yi_fp;

//////////////////////////////////////////////////////////////////
// Alpha, Red, Green, and Blue, Can be INT or Float. (T2R4 compatible).
assign vertex0`VAW  = color_2_flt(2'b00, color_mode_15, vertex0_15`VAW); 
assign vertex0`VRW  = color_2_flt(2'b00, color_mode_15, vertex0_15`VRW); 
assign vertex0`VGW  = color_2_flt(2'b00, color_mode_15, vertex0_15`VGW); 
assign vertex0`VBW  = color_2_flt(2'b00, color_mode_15, vertex0_15`VBW); 
assign vertex1`VAW  = color_2_flt(2'b00, color_mode_15, vertex1_15`VAW); 
assign vertex1`VRW  = color_2_flt(2'b00, color_mode_15, vertex1_15`VRW); 
assign vertex1`VGW  = color_2_flt(2'b00, color_mode_15, vertex1_15`VGW); 
assign vertex1`VBW  = color_2_flt(2'b00, color_mode_15, vertex1_15`VBW); 
assign vertex2`VAW  = color_2_flt(2'b00, color_mode_15, vertex2_15`VAW); 
assign vertex2`VRW  = color_2_flt(2'b00, color_mode_15, vertex2_15`VRW); 
assign vertex2`VGW  = color_2_flt(2'b00, color_mode_15, vertex2_15`VGW); 
assign vertex2`VBW  = color_2_flt(2'b00, color_mode_15, vertex2_15`VBW); 
// Fog, Rs, Gs, and Bs, are always INT for now (T2R4 compatible).
assign vertex0`VFW  = color_2_flt(2'b11, 1'b0, vertex0_15`VSW); 
assign vertex0`VRSW = color_2_flt(2'b10, 1'b0, vertex0_15`VSW); 
assign vertex0`VGSW = color_2_flt(2'b01, 1'b0, vertex0_15`VSW); 
assign vertex0`VBSW = color_2_flt(2'b00, 1'b0, vertex0_15`VSW); 
assign vertex1`VFW  = color_2_flt(2'b11, 1'b0, vertex1_15`VSW); 
assign vertex1`VRSW = color_2_flt(2'b10, 1'b0, vertex1_15`VSW); 
assign vertex1`VGSW = color_2_flt(2'b01, 1'b0, vertex1_15`VSW); 
assign vertex1`VBSW = color_2_flt(2'b00, 1'b0, vertex1_15`VSW); 
assign vertex2`VFW  = color_2_flt(2'b11, 1'b0, vertex2_15`VSW); 
assign vertex2`VRSW = color_2_flt(2'b10, 1'b0, vertex2_15`VSW); 
assign vertex2`VGSW = color_2_flt(2'b01, 1'b0, vertex2_15`VSW); 
assign vertex2`VBSW = color_2_flt(2'b00, 1'b0, vertex2_15`VSW); 

wire		co_linear;
wire		det_eqz;
wire		cull;
wire	[29:0]	ldg;
wire	[2:0]	lds;
wire	[5:0]	se_cstate;
wire  	[31:0]  grad;
wire  	[31:0]  spac;
wire  	[31:0]  ns1_fp;
wire  	[31:0]  ns2_fp;
wire  	[31:0]  spy_fp;
wire	[255:0]	spac_bus_2;		// Setup engine spacial bus.
wire		line_actv_3d;

/***********************NOTES**********************************
NOTE 1:
U and V are multiplied by W in the register input stage.
There for there must be a valid W in the chip for the current
point being written befor you can write U and V.
NOTE 2:
All input values are with the "_fp" sufix are IEEE single 
percision floating point.
**************************************************************/


/*********************MODULES***********************/

   des_grad	u_des_grad	
    	(
	.se_clk			(se_clk),
	.se_rstn		(se_rstn),
	.se_cstate		(se_cstate),
	.vertex0		(vertex0),
	.vertex1		(vertex1),
	.vertex2		(vertex2),
	.rect_15		(rect_15),
	.line_3d_actv_15	(line_3d_actv_15),
	.bce_15			(bce_15),
	.bc_pol_15		(bc_pol_15),
	// Outputs.	
	.ldg			(ldg),
	.grad			(grad),
	.lds			(lds),
	.spac			(spac),
	.scan_dir		(scan_dir),
	.co_linear		(co_linear),
	.det_eqz		(det_eqz),
	.cull			(cull),
	.ns1_fp			(ns1_fp),
	.ns2_fp			(ns2_fp),
	.spy_fp			(spy_fp)
	);

/********************/

  des_reg	u_des_reg
	(
	.se_clk			(se_clk),
	.se_rstn		(se_rstn),
	.load_actv_3d		(load_actv_3d),
	.scan_dir		(scan_dir),
	.line_3d_actv_15	(line_3d_actv_15),
	.ldg			(ldg),
	.grad			(grad),
	.lds			(lds),
	.spac			(spac),
	.ystat			({y2f_lt_y0f, y1f_lt_y0f, ystat}),
	.v0x			(vertex0`VXW),
	.v0y			(vertex0`VYW),
	.v0z			(vertex0`VZW),
	.v0w			(vertex0`VWW),
	.v0uw			(vertex0`VUW),
	.v0vw			(vertex0`VVW),
	.v0a			(vertex0`VAW),
	.v0r			(vertex0`VRW),
	.v0g			(vertex0`VGW),
	.v0b			(vertex0`VBW),
	.v0f			(vertex0`VFW),
	.v0rs			(vertex0`VRSW),
	.v0gs			(vertex0`VGSW),
	.v0bs			(vertex0`VBSW),
	.ns1_fp			(ns1_fp),
	.ns2_fp			(ns2_fp),
	.spy_fp			(spy_fp),
	.v2x			(vertex2`VXW),
	.v2y			(vertex2`VYW),
	// Outputs.     
	.line_actv_3d		(line_actv_3d),
	.spac_bus_2		(spac_bus_2),
	.cmp_z_fp		(cmp_z_fp),
	.cmp_w_fp		(cmp_w_fp),
	.cmp_uw_fp		(cmp_uw_fp),
	.cmp_vw_fp		(cmp_vw_fp),
	.cmp_a_fp		(cmp_a_fp),
	.cmp_r_fp		(cmp_r_fp),
	.cmp_g_fp		(cmp_g_fp),
	.cmp_b_fp		(cmp_b_fp),
	.cmp_f_fp		(cmp_f_fp),
	.cmp_rs_fp		(cmp_rs_fp),
	.cmp_gs_fp		(cmp_gs_fp),
	.cmp_bs_fp		(cmp_bs_fp),
	.ns1_eqz_15		(ns1_eqz_15),
	.ns2_eqz_15		(ns2_eqz_15),
	.scan_dir_2		(scan_dir_2),
	.start_x_fp_2		(start_x_fp_2),
	.start_y_fp_2		(start_y_fp_2),
	.end_x_fp_2		(end_x_fp_2),
	.end_y_fp_2		(end_y_fp_2)
	);

  des_state	u_des_state
	(
	// Inputs.
	.se_clk			(se_clk),
	.se_rstn		(se_rstn),
	.go_sup			(go_sup),
	.line_3d_actv_15	(line_3d_actv_15),
	.ns1_eqz		(ns1_eqz_15),
	.ns2_eqz		(ns2_eqz_15),
	.co_linear		(co_linear),
	.det_eqz		(det_eqz),
	.cull			(cull),
	// Outputs.
	.sup_done		(sup_done),
	.abort_cmd		(abort_cmd),
	.se_cstate		(se_cstate)
	);

//
// Triangle Scan converting statemachine.
//
des_smtri u_des_smtri
	(
	.de_clk			(se_clk),
	.de_rstn		(se_rstn),
	.load_actv_3d		(load_actv_3d),
	.line_actv_3d		(line_actv_3d),
	.scan_dir_2		(scan_dir_2),
	.stpl_2			(stpl_2),	// [1:0]
	.stpl_pk_1		(stpl_pk_1),
	.apat32_2		(apat32_2),
	.mw_fip			(mw_fip),
	.pipe_busy		(pipe_busy),
	.mcrdy			(mcrdy),
	.spac_bus		(spac_bus_2),	// [255:0]

	.t3_pixreq		(t3_pixreq),
	.t3_last_pixel		(t3_last_frag),
	.t3_msk_last		(t3_msk_last_frag),
	.cpx			(t3_cpx),	// [15:0]
	.cpy			(t3_cpy),	// [15:0]
	.tri_wrt		(tri_wrt),	// [7:0]
	.tri_dout		(tri_dout)	// [31:0]
	);

//
// 3D Line statemachine.
//
des_smline_3d u_des_smline_3d
	(
	.de_clk			(se_clk),
	.de_rstn		(se_rstn),
	.load_actv_3d		(load_actv_3d),
	.line_actv_3d		(line_actv_3d),
	.nlst_2			(nlst_2),
	.cpx0			(l3_cpx0),
	.cpy0			(l3_cpy0),
	.cpx1			(l3_cpx1),
	.cpy1			(l3_cpy1),
	.pipe_busy		(pipe_busy),

	.l_pixreq		(l3_pixreq),
	.l_last_pixel		(l3_last_pixel),
	.l_pc_msk_last		(l3_pc_msk_last),
	.cpx			(l3_cpx),
	.cpy			(l3_cpy),
	.l_incpat		(l3_incpat),	// Goes back to the line pattern reg.
	.l_active		(l3_active)	// 3D line is active.
	);




//
// Multiplex the fragments between line and triangle.
//
assign ld_frag       = t3_pixreq        | l3_pixreq;
assign last_frag     = t3_last_frag     | l3_last_pixel;
assign msk_last_frag = t3_msk_last_frag | l3_pc_msk_last;

assign current_x_fx  = (l3_active) ? l3_cpx : t3_cpx;
assign current_y_fx  = (l3_active) ? l3_cpy : t3_cpy;
assign fg_bgn 	     = (l3_active) ? l3_fg_bgn : 1'b1;

//
// Fragment Generater.
//
des_frag_gen u_des_frag_gen
	(
	// Inputs.
	.clk			(se_clk),
	.rstn			(se_rstn),
	.ld_frag		(ld_frag),
	.last_frag		(last_frag),
	.msk_last_frag		(msk_last_frag),
	.scan_dir_2		(scan_dir_2),
	.clp_2			(clp_2),
	.clptl_2		(clptl_2),
	.clpbr_2		(clpbr_2),
	.tex_2			(tex_2),
	.c3d_2			(c3d_2),
	.start_x_fp_2		(start_x_fp_2),
	.start_y_fp_2		(start_y_fp_2),
	.end_x_fp_2		(end_x_fp_2),
	.end_y_fp_2		(end_y_fp_2),
	.current_x_fx		(current_x_fx),
	.current_y_fx		(current_y_fx),
	.z_cmp_fp		(cmp_z_fp),
	.w_cmp_fp		(cmp_w_fp),
	.uw_cmp_fp		(cmp_uw_fp),
	.vw_cmp_fp		(cmp_vw_fp),
	.a_cmp_fp		(cmp_a_fp),
	.r_cmp_fp		(cmp_r_fp),
	.g_cmp_fp		(cmp_g_fp),
	.b_cmp_fp		(cmp_b_fp),
	.f_cmp_fp		(cmp_f_fp),
	.rs_cmp_fp		(cmp_rs_fp),
	.gs_cmp_fp		(cmp_gs_fp),
	.bs_cmp_fp		(cmp_bs_fp),
	.hith_2			(hith_2),
	.yon_2			(yon_2),
	.fg_bgn			(fg_bgn),
	// Outputs.
	.last_pixel		(last_pixel), 
	.msk_last_pixel		(msk_last_pixel), 
	.valid_z_col_spec	(valid_z_col_spec), 
	.valid_uv		(valid_uv), 
	.x_cur_o		(current_x), 		// [15:0]
	.y_cur_o		(current_y), 		// [15:0]
	.z_cur_fx		(current_z), 		// [31:0], 24.8
	.current_argb		(current_argb),		// [31:0]
	.current_spec		(current_spec),		// [23:0]
	.current_fog		(current_fog),	 	// [7:0]
	.current_u		(current_u),	 	// [19:0]
	.current_v		(current_v),	 	// [19:0]
	.lod_num		(lod_num), 		// [3:0]
	.lod_gamma		(lod_gamma),	 	// [5:0]
	.clip_xy		(clip_xy),
	.clip_uv		(clip_uv),
	.addr_exact		(current_exact),
	.bit_mask_x		(current_bit_mask_x),
	.bit_mask_y		(current_bit_mask_y),
	.l3_cpx0		(l3_cpx0),
	.l3_cpy0		(l3_cpy0),
	.l3_cpx1		(l3_cpx1),
	.l3_cpy1		(l3_cpy1),
	.current_fg_bgn		(current_fg_bgn)
	);

//////////////////////////////////////////////////////////////
//
// Functions.
//

// Color to Float function.
function [31:0] color_2_flt;
	input	[1:0]	color_channel;
	input	color_mode;
	input	[31:0]	color_in;

	reg	[7:0]	afx;

	begin
		case(color_channel)
			2'b00: afx = color_in[7:0];
			2'b01: afx = color_in[15:8];
			2'b10: afx = color_in[23:16];
			2'b11: afx = color_in[31:24];
		endcase

		casex({color_mode, afx})
			9'b1xxxxxxxx:color_2_flt = color_in;
			9'b000000000:color_2_flt = 32'h0;
			9'b01xxxxxxx:color_2_flt = {1'b0, 8'h86, afx[6:0], 16'h0};
			9'b001xxxxxx:color_2_flt = {1'b0, 8'h85, afx[5:0], 17'h0};
			9'b0001xxxxx:color_2_flt = {1'b0, 8'h84, afx[4:0], 18'h0};
			9'b00001xxxx:color_2_flt = {1'b0, 8'h83, afx[3:0], 19'h0};
			9'b000001xxx:color_2_flt = {1'b0, 8'h83, afx[2:0], 20'h0};
			9'b0000001xx:color_2_flt = {1'b0, 8'h81, afx[1:0], 21'h0};
			9'b00000001x:color_2_flt = {1'b0, 8'h80, afx[0], 22'h0};
			9'b000000001:color_2_flt = {1'b0, 8'h7F, 23'h0};
		endcase
	end
endfunction

// Snap  X floating point value to 1/16th.
function [31:0] flt_snap_x;
	input	[31:0]	afl;
	reg	[23:0]	mask;

	begin
	casex(afl[30:23])
		8'b00xx_xxxx: mask = 24'b000000000000000000000000; //  63 - 0,		3f - 0
		8'b010x_xxxx: mask = 24'b000000000000000000000000; //  95 - 64,		5f - 40
		8'b0110_xxxx: mask = 24'b000000000000000000000000; // 111 - 96,		6f - 60
		8'b0111_0xxx: mask = 24'b000000000000000000000000; // 119 - 112,	77 - 70
		8'b0111_100x: mask = 24'b000000000000000000000000; // 121 - 120,	79 - 78
		8'b0111_1010: mask = 24'b000000000000000000000000; // 122,	7A
		8'b0111_1011: mask = 24'b100000000000000000000000; // 123
		8'b0111_1100: mask = 24'b110000000000000000000000; // 124
		8'b0111_1101: mask = 24'b111000000000000000000000; // 125
		8'b0111_1110: mask = 24'b111100000000000000000000; // 126
		8'b0111_1111: mask = 24'b1_11110000000000000000000; // 127
		8'b1000_0000: mask = 24'b11_1111000000000000000000; // 128
		8'b1000_0001: mask = 24'b111_111100000000000000000; // 129
		8'b1000_0010: mask = 24'b1111_11110000000000000000; // 130
		8'b1000_0011: mask = 24'b11111_1111000000000000000; // 131
		8'b1000_0100: mask = 24'b111111_111100000000000000; // 132
		8'b1000_0101: mask = 24'b1111111_11110000000000000; // 133
		8'b1000_0110: mask = 24'b11111111_1111000000000000; // 134
		8'b1000_0111: mask = 24'b111111111_111100000000000; // 135
		8'b1000_1000: mask = 24'b1111111111_11110000000000; // 136
		8'b1000_1001: mask = 24'b11111111111_1111000000000; // 137
		8'b1000_1010: mask = 24'b111111111111_111100000000; // 138
		8'b1000_1011: mask = 24'b1111111111111_11110000000; // 139
		8'b1000_1100: mask = 24'b11111111111111_1111000000; // 140
		8'b1000_1101: mask = 24'b111111111111111_111100000; // 141
		8'b1000_1110: mask = 24'b1111111111111111_11110000; // 142
		8'b1000_1111: mask = 24'b11111111111111111_1111000; // 143
		8'b1001_0000: mask = 24'b111111111111111111_111100; // 144
		8'b1001_0001: mask = 24'b1111111111111111111_11110; // 145
		8'b1001_0010: mask = 24'b11111111111111111111_1111; // 146
		8'b1001_0011: mask = 24'b111111111111111111111_111; // 147
		8'b1001_0100: mask = 24'b1111111111111111111111_11; // 148
		8'b1001_0101: mask = 24'b11111111111111111111111_1; // 149
		default:      mask = 24'b111111111111111111111111_; // 150 - 255
	endcase
	flt_snap_x = (mask[23]) ? {afl[31:23], (mask[22:0] & afl[22:0])} : 32'h0;
	end
endfunction

// Snap  Y floating point value to 1/16th.
function [35:0] flt_snap_y;
	input	[31:0]	afl;
	reg	[23:0]	mask;
	reg	[3:0]	frac_y;

	begin
	casex(afl[30:23])
		8'b00xx_xxxx: begin mask = 24'b000000000000000000000000; frac_y = 4'b0000; end //  63 - 0,		3f - 0
		8'b010x_xxxx: begin mask = 24'b000000000000000000000000; frac_y = 4'b0000; end //  95 - 64,		5f - 40
		8'b0110_xxxx: begin mask = 24'b000000000000000000000000; frac_y = 4'b0000; end // 111 - 96,		6f - 60
		8'b0111_0xxx: begin mask = 24'b000000000000000000000000; frac_y = 4'b0000; end // 119 - 112,	77 - 70
		8'b0111_100x: begin mask = 24'b000000000000000000000000; frac_y = 4'b0000; end // 121 - 120,	79 - 78
		8'b0111_1010: begin mask = 24'b000000000000000000000000; frac_y = 4'b0000; end // 122,	7A
		8'b0111_1011: begin mask = 24'b100000000000000000000000; frac_y = 4'b0001; end // 123
		8'b0111_1100: begin mask = 24'b110000000000000000000000; frac_y = {3'b001, afl[22]}; end // 124
		8'b0111_1101: begin mask = 24'b111000000000000000000000; frac_y = {2'b01, afl[22:21]}; end // 125
		8'b0111_1110: begin mask = 24'b111100000000000000000000; frac_y = {1'b1, afl[22:20]}; end // 126
		8'b0111_1111: begin mask = 24'b1_11110000000000000000000; frac_y = afl[22:19]; end // 127
		8'b1000_0000: begin mask = 24'b11_1111000000000000000000; frac_y = afl[21:18]; end // 128
		8'b1000_0001: begin mask = 24'b111_111100000000000000000; frac_y = afl[20:17]; end // 129
		8'b1000_0010: begin mask = 24'b1111_11110000000000000000; frac_y = afl[19:16]; end // 130
		8'b1000_0011: begin mask = 24'b11111_1111000000000000000; frac_y = afl[18:15]; end // 131
		8'b1000_0100: begin mask = 24'b111111_111100000000000000; frac_y = afl[17:14]; end // 132
		8'b1000_0101: begin mask = 24'b1111111_11110000000000000; frac_y = afl[16:13]; end // 133
		8'b1000_0110: begin mask = 24'b11111111_1111000000000000; frac_y = afl[15:12]; end // 134
		8'b1000_0111: begin mask = 24'b111111111_111100000000000; frac_y = afl[14:11]; end // 135
		8'b1000_1000: begin mask = 24'b1111111111_11110000000000; frac_y = afl[13:10]; end // 136
		8'b1000_1001: begin mask = 24'b11111111111_1111000000000; frac_y = afl[12:9]; end // 137
		8'b1000_1010: begin mask = 24'b111111111111_111100000000; frac_y = afl[11:8]; end // 138
		8'b1000_1011: begin mask = 24'b1111111111111_11110000000; frac_y = afl[10:7]; end // 139
		8'b1000_1100: begin mask = 24'b11111111111111_1111000000; frac_y = afl[9:6]; end // 140
		8'b1000_1101: begin mask = 24'b111111111111111_111100000; frac_y = afl[8:5]; end // 141
		8'b1000_1110: begin mask = 24'b1111111111111111_11110000; frac_y = afl[7:4]; end // 142
		8'b1000_1111: begin mask = 24'b11111111111111111_1111000; frac_y = afl[6:3]; end // 143
		8'b1001_0000: begin mask = 24'b111111111111111111_111100; frac_y = afl[5:2]; end // 144
		8'b1001_0001: begin mask = 24'b1111111111111111111_11110; frac_y =  afl[4:1]; end // 145
		8'b1001_0010: begin mask = 24'b11111111111111111111_1111; frac_y =  afl[3:0]; end // 146
		8'b1001_0011: begin mask = 24'b111111111111111111111_111; frac_y = {afl[2:0], 1'b0};  end // 147
		8'b1001_0100: begin mask = 24'b1111111111111111111111_11; frac_y = {afl[1:0], 2'b00}; end // 148
		8'b1001_0101: begin mask = 24'b11111111111111111111111_1; frac_y = {afl[0], 3'b0};    end // 149
		default:      begin mask = 24'b111111111111111111111111_; frac_y = 4'b0000;   end // 150 - 255
	endcase
	flt_snap_y = { frac_y, ((mask[23]) ? {afl[31:23], (mask[22:0] & afl[22:0])} : 32'h0)};
	end
endfunction

function [23:0]flt_frac;
input	[31:0]	afl;

reg	[7:0] exp;

	begin
		exp = afl[30:23];
		case(afl[30:23])
		8'd102: flt_frac = 24'h0;
		8'd103: flt_frac = {23'h0, 1'b1};
		8'd104: flt_frac = {22'h0, 1'b1, afl[22]};
		8'd105: flt_frac = {21'h0, 1'b1, afl[22:21]};
		8'd106: flt_frac = {20'h0, 1'b1, afl[22:20]};
		8'd107: flt_frac = {19'h0, 1'b1, afl[22:19]};
		8'd108: flt_frac = {18'h0, 1'b1, afl[22:18]};
		8'd109: flt_frac = {17'h0, 1'b1, afl[22:17]};
		8'd110: flt_frac = {16'h0, 1'b1, afl[22:16]};
		8'd111: flt_frac = {15'h0, 1'b1, afl[22:15]};
		8'd112: flt_frac = {14'h0, 1'b1, afl[22:14]};
		8'd113: flt_frac = {13'h0, 1'b1, afl[22:13]};
		8'd114: flt_frac = {12'h0, 1'b1, afl[22:12]};
		8'd115: flt_frac = {11'h0, 1'b1, afl[22:11]};
		8'd116: flt_frac = {10'h0, 1'b1, afl[22:10]};
		8'd117: flt_frac = {9'h0, 1'b1, afl[22:9]};
		8'd118: flt_frac = {8'h0, 1'b1, afl[22:8]};
		8'd119: flt_frac = {7'h0, 1'b1, afl[22:7]};
		8'd120: flt_frac = {6'h0, 1'b1, afl[22:6]};
		8'd121: flt_frac = {5'h0, 1'b1, afl[22:5]};
		8'd122: flt_frac = {4'h0, 1'b1, afl[22:4]};
		8'd123: flt_frac = {3'h0, 1'b1, afl[22:3]};
		8'd124: flt_frac = {2'h0, 1'b1, afl[22:2]};
		8'd125: flt_frac = {1'h0, 1'b1, afl[22:1]};
		8'd126: flt_frac = {1'b1, afl[22:0]};		// 0.5
		8'd127: flt_frac = {afl[22:0], 1'h0};		// 1.0
		8'd128: flt_frac = {afl[21:0], 2'h0};		// 2.0
		8'd129: flt_frac = {afl[20:0], 3'h0};	// 4.0
		8'd130: flt_frac = {afl[19:0], 4'h0};	// 8.0
		8'd131: flt_frac = {afl[18:0], 5'h0};	// 16.0
		8'd132: flt_frac = {afl[17:0], 6'h0};	// 32.0
		8'd133: flt_frac = {afl[16:0], 7'h0};	// 64.0
		8'd134: flt_frac = {afl[15:0], 8'h0};	// 128.0
		8'd135: flt_frac = {afl[14:0], 9'h0};	// 256.0
		8'd136: flt_frac = {afl[13:0], 10'h0};	// 512.0
		8'd137: flt_frac = {afl[12:0], 11'h0};	// 1024.0
		8'd138: flt_frac = {afl[11:0], 12'h0};	// 2048.0
		8'd139: flt_frac = {afl[10:0], 13'h0};	// 4096.0
		8'd140: flt_frac = {afl[9:0],  14'h0};	// 8192.0
		8'd141: flt_frac = {afl[8:0],  15'h0};	// 16384.0
		8'd142: flt_frac = {afl[7:0],  16'h0};	// 32K.0
		8'd143: flt_frac = {afl[6:0],  17'h0};	// 64K.0
		8'd144: flt_frac = {afl[5:0],  18'h0};	// 128K.0
		8'd145: flt_frac = {afl[4:0],  19'h0};	// 256K.0
		8'd146: flt_frac = {afl[3:0],  20'h0};	// 512K.0
		8'd147: flt_frac = {afl[2:0],  21'h0};	// 1M.0
		8'd148: flt_frac = {afl[1:0],  22'h0};	// 2M.0
		8'd149: flt_frac = {afl[0],    23'h0};	// 4M.0
		default: flt_frac = 24'h0;		// 8M or greater, no fraction.
		endcase
	end

endfunction

endmodule
