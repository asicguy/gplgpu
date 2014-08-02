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
//  Title       :  Refresh SM
//  File        :  sm_ref.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module has the refresh state machine. At the 
//   begining of line_end signal from crt module, a refresh
//   request is done to arbritation module and a refresh
//   grant is obtained. A refresh cycle of 1, 3 or 5 is
//   done according to the programmed value.
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
module sm_ref
  (
   input      mem_clk,
   input      hreset_n,
   input      ref_gnt,
   input      svga_ack,
   input      c_cr11_b6,
   input      sync_c_crt_line_end,
   
   output     ref_svga_req,
   output     ref_req,   	 
   output     m_t_ref_n,
   output     ref_cycle_done
   );
  
  //
  // 	 Define varialbes
  //
  reg [2:0] current_state;
  reg [2:0] next_state;
  reg [2:0] rfsh_cnt_out;
  reg       ref_s1, ref_s2, ref_s3, ref_s4, ref_s5;
  
  wire      rfsh_done;
  wire      en_ref_inc;    
  
  assign    rfsh_done = (c_cr11_b6) ? (rfsh_cnt_out == 3'b101) :
					(rfsh_cnt_out == 3'b011);

  //
  // 	 Define state machine states
  //
  parameter ref_state0 = 3'b000,
            ref_state1 = 3'b001,
	    ref_state2 = 3'b100,
	    ref_state3 = 3'b010,
            ref_state4 = 3'b011,
	    ref_state5 = 3'b111;
  
  always @(posedge mem_clk or negedge hreset_n) begin
    if (!hreset_n) current_state <= ref_state0;
    else           current_state <= next_state;
  end
  
  always @* begin
    ref_s1    = 1'b0;
    ref_s2    = 1'b0;
    ref_s3    = 1'b0;
    ref_s4    = 1'b0;
    ref_s5    = 1'b0;

    case (current_state) // synopsys parallel_case full_case
      ref_state0: begin
	if (sync_c_crt_line_end) next_state = ref_state1;
	else                     next_state = ref_state0;
      end
	
      ref_state1: begin
        ref_s1 = 1'b1;
	if (ref_gnt) next_state = ref_state2;
	else         next_state = ref_state1;
      end
	
      ref_state2: begin
        ref_s2   = 1'b1;
        if (svga_ack) next_state = ref_state3;
	else          next_state = ref_state2;
      end
	
      ref_state3: begin
	ref_s3      = 1'b1;
	next_state = ref_state4;
      end

      ref_state4: begin
        ref_s4      = 1'b1;
        if (rfsh_done) next_state = ref_state5;
        else           next_state = ref_state2;
      end
      
      ref_state5: begin
	ref_s5    = 1'b1;
	next_state = ref_state0;
      end
      
    endcase               
  end     
  
  assign ref_req = ref_s1 & ~ref_gnt;
  
  assign ref_svga_req =   ref_s2;
  
  assign m_t_ref_n = ~ref_svga_req;     
  
  assign ref_cycle_done = ref_s5;
  
  assign en_ref_inc = ref_s3;

  always @ (posedge mem_clk or negedge hreset_n) begin
    if (~hreset_n)       rfsh_cnt_out <= 3'b000;
    else if (ref_s5)     rfsh_cnt_out <= 3'b000;
    else if (en_ref_inc) rfsh_cnt_out <= rfsh_cnt_out + 1'b1;
    else                 rfsh_cnt_out <= rfsh_cnt_out;
  end


endmodule       
