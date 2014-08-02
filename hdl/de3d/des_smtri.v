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
//  Title       :  Triangle State Machine
//  File        :  des_smtri.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
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

`timescale 1 ps / 1 ps

module des_smtri
	(
	input		de_clk,
	input		de_rstn,
	input		load_actv_3d,
	input		line_actv_3d,
	input 		scan_dir_2,
	input [1:0] 	stpl_2,
	input 		stpl_pk_1,
	input 		apat32_2,
	input 		mw_fip,
	input 		pipe_busy,
	input		mcrdy,
	input [255:0]	spac_bus,

	output reg		t3_pixreq,
	output reg		t3_last_pixel,
	output reg		t3_msk_last,
	output reg signed      [15:0]  cpx,		// Current position X.
	output reg signed      [15:0]  cpy,		// Current position Y.
	output reg	[7:0]	tri_wrt,
	output reg	[31:0]	tri_dout
	);

	`include "define_3d.h"

/****************************************************************/
/* 			DEFINE PARAMETERS			*/
/****************************************************************/
`define WRT_WCNT 8'b00000001

`ifdef RTL_ENUM
	enum {
	T3_WAIT  = 4'h0,
	T3_1     = 4'h1,
	T3_2     = 4'h2,
	T3_3     = 4'h3,
	T3_4     = 4'h4,
	T3_5     = 4'h5,
	T3_6     = 4'h6,
	T3_7     = 4'h7,
	T3_SWAP1 = 4'h8,
	T3_SWAP2 = 4'h9,
	T3_IDLE  = 4'hA
	} t3_cs;
`else
parameter
	T3_WAIT  = 4'h0,
	T3_1     = 4'h1,
	T3_2     = 4'h2,
	T3_3     = 4'h3,
	T3_4     = 4'h4,
	T3_5     = 4'h5,
	T3_6     = 4'h6,
	T3_7     = 4'h7,
	T3_SWAP1 = 4'h8,
	T3_SWAP2 = 4'h9,
	T3_IDLE  = 4'hA;
reg	[3:0]	t3_cs;
`endif

/* define internal wires and make assignments 	*/
reg		go_span;
reg		span_busy;
reg		span_wait;

// S16.16
reg signed [31:0]	e1x;
reg signed [31:0]	e2x;
reg signed [31:0]	e3x;
reg signed [31:0]	e1s;
reg signed [31:0]	e2s;
reg signed [31:0]	e3s;
// 16
reg	[15:0]	ns1;
reg	[15:0]	ns2;


wire		t3_ns1_eqz;
wire		t3_ns2_eqz;
wire		t3_ns2_eq1;

reg		t3_dp_save;
reg		t3_last_line;
reg		last_span;

reg		gotri3_2;
reg		gotri3_1;

/********************************************************************************/
/*			TRIANGLE SCAN EDGE REGISTERS				*/
/********************************************************************************/
reg signed	[31:0]	lft_x;
reg signed	[31:0]	rht_x;
wire signed	[15:0]	cpx_l;	// Current Left.
wire signed	[15:0]	cpx_r;	// Current Right.
wire signed	[15:0]	len;	// Current length.
reg	[15:0]	len_reg;
reg	[15:0]	cpy_i;

assign t3_ns1_eqz = ~|ns1;
assign t3_ns2_eqz = ~|ns2;
assign t3_ns2_eq1 = (~|ns2[15:1]) & ns2[0];


always @(posedge de_clk, negedge de_rstn)
	begin
		if(!de_rstn) lft_x <= 32'h0;
		else if(t3_dp_save && !scan_dir_2) lft_x <= e1x;
		else if(t3_dp_save && scan_dir_2) lft_x <= e2x;
	end

always @(posedge de_clk, negedge de_rstn)
	begin
		if(!de_rstn) rht_x <= 32'h0;
		else if(t3_dp_save && !scan_dir_2) rht_x <= e2x;
		else if(t3_dp_save &&  scan_dir_2) rht_x <= e1x;
	end

// Ceil
assign cpx_l = lft_x[31:16] + (|lft_x[15:0]);
// Floor
assign cpx_r = rht_x[31:16] - (~|rht_x[15:0]);

assign len = (cpx_r - cpx_l) + 16'h1;

/****************************************************************************************/
always @(posedge de_clk or negedge de_rstn) begin
	if(!de_rstn) begin
		t3_cs <= T3_WAIT;
		e1x   <= 32'h0;
		e2x   <= 32'h0;
		e3x   <= 32'h0;
		e1s   <= 32'h0;
		e2s   <= 32'h0;
		e3s   <= 32'h0;
		ns1   <= 16'h0;
		ns2   <= 16'h0;
		cpy_i <= 16'h0;
		go_span <= 1'b0;
		gotri3_1 <= 1'b0;
		gotri3_2 <= 1'b0;
		t3_last_line <= 1'b0;
		t3_dp_save   <= 1'b0;
		last_span <= 1'b0;
	end else begin
		t3_dp_save<= 1'b0;

		tri_wrt  <= 8'h0;
               	tri_dout <= 32'd0;
		go_span  <= 1'b0;

		gotri3_2 <= gotri3_1;
		gotri3_1 <= load_actv_3d;

/****************************************************************************************/
/*											*/
/****************************************************************************************/
	case(t3_cs)
	T3_WAIT: begin
		if(gotri3_2 && !line_actv_3d) begin
			cpy_i <= spac_bus`CPY;
			e1x   <= spac_bus`E1X;
			e2x   <= spac_bus`E2X;
			e3x   <= spac_bus`E3X;
			e1s   <= spac_bus`E1S;
			e2s   <= spac_bus`E2S;
			e3s   <= spac_bus`E3S;
			ns1   <= spac_bus`NS1;
			ns2   <= spac_bus`NS2;
			t3_last_line <=0;
			if(!stpl_pk_1) t3_cs<=T3_1;
			else begin // Load the word count to read the pattern.
				t3_cs<=T3_1;
				tri_wrt <= `WRT_WCNT;
                		if(apat32_2) tri_dout <= 32'd8; // 32x32 pattern.
                		else	     tri_dout <= 32'd1; // 8x8 pattern.
			end
		end
		else begin
			t3_cs<=T3_WAIT;
		end
	end
	/* add the pattern off set and load the registers */
	/* fifo read pointer,  funnel shift count one and two. */
	T3_1:	begin	
		t3_dp_save<= 1'b1;
		if(stpl_2[1]) begin
			t3_cs<=T3_2;
		end
		else t3_cs<=T3_3;
	end
	T3_2:	begin /* request a read of the pattern from the MC. */
                // t3_op<={noop,pline,mov,noop,wrno};
		if(stpl_2[1] && mcrdy && !mw_fip)
			begin
				t3_cs<=T3_3;
			end
			else if(stpl_2[1])t3_cs<=T3_2;
			else t3_cs<=T3_3;	// Memory is busy.
	end

/****************************************************************************************/
/*	This is the seek phase, 							*/
/*		If outside of the e2 edge begin scanning right if scan_dir<=1,		*/
/*		or left  if scan_dir <= 0, until just inside edge e2. 			*/
/*											*/
/*		Else if inside the e2 edge begin scanning left if scan_dir<=1,		*/
/*		or right if scan_dir<=0 until just outside of the edge e2,		*/
/*		 then step to the left or right one.					*/
/*											*/
/*		Else if right on the edge you are done.					*/
/*		Else if right on the edge you are done.					*/
/****************************************************************************************/
			T3_3:	begin
					if(t3_ns1_eqz) begin
			     			t3_cs<=T3_SWAP2;	// Flat top.
						e1x <= e3x;
						// e2x <= e2s + e2x;
						// ns2 <= ns2 - 1;
						// cpy_i <= cpy_i + 16'h1;
					end
					else begin
			     			t3_cs<=T3_4;
						if(t3_ns2_eq1) t3_last_line <= 1'b1;
					end
				end
			T3_4:	begin
					// Start the first span.
					if(!span_busy) begin
						t3_cs<=T3_5;
						go_span <= 1'b1;
						last_span <= t3_last_line;
					end
					else t3_cs<=T3_4;
				end
			T3_5:	begin	
					// Move to next line.
					e1x <= e1s + e1x;
					e2x <= e2s + e2x;
					ns1 <= ns1 - 16'h1;
					ns2 <= ns2 - 16'h1;
					t3_cs<=T3_6;
				end
/****************************************************************************************/
/* The previous scan line has been completed, and spy has been incremented.		*/
/* Now find the next x for both e2 and e1. This is done by adding the e1s to e1x	*/
/* and e2s to e2x. 									*/

			T3_6: 	begin
					t3_dp_save<= 1'b1;
					/* No more scan lines all done. */
					if(t3_ns2_eqz) begin
						t3_cs<=T3_IDLE;
					end
					else begin 
						if(t3_ns2_eq1) t3_last_line <= 1'b1;
						t3_cs<=T3_7;
						cpy_i <= cpy_i + 16'h1;
					end
				end
			T3_7:	begin
					if(t3_ns1_eqz) begin
						t3_cs<=T3_SWAP1;		// Go swap edge one.
					end
					else begin
						t3_cs<=T3_4;
					end
				end

/****************************************************************************************/
/* Replace edge 1 with edge 3, and continue.                                		*/
			T3_SWAP1:begin 
					t3_cs<=T3_SWAP2;
					e1x <= e3x;
				end
			T3_SWAP2:begin 
					t3_cs<=T3_4;
					e1s <= e3s;
					t3_dp_save<= 1'b1;
					if(t3_ns2_eq1) t3_last_line <= 1'b1;
				end
/****************************************************************************************/
/* Triangle idle state.                                                    		*/
			T3_IDLE: begin
				t3_cs<=T3_WAIT;
			end
		endcase

	end
end

//////////////////////////////////////////////////////////////////////////////////////////
//
// Span filling function.

always @(posedge de_clk, negedge de_rstn) begin
	if(!de_rstn) begin
		t3_pixreq        <= 1'b0;
		len_reg          <= 16'h0;
		span_busy        <= 1'b0;
		cpx              <= 16'h0;
		cpy              <= 16'h0;
		t3_last_pixel    <= 1'b0;
		span_wait        <= 1'b0;
		t3_msk_last      <= 1'b0;
	end
	else begin
		t3_msk_last      <= 1'b0;
		t3_pixreq        <= 1'b0;
		t3_last_pixel    <= 1'b0;

		if((~|len_reg[15:1]) && len_reg[0] && !pipe_busy) begin
			t3_last_pixel <= last_span;
		end

		else if(go_span && !pipe_busy && !span_wait && (len == 16'h1))  begin
			t3_last_pixel <= last_span;
		end

		else if(go_span && last_span && (len == 16'h0))  begin
			t3_last_pixel <= 1'b1;
			t3_msk_last   <= 1'b1;
			t3_pixreq     <= 1'b1;
			cpy    <= cpy_i;
			if(scan_dir_2) begin 
				cpx    <= cpx_l;
			end
			else begin
				cpx    <= cpx_r;
			end
		end

		if(go_span && !pipe_busy && (|len)) begin
			t3_pixreq<=1'b1;
			len_reg <= len - 16'h1; 
			span_busy <= 1'b1;
			cpy <= cpy_i;
			if(scan_dir_2) begin 
				cpx    <= cpx_l;
			end
			else begin
				cpx    <= cpx_r;
			end
		end
		else if(go_span && pipe_busy && (|len)) begin
			len_reg <= len; 
			span_busy <= 1'b1;
			span_wait <= 1'b1;
			cpy <= cpy_i;
			if(scan_dir_2) begin 
				cpx    <= cpx_l;
			end
			else begin
				cpx    <= cpx_r;
			end
		end
		// If len_reg = ffff, No Pixels.
		// if(span_busy && (len == 16'hffff)) span_busy <= 1'b0;
		// Scan remaining Pixels.
		//
		else if(span_busy && span_wait && |len_reg && !pipe_busy) begin
			len_reg <= len_reg - 16'h1;
			t3_pixreq<=1'b1;
			span_wait <= 1'b0;
		end
		else if(span_busy && !span_wait && |len_reg && !pipe_busy) begin
			if(scan_dir_2) begin
				cpx <= cpx + 16'h1;
			end
			else begin
		 		cpx <= cpx - 16'h1;
			end
			len_reg <= len_reg - 16'h1;
			t3_pixreq<=1'b1;
		end
		// Scan remaining Pixels.
		else if(span_busy && !pipe_busy) begin
			span_busy <= 1'b0;
			span_wait <= 1'b0;
		end
	end
end

endmodule
