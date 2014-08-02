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

module flt_fx_mult
	(
	input	     	clk,
	input	     	rstn,
	input	[23:0]	fx,
	input	[31:0]	bfl,

	output	reg [31:0]	fl
	);

reg		sfx;		// Sign of fixed
reg	[23:0]	afx;		// Absolute fixed


reg	[4:0]	nom_shft_1;	// Normalize shift.
reg	[47:0]	nmfl_1;		// Mantisa of the Float
reg	[47:0]	mfl_1;		// Multiply Result.
reg		sfx_1;
reg		sbfl_1;
reg	[7:0]	efl_1;		// Exponent of the Float
reg	[7:0]	ebfl_1;		// Exponent of the Float
reg		sfl_1;		// Sign of float
reg		result0;
reg		result0_1;

always @* // Take the absolute value of AFX.
        begin
                if(fx[23]) begin
                                sfx = 1;
                                afx = ~fx + 1;
                end else begin
                                sfx = 0;
                                afx = fx;
                end
		if((fx==0) || (bfl[30:0]==0))result0 = 1;
		else result0 = 0;
        end

// Calculate the Mantissa.
always @(posedge clk, negedge rstn) begin
	if(!rstn) begin
		mfl_1     <= 47'h0;
        	sfx_1     <= 1'b0;
		sbfl_1    <= 1'b0;
		ebfl_1    <= 8'h0;
		result0_1 <= 1'b0;

	end else begin
		mfl_1     <= afx * {1'b1,bfl[22:0]};
        	sfx_1     <= sfx;
		sbfl_1    <= bfl[31];
		ebfl_1    <= bfl[30:23];
		result0_1 <= result0;
	end
end


always @* begin
		casex(mfl_1[47:23]) /* synopsys full_case parallel_case */
		25'b1xxxxxxxxxxxxxxxxxxxxxxxx: nom_shft_1=0;
		25'b01xxxxxxxxxxxxxxxxxxxxxxx: nom_shft_1=1;
		25'b001xxxxxxxxxxxxxxxxxxxxxx: nom_shft_1=2;
		25'b0001xxxxxxxxxxxxxxxxxxxxx: nom_shft_1=3;
		25'b00001xxxxxxxxxxxxxxxxxxxx: nom_shft_1=4;
		25'b000001xxxxxxxxxxxxxxxxxxx: nom_shft_1=5;
		25'b0000001xxxxxxxxxxxxxxxxxx: nom_shft_1=6;
		25'b00000001xxxxxxxxxxxxxxxxx: nom_shft_1=7;
		25'b000000001xxxxxxxxxxxxxxxx: nom_shft_1=8;
		25'b0000000001xxxxxxxxxxxxxxx: nom_shft_1=9;
		25'b00000000001xxxxxxxxxxxxxx: nom_shft_1=10;
		25'b000000000001xxxxxxxxxxxxx: nom_shft_1=11;
		25'b0000000000001xxxxxxxxxxxx: nom_shft_1=12;
		25'b00000000000001xxxxxxxxxxx: nom_shft_1=13;
		25'b000000000000001xxxxxxxxxx: nom_shft_1=14;
		25'b0000000000000001xxxxxxxxx: nom_shft_1=15;
		25'b00000000000000001xxxxxxxx: nom_shft_1=16;
		25'b000000000000000001xxxxxxx: nom_shft_1=17;
		25'b0000000000000000001xxxxxx: nom_shft_1=18;
		25'b00000000000000000001xxxxx: nom_shft_1=19;
		25'b000000000000000000001xxxx: nom_shft_1=20;
		25'b0000000000000000000001xxx: nom_shft_1=21;
		25'b00000000000000000000001xx: nom_shft_1=22;
		25'b000000000000000000000001x: nom_shft_1=23;
		25'b0000000000000000000000001: nom_shft_1=24;
		endcase
	end

// Calculate the sign bit.
always @* sfl_1 = sfx_1 ^ sbfl_1;

// Calculate the Exponant.
always @* efl_1 = ebfl_1 + (8'h10 - nom_shft_1);

always @* nmfl_1 = mfl_1 << nom_shft_1;

always @(posedge clk, negedge rstn)	//(SFL or EFL or MFL or FX or BFL)
	begin
		if(!rstn) fl <= 32'h0;
		else if(result0_1) fl <= 32'h0;
		else fl <= {sfl_1,efl_1,nmfl_1[46:24]};
	end


endmodule
