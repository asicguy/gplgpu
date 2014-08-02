///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2009 - All rights reserved
//
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Conexant Systems, Inc., hereafter the "licensee", as defined by the NDA and the 
//  license agreement. 
//
//  This code may not be used as a basis for new development without a written
//  agreement between Silicon Spectrum and the licensee. 
//
//  New development includes, but is not limited to new designs based on this 
//  code, using this code to aid verification or using this code to test code 
//  developed independently by the licensee.
//
//  This copyright notice must be maintained as written, modifying or removing
//  this copyright header will be considered a breach of the license agreement.
//
//  The licensee may modify the code for the licensed project.
//  Silicon Spectrum does not give up the copyright to the original 
//  file or encumber in any way.
//
//  Use of this file is restricted by the license agreement between the
//  licensee and Silicon Spectrum, Inc.
//  
//  Title       :  2D Cache Top Level
//  File        :  ded_ca_top.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
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

`timescale 1ns / 10ps

  module ded_ca_top
    #(parameter BYTES = 4)
    (
     input           mclock,
     input           mc_push,
     `ifdef BYTE16 input [2:0]     mc_addr,
     `elsif BYTE8  input [3:0]     mc_addr,
     `else         input [4:0]     mc_addr,
     `endif
     
     input           hclock,
     input           hb_we,
     input [4:0]     hb_addr,
     input [(BYTES*8)-1:0] hb_dout_ram,
     
     `ifdef BYTE16 input [2:0]     rad,
     `elsif BYTE8  input [3:0]     rad,
     `else         input [4:0]     rad, `endif
     
     `ifdef BYTE16 output [3:0] ca_enable,
     `elsif BYTE8  output [1:0] ca_enable,
     `else         output       ca_enable,
     `endif
     output     [31:0]          hb_dout,
     output     [4:0]           hb_ram_addr,
     output [4:0]           ca_ram_addr0,
     output [4:0]           ca_ram_addr1
     );
  

`ifdef BYTE16
  wire [2:0]            radp1;
  assign  radp1 = rad + 3'h1;
  assign  hb_dout   = hb_dout_ram[hb_addr[1:0]*32 +: 32];
  assign  ca_enable[0] = hb_we & (hb_addr[1:0] == 2'd0);
  assign  ca_enable[1] = hb_we & (hb_addr[1:0] == 2'd1);
  assign  ca_enable[2] = hb_we & (hb_addr[1:0] == 2'd2);
  assign  ca_enable[3] = hb_we & (hb_addr[1:0] == 2'd3);
  assign  hb_ram_addr = {2'b0, hb_addr[4:2]};
  assign  ca_ram_addr0 = (mc_push) ? {2'b0, mc_addr} : {2'b0, rad};
  assign  ca_ram_addr1 = (mc_push) ? {2'b0, mc_addr} : {2'b0, radp1};
`elsif BYTE8
  wire [3:0]            radp1;
  assign  radp1 = rad + 1;
  assign  hb_dout   = hb_dout_ram[hb_addr[0]*32 +: 32];
  assign  ca_enable[0] = hb_we & (hb_addr[0] == 1'b0);
  assign  ca_enable[1] = hb_we & (hb_addr[0] == 1'b1);
  assign  hb_ram_addr = {1'b0, hb_addr[4:1]};
  assign  ca_ram_addr0 = (mc_push) ? {1'b0, mc_addr} : {1'b0, rad};
  assign  ca_ram_addr1 = (mc_push) ? {1'b0, mc_addr} : {1'b0, radp1};
`else
  wire [4:0]            radp1;
  assign  radp1 = rad + 1;
  assign  hb_dout = hb_dout_ram[31:0];
  assign  ca_enable  = hb_we;
  assign  hb_ram_addr = hb_addr[4:0];
  assign  ca_ram_addr0 = (mc_push) ? mc_addr : rad;
  assign  ca_ram_addr1 = (mc_push) ? mc_addr : radp1;
`endif

endmodule
