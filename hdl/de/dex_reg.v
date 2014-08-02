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
//  Title       :  Drawing Engine Register Block
//  File        :  dex_reg.v
//  Author      :  Jim MacLeod
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
`timescale 1ns / 10ps

module dex_reg
  (
   input		de_clk,		/* drawing engine clock input		*/
   input		de_rstn,	/* reset input                          */
   input [159:0] 	xydat_1,        /* parameter registers                  */
   input 		load_actvn_in,	/* load active command parameters	*/
   input 		load_actv_3d,	/* load active 3D parameters		*/
   input 		line_actv_1,	/* Line command is active		*/
   input 		line_actv_3d_1,	/* Line command is active		*/
   input 		line_actv_2,	/* Line command is active		*/
   input 		blt_actv_1,	/* blt command is active		*/
   input 		blt_actv_2,	/* blt command is active		*/
   input [4:0] 		aad,		/* A port register address		*/
   input [4:0]		bad,		/* B port register address		*/
   input [3:0] 		wad,		/* write port register address		*/
   input [1:0] 		wen,		/* register write enables		*/
   input 		ldmajor,	/* load major direction bit      	*/
   input		ldminor,	/* load minor direction bit		*/
   input		incpat,		/* increment line pattern pointer	*/
   input		l3_incpat,	/* increment 3D line pattern pointer	*/
   input		prst,		/* pattern reset bit			*/
   input [3:0] 		src_cntrl,	/* source counter control bits.		*/
   input [1:0] 		dst_cntrl,	/* destination counter control bits.	*/
   input 		w_chgx,		/* working counter control bits.	*/
   input [15:0] 	fx,		/* input from the ALU X output		*/
   input [15:0] 	fy,		/* input from the ALU Y output		*/
   input [31:0] 	lpat_1,         /* line pattern register output                */
   input [15:0] 	pctrl_1,        /* line pattern control register output        */
   input [1:0] 		clp_2,          /* clipping control                            */
   input [31:0] 	clptl_1,        /* clipping top left corner register input     */
   input [31:0] 	clpbr_1,        /* clipping bottom right corner register input */
   input [31:0] 	de_sorg_2,      /* source origin register output               */
   input [31:0] 	de_dorg_2,      /* destination origin register output          */
   input 		set_sol,    	/* set the start of line flag.             	*/
   input 		set_eol,    	/* set the end of line flag.             	*/
   input 		mem_req,    	/* memory request signal.                	*/
   input 		mem_read,    	/* memory read signal.	                	*/
   input [1:0] 		ps_1,        	/* pixel size level one signal.	        	*/
   input 		ps16_2,        	/* pixel size is 16.		        	*/
   input 		ps32_2,        	/* pixel size is 32.		        	*/
   input 		eline_actv_1,   /* eline active level one signal.        	*/
   input 		pline_actv_1,   /* poly line active level one signal.        	*/
   input 		pline_actv_2,   /* poly line active level one signal.        	*/
   input 		mul,       	/* mul the srx, dstx, and sizex by 1,2, or 4.   */
   input 		stpl_2,       	/* packed stipple bit level two.                */
   input 		tx_clr_seol,   	/* text mode clear sol and eol.                 */
   input 		edi_2,   	/* triangle edge include bit.                   */
   input 		inc_err,   	/* line increment error reg.                    */
   input 		rst_err,   	/* line decrement error reg.                    */
   input 		stpl_1,   	/* packed stipple level one signal.             */
   input 		src_upd,	/* Update source at end of line.		*/
   input 		b_clr_ld_disab,	/* Clear the rd_eq_wr load disable bit.		*/
   input 		next_x,		/* Nexxt X for triangle scanning.      		*/
  
   output reg	[2:0] 	dir,	        /* direction register output.			*/
   output 		wrk0_eqz,	/* working register/counter equals zero.	*/
   output 		wrk5_eqz,	/* working register/counter equals zero.	*/
   output reg	[15:0] 	ax,	        /* ax output to alu                            */
   output reg	[15:0] 	bx,             /* bx output to alu                            */
   output reg	[15:0] 	ay,             /* ay output to alu                            */
   output reg	[15:0] 	by,             /* by output to alu                            */
   output	 	clip,           /* clipping output                             */
   output [15:0] 	srcx,
   output [15:0] 	srcy,
   output [15:0] 	dstx,
   output [15:0] 	dsty,
   output 		fg_bgn,		/* foreground=1,  background=0, line patterns 	*/
   output [15:0] 	lpat_state,	/* read back path for line pattern state	*/
   output [31:0] 	clpx_bus_2,	/* clipping X values.				*/
   output reg		sol_2,       	/* start of line flag output. 			*/
   output reg		eol_2,       	/* start of line flag output. 			*/
   output 		y_clip_2,	/* current y is (ymin < y > ymax)		*/
   output reg		rd_eq_wr,	/* read words is equal to write words.		*/
   output 		wr_gt_8,   	/* write words is greater than eight.           */
   output 		wr_gt_16,   	/* write words is greater than sixteen.         */
   output reg	[4:0] 	xpat_ofs,      
   output reg	[4:0] 	ypat_ofs,     
   output [15:0] 	real_dstx,      
   output [15:0] 	real_dsty,     
   output 		xchng,     
   output 		ychng,     
   output reg		eneg,		/* Error term is negative.                */
   output reg		eeqz,		/* Error term is equal to zero.          	*/
   output reg	[2:0] 	clp_status,
   output reg 	[31:0]	clptl_r,	// clipping Top Left, for 3D core.
   output reg	[31:0]	clpbr_r		// clipping Bottom Right for 3D core.
   );
  
  // `include "de_param.h"
  parameter SRC 		= 4'h0,            
	    DST 		= 4'h1,            
	    WRK0 		= 4'h2,            
	    WRK1 		= 4'h3,            
	    WRK2 		= 4'h4,            
	    WRK3 		= 4'h5,            
	    WRK4 		= 4'h6,            
	    WRK5 		= 4'h7,            
	    WRK6X 		= 4'h8,            
	    DST_WRK1Y	        = 4'h9,            
	    SRC_WRK1	        = 4'ha,            
	    WRK3_WRK5 	        = 4'hb,            
	    WRK4_WRK6X 	        = 4'hc,            
	    WRK7X 		= 4'hd,		// pipeline address.
	    SORGL 		= 4'he,		// src org address low nibble
	    DORGL 		= 4'hf,		// src org address low nibble.
            xend_pc             = 5'h09,
            xmin_pc             = 5'h0a,
            e1s_se              = 5'h09,
            e2s_se              = 5'h0a,
            e3s_se              = 5'h0b,
            e1x_se              = 5'h0c,
            e2x_se              = 5'h0e,
            e3x_se              = 5'h0f;

	   
  reg 	  v3_flag;	/* flag indicating a third verticy.		*/
  reg 	  load_actvn;	/* X zoom enable signal.			*/

  always @(posedge de_clk)load_actvn <= load_actvn_in;
  /**************************************************************************/
  /*		split up the source counter control bits.		    */
  wire 	  s_chgx,		/* source change the X position counter.*/
     	  s_rht,		/* source x direction is right.        	*/
     	  s_chgy,		/* source change the Y position counter.*/
     	  s_dwn;		/* source y direction is down.         	*/
  assign  {s_chgx,s_rht,s_chgy,s_dwn}= src_cntrl;
  /**************************************************************************/
  /*		split up the destination counter control bits.		    */
  wire 	  d_chgy,		/* destination change the Y position counter.	*/
     	  d_dwn;		/* destination y direction is down.         	*/
  assign  {d_chgy,d_dwn}= dst_cntrl;
  assign  ychng = s_chgy | d_chgy;
  assign  xchng = s_chgx;
  /**************************************************************************/
  /*		split up the xy input bus.						*/
  wire [31:0] xy0_1,xy1_1,xy2_1,xy3_1,xy4_1;
  assign      {xy0_1,xy1_1,xy2_1,xy3_1,xy4_1} = xydat_1;

  /****************************************************************************************/
  /*		split up the xy input bus.						*/
  reg 	      wehn,weln;
  always @(wen) {wehn,weln} = wen;
  /****************************************************************************************/
  /*		create the ps16_1 and ps32_1 signals.     				*/
  wire 	      ps16_1 = ps_1[0];		/* pixel size equals sixteen.*/
  wire 	      ps32_1 = (ps_1 == 2'b10);	/* pixel size equals thirtytwo.*/
  /****************************************************************************************/
  wire [15:0] de_sorgx_2;
  wire [15:0] de_dorgx_2;
  wire [15:0] de_sorgy_2;
  wire [15:0] de_dorgy_2;

  assign      de_sorgx_2 = (ps32_2) ? de_sorg_2[31:16] << 2:
	      (ps16_2) ? de_sorg_2[31:16] << 1: de_sorg_2[31:16];
  assign      de_dorgx_2 = (ps32_2) ? de_dorg_2[31:16] << 2:
	      (ps16_2) ? de_dorg_2[31:16] << 1: de_dorg_2[31:16];

  assign      de_sorgy_2 = (ps32_2) ? de_sorg_2[15:0] << 2:
	      (ps16_2) ? de_sorg_2[15:0] << 1: de_sorg_2[15:0];
  assign      de_dorgy_2 = (ps32_2) ? de_dorg_2[15:0] << 2:
	      (ps16_2) ? de_dorg_2[15:0] << 1: de_dorg_2[15:0];
  /********************************************************************************/
  /*		DEFINE ALL SECOND LEVEL REGISTERS IN THE DRAWING ENGINE		*/
  /********************************************************************************/
  reg [15:0]  clip_dstx_end;
  reg [4:0]   new_xpat_ofs;
  reg [4:0]   new_ypat_ofs;
  reg [31:0]  new_lpat_r;	/* line pattern register 		*/
  reg [15:0]  new_pctrl_r;	/* line pattern control register	*/
  reg [31:0]  new_clptl_r;	/* clipping top left corner register	*/
  reg [31:0]  new_clpbr_r;	/* clipping bottom right corner register*/
  reg [15:0]  new_clptll_r;	/* clipping top left corner register	*/
  reg [15:0]  new_clptlh_r;	/* clipping top left corner register	*/
  reg [15:0]  new_clpbrl_r;	/* clipping bottom right corner register*/
  reg [15:0]  new_clpbrh_r;	/* clipping bottom right corner register*/
  
  /* noop | bitblt | line | eline | trian | rxfer | wxfer */
  /*      |        |      |       |       |       |       */
  reg [31:0]  new_src_r;	/*  NA  |  src   | src  |  src  |  pptr | offset| offset*/
  reg [15:0]  new_dsth_r;	/* trig |  dst   | dst  |  dst  |  p0   | width | width */
  reg [15:0]  new_dstl_r;	/* trig |  dst   | dst  |  dst  |  p0   | width | width */
  reg [31:0]  new_wrk0_r;	/*  NA  |  W/H   |DX/DY | DX/DY |  p3   |       |       */
  reg [31:0]  new_wrk1_r;	/*      |        |      |       |  p2   |       |       */
  reg [31:0]  new_wrk2_r;	/*      |        |      |       |  p1   |       |       */ 
  reg [31:0]  new_wrk3_r;	/*      |        |      |       |  p1   |       |       */ 
  reg [31:0]  new_wrk4_r;	/*      |        |      |       |       |       |       */ 
  reg [15:0]  new_wrk5h_r;	/*      |        |      |       |       |       |       */ 
  reg [15:0]  new_wrk5l_r;	/*      |        |      |       |       |       |       */ 
  reg [15:0]  new_wrk6x_r;	/*      |        |      |       |       |       |       */ 
  reg [15:0]  new_wrk7x_r;	/*      |        |      |       |       |       |       */ 

  reg [31:0]  lpat_r;		/* line pattern register 		*/
  reg [15:0]  pctrl_r;	/* line pattern control register	*/
  
  reg [15:0]  srcx_r;		/* working register source		*/
  reg [15:0]  srcy_r;		/* working register source		*/
  reg [15:0]  dstx_r;		/* working register destination		*/
  reg [15:0]  dsty_r;		/* working register destination		*/
  reg [15:0]  wrk0x_r;		/* working register zero		*/
  reg [15:0]  wrk0y_r;		/* working register zero		*/
  reg [15:0]  wrk1x_r;		/* working register one 		*/
  reg [15:0]  wrk1y_r;		/* working register one 		*/
  reg [15:0]  wrk2x_r;		/* working register two 		*/
  reg [15:0]  wrk2y_r;		/* working register two 		*/
  reg [15:0]  wrk3x_r;		/* working register three		*/
  reg [15:0]  wrk3y_r;		/* working register three		*/
  reg [15:0]  wrk4x_r;		/* working register four		*/
  reg [15:0]  wrk4y_r;		/* working register four		*/
  reg [15:0]  wrk5x_r;		/* working register five		*/
  reg [15:0]  wrk5y_r;		/* working register five		*/
  reg [15:0]  wrk6x_r;		/* working register six X		*/
  reg [15:0]  wrk7x_r;		/* working register seven X		*/
  /********************************************************************************/
  /*		DEFINE ALL LOAD SIGNALS 					*/
  /********************************************************************************/
  reg 	      iload_pat_ofs;	
  reg 	      ild_src_h;	/* working register source load high.   */
  reg 	      ild_src_l;	/* working register source load low.    */
  reg 	      ild_dst_h;	/* working register dest load high.	*/
  reg 	      ild_dst_l;	/* working register dest load low.	*/
  reg 	      ild_wrk0_h;	/* working register zero load high.     */
  reg 	      ild_wrk0_l;	/* working register zero load low.      */
  reg 	      ild_wrk1_h;	/* working register one load high.      */
  reg 	      ild_wrk1_l;	/* working register one load low.       */
  reg 	      ild_wrk2_h;	/* working register two load high.      */
  reg 	      ild_wrk2_l;	/* working register two load low.       */
  reg 	      ild_wrk3_h;	/* working register three load high.    */
  reg 	      ild_wrk3_l;	/* working register three load low.     */
  reg 	      ild_wrk4_h;	/* working register four load high.     */
  reg 	      ild_wrk4_l;	/* working register four load low.      */
  reg 	      ild_wrk5_h;	/* working register five load high.     */
  reg 	      ild_wrk5_l;	/* working register five load low.      */
  reg 	      ild_wrk6x_h;	/* working register six X load high.    */
  reg 	      ild_wrk7x_h;	/* working register seven X load high.  */

  wire 	      load_pat_ofs;	
  wire 	      ld_src_h;	/* working register source load high.   */
  wire 	      ld_src_l;	/* working register source load low.    */
  wire 	      ld_dst_h;	/* working register dest load high.	*/
  wire 	      ld_dst_l;	/* working register dest load low.	*/
  wire 	      ld_wrk0_h;	/* working register zero load high.     */
  wire 	      ld_wrk0_l;	/* working register zero load low.      */
  wire 	      ld_wrk1_h;	/* working register one load high.      */
  wire 	      ld_wrk1_l;	/* working register one load low.       */
  wire 	      ld_wrk2_h;	/* working register two load high.      */
  wire 	      ld_wrk2_l;	/* working register two load low.       */
  wire 	      ld_wrk3_h;	/* working register three load high.    */
  wire 	      ld_wrk3_l;	/* working register three load low.     */
  wire 	      ld_wrk4_h;	/* working register four load high.     */
  wire 	      ld_wrk4_l;	/* working register four load low.      */
  wire 	      ld_wrk5_h;	/* working register five load high.     */
  wire 	      ld_wrk5_l;	/* working register five load low.      */
  wire 	      ld_wrk6x_h;	/* working register six X load high.    */
  wire 	      ld_wrk7x_h;	/* working register seven X load high.    */

  assign      load_pat_ofs   = iload_pat_ofs;
  assign      ld_src_h   = ild_src_h;
  assign      ld_src_l   = ild_src_l;
  assign      ld_dst_h   = ild_dst_h;
  assign      ld_dst_l   = ild_dst_l;
  assign      ld_wrk0_h  = ild_wrk0_h;
  assign      ld_wrk0_l  = ild_wrk0_l;
  assign      ld_wrk1_h  = ild_wrk1_h;
  assign      ld_wrk1_l  = ild_wrk1_l;
  assign      ld_wrk2_h  = ild_wrk2_h;
  assign      ld_wrk2_l  = ild_wrk2_l;
  assign      ld_wrk3_h  = ild_wrk3_h;
  assign      ld_wrk3_l  = ild_wrk3_l;
  assign      ld_wrk4_h  = ild_wrk4_h;
  assign      ld_wrk4_l  = ild_wrk4_l;
  assign      ld_wrk5_h  = ild_wrk5_h;
  assign      ld_wrk5_l  = ild_wrk5_l;
  assign      ld_wrk6x_h = ild_wrk6x_h;
  assign      ld_wrk7x_h = ild_wrk7x_h;
  /********************************************************************************/
  /*				DEFINE OTHER REGISTERS				*/
  /********************************************************************************/
  reg 	      xl_xmin;	/* X is less than Xmin			*/
  reg 	      xmaxl_x;	/* Xmax is less than X			*/
  reg 	      ymaxl_y;	/* Ymax is less than Y			*/
  reg 	      yl_ymin;	/* Y is less than Ymin			*/
  /********************************************************************************/
  /*										*/
  /*			ASSIGN OUTPUTS TO REGISTERS				*/
  /*										*/
  /********************************************************************************/
  wire [15:0] clip_dstx;	/* destination X wire			*/
  wire [15:0] clip_dsty;	/* destination Y wire			*/
  wire [15:0] xmin;		/* clipping X min      			*/
  wire [15:0] xmax;		/* clipping X max     			*/
  wire [15:0] ymin;		/* clipping Y min      			*/
  wire [15:0] ymax;		/* clipping Y max      			*/
  wire [3:0]  out_code;	/* clipping out code register		*/
  assign      srcx = srcx_r;
  assign      srcy = srcy_r;
  assign      dstx = dstx_r;
  assign      dsty = dsty_r;

  assign      clip_dstx = (line_actv_2) ? srcx_r : dstx_r;

  assign      clip_dsty = (line_actv_2) ? srcy_r : dsty_r;

  assign      real_dstx = (!line_actv_2 && ps32_2) ? clip_dstx << 2 :
	      (!line_actv_2 && ps16_2) ? clip_dstx << 1 : clip_dstx;

  assign      real_dsty = clip_dsty;
  assign      xmin = clptl_r[31:16];		/* clipping X min      			*/
  assign      ymin = clptl_r[15:0];		/* clipping X max     			*/
  assign      xmax = clpbr_r[31:16];		/* clipping Y min      			*/
  assign      ymax = clpbr_r[15:0];		/* clipping Y max      			*/
  assign      out_code = {xl_xmin,xmaxl_x,ymaxl_y,yl_ymin};
  assign      clip=(((clp_2==2'b10) && (out_code != 4'b0000))
		    || ((clp_2==2'b11) && (out_code == 4'b0000)));
  assign      y_clip_2 =(((clp_2==2'b10) && (ymaxl_y | yl_ymin))
			 || ((clp_2==2'b11) && !(ymaxl_y | yl_ymin)));
  assign      clpx_bus_2 = {xmax,xmin};
  /**********************************************************************/
  /*									*/
  /*		REGISTER WRITE FUNCTION					*/
  /*		DATA INPUT SELECTION 					*/
  /*									*/
  /*									*/
  /**********************************************************************/
  /* if load active select the input data as follows to the registers.	*/
  always @*
    if(!load_actvn)
      begin
      	new_src_r = xy0_1;
      	if(eline_actv_1) new_wrk0_r = xy2_1;
      	else new_wrk0_r = xy2_1;
      end 
    else begin
      new_src_r  = {fx,fy};
      new_wrk0_r = {fx,fy};
    end

  /**************************************************************************/
  /*		Destination register input MUX.				    */
  always @*
    if (!load_actvn)        new_dsth_r = xy1_1[31:16];
    else 	            new_dsth_r = fx;

  always @*
    if (!load_actvn)        new_dstl_r = xy1_1[15:0];
    else 	            new_dstl_r = fy;

  always @*
    if (!load_actvn)
      if (eline_actv_1)       new_wrk1_r = xy2_1; // {error,NA}
      else 	         new_wrk1_r = xy3_1;
    else 		 new_wrk1_r = {fx,fy};

  always @*
    if (!load_actvn)
      if (eline_actv_1)       new_wrk2_r = xy3_1; // {errinc1,errinc2}
      else 	         new_wrk2_r = xy4_1;
    else 		 new_wrk2_r = {fx,fy};

  always @* new_wrk3_r = {fx,fy};

  /**************************************************************************/
  /*		WRK5 register input MUX.				    */
  always @* new_wrk5h_r = fx;

  always @*
    if (!load_actvn) new_wrk5l_r = {13'b0,xy3_1[2:0]};
    else             new_wrk5l_r = fy;

  /**************************************************************************/
  /* Hardwired Second level registers. */
  always @* begin
    new_lpat_r = lpat_1;
    new_pctrl_r = pctrl_1;
    new_wrk4_r[31:16] = fx;
    new_wrk4_r[15:0] = fy;
    new_wrk6x_r[15:0] = fx;
    new_wrk7x_r[15:0] = fx;
  end

  /* Second level clip top left and bottom right. */
  always @*
    if (load_actv_3d) new_clptlh_r  = clptl_1[31:16];
    else if (ps16_1)  new_clptlh_r  = clptl_1[31:16] << 1;
    else if( ps32_1)  new_clptlh_r  = clptl_1[31:16] << 2;
    else              new_clptlh_r  = clptl_1[31:16];

  /* Second level clip top left and bottom right. */
  always @*
    if (load_actv_3d) new_clpbrh_r  = clpbr_1[31:16];
    else if (ps16_1)  new_clpbrh_r  = clpbr_1[31:16] << 1;
    else if (ps32_1)  new_clpbrh_r  = clpbr_1[31:16] << 2;
    else              new_clpbrh_r  = clpbr_1[31:16];

  /* Second level clip top left and bottom right. */
  always @* new_clptll_r   = clptl_1[15:0];

  /* Second level clip top left and bottom right. */
  always @* new_clpbrl_r   = clpbr_1[15:0];

  always @*
    begin
      new_xpat_ofs   = xy3_1[20:16];
      new_ypat_ofs   = xy3_1[4:0];
    end

  always @(posedge de_clk) begin
    if (load_pat_ofs) xpat_ofs <= new_xpat_ofs;
    if (load_pat_ofs) ypat_ofs <= new_ypat_ofs;
  end

  /**************************************************************************/
  /*			REGISTER WRITE STROBE DECODER 			    */
  /**************************************************************************/
  always @(posedge de_clk)iload_pat_ofs <= ~load_actvn_in;
  
  always @(posedge de_clk) begin
    ild_src_h  <= 1'b0;
    ild_src_l  <= 1'b0;
    ild_dst_h  <= 1'b0;
    ild_dst_l  <= 1'b0;
    ild_wrk0_h <= 1'b0;
    ild_wrk0_l <= 1'b0;
    ild_wrk1_h <= 1'b0;
    ild_wrk1_l <= 1'b0;
    ild_wrk2_h <= 1'b0;
    ild_wrk2_l <= 1'b0;
    ild_wrk3_h <= 1'b0;
    ild_wrk3_l <= 1'b0;
    ild_wrk4_h <= 1'b0;
    ild_wrk4_l <= 1'b0;
    ild_wrk5_h <= 1'b0;
    ild_wrk5_l <= 1'b0;
    ild_wrk6x_h <= 1'b0;
    ild_wrk7x_h <= 1'b0;

    if(!load_actvn_in) begin
      ild_src_h <= ~pline_actv_1;
      ild_src_l <= ~pline_actv_1;
      ild_dst_h <= 1'b1;
      ild_dst_l <= 1'b1;
      ild_wrk0_h <= 1'b1;
      ild_wrk0_l <= 1'b1;
      ild_wrk1_h <= 1'b1;
      ild_wrk1_l <= 1'b1;
      ild_wrk2_h <= 1'b1;
      ild_wrk2_l <= 1'b1;
      ild_wrk3_h <= 1'b1;
      ild_wrk3_l <= 1'b1;
      ild_wrk4_h <= 1'b0;
      ild_wrk4_l <= 1'b0;
      ild_wrk5_h <= 1'b1;
      ild_wrk5_l <= 1'b1;
      ild_wrk6x_h <= 1'b0;
      ild_wrk7x_h <= 1'b0;
    end else begin
      case(wad) // synopsys parallel_case
        SRC:    begin
	  ild_src_h  <= ~wehn;
	  ild_src_l  <= ~weln;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        DST:    begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= ~wehn;
	  ild_dst_l  <= ~weln;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK0:   begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= ~wehn;
	  ild_wrk0_l <= ~weln;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK1:   begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= ~wehn;
	  ild_wrk1_l <= ~weln;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK2:   begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= ~wehn;
	  ild_wrk2_l <= ~weln;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK3:   begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= ~wehn;
	  ild_wrk3_l <= ~weln;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK4:   begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= ~wehn;
	  ild_wrk4_l <= ~weln;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK5:   begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= ~wehn;
	  ild_wrk5_l <= ~weln;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK6X: begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= ~wehn;
	  ild_wrk7x_h <= 1'b0;
	end
        WRK7X: begin
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= ~wehn;
	end
        DST_WRK1Y: begin /* load both the dst and wrk2 registers. */ 
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= ~wehn;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= ~weln;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        SRC_WRK1: begin /* load both the src and wrk1 registers. */
	  ild_src_h  <= ~wehn;
	  ild_src_l  <= ~weln;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= ~wehn;
	  ild_wrk1_l <= ~weln;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK3_WRK5: begin /* load both the wrk3 and wrk5 registers. */
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= ~wehn;
	  ild_wrk3_l <= ~weln;
	  ild_wrk4_h <= 1'b0;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= ~wehn;
	  ild_wrk5_l <= ~weln;
	  ild_wrk6x_h <= 1'b0;
	  ild_wrk7x_h <= 1'b0;
        end
        WRK4_WRK6X: begin /* load both the wrk4 and wrk6x registers. */
	  ild_src_h  <= 1'b0;
	  ild_src_l  <= 1'b0;
	  ild_dst_h  <= 1'b0;
	  ild_dst_l  <= 1'b0;
	  ild_wrk0_h <= 1'b0;
	  ild_wrk0_l <= 1'b0;
	  ild_wrk1_h <= 1'b0;
	  ild_wrk1_l <= 1'b0;
	  ild_wrk2_h <= 1'b0;
	  ild_wrk2_l <= 1'b0;
	  ild_wrk3_h <= 1'b0;
	  ild_wrk3_l <= 1'b0;
	  ild_wrk4_h <= ~wehn;
	  ild_wrk4_l <= 1'b0;
	  ild_wrk5_h <= 1'b0;
	  ild_wrk5_l <= 1'b0;
	  ild_wrk6x_h <= ~wehn;
	  ild_wrk7x_h <= 1'b0;
        end
      endcase
    end
  end
  /********************************************************************************/
  /*			REGISTER A ADDRESS OUTPUT SELECTOR			*/
  /********************************************************************************/
  reg	[13:0]	a_sel;
  always @(posedge de_clk)
    begin
      case(aad)   // synopsys parallel_case
	SRC:	a_sel <= 14'b00000000000001;
	DST:	a_sel <= 14'b00000000000010;
	WRK0:	a_sel <= 14'b00000000000100;
	WRK1:	a_sel <= 14'b00000000001000;
	WRK2:	a_sel <= 14'b00000000010000;
	WRK3:	a_sel <= 14'b00000000100000;
	WRK4:	a_sel <= 14'b00000001000000;
	WRK5:	a_sel <= 14'b00000010000000;
	WRK6X:	a_sel <= 14'b00000100000000;
	WRK7X:	a_sel <= 14'b00001000000000;
	SORGL:	a_sel <= 14'b00010000000000;
	DORGL:	a_sel <= 14'b00100000000000;
	xend_pc:a_sel <= 14'b01000000000000;
	xmin_pc:a_sel <= 14'b10000000000000;
	default:  a_sel <= 12'b000000000000;
      endcase
    end

  always @* begin

    ax=fx;
    ay=fy;

    if (a_sel[0]) begin
      ax=srcx_r;
      ay=srcy_r;
    end

    if (a_sel[1]) begin
      ax=dstx_r;
      ay=dsty_r;
    end

    if (a_sel[2]) begin
      ax=wrk0x_r;
      ay=wrk0y_r;
    end
    
    if (a_sel[3]) begin
      ax=wrk1x_r;
      ay=wrk1y_r;
    end
    
    if (a_sel[4]) begin
      ax=wrk2x_r;
      ay=wrk2y_r;
    end
    if (a_sel[5]) begin
      ax=wrk3x_r;
      ay=wrk3y_r;
    end
    
    if (a_sel[6]) begin
      ax=wrk4x_r;
      ay=wrk4y_r;
    end
    
    if (a_sel[7]) begin
      ax=wrk5x_r;
      ay=wrk5y_r;
    end
    
    if (a_sel[8]) ax=wrk6x_r;
    if (a_sel[9]) ax=wrk7x_r;

    if (a_sel[12]) ax=clip_dstx_end;
    if (a_sel[13]) ax=xmin;

    if (a_sel[10]) begin
      ax=de_sorgx_2;
      ay=de_sorgy_2;
      // ax=16'b1;
      // ay=16'b1;
    end
    
    if(a_sel[11]) begin
      ax=de_dorgx_2;
      ay=de_dorgy_2;
      // ax=16'b1;
      // ay=16'b1;
    end
  end

  /**************************************************************************/
  /*                      REGISTER B ADDRESS OUTPUT SELECTOR                */
  /**************************************************************************/

  reg	[17:0]	b_sel;
  always @(posedge de_clk) begin
    
    case(bad)     // synopsys parallel_case
      SRC:		b_sel <= 18'b000000000000000001; // 5'h0
      DST:		b_sel <= 18'b000000000000000010; // 5'h1
      WRK0:		b_sel <= 18'b000000000000000100; // 5'h2
      WRK1:		b_sel <= 18'b000000000000001000; // 5'h3
      WRK2:		b_sel <= 18'b000000000000010000; // 5'h4
      WRK3:		b_sel <= 18'b000000000000100000; // 5'h5
      WRK4:		b_sel <= 18'b000000000001000000; // 5'h6
      WRK5:		b_sel <= 18'b000000000010000000; // 5'h7
      WRK6X:		b_sel <= 18'b000000000100000000; // 5'h8
      WRK7X:		b_sel <= 18'b000000001000000000; // 5'hd
      e1s_se:		b_sel <= 18'b000000010000000000; // 5'h9
      e2s_se:		b_sel <= 18'b010000100000000000; // 5'ha
      e3s_se:		b_sel <= 18'b100001000000000000; // 5'hb
      e1x_se:		b_sel <= 18'b000010000000000000; // 5'hc
      e2x_se:		b_sel <= 18'b000100000000000000; // 5'he
      e3x_se:		b_sel <= 18'b001000000000000000; // 5'hf
      default:          b_sel <= 10'b0000000000;
    endcase
  end

  always @* begin

    bx=fx;
    by=fy;

    if (b_sel[0]) begin
      bx=srcx_r;
      by=srcy_r;
    end
    
    if (b_sel[1]) begin
      bx=dstx_r;
      by=dsty_r;
    end

    if (b_sel[2]) begin
      bx=wrk0x_r;
      by=wrk0y_r;
    end

    if (b_sel[3]) begin
      bx=wrk1x_r;
      by=wrk1y_r;
    end

    if (b_sel[4]) begin
      bx=wrk2x_r;
      by=wrk2y_r;
    end

    if (b_sel[5]) begin
      bx=wrk3x_r;
      by=wrk3y_r;
    end

    if (b_sel[6]) begin
      bx=wrk4x_r;
      by=wrk4y_r;
    end

    if (b_sel[7]) begin
      bx=wrk5x_r;
      by=wrk5y_r;
    end

    if (b_sel[8]) bx=wrk6x_r;

    if (b_sel[9]) bx=wrk7x_r;

    if (b_sel[16]) bx=xmin;

    if (b_sel[17]) bx=xmax;
  end

  /**************************************************************************/
  /* 			PRE CLIPPING COMPARATORS			*/
  /**************************************************************************/
  reg	     	xel_xmin,xmaxl_xe;
  wire [2:0] 	clp_adj;
  assign 	clp_adj = (ps32_2) ? 3'b100 : (ps16_2) ? 3'b010 : 3'b001;

  // always @* clip_dstx_end = clip_dstx + wrk0x_r - clp_adj;
  always @(posedge de_clk) clip_dstx_end <= clip_dstx + wrk0x_r - clp_adj;
  always @* begin

    if(clip_dstx_end[15] & !xmin[15])xel_xmin=1;
    else if(!clip_dstx_end[15] & xmin[15])xel_xmin=0;
    else if(clip_dstx_end[14:4] < xmin[14:4])xel_xmin=1;
    else if(clip_dstx_end < xmin)xel_xmin=1;
    else xel_xmin=0;

    if(clip_dstx_end[15] & !xmax[15])xmaxl_xe=0;
    else if(!clip_dstx_end[15] & xmax[15])xmaxl_xe=1;
    else if(xmax[14:4] < clip_dstx_end[14:4])xmaxl_xe=1;
    else if(xmax < clip_dstx_end)xmaxl_xe=1;
    else xmaxl_xe=0;
  end

  // always @*
  always @(posedge de_clk)
    case({clp_2[1],xl_xmin,xmaxl_x,xel_xmin,xmaxl_xe}) 
      5'b10101: clp_status <= 3'b100; // trivial reject
      5'b11010: clp_status <= 3'b100; // trivial reject
      5'b11000: clp_status <= 3'b001; // case 1
      5'b11001: clp_status <= 3'b010; // case 2
      5'b10001: clp_status <= 3'b011; // case 4
      default:  clp_status <= 3'b000; // no clipping applied
    endcase

  /**************************************************************************/
  /* 			CLIPPING COMPARATORS			*/
  /**************************************************************************/
  always @* begin

    	 if( clip_dstx[15] & !xmin[15])	xl_xmin=1;			// -dstx & +xmin
    else if(!clip_dstx[15] & xmin[15])	xl_xmin=0;			// +dstx & -xmin
    else if((clip_dstx[14:4] < xmin[14:4]) & (blt_actv_2))xl_xmin=1;	// 
    else if( clip_dstx < xmin)		xl_xmin=1;			//  dstx < xmin
    else 				xl_xmin=0;

    	 if( clip_dstx[15] & !xmax[15])	xmaxl_x=0;
    else if(!clip_dstx[15] &  xmax[15])	xmaxl_x=1;
    else if((xmax[14:4] < clip_dstx[14:4]) & (blt_actv_2))xmaxl_x=1;
    else if(xmax < clip_dstx)		xmaxl_x=1;
    else 				xmaxl_x=0;

    	 if(clip_dsty[15] & !ymin[15])  yl_ymin=1;
    else if(!clip_dsty[15] & ymin[15])  yl_ymin=0;
    else if(clip_dsty < ymin)		yl_ymin=1;
    else 				yl_ymin=0;

    	 if( clip_dsty[15] & !ymax[15]) ymaxl_y=0;
    else if(!clip_dsty[15] &  ymax[15]) ymaxl_y=1;
    else if(ymax < clip_dsty)	        ymaxl_y=1;
    else 			        ymaxl_y=0;
  end

  /**************************************************************************/
  /*			SOURCE X COUNTER				    */
  /**************************************************************************/

  always @(posedge de_clk) begin
    if      (ld_src_h && !src_upd)            srcx_r <= new_src_r[31:16];
    else if (ld_src_h && src_upd && ps16_2)   srcx_r <= new_src_r[31:16] >>1;
    else if (ld_src_h && src_upd && ps32_2)   srcx_r <= new_src_r[31:16] >>2;
    else if (mul && ps16_2)                   srcx_r <= srcx_r<<1;
    else if (mul && ps32_2)                   srcx_r <= srcx_r<<2;
    else if (s_chgx && s_rht && ps16_2)       srcx_r <= srcx_r+16'h2;
    else if (s_chgx && s_rht && ps32_2)       srcx_r <= srcx_r+16'h4;
    else if (s_chgx && s_rht)                 srcx_r <= srcx_r+16'h1;
    else if (s_chgx && !s_rht && ps16_2)      srcx_r <= srcx_r-16'h2;
    else if (s_chgx && !s_rht && ps32_2)      srcx_r <= srcx_r-16'h4;
    else if (s_chgx && !s_rht)                srcx_r <= srcx_r-16'h1;
  end

  /**************************************************************************/
  /*			SOURCE Y COUNTER				    */
  /**************************************************************************/
  always @(posedge de_clk) begin
    if      (ld_src_l)         srcy_r <= new_src_r[15:0];
    else if (s_chgy && s_dwn)  srcy_r <= srcy_r+16'h1;
    else if (s_chgy && !s_dwn) srcy_r <= srcy_r-16'h1;
  end

  /**************************************************************************/
  /*			DESTINATION X REGISTER				    */
  /**************************************************************************/
  always @(posedge de_clk)
    begin
      if (ld_dst_h)		dstx_r <= new_dsth_r;
      else if (mul && ps16_2)	dstx_r <= dstx_r<<1;
      else if (mul && ps32_2)	dstx_r <= dstx_r<<2;
    end
  
  /*************************************************************************/
  /*			DESTINATION Y COUNTER				   */
  /*************************************************************************/
  always @(posedge de_clk) begin
    if(ld_dst_l)              dsty_r <= new_dstl_r;
    else if(d_chgy && d_dwn)  dsty_r <= dsty_r+16'h1;
    else if(d_chgy && !d_dwn) dsty_r <= dsty_r-16'h1;
  end

  /*************************************************************************/
  /*			WORKING ZERO X COUNTER				   */
  /*************************************************************************/
  always @(posedge de_clk) begin
    if(ld_wrk0_h)                             wrk0x_r <= new_wrk0_r[31:16];
    else if(mul && ps16_2)       	      wrk0x_r <= wrk0x_r<<1;
    else if(mul && ps32_2)       	      wrk0x_r <= wrk0x_r<<2;
    else if(w_chgx && ps16_2 && !line_actv_2) wrk0x_r <= wrk0x_r-16'h2;
    else if(w_chgx && ps32_2 && !line_actv_2) wrk0x_r <= wrk0x_r-16'h4;
    else if(w_chgx)                           wrk0x_r <= wrk0x_r-16'h1;
  end
  
  /*************************************************************************/
  /*			REMAINING REGISTERS 				   */
  /*************************************************************************/

  always @(posedge de_clk) begin
    if (ld_wrk0_l) wrk0y_r <= new_wrk0_r[15:0];

    if(!load_actvn_in && (line_actv_1 | line_actv_3d_1) && prst) begin
      lpat_r  <= new_lpat_r;
      pctrl_r <= new_pctrl_r;
    end

    if(!load_actvn_in) begin
      clptl_r <= {new_clptlh_r,new_clptll_r};
      clpbr_r <= {new_clpbrh_r,new_clpbrl_r};
    end
  end
  
  /**************************************************************************/
  /* ERROR REGISTER.							    */
  reg	[15:0]	ei_in;
  reg [15:0] 	new_error_r;
  reg	      	cin;
  always @(posedge de_clk) begin
    if(ld_wrk1_h)              wrk1x_r <= new_wrk1_r[31:16]; /* load the register    	*/
    else if(inc_err | rst_err) wrk1x_r <= new_error_r;   /* load the next error.	*/
  end
  
  always @*
    if (inc_err) begin
      ei_in = wrk2y_r;
      cin = 0;
    end else if(rst_err) begin
      ei_in = ~wrk2x_r;
      cin = 1;
    end else begin
      ei_in = 0;
      cin = 0;
    end
  
  always @(ei_in or wrk1x_r or cin) new_error_r = ei_in + wrk1x_r + cin;
  always @(wrk1x_r) eneg = wrk1x_r[15];
  always @(wrk1x_r) eeqz = ~|wrk1x_r;
  /************************************************************************************************/
  always @(posedge de_clk) if(ld_wrk1_l)  wrk1y_r <= new_wrk1_r[15:0];
  always @(posedge de_clk) if(ld_wrk2_h)  wrk2x_r <= new_wrk2_r[31:16];
  always @(posedge de_clk) if(ld_wrk2_l)  wrk2y_r <= new_wrk2_r[15:0];
  always @(posedge de_clk) if(ld_wrk3_h)  wrk3x_r <= new_wrk3_r[31:16];
  always @(posedge de_clk) if(ld_wrk3_l)  wrk3y_r <= new_wrk3_r[15:0];
  always @(posedge de_clk) if(ld_wrk4_h)  wrk4x_r <= new_wrk4_r[31:16];
  always @(posedge de_clk) if(ld_wrk4_l)  wrk4y_r <= new_wrk4_r[15:0];
  always @(posedge de_clk) if(ld_wrk5_h)  wrk5x_r <= new_wrk5h_r;
  always @(posedge de_clk) if(ld_wrk5_l)  wrk5y_r <= new_wrk5l_r;
  always @(posedge de_clk) if(ld_wrk6x_h) wrk6x_r <= new_wrk6x_r[15:0];
  always @(posedge de_clk) if(ld_wrk7x_h) wrk7x_r <= new_wrk7x_r[15:0];
  /********************************************************************************/
  reg load_disab;
  wire load_disab_d;
  assign load_disab_d = load_disab; /* dummy delay for hdl simulation. */
  wire 	 ird_eq_wr;
  assign ird_eq_wr = (wrk3x_r[11:0] == wrk4x_r[11:0]);

  /********************************************************************************/
  wire 	 cmd_rstn;
  assign cmd_rstn = de_rstn & load_actvn;

  wire 	 ld_wrk4d_h;
  assign ld_wrk4d_h = ld_wrk4_h; /* dummy delay for hdl simulation. */

  /* delay the load by one clock and if load_disab is set block the load. */
  reg 	 ld_wrk4dd_h;
  always @(posedge de_clk or negedge cmd_rstn)
    begin
      if(!cmd_rstn)                      ld_wrk4dd_h <= 1'b0;
      else if(ld_wrk4d_h & ~load_disab_d)ld_wrk4dd_h <= 1'b1;
      else if(ld_wrk4d_h & ~load_disab_d)ld_wrk4dd_h <= 1'b1;
      else                               ld_wrk4dd_h <= 1'b0;
    end

  wire ld_wrk4ddd_h;
  assign ld_wrk4ddd_h = ld_wrk4dd_h;
  always @(posedge de_clk or negedge cmd_rstn)
    begin
      if(!cmd_rstn)        rd_eq_wr <= 1'b0;
      else if(ld_wrk4ddd_h)rd_eq_wr <= ird_eq_wr;
    end

  /* This signal allows the rd_eq_wr flag to be loaded only once per command. */
  always @(posedge de_clk or negedge cmd_rstn)
    begin
      if(!cmd_rstn)          load_disab <= 1'b0;
      else if(b_clr_ld_disab)load_disab <= 1'b0;
      else if(ld_wrk4ddd_h)  load_disab <= 1'b1;
    end
  /********************************************************************************/
  /*			LINE DIRECTION REGISTER					*/
  /********************************************************************************/
  always @(posedge de_clk or negedge de_rstn)
    begin
      if(!de_rstn)                      dir <= 3'b0;
      else if(ldmajor)                  dir[2] <= fx[15];
      else if(ldminor)                  dir[1:0] <= {fy[15],fx[15]};
      else if(!load_actvn_in && !stpl_1)dir <= {1'b0,xy3_1[1:0]};
      else if(!load_actvn_in)           dir <= 3'b0;
    end
  /********************************************************************************/
  /*			DELAY MEMORY REQUEST					*/	
  /********************************************************************************/
  reg del_mem_req;
  always @(posedge de_clk)del_mem_req <= mem_req;
  reg del_mem_read;
  always @(posedge de_clk)del_mem_read <= mem_read;
  /********************************************************************************/
  /*			START OF LINE FLAG					*/
  /********************************************************************************/
  always @(posedge de_clk or negedge de_rstn)
    begin
      if(!de_rstn)                        sol_2 <= 1'b0;
      else if(set_sol)                    sol_2 <= 1'b1;
      else if(del_mem_req & !del_mem_read)sol_2 <= 1'b0;
      else if(tx_clr_seol)                sol_2 <= 1'b0;
    end
  /********************************************************************************/
  /*			END OF LINE FLAG					*/
  /********************************************************************************/
  always @(posedge de_clk or negedge de_rstn)
    begin
      if(!de_rstn)        eol_2 <= 1'b0;
      else if(set_eol)    eol_2 <= 1'b1;
      else if(del_mem_req)eol_2 <= 1'b0;
      else if(tx_clr_seol)eol_2 <= 1'b0;
    end
  /********************************************************************************/
  /*			Line Pattern Control					*/
  /********************************************************************************/
  wire	     		end_scl;	/* end of scale factor.			*/
  wire	     		end_pat;	/* end of pattern signal.		*/
  wire [4:0] 		plen;		/* pattern length.			*/
  wire [2:0] 		pscl;		/* pattern scale. 			*/
  wire [4:0] 		sptr;		/* pattern initial start point.		*/
  wire [2:0] 		sscl;		/* pattern initial scale factor. 	*/
  assign 		{sscl,sptr,pscl,plen} = pctrl_r;	
  reg [4:0] 		pptr_r;
  reg [2:0] 		scl;
  reg	     		load_pat;

  always @(posedge de_clk)load_pat <= (prst && (line_actv_1 | line_actv_3d_1) && !load_actvn_in);

  /* PATTERN CONTROL DEFAULT VALUES */
  always @(posedge de_clk or negedge de_rstn)
    begin
      if(!de_rstn)
	begin
	  pptr_r <= 5'b0;
	  scl <= 3'b0;
	end
      else if(load_pat)
	begin
	  pptr_r <= sptr;
	  scl <= pscl - sscl;
	end
      else if((l3_incpat | incpat) && end_scl)
	begin
	  scl <= pscl;
	  if(end_pat)pptr_r <= 5'b0;
	  else pptr_r <= pptr_r+5'b1;
	end
      else if(l3_incpat | incpat) scl <= scl-3'b1;
      
    end

  /* ASSIGN TEST BITS */
  assign end_pat = ((plen-1) == pptr_r);
  assign end_scl = (scl == 0);

  /* ASSIGN PATTERN MULTIPLEXER */
  assign fg_bgn = lpat_r[pptr_r];

  /* CREATE THE READ BACK STATE OF THE LINE PATTERN */
  assign lpat_state = {(pscl-scl),pptr_r,pscl,plen};

  /********************************************************************************/
  /*			Status comparators					*/
  /*										*/
  /* CREATE THE WRK_EQZ SIGNAL */
  assign wrk0_eqz = ~|wrk0x_r;

  /* CREATE THE WRK_EQZ SIGNAL */
  assign wrk5_eqz = ~|wrk5y_r;

  /* CREATE THE WRITE WORDS GREATER THAN EIGHT SIGNAL */ 
  assign wr_gt_8 = (|wrk4x_r[15:4]) | (wrk4x_r[3] & |wrk4x_r[2:0]);
  assign wr_gt_16 = (|wrk4x_r[15:5]) | (wrk4x_r[4] & |wrk4x_r[3:0]);

endmodule


