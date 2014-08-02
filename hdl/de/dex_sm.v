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
//  Title       :  Drawing Engine Execution State Machines
//  File        :  dex_sm.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module handles the execution of Drawing Engine commands
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
module dex_sm
  (
   input	    de_clk,		// drawing engine clock			
   input            de_rstn,		// syncronous reset 			
   input            mclock,    		 // Memory Controller clock
   input    	    cstop_2,		// stop on clip boundry 		
   input            nlst_2,		// no last pixel     			
   input	    solid_1,		// solid bit				
   input    	    solid_2,		// solid bit				
   input            trnsp_2,		// transparent bit			
   input     	    stpl_pk_1,		// packed stipple bit level one.       	
   input [1:0]	    stpl_2,		// stipple bit.                        	
   input [1:0]	    apat_2,		// area mode.{32x32 planar,32x32,8x8}.	
   input     	    apat_1,		// the or of the area pattern mode bits level1
   input     	    sfd_2,		// source fetch disable.	      
   input            edi_2,		// triangle edge include.   
   input            mcrdy,		// memory controller is busy	   
   input            pcbusyin,		// pixel cache is busy.		 
   input            clip,		// hit clipping boundry	   
   input            wrk0_eqz,		// working counter = 0
   input            wrk5_eqz,		// working counter = 0
   input            signx,		// sign bit of X alu	       	
   input            signy,		// sign bit of X alu		   
   input            xeqz,		// alu X equals zero		  
   input            yeqz,		// alu Y equals zero               
   input [2:0]	    dir,		// dirrection bits			 
   input [3:0]      opc_1,     		// drawing opcode       	     
   input [3:0]      opc_15,     	// drawing opcode       	     
   input [3:0]      rop_1,      	// drawing raster operation.  	      
   input [3:0]      rop_2,     	 	// drawing raster operation.  	      
   input	    pc_dirty,		// data is left in the pixel cache.    
   input	    ps16_1,		// Pixel size equals sixteen.	   
   input	    ps32_1,		// Pixel size equals thirty two. 
   input	    ps8_2,		// Pixel size equals eight.    
   input	    ps16_2,		// Pixel size equals sixteen. 
   input	    ps32_2,		// Pixel size equals thirty two.
   input	    eol_2,		// end of line flag.      
   input [2:0]	    frst8,		// start of line read eight flag. 
   input	    ca_rdy,		// Cache ready bit.	                 
   input	    pad8_2,		// Select 8 bit padding.	         
   input	    wr_gt_8,		// Write words greater than eight.       
   input	    wr_gt_16,		// Write words greater than sixteen.    
   input	    eneg,eeqz,		// error is neg, error is zero.    	  
   input	    force8,		// Force a 8 page mode.                
   input [2:0]	    clp_status,
   input	    mw_fip,
   input            load_actvn,		// load active command  		  
   input            cmdcpyclr,		// command copy clear.                 
   input            goline,		// Start Line Command.                 
   input            goblt,		// Start BLT Command.                 
   input            busy_3d,		// 3D command in progress.            
   
   output [4:0]	    aluop,		// alu operation field		      
   output reg [4:0] aad,		// register file A read address	      
   output reg [4:0] bad,		// register file B read address	   
   output [3:0]	    wad,		// register file write address	   
   output [1:0]     wen,		// register file write enables	   
   output reg [4:0] ksel,		// constant select                
   output 	    l_ldmaj,		// load major dirrection bits	   
   output           l_ldmin,		// load minor dirrection bits	
   output           l_bound,		// hit clipping boundry int.	      
   output           l_incpat,		// inc line pattern pointer 		
   output [3:0]	    src_cntrl,		// source counter control bits.        
   output [1:0]	    dst_cntrl, 		// source counter control bits.     
   output	    wrk_chgx,  		// working counter control bit.                
   output	    pixreq,		// pixel request to the MC		
   output           busy_out,		// drawing engine is busy		  
   output           mem_req,		// memory request			  
   output           mem_rd,		// memory read				  
   output           mem_rmw,		// read modify write			
   output           line_actv_1,	// line is active			  
   output           line_actv_3d_1,	// line 3d is active			  
   output           eline_actv_1,	// eline is line is active		  
   output           pline_actv_1,	// poly line is line is active		  
   output reg       pline_actv_2,	// poly line is line is active		  
   output reg       line_actv_2,	// line is active			
   output           blt_actv_1,		// bit blt is active			 
   output reg       blt_actv_2,		// bit blt is active			 
   output reg	    rstn_wad,		// load the cache write address counter.
   output reg	    ld_rad,		// load the cache read address counter.    
   output	    ld_rad_e,		// load the cache read address counter
   output	    set_sol,		// set the start of line signal.         
   output           set_eol,		// set the end of line signal.          
   output reg       ld_msk,		// load the start ansd end masks.       
   output reg       ld_wcnt,		// load the page count.                 
   output reg	    mul,		//  mul the srx, dstx, and sizex by 2, or 4
   output reg	    local_sol,	
   output reg	    mod8,	
   output reg	    mod32,	
   output	    read_2,		
   output	    clr_seol,		
   output reg	    ld_initial,
   output	    next_x,
   output	    dex_next_x,
   output	    next_y,
   output 	    inc_err,
   output           rst_err,
   output reg       last_pixel,
   output           pc_msk_last,
   output reg       frst_pix,
   output reg       src_upd,
   output           b_clr_ld_disab,
   output 	    b_cin,
   output reg	    dex_busy
   );

/**************************************************************************/
// reg		last_pixel_d;
reg		noop_actv_2;
reg		eline_actv_2;
  
parameter
	NOOP      	= 4'h0,
	BLT       	= 4'h1,
	LINE      	= 4'h2,
	ELINE     	= 4'h3,
	P_LINE    	= 4'h5,
	LINE_3D    	= 4'h8,
	PAL    	        = 4'hB,
 	Clear		=4'b0000,
	CopyInverted	=4'b0011,
	Invert		=4'b0101,
	Copy		=4'b1100,
	Set		=4'b1111;

  /**************************************************************************/
  /*              Create the cache ready signal.                            */
  wire 	 cache_rdy;
  assign cache_rdy = ~(sfd_2 & ~ca_rdy);
  /**************************************************************************/
  /*              combine up the source counter control bits.               */
  wire 	 s_chgx,         /* source change the X position counter.*/
         s_rht,          /* source x direction is right.         */
         s_chgy,         /* source change the Y position counter.*/
         s_dwn;          /* source y direction is down.          */
  assign src_cntrl = {s_chgx,s_rht,s_chgy,s_dwn};
  /**************************************************************************/
  /*              combine the destination counter control bits.             */
  wire 	 d_chgy,         /* destination change the Y position counter.   */
         d_dwn;          /* destination y direction is down.             */
  assign dst_cntrl = {d_chgy,d_dwn};
  /**************************************************************************/
  /*              define registers and wires			*/
  /**************************************************************************/
  /*        LOCAL REGISTERS.					*/
  
  reg 	 busy, 
	 d_busy;
  
  reg 	 ld_rad1,
	 src_upd_d;
  
  //        REGISTERS FOR THE LINE STATEMACHINE.     
  wire 	     l_chgx,
	     l_chgy,
             l_dec_itr,
	     l_pixreq,
	     l_set_busy,
	     l_clr_busy,
	     l_mul,
	     l_pc_msk_last,
	     l_frst_pix,
	     l_last_pixel,
	     l_src_upd;

  //        REGISTERS FOR THE BITBLT STATEMACHINE.	
  wire 	     b_set_busy,
	     b_clr_busy,
	     b_mem_req,
	     b_mem_rd,
	     b_ld_wcnt,
	     b_dchgy,
	     b_rstn_wad,
	     b_ld_rad,
	     b_set_multi,
	     b_clr_multi,
	     b_set_frst_pass,
	     b_clr_frst_pass,
	     b_set_end,
	     b_clr_end,
	     b_set_last_pass,
	     b_clr_last_pass,
	     b_set_sol,
	     b_set_eol,
	     b_set_eor,
	     b_ld_msk,
	     b_mul,
	     b_mod8,
	     b_mod32,
	     b_rst_cr,
	     b_set_soc,
	     b_clr_soc;
  
  wire [4:0] b_ksel;
  wire 	     b_sdwn,b_ddwn;
  
  //        REGISTERS FOR THE LINEAR BLT STATEMACHINE.
  wire 	     lb_set_busy,
	     lb_clr_busy,
	     lb_ld_wcnt,
	     lb_mem_req,
	     lb_mem_rd,
	     lb_dchgy,
	     lb_rstn_wad,
	     lb_ld_rad,
	     lb_ld_rad_e,
	     lb_set_sol,
	     lb_set_eol,
	     lb_ld_msk,
	     lb_set_soc,
	     lb_clr_soc,
	     lb_set_local_eol,
	     lb_clr_local_eol,
	     lb_set_sos,
	     lb_clr_sos,
	     lb_set_eos,
	     lb_clr_eos,
	     lb_set_sor,
	     lb_clr_sor,
	     lb_set_eof,
	     lb_clr_eof,
	     lb_clr_sol,
	     lb_mul,
	     lb_rst_cr,
	     tx_clr_seol;
  
  wire [4:0] lb_ksel;
  
  //        Wires FOR THE LINEAR AREA BLT STATEMACHINE.
  wire 	     lab_set_busy,
	     lab_clr_busy,
	     lab_ld_wcnt,
	     lab_mem_req,
	     lab_mem_rd,
	     lab_dchgy,
	     lab_rstn_wad,
	     lab_ld_rad,
	     lab_set_sol,
	     lab_set_eol,
	     lab_ld_msk,
	     lab_mul,
	     lab_set_local_eol,
             lab_clr_local_eol,
	     lab_rst_cr;
  wire [4:0] lab_ksel;
  
  wire 	     apat8_2,apat32_2,
	     l_rht,l_dwn,clr_sol;
  wire 	     ld_rad0;
  
  /**************************************************************************/
  wire 	     src_upd_dd;
  always @(posedge de_clk)src_upd_d <= l_src_upd;
  assign     src_upd_dd = src_upd_d;
  always @(posedge de_clk)src_upd <= src_upd_dd;
  /***************************************************************************/
  always@(posedge de_clk)ld_initial <= ~load_actvn;
  assign     next_x = l_chgx;
  assign     dex_next_x = l_chgx & ~pcbusyin;
  assign     next_y = l_chgy;

  /***************************************************************************/
  /*              define registers and wires				*/
  /***************************************************************************/
  wire 	     rmw,wr_gt_8_16;
  assign     clr_seol = tx_clr_seol;
  assign     pc_msk_last = l_pc_msk_last;
  always @(posedge de_clk)frst_pix <= l_frst_pix;
  always @* last_pixel <= l_last_pixel;
  // always @(posedge de_clk)last_pixel_d <= last_pixel;
  
  assign     read_2 = !(((rop_2 == Clear) && !trnsp_2) || 
			((rop_2 == Invert) && !trnsp_2) || 
			((rop_2 == Set) && !trnsp_2) || solid_2 || sfd_2);
  
  assign     mem_rmw  = ((rop_2 != Clear) &&
			 (rop_2 != CopyInverted) &&
			 (rop_2 != Copy) &&
			 (rop_2 != Set));

  assign     rmw  = mem_rmw; //  | force8;
  // assign rmw  = 1'b1;
  // assign wr_gt_8_16  =  (~force8 & wr_gt_16) | (force8 & wr_gt_8);
  assign     wr_gt_8_16  =  wr_gt_8;

  assign     line_actv_3d_1	= (opc_15 == LINE_3D);
  assign     line_actv_1	= (opc_1 == LINE) || (opc_1 ==ELINE) || (opc_1 ==P_LINE);
  assign     eline_actv_1 	= (opc_1 == ELINE);	
  assign     pline_actv_1	= (opc_1 == P_LINE);	
  assign     blt_actv_1		= (opc_1 == BLT);
  wire 	     noop_actv_1	= (opc_1 == NOOP);
  
  always @(posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) begin
      pline_actv_2 	<= 1'b0;
      line_actv_2  	<= 1'b0;
      eline_actv_2 	<= 1'b0;
      blt_actv_2   	<= 1'b0;
      noop_actv_2   	<= 1'b0;
    end
    else if(!load_actvn) begin
      pline_actv_2 	<= pline_actv_1;
      line_actv_2  	<= line_actv_1;
      eline_actv_2 	<= eline_actv_1;
      blt_actv_2   	<= blt_actv_1;
      noop_actv_2   	<= noop_actv_1;
    end
    else if(cmdcpyclr) begin
      pline_actv_2 	<= 1'b0;
      line_actv_2  	<= 1'b0;
      eline_actv_2 	<= 1'b0;
      blt_actv_2   	<= 1'b0;
      noop_actv_2   	<= 1'b0;
    end
  end
  
  assign apat32_2 = apat_2[1];
  assign apat8_2  = apat_2[0];

  always @(posedge de_clk)mod8<=b_mod8; 
  always @(posedge de_clk)mod32<=b_mod32; 
  
  /****************************************************************/
  /* 			combine the operands.			*/
  /****************************************************************/
  wire	[21:0]  l_op;     /* line operand.			*/
  wire [21:0] 	b_op;     /* bitblt operand			*/
  wire [21:0] 	lab_op;    /* packed stipple bitblt operand	*/
  wire [21:0] 	lb_op;    /* packed bitblt operand	*/
  reg [10:0] 	op;       /* operand				*/
  
  always @* {aad,bad} = (b_op[21:12] | l_op[21:12] | lab_op[21:12] | 
			 lb_op[21:12]);

  always @(posedge de_clk)
    op[10:2] <= ({b_op[11:7],b_op[5:2]} | {l_op[11:7],l_op[5:2]} | 
		 {lab_op[11:7],lab_op[5:2]} | {lb_op[11:7],lb_op[5:2]});
  always @(posedge de_clk)
    op[1:0] <= (b_op[1:0] & l_op[1:0] & lab_op[1:0] & lb_op[1:0]);

  assign 	{aluop,wad,wen}= op;

  /****************************************************************/
  /* 			combine the constant select.			*/
  /****************************************************************/
  always @* begin
    if(blt_actv_2 && (stpl_2[1] && (|apat_2)))ksel=lab_ksel;
    else if(blt_actv_2 && stpl_2[1] && !(apat_2[1] | apat_2[0]))ksel=lb_ksel;
    else if(blt_actv_2)ksel=b_ksel;
    else ksel=5'h1;
  end
  /****************************************************************/
  /*		combine state machine output signals.		*/
  /*		these signals don't require clocking.		*/
  assign pixreq = l_pixreq;
  assign s_rht = (line_actv_2 & l_rht);
  assign s_chgx =  (line_actv_2 & l_chgx & ~pcbusyin);
  assign s_dwn = ((stpl_2[1] & blt_actv_2) | (blt_actv_2 & b_sdwn)) | (line_actv_2 & l_dwn);
  assign s_chgy = (line_actv_2 & l_chgy & ~pcbusyin);
  
  assign d_dwn =  blt_actv_2 & (stpl_2[1] | b_ddwn);
  assign d_chgy = blt_actv_2 & (b_dchgy | lab_dchgy | lb_dchgy);
  assign wrk_chgx = line_actv_2 & l_dec_itr;
  assign ld_rad0 = b_ld_rad | lab_ld_rad | lb_ld_rad;
  assign set_sol = b_set_sol | lab_set_sol | lb_set_sol;
  assign clr_sol = lb_clr_sol;
  assign set_eol = b_set_eol | lab_set_eol | lb_set_eol;
  assign mem_req = b_mem_req | lab_mem_req | lb_mem_req;
  assign mem_rd =  b_mem_rd | lab_mem_rd | lb_mem_rd; 
  wire 	 set_eor;
  assign set_eor = b_set_eor;
  always @(posedge de_clk)mul <= b_mul | lab_mul | l_mul | lb_mul;
  wire 	 clr_local_eol;
  wire 	 set_local_eol;
  assign clr_local_eol = lab_clr_local_eol | lb_clr_local_eol;
  assign set_local_eol = lab_set_local_eol | lb_set_local_eol;
  /****************************************************************/
  always @(posedge de_clk) rstn_wad <= b_rstn_wad | lab_rstn_wad | lb_rstn_wad;
  assign ld_rad_e = lb_ld_rad_e;
  always @(posedge de_clk)
    begin
      ld_rad <= ld_rad1 | lb_ld_rad_e;
      ld_rad1 <= ld_rad0;
    end
  always @(posedge de_clk)ld_msk <= b_ld_msk | lab_ld_msk | lb_ld_msk;
  /****************************************************************/
  /*		Create the local start of line flag.  		*/
  /*		                                    		*/
  always @(posedge de_clk or negedge de_rstn)
    begin
      if(!de_rstn)local_sol<=1'b0;
      else if(clr_sol)local_sol<=1'b0;
      else if(set_sol)local_sol<=1'b1;
      else if(mem_req && !mem_rd)local_sol<=1'b0;
    end
/****************************************************************/
/*		Create the local start of line flag.  		*/
/*		                                    		*/
reg		local_eol;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)local_eol<=1'b0;
		else if(clr_local_eol)local_eol<=1'b0;
		else if(set_local_eol)local_eol<=1'b1;
	end
/****************************************************************/
/*		Create the start of write segment flag.  		*/
/*		                                    		*/
reg		sos;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)sos<=1'b0;
		else if(lb_clr_sos)sos<=1'b0;
		else if(lb_set_sos)sos<=1'b1;
	end
/****************************************************************/
/*		Create the end of write segment flag.  		*/
/*		                                    		*/
reg		eos;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eos<=1'b0;
		else if(lb_clr_eos)eos<=1'b0;
		else if(lb_set_eos)eos<=1'b1;
	end
/****************************************************************/
/*		Create the end or reads flag.  			*/
/*		                                    		*/
reg		eor;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eor<=1'b0;
		else if(set_eor)eor<=1'b1;
		else if(!load_actvn)eor<=1'b0;
		else if(set_sol)eor<=1'b0;
	end
/****************************************************************/
/*		Create the end of fifo flag.  			*/
/*		                                    		*/
reg		eof;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eof<=1'b0;
		else if(lb_set_eof)eof<=1'b1;
		else if(!load_actvn)eof<=1'b0;
		else if(lb_clr_eof)eof<=1'b0;
	end
/****************************************************************/
/*              Create the start or reads flag.                   */
/*                                                              */
reg             sor;
always @(posedge de_clk or negedge de_rstn)
        begin
                if(!de_rstn)sor<=1'b0;
                else if(lb_clr_sor)sor<=1'b0;
                else if(lb_set_sor)sor<=1'b1;
        end
/****************************************************************/
/*		Create the start of command flag.  		*/
/*		                                    		*/
reg		soc;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)soc<=1'b0;
		else if(lb_clr_soc | ~load_actvn | b_clr_soc)soc<=1'b0;
		else if(lb_set_soc | b_set_soc)soc<=1'b1;
	end
/****************************************************************/
/*		Create the multi pass.	 	 		*/
/*		                                    		*/
reg		multi;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)multi<=1'b0;
		else if(b_clr_multi | ~load_actvn)multi<=1'b0;
		else if(b_set_multi)multi<=1'b1;
	end
/****************************************************************/
/*		Create the first pass.	 	 		*/
/*		                                    		*/
reg		frst_pass;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)frst_pass<=1'b0;
		else if(b_clr_frst_pass | ~load_actvn)frst_pass<=1'b0;
		else if(b_set_frst_pass)frst_pass<=1'b1;
	end
/****************************************************************/
/*		Create the last pass.	 	 		*/
/*		                                    		*/
reg		last_pass;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)last_pass<=1'b0;
		else if(b_clr_last_pass | ~load_actvn)last_pass<=1'b0;
		else if(b_set_last_pass)last_pass<=1'b1;
	end
/****************************************************************/
/*		Create the end pass.	 	 		*/
/*		                                    		*/
reg		end_pass;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)end_pass<=1'b0;
		else if(b_clr_end | ~load_actvn)end_pass<=1'b0;
		else if(b_set_end)end_pass<=1'b1;
	end
/****************************************************************/
/*		delay the load word count by one clock.		*/
/*		to allow for the ALU pipeline delay.		*/
always @(posedge de_clk) ld_wcnt <= b_ld_wcnt | lab_ld_wcnt | lb_ld_wcnt;
/****************************************************************/
/*		combine state machine output signals.		*/
/*		these signals do require clocking.		*/

reg		busy_2d;
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)busy_2d <= 1'b0;
		else if(l_set_busy | b_set_busy | lab_set_busy | lb_set_busy)busy_2d<=1'b1;
		else if(/* last_pixel_d */ l_clr_busy | b_clr_busy |
			lab_clr_busy | lb_clr_busy)busy_2d<=1'b0;
	end

assign busy_out = busy_2d | busy_3d;

always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)busy <= 1'b0;
		else if(l_set_busy | b_set_busy | lab_set_busy | lb_set_busy)busy<=1'b1;
		else if(/* last_pixel_d*/ l_clr_busy | b_clr_busy | lab_clr_busy | lb_clr_busy)busy<=1'b0;
	end
always @* dex_busy=l_set_busy | b_set_busy | lab_set_busy | lb_set_busy | busy | busy_3d;

/****************************************************************/


//
// Dispatcher state machine
//
dex_smdisp u_dex_smdisp
	(
	// Inputs.
	.de_clk			(),
	.de_rstn		(),
	.d_busy			(),
	.cmdrdy			(),
	.pcbusy			(pcbusyin),
	.line_actv_1		(line_actv_1),
	.blt_actv_1		(blt_actv_1),
	.noop_actv_2		(noop_actv_2),
	// Outputs.
	.goline			(),
	.goblt			(),
	.d_cmdack		(),
	.d_cmdcpyclr		(),
	.load_actvn		(),
	// For Test Only.
	.d_cs			()
	);
//
// Line state machine
//
dex_smline u_dex_smline
	(
	// Inputs.
	.de_clk			(de_clk),
	.de_rstn		(de_rstn),
	.goline			(goline),
	.dir			(dir),
	.eol			(wrk0_eqz),
	.signx			(signx),
	.eline_actv_2		(eline_actv_2),
	.pcbusy			(pcbusyin),
	.nlst_2			(nlst_2),
	.clip			(clip),
	.cstop_2		(cstop_2),
	.eneg			(eneg),
	.eeqz			(eeqz),
	// Outputs.
	.l_ldmaj		(l_ldmaj),
	.l_ldmin		(l_ldmin),
	.l_bound		(l_bound),
	.l_incpat		(l_incpat),
	.inc_err		(inc_err),
	.rst_err		(rst_err),
	.l_chgx			(l_chgx),
	.l_chgy			(l_chgy),
	.l_dec_itr		(l_dec_itr),
	.l_pixreq		(l_pixreq),
	.l_set_busy		(l_set_busy),
	.l_clr_busy		(l_clr_busy),
	.l_mul			(l_mul),
	.l_pc_msk_last		(l_pc_msk_last),
	.l_frst_pix		(l_frst_pix),
	.l_last_pixel		(l_last_pixel),
	.l_src_upd		(l_src_upd),
	.l_op			(l_op),
	.l_rht			(l_rht),
	.l_dwn			(l_dwn)
	);

//
// BLT state machine
//
dex_smblt u_dex_smblt
	(
	// Inputs.
	.de_clk			(de_clk),
	.de_rstn		(de_rstn),
	.dir			(dir[1:0]),
	.goblt			(goblt),
	.stpl_pk_1		(stpl_pk_1),
	.mcrdy			(mcrdy),
	.cache_rdy		(cache_rdy),
	.signx			(signx),
	.signy			(signy),
	.yeqz			(yeqz),
	.xeqz			(xeqz),
	.read_2			(read_2),
	.ps16_1			(ps16_1),
	.ps32_1			(ps32_1),
	.ps8_2			(ps8_2),
	.ps16_2			(ps16_2),
	.ps32_2			(ps32_2),
	.apat8_2		(apat8_2),
	.apat32_2		(apat32_2),
	.frst_pass		(frst_pass),
	.last_pass		(last_pass),
	.multi			(multi),
	.soc			(soc),
	.rmw			(rmw),
	.eor			(eor),
	.local_sol		(local_sol),
	.frst8_1		(frst8[1]),
	.mw_fip			(mw_fip),
	.eol_2			(eol_2),
	.end_pass		(end_pass),
	// Outputs.
	.b_op			(b_op),
	.b_ksel			(b_ksel),
	.b_set_busy		(b_set_busy),
	.b_clr_busy		(b_clr_busy),
	.b_mem_req		(b_mem_req),
	.b_mem_rd		(b_mem_rd),
	.b_ld_wcnt		(b_ld_wcnt),
	.b_dchgy		(b_dchgy),
	.b_rstn_wad		(b_rstn_wad),
	.b_ld_rad		(b_ld_rad),
	.b_set_sol		(b_set_sol),
	.b_set_eol		(b_set_eol),
	.b_set_eor		(b_set_eor),
	.b_ld_msk		(b_ld_msk),
	.b_mul			(b_mul),
	.b_mod8			(b_mod8),
	.b_mod32		(b_mod32),
	.b_rst_cr		(b_rst_cr),
	.b_set_soc		(b_set_soc),
	.b_clr_soc		(b_clr_soc),
	.b_set_multi		(b_set_multi),
	.b_clr_multi		(b_clr_multi),
	.b_set_frst_pass	(b_set_frst_pass),
	.b_clr_frst_pass	(b_clr_frst_pass),
	.b_set_end		(b_set_end),
	.b_clr_end		(b_clr_end),
	.b_set_last_pass	(b_set_last_pass),
	.b_clr_last_pass	(b_clr_last_pass),
	.b_clr_ld_disab		(b_clr_ld_disab),
	.b_cin			(b_cin),
	.b_sdwn			(b_sdwn),
	.b_ddwn			(b_ddwn)
	);
//
// Area BLT state machine
//
dex_smlablt u_dex_smlablt
	(
	// Inputs.
	.de_clk			(de_clk),
	.de_rstn		(de_rstn),
	.goblt			(goblt),
	.stpl_pk_1		(stpl_pk_1),
	.apat_1			(apat_1),
	.mcrdy			(mcrdy),
	.cache_rdy		(cache_rdy),
	.signx			(signx),
	.signy			(signy),
	.yeqz			(yeqz),
	.xeqz			(xeqz),
	.clp_status		(clp_status),
	.apat32_2		(apat32_2),
	.rmw			(rmw),
	.read_2			(read_2),
	.mw_fip			(mw_fip),
	.local_eol		(local_eol),
	// Outputs.
	.lab_op			(lab_op),
	.lab_ksel		(lab_ksel),
	.lab_set_busy		(lab_set_busy),
	.lab_clr_busy		(lab_clr_busy),
	.lab_ld_wcnt		(lab_ld_wcnt),
	.lab_mem_req		(lab_mem_req),
	.lab_mem_rd		(lab_mem_rd),
	.lab_dchgy		(lab_dchgy),
	.lab_rstn_wad		(lab_rstn_wad),
	.lab_ld_rad		(lab_ld_rad),
	.lab_set_sol		(lab_set_sol),
	.lab_set_eol		(lab_set_eol),
	.lab_ld_msk		(lab_ld_msk),
	.lab_mul		(lab_mul),
	.lab_set_local_eol	(lab_set_local_eol),
	.lab_clr_local_eol	(lab_clr_local_eol),
	.lab_rst_cr		(lab_rst_cr)
	);

//
// Linear BLT state machine
//
dex_smlblt u_dex_smlblt
	(
	.de_clk			(de_clk),
	.de_rstn		(de_rstn),
	.goblt			(goblt),
	.stpl_pk_1		(stpl_pk_1),
	.apat_1			(apat_1),
	.sor			(sor),
	.eof			(eof),
	.sos			(sos),
	.eos			(eos),
	.local_eol		(local_eol),
	.mcrdy			(mcrdy),
	.signx			(signx),
	.signy			(signy),
	.yeqz			(yeqz),
	.xeqz			(xeqz),
	.read_2			(read_2),
	.ps32_1			(ps32_1),
	.ps16_1			(ps16_1),
	.ps32_2			(ps32_2),
	.ps16_2			(ps16_2),
	.eol_2			(eol_2),
	.local_sol		(local_sol),
	.eor			(eor),
	.ps8_2			(ps8_2),
	.apat32_2		(apat32_2),
	.soc			(soc),
	.cache_rdy		(cache_rdy),
	.sfd_2			(sfd_2),
	.wr_gt_8_16		(wr_gt_8_16),
	.wrk5_eqz		(wrk5_eqz),
	.mw_fip			(mw_fip),
	.rmw			(rmw),
	// Outputs.
	.lb_op			(lb_op),
	.lb_ksel		(lb_ksel),
	.lb_set_busy		(lb_set_busy),
	.lb_clr_busy		(lb_clr_busy),
	.lb_ld_wcnt		(lb_ld_wcnt),
	.lb_mem_req		(lb_mem_req),
	.lb_mem_rd		(lb_mem_rd),
	.lb_dchgy		(lb_dchgy),
	.lb_rstn_wad		(lb_rstn_wad),
	.lb_ld_rad		(lb_ld_rad),
	.lb_ld_rad_e		(lb_ld_rad_e),
	.lb_set_sol		(lb_set_sol),
	.lb_set_eol		(lb_set_eol),
	.lb_ld_msk		(lb_ld_msk),
	.lb_set_soc		(lb_set_soc),
	.lb_clr_soc		(lb_clr_soc),
	.lb_set_local_eol	(lb_set_local_eol),
	.lb_clr_local_eol	(lb_clr_local_eol),
	.lb_set_sos		(lb_set_sos),
	.lb_clr_sos		(lb_clr_sos),
	.lb_set_eos		(lb_set_eos),
	.lb_clr_eos		(lb_clr_eos),
	.lb_set_sor		(lb_set_sor),
	.lb_clr_sor		(lb_clr_sor),
	.lb_set_eof		(lb_set_eof),
	.lb_clr_eof		(lb_clr_eof),
	.lb_clr_sol		(lb_clr_sol),
	.tx_clr_seol		(tx_clr_seol),
	.lb_mul			(lb_mul),
	.lb_rst_cr		(lb_rst_cr)
	);

endmodule
