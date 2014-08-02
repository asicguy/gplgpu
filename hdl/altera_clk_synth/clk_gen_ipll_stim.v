/////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2005
//
//  Title       :  Clock switch module for non programmable PLLs
//  File        :  clk_switch.v
//  Author      :  Frank Bruno
//  Created     :  05-Mar-2005
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

module clk_gen_ipll_stim;

   reg              hb_clk;
   reg              hb_resetn;
   reg              refclk;
   reg [1:0]        bpp;
   reg              vga_mode;
   reg [1:0]	    int_fs;
   reg 	            sync_ext;
   reg [2:0]	    pixclksel;		// input [2:0] 001= comp-ext,  100 = std-ext
					// 011= comp-int,  101 = std-int
   reg	    	    ext_fs;
   reg [7:0]	    pixreg20;		// Input [7:0]
   reg [7:0]	    pixreg21;		// Input [7:0]
   reg [7:0]	    pixreg22;		// Input [7:0]
   reg [7:0]	    pixreg23;		// Input [7:0]
   reg [7:0]	    pixreg24;		// Input [7:0]
   reg [7:0]	    pixreg25;		// Input [7:0]
   reg [7:0]	    pixreg26;		// Input [7:0]
   reg [7:0]	    pixreg27;		// Input [7:0]

   wire           pix_clk;
   wire           pix_clk_vga;
   wire           crt_clk;
   wire           pix_locked;

   wire	[2:0]	counter_param;
   wire [3:0]	counter_type;
   wire [8:0]	data_in;

	    parameter tcp = 26.67;

clk_gen_ipll u_clk_gen_ipll
  (
   .hb_clk		(hb_clk),
   .hb_resetn		(hb_resetn),
   .refclk		(refclk),
   .bpp			(bpp),
   .vga_mode		(vga_mode),
   .int_fs		(int_fs),
   .sync_ext		(sync_ext),
   .pixclksel		(pixclksel),
   .ext_fs		(ext_fs),
   .pixreg20		(pixreg20),
   .pixreg21		(pixreg21),
   .pixreg22		(pixreg22),
   .pixreg23		(pixreg23),
   .pixreg24		(pixreg24),
   .pixreg25		(pixreg25),
   .pixreg26		(pixreg26),
   .pixreg27		(pixreg27),

   .pix_clk		(pix_clk),
   .pix_clk_vga		(pix_clk_vga),
   .crt_clk		(crt_clk),
   .pix_locked		(pix_locked)
   );


   always begin
	   #(tcp/2) begin
   		hb_clk = 0;
   		refclk = 0;
	   end
	   #(tcp/2) begin
   		hb_clk = 1;
   		refclk = 1;
	   end
   end

   initial begin

   refclk	= 1;
   hb_clk	= 1;
   hb_resetn	= 0;
   bpp  	= 1;
   vga_mode 	= 0;
   int_fs	= 0;
   sync_ext	= 0;
   pixclksel    = 3;		// input [2:0] 001= comp-ext,  100 = std-ext
   ext_fs	= 0;
   pixreg20 	= 8'h11;
   pixreg21 	= 8'h11;
   pixreg22 	= 8'h11;
   pixreg23 	= 8'h11;
   pixreg24 	= 8'h11;
   pixreg25 	= 8'h11;
   pixreg26 	= 8'h11;
   pixreg27 	= 8'h11;

   #((tcp * 10) + 2)
   	hb_resetn	= 1;
   #(tcp * 1000) 
   		pixreg21 = 8'h11;
   		pixreg20 = 8'hE7;
   #(tcp * 1000) $stop;

   end
/*
   PIXEL_CLK_25175		EQU	01015h	;  25.19531 MHz,  1.17188 MHz 
   PIXEL_CLK_28322		EQU	0122Ch	;  28.38540 MHz,  1.04167 MHz
   PIXEL_CLK_31500		EQU	00E1Dh	;  31.47320 MHz,  1.33929 MHz
   PIXEL_CLK_36000		EQU	00C1Bh	;  35.93750 MHz,  1.56250 MHz
   PIXEL_CLK_40000		EQU	00F3Fh	;  40.00000 MHz,  1.25000 MHz
   PIXEL_CLK_49500		EQU	0091Eh	;  49.47916 MHz,  2.08333 MHz
   PIXEL_CLK_50000		EQU	00C3Fh	;  50.00000 MHz,  1.56250 MHz
   PIXEL_CLK_54375		EQU	00A33h	;  54.37500 MHz,  1.87500 MHz
   PIXEL_CLK_56250		EQU	00713h	;  56.24999 MHz,  2.67857 MHz
   PIXEL_CLK_65000		EQU	00720h	;  64.95535 MHz,  2.67857 MHz
   PIXEL_CLK_72000		EQU	01284h	;  71.87500 MHz,  1.04170 MHz
   PIXEL_CLK_75000		EQU	0083Fh	;  75.00000 MHz,  2.34375 MHz
   PIXEL_CLK_78750		EQU	00A53h	;  78.75000 MHz,  1.87500 MHz
   PIXEL_CLK_80000		EQU	00F7Fh	;  80.00000 MHz,  1.25000 MHz
   PIXEL_CLK_88125		EQU	00A5Dh	;  88.12500 MHz,  1.87500 MHz
   PIXEL_CLK_94200		EQU	01FCDh	;  94.35480 MHz,  1.20968 MHz
   PIXEL_CLK_94500		EQU	00C78h	;  94.53125 MHz,  1.56250 MHz
   PIXEL_CLK_102778		EQU	01BC9h	; 102.77780 MHz,  1.38890 MHz
   PIXEL_CLK_108000		EQU	019C7h	; 108.00000 MHz,  1.50000 MHz
   PIXEL_CLK_108500		EQU	00750h	; 108.48212 MHz,  2.67857 MHz
   PIXEL_CLK_121500		EQU	019D0h	; 121.50000 MHz,  1.50000 MHz
   PIXEL_CLK_135000		EQU	00A87h	; 135.00000 MHz,  1.87500 MHz
   PIXEL_CLK_157500		EQU	00A93h	; 157.50000 MHz,  1.87500 MHz
   PIXEL_CLK_158400		EQU	016DCh	; 158.52269 MHz,  1.70455 MHz
   PIXEL_CLK_162000		EQU	019EBh	; 162.00000 MHz,  1.50000 MHz
   PIXEL_CLK_173000		EQU	00992h	; 172.91664 MHz,  2.08333 MHz
   PIXEL_CLK_175500		EQU	00BA6h	; 176.56813 MHz,  1.70455 MHz
   PIXEL_CLK_189000		EQU	019FDh	; 189.00000 MHz,  1.50000 MHz
   PIXEL_CLK_198000		EQU	0099Eh	; 197.91664 MHz,  2.08333 MHz
   PIXEL_CLK_202500		EQU	00FD0h	; 202.50000 MHz,  2.50000 MHz
   PIXEL_CLK_216000		EQU	015F8h	; 216.07140 MHz,  1.78571 MHz
   PIXEL_CLK_229500		EQU	011E7h	; 229.41173 MHz,  2.20588 MHz
*/
endmodule

