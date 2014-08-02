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
// File          : alt_ddrx_bank_timer_wrapper.v
//
// Abstract      : 
///////////////////////////////////////////////////////////////////////////////

module alt_ddrx_bank_timer_wrapper #
    ( parameter
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS                          = 2,
        MEM_IF_CS_WIDTH                           = 4,
        MEM_IF_BA_WIDTH                           = 3,              // max supported bank bits
        MEM_IF_ROW_WIDTH                          = 16,             // max supported row bits
        MEM_TYPE                                  = "DDR3",
        
        MEMORY_BURSTLENGTH                        = 8,
        DWIDTH_RATIO                              = 2,              // 2 - fullrate, 4 - halfrate
        CLOSE_PAGE_POLICY                         = 1,
        
        MEM_IF_RD_TO_WR_TURNAROUND_OCT            = 0,
        MEM_IF_WR_TO_RD_TURNAROUND_OCT            = 0,
        MEM_IF_WR_TO_RD_DIFF_CHIPS_TURNAROUND_OCT = 0,
        
        // controller settings
        CTL_LOOK_AHEAD_DEPTH                      = 4,
        CTL_CMD_QUEUE_DEPTH                       = 8,
        CTL_USR_REFRESH                           = 0,              // enabled user refresh
        CTL_DYNAMIC_BANK_ALLOCATION               = 0,
        CTL_DYNAMIC_BANK_NUM                      = 4,
        
        // timing parameters width
        CAS_WR_LAT_BUS_WIDTH                      = 4,              // max will be 8 in DDR3
        ADD_LAT_BUS_WIDTH                         = 3,              // max will be 6 in DDR2
        TCL_BUS_WIDTH                             = 4,              // max will be 11 in DDR3
        TRRD_BUS_WIDTH                            = 4,              // 2 - 8
        TFAW_BUS_WIDTH                            = 6,              // 6 - 32
        TRFC_BUS_WIDTH                            = 8,              // 12 - 140?
        TREFI_BUS_WIDTH                           = 13,             // 780 - 6240
        TRCD_BUS_WIDTH                            = 4,              // 2 - 11
        TRP_BUS_WIDTH                             = 4,              // 2 - 11
        TWR_BUS_WIDTH                             = 4,              // 2 - 12
        TWTR_BUS_WIDTH                            = 4,              // 1 - 10
        TRTP_BUS_WIDTH                            = 4,              // 2 - 8
        TRAS_BUS_WIDTH                            = 5,              // 4 - 29
        TRC_BUS_WIDTH                             = 6,              // 8 - 40
        AUTO_PD_BUS_WIDTH                         = 16              // same as CSR
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // command queue entry inputs
        cmd0_is_valid,
        cmd0_chip_addr,
        cmd0_bank_addr,
        cmd0_row_addr,
        cmd0_multicast_req,
        
        cmd1_is_valid,
        cmd1_chip_addr,
        cmd1_bank_addr,
        cmd1_row_addr,
        cmd1_multicast_req,
        
        cmd2_is_valid,
        cmd2_chip_addr,
        cmd2_bank_addr,
        cmd2_row_addr,
        cmd2_multicast_req,
        
        cmd3_is_valid,
        cmd3_chip_addr,
        cmd3_bank_addr,
        cmd3_row_addr,
        cmd3_multicast_req,
        
        cmd4_is_valid,
        cmd4_chip_addr,
        cmd4_bank_addr,
        cmd4_row_addr,
        cmd4_multicast_req,
        
        cmd5_is_valid,
        cmd5_chip_addr,
        cmd5_bank_addr,
        cmd5_row_addr,
        cmd5_multicast_req,
        
        cmd6_is_valid,
        cmd6_chip_addr,
        cmd6_bank_addr,
        cmd6_row_addr,
        cmd6_multicast_req,
        
        cmd7_is_valid,
        cmd7_chip_addr,
        cmd7_bank_addr,
        cmd7_row_addr,
        cmd7_multicast_req,
        
        current_chip_addr,
        current_bank_addr,
        current_row_addr,
        current_multicast_req,
        
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
        
        // ecc inputs
        ecc_fetch_error_addr,
        
        // input interface inputs
        local_init_done,
        cmd_fifo_empty,
        
        // timing parameters
        mem_cas_wr_lat,
        mem_add_lat,
        mem_tcl,
        mem_trrd,
        mem_tfaw,
        mem_trfc,
        mem_trefi,
        mem_trcd,
        mem_trp,
        mem_twr,
        mem_twtr,
        mem_trtp,
        mem_tras,
        mem_trc,
        mem_auto_pd_cycles,
        
        // bank outputs
        all_banks_closed,
        
        current_bank_is_open,
        current_row_is_open,
        current_bank_info_valid,
        bank_is_open,
        row_is_open,
        bank_info_valid,
        
        // timer outputs
        can_read_current,
        can_write_current,
        can_activate_current,
        can_precharge_current,
        can_activate,
        can_precharge,
        can_precharge_all,
        
        // refresh logic
        can_refresh,
        
        auto_refresh_req,
        auto_refresh_chip,
        
        // power saving specific registers
        can_enter_power_down,
        can_self_rfsh,
        can_exit_power_saving_mode,
        
        power_down_req,
        zq_cal_req,
        
        // additive latency specific signals
        can_al_activate_write,
        can_al_activate_read,
        
        add_lat_on,
        
        // CAM output
        cam_full
    );

input                             ctl_clk;
input  [5 : 0]                    ctl_reset_n; // Resynced reset to remove recovery failure in HCx

// command queue entry inputs
input                             cmd0_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd0_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd0_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd0_row_addr;
input                             cmd0_multicast_req;

input                             cmd1_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd1_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd1_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd1_row_addr;
input                             cmd1_multicast_req;

input                             cmd2_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd2_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd2_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd2_row_addr;
input                             cmd2_multicast_req;

input                             cmd3_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd3_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd3_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd3_row_addr;
input                             cmd3_multicast_req;

input                             cmd4_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd4_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd4_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd4_row_addr;
input                             cmd4_multicast_req;

input                             cmd5_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd5_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd5_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd5_row_addr;
input                             cmd5_multicast_req;

input                             cmd6_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd6_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd6_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd6_row_addr;
input                             cmd6_multicast_req;

input                             cmd7_is_valid;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd7_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] cmd7_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] cmd7_row_addr;
input                             cmd7_multicast_req;

input  [MEM_IF_CHIP_BITS - 1 : 0] current_chip_addr;
input  [MEM_IF_BA_WIDTH  - 1 : 0] current_bank_addr;
input  [MEM_IF_ROW_WIDTH - 1 : 0] current_row_addr;
input                             current_multicast_req;

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

// ecc inputs
input  ecc_fetch_error_addr;

// input interface inputs
input  local_init_done;
input  cmd_fifo_empty;

// timing parameters
input  [CAS_WR_LAT_BUS_WIDTH - 1 : 0] mem_cas_wr_lat;
input  [ADD_LAT_BUS_WIDTH    - 1 : 0] mem_add_lat;
input  [TCL_BUS_WIDTH        - 1 : 0] mem_tcl;
input  [TRRD_BUS_WIDTH       - 1 : 0] mem_trrd;
input  [TFAW_BUS_WIDTH       - 1 : 0] mem_tfaw;
input  [TRFC_BUS_WIDTH       - 1 : 0] mem_trfc;
input  [TREFI_BUS_WIDTH      - 1 : 0] mem_trefi;
input  [TRCD_BUS_WIDTH       - 1 : 0] mem_trcd;
input  [TRP_BUS_WIDTH        - 1 : 0] mem_trp;
input  [TWR_BUS_WIDTH        - 1 : 0] mem_twr;
input  [TWTR_BUS_WIDTH       - 1 : 0] mem_twtr;
input  [TRTP_BUS_WIDTH       - 1 : 0] mem_trtp;
input  [TRAS_BUS_WIDTH       - 1 : 0] mem_tras;
input  [TRC_BUS_WIDTH        - 1 : 0] mem_trc;
input  [AUTO_PD_BUS_WIDTH    - 1 : 0] mem_auto_pd_cycles;

// bank outputs
output [MEM_IF_CS_WIDTH      - 1 : 0] all_banks_closed;

output                                current_bank_is_open;
output                                current_row_is_open;
output                                current_bank_info_valid;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_is_open;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] row_is_open;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_info_valid;

// timer outputs
output                                can_read_current;
output                                can_write_current;
output                                can_activate_current;
output                                can_precharge_current;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_activate;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_precharge;
output [MEM_IF_CS_WIDTH      - 1 : 0] can_precharge_all;

// refresh logic
output [MEM_IF_CS_WIDTH - 1 : 0] can_refresh;

output                           auto_refresh_req;
output [MEM_IF_CS_WIDTH - 1 : 0] auto_refresh_chip;

// power saving specific registers
output [MEM_IF_CS_WIDTH - 1 : 0] can_enter_power_down;
output [MEM_IF_CS_WIDTH - 1 : 0] can_self_rfsh;
output [MEM_IF_CS_WIDTH - 1 : 0] can_exit_power_saving_mode;

output                           power_down_req;
output                           zq_cal_req;

// additive latency specific signals
output can_al_activate_write;
output can_al_activate_read;

output add_lat_on;

// CAM output
output cam_full;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Parameter

------------------------------------------------------------------------------*/
    // timing parameters width
    localparam BURST_LENGTH_BUS_WIDTH             = 4;
    localparam SELF_RFSH_EXIT_CYCLES_BUS_WIDTH    = 10;
    
    localparam ACT_TO_RDWR_WIDTH                  = TRCD_BUS_WIDTH;
    localparam ACT_TO_PCH_WIDTH                   = TRAS_BUS_WIDTH;
    localparam ACT_TO_ACT_WIDTH                   = TRC_BUS_WIDTH;
    
    localparam RD_TO_RD_WIDTH                     = 3;                                     // max tCCD is 4
    localparam RD_TO_WR_WIDTH                     = 5;                                     // max of 10? (roughly because in DDR3, cas_lat - cas_wr_lat + 6)
    localparam RD_TO_WR_BC_WIDTH                  = 4;                                     // max of 8?  (roughly because in DDR3, cas_lat - cas_wr_lat + 4)
    localparam RD_TO_PCH_WIDTH                    = 4;                                     // max of 11  (add_lat (max of 6) + tRTP (max of 5))
    
    localparam WR_TO_WR_WIDTH                     = 3;                                     // max tCCD is 4
    localparam WR_TO_RD_WIDTH                     = 5;                                     // max of 28   (add_lat (max of 6) + cas_wr_lat (max of 8) + 4 + tWTR (max of 10))
    localparam WR_TO_PCH_WIDTH                    = 5;                                     // max of 24   (add_lat (max of 6) + cas_wr_lat (max of 8) + 4 + tWR (max of 6))
    
    localparam PCH_TO_ACT_WIDTH                   = TRP_BUS_WIDTH;
    
    localparam RD_AP_TO_ACT_WIDTH                 = 5;                                      // max of 22 (add_lat (max of 6) + tRTP (max of 5) + tRP (max of 11))
    localparam WR_AP_TO_ACT_WIDTH                 = 6;                                      // max of 35 (add_lat (max of 6) + cas_wr_lat (max of 8) + 4 + tWR (max of 6) + tRP (max of 11))
    
    localparam PCH_ALL_TO_VALID_WIDTH             = TRP_BUS_WIDTH;
    localparam ARF_TO_VALID_WIDTH                 = TRFC_BUS_WIDTH;
    localparam PDN_TO_VALID_WIDTH                 = 2;                                      // currently pdn_to_valid is 3
    localparam SRF_TO_VALID_WIDTH                 = SELF_RFSH_EXIT_CYCLES_BUS_WIDTH;
    localparam ARF_PERIOD_WIDTH                   = TREFI_BUS_WIDTH;
    localparam PDN_PERIOD_WIDTH                   = AUTO_PD_BUS_WIDTH;
    localparam ACT_TO_ACT_DIFF_BANK_WIDTH         = TRRD_BUS_WIDTH;
    localparam FOUR_ACT_TO_ACT_WIDTH              = TFAW_BUS_WIDTH;
    
    // bank timer settings
    localparam BANK_TIMER_INFO_INPUT_REGD         = 0;                                      // register inputs for bank timer info
    localparam BANK_TIMER_COUNTER_OFFSET          = 4;                                      // initial value for all timer counters after reset
    
    // Added to support look-ahead depth of 0
    // we need at least lookahead of '1' to cache cmd0 info to current info
    localparam INTERNAL_LOOK_AHEAD_DEPTH          = (CTL_LOOK_AHEAD_DEPTH == 0) ? 1 : CTL_LOOK_AHEAD_DEPTH;
/*------------------------------------------------------------------------------

    [END] Parameter

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Wires

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        General
    ------------------------------------------------------------------------------*/
    wire                                 current_bank_is_open;
    wire                                 current_row_is_open;
    wire                                 current_bank_info_valid;
    wire  [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_is_open;
    wire  [CTL_LOOK_AHEAD_DEPTH - 1 : 0] row_is_open;
    wire  [CTL_LOOK_AHEAD_DEPTH - 1 : 0] bank_info_valid;
    
    wire                                 can_read_current;
    wire                                 can_write_current;
    wire                                 can_activate_current;
    wire                                 can_precharge_current;
    wire  [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_activate;
    wire  [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_precharge;
    wire  [MEM_IF_CS_WIDTH      - 1 : 0] can_precharge_all;
    wire  [MEM_IF_CS_WIDTH      - 1 : 0] can_refresh;
    wire                                 auto_refresh_req;
    wire  [MEM_IF_CS_WIDTH      - 1 : 0] auto_refresh_chip;
    wire  [MEM_IF_CS_WIDTH      - 1 : 0] can_enter_power_down;
    wire  [MEM_IF_CS_WIDTH      - 1 : 0] can_self_rfsh;
    wire  [MEM_IF_CS_WIDTH      - 1 : 0] can_exit_power_saving_mode;
    wire                                 power_down_req;
    wire                                 zq_cal_req;
    wire                                 can_al_activate_write;
    wire                                 can_al_activate_read;
    wire                                 add_lat_on;
    
    wire  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_CHIP_BITS - 1 : 0] cmd_chip_addr;
    wire  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_BA_WIDTH  - 1 : 0] cmd_bank_addr;
    wire  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_ROW_WIDTH - 1 : 0] cmd_row_addr;
    wire  [CTL_CMD_QUEUE_DEPTH                              : 0] cmd_multicast_req;
    wire  [CTL_CMD_QUEUE_DEPTH                              : 0] cmd_is_valid;
    wire                                                         no_command;
    
    reg   [MEM_IF_CHIP_BITS - 1 : 0] prev_chip_addr;
    reg                              prev_multicast_req;
    reg                              chip_change;
    reg                              fetch_r1;
    reg                              early_fetch;
    
    /*------------------------------------------------------------------------------
        alt_ddrx_bank_timer
    ------------------------------------------------------------------------------*/
    wire  [MEM_IF_CS_WIDTH      - 1  : 0] cs_all_banks_closed;
    wire  [MEM_IF_CS_WIDTH      - 1  : 0] cs_can_precharge_all;
    wire  [MEM_IF_CS_WIDTH      - 1  : 0] cs_can_refresh;
    wire  [MEM_IF_CS_WIDTH      - 1  : 0] cs_can_self_refresh;
    wire  [MEM_IF_CS_WIDTH      - 1  : 0] cs_can_power_down;
    wire  [MEM_IF_CS_WIDTH      - 1  : 0] cs_can_exit_power_saving_mode;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cmd_bank_is_open;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cmd_row_is_open;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cmd_can_write;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cmd_can_read;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cmd_can_activate;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cmd_can_precharge;
    
    wire  more_than_x0_act_to_rdwr;
    wire  more_than_x0_act_to_pch;
    wire  more_than_x0_act_to_act;
    wire  more_than_x0_rd_to_rd;
    wire  more_than_x0_rd_to_wr;
    wire  more_than_x0_rd_to_wr_bc;
    wire  more_than_x0_rd_to_pch;
    wire  more_than_x0_wr_to_wr;
    wire  more_than_x0_wr_to_rd;
    wire  more_than_x0_wr_to_pch;
    wire  more_than_x0_rd_ap_to_act;
    wire  more_than_x0_wr_ap_to_act;
    wire  more_than_x0_pch_to_act;
    wire  more_than_x0_act_to_act_diff_bank;
    wire  more_than_x0_four_act_to_act;
    wire  less_than_x0_act_to_rdwr;
    wire  less_than_x0_act_to_pch;
    wire  less_than_x0_act_to_act;
    wire  less_than_x0_rd_to_rd;
    wire  less_than_x0_rd_to_wr;
    wire  less_than_x0_rd_to_wr_bc;
    wire  less_than_x0_rd_to_pch;
    wire  less_than_x0_wr_to_wr;
    wire  less_than_x0_wr_to_rd;
    wire  less_than_x0_wr_to_rd_diff_chips;
    wire  less_than_x0_wr_to_pch;
    wire  less_than_x0_rd_ap_to_act;
    wire  less_than_x0_wr_ap_to_act;
    wire  less_than_x0_pch_to_act;
    wire  less_than_x0_act_to_act_diff_bank;
    wire  less_than_x0_four_act_to_act;
    
    wire  more_than_x1_act_to_rdwr;
    wire  more_than_x1_act_to_pch;
    wire  more_than_x1_act_to_act;
    wire  more_than_x1_rd_to_rd;
    wire  more_than_x1_rd_to_wr;
    wire  more_than_x1_rd_to_wr_bc;
    wire  more_than_x1_rd_to_pch;
    wire  more_than_x1_wr_to_wr;
    wire  more_than_x1_wr_to_rd;
    wire  more_than_x1_wr_to_pch;
    wire  more_than_x1_rd_ap_to_act;
    wire  more_than_x1_wr_ap_to_act;
    wire  more_than_x1_pch_to_act;
    wire  more_than_x1_act_to_act_diff_bank;
    wire  more_than_x1_four_act_to_act;
    wire  less_than_x1_act_to_rdwr;
    wire  less_than_x1_act_to_pch;
    wire  less_than_x1_act_to_act;
    wire  less_than_x1_rd_to_rd;
    wire  less_than_x1_rd_to_wr;
    wire  less_than_x1_rd_to_wr_bc;
    wire  less_than_x1_rd_to_pch;
    wire  less_than_x1_wr_to_wr;
    wire  less_than_x1_wr_to_rd;
    wire  less_than_x1_wr_to_rd_diff_chips;
    wire  less_than_x1_wr_to_pch;
    wire  less_than_x1_rd_ap_to_act;
    wire  less_than_x1_wr_ap_to_act;
    wire  less_than_x1_pch_to_act;
    wire  less_than_x1_act_to_act_diff_bank;
    wire  less_than_x1_four_act_to_act;
    
    wire  more_than_x2_act_to_rdwr;
    wire  more_than_x2_act_to_pch;
    wire  more_than_x2_act_to_act;
    wire  more_than_x2_rd_to_rd;
    wire  more_than_x2_rd_to_wr;
    wire  more_than_x2_rd_to_wr_bc;
    wire  more_than_x2_rd_to_pch;
    wire  more_than_x2_wr_to_wr;
    wire  more_than_x2_wr_to_rd;
    wire  more_than_x2_wr_to_pch;
    wire  more_than_x2_rd_ap_to_act;
    wire  more_than_x2_wr_ap_to_act;
    wire  more_than_x2_pch_to_act;
    wire  more_than_x2_act_to_act_diff_bank;
    wire  more_than_x2_four_act_to_act;
    wire  less_than_x2_act_to_rdwr;
    wire  less_than_x2_act_to_pch;
    wire  less_than_x2_act_to_act;
    wire  less_than_x2_rd_to_rd;
    wire  less_than_x2_rd_to_wr;
    wire  less_than_x2_rd_to_wr_bc;
    wire  less_than_x2_rd_to_pch;
    wire  less_than_x2_wr_to_wr;
    wire  less_than_x2_wr_to_rd;
    wire  less_than_x2_wr_to_rd_diff_chips;
    wire  less_than_x2_wr_to_pch;
    wire  less_than_x2_rd_ap_to_act;
    wire  less_than_x2_wr_ap_to_act;
    wire  less_than_x2_pch_to_act;
    wire  less_than_x2_act_to_act_diff_bank;
    wire  less_than_x2_four_act_to_act;
    
    wire  more_than_x3_act_to_rdwr;
    wire  more_than_x3_act_to_pch;
    wire  more_than_x3_act_to_act;
    wire  more_than_x3_rd_to_rd;
    wire  more_than_x3_rd_to_wr;
    wire  more_than_x3_rd_to_wr_bc;
    wire  more_than_x3_rd_to_pch;
    wire  more_than_x3_wr_to_wr;
    wire  more_than_x3_wr_to_rd;
    wire  more_than_x3_wr_to_pch;
    wire  more_than_x3_rd_ap_to_act;
    wire  more_than_x3_wr_ap_to_act;
    wire  more_than_x3_pch_to_act;
    wire  more_than_x3_act_to_act_diff_bank;
    wire  more_than_x3_four_act_to_act;
    wire  less_than_x3_act_to_rdwr;
    wire  less_than_x3_act_to_pch;
    wire  less_than_x3_act_to_act;
    wire  less_than_x3_rd_to_rd;
    wire  less_than_x3_rd_to_wr;
    wire  less_than_x3_rd_to_wr_bc;
    wire  less_than_x3_rd_to_pch;
    wire  less_than_x3_wr_to_wr;
    wire  less_than_x3_wr_to_rd;
    wire  less_than_x3_wr_to_rd_diff_chips;
    wire  less_than_x3_wr_to_pch;
    wire  less_than_x3_rd_ap_to_act;
    wire  less_than_x3_wr_ap_to_act;
    wire  less_than_x3_pch_to_act;
    wire  less_than_x3_act_to_act_diff_bank;
    wire  less_than_x3_four_act_to_act;
    
    /*------------------------------------------------------------------------------
        alt_ddrx_rank_monitor
    ------------------------------------------------------------------------------*/
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] act_tfaw_ready;
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] act_trrd_ready;
    wire                               read_dqs_ready;
    wire                               write_dqs_ready;
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] write_to_read_finish_twtr;
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] power_saving_enter_ready;
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] power_saving_exit_ready;
    
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] cs_zq_cal_req;
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] cs_power_down_req;
    wire  [MEM_IF_CS_WIDTH    - 1 : 0] cs_refresh_req;
    
    /*------------------------------------------------------------------------------
        alt_ddrx_cache
    ------------------------------------------------------------------------------*/
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_all_banks_closed;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_can_precharge_all;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_can_refresh;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_can_self_refresh;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_can_power_down;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_can_exit_power_saving_mode;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_zq_cal_req;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_power_down_req;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] cache_out_cs_refresh_req;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_bank_is_open;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_row_is_open;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_can_write;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_can_read;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_can_activate;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_can_precharge;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] cache_out_cmd_info_valid;
    
    /*------------------------------------------------------------------------------
        alt_ddrx_bypass
    ------------------------------------------------------------------------------*/
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_all_banks_closed;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_can_precharge_all;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_can_refresh;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_can_self_refresh;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_can_power_down;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_can_exit_power_saving_mode;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_zq_cal_req;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_power_down_req;
    wire  [MEM_IF_CS_WIDTH       - 1 : 0] out_cs_refresh_req;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_bank_is_open;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_row_is_open;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_write;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_read;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_activate;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_can_precharge;
    wire  [INTERNAL_LOOK_AHEAD_DEPTH : 0] out_cmd_info_valid;
    
    /*------------------------------------------------------------------------------
        alt_ddrx_timing_param
    ------------------------------------------------------------------------------*/
    wire  [BURST_LENGTH_BUS_WIDTH          - 1 : 0] mem_burst_length;
    wire  [SELF_RFSH_EXIT_CYCLES_BUS_WIDTH - 1 : 0] mem_self_rfsh_exit_cycles;
    wire  [RD_TO_WR_WIDTH                  - 1 : 0] mem_rd_to_wr_turnaround_oct;
    wire  [WR_TO_RD_WIDTH                  - 1 : 0] mem_wr_to_rd_turnaround_oct;
    wire  [ACT_TO_RDWR_WIDTH               - 1 : 0] act_to_rdwr;
    wire  [ACT_TO_PCH_WIDTH                - 1 : 0] act_to_pch;
    wire  [ACT_TO_ACT_WIDTH                - 1 : 0] act_to_act;
    wire  [RD_TO_RD_WIDTH                  - 1 : 0] rd_to_rd;
    wire  [RD_TO_WR_WIDTH                  - 1 : 0] rd_to_wr;
    wire  [RD_TO_WR_BC_WIDTH               - 1 : 0] rd_to_wr_bc;
    wire  [RD_TO_PCH_WIDTH                 - 1 : 0] rd_to_pch;
    wire  [WR_TO_WR_WIDTH                  - 1 : 0] wr_to_wr;
    wire  [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd;
    wire  [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd_diff_chips;
    wire  [WR_TO_PCH_WIDTH                 - 1 : 0] wr_to_pch;
    wire  [RD_AP_TO_ACT_WIDTH              - 1 : 0] rd_ap_to_act;
    wire  [WR_AP_TO_ACT_WIDTH              - 1 : 0] wr_ap_to_act;
    wire  [PCH_TO_ACT_WIDTH                - 1 : 0] pch_to_act;
    wire  [PCH_ALL_TO_VALID_WIDTH          - 1 : 0] pch_all_to_valid;
    wire  [ARF_TO_VALID_WIDTH              - 1 : 0] arf_to_valid;
    wire  [PDN_TO_VALID_WIDTH              - 1 : 0] pdn_to_valid;
    wire  [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_valid;
    wire  [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_zq;
    wire  [ARF_PERIOD_WIDTH                - 1 : 0] arf_period;
    wire  [PDN_PERIOD_WIDTH                - 1 : 0] pdn_period;
    wire  [ACT_TO_ACT_DIFF_BANK_WIDTH      - 1 : 0] act_to_act_diff_bank;
    wire  [FOUR_ACT_TO_ACT_WIDTH           - 1 : 0] four_act_to_act;
    
    wire  more_than_2_act_to_rdwr;
    wire  more_than_2_act_to_pch;
    wire  more_than_2_act_to_act;
    wire  more_than_2_rd_to_rd;
    wire  more_than_2_rd_to_wr;
    wire  more_than_2_rd_to_wr_bc;
    wire  more_than_2_rd_to_pch;
    wire  more_than_2_wr_to_wr;
    wire  more_than_2_wr_to_rd;
    wire  more_than_2_wr_to_pch;
    wire  more_than_2_rd_ap_to_act;
    wire  more_than_2_wr_ap_to_act;
    wire  more_than_2_pch_to_act;
    wire  more_than_2_act_to_act_diff_bank;
    wire  more_than_2_four_act_to_act;
    wire  less_than_2_act_to_rdwr;
    wire  less_than_2_act_to_pch;
    wire  less_than_2_act_to_act;
    wire  less_than_2_rd_to_rd;
    wire  less_than_2_rd_to_wr;
    wire  less_than_2_rd_to_wr_bc;
    wire  less_than_2_rd_to_pch;
    wire  less_than_2_wr_to_wr;
    wire  less_than_2_wr_to_rd;
    wire  less_than_2_wr_to_rd_diff_chips;
    wire  less_than_2_wr_to_pch;
    wire  less_than_2_rd_ap_to_act;
    wire  less_than_2_wr_ap_to_act;
    wire  less_than_2_pch_to_act;
    wire  less_than_2_act_to_act_diff_bank;
    wire  less_than_2_four_act_to_act;
    wire  more_than_3_act_to_rdwr;
    wire  more_than_3_act_to_pch;
    wire  more_than_3_act_to_act;
    wire  more_than_3_rd_to_rd;
    wire  more_than_3_rd_to_wr;
    wire  more_than_3_rd_to_wr_bc;
    wire  more_than_3_rd_to_pch;
    wire  more_than_3_wr_to_wr;
    wire  more_than_3_wr_to_rd;
    wire  more_than_3_wr_to_pch;
    wire  more_than_3_rd_ap_to_act;
    wire  more_than_3_wr_ap_to_act;
    wire  more_than_3_pch_to_act;
    wire  more_than_3_act_to_act_diff_bank;
    wire  more_than_3_four_act_to_act;
    wire  less_than_3_act_to_rdwr;
    wire  less_than_3_act_to_pch;
    wire  less_than_3_act_to_act;
    wire  less_than_3_rd_to_rd;
    wire  less_than_3_rd_to_wr;
    wire  less_than_3_rd_to_wr_bc;
    wire  less_than_3_rd_to_pch;
    wire  less_than_3_wr_to_wr;
    wire  less_than_3_wr_to_rd;
    wire  less_than_3_wr_to_rd_diff_chips;
    wire  less_than_3_wr_to_pch;
    wire  less_than_3_rd_ap_to_act;
    wire  less_than_3_wr_ap_to_act;
    wire  less_than_3_pch_to_act;
    wire  less_than_3_act_to_act_diff_bank;
    wire  less_than_3_four_act_to_act;
    wire  more_than_4_act_to_rdwr;
    wire  more_than_4_act_to_pch;
    wire  more_than_4_act_to_act;
    wire  more_than_4_rd_to_rd;
    wire  more_than_4_rd_to_wr;
    wire  more_than_4_rd_to_wr_bc;
    wire  more_than_4_rd_to_pch;
    wire  more_than_4_wr_to_wr;
    wire  more_than_4_wr_to_rd;
    wire  more_than_4_wr_to_pch;
    wire  more_than_4_rd_ap_to_act;
    wire  more_than_4_wr_ap_to_act;
    wire  more_than_4_pch_to_act;
    wire  more_than_4_act_to_act_diff_bank;
    wire  more_than_4_four_act_to_act;
    wire  less_than_4_act_to_rdwr;
    wire  less_than_4_act_to_pch;
    wire  less_than_4_act_to_act;
    wire  less_than_4_rd_to_rd;
    wire  less_than_4_rd_to_wr;
    wire  less_than_4_rd_to_wr_bc;
    wire  less_than_4_rd_to_pch;
    wire  less_than_4_wr_to_wr;
    wire  less_than_4_wr_to_rd;
    wire  less_than_4_wr_to_rd_diff_chips;
    wire  less_than_4_wr_to_pch;
    wire  less_than_4_rd_ap_to_act;
    wire  less_than_4_wr_ap_to_act;
    wire  less_than_4_pch_to_act;
    wire  less_than_4_act_to_act_diff_bank;
    wire  less_than_4_four_act_to_act;
    wire  more_than_5_act_to_rdwr;
    wire  more_than_5_act_to_pch;
    wire  more_than_5_act_to_act;
    wire  more_than_5_rd_to_rd;
    wire  more_than_5_rd_to_wr;
    wire  more_than_5_rd_to_wr_bc;
    wire  more_than_5_rd_to_pch;
    wire  more_than_5_wr_to_wr;
    wire  more_than_5_wr_to_rd;
    wire  more_than_5_wr_to_pch;
    wire  more_than_5_rd_ap_to_act;
    wire  more_than_5_wr_ap_to_act;
    wire  more_than_5_pch_to_act;
    wire  more_than_5_act_to_act_diff_bank;
    wire  more_than_5_four_act_to_act;
    wire  less_than_5_act_to_rdwr;
    wire  less_than_5_act_to_pch;
    wire  less_than_5_act_to_act;
    wire  less_than_5_rd_to_rd;
    wire  less_than_5_rd_to_wr;
    wire  less_than_5_rd_to_wr_bc;
    wire  less_than_5_rd_to_pch;
    wire  less_than_5_wr_to_wr;
    wire  less_than_5_wr_to_rd;
    wire  less_than_5_wr_to_rd_diff_chips;
    wire  less_than_5_wr_to_pch;
    wire  less_than_5_rd_ap_to_act;
    wire  less_than_5_wr_ap_to_act;
    wire  less_than_5_pch_to_act;
    wire  less_than_5_act_to_act_diff_bank;
    wire  less_than_5_four_act_to_act;
    
    /*------------------------------------------------------------------------------
        Assignments
    ------------------------------------------------------------------------------*/
    // outputs
    assign current_bank_is_open       = out_cmd_bank_is_open  [0];
    assign current_row_is_open        = out_cmd_row_is_open   [0];
    assign current_bank_info_valid    = out_cmd_info_valid    [0];
    
    assign can_read_current           = out_cmd_can_read      [0];
    assign can_write_current          = out_cmd_can_write     [0];
    assign can_activate_current       = out_cmd_can_activate  [0];
    assign can_precharge_current      = out_cmd_can_precharge [0];
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 0)
        begin
            assign bank_is_open               = out_cmd_bank_is_open  [CTL_LOOK_AHEAD_DEPTH : 1];
            assign row_is_open                = out_cmd_row_is_open   [CTL_LOOK_AHEAD_DEPTH : 1];
            assign bank_info_valid            = out_cmd_info_valid    [CTL_LOOK_AHEAD_DEPTH : 1];
            
            assign can_activate               = out_cmd_can_activate  [CTL_LOOK_AHEAD_DEPTH : 1];
            assign can_precharge              = out_cmd_can_precharge [CTL_LOOK_AHEAD_DEPTH : 1];
        end
        else // look-ahead depth of 0
        begin
            assign bank_is_open               = 0;
            assign row_is_open                = 0;
            assign bank_info_valid            = 0;
            
            assign can_activate               = 0;
            assign can_precharge              = 0;
        end
    endgenerate
    
    assign all_banks_closed           = out_cs_all_banks_closed;
    
    assign can_precharge_all          = out_cs_can_precharge_all;
    assign can_refresh                = out_cs_can_refresh;
    assign can_self_rfsh              = out_cs_can_self_refresh;
    assign can_enter_power_down       = out_cs_can_power_down;
    assign can_exit_power_saving_mode = out_cs_can_exit_power_saving_mode;
    
    assign auto_refresh_req           = |out_cs_refresh_req;
    assign auto_refresh_chip          =  out_cs_refresh_req;
    assign power_down_req             = |out_cs_power_down_req;
    assign zq_cal_req                 = |out_cs_zq_cal_req;
    
    // inputs
    assign cmd_chip_addr     = {cmd7_chip_addr, cmd6_chip_addr, cmd5_chip_addr, cmd4_chip_addr, cmd3_chip_addr, cmd2_chip_addr, cmd1_chip_addr, cmd0_chip_addr, current_chip_addr};
    assign cmd_bank_addr     = {cmd7_bank_addr, cmd6_bank_addr, cmd5_bank_addr, cmd4_bank_addr, cmd3_bank_addr, cmd2_bank_addr, cmd1_bank_addr, cmd0_bank_addr, current_bank_addr};
    assign cmd_row_addr      = {cmd7_row_addr, cmd6_row_addr, cmd5_row_addr, cmd4_row_addr, cmd3_row_addr, cmd2_row_addr, cmd1_row_addr, cmd0_row_addr, current_row_addr};
    assign cmd_multicast_req = {cmd7_multicast_req, cmd6_multicast_req, cmd5_multicast_req, cmd4_multicast_req, cmd3_multicast_req, cmd2_multicast_req, cmd1_multicast_req, cmd0_multicast_req, current_multicast_req};
    assign cmd_is_valid      = {cmd7_is_valid, cmd6_is_valid, cmd5_is_valid, cmd4_is_valid, cmd3_is_valid, cmd2_is_valid, cmd1_is_valid, cmd0_is_valid, 1'b0}; // current signal doesn't have valid signal
    
    assign no_command = local_init_done & cmd_fifo_empty; // notify power down logic there is no incoming command
    
    assign more_than_x0_act_to_rdwr          = more_than_2_act_to_rdwr;
    assign more_than_x0_act_to_pch           = more_than_2_act_to_pch;
    assign more_than_x0_act_to_act           = more_than_2_act_to_act;
    assign more_than_x0_rd_to_rd             = more_than_2_rd_to_rd;
    assign more_than_x0_rd_to_wr             = more_than_2_rd_to_wr;
    assign more_than_x0_rd_to_wr_bc          = more_than_2_rd_to_wr_bc;
    assign more_than_x0_rd_to_pch            = more_than_2_rd_to_pch;
    assign more_than_x0_wr_to_wr             = more_than_2_wr_to_wr;
    assign more_than_x0_wr_to_rd             = more_than_2_wr_to_rd;
    assign more_than_x0_wr_to_pch            = more_than_2_wr_to_pch;
    assign more_than_x0_rd_ap_to_act         = more_than_2_rd_ap_to_act;
    assign more_than_x0_wr_ap_to_act         = more_than_2_wr_ap_to_act;
    assign more_than_x0_pch_to_act           = more_than_2_pch_to_act;
    assign more_than_x0_act_to_act_diff_bank = more_than_2_act_to_act_diff_bank;
    assign more_than_x0_four_act_to_act      = more_than_2_four_act_to_act;
    
    assign less_than_x0_act_to_rdwr          = less_than_2_act_to_rdwr;
    assign less_than_x0_act_to_pch           = less_than_2_act_to_pch;
    assign less_than_x0_act_to_act           = less_than_2_act_to_act;
    assign less_than_x0_rd_to_rd             = less_than_2_rd_to_rd;
    assign less_than_x0_rd_to_wr             = less_than_2_rd_to_wr;
    assign less_than_x0_rd_to_wr_bc          = less_than_2_rd_to_wr_bc;
    assign less_than_x0_rd_to_pch            = less_than_2_rd_to_pch;
    assign less_than_x0_wr_to_wr             = less_than_2_wr_to_wr;
    assign less_than_x0_wr_to_rd             = less_than_2_wr_to_rd;
    assign less_than_x0_wr_to_rd_diff_chips  = less_than_2_wr_to_rd_diff_chips;
    assign less_than_x0_wr_to_pch            = less_than_2_wr_to_pch;
    assign less_than_x0_rd_ap_to_act         = less_than_2_rd_ap_to_act;
    assign less_than_x0_wr_ap_to_act         = less_than_2_wr_ap_to_act;
    assign less_than_x0_pch_to_act           = less_than_2_pch_to_act;
    assign less_than_x0_act_to_act_diff_bank = less_than_2_act_to_act_diff_bank;
    assign less_than_x0_four_act_to_act      = less_than_2_four_act_to_act;
    
    assign more_than_x1_act_to_rdwr          = more_than_3_act_to_rdwr;
    assign more_than_x1_act_to_pch           = more_than_3_act_to_pch;
    assign more_than_x1_act_to_act           = more_than_3_act_to_act;
    assign more_than_x1_rd_to_rd             = more_than_3_rd_to_rd;
    assign more_than_x1_rd_to_wr             = more_than_3_rd_to_wr;
    assign more_than_x1_rd_to_wr_bc          = more_than_3_rd_to_wr_bc;
    assign more_than_x1_rd_to_pch            = more_than_3_rd_to_pch;
    assign more_than_x1_wr_to_wr             = more_than_3_wr_to_wr;
    assign more_than_x1_wr_to_rd             = more_than_3_wr_to_rd;
    assign more_than_x1_wr_to_pch            = more_than_3_wr_to_pch;
    assign more_than_x1_rd_ap_to_act         = more_than_3_rd_ap_to_act;
    assign more_than_x1_wr_ap_to_act         = more_than_3_wr_ap_to_act;
    assign more_than_x1_pch_to_act           = more_than_3_pch_to_act;
    assign more_than_x1_act_to_act_diff_bank = more_than_3_act_to_act_diff_bank;
    assign more_than_x1_four_act_to_act      = more_than_3_four_act_to_act;
    
    assign less_than_x1_act_to_rdwr          = less_than_3_act_to_rdwr;
    assign less_than_x1_act_to_pch           = less_than_3_act_to_pch;
    assign less_than_x1_act_to_act           = less_than_3_act_to_act;
    assign less_than_x1_rd_to_rd             = less_than_3_rd_to_rd;
    assign less_than_x1_rd_to_wr             = less_than_3_rd_to_wr;
    assign less_than_x1_rd_to_wr_bc          = less_than_3_rd_to_wr_bc;
    assign less_than_x1_rd_to_pch            = less_than_3_rd_to_pch;
    assign less_than_x1_wr_to_wr             = less_than_3_wr_to_wr;
    assign less_than_x1_wr_to_rd             = less_than_3_wr_to_rd;
    assign less_than_x1_wr_to_rd_diff_chips  = less_than_3_wr_to_rd_diff_chips;
    assign less_than_x1_wr_to_pch            = less_than_3_wr_to_pch;
    assign less_than_x1_rd_ap_to_act         = less_than_3_rd_ap_to_act;
    assign less_than_x1_wr_ap_to_act         = less_than_3_wr_ap_to_act;
    assign less_than_x1_pch_to_act           = less_than_3_pch_to_act;
    assign less_than_x1_act_to_act_diff_bank = less_than_3_act_to_act_diff_bank;
    assign less_than_x1_four_act_to_act      = less_than_3_four_act_to_act;
    
    assign more_than_x2_act_to_rdwr          = more_than_4_act_to_rdwr;
    assign more_than_x2_act_to_pch           = more_than_4_act_to_pch;
    assign more_than_x2_act_to_act           = more_than_4_act_to_act;
    assign more_than_x2_rd_to_rd             = more_than_4_rd_to_rd;
    assign more_than_x2_rd_to_wr             = more_than_4_rd_to_wr;
    assign more_than_x2_rd_to_wr_bc          = more_than_4_rd_to_wr_bc;
    assign more_than_x2_rd_to_pch            = more_than_4_rd_to_pch;
    assign more_than_x2_wr_to_wr             = more_than_4_wr_to_wr;
    assign more_than_x2_wr_to_rd             = more_than_4_wr_to_rd;
    assign more_than_x2_wr_to_pch            = more_than_4_wr_to_pch;
    assign more_than_x2_rd_ap_to_act         = more_than_4_rd_ap_to_act;
    assign more_than_x2_wr_ap_to_act         = more_than_4_wr_ap_to_act;
    assign more_than_x2_pch_to_act           = more_than_4_pch_to_act;
    assign more_than_x2_act_to_act_diff_bank = more_than_4_act_to_act_diff_bank;
    assign more_than_x2_four_act_to_act      = more_than_4_four_act_to_act;
    
    assign less_than_x2_act_to_rdwr          = less_than_4_act_to_rdwr;
    assign less_than_x2_act_to_pch           = less_than_4_act_to_pch;
    assign less_than_x2_act_to_act           = less_than_4_act_to_act;
    assign less_than_x2_rd_to_rd             = less_than_4_rd_to_rd;
    assign less_than_x2_rd_to_wr             = less_than_4_rd_to_wr;
    assign less_than_x2_rd_to_wr_bc          = less_than_4_rd_to_wr_bc;
    assign less_than_x2_rd_to_pch            = less_than_4_rd_to_pch;
    assign less_than_x2_wr_to_wr             = less_than_4_wr_to_wr;
    assign less_than_x2_wr_to_rd             = less_than_4_wr_to_rd;
    assign less_than_x2_wr_to_rd_diff_chips  = less_than_4_wr_to_rd_diff_chips;
    assign less_than_x2_wr_to_pch            = less_than_4_wr_to_pch;
    assign less_than_x2_rd_ap_to_act         = less_than_4_rd_ap_to_act;
    assign less_than_x2_wr_ap_to_act         = less_than_4_wr_ap_to_act;
    assign less_than_x2_pch_to_act           = less_than_4_pch_to_act;
    assign less_than_x2_act_to_act_diff_bank = less_than_4_act_to_act_diff_bank;
    assign less_than_x2_four_act_to_act      = less_than_4_four_act_to_act;
    
    assign more_than_x3_act_to_rdwr          = more_than_5_act_to_rdwr;
    assign more_than_x3_act_to_pch           = more_than_5_act_to_pch;
    assign more_than_x3_act_to_act           = more_than_5_act_to_act;
    assign more_than_x3_rd_to_rd             = more_than_5_rd_to_rd;
    assign more_than_x3_rd_to_wr             = more_than_5_rd_to_wr;
    assign more_than_x3_rd_to_wr_bc          = more_than_5_rd_to_wr_bc;
    assign more_than_x3_rd_to_pch            = more_than_5_rd_to_pch;
    assign more_than_x3_wr_to_wr             = more_than_5_wr_to_wr;
    assign more_than_x3_wr_to_rd             = more_than_5_wr_to_rd;
    assign more_than_x3_wr_to_pch            = more_than_5_wr_to_pch;
    assign more_than_x3_rd_ap_to_act         = more_than_5_rd_ap_to_act;
    assign more_than_x3_wr_ap_to_act         = more_than_5_wr_ap_to_act;
    assign more_than_x3_pch_to_act           = more_than_5_pch_to_act;
    assign more_than_x3_act_to_act_diff_bank = more_than_5_act_to_act_diff_bank;
    assign more_than_x3_four_act_to_act      = more_than_5_four_act_to_act;
    
    assign less_than_x3_act_to_rdwr          = less_than_5_act_to_rdwr;
    assign less_than_x3_act_to_pch           = less_than_5_act_to_pch;
    assign less_than_x3_act_to_act           = less_than_5_act_to_act;
    assign less_than_x3_rd_to_rd             = less_than_5_rd_to_rd;
    assign less_than_x3_rd_to_wr             = less_than_5_rd_to_wr;
    assign less_than_x3_rd_to_wr_bc          = less_than_5_rd_to_wr_bc;
    assign less_than_x3_rd_to_pch            = less_than_5_rd_to_pch;
    assign less_than_x3_wr_to_wr             = less_than_5_wr_to_wr;
    assign less_than_x3_wr_to_rd             = less_than_5_wr_to_rd;
    assign less_than_x3_wr_to_rd_diff_chips  = less_than_5_wr_to_rd_diff_chips;
    assign less_than_x3_wr_to_pch            = less_than_5_wr_to_pch;
    assign less_than_x3_rd_ap_to_act         = less_than_5_rd_ap_to_act;
    assign less_than_x3_wr_ap_to_act         = less_than_5_wr_ap_to_act;
    assign less_than_x3_pch_to_act           = less_than_5_pch_to_act;
    assign less_than_x3_act_to_act_diff_bank = less_than_5_act_to_act_diff_bank;
    assign less_than_x3_four_act_to_act      = less_than_5_four_act_to_act;
    
/*------------------------------------------------------------------------------

    [END] Wires

------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------

    [START] Common Logics

------------------------------------------------------------------------------*/
    // store current chip address into previous chip address for comparison later
    always @ (posedge ctl_clk or negedge ctl_reset_n[5])
    begin
        if (!ctl_reset_n[5])
        begin
            prev_chip_addr <= 0;
        end
        else
        begin
            if (fetch)
                prev_chip_addr <= current_chip_addr;
        end
    end
    
    // store current multicast request for comparison later
    always @ (posedge ctl_clk or negedge ctl_reset_n[5])
    begin
        if (!ctl_reset_n[5])
        begin
            prev_multicast_req <= 1'b0;
        end
        else
        begin
            if (fetch)
                prev_multicast_req <= current_multicast_req;
        end
    end
    
    // register fetch signal
    always @ (posedge ctl_clk or negedge ctl_reset_n[5])
    begin
        if (!ctl_reset_n[5])
        begin
            fetch_r1 <= 1'b0;
        end
        else
        begin
            fetch_r1 <= fetch;
        end
    end
    
    // in certain cases, fetch will be issued after a read/write command
    // in these cases, chip_change signal will change one cycle later which
    // will cause Write to Read violation becuse we have 2 parameters
    // which are wr_to_rd and wr_to_rd_diff_chips (lower value compared to the previous one)
    always @ (*)
    begin
        if (do_write && !fetch_r1)
            early_fetch = 1'b1;
        else
            early_fetch = 1'b0;
    end
    
    // compare current chip addr with prev chip addr
    // during the following case, do not assert chip change:
    // - wr with multicast to read with multicast
    // - wr with multicast to read with no multicast
    // - wr with no multicast to read with multicast
    always @ (*)
    begin
        if (!fetch && !early_fetch && prev_chip_addr != current_chip_addr && !(prev_multicast_req || current_multicast_req))
            chip_change = 1'b1;
        else if ((fetch || early_fetch) && current_chip_addr != cmd0_chip_addr && !(current_multicast_req || cmd0_multicast_req))
            chip_change = 1'b1;
        else
            chip_change = 1'b0;
    end
/*------------------------------------------------------------------------------

    [END] Common Logics

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

alt_ddrx_bank_timer #
(
    .MEM_IF_CHIP_BITS                              (MEM_IF_CHIP_BITS                              ),
    .MEM_IF_CS_WIDTH                               (MEM_IF_CS_WIDTH                               ),
    .MEM_IF_ROW_WIDTH                              (MEM_IF_ROW_WIDTH                              ),
    .MEM_IF_BA_WIDTH                               (MEM_IF_BA_WIDTH                               ),
    .MEM_TYPE                                      (MEM_TYPE                                      ),
    .DWIDTH_RATIO                                  (DWIDTH_RATIO                                  ),
    .CLOSE_PAGE_POLICY                             (CLOSE_PAGE_POLICY                             ),
    .BANK_TIMER_INFO_INPUT_REGD                    (BANK_TIMER_INFO_INPUT_REGD                    ),
    .BANK_TIMER_COUNTER_OFFSET                     (BANK_TIMER_COUNTER_OFFSET                     ),
    .CTL_LOOK_AHEAD_DEPTH                          (INTERNAL_LOOK_AHEAD_DEPTH                     ),
    .CTL_CMD_QUEUE_DEPTH                           (CTL_CMD_QUEUE_DEPTH                           ),
    .CTL_USR_REFRESH                               (CTL_USR_REFRESH                               ),
    .CTL_DYNAMIC_BANK_ALLOCATION                   (CTL_DYNAMIC_BANK_ALLOCATION                   ),
    .CTL_DYNAMIC_BANK_NUM                          (CTL_DYNAMIC_BANK_NUM                          ),
    .BURST_LENGTH_BUS_WIDTH                        (BURST_LENGTH_BUS_WIDTH                        ),
    .SELF_RFSH_EXIT_CYCLES_BUS_WIDTH               (SELF_RFSH_EXIT_CYCLES_BUS_WIDTH               ),
    .ACT_TO_RDWR_WIDTH                             (ACT_TO_RDWR_WIDTH                             ),
    .ACT_TO_PCH_WIDTH                              (ACT_TO_PCH_WIDTH                              ),
    .ACT_TO_ACT_WIDTH                              (ACT_TO_ACT_WIDTH                              ),
    .RD_TO_RD_WIDTH                                (RD_TO_RD_WIDTH                                ),
    .RD_TO_WR_WIDTH                                (RD_TO_WR_WIDTH                                ),
    .RD_TO_WR_BC_WIDTH                             (RD_TO_WR_BC_WIDTH                             ),
    .RD_TO_PCH_WIDTH                               (RD_TO_PCH_WIDTH                               ),
    .WR_TO_WR_WIDTH                                (WR_TO_WR_WIDTH                                ),
    .WR_TO_RD_WIDTH                                (WR_TO_RD_WIDTH                                ),
    .WR_TO_PCH_WIDTH                               (WR_TO_PCH_WIDTH                               ),
    .RD_AP_TO_ACT_WIDTH                            (RD_AP_TO_ACT_WIDTH                            ),
    .WR_AP_TO_ACT_WIDTH                            (WR_AP_TO_ACT_WIDTH                            ),
    .PCH_TO_ACT_WIDTH                              (PCH_TO_ACT_WIDTH                              ),
    .PCH_ALL_TO_VALID_WIDTH                        (PCH_ALL_TO_VALID_WIDTH                        ),
    .ARF_TO_VALID_WIDTH                            (ARF_TO_VALID_WIDTH                            ),
    .PDN_TO_VALID_WIDTH                            (PDN_TO_VALID_WIDTH                            ),
    .SRF_TO_VALID_WIDTH                            (SRF_TO_VALID_WIDTH                            ),
    .ARF_PERIOD_WIDTH                              (ARF_PERIOD_WIDTH                              ),
    .PDN_PERIOD_WIDTH                              (PDN_PERIOD_WIDTH                              ),
    .ACT_TO_ACT_DIFF_BANK_WIDTH                    (ACT_TO_ACT_DIFF_BANK_WIDTH                    ),
    .FOUR_ACT_TO_ACT_WIDTH                         (FOUR_ACT_TO_ACT_WIDTH                         )
)
bank_timer_inst
(
    .ctl_clk                                       (ctl_clk                                       ),
    .ctl_reset_n                                   (ctl_reset_n[0]                                ),
    .cmd_chip_addr                                 (cmd_chip_addr                                 ),
    .cmd_bank_addr                                 (cmd_bank_addr                                 ),
    .cmd_row_addr                                  (cmd_row_addr                                  ),
    .cmd_multicast_req                             (cmd_multicast_req                             ),
    .act_to_rdwr                                   (act_to_rdwr                                   ),
    .act_to_pch                                    (act_to_pch                                    ),
    .act_to_act                                    (act_to_act                                    ),
    .rd_to_rd                                      (rd_to_rd                                      ),
    .rd_to_wr                                      (rd_to_wr                                      ),
    .rd_to_wr_bc                                   (rd_to_wr_bc                                   ),
    .rd_to_pch                                     (rd_to_pch                                     ),
    .wr_to_wr                                      (wr_to_wr                                      ),
    .wr_to_rd                                      (wr_to_rd                                      ),
    .wr_to_rd_diff_chips                           (wr_to_rd_diff_chips                           ),
    .wr_to_pch                                     (wr_to_pch                                     ),
    .rd_ap_to_act                                  (rd_ap_to_act                                  ),
    .wr_ap_to_act                                  (wr_ap_to_act                                  ),
    .pch_to_act                                    (pch_to_act                                    ),
    .pch_all_to_valid                              (pch_all_to_valid                              ),
    .arf_to_valid                                  (arf_to_valid                                  ),
    .pdn_to_valid                                  (pdn_to_valid                                  ),
    .srf_to_valid                                  (srf_to_valid                                  ),
    .srf_to_zq                                     (srf_to_zq                                     ),
    .arf_period                                    (arf_period                                    ),
    .pdn_period                                    (pdn_period                                    ),
    .act_to_act_diff_bank                          (act_to_act_diff_bank                          ),
    .four_act_to_act                               (four_act_to_act                               ),
    .more_than_x1_act_to_rdwr                      (more_than_x1_act_to_rdwr                      ),
    .more_than_x1_act_to_pch                       (more_than_x1_act_to_pch                       ),
    .more_than_x1_act_to_act                       (more_than_x1_act_to_act                       ),
    .more_than_x1_rd_to_rd                         (more_than_x1_rd_to_rd                         ),
    .more_than_x1_rd_to_wr                         (more_than_x1_rd_to_wr                         ),
    .more_than_x1_rd_to_wr_bc                      (more_than_x1_rd_to_wr_bc                      ),
    .more_than_x1_rd_to_pch                        (more_than_x1_rd_to_pch                        ),
    .more_than_x1_wr_to_wr                         (more_than_x1_wr_to_wr                         ),
    .more_than_x1_wr_to_rd                         (more_than_x1_wr_to_rd                         ),
    .more_than_x1_wr_to_pch                        (more_than_x1_wr_to_pch                        ),
    .more_than_x1_rd_ap_to_act                     (more_than_x1_rd_ap_to_act                     ),
    .more_than_x1_wr_ap_to_act                     (more_than_x1_wr_ap_to_act                     ),
    .more_than_x1_pch_to_act                       (more_than_x1_pch_to_act                       ),
    .more_than_x1_act_to_act_diff_bank             (more_than_x1_act_to_act_diff_bank             ),
    .more_than_x1_four_act_to_act                  (more_than_x1_four_act_to_act                  ),
    .less_than_x1_act_to_rdwr                      (less_than_x1_act_to_rdwr                      ),
    .less_than_x1_act_to_pch                       (less_than_x1_act_to_pch                       ),
    .less_than_x1_act_to_act                       (less_than_x1_act_to_act                       ),
    .less_than_x1_rd_to_rd                         (less_than_x1_rd_to_rd                         ),
    .less_than_x1_rd_to_wr                         (less_than_x1_rd_to_wr                         ),
    .less_than_x1_rd_to_wr_bc                      (less_than_x1_rd_to_wr_bc                      ),
    .less_than_x1_rd_to_pch                        (less_than_x1_rd_to_pch                        ),
    .less_than_x1_wr_to_wr                         (less_than_x1_wr_to_wr                         ),
    .less_than_x1_wr_to_rd                         (less_than_x1_wr_to_rd                         ),
    .less_than_x1_wr_to_rd_diff_chips              (less_than_x1_wr_to_rd_diff_chips              ),
    .less_than_x1_wr_to_pch                        (less_than_x1_wr_to_pch                        ),
    .less_than_x1_rd_ap_to_act                     (less_than_x1_rd_ap_to_act                     ),
    .less_than_x1_wr_ap_to_act                     (less_than_x1_wr_ap_to_act                     ),
    .less_than_x1_pch_to_act                       (less_than_x1_pch_to_act                       ),
    .less_than_x1_act_to_act_diff_bank             (less_than_x1_act_to_act_diff_bank             ),
    .less_than_x1_four_act_to_act                  (less_than_x1_four_act_to_act                  ),
    .more_than_x2_act_to_rdwr                      (more_than_x2_act_to_rdwr                      ),
    .more_than_x2_act_to_pch                       (more_than_x2_act_to_pch                       ),
    .more_than_x2_act_to_act                       (more_than_x2_act_to_act                       ),
    .more_than_x2_rd_to_rd                         (more_than_x2_rd_to_rd                         ),
    .more_than_x2_rd_to_wr                         (more_than_x2_rd_to_wr                         ),
    .more_than_x2_rd_to_wr_bc                      (more_than_x2_rd_to_wr_bc                      ),
    .more_than_x2_rd_to_pch                        (more_than_x2_rd_to_pch                        ),
    .more_than_x2_wr_to_wr                         (more_than_x2_wr_to_wr                         ),
    .more_than_x2_wr_to_rd                         (more_than_x2_wr_to_rd                         ),
    .more_than_x2_wr_to_pch                        (more_than_x2_wr_to_pch                        ),
    .more_than_x2_rd_ap_to_act                     (more_than_x2_rd_ap_to_act                     ),
    .more_than_x2_wr_ap_to_act                     (more_than_x2_wr_ap_to_act                     ),
    .more_than_x2_pch_to_act                       (more_than_x2_pch_to_act                       ),
    .more_than_x2_act_to_act_diff_bank             (more_than_x2_act_to_act_diff_bank             ),
    .more_than_x2_four_act_to_act                  (more_than_x2_four_act_to_act                  ),
    .less_than_x2_act_to_rdwr                      (less_than_x2_act_to_rdwr                      ),
    .less_than_x2_act_to_pch                       (less_than_x2_act_to_pch                       ),
    .less_than_x2_act_to_act                       (less_than_x2_act_to_act                       ),
    .less_than_x2_rd_to_rd                         (less_than_x2_rd_to_rd                         ),
    .less_than_x2_rd_to_wr                         (less_than_x2_rd_to_wr                         ),
    .less_than_x2_rd_to_wr_bc                      (less_than_x2_rd_to_wr_bc                      ),
    .less_than_x2_rd_to_pch                        (less_than_x2_rd_to_pch                        ),
    .less_than_x2_wr_to_wr                         (less_than_x2_wr_to_wr                         ),
    .less_than_x2_wr_to_rd                         (less_than_x2_wr_to_rd                         ),
    .less_than_x2_wr_to_rd_diff_chips              (less_than_x2_wr_to_rd_diff_chips              ),
    .less_than_x2_wr_to_pch                        (less_than_x2_wr_to_pch                        ),
    .less_than_x2_rd_ap_to_act                     (less_than_x2_rd_ap_to_act                     ),
    .less_than_x2_wr_ap_to_act                     (less_than_x2_wr_ap_to_act                     ),
    .less_than_x2_pch_to_act                       (less_than_x2_pch_to_act                       ),
    .less_than_x2_act_to_act_diff_bank             (less_than_x2_act_to_act_diff_bank             ),
    .less_than_x2_four_act_to_act                  (less_than_x2_four_act_to_act                  ),
    .do_write                                      (do_write                                      ),
    .do_read                                       (do_read                                       ),
    .do_burst_chop                                 (do_burst_chop                                 ),
    .do_auto_precharge                             (do_auto_precharge                             ),
    .do_activate                                   (do_activate                                   ),
    .do_precharge                                  (do_precharge                                  ),
    .do_precharge_all                              (do_precharge_all                              ),
    .do_refresh                                    (do_refresh                                    ),
    .do_power_down                                 (do_power_down                                 ),
    .do_self_rfsh                                  (do_self_rfsh                                  ),
    .to_chip                                       (to_chip                                       ),
    .to_bank_addr                                  (to_bank_addr                                  ),
    .to_row_addr                                   (to_row_addr                                   ),
    .act_tfaw_ready                                (act_tfaw_ready                                ),
    .act_trrd_ready                                (act_trrd_ready                                ),
    .read_dqs_ready                                (read_dqs_ready                                ),
    .write_dqs_ready                               (write_dqs_ready                               ),
    .write_to_read_finish_twtr                     (write_to_read_finish_twtr                     ),
    .power_saving_enter_ready                      (power_saving_enter_ready                      ),
    .power_saving_exit_ready                       (power_saving_exit_ready                       ),
    .cs_all_banks_closed                           (cs_all_banks_closed                           ),
    .cs_can_precharge_all                          (cs_can_precharge_all                          ),
    .cs_can_refresh                                (cs_can_refresh                                ),
    .cs_can_self_refresh                           (cs_can_self_refresh                           ),
    .cs_can_power_down                             (cs_can_power_down                             ),
    .cs_can_exit_power_saving_mode                 (cs_can_exit_power_saving_mode                 ),
    .cmd_bank_is_open                              (cmd_bank_is_open                              ),
    .cmd_row_is_open                               (cmd_row_is_open                               ),
    .cmd_can_write                                 (cmd_can_write                                 ),
    .cmd_can_read                                  (cmd_can_read                                  ),
    .cmd_can_activate                              (cmd_can_activate                              ),
    .cmd_can_precharge                             (cmd_can_precharge                             ),
    .can_al_activate_read                          (can_al_activate_read                          ),
    .can_al_activate_write                         (can_al_activate_write                         ),
    .cam_full                                      (cam_full                                      )
);

alt_ddrx_rank_monitor #
(
    .MEM_IF_CHIP_BITS                              (MEM_IF_CHIP_BITS                              ),
    .MEM_IF_CS_WIDTH                               (MEM_IF_CS_WIDTH                               ),
    .MEM_IF_ROW_WIDTH                              (MEM_IF_ROW_WIDTH                              ),
    .MEM_IF_BA_WIDTH                               (MEM_IF_BA_WIDTH                               ),
    .MEM_TYPE                                      (MEM_TYPE                                      ),
    .DWIDTH_RATIO                                  (DWIDTH_RATIO                                  ),
    .BANK_TIMER_INFO_INPUT_REGD                    (BANK_TIMER_INFO_INPUT_REGD                    ),
    .BANK_TIMER_COUNTER_OFFSET                     (BANK_TIMER_COUNTER_OFFSET                     ),
    .CTL_LOOK_AHEAD_DEPTH                          (INTERNAL_LOOK_AHEAD_DEPTH                     ),
    .CTL_CMD_QUEUE_DEPTH                           (CTL_CMD_QUEUE_DEPTH                           ),
    .CTL_USR_REFRESH                               (CTL_USR_REFRESH                               ),
    .BURST_LENGTH_BUS_WIDTH                        (BURST_LENGTH_BUS_WIDTH                        ),
    .SELF_RFSH_EXIT_CYCLES_BUS_WIDTH               (SELF_RFSH_EXIT_CYCLES_BUS_WIDTH               ),
    .ACT_TO_RDWR_WIDTH                             (ACT_TO_RDWR_WIDTH                             ),
    .ACT_TO_PCH_WIDTH                              (ACT_TO_PCH_WIDTH                              ),
    .ACT_TO_ACT_WIDTH                              (ACT_TO_ACT_WIDTH                              ),
    .RD_TO_RD_WIDTH                                (RD_TO_RD_WIDTH                                ),
    .RD_TO_WR_WIDTH                                (RD_TO_WR_WIDTH                                ),
    .RD_TO_WR_BC_WIDTH                             (RD_TO_WR_BC_WIDTH                             ),
    .RD_TO_PCH_WIDTH                               (RD_TO_PCH_WIDTH                               ),
    .WR_TO_WR_WIDTH                                (WR_TO_WR_WIDTH                                ),
    .WR_TO_RD_WIDTH                                (WR_TO_RD_WIDTH                                ),
    .WR_TO_PCH_WIDTH                               (WR_TO_PCH_WIDTH                               ),
    .RD_AP_TO_ACT_WIDTH                            (RD_AP_TO_ACT_WIDTH                            ),
    .WR_AP_TO_ACT_WIDTH                            (WR_AP_TO_ACT_WIDTH                            ),
    .PCH_TO_ACT_WIDTH                              (PCH_TO_ACT_WIDTH                              ),
    .PCH_ALL_TO_VALID_WIDTH                        (PCH_ALL_TO_VALID_WIDTH                        ),
    .ARF_TO_VALID_WIDTH                            (ARF_TO_VALID_WIDTH                            ),
    .PDN_TO_VALID_WIDTH                            (PDN_TO_VALID_WIDTH                            ),
    .SRF_TO_VALID_WIDTH                            (SRF_TO_VALID_WIDTH                            ),
    .ARF_PERIOD_WIDTH                              (ARF_PERIOD_WIDTH                              ),
    .PDN_PERIOD_WIDTH                              (PDN_PERIOD_WIDTH                              ),
    .ACT_TO_ACT_DIFF_BANK_WIDTH                    (ACT_TO_ACT_DIFF_BANK_WIDTH                    ),
    .FOUR_ACT_TO_ACT_WIDTH                         (FOUR_ACT_TO_ACT_WIDTH                         )
)
rank_monitor_inst
(
    .ctl_clk                                       (ctl_clk                                       ),
    .ctl_reset_n                                   (ctl_reset_n[1]                                ),
    .do_write                                      (do_write                                      ),
    .do_read                                       (do_read                                       ),
    .do_burst_chop                                 (do_burst_chop                                 ),
    .do_auto_precharge                             (do_auto_precharge                             ),
    .do_activate                                   (do_activate                                   ),
    .do_precharge                                  (do_precharge                                  ),
    .do_precharge_all                              (do_precharge_all                              ),
    .do_refresh                                    (do_refresh                                    ),
    .do_power_down                                 (do_power_down                                 ),
    .do_self_rfsh                                  (do_self_rfsh                                  ),
    .to_chip                                       (to_chip                                       ),
    .to_bank_addr                                  (to_bank_addr                                  ),
    .act_to_rdwr                                   (act_to_rdwr                                   ),
    .act_to_pch                                    (act_to_pch                                    ),
    .act_to_act                                    (act_to_act                                    ),
    .rd_to_rd                                      (rd_to_rd                                      ),
    .rd_to_wr                                      (rd_to_wr                                      ),
    .rd_to_wr_bc                                   (rd_to_wr_bc                                   ),
    .rd_to_pch                                     (rd_to_pch                                     ),
    .wr_to_wr                                      (wr_to_wr                                      ),
    .wr_to_rd                                      (wr_to_rd                                      ),
    .wr_to_rd_diff_chips                           (wr_to_rd_diff_chips                           ),
    .wr_to_pch                                     (wr_to_pch                                     ),
    .rd_ap_to_act                                  (rd_ap_to_act                                  ),
    .wr_ap_to_act                                  (wr_ap_to_act                                  ),
    .pch_to_act                                    (pch_to_act                                    ),
    .pch_all_to_valid                              (pch_all_to_valid                              ),
    .arf_to_valid                                  (arf_to_valid                                  ),
    .pdn_to_valid                                  (pdn_to_valid                                  ),
    .srf_to_valid                                  (srf_to_valid                                  ),
    .srf_to_zq                                     (srf_to_zq                                     ),
    .arf_period                                    (arf_period                                    ),
    .pdn_period                                    (pdn_period                                    ),
    .act_to_act_diff_bank                          (act_to_act_diff_bank                          ),
    .four_act_to_act                               (four_act_to_act                               ),
    .more_than_x1_act_to_rdwr                      (more_than_x1_act_to_rdwr                      ),
    .more_than_x1_act_to_pch                       (more_than_x1_act_to_pch                       ),
    .more_than_x1_act_to_act                       (more_than_x1_act_to_act                       ),
    .more_than_x1_rd_to_rd                         (more_than_x1_rd_to_rd                         ),
    .more_than_x1_rd_to_wr                         (more_than_x1_rd_to_wr                         ),
    .more_than_x1_rd_to_wr_bc                      (more_than_x1_rd_to_wr_bc                      ),
    .more_than_x1_rd_to_pch                        (more_than_x1_rd_to_pch                        ),
    .more_than_x1_wr_to_wr                         (more_than_x1_wr_to_wr                         ),
    .more_than_x1_wr_to_rd                         (more_than_x1_wr_to_rd                         ),
    .more_than_x1_wr_to_pch                        (more_than_x1_wr_to_pch                        ),
    .more_than_x1_rd_ap_to_act                     (more_than_x1_rd_ap_to_act                     ),
    .more_than_x1_wr_ap_to_act                     (more_than_x1_wr_ap_to_act                     ),
    .more_than_x1_pch_to_act                       (more_than_x1_pch_to_act                       ),
    .more_than_x1_act_to_act_diff_bank             (more_than_x1_act_to_act_diff_bank             ),
    .more_than_x1_four_act_to_act                  (more_than_x1_four_act_to_act                  ),
    .less_than_x1_act_to_rdwr                      (less_than_x1_act_to_rdwr                      ),
    .less_than_x1_act_to_pch                       (less_than_x1_act_to_pch                       ),
    .less_than_x1_act_to_act                       (less_than_x1_act_to_act                       ),
    .less_than_x1_rd_to_rd                         (less_than_x1_rd_to_rd                         ),
    .less_than_x1_rd_to_wr                         (less_than_x1_rd_to_wr                         ),
    .less_than_x1_rd_to_wr_bc                      (less_than_x1_rd_to_wr_bc                      ),
    .less_than_x1_rd_to_pch                        (less_than_x1_rd_to_pch                        ),
    .less_than_x1_wr_to_wr                         (less_than_x1_wr_to_wr                         ),
    .less_than_x1_wr_to_rd                         (less_than_x1_wr_to_rd                         ),
    .less_than_x1_wr_to_rd_diff_chips              (less_than_x1_wr_to_rd_diff_chips              ),
    .less_than_x1_wr_to_pch                        (less_than_x1_wr_to_pch                        ),
    .less_than_x1_rd_ap_to_act                     (less_than_x1_rd_ap_to_act                     ),
    .less_than_x1_wr_ap_to_act                     (less_than_x1_wr_ap_to_act                     ),
    .less_than_x1_pch_to_act                       (less_than_x1_pch_to_act                       ),
    .less_than_x1_act_to_act_diff_bank             (less_than_x1_act_to_act_diff_bank             ),
    .less_than_x1_four_act_to_act                  (less_than_x1_four_act_to_act                  ),
    .more_than_x2_act_to_rdwr                      (more_than_x2_act_to_rdwr                      ),
    .more_than_x2_act_to_pch                       (more_than_x2_act_to_pch                       ),
    .more_than_x2_act_to_act                       (more_than_x2_act_to_act                       ),
    .more_than_x2_rd_to_rd                         (more_than_x2_rd_to_rd                         ),
    .more_than_x2_rd_to_wr                         (more_than_x2_rd_to_wr                         ),
    .more_than_x2_rd_to_wr_bc                      (more_than_x2_rd_to_wr_bc                      ),
    .more_than_x2_rd_to_pch                        (more_than_x2_rd_to_pch                        ),
    .more_than_x2_wr_to_wr                         (more_than_x2_wr_to_wr                         ),
    .more_than_x2_wr_to_rd                         (more_than_x2_wr_to_rd                         ),
    .more_than_x2_wr_to_pch                        (more_than_x2_wr_to_pch                        ),
    .more_than_x2_rd_ap_to_act                     (more_than_x2_rd_ap_to_act                     ),
    .more_than_x2_wr_ap_to_act                     (more_than_x2_wr_ap_to_act                     ),
    .more_than_x2_pch_to_act                       (more_than_x2_pch_to_act                       ),
    .more_than_x2_act_to_act_diff_bank             (more_than_x2_act_to_act_diff_bank             ),
    .more_than_x2_four_act_to_act                  (more_than_x2_four_act_to_act                  ),
    .less_than_x2_act_to_rdwr                      (less_than_x2_act_to_rdwr                      ),
    .less_than_x2_act_to_pch                       (less_than_x2_act_to_pch                       ),
    .less_than_x2_act_to_act                       (less_than_x2_act_to_act                       ),
    .less_than_x2_rd_to_rd                         (less_than_x2_rd_to_rd                         ),
    .less_than_x2_rd_to_wr                         (less_than_x2_rd_to_wr                         ),
    .less_than_x2_rd_to_wr_bc                      (less_than_x2_rd_to_wr_bc                      ),
    .less_than_x2_rd_to_pch                        (less_than_x2_rd_to_pch                        ),
    .less_than_x2_wr_to_wr                         (less_than_x2_wr_to_wr                         ),
    .less_than_x2_wr_to_rd                         (less_than_x2_wr_to_rd                         ),
    .less_than_x2_wr_to_rd_diff_chips              (less_than_x2_wr_to_rd_diff_chips              ),
    .less_than_x2_wr_to_pch                        (less_than_x2_wr_to_pch                        ),
    .less_than_x2_rd_ap_to_act                     (less_than_x2_rd_ap_to_act                     ),
    .less_than_x2_wr_ap_to_act                     (less_than_x2_wr_ap_to_act                     ),
    .less_than_x2_pch_to_act                       (less_than_x2_pch_to_act                       ),
    .less_than_x2_act_to_act_diff_bank             (less_than_x2_act_to_act_diff_bank             ),
    .less_than_x2_four_act_to_act                  (less_than_x2_four_act_to_act                  ),
    .no_command                                    (no_command                                    ),
    .chip_change                                   (chip_change                                   ),
    .act_tfaw_ready                                (act_tfaw_ready                                ),
    .act_trrd_ready                                (act_trrd_ready                                ),
    .read_dqs_ready                                (read_dqs_ready                                ),
    .write_dqs_ready                               (write_dqs_ready                               ),
    .write_to_read_finish_twtr                     (write_to_read_finish_twtr                     ),
    .power_saving_enter_ready                      (power_saving_enter_ready                      ),
    .power_saving_exit_ready                       (power_saving_exit_ready                       ),
    .cs_zq_cal_req                                 (cs_zq_cal_req                                 ),
    .cs_power_down_req                             (cs_power_down_req                             ),
    .cs_refresh_req                                (cs_refresh_req                                )
);

alt_ddrx_cache #
(
    .MEM_IF_CHIP_BITS                              (MEM_IF_CHIP_BITS                              ),
    .MEM_IF_CS_WIDTH                               (MEM_IF_CS_WIDTH                               ),
    .MEM_IF_ROW_WIDTH                              (MEM_IF_ROW_WIDTH                              ),
    .MEM_IF_BA_WIDTH                               (MEM_IF_BA_WIDTH                               ),
    .MEM_TYPE                                      (MEM_TYPE                                      ),
    .DWIDTH_RATIO                                  (DWIDTH_RATIO                                  ),
    .CLOSE_PAGE_POLICY                             (CLOSE_PAGE_POLICY                             ),
    .CTL_LOOK_AHEAD_DEPTH                          (INTERNAL_LOOK_AHEAD_DEPTH                     ),
    .CTL_CMD_QUEUE_DEPTH                           (CTL_CMD_QUEUE_DEPTH                           )
)
cache_inst
(
    .ctl_clk                                       (ctl_clk                                       ),
    .ctl_reset_n                                   (ctl_reset_n[2]                                ),
    .fetch                                         (fetch                                         ),
    .ecc_fetch_error_addr                          (ecc_fetch_error_addr                          ),
    .cmd_is_valid                                  (cmd_is_valid                                  ),
    .in_cs_all_banks_closed                        (cs_all_banks_closed                           ),
    .in_cs_can_precharge_all                       (cs_can_precharge_all                          ),
    .in_cs_can_refresh                             (cs_can_refresh                                ),
    .in_cs_can_self_refresh                        (cs_can_self_refresh                           ),
    .in_cs_can_power_down                          (cs_can_power_down                             ),
    .in_cs_can_exit_power_saving_mode              (cs_can_exit_power_saving_mode                 ),
    .in_cs_zq_cal_req                              (cs_zq_cal_req                                 ),
    .in_cs_power_down_req                          (cs_power_down_req                             ),
    .in_cs_refresh_req                             (cs_refresh_req                                ),
    .in_cmd_bank_is_open                           (cmd_bank_is_open                              ),
    .in_cmd_row_is_open                            (cmd_row_is_open                               ),
    .in_cmd_can_write                              (cmd_can_write                                 ),
    .in_cmd_can_read                               (cmd_can_read                                  ),
    .in_cmd_can_activate                           (cmd_can_activate                              ),
    .in_cmd_can_precharge                          (cmd_can_precharge                             ),
    .out_cs_all_banks_closed                       (cache_out_cs_all_banks_closed                 ),
    .out_cs_can_precharge_all                      (cache_out_cs_can_precharge_all                ),
    .out_cs_can_refresh                            (cache_out_cs_can_refresh                      ),
    .out_cs_can_self_refresh                       (cache_out_cs_can_self_refresh                 ),
    .out_cs_can_power_down                         (cache_out_cs_can_power_down                   ),
    .out_cs_can_exit_power_saving_mode             (cache_out_cs_can_exit_power_saving_mode       ),
    .out_cs_zq_cal_req                             (cache_out_cs_zq_cal_req                       ),
    .out_cs_power_down_req                         (cache_out_cs_power_down_req                   ),
    .out_cs_refresh_req                            (cache_out_cs_refresh_req                      ),
    .out_cmd_bank_is_open                          (cache_out_cmd_bank_is_open                    ),
    .out_cmd_row_is_open                           (cache_out_cmd_row_is_open                     ),
    .out_cmd_can_write                             (cache_out_cmd_can_write                       ),
    .out_cmd_can_read                              (cache_out_cmd_can_read                        ),
    .out_cmd_can_activate                          (cache_out_cmd_can_activate                    ),
    .out_cmd_can_precharge                         (cache_out_cmd_can_precharge                   ),
    .out_cmd_info_valid                            (cache_out_cmd_info_valid                      )
);

alt_ddrx_bypass #
(
    .MEM_IF_CHIP_BITS                              (MEM_IF_CHIP_BITS                              ),
    .MEM_IF_CS_WIDTH                               (MEM_IF_CS_WIDTH                               ),
    .MEM_IF_ROW_WIDTH                              (MEM_IF_ROW_WIDTH                              ),
    .MEM_IF_BA_WIDTH                               (MEM_IF_BA_WIDTH                               ),
    .CLOSE_PAGE_POLICY                             (CLOSE_PAGE_POLICY                             ),
    .CTL_LOOK_AHEAD_DEPTH                          (INTERNAL_LOOK_AHEAD_DEPTH                     ),
    .CTL_CMD_QUEUE_DEPTH                           (CTL_CMD_QUEUE_DEPTH                           )
)
bypass_inst
(
    .ctl_clk                                       (ctl_clk                                       ),
    .ctl_reset_n                                   (ctl_reset_n[3]                                ),
    .cmd_chip_addr                                 (cmd_chip_addr                                 ),
    .cmd_bank_addr                                 (cmd_bank_addr                                 ),
    .cmd_row_addr                                  (cmd_row_addr                                  ),
    .cmd_multicast_req                             (cmd_multicast_req                             ),
    .do_write                                      (do_write                                      ),
    .do_read                                       (do_read                                       ),
    .do_burst_chop                                 (do_burst_chop                                 ),
    .do_auto_precharge                             (do_auto_precharge                             ),
    .do_activate                                   (do_activate                                   ),
    .do_precharge                                  (do_precharge                                  ),
    .do_precharge_all                              (do_precharge_all                              ),
    .do_refresh                                    (do_refresh                                    ),
    .do_power_down                                 (do_power_down                                 ),
    .do_self_rfsh                                  (do_self_rfsh                                  ),
    .to_chip                                       (to_chip                                       ),
    .to_bank_addr                                  (to_bank_addr                                  ),
    .to_row_addr                                   (to_row_addr                                   ),
    .fetch                                         (fetch                                         ),
    .more_than_x0_act_to_rdwr                      (more_than_x0_act_to_rdwr                      ),
    .more_than_x0_act_to_pch                       (more_than_x0_act_to_pch                       ),
    .more_than_x0_act_to_act                       (more_than_x0_act_to_act                       ),
    .more_than_x0_rd_to_rd                         (more_than_x0_rd_to_rd                         ),
    .more_than_x0_rd_to_wr                         (more_than_x0_rd_to_wr                         ),
    .more_than_x0_rd_to_wr_bc                      (more_than_x0_rd_to_wr_bc                      ),
    .more_than_x0_rd_to_pch                        (more_than_x0_rd_to_pch                        ),
    .more_than_x0_wr_to_wr                         (more_than_x0_wr_to_wr                         ),
    .more_than_x0_wr_to_rd                         (more_than_x0_wr_to_rd                         ),
    .more_than_x0_wr_to_pch                        (more_than_x0_wr_to_pch                        ),
    .more_than_x0_rd_ap_to_act                     (more_than_x0_rd_ap_to_act                     ),
    .more_than_x0_wr_ap_to_act                     (more_than_x0_wr_ap_to_act                     ),
    .more_than_x0_pch_to_act                       (more_than_x0_pch_to_act                       ),
    .more_than_x0_act_to_act_diff_bank             (more_than_x0_act_to_act_diff_bank             ),
    .more_than_x0_four_act_to_act                  (more_than_x0_four_act_to_act                  ),
    .less_than_x0_act_to_rdwr                      (less_than_x0_act_to_rdwr                      ),
    .less_than_x0_act_to_pch                       (less_than_x0_act_to_pch                       ),
    .less_than_x0_act_to_act                       (less_than_x0_act_to_act                       ),
    .less_than_x0_rd_to_rd                         (less_than_x0_rd_to_rd                         ),
    .less_than_x0_rd_to_wr                         (less_than_x0_rd_to_wr                         ),
    .less_than_x0_rd_to_wr_bc                      (less_than_x0_rd_to_wr_bc                      ),
    .less_than_x0_rd_to_pch                        (less_than_x0_rd_to_pch                        ),
    .less_than_x0_wr_to_wr                         (less_than_x0_wr_to_wr                         ),
    .less_than_x0_wr_to_rd                         (less_than_x0_wr_to_rd                         ),
    .less_than_x0_wr_to_rd_diff_chips              (less_than_x0_wr_to_rd_diff_chips              ),
    .less_than_x0_wr_to_pch                        (less_than_x0_wr_to_pch                        ),
    .less_than_x0_rd_ap_to_act                     (less_than_x0_rd_ap_to_act                     ),
    .less_than_x0_wr_ap_to_act                     (less_than_x0_wr_ap_to_act                     ),
    .less_than_x0_pch_to_act                       (less_than_x0_pch_to_act                       ),
    .less_than_x0_act_to_act_diff_bank             (less_than_x0_act_to_act_diff_bank             ),
    .less_than_x0_four_act_to_act                  (less_than_x0_four_act_to_act                  ),
    .more_than_x1_act_to_rdwr                      (more_than_x1_act_to_rdwr                      ),
    .more_than_x1_act_to_pch                       (more_than_x1_act_to_pch                       ),
    .more_than_x1_act_to_act                       (more_than_x1_act_to_act                       ),
    .more_than_x1_rd_to_rd                         (more_than_x1_rd_to_rd                         ),
    .more_than_x1_rd_to_wr                         (more_than_x1_rd_to_wr                         ),
    .more_than_x1_rd_to_wr_bc                      (more_than_x1_rd_to_wr_bc                      ),
    .more_than_x1_rd_to_pch                        (more_than_x1_rd_to_pch                        ),
    .more_than_x1_wr_to_wr                         (more_than_x1_wr_to_wr                         ),
    .more_than_x1_wr_to_rd                         (more_than_x1_wr_to_rd                         ),
    .more_than_x1_wr_to_pch                        (more_than_x1_wr_to_pch                        ),
    .more_than_x1_rd_ap_to_act                     (more_than_x1_rd_ap_to_act                     ),
    .more_than_x1_wr_ap_to_act                     (more_than_x1_wr_ap_to_act                     ),
    .more_than_x1_pch_to_act                       (more_than_x1_pch_to_act                       ),
    .more_than_x1_act_to_act_diff_bank             (more_than_x1_act_to_act_diff_bank             ),
    .more_than_x1_four_act_to_act                  (more_than_x1_four_act_to_act                  ),
    .less_than_x1_act_to_rdwr                      (less_than_x1_act_to_rdwr                      ),
    .less_than_x1_act_to_pch                       (less_than_x1_act_to_pch                       ),
    .less_than_x1_act_to_act                       (less_than_x1_act_to_act                       ),
    .less_than_x1_rd_to_rd                         (less_than_x1_rd_to_rd                         ),
    .less_than_x1_rd_to_wr                         (less_than_x1_rd_to_wr                         ),
    .less_than_x1_rd_to_wr_bc                      (less_than_x1_rd_to_wr_bc                      ),
    .less_than_x1_rd_to_pch                        (less_than_x1_rd_to_pch                        ),
    .less_than_x1_wr_to_wr                         (less_than_x1_wr_to_wr                         ),
    .less_than_x1_wr_to_rd                         (less_than_x1_wr_to_rd                         ),
    .less_than_x1_wr_to_rd_diff_chips              (less_than_x1_wr_to_rd_diff_chips              ),
    .less_than_x1_wr_to_pch                        (less_than_x1_wr_to_pch                        ),
    .less_than_x1_rd_ap_to_act                     (less_than_x1_rd_ap_to_act                     ),
    .less_than_x1_wr_ap_to_act                     (less_than_x1_wr_ap_to_act                     ),
    .less_than_x1_pch_to_act                       (less_than_x1_pch_to_act                       ),
    .less_than_x1_act_to_act_diff_bank             (less_than_x1_act_to_act_diff_bank             ),
    .less_than_x1_four_act_to_act                  (less_than_x1_four_act_to_act                  ),
    .more_than_x2_act_to_rdwr                      (more_than_x2_act_to_rdwr                      ),
    .more_than_x2_act_to_pch                       (more_than_x2_act_to_pch                       ),
    .more_than_x2_act_to_act                       (more_than_x2_act_to_act                       ),
    .more_than_x2_rd_to_rd                         (more_than_x2_rd_to_rd                         ),
    .more_than_x2_rd_to_wr                         (more_than_x2_rd_to_wr                         ),
    .more_than_x2_rd_to_wr_bc                      (more_than_x2_rd_to_wr_bc                      ),
    .more_than_x2_rd_to_pch                        (more_than_x2_rd_to_pch                        ),
    .more_than_x2_wr_to_wr                         (more_than_x2_wr_to_wr                         ),
    .more_than_x2_wr_to_rd                         (more_than_x2_wr_to_rd                         ),
    .more_than_x2_wr_to_pch                        (more_than_x2_wr_to_pch                        ),
    .more_than_x2_rd_ap_to_act                     (more_than_x2_rd_ap_to_act                     ),
    .more_than_x2_wr_ap_to_act                     (more_than_x2_wr_ap_to_act                     ),
    .more_than_x2_pch_to_act                       (more_than_x2_pch_to_act                       ),
    .more_than_x2_act_to_act_diff_bank             (more_than_x2_act_to_act_diff_bank             ),
    .more_than_x2_four_act_to_act                  (more_than_x2_four_act_to_act                  ),
    .less_than_x2_act_to_rdwr                      (less_than_x2_act_to_rdwr                      ),
    .less_than_x2_act_to_pch                       (less_than_x2_act_to_pch                       ),
    .less_than_x2_act_to_act                       (less_than_x2_act_to_act                       ),
    .less_than_x2_rd_to_rd                         (less_than_x2_rd_to_rd                         ),
    .less_than_x2_rd_to_wr                         (less_than_x2_rd_to_wr                         ),
    .less_than_x2_rd_to_wr_bc                      (less_than_x2_rd_to_wr_bc                      ),
    .less_than_x2_rd_to_pch                        (less_than_x2_rd_to_pch                        ),
    .less_than_x2_wr_to_wr                         (less_than_x2_wr_to_wr                         ),
    .less_than_x2_wr_to_rd                         (less_than_x2_wr_to_rd                         ),
    .less_than_x2_wr_to_rd_diff_chips              (less_than_x2_wr_to_rd_diff_chips              ),
    .less_than_x2_wr_to_pch                        (less_than_x2_wr_to_pch                        ),
    .less_than_x2_rd_ap_to_act                     (less_than_x2_rd_ap_to_act                     ),
    .less_than_x2_wr_ap_to_act                     (less_than_x2_wr_ap_to_act                     ),
    .less_than_x2_pch_to_act                       (less_than_x2_pch_to_act                       ),
    .less_than_x2_act_to_act_diff_bank             (less_than_x2_act_to_act_diff_bank             ),
    .less_than_x2_four_act_to_act                  (less_than_x2_four_act_to_act                  ),
    .read_dqs_ready                                (read_dqs_ready                                ),
    .write_dqs_ready                               (write_dqs_ready                               ),
    .write_to_read_finish_twtr                     (write_to_read_finish_twtr                     ),
    .in_cs_all_banks_closed                        (cache_out_cs_all_banks_closed                 ),
    .in_cs_can_precharge_all                       (cache_out_cs_can_precharge_all                ),
    .in_cs_can_refresh                             (cache_out_cs_can_refresh                      ),
    .in_cs_can_self_refresh                        (cache_out_cs_can_self_refresh                 ),
    .in_cs_can_power_down                          (cache_out_cs_can_power_down                   ),
    .in_cs_can_exit_power_saving_mode              (cache_out_cs_can_exit_power_saving_mode       ),
    .in_cs_zq_cal_req                              (cache_out_cs_zq_cal_req                       ),
    .in_cs_power_down_req                          (cache_out_cs_power_down_req                   ),
    .in_cs_refresh_req                             (cache_out_cs_refresh_req                      ),
    .in_cmd_bank_is_open                           (cache_out_cmd_bank_is_open                    ),
    .in_cmd_row_is_open                            (cache_out_cmd_row_is_open                     ),
    .in_cmd_can_write                              (cache_out_cmd_can_write                       ),
    .in_cmd_can_read                               (cache_out_cmd_can_read                        ),
    .in_cmd_can_activate                           (cache_out_cmd_can_activate                    ),
    .in_cmd_can_precharge                          (cache_out_cmd_can_precharge                   ),
    .in_cmd_info_valid                             (cache_out_cmd_info_valid                      ),
    .out_cs_all_banks_closed                       (out_cs_all_banks_closed                       ),
    .out_cs_can_precharge_all                      (out_cs_can_precharge_all                      ),
    .out_cs_can_refresh                            (out_cs_can_refresh                            ),
    .out_cs_can_self_refresh                       (out_cs_can_self_refresh                       ),
    .out_cs_can_power_down                         (out_cs_can_power_down                         ),
    .out_cs_can_exit_power_saving_mode             (out_cs_can_exit_power_saving_mode             ),
    .out_cs_zq_cal_req                             (out_cs_zq_cal_req                             ),
    .out_cs_power_down_req                         (out_cs_power_down_req                         ),
    .out_cs_refresh_req                            (out_cs_refresh_req                            ),
    .out_cmd_bank_is_open                          (out_cmd_bank_is_open                          ),
    .out_cmd_row_is_open                           (out_cmd_row_is_open                           ),
    .out_cmd_can_write                             (out_cmd_can_write                             ),
    .out_cmd_can_read                              (out_cmd_can_read                              ),
    .out_cmd_can_activate                          (out_cmd_can_activate                          ),
    .out_cmd_can_precharge                         (out_cmd_can_precharge                         ),
    .out_cmd_info_valid                            (out_cmd_info_valid                            )
);

alt_ddrx_timing_param #
(
    .MEM_IF_RD_TO_WR_TURNAROUND_OCT                (MEM_IF_RD_TO_WR_TURNAROUND_OCT                ),
    .MEM_IF_WR_TO_RD_TURNAROUND_OCT                (MEM_IF_WR_TO_RD_TURNAROUND_OCT                ),
    .MEM_IF_WR_TO_RD_DIFF_CHIPS_TURNAROUND_OCT     (MEM_IF_WR_TO_RD_DIFF_CHIPS_TURNAROUND_OCT     ),
    .MEM_TYPE                                      (MEM_TYPE                                      ),
    .DWIDTH_RATIO                                  (DWIDTH_RATIO                                  ),
    .MEMORY_BURSTLENGTH                            (MEMORY_BURSTLENGTH                            ),
    .CAS_WR_LAT_BUS_WIDTH                          (CAS_WR_LAT_BUS_WIDTH                          ),
    .ADD_LAT_BUS_WIDTH                             (ADD_LAT_BUS_WIDTH                             ),
    .TCL_BUS_WIDTH                                 (TCL_BUS_WIDTH                                 ),
    .TRRD_BUS_WIDTH                                (TRRD_BUS_WIDTH                                ),
    .TFAW_BUS_WIDTH                                (TFAW_BUS_WIDTH                                ),
    .TRFC_BUS_WIDTH                                (TRFC_BUS_WIDTH                                ),
    .TREFI_BUS_WIDTH                               (TREFI_BUS_WIDTH                               ),
    .TRCD_BUS_WIDTH                                (TRCD_BUS_WIDTH                                ),
    .TRP_BUS_WIDTH                                 (TRP_BUS_WIDTH                                 ),
    .TWR_BUS_WIDTH                                 (TWR_BUS_WIDTH                                 ),
    .TWTR_BUS_WIDTH                                (TWTR_BUS_WIDTH                                ),
    .TRTP_BUS_WIDTH                                (TRTP_BUS_WIDTH                                ),
    .TRAS_BUS_WIDTH                                (TRAS_BUS_WIDTH                                ),
    .TRC_BUS_WIDTH                                 (TRC_BUS_WIDTH                                 ),
    .AUTO_PD_BUS_WIDTH                             (AUTO_PD_BUS_WIDTH                             ),
    .BURST_LENGTH_BUS_WIDTH                        (BURST_LENGTH_BUS_WIDTH                        ),
    .SELF_RFSH_EXIT_CYCLES_BUS_WIDTH               (SELF_RFSH_EXIT_CYCLES_BUS_WIDTH               ),
    .ACT_TO_RDWR_WIDTH                             (ACT_TO_RDWR_WIDTH                             ),
    .ACT_TO_PCH_WIDTH                              (ACT_TO_PCH_WIDTH                              ),
    .ACT_TO_ACT_WIDTH                              (ACT_TO_ACT_WIDTH                              ),
    .RD_TO_RD_WIDTH                                (RD_TO_RD_WIDTH                                ),
    .RD_TO_WR_WIDTH                                (RD_TO_WR_WIDTH                                ),
    .RD_TO_WR_BC_WIDTH                             (RD_TO_WR_BC_WIDTH                             ),
    .RD_TO_PCH_WIDTH                               (RD_TO_PCH_WIDTH                               ),
    .WR_TO_WR_WIDTH                                (WR_TO_WR_WIDTH                                ),
    .WR_TO_RD_WIDTH                                (WR_TO_RD_WIDTH                                ),
    .WR_TO_PCH_WIDTH                               (WR_TO_PCH_WIDTH                               ),
    .RD_AP_TO_ACT_WIDTH                            (RD_AP_TO_ACT_WIDTH                            ),
    .WR_AP_TO_ACT_WIDTH                            (WR_AP_TO_ACT_WIDTH                            ),
    .PCH_TO_ACT_WIDTH                              (PCH_TO_ACT_WIDTH                              ),
    .PCH_ALL_TO_VALID_WIDTH                        (PCH_ALL_TO_VALID_WIDTH                        ),
    .ARF_TO_VALID_WIDTH                            (ARF_TO_VALID_WIDTH                            ),
    .PDN_TO_VALID_WIDTH                            (PDN_TO_VALID_WIDTH                            ),
    .SRF_TO_VALID_WIDTH                            (SRF_TO_VALID_WIDTH                            ),
    .ARF_PERIOD_WIDTH                              (ARF_PERIOD_WIDTH                              ),
    .PDN_PERIOD_WIDTH                              (PDN_PERIOD_WIDTH                              ),
    .ACT_TO_ACT_DIFF_BANK_WIDTH                    (ACT_TO_ACT_DIFF_BANK_WIDTH                    ),
    .FOUR_ACT_TO_ACT_WIDTH                         (FOUR_ACT_TO_ACT_WIDTH                         )
)
timing_param_inst
(
    .ctl_clk                                       (ctl_clk                                       ),
    .ctl_reset_n                                   (ctl_reset_n[4]                                ),
    .mem_cas_wr_lat                                (mem_cas_wr_lat                                ),
    .mem_add_lat                                   (mem_add_lat                                   ),
    .mem_tcl                                       (mem_tcl                                       ),
    .mem_trrd                                      (mem_trrd                                      ),
    .mem_tfaw                                      (mem_tfaw                                      ),
    .mem_trfc                                      (mem_trfc                                      ),
    .mem_trefi                                     (mem_trefi                                     ),
    .mem_trcd                                      (mem_trcd                                      ),
    .mem_trp                                       (mem_trp                                       ),
    .mem_twr                                       (mem_twr                                       ),
    .mem_twtr                                      (mem_twtr                                      ),
    .mem_trtp                                      (mem_trtp                                      ),
    .mem_tras                                      (mem_tras                                      ),
    .mem_trc                                       (mem_trc                                       ),
    .mem_auto_pd_cycles                            (mem_auto_pd_cycles                            ),
    .mem_burst_length                              (mem_burst_length                              ),
    .mem_self_rfsh_exit_cycles                     (mem_self_rfsh_exit_cycles                     ),
    .mem_rd_to_wr_turnaround_oct                   (mem_rd_to_wr_turnaround_oct                   ),
    .mem_wr_to_rd_turnaround_oct                   (mem_wr_to_rd_turnaround_oct                   ),
    .act_to_rdwr                                   (act_to_rdwr                                   ),
    .act_to_pch                                    (act_to_pch                                    ),
    .act_to_act                                    (act_to_act                                    ),
    .rd_to_rd                                      (rd_to_rd                                      ),
    .rd_to_wr                                      (rd_to_wr                                      ),
    .rd_to_wr_bc                                   (rd_to_wr_bc                                   ),
    .rd_to_pch                                     (rd_to_pch                                     ),
    .wr_to_wr                                      (wr_to_wr                                      ),
    .wr_to_rd                                      (wr_to_rd                                      ),
    .wr_to_rd_diff_chips                           (wr_to_rd_diff_chips                           ),
    .wr_to_pch                                     (wr_to_pch                                     ),
    .rd_ap_to_act                                  (rd_ap_to_act                                  ),
    .wr_ap_to_act                                  (wr_ap_to_act                                  ),
    .pch_to_act                                    (pch_to_act                                    ),
    .pch_all_to_valid                              (pch_all_to_valid                              ),
    .arf_to_valid                                  (arf_to_valid                                  ),
    .pdn_to_valid                                  (pdn_to_valid                                  ),
    .srf_to_valid                                  (srf_to_valid                                  ),
    .srf_to_zq                                     (srf_to_zq                                     ),
    .arf_period                                    (arf_period                                    ),
    .pdn_period                                    (pdn_period                                    ),
    .act_to_act_diff_bank                          (act_to_act_diff_bank                          ),
    .four_act_to_act                               (four_act_to_act                               ),
    .more_than_2_act_to_rdwr                       (more_than_2_act_to_rdwr                       ),
    .more_than_2_act_to_pch                        (more_than_2_act_to_pch                        ),
    .more_than_2_act_to_act                        (more_than_2_act_to_act                        ),
    .more_than_2_rd_to_rd                          (more_than_2_rd_to_rd                          ),
    .more_than_2_rd_to_wr                          (more_than_2_rd_to_wr                          ),
    .more_than_2_rd_to_wr_bc                       (more_than_2_rd_to_wr_bc                       ),
    .more_than_2_rd_to_pch                         (more_than_2_rd_to_pch                         ),
    .more_than_2_wr_to_wr                          (more_than_2_wr_to_wr                          ),
    .more_than_2_wr_to_rd                          (more_than_2_wr_to_rd                          ),
    .more_than_2_wr_to_pch                         (more_than_2_wr_to_pch                         ),
    .more_than_2_rd_ap_to_act                      (more_than_2_rd_ap_to_act                      ),
    .more_than_2_wr_ap_to_act                      (more_than_2_wr_ap_to_act                      ),
    .more_than_2_pch_to_act                        (more_than_2_pch_to_act                        ),
    .more_than_2_act_to_act_diff_bank              (more_than_2_act_to_act_diff_bank              ),
    .more_than_2_four_act_to_act                   (more_than_2_four_act_to_act                   ),
    .less_than_2_act_to_rdwr                       (less_than_2_act_to_rdwr                       ),
    .less_than_2_act_to_pch                        (less_than_2_act_to_pch                        ),
    .less_than_2_act_to_act                        (less_than_2_act_to_act                        ),
    .less_than_2_rd_to_rd                          (less_than_2_rd_to_rd                          ),
    .less_than_2_rd_to_wr                          (less_than_2_rd_to_wr                          ),
    .less_than_2_rd_to_wr_bc                       (less_than_2_rd_to_wr_bc                       ),
    .less_than_2_rd_to_pch                         (less_than_2_rd_to_pch                         ),
    .less_than_2_wr_to_wr                          (less_than_2_wr_to_wr                          ),
    .less_than_2_wr_to_rd                          (less_than_2_wr_to_rd                          ),
    .less_than_2_wr_to_rd_diff_chips               (less_than_2_wr_to_rd_diff_chips               ),
    .less_than_2_wr_to_pch                         (less_than_2_wr_to_pch                         ),
    .less_than_2_rd_ap_to_act                      (less_than_2_rd_ap_to_act                      ),
    .less_than_2_wr_ap_to_act                      (less_than_2_wr_ap_to_act                      ),
    .less_than_2_pch_to_act                        (less_than_2_pch_to_act                        ),
    .less_than_2_act_to_act_diff_bank              (less_than_2_act_to_act_diff_bank              ),
    .less_than_2_four_act_to_act                   (less_than_2_four_act_to_act                   ),
    .more_than_3_act_to_rdwr                       (more_than_3_act_to_rdwr                       ),
    .more_than_3_act_to_pch                        (more_than_3_act_to_pch                        ),
    .more_than_3_act_to_act                        (more_than_3_act_to_act                        ),
    .more_than_3_rd_to_rd                          (more_than_3_rd_to_rd                          ),
    .more_than_3_rd_to_wr                          (more_than_3_rd_to_wr                          ),
    .more_than_3_rd_to_wr_bc                       (more_than_3_rd_to_wr_bc                       ),
    .more_than_3_rd_to_pch                         (more_than_3_rd_to_pch                         ),
    .more_than_3_wr_to_wr                          (more_than_3_wr_to_wr                          ),
    .more_than_3_wr_to_rd                          (more_than_3_wr_to_rd                          ),
    .more_than_3_wr_to_pch                         (more_than_3_wr_to_pch                         ),
    .more_than_3_rd_ap_to_act                      (more_than_3_rd_ap_to_act                      ),
    .more_than_3_wr_ap_to_act                      (more_than_3_wr_ap_to_act                      ),
    .more_than_3_pch_to_act                        (more_than_3_pch_to_act                        ),
    .more_than_3_act_to_act_diff_bank              (more_than_3_act_to_act_diff_bank              ),
    .more_than_3_four_act_to_act                   (more_than_3_four_act_to_act                   ),
    .less_than_3_act_to_rdwr                       (less_than_3_act_to_rdwr                       ),
    .less_than_3_act_to_pch                        (less_than_3_act_to_pch                        ),
    .less_than_3_act_to_act                        (less_than_3_act_to_act                        ),
    .less_than_3_rd_to_rd                          (less_than_3_rd_to_rd                          ),
    .less_than_3_rd_to_wr                          (less_than_3_rd_to_wr                          ),
    .less_than_3_rd_to_wr_bc                       (less_than_3_rd_to_wr_bc                       ),
    .less_than_3_rd_to_pch                         (less_than_3_rd_to_pch                         ),
    .less_than_3_wr_to_wr                          (less_than_3_wr_to_wr                          ),
    .less_than_3_wr_to_rd                          (less_than_3_wr_to_rd                          ),
    .less_than_3_wr_to_rd_diff_chips               (less_than_3_wr_to_rd_diff_chips               ),
    .less_than_3_wr_to_pch                         (less_than_3_wr_to_pch                         ),
    .less_than_3_rd_ap_to_act                      (less_than_3_rd_ap_to_act                      ),
    .less_than_3_wr_ap_to_act                      (less_than_3_wr_ap_to_act                      ),
    .less_than_3_pch_to_act                        (less_than_3_pch_to_act                        ),
    .less_than_3_act_to_act_diff_bank              (less_than_3_act_to_act_diff_bank              ),
    .less_than_3_four_act_to_act                   (less_than_3_four_act_to_act                   ),
    .more_than_4_act_to_rdwr                       (more_than_4_act_to_rdwr                       ),
    .more_than_4_act_to_pch                        (more_than_4_act_to_pch                        ),
    .more_than_4_act_to_act                        (more_than_4_act_to_act                        ),
    .more_than_4_rd_to_rd                          (more_than_4_rd_to_rd                          ),
    .more_than_4_rd_to_wr                          (more_than_4_rd_to_wr                          ),
    .more_than_4_rd_to_wr_bc                       (more_than_4_rd_to_wr_bc                       ),
    .more_than_4_rd_to_pch                         (more_than_4_rd_to_pch                         ),
    .more_than_4_wr_to_wr                          (more_than_4_wr_to_wr                          ),
    .more_than_4_wr_to_rd                          (more_than_4_wr_to_rd                          ),
    .more_than_4_wr_to_pch                         (more_than_4_wr_to_pch                         ),
    .more_than_4_rd_ap_to_act                      (more_than_4_rd_ap_to_act                      ),
    .more_than_4_wr_ap_to_act                      (more_than_4_wr_ap_to_act                      ),
    .more_than_4_pch_to_act                        (more_than_4_pch_to_act                        ),
    .more_than_4_act_to_act_diff_bank              (more_than_4_act_to_act_diff_bank              ),
    .more_than_4_four_act_to_act                   (more_than_4_four_act_to_act                   ),
    .less_than_4_act_to_rdwr                       (less_than_4_act_to_rdwr                       ),
    .less_than_4_act_to_pch                        (less_than_4_act_to_pch                        ),
    .less_than_4_act_to_act                        (less_than_4_act_to_act                        ),
    .less_than_4_rd_to_rd                          (less_than_4_rd_to_rd                          ),
    .less_than_4_rd_to_wr                          (less_than_4_rd_to_wr                          ),
    .less_than_4_rd_to_wr_bc                       (less_than_4_rd_to_wr_bc                       ),
    .less_than_4_rd_to_pch                         (less_than_4_rd_to_pch                         ),
    .less_than_4_wr_to_wr                          (less_than_4_wr_to_wr                          ),
    .less_than_4_wr_to_rd                          (less_than_4_wr_to_rd                          ),
    .less_than_4_wr_to_rd_diff_chips               (less_than_4_wr_to_rd_diff_chips               ),
    .less_than_4_wr_to_pch                         (less_than_4_wr_to_pch                         ),
    .less_than_4_rd_ap_to_act                      (less_than_4_rd_ap_to_act                      ),
    .less_than_4_wr_ap_to_act                      (less_than_4_wr_ap_to_act                      ),
    .less_than_4_pch_to_act                        (less_than_4_pch_to_act                        ),
    .less_than_4_act_to_act_diff_bank              (less_than_4_act_to_act_diff_bank              ),
    .less_than_4_four_act_to_act                   (less_than_4_four_act_to_act                   ),
    .more_than_5_act_to_rdwr                       (more_than_5_act_to_rdwr                       ),
    .more_than_5_act_to_pch                        (more_than_5_act_to_pch                        ),
    .more_than_5_act_to_act                        (more_than_5_act_to_act                        ),
    .more_than_5_rd_to_rd                          (more_than_5_rd_to_rd                          ),
    .more_than_5_rd_to_wr                          (more_than_5_rd_to_wr                          ),
    .more_than_5_rd_to_wr_bc                       (more_than_5_rd_to_wr_bc                       ),
    .more_than_5_rd_to_pch                         (more_than_5_rd_to_pch                         ),
    .more_than_5_wr_to_wr                          (more_than_5_wr_to_wr                          ),
    .more_than_5_wr_to_rd                          (more_than_5_wr_to_rd                          ),
    .more_than_5_wr_to_pch                         (more_than_5_wr_to_pch                         ),
    .more_than_5_rd_ap_to_act                      (more_than_5_rd_ap_to_act                      ),
    .more_than_5_wr_ap_to_act                      (more_than_5_wr_ap_to_act                      ),
    .more_than_5_pch_to_act                        (more_than_5_pch_to_act                        ),
    .more_than_5_act_to_act_diff_bank              (more_than_5_act_to_act_diff_bank              ),
    .more_than_5_four_act_to_act                   (more_than_5_four_act_to_act                   ),
    .less_than_5_act_to_rdwr                       (less_than_5_act_to_rdwr                       ),
    .less_than_5_act_to_pch                        (less_than_5_act_to_pch                        ),
    .less_than_5_act_to_act                        (less_than_5_act_to_act                        ),
    .less_than_5_rd_to_rd                          (less_than_5_rd_to_rd                          ),
    .less_than_5_rd_to_wr                          (less_than_5_rd_to_wr                          ),
    .less_than_5_rd_to_wr_bc                       (less_than_5_rd_to_wr_bc                       ),
    .less_than_5_rd_to_pch                         (less_than_5_rd_to_pch                         ),
    .less_than_5_wr_to_wr                          (less_than_5_wr_to_wr                          ),
    .less_than_5_wr_to_rd                          (less_than_5_wr_to_rd                          ),
    .less_than_5_wr_to_rd_diff_chips               (less_than_5_wr_to_rd_diff_chips               ),
    .less_than_5_wr_to_pch                         (less_than_5_wr_to_pch                         ),
    .less_than_5_rd_ap_to_act                      (less_than_5_rd_ap_to_act                      ),
    .less_than_5_wr_ap_to_act                      (less_than_5_wr_ap_to_act                      ),
    .less_than_5_pch_to_act                        (less_than_5_pch_to_act                        ),
    .less_than_5_act_to_act_diff_bank              (less_than_5_act_to_act_diff_bank              ),
    .less_than_5_four_act_to_act                   (less_than_5_four_act_to_act                   ),
    .add_lat_on                                    (add_lat_on                                    )
);

endmodule
