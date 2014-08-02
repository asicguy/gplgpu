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
//  Title       :  Top level of Maxwell 3D
//  File        :  max_3d_top.v
//  Author      :  Jim MacLeod
//  Created     :  04-29-2010
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This is the top level of the Maxwell 3D FPGA. It is originally
//  based on max_top.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//    U_HBI         HBI_TOP        Host bus interface
//    U_DE          DE_TOP         Drawing engine
//    U_DLP         DLP_TOP        Display List Processor
//    U_MC          MC             Memory controller
//    U_VGA 	    VGA_TOP    	   VGA
//    U_CRT 	    CRT            CRT controller
//    U_BM 	    BM             PCI Bus Masters
//    U_RAMDAC      RAMDAC         RAMDAC
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


// DEFINES FOR CHIP CONFIGURATION.
// `define USE_EXT_PLL 1;
// `define USE_MC_64B 1;

// These defines replace the old straps that we used
//`define PCI_CLASS 1'b1; // Not VGA
`define PCI_CLASS 1'b0; // VGA

`define WINDOW_SIZE 2'b11;
`define EPROM_SIZE 1'b1;
`define MEM_TYPE 1'b1; 		// SDRAM/SGRAM
// `define MEM_TYPE 2'b11; 	// SDRAM/SGRAM (From Peritek)
`define MEM_DENSITY 2'b11; 	// How much memory we have (32MB SDRAM)
// `define MEM_DENSITY 2'b10; 	// How much memory we have (16MB SDRAM)
`define IDAC_ENABLE 1'b1;
`define PCI 1'b1;

//`define SBSYS_ID_STRAP 6'h1; // 8MB
//`define SBSYS_ID_STRAP 6'h3; // 16MB
`define SBSYS_ID_STRAP 6'h7;   // 32 MB

// Turn on VGA generated refreshes.
`define VGA_REF 1

/////////////////////////////////////////////////////////////
// USED for FPGA Revision.
`define SBVEND_SEL_STRAP 1'b1;
`define SBVEND_ID_STRAP 16'h010B;

`timescale 1ns / 10ps
  module max_3d_top
    (
     // PCI I/O
     input	          hclock,	  // host clock input port
     input 	          hresetn,	  // host reset input port
     inout 	          pframen,        // address strobe/FRAME signal
     inout 	          pirdyn,         // Initiator ready signal
     inout 	          ptrdyn,         // Target ready
     inout 	          pdevseln,       // Device select
     input 	          pidsel,         // Initialization Device Select
     inout 	          pintan,         // Interrupt output
     inout 	          pstopn,         // Stop output
     inout 	          ppar,           // Parity output [31:0]
     inout 	          preqn,        // pci request to arbiter
     inout 	          pgnntn,        // pci grant from external arbiter
     inout [3:0] 	  pcben,          // Command, byte enable
     inout [31:00]        pad,         	  // host address and data port
     // Serial BIOS Interface.
     input		  bios_rdat,	  // Serial bios input data.
     output		  bios_clk,	  // Serial bios clock.
     output		  bios_csn,	  // Serial bios chip select.
     output		  bios_wrn,	  // Serial bios write enable.
     output		  bios_hld,	  // Serial bios hold.
     output		  bios_wdat,	  // Serial bios write data.
     // Reference Clock
     input 	          pll_clka,       // Pixel Clock from PLL_CLKA
     input 	          pll_clkb,       // Reference for PLL -> DE clock and VGA Clock.
     input                
     input 	          pll_xbuf,       // Reserved from PLL_XBUF or Crystal.
     // External PLL Programing Interface.
     inout                pll_sclk,        // SPI CLK to the CY22393.
     inout                pll_sdat,        // SPI DATA to the CY22393.
     // Memory Controller I/O
     // For 64 bit Micro DIMM
     inout 	          mem_clk,        // 
     inout 	          mem_clk_n,      // 
     output               mem_cke,        // Clock Enable
     output               mem_cs_n,       // Chip select
     output               mem_odt,        // DDR On Chip Termination.
     output 	          mem_ras_n,  	  // SDRAM RAS
     output 	          mem_cas_n,	  // SDRAM CAS
     output 	          mem_we_n,       // SDRAM WEn
     output [2:0] 	  mem_ba,         // Bank Address SDRAM 
     output [13:0]        mem_addr, 	  // SGRAM, WRAM address
     inout [63:0]         mem_dq,	  // Frame buffer data
     inout  [7:0]         mem_dqs,	  // SDRAM DQS
     inout  [7:0]         mem_dqsn,	  // SDRAM DQSn
     output [7:0]         mem_dm,	  // SDRAM DQM
     //
     // Signals for the DVO, 
     //
     output 	          dvo_dclk,	  // DVI Transmitter Clock.
     output 	          dvo_hsync,	  // DVI Hsync out.
     output 	          dvo_vsync,	  // DVI Vsync or Csync out.
     output 	          dvo_de,	  // DVI Data Enable.
     output [23:0] 	  dvo_data,	  // DVI/DAC Data output.
     					  // For Single Edge DVI Data output.
     					  // For Dual   Edge DVI Data output.
     					  // For Dual Edge Dual link DVI Data output.
     					  // For DAC {RED[7:0], GRN[7:0], BLU[7:0]} = DVI_D[23:0].
     output 	          dvo_bsel_scl,	  // I2C Clock
     inout 	          dvo_dsel_sda,	  // I2C Data
     inout    	          ddc_scl,	  // DDC2 "clock"
     inout    	          ddc_sda,	  // Datain from DDC1 compatible monitor

     output 	          dac_psaven,	  // Power Save Signal.
     output 	          dac_cblankn,	  // Composit Blank to DAC.
     output 	          dac_csyncn,	  // Composit Sync to DAC.
     output		  dac_sog,	  // Sync On Green Output.
     //
     // Additional Signals for the BT868, PAL encoder.
     //
     input 	          bt_clko,	  // Clock input from the BT868.
     input 	          bt_hsyncn,	  // Hsync input from the BT868.
     input 	          bt_vsyncn,	  // Vsync input from the BT868.
     input 	          bt_blankn,	  // Blank input from the BT868.
     input 	          bt_field,	  // Field input from the BT868.
     output 	          bt_pal,	  // 1 = PAL, 0 = NTSC.
     //
     // Jumper Settings for testing or internal configuration
     // Special Function Pins.
     //
     input		  t2r4_mode,	  // Input to Soft switch bit Two.
     input		  mb_32_sel,	  // Select 32MB of Memory.
     input		  vga_en,	  // VGA class_strap enable/disable VGA.
     input		  dual_enn,	  // Dual DVI Enable.
     input		  m66_en,	  // PCI 66MHz Enable.
     output               ledn,		  // General purpose LED output.
     // Test Pins which go to the Mictor Conectors.
     output 		mictor_clke,
     output 		mictor_clko,
     output 	[15:0]	mictor_de,
     output 	[15:0]	mictor_do,
     output 	[19:0]	gpio_3v
     );

///////////////////////////////////////////////////////////////
  // Wires - PCI
  wire 		  frame_out_n;
  wire 		  frame_oe_n;      
  wire 		  irdy_out_n;
  wire 		  irdy_oe_n;
  wire 		  hb_ctrl_oe_n;
  wire 		  trdy_out_n;
  wire 		  devsel_oe_n;
  wire 		  devsel_out_n;
  wire 		  intrp_oe_n;
  wire 		  intrp_out_n;
  wire 		  par32_oe_n;

  // Wires - Parallel Port
  wire [15:0]	  P_A;    	  // Peripheral Address.
  wire 		  p_d_oe_n;
  wire [7:0] 	  p_d_out;

  // Wires - System Clock
  wire 		  de_clk;
  
  // Wires - Memory Controller
  wire [127:0] 	  pdat_out;
  wire  	  pdat_oe;

  // Wires - DDC
  wire 		  ddc_dat_dout_0;
  wire 		  ddc_clk_0;

  // Wires - Once were straps
  wire [1:0] 	  window_size_strap = {t2r4_mode, mb_32_sel};
  wire 		  eprom_strap 	    = `EPROM_SIZE
  wire 		  class_strap 	    = vga_en;
  wire [1:0] 	  mem_dens_strap    = {t2r4_mode, mb_32_sel};
  wire 		  idac_strap 	    = `IDAC_ENABLE
  wire 		  mem_type_strap    = `MEM_TYPE
  wire 		  hbt_strap         = `PCI
  wire  	  sbvend_sel_strap  = `SBVEND_SEL_STRAP
  wire [15:0] 	  sbvend_id_strap   = `SBVEND_ID_STRAP
  
  wire [5:0] 	  sbsys_id_strap    = (t2r4_mode &  mb_32_sel) ? 6'h7 : // 32MBytes.
  				      (t2r4_mode & ~mb_32_sel) ? 6'h3 : // 16MBytes.
  				      (~t2r4_mode & mb_32_sel) ? 6'h9 : // 256MBytes (FIX ME).
				      6'h8; 				// 128MBytes (FIX ME).

  // Internal Signals
  // From Host Bus
  wire 		  bb_rstn;             // Internal system reset
  wire 		  dac_reset_n;         // DAC reset
  wire [13:2] 	  hb_adr_de;           // Drawing engine address from host
  wire [8:2] 	  hb_adr;              // Host address
  wire [31:0] 	  hb_din;              // Data from the host bus
  wire [3:0] 	  hb_ben;              // Host bus byte enables
  wire 		  hb_wstrb_de;         // Write strobe to the DE
  wire 		  hb_wstrb;            // Write Strobe
  wire 		  hb_write;
  wire 		  csn_de1_xyw;         // XY Windows Chip Select
  wire 		  csn_de1;             // Drawing engine chip select
  wire 		  vga_req;             // Write request to the VGA
  wire [31:0] 	  mc_config2reg;       // Configuration REG 2
  wire  	  ldi_2xzoom;          // zoom from vga control register
  wire [22:0] 	  vga_laddr;
  wire [31:0] 	  vga_ldata;
  wire [3:0] 	  vga_lbe;
  wire 		  vga_rdwr;            // VGA read or write
  wire 		  vga_mem_io;          // Memory/ IO selector for VGA
  wire 		  csn_glb;             // Global register Chip Select
  wire [20:0] 	  hb_org;              // Host origin to MC
  wire [127:0] 	  hb_pdo;              // Host data to MC
  wire [15:0] 	  hb_pix_msk;          // Host Mask to MC
  wire 		  hb_mem_read;         // Read or write to MC
  wire 		  hb_mem_req;          // Issue a memory request to the MC
  wire 		  idac_wr;
  wire 		  idac_rd;
  wire 		  idac_en;
  wire 		  mw_de_fip;
  wire 		  mw_dlp_fip;
  wire 		  enable_rbase_e_p;
  wire [31:0] 	  hb_ldata;
  wire 		  stop_out_n;
  wire 		  par32_out;
  wire 		  req_n;
  wire  	  c_be_oe_n;
  wire  	  ad_oe32_n;
  wire [31:0] 	  ad_out;
  wire [1:0] 	  hst_mw_addr;
  wire [7:0] 	  ssro;
  
  // Bus master interface from HBI
  wire 		  pci_mstr_en;         // Hammer is a PCI master
  wire 		  de_pl_busy;
  wire [4:0] 	  flow_reg;
  wire [31:2] 	  pci_wr_addr;
  wire [21:0] 	  pcim_masks;
  wire 		  hbt_pci;

  // From Drawing Engine
  wire [31:0] 	  de1_hdout;          // Data to the host bus
  wire [31:0] 	  de1_drout;          // Data to the host bus
  wire 		  de1_clp;            // Clip indicator
  wire 		  de1_deb;            // Drawing engine busy
  wire 		  de1_busy;
  wire 		  de1_ddint_tog;
  wire 		  de1_clint_tog;
  wire [20:0] 	  de1_org;            // Drawing engine origin
  wire [11:0] 	  de1_ptch;           // Drawing engine pitch
  wire 		  de1_mem_req;        // Drawing engine requesting memory op
  wire 		  de1_mem_read;       // Read or write indicator to MC
  wire 		  de1_mem_rmw;        // Read modify write on a write
  wire [11:0] 	  de1_x_pos;          // X coordinate for write
  wire [15:0] 	  de1_y_pos;          // Y coordinate for a write
  wire [3:0] 	  de1_wcnt;           // Number of pages to request
  wire [15:0] 	  de1_pix_msk;        // byte mask for data
  wire [127:0] 	  de1_pdo;            // Data to MC
  wire 		  de1_ca_busy;        // 2D cache is busy
  wire [2:0] 	  de1_hdf;            // Host Data Format
  wire [1:0] 	  de1_ps_2;           // Pixel Size
  wire 		  pc_mc_busy;         // Pixel cache busy
  wire [3:0] 	  de1_bsrcr;          // Source Blending Register
  wire [2:0]	  de1_bdstr;          // Destination Blending Register
  wire		  de1_blend_en;       // Blending Enabled
  wire		  de1_ps565;          // mode 16
  wire [7:0]	  de1_bsrc_alpha;     // Source Alpha register
  wire [7:0]	  de1_bdst_alpha;     // Destination Alpha register
  wire [3:0]	  de1_rop;            // de1 raster op select
  wire [31:0]	  de1_kcol;           // key color
  wire [2:0]	  de1_kcnt;           // keying control
  wire 		  pipeline_active;

  // From DLP
  wire [8:2] 	  de_adr;             // Drawing engine address from DLP
  wire 		  de_wstrb;           // DLP write strobe to DE
  wire 		  de_csn;             // DLP chip select for DE
  wire [3:0] 	  de_ben;             // BEN's from DLP to DE
  wire [31:0] 	  de_data;            // Data from DLP to DE
  wire [53:0] 	  pp_rdback;          // DLP register readback to host
  wire [23:0] 	  dlp_addr;           // DLP address to MC
  wire 		  dlp_sen;
  wire 		  dlp_req;            // DLP memory Controller Request
  wire 		  dlp_load;           // Load a DMA command from DLP
  wire [31:3] 	  dlp_src_addr;
  wire [25:3] 	  dlp_dst_addr;

  // From Memory Controller
  wire 		  dis_push;
  wire 		  dis_rdy;
  wire 		  de1_acken;
  wire 		  de1_popen;
  wire 		  de1_push;
  wire 		  de1_mem_rdy;
  wire 		  de1_last;
  wire 		  de1_last4;
  wire 		  dlp_push;
  wire 		  dlp_mc_done;
  wire 		  dlp_ready;
  wire 		  hb_pop;
  wire 		  hb_push;
  wire 		  hb_mem_rdy;
  wire [127:0] 	  mc_read_data;
  wire [31:0] 	  vga_data;
  wire 		  vga_ack_n;
  wire 		  vga_ready_n;
  wire 		  mcb;
  wire [1:0] 	  fb_ba;
  wire [1:0] 	  dqinclk;
  wire [127:0] 	  pdat_in;
  wire 		  dqs_oe;
  
  // From the VGA
  wire [31:0] 	  hst_data_out;       // VGA read data for host
  wire [2:0] 	  vga_stat;           // Decoder status
  wire 		  vga_push;           // VGA read data push
  wire 		  vga_ready;          // VGA request ready
  wire 		  v_clks;
  wire [7:0] 	  v_pd;               // Pixel data to ramdac
  wire 		  v_blank;
  wire 		  v_hrtc;
  wire 		  v_vrtc;
  wire [31:0] 	  vdat_out;           // VGA data to MC (unused)
//  wire 		  vga_ref_n;          // VGA making refresh request
  wire 		  mem_req;            // VGA memory Request
  wire 		  vga_rd_wrn;         // VGA RD=1, WR=0
  wire [17:0] 	  vga_addr;           // MC request address
  wire [3:0] 	  vga_we;             // VGA data byte mask
  wire [31:0] 	  vga_data_in;
  wire 		  vga_rstn;           // VGA reset
  
  // From CRT
  wire [31:0]	  hdat_out_crt_vga;
  wire 		  hb_int_tog;         // Horizontal interrupt
  wire 		  vb_int_tog;         // Vertical interrupt
  wire 		  vblnkst2;
  wire [11:0] 	  crt_ptch;           // CRT Pitch to MC
  wire [20:0] 	  crt_org;            // CRT Origin to MC
  wire 		  dis_req;            // CRT Request to MC
  wire [9:0] 	  dis_x;	      // Display controller X address
  wire [11:0] 	  dis_y;	      // Display controller Y address
  wire [4:0] 	  dis_page;    	      // Display controller page count upto 32
  wire 		  blank_toidac;
  wire 		  hcsync_toidac;
  wire 		  vsync_toidac;
  wire [23:0] 	  pd_toidac;          // Pixel data to internal RAMDAC
  wire 		  ss_sel;
  wire 		  ss_line;
  wire 		  crt_rstn;
  
  // From Bus Master
  wire [31:0] 	  pcim_ad_out;
  wire 		  pcim_ad_oe;
  wire [3:0] 	  c_be_out;
  
  // From RAMDAC
  wire 		  sys_locked;            // System PLL is locked
  wire 		  pix_locked;            // Pixel PLL is locked
  wire [1:0] 	  bpp;
  wire 		  vga_mode;
  wire [7:0] 	  idac_rd_data;          // Read data from ramdac registers
  wire 		  crtclock;
  wire 		  sprog_mode;
  wire 		  spll_enab;
  wire [7:0] 	  sysmctl;
  wire [5:0] 	  sysnctl;
  wire [2:0] 	  syspctl;
  wire 		  p_areset,
		  pixclk,
		  pixclk_vga;
  wire 		  pix_locked_1, p_scandataout_1, pixclk_1, crtclock_1;
  
  wire 		  hb_clk;
  wire 		  de_locked;
  wire 		  mclock;                // Memory controller clock
  wire 		  mclock90;              // Memory controller clock
  wire 		  mclock180;             // Memory controller clock
  wire 		  vga_mclock;            // VGA master (mem) clock
  wire 		  hb_de_busy;
  wire 		  ddc_en_0, ddc_en_1;
  wire 		  mem_locked;
  wire 		  vga_ref_n;
  wire 		  p_scandataout;
  wire 		  ppll_enable;
  wire	[2:0]	  pixclksel;
  wire	[2:0]	  horiz_actv_decode;
  wire	[1:0]	  int_fs;
  wire		  sync_ext;
  wire	[7:0]	  red;
  wire	[7:0]	  grn;
  wire	[7:0]	  blu;
  wire		  pll_sdat_oe, pll_sclk_oe;
  wire		  pll_sdat_int, pll_sclk_int;
  wire	[1:0]	  dummy_h;
  wire	[1:0]	  dummy_l;
  wire		  p_update;
  wire	[26:0]    pll_params;
  
  /***************************************************************************/
  /* 		PROBE WIRES FOR TEST ONLY                                    */
  /***************************************************************************/
  wire [76:0] 	  probe_de;
  wire [12:0] 	  probe_hint;
  wire [23:0] 	  hbi_probe;
  wire [19:0] 	  dlp_probe;
  wire [51:0] 	  crt_probe;
  wire [31:0] 	  reg_probe;
  wire [9:0] 	  probe_dec;
  wire [18:0] 	  probe_hreg;
  wire [9:0] 	  probe_ddc;
  wire [3:0] 	  probe_misc;
  wire [94:0] 	  probe_reg;
  wire [13:0] 	  probe_sm;
  wire [31:0] 	  probe_coord;
  wire [112:0] 	  probe_dex;
  wire [63:0] 	  probe_deca;
  wire 		  probe_vga1;
  wire [67:0] 	  probe_vga;
  wire [6:0] 	  probe_memif;
  wire [21:0] 	  probe_font;
  wire [47:0] 	  probe_vmem;
  wire [99:0] 	  probe_vcrt;
  wire [97:0] 	  probe_cpuwr;
  wire [3:0] 	  probe_addr;
  wire [4:0] 	  probe_cfifo;
  wire [15:0] 	  r_probe;
  wire [43:0] 	  probe_rcpu;
  wire [23:0] 	  probe_rreg;
  wire [2:0] 	  probe_pwr;

  wire HSYNC0n, VSYNC0n, CBLANK0n;
  wire DE0;

  wire 	     dqs_capture_en;
  wire [13:0] hactive_regist;
  


  /***************************************************************************/
  // Infer IO
  // Control signals put here for simplicity in changing
  // Dac Daughter board controls
  // PCI IO
  /***************************************************************************/
  // PMC Only Signals.
  // PCI IO
  assign 	  pframen  = (frame_oe_n) ? 1'bz : frame_out_n;
  assign 	  pirdyn   = (irdy_oe_n) ? 1'bz : irdy_out_n;
  assign 	  ptrdyn   = (hb_ctrl_oe_n) ? 1'bz : trdy_out_n;
  assign 	  pdevseln = (devsel_oe_n) ? 1'bz : devsel_out_n;
  assign 	  pintan   = (intrp_oe_n) ? 1'bz : intrp_out_n;
  assign 	  pstopn   = (hb_ctrl_oe_n) ? 1'bz : stop_out_n;
  //                        req_n must be tristated on reset pci 2.1 spec
  assign 	  preqn  = (bb_rstn) ? req_n : 1'bz;

  assign 	  pcben[3:0] = (c_be_oe_n) ? 4'bzzzz : c_be_out;

  assign 	  ppar       = (par32_oe_n) ? 1'bz : par32_out;
  assign 	  pad[31:24] = (ad_oe32_n) ? {8{1'bz}} : ad_out[31:24];
  assign 	  pad[23:16] = (ad_oe32_n) ? {8{1'bz}} : ad_out[23:16];
  assign 	  pad[15:8]  = (ad_oe32_n) ? {8{1'bz}} : ad_out[15:8];
  assign 	  pad[7:0]   = (ad_oe32_n) ? {8{1'bz}} : ad_out[7:0];

  // DIGITAL Outputs
  // 
  assign dvo_data = { red, grn, blu};
  assign dvo_dclk = pixclk;
  assign dvo_hsync = HSYNC0n;
  assign dvo_vsync = VSYNC0n;

//////////////////////////////////////////////////////////////////
// DDC, I2C Muxing.
// 

wire ddc_din =   (ssro[7]) ? pll_sdat :
		   (ssro[0]) ? dvo_dsel_sda :
		   ddc_sda;

wire ddc_clkin = (ssro[7]) ? pll_sclk :
		   (ssro[0]) ? dvo_bsel_scl :
       		   ddc_scl;

assign ddc_sda = (~ddc_dat_dout_0 | ssro[7] | ssro[0]) ? 1'bz : 1'b0;
assign ddc_scl = (~ddc_clk_0 | ssro[7] | ssro[0]) ? 1'bz : 1'b0;

assign dvo_dsel_sda = (~ddc_dat_dout_0 | ssro[7] | ~ssro[0]) ? 1'bz : 1'b0;
assign dvo_bsel_scl = (~ddc_clk_0 | ssro[7] | ~ssro[0]) ? 1'bz : 1'b0;

// PLL Connection.
assign pll_sdat = (ssro[7] | ~ddc_dat_dout_0) ? 1'bz : 
	   	  (~ssro[7]) ? pll_sdat_int : 1'b0;

assign pll_sclk = (ssro[7] | ~ddc_clk_0) ? 1'bz : 
		  (~ssro[7]) ? pll_sdat_int : 1'b0;

//////////////////////////////////////////////////////////////////
  
  assign bios_wrn = 1'b0;


  wire    [ 25: 0] afi_addr;
  wire    [  3: 0] afi_ba;
  wire    [  1: 0] afi_cas_n;
  wire    [  1: 0] afi_cke;
  wire    [  1: 0] afi_cs_n;
  wire    [ 31: 0] afi_dm;
  wire    [ 15: 0] afi_doing_rd;
  wire    [ 15: 0] afi_dqs_burst;
  wire    [  1: 0] afi_odt;
  wire    [  1: 0] afi_ras_n;
  wire    [255: 0] afi_rdata;
  wire    [  1: 0] afi_rdata_valid;
  wire    [  1: 0] afi_rst_n;
  wire    [255: 0] afi_wdata;
  wire    [ 15: 0] afi_wdata_valid;
  wire    [  1: 0] afi_we_n;
  wire    [  4: 0] afi_wlat;
  wire             aux_full_rate_clk;
  wire             aux_half_rate_clk;
  wire             aux_scan_clk;
  wire             aux_scan_clk_reset_n;
  wire    [ 31: 0] csr_rdata_sig;
  wire             csr_rdata_valid_sig;
  wire             csr_waitrequest_sig;
  wire    [  7: 0] ctl_cal_byte_lane_sel_n;
  wire             ctl_cal_fail;
  wire             ctl_cal_req;
  wire             ctl_cal_success;
  wire             ctl_clk;
  wire             ctl_mem_clk_disable;
  wire    [  4: 0] ctl_rlat;
  wire    [ 31: 0] dbg_rd_data_sig;
  wire             dbg_waitrequest_sig;
  wire             dll_reference_clk;
  wire    [  5: 0] dqs_delay_ctrl_export;
  wire             ecc_interrupt;
  wire    [ 63: 0] hc_scan_dout;
  wire             local_init_done;
  wire             local_power_down_ack;
  wire    [255: 0] local_rdata;
  wire             local_rdata_error;
  wire             local_rdata_valid;
  wire             local_ready;
  wire             local_refresh_ack;
  wire             local_self_rfsh_ack;
  wire             local_wdata_req;
  wire             mem_reset_n;
  wire             phy_clk;
  wire             pll_phase_done;
  wire             pll_reconfig_busy;
  wire             pll_reconfig_clk;
  wire    [  8: 0] pll_reconfig_data_out;
  wire             pll_reconfig_reset;
  wire             reset_ctl_clk_n;
  wire             reset_phy_clk_n;
  wire             reset_request_n;

  assign phy_clk = ctl_clk;
  assign reset_phy_clk_n = reset_ctl_clk_n;

/***************************************************************************/
/* 		INSTANTIATE THE MEMORY CONTROLLER.                    */
/***************************************************************************/
  
  mc U_MC
    (
     .pixclk                     (pixclk),
     .crt_clock                  (crtclock), 
//     .crt_rstn                   (crt_rstn),
     .crt_org                    (crt_org), 
     .crt_page                   (dis_page), 
     .crt_ptch                   (crt_ptch), 
     .crt_req                    (dis_req), 
     .crt_x                      (dis_x), 
     .crt_y                      (dis_y), 

     .de_bdst_alpha              (de1_bdst_alpha), 
     .de_bdstr                   (de1_bdstr), 
     .de_blend_en                (de1_blend_en), 
     .de_bsrc_alpha              (de1_bsrc_alpha), 
     .de_bsrcr                   (de1_bsrcr), 
     .de_byte_mask               (de1_pix_msk),
     .de_clock                   (de_clk), 
     //.de_clock                   (mclock), 
     .de_data                    (de1_pdo),
     // .de_data                    ({de1_pdo[63:0], de1_pdo[127:64]}),
     .de_kcnt                    (de1_kcnt), 
     .de_kcol                    (de1_kcol), 
     .de_org                     (de1_org), 
     .de_page                    (de1_wcnt),  
     .de_pix                     (de1_ps_2), 
     .de_ptch                    (de1_ptch), 
     .de_read                    (de1_mem_read), 
     .de_req                     (de1_mem_req), 
     .de_rmw                     (de1_mem_rmw),
     .de_rop                     (de1_rop),
     .de_x                       (de1_x_pos), 
     .de_y                       (de1_y_pos), 
     
     .dlp_org                    (dlp_addr[20:0]), 
     .dlp_req                    (dlp_req),
 
     .fb_data_in                 ({pdat_in[63:0], pdat_in[127:64]}), 

     .hst_byte_mask              (hb_pix_msk), 
     .hst_clock                  (hb_clk), 
     .hst_data                   (hb_pdo), 
     .hst_org                    (hb_org), 
     .hst_read                   (hb_mem_read), 
     .hst_req                    (hb_mem_req),
  
     .mclock                     (mclock), 
     .mclock180                  (mclock180), 
     .mem_locked                 (mem_locked),
     .reset                      (bb_rstn), 

     /*
     .vid_org                    (21'b0), 
     .vid_page                   (8'b0), 
     .vid_pitch                  (12'b0), 
     .vid_req                    (1'b0), 
     .vid_x                      (10'b0), 
     .vid_y                      (12'b0), 
      */
      
     .crt_push                   (dis_push), 
     .crt_ready                  (dis_rdy), 

     .de_acken                   (de1_acken), 
     .de_popen                   (de1_popen), 
     .de_push                    (de1_push), 
     .de_rdy                     (de1_mem_rdy), 
     .de_last                    (de1_last),
     
     .dlp_push                   (dlp_push), 
     .dlp_mc_done                (dlp_mc_done), 
     .dlp_ready                  (dlp_ready), 

     .fb_addr                    (afi_addr), 
     .fb_ba                      (afi_ba), 
     .fb_cas                     (afi_cas_n), 
     .fb_cs                      (afi_cs_n), 
     .fb_data_out                (pdat_out), 
     .fb_dqm                     (afi_dm), 
     .fb_oe                      (pdat_oe), 
     .fb_ras                     (), 
     .fb_we                      (), 
     .ddr_cke                    (),
     .dqs_oe                     (dqs_oe),
     .hst_pop                    (hb_pop), 
     .hst_push                   (hb_push), 
     .hst_rdy                    (hb_mem_rdy), 
     .hst_mw_addr                (hst_mw_addr),
     .read_data                  (mc_read_data), 
     .vga_data                   (vga_data), 
//     .vid_push                   (),
     .mc_dqs_capture             (dqs_capture_en),

     // VGA signals
     .vga_mode                   (vga_mode),
     .v_mclock                   (vga_mclock),
//     .vga_rstn                   (vga_rstn),
     .vga_req                    (mem_req),
     .vga_rd_wrn                 (vga_rd_wrn),
     .vga_addr                   (vga_addr),
     .vga_we                     (vga_we),
     .vga_data_in                (vga_data_in),
     .vga_ref_n                  (vga_ref_n),

     .vga_ack_n                  (vga_ack_n),
     .vga_ready_n                (vga_ready_n),
     .mcb                        (mcb)
     );

     // Alter DDR memory PHY.
  ddr3_int_phy ddr3_int_phy_inst
    (
      .pll_ref_clk			(pll_xbuf),
      .global_reset_n			(global_reset_n),
      .soft_reset_n			(soft_reset_n),
      .ctl_dqs_burst			(dqs_oe),
      .ctl_wdata			({2{pdat_out[63:0], pdat_out[127:64]}}),
      .ctl_wdata_valid			(pdat_oe),

      .ctl_addr				(afi_addr),
      .ctl_ba				(afi_ba),
      .ctl_cal_byte_lane_sel_n		(ctl_cal_byte_lane_sel_n),
      .ctl_cal_fail			(ctl_cal_fail),
      .ctl_cal_req			(ctl_cal_req),
      .ctl_cal_success			(ctl_cal_success),
      .ctl_cas_n			(afi_cas_n),
      .ctl_cke				(afi_cke),
      .ctl_clk				(ctl_clk),
      .ctl_cs_n				(afi_cs_n),
      .ctl_dm				(~{afi_dm[7:0], afi_dm[15:8]}),
      .ctl_doing_rd			(dqs_capture_en),
      .ctl_mem_clk_disable		(ctl_mem_clk_disable),
      .ctl_odt				(afi_odt),
      .ctl_ras_n			(afi_ras_n),
      .ctl_rdata			(pdat_in),
      .ctl_rdata_valid			(afi_rdata_valid),
      .ctl_reset_n			(reset_ctl_clk_n),
      .ctl_rlat				(ctl_rlat),
      .ctl_rst_n			(afi_rst_n),
      .ctl_we_n				(afi_we_n),
      .ctl_wlat				(afi_wlat),

      .dbg_addr				(13'b0),
      .dbg_clk				(ctl_clk),
      .dbg_cs				(1'b0),
      .dbg_rd				(1'b0),
      .dbg_rd_data			(dbg_rd_data_sig),
      .dbg_reset_n			(reset_ctl_clk_n),
      .dbg_waitrequest			(dbg_waitrequest_sig),
      .dbg_wr				(1'b0),
      .dbg_wr_data			(32'b0),

      .dll_reference_clk		(dll_reference_clk),
      .dqs_delay_ctrl_export		(dqs_delay_ctrl_export),
      .dqs_delay_ctrl_import		(dqs_delay_ctrl_import),
      .dqs_offset_delay_ctrl		(dqs_offset_delay_ctrl),

      .mem_addr				(mem_addr),
      .mem_ba				(mem_ba),
      .mem_cas_n			(mem_cas_n),
      .mem_cke				(mem_cke),
      .mem_clk				(mem_clk),
      .mem_clk_n			(mem_clk_n),
      .mem_cs_n				(mem_cs_n),
      .mem_dm				(mem_dm),
      .mem_dq				(mem_dq),
      .mem_dqs				(mem_dqs),
      .mem_dqs_n			(mem_dqsn),
      .mem_odt				(mem_odt),
      .mem_ras_n			(mem_ras_n),
      .mem_reset_n			(mem_reset_n),
      .mem_we_n				(mem_we_n),

      .aux_full_rate_clk		(mclock),	// Memory Clock
      .aux_half_rate_clk		(mclock_d2),	// Memory Clock/2

      .oct_ctl_rs_value			(oct_ctl_rs_value),
      .oct_ctl_rt_value			(oct_ctl_rt_value),
      .reset_request_n			(reset_request_n)
    );


  /***************************************************************************/
  /* 		INSTANTIATE THE HOST BUS INTERFACE                    */
  /***************************************************************************/

hbi_top U_HBI 
    (
     .devid_sel                  (2'b11),
     .hb_clk                     (hb_clk),
     .mclock                     (mclock),
     .vga_mclock                 (vga_mclock),
     .hreset_in_n                (hresetn), 
     .hb_ad_bus                  (pad), 
     .hb_byte_ens                (pcben), 
     .idsel                      (pidsel), 
     .frame_n                    (pframen),            
     .irdy_n                     (pirdyn), 
     .cmd_hdf                    (de1_hdf), 
     .de_ca_busy                 (de1_ca_busy), 
     .dda_int_tog                (de1_ddint_tog), 
     .cla_int_tog                (de1_clint_tog), 
     .clp_a                      (de1_clp), 
     .deb_a                      (de1_deb), 
     .draw_engine_a_dout         (de1_hdout),
     .draw_engine_reg            (de1_drout),
     .de_pipeln_activ            (pipeline_active), 
     .vga_mem_last               (vga_push), 
     .vga_mem_rdy                (vga_ready), 
     .mcb                        (pc_mc_busy | de1_mem_req | de1_ca_busy | mcb), // fixme ???? 
     .vb_int_tog                 (vb_int_tog), 
     .hb_int_tog                 (hb_int_tog), 
     .hdat_out_crt_vga           (hdat_out_crt_vga), 
     .vga_decode_ctrl            (vga_stat[1:0]), 
     .fis_io_en                  (vga_stat[2]),
     .dlp_retry                  (pp_rdback[21]), 
     .busy_a                     (hb_de_busy), 
     .ddc1_dat_0                 (ddc_din), 
     .ddc_clk_in_0               (ddc_clkin), 
     .ddc1_dat_1                 (1'b0), 
     .ddc_clk_in_1               (1'b0), 
     .pd_in                      (p_d_out[7:0]),
     .config_bus                 ({window_size_strap,
				   eprom_strap,
				   class_strap, 
				   mem_dens_strap,
				   idac_strap, 
				   mem_type_strap,
				   hbt_strap,
				   sbsys_id_strap,
				   sbvend_sel_strap,
				   sbvend_id_strap}),
     .hst_push                   (hb_push),
     .hst_pop                    (hb_pop),
     .hst_mw_addr                (hst_mw_addr),
     .mc_ready_p                 (hb_mem_rdy),
     .pix_in_dbus                (mc_read_data),
     .crt_vertical_intrp_n       (VSYNC0n),
     .soft_switch_in             ({
				  1'b0,
				  1'b0,				 
				  1'b0,				 
				  dual_enn,				 
				  vga_en,				 
				  1'b0,				 
				  mb_32_sel,				 
				  t2r4_mode				 
				 }),
     .pci_ad_out                 (pcim_ad_out),
     .pci_ad_oe                  (pcim_ad_oe),
     .idac_data_in               (idac_rd_data),
     .c_be_out                   (c_be_out),
     .vga_mode                   (vga_mode),
     .bios_rdat                  (bios_rdat),
     .m66_en                     (m66_en),
     
     .hb_soft_reset_n            (bb_rstn),
     .dac_reset_n                (dac_reset_n), 
     .hb_cycle_done_n            (), 
     .ddc1_dat2_0                (ddc_dat_dout_0), 
     .ddc1_dat2_1                (ddc_dat_dout_1), 
     .sobn_n                     (), 
     .hbi_addr_in_p1             (hb_adr_de[13:2]),
     .hbi_addr_in_p2             (hb_adr[8:2]), 
     .hbi_data_in                (hb_din),        
     .hbi_be_in                  (hb_ben),
     .hb_write                   (hb_write), 
     .trdy_n                     (trdy_out_n), 
     .stop_n                     (stop_out_n), 
     .ctrl_oe_n                  (hb_ctrl_oe_n), 
     .devsel_n                   (devsel_out_n), 
     .devsel_oe_n                (devsel_oe_n), 
     .par32_out                  (par32_out), 
     .par32_oe_n                 (par32_oe_n), 
     .ad_oe32_n                  (ad_oe32_n), 
     .c_be_oe_n                  (c_be_oe_n), 
     .blkbird_dout               (ad_out), 
     .interrupt_cnt              (intrp_oe_n), 
     .interrupt_in               (intrp_out_n), 
     .cs_xyw_a_n                 (csn_de1_xyw),  
     .wr_en_p1                   (hb_wstrb_de),
     .wr_en_p2                   (hb_wstrb),
     .cs_draw_a_regs_n           (csn_de1), 
     .vga_mem_req                (vga_req),
     .dden                       (),               
     .cfg_reg2_mc                (mc_config2reg[23:20]), // 21 no longer needed
     .cfg_reg2_cn                (mc_config2reg[7]),
     .cfg_reg2_ref_cnt           (mc_config2reg[6:5]),   // no longer needed
     .cfg_reg2_rcd               (mc_config2reg[4]),
     .cfg_reg2_jv                (mc_config2reg[3]),
     .cfg_reg2_tr                (mc_config2reg[2]),
     .cfg_reg2_sgr               (mc_config2reg[1]),
//     .vga_ctrl_dout              (vga_controlreg[7:0]), 
     .ldi_2xzoom                 (ldi_2xzoom),
     .vga_laddr                  (vga_laddr[22:0]), 
     .vga_ldata                  (vga_ldata[31:0]), 
     .vga_lbe                    (vga_lbe[3:0]), 
     .vga_rdwr                   (vga_rdwr), 
     .vga_mem_io                 (vga_mem_io), 
     .ddc1_clk_0                 (ddc_clk_0), 
     .ddc1_en_0                  (ddc_en_0), 
     .ddc1_clk_1                 (ddc_clk_1), 
     .ddc1_en_1                  (ddc_en_1), 
     .cs_global_regs_n           (csn_glb),
     .linear_origin              (hb_org),
     .hb_pdo            	 (hb_pdo),
     .mem_mask_bus               (hb_pix_msk),
     .read                       (hb_mem_read),
     .hb_mc_request_p            (hb_mem_req),
     .pci_mstr_en                (pci_mstr_en),
     .de_pl_busy                 (de_pl_busy),
     .flow_reg                   (flow_reg),
     .pci_wr_addr                (pci_wr_addr), 
     .pcim_masks                 (pcim_masks),
     .pa                         (P_A),           
     .pd_out                     (p_d_out),           
     .pwr_n                      (),
     .prd_n                      (),
     .pcs_n                      (),
     .poe_n                      (),
     .pwe_n                      (),
     .psft                       (),
     .pd_oe_n                    (p_d_oe_n),
     .idac_wr                    (idac_wr),
     .idac_rd                    (idac_rd),
     .cfg_reg2_ide               (idac_en),
     .mw_de_fip                  (mw_de_fip),
     .mw_dlp_fip                 (mw_dlp_fip),
     .enable_rbase_e_p           (enable_rbase_e_p),
     .se_clk_sel                 (),
     .hb_ldata                   (hb_ldata),
     .soft_switch_out            (ssro),
     .probe                      (hbi_probe),
     .probe_dec                  (probe_dec),
     .probe_hreg                 (probe_hreg),
     .probe_ddc                  (probe_ddc),
     .full                       (),
     .bios_clk                   (bios_clk),
     .bios_hld                   (bios_hld),
     .bios_csn                   (bios_csn),
     .bios_wdat                  (bios_wdat)
     );
  
  
  /**************************************************************************/
  /* 		INSTANTIATE DRAWING ENGINE                            */
  /**************************************************************************/
  
  de_top U_DE
    (
     .de_clk                     (de_clk),
     .hb_clk                     (hb_clk),
     .hb_rstn                    (bb_rstn),
     .hb_adr                     (de_adr[8:2]),
     .hb_adr_bp1                 (hb_adr_de[13:2]),
     .hb_adr_bp2                 (hb_adr[8:2]),
     .hb_wstrb_p1                (hb_wstrb_de),
     .hb_wstrb_p2                (de_wstrb),
     .hb_ben                     (de_ben), 
     .hb_din                     (de_data),      // from dlp no swizzle
     .hb_ben_cache               (hb_ben), 
     .hb_din_sw                  (hb_din),       // from hbi, swizzled
     .hb_csn_de                  (de_csn),
     .hb_xyw_csn                 (csn_de1_xyw),
     
     .mc_fb_in                   (mc_read_data),
     .mclock                     (mclock),
     .mc_popen                   (de1_popen),
     .mc_acken                   (de1_acken),
     .mc_push                    (de1_push),
     .mc_eop                     (de1_last),
     .mcrdy                      (de1_mem_rdy),
     .dl_rdback                  (pp_rdback),
     .mw_de_fip                  (mw_de_fip),
     .hb_write                   (hb_write),
     
     // outputs
     .hb_dout                    (de1_hdout),
     .dr_hbdout                  (de1_drout),
     .dx_deb                     (de1_deb),
     .dx_clp                     (de1_clp),
     .busy_hb                    (de1_busy),
     .de_ddint_tog               (de1_ddint_tog),
     .de_clint_tog               (de1_clint_tog),
     .dm_org_2                   (de1_org),
     .dm_ptch_2                  (de1_ptch),

     .de_mem_req                 (de1_mem_req),
     .dx_mem_rd                  (de1_mem_read),
     .dx_mem_rmw                 (de1_mem_rmw),
     .dm_x_pos                   (de1_x_pos),
     .dm_y_pos                   (de1_y_pos),
     .dm_wcnt                    (de1_wcnt),
     .dd_pixel_msk               (de1_pix_msk),
     .dd_fb_out                  (de1_pdo),
     .ca_busy                    (de1_ca_busy),
     .hdf_1                      (de1_hdf),
     .ps_2                       (de1_ps_2),
     .pc_mc_busy                 (pc_mc_busy),
     .bsrcr_2                    (de1_bsrcr),
     .bdstr_2                    (de1_bdstr),
     .blend_en_2                 (de1_blend_en),
     .ps565_2                    (de1_ps565),
     .bsrc_alpha_2               (de1_bsrc_alpha),
     .bdst_alpha_2               (de1_bdst_alpha),
     .rop_2                      (de1_rop),
     .kcol_2                     (de1_kcol),
     .key_ctrl_2                 (de1_kcnt), 
     .pipe_pending               (pipeline_active),
     .probe_misc                 (probe_misc),
     .probe_reg                  (probe_reg),
     .probe_sm                   (probe_sm),
     .probe_coord                (probe_coord),
     .probe_dex                  (probe_dex),
     .probe_deca                 (probe_deca)
     );
  
  /***************************************************************************/
  /* 		INSTANTIATE THE PRE PROCESSOR BLOCK.                  */
  /***************************************************************************/
  dlp_top U_DLP 
    (
     .hb_clk                     (hb_clk), 
     .hb_rstn                    (bb_rstn), 
     .hb_adr                     (hb_adr[8:2]),
     .hb_wstrb                   (hb_wstrb),
     .hb_ben                     (hb_ben), 
     .hb_csn                     (csn_de1), 
     .hb_din                     (hb_ldata), 
     .de_busy                    (de1_busy),
     .mclock                     (mclock),
     .mc_rdy                     (dlp_ready),
     .mc_push                    (dlp_push),
     .mc_done                    (dlp_mc_done),
     .pd_in                      (mc_read_data),
     .v_sync_tog                 (vb_int_tog),
     .cache_busy                 (mw_dlp_fip),
     
     .de_adr                     (de_adr),
     .de_wstrb                   (de_wstrb),
     .de_csn                     (de_csn),
     .de_ben                     (de_ben),
     .de_data                    (de_data),
     .dl_rdback                  (pp_rdback),    
     .mc_adr                     (dlp_addr),
     .dl_sen                     (dlp_sen),
     .dl_memreq                  (dlp_req),
     .hb_de_busy                 (hb_de_busy), 
     .probe                      (dlp_probe)
     );
		 

  /***************************************************************************/
  /* 			INSTANTIATE THE VGA MODULE                    */
  /* uses config_bus instead pdat_in , for better routing of high speed paths*/
  /***************************************************************************/
  
  
  vga_top U_VGA 
    (
     .mclock              (vga_mclock),
     .resetn              (bb_rstn),
     .hclk                (hb_clk),
     .crtclk              (pixclk_vga),
//     .crt_rstn            (crt_rstn),
     .vga_req             (vga_req), 
     .vga_rdwr            (vga_rdwr),
     .vga_mem             (vga_mem_io),
     .hst_byte            (vga_lbe[3:0]),
     .hst_addr            (vga_laddr[22:0]),
     .hst_din             (vga_ldata[31:0]),
     .mem_din             (vga_data),
     // .sense_n             (VGA_SENSE),
     .sense_n             (1'b0),
     .mem_ack_n           (vga_ack_n),
     .mem_ready_n         (vga_ready_n),
     .vga_en              (vga_mode),
     
     .hst_dout            (hst_data_out),
     .vga_stat            (vga_stat),
     .vga_push            (vga_push),
     .vga_ready           (vga_ready),
     .v_clksel            (v_clks),
     .v_pd                (v_pd),
     .v_blank             (v_blank),
     .v_hrtc              (v_hrtc),
     .v_vrtc              (v_vrtc),
     .vga_ref_n           (vga_ref_n),
     .mem_req             (mem_req),
     .vga_rd_wrn          (vga_rd_wrn),
     .vga_addr            (vga_addr),
     .vga_we              (vga_we),
     .vga_data_in         (vga_data_in),
//     .vga_rstn            (vga_rstn),
     .probe               (probe_vga),
     .probe1              (probe_vga1),
     .probe_memif         (probe_memif),
     .probe_vmem          (probe_vmem),
     .probe_crt           (probe_vcrt),
     .probe_cpuwr         (probe_cpuwr)
     );     

  /***************************************************************************/
  /* 		INSTANTIATE THE CRT CONTROLLER                        */
  /***************************************************************************/
  wire [1:0] 		  sereg;
  
  crt #(.disp_param(4'b0)) u_crt 
    (
     .crtclock            (crtclock),
     .pixclock            (pixclk),
     .hclock              (hb_clk), 
     .hreset              (bb_rstn),
     .hwr_in              (hb_wstrb_de),
     .hcs_in              (csn_glb),
     .hnben_in            (hb_ben),
     .hdat_in             (hb_din), 
     .haddr               (hb_adr_de[7:2]),
     .vga_en              (vga_mode),
     .vga_din             (v_pd),
     .dlp_wradd           (1'b0),    //to be connected to DLP (write enable, active high)
     .dlp_add             (21'b0),     //to be connected to DLP (display start address)
     
     .hdat_in_aux         (hst_data_out[31:0]), 
     .vid_win_pos         (44'b0),
     .bpp                 (bpp),
     .ovnokey             (1'b0), //from overlay module temp set to 0 
     
     .mcdc_ready          (dis_rdy),
     .mcpush              (dis_push), 
     .mclock              (mclock),
     .datdc_in            (mc_read_data),
//     .datdc_in            ({mc_read_data[111:96], mc_read_data[127:112],
//			    mc_read_data[79:64],  mc_read_data[95:80],
//			    mc_read_data[47:32],  mc_read_data[63:48],
//			    mc_read_data[15:0],   mc_read_data[31:16]}),
     
     .vga_blank           (v_blank),
     .vga_hsync           (v_hrtc),
     .vga_vsync           (v_vrtc),
     .disp_reg_rep        (1'b0),
     .disp_reg_crt        (4'b0),
     
     .hdat_out_crt_aux    (hdat_out_crt_vga),
     .hint_out_tog        ({hb_int_tog,vb_int_tog}), 
     .vblnkst2            (vblnkst2),
     
     .db_pitch_regist     (crt_ptch[11:0]),
     .displ_start_vs      (crt_org[20:0]),
     
     .mcdc_req            (dis_req),
     .mcdcyf              (dis_y),
     .mcdcx               (dis_x),
     .mcdcpg              (dis_page), 
     .blank_toidac        (blank_toidac),
     .hcsync_toidac       (hcsync_toidac),
     .vsync_toidac        (vsync_toidac), 
     .datdc_out           (pd_toidac),
     .fdp_on              (/*fdp_on*/),
     .probe               (crt_probe),
//     .crt_rstn            (crt_rstn),
     .probe_addr          (probe_addr),
     .syncsenable_regist  (sereg),
     .hactive_regist      (hactive_regist), 
     .horiz_actv_decode	  (horiz_actv_decode)
     );
  
/************************************************************/
/*	   INSTANTIATE THE BUS MASTERING UNIT PCI             */
/************************************************************/
  pci_wom U_BM
    (
     .reset_n             (bb_rstn),
     .hb_clk              (hb_clk),
     .gnt_n               (pgnntn),
     //.hbi_addr            (hb_adr[3:2]),
     //.ad_in               (pad[31:0]),
     .irdy_in_n           (pirdyn),
     .frame_in_n          (pframen),
     .trdy_in_n           (ptrdyn),
     .stop_in_n           (pstopn),
     .devsel_in_n         (pdevseln),
     .dlp_busy            (pp_rdback[21]),
     .de_pl_busy          (de_pl_busy),
     .flow_rpb            (flow_reg[4]),
     .flow_prv            (flow_reg[3]),
     .flow_clp            (flow_reg[2]),
     .flow_mcb            (flow_reg[1]),
     .flow_deb            (flow_reg[0]),
     .v_blank             (vblnkst2),     
     .vb_int_tog          (vb_int_tog),
     .hb_int_tog          (hb_int_tog),
     .pci_mstr_en         (pci_mstr_en),
     .pci_wr_addr         (pci_wr_addr),
     .pcim_masks          (pcim_masks),

     .pci_ad_out          (pcim_ad_out),
     .pci_ad_oe           (pcim_ad_oe),
     .c_be_out            (c_be_out),
     .irdy_n              (irdy_out_n),
     .pci_irdy_oe_n       (irdy_oe_n),
     .pci_req_out_n       (req_n), 
     .frame_out_n         (frame_out_n),
     .frame_oe_n          (frame_oe_n)
     );
   
/***************************************************************************/
/*      	 INSTANTIATE THE RAMDAC                               */
/***************************************************************************/
  
wire temp_psave;
assign dac_psaven =  ~temp_psave;  // CRT Power Save Signal.

ramdac u_ramdac
    // Inputs.
    (
     .hclk		(hb_clk),
     .pixclk            (pixclk),
     .crtclock		(crtclock),
     .hresetn		(dac_reset_n),
     .wrn		(idac_wr),
     .rdn		(idac_rd),
     .rs		(P_A[2:0]),
     .cpu_din		(p_d_out),
     .ext_fs		(v_clks),
     .blank		(blank_toidac),
     .hsyncin		(hcsync_toidac),
     .vsyncin		(vsync_toidac),
     .pix_din		(pd_toidac),
     .idac_en		(idac_en),
//     .ldi_2xzoom	(vga_controlreg[5]),
     .ldi_2xzoom	(ldi_2xzoom),
     .fdp_on            (1'b1),
     .pix_locked        (pix_locked & pix_locked_1),
     
     // Outputs.
     .bpp		(bpp),
     .vga_mode		(vga_mode),
     .dac_pwr		(temp_psave),
     .syncn2dac		(),
     .blanknr		(),
     .blankng		(),
     .blanknb		(),
     .sense		(),
     .cpu_dout		(idac_rd_data),
     .hsyncout		(HSYNC0n),
     .vsyncout		(VSYNC0n),
     .dac_cblankn       (dac_cblankn),
     .p0_red		(red),
     .p0_green		(grn),
     .p0_blue		(blu),
     .pixs              (),
     .display_en        (dvo_de),
     
     // For system PLL
     .sprog_mode        (sprog_mode),
     .spll_enab         (spll_enab),
     .sysmctl           (sysmctl),
     .sysnctl           (sysnctl),
     .syspctl           (syspctl),
     // For Pix PLL
     .ppll_enable       (ppll_enable),
     .pixclksel         (pixclksel),
     .int_fs            (int_fs),
     .sync_ext          (sync_ext),
     .p_update          (p_update),
     .pll_params        (pll_params),

     .probe             (r_probe),
     .probe_rcpu        (probe_rcpu),
     .probe_reg         (probe_rreg),
     .probe_pwr         (probe_pwr)
     
     );

  assign ledn = ~vga_mode;

/*************************************************************************/
/* 	   Host skew reduction PLL					 */
/* 	   PLL number two.        					 */
/*************************************************************************/
/*
hb_pll u_hb_pll
    (
     // Inputs.
     .inclk0        (hclock),
     .pllena        (1'b1),
     .areset        (1'b0), // (~hresetn),
     // Outputs.
     .c0            (hb_clk),
     .c1            (),
     .c2            (),
     .locked        ()
     );
*/
     
assign hb_clk = hclock;

/***************************************************************************/
/*      	 External PLL Interface.                                   */
/***************************************************************************/
  pll_intf u_pll_intf
    (
     .hclk                   (hb_clk),
     .hresetn                (bb_rstn),
     .p_update0              (p_update),
     .pll_params0            (pll_params),
     .p_update1              (1'b0),
     .pll_params1            (27'b0),

     .sclk                   (pll_sclk_int),
     .sdat                   (pll_sdat_int),
     .sdat_oe                (pll_sdat_oe),
     .sclk_oe                (pll_sclk_oe),
     .shift_done             (shift_done)
     );
  
/***************************************************************************/
/*      	 Clock Switcher And PLLs.                                  */
/***************************************************************************/
wire [1:0] 	   pll_locked;

clk_switch u_clk_switch 
    (
     .pll_clock    		(pll_clka),
     .bpp           		(bpp),
     .vga_mode      		(vga_mode),
     
     .pix_clk       		(pixclk),
     .pix_clk_vga      		(pixclk_vga),
     .crt_clk       		(crtclock)
     );

/*************************************************************************/
/* 	   System PLL		 					 */
/* 	   PLL number five.     					 */
/*************************************************************************/
// System PLL.

  spll_pll u_spll_pll
    (
     // Inputs.
     .inclk0        (pll_clkb),
     .pllena        (1'b1),
     .areset        (~hresetn),
     // Outputs.
     .c0            (vga_mclock),
     .c1            (de_clk),
//     .c2            (mclock180),
     .locked        (mem_locked)
     );

  assign  mclock180 = ~mclock;

  assign 	  sys_locked = 1'b1;

/*************************************************************************/
/* 	   Probes from here on.                  	  		 */
/*************************************************************************/


// assign TESTCLK0 = mclock;


endmodule

