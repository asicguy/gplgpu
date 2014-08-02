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
//  Title       :  Texture Cache State Machine
//  File        :  de3d_tc_sm.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
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
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module de3d_tc_sm
  (
   input		de_clk,		// Drawing engine clock
   input		mc_clk,		// Drawing engine clock
   input		de_rstn,	// Reset
   input	[3:0]	tc_op,		// TC operations to preform:
   input		tc_fetch,	// Fetch signal to get texels
   input		clip_in,	// ignore load
   input		pc_busy,	// Pipeline busy after stage 0
   input                pal_load,       // Load Palette
   input		tc_inv,		// Invalidate texture
   input		done,		// Memory cycles done.	
   input	[7:0]	tex_fifo_wrused,// TC operations to preform:
   input		tex_en,		// Texture Enable.
   input                pal_ack,        // From MC
   input                mc_pal_push,    // Push into palette RAM
   input [127:0]        mc_data,        // MC Data to swizzle for palette
   
   output reg		invalidate,	// invalidate texture cache
   output reg		tc_busy,	// Texture cache busy to previous states
   output reg		load_tag,	// Tag load strobe.
   output reg		tag_ads,	// tag address strobe.
   output reg	        tex_req,        // Request a read from the MC 
   output reg           pal_req,        // When high we are requesting a pal
   output               pal_half,       // Select upper or lower half of palette
   output reg		tc_ack,		// TC command accepted
   output reg		tc_ready, 	// Texel cache ready to renderer
   output reg		tc_ready_e, 	// Early cache ready to renderer
   output reg	     	ld_push_count,	// Load the push count.
   output reg	[3:0]	push_count,	// Push count start value.
   output reg	[1:0]	req_count,	// Request Number.
   output reg		pop_uv,		// Pop The UV FIFO.
   output reg [127:0]   pal_mux,        // swizzled data for palette RAMs
   output reg           pal_we,         // Write enables for palette RAMs
   output reg [7:0]     pal_addr_0,     // Palette RAM address 0
   output reg [7:0]     pal_addr_1,     // Palette RAM address 1 
   output reg [7:0]     pal_addr_2,     // Palette RAM address 2 
   output reg [7:0]     pal_addr_3      // Palette RAM address 3
   );

  reg 			tc_readyi;
  reg 			tc_readyii, tc_readyiii;
  reg 			tc_busyi;
  reg 			invalidatei;
  reg 			load_tagii;
  reg 			load_tagi;
  reg 			tex_req_fifo_almost_full;
  reg 			tex_reqi;
  reg 			tex_reqii;
  reg [1:0] 		req_counti;
  reg 			pal_tog, pal_toggle;
  reg 			pal_reset_in;
  reg [2:0] 		pal_sync;
  reg [1:0] 		done_sync;
  reg 			pal_done, pal_done_tog;
  reg [2:0] 		pal_count;
  reg [7:0] 		pal_addr; // Used to make the palette write address
  reg [127:0] 		pal_mux_i;
  reg 			pal_we_i;
  
  wire [5:0] 		pal_index; // This makes up the address into the RAM
  wire [1:0] 		mux_sel;   // This selects the data mux to swizzle
  wire [1:0] 		mux_sel_0, mux_sel_1, mux_sel_2, mux_sel_3;
  
`ifdef RTL_ENUM
  enum 			{
			 DE_IDLE     = 4'b0000,
			 DE_DO4      = 4'b0001,
			 DE_DO3      = 4'b0010,
			 DE_DO2      = 4'b0011,
			 DE_DO1      = 4'b0100,
			 DE_DONE     = 4'b0101,
			 DE_DONE1    = 4'b0110,
			 DE_DONE2    = 4'b0111,
			 DE_DONE3    = 4'b1000,
			 DE_INV      = 4'b1001,
			 DE_PAL        = 4'b1011,
			 DE_W4PAL      = 4'b1100,
			 DE_LOADED   = 4'b1010
			 } de_cs, de_ns;
`else
  reg [3:0] 		de_cs;		// State machine states for MC
  reg [3:0] 		de_ns;		// State machine states for MC
  parameter       DE_IDLE     = 4'b0000,
                    DE_DO4      = 4'b0001,
                    DE_DO3      = 4'b0010,
                    DE_DO2      = 4'b0011,
                    DE_DO1      = 4'b0100,
                    DE_DONE     = 4'b0101,
                    DE_DONE1    = 4'b0110,
                    DE_DONE2    = 4'b0111,
                    DE_DONE3    = 4'b1000,
		    DE_INV      = 4'b1001,
		    DE_PAL      = 4'b1011,
	            DE_W4PAL    = 4'b1100,
                    DE_LOADED   = 4'b1010;
`endif
  
  always @* tex_req_fifo_almost_full = (tex_fifo_wrused > 7);
  
  always @(posedge de_clk) begin
    tex_req    <= tex_reqii;
    tex_reqii  <= tex_reqi;
    invalidate <= invalidatei;
    tc_busy    <= tc_busyi;
    load_tag   <= load_tagii;
    load_tagii <= load_tagi;
    tag_ads    <= load_tagi | load_tagii | load_tag;
    req_count  <= req_counti;
    tc_ready   <= tc_ready_e;
    tc_ready_e <= tc_readyiii;
    tc_readyiii<= tc_readyii;
    tc_readyii <= tc_readyi;
  end // always @ (posedge de_clk)
  
  // Current state register.
  always @(posedge de_clk or negedge de_rstn)
    begin
      if (!de_rstn) 	de_cs <= DE_IDLE;
      else 		de_cs <= de_ns;
    end

  //  MC State machine
  always @(posedge de_clk or negedge de_rstn)
    if (!de_rstn) begin
      pal_toggle <= 0;
      done_sync  <= 2'b0;
    end else begin
      if (pal_tog) pal_toggle <= ~pal_toggle;
      done_sync <= {done_sync[0], pal_done_tog};
      pal_done  <= ^done_sync;
    end

  parameter MC_IDLE = 3'h0,
	      MC_ACK0 = 3'h1,
	      MC_ACK1 = 3'h2,
	      MC_ACK2 = 3'h3,
	      MC_ACK3 = 3'h4;
  reg [2:0] mc_cs;

  assign pal_half = pal_count[2];

  assign {pal_index[5], mux_sel[1:0], pal_index[4:0]} = pal_addr;

  assign mux_sel_0 = mux_sel;
  assign mux_sel_1 = mux_sel + 2'h1;
  assign mux_sel_2 = mux_sel + 2'h2;
  assign mux_sel_3 = mux_sel + 2'h3;
  
  always @(posedge mc_clk or negedge de_rstn)
    if (!de_rstn) begin
      pal_sync     <= 3'b0;
      pal_req      <= 1'b0;
      pal_done_tog <= 1'b0;
      pal_reset_in <= 1'b0;
      mc_cs        <= MC_IDLE;
      pal_count    <= 3'b0;
      pal_mux      <= 128'b0;
      pal_mux_i    <= 128'b0;
      pal_addr_0   <= 8'h0;
      pal_addr_1   <= 8'h0;
      pal_addr_2   <= 8'h0;
      pal_addr_3   <= 8'h0;
      pal_addr     <= 8'h0;
      pal_we       <= 1'b0;
      pal_we_i     <= 1'b0;
    end else begin // if (!de_rstn)
      pal_we     <= mc_pal_push;
      //pal_we       <= pal_we_i;
      
      pal_sync     <= {pal_sync[1:0], pal_toggle};
      pal_count    <= pal_count + pal_ack;
      pal_reset_in <= 1'b0;

      pal_addr_0 <= {pal_index, mux_sel_0};
      pal_addr_1 <= {pal_index, mux_sel_1};
      pal_addr_2 <= {pal_index, mux_sel_2};
      pal_addr_3 <= {pal_index, mux_sel_3};

      case (mux_sel)
	2'h0: pal_mux <= mc_data;
	2'h1: pal_mux <= {mc_data[31:0], mc_data[127:32]};
	2'h2: pal_mux <= {mc_data[63:0], mc_data[127:64]};
	2'h3: pal_mux <= {mc_data[95:0], mc_data[127:96]};
      endcase // case (mux_sel)
      //pal_mux <= pal_mux_i;
      
      case (mc_cs)
	MC_IDLE: begin
	  pal_count  <= 3'b0;
	  if (^pal_sync[2:1]) begin
	    pal_reset_in <= 1'b1;
	    pal_req  <= 1'b1;
	    mc_cs    <= MC_ACK0;
	  end
	end
	MC_ACK0: begin
	  pal_req  <= 1'b1;
	  if (&pal_count) mc_cs <= MC_ACK1;
	end
	MC_ACK1: begin
	  pal_req  <= 1'b1;
	  if (pal_ack) begin
	    pal_done_tog <= ~pal_done_tog;
	    pal_req      <= 1'b0;
	    mc_cs        <= MC_IDLE;
	  end
	end
      endcase // case (mc_cs)

      // Addressing for palette rams
      if (pal_reset_in) pal_addr <= 8'h0;
      else              pal_addr <= pal_addr + mc_pal_push;

    end // else: !if(!de_rstn)
  
  /* Load state machine for memory */
  always @* begin
    tc_ack 	 = 1'b0;
    ld_push_count  = 1'b0;
    push_count   	 = 4'b0000;
    tc_readyi      = 1'b0;
    invalidatei    = 1'b0;
    tc_busyi       = 1'b0;
    load_tagi      = 1'b0;
    tex_reqi   	 = 1'b0;
    req_counti     = 2'b00;
    pop_uv 	 = 1'b0;
    pal_tog        = 1'b0;
    case (de_cs) /* synopsys parallel_case */
      DE_IDLE: begin
	if (tc_inv) begin
	  de_ns = DE_INV;
	  invalidatei = 1'b1;
	  tc_busyi =1'b1;
	end 
	else if (pal_load) begin
	  de_ns    = DE_PAL;
	  tc_busyi = 1'b1;
	  pal_tog  = 1'b1;
	end 
	else if (pc_busy) begin
	  de_ns = DE_IDLE;
	  tc_readyi = 1'b0;
	end 
	else if (!tex_en & tc_fetch) begin
	  de_ns = DE_IDLE;
	  tc_readyi = 1'b1;
	end 
	else if(tc_fetch) begin
  	  tc_ack 	  = 1'b1;
	  {de_ns, ld_push_count, push_count, load_tagi, tc_readyi, pop_uv} 
	    = check_texels(clip_in, tc_op);
	end else 
	  de_ns = DE_IDLE;
      end 
      DE_DO4: begin
	if(!tex_req_fifo_almost_full) begin
  	  tex_reqi   = 1'b1;
	  de_ns = DE_DO3;
	  req_counti = 2'b11;
	end
      	else de_ns = DE_DO4;
      end
      
      DE_DO3: begin
	if(!tex_req_fifo_almost_full) begin
  	  tex_reqi   = 1'b1;
	  de_ns = DE_DO2;
	  req_counti = 2'b10;
	end
      	else de_ns = DE_DO3;
      end
      
      DE_DO2: begin
	if(!tex_req_fifo_almost_full) begin
  	  tex_reqi   = 1'b1;
	  de_ns = DE_DO1;
	  req_counti = 2'b01;
	end
      	else de_ns = DE_DO2;
      end
      DE_DO1: begin
	if(!tex_req_fifo_almost_full) begin
  	  tex_reqi   = 1'b1;
	  de_ns = DE_DONE;
	  req_counti = 2'b00;
	end
      	else de_ns = DE_DO1;
      end
      DE_DONE: begin
	if(done) begin
      	  // if (tc_fetch) pop_uv = 1'b1;
	  de_ns = DE_LOADED;
	end
      	else     de_ns = DE_DONE;
      end
      // DE_DONE1:
      // DE_DONE2:
      // DE_DONE3:
      // generate pulse to clear tags
      DE_INV: begin
	de_ns = DE_IDLE;
	//tc_readyi = 1'b1;
      end
      //
      DE_PAL: begin
	tc_busyi = 1'b1;
	// Transfer control to another SM on the MC domain to make the 4 requests
	if (pal_done)
	  de_ns = DE_IDLE;
	else 
	  de_ns = DE_PAL;
      end
      DE_LOADED:
	begin
      	  if (pc_busy)
	    begin
	      de_ns = DE_LOADED;
	      tc_readyi = 1'b0;
	    end
      	  else if (tc_inv)
	      begin
		de_ns = DE_IDLE;
		invalidatei = 1'b1;
		tc_busyi =1'b1;
	      end
	  else if (pal_load) 
	      begin
	        de_ns    = DE_PAL;
	        tc_busyi = 1'b1;
	        pal_tog  = 1'b1;
	      end
      	  else if (!tex_en & tc_fetch)
	      begin
		de_ns = DE_IDLE;
		tc_readyi = 1'b1;
	      end
      	  else if (tc_fetch)
	      begin
  		tc_ack 	  = 1'b1;
		{de_ns, ld_push_count, push_count, load_tagi, tc_readyi, pop_uv} 
		  = check_texels(clip_in, tc_op);
	      end
      	  else de_ns = DE_IDLE;
	end
      default: de_ns = DE_IDLE;
    endcase
  end // always @ *
  
  function [11:0] check_texels;
    input		clip_in;
    input [3:0] 	tc_op;
    
    reg [3:0] 		de_ns;
    reg 		ld_push_count;
    reg [3:0] 		push_count;
    reg 		load_tagi;
    reg 		tc_readyi;
    reg 		pop_uv;
    
    begin
      tc_readyi = 1'b0;
      pop_uv = 1'b0;
      load_tagi = 1'b0;
      casex({clip_in, tc_op}) /* synopsys parallel_case */
	// Missed one of four texels, load one cache line.
       	5'b0_1000, 5'b0_0100, 5'b0_0010, 5'b0_0001:
	  begin
	    de_ns = DE_DO1;
	    ld_push_count = 1'b1;
	    push_count   = 4'b0110;
	    load_tagi   = 1'b1;
	  end
	// Missed two of four texels, load two cache lines.
       	5'b0_0011, 5'b0_0101, 5'b0_0110, 5'b0_1001, 5'b0_1010, 5'b0_1100:
	  begin
       	    de_ns = DE_DO2;
	    ld_push_count = 1'b1;
	    push_count   = 4'b100;
	    load_tagi   = 1'b1;
       	  end
	// Missed three of four texels, load three cache lines.
       	5'b0_0111, 5'b0_1011, 5'b0_1101, 5'b0_1110:
	  begin
       	    de_ns = DE_DO3;
	    ld_push_count = 1'b1;
	    push_count   = 4'b0010;
	    load_tagi   = 1'b1;
       	  end
	// Missed four of four texels, load four cache lines.
       	5'b0_1111:
	  begin
    	    de_ns = DE_DO4;
	    ld_push_count = 1'b1;
	    push_count   = 4'b0000;
	    load_tagi   = 1'b1;
	  end
	default: 
	  begin
	    de_ns = DE_LOADED;	// hit
	    tc_readyi = 1'b1;
	    pop_uv = 1'b1;
	    ld_push_count = 1'b0;
	    push_count   = 4'b0000;
	  end
      endcase
      
      check_texels = {de_ns, ld_push_count, push_count, load_tagi, tc_readyi, pop_uv};
      
    end
    
  endfunction
  
endmodule
