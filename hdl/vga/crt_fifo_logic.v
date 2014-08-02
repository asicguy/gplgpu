//////////////////////////////////////////////////////////////////////////////
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
//  Title       :  CRT Fifo
//  File        :  crt_fifo_logic.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This module consists of the crt fifo of size 40 wide
//   and 32 deep. The data to the fifo is obtained from
//   memory on m_t_mem_data[63:0] which is packed to 
//   m_t_mem_data[31:0] to write into the fifo.
//   
//   The output of the fifo which is m_att_data[39:0] 
//   is sent to the attribute module.
//   The att_text_out [4:0] from the att_text_blk module
//   is also written into the crt-fifo block.
//   
//   The crtfifo writes and reads are also generated here
//   in this module.
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
module crt_fifo_logic
  (
   input          sync_c_crt_line_end,
   input          hreset_n,
   input          mem_clk,
   input          t_crt_clk,
   input          c_dclk_en,
   input          crt_ff_write,
   input          c_crt_line_end,
   input          c_crt_ff_read,
   input          dum_ff_read,
   input          enrd_font_addr, 
   input          text_mode,
   input          crt_ff_empty,
   input          crt_ff_rda,
   input          crt_ff_rdb,
   input          gr_ff_wra,
   input          gr_ff_wrb,
   input          tx_ff_wra_high,
   input          tx_ff_wra_low,
   input          tx_ff_wrb_high,
   input          tx_ff_wrb_low,
   input [4:0]    att_text_out,
   input          extend_font_addr,
   input [31:0]   m_t_mem_data_in,
   
   output         dum_ff_rd_cnt0,
   output         crt_frd0,
   output         crt_frd15,
   output         crt_frd16,
   output         crt_frd31,
   output         crt_fwr0,
   output         crt_fwr15,
   output         crt_fwr16,
   output         crt_fwr31,
   output         crt_fwr0_low,
   output         crt_fwr15_high,
   output         crt_fwr15_low,
   output         crt_fwr16_low,
   output         crt_fwr31_high,
   output         crt_fwr31_low,
   output [36:0]  m_att_data,
   output [8:0]   ff_asic_out,			     
   output         crt_fwr7_low,
   output         crt_fwr7_high,
   output         crt_fwr23_low,
   output         crt_fwr23_high,
   output         crt_frd1,
   output         crt_frd17
   );
  
  //
  // 	    Define Variables
  //
  reg [4:0] 	  wr_cnt_value;
  reg [4:0] 	  rd_cnt_value; 
  reg [4:0] 	  rd_cnt_value_a; 
  reg [4:0] 	  dum_frd_value;
  reg [4:0] 	  dum_frd_value_a;
  reg [8:0] 	  store_asi_mc[31:0];
  reg [8:0] 	  store_asi_crt[31:0];
  reg [12:0] 	  store_att[31:0];
  reg [15:0] 	  store_font[31:0];
  
  wire [39:0] 	  int_m_att_data;
  wire [31:0] 	  wr_cnt_index_dec;
  wire 		  ff_wra_low;
  wire 		  ff_wra_high;
  wire 		  ff_wrb_low;
  wire 		  ff_wrb_high;
  wire [15:0] 	  wra_low;
  wire [15:0] 	  wra_high;
  wire [31:16] 	  wrb_low;
  wire [31:16] 	  wrb_high;
  wire [31:0] 	  rd_cnt_index_dec;
  wire [31:0] 	  dum_frd_index_dec;
  wire [31:0] 	  crt_fifo_wr_low;
  wire [31:0] 	  crt_fifo_wr_high;   
  wire [31:0] 	  crt_fifo_rd;
  wire [23:16] 	  ff_data_in;
  wire [31:0] 	  ff_rda;
  wire 		  dum_index_7;
  wire 		  dum_index_15;
  wire 		  dum_index_23;
  wire 		  dum_index_31;
  wire 		  en_dum_fifo;
  wire 		  crt_ff_rdab;
  
  wire [8:0] 	  att_asic_data;

  wire [12:0] 	  ff_att_in;
  wire [15:0] 	  ff_att_out;
  wire [15:0] 	  ff_font_out;
  wire [5:0] 	  dumff_rd;
  wire [31:0] 	  asic_ff_read;   
  
  wire 		  crt_ff_strobe;  
  wire [6:0]	  nc7_0;
  
  //        
  //  	  Begining of Generating crt fifo logic
  //  	  Expecting an 5-bit counter with write enable.
  //  	  When write enable is set to one, a value of 00000 is loaded into 
  //      the register.
  //
  always @(posedge mem_clk  or negedge hreset_n) begin 
    if (!hreset_n)                wr_cnt_value <= 5'b0; 
    else if (sync_c_crt_line_end) wr_cnt_value <= 5'b0;
    else if (crt_ff_write)        wr_cnt_value <= wr_cnt_value + 1;
  end
  
  assign wr_cnt_index_dec = 1'b1 <<  wr_cnt_value;
  
  assign ff_wra_low 	= gr_ff_wra | tx_ff_wra_low;
  assign ff_wra_high 	= gr_ff_wra | tx_ff_wra_high;
  assign ff_wrb_low 	= gr_ff_wrb | tx_ff_wrb_low;
  assign ff_wrb_high    = gr_ff_wrb | tx_ff_wrb_high;
  
  //
  // 	 Decoding the write strobes for crt write fifo
  //
  assign crt_ff_strobe = crt_ff_write;

  assign wra_low[7:0] = wr_cnt_index_dec[7:0] & {8{ff_wra_low & crt_ff_strobe}};

  assign wra_low[15:8] = (wr_cnt_index_dec[15:8] | wr_cnt_index_dec[23:16]) & {8{ff_wra_low & crt_ff_strobe}};

  assign wrb_low[23:16] = (wr_cnt_index_dec[7:0] | wr_cnt_index_dec[23:16] &{8{~text_mode}}) & {8{ff_wrb_low & crt_ff_strobe}};

  assign wrb_low[31:24] = (wr_cnt_index_dec[23:16] & {8{text_mode}} | wr_cnt_index_dec[31:24]) & {8{ff_wrb_low & crt_ff_strobe}};
  
  assign wra_high[7:0] = (wr_cnt_index_dec[15:8] & {8{text_mode}} | wr_cnt_index_dec[7:0]) & {8{ff_wra_high & crt_ff_strobe}};

  assign wra_high[15:8] = (wr_cnt_index_dec[31:24] | wr_cnt_index_dec[15:8] &{8{~text_mode}})& {8{ff_wra_high & crt_ff_strobe}};

  assign wrb_high[23:16] = (wr_cnt_index_dec[23:16] | wr_cnt_index_dec[15:8]) & {8{ff_wrb_high & crt_ff_strobe}};

  assign wrb_high[31:24] = (wr_cnt_index_dec[31:24] & {8{ff_wrb_high & crt_ff_strobe}});
         
//
// 	 Generation of write strobes for read of crt fifo
//
always @*
	begin
		if (c_dclk_en & c_crt_line_end) rd_cnt_value_a = 5'b00000;
		else if (c_dclk_en & c_crt_ff_read) rd_cnt_value_a = rd_cnt_value + 1;
		else rd_cnt_value_a = rd_cnt_value;
	end
always @(posedge t_crt_clk or negedge hreset_n)
	begin
		if (!hreset_n) rd_cnt_value <= 5'b0;
		else rd_cnt_value <= rd_cnt_value_a;
	end
  
assign rd_cnt_index_dec = 1'b1 <<  rd_cnt_value;	 
  
assign crt_ff_rdab = crt_ff_rda | crt_ff_rdb;   

assign ff_rda[0]    = (rd_cnt_index_dec[0] );
assign ff_rda[30:1] = {30{crt_ff_rdab}} & rd_cnt_index_dec[30:1];
assign ff_rda[31]   = (rd_cnt_index_dec[31]);
  
//
// 	 Assigning different names to tap them as outputs.
//
  assign crt_frd0 = ff_rda[0] & c_crt_ff_read;
  assign crt_frd1 = ff_rda[1];
  assign crt_frd16 = ff_rda[16];
  assign crt_frd15 = ff_rda[15];
  assign crt_frd17 = ff_rda[17];
  assign crt_frd31 = ff_rda[31];
  assign crt_fwr0 =  wra_low[0] & wra_high[0];
  assign crt_fwr15 =  wra_low[15] & wra_high[15];
  assign crt_fwr16 =  wrb_low[16] & wrb_high[16];
  assign crt_fwr31 =  wrb_low[31] & wrb_high[31];
  assign crt_fwr0_low = wra_low[0];
  assign crt_fwr15_high = wra_high[15];
  assign crt_fwr15_low = wra_low[15];
  assign crt_fwr16_low = wrb_low[16];
  assign crt_fwr31_high = wrb_high[31];
  assign crt_fwr31_low = wrb_low[31];
  assign crt_fwr7_low  = wra_low[7];
  assign crt_fwr7_high = wra_high[7];
  assign crt_fwr23_low = wrb_low[23];
  assign crt_fwr23_high = wrb_high[23];
  //
  //  	 Generation of font fifo reads 
  //
  always @* 
	begin
		if (sync_c_crt_line_end) dum_frd_value_a = 5'b0;
    		else if (dum_ff_read)    dum_frd_value_a = dum_frd_value + 1;
    		else dum_frd_value_a = dum_frd_value;
  	end
  always @(posedge mem_clk or negedge hreset_n)
	begin
    		if (!hreset_n)  dum_frd_value <= 5'b0;
    		else 		dum_frd_value <= dum_frd_value_a;
  end
  
  
  assign en_dum_fifo = (extend_font_addr | dum_ff_read);

  assign dum_frd_index_dec = (1'b1 <<  dum_frd_value);
  assign dum_index_7 = dum_frd_index_dec[7];
  assign dum_index_15 = dum_frd_index_dec[15];
  assign dum_index_23 = dum_frd_index_dec[23];
  assign dum_index_31 = dum_frd_index_dec[31];
  //
  // By adding with extend_font_addr which is active for state 4, state5 and 
  // state 5x
  //
  assign dum_ff_rd_cnt0 = ((dum_index_7 | dum_index_15 | dum_index_23 | dum_index_31) & extend_font_addr);
  
  assign crt_fifo_wr_low = {wrb_low[31:16], wra_low[15:0]};
  
  assign crt_fifo_wr_high = {wrb_high[31:16], wra_high[15:0]};
  
  assign crt_fifo_rd = {ff_rda[31:0]}; 
  
  //
  //  Instantiating an 9x32 fifo to store ascii data [7:0] and the 
  //  mem_data[11] to be used for font generation.
  //  This fifo is read by the dum_read storbes generated from the sm_txt_sm. 
  //  The writes to this fifo are the crt_fifo_write_low in text mode and in
  //  graphic mode normal write.
  //


wire [4:0] adr_trans_asi_att = {ff_wrb_low, 
				(ff_wra_low & (wr_cnt_value[4] | wr_cnt_value[3])) |
                                (ff_wrb_low & wr_cnt_value[3]) | 
                                (ff_wrb_low & text_mode & wr_cnt_value[4]), 
				wr_cnt_value[2:0]};

wire we_asi_att =  crt_ff_write & 
		 ((ff_wra_low & ~(wr_cnt_value[4] & wr_cnt_value[3])) |
		  (ff_wrb_low & ~(~wr_cnt_value[4] & wr_cnt_value[3])));

// always @(posedge mem_clk) if (we_asi_att)
//   	store_asi_mc[adr_trans_asi_att] <= {m_t_mem_data_in[11], m_t_mem_data_in[7:0]};
// always @(posedge mem_clk) ff_asic_out <= store_asi_mc[dum_frd_value_a];
ram_9x32_2p u_asi_ram
        (
        .clock          (mem_clk),
        .wren           (we_asi_att),
        .wraddress      (adr_trans_asi_att),
        .data           ({m_t_mem_data_in[11], m_t_mem_data_in[7:0]}),
        .rdaddress      (dum_frd_value_a),
        .q              (ff_asic_out)
        );

// always @(posedge mem_clk) if (we_asi_att)
//   	store_asi_crt[adr_trans_asi_att] <= {m_t_mem_data_in[11], m_t_mem_data_in[7:0]};
// always @(posedge t_crt_clk)  att_asic_data <= store_asi_crt[rd_cnt_value_a];

ram_32x32_dp u_asi_att_ram
        (
        .wrclock        (mem_clk),
        .wren           (we_asi_att),
        .wraddress      (adr_trans_asi_att),
        .data           ({10'h0, att_text_out[4:0], m_t_mem_data_in[15:8], m_t_mem_data_in[11], m_t_mem_data_in[7:0]}),
        .rdclock        (t_crt_clk),
        .rdaddress      (rd_cnt_value_a),
        .q              ({nc7_0, ff_att_out, att_asic_data})
        );
  //
  //	If the font fifo is active then en_dum_fifo = 1 and ff_asic_out is
  //  the att_asic_data which is used to generate font address and if
  //  the en_dum_fifo = 0, then we force zero's to the att_asic_data
  //  which is also read on the m_att_data.
  //
  //  Here in part of text mode when en_dum_fifo is set to one, then
  //  we force zero's on to the att_asic_data bus. Other wise the data
  //  from the fifo sent to the m_att_data.
  //    
  //GateC    assign att_asic_data = (~en_dum_fifo) ? ff_asic_out[8:0] : 8'b0;

  // assign att_asic_data =  ff_asic_out[8:0];
  
  //
  //  Instantiating an 16x32 fifo to store attribute data [15:8], 
  //  att_text_out [4:0] and force 3'b0 for future
  //  use.
  //  This fifo is read by the crt_fifo_read[31:0] 
  //  The writes to this fifo are the crt_fifo_write_low in text mode and in
  //  graphic mode normal write.
  //
  
// always @(posedge mem_clk) if (we_asi_att)
//  	store_att[adr_trans_asi_att] <= {att_text_out[4:0], m_t_mem_data_in[15:8]};
// always @(posedge t_crt_clk)  ff_att_out <= {3'b0, store_att[rd_cnt_value_a]};

  //
  //  Instantiating an 16x32 fifo to store font data [23:16],  and [31:24]
  //  This fifo is read by the crt_fifo_read[31:0].
  //  The address for the memory is generated by the font address generator.
  //  The writes to this fifo are the crt_fifo_write_high in text mode and in graphic mode normal write.
  //

wire [4:0] adr_trans_font = {ff_wrb_high, 
			    (ff_wra_high & wr_cnt_value[4] & wr_cnt_value[3]) |
			    (ff_wra_high & ~text_mode & ~wr_cnt_value[4] & wr_cnt_value[3]) |
                            (ff_wrb_high & wr_cnt_value[4] & wr_cnt_value[3]), wr_cnt_value[2:0]};

wire we_font =  crt_ff_write & 
		 ((ff_wra_high & ~(wr_cnt_value[4] & ~wr_cnt_value[3])) |
		  (ff_wrb_high & (wr_cnt_value[4] | wr_cnt_value[3])));

ram_16x32_dp u_font_ram
        (
        .wrclock        (mem_clk),
        .wren           (we_font),
        .wraddress      (adr_trans_font),
        .data           (m_t_mem_data_in[31:16]),
        .rdclock        (t_crt_clk),
        .rdaddress      (rd_cnt_value_a),
        .q              (ff_font_out)
        );

  //
  // m_att_data[39:0] is the concatation of the data coming out of the above 
  // three crt fifos.
  //
  assign int_m_att_data[39:0] = {ff_att_out[15:8], ff_font_out[15:0], ff_att_out[7:0], att_asic_data[7:0]};
  
  assign m_att_data[36:0] = {int_m_att_data[36:0]};
  
endmodule       
