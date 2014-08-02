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
//    		TASK TO TEST 
/******************************************************************************/
task jack_test;

begin
 

 mov_dw (CONFIG_WR, 32'h10, 32'ha000_0008, 4'h0, 1); //assign 4M bytes for linear window 0.
 mov_dw (CONFIG_WR, 32'h14, 32'hb050_0008, 4'h0, 1); //assign 4M bytes for linear window 1.


 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0000_0214, 4'h0, 1); //diasble all decode except linear windows.

//****SET PACKING MODE FOR LINEAR 0 TO YUV_422 at 32BBP *****
 mov_dw (MEM_WR, rbase_w+MW0_CTRL,   32'h3838_0040, 4'h0, 1);  // MW0_CTRL(32 PACKING , 422)
 mov_dw (MEM_WR, rbase_w+MW0_AD,     32'ha000_0000, 4'h0, 1);  // MW0_AD
 mov_dw (MEM_WR, rbase_w+MW0_SZ,     32'h0000_000f, 4'h0, 1);  // MW0_SZ
 mov_dw (MEM_WR, rbase_w+MW0_PGE,    32'h0000_0000, 4'h0, 1);  // MW0_PGE
 mov_dw (MEM_WR, rbase_w+MW0_ORG,    32'h0000_0000, 4'h0, 1);  // MW0_ORG
 mov_dw (MEM_WR, rbase_w+MW0_WSRC,   32'hffff_ffff, 4'h0 ,1);  // MW0_WSRC
 mov_dw (MEM_WR, rbase_w+MW0_WKEY,   32'haaaa_5555, 4'h0, 1);  // MW0_KEY
 mov_dw (MEM_WR, rbase_w+MW0_KYDAT,  32'h0000_0005, 4'h0, 1);  // MW0_KYDAT
 mov_dw (MEM_WR, rbase_w+MW0_MASK,   32'hffff_ffff, 4'h0, 1);  // MW0_MASK

 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0003_0214, 4'h0, 1);  //Enabling Memory Window 0 & 1 decode 


$display("yuvmemwl1 mono + over  done ");

$display ("write YEllow pixels win1"); //235 full(219+16) 3pix +transi
mov_dw (MEM_WR,(32'ha000_0000),(32'hd2_91_d2_0f),4'h0,1); // 2yell 
mov_dw (MEM_WR,(32'ha000_0004),(32'hb2_91_d2_0f),4'h0,1); // yell +ytran 

$display ("write CYAN pixels");
mov_dw (MEM_WR,(32'ha000_0008),(32'ha9_0f_a9_a5),4'h0,1); // 2cyan 
mov_dw (MEM_WR,(32'ha000_000c),(32'h9d_0f_a9_a5),4'h0,1); // cyan  +ytran 

$display ("write GREEN pixels");
mov_dw (MEM_WR,(32'ha000_0010),(32'h90_21_90_35),4'h0,1); // 2green 
mov_dw (MEM_WR,(32'ha000_0014),(32'h7d_21_90_35),4'h0,1); // green  +ytran 

$display ("write Magenta pixels");
mov_dw (MEM_WR,(32'ha000_0018),(32'h6a_de_6a_ca),4'h0,1); // 2mag 
mov_dw (MEM_WR,(32'ha000_001c),(32'h5e_de_6a_ca),4'h0,1); // mag  +ytran 

$display ("write RED pixels");
mov_dw (MEM_WR,(32'ha000_0020),(32'h51_f0_51_5a),4'h0,1); // 2red 
mov_dw (MEM_WR,(32'ha000_0024),(32'h3c_f0_51_5a),4'h0,1); // red  +ytran 

$display ("write BLUE pixels");
mov_dw (MEM_WR,(32'ha000_0028),(32'h28_6e_28_f0),4'h0,1); // 2blue 
mov_dw (MEM_WR,(32'ha000_002c),(32'h1c_6e_28_f0),4'h0,1); // blue  +ytran 

$display ("write BLack16 pixels");
mov_dw (MEM_WR,(32'ha000_0030),(32'h10_80_10_80),4'h0,1); // 2bl 
mov_dw (MEM_WR,(32'ha000_0034),(32'h10_80_10_80),4'h0,1); // bl  +ytran 


$display("read from window0");

rd (MEM_RD,32'ha000_0000 ,26);  // read window 1


$stop;

$display ("write yellow color with blue below 0");
mov_dw (MEM_WR,(32'ha000_0100),(32'hbf_91_bf_0f),4'h0,1); // 2yell 

$display ("write  cyan with red below 0");
mov_dw (MEM_WR,(32'ha000_0104),(32'h96_0f_96_a5),4'h0,1); // 2cyan 

$display ("write  magenta with green below 0 ");
mov_dw (MEM_WR,(32'ha000_0108),(32'h56_de_56_ca),4'h0,1); // 2mag 

$display("read from window0");
rd (MEM_RD,32'ha0000_0100 ,16);  // read window 1



$display ("TEST COUNT=%d",TEST_COUNT);


 //flush the cache, then wait for the host cache to empty its contets to memory(cache is not busy)
mov_dw (MEM_WR, rbase_w+8'h54, 32'h0, 4'hf, 1); //write to the flush register
wait_win0_not_busy;
wait_win1_not_busy;
 
 save_bitmap_2 (32'h0, 32'h14c, 32'hdd, "junk", 32'h1400, 32) ;
 

  end
endtask
