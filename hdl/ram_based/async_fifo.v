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
///////////////////////////////////////////////////////////////////////////////
//  Title       :  Asynchronous FIFO model
//  File        :  async_fifo.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2009
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module infers an asynchronous FIFO. 1R/1W
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
///////////////////////////////////////////////////////////////////////////////
// The file below this point is mdifiable by the licensee:
`timescale 1ns / 10ps

module async_fifo
  #
  (
   parameter WIDTH = 8,
   parameter DEPTH = 8,
   parameter DLOG2 = 3
   )
  (
   input  [WIDTH-1:0]  data,
   input               rdclk,
   input               rdreq,
   input               wrclk,
   input               wrreq,
   input               aclr,
   
   output reg [WIDTH-1:0]  q,
   output                  rd_empty,
   output                  rd_full,
   output                  wr_empty,
   output                  wr_full,
   output reg [DLOG2-1:0]  wrusedw,
   output reg [DLOG2-1:0]  rdusedw
   );

  reg [WIDTH-1:0]  mem[DEPTH-1:0];
  reg [DLOG2-1:0]  wraddr, rdaddr;
  reg [DLOG2-1:0]  g_wraddr, g_rdaddr;
  reg [DLOG2-1:0]  sync_g_wraddr, sync_g_rdaddr;
  reg [DLOG2-1:0]  wraddr_bin, rdaddr_bin;
  reg [DLOG2-1:0]  wr_diff, rd_diff;

  wire [DLOG2-1:0] wraddr_next, rdaddr_next;

  integer          i, j, k, l;
  
  always @(posedge wrclk, negedge aclr)
    if (!aclr) begin
      g_wraddr      <= 'b0;
      sync_g_rdaddr <= 'b0;
      wraddr        <= 'b0;
      wrusedw       <= 'b0;
    end else begin
      sync_g_rdaddr <= g_rdaddr;
      wrusedw <= wr_diff;
      if (wrreq) begin
        mem[wraddr] <= data;
        wraddr <= wraddr_next;
        g_wraddr[DLOG2-1] <= wraddr_next[DLOG2-1];
        for (i = 0; i < DLOG2-1; i = i + 1) 
          g_wraddr[i] <= wraddr_next[i+1] ^ wraddr_next[i];
      end
    end

  always @* begin
    rdaddr_bin[DLOG2-1] = sync_g_rdaddr[DLOG2-1];
    for (l = DLOG2-2; l >=0; l = l - 1) begin
      rdaddr_bin[l] = rdaddr_bin[l+1] ^ sync_g_rdaddr[l];
    end
  end
  
  //assign wr_empty = (wrusedw == 0);
  //assign wr_full  = (wrusedw == DEPTH - 1);
  assign wr_empty = (wr_diff == 0);
  assign wr_full  = (wr_diff == DEPTH - 1);

  always @(posedge rdclk, negedge aclr)
    if (!aclr) begin
      g_rdaddr      <= 'b0;
      sync_g_wraddr <= 'b0;
      rdaddr        <= 'b0;
      q             <= 'b0;
      rdusedw       <= 'b0;
    end else begin
      sync_g_wraddr <= g_wraddr;
      rdusedw <= rd_diff;
      q <= mem[rdaddr];
      if (rdreq) begin
        rdaddr <= rdaddr_next;
        g_rdaddr[DLOG2-1] <= rdaddr_next[DLOG2-1];
        for (j = 0; j < DLOG2-1; j = j + 1) 
          g_rdaddr[j] <= rdaddr_next[j+1] ^ rdaddr_next[j];
      end
    end

  always @* begin
    wraddr_bin[DLOG2-1] = sync_g_wraddr[DLOG2-1];
    for (k = DLOG2-2; k >=0; k = k - 1) begin
      wraddr_bin[k] = wraddr_bin[k+1] ^ sync_g_wraddr[k];
    end
  end
  
  //assign rd_empty = (rdusedw == 0);
  //assign rd_full  = (rdusedw == DEPTH - 1);
  assign rd_empty = (rd_diff == 0);
  assign rd_full  = (rd_diff == DEPTH - 1);

  assign wraddr_next = wraddr + 1;
  assign rdaddr_next = rdaddr + 1;

  always @* begin
    if (wraddr >= rdaddr_bin)
      wr_diff = wraddr - rdaddr_bin;
    else 
      wr_diff = ~(rdaddr_bin - wraddr) + 1;
    if (wraddr_bin >= rdaddr)
      rd_diff = wraddr_bin - rdaddr;
    else 
      rd_diff = ~(rdaddr - wraddr_bin) + 1;
  end
  
  //assign wr_diff = wraddr - rdaddr_bin;
  //assign rd_diff = rdaddr - wraddr_bin;

endmodule // async_fifo
