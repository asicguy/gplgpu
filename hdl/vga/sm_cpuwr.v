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
//  Title       :  CPU Write SM
//  File        :  sm_cpuwr.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   CPU Wite State Machine
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
module sm_cpuwr 
  (
   input        ff_wr_pend,
   input        hreset_n,
   input        cpu_wr_gnt,
   input        crt_req,
   input        svga_ack,
   input        mem_clk,

   output reg   cpu_wr_req,        	 
   output       cpu_wr_svga_req,   	 
   output       enwr_cpu_ad_da_pl, 	 
   output       cpu_fifo_read,     	 
   output reg   int_cpu_fifo_rd,
   output       cpu_mem_wr,					  
   output reg   cpu_arb_wr
//   output [2:0] probe
   );
  
  reg [2:0]    current_state;
  reg [2:0]    next_state;
  reg          en_cpu_fifo_read;
  reg          wen;
  reg          int_cpu_wr_svga_req;
  
  wire         t32;
  wire         t34;

//  assign       probe = current_state;
  
  parameter    cpuwr_state0 = 3'b000,
      	       cpuwr_state1 = 3'b001,
	       cpuwr_state2 = 3'b011,
	       cpuwr_state3 = 3'b111,
	       cpuwr_state4 = 3'b110;
  
  assign       t32 = (ff_wr_pend & (~crt_req));
  assign       t34 = ((~ff_wr_pend) | crt_req);
    
  //
  //   Yes both the logic is same but different outputs
  //
  
  assign       cpu_fifo_read = ff_wr_pend & en_cpu_fifo_read;  
  assign       enwr_cpu_ad_da_pl = ff_wr_pend & en_cpu_fifo_read;
  assign       cpu_wr_svga_req  = int_cpu_wr_svga_req & ff_wr_pend;
  
  assign       cpu_mem_wr = cpu_wr_req;
    
  always @ (posedge mem_clk or negedge hreset_n) begin
    if (hreset_n == 0) current_state = cpuwr_state0;
    else               current_state = next_state;
  end
   
  always @* begin
    cpu_wr_req           = 1'b0;
    int_cpu_wr_svga_req  = 1'b0;
    int_cpu_fifo_rd      = 1'b0;
    en_cpu_fifo_read     = 1'b0;
    cpu_arb_wr           = 1'b0;
	 
    case(current_state) // synopsys parallel_case full_case 
      cpuwr_state0: next_state = (ff_wr_pend) ? cpuwr_state1 : cpuwr_state0;
      cpuwr_state1: begin
	cpu_wr_req = 1'b1;          // At state1, cpu_wr_req is active.
	next_state = (cpu_wr_gnt) ? cpuwr_state2 : cpuwr_state1;
      end
      cpuwr_state2: begin
	cpu_arb_wr = 1'b1;
	cpu_wr_req = 1'b1;
	int_cpu_wr_svga_req = 1'b1; // At state2, cpu_wr_svga_req is active.
	int_cpu_fifo_rd = 1'b1;     // At state2, int_cpu_fifo_r is  active.
	if (svga_ack)
	  next_state = cpuwr_state3;
	else
	  next_state = cpuwr_state2;
      end
      cpuwr_state3: begin
	cpu_wr_req = 1'b1;
	cpu_arb_wr = 1'b1;
	en_cpu_fifo_read = 1'b1;
        next_state = cpuwr_state4;
      end
      cpuwr_state4: begin
	cpu_wr_req = 1'b1;
	cpu_arb_wr = 1'b1;
	if (t34)      next_state = cpuwr_state0;
	else if (t32) next_state = cpuwr_state2;
	else          next_state = cpuwr_state4;
      end
    endcase
  end   

endmodule
















