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
//  Title       :  
//  File        :  
//  Author      :  Jim MacLeod
//  Created     :  01-Dec-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
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

`timescale 1 ps / 1 ps

module des_comp_gen_fx_color
  (
   input 	       clk,
   input 	       rstn,
   input signed [31:0] dx_fx, // 16.16
   input signed [31:0] dy_fx, // 16.16
   input [95:0]        cmp_i,

   output [7:0]        curr_i
   );

  reg signed [57:0]    ix;
  reg signed [57:0]    iy;
  reg signed [57:0]    ixy;
  reg signed [19:0]    curr;
  
  assign curr_i = (curr[19]) ? 8'h00 :	// Under flow.
		  (curr[18]) ? 8'hff :	// Over flow.
		  curr[17:10];		// Normal.
  
  wire [17:0] 	       sp_fx;
  wire signed [25:0]   idx_fx;
  wire signed [25:0]   idy_fx;
  
  assign sp_fx  = flt_fx_8p10(cmp_i[95:64]);
  assign idx_fx = flt_fx_16p10(cmp_i[63:32]);
  assign idy_fx = flt_fx_16p10(cmp_i[31:0]);
  
  always @(posedge clk) begin
    ix        <= dx_fx * idx_fx;			// 16.16 * 16.10 = 32.26
    iy        <= dy_fx * idy_fx;			// 16.16 * 16.10 = 32.26
    ixy       <= iy + ix;				// 32.26 + 32.26 = 32.26
    curr      <= ixy[35:16] + {2'b00, sp_fx};	// 10.10 + 10.10 = 10.10
  end
  
  //////////////////////////////////////////////////////////////////
  // Float to fixed converts floating point numbers to 16.16 sign
  //
  //
  function [25:0] flt_fx_16p10;
    input	[31:0]	fp_in;         // Floating point in IEEE fmt
    //  16.10, Color.
    reg [7:0] 		bias_exp;       /* Real exponent -127 - 128     */
    reg [7:0] 		bias_exp2;      /* Real exponent 2's comp       */
    reg [47:0] 		bias_mant;      /* mantissa expanded to 16.16 fmt */
    reg [47:0] 		int_fixed_out;
    reg [31:0] 		fixed_out;
    begin
      bias_mant = {25'h0001, fp_in[22:0]};
      bias_exp = fp_in[30:23] - 8'd127;
      bias_exp2 = ~bias_exp + 8'h1;
      // infinity or NaN - Don't do anything special, will overflow
      // zero condition
      if (fp_in[30:0] == 31'b0) int_fixed_out = 0;
      // negative exponent
      else if (bias_exp[7]) int_fixed_out = bias_mant >> bias_exp2;
      // positive exponent
      else int_fixed_out = bias_mant << bias_exp;
      fixed_out = int_fixed_out[38:13];
      flt_fx_16p10 = (fp_in[31]) ? ~fixed_out[25:0] + 26'h1 : fixed_out[25:0];
    end
  endfunction
  
  function [17:0] flt_fx_8p10;
    input	[31:0]	fp_in;         // Floating point in IEEE fmt
    //  16.10, Color.
    reg [7:0] 		bias_exp;       /* Real exponent -127 - 128     */
    reg [7:0] 		bias_exp2;      /* Real exponent 2's comp       */
    reg [47:0] 		bias_mant;      /* mantissa expanded to 16.16 fmt */
    reg [47:0] 		int_fixed_out;
    reg [31:0] 		fixed_out;
    begin
      bias_mant = {25'h0001, fp_in[22:0]};
      bias_exp = fp_in[30:23] - 8'd127;
      bias_exp2 = ~bias_exp + 8'h1;
      // infinity or NaN - Don't do anything special, will overflow
      // zero condition
      if (fp_in[30:0] == 31'b0) int_fixed_out = 0;
      // negative exponent
      else if (bias_exp[7]) int_fixed_out = bias_mant >> bias_exp2;
      // positive exponent
      else int_fixed_out = bias_mant << bias_exp;
      fixed_out = int_fixed_out[31:13];
      flt_fx_8p10 = (fp_in[31]) ? ~fixed_out[17:0] + 18'h1 : fixed_out[17:0];
    end
  endfunction
  
  
endmodule
