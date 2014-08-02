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
//  Title       :  Memory Windows Control
//  File        :  hbi_mw_ctl.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
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

`timescale 1ns/10ps

  module hbi_mw_ctl
    (
     input		hb_clk,
     input		hb_soft_reset_n,
     input		frame_n,
     input		sobn_n,
     input		irdy_n,
     input [25:2]	hbi_mac,
     input [3:0]	mw_be,
     input		hb_write,
     input		cs_mem0_n,
     input		cs_mem1_n,
     input [24:0]	mw0_ctrl_reg,
     input [24:0]	mw1_ctrl_reg,
     input [3:0]	mw0_sz,
     input [3:0]	mw1_sz,
     input [25:12]	mw0_org,
     input [25:12]	mw1_org,
     input		mc_rdy,
     input		mc_done,
     input		crt_vertical_intrp_n,
     input		hbi_mwflush,
     input		cs_de_xy1_n,
     input		cs_dl_cntl,
     
     output reg	        mw_trdy,
     output reg	        mw_stop,
     output [22:0]	linear_origin,
     output reg 	mc_rw,
     output reg	        mc_req,
  
     output	        window0_busy_n,
     output	        window1_busy_n,
     output	        mw_dlp_fip,     // DLP initiated flush in progess
     output	        mw_de_fip,      // DE initiated flush in progess
     output	        clr_wc0,
     output	        clr_wc1,
     output	        ld_wc0,
     output	        ld_wc1,
     output             wcregs_addr,
     output             wcregs_we,
     output reg [2:0]   sub_buf_sel,
     output reg [3:0]	wc_be,
     output reg [3:0]	wc_be_d,
     output reg 	yuv_ycrcb,
     output reg [2:0]	mw_dp_mode,
     output reg [3:0]   read_addr,
     output reg         select_del,
     output             full
     );

  // internally used sigs
  wire [24:0] mw_ctrl;
  wire 	      wcenN;
  wire 	      md16;
  wire 	      csc_en;
  wire 	      yuv_src;
  wire [1:0]  psize;
  wire 	      def;
  wire 	      crtf;
  wire 	      rcenN;
  
  wire [3:0]  mw_sz;
  wire [25:12] mw_org;
  
  reg [4:0]    state, next_state;
  wire 	       int_mc_req;
  reg [5:2]    hbi_mac1, hbi_mac2;
  reg 	       data_xfer;
  reg 	       set_wreq, set_rreq, wreq, rreq;
  reg 	       set_wreq1;
  reg 	       set_flush_wc, flush_wc, flush_rc;
  reg 	       fresh_rc_data, reset_fresh_rc_data;
  wire 	       de_mwflush, dlp_mwflush;
  reg 	       crt_mwflush, vsync1n, vsync2n;
  reg 	       de_fip0, de_fip1, dlp_fip0, dlp_fip1;
  wire 	       read_cycle, write_cycle;
  reg 	       pcird_tag_matches, pciwr_tag_matches;
  reg [25:4]   watag;
  reg [24:6]   ratag;
  reg 	       watag_valid, load_ratag;
  reg 	       ratag_valid, set_ratag_valid, reset_ratag_valid, watag_load;
  reg 	       set_read_pending, read_pending;
  wire 	       reset_read_pending;
  reg 	       wintag_w, wintag_r;
  reg 	       mc_ldwc_sel, ldwc_sel;
  reg 	       last_slot, last_slot_wait;
  reg 	       mc_done_toggle1, mc_done_toggle2, mc_done_toggle3;
  wire 	       sync_mcdone;
  reg 	       mc_win;
  reg [24:4]   mc_addr;
  reg [24:4]   mc_addr_low;
  wire 	       frame, irdy;
  reg 	       trdy, stop, hold_pci_mw;
  wire 	       start_pci_mw, pci_mw;
  reg [1:0]    mcfp; // pointer to next entry in mc transaction fifo
  wire [1:0]   mcfp_prev, mcfp_next;
  reg [1:0]    mcfifo[1:3]; // mc transaction fifo
  reg 	       wc0_busy, wc1_busy;
  reg 	       long_reset;
  reg [1:0]    waddr_mode, next_waddr_mode;
  reg 	       last_cs_de_xy1_n, last_cs_dl_cntl;
  reg 	       ld_wc;
  reg 	       grab_mac;

  wire 	       two_cycle;       // set if we are in a 2 cycle write mode
  wire 	       select;
  
  parameter IDLE       = 5'h00,
	    WRITE      = 5'h01,
	    WAITWRITE  = 5'h02,
	    READ       = 5'h03,
	    READSTART  = 5'h04,
	    STOP       = 5'h05,
	    READ_PAUSE = 5'h06,	
	    READ_PAUSE1= 5'h07,	
	    READ_PAUSE2= 5'h08,	
	    READ_IDLE  = 5'h09,
	    WRITE_WAIT = 5'h10;
  
  parameter WADDRMODE_16 = 2'h0,
	    WADDRMODE_32 = 2'h1,
	    WADDRMODE_64 = 2'h2;

  assign    two_cycle = (mw_dp_mode == 3);
  assign    select = state[4]; // select bit straight from register
  

  /*
   * Use the memory window chip select to determine which memory window
   * is being addressed this cycle, and choose the correct memory window
   * control register.  Then, give sensible names to the bit fields.
   */
  assign mw_ctrl = cs_mem0_n ? mw1_ctrl_reg : mw0_ctrl_reg;
  assign wcenN = mw_ctrl[6];        // 6
  assign md16 = mw_ctrl[12];       // 19-7
  assign csc_en = mw_ctrl[13];     // 20-7
  always @(posedge hb_clk) yuv_ycrcb = mw_ctrl[15];  // 22-7 piped to remove crit path
  assign yuv_src = mw_ctrl[16];    // 23-7
  assign psize = mw_ctrl[20:19];   // 27-7:26-7
  assign def  = ~mw0_ctrl_reg[22] | ~mw1_ctrl_reg[22];       // 29-7
  assign crtf = ~mw0_ctrl_reg[23] | ~mw1_ctrl_reg[23];       // 30-7
  assign rcenN = mw_ctrl[24];       // 31-7

  /*
   * set the mw_dp_mode based upon mw_ctrl register bits.  This is used by
   * hbi_yuv2rgb to steer incoming data to the correct bit positions.
   */
  always @* begin
    casex ({csc_en, yuv_src, md16, psize[1:0]})
      5'b10001: begin        // yuv_422_16_555
	mw_dp_mode = 3'h1;
      end // case: 5'b1001
      5'b10101: begin        // yuv_422_16_565
	mw_dp_mode = 3'h2;
      end // case: 5'b1101
      5'b10?10: begin        // yuv_422_32
	mw_dp_mode = 3'h3;
      end // case: 5'b1?10
      5'b11001: begin        // yuv_444_16_555
	mw_dp_mode = 3'h4;
      end // case: 5'b1001
      5'b11101: begin        // yuv_444_16_565
	mw_dp_mode = 3'h5;
      end // case: 5'b1101
      5'b11?10: begin        // yuv_444_32
	mw_dp_mode = 3'h6;
      end // case: 5'b1?10
      default: begin        // direct linear
	mw_dp_mode = 3'h0;
      end // case: default
    endcase // casex ({csc_en, md16, psize[1:0]})
  end // always @ (csc_en or md16 or psize)


  always @*
    if ((hbi_mac[24:6]==ratag[24:6]) && (wintag_r==cs_mem0_n) && ratag_valid)
      pcird_tag_matches = 1'b1;
    else
      pcird_tag_matches = 1'b0;

  always @*  begin
    last_slot = 1'b0;
    pciwr_tag_matches = 1'b0;
    
    /*
     * Depending on YUV mode and pixel depth, select the following:
     * last_slot: low order address bits
     * pciwr_tag_matches: high order address bits
     */
    case ({csc_en, yuv_src, psize[1:0]})
      4'b1010: begin     // yuv_422_32
	if ((hbi_mac[25:4]==watag[25:4]) && (wintag_w==cs_mem0_n) && watag_valid)
	  pciwr_tag_matches = 1'b1;
	last_slot = &hbi_mac[3:2];
      end
      4'b1101: begin     // yuv_444_16
	if ((hbi_mac[25:6]==watag[25:6]) && (wintag_w==cs_mem0_n) && watag_valid)
	  pciwr_tag_matches = 1'b1;
	last_slot = &hbi_mac[5:2];
      end
      default: begin
	// yuv_422_16, yuv_444_32, direct linear
	if ((hbi_mac[25:5]==watag[25:5]) && (wintag_w==cs_mem0_n) && watag_valid)
	  pciwr_tag_matches = 1'b1;
	last_slot = &hbi_mac[4:2];
      end // case: default
    endcase // case ({csc_en, yuv_src, psize[1:0]})
  end // always @ (hbi_mac or watag or wintag_w or cs_mem0_n...
  
  
  /*
   * create the byte enables used by the write cache.  There are 8 byte enables,
   * to select bytes in the 64-bit data bus entering the hbi_wcregs.  The yuv
   * modes use the incoming pci byte enable for the "Y" bytes to decide if a
   * pixel should be written.  444 mode uses bit 1, 422 modes uses bits 1,3
   * Also, choose which two address bits are used steer the incoming data to
   * the correct 64-bit slot in the cache (sub_buf_sel).
   * 
   * agp: always write 8 bytes
   * pci direct linear: 64 bits, use mw[7:0]
   * pci yuv 422 16: 2 pixels = 32 bits, use mw[3],mw[1]
   * pci yuv 422 32: 2 pixels = 64 bits, use mw[3],mw[1]
   * pci yuv 444 16: 1 pixel = 16 bits, use mw[1]
   * pci yuv 444 32: 1 pixel = 32 bits, use mw[1]
   */
  always @* begin
    casex ({csc_en, yuv_src, psize[1:0]})
      4'b1001: begin     // yuv_422_16
	wc_be = {{2{mw_be[3]}},{2{mw_be[1]}}};
	wc_be_d = 4'hf;
	sub_buf_sel = hbi_mac1[4:2];
	next_waddr_mode = WADDRMODE_32;
      end
      4'b1010: begin     // yuv_422_32
	wc_be = {4{mw_be[1]}};
	wc_be_d = {4{mw_be[3]}};
	sub_buf_sel = {hbi_mac2[3:2], 1'b0};
	next_waddr_mode = WADDRMODE_32;
      end
      4'b1101: begin     // yuv_444_16
	case (hbi_mac1[2])
	  1'h0: wc_be = {2'b11, {2{mw_be[1]}}};
	  1'h1: wc_be = {{2{mw_be[1]}}, 2'b11};
	endcase
	wc_be_d = 4'hf;
	sub_buf_sel = hbi_mac1[5:3];
	next_waddr_mode = WADDRMODE_16;
      end
      default: begin     // yuv_444_32 (4'b1110), or direct linear
	wc_be_d = 4'hf;
	wc_be = mw_be[3:0];
	sub_buf_sel = hbi_mac1[4:2];
	next_waddr_mode = WADDRMODE_32;
      end
    endcase // case ({csc_en, yuv_src, psize[1:0]})
  end // always @ (csc_en or yuv_src or psize or hbi_mac1 or agp_pci_sel...


  /*
   * 
   * Cache controller state machine
   * 
   */
  assign read_cycle = (~cs_mem0_n | ~cs_mem1_n) & ~hb_write;
  assign write_cycle = (~cs_mem0_n | ~cs_mem1_n) & hb_write;
  assign frame = ~frame_n;
  assign irdy = ~irdy_n;

  always @* begin
    // assign default values to all signals to prevent latches
    mw_trdy             = 1'b0;
    mw_stop             = 1'b0;
    set_wreq            = 1'b0;
    set_rreq            = 1'b0;
    load_ratag          = 1'b0;
    reset_ratag_valid   = 1'b0;
    set_ratag_valid     = 1'b0;
    watag_load          = 1'b0;
    set_read_pending    = 1'b0;
    set_flush_wc        = 1'b0;
    reset_fresh_rc_data = 1'b0;
    grab_mac            = 1'b0;
    case (state)
      
      // wait here for a decode.
      IDLE: begin
	/*
	 * read cache flush request (no effect on next state)
	 * don't flush until posted read has completed
	 */
	if (flush_rc && !read_pending && !fresh_rc_data)
	  reset_ratag_valid = 1'b1;
	
	// Commanded write cache flush
	if (flush_wc) begin
	  if (wreq || rreq)
	    // still can't flush
	    next_state = IDLE;
	  else begin
	    set_wreq = 1'b1;
	    next_state = IDLE;
	  end // else: !if(wreq || rreq)
	end // if (flush_wc)

	// PCI write
	else if (pci_mw && write_cycle) begin
	  reset_ratag_valid = 1'b1;
	  
	  if (pciwr_tag_matches) begin // cache hit
	      next_state = WRITE;
	    mw_trdy = 1'b1;
	  end // if (tag_matches)
	  else
	    if (!watag_valid)
	      // cache has been flushed
	      if (full && !clr_wc0 && !clr_wc1) begin
		mw_stop = 1'b1;
		next_state = STOP;
	      end // if (full)
	      else begin
		mw_trdy = 1'b1;
		next_state = WRITE;
		watag_load = 1'b1;
	      end // else: !if(full)
	    else
	      // cache needs to be flushed before we can write
	      if (wreq || rreq) begin
		set_flush_wc = 1'b1;
		mw_stop = 1'b1;
		next_state = STOP;
	      end // if (wreq || rreq)
	      else
		if (full) begin
		  set_wreq = 1'b1;
		  mw_stop = 1'b1;
		  next_state = STOP;
		end
		else begin
		  set_wreq = 1'b1;
		  mw_trdy = 1'b1;
		  next_state = WRITE;
		  watag_load = 1'b1;
		end // else: !if(full)
	end // if (write_cycle)
	
	// PCI read
	else if (pci_mw && read_cycle) begin
	  if (read_pending) begin
	    mw_stop = 1'b1;
	    next_state = STOP;
	  end // if (read_pending)
	  else if (pcird_tag_matches) begin
	    next_state = READ_PAUSE1;
	     grab_mac = 1'b1;
	     //mw_trdy = 1'b1;
	  end // if (pcird_tag_matches)
	  else begin
	    // read tag does not match
	    load_ratag = 1'b1;
	    if (watag_valid) begin
	      // write cache needs to be flushed before we can read
	      if (wreq || rreq) begin
		set_flush_wc = 1'b1;
		mw_stop = 1'b1;
		next_state = STOP;
	      end // if (wreq || rreq)
	      else begin
		set_wreq = 1'b1;
		mw_stop = 1'b1;
		next_state = READSTART;
	      end // else: !if(wreq)
	    end // if (watag_valid)
	    else begin
	      mw_stop = 1'b1;
	      next_state = READSTART;
	    end // else: !if(watag_valid)
	  end // else: !if(read_pending)
	end // if (pci_mw && read_cycle)

	// NOP
	else
	  next_state = IDLE;
      end // case: IDLE

      /*
       * wait for an available buffer, throttling the PCI bus with TRDYn
       */
      WAITWRITE: begin
	if ((ld_wc) || (full && !clr_wc0 && !clr_wc1))
	  next_state = WAITWRITE;
	else begin
	  mw_trdy    = 1'b1;
	  next_state = WRITE;
	  watag_load = 1'b1;
	end
      end // case: WAIT

      /*
       * Hold stop on, for terminated transactions
       */
      STOP: begin
	if (frame) begin
	  mw_stop    = 1'b1;
	  next_state = STOP;
	end // if (frame)
	else
	  next_state = IDLE;
      end // case: STOP
      
      /*
       * Write data to the cache.  This state exits when the PCI transaction
       * completes, or when the cache is full.
       */
      WRITE: begin
	if (irdy)
	  if (!frame) begin
	    // last cycle of transaction
	    if (two_cycle) next_state = WRITE_WAIT;
	    else begin
	      next_state = IDLE;
	      //
	      watag_load = 1'b1;
	      //
	      if (wcenN)
		// flush the cache if caching disabled
		if (wreq || rreq)
		  set_flush_wc = 1'b1;
		else
		  set_wreq = 1'b1;
	    end
	  end else begin
	    if (two_cycle) next_state = WRITE_WAIT;
	    else begin
	      // this transaction is a burst
	      if (last_slot) begin
 		if (wreq || rreq) begin
		  mw_stop      = 1'b1;
		  set_flush_wc = 1'b1;
		  next_state   = STOP;
		end else if (full || (wc0_busy&&ldwc_sel) || 
			     (wc1_busy&&!ldwc_sel)) begin
		  set_wreq   = 1'b1;
		  mw_stop    = 1'b1;
		  next_state = STOP;
		end else begin
		  set_wreq   = 1'b1;
		  mw_trdy    = 1'b1;
		  next_state = WRITE;
		  watag_load = 1'b1;
		end // else: !if(full)
	      end else begin
		next_state = WRITE;
		watag_load = 1'b1;
		mw_trdy    = 1'b1;
	      end // else: !if(full)
	    end
	  end else begin
	    // wait in this state for irdy
	    next_state = WRITE;
	    watag_load = 1'b1;
	    mw_trdy    = 1'b1;
	  end // else: !if(!frame)
      end // case: WRITE

      WRITE_WAIT: begin
	if (!irdy && !frame) begin
	  // last cycle of transaction
	  next_state = IDLE;
	  watag_load = 1'b1;
	  if (wcenN)
	    // flush the cache if caching disabled
	    if (wreq || rreq)
	      set_flush_wc = 1'b1;
	    else
	      set_wreq = 1'b1;
	end else begin
	  // this transaction is a burst
	  if (last_slot_wait) begin
 	    if (wreq || rreq) begin
	      mw_stop      = 1'b1;
	      set_flush_wc = 1'b1;
	      next_state   = STOP;
	    end else if (full || (wc0_busy&&ldwc_sel) || 
			 (wc1_busy&&!ldwc_sel)) begin
	      set_wreq     = 1'b1;
	      mw_stop      = 1'b1;
	      next_state   = STOP;
	    end else begin
	      set_wreq     = 1'b1;
	      mw_trdy      = 1'b1;
	      next_state   = WRITE;
	      watag_load   = 1'b1;
	    end // else: !if(full)
	  end else begin
	    next_state     = WRITE;
	    watag_load     = 1'b1;
	    mw_trdy        = 1'b1;
	  end // else: !if(full)
	end
      end // case: WRITE
      
      /*
       * Start a read transaction
       * mw_stop must be asserted by the previous state!
       */
      READSTART : begin
	grab_mac = 1'b1;
	if (frame) begin
	  // stop not seen yet by initiator, keep sending
	  mw_stop = 1'b1;
	  next_state = READSTART;
	end
	else begin
	  if (wreq || rreq)
	    // can't send address yet
	    next_state = IDLE;
	  else begin
	    // send the address to mc, and wait until cycle completes
	    next_state       = IDLE;
	    set_rreq         = 1'b1;
	    set_read_pending = 1'b1;
	    set_ratag_valid  = 1'b1;
	  end
	end // else: !if(irdy)
      end // case: READSTART

      /*
       * Valid memory data must be in the read cache to get to this state.
       * This state exits when the PCI transaction completes, or when a
       * cache miss occurs.
       */
      READ: begin
	reset_fresh_rc_data = 1'b1;
	if (irdy)
	  if (!frame) begin
	     mw_trdy = 1'b1;
	    // last cycle of transaction
	    next_state = READ_IDLE;
	    if (rcenN || flush_rc)
	      // invalidate tag when caching disabled or when there is an
	      // unserviced flush request
	      reset_ratag_valid = 1'b1;
	  end // if (!frame)
	  else begin
	    // this transaction is a burst
	    if (!pcird_tag_matches) begin
	      // the last cached address has been reached.
	      // disconnect, and request more data from mc
	      mw_stop    = 1'b1;
	      load_ratag = 1'b1;
	      next_state = READSTART;
	    end
	    else begin
	      mw_trdy  = 1'b1;
	      //next_state = read_addr[0] ? READ_PAUSE : READ;
	      next_state = READ_PAUSE;
	    end
	  end // else: !if(!frame )
	else begin
	  // wait in this state for irdy
	  next_state = READ;
	  mw_trdy    = 1'b1;
	end // else: !if(!frame)
      end // case: READ

      READ_PAUSE: begin
	// We can enter this state at the end of a transfer, so we have to
	// check the status of frame (FB 03/20/05)
	if (irdy && !frame) begin
	  next_state = READ_IDLE;
	  if (rcenN || flush_rc)
	    // invalidate tag when caching disabled or when there is an
	    // unserviced flush request
	    reset_ratag_valid = 1'b1;
	end else 
	  next_state = READ_PAUSE2;
      end

      // One extra cycle for multicycle data
      READ_PAUSE2: next_state = READ;
      
      READ_PAUSE1: begin
	// This state is entered from the start of a read. we need to handle
	// this differently, but allow the pop to occur properly
	next_state = READ;
      end
      
      READ_IDLE: 
	if (read_cycle) next_state = READ_IDLE;
	else next_state = IDLE;
					      
      /*
       * do nothing, catch all state
       */
      default: begin
	next_state = IDLE;
      end // case: default

    endcase // case (state)
  end // always @

    
  /*
   * select lines for the read cache.  This is really just low address bits, 
   * gated by address decode to prevent flogging around too much
   */
  assign full = wc0_busy & wc1_busy;
  assign clr_wc0 = (sync_mcdone && (mcfifo[1]==2'b01) || long_reset);
  assign clr_wc1 = (sync_mcdone && (mcfifo[1]==2'b10) || long_reset);
  assign ld_wc0 = (ld_wc) & ~ldwc_sel;
  assign ld_wc1 = (ld_wc) & ldwc_sel;
  assign wcregs_addr = ldwc_sel;
  assign wcregs_we   = ld_wc;
  
  /*
   * busy status to PCI control and software.  A window is busy until a request
   * is send to the MC
   */
  assign window0_busy_n = ~((watag_valid | wreq) & ~wintag_w);
  assign window1_busy_n = ~((watag_valid | wreq) & wintag_w);

  // flush event caused by drawing engine trigger
  // falling edge of 2D trigger CS
  assign de_mwflush = hb_write & def & (~cs_de_xy1_n & last_cs_de_xy1_n); 
  /*
   * flush event caused by dlp trigger
   */
  assign dlp_mwflush =hb_write & 
    (cs_dl_cntl & ~last_cs_dl_cntl);     // rising edge of DLP trigger CS

  assign int_mc_req = mc_rdy & ((wreq & !read_pending) | rreq);

  /*
   * infer the state register, and others
   */
  always @(posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      long_reset       <= 1'b1;
      state            <= IDLE;
      hold_pci_mw      <= 1'b0;
      data_xfer        <= 1'b0;
      hbi_mac1         <= 4'b0;
      hbi_mac2         <= 4'b0;
      wc0_busy         <= 1'b0;
      wc1_busy         <= 1'b0;
      waddr_mode       <= 1'b0;
      watag            <= 22'b0;
      wintag_w         <= 1'b0;
      watag_valid      <= 1'b0;
      wreq             <= 1'b0;
      flush_wc         <= 1'b0;
      flush_rc         <= 1'b0;
      rreq             <= 1'b0;
      set_wreq1        <= 1'b0;
      ldwc_sel         <= 1'b0;
      mc_ldwc_sel      <= 1'b0;
      mc_win           <= 1'b0;
      mc_rw            <= 1'b0;
      mc_addr_low      <= 21'b0;
      ratag            <= 19'b0;
      wintag_r         <= 1'b0;
      ratag_valid      <= 1'b0;
      read_pending     <= 1'b0;
      fresh_rc_data    <= 1'b0;
      mc_done_toggle1  <= 1'b0;
      mc_done_toggle2  <= 1'b0;
      mc_done_toggle3  <= 1'b0;
      trdy             <= 1'b0;
      stop             <= 1'b0;
      ld_wc            <= 1'b0;
      vsync1n          <= 1'b0;
      vsync2n          <= 1'b0;
      crt_mwflush      <= 1'b0;
      last_cs_de_xy1_n <= 1'b0;
      last_cs_dl_cntl  <= 1'b0;
      mc_req           <= 1'b0;
      read_addr        <= 4'b0;
      select_del       <= 1'b0;
      last_slot_wait   <= 1'b0;
    end else begin

      last_slot_wait <= last_slot;
      
      select_del <= select;
      
      // Address for mw read sm
      if (grab_mac)      read_addr <= hbi_mac[5:2];
      else if (irdy && mw_trdy) read_addr <= read_addr + 2'd1;

      // Delay MC request one cycle to give MW time to write
      mc_req <= int_mc_req;

      if (!sobn_n) long_reset <= 1'b0;
      
      state <= next_state;
      hold_pci_mw <= start_pci_mw
	|| (hold_pci_mw && !(!frame && irdy && (trdy||stop)));

      data_xfer <= irdy & trdy;
      
      if (!sobn_n || data_xfer)
	hbi_mac1 <= hbi_mac[5:2];

      hbi_mac2 <= hbi_mac1;
      
      if (ld_wc0)       wc0_busy <= 1'b1;
      else if (clr_wc0)	wc0_busy <= 1'b0;

      if (ld_wc1)       wc1_busy <= 1'b1;
      else if (clr_wc1) wc1_busy <= 1'b0;
      
      if (watag_load) begin
	waddr_mode <= next_waddr_mode;
	watag <= hbi_mac[25:4];
	wintag_w <= cs_mem0_n;
      end // if (ld_wc)

      if (watag_load)               watag_valid <= 1'b1;
      else if (set_wreq1 && !mc_rw) watag_valid <= 1'b0;
      
      if (int_mc_req)    wreq <= 1'b0;
      else if (set_wreq) wreq <= 1'b1;

      if (set_flush_wc)
	flush_wc <= 1'b1;
      else if (wreq)
	flush_wc <= 1'b0;
      else if (watag_valid && 
	  (hbi_mwflush || de_mwflush || crt_mwflush || dlp_mwflush))
	flush_wc <= 1'b1;
      
      if (int_mc_req)    rreq <= 1'b0;
      else if (set_rreq) rreq <= 1'b1;
      
       // "incoming" pointer toggle for pci.
       set_wreq1 <= set_wreq;

      //toggle the "incoming" pointer after the last write
      if (set_wreq1) // toggle 1 cycle later for PCI
 	ldwc_sel <= ~ldwc_sel;

      if (set_wreq) begin
	mc_ldwc_sel <= ldwc_sel;
	mc_win <= wintag_w;
	mc_rw <= 1'b0;
	case (waddr_mode)
	  WADDRMODE_16:
	    mc_addr_low <= {watag[25:6], 1'b0};
	  WADDRMODE_64:
	    mc_addr_low <= {watag[23:4], 1'b0};
	  default:
	    mc_addr_low <= {watag[24:5], 1'b0};
	endcase // case (waddr_mode)
      end // if (set_wreq)

      if (load_ratag) begin
	ratag <= hbi_mac[24:6];
	wintag_r <= cs_mem0_n;
      end // if (load_ratag)

      if (set_rreq) begin
	mc_win <= wintag_r;
	mc_rw <= 1'b1;
	mc_addr_low <= {ratag[24:6], 2'b0};
      end // if (set_rreq)


      // read cache flush request flag
      if (reset_ratag_valid)
	flush_rc <= 1'b0;
      else if ((ratag_valid || set_ratag_valid)
	       && (hbi_mwflush || de_mwflush || dlp_mwflush))
	flush_rc <= 1'b1;

      // read cache tag valid flag
      if (set_ratag_valid)
	ratag_valid <= 1'b1;
      else if (reset_ratag_valid)
	ratag_valid <= 1'b0;

      // PCI posted read flag
      if (set_read_pending)
	read_pending <= 1'b1;
      else if (reset_read_pending)
	read_pending <= 1'b0;

      // Read cache contains fresh data flag
      if (reset_read_pending)
	fresh_rc_data <= 1'b1;
      else if (reset_fresh_rc_data)
	fresh_rc_data <= 1'b0;

      // synchronizer stages.  mc_done is from mclock domain
      mc_done_toggle1 <= mc_done;
      mc_done_toggle2 <= mc_done_toggle1;
      mc_done_toggle3 <= mc_done_toggle2;

      trdy <= mw_trdy;
      stop <= mw_stop;
      ld_wc <= (irdy & trdy | select) & write_cycle;

      // synchronizer for crt_vertical_intrp_n
      vsync1n <= crt_vertical_intrp_n;
      vsync2n <= vsync1n;
      crt_mwflush <= !vsync1n & vsync2n & crtf;

      // delays for 2D triggers
      last_cs_de_xy1_n <= cs_de_xy1_n;
      last_cs_dl_cntl <= cs_dl_cntl;
      
    end // else: !if(!hb_soft_reset_n)
  end // always @ (posedge hb_clk or negedge hb_soft_reset_n)

  assign start_pci_mw = !sobn_n && (write_cycle || read_cycle);
  assign pci_mw = start_pci_mw || hold_pci_mw;
  assign sync_mcdone = mc_done_toggle2 ^ mc_done_toggle3;

  /*
   * 2-1 mux for Memory Controller parameters which come from various
   * memory window control registers.
   */
  assign mw_sz       = mc_win ? mw1_sz       : mw0_sz;
  assign mw_org      = mc_win ? mw1_org      : mw0_org;

  /*
   * Select the address, etc from the appropriate memory window to the
   * memory controller
   */
  always @* begin
    case (mw_sz)
      4'h0: mc_addr = {mw_org[24:12], mc_addr_low[11:4]};
      4'h1: mc_addr = {mw_org[24:13], mc_addr_low[12:4]};
      4'h2: mc_addr = {mw_org[24:14], mc_addr_low[13:4]};
      4'h3: mc_addr = {mw_org[24:15], mc_addr_low[14:4]};
      4'h4: mc_addr = {mw_org[24:16], mc_addr_low[15:4]};
      4'h5: mc_addr = {mw_org[24:17], mc_addr_low[16:4]};
      4'h6: mc_addr = {mw_org[24:18], mc_addr_low[17:4]};
      4'h7: mc_addr = {mw_org[24:19], mc_addr_low[18:4]};
      4'h8: mc_addr = {mw_org[24:20], mc_addr_low[19:4]};
      4'h9: mc_addr = {mw_org[24:21], mc_addr_low[20:4]};
      4'ha: mc_addr = {mw_org[24:22], mc_addr_low[21:4]};
      4'hb: mc_addr = {mw_org[24:23], mc_addr_low[22:4]};
      4'hc: mc_addr = {mw_org[24:24], mc_addr_low[23:4]};
      4'hd: mc_addr = mc_addr_low[24:4];
      4'he: mc_addr = mc_addr_low[24:4];
      4'hf: mc_addr = mc_addr_low[24:4];
    endcase 
  end 

  /*
   * linear origin is just an alias for mc_addr
   */
  assign linear_origin = {2'b00, mc_addr};
  
  /*
   * Memory controller transaction fifo (queue).  Requests "push" a transaction
   * on the top of the fifo.  Dones "pop" a transaction off the bottom
   * of the fifo.
   */
  always @(posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      mcfp      <= 2'b0;
      mcfifo[1] <= 2'b0;
      mcfifo[2] <= 2'b0;
      mcfifo[3] <= 2'b0;
    end // if (!hb_soft_reset_n)
    else begin
      case ({mc_req, sync_mcdone})
	2'h0: begin // nop
	  mcfp <= mcfp;
	end
	2'h1: begin // memory cycle finished
	  mcfifo[1] <= mcfifo[2];
	  mcfifo[2] <= mcfifo[3];
	  mcfifo[3] <= 2'b0;
	  /*
	   * don't decrement if mcfp==0.  Safety net if spurious mc_done's
	   * happen while mc is initializing
	   */
	  if (mcfp)
	    mcfp <= mcfp_prev;
	end // case: 2'h1
	2'h2: begin // memory cycle requested
	  mcfp <= mcfp_next;
	  if (mc_rw)
	    // read cycle
	    mcfifo[mcfp_next] <= 2'b11;
	  else
	    if (mc_ldwc_sel)
	      // write from cache 1
	      mcfifo[mcfp_next] <= 2'b10;
	    else
	      // write from cache 0
	      mcfifo[mcfp_next] <= 2'b01;
	end // case: 2'h2
	2'h3: begin // simult. request and done
	  mcfp <= mcfp;
	  mcfifo[1] <= mcfifo[2];
	  mcfifo[2] <= mcfifo[3];
	  if (mc_rw)
	    // read cycle
	    mcfifo[mcfp] <= 2'b11;
	  else
	    if (mc_ldwc_sel)
	      // write from cache 1
	      mcfifo[mcfp] <= 2'b10;
	    else
	      // write from cache 0
	      mcfifo[mcfp] <= 2'b01;
	end // case: 2'h3
      endcase // case ({mc_reg, sync_mcdone})
    end // else: !if(!hb_soft_reset_n)
  end // always @ (posedge hb_clk or negedge hb_soft_reset_n)

  assign mcfp_next = mcfp + 1'b1;
  assign mcfp_prev = mcfp - 1'b1;
  // reset flag when memory read cycle completes
  assign reset_read_pending = sync_mcdone & (&mcfifo[1]);

  /*
   * drawing engine "flush in progress" indicator
   */
  always @(posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      de_fip0 <= 1'b0;
      de_fip1 <= 1'b0;
    end // if (!hb_soft_reset_n)
    else begin
      if (clr_wc0)
	de_fip0 <= 1'b0;
      else if (de_mwflush && wc0_busy)
	de_fip0 <= 1'b1;

      if (clr_wc1)
	de_fip1 <= 1'b0;
      else if (de_mwflush && wc1_busy)
	de_fip1 <= 1'b1;
    end // else: !if(!hb_soft_reset_n)
  end // always @ (posedge hb_clk or negedge hb_soft_reset_n)

  assign mw_de_fip = de_fip0 | de_fip1;
  
  
  /*
   * display list processor "flush in progress" indicator
   */
  
  always @(posedge hb_clk or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      dlp_fip0 <= 1'b0;
      dlp_fip1 <= 1'b0;
    end // if (!hb_soft_reset_n)
    else begin
      if (clr_wc0)
	dlp_fip0 <= 1'b0;
      else if (dlp_mwflush && wc0_busy)
	dlp_fip0 <= 1'b1;

      if (clr_wc1)
	dlp_fip1 <= 1'b0;
      else if (dlp_mwflush && wc1_busy)
	dlp_fip1 <= 1'b1;
    end // else: !if(!hb_soft_reset_n)
  end // always @ (posedge hb_clk or negedge hb_soft_reset_n)

  assign mw_dlp_fip = dlp_fip0 | dlp_fip1;
  
endmodule // HBI_MW_CTL

