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
//  Title       :  Table Based Fog
//  File        :  de3d_tfog.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  The fog table generator consists of 3 pipeline stages which
//  consist of the actual fog table lookups, the differencer,
//  the fractional multiplier, and the final adder.
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

`timescale 1ps / 1ps

/************************************************************************/
/************************************************************************/

module de3d_tfog
	(
	input		de_clk,		// Drawing engine clock
	input		hb_csn,		// Chip select for fog unit
	input		hb_tfog_en,	// Fog unit selector for HBI
	input		hb_wstrb,	// Write strobe to access table
	input	[6:2]	hb_addr,	// Address to access the fog table
	input	[7:0]	hb_ben,		// Byte enables for the fog table
	input	[31:0]	hb_din,		// Data to the fog table
	input	[13:0]	zvalue,		// Z to be indexed, upper 16 bits
	input		pc_busy,

	output	[31:0]	hb_dout,	// Host data from the fog table
	output	[7:0]	fog_factor	// Fog factor to the fogging unit
	);

reg	[8:0]	z_diff_d;	/* pipeline delayed diff value		*/
reg	[7:0]	low_factor_d, low_factor_dd;
reg	[7:0]	fog_factor;
reg	[7:0]	zvalue_d;	/* re-registered lower 10 bits of z	*/
reg	[8:0]	z_add_d;	/* Value of Z to go into *		*/

wire	[5:0]	z_low, z_hi;	/* Low and high Z values for table look ups */
wire	[8:0]	z_diff;		/* 2's complement difference between 	*/
				/* Table z values			*/
wire	[18:0]	z_add;		/* Value of Z to go into *		*/
wire	[8:0]	fog_factor_s;	/* signed fog factor (sign always 0)	*/
wire	[7:0]	low_factor,	/* Lower fog factor			*/
		high_factor;	/* High fog factor			*/
wire	[7:0]	fog64;		/* Final fog entry in the table		*/
wire	[7:0]	high_factor_add;/* Take either the high_factor or fog64 */

/************************************************************************/
/* Pipeline Registers							*/
/************************************************************************/
always @(posedge de_clk) begin
  if (!busy3) fog_factor = fog_factor_s[7:0];
  if (!busy2) begin
    z_add_d = z_add[18:10];
    low_factor_dd = low_factor_d;
  end
  if (!pc_busy) begin
    z_diff_d = z_diff;
    low_factor_d = low_factor;
    zvalue_d = zvalue[7:0];
  end
end

/************************************************************************/
/* Calculate the high and low indices					*/
/************************************************************************/
assign z_low = zvalue[13:8];	// Low value is always the incoming z value
assign z_hi = z_low + 1;	// High value is the incoming value + 1 
				// except when the incoming value is
				// The largest table entry
assign high_factor_add = (&z_low) ? fog64 : high_factor;

/************************************************************************/
/* Fog table is the actual latch based cache which stores the fog values*/
/************************************************************************/
DED_FOG_TABLE	FOG_TABLE	
	(
	(~hb_csn && hb_tfog_en), 
	hb_wstrb, 
	hb_addr, 
	hb_ben, 
	hb_din, 

	z_low, 
	z_hi,
	hb_dout, 
	low_factor, 
	high_factor, 
	fog64
	);

/************************************************************************/
/* take the difference between low and high fog factors			*/
/************************************************************************/
assign z_diff = high_factor_add - low_factor;

/************************************************************************/
/* Multiply values together						*/
/************************************************************************/
MULT9SX10U	MULT9sx10u	(z_add, z_diff_d, {zvalue_d,2'b0});

/************************************************************************/
/* Find the final fog factor						*/
/************************************************************************/
assign fog_factor_s = {1'b0,low_factor_dd} + z_add_d;

endmodule
