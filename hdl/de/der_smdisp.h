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
//  Title       :  Dispatcher State Machine
//  File        :  der_smdisp.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Included by dex_sm.v
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
`timescale 1ns / 10ps
module der_smdisp
	(
	 input		de_clk,
	 input		de_rstn,
	 input		en_3d,
	 input		cmdrdy,
	 input		sup_done,
	 input		abort_cmd,
	 input		dex_busy,
	 input	[3:0]	opc_1,
	 input	[3:0]	opc_15,
	 input	[3:0]	opc_2,
	 input		pc_last,	// Last push from the pixel cache.
	 input		cmd_done_3d,

	 output reg	go_sup,
	 output	reg	load_15,	// Transfer parameters from L1 to L1.5
	 output	reg	load_actvn,	// Transfer parameters from L1.5 to L2 or L1 to L2.
	 output	reg	load_actv_3d,	// Transfer parameters from L1.5 to L2, in 3D engine.
	 output	reg	goline,
	 output	reg	goblt,
	 output reg	pal_load,
	 output reg	tc_inv_cmd,
	 output	reg	cmdack,
	 output	reg	cmdcpyclr
	 );

//////////////////////////////////////////////////////////////////
//			DISPATCHER STATE MACHINE
// 			DEFINE PARAMETERS
//

reg	abort_cmd_flag;
reg	abort_cmd_ack;
reg	sup_done_flag;
reg	sup_done_ack;
reg	goline_ii;
reg	goblt_ii;
reg	goline_i;
reg	goblt_i;
reg	dex_3d_busy;
reg	sup_busy;

`ifdef RTL_ENUM
	enum {
	IDLE		=3'b000,
	DECODE		=3'b001,
	DECODE2		=3'b010,
	WAIT_SUP	=3'b011,
	DECODE3		=3'b100,
	WAIT_3D		=3'b101,
	BUSY		=3'b110,
	NOOP_ST		=3'b111
	} d_cs;
`else
parameter
	IDLE		=3'b000,
	DECODE		=3'b001,
	DECODE2		=3'b010,
	WAIT_SUP	=3'b011,
	DECODE3		=3'b100,
	WAIT_3D		=3'b101,
	BUSY		=3'b110,
	NOOP_ST		=3'b111;

reg [2:0] d_cs;
`endif

parameter
	NOOP      	= 4'h0,
	BLT       	= 4'h1,
	LINE      	= 4'h2,
	ELINE     	= 4'h3,
	P_LINE     	= 4'h5,
	RXFER     	= 4'h6,
	WXFER     	= 4'h7,
	LINE_3D     	= 4'h8,
	TRIAN_3D     	= 4'h9,
	LD_TEX     	= 4'hA,
	LD_TPAL     	= 4'hB,
	busy_0  	= 3'b001,
	busy_15 	= 3'b010,
	busy_2  	= 3'b100;

// Delay goblt and goline for data delay.
always @(posedge de_clk, negedge de_rstn) begin
	if(!de_rstn) begin
		goblt_ii  <= 1'b0;
		goline_ii <= 1'b0;
		goblt     <= 1'b0;
		goline    <= 1'b0;
	end
	else begin
		goblt     <= goblt_ii;
		goblt_ii  <= goblt_i;
		goline    <= goline_ii;
		goline_ii <= goline_i;
	end
end
// Capture abort and sup_done.
always @(posedge de_clk, negedge de_rstn) begin
	if(!de_rstn) begin
		abort_cmd_flag <= 1'b0;
		sup_done_flag  <= 1'b0;
		dex_3d_busy    <= 1'b0;
	end
	else begin
		if(abort_cmd) abort_cmd_flag <= 1'b1;
		else if(abort_cmd_ack) abort_cmd_flag <= 1'b0;
		if(sup_done) sup_done_flag <= 1'b1;
		else if(sup_done_ack) sup_done_flag <= 1'b0;
		if(load_actv_3d) dex_3d_busy    <= 1'b1;
		// else if(cmd_done_3d) dex_3d_busy    <= 1'b0;
		else if(pc_last) dex_3d_busy    <= 1'b0;
	end
end

always @(posedge de_clk, negedge de_rstn) begin
	if(!de_rstn) begin
		go_sup 		<= 1'b0;
		sup_busy 	<= 1'b0;
		load_15		<= 1'b0;
		cmdack		<= 1'b0;
		load_actvn 	<= 1'b1;
		load_actv_3d 	<= 1'b0;
		cmdcpyclr 	<= 1'b0;
		goline_i	<= 1'b0;
		goblt_i		<= 1'b0;
		pal_load	<= 1'b0;
		tc_inv_cmd	<= 1'b0;
		abort_cmd_ack	<= 1'b0;
		sup_done_ack	<= 1'b0;
		d_cs 		<= IDLE;
	end 
	else begin
		go_sup		<= 1'b0;
		load_15		<= 1'b0;
		cmdack		<= 1'b0;
		load_actvn 	<= 1'b1;
		load_actv_3d 	<= 1'b0;
		cmdcpyclr 	<= 1'b0;
		goline_i	<= 1'b0;
		goblt_i		<= 1'b0;
		pal_load	<= 1'b0;
		tc_inv_cmd	<= 1'b0;
		abort_cmd_ack	<= 1'b0;
		sup_done_ack	<= 1'b0;

	case(d_cs)
	// No commands in pipe.
	// Wait for command ready.
	IDLE:	if(!cmdrdy)d_cs <= IDLE;
		// NOOP, or obsolete RXFER, WXFER.
		else if((opc_1==NOOP) || (opc_1==RXFER) || (opc_1==WXFER)) begin
		        cmdack		<= 1'b1;	// Free Level 1.
			d_cs 		<= NOOP_ST;	// Kill one cycle.
		end
		// 2D Command.
		// 3D Command, load L15, and start setup engine.
		else if(((opc_1==TRIAN_3D) || (opc_1==LINE_3D)) & en_3d & !sup_busy) begin
			go_sup 		<= 1'b1;	// Start setup.
			load_15		<= 1'b1;	// Load Level 15.
		        cmdack		<= 1'b1;	// Free Level 1.
		        sup_busy	<= 1'b1;
			d_cs 		<= WAIT_SUP;	// Go wait for setup.
		end
		// 2D Command.
		else begin
			if(opc_1 == BLT)     begin goblt_i  <= 1'b1; cmdack <= 1'b1; end
			if(opc_1 == LINE)    begin goline_i <= 1'b1; cmdack <= 1'b1; end
			if(opc_1 == ELINE)   begin goline_i <= 1'b1; cmdack <= 1'b1; end
			if(opc_1 == P_LINE)  begin goline_i <= 1'b1; cmdack <= 1'b1; end
			if((opc_1 == LD_TEX) & en_3d)  cmdack <= 1'b1;
			if((opc_1 == LD_TPAL) & en_3d) cmdack <= 1'b1;
			if(en_3d) begin // if 3D Core, L15 is included.
				load_15	<= 1'b1;
				d_cs    <= DECODE;
			end else begin // else just L2 is included.
				load_actvn <= 1'b1;
				d_cs       <= DECODE2;
			end
		end
	DECODE:	begin // Not a 3D command transfer 1.5 to 2.0
			d_cs <= DECODE2;
			load_actvn <= 1'b0;
		end
	DECODE2: d_cs <= BUSY;

	WAIT_SUP: begin // Wait for setup, no 3D in progress.
		if(abort_cmd_flag) begin
			d_cs 		<= IDLE;
			cmdcpyclr       <= 1'b1;
			abort_cmd_ack	<= 1'b1;
			sup_busy	<= 1'b0;
		end
		// SUP done no 3D in progress.
		else if(sup_done_flag && !dex_3d_busy) begin
			d_cs <= DECODE3;
			load_actvn   <= 1'b0;
			load_actv_3d <= 1'b1;
			sup_done_ack <= 1'b1;
			sup_busy     <= 1'b0;
		end
		else d_cs <= WAIT_SUP;
		end
	DECODE3: d_cs <= WAIT_3D;

	WAIT_3D: begin // 3D in progress, another setup can be started.
		if(!dex_3d_busy) begin
			d_cs <= IDLE;
			cmdcpyclr <= 1'b1;
		end
		else if(!cmdrdy || sup_busy)d_cs <= WAIT_3D;
		// if another 3D command start setup.
		else if((opc_1==TRIAN_3D) || (opc_1==LINE_3D)) begin
			go_sup 		<= 1'b1;	// Start setup.
			load_15		<= 1'b1;	// Load Level 15.
		        cmdack		<= 1'b1;	// Free Level 1.
		        sup_busy	<= 1'b1;
			d_cs 		<= WAIT_SUP;	// Go wait for setup.
		end
		else d_cs <= WAIT_3D;
		end
	BUSY:	begin
		if(opc_2 == LD_TEX && !dex_3d_busy) begin // texture load command done
			d_cs 		<= IDLE;
			cmdcpyclr 	<= 1'b1;
			tc_inv_cmd 	<= 1'b1;
		end
		else if(opc_2==LD_TPAL && !dex_3d_busy) begin // palette load command done.
			d_cs 		<= IDLE;
			cmdcpyclr 	<= 1'b1;
			pal_load 	<= 1'b1;
		end
		else if(opc_2==LD_TEX  && dex_3d_busy)d_cs <= BUSY;
		else if(opc_2==LD_TPAL && dex_3d_busy)d_cs <= BUSY;
		else if((opc_2== NOOP) || !dex_busy) begin
			d_cs <= IDLE;
			cmdcpyclr <= 1'b1;
		end
		else d_cs <= BUSY;
		end
	NOOP_ST: d_cs <= IDLE;
	endcase
	end
end

endmodule



