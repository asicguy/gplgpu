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
//  Title       :  MC DataPath Slice
//  File        :  mc_dat16.v
//  Author      :  Frank Bruno
//  Created     :  12-Nov-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This block performs blending and raster operations on a slice of data from
//  the DE, and then selects the ouput to the RAM data pins to be either this
//  DE data or data from one of the other resources.
// 
//  The first part of this datapath generates the blending factor (previously
//  known as pre-blend). This consists basicly of a large mux selected by pixel
//  format and the blend factor selector.
// 
//  This factor, along with the corresponding color data (again based on pixel 
//  format) is fed into the multiply-add blending circuit. The results are 
//  re-assembled into a full width word, again based on pixel format.
// 
//  Raster operations are then performed on the data, and the desired raster op
//  is chosen with a 16-to-1 mux.
// 
//  Data to the final output registers is updated via ifb_pop_en (which is 
//  always active in the cycle prior to a write) and the data is selected with 
//  ifb_dev_sel which always described which resource will be doing the write
//  when ifb_pop_en is active.
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

`timescale 1 ns / 10 ps

module mc_dat16
  (
   input                mclock,
   input [15:0]         hst_data,          // Host data
   input [15:0]         src_data,          // de data to be written
   input [7:0]          alpha_data,        // de data to be written
   input [7:0]          dst_alpha,         // Source alpha channel
   input [15:0]         dst_data,          // mff data from the frame buffer
   input [15:0]         de_data,           // Direct write data from DE
   input [15:0]         vga_data,          // Direct write data from DE
   input [15:0]         z_data,            // Z data to framebuffer
   input [7:0]          bsrc_alpha,        // 2d src alpha
   input [7:0]          bdst_alpha,        // 2d dst alpha
   input [2:0]          src_factor_select, // bsrcr
   input [2:0]          dst_factor_select, // bdstr
   input                src_reg_en,        // enable blending source register
   input                dst_reg_en,        // enable blending dest register
   input [1:0]          pix,               // pixel format
   input [1:0]          pix_2,             // pixel format
   input                blend_en,          // Enable Blending
   input                mc_dat_pop,        // Pop last pipe bypass
   input                pipe_enable,       //
   input [3:0]          ifb_dev_sel,       // Device pushing data
   input [3:0]          rop,               // Raster Ops
   input [3:0]          rop2,              // Raster Ops

   output reg [15:0]    ram_data_out       // Data to framebuffer
   );
   
  // This is the decode of src_factor_select (bsrcr)
  parameter     /* Computed Blend Factor */
                SRC_ZERO                = 3'h0, /* (0,0,0,0)               */
                SRC_ONE                 = 3'h1, /* (1,1,1,1)               */
                SRC_DST_COLOR           = 3'h2, /* (Ad,Rd,Gd,Bd)           */
                SRC_ONE_MINUS_DST       = 3'h3, /* (1,1,1,1)-(Ad,Rd,Gd,Bd) */
                SRC_SRC_ALPHA           = 3'h4, /* (As,Rs,Gs,Bs)           */
                SRC_ONE_MINUS_SRC_ALPHA = 3'h5, /* (1,1,1,1)-(As,As,As,As) */
                SRC_DST_ALPHA           = 3'h6, /* (Ad,Ad,Ad,Ad)           */
                SRC_ONE_MINUS_DST_ALPHA = 3'h7; /* (1,1,1,1)-(Ad,Ad,Ad,Ad) */
  
  // This is the decode of dst_factor_select (bdstr)
  parameter     /* Computed Blend Factor */
                DST_ZERO                = 3'h0, /* (0,0,0,0)               */
                DST_ONE                 = 3'h1, /* (1,1,1,1)               */
                DST_SRC_COLOR           = 3'h2, /* (As,Rs,Gs,Bs)           */
                DST_ONE_MINUS_SRC       = 3'h3, /* (1,1,1,1)-(As,Rs,Gs,Bs) */
                DST_SRC_ALPHA           = 3'h4, /* (As,Rs,Gs,Bs)           */
                DST_ONE_MINUS_SRC_ALPHA = 3'h5, /* (1,1,1,1)-(As,As,As,As) */
                DST_DST_ALPHA           = 3'h6, /* (Ad,Ad,Ad,Ad)           */
                DST_ONE_MINUS_DST_ALPHA = 3'h7; /* (1,1,1,1)-(Ad,Ad,Ad,Ad) */

  // This is the decode of rop (raster operation select)
  parameter     /* Raster Operation parameters */
        Clear           =4'b0000,       /* destination = 0 */
        Nor             =4'b0001,       /* RMW, NOT src AND NOT dst */
        AndInverted     =4'b0010,       /* RMW, NOT src AND dst */
        CopyInverted    =4'b0011,       /* NOT src */
        AndReverse      =4'b0100,       /* RMW, src AND NOT dst */
        Invert          =4'b0101,       /* RMW, NOT dst */
        Xor             =4'b0110,       /* RMW, src XOR dst */
        Nand            =4'b0111,       /* RMW, NOT src OR NOT dst */
        And             =4'b1000,       /* RMW, src AND dst */
        Equiv           =4'b1001,       /* RMW, NOT src XOR dst */
        Noop            =4'b1010,       /* RMW, dst */
        OrInverted      =4'b1011,       /* RMW, NOT src OR dst */
        Copy            =4'b1100,       /* src */
        OrReverse       =4'b1101,       /* RMW, src OR NOT dst */
        Or              =4'b1110,       /* RMW, src OR dst */
        Set             =4'b1111;       /* destination = 1(one) */

  // Internal registers and wires
  reg [7:0]     ch1_src_color;
  reg [7:0]     ch1_dst_color;
  reg [7:0]     ch1_src_color_d;
  reg [7:0]     ch1_dst_color_d;
  reg [7:0]     ch1_src_alpha;
  reg [7:0]     ch1_dst_alpha;
  reg [7:0]     ch1_src_factor;
  reg [7:0]     ch1_dst_factor;
  reg [7:0]     ch1_src_factor_d;
  reg [7:0]     ch1_dst_factor_d;

  reg [16:0]    ch1_unclamped_sum;
  wire [7:0]    ch1_sum;

  reg [7:0]     ch2_src_color;
  reg [7:0]     ch2_dst_color;
  reg [7:0]     ch2_src_color_d;
  reg [7:0]     ch2_dst_color_d;
  reg [7:0]     ch2_src_alpha;
  reg [7:0]     ch2_dst_alpha;
  reg [7:0]     ch2_src_factor;
  reg [7:0]     ch2_dst_factor;
  reg [7:0]     ch2_src_factor_d;
  reg [7:0]     ch2_dst_factor_d;

  reg [16:0]    ch2_unclamped_sum;
  wire [7:0]    ch2_sum;

  reg [7:0]     ch3_src_color;
  reg [7:0]     ch3_dst_color;
  reg [7:0]     ch3_src_color_d;
  reg [7:0]     ch3_dst_color_d;
  reg [7:0]     ch3_src_alpha;
  reg [7:0]     ch3_dst_alpha;
  reg [7:0]     ch3_src_factor;
  reg [7:0]     ch3_dst_factor;
  reg [7:0]     ch3_src_factor_d;
  reg [7:0]     ch3_dst_factor_d;

  reg [16:0]    ch3_unclamped_sum;
  wire [7:0]    ch3_sum;

  reg           ch4_src_color, ch4_src_color_d;
  reg           ch4_dst_color, ch4_dst_color_d;
  reg           ch4_src_alpha;
  reg           ch4_dst_alpha;
  reg           ch4_src_factor, ch4_src_factor_d;
  reg           ch4_dst_factor, ch4_dst_factor_d;
  reg           ch4_src_prod;
  reg           ch4_dst_prod;
  wire          ch4_sum;
  reg [15:0]    blend_data;
  reg [15:0]    rop_data;
  wire [15:0]   blend_dst;
  reg [15:0]    dst_data_1, dst_data_2;
  reg [15:0]    src_data_1, src_data_2;
  
  // Source and destination data and factor selection
  // This ammounts to 8 case statements, two for each channel
  // This always block generates a src and dst color and factor for each of the
  // four channels in this slice. These factors and colors are inputs to the
  // multipliers in the next block.
  always @* begin
    // Channel 1
    // src_color based on pix
    // For 16bpp modes, msbs are copied into lsbs to do color expansion
    ch1_src_color = (pix[0]==1'b1) ? {src_data[4:0], src_data[4:2]} : 
                    src_data[7:0];

    ch1_src_alpha = src_reg_en ? bsrc_alpha : alpha_data;

    // dst_color based on pix
    ch1_dst_color = (pix[0]==1'b1) ? {dst_data[4:0], dst_data[4:2]} : 
                    dst_data[7:0];

    ch1_dst_alpha = dst_reg_en ? bdst_alpha : (pix[0]==1'b1) ? 
		    {8{dst_data[15]}} : dst_alpha;

    casex (src_factor_select) /* synopsys full_case parallel_case */
      SRC_ZERO:                ch1_src_factor = 8'h00;
      SRC_ONE:                 ch1_src_factor = 8'hFF;
      SRC_DST_COLOR:           ch1_src_factor = ch1_dst_color;
      SRC_ONE_MINUS_DST:       ch1_src_factor = ~ch1_dst_color;
      SRC_SRC_ALPHA:           ch1_src_factor = ch1_src_alpha;
      SRC_ONE_MINUS_SRC_ALPHA: ch1_src_factor = ~ch1_src_alpha;
      SRC_DST_ALPHA:           ch1_src_factor = ch1_dst_alpha;
      SRC_ONE_MINUS_DST_ALPHA: ch1_src_factor = ~ch1_dst_alpha;
    endcase

    casex (dst_factor_select) /* synopsys full_case parallel_case */
      DST_ZERO:                ch1_dst_factor = 8'h00;
      DST_ONE:                 ch1_dst_factor = 8'hFF;
      DST_SRC_COLOR:           ch1_dst_factor = ch1_src_color;
      DST_ONE_MINUS_SRC:       ch1_dst_factor = ~ch1_src_color;
      DST_SRC_ALPHA:           ch1_dst_factor = ch1_src_alpha;
      DST_ONE_MINUS_SRC_ALPHA: ch1_dst_factor = ~ch1_src_alpha;
      DST_DST_ALPHA:           ch1_dst_factor = ch1_dst_alpha;
      DST_ONE_MINUS_DST_ALPHA: ch1_dst_factor = ~ch1_dst_alpha;
    endcase // casex (dst_blend)

    // Channel 2
    // src_color based on pix 
    ch2_src_color = (pix==2'b01) ? {src_data[9:5], src_data[9:7]} : 
                    (pix==2'b11) ? {src_data[10:5], src_data[10:9]} : 
                                    src_data[15:8];

    // src alpha based on src_alpha_en (only for factor selection next)
    ch2_src_alpha = src_reg_en ? bsrc_alpha : alpha_data;

    // dst_color based on pix
    ch2_dst_color = (pix==2'b01) ? {dst_data[9:5], dst_data[9:7]} :
                    (pix==2'b11) ? {dst_data[10:5], dst_data[10:9]} :
                                    dst_data[15:8];

    ch2_dst_alpha = dst_reg_en ? bdst_alpha : (pix[0]==1'b1) ? 
		    {8{dst_data[15]}} : dst_alpha;

    casex (src_factor_select) /* synopsys full_case parallel_case */
      SRC_ZERO:                ch2_src_factor = 8'h00;
      SRC_ONE:                 ch2_src_factor = 8'hFF;
      SRC_DST_COLOR:           ch2_src_factor = ch2_dst_color;
      SRC_ONE_MINUS_DST:       ch2_src_factor = ~ch2_dst_color;
      SRC_SRC_ALPHA:           ch2_src_factor = ch2_src_alpha;
      SRC_ONE_MINUS_SRC_ALPHA: ch2_src_factor = ~ch2_src_alpha;
      SRC_DST_ALPHA:           ch2_src_factor = ch2_dst_alpha;
      SRC_ONE_MINUS_DST_ALPHA: ch2_src_factor = ~ch2_dst_alpha;
    endcase

    casex (dst_factor_select) /* synopsys full_case parallel_case */
      DST_ZERO:                ch2_dst_factor = 8'h00;
      DST_ONE:                 ch2_dst_factor = 8'hFF;
      DST_SRC_COLOR:           ch2_dst_factor = ch2_src_color;
      DST_ONE_MINUS_SRC:       ch2_dst_factor = ~ch2_src_color;
      DST_SRC_ALPHA:           ch2_dst_factor = ch2_src_alpha;
      DST_ONE_MINUS_SRC_ALPHA: ch2_dst_factor = ~ch2_src_alpha;
      DST_DST_ALPHA:           ch2_dst_factor = ch2_dst_alpha;
      DST_ONE_MINUS_DST_ALPHA: ch2_dst_factor = ~ch2_dst_alpha;
    endcase // casex (dst_blend)

    // Channel 3 (color is only 5 bits instead of 8)
    // src_color based on pix, but we know we are in 16bpp mode if we are 
    // using this channel
    ch3_src_color = (pix[1]==1'b1) ? {src_data[15:11], src_data[15:13]} : 
                    {src_data[14:10], src_data[14:12]};

    // src alpha based on src_alpha_en (only for factor selection next)
    ch3_src_alpha = src_reg_en ? bsrc_alpha : alpha_data;

    // dst_color based on pix
    ch3_dst_color = (pix[1]==1'b1) ? {dst_data[15:11], dst_data[15:13]} : {dst_data[14:10], dst_data[14:12]};

    ch3_dst_alpha = dst_reg_en ? bdst_alpha : (pix[0]==1'b1) ? 
		    {8{dst_data[15]}} : dst_alpha;

    casex (src_factor_select) /* synopsys full_case parallel_case */
      SRC_ZERO:                ch3_src_factor = 8'h00;
      SRC_ONE:                 ch3_src_factor = 8'hFF;
      SRC_DST_COLOR:           ch3_src_factor = ch3_dst_color;
      SRC_ONE_MINUS_DST:       ch3_src_factor = ~ch3_dst_color;
      SRC_SRC_ALPHA:           ch3_src_factor = ch3_src_alpha;
      SRC_ONE_MINUS_SRC_ALPHA: ch3_src_factor = ~ch3_src_alpha;
      SRC_DST_ALPHA:           ch3_src_factor = ch3_dst_alpha;
      SRC_ONE_MINUS_DST_ALPHA: ch3_src_factor = ~ch3_dst_alpha;
    endcase

    casex (dst_factor_select) /* synopsys full_case parallel_case */
      DST_ZERO:                ch3_dst_factor = 8'h00;
      DST_ONE:                 ch3_dst_factor = 8'hFF;
      DST_SRC_COLOR:           ch3_dst_factor = ch3_src_color;
      DST_ONE_MINUS_SRC:       ch3_dst_factor = ~ch3_src_color;
      DST_SRC_ALPHA:           ch3_dst_factor = ch3_src_alpha;
      DST_ONE_MINUS_SRC_ALPHA: ch3_dst_factor = ~ch3_src_alpha;
      DST_DST_ALPHA:           ch3_dst_factor = ch3_dst_alpha;
      DST_ONE_MINUS_DST_ALPHA: ch3_dst_factor = ~ch3_dst_alpha;
    endcase // casex (dst_blend)

    // Channel 4 (1 bit alpha)
    // This channel is only used for 1555 mode, so we don't care about pix
    // we also don't care about the source and destination alpha registers and enables
    ch4_src_color = src_data[15];
    ch4_src_alpha = bsrc_alpha[7];
    ch4_dst_color = dst_data[15];
    ch4_dst_alpha = bdst_alpha[7];

    casex (src_factor_select) /* synopsys full_case parallel_case */
      SRC_ZERO:                ch4_src_factor = 1'b0;
      SRC_ONE:                 ch4_src_factor = 1'b1;
      SRC_DST_COLOR:           ch4_src_factor = ch4_dst_color;
      SRC_ONE_MINUS_DST:       ch4_src_factor = ~ch4_dst_color;
      SRC_SRC_ALPHA:           ch4_src_factor = ch4_src_alpha;
      SRC_ONE_MINUS_SRC_ALPHA: ch4_src_factor = ~ch4_src_alpha;
      SRC_DST_ALPHA:           ch4_src_factor = ch4_dst_alpha;
      SRC_ONE_MINUS_DST_ALPHA: ch4_src_factor = ~ch4_dst_alpha;
    endcase

    casex (dst_factor_select) /* synopsys full_case parallel_case */
      DST_ZERO:                ch4_dst_factor = 1'b0;
      DST_ONE:                 ch4_dst_factor = 1'b1;
      DST_SRC_COLOR:           ch4_dst_factor = ch4_src_color; 
      DST_ONE_MINUS_SRC:       ch4_dst_factor = ~ch4_src_color;
      DST_SRC_ALPHA:           ch4_dst_factor = ch4_src_alpha; 
      DST_ONE_MINUS_SRC_ALPHA: ch4_dst_factor = ~ch4_src_alpha;
      DST_DST_ALPHA:           ch4_dst_factor = ch4_dst_alpha;
      DST_ONE_MINUS_DST_ALPHA: ch4_dst_factor = ~ch4_dst_alpha;
    endcase // casex (dst_factor_select)
    
  end
  
  // Multiply source by source factor and destination by destination factor
  // This is for four channels, or 8 multipliers, but 2 are only 1 bit wide.
  // Pipe stage at the multiplier outputs
  // Mux to saturate when we have max alpha removed. It really wasn't 
  // mathmatically correct, and the rest of the pipe doesn't use saturated 
  // math. Then it was added again, just so we don't have to deal with 
  // updating expected results for the regressions right now. We can decide 
  // later what it really should end up as.
  always @ (posedge mclock) begin

    if (pipe_enable) begin
    // Pipeline the incoming colors and factors to ensure the multiplier
    // has 1 full cycle to operate in
    ch1_src_factor_d <= ch1_src_factor;
    ch2_src_factor_d <= ch2_src_factor;
    ch3_src_factor_d <= ch3_src_factor;
    ch4_src_factor_d <= ch4_src_factor;
    
    ch1_dst_factor_d <= ch1_dst_factor;
    ch2_dst_factor_d <= ch2_dst_factor;
    ch3_dst_factor_d <= ch3_dst_factor;
    ch4_dst_factor_d <= ch4_dst_factor;
    
    ch1_src_color_d <= ch1_src_color;
    ch2_src_color_d <= ch2_src_color;
    ch3_src_color_d <= ch3_src_color;
    ch4_src_color_d <= ch4_src_color;
    
    ch1_dst_color_d <= ch1_dst_color;
    ch2_dst_color_d <= ch2_dst_color;
    ch3_dst_color_d <= ch3_dst_color;
    ch4_dst_color_d <= ch4_dst_color;
    
    ch1_unclamped_sum <= ch1_src_factor_d * ch1_src_color_d +
                         ch1_dst_factor_d * ch1_dst_color_d;
    ch2_unclamped_sum <= ch2_src_factor_d * ch2_src_color_d +
                         ch2_dst_factor_d * ch2_dst_color_d;
    ch3_unclamped_sum <= ch3_src_factor_d * ch3_src_color_d +
                         ch3_dst_factor_d * ch3_dst_color_d;
    
    // only 1 bit
    ch4_src_prod <= ch4_src_color_d & ch4_src_factor_d;
    ch4_dst_prod <= ch4_dst_color_d & ch4_dst_factor_d;

    dst_data_1 <= dst_data;
    dst_data_2 <= dst_data_1;
    src_data_1 <= src_data;
    src_data_2 <= src_data_1;

    end
  end // always @ (posedge mclock)
  

  // Add source and destination products together
  // Four adders, one is again only 1 bit. 
  // Output must be clamped to prevent overflow

  assign ch1_sum = (ch1_unclamped_sum[16]) ? 8'hFF : ch1_unclamped_sum[15:8];
  assign ch2_sum = (ch2_unclamped_sum[16]) ? 8'hFF : ch2_unclamped_sum[15:8];
  assign ch3_sum = (ch3_unclamped_sum[16]) ? 8'hFF : ch3_unclamped_sum[15:8];

  // only 1 bit so the multiply is a logical and, the add is an or
  assign ch4_sum = ch4_src_prod | ch4_dst_prod;

  // Reassemble pixel data
  // mux selected by pix. 
  // Output either is ch1,ch2 or ch1,ch2,ch3 or ch1,ch2_ch3_ch4
  // pix is 00 for 8bpp, 01 for 1555, 11 for 565, 10 for 8888
  // Need to take the msb's of the color data
  always @*
    casex ({blend_en, pix_2})
      3'b1_01: 
        blend_data = {ch4_sum, ch3_sum[7:3], ch2_sum[7:3], ch1_sum[7:3]};
      3'b1_11:
        blend_data = {ch3_sum[7:3], ch2_sum[7:2], ch1_sum[7:3]};
      3'b1_x0:
        blend_data = {ch2_sum, ch1_sum};
      3'b0_xx:
        blend_data = src_data_2;
    endcase // casex({blend_en, pix})

  assign blend_dst = dst_data_2;

  // Perform rops
  always @* begin
    case(rop2)   /* synopsys parallel_case full_case     */
      Clear:            rop_data = 16'b0;
      Nor:              rop_data = (~blend_data & ~blend_dst);
      AndInverted:      rop_data = (~blend_data & blend_dst);
      CopyInverted:     rop_data = (~blend_data);
      AndReverse:       rop_data = (blend_data & ~blend_dst);
      Invert:           rop_data = (~blend_dst);
      Xor:              rop_data = (blend_data ^ blend_dst);
      Nand:             rop_data = (~blend_data | ~blend_dst);
      And:              rop_data = (blend_data & blend_dst);
      Equiv:            rop_data = (~blend_data ^ blend_dst);
      Noop:             rop_data = (blend_dst);
      OrInverted:       rop_data = (~blend_data | blend_dst);
      Copy:             rop_data = (blend_data);
      OrReverse:        rop_data = (blend_data | ~blend_dst);
      Or:               rop_data = (blend_data | blend_dst);
      Set:              rop_data = 16'hffff;
    endcase
  end

  always @ (posedge mclock)
    casex ({mc_dat_pop, ifb_dev_sel, rop})
      9'b1_0001_0000: ram_data_out <= 16'h0;
      9'b1_0001_0011: ram_data_out <= ~de_data;
      9'b1_0001_1100: ram_data_out <= de_data;
      9'b1_0001_1111: ram_data_out <= 16'hFFFF;
      9'b1_0110_xxxx: ram_data_out <= rop_data;
      9'b1_0011_xxxx: ram_data_out <= hst_data;
      9'b1_0111_xxxx: ram_data_out <= vga_data;
      9'b1_1000_xxxx: ram_data_out <= z_data;
    endcase // casex ({mc_dat_pop, ifb_dev_sel, rop})
endmodule // mc_dat16
