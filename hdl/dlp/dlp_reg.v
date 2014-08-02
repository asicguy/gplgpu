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
//  Title       :  Display List Processor REgister Block
//  File        :  dlp_reg.v
//  Author      :  Frank Bruno
//  Created     :  12-May-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
//   DLP_REG contains the ping pong registers used in the DLP.
//   writing the start address changes the active write registers.
//   Consecutively written end addresses are written into the same bank
//   as the start addresses are. Readbacks are always of the active regs
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
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
`timescale 1ns / 10ps

module dlp_reg
  (
   input  	hb_clk,         /* clock input                          */
   input 	hb_rstn,        /* reset input                          */
   input        dlp_rstn_hb,    // Sync reset of DLP when stopped
   input [8:2] 	hb_adr,         /* host bus address                     */
   input 	hb_wstrb,       /* host bus write strobr.               */
   input [3:0] 	hb_ben,         /* host bus byte enables                */
   input 	hb_csn,       	/* host bus chip select. -Drawing engine*/
   input [31:0] hb_din,         /* host bus data                        */
   input [8:2] 	de_adr,         /* host bus address                     */
   input 	de_wstrb,       /* host bus write strobr.               */
   input [3:0] 	de_ben,         /* host bus byte enables                */
   input 	de_csn,       	/* host bus chip select. -Drawing engine*/
   input [31:0] de_din,         /* host bus data                        */
   input 	actv_stp,       /* reset dlp_actv                       */
   input 	next_dle,       /* Increment Display List counter       */
   input 	cmd_ack,        /* Acknowledge start of list            */
   input        reset_wait,     // Reset the WCF bit
   input [3:0]  dlp_offset,     // Offset for the DLP
   
   output reg [27:0] hb_addr,    /* Current start address                */
   output reg [27:0] hb_end,     /* End address of current list          */
   output 	 hb_fmt,         /* Format of executing list             */
   output 	 hb_wc,          /* WC status of executing list          */
   output 	 hb_sen,         /* Current Source Enable bit            */
   output 	 hb_stp,         /* Status of the current command        */
   output reg	 dlp_actv_2,     /* Display list active signal           */
   output 	 dl_idle,        /* Display list is idle                 */
   output reg	 hold_start,     /* Start address must be held from being
                                    written                              */
   output reg 	 cmd_rdy_ld,     /* Load the command ready when active   */
   output 	 wcf,            /* When set, wait for cache flush       */
   output reg    [4:0]  dlp_wcnt /* When set, wait for cache flush       */
   );
  
  `define DLP_BURST_SIZE 28'h8
  `define DLP_BURST_SIZE_M1 5'h7

  reg signed [28:0] 	remainder;
  reg 		dl_cmd_strb;    /* Signal to load level 1 CMD to level 2*/
  reg 		start_strobe;   /* Signal to load level 1 CMD to level 2*/
  reg [27:0] 	hb_addr1;     /* Current address for level 1,1        */
  reg [27:0] 	hb_end1;      /* End address for level 1,1            */
  reg 		wc1;          /* Wait for cache to clear 1,1          */
  reg [3:0] 	hb_cntrl_w1;  /* Control signals for level 1,1        */
  reg 		wc2;          /* Wait for cache to clear 2,1          */
  reg [3:0] 	hb_cntrl_w2;  /* Control signals for level 2,1        */
  reg [1:0] 	adr_cntrl2;   /* start control signals for level 2,1  */
  reg [1:0] 	adr_cntrl1;   /* start control signals for level 1,1  */
  
  wire 		next_stp;       /* Execute next command bit             */
  wire 		toggle_out;     /* Toggle the output pointer            */
  wire 		dlp_hb_w;       /* Host bus write to the DLP            */
  wire 		dlp_de_w;       /* Write to the DLP from w/in a list    */
  wire 		start_strobe_comb;
  
  //`include "de_host_adr.h"
  parameter 	DLCNT_DLADR	= 6'b0_1111_1;	/* address 0x0f8 and 0x0fc */

  always @(posedge hb_clk or negedge hb_rstn) begin
    if (!hb_rstn)            cmd_rdy_ld <= 1'b0;
    else if (dlp_rstn_hb)    cmd_rdy_ld <= 1'b0;
    else if (dl_cmd_strb || start_strobe && dl_idle)  cmd_rdy_ld <= 1'b1;
    else if (cmd_ack)        cmd_rdy_ld <= 1'b0;
  end

  /************************************************************************/
  /* REGISTER DECODER                                                     */
  /* Current Instruction Registers level 1                                */
  /************************************************************************/
  assign dlp_hb_w = (hb_adr[8:3]==DLCNT_DLADR) && hb_wstrb && !hb_csn;
  assign dlp_de_w = (de_adr[8:3]==DLCNT_DLADR) && de_wstrb && !de_csn;

  assign start_strobe_comb = 	((dlp_hb_w & ~hb_ben[3] & ~hb_adr[2]) |
				 (dlp_de_w & ~de_adr[2]));

  wire 	 	 stop_list;
  assign 	 stop_list = ~hb_cntrl_w2[3] && hb_cntrl_w1[3];

  // Added frank's synchronous hb_rstn here to match the gates. Vic
  always @(posedge hb_clk) begin
    if (!hb_rstn) begin
      dl_cmd_strb  <= 1'b0;
      hb_addr1     <= 28'b0;
      hb_end1      <= 28'b0;
      adr_cntrl1   <= 2'b0;
      wc1          <= 1'b0;
      hb_cntrl_w1  <= 4'b0;
      hb_addr      <= 28'b0;
      hb_end       <= 28'b0;
      hb_cntrl_w2  <= 4'b1000;
      start_strobe <= 1'b0;
      adr_cntrl2   <= 2'b0;
      wc2          <= 1'b0;
      hold_start   <= 1'b0;
       remainder   <= 0;
    end else if (dlp_rstn_hb) begin
      dl_cmd_strb  <= 1'b0;
      start_strobe <= 1'b0;
      hb_cntrl_w2  <= 4'b1000;
      hold_start   <= 1'b0;
       remainder   <= 0;
    end else begin
       remainder <= (hb_end - hb_addr);
      if (start_strobe_comb) start_strobe <= 1'b1;
      /**********************************************************************/
      /* Load the address register, host bus has priority over DE.          */
      /**********************************************************************/
      if (dlp_hb_w && ~hb_adr[2]) begin
	hold_start <= 1'b1;
	// Load level 1_1 from Host Bus
	if(!hb_ben[0]) hb_addr1[3:0]   <= hb_din[7:4];
	if(!hb_ben[1]) hb_addr1[11:4]  <= hb_din[15:8];
	if(!hb_ben[2]) hb_addr1[19:12] <= hb_din[23:16];
	if(!hb_ben[3]) begin
	  hb_addr1[27:20] <= {dlp_offset, hb_din[27:24]};
	end
	if(!hb_ben[3]) adr_cntrl1      <= hb_din[30:29];
	if(!hb_ben[3]) wc1             <= hb_din[31];
      end else if (dlp_de_w && ~de_adr[2]) begin
	hold_start <= 1'b1;
	// Load level 1_1 from Within the DLP
	if(!de_ben[0]) hb_addr1[3:0]   <= de_din[7:4];
	if(!de_ben[1]) hb_addr1[11:4]  <= de_din[15:8];
	if(!de_ben[2]) hb_addr1[19:12] <= de_din[23:16];
	if(!de_ben[3]) begin
	  hb_addr1[27:20] <= {dlp_offset, de_din[27:24]};
	end
	if(!de_ben[3]) adr_cntrl1      <= de_din[30:29]; // was hb_din??
	if(!de_ben[3]) wc1             <= de_din[31];
      end
      
      /**********************************************************************/
      /* Load the control register, host bus has priority over DE. Use the  */
      /* inverted pointer register. The control register always points to   */
      /* the oposite register than the start address.                       */
      /**********************************************************************/
      // Load level 1_1 from Host Bus
      if (dlp_hb_w && hb_adr[2]) begin
	dl_cmd_strb <= ~hb_ben[3];
	if(!hb_ben[0]) hb_end1[3:0]     <= hb_din[7:4];
	if(!hb_ben[1]) hb_end1[11:4]    <= hb_din[15:8];
	if(!hb_ben[2]) hb_end1[19:12]   <= hb_din[23:16];
	if(!hb_ben[3]) begin
	  hb_end1[27:20]   <= {dlp_offset, hb_din[27:24]};
	end
	if(!hb_ben[3]) hb_cntrl_w1[3:0] <= hb_din[31:28];
      end else if (dlp_de_w && de_adr[2]) begin 
	dl_cmd_strb <= ~de_ben[3];
	// Load level 1_1 from Within the DLP
	if(!de_ben[0]) hb_end1[3:0]     <= de_din[7:4];
	if(!de_ben[1]) hb_end1[11:4]    <= de_din[15:8];
	if(!de_ben[2]) hb_end1[19:12]   <= de_din[23:16];
	if(!de_ben[3]) begin
	  hb_end1[27:20]   <= {dlp_offset, de_din[27:24]};
	end
	if(!de_ben[3]) hb_cntrl_w1[3:0] <= de_din[31:28];
      end

      /***********************************************************************/
      /* Current Instruction Register level 2                                */
      /***********************************************************************/
      // Reset the WCF bit after first wait
      if (reset_wait) adr_cntrl2[0] <= 1'b0;

      if (dl_cmd_strb && ~hold_start && stop_list && ~dl_idle) begin
	hb_addr      <= hb_end1-28'h1;
	start_strobe <= 1'b0;
	dl_cmd_strb  <= 1'b0;
	//dl_idle      <= 1'b1;
      end else if (start_strobe && dl_idle) begin
	hold_start   <= 1'b0;
	start_strobe <= 1'b0;
	hb_addr      <= hb_addr1;
	adr_cntrl2   <= adr_cntrl1;
	wc2          <= wc1;
      end else if (next_dle && ~dl_idle) 
	hb_addr      <= hb_addr + 28'h1;


      if (dl_cmd_strb && ~hold_start)
      begin
	hb_end      <= hb_end1;
	hb_cntrl_w2 <= hb_cntrl_w1;
	dl_cmd_strb <= 1'b0;
      end 
      else if (dl_idle && ~start_strobe) 
	hb_cntrl_w2[3] <= 1'b1;

    end // else: !if(!hb_rstn)      
  end // always @ (posedge hb_clk)

   /*
   always @* begin
      if (({1'b0, hb_end} - {1'b0, hb_addr}) >= `DLP_BURST_SIZE)
	dlp_wcnt = `DLP_BURST_SIZE_M1;
      else
	dlp_wcnt = (hb_end - hb_addr) - 1'b1;
   end
    */
   //always @* remainder = (hb_end - hb_addr) - `DLP_BURST_SIZE;

  always @*
    if(remainder > `DLP_BURST_SIZE) dlp_wcnt = `DLP_BURST_SIZE_M1;
    else dlp_wcnt = remainder -1'b1;
      
  /************************************************************************/
  /* Current DLP instruction Mux                                          */
  /************************************************************************/
  assign hb_fmt  = hb_cntrl_w2[1];
  assign hb_sen  = hb_cntrl_w2[2];
  assign hb_stp  = hb_cntrl_w2[3];
  assign hb_wc   = wc2;
  assign wcf     = adr_cntrl2[0];
  
  /************************************************************************/
  /* DLP next instruction command                                         */
  /************************************************************************/

  reg dl_idle_hold;
  
  assign dl_idle = (hb_addr == hb_end) | dl_idle_hold; // DLP is done w/ current command

  always @(posedge hb_clk, negedge hb_rstn) begin
    if (!hb_rstn)            		 dl_idle_hold <= 1'b0;
    //else if (hb_stp)            	 dl_idle_hold <= 1'b0;
    else if (dl_cmd_strb && ~hold_start) dl_idle_hold <= 1'b0;
    else if (hb_stp || dl_idle) 	 dl_idle_hold <= 1'b1;
  end

  assign next_stp = hb_cntrl_w2[3];
  assign toggle_out = dl_idle & ~next_stp;
  
  /************************************************************************/
  /* Generate active signal                                               */
  /************************************************************************/
  always @(posedge hb_clk or negedge hb_rstn) begin
    if(!hb_rstn)                     			     dlp_actv_2 <= 1'b0;
    else if(dlp_rstn_hb)             			     dlp_actv_2 <= 1'b0;
    else if ((dl_cmd_strb && ~hb_cntrl_w1[3]) || toggle_out) dlp_actv_2 <= 1'b1;
    else if ((~actv_stp && dl_idle && next_stp) ||
	     (dl_cmd_strb && hb_cntrl_w1[3])) 		     dlp_actv_2 <= 1'b0;
  end

endmodule
