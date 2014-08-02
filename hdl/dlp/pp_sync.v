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
//  Title       :  Synchronizer
//  File        :  pp_sync.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
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
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps

  module pp_sync
    (
     input	de_clk,		// syncronizing clock.
     input      rstn,		// reset.
     input      tog_in,		// signal to be syncronized.

     output 	sig_out	        // syncronized pulse, one clock wide.
     );
  
  /**********************************************************************/
  /* SYNCRONIZERS							*/
  reg 		c0_rdya;
  reg 		c0_rdyc;

  always @(posedge de_clk or negedge rstn) begin
    if(!rstn) c0_rdya <= 1'b0;
    else      c0_rdya <= tog_in;
  end

  always @(posedge de_clk or negedge rstn) begin
    if(!rstn) c0_rdyc <= 1'b0;
    else      c0_rdyc <= c0_rdya;
  end

  assign sig_out = c0_rdyc ^ c0_rdya;

endmodule
