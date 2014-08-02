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
//  Title       :  LUT U
//  File        :  hbi_lut_u.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  YUV LUT U component
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
`timescale 1ns/10ps

  module hbi_lut_u
    (
     input            hb_clk,
     input [7:0]      lut_u_index,
     
     output reg [9:0] lut_u0_dout,
     output reg [9:0] lut_u1_dout
     );

  reg [7:0] index;
  
  always @(posedge hb_clk) begin
    case(lut_u_index) /* synopsys full_case parallel_case */
      8'd0:   lut_u0_dout <= 10'h244;
      8'd1:   lut_u0_dout <= 10'h248;
      8'd2:   lut_u0_dout <= 10'h24B;
      8'd3:   lut_u0_dout <= 10'h24F;
      8'd4:   lut_u0_dout <= 10'h252;
      8'd5:   lut_u0_dout <= 10'h256;
      8'd6:   lut_u0_dout <= 10'h259;
      8'd7:   lut_u0_dout <= 10'h25D;
      8'd8:   lut_u0_dout <= 10'h260;
      8'd9:   lut_u0_dout <= 10'h264;
      8'd10:  lut_u0_dout <= 10'h267;
      8'd11:  lut_u0_dout <= 10'h26A;
      8'd12:  lut_u0_dout <= 10'h26E;
      8'd13:  lut_u0_dout <= 10'h271;
      8'd14:  lut_u0_dout <= 10'h275;
      8'd15:  lut_u0_dout <= 10'h278;
      8'd16:  lut_u0_dout <= 10'h27C;
      8'd17:  lut_u0_dout <= 10'h27F;
      8'd18:  lut_u0_dout <= 10'h283;
      8'd19:  lut_u0_dout <= 10'h286;
      8'd20:  lut_u0_dout <= 10'h28A;
      8'd21:  lut_u0_dout <= 10'h28D;
      8'd22:  lut_u0_dout <= 10'h291;
      8'd23:  lut_u0_dout <= 10'h294;
      8'd24:  lut_u0_dout <= 10'h298;
      8'd25:  lut_u0_dout <= 10'h29B;
      8'd26:  lut_u0_dout <= 10'h29E;
      8'd27:  lut_u0_dout <= 10'h2A2;
      8'd28:  lut_u0_dout <= 10'h2A5;
      8'd29:  lut_u0_dout <= 10'h2A9;
      8'd30:  lut_u0_dout <= 10'h2AC;
      8'd31:  lut_u0_dout <= 10'h2B0;
      8'd32:  lut_u0_dout <= 10'h2B3;
      8'd33:  lut_u0_dout <= 10'h2B7;
      8'd34:  lut_u0_dout <= 10'h2BA;
      8'd35:  lut_u0_dout <= 10'h2BE;
      8'd36:  lut_u0_dout <= 10'h2C1;
      8'd37:  lut_u0_dout <= 10'h2C5;
      8'd38:  lut_u0_dout <= 10'h2C8;
      8'd39:  lut_u0_dout <= 10'h2CC;
      8'd40:  lut_u0_dout <= 10'h2CF;
      8'd41:  lut_u0_dout <= 10'h2D2;
      8'd42:  lut_u0_dout <= 10'h2D6;
      8'd43:  lut_u0_dout <= 10'h2D9;
      8'd44:  lut_u0_dout <= 10'h2DD;
      8'd45:  lut_u0_dout <= 10'h2E0;
      8'd46:  lut_u0_dout <= 10'h2E4;
      8'd47:  lut_u0_dout <= 10'h2E7;
      8'd48:  lut_u0_dout <= 10'h2EB;
      8'd49:  lut_u0_dout <= 10'h2EE;
      8'd50:  lut_u0_dout <= 10'h2F2;
      8'd51:  lut_u0_dout <= 10'h2F5;
      8'd52:  lut_u0_dout <= 10'h2F9;
      8'd53:  lut_u0_dout <= 10'h2FC;
      8'd54:  lut_u0_dout <= 10'h300;
      8'd55:  lut_u0_dout <= 10'h303;
      8'd56:  lut_u0_dout <= 10'h306;
      8'd57:  lut_u0_dout <= 10'h30A;
      8'd58:  lut_u0_dout <= 10'h30D;
      8'd59:  lut_u0_dout <= 10'h311;
      8'd60:  lut_u0_dout <= 10'h314;
      8'd61:  lut_u0_dout <= 10'h318;
      8'd62:  lut_u0_dout <= 10'h31B;
      8'd63:  lut_u0_dout <= 10'h31F;
      8'd64:  lut_u0_dout <= 10'h322;
      8'd65:  lut_u0_dout <= 10'h326;
      8'd66:  lut_u0_dout <= 10'h329;
      8'd67:  lut_u0_dout <= 10'h32D;
      8'd68:  lut_u0_dout <= 10'h330;
      8'd69:  lut_u0_dout <= 10'h334;
      8'd70:  lut_u0_dout <= 10'h337;
      8'd71:  lut_u0_dout <= 10'h33A;
      8'd72:  lut_u0_dout <= 10'h33E;
      8'd73:  lut_u0_dout <= 10'h341;
      8'd74:  lut_u0_dout <= 10'h345;
      8'd75:  lut_u0_dout <= 10'h348;
      8'd76:  lut_u0_dout <= 10'h34C;
      8'd77:  lut_u0_dout <= 10'h34F;
      8'd78:  lut_u0_dout <= 10'h353;
      8'd79:  lut_u0_dout <= 10'h356;
      8'd80:  lut_u0_dout <= 10'h35A;
      8'd81:  lut_u0_dout <= 10'h35D;
      8'd82:  lut_u0_dout <= 10'h361;
      8'd83:  lut_u0_dout <= 10'h364;
      8'd84:  lut_u0_dout <= 10'h367;
      8'd85:  lut_u0_dout <= 10'h36B;
      8'd86:  lut_u0_dout <= 10'h36E;
      8'd87:  lut_u0_dout <= 10'h372;
      8'd88:  lut_u0_dout <= 10'h375;
      8'd89:  lut_u0_dout <= 10'h379;
      8'd90:  lut_u0_dout <= 10'h37C;
      8'd91:  lut_u0_dout <= 10'h380;
      8'd92:  lut_u0_dout <= 10'h383;
      8'd93:  lut_u0_dout <= 10'h387;
      8'd94:  lut_u0_dout <= 10'h38A;
      8'd95:  lut_u0_dout <= 10'h38E;
      8'd96:  lut_u0_dout <= 10'h391;
      8'd97:  lut_u0_dout <= 10'h395;
      8'd98:  lut_u0_dout <= 10'h398;
      8'd99:  lut_u0_dout <= 10'h39B;
      8'd100: lut_u0_dout <= 10'h39F;
      8'd101: lut_u0_dout <= 10'h3A2;
      8'd102: lut_u0_dout <= 10'h3A6;
      8'd103: lut_u0_dout <= 10'h3A9;
      8'd104: lut_u0_dout <= 10'h3AD;
      8'd105: lut_u0_dout <= 10'h3B0;
      8'd106: lut_u0_dout <= 10'h3B4;
      8'd107: lut_u0_dout <= 10'h3B7;
      8'd108: lut_u0_dout <= 10'h3BB;
      8'd109: lut_u0_dout <= 10'h3BE;
      8'd110: lut_u0_dout <= 10'h3C2;
      8'd111: lut_u0_dout <= 10'h3C5;
      8'd112: lut_u0_dout <= 10'h3C9;
      8'd113: lut_u0_dout <= 10'h3CC;
      8'd114: lut_u0_dout <= 10'h3CF;
      8'd115: lut_u0_dout <= 10'h3D3;
      8'd116: lut_u0_dout <= 10'h3D6;
      8'd117: lut_u0_dout <= 10'h3DA;
      8'd118: lut_u0_dout <= 10'h3DD;
      8'd119: lut_u0_dout <= 10'h3E1;
      8'd120: lut_u0_dout <= 10'h3E4;
      8'd121: lut_u0_dout <= 10'h3E8;
      8'd122: lut_u0_dout <= 10'h3EB;
      8'd123: lut_u0_dout <= 10'h3EF;
      8'd124: lut_u0_dout <= 10'h3F2;
      8'd125: lut_u0_dout <= 10'h3F6;
      8'd126: lut_u0_dout <= 10'h3F9;
      8'd127: lut_u0_dout <= 10'h3FD;
      8'd128: lut_u0_dout <= 10'h000;
      8'd129: lut_u0_dout <= 10'h003;
      8'd130: lut_u0_dout <= 10'h007;
      8'd131: lut_u0_dout <= 10'h00A;
      8'd132: lut_u0_dout <= 10'h00E;
      8'd133: lut_u0_dout <= 10'h011;
      8'd134: lut_u0_dout <= 10'h015;
      8'd135: lut_u0_dout <= 10'h018;
      8'd136: lut_u0_dout <= 10'h01C;
      8'd137: lut_u0_dout <= 10'h01F;
      8'd138: lut_u0_dout <= 10'h023;
      8'd139: lut_u0_dout <= 10'h026;
      8'd140: lut_u0_dout <= 10'h02A;
      8'd141: lut_u0_dout <= 10'h02D;
      8'd142: lut_u0_dout <= 10'h031;
      8'd143: lut_u0_dout <= 10'h034;
      8'd144: lut_u0_dout <= 10'h037;
      8'd145: lut_u0_dout <= 10'h03B;
      8'd146: lut_u0_dout <= 10'h03E;
      8'd147: lut_u0_dout <= 10'h042;
      8'd148: lut_u0_dout <= 10'h045;
      8'd149: lut_u0_dout <= 10'h049;
      8'd150: lut_u0_dout <= 10'h04C;
      8'd151: lut_u0_dout <= 10'h050;
      8'd152: lut_u0_dout <= 10'h053;
      8'd153: lut_u0_dout <= 10'h057;
      8'd154: lut_u0_dout <= 10'h05A;
      8'd155: lut_u0_dout <= 10'h05E;
      8'd156: lut_u0_dout <= 10'h061;
      8'd157: lut_u0_dout <= 10'h065;
      8'd158: lut_u0_dout <= 10'h068;
      8'd159: lut_u0_dout <= 10'h06B;
      8'd160: lut_u0_dout <= 10'h06F;
      8'd161: lut_u0_dout <= 10'h072;
      8'd162: lut_u0_dout <= 10'h076;
      8'd163: lut_u0_dout <= 10'h079;
      8'd164: lut_u0_dout <= 10'h07D;
      8'd165: lut_u0_dout <= 10'h080;
      8'd166: lut_u0_dout <= 10'h084;
      8'd167: lut_u0_dout <= 10'h087;
      8'd168: lut_u0_dout <= 10'h08B;
      8'd169: lut_u0_dout <= 10'h08E;
      8'd170: lut_u0_dout <= 10'h092;
      8'd171: lut_u0_dout <= 10'h095;
      8'd172: lut_u0_dout <= 10'h099;
      8'd173: lut_u0_dout <= 10'h09C;
      8'd174: lut_u0_dout <= 10'h09F;
      8'd175: lut_u0_dout <= 10'h0A3;
      8'd176: lut_u0_dout <= 10'h0A6;
      8'd177: lut_u0_dout <= 10'h0AA;
      8'd178: lut_u0_dout <= 10'h0AD;
      8'd179: lut_u0_dout <= 10'h0B1;
      8'd180: lut_u0_dout <= 10'h0B4;
      8'd181: lut_u0_dout <= 10'h0B8;
      8'd182: lut_u0_dout <= 10'h0BB;
      8'd183: lut_u0_dout <= 10'h0BF;
      8'd184: lut_u0_dout <= 10'h0C2;
      8'd185: lut_u0_dout <= 10'h0C6;
      8'd186: lut_u0_dout <= 10'h0C9;
      8'd187: lut_u0_dout <= 10'h0CC;
      8'd188: lut_u0_dout <= 10'h0D0;
      8'd189: lut_u0_dout <= 10'h0D3;
      8'd190: lut_u0_dout <= 10'h0D7;
      8'd191: lut_u0_dout <= 10'h0DA;
      8'd192: lut_u0_dout <= 10'h0DE;
      8'd193: lut_u0_dout <= 10'h0E1;
      8'd194: lut_u0_dout <= 10'h0E5;
      8'd195: lut_u0_dout <= 10'h0E8;
      8'd196: lut_u0_dout <= 10'h0EC;
      8'd197: lut_u0_dout <= 10'h0EF;
      8'd198: lut_u0_dout <= 10'h0F3;
      8'd199: lut_u0_dout <= 10'h0F6;
      8'd200: lut_u0_dout <= 10'h0FA;
      8'd201: lut_u0_dout <= 10'h0FD;
      8'd202: lut_u0_dout <= 10'h100;
      8'd203: lut_u0_dout <= 10'h104;
      8'd204: lut_u0_dout <= 10'h107;
      8'd205: lut_u0_dout <= 10'h10B;
      8'd206: lut_u0_dout <= 10'h10E;
      8'd207: lut_u0_dout <= 10'h112;
      8'd208: lut_u0_dout <= 10'h115;
      8'd209: lut_u0_dout <= 10'h119;
      8'd210: lut_u0_dout <= 10'h11C;
      8'd211: lut_u0_dout <= 10'h120;
      8'd212: lut_u0_dout <= 10'h123;
      8'd213: lut_u0_dout <= 10'h127;
      8'd214: lut_u0_dout <= 10'h12A;
      8'd215: lut_u0_dout <= 10'h12E;
      8'd216: lut_u0_dout <= 10'h131;
      8'd217: lut_u0_dout <= 10'h134;
      8'd218: lut_u0_dout <= 10'h138;
      8'd219: lut_u0_dout <= 10'h13B;
      8'd220: lut_u0_dout <= 10'h13F;
      8'd221: lut_u0_dout <= 10'h142;
      8'd222: lut_u0_dout <= 10'h146;
      8'd223: lut_u0_dout <= 10'h149;
      8'd224: lut_u0_dout <= 10'h14D;
      8'd225: lut_u0_dout <= 10'h150;
      8'd226: lut_u0_dout <= 10'h154;
      8'd227: lut_u0_dout <= 10'h157;
      8'd228: lut_u0_dout <= 10'h15B;
      8'd229: lut_u0_dout <= 10'h15E;
      8'd230: lut_u0_dout <= 10'h162;
      8'd231: lut_u0_dout <= 10'h165;
      8'd232: lut_u0_dout <= 10'h168;
      8'd233: lut_u0_dout <= 10'h16C;
      8'd234: lut_u0_dout <= 10'h16F;
      8'd235: lut_u0_dout <= 10'h173;
      8'd236: lut_u0_dout <= 10'h176;
      8'd237: lut_u0_dout <= 10'h17A;
      8'd238: lut_u0_dout <= 10'h17D;
      8'd239: lut_u0_dout <= 10'h181;
      8'd240: lut_u0_dout <= 10'h184;
      8'd241: lut_u0_dout <= 10'h188;
      8'd242: lut_u0_dout <= 10'h18B;
      8'd243: lut_u0_dout <= 10'h18F;
      8'd244: lut_u0_dout <= 10'h192;
      8'd245: lut_u0_dout <= 10'h196;
      8'd246: lut_u0_dout <= 10'h199;
      8'd247: lut_u0_dout <= 10'h19C;
      8'd248: lut_u0_dout <= 10'h1A0;
      8'd249: lut_u0_dout <= 10'h1A3;
      8'd250: lut_u0_dout <= 10'h1A7;
      8'd251: lut_u0_dout <= 10'h1AA;
      8'd252: lut_u0_dout <= 10'h1AE;
      8'd253: lut_u0_dout <= 10'h1B1;
      8'd254: lut_u0_dout <= 10'h1B5;
      8'd255: lut_u0_dout <= 10'h1B8;
    endcase
    case(lut_u_index) /* synopsys full_case parallel_case */
      8'd0:   lut_u1_dout <= 10'h353;
      8'd1:   lut_u1_dout <= 10'h355;
      8'd2:   lut_u1_dout <= 10'h356;
      8'd3:   lut_u1_dout <= 10'h357;
      8'd4:   lut_u1_dout <= 10'h359;
      8'd5:   lut_u1_dout <= 10'h35A;
      8'd6:   lut_u1_dout <= 10'h35C;
      8'd7:   lut_u1_dout <= 10'h35D;
      8'd8:   lut_u1_dout <= 10'h35E;
      8'd9:   lut_u1_dout <= 10'h360;
      8'd10:  lut_u1_dout <= 10'h361;
      8'd11:  lut_u1_dout <= 10'h362;
      8'd12:  lut_u1_dout <= 10'h364;
      8'd13:  lut_u1_dout <= 10'h365;
      8'd14:  lut_u1_dout <= 10'h366;
      8'd15:  lut_u1_dout <= 10'h368;
      8'd16:  lut_u1_dout <= 10'h369;
      8'd17:  lut_u1_dout <= 10'h36A;
      8'd18:  lut_u1_dout <= 10'h36C;
      8'd19:  lut_u1_dout <= 10'h36D;
      8'd20:  lut_u1_dout <= 10'h36E;
      8'd21:  lut_u1_dout <= 10'h370;
      8'd22:  lut_u1_dout <= 10'h371;
      8'd23:  lut_u1_dout <= 10'h372;
      8'd24:  lut_u1_dout <= 10'h374;
      8'd25:  lut_u1_dout <= 10'h375;
      8'd26:  lut_u1_dout <= 10'h377;
      8'd27:  lut_u1_dout <= 10'h378;
      8'd28:  lut_u1_dout <= 10'h379;
      8'd29:  lut_u1_dout <= 10'h37B;
      8'd30:  lut_u1_dout <= 10'h37C;
      8'd31:  lut_u1_dout <= 10'h37D;
      8'd32:  lut_u1_dout <= 10'h37F;
      8'd33:  lut_u1_dout <= 10'h380;
      8'd34:  lut_u1_dout <= 10'h381;
      8'd35:  lut_u1_dout <= 10'h383;
      8'd36:  lut_u1_dout <= 10'h384;
      8'd37:  lut_u1_dout <= 10'h385;
      8'd38:  lut_u1_dout <= 10'h387;
      8'd39:  lut_u1_dout <= 10'h388;
      8'd40:  lut_u1_dout <= 10'h389;
      8'd41:  lut_u1_dout <= 10'h38B;
      8'd42:  lut_u1_dout <= 10'h38C;
      8'd43:  lut_u1_dout <= 10'h38D;
      8'd44:  lut_u1_dout <= 10'h38F;
      8'd45:  lut_u1_dout <= 10'h390;
      8'd46:  lut_u1_dout <= 10'h391;
      8'd47:  lut_u1_dout <= 10'h393;
      8'd48:  lut_u1_dout <= 10'h394;
      8'd49:  lut_u1_dout <= 10'h396;
      8'd50:  lut_u1_dout <= 10'h397;
      8'd51:  lut_u1_dout <= 10'h398;
      8'd52:  lut_u1_dout <= 10'h39A;
      8'd53:  lut_u1_dout <= 10'h39B;
      8'd54:  lut_u1_dout <= 10'h39C;
      8'd55:  lut_u1_dout <= 10'h39E;
      8'd56:  lut_u1_dout <= 10'h39F;
      8'd57:  lut_u1_dout <= 10'h3A0;
      8'd58:  lut_u1_dout <= 10'h3A2;
      8'd59:  lut_u1_dout <= 10'h3A3;
      8'd60:  lut_u1_dout <= 10'h3A4;
      8'd61:  lut_u1_dout <= 10'h3A6;
      8'd62:  lut_u1_dout <= 10'h3A7;
      8'd63:  lut_u1_dout <= 10'h3A8;
      8'd64:  lut_u1_dout <= 10'h3AA;
      8'd65:  lut_u1_dout <= 10'h3AB;
      8'd66:  lut_u1_dout <= 10'h3AC;
      8'd67:  lut_u1_dout <= 10'h3AE;
      8'd68:  lut_u1_dout <= 10'h3AF;
      8'd69:  lut_u1_dout <= 10'h3B0;
      8'd70:  lut_u1_dout <= 10'h3B2;
      8'd71:  lut_u1_dout <= 10'h3B3;
      8'd72:  lut_u1_dout <= 10'h3B5;
      8'd73:  lut_u1_dout <= 10'h3B6;
      8'd74:  lut_u1_dout <= 10'h3B7;
      8'd75:  lut_u1_dout <= 10'h3B9;
      8'd76:  lut_u1_dout <= 10'h3BA;
      8'd77:  lut_u1_dout <= 10'h3BB;
      8'd78:  lut_u1_dout <= 10'h3BD;
      8'd79:  lut_u1_dout <= 10'h3BE;
      8'd80:  lut_u1_dout <= 10'h3BF;
      8'd81:  lut_u1_dout <= 10'h3C1;
      8'd82:  lut_u1_dout <= 10'h3C2;
      8'd83:  lut_u1_dout <= 10'h3C3;
      8'd84:  lut_u1_dout <= 10'h3C5;
      8'd85:  lut_u1_dout <= 10'h3C6;
      8'd86:  lut_u1_dout <= 10'h3C7;
      8'd87:  lut_u1_dout <= 10'h3C9;
      8'd88:  lut_u1_dout <= 10'h3CA;
      8'd89:  lut_u1_dout <= 10'h3CB;
      8'd90:  lut_u1_dout <= 10'h3CD;
      8'd91:  lut_u1_dout <= 10'h3CE;
      8'd92:  lut_u1_dout <= 10'h3CF;
      8'd93:  lut_u1_dout <= 10'h3D1;
      8'd94:  lut_u1_dout <= 10'h3D2;
      8'd95:  lut_u1_dout <= 10'h3D4;
      8'd96:  lut_u1_dout <= 10'h3D5;
      8'd97:  lut_u1_dout <= 10'h3D6;
      8'd98:  lut_u1_dout <= 10'h3D8;
      8'd99:  lut_u1_dout <= 10'h3D9;
      8'd100: lut_u1_dout <= 10'h3DA;
      8'd101: lut_u1_dout <= 10'h3DC;
      8'd102: lut_u1_dout <= 10'h3DD;
      8'd103: lut_u1_dout <= 10'h3DE;
      8'd104: lut_u1_dout <= 10'h3E0;
      8'd105: lut_u1_dout <= 10'h3E1;
      8'd106: lut_u1_dout <= 10'h3E2;
      8'd107: lut_u1_dout <= 10'h3E4;
      8'd108: lut_u1_dout <= 10'h3E5;
      8'd109: lut_u1_dout <= 10'h3E6;
      8'd110: lut_u1_dout <= 10'h3E8;
      8'd111: lut_u1_dout <= 10'h3E9;
      8'd112: lut_u1_dout <= 10'h3EA;
      8'd113: lut_u1_dout <= 10'h3EC;
      8'd114: lut_u1_dout <= 10'h3ED;
      8'd115: lut_u1_dout <= 10'h3EE;
      8'd116: lut_u1_dout <= 10'h3F0;
      8'd117: lut_u1_dout <= 10'h3F1;
      8'd118: lut_u1_dout <= 10'h3F3;
      8'd119: lut_u1_dout <= 10'h3F4;
      8'd120: lut_u1_dout <= 10'h3F5;
      8'd121: lut_u1_dout <= 10'h3F7;
      8'd122: lut_u1_dout <= 10'h3F8;
      8'd123: lut_u1_dout <= 10'h3F9;
      8'd124: lut_u1_dout <= 10'h3FB;
      8'd125: lut_u1_dout <= 10'h3FC;
      8'd126: lut_u1_dout <= 10'h3FD;
      8'd127: lut_u1_dout <= 10'h3FF;
      8'd128: lut_u1_dout <= 10'h000;
      8'd129: lut_u1_dout <= 10'h001;
      8'd130: lut_u1_dout <= 10'h003;
      8'd131: lut_u1_dout <= 10'h004;
      8'd132: lut_u1_dout <= 10'h005;
      8'd133: lut_u1_dout <= 10'h007;
      8'd134: lut_u1_dout <= 10'h008;
      8'd135: lut_u1_dout <= 10'h009;
      8'd136: lut_u1_dout <= 10'h00B;
      8'd137: lut_u1_dout <= 10'h00C;
      8'd138: lut_u1_dout <= 10'h00D;
      8'd139: lut_u1_dout <= 10'h00F;
      8'd140: lut_u1_dout <= 10'h010;
      8'd141: lut_u1_dout <= 10'h012;
      8'd142: lut_u1_dout <= 10'h013;
      8'd143: lut_u1_dout <= 10'h014;
      8'd144: lut_u1_dout <= 10'h016;
      8'd145: lut_u1_dout <= 10'h017;
      8'd146: lut_u1_dout <= 10'h018;
      8'd147: lut_u1_dout <= 10'h01A;
      8'd148: lut_u1_dout <= 10'h01B;
      8'd149: lut_u1_dout <= 10'h01C;
      8'd150: lut_u1_dout <= 10'h01E;
      8'd151: lut_u1_dout <= 10'h01F;
      8'd152: lut_u1_dout <= 10'h020;
      8'd153: lut_u1_dout <= 10'h022;
      8'd154: lut_u1_dout <= 10'h023;
      8'd155: lut_u1_dout <= 10'h024;
      8'd156: lut_u1_dout <= 10'h026;
      8'd157: lut_u1_dout <= 10'h027;
      8'd158: lut_u1_dout <= 10'h028;
      8'd159: lut_u1_dout <= 10'h02A;
      8'd160: lut_u1_dout <= 10'h02B;
      8'd161: lut_u1_dout <= 10'h02C;
      8'd162: lut_u1_dout <= 10'h02E;
      8'd163: lut_u1_dout <= 10'h02F;
      8'd164: lut_u1_dout <= 10'h031;
      8'd165: lut_u1_dout <= 10'h032;
      8'd166: lut_u1_dout <= 10'h033;
      8'd167: lut_u1_dout <= 10'h035;
      8'd168: lut_u1_dout <= 10'h036;
      8'd169: lut_u1_dout <= 10'h037;
      8'd170: lut_u1_dout <= 10'h039;
      8'd171: lut_u1_dout <= 10'h03A;
      8'd172: lut_u1_dout <= 10'h03B;
      8'd173: lut_u1_dout <= 10'h03D;
      8'd174: lut_u1_dout <= 10'h03E;
      8'd175: lut_u1_dout <= 10'h03F;
      8'd176: lut_u1_dout <= 10'h041;
      8'd177: lut_u1_dout <= 10'h042;
      8'd178: lut_u1_dout <= 10'h043;
      8'd179: lut_u1_dout <= 10'h045;
      8'd180: lut_u1_dout <= 10'h046;
      8'd181: lut_u1_dout <= 10'h047;
      8'd182: lut_u1_dout <= 10'h049;
      8'd183: lut_u1_dout <= 10'h04A;
      8'd184: lut_u1_dout <= 10'h04B;
      8'd185: lut_u1_dout <= 10'h04D;
      8'd186: lut_u1_dout <= 10'h04E;
      8'd187: lut_u1_dout <= 10'h050;
      8'd188: lut_u1_dout <= 10'h051;
      8'd189: lut_u1_dout <= 10'h052;
      8'd190: lut_u1_dout <= 10'h054;
      8'd191: lut_u1_dout <= 10'h055;
      8'd192: lut_u1_dout <= 10'h056;
      8'd193: lut_u1_dout <= 10'h058;
      8'd194: lut_u1_dout <= 10'h059;
      8'd195: lut_u1_dout <= 10'h05A;
      8'd196: lut_u1_dout <= 10'h05C;
      8'd197: lut_u1_dout <= 10'h05D;
      8'd198: lut_u1_dout <= 10'h05E;
      8'd199: lut_u1_dout <= 10'h060;
      8'd200: lut_u1_dout <= 10'h061;
      8'd201: lut_u1_dout <= 10'h062;
      8'd202: lut_u1_dout <= 10'h064;
      8'd203: lut_u1_dout <= 10'h065;
      8'd204: lut_u1_dout <= 10'h066;
      8'd205: lut_u1_dout <= 10'h068;
      8'd206: lut_u1_dout <= 10'h069;
      8'd207: lut_u1_dout <= 10'h06A;
      8'd208: lut_u1_dout <= 10'h06C;
      8'd209: lut_u1_dout <= 10'h06D;
      8'd210: lut_u1_dout <= 10'h06F;
      8'd211: lut_u1_dout <= 10'h070;
      8'd212: lut_u1_dout <= 10'h071;
      8'd213: lut_u1_dout <= 10'h073;
      8'd214: lut_u1_dout <= 10'h074;
      8'd215: lut_u1_dout <= 10'h075;
      8'd216: lut_u1_dout <= 10'h077;
      8'd217: lut_u1_dout <= 10'h078;
      8'd218: lut_u1_dout <= 10'h079;
      8'd219: lut_u1_dout <= 10'h07B;
      8'd220: lut_u1_dout <= 10'h07C;
      8'd221: lut_u1_dout <= 10'h07D;
      8'd222: lut_u1_dout <= 10'h07F;
      8'd223: lut_u1_dout <= 10'h080;
      8'd224: lut_u1_dout <= 10'h081;
      8'd225: lut_u1_dout <= 10'h083;
      8'd226: lut_u1_dout <= 10'h084;
      8'd227: lut_u1_dout <= 10'h085;
      8'd228: lut_u1_dout <= 10'h087;
      8'd229: lut_u1_dout <= 10'h088;
      8'd230: lut_u1_dout <= 10'h089;
      8'd231: lut_u1_dout <= 10'h08B;
      8'd232: lut_u1_dout <= 10'h08C;
      8'd233: lut_u1_dout <= 10'h08E;
      8'd234: lut_u1_dout <= 10'h08F;
      8'd235: lut_u1_dout <= 10'h090;
      8'd236: lut_u1_dout <= 10'h092;
      8'd237: lut_u1_dout <= 10'h093;
      8'd238: lut_u1_dout <= 10'h094;
      8'd239: lut_u1_dout <= 10'h096;
      8'd240: lut_u1_dout <= 10'h097;
      8'd241: lut_u1_dout <= 10'h098;
      8'd242: lut_u1_dout <= 10'h09A;
      8'd243: lut_u1_dout <= 10'h09B;
      8'd244: lut_u1_dout <= 10'h09C;
      8'd245: lut_u1_dout <= 10'h09E;
      8'd246: lut_u1_dout <= 10'h09F;
      8'd247: lut_u1_dout <= 10'h0A0;
      8'd248: lut_u1_dout <= 10'h0A2;
      8'd249: lut_u1_dout <= 10'h0A3;
      8'd250: lut_u1_dout <= 10'h0A4;
      8'd251: lut_u1_dout <= 10'h0A6;
      8'd252: lut_u1_dout <= 10'h0A7;
      8'd253: lut_u1_dout <= 10'h0A9;
      8'd254: lut_u1_dout <= 10'h0AA;
      8'd255: lut_u1_dout <= 10'h0AB;
    endcase
  end
  
endmodule


