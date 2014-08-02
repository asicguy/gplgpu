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
//  Title       :  Vertical CRT Controller
//  File        :  vcrt.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module generates vertical synchronization
//   signals for CRT display. This module includes various
//   registers that allow different configuration options.
//   This module provides split-screen capability and smooth
//   scrolling. This module includes the following registers.
//  
//   0. CR06 - Vertical total Register
//   1. CR07 - Overflow Register
//   2. CR10 - Vertical Sync. Start Register
//   3. CR11 - Vertical Sync. End Register
//   4. CR12 - Vertical Display End Register
//   5. CR15 - Vertical Blank Start Register
//   6. CR16 - Vertical Blank End Register
//   7. CR18 - Line Compare Register
//
//   c_crt_line_end and txt_crt_line_end are same except that txt_crt_line_end
//   does not come when c_pre_vde is active.
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

module vcrt
  (
   input        m_soft_rst_n,	
   input        h_reset_n,
   input        h_hclk,
   input        color_mode,     // 1 = color mode, 0 = mono misc_b0
   input        h_io_16,        // 16 bit access = 1, 8 bit = 0
   input        h_io_wr,        // IO write cycle
   input [15:0] h_addr,         // Host address
   input [5:0]  c_crtc_index,   // CRT register index
   input [7:0]  c_ext_index,    // Extended mode Index
   input        cclk_en,        // character clock
   input        lclk_or_by_2,   // line clock or line clock by 2
   input        cr03_b7,        // Compatible read
   input        cr17_b7,        // hsync and vsync enabler
   input        cr09_b6,        // Line compare bit 9
   input        cr09_b5,        // Vertical Blanking start bit 9
   input        misc_b7,        // vertical sync. polarity. misc_b7
   input        vsync_sel_ctl,  // 1 - oring of vsync & vde, 0 - normal vsync
   input        int_crt_line_end,
   input        t_crt_clk,
   input [15:8] h_io_dbus,      // Data bus
   input        vga_en,         // Disable CRT and REF req's
   
   output reg [7:0] reg_cr06,
   output reg [7:0] reg_cr07,
   output reg [7:0] reg_cr10,
   output reg [7:0] reg_cr11,
   output reg [7:0] reg_cr12,
   output reg [7:0] reg_cr15,
   output reg [7:0] reg_cr16,
   output reg [7:0] reg_cr18,
   output       vsync_vde,       // For status into reg_ins1
   output       cr11_b4,         // Clear vertical interrupt
   output       cr11_b5,         // Disable vertical interrupt
   output       cr11_b7,         // Write protect CR7 through CR0
   output       c_vde,           // Vertical display timing strobe
   output       c_pre_vde,       // Vertical Display will start next scan line
   output       c_vert_blank,    // the vertical blanking period
   output       c_t_vsync,       // Vertical sync to Monitor
   output       line_cmp,        // the succeeding lines will be in Screen B.
   output       byte_pan_en,     // Byte pan updating
   output       pel_pan_en,      // pelpan update
   output       c_vdisp_end,     // End of vertical display
   output       c_split_screen_pulse,  // Syn. to crt_line_end
   output       int_split_screen_pulse,  // not Syn. to crt_line_end
   output       c_crt_line_end,
   output       txt_crt_line_end,
   output reg   txt_crt_line_end_pulse,
   output       c_raw_vsync,
   output       lncmp_zero,      // Line compare register is loaded with zero
   output reg	[10:0] vcrt_cntr_op
   );
  
  reg           vde_ff;
  reg           vblank_ff;
  reg           vsync_ff;
  reg           lncmp_eq_ff;
  reg           line_cmp_ff;
  reg           vblank_e_eq;
  reg           vdisp_end_ff;
  reg           sync_ssp_ff;
  reg           syn_vsync_ff;
  reg           vsync_e_eq;
  reg 		sync_soft0, sync_soft1;
  reg           vga_en0, en_req;
  
  wire [10:0] 	vtotal;   // Vertical total
  wire [10:0] 	vdisp;    // Vertical Display End
  wire [10:0] 	vblank_s; // Vertical Blanking Start  
  wire [ 9:0] 	vblank_e; // Vertical Blanking End
  wire [10:0] 	vsync_s;  // Vertical Sync Start
  wire [ 5:0] 	vsync_e;  // Vertical Sync  End
  wire [10:0] 	lncmp;    // Line Compare reister
  wire 		vt_eq;    //  A pulse is generated when vtotal equal
                          //  to vcrt_cntr_op.
  
  wire 		lncmp_eq_ff_din;
  wire 		vdisp_eq;
  wire 		vblank_s_eq;
  wire 		vsync_s_eq;
  wire 		lncmp_eq_raw;
  wire 		lower_equal;
  reg 		vt_eq_d;
  wire 		vt_pulse_n;
  wire 		vtotal_vdisp;
  wire 		int_vdisp_end;
  wire 		vblank_eq_s_or_e;
  wire 		vsync_eq_s_or_e;
  wire 		int_vsync;
  wire 		int_vsync2;
  wire 		raw_vsync;
  wire 		split_screen_pulse;
  
  reg 		int_crt_line_end_d; // int_crt_line_end delayed w.r.t falling edge of
  reg 		int_crt_line_end_dd; // int_crt_line_end delayed w.r.t falling edge of
  // of int_crt_line_end
  wire 		vsync_en = cr17_b7 ;    // vertical sync. enabler
  wire 		vsync_pol = misc_b7;
  wire 		le_vsync_e;
  wire 		split_screen_zero;
  
  reg 		raw_vsync_ff;

  //Instantiating an up counter with async. reset( active low ).
  wire 		vcrt_cntr_rst_n =  vt_pulse_n;
  assign 	vt_pulse_n = ~vt_eq_d;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)                     vcrt_cntr_op <= 11'b0;
    else if (lclk_or_by_2)
      if (~vcrt_cntr_rst_n) vcrt_cntr_op <= 11'b0;
      else                  vcrt_cntr_op <= vcrt_cntr_op + 1'b1;
  
  // Instantiating vcrt registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      reg_cr06 <= 8'h0;
      reg_cr07 <= 8'h0;
      reg_cr10 <= 8'h0;
      reg_cr11 <= 8'h0;
      reg_cr12 <= 8'h0;
      reg_cr15 <= 8'h0;
      reg_cr16 <= 8'h0;
      reg_cr18 <= 8'h0;
    end else if (h_io_wr) begin
      case (h_addr)
	// Mono CRT Index 
	16'h03b4: begin
	  if (!color_mode) begin
	    if (h_io_16) begin
	      case (c_crtc_index[5:0])
		6'h6:  if (~cr11_b7) reg_cr06 <= h_io_dbus;
		6'h7:  begin
		  if (~cr11_b7) reg_cr07[7:5] <= h_io_dbus[15:13];
		  reg_cr07[4] <= h_io_dbus[12];
		  if (~cr11_b7) reg_cr07[3:0] <= h_io_dbus[11:8];
		end
		6'h10: reg_cr10 <= h_io_dbus;
		6'h11: reg_cr11 <= h_io_dbus;
		6'h12: reg_cr12 <= h_io_dbus;
		6'h15: reg_cr15 <= h_io_dbus;
		6'h16: reg_cr16 <= h_io_dbus;
		6'h18: reg_cr18 <= h_io_dbus;
	      endcase // case(c_crtc_index[5:0])
	    end
	  end
	end
	
	// Mono CRT Data
	16'h03b5: begin
	  if (!color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h6:  if (~cr11_b7) reg_cr06 <= h_io_dbus;
	      6'h7:  begin
		if (~cr11_b7) reg_cr07[7:5] <= h_io_dbus[15:13];
		reg_cr07[4] <= h_io_dbus[12];
		if (~cr11_b7) reg_cr07[3:0] <= h_io_dbus[11:8];
	      end
	      6'h10: reg_cr10 <= h_io_dbus;
	      6'h11: reg_cr11 <= h_io_dbus;
	      6'h12: reg_cr12 <= h_io_dbus;
	      6'h15: reg_cr15 <= h_io_dbus;
	      6'h16: reg_cr16 <= h_io_dbus;
	      6'h18: reg_cr18 <= h_io_dbus;
	    endcase // case(c_crtc_index[5:0])
	  end
	end
	
	// Color CRT Index 
	16'h03d4: begin
	  if (color_mode) begin
	    if (h_io_16) begin
	      case (c_crtc_index[5:0])
		6'h6:  if (~cr11_b7) reg_cr06 <= h_io_dbus;
		6'h7:  begin
		  if (~cr11_b7) reg_cr07[7:5] <= h_io_dbus[15:13];
		  reg_cr07[4] <= h_io_dbus[12];
		  if (~cr11_b7) reg_cr07[3:0] <= h_io_dbus[11:8];
		end
		6'h10: reg_cr10 <= h_io_dbus;
		6'h11: reg_cr11 <= h_io_dbus;
		6'h12: reg_cr12 <= h_io_dbus;
		6'h15: reg_cr15 <= h_io_dbus;
		6'h16: reg_cr16 <= h_io_dbus;
		6'h18: reg_cr18 <= h_io_dbus;
	      endcase // case(c_crtc_index[5:0])
	    end
	  end
	end
	
	// Color CRT Data
	16'h03d5: begin
	  if (color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h6:  if (~cr11_b7) reg_cr06 <= h_io_dbus;
	      6'h7:  begin
		if (~cr11_b7) reg_cr07[7:5] <= h_io_dbus[15:13];
		reg_cr07[4] <= h_io_dbus[12];
		if (~cr11_b7) reg_cr07[3:0] <= h_io_dbus[11:8];
	      end
	      6'h10: reg_cr10 <= h_io_dbus;
	      6'h11: reg_cr11 <= h_io_dbus;
	      6'h12: reg_cr12 <= h_io_dbus;
	      6'h15: reg_cr15 <= h_io_dbus;
	      6'h16: reg_cr16 <= h_io_dbus;
	      6'h18: reg_cr18 <= h_io_dbus;
	    endcase // case(c_crtc_index[5:0])
	  end
	end
      endcase // case(h_addr)
    end
  
  assign         cr11_b4 = reg_cr11[4];
  assign         cr11_b5 = reg_cr11[5];
  assign         cr11_b7 = reg_cr11[7];      
  
  assign         vtotal   = {1'b0, reg_cr07[5], reg_cr07[0], reg_cr06 }; // 11 bits
  assign         vdisp    = {1'b0, reg_cr07[6], reg_cr07[1], reg_cr12 }; // 11 bits
  assign         vblank_s = {1'b0, cr09_b5, reg_cr07[3], reg_cr15 }; // 11 bits
  assign         vblank_e = {1'b0, reg_cr16 }; // 10 bits
  assign         vsync_s  = {1'b0, reg_cr07[7], reg_cr07[2], reg_cr10 }; // 11 bits
  assign         vsync_e  = {1'b0, reg_cr11[3:0] }; // 5 bits
  assign         lncmp    = {1'b0, cr09_b6, reg_cr07[4], reg_cr18 };
  
  // Doing comparisons on all registers with vcrt_cntr_op
  
  assign         vt_eq           = ( vcrt_cntr_op == vtotal);
  assign         vdisp_eq        = ( vcrt_cntr_op == vdisp);
  assign         vblank_s_eq     = ( vcrt_cntr_op == vblank_s);
  assign         vsync_s_eq      = ( vcrt_cntr_op == vsync_s);
  assign         lncmp_eq_raw    = ( vcrt_cntr_op == lncmp);
  assign         lncmp_zero      = ( lncmp == { 11{1'b0} });
  
  assign         lower_equal  = (vcrt_cntr_op[7:0] == vblank_e[7:0]);
  assign         le_vsync_e   = (vcrt_cntr_op[3:0] == vsync_e[3:0]);
  
  always @(lower_equal)
    vblank_e_eq = lower_equal; // In vga mode, compare only lower 8 bits
  
  always @(le_vsync_e)
    vsync_e_eq = le_vsync_e; // In vga mode, compare only lower 4 bits
  

  // We need to delay vt_eq by 1 lclk_or_by_2's and then generate a reset 
  // pulse to vcrt_cntr

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) vt_eq_d <= 1'b0;
    else if (lclk_or_by_2) vt_eq_d <= vt_eq;
  
  assign         vtotal_vdisp = vde_ff ? (~vdisp_eq) : vt_eq_d;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) vde_ff <= 1'b0;
    else if (lclk_or_by_2) vde_ff <= vtotal_vdisp;
  
  assign         c_vde = vde_ff;
  
  // Generating c_crt_line_end
  always @(posedge t_crt_clk or negedge h_reset_n) 
    if (!h_reset_n) begin
      int_crt_line_end_d <= 1'b0;
      int_crt_line_end_dd <= 1'b0;
      txt_crt_line_end_pulse <= 1'b0;
    end else begin
      if (int_crt_line_end & cclk_en) begin
	int_crt_line_end_d  <= c_vde;
      end
      if (txt_crt_line_end & ~int_crt_line_end_dd) begin
	txt_crt_line_end_pulse <= 1'b1;
	int_crt_line_end_dd <= 1'b1;
      end else begin
	txt_crt_line_end_pulse <= 1'b0;
	if (~txt_crt_line_end) int_crt_line_end_dd <= 1'b0;
      end
    end
  
  assign         txt_crt_line_end = int_crt_line_end & int_crt_line_end_d ;
  
  //
  //  m_soft_rst_n is an active low soft reset, when active c_crt_line_end is
  //  issued to the memory module.
  //  if vga is enabled, generate the requests normally, else mask them out, 
  assign         c_crt_line_end = (txt_crt_line_end | c_pre_vde | 
				   ~sync_soft1) & en_req;
  
  // Synchronize soft reset to the crt clock
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      sync_soft0 <= 1'b0;
      sync_soft1 <= 1'b0;
      vga_en0    <= 1'b0;
      en_req     <= 1'b0;
    end else begin
      sync_soft0 <= m_soft_rst_n;
      sync_soft1 <= sync_soft0;
      vga_en0    <= vga_en;
      en_req     <= vga_en0;
    end
  
  // Generating vdisp_end signal
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) vdisp_end_ff <= 1'b0;
    else if (lclk_or_by_2) vdisp_end_ff <= vde_ff;
  
  assign         int_vdisp_end = ~(vde_ff | (~vdisp_end_ff));
  assign         c_vdisp_end   = int_vdisp_end & int_crt_line_end;
  
  
  assign         vblank_eq_s_or_e = vblank_ff ? (~vblank_e_eq) : vblank_s_eq;	 	 
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) vblank_ff <= 1'b0;
    else if (lclk_or_by_2) vblank_ff <= vblank_eq_s_or_e;

  assign         c_vert_blank = vblank_ff;
  
  assign         vsync_eq_s_or_e = vsync_ff ? (~vsync_e_eq) : vsync_s_eq;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) vsync_ff <= 1'b0;
    else if (lclk_or_by_2) vsync_ff <= vsync_eq_s_or_e;
  
  assign         raw_vsync   = vsync_ff;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      raw_vsync_ff <= 1'b0;
    else
      raw_vsync_ff <= raw_vsync;
  
  
  assign         c_raw_vsync = raw_vsync_ff;
  
  
  assign         int_vsync  = (raw_vsync & vsync_en) ^ vsync_pol;
  
  assign         int_vsync2 = int_vsync;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      syn_vsync_ff <= 1'b0;
    else
      syn_vsync_ff <= int_vsync2;
  
  assign         c_t_vsync = syn_vsync_ff;
  
  assign         lncmp_eq_ff_din = ( (lncmp_eq_ff | lncmp_eq_raw) & vde_ff );
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      lncmp_eq_ff <=  1'b0;
    else if (cclk_en)
      lncmp_eq_ff <= lncmp_eq_ff_din;
  
  assign         int_split_screen_pulse = c_split_screen_pulse;
  assign         split_screen_pulse     = ( (c_pre_vde & lncmp_zero) |
      	       	     	      	            ((~lncmp_zero)&int_split_screen_pulse) );
  
  // Sync. split_screen_pulse w.r.t falling edge of int_crt_line_end
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      sync_ssp_ff <= 1'b0;
    else if(int_crt_line_end & cclk_en)
      sync_ssp_ff <= lncmp_eq_ff;
  
  assign         c_split_screen_pulse = lncmp_eq_ff & (~sync_ssp_ff);
  assign         split_screen_zero = lncmp_zero | lncmp_eq_ff;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(  ~h_reset_n)
      line_cmp_ff <=  1'b0;
    else if (cclk_en) begin
      if(split_screen_zero & vde_ff)
	line_cmp_ff <=  1'b1;
      else if(~vde_ff)
	line_cmp_ff <=  1'b0;
    end
  
  
  assign         line_cmp  = line_cmp_ff;
  assign         c_pre_vde = vt_eq_d & int_crt_line_end;
  
  assign 	 byte_pan_en = c_pre_vde;
  assign 	 pel_pan_en = c_pre_vde;

  assign 	 vsync_vde = vsync_sel_ctl ? ( c_t_vsync | c_vde ) : c_t_vsync;

endmodule   

