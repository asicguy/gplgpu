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
//  Title       :  extension register instances.
//  File        :  crt_misc.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   Contains extension registers (40-4E), CR17 and 
//   Feature Control registers.
//   The decodes for all the registers are being generated
//   outside of this module in "crt_reg_dec.v"
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
module  crt_misc
  (
   input             dis_en_sta,
   input             c_raw_vsync,
   input             h_reset_n,
   input 	     h_hclk,
   input 	     color_mode,     // 1 = color mode, 0 = mono misc_b0
   input 	     h_io_16,        // 16 bit access = 1, 8 bit = 0
   input 	     h_io_wr,        // IO write cycle
   input [15:0]      h_addr,         // Host address
   input [5:0] 	     c_crtc_index,   // CRT register index
   input [7:0] 	     c_ext_index,    // Extended mode Index
   input             t_sense_n,      // Monitor sense input from RAMDAC
   input             c_t_crt_int,    // Interrupt to indicate vertical retrace
   input             a_is01_b5,      // Video diagnostic (pixel data) bits
   input             a_is01_b4,      // Video diagnostic (pixel data) bits
   input             vsync_vde,      // vertical retrace ored with vde
   input [15:0]      h_io_dbus,
   
   output [7:0]      reg_ins0,
   output [7:0]      reg_ins1,
   output [7:0]      reg_fcr,   
   output reg [7:0]  reg_cr17,
   output            c_cr17_b0,
   output            c_cr17_b1,
   output            cr17_b2,
   output            cr17_b3,
   output            c_cr17_b5,
   output            c_cr17_b6,
   output            cr17_b7,
   output            vsync_sel_ctl
   );
  
  reg 		  str_fcr;   

  // Instantiating extension registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      str_fcr  <= 1'b0;
      reg_cr17 <= 8'b0;
    end else if (h_io_wr) begin
      case (h_addr)

	// Mono CRT Index
	16'h03b4: begin
	  if (!color_mode)
	    if (h_io_16) begin
	      // We can access the CRT Data registers if we are in 16 bit mode
	      case (c_crtc_index[5:0])
		6'h17: reg_cr17 <= {h_io_dbus[15:13], 1'b0, h_io_dbus[11:8]};
	      endcase // case(c_crtc_index[5:5])
	    end
	end

	// Mono CRT Data
	16'h03b5: begin
	  if (!color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h17: reg_cr17 <= {h_io_dbus[15:13], 1'b0, h_io_dbus[11:8]};
	    endcase // case(c_crtc_index[5:5])
	  end
	end

	16'h03ba: if (!color_mode) str_fcr <= h_io_dbus[3];
	
	// Color CRT Index
	16'h03d4: begin
	  if (color_mode)
	    if (h_io_16) begin
	      // We can access the CRT Data registers if we are in 16 bit mode
	      case (c_crtc_index[5:0])
		6'h17: reg_cr17 <= {h_io_dbus[15:13], 1'b0, h_io_dbus[11:8]};
	      endcase // case(c_crtc_index[5:5])
	    end
	end

	// Color CRT Data
	16'h03d5: begin
	  if (color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h17: reg_cr17 <= {h_io_dbus[15:13], 1'b0, h_io_dbus[11:8]};
	    endcase // case(c_crtc_index[5:5])
	  end
	end

	16'h03da: if (color_mode) str_fcr <= h_io_dbus[3];

      endcase // case(h_addr)
    end

  assign reg_fcr  = {4'b0, str_fcr, 3'b0};
  
  assign vsync_sel_ctl = str_fcr;
  assign reg_ins0 = {c_t_crt_int, 2'b00, t_sense_n, 4'b0000};
  
  assign reg_ins1 = {2'b00, a_is01_b5, a_is01_b4, c_raw_vsync, 
		     2'b00, dis_en_sta };
  assign c_cr17_b0 = reg_cr17[0];
  assign c_cr17_b1 = reg_cr17[1];
  assign cr17_b2   = reg_cr17[2];
  assign cr17_b3   = reg_cr17[3];
  assign c_cr17_b5 = reg_cr17[5];
  assign c_cr17_b6 = reg_cr17[6];
  assign cr17_b7   = reg_cr17[7];
  
endmodule
