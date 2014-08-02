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
//  Title       :  Synchronous FIFO model
//  File        :  sfifo.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2009
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This module generates a Synchronous FIFO
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

module ssi_sfifo
  #
  (
   parameter WIDTH = 32,
   parameter DEPTH = 8,
   parameter DLOG2 = 3,
   parameter AFULL = 3
   )
  (
   input  [WIDTH-1:0]     data,
   input                  wrreq,
   input                  rdreq,
   input                  clock,
   input                  aclr,
   
   output reg [WIDTH-1:0] q,
   output                 full,
   output                 empty,
   output reg [DLOG2-1:0] usedw,
   output                 almost_full
   );

  reg [WIDTH-1:0]         ram[DEPTH-1:0];
  reg [DLOG2-1:0]         wr_addr;
  reg [DLOG2-1:0]         rd_addr;

  always @(posedge clock, posedge aclr)
    if (aclr) begin
      usedw   <= 'b0;
      wr_addr <= 'b0;
      rd_addr <= 'b0;
      q       <= 'b0;
    end else begin

      case ({wrreq, rdreq})
        2'b10: usedw <= usedw + 8'h1;
        2'b01: usedw <= usedw - 8'h1;
      endcase // case ({wrreq, rdreq})

      if (wrreq) ram[wr_addr] <= data;
      if (wrreq) wr_addr <= wr_addr + 8'h1;

      if (rdreq) begin
        rd_addr <= rd_addr + 8'h1;
        q       <= ram[rd_addr];
      end
      //q <= ram[rd_addr];

    end // else: !if(aclr)

  //assign q = ram[rd_addr];

  assign full = &usedw;
  assign empty = ~|usedw;
  assign almost_full = usedw > AFULL;
  
endmodule // sfifo
