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
//  Title       :  CRT Registers decoding logic 
//  File        :  crt_reg_dec.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module does rd/wr decoding for CR registers. 
//   The decoding supports 16-bit and 8-bit writes.
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
module  crt_reg_dec
  (
   input      	    h_reset_n,
   input   	    h_iord,
   input   	    h_iowr,
   input            h_hclk,
   input   	    h_io_16,
   input            h_io_8,
   input       	    misc_b0,        // 0- 3bx, 1- 3dx
   input   	    h_dec_3bx,
   input            h_dec_3cx,
   input   	    h_dec_3dx,
   input            m_dec_sr07,
   input            m_dec_sr00_sr06,
   input [15:0]     h_io_addr,
   input [15:0]     h_io_dbus,
   
   output [7:0]     crtc_index,     // crtc index register
   output reg [7:0] ext_index,      // extension index register
   output 	    trim_wr,        // delayed write strobe to load data reg
   output           c_gr_ext_en,
   output [3:0]     c_ext_index_b,
   output      	    crt_mod_rd_en_hb,
   output           crt_mod_rd_en_lb,
   output           c_ready_n,
   output           sr_00_06_wr,    // any iowrite to 3C5 index = 00 thru 06.
   output           sr07_wr,
   output      	    cr24_rd,
   output      	    cr26_rd,
   output      	    c_dec_3ba_or_3da,
   output           c_cr0c_f13_22_hit
   );
  
  reg [7:0] 	    int_io_dbus;
  reg [5:0] 	    store_index;
  reg 		    rd_or_wr_d;
  reg 		    h_iowr_d;   // h_iowr is delayed by one h_hclk

  wire 		    fcr_rd, fcr_wr; // for generating ready_n
  wire 		    ins0_rd, ins1_rd;
  wire	       	    crt_index_hit;
  wire              ext_index_hit;
  wire              crt_reg_hit;
  wire              crt_index_wr;
  wire              crt_reg_en;
  wire        	    crt_index_rd;
  wire              rd_or_wr;
  wire	       	    dec_3bx_or_3dx;
  wire              cr_reg_hit;
  wire	       	    crt_io_hit_hb;
  wire              crt_io_hit_lb;
  wire              index_from_crtc;
  wire              addr_sel = misc_b0;
  
  // Instantiating crtc index  registers
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) begin
      store_index <= 6'h0;
      ext_index   <= 8'h0;
    end else if (h_iowr) begin
      if (crt_index_hit) store_index <= h_io_dbus[5:0];
      if (ext_index_hit) ext_index <= {4'b0, h_io_dbus[3:0]};
    end
  
  assign            crtc_index = {2'b0, store_index};

  assign            c_ext_index_b[3:0] = ext_index[3:0];
  assign            c_gr_ext_en = 1'b1;
  
  // We need to delay h_iowr signal by one h_hclk to support 16 bit writing.
  // To avoid wr glitches, we first write into index register(lower byte) and
  // then with one h_hclk delay, data will be written into the data
  // register(upper byte). During one h_hclk delay, the decoder output will
  // become stable and clean.
  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) h_iowr_d <= 1'b0;
    else            h_iowr_d <= h_iowr;

  // iowrite pulse for data register writes.
  assign            trim_wr = h_iowr & h_iowr_d;  
  
  assign            crt_index_hit = addr_sel ? (h_io_addr == 16'h3d4) :
      						 (h_io_addr == 16'h3b4);
  
  assign            crt_reg_hit = addr_sel ? (h_io_addr == 16'h3d5) :
      	       	     	      	               (h_io_addr == 16'h3b5);
  
  assign            crt_index_wr  = crt_index_hit & h_iowr;
  assign            crt_index_rd  = crt_index_hit & h_iord;
  
  assign            crt_reg_en    = ( (crt_index_hit & h_io_16) | crt_reg_hit );
  
  assign            cr24_rd = (crtc_index == 36) & h_iord;
  assign            cr26_rd = (crtc_index == 38) & h_iord;   

  
  // Decode for Extension registers
  assign            ext_index_hit = (h_io_addr == 16'h3ce) ;

  // Write into extension index register when ext_index_hit is true and h_iowr
  // is true.
  // The password must be set before any writes can take place to the
  // extension data registers. 

  assign            sr_00_06_wr = m_dec_sr00_sr06 & h_iowr;
  assign            sr07_wr     = m_dec_sr07 & h_iowr;

  assign            dec_3bx_or_3dx = h_dec_3bx | h_dec_3dx;
  
  // Generating crt_io_hit by checking that the address range falls into one
  // of the IO register of crt module
  assign            cr_reg_hit =  crt_reg_en
      	       	    & (   ((crtc_index >= 8'h00) & (crtc_index <= 8'h0b))
		      	  | ((crtc_index >= 8'h10) & (crtc_index <= 8'h18) &
			     (crtc_index != 8'h13)) );

  
  assign            crt_io_hit_hb = cr_reg_hit;

  // Lower byte bus is enabled for all 16-bit operations and even addressed 
  // 8-bit operations.
  // Whenever there is a read for er30 to er39, cr0c to cr0f, cr13, cr24 , cr26
  // and if that is 16-bit operation, index has to come from crtc module.
  // crt_index_hit & h_io_8 - 8-bit read to CR index register
  // ext_index_hit & h_io_8 - 8-bit read to ER index register
  // 3CC: misc rd or write
  assign            c_dec_3ba_or_3da = addr_sel ? (h_io_addr == 16'h03da) : 
						    (h_io_addr == 16'h03ba);
  assign            fcr_wr = c_dec_3ba_or_3da & h_iowr;
  assign            fcr_rd = (h_io_addr == 16'h03ca) & h_iord;
  assign            ins0_rd = (h_io_addr == 16'h03c2) & h_iord;
  assign            ins1_rd = c_dec_3ba_or_3da & h_iord;

  assign            crt_io_hit_lb = (h_io_addr == 16'h3cc & h_iord) | 
				      (h_io_addr == 16'h3c2 & h_iowr) |
					ins0_rd | ins1_rd |
      	       	    fcr_rd | fcr_wr | 
		    (ext_index_hit & (h_io_16 | h_io_8)) |
		    (crt_index_hit & (h_io_16 | h_io_8));

  // delay (h_iowr | h_iord) by one h_hclk and then give it out as c_ready_n
  
  assign            rd_or_wr = h_iowr | h_iord;

  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) rd_or_wr_d <= 1'b0;
    else            rd_or_wr_d <= rd_or_wr;
  
  assign            c_ready_n = (~(rd_or_wr_d & (crt_io_hit_hb | 
						 crt_io_hit_lb)));


  // Decoding for io hit for any of cr00 to cr0b, cr10 to cr18, misc, ins0, 
  // ins1 and fcr .
  assign            crt_mod_rd_en_hb = crt_io_hit_hb & h_iord;


  assign            crt_mod_rd_en_lb = (crt_io_hit_lb | 
					(index_from_crtc & h_io_16)) & h_iord;
  
  // Decoding for io hit for any of cr0c to cr0f or cr13
  assign            c_cr0c_f13_22_hit = crt_reg_en & ( ((crtc_index >= 8'h0c) &
      	       	     	                                (crtc_index <= 8'h0f))
			                               | (crtc_index == 19)
			                               | (crtc_index == 34));

  assign            index_from_crtc = c_cr0c_f13_22_hit | 
		    cr24_rd | cr26_rd ;
  
endmodule

