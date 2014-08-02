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
//  Title       :  Clock Selection Logic
//  File        :  clk_sel.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   crt_2_clk, crt_4_clk are generated from t_crt_clk.
//   It also selects a clock between t_crt_clk, crt_2_clk and crt_4_clk
//   based on {m_sr01_b3 , a_ar10_b6} bits and generates pclk. 
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
  module clk_sel
    (
     input         h_reset_n,
     input         t_crt_clk,
     input         m_sr01_b3,       /* Dot clock divided by 2. 
				     * 1 -- 1/2  0 -- no division */
     input         a_ar10_b6,       // Pixel double clock select
     input         final_sh_ld,
     input 	   pre_load,        // unregistered version of final_sh_ld
     input 	   cclk_en,         // Enable signal for cclk
     
     output        sel_sh_ld,       // c_shift_ld pulse
     output reg    sel_sh_ld_pulse, // c_shift_ld pulse
     output reg    dclk_en,         // dot clock
     output reg    pclk_en          // pixel clock
     );
  
  reg [1:0] clk_sel_reg;
  reg 	    crt_2_clk_ff;   // t_crt_clk div 2 sync. w.r.t final_sh_ld
  reg [3:0] crt_4_clk_ff;
  reg 	    sel_sh_ld_pulse_store;
  reg 	    int_sh_ld_ff;   // final_sh_ld delayed t_crt_clk
  reg 	    sh_ld_ctl_ff;   // sh_ld gen. control signal
  reg 	    sel_sh_ld_reg;
  
  wire 	    sh_ld;          // final_sh_ld the width of one t_crt_clk
  wire 	    dclk_by_2 = m_sr01_b3;
  wire 	    crt_2_clk_ff_din;
  wire 	    crt_4_clk_ff_din;
  wire [1:0] clk_sel_ctl = { a_ar10_b6, dclk_by_2 } ;
  // 00 -- crt_clock
  // 01 -- crt_2_clk
  // 10 -- crt_2_clk
  // 11 -- crt_4_clk
  
  // Dotclock (dclk) is either 1x or 0.5x of the crt clk
  // The enable will be held high for 1x operation and toggled for 0.5x
  // operation
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)     dclk_en <= 1'b0;
    else if (dclk_by_2) dclk_en <= ~dclk_en;
    else                dclk_en <= 1'b1;

  //Synchronous serializer shift pixel clock switch between 1X, 1/2X  and 1/4X 
  // of crt_clk.
  always @(posedge t_crt_clk) 
    if (~crt_2_clk_ff & ~crt_4_clk_ff[1]) clk_sel_reg <= clk_sel_ctl;

  always @*
    case (clk_sel_reg)
      2'd0: pclk_en = 1'b1;
      2'd1: pclk_en = crt_2_clk_ff;
      2'd2: pclk_en = crt_2_clk_ff;
      2'd3: pclk_en = crt_4_clk_ff[3];
    endcase // case(clk_sel_reg)
  
  // Generate sh_ld from final_sh_ld whose width is only one crt_clk.
  always @( posedge t_crt_clk or negedge h_reset_n )
    if(~h_reset_n)
      int_sh_ld_ff <= 1'b0;
    else
      int_sh_ld_ff <= final_sh_ld;
	 

  // Sync. dclk_by_2 w.r.t falling edge of final_sh_ld
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      sh_ld_ctl_ff <= 1'b0;
    else if (pre_load & ~final_sh_ld & cclk_en)
      // This is equivalent to posedge of final_sh_ld (hopefully)
      sh_ld_ctl_ff <= dclk_by_2;
  
  assign     sh_ld = sh_ld_ctl_ff ? (int_sh_ld_ff & final_sh_ld) : final_sh_ld;
  
  // crt clock is divided by 2 to get crt_2_clk. crt_2_clk generation is sync.
  // w.r.t sh_ld.
  always @( posedge t_crt_clk or negedge h_reset_n )
    if(~h_reset_n)
      crt_2_clk_ff <= 1'b0;
    else
      crt_2_clk_ff <= ~crt_2_clk_ff;
  
  // crt clock is divided by 4 to get crt_2_clk. crt_2_clk generation is sync.
  // w.r.t sh_ld.
  always @( posedge t_crt_clk or negedge h_reset_n )
    if(~h_reset_n)
      crt_4_clk_ff <= 3'b0;
    else
      begin
	crt_4_clk_ff[0] <= ~|crt_4_clk_ff[2:0];
	crt_4_clk_ff[1] <= crt_4_clk_ff[0];
	crt_4_clk_ff[2] <= crt_4_clk_ff[1];
	crt_4_clk_ff[3] <= crt_4_clk_ff[2];
      end
  
  always @( posedge t_crt_clk or negedge h_reset_n )
    if(~h_reset_n) begin
      sel_sh_ld_reg <= 1'b0;
      sel_sh_ld_pulse <= 1'b0;
      sel_sh_ld_pulse_store <= 1'b0;
    end else begin
      if (pclk_en) sel_sh_ld_reg <= 1'b0;
      else if (final_sh_ld)  sel_sh_ld_reg <= 1'b1;

      if (final_sh_ld & ~sel_sh_ld_pulse_store) begin
	sel_sh_ld_pulse_store <= 1'b1;
	sel_sh_ld_pulse <= 1'b1;
      end else begin
	// This will hold the pulse signal until pclk_en has been generated
	sel_sh_ld_pulse <= 1'b0;
	if (~final_sh_ld) sel_sh_ld_pulse_store <= 1'b0;
      end
    end
  
  assign sel_sh_ld = final_sh_ld | sel_sh_ld_reg;
  
endmodule
