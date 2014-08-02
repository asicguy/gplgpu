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
//  Title       :  pixel panning
//  File        :  pixel_panning.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module realizes pixel panning both in text
//   and Graphics mode. THe pixel shifting to the left
//   or right is based on pixel panning control signals
//   and mode 13 control signals.
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
module pixel_panning
  (
   input 	   din,
   input 	   clk,         // dot clock
   input 	   clk_en,      // dot clock
   input [3:0]     pp_ctl,      // pixel panning control signals
   input 	   mode_13_ctl,
   input           r_n,
   input           by_4_syn_cclk,
   
   output 	   dout,
   output 	   dout_1
   );
  
  reg [8:0]            shift_ff;
  reg [7:0]            mux_ctl; // mux control signals
  
  wire [7:0]           int_d;
  wire [7:0]           mux_ctl_8_f_op;

  assign               int_d[7] = mux_ctl[7] ? din : shift_ff[8];
  assign               int_d[6] = mux_ctl[6] ? din : shift_ff[7];
  assign               int_d[5] = mux_ctl[5] ? din : shift_ff[6];
  assign               int_d[4] = mux_ctl[4] ? din : shift_ff[5];
  assign               int_d[3] = mux_ctl[3] ? din : shift_ff[4];
  assign               int_d[2] = mux_ctl[2] ? din : shift_ff[3];
  assign               int_d[1] = mux_ctl[1] ? din : shift_ff[2];
  assign               int_d[0] = mux_ctl[0] ? din : shift_ff[1];
  
  // Inferring 9 flops
  always@(posedge clk or negedge r_n) begin
    if(~r_n) shift_ff[8:0] <= 8'b0;
    else if (clk_en) begin
      shift_ff[8] <= din;
      shift_ff[7] <= int_d[7];
      shift_ff[6] <= int_d[6];
      shift_ff[5] <= int_d[5];
      shift_ff[4] <= int_d[4];
      shift_ff[3] <= int_d[3];
      shift_ff[2] <= int_d[2];
      shift_ff[1] <= int_d[1];
      shift_ff[0] <= int_d[0];	    
    end
  end

  assign mux_ctl_8_f_op = mode_13_ctl ? 8'b0001_0000 : 8'b0000_0000;

  // Realizing mux control signals
  always @(pp_ctl or mode_13_ctl or mux_ctl_8_f_op or by_4_syn_cclk) begin
    case(pp_ctl) // synopsys parallel_case 
      4'h0: mux_ctl = (by_4_syn_cclk) ? 8'b0000_1000 : 8'b1000_0000;
      4'h1: mux_ctl = 8'b0100_0000;
      4'h2: mux_ctl = (mode_13_ctl) ? 8'b0100_0000 : 8'b0010_0000;
      4'h3: mux_ctl = 8'b0001_0000;
      4'h4: mux_ctl = (mode_13_ctl) ? 8'b0010_0000 : 8'b0000_1000;
      4'h5: mux_ctl = 8'b0000_0100;
      4'h6: mux_ctl = (mode_13_ctl) ? 8'b0001_0000 : 8'b0000_0010;
      4'h7: mux_ctl = 8'b0000_0001;
      4'h8: mux_ctl = mux_ctl_8_f_op;
      4'h9: mux_ctl = mux_ctl_8_f_op;
      4'ha: mux_ctl = mux_ctl_8_f_op;
      4'hb: mux_ctl = mux_ctl_8_f_op;
      4'hc: mux_ctl = mux_ctl_8_f_op;
      4'hd: mux_ctl = mux_ctl_8_f_op;
      4'he: mux_ctl = mux_ctl_8_f_op;
      4'hf: mux_ctl = mux_ctl_8_f_op;
    endcase
  end
  assign dout = shift_ff[0];
  
  assign dout_1 = int_d[0];

endmodule
