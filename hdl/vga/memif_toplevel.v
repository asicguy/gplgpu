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
//  Title       :  Memory Interface Top Level
//  File        :  memif_toplevel.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module is the integration of all the memory
//   interface modules described below.
// 
//   The signal which have the suffic as c_ indicates that
//   this are generated from crt module, if g_ indicate
//   that this are generated from graph module, if h_ indicates
//   its generated from host module, if a_ indicates that 
//   this are generated from attribute module and if m_ then
//   signals are generated from memory module.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//   cpu_rd.v
//   cpu_wr.v (sm_cpuwr.v)
//   sm_txt_crt.v
//   sm_graphic_crt.v
//   sm_data_comp.v
//   sm_crt_ffwr_rd.v
//   crt_fifo_logic.v
//   crt_addr_gen.v
//   att_text_blk.v
//   sm_arb.v
//   sm_ref.v 
//   memif_reg_dec.v
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

`timescale 1 ns / 10 ps

module memif_toplevel
  (
   input         t_data_ready_n,
   input         t_mem_clk,
   input         t_crt_clk,
   input         svga_ack,
   input         c_misc_b1,
   input         c_split_screen_pulse,
   input         c_vde,
   input         c_pre_vde,
   input         c_row_end,
   input         c_cr17_b0,
   input         c_cr17_b1,
   input         c_cr17_b5,
   input         c_cr17_b6,
   input         c_cr14_b6,
   input [4:0]   c_slc_op,
   input         c_crt_line_end,
   input         c_dclk_en,
   input         c_vdisp_end,
   input         c_crt_ff_read,
   input         c_vert_blank,
   input         c_cursory,
   input         c_uln_on,
   input         c_cr0c_f13_22_hit,
   
   input         g_memrd,
   input         h_reset_n,
   input         h_iord,
   input         h_iowr,
   input         h_io_16,
   input [15:0]  h_io_addr,
   input         h_svga_sel,
   input [19:0]  val_mrdwr_addr,
   input [7:0]   fin_plane_sel,
  
   input [3:0]  g_plane_sel,
   input        g_memwr,
   input        g_gr06_b0,
   input        g_gr05_b4,
   input        g_cpu_cycle_done,
   input        g_cpu_data_done,
   input [31:0] m_t_mem_data_in,
   
   input [31:0] g_graph_data_out,   
   input [15:0] h_io_dbus,
   input        color_mode,
   input [5:0]  c_crtc_index,
   input [7:0]  c_ext_index,
   input [7:0]  c_hde,                // Numebr of characters on scan line
   input        color_256_mode,       // We are in mode 13
   input        vga_en,
   input        mem_ready,            // Ready signal from MC
   
   // was h_io_dbus
   output [7:0] memif_index_qout,
   output [7:0] reg_sr0_qout,
   output [7:0] reg_sr1_qout,
   output [7:0] reg_sr2_qout,
   output [7:0] reg_sr3_qout,
   output [7:0] reg_sr4_qout,
   output [7:0] reg_cr0c_qout,
   output [7:0] reg_cr0d_qout,
   output [7:0] reg_cr0e_qout,
   output [7:0] reg_cr0f_qout,
   output [7:0] reg_cr13_qout,
   
   output [31:0] g_graph_data_in,
   output [31:0] m_t_mem_data_out,
   output reg [20:3] m_t_mem_addr,
   output [7:0]  m_t_mwe_n,
   output        m_t_svga_req,
   output        m_ready_n,
   output [36:0] m_att_data,
   output        m_cpu_ff_full,
   output        m_sr00_b0,
   output        m_sr01_b1,
   output [3:0]  m_sr02_b,
   output        m_sr04_b3,
   output        m_sr01_b4,
   output        m_sr01_b3,
   output        m_sr01_b2,
   output        m_sr01_b0,
   output        m_sr01_b5,
   output        m_chain4,
   output        m_extend_mem,
   output        m_odd_even,
   output        m_planar,
   output        m_dec_sr00_sr06,
   output        m_dec_sr07,
   output        m_memrd_ready_n,
   output        m_cpurd_state1,
   output        m_mrd_mwr_n,
   output        m_soft_rst_n,
   output        m_cpurd_s0,
   output        cpu_rd_gnt,
   output        mem_mod_rd_en_hb,
   output        mem_mod_rd_en_lb
   );

  wire          cpu_rd_req;
  wire          cpu_rd_svga_req;
  wire          cpu_wr_gnt;
  wire          crt_req;
  wire          cpu_wr_req;
  wire          cpu_wr_svga_req;
  wire          ff_writeable_crt;
  wire          crt_gnt;
  wire          text_mode;
  wire          dum_ff_rd_cnt0;
  wire          txt_crt_svga_req;
  wire          dum_ff_read;
  wire          enrd_tx_addr;
  wire          enrd_font_addr;
  wire [2:0]    tx_cnt_qout;
  wire          graphic_mode;
  wire          gra_crt_svga_req;
  wire          enrd_gra_addr;
  wire          cursor_addr_ok;
  wire          cursor_addr_ok1;
  wire          data_complete;
  wire          crt_ff_write;
  wire          cursorx;
  
  wire          crt_fwr0;
  wire          crt_fwr15;
  wire          crt_fwr16;
  wire          crt_fwr31;
  wire          crt_fwr0_low;
  wire          crt_fwr15_low;
  wire          crt_fwr16_low;
  wire          crt_fwr15_high;
  wire          crt_fwr31_low;
  wire          crt_fwr31_high;
  wire          crt_frd0;
  wire          crt_frd16;
  wire          crt_frd15;
  wire          crt_frd31;
  wire          crt_ff_rda;
  wire          crt_ff_rdb;
  wire          tx_ff_wra_low;
  wire          tx_ff_wra_high;
  wire          tx_ff_wrb_low;
  wire          tx_ff_wrb_high;
  wire          gr_ff_wra;
  wire          gr_ff_wrb;
  wire [4:0]    att_text_out;
  wire          sync_crt_line_end;
  wire          a_empty;
  wire          b_empty;
  wire          a_full_done;
  wire          b_full_done;
  wire          tx_cnt_inc;
  wire          gra_cnt_inc;
  wire [8:0]    ff_asic_out;
  wire          crt_fwr7_low;
  wire          crt_fwr7_high;
  wire          crt_fwr23_low;
  wire          crt_fwr23_high;
  wire          m_sr04_b1;
  wire          en_cpurd_addr;
  wire          enwr_cpu_ad_da_pl;   
  wire          crt_frd1;
  wire          crt_frd17;
  wire          cpu_arb_wr;
  wire          start_txt_sm;
  wire [31:0] 	cpuwr_mem_data_out;
  wire [7:0] 	cpuwr_mwe_n;
  wire [19:0] 	fin_crt_addr;
  wire [19:0] 	font_addr;
  wire [19:0] 	cpuwr_mem_addr;
  wire 		sync_c_crt_line_end;
  wire 		cpu_mem_wr;
  wire 		extend_font_addr;
  wire 		sync_pre_vde;
  // From att_text_blk
  wire 		decode_c0todf;
  wire 		int_x5;
  wire 		blank;
  wire 		under_line;
  wire 		reverse;

  assign m_t_mem_data_out = cpuwr_mem_data_out;

  assign m_t_mwe_n = cpuwr_mwe_n;

  always @*
    casex ({en_cpurd_addr, enwr_cpu_ad_da_pl, (enrd_tx_addr | enrd_gra_addr),
	   (enrd_font_addr & vga_en)}) // synopsys full_case parallel_case
      4'b1xxx: m_t_mem_addr = val_mrdwr_addr[17:0];
      4'b01xx: m_t_mem_addr = cpuwr_mem_addr[17:0];
      4'b001x: m_t_mem_addr = fin_crt_addr[17:0];
      4'b0001: m_t_mem_addr = font_addr[17:0];
      // synopsys synthesis off
      // in simulation, these addresses are read back from memory. If the
      // memory has not been loaded, then they will be X and hose the
      // memory. Thus turn this off only for synthesis to get better gates
      // from the tools
      default: m_t_mem_addr = 18'b0;
      // synopsys synthesis on
    endcase // casex({encpurd_addr, enwr_cpu_ad_da_pl, (enrd_tx_addr | enrd_gra_addr),...
  
  cpu_rd CPURD
    (
     .g_memwr               (g_memwr),
     .g_cpu_cycle_done      (g_cpu_cycle_done),
     .g_cpu_data_done       (g_cpu_data_done),
     .c_misc_b1             (c_misc_b1),
     .h_svga_sel            (h_svga_sel),
     .hreset_n              (h_reset_n),
     .g_memrd               (g_memrd),
     .cpu_rd_gnt            (cpu_rd_gnt),
     .svga_ack              (svga_ack),
     .t_data_ready_n        (t_data_ready_n),
     .mem_clk               (t_mem_clk),
     .cpu_rd_req            (cpu_rd_req),
     .cpu_rd_svga_req       (cpu_rd_svga_req),
     .m_t_mem_data_in       (m_t_mem_data_in),
     .g_graph_data_in       (g_graph_data_in),
     .m_memrd_ready_n       (m_memrd_ready_n),
     .m_cpurd_state1        (m_cpurd_state1),
     .m_cpurd_s0            (m_cpurd_s0),
     .en_cpurd_addr         (en_cpurd_addr)
     );
  
  cpu_wr CPUWR
    (
     .cpu_rd_gnt            (cpu_rd_gnt),
     .hreset_n              (h_reset_n),
     .cpu_wr_gnt            (cpu_wr_gnt),
     .crt_req               (crt_req),
     .svga_ack              (svga_ack),
     .mem_clk               (t_mem_clk),
     .cpu_wr_req            (cpu_wr_req),
     .cpu_wr_svga_req       (cpu_wr_svga_req),
     .val_mrdwr_addr        (val_mrdwr_addr),
     .fin_plane_sel         (fin_plane_sel),
     .cpuwr_mwe_n           (cpuwr_mwe_n),
     .cpuwr_mem_addr        (cpuwr_mem_addr),
     .cpuwr_mem_data_out    (cpuwr_mem_data_out),

     .g_memwr               (g_memwr),
     .g_graph_data_out      (g_graph_data_out),
     .m_cpu_ff_full         (m_cpu_ff_full),
     .cpu_mem_wr            (cpu_mem_wr),
     .enwr_cpu_ad_da_pl     (enwr_cpu_ad_da_pl),
     .cpu_arb_wr            (cpu_arb_wr)
     );
  
  sm_txt_crt SMTXT
    (
     .start_txt_sm          (start_txt_sm),
     .sync_c_crt_line_end   (sync_crt_line_end),
     .hreset_n              (h_reset_n),
     .crt_gnt               (crt_gnt),
     .svga_ack              (svga_ack),
     .mem_clk               (t_mem_clk),
     .text_mode             (text_mode),
     .data_complete         (data_complete),
     .c_hde                 (c_hde),
     
     .dum_ff_rd_cnt0        (dum_ff_rd_cnt0),
     .txt_crt_svga_req      (txt_crt_svga_req),
     .dum_ff_read           (dum_ff_read),
     .enrd_tx_addr          (enrd_tx_addr),
     .enrd_font_addr        (enrd_font_addr),
     .extend_font_addr      (extend_font_addr),
     .tx_cnt_inc            (tx_cnt_inc)
     );
  
  sm_graphic_crt SMGRA
    (
     .sync_c_crt_line_end   (sync_crt_line_end),
     .hreset_n              (h_reset_n),
     .ff_writeable_crt      (ff_writeable_crt),
     .crt_gnt               (crt_gnt),
     .svga_ack              (svga_ack),
     .mem_clk               (t_mem_clk),
     .graphic_mode          (graphic_mode),
     .data_complete         (data_complete),
     .c_hde                 (c_hde),
     .color_256_mode        (color_256_mode),
     
     .gra_crt_svga_req      (gra_crt_svga_req),
     .enrd_gra_addr         (enrd_gra_addr),
     .gra_cnt_inc           (gra_cnt_inc)
//     .probe                 (probe_crt[30:0])
     );
  
  sm_data_comp SMDATA
    (
     .sync_c_crt_line_end   (sync_crt_line_end),
     .cpu_arb_wr            (cpu_arb_wr),
     .t_data_ready_n        (t_data_ready_n),
     .h_reset_n             (h_reset_n),
     .t_mem_clk             (t_mem_clk),
     .gra_crt_svga_req      (gra_crt_svga_req),
     .txt_crt_svga_req      (txt_crt_svga_req),
     .cpu_rd_svga_req       (cpu_rd_svga_req),
     .cpu_wr_svga_req       (cpu_wr_svga_req),
     .text_mode             (text_mode),
     .cursor_addr_ok        (cursor_addr_ok),
     .cursor_addr_ok1       (cursor_addr_ok1),
     .data_complete         (data_complete),
     .crt_ff_write          (crt_ff_write),
     .m_t_svga_req          (m_t_svga_req),
     .m_mrd_mwr_n           (m_mrd_mwr_n)
     );

  sm_crt_ffwr_rd FFWRRD
    (
     .crt_frd1              (crt_frd1),
     .crt_frd17             (crt_frd17),
     .crt_fwr7_low          (crt_fwr7_low),
     .crt_fwr7_high         (crt_fwr7_high),
     .crt_fwr23_low         (crt_fwr23_low),
     .crt_fwr23_high        (crt_fwr23_high),
     .hreset_n              (h_reset_n),
     .sync_pre_vde          (sync_pre_vde),  
     .crt_ff_write          (crt_ff_write),
     .c_crt_line_end        (c_crt_line_end),
     .crt_fwr0              (crt_fwr0),
     .crt_fwr15             (crt_fwr15),
     .crt_fwr16             (crt_fwr16),
     .crt_fwr31             (crt_fwr31),
     .crt_fwr0_low          (crt_fwr0_low),
     .crt_fwr15_low         (crt_fwr15_low),
     .crt_fwr16_low         (crt_fwr16_low),
     .crt_fwr15_high        (crt_fwr15_high),
     .crt_fwr31_low         (crt_fwr31_low),
     .crt_fwr31_high        (crt_fwr31_high),
     .graphic_mode          (graphic_mode),
     .text_mode             (text_mode),
     .mem_clk               (t_mem_clk),
     .t_crt_clk             (t_crt_clk),
     .c_dclk_en             (c_dclk_en),
     .c_vdisp_end           (c_vdisp_end),
     .c_crt_ff_read         (c_crt_ff_read),
     .crt_frd16             (crt_frd16),
     .crt_frd15             (crt_frd15),
     .crt_frd31             (crt_frd31),
     .sync_crt_line_end     (sync_crt_line_end),

     .crt_ff_rda            (crt_ff_rda),
     .crt_ff_rdb            (crt_ff_rdb),
     .tx_ff_wra_low         (tx_ff_wra_low),
     .tx_ff_wra_high        (tx_ff_wra_high),
     .tx_ff_wrb_low         (tx_ff_wrb_low),
     .tx_ff_wrb_high        (tx_ff_wrb_high),
     .gr_ff_wra             (gr_ff_wra),
     .gr_ff_wrb             (gr_ff_wrb),
     .ff_writeable_crt      (ff_writeable_crt),
     .crt_req               (crt_req),
     .a_empty               (a_empty),
     .b_empty               (b_empty),
     .a_full_done           (a_full_done),
     .b_full_done           (b_full_done),
     .start_txt_sm          (start_txt_sm)
     );
  
  
  crt_fifo_logic FFLOGIC
    (
     .sync_c_crt_line_end   (sync_crt_line_end),
     .hreset_n              (h_reset_n),
     .mem_clk               (t_mem_clk),
     .t_crt_clk             (t_crt_clk),
     .c_dclk_en             (c_dclk_en),
     .crt_ff_write          (crt_ff_write),
     .c_crt_line_end        (c_crt_line_end),
     .c_crt_ff_read         (c_crt_ff_read),
     .dum_ff_read           (dum_ff_read),
     .enrd_font_addr        (enrd_font_addr),
     .text_mode             (text_mode),
     .crt_ff_rda            (crt_ff_rda),
     .crt_ff_rdb            (crt_ff_rdb),
     .gr_ff_wra             (gr_ff_wra),
     .gr_ff_wrb             (gr_ff_wrb),
     .tx_ff_wra_high        (tx_ff_wra_high),
     .tx_ff_wra_low         (tx_ff_wra_low),
     .tx_ff_wrb_high        (tx_ff_wrb_high),
     .tx_ff_wrb_low         (tx_ff_wrb_low),
     .extend_font_addr      (extend_font_addr),
     
     .crt_frd0              (crt_frd0),
     .crt_frd15             (crt_frd15),
     .crt_frd16             (crt_frd16),
     .crt_frd31             (crt_frd31),
     .crt_fwr0              (crt_fwr0),
     .crt_fwr15             (crt_fwr15),
     .crt_fwr16             (crt_fwr16),
     .crt_fwr31             (crt_fwr31),
     .crt_fwr0_low          (crt_fwr0_low),
     .crt_fwr15_high        (crt_fwr15_high),
     .crt_fwr15_low         (crt_fwr15_low),
     .crt_fwr16_low         (crt_fwr16_low),
     .crt_fwr31_high        (crt_fwr31_high),
     .crt_fwr31_low         (crt_fwr31_low),
     
     .dum_ff_rd_cnt0        (dum_ff_rd_cnt0),
     .att_text_out          (att_text_out),
     .m_att_data            (m_att_data),
     .m_t_mem_data_in       (m_t_mem_data_in),
     .ff_asic_out           (ff_asic_out),
     
     .crt_fwr7_low          (crt_fwr7_low),
     .crt_fwr7_high         (crt_fwr7_high),
     .crt_fwr23_low         (crt_fwr23_low),
     .crt_fwr23_high        (crt_fwr23_high),
     .crt_frd1              (crt_frd1),
     .crt_frd17             (crt_frd17)
     );
  
  crt_addr_gen ADDGEN
    (
     .en_cpurd_addr         (en_cpurd_addr),
     .enwr_cpu_ad_da_pl     (enwr_cpu_ad_da_pl),
     .m_sr04_b1             (m_sr04_b1),
     .tx_cnt_inc            (tx_cnt_inc),
     .gra_cnt_inc           (gra_cnt_inc),
     .hreset_n              (h_reset_n),
     .c_split_screen_pulse  (c_split_screen_pulse),
     .c_vde                 (c_vde),
     .c_pre_vde             (c_pre_vde),
     .c_row_end             (c_row_end),
     .c_crt_line_end        (c_crt_line_end),
     .sync_c_crt_line_end   (sync_crt_line_end),
     .mem_clk               (t_mem_clk),
     .t_crt_clk             (t_crt_clk),
     .text_mode             (text_mode),
     
     .c_cr17_b0             (c_cr17_b0),
     .c_cr17_b1             (c_cr17_b1),
     .c_cr17_b5             (c_cr17_b5),
     .c_cr17_b6             (c_cr17_b6),
     .c_cr14_b6             (c_cr14_b6),  
     
     .reg_cr0c_qout         (reg_cr0c_qout),
     .reg_cr0d_qout         (reg_cr0d_qout),
     .reg_cr0e_qout         (reg_cr0e_qout),
     .reg_cr0f_qout         (reg_cr0f_qout),
     .reg_cr13_qout         (reg_cr13_qout[7:0]),
     .reg_sr3_qout          (reg_sr3_qout),
     .c_slc_op              (c_slc_op[4:0]),
     .ff_asic_out           (ff_asic_out),
     .enrd_font_addr        (enrd_font_addr),
     .enrd_tx_addr          (enrd_tx_addr),
     .enrd_gra_addr         (enrd_gra_addr),
     .crt_ff_write          (crt_ff_write),
     
     .font_addr             (font_addr),
     .fin_crt_addr          (fin_crt_addr),
     .cursorx               (cursorx),
     .sync_pre_vde          (sync_pre_vde)
     );
  
  // Was att_test_blk
  assign decode_c0todf = m_t_mem_data_in[7:5] == 3'b110;
  assign int_x5 = cursorx & c_cursory;
  assign blank = (m_t_mem_data_in[14:12] == 3'b000) &
		   (m_t_mem_data_in[10:8] == 3'b000);
  assign under_line = (m_t_mem_data_in[14:12] == 3'b000) &
			(m_t_mem_data_in[10:8] == 3'b001) &
			  c_uln_on;
  assign reverse = (m_t_mem_data_in[14:12] == 3'b111) &
		     (m_t_mem_data_in[14:12] == 3'b000);
  assign text_mode = ~g_gr06_b0;
  assign graphic_mode = g_gr06_b0;
  assign att_text_out = (text_mode) ? {decode_c0todf, reverse, under_line,
				       blank, int_x5} : m_t_mem_data_in[28:24];
  
  sm_arb U_SM_ARB
    (
     .mem_clk               (t_mem_clk),
     .hreset_n              (h_reset_n),
     .crt_req               (crt_req    & mem_ready),
     .cpu_rd_req            (cpu_rd_req & mem_ready),
     .cpu_wr_req            (cpu_wr_req & mem_ready),
     .a_empty               (a_empty),
     .b_empty               (b_empty),
     .a_full_done           (a_full_done),
     .b_full_done           (b_full_done),
     .sync_crt_line_end     (sync_crt_line_end),
     .crt_gnt               (crt_gnt),
     .cpu_wr_gnt            (cpu_wr_gnt),
     .cpu_rd_gnt            (cpu_rd_gnt)
     );
  
  memif_reg_dec MREGDEC
    (
     .h_reset_n             (h_reset_n),
     .h_iord                (h_iord),
     .h_iowr                (h_iowr),
     .h_io_16               (h_io_16),
     .h_io_addr             (h_io_addr),
     .h_io_dbus             (h_io_dbus),
     .h_hclk                (t_mem_clk),
     .color_mode            (color_mode),
     .c_crtc_index          (c_crtc_index),
     .c_ext_index           (c_ext_index),
    
     .g_gr05_b4             (g_gr05_b4),
     
     .m_ready_n             (m_ready_n),
     .mem_mod_rd_en_hb      (mem_mod_rd_en_hb),
     .mem_mod_rd_en_lb      (mem_mod_rd_en_lb),
     .m_dec_sr00_sr06       (m_dec_sr00_sr06),
     .m_dec_sr07            (m_dec_sr07),
     
     .memif_index_qout      (memif_index_qout),
     .reg_sr0_qout          (reg_sr0_qout),
     .reg_sr1_qout          (reg_sr1_qout),
     .reg_sr2_qout          (reg_sr2_qout),
     .reg_sr3_qout          (reg_sr3_qout),
     .reg_sr4_qout          (reg_sr4_qout),
     
     .reg_cr0c_qout         (reg_cr0c_qout), // screen start address high
     .reg_cr0d_qout         (reg_cr0d_qout),
     .reg_cr0e_qout         (reg_cr0e_qout),
     .reg_cr0f_qout         (reg_cr0f_qout),
     .reg_cr13_qout         (reg_cr13_qout),
     
     .m_sr00_b0             (m_sr00_b0),
     .m_sr01_b1             (m_sr01_b1),
     .m_sr02_b              (m_sr02_b),
     .m_sr04_b3             (m_sr04_b3),
     .m_chain4              (m_chain4),
     .m_extend_mem          (m_extend_mem),
     .m_odd_even            (m_odd_even),
     .m_planar              (m_planar),
     .m_sr01_b4             (m_sr01_b4),
     .m_sr01_b3             (m_sr01_b3),
     .m_sr01_b2             (m_sr01_b2),
     .m_sr01_b0             (m_sr01_b0),
     .m_sr01_b5             (m_sr01_b5),
     .m_soft_rst_n          (m_soft_rst_n),
     .m_sr04_b1             (m_sr04_b1)
     );

endmodule










