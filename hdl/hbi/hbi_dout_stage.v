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
//  Title       :  Host Bus Data Out stage
//  File        :  hbi_dout_stage.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   module to generates output blackbird data to the output pins & the module
//   also generates parity for the data bus & the byte enables bus
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

 module hbi_dout_stage 
   (
    input	       hb_clk,            // host bus clock
    input [31:0]       hb_regs_dout,      // all HBI registers bus output
    input [31:0]       hb_rcache_dout,    /* host bus data cache output 
					   * (either data cache or WID cache 
					   * output) */
    input [31:0]       hdat_out_crt_vga,  // all CRT registers bus output
    input [31:0]       draw_engine_a_dout,// 2D cache readback
    input [31:0]       draw_engine_reg,   // all DE registers bus output
    input	       cs_global_regs_n,  // global register is addressed.
    input	       cs_hbi_regs_n,     // HBI regsiters is been addressed.
    input              cs_xyw_a_n,        // 2D cache accessed
    input	       decoder_cs_windows_n, // memory windows is asserted
    input	       hb_lached_rdwr,    /* host bus read cycle in progress 
					   * signal when asserted, it 
					   * indicates that a host bus read 
					   * cycle is in progress (active low)
					   */
    input	       hbi_addr_in,       // host bus address bit
    input [3:0]        hb_byte_ens,       /* HBI UNLATCHED byte enables 
					   * directly from the PCI bus. */
    input	       irdy_n,            // host bus initiator ready signal
    input	       sys_reset_n,       // host bus system reset
    input	       trdy_n,            /* (BLACKBIRD) is ready to accept new
					   * data if the cycle is write, or
					   * target is ready to provide data 
					   * if the cycle is read */
    input [31:0]       perph_rd_dbus,     // read back perhpial data bus
    input	       cs_eprom_n,        /* chip select EPROM (the EPROM 
					   * present on the graphics board) */
    input	       cs_dac_space_n,    /* chip select VGA registers in 
					   * either I/O or MEM mode */
    input	       cs_vga_space_n,    /* chip select VGA space whenever 
					   * BLK board has VGA on board 
					   * (determined from the PCI class 
					   * configuration bits) */
					      input [2:0]  swizzler_ctrl,
    input	       any_trdy_async,    /* an "or" of all the async trdy 
					   * sources */
    input [31:0]       pci_ad_out,        // pci ad request data
    input	       pci_ad_oe,         // pci oe for write data
    input [3:0]        c_be_out,
    
    output reg [31:0]  blkbird_dout,      // data output bus to the outside
    output reg	       par32              /* even parity for the lower half of
					   * the data output bus */
    );
  
  reg 		 pci_ad_oe_reg;
  reg [31:0] 	 hb_data_swizzled;
  
  wire [31:0] 	 hb_regblock_dout;
  wire [31:0] 	 hb_read_data;
  wire [7:0] 	 hb_dat_b3, hb_dat_b2, hb_dat_b1, hb_dat_b0; 
  wire [7:0] 	 hb_dat_b7, hb_dat_b6, hb_dat_b5, hb_dat_b4; 
  wire		 be_par32;
  wire		 bkbrd_par32;
  wire		 lower_level_parity32;
  wire 		 be_out_par32;
  wire 		 pci_master_par32;

  parameter	 
		 READ    = 1'b0,
		 WRITE   = 1'b1;
  
  //                            DOUT_MUX
  // Block to multiplex data from all Blackbird modules into the data bus

  // OUTPUT  MUX SELECTING OUTPUT DATA BETWEEN BLKBIRD MODULES
  assign  hb_read_data =
	  // PERPH 
	  (!cs_eprom_n || !cs_dac_space_n) ? perph_rd_dbus :
	  // VGA & crt & video regsiters
	  (!cs_vga_space_n || !cs_global_regs_n) ?  hdat_out_crt_vga : 
	  // hb registers
	  (!cs_hbi_regs_n) ? hb_regs_dout :         
	  // hb data cache
	  (!decoder_cs_windows_n) ? hb_rcache_dout :
	  // 2D DE cache
	  (!cs_xyw_a_n) ? draw_engine_a_dout :
	  // Drawing Engine registers
	  draw_engine_reg;

  // SWIZZLER FOR THE READ DATA PATH
 
  assign  hb_dat_b3 = 
      (swizzler_ctrl[0]) ?
      {hb_read_data[24], hb_read_data[25], hb_read_data[26],
       hb_read_data[27], hb_read_data[28], hb_read_data[29],
       hb_read_data[30], hb_read_data[31]}                 :
	  hb_read_data[31:24];
 
   assign hb_dat_b2 =
      (swizzler_ctrl[0]) ?
      {hb_read_data[16], hb_read_data[17], hb_read_data[18],
       hb_read_data[19], hb_read_data[20], hb_read_data[21],
       hb_read_data[22], hb_read_data[23]}                 :
	  hb_read_data[23:16];
 
   assign hb_dat_b1 =
      (swizzler_ctrl[0]) ?
      {hb_read_data[8],  hb_read_data[9],  hb_read_data[10],
       hb_read_data[11], hb_read_data[12] ,hb_read_data[13],
       hb_read_data[14], hb_read_data[15]}                 :
	  hb_read_data[15:8];
 
   assign hb_dat_b0 =
      (swizzler_ctrl[0]) ?
      {hb_read_data[0], hb_read_data[1], hb_read_data[2],
       hb_read_data[3], hb_read_data[4], hb_read_data[5],
       hb_read_data[6],hb_read_data[7]}                    :
	  hb_read_data[7:0];
 
  always @*
    case (swizzler_ctrl[2:1])
      2'b00:
	hb_data_swizzled = { hb_dat_b3, hb_dat_b2, hb_dat_b1, hb_dat_b0};
      2'b01:
	hb_data_swizzled = { hb_dat_b2, hb_dat_b3, hb_dat_b0, hb_dat_b1};
      2'b10:
	hb_data_swizzled = { hb_dat_b1, hb_dat_b0, hb_dat_b3, hb_dat_b2};
      2'b11:
	hb_data_swizzled = { hb_dat_b0, hb_dat_b1, hb_dat_b2, hb_dat_b3};
    endcase // case(swizzler_ctrl[2:0])
    
  // PIPELINE THE OUTPUT DATA
  always @ (posedge hb_clk) begin
    //read cycle is active (in progress) thus allow data to flow through
    //if (hb_lached_rdwr==READ && ((any_trdy_async && trdy_n) ||
    //			   (!trdy_n && !irdy_n)))   
    if (any_trdy_async && (trdy_n || (!trdy_n && !irdy_n)))
      blkbird_dout <= hb_data_swizzled;

    else if (pci_ad_oe)
      blkbird_dout <= pci_ad_out;
    
  end
  
/*******************************************************************************
 *                         PARITY_GENERATOR
 * Block to generate EVEN PARITY for the the host bus read cycles & the
 * PCI master's write cycles as required by the PCI spec.
*******************************************************************************/
   always @(posedge hb_clk) pci_ad_oe_reg <= pci_ad_oe;
   
   assign be_par32 = ^hb_byte_ens[3:0];
   assign be_out_par32 = ^c_be_out[3:0]; //PCI master's CBEs 
   assign bkbrd_par32 = ^blkbird_dout;
   assign lower_level_parity32 = bkbrd_par32 ^ be_par32;//Parity for PCI slave

   assign pci_master_par32 = bkbrd_par32 ^ be_out_par32;//Parity for PCI master

  //Parity is clocked at the end of every beat(and that would delay
  //parity by one clock to comply with PCI spec.)
  always @(posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n) begin
      par32 <= 1'b0;
    end else if (pci_ad_oe_reg) begin
      par32 <= pci_master_par32;
    end else if (!trdy_n && !irdy_n) begin
      par32 <= lower_level_parity32; //current beat is done
    end 
  end
 


endmodule // HBI_DOUT_STAGE

