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
//  Title       :  Palette Control
//  File        :  pal_ctl.v
//  Author      :  Jim MacLeod
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
// This manages the processor read and write modes to the palette.
// it uses the processor wr / rd clocks for processor
// commands and the passes the data to the pix clk domain
// to performs the actual sequencing of data to the palette.
//
// for proc. read from palette, the read address is always on by default
// That is: OE for this read port is always on
//
// for proc write to palettes, addr / data are
// setup 1 cycle before the write pulse
// the address is held one cycle after the write pulse.
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

module pal_ctl
	(
	hclk, 
	hresetn, 
	wrn, 
	rdn, 
	wr_mode, 
	rd_mode, 
	colres,
	pal_data1, 
	pal_data2, 
	pal_data3,  // cpu data pre filtered
	red2pal, 
	grn2pal, 
	blu2pal,     // final data to pal
	palred, 
	palgrn, 
	palblu ,       // raw data from pal
	cp_addr, 
	paladr, 
	palwr, 
	pal2cpu, 
	pal_wradr
	);

input		hclk, 
		hresetn, 
		wrn, 
		rdn, 
		wr_mode, 
		rd_mode, 
		colres;

input	[7:0]	pal_data1, 	// Data from host to pal.
		pal_data2, 
		pal_data3, 
		pal_wradr;

input	[7:0]	palred, 	// Data read from pal RAM.
		palgrn, 
		palblu;

input	[2:0]	cp_addr; 	// Read/ Write Address from host.

output	[7:0]	paladr;		// 
output		palwr ;
output	[7:0]	red2pal,	// to be written to pal.
		grn2pal, 
		blu2pal ;
output	[7:0]	pal2cpu;

parameter       PAL_WADR        = 3'h0,  // Palette Write Address register.
                PAL_RADR        = 3'h3;  // Palette Read Address register.



reg	[7:0]	pal2cpu;
reg	[7:0]	red2pal, grn2pal, blu2pal ;
reg		palwr ;
reg	[7:0]	paladr ;

reg     wr1, wr2;
reg     rd1, rd2;
reg     wr_enable, rd_enable, inc_adr;

//---------- sync the processor interface to the palette clock
always @(posedge hclk or negedge hresetn)
	begin
		if (!hresetn)
			begin
             			wr2 <= 1'b0;
             			wr1 <= 1'b0;
				rd2 <= 1'b0;
				rd1 <= 1'b0;
			end
		else 	begin
				wr2 <= wr1;
				wr1 <= wrn;
				rd2 <= rd1;
				rd1 <= rdn;
			end
	end

wire wr_pulse = wr1 & !wr2;
wire rd_pulse = rd1 & !rd2;

wire init_rd  = wr_pulse & (cp_addr == PAL_RADR);
wire init_wr  = wr_pulse & (cp_addr == PAL_WADR);
wire init_ptr =  init_wr | init_rd;

wire pal_access = wr_enable | rd_enable;

reg	[2:0]	byte_ptr;

//--------wr pointer  update-------------//
always @(posedge hclk or  negedge hresetn)
	begin
		if (!hresetn)		byte_ptr      <= 3'b100;
		else if (init_ptr) 	byte_ptr[2:0] <= 3'b100 ;
		else if (pal_access) 	byte_ptr[2:0] <= {byte_ptr[0],byte_ptr[2:1]};
	end
//---------------------------------------------------//
always @(posedge hclk or  negedge hresetn)
	begin
	if (!hresetn)
		begin
			wr_enable <= 1'b0;
			red2pal <= 8'h00;
			blu2pal <= 8'h00;
			grn2pal <= 8'h00;
		end
	else if (wr_pulse & wr_mode  & (cp_addr == 3'h1))
		begin
			red2pal <= colres ? pal_data3[7:0] : {pal_data3[5:0] , 2'b00};
                       	grn2pal <= colres ? pal_data2[7:0] : {pal_data2[5:0] , 2'b00};
                       	blu2pal <= colres ? pal_data1[7:0] : {pal_data1[5:0] , 2'b00};
                       	wr_enable <= 1'b1;
		end
	else wr_enable <= 1'b0;
	end

always @(posedge hclk or  negedge hresetn)
	begin
	if (!hresetn)
		begin
			rd_enable <= 1'b0;
			pal2cpu <= 8'h00;
		end
	else 	begin
			case (byte_ptr)
			3'b100  : pal2cpu <= colres ? palred[7:0] : {2'b00 , palred[7:2]};
			3'b010  : pal2cpu <= colres ? palgrn[7:0] : {2'b00 , palgrn[7:2]};
			default : pal2cpu <= colres ? palblu[7:0] : {2'b00 , palblu[7:2]};
			endcase

	                if (rd_pulse & rd_mode  & (cp_addr == 3'h1))
                     		rd_enable <= 1'b1;
                	else 	rd_enable <= 1'b0;

              end
	end
//-------------------------------------------------------------
//--------generate pal rd / wr_pulse---& auto inc controls-----------
always @(posedge hclk or  negedge hresetn)
	begin
		if (!hresetn)
                	begin
				palwr  <= 1'b0;
                      		inc_adr <= 1'b0; 
			end
		else begin
                 if ((wr_enable) & (byte_ptr == 3'b001)) palwr <= 1'b1;
                 else palwr <= 1'b0;

                 if ((rd_enable | wr_enable) & (byte_ptr == 3'b001))inc_adr<= 1'b1;
                 else inc_adr<= 1'b0;

           end end

//--------auto increment the palette address------------
always @(posedge hclk or  negedge hresetn)
	begin
		if (!hresetn) paladr <= 8'b0;
		else if (init_wr) paladr <= pal_wradr;
		else if (init_rd) paladr <= pal_wradr;
		else if (inc_adr) paladr <= paladr + 8'b1;
	end
//---------------------------------------------------//

 endmodule
