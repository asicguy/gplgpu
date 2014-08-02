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
//  Title       :  
//  File        :  
//  Author      :  Jim MacLeod
//  Created     :  01-Dec-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
//  
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
`timescale 1 ps / 1 ps

module log2_table
	(
	input	     	clk,			// Drawing engine clock.
	input		trilinear_en, 		// Trilinear Enable.
	input	[31:0]	val, 			// Current Largest delta 23.9.

	output	[9:0]	log2
	);


	reg	[3:0]	int_mm_no;
	reg	[5:0]	lod_fract;

	wire		 over_flow;
	wire	[9:0]	 log_in;

	// assign log_in = val[26:17];
	// assign over_flow = |val[39:27];
	assign log_in = val[17:8];
	assign over_flow = |val[31:18];



// 17    = 9
// 16    = 8
// 15    = 7
//
// 9     = 1
// 8     = 0
// 7     = -1
// 6     = -2
// 5     = -3
// Mipmap Number Generation
// Select Mipmap based on delta and if mipmapping is on.
// Determine the largest delta value.
// Extract LOD 
always @(posedge clk) begin
	// casex (largest_delta_AM2[17:8])
	casex ({over_flow, log_in})
		11'b0_10xxxxxxx_x, 11'b0_011xxxxxx_x:	begin // 192.0 <= l < 384.0
			if(trilinear_en && log_in[9]) begin
				int_mm_no <= 4'h9; 
				lod_fract <= val[16:11];
			end 
			else begin
				int_mm_no <= 4'h8;
				lod_fract <= val[15:10];
			end
		end	
		11'b0_010xxxxxx_x, 11'b0_0011xxxxx_x: begin // 96.0 <= l < 192.0
			if(trilinear_en && log_in[8]) begin
				int_mm_no <= 4'h8; 
				lod_fract <= val[15:10];
			end 
			else begin
				int_mm_no <= 4'h7;
				lod_fract <= val[14:9];
			end
		end
		11'b0_0010xxxxx_x, 11'b0_00011xxxx_x:	begin // 48.0 <= l < 96.0
			if(trilinear_en && log_in[7]) begin
				int_mm_no <= 4'h7; 
				lod_fract <= val[14:9];
			end 
			else begin
				int_mm_no <= 4'h6;
				lod_fract <= val[13:8];
			end
		end
		11'b0_00010xxxx_x, 11'b0_000011xxx_x:	begin // 24.0 <= l < 48.0
			if(trilinear_en && log_in[6]) begin
				int_mm_no <= 4'h6; 
				lod_fract <= val[13:8];
			end 
			else begin
				int_mm_no <= 4'h5;
				lod_fract <= val[12:7];
			end
		end
		11'b0_000010xxx_x, 11'b0_0000011xx_x:	begin // 12.0 <= l < 24.0
			if(trilinear_en && log_in[5]) begin
				int_mm_no <= 4'h5; 
				lod_fract <= val[12:7];
			end 
			else begin
				int_mm_no <= 4'h4;
				lod_fract <= val[11:6];
			end
		end
		11'b0_0000010xx_x, 11'b0_00000011x_x:	begin // 6.0 <= l < 12.0
			if(trilinear_en && log_in[4]) begin
				int_mm_no <= 4'h4; 
				lod_fract <= val[11:6];
			end 
			else begin
				int_mm_no <= 4'h3;
				lod_fract <= val[10:5];
			end
		end
		11'b0_00000010x_x, 11'b0_000000011_x:	begin // 3.0 <= l < 6.0
			if(trilinear_en && log_in[3]) begin
				int_mm_no <= 4'h3; 
				lod_fract <= val[10:5];
			end 
			else begin
				int_mm_no <= 4'h2;
				lod_fract <= val[9:4];
			end
		end
		11'b0_000000010_x, 11'b0_000000001_1:	begin // 1.5 <= l < 3.0
			if(trilinear_en && log_in[2]) begin
				int_mm_no <= 4'h2; 
				lod_fract <= val[9:4];
			end 
			else begin
				int_mm_no <= 4'h1;
				lod_fract <= val[8:3];
			end
		end
		11'b0_000000001_0, 11'b0_000000000_x:	begin // 0.0 <= l < 1.5
			if(trilinear_en && log_in[1]) begin
				int_mm_no <= 4'h1; 
				lod_fract <= val[8:3];
			end 
			else begin
				int_mm_no <= 4'h0;
				lod_fract <= val[7:2];
			end
		end
		// 384.0 <= l < infinity
		default: begin
				int_mm_no <= 4'h9; 
				lod_fract <= val[16:11];
		end
	endcase
end

assign log2 = {int_mm_no, lod_fract};


endmodule
