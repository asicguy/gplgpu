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
//  Title       :  Host Bus Address Decoder
//  File        :  hbi_addr_decoder.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  module to decode the hbi address and generate the various chip selects
//  to the different blackbird sections
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

module hbi_addr_decoder
  (
   input [31:0]	     hb_lachd_addr,    // HBI latched address
   input [31:3]      hbi_addr_in,      /* host bus low address bits coming out
					* of the address counter
					*/
   input	     sys_reset_n,      // host bus system reset.
   input [3:0] 	     hb_lachd_cmd,     // HBI latched bus command. 
   input [31:8]      rbase_g_dout,     // RBASE_G register data output
   input [31:8]	     rbase_w_dout,     // RBASE_W register data output
   input [31:9]	     rbase_a_dout,     // RBASE_A register data output
   input [31:8]	     rbase_i_dout,     // RBASE_I register data output
   input [31:12]     mw0_ad_dout,      // (memory window 0 address)
   input [3:0]	     mw0_sz_dout,      // (memory window 0 size)
   input [31:12]     mw1_ad_dout,      // (memory window 1 address)
   input [3:0]	     mw1_sz_dout,      // (memory window 1 size)
   input [31:12]     xyw_a_dout,       /* XY window address and size
					* for drawing engine A
					*/
   input	     enable_rbase_g_p, // decode en for RBASE_G register
   input	     enable_rbase_w_p, // decode en for RBASE_W register
   input	     enable_rbase_a_p, // decode en for RBASE_A register
   input	     enable_rbase_i_p, // decode en for RBASE_I register
   input	     enable_mem_window0_p,// decode enable for memory window 0
   input	     enable_mem_window1_p,// decode enable for memory window 0
   input	     enable_xy_de_a_p, //decode enable for XY window for DE1
   input	     pci_io_enable_p,  /* PCI I/O space enable, on power up
					* this bit is set (IO space is enabled)
					*/
   input	     pci_mem_enable_p, /* PCI MEMORY space enable, on power up
					* this bit is set. MEM space is enabled
					*/
   input	     lachd_idsel_p,    /* latched Initialization device select
					* (this is the latched
					* chip select from PCI bus bridge)
					*/
   input [31:16]     rbase_e_dout,     // RBASE_E register data output
   input	     enable_rbase_e_p, /* decode enable for RBASE_E register, 
					* on power up this bit is set
					* (EPROM space enabled)
					*/
   input	     pci_eprom_enable_p,/* PCI EPROM space enable, on power up
					 * this bit is enabled
					 * (EPROM space is enabled) */
   input [23:0]      base_addr_reg5,   /* PCI configuration base address 
					* register 5 (IO SPACE) */
   input	     hb_clk,
   input	     pci_class_config, /* PCI class configuration, vga or other
					* 1--->decode standared VGA,
					* 0--->decode extended VGA. */
   input [1:0]	     vga_decode_ctrl,
   input	     fis_vga_space_en, // mem_en bit, vga control reg[3]
   input	     fis_io_en,        // 
   input	     vga_global_enable,
   input	     vga_3c6block_en_p,
   input [8:2]	     hbi_mac,          // hbi master's_address_count

   output reg	     cs_mem0_n,        // chip select memory window 0
   output reg	     cs_mem1_n,        // chip select memory window 1
   output	     cs_windows_n,     /* this signal is asserted whenever one
					* of the decoder memory windows is 
					* asserted */
   output reg	     cs_blk_config_regs_n,// chip select config registers
   output reg	     cs_blk_config_regs_un,  
   output reg	     cs_global_regs_n, /* chip select any global register 
					* EXCEPT DAC
					* SHADOW regs (active low signal) */
   output reg	     cs_global_intrp_reg_n,// chip select global int registers
   output reg	     cs_window_regs_n, // sync chip select window registers
   output reg	     cs_window_regs_un,// chip select window registers
   output reg	     cs_draw_a_regs_n, // chip select drawing engine A
   output reg	     cs_draw_a_regs_un,// chip select drawing engine A
   output reg	     cs_xyw_a_n,       /* chip select XY memory window for 
					* drawing engine A */
   output	     cs_hbi_regs_n,    /* This chip select is asserted if any 
					* of the HBI regsiters is been 
					* addressed. */
   output	     cs_blkbird_n,     /* This chip select is asserted if any 
					* chip resource is been addressed
					*/
   output reg	     cs_pci_config_regs_n,// chip select PCI config registers
   output	     cs_blkbird_regs_n,
   output reg	     cs_vga_shadow_n,  /* chip select VGA registers
					* in either I/O or MEM mode
					*/
   output reg	     cs_eprom_n,       /* chip select EPROM (the EPROM present
					* on the graphics board). */
   output	     cs_sw_write_n,    // chip select write to soft switches
   output reg	     cs_soft_switchs_n,// chip select soft switches
   output	     cs_soft_switchs_un,/* chip select soft switches unsynched
					 * to host clock
					 */
   output reg	     cs_vga_space_n,   /* chip select VGA space whenever BLK
					* has VGA on board determined from the
					* PCI class configuration bits. */
   output	     cs_draw_stop_n,
   output reg	     cs_3c6_block_n,
   output reg	     cs_dac_space_n,
   output reg	     cs_dereg_f8_n,    // dlp address register select for retry
   output reg	     cs_dl_cntl,       // dlp control register for flushing
   output reg	     cs_de_xy1_n,
   output	     cs_pci_wom,
   output            cs_serial_eprom   // Serial Eprom Control register
   );

  // Registers
  reg [12:0]	mw0_mask;
  reg [12:0]	mw1_mask;
  reg [12:0]	xywa_mask;
  reg		cs_blk_config_inter_n;
  reg		cs_global_regs_un;
  reg		cs_global_intrp_reg_un;
  reg		cs_pci_config_regs_un;
  reg [1:0]	vga_decode_ctrl_s;
  reg		fis_io_en_s;  
   
  reg [2:0] 	cycle_type;      /* PCI cycle type 
				  * 00-->IO,
				  * 01-->MEM,
                                  * 10--->CONFIG,
				  * 11--->INT_ACK
				  */
  wire 		hb_lached_rdwr;

  parameter 	IO         = 3'h0, //IO MAPPED
		MEM        = 3'h1, //MEMORY MAPPED
		PCI_CONFIG = 3'h2, //PCI_CONFIGURATION
		CMD_RESVD  = 3'h4, //RESERVED COMMAND DECODE
		
		EXTENDED_VGA = 1'b0, 
		
		NO_SOURCE  = 2'b11,/* linear memory window source enable is 
				    * set to NO source */
		NO_DESTN   = 2'b11,/*linear memory window destination enable 
				    * is set to NO destination */
		READ       = 1'b0,
		WRITE      = 1'b1,
		VGA        = 2'h0;
  
  // Read_Write line is LSB of hb_lached_cmd
  assign 	hb_lached_rdwr = hb_lachd_cmd[0];
   
  /***************************************************************************
   * assign CYCLE TYPE, (either I/O or MEMORY MAPPED or PCI_CONFIGURATION)
   * RESERVED COMMAND DECODE & DUAL ADDRESS CYCLE & SPECIAL CYCLE & 
   * INTERRUPT ACKNOWLEDGE (BLKBIRD WOULDN'T RESPOND TO ANY COMMAND RESERVED 
   * CYCLES.
   ***************************************************************************/
  always @*
    casex(hb_lachd_cmd)
      4'b001x:   cycle_type = IO;
      4'b111x,
	4'b011x,
	4'b1100: cycle_type = MEM;
      4'b101x:   cycle_type = PCI_CONFIG;
      default:   cycle_type = CMD_RESVD;
    endcase // casex(hb_lachd_cmd)
  
  /*
   * Generate chip select for memory window 0 (decoder_cs_mem0_n)
   * The window is assumed to be aligned the same as the size of the window.
   * i.e. a 32M window starts on a 32M block.  This reduces the decode task
   * to simply comparing the appropriate MSB's of the PCI address with the 
   * MSB's of the memory window base address register. This is accomplished by
   *  XORing the address with the base register, then masking off an 
   * increasing number of LSB's as the window size increases.
   * Finally, the decode is inhibited when reading from no source, or writing 
   * to no destination.
   */
  always @* begin
    // create a mask for address LSB's based on window size
    case (mw0_sz_dout)
      4'h0: mw0_mask = 13'b0000000000000; //   4K
      4'h1: mw0_mask = 13'b0000000000001; //   8K
      4'h2: mw0_mask = 13'b0000000000011; //  16K
      4'h3: mw0_mask = 13'b0000000000111; //  32K
      4'h4: mw0_mask = 13'b0000000001111; //  64K
      4'h5: mw0_mask = 13'b0000000011111; // 128K
      4'h6: mw0_mask = 13'b0000000111111; // 256K
      4'h7: mw0_mask = 13'b0000001111111; // 512K
      4'h8: mw0_mask = 13'b0000011111111; //   1M
      4'h9: mw0_mask = 13'b0000111111111; //   2M
      4'ha: mw0_mask = 13'b0001111111111; //   4M
      4'hb: mw0_mask = 13'b0011111111111; //   8M
      4'hc: mw0_mask = 13'b0111111111111; //  16M
      4'hd: mw0_mask = 13'b1111111111111; //  32M
      4'he: mw0_mask = 13'b1111111111111; //  reserved (32M)
      4'hf: mw0_mask = 13'b1111111111111; //  reserved (32M)
    endcase // case (mw0_sz_dout)
    
    if (sys_reset_n==0 || enable_mem_window0_p==0 || pci_mem_enable_p==0 )
      cs_mem0_n = 1'b1;
    else if(cycle_type==MEM && 
	    ((hb_lachd_addr[31:12] ~^ mw0_ad_dout[31:12] | 
	      {7'h0,mw0_mask})==20'hfffff))
      cs_mem0_n = 1'b0;
    else
      cs_mem0_n = 1'b1;
  end // always @ 

  /*
   * Generate chip select for memory window 1 (decoder_cs_mem1_n)
   * The window is assumed to be aligned the same as the size of the window.
   * i.e. a 32M window starts on a 32M block.  This reduces the decode task
   * to simply comparing the appropriate MSB's of the PCI address with the 
   * MSB's of the memory window base address register.  This is accomplished 
   * by XORing the address with the base register, then masking off an 
   * increasing number of LSB's as the window size increases.
   * Finally, the decode is inhibited when reading from no source, or writing 
   * to no destination.
   */
  always @* begin
    // create a mask for address LSB's based on window size
    case (mw1_sz_dout)
      4'h0: mw1_mask = 13'b0000000000000; //   4K
      4'h1: mw1_mask = 13'b0000000000001; //   8K
      4'h2: mw1_mask = 13'b0000000000011; //  16K
      4'h3: mw1_mask = 13'b0000000000111; //  32K
      4'h4: mw1_mask = 13'b0000000001111; //  64K
      4'h5: mw1_mask = 13'b0000000011111; // 128K
      4'h6: mw1_mask = 13'b0000000111111; // 256K
      4'h7: mw1_mask = 13'b0000001111111; // 512K
      4'h8: mw1_mask = 13'b0000011111111; //   1M
      4'h9: mw1_mask = 13'b0000111111111; //   2M
      4'ha: mw1_mask = 13'b0001111111111; //   4M
      4'hb: mw1_mask = 13'b0011111111111; //   8M
      4'hc: mw1_mask = 13'b0111111111111; //  16M
      4'hd: mw1_mask = 13'b1111111111111; //  32M
      4'he: mw1_mask = 13'b1111111111111; //  reserved (32M)
      4'hf: mw1_mask = 13'b1111111111111; //  reserved (32M)
    endcase // case (mw1_sz_dout)
    
    if (sys_reset_n==0 || enable_mem_window1_p==0 || pci_mem_enable_p==0 )
      cs_mem1_n = 1'b1;
    else if(cycle_type==MEM && 
	    ((hb_lachd_addr[31:12] ~^ mw1_ad_dout[31:12] | 
	      {7'h0,mw1_mask})==20'hfffff))
      cs_mem1_n = 1'b0;
    else
      cs_mem1_n = 1'b1;
  end // always @

  /*
   * This signal is active if either memory window chip selects
   * is active
   */
  assign cs_windows_n = (cs_mem0_n && cs_mem1_n);

  /****************************************************************************
   generating chip select I/O mapped BLACKBIRD configuration registers
   (cs_blk_config_reg)
   PCI CONFIGURATION BASE ADDRESS REGISTER 5 WOULD BE USED FOR ADDRESS DECODING
   Note: Soft switch location 0x0028 & DAC IO mapped registers 0x0080-0x00bc
   are excluded from the decode
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || pci_io_enable_p==0)
      cs_blk_config_inter_n = 1'b1;
    else if (hb_lachd_addr[31:8]==base_addr_reg5[23:0] && cycle_type==IO)
      cs_blk_config_inter_n = 1'b0;
    else
      cs_blk_config_inter_n = 1'b1;
  
  always @*
    if (sys_reset_n==0 || pci_io_enable_p==0)
      cs_blk_config_regs_un = 1'b1;
    else if (hb_lachd_addr[31:8]==base_addr_reg5[23:0] && cycle_type==IO  &&
	     ((hb_lachd_addr[7:5]==3'h0) || // 0x-1x
	      (hb_lachd_addr[7:3]==5'h04) || // 20 & 24
	      (hb_lachd_addr[7:2]==6'h0a && hb_lached_rdwr==READ) || // 28 soft switch reg
	      (hb_lachd_addr[7:2]==6'h0b) ||
	      (hb_lachd_addr[7:4]>=4'h3 && hb_lachd_addr[7:4]<=4'h7) || // 30-7c
	      (hb_lachd_addr[7:6]==2'h3))) // c0-fc
      cs_blk_config_regs_un = 1'b0;
    else
      cs_blk_config_regs_un = 1'b1;

  /***************************************************************************
   generating chip select PCI configuration registers (cs_pci_config_reg)
   NOTE: ON POWER UP, THE PCI CONFIGURATION REGISTERS ARE THE ONLY
   REGISTERS THE HOST COULD ACCESS, THEN THE HOST COULD SELECTIVELY ENABLE
   BLACKBIRD I/O SPACE OR MEMORY SPACE BY SETTING THE CORRESPONDING BITS IN
   THE COMMAND REG IN THE PCI_CONFIGURATION BLOCK; ONCE THAT'S DONE, THE
   HOST COULD THEN SELECTIVELY ENABLE READS/WRITES TO ANY OF THE BLACKBIRD
   REGISTER BLOCK OR ANY LINEAR MEMORY WINDOW OR XY_WINDOW BY SETTING THE
   APPROPRIATE BIT(S) IN THE BLACKBIRD CONFIGURATION REGISTER
   **************************************************************************/
  always @*
    if (!sys_reset_n)
      cs_pci_config_regs_un = 1'b1;
    else if (lachd_idsel_p &&
	     cycle_type==PCI_CONFIG && hb_lachd_addr[1:0]==2'h0)
      cs_pci_config_regs_un = 1'b0;
    else
      cs_pci_config_regs_un = 1'b1;
  
  /****************************************************************************
   generating chip select memory mapped global registers (cs_global_regs_n)
   MEM SPACE: if host address is either 0x0000-to-0x001C or 0x0070-to-0x00AC 
   then assert cs_global_regs.
   NOTE: WHEN ANY OF THE DAC SHADOW REGISTERS ARE ADDRESSED IN MEMORY SPACE,
   CS_GLOBAL_REGS WOULD BE DEASSERTED (SINCE THOSE REGISTERS DON'T EXIST
   PHYSICALLY IN BLKBIRD
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || enable_rbase_g_p==0 || pci_mem_enable_p==0 ||
	cs_vga_space_n==0)
      cs_global_regs_un = 1'b1;
    else if (hb_lachd_addr[31:8] == rbase_g_dout[31:8] && cycle_type==MEM &&
	     ((hb_lachd_addr[7:3]>5'h03 && hb_lachd_addr[7:3]<5'he ) ||
	      (hb_lachd_addr[7:3]>5'h15)))
      cs_global_regs_un = 1'b0;
    else
      cs_global_regs_un = 1'b1;
  
  /****************************************************************************
   generating chip select memory window registers (cs_window_regs_un)
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || enable_rbase_w_p==0 || pci_mem_enable_p==0)
      cs_window_regs_un = 1'b1;
    else if (hb_lachd_addr[31:8] == rbase_w_dout[31:8] && cycle_type==MEM )
      cs_window_regs_un = 1'b0;
    else
      cs_window_regs_un = 1'b1;

  /***************************************************************************
   generating chip select memory mapped drawing engine A registers
   (cs_draw_a_regs_n)
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || enable_rbase_a_p==0 || pci_mem_enable_p==0)
      cs_draw_a_regs_un = 1'b1;
    else if (hb_lachd_addr[31:9] == rbase_a_dout[31:9] && cycle_type==MEM)
      cs_draw_a_regs_un = 1'b0;
    else
      cs_draw_a_regs_un = 1'b1;
  
  //all drawing registers except the display list registers
  assign cs_draw_stop_n = !(!cs_draw_a_regs_un &&
			    (hbi_mac[8:3]>=6'h03) &&
			    (hbi_mac[8:3]!=6'h1f));

  /****************************************************************************
   * generating chip select for de_xy1 register
   ***************************************************************************/
  always @* begin
    if (!sys_reset_n || !enable_rbase_a_p || !pci_mem_enable_p)
      cs_de_xy1_n = 1'b1;
    else if (hbi_addr_in[31:9] == rbase_a_dout[31:9] && cycle_type == MEM)
      cs_de_xy1_n = ~(hbi_mac[8:2] == 7'h23);
    else
      cs_de_xy1_n = 1'b1;
  end

  /****************************************************************************
   generating chip select memory mapped display list register F8 only
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || enable_rbase_a_p==0 || pci_mem_enable_p==0)
      cs_dereg_f8_n = 1'b1;
    else if (hbi_mac[8:2] == 7'h3e &&                // [8:2]3e = [8:0]0f8
	     hbi_addr_in[31:9] == rbase_a_dout[31:9] && cycle_type==MEM)
      cs_dereg_f8_n = 1'b0;
    else
      cs_dereg_f8_n = 1'b1;

  /****************************************************************************
   generating chip select memory mapped display list register FC only
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || enable_rbase_a_p==0 || pci_mem_enable_p==0)
      cs_dl_cntl = 1'b0;
    else if (hb_lachd_addr[31:9] == rbase_a_dout[31:9] && cycle_type==MEM)
      cs_dl_cntl = (hbi_mac[8:2] == 7'h3f);
    else
      cs_dl_cntl = 1'b0;
  
  /****************************************************************************
   generating chip select memory mapped global INTERRUPT register
   (cs_global_intrp_reg_n)
   ***************************************************************************/
  always @*
    if (!sys_reset_n || !enable_rbase_i_p || !pci_mem_enable_p)
      cs_global_intrp_reg_un = 1'b1;
    else if (hb_lachd_addr[31:8] == rbase_i_dout[31:8] && cycle_type==MEM)
      cs_global_intrp_reg_un = 1'b0;
    else
      cs_global_intrp_reg_un = 1'b1;
   
  /*
   * Generate chip select XYmemory window for drawing engine .
   */
  always @* begin  
    if (sys_reset_n==0 || enable_xy_de_a_p==0 || pci_mem_enable_p==0)
      cs_xyw_a_n = 1'b1;
    else if(cycle_type==MEM && (hb_lachd_addr[31:12] ==  xyw_a_dout))
      cs_xyw_a_n = 1'b0; 
    else
      cs_xyw_a_n = 1'b1; 
  end //

  /****************************************************************************
   GENERATING CHIP SELECT VGA SHADOW REGISTERS
   NOTE: Shadow registers are either IO mapped DAC registers or
   memory mapped DAC registers
   I/O SPACE: if the host address is either 0x0080-0x00bc 
   MEM SPACE: if global registers block is enabled, & host address is either 
   0x0000-to-0x001C or 0x0070-to-0x00AC then chip
   select VGA shadow is asserted.
   ***************************************************************************/
  always @*
    if (sys_reset_n==0) 
      cs_vga_shadow_n = 1'b1;
    else if //IO CYCLE 
      ((cycle_type==IO && pci_io_enable_p==1 && cs_blk_config_inter_n==0) &&
       (hb_lachd_addr[7:4] >= 4'h8 && hb_lachd_addr[7:4] <= 4'hb))
      cs_vga_shadow_n = 1'b0;
    else if  //MEMORY CYCLE 
      ((cycle_type==MEM && pci_mem_enable_p==1 && enable_rbase_g_p==1 &&
	hb_lachd_addr[31:8]==rbase_g_dout[31:8]) &&
       ((hb_lachd_addr[7:5] == 3'h0) || // addr = 0 or 1
	(hb_lachd_addr[7:4] >= 4'h7 && hb_lachd_addr[7:4] <= 4'ha)))
      cs_vga_shadow_n = 1'b0;
    else
      cs_vga_shadow_n = 1'b1;

  /*
   * GENERATE CS_DAC_SPACE TO THE MEMORY CONTROLLER
   */
  always @(posedge hb_clk) cs_dac_space_n <= cs_3c6_block_n && cs_vga_shadow_n;

  /* Generate chip select for EPROM. Base address is rbase_e[31:16].*/
  always @* begin
    if (sys_reset_n==0 || enable_rbase_e_p==0 ||
	pci_mem_enable_p==0 || pci_eprom_enable_p==0) 
      cs_eprom_n = 1'b1;
    else if (cycle_type==MEM && (hb_lachd_addr[31:16] == rbase_e_dout))
      cs_eprom_n = 1'b0;
    else
      cs_eprom_n = 1'b1;
  end

  /****************************************************************************
   GENERATING CHIP SELECT FOR THE VGA SPACE  
   NOTE: IN ALL THE CASES BELOW, THE GLOBAL VGA ENABLE BIT SHOULD BE ASSERTED 
   FOR VGA TO RESPOND
   NOTE: 3C6-3C9 is no longer part of the VGA space decode.

   IO SPACE: If the cycle is in I/O space & PCI class bits are set to VGA & the
   host address is 0x03C0-0x3C2 ,or 0x3C4-0x3C5, or 0x3CA, or 0x3CC,
   or  0x3CE-0x3CF, or 0x3B4-0x3B5, or 0x3BA, or 
   0x3D4-0x3D5, or 0x3DA, then assert chip select for VGA space.
   MEM SPACE: If the cycle is in MEM space & PCI class bits are set to VGA,
   a) if vga_decode_a0_p is asserted,
   & host address is 0x000A-0000 to 0x000A_FFFF. OR
   b) if vga_decode_b0_p is asserted,
   & host address is 0x000B-0000 to 0x000B_7FFF. OR
   c) if vga_decode_b8_p is asserted,
   & host address is 0x000B-8000 to 0x000B_FFFF, then
   assert chip select for VGA space.
   ***************************************************************************/

  // synchronize the vga stuff just to be safe
  always @(posedge hb_clk) begin
    vga_decode_ctrl_s <= vga_decode_ctrl;
    fis_io_en_s       <= fis_io_en;
  end //
  
  always @* begin
    cs_vga_space_n = 1'b1;
    if (sys_reset_n==0 || ~vga_global_enable)
      cs_vga_space_n = 1'b1;
    else if (pci_class_config==VGA) begin
      if (pci_io_enable_p && cycle_type==IO && 
	  hb_lachd_addr[31:8] == 24'h3) begin //0000_03xx
	if (hb_lachd_addr[7:4] == 4'hc) begin //0000_03cx
	  if ((hb_lachd_addr[2:0] != 3'h3) && // != 3 or b
	      (hb_lachd_addr[3:1] != 3'h3) && // |= 6 or 7
	      (hb_lachd_addr[3:1] != 3'h4) && // != 8 or 9
	      (hb_lachd_addr[3:0] != 4'hd))   // != d
	    cs_vga_space_n = 1'b0;
	end // if (hb_lachd_addr[7:4] == 4'hc)
	else if ((!fis_io_en_s && (hb_lachd_addr[7:4] == 4'hb)) ||//0000_03bx, mono
		 (fis_io_en_s && (hb_lachd_addr[7:4] == 4'hd)))//0000_03dx, color
	begin
	  if ((hb_lachd_addr[3:1] == 3'h2) ||  // 4 or 5
	      (hb_lachd_addr[3:0] == 4'ha))
	    cs_vga_space_n = 1'b0;
	end // else: !if(hb_lachd_addr[7:4] == 4'hc)
      end // if (cycle_type==IO && hb_lachd_addr[31:8] == 24'h3)
      else if (cycle_type==MEM && pci_mem_enable_p && fis_vga_space_en)
      begin
	if ((vga_decode_ctrl_s[1:0]==2'h0 && hb_lachd_addr[31:17]==15'h5) ||
	    // 000a0000 - 000bffff   
	    (vga_decode_ctrl_s[1:0]==2'h1 && hb_lachd_addr[31:16]==16'h000a)  ||
	    // 000a0000 - 000affff 
	    (vga_decode_ctrl_s[1:0]==2'h2 && hb_lachd_addr[31:15]==17'h0_0016) ||
	    // 000b0000 - 000b7fff 
	    (vga_decode_ctrl_s[1:0]==2'h3 && hb_lachd_addr[31:15]==17'h0_0017))
	  // 000b8000 - 000bffff 
	  cs_vga_space_n = 1'b0;
      end
    end
  end
  
  /***************************************************************************
   Generate chip select VGA 3C6 IO block.
   This chip select is asserted only when there is IO cycle to 3C6-3C9
   ***************************************************************************/
  always @*
    if (sys_reset_n==0 || vga_3c6block_en_p==0)
      cs_3c6_block_n   = 1'b1;
    else if ((cycle_type==IO && pci_io_enable_p==1 && 
	      hb_lachd_addr[31:4]==28'h0000_03C) &&
	     (hb_lachd_addr[3:0] >= 4'h6 &&
	      hb_lachd_addr[3:0] <= 4'h9))
      cs_3c6_block_n   = 1'b0;
    else
      cs_3c6_block_n   = 1'b1;

  /****************************************************************************
   generating chip select hbi_regs 
   (asserted when any HBI register is addressed)
   ***************************************************************************/
  assign cs_hbi_regs_n =!((cs_blk_config_regs_un==0) || 
			  (cs_pci_config_regs_un==0) ||
			  (cs_global_intrp_reg_un==0) || 
			  (cs_window_regs_un==0) ||
			  (cs_draw_a_regs_un==0 && hbi_addr_in[8:3]==6'h00) ||
			  (cs_draw_a_regs_un==0 && hbi_addr_in[8:3]==6'h01) ||
			  (cs_draw_a_regs_un==0 && hbi_addr_in[8:3]==6'h02));

  /****************************************************************************
   generate chip select for any register in blackbird   
   ***************************************************************************/
  assign cs_blkbird_regs_n = !((cs_blk_config_regs_un==0)       ||
			       (cs_pci_config_regs_un==0)       ||
			       (cs_global_regs_un==0)           ||
			       (cs_global_intrp_reg_un==0)      ||
			       (cs_window_regs_un==0)           ||
			       (cs_draw_a_regs_un==0));
  
  /***************************************************************************
   generate chip select blackbird which indicates that one of the blackbird
   resources has been addressed
   ***************************************************************************/
  assign cs_blkbird_n = !(cs_blkbird_regs_n    ==0  ||
			  cs_xyw_a_n           ==0  ||
			  cs_mem0_n    ==0  ||
			  cs_mem1_n    ==0    );

  /***************************************************************************
   GENERATE CHIP SELECT WRITE SOFT SWITCHES
   NOTE: THE SOFT SWITCH HAS TWO ADDRESSES,
   IN IO SPACE IT IS ADDRESSED AT (RBASE_IO+0X0028), AND
   IN MEMORY SPACE IT IS ACCESSED AT ADDRESS (RBASE_I+0X0A8)
   ***************************************************************************/
  assign cs_sw_write_n =
	 !((cs_blk_config_inter_n==0 &&
	    hb_lachd_addr[7:2]==6'h0a && hb_lached_rdwr==WRITE) ||
	   (cs_global_intrp_reg_un==0 &&
	    hb_lachd_addr[7:2]==6'h2a && hb_lached_rdwr==WRITE));
  
  assign cs_soft_switchs_un=
	 !((cs_blk_config_inter_n==0 && hb_lachd_addr[7:2]==6'h0a) ||
	   (cs_global_intrp_reg_un==0 && hb_lachd_addr[7:2]==6'h2a));
  
  
  /***************************************************************************
   * generating chip select for the 2 registers in the pci write only master  
   * io space ex
   * rbase_i ex
   ***************************************************************************/
  assign cs_pci_wom = ((!cs_blk_config_regs_un || !cs_global_intrp_reg_un) &&
		       hb_lachd_addr[7:3]==5'h1c);
  
  // 0xDC for Serial Eprom access
  assign cs_serial_eprom = (pci_eprom_enable_p &
                            (!cs_blk_config_regs_un |
                             !cs_global_intrp_reg_un) &
                            hb_lachd_addr[7:2]==6'h37);


  /*
   * Synchronize a bunch of stuff to hb_clk rise
   */
  always @(posedge hb_clk) begin
    //SYNCHRONIZE CHIP SELECTS THAT GO TO REGISTERS
    cs_blk_config_regs_n  <= cs_blk_config_regs_un;
    cs_global_regs_n      <= cs_global_regs_un;
    cs_global_intrp_reg_n <= cs_global_intrp_reg_un;
    cs_window_regs_n      <= cs_window_regs_un;
    cs_draw_a_regs_n      <= cs_draw_a_regs_un;
    cs_pci_config_regs_n  <= cs_pci_config_regs_un;
    cs_soft_switchs_n     <= cs_soft_switchs_un;
  end

endmodule
 
