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
//  Title       :  DLP Top Level
//  File        :  dlp_top.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  The Display List Processor is used to automatically run commands
//  to the Drawing engine, copy engine, or the DMA controller.
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

  module dlp_top
    #(parameter BYTES = 4
      )
    (
     input                 hb_clk,         // clock input
     input                 hb_rstn,        // reset input
     input [8:2]           hb_adr,         // host bus address
     input                 hb_wstrb,       // host bus write strobr.
     input [3:0]           hb_ben,         // host bus byte enables            
     input                 hb_csn,         // host bus chip select.
     input [31:0]          hb_din,         // host bus data
     input [3:0]           dlp_offset,     // Offset for DLP data
     input                 de_busy,        // drawing pipeline busy            
     input                 mclock,         // Memory controller clock
     input                 mc_rdy,         // memory controller ready          
     input                 mc_push,        // memory controller push           
     input                 mc_done,        // memory controller last word
     input [(BYTES*8)-1:0] pd_in,          // pixel data input                
     input                 v_sync_tog,     // Vertical Sync Toggle Signal
     input                 cache_busy,     // The Linear windows cache is busy 
     input [3:0]           sorg_upper,     // Upper 4 bits of text SORG
     
     //**********************************************************************
     // outputs to the drawinig engine module.                          
     //**********************************************************************
     output [8:2]          de_adr,         // drawing engine bus address       
     output                de_wstrb,       // drawing engine bus write strobr. 
     output                de_csn,         // drawing engine bus write strobr. 
     output [3:0]          de_ben,         // drawing engine bus byte enables  
     output [31:0]         de_data,        // drawing engine data bus data     
     output [53:0]         dl_rdback,      // host bus read back data.         
     
     //**********************************************************************
     // outputs to the memory controller module.
     //**********************************************************************
     output [27:0]         mc_adr,         // display list address for MC
     output                dl_sen,         // display list source enable.
     output                dl_memreq,      // drawing engine bus write strobr  
     output [4:0]          dlp_wcnt,       // display list word count.
     
     //**********************************************************************
     // outputs to the Host Bus                                              
     //**********************************************************************
     output                hb_de_busy,     // drawing engine busy to host.
     output                hold_start      // can't write a start address     
     );

  wire [1:0]    list_format;    /* Display list format                 
                                 * 00 3 registers programmable         
                                 * 01 4 registers XY0, XY1, XY2, XY3 
                                 * 10 AGP DMA                   
                                 * 11 Text mode                 */
                        
  wire          dlp_actv_2;     /* dlp is currently running             */
  wire [27:0]   hb_end;         /* Active End address register          */
  wire          dl_idle;        /* Display list processor idle          */
  wire          dl_stop;        /* Stop Display List                    */
  wire          dlf;            /* Display List Format                  */
  wire          wvs;            /* Wait for vertical sync               */
  wire          v_sunk;         /* Sync up the vertical sync signal     */
  wire [1:0]    wcount;         /* Number of registers to write:
                                 * 00 (default) write 3 words        
                                 * 01 one word                      
                                 * 10 two words                       
                                 * 11 three words                       */
  wire          actv_stp;       /* reset dlp_actv                       */
  wire          cmd_rdy_ld;     /* Load the command ready when active   */
  wire          hb_wc;          /* wait for cache flush                 */
  wire          wcf;            /* wait for cache flush signal          */
  wire [27:0]   dl_adr;         /* current display list address         */
  wire          char_select;    /* selects between character0 or 1      */
  wire [31:0]   table_org0,     /* Origin pointer to text tables        */
                table_org1;     /* Origin pointer to text tables        */
  wire          char_count;     /* number of characters 0=1, 1=2        */
  wire [31:0]   curr_sorg;      /* Source origin of current entry       */
  wire [3:0]    curr_pg_cnt;    /* Pages of current entry               */
  wire [7:0]    curr_height;    /* height of current entry              */
  wire [7:0]    curr_width;     /* width of current entry               */
  wire [8:2]    aad,bad,cad;    /* Address for data                     */
  wire [127:0]  dl_temp;        /* Mux'd input to DLP                   */
  wire [15:0]   dest_x;         /* X destination for text mode          */
  wire [15:0]   dest_y;         /* Y destiantion for text mode          */
  wire          reset_wait;     // Reset the WCF bit
  wire          next_dle;
  wire          cmd_ack;
  wire          text_store;
  wire          dlp_data_avail;
  wire          dlp_flush;
  wire [127:0]  dlp_data;
  wire          dlp_wreg_pop;
  
  reg           dlp_rstn_hb;       /* Stop Cmd Rstn */ 
  reg           dlp_rstn_mc;       /* Stop Cmd Rstn */ 
  reg           mc_sync0, mc_sync1; // Synchronize the dlp_rstn_hb to MC
  reg           mc_done_0, mc_done_tog, mc_done_tog_sync_0, mc_done_tog_sync_1, mc_done_tog_sync;

  reg           dlp_pop;
  
  localparam    DLCNT_DLADR     = 6'b0_1111_1;  /* address 0x0f8 and 0x0fc */

  /************************************************************************/
  /* Synchronizers                                                      */
  /************************************************************************/
  pp_sync SYNC0 (hb_clk, hb_rstn, v_sync_tog, v_sunk);

  always @(posedge mclock or negedge hb_rstn)
    if (!hb_rstn) begin
      mc_sync0    <= 1'b0;
      mc_sync1    <= 1'b0;
      dlp_rstn_mc <= 1'b0;
      mc_done_0   <= 1'b0;
      mc_done_tog <= 1'b0;
    end else begin
      mc_sync0 <= dlp_rstn_hb;
      mc_sync1 <= mc_sync0;
      dlp_rstn_mc <= mc_sync0 & ~mc_sync1;
      mc_done_0 <= mc_done;
      if (mc_done & ~mc_done_0) mc_done_tog <= ~mc_done_tog;
    end
  
  always @(posedge hb_clk or negedge hb_rstn)
    if (!hb_rstn) begin
      dlp_rstn_hb <= 1'b0;
      dlp_pop     <= 1'b0;
    end else begin
      dlp_pop <= dlp_wreg_pop;
      dlp_rstn_hb <= !hb_ben[3] & hb_din[31] & 
                     (hb_adr == {DLCNT_DLADR, 1'b1}) &&
                     hb_wstrb && !hb_csn;
      mc_done_tog_sync_0 <= mc_done_tog;
      mc_done_tog_sync_1 <= mc_done_tog_sync_0;
      mc_done_tog_sync   <= mc_done_tog_sync_1 ^ mc_done_tog_sync_0;
    end

  /************************************************************************/
  /* Break apart DL Control                                               */
  /************************************************************************/
  dlp_reg REG
    (
     .hb_clk             (hb_clk),
     .hb_rstn            (hb_rstn),
     .dlp_rstn_hb        (dlp_rstn_hb),
     .hb_adr             (hb_adr),
     .hb_wstrb           (hb_wstrb),
     .hb_ben             (hb_ben),
     .hb_csn             (hb_csn),
     .hb_din             (hb_din),
     .de_adr             (de_adr),
     .de_wstrb           (de_wstrb),
     .de_ben             (de_ben),
     .de_csn             (de_csn),
     .de_din             (de_data),
     .actv_stp           (actv_stp),
     .next_dle           (next_dle),
     .cmd_ack            (cmd_ack),
     .reset_wait         (reset_wait),
     .dlp_offset         (4'h0), // dlp_offset),
     
     .hb_addr            (dl_adr),
     .hb_end             (hb_end),
     .hb_fmt             (dlf),
     .hb_wc              (hb_wc),
     .hb_sen             (dl_sen),
     .hb_stp             (dl_stop),
     .dlp_actv_2         (dlp_actv_2),
     .dl_idle            (dl_idle),
     .hold_start         (hold_start),
     .cmd_rdy_ld         (cmd_rdy_ld),
     .wcf                (wcf),
     .dlp_wcnt           (dlp_wcnt)
     );

  dlp_store #
    (
     .BYTES              (BYTES)
     ) STORE
    (
     .hb_clk             (hb_clk),
     .hb_rstn            (hb_rstn),
     .dlp_rstn_mc        (dlp_rstn_mc),
     .dlp_wreg_pop       (dlp_wreg_pop),
     .dlp_data           (dlp_data), 
     .dlf                (dlf),
     .text               (text_store),
     .char_select        (char_select),
     .list_format        (list_format),
     .wcount             (wcount),
     .wvs                (wvs), 
     .table_org0         (table_org0), 
     .table_org1         (table_org1),
     .char_count         (char_count),
     .sorg_upper         (sorg_upper),
     .curr_sorg          (curr_sorg),
     .curr_pg_cnt        (curr_pg_cnt), 
     .curr_height        (curr_height),
     .curr_width         (curr_width), 
     .aad                (aad),
     .bad                (bad),
     .cad                (cad),
     .dl_temp            (dl_temp),
     .dest_x             (dest_x),
     .dest_y             (dest_y)
     );

  dlp_sm SM
    (
     .hb_clk             (hb_clk),
     .hb_rstn            (hb_rstn),
     .dlp_rstn_hb        (dlp_rstn_hb),
     .mc_done            (mc_done_tog_sync),
     .hb_adr             (hb_adr),
     .hb_wstrb           (hb_wstrb),
     .hb_ben             (hb_ben),
     .hb_csn             (hb_csn),
     .hb_din             (hb_din),
     .de_busy            (de_busy),
     .dl_stop            (dl_stop), 
     .table_org0         (table_org0),
     .table_org1         (table_org1),
     .aad                (aad),
     .bad                (bad),
     .cad                (cad),
     .dl_temp            (dl_temp),
     .curr_sorg          (curr_sorg),
     .curr_height        (curr_height),
     .curr_width         (curr_width),
     .curr_pg_cnt        (curr_pg_cnt),
     .dest_x             (dest_x),
     .dest_y             (dest_y),
     .cmd_rdy_ld         (cmd_rdy_ld),
     .wcf                (wcf),
     .cache_busy         (cache_busy),
     .mc_rdy             (mc_rdy),
     .dl_idle            (dl_idle),
     .list_format        (list_format),
     .v_sunk             (v_sunk),
     .wvs                (wvs),
     .dlf                (dlf),
     .wcount             (wcount),
     .dl_adr             (dl_adr),
     .dlp_actv_2         (dlp_actv_2),
     .char_count         (char_count),
     .dlp_data_avail     (dlp_data_avail),
     
     .dl_memreq          (dl_memreq),
     .text_store         (text_store),
     .char_select        (char_select),
     .actv_stp           (actv_stp),
     .mc_adr             (mc_adr),
     .hb_de_busy         (hb_de_busy),
     .de_adr             (de_adr),
     .de_ben             (de_ben),
     .de_wstrb           (de_wstrb),
     .de_data            (de_data),
     .de_csn             (de_csn),
     .cmd_ack            (cmd_ack),
     .next_dle           (next_dle),
     .reset_wait         (reset_wait),
     .dlp_wreg_pop       (dlp_wreg_pop),
     .dlp_flush          (dlp_flush)
     );

  dlp_cache #
    (
     .BYTES              (BYTES)
     ) u_dlp_cache
    (
     .hb_clk             (hb_clk),
     .hb_rstn            (hb_rstn),
     .dlp_flush          (dlp_flush),
     .dlp_pop            (dlp_pop),
     .mclock             (mclock),
     .mc_push            (mc_push),
     .pd_in              (pd_in),
     // Outputs.
     .dlp_data_avail     (dlp_data_avail),
     .dlp_data     	 (dlp_data)
     );

assign dl_rdback[20:0]  =       dl_adr[20:0];   // lower current addr
assign dl_rdback[53:51] =       3'b0;           // upper current addr (gone)
assign dl_rdback[22:21] =       {hb_wc,hold_start};
assign dl_rdback[43:23] =       hb_end[20:0];   // lower end address
assign dl_rdback[50:48] =       3'b0;           // upper end address (gone)
assign dl_rdback[44]    =       1'b0;
assign dl_rdback[45]    =       dlf;
assign dl_rdback[46]    =       dl_sen;
assign dl_rdback[47]    =       dl_stop;

endmodule
