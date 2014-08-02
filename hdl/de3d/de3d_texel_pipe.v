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
//  Title       :  3D Texel Pipeline
//  File        :  de3d_texel_pipe.v
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This is the OpenGL/ Direct3D Fixed Function pipeline.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module de3d_texel_pipe
  #
  (
   parameter fract = 9
   )
  (
   input 	       de_clk,        // Drawing engine clock.
   input 	       de_rstn,       // Drawing engine reset.
   input 	       pix_valid,     // Valid pixel
   input 	       clip,          // Rectangular Clip Signal
   input 	       last,          // Rectangular Clip Signal
   input 	       msk_last,      // Rectangular Clip Signal
   input 	       fg_bgn,        // foreground/background bit
   input [15:0]        current_x,     // X location of pixel
   input [15:0]        current_y,     // X location of pixel
   input [31:0]        current_argb,  // Current interpolated value of ARGB
   input [23:0]        current_spec,  // Specular color
   input [7:0] 	       current_fog,   // fog table value
   input [31:0]        c3d_2,         // 3D control register.
   input [31:0]        tex_2,         // texture control register.
   input [(fract-1):0] current_u,     // U fractional portion.
   input [(fract-1):0] current_v,     // V fractional portion.
   input [5:0] 	       current_gamma, // Gamma for trilinear.
   input [31:0]        ul_tex,        // Texels in
   input [31:0]        ur_tex,        // Texels in
   input [31:0]        ll_tex,        // Texels in
   input [31:0]        lr_tex,        // Texels in

   // From 2D Core.

   input [1:0] 	       ps_2,          // Pixel size
   input [23:0]        alpha_2,       // Alpha Compare Value
   input [17:0]        acntrl_2,      // Alpha Control Register
   input [31:0]        fog_value,     // Fog Color Value
   // The two key values must be programmed
   // by software to match the texel fmt.
   input [23:0]        key_low,       // Low color in the chroma clip range
   input [23:0]        key_hi,        // High color in the chroma clip range
   input 	       pc_busy,       // Pixel Cache busy

   output reg [31:0]   formatted_pixel, // Current Pixel to Pixel Cache
   output reg [7:0]    current_alpha, // Current Alpha to Pixel Cache
   output reg [15:0]   x_out,         // X_POS from F Register
   output reg [15:0]   y_out,         // Y_POS from F Register
   output reg 	       pc_valid,      // Load Pixel Signal to Pixel Cache
   output reg 	       pc_last,       // Last pixel to flush PC
   output reg 	       pc_msk_last,   // Mask the last pixel.
   output reg 	       pc_fg_bgn,     // Fore ground/Back ground select.
   output reg 	       pop_xy,        // Pop the current X&Y location
   output reg 	       pop_spec,      // Pop the current X&Y location
   output reg 	       pop_argb,      // Pop the current ARGB location
   output reg 	       pop_z,         // Pop  Z.
   output reg 	       pop_fog,       // Pop Fog, this can be Vertex or Table fog..

   output reg 	       ps565s_20,     // Pipeline source format
   output reg 	       ps565s_21,     // Pipeline source format
   output reg [2:0]    val3,          // dither lookup
   output reg [1:0]    val2,          // dither lookup
   output reg 	       inc_red,       // dither increment
   output reg 	       inc_green,     // dither increment
   output reg 	       inc_blue,      // dither increment
   output reg [5:0]    rr_out,        // Red and blue intermediate
   output reg [6:0]    gg_out,        // Green intermediate
   output reg [5:0]    bb_out         // Red and blue intermediate
   );

`include "../include/define_3d.h"

  localparam 
    BLUE  = 0,
    GREEN = 1,
    RED   = 2,
    ALPHA = 3;
  
  wire         ps8    = ~|ps_2;
  wire 	       ps565s =  &ps_2;
  wire 	       ps16s  =  ~ps_2[1] & ps_2[0];
  // ALPHA Registers.
  wire [7:0]   alpha_test     = alpha_2[23:16];	// Alpha Compare Value
  wire 	       alpha_comp_en  = acntrl_2[14];	// Alpha Compare Enable Bit
  wire [2:0]   alpha_comp_op  = acntrl_2[13:11];// Alpha clipping operator
  wire 	       alpha_sel      = acntrl_2[15]; 	// Alpha Select Bit
  wire 	       alpha_mod      = acntrl_2[16]; 	// Alpha_modulation bit
  wire 	       alpha_bl_sel   = acntrl_2[17];   // Alpha blending
  // 3D Control register.
  wire 	       ps8p   	      = c3d_2`D3_P8;	// 8 bpp Palletized mode
  wire 	       fog_en	      = c3d_2`D3_FEN;   // Enable or disable fog
  wire 	       spec_enable    = c3d_2`D3_SPE;	// Spec Highlight Enable.
  wire 	       rgb_select     = c3d_2`D3_RSL;	// select RGB
  wire 	       tex_bl_sel     = c3d_2`D3_TBS;	// Texture blending
  wire 	       dither_op      = c3d_2`D3_DOP;	// Dither Control Bits
  wire 	       key_en 	      = c3d_2`D3_KYE;	// Enable color keying
  wire 	       key_pol 	      = c3d_2`D3_KYP;	// key polarity: 0 = inclusive
  
  // TextureD Control register.
  wire 	       decal_a_blend = 0;		// (FIX ME) Texture Decal Alpha Blend Mode
  
  wire 	       rgb_modulation   = tex_2`T_RGBM;  // Texture Map RGB Modulation Mode
  wire 	       texture_map      = tex_2`T_TM;	// Texture Map Mode Bit
  
  // wire	      near_mode        = tex_2`T_NMM;	// Nearest U,V Address Mode
  // wire	      near_mode_mag    = tex_2`T_NMG;	// Nearest U,V Address Mode


  reg [31:0]   texel_pipe1_0;     // Pipeline texels
  reg [31:0]   texel_pipe1_1;     // Pipeline texels
  reg [31:0]   texel_pipe1_2;     // Pipeline texels
  reg [31:0]   texel_pipe1_3;     // Pipeline texels
  reg [16:0]   ul_3, ur_3, ll_3, lr_3;
  reg [16:0]   ul_2, ur_2, ll_2, lr_2;
  reg [16:0]   ul_1, ur_1, ll_1, lr_1;
  reg [16:0]   ul_0, ur_0, ll_0, lr_0;
  
  reg signed [fract:0] u_fract, u_fract_m1;
  reg signed [fract:0] v_fract[5:1], v_fract_m1;
  reg [17:0] 	       upper_tex[3:0], lower_tex[3:0];
  reg [7:0] 	       upper_tex_clamp[3:0], lower_tex_clamp[3:0];
  reg [16:0] 	       texel_top[3:0], texel_bot[3:0];
  reg [17:0] 	       texel_bi_full[3:0];
  reg [7:0] 	       texel_bi[10:7][3:0];
  reg [7:0] 	       one_minus_alpha_8;
  reg [7:0] 	       one_minus[3:0];
  reg [7:0] 	       current_argb_d[2:0][2:0];  // delayed 1 cycle
  reg [8:0] 	       spec_add[2:0];        // Specular + shaded
  reg                  alpha_clip;           // Clip signal due to alpha test
  reg [7:0] 	       alpha_argb_pipe[11:9];// Pipeline alpha
  reg [16:0] 	       temp9, temp9a;        // alpha calculation variables
  reg [7:0] 	       one_minus_10[3:0];
  reg [7:0] 	       alpha_pipe[12:10];    // Pipeline alpha
  reg [15:0] 	       temp16[2:0], temp16a[2:0];
  reg [7:0] 	       final_color[19:12][2:0]; // Pipeline colors
  reg [7:0] 	       final_alpha[19:12];   // Pipeline alpha
  reg [7:0] 	       fog_m1;               // Fog value - 1
  reg [7:0] 	       fog_factor_pipe;      // Pipeline fog factor
  // reg [23:0] 	       fog1, fog2;
  reg [15:0] 	       fog1_red, fog2_red;
  reg [15:0] 	       fog1_grn, fog2_grn;
  reg [15:0] 	       fog1_blu, fog2_blu;
  reg [15:0] 	       x_pipe[20:17];
  reg [15:0] 	       y_pipe[20:17];
  reg [8:0] 	       fogged_color[2:0];
  // reg 	       ps565s_20; 		// Pipeline source format
  // reg 	       ps565s_21; 		// Pipeline source format
  // reg [2:0] 	       val3;                 	// dither lookup
  // reg [1:0] 	       val2;                 	// dither lookup
  // reg 	       inc_red;              // dither increment
  // reg 	       inc_green;            // dither increment
  // reg 	       inc_blue;             // dither increment
  // reg [5:0] 	       rr_out;       		// Red and blue intermediate
  // reg [5:0] 	       bb_out;       		// Red and blue intermediate
  // reg [6:0] 	       gg_out;               // Green intermediate
  reg [1:0] 	       alpha_lt;             // alpha compare
  reg [1:0] 	       alpha_gt;             // alpha compare
  reg [1:0] 	       alpha_eq;             // alpha compare
  reg 		       alpha_tex_sel;        // alpha from texture or shader
  reg [20:0] 	       pipe_valid;           // Pipeline pix valid
  reg [16:13]	       alpha_clip_pipe;	     // Pipeline for Alpha Clip.
  reg [20:1] 	       clip_key;            // Clip signal
  reg [20:17] 	       clip_pipe;            // Clip signal
  reg [20:17]	       pipe_last;	     // Pipeline the last signal.
  reg [20:17]	       pipe_last_msk;	     // Pipeline the mask last signal.
  reg [20:17]	       pipe_fg_bgn;	     // Pipeline the fg_bgn signal.
  reg [3:0] 	       key_clip;             // Texel Keying clip signals
  reg [5:0]	       gamma_pipe[13:1];   	    // Gamma Pipe.

  // Pipelined signals
  // CCS and border color FIFO
  wire [31:0] 	       texel[3:0];           // Texels in
  wire 		       border_empty; // Border FIFO empty
  wire 		       border_full;  // Border FIFO full
  wire [31:0] 	       border_out;   // border color from FIFO
  wire [7:0] 	       border_used;  // border color used words
  wire 		       ccs_out;      // border clamp pipelined
  wire 		       opengl;       // Opengl mode
  wire                 val_comb;     // Valid control setup
  wire                 d3d;
  // wire		       nearest_md;
  
  assign opengl   = tex_bl_sel | alpha_bl_sel;
  assign d3d      = spec_enable;
  assign val_comb = ~(opengl & d3d);
  // assign nearest_md = near_mode | near_mode_mag;
  
  always @* begin
    // if(texture_map & !pc_busy) pop_argb = pipe_valid[6];
    // else if(!pc_busy)pop_argb = pix_valid;
    // else pop_argb = 1'b0;
    if(texture_map) pop_argb = pipe_valid[6];
    else pop_argb = pix_valid;
  end
  
  always @(posedge de_clk, negedge de_rstn)
    if (!de_rstn) begin
      clip_pipe     <= 0;
      clip_key      <= 0;
      pipe_valid    <= 21'b0;
      pipe_last     <= 0;
      pipe_last_msk <= 0;
      alpha_tex_sel <= 1'b0;
    end else begin

      alpha_tex_sel <= texture_map & ~alpha_sel;

      if(texture_map) begin
	pipe_valid    <= pipe_valid    << 1 | (pix_valid);
	clip_key      <= clip_key      << 1 | (&key_clip);
	// Need to handle nearest for clipping
      end else
 	pipe_valid    <= pipe_valid    << 1 | {(pix_valid), 7'h0};

      //if (alpha_clip_pipe[16]) clip_pipe[17] <= 1'b0;
      clip_pipe     <= clip_pipe     << 1 | (clip | alpha_clip_pipe[16]);
      pipe_last     <= pipe_last     << 1 | (last);
      pipe_last_msk <= pipe_last_msk << 1 | (msk_last);
      pipe_fg_bgn   <= pipe_fg_bgn   << 1 | (fg_bgn);

    end

`ifdef RTL_SIM
  reg [4:0] pipe_number;
  always @* begin
    case(pipe_valid)
      21'b000000000000000000000:pipe_number = 5'd0;
      21'b000000000000000000001:pipe_number = 5'd1;
      21'b000000000000000000010:pipe_number = 5'd2;
      21'b000000000000000000100:pipe_number = 5'd3;
      21'b000000000000000001000:pipe_number = 5'd4;
      21'b000000000000000010000:pipe_number = 5'd5;
      21'b000000000000000100000:pipe_number = 5'd6;
      21'b000000000000001000000:pipe_number = 5'd7;
      21'b000000000000010000000:pipe_number = 5'd8;
      21'b000000000000100000000:pipe_number = 5'd9;
      21'b000000000001000000000:pipe_number = 5'd10;
      21'b000000000010000000000:pipe_number = 5'd11;
      21'b000000000100000000000:pipe_number = 5'd12;
      21'b000000001000000000000:pipe_number = 5'd13;
      21'b000000010000000000000:pipe_number = 5'd14;
      21'b000000100000000000000:pipe_number = 5'd15;
      21'b000001000000000000000:pipe_number = 5'd16;
      21'b000010000000000000000:pipe_number = 5'd17;
      21'b000100000000000000000:pipe_number = 5'd18;
      21'b001000000000000000000:pipe_number = 5'd19;
      21'b010000000000000000000:pipe_number = 5'd20;
      21'b100000000000000000000:pipe_number = 5'd21;
    endcase
  end
`endif
  
`ifdef RTL_SIM 
  
  reg [7:0] sample_0;
  reg [7:0] sample_1;
  reg [7:0] sample_2;
  reg [7:0] sample_3;
  
  always @(posedge de_clk) begin
    if (pix_valid)
      case ({|current_u[fract-1:0], |current_v[fract-1:0]})
	2'b00: begin
	  // $display("Filtered texel: %h", texel[0]);
	end
	2'b01: begin
	  sample_0 = ul_tex[7:0] * current_v[fract-1:0] +
		     ll_tex[7:0] * (1 - current_v[fract-1:0]);
	  sample_1 = ul_tex[15:8] * current_v[fract-1:0] +
		     ll_tex[15:8] * (1 - current_v[fract-1:0]);
	  sample_2 = ul_tex[23:16] * current_v[fract-1:0] +
		     ll_tex[23:16] * (1 - current_v[fract-1:0]);
	  sample_3 = ul_tex[31:24] * current_v[fract-1:0] +
		     ll_tex[31:24] * (1 - current_v[fract-1:0]);
	  // $display("Filtered texel: %h", {sample[3], sample[2], sample[1], sample[0]});
	end
	2'b10: begin
	  sample_0 = ul_tex[7:0] * current_u[fract-1:0] +
		     ur_tex[7:0] * (1 - current_u[fract-1:0]);
	  sample_1 = ul_tex[15:8] * current_u[fract-1:0] +
		     ur_tex[15:8] * (1 - current_u[fract-1:0]);
	  sample_2 = ul_tex[23:16] * current_u[fract-1:0] +
		     ur_tex[23:16] * (1 - current_u[fract-1:0]);
	  sample_3 = ul_tex[31:24] * current_u[fract-1:0] +
		     ur_tex[31:24] * (1 - current_u[fract-1:0]);
	  // $display("Filtered texel: %h", {sample[3], sample[2], sample[1], sample[0]});
	end
	2'b11: begin
	  sample_0 = (ul_tex[7:0] * current_u[fract-1:0] +
		      ur_tex[7:0] * (1 - current_u[fract-1:0])) * current_v[fract-1:0] +
		     (ll_tex[7:0] * current_u[fract-1:0] +
		      lr_tex[7:0] * (1 - current_u[fract-1:0])) * (1 - current_v[fract-1:0]);
	  sample_1 = (ul_tex[15:8] * current_u[fract-1:0] +
		      ur_tex[15:8] * (1 - current_u[fract-1:0])) * current_v[fract-1:0] +
		     (ll_tex[15:8] * current_u[fract-1:0] +
		      lr_tex[15:8] * (1 - current_u[fract-1:0])) * (1 - current_v[fract-1:0]);
	  sample_2 = (ul_tex[23:16] * current_u[fract-1:0] +
		      ur_tex[23:16] * (1 - current_u[fract-1:0])) * current_v[fract-1:0] +
		     (ll_tex[23:16] * current_u[fract-1:0] +
		      lr_tex[23:16] * (1 - current_u[fract-1:0])) * (1 - current_v[fract-1:0]);
	  sample_3 = (ul_tex[31:24] * current_u[fract-1:0] +
		      ur_tex[31:24] * (1 - current_u[fract-1:0])) * current_v[fract-1:0] +
		     (ll_tex[31:24] * current_u[fract-1:0] +
		      lr_tex[31:24] * (1 - current_u[fract-1:0])) * (1 - current_v[fract-1:0]);
	  // $display("Filtered texel: %h", {sample[3], sample[2], sample[1], sample[0]});
	end // case: 2'b11
      endcase // case ({|current_u[fract-1:0], |current_v[fract-1:0]})
  end // always @ (posedge de_clk)
`endif
  
  always @(posedge de_clk, negedge de_rstn)
    if (!de_rstn) begin
      pop_spec <= 1'b0;
      pop_xy   <= 1'b0;
      pop_z    <= 1'b0;
    end else begin
      // Pipe 1:
      // Key texels
      gamma_pipe[1] <= current_gamma;
      key_clip[0] <= texel_key(key_en, key_pol, ul_tex, key_low, key_hi);
      key_clip[1] <= texel_key(key_en, key_pol, ur_tex, key_low, key_hi);
      key_clip[2] <= texel_key(key_en, key_pol, ll_tex, key_low, key_hi);
      key_clip[3] <= texel_key(key_en, key_pol, lr_tex, key_low, key_hi);
      
      texel_pipe1_0 <= ul_tex;
      texel_pipe1_1 <= ur_tex;
      texel_pipe1_2 <= ll_tex;
      texel_pipe1_3 <= lr_tex;
      // Pipeline fractions
      v_fract[1] <= {1'b0, current_v[fract-1:0]};
      u_fract    <= {1'b0, current_u[fract-1:0]};
      u_fract_m1 <= (~|current_u[fract-1:0]) ? (1'b1 << fract) : {1'b0, ~current_u[fract-1:0]};
      // Pipe 2:
      //texel_pipe2[l2] <= key_clip[l2] ? 32'b0 : texel_pipe1[l2];
      gamma_pipe[2] <= gamma_pipe[1];
      // Bilinear math - Left/ Right
      ul_0  <= ({8{~key_clip[0]}} & texel_pipe1_0[7:0])   * u_fract_m1;
      ul_1  <= ({8{~key_clip[0]}} & texel_pipe1_0[15:8])  * u_fract_m1;
      ul_2  <= ({8{~key_clip[0]}} & texel_pipe1_0[23:16]) * u_fract_m1;
      ul_3  <= ({8{~key_clip[0]}} & texel_pipe1_0[31:24]) * u_fract_m1;
      ur_0  <= ({8{~key_clip[1]}} & texel_pipe1_1[7:0])   * u_fract;
      ur_1  <= ({8{~key_clip[1]}} & texel_pipe1_1[15:8])  * u_fract;
      ur_2  <= ({8{~key_clip[1]}} & texel_pipe1_1[23:16]) * u_fract;
      ur_3  <= ({8{~key_clip[1]}} & texel_pipe1_1[31:24]) * u_fract;
      ll_0  <= ({8{~key_clip[2]}} & texel_pipe1_2[7:0])   * u_fract_m1;
      ll_1  <= ({8{~key_clip[2]}} & texel_pipe1_2[15:8])  * u_fract_m1;
      ll_2  <= ({8{~key_clip[2]}} & texel_pipe1_2[23:16]) * u_fract_m1;
      ll_3  <= ({8{~key_clip[2]}} & texel_pipe1_2[31:24]) * u_fract_m1;
      lr_0  <= ({8{~key_clip[3]}} & texel_pipe1_3[7:0])   * u_fract;
      lr_1  <= ({8{~key_clip[3]}} & texel_pipe1_3[15:8])  * u_fract;
      lr_2  <= ({8{~key_clip[3]}} & texel_pipe1_3[23:16]) * u_fract;
      lr_3  <= ({8{~key_clip[3]}} & texel_pipe1_3[31:24]) * u_fract;
      // Pipe 2: Take 1- the fractions
      v_fract[2]    <= v_fract[1];
      // Pipe 3:
      gamma_pipe[3] <= gamma_pipe[2];
      v_fract[3]    <= v_fract[2];
      upper_tex[0]  <= ul_0  + ur_0;
      upper_tex[1]  <= ul_1  + ur_1;
      upper_tex[2]  <= ul_2  + ur_2;
      upper_tex[3]  <= ul_3  + ur_3;
      lower_tex[0]  <= ll_0  + lr_0;
      lower_tex[1]  <= ll_1  + lr_1;
      lower_tex[2]  <= ll_2  + lr_2;
      lower_tex[3]  <= ll_3  + lr_3;
      // Pipe 4:
      gamma_pipe[4] <= gamma_pipe[3];
      // Clamp texels
      if (upper_tex[0][17] || &upper_tex[0][16:9]) upper_tex_clamp[0]  <= 8'hFF;
      else upper_tex_clamp[0]  <= (upper_tex[0] >> fract)  + upper_tex[0][fract-8'h1];
      if (upper_tex[1][17] || &upper_tex[1][16:9]) upper_tex_clamp[1]  <= 8'hFF;
      else upper_tex_clamp[1]  <= (upper_tex[1] >> fract)  + upper_tex[1][fract-8'h1];
      if (upper_tex[2][17] || &upper_tex[2][16:9]) upper_tex_clamp[2]  <= 8'hFF;
      else upper_tex_clamp[2]  <= (upper_tex[2] >> fract)  + upper_tex[2][fract-8'h1];
      if (upper_tex[3][17] || &upper_tex[3][16:9]) upper_tex_clamp[3]  <= 8'hFF;
      else upper_tex_clamp[3]  <= (upper_tex[3] >> fract)  + upper_tex[3][fract-8'h1];
      if (lower_tex[0][17] || &lower_tex[0][16:9]) lower_tex_clamp[0]  <= 8'hFF;
      else lower_tex_clamp[0]  <= (lower_tex[0] >> fract)  + lower_tex[0][fract-8'h1];
      if (lower_tex[1][17] || &lower_tex[1][16:9]) lower_tex_clamp[1]  <= 8'hFF;
      else lower_tex_clamp[1]  <= (lower_tex[1] >> fract)  + lower_tex[1][fract-8'h1];
      if (lower_tex[2][17] || &lower_tex[2][16:9]) lower_tex_clamp[2]  <= 8'hFF;
      else lower_tex_clamp[2]  <= (lower_tex[2] >> fract)  + lower_tex[2][fract-8'h1];
      if (lower_tex[3][17] || &lower_tex[3][16:9]) lower_tex_clamp[3]  <= 8'hFF;
      else lower_tex_clamp[3]  <= (lower_tex[3] >> fract)  + lower_tex[3][fract-8'h1];
      v_fract[4] <= v_fract[3];
      v_fract_m1 <= (~|v_fract[3]) ? (1'b1 << fract) : {1'b0, ~v_fract[3][fract-1:0]};
      // Pipe 5:
      gamma_pipe[5] <= gamma_pipe[4];
      // Blinear Math - Upper / Lower
      texel_top[0] <= upper_tex_clamp[0] * v_fract_m1;
      texel_top[1] <= upper_tex_clamp[1] * v_fract_m1;
      texel_top[2] <= upper_tex_clamp[2] * v_fract_m1;
      texel_top[3] <= upper_tex_clamp[3] * v_fract_m1;
      texel_bot[0] <= lower_tex_clamp[0] * v_fract[4];
      texel_bot[1] <= lower_tex_clamp[1] * v_fract[4];
      texel_bot[2] <= lower_tex_clamp[2] * v_fract[4];
      texel_bot[3] <= lower_tex_clamp[3] * v_fract[4];
      // Pipe 6:
      gamma_pipe[6] <= gamma_pipe[5];
      texel_bi_full[0] <= texel_top[0] + texel_bot[0];
      texel_bi_full[1] <= texel_top[1] + texel_bot[1];
      texel_bi_full[2] <= texel_top[2] + texel_bot[2];
      texel_bi_full[3] <= texel_top[3] + texel_bot[3];
      // Pipe 7:
      gamma_pipe[7] <= gamma_pipe[6];
      // Final Bilinear filtered
      // pop_argb <= pipe_valid[6];
      if (texel_bi_full[0][17] || &texel_bi_full[0][16:9]) texel_bi[7][0] <= 8'hFF;
      else texel_bi[7][0] <= (texel_bi_full[0] >> fract)  + texel_bi_full[0][fract-8'h1];
      if (texel_bi_full[1][17] || &texel_bi_full[1][16:9]) texel_bi[7][1] <= 8'hFF;
      else texel_bi[7][1] <= (texel_bi_full[1] >> fract)  + texel_bi_full[1][fract-8'h1];
      if (texel_bi_full[2][17] || &texel_bi_full[2][16:9]) texel_bi[7][2] <= 8'hFF;
      else texel_bi[7][2] <= (texel_bi_full[2] >> fract)  + texel_bi_full[2][fract-8'h1];
      if (texel_bi_full[3][17] || &texel_bi_full[3][16:9]) texel_bi[7][3] <= 8'hFF;
      else texel_bi[7][3] <= (texel_bi_full[3] >> fract)  + texel_bi_full[3][fract-8'h1];
      // Pipe 8:
      gamma_pipe[8] <= gamma_pipe[7];
      // Modulation
      one_minus_alpha_8 <= ~texel_bi[7][ALPHA] + 8'h1;
      texel_bi[8][0] <= texel_bi[7][0];
      texel_bi[8][1] <= texel_bi[7][1];
      texel_bi[8][2] <= texel_bi[7][2];
      texel_bi[8][3] <= texel_bi[7][3];
      // Pipe 9:
      gamma_pipe[9] <= gamma_pipe[8];
      // Modulation
      alpha_argb_pipe[9]       <= current_argb[31:24];
      current_argb_d[0][RED]   <= current_argb[23:16];
      current_argb_d[0][GREEN] <= current_argb[15:8];
      current_argb_d[0][BLUE]  <= current_argb[7:0];
      texel_bi[9][0] <= texel_bi[8][0];
      texel_bi[9][1] <= texel_bi[8][1];
      texel_bi[9][2] <= texel_bi[8][2];
      texel_bi[9][3] <= texel_bi[8][3];
      case ({alpha_bl_sel, alpha_mod})
/*
       2'b00: begin
	  // Texture Alpha, no modulation 
          temp9  <= {texel_bi[8][ALPHA], 8'h0};
          temp9a <= 16'h0;
        end
        2'b10: begin
	  // Vertex Alpha, no modulation 
          temp9  <= {current_argb[31:24], 8'h0};
          temp9a <= 16'h0;
        end
        2'b01: begin
	  // Modulate texture Alpha and Vertex Alpha
          temp9  <= |texel_bi[8][ALPHA] ?  one_minus_alpha_8 * current_argb[ALPHA] : {current_argb[ALPHA], 8'b0};
          temp9a <= texel_bi[8][ALPHA] * current_argb[ALPHA];
        end
        2'b11: begin
	  // Vertex Alpha, no modulation 
          temp9  <= 16'h0;
          temp9a <= 16'h0;
        end
 */
        2'b01: begin
	  // Vertex Alpha, no modulation 
          temp9  <= current_argb[31:24] * texel_bi[8][ALPHA];
          temp9a <= 16'h0;
        end
        2'b10: begin
	  // Modulate texture Alpha and Vertex Alpha
          temp9  <= |texel_bi[8][ALPHA] ?  one_minus_alpha_8 * current_argb[ALPHA] : {current_argb[ALPHA], 8'b0};
          temp9a <= texel_bi[8][ALPHA] * current_argb[ALPHA];
        end
	default: begin
	  // Texture Alpha, no modulation 
          temp9  <= {texel_bi[8][ALPHA], 8'h0};
          temp9a <= 16'h0;
        end
      endcase // case ({alpha_bl_sel, alpha_mod})
      // Pipe 10:
      gamma_pipe[10] <= gamma_pipe[9];
      pop_spec <= pipe_valid[9];
      alpha_argb_pipe[10] <= alpha_argb_pipe[9];
      current_argb_d[1][RED]   <= current_argb_d[0][RED];
      current_argb_d[1][GREEN] <= current_argb_d[0][GREEN];
      current_argb_d[1][BLUE]  <= current_argb_d[0][BLUE];
      texel_bi[10][0] <= texel_bi[9][0];
      one_minus_10[0] <= ~texel_bi[9][0];
      texel_bi[10][1] <= texel_bi[9][1];
      one_minus_10[1] <= ~texel_bi[9][1];
      texel_bi[10][2] <= texel_bi[9][2];
      one_minus_10[2] <= ~texel_bi[9][2];
      texel_bi[10][3] <= texel_bi[9][3];
      one_minus_10[3] <= ~texel_bi[9][3];
      alpha_pipe[10] <= (temp9 >> 8) + (temp9a >> 8) + (temp9[7] | temp9a[7]);
      // Pipe 11:
      gamma_pipe[11] <= gamma_pipe[10];
      pop_fog <= pipe_valid[10];
      alpha_argb_pipe[11] <= alpha_argb_pipe[10];
      current_argb_d[2][RED]   <= current_argb_d[1][RED];
      current_argb_d[2][GREEN] <= current_argb_d[1][GREEN];
      current_argb_d[2][BLUE]  <= current_argb_d[1][BLUE];
      alpha_pipe[11] <= alpha_pipe[10];
      alpha_lt[1] <= alpha_pipe[10] <  alpha_test;
      alpha_gt[1] <= alpha_pipe[10] >  alpha_test;
      alpha_eq[1] <= alpha_pipe[10] == alpha_test;
      alpha_lt[0] <= alpha_argb_pipe[10] <  alpha_test;
      alpha_gt[0] <= alpha_argb_pipe[10] >  alpha_test;
      alpha_eq[0] <= alpha_argb_pipe[10] == alpha_test;
      
	case ({val_comb, tex_bl_sel, rgb_modulation, decal_a_blend})
	  4'b1010: begin
	    temp16[0]  <= texel_bi[10][0] * current_argb_d[1][0];
	    temp16a[0] <= 16'h0;
	    temp16[1]  <= texel_bi[10][1] * current_argb_d[1][1];
	    temp16a[1] <= 16'h0;
	    temp16[2]  <= texel_bi[10][2] * current_argb_d[1][2];
	    temp16a[2] <= 16'h0;
	  end
	  4'b1100: begin
	    temp16[0]  <= |texel_bi[10][0] ? 
			    one_minus_10[0] * current_argb_d[1][0] :
			    current_argb_d[1][0] << 8;
	    temp16[1]  <= |texel_bi[10][1] ? 
			    one_minus_10[1] * current_argb_d[1][1] :
			    current_argb_d[1][1] << 8;
	    temp16[2]  <= |texel_bi[10][2] ? 
			    one_minus_10[2] * current_argb_d[1][2] :
			    current_argb_d[1][2] << 8;
	    temp16a[0] <= texel_bi[10][0] * current_argb_d[1][0];
	    temp16a[1] <= texel_bi[10][1] * current_argb_d[1][1];
	    temp16a[2] <= texel_bi[10][2] * current_argb_d[1][2];
	  end
	  4'b1001: begin
	    temp16[0]  <= texel_bi[10][0] * alpha_pipe[10]; 
	    temp16[1]  <= texel_bi[10][1] * alpha_pipe[10]; 
	    temp16[2]  <= texel_bi[10][2] * alpha_pipe[10]; 

	    temp16a[0] <= |alpha_pipe[10] ? 
			    current_argb_d[1][0] * one_minus_10[0] :
			    current_argb_d[1][0] << 8;
	    temp16a[1] <= |alpha_pipe[10] ? 
			    current_argb_d[1][1] * one_minus_10[1] :
			    current_argb_d[1][1] << 8;
	    temp16a[2] <= |alpha_pipe[10] ? 
			    current_argb_d[1][2] * one_minus_10[2] :
			    current_argb_d[1][2] << 8;
	  end
	  default: begin
	    temp16[0]  <= texel_bi[10][0] << 8;
	    temp16a[0] <= 8'h0;
	    temp16[1]  <= texel_bi[10][1] << 8;
	    temp16a[1] <= 8'h0;
	    temp16[2]  <= texel_bi[10][2] << 8;
	    temp16a[2] <= 8'h0;
	  end
	endcase // case ({val_comb, tex_bl_sel, rgb_modulation, decal_a_blend})

      // Pipe 12: Final stage
      gamma_pipe[12] <= gamma_pipe[11];
      if (texture_map & ~rgb_select) begin
	  final_color[12][0] <= (temp16[0] >> 8) + (temp16a[0] >> 8) +
				  (temp16[0][7] | temp16a[0][7]);
	  final_color[12][1] <= (temp16[1] >> 8) + (temp16a[1] >> 8) +
				  (temp16[1][7] | temp16a[1][7]);
	  final_color[12][2] <= (temp16[2] >> 8) + (temp16a[2] >> 8) +
				  (temp16[2][7] | temp16a[2][7]);
        end
	else begin
	  final_color[12][0] <= current_argb_d[2][0];
	  final_color[12][1] <= current_argb_d[2][1];
	  final_color[12][2] <= current_argb_d[2][2];
       end

      final_alpha[12] <= (texture_map & ~alpha_sel) ? alpha_pipe[11] :
			 alpha_argb_pipe[11];
      
      casex ({alpha_comp_en, alpha_tex_sel, alpha_comp_op})
	5'b0xxxx: alpha_clip <= 1'b0;                        // Not enabled
	5'b1x000: alpha_clip <= 1'b1;                        // NEVER
	5'b1x001: alpha_clip <= 1'b0;                        // ALWAYS
	5'b10010: alpha_clip <= ~alpha_lt[0];                 // LESS
	5'b10011: alpha_clip <= ~(alpha_lt[0] | alpha_eq[0]); // LEQUAL
	5'b10100: alpha_clip <= ~alpha_eq[0];                 // EQUAL
	5'b10101: alpha_clip <= ~(alpha_gt[0] | alpha_eq[0]); // GEQUAL
	5'b10110: alpha_clip <= ~alpha_gt[0];                 // GREATER
	5'b10111: alpha_clip <= alpha_eq[0];                // NOTEQUAL
	5'b11010: alpha_clip <= ~alpha_lt[1];                 // LESS
	5'b11011: alpha_clip <= ~(alpha_lt[1] | alpha_eq[1]); // LEQUAL
	5'b11100: alpha_clip <= ~alpha_eq[1];                 // EQUAL
	5'b11101: alpha_clip <= ~(alpha_gt[1] | alpha_eq[1]); // GEQUAL
	5'b11110: alpha_clip <= ~alpha_gt[1];                 // GREATER
	5'b11111: alpha_clip <= alpha_eq[1];                // NOTEQUAL
      endcase // casex ({alpha_enable, alpha_comp_op})

      // Pipe 13: 
      gamma_pipe[13] <= gamma_pipe[12];
      alpha_clip_pipe[13] <= alpha_clip;
      spec_add[RED]   <= final_color[12][RED]   + current_spec[23:16];
      spec_add[GREEN] <= final_color[12][GREEN] + current_spec[15:8];
      spec_add[BLUE]  <= final_color[12][BLUE]  + current_spec[7:0];
      final_color[13][RED]   <= final_color[12][RED];
      final_color[13][GREEN] <= final_color[12][GREEN];
      final_color[13][BLUE]  <= final_color[12][BLUE];
      final_alpha[13] 	     <= final_alpha[12];
      
      // Pipe 14:
      alpha_clip_pipe[14] <= alpha_clip_pipe[13];
      pop_xy <= pipe_valid[13];
	// tex_2`T_MLM // trilinear enable.
	// tex_2`T_MLP // trilinear pass.
      casex({tex_2`T_MLM, tex_2`T_MLP})
	2'b0x:begin	// No trilinear.
      		//fog_m1 <= ~current_fog + 9'h1;
      		fog_m1 <= ~current_fog;
      		fog_factor_pipe <= current_fog;
	end
	2'b10:begin	// trilinear first pass.
      		//fog_m1 <= ~{gamma_pipe[13],3'b000} + 9'h1;
      		fog_m1 <= ~{gamma_pipe[13],gamma_pipe[13][5:4]};
      		fog_factor_pipe <= {gamma_pipe[13],gamma_pipe[13][5:4]};
	end
	2'b11:begin	// trilinear second pass.
      		fog_m1 <= {gamma_pipe[13],gamma_pipe[13][5:4]};
      		//fog_factor_pipe <= ~{gamma_pipe[13],3'b000} + 9'h1;
      		fog_factor_pipe <= ~{gamma_pipe[13],gamma_pipe[13][5:4]};
	end
	endcase

      final_alpha[14] <= final_alpha[13];

	if (~opengl && d3d) begin
	  final_color[14][RED] <= spec_add[RED][8] ? 8'hFF : spec_add[RED][7:0];
	  final_color[14][GREEN] <= spec_add[GREEN][8] ? 8'hFF : spec_add[GREEN][7:0];
	  final_color[14][BLUE] <= spec_add[BLUE][8] ? 8'hFF : spec_add[BLUE][7:0];
	end else begin
	  final_color[14][RED] <= final_color[13][RED];
	  final_color[14][GREEN] <= final_color[13][GREEN];
	  final_color[14][BLUE] <= final_color[13][BLUE];
	end

      // Pipe 15: Fog Multiply
      alpha_clip_pipe[15]    <= alpha_clip_pipe[14];
      final_alpha[15]        <= final_alpha[14];
      final_color[15][RED]   <= final_color[14][RED];
      final_color[15][GREEN] <= final_color[14][GREEN];
      final_color[15][BLUE]  <= final_color[14][BLUE];

      // fog1[RED*8+:8]   <= final_color[14][RED]   * fog_factor_pipe;
      // fog1[GREEN*8+:8] <= final_color[14][GREEN] * fog_factor_pipe;
      // fog1[BLUE*8+:8]  <= final_color[14][BLUE]  * fog_factor_pipe;
      // fog2[RED*8+:8]   <= fog_value[RED*8+:8]    * fog_m1;
      // fog2[GREEN*8+:8] <= fog_value[GREEN*8+:8]  * fog_m1;
      // fog2[BLUE*8+:8]  <= fog_value[BLUE*8+:8]   * fog_m1;
      //
      fog1_red <= final_color[14][RED]   * fog_factor_pipe;
      fog1_grn <= final_color[14][GREEN] * fog_factor_pipe;
      fog1_blu <= final_color[14][BLUE]  * fog_factor_pipe;
      fog2_red <= fog_value[RED*8+:8]    * fog_m1;
      fog2_grn <= fog_value[GREEN*8+:8]  * fog_m1;
      fog2_blu <= fog_value[BLUE*8+:8]   * fog_m1;

      // pipe 16: Fog Add
      alpha_clip_pipe[16] <= alpha_clip_pipe[15];
      final_alpha[16] <= final_alpha[15];
      final_color[16][RED]   <= final_color[15][RED];
      final_color[16][GREEN] <= final_color[15][GREEN];
      final_color[16][BLUE]  <= final_color[15][BLUE];
      // fogged_color[RED]    <= fog1[RED*8+:8] + fog2[RED*8+:8];
      // fogged_color[GREEN]  <= fog1[GREEN*8+:8] + fog2[GREEN*8+:8];
      // fogged_color[BLUE]   <= fog1[BLUE*8+:8] + fog2[BLUE*8+:8];
      fogged_color[RED]    <= fog1_red[15:8] + fog2_red[15:8] + 
			      (fog1_red[7] | fog2_red[7]);
      fogged_color[GREEN]  <= fog1_grn[15:8] + fog2_grn[15:8] + 
			      (fog1_grn[7] | fog2_grn[7]);
      fogged_color[BLUE]   <= fog1_blu[15:8] + fog2_blu[15:8] + 
			      (fog1_blu[7] | fog2_blu[7]);
      
      // Pipe 17: Fog Normalize
      final_alpha[17] <= final_alpha[16];
      if (fog_en) begin
	final_color[17][RED]   <= fogged_color[RED][8]   ? 8'hFF : fogged_color[RED][7:0];
	final_color[17][GREEN] <= fogged_color[GREEN][8] ? 8'hFF : fogged_color[GREEN][7:0];
	final_color[17][BLUE]  <= fogged_color[BLUE][8]  ? 8'hFF : fogged_color[BLUE][7:0];
      end else begin
	final_color[17][RED]   <= final_color[16][RED];
	final_color[17][GREEN] <= final_color[16][GREEN];
	final_color[17][BLUE]  <= final_color[16][BLUE];
      end
      // Look up Dither values
      val3 = dith4x4_3(current_x[1:0],current_y[1:0]);
      val2 = dith2x2_2(current_x[0],current_y[0]);
      x_pipe[17] <= current_x;
      y_pipe[17] <= current_y;
      
      // Pipe 18: Dither
      pop_z     <= pipe_valid[17];
      final_alpha[18] <= final_alpha[17];
      final_color[18][RED]   <= final_color[17][RED];
      final_color[18][GREEN] <= final_color[17][GREEN];
      final_color[18][BLUE]  <= final_color[17][BLUE];

      inc_red   <= final_color[17][RED][2:0] > val3;
      inc_green <= (ps565s) ? final_color[17][GREEN][1:0] > val2 : 
	             	      final_color[17][GREEN][2:0] > val3;
      inc_blue  <= final_color[17][BLUE][2:0] > val3;

      x_pipe[18] <= x_pipe[17];
      y_pipe[18] <= y_pipe[17];
      ps565s_20 <= ps565s;
      // Pipe 19: Do dither Add
      final_alpha[19] <= final_alpha[18];
      final_color[19][RED]   <= final_color[18][RED];
      final_color[19][GREEN] <= final_color[18][GREEN];
      final_color[19][BLUE]  <= final_color[18][BLUE];

      rr_out <= final_color[18][RED][7:3] + inc_red;
      bb_out <= final_color[18][BLUE][7:3] + inc_blue;
      if (ps565s_20) gg_out <= final_color[18][GREEN][7:2] + inc_green;
      else 	     gg_out <= {final_color[18][GREEN][7:3],1'b0} + {inc_green,1'b0};

      x_pipe[19] <= x_pipe[18];
      y_pipe[19] <= y_pipe[18];
      ps565s_21 <= ps565s_20;

      // Pipe 20: Select output
      current_alpha <= final_alpha[19];
      casex ({ps565s_21, ps16s, ps8, ps8p}) /* synopsys parallel_case */
	// 565 - 16bpp Format	
	4'b1xxx: begin
          x_out <= {x_pipe[19], 1'b0};
	  formatted_pixel[31:16] <= 16'h0000;
	  if (dither_op) begin
	    formatted_pixel[15:11] <= rr_out[5] ? 5'h1F : rr_out[4:0];
	    formatted_pixel[10:5]  <= gg_out[6] ? 6'h3F : gg_out[5:0];
	    formatted_pixel[4:0]   <= bb_out[5] ? 5'h1F : bb_out[4:0];
	  end else begin
	    formatted_pixel[15:11] <= final_color[19][RED][7:3];
	    formatted_pixel[10:5]  <= final_color[19][GREEN][7:2];
	    formatted_pixel[4:0]   <= final_color[19][BLUE][7:3];
	  end
	end

	// 1555 - 16bpp Format
	4'b01xx: begin
          x_out <= {x_pipe[19], 1'b0};
	  formatted_pixel[31:16] <= 16'h0000;
	  formatted_pixel[15]    <= final_alpha[19][7];
	  if (dither_op) begin
	    formatted_pixel[14:10] <= rr_out[5] ? 5'h1F : rr_out[4:0];
	    formatted_pixel[9:5]   <= gg_out[6] ? 5'h1F : gg_out[5:1];
	    formatted_pixel[4:0]   <= bb_out[5] ? 5'h1F : bb_out[4:0];
	  end else begin
	    formatted_pixel[14:10] <= final_color[19][RED][7:3];
	    formatted_pixel[9:5]   <= final_color[19][GREEN][7:3];
	    formatted_pixel[4:0]   <= final_color[19][BLUE][7:3];
	  end
	end
	
	// 8bpp Indexed (332) Format
	4'b0011: begin
          x_out <= x_pipe[19];
	  formatted_pixel[31:8] = 24'h000000;
	  if (dither_op) begin
	    formatted_pixel[7:5] <= rr_out[3] ? 3'h7 : rr_out[4:2];
	    formatted_pixel[4:2] <= gg_out[3] ? 3'h7 : gg_out[5:3];
	    formatted_pixel[1:0] <= bb_out[2] ? 2'h3 : bb_out[4:3];
	  end else begin
	    formatted_pixel[7:5] <= final_color[19][RED][7:5];
	    formatted_pixel[4:2] <= final_color[19][GREEN][7:5];
	    formatted_pixel[1:0] <= final_color[19][BLUE][7:6];
	  end
	end
	
	// 8bpp (blue channel) Format
	4'b0010: begin
          x_out <= x_pipe[19];
	  formatted_pixel <= dither_op ? {24'h000000, bb_out[4:0], 3'b0} : final_color[19][BLUE];
	end

	// 32bpp ARGB Format
	default: begin
          x_out <= {x_pipe[19], 2'b00};
	  formatted_pixel <= (dither_op) ? 
			     {
			     // rr_out[4:0], 3'b0, 
			     // gg_out[5:0], 2'b0, 
			     // bb_out[4:0], 3'b0
			     final_alpha[19], 
	    		     final_color[19][RED],
	    		     final_color[19][GREEN],
	    		     final_color[19][BLUE]
			     } :
			     {
			     final_alpha[19], 
			     final_color[19][RED],
			     final_color[19][GREEN], 
			     final_color[19][BLUE]
			     };
	end
      endcase
      pc_valid    <= (pipe_valid[18] & ~clip_pipe[19] & ~clip_key[18]) | (pipe_valid[18] & pipe_last[19]);
      y_out 	  <= y_pipe[19];
      pc_fg_bgn   <= pipe_fg_bgn[19];
      pc_last 	  <= pipe_last[19];
      pc_msk_last <= pipe_last_msk[19] | (pipe_last[19] & (clip_pipe[19] | clip_key[18]));
    end // else: !if(!de_rstn)

  function texel_key;
    input        key_en;  // Enable keying
    input        key_pol; // 0 = inclusive, 1 = exclusive
    input [23:0] texel;   // Texel to compare
    input [23:0] key_low; // Low key color
    input [23:0] key_hi;  // Low key color
    
    reg  	 gt_low;
    reg  	 eq_low;
    reg  	 lt_hi;
    reg  	 eq_hi;
    reg [2:0] 	 inclusive;

    integer 	 i;
    begin
      for (i = 0; i < 3; i = i + 1) begin
	gt_low = texel[i*8+:8] >  key_low[i*8+:8];
	eq_low = texel[i*8+:8] == key_low[i*8+:8];
	lt_hi  = texel[i*8+:8] <  key_hi[i*8+:8];
	eq_hi  = texel[i*8+:8] == key_hi[i*8+:8];
	inclusive[i] = (gt_low | eq_low) & (lt_hi | eq_hi);
      end
      texel_key = key_en & (key_pol ? ~&inclusive : &inclusive);
    end
    
  endfunction // for
  
  /*
   * function dith4x4_3:
   * This function implements an ordered dither matrix, for converting 8-bit
   * pixels to 5-bit pixels.  It is a modification of a D4 Bayer matrix, as
   * described in Computer Graphics, Practices and Principles (Foley, Van Dam,
   * et. al.)  D4' is a standard D4 matrix (4-bit entries) with the LSB of each
   * entry truncated.
   * 
   * D4:
   *  0  8   2  10
   * 12  4  14   6
   *  3 11   1   9
   * 15  7  13   5
   * 
   * D4':
   * 0 4 1 5
   * 6 2 7 3
   * 1 5 0 4
   * 7 3 6 2
   * 
   */
  function [2:0] dith4x4_3;
    input [1:0] x;
    input [1:0] y;
    begin
      case ({y,x})
	4'b00_00: dith4x4_3 = 0;	// 0/8 = 0;
	4'b00_01: dith4x4_3 = 4;	// 4/8 = 0.5;
	4'b00_10: dith4x4_3 = 1;	// 1/8 = 0.125;
	4'b00_11: dith4x4_3 = 5;	// 5/8 = 0.625;
	4'b01_00: dith4x4_3 = 6;	// 6/8 = 0.75;
	4'b01_01: dith4x4_3 = 2;	// 2/8 = 0.25;
	4'b01_10: dith4x4_3 = 7;	// 7/8 = 0.875;
	4'b01_11: dith4x4_3 = 3;	// 3/8 = 0.375;
	4'b10_00: dith4x4_3 = 1;	// 1/8 = 0.125;
	4'b10_01: dith4x4_3 = 5;	// 5/8 = 0.625;
	4'b10_10: dith4x4_3 = 0;	// 0/8 = 0;
	4'b10_11: dith4x4_3 = 4;	// 4/8 = 0.5;
	4'b11_00: dith4x4_3 = 7;	// 7/8 = 0.875;
	4'b11_01: dith4x4_3 = 3;	// 3/8 = 0.375;
	4'b11_10: dith4x4_3 = 6;	// 6/8 = 0.75;
	4'b11_11: dith4x4_3 = 2;	// 2/8 = 0.25;
      endcase // case ({y,x})
    end
  endfunction // dith4x4_3


  /*
   * function dith2x2_2:
   * This function implements an ordered dither matrix, for converting 8-bit
   * pixels to 6-bit pixels.  It is a standard D2 Bayer matrix, as
   * described in Computer Graphics, Practices and Principles (Foley, Van Dam,
   * et. al.)
   * 
   * D2:
   * 0 2
   * 3 1
   * 
   */
  function [1:0] dith2x2_2;
    input  x;
    input  y;
    begin
      case ({y,x})
	2'b0_0: dith2x2_2 = 0;		// 0/4 = 0;
	2'b0_1: dith2x2_2 = 2;		// 2/4 = 0.4;
	2'b1_0: dith2x2_2 = 1;		// 1/4 = 0.25;
	2'b1_1: dith2x2_2 = 3;		// 3/4 = 0/75;
      endcase // case ({y,x})
    end
  endfunction // dith4x4_3

endmodule
  
