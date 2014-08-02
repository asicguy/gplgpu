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
//  Title       :  CRT Fifo SM's
//  File        :  sm_crt_ffwr_rd.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module consists of two state machines, 
//   a) crt_fwr_sm and b) crt_frd_sm.
//   
//   Crt fifo write state machine generates write
//   strobes to the crt fifo. The state machine
//   also keeps track of the fifo full and empty
//   condition. This state machine runs on mem-clk.
//   
//   Crt fifo read state machine generaes read 
//   strobes to the crt fifo. This state machine also
//   keeps track of the fifo full and empty condtion.
//   This state machine runs on c_dclk. 
//    
//   Some signals generated on c_cdclk have to be used
//   on mem-clk machine so they are syncronized by double clocking
//   via mem_clk
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
module sm_crt_ffwr_rd 
  (
   input       t_crt_clk,
   input       crt_frd1,
   input       crt_frd17,   
   input       crt_fwr7_low,
   input       crt_fwr7_high,
   input       crt_fwr23_low,
   input       crt_fwr23_high,
   input       hreset_n,
   input       crt_ff_write,
   input       c_crt_line_end,
   input       crt_fwr0,
   input       crt_fwr15,
   input       crt_fwr16,
   input       crt_fwr31,
   input       crt_fwr0_low,
   input       crt_fwr15_low,
   input       crt_fwr16_low,
   input       crt_fwr15_high,
   input       crt_fwr31_low,
   input       crt_fwr31_high,
   input       graphic_mode,
   input       text_mode,
   input       mem_clk,
   input       c_dclk_en,
   input       c_vdisp_end,
   input       c_crt_ff_read,
   input       crt_frd16,
   input       crt_frd15,
   input       crt_frd31,
   input       sync_crt_line_end,
   input       sync_pre_vde,
   
   output      crt_ff_rda,	  
   output      crt_ff_rdb,    
   output      tx_ff_wra_low, 
   output      tx_ff_wra_high,
   output      tx_ff_wrb_low,	
   output      tx_ff_wrb_high,      
   output      gr_ff_wra,           
   output      gr_ff_wrb,           
   output      ff_writeable_crt,
   output      crt_req,
   output  reg a_empty,
   output  reg b_empty,
   output  reg a_full_done,
   output  reg b_full_done,
   output      start_txt_sm
   );
  
  //
  // 	    Define   Variables
  //
  
  wire    dummy_2;
  reg [4:0] current_state;
  reg [4:0] next_state;
  wire      a_full;
  wire      b_full;
  reg [1:0] rd_current_state;
  reg [1:0] rd_next_state;
  reg [1:0] sync0;
  reg [1:0] sync1;
  reg [1:0] sync2;
  reg [1:0] sync3;
  reg [1:0] sync4;
  reg [1:0] sync5;
  reg       cfwr_s0;
  reg       cfwr_s10;
  reg       cfwr_s11;
  reg       cfwr_s12;
  reg       cfwr_s13;
  reg       cfwr_s14;
  reg       cfwr_s15;
  reg       cfwr_s16;
  reg       cfwr_s17;
  reg       cfwr_s18;
  reg       cfwr_s6;
  reg       cfwr_s7;
  reg       cfwr_s8;
  
  reg       crtrd_s0;
  reg       crtrd_s1;
  reg       crtrd_s2;
  reg 	    dly_pre_vde;
  reg 	    int_a_full;
  reg 	    int_b_full;
  reg [3:0] toggle;
  
  wire	    int_frd_sm_reset;
  wire	    sync_crt_frd16;
  wire	    sync_crt_frd31;
  wire	    sync_crt_frd1;
  wire	    sync_crt_frd17;
  wire	    int_fwr_sm_reset;
  wire      a_full_set;
  wire      a_empty_reset;
  wire      b_full_set;
  wire      b_empty_reset;
  wire      crt_ff_full;
  wire      a_full_rst;
  wire      a_empty_set;
  wire      b_full_reset;
  wire      b_empty_set;
  wire      crt_ffsm_reset;
  wire      crt_frd_reset;
  wire      int_aempty_set;
  wire      int_bempty_set;

  // Syncronization of signals from c_dclk to mem_clk
  // Changed to toggle synchronizers
  always @(posedge t_crt_clk or negedge hreset_n)
    if (!hreset_n) begin
      toggle[3:0] <= 4'b0;
    end else begin
      toggle <= toggle ^ {crt_frd31, crt_frd16, crt_frd17, crt_frd1};
    end
  
  always @(posedge mem_clk or negedge hreset_n)
    if (!hreset_n) begin
      sync0 <= 2'b0;
      sync1 <= 2'b0;
      sync2 <= 2'b0;
      sync3 <= 2'b0;
    end else begin
      sync0 <= {sync0[0], toggle[0]};
      sync1 <= {sync1[0], toggle[1]};
      sync2 <= {sync2[0], toggle[2]};
      sync3 <= {sync3[0], toggle[3]};
    end

  assign sync_crt_frd1 = ^sync0;
  assign sync_crt_frd17 = ^sync1;
  assign sync_crt_frd16 = ^sync2;
  assign sync_crt_frd31 = ^sync3;
  
  //
  // 	 Define state machine states
  //
  
  parameter crt_fwr_state0  = 5'b00000,
      	    crt_fwr_state10 = 5'b00001,
	    crt_fwr_state11 = 5'b00011,
	    crt_fwr_state12 = 5'b00111,
            crt_fwr_state13 = 5'b01111,
            crt_fwr_state14 = 5'b11111,
            crt_fwr_state14x= 5'b11101,
	    crt_fwr_state15 = 5'b11110,
	    crt_fwr_state16 = 5'b11100,
	    crt_fwr_state17 = 5'b11000,
	    crt_fwr_state18 = 5'b10000,
	    crt_fwr_state6  = 5'b10001,
	    crt_fwr_state7  = 5'b10011,
	    crt_fwr_state7x  = 5'b10010,
            crt_fwr_state8  = 5'b10111;
  
  always @ (posedge mem_clk or negedge hreset_n) begin
    if (~hreset_n)              current_state <= crt_fwr_state0;
    else if (sync_crt_line_end) current_state <= crt_fwr_state0;
    else                        current_state <= next_state;
  end
  
  always @* begin
    cfwr_s0              = 1'b0;
    cfwr_s6              = 1'b0;
    cfwr_s7              = 1'b0;
    cfwr_s8              = 1'b0;
    cfwr_s10             = 1'b0;
    cfwr_s11             = 1'b0;
    cfwr_s12             = 1'b0;
    cfwr_s13             = 1'b0;
    cfwr_s14             = 1'b0;
    cfwr_s15             = 1'b0;
    cfwr_s16             = 1'b0;
    cfwr_s17             = 1'b0;
    cfwr_s18             = 1'b0;
      
    case(current_state) // synopsys parallel_case full_case 
      crt_fwr_state0: begin
	cfwr_s0 = 1'b1;
	if (~sync_pre_vde & graphic_mode & ff_writeable_crt)
	  next_state = crt_fwr_state6;
	else if (~sync_pre_vde & text_mode & ff_writeable_crt)
	  next_state = crt_fwr_state10;
	else
	  next_state = crt_fwr_state0;
      end

      crt_fwr_state6: begin
	cfwr_s6 = 1'b1;
	if (crt_fwr15 | sync_crt_line_end)
	  next_state = crt_fwr_state7;
	else 
	  next_state = crt_fwr_state6;
      end
        
      crt_fwr_state7: begin
	cfwr_s7 = 1'b1;
	if (b_empty & (~sync_crt_line_end))
          next_state = crt_fwr_state8;
	else if (sync_crt_line_end)
	  next_state = crt_fwr_state0;
	else
	  next_state = crt_fwr_state7;
      end
	
      crt_fwr_state7x: begin
	cfwr_s7 = 1'b1;
	if (a_empty & (~sync_crt_line_end))
	  next_state = crt_fwr_state6;
	else if (sync_crt_line_end)
	  next_state = crt_fwr_state0;
	else
	  next_state = crt_fwr_state7x;
      end
	
      crt_fwr_state8: begin
	cfwr_s8 = 1'b1;
	if (crt_fwr31 | sync_crt_line_end) 
          next_state = crt_fwr_state7x;
	else 
	  next_state = crt_fwr_state8;
      end
	
      //
      //   States have been changed from 1 to 5, to 10 to 18.
      //		  
      crt_fwr_state10: begin
	cfwr_s10 = 1'b1;
	if (crt_fwr7_low | sync_crt_line_end)
	  next_state = crt_fwr_state11;
	else
	  next_state = crt_fwr_state10;
      end
	
      crt_fwr_state11: begin
	cfwr_s11 = 1'b1;
	if (crt_fwr7_high | sync_crt_line_end)
	  next_state = crt_fwr_state12;
	else
	  next_state = crt_fwr_state11;
      end
	
      crt_fwr_state12: begin
	cfwr_s12 = 1'b1;
	if (crt_fwr15_low | sync_crt_line_end)
	  next_state = crt_fwr_state13;
	else
	  next_state = crt_fwr_state12;
      end

      crt_fwr_state13: begin
	cfwr_s13 = 1'b1;
	if (crt_fwr15_high | sync_crt_line_end)
	  next_state = crt_fwr_state14;
	else
	  next_state = crt_fwr_state13;
      end

      crt_fwr_state14: begin
	cfwr_s14 = 1'b1;
	if (b_empty &  (~sync_crt_line_end))
	  next_state = crt_fwr_state15;
	else if (sync_crt_line_end)
	  next_state = crt_fwr_state0;
	else
	  next_state = crt_fwr_state14;
      end
	
      crt_fwr_state14x: begin
	cfwr_s14 = 1'b1;
	if (a_empty & (~sync_crt_line_end))
	  next_state = crt_fwr_state10;
	else if (sync_crt_line_end)
	  next_state = crt_fwr_state0;
	else
	  next_state = crt_fwr_state14x;
      end
	
      crt_fwr_state15: begin
	cfwr_s15 = 1'b1;
	if (crt_fwr23_low | sync_crt_line_end)
	  next_state = crt_fwr_state16;
	else
   	  next_state = crt_fwr_state15;
      end
	
      crt_fwr_state16: begin
	cfwr_s16 = 1'b1;
	if (crt_fwr23_high | sync_crt_line_end)
	  next_state = crt_fwr_state17;
	else
	  next_state = crt_fwr_state16;
      end
	
      crt_fwr_state17: begin
	cfwr_s17 = 1'b1;
	if (crt_fwr31_low | sync_crt_line_end)
	  next_state = crt_fwr_state18;
	else
	  next_state = crt_fwr_state17;
      end	  
	
      crt_fwr_state18: begin
	cfwr_s18 = 1'b1;
	if (crt_fwr31_high | sync_crt_line_end)
	  //next_state = crt_fwr_state14;
	  next_state = crt_fwr_state14x;
	else
	  next_state = crt_fwr_state18;
      end
    endcase		 
  end   
  
  
  assign start_txt_sm   =  tx_ff_wra_low | tx_ff_wrb_low;
  
  assign tx_ff_wra_low  =  cfwr_s10   | cfwr_s12;
  assign tx_ff_wra_high =  cfwr_s11   | cfwr_s13;
  assign tx_ff_wrb_low  =  cfwr_s15   | cfwr_s17;
  assign tx_ff_wrb_high =  cfwr_s16   | cfwr_s18;

  assign int_fwr_sm_reset = (sync_pre_vde | sync_crt_line_end);
  
  assign gr_ff_wra = cfwr_s6 | (cfwr_s0 & graphic_mode & crt_ff_write);
  
  assign gr_ff_wrb = cfwr_s8 | (cfwr_s7 & crt_ff_write);

  //     
  // Generating the fifo_status signals as " a_empty, a_full, b_empty, b_full "
  //
  // Inferring Logic for a_full
  //
  
  assign a_full_set = ((crt_fwr15_high & text_mode) | 
                       (crt_fwr15 & graphic_mode));

  always @(posedge mem_clk or negedge hreset_n)
    if (!hreset_n) begin
      a_full_done <= 1'b0;
      int_a_full <= 1'b0;
      b_full_done <= 1'b0;
      int_b_full <= 1'b0;
    end else begin
      a_full_done <= a_full_set;

      casex ({a_full_rst, a_full_set})
	2'b1x: int_a_full <= 1'b0;
	2'b01: int_a_full <= 1'b1;
	2'b00: int_a_full <= a_full;
      endcase // casex({a_full_rst, a_full_set})
      
      b_full_done <= b_full_set;

      casex ({b_full_reset, b_full_set})
	2'b1x: int_b_full <= 1'b0;
	2'b01: int_b_full <= 1'b1;
	2'b00: int_b_full <= b_full;
      endcase // casex({b_full_reset, b_full_set})
      
    end

  // Prevent CRT display until first true frame
  always @(posedge mem_clk or negedge hreset_n)
    if (!hreset_n)            dly_pre_vde <= 1'b0;
    else if (~sync_pre_vde) dly_pre_vde <= 1'b1;
  
  assign a_full_rst = sync_crt_frd1 | int_fwr_sm_reset ;
  
  assign a_full = int_a_full & ~a_empty;
  
  //    
  // Inferring Logic  for a_empty
  //
  assign a_empty_reset = ((crt_fwr0_low & text_mode) |
                          (crt_fwr0 & graphic_mode));
  
  assign a_empty_set = sync_crt_frd16 | int_fwr_sm_reset;
  
  always @(posedge mem_clk or negedge hreset_n)
    if (!hreset_n) a_empty <= 1'b1;
    else 
      casex ({a_empty_reset, a_empty_set})
	2'b1x: a_empty <= 1'b0;
	2'b01: a_empty <= 1'b1;
	2'b00: a_empty <= a_empty;
      endcase // casex({a_empty_reset, a_empty_set})
  
  //
  // Inferring Logic  for b_full
  //
  
  assign b_full_set =  ((crt_fwr31_high & text_mode) | 
			(crt_fwr31 & graphic_mode));
  
  assign b_full_reset =  sync_crt_frd17 | int_fwr_sm_reset ;
  
  assign b_full = int_b_full & ~b_empty;
  
  
  //	   
  // Inferring Logic for b_empty
  //
  
  assign b_empty_reset = ((crt_fwr16_low & text_mode) | 
                          (crt_fwr16 & graphic_mode));
  
  assign b_empty_set = sync_crt_frd31 | int_fwr_sm_reset;
  
  always @(posedge mem_clk or negedge hreset_n)
    if (!hreset_n) b_empty <= 1'b1;
    else 
      casex ({b_empty_reset, b_empty_set})
        2'b1x: b_empty <= 1'b0;
	2'b01: b_empty <= 1'b1;
	2'b00: b_empty <= b_empty;
      endcase // casex({b_empty_reset, b_empty_set})
  
  assign crt_ff_full = a_full & b_full;
  
  assign ff_writeable_crt = a_empty | b_empty;
  
  assign crt_req = ff_writeable_crt & dly_pre_vde;
  
  //      
  // Generating  a state machine for crt_fifo_read
  //

  parameter crt_frd_state0 = 2'b00,
   	    crt_frd_state1 = 2'b01,
	    crt_frd_state2 = 2'b11;
  
  always @(posedge t_crt_clk or negedge hreset_n) begin
    if (~hreset_n)           rd_current_state <= crt_frd_state0;
    else if (c_crt_line_end) rd_current_state <= crt_frd_state0;
    else if (c_dclk_en)      rd_current_state <= rd_next_state;
  end
  
  assign int_frd_sm_reset = (c_vdisp_end | c_crt_line_end);

  always @* begin
    crtrd_s0   = 1'b0;
    crtrd_s1   = 1'b0;
    crtrd_s2   = 1'b0;   
    
    case (rd_current_state) // synopsys parallel_case full_case
      
      crt_frd_state0: begin
	crtrd_s0 = 1'b1;
	if (c_crt_ff_read & ~int_frd_sm_reset)
	  rd_next_state = crt_frd_state1;
	else
	  rd_next_state = crt_frd_state0;
      end
	
      crt_frd_state1: begin
        crtrd_s1  = 1'b1;
	if (crt_frd15 & ~int_frd_sm_reset)
	  rd_next_state = crt_frd_state2;
	else if (int_frd_sm_reset == 1)
	  rd_next_state = crt_frd_state0;
	else
	  rd_next_state = crt_frd_state1;
      end
	
      crt_frd_state2: begin
        crtrd_s2   = 1'b1;
	if (crt_frd31 & ~int_frd_sm_reset)
	  rd_next_state = crt_frd_state1;
	else if (int_frd_sm_reset == 1)
	  rd_next_state = crt_frd_state0;
	else
	  rd_next_state = crt_frd_state2;
      end
	
    endcase	 	  	         
  end 
  
  assign crt_ff_rda = ((crtrd_s0 & c_crt_ff_read) | crtrd_s1);
  
  assign crt_ff_rdb = crtrd_s2;
endmodule
