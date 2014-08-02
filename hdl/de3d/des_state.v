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
//  Title       :  Setup State Machine
//  File        :  des_state.v
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

module des_state
	(
	input		se_clk,
	input		se_rstn,
	input		go_sup,
	input		line_3d_actv_15,
	input		ns1_eqz,
	input		ns2_eqz,
	input		co_linear,
	input		det_eqz,
	input		cull,

	output reg		sup_done,
 	output reg		abort_cmd, 
	output reg	[5:0]	se_cstate
	);

	`include "define_3d.h"

	reg		go_sup_1;
	reg		go_sup_2;

/*******************Setup Engine Program Counter *******************/
  always @ (posedge se_clk or negedge se_rstn) begin
	    if (!se_rstn) begin
		    se_cstate <= 6'b000000;
      		    sup_done  <= 1'b0;
	      	    abort_cmd <= 1'b0;
		    go_sup_1  <= 1'b0;
		    go_sup_2  <= 1'b0;
	    end
	    else begin
		go_sup_2  <= go_sup_1;
		go_sup_1  <= go_sup;
	      	abort_cmd <= 1'b0;
      		if((se_cstate == 6'b000000) & go_sup_2) se_cstate <= 6'b000001;
		else if((se_cstate == `COLIN_STATE) & co_linear & ~line_3d_actv_15) begin 
	      		abort_cmd <= 1'b1;
	      		se_cstate <= 6'b000000;
	    	end
		else if((se_cstate == `NL1_NL2_STATE) & (ns1_eqz & ns2_eqz & ~line_3d_actv_15)) begin
	      		abort_cmd <= 1'b1;
	      		se_cstate <= 6'b000000;
	    	end
		else if((se_cstate == `NO_AREA_STATE) & ((cull | det_eqz) & ~line_3d_actv_15)) begin
	      		abort_cmd <= 1'b1;
	      		se_cstate <= 6'b000000;
	    	end
      		else if(se_cstate == 6'b000000) se_cstate <= 6'b000000;
      		else if((se_cstate == `SETUP_END)) se_cstate <= 6'b000000;
      		else se_cstate <= se_cstate + 6'b000001;

      		sup_done <= (se_cstate == `SETUP_END);
    	   end
   end

endmodule
