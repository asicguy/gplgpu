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
//  Title       :  Serial Shifter
//  File        :  serial_shifter.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   
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
 
 module serial_shifter
   (
    input              h_reset_n,
    input              h_hclk,
    input 	       h_io_wr,
    input 	       h_io_16,
    input [15:0]       h_io_addr,
    input [5:0]        a_attr_index,
    input              attr_data_wr, /* Because of the nature of the attribute
				      * reg, we need this */
    input              g_gr05_b5,    // Serializer shift mode control bit
    input              g_gr05_b6,    // Indicates 256 color mode
    input              c_shift_ld,   // Load signal to Attribute serializer
    input              c_shift_clk,  // Attribute serializer shift clock
    input              c_dclk_en,    // dot clock
    input              c_9dot,
    input [36:0]       m_att_data,   /* Memory data containing pixel info
				      * to the attribute module. */
    input              m_sr04_b3,    // chain-4
    input              cursor_blink_rate,
    input              char_blink_rate,
    input              final_cursor,
    input              pal_reg_bank_b7_b6_rd,
    input              c_attr_de,	       
    input              t_crt_clk,
    input [15:0]       h_io_dbus,  
    input              pre_load, 
    input 	       dport_we,
  
    output [7:0]       reg_ar10,
    output [7:0]       reg_ar11,
    output [7:0]       reg_ar12,
    output [7:0]       reg_ar13,
    output [7:0]       reg_ar14,
    output [5:0]       dport_out,
    output             ar12_b4,       // Video status Mux[0]
    output             a_ar10_b6,     // Pixel double control bit
    output             a_ar10_b5,     // Screen B pixel pan enable control bit
    output             a_ar10_b0,     // Graphics mode bit
    output             a_ar13_b3,     
    output             a_ar13_b2,
    output             a_ar13_b1,
    output             a_ar13_b0,
    output reg         a_is01_b5,     // Video Diagnostic (pixel data) bit
    output reg         a_is01_b4,     // Video Diagnostic (pixel data) bit
    output reg [7:0]   a_t_pix_data,  // pixel data to RAMDAC VGA port
    output             color_256_mode
    );

  
  reg [7:0]          video_a_ff;
  reg [6:0] 	     store_ar10;
  reg [7:0] 	     store_ar11;
  reg [5:0] 	     store_ar12;
  reg [3:0] 	     store_ar13;
  reg [3:0] 	     store_ar14;
  
  wire [7:0]         video_din_a;
  wire [7:0]         sta_final_data;   
  wire [7:0]         int_a_t_pix_data;
  wire               ar10_b0;
  wire               ar10_b1;
  wire               ar10_b2;
  wire               ar10_b3;
  wire               ar10_b7;
  wire [3:0]         ar12_b;
  wire [3:0]         ar14_b;
  wire [1:0]         stat_mux_ctl;

  // Instantiating ar10, ar11, ar12, ar13 and ar14 registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      store_ar10 <= 7'b0;
      store_ar11 <= 8'b0;
      store_ar12 <= 6'b0;
      store_ar13 <= 4'b0;
      store_ar14 <= 4'b0;
    end else if (attr_data_wr) begin
      case (a_attr_index[4:0])
	5'd16: store_ar10 <= {h_io_dbus[7:5], h_io_dbus[3:0]};
	5'd17: store_ar11 <= h_io_dbus[7:0];
	5'd18: store_ar12 <= h_io_dbus[5:0];
	5'd19: store_ar13 <= h_io_dbus[3:0];
	5'd20: store_ar14 <= h_io_dbus[3:0];
      endcase // case(a_attr_index)
    end

  assign reg_ar10 = {store_ar10[6:4], 1'b0, store_ar10[3:0]};
  assign reg_ar11 = store_ar11;
  assign reg_ar12 = {2'b0, store_ar12};
  assign reg_ar13 = {4'b0, store_ar13};
  assign reg_ar14 = {4'b0, store_ar14};
  
  assign ar10_b0   = reg_ar10[0];
  assign ar10_b1   = reg_ar10[1];
  assign ar10_b2   = reg_ar10[2];
  assign ar10_b3   = reg_ar10[3];
  assign ar10_b7   = reg_ar10[7];
  assign ar12_b    = reg_ar12[3:0];
  assign ar12_b4   = reg_ar12[4];
  assign ar14_b    = reg_ar14[3:0];
  
  assign a_ar10_b6 = reg_ar10[6];
  assign a_ar10_b5 = reg_ar10[5];
  assign a_ar10_b0 = reg_ar10[0];
  assign a_ar13_b3 = reg_ar13[3];
  assign a_ar13_b2 = reg_ar13[2];
  assign a_ar13_b1 = reg_ar13[1];
  assign a_ar13_b0 = reg_ar13[0];
  
  serializer_a  SA
    (
     .pre_load        (pre_load),
     .h_hclk          (h_hclk),
     .t_crt_clk       (t_crt_clk),
     .h_reset_n       (h_reset_n),
     .g_gr05_b5       (g_gr05_b5),
     .g_gr05_b6       (g_gr05_b6),
     .c_shift_ld      (c_shift_ld),
     .c_shift_clk     (c_shift_clk),
     .c_dclk_en       (c_dclk_en),
     .c_9dot          (c_9dot),
     .dport_addr      (a_attr_index[3:0]),
     .m_att_data      (m_att_data),
     .m_sr04_b3       (m_sr04_b3),
     .ar10_b0         (ar10_b0),
     .ar10_b1         (ar10_b1),
     .ar10_b2         (ar10_b2),
     .ar10_b3         (ar10_b3),
     .ar10_b7         (ar10_b7),
     .ar12_b          (ar12_b),
     .ar14_b          (ar14_b),
     .cursor_blink_rate(cursor_blink_rate),
     .char_blink_rate (char_blink_rate),
     .final_cursor    (final_cursor),
     .pal_reg_bank_b7_b6_rd(pal_reg_bank_b7_b6_rd),
     .h_io_dbus       (h_io_dbus),
     .dport_we        (dport_we),
     
     .dport_out       (dport_out),
     .color_256_mode  (color_256_mode),
     .sta_final_data  (sta_final_data)
     );

  assign             video_din_a = c_attr_de ? sta_final_data : reg_ar11;

  // Inferring video data flops for serilizer a
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)      video_a_ff <= 8'b0;
    else if (c_dclk_en) video_a_ff <= video_din_a;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n) a_t_pix_data <= 8'b0;
    else            a_t_pix_data <= video_a_ff;
  
  assign             stat_mux_ctl = reg_ar12[5:4];

  always @( a_t_pix_data or stat_mux_ctl) begin
    case(stat_mux_ctl)
      2'b00: begin
	a_is01_b5 <= a_t_pix_data[2];
	a_is01_b4 <= a_t_pix_data[0];
      end
      2'b01: begin
      	a_is01_b5 <= a_t_pix_data[5];
	a_is01_b4 <= a_t_pix_data[4];
      end
      2'b10: begin
	a_is01_b5 <= a_t_pix_data[3];
	a_is01_b4 <= a_t_pix_data[1];
      end
      2'b11: begin
	a_is01_b5 <= a_t_pix_data[7];
	a_is01_b4 <= a_t_pix_data[6];
      end
    endcase
  end
  
endmodule
