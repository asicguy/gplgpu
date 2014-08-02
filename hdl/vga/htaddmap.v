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
//  Title       :  Host Address mapping
//  File        :  htaddmap.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module does the address scramble of the host
//   address before sending to the graphic module. The
//   address scramble is done based on odd/even mode or
//   chain4 mode.
//   This module also does the host address map based on
//   the enable linear addr map bit (er35_bit0). The mapA
//   and mapB offset registers are used here to differenciate
//   between graphic address and mapped address.
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
module htaddmap 
  (
   input             mem_read,
   input             cpu_rd_gnt,   
   input             svmem_hit_we,
   input             svmem_sel_hit,   
   input             svga_sel_hit,   
   input             t_mem_io_n,
   input [31:0]      h_mem_dbus_out,   
   input             memwr_inpr,
   input             mem_write,
   input             cy2_gnt,
   input             cy3_gnt,
   input             cy4_gnt,
   input [3:0]       h_byte_en_n,
   input             m_planar,
   input             cpucy_1_2,
   input             cpucy_2_2,
   input             cpucy_1_3,
   input             cpucy_2_3,
   input             cpucy_3_3,
   input             cpucy_1_4,
   input             cpucy_2_4,
   input             cpucy_3_4,
   input             cpucy_4_4,
   input [22:0]      h_mem_addr,
   input             c_mis_3c2_b5,
   input             gr6_b2,
   input             gr6_b3,
   input             g_gr06_b1,
   input             m_odd_even,
   input             m_chain4,
   input [3:0]       m_sr02_b,
   
   output [19:0]     val_mrdwr_addr,   
   output [7:0]      fin_plane_sel,
   output reg        en_cy1,
   output reg        en_cy2,
   output reg        en_cy3,
   output reg        en_cy4,
   output [31:0]     sftw_h_mem_dbus,
   output reg        odd_8bit
   );
  
  //
  // 	 Define Variables
  //
  reg [7:0] int_val_plane_sel;
  reg [19:0] int_val_mem_addr;   
  reg 	     odd_a0;
  reg [1:0]  new_addr_out;
  reg 	     rd_en0, rd_en1, rd_en2, rd_en3;
  reg 	     pla_en_cy1, pla_en_cy2, pla_en_cy3, pla_en_cy4;
  reg 	     odd_en_cy1, odd_en_cy2;
  reg 	     ch_en_cy1;
  reg 	     pla_rd_en0;
  reg 	     pla_rd_en1;
  reg 	     pla_rd_en2;
  reg 	     pla_rd_en3;
  reg 	     odd_rd_en0;
  reg 	     odd_rd_en1;
  reg 	     odd_rd_en2;
  reg 	     odd_rd_en3;
  reg 	     ch8pl7, ch8pl6, ch8pl5;
  reg 	     ch8pl4, ch8pl3, ch8pl2;
  reg 	     ch8pl1, ch8pl0;
  reg [7:0]  int16_plane_sel;
  reg [19:0] pla_val_mem_addr;
  reg [7:0]  pla_val_plane_sel;
  reg [19:0] odd_val_mem_addr;
  reg [7:0]  odd_val_plane_sel;
  reg [19:0] chain_val_mem_addr;
  reg [7:0]  chain_val_plane_sel;
  reg [19:0] ext8bp_val_mem_addr;
  reg [7:0]  ext8bp_val_plane_sel;
  reg [1:0]  scr_addr_out;
  reg [19:0] pla_read_addr;
  reg [19:0] odd_read_addr;
  reg [19:0] chain_read_addr;
  reg [19:0] int_memrd_addr;
  reg [31:0] sft_h_mem_dbus;    
  
  wire 	     n16_en;
  wire 	     en_32k;
  wire 	     en_64k;
  wire 	     en_128k;
  wire 	     ln_addr15;
  wire 	     ln_addr17;
  wire [10:0] shift_cpu_ad;
  wire [19:9] map_add_out;
  wire [19:0] mapped_cpu_addr;
  wire 	      odd_sel0;
  wire 	      odd_sel1;
  wire 	      odd_sel2;
  wire 	      chain_a1;
  wire 	      chain_a0;
  wire 	      odd_a1;
  wire [1:0]  odd_addr;
  wire [1:0]  chain_addr;
  wire [22:0] int_g_addr_out;
  wire 	      new_addr17;
  wire 	      new_addr16;  
  wire 	      new_addr15;
  wire 	      bit8_mode;
  wire 	      bit16_mode;
  wire 	      bit32_mode;
  wire [7:0]  int8_plane_sel;
  wire 	      pla_16m_32;
  wire 	      pla_16m_64;
  wire 	      pla_8m_32;
  wire 	      pla_8m_64;
  wire 	      odd_8m_32;
  wire 	      odd_8m_64;
  wire 	      odd_16m_32;
  wire 	      odd_16m_64;
  wire 	      odd_32m_32;
  wire 	      odd_32m_64;
  wire 	      chain_8m_32;
  wire 	      chain_8m_64;
  wire 	      chain_16m_32;
  wire 	      chain_16m_64;
  wire 	      chain_32m_32;
  wire 	      chain_32m_64;
  wire 	      pla_32;
  wire 	      odd_32;
  wire 	      chain_32;
  wire 	      chain_32new;
  wire [7:0]  int16_plane_cy1;
  wire [7:0]  int16_plane_cy2;
  wire 	      pla_32m_32;
  wire 	      pla_32m_64;
  wire [7:0]  int32_plane_cy1;    
  wire [7:0]  int32_plane_cy2;
  wire [7:0]  int32_plane_cy3;
  wire [7:0]  int32_plnae_cy4;
  wire 	      int8_odd_pl0, int8_odd_pl1, int8_odd_pl2, int8_odd_pl3;
  wire 	      int8_odd64_pl0, int8_odd64_pl1, int8_odd64_pl2, int8_odd64_pl3;
  wire 	      int8_odd64_pl4, int8_odd64_pl5, int8_odd64_pl6, int8_odd64_pl7;
  wire [7:0]  int16_odd_pl;
  wire [3:0]  int32_odd_c1;
  wire [3:0]  int32_odd_c2;
  wire 	      int8_c32_pl0, int8_c32_pl1;
  wire 	      int8_c32_pl2, int8_c32_pl3;
  wire 	      ch32_pl0, ch32_pl1;
  wire 	      ch32_pl2, ch32_pl3;
  wire 	      c64_pl01, c64_pl23;
  wire 	      c64_pl45, c64_pl67;
  wire [7:0]  int_c64;
  wire [7:0]  int32_plane_cy4;
  wire [19:0] int_mwr_addr;
  wire [19:0] fin_scr_addr;
  wire 	      en_32or64k;
  wire 	      en_32to128k;
  wire 	      ext8bp_8m_32;
  wire 	      ext8bp_8m_64;
  wire 	      ext8bp_16m_32;
  wire 	      ext8bp_16m_64;
  wire 	      ext8bp_32m_32;
  wire 	      ext8bp_32m_64;
  wire 	      e832_pl3, e832_pl2, e832_pl1, e832_pl0;
  wire 	      e864_pl3, e864_pl2, e864_pl1, e864_pl0;
  wire 	      e864_pl7, e864_pl6, e864_pl5, e864_pl4;
  wire 	      e1664_pl3, e1664_pl2, e1664_pl1, e1664_pl0;
  wire 	      e1664_pl7, e1664_pl6, e1664_pl5, e1664_pl4;
  wire [19:0] man_rdwr_addr;
  wire 	      cha_ext;
  
  assign      int_g_addr_out[22:0] = h_mem_addr[22:0];
  
  
  //
  //  Address mapping Block
  //  The input is 20 bit address generated from the address manipulation
  //  module [man_rdwr_addr[19:0]]
  //
  assign      shift_cpu_ad = {2'b0, new_addr17, new_addr16, 
                              new_addr15, man_rdwr_addr[14:9] };
  
  assign      en_32k = gr6_b3;
  
  assign      en_64k = ~gr6_b3 & gr6_b2;
  
  assign      en_128k = ~gr6_b3 & ~gr6_b2;
  
  assign      ln_addr15 = man_rdwr_addr[15];
  
  assign      new_addr15 = en_32k ? 1'b0 : ln_addr15;
  
  assign      en_32or64k = en_32k | en_64k;
  
  assign      en_32to128k = en_32k | en_64k | en_128k;
  
  assign      new_addr16 = en_32or64k ? 1'b0 : man_rdwr_addr[16];
  
  assign      new_addr17 = en_32to128k ? 1'b0 : man_rdwr_addr[17];
  
  assign      map_add_out = shift_cpu_ad;
  
  assign      mapped_cpu_addr[19:0] = {map_add_out[19:9], 
                                       man_rdwr_addr[8:0]};

  //
  // Generation of Address scramble logic
  // Here the input used is mapped_cpu_addr[19:0]
  //
  
  assign      odd_sel0   = gr6_b3 & gr6_b2 & g_gr06_b1;
  
  assign      odd_sel1   = ~(gr6_b3 & gr6_b2) & g_gr06_b1;
  
  assign      odd_sel2   = ~(gr6_b3 & gr6_b2) & ~g_gr06_b1;
  
  
  always @* begin
    if (odd_sel0)      odd_a0 = mapped_cpu_addr[0];
    else if (odd_sel1) odd_a0 = ~c_mis_3c2_b5;
    else if (odd_sel2) odd_a0 = mapped_cpu_addr[14];
    else               odd_a0 = mapped_cpu_addr[0];
  end
  
  assign odd_a1 = mapped_cpu_addr[1];
  
  assign chain_a0 = mapped_cpu_addr[14];
  
  assign chain_a1 = mapped_cpu_addr[15];
  
  assign odd_addr = {odd_a1, odd_a0};
  
  assign chain_addr = {chain_a1, chain_a0};
  
  always @* begin
    if (m_odd_even)    scr_addr_out[1:0] = odd_addr;
    else if (chain_32) scr_addr_out[1:0] = chain_addr;
    else               scr_addr_out[1:0] = mapped_cpu_addr[1:0];
  end

  //
  // The output of the scramble block is fin_scr_addr[19:0]
  // 

  assign fin_scr_addr[19:0] = {mapped_cpu_addr[19:2], scr_addr_out[1:0]};   
  
  //
  //    Planar, 8bit_mode and both 32bit and 64bit memory.
  //
  
  assign pla_32 = m_planar;
  assign int8_plane_sel[7:0] = {{4{int_g_addr_out[0]}}, 
                                {4{~int_g_addr_out[0]}}};
  
  //
  //   Planar mode
  //
  
  always @* begin
    pla_rd_en0 = 1'b0;
    pla_rd_en1 = 1'b0;
    pla_rd_en2 = 1'b0;
    pla_rd_en3 = 1'b0;
    pla_en_cy1 = 1'b0;
    pla_en_cy2 = 1'b0;
    pla_en_cy3 = 1'b0;
    pla_en_cy4 = 1'b0;
    
    case (h_byte_en_n)  // synopsys parallel_case full_case
      
      4'b1111: begin
        pla_en_cy1 = 1'b1;
	pla_val_mem_addr  = {20'b0};
        pla_val_plane_sel = {4'b0, 4'b0};
      end
      4'b1110: begin
        pla_en_cy1 = 1'b1;
        pla_rd_en0        = 1'b1;
        pla_val_plane_sel = {4'b0, 4'b1111};
	if (pla_32) pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
        else        pla_val_mem_addr  =  {int_g_addr_out[20:2], 1'b0};
      end
      
      4'b1101: begin
        pla_en_cy1 = 1'b1;
        pla_rd_en1        = 1'b1;
	if(pla_32) begin
	  pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel = {4'b0, 4'b1111};
        end else begin
          pla_val_mem_addr  =  {int_g_addr_out[20:2], 1'b0};
	  pla_val_plane_sel = {4'b1111, 4'b0};
	end
      end
      
      4'b1100: begin
        pla_en_cy2 = 1'b1;
	if (pla_32 & cy2_gnt & cpucy_1_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en0	    = 1'b1;
        end else if (pla_32 & cy2_gnt & cpucy_2_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
	  pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en1        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b1011: begin
	pla_en_cy1 = 1'b1;
	if (pla_32) begin
	  pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else begin
          pla_val_mem_addr  =  {int_g_addr_out[20:2], 1'b1}; 
	  pla_val_plane_sel =  {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
	end
      end
      
      4'b1010: begin
        pla_en_cy2 = 1'b1;
	if(pla_32 & cy2_gnt & cpucy_1_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en0        = 1'b1;
        end else if (pla_32 & cy2_gnt & cpucy_2_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
	  pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b1001: begin
        pla_en_cy2 = 1'b1;
	if(pla_32 & cy2_gnt & cpucy_1_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en1        = 1'b1;
        end else if (pla_32 & cy2_gnt & cpucy_2_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
	  pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b1000: begin
        pla_en_cy3 = 1'b1;
        if(pla_32 & cy3_gnt & cpucy_1_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en0        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_2_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en1        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_3_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0111: begin
        pla_en_cy1 = 1'b1;
	if (pla_32) begin
	  pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr  = {int_g_addr_out[20:2], 1'b1}; //REDO
	  pla_val_plane_sel = {4'b1111, 4'b0};
          pla_rd_en3        = 1'b1;
	end
      end
      
      4'b0110: begin
        pla_en_cy2 = 1'b1;
	if(pla_32 & cy2_gnt & cpucy_1_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en0        = 1'b1;
        end else if (pla_32 & cy2_gnt & cpucy_2_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
	  pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0101: begin
        pla_en_cy2 = 1'b1;
	if(pla_32 & cy2_gnt & cpucy_1_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en1        = 1'b1;
        end else if (pla_32 & cy2_gnt & cpucy_2_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
	  pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0100: begin
        pla_en_cy3 = 1'b1;
        if(pla_32 & cy3_gnt & cpucy_1_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en0        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_2_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en1        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_3_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0011: begin
        pla_en_cy2 = 1'b1;
	if(pla_32 & cy2_gnt & cpucy_1_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else if (pla_32 & cy2_gnt & cpucy_2_2) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
	  pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end

      4'b0010: begin
        pla_en_cy3 = 1'b1;
        if(pla_32 & cy3_gnt & cpucy_1_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en0        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_2_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_3_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0001: begin
        pla_en_cy3 = 1'b1;
        if(pla_32 & cy3_gnt & cpucy_1_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en1        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_2_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en2        = 1'b1;
        end else if (pla_32 & cy3_gnt & cpucy_3_3) begin
          pla_val_mem_addr  = {int_g_addr_out[19:2], 2'b11};
          pla_val_plane_sel = {4'b0, 4'b1111};
          pla_rd_en3        = 1'b1;
        end else begin
          pla_val_mem_addr       = 20'b0;
          pla_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0000: begin
        pla_en_cy4 = 1'b1;
	if (pla_32 & cy4_gnt & cpucy_1_4) begin
          pla_val_mem_addr       = {int_g_addr_out[19:2], 2'b00};
          pla_val_plane_sel[7:0] = {4'b0, 4'b1111};
          pla_rd_en0             = 1'b1;
        end else if (pla_32 & cy4_gnt & cpucy_2_4) begin
          pla_val_mem_addr       = {int_g_addr_out[19:2], 2'b01};
          pla_val_plane_sel[7:0] = {4'b0, 4'b1111};
          pla_rd_en1             = 1'b1;
        end else if (pla_32 & cy4_gnt & cpucy_3_4) begin
          pla_val_mem_addr       = {int_g_addr_out[19:2], 2'b10};
          pla_val_plane_sel[7:0] = {4'b0, 4'b1111};
          pla_rd_en2             = 1'b1;
        end else if (pla_32 & cy4_gnt & cpucy_4_4) begin
          pla_val_mem_addr       = {int_g_addr_out[19:2], 2'b11};
          pla_val_plane_sel[7:0] = {4'b0, 4'b1111};
          pla_rd_en3             = 1'b1;
        end else begin
	  pla_val_mem_addr       = 20'b0;
	  pla_val_plane_sel[7:0] = 8'b0;
	end
      end
      
    endcase
    
  end
  
  //
  //   Begining of m_odd_even mode 
  //
  always @* begin
    odd_rd_en0 = 1'b0;
    odd_rd_en1 = 1'b0;
    odd_rd_en2 = 1'b0;
    odd_rd_en3 = 1'b0;
    odd_en_cy1 = 1'b0;
    odd_en_cy2 = 1'b0;
    odd_8bit   = 1'b0;
    
    case (h_byte_en_n)   // synopsys parallel_case  full_case
      4'b1111: begin
        odd_en_cy1 = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {20'b0};
          odd_val_plane_sel = {8'b0};
          odd_rd_en0            = 1'b0;
          odd_rd_en1            = 1'b0;
        end else begin
          odd_val_mem_addr  =  20'b0;
       	  odd_val_plane_sel =  8'b0;
          odd_rd_en0            = 1'b0;
	  odd_rd_en1            = 1'b0;
	end
      end
      
      4'b1110: begin
	odd_8bit     = 1'b1;
        odd_en_cy1   = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b0101}; 
          odd_rd_en0            = 1'b1;
        end else begin
          odd_val_mem_addr  =  int_g_addr_out[21:2];
	  odd_val_plane_sel =  {4'b0, 4'b0101};
          odd_rd_en0            = 1'b1;
	end
      end
      
      4'b1101: begin
	odd_8bit     = 1'b1;
        odd_en_cy1   = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en1            = 1'b1;
        end else begin
          odd_val_mem_addr  =  int_g_addr_out[21:2];
          odd_val_plane_sel =  {4'b0, 4'b1010};
	  odd_rd_en1            = 1'b1;
	end
      end

      4'b1100: begin
        odd_en_cy1   = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1111 };
          odd_rd_en0            = 1'b1;
          odd_rd_en1            = 1'b1;
        end else begin
          odd_val_mem_addr  =  int_g_addr_out[21:2];
       	  odd_val_plane_sel =  {4'b0, 4'b1111};
          odd_rd_en0            = 1'b1;
	  odd_rd_en1            = 1'b1;
	end
      end
      
      4'b1011: begin
	odd_8bit    = 1'b1;
        odd_en_cy1  = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en2            = 1'b1;
        end else begin
          odd_val_mem_addr  =  int_g_addr_out[21:2];
       	  odd_val_plane_sel =  {4'b0101, 4'b0};
          odd_rd_en2            = 1'b1;
	end
      end
      
      4'b1010: begin
	odd_8bit     = 1'b1;
        odd_en_cy2     = 1'b1;
	if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en0            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
	  odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en2            = 1'b1;
	end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end                
      
      4'b1001: begin
	odd_8bit     = 1'b1;
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en1            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en2            = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end

      4'b1000: begin
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1111 };
          odd_rd_en0            = 1'b1;
          odd_rd_en1            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en2            = 1'b1;
	  odd_8bit          = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end

      4'b0111: begin
	odd_8bit     = 1'b1;
        odd_en_cy1        = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr  =  int_g_addr_out[21:2];
      	  odd_val_plane_sel =  {4'b1010, 4'b0};
          odd_rd_en3            = 1'b1;
	end
      end
      
      4'b0110: begin
	odd_8bit     = 1'b1;
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en0            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end

      4'b0101: begin
	odd_8bit     = 1'b1;
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en1            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end

      4'b0100: begin
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1111};
          odd_rd_en0            = 1'b1;
          odd_rd_en1            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en3            = 1'b1;
	  odd_8bit     = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end

      4'b0011: begin
        odd_en_cy1        = 1'b1;
	if(odd_32) begin
	  odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1111};
          odd_rd_en2            = 1'b1;
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr  =  int_g_addr_out[21:2];
	  odd_val_plane_sel = {4'b1111, 4'b0};
          odd_rd_en2            = 1'b1;
          odd_rd_en3            = 1'b1;
	end
      end
      
      4'b0010: begin
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b0101};
          odd_rd_en0            = 1'b1;
	  odd_8bit     = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1111};
          odd_rd_en2            = 1'b1;
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0001: begin
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1010};
          odd_rd_en1            = 1'b1;
	  odd_8bit     = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1111};
          odd_rd_en2            = 1'b1;
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end
      
      4'b0000: begin
        odd_en_cy2        = 1'b1;
        if(odd_32 & cy2_gnt & cpucy_1_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b00};
          odd_val_plane_sel = {4'b0, 4'b1111};
          odd_rd_en0            = 1'b1;
          odd_rd_en1            = 1'b1;
        end else if (odd_32 & cy2_gnt & cpucy_2_2) begin
          odd_val_mem_addr  = {int_g_addr_out[19:2], 2'b10};
          odd_val_plane_sel = {4'b0, 4'b1111};
          odd_rd_en2            = 1'b1;
          odd_rd_en3            = 1'b1;
        end else begin
          odd_val_mem_addr = 20'b0;
          odd_val_plane_sel[7:0] = 8'b0;
        end
      end
    endcase
    
  end
  
  always @* begin
    if (chain_32) begin
      ch_en_cy1          = 1'b1;
      chain_val_mem_addr = {int_g_addr_out[19:2], 2'b00};
      chain_val_plane_sel = {4'b0, ~h_byte_en_n[3:0]};
    end else begin
      ch_en_cy1   = 1'b0;
      chain_val_mem_addr = 20'b0;
      chain_val_plane_sel = 8'b0;
    end
  end
  
  always @* begin
    if   (m_planar & svmem_sel_hit) begin
      en_cy1 = pla_en_cy1;
      en_cy2 = pla_en_cy2;
      en_cy3 = pla_en_cy3;
      en_cy4 = pla_en_cy4;
    end else if (m_odd_even & svmem_sel_hit) begin
      en_cy1 = odd_en_cy1;
      en_cy2 = odd_en_cy2;
      en_cy3 = 1'b0;
      en_cy4 = 1'b0;
    end else if (m_chain4 & svmem_sel_hit) begin
      en_cy1 = ch_en_cy1;
      en_cy2 = 1'b0;
      en_cy3 = 1'b0;
      en_cy4 = 1'b0;
    end else begin
      en_cy1 = 1'b0;
      en_cy2 = 1'b0;
      en_cy3 = 1'b0;
      en_cy4 = 1'b0;
    end
  end
  
  always @* begin
    if (m_planar) begin
      rd_en0 = pla_rd_en0;
      rd_en1 = pla_rd_en1;
      rd_en2 = pla_rd_en2;
      rd_en3 = pla_rd_en3;
    end else if (m_odd_even) begin
      rd_en0 = odd_rd_en0;
      rd_en1 = odd_rd_en1;
      rd_en2 = odd_rd_en2;
      rd_en3 = odd_rd_en3;
    end else begin
      rd_en0 = 1'b0;
      rd_en1 = 1'b0;
      rd_en2 = 1'b0;
      rd_en3 = 1'b0;
    end
  end
  
  
  always @* begin
    if (m_planar)        int_val_mem_addr = pla_val_mem_addr;
    else if (m_odd_even) int_val_mem_addr = odd_val_mem_addr;
    else if (m_chain4)   int_val_mem_addr = chain_val_mem_addr;
    else                 int_val_mem_addr = 20'b0;
  end

  always @* begin
    if (m_planar)        int_val_plane_sel = pla_val_plane_sel;
    else if (m_odd_even) int_val_plane_sel = odd_val_plane_sel;
    else if (m_chain4)   int_val_plane_sel = chain_val_plane_sel;
    else                 int_val_plane_sel = 8'b0;
  end

  assign fin_plane_sel[7:4] = {int_val_plane_sel[7:4] & m_sr02_b[3:0]};
  assign fin_plane_sel[3:0] = {int_val_plane_sel[3:0] & m_sr02_b[3:0]};
  
  assign int_mwr_addr[19:0] = {int_val_mem_addr[19:0]} ;
  
  //
  //  CPU read Address generation
  //
  assign odd_32 = m_odd_even;

  // Fixme ??? 
  assign chain_32 = m_chain4;
  assign chain_32new = m_chain4;

  assign  man_rdwr_addr =  int_mwr_addr;

  // valid memory read or write address  
  assign  val_mrdwr_addr = fin_scr_addr;
  
  //
  //  Host Data Shifting for writing to the memory
  //
  assign  cha_ext = m_chain4;
  
  always @(rd_en0 or rd_en1 or rd_en2 or rd_en3 or cha_ext or 
           h_mem_dbus_out) begin
    case ({rd_en3, rd_en2, rd_en1, rd_en0, cha_ext})
      5'b0001_0: sft_h_mem_dbus = {4{h_mem_dbus_out[7:0]}};
      5'b0010_0: sft_h_mem_dbus = {4{h_mem_dbus_out[15:8]}};
      5'b0100_0: sft_h_mem_dbus = {4{h_mem_dbus_out[23:16]}};
      5'b1000_0: sft_h_mem_dbus = {4{h_mem_dbus_out[31:24]}};
      5'b0011_0: sft_h_mem_dbus = {2{h_mem_dbus_out[15:0]}};
      5'b1100_0: sft_h_mem_dbus = {2{h_mem_dbus_out[31:16]}};
      default:   sft_h_mem_dbus = {h_mem_dbus_out[31:0]};
    endcase // casex({rd_en3, rd_en2, rd_en1, rd_en0, cha_ext})
  end // always @ (rd_en0 or rd_en1 or rd_en2 or rd_en3 or cha_ext or...
  
  assign sftw_h_mem_dbus  = sft_h_mem_dbus;	       

endmodule





