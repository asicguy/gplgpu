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
//  Title       :  Stimulus parameters
//  File        :  stim_params_sh.h
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  This file contains all of the parameters required for the simulation
//  environment.		                                        
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

 parameter
 
  `ifdef GATE_LEVEL
     //Thld        = 2.0, //hold time for gate level
    `ifdef PLAY_HOLD
     Thld        = 2.0, //hold time for gate level SDF to adjust PCI delay
    `else
     Thld        = 1.25, //hold time for gate level temp.value 
    `endif


   `else
     Thld        = 0.8, //hold time for hdl
   `endif

       //  Thld        = 2,  //clk to control signal hold time

         PCI       = 2'h0,
         ZERO_WAIT = 2'h0,
         ONE_WAIT  = 2'h1,
         TWO_WAIT  = 2'h2,
         THREE_WAIT= 2'h3,
 
         DISABLE   = 1'b1,
         ENABLE    = 1'b0,
         NOT_SELECTED = 1'b1,
         SELECTED     = 1'b0,

`ifdef PCI_TSU
Tsu = `PCI_TSU,
`else
         Tsu         = 7,  //clk to control signal setup time
`endif
         VLtsu       = 7,
         VLthld      = 2,
         DOG_TIMER   = 999,
         PRDY_TIMER = 2,

//         D32       = 0,
//         D64       = 1,

         INT_ACK       = 4'b0000,
         SP_CYCLE      = 4'b0001,
         IO_RD         = 4'b0010,
         IO_WR         = 4'b0011,
         RESV1         = 4'b0100,
         RESV2         = 4'b0101,
         MEM_RD        = 4'b0110,
         MEM_WR        = 4'b0111,
         RESV3         = 4'b1000,
         RESV4         = 4'b1001,
         CONFIG_RD     = 4'b1010,
         CONFIG_WR     = 4'b1011,
         MEM_RD_MULTI  = 4'b1100,
         DUAL_ADDR     = 4'b1101,
         MEM_RD_LINE   = 4'b1110,
         MEM_WR_INV    = 4'b1111;
/********************************************************/
/* DEFINE CLOCK PARAMETERS.				*/
/********************************************************/
//moved to local xxx_run/clks_params.h files

/****************************************************************/
/* 		DEFINE SET CONFIGURATION FIELDS			*/
/*			( New Definitions) 			*/

parameter
		BASE0_1	 = 6'h0,	// Base reg. 0 and 1 size
		EE	 = 6'h1,	// EPROM Enable
		CLASS	 = 6'h2,	// PCI Class	
		VDEN	 = 6'h3,	// RAM Density	
		IDAC	 = 6'h4,	// INTERNAL/EXTERNAL RAMDAC 
		SGRAM	 = 6'h5,	// SGRAM/WINRAM 	
		HBT	 = 6'h6,	// Host Bus type
                SUB_ID   = 6'h7,
                ID_DEF   = 6'h8,       //FIXED/STRAPPED VENDOR ID
                SUB_VID  = 6'h9,
		PULLUP	 = 6'ha,
                CLEAR    = 6'hb,	
		ALL	 = 6'hc,       // all straps to be set at once 	

/********************************************************/
/* DEFINE IO MAPPED GLOBAL REGISTER ADDRESS OFFSETS.	*/
		RBASE_G	   = 8'h0,
		RBASE_W	   = 8'h4,
		RBASE_A	   = 8'h8,
		RBASE_B	   = 8'hC,
		RBASE_I	   = 8'h10,
		RBASE_E	   = 8'h14,
		ID	   = 8'h18,
		CONFIG1	   = 8'h1C,
		CONFIG2	   = 8'h20,
		SGR_CONFIG = 8'h24,
		SSWTCH	   = 8'h28;
/******************************************************************************/
/* 		DEFINE MEMORY MAPPED GLOBAL REGISTER ADDRESS OFFSETS.	      */
/******************************************************************************/
parameter
		WR_ADR		= 8'h00,
		PAL_DAT		= 8'h04,
		PEL_MASK	= 8'h08,
		RD_ADR		= 8'h0C,
		RESERVED1	= 8'h10,		
		RESERVED2	= 8'h14,		
		INDEX_TI	= 8'h18,	/* viewpoint index register. */
		DATA_TI		= 8'h1C,	/* viewpoint data register. */
		INT_VCNT	= 8'h20,		
		INT_HCNT	= 8'h24,		
		DB_ADR		= 8'h28,		
		DB_PTCH		= 8'h2C,		
		CRT_HAC		= 8'h30,		
		CRT_HBL		= 8'h34,		
		CRT_HFP		= 8'h38,		
		CRT_HS		= 8'h3C,		
		CRT_VAC		= 8'h40,		
		CRT_VBL		= 8'h44,		
		CRT_VFP		= 8'h48,		
		CRT_VS		= 8'h4C,		
		CRT_BORD	= 8'h50, //old for compatibility with older test
		CRT_LCNT	= 8'h50, // new		
		CRT_ZOOM	= 8'h54,		
		CRT_1CON	= 8'h58,		
		CRT_2CON	= 8'h5C,
		DB_ADR2		= 8'h60;		

//VP_1CON		= 8'h60,		
//VP_MASK		= 8'h64,		
//VP_2CON		= 8'h68,		
//VP_ZERO		= 8'h6C,		
//VP_TCOL		= 8'h70,		
//VP_3CON		= 8'h74,		
//VP_STRT		= 8'h78,		
//VP_SIZE		= 8'h7C,		
//VP_XYOFFS	= 8'h80,		
//VP_PGE		= 8'h84,		
//VP_SORG		= 8'h88,		
//VP_DORG		= 8'h8C,		
//VP_WSRC		= 8'h90,		
//VP_COMP		= 8'h94,		
//VP_YINT		= 8'h98,		
//VP_FLDINT	= 8'h9C,		
//VP_SPTCH	= 8'hA0,		
//VP_DPTCH	= 8'hA4,		
//VP_DEC		= 8'hA8;		
//		reserved	= 8'hAC,		

/******************************************************************************/
/* 	DEFINE MEMORY MAPPED GLOBAL INTERRUPT REGISTER ADDRESS OFFSETS.	      */
/******************************************************************************/
parameter
		GINTP		= 8'h00,		
		GINTM		= 8'h04;		
/******************************************************************************/
/* 		DEFINE MEMORY MAPPED MEMORY WINDOWS REGISTER ADDRESS OFFSETS. */
/******************************************************************************/
parameter
		MW0_CTRL	= 8'h00,		
		MW0_AD		= 8'h04,		
		MW0_SZ		= 8'h08,		
		MW0_PGE		= 8'h0C, //now reserved
		MW0_ORG		= 8'h10,
		MW0_WSRC	= 8'h18, //now reserved
		MW0_MSRC	= 8'h18, //now reserved
		MW0_WKEY	= 8'h1C, //now reserved
		MW0_KYDAT	= 8'h20, //now reserved
		MW0_MASK	= 8'h24,		
		MW1_CTRL	= 8'h28,		
		MW1_AD		= 8'h2C,		
		MW1_SZ		= 8'h30,		
		MW1_PGE		= 8'h34, //now reserved
		MW1_ORG		= 8'h38,		
		MW1_WSRC	= 8'h40, //now reserved
		MW1_MSRC	= 8'h40, //now reserved
		MW1_WKEY	= 8'h44, //now reserved
		MW1_KYDAT	= 8'h48, //now reserved
		MW1_MASK	= 8'h4C,		
                MWC_FLSH        = 8'h54,
                YUV_ADR         = 8'h58,
                YUV_DAT         = 8'h60;
/******************************************************************************/
/* 		DEFINE MEMORY MAPPED DRAWING REGISTER ADDRESS OFFSETS.	      */
/******************************************************************************/
parameter
		INTP		= 9'h00,		
		INTM		= 9'h04,		
		FLOW		= 9'h08,		
		BUSY		= 9'h0C,		
		XYC_AD		= 9'h10,		
		XYW_AD		= 9'h10,		
//		reserved	= 9'h14,		
//		reserved	= 9'h18,		
//		reserved	= 9'h1C,		
		BUF_CTRL	= 9'h20,		
//		reserved	= 9'h24,		
		DE_SORG		= 9'h28,		
		DE_DORG		= 9'h2C,		
//		reserved	= 9'h30,		
//		reserved	= 9'h34,		
		DE_TPTCH	= 9'h38,		
		DE_ZPTCH	= 9'h3C,		
		DE_SPTCH	= 9'h40,		
		DE_DPTCH	= 9'h44,		
		CMD		= 9'h48,		
//		reserved	= 9'h4C,		
		CMD_OPC		= 9'h50,		
		CMD_ROP		= 9'h54,		
		CMD_STYLE	= 9'h58,		
		CMD_PATRN	= 9'h5C,		
		CMD_CLP		= 9'h60,		
		CMD_PF		= 9'h64,		
		CMD_HDF		= 9'h64,		
	        FORE		= 9'h68,		
		BACK		= 9'h6C,		
		MASK		= 9'h70,		
		DE_KEY		= 9'h74,		
		LPAT		= 9'h78,		
		PCTRL		= 9'h7C,		
		CLPTL		= 9'h80,		
		CLPBR		= 9'h84,		
		XY0		= 9'h88,		
		XY1		= 9'h8C,		
		XY2		= 9'h90,		
		XY3		= 9'h94,		
		XY4		= 9'h98,		
//		reserved        = 8'h9C,
//              reserved	= 9'hA0,		
//		reserved        = 9'hA4,
//              reserved    	= 9'hA8,		
//              reserved        = 9'hAC,
//              reserved        = 9'hB0,
//              reserved        = 9'hB4,
//              reserved	= 9'hB8,		
//		reserved        = 9'hBC,
//              reserved    	= 9'hC0,		
//              reserved        = 9'hC4,
//              reserved        = 9'hC8,
//              reserved        = 9'hCC,
		LOD0_ORG	= 9'hD0,		
		LOD1_ORG	= 9'hD4,		
		LOD2_ORG	= 9'hD8,		
		LOD3_ORG	= 9'hDC,		
		LOD4_ORG	= 9'hE0,		
                LOD5_ORG        = 9'hE4,
                LOD6_ORG	= 9'hE8,		
		LOD7_ORG        = 9'hEC,
                LOD8_ORG        = 9'hF0,
                LOD9_ORG        = 9'hF4,
                DLP_ADR         = 9'hF8,
                DLP_CTRL        = 9'hFC,
                DE_ZORG		= 9'h100,		
//		reserved	= 9'h104,		
//		reserved	= 9'h108,		
//		reserved	= 9'h10C,		
//		reserved	= 9'h110,		
//		reserved	= 9'h114,		
		TPAL_ORG	= 9'h118,	       
		HITH		= 9'h11C,		
                YON	        = 9'h120,		
		FOG_COL		= 9'h124,		
		ALPHA		= 9'h128,		
		TBORDER		= 9'h12C,		
		V0A_FL		= 9'h130,		
		V0R_FL		= 9'h134,		
		V0G_FL		= 9'h138,		
		V0B_FL		= 9'h13C,		
		V1A_FL		= 9'h140,		
		V1R_FL		= 9'h144,		
		V1G_FL		= 9'h148,		
		V1B_FL		= 9'h14C,		
		V2A_FL		= 9'h150,		
		V2R_FL		= 9'h154,		
		V2G_FL		= 9'h158,		
		V2B_FL		= 9'h15C,		
		KEY3D_LO	= 9'h160,		
		KEY3D_HI	= 9'h164,		
		CMD3		= 9'h168,		
		A_CNTRL		= 9'h16C,		
		ACNTRL		= 9'h16C,		
		I3D_CNTRL	= 9'h170,		
		TEX_CNTRL	= 9'h174,		
		CP0		= 9'h178,		
		CP1		= 9'h17C,		
		CP2		= 9'h180,		
		CP3		= 9'h184,		
		CP4		= 9'h188,		
		CP5		= 9'h18C,		
		CP6		= 9'h190,		
		CP7		= 9'h194,		
		CP8		= 9'h198,		
		CP9		= 9'h19C,		
		CP10		= 9'h1A0,		
		CP11		= 9'h1A4,		
		CP12		= 9'h1A8,		
		CP13		= 9'h1AC,		
		CP14		= 9'h1B0,		
		CP15		= 9'h1B4,		
		CP16		= 9'h1B8,		
		CP17		= 9'h1BC,		
		CP18		= 9'h1C0,		
		CP19		= 9'h1C4,		
		CP20		= 9'h1C8,		
		CP21		= 9'h1CC,		
		CP22		= 9'h1D0,		
		CP23		= 9'h1D4,		
		CP24		= 9'h1D8,		
		I3D_TRIG	= 9'h1DC,
 		GLBLENDC        = 9'h1E0;
//		Reserved	= 9'h1E4,		
//		Reserved	= 9'h1E8,		
//		Reserved	= 9'h1EC,		
//		Reserved	= 9'h1F0,		
//		Reserved	= 9'h1F4,		
//		Reserved	= 9'h1F8,		
//		reserved	= 9'h1FC;		
/******************************************************************************/
/* 		END						              */
/******************************************************************************/
parameter

		B_4M		= 2'b00,
		B_8M		= 2'b01,
		B_16M		= 2'b10,
		B_32M		= 2'b11,
		P_32K		= 3'b000,
		P_64K		= 3'b001,
		No_PROM		= 1'b0,
		PROM		= 1'b1,
		M_256K		= 2'b01,
		M_16M  		= 2'b10,
		M_WI  		= 2'b10,
		AGP_CONFIG 	= 1'b0,
		PCI_CONFIG 	= 1'b1,
		PCI_VGA  	= 1'b0,
		PCI_OTHR  	= 1'b1,
		VGA_OFF  	= 1'b0,
		VGA_ON  	= 1'b1,
		SNOOP_OFF  	= 1'b0,
		SNOOP_ON  	= 1'b1,
		SHORT  		= 1'b0,
		LONG  		= 1'b1;
/******************************************************************************/
/* 		DEFINE MEMORY MAPPED MEMORY WINDOWS REGISTER CONTENTS.        */
/******************************************************************************/
// Memory Windows Control Register
parameter
  MW_CTL_WC_ON     = 32'h00_00_00_00,
  MW_CTL_WC_OFF    = 32'h00_00_00_40,
  MW_CTL_NO_SWAP   = 32'h00_00_00_00,
  MW_CTL_BIT_SWAP  = 32'h00_01_00_00,
  MW_CTL_BYTE_SWAP = 32'h00_02_00_00,
  MW_CTL_WORD_SWAP = 32'h00_04_00_00,
  MW_CTL_CSC_OFF   = 32'h00_00_00_00,
  MW_CTL_CSC_ON    = 32'h00_10_00_00,
  MW_CTL_YCRCB     = 32'h00_00_00_00,
  MW_CTL_YUV       = 32'h00_40_00_00,
  MW_CTL_422       = 32'h00_00_00_00,
  MW_CTL_444       = 32'h00_80_00_00,
  MW_CTL_8BPP      = 32'h00_00_00_00,
  MW_CTL_16BPP_555 = 32'h04_00_00_00,
  MW_CTL_16BPP_565 = 32'h04_08_00_00,
  MW_CTL_32BPP     = 32'h08_00_00_00,
  MW_CTL_DEF_OFF   = 32'h00_00_00_00,
  MW_CTL_DEF_ON    = 32'h20_00_00_00,
  MW_CTL_CRTF_OFF  = 32'h00_00_00_00,
  MW_CTL_CRTF_ON   = 32'h40_00_00_00,
  MW_CTL_RC_ON     = 32'h00_00_00_00,
  MW_CTL_RC_OFF    = 32'h80_00_00_00;

// Memory Windows Size Register
parameter
  MW_SZ_4K   = 32'h0000000_0,
  MW_SZ_8K   = 32'h0000000_1,
  MW_SZ_16K  = 32'h0000000_2,
  MW_SZ_32K  = 32'h0000000_3,
  MW_SZ_64K  = 32'h0000000_4,
  MW_SZ_128K = 32'h0000000_5,
  MW_SZ_246K = 32'h0000000_6,
  MW_SZ_512K = 32'h0000000_7,
  MW_SZ_1M   = 32'h0000000_8,
  MW_SZ_2M   = 32'h0000000_9,
  MW_SZ_4M   = 32'h0000000_a,
  MW_SZ_8M   = 32'h0000000_b,
  MW_SZ_16M  = 32'h0000000_c,
  MW_SZ_32M  = 32'h0000000_d;

/******************************************************************************/
/* 		DEFINE CONFIG1  REGISTER CONTENTS.                            */
/******************************************************************************/
parameter
  CFG1_SOFTRESET = 32'h00_00_00_02,
  CFG1_EG        = 32'h00_00_01_00,
  CFG1_EW        = 32'h00_00_02_00,
  CFG1_ED        = 32'h00_00_04_00,
  CFG1_EI        = 32'h00_00_10_00,
  CFG1_EE        = 32'h00_00_20_00,
  CFG1_EW0       = 32'h00_01_00_00,
  CFG1_EW1       = 32'h00_02_00_00,
  CFG1_EXA       = 32'h00_10_00_00;
