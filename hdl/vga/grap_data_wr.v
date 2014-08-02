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
//  Title       :  Graphics Data Write
//  File        :  grap_data_wr.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module consists of the graphic engine of
//   the VGA. Here in this module the lower byte of
//   host_data h_mem_dbus[7:0] is passed through this
//   module and the data is processed depending on 
//   the mode ie 8bits per pixel, 16bits per pixel,
//   24bits per pixel. If the bypass graphic bit is
//   set then the host data is passed without any
//   conversion and sent to the memory block.
//   The 8bit host data after passing through this 
//   module is converted to 32bit graphic data.
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
module grap_data_wr
  (
   input [31:0]    sftw_h_mem_dbus,  
   input           g_memrd,
   input           m_sr04_b3,        	 // chain4
   input           gr5_b0,           	 // write mode[0]
   input           gr5_b1,           	 // write mode[1] 
   input           m_odd_even,        	 // odd/even
   input [3:0]     reg_gr0_qout,
   input [3:0]     reg_gr1_qout, 
   input [4:0]     reg_gr3_qout,
   input [7:0]     reg_gr8_qout,
   input [31:0]    cpu_lat_data,
   
   output [31:0]   g_graph_data_out
   );

  //
  // 	 Define Variables
  //
  reg [31:0]      int_g_graph_data;
  
  reg [7:0]       rot_data;
  reg             wr_mode0;
  reg             wr_mode1;
  reg             wr_mode2;
  reg             wr_mode3;
  reg [7:0]       grint_data0;
  reg [15:8]      grint_data1;
  reg [23:16]     grint_data2;
  reg [31:24]     grint_data3;
  reg [31:0]      alu_out_data;
  
  reg [31:0]      int1_g_graph_data;
  reg [31:0]      int2_g_graph_data;

  wire            gr0_b0;
  wire            gr0_b1;
  wire            gr0_b2;
  wire            gr0_b3;
  wire            gr1_b0;
  wire            gr1_b1;
  wire            gr1_b2;
  wire            gr1_b3;
  wire [7:0]      hm_dbus;
  wire [7:0]      gr0_b0_bus;
  wire [7:0]      gr0_b1_bus;
  wire [7:0]      gr0_b2_bus;
  wire [7:0]      gr0_b3_bus;
  wire [31:0]     grint_data;
  wire [7:0]      spmux_en_bus;
  wire [31:0]     gra_out_data;   
  wire [1:0]      write_count;
  wire            int_x1, int_x2;
  wire            p0_s0, p0_s1, p0_s2;
  wire            p1_s0, p1_s1, p1_s2;
  wire            p2_s0, p2_s1, p2_s2;
  wire            p3_s0, p3_s1, p3_s2;
  wire            alu_pass;
  wire            alu_and;
  wire            alu_or;
  wire            alu_xor;
  wire            odd_even;
  wire [2:0]      gr3_count;
  wire            bypass_graph;
  wire            hdbus_en;
  wire            gdbus_en;
  
  wire [7:0]      hm_bus_0;
  wire [7:0]      hm_bus_1;
  wire [7:0]      hm_bus_2;
  wire [7:0]      hm_bus_3;

  assign          gr0_b0 = reg_gr0_qout[0];
  assign          gr0_b1 = reg_gr0_qout[1];
  assign          gr0_b2 = reg_gr0_qout[2];
  assign          gr0_b3 = reg_gr0_qout[3];
  
  assign          gr1_b0 = reg_gr1_qout[0];
  assign          gr1_b1 = reg_gr1_qout[1];
  assign          gr1_b2 = reg_gr1_qout[2];
  assign          gr1_b3 = reg_gr1_qout[3];
  
  assign          odd_even = m_odd_even;
  assign          hm_dbus = sftw_h_mem_dbus[7:0];
  assign          gr3_count = reg_gr3_qout[2:0];
  assign          write_count = {gr5_b1, gr5_b0};
  assign          bypass_graph = (m_odd_even | m_sr04_b3) & ~wr_mode1;
  
  always @* begin
    wr_mode0   = 1'b0;
    wr_mode1   = 1'b0;
    wr_mode2   = 1'b0;
    wr_mode3   = 1'b0;
      
    case(write_count)
      2'b00:   wr_mode0 = 1'b1;
      2'b01:   wr_mode1 = 1'b1;
      2'b10:   wr_mode2 = 1'b1;
      2'b11:   wr_mode3 = 1'b1;
    endcase
  end     
  
  
  always @(gr3_count or hm_dbus) begin
    case(gr3_count) // synopsys parallel_case full_case
      3'b000: rot_data = hm_dbus;
      3'b001: rot_data = {hm_dbus[0], hm_dbus[7:1]};
      3'b010: rot_data = {hm_dbus[1:0], hm_dbus[7:2]};
      3'b011: rot_data = {hm_dbus[2:0], hm_dbus[7:3]};
      3'b100: rot_data = {hm_dbus[3:0], hm_dbus[7:4]};
      3'b101: rot_data = {hm_dbus[4:0], hm_dbus[7:5]};
      3'b110: rot_data = {hm_dbus[5:0], hm_dbus[7:6]};
      3'b111: rot_data = {hm_dbus[6:0], hm_dbus[7]};
    endcase
  end
  
  //
  // Generating select signals for each plane which is a 3 input mux
  // with gr[0], sftw_h_mem_dbus[7:0] and rot_data[7:0] are muxed into this
  // mux and the output is grint_data[7:0]
  
  // The above procedure is repeated for the other 3 planes with gr[1]
  // for plane1, gr[2] for plane2 and gr[3] for plane3.
  
  // The outputs are grint_data[15:8] for plane1, grint_data[23:16] for
  // plane2 and grint_data[31:24] for plane3.
  //
  
  
  assign int_x1 = (wr_mode1 | bypass_graph);
  assign int_x2 = int_x1 | wr_mode0;
  
  assign p0_s0 = (wr_mode0 & gr1_b0) | wr_mode3 ;
  assign p0_s1 = (wr_mode2 & ~bypass_graph);
  assign p0_s2 = ((int_x1 | ~gr1_b0) & int_x2);

  assign p1_s0 = (wr_mode0 & gr1_b1) | wr_mode3 ;
  assign p1_s1 = (wr_mode2 & ~bypass_graph);
  assign p1_s2 = ((int_x1 | ~gr1_b1) & int_x2); 

  assign p2_s0 = (wr_mode0 & gr1_b2) | wr_mode3 ;
  assign p2_s1 = (wr_mode2 & ~bypass_graph);
  assign p2_s2 = ((int_x1 | ~gr1_b2) & int_x2); 

  assign p3_s0 = (wr_mode0 & gr1_b3) | wr_mode3 ;
  assign p3_s1 = (wr_mode2 & ~bypass_graph);
  assign p3_s2 = ((int_x1 | ~gr1_b3) & int_x2); 
  
  assign gr0_b0_bus = {8{gr0_b0}};
  assign gr0_b1_bus = {8{gr0_b1}};
  assign gr0_b2_bus = {8{gr0_b2}};
  assign gr0_b3_bus = {8{gr0_b3}};

  assign hm_bus_0 = {8{hm_dbus[0]}};
  assign hm_bus_1 = {8{hm_dbus[1]}};  
  assign hm_bus_2 = {8{hm_dbus[2]}};  
  assign hm_bus_3 = {8{hm_dbus[3]}};

  always @(p0_s0 or p0_s1 or p0_s2 or gr0_b0_bus or hm_bus_0 or rot_data )
    begin
      if (p0_s0)      grint_data0 = gr0_b0_bus;
      else if (p0_s1) grint_data0 = hm_bus_0;
      else if (p0_s2) grint_data0 = rot_data;
      else            grint_data0 = hm_bus_0;
    end	 
  
  always @(p1_s0 or p1_s1 or p1_s2 or gr0_b1_bus or hm_bus_1 or rot_data)
    begin
      if (p1_s0)      grint_data1 = gr0_b1_bus;
      else if (p1_s1) grint_data1 = hm_bus_1;
      else if (p1_s2) grint_data1 = rot_data;
      else            grint_data1 = hm_bus_1;
    end
  
  always @(p2_s0 or p2_s1 or p2_s2 or gr0_b2_bus or hm_bus_2 or rot_data)
    begin
      if (p2_s0)      grint_data2 = gr0_b2_bus;
      else if (p2_s1) grint_data2 = hm_bus_2;
      else if (p2_s2) grint_data2 = rot_data;
      else            grint_data2 = hm_bus_2;
    end

  always @(p3_s0 or p3_s1 or p3_s2 or gr0_b3_bus or hm_bus_3 or rot_data)
    begin
      if (p3_s0)      grint_data3 = gr0_b3_bus;
      else if (p3_s1) grint_data3 = hm_bus_3;
      else if (p3_s2) grint_data3 = rot_data;
      else            grint_data3 = hm_bus_3;
    end

  assign grint_data = {grint_data3, grint_data2, grint_data1, grint_data0};
  
  assign alu_pass = ~reg_gr3_qout[4] & ~reg_gr3_qout[3];
  assign alu_and = ~reg_gr3_qout[4] & reg_gr3_qout[3];
  assign alu_or = reg_gr3_qout[4] & ~reg_gr3_qout[3];
  assign alu_xor = reg_gr3_qout[4] & reg_gr3_qout[3];

  always @* begin
    case(reg_gr3_qout[4:3])
      2'b11: alu_out_data = cpu_lat_data ^ grint_data;  // XOR
      2'b10: alu_out_data = cpu_lat_data | grint_data;  // OR
      2'b01: alu_out_data = cpu_lat_data & grint_data;  // AND
      2'b00: alu_out_data = grint_data;
    endcase
  end
  
  //	 
  // Here we are muxing 32-bit cpu-lt-data and alu_out_data
  // depending on the gr5[0] & gr5[1] ie write-mode state.
  // The output of this mux is graphic_data for the four
  // planes of the memory. 
  // In each plane each bit is qualified with bit of the 
  // bit mask register and rotated data.
  //

  assign spmux_en_bus = ((rot_data & {8{gr5_b1}} | {8{~gr5_b0}}) &
                         reg_gr8_qout) | {8{bypass_graph}};
  assign gra_out_data = (alu_out_data[31:0] & {4{spmux_en_bus[7:0]}}) |
                          ({4{~spmux_en_bus[7:0]}} & cpu_lat_data[31:0]);
  
  assign g_graph_data_out = bypass_graph ? sftw_h_mem_dbus :
	 gra_out_data;
  
endmodule	 



