///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2009 - All rights reserved
//
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Conexant Systems, Inc., hereafter the "licensee", as defined by the NDA and the 
//  license agreement. 
//
//  This code may not be used as a basis for new development without a written
//  agreement between Silicon Spectrum and the licensee. 
//
//  New development includes, but is not limited to new designs based on this 
//  code, using this code to aid verification or using this code to test code 
//  developed independently by the licensee.
//
//  This copyright notice must be maintained as written, modifying or removing
//  this copyright header will be considered a breach of the license agreement.
//
//  The licensee may modify the code for the licensed project.
//  Silicon Spectrum does not give up the copyright to the original 
//  file or encumber in any way.
//
//  Use of this file is restricted by the license agreement between the
//  licensee and Silicon Spectrum, Inc.
//  
//  Title       :  Dispatcher State Machine
//  File        :  dex_smdisp.v
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
module dex_smdisp
	(
	 input		de_clk,
	 input		de_rstn,
	 input		d_busy,
	 input		cmdrdy,
	 input		pcbusy,
	 input		line_actv_1,
	 input		blt_actv_1,
	 input		noop_actv_2,

	output	reg	goline,
	output	reg	goblt,
	output	reg	d_cmdack,
	output	reg	d_cmdcpyclr,
	output	reg	load_actvn,
	// For test only.
	 output	reg	[1:0]	d_cs
	);

/****************************************************************/
/* 			DEFINE PARAMETERS			*/
/****************************************************************/
/* define state parameters */
parameter
	IDLE=2'b00,
	DECODE=2'b01,
	BUSY=2'b10;

/* define internal wires and make assignments 	*/
// reg	[1:0]	d_cs;
reg	[1:0]	d_ns;

/* create the state register */
always @(posedge de_clk or negedge de_rstn) 
	begin
		if(!de_rstn)d_cs <= 2'b0;
		else d_cs <= d_ns;
	end
reg	igoblt;
reg	igoline;
always @(posedge de_clk) goline <= igoline;
always @(posedge de_clk) goblt <= igoblt;

always @* begin
		d_cmdack=1'b0;
		d_cmdcpyclr=1'b0;
		load_actvn=1'b1;
		igoline=1'b0;
		igoblt=1'b0;
		case(d_cs) /* synopsys parallel_case */
			IDLE:	if(!cmdrdy || pcbusy)d_ns=IDLE;
				else begin
					load_actvn=1'b0;
					d_cmdack=1'b1;
					d_ns=DECODE;
					if(line_actv_1) igoline=1'b1;
					if(blt_actv_1)  igoblt=1'b1;
				end

			DECODE:	d_ns=BUSY;

		  BUSY:	begin
		    if((noop_actv_2) || !d_busy)
		      begin
			d_ns=IDLE;
			d_cmdcpyclr=1'b1;
		      end
		    else d_ns=BUSY;
		  end
		  default: begin
					d_ns=IDLE;
					d_cmdcpyclr=1'b0;
					load_actvn=1'b1;
					d_cmdack=1'b0;
				end
		endcase
	end

endmodule
