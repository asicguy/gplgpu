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
//  The DLP makes one page read requests from host clock domain. This block has
//  to synchronize the requests, pass them on to the arbiter, and mask the
//  push enables that come back.
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

module mc_dlp
  #(parameter           BYTES = 16)
  (
   input                reset_n,
   input                mclock,
   input                hst_clock,
   input                dlp_req,
   input [4:0]          dlp_wcnt,
   input [27:0]         dlp_org,
   input                dlp_gnt,
   input                dlp_push,
   
   output reg           dlp_mc_done,
   output reg           dlp_arb_req,
   output reg [4:0]     dlp_arb_wcnt,
   output reg [27:0]    dlp_arb_addr,
   output reg           dlp_ready
   );
  
  reg [27:0]    capt_org;
  reg [4:0]     capt_wcnt;
  reg           dlp_req_toggle;
  reg           req_sync_1, req_sync_2, req_sync_3;
  reg           dlp_gnt_toggle;
  reg           gnt_sync_1, gnt_sync_2, gnt_sync_3;
  reg [1:0]     request_count;
  reg [4:0]     dlp_count;
  
  localparam    DLP = 3'h1;
  
  // Capture request and control the ready signal
  always @ (posedge hst_clock or negedge reset_n) begin
    if(!reset_n) begin
      dlp_ready      <= 1'b1;
      dlp_req_toggle <= 1'b0;
      gnt_sync_1     <= 1'b0;
      gnt_sync_2     <= 1'b0;
      gnt_sync_3     <= 1'b0;
    end else begin
      if(dlp_req==1'b1) begin
        dlp_req_toggle <= ~dlp_req_toggle;
        capt_org  <= dlp_org;
        capt_wcnt <= dlp_wcnt;
        dlp_ready <= 1'b0;
      end // if (dlp_req==1'b1)
      
      // synchronize the gnt toggle from mclock domain
      gnt_sync_1 <= dlp_gnt_toggle;
      gnt_sync_2 <= gnt_sync_1;
      gnt_sync_3 <= gnt_sync_2;
      
      if(gnt_sync_2 ^ gnt_sync_3) dlp_ready <= 1'b1;
      
    end // else: !if(!reset_n)
  end // always @ (posedge hst_clock or negedge reset_n)

  // Issue requests to the arbiter
  always @ (posedge mclock or negedge reset_n) begin
    if(!reset_n) begin
      dlp_arb_req    <= 1'b0;
      dlp_gnt_toggle <= 1'b0;
      req_sync_1     <= 1'b0;
      req_sync_2     <= 1'b0;
      req_sync_3     <= 1'b0;
      dlp_mc_done    <= 1'b0;
      dlp_arb_addr   <= 28'b0;
      dlp_arb_req    <= 1'b0;
      dlp_count      <= 5'b0;
    end else begin
      req_sync_1 <= dlp_req_toggle;
      req_sync_2 <= req_sync_1;
      req_sync_3 <= req_sync_2;

      if(req_sync_2 ^ req_sync_3) begin
        dlp_arb_addr <= capt_org;
        dlp_arb_req  <= 1'b1;
        dlp_arb_wcnt <= capt_wcnt;
      end // if (req_sync_2==1'b1 && req_sync_3==1'b0)
      
      if(dlp_gnt==1'b1) begin
        dlp_arb_req <= 1'b0;
        dlp_gnt_toggle <= ~dlp_gnt_toggle;
      end // if (dlp_gnt==1'b1)

      if (dlp_push && ~dlp_mc_done)
        	dlp_count <= dlp_count + 5'h1;
      else if(dlp_mc_done)
        	dlp_count <= 5'h0;

      if (dlp_push && ~dlp_mc_done) begin
        if (BYTES == 4)      dlp_mc_done <= &dlp_count;		// FIXME.
        else if (BYTES == 8) dlp_mc_done <= dlp_count[0];	// FIXME.
        else 		     dlp_mc_done <= (dlp_count == dlp_arb_wcnt);
      end 
      else dlp_mc_done <= 1'b0;
      
    end // else: !if(!reset_n)
  end // always @ (posedge mclock or negedge reset_n)

endmodule
