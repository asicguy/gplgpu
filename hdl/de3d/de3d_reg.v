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
//  Title       :  Drawing Engine 3D Registers
//  File        :  de3d_reg.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This is the 3D Register block.
//  It handles the different levels of registers.
//  To reduce storage some floating point operations are done on the way in.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//    u_flt_mult_comb    flt_mult_comb    Floating Point Multiply
//    u_flt_add_sub_comb flt_add_sub_comb Floating Point Add/ Subtract
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

module de3d_reg 
  (
   // Host Interface.
   input 	      hb_rstn,          // clock input
   input 	      hb_clk,           // host bus clock input
   input [31:0]       hb_din_p,         // host bus data
   input [8:2] 	      hb_adr_p,         // host bus address
   input [8:2] 	      hb_adr_r,         // host bus read address
   input 	      hb_wstrb_p,       // host bus write strobes
   input [3:0] 	      hb_ben_p,         // host bus byte enables.
   input 	      hb_cp_csn,        // host bus chip select.
   input 	      de_clk,           // DE clock input
   input 	      de_rstn,          // DE resetn input
   input 	      go_sup,           // Setup is starting.
   input 	      load_actv_3d,     // Setup done.
   input [1:0] 	      ps_15,            // Pixel Size Level 15.
   input 	      load_actvn,
   input 	      load_15,

   // Level 1.5 to the setup input.
   output [351:0]     vertex0_15,       // Vertex 0.
   output [351:0]     vertex1_15,       // Vertex 1.
   output [351:0]     vertex2_15,       // Vertex 2.
   output reg 	      bc_pol_15,        // Backface Culling Polarity
   output reg 	      color_mode_15,    // 0 = ARGB, 1 = Float.
   output reg 	      bce_15,           // Backface Cull enable
   output 	      rect_15,          // Rectangle Mode.
   output 	      line_3d_actv_15,  // Line is active

   // Level 2 Pipe line signals.
   output reg [209:0] lod_2,            // LOD [9:0]  origin
   output reg [27:0]  zorg_2,           // Z origin pointer
   output reg [11:0]  zptch_2,          // Z pitch register output
   output reg [20:0]  tporg_2,          // Texture palette origin
   output reg [20:0]  tporg_1,          // Texture palette origin
   output reg [11:0]  tptch_2,          // Texture pitch register output
   output reg [31:0]  hith_2,           // clipping hither.
   output reg [31:0]  yon_2,            // clipping yon.
   output reg [31:0]  fcol_2,           // Fog color
   output reg [31:0]  texbc_2,          // Texture Boarder Color
   output reg [23:0]  key3dlo_2,        // Alpha value   register
   output reg [23:0]  key3dhi_2,        // Alpha value   register
   output reg [31:0]  c3d_2,            // 3D Control Register
   output reg [31:0]  tex_2,            // Texture Control Register
   output reg [31:0]  blendc_2,         // OpenGL blending constant
   output reg [31:0]  pptr3d_2,         // Pattern Pointer 3D output XY1 or CP1
   output reg [23:0]  alpha_2,          // Alpha register
   output reg [17:0]  acntrl_2,         // Alpha control
   output reg 	      actv_3d_2,        // 3D command active

   // Host read back data.
   output reg [31:0]  cp_hb_dout        // Register readback
   );
  
  // _2 signals are the currently active command signals
  // _15 are the signals in 3D for setup
  // _1  is the next command
  
`include "define_3d.h"
  
  ////////////////////////////////////////////////////////////////
  //
  // Register Address Parameters.
  //
  // These are the original register locations for backward compatibility
  // with the Imagine series of graphics processors. They can easily be
  // changed for custom drivers.
  parameter
    CMDR 	= 7'b0_0100_10,	// 0x048
    OPC 	= 7'b0_0101_00,	// 0x050
    CMD_3D	= 7'b1_0110_10,	// 0x168
    ROP 	= 7'b0_0101_01,	// 0x054
    LOD0	= 7'b0_1101_00,	// 0x0d0
    LOD1	= 7'b0_1101_01,	// 0x0d4
    LOD2	= 7'b0_1101_10,	// 0x0d8
    LOD3	= 7'b0_1101_11,	// 0x0dc
    LOD4	= 7'b0_1110_00,	// 0x0e0
    LOD5	= 7'b0_1110_01,	// 0x0e4
    LOD6	= 7'b0_1110_10,	// 0x0e8
    LOD7	= 7'b0_1110_11,	// 0x0ec
    LOD8	= 7'b0_1111_00,	// 0x0f0
    LOD9	= 7'b0_1111_01,	// 0x0f4
    TPTCH 	= 7'b0_0011_10,	// 0x038
    ZPTCH 	= 7'b0_0011_11,	// 0x03c
    ZORG        = 7'b1_0000_00, // 0x100
    TPAL        = 7'b1_0001_10, // 0x118
    HITH        = 7'b1_0001_11, // 0x11c
    YON         = 7'b1_0010_00, // 0x120
    FCOL        = 7'b1_0010_01, // 0x124
    ALPHA	= 7'b1_0010_10,	// 0x128
    TBOARD	= 7'b1_0010_11,	// 0x12c
    V0AF	= 7'b1_0011_00, // 0x130
    V0RF	= 7'b1_0011_01, // 0x134
    V0GF	= 7'b1_0011_10, // 0x138
    V0BF	= 7'b1_0011_11, // 0x13c
    V1AF	= 7'b1_0100_00, // 0x140
    V1RF	= 7'b1_0100_01, // 0x144
    V1GF	= 7'b1_0100_10, // 0x148
    V1BF	= 7'b1_0100_11, // 0x14c
    V2AF	= 7'b1_0101_00, // 0x150
    V2RF	= 7'b1_0101_01, // 0x154
    V2GF	= 7'b1_0101_10, // 0x158
    V2BF	= 7'b1_0101_11, // 0x15c
    KY3DLO	= 7'b1_0110_00,	// 0x160
    KY3DHI	= 7'b1_0110_01,	// 0x164
    ACNTRL	= 7'b1_0110_11,	// 0x16c
    C3D         = 7'b1_0111_00, // 0x170
    TEX         = 7'b1_0111_01, // 0x174
    CP0         = 7'b1_0111_10, // 0x178
    CP1         = 7'b1_0111_11, // 0x17c
    CP2         = 7'b1_1000_00, // 0x180
    CP3         = 7'b1_1000_01, // 0x184
    CP4         = 7'b1_1000_10, // 0x188
    CP5         = 7'b1_1000_11, // 0x18c
    CP6 	= 7'b1_1001_00,	// 0x190
    CP7 	= 7'b1_1001_01,	// 0x194
    CP8 	= 7'b1_1001_10,	// 0x198
    CP9 	= 7'b1_1001_11,	// 0x19c
    CP10 	= 7'b1_1010_00,	// 0x1a0
    CP11 	= 7'b1_1010_01,	// 0x1a4
    CP12	= 7'b1_1010_10,	// 0x1a8
    CP13	= 7'b1_1010_11,	// 0x1ac
    CP14	= 7'b1_1011_00,	// 0x1b0
    CP15	= 7'b1_1011_01,	// 0x1b4
    CP16	= 7'b1_1011_10,	// 0x1b8
    CP17	= 7'b1_1011_11,	// 0x1bc
    CP18	= 7'b1_1100_00,	// 0x1c0
    CP19	= 7'b1_1100_01,	// 0x1c4
    CP20	= 7'b1_1100_10,	// 0x1c8
    CP21	= 7'b1_1100_11,	// 0x1cc
    CP22	= 7'b1_1101_00,	// 0x1d0
    CP23	= 7'b1_1101_01,	// 0x1d4
    CP24	= 7'b1_1101_10,	// 0x1d8
    TRG3D	= 7'b1_1101_11,	// 0x1dc
    BLENDC 	= 7'b1_1110_00,	// 0x1e0
    
    LINE_3D	= 4'b1000,	// Line 3D command.
    TRIAN_3D	= 4'b1001;	// Triangle 3D command.

  /////////////////////////////////////////////////////////////////
  
  wire [31:0] 	      vertex0_w;
  wire [31:0] 	      vertex1_w;
  wire [31:0] 	      vertex2_w;
  wire [31:0] 	      uvout;          // UV from multiplier to UV of vertices
  wire [31:0] 	      bias_space;
  wire [31:0] 	      xy_in;
  wire 		      not_zero_u0;
  wire 		      not_zero_v0;
  wire 		      not_zero_u1;
  wire 		      not_zero_v1;
  wire 		      not_zero_u2;
  wire 		      not_zero_v2;

  reg [351:0] 	      vertex0_u;	// Vertex 0, un-sorted.
  reg [351:0] 	      vertex1_u;	// Vertex 1, un-sorted.
  reg [351:0] 	      vertex2_u;	// Vertex 2, un-sorted.
  
  reg [20:0] 	      lod9_r;
  reg [20:0] 	      lod8_r;
  reg [20:0] 	      lod7_r;
  reg [20:0] 	      lod6_r;
  reg [20:0] 	      lod5_r;
  reg [20:0] 	      lod4_r;
  reg [20:0] 	      lod3_r;
  reg [20:0] 	      lod2_r;
  reg [20:0] 	      lod1_r;
  reg [20:0] 	      lod0_r;
  reg [31:0] 	      win;
  
  reg [7:0] 	      asrcreg_r;      // Alpha blend source alpha override
  reg [7:0] 	      adstreg_r;      // Alpha blend dest   alpha override
  reg [7:0] 	      atest_r;        // Alpha test register
  
  reg [3:0] 	      asrc_r;         // Alpha blending src factor
  reg [3:0] 	      adst_r;         // Alpha blending dst factor
  reg 		      sre_r;          // Use source register
  reg 		      dre_r;          // Use dest register
  reg 		      be_r;           // enable blending
  reg 		      aen_r;          // alpha enable
  reg [2:0] 	      aop_r;          // Alpha operator
  reg 		      da_r;
  reg 		      amd_r;
  reg 		      asl_r;
  reg [2:0] 	      key_ctrl_r;

  reg [31:0] 	      pptr3d_1;
  reg 		      color_mode_1;
  reg [27:0] 	      zorg_1;
  reg [11:0] 	      zptch_1;
  reg [11:0] 	      tptch_1;
  reg [31:0] 	      hith_1;
  reg [31:0] 	      yon_1;
  reg [31:0] 	      fcol_1;
  reg [31:0] 	      texbc_1;
  reg [23:0] 	      key3dlo_1;
  reg [23:0] 	      key3dhi_1;
  reg [31:0] 	      c3d_1;
  reg [31:0] 	      tex_1;
  reg [31:0] 	      blendc_1;
  reg [3:0] 	      opc_r;
  reg [3:0] 	      opc_15;
  
  wire 		      bce_1;
  wire [23:0] 	      alpha_1;
  wire [17:0] 	      acntrl_1;
  wire 		      bc_pol_1;
  wire [351:0] 	      vertex0_1;
  wire [351:0] 	      vertex1_1;
  wire [351:0] 	      vertex2_1;
  wire 		      not_zero_z0;
  wire 		      not_zero_z1;
  wire 		      not_zero_z2;
  wire [31:0] 	      z0_fp;
  wire [31:0] 	      z1_fp;
  wire [31:0] 	      z2_fp;
  wire [31:0] 	      u0_fp;
  wire [31:0] 	      v0_fp;
  wire [31:0] 	      u1_fp;
  wire [31:0] 	      v1_fp;
  wire [31:0] 	      u2_fp;
  wire [31:0] 	      v2_fp;
  wire [31:0] 	      p0z_fp;
  wire [31:0] 	      p1z_fp;
  wire [31:0] 	      p2z_fp;
  wire [31:0] 	      p0uw_fp;
  wire [31:0] 	      p0vw_fp;
  wire [31:0] 	      p1uw_fp;
  wire [31:0] 	      p1vw_fp;
  wire [31:0] 	      p2uw_fp;
  wire [31:0] 	      p2vw_fp;
  
  reg [209:0] 	      lod_15;         // LOD [9:0]  origin
  reg [31:0] 	      hith_15;	      // clipping hither.
  reg [31:0] 	      yon_15;	      // clipping yon.
  reg [27:0] 	      zorg_15;        // Z origin pointer
  reg [11:0] 	      zptch_15;	      // Z pitch register output
  reg [20:0] 	      tporg_15;       // Texture palette origin
  reg [11:0] 	      tptch_15;	      // Texture pitch register output
  reg [31:0] 	      fcol_15;        // Fog color
  reg [31:0] 	      texbc_15;       // Texture Boarder Color
  reg [23:0] 	      key3dlo_15;     // Alpha value   register
  reg [23:0] 	      key3dhi_15;     // Alpha value   register
  reg [31:0] 	      c3d_15;         // 3D Control Register
  reg [31:0] 	      tex_15;         // Texture Control Register
  reg [31:0] 	      blendc_15;      // OpenGL blending constant
  reg [23:0] 	      alpha_15;
  reg [17:0] 	      acntrl_15;
  reg [31:0] 	      pptr3d_15;
  reg [1:0] 	      zsc_add;
  reg [351:0] 	      vertex0_15u;    // Vertex 0.
  reg [351:0] 	      vertex1_15u;    // Vertex 1.
  reg [351:0] 	      vertex2_15u;    // Vertex 2.

  /************************************************************************/
  /* Transfer non sorted vertices to rdmux				*/
  /************************************************************************/
  
  assign rect_15 = c3d_15[28];	// Rectangle Mode.
  wire 		      line_3d_1  = (opc_r == LINE_3D);
  wire 		      trian_3d_1 = (opc_r == TRIAN_3D);
  wire 		      line_3d_15  = (opc_15 == LINE_3D);
  wire 		      trian_3d_15 = (opc_15 == TRIAN_3D);
  
  wire 		      cmd_3d     = trian_3d_1 | line_3d_1;
  wire 		      cull_polarity_1;
  wire 		      sort_on = trian_3d_1 & ~c3d_1[28];
  
  assign line_3d_actv_15  = (opc_15 == LINE_3D);
  assign bc_pol_1 = ~(cull_polarity_1 ^ c3d_1[22]);
  assign bce_1 = trian_3d_1 & c3d_1[23];
  
  assign alpha_1[15:0] 	= {adstreg_r,asrcreg_r};
  assign alpha_1[23:16]	= atest_r;
  assign acntrl_1[10:0] 	= {be_r,dre_r,sre_r, adst_r,asrc_r};
  assign acntrl_1[17:11] 	= {da_r,amd_r,asl_r,aen_r,aop_r};
  
  // Pipeline all the goodies from the hb/dlp
  // It has been looking like we will have trouble getting from
  // hb/dlp through des_mulf and setup in 15ns.  The 3d_trig 
  // register is in der_reg.

  reg [31:0] 	      hb_din;	// host bus data
  reg [8:2] 	      hb_adr;	// host bus address
  reg 		      hb_wstrb;	// host bus write strobes
  reg [3:0] 	      hb_ben;	// host bus byte enables.
  reg 		      hb_csn;	// host bus chip select.
  
  always @(posedge hb_clk) begin
    hb_din   <= hb_din_p;
    hb_adr   <= hb_adr_p;
    hb_wstrb <= hb_wstrb_p;
    hb_ben   <= hb_ben_p;
    hb_csn   <= hb_cp_csn;
  end //

  //////////////////////////////////////////////////////////////////////////
  //
  // OPCODE Register.
  // Mirror of the OPCODE register in the 2D core.

  always @(posedge hb_clk, negedge hb_rstn)
    if(!hb_rstn) opc_r <= 4'h0;
    else if(hb_wstrb && !hb_csn && !hb_ben[0] && 
	    ((hb_adr==CMDR) || (hb_adr==CMD_3D) || (hb_adr==OPC)))
      opc_r <= hb_din[3:0];
  
  // CMDR 	= 7'b0_0100_10,	// 0x048
  // OPC 		= 7'b0_0101_00,	// 0x050
  // CMD_3D	= 7'b1_0110_10,	// 0x168
  
  //////////////////////////////////////////////////////////////////////////
  //
  // Sort Verticies.
  
  
  assign {cull_polarity_1, vertex2_1, vertex1_1, vertex0_1} 
    = vertex_sort(vertex2_u, vertex1_u, vertex0_u, sort_on, line_3d_1); 

  // For orthogonal mode, we mux in a 1.0 (3f800000) for all W values
  assign vertex0_w = (~tex_1`T_PCM) ? 32'h3f800000 : vertex0_u`VWW;
  assign vertex1_w = (~tex_1`T_PCM) ? 32'h3f800000 : vertex1_u`VWW;
  assign vertex2_w = (~tex_1`T_PCM) ? 32'h3f800000 : vertex2_u`VWW;
  
  ///////////////////////////////////////////////////////////////////////////
  // Multiply all inputs by W coming in, if opc_r = TRIAN_3D and register
  // written in is the UV coordinates for Vertex 0,1 or 2
  //
  always @* 
    case(hb_adr)
      CP9, CP8, CP7, CP6: 	win = vertex0_w;
      CP17, CP16, CP15, CP14:  	win = vertex1_w;
      CP24, CP23, CP22, TRG3D: 	win = vertex2_w;
      default: win = 32'h3f80_0000;  // 1.0 in floating point
    endcase

  flt_mult_comb	u_flt_mult_comb	
    (win, hb_din[31:0], uvout);

  ///////////////////////////////////////////////////////////////////////////
  // subtract .5 to X,Y
  flt_add_sub_comb u_flt_add_sub_comb 
    (1'b1,hb_din[31:0], {2'b00,{6{c3d_1[21] & cmd_3d}},24'h0}, bias_space);

  // assign xy_in = (!bias_space[31]) ? bias_space : 32'h0;
  assign xy_in = bias_space;

  ///////////////////////////////////////////////////////////////////////////
  // Control Registers.
  always @(posedge hb_clk, negedge hb_rstn)
    if(!hb_rstn) begin
      tex_1               <= 32'h0;
      c3d_1               <= 32'h0;
      
      asl_r               <= 0;
      amd_r               <= 0;
      da_r                <= 0;
      
      color_mode_1        <= 0;
      {adst_r,asrc_r}     <= 8'h0;
      {be_r, dre_r,sre_r} <= 3'h0;
      {aen_r, aop_r}      <= 4'h0;
      c3d_1   	          <= 32'h0;
      tex_1   	          <= 32'h0;
      tptch_1 	          <= 12'h0;
      zptch_1 	          <= 12'h0;
      zorg_1  	          <= 28'h0;
      lod0_r  	          <= 21'h0;
      lod1_r  	          <= 21'h0;
      lod2_r  	          <= 21'h0;
      lod3_r  	          <= 21'h0;
      lod4_r  	          <= 21'h0;
      lod5_r  	          <= 21'h0;
      lod6_r  	          <= 21'h0;
      lod7_r  	          <= 21'h0;
      lod8_r  	          <= 21'h0;
      lod9_r              <= 21'h0;
      tporg_1 	          <= 21'h0;
      hith_1  	          <= 32'h0;
      yon_1   	          <= 32'h0;
      fcol_1  	          <= 32'h0;
      asrcreg_r	          <= 8'h0;
      adstreg_r	          <= 8'h0;
      atest_r		  <= 8'h0;
      texbc_1  	          <= 32'h0;
      key3dlo_1  	  <= 24'h0;
      key3dhi_1  	  <= 24'h0;
      blendc_1   	  <= 24'h0;
      pptr3d_1   	  <= 32'h0;
      vertex0_u`VALL	  <= 352'h0;
      vertex1_u`VALL	  <= 352'h0;
      vertex2_u`VALL	  <= 352'h0;
    end else begin // if (!hb_rstn)
      
      if (~tex_1`T_PCM) begin
	vertex0_u`VWW <= 32'h3f800000;
	vertex1_u`VWW <= 32'h3f800000;
	vertex2_u`VWW <= 32'h3f800000;
      end
      
      if (!hb_csn && hb_wstrb) begin
	if(hb_adr==ACNTRL) begin
          if(!hb_ben[0]){adst_r,asrc_r}     <= hb_din[7:0];
          if(!hb_ben[1]){be_r, dre_r,sre_r} <= hb_din[10:8];
	  if(!hb_ben[2]) {aen_r, aop_r}     <= hb_din[19:16];
	  if(!hb_ben[3]) {da_r,amd_r,asl_r} <= hb_din[26:24];
        end
        if(hb_adr==C3D) begin
          if (!hb_ben[0]) c3d_1[7:0]   <= hb_din[7:0];
          if (!hb_ben[1]) c3d_1[15:8]  <= hb_din[15:8];
          if (!hb_ben[2]) c3d_1[23:16] <= hb_din[23:16];
          if (!hb_ben[3]) c3d_1[31:24] <= hb_din[31:24];
        end
        if(hb_adr==TEX) begin
          if (!hb_ben[0]) tex_1[7:0]   <= hb_din[7:0];
          if (!hb_ben[1]) tex_1[15:8]  <= hb_din[15:8];
          if (!hb_ben[2]) tex_1[23:16] <= hb_din[23:16];
          if (!hb_ben[3]) tex_1[31:24] <= hb_din[31:24];
        end
        if(hb_adr==TPTCH) begin
          if(!hb_ben[0])tptch_1[3:0]  <= hb_din[7:4];
          if(!hb_ben[1])tptch_1[11:4] <= hb_din[15:8];
        end
        if(hb_adr==ZPTCH) begin
          if(!hb_ben[0])zptch_1[3:0]  <= hb_din[7:4];
          if(!hb_ben[1])zptch_1[11:4] <= hb_din[15:8];
        end
        if(hb_adr==ZORG) begin
          if(!hb_ben[0])zorg_1[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])zorg_1[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])zorg_1[19:12] <= hb_din[23:16];
          if(!hb_ben[3])zorg_1[27:20] <= hb_din[31:24];
        end
        if(hb_adr==LOD0) begin
          if(!hb_ben[0])lod0_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod0_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod0_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod0_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD1) begin
          if(!hb_ben[0])lod1_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod1_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod1_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod1_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD2) begin
          if(!hb_ben[0])lod2_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod2_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod2_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod2_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD3) begin
          if(!hb_ben[0])lod3_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod3_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod3_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod3_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD4) begin
          if(!hb_ben[0])lod4_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod4_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod4_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod4_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD5) begin
          if(!hb_ben[0])lod5_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod5_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod5_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod5_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD6) begin
          if(!hb_ben[0])lod6_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod6_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod6_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod6_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD7) begin
          if(!hb_ben[0])lod7_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod7_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod7_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod7_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD8) begin
          if(!hb_ben[0])lod8_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod8_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod8_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod8_r[20]    <= hb_din[24];
        end
        if(hb_adr==LOD9) begin
          if(!hb_ben[0])lod9_r[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])lod9_r[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])lod9_r[19:12] <= hb_din[23:16];
          if(!hb_ben[3])lod9_r[20]    <= hb_din[24];
        end
        if(hb_adr==TPAL) begin
          if(!hb_ben[0])tporg_1[3:0]   <= hb_din[7:4];
          if(!hb_ben[1])tporg_1[11:4]  <= hb_din[15:8];
          if(!hb_ben[2])tporg_1[19:12] <= hb_din[23:16];
          if(!hb_ben[3])tporg_1[20]    <= hb_din[24];
        end
        if(hb_adr==HITH) begin
          if(!hb_ben[0])hith_1[7:0]    <= hb_din[7:0];
          if(!hb_ben[1])hith_1[15:8]   <= hb_din[15:8];
          if(!hb_ben[2])hith_1[23:16]  <= hb_din[23:16];
          if(!hb_ben[3])hith_1[31:24]  <= hb_din[31:24];
        end
        if(hb_adr==YON) begin
          if(!hb_ben[0])yon_1[7:0]    <= hb_din[7:0];
          if(!hb_ben[1])yon_1[15:8]   <= hb_din[15:8];
          if(!hb_ben[2])yon_1[23:16]  <= hb_din[23:16];
          if(!hb_ben[3])yon_1[31:24]  <= hb_din[31:24];
        end
        if(hb_adr==FCOL) begin
          if(!hb_ben[0])fcol_1[7:0]    <= hb_din[7:0];
          if(!hb_ben[1])fcol_1[15:8]   <= hb_din[15:8];
          if(!hb_ben[2])fcol_1[23:16]  <= hb_din[23:16];
          if(!hb_ben[3])fcol_1[31:24]  <= hb_din[31:24];
        end
        if(hb_adr==ALPHA) begin
          if(!hb_ben[0])asrcreg_r      <= hb_din[7:0];
          if(!hb_ben[1])adstreg_r      <= hb_din[15:8];
          if(!hb_ben[2])atest_r        <= hb_din[23:16];
        end
        if(hb_adr==TBOARD) begin
          if(!hb_ben[0])texbc_1[7:0]    <= hb_din[7:0];
          if(!hb_ben[1])texbc_1[15:8]   <= hb_din[15:8];
          if(!hb_ben[2])texbc_1[23:16]  <= hb_din[23:16];
          if(!hb_ben[3])texbc_1[31:24]  <= hb_din[31:24];
        end
        if(hb_adr==KY3DLO) begin
          if(!hb_ben[0])key3dlo_1[7:0]   <= hb_din[7:0];
          if(!hb_ben[1])key3dlo_1[15:8]  <= hb_din[15:8];
          if(!hb_ben[2])key3dlo_1[23:16] <= hb_din[23:16];
        end
        if(hb_adr==KY3DHI) begin
          if(!hb_ben[0])key3dhi_1[7:0]   <= hb_din[7:0];
          if(!hb_ben[1])key3dhi_1[15:8]  <= hb_din[15:8];
          if(!hb_ben[2])key3dhi_1[23:16] <= hb_din[23:16];
        end
        if(hb_adr==BLENDC) begin
            if(!hb_ben[0])blendc_1[7:0]   <= hb_din[7:0];
          if(!hb_ben[1])blendc_1[15:8]  <= hb_din[15:8];
          if(!hb_ben[2])blendc_1[23:16] <= hb_din[23:16];
          if(!hb_ben[3])blendc_1[31:24] <= hb_din[31:24];
        end
	if (hb_adr==CP0) begin
          if (!hb_ben[0]) pptr3d_1[7:0]   <= hb_din[7:0];
          if (!hb_ben[1]) pptr3d_1[15:8]  <= hb_din[15:8];
          if (!hb_ben[2]) pptr3d_1[23:16] <= hb_din[23:16];
          if (!hb_ben[3]) pptr3d_1[31:24] <= hb_din[31:24];
	end
	if (hb_adr==CP1) begin // V0X
          if (!hb_ben[0]) vertex0_u`VXB0 <= xy_in[7:0];
          if (!hb_ben[1]) vertex0_u`VXB1 <= xy_in[15:8];
          if (!hb_ben[2]) vertex0_u`VXB2 <= xy_in[23:16];
          if (!hb_ben[3]) vertex0_u`VXB3 <= xy_in[31:24];
	end
	if (hb_adr==CP2) begin // V0Y
	  if (!hb_ben[0]) vertex0_u`VYB0 <= xy_in[7:0];
	  if (!hb_ben[1]) vertex0_u`VYB1 <= xy_in[15:8];
	  if (!hb_ben[2]) vertex0_u`VYB2 <= xy_in[23:16];
	  if (!hb_ben[3]) vertex0_u`VYB3 <= xy_in[31:24];
	end
	if (hb_adr==CP3) begin // V0Z
	  if (!hb_ben[0]) vertex0_u`VZB0 <= xy_in[7:0];
	  if (!hb_ben[1]) vertex0_u`VZB1 <= xy_in[15:8];
	  if (!hb_ben[2]) vertex0_u`VZB2 <= xy_in[23:16];
	  if (!hb_ben[3]) vertex0_u`VZB3 <= xy_in[31:24];
	end
	if (hb_adr==CP4) begin // V0W
	  if (!hb_ben[0]) vertex0_u`VWB0 <= hb_din[7:0];
	  if (!hb_ben[1]) vertex0_u`VWB1 <= hb_din[15:8];
	  if (!hb_ben[2]) vertex0_u`VWB2 <= hb_din[23:16];
	  if (!hb_ben[3]) vertex0_u`VWB3 <= hb_din[31:24];
	end
	if (hb_adr==CP5) begin // Color Int.
	  if(~&hb_ben[3:0]) color_mode_1 <= 1'b0;
	  if (!hb_ben[0]) vertex0_u`VBB0 <= hb_din[7:0];
	  if (!hb_ben[1]) vertex0_u`VGB0 <= hb_din[15:8];
	  if (!hb_ben[2]) vertex0_u`VRB0 <= hb_din[23:16];
	  if (!hb_ben[3]) vertex0_u`VAB0 <= hb_din[31:24];
	end
	if (hb_adr==CP6) begin // Specular Color Int Fog, Rs, Gs, Bs.
	  if (!hb_ben[0]) vertex0_u`VSB0 <= hb_din[7:0];
	  if (!hb_ben[1]) vertex0_u`VSB1 <= hb_din[15:8];
	  if (!hb_ben[2]) vertex0_u`VSB2 <= hb_din[23:16];
	  if (!hb_ben[3]) vertex0_u`VSB3 <= hb_din[31:24];
	end
	if (hb_adr==CP7) begin // V0U
	  if (!hb_ben[0]) vertex0_u`VUB0 <= uvout[7:0];
	  if (!hb_ben[1]) vertex0_u`VUB1 <= uvout[15:8];
	  if (!hb_ben[2]) vertex0_u`VUB2 <= uvout[23:16];
	  if (!hb_ben[3]) vertex0_u`VUB3 <= uvout[31:24];
	end
	if (hb_adr==CP8) begin // V0V
	  if (!hb_ben[0]) vertex0_u`VVB0 <= uvout[7:0];
	  if (!hb_ben[1]) vertex0_u`VVB1 <= uvout[15:8];
	  if (!hb_ben[2]) vertex0_u`VVB2 <= uvout[23:16];
	  if (!hb_ben[3]) vertex0_u`VVB3 <= uvout[31:24];
	end
	if (hb_adr==CP9) begin // V1X
          if (!hb_ben[0]) vertex1_u`VXB0 <= xy_in[7:0];
          if (!hb_ben[1]) vertex1_u`VXB1 <= xy_in[15:8];
          if (!hb_ben[2]) vertex1_u`VXB2 <= xy_in[23:16];
          if (!hb_ben[3]) vertex1_u`VXB3 <= xy_in[31:24];
	end
	if (hb_adr==CP10) begin // V1Y
	  if (!hb_ben[0]) vertex1_u`VYB0 <= xy_in[7:0];
	  if (!hb_ben[1]) vertex1_u`VYB1 <= xy_in[15:8];
	  if (!hb_ben[2]) vertex1_u`VYB2 <= xy_in[23:16];
	  if (!hb_ben[3]) vertex1_u`VYB3 <= xy_in[31:24];
	end
	if (hb_adr==CP11) begin // V1Z
	  if (!hb_ben[0]) vertex1_u`VZB0 <= hb_din[7:0];
	  if (!hb_ben[1]) vertex1_u`VZB1 <= hb_din[15:8];
	  if (!hb_ben[2]) vertex1_u`VZB2 <= hb_din[23:16];
	  if (!hb_ben[3]) vertex1_u`VZB3 <= hb_din[31:24];
	end
	if (hb_adr==CP12) begin // V1W
	  if (!hb_ben[0]) vertex1_u`VWB0 <= xy_in[7:0];
	  if (!hb_ben[1]) vertex1_u`VWB1 <= xy_in[15:8];
	  if (!hb_ben[2]) vertex1_u`VWB2 <= xy_in[23:16];
	  if (!hb_ben[3]) vertex1_u`VWB3 <= xy_in[31:24];
	end
	if (hb_adr==CP13) begin // V1 Color Int.
          if(~&hb_ben[3:0]) color_mode_1 <= 1'b0;
          if (!hb_ben[0]) vertex1_u`VBB0 <= hb_din[7:0];
          if (!hb_ben[1]) vertex1_u`VGB0 <= hb_din[15:8];
          if (!hb_ben[2]) vertex1_u`VRB0 <= hb_din[23:16];
          if (!hb_ben[3]) vertex1_u`VAB0 <= hb_din[31:24];
	end
	if (hb_adr==CP14) begin // V1 Specular Fog, Rs, Gs, Bs.
          if (!hb_ben[0]) vertex1_u`VSB0 <= hb_din[7:0];
          if (!hb_ben[1]) vertex1_u`VSB1 <= hb_din[15:8];
          if (!hb_ben[2]) vertex1_u`VSB2 <= hb_din[23:16];
          if (!hb_ben[3]) vertex1_u`VSB3 <= hb_din[31:24];
	end
	if (hb_adr==CP15) begin // V1U
          if (!hb_ben[0]) vertex1_u`VUB0 <= uvout[7:0];
          if (!hb_ben[1]) vertex1_u`VUB1 <= uvout[15:8];
          if (!hb_ben[2]) vertex1_u`VUB2 <= uvout[23:16];
          if (!hb_ben[3]) vertex1_u`VUB3 <= uvout[31:24];
	end
	if (hb_adr==CP16) begin // V1V
          if (!hb_ben[0]) vertex1_u`VVB0 <= uvout[7:0];
          if (!hb_ben[1]) vertex1_u`VVB1 <= uvout[15:8];
          if (!hb_ben[2]) vertex1_u`VVB2 <= uvout[23:16];
          if (!hb_ben[3]) vertex1_u`VVB3 <= uvout[31:24];
	end
	if (hb_adr==CP17) begin // V2X
          if (!hb_ben[0]) vertex2_u`VXB0 <= xy_in[7:0];
          if (!hb_ben[1]) vertex2_u`VXB1 <= xy_in[15:8];
          if (!hb_ben[2]) vertex2_u`VXB2 <= xy_in[23:16];
          if (!hb_ben[3]) vertex2_u`VXB3 <= xy_in[31:24];
	end
	if (hb_adr==CP18) begin // V2Y
          if (!hb_ben[0]) vertex2_u`VYB0 <= xy_in[7:0];
          if (!hb_ben[1]) vertex2_u`VYB1 <= xy_in[15:8];
          if (!hb_ben[2]) vertex2_u`VYB2 <= xy_in[23:16];
          if (!hb_ben[3]) vertex2_u`VYB3 <= xy_in[31:24];
	end
	if (hb_adr==CP19) begin // V2Z
          if (!hb_ben[0]) vertex2_u`VZB0 <= hb_din[7:0];
          if (!hb_ben[1]) vertex2_u`VZB1 <= hb_din[15:8];
          if (!hb_ben[2]) vertex2_u`VZB2 <= hb_din[23:16];
          if (!hb_ben[3]) vertex2_u`VZB3 <= hb_din[31:24];
	end
	if (hb_adr==CP20) begin // V2W
          if (!hb_ben[0]) vertex2_u`VWB0 <= hb_din[7:0];
          if (!hb_ben[1]) vertex2_u`VWB1 <= hb_din[15:8];
          if (!hb_ben[2]) vertex2_u`VWB2 <= hb_din[23:16];
          if (!hb_ben[3]) vertex2_u`VWB3 <= hb_din[31:24];
	end
	if (hb_adr==CP21) begin // V2 Color Int.
          if(~&hb_ben[3:0]) color_mode_1  <= 1'b0;
          if (!hb_ben[0]) vertex2_u`VBB0 <= hb_din[7:0];
          if (!hb_ben[1]) vertex2_u`VGB0 <= hb_din[15:8];
          if (!hb_ben[2]) vertex2_u`VRB0 <= hb_din[23:16];
          if (!hb_ben[3]) vertex2_u`VAB0 <= hb_din[31:24];
	end
	if (hb_adr==CP22) begin // V2 Specular Fog, Rs, Gs, Bs.
          if (!hb_ben[0]) vertex2_u`VSB0 <= hb_din[7:0];
          if (!hb_ben[1]) vertex2_u`VSB1 <= hb_din[15:8];
          if (!hb_ben[2]) vertex2_u`VSB2 <= hb_din[23:16];
          if (!hb_ben[3]) vertex2_u`VSB3 <= hb_din[31:24];
	end
	if (hb_adr==CP23) begin // V2U
          if (!hb_ben[0]) vertex2_u`VUB0 <= uvout[7:0];
          if (!hb_ben[1]) vertex2_u`VUB1 <= uvout[15:8];
          if (!hb_ben[2]) vertex2_u`VUB2 <= uvout[23:16];
          if (!hb_ben[3]) vertex2_u`VUB3 <= uvout[31:24];
	end
	if (hb_adr==CP24) begin
	  // V2V
          if (!hb_ben[0]) vertex2_u`VVB0 <= uvout[7:0];
          if (!hb_ben[1]) vertex2_u`VVB1 <= uvout[15:8];
          if (!hb_ben[2]) vertex2_u`VVB2 <= uvout[23:16];
          if (!hb_ben[3]) vertex2_u`VVB3 <= uvout[31:24];
	end
	if (hb_adr==V0AF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex0_u`VAB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex0_u`VAB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex0_u`VAB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex0_u`VAB3 <= hb_din[31:24];
	end
	if (hb_adr==V0RF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex0_u`VRB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex0_u`VRB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex0_u`VRB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex0_u`VRB3 <= hb_din[31:24];
	end
	if (hb_adr==V0GF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex0_u`VGB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex0_u`VGB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex0_u`VGB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex0_u`VGB3 <= hb_din[31:24];
	end
	if (hb_adr==V0BF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex0_u`VBB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex0_u`VBB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex0_u`VBB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex0_u`VBB3 <= hb_din[31:24];
	end
	if (hb_adr==V1AF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex1_u`VAB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex1_u`VAB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex1_u`VAB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex1_u`VAB3 <= hb_din[31:24];
	end
	if (hb_adr==V1RF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex1_u`VRB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex1_u`VRB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex1_u`VRB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex1_u`VRB3 <= hb_din[31:24];
	end
	if (hb_adr==V1GF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex1_u`VGB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex1_u`VGB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex1_u`VGB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex1_u`VGB3 <= hb_din[31:24];
	end
	if (hb_adr==V1BF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex1_u`VBB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex1_u`VBB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex1_u`VBB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex1_u`VBB3 <= hb_din[31:24];
	end
	if (hb_adr==V2AF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex2_u`VAB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex2_u`VAB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex2_u`VAB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex2_u`VAB3 <= hb_din[31:24];
	end
	if (hb_adr==V2RF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex2_u`VRB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex2_u`VRB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex2_u`VRB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex2_u`VRB3 <= hb_din[31:24];
	end
	if (hb_adr==V2GF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex2_u`VGB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex2_u`VGB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex2_u`VGB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex2_u`VGB3 <= hb_din[31:24];
	end
	if (hb_adr==V2BF) begin
          if(~&hb_ben) color_mode_1  <= 1'b1;
      	  if (!hb_ben[0]) vertex2_u`VBB0 <= hb_din[7:0];
      	  if (!hb_ben[1]) vertex2_u`VBB1 <= hb_din[15:8];
      	  if (!hb_ben[2]) vertex2_u`VBB2 <= hb_din[23:16];
      	  if (!hb_ben[3]) vertex2_u`VBB3 <= hb_din[31:24];
	end
      end // if (!hb_csn && hb_wstrb)
    end // else: !if(!hb_rstn)

  always @(posedge de_clk, negedge de_rstn)
    if(!de_rstn) begin
      opc_15 		<= 4'h0;
      c3d_15		<= 32'h0;
      tex_15		<= 32'h0;       // Texture Control Register
    end	else if(go_sup & (line_3d_1 | trian_3d_1)) begin
      opc_15	        <= opc_r;
      c3d_15	        <= c3d_1;       // 3D Control Register
      tex_15	        <= tex_1;       // Texture Control Register
    end	else if(load_15 & !(line_3d_1 | trian_3d_1)) begin
      opc_15 		<= 4'h0;
      c3d_15		<= 32'h0;
      tex_15		<= 32'h0;       // Texture Control Register
    end

  always @(posedge de_clk, negedge de_rstn)
    if(!de_rstn) begin
      pptr3d_15       <= 32'h0;	     // Pattern Pointer 3D output XY1 or CP1
      vertex0_15u     <= 352'h0;     // Vertex 0.
      vertex1_15u     <= 352'h0;     // Vertex 1.
      vertex2_15u     <= 352'h0;     // Vertex 2.
      bc_pol_15       <= 1'b0;
      color_mode_15   <= 1'b0;	     // 0 = ARGB, 1 = Float.
      lod_15 	      <= 210'h0;
      zorg_15	      <= 28'h0;      // Z origin pointer
      zptch_15	      <= 12'h0;      // Z pitch register output
      tporg_15	      <= 21'h0;      // Texture palette origin
      tptch_15	      <= 12'h0;	     // Texture pitch register output
      hith_15	      <= 32'h0;	     // clipping hither.
      yon_15          <= 32'h0;	     // clipping yon.
      fcol_15	      <= 32'h0;      // Fog color
      texbc_15	      <= 32'h0;      // Texture Boarder Color
      key3dlo_15      <= 24'h0;      // Alpha value   register
      key3dhi_15      <= 24'h0;      // Alpha value   register
      blendc_15	      <= 32'h0;	     // OpenGL blending constant
      bce_15	      <= 1'b0;	     // Backface Cull enable
      alpha_15	      <= 24'h0;
      acntrl_15	      <= 18'h0;
    end else if(go_sup) begin
      pptr3d_15       <= pptr3d_1;	// Pattern Pointer 3D output XY1 or CP1
      vertex0_15u     <= vertex0_1;	// Vertex 0.
      vertex1_15u     <= vertex1_1;	// Vertex 1.
      vertex2_15u     <= vertex2_1;	// Vertex 2.
      bc_pol_15       <= bc_pol_1;
      color_mode_15   <= color_mode_1;	// 0 = ARGB, 1 = Float.
      lod_15 	      <= {lod9_r, lod8_r, lod7_r, lod6_r, lod5_r,
		       	  lod4_r, lod3_r, lod2_r, lod1_r, lod0_r}; 
      zorg_15	      <= zorg_1;        // Z origin pointer
      zptch_15	      <= zptch_1;	// Z pitch register output
      tporg_15	      <= tporg_1;       // Texture palette origin
      tptch_15	      <= tptch_1;	// Texture pitch register output
      hith_15	      <= hith_1;	// clipping hither.
      yon_15	      <= yon_1;  	// clipping yon.
      fcol_15	      <= fcol_1;        // Fog color
      texbc_15	      <= texbc_1;       // Texture Boarder Color
      key3dlo_15      <= key3dlo_1;     // Alpha value   register
      key3dhi_15      <= key3dhi_1;     // Alpha value   register
      blendc_15	      <= blendc_1;	// OpenGL blending constant
      bce_15	      <= bce_1;	        // Backface Cull enable
      alpha_15	      <= alpha_1;
      acntrl_15	      <= acntrl_1;
    end

  // Z Scaling
  // Scale to 16bpp for ps16_2
  // Otherwise to 34bpz
  // Use zsc_15 instead
  // ps_1 are the 15 bits for DSIZE
  // ps_1[0] is 16 bis per pixel
  always @*
    casex ({c3d_15`D3_ZS, ps_15[0]})
      2'b10:   zsc_add = 2'b11; // Add 24 to exponent
      2'b11:   zsc_add = 2'b10; // Add 16 to exponent
      default: zsc_add = 2'b00;
    endcase

  // Extract the Z. 
  assign z0_fp = vertex0_15u`VZW;
  assign z1_fp = vertex1_15u`VZW;
  assign z2_fp = vertex2_15u`VZW;
  
  // detect z not zero
  assign not_zero_z0 = |(z0_fp[30:0]);
  assign not_zero_z1 = |(z1_fp[30:0]);
  assign not_zero_z2 = |(z2_fp[30:0]);
  
  // Add 16 or 24
  assign p0z_fp = (not_zero_z0) ?  {z0_fp[31], (z0_fp[30:26] + zsc_add), z0_fp[25:0]} : 32'h0;
  assign p1z_fp = (not_zero_z1) ?  {z1_fp[31], (z1_fp[30:26] + zsc_add), z1_fp[25:0]} : 32'h0;
  assign p2z_fp = (not_zero_z2) ?  {z2_fp[31], (z2_fp[30:26] + zsc_add), z2_fp[25:0]} : 32'h0;
  
  // Extract uv.
  assign u0_fp = vertex0_15u`VUW;
  assign v0_fp = vertex0_15u`VVW;
  assign u1_fp = vertex1_15u`VUW;
  assign v1_fp = vertex1_15u`VVW;
  assign u2_fp = vertex2_15u`VUW;
  assign v2_fp = vertex2_15u`VVW;
  
  // detect uv not zero
  assign not_zero_u0 = |u0_fp[30:0];
  assign not_zero_v0 = |v0_fp[30:0];
  assign not_zero_u1 = |u1_fp[30:0];
  assign not_zero_v1 = |v1_fp[30:0];
  assign not_zero_u2 = |u2_fp[30:0];
  assign not_zero_v2 = |v2_fp[30:0];
  // U,V Scaling
  // Use uvsc_15
  // Use tex_15
  assign p0uw_fp = (tex_15`T_SCL & not_zero_u0) ?  {u0_fp[31], (u0_fp[30:23] + tex_15`T_MMSZX), u0_fp[22:0]} : u0_fp;
  assign p0vw_fp = (tex_15`T_SCL & not_zero_v0) ?  {v0_fp[31], (v0_fp[30:23] + tex_15`T_MMSZY), v0_fp[22:0]} : v0_fp;
  assign p1uw_fp = (tex_15`T_SCL & not_zero_u1) ?  {u1_fp[31], (u1_fp[30:23] + tex_15`T_MMSZX), u1_fp[22:0]} : u1_fp;
  assign p1vw_fp = (tex_15`T_SCL & not_zero_v1) ?  {v1_fp[31], (v1_fp[30:23] + tex_15`T_MMSZY), v1_fp[22:0]} : v1_fp;
  assign p2uw_fp = (tex_15`T_SCL & not_zero_u2) ?  {u2_fp[31], (u2_fp[30:23] + tex_15`T_MMSZX), u2_fp[22:0]} : u2_fp;
  assign p2vw_fp = (tex_15`T_SCL & not_zero_v2) ?  {v2_fp[31], (v2_fp[30:23] + tex_15`T_MMSZY), v2_fp[22:0]} : v2_fp;
  // Merge in the changes.
  assign vertex0_15 = {vertex0_15u[351:192], p0vw_fp, p0uw_fp, vertex0_15u[127:96], p0z_fp, vertex0_15u[63:0]};// Vertex 0.
  assign vertex1_15 = {vertex1_15u[351:192], p1vw_fp, p1uw_fp, vertex1_15u[127:96], p1z_fp, vertex1_15u[63:0]};// Vertex 1.
  assign vertex2_15 = {vertex2_15u[351:192], p2vw_fp, p2uw_fp, vertex2_15u[127:96], p2z_fp, vertex2_15u[63:0]};// Vertex 2.
  
  
  always @(posedge de_clk, negedge de_rstn)
    if(!de_rstn) begin
      c3d_2     <= 32'h0;
      tex_2     <= 32'h0;
      actv_3d_2 <= 1'b0;
    end
    else if(load_actv_3d & (line_3d_15 | trian_3d_15)) begin
      c3d_2     <= c3d_15;       // 3D Control Register
      tex_2     <= tex_15;       // Texture Control Register
      actv_3d_2 <= 1'b1;
    end
    // else if(!load_actvn & !(line_3d_15 | trian_3d_15)) begin
    else if(~load_actvn & ~line_3d_15 & ~trian_3d_15) begin
      c3d_2     <= 32'h0;
      tex_2     <= 32'h0;       // Texture Control Register
      actv_3d_2 <= 1'b0;
    end

  always @(posedge de_clk, negedge de_rstn)
    if(!de_rstn) begin
      pptr3d_2	<= 32'h0;
      lod_2		<= 210'h0;
      zorg_2		<= 28'h0;
      zptch_2		<= 12'h0;
      tporg_2		<= 21'h0;
      tptch_2		<= 12'h0;
      hith_2		<= 32'h0;
      yon_2		<= 32'h0;
      fcol_2		<= 32'h0;
      texbc_2		<= 32'h0;
      key3dlo_2	<= 24'h0;
      key3dhi_2	<= 24'h0;
      blendc_2	<= 32'h0;
      alpha_2		<= 24'h0;
      acntrl_2	<= 18'h0;
    end else if(load_actv_3d) begin
      pptr3d_2	<= pptr3d_15;
      lod_2		<= lod_15;
      zorg_2		<= zorg_15;
      zptch_2		<= zptch_15;
      tporg_2		<= tporg_15;
      tptch_2		<= tptch_15;
      hith_2		<= hith_15;
      yon_2		<= yon_15;
      fcol_2		<= fcol_15;
      texbc_2		<= texbc_15;
      key3dlo_2	<= key3dlo_15;
      key3dhi_2	<= key3dhi_15;
      blendc_2	<= blendc_15;
      alpha_2		<= alpha_15;
      acntrl_2	<= acntrl_15;
    end
  
  always @* begin
    cp_hb_dout = 32'h0;
    case(hb_adr_r)
      TPTCH: cp_hb_dout[11:0] = {tptch_1[11:4], tptch_1[3:0]};
      ZPTCH: cp_hb_dout[11:0] = {zptch_1[11:4], zptch_1[3:0]};
      ZORG: cp_hb_dout = zorg_1;
      LOD0: cp_hb_dout[20:0] = lod0_r;
      LOD1: cp_hb_dout[20:0] = lod1_r;
      LOD2: cp_hb_dout[20:0] = lod2_r;
      LOD3: cp_hb_dout[20:0] = lod3_r;
      LOD4: cp_hb_dout[20:0] = lod4_r;
      LOD5: cp_hb_dout[20:0] = lod5_r;
      LOD6: cp_hb_dout[20:0] = lod6_r;
      LOD7: cp_hb_dout[20:0] = lod7_r;
      LOD8: cp_hb_dout[20:0] = lod8_r;
      LOD9: cp_hb_dout[20:0] = lod9_r;
      TPAL: cp_hb_dout[24:4] = tporg_1;
      HITH: cp_hb_dout       = hith_1;
      YON:  cp_hb_dout       = yon_1;
      FCOL:  cp_hb_dout      = fcol_1;
      ALPHA:  cp_hb_dout[23:0] = {atest_r, adstreg_r, asrcreg_r};
      TBOARD:  cp_hb_dout[31:0] = texbc_1;
      KY3DLO: cp_hb_dout[23:0] = key3dlo_1;
      KY3DHI: cp_hb_dout[23:0] = key3dhi_1;
      BLENDC: cp_hb_dout[31:0] = blendc_1;
      CP0: cp_hb_dout[31:0] = pptr3d_1;
      CP1: cp_hb_dout[31:0] = vertex0_u`VXW; 	// V0X
      CP2: cp_hb_dout[31:0] = vertex0_u`VYW; 	// V0Y
      CP3: cp_hb_dout[31:0] = vertex0_u`VZW; 	// V0Z
      CP4: cp_hb_dout[31:0] = vertex0_u`VWW; 	// V0W
      CP5: cp_hb_dout[31:0] = {vertex0_u`VAB0, vertex0_u`VRB0, vertex0_u`VGB0, vertex0_u`VBB0}; // Color Int.
      CP6: cp_hb_dout[31:0] = vertex0_u`VSW; // Fog, Rs, Gs, Bs.
      CP7: cp_hb_dout[31:0] = vertex0_u`VUW; // V0U
      CP8: cp_hb_dout[31:0] = vertex0_u`VVW; // V0V
      CP9: cp_hb_dout[31:0] = vertex1_u`VXW; // V1X
      CP10: cp_hb_dout[31:0] = vertex1_u`VYW; // V1Y
      CP11: cp_hb_dout[31:0] = vertex1_u`VZW; // V1Z
      CP12: cp_hb_dout[31:0] = vertex1_u`VWW; // V1W
      CP13: cp_hb_dout[31:0] = {vertex1_u`VAB0, vertex1_u`VRB0, vertex1_u`VGB0, vertex1_u`VBB0}; // Color Int.
      CP14: cp_hb_dout[31:0] = vertex1_u`VSW; // Fog, Rs, Gs, Bs.
      CP15: cp_hb_dout[31:0] = vertex1_u`VUW; // V1U
      CP16: cp_hb_dout[31:0] = vertex1_u`VVW; // V1V
      CP17: cp_hb_dout[31:0] = vertex2_u`VXW; // V2X
      CP18: cp_hb_dout[31:0] = vertex2_u`VYW; // V2Y
      CP19: cp_hb_dout[31:0] = vertex2_u`VZW; // V2Z
      CP20: cp_hb_dout[31:0] = vertex2_u`VWW; // V2W
      CP21: cp_hb_dout[31:0] = {vertex2_u`VAB0, vertex2_u`VRB0, vertex2_u`VGB0, vertex2_u`VBB0}; // V2 Color Int.
      CP22: cp_hb_dout[31:0] = vertex2_u`VSW; // Fog, Rs, Gs, Bs.
      CP23: cp_hb_dout[31:0] = vertex2_u`VUW; // V2U
      CP24: cp_hb_dout[31:0] = vertex2_u`VVW; // V2V
      V0AF: cp_hb_dout[31:0] = vertex0_u`VAW;
      V0RF: cp_hb_dout[31:0] = vertex0_u`VRW;
      V0GF: cp_hb_dout[31:0] = vertex0_u`VGW;
      V0BF: cp_hb_dout[31:0] = vertex0_u`VBW;
      V1AF: cp_hb_dout[31:0] = vertex1_u`VAW;
      V1RF: cp_hb_dout[31:0] = vertex1_u`VRW;
      V1GF: cp_hb_dout[31:0] = vertex1_u`VGW;
      V1BF: cp_hb_dout[31:0] = vertex1_u`VBW;
      V2AF: cp_hb_dout[31:0] = vertex2_u`VAW;
      V2RF: cp_hb_dout[31:0] = vertex2_u`VRW;
      V2GF: cp_hb_dout[31:0] = vertex2_u`VGW;
      V2BF: cp_hb_dout[31:0] = vertex2_u`VBW;
      default: cp_hb_dout = 32'h0;
    endcase
  end
  
  /************************************************************************/
  /* vertex_sort is the vertex level sorter which muxes the vertices 	*/
  /* into the registers going into the setup engine. smallest vertex goes */
  /* into output 0, largest into output 3.                                */
  /************************************************************************/
  function [1056:0] vertex_sort;
    input   [351:0]  	vertex2;	// vertex 2
    input [351:0] 	vertex1;	// vertex 1
    input [351:0] 	vertex0;	// vertex 0
    input           	trian_3d;	// Executing a 3D triangle
    input           	line_3d;	// executing a 3D line
    
    //////////////////////////////////////////////////////////////////////////
    //
    reg [351:0] 	vertex0_s;
    reg [351:0] 	vertex1_s;
    reg [351:0] 	vertex2_s;
    reg 		cull_polarity;	// 0 = sign, 1= ~sign
    reg 		v0_lt_v1;  	// Vertex 0 is less than Vertex 1
    reg 		v1_lt_v2;  	// Vertex 1 is less than Vertex 2
    reg 		v0_lt_v2;  	// Vertex 0 is less than Vertex 2 
    
    begin
      // Compare the Y values
      v0_lt_v1 = fp_comp(vertex0`VYW, vertex1`VYW);
      v1_lt_v2 = fp_comp(vertex1`VYW, vertex2`VYW);
      v0_lt_v2 = fp_comp(vertex0`VYW, vertex2`VYW);
      // cull mux
      casex ({v0_lt_v1,v1_lt_v2,v0_lt_v2})
        3'b000, 3'b001, 3'b110: cull_polarity = 1;
        3'b010: cull_polarity = 0;
        3'b011: cull_polarity = 1;
        3'b100: cull_polarity = 0;
        3'b101: cull_polarity = 1;
        3'b111: cull_polarity = 0;
      endcase
      // Vertex MUX
      casex ({line_3d,trian_3d,v0_lt_v1,v1_lt_v2,v0_lt_v2})
	5'b01_000, 5'b01_001, 5'b01_110: begin vertex0_s = vertex2; vertex1_s = vertex1; vertex2_s = vertex0; end
	5'b01_010: begin vertex0_s = vertex1; vertex1_s = vertex2; vertex2_s = vertex0; end
	5'b01_011: begin vertex0_s = vertex1; vertex1_s = vertex0; vertex2_s = vertex2; end
	5'b01_100: begin vertex0_s = vertex2; vertex1_s = vertex0; vertex2_s = vertex1; end
	5'b01_101: begin vertex0_s = vertex0; vertex1_s = vertex2; vertex2_s = vertex1; end
	5'b00_xxx,5'b01_111: begin vertex0_s = vertex0; vertex1_s = vertex1; vertex2_s = vertex2; end
	// Lines
	// 5'b10_x0x: begin vertex0_s = vertex2; vertex1_s = vertex2; vertex2_s = vertex1; end
	// 5'b10_x1x: begin vertex0_s = vertex1; vertex1_s = vertex1; vertex2_s = vertex2; end    
	5'b1x_xxx: begin vertex0_s = vertex1; vertex1_s = vertex1; vertex2_s = vertex2; end    
	default:   begin vertex0_s = 352'h0; vertex1_s = 352'h0; vertex2_s = 352'h0; end    
      endcase
      
      vertex_sort = {cull_polarity, vertex2_s, vertex1_s, vertex0_s};
    end
    
  endfunction

  // Floating Point less than magnitude comparator. 
  // This module takes two IEEE single precision floating point and does a
  // Comparison to determine ehich is smaller.                         
  function fp_comp;
    input     [31:0]   fp1;           // IEEE floating point input
    input [31:0]       fp2;           // IEEE floating point input
    // Figure out which one is smaller
    begin
      casex({fp1[31],fp2[31], (fp1[30:23] < fp2[30:23]), (fp1[30:23] == fp2[30:23]), (fp1[22:0] < fp2[22:0])})
	5'b10_xxx:            fp_comp = 1;        // fp1 is neg and fp2 is pos
	5'b01_xxx:            fp_comp = 0;        // fp1 is pos and fp2 is neg
	5'b00_1xx:            fp_comp = 1;        // exp1 < exp2
	5'b00_00x:            fp_comp = 0;        // exp1 > exp2
	5'b00_011:            fp_comp = 1;        // exp1 = exp2, mant1 < mant2
	5'b00_010:            fp_comp = 0;        // exp1 = exp2, mant1 >= mant2
	5'b11_1xx:            fp_comp = 0;        // exp1 < exp2
	5'b11_00x:            fp_comp = 1;        // exp1 > exp2
	5'b11_011:            fp_comp = 0;        // exp1 = exp2, mant1 < mant2
	5'b11_010:            fp_comp = 1;        // exp1 = exp2, mant1 >= mant2
      endcase    
    end
  endfunction
  
  //////////////////////////////////////////////////////////////////////////////
  // Simulation debug stuff. 
`ifdef RTL_SIM
  always @* begin
    if (go_sup) begin
      $display($stime, " Executing 3D Command\n");
      // $display("\t\tFORE:  %h", fore_1);
      // $display("\t\tBACK:  %h", back_1);
      // $display("\t\tXY0:   %h", xy0_1);
      // $display("\t\tTPTCH: cp_hb_dout[11:0] = {tptch_1[11:4], tptch_1[3:0]};
      // $display("\t\tZPTCH: cp_hb_dout[11:0] = {zptch_1[11:4], zptch_1[3:0]};
      // $display("\t\tZORG: cp_hb_dout = zorg_1;
      // $display("\t\tLOD0: cp_hb_dout[20:0] = lod0_r;
      // $display("\t\tLOD1: cp_hb_dout[20:0] = lod1_r;
      // $display("\t\tLOD2: cp_hb_dout[20:0] = lod2_r;
      // $display("\t\tLOD3: cp_hb_dout[20:0] = lod3_r;
      // $display("\t\tLOD4: cp_hb_dout[20:0] = lod4_r;
      // $display("\t\tLOD5: cp_hb_dout[20:0] = lod5_r;
      // $display("\t\tLOD6: cp_hb_dout[20:0] = lod6_r;
      // $display("\t\tLOD7: cp_hb_dout[20:0] = lod7_r;
      // $display("\t\tLOD8: cp_hb_dout[20:0] = lod8_r;
      // $display("\t\tLOD9: cp_hb_dout[20:0] = lod9_r;
      // $display("\t\tTPAL: cp_hb_dout[24:4] = tporg_1;
      // $display("\t\tHITH: cp_hb_dout[24:4] = hith_1;
      // $display("\t\tYON:  cp_hb_dout 	    = yon_1;
      // $display("\t\tFCOL:  cp_hb_dout 	    = fcol_1;
      // $display("\t\tALPHA:  cp_hb_dout[23:0] = {atest_r, adstreg_r, asrcreg_r};
      // $display("\t\tTBOARD:  cp_hb_dout[31:0] = texbc_1;
      // $display("\t\tKY3DLO: cp_hb_dout[23:0] = key3dlo_1;
      // $display("\t\tKY3DHI: cp_hb_dout[23:0] = key3dhi_1;
      // $display("\t\tBLENDC: cp_hb_dout[31:0] = blendc_1;
      $display("\t\tPPTR3D: %h", pptr3d_1);
      $display("\t\tV0X: %h", vertex0_u`VXW); 	// V0X
      $display("\t\tVOY: %h", vertex0_u`VYW); 	// V0Y
      $display("\t\tV0Z: %h", vertex0_u`VZW); 	// V0Z
      $display("\t\tV0W: %h", vertex0_u`VWW); 	// V0W
      $display("\t\tV0CI: %h", {vertex0_u`VAB0, vertex0_u`VRB0, vertex0_u`VGB0, vertex0_u`VBB0}); // Color Int.
      $display("\t\tV0S: %h", vertex0_u`VSW); // Fog, Rs, Gs, Bs.
      $display("\t\tV0U: %h", vertex0_u`VUW); // V0U
      $display("\t\tV0V: %h", vertex0_u`VVW); // V0V
      $display("\t\tV1X: %h", vertex1_u`VXW); 	// V1X
      $display("\t\tV1Y: %h", vertex1_u`VYW); 	// V1Y
      $display("\t\tV1Z: %h", vertex1_u`VZW); 	// V1Z
      $display("\t\tV1W: %h", vertex1_u`VWW); 	// V1W
      $display("\t\tV1CI: %h", {vertex1_u`VAB0, vertex1_u`VRB0, vertex1_u`VGB0, vertex1_u`VBB0}); // Color Int.
      $display("\t\tV1S: %h", vertex1_u`VSW); // Fog, Rs, Gs, Bs.
      $display("\t\tV1U: %h", vertex1_u`VUW); // V1U
      $display("\t\tV1V: %h", vertex1_u`VVW); // V1V
      $display("\t\tV2X: %h", vertex2_u`VXW); 	// V2X
      $display("\t\tV2Y: %h", vertex2_u`VYW); 	// V2Y
      $display("\t\tV2Z: %h", vertex2_u`VZW); 	// V2Z
      $display("\t\tV2W: %h", vertex2_u`VWW); 	// V2W
      $display("\t\tV2CI: %h", {vertex2_u`VAB0, vertex2_u`VRB0, vertex2_u`VGB0, vertex2_u`VBB0}); // Color Int.
      $display("\t\tV2S: %h", vertex2_u`VSW); // Fog, Rs, Gs, Bs.
      $display("\t\tV2U: %h", vertex2_u`VUW); // V2U
      $display("\t\tV2V: %h", vertex2_u`VVW); // V2V
      $display("\t\tV0AF: %h", vertex0_u`VAW);
      $display("\t\tV0RF: %h", vertex0_u`VRW);
      $display("\t\tV0GF: %h", vertex0_u`VGW);
      $display("\t\tV0BF: %h", vertex0_u`VBW);
	  $display("\t\tV1AF: %h", vertex1_u`VAW);
      $display("\t\tV1RF: %h", vertex1_u`VRW);
      $display("\t\tV1GF: %h", vertex1_u`VGW);
      $display("\t\tV1BF: %h", vertex1_u`VBW);
      $display("\t\tV2AF: %h", vertex2_u`VAW);
      $display("\t\tV2RF: %h", vertex2_u`VRW);
      $display("\t\tV2GF: %h", vertex2_u`VGW);
      $display("\t\tV2BF: %h", vertex2_u`VBW);
    end // if (cmdack)
  end // always @ *
`endif
  
endmodule
