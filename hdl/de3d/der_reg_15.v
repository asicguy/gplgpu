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
//  Title       :  Drawing Engine Register Block Level 15
//  File        :  der_reg_15.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//   Second level register block
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
  
module der_reg_15
  (
   input 	     de_clk,      // drawing engine clock input
		     de_rstn,     // reset input              
   input 	     load_15,     // load L15 command parameters
   input [12:0]      buf_ctrl_1,  // buffer control register input
   input [31:0]      sorg_1,      // source origin register input
   input [31:0]      dorg_1,      // destination origin register input
   input [11:0]      sptch_1,     // source pitch register input
   input [11:0]      dptch_1,     // destination pitch register input
   input [3:0] 	     opc_1,       // opcode register
   input [3:0] 	     rop_1,       // raster opcode register input
   input [4:0] 	     style_1,     // drawing style register input
   input 	     nlst_1,      // drawing pattern style register input
   input [1:0] 	     apat_1,      // drawing area pattern mode
   input [2:0] 	     clp_1,       // drawing clip control register input
   input [31:0]      fore_1,      // foreground color register input
   input [31:0]      back_1,      // background color register input
   input [3:0] 	     mask_1,      // plane mask register input
   input [23:0]      de_key_1,    // Key data
   input [15:0]      alpha_1,     // Alpha Register
   input [17:0]      acntrl_1,    // Alpha Control Register
   input [1:0] 	     bc_lvl_1, 
   input [31:0]      xy0_1, 
   input [31:0]      xy1_1, 
   input [31:0]      xy2_1, 
   input [31:0]      xy3_1, 
   input [31:0]      xy4_1, 

   output reg [12:0] buf_ctrl_15, // buffer control register input
   output reg [31:0] sorg_15,     // source origin register input
   output reg [31:0] dorg_15,     // destination origin register input
   output reg [11:0] sptch_15,    // source pitch register input
   output reg [11:0] dptch_15,    // destination pitch register input
   output reg [3:0]  rop_15,      // raster opcode register input
   output reg [4:0]  style_15,    // drawing style register input
   output reg 	     nlst_15,     // drawing pattern style register input
   output reg [1:0]  apat_15,     // drawing area pattern mode.      
   output reg [2:0]  clp_15,      // drawing clip control register input
   output reg [31:0] fore_15,     // foreground color register input
   output reg [31:0] back_15,     // background color register input
   output reg [3:0]  mask_15,     // plane mask register input
   output reg [23:0] de_key_15,   // Key data
   output reg [15:0] alpha_15,    // Alpha Register
   output reg [17:0] acntrl_15,   // Alpha Control Register
   output reg [1:0]  bc_lvl_15,
   output reg [3:0]  opc_15,      // opcode register, L15
   output reg [31:0] xy0_15, 
   output reg [31:0] xy1_15, 
   output reg [31:0] xy2_15, 
   output reg [31:0] xy3_15, 
   output reg [31:0] xy4_15  
   );
  
  /***************************************************************************/
  /*									*/
  /*			ASSIGN OUTPUTS TO REGISTERS			*/
  /*									*/
  /***************************************************************************/
  
  always @(posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) begin
      buf_ctrl_15  <= 13'b0;
      sorg_15      <= 32'b0;
      dorg_15      <= 32'b0;
      rop_15       <= 4'b0;
      style_15     <= 5'b0;
      nlst_15      <= 1'b0;
      apat_15      <= 2'b0;
      clp_15       <= 3'b0;
      bc_lvl_15    <= 2'b0;
      sptch_15     <= 12'b0;
      dptch_15     <= 12'b0;
      fore_15      <= 32'b0;
      back_15      <= 32'b0;
      mask_15      <= 4'b0;
      de_key_15    <= 24'b0;
      alpha_15     <= 16'b0;
      acntrl_15    <= 18'b0;
      opc_15       <= 4'b0;
      xy0_15	   <= 32'h0;
      xy1_15	   <= 32'h0;
      xy2_15	   <= 32'h0;
      xy3_15	   <= 32'h0;
      xy4_15	   <= 32'h0;
    end else if (load_15) begin
      buf_ctrl_15  <= buf_ctrl_1;
      sorg_15      <= sorg_1;
      dorg_15      <= dorg_1;
      rop_15       <= rop_1;
      style_15     <= style_1;
      nlst_15      <= nlst_1;
      apat_15      <= apat_1;
      clp_15       <= clp_1;
      bc_lvl_15    <= bc_lvl_1;
      sptch_15     <= sptch_1;
      dptch_15     <= dptch_1;
      fore_15      <= fore_1; 
      back_15      <= back_1;
      mask_15      <= mask_1;
      de_key_15    <= de_key_1;
      alpha_15     <= alpha_1;
      acntrl_15    <= acntrl_1;
      opc_15       <= opc_1;
      xy0_15	   <= xy0_1;  
      xy1_15	   <= xy1_1;  
      xy2_15	   <= xy2_1;  
      xy3_15	   <= xy3_1;  
      xy4_15	   <= xy4_1; 
    end
  end
  
endmodule
