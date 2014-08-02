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
// File          : alt_ddrx_bank_timer.v
//
// Abstract      : 
///////////////////////////////////////////////////////////////////////////////

module alt_ddrx_bank_timer #
    ( parameter
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS                          = 2,
        MEM_IF_CS_WIDTH                           = 4,
        MEM_IF_ROW_WIDTH                          = 16,            // max supported row bits
        MEM_IF_BA_WIDTH                           = 3,             // max supported bank bits
        MEM_TYPE                                  = "DDR3",
        
        DWIDTH_RATIO                              = 2,             // 2 - fullrate, 4 - halfrate
        CLOSE_PAGE_POLICY                         = 1,
        
        // bank timer settings
        BANK_TIMER_INFO_INPUT_REGD                = 1,
        BANK_TIMER_COUNTER_OFFSET                 = 4,
        
        // controller settings
        CTL_LOOK_AHEAD_DEPTH                      = 4,
        CTL_CMD_QUEUE_DEPTH                       = 8,
        CTL_USR_REFRESH                           = 0,             // enabled user refresh
        CTL_DYNAMIC_BANK_ALLOCATION               = 0,
        CTL_DYNAMIC_BANK_NUM                      = 4,             // CTL_DYNAMIC_BANK_NUM must be >= CTL_LOOK_AHEAD_DEPTH     
        
        BURST_LENGTH_BUS_WIDTH                    = 4,
        TMRD_BUS_WIDTH                            = 3,
        TMOD_BUS_WIDTH                            = 4,
        SELF_RFSH_EXIT_CYCLES_BUS_WIDTH           = 10,
        ACT_TO_RDWR_WIDTH                         = 4,
        ACT_TO_PCH_WIDTH                          = 5,
        ACT_TO_ACT_WIDTH                          = 6,
        RD_TO_RD_WIDTH                            = 3,
        RD_TO_WR_WIDTH                            = 5,
        RD_TO_WR_BC_WIDTH                         = 4,
        RD_TO_PCH_WIDTH                           = 4,
        WR_TO_WR_WIDTH                            = 3,
        WR_TO_RD_WIDTH                            = 5,
        WR_TO_PCH_WIDTH                           = 5,
        RD_AP_TO_ACT_WIDTH                        = 5,
        WR_AP_TO_ACT_WIDTH                        = 6,
        PCH_TO_ACT_WIDTH                          = 4,
        PCH_ALL_TO_VALID_WIDTH                    = 4,
        ARF_TO_VALID_WIDTH                        = 8,
        PDN_TO_VALID_WIDTH                        = 2,
        SRF_TO_VALID_WIDTH                        = 10,
        ARF_PERIOD_WIDTH                          = 13,
        PDN_PERIOD_WIDTH                          = 16,
        ACT_TO_ACT_DIFF_BANK_WIDTH                = 4,
        FOUR_ACT_TO_ACT_WIDTH                     = 6
    )
    (
        // port connections
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
        
        // timing param input
        act_to_rdwr,
        act_to_pch,
        act_to_act,
        rd_to_rd,
        rd_to_wr,
        rd_to_wr_bc,
        rd_to_pch,
        wr_to_wr,
        wr_to_rd,
        wr_to_rd_diff_chips,
        wr_to_pch,
        rd_ap_to_act,
        wr_ap_to_act,
        pch_to_act,
        pch_all_to_valid,
        arf_to_valid,
        pdn_to_valid,
        srf_to_valid,
        srf_to_zq,
        arf_period,
        pdn_period,
        act_to_act_diff_bank,
        four_act_to_act,
        
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
        act_tfaw_ready,
        act_trrd_ready,
        read_dqs_ready,
        write_dqs_ready,
        write_to_read_finish_twtr,
        power_saving_enter_ready,
        power_saving_exit_ready,
        
        // bank info outputs
        cs_all_banks_closed,
        
        cmd_bank_is_open,
        cmd_row_is_open,
        
        // timer info outputs
        cs_can_precharge_all,
        cs_can_refresh,
        cs_can_self_refresh,
        cs_can_power_down,
        cs_can_exit_power_saving_mode,
        
        cmd_can_write,
        cmd_can_read,
        cmd_can_activate,
        cmd_can_precharge,
        
        // common logic output
        can_al_activate_read,
        can_al_activate_write,
        
        // CAM output
        cam_full
    );

input  ctl_clk;
input  ctl_reset_n;

// command queue entry inputs
input  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_CHIP_BITS - 1 : 0] cmd_chip_addr;
input  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_BA_WIDTH  - 1 : 0] cmd_bank_addr;
input  [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_ROW_WIDTH - 1 : 0] cmd_row_addr;
input  [CTL_CMD_QUEUE_DEPTH                              : 0] cmd_multicast_req;

// timing value inputs
input  [ACT_TO_RDWR_WIDTH               - 1 : 0] act_to_rdwr;
input  [ACT_TO_PCH_WIDTH                - 1 : 0] act_to_pch;
input  [ACT_TO_ACT_WIDTH                - 1 : 0] act_to_act;
input  [RD_TO_RD_WIDTH                  - 1 : 0] rd_to_rd;
input  [RD_TO_WR_WIDTH                  - 1 : 0] rd_to_wr;
input  [RD_TO_WR_BC_WIDTH               - 1 : 0] rd_to_wr_bc;
input  [RD_TO_PCH_WIDTH                 - 1 : 0] rd_to_pch;
input  [WR_TO_WR_WIDTH                  - 1 : 0] wr_to_wr;
input  [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd;
input  [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd_diff_chips;
input  [WR_TO_PCH_WIDTH                 - 1 : 0] wr_to_pch;
input  [RD_AP_TO_ACT_WIDTH              - 1 : 0] rd_ap_to_act;
input  [WR_AP_TO_ACT_WIDTH              - 1 : 0] wr_ap_to_act;
input  [PCH_TO_ACT_WIDTH                - 1 : 0] pch_to_act;
input  [PCH_ALL_TO_VALID_WIDTH          - 1 : 0] pch_all_to_valid;
input  [ARF_TO_VALID_WIDTH              - 1 : 0] arf_to_valid;
input  [PDN_TO_VALID_WIDTH              - 1 : 0] pdn_to_valid;
input  [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_valid;
input  [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_zq;
input  [ARF_PERIOD_WIDTH                - 1 : 0] arf_period;
input  [PDN_PERIOD_WIDTH                - 1 : 0] pdn_period;
input  [ACT_TO_ACT_DIFF_BANK_WIDTH      - 1 : 0] act_to_act_diff_bank;
input  [FOUR_ACT_TO_ACT_WIDTH           - 1 : 0] four_act_to_act;

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

// rank monitor inputs
input  [MEM_IF_CS_WIDTH    - 1 : 0] act_tfaw_ready;
input  [MEM_IF_CS_WIDTH    - 1 : 0] act_trrd_ready;
input                               read_dqs_ready;
input                               write_dqs_ready;
input  [MEM_IF_CS_WIDTH    - 1 : 0] write_to_read_finish_twtr;
input  [MEM_IF_CS_WIDTH    - 1 : 0] power_saving_enter_ready;
input  [MEM_IF_CS_WIDTH    - 1 : 0] power_saving_exit_ready;

// bank info outputs
output [MEM_IF_CS_WIDTH - 1  : 0] cs_all_banks_closed;

output [CTL_LOOK_AHEAD_DEPTH : 0] cmd_bank_is_open;
output [CTL_LOOK_AHEAD_DEPTH : 0] cmd_row_is_open;

// timer info outputs
output [MEM_IF_CS_WIDTH - 1  : 0] cs_can_precharge_all;
output [MEM_IF_CS_WIDTH - 1  : 0] cs_can_refresh;
output [MEM_IF_CS_WIDTH - 1  : 0] cs_can_self_refresh;
output [MEM_IF_CS_WIDTH - 1  : 0] cs_can_power_down;
output [MEM_IF_CS_WIDTH - 1  : 0] cs_can_exit_power_saving_mode;

output [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_write;
output [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_read;
output [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_activate;
output [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_precharge;

// common logic output
output can_al_activate_read;
output can_al_activate_write;

// CAM output
output cam_full;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Registers & Wires

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Bank Logic
    ------------------------------------------------------------------------------*/
    reg    [MEM_IF_CS_WIDTH - 1  : 0] cs_all_banks_closed;
    reg    [CTL_LOOK_AHEAD_DEPTH : 0] cmd_bank_is_open;
    reg    [CTL_LOOK_AHEAD_DEPTH : 0] cmd_row_is_open;
    
    /*------------------------------------------------------------------------------
        Timer Logic
    ------------------------------------------------------------------------------*/
    reg    [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_write;
    reg    [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_read;
    reg    [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_activate;
    reg    [CTL_LOOK_AHEAD_DEPTH : 0] cmd_can_precharge;
    
    reg    [MEM_IF_CS_WIDTH  - 1 : 0] cs_can_precharge_all;
    reg    [MEM_IF_CS_WIDTH  - 1 : 0] cs_can_refresh;
    reg    [MEM_IF_CS_WIDTH  - 1 : 0] cs_can_self_refresh;
    reg    [MEM_IF_CS_WIDTH  - 1 : 0] cs_can_power_down;
    reg    [MEM_IF_CS_WIDTH  - 1 : 0] cs_can_exit_power_saving_mode;
    
    reg                               can_al_activate_read;
    reg                               can_al_activate_write;
    /*------------------------------------------------------------------------------
        Bank / Timer Input Logic
    ------------------------------------------------------------------------------*/
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] int_open      [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] int_close     [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] int_read      [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] int_write     [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [MEM_IF_ROW_WIDTH       - 1 : 0] int_row_addr;
    
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] open          [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] close         [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] read          [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] write         [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [MEM_IF_ROW_WIDTH       - 1 : 0] row_addr;
     
    wire   [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] current_state [MEM_IF_CS_WIDTH - 1 : 0];
    wire   [MEM_IF_ROW_WIDTH       - 1 : 0] current_row   [MEM_IF_CS_WIDTH - 1 : 0][(2 ** MEM_IF_BA_WIDTH) - 1 : 0];
    wire   [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] rdwr_ready    [MEM_IF_CS_WIDTH - 1 : 0];
    wire   [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] act_ready     [MEM_IF_CS_WIDTH - 1 : 0];
    wire   [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] pch_ready     [MEM_IF_CS_WIDTH - 1 : 0];
    

    /*------------------------------------------------------------------------------
        CTL_DYNAMIC_BANK_ALLOCATION logic
    ------------------------------------------------------------------------------*/

    // cam_handle_cs_partial_match : 
    //      0- to optimize the logic away
    //      1- to handle case where single chip precharge to multicast cam entry. not expected behavior
    wire                                  cam_handle_cs_partial_match = 0;      

    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] int_open_cam  ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] int_close_cam ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] int_read_cam  ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] int_write_cam ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] int_row_addr_cam;

    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] open_cam      ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] close_cam     ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] read_cam      ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] write_cam     ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] row_addr_cam  ;

    reg    [MEM_IF_CS_WIDTH  - 1     : 0] int_cam_cs      [CTL_DYNAMIC_BANK_NUM - 1 : 0];
    reg    [MEM_IF_BA_WIDTH   - 1    : 0] int_cam_bank    [CTL_DYNAMIC_BANK_NUM - 1 : 0];
    reg                                   int_cam_mcast   [CTL_DYNAMIC_BANK_NUM - 1 : 0];

    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_allocate                   ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_deallocate                 ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_update_cs                  ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_v                          ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_priority                   ;

    reg    [MEM_IF_CS_WIDTH  - 1    : 0]  cam_cs         [CTL_DYNAMIC_BANK_NUM - 1 : 0];
    reg    [MEM_IF_BA_WIDTH   - 1    : 0] cam_bank       [CTL_DYNAMIC_BANK_NUM - 1 : 0];
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_mcast      ;

    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_cs_match   ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_cs_partial_match   ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_bank_match ;

    wire   [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_current_free_entry         ;
    reg    [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_current_free_entry_r       ;
                                                                                           
    wire                                  cam_full                       ;
                                                                                           
    wire   [MEM_IF_CHIP_BITS     - 1 : 0] to_chip_addr;
                                                                                           
    wire   [CTL_DYNAMIC_BANK_NUM - 1 : 0] current_state_cam ;
    wire   [CTL_DYNAMIC_BANK_NUM - 1 : 0] rdwr_ready_cam    ;
    wire   [CTL_DYNAMIC_BANK_NUM - 1 : 0] act_ready_cam     ;
    wire   [CTL_DYNAMIC_BANK_NUM - 1 : 0] pch_ready_cam     ;
    wire   [MEM_IF_ROW_WIDTH     - 1 : 0] current_row_cam [CTL_DYNAMIC_BANK_NUM - 1 : 0] ;                  // open row policy not supported using dynamic bank allocation

    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] act_ready_per_chip_cam            [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] current_state_per_chip_cam        [MEM_IF_CS_WIDTH - 1 : 0];

    // CTL_LOOK_AHEAD_DEPTH+1 is to handle "current" as well
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] current_state_per_lookahead_cam   [CTL_LOOK_AHEAD_DEPTH : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] rdwr_ready_per_lookahead_cam      [CTL_LOOK_AHEAD_DEPTH : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] act_ready_per_lookahead_cam       [CTL_LOOK_AHEAD_DEPTH : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] pch_ready_per_lookahead_cam       [CTL_LOOK_AHEAD_DEPTH : 0];

    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] current_state_per_lhead_mcast_cam [CTL_LOOK_AHEAD_DEPTH : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] rdwr_ready_per_lookahead_mcast_cam[CTL_LOOK_AHEAD_DEPTH : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] act_ready_per_lookahead_mcast_cam [CTL_LOOK_AHEAD_DEPTH : 0];
    reg    [CTL_DYNAMIC_BANK_NUM-1   : 0] pch_ready_per_lookahead_mcast_cam [CTL_LOOK_AHEAD_DEPTH : 0];

    // default values on cam miss
    wire   default_current_state_cam_miss   = 0;
    wire   default_act_ready_cam_miss       = 1;
    wire   default_rdwr_ready_cam_miss      = 0;
    wire   default_pch_ready_cam_miss       = 0;
    

/*------------------------------------------------------------------------------

    [END] Registers & Wires

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Bank Logic

------------------------------------------------------------------------------*/
    // All banks closed logic
    generate
        genvar z_cs;
        for (z_cs = 0;z_cs < MEM_IF_CS_WIDTH;z_cs = z_cs + 1)
        begin : all_banks_close_per_chip

            if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
            begin
                // body...
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        cs_all_banks_closed [z_cs] <= 1'b0;
                    end
                    else
                    begin
                        if (!(|current_state [z_cs][(2 ** MEM_IF_BA_WIDTH) - 1 : 0]))
                            cs_all_banks_closed [z_cs] <= 1'b1;
                        else
                            cs_all_banks_closed [z_cs] <= 1'b0;
                    end
                end
            end
            else
            begin 
                // CTL_DYNAMIC_BANK_ALLOCATION == 1
                always @ (posedge ctl_clk or negedge ctl_reset_n) 
                begin
                    if (~ctl_reset_n)
                    begin
                        cs_all_banks_closed[z_cs] <= 1'b0;
                    end
                    else
                    begin
                        cs_all_banks_closed[z_cs] <=  ~(|current_state_per_chip_cam[z_cs]);
                    end
                end
            end


        end
    endgenerate
    
    // Bank/row is open signal for each command queue entry (include current command)
    generate
        genvar z_lookahead;
        genvar z_lookahead_cs;
        for (z_lookahead = 0;z_lookahead < CTL_LOOK_AHEAD_DEPTH + 1;z_lookahead = z_lookahead + 1)
        begin : bank_is_open_per_lookahead
            wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(z_lookahead + 1) * MEM_IF_CHIP_BITS - 1 : z_lookahead * MEM_IF_CHIP_BITS];
            wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(z_lookahead + 1) * MEM_IF_BA_WIDTH  - 1 : z_lookahead * MEM_IF_BA_WIDTH ];
            wire [MEM_IF_ROW_WIDTH - 1 : 0] row_addr  = cmd_row_addr  [(z_lookahead + 1) * MEM_IF_ROW_WIDTH - 1 : z_lookahead * MEM_IF_ROW_WIDTH];
            
            wire [MEM_IF_CS_WIDTH  - 1 : 0] multicast_cmd_bank_is_open;
            //wire [MEM_IF_CS_WIDTH  - 1 : 0] multicast_cmd_row_is_open;
            reg  [MEM_IF_CS_WIDTH  - 1 : 0] multicast_cmd_row_is_open;
            
            wire multicast_bank_is_open;
            
            wire one = 1'b1;
            
            for (z_lookahead_cs = 0;z_lookahead_cs < MEM_IF_CS_WIDTH;z_lookahead_cs = z_lookahead_cs + 1)
            begin : multicast_bank_info_per_chip
                wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = z_lookahead_cs;
                wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(z_lookahead + 1) * MEM_IF_BA_WIDTH  - 1 : z_lookahead * MEM_IF_BA_WIDTH ];
                wire [MEM_IF_ROW_WIDTH - 1 : 0] row_addr  = cmd_row_addr  [(z_lookahead + 1) * MEM_IF_ROW_WIDTH - 1 : z_lookahead * MEM_IF_ROW_WIDTH];
                
                assign multicast_cmd_bank_is_open [z_lookahead_cs] = current_state [chip_addr][bank_addr];
                //assign multicast_cmd_row_is_open  [z_lookahead_cs] = ((current_row [chip_addr][bank_addr] == row_addr) ? 1'b1 : 1'b0) & current_state [chip_addr][bank_addr];
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        multicast_cmd_row_is_open [z_lookahead_cs] <= 0;
                    end
                    else
                    begin
                        multicast_cmd_row_is_open [z_lookahead_cs] <= ((current_row [chip_addr][bank_addr] == row_addr) ? 1'b1 : 1'b0) & current_state [chip_addr][bank_addr];
                    end
                end
            end
            
            // OPP if (!CLOSE_PAGE_POLICY) // only enable in open-page policy
            // OPP begin
            // OPP     assign multicast_bank_is_open = |multicast_cmd_bank_is_open;
            // OPP end
            // OPP else
            // OPP begin
                assign multicast_bank_is_open = &multicast_cmd_bank_is_open;
            // OPP end
          
            // bank is open
            if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
            begin
                // body...
                always @ (*)
                begin
                    if (cmd_multicast_req [z_lookahead])
                        cmd_bank_is_open [z_lookahead] = multicast_bank_is_open;
                    else
                        cmd_bank_is_open [z_lookahead] = current_state [chip_addr][bank_addr];
                end
            end
            else
            begin
                // CTL_DYNAMIC_BANK_ALLOCATION
                always @ (*) 
                begin
                    if (cmd_multicast_req [z_lookahead])
                        cmd_bank_is_open[z_lookahead] <= |current_state_per_lhead_mcast_cam[z_lookahead];
                    else
                        cmd_bank_is_open[z_lookahead] <= |current_state_per_lookahead_cam [z_lookahead];
                end
            end

            
            // row is open
            // OPP if (!CLOSE_PAGE_POLICY) // only enable in open-page policy
            // OPP begin
            // OPP     always @ (*)
            // OPP     begin
            // OPP         if (cmd_multicast_req [z_lookahead])
            // OPP             cmd_row_is_open [z_lookahead] = &multicast_cmd_row_is_open;
            // OPP         else
            // OPP             cmd_row_is_open [z_lookahead] =  multicast_cmd_row_is_open [chip_addr];
            // OPP     end
            // OPP end
            // OPP else
            // OPP begin
                // always assign row is open to '1' during close page policy
                always @ (*)
                begin
                    cmd_row_is_open [z_lookahead] = one;
                end
            // OPP end
        end
    endgenerate
    
    
/*------------------------------------------------------------------------------

    [END] Bank Logic

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Timer Logic

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Can_* Logic
    ------------------------------------------------------------------------------*/
    generate
        genvar t_lookahead;
        genvar t_lookahead_cs;
        for (t_lookahead = 0;t_lookahead < CTL_LOOK_AHEAD_DEPTH + 1;t_lookahead = t_lookahead + 1)
        begin : can_signal_per_lookahead
            wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(t_lookahead + 1) * MEM_IF_CHIP_BITS - 1 : t_lookahead * MEM_IF_CHIP_BITS];
            wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(t_lookahead + 1) * MEM_IF_BA_WIDTH  - 1 : t_lookahead * MEM_IF_BA_WIDTH ];
            
            wire [MEM_IF_CS_WIDTH  - 1 : 0] multicast_cmd_can_write;
            wire [MEM_IF_CS_WIDTH  - 1 : 0] multicast_cmd_can_activate;
            wire [MEM_IF_CS_WIDTH  - 1 : 0] multicast_cmd_can_precharge;
            
            wire zero = 1'b0;
            
            for (t_lookahead_cs = 0;t_lookahead_cs < MEM_IF_CS_WIDTH;t_lookahead_cs = t_lookahead_cs + 1)
            begin : multicast_can_info_per_chip
                wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = t_lookahead_cs;
                wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(t_lookahead + 1) * MEM_IF_BA_WIDTH - 1 : t_lookahead * MEM_IF_BA_WIDTH];
                
                assign multicast_cmd_can_write     [t_lookahead_cs] = rdwr_ready [chip_addr][bank_addr];
                assign multicast_cmd_can_activate  [t_lookahead_cs] = act_ready  [chip_addr][bank_addr];
                assign multicast_cmd_can_precharge [t_lookahead_cs] = pch_ready  [chip_addr][bank_addr];
            end
           

            if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
            begin
                // Can write signal for each command queue entry (include current command)
                always @ (*)
                begin
                    if (cmd_multicast_req [t_lookahead])
                        cmd_can_write [t_lookahead] = &multicast_cmd_can_write          & write_dqs_ready;
                    else
                        cmd_can_write [t_lookahead] = rdwr_ready [chip_addr][bank_addr] & write_dqs_ready;
                end
                
                // Can read signal for each command queue entry (include current command)
                always @ (*)
                begin
                    cmd_can_read [t_lookahead] = rdwr_ready [chip_addr][bank_addr] & write_to_read_finish_twtr [chip_addr] & read_dqs_ready;
                end
                
                // Can activate signal for each command queue entry (include current command)
                always @ (*)
                begin
                    if (cmd_multicast_req [t_lookahead])
                        cmd_can_activate [t_lookahead] = &multicast_cmd_can_activate      & &act_tfaw_ready             & &act_trrd_ready             & &power_saving_enter_ready;
                    else
                        cmd_can_activate [t_lookahead] = act_ready [chip_addr][bank_addr] &  act_tfaw_ready [chip_addr] &  act_trrd_ready [chip_addr] &  power_saving_enter_ready [chip_addr];
                end

                // Can precharge signal for each command queue entry (include current command)
                always @ (*)
                begin
                    if (cmd_multicast_req [t_lookahead])
                        cmd_can_precharge [t_lookahead] = &multicast_cmd_can_precharge     & &power_saving_enter_ready;
                    else
                        cmd_can_precharge [t_lookahead] = pch_ready [chip_addr][bank_addr] &  power_saving_enter_ready [chip_addr];
                end
            end
            else
            begin
                // CTL_DYNAMIC_BANK_ALLOCATION

                // Can write signal for each command queue entry (include current command)
                always @ (*)
                begin
                    if (cmd_multicast_req [t_lookahead])
                        cmd_can_write [t_lookahead] = |rdwr_ready_per_lookahead_mcast_cam [t_lookahead] & write_dqs_ready;
                    else
                        cmd_can_write [t_lookahead] = |rdwr_ready_per_lookahead_cam [t_lookahead] & write_dqs_ready;
                end
                
                // Can read signal for each command queue entry (include current command)
                always @ (*)
                begin
                    cmd_can_read [t_lookahead] = |rdwr_ready_per_lookahead_cam [t_lookahead] & write_to_read_finish_twtr [chip_addr] & read_dqs_ready;
                end
                
                // Can activate signal for each command queue entry (include current command)
                always @ (*)
                begin
                    if (cmd_multicast_req [t_lookahead])
                        cmd_can_activate [t_lookahead] = &act_ready_per_lookahead_mcast_cam [t_lookahead]   & &act_tfaw_ready           & &act_trrd_ready           & &power_saving_enter_ready           & ~cam_full;
                    else
                        cmd_can_activate [t_lookahead] = &act_ready_per_lookahead_cam [t_lookahead]         & act_tfaw_ready[chip_addr] & act_trrd_ready[chip_addr] & power_saving_enter_ready[chip_addr] & ~cam_full;
                end

                // Can precharge signal for each command queue entry (include current command)
                always @ (*)
                begin
                    if (cmd_multicast_req [t_lookahead])
                        cmd_can_precharge [t_lookahead] = |pch_ready_per_lookahead_mcast_cam[t_lookahead]     & &power_saving_enter_ready;
                    else
                        cmd_can_precharge [t_lookahead] = |pch_ready_per_lookahead_cam [t_lookahead] &  power_saving_enter_ready [chip_addr];
                end
            end


            
        end
    endgenerate
    
    generate
        genvar w_cs;
        for (w_cs = 0;w_cs < MEM_IF_CS_WIDTH;w_cs = w_cs + 1)
        begin : can_signal_per_chip

            wire chip_idle;

            if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
            begin
                assign chip_idle = &(act_ready [w_cs][(2 ** MEM_IF_BA_WIDTH) - 1 : 0]);
            end
            else
            begin
                assign chip_idle = &(act_ready_per_chip_cam[w_cs]);
            end

            // Can precharge all signal for each rank
            always @ (*)
            begin
                cs_can_precharge_all [w_cs] = power_saving_enter_ready [w_cs] & chip_idle;
            end
            
            // Can refresh signal for each rank
            always @ (*)
            begin
                cs_can_refresh [w_cs] = power_saving_enter_ready [w_cs] & chip_idle;
            end
            
            // Can self refresh signal for each rank
            always @ (*)
            begin
                cs_can_self_refresh [w_cs] = power_saving_enter_ready [w_cs] & chip_idle;
            end
            
            // Can power down signal for each rank
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    cs_can_power_down [w_cs] <= 1'b0;
                end
                else
                begin
                    cs_can_power_down [w_cs] <= power_saving_enter_ready [w_cs] & chip_idle;
                end
            end
            
            // Can exit power saving mode signal for each rank
            always @ (*)
            begin
                cs_can_exit_power_saving_mode [w_cs] = power_saving_exit_ready [w_cs];
            end
        end
    endgenerate
    
    // special can activate signal when add latency is ON
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            can_al_activate_write <= 1'b0;
            can_al_activate_read  <= 1'b0;
        end
        else
        begin
            if (do_read && more_than_x2_rd_to_wr)
                can_al_activate_write <= 1'b0;
            else
                can_al_activate_write <= write_dqs_ready;
            
            if (do_write && more_than_x2_wr_to_rd)
                can_al_activate_read <= 1'b0;
            else
                can_al_activate_read <= read_dqs_ready & write_to_read_finish_twtr [cmd_chip_addr [MEM_IF_CHIP_BITS - 1 : 0]];
        end
    end
/*------------------------------------------------------------------------------

    [END] Timer Logic

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Bank / Timer Input Logic

------------------------------------------------------------------------------*/
    generate
        genvar y_cs;
        genvar y_bank;
        if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
        begin
            // body...
            for (y_cs = 0;y_cs < MEM_IF_CS_WIDTH;y_cs = y_cs + 1)
            begin : open_close_signal_per_chip
                for (y_bank = 0;y_bank < 2 ** MEM_IF_BA_WIDTH; y_bank = y_bank + 1)
                begin : open_close_signal_per_bank
                    // Determine which open signal should be '1' when activate happen
                    always @ (*)
                    begin
                        if (do_activate && to_chip [y_cs] && to_bank_addr == y_bank)
                            int_open [y_cs][y_bank] = 1'b1;
                        else
                            int_open [y_cs][y_bank] = 1'b0;
                    end
                    
                    // Determine which close signal should be '1' when precharge happen
                    always @ (*)
                    begin
                        if (((do_precharge || do_auto_precharge) && to_chip [y_cs] && to_bank_addr == y_bank) || (do_precharge_all && to_chip [y_cs]))
                            int_close [y_cs][y_bank] = 1'b1;
                        else
                            int_close [y_cs][y_bank] = 1'b0;
                    end
                    
                    // Determine which write signal should be '1' when write happen
                    always @ (*)
                    begin
                        if (do_write && to_chip [y_cs] && to_bank_addr == y_bank)
                            int_write [y_cs][y_bank] = 1'b1;
                        else
                            int_write [y_cs][y_bank] = 1'b0;
                    end
                    
                    // Determine which read signal should be '1' when write happen
                    always @ (*)
                    begin
                        if (do_read && to_chip [y_cs] && to_bank_addr == y_bank)
                            int_read [y_cs][y_bank] = 1'b1;
                        else
                            int_read [y_cs][y_bank] = 1'b0;
                    end
                    
                    if (BANK_TIMER_INFO_INPUT_REGD) // if we choose to register bank timer info inputs
                    begin
                        always @ (posedge ctl_clk or negedge ctl_reset_n)
                        begin
                            if (!ctl_reset_n)
                            begin
                                open  [y_cs][y_bank] <= 1'b0;
                                close [y_cs][y_bank] <= 1'b0;
                                write [y_cs][y_bank] <= 1'b0;
                                read  [y_cs][y_bank] <= 1'b0;
                            end
                            else
                            begin
                                open  [y_cs][y_bank] <= int_open  [y_cs][y_bank];
                                close [y_cs][y_bank] <= int_close [y_cs][y_bank];
                                write [y_cs][y_bank] <= int_write [y_cs][y_bank];
                                read  [y_cs][y_bank] <= int_read  [y_cs][y_bank];
                            end
                        end
                    end
                    else
                    begin
                        always @ (*)
                        begin
                            open  [y_cs][y_bank] = int_open  [y_cs][y_bank];
                            close [y_cs][y_bank] = int_close [y_cs][y_bank];
                            write [y_cs][y_bank] = int_write [y_cs][y_bank];
                            read  [y_cs][y_bank] = int_read  [y_cs][y_bank];
                        end
                    end
                end
            end
        end // CTL_DYNAMIC_BANK_ALLOCATION != 1
    endgenerate
    
    // Row information
    // OPP generate
    // OPP     if (!CLOSE_PAGE_POLICY) // only enable in open page policy
    // OPP     begin
    // OPP         always @ (*)
    // OPP         begin
    // OPP             int_row_addr = to_row_addr;
    // OPP         end
    // OPP         
    // OPP         if (BANK_TIMER_INFO_INPUT_REGD) // if we choose to register bank timer info inputs
    // OPP         begin
    // OPP             always @ (posedge ctl_clk or negedge ctl_reset_n)
    // OPP             begin
    // OPP                 if (!ctl_reset_n)
    // OPP                     row_addr <= 0;
    // OPP                 else
    // OPP                     row_addr <= int_row_addr;
    // OPP             end
    // OPP         end
    // OPP         else
    // OPP         begin
    // OPP             always @ (*)
    // OPP             begin
    // OPP                 row_addr = int_row_addr;
    // OPP             end
    // OPP         end
    // OPP     end
    // OPP endgenerate
/*------------------------------------------------------------------------------

    [END] Bank / Timer Input Logic

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Bank / Timer Information

------------------------------------------------------------------------------*/
    generate
        if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
        begin
            genvar x_cs;
            genvar x_bank;
            for (x_cs = 0;x_cs < MEM_IF_CS_WIDTH; x_cs = x_cs + 1)
            begin : bank_timer_info_per_chip
                for (x_bank = 0;x_bank < 2 ** MEM_IF_BA_WIDTH; x_bank = x_bank + 1)
                begin : bank_timer_info_per_bank
                    alt_ddrx_bank_timer_info #
                    (
                        .ACT_TO_RDWR_WIDTH         (ACT_TO_RDWR_WIDTH             ),
                        .ACT_TO_ACT_WIDTH          (ACT_TO_ACT_WIDTH              ),
                        .ACT_TO_PCH_WIDTH          (ACT_TO_PCH_WIDTH              ),
                        .RD_TO_PCH_WIDTH           (RD_TO_PCH_WIDTH               ),
                        .WR_TO_PCH_WIDTH           (WR_TO_PCH_WIDTH               ),
                        .RD_AP_TO_ACT_WIDTH        (RD_AP_TO_ACT_WIDTH            ),
                        .WR_AP_TO_ACT_WIDTH        (WR_AP_TO_ACT_WIDTH            ),
                        .PCH_TO_ACT_WIDTH          (PCH_TO_ACT_WIDTH              ),
                        .BANK_TIMER_COUNTER_OFFSET (BANK_TIMER_COUNTER_OFFSET     ),
                        .MEM_IF_ROW_WIDTH          (MEM_IF_ROW_WIDTH              ),
                        .CLOSE_PAGE_POLICY         (CLOSE_PAGE_POLICY             )
                    )
                    bank_timer_info_inst
                    (
                        .ctl_clk                   (ctl_clk                       ),
                        .ctl_reset_n               (ctl_reset_n                   ),
                        
                        // timing information
                        .act_to_rdwr               (act_to_rdwr                   ),
                        .act_to_act                (act_to_act                    ),
                        .act_to_pch                (act_to_pch                    ),
                        .rd_to_pch                 (rd_to_pch                     ),
                        .wr_to_pch                 (wr_to_pch                     ),
                        .rd_ap_to_act              (rd_ap_to_act                  ),
                        .wr_ap_to_act              (wr_ap_to_act                  ),
                        .pch_to_act                (pch_to_act                    ),
                        
                        .less_than_x2_act_to_rdwr  (less_than_x2_act_to_rdwr      ),
                        
                        // inputs
                        .open                      (open           [x_cs][x_bank] ),
                        .close                     (close          [x_cs][x_bank] ),
                        .read                      (read           [x_cs][x_bank] ),
                        .write                     (write          [x_cs][x_bank] ),
                        .row_addr                  (row_addr                      ),
                        
                        // outputs
                        .current_state             (current_state  [x_cs][x_bank] ),
                        .current_row               (current_row    [x_cs][x_bank] ),
                        .rdwr_ready                (rdwr_ready     [x_cs][x_bank] ),
                        .act_ready                 (act_ready      [x_cs][x_bank] ),
                        .pch_ready                 (pch_ready      [x_cs][x_bank] )
                    );
                end
            end
        end
        else
        begin
            genvar x_cam_entry;
            for (x_cam_entry = 0; x_cam_entry < CTL_DYNAMIC_BANK_NUM; x_cam_entry = x_cam_entry + 1)
            begin : bank_timer_info_per_cam
                alt_ddrx_bank_timer_info #
                (
                    .ACT_TO_RDWR_WIDTH         (ACT_TO_RDWR_WIDTH             ),
                    .ACT_TO_ACT_WIDTH          (ACT_TO_ACT_WIDTH              ),
                    .ACT_TO_PCH_WIDTH          (ACT_TO_PCH_WIDTH              ),
                    .RD_TO_PCH_WIDTH           (RD_TO_PCH_WIDTH               ),
                    .WR_TO_PCH_WIDTH           (WR_TO_PCH_WIDTH               ),
                    .RD_AP_TO_ACT_WIDTH        (RD_AP_TO_ACT_WIDTH            ),
                    .WR_AP_TO_ACT_WIDTH        (WR_AP_TO_ACT_WIDTH            ),
                    .PCH_TO_ACT_WIDTH          (PCH_TO_ACT_WIDTH              ),
                    .BANK_TIMER_COUNTER_OFFSET (BANK_TIMER_COUNTER_OFFSET     ),
                    .MEM_IF_ROW_WIDTH          (MEM_IF_ROW_WIDTH              ),
                    .CLOSE_PAGE_POLICY         (CLOSE_PAGE_POLICY             )
                )
                bank_timer_info_inst
                (
                    .ctl_clk                   (ctl_clk                       ),
                    .ctl_reset_n               (ctl_reset_n                   ),
                    
                    // timing information
                    .act_to_rdwr               (act_to_rdwr                   ),
                    .act_to_act                (act_to_act                    ),
                    .act_to_pch                (act_to_pch                    ),
                    .rd_to_pch                 (rd_to_pch                     ),
                    .wr_to_pch                 (wr_to_pch                     ),
                    .rd_ap_to_act              (rd_ap_to_act                  ),
                    .wr_ap_to_act              (wr_ap_to_act                  ),
                    .pch_to_act                (pch_to_act                    ),
                    
                    .less_than_x2_act_to_rdwr  (less_than_x2_act_to_rdwr      ),
                    
                    // inputs
                    .open                      (open_cam           [x_cam_entry]  ),
                    .close                     (close_cam          [x_cam_entry]  ),
                    .read                      (read_cam           [x_cam_entry]  ),
                    .write                     (write_cam          [x_cam_entry]  ),
                    .row_addr                  (row_addr_cam                      ),
                    
                    // outputs
                    .current_state             (current_state_cam  [x_cam_entry] ),
                    .current_row               (current_row_cam    [x_cam_entry] ),
                    .rdwr_ready                (rdwr_ready_cam     [x_cam_entry] ),
                    .act_ready                 (act_ready_cam      [x_cam_entry] ),
                    .pch_ready                 (pch_ready_cam      [x_cam_entry] )
                );
            end
        end
    endgenerate
/*------------------------------------------------------------------------------

    [END] Bank / Timer Information

------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------

    [START] CTL_DYNAMIC_BANK_ALLOCATION - next free cam arbiter

------------------------------------------------------------------------------*/
    generate
        if (CTL_DYNAMIC_BANK_ALLOCATION != 1)
        begin
            wire zero = 1'b0;
            
            // assign cam_full to '0' when CAM option is disabled
            assign cam_full = zero;
        end
        else
        begin
            assign cam_full = & (cam_v | int_open_cam);
        end
    endgenerate
    
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
            cam_current_free_entry_r <= 0;
        else
            cam_current_free_entry_r <= cam_current_free_entry;
    end

    assign cam_current_free_entry = ~cam_v & ~(~cam_v - 1);

/*------------------------------------------------------------------------------

    [END] CTL_DYNAMIC_BANK_ALLOCATION - next free cam arbiter

------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------

    [START] CTL_DYNAMIC_BANK_ALLOCATION - dynamic bank allocation manager

------------------------------------------------------------------------------*/

    function [MEM_IF_CHIP_BITS  - 1 : 0] convert_one_hot_to_bin;
        input [MEM_IF_CS_WIDTH - 1 : 0] one_hot_num;
        integer i;
        begin
            convert_one_hot_to_bin = 0;
            for (i =0; i<MEM_IF_CS_WIDTH; i=i+1)  if (one_hot_num[i]) convert_one_hot_to_bin = i;
        end
    endfunction

    function [MEM_IF_CS_WIDTH  - 1 : 0] convert_dec_to_one_hot;
        input [MEM_IF_CHIP_BITS - 1 : 0] dec_num;
        begin
            convert_dec_to_one_hot = 0;
            convert_dec_to_one_hot[dec_num] =  1'b1;
        end
    endfunction

    assign to_chip_addr = convert_one_hot_to_bin (to_chip);

    generate
        genvar z_cam;

        if (CTL_DYNAMIC_BANK_ALLOCATION)
        begin
            for (z_cam = 0;z_cam < CTL_DYNAMIC_BANK_NUM; z_cam = z_cam + 1)
            begin : open_close_signal_per_bank

                always @ (*) 
                begin
                    // default values
                    int_cam_cs          [z_cam]    = 0;
                    int_cam_bank        [z_cam]    = 0;
                    int_cam_mcast       [z_cam]    = 0;
                    cam_allocate        [z_cam]    = 0;
                    cam_deallocate      [z_cam]    = 0;
                    cam_update_cs       [z_cam]    = 0;
                    int_open_cam        [z_cam]    = 0;
                    int_close_cam       [z_cam]    = 0;
                    int_write_cam       [z_cam]    = 0;
                    int_read_cam        [z_cam]    = 0;

                    cam_cs_match        [z_cam]    = cam_v[z_cam] & cam_cs[z_cam] == (cam_cs[z_cam] & to_chip);
                    cam_bank_match      [z_cam]    = cam_v[z_cam] & cam_bank[z_cam] == to_bank_addr;
                    cam_cs_partial_match[z_cam]    = cam_v[z_cam] & cam_cs[z_cam] & to_chip;  // any once cs bit matches  

                    // use registered cam_current_free_entry, assume do_activate won't happen back to back
                    if (do_activate & cam_current_free_entry_r[z_cam])
                    begin
                        // allocate a cam entry
                        cam_allocate    [z_cam]    = 1'b1;
                        int_open_cam    [z_cam]    = 1'b1;
                        int_cam_cs      [z_cam]    = to_chip;
                        int_cam_bank    [z_cam]    = to_bank_addr;
                        int_cam_mcast   [z_cam]    = &to_chip;
                    end

                    if (((do_precharge|do_auto_precharge) & cam_bank_match[z_cam]) | do_precharge_all)
                    begin
                        if (cam_cs_match[z_cam])
                        begin
                            // page-close issued to chip+bank tracked by this cam
                            int_close_cam   [z_cam]  = 1'b1;
                        end
                        else if (cam_handle_cs_partial_match & cam_cs_partial_match[z_cam])
                        begin
                            // page-close issued to 1 of the chip+bank tracked by this cam (in a multicast cam entry)
                            // stop tracking the chip+bank, so that chip+bank is tracked as close in the lookahead signals
                            cam_update_cs[z_cam] = 1'b1;
                            int_cam_cs[z_cam] = cam_cs[z_cam] & ~to_chip;
                        end
                    end
                    
                    if (do_write & cam_cs_match[z_cam] & cam_bank_match[z_cam])
                        int_write_cam   [z_cam] = 1'b1;

                    if (do_read & cam_cs_match[z_cam] & cam_bank_match[z_cam])
                        int_read_cam    [z_cam] = 1'b1;

                    if (cam_v[z_cam] & ~current_state_cam[z_cam] & act_ready_cam[z_cam])
                    begin
                        // de-allocate the cam entry
                        cam_deallocate  [z_cam]    = 1'b1;
                    end
                end

                 always @ (posedge ctl_clk or negedge ctl_reset_n) 
                 begin
                     if (~ctl_reset_n)
                     begin
                         //reset state ...
                        cam_cs          [z_cam]    <= 0;
                        cam_bank        [z_cam]    <= 0;
                        cam_mcast       [z_cam]    <= 0;
                        cam_v           [z_cam]    <= 0;
                     end
                     else
                     begin
                        if (cam_allocate[z_cam])
                        begin
                            // allocate cam entry
                            cam_cs      [z_cam]    <= int_cam_cs    [z_cam];
                            cam_bank    [z_cam]    <= int_cam_bank  [z_cam];
                            cam_mcast   [z_cam]    <= int_cam_mcast [z_cam];
                            cam_v       [z_cam]    <= 1'b1;
                        end
                        else if (cam_deallocate[z_cam])
                        begin
                            // de-allocate cam entry
                            cam_cs      [z_cam]    <= 0;
                            cam_bank    [z_cam]    <= 0;
                            cam_mcast   [z_cam]    <= 0;
                            cam_v       [z_cam]    <= 0;
                        end
                        else if (cam_update_cs[z_cam])
                        begin
                            cam_cs      [z_cam]    <= int_cam_cs    [z_cam];
                        end
                        else
                        begin
                        end
                     end
                 end

                if (BANK_TIMER_INFO_INPUT_REGD) // if we choose to register bank timer info inputs
                begin
                    always @ (posedge ctl_clk or negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                        begin
                            open_cam    [z_cam] <= 1'b0;
                            close_cam   [z_cam] <= 1'b0;
                            write_cam   [z_cam] <= 1'b0;
                            read_cam    [z_cam] <= 1'b0;
                        end
                        else
                        begin
                            open_cam    [z_cam] <= int_open_cam  [z_cam];
                            close_cam   [z_cam] <= int_close_cam [z_cam];
                            write_cam   [z_cam] <= int_write_cam [z_cam];
                            read_cam    [z_cam] <= int_read_cam  [z_cam];
                        end
                    end
                end
                else
                begin
                    always @ (*)
                    begin
                        open_cam        [z_cam] = int_open_cam  [z_cam];
                        close_cam       [z_cam] = int_close_cam [z_cam];
                        write_cam       [z_cam] = int_write_cam [z_cam];
                        read_cam        [z_cam] = int_read_cam  [z_cam];
                    end
                end
        end


        end
    endgenerate
/*------------------------------------------------------------------------------

    [END] CTL_DYNAMIC_BANK_ALLOCATION - dynamic bank allocation manager

------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------

    [START] CTL_DYNAMIC_BANK_ALLOCATION - generate per chip, and per-lookahead, 
                                          bank info signals by doing cam look-up

------------------------------------------------------------------------------*/
    generate
        genvar r_cs;
        genvar r_cam, r_cam2;
        genvar r_lookahead;
        for (r_cs = 0;r_cs < MEM_IF_CS_WIDTH;r_cs = r_cs + 1)
        begin : bank_info_per_chip

            reg  [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_cs_match   ;

            for (r_cam = 0; r_cam < CTL_DYNAMIC_BANK_NUM; r_cam = r_cam + 1'b1)
            begin : bank_info_chip_cam
                always @ (*) 
                begin
                    cam_cs_match                [r_cam]       = cam_v[r_cam] & |(cam_cs[r_cam] & convert_dec_to_one_hot(r_cs));

                    act_ready_per_chip_cam      [r_cs][r_cam] = cam_cs_match[r_cam] ? act_ready_cam[r_cam]        : default_act_ready_cam_miss;
                    current_state_per_chip_cam  [r_cs][r_cam] = cam_cs_match[r_cam] ? current_state_cam[r_cam]    : default_current_state_cam_miss;
                end
            end

        end
        for (r_lookahead = 0;r_lookahead < CTL_LOOK_AHEAD_DEPTH + 1;r_lookahead = r_lookahead + 1)
        begin : bank_info_per_lookahead

        wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(r_lookahead + 1) * MEM_IF_CHIP_BITS - 1 : r_lookahead * MEM_IF_CHIP_BITS];
        wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(r_lookahead + 1) * MEM_IF_BA_WIDTH  - 1 : r_lookahead * MEM_IF_BA_WIDTH ];
        wire [MEM_IF_ROW_WIDTH - 1 : 0] row_addr  = cmd_row_addr  [(r_lookahead + 1) * MEM_IF_ROW_WIDTH - 1 : r_lookahead * MEM_IF_ROW_WIDTH];

        reg  [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_cs_match   ;
        reg  [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_bank_match ;
        reg  [CTL_DYNAMIC_BANK_NUM - 1 : 0] cam_match   ;

            for (r_cam2 = 0; r_cam2 < CTL_DYNAMIC_BANK_NUM; r_cam2 = r_cam2 + 1'b1)
            begin : bank_info_lookahead_cam
                always @ (*) 
                begin

                    cam_cs_match                      [r_cam2]    = cam_v[r_cam2] & |(cam_cs[r_cam2] & convert_dec_to_one_hot(chip_addr));
                    cam_bank_match                    [r_cam2]    = cam_v[r_cam2] & (cam_bank[r_cam2] == bank_addr);
                    cam_match                         [r_cam2]    = cam_bank_match[r_cam2] & cam_cs_match[r_cam2];

                    current_state_per_lookahead_cam   [r_lookahead][r_cam2] = cam_match[r_cam2] ? current_state_cam   [r_cam2] : default_current_state_cam_miss;
                    rdwr_ready_per_lookahead_cam      [r_lookahead][r_cam2] = cam_match[r_cam2] ? rdwr_ready_cam      [r_cam2] : default_rdwr_ready_cam_miss;
                    act_ready_per_lookahead_cam       [r_lookahead][r_cam2] = cam_match[r_cam2] ? act_ready_cam       [r_cam2] : default_act_ready_cam_miss;
                    pch_ready_per_lookahead_cam       [r_lookahead][r_cam2] = cam_match[r_cam2] ? pch_ready_cam       [r_cam2] : default_pch_ready_cam_miss;

                    current_state_per_lhead_mcast_cam [r_lookahead][r_cam2] = (cam_bank_match[r_cam2] & &cam_cs[r_cam2]) ? current_state_cam[r_cam2] : default_current_state_cam_miss;
                    act_ready_per_lookahead_mcast_cam [r_lookahead][r_cam2] = cam_bank_match[r_cam2] ? act_ready_cam[r_cam2] : default_act_ready_cam_miss;
                    rdwr_ready_per_lookahead_mcast_cam[r_lookahead][r_cam2] = cam_bank_match[r_cam2] ? rdwr_ready_cam[r_cam2]: default_rdwr_ready_cam_miss;
                    pch_ready_per_lookahead_mcast_cam [r_lookahead][r_cam2] = cam_bank_match[r_cam2] ? pch_ready_cam[r_cam2] : default_pch_ready_cam_miss;
                end
            end
        end
    endgenerate

/*------------------------------------------------------------------------------

    [END] CTL_DYNAMIC_BANK_ALLOCATION - generate per chip, and per-lookahead,
                                        bank info signals by doing cam look-up                                            

------------------------------------------------------------------------------*/

endmodule
