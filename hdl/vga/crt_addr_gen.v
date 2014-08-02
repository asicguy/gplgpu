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
//  Title       :  CRT Address Generator
//  File        :  crt_addr_gen.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module generates the address requried
//   to access the memory in the crt cycle mode.
//   The value from the screen start address register
//   is loaded into this module and also the crt offset
//   value is also loaded in to this module.
//   Before puting the generated address onto the m-t-mem-addr
//   bus it also goes through some address maping for
//   various modes, ie for address-wrap, word-mode and Dword-
//   mode.
//   
//   This module also generates the font address which is 
//   requried to read the font data from the memory.  
//   The font address is generated using scan-line ctr value,
//   character map select register (sr3(0:5))value and 
//   crt_fifo_data [7:0].
//   
//   This module also generates the cursor location value
//   by comparing the crt_addr and cursor-location-register
//   value.      
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

module crt_addr_gen  
  (
   input 	      en_cpurd_addr,
   input 	      enwr_cpu_ad_da_pl,
   input 	      m_sr04_b1,
   input 	      tx_cnt_inc,
   input 	      gra_cnt_inc,    
   input 	      hreset_n,
   input 	      c_split_screen_pulse,
   input 	      c_vde,
   input 	      c_pre_vde,
   input 	      c_row_end,           // End of row of text
   input 	      mem_clk,
   input 	      t_crt_clk,
   input 	      text_mode,
   input 	      c_cr14_b6,
   input 	      c_cr17_b0,
   input 	      c_cr17_b1,
   input 	      c_cr17_b5,
   input 	      c_cr17_b6,
   input [7:0] 	      reg_cr0c_qout,  // screen start address high
   input [7:0] 	      reg_cr0d_qout,  // screen start address low
   input [7:0] 	      reg_cr0e_qout,  // Text cursor location address high
   input [7:0] 	      reg_cr0f_qout,  // Text cursor location  address low
   input [7:0] 	      reg_cr13_qout,  // crt offset register
   input [7:0] 	      reg_sr3_qout,  // character map select register
   input [4:0] 	      c_slc_op,
   input [8:0] 	      ff_asic_out,
   input 	      enrd_font_addr,
   input 	      enrd_tx_addr,
   input 	      enrd_gra_addr,
   input              c_crt_line_end,
   input              crt_ff_write,   // signal writing cursor attribute.
   
   output reg [19:0]  fin_crt_addr,
   output [19:0]      font_addr,       
   output reg         sync_pre_vde,
   output reg	      sync_c_crt_line_end,
   output             cursorx           // Cursor display indicator
   );
  
  //
  //        Define Variables
  //
  reg [19:0] 	      int_crt_addr;
  reg [10:0] 	      crt_offset;
  reg [19:0] 	      crt_addr;
  reg [16:0] 	      cur_addr;
  reg [19:0] 	      row_beg_saddr;
  reg 		      c_pre_vde_del, c_row_end_del;
  reg 		      c_split_del;
  reg 		      del_vde, del_crt;
  
  wire 		      new_int_crt_addr14;
  wire 		      new_int_crt_addr13;
  wire [19:0] 	      sr_stadd_qout;
  wire [19:0] 	      int1_cdg_out;
  wire [19:0] 	      def_crt_addr;
  wire [19:0] 	      db_word_crt_addr;
  wire [19:0] 	      word_crt_addr;
  wire [19:0] 	      wrap_crt_addr15;
  wire [19:0] 	      wrap_crt_addr13;
  wire [19:0] 	      map_crt_addr;
  wire 		      scan_b0;
  wire 		      scan_b1;
  wire 		      offset_sel;
  wire 		      def_mode;
  wire 		      regcr17_b0;
  wire [2:0] 	      pri_map;
  wire [2:0] 	      second_map;
  wire [2:0] 	      seq_font_bit;
  wire 		      add_wrap;
  wire 		      add_wrap_15;
  wire 		      add_wrap_13;
  wire 		      word_mode;
  wire 		      db_word_mode;
  wire [15:0] 	      cur_loc_value;
  wire [15:0] 	      crt_addr_loc;
  wire 		      crt_addr_inc;
  wire [10:0] 	      ext_int_offset_out;
  wire [19:0] 	      caddr_wrap_256;
  wire [19:0] 	      caddr_wrap_64;
  wire [19:0] 	      i_crt_addr;
  wire 		      equal_64k;
  
  wire 		      add_en;
  wire 		      add_en1;
  wire 		      add_en2;
  
  wire [2:0] 	      int_seq_font_bit;   
  wire [19:0] 	      saddr_offset;

  assign 	      crt_addr_inc = tx_cnt_inc | gra_cnt_inc; 
  
  assign 	      word_mode = ~c_cr17_b6;
  assign 	      add_wrap  =  c_cr17_b5;
  assign 	      add_wrap_15 = c_cr17_b5 & word_mode;  // wrap at 64k.
  assign 	      add_wrap_13 = ~c_cr17_b5 & word_mode; // wrap at 16k.
  assign 	      db_word_mode = c_cr14_b6;
  assign 	      sr_stadd_qout = {reg_cr0c_qout[7:0], reg_cr0d_qout[7:0]};
   
  always @ (c_cr14_b6 or c_cr17_b6 or c_cr17_b5 or reg_cr13_qout)
    casex ({c_cr14_b6, c_cr17_b6, c_cr17_b5})
      // Double
      3'b1xx:   crt_offset = {reg_cr13_qout[7:0], 3'b0};
      // Word Mode
      3'b001:   crt_offset = {1'b0, reg_cr13_qout[7:0], 2'b0};
      3'b000:   crt_offset = {1'b0, reg_cr13_qout[7:0], 2'b0};
      // Default Mode
      3'b01x:   crt_offset = {2'b0, reg_cr13_qout[7:0], 1'b0};
      default: crt_offset = {2'b0, reg_cr13_qout[7:0], 1'b0};
    endcase // casex({c_cr14_b6, c_cr17_b6, c_cr14_b6, c_cr17_b5})

  always @(posedge t_crt_clk or negedge hreset_n)
    if (!hreset_n) begin
      c_pre_vde_del  <= 1'b0;
      c_row_end_del  <= 1'b0;
      c_split_del    <= 1'b0;
    end else begin
      c_pre_vde_del  <= c_pre_vde;
      c_row_end_del  <= c_row_end;
      c_split_del    <= c_split_screen_pulse;
    end

  // The actual start position for each row is generated here.
  // On the first cycle of c_pre_vde, we will register the start address
  // Otherwise upon the row end or upon a split screen pulse, we will generate
  // the new address
  always @(posedge t_crt_clk or negedge hreset_n)
    if (!hreset_n) row_beg_saddr <= 20'b0;
    else if (c_pre_vde && ~c_pre_vde_del)
      // This is the load condition at the start of each display page
      // The c_pre_vde comes one Hsync prior to the start of an actual display
      casex ({db_word_mode, word_mode})
	2'b1x: row_beg_saddr <= {sr_stadd_qout[15:0], 2'b0};
	2'b00: row_beg_saddr <= {1'b0, sr_stadd_qout[16:0]};
	2'b01: row_beg_saddr <= {sr_stadd_qout[16:0], 1'b0};
      endcase // casex({db_word_mode, word_mode})
    else if (~c_split_screen_pulse && c_split_del)
      // When we get a split screen pulse, we reset the start address to 0,
      // The starting location of the second image always.
      row_beg_saddr <= 20'b0;
    else if (c_row_end && ~c_row_end_del)
      // At the end of each row, we will add the crt offset onto the current
      // page.
      row_beg_saddr <= row_beg_saddr + crt_offset; 

  // Synchronize the crt_line_end and the pre_vde and we'll feed them out from
  // here
  always @(posedge mem_clk or negedge hreset_n)
    if (~hreset_n) begin
      del_vde             <= 1'b0;
      del_crt             <= 1'b0;
      sync_pre_vde        <= 1'b0;
      sync_c_crt_line_end <= 1'b0;
    end else begin
      del_vde             <= c_pre_vde;
      del_crt             <= c_crt_line_end;
      sync_pre_vde        <= del_vde;
      sync_c_crt_line_end <= del_crt;
    end
    
  always @(posedge mem_clk or negedge hreset_n) begin
    if (~hreset_n)     
      crt_addr <= 20'b0;
    else if (sync_c_crt_line_end | sync_pre_vde) 
      crt_addr <= row_beg_saddr;
    else if (crt_addr_inc)
      case ({~c_cr17_b6, c_cr14_b6})
	2'b00:   crt_addr <= crt_addr + 1;
	2'b10:   crt_addr <= crt_addr + 2;
	default: crt_addr <= crt_addr + 4;
      endcase // case({~c_cr17_b6, c_cr14_b6})
  end
   
  //  
  //
  // 	  Begining of address mapping logic 
  //
  //
  assign scan_b0 = c_slc_op[0];
  assign scan_b1 = c_slc_op[1];  
    
  assign def_crt_addr = {crt_addr[19:16], crt_addr[15:0]};
  assign db_word_crt_addr = {crt_addr[19:16], crt_addr[15:2], crt_addr[15:14]};
  assign word_crt_addr = {crt_addr[19:16], crt_addr[15:1], crt_addr[15]};    
  assign wrap_crt_addr15 = {crt_addr[19:16], crt_addr[15:1], crt_addr[15]};
  assign wrap_crt_addr13 = {crt_addr[19:14], crt_addr[13:1], crt_addr[13]};
  assign map_crt_addr = {int_crt_addr[19:15], new_int_crt_addr14, new_int_crt_addr13, int_crt_addr[12:0]};
    
  //
  //  Generating the final crt_addr.
  //  Forcing the bits 19-16 to zero when reg_er30_qout[0] = 0.
  //
  always @(m_sr04_b1 or map_crt_addr or caddr_wrap_256 or
	   caddr_wrap_64) 
    case (m_sr04_b1)
      1'b0: fin_crt_addr[19:0] = caddr_wrap_64[19:0];
      1'b1: fin_crt_addr[19:0] = caddr_wrap_256[19:0];
    endcase // casex({reg_er30_qout[0], m_sr04_b1})
    
  assign   equal_64k = ~m_sr04_b1;
  
  assign   caddr_wrap_64[19:0]   = {6'b0, map_crt_addr[13:0]};
  assign   caddr_wrap_256[19:0]   = {4'b0, map_crt_addr[15:0]};

  assign   def_mode = ~(db_word_mode | word_mode | add_wrap_15 | add_wrap_13);
    
  always @ (c_cr14_b6 or c_cr17_b6 or c_cr17_b5 or db_word_crt_addr or
	    wrap_crt_addr15 or wrap_crt_addr13 or def_crt_addr)
    casex ({c_cr14_b6, c_cr17_b6, c_cr17_b5})
      // Double
      3'b1xx:   int_crt_addr = db_word_crt_addr;
      // Word Mode
      3'b001:   int_crt_addr = wrap_crt_addr15;
      3'b000:   int_crt_addr = wrap_crt_addr13;
      // Default Mode
      3'b01x:   int_crt_addr = def_crt_addr;
      default: int_crt_addr = def_crt_addr;
    endcase // casex({c_cr14_b6, c_cr17_b6, c_cr14_b6, c_cr17_b5})

  assign new_int_crt_addr14 = c_cr17_b1 ? int_crt_addr[14] : scan_b1;
      
  assign new_int_crt_addr13 = c_cr17_b0 ? int_crt_addr[13] : scan_b0;
      
  //
  //  	  Generation of font-addr
  //
  
  assign pri_map[2:0] = {reg_sr3_qout[5], reg_sr3_qout[3], reg_sr3_qout[2]};
  
  assign second_map[2:0] = {reg_sr3_qout[4], reg_sr3_qout[1], reg_sr3_qout[0]};
  
  assign int_seq_font_bit[2:0] = ~ff_asic_out[8] ? second_map[2:0] : 
	 pri_map[2:0];
  
  assign seq_font_bit[2:0] = {int_seq_font_bit[1], int_seq_font_bit[0], 
			      int_seq_font_bit[2]};
      
  assign font_addr = {4'b0, seq_font_bit[2:0], 
		      ff_asic_out[7:0], c_slc_op[4:0]};
      
  // We generate the cursor position to the attribute module here.
  // We maintain a character count the same as above, however, it increments
  // on every t_data_ready_n. This is the signal that generates the
  // crt_ff_write that loads the cursorx into the fifo.
  // The only issue with this is that the text state machine reads two times
  // for each character position. The first is a char, attribute read, the
  // second is a font read. Bursts are always in 8, thus the actual address
  // for comparison will be {cur_addr[16:4], cur_addr[2:0]}
  // bit 3 is simply which half cycle we are in.
  always @(posedge mem_clk or negedge hreset_n) begin
    if (~hreset_n)     
      cur_addr <= 17'b0;
    else if (sync_c_crt_line_end | sync_pre_vde) 
      cur_addr <= row_beg_saddr;
    else if (crt_ff_write)
      cur_addr <= cur_addr + 1;
  end
   
  assign cur_loc_value = {reg_cr0e_qout[7:0], reg_cr0f_qout[7:0]};
  
  assign cursorx = (cur_loc_value == {cur_addr[16:4], cur_addr[2:0]});

endmodule       
       
         
	 
	 
	 
	 
      





















