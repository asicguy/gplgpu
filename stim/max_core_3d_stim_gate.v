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
//  Title       :  Top level stimulus file for ImaginePC family of chips
//  File        :  borealis_stim.v
//  Author      :  Frank Bruno
//  Created     :  12-29-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : This file is the top level stimulus file for Borealis
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
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 10 ps
module max_core_3d_stim;

`define DISPLAY_MODE 32'H0104_0101
`define BLOCK_MODE 32'h0
`include "../../stim/includes/stim_params_sh.h"

  parameter 
      `ifdef BYTE4
      BYTES           = 4,
      BYTE_BASE       = 2,
      `elsif BYTE8
      BYTES           = 8,
      BYTE_BASE       = 3,
      `elsif BYTE16
      BYTES           = 16,
      BYTE_BASE       = 4,
      `else
      BYTES           = 32,
      BYTE_BASE       = 5,
      `endif
      DE_ADDR         = 32'h800,
      `ifdef WIN_TEST XYW_ADDR        = 32'h4000_0000,
      `else           XYW_ADDR        = 32'h1000_0000,
      `endif
      LAST_PARAM = 0;
  
  // HEADER		HDR	();
 
  //		HOST BUS INPUTS AND OUTPUTS.			     
  reg		HCLK;		// host clock input port.
  reg 		MEMORY_CLK;
  reg		RSTn;		// host reset input port.
  tri [63:00] 	AD;		// host address and data port.
  tri		FRAMEn;	        // address strobe/FRAME signal
  tri		PRDYn;	        // Processor ready signal.
  tri		TRDYn;	        // Target ready.
  tri		DEVSELn;	// Device select
  wire		INTRP;	        // Interrupt output
  tri		STOPn;	        // Stop output.		
  wire		PAR;		// Parity output.	
  reg		IDSEL;	        // Identification select
  wire		IDSEL_p;	// Identification select
  tri [7:0]	C_BEn;
  wire		GRANTn;         // pci grant for ImaginePC from arbiter
  wire		REQn;           // pci request from ImaginePC to arbiter
  wire		GNT_RWTn;       // pci grant for RW_TASKS from arbiter
  reg		REQ_RWTn;       // pci request from RW_TASKS to arbiter
  wire		GNT_DMn;        // pci grant for PCI_REQUEST from arbiter
  reg		REQ_DMn;        // pci request from PCI_REQUEST to arbiter
  reg		RBFn;           // agp read buffer full signal
  wire ACK64n = 1'b1;
  wire PAR64  = 1'b0;

  // MEMORY CONTROLLER INPUTS AND OUTPUTS.
  wire		MCLK;		// Memory controller clock.
  reg		EX_MCLK_FB;	// Memory controller clock.
  wire [13:0]	RAD;		// DRAM, VRAM address.
  tri [BYTES*2-1:0]	PDAT;		// Frame buffer data.
  wire 		RAS;	        // VRAM ras zero to three.
  wire  	CSn;
  
  wire [1:0]	DQM;		// WRAM BE (low) SGRAM DQM.
  wire [2:0] 	BA;             // Bank Address
  wire      	CAS;	        // WRAM CASn  and SGRAM WEn

  // CRT CONTROLLER INPUTS AND OUTPUTS.	
  wire		HSYNC;
  wire		VSYNC;
  wire		CBLANK;
  //to keep older tests
  wire [7:0] 	DDAT;           /* Video data to a RAMDAC       */
  assign 	DDAT= { 4'b0, 4'b0 };

  tri		DDC;            /* Data from DDC1 compatible monitor  */
  tri		DDC2_CLK;	/* DDC2 "clock"			*/

  // SIMULATION ENVIRONMENT REGISTERS.
  reg 		enable_64;
  reg [11:0] 	mw0_mask, mw1_mask;
  reg [19:0] 	aw_mask;
  reg [3:0] 	aw_size;
  reg [64:0] 	hb_ad_bus;
  reg [31:0] 	config_reg;
  reg [31:0] 	temp_config;
  reg 		config_en;
  reg [31:0] 	rbase_io;
  reg [31:0] 	rbase_g;  // holding register for the global base address.    
  reg [31:0] 	rbase_w;  // holding register for the memory windows base addr
  reg [31:0] 	rbase_a;  // holding register for drawing engine A base addr  
  reg [31:0] 	rbase_aw; // holding reg for drawing engine A cache base addr 
  reg [31:0] 	rbase_b;  // holding register for drawing engine B base addr  
  reg [31:0] 	rbase_bw; // holding reg for drawing engine B cache base addr 
  reg [31:0] 	rbase_i;  // holding register for interrupt register address. 
  reg [31:0] 	rbase_e;  // holding register for EPROM base address.
  reg [31:0] 	rbase_mw0;
  reg [31:0] 	rbase_mw1;
  reg [1:0] 	mw0_size, mw1_size;
  reg [31:0] 	test_reg; // holding register for read.		 	      
  reg [15:0] 	h;
  reg [15:0] 	i;
  reg [15:0] 	j;
  reg [15:0] 	k;
  reg [15:0] 	l;
  reg [15:0] 	m;
  reg [15:0] 	n;
  reg [15:0] 	o;
  reg [15:0] 	p;
  reg [15:0] 	w;
  reg [15:0] 	xs;
  reg [15:0] 	ys;
  reg [15:0] 	xd;
  reg [15:0] 	yd;
  reg [15:0] 	xe;
  reg [15:0] 	ye;
  reg [15:0] 	xs_inc;
  reg [15:0] 	ys_inc;
  reg [15:0] 	xe_inc;
  reg [15:0] 	ye_inc;
  reg [15:0] 	zx;
  reg [15:0] 	zy;
  // From reg.h file.
  integer ramdac_dump_file;
  reg     ramdac_dump_en;

  reg     [31:0] start_time;
  reg     [31:0] stop_time;
  reg     [31:0]  test_counter;
  reg     [31:0]  sliv_counter;

  reg     [7:0] alpha_data;
  reg     [7:0] red_data;
  reg     [7:0] green_data;
  reg     [7:0] blue_data;
  reg     [7:0] next_red;
  reg     [7:0] next_green;
  reg     [7:0] next_blue;
  real	      ld_clk_edge1;
  real	      ld_clk_edge2;
  real	      clk_freq;
  reg toggle_cursor;

`ifdef RXF_TST
	reg	     	save_flag;
	reg	[11:0]	save_ram_adr;
	reg     [31:0] 	save_ram [0:4095];
	reg     [1:0] 	remain;
	reg     [15:0] 	w_count;
	reg     [15:0] 	r_count;
	reg     [31:0] 	fore;
	reg     [31:0] 	back;
	reg            	force_wrt;
	reg     [31:0] 	o_mask;
	reg     [31:0] 	r_mask;
`endif

  /////////////////////////// external bus models ///////////////////////////
  wire 		AGPT_CLK;	  
  wire 		AGPM_CLK;	  
  wire [2:0] 	st_agpt;
  wire [3:0] 	c_be_in;
  wire 		frame_in;
  wire 		irdy_in;
  wire [7:0] 	req_arb;
  wire [7:0] 	gnt_tarb;
  tri [7:0] 	gnt_marb;
  reg 		LMC_RSTn;
  wire [63:0] 	AD64;
  wire [7:0] 	CBE64;
  wire [7:1] 	idsel;
  wire 		PERR;
  wire 		SERR;
  wire 		LOCK;
  wire 		SBO;
  wire 		SDONE;
  wire 		INTB; 
  wire 		INTC;
  wire 		INTD;
  wire		bios_rdat;
  wire		bios_clk;
  wire		bios_wdat;
  wire		bios_csn;
  wire		bios_wrn;
  wire		bios_hld;
  wire [(BYTES/4)-1:0] DQS, DQSn;
  wire [(BYTES/4-1):0] DM;
  wire 		ODT;
  wire 		RST;
  wire 		pixclk;
  wire [19:0] 	gpio_3v;
  wire		dvo_de;
  wire [23:0]	dvo_data;
  
  initial REQ_RWTn = 1;
  initial REQ_DMn = 1;
  initial RBFn = 1; 
  reg 		rwt_read_log; 
  initial rwt_read_log = 0; //enable for read logging
  reg 		rwt_write_log; 
  initial rwt_write_log = 0; //enable for write logging
  integer 	rwt_log; 
  initial rwt_log = 0; // File pointer for rw_tasks

`include "../../stim/includes/svga_reg_const.v"

`ifdef INCLUDES_IN_CWD 
 `include "reg.h"
`endif

  // PCI_WOM CONFIG REGISTERS 
  reg [31:0] 	pcim_masks; 
  
`ifdef PCIM_MASKS
  initial pcim_masks = `PCIM_MASKS;
`else   
  initial pcim_masks = 32'hffff_ffff; //Set all masks
`endif   

  reg 		FIRST_RESET;	/* Flag that controls hold time for host
                                 * when multiple resets issued */
  reg 		ENABLE_MEM;	/* Turns on memory data drivers after
                                 * MC tristates disabled */
  reg [63:0] 	cycle_s;	// Display strings for MC
  reg [63:0] 	sequence_s;	// Display strings for MC
  reg 		ddc_con;        /* connects external DDC1 data and clock */
  reg 		DDC_IN;         /* temp register for DDC data in */
  reg 		DDC2_CLK_IN;     /* temp register for DDC2_CLK in */
  
  reg [2:0] 	rom_base;
  reg [9:0] 	mov_dw_counter, rd_counter, pci_master_movdw_counter;
  reg [3:0] 	retry_count;
  reg 		trdyy_n, stopp_n;
  reg [4:0] 	count;
  reg [10:0] 	write_index, write_index_1, read_index;
  reg [31:0] 	write_mem_table[0:2500]; //2K entry
  reg [31:0] 	write_mem_table_1[0:2500]; //2K entry
  reg [31:0] 	read_mem_table [0:2500]; //2K entry
  reg 		write_flag_n, write_flag_1_n, read_flag_n;
  
  reg 		framee_n, prdyy_n;          /* to allow tri-state with dma */
  reg [7:0] 	byte_ens;             /* to allow tri-state with dma */
  reg           req64_n;
  reg 		transmit_64;          // are we transmitting 64 bits to host
  
  integer 	fname, fname1, results, channel;
  
  event 	start_waves, conn_ddc, discon_ddc ;
  
  reg [19:0] 	TEST_COUNT;                          /* TEST COUNT register */
  reg [1:0] 	inc_trans;
  reg 		last_xfer;            // Last part of PCI transfer
  reg 		xfer_odd;             // This xfer is at the start and odd
  reg 		retransmit;
  reg 		pll_clka, pll_clkb, pll_xbuf;
  
  // INCLUDES 
  
`include "../../stim/includes/clks_params.h"

  // Some defaults for unused 64 bit I/O

  assign 	IDSEL_p = IDSEL;

  always @* EX_MCLK_FB = MCLK;

  /**************************************************************************/
  graph_core 
    #
    (
     .BYTES          (BYTES)
     )
  U0 
    (
     .hclock         (HCLK),
     .hresetn        (RSTn),
     .pframen        (FRAMEn),
     .pirdyn         (PRDYn),
     .ptrdyn         (TRDYn),
     .pdevseln       (DEVSELn),
     .pidsel         (1'b1),
     .pintan         (INTRP),
     .pstopn         (STOPn),
     .ppar           (PAR),
     .preqn          (REQn),
     .pgnntn         (GRANTn),
     .pcben          (C_BEn[3:0]),
     .pad            (AD[31:0]),
     .bios_rdat      (bios_rdat),
     .bios_clk       (bios_clk),
     .bios_wdat      (bios_wdat),
     .bios_csn       (bios_csn),
     .bios_wrn       (bios_wrn),
     .bios_hld       (bios_hld),
     .pll_xbuf       (pll_xbuf),
     .pll_clka       (pll_xbuf),
     .pll_clkb       (pll_clkb),
     //.pll_sclk       (),
     //.pll_sdat       (),
     // DVI Display Interface
     .dvo_dclk       (pixclk),
     .dvo_hsync      (HSYNC),
     .dvo_vsync      (VSYNC),
     .dvo_de         (dvo_de), 
     .dvo_data       (dvo_data),
     .dvo_bsel_scl   (),
     .dvo_dsel_sda   (),
     .dac_psaven     (),
     .dac_cblankn    (),
     .dac_csyncn     (),
     .dac_sog        (),
     .bt_clko        (),	  // Clock input from the BT868.
     .bt_hsyncn      (),	  // Hsync input from the BT868.
     .bt_vsyncn      (), 	  // Vsync input from the BT868.
     .bt_blankn      (),	  // Blank input from the BT868.
     .bt_field       (),	  // Field input from the BT868.
     .bt_pal         (),	  // 1 = PAL, 0 = NTSC.
     
     // Memory outputs
     .mem_odt        (ODT),
     .mem_cs_n       (CSn),
     .mem_cke        (CKE),
     .mem_addr       (RAD),
     .mem_ba         (BA),
     .mem_ras_n      (RAS),
     .mem_cas_n      (CAS),
     .mem_we_n       (WEn),
     //.mem_rst_n      (RST),
     .mem_dm         (DM[3:0]),
     
     .mem_clk        (MCLK),
     .mem_clk_n      (MCLKn),
     .mem_dq         (PDAT[31:0]),
     .mem_dqs        (DQS[3:0]),
     .mem_dqsn       (DQSn[3:0]),
     // DDC signals.
     .ddc_scl        (DDC2_CLK),
     .ddc_sda        (DDC), 
     // User configuration jumpers.
     .t2r4_mode      (1'b1),
     .mb_32_sel      (1'b1),
     .vga_en         (1'b0), // 0 = enable
     .dual_enn       (1'b1),
     .m66_en         (1'b0),
     .ledn           (),
     .gpio_3v        (gpio_3v)
     );

  // Dedicated lines for ImaginePC, RW_TASKS, & PCI_REQUEST
`ifdef PCI66 // AGP Monitor acts as the arbiter
 `ifdef SH_LOW_PRI //ImaginePC is lowest priority, RW_TASKS is highest.
  assign GNT_RWTn = gnt_marb[0];
  assign GNT_DMn = gnt_marb[1];
  assign GRANTn = gnt_marb[2];
 `else //ImaginePC is highest priority (needed for bus parking.)
  assign GRANTn = gnt_marb[0];
  assign GNT_RWTn = gnt_marb[1];
  assign GNT_DMn = gnt_marb[2];
 `endif
`else   
  assign GRANTn = 1;  // RW_TASKS has the bus, as no mastering from ImaginePC
  assign GNT_RWTn = 0;// can be performed for this setting.
  assign GNT_DMn = 1;
`endif   

`ifdef SH_LOW_PRI //ImaginePC is lowest priority, RW_TASKS is highest.
  assign req_arb = {5'h1f, REQn, REQ_DMn, REQ_RWTn};
`else //ImaginePC is highest priority (needed for bus parking.)   
  assign req_arb = {5'h1f, REQ_DMn, REQ_RWTn, REQn};
`endif

  //Behavioral buffers for functional models
  INBUF TAR0 (C_BEn[0], c_be_in[0]);
  INBUF TAR1 (C_BEn[1], c_be_in[1]);
  INBUF TAR2 (C_BEn[2], c_be_in[2]);
  INBUF TAR3 (C_BEn[3], c_be_in[3]);
  INBUF TAR4 (FRAMEn, frame_in);
  INBUF TAR5 (PRDYn, irdy_in);
  
  // PCI Bus Functional Model
  PCI_TARGET U_PCI_TARGET
    ( 
      .RSTn    (RSTn), 
      .HCLK    (HCLK), 
      .AD      (AD[31:0]), 
      .C_BEn   (c_be_in), 
      .FRAMEn  (frame_in), 
      .IRDYn   (irdy_in), 
      .TRDYn   (TRDYn), 
      .DEVSELn (DEVSELn), 
      .STOPn   (STOPn)
      );
  
  always @(rwt_log) U_PCI_TARGET.pci_log = rwt_log;

`ifdef PCI66 // Disable AGP Target
  assign AGPT_CLK = 0;
  assign AGPM_CLK = HCLK;
`else // Disable both LMC models
  assign AGPT_CLK = 0;
  assign AGPM_CLK = 0;
`endif

  /*
  // PCI & AGP Protocol Checker
  agpmonitor U_AGP_MONITOR
    (
     .clk      (AGPM_CLK),
     .rstnn    (LMC_RSTn),
     .ad       (AD64),
     .cxbenn   (CBE64),
     .par      (PAR),
     .framenn  (FRAMEn),
     .trdynn   (TRDYn),
     .irdynn   (PRDYn),
     .stopnn   (STOPn),
     .devselnn (DEVSELn),
     .idsel    ({idsel[7:1],IDSEL}),
     .perrnn   (PERR),
     .serrnn   (SERR),
     .reqnn    (req_arb),
     .gntnn    (gnt_marb),
     .locknn   (LOCK),
     .par64    (PAR64),
     .req64nn  (REQ64),
     .ack64nn  (ACK64),
     .sbonn    (SBO),
     .sdone    (SDONE),
     .intann   (INTRP),
     .intbnn   (INTB),
     .intcnn   (INTC),
     .intdnn   (INTD),
     .pipenn   (PIPEn),
     .st       (ST),
     .sba      (SBA),
     .adstb0   (AD_STB0),
     .adstb1   (AD_STB1),
     .rbfnn    (RBFn),
     .sbstb    (sb_stb_in_d)
     );
   defparam U_AGP_MONITOR.fm.version             = "pci66";
   defparam U_AGP_MONITOR.fm.gen_global          = `false;
   defparam U_AGP_MONITOR.fm.gen_debug_level     = 0;
   defparam U_AGP_MONITOR.fm.agpconfigindex 	 = 0;
`ifdef PCI66
   defparam U_AGP_MONITOR.fm.arbitrate 	 = `true;
`ifdef AGPM_PRIORITY
   defparam U_AGP_MONITOR.fm.priority 	 = `AGPM_PRIORITY;
`else   
   defparam U_AGP_MONITOR.fm.priority 	 = 0;
`endif
   defparam U_AGP_MONITOR.fm.parkzero 	 = `true;
`else // By default, the AGP Monitor is not the arbiter!
   defparam U_AGP_MONITOR.fm.arbitrate 	 = `false;
   defparam U_AGP_MONITOR.fm.priority 	 = 0;
   defparam U_AGP_MONITOR.fm.parkzero 	 = `false;
`endif   
`ifdef AGPM_CMDFILE
   defparam U_AGP_MONITOR.fm.cmd_file    = `AGPM_CMDFILE;
`else
   defparam U_AGP_MONITOR.fm.cmd_file    = "/u/hammer/stim/agpmonitor.cmd";
`endif
`ifdef AGPM_LOGFILE
   defparam U_AGP_MONITOR.fm.trace_file  = `AGPM_LOGFILE;
`else
   defparam U_AGP_MONITOR.fm.trace_file  = "agpmonitor.log";
`endif   
`ifdef MONITOR_MESG   
   defparam    U_AGP_MONITOR.fm.disablemsg 	 = `false;
`else
   defparam    U_AGP_MONITOR.fm.disablemsg 	 = `true;
`endif   
`ifdef AGPMIN
   defparam U_AGP_MONITOR.fm.gen_option = `lmv_minimum; 
`endif
`ifdef AGPMAX
   defparam U_AGP_MONITOR.fm.gen_option = `lmv_maximum;
`endif

   */   

  // Make sure unused pins are inactive
  assign AD64 = AD;
  assign CBE64 = C_BEn;
  assign idsel[7:1] = 7'b1;
  assign PERR = 1'bz;
  assign SERR = 1'bz;
  assign LOCK = 1'bz;
  assign SBO = 1'bz;
  assign SDONE = 1'bz;
  assign INTB = 1'bz; 
  assign INTC = 1'bz;
  assign INTD = 1'bz;

  pullup (PERR);

  reg 	 FRAMEn_last;
  reg 	 DEVSELn_last;
  reg 	 IRDYn_last;
  reg 	 TRDYn_last;
  reg 	 STOPn_last;
  reg 	 frame_en_last;
  reg 	 devsel_en_last;
  reg 	 irdy_en_last;
  reg 	 trdy_en_last;
  reg 	 stop_en_last;

  /*
  // Additional PCI protocol checks that current version of the agp 
  // monitor doesn't catch (corresponds to /u/synopsys-lm/doc/agpmonitor.txt)
  always @(posedge HCLK) begin
    //PCI 49
    if (DEVSELn && !TRDYn) begin
      $display ("\nPCI PROTOCOL ERROR 49 at time %0t",$time);
      $display ("TRDYn must be deasserted the cycle immediately following the completion of the last data phase (3.3.3.2.1)\n");
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 49  TRDYn must be deasserted the cycle immediately following the completion of the last data phase (3.3.3.2.1)");
    end
    //PCI 64
    if (DEVSELn && !STOPn) begin
      $display ("\nPCI PROTOCOL ERROR 64 at time %0t",$time);
      $display ("STOPn must be deasserted the cycle immediately following the completion of the last data phase (3.3.3.2.1)\n");
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 64  STOPn must be deasserted the cycle immediately following the completion of the last data phase (3.3.3.2.1)");
    end
    //PCI 52 - TRDYn
    if (!TRDYn_last && !trdy_en_last && U0.hb_ctrl_oe) begin
      $display ("\nPCI PROTOCOL ERROR 52 at time %0t",$time);
      $display ("TRDYn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1)\n"); 
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 52  TRDYn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1) ");
    end
    //PCI 53 - IRDYn
    if (!IRDYn_last && !irdy_en_last && U0.irdy_oe_n) begin
      $display ("\nPCI PROTOCOL ERROR 53 at time %0t",$time);
      $display ("IRDYn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1)\n"); 
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 53  IRDYn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1) ");
    end
    //PCI 54 - FRAMEn
    if (!FRAMEn_last && !frame_en_last && U0.frame_oe_n) begin
      $display ("\nPCI PROTOCOL ERROR 54 at time %0t",$time);
      $display ("FRAMEn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1)\n"); 
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 54  FRAMEn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1) ");
    end
    //PCI 55 - DEVSELn
    if (!DEVSELn_last && !devsel_en_last && U0.devsel_oe) begin
      $display ("\nPCI PROTOCOL ERROR 55 at time %0t",$time);
      $display ("DEVSELn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1)\n"); 
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 55  DEVSELn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1) ");
    end
    //PCI 56 - STOPn
    if (!STOPn_last && !stop_en_last && U0.hb_ctrl_oe) begin
      $display ("\nPCI PROTOCOL ERROR 56 at time %0t",$time);
      $display ("STOPn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1)\n"); 
      $fdisplay (U_AGP_MONITOR.fm.lfile,"PCI ERROR           : 56  STOPn, a Sustained Tri-State signal must be driven high for 1 clock before being Tri-Stated (2.1) ");
    end
    
    FRAMEn_last <= FRAMEn;
    DEVSELn_last <= DEVSELn;
    IRDYn_last <= PRDYn;
    TRDYn_last <= TRDYn;
    STOPn_last <= STOPn;
    
    frame_en_last <= U0.frame_oe_n;
    devsel_en_last <= U0.devsel_oe;
    irdy_en_last <= U0.irdy_oe_n;
    trdy_en_last <= U0.hb_ctrl_oe;
    stop_en_last <= U0.hb_ctrl_oe;
  end
*/
   
  //////////////////////// INSTANTIATE MEMORY BUFFERS /////////////////////////
`ifdef FAST_MEM_FULL
  fast_mem_tasks VR ();
`else
  ddr3_int_full_mem_model VR
    (
     // inputs:
     .mem_addr          (RAD),
     .mem_ba            (BA),
     .mem_cas_n         (CAS),
     .mem_cke           (CKE),
     .mem_clk           (MCLK),
     .mem_clk_n         (MCLKn),
     .mem_cs_n          (CSn),
     .mem_dm            (DM),
     .mem_odt           (ODT),
     .mem_ras_n         (RAS),
     .mem_rst_n         (RST),
     .mem_we_n          (WEn),
     
     // outputs:
     .global_reset_n    (),
     .mem_dq            (PDAT[31:0]),
     .mem_dqs           (DQS[3:0]),
     .mem_dqs_n         (DQSn[3:0])
     );
`endif

  /////////////////////////// PERIPHERAL DEVICES //////////////////////////////
  /****************************************************************************
   Serial PROM for BIOS.
   ************************************************************************/
  m25p40 SPR
	(
	.c		(bios_clk),
	.data_in	(bios_wdat),
	.s		(bios_csn),
	.w		(bios_wrn),
	.hold		(bios_hld),

	.data_out	(bios_rdat)
	);
 
  // CREATE tristate driver for DDC

  assign DDC = (!ddc_con || !RSTn)? 1'bz: DDC_IN;
  //toggle DDC_IN  directly in local stim files

  assign DDC2_CLK = (!ddc_con || !RSTn)? 1'bz: DDC2_CLK_IN;
  //toggle DDC2_CLK_IN  directly in local stim files
  
  // DDC data direction
 
  always @conn_ddc     begin                        ddc_con=1'b1; end
  always @discon_ddc   begin                        ddc_con=1'b0; end
 
  // CREATE tristate drivers for AD bus & pci control sigs 
  assign AD         = hb_ad_bus;
  assign TRDYn      = trdyy_n;
  assign STOPn      = stopp_n;   
  assign C_BEn      = byte_ens;
  // RW_TASKS now drive the bus only at the appropriate time
  assign PRDYn      = prdyy_n;  
  assign FRAMEn     = framee_n;
  
  // pullup pci control sigs as they would be on the motherboard
  pullup (FRAMEn);
  pullup (PRDYn);
  pullup (DEVSELn);
  pullup (TRDYn);
  pullup (STOPn);

  // CREATE CLOCKS.                   
  always begin  
    // #(hclk_hi)HCLK=0;
    // #(hclk_low)HCLK=1;
    #15 HCLK=0;
    #15 HCLK=1;
  end

  // CREATE CLOCKS.                   
  always begin  
    #20 pll_xbuf=0;
    #20 pll_xbuf=1;
  end

  // CREATE CLOCKS.                   
  always begin  
    #5 pll_clka=0;
    #5 pll_clka=1;
  end

  // CREATE CLOCKS.                   
  always begin  
    #5 pll_clkb=0;
    #5 pll_clkb=1;
  end

  // Memory Clock 100MHz (CLKA).
  always begin
    //#3 MEMORY_CLK=0;
    //#3 MEMORY_CLK=1;
    #4.5 MEMORY_CLK=0;
    #4.5 MEMORY_CLK=1;
  end

  // START SIMULATION (MAIN INITIAL BLOCK)            
  initial begin 

`ifdef SEE_CONFIG
  $vcdpluson; 
`endif
   
    ENABLE_MEM	= 0;
    FIRST_RESET = 1;
    config_en       = 1;
    mov_dw_counter=0;
    rd_counter = 0;
    pci_master_movdw_counter = 0;
    retry_count=0;
    count = 0;
    
    ddc_con        =0; // DDC pin external driver disconnected
    DDC_IN         =0;
    DDC2_CLK_IN    =0;
    TEST_COUNT      = 0;
    
`ifdef TV    //for test vectors only
    con_spec_inp   =0;
    TEST_STROBE     = 0;
    TIME_STAMP      = 0;
 `ifdef TEST
    open_tpt(test_file_name);
    open_vpat(test_file_name);
 `endif
    
    #(test_period);
    RSTn=0;
    LMC_RSTn = 1'b0;
    config_en       = 1;
    //FRAMEn       = 1'bz;
    //PRDYn        = 1'bz;
    #(test_period);
    //FRAMEn       = 1;
    //PRDYn        = 1;
    // PRDYn           = 1;
    IDSEL           = 1;
    // C_BEn           = 4'hf;
    
`else
 `ifdef ANY_CLOCKS
    
 `else
    HCLK = 1;
 `endif
    
`endif
    
    // loads memory from a file (only if one of VGA mode is defined)
`include "../../stim/tasks/vga_mode_set"

    RSTn = 1'b0;
    #(hclk);
    LMC_RSTn = 1'b0;
    //@(posedge HCLK) ;
    repeat (100) @(negedge HCLK) ;  
    @(negedge HCLK) // was U0.PCICLK
      RSTn = 1'b1;
    LMC_RSTn = 1'b1;
    @(posedge HCLK) ; // was U0.PCICLK
    initialize(0);	/* default configuration. */

    $display("Wait for the DDR3 Contoller.");
    // Wait for the DDR2 Controller to come up
    wait (gpio_3v[0]);
    $display("DDR3 Contoller now up.");

    #(1000*hclk);
    #(20*hclk);
    mov_dw (IO_WR, rbase_io + SGR_CONFIG,     32'h0996A020, 4'h0, 1); //SGRAM CON
    mov_dw (IO_WR, rbase_io + SGR_CONFIG,     32'h8996A020, 4'h0, 1); //SGRAM CON
    #(50*hclk);
    
    $display("issue soft reset"); 
    mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0000_0022, 4'he, 1 );
    #(200*hclk);
    //remove reset
    mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0000_0020, 4'he, 1 );
    
    VR.ram_fill32 (0,20,0);
    
    //`include "init.h"
    //*****************
    // INITAL SETUP
    //*****************
    
    #(20*hclk);
    mov_dw (IO_WR, rbase_io + SGR_CONFIG,     32'h0996A020, 4'h0, 1); //SGRAM CON
    mov_dw (IO_WR, rbase_io + SGR_CONFIG,     32'h8996A020, 4'h0, 1); //SGRAM CON
    #(50*hclk);
    
    //`include "initial_setup.h"
    //disable all address decoding
    mov_dw(IO_WR, rbase_io + CONFIG1, 32'h0000_3f34, 4'h0, 1 );
    
    //set up the memory window addresses
    mov_dw(MEM_WR, rbase_a + XYC_AD, 32'h1000_0000, 4'h0, 1); // 4 KBytes
    
    mov_dw(MEM_WR, rbase_w + MW0_AD, 32'h4000_0000, 4'h0, 1);
    mov_dw(MEM_WR, rbase_w + MW0_SZ, 32'h0000_000A, 4'h0, 1); // 4 MBytes
    mov_dw(MEM_WR, rbase_w + MW1_AD, 32'hA000_0000, 4'h0, 1);
    mov_dw(MEM_WR, rbase_w + MW1_SZ, 32'h0000_000A, 4'h0, 1); // 4 MBytes
    
    //enable all address decoding
    mov_dw(IO_WR, rbase_io + CONFIG1, 32'h00ff_f734, 4'h0, 1 );
    
    //set up the number of wait states (0 wait state) for BLKBIRD reads/writes
    mov_dw(IO_WR, rbase_io + CONFIG2, 32'h0010_0000, 4'h1, 1);
    
    //`include "setup_def_2kp.h"
    /* clear interrupt register. */
 mov_dw(MEM_WR, rbase_a+INTP, 32'h0000_0000, 4'h0, 1 );
 
/* clear interrupt mask register. */
 mov_dw(MEM_WR, rbase_a+INTM, 32'h0000_0000, 4'h0, 1 );
 
/* read the flow register. */
 rd(MEM_RD, rbase_a+FLOW,1);
 
/* read the busy register. */
 rd(MEM_RD, rbase_a+BUSY,1);
 
/* set the buffer control register. */
 mov_dw(MEM_WR, rbase_a+BUF_CTRL, 32'h0000_0000, 4'h0, 1 );
 
/* set the buffer control register. */
 mov_dw(MEM_WR, rbase_a+XYW_AD, 32'h1000_0000, 4'h0, 1 );
 
/* Set the Drawing engine source origins equals zero. */
 mov_dw(MEM_WR, rbase_a+DE_SORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+DE_DORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+DE_ZORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD0_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD1_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD2_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD3_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD4_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD5_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD6_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD7_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD8_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+LOD9_ORG,32'h0000_0000, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+TPAL_ORG,32'h0000_0000, 4'h0, 1 );
 //mov_dw(MEM_WR, rbase_a+HITH,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+YON,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+FOG_COL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+ALPHA,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+TBORDER,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V0A_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V0R_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V0G_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V0B_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V1A_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V1R_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V1G_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V1B_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V2A_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V2R_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V2G_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+V2B_FL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+KEY3D_LO,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+KEY3D_HI,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CMD3,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+A_CNTRL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+ACNTRL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+I3D_CNTRL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+TEX_CNTRL,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP0,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP1,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP2,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP3,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP4,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP5,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP6,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP7,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP8,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP9,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP10,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP11,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP12,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP13,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP14,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP15,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP16,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP17,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP18,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP19,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP20,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP21,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP22,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP23,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+CP24,32'h0,4'h0, 1);
 //mov_dw(MEM_WR, rbase_a+GLBLENDC,32'h0,4'h0, 1);

/* Drawing engine KEY equals zero. */
 mov_dw(MEM_WR, rbase_a+DE_KEY,32'h0000_0000, 4'h0, 1 );
 
/* Set the Drawing engine pitches  = 40h (64x16bytes=1024). */
 mov_dw(MEM_WR, rbase_a+DE_SPTCH,32'h0000_0400, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+DE_DPTCH,32'h0000_0400, 4'h0, 1 );
 mov_dw(MEM_WR, rbase_a+DE_ZPTCH,32'h0000_0400, 4'h0, 1 );
 
/* Drawing engine foreground = ffff. */
 mov_dw(MEM_WR, rbase_a+FORE,32'h9999_9999, 4'h0, 1 );
 
/* Drawing engine background = bbbb. */
 mov_dw(MEM_WR, rbase_a+BACK,32'hbbbb_bbbb, 4'h0, 1 );
 
/* Drawing engine plane mask = ffffffff. */
 mov_dw(MEM_WR, rbase_a+MASK,32'hffff_ffff, 4'h0, 1 );
 
/* Drawing engine line pattern register = ffffffff. */
 mov_dw(MEM_WR, rbase_a+LPAT,32'hffff_ffff, 4'h0, 1 );
 
/* Drawing engine line pattern control register = 0. */
 mov_dw(MEM_WR, rbase_a+PCTRL,32'h0000_0000, 4'h0, 1 );
 
/* Drawing engine clipping top left corner (0,0). */
 mov_dw(MEM_WR, rbase_a+CLPTL,32'h0000_0000, 4'h0, 1 );
 
/* Drawing engine clipping bottom right corner (1024,1024). */
 mov_dw(MEM_WR, rbase_a+CLPBR,32'h03ff_03ff, 4'h0, 1 );
 
    //`include "cache_setup.h"
    //*****************
// GALEN INITAL SETUP
//*****************
//disable all address decoding
 mov_dw(IO_WR, rbase_io + CONFIG1, 32'h0000_3f34, 4'h0, 1 );
 
//set up the memory window addresses
//mov_dw(MEM_WR, rbase_a + XYC_AD, 32'h1000_0000, 4'h0, 1); // 4 KBytes
mov_dw(MEM_WR, rbase_a + XYC_AD, 32'h1000_0400, 4'h0, 1); // 4 KBytes
 
mov_dw(MEM_WR, rbase_w + MW0_AD, 32'h4000_0000, 4'h0, 1);
mov_dw(MEM_WR, rbase_w + MW0_SZ, 32'h0000_000A, 4'h0, 1); // 4 MBytes
mov_dw(MEM_WR, rbase_w + MW1_AD, 32'hA000_0000, 4'h0, 1);
mov_dw(MEM_WR, rbase_w + MW1_SZ, 32'h0000_000A, 4'h0, 1); // 4 MBytes
 
//enable all address decoding
 mov_dw(IO_WR, rbase_io + CONFIG1, 32'h00ff_f734, 4'h0, 1 );
 
//set up the number of wait states (0 wait state) for BLKBIRD reads/writes
 mov_dw(IO_WR, rbase_io + CONFIG2, 32'h0010_0000, 4'h1, 1);

    rd(IO_RD, rbase_io+CONFIG2, 1);//read CONFIG 2 register
    mov_dw (IO_WR, rbase_io+CONFIG2, (test_reg | 32'h0003_0000), 4'b1011, 1); // Set dac 5 clocks low, 16 High min.
    
    $display("Wait for the DDR3 Contoller.");
    // Wait for the DDR2 Controller to come up
    wait (gpio_3v[0]);
    $display("DDR3 Contoller now up.");

    `include "the_test.h"

    #(5*hclk) $finish;
  end // initial begin
  
  task write_pal;
    input [7:0] red, green, blue;
    begin
      $display("Loading Palette");
      mov_dw (IO_WR, 32'h3c9, red,   4'h0, 1); // R
      mov_dw (IO_WR, 32'h3c9, green, 4'h0, 1); // G
      mov_dw (IO_WR, 32'h3c9, blue,  4'h0, 1); // B
    end
  endtask // write_pal
  
  //  	TASK TO INITIALIZE CONFIGUARTION Defaults:
  task set_config;
    input	[5:0]	field;
    input	[31:0]	data;
    begin

/* -----\/----- EXCLUDED -----\/-----
      case(field)
	BASE0_1:force U0.window_size_strap = data[1:0];  /-* size (0&1)*-/
	EE:	force U0.eprom_strap       = data[0];    /-* EPR.enable*-/
	CLASS:	force U0.class_strap       = data[0];    /-* PCI CLASS *-/
	VDEN:	force U0.mem_dens_strap    = data[1:0];  /-* MEM DENS  *-/
	IDAC:	force U0.idac_strap        = data[0];    /-* INT RAMDAC*-/
	SGRAM:	force U0.mem_type_strap    = data[0];    /-* SGRAM bit *-/
	HBT:	force U0.hbt_strap         = data[0];    /-* PCI/AGP   *-/
        SUB_ID: force U0.sbsys_id_strap    = data[5:0];  /-* subs. ID  *-/
        ID_DEF: force U0.sbvend_sel_strap  = data[0];    /-* others/#9 *-/
        SUB_VID:force U0.sbvend_id_strap   = data[15:0]; /-* sub.ven.ID*-/
	
        ALL:    begin
	  force U0.window_size_strap = data[31:30]; /-* size (0&1)*-/
	  force U0.eprom_strap       = data[29];    /-* EPR.enable*-/
	  force U0.class_strap       = data[28];    /-* PCI CLASS *-/
	  force U0.mem_dens_strap    = data[27:26]; /-* MEM DENS  *-/
	  force U0.idac_strap        = data[25];    /-* INT RAMDAC*-/
	  force U0.mem_type_strap    = data[24];    /-* SGRAM bit *-/
	  force U0.hbt_strap         = data[23];    /-* PCI/AGP   *-/
          force U0.sbsys_id_strap    = data[22:17]; /-* subs. ID  *-/
          force U0.sbvend_sel_strap  = data[16];    /-* others/#9 *-/
          force U0.sbvend_id_strap   = data[15:0];  /-* sub.ven.ID*-/
	end

        PULLUP: begin
	  force U0.window_size_strap = 2'b11;     /-* size (0&1)*-/
	  force U0.eprom_strap       = 1'b1;      /-* EPR.enable*-/
	  force U0.class_strap       = 1'b1;      /-* PCI CLASS *-/
	  force U0.mem_dens_strap    = 2'b11;     /-* MEM DENS  *-/
	  force U0.idac_strap        = 1'b1;      /-* INT RAMDAC*-/
	  force U0.mem_type_strap    = 1'b1;      /-* SGRAM bit *-/
	  force U0.hbt_strap         = 1'b1;      /-* PCI/AGP   *-/
          force U0.sbsys_id_strap    = 6'h3F;     /-* subs. ID  *-/
          force U0.sbvend_sel_strap  = 1'b1;      /-* others/#9 *-/
          force U0.sbvend_id_strap   = 16'hFFFF;  /-* sub.ven.ID*-/
	end
	
        CLEAR: begin
	  force U0.window_size_strap = 2'b0;    /-* size (0&1)*-/
	  force U0.eprom_strap       = 1'b0;    /-* EPR.enable*-/
	  force U0.class_strap       = 1'b0;    /-* PCI CLASS *-/
	  force U0.mem_dens_strap    = 2'b0;    /-* MEM DENS  *-/
	  force U0.idac_strap        = 1'b0;    /-* INT RAMDAC*-/
	  force U0.mem_type_strap    = 1'b0;    /-* SGRAM bit *-/
	  force U0.hbt_strap         = 1'b0;    /-* PCI/AGP   *-/
          force U0.sbsys_id_strap    = 6'b0;    /-* subs. ID  *-/
          force U0.sbvend_sel_strap  = 1'b0;    /-* others/#9 *-/
          force U0.sbvend_id_strap   = 16'b0;   /-* sub.ven.ID*-/
	end

        default: begin
          $display("Unknown field in set_config task"); 
          $stop;
        end
    endcase // UNMATCHED!!
 -----/\----- EXCLUDED -----/\----- */
    end
  endtask

  /***************************************************************************/
  /*    TASK TO INITIALIZE BLACKBIRD					     */
  /***************************************************************************/
  task initialize;
    input	[31:0]		con_string;
    begin
      @(posedge HCLK);
`ifdef TV
      @(negedge TEST_STROBE)  // if initialize is called from any place
	RSTn = 0;          // in simulation then in test vector environment 
      // the RSTn signal have to transition on test period
      // boundries or at least before rising edge of HCLK  
      // in the same test vectors
`else
      
      #0   
	RSTn = 0;
      
`endif

      hb_ad_bus = 64'hz;
      trdyy_n   = 1'hz;
      stopp_n   = 1'hz;
      framee_n  = 1'bz;
      prdyy_n   = 1'bz;
      byte_ens  = 8'hz;
      req64_n   = 1'bz;
      config_reg    = temp_config;

      /***********************************************************************/
      /* For PCI, rbase_io is assigned here, not by configuration jumpers !!!*/
      /***********************************************************************/
      rbase_io = 32'h9000;
      config_en = 1'b1;
      #(12*hclk) config_en = 1'b0;
      //#(15*hclk+2)RSTn = 1;   //hclk period and test_period are the same
	#(15*hclk+7)RSTn = 1;     // RSTn transitions before HCLK which is OK  
                                  // for test vectors
      #(15*hclk) req64_n   = 1'bz;

`ifdef TV    //for test vectors only
      #(2*hclk);
      config_en = 1'b1;
`else
      #(10*hclk);// NOTE: This causes bus contention on the PA lines... {SES}
      config_en = 1'b1;
`endif
      @ (posedge HCLK) #(Thld) ;	// Line up simulation to Thld after HCLK
      // Set the PCI I/O base = rbase_io
      mov_dw(CONFIG_WR, 32'h0000_0024, rbase_io, 4'h0, 1);
      rd(CONFIG_RD,32'h0000_0024,1);
      // Disable VGA Palette snooping, bus mastering, and io/mem accesses
      mov_dw(CONFIG_WR, 32'h0000_0004, 32'h07,   4'h0, 1);
      rd(CONFIG_RD,32'h0000_0004,1);
      // Set rq_depth, enable sba & agp and set data rate
      mov_dw(CONFIG_WR, 32'h0000_0088, {8'b0,14'h0,1'b0,1'b0,6'h0,2'b0}, 4'h0, 1);
      rd(CONFIG_RD,32'h0000_0088,1);
      
      // Enable all address decoding
      load_base("G",32'h100);
      load_base("W",32'h200);
      load_base("A",32'h800);
      load_base("B",32'h400);
      load_base("I",32'h500);
      load_base("E",32'h600);
      // Configure PCI_WOM to write to address xcabcab00
      mov_dw(IO_WR, rbase_io+32'he0, 32'hcabcab00, 4'h0, 1);
      mov_dw(IO_WR, rbase_io+32'he4, pcim_masks, 4'h0, 1);
   
      /***********************************************************************/
      /* Disable window decode (linear, XY) and enable register decode */
      /***********************************************************************/

      mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0000_ff00, 4'hc, 1 );
      // Readback PCI_WOM setup regs
      rd(MEM_RD, rbase_i+32'he0, 2);
   
      /***********************************************************************/
      /* Enable frame buffer drivers (data and control)		      */
      /***********************************************************************/
    
      mov_dw(IO_WR, rbase_io + CONFIG2, 32'h0010_0000, 4'h1, 1);

    end
  endtask
  /***************************************************************************/
  /* TASK TO LOAD THE BASE ADDRESSES.                      		     */
  /***************************************************************************/
  task load_base;
    input	[7:0]	reg_string;
    input	[31:0]	reg_address;
    begin

      if(reg_string=="G") begin
	mov_dw(IO_WR,rbase_io+RBASE_G,{reg_address[31:8],8'h0},0,1);
	rbase_g = {reg_address[31:8],8'h0};
      end
      
      if(reg_string=="W") begin
	mov_dw(IO_WR,rbase_io+RBASE_W,{reg_address[31:8],8'h0},0,1);
	rbase_w = {reg_address[31:8],8'h0};
      end

      if(reg_string=="A") begin
	mov_dw(IO_WR,rbase_io+RBASE_A,{reg_address[31:8],8'h0},0,1);
	rbase_a = {reg_address[31:8],8'h0};
      end

      if(reg_string=="B") begin
	mov_dw(IO_WR,rbase_io+RBASE_B,{reg_address[31:8],8'h0},0,1);
	rbase_b = {reg_address[31:8],8'h0};
      end

      if(reg_string=="I") begin
	mov_dw(IO_WR,rbase_io+RBASE_I,{reg_address[31:8],8'h0},0,1);
	rbase_i = {reg_address[31:8],8'h0};
      end

      if(reg_string=="E") begin
	mov_dw(IO_WR,rbase_io+RBASE_E,reg_address[31:0],0,1);
	rbase_e = {reg_address[31:8],8'h0};
      end
    end
  endtask
  /***************************************************************************/
  /*   	 INCLUDE HOST READ AND WRITE TASKS             		      */
  /***************************************************************************/
`include "../../stim/tasks/rw_tasks64.v"
  
  /***************************************************************************/
  /*   	     Simple task to issue PCI requests like a Bus Master             */
  /***************************************************************************/
  task pci_request;
    begin
      REQ_DMn = 0; //Make request
      @(posedge HCLK);
      while(GNT_DMn) @(posedge HCLK);//Wait for grant
      REQ_DMn = 1; //Deassert request
      @(posedge HCLK);
    end
  endtask
	
  /***************************************************************************/
  task wait_for_pipe_not_busy;
    begin
      rd(MEM_RD, rbase_a+BUSY,1);
      while (test_reg[0]) rd(MEM_RD, rbase_a+BUSY,1);
    end
  endtask
  /***************************************************************************/
  task wait_for_pipe_a;
    begin
        rd(MEM_RD, rbase_a+BUSY,1);
        while (test_reg[0]) rd(MEM_RD, rbase_a+BUSY,1);
    end
  endtask

  task wait_for_pipe_ax;
    begin
        wait_for_pipe_a;
        wait_for_de_a;
        wait_for_mc_a;
	VR.save_fbmp(32'h0, 32'h120, 32'h90, "junk", 32'h600, 2'h2);
	$stop;
    end
  endtask
  /**************************************************************************/
  task wait_for_prev_a;
    begin
          rd(MEM_RD, rbase_a+FLOW,1);
          while (test_reg[3]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /***************************************************************************/
  task wait_for_de_not_busy;
    begin
      rd(MEM_RD, rbase_a+FLOW,1);
      while (test_reg[0] | test_reg[4]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /***************************************************************************/
  task wait_for_de_a;
    begin
      rd(MEM_RD, rbase_a+FLOW,1);
      while (test_reg[0] | test_reg[4]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /***************************************************************************/
  task wait_for_mc_not_busy;
    begin
      rd(MEM_RD, rbase_a+FLOW,1);
      while (test_reg[1]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /***************************************************************************/
  task wait_for_mc_a;
    begin
      rd(MEM_RD, rbase_a+FLOW,1);
      while (test_reg[1]) rd(MEM_RD, rbase_a+FLOW,1);
      #100000 rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /***************************************************************************/
  
`ifdef TV   //this is mainly for protection of test vector files
  task open_tpt;
    input [8*63:1] pattern_filename;
    begin
      $display ("opening tpt file =%s", {pattern_filename,"pat"});
      fname = $fopen ( {pattern_filename,"pat"});
    end
  endtask
  
  task open_vpat;
    input [8*63:1] pattern_filename;
    begin
      $display ("opening vpat file =%s", {pattern_filename,"exp"});
      fname1 = $fopen ({pattern_filename,"exp"});
    end
  endtask
  
`else
  
  task open_file;
    input [8*48:1] pattern_filename;
    begin
      $display ("openning pattern file =%s", pattern_filename);
      fname = $fopen (pattern_filename);
    end
  endtask
 
  task open_results;
    input [8*48:1] pattern_filename;
    
    begin
      $display ("openning pattern file =%s", pattern_filename);
      results = $fopen (pattern_filename);
    end
  endtask
  
  task close_file;
    input [8*48:1] pattern_filename;
    
    begin
      $display ("closing pattern file =%s", pattern_filename);
      $fclose (fname);
    end
  endtask
  
  task close_results;
    input [8*48:1] pattern_filename;
    
    begin
      $display ("closing pattern file =%s", pattern_filename);
      $fclose (results);
    end
  endtask

`endif

  /***************************************************************************/

  /***************************************************************************/
  //THIS BLOCK SAMPLES THE PCI AD_BUS WHENEVER TRDY & PRDY ARE VALID
  // & THE TASK IS ACTIVATED
  initial begin
    write_index=0; //write index for the memory write table.
    write_index_1=0; //write index for the memory write table.
    read_index=0 ; //read index for the memory read table.
    write_flag_n=1; //enabling/disabling the write to the memory array
    write_flag_1_n=1; //enabling/disabling the write to the memory array
    read_flag_n =1;
    
    forever @(posedge HCLK) begin
      if (TRDYn==0 && PRDYn==0 && DEVSELn==0 && read_flag_n==0) begin
	read_mem_table[read_index] = AD;
	read_index = read_index+1;
      end else if (TRDYn==0 && PRDYn==0 && DEVSELn==0 && write_flag_n==0) begin
	write_mem_table[write_index] = hb_ad_bus;
	write_index= write_index+1;
      end else if (TRDYn==0 && PRDYn==0 && DEVSELn==0 && write_flag_1_n==0)
      begin
	write_mem_table_1[write_index_1] = hb_ad_bus;
	write_index_1= write_index_1+1;
      end
    end
  end

  /***************************************************************************/
  //TASK TO CHECK THAT LINEAR WINDOW 0 IS NOT BUSY
  //(THUS IT IS OK TO CHANGE THE WINDOW PARAMTER REGISTERS
  task wait_win0_not_busy;
    integer done;
    
    begin
      done = 0;
      while (!done) begin
	rd(MEM_RD, rbase_w+MW0_CTRL, 1);
	if (test_reg[8]==1)    done=1;
      end
    end
  endtask

  task wait_win1_not_busy;
    integer done;
    
    begin
      done = 0;
      while (!done) begin
	rd(MEM_RD, rbase_w+MW1_CTRL, 1);
	if (test_reg[8]==1)    done=1;
      end
    end
  endtask

task Verify;
 input [31:0] address;
 input [7:0]  size;
 input [31:0] data;

 begin
  $display("VERIFY ADDRESS  %h Size %h", address, size);
  $display("VERIFY EXPECTED %h", data);
  rd(MEM_RD, address, 1);
  $display("VERIFY DATA     %h", test_reg);
 end
endtask


task Verify_Io;
 input [31:0] address;
 input [7:0]  size;
 input [31:0] data;

 integer long_addr;
 integer byte_enables;

 begin
  long_addr = address & 32'hFFFFFFFC;
  byte_enables = (1 << size) - 1;
  byte_enables = byte_enables << (address & 3);
  $display("VERIFY ADDRESS  %h Size %h", address, size);
  $display("VERIFY EXPECTED %h", data);
  rd_byte(IO_RD, address, ~byte_enables, 1);
 
  data = (test_reg >> (address & 3)) & ((1 << size) - 1);
  $display("VERIFY DATA     %h", data);
 end
endtask
   
  /***************************************************************************/
  /*                  TASK FILES                                             */
  /***************************************************************************/
  `include "../../stim/tasks/save_vdac_frame.h"
  // RAMDAC
  `include "../../stim/tasks/move_cursor.h"
  `include "../../stim/tasks/draw_cur.h"
  `include "../../stim/tasks/dctests.h"

  
endmodule
