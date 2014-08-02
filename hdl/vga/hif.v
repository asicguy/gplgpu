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
//  Title       :  Host Interface top level
//  File        :  hif.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module is the main interface to host.
//   It monitors the handshake protocol between host
//   and VGA host interfaces.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//    hif_sm
//    addr_dec_gen
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
module hif
  (
   input         mem_mod_rd_en_hb,
   input 	 mem_mod_rd_en_lb,
   input 	 crt_mod_rd_en_hb,
   input 	 crt_mod_rd_en_lb,
   input 	 attr_mod_rd_en_hb,
   input 	 attr_mod_rd_en_lb,
   input 	 gra_mod_rd_en,
   input [22:0]  t_haddr,           // 23 bit address lines from host
   input [3:0] 	 t_byte_en_n,       // Byte enable signals
   input 	 t_mem_io_n,        // memory or IO access. 1 - Mem, 0 - IO.
   input 	 t_hrd_hwr_n,       // read or write access. 1 -read, 0 - write
   input 	 t_hreset_n,        // reset signal coming from host
   input 	 t_mem_clk,         // memory clock
   input 	 t_svga_sel,        /* Valid address has been decoded in
				     * SVGA memory or IO space */
   input 	 a_ready_n,         // IO cycle to attribute module is done
   input 	 c_ready_n,         // IO cycle to crtc module is done
   input 	 g_ready_n,         // IO cycle to graphics module is done
   input 	 m_ready_n,         // IO cycle to memory module is done
   input 	 g_mem_ready_n,     // memory cycle to memory module is done
   input 	 m_cpurd_state1,
   input 	 g_cpult_state1,
   input 	 g_lt_hwr_cmd,
   input [31:0]  t_hdata_in,        // Tranfer data between Core and Host
   input [31:0]  h_mem_dbus_in,     // Memory Read/ Write operations

   // All Internal Registers from within the VGA to read back by the host
   input [7:0] 	 a_reg_ar10,
   input [7:0] 	 a_reg_ar11,
   input [7:0] 	 a_reg_ar12,
   input [7:0] 	 a_reg_ar13,
   input [7:0] 	 a_reg_ar14,
   input [5:0] 	 a_dport_out,
   input [7:0] 	 a_attr_index,
   input [7:0] 	 a_cr24_26_dbus,
   input [7:0] 	 c_reg_ht,          // Horizontal total
   input [7:0] 	 c_reg_hde,         // Horizontal Display End
   input [7:0] 	 c_reg_hbs,         // Horizontal Blanking Start
   input [7:0] 	 c_reg_hbe,         // Horizontal Blanking End
   input [7:0] 	 c_reg_hss,         // Horizontal Sync Start
   input [7:0] 	 c_reg_hse,         // Horizontal Sync End
   input [7:0] 	 c_reg_cr06,
   input [7:0] 	 c_reg_cr07,
   input [7:0] 	 c_reg_cr10,
   input [7:0] 	 c_reg_cr11,
   input [7:0] 	 c_reg_cr12,
   input [7:0] 	 c_reg_cr15,
   input [7:0] 	 c_reg_cr16,
   input [7:0] 	 c_reg_cr18,
   input [7:0] 	 c_crtc_index,      // crtc index register
   input [7:0] 	 c_ext_index,       // extension index register
   input [7:0] 	 c_reg_ins0,
   input [7:0] 	 c_reg_ins1,
   input [7:0] 	 c_reg_fcr,   
   input [7:0] 	 c_reg_cr17,
   input [7:0] 	 c_reg_cr08,
   input [7:0] 	 c_reg_cr09,
   input [7:0] 	 c_reg_cr0a,   
   input [7:0] 	 c_reg_cr0b,
   input [7:0] 	 c_reg_cr14,
   input [7:0] 	 c_reg_misc,
   input [7:0] 	 g_int_crt22_data,
   input [7:0] 	 m_index_qout,
   input [7:0] 	 m_reg_sr0_qout,
   input [7:0] 	 m_reg_sr1_qout,
   input [7:0] 	 m_reg_sr2_qout,
   input [7:0] 	 m_reg_sr3_qout,
   input [7:0] 	 m_reg_sr4_qout,
   input [7:0] 	 m_reg_cr0c_qout,
   input [7:0] 	 m_reg_cr0d_qout,
   input [7:0] 	 m_reg_cr0e_qout,
   input [7:0] 	 m_reg_cr0f_qout,
   input [7:0] 	 m_reg_cr13_qout,
   input [7:0] 	 g_reg_gr0,
   input [7:0] 	 g_reg_gr1,
   input [7:0] 	 g_reg_gr2,
   input [7:0] 	 g_reg_gr3,
   input [7:0] 	 g_reg_gr4,
   input [7:0] 	 g_reg_gr5,
   input [7:0] 	 g_reg_gr6,
   input [7:0] 	 g_reg_gr7,
   input [7:0] 	 g_reg_gr8,

   output [15:0] h_io_dbus,         // Output Bus from Host
   output [31:0] t_hdata_out,       // output pins used to transfer data
   output [31:0] h_mem_dbus_out,    // between VGA core and Host.
   output 	 h_hrd_hwr_n,
   output 	 h_mem_io_n,
   output 	 h_t_ready_n,	    /* Indicates that the VGA core has 
				     * completed the current cycle and is 
				     * ready for the next cycle */
   output [22:0] h_mem_addr, 	    // Lower 22 address bits for memory 
   output [15:0] h_io_addr,
   output 	 h_io_16,    	    // Indicates the current IO cycle is 16-bit
   output 	 h_io_8,     	    // Indicates the current IO cycle is 8-bit
   output 	 h_dec_3bx,  	    // IO group decode of address range 03bx
   output 	 h_dec_3cx,  	    // IO group decode of address range 03cx
   output 	 h_dec_3dx,  	    // IO group decode of address range 03dx
   output 	 h_iord,     	    // Indicates The current IO cycle is read
   output 	 h_iowr,     	    // Indicates The current IO cycle is write
   output 	 h_svga_sel, 	    /* Valid address has been decoded in
				     * VGA memory or IO space. */
   output [3:0]  h_byte_en_n
   );
  
  wire 		 host_cycle;
  wire 		 io_cycle;
  wire 		 dac_reg_dec;
  wire 		 wrbus_io_cycle;
  
  hif_sm  HSM
    (
     .h_reset_n         (t_hreset_n),
     .t_svga_sel        (t_svga_sel),
     .h_hclk            (t_mem_clk),
     .a_ready_n         (a_ready_n),
     .c_ready_n         (c_ready_n),
     .g_ready_n         (g_ready_n),
     .m_ready_n         (m_ready_n),
     .g_mem_ready_n     (g_mem_ready_n),
     .h_hrd_hwr_n       (h_hrd_hwr_n),
     .h_mem_io_n        (h_mem_io_n),
     .m_cpurd_state1    (m_cpurd_state1),
     .g_cpult_state1    (g_cpult_state1),
     .g_lt_hwr_cmd      (g_lt_hwr_cmd),
     
     .h_iord            (h_iord),
     .h_iowr            (h_iowr),
     .h_t_ready_n       (h_t_ready_n),
     .host_cycle        (host_cycle),
     .io_cycle          (io_cycle),
     .h_svga_sel        (h_svga_sel),
     .wrbus_io_cycle    (wrbus_io_cycle)
     );

  addr_dec_gen HAD
    (
     .h_hclk            (t_mem_clk),
     .wrbus_io_cycle    (wrbus_io_cycle),
     .mem_mod_rd_en_hb  (mem_mod_rd_en_hb),
     .mem_mod_rd_en_lb  (mem_mod_rd_en_lb),
     .crt_mod_rd_en_hb  (crt_mod_rd_en_hb),
     .crt_mod_rd_en_lb  (crt_mod_rd_en_lb),
     .attr_mod_rd_en_lb (attr_mod_rd_en_lb),
     .attr_mod_rd_en_hb (attr_mod_rd_en_hb),
     .gra_mod_rd_en     (gra_mod_rd_en),
     .t_haddr           (t_haddr),
     .t_svga_sel        (t_svga_sel),
     .t_byte_en_n       (t_byte_en_n),
     .t_mem_io_n        (t_mem_io_n),
     .t_hrd_hwr_n       (t_hrd_hwr_n),
     .io_cycle          (io_cycle),
     .t_hreset_n        (t_hreset_n),
     .h_iord            (h_iord),
     .g_lt_hwr_cmd      (g_lt_hwr_cmd),
     .t_hdata_in        (t_hdata_in),
     .h_mem_dbus_in     (h_mem_dbus_in),
     .a_reg_ar10        (a_reg_ar10),
     .a_reg_ar11        (a_reg_ar11),
     .a_reg_ar12        (a_reg_ar12),
     .a_reg_ar13        (a_reg_ar13),
     .a_reg_ar14        (a_reg_ar14),
     .a_dport_out       (a_dport_out),
     .a_attr_index      (a_attr_index),
     .a_cr24_26_dbus    (a_cr24_26_dbus),
     .c_reg_ht          (c_reg_ht),   // Horizontal total
     .c_reg_hde         (c_reg_hde),  //Horizontal Display End
     .c_reg_hbs         (c_reg_hbs),  //Horizontal Blanking Start
     .c_reg_hbe         (c_reg_hbe),  //Horizontal Blanking End
     .c_reg_hss         (c_reg_hss),  //Horizontal Sync Start
     .c_reg_hse         (c_reg_hse),  //Horizontal Sync End
     .c_reg_cr06        (c_reg_cr06),
     .c_reg_cr07        (c_reg_cr07),
     .c_reg_cr10        (c_reg_cr10),
     .c_reg_cr11        (c_reg_cr11),
     .c_reg_cr12        (c_reg_cr12),
     .c_reg_cr15        (c_reg_cr15),
     .c_reg_cr16        (c_reg_cr16),
     .c_reg_cr18        (c_reg_cr18),
     .c_crtc_index      (c_crtc_index),
     .c_ext_index       (c_ext_index),
     .c_reg_ins0        (c_reg_ins0),
     .c_reg_ins1        (c_reg_ins1),
     .c_reg_fcr         (c_reg_fcr),    
     .c_reg_cr17        (c_reg_cr17),
     .c_reg_cr08        (c_reg_cr08),
     .c_reg_cr09        (c_reg_cr09),
     .c_reg_cr0a        (c_reg_cr0a),    
     .c_reg_cr0b        (c_reg_cr0b),
     .c_reg_cr14        (c_reg_cr14),
     .g_int_crt22_data  (g_int_crt22_data),      
     .m_index_qout      (m_index_qout),
     .m_reg_sr0_qout    (m_reg_sr0_qout),
     .m_reg_sr1_qout    (m_reg_sr1_qout),
     .m_reg_sr2_qout    (m_reg_sr2_qout),
     .m_reg_sr3_qout    (m_reg_sr3_qout),
     .m_reg_sr4_qout    (m_reg_sr4_qout),
     .m_reg_cr0c_qout   (m_reg_cr0c_qout),
     .m_reg_cr0d_qout   (m_reg_cr0d_qout),
     .m_reg_cr0e_qout   (m_reg_cr0e_qout),
     .m_reg_cr0f_qout   (m_reg_cr0f_qout),
     .m_reg_cr13_qout   (m_reg_cr13_qout),
     .g_reg_gr0         (g_reg_gr0),
     .g_reg_gr1         (g_reg_gr1),
     .g_reg_gr2         (g_reg_gr2),
     .g_reg_gr3         (g_reg_gr3),
     .g_reg_gr4         (g_reg_gr4),
     .g_reg_gr5         (g_reg_gr5),
     .g_reg_gr6         (g_reg_gr6),
     .g_reg_gr7         (g_reg_gr7),
     .g_reg_gr8         (g_reg_gr8),
     .c_reg_misc        (c_reg_misc),
     
     .h_io_dbus         (h_io_dbus),
     .t_hdata_out       (t_hdata_out),	   
     .h_mem_dbus_out    (h_mem_dbus_out),
     .h_io_addr         (h_io_addr),
     .h_byte_en_n       (h_byte_en_n),
     .h_mem_addr        (h_mem_addr),
     .h_io_16           (h_io_16),
     .h_io_8            (h_io_8),
     .h_dec_3bx         (h_dec_3bx),
     .h_dec_3cx         (h_dec_3cx),
     .h_dec_3dx         (h_dec_3dx),
     .h_hrd_hwr_n       (h_hrd_hwr_n),
     .h_mem_io_n        (h_mem_io_n)
     );
  
endmodule
