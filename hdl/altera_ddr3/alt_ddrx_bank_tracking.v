//Legal Notice: (C)2009 Altera Corporation. All rights reserved.  Your
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

///////////////////////////////////////////////////////////////////////////////
// Title         : DDR controller Bank Tracking
//
// File          : alt_ddrx_bank_tracking.v
//
// Abstract      : Keep track of open banks/rows
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_bank_tracking #
    ( parameter
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS = 2,
        MEM_IF_CS_WIDTH  = 2,
        MEM_IF_ROW_WIDTH = 16, // max supported row bits
        MEM_IF_BA_WIDTH  = 3,  // max supported bank bits
        
        // controller settings
        CTL_LOOK_AHEAD_DEPTH = 6, // set to 6 in halfrate and 8 in fullrate
        CTL_CMD_QUEUE_DEPTH  = 8
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        all_banks_closed, // needed for precharge_all before a refresh 
        
        // Per cmd entry inputs and outputs, currently set to 4, might increase to 7 or more
        cmd0_is_valid,
        cmd0_chip_addr,
        cmd0_row_addr,
        cmd0_bank_addr,
        cmd0_is_a_write,
        cmd0_is_a_read,
        cmd0_multicast_req,
        
        cmd1_is_valid,
        cmd1_chip_addr,
        cmd1_row_addr,
        cmd1_bank_addr,
        cmd1_is_a_write,
        cmd1_is_a_read,
        cmd1_multicast_req,
        
        cmd2_is_valid,
        cmd2_chip_addr,
        cmd2_row_addr,
        cmd2_bank_addr,
        cmd2_is_a_write,
        cmd2_is_a_read,
        cmd2_multicast_req,
        
        cmd3_is_valid,
        cmd3_chip_addr,
        cmd3_row_addr,
        cmd3_bank_addr,
        cmd3_is_a_write,
        cmd3_is_a_read,
        cmd3_multicast_req,
        
        cmd4_is_valid,
        cmd4_chip_addr,
        cmd4_row_addr,
        cmd4_bank_addr,
        cmd4_is_a_write,
        cmd4_is_a_read,
        cmd4_multicast_req,
        
        cmd5_is_valid,
        cmd5_chip_addr,
        cmd5_row_addr,
        cmd5_bank_addr,
        cmd5_is_a_write,
        cmd5_is_a_read,
        cmd5_multicast_req,
        
        cmd6_is_valid,
        cmd6_chip_addr,
        cmd6_row_addr,
        cmd6_bank_addr,
        cmd6_is_a_write,
        cmd6_is_a_read,
        cmd6_multicast_req,
        
        cmd7_is_valid,
        cmd7_chip_addr,
        cmd7_row_addr,
        cmd7_bank_addr,
        cmd7_is_a_write,
        cmd7_is_a_read,
        cmd7_multicast_req,
        
        row_is_open,
        bank_is_open,
        bank_info_valid,
        
        // used for current command
        current_chip_addr,
        current_row_addr,
        current_bank_addr,
        current_is_a_write,
        current_is_a_read,
        current_multicast_req,
        current_row_is_open,
        current_bank_is_open,
        current_bank_info_valid,
        
        // state machine command outputs
        ecc_fetch_error_addr,
        fetch,
        flush1,
        flush2,
        flush3,
        do_activate,
        do_precharge,
        do_precharge_all,
        do_auto_precharge,
        
        to_chip,
        //to_cs_addr,
        to_row_addr,
        to_bank_addr,

        // bank page open/close information
        bank_information,
        bank_open
    );

input ctl_clk;
input ctl_reset_n;

output [MEM_IF_CS_WIDTH - 1 : 0] all_banks_closed;

// Per cmd entry inputs and outputs; currently set to 4; might increase to 7 or more
input  cmd0_is_valid;
input  cmd0_is_a_write;
input  cmd0_is_a_read;
input  cmd0_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd0_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd0_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd0_bank_addr;

input  cmd1_is_valid;
input  cmd1_is_a_write;
input  cmd1_is_a_read;
input  cmd1_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd1_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd1_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd1_bank_addr;

input  cmd2_is_valid;
input  cmd2_is_a_write;
input  cmd2_is_a_read;
input  cmd2_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd2_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd2_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd2_bank_addr;

input  cmd3_is_valid;
input  cmd3_is_a_write;
input  cmd3_is_a_read;
input  cmd3_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd3_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd3_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd3_bank_addr;

input  cmd4_is_valid;
input  cmd4_is_a_write;
input  cmd4_is_a_read;
input  cmd4_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd4_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd4_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd4_bank_addr;

input  cmd5_is_valid;
input  cmd5_is_a_write;
input  cmd5_is_a_read;
input  cmd5_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd5_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd5_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd5_bank_addr;

input  cmd6_is_valid;
input  cmd6_is_a_write;
input  cmd6_is_a_read;
input  cmd6_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd6_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd6_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd6_bank_addr;

input  cmd7_is_valid;
input  cmd7_is_a_write;
input  cmd7_is_a_read;
input  cmd7_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd7_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd7_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd7_bank_addr;

output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] row_is_open;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_is_open;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_info_valid;

input  current_is_a_write;
input  current_is_a_read;
input  current_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] current_chip_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] current_row_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  current_bank_addr;

output current_row_is_open;
output current_bank_is_open;
output current_bank_info_valid;

// state machine command outputs
input ecc_fetch_error_addr;
input fetch;
input flush1;
input flush2;
input flush3;
input do_activate;
input do_precharge;
input do_precharge_all;
input do_auto_precharge;

input [MEM_IF_CS_WIDTH - 1 : 0]  to_chip;
input [MEM_IF_ROW_WIDTH - 1 : 0] to_row_addr;
input [MEM_IF_BA_WIDTH - 1 : 0]  to_bank_addr;

output [MEM_IF_CS_WIDTH * (2**MEM_IF_BA_WIDTH) * MEM_IF_ROW_WIDTH - 1 : 0]  bank_information ; 
output [MEM_IF_CS_WIDTH * (2**MEM_IF_BA_WIDTH) - 1 : 0]                     bank_open ; 

// Registers
reg [MEM_IF_CS_WIDTH - 1 : 0] all_banks_closed;

integer ba_count;
integer cs_count1;
integer cs_count2;

reg [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bank_status [MEM_IF_CS_WIDTH - 1 : 0]; // bank status register num_of_cs * num_of_bank

reg ecc_fetch_error_addr_r1;
reg ecc_fetch_error_addr_r2;
reg fetch_r1;
reg fetch_r2;
reg flush1_r1;
reg flush2_r1;
reg flush3_r1;
reg [1 : 0] flush;

reg int_current_info_valid;
reg int_current_info_valid_r;

reg cmd_cache;

reg do_activate_r1;
reg [MEM_IF_CHIP_BITS - 1 : 0] to_chip_r1;
reg [MEM_IF_BA_WIDTH  - 1 : 0] to_bank_addr_r1;
reg [MEM_IF_ROW_WIDTH - 1 : 0] to_row_addr_r1;

reg [MEM_IF_BA_WIDTH - 1 : 0]  current_bank_addr_r1;
reg [MEM_IF_ROW_WIDTH - 1 : 0] current_row_addr_r1;

reg current_bank_change;
reg current_row_change;

// One big bus which will concatenate all CMD 0 - N signals where N is CTL_CMD_QUEUE_DEPTH (might set to constant value based on number of command ports)
// Also includes current cmd
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_bank_is_open;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_row_is_open;

reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_activate;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_precharge;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_activate_r1;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_precharge_r1;
reg [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_do_activate_cached;
reg [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_do_precharge_cached;
reg [CTL_CMD_QUEUE_DEPTH  : 0] cmd_do_activate_cached;
reg [CTL_CMD_QUEUE_DEPTH  : 0] cmd_do_precharge_cached;

wire [(CTL_CMD_QUEUE_DEPTH + 1) * (MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd_addr;
wire [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_CHIP_BITS - 1 : 0] cmd_chip_addr;
wire [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_BA_WIDTH  - 1 : 0] cmd_bank_addr;
wire [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_ROW_WIDTH - 1 : 0] cmd_row_addr;
wire [CTL_CMD_QUEUE_DEPTH : 0] cmd_is_valid;
wire [CTL_CMD_QUEUE_DEPTH : 0] cmd_info_valid;

wire [CTL_CMD_QUEUE_DEPTH : 0] is_a_write;
wire [CTL_CMD_QUEUE_DEPTH : 0] is_a_read;
wire [CTL_CMD_QUEUE_DEPTH : 0] multicast_req;
wire [CTL_CMD_QUEUE_DEPTH : 0] cmd_multicast_req;

wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] current_addr = {current_chip_addr, current_bank_addr, current_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd0_addr = {cmd0_chip_addr, cmd0_bank_addr, cmd0_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd1_addr = {cmd1_chip_addr, cmd1_bank_addr, cmd1_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd2_addr = {cmd2_chip_addr, cmd2_bank_addr, cmd2_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd3_addr = {cmd3_chip_addr, cmd3_bank_addr, cmd3_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd4_addr = {cmd4_chip_addr, cmd4_bank_addr, cmd4_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd5_addr = {cmd5_chip_addr, cmd5_bank_addr, cmd5_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd6_addr = {cmd6_chip_addr, cmd6_bank_addr, cmd6_row_addr};
wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] cmd7_addr = {cmd7_chip_addr, cmd7_bank_addr, cmd7_row_addr};

// CMD outputs
wire [CTL_LOOK_AHEAD_DEPTH - 1 : 0] row_is_open;
wire [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_is_open;
wire [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_info_valid;

reg [CTL_CMD_QUEUE_DEPTH - 1 : 0]  int_row_is_open;
reg [CTL_CMD_QUEUE_DEPTH - 1 : 0]  int_bank_is_open;
reg [CTL_CMD_QUEUE_DEPTH - 1 : 0]  int_bank_info_valid;

reg current_bank_is_open;
reg current_row_is_open;
reg current_bank_info_valid;

assign cmd_addr           = {cmd7_addr, cmd6_addr, cmd5_addr, cmd4_addr, cmd3_addr, cmd2_addr, cmd1_addr, cmd0_addr, current_addr};
assign cmd_chip_addr      = {cmd7_chip_addr, cmd6_chip_addr, cmd5_chip_addr, cmd4_chip_addr, cmd3_chip_addr, cmd2_chip_addr, cmd1_chip_addr, cmd0_chip_addr, current_chip_addr};
assign cmd_bank_addr      = {cmd7_bank_addr, cmd6_bank_addr, cmd5_bank_addr, cmd4_bank_addr, cmd3_bank_addr, cmd2_bank_addr, cmd1_bank_addr, cmd0_bank_addr, current_bank_addr};
assign cmd_row_addr       = {cmd7_row_addr, cmd6_row_addr, cmd5_row_addr, cmd4_row_addr, cmd3_row_addr, cmd2_row_addr, cmd1_row_addr, cmd0_row_addr, current_row_addr};
assign cmd_is_valid       = {cmd7_is_valid, cmd6_is_valid, cmd5_is_valid, cmd4_is_valid, cmd3_is_valid, cmd2_is_valid, cmd1_is_valid, cmd0_is_valid, 1'b0}; // current signal doesn't have valid signal
assign cmd_info_valid [0] = int_current_info_valid;

assign multicast_req = {cmd7_multicast_req, cmd6_multicast_req, cmd5_multicast_req, cmd4_multicast_req, cmd3_multicast_req, cmd2_multicast_req, cmd1_multicast_req, cmd0_multicast_req, current_multicast_req};
assign is_a_write    = {cmd7_is_a_write, cmd6_is_a_write, cmd5_is_a_write, cmd4_is_a_write, cmd3_is_a_write, cmd2_is_a_write, cmd1_is_a_write, cmd0_is_a_write, current_is_a_write};
assign is_a_read     = {cmd7_is_a_read, cmd6_is_a_read, cmd5_is_a_read, cmd4_is_a_read, cmd3_is_a_read, cmd2_is_a_read, cmd1_is_a_read, cmd0_is_a_read, current_is_a_read};

assign cmd_multicast_req = multicast_req & is_a_write;

assign row_is_open     = int_row_is_open     [CTL_LOOK_AHEAD_DEPTH - 1 : 0];
assign bank_is_open    = int_bank_is_open    [CTL_LOOK_AHEAD_DEPTH - 1 : 0];
assign bank_info_valid = int_bank_info_valid [CTL_LOOK_AHEAD_DEPTH - 1 : 0];

/*------------------------------------------------------------------------------

    Cache

------------------------------------------------------------------------------*/
// Determine the flush value
always @ (*)
begin
    if (fetch)
    begin
        if (flush1)
            flush = 2'b01;
        else if (flush2)
            flush = 2'b10;
        else if (flush3)
            flush = 2'b11;
        else
            flush = 2'b00;
    end
    else if (fetch_r1)
    begin
        if (flush1_r1)
            flush = 2'b01;
        else if (flush2_r1)
            flush = 2'b10;
        else if (flush3_r1)
            flush = 2'b11;
        else
            flush = 2'b00;
    end
    else
    begin
        // the following case is to prevent caching the wrong data during flush with no fetch state
        // eg: when there is flush1 with no fetch, we should only move the data by one command instead of 2
        if (flush1 || flush1_r1)
            flush = 2'b00;
        else if (flush2 || flush2_r1)
            flush = 2'b01;
        else if (flush3 || flush3_r1)
            flush = 2'b10;
        else
            flush = 2'b00;
    end
end

// Fetch registers
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        ecc_fetch_error_addr_r1 <= 1'b0;
        ecc_fetch_error_addr_r2 <= 1'b0;
        fetch_r1                <= 1'b0;
        fetch_r2                <= 1'b0;
    end
    else
    begin
        ecc_fetch_error_addr_r1 <= ecc_fetch_error_addr;
        ecc_fetch_error_addr_r2 <= ecc_fetch_error_addr_r1;
        fetch_r1                <= fetch;
        fetch_r2                <= fetch_r1;
    end
end

// register all flush signal
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        flush1_r1 <= 1'b0;
        flush2_r1 <= 1'b0;
        flush3_r1 <= 1'b0;
    end
    else
    begin
        flush1_r1 <= flush1;
        flush2_r1 <= flush2;
        flush3_r1 <= flush3;
    end
end

// Determine when to cache the information
always @ (*)
begin
    begin
        if (fetch || fetch_r1 || flush1 || flush2 || flush3 || flush1_r1 || flush2_r1 || flush3_r1)
            cmd_cache = 1'b1;
        else
            cmd_cache = 1'b0;
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        current_bank_is_open    <=  0;
        int_bank_is_open        <=  0;
        current_row_is_open     <=  0;
        int_row_is_open         <=  0;
        current_bank_info_valid <=  0;
        int_bank_info_valid     <=  0;
    end
    else if (cmd_cache)
    begin
        if (flush == 2'b01)
        begin
            current_bank_is_open    <= cmd_bank_is_open [2];
            int_bank_is_open [0]    <= cmd_bank_is_open [3];
            int_bank_is_open [1]    <= cmd_bank_is_open [4];
            int_bank_is_open [2]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [5];
            int_bank_is_open [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [6];
            int_bank_is_open [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [7];
            int_bank_is_open [5]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [8];
            int_bank_is_open [6]    <= 1'b0;
            int_bank_is_open [7]    <= 1'b0;
            
            current_row_is_open     <= cmd_row_is_open [2];
            int_row_is_open [0]     <= cmd_row_is_open [3];
            int_row_is_open [1]     <= cmd_row_is_open [4];
            int_row_is_open [2]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [5];
            int_row_is_open [3]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [6];
            int_row_is_open [4]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [7];
            int_row_is_open [5]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [8];
            int_row_is_open [6]     <= 1'b0;
            int_row_is_open [7]     <= 1'b0;
            
            current_bank_info_valid <= cmd_info_valid[2];
            int_bank_info_valid [0] <= cmd_info_valid[3];
            int_bank_info_valid [1] <= cmd_info_valid[4];
            int_bank_info_valid [2] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [5];
            int_bank_info_valid [3] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [6];
            int_bank_info_valid [4] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [7];
            int_bank_info_valid [5] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [8];
            int_bank_info_valid [6] <= 1'b0;
            int_bank_info_valid [7] <= 1'b0;
        end
        else if (flush == 2'b10)
        begin
            current_bank_is_open    <= cmd_bank_is_open [3];
            int_bank_is_open [0]    <= cmd_bank_is_open [4];
            int_bank_is_open [1]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [5];
            int_bank_is_open [2]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [6];
            int_bank_is_open [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [7];
            int_bank_is_open [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [8];
            int_bank_is_open [5]    <= 1'b0;
            int_bank_is_open [6]    <= 1'b0;
            int_bank_is_open [7]    <= 1'b0;
            
            current_row_is_open     <= cmd_row_is_open [3];
            int_row_is_open [0]     <= cmd_row_is_open [4];
            int_row_is_open [1]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [5];
            int_row_is_open [2]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [6];
            int_row_is_open [3]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [7];
            int_row_is_open [4]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [8];
            int_row_is_open [5]     <= 1'b0;
            int_row_is_open [6]     <= 1'b0;
            int_row_is_open [7]     <= 1'b0;
            
            current_bank_info_valid <= cmd_info_valid[3];
            int_bank_info_valid [0] <= cmd_info_valid[4];
            int_bank_info_valid [1] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [5];
            int_bank_info_valid [2] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [6];
            int_bank_info_valid [3] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [7];
            int_bank_info_valid [4] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [8];
            int_bank_info_valid [5] <= 1'b0;
            int_bank_info_valid [6] <= 1'b0;
            int_bank_info_valid [7] <= 1'b0;
        end
        else if (flush == 2'b11)
        begin
            current_bank_is_open    <= cmd_bank_is_open [4];
            int_bank_is_open [0]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [5];
            int_bank_is_open [1]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [6];
            int_bank_is_open [2]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [7];
            int_bank_is_open [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [8];
            int_bank_is_open [4]    <= 1'b0;
            int_bank_is_open [5]    <= 1'b0;
            int_bank_is_open [6]    <= 1'b0;
            int_bank_is_open [7]    <= 1'b0;
            
            current_row_is_open     <= cmd_row_is_open [4];
            int_row_is_open [0]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [5];
            int_row_is_open [1]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [6];
            int_row_is_open [2]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [7];
            int_row_is_open [3]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [8];
            int_row_is_open [4]     <= 1'b0;
            int_row_is_open [5]     <= 1'b0;
            int_row_is_open [6]     <= 1'b0;
            int_row_is_open [7]     <= 1'b0;
            
            current_bank_info_valid <= cmd_info_valid[4];
            int_bank_info_valid [0] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [5];
            int_bank_info_valid [1] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [6];
            int_bank_info_valid [2] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [7];
            int_bank_info_valid [3] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [8];
            int_bank_info_valid [4] <= 1'b0;
            int_bank_info_valid [5] <= 1'b0;
            int_bank_info_valid [6] <= 1'b0;
            int_bank_info_valid [7] <= 1'b0;
        end
        else
        begin
            current_bank_is_open    <= cmd_bank_is_open [1];
            int_bank_is_open [0]    <= cmd_bank_is_open [2];
            int_bank_is_open [1]    <= cmd_bank_is_open [3];
            int_bank_is_open [2]    <= cmd_bank_is_open [4];
            int_bank_is_open [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [5];
            int_bank_is_open [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [6];
            int_bank_is_open [5]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [7];
            int_bank_is_open [6]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [8];
            int_bank_is_open [7]    <= 1'b0;
            
            current_row_is_open     <= cmd_row_is_open [1];
            int_row_is_open [0]     <= cmd_row_is_open [2];
            int_row_is_open [1]     <= cmd_row_is_open [3];
            int_row_is_open [2]     <= cmd_row_is_open [4];
            int_row_is_open [3]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [5];
            int_row_is_open [4]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [6];
            int_row_is_open [5]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [7];
            int_row_is_open [6]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [8];
            int_row_is_open [7]     <= 1'b0;
            
            current_bank_info_valid <= cmd_info_valid [1];
            int_bank_info_valid [0] <= cmd_info_valid [2];
            int_bank_info_valid [1] <= cmd_info_valid [3];
            int_bank_info_valid [2] <= cmd_info_valid [4];
            int_bank_info_valid [3] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [5];
            int_bank_info_valid [4] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [6];
            int_bank_info_valid [5] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [7];
            int_bank_info_valid [6] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [8];
            int_bank_info_valid [7] <= 1'b0;
        end
    end
    else
    begin
        // changes done to current information because state machine will change current row, bank and chip address
        // when address reaches encd of row, bank or chip, normally happen when local size is set to a large value
        
        // during bank or chip change, bank will definitely change, so we check for bank change only
        // when there is a bank change, we will hold off valid signal for 2 clock cycles before valid data comes back from ram
        if (current_bank_change)
            current_bank_info_valid <= 1'b0;
        else
            current_bank_info_valid <= cmd_info_valid [0];
        
        // during row change, we only need to set row_is_open to zero so that state machine will precharge and activate the current bank
        if (current_row_change)
            current_row_is_open <= 1'b0;
        else
            current_row_is_open <= cmd_row_is_open [0];
        
        current_bank_is_open    <= cmd_bank_is_open [0];
        int_bank_is_open [0]    <= cmd_bank_is_open [1];
        int_bank_is_open [1]    <= cmd_bank_is_open [2];
        int_bank_is_open [2]    <= cmd_bank_is_open [3];
        int_bank_is_open [3]    <= cmd_bank_is_open [4];
        int_bank_is_open [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [5];
        int_bank_is_open [5]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_bank_is_open [6];
        int_bank_is_open [6]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [7];
        int_bank_is_open [7]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_bank_is_open [8];
        
        //current_row_is_open     <= cmd_row_is_open [0];
        int_row_is_open [0]     <= cmd_row_is_open [1];
        int_row_is_open [1]     <= cmd_row_is_open [2];
        int_row_is_open [2]     <= cmd_row_is_open [3];
        int_row_is_open [3]     <= cmd_row_is_open [4];
        int_row_is_open [4]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [5];
        int_row_is_open [5]     <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_row_is_open [6];
        int_row_is_open [6]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [7];
        int_row_is_open [7]     <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_row_is_open [8];
        
        //current_bank_info_valid <= cmd_info_valid [0];
        int_bank_info_valid [0] <= cmd_info_valid [1];
        int_bank_info_valid [1] <= cmd_info_valid [2];
        int_bank_info_valid [2] <= cmd_info_valid [3];
        int_bank_info_valid [3] <= cmd_info_valid [4];
        int_bank_info_valid [4] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [5];
        int_bank_info_valid [5] <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : cmd_info_valid [6];
        int_bank_info_valid [6] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [7];
        int_bank_info_valid [7] <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : cmd_info_valid [8];
    end
end

always @ (*)
begin
    if (cmd_cache)
    begin
        if (flush == 2'b01)
        begin
            // cmd do signal (registered version)
            cmd_do_activate_cached [0] = 1'b0;
            cmd_do_activate_cached [1] = 1'b0;
            cmd_do_activate_cached [2] = int_cmd_do_activate_cached [0];
            cmd_do_activate_cached [3] = int_cmd_do_activate_cached [1];
            cmd_do_activate_cached [4] = int_cmd_do_activate_cached [2];
            cmd_do_activate_cached [5] = int_cmd_do_activate_cached [3];
            cmd_do_activate_cached [6] = int_cmd_do_activate_cached [4];
            cmd_do_activate_cached [7] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [5];
            cmd_do_activate_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [6];
            
            cmd_do_precharge_cached [0] = 1'b0;
            cmd_do_precharge_cached [1] = 1'b0;
            cmd_do_precharge_cached [2] = int_cmd_do_precharge_cached [0];
            cmd_do_precharge_cached [3] = int_cmd_do_precharge_cached [1];
            cmd_do_precharge_cached [4] = int_cmd_do_precharge_cached [2];
            cmd_do_precharge_cached [5] = int_cmd_do_precharge_cached [3];
            cmd_do_precharge_cached [6] = int_cmd_do_precharge_cached [4];
            cmd_do_precharge_cached [7] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [5];
            cmd_do_precharge_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [6];
        end
        else if (flush == 2'b10)
        begin
            // cmd do signal (registered version)
            cmd_do_activate_cached [0] = 1'b0;
            cmd_do_activate_cached [1] = 1'b0;
            cmd_do_activate_cached [2] = 1'b0;
            cmd_do_activate_cached [3] = int_cmd_do_activate_cached [0];
            cmd_do_activate_cached [4] = int_cmd_do_activate_cached [1];
            cmd_do_activate_cached [5] = int_cmd_do_activate_cached [2];
            cmd_do_activate_cached [6] = int_cmd_do_activate_cached [3];
            cmd_do_activate_cached [7] = int_cmd_do_activate_cached [4];
            cmd_do_activate_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [5];
            
            cmd_do_precharge_cached [0] = 1'b0;
            cmd_do_precharge_cached [1] = 1'b0;
            cmd_do_precharge_cached [2] = 1'b0;
            cmd_do_precharge_cached [3] = int_cmd_do_precharge_cached [0];
            cmd_do_precharge_cached [4] = int_cmd_do_precharge_cached [1];
            cmd_do_precharge_cached [5] = int_cmd_do_precharge_cached [2];
            cmd_do_precharge_cached [6] = int_cmd_do_precharge_cached [3];
            cmd_do_precharge_cached [7] = int_cmd_do_precharge_cached [4];
            cmd_do_precharge_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [5];
        end
        else if (flush == 2'b11)
        begin
            // cmd do signal (registered version)
            cmd_do_activate_cached [0] = 1'b0;
            cmd_do_activate_cached [1] = 1'b0;
            cmd_do_activate_cached [2] = 1'b0;
            cmd_do_activate_cached [3] = 1'b0;
            cmd_do_activate_cached [4] = int_cmd_do_activate_cached [0];
            cmd_do_activate_cached [5] = int_cmd_do_activate_cached [1];
            cmd_do_activate_cached [6] = int_cmd_do_activate_cached [2];
            cmd_do_activate_cached [7] = int_cmd_do_activate_cached [3];
            cmd_do_activate_cached [8] = int_cmd_do_activate_cached [4];
            
            cmd_do_precharge_cached [0] = 1'b0;
            cmd_do_precharge_cached [1] = 1'b0;
            cmd_do_precharge_cached [2] = 1'b0;
            cmd_do_precharge_cached [3] = 1'b0;
            cmd_do_precharge_cached [4] = int_cmd_do_precharge_cached [0];
            cmd_do_precharge_cached [5] = int_cmd_do_precharge_cached [1];
            cmd_do_precharge_cached [6] = int_cmd_do_precharge_cached [2];
            cmd_do_precharge_cached [7] = int_cmd_do_precharge_cached [3];
            cmd_do_precharge_cached [8] = int_cmd_do_precharge_cached [4];
        end
        else
        begin
            // cmd do signal (registered version)
            cmd_do_activate_cached [0] = 1'b0;
            cmd_do_activate_cached [1] = int_cmd_do_activate_cached [0];
            cmd_do_activate_cached [2] = int_cmd_do_activate_cached [1];
            cmd_do_activate_cached [3] = int_cmd_do_activate_cached [2];
            cmd_do_activate_cached [4] = int_cmd_do_activate_cached [3];
            cmd_do_activate_cached [5] = int_cmd_do_activate_cached [4];
            cmd_do_activate_cached [6] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [5];
            cmd_do_activate_cached [7] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [6];
            cmd_do_activate_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_cached [7];
            
            cmd_do_precharge_cached [0] = 1'b0;
            cmd_do_precharge_cached [1] = int_cmd_do_precharge_cached [0];
            cmd_do_precharge_cached [2] = int_cmd_do_precharge_cached [1];
            cmd_do_precharge_cached [3] = int_cmd_do_precharge_cached [2];
            cmd_do_precharge_cached [4] = int_cmd_do_precharge_cached [3];
            cmd_do_precharge_cached [5] = int_cmd_do_precharge_cached [4];
            cmd_do_precharge_cached [6] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [5];
            cmd_do_precharge_cached [7] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [6];
            cmd_do_precharge_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_cached [7];
        end
    end
    else
    begin
        // cmd do signal (registered version)
        cmd_do_activate_cached [0] = int_cmd_do_activate_cached [0];
        cmd_do_activate_cached [1] = int_cmd_do_activate_cached [1];
        cmd_do_activate_cached [2] = int_cmd_do_activate_cached [2];
        cmd_do_activate_cached [3] = int_cmd_do_activate_cached [3];
        cmd_do_activate_cached [4] = int_cmd_do_activate_cached [4];
        cmd_do_activate_cached [5] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [5];
        cmd_do_activate_cached [6] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_cached [6];
        cmd_do_activate_cached [7] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_cached [7];
        cmd_do_activate_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_cached [8];
        
        cmd_do_precharge_cached [0] = int_cmd_do_precharge_cached [0];
        cmd_do_precharge_cached [1] = int_cmd_do_precharge_cached [1];
        cmd_do_precharge_cached [2] = int_cmd_do_precharge_cached [2];
        cmd_do_precharge_cached [3] = int_cmd_do_precharge_cached [3];
        cmd_do_precharge_cached [4] = int_cmd_do_precharge_cached [4];
        cmd_do_precharge_cached [5] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [5];
        cmd_do_precharge_cached [6] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_cached [6];
        cmd_do_precharge_cached [7] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_cached [7];
        cmd_do_precharge_cached [8] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_cached [8];
    end
end

// register for current address
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        current_bank_addr_r1 <= 0;
        current_row_addr_r1  <= 0;
    end
    else
    begin
        current_bank_addr_r1 <= current_bank_addr;
        current_row_addr_r1  <= current_row_addr;
    end
end

// checking for row, bank and chip change in current addresses
always @ (*)
begin
    //if (!ctl_reset_n)
    //begin
    //    current_bank_change <= 1'b0;
    //    current_row_change  <= 1'b0;
    //end
    //else
    begin
        if (current_bank_addr != current_bank_addr_r1)
            current_bank_change <= 1'b1;
        else
            current_bank_change <= 1'b0;
        
        if (current_row_addr != current_row_addr_r1)
            current_row_change <= 1'b1;
        else
            current_row_change <= 1'b0;
    end
end

/*------------------------------------------------------------------------------

    CMD Signals

------------------------------------------------------------------------------*/
// register the following signal to be used in row/bank is open logic
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        do_activate_r1 <= 1'b0;
    end
    else
    begin
        do_activate_r1 <= do_activate;
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        to_chip_r1      <= 0;
        to_bank_addr_r1 <= 0;
        to_row_addr_r1  <= 0;
    end
    else
    begin
        to_chip_r1      <= to_chip;
        to_bank_addr_r1 <= to_bank_addr;
        to_row_addr_r1  <= to_row_addr;
    end
end

// The following signals will be used to determine when there is a activate/precharge
// to each command queue address
generate
begin
    genvar w;
    for (w = 0;w < CTL_LOOK_AHEAD_DEPTH + 1;w = w + 1)
    begin : input_do_signal_fanout_per_cmd
        wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(w + 1) * MEM_IF_CHIP_BITS - 1 : w * MEM_IF_CHIP_BITS];
        wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(w + 1) * MEM_IF_BA_WIDTH  - 1 : w * MEM_IF_BA_WIDTH];
        wire [MEM_IF_ROW_WIDTH - 1 : 0] row_addr  = cmd_row_addr  [(w + 1) * MEM_IF_ROW_WIDTH - 1 : w * MEM_IF_ROW_WIDTH];
        
        always @ (*)
        begin
            // do_activate
            if (cmd_multicast_req [w]) // don't care to_chip during multicast
            begin
                if (do_activate && &to_chip && to_bank_addr == bank_addr && to_row_addr == row_addr)
                    cmd_do_activate [w] = 1'b1;
                else
                    cmd_do_activate [w] = 1'b0;
            end
            else
            begin
                if (do_activate && to_chip [chip_addr] && to_bank_addr == bank_addr && to_row_addr == row_addr)
                    cmd_do_activate [w] = 1'b1;
                else
                    cmd_do_activate [w] = 1'b0;
            end
            
            // do_precharge
            if (cmd_multicast_req [w]) // don't care to_chip during multicast
            begin
                if ((((do_auto_precharge || do_precharge) && to_bank_addr == bank_addr) || do_precharge_all) && &to_chip)
                    cmd_do_precharge [w] = 1'b1;
                else
                    cmd_do_precharge [w] = 1'b0;
            end
            else
            begin
                if ((((do_auto_precharge || do_precharge) && to_bank_addr == bank_addr) || do_precharge_all) && to_chip [chip_addr])
                    cmd_do_precharge [w] = 1'b1;
                else
                    cmd_do_precharge [w] = 1'b0;
            end
        end
        
        // registered version of cmd_do
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                cmd_do_activate_r1  [w] <= 1'b0;
                cmd_do_precharge_r1 [w] <= 1'b0;
            end
            else
            begin
                cmd_do_activate_r1  [w] <= cmd_do_activate  [w];
                cmd_do_precharge_r1 [w] <= cmd_do_precharge [w];
            end
        end
        
        // this signal is required when there is a fetch followed by activate
        // without this signal, tRCD efficiency will be impacted
        always @ (*)
        begin
            int_cmd_do_activate_cached [w] <= cmd_do_activate [w];
        end
        
        // this signal is required when there is a fetch followed by precharge
        // without this signal, efficiency will be affected
        always @ (*)
        begin
            int_cmd_do_precharge_cached [w] <= cmd_do_precharge [w];
        end
    end
end
endgenerate

/* -----------------------------------------------------------------------------
    
    Important Notice:
    
    Currently we remove all RAM instantiation because design doesn't meet fmax
    266.67MHz. To re-design bank logic block with RAM instantiation (customer
    might want to reduce LE counts), they will need to instantiate
    'lookahead depth x chipselects' numbers of RAM (to support multicast, can be
    reduced to 'lookahead depth' numbers of RAM)
    
    Please refer to revision 24 in Perforce for futher reference.
    
------------------------------------------------------------------------------*/
reg [MEM_IF_ROW_WIDTH - 1 : 0] row_information [MEM_IF_CS_WIDTH - 1 : 0] [(2 ** MEM_IF_BA_WIDTH) - 1 : 0];

generate
    genvar x_outer;
    genvar x_inner;
    for (x_outer = 0;x_outer < MEM_IF_CS_WIDTH;x_outer = x_outer + 1)
    begin : row_information_per_chip
        for (x_inner = 0;x_inner < (2 ** MEM_IF_BA_WIDTH);x_inner = x_inner + 1)
        begin : row_information_per_bank
            // row information is used to store row addresses during activate
            // one extra bit is required for each entry to indicate whether the current entry is valid or not
            // this is required to handle non-multicast to multicast request
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    row_information [x_outer][x_inner] <= 0;
                end
                else
                begin
                    if (do_activate && to_chip [x_outer] && x_inner == to_bank_addr)
                        row_information [x_outer][x_inner] <= to_row_addr;
                end
            end
        end
    end
endgenerate

generate
    genvar m_cs;
    genvar m_bank;
    genvar m_rowbit;

    for (m_cs = 0;m_cs < MEM_IF_CS_WIDTH;m_cs = m_cs + 1)
    begin : bank_information_cs
        for (m_bank = 0;m_bank < (2 ** MEM_IF_BA_WIDTH);m_bank = m_bank + 1)
        begin : bank_information_bank
             
            wire [MEM_IF_ROW_WIDTH - 1 : 0] bankaware_row   = row_information[m_cs] [m_bank];
            wire                            bankaware_open  = bank_status    [m_cs] [m_bank];

            assign bank_open[m_cs * (2 ** MEM_IF_BA_WIDTH) + m_bank] = bankaware_open;

            for (m_rowbit = 0; m_rowbit < MEM_IF_ROW_WIDTH; m_rowbit = m_rowbit + 1)
            begin : bank_information_row
                assign bank_information[ ( (m_cs * (2 ** MEM_IF_BA_WIDTH) * MEM_IF_ROW_WIDTH) + (m_bank * MEM_IF_ROW_WIDTH) + m_rowbit) ] = bankaware_row[m_rowbit];
            end

        end
    end
endgenerate

generate
    genvar z;
    genvar z_inner;
    for (z = 0; z < CTL_LOOK_AHEAD_DEPTH + 1;z = z + 1)
    begin : CMD
        reg [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] int_cmd_addr_r1;
        reg [MEM_IF_CS_WIDTH - 1 : 0]  int_cmd_row_is_open;
        reg [MEM_IF_CS_WIDTH - 1 : 0]  int_cmd_to_chip;
        reg [MEM_IF_CS_WIDTH - 1 : 0]  int_cmd_to_chip_r1;
        reg [MEM_IF_CS_WIDTH - 1 : 0]  int_cmd_bank_is_open;
        reg int_cmd_multicast_req_r1;
        
        wire [(MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH) - 1 : 0] int_cmd_addr;
        wire [MEM_IF_CHIP_BITS - 1 : 0] int_cmd_chip_addr;
        wire [MEM_IF_ROW_WIDTH - 1 : 0] int_cmd_row_addr;
        wire [MEM_IF_BA_WIDTH - 1 : 0]  int_cmd_bank_addr;
        wire [MEM_IF_CHIP_BITS - 1 : 0] int_cmd_chip_addr_r1;
        wire [MEM_IF_ROW_WIDTH - 1 : 0] int_cmd_row_addr_r1;
        wire [MEM_IF_BA_WIDTH - 1 : 0]  int_cmd_bank_addr_r1;
        wire [MEM_IF_CS_WIDTH * MEM_IF_ROW_WIDTH - 1 : 0] int_cmd_ram_rd_data;
        wire int_cmd_multicast_req;
        
        // Addr Signals
        assign int_cmd_addr          = cmd_addr[((z + 1) * (MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH)) - 1 : (z * (MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH))];
        assign int_cmd_chip_addr     = int_cmd_addr [MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH - 1 : MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH];
        assign int_cmd_bank_addr     = int_cmd_addr [MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH - 1 : MEM_IF_ROW_WIDTH];
        assign int_cmd_row_addr      = int_cmd_addr [MEM_IF_ROW_WIDTH - 1 : 0];
        assign int_cmd_chip_addr_r1  = int_cmd_addr_r1 [MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH - 1 : MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH];
        assign int_cmd_bank_addr_r1  = int_cmd_addr_r1 [MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH - 1 : MEM_IF_ROW_WIDTH];
        assign int_cmd_row_addr_r1   = int_cmd_addr_r1 [MEM_IF_ROW_WIDTH - 1 : 0];
        
        // Multicast request
        assign int_cmd_multicast_req = cmd_multicast_req [z];
        
        // Convert chip_addr to to_chip
        always @ (*)
        begin
            // Set all to zero then set the chip bit to one
            int_cmd_to_chip = 0;
            int_cmd_to_chip [int_cmd_chip_addr] = 1'b1;
        end
        
        // CMD registers
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_cmd_addr_r1 <= 0;
            end
            else
            begin
                int_cmd_addr_r1 <= int_cmd_addr;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_cmd_to_chip_r1 <= 0;
            end
            else
            begin
                int_cmd_to_chip_r1 <= int_cmd_to_chip;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_cmd_multicast_req_r1 <= 1'b0;
            end
            else
            begin
                int_cmd_multicast_req_r1 <= int_cmd_multicast_req;
            end
        end
        
        // bank open signal
        always @ (*)
        begin
            // setting this signal to '0' more important than setting it to '1'
            // setting it to '1' later will only cause in-efficiency but not functional failure
            if (cmd_do_precharge_cached [z])
                cmd_bank_is_open [z] = 1'b0;
            else if (cmd_do_precharge_r1 [z])
                cmd_bank_is_open [z] = 1'b0;
            else if (cmd_do_activate_cached [z])
                cmd_bank_is_open [z] = 1'b1;
            else if (cmd_do_activate_r1 [z])
                cmd_bank_is_open [z] = 1'b1;
            else
            begin
                if (int_cmd_multicast_req_r1)
                    cmd_bank_is_open [z] = |int_cmd_bank_is_open;
                else
                    cmd_bank_is_open [z] = int_cmd_bank_is_open [int_cmd_chip_addr_r1];
            end
        end
        
        // row open signal
        always @ (*)
        begin
            if (cmd_do_activate_cached [z])
                cmd_row_is_open [z] = 1'b1;
            else if (cmd_do_activate_r1 [z])
                cmd_row_is_open [z] = 1'b1;
            else
            begin
                if (int_cmd_multicast_req_r1)
                    cmd_row_is_open [z] = &int_cmd_row_is_open;
                else
                    cmd_row_is_open [z] = int_cmd_row_is_open [int_cmd_chip_addr_r1];
            end
        end
        
        for (z_inner = 0;z_inner < MEM_IF_CS_WIDTH;z_inner = z_inner + 1)
        begin : row_is_open_loop
            wire [MEM_IF_ROW_WIDTH - 1 : 0] int_read_data = row_information [z_inner][int_cmd_bank_addr];
            wire                            int_bank_data = bank_status     [z_inner][int_cmd_bank_addr];
            
            // assign bank status information
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    int_cmd_bank_is_open [z_inner] <= 1'b0;
                else
                    int_cmd_bank_is_open [z_inner] <= int_bank_data;
            end
            
            // assign read data from row information
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    int_cmd_row_is_open [z_inner] <= 1'b0;
                else
                begin
                    if (int_read_data == int_cmd_row_addr)
                        int_cmd_row_is_open [z_inner] <= 1'b1 & int_bank_data;
                    else
                        int_cmd_row_is_open [z_inner] <= 1'b0;
                end
            end
        end
    end
endgenerate

// Valid signals for command
generate
    genvar Y;
    for (Y = 1; Y < CTL_LOOK_AHEAD_DEPTH + 1;Y = Y + 1)
    begin : VALID
        reg int_cmd_info_valid;
        wire int_cmd_info_valid_r1;
        reg int_cmd_is_valid_r1;
        reg int_cmd_is_valid_r2;
        
        wire int_cmd_is_valid;
        
        assign int_cmd_is_valid = cmd_is_valid [Y];
        assign int_cmd_info_valid_r1 = int_cmd_info_valid;
        assign cmd_info_valid [Y] = int_cmd_info_valid_r1;
        
        
        // Valid signal
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_cmd_info_valid    <= 1'b0;
                //int_cmd_info_valid_r1 <= 1'b0;
            end
            else
            begin
                int_cmd_info_valid    <= int_cmd_is_valid;
                //int_cmd_info_valid_r1 <= int_cmd_info_valid;
            end
        end
    end
endgenerate

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    int_current_info_valid_r <= 1'b0;
    else
    int_current_info_valid_r <= int_current_info_valid;
end

// Valid signal for current command
always @ (*)
begin
    //if (!ctl_reset_n)
    //begin
    //    int_current_info_valid <= 1'b0;
    //end
    //else
    begin
        if (fetch)
            int_current_info_valid <= 1'b0;
        else if (fetch_r2)
            int_current_info_valid <= 1'b1;
        //we will need to deassert current info valid signal for 2 clock cycle so that state machine will not capture the wrong information
        else if (ecc_fetch_error_addr)
            int_current_info_valid <= 1'b0;
        else if (ecc_fetch_error_addr_r2)
            int_current_info_valid <= 1'b1;
        else
            int_current_info_valid <= int_current_info_valid_r;
    end
end
/*------------------------------------------------------------------------------

    General

------------------------------------------------------------------------------*/
// Bank status register
integer i;
integer j;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        for (i = 0;i < MEM_IF_CS_WIDTH;i = i + 1'b1)
        begin : bank_status_init_outer_loop
            bank_status [i] <= 0;
        end
    end
    else
    begin
        i <= 0;
        for (cs_count2 = 0;cs_count2 < MEM_IF_CS_WIDTH;cs_count2 = cs_count2 + 1'b1)
        begin : bank_status_per_chip
            if (to_chip [cs_count2])
            begin
                if (do_precharge_all)
                    bank_status [cs_count2][(2 ** MEM_IF_BA_WIDTH) - 1 : 0] <= 0;
                else if (do_precharge || do_auto_precharge)
                    bank_status [cs_count2][to_bank_addr] <= 1'b0;
                else if (do_activate)
                    bank_status [cs_count2][to_bank_addr] <= 1'b1;
            end
        end
    end
end

// All banks closed signal
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        all_banks_closed <= 0;
    end
    else
    begin
        for (cs_count1 = 0;cs_count1 < MEM_IF_CS_WIDTH;cs_count1 = cs_count1 + 1'b1)
        begin : all_banks_closed_per_chip
            if (do_activate && to_chip[cs_count1]) // need this because after do_activate, all banks closed signal doesn't deassert fast enough
                all_banks_closed [cs_count1] <= 1'b0;
            else if (!(|bank_status [cs_count1][(2 ** MEM_IF_BA_WIDTH) - 1 : 0]))
                all_banks_closed [cs_count1] <= 1'b1;
            else
                all_banks_closed [cs_count1] <= 1'b0;
        end
    end
end

endmodule

/*
// This module (RAM) is not used anymore, this will be commented for future reference
// which will instantiate ram modules
module alt_ddrx_bank_mem #
    ( parameter
        MEM_IF_CS_WIDTH  = 4,
        MEM_IF_CHIP_BITS = 2,
        MEM_IF_BA_WIDTH  = 3,
        MEM_IF_ROW_WIDTH = 16
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // Write Interface
        write_req,
        write_addr,
        write_data,
        
        // Read Interface
        read_addr,
        read_data
    );

localparam RAM_ADDR_WIDTH = 5;

input ctl_clk;
input ctl_reset_n;

input [MEM_IF_CS_WIDTH - 1 : 0]  write_req;
input [MEM_IF_BA_WIDTH - 1 : 0]  write_addr;
input [MEM_IF_ROW_WIDTH - 1 : 0] write_data;

input  [MEM_IF_BA_WIDTH - 1 : 0] read_addr;
output [(MEM_IF_CS_WIDTH * MEM_IF_ROW_WIDTH) - 1 : 0] read_data;

wire   [(MEM_IF_CS_WIDTH * MEM_IF_ROW_WIDTH) - 1 : 0] read_data;

generate
    genvar z;
    for (z = 0;z < MEM_IF_CS_WIDTH;z = z + 1)
    begin : ram_inst_per_chip
        ram ram_inst
            (
                .clock (ctl_clk),
                .wren (write_req [z]),
                .wraddress ({{(RAM_ADDR_WIDTH - MEM_IF_BA_WIDTH){1'b0}}, write_addr}),
                .data (write_data),
                .rdaddress ({{(RAM_ADDR_WIDTH - MEM_IF_BA_WIDTH){1'b0}}, read_addr [MEM_IF_BA_WIDTH - 1 : 0]}),
                .q (read_data [(z + 1) * MEM_IF_ROW_WIDTH - 1 : z * MEM_IF_ROW_WIDTH])
            );
    end
endgenerate

endmodule
*/
