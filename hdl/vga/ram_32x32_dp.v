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
//  Title       :  32 by 32 Dual Port RAM
//  File        :  ram_32x32_dp.v
//  Author      :  Jim Macleod
//  Created     :  06-April-2005
//  RCS File    :  $Source: /u/Maxwell/hdl/vga/RCS/ram_32x32_dp.v,v $
//  Status      :  $Id: ram_32x32_dp.v,v 1.1 2005/10/11 21:14:15 fbruno Exp fbruno $
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
//  $Log: ram_32x32_dp.v,v $
//  Revision 1.1  2005/10/11 21:14:15  fbruno
//  Initial revision
//
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
 
`timescale 1 ns / 10 ps
module ram_32x32_dp
	(
	input			wrclock,
	input			wren,
	input	[4:0]		wraddress,
	input	[31:0]		data,
	input			rdclock,
	input	[4:0]		rdaddress,
	output	reg	[31:0]	q 
	);

reg	[31:0]	mem_a [0:31];

always @(posedge wrclock) if(wren) mem_a[wraddress] <= data;

always @(posedge rdclock) q <= mem_a[rdaddress];


endmodule



