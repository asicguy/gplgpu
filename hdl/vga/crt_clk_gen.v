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
//  Title       :  clk generation logic
//  File        :  crt_clk_gen.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module generates dot clock, pixel clock (serializer
//   shift clock) and character clock.
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
module crt_clk_gen
  (
   input           t_crt_clk,
   input           line_cmp,
   input           pix_pan,
   input           h_reset_n,
   input 	   h_io_16,        // 16 bit access = 1, 8 bit = 0
   input 	   h_io_wr,        // IO write cycle
   input [15:0]    h_addr,         // Host address
   input [7:0] 	   c_ext_index,    // Extended mode Index
   input           m_sr01_b4,      // Shift and load 32
   input           m_sr01_b2,      // Shift and load 16
   input           m_sr01_b0,      /* 8 by 9 dot clock.
				    * 1 - 1/8; 0 - 1/9
				    * 1 - dclk is divided by 8
				    * 0 - dclk is divided by 9 */
   input           a_ar10_b0,      // Graphics mode bit
   input           a_ar10_b6,      // Pixel double clock select
   input           a_ar13_b3,      // Pixel panning control bits 3-0
   input           a_ar13_b2,
   input           a_ar13_b1,
   input           a_ar13_b0,
   input           cr14_b5,        // count by four
   input           cr17_b3,        // count by two
   input           c_ahde_1,       // advance horiz display enable
   input           c_ahde_1_u,     // advance horiz display enable
   input           h_hclk,         // Host clock
   input           ade,            // advance display enable
   input           screen_off,
   input           pel_pan_en,
   input           dclk_en,        // dot clock
   input [15:0]    h_io_dbus,      // data bus	 	 
   
   output [7:0]    reg_misc,
   output          c_9dot,         // 9-dot character clock
   output          misc_b0,        // Address select bit.  0- 3bx, 1- 3dx
   output          misc_b6,        // Horizontal sync. polarity
   output          misc_b7,        // Vertical sync. polarity
   output          c_mis_3c2_b5,   // Odd/Even page select
   output 	   clk_sel_ctl,    // These 4 bits select the clock source
   output          cclk_en,        // character clock
   output          final_sh_ld,
   output          final_crt_rd,
   output          c_misc_b1,
   output          pre_load
   );

  

  reg [4:0]        cntr_op_ff;  	 // Character counter FF's.
  reg              detect_s3_s7_s8_ff;
  reg [1:0] 	   sync1;
  reg [1:0] 	   sync2;
  reg [1:0] 	   sync4;
  reg [1:0] 	   sync5;
  reg [1:0] 	   sync6;
  reg [1:0] 	   sync7;
  reg [1:0] 	   sync8;
  reg [1:0] 	   sync9;
  reg [1:0] 	   sync10;
  reg [1:0] 	   sync11;
  reg [1:0] 	   sync12;
  reg 		   shift_ld_del;
  reg 		   detect_del;
  reg [1:0] 	   sh_cnt;
  reg [1:0] 	   cr_cnt;
  reg 		   cr_1_of_4_dly1;
  reg 		   cr_1_of_4_dly2;

  wire             sh_1_of_4; // generation of shift load signals
  wire             sh_1_0f_2;
  wire             int_shift_ld;
  wire             mid_shift_ld;
  wire             cr_1_of_4; // generation of crt read signals
  wire             cr_1_0f_2;
  wire             int_crt_rd;
  wire             mid_crt_rd;
  wire [3:0]       pp_mux_ctl; // pixel panning mux control
  wire             shift_ld;
  wire             crt_rd;
  wire             cntr_rst_n;
  wire             clk_ctl;        // control signal of a mux
  wire             detect_3;       // Set when cntr_op_ff = 5'b000_11
  wire             cntr_din_3;
  wire             cntr_din_0;
  wire             cntr_din_1;
  wire             state_8;       //  000_11 
  wire             state_7;       //   0001
  wire             state_3;
  wire             detect_s7_s8;
  wire             detect_s3_s7_s8;
  wire             state_8i;       //  000_11 
  wire             state_7i;       //   0001
  wire             state_3i;
  wire             detect_s7_s8i;
  wire             detect_s3_s7_s8i;
  wire             mode_13_ctl;



  wire             sh_ld_32 = m_sr01_b4;
  wire             sh_ld_16 = m_sr01_b2;
  wire             cnt_by_4 = cr14_b5;
  wire             cnt_by_2 = cr17_b3;
  wire             by_8_or_9 = m_sr01_b0; // if by_8_or_9 = 1 then 1/8 else 1/9
  wire             by_4      = 1'b0; // if by_4 = 1 then 1/4
  wire             mode_13_ctl_syn_cclk;
  wire             a_ar13_b3_syn_cclk;
  wire             a_ar13_b2_syn_cclk;
  wire             a_ar13_b1_syn_cclk;
  wire             a_ar13_b0_syn_cclk;
  wire             sh_ld_32_syn_cclk;
  wire             sh_ld_16_syn_cclk;
  wire             cnt_by_4_syn_cclk;
  wire             cnt_by_2_syn_cclk;
  wire             by_8_or_9_syn_cclk;
  wire             by_4_syn_cclk;
  wire [3:0]       int_pp_mux_ctl;
  
  reg [6:0] 	   store_misc;

  assign 	   reg_misc = store_misc;

  // Instantiating the registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      store_misc <= 7'h0;
    end else if (h_io_wr) begin
      case (h_addr)

	16'h03c2: store_misc <= {h_io_dbus[7:5], h_io_dbus[3:0]};
	default:  store_misc <= store_misc; // stop linter
      endcase // case(h_addr)
    end
  
      
  // Synchronizing control register bits w.r.t cclk
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      sync1  <= 2'b0;
      sync2  <= 2'b0;
      sync4  <= 2'b0;
      sync5  <= 2'b0;
      sync6  <= 2'b0;
      sync7  <= 2'b0;
      sync8  <= 2'b0;
      sync9  <= 2'b0;
      sync10 <= 2'b0;
      sync11 <= 2'b0;
      sync12 <= 2'b0;
    end else if (cclk_en) begin
      sync1  <= {sync1[0],  sh_ld_32};
      sync2  <= {sync2[0],  sh_ld_16};
      sync4  <= {sync4[0],  cnt_by_4};
      sync5  <= {sync5[0],  cnt_by_2};
      sync6  <= {sync6[0],  by_8_or_9};
      sync7  <= {sync7[0],  by_4};
      sync8  <= {sync8[0],  a_ar13_b0};
      sync9  <= {sync9[0],  a_ar13_b1};
      sync10 <= {sync10[0], a_ar13_b2};
      sync11 <= {sync11[0], a_ar13_b3};
      sync12 <= {sync12[0], mode_13_ctl};
    end

  assign sh_ld_32_syn_cclk    = sync1[1];
  assign sh_ld_16_syn_cclk    = sync2[1];
  assign cnt_by_4_syn_cclk    = sync4[1];
  assign cnt_by_2_syn_cclk    = sync5[1];
  assign by_8_or_9_syn_cclk   = sync6[1];
  assign by_4_syn_cclk        = sync7[1];
  assign a_ar13_b0_syn_cclk   = sync8[1];
  assign a_ar13_b1_syn_cclk   = sync9[1];
  assign a_ar13_b2_syn_cclk   = sync10[1];
  assign a_ar13_b3_syn_cclk   = sync11[1];
  assign mode_13_ctl_syn_cclk = sync12[1];
  
  assign c_misc_b1 = reg_misc[1];
  assign misc_b0 = reg_misc[0];
  assign misc_b6 = reg_misc[6];
  assign misc_b7 = reg_misc[7];   
  assign c_mis_3c2_b5 = reg_misc[5];

  // Generating external clock selection control signals
  
  assign           clk_ctl = (reg_misc[3:2] == 2'b11);
  assign           clk_sel_ctl = clk_ctl ? 1'b0 : reg_misc[2];
  
  
  // Generating character clock using Gray counter( Johnson counter )
  assign           detect_3 = (cntr_op_ff == 5'b000_11);

  assign           cntr_din_3 = by_8_or_9_syn_cclk ? (~cntr_op_ff[0]) : cntr_op_ff[4];

  // if by_8_or_9 is true then cntr_din_0 = cntr_op_ff[1] otherwise
  // cntr_din_0 = cntr_op_ff[1] if detect_3 is false. If detect_3 is true 
  // and by_8_or_9 is false then cntr_din_0 = 0;
  // Using this logic we are detecting 000_11 and then forcing the
  // counter to 000_00;
  
  assign           cntr_din_0 = by_8_or_9_syn_cclk ? cntr_op_ff[1] :
                   (cntr_op_ff[1] & (~detect_3));

  // If by_4 is true then cntr_din_1 = ~cntr_op_ff[0] otherwise
  // cntr_din_1 = cntr_op_ff[2]. This logic is to generate 4 dot
  // character clock
  
  assign           cntr_din_1 = by_4_syn_cclk ? ~cntr_op_ff[0] : cntr_op_ff[2];
  
  always @(posedge t_crt_clk or negedge h_reset_n )
    if(~h_reset_n)
      cntr_op_ff <= 5'b0;
    else if (dclk_en) begin
      cntr_op_ff[4] <=  (~cntr_op_ff[0]);
      cntr_op_ff[3] <=  cntr_din_3;
      cntr_op_ff[2] <=  cntr_op_ff[3];
      cntr_op_ff[1] <=  cntr_din_1;
      cntr_op_ff[0] <=  cntr_din_0;	
    end
  
  // Detecting state_7 in case of 8_dot and state_8 in case of 9_dot.
  // Detecting state_3 in case of 4_dot

  // This set of states are for being used synchronously
  assign state_7i = dclk_en & (~cntr_op_ff[3])&(~cntr_din_1)&(cntr_din_0);
  assign state_8i = dclk_en & (~cntr_din_3)&(~cntr_op_ff[3])&(cntr_din_1);
  assign state_3i = dclk_en & (~cntr_din_1 & cntr_din_0);
  assign detect_s7_s8i      = by_8_or_9_syn_cclk ? state_7i : state_8i;
  assign detect_s3_s7_s8i   = by_4_syn_cclk ? state_3i : detect_s7_s8i;

  assign state_7 = (~cntr_op_ff[2])&(~cntr_op_ff[1])&(cntr_op_ff[0]);
  assign state_8 = (~cntr_op_ff[3])&(~cntr_op_ff[2])&(cntr_op_ff[1]);
  assign state_3 = (~cntr_op_ff[1] & cntr_op_ff[0]);
  assign detect_s7_s8      = by_8_or_9_syn_cclk ? state_7 : state_8;
  assign detect_s3_s7_s8   = by_4_syn_cclk ? state_3 : detect_s7_s8;
  
  always@( posedge t_crt_clk or negedge h_reset_n )
    if(~h_reset_n)
      detect_s3_s7_s8_ff <=  1'b0;
    else if (dclk_en)
      detect_s3_s7_s8_ff <=  (detect_s3_s7_s8 & ade & (~screen_off));

  assign cclk_en = cntr_op_ff[0] & ~cntr_din_0 & dclk_en;
  assign shift_ld = detect_s3_s7_s8 & (~screen_off);
  assign crt_rd   = detect_s3_s7_s8_ff;

  // Generate a registered version for edge detection
  always @(posedge t_crt_clk) begin
    shift_ld_del <= detect_s3_s7_s8i & ~screen_off;
    detect_del   <= detect_s3_s7_s8 & ade & ~screen_off;
  end
  
  // Instantiating a 2-bit up counters for countby2/4 & shift16/32.
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)     sh_cnt <= 2'b0;
    else if (~c_ahde_1) sh_cnt <= 2'b0;
    else if (shift_ld_del & 
	     ~(detect_s3_s7_s8i & ~screen_off)) sh_cnt <= sh_cnt + 1;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)     cr_cnt <= 2'b0;
    else if (~c_ahde_1) cr_cnt <= 2'b0;
    else if (detect_del & 
	     ~(detect_s3_s7_s8 & ade & ~screen_off)) cr_cnt <= cr_cnt + 1;
  
  assign cntr_rst_n = h_reset_n & c_ahde_1;

  // if sh_ld_32 is true generate 1 out of 4.
  // if sh_ld_16 is true generate 1 out of 2.
  
  assign sh_1_of_4 = (~sh_cnt[1]) & (sh_cnt[0]); // detect 01
  assign sh_1_0f_2 = sh_cnt[0]; // detect 11 or  01
  
  assign int_shift_ld = sh_ld_32_syn_cclk ? sh_1_of_4 : sh_1_0f_2;
  assign mid_shift_ld = (sh_ld_16_syn_cclk | sh_ld_32_syn_cclk) ? (int_shift_ld & shift_ld) : shift_ld;
  
  // if cnt_by_4 is true generate 1 out of 4.
  // if cnt_by_2 is true generate 1 out of 2.
  
  assign cr_1_of_4 = (~cr_cnt[1]) & (cr_cnt[0]); // detect 01

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      cr_1_of_4_dly1 <= 1'b0;
      cr_1_of_4_dly2 <= 1'b0;
    end else if (~c_ahde_1_u) begin
      cr_1_of_4_dly1 <= 1'b0;
      cr_1_of_4_dly2 <= 1'b0;
    end else if (detect_del & 
		 ~(detect_s3_s7_s8 & ade & ~screen_off)) begin
      cr_1_of_4_dly1 <= cr_1_of_4;
      cr_1_of_4_dly2 <= cr_1_of_4_dly1;
    end
  
  assign cr_1_0f_2 = cr_cnt[0]; // detect 11 or  01
  
  assign int_crt_rd = cnt_by_4_syn_cclk ? cr_1_of_4_dly2 : cr_1_0f_2;
  
  assign mid_crt_rd = ( cnt_by_4_syn_cclk | cnt_by_2_syn_cclk ) ? (int_crt_rd & crt_rd) : crt_rd;

  // Mode 13 is true if a_ar10_b0 & a_ar10_b6 are true
  assign mode_13_ctl = a_ar10_b0 & a_ar10_b6;
  

  // Realizing the pixel panning
  
  assign int_pp_mux_ctl = { a_ar13_b3_syn_cclk, a_ar13_b2_syn_cclk,
                            a_ar13_b1_syn_cclk,
                            ( a_ar13_b0_syn_cclk & (~mode_13_ctl_syn_cclk) ) };
  
  assign pp_mux_ctl[3:0] = ~(line_cmp & pix_pan) ? int_pp_mux_ctl[3:0] : 4'b0;
  
  pixel_panning SH_LD_PP
    (
     .din             (mid_shift_ld),
     .clk             (t_crt_clk),
     .clk_en          (dclk_en),
     .pp_ctl          (pp_mux_ctl),
     .mode_13_ctl     (mode_13_ctl_syn_cclk),
     .r_n             (h_reset_n),
     .by_4_syn_cclk   (by_4_syn_cclk),

     .dout            (final_sh_ld),
     .dout_1          (pre_load)
     );

  pixel_panning CRT_RD_PP
    (
     .din             (mid_crt_rd),
     .clk             (t_crt_clk),
     .clk_en          (dclk_en),
     .pp_ctl          (pp_mux_ctl),
     .mode_13_ctl     (mode_13_ctl_syn_cclk),
     .r_n             (h_reset_n),
     .by_4_syn_cclk   (by_4_syn_cclk),
     .dout            (final_crt_rd),
     .dout_1          ()
     );


  assign c_9dot    = (~by_8_or_9_syn_cclk);
  
endmodule
