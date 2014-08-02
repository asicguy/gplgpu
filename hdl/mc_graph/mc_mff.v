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
//  $Log:$
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 10 ps

module mc_mff
  #(parameter BYTES = 4
    )
  (
   input                      mclock,
   input                      reset_n,
   input [(BYTES*8)-1:0]      de_data_in,
   input [(BYTES*4)-1:0]      de_adata_in,
   input [(BYTES*8)-1:0]      de_zdata_in,
   input [BYTES-1:0]          mask_in,
   input                      load_en,
   input                      de_push,
   input                      de_push_a,
   input                      de_push_z,
   input                      unload_mff,
   input                      unload_de,
   input                      unload_z,
   input                      local_ready,
   input                      z_en,
   input [(BYTES*8)-1:0]      read_data,
   input [2:0]                kcnt_de,
   input [31:0]               kcol_de,
   input [2:0]                kcnt_rd,
   input [31:0]               kcol_rd,
   input [1:0]                pix_de,
   input [1:0]                pix_rd,
   
   output [(BYTES*8)-1:0]     mff_data,
   output [(BYTES*8)-1:0]     de_data_out, 
   output [(BYTES*4)-1:0]     de_adata_out, 
   output [(BYTES*8)-1:0]     de_zdata_out, 
   output [BYTES-1:0]         mask_out,
   output [BYTES-1:0]         zmask_out,
   output reg                 mff_almost_full,
   output reg                 de_almost_full,
   output                     empty_mff,
   output                     empty_de,
   output [6:0]               mff_usedw
   );
  
  reg [(BYTES*8)-1:0] 	      de_zdata_del;
  reg [(BYTES*4)-1:0] 	      de_adata_del;
  reg [(BYTES*8)-1:0] 	      de_data_out_last;
  reg [(BYTES*4)-1:0] 	      de_adata_out_last;
  reg [(BYTES*8)-1:0] 	      de_zdata_out_last;
  reg [BYTES-1:0] 	      de_mask_out_last;
  reg [BYTES-1:0] 	      de_zmask_out_last;

  wire 			      full_mff, full_de;
  wire [6:0] 		      usedw;
  wire [BYTES-1:0] 	      de_mask_out;
  wire [BYTES-1:0] 	      mask_out_rd;
  wire [BYTES-1:0] 	      key_mask;
  wire [BYTES-1:0] 	      key_mask_rd;
  wire [(BYTES*8)-1:0] 	      de_data_out_int;
  wire [(BYTES*8)-1:0] 	      de_zdata_out_int;
  wire [(BYTES*4)-1:0] 	      de_adata_out_int;
  wire [BYTES-1:0] 	      de_mask_out_int;
  wire [BYTES-1:0] 	      de_zmask_out_int;
  wire 			      empty_z;

  wire  [BYTES-1:0] 	      rd_mask_in;
  assign rd_mask_in = {BYTES{1'b0}};


  
  mc_mff_key
    #(.BYTES	   (BYTES)) 
    u_mc_mff_key
    (
     .data_in      (de_data_in),
     // .key_in       (kcol_de),
     .key_in       (kcol_rd),
     .pix          (pix_de),
     // .kcnt         ({kcnt_de[2:1], ~kcnt_de[0]}),    // New.
     .kcnt         ({kcnt_rd[2:1], ~kcnt_rd[0]}),    // New.
     .mask_in      (mask_in),
     
     .key_mask     (key_mask)
     );
  
  mc_mff_key
    #(.BYTES	   (BYTES)) 
    u_mc_mff_key_rd
    (
     .data_in      (read_data),
     .key_in       (kcol_rd),
     .pix          (pix_rd),
     .kcnt         (kcnt_rd),
     .mask_in      (rd_mask_in),
     
     .key_mask     (key_mask_rd)
     );
  
  // If we have at least 18 locations free, then we are not almost full.
  // Registered result for speed.
  always @(posedge mclock) mff_almost_full <= mff_usedw > (128 - 36);
  always @(posedge mclock) de_almost_full  <= usedw     > (128 - 36);
  
  // MFF Fifo
  // This is a FIFO with registered addresses and control signals.


`ifdef RAM_FIFO_36x128
  ssi_sfifo
    #
    (
     .WIDTH                  (9*BYTES),
     .DEPTH                  (128),
     .DLOG2                  (7),
     .AFULL                  (128)
     ) 
  U_RD_MASK
    (
     .data           ({key_mask_rd, read_data}),
     .wrreq          (load_en),
     .rdreq          (unload_mff),
     
     .clock          (mclock),
     .aclr           (~reset_n),

     .q              ({mask_out_rd, mff_data}),
     .full           (full_mff),
     .empty          (empty_mff),
     .usedw          (mff_usedw)
     );
    
  ssi_sfifo
    #
    (
     .WIDTH                  (9*BYTES),
     .DEPTH                  (128),
     .DLOG2                  (7),
     .AFULL                  (128)
     )
  U_DE_MASK
    (
     .data           ({key_mask, de_data_in}),
     .wrreq          (de_push),
     .rdreq          (unload_de),
     
     .clock          (mclock),
     .aclr           (~reset_n),

     .q              ({de_mask_out_int, de_data_out_int}),
     .full           (full_de),
     .empty          (empty_de),
     .usedw          (usedw)
     );

`else
  
  // fifo_36x128 U_RD_MASK[(BYTES/4)-1:0]
  fifo_144x128 U_RD_MASK
    (
     .data           ({key_mask_rd, read_data}),
     .wrreq          (load_en),
     .rdreq          (unload_mff),
     
     .clock          (mclock),
     .aclr           (~reset_n),

     .q              ({mask_out_rd, mff_data}),
     .full           (full_mff),
     .empty          (empty_mff),
     .usedw          (mff_usedw)
     );

  // fifo_36x128 U_DE_MASK[(BYTES/4)-1:0]
  fifo_144x128 U_DE_MASK
    (
     .data           ({key_mask, de_data_in}),
     .wrreq          (de_push),
     .rdreq          (unload_de),
     
     .clock          (mclock),
     .aclr           (~reset_n),

     .q              ({de_mask_out_int, de_data_out_int}),
     .full           (full_de),
     .empty          (empty_de),
     .usedw          (usedw)
     );

  fifo_144x128 U_Z_MASK
    (
     .data           ({key_mask, de_zdata_del}),
     .wrreq          (de_push_z),
     .rdreq          (unload_z),
     
     .clock          (mclock),
     .aclr           (~reset_n),

     .q              ({de_zmask_out_int, de_zdata_out_int}),
     .full           (),
     .empty          (empty_z),
     .usedw          ()
     );

  fifo_144x128 U_A_MASK
    (
     .data           (de_adata_in),
     .wrreq          (de_push_a),
     .rdreq          (unload_de),
     
     .clock          (mclock),
     .aclr           (~reset_n),

     .q              (de_adata_out_int),
     .full           (),
     .empty          (),
     .usedw          ()
     );

`endif // !`ifdef RAM_FIFO_36x128
  
  // assign mask_out = de_mask_out | mask_out_rd & {BYTES{kcnt_rd[2]}};
  // Fix stuck mask problem. (J.Macleod 083110).
  assign mask_out = de_mask_out | (mask_out_rd & {BYTES{kcnt_rd[0]}}) & {BYTES{kcnt_rd[2]}};

  always @(posedge mclock) begin
    de_adata_del      <= de_adata_in;
    de_zdata_del      <= de_zdata_in;
    de_data_out_last  <= de_data_out_int;
    de_adata_out_last <= de_adata_out_int;
    de_zdata_out_last <= de_zdata_out_int;
    de_mask_out_last  <= de_mask_out_int;
    de_zmask_out_last <= de_zmask_out_int;
  end

  assign de_data_out  = (local_ready) ? de_data_out_int  : de_data_out_last;
  assign de_adata_out = (local_ready) ? de_adata_out_int : de_adata_out_last;
  assign de_zdata_out = (local_ready) ? de_zdata_out_int : de_zdata_out_last;
  assign de_mask_out  = (local_ready) ? de_mask_out_int  : de_mask_out_last;
  assign zmask_out    = (local_ready) ? de_zmask_out_int : de_zmask_out_last;

endmodule
