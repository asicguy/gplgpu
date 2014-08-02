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
//  Title       :  Graphics module top level
//  File        :  graph_top.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module is the integration of all the graphic
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
//   sm_cpu_cy124.v
//   htaddmap.v
//   grap_reg_dec.v
//   grap_data_wr.v
//   grap_data_rd.v
//   read_data.v
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
module graph_top 
  (
   input          t_mem_io_n,   
   input 	  t_svga_sel,      
   input 	  cpu_rd_gnt,
   input 	  m_cpurd_s0,
   input 	  t_data_ready_n,
   input 	  svga_ack,
   input 	  h_reset_n,  	  // Power on reset
   input 	  t_mem_clk,	  // Memory reference clock input.
   input 	  h_svga_sel,     /* This pin is driven by the host I/F block 
				   * indicating that a valid address has been 
				   * decoded in a SVGA memory space or a svga
				   * IO space. These signals are buffered 
				   * from the top level. */
   input 	  h_hrd_hwr_n,    // indicates whether a read or a write.
   input 	  h_mem_io_n,	  // indicates whether a memory or a IO acc.
   input [3:0] 	  h_byte_en_n,    // specify the width of the data.
   input [31:0]   h_mem_dbus_out,  /* Data bus for Memory read/write operation 
				    * from/to Host module. */
   input 	  m_cpu_ff_full,  // Indicates the cpu fifo is full.
   input [22:0]   h_mem_addr,     // Lower 23 bits for memory operation.
   input 	  c_mis_3c2_b5,   // Odd/Even page select.
   input 	  h_iord,  	  // Indicates curr IO cycle is a read cycle.
   input 	  h_iowr,         // Indicates curr IO cycle is a write cycle
   input 	  h_io_16,        // Indicates the current IO cycle is 16 bit.
   input 	  h_dec_3cx,      // IO group decode of address range 03CX.
   input [15:0]   h_io_addr,      // Used for IO decodes.
   input 	  c_misc_b0,      // 
   input 	  c_misc_b1,
   input 	  c_gr_ext_en,    //
   input [7:0] 	  c_ext_index,
   input 	  m_sr04_b3,      // Double odd/even (chain4) addressing mode.
   input 	  m_ready_n,   
   input 	  m_chain4,	  // Double odd/even (chain4) addressing mode.
   input 	  m_odd_even,	  // Odd/Even addressing mode.
   input 	  m_planar,	  // Plannar addressing mode.
   input 	  m_memrd_ready_n,
   input [3:0] 	  m_sr02_b,    	  // Plane enable register bits.
   input [15:8]   h_io_dbus, 	  // Data bus for I/O read/write operation
   input [31:0]   g_graph_data_in,// Data bus to/from memory module.
   
   output [7:0]   g_reg_gr0,
   output [7:0]   g_reg_gr1,
   output [7:0]   g_reg_gr2,
   output [7:0]   g_reg_gr3,
   output [7:0]   g_reg_gr4,
   output [7:0]   g_reg_gr5,
   output [7:0]   g_reg_gr6,
   output [7:0]   g_reg_gr7,
   output [7:0]   g_reg_gr8,
   output [31:0]  h_mem_dbus_in,
   output 	  g_ready_n,	 // Indicates the current IO cycle is done.
   output 	  g_mem_ready_n, // Indicates the current memory cycle is done.
   output 	  g_memwr, 	 // Indicates memory write cycle in progress.
   output 	  g_gr05_b5,              
   output 	  g_gr05_b6,
   output 	  g_gr05_b4,
   output 	  g_gr06_b0,
   output 	  g_gr06_b1,
   output [31:0]  g_graph_data_out, // Data bus to/from memory module.
   output [5:0]   g_t_ctl_bit,	 /* Indicates the appropriate address range 
				  * required to be decoded in order to 
				  * generate SVGA_SEL. */
   output [7:0]   g_int_crt22_data,
   output         g_memrd,   
   
   output [19:0]  val_mrdwr_addr,
   output [7:0]   fin_plane_sel,
   output         g_lt_hwr_cmd,
   output         g_cpult_state1,
   output         g_cpu_data_done,
   output         g_cpu_cycle_done,
   output         gra_mod_rd_en
   );
   
  //
  // 	 Define Variables
  //
  wire          en_cy1;
  wire          en_cy2;
  wire          en_cy3;
  wire          en_cy4;
  wire          en_cy1_ff;
  wire          en_cy2_ff;
  wire          en_cy3_ff;
  wire          en_cy4_ff;
  wire          odd_8bit;
  wire 		rd_en_0, rd_en_1;
  wire          memwr_inpr;
  wire [31:0]   sftw_h_mem_dbus;   
  wire [1:0]    g_graph_addr;
  wire          gr4_b0;
  wire          gr4_b1;
  wire          gr6_b2;
  wire          gr6_b3;
  wire [3:0]    reg_gr0_qout;
  wire [3:0]    reg_gr1_qout;
  wire [3:0]    reg_gr2_qout;
  wire [4:0]    reg_gr3_qout;
  wire [3:0]    reg_gr7_qout;
  wire [7:0]    reg_gr8_qout;
  wire          gr5_b0;     // write mode[0]
  wire          gr5_b1;     // write mode[1]
  wire          mem_clk;
  wire          read_mode_1;
  wire          read_mode_0;
  wire [31:0]   cpu_lat_data;
  wire          cpucy_1_2;
  wire          cpucy_2_2;
  wire          cpucy_1_3;
  wire          cpucy_2_3;
  wire          cpucy_3_3;
  wire          cpucy_1_4;
  wire          cpucy_2_4;
  wire          cpucy_3_4;
  wire          cpucy_4_4;
  wire          cy2_gnt;
  wire          cy3_gnt;
  wire          cy4_gnt;
  wire          mem_write;
  wire [31:0]   h2mem_bout;
  wire          mem_read;
  wire          svga_sel_hit;
  wire          svmem_sel_hit;
  wire          svmem_hit_we;      
  wire          cur_cpurd_done;
  
  wire          cycle2;
  wire          m2s1_q;
  wire          m2s2_q;

  sm_cpu_cy124 CY124 
    (
     .t_mem_io_n             (t_mem_io_n),
     .t_svga_sel             (t_svga_sel),
     .m_cpurd_s0             (m_cpurd_s0),
     .t_data_ready_n         (t_data_ready_n),
     .cpu_rd_gnt             (cpu_rd_gnt),
     .svga_ack               (svga_ack),
     .en_cy1                 (en_cy1),
     .en_cy2                 (en_cy2),
     .en_cy3                 (en_cy3),
     .en_cy4                 (en_cy4),
     .c_misc_b1              (c_misc_b1),  
     .h_reset_n              (h_reset_n),
     .t_mem_clk              (t_mem_clk),
     .h_svga_sel             (h_svga_sel),
     .h_hrd_hwr_n            (h_hrd_hwr_n),
     .h_mem_io_n             (h_mem_io_n),
     .m_cpu_ff_full          (m_cpu_ff_full),
     .m_chain4               (m_chain4),
     .m_odd_even             (m_odd_even),
     .m_planar               (m_planar),
     .m_memrd_ready_n        (m_memrd_ready_n),
     .cpucy_1_2              (cpucy_1_2),
     .cpucy_2_2              (cpucy_2_2),
     .cpucy_1_3              (cpucy_1_3),
     .cpucy_2_3              (cpucy_2_3),
     .cpucy_3_3              (cpucy_3_3),
     .cpucy_1_4              (cpucy_1_4),
     .cpucy_2_4              (cpucy_2_4),
     .cpucy_3_4              (cpucy_3_4),
     .cpucy_4_4              (cpucy_4_4),
     .g_mem_ready_n          (g_mem_ready_n),
     .g_memwr                (g_memwr),
     .mem_clk                (mem_clk),
     .g_memrd                (g_memrd),
     .g_lt_hwr_cmd           (g_lt_hwr_cmd),
     .g_cpult_state1         (g_cpult_state1),
     .cy2_gnt                (cy2_gnt),
     .cy3_gnt                (cy3_gnt),
     .cy4_gnt                (cy4_gnt),
     .mem_write              (mem_write),
     .memwr_inpr             (memwr_inpr),
     .g_cpu_data_done        (g_cpu_data_done),
     .g_cpu_cycle_done       (g_cpu_cycle_done),
     .mem_read               (mem_read),
     .svga_sel_hit           (svga_sel_hit),
     .svmem_sel_hit          (svmem_sel_hit),
     .svmem_hit_we           (svmem_hit_we),
     .en_cy1_ff              (en_cy1_ff),
     .en_cy2_ff              (en_cy2_ff),
     .en_cy3_ff              (en_cy3_ff),
     .en_cy4_ff              (en_cy4_ff),
     .cur_cpurd_done         (cur_cpurd_done)
     );

  htaddmap HADMAP
    (
     .mem_read               (mem_read),
     .cpu_rd_gnt             (cpu_rd_gnt),
     .svmem_hit_we           (svmem_hit_we),
     .svmem_sel_hit          (svmem_sel_hit),
     .svga_sel_hit           (svga_sel_hit),
     .t_mem_io_n             (t_mem_io_n),
     .h_mem_dbus_out         (h_mem_dbus_out),
     .memwr_inpr             (memwr_inpr),
     .mem_write              (mem_write),   
     .cy2_gnt                (cy2_gnt),
     .cy3_gnt                (cy3_gnt),
     .cy4_gnt                (cy4_gnt),
     .h_byte_en_n            (h_byte_en_n),
     .m_planar               (m_planar),
     .cpucy_1_2              (cpucy_1_2),
     .cpucy_2_2              (cpucy_2_2),
     .cpucy_1_3              (cpucy_1_3),
     .cpucy_2_3              (cpucy_2_3),
     .cpucy_3_3              (cpucy_3_3),
     .cpucy_1_4              (cpucy_1_4),
     .cpucy_2_4              (cpucy_2_4),
     .cpucy_3_4              (cpucy_3_4),
     .cpucy_4_4              (cpucy_4_4),
     .h_mem_addr             (h_mem_addr),
     .c_mis_3c2_b5           (c_mis_3c2_b5),
     .gr6_b2                 (gr6_b2),
     .gr6_b3                 (gr6_b3),
     .g_gr06_b1              (g_gr06_b1),
     .m_odd_even             (m_odd_even),
     .m_chain4               (m_chain4),
     .m_sr02_b               (m_sr02_b),
    
     .val_mrdwr_addr         (val_mrdwr_addr),
     .fin_plane_sel          (fin_plane_sel),
     .en_cy1                 (en_cy1),
     .en_cy2                 (en_cy2),
     .en_cy3                 (en_cy3),
     .en_cy4                 (en_cy4),
     .sftw_h_mem_dbus        (sftw_h_mem_dbus),
     .odd_8bit               (odd_8bit)
     );

  grap_reg_dec GREGD 
    (
     .h_reset_n              (h_reset_n),
     .h_iord                 (h_iord),
     .h_iowr                 (h_iowr),
     .h_io_16                (h_io_16),
     .h_dec_3cx              (h_dec_3cx),
     .h_io_addr              (h_io_addr),
     .h_io_dbus              (h_io_dbus[15:8]),
     .h_hclk                 (t_mem_clk),
     .c_misc_b0              (c_misc_b0),
     
     .c_gr_ext_en            (c_gr_ext_en),
     .c_ext_index            (c_ext_index),
     
     .g_t_ctl_bit            (g_t_ctl_bit),
     .gr5_b0                 (gr5_b0),
     .gr5_b1                 (gr5_b1),
     .read_mode_0            (read_mode_0),
     .read_mode_1            (read_mode_1),
     .g_gr05_b4              (g_gr05_b4),
     .g_gr05_b5              (g_gr05_b5),
     .g_gr05_b6              (g_gr05_b6),
     .gr4_b0                 (gr4_b0),
     .gr4_b1                 (gr4_b1),
     
     .g_gr06_b0              (g_gr06_b0),
     .g_gr06_b1              (g_gr06_b1),
     .gr6_b2                 (gr6_b2),
     .gr6_b3                 (gr6_b3),
     
     .reg_gr0_qout           (reg_gr0_qout),
     .reg_gr1_qout           (reg_gr1_qout),
     .reg_gr2_qout           (reg_gr2_qout),
     .reg_gr3_qout           (reg_gr3_qout),
     
     .reg_gr7_qout           (reg_gr7_qout),
     .reg_gr8_qout           (reg_gr8_qout),
     .g_ready_n              (g_ready_n),
     .gra_mod_rd_en          (gra_mod_rd_en),
     
     .g_reg_gr0              (g_reg_gr0),
     .g_reg_gr1              (g_reg_gr1),
     .g_reg_gr2              (g_reg_gr2),
     .g_reg_gr3              (g_reg_gr3),
     .g_reg_gr4              (g_reg_gr4),
     .g_reg_gr5              (g_reg_gr5),
     .g_reg_gr6              (g_reg_gr6),
     .g_reg_gr7              (g_reg_gr7),
     .g_reg_gr8              (g_reg_gr8)
     );

  grap_data_wr GDWR 
    (
     .sftw_h_mem_dbus        (sftw_h_mem_dbus),
     .g_memrd                (g_memrd), 
     .m_sr04_b3              (m_sr04_b3),  
     .reg_gr0_qout           (reg_gr0_qout),
     .reg_gr1_qout           (reg_gr1_qout),
     .gr5_b0                 (gr5_b0),    
     .gr5_b1                 (gr5_b1),    
     .m_odd_even             (m_odd_even),
     .reg_gr3_qout           (reg_gr3_qout),
     .reg_gr8_qout           (reg_gr8_qout),
     .cpu_lat_data           (cpu_lat_data),
     .g_graph_data_out       (g_graph_data_out)
     );
  
  grap_data_rd GDRD 
    (
     .m2s1_q                 (m2s1_q),
     .m2s2_q                 (m2s2_q),
     .cycle2                 (cycle2),
     .h_byte_en_n            (h_byte_en_n[3:0]),
     .cur_cpurd_done         (cur_cpurd_done),
     .m_memrd_ready_n        (m_memrd_ready_n),
     .odd_8bit               (odd_8bit),
     .h_hrd_hwr_n            (h_hrd_hwr_n),
     .h_mem_io_n             (h_mem_io_n),
     .g_mem_ready_n          (g_mem_ready_n),
     .hreset_n               (h_reset_n),
     .mem_clk                (mem_clk),
     .m_sr04_b3              (m_sr04_b3),   
     .m_odd_even             (m_odd_even),
     .val_mrdwr_addr         (val_mrdwr_addr[1:0]),
     .gr4_b1                 (gr4_b1),
     .gr4_b0                 (gr4_b0),
     .reg_gr2_qout           (reg_gr2_qout),
     .reg_gr7_qout           (reg_gr7_qout),
     .read_mode_1            (read_mode_1),
     .read_mode_0            (read_mode_0),
     .m_ready_n              (m_ready_n),
     .g_graph_data_in        (g_graph_data_in),
     .cpu_lat_data           (cpu_lat_data),
     .h2mem_bout             (h2mem_bout),
     .g_int_crt22_data       (g_int_crt22_data),
     .rd_en_0                (rd_en_0),
     .rd_en_1                (rd_en_1)
     );

  read_data RDD
    (
     .h_byte_en_n            (h_byte_en_n),
     .rd_en_0                (rd_en_0),
     .rd_en_1                (rd_en_1),
     .en_cy1_ff              (en_cy1_ff),
     .en_cy2_ff              (en_cy2_ff),
     .en_cy3_ff              (en_cy3_ff),
     .en_cy4_ff              (en_cy4_ff),
     .mem_read               (mem_read),
     .mem_clk                (mem_clk),
     .hreset_n               (h_reset_n),
    
     .m_odd_even             (m_odd_even),
     .h2mem_bout             (h2mem_bout),
     .h_mem_dbus_in          (h_mem_dbus_in),
     .cycle2                 (cycle2),
     .m2s1_q                 (m2s1_q),
     .m2s2_q                 (m2s2_q)
     );

endmodule



