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

///////////////////////////////////////////////////////////////////////////////
// Title         : 
//
// File          : alt_ddrx_bypass.v
//
// Abstract      : 
///////////////////////////////////////////////////////////////////////////////

module alt_ddrx_bypass #
    ( parameter
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS                          = 2,
        MEM_IF_CS_WIDTH                           = 4,
        MEM_IF_ROW_WIDTH                          = 16,            // max supported row bits
        MEM_IF_BA_WIDTH                           = 3,             // max supported bank bits
        
        CLOSE_PAGE_POLICY                         = 1,
        
        // controller settings
        CTL_LOOK_AHEAD_DEPTH                      = 4,
        CTL_CMD_QUEUE_DEPTH                       = 8
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // command queue entry inputs
        cmd_chip_addr,
        cmd_bank_addr,
        cmd_row_addr,
        cmd_multicast_req,
        
        // state machine command inputs
        do_write,
        do_read,
        do_burst_chop,
        do_auto_precharge,
        do_activate,
        do_precharge,
        do_precharge_all,
        do_refresh,
        do_power_down,
        do_self_rfsh,
        
        to_chip,
        to_bank_addr,
        to_row_addr,
        
        fetch,
        
        // timing param inputs
        more_than_x0_act_to_rdwr,
        more_than_x0_act_to_pch,
        more_than_x0_act_to_act,
        more_than_x0_rd_to_rd,
        more_than_x0_rd_to_wr,
        more_than_x0_rd_to_wr_bc,
        more_than_x0_rd_to_pch,
        more_than_x0_wr_to_wr,
        more_than_x0_wr_to_rd,
        more_than_x0_wr_to_pch,
        more_than_x0_rd_ap_to_act,
        more_than_x0_wr_ap_to_act,
        more_than_x0_pch_to_act,
        more_than_x0_act_to_act_diff_bank,
        more_than_x0_four_act_to_act,
        
        less_than_x0_act_to_rdwr,
        less_than_x0_act_to_pch,
        less_than_x0_act_to_act,
        less_than_x0_rd_to_rd,
        less_than_x0_rd_to_wr,
        less_than_x0_rd_to_wr_bc,
        less_than_x0_rd_to_pch,
        less_than_x0_wr_to_wr,
        less_than_x0_wr_to_rd,
        less_than_x0_wr_to_rd_diff_chips,
        less_than_x0_wr_to_pch,
        less_than_x0_rd_ap_to_act,
        less_than_x0_wr_ap_to_act,
        less_than_x0_pch_to_act,
        less_than_x0_act_to_act_diff_bank,
        less_than_x0_four_act_to_act,
        
        more_than_x1_act_to_rdwr,
        more_than_x1_act_to_pch,
        more_than_x1_act_to_act,
        more_than_x1_rd_to_rd,
        more_than_x1_rd_to_wr,
        more_than_x1_rd_to_wr_bc,
        more_than_x1_rd_to_pch,
        more_than_x1_wr_to_wr,
        more_than_x1_wr_to_rd,
        more_than_x1_wr_to_pch,
        more_than_x1_rd_ap_to_act,
        more_than_x1_wr_ap_to_act,
        more_than_x1_pch_to_act,
        more_than_x1_act_to_act_diff_bank,
        more_than_x1_four_act_to_act,
        
        less_than_x1_act_to_rdwr,
        less_than_x1_act_to_pch,
        less_than_x1_act_to_act,
        less_than_x1_rd_to_rd,
        less_than_x1_rd_to_wr,
        less_than_x1_rd_to_wr_bc,
        less_than_x1_rd_to_pch,
        less_than_x1_wr_to_wr,
        less_than_x1_wr_to_rd,
        less_than_x1_wr_to_rd_diff_chips,
        less_than_x1_wr_to_pch,
        less_than_x1_rd_ap_to_act,
        less_than_x1_wr_ap_to_act,
        less_than_x1_pch_to_act,
        less_than_x1_act_to_act_diff_bank,
        less_than_x1_four_act_to_act,
        
        more_than_x2_act_to_rdwr,
        more_than_x2_act_to_pch,
        more_than_x2_act_to_act,
        more_than_x2_rd_to_rd,
        more_than_x2_rd_to_wr,
        more_than_x2_rd_to_wr_bc,
        more_than_x2_rd_to_pch,
        more_than_x2_wr_to_wr,
        more_than_x2_wr_to_rd,
        more_than_x2_wr_to_pch,
        more_than_x2_rd_ap_to_act,
        more_than_x2_wr_ap_to_act,
        more_than_x2_pch_to_act,
        more_than_x2_act_to_act_diff_bank,
        more_than_x2_four_act_to_act,
        
        less_than_x2_act_to_rdwr,
        less_than_x2_act_to_pch,
        less_than_x2_act_to_act,
        less_than_x2_rd_to_rd,
        less_than_x2_rd_to_wr,
        less_than_x2_rd_to_wr_bc,
        less_than_x2_rd_to_pch,
        less_than_x2_wr_to_wr,
        less_than_x2_wr_to_rd,
        less_than_x2_wr_to_rd_diff_chips,
        less_than_x2_wr_to_pch,
        less_than_x2_rd_ap_to_act,
        less_than_x2_wr_ap_to_act,
        less_than_x2_pch_to_act,
        less_than_x2_act_to_act_diff_bank,
        less_than_x2_four_act_to_act,
        
        // rank monitor inputs
        read_dqs_ready,
        write_dqs_ready,
        write_to_read_finish_twtr,
        
        // command inputs
        in_cs_all_banks_closed,
        in_cs_can_precharge_all,
        in_cs_can_refresh,
        in_cs_can_self_refresh,
        in_cs_can_power_down,
        in_cs_can_exit_power_saving_mode,
        in_cs_zq_cal_req,
        in_cs_power_down_req,
        in_cs_refresh_req,
        in_cmd_bank_is_open,
        in_cmd_row_is_open,
        in_cmd_can_write,
        in_cmd_can_read,
        in_cmd_can_activate,
        in_cmd_can_precharge,
        in_cmd_info_valid,
        
        // command outputs
        out_cs_all_banks_closed,
        out_cs_can_precharge_all,
        out_cs_can_refresh,
        out_cs_can_self_refresh,
        out_cs_can_power_down,
        out_cs_can_exit_power_saving_mode,
        out_cs_zq_cal_req,
        out_cs_power_down_req,
        out_cs_refresh_req,
        out_cmd_bank_is_open,
        out_cmd_row_is_open,
        out_cmd_can_write,
        out_cmd_can_read,
        out_cmd_can_activate,
        out_cmd_can_precharge,
        out_cmd_info_valid
    );

input  ctl_clk;
input  ctl_reset_n;

// command queue entry inputs
input  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_CHIP_BITS - 1 : 0] cmd_chip_addr;
input  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_BA_WIDTH  - 1 : 0] cmd_bank_addr;
input  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_ROW_WIDTH - 1 : 0] cmd_row_addr;
input  [CTL_CMD_QUEUE_DEPTH                              : 0] cmd_multicast_req;

// state machine command outputs
input  do_write;
input  do_read;
input  do_burst_chop;
input  do_auto_precharge;
input  do_activate;
input  do_precharge;
input  do_precharge_all;
input  do_refresh;
input  do_power_down;
input  do_self_rfsh;

input  [MEM_IF_CS_WIDTH  - 1 : 0] to_chip;
input  [MEM_IF_BA_WIDTH  - 1 : 0] to_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] to_row_addr;

input  fetch;

// timing param inputs
input  more_than_x0_act_to_rdwr;
input  more_than_x0_act_to_pch;
input  more_than_x0_act_to_act;
input  more_than_x0_rd_to_rd;
input  more_than_x0_rd_to_wr;
input  more_than_x0_rd_to_wr_bc;
input  more_than_x0_rd_to_pch;
input  more_than_x0_wr_to_wr;
input  more_than_x0_wr_to_rd;
input  more_than_x0_wr_to_pch;
input  more_than_x0_rd_ap_to_act;
input  more_than_x0_wr_ap_to_act;
input  more_than_x0_pch_to_act;
input  more_than_x0_act_to_act_diff_bank;
input  more_than_x0_four_act_to_act;

input  less_than_x0_act_to_rdwr;
input  less_than_x0_act_to_pch;
input  less_than_x0_act_to_act;
input  less_than_x0_rd_to_rd;
input  less_than_x0_rd_to_wr;
input  less_than_x0_rd_to_wr_bc;
input  less_than_x0_rd_to_pch;
input  less_than_x0_wr_to_wr;
input  less_than_x0_wr_to_rd;
input  less_than_x0_wr_to_rd_diff_chips;
input  less_than_x0_wr_to_pch;
input  less_than_x0_rd_ap_to_act;
input  less_than_x0_wr_ap_to_act;
input  less_than_x0_pch_to_act;
input  less_than_x0_act_to_act_diff_bank;
input  less_than_x0_four_act_to_act;

input  more_than_x1_act_to_rdwr;
input  more_than_x1_act_to_pch;
input  more_than_x1_act_to_act;
input  more_than_x1_rd_to_rd;
input  more_than_x1_rd_to_wr;
input  more_than_x1_rd_to_wr_bc;
input  more_than_x1_rd_to_pch;
input  more_than_x1_wr_to_wr;
input  more_than_x1_wr_to_rd;
input  more_than_x1_wr_to_pch;
input  more_than_x1_rd_ap_to_act;
input  more_than_x1_wr_ap_to_act;
input  more_than_x1_pch_to_act;
input  more_than_x1_act_to_act_diff_bank;
input  more_than_x1_four_act_to_act;

input  less_than_x1_act_to_rdwr;
input  less_than_x1_act_to_pch;
input  less_than_x1_act_to_act;
input  less_than_x1_rd_to_rd;
input  less_than_x1_rd_to_wr;
input  less_than_x1_rd_to_wr_bc;
input  less_than_x1_rd_to_pch;
input  less_than_x1_wr_to_wr;
input  less_than_x1_wr_to_rd;
input  less_than_x1_wr_to_rd_diff_chips;
input  less_than_x1_wr_to_pch;
input  less_than_x1_rd_ap_to_act;
input  less_than_x1_wr_ap_to_act;
input  less_than_x1_pch_to_act;
input  less_than_x1_act_to_act_diff_bank;
input  less_than_x1_four_act_to_act;

input  more_than_x2_act_to_rdwr;
input  more_than_x2_act_to_pch;
input  more_than_x2_act_to_act;
input  more_than_x2_rd_to_rd;
input  more_than_x2_rd_to_wr;
input  more_than_x2_rd_to_wr_bc;
input  more_than_x2_rd_to_pch;
input  more_than_x2_wr_to_wr;
input  more_than_x2_wr_to_rd;
input  more_than_x2_wr_to_pch;
input  more_than_x2_rd_ap_to_act;
input  more_than_x2_wr_ap_to_act;
input  more_than_x2_pch_to_act;
input  more_than_x2_act_to_act_diff_bank;
input  more_than_x2_four_act_to_act;

input  less_than_x2_act_to_rdwr;
input  less_than_x2_act_to_pch;
input  less_than_x2_act_to_act;
input  less_than_x2_rd_to_rd;
input  less_than_x2_rd_to_wr;
input  less_than_x2_rd_to_wr_bc;
input  less_than_x2_rd_to_pch;
input  less_than_x2_wr_to_wr;
input  less_than_x2_wr_to_rd;
input  less_than_x2_wr_to_rd_diff_chips;
input  less_than_x2_wr_to_pch;
input  less_than_x2_rd_ap_to_act;
input  less_than_x2_wr_ap_to_act;
input  less_than_x2_pch_to_act;
input  less_than_x2_act_to_act_diff_bank;
input  less_than_x2_four_act_to_act;

// rank monitor inputs
input                             read_dqs_ready;
input                             write_dqs_ready;
input  [MEM_IF_CS_WIDTH - 1  : 0] write_to_read_finish_twtr;

// command inputs
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_all_banks_closed;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_can_precharge_all;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_can_refresh;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_can_self_refresh;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_can_power_down;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_can_exit_power_saving_mode;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_zq_cal_req;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_power_down_req;
input  [MEM_IF_CS_WIDTH - 1  : 0] in_cs_refresh_req;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_bank_is_open;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_row_is_open;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_can_write;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_can_read;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_can_activate;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_can_precharge;
input  [CTL_LOOK_AHEAD_DEPTH : 0] in_cmd_info_valid;

// command outputs
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_all_banks_closed;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_precharge_all;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_refresh;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_self_refresh;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_power_down;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_exit_power_saving_mode;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_zq_cal_req;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_power_down_req;
output [MEM_IF_CS_WIDTH - 1  : 0] out_cs_refresh_req;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_bank_is_open;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_row_is_open;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_write;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_read;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_activate;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_precharge;
output [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_info_valid;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Registers & Wires

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Bypass Input Logic
    ------------------------------------------------------------------------------*/
    reg  do_write_r1;
    reg  do_read_r1;
    reg  do_activate_r1;
    reg  do_auto_precharge_r1;
    reg  do_precharge_all_r1;
    reg  do_refresh_r1;
    
    reg  [MEM_IF_CS_WIDTH  - 1 : 0] to_chip_r1;
    reg  [MEM_IF_BA_WIDTH  - 1 : 0] to_bank_addr_r1;
    reg  [MEM_IF_ROW_WIDTH - 1 : 0] to_row_addr_r1;
    
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_open;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_open_row;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_read;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_write;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_close;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_open_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_open_row_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_read_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_write_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_close_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_open;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_open_row;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_read;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_write;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_close;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_open_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_open_row_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_read_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_write_r1;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] cmd_close_r1;
    reg                             cache;
    reg                             cache_r1;
    
    /*------------------------------------------------------------------------------
        Bypass Logic
    ------------------------------------------------------------------------------*/
    reg  [MEM_IF_CS_WIDTH - 1  : 0] out_cs_all_banks_closed;
    reg  [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_precharge_all;
    reg  [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_refresh;
    reg  [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_self_refresh;
    reg  [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_power_down;
    reg  [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_exit_power_saving_mode;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_bank_is_open;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_row_is_open;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_info_valid;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_write;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_read;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_activate;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_precharge;
    
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_zq_cal_req;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_power_down_req;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_refresh_req;
    
    /*------------------------------------------------------------------------------
        Assignment
    ------------------------------------------------------------------------------*/
    assign out_cs_zq_cal_req     = in_cs_zq_cal_req;
    assign out_cs_power_down_req = in_cs_power_down_req;
    assign out_cs_refresh_req    = in_cs_refresh_req;
    
/*------------------------------------------------------------------------------

    [END] Registers & Wires

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Bypass Input Logic

------------------------------------------------------------------------------*/
    // Register do_* inputs
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            do_write_r1          <= 1'b0;
            do_read_r1           <= 1'b0;
            do_activate_r1       <= 1'b0;
            do_auto_precharge_r1 <= 1'b0;
            do_precharge_all_r1  <= 1'b0;
            do_refresh_r1        <= 1'b0;
        end
        else
        begin
            do_write_r1          <= do_write;
            do_read_r1           <= do_read;
            do_activate_r1       <= do_activate;
            do_auto_precharge_r1 <= do_auto_precharge;
            do_precharge_all_r1  <= do_precharge_all;
            do_refresh_r1        <= do_refresh;
        end
    end
    
    // Register to_* inputs
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
    
    generate
        genvar z_lookahead;
        for (z_lookahead = 0;z_lookahead < CTL_LOOK_AHEAD_DEPTH + 1;z_lookahead = z_lookahead + 1)
        begin : bypass_input_logic_per_lookahead
            reg int_cmd_same_bank;
            reg int_cmd_same_row;
            
            wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(z_lookahead + 1) * MEM_IF_CHIP_BITS - 1 : z_lookahead * MEM_IF_CHIP_BITS];
            wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(z_lookahead + 1) * MEM_IF_BA_WIDTH  - 1 : z_lookahead * MEM_IF_BA_WIDTH ];
            wire [MEM_IF_ROW_WIDTH - 1 : 0] row_addr  = cmd_row_addr  [(z_lookahead + 1) * MEM_IF_ROW_WIDTH - 1 : z_lookahead * MEM_IF_ROW_WIDTH];
            
            wire zero = 1'b0;
            
            // same bank signal
            always @ (*)
            begin
                if (to_bank_addr == bank_addr)
                    int_cmd_same_bank = 1'b1;
                else
                    int_cmd_same_bank = 1'b0;
            end
            
            // same row signal
            // OPP if (!CLOSE_PAGE_POLICY) // only enable in open-page policy
            // OPP begin
            // OPP     always @ (*)
            // OPP     begin
            // OPP         if (to_row_addr == row_addr)
            // OPP             int_cmd_same_row = 1'b1;
            // OPP         else
            // OPP             int_cmd_same_row = 1'b0;
            // OPP     end
            // OPP end
            // OPP else
            // OPP begin
                // always assign open row to '0' during close page policy
                always @ (*)
                begin
                    int_cmd_open_row [z_lookahead] = zero;
                end
            // OPP end
            
            // open signal combinatorial
            always @ (*)
            begin
                if (cmd_multicast_req [z_lookahead])
                begin
                    if (do_activate && int_cmd_same_bank)
                        int_cmd_open [z_lookahead] = 1'b1;
                    else
                        int_cmd_open [z_lookahead] = 1'b0;
                end
                else
                begin
                    if (do_activate && to_chip [chip_addr] && int_cmd_same_bank)
                        int_cmd_open [z_lookahead] = 1'b1;
                    else
                        int_cmd_open [z_lookahead] = 1'b0;
                end
            end
            
            // close signal combinatorial
            always @ (*)
            begin
                if (cmd_multicast_req [z_lookahead])
                begin
                    if (((do_precharge || do_auto_precharge) && int_cmd_same_bank) || do_precharge_all)
                        int_cmd_close [z_lookahead] = 1'b1;
                    else
                        int_cmd_close [z_lookahead] = 1'b0;
                end
                else
                begin
                    if (((do_precharge || do_auto_precharge) && to_chip [chip_addr] && int_cmd_same_bank) || (do_precharge_all && to_chip [chip_addr]))
                        int_cmd_close [z_lookahead] = 1'b1;
                    else
                        int_cmd_close [z_lookahead] = 1'b0;
                end
            end
            
            // read signal combinatorial
            always @ (*)
            begin
                if (cmd_multicast_req [z_lookahead])
                begin
                    if (do_read && int_cmd_same_bank)
                        int_cmd_read [z_lookahead] = 1'b1;
                    else
                        int_cmd_read [z_lookahead] = 1'b0;
                end
                else
                begin
                    if (do_read && to_chip [chip_addr] && int_cmd_same_bank)
                        int_cmd_read [z_lookahead] = 1'b1;
                    else
                        int_cmd_read [z_lookahead] = 1'b0;
                end
            end
            
            // write signal combinatorial
            always @ (*)
            begin
                if (cmd_multicast_req [z_lookahead])
                begin
                    if (do_write && int_cmd_same_bank)
                        int_cmd_write [z_lookahead] = 1'b1;
                    else
                        int_cmd_write [z_lookahead] = 1'b0;
                end
                else
                begin
                    if (do_write && to_chip [chip_addr] && int_cmd_same_bank)
                        int_cmd_write [z_lookahead] = 1'b1;
                    else
                        int_cmd_write [z_lookahead] = 1'b0;
                end
            end
            
            // open row signal combinatorial
            always @ (*)
            begin
                int_cmd_open_row [z_lookahead] = int_cmd_same_row;
            end
            
            // open / open row / read / write / close signal registered
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_cmd_open_r1     [z_lookahead] <= 1'b0;
                    int_cmd_open_row_r1 [z_lookahead] <= 1'b0;
                    int_cmd_read_r1     [z_lookahead] <= 1'b0;
                    int_cmd_write_r1    [z_lookahead] <= 1'b0;
                    int_cmd_close_r1    [z_lookahead] <= 1'b0;
                end
                else
                begin
                    int_cmd_open_r1     [z_lookahead] <= int_cmd_open     [z_lookahead];
                    int_cmd_open_row_r1 [z_lookahead] <= int_cmd_open_row [z_lookahead];
                    int_cmd_read_r1     [z_lookahead] <= int_cmd_read     [z_lookahead];
                    int_cmd_write_r1    [z_lookahead] <= int_cmd_write    [z_lookahead];
                    int_cmd_close_r1    [z_lookahead] <= int_cmd_close    [z_lookahead];
                end
            end
        end
    endgenerate
    
    /*------------------------------------------------------------------------------
        Open/Close Cache Logic
    ------------------------------------------------------------------------------*/
    // Determine when to cache
    always @ (*)
    begin
        if (fetch)
            cache = 1'b1;
        else
            cache = 1'b0;
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
            cache_r1 <= 1'b0;
        else
        begin
            if (fetch)
                cache_r1 <= 1'b1;
            else
                cache_r1 <= 1'b0;
        end
    end
    
    // Cache logic
    // we need to cache cmd_open / cmd_open_r1 and cmd_open_row / cmd_open_row_r1 / cmd_close / cmd_close_r1
    // we only need to cache cmd_read_r1 / cmd_write_r1 because read/write only can be issued before or after a fetch
    // Activate   ----------X  ACT  X----------
    // Fetch      X           Fetch           X
    //
    // Precharge  ----------X  PCH  X----------
    // Fetch      X           Fetch           X
    //
    // Read/Write ----------X RD/WR X----------
    // Fetch      X  Fetch  X-------X  Fetch  X
    
    always @ (*)
    begin
        cmd_read  = int_cmd_read;
        cmd_write = int_cmd_write;
        
        if (cache)
        begin
            cmd_open        [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_open        [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_open_r1     [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_open_r1     [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_open_row    [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_open_row    [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_open_row_r1 [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_open_row_r1 [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_read_r1     [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_read_r1     [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_write_r1    [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_write_r1    [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_close       [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_close       [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_close_r1    [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_close_r1    [CTL_LOOK_AHEAD_DEPTH : 1];
            
            cmd_open        [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_open_r1     [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_open_row    [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_open_row_r1 [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_read_r1     [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_write_r1    [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_close       [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_close_r1    [CTL_LOOK_AHEAD_DEPTH]                                = 0;
        end
        else if (cache_r1)
        begin
            cmd_open                                                              = int_cmd_open;
            cmd_open_row                                                          = int_cmd_open_row;
            cmd_close                                                             = int_cmd_close;
            
            cmd_open_r1     [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_open_r1     [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_open_row_r1 [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_open_row_r1 [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_read_r1     [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_read_r1     [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_write_r1    [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_write_r1    [CTL_LOOK_AHEAD_DEPTH : 1];
            cmd_close_r1    [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_close_r1    [CTL_LOOK_AHEAD_DEPTH : 1];
            
            cmd_open_r1     [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_open_row_r1 [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_read_r1     [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_write_r1    [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            cmd_close_r1    [CTL_LOOK_AHEAD_DEPTH]                                = 0;
        end
        else
        begin
            cmd_open                                                              = int_cmd_open;
            cmd_open_r1                                                           = int_cmd_open_r1;
            cmd_open_row                                                          = int_cmd_open_row;
            cmd_open_row_r1                                                       = int_cmd_open_row_r1;
            cmd_read_r1                                                           = int_cmd_read_r1;
            cmd_write_r1                                                          = int_cmd_write_r1;
            cmd_close                                                             = int_cmd_close;
            cmd_close_r1                                                          = int_cmd_close_r1;
        end
    end
    
/*------------------------------------------------------------------------------

    [END] Bypass Input Logic

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Bypass Logic

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Per Command Entry
    ------------------------------------------------------------------------------*/
    generate
        genvar y_lookahead;
        for (y_lookahead = 0;y_lookahead < CTL_LOOK_AHEAD_DEPTH + 1;y_lookahead = y_lookahead + 1)
        begin : bypass_logic_per_lookahead
            wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(y_lookahead + 1) * MEM_IF_CHIP_BITS - 1 : y_lookahead * MEM_IF_CHIP_BITS];
            
            wire zero = 1'b0;
            wire one  = 1'b1;
            
            /*------------------------------------------------------------------------------
                Timer Info
            ------------------------------------------------------------------------------*/
            // write logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cmd_can_write [y_lookahead] <= 1'b0;
                else
                begin
                    if (cmd_open [y_lookahead] && more_than_x1_act_to_rdwr)
                        out_cmd_can_write [y_lookahead] <= 1'b0;
                    else if (cmd_open_r1 [y_lookahead] && more_than_x2_act_to_rdwr)
                        out_cmd_can_write [y_lookahead] <= 1'b0;
                    //else if (cmd_close [y_lookahead])
                    //    out_cmd_can_write [y_lookahead] <= 1'b0;
                    //else if (cmd_close_r1 [y_lookahead])
                    //    out_cmd_can_write [y_lookahead] <= 1'b0;
                    else if (do_read && do_burst_chop && more_than_x2_rd_to_wr_bc)
                        out_cmd_can_write [y_lookahead] <= 1'b0;
                    else if (do_read && !do_burst_chop && more_than_x2_rd_to_wr)
                        out_cmd_can_write [y_lookahead] <= 1'b0;
                    else if (do_write && more_than_x2_wr_to_wr)
                        out_cmd_can_write [y_lookahead] <= 1'b0;
                    else if (cmd_open [y_lookahead] && less_than_x0_act_to_rdwr)    // to increase tRCD efficiency
                        out_cmd_can_write [y_lookahead] <= write_dqs_ready;
                    else if (cmd_open_r1 [y_lookahead] && less_than_x1_act_to_rdwr) // to increase tRCD efficiency
                        out_cmd_can_write [y_lookahead] <= write_dqs_ready;
                    else
                        out_cmd_can_write [y_lookahead] <= in_cmd_can_write [y_lookahead];
                end
            end
            
            // read logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cmd_can_read [y_lookahead] <= 1'b0;
                else
                begin
                    if (cmd_open [y_lookahead] && more_than_x1_act_to_rdwr)
                        out_cmd_can_read [y_lookahead] <= 1'b0;
                    else if (cmd_open_r1 [y_lookahead] && more_than_x2_act_to_rdwr)
                        out_cmd_can_read [y_lookahead] <= 1'b0;
                    //else if (cmd_close [y_lookahead])
                    //    out_cmd_can_read [y_lookahead] <= 1'b0;
                    //else if (cmd_close_r1 [y_lookahead])
                    //    out_cmd_can_read [y_lookahead] <= 1'b0;
                    else if (do_read && more_than_x2_rd_to_rd)
                        out_cmd_can_read [y_lookahead] <= 1'b0;
                    else if (do_write && more_than_x2_wr_to_rd)
                        out_cmd_can_read [y_lookahead] <= 1'b0;
                    else if (cmd_open [y_lookahead] && less_than_x0_act_to_rdwr)    // to increase tRCD efficiency
                        out_cmd_can_read [y_lookahead] <= write_to_read_finish_twtr [chip_addr] & read_dqs_ready;
                    else if (cmd_open_r1 [y_lookahead] && less_than_x1_act_to_rdwr) // to increase tRCD efficiency
                        out_cmd_can_read [y_lookahead] <= write_to_read_finish_twtr [chip_addr] & read_dqs_ready;
                    else
                        out_cmd_can_read [y_lookahead] <= in_cmd_can_read [y_lookahead];
                end
            end
            
            // activate logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cmd_can_activate [y_lookahead] <= 1'b0;
                else
                begin
                    //if (cmd_open [y_lookahead]) // we don't allow activate to and open page
                    //    out_cmd_can_activate [y_lookahead] <= 1'b0;
                    //else if (cmd_open_r1 [y_lookahead]) // we don't allow activate to and open page
                    //    out_cmd_can_activate [y_lookahead] <= 1'b0;
                    if (do_activate && more_than_x1_act_to_act_diff_bank) // tRRD constraint
                        out_cmd_can_activate [y_lookahead] <= 1'b0;
                    else if (cmd_close [y_lookahead])
                        out_cmd_can_activate [y_lookahead] <= 1'b0;
                    else if (cmd_close_r1 [y_lookahead])
                        out_cmd_can_activate [y_lookahead] <= 1'b0;
                    else
                        out_cmd_can_activate [y_lookahead] <= in_cmd_can_activate [y_lookahead];
                end
            end
            
            // precharge logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    out_cmd_can_precharge [y_lookahead] <= 1'b0;
                end
                else
                begin
                    if (cmd_open [y_lookahead] || cmd_open_r1 [y_lookahead])
                        out_cmd_can_precharge [y_lookahead] <= 1'b0;
                    else if (cmd_read [y_lookahead] && more_than_x1_rd_to_pch)
                        out_cmd_can_precharge [y_lookahead] <= 1'b0;
                    else if (cmd_read_r1 [y_lookahead] && more_than_x2_rd_to_pch)
                        out_cmd_can_precharge [y_lookahead] <= 1'b0;
                    else if (cmd_write [y_lookahead] && more_than_x1_wr_to_pch)
                        out_cmd_can_precharge [y_lookahead] <= 1'b0;
                    else if (cmd_write_r1 [y_lookahead] && more_than_x2_wr_to_pch)
                        out_cmd_can_precharge [y_lookahead] <= 1'b0;
                    else
                        out_cmd_can_precharge [y_lookahead] <= in_cmd_can_precharge [y_lookahead];
                end
            end
            
            /*------------------------------------------------------------------------------
                Bank Info
            ------------------------------------------------------------------------------*/
            // bank is open logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cmd_bank_is_open [y_lookahead] <= 1'b0;
                else
                begin
                    if (cmd_open [y_lookahead])
                        out_cmd_bank_is_open [y_lookahead] <= 1'b1;
                    //else if (cmd_open_r1 [y_lookahead])
                    //    out_cmd_bank_is_open [y_lookahead] <= 1'b1;
                    else if (cmd_close [y_lookahead])
                        out_cmd_bank_is_open [y_lookahead] <= 1'b0;
                    //else if (cmd_close_r1 [y_lookahead])
                    //    out_cmd_bank_is_open [y_lookahead] <= 1'b0;
                    else
                        out_cmd_bank_is_open [y_lookahead] <= in_cmd_bank_is_open [y_lookahead];
                end
            end
            
            // row is open logic
            // OPP if (!CLOSE_PAGE_POLICY) // only enable in open-page policy
            // OPP begin
            // OPP     always @ (posedge ctl_clk or negedge ctl_reset_n)
            // OPP     begin
            // OPP         if (!ctl_reset_n)
            // OPP         begin
            // OPP             out_cmd_row_is_open [y_lookahead] <= 1'b0;
            // OPP         end
            // OPP         else
            // OPP         begin
            // OPP             if (cmd_open [y_lookahead] && cmd_open_row [y_lookahead])
            // OPP                 out_cmd_row_is_open [y_lookahead] <= 1'b1;
            // OPP             else if (cmd_open_r1 [y_lookahead] && cmd_open_row_r1 [y_lookahead])
            // OPP                 out_cmd_row_is_open [y_lookahead] <= 1'b1;
            // OPP             else
            // OPP                 out_cmd_row_is_open [y_lookahead] <= in_cmd_row_is_open [y_lookahead];
            // OPP         end
            // OPP     end
            // OPP end
            // OPP else
            // OPP begin
                always @ (*)
                begin
                    out_cmd_row_is_open [y_lookahead] = one;
                end
            // OPP end
            
            // info valid
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cmd_info_valid [y_lookahead] <= 1'b0;
                else
                    out_cmd_info_valid [y_lookahead] <= in_cmd_info_valid [y_lookahead]; // no changes required
            end
        end
    endgenerate
    
    /*------------------------------------------------------------------------------
        Per Rank
    ------------------------------------------------------------------------------*/
    generate
        genvar y_cs;
        for (y_cs = 0;y_cs < MEM_IF_CS_WIDTH;y_cs = y_cs + 1)
        begin : all_banks_closed_logic_per_chip
            /*------------------------------------------------------------------------------
                Timer Info
            ------------------------------------------------------------------------------*/
            // can precharge all logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cs_can_precharge_all [y_cs] <= 1'b0;
                else
                begin
                    if (do_activate && to_chip [y_cs])
                        out_cs_can_precharge_all [y_cs] <= 1'b0;
                    else if (do_activate_r1 && to_chip_r1 [y_cs])
                        out_cs_can_precharge_all [y_cs] <= 1'b0;
                    else if ((do_write || do_read) && to_chip [y_cs])
                        out_cs_can_precharge_all [y_cs] <= 1'b0;
                    else if ((do_write_r1 || do_read_r1) && to_chip_r1 [y_cs])
                        out_cs_can_precharge_all [y_cs] <= 1'b0;
                    else
                        out_cs_can_precharge_all [y_cs] <= in_cs_can_precharge_all [y_cs];
                end
            end
            
            // can refresh logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cs_can_refresh [y_cs] <= 1'b0;
                else
                begin
                    if (do_activate && to_chip [y_cs])
                        out_cs_can_refresh [y_cs] <= 1'b0;
                    else if (do_activate_r1 && to_chip_r1 [y_cs])
                        out_cs_can_refresh [y_cs] <= 1'b0;
                    else if ((do_auto_precharge || do_precharge_all) && to_chip [y_cs])
                        out_cs_can_refresh [y_cs] <= 1'b0;
                    else if ((do_auto_precharge_r1 || do_precharge_all_r1) && to_chip_r1 [y_cs])
                        out_cs_can_refresh [y_cs] <= 1'b0;
                    else if (do_refresh && to_chip [y_cs])
                        out_cs_can_refresh [y_cs] <= 1'b0;
                    else
                        out_cs_can_refresh [y_cs] <= in_cs_can_refresh [y_cs];
                end
            end
            
            // can self refresh logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cs_can_self_refresh [y_cs] <= 1'b0;
                else
                begin
                    if (do_activate && to_chip [y_cs])
                        out_cs_can_self_refresh [y_cs] <= 1'b0;
                    else if (do_activate_r1 && to_chip_r1 [y_cs])
                        out_cs_can_self_refresh [y_cs] <= 1'b0;
                    else if ((do_auto_precharge || do_precharge_all) && to_chip [y_cs])
                        out_cs_can_self_refresh [y_cs] <= 1'b0;
                    else if ((do_auto_precharge_r1 || do_precharge_all_r1) && to_chip_r1 [y_cs])
                        out_cs_can_self_refresh [y_cs] <= 1'b0;
                    else if (do_refresh && to_chip [y_cs])
                        out_cs_can_self_refresh [y_cs] <= 1'b0;
                    else
                        out_cs_can_self_refresh [y_cs] <= in_cs_can_self_refresh [y_cs];
                end
            end
            
            // can power down logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cs_can_power_down [y_cs] <= 1'b0;
                else
                begin
                    if (do_activate && to_chip [y_cs])
                        out_cs_can_power_down [y_cs] <= 1'b0;
                    else if (do_activate_r1 && to_chip_r1 [y_cs])
                        out_cs_can_power_down [y_cs] <= 1'b0;
                    else if ((do_auto_precharge || do_precharge_all) && to_chip [y_cs])
                        out_cs_can_power_down [y_cs] <= 1'b0;
                    else if ((do_auto_precharge_r1 || do_precharge_all_r1) && to_chip_r1 [y_cs])
                        out_cs_can_power_down [y_cs] <= 1'b0;
                    else if (do_refresh && to_chip [y_cs])
                        out_cs_can_power_down [y_cs] <= 1'b0;
                    else if (do_refresh_r1 && to_chip_r1 [y_cs])
                        out_cs_can_power_down [y_cs] <= 1'b0;
                    else
                        out_cs_can_power_down [y_cs] <= in_cs_can_power_down [y_cs];
                end
            end
            
            // can exit power saving logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cs_can_exit_power_saving_mode [y_cs] <= 1'b0;
                else
                    out_cs_can_exit_power_saving_mode [y_cs] <= in_cs_can_exit_power_saving_mode [y_cs];
            end
            
            /*------------------------------------------------------------------------------
                Bank Info
            ------------------------------------------------------------------------------*/
            // all banks closed logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    out_cs_all_banks_closed [y_cs] <= 1'b0;
                else
                begin
                    if (do_activate && to_chip [y_cs])
                        out_cs_all_banks_closed [y_cs] <= 1'b0;
                    else if (do_activate_r1 && to_chip_r1 [y_cs])
                        out_cs_all_banks_closed [y_cs] <= 1'b0;
                    else if (do_precharge_all && to_chip [y_cs])
                        out_cs_all_banks_closed [y_cs] <= 1'b1;
                    else if (do_precharge_all_r1 && to_chip_r1 [y_cs])
                        out_cs_all_banks_closed [y_cs] <= 1'b1;
                    else
                        out_cs_all_banks_closed [y_cs] <= in_cs_all_banks_closed [y_cs];
                end
            end
        end
    endgenerate
    
/*------------------------------------------------------------------------------

    [END] Bypass Logic

------------------------------------------------------------------------------*/



endmodule
