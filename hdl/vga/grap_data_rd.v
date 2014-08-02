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
//  Title       :  Graphics Data Read
//  File        :  grap_data_rd.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   In this module the graphic module reads the data
//   from the memory module ie g_graph_data[31:0] in
//   32bit mode. This data is latched into the graphic
//   module with m_g_ready_n signal. In graphic_read0
//   mode before shifting the data to the host module,
//   it is processed/adjusted  depending on the various 
//   graphic modes and host data width.
//   In graphic_read1 mode the data is passed through 
//   the color cmpare module and the upper 24 bits are
//   forced to low. Only the lower byte h_mem_dbus[7:0]
//   is sent to the host.
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
module grap_data_rd 
  (
   input              m2s1_q,
   input 	      m2s2_q,
   input 	      cycle2,
   input [3:0] 	      h_byte_en_n,
   input 	      cur_cpurd_done,   
   input 	      m_memrd_ready_n,   
   input 	      odd_8bit,
   input 	      h_hrd_hwr_n,
   input 	      h_mem_io_n,
   input 	      g_mem_ready_n,
   input 	      hreset_n,
   input 	      mem_clk,
   input 	      m_sr04_b3,        // chain4
   input 	      m_odd_even,        // odd/even
   input [1:0] 	      val_mrdwr_addr,
   input 	      gr4_b1,
   input 	      gr4_b0,
   input [3:0] 	      reg_gr2_qout,
   input [3:0] 	      reg_gr7_qout,
   input 	      read_mode_1,
   input 	      read_mode_0,
   input 	      m_ready_n,
   
   input [31:0]       g_graph_data_in,
   
   output reg [31:0]  cpu_lat_data,  
   output reg [31:0]  h2mem_bout,    
   output reg [7:0]   g_int_crt22_data, 
   output 	      rd_en_0,
   output 	      rd_en_1
   );
  
  //
  // 	    Define Variables
  //
   
  reg [7:0] 	 int_cpu_lat_data;
  reg [15:0] 	 int_odd16_lat_data; 
  reg 		 gra_ready_dly;

  wire [7:0] 	 clrcmpr_low;
  wire 		 graphic_ready;
  wire [31:0] 	 int_clrcmpr; 
  wire [7:0] 	 clrcmpr;
  wire 		 rd_mux1;
  wire 		 rd_mux0;
  wire 		 rd_sel_1;
  wire 		 rd_sel_0;
  wire 		 rd_pl0;
  wire 		 rd_pl1;
  wire 		 rd_pl2;
  wire 		 rd_pl3;
  wire 		 rd_odd8_0;
  wire 		 rd_odd8_1;
  wire 		 rd_odd8_2;
  wire 		 rd_odd8_3;
  wire 		 rd_chain8_0;
  wire 		 rd_chain8_1;
  wire 		 rd_chain8_2;
  wire 		 rd_chain8_3;
  wire 		 rd_8plodch0;
  wire 		 rd_8plodch1;
  wire 		 rd_8plodch2;
  wire 		 rd_8plodch3;
  wire 		 planar;
  wire 		 data8bit_en;
  wire [31:0] 	 data_8bit;
  wire 		 rd_odd16_0;
  wire 		 rd_odd16_1;
  wire 		 rd_chain16_0;
  wire 		 rd_chain16_1;
  wire 		 rd_16odch0;
  wire 		 rd_16odch1;
  wire [31:0] 	 data_16bit;
  wire 		 data16bit_en;
  wire 		 chain_data32_en;
  wire 		 mem_read;
  wire 		 dumrdy_1;
  
  wire 		 gra_ready_dly1;
  wire 		 dumrdy_2;
  wire 		 int_en1;
  wire 		 dly_en1;
  wire 		 dumdly_1;
  wire 		 enbyte0;
  wire 		 enbyte1;
  wire 		 odd_cy2_0;
  wire 		 odd_cy2_1;

  assign rd_en_0 = mem_read & gra_ready_dly & read_mode_0;
  assign rd_en_1 = mem_read &  gra_ready_dly & read_mode_1;
  
  assign 	 mem_read = h_hrd_hwr_n & h_mem_io_n;
  
  assign 	 graphic_ready = cur_cpurd_done;

  always @(posedge mem_clk or negedge hreset_n)
    if (!hreset_n) gra_ready_dly <= 1'b0;
    else           gra_ready_dly <= graphic_ready;
  
  assign 	 enbyte0 = gra_ready_dly & m2s1_q;
  assign 	 enbyte1 = gra_ready_dly & m2s2_q;


  assign 	 odd_cy2_0 = cycle2 & 
		 (((h_byte_en_n[2:0] == 3'b001) & enbyte1) | 
		  ((h_byte_en_n[1:0] == 2'b10)  & enbyte0) | 
		  ((h_byte_en_n[2:0] == 3'b010) & enbyte1));

  assign 	 odd_cy2_1 = cycle2 & 
		 (((h_byte_en_n[1:0] == 2'b01) & enbyte0) | 
		  ((h_byte_en_n[2:0] == 3'b110) & enbyte1) | 
		  ((h_byte_en_n[2:0] == 3'b101) & enbyte1));

  assign 	 rd_odd8_0 = odd_8bit & ~gr4_b1 & m_odd_even & 
		 ((~cycle2 & (~h_byte_en_n[0] | ~h_byte_en_n[2])) | 
		  odd_cy2_0);

  assign 	 rd_odd8_1 = odd_8bit & ~gr4_b1 & m_odd_even & 
		 ((~cycle2 & (~h_byte_en_n[1] |~h_byte_en_n[3])) | 
		  odd_cy2_1);

  assign 	 rd_odd8_2 = odd_8bit & gr4_b1 & h_byte_en_n[2] & m_odd_even;

  assign 	 rd_odd8_3 = odd_8bit & gr4_b1 & h_byte_en_n[3] & m_odd_even;

//  always @(posedge mem_clk or negedge hreset_n)
//    if (!hreset_n)          cpu_lat_data <= 0;
//    else if (gra_ready_dly) cpu_lat_data <= g_graph_data_in;

  // Can't figure out how to remove this!!!!!
  // Not sure if we even need to latch the data as it seems to sit on the input
  // from the MC. For now leave as latches
//  assign cpu_lat_data = g_graph_data_in;
  
  always @(gra_ready_dly or g_graph_data_in or hreset_n)
    if (!hreset_n)          cpu_lat_data <= 0;
    else if (gra_ready_dly) cpu_lat_data <= g_graph_data_in;

  assign 	 rd_sel_1 = gr4_b1;
  assign 	 rd_sel_0 = gr4_b0;
  
  //
  // 	  planar rd enables 
  //
  assign 	 rd_pl0 = ~rd_sel_1 & ~rd_sel_0 & planar;
  assign 	 rd_pl1 = ~rd_sel_1 &  rd_sel_0 & planar;
  assign 	 rd_pl2 = rd_sel_1 & ~rd_sel_0  & planar;
  assign 	 rd_pl3 = rd_sel_1 & rd_sel_0   & planar;
  
  //
  //  Generating rd_en signals to enable planar, odd. or chain in 8-bit mode
  //
  assign 	 rd_8plodch0  = rd_pl0 | rd_odd8_0;
  assign 	 rd_8plodch1  = rd_pl1 | rd_odd8_1;
  
  assign 	 rd_8plodch2  = rd_pl2;
  assign 	 rd_8plodch3  = rd_pl3;

  // m_sr04_b3 = chain4
  assign 	 planar = ~m_odd_even & ~m_sr04_b3;
  
  always @* begin
    if      (rd_8plodch1) int_cpu_lat_data = cpu_lat_data[15:8];
    else if (rd_8plodch2) int_cpu_lat_data = cpu_lat_data[23:16];
    else if (rd_8plodch3) int_cpu_lat_data = cpu_lat_data[31:24];
    else                  int_cpu_lat_data = cpu_lat_data[7:0];
  end

  assign data8bit_en =  (planar | (m_odd_even & odd_8bit)) & rd_en_0;
  
  assign data_8bit = {4{int_cpu_lat_data[7:0]}};
  
  //
  // 	 odd-even mode and  not 8bit mode (16bit mode)
  //
  assign rd_odd16_0 = ~odd_8bit & ~gr4_b1 & m_odd_even;
  assign rd_odd16_1 = ~odd_8bit & gr4_b1 & m_odd_even; 

  always @* begin
    if(rd_odd16_1) int_odd16_lat_data = cpu_lat_data[31:16];
    else           int_odd16_lat_data = cpu_lat_data[15:0];
  end

  assign data_16bit = {2{int_odd16_lat_data[15:0]}};
  
  assign data16bit_en = m_odd_even & ~odd_8bit & rd_en_0;
  
  //
  //   chain 32-bit mode 
  //
  
  assign chain_data32_en =  rd_en_0 & m_sr04_b3;
  
  always @(data8bit_en or data16bit_en or chain_data32_en or rd_en_1 or 
	   int_clrcmpr or cpu_lat_data or data_16bit or data_8bit) begin
    if (data8bit_en)          h2mem_bout = data_8bit;
    else if (data16bit_en)    h2mem_bout = data_16bit;
    else if (chain_data32_en) h2mem_bout = cpu_lat_data;
    else if (rd_en_1)         h2mem_bout = int_clrcmpr;
    else                      h2mem_bout = cpu_lat_data;
  end
  
  always @(gr4_b1 or gr4_b0 or cpu_lat_data) begin
    case ({gr4_b1, gr4_b0})
      2'b00: g_int_crt22_data = cpu_lat_data[7:0];
      2'b01: g_int_crt22_data = cpu_lat_data[15:8];
      2'b10: g_int_crt22_data = cpu_lat_data[23:16];
      2'b11: g_int_crt22_data = cpu_lat_data[31:24];
    endcase
  end
  
  assign clrcmpr_low[0] = &((reg_gr2_qout[3:0] ~^ 
                             {cpu_lat_data[24], cpu_lat_data[16],
                              cpu_lat_data[8], cpu_lat_data[0]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[1] = &((reg_gr2_qout[3:0] ~^ 
                             {cpu_lat_data[25], cpu_lat_data[17],
                              cpu_lat_data[9], cpu_lat_data[1]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[2] = &((reg_gr2_qout[3:0] ~^ 
                             {cpu_lat_data[26], cpu_lat_data[18],
                              cpu_lat_data[10], cpu_lat_data[2]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[3] = &((reg_gr2_qout[3:0] ~^                   
                             {cpu_lat_data[27], cpu_lat_data[19],
                              cpu_lat_data[11], cpu_lat_data[3]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[4] = &((reg_gr2_qout[3:0] ~^ 
                             {cpu_lat_data[28], cpu_lat_data[20],
                              cpu_lat_data[12], cpu_lat_data[4]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[5] = &((reg_gr2_qout[3:0] ~^ 
                             {cpu_lat_data[29], cpu_lat_data[21],
                              cpu_lat_data[13], cpu_lat_data[5]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[6] = &((reg_gr2_qout[3:0] ~^ 
                             {cpu_lat_data[30], cpu_lat_data[22],
                              cpu_lat_data[14], cpu_lat_data[6]}) | 
                            ~reg_gr7_qout[3:0]);
  assign clrcmpr_low[7] = &((reg_gr2_qout[3:0] ~^ 
                            {cpu_lat_data[31], cpu_lat_data[23],
                             cpu_lat_data[15], cpu_lat_data[7]}) | 
                            ~reg_gr7_qout[3:0]);
  
  assign int_clrcmpr ={4{clrcmpr_low[7:0]}};

endmodule


