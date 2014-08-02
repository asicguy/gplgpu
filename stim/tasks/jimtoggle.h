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
//----------------TEXT--------------------------------------------
task jimtoggle;
begin
$display ("jimtoggle start");
$display ("TEST COUNT=%d",TEST_COUNT);

                wait_for_pipe_not_busy;
		mov_dw(IO_WR, rbase_io + CONFIG1, 32'h0000_3f14, 4'h0, 1 );
		mov_dw(MEM_WR,rbase_a+XYC_AD,32'h40000a00,4'h0,1);
                rbase_aw=32'h40000040;
		mov_dw(IO_WR, rbase_io + CONFIG1, 32'h0010_3f14, 4'h0, 1 );
		mov_dw(MEM_WR,rbase_a+BACK,32'hffffffff,4'h0,1);
		mov_dw(MEM_WR,rbase_a+FORE,32'h0,4'h0,1);
		mov_dw(MEM_WR,rbase_a+CMD,32'h104c0c01,4'h0,1);
		mov_dw(MEM_WR,rbase_a+XY3,32'h0,4'h0,1);
		mov_dw(MEM_WR,rbase_a+BUF_CTRL,32'h40000300,4'h0,1);
		mov_dw(MEM_WR,rbase_a+XY0,32'h0,4'h0,1);
		gwait_for_de_a;
		gwait_for_mc_a;
		gwait_for_prev_a;
		mov_dw(MEM_WR,rbase_a+XY0,32'h400000,4'h0,1);
		mov_dw(MEM_WR,rbase_a+XY2,32'hd0003,4'h0,1);
		mov_burst(MEM_WR,32'h40000040,3'h0, 29'h2,32'haa55aa55,32'haa55aa55,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0);
		mov_dw(MEM_WR,rbase_a+XY1,32'h30000,4'h0,1);
		gwait_for_prev_a;
$display ("1 TEST COUNT=%d",TEST_COUNT);

//----------------SBLTS--------------------------------------------
                mov_dw(MEM_WR, rbase_a+BUF_CTRL,0, 4'h0, 1 );
                // Drawing engine command OPC = blt. 
                mov_dw(MEM_WR, rbase_a+CMD,32'hC01, 4'h0, 1 );
                // XY0 contains the source pointer. 
                mov_dw(MEM_WR, rbase_a+XY0,{16'h3,16'h0}, 4'h0, 1 );
                // XY2 contains size. 
                mov_dw(MEM_WR, rbase_a+XY2,{16'h1,16'h1}, 4'h0, 1 );
                // XY3 contains direction. 
                mov_dw(MEM_WR, rbase_a+XY3,{16'h0,16'h0}, 4'h0, 1 );
                // XY4 contains zoom factor. 
              // obs.  mov_dw(MEM_WR, rbase_a+XY4,{16'h2,16'h0}, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_a+XY4,{16'h0,16'h0}, 4'h0, 1 );
                // XY1 contains vertex one. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'hf,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
                // XY1 contains destination. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'he,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
                // XY4 contains zoom factor. 
              //obs  mov_dw(MEM_WR, rbase_a+XY4,{16'h3,16'h0}, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_a+XY4,{16'h0,16'h0}, 4'h0, 1 );
                // XY1 contains destination. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h1,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
                // XY1 contains destination one. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h1,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
                // XY4 contains zoom factor. 
              //obs.  mov_dw(MEM_WR, rbase_a+XY4,{16'h4,16'h0}, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_a+XY4,{16'h0,16'h0}, 4'h0, 1 );
                // XY1 contains destination. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h1,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
                // XY4 contains zoom factor. 
              //obs.  mov_dw(MEM_WR, rbase_a+XY4,{16'h5,16'h0}, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_a+XY4,{16'h0,16'h0}, 4'h0, 1 );
                // XY1 contains destination. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h1,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
                // XY4 contains zoom factor. 
              //obs  mov_dw(MEM_WR, rbase_a+XY4,{16'h6,16'h0}, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_a+XY4,{16'h0,16'h0}, 4'h0, 1 );
                // XY1 contains destination. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h1,16'h0},4'h0, 1 );
                wait_for_pipe_not_busy;
//----------------VERY LARGE WXFER, RESET BEFOR DONE.--------------
		gwait_for_de_a; 
		gwait_for_mc_a;
$display ("2 TEST COUNT=%d",TEST_COUNT);

                // Drawing engine command OPC = wxfer. 
                mov_dw(MEM_WR, rbase_a+CMD,32'hC07, 4'h0, 1 );
                // XY0 contains the offset. 
                mov_dw(MEM_WR, rbase_a+XY0,0, 4'h0, 1 );
                // XY2 contains size. 
                mov_dw(MEM_WR, rbase_a+XY2,{16'h7fff,16'h1}, 4'h0, 1 );
                // XY3 contains direction. 
////                   mov_dw(MEM_WR, rbase_a+XY3,{16'h0,16'h1}, 4'h0, 1 );
                       mov_dw(MEM_WR, rbase_a+XY3,{16'h0,16'h0}, 4'h0, 1 );
                // XY4 contains zoom factor. 
                mov_dw(MEM_WR, rbase_a+XY4,{16'h0,16'h0}, 4'h0, 1 );
                // XY1 contains destination one. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h0,16'h0},4'h0, 1 );
 $display ("3 TEST COUNT=%d",TEST_COUNT);
 
              // write to the Cache.                             
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'haaaaaaaa, 4'h0, 1 );
                mov_dw(MEM_WR, rbase_aw,32'h55555555, 4'h0, 1 );

                rd(MEM_RD, rbase_a+FLOW,1);
                while (!test_reg[1]) rd(MEM_RD, rbase_a+FLOW,1);
		gwait_for_mc_a;
$display ("4 TEST COUNT=%d",TEST_COUNT);

		//2) ISSUE SOFT RESET
		rd(IO_RD, rbase_io+8'h1c, 1);//read CONFIG 1 register
		mov_dw (IO_WR, rbase_io+8'h1c, (test_reg | 32'h2), 4'b1110, 1);//issue soft reset
		mov_dw (IO_WR, rbase_io+8'h1c, (test_reg | 32'h2), 4'b1110, 1);//issue soft reset
		mov_dw (IO_WR, rbase_io+8'h1c, (test_reg & 32'hffff_fffd), 4'b1110, 1);//deassert soft reset

            //   wait_for_pipe_not_busy;
            // N/A for IM2 Reserved Drawing engine command. 
            // N/A for IM2 mov_dw(MEM_WR, rbase_a+CMD,32'h0000_0008, 4'h0, 1 );
                // XY1 contains trigger. 
            //    mov_dw(MEM_WR, rbase_a+XY1,{16'h0,16'h0},4'h0, 1 );
//----------------TRIANGLE--------------------------------------------
                wait_for_pipe_not_busy;
$display ("5 TEST COUNT=%d",TEST_COUNT);
		mov_dw(MEM_WR,rbase_a+FORE,32'hffffffff,4'h0,1);
		mov_dw(MEM_WR,rbase_a+BACK,32'h0,4'h0,1);
                // set the buffer control register. 
                mov_dw(MEM_WR, rbase_a+BUF_CTRL,0, 4'h0, 1 );
                // Drawing engine command OPC = blt. 
                mov_dw(MEM_WR, rbase_a+CMD,32'h1080C04, 4'h0, 1 );
                // XY0 contains the pattern pointer. 
                mov_dw(MEM_WR, rbase_a+XY0,0, 4'h0, 1 );
                // XY2 contains vertex two. 
                mov_dw(MEM_WR, rbase_a+XY2,{16'h0,16'h3}, 4'h0, 1 );
                // XY3 contains vertex three. 
                mov_dw(MEM_WR, rbase_a+XY3,{16'h4,16'h6}, 4'h0, 1 );
                // XY1 contains vertex one. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h3,16'h0},4'h0, 1 );
		wait_for_pipe_not_busy;
$display ("6 TEST COUNT=%d",TEST_COUNT);
		gwait_for_de_a; 
$display ("7 TEST COUNT=%d",TEST_COUNT);
		gwait_for_mc_a;
$display ("8 TEST COUNT=%d",TEST_COUNT);
//------------- VERY LARGE TRIANGLE, RESET BEFOR DONE. -----------------------
                // Drawing engine command OPC = triangle. 
                mov_dw(MEM_WR, rbase_a+CMD,32'h10C04, 4'h0, 1 );
                // XY0 contains the pattern pointer. 
                mov_dw(MEM_WR, rbase_a+XY0,0, 4'h0, 1 );
                // XY2 contains vertex two. 
                mov_dw(MEM_WR, rbase_a+XY2,{16'h0,16'h3fff}, 4'h0, 1 );
                // XY3 contains vertex three. 
                mov_dw(MEM_WR, rbase_a+XY3,{16'h20,16'h3ff0}, 4'h0, 1 );
                // XY1 contains vertex one. 
                mov_dw(MEM_WR, rbase_a+XY1,{16'h10,16'h0},4'h0, 1 );
                rd(MEM_RD, rbase_a+FLOW,1);
                while (!test_reg[1]) rd(MEM_RD, rbase_a+FLOW,1);
$display ("9 TEST COUNT=%d",TEST_COUNT);
		//2) ISSUE SOFT RESET
		rd(IO_RD, rbase_io+8'h1c, 1);//read CONFIG 1 register
		mov_dw (IO_WR, rbase_io+8'h1c, (test_reg | 32'h2), 4'b1110, 1);//issue soft reset
		mov_dw (IO_WR, rbase_io+8'h1c, (test_reg | 32'h2), 4'b1110, 1);//issue soft reset
		mov_dw (IO_WR, rbase_io+8'h1c, (test_reg & 32'hffff_fffd), 4'b1110, 1);//deassert soft reset
                wait_for_pipe_not_busy;
$display ("10 TEST COUNT=%d",TEST_COUNT);
		gwait_for_de_a; 
$display ("11 TEST COUNT=%d",TEST_COUNT);
		gwait_for_mc_a;
$display ("12 TEST COUNT=%d",TEST_COUNT);
$display ("jimtoggle end");
$display ("TEST COUNT=%d",TEST_COUNT);


end
endtask



/**************************************************************************/
task gwait_for_pipe_a;
        begin
                rd(MEM_RD, rbase_a+BUSY,1);
                while (test_reg[0]) rd(MEM_RD, rbase_a+BUSY,1);
        end
endtask
/**************************************************************************/
task gwait_for_de_a;
        begin
                rd(MEM_RD, rbase_a+FLOW,1);
                while (test_reg[0]) rd(MEM_RD, rbase_a+FLOW,1);
        end
endtask
/**************************************************************************/
task gwait_for_mc_a;
        begin
                rd(MEM_RD, rbase_a+FLOW,1);
                while (test_reg[1]) rd(MEM_RD, rbase_a+FLOW,1);
        end
endtask
/**************************************************************************/
task gwait_for_prev_a;
        begin
                rd(MEM_RD, rbase_a+FLOW,1);
                while (test_reg[3]) rd(MEM_RD, rbase_a+FLOW,1);
        end
endtask
/**************************************************************************/
task gwait_for_crdy_a;
        begin
                rd(MEM_RD, rbase_a+BUF_CTRL,1);
                while (test_reg[31]) rd(MEM_RD, rbase_a+BUF_CTRL,1);
        end
endtask
/**************************************************************************/
task gwait_for_pipe_b;
        begin
                rd(MEM_RD, rbase_b+BUSY,1);
                while (test_reg[0]) rd(MEM_RD, rbase_b+BUSY,1);
        end
endtask
/**************************************************************************/
task gwait_for_de_b;
        begin
                rd(MEM_RD, rbase_b+FLOW,1);
                while (test_reg[0]) rd(MEM_RD, rbase_b+FLOW,1);
        end
endtask
/**************************************************************************/
task gwait_for_mc_b;
        begin
                rd(MEM_RD, rbase_b+FLOW,1);
                while (test_reg[1]) rd(MEM_RD, rbase_b+FLOW,1);
        end
endtask
/**************************************************************************/
task gwait_for_prev_b;
        begin
                rd(MEM_RD, rbase_b+FLOW,1);
                while (test_reg[3]) rd(MEM_RD, rbase_b+FLOW,1);
        end
endtask
/**************************************************************************/
task gwait_for_crdy_b;
        begin
                rd(MEM_RD, rbase_b+BUF_CTRL,1);
                while (test_reg[31]) rd(MEM_RD, rbase_b+BUF_CTRL,1);
        end
endtask
/**************************************************************************/
task gwait_for_mw0;
        begin
                rd(MEM_RD, rbase_w+MW0_CTRL,1);
                while (!test_reg[8]) rd(MEM_RD, rbase_w+MW0_CTRL,1);
        end
endtask
/**************************************************************************/
task gwait_for_mw1;
        begin
                rd(MEM_RD, rbase_w+MW1_CTRL,1);
                while (!test_reg[8]) rd(MEM_RD, rbase_w+MW1_CTRL,1);
        end
endtask
/**************************************************************************/

// mov_burst task used to be here
 
/***************************************************************************/
