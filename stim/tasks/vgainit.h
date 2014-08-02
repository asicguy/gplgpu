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

task vgainit;
begin
//====================
$display("Set mode 0x3 (3).");
//====================

// enable VGA decode only (not memory,not vid out) 
mov_dw(IO_WR, rbase_io + 8'h30, 32'h2, 4'h0, 1);

/////Verify_Io(16'h3cc, 1, 32'hd67);
/////Verify_Io(16'h3da, 1, 32'hdf5);
mov_dw(IO_WR, 32'h3c0, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3c4, 32'h1, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h302, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h3, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h204, 4'hc, 1);
mov_dw(IO_WR, 32'h3c2, 32'h670000, 4'hb, 1);
#1000;
/////Verify_Io(16'h3cc, 1, 32'h267);
mov_dw(IO_WR, 32'h3d4, 32'h11, 4'he, 1);
/////Verify_Io(16'h3d5, 1, 32'h11ae);
mov_dw(IO_WR, 32'h3d4, 32'h2e11, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h5f00, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h4f01, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h5002, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h8203, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h5504, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h8105, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'hbf06, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h4f06, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'h1f07, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h0007, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h8, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h4f09, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'hd0a, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'he0b, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'hc, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'hd, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'he, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'hf, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'h9c10, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h3c10, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'hae11, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'ha411, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'h8f12, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h2f12, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h2813, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h1f14, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'h9615, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h3615, 4'hc, 1);
//mov_dw(IO_WR, 32'h3d4, 32'hb916, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'h4916, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'ha317, 4'hc, 1);
mov_dw(IO_WR, 32'h3d4, 32'hff18, 4'hc, 1);
/////Verify_Io(16'h3da, 1, 32'hffc4);
mov_dw(IO_WR, 32'h3c0, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h1, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h1, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h2, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h2, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h4, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h4, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h5, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h5, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h6, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h14, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h7, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h7, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h8, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h38, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h9, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h39, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'ha, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3a, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'hb, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3b, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'hc, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3c, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'hd, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3d, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'he, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3e, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'hf, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h3f, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h10, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'hc, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h11, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h12, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'hf, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h13, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h8, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h14, 4'he, 1);
mov_dw(IO_WR, 32'h3c0, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3cc, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3ca, 32'h10000, 4'hb, 1);
mov_dw(IO_WR, 32'h3ce, 32'h0, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h10000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h20000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h30000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h40000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h10050000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'he060000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h70000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'hff080000, 4'h3, 1);
/////Verify_Io(16'h3cc, 1, 32'h67);
/////Verify_Io(16'h3da, 1, 32'hc5);
mov_dw(IO_WR, 32'h3c0, 32'h0, 4'he, 1);
mov_dw(IO_WR, 32'h3c4, 32'h402, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h704, 4'hc, 1);
mov_dw(IO_WR, 32'h3ce, 32'h2040000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h50000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h4060000, 4'h3, 1);
mov_dw(IO_WR, 32'h3c4, 32'h302, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h304, 4'hc, 1);
mov_dw(IO_WR, 32'h3ce, 32'h40000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'h10050000, 4'h3, 1);
mov_dw(IO_WR, 32'h3ce, 32'he060000, 4'h3, 1);
/////Verify_Io(16'h3cc, 1, 32'he67);
/////Verify_Io(16'h3da, 1, 32'hef4);
mov_dw(IO_WR, 32'h3c0, 32'h20, 4'he, 1);
/////Verify_Io(16'h3da, 1, 32'hec4);
/////Verify_Io(16'h3c4, 1, 32'h1004);
mov_dw(IO_WR, 32'h3c4, 32'h1, 4'he, 1);
/////Verify_Io(16'h3c5, 1, 32'h100);
mov_dw(IO_WR, 32'h3c4, 32'h2001, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h4, 4'he, 1);
/////Verify_Io(16'h3c4, 1, 32'h704);
mov_dw(IO_WR, 32'h3c4, 32'h1, 4'he, 1);
/////Verify_Io(16'h3c5, 1, 32'h120);
mov_dw(IO_WR, 32'h3c4, 32'h1, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h4, 4'he, 1);
/////Verify_Io(16'h3cc, 1, 32'h67);
/////Verify_Io(16'h3da, 1, 32'he5);
mov_dw(IO_WR, 32'h3c0, 32'h20, 4'he, 1);
/////Verify_Io(16'h3da, 1, 32'he4);
/////Verify_Io(16'h3c4, 1, 32'h4);
mov_dw(IO_WR, 32'h3c4, 32'h1, 4'he, 1);
/////Verify_Io(16'h3c5, 1, 32'h100);
mov_dw(IO_WR, 32'h3c4, 32'h1, 4'hc, 1);
mov_dw(IO_WR, 32'h3c4, 32'h4, 4'he, 1);

/// disable VGA decode
mov_dw(IO_WR, rbase_io + 8'h30, 32'h0, 4'h0, 1);

//====================
$display("Done setting mode 0x3 (3).");
//====================
end
endtask
