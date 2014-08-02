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
//  Title       :  Ramdac Blank Generator
//  File        :  blnk.v
//  Author      :  Frank Bruno
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module Process Active lines and frames and generates the
//  controls for the pipeline, the active cursor display.
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

module blnk 
  (
   input		pixclk,
   input                reset,
   input                blankx, 
   input		misr_cntl,
   input		red_comp,
   input		grn_comp,
   input		blu_comp,
   input                vga_en,
   
   output reg		vsync,
   output		hsync,
   output reg		vsync_m1,
   output reg		misr_done,
   output		enable_crc,
   output reg		init_crc,
   output reg		lred_comp,
   output reg		lgrn_comp,
   output reg		lblu_comp,
   output reg		blankx4d,
   output reg		blankx6
   );

  // level changes required to support FDP
  reg 			blankx5,
			blankx1,
			blankx2, 
			blankx3,
			blankx4,
			blankx4a,
			blankx4b,
			blankx4c,
			enable_crc_i,
			misr_cntl1,
			misr_cntl2,
			vsync1;
  
  reg [11:0] 		pix_counter;

  assign 		enable_crc = enable_crc_i & blankx6;
  assign 		hsync   = !blankx;
  
  //---------DAC SNS controls-----------
  always @(posedge pixclk or negedge reset)
    if (!reset) begin
      lblu_comp <= 1'b0;
      lgrn_comp <= 1'b0;
      lred_comp <= 1'b0;
    end else if(!blankx5) begin // synchronized to the pipe
      lblu_comp <= blu_comp;
      lgrn_comp <= grn_comp;
      lred_comp <= red_comp;
    end

  //   generate pipelined blank control
  always @(posedge pixclk or  negedge reset) begin
    if (!reset) begin
      blankx1 <= 1'b0;
      blankx2 <= 1'b0;
      blankx3 <= 1'b0;
      blankx4 <= 1'b0;
      blankx4a <= 1'b0;
      blankx4b <= 1'b0;
      blankx4c <= 1'b0;
      blankx4d <= 1'b0;
      blankx5 <= 1'b0;
      blankx6 <= 1'b0;
      vsync1 <= 1'b0;
      misr_cntl1 <= 1'b0;
      misr_cntl2 <= 1'b0;
    end else begin
      misr_cntl1 <= misr_cntl;
      misr_cntl2 <= misr_cntl1;
      vsync1  <= vsync;
      blankx1 <= blankx;
      blankx2 <= blankx1;
      blankx3 <= blankx2;
      blankx4 <= blankx3;
      blankx4a <= blankx4;
      blankx4b <= blankx4a;
      blankx4c <= blankx4b;
      blankx4d <= (vga_en) ? blankx4c : blankx4; // FB: added to match new pip stage in pixel_dp
      blankx5 <= blankx4d;
      blankx6 <= blankx5;
    end
  end
	
  // detect lines , vsync
  always @(posedge pixclk or negedge reset)
    if (!reset)            pix_counter <= 12'h0;
    else if (blankx  == 1) pix_counter <= 12'h0;  // reset pixel counter
    else                   pix_counter <= pix_counter + 12'b1; // run pixel counter
  
  always @(posedge pixclk or negedge reset) begin
    if (!reset) vsync<= 1'b0;
    // turn off  vsync
    else if (blankx == 1) vsync <= 1'b0;
    // turn off vsync
    else if ((blankx == 0) & (pix_counter == 12'd2050)) vsync <= 1'b1;
  end

  //-----------------------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) vsync_m1 <= 1'b0;
    // turn off  vsync
    else if (blankx == 1) vsync_m1 <= 1'b0;
    // turn off vsync
    else if ((blankx == 0) & (pix_counter == 12'd2049))vsync_m1 <= 1'b1;
  end
  
  //----------misr controls------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) init_crc <= 1'b0;
    else if (vsync1 & !vsync & misr_cntl2) init_crc <= 1'b1;
    else init_crc <= 1'b0;      // one pulse crc
  end

  //----------misr controls------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) enable_crc_i <= 1'b0;
    else if (init_crc) enable_crc_i <= 1'b1;
    //  stop at the next frame.
    else if (vsync & !vsync1) enable_crc_i <= 1'b0;
  end

  //----------misr controls------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) misr_done <= 1'b0;
    // reset at start of frame
    else if (vsync1 & !vsync) misr_done <= 1'b0;
    else if (enable_crc_i & vsync & !vsync1) misr_done <= 1'b1;
  end

endmodule
