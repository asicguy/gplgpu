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
//  Title       :  Attribute Reg Dec
//  File        :  attr_reg_dec.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
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
module attr_reg_dec
  (
   input       	  h_reset_n,
   input       	  h_iord,
   input       	  h_iowr,
   input       	  h_dec_3cx,
   input [15:0]   h_io_addr,
   input       	  c_cr24_rd,
   input       	  c_cr26_rd,
   input       	  c_dec_3ba_or_3da,   // decode of address 3ba or 3da
   input          h_io_16,
   input          h_hclk,             // host clock
   input [15:0]   h_io_dbus,
  
   output 	  attr_data_wr,       // Need to enable the attribute writing
   output 	  dport_we,           // Write enable for the dual ports
   output [7:0]   attr_index,
   output [7:0]   int_io_dbus,
   output         a_ready_n,
   output      	  attr_mod_rd_en_hb,
   output      	  attr_mod_rd_en_lb,
   output      	  a_arx_b5,           // Video display enable control bit
   output      	  pal_reg_bank_b7_b6_rd
   );
  
  reg 		  final_toggle_ff;
  reg 		  final_toggle_ff_d; // final_toggle_ff delayed by one h_hclk
  reg 		  toggle_ff;
  reg [5:0] 	  store_index;
  reg 		  h_iowr_trim_d;
  reg 		  h_iowr_d;       // Host io write delayed by one h_hclk
  reg 		  rd_or_wr_d;
  
  wire 		  wr_to_3c0;
  wire 		  rd_to_3ba_or_3da;
  wire 		  attr_index_rd; // Attribute index read
  wire 		  attr_data_rd;
  wire 		  dec_3c0;
  wire 		  dec_3c1;
  wire 		  attr_io_hit;
  wire 		  rd_or_wr;
  wire 		  h_iowr_trim;
  
  integer 	  i;
  
  // Infering Attribute index register. 
  // dout is connected to h_io_dbus[15:8]
  // because reading of this register happens at odd address ("03C1")
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) 
      store_index <= 6'b0;
    else if (~final_toggle_ff_d & h_iowr & h_io_addr == 16'h03c0)
      store_index <= h_io_dbus[5:0];
  
  assign   attr_index = {2'b0, store_index};
      
  assign   a_arx_b5 = attr_index[5]; // Video display enable control bit
  
  // Realizing index toggle register
  assign   dec_3c0  = h_io_addr == 16'h03c0;
  assign   dec_3c1  = h_io_addr == 16'h03c1;
  
  assign   rd_to_3ba_or_3da  = c_dec_3ba_or_3da & h_iord;
  assign   h_iowr_trim = (h_iowr & (~h_iowr_d));
  assign   wr_to_3c0   = h_iowr_trim_d & dec_3c0;
  
  always @(posedge h_hclk or negedge h_reset_n)
    if(~h_reset_n) toggle_ff <= 1'b0;
    else           toggle_ff <= ((wr_to_3c0 ^ toggle_ff) & 
				 (~rd_to_3ba_or_3da));
  
  always @(posedge h_hclk or negedge h_reset_n)
    if(~h_reset_n) final_toggle_ff <= 1'b0;
    else           final_toggle_ff <= (toggle_ff & (~rd_to_3ba_or_3da));
  
  always @(posedge h_hclk or negedge h_reset_n)
    if(~h_reset_n) final_toggle_ff_d <= 1'b0;
    else           final_toggle_ff_d <= final_toggle_ff;
  
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      h_iowr_trim_d <= 1'b0;
      h_iowr_d      <= 1'b0;
    end else begin
      h_iowr_trim_d <= h_iowr_trim;
      h_iowr_d      <= h_iowr;
    end

  assign dport_we     = final_toggle_ff_d & ~attr_index[4] & h_iowr & dec_3c0;
  
  assign attr_index_rd = h_iord & (h_io_addr == 16'h03c0);
  
  assign attr_data_wr = final_toggle_ff_d & h_iowr & dec_3c0;
  assign attr_data_rd = ( (dec_3c0 & h_io_16) | dec_3c1 ) & h_iord;
  
  assign int_io_dbus = { final_toggle_ff, attr_index[6:0] };
  
  // detecting index 0 through f. pal_reg_bank_b7_b6_rd will be set whenever
  // there is a read to any of registers in the palette register bank.
  assign pal_reg_bank_b7_b6_rd =  (~attr_index[4]) & attr_data_rd;
  assign attr_mod_rd_en_hb     = attr_data_rd | c_cr24_rd | c_cr26_rd;
  assign attr_mod_rd_en_lb     = attr_index_rd;
  
  // Generating attr_io_hit by checking that the address range falls into one
  // of the IO register of attr module
  assign attr_io_hit = dec_3c0 | dec_3c1 | c_cr24_rd | c_cr26_rd;
  
  assign rd_or_wr = h_iowr | h_iord;

  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) rd_or_wr_d <= 1'b0;
    else            rd_or_wr_d <= rd_or_wr;
  
  // delay (h_iowr | h_iord) by one h_hclk and then give it out as a_ready_n
  assign a_ready_n = (~(rd_or_wr_d & attr_io_hit) ) ;
  
endmodule
