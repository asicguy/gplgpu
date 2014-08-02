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
//  Title       :  Line State Machine
//  File        :  dex_smline.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Included by dex_sm.v
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
module dex_smline
	(
	input		de_clk,
	input		de_rstn,
	input		goline,
	input	[2:0]	dir,
	input 		eol,
	input 		signx,
	input 		eline_actv_2,
	input 		pcbusy,
	input 		nlst_2,
	input 		clip,
	input 		cstop_2,
	input 		eneg,
	input 		eeqz,

	output	reg	l_ldmaj,
	output	reg	l_ldmin,
	output	reg	l_bound,
	output	reg	l_incpat,
	output	reg	inc_err,
	output	reg	rst_err,
	output	reg	l_chgx,
	output	reg	l_chgy,
	output	reg	l_dec_itr,
	output	reg	l_pixreq,
	output	reg	l_set_busy,
	output	reg	l_clr_busy,
	output	reg	l_mul,
	output	reg	l_pc_msk_last,
	output	reg	l_frst_pix,
	output	reg	l_last_pixel,
	output	reg	l_src_upd,
	output	reg	[21:0]	l_op,
	output		l_rht,
	output		l_dwn
	);

/****************************************************************/
/* 			DEFINE PARAMETERS			*/
/****************************************************************/

parameter
        LWAIT		= 4'h0,
	L1		= 4'h1,
	L2		= 4'h2,
	L3		= 4'h3,
	L4		= 4'h4,
	L5		= 4'h5,
	L6		= 4'h6,
        L7		= 4'h7,
	L8		= 4'h8,
	LIDLE1		= 4'ha,
	src  		= 5'h0,
	dst  		= 5'h1,
	delta 		= 5'h2,
	noop 		= 5'h0,
	pline 		= 5'h10,
	einc 		= 5'h4,	
	error  		= 5'h3,
	err_inc  	= 5'hc,	
	sub  		= 5'h12,
	add 		= 5'h1,	
	abs 		= 5'h0,	
	mov 		= 5'hd,	
	movx 		= 5'hf,	
	subx  		= 5'h13,
	cmp_add 	= 5'h7,	
	addx  		= 5'h3,	
	wrhl 		= 2'b00,
	wrno 		= 2'b11,
	wrhi 		= 2'b01,
	dorgl 		= 5'hf;


	 parameter
		                /* define octants */
		                /* |YMAJ|sign dy|sign dx|	*/
		                /*  \       |       /	*/
		  o0=3'b000,	/*    \  7  |  6  /	*/
		  o1=3'b001,	/*      \   |   /	*/
		  o2=3'b010,	/*     3  \ | /	   2	*/
		  o3=3'b011,	/*  --------|-------	*/
		  o4=3'b100,	/*     1   /| \	   0	*/
		  o5=3'b101,	/*       /  |   \	*/
		  o6=3'b110,	/*     / 5  |  4  \	*/
		  o7=3'b111;	/*   /      |       \	*/

/* define internal wires and make assignments 	*/
reg	[3:0]	l_cs;
reg	[3:0]	l_ns;

/* create the state register */
always @(posedge de_clk or negedge de_rstn) begin
  if(!de_rstn)l_cs <= 4'b0;
  else l_cs <= l_ns;
end

  assign l_rht = ((dir==o0) || (dir==o2) || (dir==o4) || (dir==o6));
  assign l_dwn = ((dir==o0) || (dir==o1) || (dir==o4) || (dir==o5));
  
  always @* begin
    l_ldmaj       = 1'b0;
    l_ldmin       = 1'b0;
    l_bound       = 1'b0;
    l_incpat      = 1'b0;
    inc_err       = 1'b0;
    rst_err       = 1'b0;
    l_chgx        = 1'b0;
    l_chgy        = 1'b0;
    l_dec_itr     = 1'b0;
    l_pixreq      = 1'b0;
    l_set_busy    = 1'b0;
    l_clr_busy    = 1'b0;
    l_mul         = 1'b0;
    l_pc_msk_last = 1'b0;
    l_frst_pix    = 1'b0;
    l_last_pixel  = 1'b0;
    l_src_upd     = 1'b0;
    l_op          = 22'b00000_00000_00000_00000_11;
    
    case(l_cs) /* synopsys full_case parallel_case */
      
      LWAIT:	if(goline)
      begin	/* calculate deltaX and deltaY */
	l_ns=L1;
	l_op={dst,src,sub,delta,wrhl};
	l_set_busy=1'b1;
      end
      else l_ns= LWAIT;
      L1:	begin	/* absolute deltaX and deltaY */
	l_ns=L2;
	l_op={noop,pline,abs,delta,wrhl};
	l_mul=1'b1;
      end
      /* calculate the major axis */
      L2:	begin	/* deltaX minus deltaY and load the resulting sign bit in L4 */
	l_ldmin=1'b1;
	l_ns=L3;
	l_op={pline,pline,subx,noop,wrno};
      end
      /* wait for the pipeline delay,  and add the origin to the destination. */
      L3:	begin /* add org low nibble to source point */
	l_ns=L4;	
	l_op={dorgl,src,add,src,wrhi};
      end
      /* If deltaY < deltaX swap deltaX and deltY. */
      L4:	begin
	l_ldmaj=1'b1;
	l_ns=L5;
	if(signx)l_op={delta,delta,movx,delta,wrhl};
	else l_op={delta,delta,mov,noop,wrno};
      end
      
      L5:	if(!eline_actv_2)	/* if not eline calculate the two error increments */
      begin 		/* fx = (ax * 2) - (ay * 2), fy= (ay * 2) */
	l_ns=L6;
	l_op={pline,pline,err_inc,einc,wrhl};
      end
      else begin 
	l_ns=L6;
	l_op={einc,einc,subx,einc,wrhi};
      end
      
      /* initial error equals (-delta major + 2(delta minor)).	*/
      L6:	begin
	l_ns=L7;
	if(!eline_actv_2)l_op={pline,delta,cmp_add,error,wrhi};
	else l_op={error,einc,addx,error,wrhi};
      end
      
      L7:	begin
	if(!pcbusy)
	begin
	  l_op={noop,pline,mov,noop,wrno};
	  l_ns=4'hb;
	end
	else l_ns=L7;
	l_frst_pix=1'b1;
	// l_pipe_adv=1;
      end
      /* End of line with nolast set */
      /* Go to IDLE state.           */
      L8:	begin
	if(eol && nlst_2)
	begin
	  l_ns=LIDLE1;
	  l_pixreq=1'b1;
	  l_last_pixel = 1'b1;
	  l_pc_msk_last=1'b1;
	  l_op={noop,dst,mov,src,wrhl};
	  l_src_upd=1'b1;
	end
	
	/* End of line with nolast not set and stop or not stop. */
	/* draw last pixel if pixel cache is not busy. */
	/* Go to IDLE state.           */
   	else if(!pcbusy && eol && !nlst_2)
	begin
	  l_ns=LIDLE1;
	  l_incpat=1'b1;
	  l_op={noop,dst,mov,src,wrhl};
	  l_src_upd=1'b1;
	end
	/* Not end of line. */
	/* Hit clipping boundry with stop set. */
	/* Draw last pixel if pixel cache is not busy. */
	/* Go to IDLE state.           */
   	else if(!pcbusy && !eol && clip && cstop_2)
	begin
	  l_ns=LIDLE1;
	  l_bound=1'b1;
	  l_incpat=1'b1;
	  l_op={noop,dst,mov,src,wrhl};
	  l_src_upd=1'b1;
	end
	/* Not end of line draw pixel if pixel cache is no busy. */
   	else if(!pcbusy && !eol)
	begin
	  l_incpat=1'b1;
	  l_dec_itr=1'b1;
	  l_ns=L8;
	  if(!pcbusy && (dir==o1 || dir==o3 || dir==o5 || dir==o7) && !eneg && !eeqz)// >  0
	    /* error >=0 reset error */ rst_err=1;
	  else if(!pcbusy && (dir==o0 || dir==o2 || dir==o4 || dir==o6) && !eneg)	// >= 0
	    /* error > 0 reset error */ rst_err=1;
	  else if(!pcbusy)
	    /* increment error. */ inc_err=1;
	end
	else 	begin
	  l_op={noop,pline,mov,noop,wrno};
	  l_ns=L8;
	end

	if(!pcbusy) begin	
        	if(eol && !nlst_2) begin
	  		l_pixreq=1'b1;
	  		l_last_pixel = 1'b1;
        	end 
		else if(!eol && clip && cstop_2) l_pixreq=1'b1;
        	else if(!eol)l_pixreq=1'b1;
		
        	if(!eol && (dir==o1 || dir==o3 || dir==o5 || dir==o7) && !eneg && !eeqz)// >  0
          		l_chgx=1'b1;
        	else if(!eol && (dir==o0 || dir==o2 || dir==o4 || dir==o6) && !eneg)       // >= 0
          		l_chgx=1'b1;
        	else if(!eol && (dir==o0 || dir==o1 || dir==o2 || dir==o3))
          		l_chgx=1'b1;
		
        	if(!eol && (dir==o1 || dir==o3 || dir==o5 || dir==o7) && !eneg && !eeqz)// >  0
          		l_chgy=1'b1;
        	else if(!eol && (dir==o0 || dir==o2 || dir==o4 || dir==o6) && !eneg)         // >= 0
          		l_chgy=1'b1;
        	else if(!eol && (dir==o4 || dir==o5 || dir==o6 || dir==o7))
          		l_chgy=1'b1;
	end
	
	
	
      end
      4'hb:	begin
	l_ns=L8;
	l_op={noop,pline,mov,noop,wrno};
      end
      LIDLE1:	begin 
	l_ns=LWAIT;
	l_clr_busy=1'b1;
      end
    endcase
    
  end
  
endmodule
