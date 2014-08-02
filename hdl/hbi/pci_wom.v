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
//  Title       :  PCI Write Only Master
//  File        :  pci_wom.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module detects specific status events within Silver Hammer
//  and then masters a single dword PCI write containing all status
//  information to a predefined system memory location.  The idea
//  here is to reduce the amount of time the host spends PCI polling.
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

`timescale 1ns / 10ps
module pci_wom
  (
   input		reset_n,
   input		hb_clk,
   input		gnt_n,
   input		irdy_in_n,
   input		frame_in_n,
   input		trdy_in_n,
   input		stop_in_n,
   input		devsel_in_n,
   input		dlp_busy,
   input		de_pl_busy,
   input		flow_rpb,
   input		flow_prv,
   input		flow_clp,
   input		flow_mcb,  
   input		flow_deb,
   input		v_blank,
   input		vb_int_tog,
   input		hb_int_tog,
   // arise.  To be used in PCI systems.
   input		pci_mstr_en,  // master enable indicator from config
   input [31:2]	        pci_wr_addr,
   input [21:0]	        pcim_masks,

   output [31:0]	pci_ad_out,
   output	        pci_ad_oe,
   output reg [3:0]     c_be_out,
   output reg           irdy_n,
   output reg	        pci_irdy_oe_n,
   output reg	        pci_req_out_n,
   output reg 	        frame_out_n,
   output reg	        frame_oe_n
   );
  
  reg		pci_req_out, pci_irdy_out, frame_out, frame_oe;
  reg		pci_irdy_oe;
  
  reg [2:0]	devsel_cnt;
  reg		inc_devsel_cnt, clr_devsel_cnt;
  reg		pci_ad_oe_sm;  
// I intentionally stayed away from bussing the trigger
// conditions and masks to make this code easier to follow.
  
 
  wire		v_blank_re_mask, v_blank_fe_mask,  // rising/falling edges masks
  		vb_int_re_mask, hb_int_re_mask,
  		flow_deb_re_mask, flow_deb_fe_mask,
  		dlp_busy_re_mask, dlp_busy_fe_mask,
  		de_pl_busy_re_mask, de_pl_busy_fe_mask,
		flow_rpb_re_mask, flow_rpb_fe_mask,
 		flow_prv_re_mask, flow_prv_fe_mask, 
  		flow_clp_re_mask,
		flow_mcb_re_mask, flow_mcb_fe_mask;
		
 // things that trigger this semaphore writer
  wire		v_blank_trig, vb_int_trig, hb_int_trig, flow_deb_trig,
		dlp_busy_trig, de_pl_busy_trig,
		flow_rpb_trig, flow_prv_trig, flow_clp_trig,
		flow_mcb_trig;
  
  reg		flow_deb_d, 
		dlp_busy_d, de_pl_busy_d,
		flow_rpb_d, flow_prv_d, flow_clp_d, flow_mcb_d,
		vb_int_clr_n, hb_int_clr_n;
  
  reg		v_blank_d;
  reg		v_blank_d1;
  reg 		vb_catch_0;
  reg 		vb_catch_1;
  reg 		vb_catch;
  reg 		vb_catch_d;
  reg 		hb_catch_0;
  reg 		hb_catch_1;
  reg 		hb_catch;
  reg 		hb_catch_d;
  
  reg [2:0] 	pci_state, pci_next;

  reg		go_pci;           // starts the state machine
  reg		pci_parked;       // the we're parked on the bus indicator

  reg           r_irdy_in_n, r_frame_in_n;
  reg 		grant_n_reg;
  
  wire [3:0] 	pci_be_out;

  parameter	PCI_IDLE = 0,
		PCI_WAIT2_REQ = 1,
		PCI_WAIT4_IDLE = 2,
		PCI_WAIT4_DEV = 3,
		PCI_RETRY = 4,
		PCI_RETRY1 = 5;

  // Register Grant for better timing
  always @(posedge hb_clk) grant_n_reg <= gnt_n;

  // Registers that used to be in the AGP section
  always @(posedge hb_clk or negedge reset_n)
    if (!reset_n) begin
      pci_req_out_n <= 1'b1;
      irdy_n <= 1'b1;
      pci_irdy_oe_n <= 1'b1;
    end else begin
      pci_req_out_n <= ~pci_req_out;
      if (pci_irdy_oe) irdy_n <= ~pci_irdy_out;
      pci_irdy_oe_n <= ~pci_irdy_oe;
    end
  
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n)        c_be_out <= 3'h0;
    else if (pci_ad_oe)  c_be_out <= pci_be_out;
    else                 c_be_out <= 3'h0;
  end //
  
  // start with interface register loads
  assign dlp_busy_re_mask    = pcim_masks[20];
  assign dlp_busy_fe_mask    = pcim_masks[19];
  assign de_pl_busy_re_mask = pcim_masks[18];
  assign de_pl_busy_fe_mask = pcim_masks[17];
  assign flow_rpb_re_mask   = pcim_masks[16];
  assign flow_rpb_fe_mask   = pcim_masks[15];
  assign flow_prv_re_mask   = pcim_masks[14];
  assign  flow_prv_fe_mask   = pcim_masks[13];
  assign  flow_clp_re_mask   = pcim_masks[12];
  assign  flow_mcb_re_mask   = pcim_masks[11];
  assign  flow_mcb_fe_mask   = pcim_masks[10];
  assign  v_blank_re_mask    = pcim_masks[9];
  assign  v_blank_fe_mask    = pcim_masks[8];
  assign  vb_int_re_mask     = pcim_masks[7];
  assign  hb_int_re_mask     = pcim_masks[6];   
  assign  flow_deb_re_mask   = pcim_masks[5];
  assign  flow_deb_fe_mask   = pcim_masks[4];  	      

  always @ (posedge hb_clk or negedge reset_n)
    if (!reset_n) begin
      vb_catch_0 <= 1'b0;
      vb_catch_1 <= 1'b0;
      vb_catch   <= 1'b0;
      vb_catch_d <= 1'b0;
      hb_catch_0 <= 1'b0;
      hb_catch_1 <= 1'b0;
      hb_catch   <= 1'b0;
      hb_catch_d <= 1'b0;
    end else begin
      vb_catch_0 <= vb_int_tog;
      vb_catch_1 <= vb_catch_0;
      hb_catch_0 <= hb_int_tog;
      hb_catch_1 <= hb_catch_0;

      if (!vb_int_clr_n) vb_catch <= 1'b0;
      else if (vb_catch_0 ^ vb_catch_1) vb_catch <= 1'b1;
      vb_catch_d <= vb_catch;
      if (!hb_int_clr_n) hb_catch <= 1'b0;
      else if (hb_catch_0 ^ hb_catch_1) hb_catch <= 1'b1;
      hb_catch_d <= hb_catch;
    end
      
  // Build the pipe stage that will be used to detect
  // rising and falling edges.       
  always @ (posedge hb_clk) begin
    // first a somple synchronizer for the crt timing stuff
    v_blank_d <= v_blank;
    // Don't let the current state flop change if we have irdy down unless
    // the target is terminating the cycle.
    if (!pci_irdy_out) begin
      v_blank_d1 <= v_blank_d;      
      dlp_busy_d <= dlp_busy;
      de_pl_busy_d <= de_pl_busy;   
      flow_rpb_d <= flow_rpb;
      flow_prv_d <= flow_prv;
      flow_clp_d <= flow_clp;
      flow_mcb_d <= flow_mcb;
      flow_deb_d <= flow_deb;
    end //   
  end //
  
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n) vb_int_clr_n <= 1'b1;
    else if (vb_catch && pci_state != PCI_IDLE && pci_next == PCI_IDLE)
      vb_int_clr_n <= 1'b0;
    else vb_int_clr_n <= 1'b1;
  end //
  
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n) hb_int_clr_n <= 1'b1;
    else if (hb_catch && pci_state != PCI_IDLE && pci_next == PCI_IDLE)
      hb_int_clr_n <= 1'b0;
    else hb_int_clr_n <= 1'b1;
  end //
  
  assign pci_ad_out = frame_out ? {pci_wr_addr, 2'b0} :
		      {1'h1, 19'h0, v_blank_d1, vb_catch, hb_catch, 1'b0,
		       1'b0, dlp_busy_d, de_pl_busy_d, flow_rpb_d,
		       flow_prv_d, flow_clp_d, flow_mcb_d, flow_deb_d};
  
  assign pci_be_out = frame_out ? 4'b0111 : 4'b0000;
  
  // Now to detect the status change that will result
  // in a "semaphore write" to system memory.
  
  // caution: need to sync the blanks to hck?
  assign v_blank_trig = ((!v_blank_re_mask && v_blank_d && !v_blank_d1) ||
			 (!v_blank_fe_mask && !v_blank_d && v_blank_d1));
  
  assign vb_int_trig = (!vb_int_re_mask && vb_catch && !vb_catch_d);
  
  assign hb_int_trig = (!hb_int_re_mask && hb_catch && !hb_catch_d);
  
  assign dlp_busy_trig =
	 ((!dlp_busy_re_mask && dlp_busy && !dlp_busy_d) ||
	  (!dlp_busy_fe_mask && !dlp_busy && dlp_busy_d));
  
  assign de_pl_busy_trig = 
	 ((!de_pl_busy_re_mask && de_pl_busy && !de_pl_busy_d && flow_deb_d) ||
	  (!de_pl_busy_fe_mask && !de_pl_busy && de_pl_busy_d && flow_deb_d));
  
  assign flow_rpb_trig =
	 ((!flow_rpb_re_mask && flow_rpb && !flow_rpb_d) ||
	  (!flow_rpb_fe_mask && !flow_rpb && flow_rpb_d));
  
  assign flow_prv_trig =
	 ((!flow_prv_re_mask && flow_prv && !flow_prv_d && flow_deb_d) ||
	  (!flow_prv_fe_mask && !flow_prv && flow_prv_d && !flow_deb_d));
  
  assign flow_clp_trig =
	 (!flow_clp_re_mask && flow_clp && !flow_clp_d);
  
  assign flow_mcb_trig =
	 ((!flow_mcb_re_mask && flow_mcb && !flow_mcb_d) ||
	  (!flow_mcb_fe_mask && !flow_mcb && flow_mcb_d));
  
  assign flow_deb_trig =
	 ((!flow_deb_re_mask && flow_deb && !flow_deb_d) ||
	  (!flow_deb_fe_mask && !flow_deb && flow_deb_d));
  
  // smaple the above trigger conditions at clk time
  // send this off to the state machine to begin the pci write
  
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n)
      go_pci <= 1'b0;
    else if ((v_blank_trig ||
  	      vb_int_trig ||
	      hb_int_trig ||
	      flow_deb_trig ||
	      dlp_busy_trig ||
	      de_pl_busy_trig ||
	      flow_rpb_trig ||
	      flow_prv_trig ||
	      flow_clp_trig ||
	      flow_mcb_trig) && pci_mstr_en)
      go_pci <= 1'b1;
    else
      go_pci <= 1'b0;
  end //


  // clock frame and irdy.
  // we do not burst therefore we can look at a delayed
  // version of these 2 signals thus making timing easier
  
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n) begin
      r_irdy_in_n  <= 1'b0;  
      r_frame_in_n <= 1'b0;
    end else begin
      r_irdy_in_n  <= irdy_in_n;  
      r_frame_in_n <= frame_in_n;
    end //
  end //
  

  // The parked on the PCI Bus indicator
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n) 
      pci_parked <= 1'b0;
    else if (!grant_n_reg && pci_req_out_n && r_irdy_in_n && r_frame_in_n)
      pci_parked <= 1'b1;
    else
      pci_parked <= 1'b0;
  end //
  
  // Here lies the state machine responsible for PCI bus mastering
  // a single dword write. No need to worry about a latency timer.
  
  always @* begin
    pci_next       = pci_state;
    pci_req_out    = 1'b0;
    pci_irdy_out   = 1'b0;
    pci_irdy_oe    = 1'b0;
    pci_ad_oe_sm   = 1'b0;
    frame_out      = 1'b0;
    frame_oe       = 1'b0;
    inc_devsel_cnt = 1'b0;
    clr_devsel_cnt = 1'b0;
    
    case (pci_state)
      
      PCI_IDLE: // 0
	begin
	  if (go_pci) begin
	    if (!grant_n_reg && pci_req_out_n
		&& r_irdy_in_n && r_frame_in_n) begin
	      pci_irdy_oe = 1'b1;
	      frame_out = 1'b1; //assert frame for 1 cycle
	      frame_oe = 1'b1;
	      pci_ad_oe_sm = 1'b1;
	      pci_next = PCI_WAIT4_DEV;
	    end else begin
	      pci_next = PCI_WAIT2_REQ;
	    end //	      
	  end //
	  
	end // case: PCI_IDLE
      
      
      PCI_WAIT2_REQ: begin
	pci_req_out = 1'b1;
	pci_next = PCI_WAIT4_IDLE;
      end //
      
      PCI_WAIT4_IDLE: // 2
	begin
	  pci_req_out = 1'b1;
	  if (!grant_n_reg && r_irdy_in_n && r_frame_in_n) begin
	    pci_req_out = 1'b0;
	    pci_irdy_oe = 1'b1;
	    frame_out = 1'b1; //assert frame for 1 cycle
	    frame_oe = 1'b1;
	    pci_ad_oe_sm = 1'b1;
	    pci_next = PCI_WAIT4_DEV;
	  end // 
	end // case: PCI_WAIT4_GNT7
      
      
      PCI_WAIT4_DEV: begin
	pci_irdy_oe = 1'b1;
	pci_irdy_out = 1'b1;
	pci_ad_oe_sm = 1'b1;
	inc_devsel_cnt = 1'b1;	    
	if (devsel_cnt == 3'b100 && devsel_in_n) begin// devsel timeout
	  pci_irdy_out = 1'b0;
	  inc_devsel_cnt = 1'b0;
	  clr_devsel_cnt = 1'b1;
	  pci_next = PCI_IDLE;
	end else if (!devsel_in_n) begin   // devsel in time
	  clr_devsel_cnt = 1'b1;
	  inc_devsel_cnt = 1'b0;
	  if (!trdy_in_n) begin     // normal completion or disconnect
	    pci_irdy_out = 1'b0;
	    pci_ad_oe_sm = 1'b0;
	    pci_next = PCI_IDLE;
	  end else if (!stop_in_n) begin // retry
	    pci_irdy_out = 1'b0;
	    pci_ad_oe_sm = 1'b0;
	    pci_next = PCI_RETRY;
	  end //
	end else if (!stop_in_n) begin // abort
	  clr_devsel_cnt = 1'b1;
	  inc_devsel_cnt = 1'b0;
	    pci_irdy_out = 1'b0;
	  pci_ad_oe_sm = 1'b0;
	  pci_next = PCI_IDLE;
	end //
	
      end // case: PCI_WAIT4_DEV
      
      PCI_RETRY: // 4    need to kill a couple of cycles first
	pci_next = PCI_RETRY1;
      
      PCI_RETRY1: // 5
	begin
	  if (!grant_n_reg &&
	      r_irdy_in_n && r_frame_in_n) begin
	    pci_irdy_oe = 1'b1;
	    frame_out = 1'b1; //assert frame for 1 cycle
	    frame_oe = 1'b1;
	    pci_ad_oe_sm = 1'b1;
	    pci_next = PCI_WAIT4_DEV;
	  end else begin
	    pci_req_out = 1'b1;
	    pci_next = PCI_WAIT4_IDLE;
	  end //	    
	end // case: PCI_RETRY1
      
      default: pci_next = PCI_IDLE;
    endcase // case (pci_state)
  end //
  
  assign pci_ad_oe = (pci_ad_oe_sm ||
		      (!grant_n_reg && 
		       pci_req_out_n && r_irdy_in_n && r_frame_in_n &&
		       pci_parked));
  // Register state machine stuff
  
  always @ (posedge hb_clk or negedge reset_n) begin
    if (!reset_n) begin
      pci_state <= PCI_IDLE;
      frame_out_n <= 1;
      frame_oe_n <= 1;
    end else begin
      pci_state <= pci_next;
      frame_out_n <= !frame_out;
      frame_oe_n <= !(frame_oe || !frame_out_n);
    end //
  end //
  
  // here's the devsel counter
  always @(posedge hb_clk or negedge reset_n) begin
    if (!reset_n)
      devsel_cnt <= 0;
    else if (clr_devsel_cnt)
      devsel_cnt <= 0;
    else if (inc_devsel_cnt)
      devsel_cnt <= devsel_cnt + 1;
  end // always @ (posedge hb_clk or negedge reset_n)
  
endmodule // PCI_WOM
