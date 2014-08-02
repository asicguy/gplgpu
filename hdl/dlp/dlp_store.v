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
//  Title       :  DLP Store.
//  File        :  dlp_store.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  this module stores the dlp data and outputs the data when needed
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

module dlp_store
  #(parameter BYTES = 4)
  (
   input                 hb_clk,        // Host bus clock.
   input                 hb_rstn,       // Reset signal for control signals
   input                 dlp_rstn_mc,   // Synchronous stopping of DLP 
   input                 dlp_wreg_pop,  // DLP push signal.
   input [(BYTES*8)-1:0] dlp_data,      // memory controller data in
   input                 dlf,           // format selector for format 4
   input                 text,          // text mode selector
   input                 char_select,   // character selector
   input  [3:0]          sorg_upper,    // Upper 4 bits of sorg
   
   output reg   [1:0]    list_format,   // Display list format
   output [1:0]          wcount,         /* Number of registers to write:
                                         * 00 (default) write 3 words
                                         * 01 one word  
                                         * 10 two words
                                         * 11 three words               */
   output                wvs,           // Wait for vertical sync       */
   output [31:0]         table_org0,    // Origin pointer to text tables
   output [31:0]         table_org1,    // Origin pointer to text tables
   output                char_count,    // number of characters 0=1, 1=2
   output [31:0]         curr_sorg,     // Source origin of current entry
   output [3:0]          curr_pg_cnt,   // Pages of current entry
   output [7:0]          curr_height,   // height of current entry
   output [7:0]          curr_width,    // width of current entry
   output [8:2]          aad,bad,cad,   // Address for data
   output [127:0]        dl_temp,       // Mux'd input to DLP
   output [15:0]         dest_x,        // X destination for text mode
   output [15:0]         dest_y         // Y destiantion for text mode
   );
  
  reg [127:0]            dl_data_reg;   // Store data from MC
  reg [127:0]            dl_text_reg;   // Store data from MC
  
  wire [1:0]             dlp_format;    /* format of the dlp, consists of
                                         *  dlf in the command reg
                                         *  reg[25:24]
                                         *  000:        3 register write mode
                                         *  001:        dma mode
                                         *  01x:        textmode
                                         *  1xx:        four register write mode */
  wire [31:0]            dest0,         /* XY destination of glyphs             */
                         dest1;         /* XY destination of glyphs             */
  wire [27:0]            sorg0,         /* Source origin for glyphs             */
                         sorg1;         /* Source origin for glyphs             */
  wire [3:0]             pg_cnt0,       /* number of pages of glyph             */
                         pg_cnt1;       /* number of pages of glyph             */
  wire [7:0]             height0,       /* height of glyph                      */
                         height1;       /* height of glyph                      */
  wire [7:0]             width0,                /* width of glyph                       */
                         width1;                /* width of glyph                       */
  wire [7:0]             x_off0,                /* X offset into the glyph              */
                         x_off1;                /* x offset into the glyph              */
  wire [7:0]             y_off0,                /* y offset into the glyph              */
                         y_off1;                /* y offset into the glyph              */
  wire                   curr_org;      /* which half of table entry            */
  wire [15:0]            y_off_n;       /* inverted Y offset                    */
  wire [31:0]            curr_dest;     /* destination of current entry         */
  wire [7:0]             curr_x_off;    /* X offset of current entry            */
  wire [7:0]    curr_y_off;     /* Y offset of current entry            */
  
  localparam    
                REG3    = 2'b00,                // 3 registers programmable
                REG4    = 2'b01,                // 4 registers fixed
                DMA     = 2'b10,                // AGP DMA mode
                TEXT    = 2'b11;                // Text processing mode
  
/************************************************************************/

/* Mode selector ********************************************************/
always @*
  casex ({dlf, dlp_format}) /* synopsys full_case parallel_case */
    3'b1_xx: list_format = REG4;
    3'b0_00: list_format = REG3;
    3'b0_01: list_format = DMA;
    3'b0_1x: list_format = TEXT;
  endcase

  /* Data Registers *******************************************************/
  always @(posedge hb_clk or negedge hb_rstn)
    if (!hb_rstn) begin
      dl_data_reg[31]       <= 1'b0;
      dl_data_reg[27:24]    <= 4'b0;
    end else if (dlp_rstn_mc) begin
      dl_data_reg[31]       <= 1'b0;
      dl_data_reg[27:24]    <= 4'b0;
    end else if (dlp_wreg_pop) begin
      if (~text)
        case (BYTES)
          4: begin
            dl_data_reg[127:96] <= dlp_data;
            dl_data_reg[95:64]  <= dl_data_reg[127:96];
            dl_data_reg[63:32]  <= dl_data_reg[95:64];
            dl_data_reg[31:0]   <= dl_data_reg[63:32];
          end
          8: begin
            dl_data_reg[127:64] <= dlp_data;
            dl_data_reg[63:0]   <= dl_data_reg[127:64];
          end
          default:
            // BYTES = 16
            dl_data_reg <= dlp_data;
        endcase // case(BYTES)
      else 
        case (BYTES)
          4: begin
            dl_text_reg[127:96] <= dlp_data;
            dl_text_reg[95:64]  <= dl_text_reg[127:96];
            dl_text_reg[63:32]  <= dl_text_reg[95:64];
            dl_text_reg[31:0]   <= dl_text_reg[63:32];
          end
          8: begin
            dl_text_reg[127:64] <= dlp_data;
            dl_text_reg[63:0]   <= dl_text_reg[127:64];
          end
          default:
            // BYTES = 16
            dl_text_reg <= dlp_data;
        endcase // case(BYTES)

    end
  
  /* Address Mux **********************************************************/
  assign dl_temp = dl_data_reg;

  // Command Data for REG3, REG4, DMA modes
  assign aad            = {dl_data_reg[28], dl_data_reg[7:2]};
  assign bad            = {dl_data_reg[29], dl_data_reg[15:10]};
  assign cad            = {dl_data_reg[30], dl_data_reg[23:18]};
  assign dlp_format     = dl_data_reg[25:24];
  assign wcount         = dl_data_reg[27:26];
  assign wvs            = dl_data_reg[31];
  
  // Data for TEXT mode
  // assign table_org0     = {dl_data_reg[95:89], dl_data_reg[24:0]};
  assign table_org0     = {7'h0, dl_data_reg[24:0]};
  assign char_count     = dl_data_reg[27];
  assign dest0          = dl_data_reg[63:32];
  // assign table_org1     = dl_data_reg[95:64];
  assign table_org1     = {7'h0, dl_data_reg[88:64]};
  assign dest1          = dl_data_reg[127:96];
  
  // assign sorg0          = dl_text_reg[27:0];
  assign sorg0          = {3'b000, dl_text_reg[24:0]};
  assign pg_cnt0        = dl_text_reg[31:28];
  assign height0        = dl_text_reg[39:32];
  assign width0         = dl_text_reg[47:40];
  assign y_off0         = dl_text_reg[55:48];
  assign x_off0         = dl_text_reg[63:56];
  // assign sorg1          = dl_text_reg[91:64];
  assign sorg1          = {3'b000, dl_text_reg[88:64]};
  assign pg_cnt1        = dl_text_reg[95:92];
  assign height1        = dl_text_reg[103:96];
  assign width1         = dl_text_reg[111:104];
  assign y_off1         = dl_text_reg[119:112];
  assign x_off1         = dl_text_reg[127:120];
  
// Select current character
  assign curr_org       = (char_select) ? table_org1[3] : table_org0[3];
  assign curr_dest      = (char_select) ? dest1 : dest0;
  // assign curr_sorg      = (curr_org) ? {sorg_upper, sorg1} : {sorg_upper, sorg0};
  assign curr_sorg      = (curr_org) ? {4'h0, sorg1} : {4'h0, sorg0};
  assign curr_pg_cnt    = (curr_org) ? pg_cnt1 : pg_cnt0;
  assign curr_height    = (curr_org) ? height1 : height0;
  assign curr_width     = (curr_org) ? width1 : width0;
  assign curr_x_off     = (curr_org) ? x_off1 : x_off0;
  assign curr_y_off     = (curr_org) ? y_off1 : y_off0;

  //
  // Formerly DLP_ALU
  // X offset adder
  assign dest_x = curr_dest[31:16] + 
         {{8{curr_x_off[7]}}, curr_x_off}; // X offset adder
  
  // Y offset subtractor
  assign y_off_n = ~{{8{curr_y_off[7]}}, curr_y_off};
  assign dest_y = curr_dest[15:0] + y_off_n + 16'h1;

endmodule
