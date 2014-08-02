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
//  Title       :  Host Bus Interface Register Block
//  File        :  hbi_regblock.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  module that contains all the host bus interface registers
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
`timescale 1ns/10ps

module hbi_regblock
  (
   input [1:0]      devid_sel,
   input	    hb_clk,                // host bus clock
   input [8:2]	    hbi_addr_in,           // HBI low address bits
   input [31:0]     hbi_data_in,           // HBI data bus internal
   input [3:0]	    hbi_byte_en_in,        // 8 byte enables for the 64bit bus
   input	    wr_en,                 /* write enable master pulse.
					    * write enable is active high */
   input [31:0]     config_bus,            // configuration bus
   input	    sys_reset_n,           // HBI system reset
   input	    cs_blk_config_regs_n,  /* chip select BBIRD configuration
					    * registers (active low signal) */
   input	    cs_global_intrp_reg_n, /* chip select interrupt global 
					    * registers (active low signal)*/
   input	    cs_window_regs_n,      /* chip select memory windows
					    * configuration registers */
   input	    cs_draw_a_regs_n,      /* chip select drawing engine A 
					    * registers (active low signal) */
   input	    vb_int_tog,            // vertical blank interrupt
   input	    hb_int_tog,            // horizonatl blank
   input	    dda_int_tog,           // DE A operation is not done
   input	    cla_int_tog,           // DE A clip int has not occured
   input	    deb_a,                 // drawing engine A is not busy
   input	    mcb,                   // memory controller is not busy
   input	    clp_a,                 /* No clipping done to the previous
					    * command (engine A) */
   input	    busy_a,                // Chip is ready to accept a command
   input	    window0_busy_n,        /* asserted whenever the host bus 
					    * cache is still in progress of 
					    * writing to memory window 0. */
   input	    window1_busy_n,        /* asserted whenever the host bus 
					    * cache is still in progress of 
					    * writting to memory window 1. */
   input	    cs_pci_config_regs_n,  /* chip select PCI configuration 
						 * registers (active low signal) */
   input	    cs_soft_switchs_n,     //chip select soft switchs
   input	    de_ca_busy,            //DE cache busy
   input	    ddc1_dat_0,
   input	    ddc_clk_in_0,            // input from pin to register
   input	    ddc1_dat_1,
   input	    ddc_clk_in_1,            // input from pin to register
   input	    de_pipeln_activ,       // from de to register to be read
   input	    cs_pci_wom,
   input	    cs_serial_eprom,
   input [7:0]	    soft_switch_in,
   input            vga_en,
   input            hb_soft_reset_n,
   input            clr_sepm_busy,         // Clear the busy bit when done
   input            m66_en,                // Enabel 66MHz PCI.
   
   output reg [31:8]  rbase_g_dout,        // RBASE_G register data output
   output reg [31:8]  rbase_w_dout,        // RBASE_W register data output
   output reg [31:9]  rbase_a_dout,        // RBASE_A register data output
   output reg [31:16] rbase_e_dout,        // RBASE_E register data output
   output reg [31:8]  rbase_i_dout,
   output reg	    soft_reset_p,          /* soft reset to reset blackbird
                                            * except the host bus interface */
   output reg	    dac_soft_reset,
   output reg	    enable_rbase_g_p,      // decode enable for RBASE_G
   output reg	    enable_rbase_w_p,      // decode enable for RBASE_W
   output reg	    enable_rbase_a_p,      // decode enable for RBASE_A
   output reg	    enable_rbase_i_p,      // decode enable for RBASE_I
   output reg	    enable_mem_window0_p,  // decode enable for memory window 0
   output reg	    enable_mem_window1_p,  // decode enable for memory window 0
   output reg	    enable_xy_de_a_p,      /* decode enable for XY window for
                                            * drawing engine A */
   output [24:0]    mw0_ctrl_dout,         // MW0_CTRL regster data output
   output reg [31:12] mw0_ad_dout,           /* MW0_AD register
                                          * (memory window 0 address) */
   output reg [3:0] mw0_sz_dout,           // MW0_SZ register memory window 0
   output reg [25:12] mw0_org_dout,          // MW0_ORG  register data output
   output [24:0]    mw1_ctrl_dout,         // MW1_CTRL regster data output
   output reg [31:12] mw1_ad_dout,           /* MW1_AD register
                                          * (memory window 1 address) */
   output reg [3:0]   mw1_sz_dout,           // MW1_SZ register memory window 1
   output reg [25:12] mw1_org_dout,          // MW1_ORG  register data output
   output reg [31:12] xyw_a_dout,          // XY window address drawing engine
   output reg [31:0] hb_regs_dout,          /* all HBI registers bus output
					    * (the output of the mux) */
   output	    interrupt_in,          /* input to the tri_state interrupt
                                            * driver pad */
   output	    interrupt_cnt,         /* input to the control interrupt
                                            * driver pad */
   output reg	    pci_io_enable_p,       /* PCI IP space enable. on power up 
					    * this bit is set
					    * (IO space is enabled) */
   output reg	    pci_mem_enable_p,      /* PCI MEMORY space enable. 
					    * on power up this bit is set 
					    * (MEM space is enabled) */
   output reg	    enable_rbase_e_p,      // decode enable for RBASE_E
   output [1:0]	    dden,                  // disply buffer density
   output reg	    pci_eprom_enable_p,    /* PCI EPROM space enable. 
					    * on power up this bit is enabled
					    * configuration */
   output reg [3:0] cfg_reg2_mc,           // control bits to the MC
   output reg [2:0] cfg_reg2_dws,          // # of wait states to be inserted
   output reg [3:0] cfg_reg2_ews,          // # of wait states to be inserted
   output reg	    cfg_reg2_cn,
   output reg [1:0] cfg_reg2_ref_cnt,      // refresh count configuration
   output reg 	    cfg_reg2_rcd,
   output reg 	    cfg_reg2_jv,
   output reg 	    cfg_reg2_tr,           // RAS pulse length control config
   output	    cfg_reg2_sgr,          // sgram configuration
   output 	    cfg_reg2_ide,          // internal dac enable configuration
   
   output reg	    vga_palette_snoop_n,   /* VGA PALAATE SNOOP.
					    * 1-->WRITES TO VGA IS DISABLED,
					    * 0--> WRITES TO VGA IS ENABLED */
   output reg [23:0]base_addr_reg5,        /* PCI CONFIGURATION SPACE ADDRESS
					    * REGISTER 5 (IO SPACE) */
   output 	    pci_class_config,      // PCI class configuration bits
   output	    ddc1_clk_0,
   output	    ddc1_en_0,
   output	    ddc1_clk_1,
   output	    ddc1_en_1,
   output	    vga_global_enable,
//   output [7:0]	    vga_ctrl_dout,
   output           ldi_2xzoom,
   output           fis_vga_space_en,
   output	    ddc1_dat2_0,
   output	    ddc1_dat2_1,
   output	    vga_3c6block_en_p,
   output reg	    pci_mstr_en,
   output 	    de_pl_busy,
   output [4:0]	    flow_reg,
   output reg [31:2] pci_wr_addr,
   output reg [21:0] pcim_masks,
   output reg [1:0] se_clk_sel,    // selects an se_clk source in agp_pll
   output reg [7:0] soft_switch_out,
   output reg [18:0] sepm_addr,     // Serial Eprom address for erasure
   output reg [3:0] sepm_cmd,      // Command to the serial eprom
   output reg       sepm_busy
   );
  
   parameter	 ON                = 1'b1,
		 OFF               = 1'b0,
		 DEVSEL_MEDIUM     = 2'b01,
		 SINGLE_FUNCTION   = 1'b0,
		 PREFETCHABLE      = 1'b1,
		 MEM_SPACE         = 1'b0,
		 IO_SPACE          = 1'b1,
		 FAST_BB_CAPABLE   = 1'b1,
		 VGA               = 1'h0,
		 REG_RESERVED      = 32'h0, /* for the memory mapped drawing 
					     * reg. of addr 0x001 */
		 DEVICE_ID4         = 16'h5348,// DEVICE ID=SH (in ASCII ->hex)
		 DEVICE_ID3         = 16'h493D,// DEVICE ID=SH (in ASCII ->hex)
		 DEVICE_ID2         = 16'h2339,// DEVICE ID=SH (in ASCII ->hex)
		 DEVICE_ID1         = 16'h2309,// DEVICE ID=SH (in ASCII ->hex)
		 VENDOR_ID          = 16'h105d,/* VENDOR ID= x105D
						* (given to us by INTEL) */
		  BIST               = 8'h00,  /* SILVERHAMMER doesn't support
   						* BUILT_IN_SELF_TEST */
		 CACHE_LINE_SIZE    = 8'h00, /* since SILVERHAMMER ignores 
					      * SDONE & SOB pins */
		 LATENCY_TIMER      = 8'h00, // not a PCI master
		 DISPLAY_CONTROLLER = 8'h03, /* base class set to 
					      * DISPLAY CONTROLLER */
		 PROG_IF            = 8'h00, // programming interface
		 NON_PREFETCHABLE   = 1'b0,
		 MAX_LAT            = 8'h00, /* SILVERHAMMER has no major 
					      * requirements for
 	                                      * setting the latency timer */
		 MIN_GNT            = 8'h00, /* SILVERHAMMER is a slave device.
					      * no need to implement this field
					      */
		 // SIXTY_SIX = 1'b0,  // Device is not 66 MHz capable
		 CAP_LIST  = 1'b1,  // Config Space has a list of capabilities.
		 CAP_PTR   = 8'h80, // Capabilities pointer
		 AGP_RQ    = 8'h0F, // AGP request queue (max depth is 16)
		 SBA       = 1'b1,  // Supports sideband addressing.
		 // SH revb SBA replace with strap subsytem_id_5
		 AGP_RATE  = 2'b11, // Supports 1X and 2X transfer rates.
		 REV_MAJ   = 4'h1,  /* AGP spec major revision that device
				     * complies to */
		 REV_MIN   = 4'h0,  /* AGP spec minor revision that device
				     * complies to */
		 PM_PTR    = 8'h90, /* Pointer To next capabilities list, 
				     * Power Management. */
		 NO_PTR    = 8'h00, /* Pointer to next capabilities list 
				     * (no more caps.) */
		 AGP_ID    = 8'h02, // This is an AGP device.
                 PM_ID     = 8'h01; /* This is an Power Managed device. 
				     * (we pretend to be) */

  reg [15:0] 	 devid;

  always @*
    case (devid_sel)
      2'b00: devid = DEVICE_ID1;
      2'b01: devid = DEVICE_ID2;
      2'b10: devid = DEVICE_ID3;
      2'b11: devid = DEVICE_ID4;
    endcase // case(devid_sel)
  
  reg [23:0]	 config_base_reg;
  wire		 rom_present;
  reg		 sys_reset_config_n ;
  reg		 m_info_4_0_0, m_info_4_1_0;
  reg [1:0]	 m_info_5_0;
  reg		 m_info_4_0_1, m_info_4_1_1;
  reg [1:0]	 m_info_5_1;
  wire [22:0]	 pci_sub_ven_id;
  reg [3:0]	 vga_ctrl_0;
  reg		 blkbird_intrp_n;
  reg [7:0]	 mw0_ctrl_dout_0;
  reg [0:0]	 mw0_ctrl_dout_1;
  reg [7:0]	 mw0_ctrl_dout_2;
  reg [7:0]	 mw0_ctrl_dout_3;
  reg [7:0]	 mw0_plnmask_dout4, mw0_plnmask_dout5,
		 mw0_plnmask_dout6,mw0_plnmask_dout7;
  reg [7:0]	 mw1_ctrl_dout_0;
  reg [0:0]	 mw1_ctrl_dout_1;
  reg [7:0]	 mw1_ctrl_dout_2;
  reg [7:0]	 mw1_ctrl_dout_3;
  reg [7:0]	 mw1_plnmask_dout4, mw1_plnmask_dout5,
        	 mw1_plnmask_dout6, mw1_plnmask_dout7;
  reg		 sync_dda, sync_dda0, sync_dda1, dda_intrp;
  reg		 sync_cla, sync_cla0, sync_cla1, cla_intrp;
  reg		 sync_vb, sync_vb0, sync_vb1, vb_intrp;
  reg		 sync_hb, sync_hb0, sync_hb1, hb_intrp;
  reg		 mcb_out,sync_mcb;
  reg		 mcb_out1,sync_mcb1;
  reg		 clp_a_out,sync_clp_a;
  reg		 de_ca_busy_dout, ca_busy_temp;
  reg		 de_pipeln_activ_out,sync_de_pipeln_activ;
  reg [7:0] 	 interrupt_line;
  reg		 ddc1_dat_sync_0;
  reg		 ddc1_dat_temp_0;
  reg		 ddc1_dat_sync_1;
  reg		 ddc1_dat_temp_1;
  reg [1:0]	 pm_ps;        // power managment power states
  reg 		 vga_en_del, reset_vga;
  reg [31:0] 	 sgram_reg;      // backwards compatibility
  reg [9:0] 	 base_valid_dec0, base_valid_dec1;

  wire [3:0]	 gintp_dout;     //global interrupt register
  reg  [2:0]	 gintm_dout;     //global  interrupt mask register
  wire [1:0]	 intp_a_dout;    //interrupt register for drawing engine A
  reg [1:0] 	 intm_a_dout;    //interrupt mask register for drawing engine A
  wire [4:0]	 flow_a_dout;    //flow status register for drawing engine A
  wire [31:0]	 sub_class;
  reg [9:0] 	 base_addr_reg0;
  reg [9:0] 	 base_addr_reg1;
  reg  [31:12]	 base_addr_reg2;
  reg [15:0] 	 base_addr_reg4;
  wire [1:0]	 pci_base0_1size;
  reg [1:0] 	 mw0_sz_dout_flush, mw1_sz_dout_flush;
  wire [7:0]	 vga_ctrl_dout;
  reg [31:0] 	 bios_1_dout, bios_2_dout, bios_3_dout, bios_4_dout;
  wire [7:0]	 m_info_dout;

  wire		 all_intps_n;
  wire [15:0]	 sub_vendor_id, subsytem_id;
  wire [7:0]	 intrp_pin, intrp_reg;
  wire [2:0]	 sh_rev;  // Planning for failure?
  // wire		 ide_strap;

  `ifdef RTL_SIM
  initial begin
    soft_reset_p = 0;
    dac_soft_reset = 0;
  end
  `endif

  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) begin
      rbase_g_dout         <= 24'h00;
      rbase_e_dout         <= 16'h00;
      rbase_w_dout         <= 24'h20;
      rbase_a_dout         <= 23'h20;
      rbase_i_dout         <= 24'h80;
      soft_reset_p         <= 1'b0;   //(soft reset= 0 as default)
      dac_soft_reset       <= 1'b0;
      se_clk_sel           <= 1'b0;
      enable_rbase_g_p     <= 1'b0; //all registers decode is disabled 
      enable_rbase_w_p     <= 1'b0; 
      enable_rbase_a_p     <= 1'b0;
      enable_rbase_i_p     <= 1'b0; 
      enable_mem_window0_p <= 1'b0; // LINEAR memory windows are disabled
      enable_mem_window1_p <= 1'b0;
      enable_xy_de_a_p     <= 1'b0; // XY memory windows are disabled    
      enable_rbase_e_p     <= config_bus[29];// set eprom enable based on jmper
      cfg_reg2_mc          <= 4'h0; //set to 0
      cfg_reg2_dws         <= 3'h3; //set the # of wait states for DAC to 3
      cfg_reg2_ews         <= 4'hf; //set the # of wait states for EPROM to 16
      cfg_reg2_cn          <= 1'b1;
      cfg_reg2_ref_cnt     <= 2'h2;
      cfg_reg2_rcd         <= 1'b1;
      cfg_reg2_jv          <= 1'b1;
      cfg_reg2_tr          <= 1'b0;   
      m_info_4_0_0         <= 1'h0;
      m_info_4_1_0         <= 1'h0;
      m_info_5_0           <= 2'h0;
      m_info_4_0_1         <= 1'h0;
      m_info_4_1_1         <= 1'h0;
      m_info_5_1           <= 2'h0;
      vga_ctrl_0           <= 4'b0;
      mw0_ad_dout          <= 20'b0;
      mw0_ctrl_dout_0      <= 8'h0; //reset the register to 0's
      mw0_ctrl_dout_2      <= 8'h0; //reset the register to 0's
      mw0_ctrl_dout_3      <= 8'h0; //reset the register to 0's
      mw0_sz_dout          <= 4'h0;
      mw0_sz_dout_flush    <= 2'h0;
      mw0_org_dout         <= 14'b0;
      mw1_ad_dout          <= 20'b0;
      mw1_ctrl_dout_0      <= 8'h0; //reset the register to 0's
      mw1_ctrl_dout_2      <= 8'h0; //reset the register to 0's
      mw1_ctrl_dout_3      <= 8'h0; //reset the register to 0's
      mw1_sz_dout          <= 4'h0;
      mw1_sz_dout_flush    <= 2'h0;
      mw1_org_dout         <= 14'b0;
      xyw_a_dout           <= 20'h0;
      gintm_dout           <= 3'b0;
      pci_io_enable_p      <= 1'b0; // IO space is  disabled at power up
      pci_mem_enable_p     <= 1'b0; // MEM space is disabled at power up
      pci_mstr_en          <= 1'b0; // PCI bus mastering disabled at power up
      vga_palette_snoop_n  <= 1'b0; /* VGA PALETTE SNOOP IS OFF */
      pci_eprom_enable_p   <= 1'b0; //disable EPROM on power up
      interrupt_line[7:0]  <= 8'h0;
      pm_ps                <= 2'b0;
      sgram_reg            <= 32'b0;
      intm_a_dout          <= 2'b0;
    end else if (wr_en) begin
      if (!cs_blk_config_regs_n) begin
	case (hbi_addr_in[7:2])
	  // RBASE_G register (addr= {CJ,x0000})
	  6'h00: begin
	    if (!hbi_byte_en_in[1]) rbase_g_dout[15:8]  <= hbi_data_in[15:8]; 
	    if (!hbi_byte_en_in[2]) rbase_g_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_g_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_W register (addr= {CJ,x0004})
	  6'h01: begin
	    if (!hbi_byte_en_in[1]) rbase_w_dout[15:8]  <= hbi_data_in[15:8]; 
	    if (!hbi_byte_en_in[2]) rbase_w_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_w_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_A register (addr= {CJ,x0008})
	  6'h02: begin
	    if (!hbi_byte_en_in[1]) rbase_a_dout[15:9]  <= hbi_data_in[15:9];
	    if (!hbi_byte_en_in[2]) rbase_a_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_a_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_I register (addr= {CJ,x0010})
	  6'h04: begin
	    if (!hbi_byte_en_in[1]) rbase_i_dout[15:8]  <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) rbase_i_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_i_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_E register (addr= {CJ,x0014})
	  // THIS REGISTER RESETS TO 0X000C-0000
	  6'h05: begin
	    if (!hbi_byte_en_in[2]) rbase_e_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_e_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // CONFIG I register (addr= {CJ+x001C})
   	  6'h07: begin
	    if (!hbi_byte_en_in[0]) dac_soft_reset      <= hbi_data_in[0];
	    if (!hbi_byte_en_in[0]) soft_reset_p        <= hbi_data_in[1];
	    if (!hbi_byte_en_in[0]) se_clk_sel          <= hbi_data_in[5:4];
	    if (!hbi_byte_en_in[1]) enable_rbase_g_p    <= hbi_data_in[8];
	    if (!hbi_byte_en_in[1]) enable_rbase_w_p    <= hbi_data_in[9];
	    if (!hbi_byte_en_in[1]) enable_rbase_a_p    <= hbi_data_in[10];
	    if (!hbi_byte_en_in[1]) enable_rbase_i_p    <= hbi_data_in[12];
	    if (!hbi_byte_en_in[1]) enable_rbase_e_p    <= hbi_data_in[13];
	    if (!hbi_byte_en_in[2]) enable_mem_window0_p<= hbi_data_in[16];
	    if (!hbi_byte_en_in[2]) enable_mem_window1_p<= hbi_data_in[17];
	    if (!hbi_byte_en_in[2]) enable_xy_de_a_p    <= hbi_data_in[20];
	  end // case: 6'h07
	  // CONFIG II register (addr= {CJ+x0020})
	  6'h08: begin
	    if (!hbi_byte_en_in[0]) cfg_reg2_cn         <= hbi_data_in[7]; 
	    if (!hbi_byte_en_in[0]) cfg_reg2_ref_cnt    <= hbi_data_in[6:5];
	    if (!hbi_byte_en_in[0]) cfg_reg2_rcd        <= hbi_data_in[4];
	    if (!hbi_byte_en_in[0]) cfg_reg2_jv         <= hbi_data_in[3];
	    if (!hbi_byte_en_in[0]) cfg_reg2_tr         <= hbi_data_in[2];     
	    if (!hbi_byte_en_in[1]) cfg_reg2_ews        <= hbi_data_in[11:8];
	    if (!hbi_byte_en_in[2]) cfg_reg2_dws        <= hbi_data_in[18:16];
	    if (!hbi_byte_en_in[2]) cfg_reg2_mc         <= hbi_data_in[23:20];
	  end
	  // SGRAM Register
	  6'h09: begin
	    if (!hbi_byte_en_in[0]) sgram_reg[7:0]      <= hbi_data_in[7:0]; 
	    if (!hbi_byte_en_in[1]) sgram_reg[15:8]     <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) sgram_reg[23:16]    <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) sgram_reg[31:24]    <= hbi_data_in[31:24];
	  end
	  // M_INFO REGISTER (addr= {CJ+x002c})
	  // THIS IS A REGISTER THAT IS REQUIRED TO SUPPORT DDC1 STANDARD.
	  6'h0b: begin
      	    if (!hbi_byte_en_in[0]) m_info_4_0_0        <= hbi_data_in[0];
      	    if (!hbi_byte_en_in[0]) m_info_4_1_0        <= hbi_data_in[2];
     	    if (!hbi_byte_en_in[1]) m_info_5_0          <= hbi_data_in[9:8];
      	    if (!hbi_byte_en_in[2]) m_info_4_0_1        <= hbi_data_in[16];
      	    if (!hbi_byte_en_in[2]) m_info_4_1_1        <= hbi_data_in[18];
     	    if (!hbi_byte_en_in[3]) m_info_5_1          <= hbi_data_in[25:24];
	  end
	  // VGA_IO_CTRL REGISTER (addr= {CJ+x0030})
	  // This reg. controls the VGA global enable/disable mechanisim
	  6'h0c: begin
	    if (!hbi_byte_en_in[0]) vga_ctrl_0          <= {hbi_data_in[7], 
							    hbi_data_in[5], 
							    hbi_data_in[3],
							    hbi_data_in[1]};
	  end
	  // MW1_CTRL register (addr= {RBASE_W,x0028}) 
	  6'h10: begin
	    if (!hbi_byte_en_in[0]) mw1_ctrl_dout_0     <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[2]) mw1_ctrl_dout_2     <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw1_ctrl_dout_3     <= hbi_data_in[31:24];
	  end
	  // MW1_AD register (addr= {RBASE_W,x002C})
	  6'h11: begin
	    if (!hbi_byte_en_in[1]) mw1_ad_dout[15:12]  <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[2]) mw1_ad_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw1_ad_dout[31:24]  <= hbi_data_in[31:24];
	  end
	  // MW1_SZ register (addr= {RBASE_W,x0030})
	  6'h12: begin
	    if (!hbi_byte_en_in[0]) mw1_sz_dout         <= hbi_data_in[3:0];
	    if (!hbi_byte_en_in[3]) mw1_sz_dout_flush[0]<= hbi_data_in[24];
	    if (!hbi_byte_en_in[3]) mw1_sz_dout_flush[1]<= hbi_data_in[26];
	  end //
	  // MW1_ORG register (addr= {RBASE_W,x0010 OR RBASE_W,x003C})
	  6'h14: begin
	    if (!hbi_byte_en_in[1]) mw1_org_dout[15:12] <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[2]) mw1_org_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw1_org_dout[25:24] <= hbi_data_in[25:24];
	  end
	  // GP Bios Registers
	  6'h1a: begin
	    if (!hbi_byte_en_in[0]) bios_1_dout[7:0]    <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[1]) bios_1_dout[15:8]   <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) bios_1_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) bios_1_dout[31:24]  <= hbi_data_in[31:24];
	  end
	  6'h1b: begin
	    if (!hbi_byte_en_in[0]) bios_2_dout[7:0]    <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[1]) bios_2_dout[15:8]   <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) bios_2_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) bios_2_dout[31:24]  <= hbi_data_in[31:24];
	  end
	  6'h1c: begin
	    if (!hbi_byte_en_in[0]) bios_3_dout[7:0]    <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[1]) bios_3_dout[15:8]   <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) bios_3_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) bios_3_dout[31:24]  <= hbi_data_in[31:24];
	  end
	  6'h1d: begin
	    if (!hbi_byte_en_in[0]) bios_4_dout[7:0]    <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[1]) bios_4_dout[15:8]   <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) bios_4_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) bios_4_dout[31:24]  <= hbi_data_in[31:24];
	  end
	endcase // case(hbi_addr_in[7:2])
      end
      if (!cs_global_intrp_reg_n) begin
	case (hbi_addr_in[7:2])
	  6'h01: begin
	    if (!hbi_byte_en_in[0]) gintm_dout[1:0]     <= hbi_data_in[1:0]; 
	    if (!hbi_byte_en_in[2]) gintm_dout[2]       <= hbi_data_in[16]; 
	  end
	  // RBASE_G register (addr= {CJ,x0000})
	  6'h20: begin
	    if (!hbi_byte_en_in[1]) rbase_g_dout[15:8]  <= hbi_data_in[15:8]; 
	    if (!hbi_byte_en_in[2]) rbase_g_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_g_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_W register (addr= {CJ,x0004})
	  6'h21: begin
	    if (!hbi_byte_en_in[1]) rbase_w_dout[15:8]  <= hbi_data_in[15:8]; 
	    if (!hbi_byte_en_in[2]) rbase_w_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_w_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_A register (addr= {CJ,x0008})
	  6'h22: begin
	    if (!hbi_byte_en_in[1]) rbase_a_dout[15:9]  <= hbi_data_in[15:9];
	    if (!hbi_byte_en_in[2]) rbase_a_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_a_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_I register (addr= {CJ,x0010})
	  6'h24: begin
	    if (!hbi_byte_en_in[1]) rbase_i_dout[15:8]  <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) rbase_i_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_i_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // RBASE_E register (addr= {CJ,x0014})
	  // THIS REGISTER RESETS TO 0X000C-0000
	  6'h25: begin
	    if (!hbi_byte_en_in[2]) rbase_e_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_e_dout[31:24] <= hbi_data_in[31:24];
	  end
	  // CONFIG I register (addr= {CJ+x001C})
   	  6'h27: begin
	    if (!hbi_byte_en_in[0]) se_clk_sel          <= hbi_data_in[5:4];
	    if (!hbi_byte_en_in[0]) soft_reset_p        <= hbi_data_in[1];
	    if (!hbi_byte_en_in[0]) dac_soft_reset      <= hbi_data_in[0];
	    if (!hbi_byte_en_in[1]) enable_rbase_e_p    <= hbi_data_in[13];
	    if (!hbi_byte_en_in[1]) enable_rbase_i_p    <= hbi_data_in[12];
	    if (!hbi_byte_en_in[1]) enable_rbase_a_p    <= hbi_data_in[10];
	    if (!hbi_byte_en_in[1]) enable_rbase_w_p    <= hbi_data_in[9];
	    if (!hbi_byte_en_in[1]) enable_rbase_g_p    <= hbi_data_in[8];
	    if (!hbi_byte_en_in[2]) enable_mem_window1_p <= hbi_data_in[17];
	    if (!hbi_byte_en_in[2]) enable_mem_window0_p <= hbi_data_in[16];
	    if (!hbi_byte_en_in[2]) enable_xy_de_a_p    <= hbi_data_in[20];
	  end // case: 6'h07
	  // CONFIG II register (addr= {CJ+x0020})
	  6'h28: begin
	    if (!hbi_byte_en_in[0]) cfg_reg2_cn         <= hbi_data_in[7]; 
	    if (!hbi_byte_en_in[0]) cfg_reg2_ref_cnt    <= hbi_data_in[6:5];
	    if (!hbi_byte_en_in[0]) cfg_reg2_rcd        <= hbi_data_in[4];
	    if (!hbi_byte_en_in[0]) cfg_reg2_jv         <= hbi_data_in[3];
	    if (!hbi_byte_en_in[0]) cfg_reg2_tr         <= hbi_data_in[2];     
	    if (!hbi_byte_en_in[1]) cfg_reg2_ews        <= hbi_data_in[11:8];
	    if (!hbi_byte_en_in[2]) cfg_reg2_dws        <= hbi_data_in[18:16];
	    if (!hbi_byte_en_in[2]) cfg_reg2_mc         <= hbi_data_in[23:20];
	  end
	  // SGRAM Register
	  6'h29: begin
	    if (!hbi_byte_en_in[0]) sgram_reg[7:0]      <= hbi_data_in[7:0]; 
	    if (!hbi_byte_en_in[1]) sgram_reg[15:8]     <= hbi_data_in[15:8];
	    if (!hbi_byte_en_in[2]) sgram_reg[23:16]    <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) sgram_reg[31:24]    <= hbi_data_in[31:24];
	  end
	  // M_INFO REGISTER (addr= {CJ+x002c})
	  // THIS IS A REGISTER THAT IS REQUIRED TO SUPPORT DDC1 STANDARD.
	  6'h2b: begin
      	    if (!hbi_byte_en_in[0]) m_info_4_0_0        <= hbi_data_in[0];
      	    if (!hbi_byte_en_in[0]) m_info_4_1_0        <= hbi_data_in[2];
     	    if (!hbi_byte_en_in[1]) m_info_5_0          <= hbi_data_in[9:8];
      	    if (!hbi_byte_en_in[2]) m_info_4_0_1        <= hbi_data_in[16];
      	    if (!hbi_byte_en_in[2]) m_info_4_1_1        <= hbi_data_in[18];
     	    if (!hbi_byte_en_in[3]) m_info_5_1          <= hbi_data_in[25:24];
	  end
	  // VGA_IO_CTRL REGISTER (addr= {CJ+x0030})
	  // This reg. controls the VGA global enable/disable mechanisim
	  6'h2c: begin
	    if (!hbi_byte_en_in[0]) vga_ctrl_0          <= {hbi_data_in[7], 
							    hbi_data_in[5], 
							    hbi_data_in[3],
							    hbi_data_in[1]};
	  end
	endcase
      end
      if (!cs_pci_config_regs_n) begin
	case (hbi_addr_in[7:2])
	  6'h01: begin
	    if (!hbi_byte_en_in[0]) pci_io_enable_p     <= hbi_data_in[0];  
	    if (!hbi_byte_en_in[0]) pci_mem_enable_p    <= hbi_data_in[1];
	    if (!hbi_byte_en_in[0]) pci_mstr_en         <= hbi_data_in[2];
	    if (!hbi_byte_en_in[0]) vga_palette_snoop_n <= hbi_data_in[5];
	  end
	  // MW0_AD register (addr= {RBASE_W,x0004})
	  6'h04: begin
	    if (!hbi_byte_en_in[3]) mw0_ad_dout[31:24]  <= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) mw0_ad_dout[23:22]  <= hbi_data_in[23:22];
	    if (!hbi_byte_en_in[3]) base_valid_dec0[9:2]<= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) base_valid_dec0[1:0]<= hbi_data_in[23:22];
	  end
	  // MW1_AD register (addr= {RBASE_W,x002C})
	  6'h05: begin
	    if (!hbi_byte_en_in[3]) mw1_ad_dout[31:24]  <= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) mw1_ad_dout[23:22]  <= hbi_data_in[23:22];
	    if (!hbi_byte_en_in[3]) base_valid_dec1[9:2]<= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) base_valid_dec1[1:0]<= hbi_data_in[23:22];
	  end
	  // XYW_AD register ((addr= {RBASE_A,x0010})
	  6'h06: begin
	    if (!hbi_byte_en_in[3]) xyw_a_dout[31:24]   <= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) xyw_a_dout[23:16]   <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[1]) xyw_a_dout[15:12]   <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[3]) base_addr_reg2[31:24]<= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) base_addr_reg2[23:16]<= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[1]) base_addr_reg2[15:12]<= hbi_data_in[15:12];
	  end
	  // RBASE_G register (addr= {CJ,x0000})
	  // RBASE_W register (addr= {CJ,x0004})
	  6'h08: begin
	    if (!hbi_byte_en_in[2]) base_addr_reg4[7:0] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) base_addr_reg4[15:8]<= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) rbase_g_dout[23:16] <= hbi_data_in[23:16]; 
	    if (!hbi_byte_en_in[3]) rbase_g_dout[31:24] <= hbi_data_in[31:24]; 
	    if (!hbi_byte_en_in[2]) rbase_w_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_w_dout[31:24] <= hbi_data_in[31:24]; 
	    if (!hbi_byte_en_in[2]) rbase_a_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_a_dout[31:24] <= hbi_data_in[31:24]; 
	    if (!hbi_byte_en_in[2]) rbase_i_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_i_dout[31:24] <= hbi_data_in[31:24]; 
	  end
	    // BASE ADDR REGISTER 5 used for IO mapped regs  (addr=x24)
	  6'h09: begin
	    if (!hbi_byte_en_in[3]) base_addr_reg5[23:16]<= hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) base_addr_reg5[15:8]<= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[1]) base_addr_reg5[7:0] <= hbi_data_in[15:8];
	  end
	  // EXPANSION ROM BASE ADDRESS REGISTER (addr=x30)
	  // RBASE_E register (addr= {CJ,x0014})
	  // THIS REGISTER RESETS TO 0X000C-0000
	  6'h0c: begin
	    if (!hbi_byte_en_in[0]) pci_eprom_enable_p  <= hbi_data_in[0];
	    if (!hbi_byte_en_in[2]) rbase_e_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) rbase_e_dout[31:24] <= hbi_data_in[31:24];
	  end
	  6'h0f: begin
	    if (!hbi_byte_en_in[0]) interrupt_line      <= hbi_data_in[7:0];
	  end
	  // Power Management State (READ/WRITE) (addr = x94)
	  // 00 = D0 = running (default)
	  // 01 = D1 We do not support.  We must ignore!
	  // 10 = D2 We do not support.  We must ignore!
	  // 11 = D3 We support but don't take any action.
	  6'h25: begin
	    if (!hbi_byte_en_in[0] && (~^hbi_data_in[1:0]))
	      pm_ps <= hbi_data_in[1:0];
	  end
	endcase // case(hbi_addr_in[7:2])
      end // if (!cs_cpi_config_regs_n)

      if (!cs_window_regs_n) begin
	case (hbi_addr_in[7:2])
	  // MW0_CTRL register (addr= {RBASE_W,x0000}) 
	  6'h00: begin
	    if (!hbi_byte_en_in[0]) mw0_ctrl_dout_0     <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[2]) mw0_ctrl_dout_2     <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw0_ctrl_dout_3     <= hbi_data_in[31:24];
	  end
	  // MW0_AD register (addr= {RBASE_W,x0004})
	  6'h01: begin
	    if (!hbi_byte_en_in[1]) mw0_ad_dout[15:12]  <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[2]) mw0_ad_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw0_ad_dout[31:24]  <= hbi_data_in[31:24];
	  end
	  // MW0_SZ register (addr= {RBASE_W,x0008})
	  6'h02: begin
	    if (!hbi_byte_en_in[0]) mw0_sz_dout         <= hbi_data_in[3:0];
	    if (!hbi_byte_en_in[3]) mw0_sz_dout_flush[0]<= hbi_data_in[24];
	    if (!hbi_byte_en_in[3]) mw0_sz_dout_flush[1]<= hbi_data_in[26];
	  end //
	  // MW0_ORG register (addr= {RBASE_W,x0010 OR RBASE_W,x0014})
	  6'h04: begin
	    if (!hbi_byte_en_in[1]) mw0_org_dout[15:12] <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[2]) mw0_org_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw0_org_dout[25:24] <= hbi_data_in[25:24];
	  end
	  // MW1_CTRL register (addr= {RBASE_W,x0028}) 
	  6'h0a: begin
	    if (!hbi_byte_en_in[0]) mw1_ctrl_dout_0     <= hbi_data_in[7:0];
	    if (!hbi_byte_en_in[2]) mw1_ctrl_dout_2     <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw1_ctrl_dout_3     <= hbi_data_in[31:24];
	  end
	  // MW1_AD register (addr= {RBASE_W,x002C})
	  6'h0b: begin
	    if (!hbi_byte_en_in[1]) mw1_ad_dout[15:12]  <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[2]) mw1_ad_dout[23:16]  <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw1_ad_dout[31:24]  <= hbi_data_in[31:24];
	  end
	  // MW1_SZ register (addr= {RBASE_W,x0030})
	  6'h0c: begin
	    if (!hbi_byte_en_in[0]) mw1_sz_dout         <= hbi_data_in[3:0];
	    if (!hbi_byte_en_in[3]) mw1_sz_dout_flush[0]<= hbi_data_in[24];
	    if (!hbi_byte_en_in[3]) mw1_sz_dout_flush[1]<= hbi_data_in[26];
	  end //
	  // MW1_ORG register (addr= {RBASE_W,x0010 OR RBASE_W,x003C})
	  6'h0e: begin
	    if (!hbi_byte_en_in[1]) mw1_org_dout[15:12] <= hbi_data_in[15:12];
	    if (!hbi_byte_en_in[2]) mw1_org_dout[23:16] <= hbi_data_in[23:16];
	    if (!hbi_byte_en_in[3]) mw1_org_dout[25:24] <= hbi_data_in[25:24];
	  end
	endcase // case(hbi_addr_in[7:2])

      end
      if (!cs_draw_a_regs_n) begin
	case (hbi_addr_in[8:2])
	  // INTM_A register (addr= {RBASE_A,x0004})
	  7'h01:
	    if (!hbi_byte_en_in[0]) intm_a_dout         <= hbi_data_in[1:0];
	  // XYW_AD register ((addr= {RBASE_A,x0010})
	  7'h04: begin
	    if (!hbi_byte_en_in[3]) xyw_a_dout[31:24]   <=  hbi_data_in[31:24];
	    if (!hbi_byte_en_in[2]) xyw_a_dout[23:16]   <=  hbi_data_in[23:16];
	    if (!hbi_byte_en_in[1]) xyw_a_dout[15:12]   <=  hbi_data_in[15:12];
	  end
	endcase // case(hbi_addr_in[8:2])
      end
    end // if (wr_en)
  
  assign mw0_ctrl_dout = {mw0_ctrl_dout_3, mw0_ctrl_dout_2, 
			  window0_busy_n, mw0_ctrl_dout_0};
  assign mw1_ctrl_dout = {mw1_ctrl_dout_3, mw1_ctrl_dout_2, 
			  window1_busy_n, mw1_ctrl_dout_0};
  
  /***************************************************************************
   ID register (addr= {CJ+x0018})
   This register is loaded at reset time
   ***************************************************************************/
  // No longer a reset as these are defined in the HDL of the top level

  assign pci_base0_1size      = config_bus[31:30];
  assign rom_present          = config_bus[29];
  assign pci_class_config     = config_bus[28];
  assign dden                 = config_bus[27:26];
  // assign ide_strap            = config_bus[25];
  assign cfg_reg2_sgr         = config_bus[24];        
  assign pci_sub_ven_id       = config_bus[22:0];
  assign cfg_reg2_ide         = config_bus[25];
  
  /**************************************************************************
   * assign the subystem vendor ID
   **************************************************************************/
  assign sub_vendor_id [15:0]=
         (pci_sub_ven_id[16]==1'b0) ? VENDOR_ID : //# 9 vendor ID
         pci_sub_ven_id[15:0];
					  
  assign subsytem_id [15:0] = {10'b0, pci_sub_ven_id[22:17]};

  /****************************************************************************
   SOFT SWITCHES REGISTER (addr= {CJ+x0028})
   THIS REGISTER IS SHADOWED OUTSIDE BLACKBIRD. WRITING TO THE OUTSIDE 
   SOFT SWITCHES WOULD WRITE TO THIS REGISTER, READING SOFT SWITCHES WOULD
   RETERN THE VALUE OF THIS REGISTER, WHICH IN ESSENCE IS THE VALUE STORED
   IN THE OUTSIDE SOFT SWITCHES(SINCE THEY ARE SHADOWED)
   ***************************************************************************/
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) soft_switch_out <= 8'h0;
    else if (wr_en && !cs_soft_switchs_n) begin
      if(!hbi_byte_en_in[0]) soft_switch_out <= hbi_data_in[7:0];
    end

  assign m_info_dout[3:0] = {m_info_5_0, m_info_4_1_0, m_info_4_0_0};
  assign m_info_dout[7:4] = {m_info_5_1, m_info_4_1_1, m_info_4_0_1};
  
  //DDC2 SUPPORT, 
  assign ddc1_clk_0 = (m_info_5_0[1:0] ==2'b10) ? !m_info_4_0_0  : //invert clk
         (m_info_5_0[1:0] ==2'b01) ?  m_info_4_0_0  :  //non_invert clk
         1'b0;
  assign ddc1_en_0  = (m_info_5_0[1:0] ==2'b01) ? 1'b1 :  //DDC1
         1'b0;
  assign ddc1_dat2_0 = (m_info_5_0[1:0] ==2'b10) ? !m_info_4_1_0 :
         1'b0; 
  
  assign ddc1_clk_1 = (m_info_5_1[1:0] ==2'b10) ? !m_info_4_0_1  : //invert clk
         (m_info_5_1[1:0] ==2'b01) ?  m_info_4_0_1  :  //non_invert clk
         1'b0;
  assign ddc1_en_1  = (m_info_5_1[1:0] ==2'b01) ? 1'b1 :  //DDC1
         1'b0;
  assign ddc1_dat2_1 = (m_info_5_1[1:0] ==2'b10) ? !m_info_4_1_1 :
         1'b0;
 
  // Temporary overide of disabling VGA
  assign vga_global_enable = vga_ctrl_0[0];// | vga_en;
  assign vga_3c6block_en_p = vga_ctrl_0[3];// | vga_en;
  assign ldi_2xzoom        = vga_ctrl_0[2];
  assign fis_vga_space_en  = vga_ctrl_0[1];// | vga_en;
  assign vga_ctrl_dout = {vga_3c6block_en_p, 1'b0, ldi_2xzoom, 1'b0,
			  fis_vga_space_en, 1'b0, vga_global_enable, 1'b0};

  /****************************************************************************
   *                             INTERRUPTS
   ***************************************************************************/
   
  /****************************************************************************
   This section was originally the module to implement the global interrupt 
   register and global interrupt mask register.
   ***************************************************************************/

  /***************************************************************************
   GINTP register (addr={RBASE_I,x0000})
   all interrupts are cleared on system reset
   ***************************************************************************/
  // Sync the Vertical and Horizontal Interrupts.
  always @(posedge hb_clk, negedge sys_reset_n) begin
    if(!sys_reset_n) begin
        sync_vb  <= 1'b0;
        sync_vb1 <= 1'b0;
        sync_vb0 <= 1'b0;
        sync_hb  <= 1'b0;
        sync_hb1 <= 1'b0;
        sync_hb0 <= 1'b0;
    end
    else begin
        sync_vb  <= sync_vb0 ^ sync_vb1;
        sync_vb1 <= sync_vb0;
        sync_vb0 <= vb_int_tog;
        sync_hb  <= sync_hb0 ^ sync_hb1;
        sync_hb1 <= sync_hb0;
        sync_hb0 <= hb_int_tog;
    end
  end

  //VB_INT
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) vb_intrp <= 1'b0;
    else if (!cs_global_intrp_reg_n && hbi_addr_in[7:2]==6'h00 &&
             !hbi_byte_en_in[0] && !hbi_data_in[0] && wr_en)
      vb_intrp <= 1'b0;
    else if(sync_vb) vb_intrp <= 1'b1;

  //HB_INT
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) hb_intrp <= 1'b0;
    else if (!cs_global_intrp_reg_n && hbi_addr_in[7:2]==6'h00 &&
             !hbi_byte_en_in[0] && !hbi_data_in[1] && wr_en)
      hb_intrp <= 1'b0;
    else
      if(sync_hb) hb_intrp <= 1'b1;

  assign gintp_dout[3:0] = {intp_a_dout[1:0],hb_intrp,vb_intrp};

  /****************************************************************************
   This section was the original INTERRUPTS module.  It is used to generate the
   host bus interrupt, & also to mask interrupts.
   ***************************************************************************/

  /***************************************************************************
   GENERATE INTERRUPT LOGIC FOR THE INTERRUPT PIN
   ***************************************************************************/
  //note: gintm_dout[2] is the global interrupt mask bit
  assign all_intps_n = !(gintm_dout[2] && 
			 ((gintp_dout[3] && intm_a_dout[1]) ||
			  (gintp_dout[2] && intm_a_dout[0]) ||
			  (gintp_dout[1] && gintm_dout[1])  ||
			  (gintp_dout[0] && gintm_dout[0])));
  
  //one stage synchronization to the hb_clk for the interrupt pin
  always @(posedge hb_clk) blkbird_intrp_n <= all_intps_n;

  //implement the input to the interrupt tri_state driver
  assign interrupt_in = 1'b0;

  //implement the tri_state driver control of the interrupt pin
  assign interrupt_cnt = blkbird_intrp_n;

  /****************************************************************************
   *                             DRAWING_REGS
   * Block to implement the intp, intm, flow, busy, xyw_adsz registers
   ***************************************************************************/

  /****************************************************************************
   INTP_A register (addr= {RBASE_A,x0000})
   all interrupts are cleared on system reset
   ***************************************************************************/
  // DD_INT_A
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) 
      dda_intrp <= 1'b0;
    else if (!cs_draw_a_regs_n && hbi_addr_in[8:3]==6'h00 &&
 	     !hbi_byte_en_in[0] && wr_en && hbi_data_in[1]==0)
      dda_intrp <= 1'b0;
    else
      dda_intrp <= sync_dda;

  always @(posedge hb_clk) begin
    sync_dda0 <= dda_int_tog;
    sync_dda1 <= sync_dda0;
    sync_dda  <= sync_dda0 ^ sync_dda1;
    sync_cla0 <= cla_int_tog;
    sync_cla1 <= sync_cla0;
    sync_cla  <= sync_cla0 ^ sync_cla1;
  end
  
  // CL_INT_A
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) 
      cla_intrp <= 1'b0;
    else if (!cs_draw_a_regs_n && hbi_addr_in[8:3]==6'h00 &&
 	     !hbi_byte_en_in[0] && wr_en && hbi_data_in[1]==0)
      cla_intrp <= 1'b0;
    else
      cla_intrp <= sync_cla;

  assign intp_a_dout = {cla_intrp, dda_intrp};
            
  /****************************************************************************
   FLOW_A register (addr= {RBASE_A,x0008}).READ ONLY REG
   ***************************************************************************/
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) begin
      mcb_out              <= 1'b0;
      sync_mcb             <= 1'b0;
      clp_a_out            <= 1'b0;
      sync_clp_a           <= 1'b0;
      de_ca_busy_dout      <= 1'b0;
      ca_busy_temp         <= 1'b0;
      de_pipeln_activ_out  <= 1'b0;
      sync_de_pipeln_activ <= 1'b0;
    end else begin
      // MCB
      mcb_out              <= sync_mcb;
      sync_mcb             <= mcb;

      // CLP_A
      clp_a_out            <= sync_clp_a;
      sync_clp_a           <= clp_a;

      //DE_CACHE_BUSY
      de_ca_busy_dout      <= ca_busy_temp;
      ca_busy_temp         <= de_ca_busy;

      //DE_PIPELINE_ACTIVE
      de_pipeln_activ_out  <= sync_de_pipeln_activ;
      sync_de_pipeln_activ <= de_pipeln_activ;
    end

  assign flow_a_dout = {de_pipeln_activ_out, de_ca_busy_dout,clp_a_out, 
			mcb_out, deb_a};

  assign sub_class[7:0] =  (pci_class_config==VGA ) ? 8'h00 : // VGA controller.
			   			      8'h80 ; //other display controller

  always @* begin
    case (pci_base0_1size) 
      2'b10: base_addr_reg0[9:0] = {base_valid_dec0[9:2], 2'b0};	// 16Mbytes
      2'b11: base_addr_reg0[9:0] = {base_valid_dec0[9:3], 3'b0};	// 32Mbytes
      2'b00: base_addr_reg0[9:0] = {base_valid_dec0[9:5], 5'b0};	// 128Mbytes
      2'b01: base_addr_reg0[9:0] = {base_valid_dec0[9:6], 6'b0};	// 256Mbytes
    endcase // case(pci_base0_1_size)
  end

  always @* begin
    case (pci_base0_1size) 
      2'b10: base_addr_reg1[9:0] = {base_valid_dec1[9:2], 2'b0};	// 16Mbytes.
      2'b11: base_addr_reg1[9:0] = {base_valid_dec1[9:3], 3'b0};	// 32Mbytes.
      2'b00: base_addr_reg1[9:0] = {base_valid_dec1[9:5], 5'b0};	// 128Mbytes
      2'b01: base_addr_reg1[9:0] = {base_valid_dec1[9:6], 6'b0};	// 256Mbytes
    endcase // case(pci_base0_1_size)
  end

  /****************************************************************************
   *                             PCI master registers
   * These registers are mapped to xe0 & xe4 in rbase_io & rbase_i spaces.
   ***************************************************************************/
  always @ (posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n) begin // enable all masks
      pci_wr_addr <= 30'h0;
      pcim_masks <= 22'h3f_ffff;
    end else if (cs_pci_wom && wr_en) begin
      case (hbi_addr_in[2])
	1'h0: begin //pci_wr_addr & be's
	  if (!hbi_byte_en_in[3]) pci_wr_addr[31:24] <= hbi_data_in[31:24];
	  if (!hbi_byte_en_in[2]) pci_wr_addr[23:16] <= hbi_data_in[23:16];
	  if (!hbi_byte_en_in[1]) pci_wr_addr[15:8]  <= hbi_data_in[15:8];
	  if (!hbi_byte_en_in[0]) pci_wr_addr[7:2]   <= hbi_data_in[7:2];
	end
	1'h1: begin //pcim_masks
	  if (!hbi_byte_en_in[2]) pcim_masks[21:16]  <= hbi_data_in[21:16];
	  if (!hbi_byte_en_in[1]) pcim_masks[15:8]   <= hbi_data_in[15:8];
	  if (!hbi_byte_en_in[0]) pcim_masks[7:0]    <= hbi_data_in[7:0];
	end
      endcase
    end
  end

  // Serial Eprom Registers 0xDC
  always @ (posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n) begin // enable all masks
      sepm_addr <= 3'b0;
      sepm_cmd  <= 4'b0;
      sepm_busy <= 1'b0;
    end else begin
      if (clr_sepm_busy)
        sepm_busy <= 1'b0;
      else if (cs_serial_eprom && wr_en && !hbi_byte_en_in[3])
        sepm_busy <= 1'b1;
      if (cs_serial_eprom && wr_en) begin
        if (!hbi_byte_en_in[0]) sepm_cmd         <= hbi_data_in[3:0];
        if (!hbi_byte_en_in[1]) sepm_addr[7:0]   <= hbi_data_in[15:8];
        if (!hbi_byte_en_in[2]) sepm_addr[15:8]  <= hbi_data_in[23:16];
        if (!hbi_byte_en_in[3]) sepm_addr[18:16] <= hbi_data_in[26:24];
      end
    end
  end
  
  /****************************************************************************
   *                             REGBLOCK_MUX
   * Block to multiplex between all the hbi registers
   ***************************************************************************/
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) begin
      ddc1_dat_sync_0 <= 1'b0;
      ddc1_dat_temp_0 <= 1'b0;
    end else begin
      ddc1_dat_sync_0 <= ddc1_dat_temp_0;
      ddc1_dat_temp_0 <= ddc1_dat_0;
    end
  
  always @(posedge hb_clk or negedge sys_reset_n)
    if (!sys_reset_n) begin
      ddc1_dat_sync_1 <= 1'b0;
      ddc1_dat_temp_1 <= 1'b0;
    end else begin
      ddc1_dat_sync_1 <= ddc1_dat_temp_1;
      ddc1_dat_temp_1 <= ddc1_dat_1;
    end

  /* 3 latches in a separate module to make changing */
  /* the rev field easier with mask changes          */
  /* Now an FPGA, so it goes away                    */
  assign sh_rev = 3'b011;

  //assign the interrupt pin & interrpt register
  assign intrp_pin[7:0] = 8'h01; /* connecting SILVERHAMMER interrupt
				  * pin to INTA# connector pin */

  assign intrp_reg[7:0] = interrupt_line[7:0];//read back the register

  //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  //          MUXING ALL HBI REGISTERS
  //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  always @* begin
    casex ({cs_draw_a_regs_n,
            cs_global_intrp_reg_n,
	    cs_window_regs_n,
            cs_pci_config_regs_n,
	    cs_blk_config_regs_n,
	    hbi_addr_in[8:2]}) /*synopsys parallel_case */
      12'b1_1_1_1_0_X00000_1: //RBASE_W
	hb_regs_dout =  {rbase_w_dout,8'h0};
      12'b1_1_1_1_0_X00000_0: //RBASE_G
	hb_regs_dout =  {rbase_g_dout,8'h0};
      
      12'b1_1_1_1_0_X00001_0: // RBASE_A
	hb_regs_dout = {rbase_a_dout,9'h0};
      
      12'b1_1_1_1_0_X00010_1: //RBASE_I
	hb_regs_dout = {rbase_e_dout,16'h0};
      12'b1_1_1_1_0_X00010_0: //RBASE_I
	hb_regs_dout = {rbase_i_dout,8'h0};
      
      12'b1_1_1_1_0_X00011_1: //CONFIG1
	hb_regs_dout =
		      // CONFIG1    
		      {8'b0,    // byte3
		       3'b0, enable_xy_de_a_p, 2'h0, enable_mem_window1_p, 
		       enable_mem_window0_p, 2'h0, enable_rbase_e_p, 
		       enable_rbase_i_p, 1'h0, // byte1
		       enable_rbase_a_p, enable_rbase_w_p, enable_rbase_g_p,
		       2'h0, se_clk_sel, 2'h0, soft_reset_p, 
		       dac_soft_reset};  // byte0
      12'b1_1_1_1_0_X00011_0: // ID
	hb_regs_dout =
		      { 1'b0, rom_present, 1'b0, pci_class_config, 1'b1, 
		       3'h0,                                    // byte3 
		       2'h0, subsytem_id[5:0],                  // byte2
		       3'b0, pci_base0_1size, 1'b0, dden,       // byte1
		       pci_base0_1size, 2'b0, 1'b1, sh_rev};    // byte0

      12'b1_1_1_1_0_X00100_1: //SGRAM
	hb_regs_dout = sgram_reg[31:0];
      12'b1_1_1_1_0_X00100_0: // CONFIG2 REG
	hb_regs_dout =
		      { 8'h0, 
		       cfg_reg2_mc, 1'h0, cfg_reg2_dws,
		       4'h0, cfg_reg2_ews,
		       cfg_reg2_cn, cfg_reg2_ref_cnt, cfg_reg2_rcd, 
		       cfg_reg2_jv,
		       cfg_reg2_tr, cfg_reg2_sgr, cfg_reg2_ide};
 	  
      12'b1_1_1_1_0_X00101_1: //SOFT SWITCHS REG & M_INFO.
	hb_regs_dout =
		      {
			6'h0,                // 6      64
			m_info_dout[7:6],    // 2      58
			4'h0,                // 4      56
			ddc_clk_in_1,        // 1      52
 		        m_info_dout[5],      // 1      51
			ddc1_dat_sync_1,     // 1      50
			m_info_dout[4],      // 1      49
			6'h0,                // 6      48
			m_info_dout[3:2],    // 2      42
			2'h0,                // 2      40
			2'h0,                // 2      38
			ddc_clk_in_0,        // 1      36
 		        m_info_dout[1],      // 1      35 
			ddc1_dat_sync_0,     // 1      34
			m_info_dout[0]};      // 1      33
      12'b1_1_1_1_0_X00101_0: //SOFT SWITCHS REG & M_INFO.
	hb_regs_dout = {
			16'h0,
			soft_switch_in,      // 8
			soft_switch_out      // 8
			};
      
      12'b1_1_1_1_0_X00110_0: //VGA_CTRL & RESERVED
	hb_regs_dout =
		      {24'h0, vga_ctrl_dout[7:0]};
      
      12'b1_1_1_1_0_X01101_1: //BIOS REG 2
	hb_regs_dout = bios_2_dout[31:0];
      12'b1_1_1_1_0_X01101_0: //BIOS REG 1
	hb_regs_dout = bios_1_dout[31:0];
      
      12'b1_1_1_1_0_X01110_1: //BIOS REG 4
	hb_regs_dout = bios_4_dout[31:0];
      12'b1_1_1_1_0_X01110_0: //BIOS REG 3
	hb_regs_dout = bios_3_dout[31:0];
      
      12'b1_1_1_1_0_X11010_1: //DMAC_SRC
	hb_regs_dout = REG_RESERVED;
      12'b1_1_1_1_0_X11010_0: //DMAC_DST
	hb_regs_dout = REG_RESERVED;
      
      12'b1_1_1_1_0_X11011_1: //Serial Eprom Control
        hb_regs_dout = {sepm_busy, 4'b0, 
		        sepm_addr[18:16],
                        sepm_addr[15:8],
                        sepm_addr[7:0],
                        4'b0, sepm_cmd};
      12'b1_1_1_1_0_X11011_0: //DMAC_CMD
        hb_regs_dout = REG_RESERVED;

      12'b1_1_1_1_0_X11100_1: //PCIM_MASKS
	hb_regs_dout = {10'h0, pcim_masks};
      12'b1_1_1_1_0_X11100_0: //PCI_WR_ADDR
	hb_regs_dout = {pci_wr_addr, 2'h0};
      
      //
      // PCI configuration registers
      //
      12'b1_1_1_0_1_X00000_1: //STATUS/COMMAND & DEVICE ID REG
	hb_regs_dout = {5'h0, DEVSEL_MEDIUM, 1'b0, 1'b1, //Status Reg
			1'b0, m66_en, CAP_LIST, 4'h0,
			10'h0, vga_palette_snoop_n, 2'b00,      //Command Reg
			pci_mstr_en, pci_mem_enable_p, pci_io_enable_p}; 
      12'b1_1_1_0_1_X00000_0: //STATUS/COMMAND & DEVICE ID REG
	hb_regs_dout = { devid,                              //Device ID
			VENDOR_ID};                             //Vendor ID
  
      12'b1_1_1_0_1_X00001_1: //BIST & CLASS REG
	hb_regs_dout = { BIST, 
		       SINGLE_FUNCTION, 7'h0,
		       LATENCY_TIMER,
		       CACHE_LINE_SIZE};

      12'b1_1_1_0_1_X00001_0: //BIST & CLASS REG
	hb_regs_dout = { DISPLAY_CONTROLLER,
		       sub_class[7:0],
		       PROG_IF,
		       5'h0, sh_rev};
	  
      12'b1_1_1_0_1_X00010_1: //BASE1
	hb_regs_dout = {base_addr_reg1[9:0], 18'h0, 
		       PREFETCHABLE, 2'h0, MEM_SPACE};
      12'b1_1_1_0_1_X00010_0: //BASE0
	hb_regs_dout = {base_addr_reg0[9:0], 18'h0, 
		       PREFETCHABLE, 2'h0, MEM_SPACE};
	  
      12'b1_1_1_0_1_X00011_0: //BASE2 REG
	hb_regs_dout =
		      { base_addr_reg2[31:12], 8'h0, 
		       NON_PREFETCHABLE, 2'h0, MEM_SPACE};
   	  
      12'b1_1_1_0_1_X00100_1: //BASE5 & BASE4 REG
	hb_regs_dout = {base_addr_reg5[23:0],
		       6'h0, 1'b0, IO_SPACE};
      12'b1_1_1_0_1_X00100_0: //BASE5 & BASE4 REG
	hb_regs_dout = { base_addr_reg4[15:0],
		       12'h0, NON_PREFETCHABLE, 2'h0, MEM_SPACE};

      12'b1_1_1_0_1_X00101_1: //SUB_VENDOR ID
	hb_regs_dout = {subsytem_id, sub_vendor_id};
	  
      12'b1_1_1_0_1_X00110_1: //CAPABILITIES POINTER
	hb_regs_dout = {24'h0, CAP_PTR};

      12'b1_1_1_0_1_X00110_0: //ROM BASE
	hb_regs_dout = { rbase_e_dout[31:16], 15'h0, 
			pci_eprom_enable_p};  
	 
      12'b1_1_1_0_1_X00111_1: //INTERRUPT LINE & RESERVED REG
	hb_regs_dout =
		      {MAX_LAT,
		       MIN_GNT,
		       intrp_pin[7:0],
		       intrp_reg[7:0]};
	  
      12'b1_1_1_0_1_X01XXX_X: //REGISTERS FROM 40h-7Fh ARE RESERVED
	hb_regs_dout = REG_RESERVED;
      
      12'b1_1_1_0_1_X10000_1: //AGP STATUS
	hb_regs_dout = {AGP_RQ, 14'h0, subsytem_id[5], 7'h0, AGP_RATE};
      12'b1_1_1_0_1_X10000_0: // CAPABILITIES ID
	hb_regs_dout = {8'h0, REV_MAJ, REV_MIN, PM_PTR, AGP_ID};
      
      12'b1_1_1_0_1_X10001_X: //RESERVED REG & AGP COMMAND REG (No more AGP)
	hb_regs_dout = REG_RESERVED;

      12'b1_1_1_0_1_X10010_1: //Power Managment STATUS
	hb_regs_dout = {30'h0, pm_ps};
      12'b1_1_1_0_1_X10010_0: //STATUS & CAPABILITIES ID
	hb_regs_dout = {16'h21, NO_PTR, PM_ID};

      //Remainder of registers in config space are reserved
      12'b1_1_1_0_1_X10011_X,
	12'b1_1_1_0_1_X101XX_X,
	12'b1_1_1_0_1_X11XXX_X: 
	  hb_regs_dout = REG_RESERVED;

      //
      // Window registers
      //
      // window 0
      12'b1_1_0_1_1_X00000_1: // MW0_AD
	hb_regs_dout = {mw0_ad_dout,12'h0};
      12'b1_1_0_1_1_X00000_0: //MW0_CTRL
	hb_regs_dout = {mw0_ctrl_dout[24:17], mw0_ctrl_dout[16:9],
		       7'h0,mw0_ctrl_dout[8],mw0_ctrl_dout[7:0]};
	  
      12'b1_1_0_1_1_X00001_0: //MW0_SZ
	hb_regs_dout =
		      {5'h0, 
		       mw0_sz_dout_flush[1], 1'b0, 
		       mw0_sz_dout_flush[0], 
		       20'h0, mw0_sz_dout[3:0]};
	  
      12'b1_1_0_1_1_X00010_X: //MW0_ORG
	hb_regs_dout = {6'h0, mw0_org_dout[25:12],12'h0};
   	 
      // window 1
      12'b1_1_0_1_1_X00101_1: // MW1_AD 
	hb_regs_dout = {mw1_ad_dout,12'h0};

      12'b1_1_0_1_1_X00101_0: //MW1_CTRL
	hb_regs_dout = {mw1_ctrl_dout[24:17],
		       mw1_ctrl_dout[16:9],
		       7'h0,mw1_ctrl_dout[8],mw1_ctrl_dout[7:0]};
      
      12'b1_1_1_1_0_X01000_1: //MW1_CTRL & MW1_AD 
	hb_regs_dout = {mw1_ad_dout,12'h0};

      12'b1_1_1_1_0_X01000_0: //MW1_CTRL & MW1_AD 
	hb_regs_dout = { mw1_ctrl_dout[24:17],
		       mw1_ctrl_dout[16:9],
		       7'h0,mw1_ctrl_dout[8],mw1_ctrl_dout[7:0]};

      12'b1_1_0_1_1_X00110_0: //MW1_SZ
	hb_regs_dout = {5'h0, mw1_sz_dout_flush[1], 1'b0, 
		       mw1_sz_dout_flush[0],
 		       20'h0, mw1_sz_dout[3:0]};

      12'b1_1_1_1_0_X01001_0: //MW1_SZ
	hb_regs_dout = {5'h0, mw1_sz_dout_flush[1], 1'b0, 
		       mw1_sz_dout_flush[0],
 		       20'h0, mw1_sz_dout[3:0]};
	  
      12'b1_1_0_1_1_X00111_X: //MW1_ORG
	hb_regs_dout = {6'h0,mw1_org_dout[25:12],12'h0};

      12'b1_1_1_1_0_X01010_X: //MW1_ORG
	hb_regs_dout = {6'h0,mw1_org_dout[25:12],12'h0};
   	 
      //
      // global interrupt registers
      //

      12'b1_0_1_1_1_X00000_1: // GINTM
	hb_regs_dout = {15'h0,gintm_dout[2], 14'h0, gintm_dout[1:0]};
      12'b1_0_1_1_1_X00000_0: // GINTP
	hb_regs_dout = {22'h0, gintp_dout[3:2], 6'h0,gintp_dout[1:0]};
	  
      12'b1_0_1_1_1_X10000_1: //RBASE_G & RBASE_W(IN MEM SPACE)
	hb_regs_dout = {rbase_w_dout,8'h0};
      12'b1_0_1_1_1_X10000_0: //RBASE_G & RBASE_W(IN MEM SPACE)
	hb_regs_dout = {rbase_g_dout,8'h0};

      12'b1_0_1_1_1_X10001_0: //RBASE_B & RBASE_A(IN MEM SPACE)
	hb_regs_dout = {rbase_a_dout,9'h0};
	 
      12'b1_0_1_1_1_X10010_1: // RBASE_E(IN MEM SPACE)
	hb_regs_dout = {rbase_e_dout, 16'h0};
      12'b1_0_1_1_1_X10010_0: //RBASE_I 
	hb_regs_dout = {rbase_i_dout,8'h0};

      12'b1_0_1_1_1_X10011_1: //CONFIG1 & ID(IN MEM SPACE)
	hb_regs_dout =
		      // CONFIG1    
		      {8'b0,    // byte3
		       3'b0, enable_xy_de_a_p, 2'h0, enable_mem_window1_p, 
		       enable_mem_window0_p,
		       2'h0, enable_rbase_e_p, enable_rbase_i_p, 1'h0, // byte1
		       enable_rbase_a_p, enable_rbase_w_p, enable_rbase_g_p,
		       2'h0, se_clk_sel, 2'h0, soft_reset_p, 
		       dac_soft_reset};  // byte0

      12'b1_0_1_1_1_X10011_0: //CONFIG1 & ID(IN MEM SPACE)
	hb_regs_dout =
		       // ID
		       {1'b0, rom_present, 1'b0, pci_class_config, 1'b1, 
		       3'h0,                                     // byte3 
		       2'h0, subsytem_id [5:0],                  // byte2
		       3'b0, pci_base0_1size, 1'b0, dden,        // byte1
		       pci_base0_1size, 2'b0, 1'b1, sh_rev};  // byte0

      12'b1_0_1_1_1_X10100_1: //SGRAM
	hb_regs_dout = sgram_reg[31:0];
      12'b1_0_1_1_1_X10100_0: // CONFIG2 REG (MEM SPACE)
	hb_regs_dout =
		       {8'h0, 
		       cfg_reg2_mc, 1'h0, cfg_reg2_dws,
		       4'h0, cfg_reg2_ews,
		       cfg_reg2_cn, cfg_reg2_ref_cnt, cfg_reg2_rcd, 
		       cfg_reg2_jv,
		       cfg_reg2_tr, cfg_reg2_sgr, cfg_reg2_ide};
 
      12'b1_0_1_1_1_X10101_1: // SOFT SWITCHS & M_INFO(MEM SPACE)
	hb_regs_dout = {
			6'h0,                // 6      64
			m_info_dout[7:6],    // 2      58
			4'h0,                // 4      56
			ddc_clk_in_1,        // 1      52
 		        m_info_dout[5],      // 1      51
			ddc1_dat_sync_1,     // 1      50
			m_info_dout[4],      // 1      49
			6'h0,                // 6      48
			m_info_dout[3:2],    // 2      42
			2'h0,                // 2      40
			2'h0,                // 2      38
			ddc_clk_in_0,        // 1      36
 		        m_info_dout[1],      // 1      35 
			ddc1_dat_sync_0,     // 1      34
			m_info_dout[0]};     // 1      33
      12'b1_0_1_1_1_X10101_0: // SOFT SWITCHS
	hb_regs_dout = {
			soft_switch_in,      // 16     32
			soft_switch_out      // 16
			};
	  
      12'b1_0_1_1_1_X10110_1: //BIOS REG 1
	hb_regs_dout = bios_1_dout[31:0];
      12'b1_0_1_1_1_X10110_0: //VGA_CTRL REG
	hb_regs_dout = {24'h0, vga_ctrl_dout[7:0]};
	 
      12'b1_0_1_1_1_X10111_1: //BIOS REG 3
	hb_regs_dout = bios_3_dout[31:0];
      12'b1_0_1_1_1_X10111_0: // BIOS REG 2
	hb_regs_dout = bios_2_dout[31:0];
      
      12'b1_0_1_1_1_X11000_0: // BIOS REG 4
	hb_regs_dout = bios_4_dout[31:0]; 
      
      12'b1_0_1_1_1_X11010_X: //DMAC_SRC & DMAC_DST
	hb_regs_dout = REG_RESERVED;
      
      12'b1_0_1_1_1_X11011_X: //DMAC_CMD & RESERVED
	hb_regs_dout = 32'h0;
      
      12'b1_0_1_1_1_X11100_1: //PCI_WR_ADDR & PCIM_MASKS
	hb_regs_dout = {10'h0, pcim_masks};
      12'b1_0_1_1_1_X11100_0: //PCI_WR_ADDR & PCIM_MASKS
	hb_regs_dout = {pci_wr_addr, 2'h0};
  
      //
      // drawing engine A registers
      //
      12'b0_1_1_1_1_000000_1: //INTM_A
	hb_regs_dout = {30'h0, intm_a_dout[1:0]};
      12'b0_1_1_1_1_000000_0: //INTP_A
	hb_regs_dout = {30'h0, intp_a_dout[1:0]};
      
      12'b0_1_1_1_1_000001_1: //BUSY_A
	hb_regs_dout = {31'h0,busy_a};
      12'b0_1_1_1_1_000001_0: //BUSY_A & FLOW_A
	hb_regs_dout = {27'h0,flow_a_dout[4:0]};
	 
      12'b0_1_1_1_1_000010_0: //XYW_AD
	hb_regs_dout = {xyw_a_dout[31:12],12'h0};

      default: 
	hb_regs_dout = 32'h0;

    endcase
    
  end

  assign de_pl_busy = busy_a;
  assign flow_reg = flow_a_dout;

endmodule
 
 


