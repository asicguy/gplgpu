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
//  Title       :  Load Generator
//  File        :  de3d_tc_load_gen.v
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

module de3d_tc_load_gen
	#(parameter BYTES = 4)
	(
	input             de_clk,
	input     [20:0]  tex_org,     	    // LOD origins.
	input     [11:0]  tptch,      	    // LOD origins.
	input     [3:0]   tc_op_store,      // Upper left texel address
	input     [8:0]   ul_store_x,       // Upper left texel address
	input     [8:0]   ul_store_y,       // Upper left texel address
	input     [8:0]   ll_store_x,       // Lower left texel address 
	input     [8:0]   ll_store_y,       // Lower left texel address 
	input     [8:0]   ur_store_x,       // Upper right texel address
	input     [8:0]   ur_store_y,       // Upper right texel address
	input     [8:0]   lr_store_x,       // Lower right texel address
	input     [8:0]   lr_store_y,       // Lower right texel address
	input     [2:0]   bpt,              // bpt
	input     [1:0]   req_count,        // Memory Request Count.

	output reg	[31:0]	tex_address  // X out to memory controller.
	);

reg     [6:0]   tex_x1_r;            // X out to memory controller.
reg     [6:0]   tex_x2_r;            // X out to memory controller.
reg	[31:0]	p_mult;
reg	[31:0]	int_add;
reg     [1:0]   req_current;

always @* begin
		case (bpt) /* synopsys parallel_case */
			3: // 8 bpt.
				begin
					tex_x1_r = {2'b0,ul_store_x[8:5], 1'b0};
					tex_x2_r = {2'b0,lr_store_x[8:5], 1'b0};
				end
			5: // 32 bpt.
				begin
					tex_x1_r = {ul_store_x[8:3], 1'b0};
					tex_x2_r = {lr_store_x[8:3], 1'b0};
				end
			default: // 16 bpt.
				begin
					tex_x1_r = {1'b0,ul_store_x[8:4], 1'b0};
					tex_x2_r = {1'b0,lr_store_x[8:4], 1'b0};
				end
            	endcase
      	end

always @* begin
                casex({tc_op_store, req_count}) /* synopsys parallel_case */
                        // Missed one of four texels, load one cache line.
                        6'b1000_xx: req_current = 2'b00; // UL.
                        6'b0100_xx: req_current = 2'b01; // LL.
                        6'b0010_xx: req_current = 2'b10; // UR.
                        6'b0001_xx: req_current = 2'b11; // LR.
                        // Missed two of four texels, load two cache lines.
                        6'b0011_01: req_current = 2'b10; // UR.
                        6'b0011_00: req_current = 2'b11; // LR.
                        6'b0101_01: req_current = 2'b01; // LL.
                        6'b0101_00: req_current = 2'b11; // LR.
                        6'b0110_01: req_current = 2'b01; // LL.
                        6'b0110_00: req_current = 2'b10; // UR.
                        6'b1001_01: req_current = 2'b00; // UL.
                        6'b1001_00: req_current = 2'b11; // LR.
                        6'b1010_01: req_current = 2'b00; // UL.
                        6'b1010_00: req_current = 2'b10; // UR.
                        6'b1100_01: req_current = 2'b00; // UL.
                        6'b1100_00: req_current = 2'b01; // LL.
                        // Missed three of four texels, load three cache lines.
                        6'b0111_10: req_current = 2'b01; // LL.
                        6'b0111_01: req_current = 2'b10; // UR.
                        6'b0111_00: req_current = 2'b11; // LR.
                        6'b1011_10: req_current = 2'b00; // UL.
                        6'b1011_01: req_current = 2'b10; // UR.
                        6'b1011_00: req_current = 2'b11; // LR.
                        6'b1101_10: req_current = 2'b00; // UL.
                        6'b1101_01: req_current = 2'b01; // LL.
                        6'b1101_00: req_current = 2'b11; // LR.
                        6'b1110_10: req_current = 2'b00; // UL.
                        6'b1110_01: req_current = 2'b01; // LL.
                        6'b1110_00: req_current = 2'b10; // UR.
                        // Missed four of four texels, load four cache lines.
                        6'b1111_11: req_current = 2'b00; // UL.
                        6'b1111_10: req_current = 2'b01; // LL.
                        6'b1111_01: req_current = 2'b10; // UR.
                        6'b1111_00: req_current = 2'b11; // LR.
                        default:    req_current = 2'b00; // UL.
                endcase
        end

  always @ (posedge de_clk) begin
    	case(req_current)
      	// Pitch conversion
	2'b00: begin
			p_mult <= (ul_store_y * {{4{tptch[11]}}, tptch});	// x1, y1
			`ifdef BYTE16 int_add <= (tex_org + {25'h0, tex_x1_r}); `endif
			`ifdef BYTE8  int_add <= ({tex_org, 1'b0} + {{14{tex_x1_r[13]}}, tex_x1_r}); `endif
			`ifdef BYTE4  int_add <= ({tex_org, 2'b0} + {{14{tex_x1_r[13]}}, tex_x1_r}); `endif
		end
	2'b01:	 begin   
			p_mult <= (ll_store_y * {{4{tptch[11]}}, tptch});	// x1, y2
			`ifdef BYTE16 int_add <= (tex_org + {25'h0, tex_x1_r}); `endif
			`ifdef BYTE8  int_add <= ({tex_org, 1'b0} + {{14{tex_x1_r[13]}}, tex_x1_r}); `endif
			`ifdef BYTE4  int_add <= ({tex_org, 2'b0} + {{14{tex_x1_r[13]}}, tex_x1_r}); `endif
		 end
	2'b10:    begin
			p_mult <= (ur_store_y * {{4{tptch[11]}}, tptch});	// x2, y1
			`ifdef BYTE16 int_add <= (tex_org + {25'h0, tex_x2_r}); `endif
			`ifdef BYTE8  int_add <= ({tex_org, 1'b0} + {{14{tex_x2_r[13]}}, tex_x2_r}); `endif
			`ifdef BYTE4  int_add <= ({tex_org, 2'b0} + {{14{tex_x2_r[13]}}, tex_x2_r}); `endif
		 end

	2'b11:   begin
			p_mult <= (lr_store_y * {{4{tptch[11]}}, tptch});	// x2, y2
			`ifdef BYTE16 int_add <= (tex_org + {25'h0, tex_x2_r}); `endif
			`ifdef BYTE8  int_add <= ({tex_org, 1'b0} + {{14{tex_x2_r[13]}}, tex_x2_r}); `endif
			`ifdef BYTE4  int_add <= ({tex_org, 2'b0} + {{14{tex_x2_r[13]}}, tex_x2_r}); `endif
		end
    	endcase
  end

  always @* begin
    	if (BYTES == 16)     tex_address = p_mult + int_add;
    	else if (BYTES == 8) tex_address = {p_mult, 1'b0} + int_add;
    	else                 tex_address = {p_mult, 2'b0} + int_add;
    end


endmodule
