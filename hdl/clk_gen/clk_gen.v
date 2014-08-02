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
//  Title       :  Graphics core top level
//  File        :  graph_core.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module takes in up to 6 PLL derived clocks plus a master clock (PCI).
//  This module allows the glitchless switching amongst the clock frequencies.
//  The purpose of this is to allow an FPGA w/o a programmable PLL 
// (ex Cyclone2) to provide us with a variety of frequencies for generating
//  Pixel clock and CRT clocks.
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

module clk_gen
  (
   input            hb_clk,
   input            hb_resetn,
   input            pll_locked,
   input [1:0]      bpp,
   input [13:0]     hactive_regist,
   input [2:0]      pixclksel,
   input            vga_mode,
   input [1:0]	    int_fs,
   input 	    sync_ext,
   input            pix_clk,

   output           pix_clk_vga,
   output reg       crt_clk,
   output reg       locked,
   output reg [2:0] 	    int_clk_sel   // internal snapshot of clksel
   );


  reg [2:0]	    horiz_actv_decode;
  reg [2:0] 	    current, next; // State variables
  reg 		    set_clock; // set the current clock register
  reg [1:0] 	    int_crt_divider; // internal snapshot of crt_divider
  reg [5:0] 	    counter;
  reg [7:0] 	    neg_enable;
  reg [7:0] 	    neg_enable_0;
  reg [7:0] 	    neg_enable_1;
  reg [1:0] 	    crt_count0;
  reg [1:0] 	    crt_count1;
  reg [1:0] 	    crt_count2;
  reg [1:0] 	    crt_count3;
  reg [1:0] 	    crt_count4;
  reg [1:0] 	    crt_count5;
  reg [1:0] 	    crt_count6;
  reg [1:0] 	    crt_count7;
  reg [2:0] 	    crt_counter;
  reg [1:0]         crt_divider;
  reg [2:0]         clk_sel;
  
  wire [7:0] 	    gated_clocks;

  parameter 	    IDLE          = 3'b000,
		    ENABLE_CLOCK  = 3'b001,
		    WAIT4CHANGE   = 3'b010,
		    WAIT4QUIET    = 3'b011,
		    WAIT4QUIET2   = 3'b100;
  
wire int_fs_1 = int_fs[1];

`include "hres_table_4clk.h"

always @*
	begin
   		casex({vga_mode, bpp})
   		3'b1_xx: crt_divider = 2'b00;
   		3'b0_01: crt_divider = 2'b10;
   		3'b0_10: crt_divider = 2'b01;
   		default: crt_divider = 2'b00;
		endcase
	end

always @*
	begin
   		casex({vga_mode, pixclksel, sync_ext, int_fs_1})
		// VGA Core resolutions.
		6'b1_001_0_x:		clk_sel = 3'b001; // External  25.17MHz (640x480 60Hz).
		6'b1_100_0_x:		clk_sel = 3'b001;
		6'b1_001_1_x:		clk_sel = 3'b010; // External  28MHz(720x480 60Hz).
		6'b1_100_1_x:		clk_sel = 3'b010;
		6'b1_011_x_0:		clk_sel = 3'b001; // Internal  25MHz (640x480 60Hz).
		6'b1_101_x_0:		clk_sel = 3'b001;
		6'b1_011_x_1:		clk_sel = 3'b010; // Internal  28MHz (720x480 60Hz).
		6'b1_101_x_1:		clk_sel = 3'b010;
		default:		clk_sel = horiz_actv_decode;
		endcase
	end


  always @(posedge hb_clk or negedge hb_resetn)
    if (!hb_resetn) begin
      current     <= IDLE;
      int_clk_sel <= 3'b0;
      locked      <= 1'b0;
    end else begin
      locked <= current == IDLE;
      
      current <= next;
      if (set_clock) begin
	int_clk_sel <= clk_sel;
	int_crt_divider <= crt_divider;
      end

      // counter for waiting for clocks to be quiet
      if (current == WAIT4CHANGE || current == IDLE) 
	counter <= 6'h0;
      else if (current == WAIT4QUIET ||
	       current == WAIT4QUIET2) 
	counter <= counter + 6'h1;
    end

  always @* begin
    set_clock = 1'b0;
    next = current;
    case (current)
      IDLE: begin
	// Wait for the PLLS to lock, then enable the current PLL
	if (pll_locked) begin
	  next = WAIT4QUIET;
	end else
          next = IDLE;
      end
      ENABLE_CLOCK: begin
	next = WAIT4CHANGE;
      end
      WAIT4CHANGE: begin
	if ((clk_sel != int_clk_sel) || (crt_divider != int_crt_divider)) begin
	  // we've detected a change, disable all clocks
//	  set_clock = 1'b1;
	  next = WAIT4QUIET;
	end else	  
	  next = WAIT4CHANGE;
      end
      WAIT4QUIET: begin
	if (&counter[4:0]) begin
	  next = WAIT4QUIET2;
	  set_clock = 1'b1;
	end else
          next = WAIT4QUIET;
      end
      WAIT4QUIET2: begin
	if (&counter) begin
	  next = ENABLE_CLOCK;
	end else
          next = WAIT4QUIET2;
      end
    endcase // case(current)
  end


  always @(posedge pix_clk or negedge hb_resetn)
	begin
		if(!hb_resetn)
			begin
      				crt_clk <= 1'b1;
    				crt_counter <= 3'b000;
			end
		else begin
    				crt_counter <= crt_counter + 3'h1;
    				case (int_crt_divider)
      				0: crt_clk <= 1'b1;
      				1: crt_clk <= ~crt_counter[0];
      				2: crt_clk <= ~|crt_counter[1:0];
      				3: crt_clk <= ~|crt_counter[2:0];
    				endcase // case(int_crt_divider)
		end
  	end

endmodule // clk_switch

