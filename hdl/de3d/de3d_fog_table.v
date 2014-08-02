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
//  Title       :  Graphics core top level
//  File        :  graph_core.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  Fog table is the actual latch based cache which stores the fog values
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

`timescale 1ns / 10ps

module de3d_fog_table
  (
   input 	 select, // Cache selector
   input 	 hb_wstrb, // write strobe into fog table
   input [6:2] 	 hb_addr, // Address into fog table
   input [7:0] 	 hb_ben, // Byte enables into the table
   input [31:0]  hb_din, // data into the fog table
   input [5:0] 	 z_low, // Low lookup value
   input [5:0] 	 z_hi, // high lookup value

   output [31:0] hb_dout, // data from the fog table
   output [7:0]  low_factor, // Low fog factor
   output [7:0]  high_factor, // High fog factor
   output [7:0]  fog64		// The final fog entry in the table
   );
  
  reg [7:0] 	 low_factor;
  reg [7:0] 	 high_factor;
  
  reg [7:0] 	 fog0,	fog1,	/* Fog values for the table		*/
		 fog2,	fog3,
		 fog4,	fog5,
		 fog6,	fog7,
		 fog8,	fog9,
		 fog10,	fog11,
		 fog12,	fog13,
		 fog14,	fog15,
		 fog16,	fog17,
		 fog18,	fog19,
		 fog20,	fog21,
		 fog22,	fog23,
		 fog24,	fog25,
		 fog26,	fog27,
		 fog28,	fog29,
		 fog30,	fog31,
		 fog32,	fog33,
		 fog34,	fog35,
		 fog36,	fog37,
		 fog38,	fog39,
		 fog40,	fog41,
		 fog42,	fog43,
		 fog44,	fog45,
		 fog46,	fog47,
		 fog48,	fog49,
		 fog50,	fog51,
		 fog52,	fog53,
		 fog54,	fog55,
		 fog56,	fog57,
		 fog58,	fog59,
		 fog60,	fog61,
		 fog62,	fog63,
		 fog64;		/* Upper fog register			*/
  
  reg [31:0] 	 hb_dout;	/* register assignment for dout		*/
  
  /************************************************************************/
  /* Fog Table writes							*/
  /************************************************************************/
  always @* begin
    if (select && hb_wstrb)
      casex (hb_addr[6:2]) /* synopsys full_case parallel_case */
	5'b00000: begin
    	  if (!hb_ben[0]) fog0 = hb_din[7:0];
    	  if (!hb_ben[1]) fog1 = hb_din[15:8];
    	  if (!hb_ben[2]) fog2 = hb_din[23:16];
    	  if (!hb_ben[3]) fog3 = hb_din[31:24];
	end	
	5'b00001: begin
    	  if (!hb_ben[4]) fog4 = hb_din[7:0];
    	  if (!hb_ben[5]) fog5 = hb_din[15:8];
    	  if (!hb_ben[6]) fog6 = hb_din[23:16];
    	  if (!hb_ben[7]) fog7 = hb_din[31:24];
	end
	5'b00010: begin
    	  if (!hb_ben[0]) fog8 = hb_din[7:0];
    	  if (!hb_ben[1]) fog9 = hb_din[15:8];
    	  if (!hb_ben[2]) fog10 = hb_din[23:16];
    	  if (!hb_ben[3]) fog11 = hb_din[31:24];
	end	
	5'b00011: begin
    	  if (!hb_ben[4]) fog12 = hb_din[7:0];
    	  if (!hb_ben[5]) fog13 = hb_din[15:8];
    	  if (!hb_ben[6]) fog14 = hb_din[23:16];
    	  if (!hb_ben[7]) fog15 = hb_din[31:24];
	end
	5'b00100: begin
    	  if (!hb_ben[0]) fog16 = hb_din[7:0];
    	  if (!hb_ben[1]) fog17 = hb_din[15:8];
    	  if (!hb_ben[2]) fog18 = hb_din[23:16];
    	  if (!hb_ben[3]) fog19 = hb_din[31:24];
	end	
	5'b00101: begin
    	  if (!hb_ben[4]) fog20 = hb_din[7:0];
    	  if (!hb_ben[5]) fog21 = hb_din[15:8];
    	  if (!hb_ben[6]) fog22 = hb_din[23:16];
    	  if (!hb_ben[7]) fog23 = hb_din[31:24];
	end
	5'b00110: begin
    	  if (!hb_ben[0]) fog24 = hb_din[7:0];
    	  if (!hb_ben[1]) fog25 = hb_din[15:8];
    	  if (!hb_ben[2]) fog26 = hb_din[23:16];
    	  if (!hb_ben[3]) fog27 = hb_din[31:24];
	end	
	5'b00111: begin
    	  if (!hb_ben[4]) fog28 = hb_din[7:0];
    	  if (!hb_ben[5]) fog29 = hb_din[15:8];
    	  if (!hb_ben[6]) fog30 = hb_din[23:16];
    	  if (!hb_ben[7]) fog31 = hb_din[31:24];
	end
	5'b01000: begin
    	  if (!hb_ben[0]) fog32 = hb_din[7:0];
    	  if (!hb_ben[1]) fog33 = hb_din[15:8];
    	  if (!hb_ben[2]) fog34 = hb_din[23:16];
    	  if (!hb_ben[3]) fog35 = hb_din[31:24];
	end	
	5'b01001: begin
    	  if (!hb_ben[4]) fog36 = hb_din[7:0];
    	  if (!hb_ben[5]) fog37 = hb_din[15:8];
    	  if (!hb_ben[6]) fog38 = hb_din[23:16];
    	  if (!hb_ben[7]) fog39 = hb_din[31:24];
	end
	5'b01010: begin
    	  if (!hb_ben[0]) fog40 = hb_din[7:0];
    	  if (!hb_ben[1]) fog41 = hb_din[15:8];
    	  if (!hb_ben[2]) fog42 = hb_din[23:16];
    	  if (!hb_ben[3]) fog43 = hb_din[31:24];
	end	
	5'b01011: begin
    	  if (!hb_ben[4]) fog44 = hb_din[7:0];
    	  if (!hb_ben[5]) fog45 = hb_din[15:8];
    	  if (!hb_ben[6]) fog46 = hb_din[23:16];
    	  if (!hb_ben[7]) fog47 = hb_din[31:24];
	end
	5'b01100: begin
    	  if (!hb_ben[0]) fog48 = hb_din[7:0];
    	  if (!hb_ben[1]) fog49 = hb_din[15:8];
    	  if (!hb_ben[2]) fog50 = hb_din[23:16];
    	  if (!hb_ben[3]) fog51 = hb_din[31:24];
	end	
	5'b01101: begin
    	  if (!hb_ben[4]) fog52 = hb_din[7:0];
    	  if (!hb_ben[5]) fog53 = hb_din[15:8];
    	  if (!hb_ben[6]) fog54 = hb_din[23:16];
    	  if (!hb_ben[7]) fog55 = hb_din[31:24];
	end
	5'b01110: begin
    	  if (!hb_ben[0]) fog56 = hb_din[7:0];
    	  if (!hb_ben[1]) fog57 = hb_din[15:8];
    	  if (!hb_ben[2]) fog58 = hb_din[23:16];
    	  if (!hb_ben[3]) fog59 = hb_din[31:24];
	end	
	5'b01111: begin
    	  if (!hb_ben[4]) fog60 = hb_din[7:0];
    	  if (!hb_ben[5]) fog61 = hb_din[15:8];
    	  if (!hb_ben[6]) fog62 = hb_din[23:16];
    	  if (!hb_ben[7]) fog63 = hb_din[31:24];
	end
	5'b1xxxx: if (!hb_ben[0]) fog64 = hb_din[7:0];
      endcase
  end
  
  /************************************************************************/
  /* Fog Table readback							*/
  /************************************************************************/
  always @* begin
    if (select)
      case (hb_addr[6:2]) /* synopsys full_case parallel_case */
	5'b00000: hb_dout = {fog3, fog2, fog1, fog0};
	5'b00001: hb_dout = {fog7, fog6, fog5, fog4};
	5'b00010: hb_dout = {fog11, fog10, fog9, fog8};
	5'b00011: hb_dout = {fog15, fog14, fog13, fog12};
	5'b00100: hb_dout = {fog19, fog18, fog17, fog16};
	5'b00101: hb_dout = {fog23, fog22, fog21, fog20};
	5'b00110: hb_dout = {fog27, fog26, fog25, fog24};
	5'b00111: hb_dout = {fog31, fog30, fog29, fog28};
	5'b01000: hb_dout = {fog35, fog34, fog33, fog32};
	5'b01001: hb_dout = {fog39, fog38, fog37, fog36};
	5'b01010: hb_dout = {fog43, fog42, fog41, fog40};
	5'b01011: hb_dout = {fog47, fog46, fog45, fog44};
	5'b01100: hb_dout = {fog51, fog50, fog49, fog48};
	5'b01101: hb_dout = {fog55, fog54, fog53, fog52};
	5'b01110: hb_dout = {fog59, fog58, fog57, fog56};
	5'b01111: hb_dout = {fog63, fog62, fog61, fog60};
	default: hb_dout = {24'b0, fog64};
      endcase
    else hb_dout = 'b0;
  end
  
  always @*
    case (z_low) /* synopsys full_case parallel_case */
      6'd0: low_factor = fog0;
      6'd1: low_factor = fog1;
      6'd2: low_factor = fog2;
      6'd3: low_factor = fog3;
      6'd4: low_factor = fog4;
      6'd5: low_factor = fog5;
      6'd6: low_factor = fog6;
      6'd7: low_factor = fog7;
      6'd8: low_factor = fog8;
      6'd9: low_factor = fog9;
      6'd10: low_factor = fog10;
      6'd11: low_factor = fog11;
      6'd12: low_factor = fog12;
      6'd13: low_factor = fog13;
      6'd14: low_factor = fog14;
      6'd15: low_factor = fog15;
      6'd16: low_factor = fog16;
      6'd17: low_factor = fog17;
      6'd18: low_factor = fog18;
      6'd19: low_factor = fog19;
      6'd20: low_factor = fog20;
      6'd21: low_factor = fog21;
      6'd22: low_factor = fog22;
      6'd23: low_factor = fog23;
      6'd24: low_factor = fog24;
      6'd25: low_factor = fog25;
      6'd26: low_factor = fog26;
      6'd27: low_factor = fog27;
      6'd28: low_factor = fog28;
      6'd29: low_factor = fog29;
      6'd30: low_factor = fog30;
      6'd31: low_factor = fog31;
      6'd32: low_factor = fog32;
      6'd33: low_factor = fog33;
      6'd34: low_factor = fog34;
      6'd35: low_factor = fog35;
      6'd36: low_factor = fog36;
      6'd37: low_factor = fog37;
      6'd38: low_factor = fog38;
      6'd39: low_factor = fog39;
      6'd40: low_factor = fog40;
      6'd41: low_factor = fog41;
      6'd42: low_factor = fog42;
      6'd43: low_factor = fog43;
      6'd44: low_factor = fog44;
      6'd45: low_factor = fog45;
      6'd46: low_factor = fog46;
      6'd47: low_factor = fog47;
      6'd48: low_factor = fog48;
      6'd49: low_factor = fog49;
      6'd50: low_factor = fog50;
      6'd51: low_factor = fog51;
      6'd52: low_factor = fog52;
      6'd53: low_factor = fog53;
      6'd54: low_factor = fog54;
      6'd55: low_factor = fog55;
      6'd56: low_factor = fog56;
      6'd57: low_factor = fog57;
      6'd58: low_factor = fog58;
      6'd59: low_factor = fog59;
      6'd60: low_factor = fog60;
      6'd61: low_factor = fog61;
      6'd62: low_factor = fog62;
      6'd63: low_factor = fog63;
    endcase
  
  
  always @*
    case (z_hi) /* synopsys full_case parallel_case */
      6'd0: high_factor = fog0;
      6'd1: high_factor = fog1;
      6'd2: high_factor = fog2;
      6'd3: high_factor = fog3;
      6'd4: high_factor = fog4;
      6'd5: high_factor = fog5;
      6'd6: high_factor = fog6;
      6'd7: high_factor = fog7;
      6'd8: high_factor = fog8;
      6'd9: high_factor = fog9;
      6'd10: high_factor = fog10;
      6'd11: high_factor = fog11;
      6'd12: high_factor = fog12;
      6'd13: high_factor = fog13;
      6'd14: high_factor = fog14;
      6'd15: high_factor = fog15;
      6'd16: high_factor = fog16;
      6'd17: high_factor = fog17;
      6'd18: high_factor = fog18;
      6'd19: high_factor = fog19;
      6'd20: high_factor = fog20;
      6'd21: high_factor = fog21;
      6'd22: high_factor = fog22;
      6'd23: high_factor = fog23;
      6'd24: high_factor = fog24;
      6'd25: high_factor = fog25;
      6'd26: high_factor = fog26;
      6'd27: high_factor = fog27;
      6'd28: high_factor = fog28;
      6'd29: high_factor = fog29;
      6'd30: high_factor = fog30;
      6'd31: high_factor = fog31;
      6'd32: high_factor = fog32;
      6'd33: high_factor = fog33;
      6'd34: high_factor = fog34;
      6'd35: high_factor = fog35;
      6'd36: high_factor = fog36;
      6'd37: high_factor = fog37;
      6'd38: high_factor = fog38;
      6'd39: high_factor = fog39;
      6'd40: high_factor = fog40;
      6'd41: high_factor = fog41;
      6'd42: high_factor = fog42;
      6'd43: high_factor = fog43;
      6'd44: high_factor = fog44;
      6'd45: high_factor = fog45;
      6'd46: high_factor = fog46;
      6'd47: high_factor = fog47;
      6'd48: high_factor = fog48;
      6'd49: high_factor = fog49;
      6'd50: high_factor = fog50;
      6'd51: high_factor = fog51;
      6'd52: high_factor = fog52;
      6'd53: high_factor = fog53;
      6'd54: high_factor = fog54;
      6'd55: high_factor = fog55;
      6'd56: high_factor = fog56;
      6'd57: high_factor = fog57;
      6'd58: high_factor = fog58;
      6'd59: high_factor = fog59;
      6'd60: high_factor = fog60;
      6'd61: high_factor = fog61;
      6'd62: high_factor = fog62;
      6'd63: high_factor = fog63;
    endcase
  
endmodule
