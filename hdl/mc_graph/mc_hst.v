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
//  File        :  mc_hst.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Receives requests from the HBI block in the form of a active high hst_req 
//  signal. Requests will only be made when our hst_rdy output is asserted 
//  high. Address, read (data directions), and page count are captured with 
//  the request. They are then brought across the clock domains to mclock by 
//  the synchronized request signal. Once in mclock domain, the request is 
//  made to the RAM arbiter.
// 
//  In other interface modules, address translation may occur as part of the 
//  clock domain crossing, but we are already given a linear address from the 
//  host bus so no extra translation is necessary. Also in other interfaces, 
//  request may be of up to 32 pages. Requests to the RAM arbiter may only be 
//  4 pages, read or write, so large request must be broken up. The HBI only 
//  ever requests 1 or 2 page writes and 4 page reads, so we don't have to 
//  break things up, although we must mask out read data so garbage doesn't 
//  get written for the unused write cycles.
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

module mc_hst
  (
   input	    mclock,
   input	    reset_n,
   input	    hst_clock,
   input	    hst_gnt,       // Grant back from arbiter
   input [22:0]	    hst_org,       // Address for HBI request
   input	    hst_read,      // Read/write select for HBI request
   input	    hst_req,       // Request from HBI (sync to hst_clock)
   input	    rc_push_en,
   input	    rc_pop_en,     /* Should also add a select bus so I know
				    who the push or pop is for. */
   output reg [22:0] hst_arb_addr,  // MC internal address to arbiter
   output reg	     hst_pop,       // Data increment for write data from HBI
   output reg	     hst_push,      // Write enable for read data back to HBI
   output reg	     hst_rdy,       /* Ready flag must be asserted before HBI 
				    sends request */
   output reg [1:0]  hst_mw_addr,   // The address to read from MW
   output reg [1:0]  hst_arb_page,  // MC internal page count to arbiter
   output reg	     hst_arb_read,  // MC internal r/w select to arbiter
   output 	     hst_arb_req    // MC internal request to arbiter
   );
  
  reg [22:0]	capt_addr[1:0];
  reg [1:0] 	capt_read;
  reg		input_select, output_select, capt_select;
  reg [1:0] 	req_sync_1, req_sync_2, req_sync_3;
  reg [1:0] 	hst_push_cnt;
  reg [1:0] 	busy;
  reg [1:0] 	clear_busy;
  reg [1:0] 	clear_busy0;
  reg [1:0] 	clear_busy1;
  reg [1:0] 	avail_mc;
  reg 		final_select;
  reg [1:0] 	hst_arb_req_int;

  assign hst_arb_req = |hst_arb_req_int;
  // Implement asynchronous interface and capture registers.
  // This process should be the only things that runs on hst_clock.
  // It captures the request on hst_clock and generates synchronization logic
  // to get back to hst_clock domain. It also generates the ready flag
  always @ (posedge hst_clock or negedge reset_n) begin
    if(!reset_n) begin
      input_select   <= 1'b0;
      hst_rdy        <= 1'b1;
      capt_addr[0]   <= 23'b0;
      capt_addr[1]   <= 23'b0;
      capt_read      <= 2'b0;
      busy           <= 2'b0;
      clear_busy0    <= 2'b0;
      clear_busy1    <= 2'b0;
    end else begin // if (!reset_n)

      clear_busy0 <= clear_busy;
      clear_busy1 <= clear_busy0;
      
      hst_rdy <= ~&busy;
      
      // If we detect an edge on either clear, then clear the busy flag
      if (clear_busy1[0] ^ clear_busy0[0]) busy[0] <= 1'b0;
      if (clear_busy1[1] ^ clear_busy0[1]) busy[1] <= 1'b0;
      
     // Capture registers grab necessary data whenever a new request is made
      if (hst_req && ~&busy) begin
	input_select <= ~input_select;
	busy[input_select] <= 1'b1;
	capt_addr[input_select] <= hst_org;
	capt_read[input_select] <= hst_read;
	hst_rdy   <= 1'b0;
      end

    end // else: !if(!reset_n)
  end // always @ (posedge hst_clock)

  // This is the main mclock domain process.
  // It implements synchronizers to move the request from hst_clock over to
  // mclock domain. It also has all the mclock capture registers that forward
  // the request on to the arbiter.
  always @ (posedge mclock or negedge reset_n) begin
    if(!reset_n) begin
      hst_arb_req_int<= 1'b0;
      req_sync_1     <= 2'b0;
      req_sync_2     <= 2'b0;
      req_sync_3     <= 2'b0;
      avail_mc       <= 2'b0;
      capt_select    <= 1'b0;
      output_select   <= 1'b0;
      clear_busy      <= 2'b0;
      final_select    <= 1'b0;
    end else begin
      // Triple register the request toggle for clock synchronization
      req_sync_1 <= busy;
      req_sync_2 <= req_sync_1;
      req_sync_3 <= req_sync_2;

      if (~req_sync_3[0] && req_sync_2[0]) avail_mc[0] <= 1'b1;
      if (~req_sync_3[1] && req_sync_2[1]) avail_mc[1] <= 1'b1;
 
      // A rising or falling transition on the synchronized request toggle
      // indicates a new request is in the capture registers. In that case it 
      // is moved to the arbiter request registers and the request signal to 
      // the arbiter is asserted.
      if (avail_mc[output_select]) begin
	// make a new request to the arbiter
	output_select <= ~output_select;
	hst_arb_req_int[output_select] <= 1'b1;
	avail_mc[output_select] <= 1'b0;
      end // if (req_sync_2 ^ req_sync_3)

      hst_arb_read <= capt_read[capt_select];
      hst_arb_page <= capt_read[capt_select] ? 2'h3 : 2'h1;
      hst_arb_addr <= capt_addr[capt_select];
      
      // When we get a grant from the arbiter, deassert arbiter request and
      // generate the grant toggle that is used to reassert ready.
      // I should never get a request and grant in the same cycle
      if(hst_gnt) begin
	capt_select <= ~capt_select;
	hst_arb_req_int[capt_select] <= 1'b0;
      end // if (hst_gnt)

      if (&hst_push_cnt | hst_mw_addr[0]) begin
	clear_busy[final_select] <= ~clear_busy[final_select];
	final_select <= ~final_select;
      end
    
    end // else: !if(!reset_n)
  end // always @ (posedge mclock or negedge reset_n)

  // finally, we need a process to forward push's and pop's correctly, and to 
  // mask writes that are part of the burst, but we don't have any data for.
  always @ (posedge mclock or negedge reset_n) begin
    if(!reset_n) begin
      hst_push        <= 1'b0;
      hst_pop         <= 1'b0;
      hst_mw_addr     <= 2'b0;
      hst_push_cnt    <= 2'b0;
    end else begin

      if (rc_push_en) begin
	hst_push <= 1'b1;
	hst_push_cnt <= hst_push_cnt + 2'b1;
      end else hst_push <= 1'b0;

      if (rc_pop_en) begin
	hst_pop <= 1'b1;
	hst_mw_addr <= hst_mw_addr + 2'b1;
      end else hst_pop <= 1'b0;

    end // else: !if(!reset_n)
  end // always @ (posedge mclock)
  
endmodule
