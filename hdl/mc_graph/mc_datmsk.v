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
//  Description :
//  Color keying is a function that will prevent overwriting of a particular
//  color in the frame buffer. This is accomplished by performing a 
//  read-modify-write cycle for all writes. All existing data is compared to a
//  key color, and if it matches, the new data is masked to not overwrite it. 
//  This compare is performed on an entire memory word per cycle. Matches are
//  generated according to current pixel format and used to generate a write 
//  mask. Whether to perform this function at all, and exactly how to look for
//  matches is controlled by the kcnt control bus which is sent from the 
//  drawing engine with each write request.
// 
// 
//  Final mask output is a function of whether we are writing, and what device
//  is performing the write. ifb_pop_en is always asserted on the cycle befor a
//  write so it makes a good enable to update the ram_dqm outputs. ifb_dev_sel
//  tells what resource will be doing that write, so it can be used to mux 
//  between contenders to drive the output bus. Masks from the Host and VIP
//  resources need no modification unless we are in burst mode and we want to 
//  mask an entire page (if for instance their request was less then our burst
//  size). The de needs to use the combination of the mask it provides, the 
//  color key mask, the z mask, and the full page mask.
// 
//  ALL MASKS are active high. I.e., a mask of FFFF means don't write any data
//  to memory, while a mask of 0000 means overwrite the entire page with new 
//  data.
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

`timescale 1 ns / 10 ps

module mc_datmsk
  #
  (
   parameter            BYTES = 4
   )
  (
   input                  mclock,
   input                  mc_dat_pop,
   input                  pipe_enable,
   input [3:0]            ifb_dev_sel,
   input [BYTES-1:0]      hst_byte_mask,
   input [BYTES-1:0]      de_byte_mask,
   input [BYTES-1:0]      de_byte_zmask,
   input [BYTES-1:0]      de_byte_mask_fast,
   input [BYTES-1:0]      new_z_mask,
   input [3:0]            vga_wen,
   input                  rc_rd_sel,       // select a DQM=0 for a read
   input                  z_en,
   input                  z_ro,
   
   output reg [BYTES-1:0] ram_dqm          // Final write strobes to memory
   );


  reg [BYTES-1:0] de_byte_mask_1; // piped to match blending pipe stage
  reg [BYTES-1:0] de_byte_mask_2; // piped to match blending pipe stage
  
  // Pipeline stage
  // A pipeline stage has to be present in the mask logic to match the stage in
  // the blending unit.
  always @(posedge mclock) begin
    if (pipe_enable) begin
      // Datapath only advances when enabled by wau fsm
      de_byte_mask_1 <= de_byte_mask;
      de_byte_mask_2 <= de_byte_mask_1; // | key_mask;
      
      casex ({z_en, z_ro, ifb_dev_sel})
	{1'bx, 1'bx, 4'h4}: ram_dqm <= ~(16'h0);
	{1'bx, 1'bx, 4'h3}: ram_dqm <= ~hst_byte_mask;
        {1'b0, 1'bx, 4'h1}: ram_dqm <= ~de_byte_mask_fast;
        {1'b1, 1'bx, 4'h1}: ram_dqm <= ~(de_byte_mask_fast | new_z_mask);
        {1'b1, 1'bx, 4'h6}: ram_dqm <= ~(de_byte_mask_fast | new_z_mask); // Added (jmacleod).
        {1'b0, 1'bx, 4'h6}: ram_dqm <= ~de_byte_mask_2; // (CHECK)
        {1'bx, 1'bx, 4'h7}: ram_dqm <= ~{4{vga_wen}};
        {1'bx, 1'b0, 4'h8}: ram_dqm <= ~(de_byte_zmask | new_z_mask);
        {1'bx, 1'b1, 4'h8}: ram_dqm <= 16'h0;
      endcase
    end // always @ (posedge mclock)
  end
endmodule // mc_datmsk
