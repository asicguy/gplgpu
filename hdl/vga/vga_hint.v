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
//  Title       :  VGA Host Interface
//  File        :  vga_hint.v
//  Author      :  Frank Bruno
//  Created     :  12-29-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
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

  module vga_hint
    (
     input		hclk,		// Host Interface Clock
     input		resetn,		// PCI system resetn
     input		vga_req_0,	// Host VGA request
     input		vga_rdwr,	// Host VGA read/write request
     input		vga_mem,	// Host VGA memory request
     input	[3:0]	hst_byte,	// PCI Byte enables
     input	[31:0]	hst_din,	// PCI Data for writes
     input	[22:0]	hst_addr,	// PCI address
     input		mclock,		// Memory Clock
     input	[31:0]	vga_hst_dout,	// Data from VGA core 
     input		vga_ready_n,	// VGA cycle done
     
     output reg	[31:0]	hst_dout,	// Data to HBI
     output reg	[31:0]	vga_hst_din,	// Latched HBI data to VGA core
     output reg	[22:0]	haddr,		// Latched host addr
     output		vga_sel,	// VGA select (starts VGA host cycle)
     output reg		hst_rd_wr,	// VGA rd/wr cycle select
     output reg	[3:0]	byte_en,	// VGA data transfer size
     output reg		hst_mem_io,	// VGA mem/io cycle select
     output reg		vga_ready_2,
     output reg		vga_push_1
     );
  
  reg [2:0] 		cstate, nstate;
  reg 			done_0, done_1;
  reg 			toggle_req, toggle_done;
  reg 			req0, req1;
  reg 			vga_push_0;

  wire 			svga_req;	// Internal VGA request
  wire 			vga_clear;

  parameter 		
			/*
			 State bits are the concatination of:
			 {vga_sel, vga_clear, state[0]}
			 */
			vga_0 = 3'b010,
			vga_1 = 3'b110,
			vga_2 = 3'b011,
			vga_3 = 3'b001;

  // data block for register -- no protection for errant writes
  always @(posedge hclk)
    if (vga_req_0) begin
      vga_hst_din  <= hst_din;
      haddr        <= hst_addr;
      hst_rd_wr    <= vga_rdwr;
      hst_mem_io   <= vga_mem;
      byte_en      <= hst_byte;
    end

  always @(posedge hclk or negedge resetn)
    if (!resetn) begin
      toggle_req  <= 1'b0;
      vga_ready_2 <= 1'b1;
      done_0      <= 1'b0;
      done_1      <= 1'b0;
    end else begin

      done_0 <= toggle_done;
      done_1 <= done_0;

      if (vga_req_0) begin
	toggle_req  <= ~toggle_req;
	vga_ready_2 <= 1'b0;
      end else if (done_0 ^ done_1) vga_ready_2 <= 1'b1;
    end
  
  always @(posedge mclock or negedge resetn)
    if (!resetn) begin
      toggle_done <= 1'b0;
      req0 <= 1'b0;
      req1 <= 1'b0;
    end else begin
      req0 <= toggle_req;
      req1 <= req0;

      if (~vga_clear) toggle_done <= ~toggle_done;
    end

  always @(posedge mclock or negedge resetn)
    if (!resetn) cstate <= vga_0;
    else	 cstate <= nstate;

  assign svga_req = req0 ^ req1;
  
  always @* begin
    nstate = vga_0;
    case(cstate)
      vga_0: begin
	if (svga_req)     nstate = vga_1;
	else              nstate = vga_0;
      end 
      vga_1:              nstate = vga_2;
      vga_2: begin
	if (!vga_ready_n) nstate = vga_3;
	else              nstate = vga_2;
      end 
      vga_3:              nstate = vga_0;
      default:            nstate = vga_0; // stop linter
    endcase
  end

  assign vga_sel   = cstate[2];
  assign vga_clear = cstate[1];

  // Load data out register and generate vga_push signal
  always @(posedge mclock) begin
    if (!vga_ready_n) hst_dout <= vga_hst_dout;
    vga_push_1 <= vga_push_0 ;
    vga_push_0 <= ~vga_ready_n & hst_rd_wr;
  end

endmodule
