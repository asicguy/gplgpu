//////////////////////////////////////////////////////////////////////////////
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
//  Title       :  Memory Controller Host Interface
//  File        :  mc_vga.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  The VGA generates one page read or write requests to the memory controller.
//  Unlike the other devices it hold the mem_req high and expects an active
//  low acknowledge and an active low data_ready. All requests are synchronous
//  to mclock.
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

module mc_vga
  (
   input	 mclock,        // The MC interface on the VGA is on Mclock
   input	 v_mclock,      // VGA memory controller clock
   input	 reset_n,         // Reset
   input         vga_req,       // A request issued from the VGA
   input 	 vga_rd_wrn,    // Read or Write_n request from the VGA
   input [17:0]	 vga_addr,      // Address requested
   input 	 vga_abort,     // Abort the current read
   input [3:0]	 vga_we,        // Write enables
   input [31:0]  vga_data_in,   // Datafrom VGA
   input 	 vga_gnt,       // VGA is granted the access
   input         vga_pop,       // VGA POP
   input         vga_push,      // VGA PUSH
   input [31:0]  read_data,     // Read data from the MFF
   input         init_done,     // Memory is up and running
   
   output reg	 vga_arb_req,   // MC internal request to arbiter
   output reg [17:0] vga_arb_addr,  // MC internal address to arbiter
   output reg 	 vga_arb_read,  // MC internal address to arbiter
   output reg	 vga_ack,       // Acknowledge request
   output reg	 vga_ready_n,   // Data from VGA is ready
   output [31:0] vga_data_out,  // Data out to the datapath
   output [3:0]  vga_wen,       // Write enables for VGA mode
   output [31:0] vga_data       // VGA data out to VGA
   );
  
  reg 		 capt_rw;       // Capture R/W signal
  reg 		 out_push;      // Ready to push request into FIFO
  reg 		 out_pop;       // Pop output fifo on MC side
  reg 		 make_req;      // Signal to make a request to arbiter
  reg [1:0] 	 out_cs, out_ns; // State variables
  reg [1:0] 	 in_cs;         // Small state machine for unloading FIFO
  reg 		 rc_pop;         // Registered RC Controller Pop signal
  reg 		 in_pop;
  reg [1:0] 	 init_sync;     // Sync init_done signal
  
  wire 		 in_empty;      // Input side FIFO is empty
  wire 		 out_empty_m;   // Output FIFO is empty on MC side
  wire 		 out_empty_v;   // Output FIFO is empty on VGA side
  wire 		 out_full_v;    // VGA fifo is full
  wire [56:0] 	 out_vgareq;    // Output from a VGA request
  wire [56:0] 	 ram_data_in;
  wire [3:0] 	 vga_wen_comb;
  wire 		 vga_rd;
  wire [5:0] 	 wrusedw;
  
  // The VGA parameter number
  parameter 	VGA      = 3'h6,
		IDLE     = 2'b00,
		REQ      = 2'b01,
		WAIT4GNT = 2'b10,
		WAIT4POP = 2'b11,
		IN_IDLE  = 2'b00,
		IN_POP   = 2'b01,
		IN_RDY   = 2'b10;

  // Capture requests coming in
  always @(posedge v_mclock or negedge reset_n) begin
    if (!reset_n) begin
      vga_ack         <= 1'b0;
      out_push        <= 1'b0;
      capt_rw         <= 1'b0;
      init_sync       <= 2'b0;
    end else begin

      // Default to no push
      out_push  <= 1'b0;
      init_sync <= {init_sync[0], init_done};
      
      if (vga_req && ~vga_ack && ~wrusedw[5]) begin
	capt_rw   <= vga_rd_wrn;
	vga_ack   <= 1'b1;
      end else if (vga_ack) begin
	out_push  <= 1'b1;
	vga_ack   <= 1'b0;
      end
    end
  end

  // Cross the domain into the MC
  always @(posedge mclock or negedge reset_n) begin
    if (!reset_n) begin
      vga_arb_req   <= 1'b0;
      out_cs        <= IDLE;
      rc_pop        <= 1'b0;
    end else begin
      
      rc_pop <= vga_pop;

      out_cs <= out_ns;

      // State machine says to issue a request
      if (make_req && ~vga_gnt) begin
	
	// Otherwise we have a read or write request
	vga_arb_req  <= 1'b1;
	vga_arb_read <= out_vgareq[54];
	vga_arb_addr <= out_vgareq[53:36];
      end else if (vga_gnt) begin
	vga_arb_req <= 1'b0;
      end
    end
  end
      
  // Output state machine
  always @* begin
    out_pop = 1'b0;
    make_req = 1'b0;
    case (out_cs)
      IDLE: begin
	if (~out_empty_m) begin
	  out_pop = 1'b1;
	  out_ns = REQ;
	end else out_ns = IDLE;
      end

      REQ: begin
        make_req = 1'b1;
	if (vga_arb_req) out_ns = WAIT4GNT;
	else out_ns = REQ;
      end

      WAIT4GNT: begin
	if (vga_gnt) begin
	  if (vga_arb_read && ~out_empty_m) begin
	    out_pop = 1'b1;
	    out_ns = REQ;
	  end else if (~vga_arb_read) out_ns = WAIT4POP;
	  else out_ns = IDLE;
	end else out_ns = WAIT4GNT;
      end

      WAIT4POP: begin
	if (rc_pop) begin
	  if (~out_empty_m) begin
	    out_pop = 1'b1;
	    out_ns = REQ;
	  end else out_ns = IDLE;
	end else out_ns = WAIT4POP;
      end
    endcase // case(out_cs)
  end
  
  always @(posedge v_mclock or negedge reset_n)
    if (~reset_n) begin
      vga_ready_n <= 1'b1;
      in_pop      <= 1'b0;
      in_cs       <= IN_IDLE;
    end else begin
      vga_ready_n <= 1'b1;

      case (in_cs)
	IN_IDLE: begin
 	  if (~in_empty & ~in_pop) begin
	    in_pop <= 1'b1;
	    in_cs  <= IN_POP;
	  end
	end
	IN_POP: begin
	  in_pop <= 1'b0;
	  in_cs  <= IN_RDY;
	end
	IN_RDY: begin
	  vga_ready_n <= 1'b0;
	  in_cs  <= IN_IDLE;
	end
	default: in_cs <= IN_IDLE;
      endcase
    end

  assign ram_data_in = {2'b0, capt_rw, vga_addr, vga_we, 
			vga_data_in};
  // Fifo from the VGA to the MC
  fifo_57x64 U_outfifo
    (
     .data            (ram_data_in),
     .wrreq           (out_push),
     .rdreq           (out_pop),
     .rdclk           (mclock),
     .wrclk           (v_mclock),
     .aclr            (~reset_n),
     
     .q               (out_vgareq),
     .rdempty         (out_empty_m),
     .wrfull          (out_full_v),
     .wrempty         (out_empty_v),
     .wrusedw         (wrusedw)
     );
  
  // Fifo from the MC to the VGA
  fifo_32x64a U_infifo
    (
     .data            (read_data),
     .wrreq           (vga_push),
     .rdreq           (in_pop),
     .rdclk           (v_mclock),
     .wrclk           (mclock),
     .aclr            (~reset_n),

     .q               (vga_data),
     .rdempty         (in_empty),
     .wrfull          ()
     );

  assign {vga_wen_comb, vga_data_out} = out_vgareq[35:0];

  assign vga_wen = vga_wen_comb;
  
endmodule
