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
//  Title       :  Cursor RAMDAC Memory block.
//  File        :  cur_ram_blk.v
//  Author      :  Jim Macleod
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
//
//
/////////////////////////////////////////////////////////////////////////////////
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
 
// `timescale 1 ns / 10 ps
module cur_ram_blk
	(
	hclk, 
	write,
	cpu_address, 
	cpu_data_in, 
	pixclk,
	cur_address, 
	cur_data_out, 
	cpu_data_out
	);

input      	hclk;
input      	write;
input	[8:0]	cpu_address;
input	[7:0]	cpu_data_in;
input		pixclk;
input	[8:0]	cur_address; 

output	[7:0]	cur_data_out, 
		cpu_data_out;

ram_dp_8x512 u_ram_dp_8x512
        (
        .clock_a		(hclk),
        .wren_a			(write),
        .address_a		(cpu_address),
        .data_a			(cpu_data_in),
        .clock_b		(pixclk),
        .wren_b			(1'b0),
        .address_b		(cur_address),
        .data_b			(8'b0),
        .q_a			(cpu_data_out),
        .q_b			(cur_data_out)
        );


endmodule
