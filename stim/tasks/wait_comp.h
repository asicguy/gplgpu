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

 
task compreg;

input [31:0] d_expect;

  begin
    if (d_expect == test_reg)
      $display("PASSED\n");
    else
      begin
      $display("Exp.data=%b Act.data=%b FAILED!",d_expect, test_reg);
      //$stop; 
      end
              
  end
endtask


////////////////////////////// mem.w linear check busy ////////////////////////////

////wait_mwl0_bsy, wait_mwl0_bsy 

task wait_mwl0_bsy;
        begin
                rd(MEM_RD, rbase_w+MW0_CTRL,1);
                while (!test_reg[8]) rd(MEM_RD, rbase_w+MW0_CTRL,1);
        end
endtask


task wait_mwl1_bsy;
        begin
                rd(MEM_RD, rbase_w+MW1_CTRL,1);
                while (!test_reg[8]) rd(MEM_RD, rbase_w+MW1_CTRL,1);
        end
endtask
////////////////////////// wait for cache empty ////////////////////////////

task wait_for_cache_empty;
        begin
                rd(MEM_RD, rbase_a+FLOW,1);
                while (test_reg[31]) rd(MEM_RD, rbase_a+FLOW,1);
        end
endtask


