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
//  Title       :  2D Cache Control
//  File        :  ded_cactrl.v
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
  
  module ded_cactrl
    #(parameter BYTES = 4)
    (
     /* host bus input signals */
     input              de_clk,         /* draw engine clock.           */
     input              de_rstn,        /* draw engine reset.           */
     input              mc_push,        // MC push to the 2d cache
     input              read_4,         
     
     /* memory controller input signals */
     input              mclock,         /* Memory controller clock.     */
     input              mc_popen,       /* Memory controller pop enable.*/
     input              mc_acken,       /* Memory controller ack enable.*/
     
     /* execution unit input signals */
     input              irst_wad,       // load start write address
     input              ld_rad,         // load start read address
     input              ld_rad_e,       // load start read address
     input [9:0]        x_adr,          // lower seven bits from the X ALU
     input [8:0]        srcx,           // lower five bits from the dest X
     input [4:0]        dsty,           // lower five bits from the dest Y
     input [6:0]        dstx,           // lower five bits from the dest Y
     input              lt_actv_4,      // triangle active.
     input [1:0]        stpl_2,         // stipple bit level two.
     input [1:0]        stpl_4,         // stipple bit level three.
     input [1:0]        apat_2,         // Area mode 01 = 8x8, 10=32x32.
     input [1:0]        apat_4,         // Area mode level three
     input [2:0]        psize_4,        // pixel size level three.
     input              ps8_2,          // pixel size level two.
     input              ps16_2,         // pixel size level two.
     input              ps32_2,         // pixel size level two.
     input              eol_4,          // End of line indicator
     input              mc_eop,         // end of page one cycle early
     input [2:0]        ofset,          // host ofset.
     input [2:0]        frst8_4,
     input              sol_3,          // sol_3.
     input              mem_req,        // mem_req.
     input              mem_rd,         // mem_rd.
     input              mc_read_4,
     input [4:0]        xpat_ofs,
     input [4:0]        ypat_ofs,
     input              ca_src_2,
     input              rad_flg_3,
     input [2:0]        strt_wrd_3,
     input [3:0]        strt_byt_3,
     input [2:0]        strt_bit_3,
     input [2:0]        strt_wrd_4,
     input [3:0]        strt_byt_4,
     input [2:0]        strt_bit_4,
     input              rst_wad_flg_3,

     output             rad_flg_2,
     output [2:0]       strt_wrd_2,
     output [3:0]       strt_byt_2,
     output [2:0]       strt_bit_2,
     output reg         rst_wad_flg_2,
     output [9:0]       ca_rad,         // cache read address.
     `ifdef BYTE16 output reg [2:0]     ca_mc_addr 
     `elsif BYTE8  output reg [3:0]     ca_mc_addr 
     `else         output reg [4:0]     ca_mc_addr 
     `endif
     );
  
  wire [9:0]     rad_cnt;       /* cache read counter address.          */
  reg            xyw_csn_d;     /* delayed chip select.                 */
  reg            xyw_rdyn_d;    /* delayed ready.                       */
  reg            xyw_rdyn_dd;   /* delayed ready.                       */
  wire [1:0]     ca_shf_adr;
  wire           rstflgn;       /* reset wad.                           */
  reg            irstn;
  
  always @(posedge de_clk or negedge de_rstn) begin
    if(!de_rstn)      rst_wad_flg_2 <= 1'b0;
    else if(irst_wad) rst_wad_flg_2 <= 1'b1;
    else if(mem_req)  rst_wad_flg_2 <= 1'b0;
  end

  assign ca_rad[9:0] = rad_cnt[9:0];

  /**************************************************************************/
  /*                    CACHE WRITE CONTROLLER                              */
  /**************************************************************************/
  always @(posedge mclock or negedge de_rstn)
  begin
    if(!de_rstn)                       ca_mc_addr <= 3'b000;
    else if (mc_acken & rst_wad_flg_3) ca_mc_addr <= 3'b000;
    else if (mc_push)                  ca_mc_addr <= ca_mc_addr + 3'b001;
  end
  
  /**************************************************************************/
  /*    CACHE READ CONTROLLER                                           */
  /**************************************************************************/
  ded_cactrl_rd #
    (
     .BYTES              (BYTES)
     )
  u_ded_cactrl_rd
    (
     .de_rstn            (de_rstn),
     .de_clk             (de_clk),
     .mc_read_4          (mc_read_4),
     .ld_rad             (ld_rad),
     .ld_rad_e           (ld_rad_e),
     .mclock             (mclock),
     .mc_popen           (mc_popen),
     .mc_acken           (mc_acken),
     .din                (x_adr),
     .srcx               (srcx),
     .dsty               (dsty),
     .dstx               (dstx),
     .stpl_2             (stpl_2),
     .stpl_4             (stpl_4),
     .apat_2             (apat_2),
     .apat_4             (apat_4),
     .ps8_2              (ps8_2),
     .ps16_2             (ps16_2),
     .ps32_2             (ps32_2),
     .psize_4            (psize_4),
     .lt_actv_4          (lt_actv_4),
     .eol_4              (eol_4),
     .mc_eop             (mc_eop),
     .ofset              (ofset),
     .frst8_4            (frst8_4),
     .sol_3              (sol_3),
     .mem_req            (mem_req),
     .mem_rd             (mem_rd),
     .xpat_ofs           (xpat_ofs),
     .ypat_ofs           (ypat_ofs),
     .ca_src_2           (ca_src_2),
     .rad_flg_3          (rad_flg_3),
     .strt_wrd_3         (strt_wrd_3),
     .strt_byt_3         (strt_byt_3),
     .strt_bit_3         (strt_bit_3),
     .strt_wrd_4         (strt_wrd_4),
     .strt_byt_4         (strt_byt_4),
     .strt_bit_4         (strt_bit_4),

     .rad_flg_2          (rad_flg_2),
     .strt_wrd_2         (strt_wrd_2),
     .strt_byt_2         (strt_byt_2),
     .strt_bit_2         (strt_bit_2),
     .rad                (rad_cnt)
     );

endmodule
