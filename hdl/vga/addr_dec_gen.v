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
//  Title       :  address decode generation and data bus steering.
//  File        :  addr_dec_gen.v
//  Author      :  Frank Bruno
//  Created     :  29-DEC-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//                      Address decode generation, data bus steering and
//    	       	     	data bus buffering are done in this module. Data
//    	       	     	steering is done as follows.
//
//    	       	     	1. If it is a IO 8-bit write cycle to odd address
//    	       	     	then t_hdata[15:8] (data coming from host) is 
//    	       	     	steered to h_io_dbus[7:0]( the bus that is connected
//    	       	     	to crtc, attr, graphics and memory controller.
//
//    	       	     	2. If it is a IO 8-bit read cycle to odd address
//    	       	     	then h_io_dbus[15:8] (data coming from modules) is 
//    	       	     	steered to t_hdata[7:0]( Data into host).
//
//    	       	     	vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//    	       	       	-------------------------------------------
//    	       	     	ONLY 16 or 8 BIT IO OPERATIONS ARE ALLOWED.
//    	       	       	-------------------------------------------
//    	       	     	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
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

`timescale 1 ns / 10 ps
module addr_dec_gen
  (
   input              h_hclk,
   input              wrbus_io_cycle,	   
   input 	      mem_mod_rd_en_hb,
   input 	      mem_mod_rd_en_lb,
   input 	      crt_mod_rd_en_hb,
   input 	      crt_mod_rd_en_lb,
   input 	      attr_mod_rd_en_hb,
   input 	      attr_mod_rd_en_lb,   
   input 	      gra_mod_rd_en,
   input [22:0]       t_haddr,	 
   input 	      t_svga_sel,         // Valid address in Mem or IO space
   input [3:0] 	      t_byte_en_n,
   input 	      t_mem_io_n,
   input 	      t_hrd_hwr_n,        // 1 - read, 0 - write
   input 	      io_cycle,
   input 	      t_hreset_n,
   input 	      h_iord,
   input 	      g_lt_hwr_cmd,       // latch the data int_mem_dbus_st1_lt
   input [31:0]       t_hdata_in,
   input [31:0]       h_mem_dbus_in,
   input [7:0] 	      a_reg_ar10,
   input [7:0] 	      a_reg_ar11,
   input [7:0] 	      a_reg_ar12,
   input [7:0] 	      a_reg_ar13,
   input [7:0] 	      a_reg_ar14,
   input [5:0] 	      a_dport_out,
   input [7:0] 	      a_attr_index,
   input [7:0] 	      a_cr24_26_dbus,
   input [7:0] 	      c_reg_ht,           // Horizontal total
   input [7:0] 	      c_reg_hde,          // Horizontal Display End
   input [7:0] 	      c_reg_hbs,          // Horizontal Blanking Start
   input [7:0] 	      c_reg_hbe,          // Horizontal Blanking End
   input [7:0] 	      c_reg_hss,          // Horizontal Sync Start
   input [7:0] 	      c_reg_hse,          // Horizontal Sync End
   input [7:0] 	      c_reg_cr06,
   input [7:0] 	      c_reg_cr07,
   input [7:0] 	      c_reg_cr10,
   input [7:0] 	      c_reg_cr11,
   input [7:0] 	      c_reg_cr12,
   input [7:0] 	      c_reg_cr15,
   input [7:0] 	      c_reg_cr16,
   input [7:0]        c_reg_cr18,
   input [7:0] 	      c_crtc_index,       // crtc index register
   input [7:0] 	      c_ext_index,        // extension index register
   input [7:0] 	      c_reg_ins0,
   input [7:0] 	      c_reg_ins1,
   input [7:0] 	      c_reg_fcr,   
   input [7:0] 	      c_reg_cr17,
   input [7:0] 	      c_reg_cr08,
   input [7:0] 	      c_reg_cr09,
   input [7:0] 	      c_reg_cr0a,   
   input [7:0] 	      c_reg_cr0b,
   input [7:0] 	      c_reg_cr14,
   input [7:0] 	      c_reg_misc,
   input [7:0] 	      g_int_crt22_data,
   input [7:0] 	      m_index_qout,
   input [7:0] 	      m_reg_sr0_qout,
   input [7:0] 	      m_reg_sr1_qout,
   input [7:0] 	      m_reg_sr2_qout,
   input [7:0] 	      m_reg_sr3_qout,
   input [7:0] 	      m_reg_sr4_qout,
   input [7:0] 	      m_reg_cr0c_qout,
   input [7:0] 	      m_reg_cr0d_qout,
   input [7:0] 	      m_reg_cr0e_qout,
   input [7:0] 	      m_reg_cr0f_qout,
   input [7:0] 	      m_reg_cr13_qout,
   input [7:0] 	      g_reg_gr0,
   input [7:0] 	      g_reg_gr1,
   input [7:0] 	      g_reg_gr2,
   input [7:0] 	      g_reg_gr3,
   input [7:0] 	      g_reg_gr4,
   input [7:0] 	      g_reg_gr5,
   input [7:0] 	      g_reg_gr6,
   input [7:0] 	      g_reg_gr7,
   input [7:0] 	      g_reg_gr8,
   
   output [15:0]      h_io_dbus,
   output reg [31:0]  t_hdata_out,
   output [31:0]      h_mem_dbus_out,
   output [15:0]      h_io_addr,            
   output [3:0]       h_byte_en_n,
   output [22:0]      h_mem_addr,
   output reg	      h_io_16,          // the current IO cycle is 16-bit
   output reg	      h_io_8,           // the current IO cycle is 8-bit
   output 	      h_dec_3bx,        // IO decode of address range 03bx
   output 	      h_dec_3cx,        // IO decode of address range 03cx
   output 	      h_dec_3dx,        // IO decode of address range 03dx
   output 	      h_hrd_hwr_n,
   output 	      h_mem_io_n
   );

  reg [22:0] 	      reg_h_addr_st1_lt;
  reg [22:0] 	      reg_h_addr_st2_lt;
  reg [22:0] 	      int_h_addr_st1_lt;
  reg [22:0] 	      int_h_addr_st2_lt;
  reg [15:0] 	      final_iord_data_lt;     
  reg [31:0] 	      reg_mem_dbus_st1_lt;
  reg [31:0] 	      reg_mem_dbus_st2_lt;   
  reg [31:0] 	      int_mem_dbus_st1_lt;
  reg [31:0] 	      int_mem_dbus_st2_lt;   
  reg 		      h_io_32;
  reg 		      h_io_24;
  reg [3:0] 	      int_byte_en_n_st1_lt;
  reg [3:0] 	      int_byte_en_n_st2_lt;
  reg 		      int_hrd_hwr_n_st1_lt;
  reg 		      int_hrd_hwr_n_st2_lt;
  reg 		      int_mem_io_n_st1_lt;
  reg 		      int_mem_io_n_st2_lt;
  reg [3:0] 	      reg_byte_en_n_st1_lt;
  reg [3:0] 	      reg_byte_en_n_st2_lt;
  reg 		      reg_hrd_hwr_n_st1_lt;
  reg 		      reg_hrd_hwr_n_st2_lt;
  reg 		      reg_mem_io_n_st1_lt;
  reg 		      reg_mem_io_n_st2_lt;
  
  wire 		      mem_to_host_ctl;
  wire 		      io_wr_ctl;
  wire 		      final_rd_ctl;
  wire 		      wr_en0;
  wire 		      wr_en1;
  wire 		      wr_en2;
  wire 		      wr_en3;
  wire 		      rd_en0;
  wire 		      rd_en1;
  wire 		      rd_en2;
  wire 		      rd_en3;
  wire 		      io_rd_ctl;
  wire 		      io_write_cycle;
  wire 		      addr_sel;

  // Latching address & data coming from host using
  // t_svga_sel ctl. signal
  always @(posedge h_hclk or negedge t_hreset_n)
    if (~t_hreset_n) begin
      reg_h_addr_st1_lt    <= 23'b0;
      reg_mem_dbus_st1_lt  <= 32'b0;
      reg_byte_en_n_st1_lt <= 4'b0;
      reg_hrd_hwr_n_st1_lt <= 1'b0;
      reg_mem_io_n_st1_lt  <= 1'b0;
    end else if (t_svga_sel) begin
      reg_h_addr_st1_lt    <= t_haddr;
      reg_mem_dbus_st1_lt  <= t_hdata_in;
      reg_byte_en_n_st1_lt <= t_byte_en_n;
      reg_hrd_hwr_n_st1_lt <= t_hrd_hwr_n;
      reg_mem_io_n_st1_lt  <= t_mem_io_n;
    end

  always @* 
    if (t_svga_sel) begin
      int_h_addr_st1_lt    = t_haddr;
      int_mem_dbus_st1_lt  = t_hdata_in;
      int_byte_en_n_st1_lt = t_byte_en_n;
      int_hrd_hwr_n_st1_lt = t_hrd_hwr_n;
      int_mem_io_n_st1_lt  = t_mem_io_n;
    end else begin
      int_h_addr_st1_lt    = reg_h_addr_st1_lt;
      int_mem_dbus_st1_lt  = reg_mem_dbus_st1_lt;
      int_byte_en_n_st1_lt = reg_byte_en_n_st1_lt;
      int_hrd_hwr_n_st1_lt = reg_hrd_hwr_n_st1_lt;
      int_mem_io_n_st1_lt  = reg_mem_io_n_st1_lt;
    end
  
  // passing int_mem_dbus_st1_lt data through another level of latch
  always @(posedge h_hclk or negedge t_hreset_n)
    if (~t_hreset_n) begin
      reg_mem_dbus_st2_lt  <= 32'b0;
      reg_h_addr_st2_lt    <= 23'b0;
      reg_byte_en_n_st2_lt <= 4'b0;
      reg_hrd_hwr_n_st2_lt <= 1'b0;
      reg_mem_io_n_st2_lt  <= 1'b0;
    end else if(g_lt_hwr_cmd) begin
      reg_mem_dbus_st2_lt   <= int_mem_dbus_st1_lt;
      reg_h_addr_st2_lt     <= int_h_addr_st1_lt;
      reg_byte_en_n_st2_lt  <= int_byte_en_n_st1_lt;
      reg_hrd_hwr_n_st2_lt  <= int_hrd_hwr_n_st1_lt;
      reg_mem_io_n_st2_lt   <= int_mem_io_n_st1_lt;
    end

  always @*
    if (g_lt_hwr_cmd) begin
      int_mem_dbus_st2_lt   = int_mem_dbus_st1_lt;
      int_h_addr_st2_lt     = int_h_addr_st1_lt;
      int_byte_en_n_st2_lt  = int_byte_en_n_st1_lt;
      int_hrd_hwr_n_st2_lt  = int_hrd_hwr_n_st1_lt;
      int_mem_io_n_st2_lt   = int_mem_io_n_st1_lt;
    end else begin
      int_mem_dbus_st2_lt   = reg_mem_dbus_st2_lt;
      int_h_addr_st2_lt     = reg_h_addr_st2_lt;
      int_byte_en_n_st2_lt  = reg_byte_en_n_st2_lt;
      int_hrd_hwr_n_st2_lt  = reg_hrd_hwr_n_st2_lt;
      int_mem_io_n_st2_lt   = reg_mem_io_n_st2_lt;
    end
  
  assign h_byte_en_n = int_byte_en_n_st2_lt;
  assign h_hrd_hwr_n = int_hrd_hwr_n_st2_lt;
  assign h_mem_io_n  = int_mem_io_n_st2_lt;
	 
  assign h_mem_dbus_out = int_mem_dbus_st2_lt;
   
  assign h_io_addr = int_h_addr_st1_lt[15:0];
  assign h_dec_3bx = (int_h_addr_st1_lt[15:4] == 12'h03b);
  assign h_dec_3cx = (int_h_addr_st1_lt[15:4] == 12'h03c);
  assign h_dec_3dx = (int_h_addr_st1_lt[15:4] == 12'h03d);      
  
  assign h_mem_addr = int_h_addr_st2_lt;

  // Computing the byte size
   always @* begin
     h_io_32 = 1'b0;
     h_io_24 = 1'b0;
     h_io_16 = 1'b0;
     h_io_8  = 1'b0;

     case(t_byte_en_n)
       4'b0000: h_io_32 = 1'b1; // NOT SUPPORTED
       4'b0001: h_io_24 = 1'b1; // NOT SUPPORTED
       4'b0010: h_io_24 = 1'b1; // NOT SUPPORTED
       4'b0011: h_io_16 = 1'b1; 
       4'b0100: h_io_24 = 1'b1; // NOT SUPPORTED
       4'b0101: h_io_16 = 1'b1; // NOT SUPPORTED
       4'b0110: h_io_16 = 1'b1; // NOT SUPPORTED
       4'b0111: h_io_8  = 1'b1;
       4'b1000: h_io_24 = 1'b1; // NOT SUPPORTED
       4'b1001: h_io_16 = 1'b1; // NOT SUPPORTED
       4'b1010: h_io_16 = 1'b1; // NOT SUPPORTED
       4'b1011: h_io_8  = 1'b1; 
       4'b1100: h_io_16 = 1'b1;
       4'b1101: h_io_8  = 1'b1;
       4'b1110: h_io_8  = 1'b1;
       default: begin // stop linter
	 h_io_32 = 1'b0;
	 h_io_24 = 1'b0;
	 h_io_16 = 1'b0;
	 h_io_8  = 1'b0;
       end
     endcase
   end
  
  assign io_write_cycle  = (~t_hrd_hwr_n) &(~t_mem_io_n);
  assign mem_to_host_ctl = t_hrd_hwr_n     & t_mem_io_n;
  assign io_rd_ctl       = t_hrd_hwr_n     & io_cycle;
  assign io_wr_ctl       = (~t_hrd_hwr_n)  & wrbus_io_cycle;
  assign final_rd_ctl    = t_hrd_hwr_n & (~t_mem_io_n);   

  assign wr_en0 = (~t_byte_en_n[0]) & io_wr_ctl;
  assign wr_en1 = (~t_byte_en_n[1]) & io_wr_ctl;
  assign wr_en2 = (~t_byte_en_n[2]) & io_wr_ctl;
  assign wr_en3 = (~t_byte_en_n[3]) & io_wr_ctl;
  
  assign rd_en0 = (~t_byte_en_n[0]) & final_rd_ctl;
  assign rd_en1 = (~t_byte_en_n[1]) & final_rd_ctl;
  assign rd_en2 = (~t_byte_en_n[2]) & final_rd_ctl;
  assign rd_en3 = (~t_byte_en_n[3]) & final_rd_ctl;
  
  // Capture data from the VGA registers
  assign addr_sel = c_reg_misc[0]; // Select Mono (== 0) or color (== 1)

  always @(posedge h_hclk or negedge t_hreset_n)
    if (~t_hreset_n)  final_iord_data_lt <= 16'b0;
    else if (h_iord) begin
      casex (int_h_addr_st1_lt[15:0])
	// Mono CRT Index 
	16'h03b4: begin
	  if (~addr_sel) begin
	    final_iord_data_lt[7:0] <= c_crtc_index;
	    if (h_io_16) begin
	      // In 16 bit mode we can write 3b5 if the root address is 3b4
	      case (c_crtc_index[5:0])
		6'h0:  final_iord_data_lt[15:8] <= c_reg_ht;
		6'h1:  final_iord_data_lt[15:8] <= c_reg_hde;
		6'h2:  final_iord_data_lt[15:8] <= c_reg_hbs;
		6'h3:  final_iord_data_lt[15:8] <= c_reg_hbe;
		6'h4:  final_iord_data_lt[15:8] <= c_reg_hss;
		6'h5:  final_iord_data_lt[15:8] <= c_reg_hse;
		6'h6:  final_iord_data_lt[15:8] <= c_reg_cr06;
		6'h7:  final_iord_data_lt[15:8] <= c_reg_cr07;
		6'h8:  final_iord_data_lt[15:8] <= c_reg_cr08;
		6'h9:  final_iord_data_lt[15:8] <= c_reg_cr09;
		6'ha:  final_iord_data_lt[15:8] <= c_reg_cr0a;
		6'hb:  final_iord_data_lt[15:8] <= c_reg_cr0b;
		6'hc:  final_iord_data_lt[15:8] <= m_reg_cr0c_qout;
		6'hd:  final_iord_data_lt[15:8] <= m_reg_cr0d_qout;
		6'he:  final_iord_data_lt[15:8] <= m_reg_cr0e_qout;
		6'hf:  final_iord_data_lt[15:8] <= m_reg_cr0f_qout;
		6'h10: final_iord_data_lt[15:8] <= c_reg_cr10;
		// Compatible read: Must enable to read back in VGA mode
		6'h11: 
		  if (c_reg_hbe[7]) final_iord_data_lt[15:8] <= c_reg_cr11;
		  else            final_iord_data_lt[15:8] <= 8'h0;
		6'h12: final_iord_data_lt[15:8] <= c_reg_cr12;
		6'h13: final_iord_data_lt[15:8] <= m_reg_cr13_qout;
		6'h14: final_iord_data_lt[15:8] <= c_reg_cr14;
		6'h15: final_iord_data_lt[15:8] <= c_reg_cr15;
		6'h16: final_iord_data_lt[15:8] <= c_reg_cr16;
		6'h17: final_iord_data_lt[15:8] <= c_reg_cr17;
		6'h18: final_iord_data_lt[15:8] <= c_reg_cr18;
		6'h22: final_iord_data_lt[15:8] <= g_int_crt22_data;
		6'h24: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
		6'h26: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
		default: final_iord_data_lt[15:8] <= 8'h0;
	      endcase // case(crtc_index)
	    end
	  end else final_iord_data_lt[15:0] <= 16'h0;
	end
	// Mono CRT Data
	16'h03b5: begin
	  if (~addr_sel) begin
	    case (c_crtc_index[5:0])
	      6'h0:  final_iord_data_lt[15:8] <= c_reg_ht;
	      6'h1:  final_iord_data_lt[15:8] <= c_reg_hde;
	      6'h2:  final_iord_data_lt[15:8] <= c_reg_hbs;
	      6'h3:  final_iord_data_lt[15:8] <= c_reg_hbe;
	      6'h4:  final_iord_data_lt[15:8] <= c_reg_hss;
	      6'h5:  final_iord_data_lt[15:8] <= c_reg_hse;
	      6'h6:  final_iord_data_lt[15:8] <= c_reg_cr06;
	      6'h7:  final_iord_data_lt[15:8] <= c_reg_cr07;
	      6'h8:  final_iord_data_lt[15:8] <= c_reg_cr08;
	      6'h9:  final_iord_data_lt[15:8] <= c_reg_cr09;
	      6'ha:  final_iord_data_lt[15:8] <= c_reg_cr0a;
	      6'hb:  final_iord_data_lt[15:8] <= c_reg_cr0b;
	      6'hc:  final_iord_data_lt[15:8] <= m_reg_cr0c_qout;
	      6'hd:  final_iord_data_lt[15:8] <= m_reg_cr0d_qout;
	      6'he:  final_iord_data_lt[15:8] <= m_reg_cr0e_qout;
	      6'hf:  final_iord_data_lt[15:8] <= m_reg_cr0f_qout;
	      6'h10: final_iord_data_lt[15:8] <= c_reg_cr10;
	      // Compatible read: Must enable to read back in VGA mode
	      6'h11: 
		if (c_reg_hbe[7]) final_iord_data_lt[15:8] <= c_reg_cr11;
		else            final_iord_data_lt[15:8] <= 8'h0;
	      6'h12: final_iord_data_lt[15:8] <= c_reg_cr12;
	      6'h13: final_iord_data_lt[15:8] <= m_reg_cr13_qout;
	      6'h14: final_iord_data_lt[15:8] <= c_reg_cr14;
	      6'h15: final_iord_data_lt[15:8] <= c_reg_cr15;
	      6'h16: final_iord_data_lt[15:8] <= c_reg_cr16;
	      6'h17: final_iord_data_lt[15:8] <= c_reg_cr17;
	      6'h18: final_iord_data_lt[15:8] <= c_reg_cr18;
	      6'h22: final_iord_data_lt[15:8] <= g_int_crt22_data;
	      6'h24: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
	      6'h26: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
	      default: final_iord_data_lt[15:8] <= 8'h0;
	    endcase // case(crtc_index)
	  end else final_iord_data_lt[15:8] <= 8'h0;
	end

	16'h03ba: begin
	  if (~addr_sel) final_iord_data_lt[7:0] <= c_reg_ins1;
	  else           final_iord_data_lt[7:0] <= 8'h0;
	end

	16'h03c0: begin
	  final_iord_data_lt[7:0] <= a_attr_index;
	  if (h_io_16)
	    case (a_attr_index[4:0])
	      5'd16: final_iord_data_lt[15:8] <= a_reg_ar10;
	      5'd17: final_iord_data_lt[15:8] <= a_reg_ar11;
	      5'd18: final_iord_data_lt[15:8] <= a_reg_ar12;
	      5'd19: final_iord_data_lt[15:8] <= a_reg_ar13;
	      5'd20: final_iord_data_lt[15:8] <= a_reg_ar14;
	      default: final_iord_data_lt[15:8] <= {2'b0, a_dport_out};
	    endcase // case(a_attr_index)
	end

	16'h03c1: begin
	  case (a_attr_index[4:0])
	    5'd16: final_iord_data_lt[15:8] <= a_reg_ar10;
	    5'd17: final_iord_data_lt[15:8] <= a_reg_ar11;
	    5'd18: final_iord_data_lt[15:8] <= a_reg_ar12;
	    5'd19: final_iord_data_lt[15:8] <= a_reg_ar13;
	    5'd20: final_iord_data_lt[15:8] <= a_reg_ar14;
	    default: final_iord_data_lt[15:8] <= {2'b0, a_dport_out};
	  endcase // case(a_attr_index)
	end
	16'h03c2: final_iord_data_lt[7:0] <= c_reg_ins0;

	// Memory Index
	16'h03c4: begin
	  final_iord_data_lt[7:0] <= m_index_qout;
	  if (h_io_16) begin
	    case (m_index_qout)
	      8'd0: final_iord_data_lt[15:8] <= m_reg_sr0_qout;
	      8'd1: final_iord_data_lt[15:8] <= m_reg_sr1_qout;
	      8'd2: final_iord_data_lt[15:8] <= m_reg_sr2_qout;
	      8'd3: final_iord_data_lt[15:8] <= m_reg_sr3_qout;
	      8'd4: final_iord_data_lt[15:8] <= m_reg_sr4_qout;
	      default: final_iord_data_lt[15:8] <= 8'h0;
	    endcase // case(m_index_qout)
	  end
	end

	// Memory Data
	16'h03c5: begin
	  case (m_index_qout)
	    8'd0: final_iord_data_lt[15:8] <= m_reg_sr0_qout;
	    8'd1: final_iord_data_lt[15:8] <= m_reg_sr1_qout;
	    8'd2: final_iord_data_lt[15:8] <= m_reg_sr2_qout;
	    8'd3: final_iord_data_lt[15:8] <= m_reg_sr3_qout;
	    8'd4: final_iord_data_lt[15:8] <= m_reg_sr4_qout;
	    default: final_iord_data_lt[15:8] <= 8'h0;
	  endcase // case(m_index_qout)
	end
	
	16'h03cc: final_iord_data_lt[7:0] <= c_reg_misc;
	
	16'h03ca: final_iord_data_lt[7:0] <= c_reg_fcr;
	
	// Extension Index
	16'h03ce: begin
	  final_iord_data_lt[7:0] <= c_ext_index;
	  if (h_io_16) begin
	    case (c_ext_index[3:0])
	      4'h0: final_iord_data_lt[15:8] <= g_reg_gr0;
	      4'h1: final_iord_data_lt[15:8] <= g_reg_gr1;
	      4'h2: final_iord_data_lt[15:8] <= g_reg_gr2;
	      4'h3: final_iord_data_lt[15:8] <= g_reg_gr3;
	      4'h4: final_iord_data_lt[15:8] <= g_reg_gr4;
	      4'h5: final_iord_data_lt[15:8] <= g_reg_gr5;
	      4'h6: final_iord_data_lt[15:8] <= g_reg_gr6;
	      4'h7: final_iord_data_lt[15:8] <= g_reg_gr7;
	      4'h8: final_iord_data_lt[15:8] <= g_reg_gr8;
	      default: final_iord_data_lt[15:8] <= 8'h0;
	    endcase
	  end
	end
	
	// Extension Data
	16'h03cf: begin
	  case (c_ext_index[3:0])
	    4'h0: final_iord_data_lt[15:8] <= g_reg_gr0;
	    4'h1: final_iord_data_lt[15:8] <= g_reg_gr1;
	    4'h2: final_iord_data_lt[15:8] <= g_reg_gr2;
	    4'h3: final_iord_data_lt[15:8] <= g_reg_gr3;
	    4'h4: final_iord_data_lt[15:8] <= g_reg_gr4;
	    4'h5: final_iord_data_lt[15:8] <= g_reg_gr5;
	    4'h6: final_iord_data_lt[15:8] <= g_reg_gr6;
	    4'h7: final_iord_data_lt[15:8] <= g_reg_gr7;
	    4'h8: final_iord_data_lt[15:8] <= g_reg_gr8;
	    default: final_iord_data_lt[15:8] <= 8'h0;
	  endcase
	end
	
	// Color CRT Index 
	16'h03d4: begin
	  if (addr_sel) begin
	    final_iord_data_lt[7:0] <= c_crtc_index;
	    if (h_io_16) begin
	      // In 16 bit mode we can write 3d5 if the root address is 3d4
	      case (c_crtc_index[5:0])
		6'h0:  final_iord_data_lt[15:8] <= c_reg_ht;
		6'h1:  final_iord_data_lt[15:8] <= c_reg_hde;
		6'h2:  final_iord_data_lt[15:8] <= c_reg_hbs;
		6'h3:  final_iord_data_lt[15:8] <= c_reg_hbe;
		6'h4:  final_iord_data_lt[15:8] <= c_reg_hss;
		6'h5:  final_iord_data_lt[15:8] <= c_reg_hse;
		6'h6:  final_iord_data_lt[15:8] <= c_reg_cr06;
		6'h7:  final_iord_data_lt[15:8] <= c_reg_cr07;
		6'h8:  final_iord_data_lt[15:8] <= c_reg_cr08;
		6'h9:  final_iord_data_lt[15:8] <= c_reg_cr09;
		6'ha:  final_iord_data_lt[15:8] <= c_reg_cr0a;
		6'hb:  final_iord_data_lt[15:8] <= c_reg_cr0b;
		6'hc:  final_iord_data_lt[15:8] <= m_reg_cr0c_qout;
		6'hd:  final_iord_data_lt[15:8] <= m_reg_cr0d_qout;
		6'he:  final_iord_data_lt[15:8] <= m_reg_cr0e_qout;
		6'hf:  final_iord_data_lt[15:8] <= m_reg_cr0f_qout;
		6'h10: final_iord_data_lt[15:8] <= c_reg_cr10;
		// Compatible read: Must enable to read back in VGA mode
		6'h11: 
		  if (c_reg_hbe[7]) final_iord_data_lt[15:8] <= c_reg_cr11;
		  else            final_iord_data_lt[15:8] <= 8'h0;
		6'h12: final_iord_data_lt[15:8] <= c_reg_cr12;
		6'h13: final_iord_data_lt[15:8] <= m_reg_cr13_qout;
		6'h14: final_iord_data_lt[15:8] <= c_reg_cr14;
		6'h15: final_iord_data_lt[15:8] <= c_reg_cr15;
		6'h16: final_iord_data_lt[15:8] <= c_reg_cr16;
		6'h17: final_iord_data_lt[15:8] <= c_reg_cr17;
		6'h18: final_iord_data_lt[15:8] <= c_reg_cr18;	
		6'h22: final_iord_data_lt[15:8] <= g_int_crt22_data;
		6'h24: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
		6'h26: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
		default: final_iord_data_lt[15:8] <= 8'h0;
	      endcase // case(crtc_index)
	    end
	  end else final_iord_data_lt[15:0] <= 16'h0;
	end
	// Color CRT Data
	16'h03d5: begin
	  if (addr_sel) begin
	    case (c_crtc_index[5:0])
	      6'h0:  final_iord_data_lt[15:8] <= c_reg_ht;
	      6'h1:  final_iord_data_lt[15:8] <= c_reg_hde;
	      6'h2:  final_iord_data_lt[15:8] <= c_reg_hbs;
	      6'h3:  final_iord_data_lt[15:8] <= c_reg_hbe;
	      6'h4:  final_iord_data_lt[15:8] <= c_reg_hss;
	      6'h5:  final_iord_data_lt[15:8] <= c_reg_hse;
	      6'h6:  final_iord_data_lt[15:8] <= c_reg_cr06;
	      6'h7:  final_iord_data_lt[15:8] <= c_reg_cr07;
	      6'h8:  final_iord_data_lt[15:8] <= c_reg_cr08;
	      6'h9:  final_iord_data_lt[15:8] <= c_reg_cr09;
	      6'ha:  final_iord_data_lt[15:8] <= c_reg_cr0a;
	      6'hb:  final_iord_data_lt[15:8] <= c_reg_cr0b;
	      6'hc:  final_iord_data_lt[15:8] <= m_reg_cr0c_qout;
	      6'hd:  final_iord_data_lt[15:8] <= m_reg_cr0d_qout;
	      6'he:  final_iord_data_lt[15:8] <= m_reg_cr0e_qout;
	      6'hf:  final_iord_data_lt[15:8] <= m_reg_cr0f_qout;
	      6'h10: final_iord_data_lt[15:8] <= c_reg_cr10;
	      // Compatible read: Must enable to read back in VGA mode
	      6'h11: 
		if (c_reg_hbe[7]) final_iord_data_lt[15:8] <= c_reg_cr11;
		else            final_iord_data_lt[15:8] <= 8'h0;
	      6'h12: final_iord_data_lt[15:8] <= c_reg_cr12;
	      6'h13: final_iord_data_lt[15:8] <= m_reg_cr13_qout;
	      6'h14: final_iord_data_lt[15:8] <= c_reg_cr14;
	      6'h15: final_iord_data_lt[15:8] <= c_reg_cr15;
	      6'h16: final_iord_data_lt[15:8] <= c_reg_cr16;
	      6'h17: final_iord_data_lt[15:8] <= c_reg_cr17;
	      6'h18: final_iord_data_lt[15:8] <= c_reg_cr18;
	      6'h22: final_iord_data_lt[15:8] <= g_int_crt22_data;
	      6'h24: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
	      6'h26: final_iord_data_lt[15:8] <= a_cr24_26_dbus;
	      default: final_iord_data_lt[15:8] <= 8'h0;
	    endcase // case(crtc_index)
	  end else final_iord_data_lt[15:8] <= 8'h0;
	end

	16'h03da: begin
	  if (addr_sel) final_iord_data_lt[7:0] <= c_reg_ins1;
	  else          final_iord_data_lt[7:0] <= 8'h0;
	end

	default: final_iord_data_lt <= final_iord_data_lt; // stop linter
      endcase // casex(int_h_addr_st1_lt)
    end

  // Data out of the VGA
  always @*
    if (mem_to_host_ctl) t_hdata_out = h_mem_dbus_in;
    else begin
      t_hdata_out[7:0]   = (rd_en0) ? final_iord_data_lt[7:0]  : 8'hFF;
      t_hdata_out[15:8]  = (rd_en1) ? final_iord_data_lt[15:8] : 8'hFF;
      t_hdata_out[23:16] = (rd_en2) ? final_iord_data_lt[7:0]  : 8'hFF;
      t_hdata_out[31:24] = (rd_en3) ? final_iord_data_lt[15:8] : 8'hFF;
    end
  
  // Write data steering
  assign h_io_dbus[7:0]  = (wr_en0) ? t_hdata_in[7:0]   : 
			   (wr_en2) ? t_hdata_in[23:16] : 8'hFF;
  assign h_io_dbus[15:8] = (wr_en1) ? t_hdata_in[15:8]  : 
	                   (wr_en3) ? t_hdata_in[31:24] : 8'hFF;

endmodule
