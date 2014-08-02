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
//  Title       :  Drawing Engine Top Level Miscelaneos module
//  File        :  de_top_misc.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module contains functionality which used to be instantiated at the
//  top level
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

module de_top_misc
  (// inputs
   input	         de_clk,
   input	         sys_locked,
   input 	         hb_clk,
   input 	         hb_rstn,
   input [1:0] 	         ps_2,
   input 	         pc_mc_rdy,
   input 	         busy_hb,
   input 	         mw_de_fip,	      
   input [4:0] 	         dr_style_2,	
   input 	         dx_blt_actv_2,
   input 	         load_actvn,
   input 	         line_actv_2,
   input 	         wb_clip_ind,
   input 	         clip,
   input 	         deb,
   input 	         cmd_trig_comb,  
   input  	         line_actv_1,
   input  	         blt_actv_1,
   input [23:0] 	 de_key_2,
   input 	         cmdcpyclr,
   input                 pc_empty,
   input                 abort_cmd_flag,
   input [3:0]           opc_1,
   
   output reg	         mw_fip,
   output	         ca_busy,
   output	         ps8_2,     
   output	         ps16_2,  
   output	         ps565_2,  
   output	         ps32_2,  
   output	         de_pad8_2,
   output [1:0] 	 stpl_2,
   output reg	         de_rstn,
   output reg	         de_clint_tog,
   output reg	         dx_clp,
   output reg	         dx_deb,
   output [31:0]         kcol_2,
   output	         de_trnsp_2,
   output reg	         de_ddint_tog,
   output [3:0]          probe_misc
   );
  
   parameter 	LD_TEX = 4'hA, LD_TPAL = 4'hB;

  wire		 wb_clip_rstn;
  wire		 clip_ddd;
  reg		 mw_fip_dd, de_busy_sync;
  reg		 ca_busyi;
  reg		 tmp_rstn;
  reg		 clip_disab;
  reg		 wb_clip;
  reg		 clip_d, clip_dd;   
  reg		 deb_clr_hold;
  reg		 deb_clr_q0,deb_clr_q1,deb_clr_q2;  
  reg 		 deb_last;
  reg	         de_clint;
  reg            abort_cmd_flag_d;
  reg		 deb_inv_clr_q0;
  reg		 deb_inv_clr_q1;
  reg		 deb_inv_clr;

  assign 	 probe_misc = {ca_busyi, busy_hb, de_busy_sync, pc_mc_rdy};
  
  // Syncronizers.
  always @ (posedge de_clk) begin
    de_busy_sync <= busy_hb;
    mw_fip_dd    <= mw_de_fip;
    mw_fip       <= mw_fip_dd;
  end 
   
  always @ (posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) ca_busyi <= 1'b0;
    else         ca_busyi <= ~pc_empty | ((busy_hb & de_busy_sync) | 
			      (~pc_mc_rdy & ca_busyi));
  end
   
  assign ca_busy = (ca_busyi | busy_hb);  
   
  // create the pixel size bits  
  assign ps8_2   = (ps_2==2'b00);
  assign ps16_2  = (ps_2==2'b01) | (ps_2==2'b11);
  assign ps565_2 = (ps_2==2'b11);
  assign ps32_2  = (ps_2==2'b10);
   
   // 8 bit padding for linear 
   assign de_pad8_2 = dr_style_2[3] & dr_style_2[2];
   
   // transparent enable bit
   assign de_trnsp_2 = (dr_style_2[1] & ~dr_style_2[0] & ~(dx_blt_actv_2)) | 
			 (dr_style_2[1] & ~dr_style_2[0] & 
			  (dr_style_2[3] | dr_style_2[2]));
  
   // stipple packed enable bit
   assign stpl_2[1]  = dr_style_2[3] & ~line_actv_2;
   
   // stipple planar enable bit
   assign stpl_2[0]  = ~dr_style_2[3] & dr_style_2[2] & ~line_actv_2; 		
   // syncronize the drawing engine reset.
   always @ (posedge de_clk) begin
     tmp_rstn <= (sys_locked & hb_rstn);
     de_rstn  <= tmp_rstn;     
   end //
   
   //
  always @ (posedge de_clk or negedge de_rstn) begin
    if (!de_rstn)         clip_disab <= 1'b0;
    else if (!load_actvn) clip_disab <= 1'b0;
    else if (clip_ddd)    clip_disab <= 1'b1;
  end //
   
  // grab the wb clip pulse. 
  always @ (posedge de_clk or negedge de_rstn) begin
    if (!de_rstn)         wb_clip <= 1'b0;      
    else if (clip_ddd)    wb_clip <= 1'b0; // checkme ???? ~
    else if (wb_clip_ind) wb_clip <= 1'b1;
  end //
   
  always @ (posedge de_clk) begin
    clip_d <= ((clip & line_actv_2) | wb_clip);
    clip_dd <= clip_d;
    de_clint <= (clip_ddd & ~clip_disab);
  end //
   
  always @ (posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) de_clint_tog <= 1'b0;
    else if(de_clint) de_clint_tog <= ~de_clint_tog;
  end //

  assign clip_ddd = clip_d & ~clip_dd;
  
  always @ (posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) de_ddint_tog <= 1'b0;
    else if(cmdcpyclr) de_ddint_tog <= ~de_ddint_tog;
  end //

  always @ (posedge de_clk or negedge de_rstn) begin
    if (!de_rstn)         dx_clp <= 1'b0;
    else if (!load_actvn) dx_clp <= 1'b0;
    else if (de_clint)    dx_clp <= 1'b1;
  end //

  // Detect DEB going away
  always @(posedge de_clk or negedge hb_rstn) begin
    if (!hb_rstn) begin
      deb_last     <= 1'b0;
      deb_clr_hold <= 1'b0;
      abort_cmd_flag_d <= 1'b0;
    end else begin
      deb_last         <= deb;
      abort_cmd_flag_d <= abort_cmd_flag;
      if((deb_last & ~deb) | (abort_cmd_flag_d & ~abort_cmd_flag)) deb_clr_hold <= ~deb_clr_hold;

      // deb_clr_hold <= (deb_last & ~deb) ^ deb_clr_hold; // Selectable inverter
    end
  end

  always @ (posedge hb_clk) begin
    deb_clr_q0 <= deb_clr_hold;
    deb_clr_q1 <= deb_clr_q0;
    deb_clr_q2 <= deb_clr_q1;
  end //


  wire busy_and_not_noop;
  assign busy_and_not_noop = (busy_hb && (line_actv_1 || blt_actv_1));

  always @(posedge hb_clk or negedge hb_rstn) begin
    if (!hb_rstn)                                             			dx_deb <= 1'b0;
    else if (cmd_trig_comb && !((opc_1 == LD_TEX) || (opc_1 == LD_TPAL)))	dx_deb <= 1'b1;
    else if ((deb_clr_q2 ^ deb_clr_q1) && !busy_and_not_noop) 			dx_deb <= 1'b0;
  end //
    // else if (cmd_trig_comb && (line_actv_1 || blt_actv_1))    dx_deb <= 1'b1;
   
  assign kcol_2 = (ps8_2) ? 
		  {de_key_2[7:0],de_key_2[7:0],de_key_2[7:0],de_key_2[7:0]} :
		  (ps16_2) ? {de_key_2[15:0],de_key_2[15:0]} : {8'h0,de_key_2};
  
endmodule
