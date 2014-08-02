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
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  Top Level of the Memory Controller
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

module mc
  #(parameter BYTES           = 4)
  (
   input                        hst_clock,
   input [7:0]                  de_bdst_alpha,
   input [2:0]                  de_bdstr,
   input                        de_blend_en,
   input [1:0]                  de_blend_reg_en,
   input [7:0]                  de_bsrc_alpha,
   input [3:0]                  de_bsrcr,
   input [BYTES-1:0]            de_byte_mask,
   input                        de_clock,
   input [(BYTES*8)-1:0]        de_data,
   input [(BYTES*4)-1:0]        de_adata,
   input [2:0]                  de_kcnt,
   input [31:0]                 de_kcol,
   input [3:0]                  de_page,
   input [1:0]                  de_pix,
   input                        de_read,
   input                        de_rmw,
   input [3:0]                  de_rop,
   input [31:0]                 de_address,
   input                        de_pc_empty,
   input                        line_actv_4,
   input                        de_zen,
   input                        de_zro,
   input [2:0]                  de_zop,
   input [31:0]                 de_zaddr,
   input [BYTES*8-1:0]          de_zdata,
   
   input [27:0]                 dlp_org,
   input                        dlp_req,
   input [4:0]                  dlp_wcnt,
   input                        mclock,
   input                        reset_n,

   input [BYTES-1:0]            hst_byte_mask,
   input [BYTES*8-1:0]          hst_data,
   input [22:0]                 hst_org,
   input 	                hst_read,
   input 	                hst_req,

   input                        pixclk,
   input	                crt_clock,
   input	                crt_req,
   input [20:0]	                crt_org,
   input [4:0]	                crt_page,
   input [11:0]	                crt_ptch,
   input [9:0]	                crt_x,
   input [11:0]	                crt_y,

   input                        vga_mode,
   input                        v_mclock,
   input                        vga_req,
   input                        vga_rd_wrn,
   input [17:0]                 vga_addr,
   input [3:0]                  vga_we,
   input [31:0]                 vga_data_in,

   input [31:0]                 tc_address,
   input [5:0]                  tc_page,
   input                        tc_req,
   input                        pal_req,
   input                        pal_half,
   input [31:0]                 pal_address,
   
   output                       de_popen,
   output                       de_push,
   output                       de_last,
   output                       de_last4,
   output                       de_pc_pop,
   output                       dlp_push,
   output                       dlp_mc_done,
   output                       dlp_ready,
   output 	                hst_pop,
   output 	                hst_push,
   output 	                hst_rdy,
   output [1:0]                 hst_mw_addr,
   output reg [(BYTES*8)-1:0]   read_data,
   output 	                crt_push,
   output                       crt_ready,
   output                       mcb,
   output                       mc_busy,
   output                       vga_ack,
   output                       vga_ready_n,
   output [31:0]                vga_data,       // VGA data out to VGA

   output                       tc_ack,
   output                       tc_push,
   output                       pal_ack,
   output                       pal_push,
   
   // DDR3 Avalon Interface
   output [24:0]	        local_address,
   output		        local_write_req,
   output		        local_read_req,
   output		        local_burstbegin,
   output [BYTES*8-1:0]	        local_wdata,
   output [BYTES-1:0] 	        local_be,
   output [5:0]	                local_size,

   input		        local_ready,
   input [BYTES*8-1:0]	        local_rdata,
   input		        local_rdata_valid,
   input                        init_done,
   output [3:0] 		dev_sel
   );

  localparam
    CRT         = 3'h0,
    DE          = 3'h1,
    DLP         = 3'h2,
    HOST        = 3'h3,
    TEX         = 3'h4,
    PAL         = 3'h5,
    // Device but no request
    MFF         = 3'h6;

  // Internal signal declarations
  wire [66:0]             blend_data, blend_to_arb;
  wire [4:0] 		  z_data, z_to_arb;
  wire [31:0] 		  z_arb_addr;
  wire [1:0]              de_arb_cmd, de_arb_cmd_o;
  wire                    de_gnt;
  wire [27:0]             dlp_arb_addr;
  wire [4:0]              dlp_arb_wcnt;
  wire                    dlp_arb_req;
  wire                    dlp_gnt;
  wire [(BYTES*8)-1:0]    mff_data;
  wire [(BYTES*8)-1:0]    de_mff, de_zmff;
  wire [(BYTES*4)-1:0] 	  de_amff;
  wire                    de_push_mff;
  wire                    de_push_mff_z;
  wire                    de_push_mff_a;
  wire [BYTES-1:0]        de_byte_mask_int;
  wire [BYTES-1:0]        de_byte_zmask_int;
  wire [31:0]             de_arb_address, de_arb_address_o;
  wire                    mff_empty;            // Empty to hold of DE reads
  wire                    mff_almost_full;      // DE fifo almost full flag
  wire                    de_almost_full;       // DE fifo almost full flag
  wire                    empty_de;
  wire                    de_arb_reqn;
  wire [3:0]              de_arb_page;
  wire                    read_push;
  wire [2:0]              kcnt_rd;
  wire [31:0]             kcol_rd;
  wire [1:0]              pix;
  wire                    line_active;
  wire                    unload_de, unload_mff, unload_z;
  wire                    mc_dat_pop;
  wire                    mff_push;
  wire [22:0] 		  hst_arb_addr;  // MC internal address to arbiter
  wire [1:0] 		  hst_arb_page;  // MC internal page count to arbiter
  wire 			  hst_arb_read;  // MC internal r/w select to arbiter
  wire 			  hst_arb_req;   // MC internal request to arbiter
  wire 			  hst_gnt;
  wire 			  crt_gnt;
  wire 			  unload_hst;
  wire 			  push_de;
  wire 			  push_crt;
  wire 			  push_tex;
  wire 			  push_hst;
  wire 			  crt_arb_req; // CRT to arb
  wire [4:0] 		  crt_arb_page;
  wire [20:0] 		  crt_arb_addr;
  wire 			  vga_gnt;
  wire 			  vga_arb_req;
  wire [17:0] 		  vga_arb_addr;
  wire 			  vga_arb_read;
  wire [31:0] 		  vga_data_out;
  wire [3:0] 		  vga_wen;
  wire 			  vga_pop;
  wire 			  vga_push;
  wire [6:0] 		  mff_usedw;
  wire 			  push_z;

  always @(posedge mclock) read_data <= local_rdata;

  assign hst_push = push_hst;
  
  mc_arb #
    (
     .BYTES                   (BYTES)
     ) 
  u_mc_arb
    (
     .mclock                 (mclock),
     .reset_n                (reset_n),
     .dlp_arb_addr           (dlp_arb_addr), 
     .dlp_arb_wcnt           (dlp_arb_wcnt), 
     .dlp_arb_req            (dlp_arb_req), 
     .line_actv_4            (line_active),
     .de_arb_addr            (de_arb_address_o), 
     .de_arb_page            (de_arb_page), 
     .de_arb_cmd             (de_arb_cmd_o),
     .de_arb_req             (~de_arb_reqn),
     .z_arb_addr             (z_arb_addr),
     .empty_de               (empty_de),
     .blend_ctrl_data        (blend_to_arb),
     .z_to_arb_in            (z_to_arb),
     .mff_empty              (mff_empty),

     // Host interface
     .hst_arb_addr           (hst_arb_addr),
     .hst_arb_page           (hst_arb_page),
     .hst_arb_read           (hst_arb_read),
     .hst_arb_req            (hst_arb_req),

     // CRT interface
     .crt_arb_req            (crt_arb_req),
     .crt_arb_page           (crt_arb_page),
     .crt_arb_addr           (crt_arb_addr),

     // VGA input
     .vga_mode               (vga_mode),
     .vga_arb_req            (vga_arb_req),
     .vga_arb_addr           (vga_arb_addr),
     .vga_arb_read           (vga_arb_read),

     // TC
     .tc_address             (tc_address),
     .tc_page                (tc_page),
     .tc_req                 (tc_req),
     .tc_ack                 (tc_ack),

     // Palette
     .pal_address            (pal_address),
     .pal_req                (pal_req),
     .pal_half               (pal_half),
     .pal_ack                (pal_ack),
     
     .local_ready            (local_ready),
     .local_rdata_valid      (local_rdata_valid),
     .init_done              (init_done),
     
     .local_address          (local_address),
     .local_write_req        (local_write_req),
     .local_read_req         (local_read_req),
     .local_burstbegin       (local_burstbegin),
     .local_size             (local_size),
     
     .dlp_gnt                (dlp_gnt),
     .de_gnt                 (de_gnt),
     .hst_gnt                (hst_gnt),
     .crt_gnt                (crt_gnt),
     .unload_de              (unload_de),
     .push_de                (de_push),
     .push_dlp               (dlp_push),
     .push_tex               (tc_push),
     .push_pal               (pal_push),
     .push_hst               (push_hst),
     .push_mff               (mff_push),
     .push_crt               (crt_push),
     .push_z                 (push_z),
     .vga_gnt                (vga_gnt),
     .vga_pop                (vga_pop),
     .vga_push               (vga_push),
     .mc_dat_pop             (mc_dat_pop),
     .unload_hst             (unload_hst),
     .dev_sel                (dev_sel),
     .mff_usedw              (mff_usedw),
     .unload_mff             (unload_mff),
     .unload_z               (unload_z),
     .mff_ctrl_data          (blend_data),
     .z_data                 (z_data),
     .mc_busy                (mc_busy)
     ); 

  mc_hst u_mc_hst
    (
     .mclock                 (mclock),
     .reset_n                (reset_n), 
     .hst_clock              (hst_clock), 
     .hst_gnt                (hst_gnt), 
     .hst_org                (hst_org), 
     .hst_read               (hst_read), 
     .hst_req                (hst_req), 
     .rc_push_en             (push_hst),
     .rc_pop_en              (unload_hst), 

     .hst_arb_addr           (hst_arb_addr),
     .hst_pop                (hst_pop), 
     .hst_push               (), // hst_push), 
     .hst_rdy                (hst_rdy), 
     .hst_mw_addr            (hst_mw_addr),
     .hst_arb_page           (hst_arb_page),
     .hst_arb_read           (hst_arb_read), 
     .hst_arb_req            (hst_arb_req) 
     ); 
  
  mc_crt u_mc_crt
    (
     .mclock                 (mclock),
     .reset_n                (reset_n),
     .pixclk                 (pixclk),
     .crt_clock              (crt_clock),
     .crt_gnt                (crt_gnt),
     .crt_req                (crt_req),
     .crt_org                (crt_org),
     .crt_page               (crt_page),
     .crt_ptch               (crt_ptch),
     .crt_x                  (crt_x),
     .crt_y                  (crt_y),
     
     .crt_ready              (crt_ready),
     .crt_arb_req            (crt_arb_req),
     .crt_arb_page           (crt_arb_page),
     .crt_arb_addr           (crt_arb_addr)
     );

  mc_vga u_vga
    (
     .mclock                 (mclock),
     .v_mclock               (v_mclock),
     .reset_n                (reset_n),
     .vga_req                (vga_req),
     .vga_rd_wrn             (vga_rd_wrn),
     .vga_addr               (vga_addr),
     .vga_we                 (vga_we),
     .vga_data_in            (vga_data_in),
     .vga_gnt                (vga_gnt),
     .vga_pop                (vga_pop),
     .vga_push               (vga_push),
     .read_data              (read_data[31:0]),
     .init_done              (init_done),
     
     .vga_arb_req            (vga_arb_req),
     .vga_arb_addr           (vga_arb_addr),
     .vga_arb_read           (vga_arb_read),
     .vga_ack                (vga_ack),
     .vga_ready_n            (vga_ready_n),
     .vga_data_out           (vga_data_out),
     .vga_wen                (vga_wen),
     .vga_data               (vga_data)
     );
  
  mc_dat #
    (
     .BYTES                   (BYTES)
     ) 
  u_mc_dat
    (
     .mclock                 (mclock),
     .reset_n                (reset_n), 
     .blend_ctrl_data        (blend_data), 
     .mc_dat_pop             (mc_dat_pop),
     .pipe_enable            (local_ready),
     .rc_dev_sel             (dev_sel),
     .hst_data               (hst_data), 
     .de_data                (de_mff), 
     .de_adata               (de_amff), 
     .de_zdata               (de_zmff), 
     .vga_data               (vga_data_out),
     .hst_byte_mask          (hst_byte_mask), 
     .de_byte_mask           (de_byte_mask_int),
     .de_byte_zmask          (de_byte_zmask_int),
     .vga_wen                (vga_wen),
     .mff_data               (mff_data),
     .rc_rd_sel              (1'b0), // fixme!!!!!!
     .z_data                 (z_data), 
     .unload_z               (unload_z),
     .push_z                 (push_z),
     .read_data              (read_data),
     // Outputs.
     .fb_data_out            (local_wdata), 
     .fb_dqm                 (local_be), 
     .kcol_rd                (kcol_rd),
     .kcnt_rd                (kcnt_rd),
     .pix                    (pix)
     ); 

   wire de_rmw_kcnt = de_rmw | (de_kcnt[2] & de_kcnt[0]);

  mc_de #
    (.BYTES            (BYTES)
     ) u_mc_de
    (
     .line_actv_4            (line_actv_4),
     .de_address             (de_address), 
     .de_pc_empty            (de_pc_empty), 
     .de_page                (de_page), 
     .de_read                (de_read), 
     .de_rmw                 (de_rmw_kcnt), 
     .de_push                (de_push),
     .reset_n                (reset_n), 
     .mclock                 (mclock),
     .de_almost_full         (de_almost_full),
     .de_zen		     (de_zen),
     // Outputs.
     .fifo_push              (read_push),
     .de_popen               (de_popen), 
     .de_last                (de_last),
     .de_last4               (de_last4),
     .de_pc_pop              (de_pc_pop),
     .de_arb_cmd             (de_arb_cmd), 
     .de_arb_address         (de_arb_address), 
     .mcb                    (mcb),
     .de_push_mff            (de_push_mff),
     .de_push_mff_z          (de_push_mff_z),
     .de_push_mff_a          (de_push_mff_a)
     ); 

`ifdef RAM_FIFO_104x128
  ssi_sfifo
    #
    (
     .WIDTH                  (141),
     .DEPTH                  (128),
     .DLOG2                  (7),
     .AFULL                  (128)
     ) 
  U_defifo
    (
     .clock                  (mclock),
     .aclr                   (~reset_n),
     .data                   ({de_zaddr, de_zro, de_zen, de_zop,
			       line_actv_4, de_arb_address, de_page, 
                               de_arb_cmd,
                               de_blend_reg_en, de_pix, de_bsrcr, de_bdstr, 
                               de_bsrc_alpha, de_bdst_alpha, 
                               de_rop, de_kcol, de_kcnt, 
                               de_blend_en}),
     .rdreq                  (de_gnt),
     .wrreq                  (read_push),
     .empty                  (de_arb_reqn),
     .full                   (),
     .q                      ({z_arb_addr, z_to_arb,
			       line_active, de_arb_address_o, de_arb_page, 
                               de_arb_cmd_o,
                               blend_to_arb}),
     .usedw                  ()
     );
`else
  fifo_144x128 U_defifo
    (
     .clock                  (mclock),
     .aclr                   (~reset_n),
     .data                   ({de_zaddr, de_zro, de_zen, de_zop,
			       line_actv_4, de_arb_address, de_page, 
                               de_arb_cmd,
                               de_blend_reg_en, de_pix, de_bsrcr, de_bdstr, 
                               de_bsrc_alpha, de_bdst_alpha, 
                               de_rop, de_kcol, de_kcnt, 
                               de_blend_en}),
     .rdreq                  (de_gnt),
     .wrreq                  (read_push),
     .empty                  (de_arb_reqn),
     .full                   (),
     .q                      ({z_arb_addr, z_to_arb,
			       line_active, de_arb_address_o, de_arb_page, 
                               de_arb_cmd_o,
                               blend_to_arb}),
     .usedw                  ()
     );
`endif // !`ifdef RAM_FIFO_100x128
  
  mc_dlp #
    (
     .BYTES                   (BYTES)
     ) u_mc_dlp
    (
     .dlp_arb_req            (dlp_arb_req), 
     .dlp_arb_addr           (dlp_arb_addr), 
     .dlp_arb_wcnt           (dlp_arb_wcnt), 
     .dlp_req                (dlp_req), 
     .dlp_wcnt               (dlp_wcnt), 
     .dlp_org                (dlp_org), 
     .dlp_ready              (dlp_ready), 
     .dlp_push               (dlp_push), 
     .dlp_mc_done            (dlp_mc_done), 
     .dlp_gnt                (dlp_gnt), 
     .hst_clock              (hst_clock), 
     .reset_n                (reset_n), 
     .mclock                 (mclock)
     ); 

  mc_mff #
    (
     .BYTES                  (BYTES)
     ) u_mc_mff
      (
       .mclock                 (mclock),
       .reset_n                (reset_n), 
       .de_data_in             (de_data),
       .de_adata_in            (de_adata),
       .de_zdata_in            (de_zdata),
       .mask_in                (de_byte_mask),
       .load_en                (mff_push),
       .de_push                (de_push_mff),
       .de_push_a              (de_push_mff_a),
       .de_push_z              (de_push_mff_z),
       .unload_mff             (unload_mff),
       .unload_de              (unload_de),
       .unload_z               (unload_z),
       .local_ready            (local_ready),
       .read_data              (read_data),
       .kcnt_de                (de_kcnt),
       .kcol_de                (de_kcol),
       // Changed 09/07/2010 (jmacleod).
       // .kcnt_rd             (blend_to_arb[3:1]), // Old.
       .kcnt_rd                (kcnt_rd),	    // New.
       .kcol_rd                (kcol_rd),
       .pix_de                 (de_pix),
       .pix_rd                 (pix),
       
       .mff_data               (mff_data), 
       .de_data_out            (de_mff),
       .de_adata_out           (de_amff),
       .de_zdata_out           (de_zmff),
       .mask_out               (de_byte_mask_int),
       .zmask_out              (de_byte_zmask_int),
       .mff_almost_full        (mff_almost_full),
       .de_almost_full         (de_almost_full),
       .empty_mff              (mff_empty),
       .empty_de               (empty_de),
       .mff_usedw              (mff_usedw)
       ); 
  
endmodule // mc

