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
//  Title       :  Write Buffer Registers
//  File        :  hbi_wcregs.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Infer the registers that make up the hbi write buffer (cache).  The 
//  "cache" consists of two buffers for data and two buffers for the
//  memory controller mask (byte enables).  The data and mask relate as
//  follows:
//  
//  Buf 0:
//  mc page 0    buff0   mask0
//  mc page 1    buff1   mask1
//  Buf 1:
//  mc page 0    buff2   mask2
//  mc page 1    buff3   mask3
//  
//  For each buffer, mc pages 0,1 are contiguous, with mc page 0 having
//  the lower address.
//  
//  The output stage is simply a 4:1 mux, that selects the mc page and 
//  mask to be sent to the memory controller.
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

  module hbi_wcregs 
    (
     input		 hb_clk,       // pci clock
     input 	         mclock,       // MC clock
     input 	         hb_soft_reset_n, // reset
     input [31:0]	 pci_data,     // pci data, raw or converted from yuv
     input [3:0]	 wc_be,        // byte enables
     input [3:0]	 wc_be_d,      // byte enables
     input		 clr_wc0,      // clear cache0
     input		 clr_wc1,      // clear cache1
     input		 ld_wc0,       // load cache0
     input		 ld_wc1,       // load cache1
     input               wcregs_addr,  // bit one of the RAM addr
     input               wcregs_we,    // Write enable for the RAM
     input [2:0]         sub_buf_sel,  // 1 of 4 "half buffers" for writing
     input 	         hst_push,
     input 	         hst_pop,
     input [1:0]         hst_mw_addr,
     input               select,
     
     output     [127:0]  hb_pdo,       // "write" pixel data to mc
     output reg [15:0]	 hst_md,       // byte mask data to mc
     output reg 	 mc_done,
     output reg [1:0]    push_count
     );
  
  reg [3:0] 	     mask0;      // byte enables buffers
  reg [3:0] 	     mask1;      
  reg [3:0] 	     mask2;      
  reg [3:0] 	     mask3;      
  reg [3:0] 	     mask4;      // byte enables buffers
  reg [3:0] 	     mask5;      
  reg [3:0] 	     mask6;      
  reg [3:0] 	     mask7;      
  reg [3:0] 	     mask8;      // byte enables buffers
  reg [3:0] 	     mask9;      
  reg [3:0] 	     maska;      
  reg [3:0] 	     maskb;      
  reg [3:0] 	     maskc;      // byte enables buffers
  reg [3:0] 	     maskd;      
  reg [3:0] 	     maske;      
  reg [3:0] 	     maskf;      
  reg [3:0] 	     wc_be_i;        // byte enables
  reg [3:0] 	     wc_be_di, wc_be_dii;        // byte enables
  reg 		     clr_wc0_i;      // clear cache0
  reg 		     clr_wc1_i;      // clear cache1
  reg 		     ld_wc0_i;       // load cache0
  reg 		     ld_wc1_i;       // load cache1
  reg [2:0] 	     sub_buf_sel_i;  // 1 of 4 "half buffers" for writing
  reg [3:0] 	     waddr;
  reg 		     we;
  reg [1:0] 	     pop_count;

  wire [127:0] 	     data_in;

  // Technically agp data should be delayed one cycle. However, since I am not
  // using it, it is sort of a place holder for DMA, I am leaving it as is
  always @(posedge hb_clk) begin
    waddr         <= {wcregs_addr, sub_buf_sel} | select;
    we            <= wcregs_we;
    wc_be_i       <= select ? wc_be_di : wc_be;
    wc_be_di      <= wc_be_d;
    clr_wc0_i     <= clr_wc0;
    clr_wc1_i     <= clr_wc1;
    ld_wc0_i      <= ld_wc0;
    ld_wc1_i      <= ld_wc1;
    sub_buf_sel_i <= sub_buf_sel | select;
  end

  dpram_32_128x16 U_MW_RAM
    (
     .data         (pci_data),
     .wren         (we),
     .wraddress    (waddr),
     .rdaddress    (hst_mw_addr),
     .byteena_a    (~wc_be_i),
     .wrclock      (hb_clk),
     .rdclock      (mclock),
     .q            (hb_pdo)
     );

  // Mask (byte enable) buffer
  // loads have precedence over clears.  when a clear is received, every
  // mask for that buffer is cleared, except for the selected mask being loaded
  always @(posedge hb_clk) begin

    case (sub_buf_sel_i) //synopsys full_case parallel_case
      3'd0: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask0 <= mask0 & wc_be_i;
	else if (clr_wc0_i) mask0 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask1 <= 4'hF;
	  mask2 <= 4'hF;
	  mask3 <= 4'hF;
	  mask4 <= 4'hF;
	  mask5 <= 4'hF;
	  mask6 <= 4'hF;
	  mask7 <= 4'hF;
	end
	// Mask for buffer 1
	if      (ld_wc1_i)  mask8 <= mask8 & wc_be_i;
	else if (clr_wc1_i) mask8 <= 4'hF;
	if      (clr_wc1_i) begin
	  mask9 <= 4'hF;
	  maska <= 4'hF;
	  maskb <= 4'hF;
	  maskc <= 4'hF;
	  maskd <= 4'hF;
	  maske <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      
      3'd1: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask1 <= mask1 & wc_be_i;
	else if (clr_wc0_i) mask1 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask2 <= 4'hF;
	  mask3 <= 4'hF;
	  mask4 <= 4'hF;
	  mask5 <= 4'hF;
	  mask6 <= 4'hF;
	  mask7 <= 4'hF;
	end

	// Mask for buffer 1
	if      (ld_wc1_i)  mask9 <= mask9 & wc_be_i;
	else if (clr_wc1_i) mask9 <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  maska <= 4'hF;
	  maskb <= 4'hF;
	  maskc <= 4'hF;
	  maskd <= 4'hF;
	  maske <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      
      3'd2: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask2 <= mask2 & wc_be_i;
	else if (clr_wc0_i) mask2 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask1 <= 4'hF;
	  mask3 <= 4'hF;
	  mask4 <= 4'hF;
	  mask5 <= 4'hF;
	  mask6 <= 4'hF;
	  mask7 <= 4'hF;
	end

	// Mask for buffer 1
	if      (ld_wc1_i)  maska <= maska & wc_be_i;
	else if (clr_wc1_i) maska <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  mask9 <= 4'hF;
	  maskb <= 4'hF;
	  maskc <= 4'hF;
	  maskd <= 4'hF;
	  maske <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      
      3'd3: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask3 <= mask3 & wc_be_i;
	else if (clr_wc0_i) mask3 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask1 <= 4'hF;
	  mask2 <= 4'hF;
	  mask4 <= 4'hF;
	  mask5 <= 4'hF;
	  mask6 <= 4'hF;
	  mask7 <= 4'hF;
	end

	// Mask for buffer 1
	if      (ld_wc1_i)  maskb <= maskb & wc_be_i;
	else if (clr_wc1_i) maskb <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  mask9 <= 4'hF;
	  maska <= 4'hF;
	  maskc <= 4'hF;
	  maskd <= 4'hF;
	  maske <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      3'd4: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask4 <= mask4 & wc_be_i;
	else if (clr_wc0_i) mask4 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask1 <= 4'hF;
	  mask2 <= 4'hF;
	  mask3 <= 4'hF;
	  mask5 <= 4'hF;
	  mask6 <= 4'hF;
	  mask7 <= 4'hF;
	end
	// Mask for buffer 1
	if      (ld_wc1_i)  maskc <= maskc & wc_be_i;
	else if (clr_wc1_i) maskc <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  mask9 <= 4'hF;
	  maska <= 4'hF;
	  maskb <= 4'hF;
	  maskd <= 4'hF;
	  maske <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      
      3'd5: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask5 <= mask5 & wc_be_i;
	else if (clr_wc0_i) mask5 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask1 <= 4'hF;
	  mask2 <= 4'hF;
	  mask3 <= 4'hF;
	  mask4 <= 4'hF;
	  mask6 <= 4'hF;
	  mask7 <= 4'hF;
	end

	// Mask for buffer 1
	if      (ld_wc1_i)  maskd <= maskd & wc_be_i;
	else if (clr_wc1_i) maskd <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  mask9 <= 4'hF;
	  maska <= 4'hF;
	  maskb <= 4'hF;
	  maskc <= 4'hF;
	  maske <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      
      3'd6: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask6 <= mask6 & wc_be_i;
	else if (clr_wc0_i) mask6 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask1 <= 4'hF;
	  mask2 <= 4'hF;
	  mask3 <= 4'hF;
	  mask4 <= 4'hF;
	  mask5 <= 4'hF;
	  mask7 <= 4'hF;
	end

	// Mask for buffer 1
	if      (ld_wc1_i)  maske <= maske & wc_be_i;
	else if (clr_wc1_i) maske <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  mask9 <= 4'hF;
	  maska <= 4'hF;
	  maskb <= 4'hF;
	  maskc <= 4'hF;
	  maskd <= 4'hF;
	  maskf <= 4'hF;
	end
      end
      
      3'd7: begin
	// Mask for Buffer 0
	if      (ld_wc0_i)  mask7 <= mask7 & wc_be_i;
	else if (clr_wc0_i) mask7 <= 4'hF;
	if      (clr_wc0_i) begin
	  mask0 <= 4'hF;
	  mask1 <= 4'hF;
	  mask2 <= 4'hF;
	  mask3 <= 4'hF;
	  mask4 <= 4'hF;
	  mask5 <= 4'hF;
	  mask6 <= 4'hF;
	end

	// Mask for buffer 1
	if      (ld_wc1_i)  maskf <= maskf & wc_be_i;
	else if (clr_wc1_i) maskf <= 4'hF;
	if      (clr_wc1_i) begin
	  mask8 <= 4'hF;
	  mask9 <= 4'hF;
	  maska <= 4'hF;
	  maskb <= 4'hF;
	  maskc <= 4'hF;
	  maskd <= 4'hF;
	  maske <= 4'hF;
	end
      end
    endcase // case(sub_buf_sel_i)
  end // always @ (posedge hb_clk)

  // pop, push counters, and done flag
  always @(posedge mclock or negedge hb_soft_reset_n) begin
    if (!hb_soft_reset_n) begin
      push_count <= 2'b00;
      pop_count  <= 2'b00;
      mc_done    <=  1'b0;
    end else begin
      // push counter.  It is used to tell when MC is done
      if (hst_push) push_count <= push_count + 2'b01;
      if (hst_pop)  pop_count  <= pop_count + 2'b01;
      
      // Done flop.  This toggles when MC is done.  Writes are always 8 cycles,
      // reads are always 16 cycles.
      if ((hst_pop && pop_count[0]) || (hst_push && (push_count == 2'b11)))
        mc_done <= ~mc_done;
    end // else: !if(!hb_soft_reset_n)
  end // always @ (posedge mclock or negedge hb_soft_reset_n)

  // output mux
  always @* begin
    case (pop_count)
      2'h3: hst_md = {maskf, maske, maskd, maskc};
      2'h2: hst_md = {maskb, maska, mask9, mask8};
      2'h1: hst_md = {mask7, mask6, mask5, mask4};
      2'h0: hst_md = {mask3, mask2, mask1, mask0};
    endcase // case(pop_count)
  end // always @ (pop_count or...
  
endmodule // HBI_WCREGS

