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
task move_cursor;
input [15:0] xpos;
input [15:0] ypos;

begin
$display("Move cursor to: xpos=%h,ypos=%h", { {4{xpos[15]}}, xpos[11:0] },{ {4{ypos[15]}},ypos[11:0] });
pci_burst_data(rbase_g+32'h1C,4'h0,32'h01);	//  Index control = Auto inc on.
pci_burst_data(rbase_g+32'h14,4'h0,32'h00);	//  Index high = 0x00
pci_burst_data(rbase_g+32'h10,4'h0,32'h31);	//  Index low = 0x31 (cursor X low ).
pci_burst_data(rbase_g+32'h18,4'h0,{xpos[7:0]}); //X low	
pci_burst_data(rbase_g+32'h18,4'h0,{xpos[15:8]}); //X high
pci_burst_data(rbase_g+32'h18,4'h0,{ypos[7:0]}); //  Y low 
pci_burst_data(rbase_g+32'h18,4'h0,{ypos[15:8]}); //  Y high = 0 
rd(MEM_RD,rbase_g+CRT_HAC, 1); //dummy read from CRT reg. to brake burst 

end
endtask

