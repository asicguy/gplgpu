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
// File          : alt_ddrx_timing_param.v
//
// Abstract      : 
///////////////////////////////////////////////////////////////////////////////

module alt_ddrx_timing_param #
    ( parameter
        MEM_IF_RD_TO_WR_TURNAROUND_OCT            = 0,
        MEM_IF_WR_TO_RD_TURNAROUND_OCT            = 0,
        MEM_IF_WR_TO_RD_DIFF_CHIPS_TURNAROUND_OCT = 0,
        
        MEM_TYPE                                  = "DDR3",
        
        DWIDTH_RATIO                              = 2,              // 2 - fullrate, 4 - halfrate
        MEMORY_BURSTLENGTH                        = 8,
        
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
        AUTO_PD_BUS_WIDTH                         = 16,             // same as CSR
        
        BURST_LENGTH_BUS_WIDTH                    = 4,
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
        ctl_clk,
        ctl_reset_n,
        
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
        
        // timing value outputs
        mem_burst_length,
        mem_self_rfsh_exit_cycles,
        mem_rd_to_wr_turnaround_oct,
        mem_wr_to_rd_turnaround_oct,
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
        
        // timing value comparison outputs
        more_than_2_act_to_rdwr,
        more_than_2_act_to_pch,
        more_than_2_act_to_act,
        more_than_2_rd_to_rd,
        more_than_2_rd_to_wr,
        more_than_2_rd_to_wr_bc,
        more_than_2_rd_to_pch,
        more_than_2_wr_to_wr,
        more_than_2_wr_to_rd,
        more_than_2_wr_to_pch,
        more_than_2_rd_ap_to_act,
        more_than_2_wr_ap_to_act,
        more_than_2_pch_to_act,
        more_than_2_act_to_act_diff_bank,
        more_than_2_four_act_to_act,
        less_than_2_act_to_rdwr,
        less_than_2_act_to_pch,
        less_than_2_act_to_act,
        less_than_2_rd_to_rd,
        less_than_2_rd_to_wr,
        less_than_2_rd_to_wr_bc,
        less_than_2_rd_to_pch,
        less_than_2_wr_to_wr,
        less_than_2_wr_to_rd,
        less_than_2_wr_to_rd_diff_chips,
        less_than_2_wr_to_pch,
        less_than_2_rd_ap_to_act,
        less_than_2_wr_ap_to_act,
        less_than_2_pch_to_act,
        less_than_2_act_to_act_diff_bank,
        less_than_2_four_act_to_act,
        more_than_3_act_to_rdwr,
        more_than_3_act_to_pch,
        more_than_3_act_to_act,
        more_than_3_rd_to_rd,
        more_than_3_rd_to_wr,
        more_than_3_rd_to_wr_bc,
        more_than_3_rd_to_pch,
        more_than_3_wr_to_wr,
        more_than_3_wr_to_rd,
        more_than_3_wr_to_pch,
        more_than_3_rd_ap_to_act,
        more_than_3_wr_ap_to_act,
        more_than_3_pch_to_act,
        more_than_3_act_to_act_diff_bank,
        more_than_3_four_act_to_act,
        less_than_3_act_to_rdwr,
        less_than_3_act_to_pch,
        less_than_3_act_to_act,
        less_than_3_rd_to_rd,
        less_than_3_rd_to_wr,
        less_than_3_rd_to_wr_bc,
        less_than_3_rd_to_pch,
        less_than_3_wr_to_wr,
        less_than_3_wr_to_rd,
        less_than_3_wr_to_rd_diff_chips,
        less_than_3_wr_to_pch,
        less_than_3_rd_ap_to_act,
        less_than_3_wr_ap_to_act,
        less_than_3_pch_to_act,
        less_than_3_act_to_act_diff_bank,
        less_than_3_four_act_to_act,
        more_than_4_act_to_rdwr,
        more_than_4_act_to_pch,
        more_than_4_act_to_act,
        more_than_4_rd_to_rd,
        more_than_4_rd_to_wr,
        more_than_4_rd_to_wr_bc,
        more_than_4_rd_to_pch,
        more_than_4_wr_to_wr,
        more_than_4_wr_to_rd,
        more_than_4_wr_to_pch,
        more_than_4_rd_ap_to_act,
        more_than_4_wr_ap_to_act,
        more_than_4_pch_to_act,
        more_than_4_act_to_act_diff_bank,
        more_than_4_four_act_to_act,
        less_than_4_act_to_rdwr,
        less_than_4_act_to_pch,
        less_than_4_act_to_act,
        less_than_4_rd_to_rd,
        less_than_4_rd_to_wr,
        less_than_4_rd_to_wr_bc,
        less_than_4_rd_to_pch,
        less_than_4_wr_to_wr,
        less_than_4_wr_to_rd,
        less_than_4_wr_to_rd_diff_chips,
        less_than_4_wr_to_pch,
        less_than_4_rd_ap_to_act,
        less_than_4_wr_ap_to_act,
        less_than_4_pch_to_act,
        less_than_4_act_to_act_diff_bank,
        less_than_4_four_act_to_act,
        more_than_5_act_to_rdwr,
        more_than_5_act_to_pch,
        more_than_5_act_to_act,
        more_than_5_rd_to_rd,
        more_than_5_rd_to_wr,
        more_than_5_rd_to_wr_bc,
        more_than_5_rd_to_pch,
        more_than_5_wr_to_wr,
        more_than_5_wr_to_rd,
        more_than_5_wr_to_pch,
        more_than_5_rd_ap_to_act,
        more_than_5_wr_ap_to_act,
        more_than_5_pch_to_act,
        more_than_5_act_to_act_diff_bank,
        more_than_5_four_act_to_act,
        less_than_5_act_to_rdwr,
        less_than_5_act_to_pch,
        less_than_5_act_to_act,
        less_than_5_rd_to_rd,
        less_than_5_rd_to_wr,
        less_than_5_rd_to_wr_bc,
        less_than_5_rd_to_pch,
        less_than_5_wr_to_wr,
        less_than_5_wr_to_rd,
        less_than_5_wr_to_rd_diff_chips,
        less_than_5_wr_to_pch,
        less_than_5_rd_ap_to_act,
        less_than_5_wr_ap_to_act,
        less_than_5_pch_to_act,
        less_than_5_act_to_act_diff_bank,
        less_than_5_four_act_to_act,
        
        add_lat_on
    );

input  ctl_clk;
input  ctl_reset_n;

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

// timing value outputs
output [BURST_LENGTH_BUS_WIDTH          - 1 : 0] mem_burst_length;
output [SELF_RFSH_EXIT_CYCLES_BUS_WIDTH - 1 : 0] mem_self_rfsh_exit_cycles;
output [RD_TO_WR_WIDTH                  - 1 : 0] mem_rd_to_wr_turnaround_oct;
output [WR_TO_RD_WIDTH                  - 1 : 0] mem_wr_to_rd_turnaround_oct;
output [ACT_TO_RDWR_WIDTH               - 1 : 0] act_to_rdwr;
output [ACT_TO_PCH_WIDTH                - 1 : 0] act_to_pch;
output [ACT_TO_ACT_WIDTH                - 1 : 0] act_to_act;
output [RD_TO_RD_WIDTH                  - 1 : 0] rd_to_rd;
output [RD_TO_WR_WIDTH                  - 1 : 0] rd_to_wr;
output [RD_TO_WR_BC_WIDTH               - 1 : 0] rd_to_wr_bc;
output [RD_TO_PCH_WIDTH                 - 1 : 0] rd_to_pch;
output [WR_TO_WR_WIDTH                  - 1 : 0] wr_to_wr;
output [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd;
output [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd_diff_chips;
output [WR_TO_PCH_WIDTH                 - 1 : 0] wr_to_pch;
output [RD_AP_TO_ACT_WIDTH              - 1 : 0] rd_ap_to_act;
output [WR_AP_TO_ACT_WIDTH              - 1 : 0] wr_ap_to_act;
output [PCH_TO_ACT_WIDTH                - 1 : 0] pch_to_act;
output [PCH_ALL_TO_VALID_WIDTH          - 1 : 0] pch_all_to_valid;
output [ARF_TO_VALID_WIDTH              - 1 : 0] arf_to_valid;
output [PDN_TO_VALID_WIDTH              - 1 : 0] pdn_to_valid;
output [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_valid;
output [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_zq;
output [ARF_PERIOD_WIDTH                - 1 : 0] arf_period;
output [PDN_PERIOD_WIDTH                - 1 : 0] pdn_period;
output [ACT_TO_ACT_DIFF_BANK_WIDTH      - 1 : 0] act_to_act_diff_bank;
output [FOUR_ACT_TO_ACT_WIDTH           - 1 : 0] four_act_to_act;

// timing value comparison outputs
output more_than_2_act_to_rdwr;
output more_than_2_act_to_pch;
output more_than_2_act_to_act;
output more_than_2_rd_to_rd;
output more_than_2_rd_to_wr;
output more_than_2_rd_to_wr_bc;
output more_than_2_rd_to_pch;
output more_than_2_wr_to_wr;
output more_than_2_wr_to_rd;
output more_than_2_wr_to_pch;
output more_than_2_rd_ap_to_act;
output more_than_2_wr_ap_to_act;
output more_than_2_pch_to_act;
output more_than_2_act_to_act_diff_bank;
output more_than_2_four_act_to_act;
output less_than_2_act_to_rdwr;
output less_than_2_act_to_pch;
output less_than_2_act_to_act;
output less_than_2_rd_to_rd;
output less_than_2_rd_to_wr;
output less_than_2_rd_to_wr_bc;
output less_than_2_rd_to_pch;
output less_than_2_wr_to_wr;
output less_than_2_wr_to_rd;
output less_than_2_wr_to_rd_diff_chips;
output less_than_2_wr_to_pch;
output less_than_2_rd_ap_to_act;
output less_than_2_wr_ap_to_act;
output less_than_2_pch_to_act;
output less_than_2_act_to_act_diff_bank;
output less_than_2_four_act_to_act;
output more_than_3_act_to_rdwr;
output more_than_3_act_to_pch;
output more_than_3_act_to_act;
output more_than_3_rd_to_rd;
output more_than_3_rd_to_wr;
output more_than_3_rd_to_wr_bc;
output more_than_3_rd_to_pch;
output more_than_3_wr_to_wr;
output more_than_3_wr_to_rd;
output more_than_3_wr_to_pch;
output more_than_3_rd_ap_to_act;
output more_than_3_wr_ap_to_act;
output more_than_3_pch_to_act;
output more_than_3_act_to_act_diff_bank;
output more_than_3_four_act_to_act;
output less_than_3_act_to_rdwr;
output less_than_3_act_to_pch;
output less_than_3_act_to_act;
output less_than_3_rd_to_rd;
output less_than_3_rd_to_wr;
output less_than_3_rd_to_wr_bc;
output less_than_3_rd_to_pch;
output less_than_3_wr_to_wr;
output less_than_3_wr_to_rd;
output less_than_3_wr_to_rd_diff_chips;
output less_than_3_wr_to_pch;
output less_than_3_rd_ap_to_act;
output less_than_3_wr_ap_to_act;
output less_than_3_pch_to_act;
output less_than_3_act_to_act_diff_bank;
output less_than_3_four_act_to_act;
output more_than_4_act_to_rdwr;
output more_than_4_act_to_pch;
output more_than_4_act_to_act;
output more_than_4_rd_to_rd;
output more_than_4_rd_to_wr;
output more_than_4_rd_to_wr_bc;
output more_than_4_rd_to_pch;
output more_than_4_wr_to_wr;
output more_than_4_wr_to_rd;
output more_than_4_wr_to_pch;
output more_than_4_rd_ap_to_act;
output more_than_4_wr_ap_to_act;
output more_than_4_pch_to_act;
output more_than_4_act_to_act_diff_bank;
output more_than_4_four_act_to_act;
output less_than_4_act_to_rdwr;
output less_than_4_act_to_pch;
output less_than_4_act_to_act;
output less_than_4_rd_to_rd;
output less_than_4_rd_to_wr;
output less_than_4_rd_to_wr_bc;
output less_than_4_rd_to_pch;
output less_than_4_wr_to_wr;
output less_than_4_wr_to_rd;
output less_than_4_wr_to_rd_diff_chips;
output less_than_4_wr_to_pch;
output less_than_4_rd_ap_to_act;
output less_than_4_wr_ap_to_act;
output less_than_4_pch_to_act;
output less_than_4_act_to_act_diff_bank;
output less_than_4_four_act_to_act;
output more_than_5_act_to_rdwr;
output more_than_5_act_to_pch;
output more_than_5_act_to_act;
output more_than_5_rd_to_rd;
output more_than_5_rd_to_wr;
output more_than_5_rd_to_wr_bc;
output more_than_5_rd_to_pch;
output more_than_5_wr_to_wr;
output more_than_5_wr_to_rd;
output more_than_5_wr_to_pch;
output more_than_5_rd_ap_to_act;
output more_than_5_wr_ap_to_act;
output more_than_5_pch_to_act;
output more_than_5_act_to_act_diff_bank;
output more_than_5_four_act_to_act;
output less_than_5_act_to_rdwr;
output less_than_5_act_to_pch;
output less_than_5_act_to_act;
output less_than_5_rd_to_rd;
output less_than_5_rd_to_wr;
output less_than_5_rd_to_wr_bc;
output less_than_5_rd_to_pch;
output less_than_5_wr_to_wr;
output less_than_5_wr_to_rd;
output less_than_5_wr_to_rd_diff_chips;
output less_than_5_wr_to_pch;
output less_than_5_rd_ap_to_act;
output less_than_5_wr_ap_to_act;
output less_than_5_pch_to_act;
output less_than_5_act_to_act_diff_bank;
output less_than_5_four_act_to_act;

output add_lat_on;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Timing Parameters

------------------------------------------------------------------------------*/
    wire [BURST_LENGTH_BUS_WIDTH          - 1 : 0] mem_burst_length                       = MEMORY_BURSTLENGTH;
    wire [SELF_RFSH_EXIT_CYCLES_BUS_WIDTH - 1 : 0] mem_self_rfsh_exit_cycles              = (MEM_TYPE == "DDR3") ? 520 : 210; // added extra cycles
    
    wire [RD_TO_WR_WIDTH                  - 1 : 0] mem_rd_to_wr_turnaround_oct            = MEM_IF_RD_TO_WR_TURNAROUND_OCT;
    wire [WR_TO_RD_WIDTH                  - 1 : 0] mem_wr_to_rd_turnaround_oct            = MEM_IF_WR_TO_RD_TURNAROUND_OCT;
    wire [WR_TO_RD_WIDTH                  - 1 : 0] mem_wr_to_rd_diff_chips_turnaround_oct = MEM_IF_WR_TO_RD_DIFF_CHIPS_TURNAROUND_OCT;
    
    // activate
    reg [ACT_TO_RDWR_WIDTH                - 1 : 0] act_to_rdwr;
    reg [ACT_TO_PCH_WIDTH                 - 1 : 0] act_to_pch;
    reg [ACT_TO_ACT_WIDTH                 - 1 : 0] act_to_act;
    
    // read
    reg [RD_TO_RD_WIDTH                   - 1 : 0] rd_to_rd;
    reg [RD_TO_WR_WIDTH                   - 1 : 0] rd_to_wr;
    reg [RD_TO_WR_BC_WIDTH                - 1 : 0] rd_to_wr_bc;           // Burst chop support, only affects DDR3 RD - WR
    reg [RD_TO_PCH_WIDTH                  - 1 : 0] rd_to_pch;
    
    // write
    reg [WR_TO_WR_WIDTH                   - 1 : 0] wr_to_wr;
    reg [WR_TO_RD_WIDTH                   - 1 : 0] wr_to_rd;
    reg [WR_TO_RD_WIDTH                   - 1 : 0] wr_to_rd_diff_chips;
    reg [WR_TO_PCH_WIDTH                  - 1 : 0] wr_to_pch;
    
    // auto precharge
    reg [RD_AP_TO_ACT_WIDTH               - 1 : 0] rd_ap_to_act;
    reg [WR_AP_TO_ACT_WIDTH               - 1 : 0] wr_ap_to_act;
    
    // precharge
    reg [PCH_TO_ACT_WIDTH                 - 1 : 0] pch_to_act;
    reg [PCH_ALL_TO_VALID_WIDTH           - 1 : 0] pch_all_to_valid;
    
    // others
    reg [ARF_TO_VALID_WIDTH               - 1 : 0] arf_to_valid;           // tRFC
    reg [PDN_TO_VALID_WIDTH               - 1 : 0] pdn_to_valid;           // power down exit time, not used currently
    reg [SRF_TO_VALID_WIDTH               - 1 : 0] srf_to_valid;           // self refresh exit time
    reg [SRF_TO_VALID_WIDTH               - 1 : 0] srf_to_zq;              // self refresh to ZQ calibration
    
    reg [ARF_PERIOD_WIDTH                 - 1 : 0] arf_period;             // tREFI
    reg [PDN_PERIOD_WIDTH                 - 1 : 0] pdn_period;             // will request power down if controller is idle for X number of clock cycles
    reg [ACT_TO_ACT_DIFF_BANK_WIDTH       - 1 : 0] act_to_act_diff_bank;   // tRRD
    reg [FOUR_ACT_TO_ACT_WIDTH            - 1 : 0] four_act_to_act;        // tFAW
    
    reg [FOUR_ACT_TO_ACT_WIDTH            - 1 : 0] temp_four_act_to_act;
    
    reg                                            add_lat_on;
    
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
            act_to_rdwr          <= 0;
            act_to_pch           <= 0;
            act_to_act           <= 0;
            arf_to_valid         <= 0;
            pdn_to_valid         <= 0;
            srf_to_valid         <= 0;
            arf_period           <= 0;
            pdn_period           <= 0;
            act_to_act_diff_bank <= 0;
            four_act_to_act      <= 0;
        end
        else
        begin
            // Set act_to_rdwr to zero when additive latency is enabled
            if (mem_add_lat >= (mem_trcd - 1))
                act_to_rdwr      <= 0;
            else
                act_to_rdwr      <= ((mem_trcd - mem_add_lat)  / DIV) + ((mem_trcd - mem_add_lat)  % DIV) - 1;   // ACT to RD/WR                         - tRCD (minus '1' because state machine requires another extra clock cycle for pre-processing)
            
            
            act_to_pch           <= (mem_tras                  / DIV) + (mem_tras                  % DIV);       // ACT to PCH                           - tRAS
            act_to_act           <= (mem_trc                   / DIV) + (mem_trc                   % DIV);       // ACT to ACT (same bank)               - tRC
            
            pch_to_act           <= (mem_trp                   / DIV) + (mem_trp                   % DIV);       // PCH to ACT                           - tRP
            
            arf_to_valid         <= (mem_trfc                  / DIV) + (mem_trfc                  % DIV);       // ARF to VALID                         - tRFC
            pdn_to_valid         <= (3                         / DIV) + (3                         % DIV);       // PDN to VALID                         - normally 3 clock cycles
            srf_to_valid         <= (mem_self_rfsh_exit_cycles / DIV) + (mem_self_rfsh_exit_cycles % DIV);       // SRF to VALID                         - normally 200 clock cycles
            
            arf_period           <= (mem_trefi                 / DIV) + (mem_trefi                 % DIV);       // ARF period                           - tREFI
            pdn_period           <= (mem_auto_pd_cycles        / DIV) + (mem_auto_pd_cycles        % DIV);       // PDN count after CMD_QUEUE is empty   - spepcified by users, 10 maybe?
            act_to_act_diff_bank <= (mem_trrd                  / DIV) + (mem_trrd                  % DIV);       // ACT to ACT (diff banks)              - tRRD
            
            temp_four_act_to_act <= (mem_tfaw                  / DIV) + (mem_tfaw                  % DIV);
            
            // Prevent four_act_to_act from getting negative value
            if (temp_four_act_to_act >= 4)
                four_act_to_act <= temp_four_act_to_act - 4;                                                     // Valid window for 4 ACT               - tFAW (minus '4' because of the tFAW logic)
            else
                four_act_to_act <= 0;
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
                    rd_to_rd            <= 0;
                    rd_to_wr            <= 0;
                    rd_to_pch           <= 0;
                    rd_ap_to_act        <= 0;
                    wr_to_wr            <= 0;
                    wr_to_rd            <= 0;
                    wr_to_pch           <= 0;
                    wr_ap_to_act        <= 0;
                    wr_to_rd_diff_chips <= 0;
                    pch_all_to_valid    <= 0;
                end
                else
                begin
                    rd_to_rd            <= ((mem_burst_length / 2) / DIV);                                                                                                                                                          // RD to RD     - tCCD
                    rd_to_wr            <= ((mem_tcl + (mem_burst_length / 2) + mem_rd_to_wr_turnaround_oct) / DIV) + ((mem_tcl + (mem_burst_length / 2) + mem_rd_to_wr_turnaround_oct) % DIV);                 // RD to WR     - CAS + (BL/2)
                    rd_to_pch           <= ((mem_burst_length / 2) / DIV);                                                                                                                                      // RD to PCH    - (BL/2)
                    rd_ap_to_act        <= (((mem_burst_length / 2) + mem_trp) / DIV) + (((mem_burst_length / 2) + mem_trp) % DIV);
                    
                    wr_to_wr            <= ((mem_burst_length / 2) / DIV);                                                                                                                                                          // WR to WR     - tCCD
                    wr_to_rd            <= ((1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) / DIV) + ((1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) % DIV);       // WR to RD     - WL + (BL/2) + tWTR (WL is always 1 in DDR)
                    wr_to_pch           <= ((1 + (mem_burst_length / 2) + mem_twr) / DIV) + ((1 + (mem_burst_length / 2) + mem_twr) % DIV);                                                                     // WR to PCH    - WL + (BL/2) + tWR
                    wr_ap_to_act        <= ((1 + (mem_burst_length / 2) + mem_twr + mem_trp) / DIV) + ((1 + (mem_burst_length / 2) + mem_twr + mem_trp) % DIV);
                    
                    wr_to_rd_diff_chips <= (((mem_burst_length / 2) + 3 + mem_wr_to_rd_diff_chips_turnaround_oct) / DIV) + (((mem_burst_length / 2) + 3 + mem_wr_to_rd_diff_chips_turnaround_oct) % DIV);       // WR to RD different rank  - (WL - RL) + (BL/2) + 2 (dead cycles)
                    
                    pch_all_to_valid    <= (mem_trp / DIV) + (mem_trp % DIV);
                end
            end
        end
        else if (MEM_TYPE == "DDR2")
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    rd_to_rd            <= 0;
                    rd_to_wr            <= 0;
                    rd_to_pch           <= 0;
                    rd_ap_to_act        <= 0;
                    wr_to_wr            <= 0;
                    wr_to_rd            <= 0;
                    wr_to_pch           <= 0;
                    wr_ap_to_act        <= 0;
                    wr_to_rd_diff_chips <= 0;
                    pch_all_to_valid    <= 0;
                end
                else
                begin
                    rd_to_rd            <= ((mem_burst_length / 2) / DIV); // tCCD is 2 but we set to 4 because we do burst length of 8
                    rd_to_wr            <= (((mem_burst_length / 2) + 2 + mem_rd_to_wr_turnaround_oct) / DIV) + (((mem_burst_length / 2) + 2 + mem_rd_to_wr_turnaround_oct) % DIV);
                    rd_to_pch           <= ((mem_add_lat + (mem_burst_length / 2) - 2 + max(mem_trtp, 2)) / DIV) + ((mem_add_lat + (mem_burst_length / 2) - 2 + max(mem_trtp, 2)) % DIV);
                    rd_ap_to_act        <= ((mem_add_lat + (mem_burst_length / 2) - 2 + max(mem_trtp, 2) + mem_trp) / DIV) + ((mem_add_lat + (mem_burst_length / 2) - 2 + max(mem_trtp, 2) + mem_trp) % DIV);
                    
                    wr_to_wr            <= ((mem_burst_length / 2) / DIV); // tCCD is 2 but we set to 4 because we do burst length of 8
                    wr_to_rd            <= ((mem_tcl - 1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) / DIV) + ((mem_tcl - 1 + (mem_burst_length / 2) + mem_twtr + mem_wr_to_rd_turnaround_oct) % DIV); // removed add lat because write and read is CAS command (add lat)
                    wr_to_pch           <= ((mem_add_lat + mem_tcl - 1 + (mem_burst_length / 2) + mem_twr) / DIV) + ((mem_add_lat + mem_tcl - 1 + (mem_burst_length / 2) + mem_twr) % DIV);
                    wr_ap_to_act        <= ((mem_add_lat + mem_tcl - 1 + (mem_burst_length / 2) + mem_twr + mem_trp) / DIV) + ((mem_add_lat + mem_tcl - 1 + (mem_burst_length / 2) + mem_twr + mem_trp) % DIV);
                    
                    wr_to_rd_diff_chips <= (((mem_burst_length / 2) + 1 + mem_wr_to_rd_diff_chips_turnaround_oct) / DIV) + (((mem_burst_length / 2) + 1 + mem_wr_to_rd_diff_chips_turnaround_oct) % DIV);
                    
                    pch_all_to_valid    <= ((mem_trp + 1) / DIV) + ((mem_trp + 1) % DIV); // tRPA = tRP + 1
                end
            end
        end
        else if (MEM_TYPE == "DDR3")
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    rd_to_rd            <= 0;
                    rd_to_wr            <= 0;
                    rd_to_wr_bc         <= 0;
                    rd_to_pch           <= 0;
                    rd_ap_to_act        <= 0;
                    wr_to_wr            <= 0;
                    wr_to_rd            <= 0;
                    wr_to_pch           <= 0;
                    wr_ap_to_act        <= 0;
                    wr_to_rd_diff_chips <= 0;
                    pch_all_to_valid    <= 0;
                    
                    srf_to_zq           <= 0; // DDR3 specific
                end
                else
                begin
                    rd_to_rd            <= ((mem_burst_length / 2) / DIV);
                    rd_to_wr            <= ((mem_tcl - mem_cas_wr_lat + 4 + 2 + mem_rd_to_wr_turnaround_oct) / DIV) + ((mem_tcl - mem_cas_wr_lat + 4 + 2 + mem_rd_to_wr_turnaround_oct) % DIV); // cas lat - cas wr lat + tCCD + 2
                    rd_to_wr_bc         <= ((mem_tcl - mem_cas_wr_lat + 2 + 2 + mem_rd_to_wr_turnaround_oct) / DIV) + ((mem_tcl - mem_cas_wr_lat + 2 + 2 + mem_rd_to_wr_turnaround_oct) % DIV); // tCCD/2 <= 2
                    rd_to_pch           <= ((mem_add_lat + max(mem_trtp, 4)) / DIV) + ((mem_add_lat + max(mem_trtp, 4)) % DIV);
                    rd_ap_to_act        <= ((mem_add_lat + max(mem_trtp, 4) + mem_trp) / DIV) + ((mem_add_lat + max(mem_trtp, 4) + mem_trp) % DIV);
                    
                    wr_to_wr            <= ((mem_burst_length / 2) / DIV);
                    wr_to_rd            <= ((mem_cas_wr_lat + (mem_burst_length / 2) + max(mem_twtr, 4) + mem_wr_to_rd_turnaround_oct) / DIV) + ((mem_cas_wr_lat + (mem_burst_length / 2) + max(mem_twtr, 4) + mem_wr_to_rd_turnaround_oct) % DIV); // reported by Denali, WR to RD delay is add_lat + cas_wr_lat + (bl/2) + max(tCCD or tWTR)
                    wr_to_pch           <= ((mem_add_lat + mem_cas_wr_lat + (mem_burst_length / 2) + mem_twr) / DIV) + ((mem_add_lat + mem_cas_wr_lat + (mem_burst_length / 2) + mem_twr) % DIV);
                    wr_ap_to_act        <= ((mem_add_lat + mem_cas_wr_lat + (mem_burst_length / 2) + mem_twr + mem_trp) / DIV) + ((mem_add_lat + mem_cas_wr_lat + (mem_burst_length / 2) + mem_twr + mem_trp) % DIV);
                    
                    wr_to_rd_diff_chips <= (((mem_cas_wr_lat - mem_tcl) + (mem_burst_length / 2) + 2 + mem_wr_to_rd_diff_chips_turnaround_oct) / DIV) + (((mem_cas_wr_lat - mem_tcl) + (mem_burst_length / 2) + 2 + mem_wr_to_rd_diff_chips_turnaround_oct) % DIV);
                    
                    pch_all_to_valid    <= (mem_trp / DIV) + (mem_trp % DIV);
                    
                    srf_to_zq           <= (256 / DIV);
                end
            end
        end
    endgenerate
    
    // function to determine max of 2 inputs
    function [WR_TO_RD_WIDTH - 1 : 0] max;
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
                if (act_to_rdwr == 0)
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
/*------------------------------------------------------------------------------

    [END] Timing Parameters

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] More / Less Compare Logic

------------------------------------------------------------------------------*/
    // more/less than N signal, this signal will be used in timer block, this will reduce timing violation
    // because we will abstract away the comparator and set the compared value in a register
    reg more_than_2_act_to_rdwr;
    reg more_than_2_act_to_pch;
    reg more_than_2_act_to_act;
    reg more_than_2_rd_to_rd;
    reg more_than_2_rd_to_wr;
    reg more_than_2_rd_to_wr_bc;
    reg more_than_2_rd_to_pch;
    reg more_than_2_wr_to_wr;
    reg more_than_2_wr_to_rd;
    reg more_than_2_wr_to_pch;
    reg more_than_2_rd_ap_to_act;
    reg more_than_2_wr_ap_to_act;
    reg more_than_2_pch_to_act;
    reg more_than_2_act_to_act_diff_bank;
    reg more_than_2_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_2_act_to_rdwr          <= 1'b0;
            more_than_2_act_to_pch           <= 1'b0;
            more_than_2_act_to_act           <= 1'b0;
            more_than_2_rd_to_rd             <= 1'b0;
            more_than_2_rd_to_wr             <= 1'b0;
            more_than_2_rd_to_wr_bc          <= 1'b0;
            more_than_2_rd_to_pch            <= 1'b0;
            more_than_2_wr_to_wr             <= 1'b0;
            more_than_2_wr_to_rd             <= 1'b0;
            more_than_2_wr_to_pch            <= 1'b0;
            more_than_2_rd_ap_to_act         <= 1'b0;
            more_than_2_wr_ap_to_act         <= 1'b0;
            more_than_2_pch_to_act           <= 1'b0;
            more_than_2_act_to_act_diff_bank <= 1'b0;
            more_than_2_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr >= 2)
                more_than_2_act_to_rdwr <= 1'b1;
            else
                more_than_2_act_to_rdwr <= 1'b0;
            
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
            
            // pch_to_act
            if (pch_to_act >= 2)
                more_than_2_pch_to_act <= 1'b1;
            else
                more_than_2_pch_to_act <= 1'b0;
            
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
    
    reg less_than_2_act_to_rdwr;
    reg less_than_2_act_to_pch;
    reg less_than_2_act_to_act;
    reg less_than_2_rd_to_rd;
    reg less_than_2_rd_to_wr;
    reg less_than_2_rd_to_wr_bc;
    reg less_than_2_rd_to_pch;
    reg less_than_2_wr_to_wr;
    reg less_than_2_wr_to_rd;
    reg less_than_2_wr_to_rd_diff_chips;
    reg less_than_2_wr_to_pch;
    reg less_than_2_rd_ap_to_act;
    reg less_than_2_wr_ap_to_act;
    reg less_than_2_pch_to_act;
    reg less_than_2_act_to_act_diff_bank;
    reg less_than_2_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_act_to_rdwr          <= 1'b0;
            less_than_2_act_to_pch           <= 1'b0;
            less_than_2_act_to_act           <= 1'b0;
            less_than_2_rd_to_rd             <= 1'b0;
            less_than_2_rd_to_wr             <= 1'b0;
            less_than_2_rd_to_wr_bc          <= 1'b0;
            less_than_2_rd_to_pch            <= 1'b0;
            less_than_2_wr_to_wr             <= 1'b0;
            less_than_2_wr_to_rd             <= 1'b0;
            less_than_2_wr_to_rd_diff_chips  <= 1'b0;
            less_than_2_wr_to_pch            <= 1'b0;
            less_than_2_rd_ap_to_act         <= 1'b0;
            less_than_2_wr_ap_to_act         <= 1'b0;
            less_than_2_pch_to_act           <= 1'b0;
            less_than_2_act_to_act_diff_bank <= 1'b0;
            less_than_2_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr <= 2)
                less_than_2_act_to_rdwr <= 1'b1;
            else
                less_than_2_act_to_rdwr <= 1'b0;
            
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
            
            // wr_to_rd_diff_chips
            if (wr_to_rd_diff_chips <= 2)
                less_than_2_wr_to_rd_diff_chips <= 1'b1;
            else
                less_than_2_wr_to_rd_diff_chips <= 1'b0;
            
            // wr_to_pch
            if (wr_to_pch <= 2)
                less_than_2_wr_to_pch <= 1'b1;
            else
                less_than_2_wr_to_pch <= 1'b0;
            
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
            
            // pch_to_act
            if (pch_to_act <= 2)
                less_than_2_pch_to_act <= 1'b1;
            else
                less_than_2_pch_to_act <= 1'b0;
            
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
    
    reg more_than_3_act_to_rdwr;
    reg more_than_3_act_to_pch;
    reg more_than_3_act_to_act;
    reg more_than_3_rd_to_rd;
    reg more_than_3_rd_to_wr;
    reg more_than_3_rd_to_wr_bc;
    reg more_than_3_rd_to_pch;
    reg more_than_3_wr_to_wr;
    reg more_than_3_wr_to_rd;
    reg more_than_3_wr_to_pch;
    reg more_than_3_rd_ap_to_act;
    reg more_than_3_wr_ap_to_act;
    reg more_than_3_pch_to_act;
    reg more_than_3_act_to_act_diff_bank;
    reg more_than_3_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_act_to_rdwr          <= 1'b0;
            more_than_3_act_to_pch           <= 1'b0;
            more_than_3_act_to_act           <= 1'b0;
            more_than_3_rd_to_rd             <= 1'b0;
            more_than_3_rd_to_wr             <= 1'b0;
            more_than_3_rd_to_wr_bc          <= 1'b0;
            more_than_3_rd_to_pch            <= 1'b0;
            more_than_3_wr_to_wr             <= 1'b0;
            more_than_3_wr_to_rd             <= 1'b0;
            more_than_3_wr_to_pch            <= 1'b0;
            more_than_3_rd_ap_to_act         <= 1'b0;
            more_than_3_wr_ap_to_act         <= 1'b0;
            more_than_3_pch_to_act           <= 1'b0;
            more_than_3_act_to_act_diff_bank <= 1'b0;
            more_than_3_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr >= 3)
                more_than_3_act_to_rdwr <= 1'b1;
            else
                more_than_3_act_to_rdwr <= 1'b0;
            
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
            
            // pch_to_act
            if (pch_to_act >= 3)
                more_than_3_pch_to_act <= 1'b1;
            else
                more_than_3_pch_to_act <= 1'b0;
            
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
    
    reg less_than_3_act_to_rdwr;
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
    reg less_than_3_rd_ap_to_act;
    reg less_than_3_wr_ap_to_act;
    reg less_than_3_pch_to_act;
    reg less_than_3_act_to_act_diff_bank;
    reg less_than_3_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_act_to_rdwr          <= 1'b0;
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
            less_than_3_rd_ap_to_act         <= 1'b0;
            less_than_3_wr_ap_to_act         <= 1'b0;
            less_than_3_pch_to_act           <= 1'b0;
            less_than_3_act_to_act_diff_bank <= 1'b0;
            less_than_3_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr <= 3)
                less_than_3_act_to_rdwr <= 1'b1;
            else
                less_than_3_act_to_rdwr <= 1'b0;
            
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
            
            // pch_to_act
            if (pch_to_act <= 3)
                less_than_3_pch_to_act <= 1'b1;
            else
                less_than_3_pch_to_act <= 1'b0;
            
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
    
    reg more_than_4_act_to_rdwr;
    reg more_than_4_act_to_pch;
    reg more_than_4_act_to_act;
    reg more_than_4_rd_to_rd;
    reg more_than_4_rd_to_wr;
    reg more_than_4_rd_to_wr_bc;
    reg more_than_4_rd_to_pch;
    reg more_than_4_wr_to_wr;
    reg more_than_4_wr_to_rd;
    reg more_than_4_wr_to_pch;
    reg more_than_4_rd_ap_to_act;
    reg more_than_4_wr_ap_to_act;
    reg more_than_4_pch_to_act;
    reg more_than_4_act_to_act_diff_bank;
    reg more_than_4_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_4_act_to_rdwr          <= 1'b0;
            more_than_4_act_to_pch           <= 1'b0;
            more_than_4_act_to_act           <= 1'b0;
            more_than_4_rd_to_rd             <= 1'b0;
            more_than_4_rd_to_wr             <= 1'b0;
            more_than_4_rd_to_wr_bc          <= 1'b0;
            more_than_4_rd_to_pch            <= 1'b0;
            more_than_4_wr_to_wr             <= 1'b0;
            more_than_4_wr_to_rd             <= 1'b0;
            more_than_4_wr_to_pch            <= 1'b0;
            more_than_4_rd_ap_to_act         <= 1'b0;
            more_than_4_wr_ap_to_act         <= 1'b0;
            more_than_4_pch_to_act           <= 1'b0;
            more_than_4_act_to_act_diff_bank <= 1'b0;
            more_than_4_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr >= 4)
                more_than_4_act_to_rdwr <= 1'b1;
            else
                more_than_4_act_to_rdwr <= 1'b0;
            
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
            
            // pch_to_act
            if (pch_to_act >= 4)
                more_than_4_pch_to_act <= 1'b1;
            else
                more_than_4_pch_to_act <= 1'b0;
            
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
        end
    end
    
    reg less_than_4_act_to_rdwr;
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
    reg less_than_4_rd_ap_to_act;
    reg less_than_4_wr_ap_to_act;
    reg less_than_4_pch_to_act;
    reg less_than_4_act_to_act_diff_bank;
    reg less_than_4_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_act_to_rdwr          <= 1'b0;
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
            less_than_4_rd_ap_to_act         <= 1'b0;
            less_than_4_wr_ap_to_act         <= 1'b0;
            less_than_4_pch_to_act           <= 1'b0;
            less_than_4_act_to_act_diff_bank <= 1'b0;
            less_than_4_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr <= 4)
                less_than_4_act_to_rdwr <= 1'b1;
            else
                less_than_4_act_to_rdwr <= 1'b0;
            
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
            
            // pch_to_act
            if (pch_to_act <= 4)
                less_than_4_pch_to_act <= 1'b1;
            else
                less_than_4_pch_to_act <= 1'b0;
            
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
    
    reg more_than_5_act_to_rdwr;
    reg more_than_5_act_to_pch;
    reg more_than_5_act_to_act;
    reg more_than_5_rd_to_rd;
    reg more_than_5_rd_to_wr;
    reg more_than_5_rd_to_wr_bc;
    reg more_than_5_rd_to_pch;
    reg more_than_5_wr_to_wr;
    reg more_than_5_wr_to_rd;
    reg more_than_5_wr_to_pch;
    reg more_than_5_rd_ap_to_act;
    reg more_than_5_wr_ap_to_act;
    reg more_than_5_pch_to_act;
    reg more_than_5_act_to_act_diff_bank;
    reg more_than_5_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_5_act_to_rdwr          <= 1'b0;
            more_than_5_act_to_pch           <= 1'b0;
            more_than_5_act_to_act           <= 1'b0;
            more_than_5_rd_to_rd             <= 1'b0;
            more_than_5_rd_to_wr             <= 1'b0;
            more_than_5_rd_to_wr_bc          <= 1'b0;
            more_than_5_rd_to_pch            <= 1'b0;
            more_than_5_wr_to_wr             <= 1'b0;
            more_than_5_wr_to_rd             <= 1'b0;
            more_than_5_wr_to_pch            <= 1'b0;
            more_than_5_rd_ap_to_act         <= 1'b0;
            more_than_5_wr_ap_to_act         <= 1'b0;
            more_than_5_pch_to_act           <= 1'b0;
            more_than_5_act_to_act_diff_bank <= 1'b0;
            more_than_5_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr >= 5)
                more_than_5_act_to_rdwr <= 1'b1;
            else
                more_than_5_act_to_rdwr <= 1'b0;
            
            // act_to_pch
            if (act_to_pch >= 5)
                more_than_5_act_to_pch <= 1'b1;
            else
                more_than_5_act_to_pch <= 1'b0;
            
            // act_to_act
            if (act_to_act >= 5)
                more_than_5_act_to_act <= 1'b1;
            else
                more_than_5_act_to_act <= 1'b0;
            
            // rd_to_rd
            if (rd_to_rd >= 5)
                more_than_5_rd_to_rd <= 1'b1;
            else
                more_than_5_rd_to_rd <= 1'b0;
            
            // rd_to_wr
            if (rd_to_wr >= 5)
                more_than_5_rd_to_wr <= 1'b1;
            else
                more_than_5_rd_to_wr <= 1'b0;
            
            // rd_to_wr_bc
            if (rd_to_wr_bc >= 5)
                more_than_5_rd_to_wr_bc <= 1'b1;
            else
                more_than_5_rd_to_wr_bc <= 1'b0;
            
            // rd_to_pch
            if (rd_to_pch >= 5)
                more_than_5_rd_to_pch <= 1'b1;
            else
                more_than_5_rd_to_pch <= 1'b0;
            
            // wr_to_wr
            if (wr_to_wr >= 5)
                more_than_5_wr_to_wr <= 1'b1;
            else
                more_than_5_wr_to_wr <= 1'b0;
            
            // wr_to_rd
            if (wr_to_rd >= 5)
                more_than_5_wr_to_rd <= 1'b1;
            else
                more_than_5_wr_to_rd <= 1'b0;
            
            // wr_to_pch
            if (wr_to_pch >= 5)
                more_than_5_wr_to_pch <= 1'b1;
            else
                more_than_5_wr_to_pch <= 1'b0;
            
            // rd_ap_to_act
            if (rd_ap_to_act >= 5)
                more_than_5_rd_ap_to_act <= 1'b1;
            else
                more_than_5_rd_ap_to_act <= 1'b0;
            
            // wr_ap_to_act
            if (wr_ap_to_act >= 5)
                more_than_5_wr_ap_to_act <= 1'b1;
            else
                more_than_5_wr_ap_to_act <= 1'b0;
            
            // pch_to_act
            if (pch_to_act >= 5)
                more_than_5_pch_to_act <= 1'b1;
            else
                more_than_5_pch_to_act <= 1'b0;
            
            // act_to_act_diff_bank
            if (act_to_act_diff_bank >= 5)
                more_than_5_act_to_act_diff_bank <= 1'b1;
            else
                more_than_5_act_to_act_diff_bank <= 1'b0;
            
            // four_act_to_act
            if (four_act_to_act >= 5)
                more_than_5_four_act_to_act <= 1'b1;
            else
                more_than_5_four_act_to_act <= 1'b0;
        end
    end
    
    reg less_than_5_act_to_rdwr;
    reg less_than_5_act_to_pch;
    reg less_than_5_act_to_act;
    reg less_than_5_rd_to_rd;
    reg less_than_5_rd_to_wr;
    reg less_than_5_rd_to_wr_bc;
    reg less_than_5_rd_to_pch;
    reg less_than_5_wr_to_wr;
    reg less_than_5_wr_to_rd;
    reg less_than_5_wr_to_rd_diff_chips;
    reg less_than_5_wr_to_pch;
    reg less_than_5_rd_ap_to_act;
    reg less_than_5_wr_ap_to_act;
    reg less_than_5_pch_to_act;
    reg less_than_5_act_to_act_diff_bank;
    reg less_than_5_four_act_to_act;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_5_act_to_rdwr          <= 1'b0;
            less_than_5_act_to_pch           <= 1'b0;
            less_than_5_act_to_act           <= 1'b0;
            less_than_5_rd_to_rd             <= 1'b0;
            less_than_5_rd_to_wr             <= 1'b0;
            less_than_5_rd_to_wr_bc          <= 1'b0;
            less_than_5_rd_to_pch            <= 1'b0;
            less_than_5_wr_to_wr             <= 1'b0;
            less_than_5_wr_to_rd             <= 1'b0;
            less_than_5_wr_to_rd_diff_chips  <= 1'b0;
            less_than_5_wr_to_pch            <= 1'b0;
            less_than_5_rd_ap_to_act         <= 1'b0;
            less_than_5_wr_ap_to_act         <= 1'b0;
            less_than_5_pch_to_act           <= 1'b0;
            less_than_5_act_to_act_diff_bank <= 1'b0;
            less_than_5_four_act_to_act      <= 1'b0;
        end
        else
        begin
            // act_to_rdwr
            if (act_to_rdwr <= 5)
                less_than_5_act_to_rdwr <= 1'b1;
            else
                less_than_5_act_to_rdwr <= 1'b0;
            
            // act_to_pch
            if (act_to_pch <= 5)
                less_than_5_act_to_pch <= 1'b1;
            else
                less_than_5_act_to_pch <= 1'b0;
            
            // act_to_act
            if (act_to_act <= 5)
                less_than_5_act_to_act <= 1'b1;
            else
                less_than_5_act_to_act <= 1'b0;
            
            // rd_to_rd
            if (rd_to_rd <= 5)
                less_than_5_rd_to_rd <= 1'b1;
            else
                less_than_5_rd_to_rd <= 1'b0;
            
            // rd_to_wr
            if (rd_to_wr <= 5)
                less_than_5_rd_to_wr <= 1'b1;
            else
                less_than_5_rd_to_wr <= 1'b0;
            
            // rd_to_wr_bc
            if (rd_to_wr_bc <= 5)
                less_than_5_rd_to_wr_bc <= 1'b1;
            else
                less_than_5_rd_to_wr_bc <= 1'b0;
            
            // rd_to_pch
            if (rd_to_pch <= 5)
                less_than_5_rd_to_pch <= 1'b1;
            else
                less_than_5_rd_to_pch <= 1'b0;
            
            // wr_to_wr
            if (wr_to_wr <= 5)
                less_than_5_wr_to_wr <= 1'b1;
            else
                less_than_5_wr_to_wr <= 1'b0;
            
            // wr_to_rd
            if (wr_to_rd <= 5)
                less_than_5_wr_to_rd <= 1'b1;
            else
                less_than_5_wr_to_rd <= 1'b0;
            
            // wr_to_rd_diff_chips
            if (wr_to_rd_diff_chips <= 5)
                less_than_5_wr_to_rd_diff_chips <= 1'b1;
            else
                less_than_5_wr_to_rd_diff_chips <= 1'b0;
            
            // wr_to_pch
            if (wr_to_pch <= 5)
                less_than_5_wr_to_pch <= 1'b1;
            else
                less_than_5_wr_to_pch <= 1'b0;
            
            // rd_ap_to_act
            if (rd_ap_to_act <= 5)
                less_than_5_rd_ap_to_act <= 1'b1;
            else
                less_than_5_rd_ap_to_act <= 1'b0;
            
            // wr_ap_to_act
            if (wr_ap_to_act <= 5)
                less_than_5_wr_ap_to_act <= 1'b1;
            else
                less_than_5_wr_ap_to_act <= 1'b0;
            
            // pch_to_act
            if (pch_to_act <= 5)
                less_than_5_pch_to_act <= 1'b1;
            else
                less_than_5_pch_to_act <= 1'b0;
            
            // act_to_act_diff_bank
            if (act_to_act_diff_bank <= 5)
                less_than_5_act_to_act_diff_bank <= 1'b1;
            else
                less_than_5_act_to_act_diff_bank <= 1'b0;
            
            // four_act_to_act
            if (four_act_to_act <= 5)
                less_than_5_four_act_to_act <= 1'b1;
            else
                less_than_5_four_act_to_act <= 1'b0;
        end
    end
    
/*------------------------------------------------------------------------------

    [END] More / Less Compare Logic

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------





endmodule
