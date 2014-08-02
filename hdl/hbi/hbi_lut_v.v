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
//  Title       :  LUT V
//  File        :  hbi_lut_v.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  YUV LUT V component
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

  module hbi_lut_v 
    (
     input            hb_clk,
     input [7:0]      lut_v_index,

     output reg [9:0] lut_v0_dout,
     output reg [9:0] lut_v1_dout
     );

  always @(posedge hb_clk)
    case(lut_v_index) /* synopsys full_case parallel_case*/
      8'd0:  begin
        lut_v0_dout <= 10'h2A1;
        lut_v1_dout <= 10'h29B;
      end
      8'd1:  begin
        lut_v0_dout <= 10'h2A4;
        lut_v1_dout <= 10'h29D;
      end
      8'd2:  begin
        lut_v0_dout <= 10'h2A7;
        lut_v1_dout <= 10'h2A0;
      end
      8'd3:  begin
        lut_v0_dout <= 10'h2A9;
        lut_v1_dout <= 10'h2A3;
      end
      8'd4:  begin 
        lut_v0_dout <= 10'h2AC;
        lut_v1_dout <= 10'h2A6;
      end
      8'd5:  begin
        lut_v0_dout <= 10'h2AF;
        lut_v1_dout <= 10'h2A9;
      end
      8'd6:  begin 
        lut_v0_dout <= 10'h2B1;
        lut_v1_dout <= 10'h2AB;
      end
      8'd7:  begin
        lut_v0_dout <= 10'h2B4;
        lut_v1_dout <= 10'h2AE;
      end
      8'd8:  begin 
        lut_v0_dout <= 10'h2B7;
        lut_v1_dout <= 10'h2B1;
      end
      8'd9:  begin 
        lut_v0_dout <= 10'h2BA;
        lut_v1_dout <= 10'h2B4;
      end
      8'd10:  begin
        lut_v0_dout <= 10'h2BC;
        lut_v1_dout <= 10'h2B7;
      end
      8'd11:  begin 
        lut_v0_dout <= 10'h2BF;
        lut_v1_dout <= 10'h2B9;
      end
      8'd12:  begin
        lut_v0_dout <= 10'h2C2;
        lut_v1_dout <= 10'h2BC;
      end
      8'd13:  begin
        lut_v0_dout <= 10'h2C5;
        lut_v1_dout <= 10'h2BF;
      end
      8'd14:  begin 
        lut_v0_dout <= 10'h2C7;
        lut_v1_dout <= 10'h2C2;
      end
      8'd15:  begin 
        lut_v0_dout <= 10'h2CA;
        lut_v1_dout <= 10'h2C5;
      end
      8'd16:  begin 
        lut_v0_dout <= 10'h2CD;
        lut_v1_dout <= 10'h2C7;
      end
      8'd17:  begin 
        lut_v0_dout <= 10'h2D0;
        lut_v1_dout <= 10'h2CA;
      end
      8'd18:  begin
        lut_v0_dout <= 10'h2D2;
        lut_v1_dout <= 10'h2CD;
      end
      8'd19:  begin
        lut_v0_dout <= 10'h2D5;
        lut_v1_dout <= 10'h2D0;
      end
      8'd20:  begin 
        lut_v0_dout <= 10'h2D8;
        lut_v1_dout <= 10'h2D2;
      end
      8'd21:  begin
        lut_v0_dout <= 10'h2DB;
        lut_v1_dout <= 10'h2D5;
      end
      8'd22:  begin 
        lut_v0_dout <= 10'h2DD;
        lut_v1_dout <= 10'h2D8;
      end
      8'd23:  begin 
        lut_v0_dout <= 10'h2E0;
        lut_v1_dout <= 10'h2DB;
      end
      8'd24:  begin
        lut_v0_dout <= 10'h2E3;
        lut_v1_dout <= 10'h2DE;
      end
      8'd25:  begin
        lut_v0_dout <= 10'h2E6;
        lut_v1_dout <= 10'h2E0;
      end
      8'd26:  begin
        lut_v0_dout <= 10'h2E8;
        lut_v1_dout <= 10'h2E3;
      end
      8'd27:  begin
        lut_v0_dout <= 10'h2EB;
        lut_v1_dout <= 10'h2E6;
      end
      8'd28:  begin 
        lut_v0_dout <= 10'h2EE;
        lut_v1_dout <= 10'h2E9;
      end
      8'd29:  begin
        lut_v0_dout <= 10'h2F1;
        lut_v1_dout <= 10'h2EC;
      end
      8'd30:  begin
        lut_v0_dout <= 10'h2F3;
        lut_v1_dout <= 10'h2EE;
      end
      8'd31:  begin
        lut_v0_dout <= 10'h2F6;
        lut_v1_dout <= 10'h2F1;
      end
      8'd32:  begin
        lut_v0_dout <= 10'h2F9;
        lut_v1_dout <= 10'h2F4;
      end
      8'd33:  begin 
        lut_v0_dout <= 10'h2FC;
        lut_v1_dout <= 10'h2F7;
      end
      8'd34:  begin
        lut_v0_dout <= 10'h2FE;
        lut_v1_dout <= 10'h2FA;
      end
      8'd35:  begin
        lut_v0_dout <= 10'h301;
        lut_v1_dout <= 10'h2FC;
      end
      8'd36:  begin
        lut_v0_dout <= 10'h304;
        lut_v1_dout <= 10'h2FF;
      end
      8'd37:  begin
        lut_v0_dout <= 10'h306;
        lut_v1_dout <= 10'h302;
      end
      8'd38:  begin
        lut_v0_dout <= 10'h309;
        lut_v1_dout <= 10'h305;
      end
      8'd39:  begin
        lut_v0_dout <= 10'h30C;
        lut_v1_dout <= 10'h308;
      end
      8'd40:  begin
        lut_v0_dout <= 10'h30F;
        lut_v1_dout <= 10'h30A;
      end
      8'd41:  begin
        lut_v0_dout <= 10'h311;
        lut_v1_dout <= 10'h30D;
      end
      8'd42:  begin
        lut_v0_dout <= 10'h314;
        lut_v1_dout <= 10'h310;
      end
      8'd43:  begin
        lut_v0_dout <= 10'h317;
        lut_v1_dout <= 10'h313;
      end
      8'd44:  begin
        lut_v0_dout <= 10'h31A;
        lut_v1_dout <= 10'h315;
      end
      8'd45:  begin
        lut_v0_dout <= 10'h31C;
        lut_v1_dout <= 10'h318;
      end
      8'd46:  begin
        lut_v0_dout <= 10'h31F;
        lut_v1_dout <= 10'h31B;
      end
      8'd47:  begin
        lut_v0_dout <= 10'h322;
        lut_v1_dout <= 10'h31E;
      end
      8'd48:  begin
        lut_v0_dout <= 10'h325;
        lut_v1_dout <= 10'h321;
      end
      8'd49:  begin
        lut_v0_dout <= 10'h327;
        lut_v1_dout <= 10'h323;
      end
      8'd50:  begin
        lut_v0_dout <= 10'h32A;
        lut_v1_dout <= 10'h326;
      end
      8'd51:  begin
        lut_v0_dout <= 10'h32D;
        lut_v1_dout <= 10'h329;
      end
      8'd52:  begin 
        lut_v0_dout <= 10'h330;
        lut_v1_dout <= 10'h32C;
      end
      8'd53:  begin
        lut_v0_dout <= 10'h332;
        lut_v1_dout <= 10'h32F;
      end
      8'd54:  begin 
        lut_v0_dout <= 10'h335;
        lut_v1_dout <= 10'h331;
      end
      8'd55:  begin
        lut_v0_dout <= 10'h338;
        lut_v1_dout <= 10'h334;
      end
      8'd56:  begin
        lut_v0_dout <= 10'h33B;
        lut_v1_dout <= 10'h337;
      end
      8'd57:  begin
        lut_v0_dout <= 10'h33D;
        lut_v1_dout <= 10'h33A;
      end
      8'd58:  begin
        lut_v0_dout <= 10'h340;
        lut_v1_dout <= 10'h33D;
      end
      8'd59:  begin
        lut_v0_dout <= 10'h343;
        lut_v1_dout <= 10'h33F;
      end
      8'd60:  begin
        lut_v0_dout <= 10'h346;
        lut_v1_dout <= 10'h342;
      end
      8'd61:  begin
        lut_v0_dout <= 10'h348;
        lut_v1_dout <= 10'h345;
      end
      8'd62:  begin
        lut_v0_dout <= 10'h34B;
        lut_v1_dout <= 10'h348;
      end
      8'd63:  begin 
        lut_v0_dout <= 10'h34E;
        lut_v1_dout <= 10'h34B;
      end
      8'd64:  begin
        lut_v0_dout <= 10'h351;
        lut_v1_dout <= 10'h34D;
      end
      8'd65:  begin
        lut_v0_dout <= 10'h353;
        lut_v1_dout <= 10'h350;
      end
      8'd66:  begin
        lut_v0_dout <= 10'h356;
        lut_v1_dout <= 10'h353;
      end
      8'd67:  begin
        lut_v0_dout <= 10'h359;
        lut_v1_dout <= 10'h356;
      end
      8'd68:  begin
        lut_v0_dout <= 10'h35B;
        lut_v1_dout <= 10'h358;
      end
      8'd69:  begin
        lut_v0_dout <= 10'h35E;
        lut_v1_dout <= 10'h35B;
      end
      8'd70:  begin
        lut_v0_dout <= 10'h361;
        lut_v1_dout <= 10'h35E;
      end
      8'd71:  begin
        lut_v0_dout <= 10'h364;
        lut_v1_dout <= 10'h361;
      end
      8'd72:  begin
        lut_v0_dout <= 10'h366;
        lut_v1_dout <= 10'h364;
      end
      8'd73:  begin
        lut_v0_dout <= 10'h369;
        lut_v1_dout <= 10'h366;
      end
      8'd74:  begin
        lut_v0_dout <= 10'h36C;
        lut_v1_dout <= 10'h369;
      end
      8'd75:  begin
        lut_v0_dout <= 10'h36F;
        lut_v1_dout <= 10'h36C;
      end
      8'd76:  begin
        lut_v0_dout <= 10'h371;
        lut_v1_dout <= 10'h36F;
      end
      8'd77:  begin
        lut_v0_dout <= 10'h374;
        lut_v1_dout <= 10'h372;
      end
      8'd78:  begin
        lut_v0_dout <= 10'h377;
        lut_v1_dout <= 10'h374;
      end
      8'd79:  begin
        lut_v0_dout <= 10'h37A;
        lut_v1_dout <= 10'h377;
      end
      8'd80:  begin
        lut_v0_dout <= 10'h37C;
        lut_v1_dout <= 10'h37A;
      end
      8'd81:  begin
        lut_v0_dout <= 10'h37F;
        lut_v1_dout <= 10'h37D;
      end
      8'd82:  begin
        lut_v0_dout <= 10'h382;
        lut_v1_dout <= 10'h380;
      end
      8'd83:  begin
        lut_v0_dout <= 10'h385;
        lut_v1_dout <= 10'h382;
      end
      8'd84:  begin 
        lut_v0_dout <= 10'h387;
        lut_v1_dout <= 10'h385;
      end
      8'd85:  begin
        lut_v0_dout <= 10'h38A;
        lut_v1_dout <= 10'h388;
      end
      8'd86:  begin
        lut_v0_dout <= 10'h38D;
        lut_v1_dout <= 10'h38B;
      end
      8'd87:  begin
        lut_v0_dout <= 10'h390;
        lut_v1_dout <= 10'h38E;
      end
      8'd88:  begin
        lut_v0_dout <= 10'h392;
        lut_v1_dout <= 10'h390;
      end
      8'd89:  begin
        lut_v0_dout <= 10'h395;
        lut_v1_dout <= 10'h393;
      end
      8'd90:  begin
        lut_v0_dout <= 10'h398;
        lut_v1_dout <= 10'h396;
      end
      8'd91:  begin
        lut_v0_dout <= 10'h39B;
        lut_v1_dout <= 10'h399;
      end
      8'd92:  begin
        lut_v0_dout <= 10'h39D;
        lut_v1_dout <= 10'h39B;
      end
      8'd93:  begin
        lut_v0_dout <= 10'h3A0;
        lut_v1_dout <= 10'h39E;
      end
      8'd94:  begin
        lut_v0_dout <= 10'h3A3;
        lut_v1_dout <= 10'h3A1;
      end
      8'd95:  begin
        lut_v0_dout <= 10'h3A6;
        lut_v1_dout <= 10'h3A4;
      end
      8'd96:  begin
        lut_v0_dout <= 10'h3A8;
        lut_v1_dout <= 10'h3A7;
      end
      8'd97:  begin
        lut_v0_dout <= 10'h3AB;
        lut_v1_dout <= 10'h3A9;
      end
      8'd98:  begin
        lut_v0_dout <= 10'h3AE;
        lut_v1_dout <= 10'h3AC;
      end
      8'd99:  begin
        lut_v0_dout <= 10'h3B0;
        lut_v1_dout <= 10'h3AF;
      end
      8'd100:  begin
        lut_v0_dout <= 10'h3B3;
        lut_v1_dout <= 10'h3B2;
      end
      8'd101:  begin
        lut_v0_dout <= 10'h3B6;
        lut_v1_dout <= 10'h3B5;
      end
      8'd102:  begin
        lut_v0_dout <= 10'h3B9;
        lut_v1_dout <= 10'h3B7;
      end
      8'd103:  begin
        lut_v0_dout <= 10'h3BB;
        lut_v1_dout <= 10'h3BA;
      end
      8'd104:  begin
        lut_v0_dout <= 10'h3BE;
        lut_v1_dout <= 10'h3BD;
      end
      8'd105:  begin
        lut_v0_dout <= 10'h3C1;
        lut_v1_dout <= 10'h3C0;
      end
      8'd106:  begin
        lut_v0_dout <= 10'h3C4;
        lut_v1_dout <= 10'h3C3;
      end
      8'd107:  begin
        lut_v0_dout <= 10'h3C6;
        lut_v1_dout <= 10'h3C5;
      end
      8'd108:  begin
        lut_v0_dout <= 10'h3C9;
        lut_v1_dout <= 10'h3C8;
      end
      8'd109:  begin
        lut_v0_dout <= 10'h3CC;
        lut_v1_dout <= 10'h3CB;
      end
      8'd110:  begin
        lut_v0_dout <= 10'h3CF;
        lut_v1_dout <= 10'h3CE;
      end
      8'd111:  begin
        lut_v0_dout <= 10'h3D1;
        lut_v1_dout <= 10'h3D1;
      end
      8'd112:  begin
        lut_v0_dout <= 10'h3D4;
        lut_v1_dout <= 10'h3D3;
      end
      8'd113:  begin
        lut_v0_dout <= 10'h3D7;
        lut_v1_dout <= 10'h3D6;
      end
      8'd114:  begin
        lut_v0_dout <= 10'h3DA;
        lut_v1_dout <= 10'h3D9;
      end
      8'd115:  begin
        lut_v0_dout <= 10'h3DC;
        lut_v1_dout <= 10'h3DC;
      end
      8'd116:  begin
        lut_v0_dout <= 10'h3DF;
        lut_v1_dout <= 10'h3DE;
      end
      8'd117:  begin
        lut_v0_dout <= 10'h3E2;
        lut_v1_dout <= 10'h3E1;
      end
      8'd118:  begin
        lut_v0_dout <= 10'h3E5;
        lut_v1_dout <= 10'h3E4;
      end
      8'd119:  begin
        lut_v0_dout <= 10'h3E7;
        lut_v1_dout <= 10'h3E7;
      end
      8'd120:  begin
        lut_v0_dout <= 10'h3EA;
        lut_v1_dout <= 10'h3EA;
      end
      8'd121:  begin
        lut_v0_dout <= 10'h3ED;
        lut_v1_dout <= 10'h3EC;
      end
      8'd122:  begin
        lut_v0_dout <= 10'h3F0;
        lut_v1_dout <= 10'h3EF;
      end
      8'd123:  begin
        lut_v0_dout <= 10'h3F2;
        lut_v1_dout <= 10'h3F2;
      end
      8'd124:  begin
        lut_v0_dout <= 10'h3F5;
        lut_v1_dout <= 10'h3F5;
      end
      8'd125:  begin
        lut_v0_dout <= 10'h3F8;
        lut_v1_dout <= 10'h3F8;
      end
      8'd126:  begin
        lut_v0_dout <= 10'h3FB;
        lut_v1_dout <= 10'h3FA;
      end
      8'd127:  begin
        lut_v0_dout <= 10'h3FD;
        lut_v1_dout <= 10'h3FD;
      end
      8'd128:  begin
        lut_v0_dout <= 10'h000;
        lut_v1_dout <= 10'h000;
      end
      8'd129:  begin
        lut_v0_dout <= 10'h003;
        lut_v1_dout <= 10'h003;
      end
      8'd130:  begin
        lut_v0_dout <= 10'h005;
        lut_v1_dout <= 10'h006;
      end
      8'd131:  begin
        lut_v0_dout <= 10'h008;
        lut_v1_dout <= 10'h008;
      end
      8'd132:  begin
        lut_v0_dout <= 10'h00B;
        lut_v1_dout <= 10'h00B;
      end
      8'd133:  begin
        lut_v0_dout <= 10'h00E;
        lut_v1_dout <= 10'h00E;
      end
      8'd134:  begin
        lut_v0_dout <= 10'h010;
        lut_v1_dout <= 10'h011;
      end
      8'd135:  begin
        lut_v0_dout <= 10'h013;
        lut_v1_dout <= 10'h014;
      end
      8'd136:  begin
        lut_v0_dout <= 10'h016;
        lut_v1_dout <= 10'h016;
      end
      8'd137:  begin
        lut_v0_dout <= 10'h019;
        lut_v1_dout <= 10'h019;
      end
      8'd138:  begin
        lut_v0_dout <= 10'h01B;
        lut_v1_dout <= 10'h01C;
      end
      8'd139:  begin
        lut_v0_dout <= 10'h01E;
        lut_v1_dout <= 10'h01F;
      end
      8'd140:  begin
        lut_v0_dout <= 10'h021;
        lut_v1_dout <= 10'h022;
      end
      8'd141:  begin
        lut_v0_dout <= 10'h024;
        lut_v1_dout <= 10'h024;
      end
      8'd142:  begin
        lut_v0_dout <= 10'h026;
        lut_v1_dout <= 10'h027;
      end
      8'd143:  begin
        lut_v0_dout <= 10'h029;
        lut_v1_dout <= 10'h02A;
      end
      8'd144:  begin
        lut_v0_dout <= 10'h02C;
        lut_v1_dout <= 10'h02D;
      end
      8'd145:  begin
        lut_v0_dout <= 10'h02F;
        lut_v1_dout <= 10'h02F;
      end
      8'd146:  begin
        lut_v0_dout <= 10'h031;
        lut_v1_dout <= 10'h032;
      end
      8'd147:  begin
        lut_v0_dout <= 10'h034;
        lut_v1_dout <= 10'h035;
      end
      8'd148:  begin
        lut_v0_dout <= 10'h037;
        lut_v1_dout <= 10'h038;
      end
      8'd149:  begin
        lut_v0_dout <= 10'h03A;
        lut_v1_dout <= 10'h03B;
      end
      8'd150:  begin
        lut_v0_dout <= 10'h03C;
        lut_v1_dout <= 10'h03D;
      end
      8'd151:  begin
        lut_v0_dout <= 10'h03F;
        lut_v1_dout <= 10'h040;
      end
      8'd152:  begin
        lut_v0_dout <= 10'h042;
        lut_v1_dout <= 10'h043;
      end
      8'd153:  begin
        lut_v0_dout <= 10'h045;
        lut_v1_dout <= 10'h046;
      end
      8'd154:  begin
        lut_v0_dout <= 10'h047;
        lut_v1_dout <= 10'h049;
      end
      8'd155:  begin
        lut_v0_dout <= 10'h04A;
        lut_v1_dout <= 10'h04B;
      end
      8'd156:  begin
        lut_v0_dout <= 10'h04D;
        lut_v1_dout <= 10'h04E;
      end
      8'd157:  begin
        lut_v0_dout <= 10'h050;
        lut_v1_dout <= 10'h051;
      end
      8'd158:  begin
        lut_v0_dout <= 10'h052;
        lut_v1_dout <= 10'h054;
      end
      8'd159:  begin
        lut_v0_dout <= 10'h055;
        lut_v1_dout <= 10'h057;
      end
      8'd160:  begin
        lut_v0_dout <= 10'h058;
        lut_v1_dout <= 10'h059;
      end
      8'd161:  begin
        lut_v0_dout <= 10'h05A;
        lut_v1_dout <= 10'h05C;
      end
      8'd162:  begin
        lut_v0_dout <= 10'h05D;
        lut_v1_dout <= 10'h05F;
      end
      8'd163:  begin
        lut_v0_dout <= 10'h060;
        lut_v1_dout <= 10'h062;
      end
      8'd164:  begin
        lut_v0_dout <= 10'h063;
        lut_v1_dout <= 10'h065;
      end
      8'd165:  begin
        lut_v0_dout <= 10'h065;
        lut_v1_dout <= 10'h067;
      end
      8'd166:  begin
        lut_v0_dout <= 10'h068;
        lut_v1_dout <= 10'h06A;
      end
      8'd167:  begin
        lut_v0_dout <= 10'h06B;
        lut_v1_dout <= 10'h06D;
      end
      8'd168:  begin
        lut_v0_dout <= 10'h06E;
        lut_v1_dout <= 10'h070;
      end
      8'd169:  begin
        lut_v0_dout <= 10'h070;
        lut_v1_dout <= 10'h072;
      end
      8'd170:  begin
        lut_v0_dout <= 10'h073;
        lut_v1_dout <= 10'h075;
      end
      8'd171:  begin
        lut_v0_dout <= 10'h076;
        lut_v1_dout <= 10'h078;
      end
      8'd172:  begin
        lut_v0_dout <= 10'h079;
        lut_v1_dout <= 10'h07B;
      end
      8'd173:  begin
        lut_v0_dout <= 10'h07B;
        lut_v1_dout <= 10'h07E;
      end
      8'd174:  begin
        lut_v0_dout <= 10'h07E;
        lut_v1_dout <= 10'h080;
      end
      8'd175:  begin
        lut_v0_dout <= 10'h081;
        lut_v1_dout <= 10'h083;
      end
      8'd176:  begin
        lut_v0_dout <= 10'h084;
        lut_v1_dout <= 10'h086;
      end
      8'd177:  begin
        lut_v0_dout <= 10'h086;
        lut_v1_dout <= 10'h089;
      end
      8'd178:  begin
        lut_v0_dout <= 10'h089;
        lut_v1_dout <= 10'h08C;
      end
      8'd179:  begin
        lut_v0_dout <= 10'h08C;
        lut_v1_dout <= 10'h08E;
      end
      8'd180:  begin
        lut_v0_dout <= 10'h08F;
        lut_v1_dout <= 10'h091;
      end
      8'd181:  begin
        lut_v0_dout <= 10'h091;
        lut_v1_dout <= 10'h094;
      end
      8'd182:  begin
        lut_v0_dout <= 10'h094;
        lut_v1_dout <= 10'h097;
      end
      8'd183:  begin
        lut_v0_dout <= 10'h097;
        lut_v1_dout <= 10'h09A;
      end
      8'd184:  begin
        lut_v0_dout <= 10'h09A;
        lut_v1_dout <= 10'h09C;
      end
      8'd185:  begin
        lut_v0_dout <= 10'h09C;
        lut_v1_dout <= 10'h09F;
      end
      8'd186:  begin
        lut_v0_dout <= 10'h09F;
        lut_v1_dout <= 10'h0A2;
      end
      8'd187:  begin
        lut_v0_dout <= 10'h0A2;
        lut_v1_dout <= 10'h0A5;
      end
      8'd188:  begin
        lut_v0_dout <= 10'h0A5;
        lut_v1_dout <= 10'h0A8;
      end
      8'd189:  begin
        lut_v0_dout <= 10'h0A7;
        lut_v1_dout <= 10'h0AA;
      end
      8'd190:  begin
        lut_v0_dout <= 10'h0AA;
        lut_v1_dout <= 10'h0AD;
      end
      8'd191:  begin
        lut_v0_dout <= 10'h0AD;
        lut_v1_dout <= 10'h0B0;
      end
      8'd192:  begin
        lut_v0_dout <= 10'h0AF;
        lut_v1_dout <= 10'h0B3;
      end
      8'd193:  begin
        lut_v0_dout <= 10'h0B2;
        lut_v1_dout <= 10'h0B5;
      end
      8'd194:  begin
        lut_v0_dout <= 10'h0B5;
        lut_v1_dout <= 10'h0B8;
      end
      8'd195:  begin
        lut_v0_dout <= 10'h0B8;
        lut_v1_dout <= 10'h0BB;
      end
      8'd196:  begin
        lut_v0_dout <= 10'h0BA;
        lut_v1_dout <= 10'h0BE;
      end
      8'd197:  begin
        lut_v0_dout <= 10'h0BD;
        lut_v1_dout <= 10'h0C1;
      end
      8'd198:  begin
        lut_v0_dout <= 10'h0C0;
        lut_v1_dout <= 10'h0C3;
      end
      8'd199:  begin
        lut_v0_dout <= 10'h0C3;
        lut_v1_dout <= 10'h0C6;
      end
      8'd200:  begin
        lut_v0_dout <= 10'h0C5;
        lut_v1_dout <= 10'h0C9;
      end
      8'd201:  begin
        lut_v0_dout <= 10'h0C8;
        lut_v1_dout <= 10'h0CC;
      end
      8'd202:  begin
        lut_v0_dout <= 10'h0CB;
        lut_v1_dout <= 10'h0CF;
      end
      8'd203:  begin
        lut_v0_dout <= 10'h0CE;
        lut_v1_dout <= 10'h0D1;
      end
      8'd204:  begin
        lut_v0_dout <= 10'h0D0;
        lut_v1_dout <= 10'h0D4;
      end
      8'd205:  begin
        lut_v0_dout <= 10'h0D3;
        lut_v1_dout <= 10'h0D7;
      end
      8'd206:  begin
        lut_v0_dout <= 10'h0D6;
        lut_v1_dout <= 10'h0DA;
      end
      8'd207:  begin
        lut_v0_dout <= 10'h0D9;
        lut_v1_dout <= 10'h0DD;
      end
      8'd208:  begin
        lut_v0_dout <= 10'h0DB;
        lut_v1_dout <= 10'h0DF;
      end
      8'd209:  begin
        lut_v0_dout <= 10'h0DE;
        lut_v1_dout <= 10'h0E2;
      end
      8'd210:  begin
        lut_v0_dout <= 10'h0E1;
        lut_v1_dout <= 10'h0E5;
      end
      8'd211:  begin
        lut_v0_dout <= 10'h0E4;
        lut_v1_dout <= 10'h0E8;
      end
      8'd212:  begin
        lut_v0_dout <= 10'h0E6;
        lut_v1_dout <= 10'h0EB;
      end
      8'd213:  begin
        lut_v0_dout <= 10'h0E9;
        lut_v1_dout <= 10'h0ED;
      end
      8'd214:  begin
        lut_v0_dout <= 10'h0EC;
        lut_v1_dout <= 10'h0F0;
      end
      8'd215:  begin
        lut_v0_dout <= 10'h0EF;
        lut_v1_dout <= 10'h0F3;
      end
      8'd216:  begin
        lut_v0_dout <= 10'h0F1;
        lut_v1_dout <= 10'h0F6;
      end
      8'd217:  begin
        lut_v0_dout <= 10'h0F4;
        lut_v1_dout <= 10'h0F8;
      end
      8'd218:  begin
        lut_v0_dout <= 10'h0F7;
        lut_v1_dout <= 10'h0FB;
      end
      8'd219:  begin
        lut_v0_dout <= 10'h0FA;
        lut_v1_dout <= 10'h0FE;
      end
      8'd220:  begin
        lut_v0_dout <= 10'h0FC;
        lut_v1_dout <= 10'h101;
      end
      8'd221:  begin
        lut_v0_dout <= 10'h0FF;
        lut_v1_dout <= 10'h104;
      end
      8'd222:  begin
        lut_v0_dout <= 10'h102;
        lut_v1_dout <= 10'h106;
      end
      8'd223:  begin
        lut_v0_dout <= 10'h104;
        lut_v1_dout <= 10'h109;
      end
      8'd224:  begin
        lut_v0_dout <= 10'h107;
        lut_v1_dout <= 10'h10C;
      end
      8'd225:  begin
        lut_v0_dout <= 10'h10A;
        lut_v1_dout <= 10'h10F;
      end
      8'd226:  begin
        lut_v0_dout <= 10'h10D;
        lut_v1_dout <= 10'h112;
      end
      8'd227:  begin
        lut_v0_dout <= 10'h10F;
        lut_v1_dout <= 10'h114;
      end
      8'd228:  begin
        lut_v0_dout <= 10'h112;
        lut_v1_dout <= 10'h117;
      end
      8'd229:  begin
        lut_v0_dout <= 10'h115;
        lut_v1_dout <= 10'h11A;
      end
      8'd230:  begin
        lut_v0_dout <= 10'h118;
        lut_v1_dout <= 10'h11D;
      end
      8'd231:  begin
        lut_v0_dout <= 10'h11A;
        lut_v1_dout <= 10'h120;
      end
      8'd232:  begin
        lut_v0_dout <= 10'h11D;
        lut_v1_dout <= 10'h122;
      end
      8'd233:  begin
        lut_v0_dout <= 10'h120;
        lut_v1_dout <= 10'h125;
      end
      8'd234:  begin
        lut_v0_dout <= 10'h123;
        lut_v1_dout <= 10'h128;
      end
      8'd235:  begin
        lut_v0_dout <= 10'h125;
        lut_v1_dout <= 10'h12B;
      end
      8'd236:  begin
        lut_v0_dout <= 10'h128;
        lut_v1_dout <= 10'h12E;
      end
      8'd237:  begin
        lut_v0_dout <= 10'h12B;
        lut_v1_dout <= 10'h130;
      end
      8'd238:  begin
        lut_v0_dout <= 10'h12E;
        lut_v1_dout <= 10'h133;
      end
      8'd239:  begin
        lut_v0_dout <= 10'h130;
        lut_v1_dout <= 10'h136;
      end
      8'd240:  begin
        lut_v0_dout <= 10'h133;
        lut_v1_dout <= 10'h139;
      end
      8'd241:  begin
        lut_v0_dout <= 10'h136;
        lut_v1_dout <= 10'h13B;
      end
      8'd242:  begin
        lut_v0_dout <= 10'h139;
        lut_v1_dout <= 10'h13E;
      end
      8'd243:  begin
        lut_v0_dout <= 10'h13B;
        lut_v1_dout <= 10'h141;
      end
      8'd244:  begin
        lut_v0_dout <= 10'h13E;
        lut_v1_dout <= 10'h144;
      end
      8'd245:  begin
        lut_v0_dout <= 10'h141;
        lut_v1_dout <= 10'h147;
      end
      8'd246:  begin
        lut_v0_dout <= 10'h144;
        lut_v1_dout <= 10'h149;
      end
      8'd247:  begin
        lut_v0_dout <= 10'h146;
        lut_v1_dout <= 10'h14C;
      end
      8'd248:  begin
        lut_v0_dout <= 10'h149;
        lut_v1_dout <= 10'h14F;
      end
      8'd249:  begin
        lut_v0_dout <= 10'h14C;
        lut_v1_dout <= 10'h152;
      end
      8'd250:  begin
        lut_v0_dout <= 10'h14F;
        lut_v1_dout <= 10'h155;
      end
      8'd251:  begin
        lut_v0_dout <= 10'h151;
        lut_v1_dout <= 10'h157;
      end
      8'd252:  begin
        lut_v0_dout <= 10'h154;
        lut_v1_dout <= 10'h15A;
      end
      8'd253:  begin
        lut_v0_dout <= 10'h157;
        lut_v1_dout <= 10'h15D;
      end
      8'd254:  begin
        lut_v0_dout <= 10'h159;
        lut_v1_dout <= 10'h160;
      end
      8'd255:  begin
        lut_v0_dout <= 10'h15C;
        lut_v1_dout <= 10'h163;
      end
      
    endcase
    
endmodule

