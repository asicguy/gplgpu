///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2005
//  This File is based upon: crt_op_stage.v
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Curtis Wright for use in FPGA development specifically for add-in
//  boards. Any other use of this source code must be discussed with Silicon
//  Spectrum and this copyright notice must be maintained.
//  Silicon Spectrum does not give up the copyright to the original file or
//  encumber in any way it's use except where related to Curtis Wright add-in
//  board business for the period set out in the original agreement.
//
//  Title       :  Key Output signals from CRTC.
//  File        :  crt_op_stage.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   Generates some critical signals such as composite
//   display enable, blank, line clock.
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
  module crt_op_stage
    (
     input       h_reset_n,
     input       c_vde,            // Vertical display enable
     input       cr11_b4,          // clear vertical interrupt
     input       cr11_b5,          // disable vertical interrupt
     input       a_arx_b5,         // Video enable
     input       m_sr01_b5,        // Full band width for host
     input       vblank,           // Vertical blank
     input       hblank,           // Horizontal blank
     input       cclk_en,          // char. clock
     input       dclk_en,          // dot clock
     input       hde,              // Horizontal display enable
     input       c_ahde,	   // advance horizontal display enable.
     input       int_crt_line_end, // indicates the end of current scan line
     input       t_crt_clk, 
     input       a_ar10_b0,
     input       vga_en,           // Disable screen when vga is not enabled
     
     output      c_t_crt_int,      // Interrupt to indicate vertical retrace
     output      c_attr_de,        /* This signal indicates the actual display
				    * enable to the attribute control */
     output      c_t_cblank_n,     // Composite Blank to RAMDAC
     output      ade,              // composite advance display enable
     output      screen_off,
     output      dis_en_sta
     );
	       
  reg 		 ade_ff;
  reg 		 intrpt_ff;
  reg 		 gated_hde_ff;
  reg 		 syn_cblank_ff;
  reg [2:0] 	 int_attr_de_d;
  reg [4:0] 	 int_cblank_d_dc;
  reg [2:0] 	 hde_d_cc;
  reg [1:0] 	 vde_syn_cclk;
  reg [1:0] 	 sr01_b5_syn_cclk;
  wire 		 comp_blank;
  reg [3:0] 	 comp_blank_d_cc;
  wire 		 int_cblank;
  wire 		 int_intrpt;
  wire 		 arx_b5_syn_cclk;
  wire 		 clr_intrpt_n = cr11_b4;
  wire 		 int_attr_de;
  reg [1:0] 	 sync1;
  wire [4:0] 	 h_blank_d_dc;
  
  // generating c_attr_de. Synchronize a_arx_b5 and c_vde
  // w.r.t cclk. Delay hde by 2 cclk's in Graphics and 3 cclk's in Text mode.
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      hde_d_cc <= 3'b0;
      sync1 <= 2'b0;
      vde_syn_cclk <= 2'b0;
      sr01_b5_syn_cclk <= 2'b11;
      comp_blank_d_cc <= 4'b0;
    end else if (cclk_en) begin
      hde_d_cc <= {hde_d_cc[1:0], hde};
      sync1 <= {sync1[0], a_arx_b5};
      vde_syn_cclk <= {vde_syn_cclk[0], c_vde};
      sr01_b5_syn_cclk <= {sr01_b5_syn_cclk[0], (m_sr01_b5 | ~vga_en)};
      comp_blank_d_cc <= {comp_blank_d_cc[2:0], comp_blank};
    end

  assign arx_b5_syn_cclk = sync1[1];
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)   gated_hde_ff <=  1'b0;
    else if (dclk_en) gated_hde_ff <=  ( arx_b5_syn_cclk & hde_d_cc[2] );
	   
  assign      int_attr_de = gated_hde_ff & vde_syn_cclk[1];
   
  assign      dis_en_sta = ~(hde_d_cc[2] & vde_syn_cclk[1]);

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   int_attr_de_d <= 3'b0;
    else if (dclk_en) int_attr_de_d <= {int_attr_de_d[1:0], int_attr_de};
		  
  assign      c_attr_de = int_attr_de_d[2];
  
  assign      screen_off = sr01_b5_syn_cclk[1];
   
  assign      comp_blank = vblank | hblank;
   
  assign      int_cblank = sr01_b5_syn_cclk[1] | comp_blank_d_cc[3];

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   int_cblank_d_dc <= 5'b0;
    else if (dclk_en) int_cblank_d_dc <= {int_cblank_d_dc[3:0], int_cblank};
		  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n) syn_cblank_ff <= 1'b0;
    else           syn_cblank_ff <= int_cblank_d_dc[4];
	 
  assign      c_t_cblank_n = ~syn_cblank_ff;

  assign      int_intrpt = ( intrpt_ff | (~c_vde) ) & cr11_b4;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)    intrpt_ff <= 1'b0;
    else if (cclk_en) intrpt_ff <= int_intrpt;
	
  assign      c_t_crt_int       = intrpt_ff;

  // Generating advance composite display enable
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (~h_reset_n)                      ade_ff <= 1'b0;
    else if (int_crt_line_end & cclk_en) ade_ff <= c_vde;
	 
  assign      ade = ade_ff & c_ahde;
    
endmodule   

