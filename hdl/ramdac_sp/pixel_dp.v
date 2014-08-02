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
//  Title       :  Pixel Datapath
//  File        :  pixel_dp.v
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

module pixel_dp
  (
   input		reset,
   input		blank,
   input		pixclk,
   input [23:0]	        pix_din,
   input [2:0]	        pixformat,
   input		b8dcol,
   input		b16dcol,
   input		ziblin,
   input		fsf,
   input		b32dcol,
   input 		display_cursor,
   input		p0_apply_cursor,
   input		p0_highlight,
   input		p0_translucent,
   input [7:0]	        p0_red_cursor,
   input [7:0]	        p0_grn_cursor,
   input [7:0]	        p0_blu_cursor,
   input [7:0]	        p0_red_pal,
   input [7:0]	        p0_grn_pal,
   input [7:0]  	p0_blu_pal,
   input		blankr,
   input [7:0]  	pix_mask,
   input		blankb,
   input		blankg,
   input                ldi_normalvgsel,         // 2X Horizontal Zoom in VGA
   input                vga_mode,                // In VGA mode
   
   output [7:0]	        p0_red_pal_adr,
   output [7:0]	        p0_grn_pal_adr,
   output [7:0]	        p0_blu_pal_adr,
   output reg [7:0]	p0_red,
   output reg [7:0]	p0_green,
   output reg [7:0]	p0_blue,
   output reg		blankx
   );

  reg [63:0] 		pix_reg, pix_reg1;  // Pipeline pixel data
  reg [7:0] 		vga_reg, vga_reg1;  // Pipeline VGA data
  reg 			blankl, blanks;     // Pipeline blanks
  reg [23:0] 		pix_reg3, pix_reg4;
  reg [23:0] 		pix_stage1;
  reg 			direct_mode;
  reg 			b8bpp2;
  reg 			b32bpp2;
  reg 			bpp16_2, bpp16_4;
  reg 			bpp16_5, bpp16_6, bpp16_7, bpp16_8;
  reg 			vga_mode1;
  reg 			b8bpp1, b16bpp1, b32bpp1;
  reg 			bpp16_21, bpp16_41, bpp16_51;
  reg 			bpp16_61, bpp16_71, bpp16_81;
  reg [23:0] 		pixel_stage3;       // Third stage pixel pipe
  reg [23:0] 		rgb4_0, rgb4_1, rgb4_2, rgb4_3; // Pipelined pixels
  reg [23:0] 		temp_store;
  reg [7:0] 		pix_mask1, pix_mask2;
  
  wire [7:0] 		select;
  wire [7:0] 		pass_address;
  reg [6:0] 		p0_sel_red, p0_sel_blu, p0_sel_grn;
  reg [7:0] 		p0_red_cursor_d;
  reg [7:0] 		p0_grn_cursor_d;
  reg [7:0] 		p0_blu_cursor_d;
  reg [7:0] 		p0_red_pal_d;
  reg [7:0] 		p0_grn_pal_d;
  reg [7:0] 		p0_blu_pal_d;
  
  // Datapath Stage 1:
  // handle the 64-bit and vga data in synchronization.
  // latch the data in on the LCLK, and pass it thru 2 register set
  // using the pix clk.
  //
  // No need to sync on blank signal. the data will be masked at the VDAC input
  // using a synchronzed blanking decode.

  // 3rd  sync level
  always @(posedge pixclk or negedge reset) 
    if (!reset) begin
      pix_reg3   <= 24'b0;
      pix_reg4   <= 24'b0;	  
      pix_stage1 <= 24'b0;
    end else begin
      pix_reg3 <= pix_din;    // Moved to one later because of REGRAM in CRT
      pix_reg4 <=pix_reg3;
      pix_stage1 <= pix_reg4;
    end

  always @(posedge pixclk or negedge reset)
    if (!reset) begin
      blankx     <= 1'b0;
    end else begin         
      blankx     <= blank;
    end
  
  // Datapath stage 3:
  //  This pixel mux select the incoming pixel data
  //  and route it to the RGB bus level 1.
  //  The select lines are:
  //  1.  VGA Mode, selects VGA data
  //  2.  b8bpp selects 8 bit per pixel
  //  3.  b32bpp selects 32 bit per pixel
  //  Other conditions for sparse cases were removed.
  //  4b. bpp16_2 selects mode 2 of 16 bits per pixel
  //  4d. bpp16_4 selects mode 4 of 16 bits per pixel
  //  4e. bpp16_5 selects mode 5 of 16 bits per pixel
  //  4f. bpp16_6 selects mode 6 of 16 bits per pixel
  //  4g. bpp16_7 selects mode 7 of 16 bits per pixel
  //  4h. bpp16_8 selects mode 8 of 16 bits per pixel
  //  The data to be muxed is
  //   1. vga data
  //   2. pix_c(23-16), pix_b(15- 8) pix_a(7- 0)
  //   5. Partion bits part(2-0)
  
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      direct_mode <= 1'b0;
      b8bpp2      <= 1'b0;
      b32bpp2     <= 1'b0;
      bpp16_2     <= 1'b0;
      bpp16_4     <= 1'b0;
      bpp16_5     <= 1'b0;
      bpp16_6     <= 1'b0;
      bpp16_7     <= 1'b0;
      bpp16_8     <= 1'b0;
      vga_mode1   <= 1'b0;
      b8bpp1      <= 1'b0;
      b16bpp1     <= 1'b0;
      b32bpp1     <= 1'b0;
      bpp16_21    <= 1'b0;
      bpp16_41    <= 1'b0;
      bpp16_51    <= 1'b0;
      bpp16_61    <= 1'b0;
      bpp16_71    <= 1'b0;
      bpp16_81    <= 1'b0;
    end else begin
      direct_mode <= ((b8bpp2 & b8dcol) |
                      (b32bpp2 & b32dcol) |
                      bpp16_51 | bpp16_61 |
                      bpp16_71 | bpp16_81
                      ) & ~vga_mode1 ;// vga mode is indirect mode
      b8bpp2     <= b8bpp1   ;
      b32bpp2    <= b32bpp1  ;
      bpp16_2    <= bpp16_21 ;
      bpp16_4    <= bpp16_41 ;
      bpp16_5    <= bpp16_51 ;
      bpp16_6    <= bpp16_61 ;
      bpp16_7    <= bpp16_71 ;
      bpp16_8    <= bpp16_81 ;
      vga_mode1  <= vga_mode ;
      b8bpp1     <= !pixformat[2] &  pixformat[1] &  pixformat[0];
      b32bpp1    <= pixformat[2] &  pixformat[1] & !pixformat[0];
      b16bpp1    <= pixformat[2] & !pixformat[1] & !pixformat[0];
      bpp16_21   <= b16bpp1 & (!b16dcol) & (!fsf);
      bpp16_41   <= b16bpp1 & (!b16dcol) & ( fsf);
      bpp16_51   <= b16bpp1 & ( b16dcol) & (!fsf) & ( !ziblin);
      bpp16_61   <= b16bpp1 & ( b16dcol) & ( fsf) & ( !ziblin);
      bpp16_71   <= b16bpp1 & ( b16dcol) & (!fsf) & (  ziblin);
      bpp16_81   <= b16bpp1 & ( b16dcol) & ( fsf) & (  ziblin);
    end
  end

  // parse pixels according to the modes.
  assign select = {b8bpp2, b32bpp2, bpp16_2, bpp16_4, bpp16_5, 
		   bpp16_6, bpp16_7, bpp16_8};
  
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      pixel_stage3 <= 24'b0;
    end else begin
      casex (select)
        8'b10000000: pixel_stage3 <= pix_stage1;   // 8 Bpp
        8'b01000000: pixel_stage3 <= pix_stage1;   // 32 Bpp
	// 16-2 bpp
        8'b00100000: pixel_stage3 <= { 3'b0, pix_stage1[14:10], // P0 Red
				       3'b0, pix_stage1[9:5],   // P0 Green
				       3'b0, pix_stage1[4:0]};  // P0 Blue
	// 16-4 bpp
        8'b00010000: pixel_stage3 <= { 3'b0, pix_stage1[15:11], // P0 Red
				       2'b0, pix_stage1[10:5],  // P0 Green
				       3'b0, pix_stage1[4:0]};  // P0 Blue
        // 16-5 bpp
        8'b00001000: pixel_stage3 <= { pix_stage1[14:10], 3'b0, // P0 Red
				       pix_stage1[9:5], 3'b0,   // P0 Green
				       pix_stage1[4:0], 3'b0};  // P0 Blue
	// 16-6 bpp
        8'b00000100: pixel_stage3 <= { pix_stage1[15:11], 3'b0, // P0 Red
				       pix_stage1[10:5], 2'b0,  // P0 Green
				       pix_stage1[4:0], 3'b0};  // P0 Blue
	// 16-7 bpp
        8'b00000010: pixel_stage3 <= { pix_stage1[14:10], 
				       pix_stage1[14:12], // P0 Red
				       pix_stage1[9:5],
				       pix_stage1[9:7],   // P0 Green
				       pix_stage1[4:0],
				       pix_stage1[4:2]};  // P0 Blue
	// 16-8 bpp
	8'b00000001: pixel_stage3 <= { pix_stage1[15:11], 
				       pix_stage1[15:13], // P0 Red
				       pix_stage1[10:5],
				       pix_stage1[10:9],   // P0 Green
				       pix_stage1[4:0],
				       pix_stage1[4:2]};  // P0 Blue
	// 8bpp greyscale
	default: pixel_stage3 <= pix_stage1;
      endcase
    end 
  end
  
  // Datapath stage 4:
  // Generates the final rgb data to the VDAC output.
  // added power management, zero address to palettes in direct mode.
  // Problem:  Highlight and Translucent Cursors were not coming on.
  // wire act_high_d    = display_cursor & highlight &  direct_mode;
  // wire act_high_id   = display_cursor & highlight & !direct_mode; 
  // wire act_transl_d  = display_cursor & translucent &  direct_mode; 
  // wire act_transl_id = display_cursor & translucent & !direct_mode; 
  // Summary of changes:
  // Remove [color]_pal_adr pipe stage.  This causes the palette ram address to
  // arrive one cycle earlier.  The "toggle" signal to the odd/even palette
  // address registers in ram_ctl.v is inverted to take advantage of the 
  // change in this module.
 
  wire p0_act_cursor    = display_cursor & p0_apply_cursor;
  wire p0_act_high_d    = display_cursor & p0_highlight &  direct_mode;
  wire p0_act_high_id   = display_cursor & p0_highlight & !direct_mode;
  wire p0_act_transl_d  = display_cursor & p0_translucent &  direct_mode;
  wire p0_act_transl_id = display_cursor & p0_translucent & !direct_mode;
  
  // added for power management, zero address to palettes in direct mode
  assign     pass_address = {8{!direct_mode}};

  // generate pipilined cursor direct and indirect address
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      
      rgb4_0    <= 24'b0; 
      rgb4_1    <= 24'b0; 
      rgb4_2    <= 24'b0; 
      rgb4_3    <= 24'b0; 
      
      pix_mask1 <= 8'b0;  // Sync the CPU register
      pix_mask2 <= 8'b0;  // Sync the CPU register
    end else begin
      pix_mask1 <= pix_mask;
      pix_mask2 <= pix_mask1;
      
      rgb4_0 <= pixel_stage3;
      rgb4_1 <= rgb4_0;
      rgb4_2 <= rgb4_1;
      rgb4_3 <= rgb4_2;
      
    end
  end // else: !if(!reset)

  // Generate addresses for pixels
  assign p0_blu_pal_adr = pixel_stage3[7:0]   & pix_mask2[7:0] & pass_address;
  assign p0_grn_pal_adr = pixel_stage3[15:8]  & pix_mask2[7:0] & pass_address;
  assign p0_red_pal_adr = pixel_stage3[23:16] & pix_mask2[7:0] & pass_address;

  wire 	 drmode =  direct_mode & !blankr;
  wire 	 dbmode =  direct_mode & !blankb;
  wire 	 dgmode =  direct_mode & !blankg;

  // Adding a pipe stage for timing
  always @(posedge pixclk) begin
    p0_sel_red <= {blankr, p0_act_cursor, p0_act_high_d, p0_act_high_id, 
		   p0_act_transl_id, p0_act_transl_d, drmode};
    p0_sel_blu <= {blankb, p0_act_cursor, p0_act_high_d, p0_act_high_id, 
		   p0_act_transl_id, p0_act_transl_d, dbmode};
    p0_sel_grn <= {blankg, p0_act_cursor, p0_act_high_d, p0_act_high_id, 
		   p0_act_transl_id, p0_act_transl_d, dgmode};
    
    p0_red_pal_d <= p0_red_pal;
    p0_blu_pal_d <= p0_blu_pal;
    p0_grn_pal_d <= p0_grn_pal;

    p0_red_cursor_d <= p0_red_cursor;
    p0_blu_cursor_d <= p0_blu_cursor;
    p0_grn_cursor_d <= p0_grn_cursor;

  end
  
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      p0_red   <= 8'b0;
      p0_green <= 8'b0;
      p0_blue  <= 8'b0;
    end else begin
      casex (p0_sel_red)
        7'b1xxxxxx  : p0_red <= 8'b0;
        7'b01xxxxx  : p0_red <= p0_red_cursor_d;
        7'b001xxxx  : p0_red <= ~rgb4_3[23:16];
        7'b0001xxx  : p0_red <= ~p0_red_pal_d;
        7'b00001xx  : p0_red <= {p0_red_cursor_d[7], p0_red_pal_d[7:1]};
        7'b000001x  : p0_red <= {p0_red_cursor_d[7], rgb4_3[23:17]};
        7'b0000001  : p0_red <= rgb4_3[23:16];
        default :     p0_red <= p0_red_pal_d;
      endcase

      casex (p0_sel_grn)
        7'b1xxxxxx  : p0_green <= 8'b0;
        7'b01xxxxx  : p0_green <= p0_grn_cursor_d;
        7'b001xxxx  : p0_green <= ~rgb4_3[15:8];
        7'b0001xxx  : p0_green <= ~p0_grn_pal_d;
        7'b00001xx  : p0_green <= {p0_grn_cursor_d[7], p0_grn_pal_d[7:1]};
        7'b000001x  : p0_green <= {p0_grn_cursor_d[7], rgb4_3[15:9]};
        7'b0000001  : p0_green <= rgb4_3[15:8];
        default :     p0_green <= p0_grn_pal_d;
      endcase

      casex(p0_sel_blu)
        7'b1xxxxxx  : p0_blue <= 8'b0;
        7'b01xxxxx  : p0_blue <= p0_blu_cursor_d;
        7'b001xxxx  : p0_blue <= ~rgb4_3[7:0];
        7'b0001xxx  : p0_blue <= ~p0_blu_pal_d;
        7'b00001xx  : p0_blue <= {p0_blu_cursor_d[7], p0_blu_pal_d[7:1]};
        7'b000001x  : p0_blue <= {p0_blu_cursor_d[7], rgb4_3[7:1]};
        7'b0000001  : p0_blue <= rgb4_3[7:0];
        default :     p0_blue <= p0_blu_pal_d;
      endcase

    end
  end
endmodule // pixel_dp

