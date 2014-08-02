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
//  Title       :  Texture address comparison
//  File        :  de3d_tc_compare.v
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  TC compare compares the two incoming addresses with both the
//  level two associative cache, and the level 1 cache outputs
//  from the MUX's. This block will generate the opcodes used to load
//  the RAMS on a miss.
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


`timescale 1 ps / 1 ps

module de3d_tc_compare
	(
	input		de_clk,
	input		de_rstn,
	input		tc_ack,
	input	[17:0]	ur,			/* Texel addresses to be compared	*/
	input	[17:0]	ul,			/* Texel addresses to be compared	*/
	input	[17:0]	lr,			/* Texel addresses to be compared	*/
	input	[17:0]	ll,			/* Texel addresses to be compared	*/
						/* {u[8:0],v[8:0]}		  	*/
	input   [3:0]   mipmap_in,              /* incoming mipmap number         	*/
	input	[26:0]	ul_tag,			/* tag ul data			  	*/
	input	[26:0]	ll_tag,			/* tag ll data			  	*/
	input	[26:0]	ur_tag,			/* tag ur data			  	*/
	input	[26:0]	lr_tag,			/* tag lr data			  	*/
					/* {lru,val1,mm1,tag1,val0,mm0,tag0}	*/
	input		exception,		/* Exception code.			*/
	input   [2:0]   bpt,
	input           tc_exact,               /* when set, only validate UL tex */
	input           clip,

	output  [3:0]   tc_op,                  /* operation to perform           */
	output reg  [3:0]   set_sel,                /* Set to be updated           */
	output reg  [3:0]   set_read,               /* Set to read from.          */
	output  [7:0]   hit_bus
	);

reg     [7:0]   ur_comp, ul_comp,       /* formatted for comparison       */
                lr_comp, ll_comp;

wire 		lru_ul		= ul_tag[26];
wire 		valid1_ul	= ul_tag[25];
wire 	[3:0]	mm1_ul		= ul_tag[24:21];
wire 	[7:0]	cache1_ul 	= ul_tag[20:13];
wire 		valid0_ul	= ul_tag[12];
wire 	[3:0]	mm0_ul		= ul_tag[11:8];
wire 	[7:0]	cache0_ul 	= ul_tag[7:0];

wire 		lru_ll		= ll_tag[26];
wire 		valid1_ll	= ll_tag[25];
wire 	[3:0]	mm1_ll		= ll_tag[24:21];
wire 	[7:0]	cache1_ll 	= ll_tag[20:13];
wire 		valid0_ll	= ll_tag[12];
wire 	[3:0]	mm0_ll		= ll_tag[11:8];
wire 	[7:0]	cache0_ll 	= ll_tag[7:0];

wire 		lru_ur		= ur_tag[26];
wire 		valid1_ur	= ur_tag[25];
wire 	[3:0]	mm1_ur		= ur_tag[24:21];
wire 	[7:0]	cache1_ur 	= ur_tag[20:13];
wire 		valid0_ur	= ur_tag[12];
wire 	[3:0]	mm0_ur		= ur_tag[11:8];
wire 	[7:0]	cache0_ur 	= ur_tag[7:0];

wire 		lru_lr		= lr_tag[26];
wire 		valid1_lr	= lr_tag[25];
wire 	[3:0]	mm1_lr		= lr_tag[24:21];
wire 	[7:0]	cache1_lr 	= lr_tag[20:13];
wire 		valid0_lr	= lr_tag[12];
wire 	[3:0]	mm0_lr		= lr_tag[11:8];
wire 	[7:0]	cache0_lr 	= lr_tag[7:0];


wire 		tc_same;
wire		exact;
wire		ul0_hit, ul1_hit;
wire		ll0_hit, ll1_hit;
wire		ur0_hit, ur1_hit;
wire		lr0_hit, lr1_hit;

wire	[8:0]	ulx = ul[17:9];
wire	[8:0]	uly = ul[8:0];
wire	[8:0]	llx = ll[17:9];
wire	[8:0]	lly = ll[8:0];
wire	[8:0]	urx = ur[17:9];
wire	[8:0]	ury = ur[8:0];
wire	[8:0]	lrx = lr[17:9];
wire	[8:0]	lry = lr[8:0];

/* Determine read addresses */
always @*
	begin
  		case (bpt) /* synopsys parallel_case */
    		// 8 bpt
    		3:
			begin
      				ul_comp = {2'b0,uly[8:6],ulx[8:6]};
      				ur_comp = {2'b0,ury[8:6],urx[8:6]};
      				ll_comp = {2'b0,lly[8:6],llx[8:6]};
      				lr_comp = {2'b0,lry[8:6],lrx[8:6]};
    			end
    		// 32 bpt
    		5:
			begin
      				ul_comp = {uly[8:4],ulx[8:6]};
      				ur_comp = {ury[8:4],urx[8:6]};
      				ll_comp = {lly[8:4],llx[8:6]};
      				lr_comp = {lry[8:4],lrx[8:6]};
    			end
    		default:
			begin
      				ul_comp = {1'b0,uly[8:5],ulx[8:6]};
      				ur_comp = {1'b0,ury[8:5],urx[8:6]};
      				ll_comp = {1'b0,lly[8:5],llx[8:6]};
      				lr_comp = {1'b0,lry[8:5],lrx[8:6]};
    			end
  		endcase
	end

assign hit_bus = ({ul1_hit,ul0_hit,ll1_hit,ll0_hit,ur1_hit,ur0_hit,lr1_hit,lr0_hit} & {8{tc_ack}});
assign ul0_hit = (ul_comp == cache0_ul && mipmap_in == mm0_ul && valid0_ul); // UL set 0 compare.
assign ul1_hit = (ul_comp == cache1_ul && mipmap_in == mm1_ul && valid1_ul); // UL set 1 compare.
assign ll0_hit = (ll_comp == cache0_ll && mipmap_in == mm0_ll && valid0_ll); // LL set 0 compare.
assign ll1_hit = (ll_comp == cache1_ll && mipmap_in == mm1_ll && valid1_ll); // LL set 1 compare.
assign ur0_hit = (ur_comp == cache0_ur && mipmap_in == mm0_ur && valid0_ur); // UR set 0 compare.
assign ur1_hit = (ur_comp == cache1_ur && mipmap_in == mm1_ur && valid1_ur); // UR set 1 compare.
assign lr0_hit = (lr_comp == cache0_lr && mipmap_in == mm0_lr && valid0_lr); // LR set 0 compare.
assign lr1_hit = (lr_comp == cache1_lr && mipmap_in == mm1_lr && valid1_lr); // LR set 1 compare.
assign tc_same = (ul == ur) & (ll == lr) & (ul == lr);
assign exact = tc_exact || tc_same;

/* Determine opcode */

assign tc_op = (clip) ? 4'b0000 :
	       (exact &&  (ul1_hit | ul0_hit)) ? 4'b0000 :
	       (exact && !(ul1_hit | ul0_hit)) ? 4'b1000 : 
	       (exception && !(ul[0] ^ ll[0])) ? {~(ul1_hit | ul0_hit), 1'b0, 1'b0, 1'b0} :
	       (!exception && !(ul[0] ^ ll[0])) ? {~(ul1_hit | ul0_hit), 1'b0, ~(ur1_hit | ur0_hit), 1'b0} :
	       (exception) ? {~(ul1_hit | ul0_hit), ~(ll1_hit | ll0_hit), 1'b0, 1'b0} :
	     {~(ul1_hit | ul0_hit), ~(ll1_hit | ll0_hit), ~(ur1_hit | ur0_hit), ~(lr1_hit | lr0_hit)};


/* store the set select info.    */
/* this tells the tag module which set to update. */
always @(posedge de_clk or negedge de_rstn)
        begin
                if (!de_rstn) set_sel    <= 0;
                else if (tc_ack) set_sel    <= {(ul1_hit | ul0_hit | lru_ul),
						(ll1_hit | ll0_hit | lru_ll),
						(ur1_hit | ur0_hit | lru_ur),
						(lr1_hit | lr0_hit | lru_lr)};
        end

/* store the set read info.    */
always @(posedge de_clk or negedge de_rstn)
        begin
                if (!de_rstn) set_read    <= 0;
                else if (tc_ack && exception)set_read    <= {(ul1_hit | (~ul0_hit & lru_ul)),
						 	    (ll1_hit | (~ll0_hit & lru_ll)),
						 	    (ul1_hit | (~ul0_hit & lru_ul)),
						 	    (ll1_hit | (~ll0_hit & lru_ll))};
                else if (tc_ack && !exception)set_read    <= {(ul1_hit | (~ul0_hit & lru_ul)),
						 	    (ll1_hit | (~ll0_hit & lru_ll)),
						 	    (ur1_hit | (~ur0_hit & lru_ur)),
						 	    (lr1_hit | (~lr0_hit & lru_lr))};
        end

endmodule
