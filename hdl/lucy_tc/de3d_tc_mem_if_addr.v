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
//  Title       :  MC Interface address generation
//  File        :  de3d_tc_mem_if_addr.v
//  Author      :  Frank Bruno
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

`timescale 1 ps / 1 ps

module de3d_tc_mem_if_addr
	(
	input	[8:0]	ul_store_x,	/* UL x address				*/
	input	[8:0]	ul_store_y,	/* UL y address				*/
	input	[8:0]	ll_store_x,	/* LL x address				*/
	input	[8:0]	ll_store_y,	/* LL y address				*/
	input	[8:0]	ur_store_x,	/* UR x address				*/
	input	[8:0]	ur_store_y,	/* UR y address				*/
	input	[8:0]	lr_store_x,	/* LR x address				*/
	input	[8:0]	lr_store_y,	/* LR y address				*/
	input   [2:0]   bank,           /* Bank of ram that we are addressing   */
	input   [2:0]   bpt,            /* Texture map size                     */
	input		tc_ready,	/* Texture cache in read mode		*/
	input	[7:0]	ram_addr,	/* address for exact mode		*/
	input	[3:0]	set_read,	/* selects which set to read.		*/

	output reg	[7:0]	addr_out	/* address to specified RAM		*/
	);

wire           ul_lru_read = set_read[3];
wire           ll_lru_read = set_read[2];
wire           ur_lru_read = set_read[1];
wire           lr_lru_read = set_read[0];

always @* begin
     	case (bpt) /* synopsys parallel_case */
        	/* access a memory location *********************************************/
        	/* 1 bpt ****************************************************************/
        	/* 2 bpt ****************************************************************/
                /* 4 bpt ****************************************************************/
        	/* 8 bpt ****************************************************************/
        	3'h3: 	begin
          			if ({(ul_store_x[4] ^ ul_store_y[0]),ul_store_x[3:2]} == bank) 
					addr_out={ul_lru_read,ul_store_y[5:0],ul_store_x[5]};
          			else if ({(ll_store_x[4] ^ ll_store_y[0]),ll_store_x[3:2]} == bank) 
					addr_out={ll_lru_read,ll_store_y[5:0],ll_store_x[5]};
          			else if ({(ur_store_x[4] ^ ur_store_y[0]),ur_store_x[3:2]} == bank) 
					addr_out={ur_lru_read,ur_store_y[5:0],ur_store_x[5]};
          			else if ({(lr_store_x[4] ^ lr_store_y[0]),lr_store_x[3:2]} == bank) 
					addr_out={lr_lru_read,lr_store_y[5:0],lr_store_x[5]};
				else addr_out = 8'hff;

        		end
        	/* 16 bpt ***************************************************************/
        	3'h4: 	begin
          			if ({(ul_store_x[3] ^ ul_store_y[0]),ul_store_x[2:1]} == bank) 
					addr_out={ul_lru_read,ul_store_y[4:0],ul_store_x[5:4]};

          			else if ({(ll_store_x[3] ^ ll_store_y[0]),ll_store_x[2:1]} == bank) 
					addr_out={ll_lru_read,ll_store_y[4:0],ll_store_x[5:4]};

          			else if ({(ur_store_x[3] ^ ur_store_y[0]),ur_store_x[2:1]} == bank) 
					addr_out={ur_lru_read,ur_store_y[4:0],ur_store_x[5:4]};

          			else if ({(lr_store_x[3] ^ lr_store_y[0]),lr_store_x[2:1]} == bank) 
					addr_out={lr_lru_read,lr_store_y[4:0],lr_store_x[5:4]};

				else addr_out = 8'hff;
        		end
        	/* 32 bpt ***************************************************************/
        	default:
        	 	begin
          			if ({(ul_store_x[2] ^ ul_store_y[0]),ul_store_x[1:0]} == bank) 
					addr_out={ul_lru_read,ul_store_y[3:0],ul_store_x[5:3]};

          			else if ({(ll_store_x[2] ^ ll_store_y[0]),ll_store_x[1:0]} == bank) 
					addr_out={ll_lru_read,ll_store_y[3:0],ll_store_x[5:3]};

          			else if ({(ur_store_x[2] ^ ur_store_y[0]),ur_store_x[1:0]} == bank) 
					addr_out={ur_lru_read,ur_store_y[3:0],ur_store_x[5:3]};

          			else if ({(lr_store_x[2] ^ lr_store_y[0]),lr_store_x[1:0]} == bank) 
					addr_out={lr_lru_read,lr_store_y[3:0],lr_store_x[5:3]};
				else addr_out = 8'hff;
        		end
      		endcase
end

endmodule
