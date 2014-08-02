///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2009 - All rights reserved
//
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Conexant Systems, Inc., hereafter the "licensee", as defined by the NDA and the 
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
//  Title       :  Packed Stipple Area BLT State Machine
//  File        :  dex_smlablt.v
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

  module dex_smlablt
    (
     input		de_clk,
     input		de_rstn,
     input		goblt,
     input		stpl_pk_1,
     input		apat_1,
     input		mcrdy,
     input		cache_rdy,
     input		signx,
     input		signy,
     input		yeqz,
     input		xeqz,
     input	[2:0]	clp_status,
     input		apat32_2,
     input		rmw,
     input		read_2,
     input		mw_fip,
     input		local_eol,

     output	reg	[21:0]	lab_op,
     output	reg	[4:0]	lab_ksel,
     output	reg		lab_set_busy,
     output	reg		lab_clr_busy,
     output	reg		lab_ld_wcnt,
     output	reg		lab_mem_req,
     output	reg		lab_mem_rd,
     output	reg		lab_dchgy,
     output	reg		lab_rstn_wad,
     output	reg		lab_ld_rad,
     output	reg		lab_set_sol,
     output	reg		lab_set_eol,
     output	reg		lab_ld_msk,
     output	reg		lab_mul,
     output	reg		lab_set_local_eol,
     output	reg		lab_clr_local_eol,
     output	reg		lab_rst_cr

     );


  // These parameters were formerly included by de_param.h
  //`include "de_param.h"
  parameter 	one 	        = 5'h1,
		LAB_WAIT        = 5'h0,
		LABS1           = 5'h1,
		LABS2           = 5'h2,
		LABS3           = 5'h3,
		LABS4           = 5'h4,
		LABS5           = 5'h5,
		LABR1           = 5'h6,
		LABR2           = 5'h7,
		LABR3           = 5'h8,
		LABW1           = 5'h9,
		LABW2           = 5'ha,
		LABW3           = 5'hb,
		LABW4           = 5'hc,
		LABNL1          = 5'hd,
		LABNL2          = 5'he,
		LABNL3          = 5'hf,
		LABNL4          = 5'h10,
		LABS2B          = 5'h11,
		LABS2C          = 5'h12,
		LABS2D          = 5'h13,
		LABS2E          = 5'h14,
		LABS2F          = 5'h15,
		LABS2G          = 5'h16,
		noop            = 5'h0,		// noop address.
		pline           = 5'h10,	// pipeline address
		sorgl           = 5'he,		// src org address low nibble.
		dorgl           = 5'hf,		// src org address low nibble.
		src             = 5'h0,		// source/start point register
		dst             = 5'h1,		// destination/end point
		mov 		= 5'hd,		// bx--> fx, by--> fy
		pix_dstx  	= 5'h5,	        // wrk3x
		wrhi            = 2'b01,        // define write enables
		wrlo            = 2'b10,        // define write enables
		wrhl            = 2'b00,        // define write enables
		wrno            = 2'b11,        // define write enables
		addnib  	= 5'h2,		// ax + bx(nibble)
		dst_sav		= 5'h9,	        // dst & wrk1y
		add 		= 5'h1,		// ax + bx, ay + by
		size 	  	= 5'h2,	        // wrk0x and wrk0y
		sav_dst   	= 5'h4,
		xend_pc         = 5'h09,
		xmin_pc         = 5'h0a,
		xmax_pc         = 5'h0b,
		sub  		= 5'h12,	// ax - bx, ay - by 
		amcn 		= 5'h4,		// ax-k, ay-k	   
		amcn_d		= 5'h14,	// {ax - const,ax - const}
		zero 	        = 5'h0,
		four 	        = 5'h4,
		div16 		= 5'ha,		// bx/16 + wadj.
		wr_wrds_sav	= 5'hc,	        // wrk4x & wrk6x
		mov_k 		= 5'he,		// move constant.
		eight 	        = 5'h6,
		wr_wrds		= 5'h6,	        // wrk4x
		sav_src_dst     = 5'h3,	        // wrk1x & wrk1y
		movx 		= 5'hf,		// bx--> fy, by--> fx 
		apcn 		= 5'h6,		// ax+k, ay+k     
		D64  	        = 5'h11,
		D128 	        = 5'h15,
		sav_wr_wrds	= 5'h8;	        // wrk6x

	
  
  
  /****************************************************************/
  /* 			DEFINE PARAMETERS			*/
  /****************************************************************/
  /* define internal wires and make assignments 	*/
  reg [4:0] 	lab_cs;
  reg [4:0] 	lab_ns;

  /* create the state register */
  always @(posedge de_clk or negedge de_rstn) 
    begin
      if(!de_rstn)lab_cs <= 0;
      else lab_cs <= lab_ns;
    end


  always @*
    begin
      lab_op            = 22'b00000_00000_00000_00000_11;
      lab_ksel          = one;
      lab_set_busy      = 1'b0;
      lab_clr_busy      = 1'b0;
      lab_ld_wcnt       = 1'b0;
      lab_mem_req       = 1'b0;
      lab_mem_rd        = 1'b0;
      lab_dchgy         = 1'b0;
      lab_rstn_wad      = 1'b0;
      lab_ld_rad        = 1'b0;
      lab_set_sol       = 1'b0;
      lab_set_eol       = 1'b0;
      lab_mem_req       = 1'b0;
      lab_mem_rd        = 1'b0;
      lab_ld_msk        = 1'b0;
      lab_mul           = 1'b0;
      lab_set_local_eol = 1'b0;
      lab_clr_local_eol = 1'b0;
      lab_rst_cr        = 1'b0;

      case(lab_cs) /* synopsys full_case parallel_case */

	/* if goblt and stipple and area pattern begin.			*/
	/* ELSE wait.							*/
	LAB_WAIT:if(goblt && (stpl_pk_1 && apat_1)) 
	  begin
	    lab_ns=LABS1;
	    lab_op={noop,dst,mov,pix_dstx,wrhi};
	    lab_set_busy = 1'b1;
	    lab_mul = 1'b1;
	  end
	else lab_ns= LAB_WAIT;
	/* multiply the src, dst, and size by 2 for 16BPP, or 4 for 32BPP. */
	/* add org low nibble to destination point */
	/* save the original destination X, to use on the next scan line. */
	LABS1:	begin
	  lab_ns=LABS2;
	  lab_op={dorgl,dst,addnib,dst_sav,wrhl};
	end
	LABS2:	begin
	  lab_ns=LABS2B;
	  lab_op={sorgl,src,add,src,wrhi};
	end
	LABS2B:	begin
	  lab_ns=LABS2C;
	  lab_op={noop,size,mov,sav_dst,wrlo};
	end
	LABS2C:	begin
	  if(clp_status[2]) // trivial reject.
	    begin
	      lab_clr_busy = 1'b1;
	      lab_rst_cr = 1'b1;
	      lab_ns=LAB_WAIT;
	    end
	  else if(clp_status==3'b000)lab_ns=LABS3; // No clipping.
	  else if(clp_status==3'b011)
	    begin
	      lab_op={xend_pc,xmax_pc,sub,noop,wrno};
	      lab_ns=LABS2F;
	    end
	  else begin
	    lab_op={xmin_pc,dst,sub,noop,wrno};
	    lab_ns=LABS2D;
	  end
	end
	LABS2D:	begin
	  lab_op={size,pline,sub,size,wrhi};
	  if(clp_status==3'b001)lab_ns=LABS2G;
	  else lab_ns=LABS2E;
	end
	LABS2E:	begin
	  lab_op={xend_pc,xmax_pc,sub,noop,wrno};
	  lab_ns=LABS2F;
	end
	LABS2F:	begin
	  lab_op={size,pline,sub,size,wrhi};
	  if(clp_status==3'b011)lab_ns=LABS3;
	  else lab_ns=LABS2G;
	end
	LABS2G:	begin
	  lab_op={xmin_pc,noop,amcn_d,dst_sav,wrhl};
	  lab_ksel=zero;
	  lab_ns=LABS3;
	end
	/* calculate the write words per line adjusted X size. */
	LABS3:	begin	
	  lab_ns=LABS4;
	  lab_set_sol=1'b1;
	  if(clp_status==3'b000)lab_op={dst,size,div16,wr_wrds_sav,wrhi};
	  else if(clp_status==3'b011) lab_op={dst,pline,div16,wr_wrds_sav,wrhi};
	  else lab_op={pline,size,div16,wr_wrds_sav,wrhi};
	end
	/* generate the start and end mask to be loaded in LABS5.                 */
	LABS4:	begin
	  lab_ns=LABS5;
	  lab_op={dst,size,add,noop,wrno};
	  lab_rstn_wad = 1'b1;
	end
	/* source minus destination nibble mode. for FIFO ADDRESS read = write, read = write-1.	*/
	/* this will set the first read 8 flag if source nibble is less than destination nibble.*/
	LABS5:	begin	
	  lab_ns=LABR1;
	  lab_ld_msk=1'b1;	/* load the mask generated in LABS4.    */
	  lab_op={noop,pix_dstx,mov,noop,wrno};
	  lab_ld_rad = 1'b1;
	end
	/* load the one and only read page count.	*/
	LABR1:	begin
	  lab_ld_wcnt=1'b1; /* this signal is externally delayed one clock. */
	  lab_op={noop,noop,mov_k,noop,wrno};
	  if(apat32_2)lab_ksel=eight;
	  else lab_ksel=one;
	  lab_ns=LABR2;
	  
	end
	LABR2:	lab_ns=LABR3;
	/* request the read cycles.                   */
	LABR3:	begin
	  lab_op={wr_wrds,noop,amcn,noop,wrno};
	  if(!rmw)lab_ksel=eight;
	  else lab_ksel=four;
	  /* if source fetch disable skip the read. */
	  if(!read_2)lab_ns=LABW1;
	  else if(mcrdy && !mw_fip)
	    begin
	      lab_mem_req=1'b1;
	      lab_mem_rd=1'b1;
	      lab_ns=LABW1;
	    end
	  else lab_ns=LABR3;
	end

	/* wait for the pipeline.	*/
	LABW1:	begin
	  lab_ns=LABW2;
	  if(!rmw)lab_ksel=eight;
	  else lab_ksel=four;
	  lab_op={wr_wrds,noop,amcn,wr_wrds,wrhi};
	end

	/* Begin the write portion of the stretch bit blt state machine. */
	LABW2:	begin
	  lab_ld_wcnt=1'b1;
	  lab_ns=LABW3;
	  if(!rmw)lab_ksel=eight;
	  else lab_ksel=four;
	  if(signx | xeqz)begin
	    lab_op={noop,wr_wrds,mov,noop,wrno};
	    lab_set_eol=1'b1;
	    lab_set_local_eol=1'b1;
	  end
	  else lab_op={noop,noop,mov_k,noop,wrno};
	end
	/* add 128 to the destination x pointer.	*/
	LABW3:	begin
	  if(local_eol && mcrdy && cache_rdy)
	    begin
	      lab_op={noop,sav_src_dst,movx,dst,wrhi};
	      lab_ns=LABW4;
	    end
	  else if(mcrdy && cache_rdy)
	    begin
	      lab_op={dst,noop,apcn,dst,wrhi};
	      lab_ns=LABW4;
	    end
	  else lab_ns=LABW3;
	  if(rmw)lab_ksel=D64;
	  else lab_ksel=D128;
	end

	LABW4:	begin
	  if(local_eol)
	    begin	
	      lab_op={noop,sav_src_dst,movx,dst,wrhi};
	      lab_mem_req=1'b1;
	      lab_clr_local_eol=1'b1;
	      lab_ns=LABNL1;
	    end
	  else
	    begin 
	      lab_op={wr_wrds,noop,amcn,noop,wrno};
	      if(!rmw)lab_ksel=eight;
	      else lab_ksel=four;
	      lab_mem_req=1'b1;
	      lab_ns=LABW1;
	    end
	end

	/* decrement the Y size register.       */
	LABNL1:	begin
	  lab_op={size,noop,amcn,size,wrlo};
	  lab_set_sol=1'b1;
	  lab_dchgy = 1'b1;
	  lab_ns=LABNL2;
	end
	/* restore the write words per line.		*/
	LABNL2:	begin
	  lab_op={noop,sav_wr_wrds,mov,wr_wrds,wrhi};
	  lab_ns=LABNL3;
	end
	/* If Y size register goes to zero the bit blt is all done.	*/
	/* Restore the original X destination registers.  */
	LABNL3:	begin
	  if(!rmw)lab_ksel=eight;
	  else lab_ksel=four;
	  if(yeqz)
	    begin
	      lab_clr_busy = 1'b1;
	      lab_rst_cr = 1'b1;
	      lab_ns=LAB_WAIT;
	    end
	  else begin
	    lab_ns=LABW1; 
	    lab_op={pline,noop,amcn,noop,wrno};
	  end
	end
	LABNL4:	
	  begin
	    lab_op={dst,pline,sub,dst,wrlo};
	    lab_ns=LABS3;
	  end
      endcase

    end

endmodule
