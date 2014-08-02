///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2009 - All rights reserved
//
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Conexant Systems, Inc., hereafter the "licensee", as defined by the NDA and the 
//  license agreement. 
//
//  This code may not be used as a basis for new development without a written
//  agreement between Silicon Spectrum and the licensee. 
//
//  New development includes, but is not limited to new designs based on this 
//  code, using this code to aid verification or using this code to test code 
//  developed independently by the licensee.
//
//  This copyright notice must be maintained as written, modifying or removing
//  this copyright header will be considered a breach of the license agreement.
//
//  The licensee may modify the code for the licensed project.
//  Silicon Spectrum does not give up the copyright to the original 
//  file or encumber in any way.
//
//  Use of this file is restricted by the license agreement between the
//  licensee and Silicon Spectrum, Inc.
//  
//  Title       :  Drawing Engine Data Path
//  File        :  ded_top.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This is the Drawing Engine Data path 2D only
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

`timescale 1ns / 10ps

module ded_top
  #(parameter BYTES = 16)
  (
   // Global Signals
   input          de_clk,        // Drawing Engine Clock
                  de_rstn,       // Drawing Engine Reset
   
   // Host/ XY Windows
   input          hb_clk,         // host bus clock
                  hb_rstn,        // host bus reset
   input [12:2]   hb_adr,         // host bus lower address bits
   input          hb_we,          // host bus write strobe
   input          hb_xyw_csn,     // chip select for XY window
   // DEX related
   input          dx_mem_req,     // memory request
                  dx_mem_rd,      // memory read
                  dx_line_actv_2, // line command active signal
                  dx_blt_actv_2,  // bit blt active signal
   input          dx_pc_ld,       // load pixel cache
   input [31:0]   dx_clpx_bus_2,  // clipping X values
   input          dx_rstn_wad,    // load cache write address
   input          dx_ld_rad,      // load cache read address
   input          dx_ld_rad_e,    // load cache read address
   input          dx_sol_2,       // start of line flag
                  dx_eol_2,       // end of line flag
   input          dx_ld_msk,      // load mask.{ld_start,ld_end,
                                  //            ld_lftclp,ld_rhtclp}
   input [9:0]    dx_xalu,        // lower four bits of the X alu.
   input [15:0]   srcx,           // lower five bits from the  destination X
   input [15:0]   srcy,           // lower five bits from the  destination X
   input [15:0]   dsty,           // lower five bits from the  destination Y
   input [15:0]   dx_dstx,        // Current X for blts and xfers.
   input          dx_fg_bgn,      // fore/back ground bit for line pat.
   input          clip,           // Clip indicator.   PIPED SIGNAL
   input [4:0]    xpat_ofs,       // X off set for patterns.
   input [4:0]    ypat_ofs,       // Y off set for patterns.
   input [15:0]   real_dstx,      // X destination.
   input [15:0]   real_dsty,      // Y destination.
   input          ld_initial,     // load the initial color value.
   input          pc_msk_last,    // Mask the last pixel for nolast
   input          last_pixel,     // Last Pixel from Jim (Not Clean)
   input          ld_wcnt,
   input [3:0]    fx_1,
   input          rmw,
   
   // Memory Controller Inputs
   input          mclock,         // memory controller clock
   input          mc_popen,       // memory controller pop enable
   input          mc_push,        // push data into fifo from MC. 
                  mc_eop,         // end of page cycle pulse, from MC
                  mc_eop4,        // end of page cycle pulse, from MC
   input          de_pc_pop,      // Pop from PC
   
   // Level 2 Registers
   input [3:0]    de_pln_msk_2,   // Plane mask bits
   input          dr_solid_2,     // solid mode bit
                  dr_trnsp_2,     // transparent mode bit
   input [1:0]    stpl_2,         // stipple mode bit 01 = planar, 10 = packed
   input [1:0]    dr_apat_2,      // area mode bits 01 = 8x8, 10 = 32x32
   input [1:0]    dr_clp_2,       // lower two bits of the clipping register
   input [31:0]   fore_2,         // foreground register output
   input [31:0]   back_2,         // background register output
   input          dr_sen_2,       // Source enable bits
   input          y_clip_2,       // Inside the Y clipping boundries
   input          ps8_2,          // pixel size equals eight
                  ps16_2,         // pixel size equals sixteen
                  ps32_2,         // pixel size equals thirty-two
   input [1:0]    bc_lvl_2,       // Y page request limit
   input          hb_write,
   input [27:0]   dorg_2,        // Destination origin.
   input [27:0]   sorg_2,        // Source origin.
   input [27:0]   z_org,         // Z origin
   input [11:0]   dptch_2,        // destination pitch.
   input [11:0]   sptch_2,        // source pitch.
   input [11:0]   z_ptch,        // Z pitch
   input [1:0]    ps_2,           // Pixel size to MC
   input [3:0]    bsrcr_2,      // Source blending function.          
   input [2:0]    bdstr_2,      // Destination blending function.     
   input          blend_en_2,   // Blending enable.
   input [1:0]    blend_reg_en_2,// Select blending registers or alpha from FB
   input [7:0]    bsrc_alpha_2, // Source alpha data.                 
   input [7:0]    bdst_alpha_2, // Destination alpha data.            
   input [3:0]    rop_2,        // Raster operation.                  
   input [31:0]   kcol_2,       // Key Color.                         
   input [2:0]    key_ctrl_2,   // Key control.                       
   input [2:0]    frst8_2,      // used to be in dex
   
   // Memory Controller Outputs
   output [BYTES-1:0]  mc_pixel_msk,   // pixel mask data output
   output [(BYTES<<3)-1:0] mc_fb_out,      // frame buffer data output
   output [(BYTES<<2)-1:0] mc_fb_a,      // frame buffer data output
   output         pc_mc_busy,     // gated MC busy for Jim
   output [31:0]  de_mc_address,  // Line/ Blt linear address
   output         de_mc_read,
   output         de_mc_rmw,
   output [3:0]   de_mc_wcnt,
   output         de_pc_empty,
   output         pc_empty,
   
   // Host Bus
   output [31:0]  hb_dout,        // Host read back data.

   // ded_ca_top memory interface
   `ifdef BYTE16 output [3:0] ca_enable,
   `elsif BYTE8  output [1:0] ca_enable,
   `else         output       ca_enable, `endif
   output [4:0]   hb_ram_addr,
   output [4:0]           ca_ram_addr0,
   output [4:0]           ca_ram_addr1,
   input [(BYTES*8)-1:0] hb_dout_ram,
   input [(BYTES<<3)-1:0]    ca_dout0,
   input [(BYTES<<3)-1:0]    ca_dout1,

   // Drawing Engine
   output         pc_dirty,       // data is left in the pixel cache
   output         clip_ind,       // Clipping indicator.
   output         stpl_pk_4,      // packed stipple bit, level four
   output         pc_mc_rdy,      // Ready signal from PC to DX
   output         pipe_pending,    // There is something in the PC or pipe
   output         line_actv_4,
   output [1:0]   ps_4,
   output [3:0]   bsrcr_4,      // Source blending function.          
   output [2:0]   bdstr_4,      // Destination blending function.     
   output         blend_en_4,   // Blending enable.
   output [1:0]   blend_reg_en_4, // Blending register enables
   output [7:0]   bsrc_alpha_4, // Source alpha data.                 
   output [7:0]   bdst_alpha_4, // Destination alpha data.            
   output [3:0]   rop_4,        // Raster operation.                  
   output [31:0]  kcol_4,       // Key Color.                         
   output [2:0]   key_ctrl_4,    // Key control.                       
   ////////////////////////////////////////////////////////
   // 3D Interface.
   output         pc_busy_3d,
   input	  valid_3d,
   input	  fg_bgn_3d, 
   input	  msk_last_3d,
   input [15:0]	  x_out_3d,
   input [15:0]	  y_out_3d,
   input	  last_3d,
   input [31:0]   pixel_3d,
   input [31:0]   z_3d,
   input [4:0]    z_ctrl,
   input          active_3d_2,
   input [7:0]    alpha_3d,
   output	  pc_last,
   output [4:0]   z_ctrl_4,
   output [31:0]  z_address_4,
   output [(BYTES*8)-1:0] z_out
   );

  wire [(BYTES<<3)-1:0]         de_pc_data;
  wire [(BYTES<<2)-1:0] 	de_pc_a;
  wire [BYTES-1:0]              de_pc_mask;
  wire [1:0]                    clp_4;
  wire [31:0]                   fore_4;         // foreground register output
  wire [31:0]                   back_4;         // foreground register output

  /************************************************************************/
  /*            CREATE INTERNAL WIRE BUSSES                             */
  /************************************************************************/
  wire [(BYTES<<3)-1:0]         ca_din;         /* Data into cache.             */
  wire [BYTES-1:0]              cx_sel;         /* color expand selector.       */
  wire [BYTES-1:0]              trns_msk;       /* transparentcy mask.          */
  wire [9:0]                    ca_rad;         /* Cache read address.          */
  wire [7:0]                    ca_wr_en;       /* Cache write enables.         */
  wire [1:0]     apat_4;
  wire [2:0]     psize_4;
  wire [1:0]     stpl_4;  
  wire [8:0]     x_bitmask;      /* muxed input bitmask to texel cache */
  wire [8:0]     y_bitmask;      /* muxed input bitmask to texel cache */
  
  wire           ca_src_2               = dr_sen_2;
  reg            xyw_csn_d;
  `ifdef  BYTE16 wire [2:0]      ca_mc_addr;
  `elsif  BYTE8  wire [3:0]      ca_mc_addr;
  `else          wire [4:0]      ca_mc_addr;
  `endif
  wire           sol_3;
  wire           ps32_4;
  wire           ps16_4;
  wire           ps8_4;
  wire           solid_4;
  wire           blt_actv_4;
  wire           trnsp_4;
  wire           eol_4;
  wire           pc_busy;
  wire [3:0]     mask_4;
  wire           rad_flg_2, rad_flg_3;
  wire [2:0]     strt_wrd_2;
  wire [3:0]     strt_byt_2;
  wire [2:0]     strt_bit_2;
  wire [2:0]     strt_wrd_3;
  wire [3:0]     strt_byt_3;
  wire [2:0]     strt_bit_3;
  wire [2:0]     strt_wrd_4;
  wire [3:0]     strt_byt_4;
  wire [2:0]     strt_bit_4;
  wire [6:0]     lft_enc_2;
  wire [6:0]     rht_enc_2;
  wire [11:0]    clp_min_2;     // left clipping pointer
  wire [11:0]    clp_max_2;     // right clipping pointer
  wire [3:0]     cmin_enc_2;
  wire [3:0]     cmax_enc_2;
  wire [6:0]     lft_enc_4;
  wire [6:0]     rht_enc_4;
  wire [11:0]    clp_min_4;     // left clipping pointer
  wire [11:0]    clp_max_4;     // right clipping pointer
  wire [3:0]     cmin_enc_4;
  wire [3:0]     cmax_enc_4;
  wire           y_clip_4;
  wire           sol_4;
  wire [13:0]    x_bus_4;
  wire           mc_read_3;
  wire           rst_wad_flg_2, rst_wad_flg_3;
  wire [2:0]     frst8_4;
  wire           mc_acken;
  
  assign         stpl_pk_4 = stpl_4[1];
  assign         pc_mc_rdy = ~pc_busy;
  
  /****************************************************************/
  /*            DATAPATH CACHE CONTROLLER                       */
  /****************************************************************/
  ded_cactrl
    #(.BYTES              (BYTES)) U_CACTRL
    (
     .de_clk              (de_clk),
     .de_rstn             (de_rstn),
     .mc_read_4           (mc_read_3),
     .mc_push             (mc_push),
     .mclock              (mclock),
     //.mc_popen            (mc_popen & blt_actv_4 & ~solid_4),
     .mc_popen            (mc_popen),
     .mc_acken            (mc_acken),
     .irst_wad            (dx_rstn_wad),
     .ld_rad              (dx_ld_rad),
     .ld_rad_e            (dx_ld_rad_e),
     .x_adr               (dx_xalu),
     .srcx                (srcx[8:0]),
     .dsty                (dsty[4:0]),
     .dstx                (dx_dstx[6:0]),
     .lt_actv_4           (line_actv_4),
     .stpl_2              (stpl_2),
     .stpl_4              (stpl_4),
     .apat_2              (dr_apat_2),
     .apat_4              (apat_4),
     .ps8_2               (ps8_2),
     .ps16_2              (ps16_2),
     .ps32_2              (ps32_2),
     .psize_4             (psize_4),
     //.mc_eop              (mc_eop & blt_actv_4 & ~solid_4),
     .mc_eop              (mc_eop),
     .eol_4               (eol_4),
     .ofset               (srcx[2:0]),
     .frst8_4             (frst8_4),
     .sol_3               (sol_3),
     //.mem_req             (dx_mem_req & dx_blt_actv_2),
     .mem_req             (dx_mem_req),
     .mem_rd              (dx_mem_rd),
     .xpat_ofs            (xpat_ofs),
     .ypat_ofs            (ypat_ofs),
     .ca_src_2            (ca_src_2),
     .rad_flg_2           (rad_flg_2),
     .strt_wrd_3          (strt_wrd_3),
     .strt_byt_3          (strt_byt_3),
     .strt_bit_3          (strt_bit_3),
     .strt_wrd_4          (strt_wrd_4),
     .strt_byt_4          (strt_byt_4),
     .strt_bit_4          (strt_bit_4),
     .rst_wad_flg_3       (rst_wad_flg_3),
     
     .rad_flg_3           (rad_flg_3),
     .strt_wrd_2          (strt_wrd_2),
     .strt_byt_2          (strt_byt_2),
     .strt_bit_2          (strt_bit_2),
     .rst_wad_flg_2       (rst_wad_flg_2),
     .ca_rad              (ca_rad),
     .ca_mc_addr          (ca_mc_addr)
     );

  /****************************************************************/
  /*            DATAPATH DATA CACHE                             */
  /****************************************************************/
  ded_ca_top
    #(.BYTES              (BYTES)) U_CA_TOP
    (
     .mclock               (mclock),
     .mc_push              (mc_push),
     .mc_addr              (ca_mc_addr),

     .hclock               (hb_clk),
     .hb_we                (hb_we & ~hb_xyw_csn), // fixme??? is this needed
     .hb_addr              (hb_adr[6:2]),
     .hb_dout_ram          (hb_dout_ram),
     `ifdef BYTE16 .rad    (ca_rad[9:7]),
     `elsif BYTE8  .rad    (ca_rad[9:6]),
     `else         .rad    (ca_rad[9:5]), `endif
     .ca_enable            (ca_enable),
     .hb_dout              (hb_dout),
     .hb_ram_addr          (hb_ram_addr),
     .ca_ram_addr0         (ca_ram_addr0),
     .ca_ram_addr1         (ca_ram_addr1)
     );

  // always @ (posedge hb_clk) xyw_csn_d <= hb_xyw_csn;
  
  /****************************************************************/
  /*            DATAPATH FUNNEL SHIFTER                         */
  /*            DATAPATH COLOR SELECTOR                         */
  /*              (grouped for synthesis)                         */
  /****************************************************************/
  ded_funcol
    #(.BYTES              (BYTES)) U_FUNCOL
    (
     .mclock               (mclock),
     .stpl_4               (stpl_4),
     .apat_4               (apat_4),
     .ps32_4               (ps32_4),
     .ps16_4               (ps16_4),
     .ps8_4                (ps8_4),
     .lt_actv_4            (line_actv_4),
     .fore_4               (fore_4),
     .back_4               (back_4),
     .solid_4              (solid_4),
     .pc_col               (de_pc_data),
     `ifdef BYTE16 .rad    (ca_rad[6:0]),
     `elsif BYTE8  .rad    (ca_rad[5:0]),
     `else         .rad    (ca_rad[4:0]), `endif
     .bsd0                 (ca_dout0),
     .bsd1                 (ca_dout1),

     .col_dat              (mc_fb_out),
     .trns_msk             (trns_msk),
     .cx_sel               (cx_sel)
     );

  /****************************************************************/
  /*            MASK GENERATOR                                  */
  /****************************************************************/
  ded_mskgen
    #(.BYTES              (BYTES)) U_MSKGEN
    (
     .de_clk              (de_clk),
     .de_rstn             (de_rstn),
     .mclock              (mclock),
     .mc_acken            (mc_acken),
     .mc_popen            (mc_popen),
     .ld_msk              (dx_ld_msk),
     .line_actv_4         (line_actv_4),
     .blt_actv_4          (blt_actv_4),
     .clp_4               (clp_4), 
     .mem_req             (dx_mem_req),
     .mem_rd              (dx_mem_rd),
     .pc_msk_in           (de_pc_mask),
     .clpx_bus_2          (dx_clpx_bus_2),
     .x_bus               (dx_dstx),
     .xalu_bus            (dx_xalu[6:0]),
     .trnsp_4             (trnsp_4),
     .trns_msk_in         (trns_msk),
     .ps16_2              (ps16_2),
     .ps32_2              (ps32_2),
     .mc_eop              (mc_eop),
     .mask_4              (mask_4),
     .lft_enc_4           (lft_enc_4),
     .rht_enc_4           (rht_enc_4),
     .clp_min_4           (clp_min_4),
     .clp_max_4           (clp_max_4),
     .cmin_enc_4          (cmin_enc_4),
     .cmax_enc_4          (cmax_enc_4),
     .y_clip_4            (y_clip_4),
     .sol_4               (sol_4),
     .eol_4               (eol_4),
     .x_count_4           (x_bus_4),
     .mc_eop4             (mc_eop4),
     
     .pixel_msk           (mc_pixel_msk),
     .clip_ind            (clip_ind),
     .lft_enc_2           (lft_enc_2),
     .rht_enc_2           (rht_enc_2),
     .clp_min_2           (clp_min_2),
     .clp_max_2           (clp_max_2),
     .cmin_enc_2          (cmin_enc_2),
     .cmax_enc_2          (cmax_enc_2)
    );

  /****************************************************************/
  /*            LINE PIXEL CACHE                                */
  /****************************************************************/
  ded_pix_cache
    #(.BYTES              (BYTES)) U_PIX
    (
     .de_clk              (de_clk), 
     .mc_clk              (mclock), 
     // .de_rstn             (de_rstn), 
     .de_rstn             (hb_rstn), 
     .dorg_2              (dorg_2),
     .sorg_2              (sorg_2),
     .dptch_2             (dptch_2),
     .sptch_2             (sptch_2),
     .ld_wcnt             (ld_wcnt),
     .fx_1                (fx_1),
     .rmw                 (rmw),
     .ps8_2               (ps8_2), 
     .ps16_2              (ps16_2), 
     .ps32_2              (ps32_2), 
     .fore_2              (fore_2),
     .back_2              (back_2),
     .solid_2             (dr_solid_2),
     .dr_trnsp_2          (dr_trnsp_2),
     // 2D Interface.
     .dx_pc_ld            (dx_pc_ld),
     .dx_clip             (clip),
     .dx_real_dstx        (real_dstx),
     .dx_real_dsty        (real_dsty),
     .dx_pc_msk_last      (pc_msk_last),
     .dx_fg_bgn           (dx_fg_bgn),
     .dx_last_pixel       (last_pixel),
     // 3D Interface.
     `ifdef CORE_3D
     .valid_3d            (valid_3d),
     .fg_bgn_3d           (fg_bgn_3d),
     .x_out_3d            (x_out_3d),
     .y_out_3d            (y_out_3d),
     .pc_msk_last_3d      (msk_last_3d),
     .pc_last_3d          (last_3d),
     .pixel_3d            (pixel_3d),
     .z_3d                (z_3d),
     .alpha_3d            (alpha_3d),
     .z_op                (z_ctrl[2:0]),
     .z_en                (z_ctrl[3]),
     .z_ro                (z_ctrl[4]),
     .zorg_2              (z_org),
     .zptch_2             (z_ptch),
     .active_3d_2         (active_3d_2),
     `else
     .valid_3d            (1'b0),
     .fg_bgn_3d           (1'b0),
     .x_out_3d            (16'h0),
     .y_out_3d            (16'h0),
     .pc_msk_last_3d      (1'b0),
     .pc_last_3d          (1'b0),
     .pixel_3d            (32'h0),
     .alpha_3d            (8'h0),
     .z_op                (3'b0),
     .z_en                (1'b0),
     .z_ro                (1'b0),
     .zorg_2              (28'b0),
     .zptch_2             (12'b0),
     .active_3d_2         (1'b0),
     `endif
     // 
     .de_pc_pop           (de_pc_pop),
     .mc_popen            (mc_popen),
     .srcx                (srcx),
     .srcy                (srcy),
     .dstx                (dx_dstx),
     .dsty                (dsty),
     .imem_rd             (dx_mem_rd),
     .dx_mem_req          (dx_mem_req),
     .mask_2              (de_pln_msk_2),
     .stpl_2              (stpl_2),
     .dr_apat_2           (dr_apat_2),
     .dr_clp_2            (dr_clp_2),
     .rad_flg_2           (rad_flg_2),
     .strt_wrd_2          (strt_wrd_2),
     .strt_byt_2          (strt_byt_2),
     .strt_bit_2          (strt_bit_2),
     .ps_2                (ps_2), 
     .bsrcr_2             (bsrcr_2),
     .bdstr_2             (bdstr_2),
     .blend_en_2          (blend_en_2),
     .blend_reg_en_2      (blend_reg_en_2),
     .bsrc_alpha_2        (bsrc_alpha_2),
     .bdst_alpha_2        (bdst_alpha_2),
     .rop_2               (rop_2),
     .kcol_2              (kcol_2),
     .key_ctrl_2          (key_ctrl_2),
     .lft_enc_2           (lft_enc_2),
     .rht_enc_2           (rht_enc_2),
     .clp_min_2           (clp_min_2),
     .clp_max_2           (clp_max_2),
     .cmin_enc_2          (cmin_enc_2),
     .cmax_enc_2          (cmax_enc_2),
     .y_clip_2            (y_clip_2),
     .sol_2               (dx_sol_2),
     .eol_2               (dx_eol_2),
     .rst_wad_flg_2       (rst_wad_flg_2),
     .frst8_2             (frst8_2),
     
     .rad_flg_3           (rad_flg_3),
     .strt_wrd_3          (strt_wrd_3),
     .strt_byt_3          (strt_byt_3),
     .strt_bit_3          (strt_bit_3),
     .strt_wrd_4          (strt_wrd_4),
     .strt_byt_4          (strt_byt_4),
     .strt_bit_4          (strt_bit_4),
     .px_a                (mc_fb_a),
     .px_col              (de_pc_data),
     .px_msk_color        (de_pc_mask),
     .de_mc_address       (de_mc_address),
     .de_mc_read          (de_mc_read),
     .de_mc_rmw           (de_mc_rmw),
     .de_mc_wcnt          (de_mc_wcnt),
     .pc_dirty            (pc_dirty), 
     .de_pc_empty         (de_pc_empty),
     .pc_pending          (pipe_pending), 
     .pc_busy             (pc_busy),
     .pc_busy_3d          (pc_busy_3d),
     .fore_4              (fore_4),
     .back_4              (back_4),
     .blt_actv_4          (blt_actv_4),
     .stpl_4              (stpl_4),
     .ps8_4               (ps8_4),
     .ps16_4              (ps16_4),
     .ps32_4              (ps32_4),
     .trnsp_4             (trnsp_4),
     .solid_4             (solid_4),
     .clp_4               (clp_4),
     .line_actv_4         (line_actv_4),
     .apat_4              (apat_4),
     .mask_4              (mask_4),
     .ps_4                (ps_4),
     .bsrcr_4             (bsrcr_4),
     .bdstr_4             (bdstr_4),
     .blend_en_4          (blend_en_4),
     .blend_reg_en_4      (blend_reg_en_4),
     .bsrc_alpha_4        (bsrc_alpha_4),
     .bdst_alpha_4        (bdst_alpha_4),
     .rop_4               (rop_4),
     .kcol_4              (kcol_4),
     .key_ctrl_4          (key_ctrl_4),
     .lft_enc_4           (lft_enc_4),
     .rht_enc_4           (rht_enc_4),
     .clp_min_4           (clp_min_4),
     .clp_max_4           (clp_max_4),
     .cmin_enc_4          (cmin_enc_4),
     .cmax_enc_4          (cmax_enc_4),
     .y_clip_4            (y_clip_4),
     .sol_4               (sol_4),
     .eol_4               (eol_4),
     .x_bus_4             (x_bus_4),
     .rst_wad_flg_3       (rst_wad_flg_3),
     .mc_read_3           (mc_read_3),
     .sol_3               (sol_3),
     .mc_acken            (mc_acken),
     .frst8_4             (frst8_4),
     .pc_empty            (pc_empty),
     .pc_last             (pc_last),
     .z_en_4              (z_ctrl_4[3]),
     .z_ro_4              (z_ctrl_4[4]),
     .z_op_4              (z_ctrl_4[2:0]),
     .z_address_4         (z_address_4),
     .z_out               (z_out)
     );

  assign         pc_mc_busy = pc_busy;
  assign         psize_4 = {ps32_4,ps16_4,ps8_4}; // Needed for cactrl


endmodule
