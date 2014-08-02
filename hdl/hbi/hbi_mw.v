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
//  Title       :  Memory Windows
//  File        :  hbi_mw.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   This block implements the memory window read and write caches, and yuv 
//   conversion.
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

  module hbi_mw
    (
     // from PCI
     input	    hb_clk,
     input 	    mclock,
     input	    hb_soft_reset_n,
     input	    frame_n,          // PCI FRAME#
     input	    sobn_n,           // start of burst
     input	    irdy_n,           // PCI IRDY#
     input [25:2]   hbi_mac,          // pci address, from counter
     input [31:0]   hbi_data_in,      // pci data, one flop from pin, swizzled
     input [3:0]    mw_be,            // pci byte enables, one flop, swizzled
     input	    hb_write,         // read(0)/write(1) indicator.
     
     // from REGBLOCK
     input	    cs_mem0_n,        // decode for window 0
     input	    cs_mem1_n,        // decode for window 0
     input [24:0]   mw0_ctrl_reg,     // memory win 0 control reg
     input [24:0]   mw1_ctrl_reg,     // memory win 1 control reg
     input [3:0]    mw0_sz,           // memory win 0 size reg
     input [3:0]    mw1_sz,           // memory win 1 size reg
     input [25:12]  mw0_org,          // memory win 0 origin reg
     input [25:12]  mw1_org,          // memory win 1 origin reg

     // from MC
     input	    hst_push,         // data strobe to load read cache
     input	    hst_pop,          // data strobe to select next location
     input [1:0]    hst_mw_addr,      // Memory window address for RAM
     input	    mc_ready_p,       // mc is ready to accept a command
     input [127:0]  pix_in_dbus,      // data bus from mc to read cache

     // from CRT
     input	    crt_vertical_intrp_n, // vertical interrupt
     input	    hbi_mwflush,      // any memory window ctrl register decode
     input	    cs_de_xy1_n,      // 2d trigger register decode
     input	    cs_dl_cntl,       // cache flush request from DLP
     
     // to PCI
     output [31:0]  hb_rcache_dout,   // readback data from mc, via read cache
     output	    window0_busy_n,   // status for polling
     output	    window1_busy_n,   // status for polling
     output	    mw_trdy,          // trdy, one flop from the pin
     output	    mw_stop,          // stop, one flop from the pin

     // to DLP
     output	    mw_dlp_fip,       // memory window write cache is dirty

     // to DE
     output	    mw_de_fip,        // flush initiated by DE trigger

     // to MC
     output [22:0]  linear_origin,    // memory address
     output [127:0] hb_pdo,  	      // memory data
     output [15:0]  mem_mask_bus,     // byte enables
     output	    read,             // memory read=1, write=0
     output	    hb_mc_request_p,   // request a memory cycle
     output         full
     );
     
  /*
   * wires
   */
  wire [3:0] 	    wc_be, wc_be_d;
  wire 		    clr_wc0;
  wire 		    clr_wc1;
  wire 		    ld_wc0;
  wire 		    ld_wc1;
  wire [2:0] 	    sub_buf_sel;
  wire [31:0] 	    pci_data;
  wire [7:0] 	    lut_v0_index;
  wire [7:0] 	    lut_u0_index;
  wire [9:0] 	    lut_v0;
  wire [9:0] 	    lut_v1;
  wire [9:0] 	    lut_u0;
  wire [9:0] 	    lut_u1;
  wire [3:0] 	    rcache_sel;
  wire 		    rst_rc_ptr;
  wire [2:0] 	    mw_dp_mode;
  wire 		    wcregs_addr;
  wire 		    wcregs_we;
  wire 		    mc_done;
  wire [1:0] 	    push_count;

  wire [3:0] 	    read_addr;
  wire 		    yuv_ycrcb;
  wire 		    select;        // select which half to write 422_32 to
  
  /*
   * Memory Window Control
   */
  hbi_mw_ctl U_MW_CTL
    (
     .hb_clk              (hb_clk),
     .hb_soft_reset_n     (hb_soft_reset_n),
     .frame_n             (frame_n),
     .sobn_n              (sobn_n),
     .irdy_n              (irdy_n),
     .hbi_mac             (hbi_mac),
     .mw_be               (mw_be),
     .hb_write            (hb_write),

     .cs_mem0_n           (cs_mem0_n),
     .cs_mem1_n           (cs_mem1_n),

     .mw0_ctrl_reg        (mw0_ctrl_reg),
     .mw1_ctrl_reg        (mw1_ctrl_reg),
     .mw0_sz              (mw0_sz),
     .mw1_sz              (mw1_sz),
     .mw0_org             (mw0_org),
     .mw1_org             (mw1_org),
     .mc_rdy              (mc_ready_p),
     .mc_done             (mc_done),

     .crt_vertical_intrp_n(crt_vertical_intrp_n),
     .hbi_mwflush         (hbi_mwflush),
     .cs_de_xy1_n         (cs_de_xy1_n),
     .cs_dl_cntl          (cs_dl_cntl),
     
     .window0_busy_n      (window0_busy_n),
     .window1_busy_n      (window1_busy_n),

     .mw_dlp_fip          (mw_dlp_fip),
     .mw_de_fip           (mw_de_fip),

     .mw_trdy             (mw_trdy),
     .mw_stop             (mw_stop),
     .linear_origin       (linear_origin),
     .mc_rw               (read),
     .mc_req              (hb_mc_request_p),
     .clr_wc0             (clr_wc0),
     .clr_wc1             (clr_wc1),
     .ld_wc0              (ld_wc0),
     .ld_wc1              (ld_wc1),
     .wcregs_addr         (wcregs_addr),
     .wcregs_we           (wcregs_we),
     .sub_buf_sel         (sub_buf_sel),

     .wc_be               (wc_be),
     .wc_be_d             (wc_be_d),

     .yuv_ycrcb           (yuv_ycrcb),
     .mw_dp_mode          (mw_dp_mode),
     .read_addr           (read_addr),
     .select_del          (select),
     .full                (full)
     );

  
  /*
   * Write Cache Registers
   */
  hbi_wcregs U_WCREGS
    (
     .hb_clk              (hb_clk),
     .hb_soft_reset_n     (hb_soft_reset_n),
     .pci_data            (pci_data),
     .wc_be               (wc_be),
     .wc_be_d             (wc_be_d),
     .clr_wc0             (clr_wc0),
     .clr_wc1             (clr_wc1),
     .ld_wc0              (ld_wc0),
     .ld_wc1              (ld_wc1),
     .wcregs_addr         (wcregs_addr),
     .wcregs_we           (wcregs_we),
     .sub_buf_sel         (sub_buf_sel),
     .mclock              (mclock),
     .hst_pop             (hst_pop),
     .hst_push            (hst_push),
     .hst_mw_addr         (hst_mw_addr),
     .select              (select),
     
     .hb_pdo              (hb_pdo),
     .hst_md              (mem_mask_bus),
     .mc_done             (mc_done),
     .push_count          (push_count)
     );

  /*
   * Read Cache Registers
   */
  ram_128_32x32_dp U_RCREGS
    (
     .data                (pix_in_dbus),
     .wren                (hst_push),
     .wraddress           (push_count),
     .wrclock             (mclock),
     .rdclock             (hb_clk),
     .rdaddress           (read_addr),
     .q                   (hb_rcache_dout)
     );

  /*
   * YUV to RGB Converter. Note bit-blasting of yuv_adr register.
   */
  hbi_yuv2rgb U_YUV2RGB
    (
     .hb_clk              (hb_clk),
     .hbi_din             (hbi_data_in),
     .mw_dp_mode          (mw_dp_mode),
     .lut_v0              (lut_v0),
     .lut_v1              (lut_v1),
     .lut_u0              (lut_u0),
     .lut_u1              (lut_u1),
     .ycbcr_sel_n         (yuv_ycrcb),
     .select              (select),
     
     .pci_data            (pci_data),
     .lut_u0_index        (lut_u0_index),
     .lut_v0_index        (lut_v0_index)
     );
  
  /*
   * V/Cr look-up table
   */
  hbi_lut_v U_LUTV0
    (
     .hb_clk              (hb_clk),
     .lut_v_index         (lut_v0_index[7:0]),
     
     .lut_v0_dout         (lut_v0[9:0]),
     .lut_v1_dout         (lut_v1[9:0])
     );

  /*
   * U/Cb look-up table
   */
  hbi_lut_u  U_LUTU0
    (
     .hb_clk              (hb_clk),
     .lut_u_index         (lut_u0_index[7:0]),
     
     .lut_u0_dout         (lut_u0[9:0]),
     .lut_u1_dout         (lut_u1[9:0])
     );

endmodule // HBI_MW
