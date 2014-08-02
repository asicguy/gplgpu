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
//  This is the top level of the Guru core graphics logic. 
//  This file encompasses the IP for the Guru series of Display controllers. 
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//    U_HBI         hbi_top        Host interface (PCI)
//    U_VGA         vga_top        IBM(TM) Compatible VGA core
//    U_DE          de_top         Drawing engine
//    U_DLP         dlp_top        Display List Processor
//    U_DDR3        DDR3           DDR3 Memory interface
//    u_crt         crt_top        Display interface
//    u_ramdac      ramdac         Digital DAC
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
//
///////////////////////////////////////////////////////////////////////////////
`define   CRX_ADDR_M    (16'h03b4)   // CRTC Index Register in monochrome mode
`define   CR_ADDR_M     (16'h03b5)   // CRTC Data Registers in monochrome mode
`define   CRX_ADDR_C    (16'h03d4)   // CRTC Index Register in color mode
`define   CR_ADDR_C     (16'h03d5)   // CRTC Data Registers in color mode
`define   ERX_ADDR      (16'h03ce)   // Extension Registers Index     
`define   ER_ADDR       (16'h03cf)   // Extension Data Registers  
`define   AR_WR_ADDR    (16'h03c0)   // Atribute Controller Registers Index
`define   AR_RD_ADDR    (16'h03c1)   // Atribute Controller Data Registers
`define   SRX_ADDR      (16'h03c4)   // Sequencer Registers Index
`define   SR_ADDR       (16'h03c5)   // Sequencer  Data Registers
`define   GRX_ADDR      (16'h03ce)   // Graphic Controller Registers Index
`define   GR_ADDR       (16'h03cf)   // Graphics Controller Data Registers
`define   RDACX_ADDR    (16'h03c8)   // RAMDAC Index Register
`define   RDAC_ADDR     (16'h03c9)   // RAMDAC Data Register

/*------------------------------------------------------------------------------*/
/*
 -- Index for General Registers
*/
/*------------------------------------------------------------------------------*/

`define   MISC_RD_ADDR    (16'h03cc)   // Miscellaneous output Register Rd addr.
`define   MISC_WR_ADDR    (16'h03c2)   // Miscellaneous output Register Wr addr.
`define   INS0_RD_ADDR    (16'h03c2)   // Input Status Register Rd addr.
`define   INS1_RD_ADDR_M  (16'h03ba)   //Input Status Register Rd addr.
`define   INS1_RD_ADDR_C  (16'h03da)   //Input Status Register Rd addr.
`define   FCR_RD_ADDR     (16'h03ca)   // Feature Control Register Rd addr.
`define   FC_WR_ADDR_M    (16'h03ba)   //Feature Control Register Rd addr.
`define   FC_WR_ADDR_C    (16'h03da)   //Feature Control Register Rd addr.

/*------------------------------------------------------------------------------*/
/*
 -- Index for CR Registers from CR00 to CR22 
*/
/*------------------------------------------------------------------------------*/

`define   CR00_INDEX   (8'h00)
`define   CR01_INDEX   (8'h01)
`define   CR02_INDEX   (8'h02)
`define   CR03_INDEX   (8'h03)
`define   CR04_INDEX   (8'h04)
`define   CR05_INDEX   (8'h05)
`define   CR06_INDEX   (8'h06)
`define   CR07_INDEX   (8'h07)
`define   CR08_INDEX   (8'h08)
`define   CR09_INDEX   (8'h09)
`define   CR0A_INDEX   (8'h0a)
`define   CR0B_INDEX   (8'h0b)
`define   CR0C_INDEX   (8'h0c)
`define   CR0D_INDEX   (8'h0d)
`define   CR0E_INDEX   (8'h0e)
`define   CR0F_INDEX   (8'h0f)
`define   CR10_INDEX   (8'h10)
`define   CR11_INDEX   (8'h11)
`define   CR12_INDEX   (8'h12)
`define   CR13_INDEX   (8'h13)
`define   CR14_INDEX   (8'h14)
`define   CR15_INDEX   (8'h15)
`define   CR16_INDEX   (8'h16)
`define   CR17_INDEX   (8'h17)
`define   CR18_INDEX   (8'h18)
`define   CR22_INDEX   (8'h22)
`define   CR24_INDEX   (8'h24)
`define   CR26_INDEX   (8'h26)

/*------------------------------------------------------------------------------*/
/*
 -- Index for SR Registers from SR00 to SR04
*/
/*------------------------------------------------------------------------------*/

`define   SR00_INDEX   (8'h00)
`define   SR01_INDEX   (8'h01)
`define   SR02_INDEX   (8'h02)
`define   SR03_INDEX   (8'h03)
`define   SR04_INDEX   (8'h04)
`define   SR06_INDEX   (8'h06)
`define   SR07_INDEX   (8'h07)

/*------------------------------------------------------------------------------*/
/*
 -- Index for GR Registers from GR00 to GR04
*/
/*------------------------------------------------------------------------------*/

`define   GR00_INDEX   (8'h00)
`define   GR01_INDEX   (8'h01)
`define   GR02_INDEX   (8'h02)
`define   GR03_INDEX   (8'h03)
`define   GR04_INDEX   (8'h04)
`define   GR05_INDEX   (8'h05)
`define   GR06_INDEX   (8'h06)
`define   GR07_INDEX   (8'h07)
`define   GR08_INDEX   (8'h08)

/*------------------------------------------------------------------------------*/
/*
 -- Index for AR Registers from AR00 to AR14
*/
/*------------------------------------------------------------------------------*/

`define   AR00_INDEX    (8'h00)
`define   AR01_INDEX    (8'h01)
`define   AR02_INDEX    (8'h02)
`define   AR03_INDEX    (8'h03)
`define   AR04_INDEX    (8'h04)
`define   AR05_INDEX    (8'h05)
`define   AR06_INDEX    (8'h06)
`define   AR07_INDEX    (8'h07)
`define   AR08_INDEX    (8'h08)
`define   AR09_INDEX    (8'h09)
`define   AR0A_INDEX    (8'h0A)
`define   AR0B_INDEX    (8'h0B)
`define   AR0C_INDEX    (8'h0C)
`define   AR0D_INDEX    (8'h0D)
`define   AR0E_INDEX    (8'h0E)
`define   AR0F_INDEX    (8'h0F)
`define   AR10_INDEX    (8'h10)
`define   AR11_INDEX    (8'h11)
`define   AR12_INDEX    (8'h12)
`define   AR13_INDEX    (8'h13)
`define   AR14_INDEX    (8'h14)

/*------------------------------------------------------------------------------*/
/*
 -- Index for ER Registers from ER0A, ER30 to ER4F
*/
/*------------------------------------------------------------------------------*/

`define   ER0A_INDEX    (8'h0A)
`define   ER30_INDEX    (8'h30)
`define   ER31_INDEX    (8'h31)
`define   ER32_INDEX    (8'h32)
`define   ER33_INDEX    (8'h33)
`define   ER34_INDEX    (8'h34)
`define   ER35_INDEX    (8'h35)
`define   ER36_INDEX    (8'h36)
`define   ER37_INDEX    (8'h37)
`define   ER38_INDEX    (8'h38)
`define   ER39_INDEX    (8'h39)
`define   ER40_INDEX    (8'h40)
`define   ER41_INDEX    (8'h41)
`define   ER42_INDEX    (8'h42)
`define   ER43_INDEX    (8'h43)
`define   ER44_INDEX    (8'h44)
`define   ER45_INDEX    (8'h45)
`define   ER46_INDEX    (8'h46)
`define   ER47_INDEX    (8'h47)
`define   ER48_INDEX    (8'h48)
`define   ER49_INDEX    (8'h49)
`define   ER4A_INDEX    (8'h4A)
`define   ER4B_INDEX    (8'h4B)
`define   ER4C_INDEX    (8'h4C)
`define   ER4D_INDEX    (8'h4D)
`define   ER4E_INDEX    (8'h4E)
`define   ER4F_INDEX    (8'h4F)



`define   CR07_TO_CR00_WP_CLEAR_DATA (8'h00)   // bit 7 of cr11 is to be reset
`define   CR07_TO_CR00_WP_SET_DATA   (8'h80)   // bit 7 of cr11 is to be set
`define   CR07_TO_CR00_WP_MASK       (8'h80)   // bit 7 of cr11 is to be set

`define   MONO_MODE_DATA             (8'h00)   // bit 1 0f misc reg is to be set to 0
`define   MONO_MODE_MASK             (8'h01)   // bit 1 0f misc reg is to be set to 0

`define   COLOR_MODE_DATA            (8'h01)  // bit 1 0f misc reg is to be set to 1
`define   COLOR_MODE_MASK            (8'h01)  // bit 1 0f misc reg is to be set to 1

`define   S_SH_32_DATA               (8'h10)  // Bit 4 of SR01 needs to be set
`define   R_SH_32_DATA	      	     (8'h00)  // Bit 4 of SR01 needs to be reset 
`define   SH_32_MASK                 (8'h10)  // Bit 4 of SR01

`define   S_SH_16_DATA               (8'h04)  // Bit 2 of SR01 needs to be set
`define   R_SH_16_DATA               (8'h00)  // Bit 2 of SR01 needs to be reset
`define   SH_16_MASK                 (8'h04)  // Bit 2 of SR01

`define   S_PIXEL_DOUBLE_CLK_DATA    (8'h40)  // Bit 6 of AR10 need to be set
`define   R_PIXEL_DOUBLE_CLK_DATA    (8'h00)  // Bit 6 of AR10 need to be reset
`define   PIXEL_DOUBLE_CLK_MASK      (8'h40)  // Bit 6 of AR10

`define   S_DCLK_BY_2	      	     (8'h08)  // Bit 3 of SR01 needs to be set
`define   R_DCLK_BY_2                (8'h00)  // Bit 3 of SR01 needs to be reset
`define   DCLK_BY_2_MASK      	     (8'h08)  // Bit 3 of SR01

`define   S_TIME_ENABLE              (8'h80)  // Bit 7 of CR17 needs to be set
`define   R_TIME_ENABLE              (8'h00)  // Bit 7 of CR17 needs to be reset
`define   TIME_ENABLE_MASK           (8'h80)  // Bit 7 of CR17

`define   S_SCREEN_B_PAN             (8'h00)  // Bit 5 of AR10 needs to be reset
`define   R_SCREEN_B_PAN             (8'h20)  // Bit 5 of AR10 needs to be set
`define   SCREEN_B_PAN_MASK          (8'h20)  // Bit 5 of AR10 

`define   S_VIDEO_ENABLE             (8'h20)  // Bit 5 of ARX needs to be set
`define   R_VIDEO_ENABLE      	     (8'h00)  // Bit 5 of ARX needs to be reset
`define   VIDEO_ENABLE_MASK          (8'h20)  // Bit 5 of ARX

`define   S_GRAPHICS_MODE     	     (8'h01)  // Bit 0 of AR10 needs to be set
`define   S_TEXT_MODE                (8'h00)  // Bit 0 of AR10 needs to be set
`define   GRA_TXT_MODE_MASK          (8'h01)  // Bit 0 of AR10
  
`define   S_SHIFT16_CNT_BY_2         (8'h04)  // Bit 2 of SR01 needs to be set
`define   R_SHIFT16_CNT_BY_2         (8'h00)  // Bit 2 of SR01 needs to be reset
`define   SHIFT16_CNT_BY_2_MASK      (8'h04)  // Bit 2 of SR01

`define   S_SHIFT32_CNT_BY_4         (8'h10)  // Bit 4 of SR01 needs to be set
`define   R_SHIFT32_CNT_BY_4         (8'h00)  // Bit 4 of SR01 needs to be reset
`define   SHIFT32_CNT_BY_4_MASK      (8'h10)  // Bit 4 of SR01

`define   S_8_DOT_CCLK               (8'h01)  // Bit 0 of SR01 needs to be set
`define   S_9_DOT_CCLK	      	     (8'h00)  // Bit 0 of SR01 needs to be reset
`define   DOT_CCLK_8_9_MASK          (8'h01)  // Bit 0 of SR01

`define   S_SCREEN_ON                (8'h20)  // Bit 5 of SR01 needs to be set
`define   S_SCREEN_OFF               (8'h00)  // Bit 5 of SR01 needs to be reset
`define   SCREEN_OFF_MASK     	     (8'h20)  // Bit 5 of SR01

`define   S_RE_CR10_CR11      	     (8'h80)  // Bit 7 of CR03 needs to be set
`define   R_RE_CR10_CR11      	     (8'h00)  // Bit 7 of CR03 needs to be reset
`define   RE_CR10_CR11_MASK          (8'h80)  // Bit 7 of CR03

`define   MODE_0     	      	     0
`define   MODE_1                     1
`define   MODE_2     	      	     2
`define   MODE_3                     3
`define   MODE_4     	      	     4
`define   MODE_5                     5
`define   MODE_6     	      	     6
`define   MODE_7                     7
`define   MODE_D     	      	     8
`define   MODE_E                     9
`define   MODE_F     	      	     10
`define   MODE_10                    11
`define   MODE_11     	      	     12
`define   MODE_12                    13
`define   MODE_13     	      	     14
`define   MODE_0_STAR                15
`define   MODE_1_STAR 	      	     16
`define   MODE_2_STAR                17
`define   MODE_3_STAR 	      	     18
`define   MODE_F_STAR                19
`define   MODE_10_STAR               20
`define   MODE_0_1_PLUS      	     21
`define   MODE_2_3_PLUS              22
`define   MODE_7_PLUS 	      	     23

`define   NO_OF_VGA_SR_REG    	     05
`define   NO_OF_VGA_CR_REG           25
`define   NO_OF_VGA_GR_REG           09
`define   NO_OF_VGA_AR_REG           21


parameter   
   one_byte   = 2'b00,
   two_byte   = 2'b01,
   three_byte = 2'b10,
   four_byte  = 2'b11;
   
parameter
   TRI_DELAY  = 1;
   
parameter
   sr  = 16'h3c4,
   gr  = 16'h3ce,
   er  = 16'h3ce,
   cr  = 16'h3d4,  //   --- assume misc[0] is set to 1.
   ar  = 16'h3c0,
   misc_wr = 16'h3c2,
   misc_rd = 16'h3cc;

parameter
   iowr_state = 2'b00,
   iord_state = 2'b01,
   memwr_state = 2'b10,
   memrd_state = 2'b11;
   
parameter
   pclk_crt_clk        = 2'b00,
   pclk_crt_clk_by_2   = 2'b01,
   pclk_crt_clk_by_2_2 = 2'b10,
   pclk_crt_clk_by_4   = 2'b11;

   reg    [7:0]	     vga_tbl_sr[119:0]; // 24 * 5  = 120
   reg    [7:0]      vga_tbl_cr[599:0]; // 24 * 25 = 600
   reg    [7:0]      vga_tbl_gr[215:0]; // 24 * 09 = 216
   reg    [7:0]      vga_tbl_ar[503:0]; // 24 * 21 = 504
   reg    [7:0]      vga_tbl_reg_mask[59:0]; // 60 registers
   integer     	     vga_tables_read_flag;
integer     	     chan;
   integer     	     broad_cast;
   integer     	     mem_broad_cast;
   

   reg	       	   capture_flag;
   reg    [22:0]   t_haddr;
   reg    [3:0]    t_byte_en_n;
   reg       	   t_mem_io_n;
   reg             t_hrd_hwr_n;
   reg	           t_hreset_n;
   reg	           t_svga_sel;
   reg       	   t_sclk;
   reg       	   t_sense_n;
   reg    [31:0]   t_hdata_in;
 // j15  reg    [63:0]   m_t_mem_data_out;
   reg             ioread_msg_flag;
   reg	  [15:0]   io_data;
   reg             set_memrd_flag;
   reg	       	   dump_flag;
   reg [8*100:1]   dump_file_name;
   reg [8*100:1]   file_name;

   reg     [19:0]  tb_dump_sa;
   reg     [19:0]  tb_dump_ea;
   reg     [15:0]  addr;
   reg     [15:0]  data;
   reg     [15:0]  exp_data;
   reg	   [15:0]  ram_dac_read_data;
   reg     [63:0]  mem_data_read_data;


   
   wire	           t_mem_clk;
   wire       	   t_crt_clk;
   wire    [3:0]   c_t_clk_sel;
   wire      	   c_t_clk_strb;
   wire      	   c_t_cblank_n;
   wire	           c_t_hsync;
   wire	           c_t_cde;
   wire	           c_t_vsync;   
   wire	           c_t_crt_int;
   wire	           c_t_crt_int_en;
   wire	           c_t_lclk;
   wire	           h_t_ready_n;
   wire    [7:0]   a_t_pix_data;
   wire	           h_t_dac_rd_n;
   wire	           h_t_dac_wr_n;
   wire    [3:0]   h_t_dac_rs;
   wire    [7:0]   h_t_dac_data_in;
   wire    [7:0]   h_t_dac_data_out;   
   wire	           m_t_dfs;
   wire	           m_t_dt_n;
   wire    [22:3]  m_t_mem_addr;
   wire    [7:0]   m_t_mwe_n;
   wire      	   m_t_ref_n;
   wire     	   m_t_svga_req;
   wire    [5:0]   g_t_ctl_bits;
   wire    [31:0]  t_hdata_out;
   wire    [63:0]  m_t_mem_data_out;
   wire    [63:0]  m_t_mem_data_in;
   wire	       	   r_t_dac_req;
   wire            r_t_cycle_rd_wr_n;
   wire	       	   t_dac_gnt;
   wire            m_mrd_mwr_n;
   wire       	   t_svga_ack_n;
   wire	           t_data_ready_n;
   wire    [2:0]   tk_er48_2_to_0;
   wire    [10:0]  tk_vcrt_cntr_op;
   wire            tk_hblank;
   wire            tk_vblank;
   wire            t_mem_abort;
   wire    [1:0] tk_crt_addr_msb;
    
   
   

   reg          is_forced;
   reg          contention;
   integer      driver_total, d0, d1, dx;
   reg     [15:0]  read_data;
