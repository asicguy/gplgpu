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
//  Title       :  Drawing Engine Data Path Mask Generator
//  File        :  ded_mskgen.v
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
module ded_mskgen
  #(parameter BYTES = 4)
  (
   input                de_clk,         // drawing engine clock
                        de_rstn,        // drawing engine reset
                        mclock,         // memory controller clock
                        mc_acken,       // memory controller pop enable
                        mc_popen,       // memory controller pop enable
   input                ld_msk,         // load mask registers
   input                line_actv_4,    // line command active bit
                        blt_actv_4,     // blt command active bit
   input [1:0]          clp_4,          // clipping control register
   input                mem_req,        // memory request signal
   input                mem_rd,         // memory read signal
   input [BYTES-1:0]    pc_msk_in,      // pixel cache mask
   input [31:0]         clpx_bus_2,     // clipping {xmax[15:4],xmin[15:4]}
   input [15:0]         x_bus,          // bus from execution X dest counter
   input [6:0]          xalu_bus,       // bus from execution unit X alu
   input                trnsp_4,        // Transparent bit
   input [BYTES-1:0]    trns_msk_in,    // Transparentcy mask
   input                ps16_2,         // pixel size equals 16
   input                ps32_2,         // pixel size equals 32
   input                mc_eop,         // mc end of page delayed
   input [3:0]          mask_4,         // plane mask
   input [6:0]          lft_enc_4,
   input [6:0]          rht_enc_4,
   input [11:0]         clp_min_4,      // left clipping pointer
   input [11:0]         clp_max_4,      // right clipping pointer
   input [3:0]          cmin_enc_4,
   input [3:0]          cmax_enc_4,
   input                y_clip_4,
   input                sol_4,
   input                eol_4,
   input [13:0]         x_count_4,      // current X position
   input                mc_eop4,
   
   output reg [BYTES-1:0] pixel_msk,    // pixel mask for the memory controller
   output reg             clip_ind,     // Clip indicator
   output reg [6:0]       lft_enc_2,
   output reg [6:0]       rht_enc_2,
   output [11:0]          clp_min_2,    // left clipping pointer
   output [11:0]          clp_max_2,    // right clipping pointer
   output reg [3:0]       cmin_enc_2,
   output reg [3:0]       cmax_enc_2
   
   );

  wire    iclip_ind;    // Clip indicator
  wire [BYTES-1:0] trns_msk;    // Transparentcy mask
  reg              last_mask;   // end of line pulse level 4

  /* register the mask bits from the execution unit. */
  reg            mc_eop_del;
  reg [15:0]     pixel_msk_2d_del;// pixel mask for the memory controller
  reg [15:0]     pixel_msk_2d_del2;// pixel mask for the memory controller
  reg            blt_actv_4_d, sol_4_d;
  reg [BYTES-1:0]        pc_msk_del;

  reg [15:0]     clp_msk;
  wire [15:0]    cmin_msk;
  wire [15:0]    cmax_msk;
  reg [15:0]     lft;
  reg [15:0]     rht;
  wire [15:0]    rht_msk;
  wire [15:0]    lft_msk;
  wire [15:0]    mid_msk;
  reg            cmin_en;       // clipping min mask enable
  reg            cmax_en;       // clipping max mask enable
  reg            xl_cmin;
  reg            cmaxl_x;
  wire           drw_outside_4; // draw outside of clipping box
  wire           drw_inside_4;  // draw inside of clipping box
  wire           x_clip;
  reg [15:0]     pixel_msk_0;   // pixel mask for the memory controller

  reg   [1:0]   sub_page;
  reg   [1:0]   sub_page_1;
  reg   [1:0]   sub_page_2;
  reg   [1:0]   sub_page_3;
  reg   [1:0]   sub_page_4;

  // Latch the mask values
  always @(posedge de_clk or negedge de_rstn) begin
    if (!de_rstn) begin
      lft_enc_2<=0;
      rht_enc_2 <=0;
    end else if (ld_msk) begin
      lft_enc_2 <=x_bus[6:0];
      rht_enc_2<=xalu_bus-7'b1;
    end
  end

  assign clp_min_2 = clpx_bus_2[15:4];
  assign clp_max_2 = clpx_bus_2[31:20];
  
  // Latch the encode mask values
  // clpx_bus_2 = {xmax,xmin}
  always @* begin
    cmin_enc_2 = clpx_bus_2[3:0];

    casex ({ps16_2, ps32_2})
      2'b1x: cmax_enc_2 = clpx_bus_2[19:16]+4'b0001; // 16 bpp
      2'b01: cmax_enc_2 = clpx_bus_2[19:16]+4'b0011; // 32 bpp
      2'b00: cmax_enc_2 = clpx_bus_2[19:16];   // 8  bpp
    endcase
  end

  always @* begin
    // create the mask enable control bits
    `ifdef BYTE16
        cmin_en = (x_count_4 == clp_min_4);
        cmax_en = (x_count_4 == clp_max_4);
     `endif

    `ifdef BYTE8
        cmin_en = (x_count_4[12:1] == clp_min_4);
        cmax_en = (x_count_4[12:1] == clp_max_4);
     `endif

    `ifdef BYTE4
        cmin_en = (x_count_4[13:2] == clp_min_4);
        cmax_en = (x_count_4[13:2] == clp_max_4);
     `endif
  end

    `ifdef BYTE4
  always @* begin
    if (x_count_4[13] & !clp_min_4[11])      xl_cmin = 1;
    else if (!x_count_4[13] & clp_min_4[11]) xl_cmin = 0;
    else if (x_count_4[13:2] < clp_min_4)    xl_cmin = 1;
    else                                     xl_cmin = 0;
  end

  always @* begin
    if (x_count_4[13] & !clp_max_4[11])      cmaxl_x = 0;
    else if (!x_count_4[13] & clp_max_4[11]) cmaxl_x = 1;
    else if (x_count_4[13:2] > clp_max_4)    cmaxl_x = 1;
    else                                     cmaxl_x = 0;
  end
     `endif

    `ifdef BYTE8
  always @* begin
    if (x_count_4[12] & !clp_min_4[11])      xl_cmin = 1;
    else if (!x_count_4[12] & clp_min_4[11]) xl_cmin = 0;
    else if (x_count_4[12:1] < clp_min_4)    xl_cmin = 1;
    else                                     xl_cmin = 0;
  end

  always @* begin
    if (x_count_4[12] & !clp_max_4[11])      cmaxl_x = 0;
    else if (!x_count_4[12] & clp_max_4[11]) cmaxl_x = 1;
    else if (x_count_4[12:1] > clp_max_4)    cmaxl_x = 1;
    else                                     cmaxl_x = 0;
  end
     `endif

    `ifdef BYTE16
  always @* begin
    if (x_count_4[11] & !clp_min_4[11])      xl_cmin = 1;
    else if (!x_count_4[11] & clp_min_4[11]) xl_cmin = 0;
    else if (x_count_4[11:0] < clp_min_4)    xl_cmin = 1;
    else                                     xl_cmin = 0;
  end

  always @* begin
    if (x_count_4[11] & !clp_max_4[11])      cmaxl_x = 0;
    else if (!x_count_4[11] & clp_max_4[11]) cmaxl_x = 1;
    else if (x_count_4[11:0] > clp_max_4)    cmaxl_x = 1;
    else                                     cmaxl_x = 0;
  end
     `endif


  assign drw_outside_4 = (clp_4[1] & clp_4[0]);
  assign drw_inside_4 = (clp_4[1] & ~clp_4[0]);
  assign x_clip = (drw_outside_4 & !(xl_cmin | cmaxl_x)) || 
         (drw_inside_4 & (xl_cmin | cmaxl_x));

  always @(posedge mclock) mc_eop_del <= mc_eop;

  always @(posedge mclock or negedge de_rstn) begin
    if (!de_rstn)                  clip_ind <= 0;
    else if (mc_eop_del)           clip_ind <= 0;
    else if (iclip_ind & mc_popen) clip_ind <= 1;
  end

  // combine all of the masks
  assign        cmin_msk =  left_clip(drw_outside_4,cmin_enc_4);
  assign        cmax_msk =  rght_clip(drw_outside_4,cmax_enc_4);
  
  assign        iclip_ind = 
                (blt_actv_4 & drw_outside_4 & x_clip & y_clip_4 & 
                 !(cmin_en | cmax_en)) |
                  (blt_actv_4 & drw_inside_4 & y_clip_4) |
                (blt_actv_4 & drw_inside_4 & x_clip & !(cmin_en | cmax_en)) |
                (blt_actv_4 & drw_inside_4 & cmin_en & cmax_en & !y_clip_4) |
                (blt_actv_4 & drw_outside_4 & cmin_en & cmax_en & y_clip_4) |
                (blt_actv_4 & drw_inside_4 & cmin_en & !y_clip_4) |
                (blt_actv_4 & drw_outside_4 & cmin_en & y_clip_4) |
                (blt_actv_4 & drw_inside_4 & cmax_en & !y_clip_4) |
                (blt_actv_4 & drw_outside_4 & cmax_en & y_clip_4);

  assign        rht_msk = ((blt_actv_4_d) & last_mask & sol_4_d) ? (rht | lft) : 
                          ((blt_actv_4_d) & last_mask) ? rht : 16'hFFFF;
  
  assign        lft_msk = ((blt_actv_4_d) & sol_4_d & !last_mask) ? lft : 16'hFFFF;

  assign        mid_msk = (blt_actv_4_d & last_mask) ? 16'hFFFF :
                         ((blt_actv_4_d & sol_4_d) ? 16'hFFFF :
                         ((blt_actv_4_d) ? 16'h0 : 16'hFFFF));
  
  assign        trns_msk = (trnsp_4 && !line_actv_4) ? ~trns_msk_in : 16'h0;

  always @(posedge mclock) begin
    // Delay Controls
    blt_actv_4_d <= blt_actv_4;
    sol_4_d <= sol_4;

    // Delay the rht, lft mask, and the last_mask signal
    lft <= {1'b0, {15{1'b1}}} >> (~lft_enc_4[3:0]);
    rht <= {{15{1'b1}}, 1'b0} << (rht_enc_4[3:0]);

    last_mask <= (eol_4 & mc_eop4);


    clp_msk <= (blt_actv_4 & drw_outside_4 & x_clip & y_clip_4 & !(cmin_en | cmax_en)) ? {16{1'b1}} : 
               (blt_actv_4 & drw_inside_4  & y_clip_4) ? {16{1'b1}} : 
               (blt_actv_4 & drw_inside_4  & x_clip & !(cmin_en | cmax_en)) ? {16{1'b1}} : 
               (blt_actv_4 & drw_inside_4  & cmin_en & cmax_en & !y_clip_4) ? (cmin_msk | cmax_msk) :
               (blt_actv_4 & drw_outside_4 & cmin_en & cmax_en & y_clip_4) ? (cmin_msk & cmax_msk) :
               (blt_actv_4 & drw_inside_4  & cmin_en & !y_clip_4) ? cmin_msk :
               (blt_actv_4 & drw_outside_4 & cmin_en & y_clip_4) ? cmin_msk :
               (blt_actv_4 & drw_inside_4  & cmax_en & !y_clip_4) ? cmax_msk :
               (blt_actv_4 & drw_outside_4 & cmax_en & y_clip_4) ? cmax_msk :
               16'h0;

    sub_page_4 <= sub_page_3;
    sub_page_3 <= sub_page_2;
    sub_page_2 <= sub_page_1;
    sub_page_1 <= sub_page;
      
    if(mc_acken) sub_page <= 1'b0;
    else if(mc_popen) sub_page <= sub_page + 1'b1;
  
    pixel_msk_2d_del <= (lft_msk & rht_msk & mid_msk) | clp_msk;
    pixel_msk_2d_del2 <= pixel_msk_2d_del;

    pc_msk_del <= pc_msk_in;
    
    // Pipe stage added to increase MC clock speed
    // trans mask has to be last because of delays of cx_reg
    //    pixel_msk_0 <= line_actv_4 ? pc_msk_del : (pixel_msk_0 | trns_msk | ~{(BYTES/2){mask_4}});
    `ifdef BYTE16 pixel_msk_0 <= line_actv_4 ? pc_msk_del : pixel_msk_2d_del2; `endif
    `ifdef BYTE8 pixel_msk_0 <= line_actv_4 ? {2{pc_msk_del}} : pixel_msk_2d_del2; `endif
    `ifdef BYTE4 pixel_msk_0 <= line_actv_4 ? {4{pc_msk_del}} : pixel_msk_2d_del2; `endif

    if (BYTES == 16)
      pixel_msk <= pixel_msk_0 | ((!line_actv_4) ? trns_msk : 16'h0) | ~{4{mask_4}};
    else if (BYTES == 8)
      case (sub_page_4[0])
        1'b0: pixel_msk <= pixel_msk_0[7:0] | ((!line_actv_4) ? trns_msk : 8'h0) | ~{2{mask_4}};
        1'b1: pixel_msk <= pixel_msk_0[15:8] | ((!line_actv_4) ? trns_msk : 8'h0) | ~{2{mask_4}};
      endcase
    else 
      case (sub_page_4[1:0])
        2'b00: pixel_msk <= pixel_msk_0[3:0] | ((!line_actv_4) ? trns_msk : 4'h0) | ~mask_4;
        2'b01: pixel_msk <= pixel_msk_0[7:4] | ((!line_actv_4) ? trns_msk : 4'h0) | ~mask_4;
        2'b10: pixel_msk <= pixel_msk_0[11:8] | ((!line_actv_4) ? trns_msk : 4'h0) | ~mask_4;
        2'b11: pixel_msk <= pixel_msk_0[15:12] | ((!line_actv_4) ? trns_msk : 4'h0) | ~mask_4;
      endcase
  end

  // function to generate the left clipping mask
  function [15:0] left_clip;
    input               inv_msk;
    input       [3:0]   msk_in;
    reg [15:0]  mask;
    begin
      /* left clip mask */
      case(msk_in)      /* synopsys full_case parallel_case */
        
        0:      mask = 16'b0000000000000000;
        1:      mask = 16'b0000000000000001;
        2:      mask = 16'b0000000000000011;
        3:      mask = 16'b0000000000000111;
        4:      mask = 16'b0000000000001111;
        5:      mask = 16'b0000000000011111;
        6:      mask = 16'b0000000000111111;
        7:      mask = 16'b0000000001111111;
        8:      mask = 16'b0000000011111111;
        9:      mask = 16'b0000000111111111;
        10:     mask = 16'b0000001111111111;
        11:     mask = 16'b0000011111111111;
        12:     mask = 16'b0000111111111111;
        13:     mask = 16'b0001111111111111;
        14:     mask = 16'b0011111111111111;
        15:     mask = 16'b0111111111111111;
        
      endcase
      if(inv_msk)left_clip=~mask;
      else left_clip=mask;
    end
  endfunction

  // function to generate the right clipping mask and window max.
  function [15:0] rght_clip;
    input               inv_msk;
    input       [3:0]   msk_in;
    reg [15:0]  mask;
    begin
      /* right mask */
      case(msk_in)      /* synopsys full_case parallel_case */
        
        0:      mask = 16'b1111111111111110;
        1:      mask = 16'b1111111111111100;
        2:      mask = 16'b1111111111111000;
        3:      mask = 16'b1111111111110000;
        4:      mask = 16'b1111111111100000;
        5:      mask = 16'b1111111111000000;
        6:      mask = 16'b1111111110000000;
        7:      mask = 16'b1111111100000000;
        8:      mask = 16'b1111111000000000;
        9:      mask = 16'b1111110000000000;
        10:     mask = 16'b1111100000000000;
        11:     mask = 16'b1111000000000000;
        12:     mask = 16'b1110000000000000;
        13:     mask = 16'b1100000000000000;
        14:     mask = 16'b1000000000000000;
        15:     mask = 16'b0000000000000000;
        
      endcase
      if(inv_msk)rght_clip=~mask;
      else rght_clip=mask;
    end
  endfunction

endmodule
