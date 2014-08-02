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
///////////////////////////////////////////////////////////////////////////////
//
//  Title       :  2D Cache Control Read
//  File        :  ded_cactrl_rd.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
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

module ded_cactrl_rd
  #(parameter BYTES = 4)
  (
   input                de_rstn,
   input                de_clk,
   input                mc_read_4,
   input                ld_rad,
   input                ld_rad_e,
   input                mclock,
   input                mc_popen,
   input                mc_acken,
   input        [9:0]   din,
   input        [8:0]   srcx,
   input        [4:0]   dsty,
   input        [6:0]   dstx,
   input        [1:0]   stpl_2,
   input        [1:0]   stpl_4,
   input        [1:0]   apat_2,
   input        [1:0]   apat_4,
   input                ps8_2,
   input                ps16_2,
   input                ps32_2,
   input        [2:0]   psize_4,
   input                lt_actv_4,
   input                eol_4,
   input                mc_eop,
   input        [2:0]   ofset,
   input        [2:0]   frst8_4,
   input                sol_3,
   input                mem_req,        /* mem_req.  */
   input                mem_rd,         /* mem_rd.   */
   input        [4:0]   xpat_ofs,
   input        [4:0]   ypat_ofs,
   input                ca_src_2,
   input                rad_flg_3,
   input [2:0]          strt_wrd_3,
   input [3:0]          strt_byt_3,
   input [2:0]          strt_bit_3,
   input [2:0]          strt_wrd_4,
   input [3:0]          strt_byt_4,
   input [2:0]          strt_bit_4,

   output reg           rad_flg_2,
   output [2:0]         strt_wrd_2,
   output [3:0]         strt_byt_2,
   output [2:0]         strt_bit_2,
   output reg [9:0]     rad
   );

  reg [2:0]     strt_wrd;
  reg [2:0]     strt_wrd_2a;

  reg [3:0]     strt_byt;
  reg [3:0]     strt_byt_2a;

  reg [2:0]     strt_bit;
  reg [2:0]     strt_bit_2a;

  reg [9:0]     inc;
  reg           mc_eopp1;

  reg           nx_ld_rad_e;
  
  wire          ps32_4,ps16_4,ps8_4;

  localparam     
                MINUS2_BYTES     = 10'h3C0,
                MINUS4_BYTES     = 10'h3A0,
                ZERO_BYTES       = 10'h0,
                ONE_BIT          = 10'h1,
                TWO_BITS         = 10'h2,
                HALF_BYTE        = 10'h4,
                ONE_BYTE         = 10'h8,
                TWO_BYTES        = 10'h10,
                FOUR_BYTES       = 10'h20,
                EIGHT_BYTES      = 10'h40,
                SIXTEEN_BYTES    = 10'h80,
                TWENTY_BYTES     = 10'hA0,
                TWENTYFOUR_BYTES = 10'hC0,
                THIRTYTWO_BYTES  = 10'h100,
                SIXTYFOUR_BYTES  = 10'h200;
  
  assign        {ps32_4,ps16_4,ps8_4} = psize_4;

  always @(posedge mclock)
                mc_eopp1 <= mc_eop & mc_popen & eol_4;
  
  // calculate the cache read increment.       
  always @(posedge mclock) begin
    if (stpl_4[1]) begin
      // Packed Stipple
      casex (apat_4)
        2'bx1: begin
          // 8x8 packed stipple
          if (eol_4 && mc_eop && !lt_actv_4) inc <= ONE_BYTE;
          else if (ps32_4)                   inc <= 10'h7 & (ONE_BIT * (BYTES[9:0]/10'h4));
          else if (ps16_4)                   inc <= 10'h7 & (ONE_BIT * (BYTES[9:0]/10'h2));
          else                               inc <= 10'h7 & (ONE_BIT * (BYTES[9:0]));
        end
        2'b10: begin
          // 32x32 packed stipple.
          if(eol_4 && mc_eop && !lt_actv_4)  inc <= FOUR_BYTES;
          else if (ps32_4)               inc <= ONE_BIT * (BYTES[9:0]/10'h4);
          else if (ps16_4)               inc <= ONE_BIT * (BYTES[9:0]/10'h2);
          else                           inc <= ONE_BIT * (BYTES[9:0]);
        end
        default: begin
          if (ps32_4)                    inc <= ONE_BIT * (BYTES[9:0]/10'h4);
          else if (ps16_4)               inc <= ONE_BIT * (BYTES[9:0]/10'h2);
          else                           inc <= ONE_BIT * (BYTES[9:0]);
        end
      endcase
    end
    // 32x32 Full Color.
    else if (apat_4[1] && eol_4 && mc_eop) inc <= THIRTYTWO_BYTES;
    //////////////////////////////////
    // 8x8 Full Color.
    `ifdef BYTE16 
            else if (apat_4[0] && eol_4 && mc_eop && ps32_4) inc <= SIXTYFOUR_BYTES;
            else if (apat_4[0] && eol_4 && mc_eop) inc <= THIRTYTWO_BYTES;
    `endif
    `ifdef BYTE8 
            else if (apat_4[0] && eol_4 && mc_eop && ps32_4) inc <= SIXTYFOUR_BYTES;
            else if (apat_4[0] && eol_4 && mc_eop) inc <= THIRTYTWO_BYTES;
    `endif
    `ifdef BYTE4 
            else if (apat_4[0] && eol_4 && mc_eop) inc <= {1'b0, ps32_4, ~rad[7], 1'b0, 1'b1, 5'b0};
    `endif
    //////////////////////////////////
    /*                     rds_neq_wrs    src < dst     not_sngl        */
    `ifdef BYTE16 else if (eol_4 && mc_eop && !frst8_4[2] && frst8_4[1]) inc <= ZERO_BYTES;   `endif
    `ifdef BYTE8  else if (eol_4 && mc_eop && !frst8_4[2] && frst8_4[1]) inc <= MINUS2_BYTES; `endif
    `ifdef BYTE4  else if (eol_4 && mc_eop && !frst8_4[2] && frst8_4[1]) inc <= MINUS4_BYTES; `endif
    
    /*                     rds_neq_wrs    src > dst  */
    `ifdef BYTE16 else if(eol_4 && mc_eop && !frst8_4[2] && !frst8_4[1]) inc <= THIRTYTWO_BYTES; `endif
    `ifdef BYTE8  else if(eol_4 && mc_eop && !frst8_4[2] && !frst8_4[1]) inc <= TWENTYFOUR_BYTES; `endif
    `ifdef BYTE4  else if(eol_4 && mc_eop && !frst8_4[2] && !frst8_4[1]) inc <= TWENTY_BYTES;    `endif
   //  
    else inc <= ONE_BYTE * BYTES[9:0];
    
  end

  always @(posedge de_clk or negedge de_rstn) begin
    if (!de_rstn)               rad_flg_2 <= 1'b0;
    else if (mem_req & ~mem_rd) rad_flg_2 <= 1'b0;
    else if (ld_rad | ld_rad_e) rad_flg_2 <= 1'b1;
  end

  /* pattern offset control.                                            */
  wire [4:0] new_dstx;
  wire [4:0] xofs;
  wire [4:0] yofs;
  assign     new_dstx = (ps32_2) ? {dstx[6:4],2'b0} :
             (ps16_2) ? {dstx[5:4],3'b0} : {dstx[4],4'b0};

  assign     yofs = dsty[4:0];
  assign     xofs = new_dstx;

  wire [6:0] srcx_us = (ps32_2) ? srcx[8:2] :
             (ps16_2) ? srcx[7:1] : srcx[6:0];


  /* register for cache unload pointer.                                 */
  /* loaded by the drawing engine state machines.                       */
  always @* begin
    // packed modes.
    if (stpl_2[1]) begin
      casex (apat_2)
        2'b00: strt_wrd=din[9:7]; /* linear or wxfer */
        2'b1x: strt_wrd=yofs[4:2]; /* 32x32 */
        2'b01: strt_wrd=srcx_us[6:4] & {3{ca_src_2}}; /*  8x8  */
      endcase // casex(apat_2)
    end else if (apat_2[1]) begin
      // planar or full color patterns.
      casex ({ps8_2, ps16_2}) // synopsys parallel_case
        2'b10:   strt_wrd = {2'b00,dstx[4]};
        2'b01:   strt_wrd = {1'b0,dstx[5:4]};
        default: strt_wrd = dstx[6:4];
      endcase // casex({ps8_2, ps16_2})
    end else begin
      // all other modes.              
      if(|ca_src_2)strt_wrd=srcx_us[6:4];
      else if(!din[4] && !stpl_2[1] && (~|apat_2))strt_wrd=3'b000;
      else if(din[4] && !stpl_2[1] && (~|apat_2))strt_wrd=3'b111;
      else if(!stpl_2[1] && !stpl_2[0] && apat_2[0] && ps32_2)strt_wrd={2'b00,dstx[4]};
      else strt_wrd=3'b000;
    end
  end
  
  always @* begin
    // packed modes.
    if(stpl_2[1] && apat_2[0])strt_byt={(srcx[5] & ps32_2) |
                                        (srcx[4] & ps16_2) |
                                        (srcx[3] & ps8_2),yofs[2:0]};   /* 8x8 */
    else if(stpl_2[1] && apat_2[1]) strt_byt={yofs[1:0],xofs[4:3]}; /* 32x32 */
    else if(stpl_2[1])          strt_byt=din[6:3];
    // planar or full color patterns.
    else if(|apat_2)strt_byt = 4'b0;
    // all other modes.              
    else if(|ca_src_2)strt_byt=srcx_us[3:0];
    else strt_byt=din[3:0];
  end
  
  always @* begin
    if((|stpl_2) && (|apat_2))strt_bit=xofs[2:0];
    else strt_bit=din[2:0];
  end
  
  always @(posedge de_clk or negedge de_rstn) begin
    if (!de_rstn) begin
      strt_wrd_2a <= 3'b0;
      strt_byt_2a <= 4'b0;
      strt_bit_2a <= 3'b0;
    end else if (ld_rad) begin
      strt_wrd_2a <= strt_wrd;
      strt_byt_2a <= strt_byt;
      strt_bit_2a <= strt_bit;
    end
  end


  always @(posedge de_clk) nx_ld_rad_e <= ld_rad_e;

  assign strt_wrd_2 = (nx_ld_rad_e) ? strt_wrd : strt_wrd_2a;
  assign strt_byt_2 = (nx_ld_rad_e) ? strt_byt : strt_byt_2a;
  assign strt_bit_2 = (nx_ld_rad_e) ? strt_bit : strt_bit_2a;
  
  // counter for cache unload pointer.
  always @(posedge mclock or negedge de_rstn)
        begin
                if (!de_rstn) rad[9:0] <= 10'h0;
        /* LOAD NEW POINTER */
        else if(rad_flg_3 & mc_acken & sol_3 & ~mc_read_4) 
                rad[9:0] <= {strt_wrd_3,strt_byt_3,strt_bit_3};
    //////////////////////////////////////////////////////////////////
    /* INCREMENT POINTER */
    else if(((mc_popen && !eol_4) || (mc_popen && !mc_eop)) || mc_eopp1) 
        begin
      /* 8X8 STIPPLE PACKED AREA PATTERN. */
      if(stpl_4[1] && apat_4[0])
                begin
                        if (eol_4 && mc_eopp1) rad[2:0] <= strt_bit_4;
                        else 		       rad[2:0] <= rad[2:0] + inc[2:0];
                        		       rad[5:3] <= rad[5:3] + inc[5:3];
                end
    /* 32X32 STIPPLE PACKED AREA PATTERN. */
      else if(stpl_4[1] && apat_4[1])
                begin
                        rad[9:5] <= rad[9:5] + inc[9:5]; /* word,byte pointer */
                        if (eol_4 && mc_eopp1) rad[4:0] <= {strt_byt_4[1:0],strt_bit_4};
                        `ifdef BYTE16 else rad[4:2] <= rad[4:2] + inc[4:2];
                        `elsif BYTE8  else rad[4:1] <= rad[4:1] + inc[4:1];
                        `else         else rad[4:0] <= rad[4:0] + inc[4:0];
                        `endif
                end
    /* STIPPLE WRITE TRANSFER. */
      else if(stpl_4[1])
                begin
                        /*  stipple packed. */
                        `ifdef BYTE16 if(!mc_eopp1) rad[9:2] <= rad[9:2] + inc[9:2]; `endif
                        `ifdef BYTE8  if(!mc_eopp1) rad[9:1] <= rad[9:1] + inc[9:1]; `endif
                        `ifdef BYTE4  if(!mc_eopp1) rad[9:0] <= rad[9:0] + inc[9:0]; `endif
                end
    /* 32x32 STIPPLE PLANAR OR FULL COLOR. */
    /* word pointer */
      else if(apat_4[1])
                begin
                        `ifdef BYTE16
                        if(eol_4 && ps8_4 && mc_eopp1) rad[9:7] <= {~rad[9],1'b0,strt_wrd_4[0]};
                        else if (eol_4 && mc_eopp1) rad[9:7] <= strt_wrd_4;
                        else if (ps8_4) rad[7] <= ~rad[7]; // word pointer
                        else rad[9:7] <= rad[9:7] + inc[9:7];
                        rad[6:3] <= rad[6:3] + inc[6:3]; /* word pointer */
                        `endif

                        `ifdef BYTE8
                        if(eol_4 && ps8_4 && mc_eopp1) rad[9:6] <= {~rad[9],1'b0,strt_wrd_4[0], strt_byt_4[3]};
                        else if (eol_4 && mc_eopp1) rad[9:6] <= {strt_wrd_4, strt_byt_4[3]};
                        else if (ps8_4)  rad[7:3] <= rad[7:3] + inc[7:3]; 	// Mod 32.
                        else if (ps16_4) rad[8:3] <= rad[8:3] + inc[8:3]; 	// Mod 64.
                        else 		 rad[9:3] <= rad[9:3] + inc[9:3]; 	// Mod 128.
                        `endif

                        `ifdef BYTE4
                        if(eol_4 && ps8_4 && mc_eopp1) rad[9:5] <= {~rad[9],1'b0,strt_wrd_4[0],strt_byt_4[3:2]};
                        else if (eol_4 && mc_eopp1) rad[9:5] <= {strt_wrd_4, strt_byt_4[3:2]};
                        else if (ps8_4) rad[7:5] <= rad[7:5] + inc[7:5];
                        else rad[9:3] <= rad[9:3] + inc[9:3];
                        `endif
                end
    /* 8x8 STIPPLE PLANAR OR FULL COLOR. */
      else if(apat_4[0])
                begin
		  `ifdef BYTE16 
			  if (mc_eopp1)    rad[9:7] <= {rad[9:8],strt_wrd_4[0]} + inc[9:7];
		  	  else if (ps32_4) rad[7:3] <= rad[7:3] + inc[7:3];
		  	  else 		   rad[6:3] <= rad[6:3] + inc[6:3];
	  	  `endif

                  `ifdef BYTE8  
			  if (mc_eopp1 & ps32_4) rad[9:3] <= {rad[9:8],strt_wrd[0], strt_byt_4[3:0]} + inc[9:3];
			  else if (mc_eopp1)     rad[9:3] <= {rad[9:7],strt_byt_4[3:0]} + inc[9:3];
		  	  else if (ps32_4) rad[7:3] <= rad[7:3] + inc[7:3];
		  	  else if (ps16_4) rad[6:3] <= rad[6:3] + inc[6:3];
		  	  else 		   rad[5:3] <= rad[5:3] + inc[5:3];
	  	  `endif

                  `ifdef BYTE4 	
			  if (mc_eopp1) rad[9:5] <= rad[9:5] + inc[9:5];
                  	  else 		rad[7:3] <= rad[7:3] + inc[7:3]; 
	  	  `endif
                end
    /* ALL OTHERS. */
    else rad[9:5] <= rad[9:5] + inc[9:5]; /* word pointer */
    //      int_rad[9:0] <= nxt_rad;
        end
  end


endmodule
