/////////////////////////////////////////////////////////////////////////////
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
//  Title       :  Clock switch module for non programmable PLLs
//  File        :  clk_switch.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2009
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module takes in the pixel clock and generates an enable signal
//  which becomes the effective CRT clock. 
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
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 10 ps

module clk_switch
  (
   input            pll_clock,
   input [1:0]      bpp,
   input            vga_mode,

   output           pix_clk,
   output           pix_clk_vga,
   output reg       crt_clk
   );


reg	[1:0]	crt_divider;
reg	[2:0]	crt_counter;

always @*
	begin
   		casex({vga_mode, bpp})
   		3'b1_xx: crt_divider = 2'b00;
   		3'b0_01: crt_divider = 2'b10;
   		3'b0_10: crt_divider = 2'b01;
   		default: crt_divider = 2'b00;
		endcase
	end

  // create 2 outputs so we can run them at different speeds for timing
  assign pix_clk     = pll_clock;
  assign pix_clk_vga = pll_clock;

  // this is only good for FPGA, need to change for asic implementation
  initial begin
    crt_counter = 0;
  end
  
  always @(posedge pll_clock) begin
    crt_counter <= crt_counter + 1;
    case (crt_divider)
      0: crt_clk <= 1'b1;
      1: crt_clk <= ~crt_counter[0];
      2: crt_clk <= ~|crt_counter[1:0];
      3: crt_clk <= ~|crt_counter[2:0];
    endcase // case(int_crt_divider)
  end

endmodule // clk_switch

