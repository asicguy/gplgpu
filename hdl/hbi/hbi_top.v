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
//  Title       :  Host Bus Top Level
//  File        :  hbi_top.v
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

  module hbi_top
    (
     input [1:0] devid_sel,
     // inputs
     input	 hb_clk,            /* PCI: hb clock driver      */
     input 	 mclock,            // Memory Controller Clock
     input       vga_mclock,        // VGA Memory Controller clock
     input	 hreset_in_n,       /* PCI: reset buffer         */
     input [31:0]hb_ad_bus,         /* PCI: address/data         */
     input [3:0] hb_byte_ens,       /* PCI: byte enables         */
     input	 idsel,             /* PCI: initial device sel   */
     input	 frame_n,           /* PCI: frames a transaction */
     input	 irdy_n,            /* PCI: initiator ready      */
     input [2:0] cmd_hdf,           /* DE: host data format, used in swizz cntrl   */
     input	 de_ca_busy,        /* DE: cache busy signal, to reg_block */  
     input	 dda_int_tog,       /* DE: drawing done interrupt pulse */
     input	 cla_int_tog,       /* DE: clipping interrupt pulse     */
     input	 clp_a,	            /* DE: last command was clipped*/
     input	 deb_a,             /* DE: drawing engine busy.         */
     input [31:0]draw_engine_a_dout,/* DE: host bus read back data      */
     input [31:0]draw_engine_reg,   // DE: Register readback data
     input	 de_pipeln_activ,   /* DE: pipeline has data in it      */
     input	 vga_mem_last,    /* MC: vga memory cycle finished                */
     input	 vga_mem_rdy,     /* MC: memory cntrlr ready to accept vga request*/
     input	 mcb,             /* MC: Memory controller performing DE request  */
     input	 vb_int_tog,        /* CRT: vertical blanking interrupt   */
     input	 hb_int_tog,        /* CRT: horozontal blanking interrupt */
     input [31:0]hdat_out_crt_vga,     /* CRT: CRT register for HB readback  */
     input [1:0] vga_decode_ctrl,   /* Khatmandu's CTL_BITS[1:0],see spec */ 
     input	 fis_io_en,	    /* Khatmandu's CTL_BITS[5], see spec   */
     input	 dlp_retry,         /* PREPROC: both sets DE regs full, force retry */
     input	 busy_a,	           /* PREPROC: Drawing engine busy to host */
     input	 ddc1_dat_0,          /* PIN 77  from monitor? */
     input	 ddc_clk_in_0,        /* PIN 175 from monitor? */
     input	 ddc1_dat_1,          /* PIN 77  from monitor? */
     input	 ddc_clk_in_1,        /* PIN 175 from monitor? */
     input [7:0] pd_in,              /* data in from peripherals */
     input [31:0]config_bus,        /* DIN_MUX: Configuration data for HBI */
     input	 hst_push,        // "push" data from mc to hb
     input	 hst_pop,         // "pop" data from hb to mc, sync version coming
     input [1:0] hst_mw_addr,     // MW address selector for RAM
     input	 mc_ready_p,           // mc ready for new request
     input [127:0] pix_in_dbus,          // data bus from mc to hb
     input	 crt_vertical_intrp_n, // vertical sync interrupt
     input [7:0] soft_switch_in,
     input [31:0]pci_ad_out,      // pci ad request/data
     input	 pci_ad_oe,       // pci oe for write data
     input [7:0] idac_data_in,  // internal dac data into peripheral controller
     input [3:0] c_be_out,      // From bus master
     input       vga_mode,
     input       bios_rdat,	 // Serial BIOS read data.
     input       m66_en,	 // Enable 66MHz PCI.
     
     // outputs
     output	 hb_soft_reset_n,    /* reset to all modules except HBI */
     output	 dac_reset_n,        /* reset to the internal dac */
     output	 hb_cycle_done_n,    /* (frame_n && !irdy_n && (!trdy_n || !stop_n)) */
     output	 sobn_n,             /* "start of burst indicator" */
     output	 ddc1_dat2_0,        /* to top_level inv. then to DDC pin OE */ 
     output	 ddc1_dat2_1,        /* to top_level inv. then to DDC pin OE */ 
     output [13:2] hbi_addr_in_p1,        /* PCI incrementing addr */
     output [8:2]  hbi_addr_in_p2,        /* PCI incrementing addr */
     output [31:0] hbi_data_in,        /* PCI data piped */
     output [3:0]  hbi_be_in,          /* PCI byte ens piped */
     output	   hb_write,           /* PCI Latched Command bit 0         */
     output	   trdy_n,             /* PCI TRDY_N                        */
     output	   stop_n,             /* PCI STOP_N                        */
     output	   ctrl_oe_n,          /* PCI TRDY_N & STOP_N output enable */
     output	   devsel_n,           /* PCI DEVSEL_N                */
     output	   devsel_oe_n,        /* PCI DEVSEL_N  output enable */
     output	   par32_out,          /* PCI PAR               */
     output	   par32_oe_n,         /* PCI PAR output enable */
     output        ad_oe32_n,          // AD enables, lower 32 bits
     output        c_be_oe_n,         /* C/BE 0 output enable */   
     output [31:0] blkbird_dout,       /* PCI data out */
     output	   interrupt_cnt,      /* PCI, this becomes the oe for the int pin */
     output	   interrupt_in,       /* PCI, Interrupt, pin 272 */
     
     output	   cs_xyw_a_n,         /* DE: chip select XY memory window  */
     
     output	   wr_en_p1,              /* write enable port 1 */
     output	   wr_en_p2,              /* write enable port 2 */
     output	   cs_draw_a_regs_n,   /* PREPROC: chip select drawing registers */
     output	   vga_mem_req,        /* MC: host bus vga space mem req */
     output [1:0]  dden,               /* MC: display density */  
     output [3:0]  cfg_reg2_mc,        /* MC: from CONFIG2 */
     output [1:0]  cfg_reg2_ref_cnt,   /* MC: refresh rate code */
     output	   cfg_reg2_cn,
     output	   cfg_reg2_rcd,
     output	   cfg_reg2_jv,
     output	   cfg_reg2_sgr,  
     output	   cfg_reg2_tr,        /* MC: RAS pulse length control */
//     output [7:0]  vga_ctrl_dout,      /* VGA: gets [6:5] others to CRT and top*/
     output        ldi_2xzoom,         // 2x zoom for flatpanels
     output [22:0] vga_laddr,          /* VGA: latched PCI address */
     output [31:0] vga_ldata,          /* VGA: latched PCI data */
     output [3:0]  vga_lbe,            /* VGA: latched PCI byte enables   */
     output	   vga_rdwr,           /* VGA: latched PCI cmd[0] 1=write */
     output	   vga_mem_io,         /* VGA: encoded mem or io cycle */   
     output	   ddc1_clk_0,           /* CRT: and top */
     output	   ddc1_en_0,            /* CRT: */
     output	   ddc1_clk_1,           /* CRT: and top */
     output	   ddc1_en_1,            /* CRT: */
     output	   cs_global_regs_n,   /* CRT: chip select */  
     output [22:0] linear_origin,      // address to mc
     output [127:0]hb_pdo,    	       // data to mc
     output [15:0] mem_mask_bus,       // byte enables to mc
     output	   read,               // read/write to mc
     output	   hb_mc_request_p,    // access request to mc
     output	   pci_mstr_en,     // enable the pci master function
     output [4:0]  flow_reg,
     output [31:2] pci_wr_addr, 
     output [21:0] pcim_masks,
     output	   de_pl_busy,
     output [15:0] pa,       // peripheral address bus      
     output [7:0]  pd_out,   // peripheral data out    
     output [1:0]  pwr_n,    // peripheral write (DAC)
     output [1:0]  prd_n,    // peripheral read (DAC)
     output	   pcs_n,    // peripheral chip select (EPROM)
     output	   poe_n,    // peripheral output enable (EPROM)
     output	   pwe_n,    // peripheral write enable (EPROM)
     output	   psft,     // peripheral soft switch load pulse
     output	   pd_oe_n,  // peripheral data bus oe 
     output	   idac_wr,  // internal DAC write                             
     output	   idac_rd,  // internal DAC read
     output	   cfg_reg2_ide,  // internal DAC enable	 
     output	   mw_de_fip, // mw telling de that a flush is in progress.
     output	   mw_dlp_fip,// mw telling dlp that cache is flushing
     output	   enable_rbase_e_p, // controls 2 muxes at sh_top.
     output [1:0]  se_clk_sel,    // selects an se_clk source in agp_pll
     output [31:0] hb_ldata,
     output [7:0] soft_switch_out,
     output 	  full,
     output       bios_clk,
     output       bios_hld,
     output       bios_csn,
     output       bios_wdat
     );

  wire [31:0]	 hb_laddr, perph_ldata;
  wire [31:2]	 hbi_addr_in;
  wire [25:2]	 hbi_mac;
  wire [20:0]	 perph_laddr;
  wire [3:0]	 hb_lcmd, perph_lcmd, perph_lbe;
  wire [3:0]	 dac_addr;
  wire [3:0]	 mw0_sz_dout, mw1_sz_dout;
  wire [7:0]	 perph_dout;
  wire [2:0]	 swizzler_ctrl;
  wire [2:0]	 cfg_reg2_dws;
  wire [3:0]	 cfg_reg2_ews;
  wire [24:0]	 mw0_ctrl_dout, mw1_ctrl_dout;
  wire [31:8]	 rbase_w_dout, rbase_i_dout, rbase_g_dout;
  wire [31:9]	 rbase_a_dout;
  wire [31:16]	 rbase_e_dout;
  wire [23:0]	 base_addr_reg5;
  wire [31:0]	 hb_regs_dout;
  wire [31:12]	 xyw_a_dout;   
  wire [31:12]	 mw0_ad_dout, mw1_ad_dout;
  wire [25:12]	 mw0_org_dout, mw1_org_dout;
  wire [31:0]	 hb_rcache_dout;
  wire [3:0]	 mw_be;
  wire [15:0]	 per_org;
  wire [31:0]	 perph_rd_dbus;
  wire 		 mw_stop;
  wire 		 cs_draw_stop_n;
  wire 		 cs_de_xy1_n;
  wire 		 cs_mem0_n, cs_mem1_n;
  wire 		 cs_pci_wom;
  wire 		 cs_serial_eprom;
  wire [3:0]	 sepm_cmd;
  wire [18:0]	 sepm_addr;
  wire           sepm_busy, clr_sepm_busy;
  wire 		 cs_eprom_n;
  wire 		 cs_pci_config_regs_n;
  wire 		 cs_blkbird_n;
  wire 		 cs_blkbird_regs_n;
  wire 		 cs_hbi_regs_n;
  wire 		 cs_dl_cntl;
  wire 		 cs_global_intrp_reg_n;
  wire 		 cs_windows_n;
  wire 		 soft_reset_p;
  wire 		 dac_soft_reset;
  wire 		 cs_vga_shadow_n;
  wire 		 cs_soft_switchs_un;
  wire 		 cs_sw_write_n;
  wire 		 cs_vga_space_n;
  wire 		 cs_3c6_block_n;
  wire 		 cs_draw_a_regs_un;
  wire 		 cs_dereg_f8_n;
  wire 		 vga_palette_snoop_n;
  wire 		 per_mem_rdy;
  wire 		 per_mem_done;
  wire 		 mw_trdy;
  wire 		 cs_window_regs_un;
  wire 		 cs_blk_config_regs_un;
  wire 		 window0_busy_n;
  wire 		 window1_busy_n;
  wire 		 sys_reset_n;
  wire 		 addr_strobe_n;
  wire 		 data_strobe_n;
  wire 		 wr_en;
  wire 		 vga_data_strobe_n;
  wire 		 per_mem_req;
  wire 		 perph_data_strobe_n;
  wire 		 any_trdy_async;
  wire 		 hbi_mwflush;
  wire 		 cs_dac_space_n;
  wire 		 hb_lidsel;
  wire 		 perph_lbe_f;
  wire 		 perph_rdwr;
  wire 		 cs_blk_config_regs_n;
  wire 		 cs_window_regs_n;
  wire 		 cs_soft_switchs_n;
  wire 		 enable_rbase_a_p;
  wire 		 enable_rbase_g_p;
  wire 		 enable_rbase_i_p;
  wire 		 enable_rbase_w_p;
  wire 		 enable_mem_window0_p;
  wire 		 enable_mem_window1_p;
  wire 		 enable_xy_de_a_p;
  wire 		 pci_io_enable_p;
  wire 		 pci_mem_enable_p;
  wire 		 pci_eprom_enable_p;
  wire 		 pci_class_config;
  wire 		 vga_global_enable;
  wire 		 fis_vga_space_en;
  wire 		 vga_3c6block_en_p;
  
  // rename cmd bit 0 to the write indicator
  assign 	 hb_write = hb_lcmd[0];

  hbi_control U_HB_CTRL
    (
     // inputs
     .hb_clk                        (hb_clk),  
     .hb_system_reset_n             (hreset_in_n),
     .vga_mclock                    (vga_mclock),
     .soft_reset_p                  (soft_reset_p),
     .dac_soft_reset                (dac_soft_reset),
     .frame_n                       (frame_n),
     .irdy_n                        (irdy_n),
     .hb_lcmd                       (hb_lcmd),
     .hb_laddr                      (hb_laddr[1:0]),
     .cs_vga_shadow_n               (cs_vga_shadow_n),
     .cs_eprom_n                    (cs_eprom_n),
     .cs_blkbird_n                  (cs_blkbird_n),
     .cs_soft_switchs_un            (cs_soft_switchs_un),
     .cs_sw_write_n                 (cs_sw_write_n),
     .cs_vga_space_n                (cs_vga_space_n),
     .cs_3c6_block_n                (cs_3c6_block_n),
     .cs_blkbird_regs_n             (cs_blkbird_regs_n),
     .cs_draw_stop_n                (cs_draw_stop_n),
     .cs_draw_a_regs_n              (cs_draw_a_regs_n),
     .cs_draw_a_regs_un             (cs_draw_a_regs_un),
     .cs_xyw_a_n                    (cs_xyw_a_n),
     .cs_dereg_f8_n                 (cs_dereg_f8_n),
     .cs_de_xy1_n                   (cs_de_xy1_n),
     .cs_mem0_n                     (cs_mem0_n),
     .cs_mem1_n                     (cs_mem1_n),
     .vga_palette_snoop_n           (vga_palette_snoop_n),
     .perph_mem_rdy                 (per_mem_rdy),
     .perph_mem_last                (per_mem_done),
     .vga_mem_last                  (vga_mem_last),
     .vga_mem_rdy                   (vga_mem_rdy),
     .busy_a_dout                   (busy_a),       
     .dlp_retry                     (dlp_retry),
     .hb_ad_bus                     (hb_ad_bus[31:2]),                     
     .mw_trdy                       (mw_trdy),
     .mw_stop                       (mw_stop),
     .pci_ad_oe                     (pci_ad_oe),
     .cs_window_regs_un             (cs_window_regs_un),
     .cs_blk_config_regs_un         (cs_blk_config_regs_un),
     .mw0_busy_n                    (window0_busy_n),
     .mw1_busy_n                    (window1_busy_n),
     .cs_dl_cntl                    (cs_dl_cntl),
     
     .sys_reset_n                   (sys_reset_n),
     .hb_soft_reset_n               (hb_soft_reset_n),
     .dac_reset_n                   (dac_reset_n),
     .ctrl_oe_n                     (ctrl_oe_n), 
     .devsel_n                      (devsel_n),
     .devsel_oe_n                   (devsel_oe_n),  
     .parity32_oe_n                 (par32_oe_n),      
     .ad_oe32_n                     (ad_oe32_n),
     .c_be_oe32_n                   (c_be_oe_n),
     .trdy_n                        (trdy_n),
     .stop_n                        (stop_n),
     .addr_strobe_n                 (addr_strobe_n),
     .data_strobe_n                 (data_strobe_n),
     .sobn_n                        (sobn_n),
     .wr_en_hb                      (wr_en),
     .wr_en_p1                      (wr_en_p1),
     .wr_en_p2                      (wr_en_p2),
     .vga_mem_req                   (vga_mem_req),
     .vga_data_strobe_n             (vga_data_strobe_n),
     .perph_mem_req                 (per_mem_req),
     .perph_data_strobe_n           (perph_data_strobe_n),
     .hb_cycle_done_n               (hb_cycle_done_n),
     .hbi_addr_in_hb                (hbi_addr_in),
     .hbi_addr_in_p1                (hbi_addr_in_p1),
     .hbi_addr_in_p2                (hbi_addr_in_p2),
     .hbi_mac                       (hbi_mac),     
     .any_trdy_async                (any_trdy_async),
     .hbi_mwflush                   (hbi_mwflush)
     );
  
  hbi_addr_data U_HB_AD
    (
     .hb_clk                        (hb_clk),
     .sys_reset_n                   (sys_reset_n),
     .hb_ad_bus                     (hb_ad_bus),
     .hb_byte_ens                   (hb_byte_ens),
     .addr_strobe_n                 (addr_strobe_n),
     .data_strobe_n                 (data_strobe_n),
     .idsel_p                       (idsel),
     .perph_data_strobe_n           (perph_data_strobe_n),
     .vga_data_strobe_n             (vga_data_strobe_n),
     .cs_dac_space_n                (cs_dac_space_n),
     .cs_eprom_n                    (cs_eprom_n),
     .mw0_ctrl_dout                 (mw0_ctrl_dout[11:9]),
     .mw1_ctrl_dout                 (mw1_ctrl_dout[11:9]),
     .cmd_hdf                       (cmd_hdf),
     .cs_mem0_n                     (cs_mem0_n),
     .cs_mem1_n                     (cs_mem1_n),
     .cs_xyw_a_n                    (cs_xyw_a_n),
     .hb_cycle_done_n               (hb_cycle_done_n),

     .hb_ldata                      (hb_ldata),
     .hb_laddr                      (hb_laddr),
     .hb_lcmd                       (hb_lcmd),
     .hb_lidsel                     (hb_lidsel),
     .vga_laddr                     (vga_laddr),
     .vga_ldata                     (vga_ldata),
     .vga_lbe                       (vga_lbe),
     .vga_rdwr                      (vga_rdwr),
     .vga_mem_io                    (vga_mem_io),
     .perph_lbe_f                   (perph_lbe_f),
     .perph_rdwr                    (perph_rdwr),
     .perph_dout                    (perph_dout),
     .hbi_data_in                   (hbi_data_in),
     .hbi_be_in                     (hbi_be_in),
     .mw_be                         (mw_be),
     .swizzler_ctrl                 (swizzler_ctrl), 
     .per_origin                    (per_org) 
     );
  
  hbi_regblock U_HB_RGBLK
    (
     .devid_sel                     (devid_sel),
     .hb_clk                        (hb_clk),
     .hbi_addr_in                   (hbi_addr_in[8:2]),
     .hbi_data_in                   (hbi_data_in),
     .hbi_byte_en_in                (hbi_be_in),
     .wr_en                         (wr_en),
     .config_bus                    (config_bus),
     .sys_reset_n                   (sys_reset_n),
     .cs_blk_config_regs_n          (cs_blk_config_regs_n),
     .cs_global_intrp_reg_n         (cs_global_intrp_reg_n),
     .cs_window_regs_n              (cs_window_regs_n),
     .cs_draw_a_regs_n              (cs_draw_a_regs_n),
     .cs_pci_config_regs_n          (cs_pci_config_regs_n),
     .cs_soft_switchs_n             (cs_soft_switchs_n), 
     .vb_int_tog                    (vb_int_tog),
     .hb_int_tog                    (hb_int_tog),
     .dda_int_tog                   (dda_int_tog),
     .cla_int_tog                   (cla_int_tog),
     .clp_a                         (clp_a), 
     .deb_a                         (deb_a),
     .de_ca_busy                    (de_ca_busy),
     .de_pipeln_activ               (de_pipeln_activ), 
     .mcb                           (mcb),
     .busy_a                        (busy_a),
     .window0_busy_n                (window0_busy_n),
     .window1_busy_n                (window1_busy_n),
     .ddc1_dat_0                    (ddc1_dat_0),
     .ddc_clk_in_0                  (ddc_clk_in_0),
     .ddc1_dat_1                    (ddc1_dat_1),
     .ddc_clk_in_1                  (ddc_clk_in_1),
     .cs_pci_wom                    (cs_pci_wom),
     .cs_serial_eprom               (cs_serial_eprom),
     .soft_switch_in                (soft_switch_in),     
     .vga_en                        (vga_mode),
     .hb_soft_reset_n               (hb_soft_reset_n),
     .clr_sepm_busy                 (clr_sepm_busy),
     .m66_en                 	    (m66_en),
     
     .soft_reset_p                  (soft_reset_p),
     .dac_soft_reset                (dac_soft_reset),   
     .rbase_a_dout                  (rbase_a_dout),
     .rbase_e_dout                  (rbase_e_dout), 
     .rbase_g_dout                  (rbase_g_dout),
     .rbase_i_dout                  (rbase_i_dout),
     .rbase_w_dout                  (rbase_w_dout),
     .enable_rbase_a_p              (enable_rbase_a_p),
     .enable_rbase_e_p              (enable_rbase_e_p), 
     .enable_rbase_g_p              (enable_rbase_g_p),
     .enable_rbase_i_p              (enable_rbase_i_p),
     .enable_rbase_w_p              (enable_rbase_w_p),
     .enable_mem_window0_p          (enable_mem_window0_p),
     .enable_mem_window1_p          (enable_mem_window1_p),
     .enable_xy_de_a_p              (enable_xy_de_a_p),
     .mw0_ctrl_dout                 (mw0_ctrl_dout),
     .mw0_ad_dout                   (mw0_ad_dout),
     .mw0_sz_dout                   (mw0_sz_dout),
     .mw0_org_dout                  (mw0_org_dout),
     .mw1_ctrl_dout                 (mw1_ctrl_dout),
     .mw1_ad_dout                   (mw1_ad_dout),
     .mw1_sz_dout                   (mw1_sz_dout),
     .mw1_org_dout                  (mw1_org_dout),
     .xyw_a_dout                    (xyw_a_dout),
     .hb_regs_dout                  (hb_regs_dout),
     .interrupt_in                  (interrupt_in),
     .interrupt_cnt                 (interrupt_cnt),
     .pci_io_enable_p               (pci_io_enable_p),
     .pci_mem_enable_p              (pci_mem_enable_p),
     .pci_eprom_enable_p            (pci_eprom_enable_p),
     .base_addr_reg5                (base_addr_reg5),
     .pci_class_config              (pci_class_config),
     .ddc1_clk_0                    (ddc1_clk_0),
     .ddc1_en_0                     (ddc1_en_0),
     .ddc1_dat2_0                   (ddc1_dat2_0),
     .ddc1_clk_1                    (ddc1_clk_1),
     .ddc1_en_1                     (ddc1_en_1),
     .ddc1_dat2_1                   (ddc1_dat2_1),
     .dden                          (dden),
     .cfg_reg2_mc                   (cfg_reg2_mc),
     .cfg_reg2_dws                  (cfg_reg2_dws),
     .cfg_reg2_ews                  (cfg_reg2_ews),
     .cfg_reg2_cn                   (cfg_reg2_cn),
     .cfg_reg2_ref_cnt              (cfg_reg2_ref_cnt),
     .cfg_reg2_rcd                  (cfg_reg2_rcd),
     .cfg_reg2_jv                   (cfg_reg2_jv),
     .cfg_reg2_tr                   (cfg_reg2_tr),
     .cfg_reg2_sgr                  (cfg_reg2_sgr),
     .cfg_reg2_ide                  (cfg_reg2_ide),
     .vga_palette_snoop_n           (vga_palette_snoop_n),
     .vga_global_enable             (vga_global_enable),
//     .vga_ctrl_dout                 (vga_ctrl_dout),
     .ldi_2xzoom                    (ldi_2xzoom),
     .fis_vga_space_en              (fis_vga_space_en),
     .vga_3c6block_en_p             (vga_3c6block_en_p),
     .pci_mstr_en                   (pci_mstr_en), 
     .de_pl_busy                    (de_pl_busy),
     .flow_reg                      (flow_reg),
     .pci_wr_addr                   (pci_wr_addr), 
     .pcim_masks                    (pcim_masks),
     .se_clk_sel                    (se_clk_sel),
     .soft_switch_out               (soft_switch_out),
     .sepm_cmd                      (sepm_cmd),
     .sepm_addr                     (sepm_addr),
     .sepm_busy                     (sepm_busy)
     );
  
  hbi_addr_decoder U_HB_ADR_DEC
    (
     .hb_clk                        (hb_clk),
     .hb_lachd_addr                 (hb_laddr),
     .hbi_addr_in                   (hbi_addr_in[31:3]),
     .hb_lachd_cmd                  (hb_lcmd), 
     .sys_reset_n                   (sys_reset_n),
     .base_addr_reg5                (base_addr_reg5),
     .rbase_e_dout                  (rbase_e_dout),
     .rbase_g_dout                  (rbase_g_dout),
     .rbase_w_dout                  (rbase_w_dout),
     .rbase_a_dout                  (rbase_a_dout),
     .rbase_i_dout                  (rbase_i_dout),
     .enable_rbase_g_p              (enable_rbase_g_p),
     .enable_rbase_w_p              (enable_rbase_w_p),
     .enable_rbase_a_p              (enable_rbase_a_p),
     .enable_rbase_i_p              (enable_rbase_i_p),
     .enable_rbase_e_p              (enable_rbase_e_p),
     .enable_mem_window0_p          (enable_mem_window0_p),
     .enable_mem_window1_p          (enable_mem_window1_p),
     .enable_xy_de_a_p              (enable_xy_de_a_p),
     .mw0_ad_dout                   (mw0_ad_dout),
     .mw0_sz_dout                   (mw0_sz_dout),
     .mw1_ad_dout                   (mw1_ad_dout),
     .mw1_sz_dout                   (mw1_sz_dout),
     .pci_eprom_enable_p            (pci_eprom_enable_p),
     .pci_io_enable_p               (pci_io_enable_p),
     .pci_mem_enable_p              (pci_mem_enable_p),
     .pci_class_config              (pci_class_config),
     .lachd_idsel_p                 (hb_lidsel), 
     .fis_vga_space_en              (fis_vga_space_en),
     .fis_io_en                     (fis_io_en),
     .vga_decode_ctrl               (vga_decode_ctrl),
     .vga_global_enable             (vga_global_enable),
     .vga_3c6block_en_p             (vga_3c6block_en_p),
     .xyw_a_dout                    (xyw_a_dout),
     .hbi_mac                       (hbi_mac[8:2]),
     
     .cs_mem0_n                     (cs_mem0_n),
     .cs_mem1_n                     (cs_mem1_n),
     .cs_windows_n                  (cs_windows_n), 
     .cs_window_regs_n              (cs_window_regs_n),
     .cs_window_regs_un             (cs_window_regs_un),
     .cs_global_regs_n              (cs_global_regs_n),
     .cs_global_intrp_reg_n         (cs_global_intrp_reg_n),
     .cs_draw_a_regs_n              (cs_draw_a_regs_n),
     .cs_draw_a_regs_un             (cs_draw_a_regs_un),
     .cs_dereg_f8_n                 (cs_dereg_f8_n),
     .cs_dl_cntl                    (cs_dl_cntl),
     .cs_xyw_a_n                    (cs_xyw_a_n),
     .cs_hbi_regs_n                 (cs_hbi_regs_n),
     .cs_blkbird_n                  (cs_blkbird_n),
     .cs_blkbird_regs_n             (cs_blkbird_regs_n),
     .cs_blk_config_regs_n          (cs_blk_config_regs_n),
     .cs_blk_config_regs_un         (cs_blk_config_regs_un),
     .cs_draw_stop_n                (cs_draw_stop_n), 
     .cs_pci_config_regs_n          (cs_pci_config_regs_n),
     .cs_eprom_n                    (cs_eprom_n),
     .cs_sw_write_n                 (cs_sw_write_n),
     .cs_soft_switchs_n             (cs_soft_switchs_n),
     .cs_soft_switchs_un            (cs_soft_switchs_un),
     .cs_vga_space_n                (cs_vga_space_n),
     .cs_vga_shadow_n               (cs_vga_shadow_n),
     .cs_3c6_block_n                (cs_3c6_block_n),
     .cs_dac_space_n                (cs_dac_space_n),
     .cs_de_xy1_n                   (cs_de_xy1_n),
     .cs_pci_wom                    (cs_pci_wom),
     .cs_serial_eprom               (cs_serial_eprom)
     );
  
  hbi_dout_stage U_HB_DOUT 
    (
     .hb_clk                        (hb_clk),
     .hb_regs_dout                  (hb_regs_dout),
     .hb_rcache_dout                (hb_rcache_dout),
     .hb_lached_rdwr                (hb_lcmd[0]),
     .hbi_addr_in                   (hbi_addr_in[2]),
     .hb_byte_ens                   (hb_byte_ens),
     .sys_reset_n                   (sys_reset_n),
     .irdy_n                        (irdy_n),
     .trdy_n                        (trdy_n),
     .cs_eprom_n                    (cs_eprom_n),
     .cs_dac_space_n                (cs_dac_space_n),
     .cs_vga_space_n                (cs_vga_space_n),
     .cs_global_regs_n              (cs_global_regs_n),
     .cs_hbi_regs_n                 (cs_hbi_regs_n),  
     .cs_xyw_a_n                    (cs_xyw_a_n),
     .hdat_out_crt_vga              (hdat_out_crt_vga),
     .decoder_cs_windows_n          (cs_windows_n),  
     .draw_engine_a_dout            (draw_engine_a_dout),
     .draw_engine_reg               (draw_engine_reg),
     .perph_rd_dbus                 (perph_rd_dbus),
     .swizzler_ctrl                 (swizzler_ctrl),
     .any_trdy_async                (any_trdy_async),
     .pci_ad_out                    (pci_ad_out),
     .pci_ad_oe                     (pci_ad_oe),
     .c_be_out                      (c_be_out),
     
     .blkbird_dout                  (blkbird_dout),
     .par32                         (par32_out)
     );
   
  hbi_mw U_HB_MW
    (
     .hb_clk                        (hb_clk),
     .mclock                        (mclock),
     .hb_soft_reset_n               (hb_soft_reset_n),
     .frame_n                       (frame_n),
     .sobn_n                        (sobn_n),
     .irdy_n                        (irdy_n),
     .hbi_mac                       (hbi_mac),
     .hbi_data_in                   (hbi_data_in),
     .mw_be                         (mw_be),
     .hb_write                      (hb_write),
     .cs_mem0_n                     (cs_mem0_n),
     .cs_mem1_n                     (cs_mem1_n),
     .mw0_ctrl_reg                  (mw0_ctrl_dout),
     .mw1_ctrl_reg                  (mw1_ctrl_dout),
     .mw0_sz                        (mw0_sz_dout),
     .mw1_sz                        (mw1_sz_dout),
     .mw0_org                       (mw0_org_dout),
     .mw1_org                       (mw1_org_dout),
     .hst_push                      (hst_push),
     .hst_pop                       (hst_pop),
     .hst_mw_addr                   (hst_mw_addr),
     .mc_ready_p                    (mc_ready_p),
     .pix_in_dbus                   (pix_in_dbus),
     .crt_vertical_intrp_n          (crt_vertical_intrp_n),
     .hbi_mwflush                   (hbi_mwflush),
     .cs_de_xy1_n                   (cs_de_xy1_n),
     .cs_dl_cntl                    (cs_dl_cntl),
     
     .hb_rcache_dout                (hb_rcache_dout),
     .window0_busy_n                (window0_busy_n),
     .window1_busy_n                (window1_busy_n),
     .mw_trdy                       (mw_trdy),
     .mw_stop                       (mw_stop),
     .mw_dlp_fip                    (mw_dlp_fip),
     .mw_de_fip                     (mw_de_fip),
     .linear_origin                 (linear_origin),
     .hb_pdo               	    (hb_pdo),
     .mem_mask_bus                  (mem_mask_bus),
     .read                          (read),
     .hb_mc_request_p               (hb_mc_request_p),
     .full                          (full)
     );

  
  hbi_per U_HBI_PER
    (
     .reset                         (hb_soft_reset_n),
     .hclock                        (hb_clk),
     .per_req                       (per_mem_req),
     .per_read                      (perph_rdwr),
     .per_dac                       (cs_dac_space_n),
     .per_prom                      (cs_eprom_n),
     .per_org                       (per_org),
     .per_data_wr                   (perph_dout),
     .dac_wait                      (cfg_reg2_dws),
     .prom_wait                     (cfg_reg2_ews),
     .bios_rdat                     (bios_rdat),
     .idac_data_in                  (idac_data_in),
     .idac_en                       (cfg_reg2_ide),
     .aux_data_in                   (pd_in),
     .per_lbe_f                     (perph_lbe_f),
     .ser_parn                      (1'b1),
     .idac_wr                       (idac_wr),
     .idac_rd                       (idac_rd),     
     .per_ready                     (per_mem_rdy), 
     .per_done                      (per_mem_done), 
     .per_data_rd                   (perph_rd_dbus),
     .aux_addr                      (pa),           
     .aux_data_out                  (pd_out),           
     .aux_dac_wr                    (pwr_n),  // top level pin: PP_WRn - 
     .aux_dac_rd                    (prd_n),  // top level pin: PP_RDn
     .aux_prom_cs                   (pcs_n),  // top level pin: FPCSn       
     .aux_prom_oe                   (poe_n),
     .aux_prom_we                   (pwe_n),
     .aux_ld_sft                    (psft),    // top level pin: LD_SFT - PSFT
     .aux_buff_en                   (pd_oe_n), // top wire: WDAT_OEN - pd_oe_n
     .sepm_addr                     (sepm_addr),
     .sepm_cmd                      (sepm_cmd),
     .sepm_busy                     (sepm_busy),
     .clr_sepm_busy                 (clr_sepm_busy),
     .bios_clk			    (bios_clk),
     .bios_hld			    (bios_hld),
     .bios_csn			    (bios_csn),
     .bios_wdat			    (bios_wdat)
    );

endmodule





