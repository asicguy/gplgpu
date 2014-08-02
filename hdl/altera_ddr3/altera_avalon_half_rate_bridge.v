//Legal Notice: (C)2010 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// ================================================================================
// Altera Avalon Half Rate Bridge
//
// Interface between two Avalon bus segments where master interface is
// clocked at twice the rate and synchronous to the slave interface
// ================================================================================

`timescale 1ns/1ns
module altera_avalon_half_rate_bridge (
                  avs_reset_n,
                  avm_reset_n,

                  // Avalon slave
                  avs_clk,
                  avs_chipselect,
                  avs_address,
                  avs_write,
                  avs_read,
                  avs_byteenable,
                  avs_writedata,

                  avs_readdata,
                  avs_waitrequest,
                  avs_readdatavalid,

                  // Avalon master
                  avm_clk,

                  avm_burstcount,
                  avm_address,
                  avm_write,
                  avm_read,
                  avm_byteenable,
                  avm_writedata,

                  avm_readdata,
                  avm_waitrequest,
                  avm_readdatavalid
                  );

  localparam ENABLE_BURSTING_MASTER = 1;
  parameter AVM_DATA_WIDTH = 32;
  parameter AVM_ADDR_WIDTH = 28;
  parameter AVM_BYTE_WIDTH =  4;
  parameter AVS_DATA_WIDTH = 64;
  parameter AVS_ADDR_WIDTH = 25;
  parameter AVS_BYTE_WIDTH =  8;


  // constant function to get number of bits from size
  // e.g. burstlength 8 requires 4 bit burstcount [3:0]
  function integer log2 (input integer size);
    begin
      for(log2 = 0; size > 0; log2 = log2 + 1)
        size = size >> 1;
      log2 = log2 - 1;
    end
  endfunction

  // Avalon slave
  input                        avs_reset_n;            // Active low asynch reset
  input                        avm_reset_n;

  input                        avs_clk;
  input                        avs_chipselect;
  input [AVS_ADDR_WIDTH-1:0]   avs_address;
  input                        avs_write;
  input                        avs_read;
  input [AVS_BYTE_WIDTH-1:0]   avs_byteenable;
  input [AVS_DATA_WIDTH-1:0]   avs_writedata;

  output [AVS_DATA_WIDTH-1:0]  avs_readdata;
  output                       avs_waitrequest;
  output                       avs_readdatavalid;

  // Avalon master
  input                        avm_clk;  // Must be 2x and synchronous to avs_clk
  input [AVM_DATA_WIDTH-1:0]   avm_readdata;
  input                        avm_waitrequest;
  input                        avm_readdatavalid;

  output [AVM_ADDR_WIDTH-1:0]  avm_address;
  output                       avm_write;
  output                       avm_read;
  output [AVM_BYTE_WIDTH-1:0]  avm_byteenable;
  output [AVM_DATA_WIDTH-1:0]  avm_writedata;
  output [1:0]                 avm_burstcount;

  reg                          avs_waitrequest;
  wire [2:0]                   avm_nxt_wr_txfers;
  wire [2:0]                   avm_nxt_rd_txfers;
  reg                          avm_read;
  reg                          avm_write;
  reg [AVM_ADDR_WIDTH-1:0]     avm_address;
  reg [AVM_BYTE_WIDTH-1:0]     avm_byteenable;
  reg [AVM_DATA_WIDTH-1:0]     avm_writedata;
  wire [1:0]                   avm_burstcount = 2'd2;
  wire [AVM_BYTE_WIDTH:0]      avm_addr_offset;

  generate
    if (ENABLE_BURSTING_MASTER)
      assign avm_addr_offset =  0;
    else
      assign avm_addr_offset =  (1'b1<<((log2(AVM_BYTE_WIDTH))));

  endgenerate
  //---------------------------------------------------------------------------
  // AVS Control
  //---------------------------------------------------------------------------
  wire [2:0] avm_nxt_txfers;

  always @(posedge avs_clk or negedge avs_reset_n)
    if (~avs_reset_n)
      avs_waitrequest <= 1'b1;
    else
      avs_waitrequest <= (avm_nxt_txfers >= 4'b011);

  reg avs_toggle;
  always @(posedge avs_clk or negedge avs_reset_n)
    if (~avs_reset_n)
      avs_toggle <= 1'b0;
    else
      avs_toggle <= ~avs_toggle;

  reg avm_toggle;
  reg avm_toggle_r;
  always @(posedge avm_clk or negedge avm_reset_n)
    if (~avm_reset_n)
    begin
      avm_toggle <= 1'b0;
      avm_toggle_r <= 1'b0;
    end
    else
    begin
      avm_toggle <= avs_toggle;
      avm_toggle_r <= avm_toggle;
    end

  wire avs_clk_ph = avm_toggle ^ avm_toggle_r;

  //---------------------------------------------------------------------------
  // Write path
  //---------------------------------------------------------------------------

  // Buffers can hold two avs transfers equivalent to four avm transfers
  reg [AVS_DATA_WIDTH-1:0] avs_writedata_r;
  reg [AVS_BYTE_WIDTH-1:0] avs_byteenable_r;
  reg [AVM_ADDR_WIDTH-1:0] avs_addr_r;
  reg [AVS_DATA_WIDTH-1:0] avs_skid;
  reg [AVS_BYTE_WIDTH-1:0] avs_byte_skid;
  reg [AVM_ADDR_WIDTH-1:0] avs_addr_skid;
  always @(posedge avs_clk or negedge avs_reset_n)
    if (~avs_reset_n)
    begin
      avs_writedata_r <= {AVS_DATA_WIDTH{1'b0}};
      avs_byteenable_r <= {AVS_BYTE_WIDTH{1'b0}};
      avs_addr_r <= {AVM_ADDR_WIDTH{1'b0}};
      avs_skid <= {AVS_DATA_WIDTH{1'b0}};
      avs_byte_skid <= {AVS_BYTE_WIDTH{1'b0}};
      avs_addr_skid <= {AVM_ADDR_WIDTH{1'b0}};
    end
    else if (avs_chipselect & ~avs_waitrequest)
    begin
      avs_writedata_r <= avs_writedata;
      avs_byteenable_r <= avs_byteenable;
      avs_addr_r <= {avs_address, {log2(AVS_BYTE_WIDTH){1'b0}}};
      avs_skid <= avs_writedata_r;
      avs_byte_skid <= avs_byteenable_r;
      avs_addr_skid <= avs_addr_r;
    end

  // Count number of oustanding avm write transfers
  reg [2:0] avm_wr_txfers;

  // decrement by 1 for every avm transfer
  wire      wr_txfers_dec = avm_write & ~avm_waitrequest;

  // increment by 2 for every avs transfer
  wire      wr_txfers_inc2 = avs_write & ~avs_waitrequest & avs_clk_ph;

  assign avm_nxt_wr_txfers = avm_wr_txfers + (wr_txfers_inc2 ? 3'b010 : 3'b0)
                                           - (wr_txfers_dec ? 3'b001 : 3'b0);

  always @(posedge avm_clk or negedge avm_reset_n)
    if (~avm_reset_n)
      avm_wr_txfers <= 3'b0;
    else
      avm_wr_txfers <= avm_nxt_wr_txfers;

  //---------------------------------------------------------------------------
  // Read path
  //---------------------------------------------------------------------------
  reg avs_readdatavalid;
  reg [AVS_DATA_WIDTH-1:0] avs_readdata;

  // Count number of oustanding avm read requests
  reg [2:0] avm_rd_txfers;

  // decrement for every avm transfer
  wire      rd_txfers_dec = avm_read & ~avm_waitrequest;

  // increment by 2 for every avs transfer
  wire      rd_txfers_inc2 = avs_read & ~avs_waitrequest & avs_clk_ph;

  generate
    if (ENABLE_BURSTING_MASTER)
      // decrement by 2 for each avm read if bursting is enabled
      assign avm_nxt_rd_txfers = avm_rd_txfers + (rd_txfers_inc2 ? 3'b010 : 3'b0)
                                               - (rd_txfers_dec ? 3'b010 : 3'b0);
    else
      assign avm_nxt_rd_txfers = avm_rd_txfers + (rd_txfers_inc2 ? 3'b010 : 3'b0)
                                               - (rd_txfers_dec ? 3'b001 : 3'b0);
  endgenerate
  always @(posedge avm_clk or negedge avm_reset_n)
    if (~avm_reset_n)
      avm_rd_txfers <= 3'b0;
    else
      avm_rd_txfers <= avm_nxt_rd_txfers;

  // Count number of oustanding avm read data transfers
  reg [2:0] avm_rd_data_txfers;

  // decrement by 2 for every avs transfer
  wire      rd_data_txfers_dec2 = avs_readdatavalid & avs_clk_ph;

  // increment by 1 for every avm transfer
  wire      rd_data_txfers_inc = avm_readdatavalid;

  wire [2:0] avm_nxt_rd_data_txfers = avm_rd_data_txfers + (rd_data_txfers_inc ? 3'b001 : 3'b0)
                                                         - (rd_data_txfers_dec2 ? 3'b010 : 3'b0);

  assign     avm_nxt_txfers = avm_nxt_rd_txfers + avm_nxt_wr_txfers;
  wire [2:0] avm_txfers = avm_rd_txfers + avm_wr_txfers;

  always @(posedge avm_clk or negedge avm_reset_n)
    if (~avm_reset_n)
      avm_rd_data_txfers <= 3'b0;
    else
      avm_rd_data_txfers <= avm_nxt_rd_data_txfers;

  always @(posedge avs_clk or negedge avs_reset_n)
    if (~avs_reset_n)
      avs_readdatavalid <= 1'b0;
    else
      avs_readdatavalid <= (avm_nxt_rd_data_txfers >= 3'b010);

  reg [AVS_DATA_WIDTH-1:0] avm_readdata_r;
  reg [AVS_DATA_WIDTH-1:0] avm_skid;
  always @(posedge avm_clk or negedge avm_reset_n)
    if (~avm_reset_n)
    begin
      avm_readdata_r <= {AVS_DATA_WIDTH{1'b0}};
      avm_skid <= {AVS_DATA_WIDTH{1'b0}};
    end
    else if (avm_readdatavalid & avm_nxt_rd_data_txfers[0])
    begin
      avm_readdata_r[AVM_DATA_WIDTH-1:0] <= avm_readdata;
      avm_skid <= avm_readdata_r;
    end
    else if (avm_readdatavalid)
    begin
      avm_readdata_r[AVS_DATA_WIDTH-1:AVM_DATA_WIDTH] <= avm_readdata;
    end

  always @(avm_readdata_r, avm_rd_data_txfers, avm_skid)
    case (avm_rd_data_txfers)
      3'd4, 3'd3:       avs_readdata = avm_skid;

      default:          avs_readdata = avm_readdata_r;
    endcase

  //---------------------------------------------------------------------------
  // AVM control
  //---------------------------------------------------------------------------
  reg [5:0] avm_state;
  localparam AVM_IDLE   = 6'b000001,
             AVM_WRITE1 = 6'b000010,
             AVM_READ1  = 6'b000100;

  always @(posedge avm_clk or negedge avm_reset_n)
    if (~avm_reset_n)
    begin
      avm_write <= 1'b0;
      avm_read <= 1'b0;
      avm_state <= AVM_IDLE;
    end
    else
      case (avm_state)
        AVM_IDLE:
          if (|(avm_nxt_wr_txfers))
          begin
            avm_write <= 1'b1;
            avm_state <= AVM_WRITE1;
          end
          else if (|(avm_nxt_rd_txfers))
          begin
            avm_read <= 1'b1;
            avm_state <= AVM_READ1;
          end

        AVM_WRITE1:
          if (~(|avm_nxt_wr_txfers) & ~(|avm_nxt_rd_txfers) & ~avm_waitrequest)
          begin
            avm_write <= 1'b0;
            avm_state <= AVM_IDLE;
          end
          else if (~(|avm_nxt_wr_txfers) & (|avm_nxt_rd_txfers) & ~avm_waitrequest)
          begin
            avm_write <= 1'b0;
            avm_read <= 1'b1;
            avm_state <= AVM_READ1;
          end

        AVM_READ1:
          if (~(|avm_nxt_rd_txfers) & ~(|avm_nxt_wr_txfers) & ~avm_waitrequest)
          begin
            avm_read <= 1'b0;
            avm_state <= AVM_IDLE;
          end
          else if (~(|avm_nxt_rd_txfers) & (|avm_nxt_wr_txfers) & ~avm_waitrequest)
          begin
            avm_read <= 1'b0;
            avm_write <= 1'b1;
            avm_state <= AVM_WRITE1;
          end

        default:
          avm_state <= AVM_IDLE;

      endcase

  // Write data is selected from the buffers depending on how many transfers
  // are outstanding
  always @(avs_writedata_r, avs_skid, avm_txfers)
    case (avm_txfers)
      3'd4: avm_writedata <= avs_skid[AVM_DATA_WIDTH-1:0];

      3'd3: avm_writedata <= avs_skid[AVS_DATA_WIDTH-1:AVM_DATA_WIDTH];
      
      3'd2: avm_writedata <= avs_writedata_r[AVM_DATA_WIDTH-1:0];

      3'd1: avm_writedata <= avs_writedata_r[AVS_DATA_WIDTH-1:AVM_DATA_WIDTH];

      default: avm_writedata <= {AVM_DATA_WIDTH{1'b0}};
    endcase

  // Similarly for byte enables
  always @(avm_state, avs_byteenable_r, avs_byte_skid, avm_txfers)
    case (avm_txfers)
      3'd4: avm_byteenable <= avs_byte_skid[AVM_BYTE_WIDTH-1:0];

      3'd3: avm_byteenable <= avs_byte_skid[AVS_BYTE_WIDTH-1:AVM_BYTE_WIDTH];

      3'd2: avm_byteenable <= avs_byteenable_r[AVM_BYTE_WIDTH-1:0];

      3'd1: avm_byteenable <= avs_byteenable_r[AVS_BYTE_WIDTH-1:AVM_BYTE_WIDTH];

      default: avm_byteenable <= {AVM_BYTE_WIDTH{1'b0}};
    endcase

  // And address
  always @(avm_state, avs_addr_r, avs_addr_skid, avm_txfers)
    case (avm_txfers)
      3'd4: avm_address <= avs_addr_skid;

      3'd3: avm_address <= avs_addr_skid | avm_addr_offset;

      3'd2: avm_address <= avs_addr_r;

      3'd1: avm_address <= avs_addr_r | avm_addr_offset;

      default: avm_address <= {AVM_ADDR_WIDTH{1'b0}};
    endcase

endmodule
