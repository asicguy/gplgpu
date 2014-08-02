/////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2005
//
//  Title       :  Clock switch module for non programmable PLLs
//  File        :  clk_switch.v
//  Author      :  Jim MacLeod
//  Created     :  05-Mar-2013
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
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

module clk_gen_ipll
  (
   input            hb_clk,
   input            hb_resetn,
   input            refclk,
   input [1:0]      bpp,
   input            vga_mode,
   input	    write_param, 	// input
   input [3:0]	    counter_type, 	// input [3:0]
   input [2:0]	    counter_param,	// input[2:0]
   input [8:0]	    data_in,		// input [8:0],
   input 	    reconfig,		// input.
   input 	    pll_areset_in,	// input.

   output	    busy,		// Input busy.
   output           pix_clk,
   output           pix_clk_vga,
   output reg       crt_clk,
   output           pix_locked
   );

pix_pll_rc_top u_pix_pll_rc_top
	(
	.hb_clk			(hb_clk),
	.hb_rstn		(hb_resetn),
	.ref_clk		(refclk),
	.reconfig		(reconfig),
	.write_param		(write_param),
	.counter_param		(counter_param),// Input [2:0]
	.counter_type		(counter_type),	// Input [3:0]
	.data_in		(data_in),	// Input [8:0]
	.pll_areset_in		(pll_areset_in),

	.busy			(busy),		// output.
	.pix_clk		(pix_clk),	// output.
	.pix_locked		(pix_locked)	// output.
	);


  reg [2:0] 	    crt_counter;
  reg [1:0]         crt_divider;

always @*
	begin
   		casex({vga_mode, bpp})
   		3'b1_xx: crt_divider = 2'b00;
   		3'b0_01: crt_divider = 2'b10;
   		3'b0_10: crt_divider = 2'b01;
   		default: crt_divider = 2'b00;
		endcase
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
    				case (crt_divider)
      				0: crt_clk <= 1'b1;
      				1: crt_clk <= ~crt_counter[0];
      				2: crt_clk <= ~|crt_counter[1:0];
      				3: crt_clk <= ~|crt_counter[2:0];
    				endcase
		end
  	end

endmodule

