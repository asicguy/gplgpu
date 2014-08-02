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
//
// ALGORITHM:
// This single-precision floating point reciprocal circuit
// implements an algorithm based on the Newton-Raphson 
// iteration.  The quadratically converging algorithm
// is: X[i+1] = X[i]*(2 - B*X[i]) where B is the original
// manitissa.  We can see that using a look-up table to
// provide 9 bits of precision for X[0] would require 2
// iterations to obtain the desired 23 bits of precision.
// IEEE rounding is then performed, the mantissa is
// normalized, and the exponent is calculated appropriately.
//
// IMPLEMENTATION NOTES:
// Since B is assumed to be a number such that 1 <= B < 2
// is true, the reciprocal (in this case X[2]) will be a
// number such that .5 < X[2] < 1 is true.  Notice that all
// X[2] will have an MSB of 1, so this MSB does not have to
// be explicitly stored in the look-up table.
// Another area/time saving technique that is utilized is
// the subtraction 2 - B*X[i] is the same as the two's
// complement operation of B*X[i].
// `timescale 1 ns / 10 ps

`timescale 1 ps / 1 ps

module flt_recip
   (
   input	 clk,
   input [31:0]	 denom,

   output [31:0] recip
   );

   wire [7:0]	 lutv;//Lookup Table Value
   
   flt_recip_rom u_flt_recip_rom
   	(
	.clk		(clk),
	.index		(denom[22:16]),
	.init_est	(lutv)
	);
   
   flt_recip_iter u_flt_recip_iter
      (
       .clk     (clk),
       .X0         (lutv),
       .denom      (denom),
       .recip      (recip)
       );
       
endmodule

module flt_recip_rom
  (
   input            clk,
   input      [6:0] index,
   output reg [7:0] init_est
   );

   always @(posedge clk) begin
      case (index) //synopsys full_case parallel_case
        7'h00: init_est <= 8'hff;
        7'h01: init_est <= 8'hfb;
        7'h02: init_est <= 8'hf7;
        7'h03: init_est <= 8'hf3;
        7'h04: init_est <= 8'hef;
        7'h05: init_est <= 8'heb;
        7'h06: init_est <= 8'he8;
        7'h07: init_est <= 8'he4;
        7'h08: init_est <= 8'he1;
        7'h09: init_est <= 8'hdd;
        7'h0a: init_est <= 8'hda;
        7'h0b: init_est <= 8'hd6;
        7'h0c: init_est <= 8'hd3;
        7'h0d: init_est <= 8'hd0;
        7'h0e: init_est <= 8'hcc;
        7'h0f: init_est <= 8'hc9;
        7'h10: init_est <= 8'hc6;
        7'h11: init_est <= 8'hc3;
        7'h12: init_est <= 8'hc0;
        7'h13: init_est <= 8'hbd;
        7'h14: init_est <= 8'hba;
        7'h15: init_est <= 8'hb7;
        7'h16: init_est <= 8'hb4;
        7'h17: init_est <= 8'hb1;
        7'h18: init_est <= 8'hae;
        7'h19: init_est <= 8'hab;
        7'h1a: init_est <= 8'ha9;
        7'h1b: init_est <= 8'ha6;
        7'h1c: init_est <= 8'ha3;
        7'h1d: init_est <= 8'ha1;
        7'h1e: init_est <= 8'h9e;
        7'h1f: init_est <= 8'h9b;
        7'h20: init_est <= 8'h99;
        7'h21: init_est <= 8'h96;
        7'h22: init_est <= 8'h94;
        7'h23: init_est <= 8'h91;
        7'h24: init_est <= 8'h8f;
        7'h25: init_est <= 8'h8c;
        7'h26: init_est <= 8'h8a;
        7'h27: init_est <= 8'h88;
        7'h28: init_est <= 8'h85;
        7'h29: init_est <= 8'h83;
        7'h2a: init_est <= 8'h81;
        7'h2b: init_est <= 8'h7f;
        7'h2c: init_est <= 8'h7c;
        7'h2d: init_est <= 8'h7a;
        7'h2e: init_est <= 8'h78;
        7'h2f: init_est <= 8'h76;
        7'h30: init_est <= 8'h74;
        7'h31: init_est <= 8'h72;
        7'h32: init_est <= 8'h70;
        7'h33: init_est <= 8'h6e;
        7'h34: init_est <= 8'h6c;
        7'h35: init_est <= 8'h6a;
        7'h36: init_est <= 8'h68;
        7'h37: init_est <= 8'h66;
        7'h38: init_est <= 8'h64;
        7'h39: init_est <= 8'h62;
        7'h3a: init_est <= 8'h60;
        7'h3b: init_est <= 8'h5e;
        7'h3c: init_est <= 8'h5c;
        7'h3d: init_est <= 8'h5a;
        7'h3e: init_est <= 8'h59;
        7'h3f: init_est <= 8'h57;
        7'h40: init_est <= 8'h55;
        7'h41: init_est <= 8'h53;
        7'h42: init_est <= 8'h51;
        7'h43: init_est <= 8'h50;
        7'h44: init_est <= 8'h4e;
        7'h45: init_est <= 8'h4c;
        7'h46: init_est <= 8'h4b;
        7'h47: init_est <= 8'h49;
        7'h48: init_est <= 8'h47;
        7'h49: init_est <= 8'h46;
        7'h4a: init_est <= 8'h44;
        7'h4b: init_est <= 8'h43;
        7'h4c: init_est <= 8'h41;
        7'h4d: init_est <= 8'h3f;
        7'h4e: init_est <= 8'h3e;
        7'h4f: init_est <= 8'h3c;
        7'h50: init_est <= 8'h3b;
        7'h51: init_est <= 8'h39;
        7'h52: init_est <= 8'h38;
        7'h53: init_est <= 8'h36;
        7'h54: init_est <= 8'h35;
        7'h55: init_est <= 8'h33;
        7'h56: init_est <= 8'h32;
        7'h57: init_est <= 8'h31;
        7'h58: init_est <= 8'h2f;
        7'h59: init_est <= 8'h2e;
        7'h5a: init_est <= 8'h2c;
        7'h5b: init_est <= 8'h2b;
        7'h5c: init_est <= 8'h2a;
        7'h5d: init_est <= 8'h28;
        7'h5e: init_est <= 8'h27;
        7'h5f: init_est <= 8'h26;
        7'h60: init_est <= 8'h24;
        7'h61: init_est <= 8'h23;
        7'h62: init_est <= 8'h22;
        7'h63: init_est <= 8'h21;
        7'h64: init_est <= 8'h1f;
        7'h65: init_est <= 8'h1e;
        7'h66: init_est <= 8'h1d;
        7'h67: init_est <= 8'h1c;
        7'h68: init_est <= 8'h1a;
        7'h69: init_est <= 8'h19;
        7'h6a: init_est <= 8'h18;
        7'h6b: init_est <= 8'h17;
        7'h6c: init_est <= 8'h16;
        7'h6d: init_est <= 8'h14;
        7'h6e: init_est <= 8'h13;
        7'h6f: init_est <= 8'h12;
        7'h70: init_est <= 8'h11;
        7'h71: init_est <= 8'h10;
        7'h72: init_est <= 8'h0f;
        7'h73: init_est <= 8'h0e;
        7'h74: init_est <= 8'h0d;
        7'h75: init_est <= 8'h0b;
        7'h76: init_est <= 8'h0a;
        7'h77: init_est <= 8'h09;
        7'h78: init_est <= 8'h08;
        7'h79: init_est <= 8'h07;
        7'h7a: init_est <= 8'h06;
        7'h7b: init_est <= 8'h05;
        7'h7c: init_est <= 8'h04;
        7'h7d: init_est <= 8'h03;
        7'h7e: init_est <= 8'h02;
        7'h7f: init_est <= 8'h01;
      endcase
   end
endmodule

module flt_recip_iter
   (
   input	 clk,
   input [7:0]	 X0,
   input [31:0]	 denom,
   output reg [31:0] recip
   );

   reg		 sign;
   reg [30:23]	 exp;
   reg [22:0]	 B;
      
   wire [24:0]	 round;
   reg  [32:0]	 mult1;
   wire [32:8]	 round_mult1;
   reg  [34:0]	 mult2;
   reg  [41:0]	 mult3;
   wire [25:0]	 round_mult3;
   reg  [43:0]	 mult4;
   wire [24:0]	 sub1;
   wire [25:0]	 sub2;
   
   reg		 sign1, sign1a, sign2, sign3;
   reg [30:23]	 exp1, exp1a, exp2, exp3;
   reg [7:0]	 X0_reg;
   wire [24:0]	 pipe1;
   reg [17:0]	 X1_reg;
   reg [25:0]	 pipe2;
   reg [22:0]	 B1;
   reg [22:0]	 B1a;
   wire [30:23]	 exp_after_norm;
   reg [23:0]	 round_after_norm;

   // See ded_recip.v for a complete explanation of
   // the algorithm used here.
   always @(posedge clk) begin
   	sign <= denom[31];
   	exp  <= denom[30:23];
   	B    <= denom[22:0];
   end

   //Iteration #1
   //Pipeline flow
   always @(posedge clk) begin
   	 mult1  <= ({1'b1,B} * {1'b1,X0});
	 // pipe1  <= sub1;
	 X0_reg <= X0;
	 sign1  <= sign;
	 exp1   <= 9'hFE - exp;
	 B1     <= B;
   end

   assign round_mult1 = mult1[32:8] + mult1[7];
   assign pipe1 =  ~round_mult1 + 1; //Same as 2 - round_mult1
   
   //Pipeline flow
   always @(posedge clk) begin
	 mult2  <= (pipe1 * {1'b1,X0_reg});
	 exp1a  <= exp1;
	 sign1a <= sign1;
	 B1a    <= B1;
   end

   //Iteration #2
   //Pipeline flow
   always @(posedge clk) begin
   	 mult3 <= ({1'b1,B1a} * mult2[33:16]);
	 sign2 <= sign1a;
	 exp2 <= exp1a;
	 X1_reg <= mult2[33:16];
   end

   // assign round_mult3 = mult3[40:15] + mult3[14];
   // assign sub2 = ~pipe2 + 1;//Same as 2 - pipe2
   assign sub2 = ~(mult3[40:15] + mult3[14]) + 1; //Same as 2 - pipe2

   //Pipeline flow
   always @(posedge clk) begin
	 sign3 <= sign2;
	 exp3  <= exp2;
   	 mult4 <= (X1_reg * sub2);
   end

   // IEEE rounding requires the use of the LSB, a guard 
   // bit, and a sticky bit. The guard bit is 1 bit less 
   // significant than the LSB, and the sticky bit is the 
   // logical OR of all bits less significant than the 
   // guard bit.  Rounding is performed by conditionally
   // adding 1 to the LSB if the guard bit is 1 and
   // either the LSB or the sticky bit is 1.
   // DISCREPANCY:  The previous implementation did not
   // do this, however, so this one won't either in order
   // to stay identical in function.  The way this
   // implementation works is that it's assumed that if
   // the guard bit is 1, so is the sticky bit, so you
   // can simply add the guard bit to the LSB.  I believe
   // that for single precision this yields identical
   // results as true IEEE rounding.
   // FINALLY:  In order to reduce the size of the later
   // arithmetic elements, some sacrifice in precision was
   // made.  Currently there is roughly an 8.5% error rate
   // of 1 LSB.  It is believed that this is still more
   // than enough precision for the specific application.
   //
   assign round = mult4[41:18] + mult4[17];

   //Calculate new exponent
   assign exp_after_norm = exp3 - !round[24];
   
   //Normalize and truncate mantissa
   always @(round) begin
      if (round[24]) begin //mantissa[23:0] is 1
	 round_after_norm <= round[24:1];
      end
      else begin           //mantissa[23:0] is between 1 and .5
	 round_after_norm <= round[23:0];
      end
   end
      
   //Pipeline flow
   always @(posedge clk) recip <= {sign2,exp_after_norm,round_after_norm[22:0]};

endmodule

