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
//  Title       :  CPU Write SM
//  File        :  cpu_wr.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   The function of this module is to take the hostdata
//   from the graphic module as g_graph_data[31:0] and is
//   latched into a 32 x 8 deep fifo before shifting out
//   on to the memory data bus m_t_mem_data [31:0].
//   
//   The address & the planes to the memory is also latched 
//   into the fifo along with the data and is shifted out
//   to the memory to write that particular data.
//   
//   A cpu write statemachine (cpu_wr_sm) is instansiated
//   in this module. The cpu-write state machine generates
//   cpu-write request (cpu_wr_req) to the arbitration
//   module to obtain cpu write cycle. The state machine
//   also generates svga_req to the memory block and once
//   the acknowledge is obtained the data is put on the 
//   memory bus along with the corresponding address and
//   the write-enables.
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
module cpu_wr  
  (
   input          cpu_rd_gnt,   
   input 	  hreset_n,
   input 	  cpu_wr_gnt,
   input 	  crt_req,
   input 	  svga_ack,
   input 	  mem_clk,
   input 	  g_memwr,
   input [19:0]   val_mrdwr_addr,
   input [7:0] 	  fin_plane_sel,
   
   
   input [31:0]   g_graph_data_out,
   
   output 	  cpu_wr_req,
   output 	  cpu_wr_svga_req,
   output [7:0]   cpuwr_mwe_n,
   output [22:3]  cpuwr_mem_addr,   
   output 	  m_cpu_ff_full,
   output 	  cpu_mem_wr,
   output 	  enwr_cpu_ad_da_pl,
   output [31:0]  cpuwr_mem_data_out, 
   output 	  cpu_arb_wr
   );
  
  reg [2:0]     cntrd_out;
  reg [2:0]     cntwr_out;
  reg [2:0]     ffstat_out;
  reg [22:3]    int_wrmem_add;
  wire [59:0] 	cpu_fifo_data_out;
//   reg [59:0] 	fifo_store[7:0];
  reg [7:0]     int_m_t_mwe_n;
  reg [31:0]    int1_m_t_mem_data; 
  
  wire [2:0] 	 next_read;
  wire [31:0]   cpuwr_data_out;
  wire [7:0]    plane_sel;
  wire [22:3]   cpuwr_add_out;
  wire [59:0]   cpu_fifo_wr_in;
  wire [22:3]   cpuwr_conv22;
  wire          cpu_fifo_read;
  wire          ff_wr_pend;
  wire          int_cpu_fifo_rd;
  wire          cpu_ff_empty;
  wire          cpu_ff_full_by1;
  wire          g_memwr_cwr;
  wire [3:0]    nc4_0;

  assign        g_memwr_cwr = g_memwr & ~cpu_rd_gnt;   
  
  assign cpuwr_mem_addr     = cpuwr_add_out[20:3];
  assign cpuwr_mwe_n        = ~plane_sel;
  assign cpuwr_mem_data_out = cpu_fifo_data_out[31:0];
  //
  // 	 muxing address data for high and low data
  //
  
  assign cpuwr_conv22 = {1'b0, cpuwr_add_out[21:3]};
  
  //
  // 	 Instantiating a 60 x 8 FIFO
  //
  assign cpu_fifo_wr_in[59:0] = {fin_plane_sel[7:0], val_mrdwr_addr[19:0], 
                                 g_graph_data_out[31:0]};
  
  assign cpuwr_data_out[31:0] = cpu_fifo_data_out[31:0];
  
  assign cpuwr_add_out[22:3] = cpu_fifo_data_out[51:32];
  
  assign plane_sel[7:0] = cpu_fifo_data_out[59:52];

  ram_64x32_2p u_cpu_fifo_data
    (
     .clock	(mem_clk),
     .wren	(g_memwr_cwr),
     .wraddress	({2'b00, cntwr_out}),
     .rdaddress	({2'b00, next_read}),
     .data	({4'b0000, cpu_fifo_wr_in}),
     .q		({nc4_0, cpu_fifo_data_out})
     );
  
  // 
  //  In the following always statements all the variables are not included
  //  because of the timing of the counters.
  //
  assign next_read = cntrd_out + 3'b001;
  
  always @ (posedge mem_clk or negedge hreset_n )
    if (~hreset_n)          cntrd_out <= 3'b111;
    else if (cpu_fifo_read) cntrd_out <= next_read[2:0];
  
  always @ (posedge mem_clk or negedge hreset_n )
    if (~hreset_n)          cntwr_out <= 3'b0;
    else if (g_memwr_cwr)   cntwr_out <= cntwr_out + 1;

  always @ (posedge mem_clk or negedge hreset_n )
    if (~hreset_n)                          ffstat_out <= 3'b0;
    else  if (g_memwr_cwr & ~cpu_fifo_read) ffstat_out <= ffstat_out + 1'b1;
    else if (cpu_fifo_read & ~g_memwr_cwr)  ffstat_out <= ffstat_out - 1'b1;

  assign cpu_ff_empty    = ~|ffstat_out;
  assign ff_wr_pend      = ~cpu_ff_empty;
  assign m_cpu_ff_full   = &ffstat_out;
  assign cpu_ff_full_by1 = (ffstat_out == 3'h6);
  
  //
  // 	   Instantiating CPUWR STATE MACHINE 
  //
  sm_cpuwr CPUWR_SM 
    (
     .ff_wr_pend            (ff_wr_pend),
     .hreset_n              (hreset_n),
     .cpu_wr_gnt            (cpu_wr_gnt),
     .crt_req               (crt_req),
     .svga_ack              (svga_ack),
     .mem_clk               (mem_clk),
     .cpu_wr_req            (cpu_wr_req),
     .cpu_wr_svga_req       (cpu_wr_svga_req),
     .enwr_cpu_ad_da_pl     (enwr_cpu_ad_da_pl),
     .cpu_fifo_read         (cpu_fifo_read),
     .int_cpu_fifo_rd       (int_cpu_fifo_rd),
     .cpu_mem_wr            (cpu_mem_wr),
     .cpu_arb_wr            (cpu_arb_wr)
     );
  
  

endmodule       



















