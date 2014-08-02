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
//  Title       :  Top level stimulus file for ImaginePC family of chips
//  File        :  borealis_stim.v
//  Author      :  Frank Bruno
//  Created     :  12-29-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : This file is the top level stimulus file for Borealis
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
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 10 ps
module graph_core_stim;

`define DISPLAY_MODE 32'H0104_0101
`define BLOCK_MODE 32'h0
`include "../../stim/includes/stim_params_sh.h"

  parameter 
      `ifdef BYTE4
      BYTES           = 4,
      BYTE_BASE       = 2,
      `elsif BYTE8
      BYTES           = 8,
      BYTE_BASE       = 3,
      `elsif BYTE16
      BYTES           = 16,
      BYTE_BASE       = 4,
      `else
      BYTES           = 32,
      BYTE_BASE       = 5,
      `endif
      DE_ADDR         = 32'h800,
      `ifdef WIN_TEST XYW_ADDR        = 32'h4000_0000,
      `else           XYW_ADDR        = 32'h1000_0000,
      `endif
      id_width        = 4,
      addr_width      = 29,
      aresp_width     = 2,
      alen_width      = 4,
      asize_width     = 3,
      aburst_width    = 2,
      alock_width     = 2,
      acache_width    = 4,
      aprot_width     = 3;
                      
  reg                   start_of_test = 0;
   // Clock and reset signals
  reg                   pclk;           // host clock reg port
  reg                   de_clk;         // Drawing engine clock
  reg                   pll_ref_clk;    // 25Mhz Board clock
  wire                  mclock;         // Memory controller clock
  reg                   bb_rstn;        // Global soft reset 
   

   // Dual port ram interface for ded_ca_top.v

   `ifdef BYTE16 
  wire [3:0]            ca_enable;
   `elsif BYTE8  
     wire [1:0]            ca_enable;
   `else         
  wire                     ca_enable; 
   `endif
  wire                     de_push;
  wire [(BYTES*8)-1:0]    mc_read_data;
  wire [4:0]               ca_ram_addr0;
  wire [4:0]               ca_ram_addr1;
  wire [(BYTES*8)-1:0]    hb_dout_ram, hb_din;
  reg  [(BYTES*8)-1:0]    hb_dout_ramc;
  wire [(BYTES<<3)-1:0]   ca_dout0;
  wire [(BYTES<<3)-1:0]   ca_dout1;

   // Host interface signals
  reg [31:2]               paddr;          // APB address.
  reg [31:0]               pwdata;         // APA data.
  reg                      pwrite;         // Host write enable
  reg                      psel;           // Chip Select
  reg                      penable;        // Chip Select

  wire [31:0]              prdata;         // host bus read back data
  reg  [31:0]              pwcdata;        // Cache swizzel data.
  wire                     interrupt;      // host interrupt active high.
   
  // DLP signals
  reg                      vb_int_tog;      // Vertical interrupt

  // DDR3 signals
  tri [ 63: 0] 		   mem_dq;
  tri [  7: 0] 		   mem_dqs;
  tri [  7: 0] 		   mem_dqsn;
  wire [ 13: 0] 	   mem_addr;
  wire [  2: 0] 	   mem_ba;
  wire 			   mem_cas_n;
  wire 			   mem_cke;
  wire 			   mem_clk;
  wire 			   mem_clk_n;
  wire 			   mem_cs_n;
  wire [  7: 0] 	   mem_dm;
  wire 			   mem_odt;
  wire 			   mem_ras_n;
  wire 			   mem_rst_n;
  wire 			   mem_we_n;

  // SIMULATION ENVIRONMENT REGISTERS.
  reg           enable_64;
  reg [19:0]    aw_mask;
  reg [3:0]     aw_size;
  reg [31:0]    config_reg;
  reg [31:0]    temp_config;
  reg           config_en;
  reg [31:0]    rbase_io;
  reg [31:0]    rbase_g;  // holding register for the global base address.    
  reg [31:0]    rbase_w;  // holding register for the memory windows base addr
  reg [31:0]    rbase_a;  // holding register for drawing engine A base addr  
  reg [31:0]    rbase_aw; // holding reg for drawing engine A cache base addr 
  reg [31:0]    rbase_b;  // holding register for drawing engine B base addr  
  reg [31:0]    rbase_bw; // holding reg for drawing engine B cache base addr 
  reg [31:0]    rbase_i;  // holding register for interrupt register address. 
  reg [31:0]    rbase_e;  // holding register for EPROM base address.
  reg [31:0]    rbase_mw0;
  reg [31:0]    rbase_mw1;
  reg [31:0]    test_reg; // holding register for read.                       
  reg [15:0]    h;
  reg [15:0]    i;
  reg [15:0]    j;
  reg [15:0]    k;
  reg [15:0]    l;
  reg [15:0]    m;
  reg [15:0]    n;
  reg [15:0]    o;
  reg [15:0]    p;
  reg [15:0]    w;
  reg [15:0]    xs;
  reg [15:0]    ys;
  reg [15:0]    xd;
  reg [15:0]    yd;
  reg [15:0]    xe;
  reg [15:0]    ye;
  reg [15:0]    xs_inc;
  reg [15:0]    ys_inc;
  reg [15:0]    xe_inc;
  reg [15:0]    ye_inc;
  reg [15:0]    zx;
  reg [15:0]    zy;
  reg [14:0]    mw0_mask;
  reg [14:0]    mw1_mask;
  reg [31:12]   mw0_ad_dout;
  reg [31:12]   mw1_ad_dout;
  reg [3:0]     mw0_sz_dout;
  reg [3:0]     mw1_sz_dout;
  reg [31:0]    mw0_org_dout;
  reg [31:0]    mw1_org_dout;
  reg [31:0]    mem_address;
  reg [31:0]    old_mem;
  // hb port to the cache for sims
  wire [4:0]    hb_ram_addr;
  reg [31:12]   xyw_a_dout;
  
  graph_core
    #(
      .BYTES           (BYTES),
      .DE_ADDR         (DE_ADDR),
      .XYW_ADDR        (XYW_ADDR)
      )
  u_core
    (
     // Clock and reset signals
     .de_clk           (de_clk),
     .mclock           (mclock),
     .pll_ref_clk      (pll_ref_clk),
     .bb_rstn          (bb_rstn),
   
     // Host interface signals
     .pclk             (pclk),
     .paddr            (paddr),
     .pwdata           (pwdata),
     .pwrite           (pwrite),
     .psel             (psel),
     .penable          (penable),
     .prdata           (prdata),
     .pready           (pready),
     .pslverr          (pslverr),
     .interrupt        (interrupt),

     // Memory Window Flush in progress.
     // Tie to zero if frame buffer is not cached.
     .mw_de_fip        (1'b0),
     .mw_dlp_fip       (1'b0),

     // Dual port ram interface for ded_ca_top.v
     .ca_enable        (ca_enable),
     .hb_ram_addr      (hb_ram_addr),
     .de_push          (de_push),
     .mc_read_data     (mc_read_data),
     .ca_ram_addr0     (ca_ram_addr0),
     .ca_ram_addr1     (ca_ram_addr1),
     .hb_dout_ram      (hb_dout_ramc),
     .ca_dout0         (ca_dout0),
     .ca_dout1         (ca_dout1),

     // DLP signals
     .vb_int_tog       (vb_int_tog),

     .mem_addr          (mem_addr),
     .mem_ba            (mem_ba),
     .mem_cas_n         (mem_cas_n),
     .mem_cke           (mem_cke),
     .mem_clk           (mem_clk),
     .mem_clk_n         (mem_clk_n),
     .mem_cs_n          (mem_cs_n),
     .mem_dm            (mem_dm),
     .mem_odt           (mem_odt),
     .mem_ras_n         (mem_ras_n),
     .mem_rst_n         (mem_rst_n),
     .mem_we_n          (mem_we_n),
     
     // outputs:
     .mem_dq            (mem_dq),
     .mem_dqs           (mem_dqs),
     .mem_dqsn          (mem_dqsn)
   );


// Write swizzle.
always @* begin
    case(u_core.U_DE.hdf_1)
    	3'b000: pwcdata = pwdata;
	3'b001: pwcdata = {hdf_rot(pwdata[31:24]), hdf_rot(pwdata[23:16]), hdf_rot(pwdata[15:8]), hdf_rot(pwdata[7:0])};
    	3'b010: pwcdata = {pwdata[23:16], pwdata[31:24], pwdata[7:0], pwdata[15:8]};
	3'b011: pwcdata = {hdf_rot(pwdata[23:16]), hdf_rot(pwdata[31:24]), hdf_rot(pwdata[7:0]), hdf_rot(pwdata[15:8])};
    	3'b100: pwcdata = {pwdata[15:8], pwdata[7:0], pwdata[31:24], pwdata[23:16]}; 
	3'b101: pwcdata = {hdf_rot(pwdata[15:8]), hdf_rot(pwdata[7:0]), hdf_rot(pwdata[31:24]), hdf_rot(pwdata[23:16])};
    	3'b110: pwcdata = {pwdata[7:0], pwdata[15:8], pwdata[23:16], pwdata[31:24]}; 
	3'b111: pwcdata = {hdf_rot(pwdata[7:0]), hdf_rot(pwdata[15:8]), hdf_rot(pwdata[23:16]), hdf_rot(pwdata[31:24])};
      endcase
end

// Read swizzle.
always @* begin
       if (BYTES == 16) begin
    	case(u_core.U_DE.hdf_1)
	3'b000: hb_dout_ramc[127:64] = hb_dout_ram[127:64];
	3'b001: hb_dout_ramc[127:64] = 
		{
		 hdf_rot(hb_dout_ram[127:120]),
	 	 hdf_rot(hb_dout_ram[119:112]),
	 	 hdf_rot(hb_dout_ram[111:104]),
	 	 hdf_rot(hb_dout_ram[103:96]),
	 	 hdf_rot(hb_dout_ram[95:88]),
	 	 hdf_rot(hb_dout_ram[87:80]),
	 	 hdf_rot(hb_dout_ram[79:72]),
	 	 hdf_rot(hb_dout_ram[71:64])
		 };
	3'b010: hb_dout_ramc[127:64] = 
		{
	 	 hb_dout_ram[119:112],
		 hb_dout_ram[127:120],
	 	 hb_dout_ram[103:96],
	 	 hb_dout_ram[111:104],
	 	 hb_dout_ram[87:80],
	 	 hb_dout_ram[95:88],
	 	 hb_dout_ram[71:64],
	 	 hb_dout_ram[79:72]
		 };
	3'b011: hb_dout_ramc[127:64] = 
		{
	 	 hdf_rot(hb_dout_ram[119:112]),
		 hdf_rot(hb_dout_ram[127:120]),
	 	 hdf_rot(hb_dout_ram[103:96]),
	 	 hdf_rot(hb_dout_ram[111:104]),
	 	 hdf_rot(hb_dout_ram[87:80]),
	 	 hdf_rot(hb_dout_ram[95:88]),
	 	 hdf_rot(hb_dout_ram[71:64]),
	 	 hdf_rot(hb_dout_ram[79:72])
		 };
	3'b100: hb_dout_ramc[127:64] = 
		{
	 	 hb_dout_ram[111:104],
	 	 hb_dout_ram[103:96],
		 hb_dout_ram[127:120],
	 	 hb_dout_ram[119:112],
	 	 hb_dout_ram[79:72],
	 	 hb_dout_ram[71:64],
	 	 hb_dout_ram[95:88],
	 	 hb_dout_ram[87:80]
		 };
	3'b101: hb_dout_ramc[127:64] = 
		{
	 	 hdf_rot(hb_dout_ram[111:104]),
	 	 hdf_rot(hb_dout_ram[103:96]),
		 hdf_rot(hb_dout_ram[127:120]),
	 	 hdf_rot(hb_dout_ram[119:112]),
	 	 hdf_rot(hb_dout_ram[79:72]),
	 	 hdf_rot(hb_dout_ram[71:64]),
	 	 hdf_rot(hb_dout_ram[95:88]),
	 	 hdf_rot(hb_dout_ram[87:80])
		 };
	3'b110: hb_dout_ramc[127:64] = 
		{
	 	 hb_dout_ram[103:96],
	 	 hb_dout_ram[111:104],
	 	 hb_dout_ram[119:112],
		 hb_dout_ram[127:120],
	 	 hb_dout_ram[71:64],
	 	 hb_dout_ram[79:72],
	 	 hb_dout_ram[87:80],
	 	 hb_dout_ram[95:88]
		 };
	3'b111: hb_dout_ramc[127:64] = 
		{
	 	 hdf_rot(hb_dout_ram[103:96]),
	 	 hdf_rot(hb_dout_ram[111:104]),
	 	 hdf_rot(hb_dout_ram[119:112]),
		 hdf_rot(hb_dout_ram[127:120]),
	 	 hdf_rot(hb_dout_ram[71:64]),
	 	 hdf_rot(hb_dout_ram[79:72]),
	 	 hdf_rot(hb_dout_ram[87:80]),
	 	 hdf_rot(hb_dout_ram[95:88])
		 };
	 endcase
       end
      
       if (BYTES == 16 || BYTES == 8) begin
    	case(u_core.U_DE.hdf_1)
	3'b000: hb_dout_ramc[63:32] = hb_dout_ram[63:32];
	3'b001: hb_dout_ramc[63:32] = 
		{
	 	 hdf_rot(hb_dout_ram[63:56]),
	 	 hdf_rot(hb_dout_ram[55:48]),
	 	 hdf_rot(hb_dout_ram[47:40]),
	 	 hdf_rot(hb_dout_ram[39:32])
		 };
	3'b010: hb_dout_ramc[63:32] = 
		{
	 	 hb_dout_ram[55:48],
	 	 hb_dout_ram[63:56],
	 	 hb_dout_ram[39:32],
	 	 hb_dout_ram[47:40]
		 };
	3'b011: hb_dout_ramc[63:32] = 
		{
	 	 hdf_rot(hb_dout_ram[55:48]),
	 	 hdf_rot(hb_dout_ram[63:56]),
	 	 hdf_rot(hb_dout_ram[39:32]),
	 	 hdf_rot(hb_dout_ram[47:40])
		 };
	3'b100: hb_dout_ramc[63:32] = 
		{
	 	 hb_dout_ram[47:40],
	 	 hb_dout_ram[39:32],
	 	 hb_dout_ram[63:56],
	 	 hb_dout_ram[55:48]
		 };
	3'b101: hb_dout_ramc[63:32] = 
		{
	 	 hdf_rot(hb_dout_ram[47:40]),
	 	 hdf_rot(hb_dout_ram[39:32]),
	 	 hdf_rot(hb_dout_ram[63:56]),
	 	 hdf_rot(hb_dout_ram[55:48])
		 };
	3'b110: hb_dout_ramc[63:32] = 
		{
	 	 hb_dout_ram[39:32],
	 	 hb_dout_ram[47:40],
	 	 hb_dout_ram[55:48],
	 	 hb_dout_ram[63:56]
		 };
	3'b111: hb_dout_ramc[63:32] = 
		{
	 	 hdf_rot(hb_dout_ram[39:32]),
	 	 hdf_rot(hb_dout_ram[47:40]),
	 	 hdf_rot(hb_dout_ram[55:48]),
	 	 hdf_rot(hb_dout_ram[63:56])
		 };
	 endcase
       end
    	case(u_core.U_DE.hdf_1)
	3'b000: hb_dout_ramc[31:0] = hb_dout_ram[31:0];
	3'b001: hb_dout_ramc[31:0] = 
		{
       		hdf_rot(hb_dout_ram[31:24]),
       		hdf_rot(hb_dout_ram[23:16]),
       		hdf_rot(hb_dout_ram[15:8]),
       		hdf_rot(hb_dout_ram[7:0])
		};
	3'b010: hb_dout_ramc[31:0] = 
		{
       		hb_dout_ram[23:16],
       		hb_dout_ram[31:24],
       		hb_dout_ram[7:0],
       		hb_dout_ram[15:8]
		};
	3'b011: hb_dout_ramc[31:0] = 
		{
       		hdf_rot(hb_dout_ram[23:16]),
       		hdf_rot(hb_dout_ram[31:24]),
       		hdf_rot(hb_dout_ram[7:0]),
       		hdf_rot(hb_dout_ram[15:8])
		};
	3'b100: hb_dout_ramc[31:0] = 
		{
       		hb_dout_ram[15:8],
       		hb_dout_ram[7:0],
       		hb_dout_ram[31:24],
       		hb_dout_ram[23:16]
		};
	3'b101: hb_dout_ramc[31:0] = 
		{
       		hdf_rot(hb_dout_ram[15:8]),
       		hdf_rot(hb_dout_ram[7:0]),
       		hdf_rot(hb_dout_ram[31:24]),
       		hdf_rot(hb_dout_ram[23:16])
		};
	3'b110: hb_dout_ramc[31:0] = 
		{
       		hb_dout_ram[7:0],
       		hb_dout_ram[15:8],
       		hb_dout_ram[23:16],
       		hb_dout_ram[31:24]
		};
	3'b111: hb_dout_ramc[31:0] = 
		{
       		hdf_rot(hb_dout_ram[7:0]),
       		hdf_rot(hb_dout_ram[15:8]),
       		hdf_rot(hb_dout_ram[23:16]),
       		hdf_rot(hb_dout_ram[31:24])
		};
	endcase
end

  // DE cache RAMs
//  ram_32x32_dp_be u_ram0[`BYTES/4-1:0]
  dual_port_sim u_ram0[BYTES/4-1:0]
    (
     .clock_a           (pclk),
     .data_a            (pwcdata),
     .wren_a            (ca_enable),      
     .address_a         (hb_ram_addr),
     .clock_b           (mclock),
     .data_b            (mc_read_data),
     .address_b         (ca_ram_addr0),
     .wren_b            (de_push),
     
     .q_a               (hb_dout_ram),
     .q_b               (ca_dout0)
     );
  
//  ram_32x32_dp_be u_ram4[`BYTES/4-1:0]
  dual_port_sim u_ram4[BYTES/4-1:0]
    (
     .clock_a           (pclk),
     .data_a            (pwcdata),
     .wren_a            (ca_enable),      
     .address_a         (hb_ram_addr),
     .clock_b           (mclock),
     .data_b            (mc_read_data),
     .address_b         (ca_ram_addr1),
     .wren_b            (de_push),
     
     .q_a               (),
     .q_b               (ca_dout1)
     );
  
  ddr3_int_full_mem_model VR 
    (
     // inputs:
     .mem_addr          (mem_addr),
     .mem_ba            (mem_ba),
     .mem_cas_n         (mem_cas_n),
     .mem_cke           (mem_cke),
     .mem_clk           (mem_clk),
     .mem_clk_n         (mem_clk_n),
     .mem_cs_n          (mem_cs_n),
     .mem_dm            (mem_dm),
     .mem_odt           (mem_odt),
     .mem_ras_n         (mem_ras_n),
     .mem_rst_n         (mem_rst_n),
     .mem_we_n          (mem_we_n),
     
     // outputs:
     .global_reset_n    (),
     .mem_dq            (mem_dq),
     .mem_dqs           (mem_dqs),
     .mem_dqs_n         (mem_dqsn)
     );
    
  // CREATE CLOCKS.                   
  always begin
    #5 pclk = 0;
    #5 pclk = 1;
  end

  always begin
    #3 de_clk=0;
    #3 de_clk=1;
  end

  always begin
    #20 pll_ref_clk=0;
    #20 pll_ref_clk=1;
  end

  task pci_burst_data;
    input [31:0] address;
    input [3:0]  byte_enables;
    input [31:0] data;
    begin
      
      // All APB Cycles are at least two cycles long.
      if ((address[31:9] == rbase_a[31:9]) && (address[8:2] == 7'h04)) begin
        xyw_a_dout[31:12] <= data[31:12];
      end else if (address[31:9] == rbase_a[31:9]) begin
        // Drawing engine register accesses
        psel            = 1'b1;
        pwrite          = 1'b1;
        penable         = 1'b0;
        paddr           = address[31:2];
        pwdata          = data;
        @(posedge pclk);
        #1;
        penable         = 1'b1;
        #1;
        while(pslverr | ~pready) begin
          @(posedge pclk);
          #1;
          psel    = 1'b1;
        end
        @(posedge pclk);
        #1;
        psel            = 1'b0;
        pwrite          = 1'b0;
        penable         = 1'b0;
      end else if (address[31:12] == xyw_a_dout) begin // if (address[31:9] == rbase_a[31:9])
        // Drawing engine cache access
        psel            = 1'b1;
        pwrite          = 1'b1;
        penable         = 1'b0;
        paddr           = address[31:2];
        pwdata          = data;
        @(posedge pclk);
        #1;
        penable         = 1'b1;
        @(posedge pclk);
        #1;
        psel            = 1'b0;
        pwrite          = 1'b0;
        penable         = 1'b0;
      end else if (address[31:8] == rbase_w[31:8]) begin // if (address[31:9] == rbase_a[31:9])
        case (address[7:2])
          // MW0_CTRL register (addr= {RBASE_W,x0000}) 
          //6'h00: begin
            //if (!byte_enables[0]) mw0_ctrl_dout_0     <= data[7:0];
            //if (!byte_enables[2]) mw0_ctrl_dout_2     <= data[23:16];
            //if (!byte_enables[3]) mw0_ctrl_dout_3     <= data[31:24];
          //end
          // MW0_AD register (addr= {RBASE_W,x0004})
          6'h01: begin
            if (!byte_enables[1]) mw0_ad_dout[15:12]  <= data[15:12];
            if (!byte_enables[2]) mw0_ad_dout[23:16]  <= data[23:16];
            if (!byte_enables[3]) mw0_ad_dout[31:24]  <= data[31:24];
          end
          // MW0_SZ register (addr= {RBASE_W,x0008})
          6'h02: begin
            if (!byte_enables[0]) mw0_sz_dout         <= data[3:0];
          end //
          // MW0_ORG register (addr= {RBASE_W,x0010 OR RBASE_W,x0014})
          6'h04: begin
            if (!byte_enables[1]) mw0_org_dout[15:12] <= data[15:12];
            if (!byte_enables[2]) mw0_org_dout[23:16] <= data[23:16];
            if (!byte_enables[3]) mw0_org_dout[26:24] <= data[26:24];
          end
          // MW1_CTRL register (addr= {RBASE_W,x0028}) 
          //6'h0a: begin
            //if (!byte_enables[0]) mw1_ctrl_dout_0     <= data[7:0];
            //if (!byte_enables[2]) mw1_ctrl_dout_2     <= data[23:16];
            //if (!byte_enables[3]) mw1_ctrl_dout_3     <= data[31:24];
          //end
          // MW1_AD register (addr= {RBASE_W,x002C})
          6'h0b: begin
            if (!byte_enables[1]) mw1_ad_dout[15:12]  <= data[15:12];
            if (!byte_enables[2]) mw1_ad_dout[23:16]  <= data[23:16];
            if (!byte_enables[3]) mw1_ad_dout[31:24]  <= data[31:24];
          end
          // MW1_SZ register (addr= {RBASE_W,x0030})
          6'h0c: begin
            if (!byte_enables[0]) mw1_sz_dout         <= data[3:0];
          end //
          // MW1_ORG register (addr= {RBASE_W,x0010 OR RBASE_W,x003C})
          6'h0e: begin
            if (!byte_enables[1]) mw1_org_dout[15:12] <= data[15:12];
            if (!byte_enables[2]) mw1_org_dout[23:16] <= data[23:16];
            if (!byte_enables[3]) mw1_org_dout[26:24] <= data[26:24];
          end
        endcase // case(hbi_addr_in[7:2])

        case (mw0_sz_dout)
          4'h0: mw0_mask = 15'b000000000000000; //   4K
          4'h1: mw0_mask = 15'b000000000000001; //   8K
          4'h2: mw0_mask = 15'b000000000000011; //  16K
          4'h3: mw0_mask = 15'b000000000000111; //  32K
          4'h4: mw0_mask = 15'b000000000001111; //  64K
          4'h5: mw0_mask = 15'b000000000011111; // 128K
          4'h6: mw0_mask = 15'b000000000111111; // 256K
          4'h7: mw0_mask = 15'b000000001111111; // 512K
          4'h8: mw0_mask = 15'b000000011111111; //   1M
          4'h9: mw0_mask = 15'b000000111111111; //   2M
          4'ha: mw0_mask = 15'b000001111111111; //   4M
          4'hb: mw0_mask = 15'b000011111111111; //   8M
          4'hc: mw0_mask = 15'b000111111111111; //  16M
          4'hd: mw0_mask = 15'b001111111111111; //  32M
          4'he: mw0_mask = 15'b011111111111111; //  64M
          4'hf: mw0_mask = 15'b111111111111111; //  128M
        endcase // case (mw0_sz_dout)

        case (mw1_sz_dout)
          4'h0: mw1_mask = 15'b000000000000000; //   4K
          4'h1: mw1_mask = 15'b000000000000001; //   8K
          4'h2: mw1_mask = 15'b000000000000011; //  16K
          4'h3: mw1_mask = 15'b000000000000111; //  32K
          4'h4: mw1_mask = 15'b000000000001111; //  64K
          4'h5: mw1_mask = 15'b000000000011111; // 128K
          4'h6: mw1_mask = 15'b000000000111111; // 256K
          4'h7: mw1_mask = 15'b000000001111111; // 512K
          4'h8: mw1_mask = 15'b000000011111111; //   1M
          4'h9: mw1_mask = 15'b000000111111111; //   2M
          4'ha: mw1_mask = 15'b000001111111111; //   4M
          4'hb: mw1_mask = 15'b000011111111111; //   8M
          4'hc: mw1_mask = 15'b000111111111111; //  16M
          4'hd: mw1_mask = 15'b001111111111111; //  32M
          4'he: mw1_mask = 15'b011111111111111; //  64M
          4'hf: mw1_mask = 15'b111111111111111; //  128M
        endcase // case (mw1_sz_dout)

        @(posedge pclk);
        
      end else if ((address[31:12] ~^ mw0_ad_dout[31:12] | 
                    {7'h0,mw0_mask})==22'h3fffff) begin
        // Direct memory access
	$display("Write %h to %h ", data, mem_address);
        mem_address = mw0_org_dout + {(address[26:12] & mw0_mask), address[11:0]};
	if (BYTES == 4) begin
          old_mem = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>2];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][31:24] = byte_enables[3] ? old_mem[31:24] :
						  data[31:24];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][23:16] = byte_enables[2] ? old_mem[23:16] :
						  data[23:16];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][15:8]  = byte_enables[1] ? old_mem[15:8] :
						  data[15:8];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][7:0]   = byte_enables[0] ? old_mem[7:0] :
						  data[7:0];
	end else if (BYTES == 8) begin // if (BYTES == 4)
	  if (mem_address[2]) begin
            if (~byte_enables[3]) 
	      VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][63:56] = data[31:24];
            if (~byte_enables[2]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][55:48] = data[23:16];
            if (~byte_enables[1]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][47:40] = data[15:8];
            if (~byte_enables[0]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][39:32] = data[7:0];
	  end else begin
            if (~byte_enables[3]) 
	      VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][31:24] = data[31:24];
            if (~byte_enables[2]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][23:16] = data[23:16];
            if (~byte_enables[1]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][15:8]  = data[15:8];
            if (~byte_enables[0]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][7:0]   = data[7:0];
	  end
	end else begin
          old_mem = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>4];
	  case (mem_address[3:2]) 
	    2'h0: begin
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][31:24] = byte_enables[3] ? old_mem[31:24] :
						      data[31:24];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][23:16] = byte_enables[2] ? old_mem[23:16] :
						      data[23:16];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][15:8]  = byte_enables[1] ? old_mem[15:8] :
						      data[15:8];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][7:0]   = byte_enables[0] ? old_mem[7:0] :
						      data[7:0];
	    end // case: begin...
	    2'h1: begin
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][63:56] = byte_enables[3] ? old_mem[31:24] :
						      data[31:24];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][55:48] = byte_enables[2] ? old_mem[23:16] :
						      data[23:16];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][47:40] = byte_enables[1] ? old_mem[15:8] :
						      data[15:8];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][39:32] = byte_enables[0] ? old_mem[7:0] :
						      data[7:0];
	    end // case: begin...
	    2'h2: begin
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][95:88] = byte_enables[3] ? old_mem[31:24] :
						      data[31:24];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][87:80] = byte_enables[2] ? old_mem[23:16] :
						      data[23:16];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][79:72] = byte_enables[1] ? old_mem[15:8] :
						      data[15:8];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][71:64] = byte_enables[0] ? old_mem[7:0] :
						      data[7:0];
	    end // case: begin...
	    2'h3: begin
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][127:120] = byte_enables[3] ? old_mem[31:24] :
							data[31:24];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][119:112] = byte_enables[2] ? old_mem[23:16] :
							data[23:16];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][111:104] = byte_enables[1] ? old_mem[15:8] :
							data[15:8];
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][103:96]  = byte_enables[0] ? old_mem[7:0] :
							data[7:0];
	    end // case: begin...
	  endcase // case (mem_address[3:2])
	end
        $display("MW0 Access to %h", mem_address);
        @(posedge pclk);

      end else if ((address[31:12] ~^ mw1_ad_dout[31:12] | 
                    {7'h0,mw1_mask})==22'h3fffff) begin
        // Direct memory access
        mem_address = mw1_org_dout + {(address[26:12] & mw1_mask), address[11:0]};
	$display("Write %h to %h ", data, mem_address);

	if (BYTES == 4) begin
          old_mem = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>2];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][31:24] = byte_enables[3] ? old_mem[31:24] :
						  data[31:24];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][23:16] = byte_enables[2] ? old_mem[23:16] :
						  data[23:16];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][15:8]  = byte_enables[1] ? old_mem[15:8] :
						  data[15:8];
          VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:2]][7:0]   = byte_enables[0] ? old_mem[7:0] :
						  data[7:0];
	end else if (BYTES == 8) begin // if (BYTES == 4)
	  if (mem_address[2]) begin
            if (~byte_enables[3]) 
	      VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][63:56] = data[31:24];
            if (~byte_enables[2]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][55:48] = data[23:16];
            if (~byte_enables[1]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][47:40] = data[15:8];
            if (~byte_enables[0]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][39:32] = data[7:0];
	  end else begin
            if (~byte_enables[3]) 
	      VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][31:24] = data[31:24];
            if (~byte_enables[2]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][23:16] = data[23:16];
            if (~byte_enables[1]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][15:8]  = data[15:8];
            if (~byte_enables[0]) 
              VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:3]][7:0]   = data[7:0];
	  end
	end else begin
          old_mem = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>4];
	  case (mem_address[3:2])
	    2'h0: begin
              if (~byte_enables[3]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][31:24] = data[31:24];
              if (~byte_enables[2]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][23:16] = data[23:16];
              if (~byte_enables[1]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][15:8]  = data[15:8];
              if (~byte_enables[0]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][7:0]   = data[7:0];
	    end // case: begin...
	    2'h1: begin
              if (~byte_enables[3]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][63:56] = data[31:24];
              if (~byte_enables[2]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][55:48] = data[23:16];
              if (~byte_enables[1]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][47:40] = data[15:8];
              if (~byte_enables[0]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][39:32] = data[7:0];
	    end // case: begin...
	    2'h2: begin
              if (~byte_enables[3]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][95:88] = data[31:24];
              if (~byte_enables[2]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][87:80] = data[23:16];
              if (~byte_enables[1]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][79:72] = data[15:8];
              if (~byte_enables[0]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][71:64] = data[7:0];
	    end // case: begin...
	    2'h3: begin
              if (~byte_enables[3]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][127:120] = data[31:24];
              if (~byte_enables[2]) 
		VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][119:112] = data[23:16];
              if (~byte_enables[1]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][111:104] = data[15:8];
              if (~byte_enables[0]) 
                VR.ddr3_int_full_mem_model_ram.mem_array[mem_address[31:4]][103:96]  = data[7:0];
	    end // case: begin...
	  endcase // case (mem_address[3:2])
	end

        $display("MW1 Access to %h", mem_address);
        @(posedge pclk);

      end else // if ((address[31:12] ~^ mw1_ad_dout[31:12] |...
        @(posedge pclk);
    end
    
  endtask // pci_burst_data
  
  task mov_dw;
    
    input [3:0]  host_cycle_type;
    input [31:0] address;
    input [31:0] data;
    input [3:0]  byte_enables;
    input [29:0] NO_OF_BEATS; 

    begin

      if (host_cycle_type == MEM_WR ||
          host_cycle_type == CONFIG_WR ||
          host_cycle_type == IO_WR)
        pci_burst_data(address, byte_enables, data);
    end
  endtask // mov_dw
  
  task mov_burst;
    
    input [3:0]  host_cycle_type;
    input [31:0] address;
    input [3:0]  byte_enables;
    input [3:0]  NO_OF_BEATS;
    input [31:0] data1;
    input [31:0] data2;
    input [31:0] data3;
    input [31:0] data4;
    input [31:0] data5;
    input [31:0] data6;
    input [31:0] data7;
    input [31:0] data8;

    begin
      if (NO_OF_BEATS >= 1) pci_burst_data(address,      byte_enables, data1);
      if (NO_OF_BEATS >= 2) pci_burst_data(address + 4,  byte_enables, data2);
      if (NO_OF_BEATS >= 3) pci_burst_data(address + 8,  byte_enables, data3);
      if (NO_OF_BEATS >= 4) pci_burst_data(address + 12, byte_enables, data4);
      if (NO_OF_BEATS >= 5) pci_burst_data(address + 16, byte_enables, data5);
      if (NO_OF_BEATS >= 6) pci_burst_data(address + 20, byte_enables, data6);
      if (NO_OF_BEATS >= 7) pci_burst_data(address + 24, byte_enables, data7);
      if (NO_OF_BEATS == 8) pci_burst_data(address + 28, byte_enables, data8);
    end
  endtask // mov_burst
  
  task rd;
    
    input [3:0]  host_cycle_type;
    input [31:0] address;
    input [29:0] count; //number of beats in one burst cycle (max= 1G beats)
    
    integer int_count, int_address;

    begin
      
      int_count  = count; // Load a local copy of the counter
      int_address= address;
      psel       = 1'b0;
      
      while (int_count != 0) begin
        if (int_address[31:9] == rbase_a[31:9]) begin
          psel            = 1'b1;
          pwrite          = 1'b0;
          penable         = 1'b0;
          paddr           = address[31:2];
          @(posedge pclk);
          #1;
          penable         = 1'b1;
          @(posedge pclk);
          test_reg        = prdata;
          #1;
          psel            = 1'b0;
          penable         = 1'b0;
      end else if (address[31:12] == xyw_a_dout) begin
          psel            = 1'b1;
          pwrite          = 1'b0;
          penable         = 1'b0;
          paddr           = address[31:2];
          @(posedge pclk);
          #1;
          penable         = 1'b1;
          @(posedge pclk);
          @(posedge pclk);
          test_reg        = prdata;
          #1;
          psel            = 1'b0;
          penable         = 1'b0;
        end else if (int_address[31:8] == rbase_g[31:8]) begin
        end else if (int_address[31:8] == rbase_i[31:8]) begin
        end else if ((address[31:12] ~^ mw0_ad_dout[31:12] | 
                      {7'h0,mw0_mask})==22'h3fffff) begin
          // Direct memory access
	  mem_address = mw0_org_dout + (address[31:12] - mw0_ad_dout[31:12]);
	  
	  if (BYTES == 4)
            test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>2];
	  else if (BYTES == 8)
	    case (mem_address[2])
	      1'b0: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][31:0];
	      1'b1: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][63:32];
	    endcase
	  else
	    case (mem_address[2])
	      2'h0: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][31:0];
	      2'h1: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][63:32];
	      2'h2: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][95:64];
	      2'h3: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][127:96];
	    endcase
        end else if ((address[31:12] ~^ mw1_ad_dout[31:12] | 
                      {7'h0,mw1_mask})==22'h3fffff) begin
          // Direct memory access
	  mem_address = mw1_org_dout + (address[31:12] - mw1_ad_dout[31:12]);
	  
	  if (BYTES == 4)
            test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>2];
	  else if (BYTES == 8)
	    case (mem_address[2])
	      1'b0: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][31:0];
	      1'b1: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][63:32];
	    endcase
	  else
	    case (mem_address[2])
	      2'h0: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][31:0];
	      2'h1: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][63:32];
	      2'h2: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][95:64];
	      2'h3: test_reg = VR.ddr3_int_full_mem_model_ram.mem_array[mem_address>>3][127:96];
	    endcase
        end
        int_address = int_address + 4;
        int_count = int_count - 1;
      end // while (int_count != 0)
    end
  endtask // rd
       
task cpu_mov_dw;

input[3:0] Access;
input[31:0] Address;
input[31:0] Data;

reg[31:0] shift_back, shift_forward;
reg[31:0] Address1, Address2;
reg[31:0] Data1, Data2;
reg[3:0] Mask1, Mask2;
reg[3:0] Strobe1, Strobe2;
reg[3:0] StandardMask ;
reg[3:0] Strobe;

begin

StandardMask = 4'b1111;
shift_back = (Address & 32'h0000_0003);
if (shift_back > 0)
   begin 
   shift_forward = 4 - shift_back;
   Address1 = Address - shift_back; 
   Data1 = Data << (shift_back * 8);
   Mask1 = StandardMask << shift_back;
   Strobe1 = ~Mask1;

   Address2 = Address + shift_forward; 
   Data2 = Data >> (shift_forward * 8);
   Mask2 = StandardMask >> shift_forward;
   Strobe2 = ~Mask2;

   mov_dw(Access, Address1, Data1, Strobe1, 1);
   mov_dw(Access, Address2, Data2, Strobe2, 1);
   end 
else  /* There is no need to shift data.  */

  begin 
   Strobe = ~StandardMask;
   mov_dw(Access, Address, Data, Strobe, 1);
   end 
end
endtask // cpu_mov_dw


task cpu_mov_w;

   input[3:0] Access;
   input[31:0] Address;
   input[15:0] Data;

   reg[31:0] shift_back;
   reg[31:0] Data2;
   reg[3:0] StandardMask ;
   reg[3:0] Strobe;

   begin

      StandardMask = 4'b0011;
      shift_back = (Address & 32'h0000_0003);
      if (shift_back > 2)
         begin 
            mov_dw(Access, Address - 3, Data << 24, 4'b1000, 1);
            mov_dw(Access, Address + 1, Data,       4'b0001, 1);
         end 
      else /* Shift the data in the word */
         begin 
            Strobe = ~(StandardMask << shift_back);
            Data2 = Data << (shift_back << 3);
            mov_dw(Access, Address - shift_back, Data2, Strobe, 1);
         end 
   end
endtask // cpu_mov_w



task cpu_mov_b;

input[3:0] Access;
input[31:0] Address;
input[7:0] Data;

reg[31:0] shift_back, shift_forward;
reg[31:0] NewAddress;
reg[31:0] LongData;
reg[3:0] Mask;
reg[3:0] StandardMask;
reg[3:0] Strobe;
reg[31:0] Long_tmp;
reg[31:0] test_tmp;

begin

LongData = Data;
StandardMask = 4'b0001;
shift_back = (Address & 32'h0000_0003);
if (shift_back > 0)
   begin 
   shift_forward = 4 - shift_back;
   NewAddress = Address - shift_back; 
   LongData = LongData << (shift_back * 8);
   Mask = StandardMask << shift_back;
   Strobe = ~Mask;

   rd(MEM_RD, NewAddress,1);
   test_tmp = {test_reg[31:24] & {8{Strobe[3]}},
	       test_reg[23:16] & {8{Strobe[2]}},
	       test_reg[15:8]  & {8{Strobe[1]}},
	       test_reg[7:0]   & {8{Strobe[0]}}};
   Long_tmp = {LongData[31:24] & {8{~Strobe[3]}},
	       LongData[23:16] & {8{~Strobe[2]}},
	       LongData[15:8]  & {8{~Strobe[1]}},
	       LongData[7:0]   & {8{~Strobe[0]}}};
   mov_dw(Access, NewAddress, (Long_tmp | test_tmp), Strobe, 1);

   end 
else  /* There is no need to shift data.  */
  begin 
   NewAddress = Address; 
   Strobe = ~StandardMask;
   rd(MEM_RD, NewAddress,1);
   test_tmp = {test_reg[31:24] & {8{Strobe[3]}},
	       test_reg[23:16] & {8{Strobe[2]}},
	       test_reg[15:8]  & {8{Strobe[1]}},
	       test_reg[7:0]   & {8{Strobe[0]}}};
   Long_tmp = {LongData[31:24] & {8{~Strobe[3]}},
	       LongData[23:16] & {8{~Strobe[2]}},
	       LongData[15:8]  & {8{~Strobe[1]}},
	       LongData[7:0]   & {8{~Strobe[0]}}};
   mov_dw(Access, NewAddress, (Long_tmp | test_tmp), Strobe, 1);

   end 
end
endtask // cpu_mov_b

task Verify;
 input [31:0] address;
 input [7:0]  size;
 input [31:0] data;

 begin
  $display("VERIFY ADDRESS  %h Size %h", address, size);
  $display("VERIFY EXPECTED %h", data);
  rd(MEM_RD, address, 1);
  $display("VERIFY DATA     %h", test_reg);
 end
endtask


task Verify_Io;
 input [31:0] address;
 input [7:0]  size;
 input [31:0] data;

 integer long_addr;
 integer byte_enables;

 begin
  long_addr = address & 32'hFFFFFFFC;
  byte_enables = (1 << size) - 1;
  byte_enables = byte_enables << (address & 3);
  $display("VERIFY ADDRESS  %h Size %h", address, size);
  $display("VERIFY EXPECTED %h", data);
  rd_byte(IO_RD, address, ~byte_enables, 1);
 
  data = (test_reg >> (address & 3)) & ((1 << size) - 1);
  $display("VERIFY DATA     %h", data);
 end
endtask
   
  task initialize;
    begin
      @(posedge pclk);
      bb_rstn = 0;
      
      rbase_io = 32'h9000;
      config_en = 1'b1;
      repeat (12) @(posedge pclk);
      config_en = 1'b0;
      repeat (12) @(posedge pclk);
      bb_rstn = 1;     

      // Enable all address decoding
      load_base("G",32'h100);
      load_base("W",32'h200);
      load_base("A",32'h800);
      load_base("B",32'h400);
      load_base("I",32'h500);
      load_base("E",32'h600);

    end
  endtask // initialize

  /***************************************************************************/
  /* TASK TO LOAD THE BASE ADDRESSES.                                        */
  /***************************************************************************/
  task load_base;
    input       [7:0]   reg_string;
    input       [31:0]  reg_address;
    begin

      if(reg_string=="G") rbase_g = {reg_address[31:8],8'h0};
      if(reg_string=="W") rbase_w = {reg_address[31:8],8'h0};
      if(reg_string=="A") rbase_a = {reg_address[31:8],8'h0};
      if(reg_string=="B") rbase_b = {reg_address[31:8],8'h0};
      if(reg_string=="I") rbase_i = {reg_address[31:8],8'h0};
      if(reg_string=="E") rbase_e = {reg_address[31:8],8'h0};
    end
  endtask

  /**************************************************************************/
  task redhat_wait;
    begin
        rd(MEM_RD, rbase_a+FLOW,1);
        while (test_reg[3] || test_reg[1] || test_reg[0]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /**************************************************************************/
  task wait_for_pipe_a;
    begin
      @(posedge pclk);
        rd(MEM_RD, rbase_a+BUSY,1);
        while (test_reg[0]) rd(MEM_RD, rbase_a+BUSY,1);
    end
  endtask
  /**************************************************************************/
  task wait_for_de_a;
    begin
      @(posedge pclk);
         rd(MEM_RD, rbase_a+FLOW,1);
         while (test_reg[0]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /**************************************************************************/
  task wait_for_mc_a;
    begin
      @(posedge pclk);
         rd(MEM_RD, rbase_a+FLOW,1);
         while (test_reg[1]) rd(MEM_RD, rbase_a+FLOW,1);
         repeat (6000) @(posedge pclk);
    end
  endtask
  /**************************************************************************/
  task wait_for_prev_a;
    begin
      @(posedge pclk);
          rd(MEM_RD, rbase_a+FLOW,1);
          while (test_reg[3]) rd(MEM_RD, rbase_a+FLOW,1);
    end
  endtask
  /**************************************************************************/
  task wait_for_crdy_a;
    begin
      @(posedge pclk);
          rd(MEM_RD, rbase_a+BUF_CTRL,1);
          while (test_reg[31]) rd(MEM_RD, rbase_a+BUF_CTRL,1);
    end
  endtask
  task wait_for_dlp;
    begin
      @(posedge pclk);
          rd(MEM_RD, rbase_a+32'hFC,1);
          while (~test_reg[31]) rd(MEM_RD, rbase_a+32'hFC,1);
    end
  endtask
/*
  task wait_for_eq;
    input       [31:0]  address;
    input       [4:0]   bit_select;
    input               value;
    
    begin
      rd(MEM_RD, address,1);
      while ((test_reg[bit_select]) != value) rd(MEM_RD, address,1);
    end
  endtask
  */
  /* Empty tasks to not break tests */
  task wait_for_mw0;
    begin
      @(posedge pclk);
    end
  endtask

  task wait_for_mw1;
    begin
      @(posedge pclk);
    end
  endtask

  // Main task
  initial begin
    mw0_org_dout = 32'b0;
    mw1_org_dout = 32'b0;
    vb_int_tog = 1'b0;
    paddr = 30'h0;
    pwdata = 0;    
    pwrite = 1'b0; 
    psel = 1'b0;
    penable = 1'b0;

    initialize;
 
    //set up the memory window addresses
    pci_burst_data(rbase_a + XYC_AD, 4'h0, 32'h1000_0000); // 4 KBytes
 
    mov_dw(MEM_WR, rbase_w + MW0_AD, 32'h4000_0000, 4'h0, 1);
    mov_dw(MEM_WR, rbase_w + MW0_SZ, 32'h0000_000A, 4'h0, 1); // 4 MBytes
    mov_dw(MEM_WR, rbase_w + MW1_AD, 32'hA000_0000, 4'h0, 1);
    mov_dw(MEM_WR, rbase_w + MW1_SZ, 32'h0000_000A, 4'h0, 1); // 4 MBytes
 

    /* clear interrupt register. */
    pci_burst_data(rbase_a+INTP, 4'h0, 32'h0000_0000);
 
    /* clear interrupt mask register. */
    pci_burst_data(rbase_a+INTM, 4'h0, 32'h0000_0000);
 
    /* set the buffer control register. */
    pci_burst_data(rbase_a+BUF_CTRL, 4'h0, 32'h0000_0000);
 
    /* set the buffer control register. */
    pci_burst_data(rbase_a+XYW_AD, 4'h0, 32'h1000_0000);
 
    /* Set the Drawing engine source origins equals zero. */
    pci_burst_data(rbase_a+DE_SORG,4'h0,32'h0000_0000);
    pci_burst_data(rbase_a+DE_DORG,4'h0,32'h0000_0000);
 
    /* Drawing engine KEY equals zero. */
    pci_burst_data(rbase_a+DE_KEY,4'h0,32'h0000_0000);
 
    /* Set the Drawing engine pitches  = 40h (64x16bytes=1024). */
    pci_burst_data(rbase_a+DE_SPTCH,4'h0,32'h0000_0400);
    pci_burst_data(rbase_a+DE_DPTCH,4'h0,32'h0000_0400);
 
    /* Drawing engine foreground = ffff. */
    pci_burst_data(rbase_a+FORE,4'h0,32'h9999_9999);
 
    /* Drawing engine background = bbbb. */
    pci_burst_data(rbase_a+BACK,4'h0,32'hbbbb_bbbb);
 
    /* Drawing engine plane mask = ffffffff. */
    pci_burst_data(rbase_a+MASK,4'h0,32'hffff_ffff);
 
    /* Drawing engine line pattern register = ffffffff. */
    pci_burst_data(rbase_a+LPAT,4'h0,32'hffff_ffff);
 
    /* Drawing engine line pattern control register = 0. */
    pci_burst_data(rbase_a+PCTRL,4'h0,32'h0000_0000);
 
    /* Drawing engine clipping top left corner (0,0). */
    pci_burst_data(rbase_a+CLPTL,4'h0,32'h0000_0000);
 
    /* Drawing engine clipping bottom right corner (1024,1024). */
    pci_burst_data(rbase_a+CLPBR,4'h0, 32'h03ff_03ff);
    
    pci_burst_data(rbase_a + XYC_AD, 4'h0, 32'h1000_0400); // 4 KBytes

    // Wait for the DDR2 Controller to come up
    wait (u_core.init_done);
    $display("DDR3 Contoller now up.");
   `include "the_test.h"

    $stop;
  end
  
   function [7:0] hdf_rot;
      input [7:0] din;
      
      hdf_rot = {din[0], din[1], din[2], din[3], din[4], din[5], din[6], din[7]};
   endfunction //
   
endmodule
