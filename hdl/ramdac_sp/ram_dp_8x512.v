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
//  Title       :  RAMDAC Memory block.
//  File        :  ram_dp_9x512.v
//  Author      :  Jim Macleod
//  Created     :  11-March-2003
//  RCS File    :  $Source: /u/hammer_2d/hdl/ramdac/RCS/ram_dp_8x512.v,v $
//  Status      :  $Id: ram_dp_8x512.v,v 1.1 2005/01/25 20:52:30 fbruno Exp $
//
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
//  $Log: ram_dp_8x512.v,v $
//  Revision 1.1  2005/01/25 20:52:30  fbruno
//  Initial revision
//
//  Revision 1.1  2003/06/29 21:02:11  fbruno
//  Initial revision
//
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
 
// `timescale 1 ns / 10 ps
module ram_dp_8x512
	(
	clock_a, 
	wren_a,
	address_a, 
	data_a, 
	clock_b,
	wren_b,
	address_b, 
	data_b, 
	q_a,
	q_b
	);

input      	clock_a;
input      	wren_a;
input	[8:0]	address_a;
input	[7:0]	data_a;
input		clock_b;
input      	wren_b;
input	[8:0]	address_b; 
input	[7:0]	data_b;

output	[7:0]	q_a, 
		q_b;

reg	[7:0]	q_a, 
		q_b;

reg	[7:0]	mema	[0:511];

always @(posedge clock_a) if(wren_a) mema[address_a] <= data_a;
always @(posedge clock_a) q_a <= mema[address_a];
always @(posedge clock_b) q_b <= mema[address_b];

endmodule
