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
//  Title       :  
//  File        :  
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
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
//
///////////////////////////////////////////////////////////////////////////////
/*
 * Usage notes:
 * 
 * IRDY# control:
 * Master inititated wait states (delay from FRAME# active to IRDY# active
 * are controlled in a number of ways.  The "header.v" defines PRDY1, PRDY2,
 * PRDY3, and RAND set the default behavior.  If none of these are defined,
 * no waits are inserted by the rw_tasks.  The globals "irdy_delay" and 
 * "irdy_random" can be used to control wait state behavior "on-the-fly".
 * When irdy_random is non-zero, each PCI data phase uses the next entry
 * in the irdy_pattern table to determine the number of wait states.  When 
 * irdy_random is zero, the number of waits is determined by the global 
 * irdy_delay.  The valid range for irdy_delay is 0-7 (three bits).  irdy_delay
 * and irdy_random may be set at any time during a simulation.
 */

`define WDTIMER 1000

`define MAXDEVSEL 8

`ifdef MAXRETRY
`else
`define MAXRETRY 200
`endif

`ifdef PCI64
`else
 `define PCI64 0
`endif

`define MAX_PCI_BURST_COUNT 40
// We'll change MAX_PCI_BURST_COUNT to 64 once we're sure this works.

reg [35:0] pci_cmd_list [0:63];
reg [31:0]  pci_burst_start_address;
reg [31:0]  pci_burst_current_address;
integer pci_cmd_list_index;
reg rwtPAR, rwtPAR64;
reg rwtPARen, rwtPARen1, rwtPAR64en, rwtPAR64en1;
integer irdy_random;
reg [2:0]    irdy_delay; 
reg [1:0]    irdy_pattern [0:127];    
reg [6:0] irdy_pattern_index;  
integer Tinval;
integer Tval;

initial begin

  //PCI timing
  Tinval = Thld;
  Tval = hclk-Tsu;

`ifdef PRDY1
  irdy_delay= 1;
`else
`ifdef PRDY2
  irdy_delay= 2;
`else
`ifdef PRDY3
  irdy_delay= 3;
`else
  irdy_delay= 0;
`endif
`endif
`endif

`ifdef RAND
  irdy_random = 1;
`else
  irdy_random = 0;
`endif

  irdy_pattern_index = 0;
  irdy_pattern[0]   = 2'h0;
  irdy_pattern[1]   = 2'h0;
  irdy_pattern[2]   = 2'h0;
  irdy_pattern[3]   = 2'h0;
  irdy_pattern[4]   = 2'h0;
  irdy_pattern[5]   = 2'h0;
  irdy_pattern[6]   = 2'h0;
  irdy_pattern[7]   = 2'h0;
  irdy_pattern[8]   = 2'h0;
  irdy_pattern[9]   = 2'h1;
  irdy_pattern[10]  = 2'h1;
  irdy_pattern[11]  = 2'h1;
  irdy_pattern[12]  = 2'h1;
  irdy_pattern[13]  = 2'h1;
  irdy_pattern[14]  = 2'h1;
  irdy_pattern[15]  = 2'h1;
  irdy_pattern[16]  = 2'h1;
  irdy_pattern[17]  = 2'h1;
  irdy_pattern[18]  = 2'h2;
  irdy_pattern[19]  = 2'h2;
  irdy_pattern[20]  = 2'h2;
  irdy_pattern[21]  = 2'h2;
  irdy_pattern[22]  = 2'h2;
  irdy_pattern[23]  = 2'h3;
  irdy_pattern[24]  = 2'h3;
  irdy_pattern[25]  = 2'h3;
  irdy_pattern[26]  = 2'h3;
  irdy_pattern[27]  = 2'h3;
  irdy_pattern[28]  = 2'h0;
  irdy_pattern[29]  = 2'h0;
  irdy_pattern[30]  = 2'h1;
  irdy_pattern[31]  = 2'h1;
  irdy_pattern[32]  = 2'h2;
  irdy_pattern[33]  = 2'h2;
  irdy_pattern[34]  = 2'h3;
  irdy_pattern[35]  = 2'h3;
  irdy_pattern[36]  = 2'h2;
  irdy_pattern[37]  = 2'h1;
  irdy_pattern[38]  = 2'h0;
  irdy_pattern[39]  = 2'h1;
  irdy_pattern[40]  = 2'h0;
  irdy_pattern[41]  = 2'h1;
  irdy_pattern[42]  = 2'h0;
  irdy_pattern[43]  = 2'h1;
  irdy_pattern[44]  = 2'h0;
  irdy_pattern[45]  = 2'h1;
  irdy_pattern[46]  = 2'h0;
  irdy_pattern[47]  = 2'h1;
  irdy_pattern[48]  = 2'h0;
  irdy_pattern[49]  = 2'h2;
  irdy_pattern[50]  = 2'h0;
  irdy_pattern[51]  = 2'h2;
  irdy_pattern[52]  = 2'h0;
  irdy_pattern[53]  = 2'h2;
  irdy_pattern[54]  = 2'h0;
  irdy_pattern[55]  = 2'h3;
  irdy_pattern[56]  = 2'h0;
  irdy_pattern[57]  = 2'h2;
  irdy_pattern[58]  = 2'h0;
  irdy_pattern[59]  = 2'h1;
  irdy_pattern[60]  = 2'h2;
  irdy_pattern[61]  = 2'h1;
  irdy_pattern[62]  = 2'h2;
  irdy_pattern[63]  = 2'h1;
  irdy_pattern[64]  = 2'h2;
  irdy_pattern[65]  = 2'h3;
  irdy_pattern[66]  = 2'h1;
  irdy_pattern[67]  = 2'h2;
  irdy_pattern[68]  = 2'h3;
  irdy_pattern[69]  = 2'h1;
  irdy_pattern[70]  = 2'h2;
  irdy_pattern[71]  = 2'h3;
  irdy_pattern[72]  = 2'h1;
  irdy_pattern[73]  = 2'h2;
  irdy_pattern[74]  = 2'h3;
  irdy_pattern[75]  = 2'h0;
  irdy_pattern[76]  = 2'h1;
  irdy_pattern[77]  = 2'h0;
  irdy_pattern[78]  = 2'h2;
  irdy_pattern[79]  = 2'h0;
  irdy_pattern[80]  = 2'h3;
  irdy_pattern[81]  = 2'h0;
  irdy_pattern[82]  = 2'h0;
  irdy_pattern[83]  = 2'h0;
  irdy_pattern[84]  = 2'h0;
  irdy_pattern[85]  = 2'h1;
  irdy_pattern[86]  = 2'h1;
  irdy_pattern[87]  = 2'h1;
  irdy_pattern[88]  = 2'h0;
  irdy_pattern[89]  = 2'h2;
  irdy_pattern[90]  = 2'h2;
  irdy_pattern[91]  = 2'h0;
  irdy_pattern[92]  = 2'h0;
  irdy_pattern[93]  = 2'h0;
  irdy_pattern[94]  = 2'h3;
  irdy_pattern[95]  = 2'h1;
  irdy_pattern[96]  = 2'h0;
  irdy_pattern[97]  = 2'h0;
  irdy_pattern[98]  = 2'h2;
  irdy_pattern[99]  = 2'h0;
  irdy_pattern[100] = 2'h0;
  irdy_pattern[101] = 2'h0;
  irdy_pattern[102] = 2'h0;
  irdy_pattern[103] = 2'h0;
  irdy_pattern[104] = 2'h1;
  irdy_pattern[105] = 2'h1;
  irdy_pattern[106] = 2'h1;
  irdy_pattern[107] = 2'h0;
  irdy_pattern[108] = 2'h1;
  irdy_pattern[109] = 2'h0;
  irdy_pattern[110] = 2'h0;
  irdy_pattern[111] = 2'h0;
  irdy_pattern[112] = 2'h3;
  irdy_pattern[113] = 2'h3;
  irdy_pattern[114] = 2'h0;
  irdy_pattern[115] = 2'h0;
  irdy_pattern[116] = 2'h3;
  irdy_pattern[117] = 2'h0;
  irdy_pattern[118] = 2'h2;
  irdy_pattern[119] = 2'h1;
  irdy_pattern[120] = 2'h1;
  irdy_pattern[121] = 2'h0;
  irdy_pattern[122] = 2'h0;
  irdy_pattern[123] = 2'h0;
  irdy_pattern[124] = 2'h0;
  irdy_pattern[125] = 2'h1;
  irdy_pattern[126] = 2'h2;
  irdy_pattern[127] = 2'h1;
end // initial begin
  

/*
 * pci_write(host_cycle_type, address, count, mode):
 * 
 * Low level PCI write task.  This task is called by mov_dw and mov_burst,
 * which act as wrappers around this task.  The global memory, pci_cmd_list,
 * is used to pass the data to be written to this task.
 * This task is now also called by pci_burst_end.
 */
task pci_write;
   
  input [3:0]  host_cycle_type; // config, io, or mem write
  input [31:0] address;         // first address of transaction
  input [29:0] count;           // burst size
  input [1:0]  mode;            // 0=inc, 1=burst, 2=fbtb ,3=res
   

  integer      trans_count;
  integer      devsel_count;
  integer      trdy_count;
  integer      irdy_count;
  integer      burst_count;
  integer      data_phase_done;
  integer      terminated;
  integer      fbtb;
  integer      trdy_timer;
  integer      initial_data_phase;
   
  reg [8:0]    retry_counter;
  reg [35:0]   tmp_pci_cmd;
  reg [35:0]   tmp_pci_cmd_1;
  reg [7:0]    tmp_be;
  reg [63:0]   tmp_data;
    reg first_xfer;
    reg disable_64;

  begin

    if (disable_64 != 1) disable_64 = 0;
    
    case (mw0_size)
      2'b00: mw0_mask = 11'h0;
      2'b01: mw0_mask = 11'h1;
      2'b10: mw0_mask = 11'h3;
      2'b11: mw0_mask = 11'h7;
    endcase
    case (mw1_size)
      2'b00: mw1_mask = 11'h0;
      2'b01: mw1_mask = 11'h1;
      2'b10: mw1_mask = 11'h3;
      2'b11: mw1_mask = 11'h7;
    endcase
    case (aw_size)
      0: aw_mask = 20'h1;
      1: aw_mask = 20'h3;
      2: aw_mask = 20'h7;
      3: aw_mask = 20'hF;
      4: aw_mask = 20'h1F;
      5: aw_mask = 20'h3F;
      6: aw_mask = 20'h7F;
      7: aw_mask = 20'hFF;
      8: aw_mask = 20'h1FF;
      9: aw_mask = 20'h3FF;
      10: aw_mask = 20'h7FF;
      11: aw_mask = 20'hFFF;
      default: aw_mask = 20'h1;
    endcase // case(aw_size)

    /*
     * Make sure the command is a write command
     */
    if (host_cycle_type[0] != 1) begin
      $display("Error! task pci_write(%h,%h,%h)", host_cycle_type, address, count);
      $display("       PCI test master received a read command in a write task");
      $stop;
    end // if (host_cycle_type[0] != 0)
      
    /*
     * Initialize some counters used for error checking
     */
    retry_count = 0;
    trans_count = 0;
    fbtb = 0;
    @(posedge HCLK);

    /*
     * Outermost loop handles retries and target aborts.  Master loops here
     * until all data is sent, or retry count is exceeded, or target abort.
     */
    begin : retry_loop
      while (trans_count < count) begin
	/*
	 * wait for grant
	 */
	if (!GNT_RWTn) begin
	  if (fbtb) begin
	  // we still have the bus, so just continue
	  end // if (fbtb)
	  else
	    REQ_RWTn <= #Tval 0;
	end
	else begin
 	  while (!(!GNT_RWTn && FRAMEn && PRDYn)) begin
 	    REQ_RWTn <= #Tval 0;
	    framee_n <= #Tval 'bz;
	    req64_n  <= #Tval 'bz;
	    hb_ad_bus <= #Tval 64'bz;
	    byte_ens <= #Tval 'bz;
	    rwtPARen <= #Tval 0;
	    rwtPAR64en <= #Tval 0;
 	    @(posedge HCLK);
	    prdyy_n <= #Tval 'bz;
 	  end // while (!(!GNT_RWTn && FRAMEn && PRDYn))
	end // else: !if(fbtb && !GNT_RWTn)
	
	// We will do a 64 bit transfer on any memory transaction. However, the
	// FPGA should not respond to all of these... We'll check that below.
	// If we have have only 1 piece of data, or two pieces aligned to
	// 64 bits, then we will unly request using 32 bit transactions. This
	// saves us from frame issues in the testbench. 
	if (`PCI64 && ((mode != 0) && (host_cycle_type == MEM_RD || 
				      host_cycle_type == MEM_WR ||
				      host_cycle_type == MEM_RD_MULTI || 
				      host_cycle_type == MEM_RD_LINE ||
				      host_cycle_type == MEM_WR_INV) &&
	    ~((count == 1) || (~address[2] && count == 2) ||
	      ((trans_count == count - 1) || 
	       ~address[2] && trans_count == count - 2)))) 
	  enable_64 = ~disable_64;
	else 
	  enable_64 = 1'b0;

	disable_64 = 1'b0; // reset 64 bit disable
	/*
	 * address phase.  Drive address, command, IDSEL (if config cycle)
	 * and FRAME#.  Negate REQ# if this is the last transaction.
	 * Drive AD16 as IDSEL, for AGP support.
	 */
	if (host_cycle_type==CONFIG_WR) begin
`ifdef PCIX
	  hb_ad_bus <= #Tinval 64'bx;
`endif
`ifdef PCIX
	  IDSEL <= #Tinval 'bx;
`endif
	  hb_ad_bus <= #Tval {32'b0, 16'h1, address[15:0]};
	  IDSEL  <= #Tval 1;
	end // if (host_cycle_type==CONFIG_WR)
	else begin
`ifdef PCIX
	  hb_ad_bus <= #Tinval 64'bx;
`endif
	  if (~enable_64) hb_ad_bus <= #Tval {31'b0, address};
	  else            hb_ad_bus <= #Tval {31'b0, address[31:3], 3'b0};
	end // else: !if(host_cycle_type==CONFIG_WR)
`ifdef PCIX
	byte_ens <= #Tinval 'bx;
`endif
	byte_ens <= #Tval {4'hF, host_cycle_type};
	rwtPARen <= #Tval 1;
	rwtPAR64en <= #Tval 1;
	    
`ifdef PCIX
	framee_n  <= #Tinval 'bx;
	req64_n   <= #Tval 'bx;
`endif
	framee_n  <= #Tval 0;
	req64_n   <= #Tval ~enable_64;
	devsel_count = 0;
	if (mode==2'h2) begin
	  if (trans_count == count-1)
	    REQ_RWTn <= #Tval 1;
	end
	else
	  REQ_RWTn <= #Tval 1;
	    
	/*
	 * data phases
	 */
	@ (posedge HCLK);
	IDSEL <= #Tval 'bz;
	initial_data_phase = 1;
	burst_count = 0;
	terminated = 0;
	transmit_64 = enable_64; // First pass, make them equal
	xfer_odd = 0;
	retransmit = 0;
	first_xfer = 1;
	begin : burst_loop	       
	  while ((trans_count < count) && !terminated) begin
	    trdy_count = 0;
	    // The data that gets sent depends on the wrapper task that
	    // called this one.
	    case (mode)
	      2'h0: begin // mov_dw
		tmp_pci_cmd = pci_cmd_list[0];
		tmp_be = {4'hF, tmp_pci_cmd[35:32]};
		//tmp_data = {32'b0, tmp_pci_cmd[31:0] + trans_count};
		tmp_data = {32'b0, tmp_pci_cmd[31:0]};
		inc_trans = 1;
		last_xfer = (trans_count == count - 1);
	      end // case: 2'h0
	      2'h1: begin // mov_burst
		tmp_pci_cmd = pci_cmd_list[trans_count];
		tmp_pci_cmd_1 = pci_cmd_list[trans_count+1];

		if (retransmit || ~enable_64 || ~transmit_64 || (trans_count == count - 1))
		begin
		  tmp_be = {4'hF, tmp_pci_cmd[35:32]};
		  tmp_data = {32'h0, tmp_pci_cmd[31:0]};
		  inc_trans = 1;
		  last_xfer = (trans_count == count - 1);
		  retransmit = 0;
		end else begin
		  if (address[2] && first_xfer) begin
		    // We started on an odd address.
		    tmp_be = {tmp_pci_cmd[35:32], 4'hF};
		    tmp_data = {tmp_pci_cmd[31:0], 32'hFEED_BEEF};
		    inc_trans = 1;
		    last_xfer = (trans_count == count - 1);
		    xfer_odd = 1;
		  end else begin
		    inc_trans = 2;
		    tmp_be = {tmp_pci_cmd_1[35:32], tmp_pci_cmd[35:32]};
		    tmp_data = {tmp_pci_cmd_1[31:0], tmp_pci_cmd[31:0]};
		    last_xfer = (trans_count == count - 2);
		  end
		end
	      end // case: 2'h1
	      2'h2: begin //mov_fbtb
		tmp_pci_cmd = pci_cmd_list[2*trans_count+1];
		tmp_pci_cmd_1 = pci_cmd_list[trans_count+1];

		if (retransmit || ~enable_64 || ~transmit_64 || (trans_count == count - 1))
		begin
		  tmp_be = {4'hF, tmp_pci_cmd[35:32]};
		  tmp_data = {32'h0, tmp_pci_cmd[31:0]};
		  inc_trans = 1;
		  last_xfer = (trans_count == count - 1);
		  retransmit = 0;
		end else begin
		  if (address[2] && first_xfer) begin
		    // We started on an odd address.
		    tmp_be = {tmp_pci_cmd[35:32], 4'hF};
		    tmp_data = {tmp_pci_cmd[31:0], 32'hFEED_BEEF};
		    inc_trans = 1;
		    last_xfer = (trans_count == count - 1);
		    xfer_odd = 1;
		  end else begin
		    inc_trans = 2;
		    tmp_be = {tmp_pci_cmd_1[35:32], tmp_pci_cmd[35:32]};
		    tmp_data = {tmp_pci_cmd_1[31:0], tmp_pci_cmd[31:0]};
		    last_xfer = (trans_count == count - 2);
		  end
		end
		fbtb = 1;
	      end // case: 2'h2
	      2'h3: begin // reserved
		$display ("task pci_write: coding error, invalid mode");
		$stop;
	      end // case: 2'h2,2'h3
	    endcase // case (mode)
	    
`ifdef PCIX
	    byte_ens <= #Tinval 'bx;
`endif
	    byte_ens <= #Tval tmp_be;
	    rwtPARen <= #Tval 1;
	    // Loop here to handle delay in asserting IRDY#

	    if (irdy_random) begin
	      irdy_delay=irdy_pattern[irdy_pattern_index];
	      irdy_pattern_index = irdy_pattern_index + 1;
	    end // if (irdy_random)
	      
	    for (irdy_count=0; irdy_count<irdy_delay; irdy_count = irdy_count + 1) begin
	      // negate IRDY# if it was already on (from a previous data phase)
	      if (!prdyy_n) begin
`ifdef PCIX
		prdyy_n <= #Tinval 'bx;
`endif
		prdyy_n <= #Tval 1;
	      end // if (!prdyy_n)
`ifdef PCIX
	      hb_ad_bus <= #Tinval 64'bx;
`endif
	      @ (posedge HCLK);
	      if (DEVSELn!=0)
		devsel_count = devsel_count + 1;
	      if (TRDYn!=0)
		trdy_count = trdy_count + 1;
	    end // for (irdy_count=0; irdy_count<irdy_delay; irdy_count = irdy_count + 1)
	    
	    // Assert IRDY# and drive data.  Also, check if STOP# asserted.
	    // If so, negate FRAME# (Fig's 9-4,9-7,9-9 in "PCI System
	    // Architecture, Third Edition")  FRAME# is also negated if
	    // this is the last piece of data in the transaction. Finally,
	    // if we are running in mode 2 (fbtb), FRAME# is negated
	    // because every transaction is single cycle.
	    if (PRDYn!='b0) begin
`ifdef PCIX
	      prdyy_n <= #Tinval 'bx;
`endif
	    end // if (PRDYn!='b0)
	    prdyy_n <= #Tval 0;
`ifdef PCIX
	    hb_ad_bus <= #Tinval 64'bx;
`endif
	    hb_ad_bus <= #Tval tmp_data;

	    if (last_xfer || !STOPn || (mode==2)) begin
`ifdef PCIX
	      framee_n  <= #Tinval 'bx;
	      req64_n   <= #Tinval 'bx;
`endif
	      framee_n  <= #Tval 1;
	      req64_n   <= #Tval 1;
	    end // if ((trans_count == count-1) || !STOPn)
	    // Negate REQ# if this is the last transaction
	    if (trans_count >= count-1)
	      REQ_RWTn  <= #Tval 1;
	    
	    // Loop until target signals end of data phase, or until
	    // a time out is detected
	    data_phase_done = 0;
	    while (!data_phase_done) begin
	      @ (posedge HCLK);
	      // increment devsel and trdy watchdog timers
	      if (DEVSELn!=0)
		devsel_count = devsel_count + 1;
	      if (TRDYn!=0)
		trdy_count = trdy_count + 1;

	      if (TRDYn==0 && ~ACK64n) begin
		//address[2] = 1'b0;
		first_xfer = 1'b0;
	      end
	      
	      // Normal end of data phase.  Target accepted data
	      if (DEVSELn==0 && TRDYn==0 && STOPn==1) begin
		 if ((rwt_log != 0)&& rwt_write_log) $fdisplay (rwt_log, "PCI WRITE: address=%h data=%h",address, AD);
		retry_count = 0;
		data_phase_done=1;

		// check if we are transfering 64 bits
		if (~ACK64n) begin
		  transmit_64 = 1'b1;
		  retransmit = 0;
		  xfer_odd = 0;
		  if (~enable_64 || 
		      ~((address[31:13] == rbase_a[31:13]) || // DE registers
			((address[31:22] | mw0_mask) == 
			 (rbase_mw0[31:22] | mw0_mask)) || // Memory Windows 0
			((address[31:22] | mw1_mask) == 
			 (rbase_mw1[31:22] | mw1_mask)) || // Memory Windows 1
			((address[31:12] | aw_mask) == 
			 (address[31:12] | aw_mask)))) begin  // DE cache
		    $display ("task pci_write: ACK64n recieved with no REQ64n");
		    $stop;
		  end
		  
		end else begin
		  transmit_64 = 1'b0;
		  if (xfer_odd) retransmit = 1;
		  xfer_odd = 0;
		end
		
		if (!retransmit) begin
		  trans_count = trans_count + (transmit_64 ? inc_trans : 1);
		  burst_count = burst_count + 1;
		end
		
		if (trans_count >= count) begin
		  framee_n <= #Tval 'bz;
		  req64_n  <= #Tval 'bz;
`ifdef PCIX
		  prdyy_n <= #Tinval 'bx;
`endif
		  prdyy_n <= #Tval 1;
`ifdef PCIX
		  hb_ad_bus <= #Tinval 64'hx;
`endif
		  hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		  byte_ens <= #Tinval 8'hx;
`endif
		  byte_ens <= #Tval 8'hz;
		  prdyy_n <= #(hclk+Tval) 'bz;
		  rwtPARen <= #Tval 0;
		end // if (trans_count == count)
		else begin
		  if (mode==2) begin //fbtb
		    tmp_pci_cmd = pci_cmd_list[2*trans_count];
		    address = tmp_pci_cmd[31:0];
`ifdef PCIX
		    prdyy_n <= #Tinval 'bx;
`endif
		    prdyy_n <= #Tval 1;
		    terminated = 1;
		  end // if (fbtb)
		  else
		    address = (transmit_64) ? address + (4 * inc_trans) :
			      address + 4;
		end // else: !if(trans_count == count)
	      end // if (DEVSELn==0 && TRDYn==0 && STOPn==1)
	      
	      // Retry or Disconnect w/o data
	      else if (DEVSELn==0 && TRDYn==1 && STOPn==0) begin
`ifdef RWTASK_DEBUG
		if (burst_count == 0)
		  $display ("PCI RETRY (write) at address %h, time: %d",address, $time);
		else
		  $display ("PCI DISCONNECT w/o data (write) at address %h, time: %d",address, $time);
`endif
		// must stop requesting the bus
		REQ_RWTn <= #Tval 1;
		// ensure that FRAME# is negated before negating IRDY#,
		// to properly terminate the transaction.
		if (!framee_n) begin
`ifdef PCIX
		  framee_n <= #Tinval 'bx;
		  req64_n  <= #Tval 'bx;
`endif
		  framee_n <= #Tval 1;
		  req64_n  <= #Tval 1;
		  @ (posedge HCLK);
		end // if (!framee_n)
		retry_count = retry_count + 1;
`ifdef PCIX
		prdyy_n <= #Tinval 'bx;
`endif
		prdyy_n <= #Tval 1;
`ifdef PCIX
		hb_ad_bus <= #Tinval 64'hx;
`endif
		hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		byte_ens <= #Tinval 8'hx;
`endif
		byte_ens <= #Tval 8'hz;
		framee_n <= #Tval 'bz;
		req64_n <= #Tval 'bz;
		prdyy_n <= #(hclk+Tval) 'bz;
		data_phase_done = 1;
		terminated = 1;
		rwtPARen <= #Tval 0;
		@ (posedge HCLK);
		@ (posedge HCLK);
	      end // if (DEVSELn==0 && TRDYn==1 && STOPn==0)
	      
	      // Disconnect with data
	      else if (DEVSELn==0 && TRDYn==0 && STOPn==0) begin
`ifdef RWTASK_DEBUG
		$display ("PCI DISCONNECT with data (write) at address %h, time: %d",address, $time);
`endif
		 if ((rwt_log != 0)&& rwt_write_log) $fdisplay (rwt_log, "PCI WRITE: address=%h data=%h",address, AD);

		//if (~xfer_odd & transmit_64) address[2] = 1'b0;

		// stop requesting if not on last data phase
		if (!framee_n) REQ_RWTn <= #Tval 1;

		// If we are xferring jsut the upper DWORD and we get a
		// Disconnect with data and the host does not respond to a 64
		// bit xfer, then we keep the trans_count the same so we
		// can retransmit just the upper data.
		trans_count = (transmit_64 & xfer_odd & ACK64n) ?
			      trans_count :
			      trans_count + (transmit_64 ? inc_trans : 1);

		// If the disconnect was a 64 bit transfer, then keep enable_64
		// set, otherwise complete the transfer with 32 bit xfers
		enable_64 = ~ACK64n;
		// inc the address, or fetch the next one
		if (fbtb==0)
		  casex ({transmit_64, xfer_odd})
		    2'b0x: address = address + 4;
		    2'b10: address = address + (4* inc_trans);
		    2'b11: address = address;
		  endcase
		else if (trans_count < count) begin
		  if (transmit_64 && xfer_odd || ~transmit_64) 
		    tmp_pci_cmd = pci_cmd_list[2*trans_count];
		  else
		    tmp_pci_cmd = pci_cmd_list[2*trans_count+1];
		  address = tmp_pci_cmd[31:0];
		end // else: !if(!fbtb)
		
		// ensure that FRAME# is negated before negating IRDY#,
		// to properly terminate the transaction.
		if (!framee_n) begin
`ifdef PCIX
		  framee_n <= #Tinval 'bx;
		  req64_n  <= #Tval 'bx;
`endif
		  framee_n <= #Tval 1;
		  req64_n  <= #Tval 1;
		  @ (posedge HCLK);
		end // if (!framee_n)
`ifdef PCIX
		prdyy_n <= #Tinval 'bx;
`endif
		prdyy_n <= #Tval 1;
`ifdef PCIX
		hb_ad_bus <= #Tinval 64'hx;
`endif
		hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		byte_ens <= #Tinval 8'hx;
`endif
		byte_ens <= #Tval 8'hz;
		framee_n <= #Tval 'bz;
		req64_n <= #Tval 'bz;
		prdyy_n <= #(hclk+Tval) 'bz;
		data_phase_done = 1;
		terminated = 1;
		rwtPARen <= #Tval 0;
		disable_64 = 1'b1;
	      end // if (DEVSELn==0 && TRDYn==0 && STOPn==0)
	      
	      // Target abort:  stop entire transaction
	      else if (DEVSELn==1 && STOPn==0) begin
		// (should check to make sure DEVSEL had been asserted
		// at some time.)
		$display ("PCI Target Abort (write) at address %h, time: %d",address, $time);
		// stop requesting the bus
		REQ_RWTn <= #Tval 1;
		if (!framee_n) begin
`ifdef PCIX
		  framee_n  <= #Tinval 'bx;
		  req64_n   <= #Tval 'bx;
`endif
		  framee_n  <= #Tval 1;
		  req64_n   <= #Tval 1;
		end // if (!framee_n)
		@ (posedge HCLK);
`ifdef PCIX
		prdyy_n <= #Tinval 'bx;
`endif
		prdyy_n <= #Tval 1;
`ifdef PCIX
		hb_ad_bus <= #Tinval 64'hx;
`endif
		hb_ad_bus <= #Tval 64'hz;
`ifdef PCIX
		byte_ens <= #Tinval 8'hx;
`endif
		byte_ens <= #Tval 8'hz;
		rwtPARen <= #Tval 0;
		@ (posedge HCLK);
		prdyy_n <= #Tval 'bz;
		data_phase_done = 1;
		trans_count = count;
	      end // if (DEVSELn==1 && STOPn==0)
	      
	      // No response yet.  check watchdog timers for expiration
	      else begin
		if (trdy_count >= `WDTIMER) begin
		  $display ("PCI info: TRDY# timeout (write) at address %h, time: %d",address, $time);
		  $stop;
		end // if (trdy_timer >= WDTIMER)
		if (retry_count >= `MAXRETRY) begin
		  $display ("PCI info: max RETRY count exceeded (write) at address %h, time: %d",address, $time);
		  $stop;
		end // if (retry_count >= 'MAXRETRY)
		if (devsel_count >= `MAXDEVSEL) begin
		  $display ("PCI info: no DEVSEL asserted (write) at address %h, time= %d", address, $time);
		  REQ_RWTn <= #Tval 1;
		  if (!framee_n) begin
`ifdef PCIX
		    framee_n  <= #Tinval 'bx;
		    req64_n   <= #Tval 'bx;
`endif
		    framee_n  <= #Tval 1;	
		    req64_n   <= #Tval 1;
		  end // if (!framee_n)
		  @ (posedge HCLK);
		  prdyy_n <= #Tval 1;
		  byte_ens <= #Tval 8'hz;
		  framee_n <= #Tval 'bz;
		  req64_n  <= #Tval 'bz;
		  rwtPARen <= #Tval 0;
		  @ (posedge HCLK);
		  prdyy_n <= #Tval 'bz;
		  disable retry_loop;
		end // if (devsel_count >= 'MAXDEVSEL)
	      end 
	    end // while (!data_phase_done)
	  end // while (trans_count < count)
	end // block: burst_loop
	initial_data_phase = 0;
      end // while (trans_count < count)
    end // block: retry_loop
  end
  endtask //pci_write
  

/*
 * mov_dw:  write dwords with incrementing data
 */
task mov_dw;
   
   input [3:0]	host_cycle_type;
   input [31:0]	address;
   input [31:0]	data;
   input [3:0]	byte_enables;
   input [29:0]	NO_OF_BEATS; //number of beats in one burst cycle (max=1G beats)

   begin

      // Are there any burst_data requests pending?
      if (pci_cmd_list_index > 0)
	 pci_burst_end;	// This will call pci_write

      pci_cmd_list[0] = {byte_enables, data};
      pci_write(host_cycle_type, address, NO_OF_BEATS, 0);
   end
endtask // mov_dw


/*
 * mov_burst:  write up to 8 dwords of data in a burst
 */
task mov_burst;
   
   input [3:0]	host_cycle_type;
   input [31:0]	address;
   input [3:0]	byte_enables;
   input [3:0]	NO_OF_BEATS;
   input [31:0]	data1;
   input [31:0]	data2;
   input [31:0]	data3;
   input [31:0]	data4;
   input [31:0]	data5;
   input [31:0]	data6;
   input [31:0]	data7;
   input [31:0]	data8;
 
   begin
      // Are there any burst_data requests pending?
      if (pci_cmd_list_index > 0)
	 pci_burst_end;	// This will call pci_write

      pci_cmd_list[0] = {byte_enables, data1};
      pci_cmd_list[1] = {byte_enables, data2};
      pci_cmd_list[2] = {byte_enables, data3};
      pci_cmd_list[3] = {byte_enables, data4};
      pci_cmd_list[4] = {byte_enables, data5};
      pci_cmd_list[5] = {byte_enables, data6};
      pci_cmd_list[6] = {byte_enables, data7};
      pci_cmd_list[7] = {byte_enables, data8};
      pci_write(host_cycle_type, address, NO_OF_BEATS, 1);
   end
   endtask //mov_burst
   
   
/*
 * mov_fbtb:  write dwords with fast back to back
 */
task mov_fbtb;
   
   input [3:0] host_cycle_type;
   input [3:0] count; // max count depends on pci_cmd_list size declared above

   reg [31:0]  address;
   reg [35:0]  tmp;
   
   begin
      // Are there any burst_data requests pending?
      if (pci_cmd_list_index > 0)
	 pci_burst_end;	// This will call pci_write

      tmp = pci_cmd_list[0];
      address = tmp[31:0];
      pci_write(host_cycle_type, address, count, 2);
   end
endtask // mov_fbtb


/*
 * pci_burst_end:  Wrap up the data sent by pci_burst_data
 */
task pci_burst_end;
   integer i;
   reg [35:0]  pci_cmd;

   begin
      if (pci_cmd_list_index > 0)
	 begin
`ifdef DISPLAY_PCI_BURST
	    $display ("PCI BURST START: address=%h time=%d",pci_burst_start_address, $time);
	    for (i = 0; i < pci_cmd_list_index; i = i + 1)
	       begin
		  pci_cmd = pci_cmd_list[i];
		  $display("PCI BURST DATA:  %h %h", pci_cmd[31:0], pci_cmd[35:32]);
	       end
`endif // ifdef DISPLAY_PCI_BURST
            pci_write(MEM_WR, pci_burst_start_address, pci_cmd_list_index, 1);
`ifdef DISPLAY_PCI_BURST
	    $display ("PCI BURST DONE");
`endif // ifdef DISPLAY_PCI_BURST
	 end
      pci_cmd_list_index = 0;
   end
endtask //pci_burst_end

/*
 * pci_burst_data:  write dwords of data in a burst
 *		 When finished, call pci_burst_end
 *		 Include write combining
 *		 If new address is out of range, flush and start new burst.
 */
task pci_burst_data;
   
   input [31:0]	address;
   input [3:0]	byte_enables;
   input [31:0]	data;
 
   begin
      if (pci_cmd_list_index == 0)
	 begin
	    // Start a new burst list
	    pci_burst_start_address = address;
            pci_cmd_list[0] = {byte_enables, data};
	    pci_burst_current_address = address + 4;
	    pci_cmd_list_index = 1;
	 end
      else if (address == pci_burst_current_address)
	 begin
	    // Add one entry to the burst list
            pci_cmd_list[pci_cmd_list_index] = {byte_enables, data};
	    pci_burst_current_address = pci_burst_current_address + 4;
	    pci_cmd_list_index = pci_cmd_list_index + 1;
	 end
      else if ((address == pci_burst_current_address + 4) &&
		(pci_cmd_list_index < (`MAX_PCI_BURST_COUNT - 1)))
	 begin
	    // Write combining - Add a dummy write
            pci_cmd_list[pci_cmd_list_index    ] = 36'hF_0000_0000;
            pci_cmd_list[pci_cmd_list_index + 1] = {byte_enables, data};
	    pci_burst_current_address = pci_burst_current_address + 8;
	    pci_cmd_list_index = pci_cmd_list_index + 2;
	 end
      else if ((address == pci_burst_current_address + 8) &&
		(pci_cmd_list_index < (`MAX_PCI_BURST_COUNT - 2)))
	 begin
	    // Write combining - Add two dummy writes
            pci_cmd_list[pci_cmd_list_index    ] = 36'hF_0000_0000;
            pci_cmd_list[pci_cmd_list_index + 1] = 36'hF_0000_0000;
            pci_cmd_list[pci_cmd_list_index + 2] = {byte_enables, data};
	    pci_burst_current_address = pci_burst_current_address + 12;
	    pci_cmd_list_index = pci_cmd_list_index + 3;
	 end
      else
	 begin
	    // We're writing to a new address, so flush the old list
	    pci_burst_end;
	    // Now start a new burst list
	    pci_burst_start_address = address;
            pci_cmd_list[0] = {byte_enables, data};
	    pci_burst_current_address = address + 4;
	    pci_cmd_list_index = 1;
	 end

      // Now check if the burst list is full
      if (pci_cmd_list_index >= `MAX_PCI_BURST_COUNT)
	 pci_burst_end;
   end
endtask //pci_burst_data

   

  /*
   * Task: pci_read
   * 
   * Inputs:
   * HCLK       PCI CLK
   * DEVSELn    PCI DEVSEL#
   * TRDYn      PCI TRDY#
   * STOPn      PCI STOP#
   * AD         PCI AD
   * 
   * Outputs:
   * framee_n   PCI FRAME#
   * prdyy_n    PCI IRDY#
   * IDSEL      PCI IDSEL
   * hb_ad_bus  PCI AD
   * byte_ens   PCI C/BE#
   * test_reg   receive data register
   * 
   * 
   */
  task pci_read;
    
    input [3:0]  host_cycle_type;
    input [31:0] address;
    input [3:0]  byte_enables;
    input [29:0] count; //number of beats in one burst cycle (max= 1G beats)
    
    integer	   retry_count;
    integer	   trans_count;
    integer	   devsel_count;
    integer	   trdy_count;
    integer	   irdy_count;
    integer	   burst_count;
    integer	   data_phase_done;
    integer	   terminated;
    integer	   initial_data_phase;

    begin
      
      case (mw0_size)
	2'b00: mw0_mask = 11'h0;
	2'b01: mw0_mask = 11'h1;
	2'b10: mw0_mask = 11'h3;
	2'b11: mw0_mask = 11'h7;
      endcase
      case (mw1_size)
	2'b00: mw1_mask = 11'h0;
	2'b01: mw1_mask = 11'h1;
	2'b10: mw1_mask = 11'h3;
	2'b11: mw1_mask = 11'h7;
      endcase
      case (aw_size)
	0: aw_mask = 20'h1;
	1: aw_mask = 20'h3;
	2: aw_mask = 20'h7;
	3: aw_mask = 20'hF;
	4: aw_mask = 20'h1F;
	5: aw_mask = 20'h3F;
	6: aw_mask = 20'h7F;
	7: aw_mask = 20'hFF;
	8: aw_mask = 20'h1FF;
	9: aw_mask = 20'h3FF;
	10: aw_mask = 20'h7FF;
	11: aw_mask = 20'hFFF;
	default: aw_mask = 20'h1;
      endcase // case(aw_size)
      
      // Are there any burst_data requests pending?
      if (pci_cmd_list_index > 0)
	pci_burst_end;	// This will call pci_write
      
      /*
       * Make sure the command is a read command
       */
      if (host_cycle_type[0] != 0) begin
	$display("Error! task rd(%h,%h,%h)", host_cycle_type, address, count);
	$display("       PCI test master received a write command in a read task");
	$stop;
      end // if (host_cycle_type[0] != 0)
      
      /*
       * Initialize some counters used for error checking
       */
      retry_count = 0;
      trans_count = 0;
      @(posedge HCLK);
      
      /*
       * Outermost loop handles retries.
       */
      begin : retry_loop
	while (trans_count < count) begin
	  /*
	   * wait for grant
	   */
	  while (!(!GNT_RWTn && FRAMEn && PRDYn)) begin
	    REQ_RWTn <= #Tval 0;
	    @(posedge HCLK);
	  end // while (!(!GNT_RWTn && FRAMEn && PRDYn))
	  
	  // We will do a 64 bit transfer on any memory transaction. However, 
	  // the FPGA should not respond to all of these... We'll check that 
	  // below. 
	  if (`PCI64 && (host_cycle_type == MEM_RD || 
			 host_cycle_type == MEM_WR ||
			 host_cycle_type == MEM_RD_MULTI || 
			 host_cycle_type == MEM_RD_LINE ||
			 host_cycle_type == MEM_WR_INV) &&
	      ~((count == 1) || (~address[2] && count == 2) ||
		((trans_count == count - 1) || 
		 ~address[2] && trans_count == count - 2)))
	    enable_64 = 1'b1;
	  else 
	    enable_64 = 1'b0;
	  
	  /*
	   * Address Phase
	   */
	  if (host_cycle_type==CONFIG_RD) begin
`ifdef PCIX
	    hb_ad_bus <= #Tinval 64'bx;
`endif
`ifdef PCIX
	    IDSEL <= #Tinval 'bx;
`endif
	    hb_ad_bus <= #Tval {32'b0, 16'h1, address[15:0]};
	    IDSEL  <= #Tval 1;
	  end // if (host_cycle_type==CONFIG_RD)
	  else begin
`ifdef PCIX
	    hb_ad_bus <= #Tinval 64'bx;
`endif
	    hb_ad_bus <= #Tval {32'b0, address};
	  end // else: !if(host_cycle_type==CONFIG_RD)
`ifdef PCIX
	  byte_ens <= #Tinval 'bx;
`endif
	  byte_ens <= #Tval host_cycle_type;
	  prdyy_n <= #Tval 'bz;
	  rwtPARen <= #Tval 1;
`ifdef PCIX
	  framee_n <= #Tinval 'bx;
	  req64_n <= #Tval 'bx;
`endif
	  framee_n <= #Tval 0;
	  req64_n <= #Tval ~enable_64;
	  REQ_RWTn <= #Tval 1;
	  devsel_count = 0;
	  
	  /*
	   * Data Phases
	   */
	  @ (posedge HCLK);
`ifdef PCIX
	  byte_ens <= #Tinval 'bx;
`endif
	  byte_ens <= #Tval byte_enables;
	  hb_ad_bus <= #Tval 64'bz;
	  rwtPARen <= #Tval 0;
	  IDSEL <= #Tval 'bz;
	  initial_data_phase = 1;
	  burst_count = 0;
	  terminated = 0;
	  
	  begin : burst_loop
	    while ((trans_count < count) && !terminated) begin
	      trdy_count = 0;
	      // count edges until time to assert irdy#

	      if (irdy_random) begin
		irdy_delay=irdy_pattern[irdy_pattern_index];
		irdy_pattern_index = irdy_pattern_index + 1;
	      end // if (irdy_random)
	      
	      for (irdy_count=0; irdy_count<irdy_delay; irdy_count = irdy_count + 1) begin
		if (!prdyy_n) begin
`ifdef PCIX
		  prdyy_n <= #Tinval 'bx;
`endif
		  prdyy_n <= #Tval 1;
		end // if (!prdyy_n)
		@ (posedge HCLK)
		  if (DEVSELn!=0)
		    devsel_count = devsel_count + 1;
		if (TRDYn!=0)
		  trdy_count = trdy_count + 1;
	      end // for (irdy_count=0; irdy_count<irdy_delay; irdy_count = irdy_count + 1)
	      // Assert IRDY#.  Also, check if STOP# asserted.
	      // If so, negate FRAME# (Fig's 9-4,9-7,9-9 in "PCI System
	      // Architecture, Third Edition")  FRAME# is also negated if
	      // this is the last piece of data in the transaction. 
	      if (PRDYn!='b0) begin
`ifdef PCIX
		prdyy_n <= #Tinval 'bx;
`endif
	      end // if (PRDYn!='b0)
	      prdyy_n <= #Tval 0;
	      if ((trans_count == count-1) || !STOPn) begin
`ifdef PCIX
		framee_n  <= #Tinval 'bx;
		req64_n <= #Tval 'bx;
`endif
		framee_n  <= #Tval 1;
		req64_n   <= #Tval 1;
	      end // if (trans_count == count-1)
	      if (trans_count == count-1)
		REQ_RWTn  <= #Tval 1;
	      
	      // Loop until target signals end of data phase, or until
	      // a time out is detected
	      data_phase_done = 0;
	      while (!data_phase_done) begin
		@ (posedge HCLK);
		// increment devsel and trdy watchdog timers
		if (DEVSELn!=0)
		  devsel_count = devsel_count + 1;
		if (TRDYn!=0)
		  trdy_count = trdy_count + 1;
		
		// Normal end of data phase.  Master grabs data
		if (DEVSELn==0 && TRDYn==0 && STOPn==1) begin
`ifdef DISPLAY_READ
		  $display ("PCI READ: address=%h data=%h time=%d",address, AD, $time);
`endif // ifdef DISPLAY_READ
		  if ((rwt_log != 0)&& rwt_read_log) $fdisplay (rwt_log, "PCI READ: address=%h data=%h",address, AD);
		  retry_count = 0;
		  
		  data_phase_done = 1;
		  trans_count = trans_count + 1;
		  burst_count = burst_count + 1;
		  address = address + 4;
		  test_reg = AD;
		  if (trans_count == count) begin
		    framee_n <= #Tval 'bz;
		    req64_n <= #Tval 'bz;
`ifdef PCIX
		    prdyy_n <= #Tinval 'bx;
`endif
		    prdyy_n <= #Tval 1;
`ifdef PCIX
		    byte_ens <= #Tinval 8'hx;
`endif
		    byte_ens <= #Tval 8'hz;
		    prdyy_n <= #(hclk+Tval) 'bz;
		  end // if (trans_count == count)
		  
		end // if (DEVSELn==0 && TRDYn==0 && STOPn==1)
		
		// Retry or Disconnect w/o data
		else if (DEVSELn==0 && TRDYn==1 && STOPn==0) begin
`ifdef RWTASK_DEBUG
		  if (burst_count == 0)
		    $display ("PCI RETRY (read) at address %h, time: %d",address, $time);
		  else
		    $display ("PCI DISCONNECT w/o data (read) at address %h, time: %d",address, $time);
`endif
		  // must stop requesting the bus
		  REQ_RWTn <= #Tval 1;
		  // ensure that FRAME# is negated before negating IRDY#,
		  // to properly terminate the transaction.
		  if (!framee_n) begin
`ifdef PCIX
		    framee_n <= #Tinval 'bx;
		    req64_n <= #Tval 'bx;
`endif
		    framee_n <= #Tval 1;
		    req64_n <= #Tval 1;
		    @ (posedge HCLK);
		  end // if (!framee_n)
		  retry_count = retry_count + 1;
`ifdef PCIX
		  prdyy_n <= #Tinval 'bx;
`endif
		  prdyy_n <= #Tval 1;
`ifdef PCIX
		  hb_ad_bus <= #Tinval 64'hx;
`endif
		  hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		  byte_ens <= #Tinval 8'hx;
`endif
		  byte_ens <= #Tval 8'hz;
		  framee_n <= #Tval 'bz;
		  req64_n <= #Tval 'bz;
		  @(posedge HCLK);
		  prdyy_n <= #Tval 'bz;
		  data_phase_done = 1;
		  terminated = 1;
		  @ (posedge HCLK);
		  @ (posedge HCLK);
		end // if (DEVSELn==0 && TRDYn==1 && STOPn==0)
		
		// Disconnect with data
		else if (DEVSELn==0 && TRDYn==0 && STOPn==0) begin
`ifdef RWTASK_DEBUG
		  $display ("PCI DISCONNECT with data (read) at address %h, time: %d",address, $time);
`endif
`ifdef DISPLAY_READ
		  $display ("PCI READ: address=%h data=%h",address, AD);
`endif
		  if ((rwt_log != 0)&& rwt_read_log) $fdisplay (rwt_log, "PCI READ: address=%h data=%h",address, AD);
		  if (!framee_n)
		    REQ_RWTn <= #Tval 1;
		  trans_count = trans_count + 1;
		  address = address + 4;
		  test_reg = AD;
		  // ensure that FRAME# is negated before negating IRDY#,
		  // to properly terminate the transaction.
		  if (!framee_n) begin
`ifdef PCIX
		    framee_n <= #Tinval 'bx;
		    req64_n <= #Tval 'bx;
`endif
		    framee_n <= #Tval 1;
		    req64_n <= #Tval 1;
		    @ (posedge HCLK);
		  end // if (!framee_n)
`ifdef PCIX
		  prdyy_n <= #Tinval 'bx;
`endif
		  prdyy_n <= #Tval 1;
`ifdef PCIX
		  hb_ad_bus <= #Tinval 64'hx;
`endif
		  hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		  byte_ens <= #Tinval 8'hx;
`endif
		  byte_ens <= #Tval 8'hz;
		  framee_n <= #Tval 'bz;
		  req64_n <= #Tval 'bz;
		  @(posedge HCLK);
		  prdyy_n <= #Tval 'bz;
		  data_phase_done = 1;
		  terminated = 1;
		end // if (DEVSELn==0 && TRDYn==0 && STOPn==0)
		
		// Target abort: stop entire transaction
		else if (DEVSELn==1 && STOPn==0) begin
		  $display ("PCI Target Abort (read) at address %h, time: %d",address, $time);
		  // stop requesting the bus
		  REQ_RWTn <= #Tval 1;
		  if (!framee_n) begin
`ifdef PCIX
		    framee_n  <= #Tinval 'bx;
		    req64_n <= #Tval 'bx;
`endif
		    framee_n  <= #Tval 1;
		    req64_n <= #Tval 1;
		  end // if (!framee_n)
		  @ (posedge HCLK);
		  prdyy_n <= #Tval 1;
		  byte_ens <= #Tval 8'hz;
		  @ (posedge HCLK);
		  prdyy_n <= #Tval 'bz;
		  data_phase_done = 1;
		  trans_count = count;
		end // if (DEVSELn==1 && STOPn==0)
		
		// No response yet.  check watchdog timers for expiration
		else begin
		  if (trdy_count >= `WDTIMER) begin
		    $display ("PCI info: TRDY# timeout (read) at address %h, time: %d",address, $time);
		    $stop;
		  end // if (trdy_count >= `WDTIMER)
		  
		  if (retry_count >= `MAXRETRY) begin
		    $display ("PCI info: max RETRY count exceeded (read) at address %h, time: %d",address, $time);
		    $stop;
		  end // if (retry_count >= `MAXRETRY)
		  
		  if (devsel_count >= `MAXDEVSEL) begin
		    $display ("PCI info: no DEVSEL asserted (read) at address %h, time= %d", address, $time);
		    REQ_RWTn <= #Tval 1;
		    if (!framee_n) begin
`ifdef PCIX
		      framee_n  <= #Tinval 'bx;
		      req64_n <= #Tval 'bx;
`endif
		      framee_n  <= #Tval 1;
		      req64_n <= #Tval 1;
		    end // if (!framee_n)
		    @ (posedge HCLK);
		    prdyy_n <= #Tval 1;
		    byte_ens <= #Tval 8'hz;
		    @ (posedge HCLK);
		    prdyy_n <= #Tval 'bz;
		    @ (posedge HCLK);
		    disable retry_loop;
		  end // if (devsel_count >= 'MAXDEVSEL)
		end // else: !if(DEVSELn==1 && STOPn==0)
	      end // while (!data_phase_done)
	    end // while (trans_count < count)
	  end // block: burst_loop
	  initial_data_phase = 0;
	end // while (trans_count < count)
      end // block: retry_loop
    end
  endtask // pci_read

   /*
    * Task: rd
    * read with byte enables all asserted.
    * 
    * Inputs:
    * HCLK       PCI CLK
    * DEVSELn    PCI DEVSEL#
    * TRDYn      PCI TRDY#
    * STOPn      PCI STOP#
    * AD         PCI AD
    * 
    * Outputs:
    * framee_n   PCI FRAME#
    * prdyy_n    PCI IRDY#
    * IDSEL      PCI IDSEL
    * hb_ad_bus  PCI AD
    * byte_ens   PCI C/BE#
    * test_reg   receive data register
    * 
    * 
    */
   task rd;

     input [3:0]  host_cycle_type;
     input [31:0] address;
     input [29:0] count; //number of beats in one burst cycle (max= 1G beats)

   begin
     pci_read(host_cycle_type, address, 4'h0, count);
   end
   endtask // rd

  /*
   * Task: rd_byte
   * read with byte enable control.
   */
  task rd_byte;
    input [3:0]	 host_cycle_type;
    input [31:0] address;
    input [3:0]	 byte_enables;	  
    input [29:0] count; //number of beats in one burst cycle (max= 1G beats)
  begin
    pci_read(host_cycle_type, address, byte_enables, count);
  end
  endtask // rd_byte

   /*
    * Task: rd_verify
    * 
    * This task uses the following 'defines:
    * RAND, PRDY[1-3], 
    * 
    * Inputs:
    * HCLK       PCI CLK
    * DEVSELn    PCI DEVSEL#
    * TRDYn      PCI TRDY#
    * STOPn      PCI STOP#
    * AD         PCI AD
    * 
    * Outputs:
    * framee_n   PCI FRAME#
    * prdyy_n    PCI IRDY#
    * IDSEL      PCI IDSEL
    * hb_ad_bus  PCI AD
    * byte_ens   PCI C/BE#
    * test_reg   receive data register
    * 
    * 
    */
   task rd_verify;

      input [3:0]  host_cycle_type;
      input [31:0] address;
      input [29:0] NO_OF_BEATS;        //number of beats in one burst cycle
      input [31:0] initial_rd_pattern; //the initail read comparison pattern

     integer	   retry_count;
     integer	   trans_count;
     integer	   devsel_count;
     integer	   trdy_count;
     integer	   irdy_count;
     integer	   burst_count;
     integer	   data_phase_done;
     integer	   terminated;
      integer	   initial_data_phase;

   begin

      // Are there any burst_data requests pending?
      if (pci_cmd_list_index > 0)
	 pci_burst_end;	// This will call pci_write

      /*
       * Make sure the command is a read command
       */
      if (host_cycle_type[0] != 0) begin
	 $display("Error! task rd(%h,%h,%h)", host_cycle_type, address, count);
	 $display("       PCI test master received a write command in a read task");
	 $stop;
      end // if (host_cycle_type[0] != 0)

      /*
       * Initialize some counters used for error checking
       */
      retry_count = 0;
      trans_count = 0;
     @(posedge HCLK);

      /*
       * Outermost loop handles retries.
       */
      begin : retry_loop
	 while (trans_count < count) begin
	   /*
	    * wait for grant
	    */
	   while (!(!GNT_RWTn && FRAMEn && PRDYn)) begin
	     REQ_RWTn <= #Tval 0;
	     @(posedge HCLK);
	   end // while (!(!GNT_RWTn && FRAMEn && PRDYn))
	   
	   /*
	    * Address Phase
	    */
	   if (host_cycle_type==CONFIG_RD) begin
`ifdef PCIX
	     hb_ad_bus <= #Tinval 64'bx;
`endif
`ifdef PCIX
	     IDSEL <= #Tinval 'bx;
`endif
	     hb_ad_bus <= #Tval {32'b0, 16'h1, address[15:0]};
	     IDSEL  <= #Tval 1;
	   end // if (host_cycle_type==CONFIG_RD)
	   else begin
`ifdef PCIX
	     hb_ad_bus <= #Tinval 32'bx;
`endif
	     hb_ad_bus <= #Tval {32'b0, address};
	   end // else: !if(host_cycle_type==CONFIG_RD)
`ifdef PCIX
	   byte_ens <= #Tinval 'bx;
`endif
	   byte_ens <= #Tval host_cycle_type;
	   prdyy_n <= #Tval 'bz;
	   rwtPARen <= #Tval 1;
`ifdef PCIX
	   framee_n <= #Tinval 'bx;
	   req64_n <= #Tval 'bx;
`endif
	   framee_n <= #Tval 0;
	   req64_n <= #Tval 1;
	   REQ_RWTn <= #Tval 1;
	   devsel_count = 0;

	   /*
	    * Data Phases
	    */
	   @ (posedge HCLK);
`ifdef PCIX
	   byte_ens <= #Tinval 'bx;
`endif
	   byte_ens <= #Tval 0;
	   hb_ad_bus <= #Tval 64'bz;
	   rwtPARen <= #Tval 0;
	   IDSEL <= #Tval 'bz;
	   initial_data_phase = 1;
	   burst_count = 0;
	   terminated = 0;

	    begin : burst_loop
	       while ((trans_count < count) && !terminated) begin
		  trdy_count = 0;
		  // count edges until time to assert irdy#

		 if (irdy_random) begin
		   irdy_delay=irdy_pattern[irdy_pattern_index];
		   irdy_pattern_index = irdy_pattern_index + 1;
		 end // if (irdy_random)
	      
		 for (irdy_count=0; irdy_count<irdy_delay; irdy_count = irdy_count + 1) begin
		   if (!prdyy_n) begin
`ifdef PCIX
		     prdyy_n <= #Tinval 'bx;
`endif
		     prdyy_n <= #Tval 1;
		   end // if (!prdyy_n)
		   @ (posedge HCLK)
		   if (DEVSELn!=0)
		     devsel_count = devsel_count + 1;
		   if (TRDYn!=0)
		     trdy_count = trdy_count + 1;
		 end // for (irdy_count=0; irdy_count<irdy_delay; irdy_count = irdy_count + 1)
		  // Assert IRDY#.  Also, check if STOP# asserted.
		  // If so, negate FRAME# (Fig's 9-4,9-7,9-9 in "PCI System
		  // Architecture, Third Edition")  FRAME# is also negated if
		  // this is the last piece of data in the transaction. 
		  if (PRDYn!='b0) begin
`ifdef PCIX
		     prdyy_n <= #Tinval 'bx;
`endif
		  end // if (PRDYn!='b0)
		 prdyy_n <= #Tval 0;
		  if ((trans_count == count-1) || !STOPn) begin
`ifdef PCIX
		     framee_n  <= #Tinval 'bx;
		    req64_n <= #Tval 'bx;
`endif
		    framee_n  <= #Tval 1;
		    req64_n <= #Tval 1;
		  end // if (trans_count == count-1)
		 if (trans_count == count-1)
		   REQ_RWTn  <= #Tval 1;
		  
		  // Loop until target signals end of data phase, or until
		  // a time out is detected
		  data_phase_done = 0;
		  while (!data_phase_done) begin
		     @ (posedge HCLK);
		     // increment devsel and trdy watchdog timers
		     if (DEVSELn!=0)
			devsel_count = devsel_count + 1;
		     if (TRDYn!=0)
			trdy_count = trdy_count + 1;

		     // Normal end of data phase.  Master grabs data
		     if (DEVSELn==0 && TRDYn==0 && STOPn==1) begin
`ifdef DISPLAY_READ
			$display ("PCI READ: address=%h data=%h time=%d",address, AD, $time);
`endif // ifdef DISPLAY_READ
			if ((rwt_log != 0)&& rwt_read_log) $fdisplay (rwt_log, "PCI READ: address=%h data=%h",address, AD);
		       retry_count = 0;

			data_phase_done = 1;
			trans_count = trans_count + 1;
			burst_count = burst_count + 1;
			address = address + 4;
			test_reg = AD;
                        if (test_reg==(initial_rd_pattern[31:0] + trans_count))
			   $display("COMPARISON PASSED,    ADDR=%h EXPECTED DATA=%h ACTUAL_DATA=%h",
				    address, initial_rd_pattern, test_reg);
                        else 
                          $display("COMPARISON FAILED!!!, ADDR=%h EXPECTED DATA=%h ACTUAL_DATA=%h",
				   address, initial_rd_pattern, test_reg);
		       if (trans_count == count) begin
			 framee_n <= #Tval 'bz;
			 req64_n <= #Tval 'bz;
`ifdef PCIX
			 prdyy_n <= #Tinval 'bx;
`endif
			 prdyy_n <= #Tval 1;
`ifdef PCIX
			 byte_ens <= #Tinval 8'hx;
`endif
			 byte_ens <= #Tval 8'hz;
			 @(posedge HCLK);
			 prdyy_n <= #Tval 'bz;
		       end // if (trans_count == count)

		     end // if (DEVSELn==0 && TRDYn==0 && STOPn==1)
		     
		     // Retry or Disconnect w/o data
		     else if (DEVSELn==0 && TRDYn==1 && STOPn==0) begin
`ifdef RWTASK_DEBUG
			if (burst_count == 0)
			   $display ("PCI RETRY (read) at address %h, time: %d",address, $time);
			else
			   $display ("PCI DISCONNECT w/o data (read) at address %h, time: %d",address, $time);
`endif
		       // must stop requesting the bus
		       REQ_RWTn <= #Tval 1;
			// ensure that FRAME# is negated before negating IRDY#,
			// to properly terminate the transaction.
			if (!framee_n) begin
`ifdef PCIX
			   framee_n <= #Tinval 'bx;
			  req64_n <= #Tval 'bx;
`endif
			  framee_n <= #Tval 1;
			  req64_n <= #Tval 1;
			   @ (posedge HCLK);
			end // if (!framee_n)
		       retry_count = retry_count + 1;
`ifdef PCIX
		       prdyy_n <= #Tinval 'bx;
`endif
		       prdyy_n <= #Tval 1;
`ifdef PCIX
		       hb_ad_bus <= #Tinval 64'hx;
`endif
		       hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		       byte_ens <= #Tinval 8'hx;
`endif
		       byte_ens <= #Tval 8'hz;
		       framee_n <= #Tval 'bz;
		       req64_n <= #Tval 'bz;
		       @(posedge HCLK);
		       prdyy_n <= #Tval 'bz;
		       data_phase_done = 1;
		       terminated = 1;
		       @ (posedge HCLK);
		       @ (posedge HCLK);
		     end // if (DEVSELn==0 && TRDYn==1 && STOPn==0)
		     
		     // Disconnect with data
		     else if (DEVSELn==0 && TRDYn==0 && STOPn==0) begin
`ifdef RWTASK_DEBUG
			$display ("PCI DISCONNECT with data (read) at address %h, time: %d",address, $time);
`endif
`ifdef DISPLAY_READ
			$display ("PCI READ: address=%h data=%h",address, AD);
`endif
			if ((rwt_log != 0)&& rwt_read_log) $fdisplay (rwt_log, "PCI READ: address=%h data=%h",address, AD);
		       if (!framee_n)
			 REQ_RWTn <= #Tval 1;
			trans_count = trans_count + 1;
			address = address + 4;
			test_reg = AD;
                        if (test_reg==(initial_rd_pattern[31:0] + trans_count))
			   $display("COMPARISON PASSED,    ADDR=%h EXPECTED DATA=%h ACTUAL_DATA=%h",
				    address, initial_rd_pattern, test_reg);
                        else 
                          $display("COMPARISON FAILED!!!, ADDR=%h EXPECTED DATA=%h ACTUAL_DATA=%h",
				   address, initial_rd_pattern, test_reg);
			// ensure that FRAME# is negated before negating IRDY#,
			// to properly terminate the transaction.
			if (!framee_n) begin
`ifdef PCIX
			   framee_n <= #Tinval 'bx;
			  req64_n <= #Tval 'bx;
`endif
			  framee_n <= #Tval 1;
			  req64_n <= #Tval 1;
			   @ (posedge HCLK);
			end // if (!framee_n)
`ifdef PCIX
		       prdyy_n <= #Tinval 'bx;
`endif
		       prdyy_n <= #Tval 1;
`ifdef PCIX
		       hb_ad_bus <= #Tinval 64'hx;
`endif
		       hb_ad_bus <=#Tval 64'hz;
`ifdef PCIX
		       byte_ens <= #Tinval 8'hx;
`endif
		       byte_ens <= #Tval 8'hz;
		       framee_n <= #Tval 'bz;
		       req64_n <= #Tval 'bz;
		       @(posedge HCLK);
		       prdyy_n <= #Tval 'bz;
		       data_phase_done = 1;
		       terminated = 1;
		     end // if (DEVSELn==0 && TRDYn==0 && STOPn==0)
		     
		     // Target abort: stop entire transaction
		     else if (DEVSELn==1 && STOPn==0) begin
		       $display ("PCI Target Abort (read) at address %h, time: %d",address, $time);
		       // stop requesting the bus
		       REQ_RWTn <= #Tval 1;
			if (!framee_n) begin
`ifdef PCIX
			  framee_n  <= #Tinval 'bx;
			  req64_n <= #Tval 'bx;
`endif
			  framee_n  <= #Tval 1;
			  req64_n <= #Tval 1;
			end // if (!framee_n)
			@ (posedge HCLK);
			prdyy_n <= #Tval 1;
			byte_ens <= #Tval 8'hz;
			@ (posedge HCLK);
		       prdyy_n <= #Tval 'bz;
		       data_phase_done = 1;
		       trans_count = count;
		     end // if (DEVSELn==1 && STOPn==0)
		     
		     // No response yet.  check watchdog timers for expiration
		     else begin
			if (trdy_count >= `WDTIMER) begin
			   $display ("PCI info: TRDY# timeout (read) at address %h, time: %d",address, $time);
			   $stop;
			end // if (trdy_count >= `WDTIMER)
			
			if (retry_count >= `MAXRETRY) begin
			   $display ("PCI info: max RETRY count exceeded (read) at address %h, time: %d",address, $time);
			   $stop;
			end // if (retry_count >= `MAXRETRY)
			
			if (devsel_count >= `MAXDEVSEL) begin
			   $display ("PCI info: no DEVSEL asserted (read) at address %h, time= %d", address, $time);
			  REQ_RWTn <= #Tval 1;
			   if (!framee_n) begin
`ifdef PCIX
			     framee_n  <= #Tinval 'bx;
			     req64_n <= #Tval 'bx;
`endif
			     framee_n  <= #Tval 1;
			     req64_n <= #Tval 1;
			   end // if (!framee_n)
			   @ (posedge HCLK);
			   prdyy_n <= #Tval 1;
			   byte_ens <= #Tval 8'hz;
			   @ (posedge HCLK);
			   prdyy_n <= #Tval 'bz;
			   @ (posedge HCLK);
			   disable retry_loop;
			end // if (devsel_count >= 'MAXDEVSEL)
		     end // else: !if(DEVSELn==1 && STOPn==0)
		  end // while (!data_phase_done)
	       end // while (trans_count < count)
	    end // block: burst_loop
	    initial_data_phase = 0;
	 end // while (trans_count < count)
      end // block: retry_loop
   end
  endtask // rd_verify
  


/***********************************************************/
/**** TASK TO IMPLEMENT DAC_SNOOP ON THE PCI BUS ***/
/***********************************************************/

   task pci_dac_snoop;
   
      input [3:0]  host_cycle_type;
      input [31:0] address;
      input [31:0] data;
      input [3:0]  byte_enables;
      input [29:0] NO_OF_BEATS; //number of beats in one burst cycle (max=1G beats)
      input [1:0]  trdy_stop_type;

      integer	   index_beat_timer;
      integer	   index_beat_count;

   begin

      // Are there any burst_data requests pending?
      if (pci_cmd_list_index > 0)
	 pci_burst_end;	// This will call pci_write

      $display ("DAC SNOOP CYCLE IS ACTIVATED at ADDR=%h at TIME= %d", address, $time);

      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      //**** address phase. Present address ,assert framee_n signal &
      //     check if cyle type is configuration *********
      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      #(hclk-Tsu-Thld)
      fork
	 hb_ad_bus         = {32'b0, address};
	 framee_n            = 0;
	 prdyy_n             = 1;
	 trdyy_n           = 1;
	 stopp_n           = 1;
	 IDSEL             = 'bz;
	 byte_ens[3:0]        = host_cycle_type[3:0];
      join
      
      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      // CHECK IF CYCLE IS SINGLE TRANSFER OR BURST
      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      @ (posedge HCLK)

      if (NO_OF_BEATS==1) 

	 /****************  SINGLE WRITE TRANSFER CYCLE , NO PRDY WAIT *****************/
      begin

	 #(Thld) fork
	    hb_ad_bus       = 64'hz;
	    byte_ens[3:0]      = 8'hz;
	    IDSEL           = 'bz;
	    framee_n          = 1;
	 join
	 
	 @ (posedge HCLK)
	    #(hclk-Tsu)  fork
	       prdyy_n      = 0;
	       hb_ad_bus  = {32'b0, data};
	       byte_ens[3:0] = byte_enables ;
	    join
	 @ (posedge HCLK)
	       @ (posedge HCLK)
	 begin
	    trdyy_n = 1;
	    stopp_n = 1;
	    if (trdy_stop_type[1:0] ==2'h0) //trdy_single
	       #(hclk-Tsu)
	       trdyy_n = 0;
	    else if (trdy_stop_type[1:0] ==2'h3) //stop_single
	       #(hclk-Tsu)
	       stopp_n = 0;
	 end
	 
	 @ (posedge HCLK)
	    #(Thld) fork
	       prdyy_n        = 1;
	       trdyy_n      = 1;
	       stopp_n      = 1;
	       hb_ad_bus    = 64'hz;
	       byte_ens[3:0]   = 8'hz;
	    join

	 @ (posedge HCLK)
	       #(Thld)
	 fork
	    trdyy_n      = 1'hz;
	    stopp_n      = 1'hz;
	 join

      end



      /************************ BURST WRITE TRANSFER CYCLES , NO PRDY WAIT********************/
      else if (NO_OF_BEATS!==1)
	 begin
	    
	    #(Thld) fork
	       hb_ad_bus       = 64'hz;
	       byte_ens[3:0]      = 8'hz;
	       IDSEL           = 'bz;
	    join
	    
	    
	    @ (posedge HCLK)
	       #(hclk-Tsu)  fork
		  prdyy_n      = 0;
		  hb_ad_bus  = {32'b0, data} ;
		  byte_ens[3:0] = byte_enables ;
	       join

	    @ (posedge HCLK)
		  @ (posedge HCLK)
	    begin
	       trdyy_n = 1;
	       stopp_n = 1;
	       #(hclk-Tsu)
		  trdyy_n = 0;
	    end

	    for (index_beat_count=1; index_beat_count <= NO_OF_BEATS; index_beat_count = index_beat_count+1 )
	       begin

		  @ (posedge HCLK)
		  if (trdy_stop_type[1:0] ==2'h1 && index_beat_count == NO_OF_BEATS-1) /* BEAT BEFORE LAST */
		     begin
			#(Thld) fork
			   framee_n       = 1;
			   hb_ad_bus    = 64'hz;
			   byte_ens[3:0]   = 8'hz;
			join

			#(hclk-Tsu)  fork
			   hb_ad_bus  = {32'b0, data  + index_beat_count};
			   byte_ens[3:0] = byte_enables ;
			join
		     end


		  else if (trdy_stop_type[1:0] ==2'h1 && index_beat_count!==NO_OF_BEATS)
		     begin
			#(Thld) fork
			   hb_ad_bus    = 64'hz;
			   byte_ens[3:0]   = 8'hz;
			join

			#(hclk-Tsu)  fork
			   hb_ad_bus  = {32'b0, data  + index_beat_count};
			   byte_ens[3:0] = byte_enables ;
			join
		     end

		  else if (trdy_stop_type[1:0] ==2'h1 && index_beat_count==NO_OF_BEATS) /*LAST BEAT */
		     begin
			#(Thld) fork
			   prdyy_n        = 1;
			   trdyy_n      = 1;
			   stopp_n      = 1;
			   hb_ad_bus    = 64'hz;
			   byte_ens[3:0]   = 8'hz;
			join
		     end

		  else if (trdy_stop_type[1:0] ==2'h2) //TRDY_BURST_STOP
		     begin
			begin
			   #(Thld) fork
			      framee_n       = 1;
			      hb_ad_bus    = 64'hz;
			      byte_ens[3:0]   = 8'hz;
			      trdyy_n      = 1; 
			   join
			   
			   #(hclk-Tsu-Thld)  fork
			      hb_ad_bus  = {32'b0, data  + index_beat_count};
			      byte_ens[3:0] = byte_enables ;
			      stopp_n    = 0;
			   join
			end

			@ (posedge HCLK)
			   fork
			      prdyy_n        = 1;
			      trdyy_n      = 1;
			      stopp_n      = 1;
			      hb_ad_bus    = 64'hz;
			      byte_ens[3:0]   = 8'hz;
			      index_beat_count = NO_OF_BEATS;
			   join
		     end
	       end

	    @ (posedge HCLK)
		  #(Thld)
	    fork
	       trdyy_n      = 1'hz;
	       stopp_n      = 1'hz;
	    join
	    
	 end

   end
   endtask //pci_dac_snoop

  always @(posedge HCLK) begin
    rwtPAR <= #Tval ^{AD[31:0],C_BEn[3:0]};
    rwtPAR64 <= #Tval ^{AD[63:32],C_BEn[7:4]};
    rwtPARen1 <= #Tval rwtPARen;
  end // always @ (posedge HCLK)
  
  assign PAR = rwtPARen1 ? rwtPAR : 1'bz;
  assign PAR64 = rwtPARen1 ? rwtPAR64 : 1'bz;

/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
//
// CPU_MOV.VLG - "CPU Move"
//
// This file contains tasks which convert cpu address instruction
// into bus instructions.   Currently, this file contains tasks 
// which simulate the DWORD and BYTE memory instruction. (WORD 
// memory cycles will be simulated when resources permit.)
// 
// At the bus level, all memory accesses are performed on 32 bit 
// boundaries.  (i.e. these memory accesses are DWORD aligned.)
// In addition to 32 bit data, the memory bus also receives a
// four bit bus strobe, each bit corresponding to a BYTE of data.
// Although 32 bit data is presented, the bus masks off each
// BYTE whose bus strobe bit is 1.
//
// Whenever the CPU accesses data, the CPU must DWORD align 
// the data and calculate the appropriate strobes.  If the
// data size is greater than a BYTE, then it is possible that
// the data access can not fullfilled in a single bus access.
// In this case, it is the responsibility of the CPU to 
// break the access into 2 distinct bus requests.  
// 
// The following table lists cpu memory access to bus memory 
// address conversions for various BYTES accesses.  By
// convenstion, data which is masked off is indicated by
// the character 'x'.
// 
//   +-------------------+--------------------------------+
//   |     CPU Access    |          BUS Access            |
//   +-------------------+--------------------------------+
//   |   Address   Data  |   Address     Data      Strobe |
//   +-------------------+--------------------------------+
//   | 0x00000000  0x12  | 0x00000000  xxxxxx12    0b1110 |
//   +-------------------+--------------------------------+
//   | 0x00000001  0x12  | 0x00000000  xxxx12xx    0b1101 |
//   +-------------------+--------------------------------+
//   | 0x00000002  0x12  | 0x00000000  xx12xxxx    0b1011 |
//   +-------------------+--------------------------------+
//   | 0x00000003  0x12  | 0x00000000  12xxxxxx    0b0111 |
//   +-------------------+--------------------------------+
//   | 0x00000004  0x12  | 0x00000004  xxxxxx12    0b1110 |
//   +-------------------+--------------------------------+
// 
//
//   The following table lists cpu memory access to bus memory 
//   address conversions for various DWORD accesses.  Unlike BYTE
//   accesses, the CPU must convert a single DWORD access into 
//   multiple BUS cycles.
// 
//   +-------------------------+------------------------------------+
//   |       CPU Access        |             BUS Access             |
//   +-------------------------+------------------------------------+
//   |   Address      Data     | Cycle   Address    Data     Strobe |
//   +-------------------------+------------------------------------+
//   | 0x00000000  0x12345678  |  (1)  0x00000000  12345678  0b0000 |
//   +-------------------------+------------------------------------+
//   | 0x00000001  0x12345678  |  (1)  0x00000000  345678xx  0b0001 |
//   |                         |  (2)  0x00000004  xxxxxx12  0b1110 |
//   +-------------------------+------------------------------------+
//   | 0x00000002  0x12345678  |  (1)  0x00000000  5678xxxx  0b0011 |
//   |                         |  (2)  0x00000004  xxxx1234  0b1100 |
//   +-------------------------+------------------------------------+
//   | 0x00000003  0x12345678  |  (1)  0x00000000  78xxxxxx  0b0111 |
//   |                         |  (2)  0x00000004  xx123456  0b1000 |
//   +-------------------------+------------------------------------+
//   | 0x00000004  0x12345678  |  (1)  0x00000004  12345678  0b0000 |
//   +-------------------------+------------------------------------+
// */
// /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
// 

// 

task cpu_mov_dw;

input[3:0] Access;
input[31:0] Address;
input[31:0] Data;

reg[31:0] shift_back, shift_forward;
reg[31:0] Address1, Address2;
reg[31:0] Data1, Data2;
reg[3:0] Mask1, Mask2;
reg[3:0] Strobe1, Strobe2;
reg[3:0] StandardMask ;
reg[3:0] Strobe;

/* initial */
begin

StandardMask = 4'b1111;
shift_back = (Address & 32'h0000_0003);
if (shift_back > 0)
   begin 
   shift_forward = 4 - shift_back;
   Address1 = Address - shift_back; 
   Data1 = Data << (shift_back * 8);
   Mask1 = StandardMask << shift_back;
   Strobe1 = ~Mask1;

   Address2 = Address + shift_forward; 
   Data2 = Data >> (shift_forward * 8);
   Mask2 = StandardMask >> shift_forward;
   Strobe2 = ~Mask2;

   mov_dw(Access, Address1, Data1, Strobe1, 1);
   mov_dw(Access, Address2, Data2, Strobe2, 1);
   end 
else  /* There is no need to shift data.  */

  begin 
   Strobe = ~StandardMask;
   mov_dw(Access, Address, Data, Strobe, 1);
   end 
end
endtask // cpu_mov_dw


task cpu_mov_w;

   input[3:0] Access;
   input[31:0] Address;
   input[15:0] Data;

   reg[31:0] shift_back;
   reg[31:0] Data2;
   reg[3:0] StandardMask ;
   reg[3:0] Strobe;

/* initial */
   begin

      StandardMask = 4'b0011;
      shift_back = (Address & 32'h0000_0003);
      if (shift_back > 2)
         begin 
            mov_dw(Access, Address - 3, Data << 24, 4'b1000, 1);
            mov_dw(Access, Address + 1, Data,       4'b0001, 1);
         end 
      else /* Shift the data in the word */
         begin 
            Strobe = ~(StandardMask << shift_back);
            Data2 = Data << (shift_back << 3);
            mov_dw(Access, Address - shift_back, Data2, Strobe, 1);
         end 
   end
endtask // cpu_mov_w



task cpu_mov_b;

input[3:0] Access;
input[31:0] Address;
input[7:0] Data;

reg[31:0] shift_back, shift_forward;
reg[31:0] NewAddress;
reg[31:0] LongData;
reg[3:0] Mask;
reg[3:0] StandardMask;
reg[3:0] Strobe;

/* initial */
begin

LongData = Data;
StandardMask = 4'b0001;
shift_back = (Address & 32'h0000_0003);
if (shift_back > 0)
   begin 
   shift_forward = 4 - shift_back;
   NewAddress = Address - shift_back; 
   LongData = LongData << (shift_back * 8);
   Mask = StandardMask << shift_back;
   Strobe = ~Mask;
   mov_dw(Access, NewAddress, LongData, Strobe, 1);
   end 
else  /* There is no need to shift data.  */

  begin 
   Strobe = ~StandardMask;
   mov_dw(Access, Address, LongData, Strobe, 1);
   end 
end
endtask // cpu_mov_b



