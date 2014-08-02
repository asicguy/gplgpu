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
//  Title       :  CPU SM
//  File        :  sm_cpu_cy124.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module consists of two state machines. 
//   The first one is cpu_latch_data, which process the 
//   hostdata, latches the data into a latch. This state
//   machine also generates the host ready signal to host.
//   Which indicates that the VGA is ready for the
//   next cycle.
//
//   The second state machine generates the internal cylces
//   for the external host transfers to the external memory
//   memory acess. When the external host transfer is 32-bit 
//   mode then internal it is one cycle transfer. If it is 
//   16-bit transfer then it is a two cycle transfer. If the 
//   host is 8-bit transfer then the internal transfer is four 
//   cycles.
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
module sm_cpu_cy124 
  (
   input       t_mem_io_n,   
   input       t_svga_sel,
   input       m_cpurd_s0,   
   input       t_data_ready_n,   
   input       cpu_rd_gnt,
   input       svga_ack,
   input       en_cy1,
   input       en_cy2,
   input       en_cy3,
   input       en_cy4,   
   input       c_misc_b1,      
   input       h_reset_n,
   input       t_mem_clk,
   input       h_svga_sel,
   input       h_hrd_hwr_n,
   input       h_mem_io_n,
   input       m_cpu_ff_full,
   input       m_chain4,
   input       m_odd_even,
   input       m_planar,
   input       m_memrd_ready_n,
   
   output      cpucy_1_2,
   output      cpucy_2_2,
   output      cpucy_1_3,
   output      cpucy_2_3,
   output      cpucy_3_3,
   output      cpucy_1_4,
   output      cpucy_2_4,
   output      cpucy_3_4,
   output      cpucy_4_4,
   output      g_mem_ready_n,
   output      g_memwr,
   output      mem_clk,
   output      g_memrd,
   output      g_lt_hwr_cmd,
   output      g_cpult_state1,
   output reg  cy2_gnt,
   output reg  cy3_gnt,
   output reg  cy4_gnt,
   output      mem_write,
   output      memwr_inpr,
   output      g_cpu_data_done,
   output      g_cpu_cycle_done,
   output      mem_read,
   output reg  svga_sel_hit,
   output reg  svmem_sel_hit,
   output      svmem_hit_we,
   output reg  en_cy1_ff,
   output reg  en_cy2_ff,
   output reg  en_cy3_ff,
   output reg  en_cy4_ff,
   output      cur_cpurd_done
   );
  
  reg [1:0] lt_current_state;
  reg [1:0] lt_next_state;
  reg [4:0] cyl_current_state;
  reg [4:0] cyl_next_state;
  reg       cyl_s0, cyl_s1;
  reg       cyl_s2, cyl_s3;
  reg       cyl_s4, cyl_s5;
  reg       cyl_s6;
  reg       cyl_s7, cyl_s8;
  reg       cyl_s9, cyl_sa;
  reg       cyl_sb;
  reg       cyl_sc, cyl_sd, cyl_se, cyl_sf, cyl_s10;
  reg       cltda_s0, cltda_s1, cltda_s2, cltda_s3;
  reg [2:0] drdy_q;
  reg 	    mem_ready_dly;
  reg 	    mem_ready_dly1;
  
  wire      data_rdy;
  wire      ency1_rst_n; 
  wire      ency2_rst_n; 
  wire      ency3_rst_n; 
  wire      ency4_rst_n; 
  wire      cur_cyl_done;
  wire      cpuff_ack;
  wire      start_cpuwr;
  wire      cpu_wrcycle_done;  
  wire      start_rdwr;
  wire      dly_reset_n;
  wire      cyl_gnt_rst_n;
  wire      dx_1;
  wire      dx_2;
  wire      dx_3;
  wire      dx_4;
  wire      drdy_cnt_inc;
  wire      svga_hit_we;
  wire      ency1_rst, ency2_rst, ency3_rst, ency4_rst;
  wire      mem_ready;
  wire      c_rd_rst;
  wire      c_rd_rst_dly;
  wire      svgahit_din;
  wire      svmemhit_din;
  
  
  //
  //  	 Define state machine states
  //
  
  assign    mem_write = ~h_hrd_hwr_n & h_mem_io_n;
  
  assign    mem_read = h_hrd_hwr_n & h_mem_io_n;
  
  assign    g_memrd = h_hrd_hwr_n & h_mem_io_n;
  
  assign    mem_clk = t_mem_clk;   
  
  
  
  assign    svga_hit_we = (t_mem_io_n & t_svga_sel) | cltda_s1;

  assign    svgahit_din = ~cltda_s1;

  always @(posedge mem_clk or negedge h_reset_n)
    if (!h_reset_n)        svga_sel_hit <= 1'b0;
    else if (svga_hit_we) svga_sel_hit <= svgahit_din;
  
  assign    svmem_hit_we = t_mem_io_n & t_svga_sel | ~g_mem_ready_n;
  
  assign    svmemhit_din = g_mem_ready_n;
  
  always @(posedge mem_clk or negedge h_reset_n)
    if (!h_reset_n)         svmem_sel_hit <= 1'b0;
    else if (svmem_hit_we) svmem_sel_hit <= svmemhit_din;

  parameter cpu_ltda_state0  = 2'b00,
            cpu_ltda_state1  = 2'b01,
	    cpu_ltda_state3  = 2'b11,
	    cpu_ltda_state2  = 2'b10;
  
  always @ (posedge mem_clk or negedge h_reset_n) begin
    if (!h_reset_n) lt_current_state <= cpu_ltda_state0;
    else           lt_current_state <= lt_next_state;
  end
  
  always @* begin
    cltda_s0    = 1'b0;
    cltda_s1    = 1'b0;
    cltda_s2    = 1'b0;
    cltda_s3    = 1'b0;
      
    case (lt_current_state) // synopsys parallel_case full_case
  	
      cpu_ltda_state0: begin
	cltda_s0 = 1'b1;
        if (~m_cpu_ff_full & svga_sel_hit &  c_misc_b1 & mem_write)
	  lt_next_state = cpu_ltda_state1;
	else
	  lt_next_state = cpu_ltda_state0;
      end
	
      cpu_ltda_state1: begin
	cltda_s1 = 1'b1;
	lt_next_state = cpu_ltda_state3;
      end
        
      cpu_ltda_state3: begin
        cltda_s3 = 1'b1;
	if (cpu_wrcycle_done) 
	  lt_next_state = cpu_ltda_state0;
	else 
	  lt_next_state = cpu_ltda_state2;
      end
        
      cpu_ltda_state2: begin
	cltda_s2 = 1'b1;
	if (cpu_wrcycle_done) 
	  lt_next_state = cpu_ltda_state0;
	else 
	  lt_next_state = cpu_ltda_state2;
      end
    endcase
  end  			
  
  assign start_cpuwr = cltda_s1 | cltda_s3;
  
  assign start_rdwr  = (start_cpuwr | (cpu_rd_gnt & svga_ack));
  
  assign mem_ready = cpu_rd_gnt & ~t_data_ready_n;

  always @(posedge mem_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      mem_ready_dly <= 1'b0;
      mem_ready_dly1 <= 1'b0;
      cy2_gnt <= 1'b0;
      cy3_gnt <= 1'b0;
      cy4_gnt <= 1'b0;
    end else begin
      mem_ready_dly <= mem_ready;
      mem_ready_dly1 <= data_rdy;
      if (cpu_wrcycle_done) begin
	cy2_gnt <= 1'b0;
	cy3_gnt <= 1'b0;
	cy4_gnt <= 1'b0;
      end else if (start_rdwr) begin
	if (en_cy2_ff) cy2_gnt <= 1'b1;
	if (en_cy3_ff) cy3_gnt <= 1'b1;
	if (en_cy4_ff) cy4_gnt <= 1'b1;
      end
    end
  
  assign data_rdy = mem_ready_dly & g_cpu_data_done;
  
  assign g_mem_ready_n     = ~cltda_s1 &  ~mem_ready_dly1;
  
  assign g_lt_hwr_cmd = cltda_s0;
  
  assign g_cpult_state1 = cltda_s1;
  
  //
  // The following state machine generates internal cycles for the
  // external host transfers to the external memory access. 
  // When the external host transfer is 32-bit mode then internal 
  // it is one cycle transfer. If it is 16-bit transfer then it is a 
  // two cycle transfer. If the host is 8-bit transfer then the 
  // internal transfer is four cycles.
  //
  parameter cpucyl_state0  = 5'b00000,
            cpucyl_state1  = 5'b00001,
            cpucyl_state2  = 5'b00010,
            cpucyl_state3  = 5'b00011,
            cpucyl_state4  = 5'b00111,
            cpucyl_state5  = 5'b01000,
            cpucyl_state6  = 5'b01100,
            cpucyl_state7  = 5'b01110,
            cpucyl_state8  = 5'b01111,
            cpucyl_state9  = 5'b01011,
            cpucyl_statea  = 5'b01001,
            cpucyl_stateb  = 5'b01101,
	    cpucyl_statec  = 5'b10000,
	    cpucyl_stated  = 5'b10001,
	    cpucyl_statee  = 5'b10011,
	    cpucyl_statef  = 5'b10111,
	    cpucyl_state10 = 5'b11111;
  
  always @(posedge mem_clk or negedge h_reset_n ) begin
    if (!h_reset_n) cyl_current_state <= cpucyl_state0;
    else           cyl_current_state <= cyl_next_state;
  end

  assign cur_cyl_done = ((g_cpu_data_done & cpu_rd_gnt) | ~cpu_rd_gnt);
  
  assign cur_cpurd_done  = (~t_data_ready_n & cpu_rd_gnt);
  
  assign cpuff_ack  = ((~cpu_rd_gnt & m_cpu_ff_full) | (~svga_ack & cpu_rd_gnt ));
  
  always @* begin
    cyl_s0    = 1'b0;
    cyl_s1    = 1'b0;
    cyl_s2    = 1'b0;
    cyl_s3    = 1'b0;
    cyl_s4    = 1'b0;
    cyl_s5    = 1'b0;
    cyl_s6    = 1'b0;
    cyl_s7    = 1'b0;
    cyl_s8    = 1'b0;
    cyl_s9    = 1'b0;
    cyl_sa    = 1'b0;
    cyl_sb    = 1'b0;
    cyl_sc    = 1'b0;
    cyl_sd    = 1'b0;
    cyl_se    = 1'b0;
    cyl_sf    = 1'b0;
    cyl_s10   = 1'b0;
      
    case (cyl_current_state) // synopsys parallel_case full_case
	
      cpucyl_state0: begin
        cyl_s0 = 1'b1;
        if (start_rdwr & en_cy1_ff)      cyl_next_state = cpucyl_state1;
	else if (start_rdwr & en_cy2_ff) cyl_next_state = cpucyl_state2;
	else if (start_rdwr & en_cy3_ff) cyl_next_state = cpucyl_statec;
	else if (start_rdwr & en_cy4_ff) cyl_next_state = cpucyl_state5;
        else                             cyl_next_state = cpucyl_state0;
      end

      //
      //  Start of cycle 1
      //
      cpucyl_state1: begin
	cyl_s1 = 1'b1;
	if (cur_cyl_done) cyl_next_state = cpucyl_state0;
	else              cyl_next_state = cpucyl_state1;
      end

      //
      //  Start of cycle 2
      //
      cpucyl_state2: begin
        cyl_s2 = 1'b1;
	cyl_next_state = cpucyl_state3;
      end

      cpucyl_state3: begin
	cyl_s3 = 1'b1;
        if (!cpuff_ack) cyl_next_state = cpucyl_state4;
        else            cyl_next_state = cpucyl_state3;
      end
	
      cpucyl_state4: begin
        cyl_s4 = 1'b1;
	if (cur_cyl_done) cyl_next_state = cpucyl_state0;
	else              cyl_next_state = cpucyl_state4;
      end
	
      //
      //  Start of cycle 4
      //
      cpucyl_state5: begin
	cyl_s5 = 1'b1;
        cyl_next_state = cpucyl_state6;
      end

      cpucyl_state6: begin
	cyl_s6 = 1'b1;
        if (!cpuff_ack) cyl_next_state = cpucyl_state7;
        else            cyl_next_state = cpucyl_state6;
      end
      
      cpucyl_state7: begin
        cyl_s7 = 1'b1;
        cyl_next_state = cpucyl_state8;
      end

      cpucyl_state8: begin
        cyl_s8 = 1'b1;
        if (!cpuff_ack) cyl_next_state = cpucyl_state9;
        else            cyl_next_state = cpucyl_state8;
      end

      cpucyl_state9: begin
        cyl_s9 = 1'b1;
        cyl_next_state = cpucyl_statea;
      end

      cpucyl_statea: begin
        cyl_sa = 1'b1;
        if (!cpuff_ack) cyl_next_state = cpucyl_stateb;
        else            cyl_next_state = cpucyl_statea;
      end
      
      cpucyl_stateb: begin
        cyl_sb = 1'b1;
	if (cur_cyl_done) cyl_next_state = cpucyl_state0;
	else              cyl_next_state = cpucyl_stateb;
      end 
	
      //
      //  Start of cycle 3
      //
      cpucyl_statec: begin
	cyl_sc = 1'b1;
        cyl_next_state = cpucyl_stated;
      end
      
      cpucyl_stated: begin
	cyl_sd = 1'b1;
        if (!cpuff_ack) cyl_next_state = cpucyl_statee;
        else            cyl_next_state = cpucyl_stated;
      end

      cpucyl_statee: begin
        cyl_se = 1'b1;
	cyl_next_state = cpucyl_statef;
      end

      cpucyl_statef: begin
        cyl_sf = 1'b1;
        if (!cpuff_ack) cyl_next_state = cpucyl_state10;
        else            cyl_next_state = cpucyl_statef;
      end

      cpucyl_state10: begin
        cyl_s10 = 1'b1;
	if (cur_cyl_done) cyl_next_state = cpucyl_state0;
	else              cyl_next_state = cpucyl_state10;
      end
      
    endcase
  end	
  
  assign cpu_wrcycle_done = cyl_s1 | cyl_s4 | cyl_sb | cyl_s10;
  
  assign g_cpu_cycle_done = cpu_wrcycle_done;
  
  //
  // g_cpu_write or g_memwr are the same, it goes to the cpu_fifo_write
  // to increment the f_wr counter.
  //
  
  assign g_memwr = (cyl_s1 | (cyl_s2 | cyl_s4) | (cyl_s5 | cyl_s7 | cyl_s9 | cyl_sb) | (cyl_sc | cyl_se | cyl_s10));
  
  assign memwr_inpr = ~cyl_s0;   // memory write in progress
  
  assign cpucy_1_2 = cyl_s2; // cpu_cycle one of two cycles
  
  assign cpucy_2_2 = cyl_s4; // cpu_cycle two of two cycles
  
  
  assign cpucy_1_3 = cyl_sc; // cpu_cycle one of three cycles
  
  assign cpucy_2_3 = cyl_se; // cpu_cycle two of three cycles
  
  assign cpucy_3_3 = cyl_s10; // cpu_cycle three of three cycles
  
  
  assign cpucy_1_4 = cyl_s5; // cpu_cycle one of four cycles
  
  assign cpucy_2_4 = cyl_s7; // cpu_cycle two of four cycles
  
  assign cpucy_3_4 = cyl_s9; // cpu_cycle three of four cycles
  
  assign cpucy_4_4 = cyl_sb; // cpu_cycle four of four cycles
  
  assign drdy_cnt_inc = ~t_data_ready_n & cpu_rd_gnt;
  
  always @ (posedge mem_clk or negedge h_reset_n) begin
    if (!h_reset_n)        drdy_q <= 3'b0;
    else if (m_cpurd_s0)   drdy_q <= 3'b0;
    else if (drdy_cnt_inc) drdy_q <= drdy_q + 1;
  end 

  assign dx_1 = (drdy_q[2:0] == 3'b001) & en_cy1_ff;
  assign dx_2 = (drdy_q[2:0] == 3'b010) & en_cy2_ff;
  assign dx_3 = (drdy_q[2:0] == 3'b011) & en_cy3_ff;
  assign dx_4 = (drdy_q[2:0] == 3'b100) & en_cy4_ff;
  
  assign g_cpu_data_done = dx_1 | dx_2 | dx_3 | dx_4;
  
  assign c_rd_rst = cpu_rd_gnt & m_cpurd_s0;
  
  always @(posedge mem_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      en_cy1_ff <= 1'b0;
      en_cy2_ff <= 1'b0;
      en_cy3_ff <= 1'b0;
      en_cy4_ff <= 1'b0;
    end else if ((mem_write & cpu_wrcycle_done) | c_rd_rst) begin
      en_cy1_ff <= 1'b0;
      en_cy2_ff <= 1'b0;
      en_cy3_ff <= 1'b0;
      en_cy4_ff <= 1'b0;
    end else begin
      if (en_cy1) en_cy1_ff <= 1'b1;
      if (en_cy2) en_cy2_ff <= 1'b1;
      if (en_cy3) en_cy3_ff <= 1'b1;
      if (en_cy4) en_cy4_ff <= 1'b1;
    end
  
endmodule       
