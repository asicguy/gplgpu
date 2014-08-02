
//altera message_off 10230

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_timing_param #
    ( parameter
        CFG_DWIDTH_RATIO                                    =   2,
        CFG_CTL_ARBITER_TYPE                                =   "ROWCOL",
        
        // cfg: general
        CFG_PORT_WIDTH_TYPE                                 =   3,
        CFG_PORT_WIDTH_BURST_LENGTH                         =   5,
        
        // cfg: timing parameters
        CFG_PORT_WIDTH_CAS_WR_LAT                           =   4,          // max will be 8 in DDR3
        CFG_PORT_WIDTH_ADD_LAT                              =   3,          // max will be 10 in DDR3
        CFG_PORT_WIDTH_TCL                                  =   4,          // max will be 11 in DDR3
        CFG_PORT_WIDTH_TRRD                                 =   4,          // 2 - 8        enough?
        CFG_PORT_WIDTH_TFAW                                 =   6,          // 6 - 32       enough?
        CFG_PORT_WIDTH_TRFC                                 =   8,          // 12-140       enough?
        CFG_PORT_WIDTH_TREFI                                =   13,         // 780 - 6240   enough?
        CFG_PORT_WIDTH_TRCD                                 =   4,          // 2 - 11       enough?
        CFG_PORT_WIDTH_TRP                                  =   4,          // 2 - 11       enough?
        CFG_PORT_WIDTH_TWR                                  =   4,          // 2 - 12       enough?
        CFG_PORT_WIDTH_TWTR                                 =   4,          // 1 - 10       enough?
        CFG_PORT_WIDTH_TRTP                                 =   4,          // 2 - 8        enough?
        CFG_PORT_WIDTH_TRAS                                 =   5,          // 4 - 29       enough?
        CFG_PORT_WIDTH_TRC                                  =   6,          // 8 - 40       enough?
        CFG_PORT_WIDTH_TCCD                                 =   3,          // max will be 4 in 4n prefetch architecture?
        CFG_PORT_WIDTH_TMRD                                 =   3,          // 4 - ?        enough?
        CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES                =   10,         // max will be 512 in DDR3
        CFG_PORT_WIDTH_PDN_EXIT_CYCLES                      =   4,          // 3 - ?        enough?
        CFG_PORT_WIDTH_AUTO_PD_CYCLES                       =   16,         // enough?
        CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES             =   4,          // enough?
        
        // cfg: extra timing parameters
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR            =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH             =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT             =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD               =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP     =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR               =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC            =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP     =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH              =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID         =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR               =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP     =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD               =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC            =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP     =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH              =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID         =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID           =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID       =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK   =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT        =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID           =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID           =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID           =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL          =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD             =   4,
        CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD             =   4,
        
        // Output - derived timing parameters width
        T_PARAM_ACT_TO_RDWR_WIDTH                           =   6,          // temporary
        T_PARAM_ACT_TO_PCH_WIDTH                            =   6,          // temporary
        T_PARAM_ACT_TO_ACT_WIDTH                            =   6,          // temporary
        T_PARAM_RD_TO_RD_WIDTH                              =   6,          // temporary
        T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH                    =   6,          // temporary
        T_PARAM_RD_TO_WR_WIDTH                              =   6,          // temporary
        T_PARAM_RD_TO_WR_BC_WIDTH                           =   6,          // temporary
        T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH                    =   6,          // temporary
        T_PARAM_RD_TO_PCH_WIDTH                             =   6,          // temporary
        T_PARAM_RD_AP_TO_VALID_WIDTH                        =   6,          // temporary
        T_PARAM_WR_TO_WR_WIDTH                              =   6,          // temporary
        T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH                    =   6,          // temporary
        T_PARAM_WR_TO_RD_WIDTH                              =   6,          // temporary
        T_PARAM_WR_TO_RD_BC_WIDTH                           =   6,          // temporary
        T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH                    =   6,          // temporary
        T_PARAM_WR_TO_PCH_WIDTH                             =   6,          // temporary
        T_PARAM_WR_AP_TO_VALID_WIDTH                        =   6,          // temporary
        T_PARAM_PCH_TO_VALID_WIDTH                          =   6,          // temporary
        T_PARAM_PCH_ALL_TO_VALID_WIDTH                      =   6,          // temporary
        T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH                  =   6,          // temporary
        T_PARAM_FOUR_ACT_TO_ACT_WIDTH                       =   6,          // temporary
        T_PARAM_ARF_TO_VALID_WIDTH                          =   8,          // temporary
        T_PARAM_PDN_TO_VALID_WIDTH                          =   6,          // temporary
        T_PARAM_SRF_TO_VALID_WIDTH                          =   10,         // temporary
        T_PARAM_SRF_TO_ZQ_CAL_WIDTH                         =   10,         // temporary
        T_PARAM_ARF_PERIOD_WIDTH                            =   13,         // temporary
        T_PARAM_PDN_PERIOD_WIDTH                            =   16,         // temporary
        T_PARAM_POWER_SAVING_EXIT_WIDTH                     =   6           // temporary
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // Input - configuration
        cfg_burst_length,
        cfg_type,
        
        // Input - memory timing parameter
        cfg_cas_wr_lat,
        cfg_add_lat,
        cfg_tcl,
        cfg_trrd,
        cfg_tfaw,
        cfg_trfc,
        cfg_trefi,
        cfg_trcd,
        cfg_trp,
        cfg_twr,
        cfg_twtr,
        cfg_trtp,
        cfg_tras,
        cfg_trc,
        cfg_tccd,
        cfg_tmrd,
        cfg_self_rfsh_exit_cycles,
        cfg_pdn_exit_cycles,
        cfg_auto_pd_cycles,
        cfg_power_saving_exit_cycles,
        
        // Input - extra derived timing parameter
        cfg_extra_ctl_clk_act_to_rdwr,
        cfg_extra_ctl_clk_act_to_pch,
        cfg_extra_ctl_clk_act_to_act,
        cfg_extra_ctl_clk_rd_to_rd,
        cfg_extra_ctl_clk_rd_to_rd_diff_chip,
        cfg_extra_ctl_clk_rd_to_wr,
        cfg_extra_ctl_clk_rd_to_wr_bc,
        cfg_extra_ctl_clk_rd_to_wr_diff_chip,
        cfg_extra_ctl_clk_rd_to_pch,
        cfg_extra_ctl_clk_rd_ap_to_valid,
        cfg_extra_ctl_clk_wr_to_wr,
        cfg_extra_ctl_clk_wr_to_wr_diff_chip,
        cfg_extra_ctl_clk_wr_to_rd,
        cfg_extra_ctl_clk_wr_to_rd_bc,
        cfg_extra_ctl_clk_wr_to_rd_diff_chip,
        cfg_extra_ctl_clk_wr_to_pch,
        cfg_extra_ctl_clk_wr_ap_to_valid,
        cfg_extra_ctl_clk_pch_to_valid,
        cfg_extra_ctl_clk_pch_all_to_valid,
        cfg_extra_ctl_clk_act_to_act_diff_bank,
        cfg_extra_ctl_clk_four_act_to_act,
        cfg_extra_ctl_clk_arf_to_valid,
        cfg_extra_ctl_clk_pdn_to_valid,
        cfg_extra_ctl_clk_srf_to_valid,
        cfg_extra_ctl_clk_srf_to_zq_cal,
        cfg_extra_ctl_clk_arf_period,
        cfg_extra_ctl_clk_pdn_period,
        
        // Output - derived timing parameters
        t_param_act_to_rdwr,
        t_param_act_to_pch,
        t_param_act_to_act,
        t_param_rd_to_rd,
        t_param_rd_to_rd_diff_chip,
        t_param_rd_to_wr,
        t_param_rd_to_wr_bc,
        t_param_rd_to_wr_diff_chip,
        t_param_rd_to_pch,
        t_param_rd_ap_to_valid,
        t_param_wr_to_wr,
        t_param_wr_to_wr_diff_chip,
        t_param_wr_to_rd,
        t_param_wr_to_rd_bc,
        t_param_wr_to_rd_diff_chip,
        t_param_wr_to_pch,
        t_param_wr_ap_to_valid,
        t_param_pch_to_valid,
        t_param_pch_all_to_valid,
        t_param_act_to_act_diff_bank,
        t_param_four_act_to_act,
        t_param_arf_to_valid,
        t_param_pdn_to_valid,
        t_param_srf_to_valid,
        t_param_srf_to_zq_cal,
        t_param_arf_period,
        t_param_pdn_period,
        t_param_power_saving_exit
    );

input  ctl_clk;
input  ctl_reset_n;

// Input - configuration
input  [CFG_PORT_WIDTH_BURST_LENGTH                       - 1 : 0] cfg_burst_length;
input  [CFG_PORT_WIDTH_TYPE                               - 1 : 0] cfg_type;

// Input - memory timing parameter
input  [CFG_PORT_WIDTH_CAS_WR_LAT                         - 1 : 0] cfg_cas_wr_lat;
input  [CFG_PORT_WIDTH_ADD_LAT                            - 1 : 0] cfg_add_lat;
input  [CFG_PORT_WIDTH_TCL                                - 1 : 0] cfg_tcl;
input  [CFG_PORT_WIDTH_TRRD                               - 1 : 0] cfg_trrd;
input  [CFG_PORT_WIDTH_TFAW                               - 1 : 0] cfg_tfaw;
input  [CFG_PORT_WIDTH_TRFC                               - 1 : 0] cfg_trfc;
input  [CFG_PORT_WIDTH_TREFI                              - 1 : 0] cfg_trefi;
input  [CFG_PORT_WIDTH_TRCD                               - 1 : 0] cfg_trcd;
input  [CFG_PORT_WIDTH_TRP                                - 1 : 0] cfg_trp;
input  [CFG_PORT_WIDTH_TWR                                - 1 : 0] cfg_twr;
input  [CFG_PORT_WIDTH_TWTR                               - 1 : 0] cfg_twtr;
input  [CFG_PORT_WIDTH_TRTP                               - 1 : 0] cfg_trtp;
input  [CFG_PORT_WIDTH_TRAS                               - 1 : 0] cfg_tras;
input  [CFG_PORT_WIDTH_TRC                                - 1 : 0] cfg_trc;
input  [CFG_PORT_WIDTH_TCCD                               - 1 : 0] cfg_tccd;
input  [CFG_PORT_WIDTH_TMRD                               - 1 : 0] cfg_tmrd;
input  [CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES              - 1 : 0] cfg_self_rfsh_exit_cycles;
input  [CFG_PORT_WIDTH_PDN_EXIT_CYCLES                    - 1 : 0] cfg_pdn_exit_cycles;
input  [CFG_PORT_WIDTH_AUTO_PD_CYCLES                     - 1 : 0] cfg_auto_pd_cycles;
input  [CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES           - 1 : 0] cfg_power_saving_exit_cycles;

input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR          - 1 : 0] cfg_extra_ctl_clk_act_to_rdwr;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH           - 1 : 0] cfg_extra_ctl_clk_act_to_pch;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT           - 1 : 0] cfg_extra_ctl_clk_act_to_act;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD             - 1 : 0] cfg_extra_ctl_clk_rd_to_rd;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP   - 1 : 0] cfg_extra_ctl_clk_rd_to_rd_diff_chip;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR             - 1 : 0] cfg_extra_ctl_clk_rd_to_wr;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC          - 1 : 0] cfg_extra_ctl_clk_rd_to_wr_bc;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP   - 1 : 0] cfg_extra_ctl_clk_rd_to_wr_diff_chip;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH            - 1 : 0] cfg_extra_ctl_clk_rd_to_pch;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID       - 1 : 0] cfg_extra_ctl_clk_rd_ap_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR             - 1 : 0] cfg_extra_ctl_clk_wr_to_wr;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP   - 1 : 0] cfg_extra_ctl_clk_wr_to_wr_diff_chip;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD             - 1 : 0] cfg_extra_ctl_clk_wr_to_rd;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC          - 1 : 0] cfg_extra_ctl_clk_wr_to_rd_bc;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP   - 1 : 0] cfg_extra_ctl_clk_wr_to_rd_diff_chip;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH            - 1 : 0] cfg_extra_ctl_clk_wr_to_pch;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID       - 1 : 0] cfg_extra_ctl_clk_wr_ap_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID         - 1 : 0] cfg_extra_ctl_clk_pch_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID     - 1 : 0] cfg_extra_ctl_clk_pch_all_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK - 1 : 0] cfg_extra_ctl_clk_act_to_act_diff_bank;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT      - 1 : 0] cfg_extra_ctl_clk_four_act_to_act;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID         - 1 : 0] cfg_extra_ctl_clk_arf_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID         - 1 : 0] cfg_extra_ctl_clk_pdn_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID         - 1 : 0] cfg_extra_ctl_clk_srf_to_valid;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL        - 1 : 0] cfg_extra_ctl_clk_srf_to_zq_cal;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD           - 1 : 0] cfg_extra_ctl_clk_arf_period;
input  [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD           - 1 : 0] cfg_extra_ctl_clk_pdn_period;

// Output - derived timing parameters
output [T_PARAM_ACT_TO_RDWR_WIDTH                         - 1 : 0] t_param_act_to_rdwr;
output [T_PARAM_ACT_TO_PCH_WIDTH                          - 1 : 0] t_param_act_to_pch;
output [T_PARAM_ACT_TO_ACT_WIDTH                          - 1 : 0] t_param_act_to_act;
output [T_PARAM_RD_TO_RD_WIDTH                            - 1 : 0] t_param_rd_to_rd;
output [T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH                  - 1 : 0] t_param_rd_to_rd_diff_chip;
output [T_PARAM_RD_TO_WR_WIDTH                            - 1 : 0] t_param_rd_to_wr;
output [T_PARAM_RD_TO_WR_BC_WIDTH                         - 1 : 0] t_param_rd_to_wr_bc;
output [T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH                  - 1 : 0] t_param_rd_to_wr_diff_chip;
output [T_PARAM_RD_TO_PCH_WIDTH                           - 1 : 0] t_param_rd_to_pch;
output [T_PARAM_RD_AP_TO_VALID_WIDTH                      - 1 : 0] t_param_rd_ap_to_valid;
output [T_PARAM_WR_TO_WR_WIDTH                            - 1 : 0] t_param_wr_to_wr;
output [T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH                  - 1 : 0] t_param_wr_to_wr_diff_chip;
output [T_PARAM_WR_TO_RD_WIDTH                            - 1 : 0] t_param_wr_to_rd;
output [T_PARAM_WR_TO_RD_BC_WIDTH                         - 1 : 0] t_param_wr_to_rd_bc;
output [T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH                  - 1 : 0] t_param_wr_to_rd_diff_chip;
output [T_PARAM_WR_TO_PCH_WIDTH                           - 1 : 0] t_param_wr_to_pch;
output [T_PARAM_WR_AP_TO_VALID_WIDTH                      - 1 : 0] t_param_wr_ap_to_valid;
output [T_PARAM_PCH_TO_VALID_WIDTH                        - 1 : 0] t_param_pch_to_valid;
output [T_PARAM_PCH_ALL_TO_VALID_WIDTH                    - 1 : 0] t_param_pch_all_to_valid;
output [T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH                - 1 : 0] t_param_act_to_act_diff_bank;
output [T_PARAM_FOUR_ACT_TO_ACT_WIDTH                     - 1 : 0] t_param_four_act_to_act;
output [T_PARAM_ARF_TO_VALID_WIDTH                        - 1 : 0] t_param_arf_to_valid;
output [T_PARAM_PDN_TO_VALID_WIDTH                        - 1 : 0] t_param_pdn_to_valid;
output [T_PARAM_SRF_TO_VALID_WIDTH                        - 1 : 0] t_param_srf_to_valid;
output [T_PARAM_SRF_TO_ZQ_CAL_WIDTH                       - 1 : 0] t_param_srf_to_zq_cal;
output [T_PARAM_ARF_PERIOD_WIDTH                          - 1 : 0] t_param_arf_period;
output [T_PARAM_PDN_PERIOD_WIDTH                          - 1 : 0] t_param_pdn_period;
output [T_PARAM_POWER_SAVING_EXIT_WIDTH                   - 1 : 0] t_param_power_saving_exit;

//--------------------------------------------------------------------------------------------------------
//
//  [START] Register & Wires
//
//--------------------------------------------------------------------------------------------------------
    // Output
    reg  [T_PARAM_ACT_TO_RDWR_WIDTH                   - 1 : 0] t_param_act_to_rdwr;
    reg  [T_PARAM_ACT_TO_PCH_WIDTH                    - 1 : 0] t_param_act_to_pch;
    reg  [T_PARAM_ACT_TO_ACT_WIDTH                    - 1 : 0] t_param_act_to_act;
    reg  [T_PARAM_RD_TO_RD_WIDTH                      - 1 : 0] t_param_rd_to_rd;
    reg  [T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH            - 1 : 0] t_param_rd_to_rd_diff_chip;
    reg  [T_PARAM_RD_TO_WR_WIDTH                      - 1 : 0] t_param_rd_to_wr;
    reg  [T_PARAM_RD_TO_WR_BC_WIDTH                   - 1 : 0] t_param_rd_to_wr_bc;
    reg  [T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH            - 1 : 0] t_param_rd_to_wr_diff_chip;
    reg  [T_PARAM_RD_TO_PCH_WIDTH                     - 1 : 0] t_param_rd_to_pch;
    reg  [T_PARAM_RD_AP_TO_VALID_WIDTH                - 1 : 0] t_param_rd_ap_to_valid;
    reg  [T_PARAM_WR_TO_WR_WIDTH                      - 1 : 0] t_param_wr_to_wr;
    reg  [T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH            - 1 : 0] t_param_wr_to_wr_diff_chip;
    reg  [T_PARAM_WR_TO_RD_WIDTH                      - 1 : 0] t_param_wr_to_rd;
    reg  [T_PARAM_WR_TO_RD_BC_WIDTH                   - 1 : 0] t_param_wr_to_rd_bc;
    reg  [T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH            - 1 : 0] t_param_wr_to_rd_diff_chip;
    reg  [T_PARAM_WR_TO_PCH_WIDTH                     - 1 : 0] t_param_wr_to_pch;
    reg  [T_PARAM_WR_AP_TO_VALID_WIDTH                - 1 : 0] t_param_wr_ap_to_valid;
    reg  [T_PARAM_PCH_TO_VALID_WIDTH                  - 1 : 0] t_param_pch_to_valid;
    reg  [T_PARAM_PCH_ALL_TO_VALID_WIDTH              - 1 : 0] t_param_pch_all_to_valid;
    reg  [T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH          - 1 : 0] t_param_act_to_act_diff_bank;
    reg  [T_PARAM_FOUR_ACT_TO_ACT_WIDTH               - 1 : 0] t_param_four_act_to_act;
    reg  [T_PARAM_ARF_TO_VALID_WIDTH                  - 1 : 0] t_param_arf_to_valid;
    reg  [T_PARAM_PDN_TO_VALID_WIDTH                  - 1 : 0] t_param_pdn_to_valid;
    reg  [T_PARAM_SRF_TO_VALID_WIDTH                  - 1 : 0] t_param_srf_to_valid;
    reg  [T_PARAM_SRF_TO_ZQ_CAL_WIDTH                 - 1 : 0] t_param_srf_to_zq_cal;
    reg  [T_PARAM_ARF_PERIOD_WIDTH                    - 1 : 0] t_param_arf_period;
    reg  [T_PARAM_PDN_PERIOD_WIDTH                    - 1 : 0] t_param_pdn_period;
    reg  [T_PARAM_POWER_SAVING_EXIT_WIDTH             - 1 : 0] t_param_power_saving_exit;
//--------------------------------------------------------------------------------------------------------
//
//  [END] Register & Wires
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Timing Parameter Calculation
//  
//  Important Note:
//  
//  - Added "cfg_extra_ctl_clk_*" ports into our timing parameter calculation in order for us to
//  tweak the timing parameter gaps in the future without changing the code
//  
//  - This will be very useful in HIP implementation
//  
//  - "cfg_extra_ctl_clk_*" must be set in term of controller clock cycles
//
//--------------------------------------------------------------------------------------------------------
    // DIV is a divider for our timing parameters, DIV will be '1' in fullrate, '2' in halfrate
    // and '4' in quarter rate
    localparam DIV = CFG_DWIDTH_RATIO / 2;
    
    // Use the following table to determine the optimum timing parameter
    // ==========================================================================================================
    // ||   Controller Rate   ||   Arbiter Type   ||   Command Transition   ||   Remainder DIV   ||   Offset   ||
    // ==========================================================================================================
    // ||        FR           ||    Don't care    ||       Don't care       ||       Yes         ||     No     ||
    // ----------------------------------------------------------------------------------------------------------
    // ||                     ||                  ||       Row -> Col       ||       Yes         ||     No     ||
    // --                     --      ROWCOL      ---------------------------------------------------------------
    // ||                     ||                  ||       Col -> Row       ||       No          ||     Yes    ||
    // --        HR           -----------------------------------------------------------------------------------
    // ||                     ||                  ||       Row -> Col       ||       No          ||     Yes    ||
    // --                     --      COLROW      ---------------------------------------------------------------
    // ||                     ||                  ||       Col -> Row       ||       Yes         ||     No     ||
    // ----------------------------------------------------------------------------------------------------------
    // ||                     ||                  ||       Row -> Col       ||       Yes*        ||     No     ||
    // --                     --      ROWCOL      ---------------------------------------------------------------
    // ||                     ||                  ||       Col -> Row       ||       Yes*        ||     Yes    ||
    // --        QR           -----------------------------------------------------------------------------------
    // ||                     ||                  ||       Row -> Col       ||       Yes*        ||     Yes    ||
    // --                     --      COLROW      ---------------------------------------------------------------
    // ||                     ||                  ||       Col -> Row       ||       Yes*        ||     No     ||
    // ----------------------------------------------------------------------------------------------------------
    // Footnote:
    // * for calculation with remainder of '3' only
    
    //---------------------------------------------------
    // Remainder calculation
    //---------------------------------------------------
    // We need to remove the extra clock cycle in half and quarter rate
    // for two subsequent different commands but remain for two subsequent same commands
    // example of two subsequent different commands: ROW-TO-COL, COL-TO-ROW
    // example of two subsequent same commands: ROW-TO-ROW, COL-TO-COL
    
    // Self to self command require DIV
    localparam DIV_ROW_TO_ROW = DIV;
    localparam DIV_COL_TO_COL = DIV;
    localparam DIV_SB_TO_SB   = DIV;
    
    localparam DIV_ROW_TO_COL =     (
                                        (CFG_DWIDTH_RATIO == 2 || CFG_DWIDTH_RATIO == 8) ?
                                            (
                                                DIV // Need DIV in full & quarter rate
                                            ) :
                                            (
                                                (CFG_DWIDTH_RATIO == 4) ?
                                                    (
                                                        (CFG_CTL_ARBITER_TYPE == "ROWCOL") ? DIV : 1 // Only need DIV in ROWCOL arbiter mode
                                                    ) :
                                                    (
                                                        DIV // DIV is assigned by default
                                                    )
                                            )
                                    );
    localparam DIV_COL_TO_ROW =     (
                                        (CFG_DWIDTH_RATIO == 2 || CFG_DWIDTH_RATIO == 8) ?
                                            (
                                                DIV // Need DIV in full & quarter rate
                                            ) :
                                            (
                                                (CFG_DWIDTH_RATIO == 4) ?
                                                    (
                                                        (CFG_CTL_ARBITER_TYPE == "COLROW") ? DIV : 1 // Only need DIV in COLROW arbiter mode
                                                    ) :
                                                    (
                                                        DIV // DIV is assigned by default
                                                    )
                                            )
                                    );
    localparam DIV_SB_TO_ROW  =     DIV_COL_TO_ROW; // Similar to COL_TO_ROW parameter
    
    //---------------------------------------------------
    // Remainder offset calculation
    //---------------------------------------------------
    // In QR, odd number calculation will only need to add extra offset when calculation's remainder is > 2
    
    // Self to self command's remainder offset will be 0
    localparam DIV_ROW_TO_ROW_OFFSET = 0;
    localparam DIV_COL_TO_COL_OFFSET = 0;
    localparam DIV_SB_TO_SB_OFFSET   = 0;
    
    localparam DIV_ROW_TO_COL_OFFSET = (CFG_DWIDTH_RATIO == 8) ? 2 : 0;
    localparam DIV_COL_TO_ROW_OFFSET = (CFG_DWIDTH_RATIO == 8) ? 2 : 0;
    localparam DIV_SB_TO_ROW_OFFSET  = DIV_COL_TO_ROW_OFFSET; // Similar to COL_TO_ROW parameter
    
    //---------------------------------------------------
    // Offset calculation
    //---------------------------------------------------
    // We need to offset timing parameter due to HR 1T and QR 2T support
    // this is because we can issue a row and column command in one controller clock cycle
    
    // Self to self command doesn't require offset
    localparam ROW_TO_ROW_OFFSET = 0;
    localparam COL_TO_COL_OFFSET = 0;
    localparam SB_TO_SB_OFFSET   = 0;
    
    localparam ROW_TO_COL_OFFSET =  (
                                        (CFG_DWIDTH_RATIO == 2) ?
                                            (
                                                0 // Offset is not required in full rate
                                            ) :
                                            (
                                                (CFG_CTL_ARBITER_TYPE == "ROWCOL") ? 0 : 1 // Need offset in ROWCOL arbiter mode
                                            )
                                    );
    localparam COL_TO_ROW_OFFSET =  (
                                        (CFG_DWIDTH_RATIO == 2) ?
                                            (
                                                0 // Offset is not required in full rate
                                            ) :
                                            (
                                                (CFG_CTL_ARBITER_TYPE == "COLROW") ? 0 : 1 // Need offset in COLROW arbiter mode
                                            )
                                    );
    localparam SB_TO_ROW_OFFSET  =  COL_TO_ROW_OFFSET; // Similar to COL_TO_ROW parameter
    
    //----------------------------------------------------------------------------------------------------
    // Common timing parameters, not memory type specific
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            t_param_act_to_rdwr          <= 0;
            t_param_act_to_pch           <= 0;
            t_param_act_to_act           <= 0;
            t_param_pch_to_valid         <= 0;
            t_param_act_to_act_diff_bank <= 0;
            t_param_four_act_to_act      <= 0;
            t_param_arf_to_valid         <= 0;
            t_param_pdn_to_valid         <= 0;
            t_param_srf_to_valid         <= 0;
            t_param_arf_period           <= 0;
            t_param_pdn_period           <= 0;
            t_param_power_saving_exit    <= 0;
        end
        else
        begin
            // Set act_to_rdwr to '0' when additive latency is enabled
            if (cfg_add_lat >= (cfg_trcd - 1))
                t_param_act_to_rdwr      <= 0                                                                                                                        + ROW_TO_COL_OFFSET + cfg_extra_ctl_clk_act_to_rdwr         ;
            else
                t_param_act_to_rdwr      <= ((cfg_trcd - cfg_add_lat)     / DIV) + (((cfg_trcd - cfg_add_lat)     % DIV_ROW_TO_COL) > DIV_ROW_TO_COL_OFFSET ? 1 : 0) + ROW_TO_COL_OFFSET + cfg_extra_ctl_clk_act_to_rdwr         ;          // ACT to RD/WR                         - tRCD
            
            t_param_act_to_pch           <= (cfg_tras                     / DIV) + ((cfg_tras                     % DIV_ROW_TO_ROW) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) + ROW_TO_ROW_OFFSET + cfg_extra_ctl_clk_act_to_pch          ;          // ACT to PCH                           - tRAS
            t_param_act_to_act           <= (cfg_trc                      / DIV) + ((cfg_trc                      % DIV_ROW_TO_ROW) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) + ROW_TO_ROW_OFFSET + cfg_extra_ctl_clk_act_to_act          ;          // ACT to ACT (same bank)               - tRC
            
            t_param_pch_to_valid         <= (cfg_trp                      / DIV) + ((cfg_trp                      % DIV_ROW_TO_ROW) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) + ROW_TO_ROW_OFFSET + cfg_extra_ctl_clk_pch_to_valid        ;          // PCH to ACT                           - tRP
            
            t_param_act_to_act_diff_bank <= (cfg_trrd                     / DIV) + ((cfg_trrd                     % DIV_ROW_TO_ROW) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) + ROW_TO_ROW_OFFSET + cfg_extra_ctl_clk_act_to_act_diff_bank;          // ACT to ACT (diff banks)              - tRRD
            t_param_four_act_to_act      <= (cfg_tfaw                     / DIV) + ((cfg_tfaw                     % DIV_ROW_TO_ROW) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) + ROW_TO_ROW_OFFSET + cfg_extra_ctl_clk_four_act_to_act     ;          // Valid window for 4 ACT               - tFAW
            
            t_param_arf_to_valid         <= (cfg_trfc                     / DIV) + ((cfg_trfc                     % DIV_SB_TO_ROW ) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) +  SB_TO_ROW_OFFSET + cfg_extra_ctl_clk_arf_to_valid        ;          // ARF to VALID                         - tRFC
            t_param_pdn_to_valid         <= (cfg_pdn_exit_cycles          / DIV) + ((cfg_pdn_exit_cycles          % DIV_SB_TO_ROW ) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) +  SB_TO_ROW_OFFSET + cfg_extra_ctl_clk_pdn_to_valid        ;          // PDN to VALID                         - normally 3 clock cycles
            t_param_srf_to_valid         <= (cfg_self_rfsh_exit_cycles    / DIV) + ((cfg_self_rfsh_exit_cycles    % DIV_SB_TO_ROW ) > DIV_ROW_TO_ROW_OFFSET ? 1 : 0) +  SB_TO_ROW_OFFSET + cfg_extra_ctl_clk_srf_to_valid        ;          // SRF to VALID                         - normally 200 clock cycles
            
            t_param_arf_period           <= (cfg_trefi                    / DIV) + ((cfg_trefi                    % DIV_SB_TO_SB  ) > DIV_SB_TO_SB_OFFSET   ? 1 : 0) +   SB_TO_SB_OFFSET + cfg_extra_ctl_clk_arf_period          ;          // ARF period                           - tREFI
            t_param_pdn_period           <= cfg_auto_pd_cycles                                                                                                       +   SB_TO_SB_OFFSET + cfg_extra_ctl_clk_pdn_period          ;          // PDN count after TBP is empty         - specified by user
            
            t_param_power_saving_exit    <= (cfg_power_saving_exit_cycles / DIV) + ((cfg_power_saving_exit_cycles % DIV_SB_TO_SB  ) > DIV_SB_TO_SB_OFFSET   ? 1 : 0) +   SB_TO_SB_OFFSET                                         ;          // SRF and PDN exit cycles
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Memory type specific timing parameters
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            t_param_rd_to_rd            <= 0;
            t_param_rd_to_rd_diff_chip  <= 0;
            t_param_rd_to_wr            <= 0;
            t_param_rd_to_wr_bc         <= 0;
            t_param_rd_to_wr_diff_chip  <= 0;
            t_param_rd_to_pch           <= 0;
            t_param_rd_ap_to_valid      <= 0;
            t_param_wr_to_wr            <= 0;
            t_param_wr_to_wr_diff_chip  <= 0;
            t_param_wr_to_rd            <= 0;
            t_param_wr_to_rd_bc         <= 0;
            t_param_wr_to_rd_diff_chip  <= 0;
            t_param_wr_to_pch           <= 0;
            t_param_wr_ap_to_valid      <= 0;
            t_param_pch_all_to_valid    <= 0;
            t_param_srf_to_zq_cal       <= 0;
        end
        else
        begin
            if (cfg_type == `MMR_TYPE_DDR1)
            begin
                // DDR
                // ******************************
                // Note, if the below formulas are changed then the formulas in the report_timing_core.tcl files need to be changed
                // to remain consistent with the controller
                // ******************************
                t_param_rd_to_rd            <= (cfg_tccd / DIV)                                         + ((cfg_tccd % DIV_COL_TO_COL)                                         > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd          ;      // RD to RD             - tCCD
                t_param_rd_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                             + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd_diff_chip;      // RD to RD diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_rd_to_wr            <= (((cfg_burst_length / 2) + cfg_tcl) / DIV)               + ((((cfg_burst_length / 2) + cfg_tcl) % DIV_COL_TO_COL)               > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr          ;      // RD to WR             - RL + (BL/2)
                t_param_rd_to_wr_bc         <= 0                                                                                                                                                                + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_bc       ;      // RDBC to WR           - 0, DDR3 specific only
                t_param_rd_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                     + ((((cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_diff_chip;      // RD to WR diff rank   - Same as RD to WR
                t_param_rd_to_pch           <= ((cfg_burst_length / 2) / DIV)                           + (((cfg_burst_length / 2) % DIV_COL_TO_ROW)                           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_to_pch         ;      // RD to PCH            - (BL/2)
                t_param_rd_ap_to_valid      <= (((cfg_burst_length / 2) + cfg_trp) / DIV)               + ((((cfg_burst_length / 2) + cfg_trp) % DIV_COL_TO_ROW)               > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_ap_to_valid    ;      // RDAP to VALID        - RD to PCH + PCH to VALID
                
                t_param_wr_to_wr            <= (cfg_tccd / DIV)                                         + ((cfg_tccd % DIV_COL_TO_COL)                                         > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr          ;      // WR to WR             - tCCD
                t_param_wr_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                             + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr_diff_chip;      // WR to WR diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_wr_to_rd            <= ((1 + (cfg_burst_length / 2) + cfg_twtr) / DIV)          + (((1 + (cfg_burst_length / 2) + cfg_twtr) % DIV_COL_TO_COL)          > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd          ;      // WR to RD             - WL + (BL/2) + tWTR, WL always 1
                t_param_wr_to_rd_bc         <= 0                                                                                                                                                                + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_bc       ;      // WRBC to RD           - 0, DDR3 specific only
                t_param_wr_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 3) / DIV)                     + ((((cfg_burst_length / 2) + 3) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_diff_chip;      // WR to RD diff rank   - 1 + (BL/2) + 2, extra 2 dead cycles for DQS post and preamble
                t_param_wr_to_pch           <= ((1 + (cfg_burst_length / 2) + cfg_twr) / DIV)           + (((1 + (cfg_burst_length / 2) + cfg_twr) % DIV_COL_TO_ROW)           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_to_pch         ;      // WR to PCH            - WL + (BL/2) + tWR
                t_param_wr_ap_to_valid      <= ((1 + (cfg_burst_length / 2) + cfg_twr + cfg_trp) / DIV) + (((1 + (cfg_burst_length / 2) + cfg_twr + cfg_trp) % DIV_COL_TO_ROW) > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_ap_to_valid    ;      // WRAP to VALID        - WR to PCH + PCH to VALID
                
                t_param_pch_all_to_valid    <= ((cfg_trp + 1) / DIV)                                    + (((cfg_trp + 1) % DIV_SB_TO_ROW )                                    > DIV_SB_TO_ROW_OFFSET  ? 1 : 0) + SB_TO_ROW_OFFSET  + cfg_extra_ctl_clk_pch_all_to_valid  ;      // PCHALL to VALID      - tRPA = tRP + 1
                
                t_param_srf_to_zq_cal       <= 0                                                                                                                                                                + SB_TO_SB_OFFSET   + cfg_extra_ctl_clk_srf_to_zq_cal     ;      // SRF to ZQ CAL        - 0, DDR3 specific only
            end
            else if (cfg_type == `MMR_TYPE_DDR2)
            begin
                // DDR2
                // ******************************
                // Note, if the below formulas are changed then the formulas in the report_timing_core.tcl files need to be changed
                // to remain consistent with the controller
                // ******************************
                t_param_rd_to_rd            <= (cfg_tccd / DIV)                                                                 + ((cfg_tccd % DIV_COL_TO_COL)                                                                 > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd          ;      // RD to RD             - tCCD
                t_param_rd_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                                                                             + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd_diff_chip;      // RD to RD diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_rd_to_wr            <= (((cfg_burst_length / 2) + 2) / DIV)                                             + ((((cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                                             > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr          ;      // RD to WR             - RL - WL + (BL/2) + 1, (RL - WL) will always be '1'
                t_param_rd_to_wr_bc         <= 0                                                                                                                                                                                                                + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_bc       ;      // RDBC to WR           - 0, DDR3 specific only
                t_param_rd_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                             + ((((cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                                             > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_diff_chip;      // RD to WR diff rank   - Same as RD to WR
                t_param_rd_to_pch           <= ((cfg_add_lat + (cfg_burst_length / 2) - 2 + max(cfg_trtp, 2)) / DIV)            + (((cfg_add_lat + (cfg_burst_length / 2) - 2 + max(cfg_trtp, 2)) % DIV_COL_TO_ROW)            > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_to_pch         ;      // RD to PCH            - AL + (BL/2) - 2 + max(tRTP or 2)
                t_param_rd_ap_to_valid      <= ((cfg_add_lat + (cfg_burst_length / 2) - 2 + max(cfg_trtp, 2) + cfg_trp) / DIV)  + (((cfg_add_lat + (cfg_burst_length / 2) - 2 + max(cfg_trtp, 2) + cfg_trp) % DIV_COL_TO_ROW)  > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_ap_to_valid    ;      // RDAP to VALID        - RD to PCH + PCH to VALID
                
                t_param_wr_to_wr            <= (cfg_tccd / DIV)                                                                 + ((cfg_tccd % DIV_COL_TO_COL)                                                                 > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr          ;      // WR to WR             - tCCD
                t_param_wr_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                                                                             + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr_diff_chip;      // WR to WR diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_wr_to_rd            <= ((cfg_tcl - 1 + (cfg_burst_length / 2) + cfg_twtr) / DIV)                        + (((cfg_tcl - 1 + (cfg_burst_length / 2) + cfg_twtr) % DIV_COL_TO_COL)                        > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd          ;      // WR to RD             - WL + (BL/2) + tWTR
                t_param_wr_to_rd_bc         <= 0                                                                                                                                                                                                                + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_bc       ;      // WRBC to RD           - 0, DDR3 specific only
                t_param_wr_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 1) / DIV)                                             + ((((cfg_burst_length / 2) + 1) % DIV_COL_TO_COL)                                             > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_diff_chip;      // WR to RD diff rank   - WL - RL + (BL/2) + 2, extra 2 dead cycles for DQS post and preamble
                t_param_wr_to_pch           <= ((cfg_add_lat + cfg_tcl - 1 + (cfg_burst_length / 2) + cfg_twr) / DIV)           + (((cfg_add_lat + cfg_tcl - 1 + (cfg_burst_length / 2) + cfg_twr) % DIV_COL_TO_ROW)           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_to_pch         ;      // WR to PCH            - WL + (BL/2) + tWR
                t_param_wr_ap_to_valid      <= ((cfg_add_lat + cfg_tcl - 1 + (cfg_burst_length / 2) + cfg_twr + cfg_trp) / DIV) + (((cfg_add_lat + cfg_tcl - 1 + (cfg_burst_length / 2) + cfg_twr + cfg_trp) % DIV_COL_TO_ROW) > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_ap_to_valid    ;      // WRAP to VALID        - WR to PCH + PCH to VALID
                
                t_param_pch_all_to_valid    <= ((cfg_trp + 1) / DIV)                                                            + (((cfg_trp + 1) % DIV_SB_TO_ROW )                                                            > DIV_SB_TO_ROW_OFFSET  ? 1 : 0) + SB_TO_ROW_OFFSET  + cfg_extra_ctl_clk_pch_all_to_valid  ;      // PCHALL to VALID      - tRPA = tRP + 1
                
                t_param_srf_to_zq_cal       <= 0                                                                                                                                                                                                                + SB_TO_SB_OFFSET   + cfg_extra_ctl_clk_srf_to_zq_cal     ;      // SRF to ZQ CAL        - 0, DDR3 specific only
            end
            else if (cfg_type == `MMR_TYPE_DDR3)
            begin
                // ******************************
                // Note, if the below formulas are changed then the formulas in the report_timing_core.tcl files need to be changed
                // to remain consistent with the controller
                // ******************************
                t_param_rd_to_rd            <= ((cfg_burst_length / 2) / DIV)                                                                                                                                                                                         + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd          ;       // RD to RD             - BL/2, not tCCD because there is no burst interrupt support in DDR3
                t_param_rd_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                                                                                   + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd_diff_chip;       // RD to RD diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_rd_to_wr            <= ((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 2) / DIV)                     + (((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr          ;       // RD to WR             - RL - WL + (BL/2) + 2
                t_param_rd_to_wr_bc         <= ((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 4) + 2) / DIV)                     + (((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 4) + 2) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_bc       ;       // RDBC to WR           - RL - WL + (BL/4) + 2
                t_param_rd_to_wr_diff_chip  <= ((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 2) / DIV)                     + (((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_diff_chip;       // RD to WR diff rank   - Same as RD to WR
                t_param_rd_to_pch           <= ((cfg_add_lat + max(cfg_trtp, 4)) / DIV)                                            + (((cfg_add_lat + max(cfg_trtp, 4)) % DIV_COL_TO_ROW)                                            > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_to_pch         ;       // RD to PCH            - AL + max(tRTP or 4)
                t_param_rd_ap_to_valid      <= ((cfg_add_lat + max(cfg_trtp, 4) + cfg_trp) / DIV)                                  + (((cfg_add_lat + max(cfg_trtp, 4) + cfg_trp) % DIV_COL_TO_ROW)                                  > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_ap_to_valid    ;       // RDAP to VALID        - RD to PCH + PCH to VALID
                
                t_param_wr_to_wr            <= ((cfg_burst_length / 2) / DIV)                                                                                                                                                                                         + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr          ;       // WR to WR             - BL/2, not tCCD because there is no burst interrupt support in DDR3
                t_param_wr_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                                                                                   + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr_diff_chip;       // WR to WR diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_wr_to_rd            <= ((cfg_cas_wr_lat + (cfg_burst_length / 2) + max(cfg_twtr, 4)) / DIV)                + (((cfg_cas_wr_lat + (cfg_burst_length / 2) + max(cfg_twtr, 4)) % DIV_COL_TO_COL)                > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd          ;       // WR to RD             - WL + (BL/2) + max(tWTR or 4)
                t_param_wr_to_rd_bc         <= ((cfg_cas_wr_lat + (cfg_burst_length / 2) + max(cfg_twtr, 4)) / DIV)                + (((cfg_cas_wr_lat + (cfg_burst_length / 2) + max(cfg_twtr, 4)) % DIV_COL_TO_COL)                > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_bc       ;       // WRBC to RD           - Same as WR to RD
                t_param_wr_to_rd_diff_chip  <= (((cfg_cas_wr_lat - cfg_tcl) + (cfg_burst_length / 2) + 2) / DIV)                   + ((((cfg_cas_wr_lat - cfg_tcl) + (cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                   > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_diff_chip;       // WR to RD diff rank   - WL - RL + (BL/2) + 2, extra 2 dead cycles for DQS post and preamble
                t_param_wr_to_pch           <= ((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr) / DIV)           + (((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr) % DIV_COL_TO_ROW)           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_to_pch         ;       // WR to PCH            - WL + (BL/2) + tWR
                t_param_wr_ap_to_valid      <= ((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr + cfg_trp) / DIV) + (((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr + cfg_trp) % DIV_COL_TO_ROW) > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_ap_to_valid    ;       // WRAP to VALID        - WR to PCH + PCH to VALID
                
                t_param_pch_all_to_valid    <= (cfg_trp / DIV)                                                                     + ((cfg_trp % DIV_SB_TO_ROW )                                                                     > DIV_SB_TO_ROW_OFFSET  ? 1 : 0) + SB_TO_ROW_OFFSET  + cfg_extra_ctl_clk_pch_all_to_valid  ;       // PCHALL to VALID      - tRP
                
                t_param_srf_to_zq_cal       <= ((cfg_self_rfsh_exit_cycles / 2) / DIV)                                                                                                                                                                                + SB_TO_SB_OFFSET   + cfg_extra_ctl_clk_srf_to_zq_cal     ;       // SRF to ZQ CAL        - SRF exit time divided by 2
            end
            else if (cfg_type == `MMR_TYPE_LPDDR1)
            begin
                // LPDDR
                // ******************************
                // Note, if the below formulas are changed then the formulas in the report_timing_core.tcl files need to be changed
                // to remain consistent with the controller
                // ******************************
                t_param_rd_to_rd            <= (cfg_tccd / DIV)                                         + ((cfg_tccd % DIV_COL_TO_COL)                                         > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd          ;      // RD to RD             - tCCD
                t_param_rd_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                             + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd_diff_chip;      // RD to RD diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_rd_to_wr            <= (((cfg_burst_length / 2) + cfg_tcl) / DIV)               + ((((cfg_burst_length / 2) + cfg_tcl) % DIV_COL_TO_COL)               > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr          ;      // RD to WR             - RL + (BL/2)
                t_param_rd_to_wr_bc         <= 0                                                                                                                                                                + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_bc       ;      // RDBC to WR           - 0, DDR3 specific only
                t_param_rd_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                     + ((((cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_diff_chip;      // RD to WR diff rank   - Same as RD to WR
                t_param_rd_to_pch           <= ((cfg_burst_length / 2) / DIV)                           + (((cfg_burst_length / 2) % DIV_COL_TO_ROW)                           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_to_pch         ;      // RD to PCH            - (BL/2)
                t_param_rd_ap_to_valid      <= (((cfg_burst_length / 2) + cfg_trp) / DIV)               + ((((cfg_burst_length / 2) + cfg_trp) % DIV_COL_TO_ROW)               > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_ap_to_valid    ;      // RDAP to VALID        - RD to PCH + PCH to VALID
                
                t_param_wr_to_wr            <= (cfg_tccd / DIV)                                         + ((cfg_tccd % DIV_COL_TO_COL)                                         > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr          ;      // WR to WR             - tCCD
                t_param_wr_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                             + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr_diff_chip;      // WR to WR diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_wr_to_rd            <= ((1 + (cfg_burst_length / 2) + cfg_twtr) / DIV)          + (((1 + (cfg_burst_length / 2) + cfg_twtr) % DIV_COL_TO_COL)          > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd          ;      // WR to RD             - WL + (BL/2) + tWTR, WL always 1
                t_param_wr_to_rd_bc         <= 0                                                                                                                                                                + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_bc       ;      // WRBC to RD           - 0, DDR3 specific only
                t_param_wr_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 3) / DIV)                     + ((((cfg_burst_length / 2) + 3) % DIV_COL_TO_COL)                     > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_diff_chip;      // WR to RD diff rank   - 1 + (BL/2) + 2, extra 2 dead cycles for DQS post and preamble
                t_param_wr_to_pch           <= ((1 + (cfg_burst_length / 2) + cfg_twr) / DIV)           + (((1 + (cfg_burst_length / 2) + cfg_twr) % DIV_COL_TO_ROW)           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_to_pch         ;      // WR to PCH            - WL + (BL/2) + tWR
                t_param_wr_ap_to_valid      <= ((1 + (cfg_burst_length / 2) + cfg_twr + cfg_trp) / DIV) + (((1 + (cfg_burst_length / 2) + cfg_twr + cfg_trp) % DIV_COL_TO_ROW) > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_ap_to_valid    ;      // WRAP to VALID        - WR to PCH + PCH to VALID
                
                t_param_pch_all_to_valid    <= ((cfg_trp + 1) / DIV)                                    + (((cfg_trp + 1) % DIV_SB_TO_ROW )                                    > DIV_SB_TO_ROW_OFFSET  ? 1 : 0) + SB_TO_ROW_OFFSET  + cfg_extra_ctl_clk_pch_all_to_valid  ;      // PCHALL to VALID      - tRPA = tRP + 1
                
                t_param_srf_to_zq_cal       <= 0                                                                                                                                                                + SB_TO_SB_OFFSET   + cfg_extra_ctl_clk_srf_to_zq_cal     ;      // SRF to ZQ CAL        - 0, DDR3 specific only
            end
            else if (cfg_type == `MMR_TYPE_LPDDR2)
            begin
                // LPDDR2
                // ******************************
                // Note, if the below formulas are changed then the formulas in the report_timing_core.tcl files need to be changed
                // to remain consistent with the controller
                // ******************************
                t_param_rd_to_rd            <= (cfg_tccd / DIV)                                                                        + ((cfg_tccd % DIV_COL_TO_COL)                                                                        > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd          ;      // RD to RD             - tCCD
                t_param_rd_to_rd_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                                                                                           + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_rd_diff_chip;      // RD to RD diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_rd_to_wr            <= ((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 1) / DIV)                         + (((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 1) % DIV_COL_TO_COL)                         > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr          ;       // RD to WR             - RL - WL + (BL/2) + 2
                t_param_rd_to_wr_bc         <= 0                                                                                                                                                                                                                              + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_bc       ;      // RDBC to WR           - 0, DDR3 specific only
                t_param_rd_to_wr_diff_chip  <= ((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 1) / DIV)                         + (((cfg_tcl - cfg_cas_wr_lat + (cfg_burst_length / 2) + 1) % DIV_COL_TO_COL)                         > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_rd_to_wr_diff_chip;       // RD to WR diff rank   - Same as RD to WR
                t_param_rd_to_pch           <= ((cfg_add_lat + (cfg_burst_length / 2) - cfg_tccd + max(cfg_trtp, 2)) / DIV)            + (((cfg_add_lat + (cfg_burst_length / 2) - cfg_tccd + max(cfg_trtp, 2)) % DIV_COL_TO_ROW)            > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_to_pch         ;      // RD to PCH            - AL + (BL/2) - 2 + max(tRTP or 2)
                t_param_rd_ap_to_valid      <= ((cfg_add_lat + (cfg_burst_length / 2) - cfg_tccd + max(cfg_trtp, 2) + cfg_trp) / DIV)  + (((cfg_add_lat + (cfg_burst_length / 2) - cfg_tccd + max(cfg_trtp, 2) + cfg_trp) % DIV_COL_TO_ROW)  > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_rd_ap_to_valid    ;      // RDAP to VALID        - RD to PCH + PCH to VALID
                
                t_param_wr_to_wr            <= (cfg_tccd / DIV)                                                                        + ((cfg_tccd % DIV_COL_TO_COL)                                                                        > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr          ;      // WR to WR             - tCCD
                t_param_wr_to_wr_diff_chip  <= (((cfg_burst_length / 2) + 2) / DIV)                                                                                                                                                                                           + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_wr_diff_chip;      // WR to WR diff rank   - (BL/2) + 2 (dead cycle), should be set to tCCD for burst interrupt support
                t_param_wr_to_rd            <= ((cfg_cas_wr_lat + (cfg_burst_length / 2) + max(cfg_twtr, 2) + 1) / DIV)                + (((cfg_cas_wr_lat + (cfg_burst_length / 2) + max(cfg_twtr, 2) + 1) % DIV_COL_TO_COL)                > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd          ;       // WR to RD             - WL + (BL/2) + max(tWTR or 4)
                t_param_wr_to_rd_bc         <= 0                                                                                                                                                                                                                              + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_bc       ;      // WRBC to RD           - 0, DDR3 specific only
                t_param_wr_to_rd_diff_chip  <= (((cfg_cas_wr_lat - cfg_tcl) + (cfg_burst_length / 2) + 2) / DIV)                       + ((((cfg_cas_wr_lat - cfg_tcl) + (cfg_burst_length / 2) + 2) % DIV_COL_TO_COL)                       > DIV_COL_TO_COL_OFFSET ? 1 : 0) + COL_TO_COL_OFFSET + cfg_extra_ctl_clk_wr_to_rd_diff_chip;       // WR to RD diff rank   - WL - RL + (BL/2) + 2, extra 2 dead cycles for DQS post and preamble
                t_param_wr_to_pch           <= ((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr + 1) / DIV)           + (((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr + 1) % DIV_COL_TO_ROW)           > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_to_pch         ;       // WR to PCH            - WL + (BL/2) + tWR
                t_param_wr_ap_to_valid      <= ((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr + 1 + cfg_trp) / DIV) + (((cfg_add_lat + cfg_cas_wr_lat + (cfg_burst_length / 2) + cfg_twr + 1 + cfg_trp) % DIV_COL_TO_ROW) > DIV_COL_TO_ROW_OFFSET ? 1 : 0) + COL_TO_ROW_OFFSET + cfg_extra_ctl_clk_wr_ap_to_valid    ;       // WRAP to VALID        - WR to PCH + PCH to VALID
                
                t_param_pch_all_to_valid    <= ((cfg_trp + 1) / DIV)                                                                   + (((cfg_trp + 1) % DIV_SB_TO_ROW )                                                                   > DIV_SB_TO_ROW_OFFSET  ? 1 : 0) + SB_TO_ROW_OFFSET  + cfg_extra_ctl_clk_pch_all_to_valid  ;      // PCHALL to VALID      - tRPA = tRP + 1
                
                t_param_srf_to_zq_cal       <= 0                                                                                                                                                                                                                              + SB_TO_SB_OFFSET   + cfg_extra_ctl_clk_srf_to_zq_cal     ;      // SRF to ZQ CAL        - 0, DDR3 specific only
            end
        end
    end
    
    // Function to determine max of 2 inputs
    localparam MAX_FUNCTION_PORT_WIDTH = (CFG_PORT_WIDTH_TRTP > CFG_PORT_WIDTH_TWTR) ? CFG_PORT_WIDTH_TRTP : CFG_PORT_WIDTH_TWTR;
    
    function [MAX_FUNCTION_PORT_WIDTH - 1 : 0] max;
        input [MAX_FUNCTION_PORT_WIDTH - 1 : 0] value1;
        input [MAX_FUNCTION_PORT_WIDTH - 1 : 0] value2;
        begin
            if (value1 > value2)
                max = value1;
            else
                max = value2;
        end
    endfunction
//--------------------------------------------------------------------------------------------------------
//
//  [END] Timing Parameter Calculation
//
//--------------------------------------------------------------------------------------------------------












endmodule
