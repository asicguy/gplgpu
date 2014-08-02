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
//  Title       :  Host Bus Control
//  File        :  hbi_control.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This I4 module contain all of the logic associated with PCI Bus
//   control signals.  It contains code extracted from several I1 - I3
//   HBI modules.  Lots has been rewritten for synthesis, clarity,
//   performance or bug related issues.  
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
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps

module hbi_control
 (
  input		hb_clk,               // host bus clock
  input		hb_system_reset_n,    // host PCI reset (from reset pin). 
  input         vga_mclock,           // VGA Memory Controller Clock
  input		soft_reset_p,         // reset from reg_block
  input		dac_soft_reset,       // reset from reg_block
  input		frame_n,              // PCI input
  input		irdy_n,               // PCI input  
  input		cs_blkbird_regs_n,    // all chip registers
  input		cs_blkbird_n,         // all chip registers
  input		cs_draw_stop_n,       // all DE registers except DLP
  input		cs_draw_a_regs_n,     // all DE registers
  input		cs_draw_a_regs_un,    // all DE registers
  input		cs_vga_shadow_n,      // dac vga registers
  input		cs_vga_space_n,       // vga non-3c6 space
  input		cs_3c6_block_n,       // vga/dac palette, peripheral
  input		cs_eprom_n,           // eprom, peripheral
  input		cs_xyw_a_n,           // cs XY mem window for drawing engine
  input		cs_de_xy1_n,          /* cs de kick off reg. Must issue 
				       * disconnect */
  input		cs_soft_switchs_un,   // soft switches decode
  input		cs_sw_write_n,        // soft switches decode, used for writes
  input         cs_mem0_n,            // Chip select memory windows 0
  input         cs_mem1_n,            // Chip select memory windows 1
  input		vga_palette_snoop_n,  // 1= palette snoop is on
  input		perph_mem_rdy ,       /* mc can accept request from 
				       * peripheral rdy sm */
  input		perph_mem_last,       /* memory controller done for the rd or 
				       * wr. this is sync'd to hb_clk and 
				       * becomes done
                                       * caution: this will be syncr. when jack
                                       * completes his MC changes.   */
  input		vga_mem_rdy,          // mc can accept request from vga_rdy sm
  input		vga_mem_last,         /* memory last cycle signal for the rd 
				       * or wr cycle this is sync'd to hb_clk
				       * and becomes done */
  input		busy_a_dout,          // busy status for DE
  input		cs_dereg_f8_n,        // dlp register decode 
  input		dlp_retry,            /* indicates both dlp register sets are 
				       * full force a PCI retry if DLP 
				       * registers are accessed */
  input [1:0]	hb_laddr,             // this used to be "addr mode" 
  input [3:0]	hb_lcmd,              // this used to be "cycle_type and rdwr" 

  input [31:2]	hb_ad_bus,
  input		mw_trdy,
  input		mw_stop,
  input		pci_ad_oe,
  input		cs_window_regs_un,
  input		cs_blk_config_regs_un,
  input		mw0_busy_n, mw1_busy_n,
  input		cs_dl_cntl,           // dl_cntrl register decode
  
  output reg	sobn_n,               // "start of burstn_n" falling edge frame det.
  output reg	trdy_n,               // PCI trdy_n to outside world
  output reg	stop_n,               // PCI stop_n to outside world
  output reg	devsel_n,             // PCI devsel_n to outside world
  output reg 	hb_soft_reset_n,      // reset to chip and HBI
  output reg	dac_reset_n,          // reset to DAC
  output reg	sys_reset_n,          // reset used only in HBI
  output reg	hb_cycle_done_n,      /* indicates a normally comlpeted or
				       * disconnected transaction.   
                                       * Used by the read cache and DE */
  output reg	ctrl_oe_n,            // trdy & stop oe  
  output reg	devsel_oe_n,          // devsel oe
  output reg	ad_oe32_n,            // ad output enable
  output reg	c_be_oe32_n,
  
  output reg	parity32_oe_n,        // parity oe 
  output reg	perph_mem_req,        //peripheral memory request signal
  output reg	perph_data_strobe_n,  //peripheral host data latch strobe for

  output reg	vga_mem_req,          //VGA space  memory request signal
  output reg	vga_data_strobe_n,    //host data latch strobe for VGA space write

  output	addr_strobe_n,    //address bus latch enable.
  output	data_strobe_n,    //data bus latch enable.

  output  	wr_en_hb,            //write enable, internal hb 
  output	wr_en_p1,            //write enable,  port 1
  output	wr_en_p2,            //write enable,  port 2

  output [31:2]	hbi_addr_in_hb,      //hbi address incrementer, internal hb
  output [13:2]	hbi_addr_in_p1,      //hbi address incrementer, port 1
  output [8:2]	hbi_addr_in_p2,      //hbi address incrementer, port 2

  output reg [25:2]	hbi_mac,          //hbi master's_address_count

  output	any_trdy_async, // used to load the all_data out reg

  output reg	hbi_mwflush  // Flush mw when wr to mw_ctrl, or the flush register.
  );
  
  reg		reg_irdy_n;   // registered irdy_n pin		
  
  /* params for periph trdy state machine */
  parameter	IDLE_PERF=0, WAIT4_RDY=1, WAIT4_DONE=2,
		DAC_WR_SNOOP=3, SNOOP_WAIT_MC_RDY=4, PERPH_FRAME_H=5;
  
  /* params for the vga ready state machine */
  parameter	VGA_IDLE=0, VGA_WAIT4_IRDY=1, VGA_FRAME_H=2, VGA_WAIT4_RIP_IRDY=3;
  
  /* params for the blk ready state machine */
  parameter	IDLE_TRDY=0, STATE_WR0=1, STATE_WR1=2, STATE_RD0=3,
	         STATE_RD1=4, STATE_RD2=5, WAIT4_FRAME_H=6, WAIT4_IRDY_L=7;

   
   
/* internal regs and wires */      
  reg		burst_trdy_n; //
  wire		burst_trdy_async;



  reg		reset_sync1;
  reg [2:0]	current_state_perf, next_state_perf;
  reg [2:0]	current_state_trdy, next_state_trdy;
  reg [1:0]	current_state_vga, next_state_vga;   
  reg		perph_rdy_async_n, perph_mem_req_p;
  reg		latched_mc_done_perph;  
  reg		vga_shadow_snoop_active;
  reg		vga_ready_async_n,  latched_mc_done_vga, vga_mem_done_s1;
  reg		vga_mem_done_s2, vga_mem_done_s3;
  reg		vga_mem_request_p;
  reg		blk_ready_async_n;
  reg		trdy_sync;
  reg		host_rd_done_sync;
  reg		async_stop_n;
  reg		vga_rip_set, vga_rip_clr, vga_rip;
  reg		vga_mem_rd_done;
  reg		perph_stop;
  reg		vga_space_stop;  
  reg		shadow_snoop_set;   
  reg		cs_xyw_a_n_sync1;
  reg		frame_sync_n;   
  reg		write_incr;
  reg		hb_ad_oe_hold;
  reg		sys_reset_d1_n, sys_reset_d2_n,
		 sys_reset_d3_n;	
  reg		wr_en;
  reg [31:2]	hbi_addr_in;
  reg 		lock0;

  wire		hb_ad_oe_set;    
  wire		trdy_async_cache;
  wire		async_hb_done_n;  
  wire		hb_write;
  wire		vga_mem_rd_done_p;

  assign hb_write = hb_lcmd[0]; /* 1 = write, 0 = read */
  assign wr_en_hb = wr_en;
  assign wr_en_p1 = wr_en;
  assign wr_en_p2 = wr_en;
  assign hbi_addr_in_hb = hbi_addr_in;
  assign hbi_addr_in_p1 = hbi_addr_in[13:2];
  assign hbi_addr_in_p2 = hbi_addr_in[8:2];
  
  //
  //   First let's take care of reset
  //

  /* synchronizers */   
  always @ (posedge hb_clk) begin      
    reset_sync1         <= hb_system_reset_n;
    sys_reset_n         <= reset_sync1;
    sys_reset_d1_n      <= sys_reset_n;
    sys_reset_d2_n      <= sys_reset_d1_n;
    sys_reset_d3_n      <= sys_reset_d2_n;
    // These resets used to be combinational
    hb_soft_reset_n     <= !(soft_reset_p || !sys_reset_d3_n || dac_soft_reset);
    dac_reset_n         <= !(!reset_sync1 || dac_soft_reset);
    
  end

  /* A registered version for things that don't burst */  
  always @ (posedge hb_clk) reg_irdy_n <= irdy_n;
  
  //
  //   this stuff came out of the old hbi_instage_ctrl.v
  //   devsel and control oe
  //
  always @ (posedge hb_clk)
    if (frame_n && !irdy_n && (!trdy_n || !stop_n)) hb_cycle_done_n <= 1'b0;
    else                                            hb_cycle_done_n <= 1'b1;

  always @(posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n) begin
      ctrl_oe_n   <= 1'b1;	    
      devsel_oe_n <= 1'b1;	
      devsel_n    <= 1'b1;
    end else if (!sobn_n &&
		 ((!cs_3c6_block_n && !vga_palette_snoop_n) ||	       
		  //READS OR WRITES TO DAC WHEN SNOOP IS DISABLED
		  !cs_vga_shadow_n || !cs_eprom_n || !cs_soft_switchs_un ||
		  !cs_blkbird_n || !cs_vga_space_n)) begin
      ctrl_oe_n   <= 1'b0;	    
      devsel_oe_n <= 1'b0; 
      devsel_n    <= 1'b0;
// FB 03/19/05 - This is corrected to SH..... When did this change????
//    end else if (frame_n && !irdy_n && (!trdy_n || !async_stop_n)) begin
    end else if (frame_n && !irdy_n && (!trdy_n || !stop_n)) begin
      ctrl_oe_n   <= 1'b0;	    
      devsel_oe_n <= 1'b0; 
      devsel_n    <= 1'b1;
    end else if (!hb_cycle_done_n) begin
      ctrl_oe_n   <= 1'b1;	    
      devsel_oe_n <= 1'b1; 
      devsel_n    <= 1'b1;
    end // else: !if(!async_hb_done_n)
  end // always @ (posedge hb_clk or negedge sys_reset_n)

  // Data and parity driver control -- FIXME ???
  always @ (posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      ad_oe32_n <= 1'b1;
    end else if (hb_ad_oe_set || (hb_ad_oe_hold && async_hb_done_n) ||
		 pci_ad_oe) begin
      ad_oe32_n <= 1'b0;
    end else begin
      ad_oe32_n <= 1'b1;
    end
  end
  
  always @ (posedge hb_clk) begin
    parity32_oe_n <= ad_oe32_n;
  end
  
  assign hb_ad_oe_set = ~sobn_n & ~hb_write &
			(~cs_vga_space_n | ~cs_eprom_n | ~cs_blkbird_n |
			 ~cs_vga_shadow_n | (~cs_3c6_block_n && 
					     !vga_palette_snoop_n));

  always @ (posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n)      hb_ad_oe_hold <= 1'b0;
    else if (hb_ad_oe_set)     hb_ad_oe_hold <= 1'b1;
    else if (!async_hb_done_n) hb_ad_oe_hold <= 1'b0;
  end

  // Command Byte Enables Control signal
  always @ (posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      c_be_oe32_n <= 1'b1;
    end else if (pci_ad_oe) begin
      c_be_oe32_n <= 1'b0;
    end else begin
      c_be_oe32_n <= 1'b1;
    end
  end

  //
  //   this stuff came out of the old eprom_dac_rdy_sm.v
  //   state machine for peripheral requests
  //
  always @* begin
    perph_rdy_async_n   = 1'b1;
    perph_mem_req_p     = 1'b0; 
    perph_data_strobe_n = 1'b1; 
    shadow_snoop_set    = 1'b0;
    perph_stop          = 1'b0;
    next_state_perf     = current_state_perf; //default stay put
    
    case (current_state_perf)
      IDLE_PERF: begin
	if (!sobn_n &&
	    (!cs_eprom_n || (!cs_soft_switchs_un && hb_write) ||
	     !cs_vga_shadow_n || !cs_3c6_block_n)) begin
	  if (vga_shadow_snoop_active) begin
	    perph_stop = 1'b1;
	    next_state_perf = PERPH_FRAME_H;
	  end else if (!cs_3c6_block_n && !vga_palette_snoop_n)	
	    next_state_perf = WAIT4_RDY;
	  else if (!cs_3c6_block_n && vga_palette_snoop_n && hb_write) begin
	    /* no dev_sel generated here, snooped write */
	    shadow_snoop_set = 1'b1;
	    next_state_perf = DAC_WR_SNOOP;
	  end else if (cs_3c6_block_n) 
	    next_state_perf = WAIT4_RDY;
	end //
      end // case: IDLE
      
      WAIT4_RDY: begin    
	if (!reg_irdy_n && perph_mem_rdy) begin
	  perph_data_strobe_n  = 1'b0;//latching the PCI data & address
	  perph_mem_req_p      = 1'b1; //issue memory request
	  next_state_perf      = WAIT4_DONE;
	end
      end
      
      WAIT4_DONE: begin
	if (perph_mem_last) begin 
	  perph_rdy_async_n  = 1'b0;
	  if (frame_n) next_state_perf = IDLE_PERF;
	  else begin // burst so disconnect w/data
	    perph_stop = 1'b1;
	    next_state_perf = PERPH_FRAME_H;
	  end // else: !if(frame_n)
	end
      end
      
      DAC_WR_SNOOP: begin
	if (!reg_irdy_n) begin
	  // data ready for client so lets run with it,
          // I3 and before waited here for trdy          
	  perph_data_strobe_n  = 1'b0;//latching the PCI data & address
	  next_state_perf     = SNOOP_WAIT_MC_RDY;
	end
      end // case: DAC_WR_SNOOP
      
      SNOOP_WAIT_MC_RDY: begin
	if (perph_mem_rdy) begin // MC is rdy to accept request
	  perph_mem_req_p = 1'b1; //issue memory request
	  next_state_perf = IDLE_PERF;
	end
      end
      
      PERPH_FRAME_H: begin
	if (frame_n) next_state_perf = IDLE_PERF;
	else         perph_stop = 1'b1;
      end // case: PERPH_FRAME_H
      
      default: next_state_perf = IDLE_PERF;
    endcase
  end
  
  /******************************************************/ 
  
  always @(posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      current_state_perf      <= IDLE_PERF;
      perph_mem_req           <= 1'b0;
      vga_shadow_snoop_active <= 1'b0;
    end else begin
      current_state_perf <= next_state_perf;
      perph_mem_req <= perph_mem_req_p;
      if (perph_mem_last)
	vga_shadow_snoop_active <= 1'b0;
      else if (shadow_snoop_set)
	vga_shadow_snoop_active <= 1'b1;
    end    
  end

  //
  // this stuff came out of the old vga_rdy_sm.v
  // state machine for vga (non 3c6) requests
  //
  always @* begin
    vga_ready_async_n = 1'b1;
    vga_mem_request_p = 1'b0;
    vga_data_strobe_n = 1'b1;
    vga_rip_set       = 1'b0;
    vga_rip_clr       = 1'b0;
    vga_space_stop    = 1'b0;
    next_state_vga    = current_state_vga;
     
    case (current_state_vga)
      
      VGA_IDLE: begin
	if (!sobn_n && !cs_vga_space_n) begin
	  if (!vga_mem_rdy) begin //retry no cycle started
	    vga_space_stop = 1'b1; 
	    next_state_vga = VGA_FRAME_H;
	  end else if (!hb_write) begin
	    if (vga_rip) begin
	      if (vga_mem_rd_done) begin
		vga_rip_clr = 1'b1;
		next_state_vga = VGA_WAIT4_RIP_IRDY;
	      end else begin //retry, read data not ready yet
		vga_space_stop = 1'b1; 
		next_state_vga = VGA_FRAME_H;
	      end
	    end else // start a new read
	      next_state_vga = VGA_WAIT4_IRDY;
	  end else // its a write
	    next_state_vga = VGA_WAIT4_IRDY;
	end 
      end // case: VGA_IDLE

      VGA_WAIT4_IRDY: begin //1
	if (!reg_irdy_n) begin
	  vga_data_strobe_n = 1'b0;
	  vga_mem_request_p = 1'b1; //issue memory request
	  if (hb_write) begin
	    vga_ready_async_n = 1'b0; // disconnect w/data
	    vga_space_stop = 1'b1;
	    next_state_vga = VGA_FRAME_H;
	  end else begin // READ
	    vga_rip_set = 1'b1;
	    vga_space_stop = 1'b1; // retry until the data is ready
	    next_state_vga = VGA_FRAME_H;
	  end
	end
      end // case: VGA_WAIT4_IRDY

      VGA_FRAME_H: begin //2
	if (frame_n) begin
	  vga_space_stop = 1'b0;
	  next_state_vga = VGA_IDLE;
	end else
	  vga_space_stop = 1'b1;
      end // case: WAIT4_FRAME_H
   
      VGA_WAIT4_RIP_IRDY: begin //3
	if (!reg_irdy_n) begin
	  vga_ready_async_n = 1'b0; //revb
	  vga_space_stop = 1'b1;
	  next_state_vga = VGA_FRAME_H;
	end
      end // case: VGA_WAIT4_RTRY_IRDY
    endcase
  end
 
  /************* synchronous stuff for the vga rdy state machine ***********/ 
  always @ (posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n ) begin
      current_state_vga <= VGA_IDLE;
      vga_mem_req   <= 1'b0;
    end else begin
      current_state_vga <= next_state_vga;
      vga_mem_req   <= vga_mem_request_p;
    end // else: !if(!hb_soft_reset_n )
  end // always @ (posedge hb_clk or negedge hb_soft_reset_n)
   

  //
  // GENERATE vga request MEMORY DONE SIGNAL
  //
  always @ (posedge vga_mclock or negedge hb_soft_reset_n) begin
    if(!hb_soft_reset_n)   latched_mc_done_vga <= 1'b0;
    else if (vga_mem_last) latched_mc_done_vga <= !latched_mc_done_vga;
  end
  
  always @ (posedge hb_clk or negedge hb_soft_reset_n) begin
    if(!hb_soft_reset_n)        vga_mem_rd_done <= 1'b0;
    else if (vga_rip_clr)       vga_mem_rd_done <= 1'b0;
    else if (vga_mem_rd_done_p) vga_mem_rd_done <= 1'b1;
  end // always @ (posedge hb_clk)

  always @ (posedge hb_clk) begin
    vga_mem_done_s1 <= latched_mc_done_vga;
    vga_mem_done_s2 <= vga_mem_done_s1;
    vga_mem_done_s3 <= vga_mem_done_s2;
  end // always @ (posedge hb_clk or)
   
  assign vga_mem_rd_done_p = (vga_mem_done_s3 ^ vga_mem_done_s2);

  always @(posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) vga_rip <= 1'b0;
    else if (vga_rip_clr) vga_rip <= 1'b0;
    else if (vga_rip_set) vga_rip <= 1'b1;
  end // always @ (posedge hb_clk or negedge hb_soft_reset_n)

  /*************************************************************************/
  /* I'm not sure both of these flavors are needed but I'm leaving them 
   * alone */
  assign async_hb_done_n = !(frame_n && !irdy_n && (!trdy_n || !stop_n));
   
  /****************************************************************************
   STATE MACHINE TO GENERATE  trdy and stop 
   for things other than peripherals and vga
   ***************************************************************************/
  always @* begin
    blk_ready_async_n = 1'b1;
    async_stop_n = 1'b1;
    if (frame_n && !irdy_n && !trdy_n) // host bus cycle completed)
       next_state_trdy = IDLE_TRDY;
    else begin
      next_state_trdy = current_state_trdy;
	  
      case (current_state_trdy)
	IDLE_TRDY: begin   
	  if (!sobn_n) begin
	    if (hb_write) begin			   
	      if ((!cs_dereg_f8_n && (dlp_retry)) ||
		  (!cs_draw_stop_n && (busy_a_dout)) ||
		  (!cs_window_regs_un &&  // mw0  rbase_w	
		   (((hbi_addr_in[7:2] >= 6'h00 && hbi_addr_in[7:2] < 6'h0a
		      && !mw0_busy_n) ||	// mw1  rbase_w			    
		     (hbi_addr_in[7:2] >= 6'h0a && hbi_addr_in[7:2] < 6'h14
		      && !mw1_busy_n)))) ||
		  (!cs_blk_config_regs_un && // mw1 config space
		   (hbi_addr_in[7:2] >= 6'h10 && hbi_addr_in[7:2] < 6'h1a
		    && !mw1_busy_n))) begin // retry
		async_stop_n = 1'b0; 
		next_state_trdy = WAIT4_FRAME_H;
	      end 
	      // disconnect w/data 
	      else if (!cs_de_xy1_n || cs_dl_cntl) begin 
		async_stop_n = 1'b0; 
		blk_ready_async_n = 1'b0;
		if (!irdy_n)
		  next_state_trdy = WAIT4_FRAME_H;
		else
		  next_state_trdy = WAIT4_IRDY_L;
	      end  
	      else if (!cs_xyw_a_n || (!cs_blkbird_regs_n && cs_sw_write_n))
	      begin // start of a normal write
		blk_ready_async_n = 1'b0;
		next_state_trdy = STATE_WR0;
	      end 
	    end //
	    else if (!cs_xyw_a_n || !cs_blkbird_regs_n) begin// reads
	      next_state_trdy = STATE_RD0;
	    end
	  end //
	end // case: IDLE
	
	STATE_WR0: begin
	  blk_ready_async_n = 1'b0;
	  if (!irdy_n) begin
	    if (((!frame_n && !trdy_n) &&
		 (hb_laddr[1:0] != 2'b00  ||//burst to reserved sequence
		  hb_lcmd[3:1] == 3'b001)))  //burst to IO space
	    begin
	      blk_ready_async_n = 1'b1;// cause disc wo/data
	      async_stop_n = 1'b0;
	      next_state_trdy = WAIT4_FRAME_H;
	    end
	    // things that should cause disc w/data
	    else if (!cs_de_xy1_n || cs_dl_cntl) begin    
	      async_stop_n = 1'b0; 
	      blk_ready_async_n = 1'b1;
	      next_state_trdy = WAIT4_FRAME_H;
	    end else  
	      blk_ready_async_n = 1'b0;
	  end // if (!irdy_n)
	end // case: STATE_WR0

	STATE_WR1: begin
	  blk_ready_async_n = 1'b0;
	  next_state_trdy = STATE_WR0;
	end
	
	STATE_RD0: begin
	  if  (!irdy_n) begin
	    blk_ready_async_n = 1'b0;
	    if (!frame_n &&
		(hb_laddr[1:0] != 2'b00  || //burst to reserved sequence
		 hb_lcmd[3:1] == 3'b001))   //burst to IO space
	    begin			
	      async_stop_n = 1'b0;
	      next_state_trdy = WAIT4_FRAME_H;
	    end else
	      next_state_trdy = STATE_RD1;
	  end //
	end // case: STATE_RD0
	
	STATE_RD1: begin
	  if (!irdy_n)
	    next_state_trdy = STATE_RD2;
	  else
	    blk_ready_async_n = 1'b0;
	end // case: STATE_RD1
	
	STATE_RD2: begin  // All reads except MWs take 2 cycles
	  next_state_trdy = STATE_RD1;
	  blk_ready_async_n = 1'b0;
	end // case: STATE_RD2
	
	WAIT4_FRAME_H: begin
	  if (frame_n) begin
	    async_stop_n = 1'b1;
	    next_state_trdy = IDLE_TRDY;
	  end else
	    async_stop_n = 1'b0;
	end // case: WAIT4_FRAME_H
	    
	WAIT4_IRDY_L: begin		  
	  if (!irdy_n)
	    next_state_trdy = IDLE_TRDY;
	  else begin
	    async_stop_n = 1'b0; 
	    blk_ready_async_n = 1'b0;
	  end //
	end // case: WAIT4_IRDY_L
	
	default: next_state_trdy = IDLE_TRDY;
      endcase
    end //
  end //
  
  /***********************************************************************/  
   always @(posedge hb_clk or negedge sys_reset_n) begin
     if (!sys_reset_n ) current_state_trdy <= IDLE_TRDY;
     else 		current_state_trdy <= next_state_trdy;
   end   
  
  always @(posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n)       
      stop_n <= 1'b1;
    else begin      
      if (!async_stop_n || vga_space_stop || perph_stop || mw_stop)
	stop_n <= 1'b0;
      else
	stop_n <= 1'b1;
    end //
  end //
  
  //
  // GENERATE READY 
  //
  assign any_trdy_async = (!blk_ready_async_n || !perph_rdy_async_n ||
			   !vga_ready_async_n || mw_trdy);

  always @(posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n)
      trdy_n <= 1'b1;
    else if (any_trdy_async)
      trdy_n <= 1'b0;
    else
      trdy_n <= 1'b1;
  end

  // Make a special trdy for those that can burst to incr the address cntr
  // blk & mw can burst
  assign burst_trdy_async = (!blk_ready_async_n || mw_trdy); 

  always @(posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n)
      burst_trdy_n <= 1'b1;
    else if (burst_trdy_async)
      burst_trdy_n <= 1'b0;
    else
      burst_trdy_n <= 1'b1;
  end
  
  /****************************************************************************
   GENERATE ADDRESS STROBE
   ***************************************************************************/
  //one stage synchronization of frame signal
  always @ (posedge hb_clk) frame_sync_n <= frame_n;

  //one stage synchronization of address strobe signal
  assign addr_strobe_n = !(!frame_n && frame_sync_n);

  always @ (posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n)
      sobn_n <= 1'b1;
    else
      sobn_n <= addr_strobe_n;
   
  /***************************************************************************
   GENERATE WRITE DATA STROBE
   
   NOTE: WRITE DATA STROBE IS VALID ONLY WHEN ANY BLACKBIRD RESOURCE IS BEING
   ADDRESSED, THUS WRITE DATA STROBE IS NOT VALID WHEN THE EPROM OR DAC IS
   ADDRESSED, WITH THE EXEPTION OF WRITING TO THE SOFT REGISTER WHERE THE WRITE
   STROBE WOULD BE GENERATED TO LATCH THE DATA IN THE INTERNAL SOFT SWITCH
   REGISTER FOR READ BACK.
   ***************************************************************************/
  assign data_strobe_n = !(!irdy_n && hb_write && !trdy_n && 
                           (!cs_blkbird_n || !cs_soft_switchs_un));  

  /****** write_enable for the world ***********/
  always @ (posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n) 
      wr_en <= 1'b0;
    else
      wr_en <=  !data_strobe_n;
  end //

  /****************************************************************************
   the address used internal incrementer
   ***************************************************************************/
  always @ (posedge hb_clk or negedge sys_reset_n)  begin   
    if (!sys_reset_n)
      write_incr <= 1'b0;
    else if (!irdy_n && !burst_trdy_n && hb_write)
      write_incr <= 1'b1;
    else
      write_incr <= 1'b0;
  end // always @ (posedge hb_clk )
  
  always @ (posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n)
      hbi_addr_in <= 30'b0;
    else if (!addr_strobe_n)
      hbi_addr_in <= hb_ad_bus[31:2];
    else if ((!hb_write && 
	      ((burst_trdy_async && burst_trdy_n) || // for reads incr. when out
	       (!burst_trdy_n && !irdy_n && burst_trdy_async))) // data latch is loaded
	     || (write_incr))
      hbi_addr_in <= hbi_addr_in + 1'b1;
  end // always @ (posedge hb_clk )

  /****************************************************************************
   * the address incrementer that reflects the masters address count
   * this is needed to disconnect properly during burst writes through de_xy1.
   * Also used by memory windows.
   ***************************************************************************/
  always @ (posedge hb_clk or negedge sys_reset_n) begin       
    if (!sys_reset_n) hbi_mac <= 24'b0;
    else if ((hb_write && !trdy_n && !irdy_n)
	     || (!hb_write && ((burst_trdy_async && burst_trdy_n) 
			       || (!burst_trdy_n && !irdy_n && burst_trdy_async))))
      hbi_mac <= hbi_mac + 1'b1;
    else if (!addr_strobe_n)
      hbi_mac <= hb_ad_bus[25:2]; // master's_address_count
  end // always @ (posedge hb_clk )
   
  /*****************************
   * The hbi_lwflush er'
   ****************************/
  always @ (posedge hb_clk or negedge sys_reset_n) begin       
    if (!sys_reset_n) hbi_mwflush <= 1'b0;
    else if (
	     (
	      (wr_en || !async_stop_n) &&   // write or retry
	      (!cs_window_regs_un &&
	       (hbi_addr_in[7:2] >= 6'h00 &&    // mw0,1 rbase_w 00-4c
                hbi_addr_in[7:2] < 6'h14)) || 
	      (!cs_blk_config_regs_un &&
	       hbi_addr_in[7:2] >= 6'h10 && hbi_addr_in[7:2] < 6'h1a)) //40-64
	     // ||	// mw1 cnfg space
	     /* (wr_en && hbi_addr_in[7:2] == 6'h15) */ 
	     ) // write mw flush trig reg  
      hbi_mwflush <= 1'b1; 
    else
      hbi_mwflush <= 1'b0; 
  end //

endmodule 

