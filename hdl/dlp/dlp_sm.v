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
//  Title       :  Display List Processor State Machine
//  File        :  dlp_sm.v
//  Author      :  Frank Bruno
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

`timescale 1 ns / 10 ps
  module dlp_sm
    (
     input	  hb_clk,
     input	  hb_rstn,
     input        dlp_rstn_hb,
     input	  mc_done,
     input [8:2]  hb_adr,         // host bus address
     input  	  hb_wstrb,       // host bus write strobr
     input [3:0]  hb_ben,         // host bus byte enables
     input        hb_csn,         // host bus chip select. -Drawing engine
     input [31:0] hb_din,	  // host bus data
     input        de_busy,        // drawing pipeline busy
     input	  dl_stop,
     input [31:0] table_org0,	  // Origin pointer to text tables
     input [31:0] table_org1,	  // Origin pointer to text tables
     input [8:2]  aad,
     input [8:2]  bad,
     input [8:2]  cad,
     input [127:0] dl_temp,
     input [31:0] curr_sorg,	  // Source origin of current entry
     input [7:0]  curr_height,	  // height of current entry
     input [7:0]  curr_width,	  // width of current entry
     input [3:0]  curr_pg_cnt,	  // Pages of current entry
     input [15:0] dest_x,	  // X destination for text mode
     input [15:0] dest_y,	  // Y destiantion for text mode
     input	  cmd_rdy_ld,
     input	  wcf,
     input	  cache_busy,
     input	  mc_rdy,
     input	  dl_idle,
     input [1:0]  list_format,
     input	  v_sunk,
     input	  wvs,
     input	  dlf,
     input [1:0]  wcount,
     input [27:0] dl_adr,	  // current display list address
     input	  dlp_actv_2,
     input	  char_count,
     input	  dlp_data_avail,
     
     output reg	  dl_memreq,
     output reg	  text_store, 	  // stored version of text to hold stuff 
     output	  char_select,
     output	  actv_stp,
     output reg [27:0] mc_adr,    // display list address for MC and DMA
     output	  hb_de_busy,
     output [8:2] de_adr,
     output [3:0] de_ben,
     output	  de_wstrb,
     output [31:0] de_data,
     output	  de_csn,
     output reg	  cmd_ack,      // ACK start of command
     output reg	  next_dle,     // Increment the address counter
     output reg   reset_wait,   // Reset WCF bit
     output reg   dlp_wreg_pop, // Pop the FIFO and write the data to dlp rgister.
     output reg   dlp_flush,     // FLUSH the DLP FIFO.
output reg	[6:0]	dl_cs		// State registers
     );
  
wire		text;		/* in text mode				*/

reg	     	dl_wstrb;       /* Write Strobe to DE			*/
reg	[1:0]	dl_sel;		/* select outputs			*/
reg		mc_done_lvl;	/* level signal for mc_done		*/
reg	[8:2]	dl_reg_adr;     /* Address to DE			*/
reg	[3:0]	dl_ben;         /* Byte enable to DE			*/
reg	[31:0]	dl_data;        /* Data to DE				*/
reg	     	dlp_flush_a;    // Flush FIFO pre clock.

  parameter 	DORG_SORG 	= 6'b0_0010_1,	// address 0x028 and 0x02c
		XY1_XY0 	= 6'b0_1000_1,	// address 0x088 and 0x08c
		XY3_XY2 	= 6'b0_1001_0;	// address 0x090 and 0x094
`ifdef RTL_ENUM
	enum {
  		DL_WAIT 	= 	7'b0_0_1_0000,	// 10
  		DL_S    	= 	7'b0_0_1_0001,	// 11
  		DL_POP    	= 	7'b0_0_1_1001,	// 19
  		DL_W4F  	= 	7'b0_0_1_0010,	// 12
  		DL_S1   	= 	7'b0_0_1_0011,	// 13
  		DL_R1_1 	= 	7'b0_1_1_0100,	// 34 // only text because it req's mem
  		DL_R2_1 	= 	7'b0_0_1_0101,	// 15
  		DL_R3_1 	= 	7'b0_0_1_0110,	// 16
  		DL_R4_1 	= 	7'b0_0_1_0111,	// 17
  		DL_NEXT 	= 	7'b0_0_1_1000,	// 18
  		DL_NEXT1 	= 	7'b0_0_1_1010,	// 1A
  		DL_RSTN		=	7'b0_0_0_0000,  // 00

  		TEXT_WAIT0	=	7'b0_1_1_0000,	// 30
  		TEXT_PREWAIT	=	7'b0_1_1_1111,	// 3F
  		TEXT_WR_XY20	=	7'b0_1_1_0001,	// 31
  		TEXT_WR_XY30  	=	7'b0_1_1_0010,	// 32
  		TEXT_WR_XY10	=	7'b0_1_1_0011,	// 33
		TEXT_FETCH1	=	7'b1_1_1_0000,	// 70
  		TEXT_PREWAIT1	=	7'b1_1_1_1111,	// 7F
  		TEXT_WAIT1	=	7'b1_1_1_0001,	// 71
  		TEXT_WR_XY21	=	7'b1_1_1_0010,	// 72
  		TEXT_WR_XY31  	=	7'b1_1_1_0011,	// 73
  		TEXT_WR_XY11	=	7'b1_1_1_0100	// 74
		} dl_cs, dl_ns;
`else
// reg	[6:0]	dl_cs;		/* State registers			*/
reg	[6:0]	dl_ns;		/* State registers			*/

parameter 				// {char,text,vsync_rstn,state[3:0]}
  DL_WAIT 	= 	7'b0_0_1_0000,	// 10
  DL_S    	= 	7'b0_0_1_0001,	// 11
  DL_POP    	= 	7'b0_0_1_1001,	// 19
  DL_W4F  	= 	7'b0_0_1_0010,	// 12
  DL_S1   	= 	7'b0_0_1_0011,	// 13
  DL_R1_1 	= 	7'b0_1_1_0100,	// 34 // only text because it req's mem
  DL_R2_1 	= 	7'b0_0_1_0101,	// 15
  DL_R3_1 	= 	7'b0_0_1_0110,	// 16
  DL_R4_1 	= 	7'b0_0_1_0111,	// 17
  DL_NEXT 	= 	7'b0_0_1_1000,	// 18
  DL_NEXT1 	= 	7'b0_0_1_1010,	// 1A
  DL_RSTN	=	7'b0_0_0_0000,  // 00

  TEXT_WAIT0	=	7'b0_1_1_0000,	// 30
  TEXT_PREWAIT	=	7'b0_1_1_1111,	// 3F
  TEXT_WR_XY20	=	7'b0_1_1_0001,	// 31
  TEXT_WR_XY30  =	7'b0_1_1_0010,	// 32
  TEXT_WR_XY10	=	7'b0_1_1_0011,	// 33
  TEXT_FETCH1	=	7'b1_1_1_0000,	// 70
  TEXT_PREWAIT1	=	7'b1_1_1_1111,	// 7F
  TEXT_WAIT1	=	7'b1_1_1_0001,	// 71
  TEXT_WR_XY21	=	7'b1_1_1_0010,	// 72
  TEXT_WR_XY31  =	7'b1_1_1_0011,	// 73
  TEXT_WR_XY11	=	7'b1_1_1_0100;	// 74
`endif

parameter
  REG3		=	2'b00,		// 3 registers programmable
  REG4		=	2'b01,		// 4 registers fixed
  TEXT		=	2'b11;		// Text processing mode

always @(posedge hb_clk) if (dl_memreq) text_store <= text;

assign char_select	= dl_cs[6];	/* which character are we on	*/
assign text		= dl_cs[5];	/* in text mode			*/
assign actv_stp 	= dl_cs[4];	/* Stop active list		*/

always @* begin
  casex ({(text && dl_memreq), char_select}) /* synopsys full_case parallel_case */
    2'b0x: mc_adr = dl_adr;
    2'b10: mc_adr = table_org0[31:4];
    2'b11: mc_adr = table_org1[31:4];
  endcase
end

always @(posedge hb_clk or negedge hb_rstn)
  if (!hb_rstn) 				mc_done_lvl <= 1'b0;
  else if (dlp_rstn_hb)				mc_done_lvl <= 1'b0;
  else if (mc_done) 				mc_done_lvl <= 1'b1;
  else if (dl_wstrb || dl_memreq)       	mc_done_lvl <= 1'b0;

/*************************************************************************/
/* PASS THROUGH MUXES - Must take over the DE bus when DLP is active     */
/*************************************************************************/
assign hb_de_busy 	= (dlp_actv_2) ? 1'b1 			: de_busy;
assign de_adr[8:2] 	= (dlp_actv_2) ? dl_reg_adr[8:2] 	: hb_adr[8:2];
assign de_ben 		= (dlp_actv_2) ? dl_ben 		: hb_ben;
assign de_wstrb 	= (dlp_actv_2) ? dl_wstrb 		: hb_wstrb; 
assign de_data 		= (dlp_actv_2) ? dl_data 		: hb_din;
assign de_csn 		= (dlp_actv_2) ? 1'b0 			: hb_csn;

/************************************************************************/
/* STATE MACHINE */
always @(posedge hb_clk or negedge hb_rstn) begin
	if(!hb_rstn)		dl_cs <= DL_WAIT;
	else if(dlp_rstn_hb)	dl_cs <= DL_WAIT;
	else 			dl_cs <= dl_ns;
end

always @(posedge hb_clk) dlp_flush <= dlp_flush_a;

always @* begin
  	dl_memreq    = 1'b0;
  	dl_wstrb     = 1'b0;
  	cmd_ack      = 1'b0;
  	next_dle     = 1'b0;
  	dl_sel       = 2'b0;
  	reset_wait   = 1'b0;
  	dlp_flush_a  = 1'b0;
  	dlp_wreg_pop = 1'b0;
  	dl_ns      = dl_cs;
  	case(dl_cs)	// synopsys parallel_case
    	DL_WAIT: begin 
      		dl_ns = DL_WAIT;
      		if(cmd_rdy_ld)begin
			dl_ns   = DL_S;
			cmd_ack = 1'b1;
      		end 
		else dl_ns = DL_WAIT;
    	end
    	DL_S: begin
      		if(dl_stop) dl_ns=DL_RSTN;
      		else if(~wcf & cache_busy & !dl_idle) dl_ns = DL_W4F;

      		// data available.
      		// else if(dlp_data_avail && !dl_idle) begin
      		else if(dlp_data_avail && !dl_idle) begin
			dl_ns = DL_R1_1;
  			dlp_wreg_pop = 1'b1;
		end
      		// data not available go fetch 16 words from memory
      		else if(mc_rdy && ~cache_busy && !dl_idle) begin
			dl_memreq = 1'b1;
			dl_ns = DL_POP;
      		end 
		else dl_ns=DL_S1;
    	end
    	DL_POP: begin
	  	if (mc_done_lvl)begin
  			dlp_wreg_pop = 1'b1;
			dl_ns = DL_R1_1;
		end
		else dl_ns = DL_POP;
	end
    	DL_W4F: begin
      		if (~cache_busy) begin
			dl_ns = DL_S;
			reset_wait = 1'b1;
      		end 
		else dl_ns = DL_W4F;
    	end
    	DL_S1: begin
      		if(dl_stop) dl_ns=DL_RSTN;
      		// data available.
      		else if(dlp_data_avail && !dl_idle) begin
			dl_ns        = DL_R1_1;
  			dlp_wreg_pop = 1'b1;
		end
      		else if(mc_rdy && ~cache_busy && !dl_idle) begin
			dl_memreq = 1'b1;
			dl_ns = DL_POP;
      		end 
		else dl_ns=DL_S1;
    	end
	// Flush the FIFO.
	DL_RSTN: begin
		dl_ns = DL_WAIT;
  		dlp_flush_a = 1'b1;
	end
    	// When the memory is done loading the register. set the
    	// register address to XY0. and strobe the data into the drawing
    	// engine.
    	DL_R1_1: begin
      		dl_sel = 2'b0;
      		// WAIT based on the mode
      		case (list_format)
		REG3: begin
	  		if (!de_busy && (wvs & v_sunk || !wvs))begin
	    			dl_wstrb = 1'b1;
				// Next state determination
            			if (!dlf & wcount == 1)dl_ns = DL_NEXT;
	    			else		       dl_ns = DL_R2_1;
          		end 
			else dl_ns = DL_R1_1;
        	end
		REG4: begin
	  		if (!de_busy)begin
	    			dl_wstrb = 1'b1;
            			// Next state determination
            			if (!dlf & wcount == 1)dl_ns = DL_NEXT;
	    			else		       dl_ns = DL_R2_1;
          		end 
			else dl_ns = DL_R1_1;
        	end
		TEXT: begin	// fetch table org
      	  		if(mc_rdy && ~cache_busy ) begin
  				dlp_flush_a = 1'b1;
      	    			dl_memreq = 1'b1;
            			// dl_ns = TEXT_WAIT0;
            			dl_ns = TEXT_PREWAIT;
          		end 
			else dl_ns = DL_R1_1;
        	end
		default: dl_sel = 2'd0;
      		endcase
    	end
    	DL_R2_1: begin
      		dl_sel = 2'd1;
      		if (!de_busy) begin
			dl_wstrb = 1'b1;
        		// Next state determination
        		if (!dlf & wcount == 2)	dl_ns = DL_NEXT;
			else   			dl_ns = DL_R3_1;
      		end 
		else dl_ns = DL_R2_1;
    	end
    	DL_R3_1: begin
      		dl_sel = 2'd2;
      		if (!de_busy) begin
			dl_wstrb = 1'b1;
        		// Next state determination
        		if (!dlf) dl_ns = DL_NEXT;
			else   	  dl_ns = DL_R4_1;
      		end 
		else dl_ns = DL_R3_1;
    	end
    	DL_R4_1: begin
      		dl_sel = 2'd3;
      		if(!de_busy) begin
			dl_wstrb = 1'b1;
			dl_ns    = DL_NEXT;
      		end 
		else dl_ns=DL_R4_1;
    	end
    TEXT_PREWAIT: begin
      if (mc_done_lvl && !de_busy) begin
  	dlp_wreg_pop = 1'b1;
	dl_ns = TEXT_WAIT0;
      end else dl_ns = TEXT_PREWAIT;
    end      
    TEXT_WAIT0: begin
        dl_sel = 2'b0;
        dl_wstrb = 1'b1;
        dl_ns = TEXT_WR_XY20;
    end
    TEXT_WR_XY20: begin
      dl_sel = 2'b1;
      dl_wstrb = 1'b1;
      dl_ns = TEXT_WR_XY30;
    end
    TEXT_WR_XY30: begin
      dl_sel = 2'd2;
      dl_wstrb = 1'b1;
      dl_ns = TEXT_WR_XY10;
    end
    TEXT_WR_XY10: begin
      dl_sel = 2'd3;
      dl_wstrb = 1'b1;
      dl_ns = (~char_count) ? DL_NEXT : TEXT_FETCH1;
      dlp_flush_a = 1'b1;
    end
    TEXT_FETCH1: begin	// fetch table org
      if(mc_rdy && ~cache_busy ) begin
      	dl_memreq = 1'b1;
        dl_ns = TEXT_PREWAIT1;  
      end else dl_ns = TEXT_FETCH1;
    end
    TEXT_PREWAIT1: begin
      if (mc_done_lvl && !de_busy) begin
  	dlp_wreg_pop = 1'b1;
	dl_ns = TEXT_WAIT1;
      end else dl_ns = TEXT_PREWAIT1;
    end      
    TEXT_WAIT1: begin
        dl_wstrb = 1'b1;
        dl_ns = TEXT_WR_XY21;
    end
    TEXT_WR_XY21: begin
      dl_sel = 2'd1;
      dl_wstrb = 1'b1;
      dl_ns = TEXT_WR_XY31;
    end
    TEXT_WR_XY31: begin
      dl_sel = 2'd2;
      dl_wstrb = 1'b1;
      dl_ns = TEXT_WR_XY11;
    end
    TEXT_WR_XY11: begin
      dl_sel = 2'd3;
      dl_wstrb = 1'b1;
      dl_ns = DL_NEXT;
      dlp_flush_a = 1'b1;
    end
    DL_NEXT: begin
	next_dle = 1'b1;
	dl_ns = DL_NEXT1;
      end // dl_ns=DL_NEXT1;
    DL_NEXT1: begin
	dl_ns = DL_S;
      end // dl_ns=DL_S;
    default: begin 
      		dl_ns = DL_WAIT;
	end
  endcase
end

// Data for REG3 or REG4 modes
always @* begin
  casex({(list_format==TEXT),dlf,dl_sel})	/* synopsys parallel_case */
    4'b0100: begin 
      	dl_reg_adr = {XY1_XY0, 1'b0};
      	dl_ben = 4'b0000; 
      	dl_data = dl_temp[31:0];
    end
    4'b0101: begin 
      	dl_reg_adr = {XY3_XY2, 1'b0};
      	dl_ben = 4'b0000; 
      	dl_data = dl_temp[63:32];
    end
    4'b0110: begin 
      	dl_reg_adr = {XY3_XY2, 1'b1}; 
      	dl_ben = 4'b0000; 
      	dl_data = dl_temp[95:64];
    end
    4'b0111: begin 
      	dl_reg_adr = {XY1_XY0, 1'b1}; 
      	dl_ben = 4'b0000; 
      	dl_data = dl_temp[127:96];
    end 
    4'b1x00: begin		// SORG
      	dl_reg_adr = {DORG_SORG, 1'b0}; 
      	dl_ben = 4'b0000; 
      	dl_data = curr_sorg;
    end
    4'b1x01: begin		// XY2
      	dl_reg_adr = {XY3_XY2, 1'b0}; 
      	dl_ben = 4'b0000; 
      	dl_data = {8'b0, curr_width, 8'b0, curr_height};
    end
    4'b1x10: begin		// XY3
      	dl_reg_adr = {XY3_XY2, 1'b1};       dl_ben = 4'b0000; 
      	dl_data = {24'b0, curr_pg_cnt};
    end
    4'b1x11: begin		// XY1
      	dl_reg_adr = {XY1_XY0, 1'b1}; 
      	dl_ben = 4'b0000; 
      	dl_data = {dest_x, dest_y};
    end
    4'b0000: begin 
      	dl_reg_adr = aad;
      	dl_ben = 4'b0;
      	dl_data = dl_temp[63:32];
    end 
    4'b0001: begin 
      	dl_reg_adr = bad;
      	dl_ben = 4'b0;
      	dl_data = dl_temp[95:64];
    end
    default: begin 
      	dl_reg_adr = cad;
      	dl_ben = 4'b0;
      	dl_data = dl_temp[127:96];
    end
  endcase
end

endmodule
