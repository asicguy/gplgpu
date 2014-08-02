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
//  module for the hbi address, host bus data and host bus byte enables 
//  latches 
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
`timescale 1ns/10ps

module hbi_addr_data
  (
   input	     hb_clk,             //host bus clock
   input	     sys_reset_n,        //host bus system reset
   input [31:0]	     hb_ad_bus,          //PCI host address-data bus
   input [3:0]       hb_byte_ens,        //PCI host byte enables.
   input	     addr_strobe_n,      //address bus latch enable.
   input	     data_strobe_n,      //data bus latch enable.
   input	     idsel_p,            //initialization device select signal
   input	     perph_data_strobe_n,// signal to latch perph data
   input	     vga_data_strobe_n,  // signal to latch vga data
   input	     cs_dac_space_n,
   input	     cs_eprom_n,
   input [11:9]	     mw0_ctrl_dout,
   input [11:9]	     mw1_ctrl_dout,
   input [2:0]	     cmd_hdf,
   input	     cs_mem0_n,
   input	     cs_mem1_n,
   input	     cs_xyw_a_n,
   input	     hb_cycle_done_n,
   
   
   output reg [31:0] hb_ldata,     //HBI latched data.
   output reg [31:0] hb_laddr,     //HBI latched address.
   output reg [3:0]  hb_lcmd,      //HBI latched bus commands
   output reg	     hb_lidsel,    //latched Initialization device select
   output reg [22:0] vga_laddr,
   output reg [31:0] vga_ldata,
   output reg [3:0]  vga_lbe,
   output reg	     vga_rdwr,
   output reg 	     vga_mem_io,

   output	     perph_lbe_f, // latched perph byte enables = f
   output reg	     perph_rdwr,   
   output reg [7:0]  perph_dout,

   output reg [31:0] hbi_data_in, // data, swizzled or not
   output [3:0]	     hbi_be_in,   // byte enables, swizzled or not
   output [3:0]	     mw_be,       // byte enables, swizzled or not for mem win 
   output [2:0]	     swizzler_ctrl,  // reorder bits or bytes
   output [15:0]     per_origin  // Peripheral Address
   );
 
  reg [20:0]	 perph_laddr; 
  reg [31:0]	 perph_ldata;   
  reg [3:0]	 perph_lbe; 
  reg [3:0]	 perph_lcmd;
  reg [3:0]	 dac_addr; 
  reg [3:0]	 hb_be;
  reg [7:0]	 hb_dat_b3, hb_dat_b2, hb_dat_b1, hb_dat_b0;
  reg		 cs0_sync_n, cs1_sync_n , cs_xyw_a_sync_n; 
  reg [7:0] 	 hb_lbe;
  
  wire [20:0]	 eprom_addr_bus;   
  wire		 hb_write;
  wire [2:0]	 perph_cycle_type;
  wire [7:0]	 perph_data;
  wire [1:0]	 byte_en_decode;
  assign hb_write = hb_lcmd[0]; /* 1 = write, 0 = read */
  
  parameter 
	    IO         = 3'h0, //IO MAPPED
	    MEM        = 3'h1, //MEMORY MAPPED
	    PCI_CONFIG = 3'h2, //PCI_CONFIGURATION
	    CMD_RESVD  = 3'h4; //RESERVED COMMAND DECODE
  
  // HB ADDRESS/COMMAND/IDSEL LATCH
  always @(posedge hb_clk or negedge sys_reset_n) begin
    if (!sys_reset_n) begin   
      hb_laddr  <= 32'b0;
      hb_lcmd   <= 4'h1; /* special cycle, will not repond */
      hb_lidsel <= 1'b0;
    end else if (!addr_strobe_n) begin
      hb_laddr  <= hb_ad_bus[31:0];
      hb_lcmd   <= hb_byte_ens[3:0];
      hb_lidsel <= idsel_p;
    end else if (!hb_cycle_done_n) begin
      hb_laddr  <= hb_laddr;
      hb_lcmd   <= {hb_lcmd[3], 2'b0, hb_lcmd[0]};
      hb_lidsel <= hb_lidsel;
    end //
  end //

  // HB DATA LATCH & HB BYTE ENABLE LATCH
  always @(posedge hb_clk) begin
    if (!data_strobe_n) begin
      hb_ldata <= hb_ad_bus[31:0];
      hb_lbe <= hb_byte_ens; //byte enables
    end
  end

  // ADDRESS & DATA LATCH FOR THE VGA
  always @(posedge hb_clk) begin
    if (!vga_data_strobe_n) begin
      vga_laddr[22:0] <= hb_laddr[22:0];    //latch the adderss
      vga_ldata  <= hb_ad_bus[31:0];        //latch the data
      vga_lbe    <= hb_byte_ens[3:0];       //latch byte enables
      vga_rdwr   <= !hb_lcmd[0];            //(0--> write, 1--> read)
      vga_mem_io <= !(hb_lcmd[3:1]==3'b001);//(0--> IO, 1--> MEM)
    end
  end
 
  // LATCHS FOR THE PERIPHIALS: Not 64 bit safe!!!!!! fixme
  always @(posedge hb_clk) begin
    if (!perph_data_strobe_n) begin
      perph_laddr[20:0] <= hb_laddr[20:0];
      perph_ldata       <= hb_ad_bus[31:0];
      perph_rdwr        <= !hb_lcmd[0];     // (0-->WRITE, 1-->READ
      perph_lbe         <= hb_byte_ens[3:0];     //latch byte enables
      perph_lcmd[3:0]   <= hb_lcmd;         //latch the command
    end
  end

  assign perph_lbe_f = (perph_lbe == 4'hf ? 1'b1 : 1'b0);

  // GENERATE EPROM ADDRESS BUS
  assign eprom_addr_bus =  {perph_laddr[20:2], byte_en_decode[1:0]};
 
  // DECODE BYTE ENABLES TO GENERATE 2 LOW ADDRESS BITS
  assign byte_en_decode =
	 (perph_lbe == 4'b1101)  ?  2'b01: //second byte in 8 bit EPROM wide
	 (perph_lbe == 4'b1011)  ?  2'b10: //third  byte in 8 bit EPROM wide
	 (perph_lbe == 4'b0111)  ?  2'b11: //fourth byte in 8 bit EPROM wide
	 2'b00; //default

  // CYCLE TYPE FOR PERIPHIAL CYCLES
  assign perph_cycle_type =
         (perph_lcmd[3:1]==3'b001) ? IO:         // I/O space in PCI
         (perph_lcmd[3:1]==3'b011  ||
	  perph_lcmd[3:0]==4'b1100 ||
	  perph_lcmd[3:1]==3'b111) ? MEM:        // MEMORY space in PCI
  	 (perph_lcmd[3:1]==3'b101) ? PCI_CONFIG: // PCI_CONFIGURATION
         CMD_RESVD;                         /* RESERVED COMMAND DECODE
					     * & DUAL ADDRESS CYCLE & SPECIAL
					     * CYCLE & INTERRUPT ACKNOWLEDGE
					     * (BLKBIRD WOULDN't RESPOND
                                    	     * TO ANY COMMAND RESERVED CYCLES.
					     */

  // GENERATE THE RAMDAC ADDRESS BITS (3 address bits to address 8 registers)
  always @* begin
    dac_addr =  4'hf;
    if (!cs_dac_space_n) begin
      if (perph_cycle_type==IO) begin
	if (perph_laddr[7:4]==4'hc)  begin//IO 3Cx
	  if (perph_laddr[3:0]==4'h8)
	    dac_addr =  4'h0;
	  else if (perph_laddr[3:0]==4'h9)
	    dac_addr =  4'h1;
	  else if (perph_laddr[3:0]==4'h6)
	    dac_addr =  4'h2;
	  else if (perph_laddr[3:0]==4'h7)
	    dac_addr =  4'h3;
	end else if (perph_laddr[7:6]==2'b10 &&
		     perph_laddr[1:0]==2'b00)
	  dac_addr = perph_laddr[5:2];
      end else if (perph_cycle_type==MEM) begin
	if (perph_laddr[7:5]==3'b000 && perph_laddr[1:0]==2'b00)
	  dac_addr = perph_laddr[5:2];
	else if (perph_laddr[7:4]==4'h7 && perph_laddr[1:0]==2'b00) 
	  // 70,74,78,7c -> 0-3
	  dac_addr = {2'b00,perph_laddr[3:2]};
	else if  (perph_laddr[7:6]==2'b10 && perph_laddr[1:0]==2'b00)
	  dac_addr = (perph_laddr[5:2] + 4'd4);
      end // else: !if(periphial_cycle_type==IO)
    end // if (!cs_dac_space_n)
  end // always @ (cs_dac_space_n or perph_cycle_type or perph_laddr[7:0])
  
  always @(posedge hb_clk) begin
    cs0_sync_n  <= cs_mem0_n;
    cs1_sync_n  <= cs_mem1_n;
    cs_xyw_a_sync_n <= cs_xyw_a_n;
  end
  
  // SHUFFLE THE DAC,EPROM,SW DATA TO THE CORRECT DATA LANE
  assign perph_data[7:0] =
			  (byte_en_decode[1:0]==2'b00) ? perph_ldata[7:0]   :
			  (byte_en_decode[1:0]==2'b01) ? perph_ldata[15:8]  :
			  (byte_en_decode[1:0]==2'b10) ? perph_ldata[23:16] :
                          perph_ldata[31:24] ;

  /*
   * this 2:! mux selects either the "byte steered" perph_wr_data for dac or
   * eprom space OR defaults to byte 0 from the ad_latches for soft switches
   */
  always @ (cs_dac_space_n or cs_eprom_n or perph_ldata or perph_data)
  begin
    if (!cs_dac_space_n || !cs_eprom_n)
      perph_dout[7:0] = perph_data[7:0];
    else
      perph_dout[7:0] = perph_ldata[7:0];
  end
  
  // SWIZZLER CONTROL 
  assign swizzler_ctrl[2:0] = 
			      (!cs0_sync_n)  ? mw0_ctrl_dout[11:9] :
			      (!cs1_sync_n)  ? mw1_ctrl_dout[11:9] :
			      (!cs_xyw_a_sync_n) ? cmd_hdf[2:0] : 3'h0;
  
  // reorder the bits within the bytes
  always @* begin
    if (swizzler_ctrl[0]) begin
      hb_dat_b3 = {hb_ldata[24], hb_ldata[25], hb_ldata[26], hb_ldata[27],
		    hb_ldata[28], hb_ldata[29], hb_ldata[30], hb_ldata[31]};
      
      hb_dat_b2 = {hb_ldata[16], hb_ldata[17], hb_ldata[18], hb_ldata[19],
		    hb_ldata[20], hb_ldata[21], hb_ldata[22], hb_ldata[23]};
      
      hb_dat_b1 = {hb_ldata[8],  hb_ldata[9], hb_ldata[10], hb_ldata[11],
		    hb_ldata[12], hb_ldata[13], hb_ldata[14], hb_ldata[15]};
      
      hb_dat_b0 = {hb_ldata[0], hb_ldata[1], hb_ldata[2], hb_ldata[3],
		    hb_ldata[4], hb_ldata[5], hb_ldata[6], hb_ldata[7]};
    end else begin
      hb_dat_b3 = hb_ldata[31:24];
      hb_dat_b2 = hb_ldata[23:16];
      hb_dat_b1 = hb_ldata[15:8];
      hb_dat_b0 = hb_ldata[7:0];
    end //
  end //

  // reorder the bytes and byte enables  within the d-word
  always @* begin
    case (swizzler_ctrl[2:1])
      2'b00: begin
	hbi_data_in[31:24] = hb_dat_b3;
	hbi_data_in[23:16] = hb_dat_b2;
	hbi_data_in[15:8]  = hb_dat_b1;
	hbi_data_in[7:0]   = hb_dat_b0;
	hb_be[3]  = hb_lbe[3];
	hb_be[2]  = hb_lbe[2];
        hb_be[1]  = hb_lbe[1];
        hb_be[0]  = hb_lbe[0];
      end // case: 2'b00
      
      2'b01: begin
	hbi_data_in[31:24] = hb_dat_b2;
	hbi_data_in[23:16] = hb_dat_b3;
	hbi_data_in[15:8]  = hb_dat_b0;
	hbi_data_in[7:0]   = hb_dat_b1;
	hb_be[3]  = hb_lbe[2];
	hb_be[2]  = hb_lbe[3];
        hb_be[1]  = hb_lbe[0];
        hb_be[0]  = hb_lbe[1];
      end // case: 2'b01

      2'b10: begin
	hbi_data_in[31:24] = hb_dat_b1;
	hbi_data_in[23:16] = hb_dat_b0;
	hbi_data_in[15:8]  = hb_dat_b3;
	hbi_data_in[7:0]   = hb_dat_b2;
	hb_be[3]  = hb_lbe[1];
	hb_be[2]  = hb_lbe[0];
        hb_be[1]  = hb_lbe[3];
        hb_be[0]  = hb_lbe[2];
      end // case: 2'b10
      
      2'b11: begin
	hbi_data_in[31:24] = hb_dat_b0;
	hbi_data_in[23:16] = hb_dat_b1;
	hbi_data_in[15:8]  = hb_dat_b2;
	hbi_data_in[7:0]   = hb_dat_b3;
	hb_be[3]  = hb_lbe[0];
	hb_be[2]  = hb_lbe[1];
        hb_be[1]  = hb_lbe[2];
        hb_be[0]  = hb_lbe[3];
      end // case: 2'b11
    endcase // case (swizzler_ctrl[2:1])
  end
  
  assign hbi_be_in = hb_be;

  assign mw_be[3:0] = hb_be[3:0];

  assign per_origin[15:0] =  
	 !cs_dac_space_n          ? {12'h0, dac_addr[3:0]} :
	 !cs_eprom_n && !hb_write ? {eprom_addr_bus[15:2], 2'h0} :
	 !cs_eprom_n && hb_write  ?  eprom_addr_bus[15:0] : 16'h0;
  
endmodule


