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
//  Title       :  Gradient Generator
//  File        :  des_grad.v
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

module des_grad
	(
	input		se_clk,
	input		se_rstn,
	input	[5:0]	se_cstate,

	// Vertex Zero, One, and Two.
	input	[447:0]	vertex0,
	input	[447:0]	vertex1,
	input	[447:0]	vertex2,
	// Control Signals.
	input		rect_15,
	input		line_3d_actv_15,
	input		bce_15,
	input		bc_pol_15,
	// Outputs.
	output reg	[29:0]	ldg,
	output 		[31:0]	grad,
	output reg	[2:0]	lds,
	output 		[31:0]	spac,
	output reg	      	scan_dir,
	output reg		co_linear,
	output			det_eqz,
	output reg		cull,
	output 		[31:0]	ns1_fp,
	output 		[31:0]	ns2_fp,
	output reg 	[31:0]	spy_fp
	);
	
	`include "define_3d.h"

//////////////////// Parameters //////////////////////////////////////
//
parameter sub          =  1'b1,
          add          =  1'b0,
          one_fp       = 32'h3f800000,      // Floating point one.
          zero_fp      = 32'h00000000,      // Floating point zero.
          m_one_fp     = 32'hbf800000,      // Floating point minus one.
          // p9_fp     = 32'h3f700000,      // Floating point 15/16.
          p9_fp        = 32'h3f7fffff,      // Floating point 0.999999.
          sliver_limit = 8'h77;		    // T2R4 (7E), Ref rast used (77).


/*******************INTERNAL REGISTERS*******************************/
wire	[31:0]	s0_s_fp;
wire	[31:0]	s1_s_fp;
wire	[31:0]	s2_s_fp;
wire	[31:0]	s3_s_fp;
wire	[31:0]	det_s_fp;
wire	[31:0]	int0_s_fp;
wire	[31:0]	int1_s_fp;

wire 		scan_dir_d;
wire	[31:0]	div_result_fp;

reg	[63:0]	div;
reg	[128:0]	det;
reg	[64:0]	sum_0;	// {subtract, flt_a, flt_b}
reg	[64:0]	sum_1;	// {subtract, flt_a, flt_b}
reg	[64:0]	sum_2;	// {subtract, flt_a, flt_b}
reg	[64:0]	sum_3;	// {subtract, flt_a, flt_b}

reg	[31:0]	e1s_fp;
reg	[31:0]	e2s_fp;
reg	[31:0]	e3s_fp;
reg	[31:0]	dx10_fp;
reg	[31:0]	dy10_fp;
reg	[31:0]	dx20_fp;
reg	[31:0]	dy20_fp;
reg	[31:0]	dx21_fp;
reg	[31:0]	dy21_fp;
reg	[31:0]	det_xy; 

reg [31:0] dz10_fp;
reg [31:0] dz20_fp;
reg [31:0] dw10_fp;
reg [31:0] dw20_fp;
reg [31:0] dvw10_fp;
reg [31:0] dvw20_fp;
reg [31:0] duw10_fp;
reg [31:0] duw20_fp;
reg [31:0] da10_fp;
reg [31:0] da20_fp;
reg [31:0] dr10_fp;
reg [31:0] dr20_fp;
reg [31:0] df10_fp;
reg [31:0] df20_fp;
reg [31:0] drs10_fp;
reg [31:0] drs20_fp;
reg [31:0] dg10_fp;
reg [31:0] dg20_fp;
reg [31:0] db10_fp;
reg [31:0] db20_fp;
reg [31:0] dgs10_fp;
reg [31:0] dgs20_fp;
reg [31:0] dbs10_fp;
reg [31:0] dbs20_fp;
reg 	   xmajor;
reg 	   ymajor;

wire [31:0] det_zx = (line_3d_actv_15) ? dz20_fp : det_s_fp;
wire [31:0] det_zy = (line_3d_actv_15) ? dz20_fp : det_s_fp;

/////////////////// These wires just make the code easier to read.///////

wire [31:0] dx10p_fp = s0_s_fp;
wire [31:0] dy10p_fp = s1_s_fp;
wire [31:0] dx20p_fp = s2_s_fp;
wire [31:0] dy20p_fp = s3_s_fp;
wire [31:0] dz10p_fp = s2_s_fp;
wire [31:0] dz20p_fp = s3_s_fp;

wire [31:0] det_wx = det_s_fp;
wire [31:0] det_wy = det_s_fp;
wire [31:0] det_uwx = det_s_fp;
wire [31:0] det_uwy = det_s_fp;
wire [31:0] det_vwx = det_s_fp;
wire [31:0] det_vwy = det_s_fp;
wire [31:0] det_ax = det_s_fp;
wire [31:0] det_ay = det_s_fp;
wire [31:0] det_rx = det_s_fp;
wire [31:0] det_ry = det_s_fp;
wire [31:0] det_gx = det_s_fp;
wire [31:0] det_gy = det_s_fp;
wire [31:0] det_bx = det_s_fp;
wire [31:0] det_by = det_s_fp;
wire [31:0] det_fx = det_s_fp;
wire [31:0] det_fy = det_s_fp;
wire [31:0] det_rsx = det_s_fp;
wire [31:0] det_rsy = det_s_fp;
wire [31:0] det_gsx = det_s_fp;
wire [31:0] det_gsy = det_s_fp;
wire [31:0] det_bsx = det_s_fp;
wire [31:0] det_bsy = det_s_fp;
wire [31:0] sp0yi_fp  = int0_s_fp;
wire [31:0] sp1yi_fp  = int1_s_fp;
wire [31:0] dsp0y_fp  = s0_s_fp;
wire [31:0] dsp1y_fp  = s1_s_fp;

//////////////////////  NOTES  //////////////////////////////////////
// NOTE 1:
// U and V are multiplied by W in the register input stage.
// There for there must be a valid W in the chip for the current
// point being written befor you can write U and V.
// NOTE 2:
// All input values are written as IEEE floating point or
// fixed point,

/////////////////////////////////////////////////////////////////////
//                    FLOAT ALU
//
// Float Subtracts (Three Clock Cycles).
// Float Determinate (Six Clocks).
// Float Divide (Seven Clocks).
//
flt_alu u_flt_alu
	(
	.clk		(se_clk),
	.rstn		(se_rstn),
	.sum_0		(sum_0),	// Input to sum 0.
	.sum_1		(sum_1),	// Input to sum 1.
	.sum_2		(sum_2),	// Input to sum 2.
	.sum_3		(sum_3),	// Input to sum 3.
	.det		(det),		// Input to Determinate.
	.div		(div),		// Input to divide.
	// Outputs.
	.s0_s		(s0_s_fp),	// Output from Sum 0.
	.s1_s		(s1_s_fp),	// Output from Sum 1.
	.s2_s		(s2_s_fp),	// Output from Sum 2.
	.s3_s		(s3_s_fp),	// Output from Sum 3.
	.det_s		(det_s_fp),	// Output from determinate.
	.div_result	(div_result_fp),// Output from divide.
	.int0_s		(int0_s_fp),	// Output INT of Sum 0.
	.int1_s		(int1_s_fp)	// Output INT of Sum 1.
	);

assign grad = div_result_fp;
assign spac = det_s_fp;
assign ns1_fp = dy10_fp;
assign ns2_fp = dy20_fp;

/////////////////////////////////////////////////////////////////////
//                    State Machine.
//

  always @*
    begin
      	ldg =30'h0;;
      	lds =3'h0;;
	sum_0  = 65'h0;
	sum_1  = 65'h0;
	sum_2  = 65'h0;
	sum_3  = 65'h0;
	det = 129'h0;
	div = 64'h0;
      case(se_cstate)     /* synopsys parallel_case */
	6'd0: begin
	  sum_0 = {sub, vertex1`VXW, vertex0`VXW}; 	// dx10 = p1x - p0x;
	  sum_1 = {sub, vertex1`VYW, vertex0`VYW}; 	// dy10 = p1y - p0y;
	  sum_2 = {sub, vertex2`VXW, vertex0`VXW}; 	// dx20 = p2x - p0x;
	  sum_3 = {sub, vertex2`VYW, vertex0`VYW}; 	// dy20 = p2y_fp - p0y_fp;
	end
	6'd1: begin
	  sum_0 = {sub, vertex2`VXW, vertex1`VXW}; 	// dx21 = p2x - p0x;
	  sum_1 = {sub, vertex2`VYW, vertex1`VYW}; 	// dy21 = p2y - p0y;
	  sum_2 = {sub, vertex1`VZW, vertex0`VZW}; 	// dz10 = p1z - p0z;
	  sum_3 = {sub, vertex2`VZW, vertex0`VZW}; 	// dz20 = p2z - p0z;
	end
	6'd2: begin
	  sum_0 = {sub, vertex1`VWW, vertex0`VWW}; 	// dw10 = p1w - p0w;
	  sum_1 = {sub, vertex2`VWW, vertex0`VWW}; 	// dw20 = p2w - p0w;
	  sum_2 = {sub, {1'b0, dx20p_fp[30:0]}, {1'b0, dy20p_fp[30:0]}}; // if pos X major.
	end
	6'd3:begin
	  sum_0 = {sub, vertex1`VUW, vertex0`VUW}; // duw10_fp = p1uw - p0uw;
	  sum_1 = {sub, vertex2`VUW, vertex0`VUW}; // duw20_fp = p2uw - p0uw;
	  sum_2 = {sub, vertex1`VVW, vertex0`VVW}; // dvw10_fp = p1vw - p0vw;
	  sum_3 = {sub, vertex2`VVW, vertex0`VVW}; // dvw20_fp = p2vw - p0vw;
	  det = {sub, dx20p_fp, dy10p_fp, dx10p_fp, dy20p_fp}; // det = (dx20 * dy10) - (dx10 * dy20};
	  div = {dx10p_fp, dy10p_fp}; // e1s = dx10/dy10;
	end
	6'd4:begin
	  sum_0 = {sub, vertex1`VAW, vertex0`VAW}; 	// da10 = p1a - p0a;
	  sum_1 = {sub, vertex2`VAW, vertex0`VAW}; 	// da20 = p2a - p0a;
	  sum_2 = {sub, vertex1`VRW, vertex0`VRW}; 	// dr10 = p1r - p0r;
	  sum_3 = {sub, vertex2`VRW, vertex0`VRW}; 	// dr20 = p2r - p0r;
	  det = {sub, dz20p_fp, dy10_fp, dz10p_fp, dy20_fp}; // det_zx = (dz20 * dy10) - (dz10 * dy20};
	  div = {dx20_fp, dy20_fp}; // e2s = dx20/dy20;
	end
	6'd5:begin
	  sum_0 = {sub, vertex1`VGW, vertex0`VGW}; 	// dg10 = p1g - p0g;
	  sum_1 = {sub, vertex2`VGW, vertex0`VGW}; 	// dg20 = p2g - p0g;
	  sum_2 = {sub, vertex1`VBW, vertex0`VBW}; 	// db10 = p1b - p0b;
	  sum_3 = {sub, vertex2`VBW, vertex0`VBW}; 	// db20 = p2b - p0b;
	  det = {sub, dz10_fp, dx20_fp, dz20_fp, dx10_fp}; // det_zy = (dz10 * dx20) - (dz20 * dx10};
	  div = {dx21_fp, dy21_fp}; // e3s = dx21/dy21;

	end
	6'd6:begin
	  sum_0 = {sub, vertex1`VFW, vertex0`VFW}; 		// df10 = p1f - p0f;
	  sum_1 = {sub, vertex2`VFW, vertex0`VFW}; 		// df20 = p2f - p0f;
	  sum_2 = {sub, vertex1`VRSW, vertex0`VRSW}; 	// drs10 = p1rs - p0rs;
	  sum_3 = {sub, vertex2`VRSW, vertex0`VRSW}; 	// drs20 = p2rs - p0rs;
	  det = {sub, dw20_fp, dy10_fp, dw10_fp, dy20_fp}; // det_wx = (dw20 * dy10) - (dw10 * dy20};
	end
	6'd7:begin
	  sum_0 = {sub, vertex1`VGSW, vertex0`VGSW}; 	// dgs10 = p1gs - p0gs;
	  sum_1 = {sub, vertex2`VGSW, vertex0`VGSW}; 	// dgs20 = p2gs - p0gs;
	  sum_2 = {sub, vertex1`VBSW, vertex0`VBSW}; 	// dbs10 = p1bs - p0bs;
	  sum_3 = {sub, vertex2`VBSW, vertex0`VBSW}; 	// dbs20 = p2bs - p0bs;
	  det = {sub, dw10_fp, dx20_fp, dw20_fp, dx10_fp}; // det_wy = (dw10 * dx20) - (dw20 * dx10};
	end
	6'd8: begin 
	  det = {sub, duw20_fp, dy10_fp, duw10_fp, dy20_fp}; // det_uwx = (duw20 * dy10) - (duw10 * dy20};
	end
	6'd9:begin
	  det = {sub, duw10_fp, dx20_fp, duw20_fp, dx10_fp}; // det_uwy = (duw10 * dx20) - (duw20 * dx10};
	end
	6'd10:begin 
	  det = {sub, dvw20_fp, dy10_fp, dvw10_fp, dy20_fp}; // det_vwx = (dvw20 * dy10) - (dvw10 * dy20};
	  div = {det_zx, det_xy}; // zx = det_zx / det_xy;
	end
	6'd11:begin 
	  det = {sub, dvw10_fp, dx20_fp, dvw20_fp, dx10_fp}; // det_vwy = (dvw10 * dx20) - (dvw20 * dx10};
	  div = {det_zy, det_xy}; // zy = det_zy / det_xy;
	end
	6'd12:begin	
	  det = {sub, da20_fp, dy10_fp, da10_fp, dy20_fp}; // det_ax = (da20 * dy10) - (da10 * dy20};
	  div = {det_wx, det_xy}; // wx = det_wx / det_xy;
	  ldg[`LD_E1S] = 1'b1;
	end
	6'd13:begin	
	  det = {sub, da10_fp, dx20_fp, da20_fp, dx10_fp}; // det_ay = (da10 * dx20) - (da20 * dx10};
	  div = {det_wy, det_xy}; // wy = det_wy / det_xy;
	  ldg[`LD_E2S] = 1'b1;
	end
	6'd14:begin	
	  det = {sub, dr20_fp, dy10_fp, dr10_fp, dy20_fp}; // det_rx = (dr20 * dy10) - (dr10 * dy20};
	  div = {det_uwx, det_xy}; // uwx = det_uwx / det_xy;
	  ldg[`LD_E3S] = 1'b1;
	end
	6'd15:begin	
	  det = {sub, dr10_fp, dx20_fp, dr20_fp, dx10_fp}; // det_ry = (dr10 * dx20) - (dr20 * dx10};
	  div = {det_uwy, det_xy}; // uwy = det_uwy / det_xy;
	end
	6'd16:begin
	  det = {sub, dg20_fp, dy10_fp, dg10_fp, dy20_fp}; // det_gx = (dg20 * dy10) - (dg10 * dy20};
	  div = {det_vwx, det_xy}; // vwx = det_vwx / det_xy;
	end
	6'd17:begin
	  det = {sub, dg10_fp, dx20_fp, dg20_fp, dx10_fp}; // det_gy = (dg10 * dx20) - (dg20 * dx10};
	  div = {det_vwy, det_xy}; // vwy = det_vwy / det_xy;
	end
	6'd18:begin
	  det = {sub, db20_fp, dy10_fp, db10_fp, dy20_fp}; // det_bx = (db20 * dy10) - (db10 * dy20};
	  div = {det_ax, det_xy}; // ax = det_ax / det_xy;
	end
	6'd19:begin
	  det = {sub, db10_fp, dx20_fp, db20_fp, dx10_fp}; // det_by = (db10 * dx20) - (db20 * dx10};
	  div = {det_ay, det_xy}; // ay = det_ay / det_xy;
	  ldg[`LD_ZX] = 1'b1;
	end
	6'd20:begin
	  det = {sub, df20_fp, dy10_fp, df10_fp, dy20_fp}; // det_fx = (df20 * dy10) - (df10 * dy20};
	  div = {det_rx, det_xy}; // rx = det_rx / det_xy;
	  sum_0 = {add, vertex0`VYW, p9_fp}; // INT(p0y + 0.9375);
	  ldg[`LD_ZY] = 1'b1;
	end
	6'd21:begin
	  det = {sub, df10_fp, dx20_fp, df20_fp, dx10_fp}; // det_fy = (df10 * dx20) - (df20 * dx10};
	  div = {det_ry, det_xy}; // ry = det_ry / det_xy;
	  sum_0 = {add, vertex0`VYW, p9_fp}; // INT(p0y + 0.9375);
	  ldg[`LD_WX] = 1'b1;
	end
	6'd22:begin
	  det = {sub, drs20_fp, dy10_fp, drs10_fp, dy20_fp}; // det_rsx = (drs20 * dy10) - (drs10 * dy20};
	  div = {det_gx, det_xy}; // gx = det_gx / det_xy;
	  sum_1 = {add, vertex1`VYW, p9_fp}; // INT(p1y + 0.9375);
	  ldg[`LD_WY] = 1'b1;
	end
	6'd23:begin
	  det = {sub, drs10_fp, dx20_fp, drs20_fp, dx10_fp}; // det_rsy = (drs10 * dx20) - (drs20 * dx10};
	  div = {det_gy, det_xy}; // gy = det_gy / det_xy;
	  sum_1 = {add, vertex1`VYW, p9_fp}; // INT(p1y + 0.9375);
	  ldg[`LD_UWX] = 1'b1;
	end
	6'd24: begin
	  det = {sub, dgs20_fp, dy10_fp, dgs10_fp, dy20_fp}; // det_gsx = (dgs20 * dy10) - (dgs10 * dy20};
	  div = {det_bx, det_xy}; // bx = det_bx / det_xy;
	  ldg[`LD_UWY] = 1'b1;
  	end
	6'd25: begin
	  det = {sub, dgs10_fp, dx20_fp, dgs20_fp, dx10_fp}; // det_gsy = (dgs10 * dx20) - (dgs20 * dx10};
	  div = {det_by, det_xy}; // by = det_by / det_xy;
	  sum_0 = {sub, sp0yi_fp, vertex0`VYW};
	  ldg[`LD_VWX] = 1'b1;
  	end
	6'd26: begin
	  det = {sub, dbs20_fp, dy10_fp, dbs10_fp, dy20_fp}; // det_bsx = (dbs20 * dy10) - (dbs10 * dy20};
	  div = {det_fx, det_xy}; // fx = det_fx / det_xy;
	  sum_0 = {sub, sp0yi_fp, vertex0`VYW};
	  ldg[`LD_VWY] = 1'b1;
  	end
	6'd27: begin
	  det = {sub, dbs10_fp, dx20_fp, dbs20_fp, dx10_fp}; // det_gsy = (dbs10 * dx20) - (dbs20 * dx10};
	  div = {det_fy, det_xy}; // fy = det_fy / det_xy;
	  sum_1 = {sub, sp1yi_fp, vertex1`VYW};
	  ldg[`LD_AX] = 1'b1;
  	end
	6'd28: begin
	  det = {add, e1s_fp, dsp0y_fp, vertex0`VXW, one_fp}; // e1x = (e1s * dsp0y) + (p0x * 1);
	  div = {det_rsx, det_xy}; // rsx = det_rsx / det_xy;
	  ldg[`LD_AY] = 1'b1;
  	end
	6'd29: begin
	  det = {add, e2s_fp, dsp0y_fp, vertex0`VXW, one_fp}; // e2x = (e2s * dsp0y) + (p0x * 1);
	  div = {det_rsy, det_xy}; // rsy = det_rsy / det_xy;
	  ldg[`LD_RX] = 1'b1;
  	end
	6'd30: begin
	  det = {add, e3s_fp, dsp1y_fp, vertex1`VXW, one_fp}; // e3x = (e3s * dsp1y) + (p1x * 1);
	  div = {det_gsx, det_xy}; // gsx = det_gsx / det_xy;
	  ldg[`LD_RY] = 1'b1;
  	end
	6'd31: begin
	  div = {det_gsy, det_xy}; // gsy = det_gsy / det_xy;
	  ldg[`LD_GX] = 1'b1;
  	end
	6'd32: begin
	  div = {det_bsx, det_xy}; // bsx = det_bsx / det_xy;
	  ldg[`LD_GY] = 1'b1;
  	end
	6'd33: begin
	  div = {det_bsy, det_xy}; // bsy = det_bsy / det_xy;
	  ldg[`LD_BX] = 1'b1;
  	end
	6'd34: begin
	  lds[`LD_E1X] = 1'b1;
	  ldg[`LD_BY] = 1'b1;
	end
	6'd35: begin
	  ldg[`LD_FX] = 1'b1;
	  lds[`LD_E2X] = 1'b1;
  	end
	6'd36: begin
	  ldg[`LD_FY]  = 1'b1;
	  lds[`LD_E3X] = 1'b1;
  	end
	6'd37: ldg[`LD_RSX] = 1'b1;
	6'd38: ldg[`LD_RSY] = 1'b1;
	6'd39: ldg[`LD_GSX] = 1'b1;
	6'd40: ldg[`LD_GSY] = 1'b1;
	6'd41: ldg[`LD_BSX] = 1'b1;
	6'd42: ldg[`LD_BSY] = 1'b1;
	default:begin
	  ldg = 30'h0;
	  lds = 3'h0;
	  sum_0  = 65'h0;
	  sum_1  = 65'h0;
	  sum_2  = 65'h0;
	  sum_3  = 65'h0;
	  det = 129'h0;
	  div = 64'h0;
	end

      endcase
    end

  /********HOLDING*****REGISTERS*******STATIC************/
  
  // assign scan_dir_d = (xmajor | ymajor) ? dx20_fp[31] : det_s_fp[31];
  assign scan_dir_d = det_s_fp[31];
  
  always @(posedge se_clk, negedge se_rstn) begin
	  if(!se_rstn) scan_dir <= 1'b0; 
	  else if(se_cstate == 5'b01001) scan_dir <= scan_dir_d;
  end
  
  always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
	  	dx20_fp <= 32'h0;
	  	dy20_fp <= 32'h0;
	end
        else if (se_cstate == 5'b00011) begin
	  	dx20_fp <= s2_s_fp;
	  	dy20_fp <= s3_s_fp;
	end
    end

  always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) 			dx10_fp <= 32'h0;
        else if (ymajor) 		dx10_fp <= 32'hbf800000; // 1 for lines with ymajor.
        else if (se_cstate == 5'b00011) dx10_fp <= s0_s_fp;
    end

  always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) 			dy10_fp <= 32'h0;
        else if (xmajor) 		dy10_fp <= 32'h3f800000; // -1 for lines with xmajor.
        else if (se_cstate == 5'b00011) dy10_fp <= s1_s_fp;
    end

    always @(posedge se_clk, negedge se_rstn) begin
	    if(!se_rstn) begin
		    dx21_fp <= 32'h0;
		    dy21_fp <= 32'h0;
	    end
    	    else begin
      		if (rect_15) 		        dx21_fp <= 32'h0;
      		else if (se_cstate == 5'b00100) dx21_fp <= s0_s_fp;
      		if      (se_cstate == 5'b00100) dy21_fp <= s1_s_fp;
    	    end
    end
  
    always @ (posedge se_clk, negedge se_rstn) begin
	    if(!se_rstn) det_xy <= 32'h0;
	    else if(xmajor) det_xy <= dx20_fp;
	    else if(ymajor) det_xy <= dy20_fp;
	    else if(se_cstate == 5'b01001) det_xy <= det_s_fp;
    end

    always @ (posedge se_clk, negedge se_rstn) begin
	    if(!se_rstn) spy_fp <= 32'h0;
	    else if(se_cstate == 5'b11001) spy_fp <= int0_s_fp;
    end


/********HOLDING*****REGISTERS******DYNAMIC************/
//              S0    S1    S2    S3
// 000011 save dx10, dy10, dx20, dy20
// 000100 save dx21, dy21, dz10, dz20
// 000101 save dw10, dy21, xxxx, xxxx
// 000110 save dw10, dy21, xxxx, xxxx
// LD 					USED
// (4) dz10,  dz20  			4,5     4p, 5 hld0,1
// (5) dw10,  dw20  			6,7	hld2,3
// (6) duw10, duw20  			8,9	hdl4,5
// (6) dvw10  dvw20  			A,B	hld6,7
// `
// (7) da10,  da20   			C,D	hld0,1
// (7) dr10   dr20  			E,F	hld2,3
// (8) dg10,  dg20   			10,11	hld4,5
// (8) db10   db20  			12,13	hld6.7
// (9) df10,  df20   			14,15	hld0,1
// (9) drs10  drs20  			16,17	hld2,3
// (A) dgs10  dgs20  			18,19	hld4,5
// (A) dbs10  dbs20  			1A,1B	hld6,7

// (9)  det_xy		(9)
// (A)  det_zx		(A)		zx	(11)
// (B)  det_zy		(B)		zy	(12)
// (C)  det_wx		(C)		wx	(13)
// (D)  det_wy		(D)		wy	(14)
// (E)  det_uwx		(E)		uwx	(15)
// (F)  det_uwy		(F)		uwy	(16)
// (10) det_vwx		(10)		vwx	(17)
// (11) det_vwy		(11)		vwy	(18)
// (12) det_ax		(12)		ax	(19)
// (13) det_ay		(13)		ay	(1A)
// (14) det_rx		(14)		rx	(1B)
// (15) det_ry		(15)		ry	(1C)
// (16) det_gx		(16)		gx	(1D)
// (17) det_gy		(17)		gy	(1E)
// (18) det_bx		(18)		bx	(1F)
// (19) det_by		(19)		by	(20)
// (1A) det_fx		(1A)		fx	(21)
// (1B) det_fy		(1B)		fy	(22)
// (1C) det_rsx		(1C)		rsx	(23)
// (1D) det_rsy		(1D)		rsy	(24)
// (1E) det_gsx		(1E)		gsx	(25)
// (1F) det_gsy		(1F)		gsy	(26)
// (20) det_bsx		(20)		bsx	(27)
// (21) det_bsy		(21)		bsy	(28)
//
        // case ({xmajor_15,ymajor_15,se_cstate})
        // case({xmajor_15,ymajor_15,se_cstate})
        // case ({xmajor_15,ymajor_15,se_cstate})
	// 6'b100101: hold_0 <= 0;	// Line and Y major.
	// 6'b100101: hold_0 <= 0;	// Line and Y major.
	// 6'b000001: hold_0 <= s3_s_fp;	// Line and X major duw20_fp.
	// 6'b100101: hold_1 <= s3_s_fp;	// Line and Y major duw20_fp.
	// 6'b000101: hold_1 <= 0;		// Line and X major 0.

    always @(posedge se_clk, negedge se_rstn) begin
	if(!se_rstn) begin
		dz10_fp  <= 32'h0;
		dz20_fp  <= 32'h0;
		dw10_fp  <= 32'h0;
		dw20_fp  <= 32'h0;
		dvw10_fp <= 32'h0;
		dvw20_fp <= 32'h0;
		duw10_fp <= 32'h0;
		duw20_fp <= 32'h0;
		da10_fp  <= 32'h0;
		da20_fp  <= 32'h0;
		dr10_fp  <= 32'h0;
		dr20_fp  <= 32'h0;
		df10_fp  <= 32'h0;
		df20_fp  <= 32'h0;
		drs10_fp <= 32'h0;
		drs20_fp <= 32'h0;
		dg10_fp  <= 32'h0;
		dg20_fp  <= 32'h0;
		db10_fp  <= 32'h0;
		db20_fp  <= 32'h0;
		dgs10_fp <= 32'h0;
		dgs20_fp <= 32'h0;
		dbs10_fp <= 32'h0;
		dbs20_fp <= 32'h0;
		e1s_fp   <= 32'h0;
		e2s_fp   <= 32'h0;
		e3s_fp   <= 32'h0;
	end
	else begin
      // case ({xmajor_15,ymajor_15,se_cstate})
      case (se_cstate)
	6'd4: begin
		dz10_fp <= s2_s_fp;	// dz10_fp.
		dz20_fp <= s3_s_fp;	// dz20p_fp;
	end
	6'd5: begin
		dw10_fp <= s0_s_fp;	// dw10_fp.
		dw20_fp <= s1_s_fp;	// dw20_fp.
	end
	6'd6: begin
		dvw10_fp <= s2_s_fp;	// dvw10_fp.
		dvw20_fp <= s3_s_fp;	// dvw20_fp.
		duw10_fp <= s0_s_fp;	// duw10_fp;
		duw20_fp <= s1_s_fp;	// duw20_fp;
	end
	6'd7: begin
		da10_fp <= s0_s_fp;	// da10_fp.
		da20_fp <= s1_s_fp;	// da20_fp.
		dr10_fp <= s2_s_fp;	// dr10_fp.
		dr20_fp <= s3_s_fp;	// dr20_fp.
	end
	6'd8: begin
		dg10_fp <= s0_s_fp;	// dg10_fp;
		dg20_fp <= s1_s_fp;	// dg20_fp;
		db10_fp <= s2_s_fp;	// db10_fp
		db20_fp <= s3_s_fp;	// db20_fp
	end
	6'd9: begin
		df10_fp <= s0_s_fp;	// df10_fp.
		df20_fp <= s1_s_fp;	// df20_fp.
		drs10_fp <= s2_s_fp;	// drs10_fp.
		drs20_fp <= s3_s_fp;	// drs20_fp.
	end
	6'd10: begin
		dgs10_fp <= s0_s_fp;	// dgs10_fp;
		dgs20_fp <= s1_s_fp;	// dgs20_fp;
		dbs10_fp <= s2_s_fp;	// dbs10_fp
		dbs20_fp <= s3_s_fp;	// dbs20_fp
	end
	6'd12: e1s_fp <= div_result_fp;	// Slope Edge three.
	6'd13: e2s_fp <= div_result_fp;	// Slope Edge three.
	6'd14: e3s_fp <= div_result_fp;	// Slope Edge three.
      endcase
	end
  end

    always @ (posedge se_clk, negedge se_rstn) begin
	    if(!se_rstn) begin
		    xmajor <= 1'b0;
		    ymajor <= 1'b0;
	    end
	else begin
		if(se_cstate == 6'b000101) xmajor <= (~s2_s_fp[31] & line_3d_actv_15);// Line and X major
		if(se_cstate == 6'b000101) ymajor <= ( s2_s_fp[31] & line_3d_actv_15);// Line and Y major
	end
    end

/////////////////// COLINEAR CHECKS ///////////////////////////////

always @* co_linear = ((~|{dx21_fp[30:0],dy21_fp[30:0]}) |
                        (~|{dx10_fp[30:0],dy10_fp[30:0]}));

/////////////////// CULLING CHECK ////////////////////////////////

always @* cull = (bce_15 & bc_pol_15 & ~scan_dir) | (bce_15 & ~bc_pol_15 & scan_dir);

/////////////////// SLIVER CHECK ////////////////////////////////

assign det_eqz = (sliver_limit > det_xy[30:23]);

endmodule
