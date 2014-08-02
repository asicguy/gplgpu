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
//  Title       :  Drawing Engine Register Block Misc.
//  File        :  der_misc.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module is the top level register block for Imagine-MI
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

module der_misc
	(
	input		de_clk,		/* drawing engine clock input		*/
	input		hb_clk,		/* host bus clock input		        */
	input		prst,		/* Pattern Reset			*/
	input		cr_pulse,
	input [1:0] 	ps_sel_2,	// buf_ctrl_2[10:9]
	input		bc_co,
	input [31:0] 	mf_sorg_2,      /* multi function sorg.          	*/
	input [31:0] 	mf_dorg_2,      /* multi function dorg.                 */
	input [1:0] 	apat_1,
	input		sd_selector,	// buf_ctrl_2[4]
  
	output	reg		prst_1,
	output 			hb_ca_rdy,
	output 			de_ca_rdy,
	output 			ps16s_2,
	output 			ps565s_2,
	output		[31:0]	de_sorg_2,      /* source origin register output        */
	output		[31:0]	de_dorg_2,      /* destination origin register output   */
	output		[27:0]	sorg_2,         /* source origin register output        */
	output		[27:0]	dorg_2,         /* destination origin register output   */
	output			or_apat_1
	);
  
  // reg 		hb_ca_rdy_d;
  // reg 		hb_ca_rdy_ddd;
  // reg 		de_ca_rdy_d;
  // reg 		de_ca_rdy_ddd;
  // reg		ca_rdy;
  
  // wire 		crdy_rstn;
  // wire 		hb_ca_rdy_dd;
  // wire 		de_ca_rdy_dd;
  
  assign 	or_apat_1 = |apat_1;
  
  always @(posedge de_clk) prst_1 <= prst;
  
  assign 	ps16s_2  = ~ps_sel_2[1] &  ps_sel_2[0];
  assign 	ps565s_2 = &ps_sel_2[1:0];

/*
  // Cache ready for HB and DE
  assign 	crdy_rstn = 		rstn;

  always @(posedge cr_pulse or negedge crdy_rstn)
    if(!crdy_rstn) ca_rdy <= 1'b0;
    else 	   ca_rdy <= 1'b1;

  always @(posedge hb_clk)	hb_ca_rdy_d <= ca_rdy;
  always @(posedge hb_clk)	hb_ca_rdy_ddd <= hb_ca_rdy_d;
  assign hb_ca_rdy = ca_rdy | hb_ca_rdy_ddd;

  always @(posedge de_clk)	de_ca_rdy_d <= ca_rdy;
  always @(posedge de_clk)	de_ca_rdy_ddd <= de_ca_rdy_d;
  assign de_ca_rdy = (ca_rdy & de_ca_rdy_ddd) | bc_co;
*/

  assign hb_ca_rdy = 1'b1;
  assign  de_ca_rdy = 1'b1;
  assign de_sorg_2 = {32{sd_selector}} & mf_sorg_2;
  assign de_dorg_2 = {32{sd_selector}} & mf_dorg_2;
  // assign sorg_2 = {28{~sd_selector}} & mf_sorg_2[31:4];
  // assign dorg_2 = {28{~sd_selector}} & mf_dorg_2[31:4];
  assign sorg_2 = {28{~sd_selector}} & {6'h0, mf_sorg_2[25:4]};
  assign dorg_2 = {28{~sd_selector}} & {6'h0, mf_dorg_2[25:4]};

endmodule


