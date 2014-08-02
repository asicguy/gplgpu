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
//
//  Title       :  Drawing Engine Register Block Level 2
//  File        :  der_reg_2.v
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
  
module der_reg_2
	(
	input		  de_clk,	// drawing engine clock input
	input	   	  de_rstn,		// de reset input              
	input 	  	  load_actvn,	// load active command parameters
	input 	  	  cmdcpyclr,    // command copy clear.
	input [12:0] 	  buf_ctrl_1,   // buffer control register input
	input [31:0] 	  sorg_1,       // source origin register input
	input [31:0] 	  dorg_1,       // destination origin register input
	input [11:0] 	  sptch_1,      // source pitch register input
	input [11:0] 	  dptch_1,      // destination pitch register input
	input [3:0] 	  opc_1,        // opcode register input
	input [3:0] 	  rop_1,        // raster opcode register input
	input [4:0] 	  style_1,      // drawing style register input
	input 	   	  nlst_1,       // drawing pattern style register input
	input [1:0] 	  apat_1,       // drawing area pattern mode
	input [2:0] 	  clp_1,        // drawing clip control register input
	input [31:0] 	  fore_1,       // foreground color register input
	input [31:0] 	  back_1,       // background color register input
	input [3:0] 	  mask_1,       // plane mask register input
	input [23:0] 	  de_key_1,     // Key data
	input [15:0] 	  alpha_1,      // Alpha Register
	input [17:0] 	  acntrl_1,     // Alpha Control Register
	input [1:0] 	  bc_lvl_1,  

	output     [12:0] buf_ctrl_2,   // buffer control register input
	output reg [31:0] sorg_2,       // source origin register input
	output reg [31:0] dorg_2,       // destination origin register input
	output reg [11:0] sptch_2,      // source pitch register input
	output reg [11:0] dptch_2,      // destination pitch register input
	output reg [3:0]  rop_2,        // raster opcode register input
	output reg [4:0]  style_2,      // drawing style register input
	output reg 	  nlst_2,       // drawing pattern style register input
	output reg [1:0]  apat_2,       // drawing area pattern mode.      
	output reg [2:0]  clp_2,        // drawing clip control register input
	output reg [31:0] fore_2,       // foreground color register input
	output reg [31:0] back_2,       // background color register input
	output reg [3:0]  mask_2,       // plane mask register input
	output reg [23:0] de_key_2,     // Key data
	output reg [15:0] alpha_2,      // Alpha Register
	output reg [17:0]  acntrl_2,     // Alpha Control Register
	output reg [1:0]  bc_lvl_2,
	output reg [3:0]  opc_2
	);
  
  reg [12:0] 	   buf_ctrl_r;     // buffer control register input
  
  /***************************************************************************/
  /*									*/
  /*			ASSIGN OUTPUTS TO REGISTERS			*/
  /*									*/
  /***************************************************************************/
  assign 	   buf_ctrl_2 = {
	  			buf_ctrl_r[12:4],
				(buf_ctrl_r[3] | (buf_ctrl_r[2] & buf_ctrl_r[0])),
				 buf_ctrl_r[2:0]
				 };
  
  /***************************************************************************/
  /*		REGISTER WRITE FUNCTION					*/
  /*		BYTE SELECTION ORDER					*/
  /*									*/
  /*     | 63-56 | 55-48 | 47-40 | 39-32 | 31-24 | 23-16 | 15-8 | 7-0 |	*/
  /*     | wb7n  | wb6n  | wb5n  | wb4n  | wb3n  | wb2n  | wb1n | wb0n|	*/
  /*									*/
  /***************************************************************************/
  /* Replicate the foreground and background depending on the bits per pixel.*/
  
  wire [1:0] 	   psize;
  reg [31:0] 	   fore_rep;
  reg [31:0] 	   back_rep;
  assign 	   psize = buf_ctrl_1[8:7];
  
  always @*
    casex (psize)
      2'b00: begin
	// 8 Bpp
	fore_rep = {4{fore_1[7:0]}}; 
	back_rep = {4{back_1[7:0]}};
      end
      2'bx1: begin
	// 16 Bpp
	fore_rep = {2{fore_1[15:0]}}; 
	back_rep = {2{back_1[15:0]}};
      end
      default: begin
	// 32Bpp
	fore_rep = fore_1; 
	back_rep = back_1;
      end
    endcase // casex(psize)

  always @(posedge de_clk, negedge de_rstn) begin
    if(!de_rstn)         opc_2 <= 4'b0;
    else if(cmdcpyclr)   opc_2 <= 4'b0;
    else if(!load_actvn) opc_2 <= opc_1;
  end


  always @(posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) begin
      buf_ctrl_r  <= 13'b0;
      sorg_2      <= 32'b0;
      dorg_2      <= 32'b0;
      rop_2       <= 4'b0;
      style_2     <= 5'b0;
      nlst_2      <= 1'b0;
      apat_2      <= 2'b0;
      clp_2       <= 3'b0;
      bc_lvl_2    <= 2'b0;
      sptch_2     <= 12'b0;
      dptch_2     <= 12'b0;
      fore_2      <= 32'b0;
      back_2      <= 32'b0;
      mask_2      <= 4'b0;
      de_key_2    <= 24'b0;
      alpha_2     <= 16'b0;
      acntrl_2    <= 18'b0;
    end else if(!load_actvn) begin
      buf_ctrl_r  <= buf_ctrl_1;
      sorg_2      <= sorg_1;
      dorg_2      <= dorg_1;
      rop_2       <= rop_1;
      style_2     <= style_1;
      nlst_2      <= nlst_1;
      apat_2      <= apat_1;
      clp_2       <= clp_1;
      bc_lvl_2    <= bc_lvl_1;
      sptch_2     <= sptch_1;
      dptch_2     <= dptch_1;
      fore_2      <= fore_rep; 
      back_2      <= back_rep;
      mask_2      <= mask_1;
      de_key_2    <= de_key_1;
      alpha_2     <= alpha_1;
      acntrl_2    <= acntrl_1;
    end
  end
  
endmodule
