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
//  Title       :  Ramdac Sync Generator
//  File        :  syncs.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
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

module syncs
  (
   input		crtclock,            // CRT Clock
   input                pixclk,              // Pixel Clock
   input                hresetn,             // Global Reset
   input                sync_pwr,            // Power Save: Disable Syncs
   input                sclk_pwr,            // Power Save: Disable Sclk
   input                iclk_pwr,            // Power Save: Disable Pix Clock
   input		vsyncin,
   input		hcsyncin,
   input		xor_sync,
   input		vsyn_invt,
   input		hsyn_invt,
   input		csyn_invt,
   input		sog,
   input [1:0]    	hsyn_cntl,
   input [1:0]		vsyn_cntl,
   input [3:0]   	hsyn_pos,
   
   output		syncn2dac, 
   output reg		hsyncout,
   output reg		vsyncout
   );

  reg 	  sync_pwr_crt0;                     // Synchronize pwr reg
  reg 	  sync_pwr_pix0;                     // Synchronize pwr reg
  reg 	  sclk_pwr_crt0;                     // Synchronize sclk
  reg 	  iclk_pwr_pix0;                     // Synchronize iclk
  reg 	  sync_pwr_crt;                      // Synchronize pwr reg
  reg 	  sync_pwr_pix;                      // Synchronize pwr reg
  reg 	  sclk_pwr_crt;                      // Synchronize sclk
  reg 	  iclk_pwr_pix;                      // Synchronize iclk
  reg 	  piped_sog;
  reg 	  piped_hsync;
  reg 	  hsync_l,
	  csync_l,
	  hsync_s,
	  csync_s,
	  hsync_x,
	  csync_x,
	  csync_1,
	  csync_2,
	  csync_3,
	  csync_4,
	  csync_5,
	  csync_11,
	  csync_12,
	  hsync_1,
	  hsync_2,
	  hsync_3,
	  hsync_4,
	  hsync_5,
	  hsync_11,
	  hsync_12,
	  piped_hsync1,
	  piped_hsync2,
	  piped_hsync3,
	  piped_hsync4,
	  piped_hsync5,
	  piped_hsync6,
	  piped_hsync7,
	  piped_hsync8,
	  piped_hsync9,
	  piped_hsynca,
	  piped_hsyncb,
	  piped_hsyncc,
	  piped_hsyncd, 
	  piped_hsynce,
	  piped_csync1,
	  piped_csync2,
	  piped_csync3,
	  piped_csync4,
	  piped_csync5,
	  piped_csync6,
	  piped_csync7,
	  piped_csync8,
	  piped_csync9, 
	  piped_csynca,
	  piped_csyncb,
	  piped_csyncc,
	  piped_csyncd,
	  piped_csynce;

  assign  syncn2dac =  sog ? piped_sog : 1'b0;
  
  // look for vdac sync control (is it pos active or neg active)
//  wire 	  hsync     = (hsyn_invt | ext_sync_pol[0]) ? !hcsyncin : hcsyncin;
//  wire 	  csync     = (csyn_invt | ext_sync_pol[2]) ? !hcsyncin : hcsyncin;
//  wire 	  vsync     = (vsyn_invt | ext_sync_pol[1]) ? !vsyncin :  vsyncin;
  wire 	  hsync     = hsyn_invt ? !hcsyncin : hcsyncin;
  wire 	  csync     = csyn_invt ? !hcsyncin : hcsyncin;
  wire 	  vsync     = vsyn_invt ? !vsyncin :  vsyncin;
  wire 	  composite = xor_sync  ? (hsync ^ vsync) : csync;
  
  wire  h_out = sog ? composite : piped_hsync;
  
  always@* begin
    case(hsyn_cntl)
      2'b10:   hsyncout = 1'b0;
      2'b01:   hsyncout = 1'b1;
      default: hsyncout = h_out;
    endcase 
  end

  always@* begin
    case(vsyn_cntl)
      2'b10:   vsyncout = 1'b0;
      2'b01:   vsyncout = 1'b1;
      default: vsyncout = vsync;
    endcase 
  end

  always @(posedge pixclk) 
    if (crtclock) begin
      sync_pwr_crt0 <= sync_pwr;
      sclk_pwr_crt0 <= sclk_pwr;
      sync_pwr_crt <= sync_pwr_crt0;
      sclk_pwr_crt <= sclk_pwr_crt0;
    end

  always @(posedge pixclk) 
    if (crtclock) begin
      sync_pwr_pix0 <= sync_pwr;
      iclk_pwr_pix0 <= iclk_pwr;
      sync_pwr_pix <= sync_pwr_pix0;
      iclk_pwr_pix <= iclk_pwr_pix0;
    end
  
  always @(posedge pixclk or negedge hresetn) 
    if (!hresetn) begin
      csync_l <= 1'b0;
      hsync_l <= 1'b0;
    end else if (sync_pwr_crt && crtclock) begin
      csync_l <= 1'b0;
      hsync_l <= 1'b0;
    end else if (crtclock) begin
      csync_l <= composite;
      hsync_l <= hsync    ;
    end

  reg csync_sl, hsync_sl, hsync_10, csync_10;

  always @(posedge pixclk or negedge hresetn) 
    if (!hresetn) begin
      csync_s <= 1'b0;
      hsync_s <= 1'b0;
      csync_sl <= 1'b0;
      hsync_sl <= 1'b0;
    end else if (crtclock) begin
      if (sync_pwr_crt | sclk_pwr_crt) begin
	csync_s <= 1'b0;
	hsync_s <= 1'b0;
	csync_sl <= 1'b0;
	hsync_sl <= 1'b0;
      end else begin
	csync_s <= csync_l;
	hsync_s <= hsync_l;
	csync_sl <= csync_s;
	hsync_sl <= hsync_s;
      end
    end // if (crtclock)
  
  always @(posedge pixclk or negedge hresetn)
    if (!hresetn) begin
      csync_x <= 1'b0;
      csync_1 <= 1'b0;
      csync_10 <= 1'b0;
      csync_11 <= 1'b0;
      csync_12 <= 1'b0;
      csync_2 <= 1'b0;
      csync_3 <= 1'b0;
      csync_4 <= 1'b0;
      csync_5 <= 1'b0;
      hsync_x <= 1'b0;
      hsync_1 <= 1'b0;
      hsync_10 <= 1'b0;
      hsync_11 <= 1'b0;
      hsync_12 <= 1'b0;
      hsync_2 <= 1'b0;
      hsync_3 <= 1'b0;
      hsync_4 <= 1'b0;
      hsync_5 <= 1'b0;
      piped_hsync1 <= 1'b0;
      piped_hsync2 <= 1'b0;
      piped_hsync3 <= 1'b0;
      piped_hsync4 <= 1'b0;
      piped_hsync5 <= 1'b0;
      piped_hsync6 <= 1'b0;
      piped_hsync7 <= 1'b0;
      piped_hsync8 <= 1'b0;
      piped_hsync9 <= 1'b0;
      piped_hsynca <= 1'b0;
      piped_hsyncb <= 1'b0;
      piped_hsyncc <= 1'b0;
      piped_hsyncd <= 1'b0;
      piped_hsynce <= 1'b0;
      piped_csync1 <= 1'b0;
      piped_csync2 <= 1'b0;
      piped_csync3 <= 1'b0;
      piped_csync4 <= 1'b0;
      piped_csync5 <= 1'b0;
      piped_csync6 <= 1'b0;
      piped_csync7 <= 1'b0;
      piped_csync8 <= 1'b0;
      piped_csync9 <= 1'b0;
      piped_csynca <= 1'b0;
      piped_csyncb <= 1'b0;
      piped_csyncc <= 1'b0;
      piped_csyncd <= 1'b0;
      piped_csynce <= 1'b0;
    end else if (sync_pwr_pix | iclk_pwr_pix) begin
      csync_x <= 1'b0;
      csync_1 <= 1'b0;
      csync_10 <= 1'b0;
      csync_11 <= 1'b0;
      csync_12 <= 1'b0;
      csync_2 <= 1'b0;
      csync_3 <= 1'b0;
      csync_4 <= 1'b0;
      csync_5 <= 1'b0;
      hsync_x <= 1'b0;
      hsync_1 <= 1'b0;
      hsync_10 <= 1'b0;
      hsync_11 <= 1'b0;
      hsync_12 <= 1'b0;
      hsync_2 <= 1'b0;
      hsync_3 <= 1'b0;
      hsync_4 <= 1'b0;
      hsync_5 <= 1'b0;
      piped_hsync1 <= 1'b0;
      piped_hsync2 <= 1'b0;
      piped_hsync3 <= 1'b0;
      piped_hsync4 <= 1'b0;
      piped_hsync5 <= 1'b0;
      piped_hsync6 <= 1'b0;
      piped_hsync7 <= 1'b0;
      piped_hsync8 <= 1'b0;
      piped_hsync9 <= 1'b0;
      piped_hsynca <= 1'b0;
      piped_hsyncb <= 1'b0;
      piped_hsyncc <= 1'b0;
      piped_hsyncd <= 1'b0;
      piped_hsynce <= 1'b0;
      piped_csync1 <= 1'b0;
      piped_csync2 <= 1'b0;
      piped_csync3 <= 1'b0;
      piped_csync4 <= 1'b0;
      piped_csync5 <= 1'b0;
      piped_csync6 <= 1'b0;
      piped_csync7 <= 1'b0;
      piped_csync8 <= 1'b0;
      piped_csync9 <= 1'b0;
      piped_csynca <= 1'b0;
      piped_csyncb <= 1'b0;
      piped_csyncc <= 1'b0;
      piped_csyncd <= 1'b0;
      piped_csynce <= 1'b0;
    end else begin
      csync_x <= csync_sl;
      csync_1 <= csync_x;
      csync_10 <= csync_1;
      csync_11 <= csync_10;
      csync_12 <= csync_11;
      csync_2 <= csync_12;
      csync_3 <= csync_2;
      csync_4 <= csync_3;
      csync_5 <= csync_4;
      hsync_x <= hsync_sl;
      hsync_1 <= hsync_x;
      hsync_10 <= hsync_1;
      hsync_11 <= hsync_10;
      hsync_12 <= hsync_11;
      hsync_2 <= hsync_12;
      hsync_3 <= hsync_2;
      hsync_4 <= hsync_3;
      hsync_5 <= hsync_4;
      piped_hsync1 <= hsync_5;
      piped_hsync2 <= piped_hsync1;
      piped_hsync3 <= piped_hsync2;
      piped_hsync4 <= piped_hsync3;
      piped_hsync5 <= piped_hsync4;
      piped_hsync6 <= piped_hsync5;
      piped_hsync7 <= piped_hsync6;
      piped_hsync8 <= piped_hsync7;
      piped_hsync9 <= piped_hsync8;
      piped_hsynca <= piped_hsync9;
      piped_hsyncb <= piped_hsynca;
      piped_hsyncc <= piped_hsyncb;
      piped_hsyncd <= piped_hsyncc;
      piped_hsynce <= piped_hsyncd;
      piped_csync1 <= csync_5;
      piped_csync2 <= piped_csync1;
      piped_csync3 <= piped_csync2;
      piped_csync4 <= piped_csync3;
      piped_csync5 <= piped_csync4;
      piped_csync6 <= piped_csync5;
      piped_csync7 <= piped_csync6;
      piped_csync8 <= piped_csync7;
      piped_csync9 <= piped_csync8;
      piped_csynca <= piped_csync9;
      piped_csyncb <= piped_csynca;
      piped_csyncc <= piped_csyncb;
      piped_csyncd <= piped_csyncc;
      piped_csynce <= piped_csyncd;
    end
  
  // always @*
  always @(posedge pixclk)
    case(hsyn_pos)
      4'b0000:   piped_sog  = csync_4; 		//csync_5;
      4'b0001:   piped_sog  = csync_5; 		//piped_csync1;
      4'b0010:   piped_sog  = piped_csync1;
      4'b0011:   piped_sog  = piped_csync2;
      4'b0100:   piped_sog  = piped_csync3;
      4'b0101:   piped_sog  = piped_csync4;
      4'b0110:   piped_sog  = piped_csync5;
      4'b0111:   piped_sog  = piped_csync6;
      4'b1000:   piped_sog  = piped_csync7;
      4'b1001:   piped_sog  = piped_csync8;
      4'b1010:   piped_sog  = piped_csync9;
      4'b1011:   piped_sog  = piped_csynca;
      4'b1100:   piped_sog  = piped_csyncb;
      4'b1101:   piped_sog  = piped_csyncc;
      4'b1110:   piped_sog  = piped_csyncd;
      4'b1111:   piped_sog  = piped_csynce;
    endcase

  // always @*
  always @(posedge pixclk)
    case(hsyn_pos)
      4'b0000:   piped_hsync  = hsync_4;	// hsync_5;
      4'b0001:   piped_hsync  = hsync_5;	// piped_hsync1;
      4'b0010:   piped_hsync  = piped_hsync1;
      4'b0011:   piped_hsync  = piped_hsync2;
      4'b0100:   piped_hsync  = piped_hsync3;
      4'b0101:   piped_hsync  = piped_hsync4;
      4'b0110:   piped_hsync  = piped_hsync5;
      4'b0111:   piped_hsync  = piped_hsync6;
      4'b1000:   piped_hsync  = piped_hsync7;
      4'b1001:   piped_hsync  = piped_hsync8;
      4'b1010:   piped_hsync  = piped_hsync9;
      4'b1011:   piped_hsync  = piped_hsynca;
      4'b1100:   piped_hsync  = piped_hsyncb;
      4'b1101:   piped_hsync  = piped_hsyncc;
      4'b1110:   piped_hsync  = piped_hsyncd;
      4'b1111:   piped_hsync  = piped_hsynce;
    endcase

endmodule
