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
//  Title       :  Final Cursor
//  File        :  final_cursor.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
//   This module generates the final cursor by using the
//   cursor-y and cursor-x position.  The cursor blinking
//   is achieved by counting 32 Vsync's.
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

module final_cursor
  (
   input       h_reset_n,
   input       t_crt_clk,
   input       c_shift_ld,        // Load signal to Attribute serializer
   input       m_att_data_b32, 	  // cursor text attribute
   input       c_cr0b_b6,         // Text cursor skew control 1
   input       c_cr0b_b5,         // Text cursor skew control 0
   input       c_cr0a_b5,         // Disable Text cursor
   input       c_t_vsync,         // Vertical sync.
   input       ar12_b4,           // cursor blink disable (Vid status mux [0])
   
   output      cursor_blink_rate,
   output      finalcursor,
   output      char_blink_rate
   );

  reg         mux_op;
  reg [2:0]   shifted_data;
  reg 	      ctvsync_hold;
  reg [4:0]   blink_rate;
  
  wire [2:0]  m_att_data_b32_d; // delayed m_att_data_b32
  wire        int_final_cursor;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)      shifted_data <= 3'b0;
    else if (c_shift_ld) shifted_data <= {shifted_data[1:0], m_att_data_b32};

  assign      m_att_data_b32_d = shifted_data;

  // CR06[6:5] defines the skew applied to the cursor for proper alignment
  always @*
    case({c_cr0b_b6, c_cr0b_b5})
      2'b00: mux_op = m_att_data_b32;
      2'b01: mux_op = m_att_data_b32_d[0];
      2'b10: mux_op = m_att_data_b32_d[1];
      2'b11: mux_op = m_att_data_b32_d[2];
    endcase

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      ctvsync_hold <= 1'b0;
      blink_rate <= 5'b0;
    end else begin
      ctvsync_hold <= c_t_vsync;

      // Disable blinking if this bit is set. 
      if (ar12_b4) 
	blink_rate <= 5'b0;
      // Otherwise increment the blinker on every edge of vertical sync.
      // The actual edge should not matter.
      else if (c_t_vsync && ~ctvsync_hold)
        blink_rate <= blink_rate + 1'b1;
    end

  // Cursor blinks faster than characters
  assign cursor_blink_rate = ~blink_rate[3];
  
  assign char_blink_rate = blink_rate[4];
  
  assign int_final_cursor = ~( ~cursor_blink_rate  |  (~mux_op) );
  
  assign finalcursor = (int_final_cursor & (~c_cr0a_b5));
  
endmodule

