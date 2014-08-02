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
//  Title       :  Drawing Engine ALU
//  File        :  dex_alu.v
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

module dex_alu
	(
	input		de_clk,		/* clock input		*/
	input		rstn,		/* reset input		*/
	input [4:0] 	aluop,		/* alu operation select */
	input [15:0] 	ax,		/* alu ax input		*/
	input [15:0] 	bx,		/* alu bx input		*/
	input [15:0] 	ay,		/* alu ay input		*/
	input [15:0] 	by,		/* alu by input		*/
	input [4:0] 	ksel,		/* alu constant select	*/
	input		load_actvn,	/* load active command.	*/
	input		ps32_2,		/* pixel size 32.      	*/
	input		ps16_2,		/* pixel size 16.      	*/
	input		local_sol,	/* Local start of line.	*/
	input		mod8,		/* Modulo 8 operation. 	*/
	input		mod32,		/* Modulo 32 operation.	*/
	input		pad8_2,		/* 8 bit padding.      	*/
	input		read_2,		/* reads are enabled.  	*/
	input		b_cin,
  
	output [15:0] 	fx,		/* alu fx output	*/
	output [15:0] 	fy,		/* alu fy output	*/
	output 		xeqz,		/* alu fx equals zero	*/
	output 		yeqz,		/* alu fy equals zero   */
	output [1:0] 	frst8,		/* first 8 flag output. */
	output [3:0] 	fx_1,		/* prepipe line fx output for the word count register. */
	output 		signx,		/* alu fx sign bit	*/
	output 		signy,		/* alu fy sign bit   */
	output reg		src_lte_dst	/* source pointer to the left of dstination pointer. */
	);

  
  reg [15:0] 	ik_r;
  wire [15:0] 	k_r;
  reg [15:0] 	new_fx,
		new_fy,
		new_ax,
		new_bx,
		new_ay,
		new_by;
  reg 		cinx, n_cinx;	
  reg 		ciny, n_ciny;	
  
  reg [15:0] 	n_new_ax, n_new_ay, n_new_bx, n_new_by;
  reg 		n_ldfrst8, n_ldfrst8_s, n_ldsngl;
  
  reg		ld_frst8;	/* load first 8 register.	*/
  reg		ld_frst8_s;	/* load first 8 register.	*/
  reg		ld_sngl;	/* load single bit.		*/
  reg	      	frst81;		/* first 8 register.		*/
  reg	      	frst80;		/* first 8 register.		*/
  reg 	  	mod32_sel;	/* modulo 32 select delayed.	*/
  reg 	  	mod8_sel;	/* modulo 8  select delayed.	*/
  wire [1:0] 	wadj;		/* word adjustment.		*/
  wire [1:0] 	wadj1;		/* word adjustment.		*/
  wire [1:0] 	wadj2;		/* word adjustment.		*/
  wire [2:0] 	sum4m;
  wire [3:0] 	sum8m;
  wire [4:0] 	sum16m;
  reg [2:0] 	badj;
  reg 		cin_i;
  wire 		cin_d;
  
  assign 	frst8 = {frst81,frst80};

  /* include the global parameters */
  //`include        "de_param.h"
  parameter 	zero 	        = 5'h0,
		one 	        = 5'h1,
		two 	        = 5'h2,
		three 	        = 5'h3,
		four 	        = 5'h4,
		five 	        = 5'hc,
		seven 	        = 5'h5,
		eight 	        = 5'h6,
		D256 	        = 5'h7,
		D16 	        = 5'h8,
		Hfff0 	        = 5'hb,
		D24 	        = 5'hd,         // not used
		D48 	        = 5'he,         // not used
		// D49 	        = 5'hf,         // not used
		D95 	        = 5'h10,
		D64  	        = 5'h11,
		D94 	        = 5'h12,
		D96 	        = 5'h13,
		D112 	        = 5'h14,
		D128 	        = 5'h15,
		D896 	        = 5'h16,
		D512 	        = 5'h17,
		D1024 	        = 5'h9,
		D2048 	        = 5'ha,
		abs 		= 5'h0,		// |bx|, |by|     
		add 		= 5'h1,		// ax + bx, ay + by
		addnib  	= 5'h2,		// ax + bx(nibble)
		addx  		= 5'h3,		// ay + bx, ax + by
		amcn 		= 5'h4,		// ax-k, ay-k	
		movmod 		= 5'h5,		// ay + by mod 8 or 32.
		apcn 		= 5'h6,		// ax+k, ay+k    
		cmp_add 	= 5'h7,		// -bx + ax, -by + ay
		apcn_d 		= 5'h8,		// {ax + const, ax + const}
		pad_x 		= 5'h9,		// pad to 32 or 8 bits.
		div16 		= 5'ha,		// bx/16 + wadj.  
		// div8 	= 5'hb,		// bx/32 + wadj.  
		err_inc  	= 5'hc,		// ax<<1, ay <<1 - by
		mov 		= 5'hd,		// bx--> fx, by--> fy
		mov_k 		= 5'he,		// move constant.
		movx 		= 5'hf,		// bx--> fy, by--> fx
		c_m_bnib	= 5'h10,	// K - b nibble. 
		nib 		= 5'h11,	// nibble.    	 
		sub  		= 5'h12,	// ax - bx, ay - by
		subx  		= 5'h13,	// ay - bx, ax - by
		amcn_d		= 5'h14,	// {ax - const,ax - const}
		X4		= 5'h15,	// X * 4 (ax<<2)
		div128 		= 5'h16,	// bx/128 + wadj128.
		sub_d		= 5'h17,	// {ax - bx,ax - bx}
		X8		= 5'h18,	// X * 8 (ax<<3)
		X16		= 5'h19,	// X * 16 (ax<<3)
		// zm_ofs	= 5'h1a,	// spare 		
		addlin		= 5'h1b,	//                     
		sublin		= 5'h1c,	//                     
		div4l 		= 5'h1d,	// bx/4 + linear wadj. 
		div8l 		= 5'h1e,	// bx/8 + linear wadj. 
		div16l 		= 5'h1f;	// bx/16 + linear wadj.

	   
  /* memory word count */
  assign 	fx_1 = (aluop==mov) ? bx[3:0] : 
		(aluop==movx) ? by[3:0] : 
		(aluop==mov_k) ? k_r[3:0] : fx[3:0];  // new_fx[3:0];

  always @(posedge de_clk)mod32_sel <= mod32;
  always @(posedge de_clk)mod8_sel <= mod8;
  always @(posedge de_clk)cin_i <= b_cin;
  assign 	cin_d = cin_i;

  /************************************************************************/
  /*			constant generator 				*/
  /************************************************************************/
  always @(posedge de_clk)	/* constant to be defined later */
  begin
    case(ksel)	// synopsys parallel_case
      zero:	ik_r   	<= 16'h0;
      one:	ik_r   	<= 16'h1;
      two:	ik_r   	<= 16'h2;
      three: 	ik_r 	<= 16'h3;
      four: 	ik_r  	<= 16'h4;
      five: 	ik_r   	<= 16'h5;
      seven: 	ik_r 	<= 16'h7;
      eight: 	ik_r 	<= 16'h8;
      D256:	ik_r  	<= 16'h100;
      D16:	ik_r  	<= 16'h10;
      Hfff0: 	ik_r   	<= 16'hfff0;
      D24: 	ik_r  	<= 16'h18;
      D48: 	ik_r  	<= 16'h30;
      // D49: 	ik_r  	<= 16'h30;
      D95: 	ik_r   	<= 16'h5F;
      D64: 	ik_r   	<= 16'h40;
      D94: 	ik_r   	<= 16'h5E;
      D96: 	ik_r   	<= 16'h60;
      D112: 	ik_r  	<= 16'h70;
      D128: 	ik_r	<= 16'h80;
      D896: 	ik_r	<= 16'h380;
      D512: 	ik_r	<= 16'h200;
      D1024: 	ik_r   	<= 16'h400;
      D2048: 	ik_r   	<= 16'h800;
    endcase
  end
  assign k_r = ik_r;

  /************************************************************************/
  /*			ALU BLOCK          				*/
  /************************************************************************/
  
  always @(posedge de_clk) begin
    ld_frst8   <= n_ldfrst8;
    ld_frst8_s <= n_ldfrst8_s;
    ld_sngl    <= n_ldsngl;
    new_ax     <= n_new_ax;
    new_ay     <= n_new_ay;
    new_bx     <= n_new_bx;
    new_by     <= n_new_by;
    cinx       <= n_cinx;
    ciny       <= n_ciny;
  end
  
  always @* begin
    n_ldfrst8    = 1'b0;
    n_ldfrst8_s  = 1'b0;
    n_ldsngl     = 1'b0;
    n_new_ax     = 16'b0;
    n_new_ay     = 16'b0;
    n_new_bx     = 16'b0;
    n_new_by     = 16'b0;
    n_cinx       = 1'b0;
    n_ciny       = 1'b0;
    case(aluop)	// synopsys parallel_case
      abs: begin
        if(bx[15]) begin
	  n_new_bx = ~bx;
	  n_cinx = 1'b1;
	end else n_new_bx = bx;
        if(by[15]) begin
	  n_new_by = ~by;
	  n_ciny = 1'b1;
	end else n_new_by = by;
      end

      add: begin
        n_new_ax = ax;
        n_new_bx = bx;
        n_new_ay = ay;
        n_new_by = by;
	n_cinx=cin_d;
	n_ciny=cin_d;
      end
      
      addlin: begin
        n_new_ax = ax[9:0];
        n_new_bx = {by[12:3],3'b000};
      end

      sublin: begin
        if(read_2)n_new_ax[6:0] = ax[6:0];
        else n_new_ax[9:0] = ax[9:0];
	begin
          if(ps32_2)n_new_bx = {14'h3fff,~bx[3:2]};
          else if(ps16_2)n_new_bx = {13'h1fff,~bx[3:1]};
          else n_new_bx = {12'hfff,~bx[3:0]};
	end
	n_cinx=1'b1;
	n_ldfrst8_s=1'b1;
      end

      addnib: begin
        n_new_bx = bx;
        n_new_ax = ax;
        n_new_by = bx;
        n_new_ay = ax;
	n_cinx=cin_d;
	n_ciny=cin_d;
      end

      addx: begin
        n_new_ax = ax;
        n_new_bx = by;
        n_new_ay = ay;
        n_new_by = bx;
      end

      amcn: begin /* a port minus constant */
        n_new_ax = ax;
        n_new_bx = ~k_r;
        n_new_ay = ay;
        n_new_by = ~k_r;
	n_cinx=1'b1;
	n_ciny=1'b1;
      end

      movmod: begin /* constant minus a port */
        if(mod8)n_new_ay = ay[2:0];
        if(mod32)n_new_ay = ay[4:0];
      end
      
      apcn: begin
        n_new_ax = ax;
        n_new_bx = k_r;
        n_new_ay = ay;
        n_new_by = k_r;
      end

      cmp_add: begin
	n_new_bx = ~bx;
	n_new_ax = ay;
	n_cinx=1;
      end

      apcn_d: begin // a plus constant double
        n_new_ax = ax;
        n_new_bx = k_r;
        n_new_ay = ax;
        n_new_by = k_r;
      end
      
      pad_x: begin  
        if(pad8_2)n_new_ay = {ax[15:3],3'h0};
        else n_new_ay = {ax[15:5],5'h0};
        if(pad8_2)n_new_by = {12'h0,|ax[2:0],3'h0};
        else n_new_by = {10'h0,|ax[4:0],5'h0};
      end

      div16: begin	
	n_new_bx = (bx>>4);
	n_new_ax = {14'h0,wadj};
	n_ldsngl=1'b1;
      end

      div128: begin	
	n_new_bx = (bx>>7);
	n_new_ax = {14'h0,wadj1};
	n_ldsngl=1'b1;
      end

/*
      div8: begin	
	n_new_bx = (bx>>3);
	n_new_ax = {13'h0,badj};
      end
*/

      div4l: begin	
	n_new_bx = (bx>>2'd2);
	n_new_ax = {15'h0,sum4m[2]};
      end

      div8l: begin	
	n_new_bx = (bx>>2'd3);
	n_new_ax = {15'h0,sum8m[3]};
      end

      div16l: begin	
	n_new_bx = (bx>>3'd4);
	n_new_ax = {15'h0,sum16m[4]};
      end

      err_inc: begin
       	n_new_ax = (ax << 1'b1);
       	n_new_bx = ~(ay << 1'b1);
        n_new_ay = ay << 1'b1; 
	n_cinx=1;
      end

      default: begin
      // mov: begin
        n_new_bx = bx;
        n_new_by = by;
      end

      mov_k: begin
        n_new_bx = k_r;
        n_new_by = k_r;
      end

      movx: begin
        n_new_bx = by;
        n_new_ay = ax;
      end

      c_m_bnib: begin
        n_new_bx = ~bx[3:0];
        n_new_ax = k_r;
	n_cinx=1;
      end

      nib: begin
        n_new_ax = {12'b0,ax[3:0]};
        n_new_bx = ~{12'b0,bx[3:0]};
	n_cinx=1'b1;
	n_ldfrst8=1'b1;
      end

      sub: begin
        n_new_ax = ax;
        n_new_bx = ~bx;
        n_new_ay = ay;
        n_new_by = ~by;
	n_cinx=1'b1;
	n_ciny=1'b1;
      end

      subx: begin
	n_new_ax = ax;
	n_new_bx = ~by;
	n_cinx=1'b1;
      end

      amcn_d: begin /* a port minus constant */
        n_new_ax = ax;
        n_new_bx = ~k_r;
        n_new_ay = ax;
        n_new_by = ~k_r;
	n_cinx=1'b1;
	n_ciny=1'b1;
      end

      sub_d: begin
        n_new_ax = ax;
        n_new_bx = ~bx;
        n_new_ay = ax;
        n_new_by = ~bx;
	n_cinx=1'b1;
	n_ciny=1'b1;
      end

      X4: n_new_ax = (ax << 2);
      X8: n_new_ax = (ax << 3);
      X16: begin
	n_new_ax = (ax << 4);
	if(local_sol) begin
	  n_new_bx = ~({12'h0,bx[3:0]});
	  n_cinx=1'b1;
	end
      end
    endcase
  end

/************************************************************************/
/* This is the DUAL 16 bit adder.					*/
always @*
        begin
                new_fx=new_ax + new_bx + cinx;
                new_fy=new_ay + new_by + ciny;
        end

assign fx = new_fx;
assign fy = (mod32_sel) ? {new_ay[15:5],new_fy[4:0]} : 
 	    (mod8_sel) ?  {new_ay[15:3],new_fy[2:0]} : new_fy;

wire	new_ld_frst8;
wire	new_ld_frst8_s;
wire	new_ld_sngl;
assign new_ld_frst8 =ld_frst8;
assign new_ld_frst8_s =ld_frst8_s;
assign new_ld_sngl =ld_sngl;

  always @(posedge de_clk or negedge rstn) begin
    if (!rstn)             src_lte_dst <= 1'b0;
    else if (new_ld_frst8) src_lte_dst <= (new_fx[4] | (~|new_fx[3:0]));
    else if (!load_actvn)  src_lte_dst <= 1'b0;
  end
  
  always @(posedge de_clk or negedge rstn) begin
    if (!rstn)               frst81 <= 1'b0;
    else if (new_ld_frst8)   frst81 <= new_fx[4];
    else if (new_ld_frst8_s) frst81 <= new_fx[5];
    else if (!load_actvn)    frst81 <= 1'b0;
  end

  always @(posedge de_clk or negedge rstn) begin
    if (!rstn)            frst80 <= 1'b0;
    else if (new_ld_sngl) frst80 <= ~|new_fx[11:1];
    else if (!load_actvn) frst80 <= 1'b0;
  end

  assign xeqz = (new_fx == 16'h0);
  assign yeqz = (new_fy == 16'h0);
  assign signx = new_fx[15];
  assign signy = new_fy[15];
  
/****************************************************************/
/*                              WADJ                            */
wire    [4:0]   sum;
wire    [3:0]   ain;
wire            sum_or;

assign ain =  ax[3:0];
assign sum = ain[3:0] + bx[3:0];
assign sum_or = | sum[3:0];
assign wadj[1] = (sum[4] && sum_or);
assign wadj[0] = (sum[4] ^ sum_or);
/****************************************************************/
/*                              WADJ128                         */
wire    [7:0]   sum1;
wire    [6:0]   ain1;
wire            sum_or1;

assign ain1 = ax[6:0];
assign sum1 = ain1[6:0] + bx[6:0];
assign sum_or1 = | sum1[6:0];
assign wadj1[1] = (sum1[7] && sum_or1);
assign wadj1[0] = (sum1[7] ^ sum_or1);
/****************************************************************/
// div??m;

assign sum16m = ax[3:0] + bx[3:0];
assign sum8m = ax[2:0] + bx[2:0];
assign sum4m = ax[1:0] + bx[1:0];


/****************************************************************/
/*	BADJ
always @(ax or bx)
        begin
                case({ax[4:3],|ax[2:0],|bx[2:0]}) // synopsys full_case parallel_case
                        4'b0000:badj=3'h0;
                        4'b0001:badj=3'h1;
                        4'b0010:badj=3'h1;
                        4'b0011:badj=3'h2;
                        4'b0100:badj=3'h2;
                        4'b0101:badj=3'h3;
                        4'b0110:badj=3'h2;
                        4'b0111:badj=3'h3;
                        4'b1000:badj=3'h3;
                        4'b1001:badj=3'h4;
                        4'b1010:badj=3'h3;
                        4'b1011:badj=3'h4;
                        4'b1100:badj=3'h4;
                        4'b1101:badj=3'h5;
                        4'b1110:badj=3'h4;
                        4'b1111:badj=3'h5;
                endcase
        end
****************************************************************/
endmodule
