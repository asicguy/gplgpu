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
// Title         : DDR controller Timer
//
// File          : alt_ddrx_timer.v
//
// Abstract      : Keep track of all DDR specific timing informations
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_timers #
    ( parameter
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS   = 2,
        MEM_IF_CS_WIDTH    = 4,
        MEM_IF_ROW_WIDTH   = 16,            // max supported row bits
        MEM_IF_BA_WIDTH    = 3,             // max supported bank bits
        MEM_TYPE           = "DDR3",
        
        MEM_IF_RD_TO_WR_TURNAROUND_OCT = 0,
        MEM_IF_WR_TO_RD_TURNAROUND_OCT = 0,
        
        DWIDTH_RATIO       = 2,             // 2 - fullrate, 4 - halfrate
        MEMORY_BURSTLENGTH = 8,
        
        // controller settings
        CTL_LOOK_AHEAD_DEPTH  = 6,          // 6 in halfrate and 8 in fullrate
        CTL_CMD_QUEUE_DEPTH   = 8,
        CTL_USR_REFRESH       = 0,          // enabled user refresh
        
        // timing parameters width
        CAS_WR_LAT_BUS_WIDTH = 4,           // max will be 8 in DDR3
        ADD_LAT_BUS_WIDTH    = 3,           // max will be 6 in DDR2
        TCL_BUS_WIDTH        = 4,           // max will be 11 in DDR3
        TRRD_BUS_WIDTH       = 4,           // 2 - 8
        TFAW_BUS_WIDTH       = 6,           // 6 - 32
        TRFC_BUS_WIDTH       = 8,           // 12 - 140?
        TREFI_BUS_WIDTH      = 13,          // 780 - 6240
        TRCD_BUS_WIDTH       = 4,           // 2 - 11
        TRP_BUS_WIDTH        = 4,           // 2 - 11
        TWR_BUS_WIDTH        = 4,           // 2 - 12
        TWTR_BUS_WIDTH       = 4,           // 1 - 10
        TRTP_BUS_WIDTH       = 4,           // 2 - 8
        TRAS_BUS_WIDTH       = 5,           // 4 - 29
        TRC_BUS_WIDTH        = 6,           // 8 - 40
        AUTO_PD_BUS_WIDTH    = 16           // same as CSR
    )
    (
        // port connections
        ctl_clk,
        ctl_reset_n,
        
        // look ahead ports
        can_read_current,
        can_write_current,
        can_activate_current,
        can_precharge_current,
        
        can_read,                           // [1:0], cmd0 and cmd-1
        can_write,                          // [1:0], cmd0 and cmd-1
        can_activate,                       // [CTL_LOOK_AHEAD_DEPTH-1:0]
        can_precharge,                      // [CTL_LOOK_AHEAD_DEPTH-1:0]
        can_precharge_all,                  // for precharge all
        can_lmr,                            // [MEM_IF_CS_WIDTH - 1 : 0]
        can_exit_power_saving_mode,         // [MEM_IF_CS_WIDTH - 1 : 0]
        
        // periodic auto-refresh interface
        can_refresh,                        // [MEM_IF_CS_WIDTH - 1 : 0]
        auto_refresh_req,                   // refresh timer has expired,
        auto_refresh_chip,                  // [MEM_IF_CS_WIDTH - 1 : 0]
        
        // power-down interface
        can_enter_power_down,               // [MEM_IF_CS_WIDTH - 1 : 0]
        power_down_req,                     // power down timer has expired
        
        // user self-refresh interface
        zq_cal_req,
        can_self_rfsh,                      // [MEM_IF_CS_WIDTH - 1 : 0]
        
        // indicate to state machine Additive Latency is on
        can_al_activate_write,
        can_al_activate_read,
        add_lat_on,
        
        // Per cmd entry inputs and outputs, currently set to 4, might increase to 7 or more
        cmd0_is_valid,
        cmd0_chip_addr,
        cmd0_bank_addr,
        cmd0_is_a_write,
        cmd0_is_a_read,
        cmd0_multicast_req,
        
        cmd1_is_valid,
        cmd1_chip_addr,
        cmd1_bank_addr,
        cmd1_is_a_write,
        cmd1_is_a_read,
        cmd1_multicast_req,
        
        cmd2_is_valid,
        cmd2_chip_addr,
        cmd2_bank_addr,
        cmd2_is_a_write,
        cmd2_is_a_read,
        cmd2_multicast_req,
        
        cmd3_is_valid,
        cmd3_chip_addr,
        cmd3_bank_addr,
        cmd3_is_a_write,
        cmd3_is_a_read,
        cmd3_multicast_req,
        
        cmd4_is_valid,
        cmd4_chip_addr,
        cmd4_bank_addr,
        cmd4_is_a_write,
        cmd4_is_a_read,
        cmd4_multicast_req,
        
        cmd5_is_valid,
        cmd5_chip_addr,
        cmd5_bank_addr,
        cmd5_is_a_write,
        cmd5_is_a_read,
        cmd5_multicast_req,
        
        cmd6_is_valid,
        cmd6_chip_addr,
        cmd6_bank_addr,
        cmd6_is_a_write,
        cmd6_is_a_read,
        cmd6_multicast_req,
        
        cmd7_is_valid,
        cmd7_chip_addr,
        cmd7_bank_addr,
        cmd7_is_a_write,
        cmd7_is_a_read,
        cmd7_multicast_req,
        
        // used for current command
        current_chip_addr,
        current_bank_addr,
        current_is_a_write,
        current_is_a_read,
        current_multicast_req,
        
        cmd_fifo_empty,
        local_init_done,
        
        // state machine command outputs
        ecc_fetch_error_addr,
        fetch,
        flush1,
        flush2,
        flush3,
        do_write,
        do_read,
        do_activate,
        do_precharge,
        do_auto_precharge,
        do_precharge_all,
        do_refresh,
        do_power_down,
        do_self_rfsh,
        do_lmr,
        do_burst_chop,
        
        // require to_chip (CS_WIDTH) as well for ARF, SRF and PDN
        to_chip,
        to_bank_addr,
        
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
        mem_auto_pd_cycles
    );

input ctl_clk;
input ctl_reset_n;

// look ahead ports
output can_read_current;
output can_write_current;
output can_activate_current;
output can_precharge_current;

output [1 : 0] can_read;
output [1 : 0] can_write;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_activate;
output [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_precharge;
output [MEM_IF_CS_WIDTH - 1 : 0] can_precharge_all;
output [MEM_IF_CS_WIDTH - 1 : 0] can_lmr;
output [MEM_IF_CS_WIDTH - 1 : 0] can_exit_power_saving_mode;

// periodic auto-refresh interface
output auto_refresh_req;
output [MEM_IF_CS_WIDTH - 1 : 0] auto_refresh_chip;
output [MEM_IF_CS_WIDTH - 1 : 0] can_refresh;

// power-down interface
output power_down_req;
output [MEM_IF_CS_WIDTH - 1 : 0] can_enter_power_down;

// user self-refresh interface
output zq_cal_req;
output [MEM_IF_CS_WIDTH - 1 : 0] can_self_rfsh;

output can_al_activate_write;
output can_al_activate_read;
output add_lat_on;

// Per cmd entry inputs and outputs; currently set to 4; might increase to 7 or more
input  cmd0_is_valid;
input  cmd0_is_a_write;
input  cmd0_is_a_read;
input  cmd0_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd0_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd0_bank_addr;

input  cmd1_is_valid;
input  cmd1_is_a_write;
input  cmd1_is_a_read;
input  cmd1_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd1_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd1_bank_addr;

input  cmd2_is_valid;
input  cmd2_is_a_write;
input  cmd2_is_a_read;
input  cmd2_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd2_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd2_bank_addr;

input  cmd3_is_valid;
input  cmd3_is_a_write;
input  cmd3_is_a_read;
input  cmd3_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd3_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd3_bank_addr;

input  cmd4_is_valid;
input  cmd4_is_a_write;
input  cmd4_is_a_read;
input  cmd4_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd4_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd4_bank_addr;

input  cmd5_is_valid;
input  cmd5_is_a_write;
input  cmd5_is_a_read;
input  cmd5_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd5_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd5_bank_addr;

input  cmd6_is_valid;
input  cmd6_is_a_write;
input  cmd6_is_a_read;
input  cmd6_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd6_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd6_bank_addr;

input  cmd7_is_valid;
input  cmd7_is_a_write;
input  cmd7_is_a_read;
input  cmd7_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] cmd7_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  cmd7_bank_addr;

input  current_is_a_write;
input  current_is_a_read;
input  current_multicast_req;
input  [MEM_IF_CHIP_BITS - 1 : 0] current_chip_addr;
input  [MEM_IF_BA_WIDTH - 1 : 0]  current_bank_addr;

input cmd_fifo_empty;
input local_init_done;

// state machine command outputs
input ecc_fetch_error_addr;
input fetch;
input flush1;
input flush2;
input flush3;
input do_write;
input do_read;
input do_activate;
input do_precharge;
input do_auto_precharge;
input do_precharge_all;
input do_refresh;
input do_power_down;
input do_self_rfsh;
input do_lmr;
input do_burst_chop;

input [MEM_IF_CS_WIDTH - 1 : 0]  to_chip;
input [MEM_IF_BA_WIDTH - 1 : 0]  to_bank_addr;

input [CAS_WR_LAT_BUS_WIDTH - 1 : 0] mem_cas_wr_lat;
input [ADD_LAT_BUS_WIDTH    - 1 : 0] mem_add_lat;
input [TCL_BUS_WIDTH        - 1 : 0] mem_tcl;
input [TRRD_BUS_WIDTH       - 1 : 0] mem_trrd;
input [TFAW_BUS_WIDTH       - 1 : 0] mem_tfaw;
input [TRFC_BUS_WIDTH       - 1 : 0] mem_trfc;
input [TREFI_BUS_WIDTH      - 1 : 0] mem_trefi;
input [TRCD_BUS_WIDTH       - 1 : 0] mem_trcd;
input [TRP_BUS_WIDTH        - 1 : 0] mem_trp;
input [TWR_BUS_WIDTH        - 1 : 0] mem_twr;
input [TWTR_BUS_WIDTH       - 1 : 0] mem_twtr;
input [TRTP_BUS_WIDTH       - 1 : 0] mem_trtp;
input [TRAS_BUS_WIDTH       - 1 : 0] mem_tras;
input [TRC_BUS_WIDTH        - 1 : 0] mem_trc;
input [AUTO_PD_BUS_WIDTH    - 1 : 0] mem_auto_pd_cycles;

/*------------------------------------------------------------------------------

    Timing Parameters

------------------------------------------------------------------------------*/
// timing parameters
localparam BURST_LENGTH_BUS_WIDTH             = 4;
localparam TMRD_BUS_WIDTH                     = 3;
localparam TMOD_BUS_WIDTH                     = 4;
localparam SELF_RFSH_EXIT_CYCLES_BUS_WIDTH    = 10;

localparam BANK_ACTIVATE_WIDTH                = TRCD_BUS_WIDTH;
localparam ACT_TO_PCH_WIDTH                   = TRAS_BUS_WIDTH;
localparam ACT_TO_ACT_WIDTH                   = TRC_BUS_WIDTH;

localparam RD_TO_RD_WIDTH                     = 3;                      // max tCCD is 4
localparam RD_TO_WR_WIDTH                     = 5;                      // max of 10? (roughly because in DDR3, cas_lat - cas_wr_lat + 6)
localparam RD_TO_WR_BC_WIDTH                  = 4;                      // max of 8?  (roughly because in DDR3, cas_lat - cas_wr_lat + 4)
localparam RD_TO_PCH_WIDTH                    = 4;                      // max of 11  (add_lat (max of 6) + tRTP (max of 5))

localparam WR_TO_WR_WIDTH                     = 3;                      // max tCCD is 4
localparam WR_TO_RD_WIDTH                     = 5;                      // max of 28   (add_lat (max of 6) + cas_wr_lat (max of 8) + 4 + tWTR (max of 10))
localparam WR_TO_PCH_WIDTH                    = 5;                      // max of 24   (add_lat (max of 6) + cas_wr_lat (max of 8) + 4 + tWR (max of 6))

localparam PCH_TO_ACT_WIDTH                   = TRP_BUS_WIDTH;

localparam RD_AP_TO_ACT_WIDTH                 = 5;                      // max of 22 (add_lat (max of 6) + tRTP (max of 5) + tRP (max of 11))
localparam WR_AP_TO_ACT_WIDTH                 = 6;                      // max of 35 (add_lat (max of 6) + cas_wr_lat (max of 8) + 4 + tWR (max of 6) + tRP (max of 11))

localparam ARF_TO_VALID_WIDTH                 = TRFC_BUS_WIDTH;
localparam PDN_TO_VALID_WIDTH                 = 2;                      // currently pdn_to_valid is 3
localparam SRF_TO_VALID_WIDTH                 = SELF_RFSH_EXIT_CYCLES_BUS_WIDTH;
localparam LMR_TO_LMR_WIDTH                   = TMRD_BUS_WIDTH;
localparam LMR_TO_VALID_WIDTH                 = TMOD_BUS_WIDTH;
localparam ARF_PERIOD_WIDTH                   = TREFI_BUS_WIDTH;
localparam PDN_PERIOD_WIDTH                   = AUTO_PD_BUS_WIDTH;
localparam ACT_TO_ACT_DIFF_BANK_WIDTH         = TRRD_BUS_WIDTH;
localparam FOUR_ACT_TO_ACT_WIDTH              = TFAW_BUS_WIDTH;

localparam FINISH_WRITE_WIDTH                 = 5;                      // temp

wire [BURST_LENGTH_BUS_WIDTH          - 1 : 0] mem_burst_length            = MEMORY_BURSTLENGTH;
wire [TMRD_BUS_WIDTH                  - 1 : 0] mem_tmrd                    = 4;
wire [TMOD_BUS_WIDTH                  - 1 : 0] mem_tmod                    = 12;
wire [SELF_RFSH_EXIT_CYCLES_BUS_WIDTH - 1 : 0] mem_self_rfsh_exit_cycles   = (MEM_TYPE == "DDR3") ? 512 : 200;

wire [RD_TO_WR_WIDTH                  - 1 : 0] mem_rd_to_wr_turnaround_oct = MEM_IF_RD_TO_WR_TURNAROUND_OCT;
wire [WR_TO_RD_WIDTH                  - 1 : 0] mem_wr_to_rd_turnaround_oct = MEM_IF_WR_TO_RD_TURNAROUND_OCT;

reg can_al_activate_write;
reg can_al_activate_read;
reg add_lat_on;

// activate
reg [BANK_ACTIVATE_WIDTH - 1 : 0] bank_active;
reg [ACT_TO_PCH_WIDTH    - 1 : 0] act_to_pch;
reg [ACT_TO_ACT_WIDTH    - 1 : 0] act_to_act;

// read
reg [RD_TO_RD_WIDTH    - 1 : 0] rd_to_rd;
reg [RD_TO_WR_WIDTH    - 1 : 0] rd_to_wr;
reg [RD_TO_WR_BC_WIDTH - 1 : 0] rd_to_wr_bc; // Burst chop support, only affects DDR3 RD - WR
reg [RD_TO_PCH_WIDTH   - 1 : 0] rd_to_pch;

// write
reg [WR_TO_WR_WIDTH  - 1 : 0] wr_to_wr;
reg [WR_TO_RD_WIDTH  - 1 : 0] wr_to_rd;
reg [WR_TO_RD_WIDTH  - 1 : 0] wr_to_rd_diff_chips;
reg [WR_TO_PCH_WIDTH - 1 : 0] wr_to_pch;
reg [WR_TO_PCH_WIDTH - 1 : 0] wr_to_rd_to_pch_all;

// precharge
reg [PCH_TO_ACT_WIDTH - 1 : 0] pch_to_act;
reg [PCH_TO_ACT_WIDTH - 1 : 0] pch_all_to_act;

// auto precharge
reg [RD_AP_TO_ACT_WIDTH - 1 : 0] rd_ap_to_act; // Missing
reg [WR_AP_TO_ACT_WIDTH - 1 : 0] wr_ap_to_act; // Missing

// others
reg [ARF_TO_VALID_WIDTH - 1 : 0] arf_to_valid;           // tRFC
reg [PDN_TO_VALID_WIDTH - 1 : 0] pdn_to_valid;           // power down exit time, not used currently
reg [SRF_TO_VALID_WIDTH - 1 : 0] srf_to_valid;           // self refresh exit time
reg [SRF_TO_VALID_WIDTH - 1 : 0] srf_to_zq;              // self refresh to ZQ calibration
reg [LMR_TO_LMR_WIDTH   - 1 : 0] lmr_to_lmr;             // tMRD
reg [LMR_TO_VALID_WIDTH - 1 : 0] lmr_to_valid;           // tMOD

reg [ARF_PERIOD_WIDTH           - 1 : 0] arf_period;             // tREFI
reg [PDN_PERIOD_WIDTH           - 1 : 0] pdn_period;             // will request power down if controller is idle for X number of clock cycles
reg [ACT_TO_ACT_DIFF_BANK_WIDTH - 1 : 0] act_to_act_diff_bank;   // tRRD
reg [FOUR_ACT_TO_ACT_WIDTH      - 1 : 0] four_act_to_act;        // tFAW

// required to monitor read and writes and make sure all data has benn transfered before enabling can power down/refresh/self refresh/lmr 
reg [FINISH_WRITE_WIDTH - 1 : 0] finish_write;
reg [FINISH_WRITE_WIDTH - 1 : 0] finish_read;

// more/less than N signal, this signal will be used in timer block, this will reduce timing violation
// because we will abstract away the comparator and set the compared value in a register
reg more_than_2_bank_active;
reg more_than_2_act_to_pch;
reg more_than_2_act_to_act;
reg more_than_2_rd_to_rd;
reg more_than_2_rd_to_wr;
reg more_than_2_rd_to_wr_bc;
reg more_than_2_rd_to_pch;
reg more_than_2_wr_to_wr;
reg more_than_2_wr_to_rd;
reg more_than_2_wr_to_pch;
reg more_than_2_pch_to_act;
reg more_than_2_rd_ap_to_act;
reg more_than_2_wr_ap_to_act;
reg more_than_2_arf_to_valid;
reg more_than_2_pdn_to_valid;
reg more_than_2_srf_to_valid;
reg more_than_2_lmr_to_lmr;
reg more_than_2_lmr_to_valid;
reg more_than_2_arf_period;
reg more_than_2_pdn_period;
reg more_than_2_act_to_act_diff_bank;
reg more_than_2_four_act_to_act;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        more_than_2_bank_active          <= 1'b0;
        more_than_2_act_to_pch           <= 1'b0;
        more_than_2_act_to_act           <= 1'b0;
        more_than_2_rd_to_rd             <= 1'b0;
        more_than_2_rd_to_wr             <= 1'b0;
        more_than_2_rd_to_wr_bc          <= 1'b0;
        more_than_2_rd_to_pch            <= 1'b0;
        more_than_2_wr_to_wr             <= 1'b0;
        more_than_2_wr_to_rd             <= 1'b0;
        more_than_2_wr_to_pch            <= 1'b0;
        more_than_2_pch_to_act           <= 1'b0;
        more_than_2_rd_ap_to_act         <= 1'b0;
        more_than_2_wr_ap_to_act         <= 1'b0;
        more_than_2_arf_to_valid         <= 1'b0;
        more_than_2_pdn_to_valid         <= 1'b0;
        more_than_2_srf_to_valid         <= 1'b0;
        more_than_2_lmr_to_lmr           <= 1'b0;
        more_than_2_lmr_to_valid         <= 1'b0;
        more_than_2_arf_period           <= 1'b0;
        more_than_2_pdn_period           <= 1'b0;
        more_than_2_act_to_act_diff_bank <= 1'b0;
        more_than_2_four_act_to_act      <= 1'b0;
    end
    else
    begin
        // bank_active
        if (bank_active >= 2)
            more_than_2_bank_active <= 1'b1;
        else
            more_than_2_bank_active <= 1'b0;
        
        // act_to_pch
        if (act_to_pch >= 2)
            more_than_2_act_to_pch <= 1'b1;
        else
            more_than_2_act_to_pch <= 1'b0;
        
        // act_to_act
        if (act_to_act >= 2)
            more_than_2_act_to_act <= 1'b1;
        else
            more_than_2_act_to_act <= 1'b0;
        
        // rd_to_rd
        if (rd_to_rd >= 2)
            more_than_2_rd_to_rd <= 1'b1;
        else
            more_than_2_rd_to_rd <= 1'b0;
        
        // rd_to_wr
        if (rd_to_wr >= 2)
            more_than_2_rd_to_wr <= 1'b1;
        else
            more_than_2_rd_to_wr <= 1'b0;
        
        // rd_to_wr_bc
        if (rd_to_wr_bc >= 2)
            more_than_2_rd_to_wr_bc <= 1'b1;
        else
            more_than_2_rd_to_wr_bc <= 1'b0;
        
        // rd_to_pch
        if (rd_to_pch >= 2)
            more_than_2_rd_to_pch <= 1'b1;
        else
            more_than_2_rd_to_pch <= 1'b0;
        
        // wr_to_wr
        if (wr_to_wr >= 2)
            more_than_2_wr_to_wr <= 1'b1;
        else
            more_than_2_wr_to_wr <= 1'b0;
        
        // wr_to_rd
        if (wr_to_rd >= 2)
            more_than_2_wr_to_rd <= 1'b1;
        else
            more_than_2_wr_to_rd <= 1'b0;
        
        // wr_to_pch
        if (wr_to_pch >= 2)
            more_than_2_wr_to_pch <= 1'b1;
        else
            more_than_2_wr_to_pch <= 1'b0;
        
        // pch_to_act
        if (pch_to_act >= 2)
            more_than_2_pch_to_act <= 1'b1;
        else
            more_than_2_pch_to_act <= 1'b0;
        
        // rd_ap_to_act
        if (rd_ap_to_act >= 2)
            more_than_2_rd_ap_to_act <= 1'b1;
        else
            more_than_2_rd_ap_to_act <= 1'b0;
        
        // wr_ap_to_act
        if (wr_ap_to_act >= 2)
            more_than_2_wr_ap_to_act <= 1'b1;
        else
            more_than_2_wr_ap_to_act <= 1'b0;
        
        // arf_to_valid
        if (arf_to_valid >= 2)
            more_than_2_arf_to_valid <= 1'b1;
        else
            more_than_2_arf_to_valid <= 1'b0;
        
        // pdn_to_valid
        if (pdn_to_valid >= 2)
            more_than_2_pdn_to_valid <= 1'b1;
        else
            more_than_2_pdn_to_valid <= 1'b0;
        
        // srf_to_valid
        if (srf_to_valid >= 2)
            more_than_2_srf_to_valid <= 1'b1;
        else
            more_than_2_srf_to_valid <= 1'b0;
        
        // lmr_to_lmr
        if (lmr_to_lmr >= 2)
            more_than_2_lmr_to_lmr <= 1'b1;
        else
            more_than_2_lmr_to_lmr <= 1'b0;
        
        // lmr_to_valid
        if (lmr_to_valid >= 2)
            more_than_2_lmr_to_valid <= 1'b1;
        else
            more_than_2_lmr_to_valid <= 1'b0;
        
        // arf_period
        if (arf_period >= 2)
            more_than_2_arf_period <= 1'b1;
        else
            more_than_2_arf_period <= 1'b0;
        
        // pdn_period
        if (pdn_period >= 2)
            more_than_2_pdn_period <= 1'b1;
        else
            more_than_2_pdn_period <= 1'b0;
        
        // act_to_act_diff_bank
        if (act_to_act_diff_bank >= 2)
            more_than_2_act_to_act_diff_bank <= 1'b1;
        else
            more_than_2_act_to_act_diff_bank <= 1'b0;
        
        // four_act_to_act
        if (four_act_to_act >= 2)
            more_than_2_four_act_to_act <= 1'b1;
        else
            more_than_2_four_act_to_act <= 1'b0;
    end
end

reg less_than_2_bank_active;
reg less_than_2_act_to_pch;
reg less_than_2_act_to_act;
reg less_than_2_rd_to_rd;
reg less_than_2_rd_to_wr;
reg less_than_2_rd_to_wr_bc;
reg less_than_2_rd_to_pch;
reg less_than_2_wr_to_wr;
reg less_than_2_wr_to_rd;
reg less_than_2_wr_to_pch;
reg less_than_2_pch_to_act;
reg less_than_2_rd_ap_to_act;
reg less_than_2_wr_ap_to_act;
reg less_than_2_arf_to_valid;
reg less_than_2_pdn_to_valid;
reg less_than_2_srf_to_valid;
reg less_than_2_lmr_to_lmr;
reg less_than_2_lmr_to_valid;
reg less_than_2_arf_period;
reg less_than_2_pdn_period;
reg less_than_2_act_to_act_diff_bank;
reg less_than_2_four_act_to_act;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        less_than_2_bank_active          <= 1'b0;
        less_than_2_act_to_pch           <= 1'b0;
        less_than_2_act_to_act           <= 1'b0;
        less_than_2_rd_to_rd             <= 1'b0;
        less_than_2_rd_to_wr             <= 1'b0;
        less_than_2_rd_to_wr_bc          <= 1'b0;
        less_than_2_rd_to_pch            <= 1'b0;
        less_than_2_wr_to_wr             <= 1'b0;
        less_than_2_wr_to_rd             <= 1'b0;
        less_than_2_wr_to_pch            <= 1'b0;
        less_than_2_pch_to_act           <= 1'b0;
        less_than_2_rd_ap_to_act         <= 1'b0;
        less_than_2_wr_ap_to_act         <= 1'b0;
        less_than_2_arf_to_valid         <= 1'b0;
        less_than_2_pdn_to_valid         <= 1'b0;
        less_than_2_srf_to_valid         <= 1'b0;
        less_than_2_lmr_to_lmr           <= 1'b0;
        less_than_2_lmr_to_valid         <= 1'b0;
        less_than_2_arf_period           <= 1'b0;
        less_than_2_pdn_period           <= 1'b0;
        less_than_2_act_to_act_diff_bank <= 1'b0;
        less_than_2_four_act_to_act      <= 1'b0;
    end
    else
    begin
        // bank_active
        if (bank_active <= 2)
            less_than_2_bank_active <= 1'b1;
        else
            less_than_2_bank_active <= 1'b0;
        
        // act_to_pch
        if (act_to_pch <= 2)
            less_than_2_act_to_pch <= 1'b1;
        else
            less_than_2_act_to_pch <= 1'b0;
        
        // act_to_act
        if (act_to_act <= 2)
            less_than_2_act_to_act <= 1'b1;
        else
            less_than_2_act_to_act <= 1'b0;
        
        // rd_to_rd
        if (rd_to_rd <= 2)
            less_than_2_rd_to_rd <= 1'b1;
        else
            less_than_2_rd_to_rd <= 1'b0;
        
        // rd_to_wr
        if (rd_to_wr <= 2)
            less_than_2_rd_to_wr <= 1'b1;
        else
            less_than_2_rd_to_wr <= 1'b0;
        
        // rd_to_wr_bc
        if (rd_to_wr_bc <= 2)
            less_than_2_rd_to_wr_bc <= 1'b1;
        else
            less_than_2_rd_to_wr_bc <= 1'b0;
        
        // rd_to_pch
        if (rd_to_pch <= 2)
            less_than_2_rd_to_pch <= 1'b1;
        else
            less_than_2_rd_to_pch <= 1'b0;
        
        // wr_to_wr
        if (wr_to_wr <= 2)
            less_than_2_wr_to_wr <= 1'b1;
        else
            less_than_2_wr_to_wr <= 1'b0;
        
        // wr_to_rd
        if (wr_to_rd <= 2)
            less_than_2_wr_to_rd <= 1'b1;
        else
            less_than_2_wr_to_rd <= 1'b0;
        
        // wr_to_pch
        if (wr_to_pch <= 2)
            less_than_2_wr_to_pch <= 1'b1;
        else
            less_than_2_wr_to_pch <= 1'b0;
        
        // pch_to_act
        if (pch_to_act <= 2)
            less_than_2_pch_to_act <= 1'b1;
        else
            less_than_2_pch_to_act <= 1'b0;
        
        // rd_ap_to_act
        if (rd_ap_to_act <= 2)
            less_than_2_rd_ap_to_act <= 1'b1;
        else
            less_than_2_rd_ap_to_act <= 1'b0;
        
        // wr_ap_to_act
        if (wr_ap_to_act <= 2)
            less_than_2_wr_ap_to_act <= 1'b1;
        else
            less_than_2_wr_ap_to_act <= 1'b0;
        
        // arf_to_valid
        if (arf_to_valid <= 2)
            less_than_2_arf_to_valid <= 1'b1;
        else
            less_than_2_arf_to_valid <= 1'b0;
        
        // pdn_to_valid
        if (pdn_to_valid <= 2)
            less_than_2_pdn_to_valid <= 1'b1;
        else
            less_than_2_pdn_to_valid <= 1'b0;
        
        // srf_to_valid
        if (srf_to_valid <= 2)
            less_than_2_srf_to_valid <= 1'b1;
        else
            less_than_2_srf_to_valid <= 1'b0;
        
        // lmr_to_lmr
        if (lmr_to_lmr <= 2)
            less_than_2_lmr_to_lmr <= 1'b1;
        else
            less_than_2_lmr_to_lmr <= 1'b0;
        
        // lmr_to_valid
        if (lmr_to_valid <= 2)
            less_than_2_lmr_to_valid <= 1'b1;
        else
            less_than_2_lmr_to_valid <= 1'b0;
        
        // arf_period
        if (arf_period <= 2)
            less_than_2_arf_period <= 1'b1;
        else
            less_than_2_arf_period <= 1'b0;
        
        // pdn_period
        if (pdn_period <= 2)
            less_than_2_pdn_period <= 1'b1;
        else
            less_than_2_pdn_period <= 1'b0;
        
        // act_to_act_diff_bank
        if (act_to_act_diff_bank <= 2)
            less_than_2_act_to_act_diff_bank <= 1'b1;
        else
            less_than_2_act_to_act_diff_bank <= 1'b0;
        
        // four_act_to_act
        if (four_act_to_act <= 2)
            less_than_2_four_act_to_act <= 1'b1;
        else
            less_than_2_four_act_to_act <= 1'b0;
    end
end

reg more_than_3_bank_active;
reg more_than_3_act_to_pch;
reg more_than_3_act_to_act;
reg more_than_3_rd_to_rd;
reg more_than_3_rd_to_wr;
reg more_than_3_rd_to_wr_bc;
reg more_than_3_rd_to_pch;
reg more_than_3_wr_to_wr;
reg more_than_3_wr_to_rd;
reg more_than_3_wr_to_pch;
reg more_than_3_pch_to_act;
reg more_than_3_rd_ap_to_act;
reg more_than_3_wr_ap_to_act;
reg more_than_3_arf_to_valid;
reg more_than_3_pdn_to_valid;
reg more_than_3_srf_to_valid;
reg more_than_3_lmr_to_lmr;
reg more_than_3_lmr_to_valid;
reg more_than_3_arf_period;
reg more_than_3_pdn_period;
reg more_than_3_act_to_act_diff_bank;
reg more_than_3_four_act_to_act;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        more_than_3_bank_active          <= 1'b0;
        more_than_3_act_to_pch           <= 1'b0;
        more_than_3_act_to_act           <= 1'b0;
        more_than_3_rd_to_rd             <= 1'b0;
        more_than_3_rd_to_wr             <= 1'b0;
        more_than_3_rd_to_wr_bc          <= 1'b0;
        more_than_3_rd_to_pch            <= 1'b0;
        more_than_3_wr_to_wr             <= 1'b0;
        more_than_3_wr_to_rd             <= 1'b0;
        more_than_3_wr_to_pch            <= 1'b0;
        more_than_3_pch_to_act           <= 1'b0;
        more_than_3_rd_ap_to_act         <= 1'b0;
        more_than_3_wr_ap_to_act         <= 1'b0;
        more_than_3_arf_to_valid         <= 1'b0;
        more_than_3_pdn_to_valid         <= 1'b0;
        more_than_3_srf_to_valid         <= 1'b0;
        more_than_3_lmr_to_lmr           <= 1'b0;
        more_than_3_lmr_to_valid         <= 1'b0;
        more_than_3_arf_period           <= 1'b0;
        more_than_3_pdn_period           <= 1'b0;
        more_than_3_act_to_act_diff_bank <= 1'b0;
        more_than_3_four_act_to_act      <= 1'b0;
    end
    else
    begin
        // bank_active
        if (bank_active >= 3)
            more_than_3_bank_active <= 1'b1;
        else
            more_than_3_bank_active <= 1'b0;
        
        // act_to_pch
        if (act_to_pch >= 3)
            more_than_3_act_to_pch <= 1'b1;
        else
            more_than_3_act_to_pch <= 1'b0;
        
        // act_to_act
        if (act_to_act >= 3)
            more_than_3_act_to_act <= 1'b1;
        else
            more_than_3_act_to_act <= 1'b0;
        
        // rd_to_rd
        if (rd_to_rd >= 3)
            more_than_3_rd_to_rd <= 1'b1;
        else
            more_than_3_rd_to_rd <= 1'b0;
        
        // rd_to_wr
        if (rd_to_wr >= 3)
            more_than_3_rd_to_wr <= 1'b1;
        else
            more_than_3_rd_to_wr <= 1'b0;
        
        // rd_to_wr_bc
        if (rd_to_wr_bc >= 3)
            more_than_3_rd_to_wr_bc <= 1'b1;
        else
            more_than_3_rd_to_wr_bc <= 1'b0;
        
        // rd_to_pch
        if (rd_to_pch >= 3)
            more_than_3_rd_to_pch <= 1'b1;
        else
            more_than_3_rd_to_pch <= 1'b0;
        
        // wr_to_wr
        if (wr_to_wr >= 3)
            more_than_3_wr_to_wr <= 1'b1;
        else
            more_than_3_wr_to_wr <= 1'b0;
        
        // wr_to_rd
        if (wr_to_rd >= 3)
            more_than_3_wr_to_rd <= 1'b1;
        else
            more_than_3_wr_to_rd <= 1'b0;
        
        // wr_to_pch
        if (wr_to_pch >= 3)
            more_than_3_wr_to_pch <= 1'b1;
        else
            more_than_3_wr_to_pch <= 1'b0;
        
        // pch_to_act
        if (pch_to_act >= 3)
            more_than_3_pch_to_act <= 1'b1;
        else
            more_than_3_pch_to_act <= 1'b0;
        
        // rd_ap_to_act
        if (rd_ap_to_act >= 3)
            more_than_3_rd_ap_to_act <= 1'b1;
        else
            more_than_3_rd_ap_to_act <= 1'b0;
        
        // wr_ap_to_act
        if (wr_ap_to_act >= 3)
            more_than_3_wr_ap_to_act <= 1'b1;
        else
            more_than_3_wr_ap_to_act <= 1'b0;
        
        // arf_to_valid
        if (arf_to_valid >= 3)
            more_than_3_arf_to_valid <= 1'b1;
        else
            more_than_3_arf_to_valid <= 1'b0;
        
        // pdn_to_valid
        if (pdn_to_valid >= 3)
            more_than_3_pdn_to_valid <= 1'b1;
        else
            more_than_3_pdn_to_valid <= 1'b0;
        
        // srf_to_valid
        if (srf_to_valid >= 3)
            more_than_3_srf_to_valid <= 1'b1;
        else
            more_than_3_srf_to_valid <= 1'b0;
        
        // lmr_to_lmr
        if (lmr_to_lmr >= 3)
            more_than_3_lmr_to_lmr <= 1'b1;
        else
            more_than_3_lmr_to_lmr <= 1'b0;
        
        // lmr_to_valid
        if (lmr_to_valid >= 3)
            more_than_3_lmr_to_valid <= 1'b1;
        else
            more_than_3_lmr_to_valid <= 1'b0;
        
        // arf_period
        if (arf_period >= 3)
            more_than_3_arf_period <= 1'b1;
        else
            more_than_3_arf_period <= 1'b0;
        
        // pdn_period
        if (pdn_period >= 3)
            more_than_3_pdn_period <= 1'b1;
        else
            more_than_3_pdn_period <= 1'b0;
        
        // act_to_act_diff_bank
        if (act_to_act_diff_bank >= 3)
            more_than_3_act_to_act_diff_bank <= 1'b1;
        else
            more_than_3_act_to_act_diff_bank <= 1'b0;
        
        // four_act_to_act
        if (four_act_to_act >= 3)
            more_than_3_four_act_to_act <= 1'b1;
        else
            more_than_3_four_act_to_act <= 1'b0;
    end
end

reg less_than_3_bank_active;
reg less_than_3_act_to_pch;
reg less_than_3_act_to_act;
reg less_than_3_rd_to_rd;
reg less_than_3_rd_to_wr;
reg less_than_3_rd_to_wr_bc;
reg less_than_3_rd_to_pch;
reg less_than_3_wr_to_wr;
reg less_than_3_wr_to_rd;
reg less_than_3_wr_to_rd_diff_chips;
reg less_than_3_wr_to_pch;
reg less_than_3_pch_to_act;
reg less_than_3_wr_to_rd_to_pch_all; // added to fix wr - rd - pch all bug
reg less_than_3_rd_ap_to_act;
reg less_than_3_wr_ap_to_act;
reg less_than_3_arf_to_valid;
reg less_than_3_pdn_to_valid;
reg less_than_3_srf_to_valid;
reg less_than_3_lmr_to_lmr;
reg less_than_3_lmr_to_valid;
reg less_than_3_arf_period;
reg less_than_3_pdn_period;
reg less_than_3_act_to_act_diff_bank;
reg less_than_3_four_act_to_act;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        less_than_3_bank_active          <= 1'b0;
        less_than_3_act_to_pch           <= 1'b0;
        less_than_3_act_to_act           <= 1'b0;
        less_than_3_rd_to_rd             <= 1'b0;
        less_than_3_rd_to_wr             <= 1'b0;
        less_than_3_rd_to_wr_bc          <= 1'b0;
        less_than_3_rd_to_pch            <= 1'b0;
        less_than_3_wr_to_wr             <= 1'b0;
        less_than_3_wr_to_rd             <= 1'b0;
        less_than_3_wr_to_rd_diff_chips  <= 1'b0;
        less_than_3_wr_to_pch            <= 1'b0;
        less_than_3_wr_to_rd_to_pch_all  <= 1'b0;
        less_than_3_pch_to_act           <= 1'b0;
        less_than_3_rd_ap_to_act         <= 1'b0;
        less_than_3_wr_ap_to_act         <= 1'b0;
        less_than_3_arf_to_valid         <= 1'b0;
        less_than_3_pdn_to_valid         <= 1'b0;
        less_than_3_srf_to_valid         <= 1'b0;
        less_than_3_lmr_to_lmr           <= 1'b0;
        less_than_3_lmr_to_valid         <= 1'b0;
        less_than_3_arf_period           <= 1'b0;
        less_than_3_pdn_period           <= 1'b0;
        less_than_3_act_to_act_diff_bank <= 1'b0;
        less_than_3_four_act_to_act      <= 1'b0;
    end
    else
    begin
        // bank_active
        if (bank_active <= 3)
            less_than_3_bank_active <= 1'b1;
        else
            less_than_3_bank_active <= 1'b0;
        
        // act_to_pch
        if (act_to_pch <= 3)
            less_than_3_act_to_pch <= 1'b1;
        else
            less_than_3_act_to_pch <= 1'b0;
        
        // act_to_act
        if (act_to_act <= 3)
            less_than_3_act_to_act <= 1'b1;
        else
            less_than_3_act_to_act <= 1'b0;
        
        // rd_to_rd
        if (rd_to_rd <= 3)
            less_than_3_rd_to_rd <= 1'b1;
        else
            less_than_3_rd_to_rd <= 1'b0;
        
        // rd_to_wr
        if (rd_to_wr <= 3)
            less_than_3_rd_to_wr <= 1'b1;
        else
            less_than_3_rd_to_wr <= 1'b0;
        
        // rd_to_wr_bc
        if (rd_to_wr_bc <= 3)
            less_than_3_rd_to_wr_bc <= 1'b1;
        else
            less_than_3_rd_to_wr_bc <= 1'b0;
        
        // rd_to_pch
        if (rd_to_pch <= 3)
            less_than_3_rd_to_pch <= 1'b1;
        else
            less_than_3_rd_to_pch <= 1'b0;
        
        // wr_to_wr
        if (wr_to_wr <= 3)
            less_than_3_wr_to_wr <= 1'b1;
        else
            less_than_3_wr_to_wr <= 1'b0;
        
        // wr_to_rd
        if (wr_to_rd <= 3)
            less_than_3_wr_to_rd <= 1'b1;
        else
            less_than_3_wr_to_rd <= 1'b0;
        
        // wr_to_rd_diff_chips
        if (wr_to_rd_diff_chips <= 3)
            less_than_3_wr_to_rd_diff_chips <= 1'b1;
        else
            less_than_3_wr_to_rd_diff_chips <= 1'b0;
        
        // wr_to_pch
        if (wr_to_pch <= 3)
            less_than_3_wr_to_pch <= 1'b1;
        else
            less_than_3_wr_to_pch <= 1'b0;
        
        // wr_to_rd_to_pch_all
        if (wr_to_rd_to_pch_all <= 3)
            less_than_3_wr_to_rd_to_pch_all <= 1'b1;
        else
            less_than_3_wr_to_rd_to_pch_all <= 1'b0;
        
        // pch_to_act
        if (pch_to_act <= 3)
            less_than_3_pch_to_act <= 1'b1;
        else
            less_than_3_pch_to_act <= 1'b0;
        
        // rd_ap_to_act
        if (rd_ap_to_act <= 3)
            less_than_3_rd_ap_to_act <= 1'b1;
        else
            less_than_3_rd_ap_to_act <= 1'b0;
        
        // wr_ap_to_act
        if (wr_ap_to_act <= 3)
            less_than_3_wr_ap_to_act <= 1'b1;
        else
            less_than_3_wr_ap_to_act <= 1'b0;
        
        // arf_to_valid
        if (arf_to_valid <= 3)
            less_than_3_arf_to_valid <= 1'b1;
        else
            less_than_3_arf_to_valid <= 1'b0;
        
        // pdn_to_valid
        if (pdn_to_valid <= 3)
            less_than_3_pdn_to_valid <= 1'b1;
        else
            less_than_3_pdn_to_valid <= 1'b0;
        
        // srf_to_valid
        if (srf_to_valid <= 3)
            less_than_3_srf_to_valid <= 1'b1;
        else
            less_than_3_srf_to_valid <= 1'b0;
        
        // lmr_to_lmr
        if (lmr_to_lmr <= 3)
            less_than_3_lmr_to_lmr <= 1'b1;
        else
            less_than_3_lmr_to_lmr <= 1'b0;
        
        // lmr_to_valid
        if (lmr_to_valid <= 3)
            less_than_3_lmr_to_valid <= 1'b1;
        else
            less_than_3_lmr_to_valid <= 1'b0;
        
        // arf_period
        if (arf_period <= 3)
            less_than_3_arf_period <= 1'b1;
        else
            less_than_3_arf_period <= 1'b0;
        
        // pdn_period
        if (pdn_period <= 3)
            less_than_3_pdn_period <= 1'b1;
        else
            less_than_3_pdn_period <= 1'b0;
        
        // act_to_act_diff_bank
        if (act_to_act_diff_bank <= 3)
            less_than_3_act_to_act_diff_bank <= 1'b1;
        else
            less_than_3_act_to_act_diff_bank <= 1'b0;
        
        // four_act_to_act
        if (four_act_to_act <= 3)
            less_than_3_four_act_to_act <= 1'b1;
        else
            less_than_3_four_act_to_act <= 1'b0;
    end
end

reg more_than_4_bank_active;
reg more_than_4_act_to_pch;
reg more_than_4_act_to_act;
reg more_than_4_rd_to_rd;
reg more_than_4_rd_to_wr;
reg more_than_4_rd_to_wr_bc;
reg more_than_4_rd_to_pch;
reg more_than_4_wr_to_wr;
reg more_than_4_wr_to_rd;
reg more_than_4_wr_to_pch;
reg more_than_4_pch_to_act;
reg more_than_4_rd_ap_to_act;
reg more_than_4_wr_ap_to_act;
reg more_than_4_arf_to_valid;
reg more_than_4_pdn_to_valid;
reg more_than_4_srf_to_valid;
reg more_than_4_lmr_to_lmr;
reg more_than_4_lmr_to_valid;
reg more_than_4_arf_period;
reg more_than_4_pdn_period;
reg more_than_4_act_to_act_diff_bank;
reg more_than_4_four_act_to_act;
reg more_than_4_pch_all_to_act; // special signal for DDR2, to monitor tRPA

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        more_than_4_bank_active          <= 1'b0;
        more_than_4_act_to_pch           <= 1'b0;
        more_than_4_act_to_act           <= 1'b0;
        more_than_4_rd_to_rd             <= 1'b0;
        more_than_4_rd_to_wr             <= 1'b0;
        more_than_4_rd_to_wr_bc          <= 1'b0;
        more_than_4_rd_to_pch            <= 1'b0;
        more_than_4_wr_to_wr             <= 1'b0;
        more_than_4_wr_to_rd             <= 1'b0;
        more_than_4_wr_to_pch            <= 1'b0;
        more_than_4_pch_to_act           <= 1'b0;
        more_than_4_rd_ap_to_act         <= 1'b0;
        more_than_4_wr_ap_to_act         <= 1'b0;
        more_than_4_arf_to_valid         <= 1'b0;
        more_than_4_pdn_to_valid         <= 1'b0;
        more_than_4_srf_to_valid         <= 1'b0;
        more_than_4_lmr_to_lmr           <= 1'b0;
        more_than_4_lmr_to_valid         <= 1'b0;
        more_than_4_arf_period           <= 1'b0;
        more_than_4_pdn_period           <= 1'b0;
        more_than_4_act_to_act_diff_bank <= 1'b0;
        more_than_4_four_act_to_act      <= 1'b0;
        more_than_4_pch_all_to_act       <= 1'b0;
    end
    else
    begin
        // bank_active
        if (bank_active >= 4)
            more_than_4_bank_active <= 1'b1;
        else
            more_than_4_bank_active <= 1'b0;
        
        // act_to_pch
        if (act_to_pch >= 4)
            more_than_4_act_to_pch <= 1'b1;
        else
            more_than_4_act_to_pch <= 1'b0;
        
        // act_to_act
        if (act_to_act >= 4)
            more_than_4_act_to_act <= 1'b1;
        else
            more_than_4_act_to_act <= 1'b0;
        
        // rd_to_rd
        if (rd_to_rd >= 4)
            more_than_4_rd_to_rd <= 1'b1;
        else
            more_than_4_rd_to_rd <= 1'b0;
        
        // rd_to_wr
        if (rd_to_wr >= 4)
            more_than_4_rd_to_wr <= 1'b1;
        else
            more_than_4_rd_to_wr <= 1'b0;
        
        // rd_to_wr_bc
        if (rd_to_wr_bc >= 4)
            more_than_4_rd_to_wr_bc <= 1'b1;
        else
            more_than_4_rd_to_wr_bc <= 1'b0;
        
        // rd_to_pch
        if (rd_to_pch >= 4)
            more_than_4_rd_to_pch <= 1'b1;
        else
            more_than_4_rd_to_pch <= 1'b0;
        
        // wr_to_wr
        if (wr_to_wr >= 4)
            more_than_4_wr_to_wr <= 1'b1;
        else
            more_than_4_wr_to_wr <= 1'b0;
        
        // wr_to_rd
        if (wr_to_rd >= 4)
            more_than_4_wr_to_rd <= 1'b1;
        else
            more_than_4_wr_to_rd <= 1'b0;
        
        // wr_to_pch
        if (wr_to_pch >= 4)
            more_than_4_wr_to_pch <= 1'b1;
        else
            more_than_4_wr_to_pch <= 1'b0;
        
        // pch_to_act
        if (pch_to_act >= 4)
            more_than_4_pch_to_act <= 1'b1;
        else
            more_than_4_pch_to_act <= 1'b0;
        
        // rd_ap_to_act
        if (rd_ap_to_act >= 4)
            more_than_4_rd_ap_to_act <= 1'b1;
        else
            more_than_4_rd_ap_to_act <= 1'b0;
        
        // wr_ap_to_act
        if (wr_ap_to_act >= 4)
            more_than_4_wr_ap_to_act <= 1'b1;
        else
            more_than_4_wr_ap_to_act <= 1'b0;
        
        // arf_to_valid
        if (arf_to_valid >= 4)
            more_than_4_arf_to_valid <= 1'b1;
        else
            more_than_4_arf_to_valid <= 1'b0;
        
        // pdn_to_valid
        if (pdn_to_valid >= 4)
            more_than_4_pdn_to_valid <= 1'b1;
        else
            more_than_4_pdn_to_valid <= 1'b0;
        
        // srf_to_valid
        if (srf_to_valid >= 4)
            more_than_4_srf_to_valid <= 1'b1;
        else
            more_than_4_srf_to_valid <= 1'b0;
        
        // lmr_to_lmr
        if (lmr_to_lmr >= 4)
            more_than_4_lmr_to_lmr <= 1'b1;
        else
            more_than_4_lmr_to_lmr <= 1'b0;
        
        // lmr_to_valid
        if (lmr_to_valid >= 4)
            more_than_4_lmr_to_valid <= 1'b1;
        else
            more_than_4_lmr_to_valid <= 1'b0;
        
        // arf_period
        if (arf_period >= 4)
            more_than_4_arf_period <= 1'b1;
        else
            more_than_4_arf_period <= 1'b0;
        
        // pdn_period
        if (pdn_period >= 4)
            more_than_4_pdn_period <= 1'b1;
        else
            more_than_4_pdn_period <= 1'b0;
        
        // act_to_act_diff_bank
        if (act_to_act_diff_bank >= 4)
            more_than_4_act_to_act_diff_bank <= 1'b1;
        else
            more_than_4_act_to_act_diff_bank <= 1'b0;
        
        // four_act_to_act
        if (four_act_to_act >= 4)
            more_than_4_four_act_to_act <= 1'b1;
        else
            more_than_4_four_act_to_act <= 1'b0;
        
        if (pch_all_to_act >= 4)
            more_than_4_pch_all_to_act <= 1'b1;
        else
            more_than_4_pch_all_to_act <= 1'b0;
    end
end

reg less_than_4_bank_active;
reg less_than_4_act_to_pch;
reg less_than_4_act_to_act;
reg less_than_4_rd_to_rd;
reg less_than_4_rd_to_wr;
reg less_than_4_rd_to_wr_bc;
reg less_than_4_rd_to_pch;
reg less_than_4_wr_to_wr;
reg less_than_4_wr_to_rd;
reg less_than_4_wr_to_rd_diff_chips;
reg less_than_4_wr_to_pch;
reg less_than_4_pch_to_act;
reg less_than_4_wr_to_rd_to_pch_all; // added to fix wr - rd - pch all bug
reg less_than_4_rd_ap_to_act;
reg less_than_4_wr_ap_to_act;
reg less_than_4_arf_to_valid;
reg less_than_4_pdn_to_valid;
reg less_than_4_srf_to_valid;
reg less_than_4_lmr_to_lmr;
reg less_than_4_lmr_to_valid;
reg less_than_4_arf_period;
reg less_than_4_pdn_period;
reg less_than_4_act_to_act_diff_bank;
reg less_than_4_four_act_to_act;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        less_than_4_bank_active          <= 1'b0;
        less_than_4_act_to_pch           <= 1'b0;
        less_than_4_act_to_act           <= 1'b0;
        less_than_4_rd_to_rd             <= 1'b0;
        less_than_4_rd_to_wr             <= 1'b0;
        less_than_4_rd_to_wr_bc          <= 1'b0;
        less_than_4_rd_to_pch            <= 1'b0;
        less_than_4_wr_to_wr             <= 1'b0;
        less_than_4_wr_to_rd             <= 1'b0;
        less_than_4_wr_to_rd_diff_chips  <= 1'b0;
        less_than_4_wr_to_pch            <= 1'b0;
        less_than_4_wr_to_rd_to_pch_all  <= 1'b0;
        less_than_4_pch_to_act           <= 1'b0;
        less_than_4_rd_ap_to_act         <= 1'b0;
        less_than_4_wr_ap_to_act         <= 1'b0;
        less_than_4_arf_to_valid         <= 1'b0;
        less_than_4_pdn_to_valid         <= 1'b0;
        less_than_4_srf_to_valid         <= 1'b0;
        less_than_4_lmr_to_lmr           <= 1'b0;
        less_than_4_lmr_to_valid         <= 1'b0;
        less_than_4_arf_period           <= 1'b0;
        less_than_4_pdn_period           <= 1'b0;
        less_than_4_act_to_act_diff_bank <= 1'b0;
        less_than_4_four_act_to_act      <= 1'b0;
    end
    else
    begin
        // bank_active
        if (bank_active <= 4)
            less_than_4_bank_active <= 1'b1;
        else
            less_than_4_bank_active <= 1'b0;
        
        // act_to_pch
        if (act_to_pch <= 4)
            less_than_4_act_to_pch <= 1'b1;
        else
            less_than_4_act_to_pch <= 1'b0;
        
        // act_to_act
        if (act_to_act <= 4)
            less_than_4_act_to_act <= 1'b1;
        else
            less_than_4_act_to_act <= 1'b0;
        
        // rd_to_rd
        if (rd_to_rd <= 4)
            less_than_4_rd_to_rd <= 1'b1;
        else
            less_than_4_rd_to_rd <= 1'b0;
        
        // rd_to_wr
        if (rd_to_wr <= 4)
            less_than_4_rd_to_wr <= 1'b1;
        else
            less_than_4_rd_to_wr <= 1'b0;
        
        // rd_to_wr_bc
        if (rd_to_wr_bc <= 4)
            less_than_4_rd_to_wr_bc <= 1'b1;
        else
            less_than_4_rd_to_wr_bc <= 1'b0;
        
        // rd_to_pch
        if (rd_to_pch <= 4)
            less_than_4_rd_to_pch <= 1'b1;
        else
            less_than_4_rd_to_pch <= 1'b0;
        
        // wr_to_wr
        if (wr_to_wr <= 4)
            less_than_4_wr_to_wr <= 1'b1;
        else
            less_than_4_wr_to_wr <= 1'b0;
        
        // wr_to_rd
        if (wr_to_rd <= 4)
            less_than_4_wr_to_rd <= 1'b1;
        else
            less_than_4_wr_to_rd <= 1'b0;
        
        // wr_to_rd_diff_chips
        if (wr_to_rd_diff_chips <= 4)
            less_than_4_wr_to_rd_diff_chips <= 1'b1;
        else
            less_than_4_wr_to_rd_diff_chips <= 1'b0;
        
        // wr_to_pch
        if (wr_to_pch <= 4)
            less_than_4_wr_to_pch <= 1'b1;
        else
            less_than_4_wr_to_pch <= 1'b0;
        
        // wr_to_rd_to_pch_all
        if (wr_to_rd_to_pch_all <= 4)
            less_than_4_wr_to_rd_to_pch_all <= 1'b1;
        else
            less_than_4_wr_to_rd_to_pch_all <= 1'b0;
        
        // pch_to_act
        if (pch_to_act <= 4)
            less_than_4_pch_to_act <= 1'b1;
        else
            less_than_4_pch_to_act <= 1'b0;
        
        // rd_ap_to_act
        if (rd_ap_to_act <= 4)
            less_than_4_rd_ap_to_act <= 1'b1;
        else
            less_than_4_rd_ap_to_act <= 1'b0;
        
        // wr_ap_to_act
        if (wr_ap_to_act <= 4)
            less_than_4_wr_ap_to_act <= 1'b1;
        else
            less_than_4_wr_ap_to_act <= 1'b0;
        
        // arf_to_valid
        if (arf_to_valid <= 4)
            less_than_4_arf_to_valid <= 1'b1;
        else
            less_than_4_arf_to_valid <= 1'b0;
        
        // pdn_to_valid
        if (pdn_to_valid <= 4)
            less_than_4_pdn_to_valid <= 1'b1;
        else
            less_than_4_pdn_to_valid <= 1'b0;
        
        // srf_to_valid
        if (srf_to_valid <= 4)
            less_than_4_srf_to_valid <= 1'b1;
        else
            less_than_4_srf_to_valid <= 1'b0;
        
        // lmr_to_lmr
        if (lmr_to_lmr <= 4)
            less_than_4_lmr_to_lmr <= 1'b1;
        else
            less_than_4_lmr_to_lmr <= 1'b0;
        
        // lmr_to_valid
        if (lmr_to_valid <= 4)
            less_than_4_lmr_to_valid <= 1'b1;
        else
            less_than_4_lmr_to_valid <= 1'b0;
        
        // arf_period
        if (arf_period <= 4)
            less_than_4_arf_period <= 1'b1;
        else
            less_than_4_arf_period <= 1'b0;
        
        // pdn_period
        if (pdn_period <= 4)
            less_than_4_pdn_period <= 1'b1;
        else
            less_than_4_pdn_period <= 1'b0;
        
        // act_to_act_diff_bank
        if (act_to_act_diff_bank <= 4)
            less_than_4_act_to_act_diff_bank <= 1'b1;
        else
            less_than_4_act_to_act_diff_bank <= 1'b0;
        
        // four_act_to_act
        if (four_act_to_act <= 4)
            less_than_4_four_act_to_act <= 1'b1;
        else
            less_than_4_four_act_to_act <= 1'b0;
    end
end

reg more_than_5_bank_active;
reg more_than_5_pch_to_act;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        more_than_5_bank_active <= 1'b0;
        more_than_5_pch_to_act  <= 1'b0;
    end
    else
    begin
        if (bank_active >= 5)
            more_than_5_bank_active <= 1'b1;
        else
            more_than_5_bank_active <= 1'b0;
        
        if (pch_to_act >= 5)
            more_than_5_pch_to_act <= 1'b1;
        else
            more_than_5_pch_to_act <= 1'b0;
    end
end

// compare wr_to_rd_to_pch_all with rd_to_pch
reg compare_wr_to_rd_to_pch_all;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        compare_wr_to_rd_to_pch_all <= 1'b0;
    end
    else
    begin
        if (wr_to_rd_to_pch_all > rd_to_pch)
            compare_wr_to_rd_to_pch_all <= 1'b1;
        else
            compare_wr_to_rd_to_pch_all <= 1'b0;
    end
end

// DIV is a divider for our timinf parameters, DIV will be '1' in fullrate and '2' in halfrate
localparam DIV = DWIDTH_RATIO / 2;

// All timing parameters will be divided by DIV and added with modulo of DIV
// This is to maximize out timing parameter in our halfrate memory controller
// eg: if we have 5 + 4 + 3 = 12 which is an odd number, the desired value we need in halfrate is 6
// we don't want to divide all timing parameters in Java by '2'
// because this will result in 3 + 2 + 2 = 7 (5/2 gives 3 because we don't want any floating points in RTL)

// Common timing parameters
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        bank_active          <= 0;
        act_to_pch           <= 0;
        act_to_act           <= 0;
        pch_to_act           <= 0;
        pch_all_to_act       <= 0;
        arf_to_valid         <= 0;
        pdn_to_valid         <= 0;
        srf_to_valid         <= 0;
        arf_period           <= 0;
        pdn_period           <= 0;
        act_to_act_diff_bank <= 0;
        four_act_to_act      <= 0;
        rd_ap_to_act         <= 0;
        wr_ap_to_act         <= 0;
        wr_to_rd_to_pch_all  <= 0;
    end
    else
    begin
        bank_active          <= (mem_trcd                  / DIV) + (mem_trcd                  % DIV) - 1;   // ACT to RD/WR                         - tRCD (minus '1' because state machine requires another extra clock cycle for pre-processing)
        act_to_pch           <= (mem_tras                  / DIV) + (mem_tras                  % DIV);       // ACT to PCH                           - tRAS
        act_to_act           <= (mem_trc                   / DIV) + (mem_trc                   % DIV);       // ACT to ACT (same bank)               - tRC
        
        pch_to_act           <= (mem_trp                   / DIV) + (mem_trp                   % DIV);       // PCH to ACT                           - tRP
        pch_all_to_act       <= ((mem_trp + 1)             / DIV) + ((mem_trp + 1)             % DIV);       // PCH All to ACT                       - tRPA
        
        arf_to_valid         <= (mem_trfc                  / DIV) + (mem_trfc                  % DIV);       // ARF to VALID                         - tRFC
        pdn_to_valid         <= (3                         / DIV) + (3                         % DIV);       // PDN to VALID                         - normally 3 clock cycles
        srf_to_valid         <= (mem_self_rfsh_exit_cycles / DIV) + (mem_self_rfsh_exit_cycles % DIV);       // SRF to VALID                         - normally 200 clock cycles
        
        arf_period           <= (mem_trefi                 / DIV) + (mem_trefi                 % DIV);       // ARF period                           - tREFI
        pdn_period           <= (mem_auto_pd_cycles        / DIV) + (mem_auto_pd_cycles        % DIV);       // PDN count after CMD_QUEUE is empty   - spepcified by users, 10 maybe?
        act_to_act_diff_bank <= (mem_trrd                  / DIV) + (mem_trrd                  % DIV);       // ACT to ACT (diff banks)              - tRRD
        four_act_to_act      <= (mem_tfaw                  / DIV) + (mem_tfaw                  % DIV) - 4;   // Valid window for 4 ACT               - tFAW (minus '4' because of the tFAW logic)
        
        rd_ap_to_act         <= rd_to_pch + pch_to_act;                                                      // RD with auto precharge to ACT
        wr_ap_to_act         <= wr_to_pch + pch_to_act;                                                      // WR with auto precharge to ACT
        
        if (wr_to_pch > wr_to_rd)
            wr_to_rd_to_pch_all <= wr_to_pch - wr_to_rd;                                                     // this is required to fix wr - rd - pch all bug (see RD state in alt_ddrx_timers_fsm)
        else
            wr_to_rd_to_pch_all <= 0;
    end
end

// Memory specific timing parameters
generate
    if (MEM_TYPE == "DDR")
    begin
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                rd_to_rd         <= 0;
                rd_to_wr         <= 0;
                rd_to_pch        <= 0;
                wr_to_wr         <= 0;
                wr_to_rd         <= 0;
                wr_to_pch        <= 0;
                lmr_to_lmr       <= 0;
                lmr_to_valid     <= 0;
                finish_write     <= 0;
                finish_read      <= 0;
                wr_to_rd_diff_chips <= 0;
            end
            else
            begin
                rd_to_rd  <= (2 / DIV);                                                                                                                                                         // RD to RD     - tCCD
                rd_to_wr  <= ((mem_tcl + (mem_burst_length / 2) + mem_rd_to_wr_turnaround_oct) / DIV) + ((mem_tcl + (mem_burst_length / 2) + mem_rd_to_wr_turnaround_oct) % DIV);               // RD to WR     - CAS + (BL/2)
                rd_to_pch <= ((mem_burst_length / 2) / DIV);                                                                                                                                    // RD to PCH    - (BL/2)
                
                wr_to_wr  <= (2 / DIV);                                                                                                                                                         // WR to WR     - tCCD
                wr_to_rd  <= ((1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) / DIV) + ((1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) % DIV);     // WR to RD     - WL + (BL/2) + tWTR (WL is always 1 in DDR)
                wr_to_pch <= ((1 + (mem_burst_length / 2) + mem_twr)  / DIV) + ((1 + (mem_burst_length / 2) + mem_twr)  % DIV);                                                                 // WR to PCH    - WL + (BL/2) + tWR
                
                wr_to_rd_diff_chips <= (((mem_burst_length / 2) + 3 + mem_wr_to_rd_turnaround_oct) / DIV) + (((mem_burst_length / 2) + 3 + mem_wr_to_rd_turnaround_oct) % DIV);                 // WR to RD different rank  - (WL - RL) + (BL/2) + 2 (dead cycles)
                
                lmr_to_lmr   <= (mem_tmrd / DIV) + (mem_tmrd % DIV);         // LMR to LMR   - tMRD
                lmr_to_valid <= (mem_tmrd / DIV) + (mem_tmrd % DIV);         // LMR to LMR   - tMRD as well because there is no tMOD (LMR to VALID) in DDR
                
                finish_write <= wr_to_pch + pch_to_act;
                finish_read  <= rd_to_pch + pch_to_act;
            end
        end
    end
    else if (MEM_TYPE == "DDR2")
    begin
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                rd_to_rd         <= 0;
                rd_to_wr         <= 0;
                rd_to_pch        <= 0;
                wr_to_wr         <= 0;
                wr_to_rd         <= 0;
                wr_to_pch        <= 0;
                lmr_to_lmr       <= 0;
                lmr_to_valid     <= 0;
                finish_write     <= 0;
                finish_read      <= 0;
                wr_to_rd_diff_chips <= 0;
            end
            else
            begin
                rd_to_rd  <= (4 / DIV); // tCCD is 2 but we set to 4 because we do burst length of 8
                rd_to_wr  <= (((mem_burst_length / 2) + 2 + mem_rd_to_wr_turnaround_oct) / DIV) + (((mem_burst_length / 2) + 2 + mem_rd_to_wr_turnaround_oct) % DIV);
                rd_to_pch <= ((mem_add_lat + (mem_burst_length / 2) - 2 + max(mem_trtp, 2)) / DIV) + ((mem_add_lat + (mem_burst_length / 2) - 2 + max(mem_trtp, 2)) % DIV);
                
                wr_to_wr  <= (4 / DIV); // tCCD is 2 but we set to 4 because we do burst length of 8
                wr_to_rd  <= ((mem_tcl - 1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) / DIV) + ((mem_tcl - 1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) % DIV); // removed add lat because write and read is CAS command (add lat)
                wr_to_pch <= ((mem_add_lat + mem_tcl - 1 + (mem_burst_length / 2) + mem_twr)  / DIV) + ((mem_add_lat + mem_tcl - 1 + (mem_burst_length / 2) + mem_twr)  % DIV);
                
                wr_to_rd_diff_chips <= (((mem_burst_length / 2) + 1 + mem_wr_to_rd_turnaround_oct) / DIV) + (((mem_burst_length / 2) + 1 + mem_wr_to_rd_turnaround_oct) % DIV);
                
                lmr_to_lmr   <= (mem_tmrd / DIV) + (mem_tmrd % DIV);
                lmr_to_valid <= (mem_tmod / DIV) + (mem_tmod % DIV);
                
                finish_write <= wr_to_pch + pch_to_act;
                finish_read  <= rd_to_pch + pch_to_act;
            end
        end
    end
    else if (MEM_TYPE == "DDR3")
    begin
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                rd_to_rd         <= 0;
                rd_to_wr         <= 0;
                rd_to_wr_bc      <= 0;
                rd_to_pch        <= 0;
                wr_to_wr         <= 0;
                wr_to_rd         <= 0;
                wr_to_pch        <= 0;
                lmr_to_lmr       <= 0;
                lmr_to_valid     <= 0;
                finish_write     <= 0;
                finish_read      <= 0;
                wr_to_rd_diff_chips <= 0;
                
                srf_to_zq        <= 0; // DDR3 specific
            end
            else
            begin
                rd_to_rd     <= (4 / DIV);
                rd_to_wr     <= ((mem_tcl - mem_cas_wr_lat + 4 + 2 + mem_rd_to_wr_turnaround_oct) / DIV) + ((mem_tcl - mem_cas_wr_lat + 4 + 2 + mem_rd_to_wr_turnaround_oct) % DIV); // cas lat - cas wr lat + tCCD + 2
                rd_to_wr_bc  <= ((mem_tcl - mem_cas_wr_lat + 2 + 2 + mem_rd_to_wr_turnaround_oct) / DIV) + ((mem_tcl - mem_cas_wr_lat + 2 + 2 + mem_rd_to_wr_turnaround_oct) % DIV); // tCCD/2 <= 2
                rd_to_pch    <= ((mem_add_lat + max(mem_trtp, 4)) / DIV) + ((mem_add_lat + max(mem_trtp, 4)) % DIV);
                
                wr_to_wr     <= (4 / DIV);
                wr_to_rd     <= ((mem_cas_wr_lat + (mem_burst_length / 2) + max(mem_twtr, 4) + mem_wr_to_rd_turnaround_oct) / DIV) + ((mem_cas_wr_lat + (mem_burst_length / 2) + max(mem_twtr, 4) + mem_wr_to_rd_turnaround_oct) % DIV); // reported by Denali, WR to RD delay is add_lat + cas_wr_lat + (bl/2) + max(tCCD or tWTR)
                wr_to_pch    <= ((mem_add_lat + mem_cas_wr_lat + (mem_burst_length / 2) + mem_twr)  / DIV) + ((mem_add_lat + mem_cas_wr_lat + (mem_burst_length / 2) + mem_twr)  % DIV);
                
                wr_to_rd_diff_chips <= (((mem_cas_wr_lat - mem_tcl) + (mem_burst_length / 2) + 2 + mem_wr_to_rd_turnaround_oct) / DIV) + (((mem_cas_wr_lat - mem_tcl) + (mem_burst_length / 2) + 2 + mem_wr_to_rd_turnaround_oct) % DIV);
                
                lmr_to_lmr   <= (mem_tmrd / DIV) + (mem_tmrd % DIV);
                lmr_to_valid <= (mem_tmod / DIV) + (mem_tmod % DIV);
                
                finish_write <= wr_to_pch + pch_to_act;
                finish_read  <= rd_to_pch + pch_to_act;
                
                srf_to_zq    <= (256 / DIV);
            end
        end
    end
endgenerate

// function to determine max of 2 inputs
function reg [WR_TO_RD_WIDTH - 1 : 0] max;
    input [WR_TO_RD_WIDTH - 1 : 0] value1;
    input [WR_TO_RD_WIDTH - 1 : 0] value2;
    begin
        if (value1 > value2)
            max = value1;
        else
            max = value2;
    end
endfunction

// indicate additive latency is on to state machine
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        add_lat_on <= 1'b0;
    end
    else
    begin
        if (mem_add_lat == 0)
        begin
            if (bank_active == 0)
                add_lat_on <= 1'b1;
            else
                add_lat_on <= 1'b0;
        end
        else
        begin
            // if AL is greater than tRCD-1, then we can do back to back activate-read/write
            if (mem_add_lat >= (mem_trcd - 1))
                add_lat_on <= 1'b1;
            else
                add_lat_on <= 1'b0;
        end
    end
end

// states for our DQS bus monitor state machine
localparam IDLE  = 32'h49444C45;
localparam WR    = 32'h20205752;
localparam RD    = 32'h20205244;

// width parameters for our counters
localparam RD_WR_COUNTER_WIDTH    = 7;
localparam ACTIVATE_COUNTER_WIDTH = 6;  // 8-32
localparam PDN_COUNTER_WIDTH      = AUTO_PD_BUS_WIDTH;
localparam ARF_COUNTER_WIDTH      = TREFI_BUS_WIDTH;

reg [31 : 0] state;

reg [RD_WR_COUNTER_WIDTH - 1 : 0] cnt;

reg dqs_ready;
reg doing_burst_chop;
reg read_dqs_ready;
reg write_dqs_ready;
reg [MEM_IF_CS_WIDTH - 1 : 0] write_to_read_finish_twtr;
reg [WR_TO_RD_WIDTH  - 1 : 0] twtr_cnt [MEM_IF_CS_WIDTH - 1 : 0];

reg [MEM_IF_CS_WIDTH - 1 : 0] to_chip_r1;

// Num of CSs * Num of Banks
reg [2 ** MEM_IF_BA_WIDTH - 1 : 0] bus_do_precharge_all [MEM_IF_CS_WIDTH - 1 : 0];
reg [2 ** MEM_IF_BA_WIDTH - 1 : 0] bus_do_refresh       [MEM_IF_CS_WIDTH - 1 : 0];
reg [2 ** MEM_IF_BA_WIDTH - 1 : 0] bus_do_power_down    [MEM_IF_CS_WIDTH - 1 : 0];
reg [2 ** MEM_IF_BA_WIDTH - 1 : 0] bus_do_self_rfsh     [MEM_IF_CS_WIDTH - 1 : 0];
reg [2 ** MEM_IF_BA_WIDTH - 1 : 0] bus_do_lmr           [MEM_IF_CS_WIDTH - 1 : 0];

reg [2 ** MEM_IF_BA_WIDTH - 1 : 0] do_enable            [MEM_IF_CS_WIDTH - 1 : 0];

reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_activate;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_precharge;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_write;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_read;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_refresh;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_power_down;
reg [CTL_LOOK_AHEAD_DEPTH : 0] cmd_do_self_rfsh;

reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_activate_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_precharge_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_write_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_read_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_refresh_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_power_down_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_do_self_rfsh_r1;

reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_activate_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_precharge_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_write_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_read_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_refresh_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_power_down_r1;
reg [CTL_CMD_QUEUE_DEPTH : 0] cmd_do_self_rfsh_r1;

reg [CTL_LOOK_AHEAD_DEPTH : 0] bus_can_read_reg;
reg [CTL_LOOK_AHEAD_DEPTH : 0] bus_can_write_reg;
reg [CTL_LOOK_AHEAD_DEPTH : 0] bus_can_activate_reg;
reg [CTL_LOOK_AHEAD_DEPTH : 0] bus_can_precharge_reg;

reg [MEM_IF_CS_WIDTH - 1 : 0] delay_can_exit_power_saving_mode;
reg [MEM_IF_CS_WIDTH - 1 : 0] non_delay_can_exit_power_saving_mode;

reg [MEM_IF_CS_WIDTH - 1 : 0] int_can_refresh;
reg [MEM_IF_CS_WIDTH - 1 : 0] int_can_enter_power_down;
reg [MEM_IF_CS_WIDTH - 1 : 0] int_can_exit_power_saving_mode;
reg [MEM_IF_CS_WIDTH - 1 : 0] int_can_exit_power_saving_mode_r1;
reg [MEM_IF_CS_WIDTH - 1 : 0] int_can_self_rfsh;
reg [MEM_IF_CS_WIDTH - 1 : 0] int_can_lmr;
reg [MEM_IF_CS_WIDTH - 1 : 0] int_zq_cal_req;

reg [MEM_IF_CS_WIDTH - 1 : 0] can_precharge_all;
reg [MEM_IF_CS_WIDTH - 1 : 0] can_refresh;
reg [MEM_IF_CS_WIDTH - 1 : 0] can_enter_power_down;
reg [MEM_IF_CS_WIDTH - 1 : 0] can_exit_power_saving_mode;
reg [MEM_IF_CS_WIDTH - 1 : 0] can_self_rfsh;
reg [MEM_IF_CS_WIDTH - 1 : 0] can_lmr;

reg zq_cal_req;

reg [MEM_IF_CS_WIDTH - 1 : 0] act_diff_bank;
reg [MEM_IF_CS_WIDTH - 1 : 0] act_valid_window;

reg do_power_down_r1;
reg no_command;
reg no_command_r1;

reg power_down_req;
reg [PDN_COUNTER_WIDTH : 0] power_down_cnt;

wire auto_refresh_req;
reg [MEM_IF_CS_WIDTH - 1 : 0] auto_refresh_chip;
reg [ARF_COUNTER_WIDTH - 1 : 0] auto_refresh_cnt [MEM_IF_CS_WIDTH - 1 : 0];

reg doing_write;
reg doing_read;
reg enable_chip_request;
reg enable_chip_request_ddr2;
reg [FINISH_WRITE_WIDTH - 1 : 0] chip_request_cnt;
reg [MEM_IF_CS_WIDTH    - 1 : 0] doing_auto_pch;
reg [MEM_IF_CS_WIDTH    - 1 : 0] enable_chip_request_trc_done;
reg [ACT_TO_ACT_WIDTH   - 1 : 0] trc_cnt [MEM_IF_CS_WIDTH - 1 : 0];

reg [CTL_CMD_QUEUE_DEPTH : 0] int_cmd_is_valid;
reg int_cmd_is_valid_r1;
reg cmd_cache;
reg ecc_fetch_error_addr_r1;
reg fetch_r1;
reg [1 : 0] flush;

reg chip_change;
reg prev_multicast_req;
reg [MEM_IF_CHIP_BITS - 1 : 0] prev_chip_addr;

reg can_read_current;
reg can_write_current;
reg [1 : 0] can_read;
reg [1 : 0] can_write;

reg  can_activate_current;
reg  can_precharge_current;

wire [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_activate;
wire [CTL_LOOK_AHEAD_DEPTH - 1 : 0] can_precharge;

reg [CTL_CMD_QUEUE_DEPTH - 1 : 0] int_can_activate;
reg [CTL_CMD_QUEUE_DEPTH - 1 : 0] int_can_precharge;

reg [CTL_CMD_QUEUE_DEPTH : 0] int_bus_can_read_reg;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_bus_can_write_reg;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_bus_can_activate_reg;
reg [CTL_CMD_QUEUE_DEPTH : 0] int_bus_can_precharge_reg;

wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_read          [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_write         [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_activate      [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_activate_chip [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_precharge     [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_refresh       [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_power_down    [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_self_rfsh     [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_can_lmr           [MEM_IF_CS_WIDTH - 1 : 0];
wire [(2 ** MEM_IF_BA_WIDTH) - 1 : 0] bus_zq_cal_req        [MEM_IF_CS_WIDTH - 1 : 0];

wire [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_BA_WIDTH  - 1 : 0] cmd_bank_addr;
wire [(CTL_CMD_QUEUE_DEPTH + 1) * MEM_IF_CHIP_BITS - 1 : 0] cmd_chip_addr;
wire [CTL_CMD_QUEUE_DEPTH : 0] cmd_is_valid;
wire [CTL_CMD_QUEUE_DEPTH : 0] multicast_req;
wire [CTL_CMD_QUEUE_DEPTH : 0] is_a_write;
wire [CTL_CMD_QUEUE_DEPTH : 0] is_a_read;
wire [CTL_CMD_QUEUE_DEPTH : 0] cmd_multicast_req;

//assign cmd_addr          = {cmd7_addr, cmd6_addr, cmd5_addr, cmd4_addr, cmd3_addr, cmd2_addr, cmd1_addr, cmd0_addr, current_addr};
assign cmd_chip_addr     = {cmd7_chip_addr, cmd6_chip_addr, cmd5_chip_addr, cmd4_chip_addr, cmd3_chip_addr, cmd2_chip_addr, cmd1_chip_addr, cmd0_chip_addr, current_chip_addr};
assign cmd_bank_addr     = {cmd7_bank_addr, cmd6_bank_addr, cmd5_bank_addr, cmd4_bank_addr, cmd3_bank_addr, cmd2_bank_addr, cmd1_bank_addr, cmd0_bank_addr, current_bank_addr};
assign cmd_is_valid      = {cmd7_is_valid, cmd6_is_valid, cmd5_is_valid, cmd4_is_valid, cmd3_is_valid, cmd2_is_valid, cmd1_is_valid, cmd0_is_valid, 1'b0}; // current signal doesn't have valid signal

assign multicast_req = {cmd7_multicast_req, cmd6_multicast_req, cmd5_multicast_req, cmd4_multicast_req, cmd3_multicast_req, cmd2_multicast_req, cmd1_multicast_req, cmd0_multicast_req, current_multicast_req};
assign is_a_write    = {cmd7_is_a_write, cmd6_is_a_write, cmd5_is_a_write, cmd4_is_a_write, cmd3_is_a_write, cmd2_is_a_write, cmd1_is_a_write, cmd0_is_a_write, current_is_a_write};
assign is_a_read     = {cmd7_is_a_read, cmd6_is_a_read, cmd5_is_a_read, cmd4_is_a_read, cmd3_is_a_read, cmd2_is_a_read, cmd1_is_a_read, cmd0_is_a_read, current_is_a_read};

// we only need to assert multicast request during write because during read with multicast (supported in the future) state machine will choose one of the chip to read
assign cmd_multicast_req = multicast_req & is_a_write;
/*------------------------------------------------------------------------------

    Input Bus

------------------------------------------------------------------------------*/
// This signal will indicate the banks specific state machine whether the current do signal is valid
generate
    genvar z_outer;
    genvar z_inner;
    for (z_outer = 0;z_outer < MEM_IF_CS_WIDTH;z_outer = z_outer + 1)
    begin : input_do_signal_fanout_per_chip
        for (z_inner = 0;z_inner < 2 ** MEM_IF_BA_WIDTH; z_inner = z_inner + 1)
        begin : input_do_signal_fanout_per_bank
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    do_enable [z_outer][z_inner] <= 1'b0;
                else
                begin
                    if (to_chip [z_outer] && z_inner == to_bank_addr)
                        do_enable [z_outer][z_inner] <= 1'b1;
                    else
                        do_enable [z_outer][z_inner] <= 1'b0;
                end
            end
        end
    end
endgenerate

reg do_write_r1;
reg do_read_r1;
reg do_activate_r1;
reg do_precharge_r1;
reg do_auto_precharge_r1;
reg do_precharge_all_r1;
reg do_refresh_r1;
reg do_self_rfsh_r1;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        do_write_r1          <= 1'b0;
        do_read_r1           <= 1'b0;
        do_activate_r1       <= 1'b0;
        do_precharge_r1      <= 1'b0;
        do_auto_precharge_r1 <= 1'b0;
        do_precharge_all_r1  <= 1'b0;
        do_refresh_r1        <= 1'b0;
        do_self_rfsh_r1      <= 1'b0;
    end
    else
    begin
        do_write_r1          <= do_write;
        do_read_r1           <= do_read;
        do_activate_r1       <= do_activate;
        do_precharge_r1      <= do_precharge;
        do_auto_precharge_r1 <= do_auto_precharge;
        do_precharge_all_r1  <= do_precharge_all;
        do_refresh_r1        <= do_refresh;
        do_self_rfsh_r1      <= do_self_rfsh;
    end
end

// Fanout of refresh and power down signal to one bank per chip only (first bank), this is to reduce number of resource used in this design
// Quartus will optimize away registers and ALUTs which are not used (not connected)
generate
    genvar w;
    for (w = 0;w < MEM_IF_CS_WIDTH; w = w + 1)
    begin : input_signal_fanout_per_chip
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                bus_do_precharge_all [w][2 ** MEM_IF_BA_WIDTH - 1 : 0] <= 0;
            end
            else
            begin
                if (do_precharge_all && to_chip[w])
                    bus_do_precharge_all [w][2 ** MEM_IF_BA_WIDTH - 1 : 0] <= {(2 ** MEM_IF_BA_WIDTH){1'b1}};
                else
                    bus_do_precharge_all [w][2 ** MEM_IF_BA_WIDTH - 1 : 0] <= 0;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                bus_do_refresh    [w][0] <= 1'b0;
                bus_do_power_down [w][0] <= 1'b0;
                bus_do_self_rfsh  [w][0] <= 1'b0;
                bus_do_lmr        [w][0] <= 1'b0;
            end
            else
            begin
                if (do_refresh && to_chip[w])
                    bus_do_refresh [w][0] <= 1'b1;
                else
                    bus_do_refresh [w][0] <= 1'b0;
                
                if (do_power_down && to_chip[w])
                    bus_do_power_down [w][0] <= 1'b1;
                else
                    bus_do_power_down [w][0] <= 1'b0;
                
                if (do_self_rfsh && to_chip[w])
                    bus_do_self_rfsh [w][0] <= 1'b1;
                else
                    bus_do_self_rfsh [w][0] <= 1'b0;
                
                if (do_lmr && to_chip[w])
                    bus_do_lmr [w][0] <= 1'b1;
                else
                    bus_do_lmr [w][0] <= 1'b0;
            end
        end
    end
endgenerate

// Fanout of do activate, precharge, read and write signal for current and command queue
// will use these signals to manipulate can signals to state machine
generate
    genvar p;
    for (p = 0;p < CTL_LOOK_AHEAD_DEPTH + 1;p = p + 1)
    begin : input_do_signal_fanout_per_cmd
        wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(p + 1) * MEM_IF_BA_WIDTH  - 1 : p * MEM_IF_BA_WIDTH];
        wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(p + 1) * MEM_IF_CHIP_BITS - 1 : p * MEM_IF_CHIP_BITS];
        
        always @ (*)
        begin
            // do_activate
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (do_activate && to_bank_addr == bank_addr)
                    cmd_do_activate [p] = 1'b1;
                else
                    cmd_do_activate [p] = 1'b0;
            end
            else
            begin
                if (do_activate && to_chip [chip_addr] && to_bank_addr == bank_addr)
                    cmd_do_activate [p] = 1'b1;
                else
                    cmd_do_activate [p] = 1'b0;
            end
            
            // do_precharge
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (((do_auto_precharge || do_precharge) && to_bank_addr == bank_addr) || do_precharge_all)
                    cmd_do_precharge [p] = 1'b1;
                else
                    cmd_do_precharge [p] = 1'b0;
            end
            else
            begin
                if ((((do_auto_precharge || do_precharge) && to_bank_addr == bank_addr) || do_precharge_all) && to_chip [chip_addr])
                    cmd_do_precharge [p] = 1'b1;
                else
                    cmd_do_precharge [p] = 1'b0;
            end
            
            // do_write
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (do_write && to_bank_addr == bank_addr)
                    cmd_do_write [p] = 1'b1;
                else
                    cmd_do_write [p] = 1'b0;
            end
            else
            begin
                if (do_write && to_chip [chip_addr] && to_bank_addr == bank_addr)
                    cmd_do_write [p] = 1'b1;
                else
                    cmd_do_write [p] = 1'b0;
            end
            
            // do_read
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (do_read && to_bank_addr == bank_addr)
                    cmd_do_read [p] = 1'b1;
                else
                    cmd_do_read [p] = 1'b0;
            end
            else
            begin
                if (do_read && to_chip [chip_addr] && to_bank_addr == bank_addr)
                    cmd_do_read [p] = 1'b1;
                else
                    cmd_do_read [p] = 1'b0;
            end
            
            // do_refresh
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (do_refresh)
                    cmd_do_refresh [p] = 1'b1;
                else
                    cmd_do_refresh [p] = 1'b0;
            end
            else
            begin
                if (do_refresh && to_chip [chip_addr])
                    cmd_do_refresh [p] = 1'b1;
                else
                    cmd_do_refresh [p] = 1'b0;
            end
            
            // do_power_down
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (do_power_down)
                    cmd_do_power_down [p] = 1'b1;
                else
                    cmd_do_power_down [p] = 1'b0;
            end
            else
            begin
                if (do_power_down && to_chip [chip_addr])
                    cmd_do_power_down [p] = 1'b1;
                else
                    cmd_do_power_down [p] = 1'b0;
            end
            
            // do_self_rfsh
            if (cmd_multicast_req [p]) // don't care to_chip during multicast
            begin
                if (do_self_rfsh)
                    cmd_do_self_rfsh [p] = 1'b1;
                else
                    cmd_do_self_rfsh [p] = 1'b0;
            end
            else
            begin
                if (do_self_rfsh && to_chip [chip_addr])
                    cmd_do_self_rfsh [p] = 1'b1;
                else
                    cmd_do_self_rfsh [p] = 1'b0;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_cmd_do_activate_r1   [p] <= 1'b0;
                int_cmd_do_precharge_r1  [p] <= 1'b0;
                int_cmd_do_write_r1      [p] <= 1'b0;
                int_cmd_do_read_r1       [p] <= 1'b0;
                int_cmd_do_refresh_r1    [p] <= 1'b0;
                int_cmd_do_power_down_r1 [p] <= 1'b0;
                int_cmd_do_self_rfsh_r1  [p] <= 1'b0;
            end
            else
            begin
                // do_activate
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (do_activate && to_bank_addr == bank_addr)
                        int_cmd_do_activate_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_activate_r1 [p] <= 1'b0;
                end
                else
                begin
                    if (do_activate && to_chip [chip_addr] && to_bank_addr == bank_addr)
                        int_cmd_do_activate_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_activate_r1 [p] <= 1'b0;
                end
                
                // do_precharge
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (((do_auto_precharge || do_precharge) && to_bank_addr == bank_addr) || do_precharge_all)
                        int_cmd_do_precharge_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_precharge_r1 [p] <= 1'b0;
                end
                else
                begin
                    if ((((do_auto_precharge || do_precharge) && to_bank_addr == bank_addr) || do_precharge_all) && to_chip [chip_addr])
                        int_cmd_do_precharge_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_precharge_r1 [p] <= 1'b0;
                end
                
                // do_write
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (do_write && to_bank_addr == bank_addr)
                        int_cmd_do_write_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_write_r1 [p] <= 1'b0;
                end
                else
                begin
                    if (do_write && to_chip [chip_addr] && to_bank_addr == bank_addr)
                        int_cmd_do_write_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_write_r1 [p] <= 1'b0;
                end
                
                // do_read
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (do_read && to_bank_addr == bank_addr)
                        int_cmd_do_read_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_read_r1 [p] <= 1'b0;
                end
                else
                begin
                    if (do_read && to_chip [chip_addr] && to_bank_addr == bank_addr)
                        int_cmd_do_read_r1 [p] <= 1'b1;
                    else
                        int_cmd_do_read_r1 [p] <= 1'b0;
                end
                
                // do_refresh
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (do_refresh)
                        int_cmd_do_refresh_r1 [p] = 1'b1;
                    else
                        int_cmd_do_refresh_r1 [p] = 1'b0;
                end
                else
                begin
                    if (do_refresh && to_chip [chip_addr])
                        int_cmd_do_refresh_r1 [p] = 1'b1;
                    else
                        int_cmd_do_refresh_r1 [p] = 1'b0;
                end
                
                // do_power_down
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (do_power_down)
                        int_cmd_do_power_down_r1 [p] = 1'b1;
                    else
                        int_cmd_do_power_down_r1 [p] = 1'b0;
                end
                else
                begin
                    if (do_power_down && to_chip [chip_addr])
                        int_cmd_do_power_down_r1 [p] = 1'b1;
                    else
                        int_cmd_do_power_down_r1 [p] = 1'b0;
                end
                
                // do_self_rfsh
                if (cmd_multicast_req [p]) // don't care to_chip during multicast
                begin
                    if (do_self_rfsh)
                        int_cmd_do_self_rfsh_r1 [p] = 1'b1;
                    else
                        int_cmd_do_self_rfsh_r1 [p] = 1'b0;
                end
                else
                begin
                    if (do_self_rfsh && to_chip [chip_addr])
                        int_cmd_do_self_rfsh_r1 [p] = 1'b1;
                    else
                        int_cmd_do_self_rfsh_r1 [p] = 1'b0;
                end
            end
        end
    end
endgenerate

/*------------------------------------------------------------------------------

    Output Bus

------------------------------------------------------------------------------*/
assign can_activate            = int_can_activate            [CTL_LOOK_AHEAD_DEPTH - 1 : 0];
assign can_precharge           = int_can_precharge           [CTL_LOOK_AHEAD_DEPTH - 1 : 0];
/*------------------------------------------------------------------------------
    Caching the outputs
------------------------------------------------------------------------------*/
always @ (*)
begin
    if (cmd_cache)
    begin
        if (flush == 2'b01)
        begin
            can_read_current        = int_bus_can_read_reg [2];
            can_read [0]            = int_bus_can_read_reg [3];
            can_read [1]            = int_bus_can_read_reg [4];
            
            can_write_current       = int_bus_can_write_reg [2];
            can_write [0]           = int_bus_can_write_reg [3];
            can_write [1]           = int_bus_can_write_reg [4];
            
            // cmd do signal (registered version)
            cmd_do_activate_r1 [0]  = int_cmd_do_activate_r1 [2];
            cmd_do_activate_r1 [1]  = int_cmd_do_activate_r1 [3];
            cmd_do_activate_r1 [2]  = int_cmd_do_activate_r1 [4];
            cmd_do_activate_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [5];
            cmd_do_activate_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [6];
            cmd_do_activate_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [7];
            cmd_do_activate_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [8];
            cmd_do_activate_r1 [7]  = 1'b0;
            cmd_do_activate_r1 [8]  = 1'b0;
            
            cmd_do_precharge_r1 [0]  = int_cmd_do_precharge_r1 [2];
            cmd_do_precharge_r1 [1]  = int_cmd_do_precharge_r1 [3];
            cmd_do_precharge_r1 [2]  = int_cmd_do_precharge_r1 [4];
            cmd_do_precharge_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [5];
            cmd_do_precharge_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [6];
            cmd_do_precharge_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [7];
            cmd_do_precharge_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [8];
            cmd_do_precharge_r1 [7]  = 1'b0;
            cmd_do_precharge_r1 [8]  = 1'b0;
            
            cmd_do_write_r1 [0]      = int_cmd_do_write_r1 [2];
            cmd_do_write_r1 [1]      = int_cmd_do_write_r1 [3];
            cmd_do_write_r1 [2]      = int_cmd_do_write_r1 [4];
            cmd_do_write_r1 [3]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [5];
            cmd_do_write_r1 [4]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [6];
            cmd_do_write_r1 [5]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [7];
            cmd_do_write_r1 [6]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [8];
            cmd_do_write_r1 [7]      = 1'b0;
            cmd_do_write_r1 [8]      = 1'b0;
            
            cmd_do_read_r1 [0]       = int_cmd_do_read_r1 [2];
            cmd_do_read_r1 [1]       = int_cmd_do_read_r1 [3];
            cmd_do_read_r1 [2]       = int_cmd_do_read_r1 [4];
            cmd_do_read_r1 [3]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [5];
            cmd_do_read_r1 [4]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [6];
            cmd_do_read_r1 [5]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [7];
            cmd_do_read_r1 [6]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [8];
            cmd_do_read_r1 [7]       = 1'b0;
            cmd_do_read_r1 [8]       = 1'b0;
            
            //cmd_do_refresh_r1 [0]    = int_cmd_do_refresh_r1 [2];
            //cmd_do_refresh_r1 [1]    = int_cmd_do_refresh_r1 [3];
            //cmd_do_refresh_r1 [2]    = int_cmd_do_refresh_r1 [4];
            //cmd_do_refresh_r1 [3]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [5];
            //cmd_do_refresh_r1 [4]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [6];
            //cmd_do_refresh_r1 [5]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [7];
            //cmd_do_refresh_r1 [6]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [8];
            //cmd_do_refresh_r1 [7]    = 1'b0;
            //cmd_do_refresh_r1 [8]    = 1'b0;
            //
            //cmd_do_power_down_r1 [0] = int_cmd_do_power_down_r1 [2];
            //cmd_do_power_down_r1 [1] = int_cmd_do_power_down_r1 [3];
            //cmd_do_power_down_r1 [2] = int_cmd_do_power_down_r1 [4];
            //cmd_do_power_down_r1 [3] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [5];
            //cmd_do_power_down_r1 [4] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [6];
            //cmd_do_power_down_r1 [5] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [7];
            //cmd_do_power_down_r1 [6] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [8];
            //cmd_do_power_down_r1 [7] = 1'b0;
            //cmd_do_power_down_r1 [8] = 1'b0;
            //
            //cmd_do_self_rfsh_r1 [0]  = int_cmd_do_self_rfsh_r1 [2];
            //cmd_do_self_rfsh_r1 [1]  = int_cmd_do_self_rfsh_r1 [3];
            //cmd_do_self_rfsh_r1 [2]  = int_cmd_do_self_rfsh_r1 [4];
            //cmd_do_self_rfsh_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [5];
            //cmd_do_self_rfsh_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [6];
            //cmd_do_self_rfsh_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [7];
            //cmd_do_self_rfsh_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [8];
            //cmd_do_self_rfsh_r1 [7]  = 1'b0;
            //cmd_do_self_rfsh_r1 [8]  = 1'b0;
        end
        else if (flush == 2'b10)
        begin
            can_read_current        = int_bus_can_read_reg [3];
            can_read [0]            = int_bus_can_read_reg [4];
            can_read [1]            = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_read_reg [5];
            
            can_write_current       = int_bus_can_write_reg [3];
            can_write [0]           = int_bus_can_write_reg [4];
            can_write [1]           = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_write_reg [5];
            
            // cmd do signal (registered version)
            cmd_do_activate_r1 [0]  = int_cmd_do_activate_r1 [3];
            cmd_do_activate_r1 [1]  = int_cmd_do_activate_r1 [4];
            cmd_do_activate_r1 [2]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [5];
            cmd_do_activate_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [6];
            cmd_do_activate_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [7];
            cmd_do_activate_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [8];
            cmd_do_activate_r1 [6]  = 1'b0;
            cmd_do_activate_r1 [7]  = 1'b0;
            cmd_do_activate_r1 [8]  = 1'b0;
            
            cmd_do_precharge_r1 [0]  = int_cmd_do_precharge_r1 [3];
            cmd_do_precharge_r1 [1]  = int_cmd_do_precharge_r1 [4];
            cmd_do_precharge_r1 [2]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [5];
            cmd_do_precharge_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [6];
            cmd_do_precharge_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [7];
            cmd_do_precharge_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [8];
            cmd_do_precharge_r1 [6]  = 1'b0;
            cmd_do_precharge_r1 [7]  = 1'b0;
            cmd_do_precharge_r1 [8]  = 1'b0;
            
            cmd_do_write_r1 [0]      = int_cmd_do_write_r1 [3];
            cmd_do_write_r1 [1]      = int_cmd_do_write_r1 [4];
            cmd_do_write_r1 [2]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [5];
            cmd_do_write_r1 [3]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [6];
            cmd_do_write_r1 [4]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [7];
            cmd_do_write_r1 [5]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [8];
            cmd_do_write_r1 [6]      = 1'b0;
            cmd_do_write_r1 [7]      = 1'b0;
            cmd_do_write_r1 [8]      = 1'b0;
            
            cmd_do_read_r1 [0]       = int_cmd_do_read_r1 [3];
            cmd_do_read_r1 [1]       = int_cmd_do_read_r1 [4];
            cmd_do_read_r1 [2]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [5];
            cmd_do_read_r1 [3]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [6];
            cmd_do_read_r1 [4]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [7];
            cmd_do_read_r1 [5]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [8];
            cmd_do_read_r1 [6]       = 1'b0;
            cmd_do_read_r1 [7]       = 1'b0;
            cmd_do_read_r1 [8]       = 1'b0;
            
            //cmd_do_refresh_r1 [0]    = int_cmd_do_refresh_r1 [3];
            //cmd_do_refresh_r1 [1]    = int_cmd_do_refresh_r1 [4];
            //cmd_do_refresh_r1 [2]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [5];
            //cmd_do_refresh_r1 [3]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [6];
            //cmd_do_refresh_r1 [4]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [7];
            //cmd_do_refresh_r1 [5]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [8];
            //cmd_do_refresh_r1 [6]    = 1'b0;
            //cmd_do_refresh_r1 [7]    = 1'b0;
            //cmd_do_refresh_r1 [8]    = 1'b0;
            //
            //cmd_do_power_down_r1 [0] = int_cmd_do_power_down_r1 [3];
            //cmd_do_power_down_r1 [1] = int_cmd_do_power_down_r1 [4];
            //cmd_do_power_down_r1 [2] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [5];
            //cmd_do_power_down_r1 [3] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [6];
            //cmd_do_power_down_r1 [4] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [7];
            //cmd_do_power_down_r1 [5] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [8];
            //cmd_do_power_down_r1 [6] = 1'b0;
            //cmd_do_power_down_r1 [7] = 1'b0;
            //cmd_do_power_down_r1 [8] = 1'b0;
            //
            //cmd_do_self_rfsh_r1 [0]  = int_cmd_do_self_rfsh_r1 [3];
            //cmd_do_self_rfsh_r1 [1]  = int_cmd_do_self_rfsh_r1 [4];
            //cmd_do_self_rfsh_r1 [2]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [5];
            //cmd_do_self_rfsh_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [6];
            //cmd_do_self_rfsh_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [7];
            //cmd_do_self_rfsh_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [8];
            //cmd_do_self_rfsh_r1 [6]  = 1'b0;
            //cmd_do_self_rfsh_r1 [7]  = 1'b0;
            //cmd_do_self_rfsh_r1 [8]  = 1'b0;
        end
        else if (flush == 2'b11)
        begin
            can_read_current        = int_bus_can_read_reg [4];
            can_read [0]            = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_read_reg [5];
            can_read [1]            = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_read_reg [6];
            
            can_write_current       = int_bus_can_write_reg [4];
            can_write [0]           = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_write_reg [5];
            can_write [1]           = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_write_reg [6];
            
            // cmd do signal (registered version)
            cmd_do_activate_r1 [0]  = int_cmd_do_activate_r1 [4];
            cmd_do_activate_r1 [1]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [5];
            cmd_do_activate_r1 [2]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [6];
            cmd_do_activate_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [7];
            cmd_do_activate_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [8];
            cmd_do_activate_r1 [5]  = 1'b0;
            cmd_do_activate_r1 [6]  = 1'b0;
            cmd_do_activate_r1 [7]  = 1'b0;
            cmd_do_activate_r1 [8]  = 1'b0;
            
            cmd_do_precharge_r1 [0]  = int_cmd_do_precharge_r1 [4];
            cmd_do_precharge_r1 [1]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [5];
            cmd_do_precharge_r1 [2]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [6];
            cmd_do_precharge_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [7];
            cmd_do_precharge_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [8];
            cmd_do_precharge_r1 [5]  = 1'b0;
            cmd_do_precharge_r1 [6]  = 1'b0;
            cmd_do_precharge_r1 [7]  = 1'b0;
            cmd_do_precharge_r1 [8]  = 1'b0;
            
            cmd_do_write_r1 [0]      = int_cmd_do_write_r1 [4];
            cmd_do_write_r1 [1]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [5];
            cmd_do_write_r1 [2]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [6];
            cmd_do_write_r1 [3]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [7];
            cmd_do_write_r1 [4]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [8];
            cmd_do_write_r1 [5]      = 1'b0;
            cmd_do_write_r1 [6]      = 1'b0;
            cmd_do_write_r1 [7]      = 1'b0;
            cmd_do_write_r1 [8]      = 1'b0;
            
            cmd_do_read_r1 [0]       = int_cmd_do_read_r1 [4];
            cmd_do_read_r1 [1]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [5];
            cmd_do_read_r1 [2]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [6];
            cmd_do_read_r1 [3]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [7];
            cmd_do_read_r1 [4]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [8];
            cmd_do_read_r1 [5]       = 1'b0;
            cmd_do_read_r1 [6]       = 1'b0;
            cmd_do_read_r1 [7]       = 1'b0;
            cmd_do_read_r1 [8]       = 1'b0;
            
            //cmd_do_refresh_r1 [0]    = int_cmd_do_refresh_r1 [4];
            //cmd_do_refresh_r1 [1]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [5];
            //cmd_do_refresh_r1 [2]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [6];
            //cmd_do_refresh_r1 [3]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [7];
            //cmd_do_refresh_r1 [4]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [8];
            //cmd_do_refresh_r1 [5]    = 1'b0;
            //cmd_do_refresh_r1 [6]    = 1'b0;
            //cmd_do_refresh_r1 [7]    = 1'b0;
            //cmd_do_refresh_r1 [8]    = 1'b0;
            //
            //cmd_do_power_down_r1 [0] = int_cmd_do_power_down_r1 [4];
            //cmd_do_power_down_r1 [1] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [5];
            //cmd_do_power_down_r1 [2] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [6];
            //cmd_do_power_down_r1 [3] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [7];
            //cmd_do_power_down_r1 [4] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [8];
            //cmd_do_power_down_r1 [5] = 1'b0;
            //cmd_do_power_down_r1 [6] = 1'b0;
            //cmd_do_power_down_r1 [7] = 1'b0;
            //cmd_do_power_down_r1 [8] = 1'b0;
            //
            //cmd_do_self_rfsh_r1 [0]  = int_cmd_do_self_rfsh_r1 [4];
            //cmd_do_self_rfsh_r1 [1]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [5];
            //cmd_do_self_rfsh_r1 [2]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [6];
            //cmd_do_self_rfsh_r1 [3]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [7];
            //cmd_do_self_rfsh_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [8];
            //cmd_do_self_rfsh_r1 [5]  = 1'b0;
            //cmd_do_self_rfsh_r1 [6]  = 1'b0;
            //cmd_do_self_rfsh_r1 [7]  = 1'b0;
            //cmd_do_self_rfsh_r1 [8]  = 1'b0;
        end
        else
        begin
            can_read_current        = int_bus_can_read_reg [1];
            can_read [0]            = int_bus_can_read_reg [2];
            can_read [1]            = int_bus_can_read_reg [3];
            
            can_write_current       = int_bus_can_write_reg [1];
            can_write [0]           = int_bus_can_write_reg [2];
            can_write [1]           = int_bus_can_write_reg [3];
            
            // cmd do signal (registered version)
            cmd_do_activate_r1 [0]  = int_cmd_do_activate_r1 [1];
            cmd_do_activate_r1 [1]  = int_cmd_do_activate_r1 [2];
            cmd_do_activate_r1 [2]  = int_cmd_do_activate_r1 [3];
            cmd_do_activate_r1 [3]  = int_cmd_do_activate_r1 [4];
            cmd_do_activate_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [5];
            cmd_do_activate_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [6];
            cmd_do_activate_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [7];
            cmd_do_activate_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [8];
            cmd_do_activate_r1 [8]  = 1'b0;
            
            cmd_do_precharge_r1 [0]  = int_cmd_do_precharge_r1 [1];
            cmd_do_precharge_r1 [1]  = int_cmd_do_precharge_r1 [2];
            cmd_do_precharge_r1 [2]  = int_cmd_do_precharge_r1 [3];
            cmd_do_precharge_r1 [3]  = int_cmd_do_precharge_r1 [4];
            cmd_do_precharge_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [5];
            cmd_do_precharge_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [6];
            cmd_do_precharge_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [7];
            cmd_do_precharge_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [8];
            cmd_do_precharge_r1 [8]  = 1'b0;
            
            cmd_do_write_r1 [0]      = int_cmd_do_write_r1 [1];
            cmd_do_write_r1 [1]      = int_cmd_do_write_r1 [2];
            cmd_do_write_r1 [2]      = int_cmd_do_write_r1 [3];
            cmd_do_write_r1 [3]      = int_cmd_do_write_r1 [4];
            cmd_do_write_r1 [4]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [5];
            cmd_do_write_r1 [5]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [6];
            cmd_do_write_r1 [6]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [7];
            cmd_do_write_r1 [7]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [8];
            cmd_do_write_r1 [8]      = 1'b0;
            
            cmd_do_read_r1 [0]       = int_cmd_do_read_r1 [1];
            cmd_do_read_r1 [1]       = int_cmd_do_read_r1 [2];
            cmd_do_read_r1 [2]       = int_cmd_do_read_r1 [3];
            cmd_do_read_r1 [3]       = int_cmd_do_read_r1 [4];
            cmd_do_read_r1 [4]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [5];
            cmd_do_read_r1 [5]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [6];
            cmd_do_read_r1 [6]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [7];
            cmd_do_read_r1 [7]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [8];
            cmd_do_read_r1 [8]       = 1'b0;
            
            //cmd_do_refresh_r1 [0]    = int_cmd_do_refresh_r1 [1];
            //cmd_do_refresh_r1 [1]    = int_cmd_do_refresh_r1 [2];
            //cmd_do_refresh_r1 [2]    = int_cmd_do_refresh_r1 [3];
            //cmd_do_refresh_r1 [3]    = int_cmd_do_refresh_r1 [4];
            //cmd_do_refresh_r1 [4]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [5];
            //cmd_do_refresh_r1 [5]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [6];
            //cmd_do_refresh_r1 [6]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [7];
            //cmd_do_refresh_r1 [7]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [8];
            //cmd_do_refresh_r1 [8]    = 1'b0;
            //
            //cmd_do_power_down_r1 [0] = int_cmd_do_power_down_r1 [1];
            //cmd_do_power_down_r1 [1] = int_cmd_do_power_down_r1 [2];
            //cmd_do_power_down_r1 [2] = int_cmd_do_power_down_r1 [3];
            //cmd_do_power_down_r1 [3] = int_cmd_do_power_down_r1 [4];
            //cmd_do_power_down_r1 [4] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [5];
            //cmd_do_power_down_r1 [5] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [6];
            //cmd_do_power_down_r1 [6] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [7];
            //cmd_do_power_down_r1 [7] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [8];
            //cmd_do_power_down_r1 [8] = 1'b0;
            //
            //cmd_do_self_rfsh_r1 [0]  = int_cmd_do_self_rfsh_r1 [1];
            //cmd_do_self_rfsh_r1 [1]  = int_cmd_do_self_rfsh_r1 [2];
            //cmd_do_self_rfsh_r1 [2]  = int_cmd_do_self_rfsh_r1 [3];
            //cmd_do_self_rfsh_r1 [3]  = int_cmd_do_self_rfsh_r1 [4];
            //cmd_do_self_rfsh_r1 [4]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [5];
            //cmd_do_self_rfsh_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [6];
            //cmd_do_self_rfsh_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [7];
            //cmd_do_self_rfsh_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [8];
            //cmd_do_self_rfsh_r1 [8]  = 1'b0;
        end
    end
    else
    begin
        can_read_current        = int_bus_can_read_reg [0];
        can_read [0]            = int_bus_can_read_reg [1];
        can_read [1]            = int_bus_can_read_reg [2];
        
        can_write_current       = int_bus_can_write_reg [0];
        can_write [0]           = int_bus_can_write_reg [1];
        can_write [1]           = int_bus_can_write_reg [2];
        
        // cmd do signal (registered version)
        cmd_do_activate_r1 [0]  = int_cmd_do_activate_r1 [0];
        cmd_do_activate_r1 [1]  = int_cmd_do_activate_r1 [1];
        cmd_do_activate_r1 [2]  = int_cmd_do_activate_r1 [2];
        cmd_do_activate_r1 [3]  = int_cmd_do_activate_r1 [3];
        cmd_do_activate_r1 [4]  = int_cmd_do_activate_r1 [4];
        cmd_do_activate_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [5];
        cmd_do_activate_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_activate_r1 [6];
        cmd_do_activate_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [7];
        cmd_do_activate_r1 [8]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_activate_r1 [8];
        
        cmd_do_precharge_r1 [0]  = int_cmd_do_precharge_r1 [0];
        cmd_do_precharge_r1 [1]  = int_cmd_do_precharge_r1 [1];
        cmd_do_precharge_r1 [2]  = int_cmd_do_precharge_r1 [2];
        cmd_do_precharge_r1 [3]  = int_cmd_do_precharge_r1 [3];
        cmd_do_precharge_r1 [4]  = int_cmd_do_precharge_r1 [4];
        cmd_do_precharge_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [5];
        cmd_do_precharge_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_precharge_r1 [6];
        cmd_do_precharge_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [7];
        cmd_do_precharge_r1 [8]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_precharge_r1 [8];
        
        cmd_do_write_r1 [0]      = int_cmd_do_write_r1 [0];
        cmd_do_write_r1 [1]      = int_cmd_do_write_r1 [1];
        cmd_do_write_r1 [2]      = int_cmd_do_write_r1 [2];
        cmd_do_write_r1 [3]      = int_cmd_do_write_r1 [3];
        cmd_do_write_r1 [4]      = int_cmd_do_write_r1 [4];
        cmd_do_write_r1 [5]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [5];
        cmd_do_write_r1 [6]      = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_write_r1 [6];
        cmd_do_write_r1 [7]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [7];
        cmd_do_write_r1 [8]      = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_write_r1 [8];
        
        cmd_do_read_r1 [0]       = int_cmd_do_read_r1 [0];
        cmd_do_read_r1 [1]       = int_cmd_do_read_r1 [1];
        cmd_do_read_r1 [2]       = int_cmd_do_read_r1 [2];
        cmd_do_read_r1 [3]       = int_cmd_do_read_r1 [3];
        cmd_do_read_r1 [4]       = int_cmd_do_read_r1 [4];
        cmd_do_read_r1 [5]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [5];
        cmd_do_read_r1 [6]       = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_read_r1 [6];
        cmd_do_read_r1 [7]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [7];
        cmd_do_read_r1 [8]       = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_read_r1 [8];
        
        //cmd_do_refresh_r1 [0]    = int_cmd_do_refresh_r1 [0];
        //cmd_do_refresh_r1 [1]    = int_cmd_do_refresh_r1 [1];
        //cmd_do_refresh_r1 [2]    = int_cmd_do_refresh_r1 [2];
        //cmd_do_refresh_r1 [3]    = int_cmd_do_refresh_r1 [3];
        //cmd_do_refresh_r1 [4]    = int_cmd_do_refresh_r1 [4];
        //cmd_do_refresh_r1 [5]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [5];
        //cmd_do_refresh_r1 [6]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [6];
        //cmd_do_refresh_r1 [7]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [7];
        //cmd_do_refresh_r1 [8]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [8];
        //
        //cmd_do_power_down_r1 [0] = int_cmd_do_power_down_r1 [0];
        //cmd_do_power_down_r1 [1] = int_cmd_do_power_down_r1 [1];
        //cmd_do_power_down_r1 [2] = int_cmd_do_power_down_r1 [2];
        //cmd_do_power_down_r1 [3] = int_cmd_do_power_down_r1 [3];
        //cmd_do_power_down_r1 [4] = int_cmd_do_power_down_r1 [4];
        //cmd_do_power_down_r1 [5] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [5];
        //cmd_do_power_down_r1 [6] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [6];
        //cmd_do_power_down_r1 [7] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [7];
        //cmd_do_power_down_r1 [8] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [8];
        //
        //cmd_do_self_rfsh_r1 [0]  = int_cmd_do_self_rfsh_r1 [0];
        //cmd_do_self_rfsh_r1 [1]  = int_cmd_do_self_rfsh_r1 [1];
        //cmd_do_self_rfsh_r1 [2]  = int_cmd_do_self_rfsh_r1 [2];
        //cmd_do_self_rfsh_r1 [3]  = int_cmd_do_self_rfsh_r1 [3];
        //cmd_do_self_rfsh_r1 [4]  = int_cmd_do_self_rfsh_r1 [4];
        //cmd_do_self_rfsh_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [5];
        //cmd_do_self_rfsh_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [6];
        //cmd_do_self_rfsh_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [7];
        //cmd_do_self_rfsh_r1 [8]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [8];
    end
    
    // there is no need to cache these information
    // the fastest a fetch/flush could happen after do_refresh, power_down and self_rfsh
    // is one cycle after do command, which means cmd_cache two cycle after do command
    // we will only need these information during and one cycle after the do command
    cmd_do_refresh_r1 [0]    = int_cmd_do_refresh_r1 [0];
    cmd_do_refresh_r1 [1]    = int_cmd_do_refresh_r1 [1];
    cmd_do_refresh_r1 [2]    = int_cmd_do_refresh_r1 [2];
    cmd_do_refresh_r1 [3]    = int_cmd_do_refresh_r1 [3];
    cmd_do_refresh_r1 [4]    = int_cmd_do_refresh_r1 [4];
    cmd_do_refresh_r1 [5]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [5];
    cmd_do_refresh_r1 [6]    = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_refresh_r1 [6];
    cmd_do_refresh_r1 [7]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [7];
    cmd_do_refresh_r1 [8]    = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_refresh_r1 [8];
    
    cmd_do_power_down_r1 [0] = int_cmd_do_power_down_r1 [0];
    cmd_do_power_down_r1 [1] = int_cmd_do_power_down_r1 [1];
    cmd_do_power_down_r1 [2] = int_cmd_do_power_down_r1 [2];
    cmd_do_power_down_r1 [3] = int_cmd_do_power_down_r1 [3];
    cmd_do_power_down_r1 [4] = int_cmd_do_power_down_r1 [4];
    cmd_do_power_down_r1 [5] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [5];
    cmd_do_power_down_r1 [6] = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_power_down_r1 [6];
    cmd_do_power_down_r1 [7] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [7];
    cmd_do_power_down_r1 [8] = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_power_down_r1 [8];
    
    cmd_do_self_rfsh_r1 [0]  = int_cmd_do_self_rfsh_r1 [0];
    cmd_do_self_rfsh_r1 [1]  = int_cmd_do_self_rfsh_r1 [1];
    cmd_do_self_rfsh_r1 [2]  = int_cmd_do_self_rfsh_r1 [2];
    cmd_do_self_rfsh_r1 [3]  = int_cmd_do_self_rfsh_r1 [3];
    cmd_do_self_rfsh_r1 [4]  = int_cmd_do_self_rfsh_r1 [4];
    cmd_do_self_rfsh_r1 [5]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [5];
    cmd_do_self_rfsh_r1 [6]  = (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_cmd_do_self_rfsh_r1 [6];
    cmd_do_self_rfsh_r1 [7]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [7];
    cmd_do_self_rfsh_r1 [8]  = (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_cmd_do_self_rfsh_r1 [8];
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        can_precharge_current   <=  0;
        int_can_precharge       <=  0;
    end
    else if (fetch)
    begin
        if (flush1)
        begin
            can_activate_current    <= int_bus_can_activate_reg [2];
            int_can_activate [0]    <= int_bus_can_activate_reg [3];
            int_can_activate [1]    <= int_bus_can_activate_reg [4];
            int_can_activate [2]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [5];
            int_can_activate [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [6];
            int_can_activate [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [7];
            int_can_activate [5]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [8];
            int_can_activate [6]    <= 1'b0;
            int_can_activate [7]    <= 1'b0;
            
            can_precharge_current   <= int_bus_can_precharge_reg [2];
            int_can_precharge [0]   <= int_bus_can_precharge_reg [3];
            int_can_precharge [1]   <= int_bus_can_precharge_reg [4];
            int_can_precharge [2]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [5];
            int_can_precharge [3]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [6];
            int_can_precharge [4]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [7];
            int_can_precharge [5]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [8];
            int_can_precharge [6]   <= 1'b0;
            int_can_precharge [7]   <= 1'b0;
        end
        else if (flush2)
        begin
            can_activate_current    <= int_bus_can_activate_reg [3];
            int_can_activate [0]    <= int_bus_can_activate_reg [4];
            int_can_activate [1]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [5];
            int_can_activate [2]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [6];
            int_can_activate [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [7];
            int_can_activate [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [8];
            int_can_activate [5]    <= 1'b0;
            int_can_activate [6]    <= 1'b0;
            int_can_activate [7]    <= 1'b0;
            
            can_precharge_current   <= int_bus_can_precharge_reg [3];
            int_can_precharge [0]   <= int_bus_can_precharge_reg [4];
            int_can_precharge [1]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [5];
            int_can_precharge [2]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [6];
            int_can_precharge [3]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [7];
            int_can_precharge [4]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [8];
            int_can_precharge [5]   <= 1'b0;
            int_can_precharge [6]   <= 1'b0;
            int_can_precharge [7]   <= 1'b0;
        end
        else if (flush3)
        begin
            can_activate_current    <= int_bus_can_activate_reg [4];
            int_can_activate [0]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [5];
            int_can_activate [1]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [6];
            int_can_activate [2]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [7];
            int_can_activate [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [8];
            int_can_activate [4]    <= 1'b0;
            int_can_activate [5]    <= 1'b0;
            int_can_activate [6]    <= 1'b0;
            int_can_activate [7]    <= 1'b0;
            
            can_precharge_current   <= int_bus_can_precharge_reg [4];
            int_can_precharge [0]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [5];
            int_can_precharge [1]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [6];
            int_can_precharge [2]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [7];
            int_can_precharge [3]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [8];
            int_can_precharge [4]   <= 1'b0;
            int_can_precharge [5]   <= 1'b0;
            int_can_precharge [6]   <= 1'b0;
            int_can_precharge [7]   <= 1'b0;
        end
        else
        begin
            can_activate_current    <= int_bus_can_activate_reg [1];
            int_can_activate [0]    <= int_bus_can_activate_reg [2];
            int_can_activate [1]    <= int_bus_can_activate_reg [3];
            int_can_activate [2]    <= int_bus_can_activate_reg [4];
            int_can_activate [3]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [5];
            int_can_activate [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [6];
            int_can_activate [5]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [7];
            int_can_activate [6]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [8];
            int_can_activate [7]    <= 1'b0;
            
            can_precharge_current   <= int_bus_can_precharge_reg [1];
            int_can_precharge [0]   <= int_bus_can_precharge_reg [2];
            int_can_precharge [1]   <= int_bus_can_precharge_reg [3];
            int_can_precharge [2]   <= int_bus_can_precharge_reg [4];
            int_can_precharge [3]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [5];
            int_can_precharge [4]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [6];
            int_can_precharge [5]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [7];
            int_can_precharge [6]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [8];
            int_can_precharge [7]   <= 1'b0;
        end
    end
    else
    begin
        can_activate_current    <= int_bus_can_activate_reg [0];
        int_can_activate [0]    <= int_bus_can_activate_reg [1];
        int_can_activate [1]    <= int_bus_can_activate_reg [2];
        int_can_activate [2]    <= int_bus_can_activate_reg [3];
        int_can_activate [3]    <= int_bus_can_activate_reg [4];
        int_can_activate [4]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [5];
        int_can_activate [5]    <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_activate_reg [6];
        int_can_activate [6]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [7];
        int_can_activate [7]    <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_activate_reg [8];
        
        can_precharge_current   <= int_bus_can_precharge_reg [0];
        int_can_precharge [0]   <= int_bus_can_precharge_reg [1];
        int_can_precharge [1]   <= int_bus_can_precharge_reg [2];
        int_can_precharge [2]   <= int_bus_can_precharge_reg [3];
        int_can_precharge [3]   <= int_bus_can_precharge_reg [4];
        int_can_precharge [4]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [5];
        int_can_precharge [5]   <= (CTL_LOOK_AHEAD_DEPTH <= 4) ? 1'b0 : int_bus_can_precharge_reg [6];
        int_can_precharge [6]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [7];
        int_can_precharge [7]   <= (CTL_LOOK_AHEAD_DEPTH <= 6) ? 1'b0 : int_bus_can_precharge_reg [8];
    end
end

// Determine the flush value
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        flush <= 2'b00;
    end
    else if (fetch)
    begin
        if (flush1)
            flush <= 2'b01;
        else if (flush2)
            flush <= 2'b10;
        else if (flush3)
            flush <= 2'b11;
        else
            flush <= 2'b00;
    end
    else
    begin
        // the following case is to prevent caching the wrong data during flush with no fetch state
        // eg: when there is flush1 with no fetch, we should only move the data by one command instead of 2
        if (flush1)
            flush <= 2'b00;
        else if (flush2)
            flush <= 2'b01;
        else if (flush3)
            flush <= 2'b01;
        else
            flush <= 2'b00;
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        ecc_fetch_error_addr_r1 <= 1'b0;
        fetch_r1                <= 1'b0;
    end
    else
    begin
        ecc_fetch_error_addr_r1 <= ecc_fetch_error_addr;
        fetch_r1                <= fetch;
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        cmd_cache <= 1'b0;
    end
    else
    begin
        if (fetch || flush1 || flush2 || flush3)
            cmd_cache <= 1'b1;
        else
            cmd_cache <= 1'b0;
    end
end

// cmd valid signal to mask off can signals
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        int_cmd_is_valid_r1 <= 1'b0;
    end
    else
    begin
        int_cmd_is_valid_r1 <= int_cmd_is_valid [0];
    end
end

always @ (*)
begin
    int_cmd_is_valid [CTL_CMD_QUEUE_DEPTH : 1] = cmd_is_valid [CTL_CMD_QUEUE_DEPTH : 1];
    
    if (fetch)
        int_cmd_is_valid [0] = 1'b0;
    else if (fetch_r1)
        int_cmd_is_valid [0] = 1'b1;
    else if (ecc_fetch_error_addr)
        int_cmd_is_valid [0] = 1'b0;
    else if (ecc_fetch_error_addr_r1)
        int_cmd_is_valid [0] = 1'b1;
    else
        int_cmd_is_valid [0] = int_cmd_is_valid_r1;
end
/*------------------------------------------------------------------------------
    Can registers
------------------------------------------------------------------------------*/
// We will modify can signal at the input side of the register instead of the output side
// because this will increase fmax performance
// Previously the value in modified in the output of bank specific state machine, it is better to have x * number of lookahead
// compared to y * number of total banks of logics although x is slightly larger than y
generate
    genvar y;
    genvar y_inner;
    for (y = 0;y < CTL_LOOK_AHEAD_DEPTH + 1;y = y + 1)
    begin : output_signal_fanout_per_cmd
        wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(y + 1) * MEM_IF_BA_WIDTH  - 1 : y * MEM_IF_BA_WIDTH];
        wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = cmd_chip_addr [(y + 1) * MEM_IF_CHIP_BITS - 1 : y * MEM_IF_CHIP_BITS];
        
        // multicast signals
        wire [MEM_IF_CS_WIDTH - 1 : 0] multicast_write_per_chip;
        wire [MEM_IF_CS_WIDTH - 1 : 0] multicast_activate_per_chip;
        wire [MEM_IF_CS_WIDTH - 1 : 0] multicast_precharge_per_chip;
        wire [MEM_IF_CS_WIDTH - 1 : 0] multicast_activate_chip_per_chip;
        
        wire can_multicast_write         = &multicast_write_per_chip;
        wire can_multicast_activate      = &multicast_activate_per_chip;
        wire can_multicast_precharge     = &multicast_precharge_per_chip;
        wire can_multicast_activate_chip = &multicast_activate_chip_per_chip;
        
        for (y_inner = 0;y_inner < MEM_IF_CS_WIDTH;y_inner = y_inner + 1)
        begin : multicast_signal_per_chip
            wire [MEM_IF_CHIP_BITS - 1 : 0] chip_addr = y_inner;
            wire [MEM_IF_BA_WIDTH  - 1 : 0] bank_addr = cmd_bank_addr [(y + 1) * MEM_IF_BA_WIDTH - 1 : y * MEM_IF_BA_WIDTH];
            
            assign multicast_write_per_chip         [y_inner] = bus_can_write         [chip_addr][bank_addr];
            assign multicast_activate_per_chip      [y_inner] = bus_can_activate      [chip_addr][bank_addr];
            assign multicast_precharge_per_chip     [y_inner] = bus_can_precharge     [chip_addr][bank_addr];
            assign multicast_activate_chip_per_chip [y_inner] = bus_can_activate_chip [chip_addr][0];
        end
        
        always @ (*)
        begin
            int_bus_can_activate_reg  [y] = bus_can_activate_reg  [y];
            int_bus_can_precharge_reg [y] = bus_can_precharge_reg [y];
            int_bus_can_read_reg      [y] = bus_can_read_reg      [y];
            int_bus_can_write_reg     [y] = bus_can_write_reg     [y];
        end
        
        // can read
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                bus_can_read_reg [y] <= 1'b0;
            else
            begin
                if (cmd_do_activate [y] && more_than_4_bank_active) // if we want to optimize activate to read/write, we should use additive latency
                    bus_can_read_reg [y] <= 1'b0;
                else if (cmd_do_activate_r1 [y] && more_than_5_bank_active)
                    bus_can_read_reg [y] <= 1'b0;
                else if (cmd_do_precharge [y] || cmd_do_precharge_r1 [y])
                    bus_can_read_reg [y] <= 1'b0;
                else if (do_read && more_than_4_rd_to_rd)                   // use do_read because read/write is monitored based on dqs bus usage (will ignore bank address)
                    bus_can_read_reg [y] <= 1'b0;
                else if (!chip_change && do_write && more_than_4_wr_to_rd)  // use do_write because read/write is monitored based on dqs bus usage (will ignore bank address)
                    bus_can_read_reg [y] <= 1'b0;
                //else if (chip_change && do_write && less_than_3_wr_to_rd_diff_chips)  // we can assert can read when there is a write to read different ranks
                //    bus_can_read_reg [y] <= 1'b1 & write_to_read_finish_twtr [chip_addr] & read_dqs_ready & int_cmd_is_valid [y];
                else if ((cmd_do_activate [y] || cmd_do_activate_r1 [y]) && less_than_2_bank_active) // to increase tRCD efficiency
                    bus_can_read_reg [y] <= 1'b1 & write_to_read_finish_twtr [chip_addr] & read_dqs_ready & int_cmd_is_valid [y];
                else
                    // write_to_read_finish_twtr signal is used to make sure previous write actually finish
                    // tWTR before allowing current read to proceed to avoid timing violation
                    // see DQS bus monitor for more information
                    bus_can_read_reg [y] <= bus_can_read [chip_addr][bank_addr] & write_to_read_finish_twtr [chip_addr] & read_dqs_ready & int_cmd_is_valid [y];
            end
        end
        
        // can write
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                bus_can_write_reg [y] <= 1'b0;
            else
            begin
                if (cmd_do_activate [y] && more_than_4_bank_active)  // if we want to optimize activate to read/write, we should use additive latency
                    bus_can_write_reg [y] <= 1'b0;
                else if (cmd_do_activate_r1 [y] && more_than_5_bank_active)
                    bus_can_write_reg [y] <= 1'b0;
                else if (cmd_do_precharge [y] || cmd_do_precharge_r1 [y])
                    bus_can_write_reg [y] <= 1'b0;
                else if (do_read)                                   // use do_read because read/write is monitored based on dqs bus usage (will ignore bank address)
                begin
                    if (do_burst_chop && more_than_4_rd_to_wr_bc)
                        bus_can_write_reg [y] <= 1'b0;
                    else if (!do_burst_chop && more_than_4_rd_to_wr)
                        bus_can_write_reg [y] <= 1'b0;
                end
                else if (do_write && more_than_4_wr_to_wr)          // use do_write because read/write is monitored based on dqs bus usage (will ignore bank address)
                    bus_can_write_reg [y] <= 1'b0;
                else if ((cmd_do_activate [y] || cmd_do_activate_r1 [y]) && less_than_2_bank_active) // to increase tRCD efficiency
                    bus_can_write_reg [y] <= 1'b1 & write_dqs_ready & int_cmd_is_valid [y];
                else
                begin
                    if (cmd_multicast_req [y]) // when cmd is multicast
                        bus_can_write_reg [y] <= can_multicast_write                  & write_dqs_ready & int_cmd_is_valid [y];
                    else
                        bus_can_write_reg [y] <= bus_can_write [chip_addr][bank_addr] & write_dqs_ready & int_cmd_is_valid [y];
                end
            end
        end
        
        // can activate
        always @ (*)
        begin
            ///if (!ctl_reset_n)
            ///    bus_can_activate_reg [y] <= 1'b0;
            ///else
            begin
                if (cmd_do_activate [y] || cmd_do_activate_r1 [y])
                    bus_can_activate_reg [y] <= 1'b0;
                else if (do_activate && to_chip [chip_addr] && more_than_3_act_to_act_diff_bank)    // we do not allow back-to-back activates
                    bus_can_activate_reg [y] <= 1'b0;
                else if (do_activate && cmd_multicast_req [y] && more_than_3_act_to_act_diff_bank)  // we do not allow back-to-back activates
                                                                                                    // this is to cover multicast cases, when there is a non-multicast activate
                                                                                                    // to a multicast activate, we don't need to check for to_chip
                    bus_can_activate_reg [y] <= 1'b0;
                else if (cmd_do_precharge [y] && more_than_3_pch_to_act)
                    bus_can_activate_reg [y] <= 1'b0;
                else if (cmd_do_precharge_r1 [y] && more_than_4_pch_to_act)
                    bus_can_activate_reg [y] <= 1'b0;
                //else if ((do_refresh && to_chip [chip_addr]) || (do_refresh_r1 && to_chip_r1 [chip_addr]))
                //    bus_can_activate_reg [y] <= 1'b0;
                //else if ((do_power_down && to_chip [chip_addr]) || (do_power_down_r1 && to_chip_r1 [chip_addr]))
                //    bus_can_activate_reg [y] <= 1'b0;
                //else if ((do_self_rfsh && to_chip [chip_addr]) || (do_self_rfsh_r1 && to_chip_r1 [chip_addr]))
                //    bus_can_activate_reg [y] <= 1'b0;
                else if (cmd_do_refresh [y] || cmd_do_refresh_r1 [y])
                    bus_can_activate_reg [y] <= 1'b0;
                else if (cmd_do_power_down [y] || cmd_do_power_down_r1 [y])
                    bus_can_activate_reg [y] <= 1'b0;
                else if (cmd_do_self_rfsh [y] || cmd_do_self_rfsh_r1 [y])
                    bus_can_activate_reg [y] <= 1'b0;
                else
                begin
                    if (cmd_multicast_req [y]) // when cmd is multicast
                        // during multicast command, we shouldn't check for chip specific information
                        // all information should be "AND-ed" and checked
                        bus_can_activate_reg [y] <= can_multicast_activate                  & can_multicast_activate_chip          & (&act_diff_bank)          & (&act_valid_window)          & int_cmd_is_valid [y];
                    else
                        bus_can_activate_reg [y] <= bus_can_activate [chip_addr][bank_addr] & bus_can_activate_chip [chip_addr][0] & act_diff_bank [chip_addr] & act_valid_window [chip_addr] & int_cmd_is_valid [y];
                end
            end
        end
        
        // can precharge
        always @ (*)
        begin
            ///if (!ctl_reset_n)
            ///    bus_can_precharge_reg [y] <= 1'b0;
            ///else
            begin
                if (cmd_do_activate [y] || cmd_do_activate_r1 [y])        // will impact activate to precharge efficiency, most probably during refreshes and power down
                    bus_can_precharge_reg [y] <= 1'b0;
                else if (cmd_do_precharge [y] || cmd_do_precharge_r1 [y]) // we do not wish controller to do back-to-back precharge, this might impact precharge to precharge all efficiency as well
                    bus_can_precharge_reg [y] <= 1'b0;
                else if (cmd_do_read [y] && more_than_3_rd_to_pch)
                    bus_can_precharge_reg [y] <= 1'b0;
                else if (cmd_do_read_r1 [y] && more_than_4_rd_to_pch)
                    bus_can_precharge_reg [y] <= 1'b0;
                else if (cmd_do_write [y] && more_than_3_wr_to_pch)
                    bus_can_precharge_reg [y] <= 1'b0;
                else if (cmd_do_write_r1 [y] && more_than_4_wr_to_pch)
                    bus_can_precharge_reg [y] <= 1'b0;
                else
                begin
                    if (cmd_multicast_req [y]) // when cmd is multicast
                        // during multicast request, we will need to make sure if there was a self refresh command
                        // to another chip, we will need to de-assert can_precharge as well to prevent self refresh exit violation
                        bus_can_precharge_reg [y] <= can_multicast_precharge                  & can_multicast_activate_chip & int_cmd_is_valid [y];
                    else
                        bus_can_precharge_reg [y] <= bus_can_precharge [chip_addr][bank_addr] & int_cmd_is_valid [y];
                end
            end
        end
    end
endgenerate

// register to_chip
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        to_chip_r1 <= 0;
    end
    else
    begin
        to_chip_r1 <= to_chip;
    end
end

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
        if (do_read && more_than_4_rd_to_wr)
            can_al_activate_write <= 1'b0;
        else
            can_al_activate_write <= write_dqs_ready;
        
        if (do_write && more_than_4_wr_to_rd)
            can_al_activate_read <= 1'b0;
        else
            can_al_activate_read <= read_dqs_ready & write_to_read_finish_twtr [cmd_chip_addr [MEM_IF_CHIP_BITS - 1 : 0]];
    end
end

generate
    genvar v;
    for (v = 0;v < MEM_IF_CS_WIDTH;v = v + 1)
    begin : output_signal_fanout_per_chip
        // 2 version for halfrate and fullrate
        always @ (*)
        begin
            non_delay_can_exit_power_saving_mode [v] = int_can_exit_power_saving_mode    [v];
            delay_can_exit_power_saving_mode     [v] = int_can_exit_power_saving_mode_r1 [v];
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_can_exit_power_saving_mode_r1  [v] <= 1'b0;
            else
                int_can_exit_power_saving_mode_r1  [v] <= int_can_exit_power_saving_mode [v];
        end
        
        // can precharge all
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                can_precharge_all [v] <= 1'b0;
            end
            else
            begin
                if (do_activate && to_chip [v]) // there is no need to check for timing because tRAS is a large value
                    can_precharge_all [v] <= 1'b0;
                else if (do_activate_r1 && to_chip_r1 [v]) // there is no need to check for timing because tRAS is a large value
                    can_precharge_all [v] <= 1'b0;
                else if ((do_precharge || do_precharge_all) && to_chip [v])
                    can_precharge_all [v] <= 1'b0;
                else if ((do_precharge_r1 || do_precharge_all_r1) && to_chip_r1 [v])
                    can_precharge_all [v] <= 1'b0;
                else if (do_read && to_chip [v] && more_than_3_rd_to_pch)
                    can_precharge_all [v] <= 1'b0;
                else if (do_read_r1 && to_chip_r1 [v] && more_than_3_rd_to_pch)
                    can_precharge_all [v] <= 1'b0;
                else if (do_write && to_chip [v] && more_than_3_wr_to_pch)
                    can_precharge_all [v] <= 1'b0;
                else if (do_write_r1 && to_chip_r1 [v] && more_than_3_wr_to_pch)
                    can_precharge_all [v] <= 1'b0;
                else
                    can_precharge_all [v] <= &bus_can_precharge [v][2 ** MEM_IF_BA_WIDTH - 1 : 0];
            end
        end
        
        // can auto refresh
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_can_refresh [v] <= 1'b0;
            else
            begin
                if ((do_precharge || do_precharge_all) && to_chip [v]) 
                begin
                    if (more_than_3_pch_to_act && MEM_TYPE != "DDR2")
                        int_can_refresh [v] <= 1'b0;
                    else if (more_than_2_pch_to_act && MEM_TYPE == "DDR2") // check for more than 2 when mem type is DDR2 because of tRPA = tRP + 1
                        int_can_refresh [v] <= 1'b0;
                    else
                        int_can_refresh [v] <= bus_can_refresh [v][0] & enable_chip_request & enable_chip_request_trc_done [v] & enable_chip_request_ddr2;
                end
                else if ((do_precharge_r1 || do_precharge_all_r1) && to_chip_r1 [v]) 
                begin
                    if (more_than_4_pch_to_act && MEM_TYPE != "DDR2")
                        int_can_refresh [v] <= 1'b0;
                    else if (more_than_3_pch_to_act && MEM_TYPE == "DDR2") // check for more than 3 when mem type is DDR2 because of tRPA = tRP + 1
                        int_can_refresh [v] <= 1'b0;
                    else
                        int_can_refresh [v] <= bus_can_refresh [v][0] & enable_chip_request & enable_chip_request_trc_done [v] & enable_chip_request_ddr2;
                end
                else if (do_read || do_read_r1 || do_write || do_write_r1)
                    int_can_refresh [v] <= 1'b0;
                else if (do_power_down) // this will cause some in-efficiency
                    int_can_refresh [v] <= 1'b0;
                else if ((do_refresh && to_chip [v]) || (do_refresh_r1 && to_chip_r1 [v])) // this is required to avoid back to back refreshes to the similar chip
                    int_can_refresh [v] <= 1'b0;
                else
                    int_can_refresh [v] <= bus_can_refresh [v][0] & enable_chip_request & enable_chip_request_trc_done [v] & enable_chip_request_ddr2;
            end
        end
        
        // can enter power down
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_can_enter_power_down [v] <= 1'b0;
            else
            begin
                if ((do_precharge || do_precharge_all) && to_chip [v]) // we can go into power down right after a precharge all
                    int_can_enter_power_down [v] <= 1'b1 & enable_chip_request;
                else if (do_read || do_read_r1 || do_write || do_write_r1)
                    int_can_enter_power_down [v] <= 1'b0;
                else
                    int_can_enter_power_down [v] <= bus_can_power_down [v][0] & enable_chip_request & enable_chip_request_trc_done [v] & enable_chip_request_ddr2;
            end
        end
        
        // can self refresh
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_can_self_rfsh [v] <= 1'b0;
            else
            begin
                if ((do_precharge || do_precharge_all) && to_chip [v] && more_than_3_pch_to_act)
                    int_can_self_rfsh [v] <= 1'b0;
                else if ((do_precharge_r1 || do_precharge_all_r1) && to_chip_r1 [v] && more_than_4_pch_to_act)
                    int_can_self_rfsh [v] <= 1'b0;
                else if (do_refresh && to_chip [v] && more_than_3_arf_to_valid)
                    int_can_self_rfsh [v] <= 1'b0;
                else if (do_refresh_r1 && to_chip_r1 [v] && more_than_4_arf_to_valid)
                    int_can_self_rfsh [v] <= 1'b0;
                else if (do_power_down && to_chip [v])          // do not allow self refresh entry after and power down, required at least 3 clock cycles
                    int_can_self_rfsh [v] <= 1'b0;
                else if (do_power_down_r1 && to_chip_r1 [v])    // do not allow self refresh entry after and power down, required at least 3 clock cycles
                    int_can_self_rfsh [v] <= 1'b0;
                else if (do_read || do_read_r1 || do_write || do_write_r1)
                    int_can_self_rfsh [v] <= 1'b0;
                else
                    int_can_self_rfsh [v] <= bus_can_self_rfsh [v][0] & enable_chip_request & enable_chip_request_trc_done [v] & enable_chip_request_ddr2;
            end
        end
        
        // can exit power saving mode, power down, self refresh needs at least 3 memory clock cycles before exiting
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_can_exit_power_saving_mode [v] <= 1'b0;
            end
            else
            begin
                if (do_power_down && !do_power_down_r1) // positive edge detector
                    int_can_exit_power_saving_mode [v] <= 1'b1;
                else if (!do_power_down && do_power_down_r1) // negative edge detector
                    int_can_exit_power_saving_mode [v] <= 1'b0;
                else if (do_self_rfsh && !do_self_rfsh_r1) // positive edge detector
                    int_can_exit_power_saving_mode [v] <= 1'b1;
                else if (!do_self_rfsh && do_self_rfsh_r1) // positive edge detector
                    int_can_exit_power_saving_mode [v] <= 1'b0;
            end
        end
        
        // can lmr
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_can_lmr [v] <= 1'b0;
            else
            begin
                if ((do_precharge || do_precharge_all) && to_chip [v] && more_than_3_pch_to_act)
                    int_can_lmr [v] <= 1'b0;
                else if (do_read || do_write)
                    int_can_lmr [v] <= 1'b0;
                else
                    int_can_lmr [v] <= bus_can_lmr [v][0] & enable_chip_request;
            end
        end
        
        // zq calibration request
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_zq_cal_req [v] <= 1'b0;
            end
            else
            begin
                int_zq_cal_req [v] <= bus_zq_cal_req [v][0];
            end
        end
    end
endgenerate

generate
    if (MEM_TYPE == "DDR2")
    begin
        reg [PCH_TO_ACT_WIDTH - 1 : 0] pch_all_cnt;
        
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                pch_all_cnt <= 0;
            end
            else
            begin
                if (do_precharge_all)
                    pch_all_cnt <= 4;
                else if (pch_all_cnt != {PCH_TO_ACT_WIDTH{1'b1}})
                    pch_all_cnt <= pch_all_cnt + 1'b1;
            end
        end
        
        // specific for DDR2 only, tRPA precharge all timing value which is tRP + 1
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                enable_chip_request_ddr2 <= 1'b0;
            end
            else
            begin
                if (do_precharge_all && more_than_4_pch_all_to_act)
                    enable_chip_request_ddr2 <= 1'b0;
                else if (pch_all_cnt >= pch_all_to_act)
                    enable_chip_request_ddr2 <= 1'b1;
                else
                    enable_chip_request_ddr2 <= 1'b0;
            end
        end
    end
    else
    begin
        // set to always high when mem type is not DDR2
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                enable_chip_request_ddr2 <= 1'b1;
            else
                enable_chip_request_ddr2 <= 1'b1;
        end
    end
endgenerate

always @ (*)
begin
    can_refresh          = int_can_refresh;
    can_enter_power_down = int_can_enter_power_down;
    can_self_rfsh        = int_can_self_rfsh;
end

// in halfrate, we only delay exit power down by 2 cycle because it is equal to 4 memory clocks
generate
    if (DWIDTH_RATIO == 2) // fullrate
    begin
        always @ (*)
        begin
            can_exit_power_saving_mode = delay_can_exit_power_saving_mode;
        end
    end
    else if (DWIDTH_RATIO == 4) // halfrate
    begin
        always @ (*)
        begin
            can_exit_power_saving_mode = non_delay_can_exit_power_saving_mode;
        end
    end
endgenerate

// keep track of read/write
// we will need to keep track of auto precharge as well to avoid violating tRAS
// this will cause in-efficiency in every power down entry when there was a read/write
// with auto_precharge command
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        doing_write    <= 1'b0;
        doing_read     <= 1'b0;
    end
    else
    begin
        if (do_write)
        begin
            doing_write <= 1'b1;
            doing_read  <= 1'b0;
        end
        else if (do_read)
        begin
            doing_write <= 1'b0;
            doing_read  <= 1'b1;
        end
    end
end

// counter used to track clock cycle count after read/write request
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        chip_request_cnt <= 0;
    end
    else
    begin
        if (do_read || do_write)
            chip_request_cnt <= 4;
        else if (chip_request_cnt != {FINISH_WRITE_WIDTH{1'b1}})
            chip_request_cnt <= chip_request_cnt + 1'b1;
    end
end

// this signal will de-assert can self refresh/refresh/power down and lmr signal so that it will wait will read/write finish
// this should be per chip basis but currently we are only monitoring read/write on global basis
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        enable_chip_request <= 1'b0;
    end
    else
    begin
        if (do_read || do_write) // de-assert right after read/write
            enable_chip_request <= 1'b0;
        else if (doing_write && chip_request_cnt > finish_write)
            enable_chip_request <= 1'b1;
        else if (doing_read && chip_request_cnt > finish_read)
            enable_chip_request <= 1'b1;
        else if (chip_request_cnt > finish_write) // default state and finish_write should be larger than finish_read
            enable_chip_request <= 1'b1;
        else
            enable_chip_request <= 1'b0;
    end
end

// require tRC counter to monito each activate to make sure
// internal precharge during auto precharge read/write are finished
// before enabling can refresh, power down or self refresh
// see logic below for more information (enable_chip_request_auto_pch_done)
generate
    genvar d;
    for (d = 0;d < MEM_IF_CS_WIDTH;d = d + 1)
    begin : trc_cnt_per_chip
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                trc_cnt [d] <= 0;
            end
            else
            begin
                if (do_activate && to_chip [d])
                    trc_cnt [d] <= 5;
                else if (trc_cnt [d] != {ACT_TO_ACT_WIDTH{1'b1}})
                    trc_cnt [d] <= trc_cnt [d] + 1'b1;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                doing_auto_pch [d] <= 1'b0;
            end
            else
            begin
                if (to_chip [d])
                begin
                    if (do_write)
                    begin
                        if (do_auto_precharge)
                            doing_auto_pch [d] <= 1'b1;
                        else
                            doing_auto_pch [d] <= 1'b0;
                    end
                    else if (do_read)
                    begin
                        if (do_auto_precharge)
                            doing_auto_pch [d] <= 1'b1;
                        else
                            doing_auto_pch [d] <= 1'b0;
                    end
                end
            end
        end
        
        // this signal is required to monitor read/write with auto precharge to power down, refresh entry
        // we will need to wait till internal precharge is done before asserting can_power_down
        // this signal must be used with enable_chip_request, because this signal is a simplified version
        // of enable_chip_request
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                enable_chip_request_trc_done [d] <= 1'b0;
            end
            else
            begin
                if (doing_auto_pch [d]) // we will only de-assert this signal when there is auto precharge
                begin
                    if (trc_cnt [d] > act_to_act) // must be larger than tRC
                        enable_chip_request_trc_done [d] <= 1'b1;
                    else
                        enable_chip_request_trc_done [d] <= 1'b0;
                end
                else
                    enable_chip_request_trc_done [d] <= 1'b1;
            end
        end
    end
endgenerate

/*------------------------------------------------------------------------------

   Self Refresh Request

------------------------------------------------------------------------------*/
// zq calibration request
generate
    if (MEM_TYPE == "DDR3")
    begin
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                zq_cal_req <= 1'b0;
            end
            else
            begin
                zq_cal_req <= |int_zq_cal_req;
            end
        end
    end
    else // set to zero when memory type is not DDR3
    begin
        wire zero = 1'b0;
        
        always @ (*)
        begin
            zq_cal_req <= zero;
        end
    end
endgenerate

/*------------------------------------------------------------------------------

   Auto Refresh Request

------------------------------------------------------------------------------*/
generate
    genvar c;
    if (!CTL_USR_REFRESH)
    begin
        for (c = 0; c < MEM_IF_CS_WIDTH; c = c + 1)
        begin : auto_refresh_logic_per_chip
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    auto_refresh_cnt[c] <= 0;
                end
                else
                begin
                    if (do_refresh & to_chip[c])
                        auto_refresh_cnt[c] <= 3;
                    else if (auto_refresh_cnt[c] != {ARF_COUNTER_WIDTH{1'b1}})
                        auto_refresh_cnt[c] <= auto_refresh_cnt[c] + 1'b1;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    auto_refresh_chip[c] <= 1'b0;
                end
                else
                begin
                    if (do_refresh & to_chip[c])
                        auto_refresh_chip[c] <= 1'b0;
                    else if (auto_refresh_cnt[c] >= arf_period)
                        auto_refresh_chip[c] <= 1'b1;
                    else
                        auto_refresh_chip[c] <= 1'b0;
                end
            end
            
        end
        
        assign auto_refresh_req = |auto_refresh_chip;
    end
    else
    begin
        assign auto_refresh_req = 0;
    end
endgenerate



/*------------------------------------------------------------------------------

   Power Down Request

------------------------------------------------------------------------------*/
// only start power down request after init done
always @ (*)
begin
    if (local_init_done)
        no_command = cmd_fifo_empty;
    else
        no_command = 1'b0;
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        no_command_r1 <= 1'b0;
    end
    else
    begin
        no_command_r1 <= no_command;
    end
end

// do_power_down register
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        do_power_down_r1 <= 0;
    end
    else
    begin
        do_power_down_r1 <= do_power_down;
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        power_down_cnt <= 0;
    end
    else
    begin
        if (!no_command && no_command_r1)
            power_down_cnt <= 3;
        else if (no_command && power_down_cnt != {PDN_COUNTER_WIDTH{1'b1}})
            power_down_cnt <= power_down_cnt + 1'b1;
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        power_down_req <= 1'b0;
    end
    else
    begin
        if (pdn_period == 0) // when auto power down cycles is set to '0', auto power down mode will be disabled
            power_down_req <= 1'b0;
        else
        begin
            if (!cmd_fifo_empty) // we need to make sure power down request to go low as fast as possible to avoid unnecessary power down
                power_down_req <= 1'b0;
            else if (power_down_cnt >= pdn_period)
                power_down_req <= 1'b1;
            else
                power_down_req <= 1'b0;
        end
    end
end


/*------------------------------------------------------------------------------

    ACT Command Monitor

------------------------------------------------------------------------------*/
generate
    genvar t;
    for (t = 0;t < MEM_IF_CS_WIDTH;t = t + 1)
    begin : act_command_monitor
        reg [2 : 0] act_command_cnt;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] act_cnt;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] act_cnt_valid;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] diff_count_r1;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] diff_count_r2;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] diff_count_r3;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] diff_sum_2;
        reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] diff_sum_3;
        reg do_act_reg;
        reg int_act_valid_window;
        
        if (MEM_TYPE == "DDR") // there is no tFAW in DDR
        begin
            wire one = 1'b1;
            
            always @ (*)
            begin
                act_valid_window [t] = one;
            end
        end
        else
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_cnt_valid <= 0;
                end
                else
                begin
                    if (do_activate && to_chip [t])
                        act_cnt_valid <= 1;
                    else if (act_cnt_valid != {ACTIVATE_COUNTER_WIDTH{1'b1}})
                        act_cnt_valid <= act_cnt_valid + 1'b1;
                end
            end
            
            // tFAW, four ACT valid window
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_command_cnt <= 0;
                end
                else
                begin
                    if (act_cnt_valid >= four_act_to_act)
                    begin
                        if (do_activate)
                            act_command_cnt <= 1;
                        else
                            act_command_cnt <= 0;
                    end
                    else if (do_activate && act_command_cnt != 3'b100)
                        act_command_cnt <= act_command_cnt + 1'b1;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    diff_count_r1 <= 0;
                    diff_count_r2 <= 0;
                    diff_count_r3 <= 0;
                    diff_sum_2    <= 0;
                    diff_sum_3    <= 0;
                end
                else
                begin
                    diff_sum_2 <= diff_count_r1 + diff_count_r2 + act_cnt_valid;
                    diff_sum_3 <= diff_count_r1 + diff_count_r2 + diff_count_r3 + act_cnt_valid;
                    
                    if (do_activate && to_chip [t])
                    begin
                        diff_count_r1 <= act_cnt_valid;
                        diff_count_r2 <= diff_count_r1;
                        diff_count_r3 <= diff_count_r2;
                    end
                end
            end
            
            // monitor activate for tFAW
            always @ (*)
            begin
                if (do_activate && to_chip [t] && (act_command_cnt == 3 || act_command_cnt == 4)) // during 3th or 4th activate
                    if (diff_sum_2 <= four_act_to_act)
                        act_valid_window [t] = 1'b0;
                    else
                        act_valid_window [t] = int_act_valid_window;
                else
                    act_valid_window [t] = int_act_valid_window;
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_act_valid_window <= 1'b1;
                    do_act_reg           <= 1'b0;
                end
                else
                begin
                    if (((do_activate && to_chip [t]) || do_act_reg) && (act_command_cnt == 3 || act_command_cnt == 4)) // during 4th activate and one clock cycle later
                    begin
                        if (do_act_reg)
                            do_act_reg <= 1'b0;
                        else
                            do_act_reg <= 1'b1;
                        
                        if (diff_sum_2 < four_act_to_act)
                            int_act_valid_window <= 1'b0;
                        else
                            int_act_valid_window <= 1'b1;
                    end
                    else if (act_command_cnt == 4)
                    begin
                        if (diff_sum_3 < four_act_to_act)
                            int_act_valid_window <= 1'b0;
                        else
                            int_act_valid_window <= 1'b1;
                    end
                    else
                        int_act_valid_window <= 1'b1;
                end
            end
        end
        
        // ACT counter
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                act_cnt <= 0;
            end
            else
            begin
                if (do_activate && to_chip [t])
                    act_cnt <= 4;
                else if (act_cnt != {ACTIVATE_COUNTER_WIDTH{1'b1}})
                    act_cnt <= act_cnt + 1'b1;
            end
        end
        
        // tRRD, ACT to ACT diff banks
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                act_diff_bank [t] <= 1'b0;
            end
            else
            begin
                if (do_activate && to_chip [t])
                begin
                    if (more_than_4_act_to_act_diff_bank)
                        act_diff_bank [t] <= 1'b0;
                    else
                        act_diff_bank [t] <= 1'b1;
                end
                else if (act_cnt >= act_to_act_diff_bank)
                    act_diff_bank [t] <= 1'b1;
                else
                    act_diff_bank [t] <= 1'b0;
            end
        end
    end
endgenerate

/*------------------------------------------------------------------------------

    Read / Write Command Monitor

------------------------------------------------------------------------------*/
// store current chip address into previous chip address for comparison later
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
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
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        prev_multicast_req <= 1'b0;
    end
    else
    begin
        if (fetch)
            prev_multicast_req <= current_multicast_req;
    end
end

// compare current chip addr wirt prev chip addr
// during the following case, do not assert chip change:
// - wr with multicast to read with multicast
// - wr with multicast to read with no multicast
// - wr with no multicast to read with multicast
always @ (*)
begin
    if (!fetch && prev_chip_addr != current_chip_addr && !(prev_multicast_req || current_multicast_req))
        chip_change = 1'b1;
    else if (fetch && current_chip_addr != cmd0_chip_addr && !(current_multicast_req || cmd0_multicast_req))
        chip_change = 1'b1;
    else
        chip_change = 1'b0;
end

// general counter for dqs bus monitor
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        cnt <= 0;
    end
    else
    begin
        if (do_write || do_read)
            cnt <= 5;
        else if (cnt != {RD_WR_COUNTER_WIDTH{1'b1}})
            cnt <= cnt + 1'b1;
    end
end

// write to read, tWTR monitor
generate
    genvar m;
    for (m = 0;m < MEM_IF_CS_WIDTH;m = m + 1)
    begin: tWTR_counter_per_chip
        // tWTR counter
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                twtr_cnt [m] <= 0;
            end
            else
            begin
                if (do_write && to_chip [m])
                    twtr_cnt [m] <= 5;
                else if (twtr_cnt [m] != {WR_TO_RD_WIDTH{1'b1}})
                    twtr_cnt [m] <= twtr_cnt [m] + 1'b1;
            end
        end
        
        // this signal will indicate previous write to a particular chip has met tWTR
        // this will be used in can_read logic
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                write_to_read_finish_twtr [m] <= 1'b0;
            end
            else
            begin
                if (twtr_cnt [m] >= wr_to_rd)
                    write_to_read_finish_twtr [m] <= 1'b1;
                else
                    write_to_read_finish_twtr [m] <= 1'b0;
            end
        end
    end
endgenerate

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        doing_burst_chop <= 1'b0;
    end
    else
    begin
        if (do_read || do_write)
        begin
            if (do_burst_chop)
                doing_burst_chop <= 1'b1;
            else
                doing_burst_chop <= 1'b0;
        end
    end
end

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        state <= IDLE;
        read_dqs_ready  <= 1'b0;
        write_dqs_ready <= 1'b0;
    end
    else
    begin
        case (state)
            IDLE :
                begin
                    if (do_write)
                    begin
                        state <= WR;
                        
                        if (less_than_4_wr_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (less_than_4_wr_to_wr)
                            write_dqs_ready <= 1'b1;
                        else
                            write_dqs_ready <= 1'b0;
                    end
                    else if (do_read)
                    begin
                        state <= RD;
                        
                        if (less_than_4_rd_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (!do_burst_chop)
                        begin
                            if (less_than_4_rd_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else // BC4 OTF
                        begin
                            if (less_than_4_rd_to_wr_bc)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                    end
                    else
                    begin
                        state <= IDLE;
                        read_dqs_ready  <= 1'b1;
                        write_dqs_ready <= 1'b1;
                    end
                end
            WR :
                begin
                    if (do_write)
                    begin
                        state <= WR;
                        
                        if (chip_change && less_than_4_wr_to_rd_diff_chips)
                            read_dqs_ready  <= 1'b1;
                        else if (less_than_4_wr_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (less_than_4_wr_to_wr)
                            write_dqs_ready <= 1'b1;
                        else
                            write_dqs_ready <= 1'b0;
                    end
                    else if (do_read)
                    begin
                        state <= RD;
                        
                        if (less_than_4_rd_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (!do_burst_chop)
                        begin
                            if (less_than_4_rd_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else // BC4 OTF
                        begin
                            if (less_than_4_rd_to_wr_bc)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                    end
                    else
                    begin
                        // if there will be a wr to rd to different chipselects
                        // we will maximize the efficiency by not checking for twtr
                        if (chip_change)
                        begin
                            if (cnt >= wr_to_rd_diff_chips)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                        end
                        else
                        begin
                            if (cnt >= wr_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                        end
                        
                        if (cnt >= wr_to_wr)
                            write_dqs_ready <= 1'b1;
                        else
                            write_dqs_ready <= 1'b0;
                    end
                end
            RD :
                begin
                    if (do_write)
                    begin
                        state <= WR;
                        
                        if (chip_change && less_than_4_wr_to_rd_diff_chips)
                            read_dqs_ready  <= 1'b1;
                        else if (less_than_4_wr_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (less_than_4_wr_to_wr)
                            write_dqs_ready <= 1'b1;
                        else
                            write_dqs_ready <= 1'b0;
                    end
                    else if (do_read)
                    begin
                        state <= RD;
                        
                        if (less_than_4_rd_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (!do_burst_chop)
                        begin
                            if (less_than_4_rd_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else // BC4 OTF
                        begin
                            if (less_than_4_rd_to_wr_bc)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (cnt >= rd_to_rd)
                            read_dqs_ready  <= 1'b1;
                        else
                            read_dqs_ready  <= 1'b0;
                        
                        if (!doing_burst_chop)
                        begin
                            if (cnt >= rd_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else
                        begin
                            if (cnt >= rd_to_wr_bc)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                    end
                end
            default :
                state <= IDLE;
        endcase
    end
end

/*------------------------------------------------------------------------------

    Banks Specific Process

------------------------------------------------------------------------------*/
generate
    genvar x_outer;
    genvar x_inner;
    for (x_outer = 0;x_outer < MEM_IF_CS_WIDTH; x_outer = x_outer + 1)
    begin : bank_specific_state_machine_per_chip
        for (x_inner = 0;x_inner < 2 ** MEM_IF_BA_WIDTH; x_inner = x_inner + 1)
        begin : bank_specific_state_machine_per_bank
            alt_ddrx_timers_fsm #
            (
                .BANK_ACTIVATE_WIDTH             (BANK_ACTIVATE_WIDTH                      ),
                .ACT_TO_PCH_WIDTH                (ACT_TO_PCH_WIDTH                         ),
                .ACT_TO_ACT_WIDTH                (ACT_TO_ACT_WIDTH                         ),
                .RD_TO_RD_WIDTH                  (RD_TO_RD_WIDTH                           ),
                .RD_TO_WR_WIDTH                  (RD_TO_WR_WIDTH                           ),
                .RD_TO_PCH_WIDTH                 (RD_TO_PCH_WIDTH                          ),
                .WR_TO_WR_WIDTH                  (WR_TO_WR_WIDTH                           ),
                .WR_TO_RD_WIDTH                  (WR_TO_RD_WIDTH                           ),
                .WR_TO_PCH_WIDTH                 (WR_TO_PCH_WIDTH                          ),
                .PCH_TO_ACT_WIDTH                (PCH_TO_ACT_WIDTH                         ),
                .RD_AP_TO_ACT_WIDTH              (RD_AP_TO_ACT_WIDTH                       ),
                .WR_AP_TO_ACT_WIDTH              (WR_AP_TO_ACT_WIDTH                       ),
                .ARF_TO_VALID_WIDTH              (ARF_TO_VALID_WIDTH                       ),
                .PDN_TO_VALID_WIDTH              (PDN_TO_VALID_WIDTH                       ),
                .SRF_TO_VALID_WIDTH              (SRF_TO_VALID_WIDTH                       ),
                .LMR_TO_LMR_WIDTH                (LMR_TO_LMR_WIDTH                         ),
                .LMR_TO_VALID_WIDTH              (LMR_TO_VALID_WIDTH                       )
            )
            fsm_inst
            (
                // inputs
                .ctl_clk                         (ctl_clk                                  ),
                .ctl_reset_n                     (ctl_reset_n                              ),
                
                .do_write                        (do_write_r1                              ),
                .do_read                         (do_read_r1                               ),
                .do_activate                     (do_activate_r1                           ),
                .do_precharge                    (do_precharge_r1                          ),
                .do_auto_precharge               (do_auto_precharge_r1                     ),
                .do_precharge_all                (bus_do_precharge_all   [x_outer][x_inner]),
                .do_refresh                      (bus_do_refresh         [x_outer][x_inner]),
                .do_power_down                   (bus_do_power_down      [x_outer][x_inner]),
                .do_self_rfsh                    (bus_do_self_rfsh       [x_outer][x_inner]),
                .do_lmr                          (bus_do_lmr             [x_outer][x_inner]),
                
                .do_enable                       (do_enable              [x_outer][x_inner]),
                
                // timing parameters
                .bank_active                     (bank_active                             ),
                .act_to_pch                      (act_to_pch                              ),
                .act_to_act                      (act_to_act                              ),
                .rd_to_rd                        (rd_to_rd                                ),
                .rd_to_wr                        (rd_to_wr                                ),
                .rd_to_pch                       (rd_to_pch                               ),
                .wr_to_wr                        (wr_to_wr                                ),
                .wr_to_rd                        (wr_to_rd                                ),
                .wr_to_pch                       (wr_to_pch                               ),
                .wr_to_rd_to_pch_all             (wr_to_rd_to_pch_all                     ),
                .pch_to_act                      (pch_to_act                              ),
                .rd_ap_to_act                    (rd_ap_to_act                            ),
                .wr_ap_to_act                    (wr_ap_to_act                            ),
                .arf_to_valid                    (arf_to_valid                            ),
                .pdn_to_valid                    (pdn_to_valid                            ),
                .srf_to_valid                    (srf_to_valid                            ),
                .srf_to_zq                       (srf_to_zq                               ),
                .lmr_to_lmr                      (lmr_to_lmr                              ),
                .lmr_to_valid                    (lmr_to_valid                            ),
                
                .less_than_2_bank_active         (less_than_2_bank_active                 ),
                .less_than_2_act_to_pch          (less_than_2_act_to_pch                  ),
                .less_than_2_act_to_act          (less_than_2_act_to_act                  ),
                .less_than_2_rd_to_rd            (less_than_2_rd_to_rd                    ),
                .less_than_2_rd_to_wr            (less_than_2_rd_to_wr                    ),
                .less_than_2_rd_to_pch           (less_than_2_rd_to_pch                   ),
                .less_than_2_wr_to_wr            (less_than_2_wr_to_wr                    ),
                .less_than_2_wr_to_rd            (less_than_2_wr_to_rd                    ),
                .less_than_2_wr_to_pch           (less_than_2_wr_to_pch                   ),
                .less_than_2_pch_to_act          (less_than_2_pch_to_act                  ),
                .less_than_2_rd_ap_to_act        (less_than_2_rd_ap_to_act                ),
                .less_than_2_wr_ap_to_act        (less_than_2_wr_ap_to_act                ),
                .less_than_2_arf_to_valid        (less_than_2_arf_to_valid                ),
                .less_than_2_pdn_to_valid        (less_than_2_pdn_to_valid                ),
                .less_than_2_srf_to_valid        (less_than_2_srf_to_valid                ),
                .less_than_2_lmr_to_lmr          (less_than_2_lmr_to_lmr                  ),
                .less_than_2_lmr_to_valid        (less_than_2_lmr_to_valid                ),
                
                .less_than_3_bank_active         (less_than_3_bank_active                 ),
                .less_than_3_act_to_pch          (less_than_3_act_to_pch                  ),
                .less_than_3_act_to_act          (less_than_3_act_to_act                  ),
                .less_than_3_rd_to_rd            (less_than_3_rd_to_rd                    ),
                .less_than_3_rd_to_wr            (less_than_3_rd_to_wr                    ),
                .less_than_3_rd_to_pch           (less_than_3_rd_to_pch                   ),
                .less_than_3_wr_to_wr            (less_than_3_wr_to_wr                    ),
                .less_than_3_wr_to_rd            (less_than_3_wr_to_rd                    ),
                .less_than_3_wr_to_pch           (less_than_3_wr_to_pch                   ),
                .less_than_3_wr_to_rd_to_pch_all (less_than_3_wr_to_rd_to_pch_all         ),
                .less_than_3_pch_to_act          (less_than_3_pch_to_act                  ),
                .less_than_3_rd_ap_to_act        (less_than_3_rd_ap_to_act                ),
                .less_than_3_wr_ap_to_act        (less_than_3_wr_ap_to_act                ),
                .less_than_3_arf_to_valid        (less_than_3_arf_to_valid                ),
                .less_than_3_pdn_to_valid        (less_than_3_pdn_to_valid                ),
                .less_than_3_srf_to_valid        (less_than_3_srf_to_valid                ),
                .less_than_3_lmr_to_lmr          (less_than_3_lmr_to_lmr                  ),
                .less_than_3_lmr_to_valid        (less_than_3_lmr_to_valid                ),
                
                .less_than_4_bank_active         (less_than_4_bank_active                 ),
                .less_than_4_act_to_pch          (less_than_4_act_to_pch                  ),
                .less_than_4_act_to_act          (less_than_4_act_to_act                  ),
                .less_than_4_rd_to_rd            (less_than_4_rd_to_rd                    ),
                .less_than_4_rd_to_wr            (less_than_4_rd_to_wr                    ),
                .less_than_4_rd_to_pch           (less_than_4_rd_to_pch                   ),
                .less_than_4_wr_to_wr            (less_than_4_wr_to_wr                    ),
                .less_than_4_wr_to_rd            (less_than_4_wr_to_rd                    ),
                .less_than_4_wr_to_pch           (less_than_4_wr_to_pch                   ),
                .less_than_4_wr_to_rd_to_pch_all (less_than_4_wr_to_rd_to_pch_all         ),
                .less_than_4_pch_to_act          (less_than_4_pch_to_act                  ),
                .less_than_4_rd_ap_to_act        (less_than_4_rd_ap_to_act                ),
                .less_than_4_wr_ap_to_act        (less_than_4_wr_ap_to_act                ),
                .less_than_4_arf_to_valid        (less_than_4_arf_to_valid                ),
                .less_than_4_pdn_to_valid        (less_than_4_pdn_to_valid                ),
                .less_than_4_srf_to_valid        (less_than_4_srf_to_valid                ),
                .less_than_4_lmr_to_lmr          (less_than_4_lmr_to_lmr                  ),
                .less_than_4_lmr_to_valid        (less_than_4_lmr_to_valid                ),
                
                .more_than_2_bank_active         (more_than_2_bank_active                 ),
                .more_than_2_act_to_pch          (more_than_2_act_to_pch                  ),
                .more_than_2_act_to_act          (more_than_2_act_to_act                  ),
                .more_than_2_rd_to_rd            (more_than_2_rd_to_rd                    ),
                .more_than_2_rd_to_wr            (more_than_2_rd_to_wr                    ),
                .more_than_2_rd_to_pch           (more_than_2_rd_to_pch                   ),
                .more_than_2_wr_to_wr            (more_than_2_wr_to_wr                    ),
                .more_than_2_wr_to_rd            (more_than_2_wr_to_rd                    ),
                .more_than_2_wr_to_pch           (more_than_2_wr_to_pch                   ),
                .more_than_2_pch_to_act          (more_than_2_pch_to_act                  ),
                .more_than_2_rd_ap_to_act        (more_than_2_rd_ap_to_act                ),
                .more_than_2_wr_ap_to_act        (more_than_2_wr_ap_to_act                ),
                .more_than_2_arf_to_valid        (more_than_2_arf_to_valid                ),
                .more_than_2_pdn_to_valid        (more_than_2_pdn_to_valid                ),
                .more_than_2_srf_to_valid        (more_than_2_srf_to_valid                ),
                .more_than_2_lmr_to_lmr          (more_than_2_lmr_to_lmr                  ),
                .more_than_2_lmr_to_valid        (more_than_2_lmr_to_valid                ),
                
                .more_than_3_bank_active         (more_than_3_bank_active                 ),
                .more_than_3_act_to_pch          (more_than_3_act_to_pch                  ),
                .more_than_3_act_to_act          (more_than_3_act_to_act                  ),
                .more_than_3_rd_to_rd            (more_than_3_rd_to_rd                    ),
                .more_than_3_rd_to_wr            (more_than_3_rd_to_wr                    ),
                .more_than_3_rd_to_pch           (more_than_3_rd_to_pch                   ),
                .more_than_3_wr_to_wr            (more_than_3_wr_to_wr                    ),
                .more_than_3_wr_to_rd            (more_than_3_wr_to_rd                    ),
                .more_than_3_wr_to_pch           (more_than_3_wr_to_pch                   ),
                .more_than_3_pch_to_act          (more_than_3_pch_to_act                  ),
                .more_than_3_rd_ap_to_act        (more_than_3_rd_ap_to_act                ),
                .more_than_3_wr_ap_to_act        (more_than_3_wr_ap_to_act                ),
                .more_than_3_arf_to_valid        (more_than_3_arf_to_valid                ),
                .more_than_3_pdn_to_valid        (more_than_3_pdn_to_valid                ),
                .more_than_3_srf_to_valid        (more_than_3_srf_to_valid                ),
                .more_than_3_lmr_to_lmr          (more_than_3_lmr_to_lmr                  ),
                .more_than_3_lmr_to_valid        (more_than_3_lmr_to_valid                ),
                
                .more_than_5_pch_to_act          (more_than_5_pch_to_act                  ),
                
                .compare_wr_to_rd_to_pch_all     (compare_wr_to_rd_to_pch_all             ),
                
                // outputs
                .int_can_activate                (bus_can_activate      [x_outer][x_inner]),
                .int_can_activate_chip           (bus_can_activate_chip [x_outer][x_inner]),
                .int_can_precharge               (bus_can_precharge     [x_outer][x_inner]),
                .int_can_read                    (bus_can_read          [x_outer][x_inner]),
                .int_can_write                   (bus_can_write         [x_outer][x_inner]),
                .int_can_refresh                 (bus_can_refresh       [x_outer][x_inner]),
                .int_can_power_down              (bus_can_power_down    [x_outer][x_inner]),
                .int_can_self_rfsh               (bus_can_self_rfsh     [x_outer][x_inner]),
                .int_can_lmr                     (bus_can_lmr           [x_outer][x_inner]),
                .int_zq_cal_req                  (bus_zq_cal_req        [x_outer][x_inner])
            );
        end
    end
endgenerate
endmodule







