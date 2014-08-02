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
//  Title       :  Memory Interface Registers
//  File        :  memif_reg_dec.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module consists of the io registers and its decodes.
//   The sequencer registers sr00 to sr04 and the crt register from 
//   cr0c to crof, cr13 and cr22 are assigned in this module.
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
module  memif_reg_dec
  (
   input [15:0]     h_io_dbus,	    
   input            h_reset_n,
   input            h_iord,
   input            h_iowr,
   input            h_io_16,
   input [15:0]     h_io_addr,
   input            h_hclk,
   input 	    color_mode,          // 1 = color, 0 = mono
   input [5:0] 	    c_crtc_index,        // Crt index
   input [7:0] 	    c_ext_index,         // Extension register index
   input            g_gr05_b4,
   
   output           m_ready_n,
   output           mem_mod_rd_en_hb,
   output           mem_mod_rd_en_lb,
   output           m_dec_sr00_sr06,
   output           m_dec_sr07,
   output [7:0]     memif_index_qout,
   output [7:0]     reg_sr0_qout,
   output [7:0]     reg_sr1_qout,
   output [7:0]     reg_sr2_qout,
   output [7:0]     reg_sr3_qout,
   output [7:0]     reg_sr4_qout,
   output reg [7:0] reg_cr0c_qout,
   output reg [7:0] reg_cr0d_qout,
   output reg [7:0] reg_cr0e_qout,
   output reg [7:0] reg_cr0f_qout,
   output reg [7:0] reg_cr13_qout,
   output           m_sr00_b0,
   output           m_sr00_b1,
   output           m_sr01_b1,
   output [3:0]     m_sr02_b,
   output           m_sr04_b3,
   output           m_chain4,
   output           m_extend_mem,
   output           m_odd_even,
   output           m_planar,
   output           m_sr01_b4,
   output           m_sr01_b3,
   output           m_sr01_b2,
   output           m_sr01_b0,
   output           m_sr01_b5,
   output           m_soft_rst_n,
   output           m_sr04_b1
   );
  
  //
  // 	 Define Variables
  //
  
  reg [2:0] 	   memif_index;
  reg 		   delay1_rdorwr;
  reg [1:0] 	   store_sr0;
  reg [5:0] 	   store_sr1;
  reg [3:0] 	   store_sr2;
  reg [5:0] 	   store_sr3;
  reg [2:0] 	   store_sr4;
  reg 		   h_iowr_dly;

  wire 		   seq_index_range;
  wire 		   seq_data_range;
  wire 		   m_sr04_b2;
  wire 		   h_io_rdwr1;
  wire 		   mem_mod_addr_hit;
  wire 		   real_seq_data_range;
  wire 		   seq_range;
  wire 		   seq_data_dec;
  wire 		   seq_addr_hit;
  wire 		   seq_range_0_6;
  wire 		   seq_range_7;
  wire 		   crtc_mod_data_en;
  wire 		   crt_index_hit;    // We hit the CRT index register
  wire 		   crt_reg_hit;      // We hit the CRT data register
  wire 		   c_cr0c_f13_22_hit; // We hit a CR reg in the memory block
  
  //
  // Generating the specific signals to come outside the block
  // This is done instead of allowing the whole block to come out.
  //
  assign          m_soft_rst_n = m_sr00_b0 & m_sr00_b1;
  assign          m_extend_mem = m_sr04_b1;
  assign          m_odd_even = ~m_sr04_b2 | g_gr05_b4;
  assign          m_chain4 = m_sr04_b3;
  assign          m_planar = ~(m_chain4 | m_odd_even);
  assign          m_sr00_b0 = reg_sr0_qout[0];
  assign          m_sr00_b1 = reg_sr0_qout[1];
  assign          m_sr01_b1 = reg_sr1_qout[1];
  assign          m_sr02_b  = reg_sr2_qout[3:0];  // define m_sr02_b as 3:0
  assign          m_sr04_b3 = reg_sr4_qout[3];
  assign          m_sr04_b2 = reg_sr4_qout[2];
  assign          m_sr04_b1 = reg_sr4_qout[1];
  assign          m_sr01_b4 = reg_sr1_qout[4];
  assign          m_sr01_b3 = reg_sr1_qout[3];
  assign          m_sr01_b2 = reg_sr1_qout[2];
  assign          m_sr01_b0 = reg_sr1_qout[0];
  assign          m_sr01_b5 = reg_sr1_qout[5];
  
  //
  // Infering sequencer index and extension index registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) 
      memif_index <= 3'b0;
    else if ((h_io_addr == 16'h03c4) && h_iowr)
      memif_index <= h_io_dbus[2:0];

  assign 	  memif_index_qout = {5'b0, memif_index};

  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) h_iowr_dly <= 1'b0;
    else            h_iowr_dly <= h_iowr;

  //
  //   Infering Sequencer Register (SR0 - SR4).
  //   Infering Extension  Register (CR0C - CR0F, CR13).
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      store_sr0     <= 2'b11;   // Set not reset
      store_sr1     <= 6'b0;
      store_sr2     <= 4'b0;
      store_sr3     <= 6'b0;
      store_sr4     <= 3'b0;
      reg_cr0c_qout <= 8'b0;
      reg_cr0d_qout <= 8'b0;
      reg_cr0e_qout <= 8'b0;
      reg_cr0f_qout <= 8'b0;
      reg_cr13_qout <= 8'b0;
    end else if (h_iowr & h_iowr_dly) begin
      case (h_io_addr)

	// Mono CRT Index 
	16'h03b4: begin
	  if (~color_mode & h_io_16) begin
	    case (c_crtc_index[5:0])
	      6'hc:  reg_cr0c_qout <= h_io_dbus[15:8];
	      6'hd:  reg_cr0d_qout <= h_io_dbus[15:8];
	      6'he:  reg_cr0e_qout <= h_io_dbus[15:8];
	      6'hf:  reg_cr0f_qout <= h_io_dbus[15:8];
	      6'h13: reg_cr13_qout <= h_io_dbus[15:8];
	    endcase // case(c_crtc_index[5:0])
	  end
	end
	
	// Mono CRT Data
	16'h03b5: begin
	  if (~color_mode) begin
	    case (c_crtc_index[5:0])
	      6'hc:  reg_cr0c_qout <= h_io_dbus[15:8];
	      6'hd:  reg_cr0d_qout <= h_io_dbus[15:8];
	      6'he:  reg_cr0e_qout <= h_io_dbus[15:8];
	      6'hf:  reg_cr0f_qout <= h_io_dbus[15:8];
	      6'h13: reg_cr13_qout <= h_io_dbus[15:8];
	    endcase // case(c_crtc_index[5:0])
	  end
	end
	
	// Memory Index
	16'h03c4: begin
	  if (h_io_16) begin
	    case (memif_index)
	      3'd0: store_sr0 <= h_io_dbus[9:8];
	      3'd1: store_sr1 <= {h_io_dbus[13:10], h_io_dbus[8]};
	      3'd2: store_sr2 <= h_io_dbus[11:8];
	      3'd3: store_sr3 <= h_io_dbus[13:8];
	      3'd4: store_sr4 <= h_io_dbus[11:9];
	    endcase // case(memif_index)
	  end
	end
	
	// Memory Index
	16'h03c5: begin
	  case (memif_index)
	    3'd0: store_sr0 <= h_io_dbus[9:8];
	    3'd1: store_sr1 <= {h_io_dbus[13:10], h_io_dbus[8]};
	    3'd2: store_sr2 <= h_io_dbus[11:8];
	    3'd3: store_sr3 <= h_io_dbus[13:8];
	    3'd4: store_sr4 <= h_io_dbus[11:9];
	  endcase // case(memif_index)
	end

	// Color CRT Index 
	16'h03d4: begin
	  if (color_mode & h_io_16) begin
	    case (c_crtc_index[5:0])
	      6'hc:  reg_cr0c_qout <= h_io_dbus[15:8];
	      6'hd:  reg_cr0d_qout <= h_io_dbus[15:8];
	      6'he:  reg_cr0e_qout <= h_io_dbus[15:8];
	      6'hf:  reg_cr0f_qout <= h_io_dbus[15:8];
	      6'h13: reg_cr13_qout <= h_io_dbus[15:8];
	    endcase // case(c_crtc_index[5:0])
	  end
	end
	
	// Color CRT Data
	16'h03d5: begin
	  if (color_mode) begin
	    case (c_crtc_index[5:0])
	      6'hc:  reg_cr0c_qout <= h_io_dbus[15:8];
	      6'hd:  reg_cr0d_qout <= h_io_dbus[15:8];
	      6'he:  reg_cr0e_qout <= h_io_dbus[15:8];
	      6'hf:  reg_cr0f_qout <= h_io_dbus[15:8];
	      6'h13: reg_cr13_qout <= h_io_dbus[15:8];
	    endcase // case(c_crtc_index[5:0])
	  end
	end
	
      endcase // case(h_io_addr)
    end

  assign reg_sr0_qout = {6'b111111, store_sr0};
  assign reg_sr1_qout = {1'b0, store_sr1[5:1], 1'b0, store_sr1[0]};
  assign reg_sr2_qout = {4'b0, store_sr2};
  assign reg_sr3_qout = {2'b0, store_sr3};
  assign reg_sr4_qout = {4'b0, store_sr4, 1'b0};

  //						      
  // Generating the ready signal and transreciver enable signal for the 
  // IO registers in the memory block. 
  // The registers are CR0C to CR0F, CR13,
  // and SR00 to SR07.
  //
  assign seq_index_range = (h_io_addr == 16'h03c4);
  assign seq_data_range = ((memif_index_qout >= 8'h00) & 
			   (memif_index_qout <= 8'h07));
  assign real_seq_data_range = ((memif_index_qout >= 8'h00) & 
				(memif_index_qout <= 8'h04));

  assign seq_data_dec = ((h_io_addr == 16'h03c4) & h_io_16 ) |
			  (h_io_addr == 16'h03c5);
  
  assign seq_addr_hit = (seq_index_range | (seq_data_range & seq_data_dec)) &
			  h_io_rdwr1;

  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) delay1_rdorwr <= 1'b0;
    else            delay1_rdorwr <= h_io_rdwr1;
  
  assign h_io_rdwr1 = h_iord | h_iowr;

  assign crt_index_hit = color_mode ? (h_io_addr == 16'h3d4) :
      					(h_io_addr == 16'h3b4);

  assign crt_reg_hit = color_mode ? (h_io_addr == 16'h3d5) :
      	       	     	      	      (h_io_addr == 16'h3b5);
  
  assign c_cr0c_f13_22_hit = ((crt_index_hit & h_io_16) | crt_reg_hit) &
			       (c_crtc_index >= 30 & c_crtc_index <= 8'h34);
  
  assign mem_mod_addr_hit = (c_cr0c_f13_22_hit | seq_addr_hit);

  assign m_ready_n = ~(mem_mod_addr_hit & delay1_rdorwr);
  
  assign seq_range_0_6 = ((memif_index_qout >= 8'h00) & 
			  (memif_index_qout <= 8'h06));
  
  assign seq_range_7  = {memif_index_qout[7]};
  
  //
  // Generating m_dec_sr00_sr06 which is dec of seq register enabled
  // from sr00 to sr06.
  assign m_dec_sr00_sr06 = seq_range_0_6 & seq_data_dec & h_io_rdwr1;
  assign m_dec_sr07 = seq_range_7 & seq_data_dec & h_io_rdwr1;
  assign crtc_mod_data_en = c_cr0c_f13_22_hit;
  assign mem_mod_rd_en_hb = seq_data_dec & real_seq_data_range & h_iord |
      	 crtc_mod_data_en & h_iord;
  assign mem_mod_rd_en_lb = seq_index_range & h_iord;

endmodule

