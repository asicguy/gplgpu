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
//  Title       :  VGA Top Level
//  File        :  vga.v
//  Author      :  Frank Bruno
//  Created     :  11-Jun-2002
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//  hif            - Host interface module
//  crtc           - CRT  controller module
//  attr           - Attribute controller module
//  memiftoplevel  - memory controller module
//  graph_top      - Graphic controller module
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

module vga
  (
   input [22:0]      t_haddr,         // 23 bit address lines from Host
   input [3:0]       t_byte_en_n,     // Byte enable signals
   input             t_mem_io_n,      // 1 - Mem, 0 - IO.
   input             t_hrd_hwr_n,     // 1 - read, 0 - write
   input             t_hreset_n,      // reset signal coming from Host
   input             t_mem_clk,       // memory clock
   input             t_svga_sel,      // Valid address (MEM or IO) decoded
   input             t_crt_clk,       // Main crt clock
   input             t_sense_n,       // It indicates a CRT is connected.
   input             svga_ack,        // Accepted memory access
   input             t_data_ready_n,  // Data ready
   input [31:0]      t_hdata_in,      // Input data from host
   input [31:0]      m_t_mem_data_in, // Input data from memory
   input             vga_en,          // Signal to disable CRT and REF Req
   input             mem_ready,       // MC is ready
   
   output [31:0]     t_hdata_out,
   output [31:0]     m_t_mem_data_out,
   output 	     c_t_clk_sel,     // CRT clock select
   output            c_t_cblank_n,    // composite blank to ramdac
   output            c_t_hsync,       // HSYNC to ramdac
   output            c_t_vsync,       // Vsync to ramdac
   output            h_t_ready_n,     // Ready for next cycle
   output [7:0]      a_t_pix_data,    // Pixel data to Ramdac
   output [20:3]     m_t_mem_addr,    // Address to memory
   output [7:0]      m_t_mwe_n,       // Byte enables to memory
   output            m_t_svga_req,    // Request memory
   output [5:0]      g_t_ctl_bits,
   output            m_mrd_mwr_n
   );
  
  wire              pre_load;
  wire              a_ready_n;
  wire              c_ready_n;
  wire              g_ready_n;
  wire              m_ready_n;
  wire              g_mem_ready_n;
  wire              h_hrd_hwr_n;
  wire              h_mem_io_n;
  wire [22:0]       h_mem_addr;
  wire [15:0] 	    h_io_addr;
  wire              h_io_16;
  wire              h_io_8;
  wire              h_dec_3bx;
  wire              h_dec_3cx;
  wire              h_dec_3dx;
  wire              h_iord;
  wire              h_iowr;
  wire              h_svga_sel;
  wire              h_hclk;
  wire              m_sr01_b0;
  wire              m_sr01_b2;
  wire              m_sr01_b3;
  wire              m_sr01_b4;
  wire              m_sr01_b5;
  wire              a_ar10_b0;
  wire              a_ar10_b5;
  wire              a_ar10_b6;
  wire              a_arx_b5;
  wire              a_is01_b5;
  wire              a_is01_b4;
  wire              m_dec_sr00_sr06;
  wire              m_dec_sr07;
  wire              a_ar13_b3;
  wire              a_ar13_b2;
  wire              a_ar13_b1;
  wire              a_ar13_b0;
  wire              c_cr24_rd;
  wire              c_cr26_rd;
  wire              c_9dot;
  wire              c_mis_3c2_b5;
  wire              c_misc_b0;
  wire              c_misc_b1;
  
  wire              c_cr0b_b5;
  wire              c_cr0b_b6;
  wire              c_cr0a_b5;
  wire              c_cr14_b6;
  wire              c_cr17_b0;
  wire              c_cr17_b1;
  wire              c_cr17_b5;
  wire              c_cr17_b6;
  wire              c_dec_3ba_or_3da;
  wire              c_gr_ext_en;
  wire              c_vert_blank;
  wire              c_ahde;
  wire              c_crt_line_end;
  wire              c_dclk_en;
  wire              c_crt_ff_read;
  wire              c_shift_ld;
  wire              c_shift_ld_pulse;
  wire              c_shift_clk;
  wire              c_pre_vde;
  wire              c_split_screen_pulse;
  wire              c_vde;
  wire              c_vdisp_end;
  wire              c_attr_de;
  wire              c_uln_on;
  wire              c_cursory;
  wire [4:0]        c_slc_op;
  wire              c_row_end;
  wire              c_cr0c_f13_22_hit;
  wire [36:0]       m_att_data;
  wire              m_sr04_b3;
  wire              g_gr05_b5;
  wire              g_gr05_b6;
  wire              h_memrd;
  wire [31:0]       g_graph_data_in;
  wire [31:0]       g_graph_data_out;
  
  wire [3:0]        g_plane_sel;
  wire              g_memwr;
  wire              g_gr06_b0;
  wire              g_gr05_b4;
  wire              m_cpu_ff_full;
  wire              m_sr00_b0;
  wire              m_sr01_b1;
  wire [3:0]        m_sr02_b;                    
  wire [2:0]        m_sr0x_b;
  wire              m_chain4;
  wire              m_extend_mem;
  wire              m_odd_even;
  wire              m_planar;
  wire              g_gr06_b1;
  wire [15:0]       h_io_dbus;
  wire [7:0]        g_int_crt22_data;  
  wire              m_memrd_ready_n;
  wire [7:0]        fin_plane_sel;
  wire [19:0]       val_mrdwr_addr;
  wire              m_cpurd_state1;
  wire              g_cpult_state1;
  wire              g_lt_hwr_cmd;
  wire              m_crt_abort;
  wire              m_soft_rst_n;
  wire              g_cpu_data_done;
  wire              g_cpu_cycle_done;
  wire [31:0]       h_mem_dbus_in;
  wire [31:0]       h_mem_dbus_out;
  wire              cpu_rd_gnt;
  wire [3:0]        h_byte_en_n;
  wire              mem_mod_rd_en_hb;
  wire              mem_mod_rd_en_lb;
  wire              crt_mod_rd_en_hb;
  wire              crt_mod_rd_en_lb;
  wire              attr_mod_rd_en;
  wire              gra_mod_rd_en;
  wire              attr_mod_rd_en_lb;
  wire              attr_mod_rd_en_hb;
  
  // point to points from the h_io_dbus
  // From attribute controller
  wire [7:0] 	    a_reg_ar10;
  wire [7:0] 	    a_reg_ar11;
  wire [7:0] 	    a_reg_ar12;
  wire [7:0] 	    a_reg_ar13;
  wire [7:0] 	    a_reg_ar14;
  wire [5:0] 	    a_dport_out;
  wire [7:0] 	    a_attr_index;
  wire [7:0] 	    a_cr24_26_dbus;
  wire [7:0] 	    c_reg_ht;   // Horizontal total
  wire [7:0] 	    c_reg_hde;  //Horizontal Display End
  wire [7:0] 	    c_reg_hbs;  //Horizontal Blanking Start
  wire [7:0] 	    c_reg_hbe;  //Horizontal Blanking End
  wire [7:0] 	    c_reg_hss;  //Horizontal Sync Start
  wire [7:0] 	    c_reg_hse;  //Horizontal Sync End
  wire [7:0] 	    c_reg_cr06;
  wire [7:0] 	    c_reg_cr07;
  wire [7:0] 	    c_reg_cr10;
  wire [7:0] 	    c_reg_cr11;
  wire [7:0] 	    c_reg_cr12;
  wire [7:0] 	    c_reg_cr15;
  wire [7:0] 	    c_reg_cr16;
  wire [7:0] 	    c_reg_cr18;
  wire [7:0] 	    c_crtc_index;  // crtc index register
  wire [7:0] 	    c_ext_index;   // extension index register
  wire [7:0] 	    c_reg_ins0;
  wire [7:0] 	    c_reg_ins1;
  wire [7:0] 	    c_reg_fcr;   
  wire [7:0] 	    c_reg_cr17;
  wire [7:0] 	    c_reg_cr08;
  wire [7:0] 	    c_reg_cr09;
  wire [7:0] 	    c_reg_cr0a;   
  wire [7:0] 	    c_reg_cr0b;
  wire [7:0] 	    c_reg_cr14;
  wire [7:0] 	    c_reg_misc;
  wire [7:0] 	    m_index_qout;
  wire [7:0] 	    m_reg_sr0_qout;
  wire [7:0] 	    m_reg_sr1_qout;
  wire [7:0] 	    m_reg_sr2_qout;
  wire [7:0] 	    m_reg_sr3_qout;
  wire [7:0] 	    m_reg_sr4_qout;
  wire [7:0] 	    m_reg_cr0c_qout;
  wire [7:0] 	    m_reg_cr0d_qout;
  wire [7:0] 	    m_reg_cr0e_qout;
  wire [7:0] 	    m_reg_cr0f_qout;
  wire [7:0] 	    m_reg_cr13_qout;
	    
  wire [7:0] 	    g_reg_gr0;
  wire [7:0] 	    g_reg_gr1;
  wire [7:0] 	    g_reg_gr2;
  wire [7:0] 	    g_reg_gr3;
  wire [7:0] 	    g_reg_gr4;
  wire [7:0] 	    g_reg_gr5;
  wire [7:0] 	    g_reg_gr6;
  wire [7:0] 	    g_reg_gr7;
  wire [7:0] 	    g_reg_gr8;

  wire 		    color_256_mode;      // inidcates mode 13
  wire 		    g_memrd;
  wire 		    m_cpurd_s0;

  wire [10:0] 	    vcount;
  
  hif   KH
    (
     .mem_mod_rd_en_hb     (mem_mod_rd_en_hb),
     .mem_mod_rd_en_lb     (mem_mod_rd_en_lb),
     .crt_mod_rd_en_hb     (crt_mod_rd_en_hb),
     .crt_mod_rd_en_lb     (crt_mod_rd_en_lb),
     .attr_mod_rd_en_lb    (attr_mod_rd_en_lb),
     .attr_mod_rd_en_hb    (attr_mod_rd_en_hb),
     .gra_mod_rd_en        (gra_mod_rd_en),
     .t_haddr              (t_haddr),
     .t_byte_en_n          (t_byte_en_n),
     .t_mem_io_n           (t_mem_io_n),
     .t_hrd_hwr_n          (t_hrd_hwr_n),
     .t_hreset_n           (t_hreset_n),
     .t_mem_clk            (t_mem_clk),
     .t_svga_sel           (t_svga_sel),
     .a_ready_n            (a_ready_n),
     .c_ready_n            (c_ready_n),
     .g_ready_n            (g_ready_n),
     .m_ready_n            (m_ready_n),
     .g_mem_ready_n        (g_mem_ready_n),
     .m_cpurd_state1       (m_cpurd_state1),
     .g_cpult_state1       (g_cpult_state1),
     .g_lt_hwr_cmd         (g_lt_hwr_cmd),
     .t_hdata_in           (t_hdata_in),
     .h_mem_dbus_in        (h_mem_dbus_in),

     // register inputs from the given modules
     .a_reg_ar10           (a_reg_ar10),
     .a_reg_ar11           (a_reg_ar11),
     .a_reg_ar12           (a_reg_ar12),
     .a_reg_ar13           (a_reg_ar13),
     .a_reg_ar14           (a_reg_ar14),
     .a_dport_out          (a_dport_out),
     .a_attr_index         (a_attr_index),
     .a_cr24_26_dbus       (a_cr24_26_dbus),
     .c_reg_ht             (c_reg_ht),   // Horizontal total
     .c_reg_hde            (c_reg_hde),  //Horizontal Display End
     .c_reg_hbs            (c_reg_hbs),  //Horizontal Blanking Start
     .c_reg_hbe            (c_reg_hbe),  //Horizontal Blanking End
     .c_reg_hss            (c_reg_hss),  //Horizontal Sync Start
     .c_reg_hse            (c_reg_hse),  //Horizontal Sync End
     .c_reg_cr06           (c_reg_cr06),
     .c_reg_cr07           (c_reg_cr07),
     .c_reg_cr10           (c_reg_cr10),
     .c_reg_cr11           (c_reg_cr11),
     .c_reg_cr12           (c_reg_cr12),
     .c_reg_cr15           (c_reg_cr15),
     .c_reg_cr16           (c_reg_cr16),
     .c_reg_cr18           (c_reg_cr18),
     .c_crtc_index         (c_crtc_index),
     .c_ext_index          (c_ext_index),
     .c_reg_ins0           (c_reg_ins0),
     .c_reg_ins1           (c_reg_ins1),
     .c_reg_fcr            (c_reg_fcr),    
     .c_reg_cr17           (c_reg_cr17),
     .c_reg_cr08           (c_reg_cr08),
     .c_reg_cr09           (c_reg_cr09),
     .c_reg_cr0a           (c_reg_cr0a),    
     .c_reg_cr0b           (c_reg_cr0b),
     .c_reg_cr14           (c_reg_cr14),
     .c_reg_misc           (c_reg_misc),
     .g_int_crt22_data     (g_int_crt22_data),      
     .m_index_qout         (m_index_qout),
     .m_reg_sr0_qout       (m_reg_sr0_qout),
     .m_reg_sr1_qout       (m_reg_sr1_qout),
     .m_reg_sr2_qout       (m_reg_sr2_qout),
     .m_reg_sr3_qout       (m_reg_sr3_qout),
     .m_reg_sr4_qout       (m_reg_sr4_qout),
     .m_reg_cr0c_qout      (m_reg_cr0c_qout),
     .m_reg_cr0d_qout      (m_reg_cr0d_qout),
     .m_reg_cr0e_qout      (m_reg_cr0e_qout),
     .m_reg_cr0f_qout      (m_reg_cr0f_qout),
     .m_reg_cr13_qout      (m_reg_cr13_qout),
     .g_reg_gr0            (g_reg_gr0),
     .g_reg_gr1            (g_reg_gr1),
     .g_reg_gr2            (g_reg_gr2),
     .g_reg_gr3            (g_reg_gr3),
     .g_reg_gr4            (g_reg_gr4),
     .g_reg_gr5            (g_reg_gr5),
     .g_reg_gr6            (g_reg_gr6),
     .g_reg_gr7            (g_reg_gr7),
     .g_reg_gr8            (g_reg_gr8),
     
     .h_io_dbus            (h_io_dbus),
     .t_hdata_out          (t_hdata_out),
     .h_mem_dbus_out       (h_mem_dbus_out),
     .h_hrd_hwr_n          (h_hrd_hwr_n),
     .h_mem_io_n           (h_mem_io_n),
     .h_t_ready_n          (h_t_ready_n),
     .h_mem_addr           (h_mem_addr),
     .h_io_addr            (h_io_addr),
     .h_io_16              (h_io_16),
     .h_io_8               (h_io_8),
     .h_dec_3bx            (h_dec_3bx),
     .h_dec_3cx            (h_dec_3cx),
     .h_dec_3dx            (h_dec_3dx),
     .h_iord               (h_iord),
     .h_iowr               (h_iowr),
     .h_byte_en_n          (h_byte_en_n),
     .h_svga_sel           (h_svga_sel)
     );

  crtc KC
    (
     .h_io_addr            (h_io_addr),
     .h_dec_3bx            (h_dec_3bx),
     .h_dec_3cx            (h_dec_3cx),
     .h_dec_3dx            (h_dec_3dx),
     .h_io_16              (h_io_16),
     .h_io_8               (h_io_8),
     .h_reset_n            (t_hreset_n),
     .h_iord               (h_iord),
     .h_iowr               (h_iowr),
     .h_hclk               (t_mem_clk),
     .t_crt_clk            (t_crt_clk),
     .m_sr01_b0            (m_sr01_b0),
     .m_sr01_b2            (m_sr01_b2),
     .m_sr01_b3            (m_sr01_b3),
     .m_sr01_b4            (m_sr01_b4),
     .m_sr01_b5            (m_sr01_b5),
     .a_ar10_b0            (a_ar10_b0),
     .a_ar10_b5            (a_ar10_b5),
     .a_ar10_b6            (a_ar10_b6),
     .t_sense_n            (t_sense_n),
     .a_arx_b5             (a_arx_b5),
     .a_is01_b5            (a_is01_b5),
     .a_is01_b4            (a_is01_b4),
     .m_dec_sr00_sr06      (m_dec_sr00_sr06),
     .m_dec_sr07           (m_dec_sr07),
     .m_soft_rst_n         (m_soft_rst_n),
     .a_ar13_b3            (a_ar13_b3),
     .a_ar13_b2            (a_ar13_b2),
     .a_ar13_b1            (a_ar13_b1),
     .a_ar13_b0            (a_ar13_b0),
     .h_io_dbus            (h_io_dbus), // now only the input
     .vga_en               (vga_en),
     
     .c_reg_ht             (c_reg_ht),   // Horizontal total
     .c_reg_hde            (c_reg_hde),  //Horizontal Display End
     .c_reg_hbs            (c_reg_hbs),  //Horizontal Blanking Start
     .c_reg_hbe            (c_reg_hbe),  //Horizontal Blanking End
     .c_reg_hss            (c_reg_hss),  //Horizontal Sync Start
     .c_reg_hse            (c_reg_hse),  //Horizontal Sync End
     .c_reg_cr06           (c_reg_cr06),
     .c_reg_cr07           (c_reg_cr07),
     .c_reg_cr10           (c_reg_cr10),
     .c_reg_cr11           (c_reg_cr11),
     .c_reg_cr12           (c_reg_cr12),
     .c_reg_cr15           (c_reg_cr15),
     .c_reg_cr16           (c_reg_cr16),
     .c_reg_cr18           (c_reg_cr18),
     .c_crtc_index         (c_crtc_index),
     .c_ext_index          (c_ext_index),
     .c_reg_ins0           (c_reg_ins0),
     .c_reg_ins1           (c_reg_ins1),
     .c_reg_fcr            (c_reg_fcr),    
     .c_reg_cr17           (c_reg_cr17),
     .c_reg_cr08           (c_reg_cr08),
     .c_reg_cr09           (c_reg_cr09),
     .c_reg_cr0a           (c_reg_cr0a),    
     .c_reg_cr0b           (c_reg_cr0b),
     .c_reg_cr14           (c_reg_cr14),
     .c_reg_misc           (c_reg_misc),
     
     .c_cr24_rd            (c_cr24_rd),
     .c_cr26_rd            (c_cr26_rd),
     .c_9dot               (c_9dot),
     .c_mis_3c2_b5         (c_mis_3c2_b5),
     .c_misc_b0            (c_misc_b0),
     .c_cr0b_b5            (c_cr0b_b5),
     .c_cr0b_b6            (c_cr0b_b6),
     .c_cr0a_b5            (c_cr0a_b5),
     .c_cr14_b6            (c_cr14_b6),
     .c_cr17_b0            (c_cr17_b0),
     .c_cr17_b1            (c_cr17_b1),
     .c_cr17_b5            (c_cr17_b5),
     .c_cr17_b6            (c_cr17_b6),
     .c_gr_ext_en          (c_gr_ext_en),
     .c_ext_index_b        (),
     .c_dec_3ba_or_3da     (c_dec_3ba_or_3da),
     .c_vert_blank         (c_vert_blank),
     .c_ready_n            (c_ready_n),
     .c_t_clk_sel          (c_t_clk_sel),
     .c_ahde               (c_ahde),
     .c_t_cblank_n         (c_t_cblank_n),
     .c_crt_line_end       (c_crt_line_end),
     .c_dclk_en            (c_dclk_en),
     .c_crt_ff_read        (c_crt_ff_read),
     .c_shift_ld           (c_shift_ld),
     .c_shift_ld_pulse     (c_shift_ld_pulse),
     .c_t_hsync            (c_t_hsync),
     .c_shift_clk          (c_shift_clk),
     .c_pre_vde            (c_pre_vde),
     .c_split_screen_pulse (c_split_screen_pulse),
     .c_vde                (c_vde),
     .c_vdisp_end          (c_vdisp_end),
     .c_t_vsync            (c_t_vsync),
     .c_attr_de            (c_attr_de),
     .c_uln_on             (c_uln_on),
     .c_cursory            (c_cursory),
     .c_slc_op             (c_slc_op),
     .c_row_end            (c_row_end),
     .c_cr0c_f13_22_hit    (c_cr0c_f13_22_hit),
     .c_misc_b1            (c_misc_b1),
     .crt_mod_rd_en_hb     (crt_mod_rd_en_hb),
     .crt_mod_rd_en_lb     (crt_mod_rd_en_lb),
     .pre_load             (pre_load),
     .vcount               (vcount)
     );			 
    
  attr KA
    (
     .h_reset_n            (t_hreset_n),
     .h_io_addr            (h_io_addr),
     .h_dec_3cx            (h_dec_3cx),
     .h_iowr               (h_iowr),
     .h_iord               (h_iord),
     .h_hclk               (t_mem_clk),
     .c_shift_ld           (c_shift_ld),
     .c_shift_ld_pulse     (c_shift_ld_pulse),
     .c_shift_clk          (c_shift_clk),
     .c_dclk_en            (c_dclk_en),
     .c_9dot               (c_9dot),
     .m_att_data           (m_att_data),
     .m_sr04_b3            (m_sr04_b3),
     .c_cr24_rd            (c_cr24_rd),
     .c_cr26_rd            (c_cr26_rd),
     .c_attr_de            (c_attr_de),
     .c_t_vsync            (c_t_vsync),
     .c_dec_3ba_or_3da     (c_dec_3ba_or_3da),
     .c_cr0b_b5            (c_cr0b_b5),
     .c_cr0b_b6            (c_cr0b_b6),
     .c_cr0a_b5            (c_cr0a_b5),
     .g_gr05_b5            (g_gr05_b5),
     .g_gr05_b6            (g_gr05_b6),
     .t_crt_clk            (t_crt_clk),
     .h_io_16              (h_io_16),
     .h_io_dbus            (h_io_dbus),
     .pre_load             (pre_load),    

     .reg_ar10             (a_reg_ar10),
     .reg_ar11             (a_reg_ar11),
     .reg_ar12             (a_reg_ar12),
     .reg_ar13             (a_reg_ar13),
     .reg_ar14             (a_reg_ar14),
     .dport_out            (a_dport_out),
     .attr_index           (a_attr_index),
     .cr24_26_dbus         (a_cr24_26_dbus),
     .a_ready_n            (a_ready_n),
     .a_ar10_b6            (a_ar10_b6),
     .a_ar10_b5            (a_ar10_b5),
     .a_ar10_b0            (a_ar10_b0),
     .a_ar13_b3            (a_ar13_b3),
     .a_ar13_b2            (a_ar13_b2),
     .a_ar13_b1            (a_ar13_b1),
     .a_ar13_b0            (a_ar13_b0),
     .a_arx_b5             (a_arx_b5),
     .a_is01_b5            (a_is01_b5),
     .a_is01_b4            (a_is01_b4),
     .a_t_pix_data         (a_t_pix_data),
     .attr_mod_rd_en_lb    (attr_mod_rd_en_lb),
     .attr_mod_rd_en_hb    (attr_mod_rd_en_hb),
     .color_256_mode       (color_256_mode)
     );

  memif_toplevel KM
    (
     .t_data_ready_n       (t_data_ready_n),
     .t_mem_clk            (t_mem_clk),
     .t_crt_clk            (t_crt_clk),
     .svga_ack             (svga_ack),
     .c_misc_b1            (c_misc_b1),      
     .c_split_screen_pulse (c_split_screen_pulse),
     .c_vde                (c_vde),
     .c_pre_vde            (c_pre_vde),
     .c_row_end            (c_row_end),
     .c_cr17_b0            (c_cr17_b0), 
     .c_cr17_b1            (c_cr17_b1),
     .c_cr17_b5            (c_cr17_b5),
     .c_cr17_b6            (c_cr17_b6),
     .c_cr14_b6            (c_cr14_b6), 
     .c_slc_op             (c_slc_op),
     .c_crt_line_end       (c_crt_line_end),
     .c_dclk_en            (c_dclk_en),
     .c_vdisp_end          (c_vdisp_end),
     .c_crt_ff_read        (c_crt_ff_read),
     .c_vert_blank         (c_vert_blank),
     .c_cursory            (c_cursory),
     .c_uln_on             (c_uln_on),
     .c_cr0c_f13_22_hit    (c_cr0c_f13_22_hit),
     .g_memrd              (g_memrd),
     .h_reset_n            (t_hreset_n),
     .h_iord               (h_iord),
     .h_iowr               (h_iowr),
     .h_io_16              (h_io_16),
     .h_io_addr            (h_io_addr),
     .h_svga_sel           (h_svga_sel),
     .val_mrdwr_addr       (val_mrdwr_addr),
     .fin_plane_sel        (fin_plane_sel),
     .g_graph_data_in      (g_graph_data_in),
     .g_graph_data_out     (g_graph_data_out),
     .g_plane_sel          (g_plane_sel),
     .g_memwr              (g_memwr),
     .g_gr06_b0            (g_gr06_b0),
     .g_gr05_b4            (g_gr05_b4),
     .g_cpu_cycle_done     (g_cpu_cycle_done),
     .g_cpu_data_done      (g_cpu_data_done),
     .h_io_dbus            (h_io_dbus),
     .color_mode           (c_misc_b0),
     .c_crtc_index         (c_crtc_index[5:0]),
     .c_ext_index          (c_ext_index),
     .c_hde                (c_reg_hde),
     .color_256_mode       (color_256_mode),
     .vga_en               (vga_en),
     .mem_ready            (mem_ready),
     
     .memif_index_qout     (m_index_qout),
     .reg_sr0_qout         (m_reg_sr0_qout),
     .reg_sr1_qout         (m_reg_sr1_qout),
     .reg_sr2_qout         (m_reg_sr2_qout),
     .reg_sr3_qout         (m_reg_sr3_qout),
     .reg_sr4_qout         (m_reg_sr4_qout),
     .reg_cr0c_qout        (m_reg_cr0c_qout), // screen start address high
     .reg_cr0d_qout        (m_reg_cr0d_qout),
     .reg_cr0e_qout        (m_reg_cr0e_qout),
     .reg_cr0f_qout        (m_reg_cr0f_qout),
     .reg_cr13_qout        (m_reg_cr13_qout),
     .m_t_mem_addr         (m_t_mem_addr),
     .m_t_mem_data_in      (m_t_mem_data_in),
     .m_t_mem_data_out     (m_t_mem_data_out),
     .m_t_mwe_n            (m_t_mwe_n),
     .m_t_svga_req         (m_t_svga_req),

     .m_att_data           (m_att_data),
     .m_cpu_ff_full        (m_cpu_ff_full),
     
     .m_sr00_b0            (m_sr00_b0),
     .m_sr01_b1            (m_sr01_b1),
     .m_sr02_b             (m_sr02_b),
     .m_sr04_b3            (m_sr04_b3),
     
     .m_sr01_b4            (m_sr01_b4),
     .m_sr01_b3            (m_sr01_b3),
     .m_sr01_b2            (m_sr01_b2),
     .m_sr01_b0            (m_sr01_b0),
     .m_sr01_b5            (m_sr01_b5),
     .m_chain4             (m_chain4),
     .m_extend_mem         (m_extend_mem),
     .m_odd_even           (m_odd_even),
     .m_planar             (m_planar),
     .m_ready_n            (m_ready_n),
     .m_dec_sr00_sr06      (m_dec_sr00_sr06),
     .m_dec_sr07           (m_dec_sr07),
     .m_memrd_ready_n      (m_memrd_ready_n),
     .m_cpurd_state1       (m_cpurd_state1),
     .m_mrd_mwr_n          (m_mrd_mwr_n),
     .m_soft_rst_n         (m_soft_rst_n),
     .m_cpurd_s0           (m_cpurd_s0),
     .cpu_rd_gnt           (cpu_rd_gnt),
     .mem_mod_rd_en_hb     (mem_mod_rd_en_hb),
     .mem_mod_rd_en_lb     (mem_mod_rd_en_lb)
     );
      
  graph_top KG
    (
     .t_mem_io_n           (t_mem_io_n),
     .t_svga_sel           (t_svga_sel),   
     .cpu_rd_gnt           (cpu_rd_gnt),
     .h_reset_n            (t_hreset_n),
     .t_mem_clk            (t_mem_clk),
     .t_data_ready_n       (t_data_ready_n),
     .svga_ack             (svga_ack),
     .h_svga_sel           (h_svga_sel),
     .h_hrd_hwr_n          (h_hrd_hwr_n),
     .h_mem_io_n           (h_mem_io_n),
     
     .h_byte_en_n          (h_byte_en_n),
     .m_cpurd_s0           (m_cpurd_s0),
     .m_cpu_ff_full        (m_cpu_ff_full),
     .m_chain4             (m_chain4),
     .m_odd_even           (m_odd_even),
     .m_planar             (m_planar),
     .m_memrd_ready_n      (m_memrd_ready_n),
     
     .h_mem_addr           (h_mem_addr),
     .c_mis_3c2_b5         (c_mis_3c2_b5),
     
     .h_iord               (h_iord),
     .h_iowr               (h_iowr),
     .h_io_16              (h_io_16),
     .h_dec_3cx            (h_dec_3cx),
     .h_io_addr            (h_io_addr),
     .h_io_dbus            (h_io_dbus[15:8]),
     .c_misc_b0            (c_misc_b0),
     .c_misc_b1            (c_misc_b1),
     
     .c_gr_ext_en          (c_gr_ext_en),
     .c_ext_index          (c_ext_index),
     .m_sr04_b3            (m_sr04_b3),
     
     .m_ready_n            (m_ready_n),
     
     .m_sr02_b             (m_sr02_b),
     
     // outputs
     .g_reg_gr0            (g_reg_gr0),
     .g_reg_gr1            (g_reg_gr1),
     .g_reg_gr2            (g_reg_gr2),
     .g_reg_gr3            (g_reg_gr3),
     .g_reg_gr4            (g_reg_gr4),
     .g_reg_gr5            (g_reg_gr5),
     .g_reg_gr6            (g_reg_gr6),
     .g_reg_gr7            (g_reg_gr7),
     .g_reg_gr8            (g_reg_gr8),
     
     .g_mem_ready_n        (g_mem_ready_n),         
     .g_memwr              (g_memwr),
     .g_gr05_b5            (g_gr05_b5),
     .g_gr05_b6            (g_gr05_b6),
     .g_gr05_b4            (g_gr05_b4),
     .g_gr06_b0            (g_gr06_b0),
     .g_gr06_b1            (g_gr06_b1),
     
     .g_ready_n            (g_ready_n),
     .g_t_ctl_bit          (g_t_ctl_bits),
     
     .h_mem_dbus_in        (h_mem_dbus_in),
     .h_mem_dbus_out       (h_mem_dbus_out),
     
     .g_graph_data_in      (g_graph_data_in),
     .g_graph_data_out     (g_graph_data_out),
      
     .g_int_crt22_data     (g_int_crt22_data),
     .g_memrd              (g_memrd),
     .val_mrdwr_addr       (val_mrdwr_addr),
     .fin_plane_sel        (fin_plane_sel),
     .g_lt_hwr_cmd         (g_lt_hwr_cmd),
     .g_cpult_state1       (g_cpult_state1),
     .g_cpu_data_done      (g_cpu_data_done),
     .g_cpu_cycle_done     (g_cpu_cycle_done),
     .gra_mod_rd_en        (gra_mod_rd_en)
     );


endmodule
