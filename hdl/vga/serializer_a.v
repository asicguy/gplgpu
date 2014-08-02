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
//  Title       :  Serializer
//  File        :  serializer_a.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//   This module converts the data from CRT fifo into an
//   effective serial pixel bit stream.  The input data
//   is manipulated appropriately depending on the various
//   modes.  
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
 module serializer_a
   (
    input            pre_load,
    input 	     h_hclk,       // Host Clock
    input 	     t_crt_clk,    // CRT clock
    input            h_reset_n,    // Reset
    input            g_gr05_b5,    // Serializer shift mode control bit
    input            g_gr05_b6,    // Indicates 256 color mode
    input            c_shift_ld,   // Load signal to Attribute serializer
    input            c_shift_clk,  // Attribute serializer shift clock
    input            c_dclk_en,    // dot clock
    input            c_9dot,
    input [3:0]      dport_addr,
    input [36:0]     m_att_data,   // Memory data containing pixel information
    input            m_sr04_b3,    // chain-4
    input            ar10_b0,      // Graphics mode bit
    input            ar10_b1,
    input            ar10_b2,
    input            ar10_b3,
    input            ar10_b7,
    input [3:0]      ar12_b,
    input [3:0]      ar14_b,   
    input            cursor_blink_rate,
    input            char_blink_rate,
    input            final_cursor,
    input            pal_reg_bank_b7_b6_rd,
    input [15:0]     h_io_dbus,
    input 	     dport_we,
    
    output [5:0]     dport_out,
    output           color_256_mode, // mux control signals to choose from
    output [7:0]     sta_final_data  // serializer a final data
    );

  reg [7:0] 	     st1a_pix_ff;
  reg [7:0]          st2a_pix_ff;
  reg [7:0]          st3a_pix_ff;
  reg [7:0]          st4a_pix_ff;
  reg [31:0]         mux_op;   
  reg [1:0]          int_io_dbus;   
  reg [7:0]          asr0_q;        // output of shift register 0
  reg [7:0]          asr1_q;        // output of shift register 1
  reg [7:0]          asr2_q;        // output of shift register 2
  reg [7:0]          asr3_q;        // output of shift register 3

  wire	       	     planar_mode;    // mux_in0, mux_in1
  wire	       	     text_mode;      // mux_in2,
  wire	       	     special_packed_m4_5;
  wire [5:0]         dprb_din;      // pallette reg. bank input
  wire [31:0]        mux_in0;
  wire [31:0]        mux_in1;
  wire [31:0]        mux_in2;
  wire [31:0]        mux_in4;
  wire               reg_chain_ctl; // This control signal is used to control 
                                    // the muxes which are chaining four 8-bit
                                    //  shift registers
  wire [7:0]         asr0_din;      // input to shift register 0
  wire [7:0]         asr1_din;      // input to shift register 1
  wire [7:0]         asr2_din;      // input to shift register 2
  wire [7:0]         asr3_din;      // input to shift register 3
  wire	       	     asr0_sin;      // serial input for shift register 0
  wire	       	     asr1_sin;      // serial input for shift register 1  
  wire [7:0]         pixel_op;
  wire [7:0]         st1a_pix_din;
  wire [7:0]         st1a_pix_dout;
  wire [7:0]         st2a_pix_din;
  wire [7:0]         st2a_pix_dout;
  wire [7:0]         st3a_pix_din;   // bypass pallette reg. data and use this
  wire [7:0]         st3a_pix_dout;  // bypass pallette reg. data and use this
  wire [7:0]         st4a_mux_in0;
  wire [7:0]         st4a_pix_din;
  wire	       	     plane3_data;
  wire               intensity;
  wire	       	     ninth_font;
  wire	       	     final_font;
  wire               int_pix_0;
  wire	       	     int_pix_1;
  wire	       	     int_pix_2;
  wire [5:0]         st3a_dp_pix;
  wire [1:0]         pixel_bit_5_4;
  wire	       	     pal_byp;
  wire               int_font;
  wire               intensity_ctl;
  wire	       	     text_n = ar10_b0;
  wire               int_mux1;
  wire               int_mux2;
  wire               mod_bit3;
  wire               new_asr3_q7;
  wire               en_9dot_ld;
  wire               new_m_att_data_34;
  wire               new_asr3_q3;
  wire               int_mux0;
  wire               int_mux4;
  
  assign             color_256_mode  = g_gr05_b6 & (~g_gr05_b5) & text_n;
  assign             planar_mode     = (~g_gr05_b6) & (~g_gr05_b5) & (text_n);
  assign             text_mode             = ~text_n;
  assign             special_packed_m4_5   = text_n & (~g_gr05_b6) & g_gr05_b5;
  assign             reg_chain_ctl         = m_sr04_b3 & g_gr05_b5;
  
  // preparing data for five input mux. mux_in0 is 256 color mode
  assign             mux_in0   = { m_att_data[0], m_att_data[8],  
                                   m_att_data[16], m_att_data[24],
      	       	     	           m_att_data[4], m_att_data[12], 
                                   m_att_data[20], m_att_data[28],
      	       	     	           m_att_data[1], m_att_data[9],  
                                   m_att_data[17], m_att_data[25],
      	       	     	           m_att_data[5], m_att_data[13],
                                   m_att_data[21], m_att_data[29],
      	       	     	           m_att_data[2], m_att_data[10],
                                   m_att_data[18], m_att_data[26],
      	       	     	           m_att_data[6], m_att_data[14],
                                   m_att_data[22], m_att_data[30],
      	       	     	           m_att_data[3], m_att_data[11],
                                   m_att_data[19], m_att_data[27],
      	       	     	           m_att_data[7], m_att_data[15],
                                   m_att_data[23], m_att_data[31] };

  // planar mode
  assign             mux_in1   = { m_att_data[7:0], m_att_data[15:8],
                                   m_att_data[23:16], m_att_data[31:24] };
  
  // text mode
  assign             en_9dot_ld = c_9dot & pre_load;
  
  assign             new_m_att_data_34 = en_9dot_ld ? 1'b0 : m_att_data[34];
  
  assign             mux_in2   = { m_att_data[7:4], m_att_data[35], 
                                   new_m_att_data_34, m_att_data[33], 
                                   final_cursor,
                                   m_att_data[15:8],
                                   m_att_data[23:16],
                                   ninth_font, m_att_data[31:25] };
  
  // Modes 4&5, special packed
  assign             mux_in4   = { m_att_data[6],  m_att_data[4],  
				   m_att_data[2],  m_att_data[0],
      	       	     	           m_att_data[14], m_att_data[12], 
				   m_att_data[10], m_att_data[8],
      	       	     	           m_att_data[7],  m_att_data[5],  
				   m_att_data[3],  m_att_data[1],
      	       	     	           m_att_data[15], m_att_data[13], 
				   m_att_data[11], m_att_data[9],
      	       	     	           m_att_data[22], m_att_data[20], 
				   m_att_data[18], m_att_data[16],
      	       	     	           m_att_data[30], m_att_data[28], 
				   m_att_data[26], m_att_data[24],
      	       	     	           m_att_data[23], m_att_data[21], 
				   m_att_data[19], m_att_data[17],
      	       	     	           m_att_data[31], m_att_data[29], 
				   m_att_data[27], m_att_data[25] };
  
  always @* begin    
    if      (color_256_mode)      mux_op = mux_in0;
    else if (planar_mode)         mux_op = mux_in1;
    else if (text_mode)           mux_op = mux_in2;
    else if (special_packed_m4_5) mux_op = mux_in4;
    else                          mux_op = 32'b0;
    
  end


  assign asr0_sin  = reg_chain_ctl ? asr2_q[7] : asr1_q[7];
  assign asr1_sin  = reg_chain_ctl ? asr3_q[7] : asr2_q[7];

  // Instantiating four 8-bit shift registera and chaining them
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      asr0_q <= 8'd0;
      asr1_q <= 8'd0;
    end else if (c_shift_clk) begin
      if (c_shift_ld) begin
	asr0_q <= mux_op[31:24];
	asr1_q <= mux_op[23:16];
      end else if (~text_mode) begin
	asr0_q <= {asr0_q[6:0], asr0_sin};
	asr1_q <= {asr1_q[6:0], asr1_sin};
      end
    end
    
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      asr2_q <= 8'd0;
      asr3_q <= 8'd0;
    end else if (c_shift_clk) begin
      if (c_shift_ld) begin
	asr2_q <= mux_op[15:8];
	asr3_q <= mux_op[7:0];
      end else begin
	asr2_q <= {asr2_q[6:0], asr3_q[7]};
	asr3_q <= {asr3_q[6:0], 1'b0};
      end
    end

  assign int_mux0 = ar10_b1 ? char_blink_rate : ~asr3_q[7];
  assign int_mux1 = ar10_b3 ? int_mux0 : asr3_q[7];
  assign int_mux2 = ar10_b3 & asr3_q[7] & char_blink_rate;
  
  assign mod_bit3  = int_mux1 | int_mux2;
  
  assign new_asr3_q7  = text_n ? mod_bit3 : asr3_q[7];
  
  
  assign int_mux4 = ar10_b3 ? char_blink_rate : asr3_q[3];  
  
  assign new_asr3_q3 = text_n ? int_mux4 : asr3_q[3];
  
  
  
  assign pixel_op = { new_asr3_q3, asr2_q[3], asr1_q[3], asr0_q[3],
      	       	      new_asr3_q7, asr2_q[7], asr1_q[7], asr0_q[7] };
  
  // Generation of Attribute information
  // asr0_q[1] - blank, asr0_q[2] - under line, asr0_q[0] - cursor
  assign intensity   = intensity_ctl ? asr1_q[3] : ( (~ar10_b3) & asr1_q[7]);
  
  assign ninth_font  = c_9dot ? (m_att_data[36] & m_att_data[16] & ar10_b2) :
      	       	     	      	  m_att_data[31];
  
  assign int_font    = ( asr0_q[2] | asr2_q[7] ) &
      	       	     	 (~(ar10_b3 & char_blink_rate & asr1_q[7] & (~asr0_q[0])));
  
  assign final_font  = asr0_q[0] | ( int_font & (~asr0_q[1]) );
  
  assign intensity_ctl = int_font | asr0_q[0];
  
  assign int_pix_2        =  final_font ? asr1_q[2] : asr1_q[6];
  assign int_pix_1        =  final_font ? asr1_q[1] : asr1_q[5];
  assign int_pix_0        =  final_font ? asr1_q[0] : asr1_q[4];      

  assign st1a_pix_din[7:6] =  pixel_op[7:6];
  assign st1a_pix_din[5:4] =  text_n ? pixel_op[5:4] : {2{intensity}};
  assign st1a_pix_din[3]   =  text_n ? pixel_op[3] : intensity;
  assign st1a_pix_din[2]   =  text_n ? pixel_op[2] : int_pix_2;
  assign st1a_pix_din[1]   =  text_n ? pixel_op[1] : int_pix_1;
  assign st1a_pix_din[0]   =  text_n ? pixel_op[0] : int_pix_0;      
  
  // Inferring stage 1 flops
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)     st1a_pix_ff <= 8'b0;
    else if (c_dclk_en) st1a_pix_ff <= #1 st1a_pix_din;
  
  assign st1a_pix_dout = st1a_pix_ff;
  
  // Generating the inputs for second stage.
  // ar10_b3 - Blink enable, ar12_b[3:0] - enable plane[3:0],
  // ar10_b1 - Monochrome emulation
  assign st2a_pix_din[2:0] =  st1a_pix_dout[2:0] & ar12_b[2:0];
  assign plane3_data       =  st1a_pix_dout[3] & ar12_b[3];
  
  assign st2a_pix_din[3]  =    plane3_data;
  
  assign st2a_pix_din[7:4] = st1a_pix_dout[7:4];
  
  // Inferring stage 2 flops
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)     st2a_pix_ff <= 8'b0;
    else if (c_dclk_en) st2a_pix_ff <= #1 st2a_pix_din;

  assign st2a_pix_dout = st2a_pix_ff;
   
  assign st3a_pix_din = st2a_pix_dout;
   
  // Inferring stage 3 flops
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)     st3a_pix_ff <= 8'b0;
    else if (c_dclk_en) st3a_pix_ff <= #1 st3a_pix_din;

  assign st3a_pix_dout = st3a_pix_ff;

  // Infering a 16x6 pallete register bank
  assign dprb_din =  h_io_dbus[5:0];
  
  dual_port_16x6 DPRB
    (
     .h_reset_n (h_reset_n),            // host reset
     .h_hclk    (h_hclk),
     .clk       (t_crt_clk),
     .clk_en    (c_dclk_en),
     .we        (dport_we),	        // write enable from host
     .addr1     (dport_addr),    	// read enable1 from host
     .addr2     (st2a_pix_dout[3:0]),   // read enable2
     .din       (h_io_dbus[5:0]),       // data input   from host
     .dout1     (dport_out[5:0]),       // data output   from host
     .dout2     (st3a_dp_pix[5:0])	// data output from reg. bank
     );
		  
  // Forcing the upper two bits of palette register bank to "0" whenever there
  // is a read to any of the registers in the register bank.
  assign pixel_bit_5_4 = ar10_b7 ? ar14_b[1:0] : st3a_dp_pix[5:4];
  assign st4a_mux_in0  = { ar14_b[3:2], pixel_bit_5_4, st3a_dp_pix[3:0] };
  assign pal_byp       = color_256_mode;
  assign st4a_pix_din  = pal_byp ? st3a_pix_dout : st4a_mux_in0;
  
  // Inferring stage 4 flops
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)     st4a_pix_ff <= 8'b0;
    else if (c_dclk_en) st4a_pix_ff <= #1 st4a_pix_din;

  assign sta_final_data = st4a_pix_ff;

endmodule
