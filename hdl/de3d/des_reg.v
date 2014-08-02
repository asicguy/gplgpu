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
//  Title       :  Register Block
//  File        :  des_reg.v
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
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module des_reg
	(
	input		se_clk,
	input		se_rstn,
	input		load_actv_3d,
	input		scan_dir,
	input		line_3d_actv_15,
	input	[29:0]	ldg,
	input	[31:0]	grad,
	input	[2:0]	lds,
	input	[31:0]	spac,
	input	[4:0]	ystat,
	input	[31:0]	v0x,
	input	[31:0]	v0y,
	input	[31:0]	v0z,
	input	[31:0]	v0w,
	input	[31:0]	v0uw,
	input	[31:0]	v0vw,
	input	[31:0]	v0a,
	input	[31:0]	v0r,
	input	[31:0]	v0g,
	input	[31:0]	v0b,
	input	[31:0]	v0f,
	input	[31:0]	v0rs,
	input	[31:0]	v0gs,
	input	[31:0]	v0bs,
	input	[31:0]	ns1_fp,
	input	[31:0]	ns2_fp,
	input	[31:0]	spy_fp,
	input	[31:0]	v2x,
	input	[31:0]	v2y,

	output reg	line_actv_3d,
	output	[255:0] spac_bus_2,
	output  [95:0]  cmp_z_fp,
	output  [95:0]  cmp_w_fp,
	output  [95:0]  cmp_uw_fp,
	output  [95:0]  cmp_vw_fp,
	output  [95:0]  cmp_a_fp,
	output  [95:0]  cmp_r_fp,
	output  [95:0]  cmp_g_fp,
	output  [95:0]  cmp_b_fp,
	output  [95:0]  cmp_f_fp,
	output  [95:0]  cmp_rs_fp,
	output  [95:0]  cmp_gs_fp,
	output  [95:0]  cmp_bs_fp,

	output              ns1_eqz_15,		// nscan checks
	output              ns2_eqz_15,		// nscan checks
	output reg          scan_dir_2,
	output reg [31:0]   start_x_fp_2,
	output reg [31:0]   start_y_fp_2,
	output reg [31:0]   end_x_fp_2,
	output reg [31:0]   end_y_fp_2
	);

	`include "define_3d.h"

	wire  [31:0]  spxy_ii;	// sample point {X,Y} ({16,16})
	reg   [31:0]  e1s_fx;    	// edge slopes (16.16)
	reg   [31:0]  e2s_fx;    	// edge slopes (16.16)
	reg   [31:0]  e3s_fx;    	// edge slopes (16.16)
	reg   [31:0]  e1x_fx;    	// edge intercepts (16.16)
	reg   [31:0]  e2x_fx;   	// edge intercepts (16.16)
	reg   [31:0]  e3x_fx;    	// edge intercepts (16.16)
	reg   [31:0]  nscan_ii;	// number scan lines {nscan_e2,nscan_e1}


	wire		spx_inc;
	wire  [31:0]	spy_i;
	wire  [31:0]	fxp_out_grad;
	wire  [31:0]	fxp_out_spac;
	wire  [31:0]	ns1_fxp;
	wire  [31:0]	ns2_fxp;
	wire 		ns1_fneqz;
	wire 		ns2_fneqz;

	reg  [15:0]	spy_i_fx;
	reg  [15:0]	ns1i;
	reg  [15:0]	ns2i;
	reg [31:0]	e1s;
	reg [31:0]	e2s;
	reg [31:0]	e3s;
	reg [31:0]	e1x;
	reg [31:0]	e2x;
	reg [31:0]	e3x;

	reg  [31:0]  spz_fp;
	reg  [31:0]  zx_fp;
	reg  [31:0]  zy_fp;
	reg  [31:0]  spw_fp;
	reg  [31:0]  wx_fp;
	reg  [31:0]  wy_fp;
	reg  [31:0]  spuw_fp;
	reg  [31:0]  uwx_fp;
	reg  [31:0]  uwy_fp;
	reg  [31:0]  spvw_fp;
	reg  [31:0]  vwx_fp;
	reg  [31:0]  vwy_fp;
	reg  [31:0]  spa_fp;
	reg  [31:0]  ax_fp;
	reg  [31:0]  ay_fp;
	reg  [31:0]  spr_fp;
	reg  [31:0]  rx_fp;
	reg  [31:0]  ry_fp;
	reg  [31:0]  spg_fp;
	reg  [31:0]  gx_fp;
	reg  [31:0]  gy_fp;
	reg  [31:0]  spb_fp;
	reg  [31:0]  bx_fp;
	reg  [31:0]  by_fp;
	reg  [31:0]  spf_fp;
	reg  [31:0]  fx_fp;
	reg  [31:0]  fy_fp;
	reg  [31:0]  sprs_fp;
	reg  [31:0]  rsx_fp;
	reg  [31:0]  rsy_fp;
	reg  [31:0]  spgs_fp;
	reg  [31:0]  gsx_fp;
	reg  [31:0]  gsy_fp;
	reg  [31:0]  spbs_fp;
	reg  [31:0]  bsx_fp;
	reg  [31:0]  bsy_fp;

	reg  [31:0]  zx;
	reg  [31:0]  zy;
	reg  [31:0]  wx;
	reg  [31:0]  wy;
	reg  [31:0]  uwx;
	reg  [31:0]  uwy;
	reg  [31:0]  vwx;
	reg  [31:0]  vwy;
	reg  [31:0]  ax;
	reg  [31:0]  ay;
	reg  [31:0]  rx;
	reg  [31:0]  ry;
	reg  [31:0]  gx;
	reg  [31:0]  gy;
	reg  [31:0]  bx;
	reg  [31:0]  by;
	reg  [31:0]  fx;
	reg  [31:0]  fy;
	reg  [31:0]  rsx;
	reg  [31:0]  rsy;
	reg  [31:0]  gsx;
	reg  [31:0]  gsy;
	reg  [31:0]  bsx;
	reg  [31:0]  bsy;


	assign spac_bus_2`CPX = spxy_ii[31:16];
	assign spac_bus_2`CPY = spxy_ii[15:0];
	assign spac_bus_2`E3S = e3s_fx;
	assign spac_bus_2`E2S = e2s_fx;
	assign spac_bus_2`E1S = e1s_fx;
	assign spac_bus_2`E3X = e3x_fx;
	assign spac_bus_2`E2X = e2x_fx;
	assign spac_bus_2`E1X = e1x_fx;
	assign spac_bus_2`NS2 = nscan_ii[31:16];
	assign spac_bus_2`NS1 = nscan_ii[15:0];


	assign cmp_z_fp  = {spz_fp, zx_fp, zy_fp};
	assign cmp_w_fp  = {spw_fp, wx_fp, wy_fp};
	assign cmp_uw_fp = {spuw_fp, uwx_fp, uwy_fp};
	assign cmp_vw_fp = {spvw_fp, vwx_fp, vwy_fp};
	assign cmp_a_fp  = {spa_fp, ax_fp, ay_fp};
	assign cmp_r_fp  = {spr_fp, rx_fp, ry_fp};
	assign cmp_g_fp  = {spg_fp, gx_fp, gy_fp};
	assign cmp_b_fp  = {spb_fp, bx_fp, by_fp};
	assign cmp_f_fp  = {spf_fp, fx_fp, fy_fp};
	assign cmp_rs_fp = {sprs_fp, rsx_fp, rsy_fp};
	assign cmp_gs_fp = {spgs_fp, gsx_fp, gsy_fp};
	assign cmp_bs_fp = {spbs_fp, bsx_fp, bsy_fp};



// Input Floating Point, Output 16.16
flt_fx u0_flt_fx(grad, fxp_out_grad);
flt_fx u1_flt_fx(spac, fxp_out_spac);
flt_fx u2_flt_fx(ns1_fp, ns1_fxp);
flt_fx u3_flt_fx(ns2_fp, ns2_fxp);
flt_fx u4_flt_fx(spy_fp, spy_i);

assign spx_inc = (e2x_fx[31] & (|e2x_fx[15:0]));
assign spxy_ii = {(e2x_fx[31:16] + spx_inc),spy_i_fx};

assign ns1_fneqz = |ns1_fxp[15:0];
assign ns2_fneqz = |ns2_fxp[15:0];

// Number of Scan Lines.
always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		ns1i <= 16'h0;
		ns2i <= 16'h0;
	end
	// ystat = {y2f_lt_y0f, y1_lt_y0f, y2f, y1f, y0f}
	else begin 
		// (y1f && y0f && y1_lt_y0f) || (y1f && !y0f)
		if(ns1_fneqz & ((ystat[1] && ystat[0] && ystat[3]) || (ystat[1] && !ystat[0])))
			ns1i <= ns1_fxp[31:16] + 16'h1;
		else    ns1i <= ns1_fxp[31:16];

		// (y2f && y0f && y2_lt_y0f) || (y2f && !y0f)
		if(ns2_fneqz & ((ystat[2] && ystat[0] && ystat[4]) || (ystat[2] && !ystat[0]))) 	     
			ns2i <= ns2_fxp[31:16] + 16'h1;
		else	ns2i <= ns2_fxp[31:16];

	end
end

always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		nscan_ii <= 32'h0;
		scan_dir_2 <= 1'b0;
	end
	else if(load_actv_3d) begin
		nscan_ii <= {ns2i, ns1i};
		scan_dir_2 <= scan_dir;
	end
end

assign ns1_eqz_15 = ~|ns1i;
assign ns2_eqz_15 = ~|ns2i;

always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		e1s <= 32'h0;
		e2s <= 32'h0;
		e3s <= 32'h0;
		e1x <= 32'h0;
		e2x <= 32'h0;
		e3x <= 32'h0;
	end else begin
		if(ldg[`LD_E1S]) e1s <= fxp_out_grad;
		if(ldg[`LD_E2S]) e2s <= fxp_out_grad;
		if(ldg[`LD_E3S]) e3s <= fxp_out_grad;
		if(lds[`LD_E1X]) e1x <= fxp_out_spac;
		if(lds[`LD_E2X]) e2x <= fxp_out_spac;
		if(lds[`LD_E3X]) e3x <= fxp_out_spac;
	end
end

// Start points.
always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		spz_fp  <= 32'h0;
		spw_fp  <= 32'h0;
		spuw_fp <= 32'h0;
		spvw_fp <= 32'h0;
		spa_fp  <= 32'h0;
		spr_fp  <= 32'h0;
		spg_fp  <= 32'h0;
		spb_fp  <= 32'h0;
		spf_fp  <= 32'h0;
		sprs_fp <= 32'h0;
		spgs_fp <= 32'h0;
		spbs_fp <= 32'h0;
		e1s_fx  <= 32'h0;
		e2s_fx  <= 32'h0;
		e3s_fx  <= 32'h0;
		e1x_fx  <= 32'h0;
		e2x_fx  <= 32'h0;
		e3x_fx  <= 32'h0;
		spy_i_fx <= 16'h0;
	end
	else if(load_actv_3d) begin
		spz_fp <= v0z;
		spw_fp <= v0w;
		spuw_fp <= v0uw;
		spvw_fp <= v0vw;
		spa_fp <= v0a;
		spr_fp <= v0r;
		spg_fp <= v0g;
		spb_fp <= v0b;
		spf_fp <= v0f;
		sprs_fp <= v0rs;
		spgs_fp <= v0gs;
		spbs_fp <= v0bs;
		e1s_fx <= e1s;
		e2s_fx <= e2s;
		e3s_fx <= e3s;
		e1x_fx <= e1x;
		e2x_fx <= e2x;
		e3x_fx <= e3x;
		spy_i_fx <= spy_i[31:16];
	end
end

always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		zx  <= 32'h0;
		zy  <= 32'h0;
		wx  <= 32'h0;
		wy  <= 32'h0;
		uwx <= 32'h0;
		uwy <= 32'h0;
		vwx <= 32'h0;
		vwy <= 32'h0;
		ax  <= 32'h0;
		ay  <= 32'h0;
		rx  <= 32'h0;
		ry  <= 32'h0;
		gx  <= 32'h0;
		gy  <= 32'h0;
		bx  <= 32'h0;
		by  <= 32'h0;
		fx  <= 32'h0;
		fy  <= 32'h0;
		rsx <= 32'h0;
		rsy <= 32'h0;
		gsx <= 32'h0;
		gsy <= 32'h0;
		bsx <= 32'h0;
		bsy <= 32'h0;
	end
	else begin
		if(ldg[`LD_ZX])  zx  <= grad;
		if(ldg[`LD_ZY])  zy  <= grad;
		if(ldg[`LD_WX])  wx  <= grad;
		if(ldg[`LD_WY])  wy  <= grad;
		if(ldg[`LD_UWX]) uwx <= grad;
		if(ldg[`LD_UWY]) uwy <= grad;
		if(ldg[`LD_VWX]) vwx <= grad;
		if(ldg[`LD_VWY]) vwy <= grad;
		if(ldg[`LD_AX])  ax  <= grad;
		if(ldg[`LD_AY])  ay  <= grad;
		if(ldg[`LD_RX])  rx  <= grad;
		if(ldg[`LD_RY])  ry  <= grad;
		if(ldg[`LD_GX])  gx  <= grad;
		if(ldg[`LD_GY])  gy  <= grad;
		if(ldg[`LD_BX])  bx  <= grad;
		if(ldg[`LD_BY])  by  <= grad;
		if(ldg[`LD_FX])  fx  <= grad;
		if(ldg[`LD_FY])  fy  <= grad;
		if(ldg[`LD_RSX]) rsx <= grad;
		if(ldg[`LD_RSY]) rsy <= grad;
		if(ldg[`LD_GSX]) gsx <= grad;
		if(ldg[`LD_GSY]) gsy <= grad;
		if(ldg[`LD_BSX]) bsx <= grad;
		if(ldg[`LD_BSY]) bsy <= grad;
	end
end

always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		zx_fp  <= 32'h0;
		zy_fp  <= 32'h0;
		wx_fp  <= 32'h0;
		wy_fp  <= 32'h0;
		uwx_fp <= 32'h0;
		uwy_fp <= 32'h0;
		vwx_fp <= 32'h0;
		vwy_fp <= 32'h0;
		ax_fp  <= 32'h0;
		ay_fp  <= 32'h0;
		rx_fp  <= 32'h0;
		ry_fp  <= 32'h0;
		gx_fp  <= 32'h0;
		gy_fp  <= 32'h0;
		bx_fp  <= 32'h0;
		by_fp  <= 32'h0;
		fx_fp  <= 32'h0;
		fy_fp  <= 32'h0;
		rsx_fp <= 32'h0;
		rsy_fp <= 32'h0;
		gsx_fp <= 32'h0;
		gsy_fp <= 32'h0;
		bsx_fp <= 32'h0;
		bsy_fp <= 32'h0;
		start_x_fp_2 <= 32'h0;
		start_y_fp_2 <= 32'h0;
		end_x_fp_2   <= 32'h0;
		end_y_fp_2   <= 32'h0;
		line_actv_3d <= 1'b0;
	end
	else if(load_actv_3d) begin
		zx_fp  <= zx;
		zy_fp  <= zy;
		wx_fp  <= wx;
		wy_fp  <= wy;
		uwx_fp <= uwx;
		uwy_fp <= uwy;
		vwx_fp <= vwx;
		vwy_fp <= vwy;
		ax_fp  <= ax;
		ay_fp  <= ay;
		rx_fp  <= rx;
		ry_fp  <= ry;
		gx_fp  <= gx;
		gy_fp  <= gy;
		bx_fp  <= bx;
		by_fp  <= by;
		fx_fp  <= fx;
		fy_fp  <= fy;
		rsx_fp <= rsx;
		rsy_fp <= rsy;
		gsx_fp <= gsx;
		gsy_fp <= gsy;
		bsx_fp <= bsx;
		bsy_fp <= bsy;
		start_x_fp_2 <= v0x;
		start_y_fp_2 <= v0y;
		end_x_fp_2   <= v2x;
		end_y_fp_2   <= v2y;
		line_actv_3d <= line_3d_actv_15;
	end
end






endmodule
