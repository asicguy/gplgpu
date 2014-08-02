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
//  Title       :  Drawing Engine Funnel Shifter and Color Selector
//  File        :  ded_funcol.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module instantiates the funnel shifter and color selector
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
module ded_funcol
  #(parameter BYTES = 4)
  (
   input          mclock,       // Clock for delaying RAD
   input [1:0]    stpl_4,       // stipple mode bit 01 = planar, 10 = packed
   input [1:0]    apat_4,       // should be moved to here from ded_top_misc
   input          ps8_4,
                  ps16_4,
                  ps32_4,
   input          lt_actv_4,
   input [31:0]   fore_4,       // foreground register output
   input [31:0]   back_4,       // foreground register output
   input          solid_4,
   input [(BYTES<<3)-1:0]  pc_col,       // color select from pix cache
  `ifdef BYTE16 input [6:0]       rad,
  `elsif BYTE8  input [5:0]       rad,
  `else         input [4:0]       rad, `endif
   input [(BYTES<<3)-1:0]  bsd0,bsd1,   // cache data output
   
   output [(BYTES<<3)-1:0] col_dat,     // frame buffer data output
   output [BYTES-1:0]  trns_msk,     // transparentcy mask
   output [BYTES-1:0]  cx_sel   // color expand selector (for test)
   
   );
  
  wire [(BYTES<<3)-1:0]  fs_dat;        // funnel shift data to color selector

  /****************************************************************/
  /*            DATAPATH FUNNEL SHIFTER                         */
  /****************************************************************/
  ded_funshf #
    (
     .BYTES       (BYTES)
     )
  U_FUNSHF
    (
     .mclock      (mclock),
     .rad         (rad),
     .bsd0        (bsd0),
     .bsd1        (bsd1),
     .apat8_4     (apat_4[0]),
     .apat32_4    (apat_4[1]),
     .bsout       (fs_dat),
     .cx_sel      (cx_sel)
     );

  /****************************************************************/
  /*            DATAPATH COLOR SELECTOR                         */
  /****************************************************************/
  ded_colsel #
    (
     .BYTES       (BYTES)
     )
  U_COLSEL
    (
     .mclock      (mclock),
     .ps8_4       (ps8_4),
     .ps16_4      (ps16_4),
     .ps32_4      (ps32_4),
     .stpl_4      (stpl_4),
     .lt_actv_4   (lt_actv_4),
     .fore_4      (fore_4),
     .back_4      (back_4),
     .fs_dat      (fs_dat),
     .cx_sel      (cx_sel),
     .pc_col      (pc_col),
     .solid_4     (solid_4), 
     .col_dat     (col_dat),
     .trns_msk    (trns_msk));


endmodule // DED_FUNCOL

