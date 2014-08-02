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
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
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
//
///////////////////////////////////////////////////////////////////////////////
// Vertex Componant selectors.
	`define  VALL [351:0]
	`define  VXW  [31:0]
	`define  VXB3 [31:24]
	`define  VXB2 [23:16]
	`define  VXB1 [15:8]
	`define  VXB0 [7:0]
	`define  VYW  [63:32]
	`define  VYB3 [63:56]
	`define  VYB2 [55:48]
	`define  VYB1 [47:40]
	`define  VYB0 [39:32]
	`define  VZW  [95:64]
	`define  VZB3 [95:88]
	`define  VZB2 [87:80]
	`define  VZB1 [79:72]
	`define  VZB0 [71:64]
	`define  VWW  [127:96]
	`define  VWB3 [127:120]
	`define  VWB2 [119:112]
	`define  VWB1 [111:104]
	`define  VWB0 [103:96]
	`define  VUW  [159:128]
	`define  VUB3 [159:152]
	`define  VUB2 [151:144]
	`define  VUB1 [143:136]
	`define  VUB0 [135:128]
	`define  VVW  [191:160]
	`define  VVB3 [191:184]
	`define  VVB2 [183:176]
	`define  VVB1 [175:168]
	`define  VVB0 [167:160]
	`define  VAW  [223:192]
	`define  VAB3 [223:216]
	`define  VAB2 [215:208]
	`define  VAB1 [207:200]
	`define  VAB0 [199:192]
	`define  VRW  [255:224]
	`define  VRB3 [255:248]
	`define  VRB2 [247:240]
	`define  VRB1 [239:232]
	`define  VRB0 [231:224]
	`define  VGW  [287:256]
	`define  VGB3 [287:280]
	`define  VGB2 [279:272]
	`define  VGB1 [271:264]
	`define  VGB0 [263:256]
	`define  VBW  [319:288]
	`define  VBB3 [319:312]
	`define  VBB2 [311:304]
	`define  VBB1 [303:296]
	`define  VBB0 [295:288]
	`define  VSW  [351:320]
	`define  VSB3 [351:344]
	`define  VSB2 [343:336]
	`define  VSB1 [335:328]
	`define  VSB0 [327:320]
	// Extra for setup Engine.
	`define  VBSW [351:320]
	`define  VGSW [383:352]
	`define  VRSW [415:384]
	`define  VFW  [447:416]

// Result Load Bits.
	`define LD_ZX  0
	`define LD_ZY  1
	`define LD_WX  2
	`define LD_WY  3
	`define LD_UWX  4
	`define LD_UWY  5
	`define LD_VWX  6
	`define LD_VWY  7
	`define LD_AX  8
	`define LD_AY  9
	`define LD_RX  10
	`define LD_RY  11
	`define LD_GX  12
	`define LD_GY  13
	`define LD_BX  14
	`define LD_BY  15
	`define LD_FX  16
	`define LD_FY  17
	`define LD_RSX 18
	`define LD_RSY 19
	`define LD_GSX 20
	`define LD_GSY 21
	`define LD_BSX 22
	`define LD_BSY 23
	`define LD_E1S 24
	`define LD_E2S 25
	`define LD_E3S 26
	`define LD_E1X 0
	`define LD_E2X 1
	`define LD_E3X 2
	`define CPX [255:240]
	`define CPY [239:224]
	`define E3S [223:192]
	`define E2S [191:160]
	`define E1S [159:128]
	`define E3X [127:96]
	`define E2X [95:64]
	`define E1X [63:32]
	`define NS2 [31:16]
	`define NS1 [15:0]
// Setup State Parametes.
	`define SETUP_END 6'd42
	`define COLIN_STATE 6'd5
	`define NL1_NL2_STATE 6'd5
	`define NO_AREA_STATE 6'd10
// Texture Control Bits.
	`define T_TM   [0]
	`define T_MM   [1]
	`define T_NMG  [2]
	`define T_MLM  [3]
	`define T_NMM  [4]
	`define T_RGBM [5]
	`define T_PCM  [6]
	`define T_CCS  [7]
	`define T_TCU  [8]
	`define T_TCV  [9]
	`define T_MLP  [10]

	`define T_MMN   [15:12]
	`define T_MMSZX [19:16]
	`define T_MMSZY [23:20]
	`define T_SIZE  [29:24]
	`define T_SCL   [31]

// 3D Control Bits.
	`define D3_ZE  [0]
	`define D3_ZRO [1]
	`define D3_FIS [3]
	`define D3_FSL [4]
	`define D3_ZOP [7:5]
	`define D3_YOP [7:5]
	`define D3_HOP [13:11]
	`define D3_KYP [14]
	`define D3_KYE [15]
	`define D3_DOP [16]
	`define D3_ABS [17]
	`define D3_TBS [18]
	`define D3_RSL [19]
	`define D3_SSC [21]
	`define D3_CW  [22]
	`define D3_BCE [23]
	`define D3_SH  [24]
	`define D3_SPE [25]
	`define D3_RSC [26]
	`define D3_FEN [27]
	`define D3_RT  [28]
	`define D3_P8  [29]
	`define D3_ZS  [30]
// ALPHA Control Bits.
	`define A_TEST     [23:16]
	`define A_COMP_OP  [13:11]
	`define A_COMP_EN  [14]
	`define A_ASL  	   [15]
	`define A_AMD  	   [16]
	`define A_BE   	   [10]
// LODs.
	`define LOD_0 [20:0]
	`define LOD_1 [41:21]
	`define LOD_2 [62:42]
	`define LOD_3 [83:63]
	`define LOD_4 [104:84]
	`define LOD_5 [125:105]
	`define LOD_6 [146:126]
	`define LOD_7 [167:147]
	`define LOD_8 [188:168]
	`define LOD_9 [209:189]


