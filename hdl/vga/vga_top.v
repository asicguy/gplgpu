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
//  Title       :  VGA Top Level
//  File        :  vga_top.v
//  Author      :  Frank Bruno
//  Created     :  11-Jun-2002
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : This file is the top level stimulus file for Borealis
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//  vga            - VGA Core
//  vga_hint       - VGA Hist interface gasket
//  vga_mint       - VGA Memory Controller interface
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
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 10 ps
 
module vga_top
  (
   input		sense_n,	// RAMDAC Sense Pin
   input		mclock,		// Memory controller clock
   input		resetn,		// System Reset
   input		hclk,		// PCI Host Clock
   input		crtclk,		// CRT Clock
   input		vga_req,	// VGA request
   input		vga_rdwr,	// VGA write/read cycle
   input		vga_mem,	// VGA memory/io cycle
   input [3:0] 	        hst_byte,	// Host byte enables
   input [22:0] 	hst_addr,	// Host address (byte address)
   input [31:0] 	hst_din,	// Data from HBI to VGA_HINT
   input [31:0] 	mem_din,	// Data from MC  to VGA
   input 	        mem_ack,        // Memory Acknowledge
   input 	        mem_ready_n,    // VGA data ready
   input                vga_en,         // Signal to disable VGA crt and ref R
   input                mem_ready,      // MC is ready
   
   output [31:0]        hst_dout,	// Data from VGA_HINT to HBI
   output [2:0] 	vga_stat,	/* VGA status back to HBI 
					 * [1:0]=CTL_BITS[1:0] spec 
					 *       CTL_BITS[4:2] not used here
					 * [2]=  CTL_BITS[5] see spec */
   output 	        vga_push,	// VGA push for read data
   output 	        vga_ready,	// VGA Ready for next cycle
   output 	        v_clksel,	// VGA frequency Selects
   output [7:0] 	v_pd,		// VGA Pixel Data
   output 	        v_blank,	// VGA Blank
   output 	        v_hrtc,		// VGA Hsync
   output 	        v_vrtc,		// VGA Vsync
   output 	        mem_req,        // Request a memory cycle
   output 	        vga_rd_wrn,     // Read or write
   output [17:0]        vga_addr,	// Address lines to memory
   output [3:0] 	vga_we,		// Write enables for each byte
   output [31:0]        vga_data_in     // Data from VGA core to VGA_MINT
   );
   
  /* Internal VGA core signals */
  wire [3:0] 	dummy_we;       // just to stop warnings
  wire [31:0] 	vga_hst_din;	// Data from VGA_HINT to VGA core
  wire [31:0] 	vga_hst_dout;	// Data from VGA core to VGA_HINT
  wire [22:0] 	haddr;		// 23 bit address lines from Host
  wire [3:0] 	byte_en;	// Byte enable signals
  wire 		hst_mem_io;	// memory access or IO access. 1 - Mem, 0 - IO.
  wire 		hst_rd_wr;	// 1 - read, 0 - write
  wire 		vga_sel;	/* Valid address has been decoded in
				 * SVGA memory or IO space */
  wire 		vga_ready_n;	/* Indicates that the SVGA core has completed 
				 * the current cycle and is ready for the 
				 * next cycle */
  wire [5:0] 	vga_cntrl_tmp;	

  assign 	vga_stat = { vga_cntrl_tmp[5],  vga_cntrl_tmp[1:0]};

  vga_hint U_HINT
    (
     .hclk		(hclk), 
     .resetn		(resetn), 
     .vga_req_0		(vga_req), 
     .vga_rdwr		(vga_rdwr), 
     .vga_mem		(vga_mem), 
     .hst_byte		(hst_byte), 
     .hst_din		(hst_din),
     .hst_addr		(hst_addr), 
     .mclock		(mclock), 
     .vga_hst_dout	(vga_hst_dout), 
     .vga_ready_n	(vga_ready_n),

     .hst_dout		(hst_dout), 
     .vga_hst_din	(vga_hst_din), 
     .haddr		(haddr), 
     .vga_sel		(vga_sel), 
     .hst_rd_wr		(hst_rd_wr), 
     .byte_en		(byte_en),
     .hst_mem_io	(hst_mem_io), 
     .vga_ready_2 	(vga_ready), 
     .vga_push_1	(vga_push)
     );

  vga U_VGA
    (
     .t_haddr		(haddr),
     .t_byte_en_n	(byte_en),
     .t_mem_io_n	(hst_mem_io),
     .t_hrd_hwr_n	(hst_rd_wr),
     .t_hreset_n	(resetn),
     .t_mem_clk		(mclock),
     .t_svga_sel	(vga_sel),
     .t_crt_clk		(crtclk),
     .t_sense_n		(sense_n),
     .svga_ack	        (mem_ack),
     .t_data_ready_n	(mem_ready_n),
     .m_t_mem_data_in	(mem_din),
     .t_hdata_in	(vga_hst_din),
     .vga_en            (vga_en),
     .mem_ready         (mem_ready),
     
     .m_t_mem_data_out	(vga_data_in),    
     .t_hdata_out	(vga_hst_dout),
     .c_t_clk_sel	(v_clksel),
     .c_t_cblank_n	(v_blank),
     .c_t_hsync		(v_hrtc),
     .c_t_vsync		(v_vrtc),
     .h_t_ready_n	(vga_ready_n),
     .a_t_pix_data	(v_pd),
     .m_t_mem_addr	(vga_addr),
     .m_t_mwe_n		({dummy_we, vga_we}),
     .m_t_svga_req	(mem_req),
     .g_t_ctl_bits	(vga_cntrl_tmp),
     .m_mrd_mwr_n	(vga_rd_wrn)
     );

endmodule


