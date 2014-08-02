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
//  Title       :  Text character height
//  File        :  txt_time.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module determines the character height and takes
//   into account the split screen effect.  
//   Generates the cursor & underline Y- position.   
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
`define   SCAN_LINE_CNTR_WIDTH 5

module txt_time
  (
   input      	    h_reset_n,
   input 	    h_hclk,
   input 	    color_mode,     // 1 = color mode, 0 = mono misc_b0
   input 	    h_io_16,        // 16 bit access = 1, 8 bit = 0
   input 	    h_io_wr,        // IO write cycle
   input [15:0]	    h_addr,         // Host address
   input [5:0] 	    c_crtc_index,   // CRT register index
   input 	    t_crt_clk,
   input       	    cclk_en, 	 // character clock
   input            dclk_en,
   input    	    int_pre_vde,    // Vertical Display start next scan line
   input       	    int_split_screen_pulse,
   input       	    txt_crt_line_end,       // the end of current scan line
   input       	    txt_crt_line_end_pulse, // the end of current scan line
   input            c_vdisp_end,
   input            lncmp_zero,     // Line compare register is loaded with 0
   input [7:0] 	    h_io_dbus,
   
   output [7:0]	    reg_cr08,
   output reg [7:0] reg_cr09,
   output [7:0]	    reg_cr0a,   
   output [7:0]	    reg_cr0b,
   output [7:0]	    reg_cr14,
   output           cr08_b5,
   output           cr08_b6,
   output           cr09_b5,        // Vertical Blanking start bit 9
   output           cr09_b6,        // Line compare bit 9
   output           c_cr0b_b5,      // Text cursor skew control bit 0
   output           c_cr0b_b6,      // Text cursor skew control bit 1
   output           c_cr0a_b5,      // Disable Text cursor
   output           cr14_b5,        // Count by four
   output           c_cr14_b6,      // Double word mode
   output           c_uln_on,       // under line on
   output           c_cursor_on_line,
   output reg [4:0] c_slc_op,       // scan line counter output
   output           c_row_end       // end of row
   );

  reg 		 old_slc_en;
  reg            cursor_width_ff;
  reg            ul_eq_ff;
  reg            cle_by_2_shaped;
  reg            vdisp_end_pulse;
  reg            int_pre_vde_pulse;
  reg [6:0] 	 store_cr08;
  reg [5:0] 	 store_cr0a;
  reg [6:0] 	 store_cr0b;
  reg [6:0] 	 store_cr14;
  reg [1:0] 	 c_vdisp_end_d;
  reg [1:0] 	 int_pre_vde_d;
  reg [1:0] 	 sync0, sync1;

  wire           sync_cr09_b7;
  wire [4:0] 	 reg_ch;    // cell height
  wire [4:0]     reg_cs;    // cursor start
  wire [4:0]     reg_ce;    // cursor end
  wire [4:0]     reg_ul;    // cursor undel line
  wire           slc_ld; // scan line counter load control signal
  wire [4:0]     slc_data; // scan line counter load data
  wire           ch_eq; // A pluse is generated when reg_ch == c_slc_op
  wire           cs_eq; // A pluse is generated when reg_cs == c_slc_op
  wire           ce_eq; // A pluse is generated when reg_ce == c_slc_op
  wire           ul_eq; // A pluse is generated when reg_ul == c_slc_op
  reg 		 ce_eq_d;
  reg 		 ch_eq_d;
  wire           cs_le_ce; //  cursor start is less than or equal to cursor end
  wire           cs_le_ch; //  cursor start is less than or equal to cursor height
  wire           ch_pulse;
  wire           cursor_eq_s_or_e;
  wire           slc_en;      // Scan. line counter clock
  reg            cle_by_2;     // txt_crt_line_end by 2 clock
  reg 		 cle_by_2_d;   // cle_by_2 delayed by 1 cclk
  wire           cle_or_by_2;  // txt_crt_line_end or txt_crt_line_end by 2 clock
  wire           reg_ch_zero;	       // reg. Cell Height is programmed to zero
  wire           sync_re_sel_ctl;     // Sync. c_row_end select control
  wire           tmp_slc_clk;
  reg 		 ch_pulse_d;
  wire           final_ch_pulse;

  // Divide txt_crt_line_end by 2
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)                  cle_by_2 <= 1'b1;
    else if (txt_crt_line_end_pulse) cle_by_2 <= ~cle_by_2;
  
  // Shaping the pulse width of cle_by_2.
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   cle_by_2_d <= 1'b0;
    else if (cclk_en) cle_by_2_d <= cle_by_2;
  
  always @(cle_by_2 or cle_by_2_d)
    cle_by_2_shaped = cle_by_2 &(~cle_by_2_d);
  
  // Sync. cr09_b7 w.r.t rising edge of txt_crt_line_end in the first stage,
  // rising edge of cclk in the second stage.
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      sync0 <= 2'b0;
      sync1 <= 2'b0;
    end else if (cclk_en) begin
      sync0 <= {sync0[0], reg_cr09[7]};
      sync1 <= {sync1[0], reg_ch_zero};
    end

  assign 	 sync_cr09_b7 = sync0[1];
  assign 	 sync_re_sel_ctl = sync1[1];

  assign         cle_or_by_2 = sync_cr09_b7 ? cle_by_2_shaped : txt_crt_line_end;

  assign         c_row_end = sync_re_sel_ctl ? cle_or_by_2 : final_ch_pulse;

  // Generating vdisp_end_pulse of one dclk
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   c_vdisp_end_d <= 2'b0;
    else if (dclk_en) c_vdisp_end_d <= {c_vdisp_end_d[0], c_vdisp_end};
  
  always @(c_vdisp_end_d)
    vdisp_end_pulse = c_vdisp_end_d[0] &(~c_vdisp_end_d[1]);

  // Generating int_pre_vde_pulse of one dclk
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   int_pre_vde_d <= 2'b0;
    else if (dclk_en) int_pre_vde_d <= {int_pre_vde_d[0], int_pre_vde};

  always @(int_pre_vde_d)
    int_pre_vde_pulse = int_pre_vde_d[0] & (~int_pre_vde_d[1]);


  //Instantiating an up counter with sync. reset( active low ).
  assign         slc_ld  = ch_pulse | int_pre_vde | int_split_screen_pulse | c_vdisp_end;
  assign         slc_data = ( int_pre_vde & (~lncmp_zero) ) ? reg_cr08[4:0] : 5'b0;
  assign         tmp_slc_clk  = cle_or_by_2 | int_pre_vde_pulse | vdisp_end_pulse;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) old_slc_en <= 1'b0;
    else            old_slc_en <= tmp_slc_clk;

  assign         slc_en  = ~old_slc_en & tmp_slc_clk;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)  c_slc_op <= 5'b0;
    else if (slc_en) begin
      if (slc_ld) c_slc_op <= slc_data;
      else        c_slc_op <= c_slc_op + 1;  
    end
  
  assign 	 reg_cr08 = {1'b0, store_cr08};
  assign 	 reg_cr0a = {2'b0, store_cr0a};
  assign 	 reg_cr0b = {1'b0, store_cr0b};
  assign 	 reg_cr14 = {1'b0, store_cr14};
  
  // Instantiating txt_time registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (~h_reset_n) begin
      store_cr08 <= 7'b0;
      reg_cr09   <= 8'b0;
      store_cr0a <= 6'b0;
      store_cr0b <= 7'b0;
      store_cr14 <= 7'b0;
    end else if (h_io_wr) begin
      case (h_addr)

	// Mono CRT Index
	16'h03b4: begin
	  if (!color_mode)
	    if (h_io_16) begin
	      // We can access the CRT Data registers if we are in 16 bit mode
	      case (c_crtc_index[5:0])
		6'h8: store_cr08  <= h_io_dbus[6:0];
		6'h9: reg_cr09    <= h_io_dbus;
		6'ha: store_cr0a  <= h_io_dbus[5:0];
		6'hb: store_cr0b  <= h_io_dbus[6:0];
		6'h14: store_cr14 <= h_io_dbus[6:0];
	      endcase // case(c_crtc_index[5:5])
	    end
	end

	// Mono CRT Data
	16'h03b5: begin
	  if (!color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h8: store_cr08  <= h_io_dbus[6:0];
	      6'h9: reg_cr09    <= h_io_dbus;
	      6'ha: store_cr0a  <= h_io_dbus[5:0];
	      6'hb: store_cr0b  <= h_io_dbus[6:0];
	      6'h14: store_cr14 <= h_io_dbus[6:0];
	    endcase // case(c_crtc_index[5:5])
	  end
	end
	
	// Color CRT Index
	16'h03d4: begin
	  if (color_mode)
	    if (h_io_16) begin
	      // We can access the CRT Data registers if we are in 16 bit mode
	      case (c_crtc_index[5:0])
		6'h8: store_cr08  <= h_io_dbus[6:0];	
		6'h9: reg_cr09    <= h_io_dbus;
		6'ha: store_cr0a  <= h_io_dbus[5:0];	
		6'hb: store_cr0b  <= h_io_dbus[6:0];
		6'h14: store_cr14 <= h_io_dbus[6:0];
	      endcase // case(c_crtc_index[5:5])
	    end
	end

	// Color CRT Data
	16'h03d5: begin
	  if (color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h8: store_cr08  <= h_io_dbus[6:0];
	      6'h9: reg_cr09    <= h_io_dbus;
	      6'ha: store_cr0a  <= h_io_dbus[5:0];
	      6'hb: store_cr0b  <= h_io_dbus[6:0];
	      6'h14: store_cr14 <= h_io_dbus[6:0];
	    endcase // case(c_crtc_index[5:5])
	  end
	end
      endcase // case(h_addr)
    end
  
  assign         reg_ch = reg_cr09[4:0];
  assign         reg_cs = reg_cr0a[4:0];
  assign         reg_ce = reg_cr0b[4:0];
  assign         reg_ul = reg_cr14[4:0];
  
  // Doing comparisons on all registers with c_slc_op
  assign         ch_eq = (c_slc_op == reg_ch);
  assign         cs_eq = (c_slc_op == reg_cs);
  assign         ce_eq = (c_slc_op == reg_ce);
  assign         ul_eq = (c_slc_op == reg_ul);
  assign         reg_ch_zero = (reg_ch == 5'b0);   
  

  // We need to delay ce_eq by 1 slc_clk to make the pulse width of 
  // cursor_on_line equal to (reg_ce - reg_cs + 1).
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)  ce_eq_d <= 1'b0;
    else if (slc_en) ce_eq_d <= ce_eq;

  // We need to delay ch_eq by 1 slc_clk and then generate a reset pulse to
  // scan line counter.
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)  ch_eq_d <= 1'b0;
    else if (slc_en) ch_eq_d <= ch_eq;
  
  assign         ch_pulse = ( ((~ch_eq_d) & ch_eq) | reg_ch_zero );
  
  // Generating final_ch_pulse of one cclk
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   ch_pulse_d <= 1'b0;
    else if (cclk_en) ch_pulse_d <= ch_eq_d;
  
  assign         final_ch_pulse    = ch_eq_d & (~ch_pulse_d);

  assign         cursor_eq_s_or_e = cursor_width_ff ? (~ce_eq_d) : cs_eq;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      cursor_width_ff <=  1'b0;
    else if(tmp_slc_clk & cclk_en)
      cursor_width_ff <=  cursor_eq_s_or_e;
  
  assign         cs_le_ce = (reg_cs <= reg_ce);
  assign         cs_le_ch = (reg_cs <= reg_ch);
  
  assign         c_cursor_on_line = cs_le_ce & cs_le_ch & cursor_width_ff;

  // Using the flop to get rid of glitches on ul_eq to generate c_uln_on
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      ul_eq_ff <=  1'b0;
    else if(tmp_slc_clk & cclk_en)
      ul_eq_ff <=  ul_eq;
  
  assign         c_uln_on = ul_eq_ff;
  

  assign         cr08_b5 = reg_cr08[5];
  assign         cr08_b6 = reg_cr08[6]; 
  assign         cr09_b5 = reg_cr09[5];
  assign         cr09_b6 = reg_cr09[6];

  assign         c_cr0b_b5 = reg_cr0b[5];
  assign         c_cr0b_b6 = reg_cr0b[6];
  assign         c_cr0a_b5 = reg_cr0a[5];
  assign         c_cr14_b6 = reg_cr14[6];   

  assign         cr14_b5   = reg_cr14[5];

endmodule
