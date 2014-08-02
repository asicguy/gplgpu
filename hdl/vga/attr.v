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
//  Title       :  Attribute Controller
//  File        :  attr.v
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
//   Serial Shifter
//   attr_reg_dec
//   final_cursor
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

  module attr
    (
     input             h_reset_n,         // power on reset
     input [15:0]      h_io_addr,         // host address used for IO decoding
     input             h_dec_3cx,         // IO decode of address range 3cx
     input             h_iowr,            // IO write cycle
     input             h_iord,            // IO read cycle 
     input             h_hclk,            // Host clock
     input             c_shift_ld,        // Load signal to Attr serializer
     input             c_shift_ld_pulse,  // Load signal to Attr serializer
     input             c_shift_clk,       // Attribute serializer shift clock
     input             c_dclk_en,         // dot clock
     input             c_9dot,
     input [36:0]      m_att_data,        /* Memory data containing pixel 
					   * information to the attribute 
					   * module. */
     input             m_sr04_b3,         // chain-4
     input             c_cr24_rd,
     input             c_cr26_rd,   
     input             c_attr_de,         // display enable for overscan
     input             c_t_vsync,         // Vertical sync.
     input             c_dec_3ba_or_3da,
     input             c_cr0b_b5,
     input             c_cr0b_b6,
     input             c_cr0a_b5,         // Disable Text cursor
     input             g_gr05_b5,         // Serializer shift mode control bit
     input             g_gr05_b6,         // Indicates 256 color mode
     input             t_crt_clk,
     input             h_io_16,
     input [15:0]      h_io_dbus,
     input             pre_load,

     output [7:0]      reg_ar10,
     output [7:0]      reg_ar11,
     output [7:0]      reg_ar12,
     output [7:0]      reg_ar13,
     output [7:0]      reg_ar14,
     output [5:0]      dport_out,
     output [7:0]      attr_index,
     output [7:0]      cr24_26_dbus,
     output            a_ready_n,         // Ready from attribute module
     output            a_ar10_b6,         // Pixel double control bit
     output	       a_ar10_b5,         // Screen B pixel pan enable control
     output            a_ar10_b0,         // Graphics mode bit
     output            a_ar13_b3,
     output	       a_ar13_b2,
     output	       a_ar13_b1,
     output	       a_ar13_b0,
     output            a_arx_b5,          // Video display enable control bit
     output	       a_is01_b5,         // Video Diagnostic (pixel data) bit
     output	       a_is01_b4,         // Video Diagnostic (pixel data) bit
     output [7:0]      a_t_pix_data,      // pixel data to RAMDAC VGA port
     output            attr_mod_rd_en_lb,
     output   	       attr_mod_rd_en_hb,
     output            color_256_mode     // Mode 13 indicator
     );
  
  wire                 ar12_b4;
  wire                 cursor_blink_rate;
  wire                 finalcursor;
  wire                 pal_reg_bank_b7_b6_rd;
  wire [15:0]          attr_io_dbus;
  wire                 m_att_data_b32 = m_att_data[32];
  wire                 char_blink_rate;   
  wire 		       attr_data_wr;
  wire 		       dport_we;
  
  final_cursor  FC
    (
     .h_reset_n              (h_reset_n),
     .t_crt_clk              (t_crt_clk),
     .c_shift_ld             (c_shift_ld_pulse),
     .m_att_data_b32         (m_att_data_b32),
     .c_cr0b_b6              (c_cr0b_b6),
     .c_cr0b_b5              (c_cr0b_b5),
     .c_cr0a_b5              (c_cr0a_b5),
     .c_t_vsync              (c_t_vsync),
     .ar12_b4                (ar12_b4),
     .cursor_blink_rate      (cursor_blink_rate),
     .char_blink_rate        (char_blink_rate),
     .finalcursor            (finalcursor)
     );
  
  serial_shifter SS
    (
     .h_reset_n              (h_reset_n),
     .h_hclk                 (h_hclk),
     .h_io_wr                (h_iowr),
     .h_io_16                (h_io_16),
     .h_io_addr              (h_io_addr),
     .a_attr_index           (attr_index[5:0]),
     .attr_data_wr           (attr_data_wr),
     .g_gr05_b5              (g_gr05_b5),
     .g_gr05_b6              (g_gr05_b6),
     .c_shift_ld             (c_shift_ld),
     .c_shift_clk            (c_shift_clk),
     .c_dclk_en              (c_dclk_en),
     .c_9dot                 (c_9dot),
     .m_att_data             (m_att_data),
     .m_sr04_b3              (m_sr04_b3),
     .cursor_blink_rate      (cursor_blink_rate),
     .char_blink_rate        (char_blink_rate),
     .final_cursor           (finalcursor),
     .pal_reg_bank_b7_b6_rd  (pal_reg_bank_b7_b6_rd),
     .c_attr_de              (c_attr_de),
     .t_crt_clk              (t_crt_clk),
     .h_io_dbus              (h_io_dbus),
     .pre_load               (pre_load),
     .dport_we               (dport_we),
     
     //####################### OUTPUTS #######################################

     .reg_ar10               (reg_ar10),
     .reg_ar11               (reg_ar11),
     .reg_ar12               (reg_ar12),
     .reg_ar13               (reg_ar13),
     .reg_ar14               (reg_ar14),
     .dport_out              (dport_out),
     .ar12_b4                (ar12_b4),
     .a_ar10_b6              (a_ar10_b6),
     .a_ar10_b5              (a_ar10_b5),
     .a_ar10_b0              (a_ar10_b0),
     .a_ar13_b3              (a_ar13_b3),
     .a_ar13_b2              (a_ar13_b2),
     .a_ar13_b1              (a_ar13_b1),
     .a_ar13_b0              (a_ar13_b0),
     .a_is01_b5              (a_is01_b5),
     .a_is01_b4              (a_is01_b4),
     .a_t_pix_data           (a_t_pix_data),
     .color_256_mode         (color_256_mode)
     );

  attr_reg_dec AD
    (
     .h_reset_n              (h_reset_n),
     .h_iord                 (h_iord),
     .h_iowr                 (h_iowr),
     .h_dec_3cx              (h_dec_3cx),
     .h_io_addr              (h_io_addr),
     .c_cr24_rd              (c_cr24_rd),
     .c_cr26_rd              (c_cr26_rd),
     .c_dec_3ba_or_3da       (c_dec_3ba_or_3da),
     .h_io_16                (h_io_16),
     .h_hclk                 (h_hclk),
     .h_io_dbus              (h_io_dbus),
	    
     //####################### OUTPUTS #######################################

     .attr_data_wr           (attr_data_wr),
     .dport_we               (dport_we),
     .attr_index             (attr_index),
     .int_io_dbus            (cr24_26_dbus),
     .a_ready_n              (a_ready_n),
     .attr_mod_rd_en_hb      (attr_mod_rd_en_hb),
     .attr_mod_rd_en_lb      (attr_mod_rd_en_lb),
     .a_arx_b5               (a_arx_b5),
     .pal_reg_bank_b7_b6_rd  (pal_reg_bank_b7_b6_rd)
     );

endmodule
