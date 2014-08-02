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

task draw_cur;

reg[6:0] row;
reg[1:0] c0,c1,c2,c3;
reg[63:0] dl,dr;
reg[127:0] dfull;

begin

c0=2'b00;
c1=2'b01;
c2=2'b10;
c3=2'b11;

for (row=0; row<64; row=row+1)
begin
        if(row==0)
        begin
                dl={c0,{31{c1}}};
                dr={ {31{c0}},c1 };
        end
        else if(row <32)
        begin
                dl= dl >> 2;
                dl= {c3,dl[61:0]};
                dr= dr << 2;
                dr= {dr[63:2],c2};
        end
        else if(row == 32)
        begin
                dl={ {31{c2}},c3 };
                dr={c2,{31{c3}}};
        end
        else
        begin
                dl= dl << 2;
                dl= {dl[63:2],c0};
                dr= dr >> 2;
                dr= {c1,dr[61:0]};
        end
 
        dfull={dl,dr};
        for(i=0; i<16; i=i+1)
        begin
        pci_burst_data(rbase_g+32'h18,4'h0, dfull[127:120]);
        dfull=dfull << 8 ;
        end
 
 
end

end

endtask

