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
//  Title       :  Memory Controller CRT Interface
//  File        :  mc_crt.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  The CRT controller makes read-only requests to the memory system in order
//  to keep the CRT refreshed. These requests may be from 1 to 32 memory pages
//  (16 byte chunks) and cannot be counted on to have any particular alignment
//  in memory, primarily because of the use of sliding "virtural desktops". We
//  take these requests, turn them into aligned 4 page requests and send them
//  off to the arbiter. Then, when we get the push signal back from the rc 
//  state machine, we gate off the extra pages read due to the alignment
//  process and forward the push to the crt controller so that it may be used
//  to grab data from our capture registers. Also, currently the crt 
//  controller expects the push to be an asynchronous set of pulses instead of
//  an enable in mclock domain, so we may have to delay the enable and gate it
//  with mclock.
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

module mc_crt
  (
   input	      mclock,
   input	      reset_n,
   input              pixclk,
   input	      crt_clock,
   input	      crt_gnt,
   input	      crt_req,
   input [20:0]	      crt_org,
   input [4:0]	      crt_page,
   input [11:0]	      crt_ptch,
   input [9:0]	      crt_x,
   input [11:0]	      crt_y,
   
   output reg	      crt_ready,
   output reg	      crt_arb_req,
   output reg [4:0]   crt_arb_page,
   output reg [20:0]  crt_arb_addr
   );
  
  reg		capt_req;
  reg [20:0]	capt_org;
  reg [11:0]	capt_ptch;
  reg [9:0]	capt_x;
  reg [11:0]	capt_y;
  reg [4:0]	capt_page;

  reg		req_sync_m1, req_sync_1, req_sync_2, req_sync_3;
  reg		gnt_sync_1, gnt_sync_2, gnt_sync_3;
  reg [20:0] 	pmult, int_add;
  
  reg		final_grant; // patch signal, need to do real fix later
  reg [1:0] 	requests;
  reg 		hold_req;
  
  wire 		req_toggle;

  // Request capture logic and grant sync logic runs in crt_clock domain
  // Might we be able to get rid of that first set of capture registers? We 
  // could if we went to more of a request/grant interface where he keeps the 
  // data around until we grant him. His requests are so long that having a 
  // bunch of little requests in a row is not a problem.
  always @ (posedge pixclk or negedge reset_n) begin
    if(!reset_n) begin
      crt_ready <= 1'b1;
      capt_req  <= 1'b0;
      capt_org  <= 21'h0;
      capt_ptch <= 12'b0;
      capt_x    <= 10'b0;
      capt_y    <= 12'b0;
      capt_page <= 5'b0;
      gnt_sync_1<= 1'b0;
      gnt_sync_2<= 1'b0;
      gnt_sync_3<= 1'b0;
    end else if (crt_clock) begin
      if (crt_req) begin
	capt_req <= ~capt_req;
	capt_org <= crt_org;
	capt_ptch <= crt_ptch;
	capt_x <= crt_x;
	capt_y <= crt_y;
	// crt_page==0 is 32 pages, else just # pages
	capt_page <= crt_page - 5'b1;
	crt_ready <= 1'b0;
      end // if (crt_req==1'b1)
      
      gnt_sync_1 <= final_grant;
      gnt_sync_2 <= gnt_sync_1;
      gnt_sync_3 <= gnt_sync_2;
      if(gnt_sync_2 ^ gnt_sync_3) crt_ready <= 1'b1;
    end // else: !if(!reset_n)
  end // always @ (posedge crt_clock or negedge reset_n)

  assign req_toggle = req_sync_2 ^ req_sync_3;
  
  // Request synchronizers, translation logic and registers, and request FSM
  // runs in mclock domain.
  always @ (posedge mclock or negedge reset_n) begin
    if(!reset_n) begin
      // reset_n stuff
      crt_arb_req  <= 1'b0;
      final_grant  <= 1'b0; // this is now a toggle signal, I should rename it
      requests     <= 2'b0;
      hold_req     <= 1'b0;
      pmult        <= 21'b0;
      int_add      <= 21'b0;
      req_sync_m1  <= 1'b0;
      req_sync_1   <= 1'b0;
      req_sync_2   <= 1'b0;
      req_sync_3   <= 1'b0;
      crt_arb_req  <= 1'b0;
      crt_arb_page <= 5'b0;
      crt_arb_addr <= 21'b0;
    end else begin

      // Keep track of # of requests
      case ({crt_gnt, req_toggle})
	2'b01: requests <= requests + 2'b1;
	2'b10: requests <= requests - 2'b1;
      endcase
      
      // Cycle 1, calculate 1st half of pitch
      pmult <= (capt_y * {{4{capt_ptch[11]}}, capt_ptch});
//      pmult <= (capt_y << 8);
      int_add <= (capt_org + {{11{capt_x[9]}}, capt_x});
      
      // Synchronize crt requests
      req_sync_m1 <= capt_req; // this is a toggle signal, I should rename it
      req_sync_1 <= req_sync_m1;
      req_sync_2 <= req_sync_1;
      req_sync_3 <= req_sync_2;

      // When we get a request, we translate address, etc
      // we better not get another request until this one ends, thus the sync
      // logic, ready signal
      if (hold_req && ~&requests[1]) begin
	hold_req <= 0;
	crt_arb_req <= 1'b1;
	crt_arb_page <= capt_page;
	crt_arb_addr <= pmult + int_add;
      end else if(req_toggle && ~&requests[1]) begin
	crt_arb_req <= 1'b1;
	crt_arb_page <= capt_page;
	crt_arb_addr <= pmult + int_add;
      end else if(req_toggle && (&requests[1])) begin
	hold_req <= 1;
      end // if (req_sync_2==1'b1 && req_sync_3==1'b0)

      if(crt_gnt) begin
	crt_arb_req <= 1'b0;
	final_grant <= ~final_grant;
      end // if (crt_gnt==1'b1)

    end // else: !if(!reset_n)
  end // always @ (posedge mclock or negedge reset_n)

endmodule
