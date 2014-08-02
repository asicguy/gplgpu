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
//  Title       :  Bit BLT State Machine
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

  module dex_smblt
    (
     input		de_clk,
     input		de_rstn,
     input	[1:0]	dir,
     input		goblt,
     input		stpl_pk_1,
     input		mcrdy,
     input		cache_rdy,
     input		signx,
     input		signy,
     input		yeqz,
     input		xeqz,
     input		read_2,
     input		ps16_1,
     input		ps32_1,
     input		ps8_2,
     input		ps16_2,
     input		ps32_2,
     input		apat8_2,
     input		apat32_2,
     input		frst_pass,
     input		last_pass,
     input		multi,
     input		soc,
     input		rmw,
     input		eor,
     input		local_sol,
     input		frst8_1,
     input		mw_fip,
     input		eol_2,
     input		end_pass,

     output	reg	[21:0]	b_op,
     output	reg	[4:0]	b_ksel,
     output	reg		b_set_busy,
     output	reg		b_clr_busy,
     output	reg		b_mem_req,
     output	reg		b_mem_rd,
     output	reg		b_ld_wcnt,
     output	reg		b_dchgy,
     output	reg		b_rstn_wad,
     output	reg		b_ld_rad,

     output	reg		b_set_sol,
     output	reg		b_set_eol,
     output	reg		b_set_eor,
     output	reg		b_ld_msk,
     output	reg		b_mul,
     output	reg		b_mod8,
     output	reg		b_mod32,
     output	reg		b_rst_cr,
     output	reg		b_set_soc,
     output	reg		b_clr_soc,
     output	reg		b_set_multi,
     output	reg		b_clr_multi,
     output	reg		b_set_frst_pass,
     output	reg		b_clr_frst_pass,
     output	reg		b_set_end,
     output	reg		b_clr_end,
     output	reg		b_set_last_pass,
     output	reg		b_clr_last_pass,
     output	reg		b_clr_ld_disab,
     output	reg		b_cin,
     output			b_sdwn,
     output			b_ddwn
     );

  // The following are from de_param.h
  //`include "de_param.h"
  parameter one         = 5'h1,
            B_WAIT      = 5'h0,
	    BS1         = 5'h1,
	    BS2         = 5'h2,
	    BS3         = 5'h3,
	    BS4         = 5'h4,
	    BS5         = 5'h5,
	    BS6         = 5'h6,
	    BS7         = 5'h7,
	    BS8         = 5'h8,
	    BS9         = 5'h9,
	    BS10        = 5'ha,
	    BS11        = 5'hb,
	    BS12        = 5'hc,
	    BS13        = 5'hd,
	    BR1         = 5'he,
	    BR2         = 5'hf,
	    BR3         = 5'h10,
	    BR4         = 5'h11,
	    BR5         = 5'h12,
	    BW1         = 5'h13,
	    BW2         = 5'h14,
	    BW3         = 5'h15,
	    BW4         = 5'h16,
	    BW5         = 5'h17,
	    BW6         = 5'h18,
	    BNL1        = 5'h19,
	    BNL2        = 5'h1a,
	    BNL3        = 5'h1b,
	    BNL4        = 5'h1c,
	    BNL5        = 5'h1d,
	    BNL6        = 5'h1e,
	    BNL7        = 5'h1f,
	    size        = 5'h2,	// wrk0x and wrk0y
	    wr_seg      = 5'hd,	// wrk7x
	    noop        = 5'h0,	// noop address.
	    pline       = 5'h10,// pipeline address.  
	    sorgl       = 5'he,	// src org address low nibble.
	    dorgl       = 5'hf,	// src org address low nibble.
	    amcn        = 5'h4,	// ax-k, ay-k
	    apcn_d      = 5'h8, // {ax + const,ax + const}
	    amcn_d      = 5'h14,// {ax - const,ax - const}
	    sub_d       = 5'h17,// {ax - bx,ax - bx}  
	    wrhl        = 2'b00,// define write enables
	    wrhi        = 2'b01,
	    wrlo        = 2'b10,// define write enables
	    wrno        = 2'b11,// define write enables
	    D24         = 5'hd, // not used
	    D48         = 5'he, // not used
	    D95         = 5'h10,
	    D94         = 5'h12,
	    D96         = 5'h13,
	    dst         = 5'h1,	// destination/end point
	    add         = 5'h1,	// ax + bx, ay + by   
	    sub         = 5'h12,// ax - bx, ay - by
	    addnib      = 5'h2,	// ax + bx(nibble)
	    movx        = 5'hf,	// bx--> fy, by--> fx
	    dst_sav     = 5'h9,	// dst & wrk1y
	    src         = 5'h0,	// source/start point register
	    src_sav     = 5'ha,	// src & wrk1x
	    mov 	= 5'hd,	// bx--> fx, by--> fy
	    mov_k       = 5'he,	// move constant
	    rd_wrds	= 5'h5,	// wrk3x
	    rd_wrds_sav	= 5'hb,	// wrk3x & wrk5x
	    wr_wrds_sav	= 5'hc,	// wrk4x & wrk6x
	    div16 	= 5'ha,	// bx/16 + wadj.
	    two 	= 5'h2,
	    four 	= 5'h4,
	    eight 	= 5'h6,
	    movmod 	= 5'h5,	// ay + by mod 8 or 32
	    adr_ofs  	= 5'h5,
	    mod_src  	= 5'h6,
	    apcn 	= 5'h6,	// ax+k, ay+k    	  
	    zoom   	= 5'h4,	// wrk2x & wrk2y
	    nib 	= 5'h11,// nibble
	    sav_yzoom  	= 5'h5,	// wrk3y
	    wr_wrds	= 5'h6,	// wrk4x
	    D16 	= 5'h8,
	    seven 	= 5'h5,
	    D64 	= 5'h11,
	    D112 	= 5'h14,
	    D128 	= 5'h15,
	    D256 	= 5'h7,
	    sav_rd_wrds	= 5'h7,	// wrk5x
	    sav_wr_wrds	= 5'h8,	// wrk6x
	    sav_src_dst = 5'h3;	// wrk1x & wrk1y


  /****************************************************************/
  /* 			DEFINE PARAMETERS			*/
  /****************************************************************/
  /* define internal wires and make assignments 	*/
  reg [4:0]	b_cs;
  reg [4:0] 	b_ns;

  assign 	b_sdwn = ~dir[0];
  assign 	b_ddwn = ~dir[0];

  /* create the state register */
  always @(posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) b_cs <= 5'b0;
    else         b_cs <= b_ns;
  end


  always @*
    begin
      b_op            = 22'b00000_00000_00000_00000_11;
      b_ksel          = one;
      b_set_busy      = 1'b0;
      b_clr_busy      = 1'b0;
      b_ld_wcnt       = 1'b0;
      b_mem_req       = 1'b0;
      b_mem_rd        = 1'b0;
      b_dchgy         = 1'b0;
      b_rstn_wad      = 1'b0;
      b_ld_rad        = 1'b0;
      b_set_sol       = 1'b0;
      b_set_eol       = 1'b0;
      b_mem_req       = 1'b0;
      b_mem_rd        = 1'b0;
      b_set_eor       = 1'b0;
      b_ld_msk        = 1'b0;
      b_mul           = 1'b0;
      b_mod32         = 1'b0;
      b_mod8          = 1'b0;
      b_rst_cr        = 1'b0;
      b_set_soc       = 1'b0;
      b_clr_soc       = 1'b0;
      b_set_multi     = 1'b0;
      b_clr_multi     = 1'b0;
      b_set_frst_pass = 1'b0;
      b_clr_frst_pass = 1'b0;
      b_set_end       = 1'b0;
      b_clr_end       = 1'b0;
      b_set_last_pass = 1'b0;
      b_clr_last_pass = 1'b0;
      b_clr_ld_disab  = 1'b0;
      b_cin           = 1'b0;

      case(b_cs) /* synopsys full_case parallel_case */

	/* Wait for goblt. */
	B_WAIT:	if(goblt && !stpl_pk_1)
	  begin
	    b_ns=BS1;
	    b_set_busy = 1'b1;
	    b_set_frst_pass = 1'b1;
	    b_mul = 1'b1;
	    b_op={size,noop,amcn,noop,wrno};

	    if(ps32_1)b_ksel=D24;
	    else if(ps16_1)b_ksel=D48;
	    else b_ksel=D96;
	  end
	else b_ns= B_WAIT;
	/* multiply the src, dst, and size by 2 for 16BPP, or 4 for 32BPP. */
	/* add org low nibble to destination point */
	/* save the original destination X, to use on the next scan line. */
	BS1:	begin
	  if(frst_pass)
	    begin
	      // b_op={dst,noop,apcn_d,dst_sav,wrhl};
	      b_op={dorgl,dst,addnib,dst_sav,wrhl};
	      if(read_2)b_cin = 1'b1;
	    end
	  else b_op={wr_seg,noop,movx,size,wrlo};
	  if(!read_2)b_ns=BS5;
	  else b_ns=BS2;
	  b_set_sol=1'b1;
	  b_set_soc=1'b1;
	  b_clr_ld_disab = 1'b1;

	  // if(ps32_2)     b_ksel=four;
	  // else if(ps16_2)b_ksel=two;
	  // else		 b_ksel=one;

	end
	BS2:	begin
	  if(!read_2)b_ns=BS5;
	  else b_ns=BS3;
	  if(dir[1] & !signx & !xeqz)
	    begin
	      b_set_multi = 1'b1;
	      if(frst_pass)b_op={pline,noop,amcn_d,dst_sav,wrhl};
	      else b_op={dst,noop,amcn_d,dst_sav,wrhl};
	    end
	  else if (dir[1])
	    begin
	      b_set_last_pass = 1'b1;
	      if(frst_pass) b_op={pline,size,sub_d,dst_sav,wrhl};
	      else b_op={dst,size,sub_d,dst_sav,wrhl};
	    end
	  else b_op={pline,noop,amcn_d,dst_sav,wrhl};

	  if     (dir[1] & frst_pass & ps32_2)b_ksel=D94;
	  else if(dir[1] & frst_pass & ps16_2)b_ksel=D95;
	  // if     (dir[1] & frst_pass & ps32_2)b_ksel=D95;
	  // else if(dir[1] & frst_pass & ps16_2)b_ksel=D96;
	  else if(dir[1])		      b_ksel=D96;
	  else 				      b_ksel=one;
	end
	/* add org low nibble to source point */
	/* save the original source X, to use on the next scan line. */
	BS3:	begin
	  if(frst_pass)
	    begin
	      b_op={sorgl,src,add,src_sav,wrhi};
	      b_cin = 1'b1;
	      // b_op={src,noop,apcn_d,dst_sav,wrhl};
	    end
	  // if(ps32_2)     b_ksel=four;
	  // else if(ps16_2)b_ksel=two;
	  // else		 b_ksel=one;
	  b_ns=BS4;
	end
	BS4:	begin
	  b_ns=BS5;

	  if	 (multi &  frst_pass & !last_pass) b_op={pline,noop,amcn,src_sav,wrhi};
	  else if(multi & !frst_pass & !last_pass) b_op={src,noop,amcn,src_sav,wrhi};
	  else if(multi &  frst_pass &  last_pass) b_op={pline,size,sub,src_sav,wrhi};
	  else if(multi & !frst_pass &  last_pass) b_op={src,size,sub,src_sav,wrhi};
	  else if(dir[1]) 			   b_op={pline,size,sub,src_sav,wrhi};
	  else 					   b_op={pline,noop,amcn,src_sav,wrhi};

	  if     (dir[1] & frst_pass & ps32_2)b_ksel=D94;
	  else if(dir[1] & frst_pass & ps16_2)b_ksel=D95;
	  // if     (dir[1] & frst_pass & ps32_2)b_ksel=D95;
	  // else if(dir[1] & frst_pass & ps16_2)b_ksel=D96;
	  else if(dir[1])		      b_ksel=D96;
	  else  			      b_ksel=one;
	end
	/* calculate the read words per line adjusted X size. */
	BS5:	begin	
	  if(apat32_2 | apat8_2 | (multi & ~last_pass))b_ns=BS6;
	  else b_ns=BS8;

	  if(apat32_2 | apat8_2)b_op={noop,noop,mov_k,rd_wrds_sav,wrhi};
	  else if(multi & ~last_pass)b_op={size,noop,amcn,size,wrhi};
	  else b_op={pline,size,div16,rd_wrds_sav,wrhi};

	  if(multi)b_ksel=D96;
	  if(ps32_2 & apat32_2 & ~multi)b_ksel=eight;
	  if(ps16_2 & apat32_2 & ~multi)b_ksel=four;
	  if(ps8_2 & apat32_2 & ~multi) b_ksel=two;
	  if(ps32_2 & apat8_2 & ~multi)b_ksel=two;
	  if((ps16_2 | ps8_2) & apat8_2 & ~multi)b_ksel=one;
	end
	/* Calculate the offset between the source and destination. */
	/* this code is exicuted for area patterns only.*/
	BS6:	begin	
	  b_ns=BS7;
	  if(apat32_2)b_mod32 = 1'b1;
	  if(apat8_2)b_mod8 = 1'b1;
	  if(multi)b_op={noop,noop,mov_k,noop,wrno};
	  else b_op={noop,src,movmod,adr_ofs,wrlo};
	  b_ksel=D96;
	end
	/* this code is exicuted for area patterns only.*/
	/* clear the lower 3 or 5 bits of the Y source.*/
	BS7:	begin	
	  b_ns=BS8;
	  if(multi)b_op={src,pline,div16,rd_wrds_sav,wrhi};
	  else b_op={src,src,sub,mod_src,wrno};
	  if(apat32_2)b_mod32 = 1'b1;
	  if(apat8_2)b_mod8 = 1'b1;
	end
	/* this code is exicuted for area patterns only.*/
	/* add the source offset to the source. */
	BS8:	begin	
	  b_ns=BS9;
	  if(multi & ~last_pass)b_op={noop,noop,mov_k,noop,wrno};
	  else b_op={pline,dst,add,mod_src,wrlo};
	  if(apat32_2)b_mod32 = 1'b1;
	  if(apat8_2)b_mod8 = 1'b1;
	  b_ksel=D96;
	end
	/* calculate the write words per line adjusted X size. */
	BS9:	begin	
	  b_ns=BS10;
	  if(multi & ~last_pass)b_op={dst,pline,div16,wr_wrds_sav,wrhi};
	  else b_op={dst,size,div16,wr_wrds_sav,wrhi};
	end
	/* generate the start and end mask to be loaded in BS10.                 */
	BS10:	begin
	  b_ns=BS11;
	  if(!dir[1] | last_pass)b_op={dst,size,add,noop,wrno};
	  else b_op={dst,size,apcn,noop,wrno};
	  b_rstn_wad = 1'b1;
	  b_ksel=D96;
	end
	BS11: begin
	  b_ld_msk=1'b1;	/* load the mask. */
	  b_ns=BS12;
	  if(multi)b_op={noop,src,mov,zoom,wrlo};
	end
	/* source minus destination nibble mode. for FIFO ADDRESS read = write, read = write-1.	*/
	/* this will set the first read 8 flag if source nibble is less than destination nibble.*/
	BS12:	begin	
	  if(mcrdy) begin
	    b_ns=BS13;
	    b_ld_rad = 1'b1;
	    if(apat32_2 || apat8_2)b_op={mod_src,adr_ofs,add,src,wrlo};
	    else b_op={src,dst,nib,noop,wrno};
	  end
	  else b_ns=BS12;
	end
	BS13: begin
	  b_ns=BR1;
	  if(multi && soc)b_op={noop,dst,mov,sav_yzoom,wrlo};
	  b_clr_soc  = 1'b1;
	  
	end
	/* write words minus max page count of eight for no reads. */
	/* or seven for commands with reads.                       */
	BR1: 	begin
	  if(!read_2)
	    begin
	      b_ns=BW3;
	      b_op={wr_wrds,noop,amcn,noop,wrno};
	      if(!rmw)b_ksel=eight;
	      else b_ksel=four;
	    end
	  else if(eor && (apat32_2 || apat8_2))
	    begin
	      b_ns=BW3;
	      b_op={wr_wrds,noop,amcn,noop,wrno};
	      if(!rmw)b_ksel=eight;
	      else b_ksel=four;
	    end
	  else if(eor)
	    begin
	      b_ns=BW3;
	      b_ksel=seven;
	      b_op={wr_wrds,noop,amcn,noop,wrno};
	    end
	  else if(frst_pass)
	    begin
	      b_ns=BR2;
	      b_op={noop,size,movx,wr_seg,wrhi};
	    end
	  else b_ns=BR2;
	  b_clr_frst_pass = 1'b1;
	end
	/* read words minus max page count of eight reads. */
	BR2:	begin
	  b_op={rd_wrds,noop,amcn,noop,wrno};
	  b_ns=BR3;
	  if((local_sol & !frst8_1) | apat32_2 | apat8_2)b_ksel=eight;
	  else b_ksel=seven;
	end

	/* wait for the pipeline.	*/
	/* subtract 7 or 8 from the read words.	*/
	BR3:	begin
	  b_ns=BR4;
	  b_op={rd_wrds,noop,amcn,rd_wrds,wrhi};
	  if((local_sol & !frst8_1) | apat32_2 | apat8_2)b_ksel=eight;
	  else b_ksel=seven;
	end
	BR4:	begin
	  b_ld_wcnt=1'b1; /* this signal is externally delayed one clock. */
	  if(signx || xeqz) b_op={noop,rd_wrds,mov,noop,wrno};
	  if(!signx && !xeqz)b_op={noop,noop,mov_k,noop,wrno};
	  if(local_sol & !frst8_1)b_ksel=eight;
	  else b_ksel=seven;
	  b_ns=BR5;
	  
	end

	BR5:	begin
	  if(signx | xeqz) b_set_eor=1'b1;
	  b_ns=BW1;
	end
	/* Begin the write portion of the bit blt state machine. */
	/* read words minus max page count of eight reads. */
	BW1:	if(mcrdy && !mw_fip)
	  begin
	    b_op={wr_wrds,noop,amcn,noop,wrno};
	    if(read_2 && apat32_2 && (ps8_2 || ps16_2))b_ns=BW2;
	    else if(read_2 && apat8_2)b_ns=BW2;
	    else b_ns=BW3;
	    if(read_2)begin
	      b_mem_req=1'b1;
	      b_mem_rd=1'b1;
	    end
	    if(read_2 && !(apat32_2 || apat8_2)) b_ksel=seven;
	    else if(!rmw)b_ksel=eight;
	    else b_ksel=four;
	  end
	else b_ns=BW1;

	BW2:	if(mcrdy && !mw_fip)
	  begin
	    b_op={wr_wrds,noop,amcn,noop,wrno};
	    b_ns=BW3;
	    b_mem_req=1'b1;
	    b_mem_rd=1'b1;
	    if(read_2 && !(apat32_2 || apat8_2)) b_ksel=seven;
	    else if(!rmw)b_ksel=eight;
	    else b_ksel=four;
	  end
	else b_ns=BW2;


	/* add 128 or 112 to the source x pointer.	*/
	BW3:	begin
	  b_ns=BW4; 
	  if(local_sol & !frst8_1)b_ksel=D128;
	  else b_ksel=D112;
	  if(!apat32_2)b_op={src,noop,apcn,src,wrhi};
	end

	/* test to see which is less and use that one. */
	/* and wait if memory controller is busy.      */
	BW4:	begin
	  b_ns=BW5;
	  if(read_2 && !(apat32_2 || apat8_2))b_ksel=seven;
	  else if(rmw)b_ksel=four;
	  else b_ksel=eight;
	  b_ld_wcnt=1'b1;
	  if(signx | xeqz)
	    begin 
	      b_op={noop,wr_wrds,mov,noop,wrno};
	      b_set_eol=1'b1;
	    end
	  else begin
	    b_op={noop,noop,mov_k,noop,wrno};
	  end
	end
	/* subtract 7 from the write words.	*/
	BW5:	begin
	  b_ns=BW6;
	  b_op={wr_wrds,noop,amcn,wr_wrds,wrhi};
	  if(read_2 && !(apat32_2 || apat8_2))b_ksel=seven;
	  else if(rmw)b_ksel=four;
	  else b_ksel=eight;
	end
	/* add 128 to the destination x pointer.	*/
	BW6:	begin
	  if(mcrdy && !eol_2 && cache_rdy)
	    begin
	      b_mem_req=1'b1;
	      b_ns=BR1;
	      b_op={dst,noop,apcn,dst,wrhi};
	      if(read_2 && !(apat32_2 || apat8_2))b_ksel=D112;
	      else if(rmw)b_ksel=D64;
	      else b_ksel=D128;
	    end
	  else if(mcrdy && eol_2 && cache_rdy) /* decrement the Y size register.	*/
	    begin
	      b_mem_req=1'b1;
	      b_ns=BNL1;
	      b_op={size,noop,amcn,size,wrlo};
	    end
	  else b_ns=BW6;
	end
	/* restore the write words per line.		*/
	BNL1:	begin
	  b_dchgy = 1'b1;
	  b_op={noop,sav_wr_wrds,mov,wr_wrds,wrhi};
	  b_ns=BNL2;
	end
	/* If Y size register goes to zero the bit blt is all done.	*/
	/* else go back and read more data.				*/
	/* Restore the original X destination registers.  */
	BNL2:	begin
	  if(yeqz & multi & ~last_pass)
	    begin
	      b_rst_cr = 1'b1;
	      b_ns=BNL4;
	      b_op={noop,sav_yzoom,mov,dst,wrlo}; // restore dst Y
	      b_set_end = 1'b1;
	    end
	  else if(yeqz)
	    begin
	      b_clr_last_pass = 1'b1;
	      b_clr_multi = 1'b1;
	      b_rst_cr = 1'b1;
	      b_clr_busy = 1'b1;
	      b_ns=B_WAIT;
	    end
	  else begin
	    if(read_2 && (apat32_2 || apat8_2))b_ns=BNL4; 
	    else if(read_2)b_ns=BNL3;
	    else b_ns=BS13; 
	    b_set_sol=1'b1;
	    b_op={noop,sav_src_dst,movx,dst,wrhi}; // restore dst Y
	  end
	end
	/* Increment or decrement the source Y registers.  */
	BNL3:	begin
	  b_ns=BNL6;
	  if(dir[0])b_op={src,noop,amcn,src,wrlo};
	  else b_op={src,noop,apcn,src,wrlo};
	end
	/* increment the modulo source Y counter. */
	BNL4:	begin
	  b_ns=BNL5;
	  b_ksel=one;
	  // b_rstn_wad=1'b1;
	  if(apat32_2)b_mod32 = 1'b1;
	  if(apat8_2)b_mod8 = 1'b1;
	  if(multi)b_op={noop,zoom,mov,src,wrlo};  // restore src Y
	  else b_op={mod_src,noop,apcn,mod_src,wrlo};
	end
	/* add the source Y offset to the source Y. */
	BNL5:	begin
	  if(multi)
	    begin
	      b_op={noop,sav_src_dst,movx,dst,wrhi}; // restore dstx
	      b_ns=BNL6;
	    end
	  else
	    begin
	      b_op={pline,adr_ofs,add,src,wrlo};
	      b_ns=BNL6;
	    end
	end
	/* Restore the original X source registers.  */
	BNL6:	begin
	  b_op={noop,sav_src_dst,mov,src,wrhi};
	  b_ns=BNL7;
	end
	/* restore the read words per line.		*/
	BNL7:	begin
	  if(multi & end_pass)
	    begin
	      b_op={size,noop,amcn,noop,wrno};
	      b_ns=BS1;
	      b_clr_end = 1'b1;
	    end
	  else begin
	    b_op={noop,sav_rd_wrds,mov,rd_wrds,wrhi};
	    b_ns=BS13;
	  end
	  b_ksel=D96;
	end
      endcase

    end


endmodule
