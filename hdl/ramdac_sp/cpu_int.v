//////////////////////////////////////////////////////////////////////////////
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
//  Title       :  RAMDAC CPU Interface
//  File        :  cpu_int.v
//  Author      :  Jim MacLeod
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
//
//                 +----------------------------------+
//                 |                 +-------+        |
//                 |                 | reg.  |        |
//   reset ------->| --------------->| block |        |
//                 |                 |       |>-+-<-- |<--> misr info
//   rs ---------->|         +------>|       |  |     |
//                 |         | +---->|       |  +-<-- |<--> v/h sync ctl
//   write ------->| wrn    -+ | +-->|       |  |     |
//                 |           | |   |       |  +-<-- |<--> M, N, P, C ctl
//   read -------->| rdn    ---+ |   +-------+  |     |
//                 |             |              +-<-- |<--> cursor color & ctl
//   cpu_din ----->| ------------+              |     |
//                 |                            +-<-- |<--> Palette i/f
//                 |         +-------+          |     |
//                 |         |       |          +-<-- |<--> pixel ctl
//                 |         | cpu   |          |     |
//   cpu_dout <----|<--------|       |<---------+-<-- |<--> dac ctl
//                 |         | read  |          |     |
//                 |         |       |          +-<-- |<--> Mode ctl
//                 |         | mux   |          |     |
//                 |         |       |          +-<-- |<--> power mgmt
//   ext_fs ------>|         +-------+          |     |
//                 |                            +-<-- |<--> misc ctl
//                 +----------------------------------+

// misr info is: misr_cntl, misr_done, misr_red, misr_grn, misr_blu
// v/h sync ctl  xor_sync, csyn_invt, vsyn_invt, hsyn_invt, vsyn_cntl,
//               hsyn_cntl, hsyn_pos,
// M,N,P,C ctl   pix20ctl, pix21ctl, pixreg28, pixreg2c, pixreg21, pixreg25,
//               pixreg29, pixreg2d, pixreg22, pixreg26, pixp2ctl, pixp3ctl,
//               pixreg23, pixreg27, pixc2ctl, pixc3ctl, int_fs,
//
//cur color & ctl cur1red, cur1grn, cur1blu, cur2red, cur2grn, cur2blu, cur3red,
//               cur3grn, cur3blu, curhotx, curhoty, curxlow, curxhi, curylow,
//               curyhi, act_curylow, act_curyhi, act_curxlow, act_curxhi,
//               curctl, adcurctl, adcuratt,
// palette i/f   pal_wradr, pal2cpu, paladr pal_data1, pal_data2, pal_data3,
// pixel ctl     pix_mask, pixformat, pixclksel, pix_sel, pix_p_pll, pix_c_pll,
//               pix_m_pll, pix_n_pll,
// dac ctl       lblu_comp, lgrn_comp, lred_comp,  blu_comp, grn_comp,
//               red_comp, sens_disb, sens_sel, dac_op,
// Mode ctl      col_res, sixbitlin, sclkctl6, b8dcol, b16dcol, ziblin, fsf,
//               b32dcol, padr_rfmt,
// power mgmt    sclk_pwr, sync_pwr, iclk_pwr, dac_pwr,
// misc ctl      prog_mode, spll_enab,  ppll_enab, blank_cntl,
//               sclk_inv, syscctl, sysnctl, sysmctl, syspctl,
//
/////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 10 ps

module cpu_int
  (
   input		hclk, 
   input		hresetn, 
   input	[2:0]	rs,
   input		wrn, 
   input		rdn,  
   input	[7:0]	cpu_din, 
   input	[6:0]	mreg,
   input	[5:0]	nreg,
   input	[2:0]	preg,
   input	[1:0]	creg,
   input	[7:0]	cursor2cpu,
   input		lblu_comp, 
   input		lgrn_comp, 
   input		lred_comp,
   input		blu_comp,  
   input		grn_comp,  
   input		red_comp,
   input		misr_done,
   input	[7:0]	pal2cpu, 
   input	[7:0]	paladr, 
   input	[7:0]	act_curxlow, 
   input	[7:0]	act_curxhi,
   input	[7:0]	act_curylow, 
   input	[7:0]	act_curyhi, 
   input	[7:0]	misr_red, 
   input	[7:0]	misr_grn, 
   input	[7:0]	misr_blu,
   input		ext_fs,
   
   output reg		rd_mode,
   output reg	[10:0]	idx_inc,
   output reg   [10:0]  idx_raw,
   output reg	[7:0]	cpu2cursor,
   output reg	[2:0]	cp_addr,
   output reg	[2:0]	pixformat,
   output reg	[2:0]	pixclksel,
   output reg	[3:0]	hsyn_pos,
   output reg	[3:0]	dac_op,
   output reg	[1:0]	syscctl,
   output reg	[1:0]	pix_sel,
   output reg 	[1:0]	vsyn_cntl,
   output reg	[1:0]	hsyn_cntl,
   output reg	[1:0]	int_fs,
   output reg	[7:0]	cur1red,
   output reg	[7:0]	cur1grn,
   output reg	[7:0]	cur1blu,
   output reg	[7:0]	cur2red,
   output reg	[7:0]	cur2grn,
   output reg	[7:0]	cur2blu,
   output reg	[7:0]	cur3red,
   output reg	[7:0]	cur3grn,
   output reg	[7:0]	cur3blu,
   output reg	[7:0]	pal_wradr,
   output reg 	[7:0]	pal_data1,
   output reg	[7:0]	pal_data2,
   output reg	[7:0]	pal_data3,
   output reg	[7:0]	pix_mask,
   output reg	[7:0]	curctl,
   output reg 	[7:0]	curxlow,
   output reg	[7:0]	curxhi,
   output reg	[7:0]	curylow,
   output reg	[7:0]	curyhi,
   output reg	[7:0]	sysmctl,
   output reg	[7:0]	cpu_dout,
   output reg	[7:0]	adcuratt,
   output reg	[5:0]	curhotx , curhoty, sysnctl,
   output reg	[2:0]	syspctl,
   output reg	[7:0]	pixreg20, 
   output reg	[7:0]	pixreg21, 
   output reg	[7:0]	pixreg22, 
   output reg	[7:0]	pixreg23, 
   output reg	[7:0]	pixreg24, 
   output reg	[7:0]	pixreg25, 
   output reg	[7:0]	pixreg26, 
   output reg	[7:0]	pixreg27, 
   output reg		sclk_pwr,
   output reg		sync_pwr,
   output reg		iclk_pwr,
   output reg		dac_pwr, 
   output reg           blank_cntl,
   output reg           colres,
   output reg           fsf,
   output reg           ziblin,
   output reg           b8dcol,
   output reg           b16dcol,
   output reg           b32dcol,
   output reg           wr_mode,
   output reg           sixbitlin,
   output reg           vga_mode,
   output reg           csyn_invt,
   output reg           vsyn_invt,
   output reg           hsyn_invt,
   output reg           adcurctl, 
   output reg           prog_mode,
   output reg           spll_enab,
   output reg           misr_cntl,
   output reg           sens_disb,
   output reg           sens_sel,
   output reg           xor_sync,
   output reg		padr_rfmt, 
   output reg           sclk_inv,
   output reg           ppll_enab
  );
  
  parameter 		PAL_WADR	= 3'h0,  // Palette Write Address register.
	  		PAL_DAT		= 3'h1,  // Palette Data register.
	  		PIX_MSK		= 3'h2,  // Pixel Mask register.
	  		PAL_RADR 	= 3'h3,  // Palette Read Address register.
			IDX_ADRLO	= 3'h4,  // Index address register.
			IDX_ADRHI 	= 3'h5,  // Index address register
	  		IDX_DAT 	= 3'h6,  // Index data register.
			IDX_CTL		= 3'd7,	 // Index Control.
			MISC_CTL1	= 11'h70, // Misccellaneous Control Register 1.
			MISC_CTL2	= 11'h71, // Misccellaneous Control Register 2.
			MISC_CLK_CTL	= 11'h02, // Misccellaneous Clock Control.
			SYNC_CTL	= 11'h03, // Sync Control Register.
			HSYNC_CTL	= 11'h04, // Horizontal Sync Control Register.
			PWR_MNG		= 11'h05, // Power Management Register.
			DAC_OPR		= 11'h06, // DAC Operation Register.
			PAL_CTL		= 11'h07, // Pallette Control Register.
			SYSCLK_CTL	= 11'h08, // Pallette Control Register.
			PIX_FMT		= 11'h0A, // Pixel Format Register.
			PIX_CTL8	= 8'h0B, // 8 Bit Pixel Control Register.
			PIX_CTL16	= 8'h0C, // 16 Bit Pixel Control Register.
			PIX_CTL32	= 8'h0E; // 32 Bit Pixel Control Register.
  
  wire [13:0] 		read_address;
  wire 			sns =  blu_comp & grn_comp & red_comp;
  wire 			lsns = lblu_comp & lgrn_comp & lred_comp;
  
  reg [10:0] 		idx;
  reg 			idx_cntl;
  reg [2:0] 		pix_p_pll;
  reg [1:0] 		pix_c_pll;
  reg [6:0] 		pix_m_pll;
  reg [5:0] 		pix_n_pll;
  //reg [10:0] read_address;
  
  wire 			rdwr_clk;
  
  assign 		read_address = {cp_addr[2:0] , idx[10:0]};
  
  assign 		rdwr_clk = wrn & rdn;
  
  //---generate idx w/o auto incr.- used for detecting cursor write locs-----
  always @(posedge hclk or negedge hresetn)
    begin
      if (!hresetn)idx_raw[10:0] <= 11'h000;
      // Write index register (low)
      else if((rs == IDX_DAT) && !wrn) idx_raw <= idx;
      else if(!rdwr_clk) idx_raw <= 11'h0;
    end
  
  //----------generate idx w/o auto. used for cursor ram read write -----------
  always @(posedge hclk or negedge hresetn)
    begin
      if (!hresetn) idx_inc[10:0] <= 11'h000;
      else if((rs == IDX_DAT) && !rdwr_clk) idx_inc <= idx;
      else if(!rdwr_clk) idx_inc <= 11'h0;
    end
  
  //-------------------
  always @(posedge hclk or negedge hresetn)
    if (!hresetn) 	cp_addr[2:0] <= 3'b0;
    else 		cp_addr <= rs;
  
  always @(posedge hclk or negedge hresetn) begin
    if (!hresetn) begin
      idx[10:0]      <= 11'h000;
      pal_wradr[7:0] <= 8'h00;
      pal_data1[7:0] <= 8'h00;
      pal_data2[7:0] <= 8'h00;
      pal_data3[7:0] <= 8'h00;
      pix_mask[7:0]  <= 8'h00;
      idx_cntl       <= 1'b0;
      misr_cntl      <= 1'b0;
      padr_rfmt      <= 1'b0;
      sens_disb      <= 1'b0;
      sens_sel       <= 1'b0;
      xor_sync       <= 1'b0;
      pix_sel        <= 2'b0;
      blank_cntl     <= 1'b0;
      colres         <= 1'b0;
      vga_mode       <= 1'b0;
      sclk_inv       <= 1'b0;
      ppll_enab      <= 1'b1;
      csyn_invt      <= 1'b0;
      vsyn_invt      <= 1'b0;
      hsyn_invt      <= 1'b0;
      vsyn_cntl      <= 2'b00;
      hsyn_cntl      <= 2'b00;
      hsyn_pos       <= 4'b0;
      sclk_pwr       <= 1'b0;
      sync_pwr       <= 1'b0;
      iclk_pwr       <= 1'b0;
      dac_pwr        <= 1'b0;
      dac_op         <= 4'b0;
      sixbitlin      <= 1'b0;
      prog_mode      <= 1'b0;
      spll_enab      <= 1'b1;
      pixformat      <= 3'b0;
      b8dcol         <= 1'b0;
      b16dcol        <= 1'b0;
      ziblin         <= 1'b0;
      fsf            <= 1'b0;
      b32dcol        <= 1'b0;
      pixclksel      <= 3'b1;
      int_fs         <= 2'h0;
      pixreg20       <= 8'h07;
      pixreg21       <= 8'h15;
      pixreg22       <= 8'h10;
      pixreg23       <= 8'h2C;
      pixreg24       <= 8'h12;
      pixreg25       <= 8'h00;
      pixreg26       <= 8'h00;
      pixreg27       <= 8'h00;
      sysnctl        <= 6'h08;
      sysmctl        <= 8'h41;
      syspctl        <= 3'h0;
      syscctl        <= 2'h0;
      curctl         <= 8'h00;
      adcurctl       <= 1'b0;
      adcuratt       <= 8'h00;
      curxlow        <= 8'h00;
      curxhi         <= 8'h00; 
      curylow        <= 8'h00;
      curyhi         <= 8'h00; 
      curhotx        <= 6'h00; 
      curhoty        <= 6'h00;
      cur1red        <= 8'h00;
      cur1grn        <= 8'h00;
      cur1blu        <= 8'h00;
      cur2red        <= 8'h00;
      cur2grn        <= 8'h00;
      cur2blu        <= 8'h00;
      cur3red        <= 8'h00;
      cur3grn        <= 8'h00;
      cur3blu        <= 8'h00;
      cpu2cursor     <= 8'h00;
    end else begin
      // Autoincrement on a read or a write to a data register
      if ((cp_addr == IDX_DAT) && (!wrn || !rdn)) idx <= idx + idx_cntl;

      if (!wrn) begin
	case (cp_addr)
	  IDX_ADRLO: idx[7:0]  <= cpu_din[7:0]; // Write index register (low)
	  IDX_ADRHI: idx[10:8] <= cpu_din[2:0]; // Write index register (high)
	  IDX_DAT: begin
	    // writes or reads to any indexed register auto inc ON

            cpu2cursor <= cpu_din[7:0]; // Cursor ram data
	    case (idx)
	      MISC_CTL1: begin
		misr_cntl <= cpu_din[7];
		padr_rfmt <= cpu_din[5];
		sens_disb <= cpu_din[4];
		sens_sel  <= cpu_din[3];
		xor_sync  <= cpu_din[2];
	      end
	      MISC_CTL2: begin
		pix_sel    <= cpu_din[7:6];
		blank_cntl <= cpu_din[4];
		colres     <= cpu_din[2];
		vga_mode   <= !cpu_din[0];
	      end
	      MISC_CLK_CTL: begin
		sclk_inv  <= cpu_din[4];
		ppll_enab <= cpu_din[0];
	      end
	      SYNC_CTL: begin
		csyn_invt <= cpu_din[6];
		vsyn_invt <= cpu_din[5];
		hsyn_invt <= cpu_din[4];
		vsyn_cntl <= cpu_din[3:2];
		hsyn_cntl <= cpu_din[1:0];
	      end
	      HSYNC_CTL: hsyn_pos <= cpu_din[3:0];
	      PWR_MNG: begin
		sclk_pwr  <= cpu_din[4];
		sync_pwr  <= cpu_din[2];
		iclk_pwr  <= cpu_din[1];
		dac_pwr   <= cpu_din[0];
	      end
	      DAC_OPR: dac_op <= cpu_din[3:0];
	      PAL_CTL: sixbitlin <= cpu_din[7];
	      SYSCLK_CTL: begin
		prog_mode <= cpu_din[2];
		spll_enab <= cpu_din[0];
	      end
	      PIX_FMT: pixformat <= cpu_din[2:0];
	      PIX_CTL8: b8dcol <= cpu_din[0];
	      PIX_CTL16: begin
		// dynamic bypass is not implemented.
		// bit 5 of this register is not implemented
		ziblin <= cpu_din[2];
		fsf    <= cpu_din[1];
		if (cpu_din[7:6] == 2'b11) b16dcol <= 1'b1;
		else b16dcol <= 1'b0;
	      end
	      PIX_CTL32: begin
		// dynamic bypass is not implemented.
		// bits 2 and 6  of this register are not implemented
		if (cpu_din[1:0] == 2'b11) b32dcol <= 1'b1;
		else b32dcol <= 1'b0;
	      end
	      11'h010: pixclksel <= cpu_din[2:0];
	      11'h011: int_fs   <= cpu_din[1:0];
	      11'h020: begin
		pixreg20   <= cpu_din[7:0]; // M0
	      end
	      11'h021: begin
		pixreg21   <= cpu_din[7:0]; // N0
	      end
	      11'h022: begin
		pixreg22   <= cpu_din[7:0]; // P0
	      end
	      11'h023: begin
		pixreg23   <= cpu_din[7:0]; // C0
	      end
	      11'h024: begin
		pixreg24   <= cpu_din[7:0]; // M1
	      end
	      11'h025: begin
		pixreg25   <= cpu_din[7:0]; // N1
	      end
	      11'h026: begin
		pixreg26   <= cpu_din[7:0]; // P1
	      end
	      11'h027: begin
		pixreg27   <= cpu_din[7:0]; // C1
	      end
	      11'h015: begin
		sysnctl    <= cpu_din[5:0]; // Sysclk N
	      end
	      11'h016: begin
		sysmctl    <= cpu_din[7:0]; // Sysclk M
	      end
	      11'h017: begin
		syspctl    <= cpu_din[2:0]; // Sysclk P
	      end
	      11'h018: begin
		syscctl    <= cpu_din[1:0]; // Sysclk C
	      end
	      11'h030: curctl     <= cpu_din[7:0]; // Cursor control
	      11'h037: adcurctl   <= cpu_din[0];   // Advance cursor control
	      11'h038: adcuratt   <= cpu_din[7:0]; // Advance cursor attribute
	      11'h031: curxlow    <= cpu_din[7:0]; // Cursor X Low
	      11'h032: curxhi     <= {{4{cpu_din[7]}},
                                      cpu_din[3:0]};  // Cursor X High
	      11'h033: curylow    <= cpu_din[7:0]; // Cursor Y low
	      11'h034: curyhi     <= {{4{cpu_din[7]}},
                                      cpu_din[3:0]};// Cursor Y High
	      11'h035: curhotx    <= cpu_din[5:0]; // Cursor Hot Spot X
	      11'h036: curhoty    <= cpu_din[5:0]; // Cursor Hot Spot Y
	      11'h040: cur1red    <= cpu_din[7:0]; // Cursor color 1 red
	      11'h041: cur1grn    <= cpu_din[7:0]; // Cursor color 1 green
	      11'h042: cur1blu    <= cpu_din[7:0]; // Cursor color 1 blue
	      11'h043: cur2red    <= cpu_din[7:0]; // Cursor color 2 red
	      11'h044: cur2grn    <= cpu_din[7:0]; // Cursor color 2 green
	      11'h045: cur2blu    <= cpu_din[7:0]; // Cursor color 2 blue
	      11'h046: cur3red    <= cpu_din[7:0]; // Cursor color 3 red
	      11'h047: cur3grn    <= cpu_din[7:0]; // Cursor color 3 green
	      11'h048: cur3blu    <= cpu_din[7:0]; // Cursor color 3 blue
	    endcase
	  end
	  PAL_WADR: begin
	    wr_mode  <=1'b1;
	    rd_mode  <=1'b0;
	    pal_wradr[7:0] <= cpu_din[7:0]; // set up palette write address
	  end
	  PAL_RADR: begin
            wr_mode  <=1'b0;
            rd_mode  <=1'b1;
	    pal_wradr[7:0] <= cpu_din[7:0]; // set up palette read address
	  end
	  PAL_DAT: begin
	    pal_data1[7:0] <= cpu_din[7:0];
	    pal_data2[7:0] <= pal_data1[7:0];
	    pal_data3[7:0] <= pal_data2[7:0];
	  end
	  // set up pixel mask
	  PIX_MSK: pix_mask[7:0] <= cpu_din[7:0];
	  IDX_CTL: idx_cntl  <= cpu_din[0];
	endcase
      end
    end
  end
  
  // processor read mode...
  always @*
    casex(read_address)
      14'b000xxxxxxxxxxx:    cpu_dout = paladr;
      14'b001xxxxxxxxxxx:    cpu_dout = pal2cpu;
      14'b010xxxxxxxxxxx:    cpu_dout = pix_mask;
      14'b011xxxxxxxxxxx:      begin
        if (!padr_rfmt) begin
          cpu_dout = paladr; end
        else begin
          cpu_dout = {6'h00 , rd_mode, rd_mode}; end
      end
      14'b100xxxxxxxxxxx:    cpu_dout = idx[7:0];
      14'b101xxxxxxxxxxx:    cpu_dout = {5'h00 , idx[10:8]};
      14'b111xxxxxxxxxxx:    cpu_dout = {7'h00 , idx_cntl};
      
      // 0x070
      14'b11000001110000:    cpu_dout = {misr_cntl, 1'b0, padr_rfmt,
					  sens_disb, sens_sel, xor_sync, 2'h0 };
      
      // 0x
      
      14'b11000001110001:    cpu_dout = {pix_sel, 1'b0, blank_cntl, 1'b0,
					  colres, 1'b0, !vga_mode };
      
      // 0x000 , 0x001
      14'b1100000000000x:    cpu_dout = 8'h99;
      
      // 0x002
      14'b11000000000010:    cpu_dout = { 3'h0, sclk_inv, 3'h0, ppll_enab};
      
      // 0x003
      14'b11000000000011:    cpu_dout = { 1'h0, csyn_invt, vsyn_invt,
                                           hsyn_invt, vsyn_cntl, hsyn_cntl};
      
      // 0x004
      14'b11000000000100:    cpu_dout = { 4'h0, hsyn_pos};
      
      // 0x005
      14'b11000000000101:    cpu_dout = { 3'h0, sclk_pwr, 1'b0, sync_pwr,
					   iclk_pwr, dac_pwr};
      
      // 0x006
      14'b11000000000110:    cpu_dout = { 4'h0, dac_op };
      
      // 0x007
      14'b11000000000111:    cpu_dout = { sixbitlin, 7'h00 };
      
      // 0x008
      14'b11000000001000:    cpu_dout = {5'h00, prog_mode, 1'b0, spll_enab};
      
      // 0x00a
      14'b11000000001010:    cpu_dout = {5'h00, pixformat};
      // 0x00b
      14'b11000000001011:    cpu_dout = {7'h00, b8dcol};
      // 0x00c
      14'b11000000001100:    cpu_dout = {b16dcol, b16dcol, 3'h0, ziblin,
                                          fsf, 1'b0 };
      // 0x00e
      14'b11000000001110:    cpu_dout = {6'h00, b32dcol, b32dcol };
      // 0x010
      14'b11000000010000:    cpu_dout = {5'h00, pixclksel};
      // 0x011
      14'b11000000010001:    cpu_dout = {6'h00, int_fs};
      // 0x020
      14'b11000000100000:   // begin if (std_mode) begin
        //   cpu_dout <= {1'b0, pixreg20[6:0]}; end
        //  else begin
        cpu_dout =  pixreg20; //end end
      // 0x021
      14'b11000000100001: //   begin  if (std_mode) begin
        //            cpu_dout <= {2'h0, pixreg21[5:0]}; end
        //         else begin cpu_dout <=
        //            {3'h0, pixreg21[4:0]}; end end
        cpu_dout =  pixreg21;
      // 0x022
      14'b11000000100010: // begin  if (std_mode) begin
        //          cpu_dout <= {5'h00, pixreg22[2:0]}; end
        //        else begin cpu_dout <=  pixreg22; end end
        cpu_dout =  pixreg22;
      // 0x023
      14'b11000000100011: // begin  if (std_mode) begin
        //          cpu_dout <= {6'h00, pixreg23[1:0]}; end
        //        else begin cpu_dout <=  pixreg23; end end
        cpu_dout =  pixreg23;
      // 0x024
      14'b11000000100100: // begin  if (std_mode) begin
	
        //           cpu_dout <= {1'b0, pixreg24[6:0]}; end
        //        else begin cpu_dout <=  pixreg24; end end
        cpu_dout =  pixreg24;
      // 0x025
      14'b11000000100101: // begin  if (std_mode) begin
        //            cpu_dout <= {2'h0, pixreg25[5:0]}; end
        //         else begin cpu_dout <=
        //            {3'h0, pixreg25[4:0]}; end end
        cpu_dout =  pixreg25;
      // 0x026
      14'b11000000100110: // begin  if (std_mode) begin
        //          cpu_dout <= {5'h00, pixreg26[2:0]}; end
        //        else begin cpu_dout <=  pixreg26; end end
        cpu_dout =  pixreg26;
      // 0x027
      14'b11000000100111://  begin  if (std_mode) begin
        //           cpu_dout <= {6'h00, pixreg27[1:0]}; end
        //         else begin cpu_dout <=  pixreg27; end end
        cpu_dout =  pixreg27;
      // 0x015
      14'b11000000010101: // begin  if (std_mode) begin
        //          cpu_dout <= {2'b00, sysnctl}; end
        //        else begin cpu_dout <=  sysnctl[4:0];
        //        end end
        cpu_dout = {2'b0 , sysnctl[5:0]};
      // 0x016
      14'b11000000010110: //   begin  if (std_mode) begin
        //            cpu_dout <= {1'b0, sysmctl}; end
        //          else begin cpu_dout <= sysmctl;
        //          end end
        cpu_dout =  sysmctl;
      
      // 0x017
      14'b11000000010111: // begin  if (std_mode) begin
        cpu_dout = {5'h00, syspctl}; // end
      //       else begin cpu_dout <= 8'h00;
      //       end end
      // 0x018
      14'b11000000011000: //   begin  if (std_mode) begin
        cpu_dout = {6'h00, syscctl}; // end
      //          else begin cpu_dout <= 8'h00;
      //          end end
      // 0x030
      14'b11000000110000:    cpu_dout = curctl;
      // 0x037
      14'b11000000110111:    cpu_dout = {7'h00, adcurctl};
      // 0x038
      14'b11000000111000:    cpu_dout = adcuratt;
      // 0x031
      14'b11000000110001:    begin  if (curctl[4]) begin
        cpu_dout =  act_curxlow ; end
      else begin cpu_dout =  curxlow ; end
      end
      // 0x032
      14'b11000000110010:    begin  if (curctl[4]) begin
        cpu_dout = {act_curxhi[7],
                     act_curxhi[7], act_curxhi[7],
                     act_curxhi[7], act_curxhi[3:0]}; end
      else begin cpu_dout = {curxhi[7],
                              curxhi[7], curxhi[7], curxhi[7],
                              curxhi[3:0]}; end end
      // 0x033
      14'b11000000110011:    begin  if (curctl[4]) begin
        cpu_dout =  act_curylow ; end
      else begin cpu_dout =  curylow ; end
      end
      // 0x034
      14'b11000000110100:    begin  if (curctl[4]) begin
        cpu_dout = {act_curyhi[7],
                     act_curyhi[7], act_curyhi[7],
                     act_curyhi[7], act_curyhi[3:0]}; end
      else begin cpu_dout = {curyhi[7],
                              curyhi[7], curyhi[7], curyhi[7],
                              curyhi[3:0]}; end end
      // 0x035
      14'b11000000110101:    begin  if (curctl[2]) begin
        cpu_dout = {2'b00, curhotx}; end
      else begin
        cpu_dout = {3'h0, curhotx[4:0]}; end end
      // 0x036
        14'b11000000110110:    begin  if (curctl[2]) begin
          cpu_dout = {2'b00, curhoty}; end
        else begin
          cpu_dout = {3'h0, curhoty[4:0]}; end end
      // 0x040
      14'b11000001000000:    cpu_dout = cur1red;
      // 0x041
      14'b11000001000001:    cpu_dout = cur1grn;
      // 0x042
      14'b11000001000010:    cpu_dout = cur1blu;
      // 0x043
      14'b11000001000011:    cpu_dout = cur2red;
      // 0x044
      14'b11000001000100:    cpu_dout = cur2grn;
      // 0x045
      14'b11000001000101:    cpu_dout = cur2blu;
      // 0x046
      14'b11000001000110:    cpu_dout = cur3red;
      // 0x047
      14'b11000001000111:    cpu_dout = cur3grn;
      // 0x048
      14'b11000001001000:    cpu_dout = cur3blu;
      // 0x082
      14'b11000010000010:    cpu_dout = {lsns, lblu_comp, lgrn_comp,
					  lred_comp, sns, blu_comp, grn_comp, red_comp};
      // 0x083
      14'b11000010000011:    cpu_dout = {7'h0, misr_done};
      // 0x084
      14'b11000010000100:    cpu_dout =  misr_red;
      // 0x086
      14'b11000010000110:    cpu_dout = misr_grn;
      // 0x086
      14'b11000010001000:    cpu_dout = misr_blu;
      // 0x08c
      14'b11000010001100:    cpu_dout = {5'h00 , preg[2:0]};
      // 0x08d
      14'b11000010001101:    cpu_dout = {6'h00 , creg[1:0]};
      // 0x08e
      14'b11000010001110:    cpu_dout = {1'b0 ,  mreg[6:0]};
      // 0x08f
      14'b11000010001111:    cpu_dout = {2'b00 , nreg[5:0]};
      // 0x090
      14'b11000010010000:    cpu_dout = {5'h00 , preg[2:0]};
      // 0x091
      14'b11000010010001:    cpu_dout = {6'h00 , creg[1:0]};
      default :   cpu_dout = cursor2cpu;
    endcase

  
 endmodule
