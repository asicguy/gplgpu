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
//  Title       :  Memory Controller Cache block
//  File        :  mc_cache.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This block converts the 128 bit data path of the graphics controller to the
//  256 bit memory bus.
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

`timescale 1ns / 10ps

module mc_cache
	(
	input		mclock,
	input		mc_rstn,
	input [3:0]	mc_dev_sel,
	// to/from mc
	input		mc_local_write_req,
	input		mc_local_read_req,
	input		mc_local_burstbegin,
	input	[23:0]	mc_local_address,
	input	[127:0]	mc_local_wdata,
	input	[15:0]	mc_local_be,
	input	[5:0]	mc_local_size,
	output    	mc_local_ready,
	output reg 	[127:0]	mc_local_rdata,
	output reg 		mc_local_rdata_valid,
	// 
	// to/from ddr3
	//
	input			ddr3_ready,
	input			ddr3_rdata_valid,
	input	[255:0]		ddr3_rdata,
	output reg  		ddr3_write_req,
	output reg  		ddr3_read_req,
	output reg  		ddr3_burstbegin,
	output reg   [23:0]	ddr3_address,
	output reg   [4:0]	ddr3_size,
	output reg   [255:0]	ddr3_wdata,
	output reg   [31:0]	ddr3_be,

	output reg		ff_rdata_pop,
	output			local_read_empty,
	output [7:0]		data_fifo_used,
	output [3:0]		read_cmd_used,
	output			read_adr_0,
	output [5:0]		read_count_128
	);

	`define B31 [255:248]
	`define B30 [247:240]
	`define B29 [239:232]
	`define B28 [231:224]
	`define B27 [223:216]
	`define B26 [215:208]
	`define B25 [207:200]
	`define B24 [199:192]
	`define B23 [191:184]
	`define B22 [183:176]
	`define B21 [175:168]
	`define B20 [167:160]
	`define B19 [159:152]
	`define B18 [151:144]
	`define B17 [143:136]
	`define B16 [135:128]
	`define B15 [127:120]
	`define B14 [119:112]
	`define B13 [111:104]
	`define B12 [103:96]
	`define B11 [95:88]
	`define B10 [87:80]
	`define B9  [79:72]
	`define B8  [71:64]
	`define B7  [63:56]
	`define B6  [55:48]
	`define B5  [47:40]
	`define B4  [39:32]
	`define B3  [31:24]
	`define B2  [23:16]
	`define B1  [15:8]
	`define B0  [7:0]

	parameter READ_IDLE	= 2'b00,
		  READ_FIRST	= 2'b01,
		  READ_SECOND	= 2'b10;

	// reg		ff_rdata_pop;
	// wire		local_read_empty;
	// wire		read_adr_0;
	// wire	[5:0]	read_count_128;

	reg  [1:0]	read_state;
	reg		local_word;
	reg [5:0]	local_size_128;
	reg [5:0]	read_size;
	reg 		read_start;
	reg		bb_hold;

	reg		ddr3_burstbegin_wr;
	reg [23:1]	ddr3_address_wr;
	reg [4:0]	ddr3_size_wr;

	wire  [255:0]	local_rdata;
	wire		one_word;
	wire		read_cmd_empty;
	reg		pop_read_128;

	wire		z_hit;
	wire		z_miss;
	// reg		z_valid;
	// reg [22:0]	z_address;
	reg		z_addr_0;
	reg		z_rdata_valid;
	reg [255:0] 	z_cache;
	wire		z_load;
	wire		last_word;

	assign last_word = ~|local_size_128[5:1] & local_size_128[0];
	assign one_word = ~|mc_local_size[5:1] & mc_local_size[0];

	// Pack Data.
	always @(posedge mclock, negedge mc_rstn) begin
		if(!mc_rstn) begin
			local_size_128 <= 6'h0;
			local_word     <= 1'b0;
		end
		else begin
		ddr3_address_wr <= mc_local_address[23:1];
		ddr3_size_wr 	<= (mc_local_size >> 1) + (mc_local_size[0] | mc_local_address[0]);

		if(mc_local_burstbegin) begin
			local_size_128 <= mc_local_size - 6'h1;
			local_word     <= ~mc_local_address[0];
		end
		else if(mc_local_write_req) begin
			local_size_128 <= local_size_128 - 6'h1; 
			local_word     <= ~local_word; 
		end

		bb_hold <= 1'b0;
		casex({mc_local_write_req, mc_local_burstbegin, one_word, last_word, mc_local_address[0], local_word})
			// Write one word low.
			6'b111x0x: begin // Mask Hi, Write Lo, We, BB.
				ddr3_be[15:0]      <= mc_local_be;
				ddr3_be[31:16]     <= 16'h0;
				ddr3_wdata[127:0]  <= mc_local_wdata;
				ddr3_write_req     <= |(mc_local_be); // 1'b1;
				ddr3_burstbegin_wr <= |(mc_local_be); // 1'b1;
			end
			// Write one word high
			6'b111x1x: begin // Write Hi, Mask Lo, We, BB.
				ddr3_be[15:0]       <= 16'h0;
				ddr3_be[31:16]      <= mc_local_be;
				ddr3_wdata[255:128] <= mc_local_wdata;
				ddr3_write_req      <= |(mc_local_be); // 1'b1;
				ddr3_burstbegin_wr  <= |(mc_local_be); // 1'b1;
			end
			// Write first word low
			6'b110x0x: begin // Write Lo, Mask hi. No We, No BB
				ddr3_be[15:0]      <= mc_local_be;
				ddr3_wdata[127:0]  <= mc_local_wdata;
				ddr3_write_req     <= 1'b0;
				ddr3_burstbegin_wr <= 1'b0;
				bb_hold     	   <= 1'b1;
			end
			// Write first word high
			6'b110x1x: begin // Write Hi, Mask lo. We, BB
				ddr3_be[31:16]      <= mc_local_be;
				ddr3_be[15:0]       <= 16'h0;
				ddr3_wdata[255:128] <= mc_local_wdata;
				ddr3_write_req      <= 1'b1;
				ddr3_burstbegin_wr  <= 1'b1;
			end
			// Normal Write Low
			6'b10x0x0: begin // Mask Hi, Write Lo, No We, No BB
				ddr3_be[15:0]      <= mc_local_be;
				ddr3_wdata[127:0]  <= mc_local_wdata;
				ddr3_write_req     <= 1'b0;
				ddr3_burstbegin_wr <= 1'b0;
			end
			// Normal Write High, now push.
			6'b10xxx1: begin
				ddr3_be[31:16]      <= mc_local_be;
				ddr3_wdata[255:128] <= mc_local_wdata;
				ddr3_write_req      <= 1'b1;
				ddr3_burstbegin_wr  <= bb_hold;
			end
			// Write last word low
			6'b10x1x0: begin // Mask Hi, Write Lo, We, BB
				ddr3_be[15:0]      <= mc_local_be;
				ddr3_be[31:16]     <= 16'h0;
				ddr3_wdata[127:0]  <= mc_local_wdata;
				ddr3_write_req     <= 1'b1;
				ddr3_burstbegin_wr <= 1'b0;
			end
			default: begin
				ddr3_be            <= 32'hffffffff;
				ddr3_write_req     <= 1'b0;
				ddr3_burstbegin_wr <= 1'b0;
			end
			endcase
	end
	end

	// Chech for Z in the cache.
	// assign z_hit =  (mc_dev_sel == 4'h8) & ({z_valid, z_address} == {1'b1, mc_local_address[23:1]});
	// assign z_miss = (mc_dev_sel == 4'h8) & ({z_valid, z_address} != {1'b1, mc_local_address[23:1]});
	assign z_hit =  1'b0;
	assign z_miss = 1'b1;

	// Read Request.
	// Don't request read if there is a Z hit.
	always @* begin
		if(mc_local_read_req & ddr3_ready & ~z_hit) begin
			ddr3_read_req   = 1'b1;
			ddr3_burstbegin = 1'b1;
			ddr3_address    =  mc_local_address[23:1];
			ddr3_size 	= (mc_local_size >> 1) + (mc_local_size[0] | mc_local_address[0]);
		end
		else begin
			ddr3_read_req   = 1'b0;
			ddr3_burstbegin = ddr3_burstbegin_wr;
			ddr3_address    = ddr3_address_wr;
			ddr3_size 	= ddr3_size_wr;
		end
	end

	assign mc_local_ready = ddr3_ready;

	/* Z Cache.	
	always @(posedge mclock, negedge mc_rstn) begin
		if(!mc_rstn) begin
			z_valid       <= 1'b0;
			z_address     <= 23'h0;;
		end
		// Z miss, load the address, valid, and enable data load..
		else if(~z_hit & mc_local_read_req & (mc_dev_sel == 4'h8)) begin 
			z_valid   <= 1'b1;
			z_address <= mc_local_address[23:1];
		end
	end
	*/

	mc_cache_fifo_256	u0_read_fifo_la
		(
		.clock		(mclock),
		.aclr		(~mc_rstn),
		.wrreq		(ddr3_rdata_valid),
		.data		(ddr3_rdata),
		.rdreq		(ff_rdata_pop),
		.almost_full	(),
		.empty		(local_read_empty),
		.full		(),
		.usedw		(data_fifo_used),
		.q		(local_rdata)
		);

	sfifo_8x16_la u_read_128
		(
		.aclr         (~mc_rstn),
		.clock        (mclock),
		.wrreq        (mc_local_read_req & ddr3_ready),
		.data         ({z_miss, mc_local_address[0], {6{~z_hit}} & mc_local_size}),
		.rdreq        (pop_read_128),

		.q            ({z_load, read_adr_0, read_count_128}),
		.full         (),
		.empty        (read_cmd_empty),
		.usedw        (read_cmd_used),
		.almost_full  ()
		);

	// Register to hold the Z.
	always @(posedge mclock, negedge mc_rstn) begin
		if(!mc_rstn) 			   z_cache   <= 256'h0;
		else if(ddr3_write_req & (mc_dev_sel == 4'h8)) begin 
			if(ddr3_be[31]) z_cache`B31 <= ddr3_wdata`B31;
			if(ddr3_be[30]) z_cache`B30 <= ddr3_wdata`B30;
			if(ddr3_be[29]) z_cache`B29 <= ddr3_wdata`B29;
			if(ddr3_be[28]) z_cache`B28 <= ddr3_wdata`B28;
			if(ddr3_be[27]) z_cache`B27 <= ddr3_wdata`B27;
			if(ddr3_be[26]) z_cache`B26 <= ddr3_wdata`B26;
			if(ddr3_be[25]) z_cache`B25 <= ddr3_wdata`B25;
			if(ddr3_be[24]) z_cache`B24 <= ddr3_wdata`B24;
			if(ddr3_be[23]) z_cache`B23 <= ddr3_wdata`B23;
			if(ddr3_be[22]) z_cache`B22 <= ddr3_wdata`B22;
			if(ddr3_be[21]) z_cache`B21 <= ddr3_wdata`B21;
			if(ddr3_be[20]) z_cache`B20 <= ddr3_wdata`B20;
			if(ddr3_be[19]) z_cache`B19 <= ddr3_wdata`B19;
			if(ddr3_be[18]) z_cache`B18 <= ddr3_wdata`B18;
			if(ddr3_be[17]) z_cache`B17 <= ddr3_wdata`B17;
			if(ddr3_be[16]) z_cache`B16 <= ddr3_wdata`B16;
			if(ddr3_be[15]) z_cache`B15 <= ddr3_wdata`B15;
			if(ddr3_be[14]) z_cache`B14 <= ddr3_wdata`B14;
			if(ddr3_be[13]) z_cache`B13 <= ddr3_wdata`B13;
			if(ddr3_be[12]) z_cache`B12 <= ddr3_wdata`B12;
			if(ddr3_be[11]) z_cache`B11 <= ddr3_wdata`B11;
			if(ddr3_be[10]) z_cache`B10 <= ddr3_wdata`B10;
			if(ddr3_be[9])  z_cache`B9 <= ddr3_wdata`B9;
			if(ddr3_be[8])  z_cache`B8 <= ddr3_wdata`B8;
			if(ddr3_be[7])  z_cache`B7 <= ddr3_wdata`B7;
			if(ddr3_be[6])  z_cache`B6 <= ddr3_wdata`B6;
			if(ddr3_be[5])  z_cache`B5 <= ddr3_wdata`B5;
			if(ddr3_be[4])  z_cache`B4 <= ddr3_wdata`B4;
			if(ddr3_be[3])  z_cache`B3 <= ddr3_wdata`B3;
			if(ddr3_be[2])  z_cache`B2 <= ddr3_wdata`B2;
			if(ddr3_be[1])  z_cache`B1 <= ddr3_wdata`B1;
			if(ddr3_be[0])  z_cache`B0 <= ddr3_wdata`B0;
		end
		else if(z_load & ddr3_rdata_valid) z_cache   <= ddr3_rdata;
	end

	// Unpack data.
	always @(posedge mclock, negedge mc_rstn) begin
		if(!mc_rstn) begin
			read_state 	     <= READ_FIRST;
		   	read_size  	     <= 6'h0;
		   	read_start  	     <= 1'b0;
			z_rdata_valid 	     <= 1'b0;
			z_addr_0      	     <= 1'b0;
		end
		else begin
			z_rdata_valid <= 1'b0;
			case(read_state)
			READ_IDLE: begin
		   			read_start <= read_adr_0;
					if(!read_cmd_empty & (read_count_128 == 6'h0)) begin // This is a Z cache hit.
						read_state <= READ_IDLE;
						z_rdata_valid <= 1'b1;
						z_addr_0      <= read_adr_0;
				 	end
					else if(~local_read_empty) begin
						if(read_adr_0) read_state <= READ_SECOND;
						else	       read_state <= READ_FIRST;
		   				read_size      		  <= read_count_128;
				 	end
					else read_state <= READ_IDLE;
				end
			READ_FIRST: begin
					// Last word to send
					if((read_size == 6'h1) & ~local_read_empty) begin
		   				read_size  	     <= read_size - 6'h1;
						read_state 	     <= READ_IDLE;
					end
					// More to send.
					else if((read_size != 6'h0) & ~local_read_empty) begin
		   				read_size  	     <= read_size - 6'h1;
						read_state 	     <= READ_SECOND;
						read_start 	     <= ~read_start;
				 	end
					// Wait for more data.
					else if((read_size != 6'h0) & local_read_empty) begin
						read_state 	     <= READ_FIRST;
				 	end
					// Done.
					else read_state 	<= READ_IDLE;
				end
			READ_SECOND: begin
					// Last word to send
					if((read_size == 6'h1) & ~local_read_empty) begin
		   				read_size  	     <= read_size - 6'h1;
						read_state 	     <= READ_IDLE;
				 	end
					// More to send.
					else if((read_size != 6'h0) & ~local_read_empty) begin
		   				read_size  	     <= read_size - 6'h1;
						read_state 	     <= READ_FIRST;
						read_start 	     <= ~read_start;
				 	end
					// Wait for more data.
					else if((read_size != 6'h0) & local_read_empty) begin
						read_state 	     <= READ_SECOND;
				 	end
					// Done.
					else read_state   <= READ_IDLE;
				end
			endcase
		end
	end

	always @* pop_read_128 = ((((read_state == READ_FIRST) | (read_state == READ_SECOND)) & (read_size == 6'h1)) & ~local_read_empty) |
				   ((read_state == READ_IDLE) & (!read_cmd_empty & (read_count_128 == 6'h0))); 	// This is a Z cache hit.
			

	always @* ff_rdata_pop = (((read_state == READ_FIRST) & (read_size == 6'h1)) | (read_state == READ_SECOND)) & ~local_read_empty;

	always @* mc_local_rdata = (z_rdata_valid & z_addr_0) ? z_cache[255:128] :
				   (z_rdata_valid & ~z_addr_0) ? z_cache[127:0] :
				   (read_start) ?  local_rdata[255:128] : local_rdata[127:0];

	always @* mc_local_rdata_valid = (((read_state == READ_FIRST) | (read_state == READ_SECOND)) & ((read_size != 6'h0) & ~local_read_empty)) | z_rdata_valid;


endmodule
