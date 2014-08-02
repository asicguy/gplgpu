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
//  Title       :  
//  File        :  
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
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
//
///////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
//    		TASK TO TEST YUV IMAGE (LILY) IN 444 MODE at 16 BBP(555)
/******************************************************************************/
task lily_16_444;

begin
 

 mov_dw (CONFIG_WR, 32'h10, 32'ha040_0008, 4'h0, 1); //assign 4M bytes for linear window 0.
 mov_dw (CONFIG_WR, 32'h14, 32'ha000_0008, 4'h0, 1); //assign 4M bytes for linear window 1.


 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0000_0214, 4'h0, 1); //diasble all decode except linear windows.

//****SET PACKING MODE FOR LINEAR 1 TO YUV_444 at 16BBP *****
 mov_dw (MEM_WR, rbase_w+MW1_CTRL,   32'h34b0_0040, 4'h0, 1);  // MW1_CTRL(16 PACKING 555 , 444)
 mov_dw (MEM_WR, rbase_w+MW1_AD,     32'ha000_0000, 4'h0, 1);  // MW1_AD
 mov_dw (MEM_WR, rbase_w+MW1_SZ,     32'h0000_000f, 4'h0, 1);  // MW1_SZ
 mov_dw (MEM_WR, rbase_w+MW1_PGE,    32'h0000_0000, 4'h0, 1);  // MW1_PGE
 mov_dw (MEM_WR, rbase_w+MW1_ORG,    32'h0000_0000, 4'h0, 1);  // MW1_ORG
 mov_dw (MEM_WR, rbase_w+MW1_WSRC,   32'hffff_ffff, 4'h0 ,1);  // MW1_WSRC
 mov_dw (MEM_WR, rbase_w+MW1_WKEY,   32'haaaa_5555, 4'h0, 1);  // MW1_KEY
 mov_dw (MEM_WR, rbase_w+MW1_KYDAT,  32'h0000_0005, 4'h0, 1);  // MW1_KYDAT
 mov_dw (MEM_WR, rbase_w+MW1_MASK,   32'hffff_ffff, 4'h0, 1);  // MW1_MASK

 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0003_0214, 4'h0, 1);  //Enabling Memory Window 0 & 1 decode 


 //INCLUDE LILY 444 SOURCE FILE
 `include "/home/homer/rev2/blackbird/naser_run/hb_test_suite/IMAGES/YUV/YUV_444_16/lily444.h"

 //flush the cache, then wait for the host cache to empty its contets to memory(cache is not busy)
mov_dw (MEM_WR, rbase_w+8'h54, 32'h0, 4'hf, 1); //write to the flush register
wait_win0_not_busy;
wait_win1_not_busy;
 
 save_bitmap_2 (32'h0, 32'h14c, 32'hdd, "junk", 32'h0500, 16) ;
 

  end
endtask
