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
//  Title       :  Dual Port 16x6
//  File        :  dual_port_16x6.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module realizes a 16x6 dual port register bank
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
      	 
module dual_port_16x6
  (
   input             h_reset_n,
   input 	     we,          // write enable (host)
   input 	     h_hclk,
   input             clk,
   input             clk_en,
   input [3:0] 	     addr1,       // R/W Address (host)
   input [3:0]       addr2,       // Read address 2 (other)
   input [5:0] 	     din,         // data in (host)
   
   output reg [5:0]  dout1,       // data out (host)	 
   output reg [5:0]  dout2	  // data out (other)
   );
  
  reg [5:0] 	     storage[15:0];

  integer 	     i;
  
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      for (i = 0; i < 16; i = i + 1) storage[i] <= 6'b0;
    end else begin
      if (we) storage[addr1] <= din;
      dout1 <= storage[addr1];
    end

  always @(posedge clk or negedge h_reset_n)
    if (!h_reset_n) dout2 <= 6'b0;
    else if(clk_en) dout2 <= storage[addr2]; 

endmodule

