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
//  Title       :  DLP Cache.
//  File        :  dlp_top.v
//  Author      :  Frank Bruno
//  Created     :  17-March-2012
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  The Display List Processor is used to automatically run commands
//  to the Drawing engine, copy engine, or the DMA controller.
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

`timescale 1 ns / 10 ps

  module dlp_cache
    #(parameter BYTES = 4
      )
    (
     input                 hb_clk,         // clock input
     input                 hb_rstn,        // reset input
     input                 dlp_flush,      // Flush when end of list is reached.
     input                 dlp_pop,        // DLP read signal.
     //
     input                 mclock,         // Memory controller clock
     input                 mc_push,        // memory controller push           
     input [(BYTES*8)-1:0] pd_in,          // pixel data input                
     
     //**********************************************************************
     // outputs to the Host Bus                                              
     //**********************************************************************
     output                	dlp_data_avail, // DLP data Available.
     output [(BYTES*8)-1:0]	dlp_data,       // DLP data.
     output [6:0]		rdusedw
     );

  /************************************************************************/
  /* DLP FIFO.                                                            */
  /************************************************************************/

  wire rdempty;
  wire flush_ff = (dlp_flush | ~hb_rstn);
  assign dlp_data_avail = ~rdempty;


  fifo_128x128a u_fifo_128_128a
  	(
	.aclr		(flush_ff),
	.wrclk		(mclock),
	.wrreq		(mc_push),
	.data		(pd_in),
	.wrempty	(),
	.wrusedw	(),

	.rdclk		(hb_clk),
	.rdreq		(dlp_pop),
	.q		(dlp_data),
	.rdempty	(rdempty),
	.rdusedw	(rdusedw)
	);



endmodule
