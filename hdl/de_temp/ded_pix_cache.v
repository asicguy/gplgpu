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
//  Title       :  Pixel Cache Top Level
//  File        :  ded_pix_cache.v
//  Author      :  Frank Bruno
//  Created     :  08-Jul-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  ded_pix_cache is used to handle all memory requests for the 2D/3D pipeline 
//  Requests from Lines and triangles as well as BLTs all pass through this
//  Block.
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

module ded_pix_cache
  #(parameter BYTES = 4)
  (
   input                  de_clk,    // Drawing engine clock
   input                  mc_clk,    // memory controller clock
   input                  de_rstn,   // reset input bit_t 
   input [27:0]           dorg_2,    // Destination origin.
   input [27:0]           sorg_2,    // Source origin.
   input [27:0]           zorg_2,    // Z origin.
   input [11:0]           dptch_2,   // destination pitch.
   input [11:0]           sptch_2,   // source pitch.
   input [11:0]           zptch_2,   // Z pitch.
   input                  ld_wcnt,
   input [3:0]            fx_1,      // lower nibble of the alu fx 
   input                  rmw,
   
   // Needed by Pixel cache
   input                  ps8_2,      // pixel size equals eight
   input                  ps16_2,     // pixel size equals sixteen
   input                  ps32_2,     // pixel size equals sixteen
   input [31:0]           fore_2,     // Foreground Color
   input [31:0]           back_2,     // Background Color
   input                  solid_2,    // Solid indicator
   input                  dr_trnsp_2, // Transparent indicator

   input                  dx_pc_ld,   // Load a pixel from execution
   input                  dx_clip,       // Line is being clipped
   input [15:0]           dx_real_dstx,  // X destination
   input [15:0]           dx_real_dsty,  // Y destination
   input                  dx_pc_msk_last,// Don;t display last pixel
   input                  dx_fg_bgn,  // Foreground or background color
   input                  dx_last_pixel, // We are receiving the last pix
   // 3D Interface.
   input		  valid_3d,   // Valid pixel from the 3D engine.
   input		  fg_bgn_3d,  // Forground background from 3D engine.
   input [15:0]           x_out_3d,   // X destination
   input [15:0]           y_out_3d,   // Y destination
   input                  pc_msk_last_3d,// Don;t display last pixel
   input		  pc_last_3d, // Last pixel from the 3D engine.
   input [31:0]           pixel_3d,   // 3D Pixel.
   input [31:0]           z_3d,       // 3D Pixel.
   input [7:0]            alpha_3d,   // 3D Alpha.
   input [2:0]            z_op,       // Z operation
   input                  z_en,       // Z enabled
   input                  z_ro,       // Do not update Z
   input                  active_3d_2,// #D is active.
   // Needed by BLT
   input                  de_pc_pop,  // Pop from PC
   input                  mc_popen,   // increment from MC
   input [15:0]           srcx,     // Source X address.
   input [15:0]           srcy,     // Source Y address.
   input [15:0]           dstx,     // Destination X address.
   input [15:0]           dsty,     // Destination Y address.
   input                  imem_rd,    // Internal Memory read.
   input                  dx_mem_req, // Internal Memory request.
   input [3:0]            mask_2,
   input [1:0]            stpl_2,
   input [1:0]            dr_apat_2,
   input [1:0]            dr_clp_2,
   input                  rad_flg_2,
   input [2:0]            strt_wrd_2,
   input [3:0]            strt_byt_2,
   input [2:0]            strt_bit_2,
   input [1:0]            ps_2,
   input [3:0]            bsrcr_2,      // Source blending function.   
   input [2:0]            bdstr_2,      // Destination blending fx     
   input                  blend_en_2,   // Blending enable.       
   input [1:0]            blend_reg_en_2,// Blending register enable.       
   input [7:0]            bsrc_alpha_2, // Source alpha data.          
   input [7:0]            bdst_alpha_2, // Destination alpha data.     
   input [3:0]            rop_2,        // Raster operation.         
   input [31:0]           kcol_2,       // Key Color.                 
   input [2:0]            key_ctrl_2,   // Key control.               
   input [6:0]            lft_enc_2,
   input [6:0]            rht_enc_2,
   input [11:0]           clp_min_2,    // left clipping pointer
   input [11:0]           clp_max_2,    // right clipping pointer
   input [3:0]            cmin_enc_2,
   input [3:0]            cmax_enc_2,
   input                  y_clip_2,
   input                  sol_2,
   input                  eol_2,
   input                  rst_wad_flg_2,
   input [2:0]            frst8_2,
   
   output reg                 mc_acken,
   output reg [(BYTES*8)-1:0] px_col,       // pixel color select
   output reg [BYTES-1:0]     px_msk_color, // pixel mask
   output reg [(BYTES*4)-1:0] px_a,         // alpha out
   output reg [31:0]          de_mc_address,
   output reg                 de_mc_read,
   output reg                 de_mc_rmw,
   output reg [3:0]           de_mc_wcnt,
   
   output reg                 pc_dirty,   // data left in the pixel cache.
   output reg                 pc_pending, // Pixel cache access pending
   output reg                 pc_busy,    // Pixel cache is busy
   output reg                 pc_busy_3d, // Pixel cache is busy
   output                     de_pc_empty,
   
   output reg [31:0]          fore_4,     // foreground register output
   output reg [31:0]          back_4,     // foreground register output.
   output reg                 blt_actv_4,
   output reg                 trnsp_4, solid_4,
   output reg                 ps8_4,
   output reg                 ps16_4,
   output reg                 ps32_4,
   output reg [1:0]           stpl_4,
   output reg [1:0]           clp_4,
   output reg                 line_actv_4,
   
   output reg [1:0]           apat_4,
   output reg [3:0]           mask_4,
   output                     rad_flg_3,
   output [2:0]               strt_wrd_3,
   output [3:0]               strt_byt_3,
   output [2:0]               strt_bit_3,
   output reg [2:0]           strt_wrd_4,
   output reg [3:0]           strt_byt_4,
   output reg [2:0]           strt_bit_4,
   output reg [1:0]           ps_4,
   output reg [3:0]           bsrcr_4,  // Source blending function.       
   output reg [2:0]           bdstr_4,  // Destination blending function.  
   output reg                 blend_en_4,   // Blending enable.           
   output reg [1:0]           blend_reg_en_4,   // Blending enable.           
   output reg [7:0]           bsrc_alpha_4, // Source alpha data.          
   output reg [7:0]           bdst_alpha_4, // Destination alpha data.     
   output reg [3:0]           rop_4,        // Raster operation           
   output reg [31:0]          kcol_4,       // Key Color.                 
   output reg [2:0]           key_ctrl_4,   // Key control.               
   output reg [6:0]           lft_enc_4,
   output reg [6:0]           rht_enc_4,
   output reg [11:0]          clp_min_4,    // left clipping pointer
   output reg [11:0]          clp_max_4,    // right clipping pointer
   output reg [3:0]           cmin_enc_4,
   output reg [3:0]           cmax_enc_4,
   output reg [13:0]          x_bus_4, // bus from execution X dest counter
   output reg                 y_clip_4,
   output                     sol_4,
   output reg                 eol_4,
   output                     rst_wad_flg_3,
   output                     mc_read_3,
   output                     sol_3,
   output reg [2:0]           frst8_4,
   output reg                 pc_empty,
   output reg                 pc_last,
   output reg [2:0]           z_op_4,       // Z operation
   output reg                 z_en_4,       // Z enabled
   output reg                 z_ro_4,       // Do not update Z
   output reg [31:0]          z_address_4,  // Z Address.
   output reg [(BYTES*8)-1:0] z_out         // Z value to framebuffer
   );

  reg         push_last;
  reg [2:0]   sol_4_int;
  reg [31:0]  pix_color;  	// Color into output fifo
  reg [31:0]  pix_z;  		// Color into output fifo
  reg [7:0]   pix_a;  		// Color into output fifo
   
  reg         push;       	// push into output fifo
  reg [15:0]  in_x, in_y; 	// X,Y into the output fifo
  reg [1:0]   depth;      	// encoded depth into fifo
  reg [127:0] int_col;
  reg [15:0]  int_mask;
  reg [3:0]   wcnt;
  reg [15:0]  y_pos;
  reg [13:0]  x_pos;
  reg [27:0]  org_2;
  reg [11:0]  ptch_2;
  reg         same_page; // we are writing to the same mask
  reg         startup;
  reg         push_previous;
  reg         pipe_push_last;
  reg         fifo_rmw;
  reg         fifo_cmd;
  reg [15:0]  fifo_mask;
  reg [127:0] fifo_color;
  reg         dx_delayed;
  reg [31:0]  fifo_kcol;
  reg [1:0]   fifo_ps;
  reg [3:0]   fifo_bsrcr;
  reg [2:0]   fifo_bdstr;
  reg         fifo_blend_en;
  reg [1:0]   fifo_blend_reg_en;
  reg [7:0]   fifo_bsrc_alpha;
  reg [7:0]   fifo_bdst_alpha;
  reg [3:0]   fifo_rop;
  reg [2:0]   fifo_key_ctrl;
  reg [27:0]  fifo_junk;
  reg         data_pending;
  reg [31:0]  p_mult, int_add;
  reg [31:0]  z_mult, int_zadd;
  reg         fifo_push;
  reg [270:0] fifo_data;  // Muxed data into fifo
  reg [128:0] fifo_adata;  // Muxed data into fifo
  reg         push_d;
  reg [1:0]   last_pixel_pipe;
  reg [31:0]  fifo_address;
  reg [31:0]  z_address;
  reg [127:0] z_buffer, int_z;
  reg [63:0]  a_buffer;
  reg [165:0] fifo_z;
  reg 	      hold_push_last;
  reg 	      hold_3d;
  reg         active_3d_del;
  
  wire [6:0]   wrusedw;
  wire         fifo_empty;
  wire [270:0] fifo_dout;  // Muxed data into fifo
  wire [165:0] fifo_zout;  // Muxed data into fifo
  wire         fifo_dout_extra;
  wire [127:0] a_dout;
  
  // Combine 2D and 3D signals (jmacleod).
   wire 	pc_ld      = dx_pc_ld |      valid_3d;    // Valid pixel
   wire 	fg_bgn     = (~valid_3d & dx_fg_bgn) | (valid_3d & fg_bgn_3d);  // Forground background Select.
   wire 	last_pixel = (~valid_3d & dx_last_pixel) | (valid_3d & pc_last_3d); // Last pixel
   wire [15:0] 	real_dstx  = ({16{~valid_3d}} & dx_real_dstx) | ({16{valid_3d}} & x_out_3d);   // X destination
   wire [15:0] 	real_dsty  = ({16{~valid_3d}} & dx_real_dsty) | ({16{valid_3d}} & y_out_3d);   // Y destination
   wire 	pc_msk_last = (~valid_3d & dx_pc_msk_last) | (valid_3d & pc_msk_last_3d); // Last pixel mask.
   wire 	clip       = (~valid_3d) ? dx_clip : 1'b0;

  // create org and pitch multiplexers                         
  always @* begin
    casex({push,imem_rd}) 
      /* synopsys full_case parallel_case */
      2'b1x:begin       // Pixel Cache Color write to memory.
        org_2  = dorg_2;
        ptch_2 = dptch_2;
        if (BYTES == 16)     x_pos  = {{2{in_x[15]}}, in_x[15:4]};
        else if (BYTES == 8) x_pos  = {in_x[15], in_x[15:3]};
        else                 x_pos  = in_x[15:2];
        y_pos  = in_y;
      end
      2'b01:begin       // 2 D read from memory.
        org_2  = sorg_2;
        ptch_2 = sptch_2;
        //if (BYTES == 16)     x_pos  = {{2{srcx[15]}}, srcx[15:6], 2'b0};
        //else if (BYTES == 8) x_pos  = {srcx[15], srcx[15:5], 2'b0};
        //else                 x_pos  = {srcx[15:4], 2'b0};
        if (BYTES == 16)     x_pos  = {{2{srcx[15]}}, srcx[15:4]};
        else if (BYTES == 8) x_pos  = {srcx[15], srcx[15:4], 1'b0};
        else                 x_pos  = {srcx[15:4], 2'b0};
        y_pos  = srcy;
      end
      2'b00:begin       // 2 D write to memory.
        org_2  = dorg_2;
        ptch_2 = dptch_2;
        //if (BYTES == 16)     x_pos  = {{2{dstx[15]}}, dstx[15:6], 2'b0};
        //else if (BYTES == 8) x_pos  = {dstx[15], dstx[15:5], 2'b0};
        //else                 x_pos  = {dstx[15:4], 2'b0};
        if (BYTES == 16)     x_pos  = {{2{dstx[15]}}, dstx[15:4]};
        else if (BYTES == 8) x_pos  = {dstx[15], dstx[15:4], 1'b0};
        else                 x_pos  = {dstx[15:4], 2'b0};
        y_pos  = dsty;
      end
    endcase
  end

  always @*
    if (BYTES == 16)     fifo_address = p_mult + int_add;
    else if (BYTES == 8) fifo_address = {p_mult, 1'b0} + int_add;
    else                 fifo_address = {p_mult, 2'b0} + int_add;
  always @*
    if (BYTES == 16)     z_address = z_mult + int_zadd;
    else if (BYTES == 8) z_address = {z_mult, 1'b0} + int_zadd;
    else                 z_address = {z_mult, 2'b0} + int_zadd;

  always @ (posedge de_clk) begin
    if (push || dx_mem_req) begin
      // Pitch conversion
      p_mult              <= (y_pos * {{4{ptch_2[11]}}, ptch_2});
      z_mult              <= (y_pos * {{4{zptch_2[11]}}, zptch_2});
`ifdef BYTE16 int_add <= (org_2 + {{14{x_pos[13]}}, x_pos}); `endif
`ifdef BYTE8  int_add <= ({org_2, 1'b0} + {{14{x_pos[13]}}, x_pos}); `endif
`ifdef BYTE4  int_add <= ({org_2, 2'b0} + {{14{x_pos[13]}}, x_pos}); `endif
`ifdef BYTE16 int_zadd <= (zorg_2 + {{14{x_pos[13]}}, x_pos}); `endif
`ifdef BYTE8  int_zadd <= ({zorg_2, 1'b0} + {{14{x_pos[13]}}, x_pos}); `endif
`ifdef BYTE4  int_zadd <= ({zorg_2, 2'b0} + {{14{x_pos[13]}}, x_pos}); `endif
      fifo_rmw            <= (rmw | blend_en_2);
      fifo_kcol           <= kcol_2;
      fifo_ps             <= ps_2;
      fifo_bsrcr          <= bsrcr_2;
      fifo_bdstr          <= bdstr_2;
      fifo_blend_en       <= blend_en_2;
      fifo_blend_reg_en   <= blend_reg_en_2;
      fifo_bsrc_alpha     <= bsrc_alpha_2;
      fifo_bdst_alpha     <= bdst_alpha_2;
      fifo_rop            <= rop_2;
      fifo_key_ctrl       <= key_ctrl_2;
      fifo_junk[6:0]      <= lft_enc_2;
      fifo_junk[13:7]     <= rht_enc_2;
      fifo_junk[25:14]    <= dstx[15:4];
      fifo_junk[26]       <= rst_wad_flg_2;
    end
    if (push) begin
      fifo_color[7:0]     <= ~int_mask[0]  ? int_col[7:0] : fifo_color[7:0];
      fifo_color[15:8]    <= ~int_mask[1]  ? int_col[15:8] : fifo_color[15:8];
      fifo_color[23:16]   <= ~int_mask[2]  ? int_col[23:16] : fifo_color[23:16];
      fifo_color[31:24]   <= ~int_mask[3]  ? int_col[31:24] : fifo_color[31:24];
      fifo_color[39:32]   <= ~int_mask[4]  ? int_col[39:32] : fifo_color[39:32];
      fifo_color[47:40]   <= ~int_mask[5]  ? int_col[47:40] : fifo_color[47:40];
      fifo_color[55:48]   <= ~int_mask[6]  ? int_col[55:48] : fifo_color[55:48];
      fifo_color[63:56]   <= ~int_mask[7]  ? int_col[63:56] : fifo_color[63:56];
      fifo_color[71:64]   <= ~int_mask[8]  ? int_col[71:64] : fifo_color[71:64];
      fifo_color[79:72]   <= ~int_mask[9]  ? int_col[79:72] : fifo_color[79:72];
      fifo_color[87:80]   <= ~int_mask[10] ? int_col[87:80] : fifo_color[87:80];
      fifo_color[95:88]   <= ~int_mask[11] ? int_col[95:88] : fifo_color[95:88];
      fifo_color[103:96]  <= ~int_mask[12] ? int_col[103:96] : fifo_color[103:96];
      fifo_color[111:104] <= ~int_mask[13] ? int_col[111:104] : fifo_color[111:104];
      fifo_color[119:112] <= ~int_mask[14] ? int_col[119:112] : fifo_color[119:112];
      fifo_color[127:120] <= ~int_mask[15] ? int_col[127:120] : fifo_color[127:120];
      z_buffer[7:0]     <= ~int_mask[0]  ? int_z[7:0]     : z_buffer[7:0];
      z_buffer[15:8]    <= ~int_mask[1]  ? int_z[15:8]    : z_buffer[15:8];
      z_buffer[23:16]   <= ~int_mask[2]  ? int_z[23:16]   : z_buffer[23:16];
      z_buffer[31:24]   <= ~int_mask[3]  ? int_z[31:24]   : z_buffer[31:24];
      z_buffer[39:32]   <= ~int_mask[4]  ? int_z[39:32]   : z_buffer[39:32];
      z_buffer[47:40]   <= ~int_mask[5]  ? int_z[47:40]   : z_buffer[47:40];
      z_buffer[55:48]   <= ~int_mask[6]  ? int_z[55:48]   : z_buffer[55:48];
      z_buffer[63:56]   <= ~int_mask[7]  ? int_z[63:56]   : z_buffer[63:56];
      z_buffer[71:64]   <= ~int_mask[8]  ? int_z[71:64]   : z_buffer[71:64];
      z_buffer[79:72]   <= ~int_mask[9]  ? int_z[79:72]   : z_buffer[79:72];
      z_buffer[87:80]   <= ~int_mask[10] ? int_z[87:80]   : z_buffer[87:80];
      z_buffer[95:88]   <= ~int_mask[11] ? int_z[95:88]   : z_buffer[95:88];
      z_buffer[103:96]  <= ~int_mask[12] ? int_z[103:96]  : z_buffer[103:96];
      z_buffer[111:104] <= ~int_mask[13] ? int_z[111:104] : z_buffer[111:104];
      z_buffer[119:112] <= ~int_mask[14] ? int_z[119:112] : z_buffer[119:112];
      z_buffer[127:120] <= ~int_mask[15] ? int_z[127:120] : z_buffer[127:120];
      a_buffer[7:0]     <= ~int_mask[0]  ? pix_a          : a_buffer[7:0];
      a_buffer[15:8]    <= ~int_mask[2]  ? pix_a          : a_buffer[15:8];
      a_buffer[23:16]   <= ~int_mask[4]  ? pix_a          : a_buffer[23:16];
      a_buffer[31:24]   <= ~int_mask[6]  ? pix_a          : a_buffer[31:24];
      a_buffer[39:32]   <= ~int_mask[8]  ? pix_a          : a_buffer[39:32];
      a_buffer[47:40]   <= ~int_mask[10] ? pix_a          : a_buffer[47:40];
      a_buffer[55:48]   <= ~int_mask[12] ? pix_a          : a_buffer[55:48];
      a_buffer[63:56]   <= ~int_mask[14] ? pix_a          : a_buffer[63:56];
      fifo_mask  <= ~same_page ? int_mask : int_mask & fifo_mask;
      fifo_cmd   <= 1'b0; // Line/ Triangle write
      fifo_junk[27]       <= sol_2;
    end else if (dx_mem_req) begin
      fifo_junk[27]       <= ~imem_rd ? sol_2 : fifo_junk[27];
      fifo_color[31:0]    <= fore_2;
      fifo_color[63:32]   <= back_2;
      fifo_color[67:64]   <= mask_2;
      fifo_color[68]      <= ps8_2;
      fifo_color[69]      <= ps16_2;
      fifo_color[70]      <= ps32_2;
      fifo_color[72:71]   <= stpl_2;
      fifo_color[73]      <= dr_trnsp_2;
      fifo_color[75:74]   <= dr_clp_2;
      fifo_color[77:76]   <= dr_apat_2;
      fifo_color[78]      <= solid_2;
      fifo_color[79]      <= imem_rd;
      fifo_color[80]      <= rad_flg_2;
      fifo_color[83:81]   <= strt_wrd_2;
      fifo_color[87:84]   <= strt_byt_2;
      fifo_color[90:88]   <= strt_bit_2;
      fifo_color[93:91]   <= frst8_2;
      fifo_color[105:94]  <= clp_min_2;
      fifo_color[117:106] <= clp_max_2;
      fifo_color[121:118] <= cmin_enc_2;
      fifo_color[125:122] <= cmax_enc_2;
      fifo_color[126]     <= y_clip_2;
      fifo_color[127]     <= eol_2;
      
      fifo_mask           <= {12'b0, wcnt};
      fifo_cmd            <= 1'b1; // BLT operation
    end
  end

  always @(posedge de_clk or negedge de_rstn)
    if (!de_rstn) begin
      pix_color      <= 32'b0;
      pix_z          <= 32'b0;
      pix_a          <= 8'b0;
      push           <= 1'b0;
      pc_dirty       <= 1'b0;
      pc_pending     <= 1'b0;
      in_x           <= 16'h0;
      in_y           <= 16'h0;
      depth          <= 2'b0;
      pc_busy        <= 1'b0;
      pc_busy_3d     <= 1'b0;
      wcnt           <= 4'b0;
      startup        <= 1'b1;
      same_page      <= 1'b0;
      push_previous  <= 1'b0;
      push_last      <= 1'b0;
      pipe_push_last <= 1'b0;
      dx_delayed     <= 1'b0;
      data_pending   <= 1'b0;
      fifo_data      <= 271'b0;
      fifo_adata     <= 128'b0;
      fifo_z         <= 166'h0;
      fifo_push      <= 1'b0;
      push_d         <= 1'b0;
      last_pixel_pipe<= 2'b0;
      pc_empty       <= 1'b0;
      hold_push_last <= 1'b0;
      hold_3d        <= 1'b0;
      active_3d_del  <= 1'b0;
    end else begin

      active_3d_del <= active_3d_2;
      pc_empty <= fifo_empty;
      
      push_d <= push;
      last_pixel_pipe <= {last_pixel_pipe[0], last_pixel};
      
      fifo_push <= dx_delayed | push_previous | pipe_push_last;

      fifo_adata <= {fifo_blend_reg_en, a_buffer};
      
      fifo_data <= {
	      	   fifo_junk, 		// [270:243]
		   fifo_ps, 		// [242:241]
		   fifo_key_ctrl,	// [240:238]
                   fifo_blend_en, 	// [237]
		   fifo_bsrcr, 		// [236:233]
		   fifo_bdstr, 		// [232:230]
		   fifo_rop, 		// [229:226]
                   fifo_bsrc_alpha, 	// [225:218]
		   fifo_bdst_alpha,	// [217:210]
                   fifo_kcol, 		// [209:178]
		   fifo_rmw, 		// [177]
		   fifo_cmd, 		// [176]
		   fifo_address, 	// [175:144]
                   fifo_mask,		// [143:128] 
		   fifo_color		// [127:0]
		   };
      fifo_z    <= {
		    active_3d_del | hold_3d,        // [165]
		    z_en,               // [164]
		    z_ro,               // [163]
		    z_op,               // [162:160]
		    z_address,          // [159:128]
		    z_buffer            // [127:0]
		    };
      
      if (push_d && ~push_previous)     data_pending <= 1'b1;
      else if (push_d && push_previous || push_last) data_pending <= 1'b0;
      
      push_previous  <= 1'b0;
      push_last      <= 1'b0;
      pipe_push_last <= push_last;
      
      dx_delayed   <= dx_mem_req;

      if (ld_wcnt) wcnt <= fx_1[3:0] - 1'b1;
      
      // pc_busy_3d <= (wrusedw > 64);
      pc_busy_3d <= (wrusedw > 96);
      pc_busy <= (wrusedw > 120);
      // pc_busy <= ~fifo_empty;
  
      push <= 1'b0;
      
      // create the dirty flag
      if (pc_ld && ~clip && ~pc_busy) pc_dirty <= 1'b1;
      else if (fifo_empty)            pc_dirty <= 1'b0;

      // Ceate the busy flag
      if (last_pixel)             pc_pending <= 1'b0;
      else if (pc_ld && ~pc_busy) pc_pending <= 1'b1;

      //push_last <= (data_pending & last_pixel_pipe[1] & ~pc_busy) |
      push_last <= ~hold_push_last & (data_pending & last_pixel_pipe[1] & ~last_pixel_pipe[0]) |
                    pc_ld & ~pc_busy & last_pixel & ~pc_msk_last & ~(dr_trnsp_2 & ~fg_bgn);

      // pc_last   <= ~hold_push_last & (data_pending & last_pixel_pipe[1] & ~last_pixel_pipe[0]) |
      //              pc_ld & ~pc_busy & last_pixel;
      pc_last   <= (last_pixel_pipe[1] & ~last_pixel_pipe[0]);

      if (pc_ld && ~last_pixel) hold_push_last <= 1'b0;
      else if (push_last)       hold_push_last <= 1'b1;

      if (pc_ld && ~last_pixel) hold_3d <= active_3d_2;
      
      if (pc_ld && ~clip && ~pc_busy) begin
        //startup <= last_pixel; // each new line
        if (last_pixel) startup <= 1'b1;
        else if ((~dr_trnsp_2 | dr_trnsp_2 & fg_bgn | solid_2) &
                 ~(last_pixel & pc_msk_last)) startup <= 1'b0;

        if (last_pixel) startup <= 1'b1; // each new line

	// Added 3D data input (Jim MacLeod)
        pix_color <= (solid_2) ? fore_2 : 
		     (valid_3d & fg_bgn_3d) ? pixel_3d : 
		     (fg_bgn) ? fore_2 : back_2;
	pix_z <= z_3d;
	pix_a <= alpha_3d;
	
        // push if solid, not transparent or transparent + foreground
        if ((~dr_trnsp_2 | dr_trnsp_2 & fg_bgn | solid_2) &
            ~(last_pixel & pc_msk_last)) begin
          push <= 1'b1;
          // X miss
          if (BYTES == 16) begin
            push_previous <= ~startup & ((in_x[15:4] != real_dstx[15:4]) |
                                         (in_y != real_dsty));
            // make sure to push if really last
            same_page <= ~(startup | in_x[15:4] != real_dstx[15:4] | 
                           in_y != real_dsty);
          end else if (BYTES == 8) begin
            push_previous <= ~startup & ((in_x[15:3] != real_dstx[15:3]) |
                                         (in_y != real_dsty));
            // make sure to push if really last
            same_page <= ~(startup | in_x[15:3] != real_dstx[15:3] | 
                           in_y != real_dsty);
          end else begin
            push_previous <= ~startup & ((in_x[15:2] != real_dstx[15:2]) |
                                         (in_y != real_dsty));
            // make sure to push if really last
            same_page <= ~(startup | in_x[15:2] != real_dstx[15:2] | 
                           in_y != real_dsty);
          end
          
        end

        // don't push if masking last pix. 
        in_x <= real_dstx;
        in_y <= real_dsty;
        depth <= {ps32_2, ps16_2};
      end
    end

  always @*
    case (depth)
      2'b00:   int_col = {16{pix_color[7:0]}};
      2'b01:   int_col = {8{pix_color[15:0]}};
      default: int_col = {4{pix_color}};
    endcase // casex({solid_2, fg_bgn_2, ps32_2, ps16_2})

  always @*
    case (depth)
      2'b00:   int_z = {16{pix_z[7:0]}};
      2'b01:   int_z = {8{pix_z[15:0]}};
      default: int_z = {4{pix_z}};
    endcase // casex({solid_2, fg_bgn_2, ps32_2, ps16_2})

  always @*
    if (BYTES == 16)
      casex ({depth, in_x[3:0]}) 
        // synopsys parallel_case
        6'b00_0000: int_mask = 16'hFFFE;
        6'b00_0001: int_mask = 16'hFFFD;
        6'b00_0010: int_mask = 16'hFFFB;
        6'b00_0011: int_mask = 16'hFFF7;
        6'b00_0100: int_mask = 16'hFFEF;
        6'b00_0101: int_mask = 16'hFFDF;
        6'b00_0110: int_mask = 16'hFFBF;
        6'b00_0111: int_mask = 16'hFF7F;
        6'b00_1000: int_mask = 16'hFEFF;
        6'b00_1001: int_mask = 16'hFDFF;
        6'b00_1010: int_mask = 16'hFBFF;
        6'b00_1011: int_mask = 16'hF7FF;
        6'b00_1100: int_mask = 16'hEFFF;
        6'b00_1101: int_mask = 16'hDFFF;
        6'b00_1110: int_mask = 16'hBFFF;
        6'b00_1111: int_mask = 16'h7FFF;
        6'b01_000x: int_mask = 16'hFFFC;
        6'b01_001x: int_mask = 16'hFFF3;
        6'b01_010x: int_mask = 16'hFFCF;
        6'b01_011x: int_mask = 16'hFF3F;
        6'b01_100x: int_mask = 16'hFCFF;
        6'b01_101x: int_mask = 16'hF3FF;
        6'b01_110x: int_mask = 16'hCFFF;
        6'b01_111x: int_mask = 16'h3FFF;
        6'b10_00xx: int_mask = 16'hFFF0;
        6'b10_01xx: int_mask = 16'hFF0F;
        6'b10_10xx: int_mask = 16'hF0FF;
        default:    int_mask = 16'h0FFF;
      endcase // casex({depth, in_x[3:0]})
    else if (BYTES == 8)
      casex ({depth, in_x[3:0]}) 
        // synopsys parallel_case
        6'b00_x000: int_mask = 16'hFFFE;
        6'b00_x001: int_mask = 16'hFFFD;
        6'b00_x010: int_mask = 16'hFFFB;
        6'b00_x011: int_mask = 16'hFFF7;
        6'b00_x100: int_mask = 16'hFFEF;
        6'b00_x101: int_mask = 16'hFFDF;
        6'b00_x110: int_mask = 16'hFFBF;
        6'b00_x111: int_mask = 16'hFF7F;
        6'b01_x00x: int_mask = 16'hFFFC;
        6'b01_x01x: int_mask = 16'hFFF3;
        6'b01_x10x: int_mask = 16'hFFCF;
        6'b01_x11x: int_mask = 16'hFF3F;
        6'b10_x0xx: int_mask = 16'hFFF0;
        default:    int_mask = 16'hFF0F;
      endcase // casex({depth, in_x[3:0]})
    else
      casex ({depth, in_x[3:0]}) 
        // synopsys parallel_case
        6'b00_xx00: int_mask = 16'hFFFE;
        6'b00_xx01: int_mask = 16'hFFFD;
        6'b00_xx10: int_mask = 16'hFFFB;
        6'b00_xx11: int_mask = 16'hFFF7;
        6'b01_xx0x: int_mask = 16'hFFFC;
        6'b01_xx1x: int_mask = 16'hFFF3;
        default:    int_mask = 16'hFFF0;
      endcase // casex({depth, in_x[3:0]})

`ifdef RAM_FIFO_271x128
  async_fifo
    #
    (
     .WIDTH         (271),
     .DEPTH         (128),
     .DLOG2         (7)
     ) u_fifo_271x128a
  (
   .aclr            (de_rstn),
   .wrclk           (de_clk),
   .wrreq           (fifo_push),
   .data            (fifo_data),
   .wr_empty        (fifo_empty),
   .wrusedw         (wrusedw),
   
   .rdclk           (mc_clk),
   .rdreq           (de_pc_pop),
   .q               (fifo_dout),
   .rd_empty        (de_pc_empty)
   );

  async_fifo
    #
    (
     .WIDTH         (166),
     .DEPTH         (128),
     .DLOG2         (7)
     ) u_fifo_181x128a
    (
     .aclr	    (de_rstn),
     .wrclk         (de_clk),
     .wrreq         (fifo_push),
     .data          (fifo_z),
     .wr_empty      (),
     .wrusedw       (),

     .rdclk         (mc_clk),
     .rdreq         (de_pc_pop),
     .q             (fifo_zout),
     .rd_empty	    ()
     );

`else

  fifo_128x128a u0_fifo
    (
     .aclr	    (~de_rstn),
     .data          (fifo_data[127:0]),
     .rdclk         (mc_clk),
     .rdreq         (mc_acken), // de_pc_pop),
     .wrclk         (de_clk),
     .wrreq         (fifo_push),

     .q             (fifo_dout[127:0]),
     .rdempty       (de_pc_empty),
     .wrempty       (fifo_empty),
     .wrusedw       (wrusedw)
     );

  fifo_144x128a u1_fifo
    (
     .aclr	    (~de_rstn),
     .data          ({1'b0, fifo_data[270:128]}),
     .rdclk         (mc_clk),
     .rdreq         (mc_acken), // de_pc_pop),
     .wrclk         (de_clk),
     .wrreq         (fifo_push),

     .q             ({fifo_dout_extra, fifo_dout[270:128]})
     );

  fifo_181x128a u2_fifo
    (
     .aclr	    (~de_rstn),
     .data          (fifo_z),
     .rdclk         (mc_clk),
     .rdreq         (mc_acken), // de_pc_pop),
     .wrclk         (de_clk),
     .wrreq         (fifo_push),

     .q             (fifo_zout)
     );

  fifo_128x128a u3_fifo
    (
     .aclr	    (~de_rstn),
     .data          (fifo_adata),
     .rdclk         (mc_clk),
     .rdreq         (mc_acken), // de_pc_pop),
     .wrclk         (de_clk),
     .wrreq         (fifo_push),

     .q             (a_dout[127:0])
     );

`endif // !`ifdef RAM_FIFO_267x128
  
  always @(posedge mc_clk or negedge de_rstn)
    if (!de_rstn) mc_acken <= 1'b0;
    else          mc_acken <= de_pc_pop;
  
  always @(posedge mc_clk or negedge de_rstn)
    if (!de_rstn) begin
      px_col       <= 128'b0;
      px_a         <= 64'b0;
      px_msk_color <= 16'b0;
      de_mc_address<= 32'b0;
      de_mc_rmw    <= 1'b0;
      de_mc_read   <= 1'b0;
      de_mc_wcnt   <= 4'b0;
      blt_actv_4   <= 1'b0;
      line_actv_4  <= 1'b0;
      kcol_4       <= 32'b0;
      bdst_alpha_4 <= 8'b0;
      bsrc_alpha_4 <= 8'b0;
      rop_4        <= 4'b0;
      bdstr_4      <= 3'b0;
      bsrcr_4      <= 4'b0;
      blend_en_4   <= 1'b0;
      key_ctrl_4   <= 3'b0;
      ps_4         <= 2'b0;
      lft_enc_4    <= 7'b0;
      rht_enc_4    <= 7'b0;
      clp_min_4    <= 12'b0;
      clp_max_4    <= 12'b0;
      cmin_enc_4   <= 4'b0;
      cmax_enc_4   <= 4'b0;
      y_clip_4     <= 1'b0;
      eol_4        <= 1'b0;
      fore_4       <= 32'b0;
      back_4       <= 32'b0;
      mask_4       <= 4'b0;
      ps8_4        <= 1'b0;
      ps16_4       <= 1'b0;
      ps32_4       <= 1'b0;
      stpl_4       <= 2'b0;
      trnsp_4      <= 1'b0;
      clp_4        <= 2'b0;
      apat_4       <= 2'b0;
      solid_4      <= 1'b0;
      strt_wrd_4   <= 3'b0;
      strt_byt_4   <= 4'b0;
      strt_bit_4   <= 3'b0;
      frst8_4      <= 3'b0;
      z_en_4       <= 1'b0;
      z_ro_4       <= 1'b0;
      z_op_4       <= 3'b0;
      z_address_4  <= 32'b0;
      z_out        <= 128'b0;
    end else begin
      if (mc_acken) begin
	// Z stuff
	z_en_4       <= (&fifo_zout[165:164]);
	z_ro_4       <= fifo_zout[163];
	z_op_4       <= fifo_zout[162:160];
	z_address_4  <= fifo_zout[159:128];
	z_out        <= fifo_zout[127:0];
	// Color stuff
	px_a         <= a_dout[63:0];
        blend_reg_en_4<= a_dout[65:64];
        px_col       <= fifo_dout[127:0];
        px_msk_color <= fifo_dout[143:128];
        de_mc_address<= fifo_dout[175:144];
        de_mc_rmw    <= fifo_dout[177];
        de_mc_read   <= fifo_dout[176] & fifo_dout[79];
        de_mc_wcnt   <= ~fifo_dout[176] ? 4'b0 : fifo_dout[131:128];
        blt_actv_4   <= fifo_dout[176];
        line_actv_4  <= ~fifo_dout[176];
        kcol_4       <= fifo_dout[209:178];
        bdst_alpha_4 <= fifo_dout[217:210];
        bsrc_alpha_4 <= fifo_dout[225:218];
        rop_4        <= fifo_dout[229:226];
        bdstr_4      <= fifo_dout[232:230];
        bsrcr_4      <= fifo_dout[236:233];
        blend_en_4   <= fifo_dout[237];
        key_ctrl_4   <= fifo_dout[240:238];
        ps_4         <= fifo_dout[242:241];
        lft_enc_4    <= fifo_dout[249:243];
        rht_enc_4    <= fifo_dout[256:250];
        
        clp_min_4    <= fifo_dout[105:94];
        clp_max_4    <= fifo_dout[117:106];
        cmin_enc_4   <= fifo_dout[121:118];
        cmax_enc_4   <= fifo_dout[125:122];
        y_clip_4     <= fifo_dout[126];
        eol_4        <= fifo_dout[127];
        
        // BLT only flags
        if (fifo_dout[176]) begin
          fore_4       <= fifo_dout[31:0];
          back_4       <= fifo_dout[63:32];
          mask_4       <= fifo_dout[67:64];
          ps8_4        <= fifo_dout[68];
          ps16_4       <= fifo_dout[69];
          ps32_4       <= fifo_dout[70];
          stpl_4       <= fifo_dout[72:71];
          trnsp_4      <= fifo_dout[73];
          clp_4        <= fifo_dout[75:74];
          apat_4       <= fifo_dout[77:76];
          solid_4      <= fifo_dout[78];
          if (fifo_dout[80]) begin
            strt_wrd_4 <= fifo_dout[83:81];
            strt_byt_4 <= fifo_dout[87:84];
            strt_bit_4 <= fifo_dout[90:88];
          end
          frst8_4      <= fifo_dout[93:91];
          
        end else begin // if (fifo_dout[172])
          mask_4       <= 4'hF; // set mask to 1111 for line
        end
      end
    end // else: !if(!de_rstn)
  
  // page coordinate counter, used to track X during page cycles and produce 
  // the correct clipping mask
  always @(posedge mc_clk)
         if (mc_acken && (BYTES == 16)) x_bus_4 <= {2'b00, fifo_dout[268:257]};
    else if (mc_acken && (BYTES == 8))  x_bus_4 <= {1'b0,  fifo_dout[268:257], 1'b0};
    else if (mc_acken)                  x_bus_4 <= {fifo_dout[268:257], 2'b00};
    else if (mc_popen) 			x_bus_4 <= x_bus_4 + 14'h1;

  `ifdef BYTE16
  always @(posedge mc_clk)
    if (mc_acken)      sol_4_int <= fifo_dout[270];
    else if (mc_popen) sol_4_int <= 1'b0;
  assign sol_4 = sol_4_int[0];
  `elsif BYTE8
  always @(posedge mc_clk)
    if (mc_acken)      sol_4_int <= {1'b0, fifo_dout[270], 1'b0};
    else if (mc_popen) sol_4_int <= sol_4_int - |sol_4_int;
  assign sol_4 = |sol_4_int;
  `else
  always @(posedge mc_clk)
    if (mc_acken)      sol_4_int <= {fifo_dout[270], 2'b0};
    else if (mc_popen) sol_4_int <= sol_4_int - |sol_4_int;
  assign sol_4 = |sol_4_int;
  `endif
  
  assign rst_wad_flg_3 = fifo_dout[269];
  assign rad_flg_3     = fifo_dout[80];
  assign sol_3         = fifo_dout[270];
  assign mc_read_3     = fifo_dout[172] & fifo_dout[79];
  assign strt_wrd_3    = fifo_dout[80] ? fifo_dout[83:81] : strt_wrd_4;
  assign strt_byt_3    = fifo_dout[80] ? fifo_dout[87:84] : strt_byt_4;
  assign strt_bit_3    = fifo_dout[80] ? fifo_dout[90:88] : strt_bit_4;

endmodule



