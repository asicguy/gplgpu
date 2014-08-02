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
//  Title       :  Drawing Engine Register block read mux
//  File        :  der_rdmux.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module Reads back the DE registers
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

module der_rdmux
 (
  input [8:2]    hb_adr,         // host bus address	               
  input [1:0] 	 intm,     	 // Interrupt mask bits.
  input [1:0] 	 intp,     	 // Interrupts {CL, DD}.
  input [4:0] 	 flow,     	 // Flow Register {PRV, CLP, MCB, DEB}.
  input  	 busy,     	 // Busy.
  input [14:0] 	 buf_ctrl_1,     // buffer control register input      
  input [31:0] 	 sorg_1,         // source origin register input       
  input [31:0] 	 dorg_1,         // destination origin register input  
  input [11:0] 	 sptch_1,        // source pitch register input        
  input [11:0] 	 dptch_1,        // destination pitch register input   
  input [3:0] 	 opc_1,          // opcode register input              
  input [3:0] 	 rop_1,          // raster opcode register input       
  input [4:0] 	 style_1,        // drawing style register input        
  input [3:0] 	 patrn_1,        // drawing pattern style register input
  input [2:0] 	 hdf_1,          // Host data format.                  
  input [2:0] 	 clp_1,          // drawing clip control register input
  input [31:0] 	 fore_1,         // foreground color register input    
  input [31:0] 	 back_1,         // background color register input    
  input [3:0] 	 mask_1,         // plane mask register input          
  input [23:0] 	 de_key_1,       // raster op mask register input      
  input [31:0] 	 lpat_1,         // line pattern register input        
  input [15:0] 	 pctrl_1,        // line pattern control register input
  input [31:0] 	 clptl_1,        // clipping top left corner register input
  input [31:0] 	 clpbr_1,        // clipping bottom right corner register in
  input [31:0] 	 xy0_1,          // parameter register input XY0
  input [31:0] 	 xy1_1,          // parameter register input XY1
  input [31:0] 	 xy2_1,          // parameter register input XY2
  input [31:0] 	 xy3_1,          // parameter register input XY3
  input [31:0] 	 xy4_1,          // parameter register input XY4
  input [15:0] 	 alpha_1,        // Alpha register             
  input [17:0] 	 acntrl_1,       // Alpha Control Register     
  input [15:0] 	 lpat_state,     // line pattern state         
  input [53:0] 	 dl_rdback,      // DLP host bus read back data.
  input [1:0] 	 bc_lvl_1,
  input [6:0]    mem_offset_1,  // Select memory region
  input [3:0]    sorg_upper_1,  // Select memory region
  
  output    [31:0]  hb_dout     // output to host bus interface
  );


parameter
	INTM_INTP 	= 6'b0_0000_0,	// Interrupt mask/int, 0x00.
	BUSY_FLOW 	= 6'b0_0000_1,	// Busy/Flow Register, 0x08.
	NA_TSORG 	= 6'b0_0001_1,	// Text offset Sorg    0x18.
        MEM_BCTRL 	= 6'b0_0010_0,
	DORG_SORG 	= 6'b0_0010_1,
	DPTCH_SPTCH 	= 6'b0_0100_0,
	CMDR 		= 6'b0_0100_1,
	ROP_OPC 	= 6'b0_0101_0,
	PATRN_STYLE 	= 6'b0_0101_1,
	SFD_CLP 	= 6'b0_0110_0,
	BACK_FORE 	= 6'b0_0110_1,
	DEKEY_MASK 	= 6'b0_0111_0,
	PCTRL_LPAT 	= 6'b0_0111_1,
	CLPBR_CLPTL 	= 6'b0_1000_0,
	XY1_XY0 	= 6'b0_1000_1,
	XY3_XY2 	= 6'b0_1001_0,
	NA_XY4  	= 6'b0_1001_1,
	DLCNT_DLADR	= 6'b0_1111_1,
	TBOARD_ALPHA	= 6'b1_0010_1,
	ACNTRL_CMD	= 6'b1_0110_1;


  reg [63:0]  hb_dout_i;
  /**************************************************************************/
  /*									*/
  /*		REGISTER READ BACK FUNCTION				*/
  /*									*/
  /**************************************************************************/
  always @* begin
    hb_dout_i = 64'h0;
    case (hb_adr[8:3])  //synopsys parallel_case
      INTM_INTP: begin
	hb_dout_i[1:0]   = intp;
	hb_dout_i[33:32] = intm;
      end
      BUSY_FLOW: begin
	hb_dout_i[4:0]   = flow;
	hb_dout_i[32]    = busy;
      end
      NA_TSORG:
	hb_dout_i[63:60] = sorg_upper_1;
      MEM_BCTRL: begin
	hb_dout_i[2:0]   = buf_ctrl_1[2:0];
	hb_dout_i[5]     = buf_ctrl_1[3];
	hb_dout_i[7:6]   = bc_lvl_1;
	hb_dout_i[8]     = buf_ctrl_1[13];
	hb_dout_i[15]    = buf_ctrl_1[4];
	hb_dout_i[23:22] = buf_ctrl_1[6:5];
	hb_dout_i[27:24] = buf_ctrl_1[10:7];
	hb_dout_i[31:29] = {buf_ctrl_1[14],buf_ctrl_1[12:11]};
	hb_dout_i[63:57] = mem_offset_1;
      end
      DORG_SORG: begin
	hb_dout_i[7:0]   = sorg_1[7:0];
	hb_dout_i[15:8]  = sorg_1[15:8];
	hb_dout_i[23:16] = sorg_1[23:16];
	hb_dout_i[31:24] = sorg_1[31:24];
	hb_dout_i[39:32] = dorg_1[7:0];
	hb_dout_i[47:40] = dorg_1[15:8];
	hb_dout_i[55:48] = dorg_1[23:16];
	hb_dout_i[63:56] = dorg_1[31:24];
      end
      DPTCH_SPTCH: begin
	hb_dout_i[7:4]   = sptch_1[3:0];
	hb_dout_i[15:8]  = sptch_1[11:4];
	hb_dout_i[39:36] = dptch_1[3:0];
	hb_dout_i[47:40] = dptch_1[11:4];
      end
      CMDR: begin
	hb_dout_i[3:0]   = opc_1; 
	hb_dout_i[11:8]  = rop_1; 
	hb_dout_i[20:16] = style_1; 
	hb_dout_i[23:21] = clp_1;
	hb_dout_i[27:24] = patrn_1;
	hb_dout_i[30:28] = hdf_1;
      end
      ROP_OPC: begin
	hb_dout_i[3:0]   = opc_1;
	hb_dout_i[35:32] = rop_1;
      end
      PATRN_STYLE: begin
	hb_dout_i[4:0]   = style_1;
	hb_dout_i[35:32] = patrn_1;
      end
      SFD_CLP: begin
	hb_dout_i[2:0]   = clp_1;
	hb_dout_i[34:32] = hdf_1;
      end
      BACK_FORE: begin
	hb_dout_i[7:0]   = fore_1[7:0];
	hb_dout_i[15:8]  = fore_1[15:8];
	hb_dout_i[23:16] = fore_1[23:16];
	hb_dout_i[31:24] = fore_1[31:24];
	hb_dout_i[39:32] = back_1[7:0];
	hb_dout_i[47:40] = back_1[15:8];
	hb_dout_i[55:48] = back_1[23:16];
	hb_dout_i[63:56] = back_1[31:24];
      end
      DEKEY_MASK: begin
	hb_dout_i[7:0]   = {8{mask_1[0]}};
	hb_dout_i[15:8]  = {8{mask_1[1]}};
	hb_dout_i[23:16] = {8{mask_1[2]}};
	hb_dout_i[31:24] = {8{mask_1[3]}};
	hb_dout_i[39:32] = de_key_1[7:0];
	hb_dout_i[47:40] = de_key_1[15:8];
	hb_dout_i[55:48] = de_key_1[23:16];
      end
      PCTRL_LPAT: begin
	hb_dout_i[7:0]   = lpat_1[7:0];
	hb_dout_i[15:8]  = lpat_1[15:8];
	hb_dout_i[23:16] = lpat_1[23:16];
	hb_dout_i[31:24] = lpat_1[31:24];
	hb_dout_i[39:32] = pctrl_1[7:0];
	hb_dout_i[47:40] = pctrl_1[15:8];
	hb_dout_i[55:48] = lpat_state[7:0];
	hb_dout_i[63:56] = lpat_state[15:8];
      end
      CLPBR_CLPTL: begin
	hb_dout_i[7:0]   = clptl_1[7:0];
	hb_dout_i[15:8]  = clptl_1[15:8];
	hb_dout_i[23:16] = clptl_1[23:16];
	hb_dout_i[31:24] = clptl_1[31:24];
	hb_dout_i[39:32] = clpbr_1[7:0];
	hb_dout_i[47:40] = clpbr_1[15:8];
	hb_dout_i[55:48] = clpbr_1[23:16];
	hb_dout_i[63:56] = clpbr_1[31:24];
      end       
      XY1_XY0: begin
	hb_dout_i[7:0]   = xy0_1[7:0];
	hb_dout_i[15:8]  = xy0_1[15:8];
	hb_dout_i[23:16] = xy0_1[23:16];
	hb_dout_i[31:24] = xy0_1[31:24];
	hb_dout_i[39:32] = xy1_1[7:0];
	hb_dout_i[47:40] = xy1_1[15:8];
	hb_dout_i[55:48] = xy1_1[23:16];
	hb_dout_i[63:56] = xy1_1[31:24];
      end
      XY3_XY2: begin
	hb_dout_i[7:0]   = xy2_1[7:0];
	hb_dout_i[15:8]  = xy2_1[15:8];
	hb_dout_i[23:16] = xy2_1[23:16];
	hb_dout_i[31:24] = xy2_1[31:24];
	hb_dout_i[39:32] = xy3_1[7:0];
	hb_dout_i[47:40] = xy3_1[15:8];
	hb_dout_i[55:48] = xy3_1[23:16];
	hb_dout_i[63:56] = xy3_1[31:24];
      end
      NA_XY4: begin
	hb_dout_i[7:0]   = xy4_1[7:0];
	hb_dout_i[15:8]  = xy4_1[15:8];
	hb_dout_i[23:16] = xy4_1[23:16];
	hb_dout_i[31:24] = xy4_1[31:24];
      end
      DLCNT_DLADR: begin
	hb_dout_i[7:4]   = dl_rdback[3:0];
	hb_dout_i[15:8]  = dl_rdback[11:4];
	hb_dout_i[23:16] = dl_rdback[19:12];
	hb_dout_i[27:24] = {dl_rdback[53:51],dl_rdback[20]};
	hb_dout_i[31:30] = dl_rdback[22:21];
	hb_dout_i[39:36] = dl_rdback[26:23];
	hb_dout_i[47:40] = dl_rdback[34:27];
	hb_dout_i[55:48] = dl_rdback[42:35];
	hb_dout_i[56]    = dl_rdback[43];
	hb_dout_i[63:60] = dl_rdback[47:44];
      end       
      TBOARD_ALPHA: begin
	hb_dout_i[7:0]   = alpha_1[7:0];
	hb_dout_i[15:8]  = alpha_1[15:8];
      end
      ACNTRL_CMD: begin
	hb_dout_i[3:0]   = opc_1; 
	hb_dout_i[11:8]  = rop_1; 
	hb_dout_i[20:16] = style_1; 
	hb_dout_i[23:21] = clp_1;
	hb_dout_i[27:24] = patrn_1;
	hb_dout_i[30:28] = hdf_1;
	hb_dout_i[39:32] = acntrl_1[7:0];
	hb_dout_i[42:40] = {acntrl_1[10:8]};
	hb_dout_i[51:48] = {acntrl_1[14:11]};
	hb_dout_i[58:56] = {acntrl_1[17:15]};
      end
      default: hb_dout_i = 64'h0;
    endcase
  end

assign hb_dout = (hb_adr[2]) ? hb_dout_i[63:32] : hb_dout_i[31:0];

endmodule
