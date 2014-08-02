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
//  Title       :  Graphics Register Decoder
//  File        :  grap_reg_dec.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module consists of the io registers and its decodes.
//   The graphic registers gr00 to gr08, are assigned in this module.
//   The graphic ready signal is also generated in this module.
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
module  grap_reg_dec
  (
   input        h_reset_n,
   input        h_iord,
   input        h_iowr,
   input        h_io_16,
   input        h_dec_3cx,
   input [15:0] h_io_addr,
   input [15:8] h_io_dbus,
   input        h_hclk,
   input        c_gr_ext_en,
   input [7:0]  c_ext_index,
   input        c_misc_b0,
   
   output [7:0] g_reg_gr0,
   output [7:0] g_reg_gr1,
   output [7:0] g_reg_gr2,
   output [7:0] g_reg_gr3,
   output [7:0] g_reg_gr4,
   output [7:0] g_reg_gr5,
   output [7:0] g_reg_gr6,
   output [7:0] g_reg_gr7,
   output [7:0] g_reg_gr8,
   
   output [5:0] g_t_ctl_bit,
   output       gr5_b0,
   output       gr5_b1,
   output       read_mode_0,
   output       read_mode_1,
   output       gr4_b0,
   output       gr4_b1,
   output       g_gr05_b4,
   output       g_gr05_b5,
   output       g_gr05_b6,
   output       g_gr06_b0,
   output       g_gr06_b1,
   output       gr6_b2,
   output       gr6_b3,
   output [3:0] reg_gr0_qout,
   output [3:0] reg_gr1_qout,
   output [3:0] reg_gr2_qout,
   output [4:0] reg_gr3_qout, // only two bits are used, the rest are RESERVED
   output [3:0] reg_gr7_qout,
   output [7:0] reg_gr8_qout,
   output       g_ready_n,
   output       gra_mod_rd_en
   );

  reg [3:0]    store0_reg;
  reg [3:0]    store1_reg;
  reg [3:0]    store2_reg;
  reg [4:0]    store3_reg;
  reg [1:0]    store4_reg;
  reg [5:0]    store5_reg;
  reg [3:0]    store6_reg;
  reg [3:0]    store7_reg;
  reg [7:0]    store8_reg;
  reg 	       h_iowr_d;
  reg 	       delay_rdorwr;
  
  wire [7:0]   int_reg_gr0_qout;
  wire [7:0]   int_reg_gr1_qout;
  wire [7:0]   int_reg_gr2_qout;
  wire [7:0]   int_reg_gr3_qout;
  wire [7:0]   int_reg_gr7_qout;
  wire [7:0]   reg_gr5_qout;
  wire [7:0]   reg_gr4_qout;
  wire [7:0]   reg_gr6_qout;
  wire [7:0]   reg_grx_qout;   
  wire         graph_range;
  wire         graph_data_dec;
  wire         h_io_rdwr;
  wire         graphic_io_hit;
  wire         grap_mod_addr_hit;

  // ASsigns for h_io_dbus readback path
  assign       g_reg_gr0 = int_reg_gr0_qout;
  assign       g_reg_gr1 = int_reg_gr1_qout;
  assign       g_reg_gr2 = int_reg_gr2_qout;
  assign       g_reg_gr3 = int_reg_gr3_qout;
  assign       g_reg_gr4 = reg_gr4_qout;
  assign       g_reg_gr5 = reg_gr5_qout;
  assign       g_reg_gr6 = reg_gr6_qout;
  assign       g_reg_gr7 = int_reg_gr7_qout;
  assign       g_reg_gr8 = reg_gr8_qout;
  
  assign       reg_gr0_qout = int_reg_gr0_qout[3:0];
  assign       reg_gr1_qout = int_reg_gr1_qout[3:0];
  assign       reg_gr2_qout = int_reg_gr2_qout[3:0];
  assign       reg_gr3_qout = int_reg_gr3_qout[4:0];
  assign       reg_gr7_qout = int_reg_gr7_qout[3:0];
  
  assign       gr5_b0 = reg_gr5_qout[0];
  assign       gr5_b1 = reg_gr5_qout[1];
  assign       gr6_b2 = reg_gr6_qout[2];
  assign       gr6_b3 = reg_gr6_qout[3];
  
  assign       read_mode_1 = reg_gr5_qout[3];
  assign       read_mode_0 = ~reg_gr5_qout[3];
  assign       g_gr05_b4 = reg_gr5_qout[4];
  assign       g_gr05_b5 = reg_gr5_qout[5];
  assign       g_gr05_b6 = reg_gr5_qout[6];
  
  assign       g_gr06_b0 = reg_gr6_qout[0];
  assign       g_gr06_b1 = reg_gr6_qout[1];
  
  assign       gr4_b0 = reg_gr4_qout[0];
  assign       gr4_b1 = reg_gr4_qout[1];  
  
  assign       g_t_ctl_bit[3] = 1'b0;
  assign       g_t_ctl_bit[2] = 1'b0;
  assign       g_t_ctl_bit[5] = c_misc_b0;
  assign       g_t_ctl_bit[4] = 1'b0;
  assign       g_t_ctl_bit[1] = gr6_b3;
  assign       g_t_ctl_bit[0] = gr6_b2;
  
  
  //
  // 	 Instantiating grap index and extension index registers
  //
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      h_iowr_d     <= 1'b0;
      delay_rdorwr <= 1'b0;
    end else begin
      h_iowr_d     <= h_iowr;
      delay_rdorwr <= h_io_rdwr;
    end
  
  //
  // Infering Graphic Register (GR0 - GR8).
  //
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      store0_reg  <= 4'b0;
      store1_reg  <= 4'b0;
      store2_reg  <= 4'b0;
      store3_reg  <= 5'b0;
      store4_reg  <= 2'b0;
      store5_reg  <= 6'b0;
      store6_reg  <= 4'b0;
      store7_reg  <= 4'b0;
      store8_reg  <= 8'b0;
    end else if (h_iowr & h_iowr_d) begin

      case (h_io_addr)

	// Extension Index
	16'h03ce: begin
	  if (h_io_16) begin
	    case (c_ext_index)
	      8'h0: store0_reg <= h_io_dbus[11:8];
	      8'h1: store1_reg <= h_io_dbus[11:8];
	      8'h2: store2_reg <= h_io_dbus[11:8];
	      8'h3: store3_reg <= h_io_dbus[12:8];
	      8'h4: store4_reg <= h_io_dbus[9:8];
	      8'h5: store5_reg <= {h_io_dbus[14:11], h_io_dbus[9:8]};
	      8'h6: store6_reg <= h_io_dbus[11:8];
	      8'h7: store7_reg <= h_io_dbus[11:8];
	      8'h8: store8_reg <= h_io_dbus[15:8];
	    endcase // case(c_ext_index)
	  end
	end

	// Extension Data
	16'h03cf: begin
	  case (c_ext_index)
	    8'h0: store0_reg <= h_io_dbus[11:8];
	    8'h1: store1_reg <= h_io_dbus[11:8];
	    8'h2: store2_reg <= h_io_dbus[11:8];
	    8'h3: store3_reg <= h_io_dbus[12:8];
	    8'h4: store4_reg <= h_io_dbus[9:8];
	    8'h5: store5_reg <= {h_io_dbus[14:11], h_io_dbus[9:8]};
	    8'h6: store6_reg <= h_io_dbus[11:8];
	    8'h7: store7_reg <= h_io_dbus[11:8];
	    8'h8: store8_reg <= h_io_dbus[15:8];
	  endcase // case(c_ext_index)
	end
      endcase // case(h_addr)
    end

  assign int_reg_gr0_qout = {4'b0, store0_reg};
  assign int_reg_gr1_qout = {4'b0, store1_reg};
  assign int_reg_gr2_qout = {4'b0, store2_reg};
  assign int_reg_gr3_qout = {3'b0, store3_reg};
  assign reg_gr4_qout     = {6'b0, store4_reg};
  assign reg_gr5_qout     = {1'b0, store5_reg[5:2], 1'b0, store5_reg[1:0]};
  assign reg_gr6_qout     = {4'b0, store6_reg};
  assign int_reg_gr7_qout = {4'b0, store7_reg};
  assign reg_gr8_qout     = store8_reg;
  
  // 
  // Evaluating the graphic address range and generating g_ready_n.	 
  //
  
  assign graph_range = ((c_ext_index >= 8'h00) & (c_ext_index <= 8'h08));
  assign graph_data_dec = (h_dec_3cx & (h_io_addr[3:0] == 4'hf)) | 
			    (h_dec_3cx & (h_io_addr[3:0] == 4'he)) ;
  assign h_io_rdwr = h_iord | h_iowr;
  assign graphic_io_hit = (graph_range & graph_data_dec & 
			   h_io_rdwr & c_gr_ext_en);
  assign grap_mod_addr_hit = graphic_io_hit;
  assign g_ready_n = ~(grap_mod_addr_hit & delay_rdorwr);
  assign gra_mod_rd_en = grap_mod_addr_hit & h_iord;
  
endmodule
