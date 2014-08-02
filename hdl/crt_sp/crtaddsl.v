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
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module is extracted from the original CRTTIMER.
//  It consist of adders and substractors common to VRAM and DRAM
//  controllers. Speed of everything in this module is really don't care. 
//  The original CRTTIMER will remain intact if proper port connections are 
//  made with this module.
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
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

module crtaddsl 
  (
   hactive_regist, 
   hblank_regist, 
   hfporch_regist, 
   hswidth_regist,
   vactive_regist, 
   vblank_regist, 
   vfporch_regist, 
   vswidth_regist,
   
   htotal_add, 
   hendsync_add, 
   endequal_add, 
   halfline_add,
   endequalsec_add,
   serrlongfp_substr, 
   serr_substr, 
   serrsec_substr,
   vendsync_add,
   vendequal_add,
   vtotal_add,
   hfpbhs 
   );  

  /* vertical parameters max FFF, horizontal parameters max 3FFF */    

  input [13:0]  hactive_regist, 
		hblank_regist,
		hfporch_regist,
		hswidth_regist;
  input [11:0] 	vactive_regist,
		vblank_regist,
		vfporch_regist,
		vswidth_regist;
             
  output [13:0] htotal_add,
		hendsync_add,
		endequal_add,
		halfline_add,
		endequalsec_add,
		serrlongfp_substr, 
		serr_substr,
		serrsec_substr;
  output [11:0] vendsync_add,
		vendequal_add,
		vtotal_add;
  output        hfpbhs;

  wire [13:0] 	serrshortfp_substr;

  /*****
   establish horizontal sync end position , equalizing impulse end , half line
   and second equalizing end, and htotal.
   *****/

  assign 	htotal_add[13:0] = hblank_regist[13:0] + hactive_regist[13:0];
  assign 	hendsync_add[13:0] = hfporch_regist[13:0] + 
		hswidth_regist[13:0];
  assign 	endequal_add[13:0] = hfporch_regist[13:0] + 
		hswidth_regist[13:1];
  //half sync
  assign 	halfline_add[13:0] = hfporch_regist[13:0] + htotal_add[13:1];
  assign 	endequalsec_add[13:0] = halfline_add[13:0] + 
		hswidth_regist[13:1];
  //half sync
  assign 	serrlongfp_substr[13:0] = hfporch_regist[13:0] - 
		hswidth_regist[13:0]; 
  assign 	serrshortfp_substr[13:0] = hswidth_regist[13:0] - 
		hfporch_regist[13:0];
  assign 	serr_substr[13:0] = halfline_add[13:0] - hswidth_regist[13:0];
  assign 	serrsec_substr[13:0] = htotal_add[13:0] - 
		serrshortfp_substr[13:0];

  /** set points for the vertical-end-sync position and the end of vertical
   equalization region */
                                                            
  assign 	vtotal_add[11:0] = vblank_regist[11:0] + vactive_regist[11:0];
  assign 	vendsync_add[11:0] = vfporch_regist[11:0] + 
		vswidth_regist[11:0];
  assign 	vendequal_add[11:0] = vfporch_regist[11:0] + 
		{vswidth_regist[10:0],1'b0};

  /*** compare hfporch and width of hsync ***/
  assign 	hfpbhs = (hfporch_regist[13:0] > hswidth_regist[13:0]);

endmodule
