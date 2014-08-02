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
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Brief Description: Contains the capture registers for data back from the 
//  RAM as well as the FIFO used by the drawing engine data path for 
//  read-modify-write
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log: mc_mff_key.v.rca $
//  
//   Revision: 1.3 Thu Aug  6 22:11:31 2009 linstale
//   Update with 072709 drop version.
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 10 ps

module mc_mff_key
  #(parameter BYTES = 4)
  (
   input [(BYTES*8)-1:0]     	data_in,
   input [31:0]     		key_in,
   input [1:0]      		pix,
   input [2:0]      		kcnt,
   input [BYTES-1:0]         	mask_in,
   
   output reg [BYTES-1:0] 	key_mask
   );

   reg [BYTES-1:0]	key_mask_tmp1;
   reg [BYTES-1:0]	key_mask_tmp2;

  // Color keying support logic.
  // This logic compares source or destination data (depending on key control)
  // to a key color, and masks the write if there is a match.
  // Interpertation of kcnt:
  // 0xx = no masking
  // 100 = source masking, mask keyed color
  // 101 = destination masking, mask keyed color
  // 110 = source masking, mask NOT keyed color
  // 111 = destination masking, mask NOT keyed color
  always @* begin
    // Each of the 16 bytes or 8 words or 4 longwords are compared according 
    // to pixel format
    casex(pix)
      2'b00: 
      begin
        key_mask_tmp1[0]   = (data_in[7:0]   == key_in[7:0]);
        key_mask_tmp1[1]   = (data_in[15:8]  == key_in[7:0]);
        key_mask_tmp1[2]   = (data_in[23:16] == key_in[7:0]);
        key_mask_tmp1[3]   = (data_in[31:24] == key_in[7:0]);
	if((BYTES == 16) || (BYTES == 8)) begin
        	key_mask_tmp1[4]   = (data_in[39:32] == key_in[7:0]);
        	key_mask_tmp1[5]   = (data_in[47:40] == key_in[7:0]);
        	key_mask_tmp1[6]   = (data_in[55:48] == key_in[7:0]);
        	key_mask_tmp1[7]   = (data_in[63:56] == key_in[7:0]);
	end
	if(BYTES == 16) begin
        	key_mask_tmp1[8]  = (data_in[71:64]   == key_in[7:0]);
        	key_mask_tmp1[9]  = (data_in[79:72]   == key_in[7:0]);
        	key_mask_tmp1[10] = (data_in[87:80]   == key_in[7:0]);
        	key_mask_tmp1[11] = (data_in[95:88]   == key_in[7:0]);
        	key_mask_tmp1[12] = (data_in[103:96]  == key_in[7:0]);
        	key_mask_tmp1[13] = (data_in[111:104] == key_in[7:0]);
        	key_mask_tmp1[14] = (data_in[119:112] == key_in[7:0]);
        	key_mask_tmp1[15] = (data_in[127:120] == key_in[7:0]);
	end
      end
      2'bx1: begin
        key_mask_tmp1[1:0] = (data_in[15:0]  == key_in[15:0]) ? 2'b11 : 2'b00;
        key_mask_tmp1[3:2] = (data_in[31:16] == key_in[15:0]) ? 2'b11 : 2'b00;
	if((BYTES == 16) || (BYTES == 8)) begin
        	key_mask_tmp1[5:4] = (data_in[47:32] == key_in[15:0]) ? 2'b11 : 2'b00;
        	key_mask_tmp1[7:6] = (data_in[63:48] == key_in[15:0]) ? 2'b11 : 2'b00;
	end
	if(BYTES == 16) begin
        	key_mask_tmp1[9:8]   = (data_in[79:64]   == key_in[15:0]) ? 2'b11 : 2'b00;
        	key_mask_tmp1[11:10] = (data_in[95:80]   == key_in[15:0]) ? 2'b11 : 2'b00;
        	key_mask_tmp1[13:12] = (data_in[111:96]  == key_in[15:0]) ? 2'b11 : 2'b00;
        	key_mask_tmp1[15:14] = (data_in[127:112] == key_in[15:0]) ? 2'b11 : 2'b00;
	end
      end
      2'b10: begin
        key_mask_tmp1[3:0] = (data_in[23:0]  == key_in[23:0]) ? 4'b1111 : 4'b0000;
	if((BYTES == 16) || (BYTES == 8)) begin
        	key_mask_tmp1[7:4] = (data_in[55:32]  == key_in[23:0]) ? 4'b1111 : 4'b0000;
	end
	if(BYTES == 16) begin
        	key_mask_tmp1[11:8] = (data_in[87:64]  == key_in[23:0]) ? 4'b1111 : 4'b0000;
        	key_mask_tmp1[15:12] = (data_in[119:96] == key_in[23:0]) ? 4'b1111 : 4'b0000;
	end
      end
      default: begin
        key_mask_tmp1[3:0] = 4'b0000;
	if((BYTES == 16) || (BYTES == 8)) key_mask_tmp1[7:4] = 4'b0000;
	if(BYTES == 16) key_mask_tmp1[15:8] = 8'b00000000;
      end
    endcase // casex(pix)

    // The final mask is inverted if necessary, depending on key control
    key_mask_tmp2 = !kcnt[1] ? key_mask_tmp1 : ~key_mask_tmp1;

    // The mask is ignored and set to zero if 2d color keying is disabled
   key_mask[3:0]  = mask_in[3:0] | {4{(kcnt[2] & kcnt[0])}} & key_mask_tmp2[3:0];
   if((BYTES == 16) || (BYTES == 8)) key_mask[7:4] = mask_in[7:4] | {4{(kcnt[2] & kcnt[0])}} & key_mask_tmp2[7:4];
   if(BYTES == 16) key_mask[15:8] = mask_in[15:8] | {8{(kcnt[2] & kcnt[0])}} & key_mask_tmp2[15:8];

  end // always @ *
endmodule // mc_mff_key
