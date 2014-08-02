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
//  Title       :  Drawing Engine Color Selector
//  File        :  ded_colsel.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Select Outgoing color value
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
  module ded_colsel
    #(parameter BYTES = 4)
    (
     input              mclock,        // Memory Controller Clock
     input	        ps8_4,	       // Pixel size equals 8 bits
     input 	        ps16_4,	       // Pixel size equals 16 bits.
     input 	        ps32_4,	       // Pixel size equals 32 bits.
     input [1:0]        stpl_4,	       // Stipple bit 01=planar, 10 = packed.
     input 	        lt_actv_4,     // Line active bit.
     input [31:0]       fore_4,	       // foreground data.
     input [31:0]       back_4,	       // background data.
     input [(BYTES<<3)-1:0]      fs_dat,	       // Data from funnel shifter.
     input [BYTES-1:0]       cx_sel,	       // Color Expand selector.
     input [(BYTES<<3)-1:0]      pc_col,	       // Pixel Cache Data.
     input 	        solid_4,       // Solid bit level two.
     
     output reg [(BYTES<<3)-1:0] col_dat,       // color data output.
     output [BYTES-1:0]      trns_msk       // transparentcy mask.
     );
  
  reg [(BYTES<<3)-1:0] 		pipe_col, pipe_col_0;
  reg [BYTES-1:0] 		fg_bg;		// color selector signal
  reg [BYTES-1:0] 		cx_reg;	        // Color Expand selector
  reg [(BYTES<<3)-1:0] 		pc_col_d;
  
  wire [(BYTES<<3)-1:0] 		cx_color_dat;	// color expanded data
  wire [(BYTES<<3)-1:0] 		wide_fore_4;	// expanded foreground color
  wire [(BYTES<<3)-1:0] 		wide_back_4;	// expanded background color
  
  // Pipe stage from funnel shifter
  always @(posedge mclock) pc_col_d <= pc_col;
  
  always @(posedge mclock) begin
    cx_reg   <= cx_sel; // pipe stage insterted in the funshf
    // addd one stage to increase clock speed of MC
    pipe_col_0 <= (lt_actv_4) ? pc_col_d : fs_dat;
    pipe_col <= pipe_col_0;
  end
  
  /************************************************************************/
  /*			EXPAND THE COLOR REGISTERS			*/
  /* if in stipple mode or line draw use color expanded data.		*/
  assign 	 wide_fore_4[(BYTES<<3)-1:0] = (lt_actv_4 && |stpl_4) ? pc_col : {(BYTES/4){fore_4}} ; 
  assign 	 wide_back_4[(BYTES<<3)-1:0] = {(BYTES/4){back_4}} ; 
  /************************************************************************/

  /************************************************************************/
  /*			OUTPUT SELECTOR					*/
  /* if in stipple mode or line draw use color expanded data.		*/
  /************************************************************************/
  always @(posedge mclock)begin
      if(lt_actv_4)		col_dat <= pipe_col;    // else use funnel shifter color
      else if(solid_4)		col_dat <= wide_fore_4; // solid is set force foreground col
      else if(stpl_4 == 2'b00) 	col_dat <= pipe_col; 	// use pixel cache data
      else			col_dat <= cx_color_dat;// stipple color expanded color
  end
  
  assign     trns_msk = fg_bg;

  /************************************************************************/
  /*			Replicate color data and selectors.		*/
  /************************************************************************/
  always @*
  begin
    if(BYTES == 4)
	begin
    		case({ps8_4,ps16_4,ps32_4}) /* synopsys parallel_case */
      		3'b001:  fg_bg = { cx_reg[0],cx_reg[0],cx_reg[0],cx_reg[0]};
      		3'b010:  fg_bg = { cx_reg[1],cx_reg[1],cx_reg[0],cx_reg[0]};
      		default: fg_bg = cx_reg;
    		endcase
	end

    else if(BYTES == 8)
	begin
    		case({ps8_4,ps16_4,ps32_4}) /* synopsys parallel_case */
      			3'b001:fg_bg = { cx_reg[1],cx_reg[1],cx_reg[1],cx_reg[1],
                       			 cx_reg[0],cx_reg[0],cx_reg[0],cx_reg[0]};
      			3'b010:fg_bg = { cx_reg[3],cx_reg[3],cx_reg[2],cx_reg[2],
                       		 	 cx_reg[1],cx_reg[1],cx_reg[0],cx_reg[0]};
      			// 3'b1xx:fg_bg = cx_reg;
      			default:fg_bg = cx_reg;
    		endcase
	end
    else begin
    		case({ps8_4,ps16_4,ps32_4}) /* synopsys parallel_case */
      		3'b001:fg_bg = {cx_reg[3],cx_reg[3],cx_reg[3],cx_reg[3],
                      		cx_reg[2],cx_reg[2],cx_reg[2],cx_reg[2],
                      		cx_reg[1],cx_reg[1],cx_reg[1],cx_reg[1],
                      		cx_reg[0],cx_reg[0],cx_reg[0],cx_reg[0]};
      		3'b010:fg_bg = {cx_reg[7],cx_reg[7],cx_reg[6],cx_reg[6],
                      		cx_reg[5],cx_reg[5],cx_reg[4],cx_reg[4],
                      		cx_reg[3],cx_reg[3],cx_reg[2],cx_reg[2],
                      		cx_reg[1],cx_reg[1],cx_reg[0],cx_reg[0]};
      		// 3'b1xx:fg_bg = cx_reg;
      		default:fg_bg = cx_reg;
    		endcase
	end
  end

  /************************************************************************/
  
  assign cx_color_dat[007:000] = (fg_bg[00]) ? wide_fore_4[007:000] : wide_back_4[007:000];
  assign cx_color_dat[015:008] = (fg_bg[01]) ? wide_fore_4[015:008] : wide_back_4[015:008];
  assign cx_color_dat[023:016] = (fg_bg[02]) ? wide_fore_4[023:016] : wide_back_4[023:016];
  assign cx_color_dat[031:024] = (fg_bg[03]) ? wide_fore_4[031:024] : wide_back_4[031:024];

`ifdef BYTE8
  assign cx_color_dat[039:032] = (fg_bg[04]) ? wide_fore_4[039:032] : wide_back_4[039:032];
  assign cx_color_dat[047:040] = (fg_bg[05]) ? wide_fore_4[047:040] : wide_back_4[047:040];
  assign cx_color_dat[055:048] = (fg_bg[06]) ? wide_fore_4[055:048] : wide_back_4[055:048];
  assign cx_color_dat[063:056] = (fg_bg[07]) ? wide_fore_4[063:056] : wide_back_4[063:056];
`endif

`ifdef BYTE16
  assign cx_color_dat[039:032] = (fg_bg[04]) ? wide_fore_4[039:032] : wide_back_4[039:032];
  assign cx_color_dat[047:040] = (fg_bg[05]) ? wide_fore_4[047:040] : wide_back_4[047:040];
  assign cx_color_dat[055:048] = (fg_bg[06]) ? wide_fore_4[055:048] : wide_back_4[055:048];
  assign cx_color_dat[063:056] = (fg_bg[07]) ? wide_fore_4[063:056] : wide_back_4[063:056];
  assign cx_color_dat[071:064] = (fg_bg[08]) ? wide_fore_4[071:064] : wide_back_4[071:064];
  assign cx_color_dat[079:072] = (fg_bg[09]) ? wide_fore_4[079:072] : wide_back_4[079:072];
  assign cx_color_dat[087:080] = (fg_bg[10]) ? wide_fore_4[087:080] : wide_back_4[087:080];
  assign cx_color_dat[095:088] = (fg_bg[11]) ? wide_fore_4[095:088] : wide_back_4[095:088];
  assign cx_color_dat[103:096] = (fg_bg[12]) ? wide_fore_4[103:096] : wide_back_4[103:096];
  assign cx_color_dat[111:104] = (fg_bg[13]) ? wide_fore_4[111:104] : wide_back_4[111:104];
  assign cx_color_dat[119:112] = (fg_bg[14]) ? wide_fore_4[119:112] : wide_back_4[119:112];
  assign cx_color_dat[127:120] = (fg_bg[15]) ? wide_fore_4[127:120] : wide_back_4[127:120];
`endif
  
endmodule
