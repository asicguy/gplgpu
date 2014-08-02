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
//  Title       :  Ram Blocks Module
//  File        :  ram_blks.v
//  Author      :  Jim MacLeod
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
// This Model contains all  the rams used on the core
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

module ram_blks
	(
	input		hclk, 
	input		hresetn, 
	input		wrn, 
	input		pixclk, 
	input		palwr, 
	input	[7:0]	pal_cpu_adr, 
	input	[7:0]	red2pal,
	input	[7:0]	grn2pal,
	input	[7:0]	blu2pal,
	input		cpu_pal_one,
	input		cpu_cursor_one,
	input	[10:0]	idx_inc,
	input	[7:0]	cpu2cursor,
	input		disp_pal_one,
	input		disp_cursor_one,
	// Address for Palette Display Output.
	input	[7:0]	palr_addr_evn, 
	input	[7:0]	palg_addr_evn, 
	input	[7:0]	palb_addr_evn, 
	// Address for Cursor Display Output.
	input	[7:0]	cursor_addr, 

	output	[7:0]	palr2dac_evn, 
	output	[7:0]	palr2cpu,
	output	[7:0]	palg2dac_evn, 
	output	[7:0]	palg2cpu,
	output	[7:0]	palb2dac_evn, 
	output	[7:0]	palb2cpu,
	output	reg	[7:0]	cursor2cpu, 
	output	[7:0]	cursor1_data, 
	output	[7:0]	cursor2_data, 
	output	[7:0]	cursor3_data, 
	output	[7:0]	cursor4_data 
	);

wire	[7:0]	curdata1,
		curdata2,
		curdata3,
		curdata4;

reg		wr1, wr2;

always @(posedge hclk or negedge hresetn)
        if (!hresetn)
        begin
                wr1       <= 1'b0;
                wr2       <= 1'b0;
        end
        else begin
                wr1       <= wrn;
                wr2       <= wr1;
        end

wire wr_pulse = wr1 & !wr2;
wire cursor1_wr = !idx_inc[10] & !idx_inc[9] &  idx_inc[8] & wr_pulse;
wire cursor2_wr = !idx_inc[10] &  idx_inc[9] & !idx_inc[8] & wr_pulse;
wire cursor3_wr = !idx_inc[10] &  idx_inc[9] &  idx_inc[8] & wr_pulse;
wire cursor4_wr =  idx_inc[10] & !idx_inc[9] & !idx_inc[8] & wr_pulse;

always @*
        begin
                case(idx_inc[10:8])
                3'b001  : cursor2cpu <=  curdata1 ;
                3'b010  : cursor2cpu <=  curdata2 ;
                3'b011  : cursor2cpu <=  curdata3 ;
                default : cursor2cpu <=  curdata4 ;
                endcase
        end

ram_blk red_ram_blk
	(
	.hclk			(hclk),
	.write			(palwr),
	.cpu_address		({cpu_pal_one,pal_cpu_adr}),
	.cpu_data_in		(red2pal),
	.pixclk			(pixclk),
	.evn_address		({disp_pal_one, palr_addr_evn}),
	.evn_data_out		(palr2dac_evn),
	.cpu_data_out		(palr2cpu)
	);

ram_blk green_ram_blk
	(
	.hclk			(hclk),
	.write			(palwr),
	.cpu_address		({cpu_pal_one,pal_cpu_adr}),
	.cpu_data_in		(grn2pal),
	.pixclk			(pixclk),
	.evn_address		({disp_pal_one, palg_addr_evn}),
	.evn_data_out		(palg2dac_evn),
	.cpu_data_out		(palg2cpu)
	);

ram_blk blue_ram_blk
	(
	.hclk			(hclk),
	.write			(palwr),
	.cpu_address		({cpu_pal_one,pal_cpu_adr}),
	.cpu_data_in		(blu2pal),
	.pixclk			(pixclk),
	.evn_address		({disp_pal_one, palb_addr_evn}),
	.evn_data_out		(palb2dac_evn),
	.cpu_data_out		(palb2cpu)
	);

cur_ram_blk cursor1_ram_blk
	(
	.hclk			(hclk),
	.write			(cursor1_wr),
	.cpu_address		({cpu_cursor_one,idx_inc[7:0]}),
	.cpu_data_in		(cpu2cursor),
	.pixclk			(pixclk),
	.cur_address		({disp_cursor_one, cursor_addr}),
	.cur_data_out		(cursor1_data),
	.cpu_data_out		(curdata1)
	);

cur_ram_blk cursor2_ram_blk(
	.hclk			(hclk),
 	.write			(cursor2_wr),
	.cpu_address		({cpu_cursor_one,idx_inc[7:0]}),
	.cpu_data_in		(cpu2cursor),
	.pixclk			(pixclk),
	.cur_address		({disp_cursor_one, cursor_addr}),
	.cur_data_out		(cursor2_data),
	.cpu_data_out		(curdata2)
	);

cur_ram_blk cursor3_ram_blk 
	(
	.hclk			(hclk),
	.write			(cursor3_wr),
	.cpu_address		({cpu_cursor_one,idx_inc[7:0]}),
	.cpu_data_in		(cpu2cursor),
	.pixclk			(pixclk),
	.cur_address		({disp_cursor_one, cursor_addr}),
	.cur_data_out		(cursor3_data),
	.cpu_data_out		(curdata3)
	);

cur_ram_blk cursor4_ram_blk
	(
	.hclk			(hclk),
	.write			(cursor4_wr),
	.cpu_address		({cpu_cursor_one,idx_inc[7:0]}),
	.cpu_data_in		(cpu2cursor),
	.pixclk			(pixclk),
	.cur_address		({disp_cursor_one, cursor_addr}),
	.cur_data_out		(cursor4_data),
	.cpu_data_out		(curdata4)
	);

endmodule
