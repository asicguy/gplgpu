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
//  Performs blending and logical operations under the control of the mc_de 
//  block on raw pixel data. Mc_de performs necessary memory read cycles to 
//  fill the mff and pops to the drawing engine to provide data for this block
//  to operate on according to the blend_ctrl_data control bus. Mc_de also 
//  sets up memory write cycles so that the generated data can be written out 
//  to off-chip memory resources.
// 
//  Other Information:
//  The blend_ctrl_data register is a packed control bus that contains a number
//  of pieces of data and control for blending that is sent from the drawing 
//  engine with the request. Its format is as follows:
//  blend_ctrl_data[1:0]        de_pix: 00 8 bits per pixel color
//                                      01 16bpp 5-5-5 mode  ??????????
//                                      10 16bpp 5-6-5 mode  ??????????
//                                      11 32bpp
//  blend_ctrl_data[3:2]        de_bw:
//  
//  blend_ctrl_data[35:4]       de_bwcolor:
// 
//  and on, and on...
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

module mc_dat
  #
  (
   parameter             BYTES = 4
   )
  (
   input                  mclock,
   input                  reset_n,
   input [66:0]           blend_ctrl_data,
   input                  mc_dat_pop,
   input                  pipe_enable,
   input [3:0]            rc_dev_sel,
   input [(BYTES*8)-1:0]  hst_data,
   input [(BYTES*8)-1:0]  de_data,
   input [(BYTES*4)-1:0]  de_adata,
   input [(BYTES*8)-1:0]  de_zdata,
   input [31:0]           vga_data,
   input [BYTES-1:0]      hst_byte_mask,
   input [BYTES-1:0]      de_byte_mask,
   input [BYTES-1:0]      de_byte_zmask,
   input [3:0]            vga_wen,
   input [(BYTES*8)-1:0]  mff_data,
   input                  rc_rd_sel,
   input [4:0]            z_data,
   input                  unload_z,
   input                  push_z,
   input [(BYTES*8)-1:0]  read_data,
   
   output [(BYTES*8)-1:0] fb_data_out,
   output [BYTES-1:0]     fb_dqm, 
   output reg [31:0]      kcol_rd,     // key color
   output reg [2:0]       kcnt_rd,     // keying control
   output reg [1:0]       pix
   );

  // states for constructing the correct comparisons
  localparam	NEVER 	= 3'b000,/* A win will never occur 	*/
		ALWAYS	= 3'b001,/* A win shall always occur	*/
		LESS	= 3'b010,/* Win if new < old		*/
		LEQUAL	= 3'b011,/* Win if new <= old		*/
		EQUAL	= 3'b100,/* Win if new = old		*/
		GEQUAL	= 3'b101,/* Win if new >= old		*/
		GREATER	= 3'b110,/* Win if new > old		*/
		NOTEQUAL= 3'b111;/* Win if new != old		*/

  reg [3:0]             bsrcr;       // Source Blending Register
  reg [2:0]             bdstr;       // Destination Blending Register
  reg                   blend_en;    // Blending Enabled
  reg [7:0]             bsrc_alpha;  // Source Alpha register 
  reg [7:0]             bdst_alpha;  // Destination Alpha register
  reg [3:0]             rop;         // Raster op select
  reg [3:0]             rop_i[5:0];// Raster op select pipelined
  reg [1:0]             pix_i[5:0];
  reg [1:0]             blend_en_pipe;
  reg [(BYTES*8)-1:0]   de_data_i;
  reg [(BYTES*4)-1:0] 	de_adata_i;
  reg [(BYTES*8)-1:0]   de_zdata_i;
  reg [(BYTES*8)-1:0]   z_store_i;
  reg [BYTES-1:0]       de_byte_mask_i;
  reg [BYTES-1:0]       de_byte_zmask_i;
  reg [BYTES-1:0]       new_z_mask;
  reg [(BYTES*8)-1:0]   mff_data_i;
  reg 			z_ro_i, z_en_i;
  reg [2:0] 		z_op_i;
  reg [2:0] 		z_pipe;
  reg [(BYTES*8)-1:0]   z_store;
  reg 			bsrc_en, bdst_en; // source and dest blend reg en
  
  // int 			loop0;
  integer 			loop0;
  
  // 09/10/2010 Bypass the pipe_enable register.
  // (jmacleod)
  always @* {kcol_rd, kcnt_rd} = blend_ctrl_data[35:1];
  
  always @(posedge mclock) begin
    if (pipe_enable) begin
      // {pix, bsrcr, bdstr, bsrc_alpha, bdst_alpha, rop, kcol_rd, kcnt_rd, 
      //  blend_en} <= blend_ctrl_data;
      // 09/10/2010 Remove kcol_rd and kcnt_rd from the pipe_enable register.
      // (jmacleod)
      {pix, bsrcr, bdstr, bsrc_alpha, bdst_alpha, rop, 
       blend_en} <= {blend_ctrl_data[64:36], blend_ctrl_data[0]};
      bsrc_en  <= blend_ctrl_data[65];
      bdst_en  <= blend_ctrl_data[66];
      rop_i[0] <= rop;
      rop_i[1] <= rop_i[0];
      rop_i[2] <= rop_i[1];
      rop_i[3] <= rop_i[2];
      rop_i[4] <= rop_i[3];
      rop_i[5] <= rop_i[4];
      pix_i[0] <= pix;
      pix_i[1] <= pix_i[0];
      pix_i[2] <= pix_i[1];
      pix_i[3] <= pix_i[2];
      pix_i[4] <= pix_i[3];
      pix_i[5] <= pix_i[4];
      z_pipe[0] <= unload_z;
      z_pipe[1] <= z_pipe[0];
      z_pipe[2] <= z_pipe[1];
      
      blend_en_pipe 	 <= {blend_en_pipe[0], blend_en};
      de_data_i       	 <= de_data;
      de_adata_i       	 <= de_adata;
      de_zdata_i      	 <= de_zdata;
      z_op_i          	 <= z_data[2:0];
      z_en_i          	 <= z_data[3];
      z_ro_i          	 <= z_data[4];
      de_byte_mask_i  	 <= de_byte_mask;
      de_byte_zmask_i 	 <= de_byte_zmask;
      mff_data_i         <= mff_data;

      if(push_z) z_store <= read_data;
      z_store_i       	 <= z_store;
    end
  end

  mc_datmsk #
    (
     .BYTES                 (BYTES)
     ) mc_datmsk
    (
     .mclock                (mclock),
     .mc_dat_pop            (mc_dat_pop),
     .pipe_enable           (mc_dat_pop | pipe_enable),
     .ifb_dev_sel           (rc_dev_sel),
     .hst_byte_mask         (hst_byte_mask),
     .vga_wen               (vga_wen),
     .de_byte_mask_fast     (de_byte_mask),
     .de_byte_mask          (de_byte_mask_i),
     .de_byte_zmask         (de_byte_zmask_i),
     .new_z_mask            (new_z_mask),
     .rc_rd_sel             (rc_rd_sel),
     .z_en                  (z_en_i),
     .z_ro                  (z_ro_i),
     
     .ram_dqm               (fb_dqm)
     );

  wire [3:0] rop_i_2 = rop_i[2];

  mc_dat16 mc_dat[(BYTES/2)-1:0]
    (
     .mclock                (mclock),
     .hst_data              (hst_data),
     .src_data              (de_data_i),
     .alpha_data            (de_adata_i),
     .dst_alpha             ({{2{mff_data_i[127:120]}},
			      {2{mff_data_i[95:88]}},
			      {2{mff_data_i[63:56]}},
			      {2{mff_data_i[31:24]}}}),
     .dst_data              (mff_data_i),
     .de_data               (de_data),
     .vga_data              (vga_data[15:0]),	// FIX_ME
     // .vga_data              ({4{vga_data}}),
     .z_data                (de_zdata_i),
     .bsrc_alpha            (bsrc_alpha),
     .bdst_alpha            (bdst_alpha),
     .src_factor_select     (bsrcr[2:0]),
     .dst_factor_select     (bdstr[2:0]),
     .src_reg_en            (bsrc_en),
     .dst_reg_en            (bdst_en),
     .pix                   (pix), // pixel_format 
     .pix_2                 (pix), // pixel_format 
     .blend_en              (blend_en_pipe[1]),
     .mc_dat_pop            (mc_dat_pop),
     .pipe_enable           (mc_dat_pop | pipe_enable),
     .ifb_dev_sel           (rc_dev_sel),
     .rop                   (rop),      // raster_operation
     .rop2                  (rop_i_2),  // Adec has a problem with this, rop_i[2]), // raster_operation
     // Output.
     .ram_data_out          (fb_data_out)
     );

  // Z comparison
  always @(posedge mclock)
    if (z_pipe[1])
      casex({pix_i[0], z_op_i})
	{2'bxx, ALWAYS}: new_z_mask <= {BYTES{1'b0}};
        // 16 BPP modes
        {2'bx1, LESS}:
        for (loop0 = 0; loop0 < BYTES/2; loop0 = loop0 + 1)
	  if (de_zdata_i[loop0*16+:16] < z_store_i[loop0*16+:16])
	    new_z_mask[loop0*2+:2] <= 2'b00;
	  else 
	    new_z_mask[loop0*2+:2] <= 2'b11;
        {2'bx1, LEQUAL}:
	  for (loop0 = 0; loop0 < BYTES/2; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*16+:16] <= z_store_i[loop0*16+:16])
	      new_z_mask[loop0*2+:2] <= 2'b00;
	    else 
	      new_z_mask[loop0*2+:2] <= 2'b11;
        {2'bx1, EQUAL}:
	  for (loop0 = 0; loop0 < BYTES/2; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*16+:16] == z_store_i[loop0*16+:16])
	      new_z_mask[loop0*2+:2] <= 2'b00;
	    else 
	      new_z_mask[loop0*2+:2] <= 2'b11;
        {2'bx1, GEQUAL}:
	  for (loop0 = 0; loop0 < BYTES/2; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*16+:16] >= z_store_i[loop0*16+:16])
	      new_z_mask[loop0*2+:2] <= 2'b00;
	    else 
	      new_z_mask[loop0*2+:2] <= 2'b11;
        {2'bx1, GREATER}:
	  for (loop0 = 0; loop0 < BYTES/2; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*16+:16] > z_store_i[loop0*16+:16])
	      new_z_mask[loop0*2+:2] <= 2'b00;
	    else 
	      new_z_mask[loop0*2+:2] <= 2'b11;
        {2'bx1, NOTEQUAL}:
	  for (loop0 = 0; loop0 < BYTES/2; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*16+:16] != z_store_i[loop0*16+:16])
	      new_z_mask[loop0*2+:2] <= 2'b00;
	    else 
	      new_z_mask[loop0*2+:2] <= 2'b11;
	// 32 bit Z.
        {2'b10, LESS}:
	  for (loop0 = 0; loop0 < BYTES/4; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*32+:32] < z_store_i[loop0*32+:32])
	      new_z_mask[loop0*4+:4] <= 4'b0000;
	    else 
	      new_z_mask[loop0*4+:4] <= 4'b1111;
        {2'b10, LEQUAL}:
	  for (loop0 = 0; loop0 < BYTES/4; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*32+:32] <= z_store_i[loop0*32+:32])
	      new_z_mask[loop0*4+:4] <= 4'b0000;
	    else 
	      new_z_mask[loop0*4+:4] <= 4'b1111;
        {2'b10, EQUAL}:
	  for (loop0 = 0; loop0 < BYTES/4; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*32+:32] == z_store_i[loop0*32+:32])
	      new_z_mask[loop0*4+:4] <= 4'b0000;
	    else 
	      new_z_mask[loop0*4+:4] <= 4'b1111;
        {2'b10, GEQUAL}:
	  for (loop0 = 0; loop0 < BYTES/4; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*32+:32] >= z_store_i[loop0*32+:32])
	      new_z_mask[loop0*4+:4] <= 4'b0000;
	    else 
	      new_z_mask[loop0*4+:4] <= 4'b1111;
        {2'b10, GREATER}:
	  for (loop0 = 0; loop0 < BYTES/4; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*32+:32] > z_store_i[loop0*32+:32])
	      new_z_mask[loop0*4+:4] <= 4'b0000;
	    else 
	      new_z_mask[loop0*4+:4] <= 4'b1111;
        {2'b10, NOTEQUAL}:
	  for (loop0 = 0; loop0 < BYTES/4; loop0 = loop0 + 1)
	    if (de_zdata_i[loop0*32+:32] != z_store_i[loop0*32+:32])
	      new_z_mask[loop0*4+:4] <= 4'b0000;
	    else 
	      new_z_mask[loop0*4+:4] <= 4'b1111;
        default: new_z_mask <= {BYTES{1'b1}};
      endcase // casex ({pix_i[0], z_op_i})

endmodule

