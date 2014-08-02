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
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module handles the interface between the memory controller and the 
//  drawing engine. It aligns and breaks up requests into four page bursts, 
//  breaks up read-modify-write cycles and controls the datapath for
//  drawing engine data (including blending, rops, z-masking, and keying 
//  support).
// 
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

module mc_de
  #(parameter BYTES = 4)
  (
   /* Clocks and resets */
   input                mclock,
   input                reset_n,
   
   // Signals from the 2D cache
   input                line_actv_4,
   input                de_read,
   input                de_rmw,
   input                de_pc_empty,
   input [3:0]          de_page,
   input [31:0]         de_address,
   
   /* Data movement signals */
   input                de_push,
   input                de_almost_full,
   input                de_zen,
   
   output reg           fifo_push,
   output               de_popen,
   output reg           de_last,
   output reg           de_last4,
   output reg           de_pc_pop,
   
   /* Arbiter interface signals */
   output reg [1:0]     de_arb_cmd,  // Command to arb: 0 = wr, 1 = rd, 2 = rmw
   output reg [31:0]    de_arb_address,
   
   /* Datapath control signals */
   output reg           mcb,       // Memory controller busy DE operation
   output reg           de_push_mff,
   output reg           de_push_mff_z,
   output reg           de_push_mff_a
   );
  
  localparam            // DE        = 3'h4,
                        IDLE      = 2'b00,
                        WAIT_GRAB = 2'b01,
                        DATA_GRAB = 2'b10,
                        WAIT4GNT  = 2'b11;
                        // NUM_STAGE = 2'd1;
  
  reg [1:0]     de_cs, de_ns;         // Drawing engine states
  reg [6:0]     page_count;           // Keep track of page counts
  reg           grab_data;
  reg [4:0]     de_popen_pipe;
  reg           fifo_push_d;          // delayed fifo_push for short requests
  
  always @ (posedge mclock or negedge reset_n)
    if(!reset_n) begin
      mcb             <= 1'b0;
      de_cs           <= IDLE;
      de_popen_pipe   <= 5'b0;
      de_push_mff     <= 1'b0;
      de_push_mff_z   <= 1'b0;
      de_push_mff_a   <= 1'b0;
      de_last         <= 1'b0;
      de_last4        <= 1'b0;
      page_count      <= 7'b0;
      de_arb_address  <= 32'b0;
      fifo_push_d     <= 1'b0;
    end else begin

      fifo_push_d <= fifo_push;
      
      // assign next state
      de_cs <= de_ns;
      
      // Busy back to host
      mcb <= |de_cs;
      
      // Initiate first request
      if (grab_data) begin
        de_arb_address <= de_address;
        // We issue a read request here if we are doing a read,
        // a read-modify-write, or due to a plane mask, we must do a RMW
        casex ({de_read, de_rmw})
          2'b01: de_arb_cmd <= 2'd2;
          2'b00: de_arb_cmd <= 2'd0;
          2'b1x: de_arb_cmd <= 2'd1;
        endcase // casex({capt_read[current_output_select],...
      end 

      de_last  <= 1'b0;
      de_last4 <= 1'b0;
      
      // Pipeline pops for loading the MFF
      de_popen_pipe <= (de_popen_pipe << 1) | (~de_read & |page_count);

      de_push_mff   <=  de_popen_pipe[4];
      de_push_mff_z <= (de_popen_pipe[4] & de_zen);
      de_push_mff_a <=  de_popen_pipe[1];
      
      // The counter is loaded with the count.
      if (grab_data)
        if (line_actv_4)
          page_count <= de_page + 5'b1;
        else if (BYTES == 16)
          page_count <= de_page + 5'b1;
        else if (BYTES == 8)
          page_count <= {de_page, 1'b1} + 5'b1;
        else 
          page_count <= {de_page, 2'b11} + 5'b1;
      // Don't roll the counter over.
      else if ((de_push || ~de_read) && |page_count) begin
        page_count <= page_count - 7'b1;
        de_last    <= (page_count == 1);
      end
      
      if (BYTES == 4)
        de_last4 <= (page_count <= 4);
      else if (BYTES == 8)
        de_last4 <= (page_count <= 2);
      else
        de_last4 <= (page_count == 1);
    end
  
      assign de_popen = de_popen_pipe[0];
  
  // Drawing engine access state machine.
  // The drawing engine path to the Rams is heavily pipelined to allow for
  // maximum speed and for Ram latencies. As such we need to generate:
  //
  // de_popen: The actual pop signal to move data from the drawing engine
  // shift_en: The signal to push data through the pipeline
  // de_push:  The signal to pus hdata into the DE
  always @* begin
    de_pc_pop    = 1'b0;
    grab_data    = 1'b0;
    fifo_push    = 1'b0;
    de_ns        = de_cs; // ?????
    case (de_cs)
      IDLE: begin
//      if (~de_pc_empty && ~de_almost_full && (page_count < 5'd2)) begin
//      if (~de_pc_empty && ~de_almost_full && ~|page_count) begin
        if (~de_pc_empty && ~de_almost_full && ~|page_count 
          && ~fifo_push_d && ~|de_popen_pipe[2:0]) begin
          de_pc_pop = 1'b1; // need to register?
          de_ns     = WAIT_GRAB;
        end else
          de_ns     = IDLE;
      end

      WAIT_GRAB: de_ns = DATA_GRAB;

      DATA_GRAB: begin
        grab_data = 1'b1;
        de_ns     = WAIT4GNT;
      end

      WAIT4GNT: begin
        fifo_push = 1'b1;
        de_ns = IDLE;
      end
    endcase
  end

endmodule


