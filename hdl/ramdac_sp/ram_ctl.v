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
//  Title       :  RAM Control Block
//  File        :  ram_ctl.v
//  Author      :  Jim MacLeod
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
//-- Modified Cursor Ram logic. NO LONGER USING INTERLEAVE.
//-- CURSOR PIXEL READ IS NOW USING THE EVEN SIDE ONLY.
//-- THE ODD PORT OF THE CURSOR IS NOW PERMANANTLY TIED TO 0.
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

module ram_ctl
  (
   input		pixclk, 
   input                hresetn,  
   input                colres,
   input                sixbitlin,
   input [7:0]   	p0_red_pal_adr, 
   input [7:0]          p0_grn_pal_adr, 
   input [7:0]          p0_blu_pal_adr,
   input [7:0] 		palr2dac_evn,
   input [7:0]          palg2dac_evn,
   input [7:0]          palb2dac_evn,
   
   output reg [7:0]	p0_red_pal, 	// Output to Dac.
   output reg [7:0]	p0_grn_pal, 	// Output to Dac.
   output reg [7:0]	p0_blu_pal, 	// Output to Dac.
   output reg [7:0]     palr_addr_evn,
   output reg [7:0]     palg_addr_evn,
   output reg [7:0]     palb_addr_evn
   );
  
  wire 	  apply_lin = ! (colres | sixbitlin);

  //---------------------- address for palette -----
  always @( posedge pixclk or   negedge hresetn)
    if (!hresetn) begin
      palr_addr_evn <= 8'b0;
      palg_addr_evn <= 8'b0;
      palb_addr_evn <= 8'b0;
    end else begin
      palr_addr_evn <= p0_red_pal_adr;
      palg_addr_evn <= p0_grn_pal_adr;
      palb_addr_evn <= p0_blu_pal_adr;
    end

  //-------------- Mux the odd / even data from palette -----
  always @( posedge pixclk or   negedge hresetn)
    if (!hresetn) begin
      p0_red_pal  <= 8'b0;
      p0_grn_pal  <= 8'b0;
      p0_blu_pal  <= 8'b0;
    end else begin
      p0_red_pal <= apply_lin ? {palr2dac_evn[7:2] ,palr2dac_evn[7:6]} : 
		    palr2dac_evn ;
      p0_grn_pal <= apply_lin ? {palg2dac_evn[7:2] ,palg2dac_evn[7:6]} : 
		    palg2dac_evn ;
      p0_blu_pal <= apply_lin ? {palb2dac_evn[7:2] ,palb2dac_evn[7:6]} : 
		    palb2dac_evn ;
    end

endmodule
