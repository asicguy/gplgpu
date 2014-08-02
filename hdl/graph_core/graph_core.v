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
//  Title       :  Graphics core top level
//  File        :  graph_core.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This is the top level of the Guru core graphics logic. 
//  This file encompasses the IP for the Guru series of Display controllers. 
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//    U_HBI         hbi_top        Host interface (PCI)
//    U_VGA         vga_top        IBM(TM) Compatible VGA core
//    U_DE          de_top         Drawing engine
//    U_DLP         dlp_top        Display List Processor
//    U_DDR3        DDR3           DDR3 Memory interface
//    u_crt         crt_top        Display interface
//    u_ramdac      ramdac         Digital DAC
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps

// Include the VGA core
`define INCLUDE_VGA 1
// Set to include 3D, otherwise will build 2D only
`define CORE_3D  1
// Use internal PLLs
`define PLL_INT 1

// Defined in Quartus and build file.
// 128 bit memory bus
// `define BYTE16
// 64 bit memory bus
//`define BYTE8
// 32 bit memory bus
//`define BYTE4

// To compile the internal FIFO's as RAM, use the following:
// `define RAM_FIFO_104x128 1
// `define RAM_FIFO_271x128 1
// TEMP REMOVE,  `define RAM_FIFO_36x128  1
//`define RAM_FIFO_100x128 1
//`define RAM_FIFO_271x128 1
//`define RAM_FIFO_57x64   1
//`define RAM_FIFO_32x128a 1
//`define RAM_FIFO_32x64a  1
//`define RAM_SFIFO_39x128 1
//`define RAM_SFIFO_65x128 1

// DEFINES FOR CHIP CONFIGURATION.
// `define USE_EXT_PLL 1;
// `define USE_MC_64B 1;

// These defines replace the old straps that we used - inverted externally
//`define PCI_CLASS 1'b1; // Not VGA
`define PCI_CLASS 1'b0; // VGA

`define WINDOW_SIZE 2'b11;
`define EPROM_SIZE 1'b1;
`define MEM_TYPE 1'b1; 		// SDRAM/SGRAM
// `define MEM_TYPE 2'b11; 	// SDRAM/SGRAM 
`define MEM_DENSITY 2'b11; 	// How much memory we have (32MB SDRAM)
// `define MEM_DENSITY 2'b10; 	// How much memory we have (16MB SDRAM)
`define IDAC_ENABLE 1'b1;
`define PCI 1'b1;

//`define SBSYS_ID_STRAP 6'h1; // 8MB
//`define SBSYS_ID_STRAP 6'h3; // 16MB
`define SBSYS_ID_STRAP 6'h7;   // 32 MB

// Used to identify FPGA firmware version.
`define SBVEND_SEL_STRAP 1'b1;
// `define SBVEND_ID_STRAP 16'h010B;
// Added Signal TAP.
// `define SBVEND_ID_STRAP 16'h011B;
// Add BT clock in out.
// `define SBVEND_ID_STRAP 16'h012B;
// Remove BT clock in out.
// `define SBVEND_ID_STRAP 16'h013B;
// Fix 2D/3D switching, fixed NO AREA triangles.
// `define SBVEND_ID_STRAP 16'h104B;
// Fix 2D/3D switching, fixed NO AREA triangles.
// Change to PAL clock.
// `define SBVEND_ID_STRAP 16'h105B;
// Fixed 16BPP 3D bug.
// `define SBVEND_ID_STRAP 16'h200B;
// First release with textures, Z still not working, disabled.
// `define SBVEND_ID_STRAP 16'h300B;
// `define SBVEND_ID_STRAP 16'h302B;
// Fixed Hang in 2D core, pcbusy was disconnected.
// `define SBVEND_ID_STRAP 16'h303B;
// Fixed 3D/2D switching and Z buffer.
// `define SBVEND_ID_STRAP 16'h306B;
// `define SBVEND_ID_STRAP 16'h306B;
// `define SBVEND_ID_STRAP 16'h308B;
// Fixed Z-buffer and corruption, miss wired bit in pixel cache.
// `define SBVEND_ID_STRAP 16'h312B;
// `define SBVEND_ID_STRAP 16'h313B;
// Fixed filtering.
// `define SBVEND_ID_STRAP 16'h314B;
// Fixed 16 bit texturing problem.
// `define SBVEND_ID_STRAP 16'h315B;
// Fixed Float rounding problem in multiplier.
// `define SBVEND_ID_STRAP 16'h316B;
// Fixed texturing black spots and noise problem.
// `define SBVEND_ID_STRAP 16'h317B;
// Fixed CRT lock out problem.
// `define SBVEND_ID_STRAP 16'h318F;
// Fixed 780x780 problems.
// `define SBVEND_ID_STRAP 16'h319B;
// Fixed Resolution clock problem and mipmaps.
// `define SBVEND_ID_STRAP 16'h320B;
// Fixed Timing issue with mipmaps.
// `define SBVEND_ID_STRAP 16'h321B;
// Fixed another Timing issue with mipmaps.
// `define SBVEND_ID_STRAP 16'h322B;
// Fixed Blending.
// Fixed Color Keying
// Changed MIP Mapping to T2R4 Style LOD calculations.
// Set 780x780 pixel clock to 43.5MHz.
//`define SBVEND_ID_STRAP 16'h323B;
// Increased DDR3 Refresh speed..5MHz.
// `define SBVEND_ID_STRAP 16'h324B;
// Fixed 2D clipping problem.
// // This was causing texture corruption.
// `define SBVEND_ID_STRAP 16'h325B;
// Added Z cache, fixed setup engine/execution engine pipe line.
// Z Cache still has a slight problem.
// `define SBVEND_ID_STRAP 16'h326B;
// Continue performance work.
// `define SBVEND_ID_STRAP 16'h327B;
// Increased Memory speed to 333.
// FIxed Z always, should not read.
// Removed writes with all bytes masked.
// `define SBVEND_ID_STRAP 16'h328B;
// Change the DLP to request up to 8 pages.
// `define SBVEND_ID_STRAP 16'h329B;
// Just removed all signal tap.
// `define SBVEND_ID_STRAP 16'h330B;
// Changed mimaping and filtering.
// Still have ants.
// `define SBVEND_ID_STRAP 16'h331B;
// Added 8 more bits of precision for
// X, Y inputs to the interpolator.
// `define SBVEND_ID_STRAP 16'h332B;
// Fixed LOD calculations.
// `define SBVEND_ID_STRAP 16'h333B;
// Fixed LOD calculations.
// `define SBVEND_ID_STRAP 16'h336B;
// Fixed LOD negative U, V calculations.
// `define SBVEND_ID_STRAP 16'h338B;
// Fixed extended floating point in LOD U, V calculations.
// `define SBVEND_ID_STRAP 16'h339B;
// Fixed some timing problems, set MC clock to 300MHz.
// `define SBVEND_ID_STRAP 16'h340B;
// Change ARGB and FRsGsBs to fixed point
// interpolators, to save logic.
// `define SBVEND_ID_STRAP 16'h341B;
// Fixed Z/blending problem.
// `define SBVEND_ID_STRAP 16'h342B;
// Fixed Clipping Problem.
// `define SBVEND_ID_STRAP 16'h343B;
// Fixed Overflow problem.
//`define SBVEND_ID_STRAP 16'h344B;
// Fixed Overflow problem in PAL mode.
// Removed VGA core.
// `define SBVEND_ID_STRAP 16'h345B;
// Fixed black lines on left side.
// Connected BT_CLK to pixclk.
// `define SBVEND_ID_STRAP 16'h346B;
// Fix crt lock out during BLT.
// `define SBVEND_ID_STRAP 16'h347B;
// Fix DLP text mode.
// `define SBVEND_ID_STRAP 16'h348B;
// Removed Address extensions on DLP.
// NT driver was not clearing these and was causing
// corruption and hangs.
// `define SBVEND_ID_STRAP 16'h349B;
// Not Released.
// `define SBVEND_ID_STRAP 16'h350B;
// Fixed flashing one problem.
// DLP need to wait for cache.
// `define SBVEND_ID_STRAP 16'h351B;
// XXXXXXXXXXXXXXXXXXXXXXXXXX.
// `define SBVEND_ID_STRAP 16'h352B;
// Removed many warnings.
// `define SBVEND_ID_STRAP 16'h353B;
// `define SBVEND_ID_STRAP 16'h354B (NOT USED);
// Fixed triangles outside of window in the ATP.
// `define SBVEND_ID_STRAP 16'h355B;
// Fixed Z buffer problem which shows up in ATP.
// `define SBVEND_ID_STRAP 16'h356B;
//
////////////////////////////////////////////////////////////////////
//
// Major Release 359B.
//
// 1) Replace Clock synthesizer table with true clock generator.
//    Using Altera PLL reconfiguration.
// 2) Fixed register read back and defaults.
// 3) Added 3D line command.
// 4) Fixed problem with display controller at 32 BPP.
// 5) Fixed problem with specular.
// 6) Fixed problem with TOM 2D benchmark.
//
`define SBVEND_ID_STRAP 16'h359B;
`define PAL_CLOCK 1

// Turn on VGA generated refreshes.
// `define VGA_REF 1

`ifdef CORE_3D 
	`include "define_3d.h"
`endif

module graph_core
  #(parameter BYTES           = 16,
    parameter DE_ADDR         = 32'h800,	// DE Reg base address.
    parameter XYW_ADDR        = 32'h1000_0000 // DE Cache base address.
    )
  (
   // PCI I/O
   input	          hclock,	  // host clock input port
   input 	          hresetn,	  // host reset input port
   input 	          pframen,        // address strobe/FRAME signal
   input 	          pirdyn,         // Initiator ready signal
   inout 	          ptrdyn,         // Target ready
   inout 	          pdevseln,       // Device select
   input 	          pidsel,         // Initialization Device Select
   inout 	          pintan,         // Interrupt output
   inout 	          pstopn,         // Stop output
   inout 	          ppar,           // Parity output [31:0]
   input 	          preqn,          // pci request to arbiter
   input 	          pgnntn,        // pci grant from external arbiter
   input [3:0] 	          pcben,          // Command, byte enable
   inout [31:00]          pad,         	  // host address and data port
   // Serial BIOS Interface.
   input		  bios_rdat,	  // Serial bios input data.
   output		  bios_clk,	  // Serial bios clock.
   output		  bios_csn,	  // Serial bios chip select.
   output		  bios_wrn,	  // Serial bios write enable.
   output		  bios_hld,	  // Serial bios hold.
   output		  bios_wdat,	  // Serial bios write data.
   // Reference Clock
   input 	          pll_xbuf,       // PLL XBUF input (Pixel Clock Ref).
   input 	          pll_xbuf1,      // XBUF1, (DDR3 Clock Ref).
   inout                  pll_sclk,
   inout                  pll_sdat,
   //
   // Signals for the DVO, 
   //
   output 	          dvo_dclk,	  // DVI Transmitter Clock.
   output 	          dvo_hsync,	  // DVI Hsync out.
   output 	          dvo_vsync,	  // DVI Vsync or Csync out.
   output 	          dvo_de,	  // DVI Data Enable.
   output [23:0] 	  dvo_data,	  /* DVI/DAC Data output.
					   * For Single Edge DVI Data output.
					   * For Dual   Edge DVI Data output.
					   * For Dual Edge Dual link DVI Data output.
					   * For DAC {RED[7:0], GRN[7:0], BLU[7:0]} = DVI_D[23:0].
					   */
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
   input 	          bt_clko,	  // Clock input from the BT868 (37.5/29.5) MHz.
   output 	          bt_clki,	  // Clock output to the BT868.
   input 	          bt_field,	  // Field input from the BT868.
   output 	          bt_hsyncn,	  // Hsync input from the BT868.
   output 	          bt_vsyncn,	  // Vsync input from the BT868.
   output 	          bt_blankn,	  // Blank input from the BT868.
   output 	          bt_pal,	  // 1 = PAL, 0 = NTSC.
   //
   // Jumper Settings for testing or internal configuration
   // Special Function Pins.
   //
   input		  bt_clk_sel,	  // Selects between BT clock and 25MHz clock input.
   input 		  mb_32_sel,	  // Select 32MB of Memory.
   input		  vga_en,	  // VGA class_strap enable/disable VGA.
   input		  dual_enn,	  // Dual DVI Enable.
   input		  m66_en,	  // PCI 66MHz Enable.
   output                 ledn,		  // General purpose LED output.
   // Test Pins which go to the Mictor Conectors.
   input 		  mictor_clke,
   input 		  mictor_clko,
   input 	[15:0]	  mictor_de,
   input 	[15:0]	  mictor_do,
   output 	[19:0]	  gpio_3v,
   
   // Memory outputs
   output	          mem_odt,
   output		  mem_cs_n,
   output		  mem_cke,
   output [13:0]	  mem_addr,
   output [2:0]	          mem_ba,
   output		  mem_ras_n,
   output		  mem_cas_n,
   output		  mem_we_n,
   // output [BYTES/4-1:0]   mem_dm,
   inout		  mem_clk,
   inout		  mem_clk_n,
   output	          mem_reset_n,
   `ifdef RTL_SIM
   output [3:0]   	  mem_dm,
   inout [31:0]    	  mem_dq,
   inout [3:0]    	  mem_dqs,
   inout [3:0]    	  mem_dqsn
   `else
   output [7:0]   	  mem_dm,
   inout [63:0]    	  mem_dq,
   inout [7:0]    	  mem_dqs,
   inout [7:0]    	  mem_dqsn
   `endif
   );

// `include "define_2d"

  wire   bios_rdat_i;
  wire 	 hb_clk;

  assign bios_wrn = 1'b0;
  
  reg	[25:0]		LED_COUNTER;
  always @(posedge hb_clk) LED_COUNTER <= LED_COUNTER + 26'h1;
  assign ledn = LED_COUNTER[25];


  wire 			  bb_rstn;        // Global soft reset 
  wire 			  de_clk;

  wire 			  pll_sdat_oe;
  wire 			  pll_sclk_oe;
  
  // From Drawing Engine
  wire 			  de_busy;
  wire 			  de_mem_read;    // Read or write indicator to MC
  wire 			  de_mem_rmw;     // Read modify write on a write
  wire [31:0] 		  de_address;     // linear address
  wire [3:0] 		  de_wcnt;        // Number of pages to request
  wire [BYTES-1:0] 	  de_pix_msk;     // byte mask for data
  wire [(BYTES*8)-1:0] 	  de_pdo;         // Data to MC
  wire [(BYTES*4)-1:0] 	  de_ado;         // Data to MC
  wire [1:0] 		  de_ps_2;        // Pixel Size
  wire 			  de_pc_empty;    // empty flag from the PC FIFO
  wire [3:0] 		  de_bsrcr;       // Source Blending Register
  wire [2:0] 		  de_bdstr;       // Destination Blending Register
  wire 			  de_blend_en;    // Blending Enabled
  wire [1:0]	          de_blend_reg_en;// Blending Enabled
  wire [7:0] 		  de_bsrc_alpha;  // Source Alpha register
  wire [7:0] 		  de_bdst_alpha;  // Destination Alpha register
  wire [3:0] 		  de_rop;         // de raster op select
  wire [31:0] 		  de_kcol;        // key color
  wire [2:0] 		  de_kcnt;        // keying control
  wire 			  de_pc_pop;
  wire 			  line_actv_4;
  wire [6:0] 		  mem_offset;
  // Dual port ram interface for ded_ca_top.v
  `ifdef BYTE16 
  wire [3:0] 		  ca_enable;
  `elsif BYTE8  
  wire [1:0]              ca_enable;
  `else         
  wire 		          ca_enable; 
  `endif
  wire [3:0] 		  ca_byteena;      
  wire [4:0] 		  hb_ram_addr;
  wire 			  de_push;
  wire [(BYTES*8)-1:0]    mc_read_data;
  wire [4:0] 		  ca_ram_addr0;
  wire [4:0] 		  ca_ram_addr1;
  wire [(BYTES*8)-1:0]    hb_dout_ram;
  wire [(BYTES*8)-1:0]    ca_dout0;
  wire [(BYTES*8)-1:0]    ca_dout1;
  wire [4:0] 		  z_ctrl_4;
  wire [31:0] 		  z_address_4;
  wire [(BYTES*8)-1:0]    z_out;
  
  // From DLP
  wire [8:2] 		  dlp_adr;        // Drawing engine address from DLP
  wire 			  de_wstrb;       // DLP write strobe to DE
  wire 			  de_csn;         // DLP chip select for DE
  wire [3:0] 		  de_ben;         // BEN's from DLP to DE
  wire [31:0] 		  de_data;        // Data from DLP to DE
  wire [53:0] 		  pp_rdback;      // DLP register readback to host
  wire [27:0] 		  dlp_addr;       // DLP address to MC
  wire 			  dlp_sen;
  wire 			  dlp_req;        // DLP memory Controller Request
  wire [4:0] 		  dlp_wcnt;       // DLP memory Controller Word Count.
  wire [31:3] 		  dlp_src_addr;
  wire [25:3] 		  dlp_dst_addr;
  
  // From Memory Controller
  wire 			  de_popen;
  wire 			  de_last;
  wire 			  de_last4;
  wire 			  dlp_push;
  wire 			  dlp_mc_done;
  wire 			  dlp_ready;
  wire [1:0] 		  dqinclk;
  wire 			  mc_busy;     // Memory controller is busy
  wire 			  mc_busy2;    // Memory controller is busy
  wire 			  hb_de_busy;  // DE busy to host
  wire [7:0] 		  ssro;
  wire 			  dis_push;
  wire 			  dis_rdy;
  wire 			  hb_pop;
  wire 			  hb_push;
  wire 			  hb_mem_rdy;

  // Host interface signals
  wire [13:2] 		  hb_adr_de;      // Drawing engine address from host
  wire [8:2] 		  hb_adr;         // Host address
  wire [31:0] 		  hb_din;         // Host data
  wire [3:0] 		  hb_ben;         // Host bus byte enables
  wire                    hb_write;       // Host write enable
  wire                    hb_wstrb;       // Write Strobe to the DLP
  wire                    csn_de_xyw;     // XY Windows Chip Select
  wire                    csn_de;         // Drawing engine chip select
  wire [31:0] 		  de_hdout;       // host bus read back data
  wire [31:0] 		  de_drout;       // Drawing engine registers to HB
  wire 			  dlp_hold_start; // Hold the APB from writing the DLP
  wire [3:0] 		  sorg_upper;     // Upper 4 bits of the text sorg
  wire [2:0] 		  de_hdf;            // Host Data Format
  wire 			  ca_busy;
  wire 			  de_clp;            // Clip indicator
  wire 			  de_deb;            // Drawing engine busy
  wire 			  de_ddint_tog;
  wire 			  de_clint_tog;
  wire [31:0] 		  hb_ldata;
  wire [31:0] 		  vga_data;
  wire 			  vga_ack;
  wire 			  vga_ready_n;
  wire 			  csn_glb;          // Global register Chip Select
  wire [22:0] 		  hb_org;           // Host origin to MC
  wire [127:0] 		  hb_pdo;           // Host data to MC
  wire [15:0] 		  hb_pix_msk;       // Host Mask to MC
  wire 			  hb_mem_read;      // Read or write to MC
  wire 			  hb_mem_req;       // Issue a memory request to the MC
  wire [1:0] 		  hst_mw_addr;
  wire 			  phy_clk;

  // assign  mb_32_sel = 1'b1; // de_clk; // pll_xbuf;

  // Wires - Once were straps
  // wire [1:0] 	  window_size_strap = {t2r4_mode, mb_32_sel};
  wire [1:0] 	  window_size_strap = 2'b11;
  wire 		  eprom_strap 	    = `EPROM_SIZE
  wire 		  class_strap 	    = vga_en;
  wire [1:0] 	  mem_dens_strap    = 2'b11; // {t2r4_mode, mb_32_sel};
  wire 		  idac_strap 	    = `IDAC_ENABLE
  wire 		  mem_type_strap    = `MEM_TYPE
  wire 		  hbt_strap         = `PCI
  wire  	  sbvend_sel_strap  = `SBVEND_SEL_STRAP
  wire [15:0] 	  sbvend_id_strap   = `SBVEND_ID_STRAP
  
  wire [5:0] 	  sbsys_id_strap    = 6'h7; // (t2r4_mode &  mb_32_sel) ? 6'h7 : // 32MBytes.
  				      // (t2r4_mode & ~mb_32_sel) ? 6'h3 : // 16MBytes.
  				      // (~t2r4_mode & mb_32_sel) ? 6'h9 : // 256MBytes (FIX ME).
				      // 6'h8; 				// 128MBytes (FIX ME).

  // Wires - PCI
  // wire 			  frame_out_n;
  // wire 			  frame_oe_n;      
  // wire 			  irdy_out_n;
  // wire 			  irdy_oe_n;
  wire 			  hb_ctrl_oe_n;
  wire 			  trdy_out_n;
  wire 			  devsel_oe_n;
  wire 			  devsel_out_n;
  wire 			  intrp_oe_n;
  wire 			  intrp_out_n;
  wire 			  par32_oe_n;
  wire 			  stop_out_n;
  wire 			  req_n;
  wire 			  c_be_oe_n;
  wire 			  par32_out;
  wire 			  ad_oe32_n;
  wire [31:0] 		  ad_out;

  // MC Avalon Interfaces
  wire 			  local_ready;
  wire [BYTES*8-1:0]      local_rdata;
  wire 			  local_rdata_valid;
  
  wire [24:0] 		  local_address;
  wire 			  local_write_req;
  wire 			  local_read_req;
  wire 			  local_burstbegin;
  wire [BYTES*8-1:0]	  local_wdata;
  wire [BYTES-1:0] 	  local_be;
  wire [5:0] 		  local_size;
  wire 			  init_done;
  wire 			  ddc_clk_0, ddc_clk_1;
  wire 			  ddc_en_0, ddc_en_1;
  wire 			  ddc_dat_dout_0, ddc_dat_dout_1;
  wire 			  pipeline_active;
  wire 			  pll_sdat_int, pll_sclk_int;
  wire [11:0] 		  crt_ptch;
  wire [31:0] 		  vga_ldata;
  wire [22:0] 		  vga_laddr;
  wire [3:0] 		  vga_lbe;
  wire [31:0] 		  mc_config2reg;       // Configuration REG 2

  // Wires - Parallel Port
  wire [15:0] 		  P_A;    	  // Peripheral Address.
  wire 			  p_d_oe_n;
  wire [7:0] 		  p_d_out;
  
  wire [1:0] 		  bpp;      // Bits per pixel
  wire 			  p_update;
  wire [23:0] 		  pll_params;
  wire [1:0] 		  int_fs;
  wire [2:0] 		  pixclksel;
  wire [7:0] 		  red;
  wire [7:0] 		  grn;
  wire [7:0] 		  blu;
  wire 			  pixclk;
  wire [7:0] 		  idac_rd_data;      // Read data from ramdac registers
  wire [23:0] 		  pd_toidac;          // Pixel data to internal RAMDAC
  wire [13:0] 		  hactive_regist;
  wire [1:0] 		  sereg;
  wire [9:0] 		  dis_x;	 // Display controller X address
  wire [11:0] 		  dis_y;	 // Display controller Y address
  wire [4:0] 		  dis_page;      // Display controller page count upto 32

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
  wire [20:0] 	  crt_org;            // CRT Origin to MC
  wire 		  dis_req;            // CRT Request to MC
  wire 		  blank_toidac;
  wire 		  hcsync_toidac;
  wire 		  vsync_toidac;
  wire 		  ss_sel;
  wire 		  ss_line;
  wire 		  crt_rstn;

  // Bus master interface from HBI
  wire 			  pci_mstr_en;         // Hammer is a PCI master
  wire 			  de_pl_busy;
  wire [4:0] 		  flow_reg;
  wire [31:2] 		  pci_wr_addr;
  wire [21:0] 		  pcim_masks;
  wire 			  hbt_pci;
  
  // From Bus Master
  // wire [31:0] 		  pcim_ad_out;
  // wire 			  pcim_ad_oe;
  // wire [3:0] 		  c_be_out;
  
  // From RAMDAC.
  wire			rdac_hsync;
  wire			rdac_vsync;
  wire			rdac_cblankn;
  wire 			temp_psave;

  // Pixel Clocks
  wire			clk162p00;	// 1600x1200 60Hz.
  wire			clk108p00;	// 1280x1024 60Hz, 1152x864 75Hz.
  wire			clk65p00;	// 1024x768 60Hz.
  wire			clk43p50;	// 800x600 72Hz.
  wire			clk28p00;	// 720x480 60Hz.
  wire			clk25p17;	// 640x480 60Hz.
  wire			clk37p50;
  wire			vga_mode;
  wire			sync_ext;
  wire			pll_busy;
  wire			pll_write_param;
  wire [3:0]		pll_counter_type;
  wire [2:0]		pll_counter_param;
  wire [8:0]		pll_data_in;
  wire			pll_reconfig;

  // Misc wires.
  wire			vga_mclock;
  wire			dac_reset_n;
  wire			hb_wstrb_de;
  wire			vga_req;
  wire			ldi_2xzoom;
  wire			vga_rdwr;
  wire			vga_mem_io;
  wire			idac_wr;
  wire			idac_rd;
  wire			idac_en;
  wire			mw_de_fip;
  wire			mw_dlp_fip;
  wire			enable_rbase_e_p;
  wire			pixclk_vga;
  wire			crtclock;
  wire			interrupt;
  wire			pix_locked;
  wire			mem_locked;
  wire			locked;
  wire            	phy_reset_n;
  wire			clk100;
  wire			sys_locked;
  wire			pix_locked_37;
  wire			pix_locked_1;
  wire			pll_areset_in;
  // TC wires. 
  wire			mc_tc_push;
  wire [(BYTES<<3)-1:0] mc_tc_data;
  wire			mc_tc_ack;
  wire			mc_tc_req;
  wire	[5:0]		mc_tc_page;
  wire	[31:0]		mc_tc_address;
  wire  [3:0] 		mc_dev_sel;
  wire                  mc_pal_ack;
  wire                  mc_pal_push;
  wire                  mc_pal_req;
  wire                  mc_pal_half;
  wire [31:0] 		mc_pal_address;
  
  wire			ddr3_ready;
  wire			ddr3_rdata_valid;
  wire  		ddr3_write_req;
  wire  		ddr3_read_req;
  wire  		ddr3_burstbegin;
  wire  [23:0]		ddr3_address;
  wire  [4:0]		ddr3_size;
  wire	[255:0]		ddr3_rdata;
  wire  [255:0]		ddr3_wdata;
  wire  [31:0]		ddr3_be;
  
  assign bt_pal = 1'b1;		// 1 = PAL, 0 = NTSC.
  assign dac_sog = 1'b0;     	// Sync On Green Output.
  assign gpio_3v[19:1] = 19'h0;
  assign gpio_3v[0] = init_done;

  // assign  pframen  = (frame_oe_n) ? 1'bz : frame_out_n;
  // assign  pirdyn   = (irdy_oe_n) ? 1'bz : irdy_out_n;
  assign  ptrdyn   = (hb_ctrl_oe_n) ? 1'bz : trdy_out_n;
  assign  pdevseln = (devsel_oe_n) ? 1'bz : devsel_out_n;
  assign  pintan   = (intrp_oe_n) ? 1'bz : intrp_out_n;
  assign  pstopn   = (hb_ctrl_oe_n) ? 1'bz : stop_out_n;
  //
  // req_n must be tristated on reset pci 2.1 spec
  //
  // reg preqn_enable;
  // always @(posedge hclock) preqn_enable <= bb_rstn;
  // assign  preqn  = (preqn_enable) ? req_n : 1'bz;
  // assign  preqn  = (bb_rstn) ? req_n : 1'bz;

  // assign  pcben[3:0] = (c_be_oe_n) ? 4'bzzzz : c_be_out;

  assign  ppar       = (par32_oe_n) ? 1'bz : par32_out;
  assign  pad[31:24] = (ad_oe32_n) ? {8{1'bz}} : ad_out[31:24];
  assign  pad[23:16] = (ad_oe32_n) ? {8{1'bz}} : ad_out[23:16];
  assign  pad[15:8]  = (ad_oe32_n) ? {8{1'bz}} : ad_out[15:8];
  assign  pad[7:0]   = (ad_oe32_n) ? {8{1'bz}} : ad_out[7:0];

  // DIGITAL Outputs
  // 
  assign dvo_data = { red, grn, blu};

  assign dvo_hsync = rdac_hsync;
  assign dvo_vsync = rdac_vsync;
  assign bt_hsyncn = rdac_hsync;
  assign bt_vsyncn = rdac_vsync;
  assign bt_blankn = rdac_cblankn;

  assign dac_cblankn = rdac_cblankn;
  assign dac_psaven =  ~temp_psave;  // CRT Power Save Signal.
  assign dac_csyncn = 1'b1;	     // Composit Sync to DAC (for sync on green).

  // assign dvo_dclk = ~pixclk;
	bt_ddr_io u_dvo_ddr_io
		(
		.aclr		(~bb_rstn),
		.datain_h	(1'b0),
		.datain_l	(1'b1),
		.outclock	(pixclk),
		.dataout	(dvo_dclk)
		);

  //////////////////////////////////////////////////////////////////
  // DDC, I2C Muxing.
  // 
  
  wire 			  ddc_din =   (ssro[7]) ? pll_sdat_int :
			  (ssro[0]) ? dvo_dsel_sda :
			  ddc_sda;
  
  wire 			  ddc_clkin = (ssro[7]) ? pll_sclk_int :
			  (ssro[0]) ? dvo_bsel_scl :
       			  ddc_scl;
  
  assign ddc_sda = (~ddc_dat_dout_0 | ssro[7] | ssro[0]) ? 1'bz : 1'b0;
  assign ddc_scl = (~ddc_clk_0 | ssro[7] | ssro[0]) ? 1'bz : 1'b0;
  
  assign dvo_dsel_sda = (~ddc_dat_dout_0 | ssro[7] | ~ssro[0]) ? 1'bz : 1'b0;
  assign dvo_bsel_scl = (~ddc_clk_0 | ssro[7] | ~ssro[0]) ? 1'bz : 1'b0;

  assign pll_sclk = (ssro[7] & ddc_clk_0) ? 1'b0 : (~ssro[7] & pll_sclk_oe) ? pll_sclk_int : 1'bz;
  assign pll_sdat = (ssro[7] & ddc_dat_dout_0) ? 1'b0 : (~ssro[7] & pll_sdat_oe) ? pll_sdat_int : 1'bz;
		    
// Needed for PCI 66MHz
/*
`ifndef RTL_SIM
  pci_pll u_pci_pll
  	(
	.areset		(~hresetn),
	.inclk0		(hclock),
	.c0		(hb_clk),
	.locked		()
	);
`else
	assign hb_clk = hclock;
`endif
*/
	assign hb_clk = hclock;

// assign hb_clk = hclock;

assign ca_byteena = ~hb_ben;

  hbi_top U_HBI 
    (
     .devid_sel                  (2'b11),
     .hb_clk                     (hb_clk),
     .mclock                     (phy_clk),
     .vga_mclock                 (vga_mclock),
     .hreset_in_n                (hresetn), 
     .hb_ad_bus                  (pad), 
     .hb_byte_ens                (pcben), 
     .idsel                      (pidsel), 
     .frame_n                    (pframen),            
     .irdy_n                     (pirdyn), 
     .cmd_hdf                    (de_hdf), 
     .de_ca_busy                 (ca_busy), 
     .dda_int_tog                (de_ddint_tog), 
     .cla_int_tog                (de_clint_tog), 
     .clp_a                      (de_clp), 
     .deb_a                      (de_deb), 
     .draw_engine_a_dout         (de_hdout),
     .draw_engine_reg            (de_drout),
     .de_pipeln_activ            (pipeline_active), 
     .vga_mem_last               (vga_push), 
     .vga_mem_rdy                (vga_ready),

     .mcb                        (~de_pc_empty | ca_busy | mc_busy | mc_busy2), // fixme ???? 
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
     .crt_vertical_intrp_n       (dvo_vsync),
     .soft_switch_in             ({
				  1'b0,
				  1'b0,				 
				  1'b0,				 
				  dual_enn,				 
				  ~vga_en,				 
				  1'b0,				 
				  1'b0, // mb_32_sel,				 
				  1'b0  // t2r4_mode				 
				 }),
     .pci_ad_out                 (32'h0), // pcim_ad_out),
     .pci_ad_oe                  (1'b0),  // pcim_ad_oe),
     .idac_data_in               (idac_rd_data),
     .c_be_out                   (4'h0), // c_be_out),
     .vga_mode                   (vga_mode),
     .bios_rdat                  (/*bios_rdat), */ bios_rdat_i), //  FOR INTERNAL BIOS.
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
     .cs_xyw_a_n                 (csn_de_xyw),  
     .wr_en_p1                   (hb_wstrb_de),
     .wr_en_p2                   (hb_wstrb),
     .cs_draw_a_regs_n           (csn_de), 
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
     .full                       (),
     .bios_clk                   (bios_clk),
     .bios_hld                   (bios_hld),
     .bios_csn                   (bios_csn),
     .bios_wdat                  (bios_wdat)
     );

  

  // DE cache RAMs
  // dual_port_sim u_ram0[BYTES/4-1:0]
  ram_32x32_dp_be u_ram0[BYTES/4-1:0]
    (
     .clock_a           (hb_clk),
     .data_a            (hb_din),
     .wren_a            (ca_enable),      
     .byteena_a         (ca_byteena),      
     .address_a         (hb_ram_addr),
     .clock_b           (phy_clk),
     .data_b            (mc_read_data),
     .address_b         (ca_ram_addr0),
     .wren_b            (de_push),
     
     .q_a               (hb_dout_ram),
     .q_b               (ca_dout0)
     );
  
  // dual_port_sim u_ram4[BYTES/4-1:0]
  ram_32x32_dp_be u_ram4[BYTES/4-1:0]
    (
     .clock_a           (hb_clk),
     .data_a            (hb_din),
     .wren_a            (ca_enable),      
     .byteena_a         (ca_byteena),      
     .address_a         (hb_ram_addr),
     .clock_b           (phy_clk),
     .data_b            (mc_read_data),
     .address_b         (ca_ram_addr1),
     .wren_b            (de_push),
     
     .q_a               (),
     .q_b               (ca_dout1)
     );

    `ifdef INCLUDE_VGA

  reg 			  init_done_sync, init_done_v;

  always @(posedge vga_mclock, negedge bb_rstn)
    if (!bb_rstn) init_done_sync <= 1'b0;
    else 	  init_done_sync <= init_done;
  
  always @(posedge vga_mclock, negedge bb_rstn)
    if (!bb_rstn) init_done_v    <= 1'b0;
    else 	  init_done_v    <= init_done_sync;

  vga_top U_VGA 
    (
     .mclock              (vga_mclock),
     .resetn              (bb_rstn),
     .hclk                (hb_clk),
     .crtclk              (pixclk),
     .vga_req             (vga_req), 
     .vga_rdwr            (vga_rdwr),
     .vga_mem             (vga_mem_io),
     .hst_byte            (vga_lbe[3:0]),
     .hst_addr            (vga_laddr[22:0]),
     .hst_din             (vga_ldata[31:0]),
     .mem_din             (vga_data),
     .sense_n             (1'b0),
     .mem_ack             (vga_ack),
     .mem_ready_n         (vga_ready_n),
     .vga_en              (vga_mode),
     .mem_ready           (init_done_v),
     
     .hst_dout            (hst_data_out),
     .vga_stat            (vga_stat),
     .vga_push            (vga_push),
     .vga_ready           (vga_ready),
     .v_clksel            (v_clks),
     .v_pd                (v_pd),
     .v_blank             (v_blank),
     .v_hrtc              (v_hrtc),
     .v_vrtc              (v_vrtc),
     .mem_req             (mem_req),
     .vga_rd_wrn          (vga_rd_wrn),
     .vga_addr            (vga_addr),
     .vga_we              (vga_we),
     .vga_data_in         (vga_data_in)
     );     
     `else
     assign hst_data_out = 32'h0;
     assign vga_stat 	 =  3'h0;
     assign vga_push 	 =  1'b0;
     assign vga_ready 	 =  1'b0;
     assign v_clks 	 =  1'h0;
     assign v_pd 	 =  8'h0;
     assign v_blank 	 =  1'h0;
     assign v_hrtc 	 =  1'h0;
     assign v_vrtc 	 =  1'h0;
     assign mem_req 	 =  1'h0;
     assign vga_rd_wrn 	 =  1'h0;
     assign vga_addr 	 = 18'h0;
     assign vga_we 	 =  4'h0;
     assign vga_data_in  = 32'h0;
     `endif

  crt #(.disp_param(4'b0)) u_crt 
    (
     .bpp                 (bpp),
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
     .vid_win_pos         (40'b0),
     .ovnokey             (1'b0), //from overlay module temp set to 0 
     
     .mcdc_ready          (dis_rdy),
     .mcpush              (dis_push), 
     .mclock              (phy_clk),
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
     .syncsenable_regist  (sereg),
     .hactive_regist      (hactive_regist) 
     );
  
/************************************************************/
/*	   INSTANTIATE THE BUS MASTERING UNIT PCI             */
/************************************************************/
/*
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
     */
   
/***************************************************************************/
/*      	 INSTANTIATE THE RAMDAC                               */
/***************************************************************************/
  

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
     .hsyncout		(rdac_hsync),
     .vsyncout		(rdac_vsync),
     .dac_cblankn       (rdac_cblankn),
     .p0_red		(red),
     .p0_green		(grn),
     .p0_blue		(blu),
     .pixs              (),
     .display_en        (dvo_de),
     
     // For Pix PLL
     .pll_busy         	(pll_busy),
     .pll_write_param  	(pll_write_param),
     .pll_counter_type 	(pll_counter_type),
     .pll_counter_param (pll_counter_param),
     .pll_data_in 	(pll_data_in),
     .pll_reconfig 	(pll_reconfig),
     .pixclksel         (pixclksel),
     .int_fs            (int_fs),
     .sync_ext          (sync_ext),
     .pll_areset_in     (pll_areset_in)
     );

  // assign ledn = ~vga_mode;

  /**************************************************************************/
  /*            INSTANTIATE DRAWING ENGINE                            */
  /**************************************************************************/
  de_top
    #
    (
     .BYTES                      (BYTES)
     ) 
  U_DE
    (
     .de_clk                     (de_clk),
     .sys_locked		 (sys_locked),
     .hb_clk                     (hb_clk),
     .hb_rstn                    (bb_rstn),
     .dlp_adr                    (dlp_adr[8:2]),
     .hb_adr_bp1                 (hb_adr_de[13:2]),
     .hb_adr_bp2                 (hb_adr[8:2]),
     .hb_wstrb                   (de_wstrb),
     .hb_ben                     (de_ben), 
     .hb_din                     (de_data),      // from dlp no swizzle
     .hb_csn_de                  (de_csn),
     .hb_xyw_csn                 (csn_de_xyw),
     
     .mclock                     (phy_clk),
     .mc_popen                   (de_popen),
     .mc_push                    (de_push),
     .mc_eop                     (de_last),
     .mc_eop4                    (de_last4),
     .de_pc_pop                  (de_pc_pop),
     .dl_rdback                  (pp_rdback),
     .mw_de_fip                  (mw_de_fip),
     .hb_write                   (hb_write),
     .mc_busy                    (mc_busy),
     .busy_dlp			 (hb_de_busy),
     
     // outputs
     .hb_dout                    (de_hdout),
     .dr_hbdout                  (de_drout),
     .busy_hb                    (de_busy),
     .interrupt                  (interrupt),

     .dd_pixel_msk               (de_pix_msk),
     .dd_fb_out                  (de_pdo),
     .dd_fb_a                    (de_ado),
     .de_pc_empty                (de_pc_empty),
     .hdf_1                      (de_hdf),
     .ps_4                       (de_ps_2),
     .de_mc_address              (de_address),
     .de_mc_read                 (de_mem_read),
     .de_mc_rmw                  (de_mem_rmw),
     .de_mc_wcnt                 (de_wcnt),
     .line_actv_4                (line_actv_4),

     .bsrcr_4                    (de_bsrcr),
     .bdstr_4                    (de_bdstr),
     .blend_en_4                 (de_blend_en),
     .blend_reg_en_4             (de_blend_reg_en),
     .bsrc_alpha_4               (de_bsrc_alpha),
     .bdst_alpha_4               (de_bdst_alpha),
     .rop_4                      (de_rop),
     .kcol_4                     (de_kcol),
     .key_ctrl_4                 (de_kcnt),

     .ca_enable                  (ca_enable),
     .hb_ram_addr                (hb_ram_addr),
     .ca_ram_addr0               (ca_ram_addr0),
     .ca_ram_addr1               (ca_ram_addr1),
     .hb_dout_ram                (hb_dout_ram),
     .ca_dout0                   (ca_dout0),
     .ca_dout1                   (ca_dout1),
     .mem_offset                 (mem_offset),
     .sorg_upper                 (sorg_upper),
     .ca_busy                    (ca_busy),
     .de_ddint_tog               (de_ddint_tog), 
     .de_clint_tog               (de_clint_tog), 
     .dx_clp                     (de_clp), 
     .dx_deb                     (de_deb),
     .pipe_pending               (pipeline_active),
     .z_ctrl_4               	 (z_ctrl_4),
     .z_address_4              	 (z_address_4),
     .z_out              	 (z_out),
     // TC Signals To/from the Memory Controller.
     // Inputs.
     .mc_tc_push		(mc_tc_push),
     .mc_tc_data		(mc_tc_data),
     .mc_tc_ack			(mc_tc_ack),
     .mc_pal_ack                (mc_pal_ack),
     .mc_pal_push               (mc_pal_push),
     // Outputs.
     .mc_tc_req			(mc_tc_req),
     .mc_tc_page		(mc_tc_page),
     .mc_tc_address		(mc_tc_address),
     .mc_pal_req                (mc_pal_req),
     .mc_pal_half               (mc_pal_half),
     .mc_pal_address            (mc_pal_address)
     );
  
  /***************************************************************************/
  /*            INSTANTIATE THE PRE PROCESSOR BLOCK.                  */
  /***************************************************************************/
  dlp_top 
    #
    (
     .BYTES                      (BYTES)
     ) 
  U_DLP
    (
     .hb_clk                     (hb_clk), 
     .hb_rstn                    (bb_rstn), 
     .hb_adr                     (hb_adr[8:2]),
     .hb_wstrb                   (hb_wstrb),
     .hb_ben                     (hb_ben), 
     .hb_csn                     (csn_de), 
     .hb_din                     (hb_ldata),
     .dlp_offset                 (mem_offset[6:3]),
     .de_busy                    (de_busy),
     .mclock                     (phy_clk),
     .mc_rdy                     (dlp_ready),
     .mc_push                    (dlp_push),
     .mc_done                    (dlp_mc_done),
     .pd_in                      (mc_read_data),
     .v_sync_tog                 (vb_int_tog),
     .cache_busy                 (mw_dlp_fip),
     .sorg_upper                 (sorg_upper),
     
     .de_adr                     (dlp_adr),
     .de_wstrb                   (de_wstrb),
     .de_csn                     (de_csn),
     .de_ben                     (de_ben),
     .de_data                    (de_data),
     .dl_rdback                  (pp_rdback),    
     .mc_adr                     (dlp_addr),
     .dl_sen                     (dlp_sen),
     .dl_memreq                  (dlp_req),
     .dlp_wcnt                   (dlp_wcnt),
     .hb_de_busy                 (hb_de_busy),
     .hold_start                 (dlp_hold_start)
     );
                 
  /***************************************************************************/
  /*            INSTANTIATE THE MEMORY CONTROLLER.                    */
  /***************************************************************************/

  mc 
    #(
      .BYTES                     (BYTES)
      ) 
  u_mc
    (
     .de_bdst_alpha              (de_bdst_alpha), 
     .de_bdstr                   (de_bdstr), 
     .de_blend_en                (de_blend_en), 
     .de_blend_reg_en            (de_blend_reg_en), 
     .de_bsrc_alpha              (de_bsrc_alpha), 
     .de_bsrcr                   (de_bsrcr), 
     .de_byte_mask               (de_pix_msk),
     .de_data                    (de_pdo),
     .de_adata                   (de_ado),
     .de_kcnt                    (de_kcnt), 
     .de_kcol                    (de_kcol), 
     .de_page                    (de_wcnt),  
     .de_pix                     (de_ps_2), 
     .de_read                    (de_mem_read), 
     .de_rmw                     (de_mem_rmw),
     .de_rop                     (de_rop),
     .de_address                 (de_address),
     .de_pc_empty                (de_pc_empty),
     .de_pc_pop                  (de_pc_pop),
     .line_actv_4                (line_actv_4),
     .de_zen                	 (z_ctrl_4[3]),
     .de_zro                	 (z_ctrl_4[4]),
     .de_zop                	 (z_ctrl_4[2:0]),
     .de_zaddr                	 (z_address_4),
     .de_zdata                	 (z_out),
     
     .dlp_org                    (dlp_addr), 
     .dlp_req                    (dlp_req),
     .dlp_wcnt                   (dlp_wcnt),
 
     .hst_clock                  (hb_clk), 
     .hst_byte_mask              (hb_pix_msk), 
     .hst_data                   (hb_pdo), 
     .hst_org                    (hb_org), 
     .hst_read                   (hb_mem_read), 
     .hst_req                    (hb_mem_req),
     
     .pixclk                     (pixclk),
     .crt_clock                  (crtclock),
     .crt_req                    (dis_req),
     .crt_org                    (crt_org),
     .crt_page                   (dis_page),
     .crt_ptch                   (crt_ptch),
     .crt_x                      (dis_x),
     .crt_y                      (dis_y),
   
     .vga_mode                   (vga_mode),
     .v_mclock                   (vga_mclock),
     .vga_req                    (mem_req),
     .vga_rd_wrn                 (vga_rd_wrn),
     .vga_addr                   (vga_addr),
     .vga_we                     (vga_we),
     .vga_data_in                (vga_data_in),

     // From Texel Cache.
     .tc_address		(mc_tc_address),
     .tc_page			(mc_tc_page),
     .tc_req			(mc_tc_req),

     // Palette
     .pal_req                   (mc_pal_req),
     .pal_half                  (mc_pal_half),
     .pal_address               (mc_pal_address),
     .pal_ack                   (mc_pal_ack),
     .pal_push                  (mc_pal_push),
     
     .mclock                     (phy_clk), 
     .reset_n           	 (phy_reset_n),
     // .reset                      (bb_rstn), 
     // .reset                      (hresetn), 

     .de_popen                   (de_popen), 
     .de_push                    (de_push), 
     .de_last                    (de_last),
     .de_last4                   (de_last4),
     
     .dlp_push                   (dlp_push), 
     .dlp_mc_done                (dlp_mc_done), 
     .dlp_ready                  (dlp_ready), 

     .hst_pop                    (hb_pop), 
     .hst_push                   (hb_push), 
     .hst_rdy                    (hb_mem_rdy), 
     .hst_mw_addr                (hst_mw_addr),

     .read_data                  (mc_read_data),
     .mcb                        (mc_busy),
     .mc_busy                    (mc_busy2),
     .crt_push                   (dis_push),
     .crt_ready                  (dis_rdy),

     .vga_data                   (vga_data),
     .vga_ack                    (vga_ack),
     .vga_ready_n                (vga_ready_n),
     
     // To Texel Cache.
     .tc_ack			(mc_tc_ack),
     .tc_push			(mc_tc_push),

     .local_ready                (local_ready),
     .local_rdata                (local_rdata),
     .local_rdata_valid          (local_rdata_valid),
     
     .local_address              (local_address),
     .local_write_req            (local_write_req),
     .local_read_req             (local_read_req),
     .local_burstbegin           (local_burstbegin),
     .local_wdata                (local_wdata),
     .local_be                   (local_be),
     .local_size                 (local_size),
     .init_done                  (init_done),
     .dev_sel                    (mc_dev_sel)
     );

mc_cache u_mc_cache
	(
	.mclock			(phy_clk),
	.mc_rstn		(phy_reset_n),
	.mc_dev_sel		(mc_dev_sel),
	.mc_local_write_req	(local_write_req),
	.mc_local_read_req	(local_read_req),
	.mc_local_burstbegin	(local_burstbegin),
	.mc_local_address	(local_address),
	.mc_local_wdata		(local_wdata),
	.mc_local_be		(local_be),
	.mc_local_size		(local_size),
	.mc_local_ready		(local_ready),
	.mc_local_rdata		(local_rdata),
	.mc_local_rdata_valid	(local_rdata_valid),
	// to/from ddr3
	.ddr3_ready		(ddr3_ready),
	.ddr3_rdata		(ddr3_rdata),
	.ddr3_rdata_valid	(ddr3_rdata_valid),
	.ddr3_write_req		(ddr3_write_req),
	.ddr3_read_req		(ddr3_read_req),
	.ddr3_burstbegin	(ddr3_burstbegin),
	.ddr3_address		(ddr3_address),
	.ddr3_wdata		(ddr3_wdata),
	.ddr3_be		(ddr3_be),
	.ddr3_size		(ddr3_size)
	);

     // Outputs.
     assign mc_tc_data  = mc_read_data;

  `ifdef FAST_MEM_FULL
  avalon_fast_model U_DDR3
  `else
  ddr3_int U_DDR3
  `endif
    (
     .local_address             (ddr3_address),
     .local_write_req           (ddr3_write_req),
     .local_read_req            (ddr3_read_req),
     .local_burstbegin          (ddr3_burstbegin),
     .local_wdata               (ddr3_wdata),
     .local_be                  (ddr3_be),
     .local_size                (ddr3_size),
     .pll_ref_clk               (pll_xbuf1),
     .global_reset_n            (bb_rstn),
     // .pll_ref_clk               (hclock),
     // .global_reset_n            (hresetn),
     .soft_reset_n              (1'b1),
     .local_ready               (ddr3_ready),
     .local_rdata               (ddr3_rdata),
     .local_rdata_valid         (ddr3_rdata_valid),
     .reset_request_n           (),
     .mem_odt                   (mem_odt),
     .mem_cs_n                  (mem_cs_n),
     .mem_cke                   (mem_cke),
     .mem_addr                  (mem_addr[12:0]),
     .mem_ba                    (mem_ba),
     .mem_ras_n                 (mem_ras_n),
     .mem_cas_n                 (mem_cas_n),
     .mem_we_n                  (mem_we_n),
     .mem_dm                    (mem_dm),
     .local_refresh_ack         (),
     .local_wdata_req           (),
     .local_init_done           (init_done),
     .mem_reset_n               (mem_reset_n),
     .dll_reference_clk         (),
     .dqs_delay_ctrl_export     (),
     .phy_clk                   (phy_clk),
     .reset_phy_clk_n           (phy_reset_n),
     .aux_full_rate_clk         (),
     .aux_half_rate_clk         (),
     .mem_clk                   (mem_clk),
     .mem_clk_n                 (mem_clk_n),
     .mem_dq                    (mem_dq),
     .mem_dqs                   (mem_dqs),
     .mem_dqsn                  (mem_dqsn)
     );  

     assign mem_addr[13] = 1'b0;
  
     `ifdef EX_PLL
  // External PLL Interface.
  pll_intf u_pll_intf
    (
     .hclk                   (hb_clk),
     .hresetn                (bb_rstn),
     .p_update               (p_update),
     .pll_params             (pll_params),
     .m66_en                 (1'b1),
     .alt_pll_lock           (1'b1),
     // .p_update1              (1'b0),
     // .pll_params1            (27'b0),

     .sclk                   (pll_sclk_int),
     .sdat                   (pll_sdat_int),
     .sdat_oe                (pll_sdat_oe),
     .sclk_oe                (pll_sclk_oe),
     .shift_done             (),
     .ext_pll_locked         ()
     );
     `else

     assign pll_sclk_int = 1'b0;
     assign pll_sdat_int = 1'b0;
     assign pll_sdat_oe  = 1'b0;
     assign pll_sclk_oe  = 1'b0;

     `endif


`ifdef RTL_SIM
	reg clk162p00_tmp;
	reg clk108p00_tmp;
	reg clk65p00_tmp;
	reg clk43p50_tmp;
	reg clk28p00_tmp;
	reg clk25p17_tmp;
	reg vga_mclock_tmp;
	reg de_clk_tmp;

	assign clk162p00 = clk162p00_tmp;
	assign clk108p00 = clk108p00_tmp;
	assign clk65p00  = clk65p00_tmp;
	assign clk43p50  = clk43p50_tmp;
	assign clk28p00  = clk28p00_tmp;
	assign clk25p17  = clk25p17_tmp;
	assign pix_locked = 1'b1;
	assign vga_mclock = vga_mclock_tmp;
	assign de_clk = de_clk_tmp;
	assign mem_locked = 1'b1;
   assign pixclk = clk28p00_tmp;
   assign crtclock = clk28p00_tmp;

	always begin
		#3.08 clk162p00_tmp = 0;
		#3.08 clk162p00_tmp = 1;
	end
	always begin
		#4.63 clk108p00_tmp = 0;
		#4.63 clk108p00_tmp = 1;
	end
	always begin
		#7.69 clk65p00_tmp = 0;
		#7.69 clk65p00_tmp = 1;
	end
	always begin
		#11.50 clk43p50_tmp = 0;
		#11.50 clk43p50_tmp = 1;
	end
	always begin
		#17.86 clk28p00_tmp = 0;
		#17.86 clk28p00_tmp = 1;
	end
	always begin
		#19.86 clk25p17_tmp = 0;
		#19.86 clk25p17_tmp = 1;
	end
	always begin
		#10 vga_mclock_tmp = 0;
		#10 vga_mclock_tmp = 1;
	end
	always begin
		#5 de_clk_tmp = 0;
		#5 de_clk_tmp = 1;
	end

	assign bt_clki = bt_clko;
	assign sys_locked = 1'b1;
`else

  ///////////////////////////////////////////////////
  // System PLL, xbuf_1 Clock source
  //
  
  sys_pll_rb u_sys_pll_rb
  	(
	.areset		(~bb_rstn),
	.inclk0		(pll_xbuf),	// 25.00Hz
	.c0		(de_clk),	// 
	.c1		(vga_mclock),	// 
	.locked		(sys_locked)
	);

	`ifdef PLL_INT

  ///////////////////////////////////////////////////
  // Internal reconfigurable PLL.
  // 
  clk_gen_ipll u_clk_gen_ipll
	(
	.hb_clk			(hb_clk),
	.hb_resetn		(bb_rstn),
	.refclk			(bt_clko),
	.bpp			(bpp),
	.vga_mode		(vga_mode),
	.write_param		(pll_write_param),
	.counter_type		(pll_counter_type),
	.counter_param		(pll_counter_param),
	.data_in		(pll_data_in),
	.reconfig		(pll_reconfig),
	.pll_areset_in		(pll_areset_in),

	.busy			(pll_busy),
	.pix_clk		(pixclk),
     	.crt_clk       		(crtclock),
	.pix_clk_vga		(),
	.pix_locked		(pix_locked)
	);

	// assign bt_clki = pixclk;

	bt_ddr_io u_bt_ddr_io
		(
		.aclr		(~bb_rstn),
		.datain_h	(1'b1),
		.datain_l	(1'b0),
		.outclock	(pixclk),
		.dataout	(bt_clki)
		);

     `else

  ///////////////////////////////////////////////////
  // Internal PLL with clock switch.
  // Pixel Clock PLL
  wire bt_clk_1x;

/*
  // Generate the 37.5MHz from the 25MHz input
  pll_25_37p5 u_pix_pll2
  	(
	.areset		(1'b0), // ~bb_rstn),
	.inclk0		(pll_xbuf1),	// 25.0MHz
	.c0		(clk37p50),	// 37.5MHz, 800x600 60Hz, 780x780 60hz.
	.locked		(pix_locked_37)
	);
*/

  
  pix_pll_bt u_pix_pll0
  	(
	.areset		(1'b0), // ~bb_rstn),
	// .clkswitch	(bt_clk_sel),
	// .inclk0		(pll_xbuf), // clk37p50),	// 25.5MHz or 37.5MHz
	.inclk0		(bt_clko),	// 29.5MHz or 37.5MHz
	.c3		(clk65p00),	// 1024x768 60Hz.
	.c2		(clk25p17),	// 640x480 60Hz.
	.c1		(clk43p50),	// 43.5MHz, 800x600 60Hz, 780x780 60hz.
	.c0		(bt_clk_1x), 	// bt_clki),	// 29.5MHz or 37.5MHz, 1X output.
	.locked		(pix_locked)
	);

  // Clock Switcher And PLLs.
wire	pixclk_i;
/*
  clk_gen u_clk_gen 
    (
     .hb_clk    		(hb_clk),
     .hb_resetn    		(hresetn),
     // .pll_locked    		((pix_locked & pix_locked_1)),
     .pll_locked    		(1'b1), // pix_locked),
     .pll_clocks    		({
     				1'b0,
				1'b0, 		// clk162p00,	// 1600x1200 60Hz.
				clk108p00,	// 1280x1024 60Hz, 1152x864 75Hz.
				clk65p00,	// 1024x768 60Hz.
				clk43p50,	// 800x600, 780x780, 60Hz
				1'b0	,	// 720x480 60Hz.
				clk25p17,	// 640x480 60Hz.
				bt_clk_1x	// 1X 29.5MHz or 37.5MHz (PAL).
				}),
     .bpp           		(bpp),
     .hactive_regist      	(hactive_regist), 
     .pixclksel      		(pixclksel),
     .vga_mode      		(vga_mode),
     .int_fs      		(int_fs),
     .sync_ext      		(sync_ext),
     
     .pix_clk       		(pixclk_i),
     .pix_clk_vga      		(pixclk_vga),
     .crt_clk       		(crtclock),
     .locked       		(locked)
     );
     */

wire	[2:0]	int_clk_sel;

  clk_gen u_clk_gen 
    (
     .hb_clk    		(hb_clk),
     .hb_resetn    		(hresetn),
     // .pll_locked    		((pix_locked & pix_locked_1)),
     .pll_locked    		(1'b1), // pix_locked),
     .bpp           		(bpp),
     .hactive_regist      	(hactive_regist), 
     .pixclksel      		(pixclksel),
     .vga_mode      		(vga_mode),
     .int_fs      		(int_fs),
     .sync_ext      		(sync_ext),
     .pix_clk      		(pixclk),
     
     .crt_clk       		(crtclock),
     .locked       		(locked),
     .int_clk_sel       	(int_clk_sel)
     );


    clk_global u_clk_global
    	(
	.clkselect	(int_clk_sel[1:0]),
	.inclk3x	(clk65p00),
	.inclk2x	(clk43p50),
	.inclk1x	(clk25p17),
	.inclk0x	(bt_clk_1x),
	.outclk		(pixclk)
	);

	assign bt_clki = pixclk;


	`endif
`endif


`ifdef INCLUDE_VGA
  // The BIOS is compiled to fit in an internal memory to make life a little
  // easier
   bios_internal u_bios_internal
     (
      .hb_clk        (hb_clk),
      .hresetn       (hresetn), 
      .bios_clk	     (bios_clk),
      .bios_wdat     (bios_wdat),
      .bios_csn	     (bios_csn),
      .bios_rdat     (bios_rdat_i)
      );
`else   
`endif
endmodule

