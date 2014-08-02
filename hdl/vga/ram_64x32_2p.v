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
//  Title       :  64 by 32 two port RAM
//  File        :  ram_64x32_2p.v
//  Author      :  Jim Macleod
//  Created     :  06-April-2005
//  RCS File    :  $Source: /u/Maxwell/hdl/vga/RCS/ram_64x32_2p.v,v $
//  Status      :  $Id: ram_64x32_2p.v,v 1.1 2005/10/11 21:14:15 fbruno Exp fbruno $
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
//  $Log: ram_64x32_2p.v,v $
//  Revision 1.1  2005/10/11 21:14:15  fbruno
//  Initial revision
//
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
 
`timescale 1 ns / 10 ps
module ram_64x32_2p
	(
	input			clock,
	input			wren,
	input	[4:0]		wraddress,
	input	[4:0]		rdaddress,
	input	[63:0]		data,
	output	reg	[63:0]	q 
	);

reg	[63:0]	mem_a [0:31];

always @(posedge clock) if(wren) mem_a[wraddress] <= data;

always @(posedge clock) q <= mem_a[rdaddress];


endmodule



