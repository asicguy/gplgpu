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
//  Title       :  LBIT BLT State Machine
//  File        :  dex_smblt.v
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
  module dex_smlblt
    (
     input		de_clk,
     input		de_rstn,
     input		goblt,
     input		stpl_pk_1,
     input		apat_1,
     input		sor,
     input		eof,
     input		sos,
     input		eos,
     input		local_eol,
     input		mcrdy,
     input		signx,
     input		signy,
     input		yeqz,
     input		xeqz,
     input		read_2,
     input		ps32_1,
     input		ps16_1,
     input		ps32_2,
     input		ps16_2,
     input		eol_2,
     input		local_sol,
     input		eor,
     input		ps8_2,
     input		apat32_2,
     input		soc,
     input		cache_rdy,
     input		sfd_2,
     input		wr_gt_8_16,
     input		wrk5_eqz,
     input		mw_fip,
     input		rmw,

     output	reg	[21:0]	lb_op,
     output	reg	[4:0]	lb_ksel,
     output	reg		lb_set_busy,
     output	reg		lb_clr_busy,
     output	reg		lb_ld_wcnt,
     output	reg		lb_mem_req,
     output	reg		lb_mem_rd,
     output	reg		lb_dchgy,
     output	reg		lb_rstn_wad,
     output	reg		lb_ld_rad,
     output	reg		lb_ld_rad_e,
     output	reg		lb_set_sol,
     output	reg		lb_set_eol,
     output	reg		lb_ld_msk,
     output	reg		lb_set_soc,
     output	reg		lb_clr_soc,
     output	reg		lb_set_local_eol,
     output	reg		lb_clr_local_eol,
     output	reg		lb_set_sos,
     output	reg		lb_clr_sos,
     output	reg		lb_set_eos,
     output	reg		lb_clr_eos,
     output	reg		lb_set_sor,
     output	reg		lb_clr_sor,
     output	reg		lb_set_eof,
     output	reg		lb_clr_eof,
     output	reg		lb_clr_sol,
     output	reg		tx_clr_seol,
     output	reg		lb_mul,
     output	reg		lb_rst_cr
     );

  /****************************************************************/
  /* 			DEFINE PARAMETERS			*/
  /****************************************************************/
parameter
        LB_WAIT		= 5'h0,
	LBS1		= 5'h1,
	LBS2		= 5'h2,
	LBS3		= 5'h3,
	LBS4		= 5'h4,
	LBS5		= 5'h5,
	LBS6		= 5'h6,
	LBS7		= 5'h7,
	LBS8		= 5'h8,
	LBR1		= 5'h9,
	LBR2		= 5'ha,
	LBR3		= 5'hb,
	LBW1		= 5'hc,
	LBW2		= 5'hd,
	LBW3		= 5'he,
	LBW4		= 5'hf,
	LBW5		= 5'h10,
	LBW6		= 5'h11,
	LBW7		= 5'h12,
	LBW8		= 5'h13,
	LBW9		= 5'h14,
	LBW10		= 5'h15,
	LBW11		= 5'h16,
	LBNL1		= 5'h17,
	LBNL2		= 5'h18,
	LBNL3		= 5'h19,
	LBNL4		= 5'h1a,
	LBNL5		= 5'h1b,
	LBNL6		= 5'h1c,
	LBTX0		= 5'h1e,
	LBTX1		= 5'h1f,
	noop 		= 5'h0,
	src  		= 5'h0,
	dst  		= 5'h1,
	size 	  	= 5'h2,
	sorgl 		= 5'he,
	pline 		= 5'h10,
	dorgl 		= 5'hf,
	dst_sav		= 5'h9,	
	wr_wrds_sav	= 5'hc,	
	sav_rad	  	= 5'h3,	
	hst_pg_cnt	= 5'h7,	
	wr_wrds		= 5'h6,	
	pg_ff	  	= 5'h5,	
	wr_seg		= 5'hd,	
	pages	  	= 5'h7,	
	sav_wr_wrds	= 5'h8,	
	pages_X16  	= 5'h7,	
        sav_src_dst    	= 5'h3,	
	apcn 		= 5'h6,	
	mov_k 		= 5'he,	
	movx 		= 5'hf,	
	mov 		= 5'hd,	
	add 		= 5'h1,	
	pad_x 		= 5'h9,	
	pix_ln	  	= 5'h5,	
	c_m_bnib	= 5'h10,
	X4		= 5'h15,
	X8		= 5'h18,
	pix_ff	  	= 5'h4,	
	addnib  	= 5'h2,	
	div16 		= 5'ha,	
	sub  		= 5'h12,
	sublin		= 5'h1c,
	subx  		= 5'h13,
	div4l 		= 5'h1d,
	div8l 		= 5'h1e,
	div16l 		= 5'h1f,
	amcn 		= 5'h4,	
	X16		= 5'h19,
	addlin		= 5'h1b,
	wrlo 		= 2'b10,
	wrhi 		= 2'b01,
	wrno 		= 2'b11,
	wrhl 		= 2'b00,
	one 		= 5'h1,
	four 		= 5'h4,
	seven 		= 5'h5,
	eight 		= 5'h6,
	D64  		= 5'h11,
	D112 		= 5'h14,
	D128 		= 5'h15,
	D896 		= 5'h16;

  /****************************************************************/
  /* define internal wires and make assignments 	*/
  reg [4:0] 	lb_cs;
  reg [4:0] 	lb_ns;

  /* create the state register */
  always @(posedge de_clk or negedge de_rstn) 
    begin
      if(!de_rstn)lb_cs <= 5'b0;
      else lb_cs <= lb_ns;
    end


  always @*
    begin
      lb_op            = 22'b00000_00000_00000_00000_11;
      lb_ksel          = one;
      lb_set_busy      = 1'b0;
      lb_clr_busy      = 1'b0;
      lb_ld_wcnt       = 1'b0;
      lb_mem_req       = 1'b0;
      lb_mem_rd        = 1'b0;
      lb_dchgy         = 1'b0;
      lb_rstn_wad      = 1'b0;
      lb_ld_rad        = 1'b0;
      lb_ld_rad_e      = 1'b0;
      lb_set_sol       = 1'b0;
      lb_set_eol       = 1'b0;
      lb_mem_rd        = 1'b0;
      lb_ld_msk        = 1'b0;
      lb_set_soc       = 1'b0;
      lb_clr_soc       = 1'b0;
      lb_set_local_eol = 1'b0;
      lb_clr_local_eol = 1'b0;
      lb_set_sos       = 1'b0;
      lb_clr_sos       = 1'b0;
      lb_set_eos       = 1'b0;
      lb_clr_eos       = 1'b0;
      lb_set_sor       = 1'b0;
      lb_clr_sor       = 1'b0;
      lb_set_eof       = 1'b0;
      lb_clr_eof       = 1'b0;
      lb_clr_sol       = 1'b0;
      tx_clr_seol      = 1'b0;
      lb_mul           = 1'b0;
      lb_rst_cr        = 1'b0;

      case(lb_cs) /* synopsys full_case parallel_case */

        /* Calculate the number of bits per line including 32bit or 8bit padding. */
        /* ELSE wait.                                                   */
	LB_WAIT: if(goblt && stpl_pk_1 && !apat_1)
          begin
            if(read_2)lb_ns=LBS1;
            else begin
	      lb_ns=LBS4;
	      lb_mul = 1'b1;
	    end
	    lb_op={size,noop,pad_x,pix_ln,wrlo};
            lb_set_busy = 1'b1;
	    lb_mul = 1'b1;
          end
        else lb_ns= LB_WAIT;

	/* add org low nibble to source point */
	LBS1:	begin
	  lb_op={sorgl,src,add,src,wrhi};
	  if(read_2)lb_ns=LBS2;
	  else lb_ns=LBS4;
        end
 	/* The first step to calculate the number of pixels in the fifo, is 128 bytes    */
        /* minus the source offset.                */
	LBS2:	begin
          lb_op={noop,pline,c_m_bnib,noop,wrno};
	  lb_ns=LBS3;
	  lb_ksel=D128;
	end
 	/* The second step to calculate the number of pixels in the fifo, is multiply by 8 */
	LBS3:	begin
          lb_op={pline,noop,X8,pix_ff,wrhi};
	  lb_ns=LBS4;
	end
        /* Add org destination point and */
        /* save the original destination X, to use on the next scan line. */
	LBS4:	begin
          lb_op={dorgl,dst,addnib,dst_sav,wrhl};
	  lb_ns=LBS5;
	  lb_set_sol=1'b1; // set start of line.
	  lb_set_sor=1'b1; // set start of reads.
	  lb_set_soc=1'b1; // set start of command.
	end
	/* calculate the write words per line adjusted X size.  */
	/* load the word count register for sfd mode.		*/
	LBS5:	begin	
	  lb_ns=LBS6;
	  lb_op={pline,size,div16,wr_wrds_sav,wrhi};
	end
	/* generate the start and end mask to be loaded in LBS10.                 */
	LBS6:	begin
	  lb_ld_wcnt=1'b1; /* this signal is externally delayed one clock. */
	  lb_ns=LBS7;
	  lb_op={dst,size,add,noop,wrno};
	  lb_rstn_wad = 1'b1;
	end
	LBS7:	begin	
	  lb_ns=LBS8;
	  if(ps32_2 && !read_2)lb_op={src,src,add,noop,wrno};
	  else if(ps16_2 && !read_2)lb_op={src,noop,X4,noop,wrno};
	  else lb_op={src,noop,X8,noop,wrno};
	  lb_ld_msk=1'b1;	/* load the mask generated in LBS6.    */
	end
	/* source minus destination nibble mode. for FIFO ADDRESS read = write, read = write-1.	*/
	/* this will set the first read 8 flag if source nibble is less than destination nibble.*/
	LBS8:	begin	
	  if(read_2 && mcrdy)begin
	    lb_ns=LBR1;
	    if(wrk5_eqz | wr_gt_8_16)lb_ld_rad = 1'b1;
	    lb_op={pline,dst,sublin,sav_rad,wrhi};
	  end
	  else if(sfd_2 && !wr_gt_8_16 && mcrdy)
	    begin
	      lb_ns=LBTX0;
	      lb_set_eol=1'b1;
	      lb_op={pline,dst,sublin,sav_rad,wrhi};
	    end
	  else if (mcrdy)
	    begin
	      lb_ns=LBW3;
	      lb_ld_rad = 1'b1;
	      lb_op={pline,dst,sublin,sav_rad,wrhi};
	    end
	  else 
	    begin
	      lb_ns=LBS8;
	      lb_op={noop,pline,mov,noop,wrno};
	    end
	end
	/* set the number of pages per read. */
	LBR1:	begin
	  lb_ld_wcnt=1'b1; /* this signal is externally delayed one clock. */
	  lb_ns=LBR2;
	  if(!wrk5_eqz && soc)lb_op={noop,hst_pg_cnt,movx,noop,wrno};
	  else lb_op={noop,noop,mov_k,noop,wrno};
	  if(sor) lb_ksel=eight;
	  else lb_ksel=seven;
	end
	LBR2:	begin
	  lb_ns=LBR3;
	  if(!sor)lb_op={pix_ff,noop,apcn,pix_ff,wrhi};
	  lb_ksel=D896;
	end
	/* request the page read. */
	LBR3:	begin
	  if(mcrdy && !mw_fip)
	    begin
	      lb_mem_req=1'b1;
	      lb_mem_rd=1'b1;
	      lb_ns=LBW1;
	      lb_op={noop,wr_wrds,mov,noop,wrno};
	      lb_ld_wcnt=1'b1; 
	    end
	  else lb_ns=LBR3;
	end
	/* subtract pixel per line from pixels in the fifo. */
	/* to find out which is larger.                         */
	LBW1:	begin
	  if(!wrk5_eqz && !wr_gt_8_16 && soc)
	    begin
	      lb_ns=LBTX0;
	      lb_set_eol=1'b1;
	      lb_op={noop,sav_rad,mov,noop,wrno};
	    end
	  else begin
	    lb_ns=LBW2;
	    lb_op={pix_ff,pix_ln,subx,noop,wrno};
	  end
	end
	/* calculate the pages in the fifo. */
	LBW2:	begin
	  lb_ns=LBW3;
	  if(ps8_2)lb_op={dst,pix_ff,div16l,pg_ff,wrhi};
	  else if(ps16_2)lb_op={dst,pix_ff,div8l,pg_ff,wrhi};
	  else lb_op={dst,pix_ff,div4l,pg_ff,wrhi};
	end
	/* calculate the segment count. */
	/* if no read segment equals words per line count. */
	LBW3:	begin
	  lb_ns=LBW4;
	  if(signx && read_2)
	    begin /* write the whole fifo to memory. */
	      lb_op={pline,noop,amcn,wr_seg,wrhi};
	      lb_set_eof=1'b1;
	      lb_set_sos=1'b1;
	    end
	  else if(xeqz && read_2)
	    begin /* write the whole fifo to memory. */
	      lb_op={noop,wr_wrds,mov,wr_seg,wrhi};
	      lb_set_eof=1'b1;
	      lb_set_local_eol=1'b1;
	    end
	  else	begin /* write the whole line to memory. */
	    lb_op={noop,wr_wrds,mov,wr_seg,wrhi};
	    lb_set_local_eol=1'b1;
	  end
	end
	/* write segment minus max page count of seven  */
	/* or eight if no read.                         */
	LBW4:	begin
	  if(mcrdy && cache_rdy)
	    begin
	      lb_ns=LBW5;
	      lb_op={pline,noop,amcn,noop,wrno};
	      // lb_ksel=eight;
	      if(!rmw)lb_ksel=eight;
	      else lb_ksel=four;

	    end
	  else begin
	    lb_ns=LBW4;
	    lb_op={noop,pline,mov,noop,wrno};
	  end
	end

	/* Wait for the pipline. */
	LBW5:	begin
	  if(xeqz)lb_ns=LBNL3;
	  else if(soc)
	    begin
	      lb_ns=LBW6;
	      lb_clr_soc=1'b1;
	    end
	  else lb_ns=LBW6;
	  if(sos)begin
	    lb_clr_sos=1'b1;
	    lb_op={wr_seg,noop,movx,wr_wrds,wrlo};
	  end


	end

	/* calculate the pages to request. */
	LBW6:	begin
	  lb_ld_wcnt=1'b1; /* this signal is externally delayed one clock. */
	  lb_ns=LBW7;
	  // lb_ksel=eight;
	  if(!rmw)lb_ksel=eight;
	  else lb_ksel=four;
	  if((xeqz || signx) && (local_eol || !read_2))
	    begin /* end of segment and end of line. */
	      /* must setup for next line.	 */
	      lb_op={noop,wr_seg,mov,pages,wrhi};
	      lb_set_eol=1'b1;
	      lb_set_eos=1'b1;
	    end
	  else if(xeqz || signx)
	    begin /* end of this segment and not end of line. */
	      /* need more read data.			  */
	      lb_op={noop,wr_seg,mov,pages,wrhi};
	      lb_set_eos=1'b1;
	    end
	  else lb_op={noop,noop,mov_k,pages,wrhi};
	end
	/* update the segment page count. */
	LBW7:	begin
	  lb_op={pline,dst,X16,pages,wrhi};
	  lb_ns=LBW8;
	end
	/* update the segment page count. */
	LBW8:	begin
	  lb_mem_req=1'b1;
	  if(read_2)lb_ns=LBW9;
	  else lb_ns=LBW10;
	  if(eof && eos && !local_eol)lb_op={sav_wr_wrds,wr_wrds,subx,wr_wrds,wrhi};
	  else if(eof && eos)lb_op={noop,sav_wr_wrds,mov,wr_wrds,wrhi};
	  else lb_op={wr_seg,pages,sub,wr_seg,wrhi};
	end
	/* update the pixels in the fifo count. */
	LBW9:	begin
	  if(local_eol && eos)lb_op={pix_ff,pix_ln,subx,pix_ff,wrhi};
	  lb_ns=LBW10;
	  lb_clr_sol = 1'b1;
	end
	/* update the destination X. */
	LBW10:	begin
	  if(read_2)lb_op={dst,pages_X16,add,dst,wrhi};
	  else lb_op={dst,noop,apcn,dst,wrhi};

	  if(local_eol && eos)lb_ns = LBNL1;
	  else if(eof && eos)lb_ns = LBNL3;
	  else lb_ns=LBW11;
	  // lb_ksel=D128;
	  if(!rmw)lb_ksel=D128;
	  else lb_ksel=D64;
	end
	/* update the destination X. */
	LBW11:	begin
	  lb_op={noop,wr_seg,mov,noop,wrno};
	  lb_ns=LBW4;
	end
	/* restore the write words per line.		*/
	LBNL1:	begin
	  lb_ns=LBNL2;
	  if(read_2)lb_op={noop,sav_wr_wrds,mov,wr_wrds,wrhi};
	  else lb_op={noop,sav_wr_wrds,mov,wr_seg,wrhi};
	  lb_dchgy = 1'b1;
	end
	LBNL2:	begin
	  if(mcrdy)
	    begin
	      lb_op={sav_rad,pix_ln,addlin,sav_rad,wrhi};
	      lb_ld_rad = 1'b1;
	      if(read_2)lb_ns=LBNL3;
	      else lb_ns=LBNL4;
	    end
	  else lb_ns=LBNL2;
	end
	/* Increment the source Y registers.  */
	LBNL3:	begin
	  lb_ns=LBNL4;
	  if(eof)lb_op={src,noop,apcn,src,wrhi};
	  if(sor && eof)begin
	    lb_ksel=D128;
	    lb_clr_sor=1'b1;
	  end
	  else lb_ksel=D112;
	end
	LBNL4:	begin
	  if((local_eol && eos) || !read_2)begin
	    lb_op={size,noop,amcn,size,wrlo};
	    lb_set_sol=1'b1;
	  end
	  else lb_op={noop,size,mov,noop,wrno};
	  lb_clr_eos=1'b1;
	  lb_ns=LBNL5;
	end
	/* Wait for pipeline delay.  */
	LBNL5:	lb_ns=LBNL6;

	/* If Y size register goes to zero the bit blt is all done.	*/
	/* else go back and read more data.				*/
	/* Restore the original X destination registers.  */
	LBNL6:	begin
	  if(yeqz)begin
	    lb_clr_busy = 1'b1;
	    lb_ns=LB_WAIT;
	    lb_rst_cr = 1'b1;
	  end
	  else if(eof & read_2)begin
	    lb_ns=LBR1;
	    lb_clr_eof = 1'b1;
	    if(local_eol)lb_op={noop,sav_src_dst,movx,dst,wrhi};
	  end
	  else if(!read_2) 
	    begin
	      lb_ns=LBW3; 
	      lb_op={noop,sav_src_dst,movx,dst,wrhi};
	    end
	  else 	begin
	    lb_ns=LBW1; 
	    lb_op={noop,sav_src_dst,movx,dst,wrhi};
	  end
	  lb_clr_local_eol=1'b1;
	end

	LBTX0:	begin
	  if(!soc && yeqz)
	    begin
	      lb_clr_busy = 1'b1;
	      lb_ns=LB_WAIT;
	      lb_rst_cr = 1'b1;
	      tx_clr_seol = 1'b1;
	    end
	  else if(mcrdy && cache_rdy)
	    begin
	      lb_op={size,noop,amcn,size,wrlo};
	      // lb_dchgy = 1'b1;
	      lb_ns=LBTX1; 
	      lb_clr_soc=1'b1;
	      lb_ld_rad_e = 1'b1;
	      // NEW 
	  lb_set_sol=1'b1;
	  lb_set_eol=1'b1;
	  	//
	    end
	  else begin
	    lb_ns=LBTX0; 
	    lb_set_soc = 1'b1;
	    lb_op={noop,pline,mov,noop,wrno};
	  end
	end
	LBTX1:	begin
	  lb_ns=LBTX0; 
	  lb_op={sav_rad,pix_ln,addlin,sav_rad,wrhi};
	  lb_mem_req=1'b1;
	  lb_dchgy = 1'b1;
	  // OLD
	  // lb_set_sol=1'b1;
	  // lb_set_eol=1'b1;
	end
      endcase

    end

endmodule
