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
// File          : alt_ddrx_cache.v
//
// Abstract      : 
///////////////////////////////////////////////////////////////////////////////

module alt_ddrx_cache #
    ( parameter
        // controller settings
        MEM_IF_CHIP_BITS                          = 2,
        MEM_IF_CS_WIDTH                           = 4,
        MEM_IF_ROW_WIDTH                          = 16,            // max supported row bits
        MEM_IF_BA_WIDTH                           = 3,             // max supported bank bits
        MEM_TYPE                                  = "DDR3",
        
        DWIDTH_RATIO                              = 2,             // 2 - fullrate, 4 - halfrate
        CLOSE_PAGE_POLICY                         = 1,
        
        CTL_LOOK_AHEAD_DEPTH                      = 4,
        CTL_CMD_QUEUE_DEPTH                       = 8
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // state machine inputs
        fetch,
        
        // ecc inputs
        ecc_fetch_error_addr,
        
        // command queue inputs
        cmd_is_valid,
        
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

// state machine inputs
input  fetch;

// ecc inputs
input  ecc_fetch_error_addr;

// command queue inputs
input  [CTL_CMD_QUEUE_DEPTH  : 0] cmd_is_valid;

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
        Cache Logic
    ------------------------------------------------------------------------------*/
    reg                             cache;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_bank_is_open;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_row_is_open;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_write;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_read;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_activate;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_precharge;
    
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_all_banks_closed;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_precharge_all;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_refresh;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_self_refresh;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_power_down;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_can_exit_power_saving_mode;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_zq_cal_req;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_power_down_req;
    wire [MEM_IF_CS_WIDTH - 1  : 0] out_cs_refresh_req;
    
    /*------------------------------------------------------------------------------
        Command Valid Logic
    ------------------------------------------------------------------------------*/
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] out_cmd_info_valid;
    reg  [CTL_LOOK_AHEAD_DEPTH : 0] int_cmd_info_valid;
    reg                             int_current_info_valid_r1;
    reg                             fetch_r1;
    reg                             ecc_fetch_error_addr_r1;
    
    /*------------------------------------------------------------------------------
        Assignment
    ------------------------------------------------------------------------------*/
    // no changes made to these signals
    assign out_cs_all_banks_closed           = in_cs_all_banks_closed;
    assign out_cs_can_precharge_all          = in_cs_can_precharge_all;
    assign out_cs_can_refresh                = in_cs_can_refresh;
    assign out_cs_can_self_refresh           = in_cs_can_self_refresh;
    assign out_cs_can_power_down             = in_cs_can_power_down;
    assign out_cs_can_exit_power_saving_mode = in_cs_can_exit_power_saving_mode;
    assign out_cs_zq_cal_req                 = in_cs_zq_cal_req;
    assign out_cs_power_down_req             = in_cs_power_down_req;
    assign out_cs_refresh_req                = in_cs_refresh_req;
    
/*------------------------------------------------------------------------------

    [END] Registers & Wires

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Cache Logic

------------------------------------------------------------------------------*/
    // Determine when to cache
    always @ (*)
    begin
        if (fetch)
            cache = 1'b1;
        else
            cache = 1'b0;
    end
    
    /*------------------------------------------------------------------------------
        Cache Logic
    ------------------------------------------------------------------------------*/
    always @ (*)
    begin
        if (cache)
        begin
            out_cmd_bank_is_open  [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = in_cmd_bank_is_open  [CTL_LOOK_AHEAD_DEPTH : 1];
            out_cmd_can_write     [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = in_cmd_can_write     [CTL_LOOK_AHEAD_DEPTH : 1];
            out_cmd_can_read      [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = in_cmd_can_read      [CTL_LOOK_AHEAD_DEPTH : 1];
            out_cmd_can_activate  [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = in_cmd_can_activate  [CTL_LOOK_AHEAD_DEPTH : 1];
            out_cmd_can_precharge [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = in_cmd_can_precharge [CTL_LOOK_AHEAD_DEPTH : 1];
            out_cmd_info_valid    [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = int_cmd_info_valid   [CTL_LOOK_AHEAD_DEPTH : 1];
            
            out_cmd_bank_is_open  [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            out_cmd_can_write     [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            out_cmd_can_read      [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            out_cmd_can_activate  [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            out_cmd_can_precharge [CTL_LOOK_AHEAD_DEPTH]                                = 0;
            out_cmd_info_valid    [CTL_LOOK_AHEAD_DEPTH]                                = 0;
        end
        else
        begin
            out_cmd_bank_is_open                                                        = in_cmd_bank_is_open;
            out_cmd_can_write                                                           = in_cmd_can_write;
            out_cmd_can_read                                                            = in_cmd_can_read;
            out_cmd_can_activate                                                        = in_cmd_can_activate;
            out_cmd_can_precharge                                                       = in_cmd_can_precharge;
            out_cmd_info_valid                                                          = int_cmd_info_valid;
        end
    end
    
    always @ (*)
    begin
        if (cache || fetch_r1)
        begin
            out_cmd_row_is_open   [CTL_LOOK_AHEAD_DEPTH - 1 :                        0] = in_cmd_row_is_open   [CTL_LOOK_AHEAD_DEPTH : 1];
            out_cmd_row_is_open   [CTL_LOOK_AHEAD_DEPTH]                                = 0;
        end
        else
        begin
            out_cmd_row_is_open                                                         = in_cmd_row_is_open;
        end
    end
/*------------------------------------------------------------------------------

    [END] Cache Logic

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Command Valid Logic

------------------------------------------------------------------------------*/
    // register fetch signals
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            fetch_r1                <= 1'b0;
            ecc_fetch_error_addr_r1 <= 1'b0;
        end
        else
        begin
            fetch_r1                <= fetch;
            ecc_fetch_error_addr_r1 <= ecc_fetch_error_addr;
        end
    end
    
    // Command valid logic
    generate
        genvar z_lookahead;
        for (z_lookahead = 1; z_lookahead < CTL_LOOK_AHEAD_DEPTH + 1;z_lookahead = z_lookahead + 1)
        begin : cmd_valid_logic_per_lookahead
            always @ (*)
            begin
                int_cmd_info_valid [z_lookahead] = cmd_is_valid [z_lookahead];
            end
        end
    endgenerate
    
    // Current valid logic
    always @ (*)
    begin
        if (fetch)
            int_cmd_info_valid [0] = 1'b0;
        else if (fetch_r1)
            int_cmd_info_valid [0] = 1'b1;
        //we will need to deassert current info valid signal for 2 clock cycle so that state machine will not capture the wrong information
        else if (ecc_fetch_error_addr)
            int_cmd_info_valid [0] = 1'b0;
        else if (ecc_fetch_error_addr_r1)
            int_cmd_info_valid [0] = 1'b1;
        else
            int_cmd_info_valid [0] = int_current_info_valid_r1;
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
            int_current_info_valid_r1 <= 1'b0;
        else
            int_current_info_valid_r1 <= int_cmd_info_valid [0];
    end
/*------------------------------------------------------------------------------

    [END] Command Valid Logic

------------------------------------------------------------------------------*/













endmodule
