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

module dual_port_sim
  (
   input             clock_a,
   input [31:0]      data_a,
   input             wren_a,
   input [4:0]       address_a,
   input             clock_b,
   input [31:0]      data_b,
   input             wren_b,
   input [4:0]       address_b,

   output reg [31:0] q_a,
   output reg [31:0] q_b
   );

  reg [31:0] mem[31:0];
  
  always @(posedge clock_a) begin
    if (wren_a) begin
      mem[address_a][7:0]   <= data_a[7:0];
      mem[address_a][15:8]  <= data_a[15:8];
      mem[address_a][23:16] <= data_a[23:16];
      mem[address_a][31:24] <= data_a[31:24];
    end

    q_a <= mem[address_a];
  end

  //always @* q_a = mem[address_a];
  
  always @(posedge clock_b) begin
    if (wren_b) mem[address_b] <= data_b;

    q_b <= mem[address_b];
  end

  //always @* q_b = mem[address_b];
  
endmodule // dual_port_sim
