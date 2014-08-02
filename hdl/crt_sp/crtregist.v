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
//  Title       :  CRT Controller Registers
//  File        :  crtregist.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module is the CRT Display controller Host accessible registers
//  CRT Registers start at 0x0020 and end at 0x0063
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

module crtregist
  (
   input	      hclock,
   input 	      hnreset,
   input 	      hwr,
   input 	      hncs,
   input [3:0] 	      hnben,
   input [31:0]       hdat_in,
   input [7:2] 	      haddr,         // bit[2] used only in readback path
   input 	      ad_strst,      /* synchronized reset for 
				      * "display address updated" bit */
   input 	      vblnkst,       // synchronized  vertical blank status
   input [11:0]       lcounter_stat, // from line counter in TIMER (synch)
   
   input 	      dlp_wradd,     // DLP write enable to display register
   input [20:0]       dlp_add,       // display address from DLP
   
   output reg [31:0]  hdat_out,
   output reg [7:0]   vicount,
   output reg [11:0]  hicount,
   output reg [13:0]  hactive_o, 
   output reg [13:0]  hblank_o,
   output reg [13:0]  hfporch_o,
   output reg [13:0]  hswidth_o,
   output reg [11:0]  vactive,
   output reg [11:0]  vblank,
   output reg [11:0]  vfporch,
   output reg [11:0]  vswidth,
   output reg [3:0]   dzoom,
   output reg [15:4]  db_pitch,
   output reg [24:4]  displ_start,
   output reg [24:4]  sec_start,
   output reg	      poshs,
   output reg         posvs,
   output reg	      compsync,
   output reg	      crtintl,
   output reg	      videnable,
   output reg	      refresh_enable,
   output reg	      ovignr,
   output reg  	      ovignr16l,
   output reg [1:0]   syncsenable,
   output reg	      fdp_on,     //1 - enables flat display mode
   output reg	      addr_stat, // used as enble to synchr. with frame
   output reg[9:0]    pinl,
   output reg	      ss_mode
   );
  
  parameter 	  FRAME_COUNTorLINE_COUNT  = 5'b0010_0,
		  DISP_STARTorDISP_PITCH   = 5'b0010_1,
		  HACTIVEorHBLANK          = 5'b0011_0,
		  HFPORCHorHSYNC           = 5'b0011_1,
		  VACTIVEorVBLANK          = 5'b0100_0,
		  VFPORCHorVSYNC           = 5'b0100_1,
		  LCOUNTSorZOOM            = 5'b0101_0,
		  SYNC_SELorMEM_CONFIG     = 5'b0101_1 ,
		  SEC_STARTorRESERVED      = 5'b0110_0 ;
  
  reg [13:0] 	  hactive,  hblank,  hfporch, hswidth;
  reg [13:0] 	  hactive_s,  hblank_s,  hfporch_s, hswidth_s;
  reg [3:0] 	  hshifter;

  always @* hactive_o = {hactive_s[12:0], 1'b0};  
  always @* hblank_o =  {hblank_s[12:0],  1'b0};  
  always @* hfporch_o = {hfporch_s[12:0], 1'b0};  
  always @* hswidth_o = {hswidth_s[12:0], 1'b0};  

  always @*
    pinl[9:0] = (hactive_s[0]) ? (hactive_s[10:1]+1'b1) : hactive_s[10:1];

  // shift /divide horizontal sync parameters

  always @*
    case (hshifter) // synopsys parallel_case full_case 
      4'b0,
      4'b10,
      4'b100,
      4'b101,
      4'b110,
      4'b1000,
      4'b1001,
      4'b1010,
      4'b1011,
      4'b1100,
      4'b1101,
      4'b1110: begin
	hactive_s[13:0]=hactive[13:0];
	hblank_s[13:0]=hblank[13:0];
	hfporch_s[13:0]=hfporch[13:0];
	hswidth_s[13:0]=hswidth[13:0];
      end // case: 4'b0,...
      
      4'b1: begin
	hactive_s[13:0]={1'b0,hactive[13:1]};
	hblank_s[13:0]= {1'b0,hblank[13:1]};
	hfporch_s[13:0]={1'b0,hfporch[13:1]};
	hswidth_s[13:0]={1'b0,hswidth[13:1]};
      end // case: 4'b1
	
      4'b11: begin
	hactive_s[13:0]={2'b0,hactive[13:2]};
	hblank_s[13:0] ={2'b0,hblank[13:2]};
	hfporch_s[13:0]={2'b0,hfporch[13:2]};
	hswidth_s[13:0]={2'b0,hswidth[13:2]};
      end // case: 4'b11
	
      4'b111: begin
	hactive_s[13:0]={3'b0,hactive[13:3]};
	hblank_s[13:0]= {3'b0,hblank[13:3]};
	hfporch_s[13:0]={3'b0,hfporch[13:3]};
	hswidth_s[13:0]={3'b0,hswidth[13:3]};
      end // case: 4'b111
	
      4'b1111: begin
	hactive_s[13:0]={4'b0,hactive[13:4]};
	hblank_s[13:0]= {4'b0,hblank[13:4]};
	hfporch_s[13:0]={4'b0,hfporch[13:4]};
	hswidth_s[13:0]={4'b0,hswidth[13:4]};
      end // case: 4'b1111
    endcase
  
  always @ (posedge hclock or negedge hnreset)
    if(!hnreset) begin
      syncsenable    <= 2'b0;
      videnable      <= 1'b0;
      refresh_enable <= 1'b0;
      ovignr         <= 1'b0;
      ovignr16l      <= 1'b0;
      fdp_on         <= 1'b1; // Now enable Flat panel on reset
      ss_mode        <= 1'b0;
    end else if (hwr && !hncs) begin
      case (haddr[7:2]) // 
	
	{SYNC_SELorMEM_CONFIG, 1'b0}: begin
	  if (!hnben[0]) videnable      <= hdat_in[6];
	  if (!hnben[0]) syncsenable    <= hdat_in[5:4];
	  if (!hnben[0]) {crtintl, compsync, posvs, poshs} <= hdat_in[3:0];
	  if (!hnben[1]) fdp_on         <= hdat_in[8];
	  if (!hnben[3]) ss_mode        <= hdat_in[30];
	end
	{SYNC_SELorMEM_CONFIG, 1'b1}: begin
	  if (!hnben[1]) refresh_enable <= hdat_in[8];
	  if (!hnben[1]) ovignr16l      <= hdat_in[9];
	  if (!hnben[1]) ovignr         <= hdat_in[10];
	end
		 
	{FRAME_COUNTorLINE_COUNT, 1'b0}: begin
	  if (!hnben[0]) vicount[7:0]   <= hdat_in[7:0];
	end
	{FRAME_COUNTorLINE_COUNT, 1'b1}: begin
	  if (!hnben[0]) hicount[7:0]   <= {hdat_in[7:1], 1'b0};
	  if (!hnben[1]) hicount[11:8]  <= hdat_in[11:8];
	end
	
	{DISP_STARTorDISP_PITCH, 1'b1}: begin
	  if (!hnben[0]) db_pitch[7:4]  <= hdat_in[7:4];
	  if (!hnben[1]) db_pitch[15:8] <= hdat_in[15:8];
	end 
		 
	{HACTIVEorHBLANK, 1'b0}: begin
	  if (!hnben[0]) hactive[7:0]   <= hdat_in[7:0];
	  if (!hnben[1]) hactive[13:8]  <= hdat_in[13:8];
	end
	{HACTIVEorHBLANK, 1'b1}: begin
	  if (!hnben[0]) hblank[7:0]    <= hdat_in[7:0];
	  if (!hnben[1]) hblank[13:8]   <= hdat_in[13:8];
	end 

	{HFPORCHorHSYNC, 1'b0}: begin
	  if (!hnben[0]) hfporch[7:0]   <= hdat_in[7:0];
	  if (!hnben[1]) hfporch[13:8]  <= hdat_in[13:8];
	end
	{HFPORCHorHSYNC, 1'b1}: begin
	  if (!hnben[0]) hswidth[7:0]   <= hdat_in[7:0];
	  if (!hnben[1]) hswidth[13:8]  <= hdat_in[13:8];
	end 
	
	{VACTIVEorVBLANK, 1'b0}: begin
	  if (!hnben[0]) vactive[7:0]   <= hdat_in[7:0];
	  if (!hnben[1]) vactive[11:8]  <= hdat_in[11:8];
	end
	{VACTIVEorVBLANK, 1'b1}: begin
	  if (!hnben[0]) vblank[7:0]    <= hdat_in[7:0];
	  if (!hnben[1]) vblank[11:8]   <= hdat_in[11:8];
	end 
	
	{VFPORCHorVSYNC, 1'b0}: begin
	  if (!hnben[0]) vfporch[7:0]   <= hdat_in[7:0]; 
	  if (!hnben[1]) vfporch[11:8]  <= hdat_in[11:8];
	end
	{VFPORCHorVSYNC, 1'b1}: begin
	  if (!hnben[0]) vswidth[7:0]   <= hdat_in[7:0];
	  if (!hnben[1]) vswidth[11:8]  <= hdat_in[11:8];
	end 
	
	{LCOUNTSorZOOM, 1'b1}: begin
	  if (!hnben[0]) dzoom[3:0]     <= hdat_in[3:0];
	  if (!hnben[2]) hshifter[3:0]  <= hdat_in[19:16];
	end 
	 
	{SEC_STARTorRESERVED, 1'b0}: begin
	  if (!hnben[0]) sec_start[7:4]   <= hdat_in[7:4];
	  if (!hnben[1]) sec_start[15:8]  <= hdat_in[15:8];
	  if (!hnben[2]) sec_start[23:16] <= hdat_in[23:16];
	  if (!hnben[3]) sec_start[24]    <= hdat_in[24];
        end
	
      endcase // case (haddr)
    end // if (hwr && !hncs)

  // displ_start register can be modyfied by host and  DLP, DLP no byte writes
  always @ (posedge hclock) begin
    // host writes
    if( hwr && !hncs && (haddr[7:2] == {DISP_STARTorDISP_PITCH, 1'b0}) ) begin 
      if (!hnben[0]) displ_start[7:4]   <= hdat_in[7:4];
      if (!hnben[1]) displ_start[15:8]  <= hdat_in[15:8];
      if (!hnben[2]) displ_start[23:16] <= hdat_in[23:16];
      if (!hnben[3]) displ_start[24]    <= hdat_in[24];
    end else if (dlp_wradd) //DLP writes
      displ_start[24:4] <= dlp_add;
  end

  // ad_strst is a one hclk active high signal
  // generated after the display start address gets synchronized 
  // (once per frame)
  // This is now a synchronous signal for synchronous clearing.
  always @(posedge hclock or negedge hnreset) begin
    if (!hnreset)      addr_stat <= 1'b0;
    else if (ad_strst) addr_stat <= 1'b0;
    else if ((hwr && !hncs && !hnben[3]
              && (haddr[7:2] == {DISP_STARTorDISP_PITCH, 1'b0})
              ) || dlp_wradd)
      addr_stat <= 1'b1;
  end 

  /*********** output mux **************************************************/
  // haddr[2] in this case statement got added for layout improvements
  // (64->32 bus)
  // Only to avoid redefinitions in case values  bit[2] is treated seperately 
  // even if it looks strange
  always @*
    case (haddr[7:2]) //synopsys parallel_case
      {FRAME_COUNTorLINE_COUNT, 1'b0}: hdat_out[31:0] = {24'b0, vicount[7:0]};
      {FRAME_COUNTorLINE_COUNT, 1'b1}: hdat_out[31:0] = {20'b0, hicount[11:0]};
      {DISP_STARTorDISP_PITCH, 1'b0}:  hdat_out[31:0] = {addr_stat, 1'b0, 
							 vblnkst, 4'b0, 
							 displ_start[24:4], 
							 4'b0};
      {DISP_STARTorDISP_PITCH, 1'b1}:  hdat_out[31:0] = {16'b0, db_pitch[15:4],
							 4'b0};
      {HACTIVEorHBLANK, 1'b0}:         hdat_out[31:0] = {18'b0, hactive[13:0]};
      {HACTIVEorHBLANK, 1'b1}:         hdat_out[31:0] = {18'b0, hblank[13:0]};
      {HFPORCHorHSYNC, 1'b0}:          hdat_out[31:0] = {18'b0, hfporch[13:0]};
      {HFPORCHorHSYNC, 1'b1}:          hdat_out[31:0] = {18'b0, hswidth[13:0]};
      {VACTIVEorVBLANK, 1'b0}:         hdat_out[31:0] = {20'b0, vactive[11:0]};
      {VACTIVEorVBLANK, 1'b1}:         hdat_out[31:0] = {20'b0, vblank[11:0]};
      {VFPORCHorVSYNC, 1'b0}:          hdat_out[31:0] = {20'b0, vfporch[11:0]};
      {VFPORCHorVSYNC, 1'b1}:          hdat_out[31:0] = {20'b0, vswidth[11:0]};
      {LCOUNTSorZOOM, 1'b0}:           hdat_out[31:0] = {20'b0, 
							 lcounter_stat[11:0]};
      {LCOUNTSorZOOM, 1'b1}:           hdat_out[31:0] = {12'b0, hshifter[3:0],
							 12'b0, dzoom[3:0]};
      {SYNC_SELorMEM_CONFIG, 1'b0}:    hdat_out[31:0] = {1'b0, ss_mode, 
							 1'b0, 13'b0,
							 7'b0, fdp_on,
							 1'b0, videnable, 
							 syncsenable[1:0],
							 crtintl, compsync, 
							 posvs, poshs };
      {SYNC_SELorMEM_CONFIG, 1'b1}:    hdat_out[31:0] = {8'b0, 8'b0, 5'b0, 
							 ovignr, ovignr16l,
							 refresh_enable, 8'b0};
      {SEC_STARTorRESERVED, 1'b0}:     hdat_out[31:0] = {7'b0, sec_start[24:4],
							 4'b0};
      {SEC_STARTorRESERVED, 1'b1}:     hdat_out[31:0] = 32'b0;
      default:                         hdat_out[31:0]= 32'b0; // why not? 
    endcase
endmodule




