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
//  Title       :  CRT Controller
//  File        :  crt.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module is the CRT Display controller
//  this is modified CRT module (top of original crt controler )
//  CRTTIMER module is broken in two modules: CRTADDSL and CRTTIMER
//  CRTADDSL consist of all adders and substractors common to
//  VRAM and DRAM controlers
//  Functionality of original CRTTIMER will be intact if CRTADDSEL and
//  CRTTIMER have proper port connections.
//  To support the "DRAM only" configuration the following mudules are
//  added: DC_TOP (and all DC_xxx modules in hierarchy),
//         CRTDCVMUX (a mux for selecting  syncs from CRT_xx or DC_xxx or VGA) 
//  Port list of CRT module (this module) has new signals
//  added at the end of the original port list.
//  It includes new signals to comunicate with mem.controller, data lines etc.
//  DC_xxx is also muxing display data from DC_ and from the VGA core
//  and gating pixel clock to vga core
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

`timescale 1ns / 10ps

module crt
  (
   input [1:0]       bpp, /* screen depth 
			   * (from idac pixel_representation[2:1] reg)
			   * 2'b01: 8bpp
			   * 2'b10: 16pbb
			   * 2'b11 or 00: 32bpp */
   input 	     ovnokey, /* from overlay (overlay on, no key,
			       * crt can suppress some requsets.) */
   
   input             crtclock,
   input             pixclock,
   input	     hclock,
   input             hreset,
   input 	     hwr_in,
   input 	     hcs_in,
   input [3:0] 	     hnben_in,
   input [31:0]      hdat_in,
   input [7:2] 	     haddr,
   input  	     vga_en,
   input [7:0]       vga_din,
   input             dlp_wradd,//write enable to display address register from DLP
   input [20:0]      dlp_add,   // display address from DLP (24:4),
   input [31:0]      hdat_in_aux, /* data to host from VGA_TOP or Second CRT.
                                * muxed here only for layout improvement */
   // video overlay postion (in pixels)
   input [39:0]	     vid_win_pos, 
   input             mcdc_ready, 
   input             mcpush,
   input             mclock,
   input [127:0]     datdc_in,
   input 	     vga_blank,
   input 	     vga_hsync,
   input 	     vga_vsync,
   input 	     disp_reg_rep,
   input [3:0]	     disp_reg_crt,

   output [31:0]     hdat_out_crt_aux,
   output [1:0]      hint_out_tog,   // interrupt
   output reg	     vblnkst2,     // to HBI status register
   output [15:4]     db_pitch_regist,
   output reg [24:4] displ_start_vs,
   output            mcdc_req,
   output [9:0]      mcdcx,
   output [11:0]     mcdcyf,
   output [4:0]      mcdcpg , 
   output            blank_toidac,hcsync_toidac, vsync_toidac, 
   output [23:0]     datdc_out,// 2 pixels of data to ramdac
   output            fdp_on,    // (flat panel display on)
   output [1:0] 	  syncsenable_regist,
   output [13:0] 	  hactive_regist 
   );
  
  parameter 	  disp_param = 4'b0000;

  // FIXME These are the values for 2 pixels per clock.
  /*
  parameter 	  hactv_640  = 14'h0A0,
  		  hactv_800  = 14'h0C0,
  		  hactv_1024 = 14'h100,
  		  hactv_1280 = 14'h140,
  		  hactv_1600 = 14'h190;
   */
  parameter 	  hactv8_640  =  14'hA0,
  	 	  hactv16_640  = 14'h140,
  	 	  hactv32_640  = 14'h280,
  		  hactv8_800  =  14'hC8,
  		  hactv16_800  = 14'h190,
  		  hactv32_800  = 14'h320,
  		  hactv8_1024 =  14'h100,
  		  hactv16_1024 = 14'h200,
  		  hactv32_1024 = 14'h400,
  		  hactv8_1152 =  14'h120,
  		  hactv16_1152 = 14'h240,
  		  hactv32_1152 = 14'h480,
  		  hactv8_1280 =  14'h140,
  		  hactv16_1280 = 14'h280,
  		  hactv32_1280 = 14'h500,
  		  hactv8_1600 =  14'h190,
  		  hactv16_1600 = 14'h320,
  		  hactv32_1600 = 14'h640;

  wire [9:0] 	  ovtl_x = vid_win_pos[39:30]; 
  wire [9:0] 	  ovtl_y = vid_win_pos[29:20];
  wire [9:0] 	  ovbr_x = vid_win_pos[19:10];
  wire [9:0] 	  ovbr_y = vid_win_pos[9:0];
  
  reg [24:4] 	  displ_start_vst;
  
  wire 		  int_blank_toidac,
		  int_hcsync_toidac, 
		  int_vsync_toidac; 
  wire 		  vblnk_early;
  wire [11:0] 	  mcdcy;
  wire 		  vsync_early;
  wire [9:0] 	  ff_stp, ff_rls;
  
  wire [13:0] 	  
		  hblank_regist, 
		  hfporch_regist, 
		  hswidth_regist;
  wire [11:0] 	  hicount_regist;
  wire [11:0] 	  vactive_regist, 
		  vblank_regist, 
		  vfporch_regist, 
		  vswidth_regist;
  wire [7:0] 	  vicount_regist;
  wire [3:0] 	  dzoom_regist;
  
  //  CRTADDSL wires  
  wire [13:0] 	  htotal_add, 
		  hendsync_add,
		  endequal_add,
		  halfline_add,
		  endequalsec_add,
		  serrlongfp_substr, 
		  serr_substr,
		  serrsec_substr;
  wire [11:0] 	  vendsync_add,
		  vendequal_add,
		  vtotal_add;
  
  // other wires
  wire [9:0] 	  pinl_regist;
  wire [24:4] 	  displ_start_regist; 
  wire [24:4] 	  sec_start_regist; 
  wire 		  addr_load; 
  wire 		  ss_mode;
  
  wire 		  addr_stat;
  
  reg 		  addr_stat1, 
		  addr_stat2, 
		  addr_tr, 
		  ad_strst1,
		  ad_strst2,
		  ad_strst3,
		  vblnkst1;
  wire 		  lcounter_enstat;
  wire [11:0] 	  lcounter_stat;
  reg [11:0] 	  lcounter_stat_s; //latched and synchornized to host clock
  reg 		  lcount_toggle, 
		  lcount_le2,
		  lcount_le1;
  
  wire [127:0] 	  dat_rd128, 
		  dat_out128;
  
  wire [31:0] 	  hdat_out_from_crt;
  wire [127:0] 	  crt_data;         // Data from ram to adout
  wire [9:0] 	  wrusedw;
  wire 		  poshs_regist;
  wire 		  posvs_regist;
  wire 		  compsync_regist;
  wire 		  crtintl_regist;
  wire 		  videnable_regist;
  wire 		  ovignr_regist;
  wire 		  ovignr16l_regist;
  wire 		  refresh_enable_regist;
  wire 		  hfpbhs;
  wire 		  dcnreset;
  wire 		  hblnk_early;
  wire 		  hblnk_late;
  wire 		  fsign_early;
  wire 		  cblnk_early;
  wire 		  rsuppr;
  wire 		  pop;
  
  // Muxing for VGA signals
  assign 	  blank_toidac = (vga_en) ? vga_blank : int_blank_toidac;
  assign 	  hcsync_toidac = (vga_en) ? vga_hsync : int_hcsync_toidac;
  assign 	  vsync_toidac = (vga_en) ? vga_vsync : int_vsync_toidac;
  
  // If this CRT is selected or if all CRTs are select pass 
  // through the chip select.
  wire 		  hcsn = (disp_reg_rep | (disp_reg_crt == disp_param)) ?  
			   hcs_in : 1'b1; 
  
  //send data from crtregisters whenever chip_select for crt goes low 
  // otherwise send vga data on the same bus
  assign 	  hdat_out_crt_aux = (~hcsn) ? hdat_out_from_crt : 
		  hdat_in_aux; 
           

  ////////////////////////////////////////////////////////////////////////////
  ////////  synchronize display start address and make status signals        //
  always @(posedge pixclock or negedge hreset)
    if (!hreset) begin
      addr_tr    <= 1'b0;
      addr_stat1 <= 1'b0;
      addr_stat2 <= 1'b0;
    end else if (crtclock) begin
      addr_stat1 <= addr_stat;
      addr_stat2 <= addr_stat1;

      if(addr_load & addr_stat2) begin
	displ_start_vst[24:4] <= displ_start_regist[24:4];
	addr_tr <= ~addr_tr;
      end
    end
  
  always @(posedge hclock or negedge hreset)
    if (!hreset) begin
      ad_strst3  <= 1'b0;
      ad_strst2  <= 1'b0;
      ad_strst1  <= 1'b0;
      vblnkst2   <= 1'b0;
      vblnkst1   <= 1'b0;
    end else begin
      ad_strst3  <= ad_strst2 ^ ad_strst1;
      ad_strst2  <= ad_strst1;
      ad_strst1  <= addr_tr;
      vblnkst2   <= vblnkst1;
      vblnkst1   <= vblnk_early;  
    end

  // select synchronized display start address if not in ss_mode, and toggle
  // start address in ss_mode
  // !!! lucy synchronize regist and sec to vsync????????
  always @*    
    casex({ss_mode,mcdcy[0]})
      2'b0x: displ_start_vs[24:4]=displ_start_vst[24:4];
      2'b10: displ_start_vs[24:4]=displ_start_regist[24:4];
      2'b11: displ_start_vs[24:4]=sec_start_regist[24:4];
    endcase
  
  //shift down mcdcy final  if in ss_mode(will not work with zoom!)
  assign mcdcyf = (ss_mode)? {1'b0, mcdcy[11:1]}: mcdcy[11:0]; 
  
  ////////////////////////////////////////////////////////////////////////////
  // latch line counter status ( latching signal is synchronized with host 
  // clock, width active=2hclks, lcounter is stable at that time )
  always @(posedge pixclock or negedge hreset)
    if (!hreset)               
      lcount_toggle <= 1'b0;
    else if (~lcounter_enstat && crtclock) 
      lcount_toggle <= ~lcount_toggle;

  always @(posedge hclock or negedge hreset) begin
    if (!hreset) begin
      lcounter_stat_s <= 12'b0;
      lcount_le2      <= 1'b0;
      lcount_le1      <= 1'b0;
    end else begin
      if (lcount_le2 ^ lcount_le1) lcounter_stat_s <= lcounter_stat; 
      lcount_le2 <= lcount_le1;
      lcount_le1 <= lcount_toggle;
    end
  end
  
  crtregist CRTREGIST
    (
     .hclock          (hclock),
     .hnreset         (hreset),
     .hwr             (hwr_in),
     .hncs            (hcsn),
     .hnben           (hnben_in),
     .hdat_in         (hdat_in), 
     .haddr           (haddr),
     .ad_strst        (ad_strst3),
     .vblnkst         (vblnkst2), 
     .lcounter_stat   (lcounter_stat_s),
     .dlp_wradd       (dlp_wradd),
     .dlp_add         (dlp_add),
     
     .hdat_out        (hdat_out_from_crt),
     .vicount         (vicount_regist),
     .hicount         (hicount_regist),
     .hactive_o       (hactive_regist),
     .hblank_o        (hblank_regist),
     .hfporch_o       (hfporch_regist),
     .hswidth_o       (hswidth_regist),
     .vactive         (vactive_regist),
     .vblank          (vblank_regist),
     .vfporch         (vfporch_regist),
     .vswidth         (vswidth_regist),
     .dzoom           (dzoom_regist),
     .db_pitch        (db_pitch_regist[15:4]),
     .displ_start     (displ_start_regist[24:4]),
     .sec_start       (sec_start_regist[24:4]),
     .poshs           (poshs_regist), 
     .posvs           (posvs_regist),
     .compsync        (compsync_regist),
     .crtintl         (crtintl_regist),
     .syncsenable     (syncsenable_regist), 
     .videnable       (videnable_regist),
     .ovignr          (ovignr_regist),
     .ovignr16l       (ovignr16l_regist),
     .refresh_enable  (refresh_enable_regist),
     .fdp_on          (fdp_on), 
     .addr_stat       (addr_stat),  
     .pinl            (pinl_regist),
     .ss_mode         (ss_mode)
     );
  
  crttimer  CRTTIMER
    (
     .hnreset         (hreset),
     .vga_en          (vga_en),
     .pixclk          (pixclock),
     .crtclock        (crtclock),
     .crtintl_regist  (crtintl_regist),
     .hblank_regist   (hblank_regist),
     .hfporch_regist  (hfporch_regist), 
     .vblank_regist   (vblank_regist), 
     .vfporch_regist  (vfporch_regist), 
     .poshs_regist    (poshs_regist), 
     .posvs_regist    (posvs_regist),
     .compsync_regist (compsync_regist),
     .syncsenable_regist(syncsenable_regist),
     .videnable_regist(videnable_regist),
     .refrenable_regist(refresh_enable_regist),
     .vicount_regist  (vicount_regist),
     .hicount_regist  (hicount_regist),
     
     .htotal_add      (htotal_add),
     .hendsync_add    (hendsync_add),
     .endequal_add    (endequal_add),
     .halfline_add    (halfline_add),
     .endequalsec_add (endequalsec_add),
     .serrlongfp_substr(serrlongfp_substr), 
     .serr_substr     (serr_substr),
     .serrsec_substr  (serrsec_substr),
     .vendsync_add    (vendsync_add),
     .vendequal_add   (vendequal_add), 
     .vtotal_add      (vtotal_add),
     .hfpbhs          (hfpbhs), 

     .dcnreset        (dcnreset),
     .dchcsync_o      (int_hcsync_toidac),
     .dcvsync_o       (int_vsync_toidac), 
     .dcblank_o       (int_blank_toidac),// lucy now to ramdac 

     .hblank          (hblnk_early),
     .hblank_d        (hblnk_late),
     .vblank          (vblnk_early),
     .fsign           (fsign_early),
     .cblank          (cblnk_early), 
     .vsync           (vsync_early),
     .crtintdd_tog    (hint_out_tog),  // interrupts
     .addr_load       (addr_load),
     .lcounter_enstat (lcounter_enstat),
     .lcounter_stat   (lcounter_stat)
     );

  crtaddsl CRTADDSL
    (
     .hactive_regist  (hactive_regist),
     .hblank_regist   (hblank_regist),
     .hfporch_regist  (hfporch_regist),
     .hswidth_regist  (hswidth_regist),
     .vactive_regist  (vactive_regist), 
     .vblank_regist   (vblank_regist),
     .vfporch_regist  (vfporch_regist),
     .vswidth_regist  (vswidth_regist),

     .htotal_add      (htotal_add),
     .hendsync_add    (hendsync_add),
     .endequal_add    (endequal_add),
     .halfline_add    (halfline_add),
     .endequalsec_add (endequalsec_add),
     .serrlongfp_substr(serrlongfp_substr), 
     .serr_substr     (serr_substr),
     .serrsec_substr  (serrsec_substr),
     .vendsync_add    (vendsync_add),
     .vendequal_add   (vendequal_add),
     .vtotal_add      (vtotal_add),
     .hfpbhs          (hfpbhs)
     );  

  dc_contr  DCCONTR 
    (
     .dcnreset        (dcnreset), 
     .hnreset         (hreset),
     .pixclock        (pixclock),
     .crtclock        (crtclock),
     .mclock          (mclock),
     .vsync           (vsync_early), 
     .refresh_enable_regist(refresh_enable_regist),
     .dzoom_regist    (dzoom_regist),
     .vactive_regist  (vactive_regist),
     .pinl_regist     (pinl_regist),
     .mcdc_ready      (mcdc_ready), 
     .wrusedw         (wrusedw),
     
     .ovtl_x          (ovtl_x), 
     .ovtl_y          (ovtl_y),
     .ovbr_x          (ovbr_x),
     .ovbr_y          (ovbr_y),
     .bpp             (bpp),
     .ovnokey         (ovnokey),
     .ovignr_regist   (ovignr_regist),
     .ovignr16l_regist(ovignr_regist),
     
     .ff_stp          (ff_stp),
     .ff_rls          (ff_rls),
     .rsuppr          (rsuppr),
     .mcdc_req        (mcdc_req),
     .mcdcy           (mcdcy),
     .mcdcx           (mcdcx),
     .mcdcpg          (mcdcpg)
     );
  
  dc_adout  DCADOUT 
    (
     .pixclock        (pixclock),
     .dcnreset        (dcnreset),
     .hnreset         (hreset),
     .vsync           (vsync_early),
     .cblank          (cblnk_early),
     .rsuppr          (rsuppr),
     .ff_stp          (ff_stp),
     .ff_rls          (ff_rls),
     .ovtl_y          (11'h0), // ovtl_y),
     .ovbr_y          (11'h0), // ovbr_y),
     .bpp             (bpp),
     .crt_data        (crt_data),
     .vga_din         (vga_din),
     .vga_en          (vga_en),
		       
     .pop             (pop),
     .datdc_out       (datdc_out)
     ); 
  
  // The original Output Ram was as follows:
  // ASYNC RAM
  // 128 bit output register
  // 128 to 64 mux
  // 64 bit register
  // This has been replaced by an Altera RAM w/ 128 bit input and 64 bit output
  // Addresses are registered which replaces the first output flop.
  // The output is also registered replacing the 64 bit output register
  fifo_128x512a U_DCFIFO
    (
     .data            (datdc_in),
     .wrreq           (mcpush),
     .rdreq           (pop),
     .rdclk           (pixclock),
     .wrclk           (mclock),
     .aclr            (~(vsync_early & dcnreset)),
     
     .q               (crt_data),
     .wrusedw         (wrusedw),
     .rdempty         (),
     .wrfull          ()  
     );

endmodule






