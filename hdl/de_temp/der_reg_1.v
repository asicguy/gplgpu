///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2009 - All rights reserved
//
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by UASC hereafter the "licensee", as defined by the NDA and the 
//  license agreement. 
//
//  This code may not be used as a basis for new development without a written
//  agreement between Silicon Spectrum and the licensee. 
//
//  New development includes, but is not limited to new designs based on this 
//  code, using this code to aid verification or using this code to test code 
//  developed independently by the licensee.
//
//  This copyright notice must be maintained as written, modifying or removing
//  this copyright header will be considered a breach of the license agreement.
//
//  The licensee may modify the code for the licensed project.
//  Silicon Spectrum does not give up the copyright to the original 
//  file or encumber in any way.
//
//  Use of this file is restricted by the license agreement between the
//  licensee and Silicon Spectrum, Inc.
//  
//  Title       :  Drawing Engine Register Block Level 1
//  File        :  der_reg_1.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module is the First input register stage
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

module der_reg_1
  (
   input		de_clk,		// drawing engine clock input
   input 	        de_rstn,	// de reset input
   input 	        hb_clk,		// host bus clock input
   input 	        hb_rstn,	// host bus reset input
   input [31:0] 	hb_din,	        // host bus data
   input [8:2]    	dlp_adr,	// host bus address
   input  	        hb_wstrb,	// host bus write strobes
   input [3:0] 	        hb_ben,		// host bus byte enables
   input 	        hb_csn,		// host bus chip select
   input 	        cmdack, 	// command ack from the dispatcher
   input 	        en_3d, 		// Enable 3D Core.
   input 	        de_clint_tog, 	// Clip Int toggle signal.
   input 	        de_ddint_tog, 	// Clip Int toggle signal.
   
   output reg [1:0]     intm,		// Interrupt Mask register.
   output reg [1:0]     intp,		// Interrupt Mask register.
   output [14:0]        buf_ctrl_1,	// buffer control register output
   output reg [31:0]    sorg_1,		// source origin register output
   output reg [31:0]    dorg_1,		// destination origin register output
   output reg [11:0]    sptch_1,	// source pitch register output
   output reg [11:0]    dptch_1,	// destination pitch register output
   output reg [3:0] 	opc_1,		// opcode register output
   output reg [3:0] 	rop_1,		// raster opcode register output
   output reg [4:0] 	style_1,	// drawing style register output
   output reg [3:0] 	patrn_1,	// drawing pattern style register
   output reg [2:0] 	hdf_1,		// source fetch disable
   output reg [2:0] 	clp_1,		// drawing clip control register output
   output reg [31:0]    fore_1,		// foreground color register output
   output reg [31:0]    back_1,		// background color register output
   output reg [3:0]     mask_1,		// plane mask register output
   output reg [23:0]    de_key_1,	// raster op  mask register output
   output reg [31:0]    lpat_1,		// line pattern register output
   output reg [15:0]    pctrl_1,	// line pattern control register output
   output reg [31:0]    clptl_1,	// clipping top left corner register
   output reg [31:0]    clpbr_1,	/* clipping bottom right corner
					 * output To maintain compatibility, 
					 * the XY ports are either XY or CP 
					 * based on opcode	       */
   output reg [31:0]    xy0_1,		// parameter register output XY0
   output reg [31:0]    xy1_1,		// parameter register output XY1
   output reg [31:0]    xy2_1,		// parameter register output XY2
   output reg [31:0]    xy3_1,		// parameter register output XY3
   output reg [31:0]    xy4_1,		// parameter register output XY4
   output reg [15:0]    alpha_1,        // Alpha value   register
   output reg [17:0]    acntrl_1,       // Alpha control register
   
   output reg 	        cmdrdy,		// command ready output to dispatcher
   output reg	        busy_hb,	// busy signal to the host
   output 	        stpl_1,		// packed stipple bit level one
   
   output reg	        cmd_trig_comb,	// Combinational command trigger
   
   // Outputs to CP reg block
   output reg [1:0] 	bc_lvl_1,	// Line vertical limit
   output reg		interrupt,
   output reg [6:0]     mem_offset_1,   // Define the offset in memory for ops
   output reg [3:0]     sorg_upper_1    // Define the offset in memory for ops
   );
  

parameter
	INTM_INTP 	= 6'b0_0000_0,	// Int mask, Int reg, 	0x00.
	BUSY_FLOW 	= 6'b0_0000_1,	// Int mask, Int reg, 	0x08.
	NA_XYW	 	= 6'b0_0001_0,	// XYW Address/Size,  	0x10.
	NA_TSORG 	= 6'b0_0001_1,	// Text offset Sorg	0x18.
	MEM_BCTRL 	= 6'b0_0010_0,	// Buffer Control, 	0x20.
	DORG_SORG 	= 6'b0_0010_1,	// Dest and Src Origin.	0x28.
	DPTCH_SPTCH 	= 6'b0_0100_0,
	CMDR 		= 6'b0_0100_1,
	ROP_OPC 	= 6'b0_0101_0,
	PATRN_STYLE 	= 6'b0_0101_1,
	SFD_CLP 	= 6'b0_0110_0,
	BACK_FORE 	= 6'b0_0110_1,
	DEKEY_MASK 	= 6'b0_0111_0,
	PCTRL_LPAT 	= 6'b0_0111_1,
	CLPBR_CLPTL 	= 6'b0_1000_0,
	XY1_XY0 	= 6'b0_1000_1,
	XY3_XY2 	= 6'b0_1001_0,
	NA_XY4  	= 6'b0_1001_1,
	TBOARD_ALPHA	= 6'b1_0010_1,
	ACNTRL_CMD	= 6'b1_0110_1,
	TRG3D_CP24 	= 6'b1_1101_1;


  wire [1:0] 	bc_nc_r = 2'b00;	// Buffer Control No Connection.
  wire 	 	hb_cmdclr;
  reg 	 	hb_cmdclr_d,hb_cmdclr_dd,hb_cmdclr_ddd;
  
  /***************************************************************************/
  /*		DEFINE ALL FIRST LEVEL REGISTERS IN THE DRAWING ENGINE	     */
  /***************************************************************************/
  reg 		bc_cr_r;	/* Cache ready bit.     		*/
  reg 		bc_co_r;	/* Cache on bit.	     		*/
  reg 		bc_cs_r;	/* Cache select bit.	     		*/
  reg 		bc_org_md_r;	/* origin mode.      			*/
  reg 		bc_8pg_r;	/* force 8 page mode.			*/
  
  reg [1:0] 	hform_r;        /* Host format                          */
  reg [2:0] 	key_ctrl_r;
  reg 		bc_sen_r;
  reg [1:0] 	bc_de_ps_r;

  reg		set_cl;
  reg		clint_1;
  reg		clint;
  reg		set_dd;
  reg		ddint_1;
  reg		ddint;

  /***************************************************************************/
  /*			DEFINE OTHER REGISTERS				*/
  /***************************************************************************/
  reg 		cmdrdy_r;	// command is ready for execution.
  reg 		cmdrdy_rr;	// command is ready for execution.
  reg 		hcmd_rdy_tog;	// host syncronous command ready

  /***************************************************************************/
  /*									*/
  /*		ASSIGN OUTPUTS TO REGISTERS				*/
  /*									*/
  /***************************************************************************/
  assign 	buf_ctrl_1 = {
	  			bc_cr_r,	// [14]
				bc_sen_r,	// [13]
				bc_co_r,	// [12]
				bc_cs_r,	// [11]
				hform_r,	// [10:9]
				bc_de_ps_r, 	// [8:7]
				bc_nc_r,	// [6:5]
				bc_org_md_r,	// [4] 
				bc_8pg_r,	// [3]
				key_ctrl_r	// [2:0]
				};

  assign 	stpl_1 	= style_1[3];
  
  //
  //		REGISTER WRITE FUNCTION				       
  //		BYTE SELECTION ORDER				
  //									
  // |  31-24  | 23-16   |  15-8   |   7-0   |	
  // |hb_ben[3]|hb_ben[2]|hb_ben[1]|hb_ben[0]|	
  //
  always @* begin
    if(dlp_adr == {MEM_BCTRL, 1'b0} && !hb_csn && hb_wstrb && !hb_ben[3] && hb_din[31]) bc_cr_r = 1'b1;
    else bc_cr_r = 1'b0;
  end

  //
  // Interrupts.
  //
  always @(posedge hb_clk or negedge hb_rstn) begin
    if (!hb_rstn) intp    <= 2'b00;
    else if (!hb_ben[0] && !hb_csn && hb_wstrb && (dlp_adr == {INTM_INTP, 1'b0}))
	  intp            <= hb_din[1:0];
    else begin
		if (set_dd) intp[0] <= 1'b1;
		if (set_cl) intp[1] <= 1'b1;
	end
  end

  always @(posedge hb_clk) begin
		set_cl  <= clint ^ clint_1;
		clint_1 <= clint;
		clint   <= de_clint_tog;
		set_dd  <= ddint ^ ddint_1;
		ddint_1 <= ddint;
		ddint   <= de_ddint_tog;
		interrupt <= |(intm & intp);
	end

////////////////////////////////////////////////////////////////////////////
//
// Register Writes.
//
  always @(posedge hb_clk or negedge hb_rstn) begin
    if (!hb_rstn) begin
      opc_1        <= 4'h0;
      bc_cs_r      <= 1'b0;
      acntrl_1     <= 18'b0;
      mem_offset_1 <= 7'b0;
      sorg_upper_1 <= 4'b0;
      hdf_1        <= 3'b0;
    end else if (!hb_csn && hb_wstrb) begin
      case (dlp_adr)
	{INTM_INTP, 1'b1}: begin
	  if(!hb_ben[0]) intm	             <= hb_din[1:0];
	end
	{NA_TSORG, 1'b0}:
	  if(!hb_ben[3]) sorg_upper_1        <= hb_din[31:28];
	{MEM_BCTRL, 1'b0}: begin
	  if(!hb_ben[3]) bc_co_r             <= hb_din[30];
	  if(!hb_ben[3]) bc_cs_r             <= hb_din[29];
	  if(!hb_ben[3]) hform_r             <= hb_din[27:26];
	  if(!hb_ben[3]) bc_de_ps_r          <= hb_din[25:24];
	  if(!hb_ben[1]) bc_org_md_r         <= hb_din[15];
	  if(!hb_ben[1]) bc_sen_r            <= hb_din[8];
	  if(!hb_ben[0]) {bc_lvl_1,bc_8pg_r} <= hb_din[7:5];
	  if(!hb_ben[0]) key_ctrl_r          <= hb_din[2:0];
	end
	{MEM_BCTRL, 1'b1}: begin
	  if(!hb_ben[3]) mem_offset_1        <= hb_din[31:25];
	end
	{DORG_SORG, 1'b0}: begin
	  if(!hb_ben[0]) sorg_1[7:0]         <= hb_din[7:0];
	  if(!hb_ben[1]) sorg_1[15:8]        <= hb_din[15:8];
	  if(!hb_ben[2]) sorg_1[23:16]       <= hb_din[23:16];
	  if(!hb_ben[3]) sorg_1[31:24]       <= hb_din[31:24];
	end
	{DORG_SORG, 1'b1}: begin
	  if(!hb_ben[0]) dorg_1[7:0]         <= hb_din[7:0];
	  if(!hb_ben[1]) dorg_1[15:8]        <= hb_din[15:8];
	  if(!hb_ben[2]) dorg_1[23:16]       <= hb_din[23:16];
	  if(!hb_ben[3]) dorg_1[31:24]       <= hb_din[31:24];
	end
	{DPTCH_SPTCH, 1'b0}: begin
	  if(!hb_ben[0]) sptch_1[3:0]        <= hb_din[7:4];
	  if(!hb_ben[1]) sptch_1[11:4]       <= hb_din[15:8];
	end
	{DPTCH_SPTCH, 1'b1}: begin
	  if(!hb_ben[0]) dptch_1[3:0]        <= hb_din[7:4];
	  if(!hb_ben[1]) dptch_1[11:4]       <= hb_din[15:8];
	end
	{CMDR, 1'b0}, {ACNTRL_CMD, 1'b0}: begin
	  if(!hb_ben[0]) opc_1               <= hb_din[3:0];
 	  if(!hb_ben[1]) rop_1               <= hb_din[11:8]; 
	  if(!hb_ben[2]) {clp_1,style_1}     <= hb_din[23:16]; 
	  if(!hb_ben[3]) {hdf_1,patrn_1}     <= hb_din[30:24];
	end
	{ROP_OPC, 1'b0}:
	  if(!hb_ben[0]) opc_1               <= hb_din[3:0];
	{ROP_OPC, 1'b1}:
	  if(!hb_ben[0]) rop_1               <= hb_din[3:0];
	{PATRN_STYLE, 1'b0}:
	  if(!hb_ben[0]) style_1             <= hb_din[4:0];
	{PATRN_STYLE, 1'b1}:
	  if(!hb_ben[0]) patrn_1             <= hb_din[3:0];
	{SFD_CLP, 1'b0}:
	  if(!hb_ben[0]) clp_1               <= hb_din[2:0];
	{SFD_CLP, 1'b1}:
	  if(!hb_ben[0]) hdf_1               <= hb_din[2:0];
	{BACK_FORE, 1'b0}: begin
	  if(!hb_ben[0]) fore_1[7:0]         <= hb_din[7:0];
	  if(!hb_ben[1]) fore_1[15:8]        <= hb_din[15:8];
	  if(!hb_ben[2]) fore_1[23:16]       <= hb_din[23:16];
	  if(!hb_ben[3]) fore_1[31:24]       <= hb_din[31:24];
	end
	{BACK_FORE, 1'b1}: begin
	  if(!hb_ben[0]) back_1[7:0]         <= hb_din[7:0];
	  if(!hb_ben[1]) back_1[15:8]        <= hb_din[15:8];
	  if(!hb_ben[2]) back_1[23:16]       <= hb_din[23:16];
	  if(!hb_ben[3]) back_1[31:24]       <= hb_din[31:24];
	end
	{DEKEY_MASK, 1'b0}: begin
	  // The plane mask now operates on the byte level.
	  // If any bit is set in a byte then unmask the whole byte
	  if(!hb_ben[0]) mask_1[0]           <= |hb_din[7:0];
	  if(!hb_ben[1]) mask_1[1]           <= |hb_din[15:8];
	  if(!hb_ben[2]) mask_1[2]           <= |hb_din[23:16];
	  if(!hb_ben[3]) mask_1[3]           <= |hb_din[31:24];
	end
	{DEKEY_MASK, 1'b1}: begin
	  if(!hb_ben[0]) de_key_1[7:0]       <= hb_din[7:0];
	  if(!hb_ben[1]) de_key_1[15:8]      <= hb_din[15:8];
	  if(!hb_ben[2]) de_key_1[23:16]     <= hb_din[23:16];
	end
	{PCTRL_LPAT, 1'b0}: begin
	  if(!hb_ben[0]) lpat_1[7:0]         <= hb_din[7:0];
	  if(!hb_ben[1]) lpat_1[15:8]        <= hb_din[15:8];
	  if(!hb_ben[2]) lpat_1[23:16]       <= hb_din[23:16];
	  if(!hb_ben[3]) lpat_1[31:24]       <= hb_din[31:24];
	end
	{PCTRL_LPAT, 1'b1}: begin
	  if(!hb_ben[0]) pctrl_1[7:0]        <= hb_din[7:0];
	  if(!hb_ben[1]) pctrl_1[15:8]       <= hb_din[15:8];
	end
	{CLPBR_CLPTL, 1'b0}: begin
	  if(!hb_ben[0]) clptl_1[7:0]        <= hb_din[7:0];
	  if(!hb_ben[1]) clptl_1[15:8]       <= hb_din[15:8];
	  if(!hb_ben[2]) clptl_1[23:16]      <= hb_din[23:16];
	  if(!hb_ben[3]) clptl_1[31:24]      <= hb_din[31:24];
	end
	{CLPBR_CLPTL, 1'b1}: begin
	  if(!hb_ben[0]) clpbr_1[7:0]        <= hb_din[7:0];
	  if(!hb_ben[1]) clpbr_1[15:8]       <= hb_din[15:8];
	  if(!hb_ben[2]) clpbr_1[23:16]      <= hb_din[23:16];
	  if(!hb_ben[3]) clpbr_1[31:24]      <= hb_din[31:24];
	end
	{XY1_XY0, 1'b0}: begin
	  if(!hb_ben[0]) xy0_1[7:0]          <= hb_din[7:0];
	  if(!hb_ben[1]) xy0_1[15:8]         <= hb_din[15:8];
	  if(!hb_ben[2]) xy0_1[23:16]        <= hb_din[23:16];
	  if(!hb_ben[3]) xy0_1[31:24]        <= hb_din[31:24];
	end
	{XY1_XY0, 1'b1}: begin
	  if(!hb_ben[0]) xy1_1[7:0]          <= hb_din[7:0];
	  if(!hb_ben[1]) xy1_1[15:8]         <= hb_din[15:8];
	  if(!hb_ben[2]) xy1_1[23:16]        <= hb_din[23:16];
	  if(!hb_ben[3]) xy1_1[31:24]        <= hb_din[31:24];
	end
	{XY3_XY2, 1'b0}: begin
	  if(!hb_ben[0]) xy2_1[7:0]          <= hb_din[7:0];
	  if(!hb_ben[1]) xy2_1[15:8]         <= hb_din[15:8];
	  if(!hb_ben[2]) xy2_1[23:16]        <= hb_din[23:16];
	  if(!hb_ben[3]) xy2_1[31:24]        <= hb_din[31:24];
	end
	{XY3_XY2, 1'b1}: begin
	  if(!hb_ben[0]) xy3_1[7:0]          <= hb_din[7:0];
	  if(!hb_ben[1]) xy3_1[15:8]         <= hb_din[15:8];
	  if(!hb_ben[2]) xy3_1[23:16]        <= hb_din[23:16];
	  if(!hb_ben[3]) xy3_1[31:24]        <= hb_din[31:24];
	end
	{NA_XY4, 1'b0}: begin
	  if(!hb_ben[0]) xy4_1[7:0]          <= hb_din[7:0];
	  if(!hb_ben[1]) xy4_1[15:8]         <= hb_din[15:8];
	  if(!hb_ben[2]) xy4_1[23:16]        <= hb_din[23:16];
	  if(!hb_ben[3]) xy4_1[31:24]        <= hb_din[31:24];
	end
	{TBOARD_ALPHA, 1'b0}: begin
	  if(!hb_ben[0]) alpha_1[7:0]        <= hb_din[7:0];
	  if(!hb_ben[1]) alpha_1[15:8]       <= hb_din[15:8];
	end
	{ACNTRL_CMD, 1'b1}: begin
	  if(!hb_ben[0]) acntrl_1[7:0]       <= hb_din[7:0];// dst(4), src(4)
	  if(!hb_ben[1]) acntrl_1[10:8]      <= hb_din[10:8];  // 
	  if(!hb_ben[2]) acntrl_1[14:11]     <= hb_din[20:16];  // 
	  if(!hb_ben[3]) acntrl_1[17:15]     <= hb_din[26:24];  // 
	end
      endcase // case(dlp_adr)
    end
  end // always @ (posedge hb_clk)
  
  /***************************************************************************/
  /*		LATCH THE COMMAND TRIGGER				*/
  /***************************************************************************/

  // Hit XY1 or CP1 and not in 3D line or Triangle
  always @* cmd_trig_comb = (!hb_csn && hb_wstrb && (dlp_adr == {XY1_XY0, 1'b1}) && !hb_ben[3]) ||
			    // Hit 3D trigger
  			    (!hb_csn && hb_wstrb && (dlp_adr == {TRG3D_CP24, 1'b1}) && !hb_ben[3] && en_3d);
  
  //
  // Busy to the host goes active right away.
  //
  always @(posedge hb_clk or negedge hb_rstn) begin
    if (!hb_rstn)           busy_hb <= 1'b0;
    else if (hb_cmdclr)     busy_hb <= 1'b0;
    else if (cmd_trig_comb) busy_hb <= 1'b1;
  end

 //
 //Once the dispatcher accepts the command the cmdack is sent back.
 // This toggles "hb_cmdclr_ddd"
  always @(posedge de_clk or negedge hb_rstn) begin
    if (!hb_rstn)    hb_cmdclr_ddd <= 1'b0;
    else if (cmdack) hb_cmdclr_ddd <= ~hb_cmdclr_ddd;
  end

  // Syncronize the command clear toggle
  always @(posedge hb_clk) begin
    hb_cmdclr_dd <= hb_cmdclr_ddd;
    hb_cmdclr_d <= hb_cmdclr_dd;
  end

 // Generate host bus command clear signal. 
 // This clears "busy_hb".
  assign hb_cmdclr = hb_cmdclr_d ^ hb_cmdclr_dd;

  always @(posedge hb_clk, negedge hb_rstn) begin
    if (!hb_rstn)           hcmd_rdy_tog <= 1'b0;
    else if (cmd_trig_comb) hcmd_rdy_tog <= ~hcmd_rdy_tog;
  end

  // Syncronize command ready.
  always @(posedge de_clk, negedge de_rstn) begin
    if(!de_rstn)   	          cmdrdy <= 1'b0;
    else if(cmdrdy_rr ^ cmdrdy_r) cmdrdy <= 1'b1;
    else if(cmdack)   	          cmdrdy <= 1'b0;
  end

  // Syncronize command ready.
  always @(posedge de_clk) begin
    cmdrdy_rr <= cmdrdy_r;
    cmdrdy_r  <= hcmd_rdy_tog;
  end

  //////////////////////////////////////////////////////////////////////////////
  // Simulation debug stuff. 
  `ifdef RTL_SIM
  always @* begin
    if (cmdack) begin
      case (opc_1)
	4'h0:
	  $display($stime, " Executing NOP\n");
	4'h1: begin
	  $display($stime, " Executing BitBlt\n");
	  $display("\t\tFORE:  %h", fore_1);
	  $display("\t\tBACK:  %h", back_1);
	  $display("\t\tXY0:   %h", xy0_1);
	  $display("\t\tXY1:   %h", xy1_1);
	  $display("\t\tXY2:   %h", xy2_1);
	  $display("\t\tXY3:   %h", xy3_1);
	  $display("\t\tXY4:   %h", xy4_1);
	end
	4'h2: begin
	  $display($stime, " Executing Line\n");
	  $display("\t\tFORE:  %h", fore_1);
	  $display("\t\tBACK:  %h", back_1);
	  $display("\t\tXY0:   %h", xy0_1);
	  $display("\t\tXY1:   %h", xy1_1);
	end
	4'h3: begin
	  $display($stime, " Executing ELine\n");
	  $display("\t\tFORE:  %h", fore_1);
	  $display("\t\tBACK:  %h", back_1);
	  $display("\t\tXY0:   %h", xy0_1);
	  $display("\t\tXY1:   %h", xy1_1);
	  $display("\t\tXY2:   %h", xy2_1);
	  $display("\t\tXY3:   %h", xy3_1);
	end
	4'h5: begin
	  $display($stime, " Executing PLine\n");
	  $display("\t\tFORE:  %h", fore_1);
	  $display("\t\tBACK:  %h", back_1);
	  $display("\t\tXY0:   %h", xy0_1);
	end
	4'h6: begin
	  $display($stime, " Obsolete OPCODE RXFER\n");
	end
	4'h7: begin
	  $display($stime, " Obsolete OPCODE WXFER\n");
	end
	4'h8: begin
	  $display($stime, " Executing 3D Line\n");
	  $display("\t\tFORE:  %h", fore_1);
	  $display("\t\tBACK:  %h", back_1);
	  $display("\t\tXY0:   %h", xy0_1);
	end
	4'h9: begin
	  $display($stime, " Executing 3D Triangle\n");
	  $display("\t\tFORE:  %h", fore_1);
	  $display("\t\tBACK:  %h", back_1);
	  $display("\t\tXY0:   %h", xy0_1);
	end
	default:
	  $display($stime, " Undefined Opcode\n");
      endcase // case (rop)
    end // if (cmdack)
  end // always @ *
  `endif

endmodule
