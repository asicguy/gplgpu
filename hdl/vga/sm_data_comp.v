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
//  Title       :  Memory and VGA arbitration
//  File        :  sm_data_comp.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This state machine is activated on an crt svga request,
//   it coordinates the data xfer between the memory and
//   the VGA on an crt cycle.
//   For every 16 crt_cycles it issues and datacomplete
//   command. This indicates that half the crt fifo is 
//   filled now.
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
  module sm_data_comp 
    (
     input         sync_c_crt_line_end,
     input         cpu_arb_wr,
     input         t_data_ready_n,
     input         h_reset_n,   
     input         t_mem_clk,
     input         gra_crt_svga_req,
     input         txt_crt_svga_req,
     input         cpu_rd_svga_req,
     input         cpu_wr_svga_req,
     input         text_mode,
     input         cursor_addr_ok,
     input         cursor_addr_ok1,
     input [3:0]   gra_cnt_qout,
  
     output reg    data_complete,
     output reg    crt_ff_write,
     output        m_t_svga_req,
     output        m_mrd_mwr_n
     );
  
  //
  //       Define Variables
  //
  
  reg [1:0]     current_state;
  reg [1:0]     next_state;
  reg [3:0]     dardy_cnt_qout;
  reg           dardy_s1;
  
  wire          mux3_out; 
  wire          dardy_cnt_0;
  wire          dardy_cnt_inc;
  wire          int_svga_req;
  wire [3:0]    tx_gr_muxout;
  wire          cursor_reset;
  wire          cur_addr_rst_n;
  wire          int_crt_ff_write;

  assign        int_svga_req = gra_crt_svga_req | txt_crt_svga_req;
  
  assign        m_t_svga_req = (int_svga_req |
				cpu_rd_svga_req | cpu_wr_svga_req);
  
  assign        m_mrd_mwr_n = ~cpu_arb_wr;
  
  assign        mux3_out = text_mode ? 1'b0 : dardy_cnt_qout[3];
  
  assign        dardy_cnt_0 = ((~mux3_out) & (~dardy_cnt_qout[2]) & 
			       (~dardy_cnt_qout[1]) & (~dardy_cnt_qout[0]));
  
  //
  //  	    Define state machine states
  //
  
  parameter     dardy_crt_state0  = 2'b00,
                dardy_crt_state1  = 2'b01,
	        dardy_crt_state2  = 2'b10,
	        dardy_crt_state3  = 2'b11;
  
  always @ (posedge t_mem_clk or negedge h_reset_n) begin
    if (~h_reset_n) current_state <= dardy_crt_state0;
    else            current_state <= next_state;
  end
  
  always @* begin
    dardy_s1      = 1'b0;
    data_complete = 1'b0;
    crt_ff_write  = 1'b0;
      
    case (current_state) // synopsys parallel_case full_case
  	
      dardy_crt_state0: begin
        if (int_svga_req) next_state = dardy_crt_state1;
	else              next_state = dardy_crt_state0;
      end
	
      dardy_crt_state1: begin
	dardy_s1 = 1'b1;
	casex ({t_data_ready_n, sync_c_crt_line_end})
	  2'b00: next_state = dardy_crt_state2;
	  2'b10: next_state = dardy_crt_state1;
	  2'bx1: next_state = dardy_crt_state3;
	endcase // case({t_data_ready_n, sync_c_crt_line_end})
      end
      
      dardy_crt_state2: begin
	crt_ff_write = 1'b1;
	casex ({dardy_cnt_0, sync_c_crt_line_end})
	  2'b00: next_state = dardy_crt_state1;
	  2'b10: next_state = dardy_crt_state3;
	  2'bx1: next_state = dardy_crt_state3;
	endcase
      end
        
      dardy_crt_state3: begin
	data_complete = 1'b1;
        next_state = dardy_crt_state0;
      end
      
    endcase
  end  			
  
  assign dardy_cnt_inc = ~t_data_ready_n &  (dardy_s1 | crt_ff_write);
  
  always @ (posedge t_mem_clk or negedge h_reset_n) begin
    if (~h_reset_n)                      dardy_cnt_qout <= 4'b0;
    else if (sync_c_crt_line_end)        dardy_cnt_qout <= 4'b0;
    else if (data_complete & text_mode)  dardy_cnt_qout <= 4'b0;
    else if (dardy_cnt_inc)              dardy_cnt_qout <= dardy_cnt_qout + 1;
  end

endmodule	 


















