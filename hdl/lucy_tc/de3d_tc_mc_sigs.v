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
//  Title       :  Memory controller interface
//  File        :  de3d_tc_mc_sigs.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  Because other resources in the drawing engine (Texel Cache) can be  
//  interleaving requests with mine, I must make sure that I know which 
//  signals are mine                                                    
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//    U_HBI         hbi_top        Host interface (PCI)
//    U_VGA         vga_top        IBM(TM) Compatible VGA core
//    U_DE          de_top         Drawing engine
//    U_DLP         dlp_top        Display List Processor
//    U_DDR3        DDR3           DDR3 Memory interface
//    u_crt         crt_top        Display interface
//    u_ramdac      ramdac         Digital DAC
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

/************************************************************************/
/************************************************************************/
module de3d_tc_mc_sigs
	(
	input		de_clk,		// Drawing engine clock	
	input		de_rstn,	// Drawing engine reset	
	input		ld_push_count,	// Load push count from tc_sm.
	input	[3:0]   push_count,	// push count from tc_sm.
	input		mclock,		// Memory controller clock	
	input		tex_push_en,	// push signal to load data to TC
	input	[3:0]	tc_op_store,	// Current tc op.       	
	input   [8:0]   ul_store_x,       // Upper left texel address
	input   [8:0]   ul_store_y,       // Upper left texel address
	input   [8:0]   ll_store_x,       // Lower left texel address 
	input   [8:0]   ll_store_y,       // Lower left texel address 
	input   [8:0]   ur_store_x,       // Upper right texel address
	input   [8:0]   ur_store_y,       // Upper right texel address
	input   [8:0]   lr_store_x,       // Lower right texel address
	input   [8:0]   lr_store_y,       // Lower right texel address
	input   [2:0]   bpt,              // bpt
	input   [3:0]   set_read,         // LRU

	output reg	        done,	      // Done sent back to tc_sm.
	output reg            	ram_sel,      // RAM select for first read.
	output reg	[7:0]   ram_addr      // Address for loading TC RAM.
	);

wire	       ul_lru_read = set_read[3];
wire	       ll_lru_read = set_read[2];
wire	       ur_lru_read = set_read[1];
wire	       lr_lru_read = set_read[0];

reg             ld_push_count_t;
reg             ld_push_count_d;
reg             ld_push_count_mc;
reg             mc_ld_push_count;
reg     [3:0]   de_push_count;
reg     [3:0]   mc_push_count;
reg             done_un;
reg             done_de;
reg	[1:0]   mc_current;


always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn) de_push_count <= 4'b0000;
		else if(ld_push_count) de_push_count <= push_count;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)ld_push_count_t <= 0;
		else if(ld_push_count) ld_push_count_t <= ~ld_push_count_t;
	end

/*********************************************************/
/* Syncronize the load push counter to the memory clock. */
always @(posedge mclock) ld_push_count_d <= ld_push_count_t;
always @(posedge mclock) ld_push_count_mc <= ld_push_count_d;
always @* mc_ld_push_count = ld_push_count_mc ^ ld_push_count_d;

/****************************************************/
/* Syncronize the done to the drawing engine clock. */
always @(posedge de_clk) done_un <= mc_push_count[3];
always @(posedge de_clk) done_de <= done_un;
always @* done = ~done_de & done_un;


always @(posedge mclock or negedge de_rstn)
	begin
		 if(!de_rstn)mc_push_count <= 4'b0000;
		 else if(mc_ld_push_count)mc_push_count <= de_push_count;
		 else if(tex_push_en)mc_push_count <= mc_push_count + 4'b0001;
	end

always @* begin
                casex({tc_op_store, mc_push_count[2:1]}) /* synopsys parallel_case */
                        // Missed one of four texels, load one cache line.
                        6'b1000_xx: mc_current = 2'b00; // UL.
                        6'b0100_xx: mc_current = 2'b01; // LL.
                        6'b0010_xx: mc_current = 2'b10; // UR.
                        6'b0001_xx: mc_current = 2'b11; // LR.
                        // Missed two of four texels, load two cache lines.
                        6'b0011_10: mc_current = 2'b10; // UR.
                        6'b0011_11: mc_current = 2'b11; // LR.
                        6'b0101_10: mc_current = 2'b01; // LL.
                        6'b0101_11: mc_current = 2'b11; // LR.
                        6'b0110_10: mc_current = 2'b01; // LL.
                        6'b0110_11: mc_current = 2'b10; // UR.
                        6'b1001_10: mc_current = 2'b00; // UL.
                        6'b1001_11: mc_current = 2'b11; // LR.
                        6'b1010_10: mc_current = 2'b00; // UL.
                        6'b1010_11: mc_current = 2'b10; // UR.
                        6'b1100_10: mc_current = 2'b00; // UL.
                        6'b1100_11: mc_current = 2'b01; // LL.
                        // Missed three of four texels, load three cache lines.
                        6'b0111_01: mc_current = 2'b01; // LL.
                        6'b0111_10: mc_current = 2'b10; // UR.
                        6'b0111_11: mc_current = 2'b11; // LR.
                        6'b1011_01: mc_current = 2'b00; // UL.
                        6'b1011_10: mc_current = 2'b10; // UR.
                        6'b1011_11: mc_current = 2'b11; // LR.
                        6'b1101_01: mc_current = 2'b00; // UL.
                        6'b1101_10: mc_current = 2'b01; // LL.
                        6'b1101_11: mc_current = 2'b11; // LR.
                        6'b1110_01: mc_current = 2'b00; // UL.
                        6'b1110_10: mc_current = 2'b01; // LL.
                        6'b1110_11: mc_current = 2'b10; // UR.
                        // Missed four of four texels, load four cache lines.
                        6'b1111_00: mc_current = 2'b00; // UL.
                        6'b1111_01: mc_current = 2'b01; // LL.
                        6'b1111_10: mc_current = 2'b10; // UR.
                        6'b1111_11: mc_current = 2'b11; // LR.
                        default:    mc_current = 2'b00; // UL.
                endcase
        end

always @* begin
        	case (mc_current) /* synopsys full_case parallel_case */
        	2'b00: // Upper left.
			begin
      	     			ram_sel  = ul_store_y[0];
            			case (bpt) /* synopsys parallel_case */
					3: begin // 8 bpt.
							ram_addr = {ul_lru_read,ul_store_y[5:0],ul_store_x[5]};
      	     						// ram_sel  = (ul_store_x[4] ^ ul_store_y[0]);
					end
					5: begin // 32 bpt.
							ram_addr = {ul_lru_read,ul_store_y[3:0],ul_store_x[5:3]};
      	     						// ram_sel  = (ul_store_x[2] ^ ul_store_y[0]);
					end
					default: begin// 16 bpt.
							ram_addr = {ul_lru_read,ul_store_y[4:0],ul_store_x[5:4]};
      	     						// ram_sel  = (ul_store_x[3] ^ ul_store_y[0]);
					end
            			endcase
        		end
		2'b01: // Lower left.
			begin
      	     			ram_sel  = ll_store_y[0];
            			case (bpt) /* synopsys parallel_case */
					3: begin // 8 bpt.
							ram_addr = {ll_lru_read,ll_store_y[5:0],ll_store_x[5]};
      	     						// ram_sel  = (ll_store_x[4] ^ ll_store_y[0]);
					end
					5: begin // 32 bpt.
							ram_addr = {ll_lru_read,ll_store_y[3:0],ul_store_x[5:3]};
      	     						// ram_sel  = (ll_store_x[2] ^ ll_store_y[0]);
					end
					default: begin // 16 bpt.
							ram_addr = {ll_lru_read,ll_store_y[4:0],ll_store_x[5:4]};
      	     						// ram_sel  = (ll_store_x[3] ^ ll_store_y[0]);
					end
            			endcase
			end
		2'b10: // Upper right.
			begin
      	     			ram_sel  = ur_store_y[0];
            			case (bpt) /* synopsys parallel_case */
					3: begin // 8 bpt.
							ram_addr = {ur_lru_read,ur_store_y[5:0],ur_store_x[5]};
      	     						// ram_sel  = (ur_store_x[4] ^ ur_store_y[0]);
					end
					5: begin // 32 bpt.
							ram_addr = {ur_lru_read,ur_store_y[3:0],ur_store_x[5:3]};
      	     						// ram_sel  = (ur_store_x[2] ^ ur_store_y[0]);
					end
					default: begin // 16 bpt.
							ram_addr = {ur_lru_read,ur_store_y[4:0],ur_store_x[5:4]};
      	     						// ram_sel  = (ur_store_x[3] ^ ur_store_y[0]);
					end
            			endcase
			end
		2'b11: // Lower right.
			begin
      	     			ram_sel  = lr_store_y[0];
            			case (bpt) /* synopsys parallel_case */
					3: begin // 8 bpt.
							ram_addr = {lr_lru_read,lr_store_y[5:0],lr_store_x[5]};
      	     						// ram_sel  = (lr_store_x[4] ^ lr_store_y[0]);
					end
					5: begin // 32 bpt.
							ram_addr = {lr_lru_read,lr_store_y[3:0],lr_store_x[5:3]};
      	     						// ram_sel  = (lr_store_x[2] ^ lr_store_y[0]);
					end
					default: begin // 16 bpt.
							ram_addr = {lr_lru_read,lr_store_y[4:0],lr_store_x[5:4]};
      	     						// ram_sel  = (lr_store_x[3] ^ lr_store_y[0]);
					end
            			endcase
			end
      		endcase
	end

endmodule
