module alt_mem_ddrx_controller #
	( parameter
        // Local interface parameters
        CFG_LOCAL_SIZE_WIDTH                                =   3,
        CFG_LOCAL_ADDR_WIDTH                                =   32,
        CFG_LOCAL_DATA_WIDTH                                =   80,            // Maximum DQ width of 40
        CFG_LOCAL_ID_WIDTH                                  =   8,
        CFG_LOCAL_IF_TYPE                                   =   "AVALON",
        
        // Memory interface parameters
        CFG_MEM_IF_CHIP                                     =   2,
        CFG_MEM_IF_CS_WIDTH                                 =   1,
        CFG_MEM_IF_BA_WIDTH                                 =   3,
        CFG_MEM_IF_ROW_WIDTH                                =   15,
        CFG_MEM_IF_COL_WIDTH                                =   12,
        CFG_MEM_IF_ADDR_WIDTH                               =   15,
        CFG_MEM_IF_CKE_WIDTH                                =   2,
        CFG_MEM_IF_ODT_WIDTH                                =   2,
        CFG_MEM_IF_CLK_PAIR_COUNT                           =   2,
        CFG_MEM_IF_DQ_WIDTH                                 =   40,
        CFG_MEM_IF_DQS_WIDTH                                =   5,
        CFG_MEM_IF_DM_WIDTH                                 =   5,
        
        // Controller parameters
        CFG_DWIDTH_RATIO                                    =   2,
        CFG_ODT_ENABLED                                     =   1,            // NOTICE: required?
        CFG_OUTPUT_REGD                                     =   0,            // NOTICE: un-used and will be removed
        CFG_CTL_TBP_NUM                                     =   4,
        CFG_LPDDR2_ENABLED                                  =   0,
        CFG_DATA_REORDERING_TYPE                            =   "INTER_BANK",
        CFG_ECC_MULTIPLES_16_24_40_72                       =   1,
        
        // Data path buffer & fifo parameters
        CFG_WRBUFFER_ADDR_WIDTH                             =   6,
        CFG_RDBUFFER_ADDR_WIDTH                             =   10,
        
        // MMR port width
        // cfg: general
        CFG_PORT_WIDTH_TYPE                                 =   3,
        CFG_PORT_WIDTH_INTERFACE_WIDTH                      =   8,
        CFG_PORT_WIDTH_BURST_LENGTH                         =   5,
        CFG_PORT_WIDTH_DEVICE_WIDTH                         =   4,
        CFG_PORT_WIDTH_OUTPUT_REGD                          =   1,
        
        // cfg: address mapping signals
        CFG_PORT_WIDTH_ADDR_ORDER                           =   2,
        CFG_PORT_WIDTH_COL_ADDR_WIDTH                       =   5,
        CFG_PORT_WIDTH_ROW_ADDR_WIDTH                       =   5,
        CFG_PORT_WIDTH_BANK_ADDR_WIDTH                      =   3,
        CFG_PORT_WIDTH_CS_ADDR_WIDTH                        =   3,
        
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
        CFG_PORT_WIDTH_TCCD                                 =   4,          // max will be 8 in DDR3
        CFG_PORT_WIDTH_TMRD                                 =   3,          // 4 - ?        enough?
        CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES                =   10,         // max will be 512 in DDR3
        CFG_PORT_WIDTH_PDN_EXIT_CYCLES                      =   4,          // 3 - ?        enough?
        CFG_PORT_WIDTH_AUTO_PD_CYCLES                       =   16,         // enough?
        CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES             =   4,          // enough?
        CFG_PORT_WIDTH_MEM_CLK_ENTRY_CYCLES                 =   4,          // enough?
        
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
        
        // cfg: control signals
        CFG_PORT_WIDTH_REORDER_DATA                         =   1,
        CFG_PORT_WIDTH_STARVE_LIMIT                         =   6,
        CFG_PORT_WIDTH_USER_RFSH                            =   1,
        CFG_PORT_WIDTH_SELF_RFSH                            =   1,
        CFG_PORT_WIDTH_REGDIMM_ENABLE                       =   1,
        CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT               =   1,
        CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE               =   1,
        CFG_ENABLE_CMD_SPLIT                                = 1'b1, // disable this (set to 0) when using the controller with hard MPFE
        
        // cfg: ecc signals
        CFG_PORT_WIDTH_ENABLE_ECC                           =   1,
        CFG_PORT_WIDTH_ENABLE_AUTO_CORR                     =   1,
        CFG_PORT_WIDTH_GEN_SBE                              =   1,
        CFG_PORT_WIDTH_GEN_DBE                              =   1,
        CFG_PORT_WIDTH_ENABLE_INTR                          =   1,
        CFG_PORT_WIDTH_MASK_SBE_INTR                        =   1,
        CFG_PORT_WIDTH_MASK_DBE_INTR                        =   1,
        CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR               =   1,
        CFG_PORT_WIDTH_CLR_INTR                             =   1,
        CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES           =   1,
        CFG_PORT_WIDTH_ENABLE_NO_DM                         =   1,
        
        // cfg: odt
        CFG_PORT_WIDTH_WRITE_ODT_CHIP                       =   4,
        CFG_PORT_WIDTH_READ_ODT_CHIP                        =   4,
        
        // cfg: ecc signals
        STS_PORT_WIDTH_SBE_ERROR                            =   1,
        STS_PORT_WIDTH_DBE_ERROR                            =   1,
        STS_PORT_WIDTH_CORR_DROP_ERROR                      =   1,
        STS_PORT_WIDTH_SBE_COUNT                            =   8,
        STS_PORT_WIDTH_DBE_COUNT                            =   8,
        STS_PORT_WIDTH_CORR_DROP_COUNT                      =   8,
        
        // PHY parameters
        CFG_WLAT_BUS_WIDTH                                  =   4,
        
        // controller read data return mode
        CFG_RDATA_RETURN_MODE                               = "PASSTHROUGH"
    )
    (
        // Clock and reset
        ctl_clk,
        ctl_reset_n,
        
        // Command channel
        itf_cmd_ready,
        itf_cmd_valid,
        itf_cmd,
        itf_cmd_address,
        itf_cmd_burstlen,
        itf_cmd_id,
        itf_cmd_priority,
        itf_cmd_autopercharge,
        itf_cmd_multicast,
        
        // Write data channel
        itf_wr_data_ready,
        itf_wr_data_valid,
        itf_wr_data,
        itf_wr_data_byte_en,
        itf_wr_data_begin,
        itf_wr_data_last,
        itf_wr_data_id,
        
        // Read data channel
        itf_rd_data_ready,
        itf_rd_data_valid,
        itf_rd_data,
        itf_rd_data_error,
        itf_rd_data_begin,
        itf_rd_data_last,
        itf_rd_data_id,
        itf_rd_data_id_early,                   // only valid when CFG_RDATA_RETURN_MODE == PASSTHROUGH
        itf_rd_data_id_early_valid,             // only valid when CFG_RDATA_RETURN_MODE == PASSTHROUGH
        
        // Sideband signals
        local_refresh_req,
        local_refresh_chip,
        local_deep_powerdn_chip,
        local_deep_powerdn_req,
        local_self_rfsh_req,
        local_self_rfsh_chip,
        local_refresh_ack,
        local_deep_powerdn_ack,
        local_power_down_ack,
        local_self_rfsh_ack,
        local_init_done,
        
        // Controller commands to the AFI interface
        afi_rst_n,
        afi_ba,
        afi_addr,
        afi_cke,
        afi_cs_n,
        afi_ras_n,
        afi_cas_n,
        afi_we_n,
        afi_odt,
        
        // Controller read and write data to the AFI interface
        afi_wlat,
        afi_dqs_burst,
        afi_dm,
        afi_wdata,
        afi_wdata_valid,
        afi_rdata_en,
        afi_rdata_en_full,
        afi_rdata,
        afi_rdata_valid,
        
        // Status and control signal to the AFI interface
        ctl_cal_success,
        ctl_cal_fail,
        ctl_cal_req,
        ctl_init_req,
        ctl_mem_clk_disable,
        ctl_cal_byte_lane_sel_n,
        
        // cfg: general
        cfg_type,
        cfg_interface_width,    // not sure where this signal is used
        cfg_burst_length,
        cfg_device_width,       // not sure where this signal is used
        cfg_output_regd,
        
        // cfg: address mapping signals
        cfg_addr_order,
        cfg_col_addr_width,
        cfg_row_addr_width,
        cfg_bank_addr_width,
        cfg_cs_addr_width,
        
        // cfg: timing parameters
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
        cfg_auto_pd_cycles,
        cfg_self_rfsh_exit_cycles,
        cfg_pdn_exit_cycles,
        cfg_power_saving_exit_cycles,
        cfg_mem_clk_entry_cycles,
        cfg_tmrd,
        
        // cfg: extra timing parameters
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
        
        // cfg: control signals
        cfg_reorder_data,       // enable data reordering
        cfg_starve_limit,       // starvation counter limit
        cfg_user_rfsh,
        cfg_regdimm_enable,
        cfg_enable_burst_interrupt,
        cfg_enable_burst_terminate,
        
        // cfg: ecc signals
        cfg_enable_ecc,
        cfg_enable_auto_corr,
        cfg_enable_ecc_code_overwrites,
        cfg_enable_no_dm,
        cfg_gen_sbe,
        cfg_gen_dbe,
        cfg_enable_intr,
        cfg_mask_sbe_intr,
        cfg_mask_dbe_intr,
        cfg_mask_corr_dropped_intr,
        cfg_clr_intr,
        
        // cfg: odt
        cfg_write_odt_chip,
        cfg_read_odt_chip,
        
        // sts: ecc signals
        ecc_interrupt,
        sts_sbe_error,
        sts_dbe_error,
        sts_corr_dropped,
        sts_sbe_count,
        sts_dbe_count,
        sts_corr_dropped_count,
        sts_err_addr,
        sts_corr_dropped_addr,

        //calibration
        cfg_cal_req,
        sts_cal_fail,
        sts_cal_success,
	
	    // DQS enable tracking
	    cfg_enable_dqs_tracking,  //enable DQS enable tracking support in controller
	    afi_ctl_refresh_done, // Controller asserts this after tRFC is done, also acts as stall ack to phy
	    afi_seq_busy, // Sequencer busy signal to controller, also acts as stall request to ctlr
	    afi_ctl_long_idle // Controller asserts this after long period of no refresh, protocol is the same as rfsh_done
	
    );

// General parameters
localparam CFG_MEM_IF_DQ_PER_DQS                           = CFG_MEM_IF_DQ_WIDTH / CFG_MEM_IF_DQS_WIDTH;
localparam CFG_INT_SIZE_WIDTH                              = (CFG_DWIDTH_RATIO == 2) ? 4 : ((CFG_DWIDTH_RATIO == 4) ? 3 : ((CFG_DWIDTH_RATIO == 8) ? 2 : 4));
localparam CFG_CTL_QUEUE_DEPTH                             = 8;
localparam CFG_ENABLE_QUEUE                                = 0;
localparam CFG_ENABLE_BURST_MERGE                          = 0;
localparam CFG_CMD_GEN_OUTPUT_REG                          = 1;                 // only in effect when CFG_ENABLE_QUEUE is set to '0'
localparam CFG_CTL_ARBITER_TYPE                            = "ROWCOL";
localparam CFG_AFI_INTF_PHASE_NUM                          = 2;
localparam CFG_ECC_DATA_WIDTH                              = CFG_MEM_IF_DQ_WIDTH  * CFG_DWIDTH_RATIO;
localparam CFG_ECC_DM_WIDTH                                = CFG_ECC_DATA_WIDTH / CFG_MEM_IF_DQ_PER_DQS;
localparam CFG_ECC_CODE_WIDTH                              = 8;
localparam CFG_ECC_MULTIPLES                               = CFG_DWIDTH_RATIO * CFG_ECC_MULTIPLES_16_24_40_72;
localparam CFG_PARTIAL_BE_PER_WORD_ENABLE                  = 1;
localparam CFG_ENABLE_BURST_GEN_OUTPUT_REG                 = 1;
localparam CFG_DISABLE_PRIORITY                            = 1;
localparam CFG_REG_GRANT                                   = (CFG_DWIDTH_RATIO == 8) ? 0 : 1; // disable grant register for better efficiency in quarter rate
localparam CFG_REG_REQ                                     = 0;
localparam CFG_RANK_TIMER_OUTPUT_REG                       = 1;
localparam CFG_ECC_DEC_REG                                 = 1;
localparam CFG_ECC_RDATA_REG                               = 1;
localparam CFG_ECC_ENC_REG                                 = 1;                 // only one of CFG_ECC_ENC_REG / CFG_WDATA_REG can be set to '1'
localparam CFG_WDATA_REG                                   = 0;                 // only one of CFG_ECC_ENC_REG / CFG_WDATA_REG can be set to '1'
localparam CFG_DISABLE_READ_REODERING                      = 0;
localparam CFG_ENABLE_SHADOW_TBP                           = 0;
localparam CFG_CTL_SHADOW_TBP_NUM                          = CFG_CTL_TBP_NUM;    // similar to TBP number

// Datapath buffer & fifo size calculation
localparam CFG_MAX_PENDING_RD_CMD                          = 16;                // temporary
localparam CFG_MAX_PENDING_WR_CMD                          = 8;                 // temporary
localparam CFG_MAX_PENDING_ERR_CMD                         = 8;                 // temporary

localparam CFG_MAX_PENDING_RD_CMD_WIDTH                    = log2(CFG_MAX_PENDING_RD_CMD);
localparam CFG_WRDATA_ID_WIDTH                             = log2(CFG_MAX_PENDING_WR_CMD);
localparam CFG_ERRCMD_FIFO_ADDR_WIDTH                      = log2(CFG_MAX_PENDING_ERR_CMD);
localparam CFG_RDDATA_ID_WIDTH                             = CFG_RDBUFFER_ADDR_WIDTH - CFG_INT_SIZE_WIDTH;
localparam CFG_DATA_ID_WIDTH                               = (CFG_WRDATA_ID_WIDTH >= CFG_RDDATA_ID_WIDTH) ? CFG_WRDATA_ID_WIDTH : CFG_RDDATA_ID_WIDTH;
localparam integer CFG_DATA_ID_REMAINDER                   = 2**(CFG_WRDATA_ID_WIDTH-CFG_DATA_ID_WIDTH);
localparam CFG_WRDATA_VEC_ID_WIDTH                         = CFG_MAX_PENDING_WR_CMD;

// AFI 
localparam CFG_ADDR_RATE_RATIO                             = (CFG_LPDDR2_ENABLED == 1) ? 2 : 1;
localparam CFG_AFI_IF_FR_ADDR_WIDTH                        = CFG_ADDR_RATE_RATIO * CFG_MEM_IF_ADDR_WIDTH;
localparam CFG_DRAM_WLAT_GROUP                             = (CFG_WLAT_BUS_WIDTH <= 6) ? 1 : CFG_MEM_IF_DQS_WIDTH; // Supports single / multiple DQS group of afi_wlat
localparam CFG_LOCAL_WLAT_GROUP                            = (CFG_WLAT_BUS_WIDTH <= 6) ? 1 : (((CFG_LOCAL_DATA_WIDTH / CFG_DWIDTH_RATIO) == CFG_MEM_IF_DQ_WIDTH) ? CFG_MEM_IF_DQS_WIDTH : CFG_MEM_IF_DQS_WIDTH - CFG_ECC_MULTIPLES_16_24_40_72); // Determine the wlat group for local data width (without ECC code)

// Derived timing parameters width
localparam T_PARAM_ACT_TO_RDWR_WIDTH                                  = 6;        // temporary
localparam T_PARAM_ACT_TO_PCH_WIDTH                                   = 6;        // temporary
localparam T_PARAM_ACT_TO_ACT_WIDTH                                   = 6;        // temporary
localparam T_PARAM_RD_TO_RD_WIDTH                                     = 6;        // temporary
localparam T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH                           = 6;        // temporary
localparam T_PARAM_RD_TO_WR_WIDTH                                     = 6;        // temporary
localparam T_PARAM_RD_TO_WR_BC_WIDTH                                  = 6;        // temporary
localparam T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH                           = 6;        // temporary
localparam T_PARAM_RD_TO_PCH_WIDTH                                    = 6;        // temporary
localparam T_PARAM_RD_AP_TO_VALID_WIDTH                               = 6;        // temporary
localparam T_PARAM_WR_TO_WR_WIDTH                                     = 6;        // temporary
localparam T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH                           = 6;        // temporary
localparam T_PARAM_WR_TO_RD_WIDTH                                     = 6;        // temporary
localparam T_PARAM_WR_TO_RD_BC_WIDTH                                  = 6;        // temporary
localparam T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH                           = 6;        // temporary
localparam T_PARAM_WR_TO_PCH_WIDTH                                    = 6;        // temporary
localparam T_PARAM_WR_AP_TO_VALID_WIDTH                               = 6;        // temporary
localparam T_PARAM_PCH_TO_VALID_WIDTH                                 = 6;        // temporary
localparam T_PARAM_PCH_ALL_TO_VALID_WIDTH                             = 6;        // temporary
localparam T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH                         = 6;        // temporary
localparam T_PARAM_FOUR_ACT_TO_ACT_WIDTH                              = 6;        // temporary
localparam T_PARAM_ARF_TO_VALID_WIDTH                                 = 8;        // temporary
localparam T_PARAM_PDN_TO_VALID_WIDTH                                 = 6;        // temporary
localparam T_PARAM_SRF_TO_VALID_WIDTH                                 = 10;       // temporary
localparam T_PARAM_SRF_TO_ZQ_CAL_WIDTH                                = 10;       // temporary
localparam T_PARAM_ARF_PERIOD_WIDTH                                   = 13;       // temporary
localparam T_PARAM_PDN_PERIOD_WIDTH                                   = 16;       // temporary
localparam T_PARAM_POWER_SAVING_EXIT_WIDTH                            = 6;        // temporary

localparam integer CFG_DATAID_ARRAY_DEPTH                             = 2**CFG_DATA_ID_WIDTH;
localparam integer CFG_WRDATA_ID_WIDTH_SQRD                           = 2**CFG_WRDATA_ID_WIDTH;

// Clock and reset
input  ctl_clk;
input  ctl_reset_n;

// Command channel
output                                 itf_cmd_ready;
input                                  itf_cmd_valid;
input                                  itf_cmd;
input  [CFG_LOCAL_ADDR_WIDTH  - 1 : 0] itf_cmd_address;
input  [CFG_LOCAL_SIZE_WIDTH  - 1 : 0] itf_cmd_burstlen;
input  [CFG_LOCAL_ID_WIDTH - 1 : 0]    itf_cmd_id;
input                                  itf_cmd_priority;
input                                  itf_cmd_autopercharge;
input                                  itf_cmd_multicast;

// Write data channel
output                                    itf_wr_data_ready;
input                                     itf_wr_data_valid;
input  [CFG_LOCAL_DATA_WIDTH     - 1 : 0] itf_wr_data;
input  [CFG_LOCAL_DATA_WIDTH / 8 - 1 : 0] itf_wr_data_byte_en;
input                                     itf_wr_data_begin;
input                                     itf_wr_data_last;
input  [CFG_LOCAL_ID_WIDTH       - 1 : 0] itf_wr_data_id;

// Read data channel
input                                 itf_rd_data_ready;
output                                itf_rd_data_valid;
output [CFG_LOCAL_DATA_WIDTH - 1 : 0] itf_rd_data;
output                                itf_rd_data_error;
output                                itf_rd_data_begin;
output                                itf_rd_data_last;
output [CFG_LOCAL_ID_WIDTH   - 1 : 0] itf_rd_data_id;
output [CFG_LOCAL_ID_WIDTH   - 1 : 0] itf_rd_data_id_early;
output                                itf_rd_data_id_early_valid;

// Sideband signals
input                            local_refresh_req;
input  [CFG_MEM_IF_CHIP - 1 : 0] local_refresh_chip;
input                            local_deep_powerdn_req;
input  [CFG_MEM_IF_CHIP-1:0]     local_deep_powerdn_chip;
input                            local_self_rfsh_req;
input  [CFG_MEM_IF_CHIP - 1 : 0] local_self_rfsh_chip;
output                           local_refresh_ack;
output                           local_deep_powerdn_ack;
output                           local_power_down_ack;
output                           local_self_rfsh_ack;
output                           local_init_done;

// Controller commands to the AFI interface
output [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_rst_n;
output [(CFG_MEM_IF_BA_WIDTH   * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_ba;
output [(CFG_AFI_IF_FR_ADDR_WIDTH*(CFG_DWIDTH_RATIO / 2))- 1 : 0] afi_addr;
output [(CFG_MEM_IF_CKE_WIDTH  * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_cke;
output [(CFG_MEM_IF_CHIP       * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_cs_n;
output [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_ras_n;
output [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_cas_n;
output [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_we_n;
output [(CFG_MEM_IF_ODT_WIDTH  * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_odt;

// Controller read and write data to the AFI interface
input  [CFG_WLAT_BUS_WIDTH                            - 1 : 0] afi_wlat;
output [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2) - 1 : 0] afi_dqs_burst;
output [CFG_MEM_IF_DM_WIDTH * CFG_DWIDTH_RATIO        - 1 : 0] afi_dm;
output [CFG_MEM_IF_DQ_WIDTH * CFG_DWIDTH_RATIO        - 1 : 0] afi_wdata;
output [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2) - 1 : 0] afi_wdata_valid;
output [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2) - 1 : 0] afi_rdata_en;
output [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2) - 1 : 0] afi_rdata_en_full;
input  [CFG_MEM_IF_DQ_WIDTH * CFG_DWIDTH_RATIO        - 1 : 0] afi_rdata;
input  [CFG_DWIDTH_RATIO / 2                          - 1 : 0] afi_rdata_valid;

// Status and control signal to the AFI interface
input                                                     ctl_cal_success;
input                                                     ctl_cal_fail;
output                                                    ctl_cal_req;
output                                                    ctl_init_req;
output [CFG_MEM_IF_DQS_WIDTH * CFG_MEM_IF_CHIP   - 1 : 0] ctl_cal_byte_lane_sel_n ;
output [CFG_MEM_IF_CLK_PAIR_COUNT                - 1 : 0] ctl_mem_clk_disable;

// cfg: general
input  [CFG_PORT_WIDTH_TYPE            - 1 : 0] cfg_type;
input  [CFG_PORT_WIDTH_INTERFACE_WIDTH - 1 : 0] cfg_interface_width;
input  [CFG_PORT_WIDTH_BURST_LENGTH    - 1 : 0] cfg_burst_length;
input  [CFG_PORT_WIDTH_DEVICE_WIDTH    - 1 : 0] cfg_device_width;
input  [CFG_PORT_WIDTH_OUTPUT_REGD     - 1 : 0] cfg_output_regd;

// cfg: address mapping signals
input  [CFG_PORT_WIDTH_ADDR_ORDER      - 1 : 0] cfg_addr_order;
input  [CFG_PORT_WIDTH_COL_ADDR_WIDTH  - 1 : 0] cfg_col_addr_width;
input  [CFG_PORT_WIDTH_ROW_ADDR_WIDTH  - 1 : 0] cfg_row_addr_width;
input  [CFG_PORT_WIDTH_BANK_ADDR_WIDTH - 1 : 0] cfg_bank_addr_width;
input  [CFG_PORT_WIDTH_CS_ADDR_WIDTH   - 1 : 0] cfg_cs_addr_width;

// cfg: timing parameters
input  [CFG_PORT_WIDTH_CAS_WR_LAT               - 1 : 0] cfg_cas_wr_lat;
input  [CFG_PORT_WIDTH_ADD_LAT                  - 1 : 0] cfg_add_lat;
input  [CFG_PORT_WIDTH_TCL                      - 1 : 0] cfg_tcl;
input  [CFG_PORT_WIDTH_TRRD                     - 1 : 0] cfg_trrd;
input  [CFG_PORT_WIDTH_TFAW                     - 1 : 0] cfg_tfaw;
input  [CFG_PORT_WIDTH_TRFC                     - 1 : 0] cfg_trfc;
input  [CFG_PORT_WIDTH_TREFI                    - 1 : 0] cfg_trefi;
input  [CFG_PORT_WIDTH_TRCD                     - 1 : 0] cfg_trcd;
input  [CFG_PORT_WIDTH_TRP                      - 1 : 0] cfg_trp;
input  [CFG_PORT_WIDTH_TWR                      - 1 : 0] cfg_twr;
input  [CFG_PORT_WIDTH_TWTR                     - 1 : 0] cfg_twtr;
input  [CFG_PORT_WIDTH_TRTP                     - 1 : 0] cfg_trtp;
input  [CFG_PORT_WIDTH_TRAS                     - 1 : 0] cfg_tras;
input  [CFG_PORT_WIDTH_TRC                      - 1 : 0] cfg_trc;
input  [CFG_PORT_WIDTH_TCCD                     - 1 : 0] cfg_tccd;
input  [CFG_PORT_WIDTH_AUTO_PD_CYCLES           - 1 : 0] cfg_auto_pd_cycles;
input  [CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES    - 1 : 0] cfg_self_rfsh_exit_cycles;
input  [CFG_PORT_WIDTH_PDN_EXIT_CYCLES          - 1 : 0] cfg_pdn_exit_cycles;
input  [CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES - 1 : 0] cfg_power_saving_exit_cycles;
input  [CFG_PORT_WIDTH_MEM_CLK_ENTRY_CYCLES     - 1 : 0] cfg_mem_clk_entry_cycles;
input  [CFG_PORT_WIDTH_TMRD                     - 1 : 0] cfg_tmrd;

// cfg: extra timing parameters
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

// cfg: control signals
input  [CFG_PORT_WIDTH_REORDER_DATA                 - 1 : 0] cfg_reorder_data;
input  [CFG_PORT_WIDTH_STARVE_LIMIT                 - 1 : 0] cfg_starve_limit;
input  [CFG_PORT_WIDTH_USER_RFSH                    - 1 : 0] cfg_user_rfsh;
input  [CFG_PORT_WIDTH_REGDIMM_ENABLE               - 1 : 0] cfg_regdimm_enable;
input  [CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT       - 1 : 0] cfg_enable_burst_interrupt;
input  [CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE       - 1 : 0] cfg_enable_burst_terminate;

// cfg: ecc signals
input  [CFG_PORT_WIDTH_ENABLE_ECC                   - 1 : 0] cfg_enable_ecc;
input  [CFG_PORT_WIDTH_ENABLE_AUTO_CORR             - 1 : 0] cfg_enable_auto_corr;
input  [CFG_PORT_WIDTH_ENABLE_NO_DM                 - 1 : 0] cfg_enable_no_dm;
input  [CFG_PORT_WIDTH_GEN_SBE                      - 1 : 0] cfg_gen_sbe;
input  [CFG_PORT_WIDTH_GEN_DBE                      - 1 : 0] cfg_gen_dbe;
input  [CFG_PORT_WIDTH_ENABLE_INTR                  - 1 : 0] cfg_enable_intr;
input  [CFG_PORT_WIDTH_MASK_SBE_INTR                - 1 : 0] cfg_mask_sbe_intr;
input  [CFG_PORT_WIDTH_MASK_DBE_INTR                - 1 : 0] cfg_mask_dbe_intr;
input  [CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR       - 1 : 0] cfg_mask_corr_dropped_intr;
input  [CFG_PORT_WIDTH_CLR_INTR                     - 1 : 0] cfg_clr_intr;
input  [CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES   - 1 : 0] cfg_enable_ecc_code_overwrites;

// cfg: odt
input  [CFG_PORT_WIDTH_WRITE_ODT_CHIP - 1 : 0] cfg_write_odt_chip;
input  [CFG_PORT_WIDTH_READ_ODT_CHIP  - 1 : 0] cfg_read_odt_chip;

// sts: ecc signals
output                                                 ecc_interrupt;
output [STS_PORT_WIDTH_SBE_ERROR              - 1 : 0] sts_sbe_error;
output [STS_PORT_WIDTH_DBE_ERROR              - 1 : 0] sts_dbe_error;
output [STS_PORT_WIDTH_SBE_COUNT              - 1 : 0] sts_sbe_count;
output [STS_PORT_WIDTH_DBE_COUNT              - 1 : 0] sts_dbe_count;
output [CFG_LOCAL_ADDR_WIDTH                  - 1 : 0] sts_err_addr;
output [STS_PORT_WIDTH_CORR_DROP_ERROR        - 1 : 0] sts_corr_dropped;
output [STS_PORT_WIDTH_CORR_DROP_COUNT        - 1 : 0] sts_corr_dropped_count;
output [CFG_LOCAL_ADDR_WIDTH                  - 1 : 0] sts_corr_dropped_addr;

// calibration signals
input                                                   cfg_cal_req;
output                                                  sts_cal_fail;
output                                                  sts_cal_success;

// DQS enable tracking
input   cfg_enable_dqs_tracking;
output  [CFG_MEM_IF_CHIP - 1 : 0] afi_ctl_refresh_done;
input   [CFG_MEM_IF_CHIP - 1 : 0] afi_seq_busy;
output  [CFG_MEM_IF_CHIP - 1 : 0] afi_ctl_long_idle;

//==============================================================================
//
//  Wires
//
//==============================================================================
    
    // General
    wire init_done                                                               = ctl_cal_success;
    wire sts_cal_success                                                         = ctl_cal_success;
    wire sts_cal_fail                                                            = ctl_cal_fail;
    wire ctl_cal_req                                                             = cfg_cal_req;
    wire ctl_init_req;
    wire [CFG_MEM_IF_DQS_WIDTH*CFG_MEM_IF_CHIP-1: 0] ctl_cal_byte_lane_sel_n = 0;
    
    // alt_mem_ddrx_input_if
    wire                                    itf_cmd_ready;
    wire                                    itf_wr_data_ready;
    wire                                    itf_rd_data_valid;
    wire [CFG_LOCAL_DATA_WIDTH     - 1 : 0] itf_rd_data;
    wire                                    itf_rd_data_error;
    wire                                    itf_rd_data_begin;
    wire                                    itf_rd_data_last;
    wire [CFG_LOCAL_ID_WIDTH       - 1 : 0] itf_rd_data_id;
    wire [CFG_LOCAL_ID_WIDTH       - 1 : 0] itf_rd_data_id_early;
    wire                                    itf_rd_data_id_early_valid;
    wire                                    cmd_valid;
    wire [CFG_LOCAL_ADDR_WIDTH     - 1 : 0] cmd_address;
    wire                                    cmd_write;
    wire                                    cmd_read;
    wire                                    cmd_multicast;
    wire [CFG_LOCAL_SIZE_WIDTH     - 1 : 0] cmd_size;
    wire                                    cmd_priority;
    wire                                    cmd_autoprecharge;
    wire [CFG_LOCAL_ID_WIDTH       - 1 : 0] cmd_id;
    wire [CFG_LOCAL_DATA_WIDTH     - 1 : 0] write_data;
    wire [CFG_LOCAL_DATA_WIDTH / 8 - 1 : 0] byte_en;
    wire                                    write_data_valid;
    wire [CFG_LOCAL_ID_WIDTH       - 1 : 0] write_data_id;
    wire                                    local_refresh_ack;
    wire                                    local_deep_powerdn_ack;
    wire                                    local_power_down_ack;
    wire                                    local_self_rfsh_ack;
    wire                                    local_init_done;
    wire                                    rfsh_req;
    wire [CFG_MEM_IF_CHIP          - 1 : 0] rfsh_chip;
    wire                                    deep_powerdn_req;
    wire [CFG_MEM_IF_CHIP          - 1 : 0] deep_powerdn_chip;
    wire                                    self_rfsh_req;
    wire [CFG_MEM_IF_CHIP          - 1 : 0] self_rfsh_chip;
    
    // alt_mem_ddrx_cmd_gen
    wire                                  cmd_gen_load;
    wire [CFG_MEM_IF_CS_WIDTH    - 1 : 0] cmd_gen_chipsel;
    wire [CFG_MEM_IF_BA_WIDTH    - 1 : 0] cmd_gen_bank;
    wire [CFG_MEM_IF_ROW_WIDTH   - 1 : 0] cmd_gen_row;
    wire [CFG_MEM_IF_COL_WIDTH   - 1 : 0] cmd_gen_col;
    wire                                  cmd_gen_write;
    wire                                  cmd_gen_read;
    wire                                  cmd_gen_multicast;
    wire [CFG_INT_SIZE_WIDTH     - 1 : 0] cmd_gen_size;
    wire [CFG_LOCAL_ID_WIDTH     - 1 : 0] cmd_gen_localid;
    wire [CFG_DATA_ID_WIDTH      - 1 : 0] cmd_gen_dataid;
    wire                                  cmd_gen_priority;
    wire                                  cmd_gen_rmw_correct;
    wire                                  cmd_gen_rmw_partial;
    wire                                  cmd_gen_autopch;
    wire                                  cmd_gen_complete;
    wire [CFG_CTL_TBP_NUM        - 1 : 0] cmd_gen_same_chipsel_addr;
    wire [CFG_CTL_TBP_NUM        - 1 : 0] cmd_gen_same_bank_addr;
    wire [CFG_CTL_TBP_NUM        - 1 : 0] cmd_gen_same_row_addr;
    wire [CFG_CTL_TBP_NUM        - 1 : 0] cmd_gen_same_col_addr;
    wire [CFG_CTL_TBP_NUM        - 1 : 0] cmd_gen_same_read_cmd;
    wire [CFG_CTL_TBP_NUM        - 1 : 0] cmd_gen_same_write_cmd;
    wire [CFG_CTL_SHADOW_TBP_NUM - 1 : 0] cmd_gen_same_shadow_chipsel_addr;
    wire [CFG_CTL_SHADOW_TBP_NUM - 1 : 0] cmd_gen_same_shadow_bank_addr;
    wire [CFG_CTL_SHADOW_TBP_NUM - 1 : 0] cmd_gen_same_shadow_row_addr;
    wire                                  cmd_gen_full;
    
    // alt_mem_ddrx_tbp
    wire                                                           tbp_full;
    wire                                                           tbp_empty;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] row_req;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] act_req;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] pch_req;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] col_req;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] rd_req;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] wr_req;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_read;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_write;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_precharge;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_activate;
    wire [(CFG_CTL_TBP_NUM * CFG_MEM_IF_CS_WIDTH)         - 1 : 0] tbp_chipsel;
    wire [(CFG_CTL_TBP_NUM * CFG_MEM_IF_BA_WIDTH)         - 1 : 0] tbp_bank;
    wire [(CFG_CTL_TBP_NUM * CFG_MEM_IF_ROW_WIDTH)        - 1 : 0] tbp_row;
    wire [(CFG_CTL_TBP_NUM * CFG_MEM_IF_COL_WIDTH)        - 1 : 0] tbp_col;
    wire [(CFG_CTL_SHADOW_TBP_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] tbp_shadow_chipsel;
    wire [(CFG_CTL_SHADOW_TBP_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] tbp_shadow_bank;
    wire [(CFG_CTL_SHADOW_TBP_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] tbp_shadow_row;
    wire [(CFG_CTL_TBP_NUM * CFG_INT_SIZE_WIDTH)          - 1 : 0] tbp_size;
    wire [(CFG_CTL_TBP_NUM * CFG_LOCAL_ID_WIDTH)          - 1 : 0] tbp_localid;
    wire [(CFG_CTL_TBP_NUM * CFG_DATA_ID_WIDTH)           - 1 : 0] tbp_dataid;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_ap;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_burst_chop;
    wire [(CFG_CTL_TBP_NUM * CFG_CTL_TBP_NUM)             - 1 : 0] tbp_age;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_priority;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_rmw_correct;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_rmw_partial;
    wire [CFG_MEM_IF_CHIP                                 - 1 : 0] tbp_bank_active;
    wire [CFG_MEM_IF_CHIP                                 - 1 : 0] tbp_timer_ready;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_load_index;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_load;
    
    // alt_mem_ddrx_arbiter
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] row_grant;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] col_grant;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] act_grant;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] pch_grant;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] rd_grant;
    wire [CFG_CTL_TBP_NUM                                 - 1 : 0] wr_grant;
    wire [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_row_grant;
    wire [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_col_grant;
    wire [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_act_grant;
    wire [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_pch_grant;
    wire [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_rd_grant;
    wire [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_wr_grant;
    wire                                                           or_row_grant;
    wire                                                           or_col_grant;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_write;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_read;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_chop;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_terminate;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_auto_precharge;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_correct;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_partial;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_activate;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_precharge;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_precharge_all;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_refresh;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_self_refresh;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_power_down;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_deep_pdown;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_zq_cal;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_lmr;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] arb_to_chipsel;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_to_chip;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] arb_to_bank;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] arb_to_row;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] arb_to_col;
    wire [CFG_LOCAL_ID_WIDTH                              - 1 : 0] arb_localid;
    wire [CFG_DATA_ID_WIDTH                               - 1 : 0] arb_dataid;
    wire [CFG_INT_SIZE_WIDTH                              - 1 : 0] arb_size;
    
    // alt_mem_ddrx_burst_gen

    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write_combi;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read_combi;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop_combi;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate_combi;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate_combi;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge_combi;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip_combi;
    wire [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_effective_size_combi;
    wire                                                           bg_interrupt_ready_combi;

    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_auto_precharge;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_correct;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_partial;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_precharge_all;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_refresh;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_self_refresh;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_power_down;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_deep_pdown;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_zq_cal;
    wire [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_lmr;
    wire                                                           bg_do_lmr_read = 0;
    wire                                                           bg_do_refresh_1bank = 0;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] bg_to_chipsel;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] bg_to_bank;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] bg_to_row;
    wire [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] bg_to_col;
    wire                                                           bg_doing_write;
    wire                                                           bg_doing_read;
    wire                                                           bg_rdwr_data_valid;
    wire                                                           bg_interrupt_ready;
    wire [CFG_LOCAL_ID_WIDTH                              - 1 : 0] bg_localid;
    wire [CFG_DATA_ID_WIDTH                               - 1 : 0] bg_dataid;
    wire [CFG_RDDATA_ID_WIDTH                             - 1 : 0] bg_rddataid;
    wire [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_size;
    wire [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_effective_size;
    wire [                                                  7 : 0] bg_to_lmr = 0;
    
    // alt_mem_ddrx_addr_cmd_wrap
    wire [(CFG_MEM_IF_CKE_WIDTH  * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_cke;
    wire [(CFG_MEM_IF_CHIP       * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_cs_n;
    wire [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_ras_n;
    wire [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_cas_n;
    wire [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_we_n;
    wire [(CFG_MEM_IF_BA_WIDTH   * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_ba;
    wire [(CFG_AFI_IF_FR_ADDR_WIDTH*(CFG_DWIDTH_RATIO / 2))- 1 : 0] afi_addr;
    wire [(CFG_DWIDTH_RATIO / 2)                           - 1 : 0] afi_rst_n;
    wire [(CFG_MEM_IF_ODT_WIDTH  * (CFG_DWIDTH_RATIO / 2)) - 1 : 0] afi_odt;
    wire [CFG_AFI_IF_FR_ADDR_WIDTH                         - 1 : 0] lmr_opcode = 0;
    
    // alt_mem_ddrx_rdwr_data_tmg
    wire [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2)  - 1 : 0] afi_rdata_en;
    wire [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2)  - 1 : 0] afi_rdata_en_full;
    wire [CFG_PORT_WIDTH_OUTPUT_REGD                     - 1 : 0] cfg_output_regd_for_afi_output;
    wire [CFG_DRAM_WLAT_GROUP                            - 1 : 0] ecc_wdata_fifo_read;
    wire [CFG_DRAM_WLAT_GROUP * CFG_DATA_ID_WIDTH        - 1 : 0] ecc_wdata_fifo_dataid;
    wire [CFG_DRAM_WLAT_GROUP * CFG_DATAID_ARRAY_DEPTH   - 1 : 0] ecc_wdata_fifo_dataid_vector;
    wire [CFG_DRAM_WLAT_GROUP                            - 1 : 0] ecc_wdata_fifo_rmw_correct;
    wire [CFG_DRAM_WLAT_GROUP                            - 1 : 0] ecc_wdata_fifo_rmw_partial;
    wire                                                          ecc_wdata_fifo_read_first;
    wire [CFG_DATA_ID_WIDTH                              - 1 : 0] ecc_wdata_fifo_dataid_first;
    wire [CFG_DATAID_ARRAY_DEPTH                         - 1 : 0] ecc_wdata_fifo_dataid_vector_first;
    wire                                                          ecc_wdata_fifo_rmw_correct_first;
    wire                                                          ecc_wdata_fifo_rmw_partial_first;
    wire [CFG_DRAM_WLAT_GROUP                            - 1 : 0] ecc_wdata_fifo_first_vector;
    wire                                                          ecc_wdata_fifo_read_last;
    wire [CFG_DATA_ID_WIDTH                              - 1 : 0] ecc_wdata_fifo_dataid_last;
    wire [CFG_DATAID_ARRAY_DEPTH                         - 1 : 0] ecc_wdata_fifo_dataid_vector_last;
    wire                                                          ecc_wdata_fifo_rmw_correct_last;
    wire                                                          ecc_wdata_fifo_rmw_partial_last;
    wire [CFG_DRAM_WLAT_GROUP * CFG_WRDATA_ID_WIDTH      - 1 : 0] ecc_wdata_wrdataid;
    wire [CFG_DRAM_WLAT_GROUP * CFG_WRDATA_ID_WIDTH_SQRD - 1 : 0] ecc_wdata_wrdataid_vector;
    wire [CFG_WRDATA_ID_WIDTH                            - 1 : 0] ecc_wdata_wrdataid_first;
    wire [CFG_WRDATA_ID_WIDTH_SQRD                       - 1 : 0] ecc_wdata_wrdataid_vector_first;
    wire [CFG_WRDATA_ID_WIDTH                            - 1 : 0] ecc_wdata_wrdataid_last;
    wire [CFG_WRDATA_ID_WIDTH_SQRD                       - 1 : 0] ecc_wdata_wrdataid_vector_last;
    wire [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2)  - 1 : 0] afi_dqs_burst;
    wire [CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2)  - 1 : 0] afi_wdata_valid;
    wire [CFG_MEM_IF_DQ_WIDTH  * CFG_DWIDTH_RATIO        - 1 : 0] afi_wdata;
    wire [CFG_MEM_IF_DM_WIDTH  * CFG_DWIDTH_RATIO        - 1 : 0] afi_dm;
    
    // alt_mem_ddrx_wdata_path
    wire proc_busy;
    wire proc_load;
    wire proc_load_dataid;
    wire proc_write;
    wire proc_read;
    wire [CFG_INT_SIZE_WIDTH-1:0] proc_size;
    wire [CFG_LOCAL_ID_WIDTH-1:0] proc_localid;
    wire                                                          wdatap_free_id_valid;
    wire [CFG_DATA_ID_WIDTH                              - 1 : 0] wdatap_free_id_dataid;
    wire [CFG_WRDATA_ID_WIDTH                            - 1 : 0] wdatap_free_id_wrdataid;
    wire                                                          wr_data_mem_full;
    wire [CFG_CTL_TBP_NUM                                - 1 : 0] data_complete;
    wire                                                          data_rmw_complete;
    wire                                                          data_partial_be;
    wire [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] wdatap_data;
    wire [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] wdatap_rmw_partial_data;
    wire [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] wdatap_rmw_correct_data;
    wire                                                          wdatap_rmw_partial;
    wire                                                          wdatap_rmw_correct;
    wire [(CFG_LOCAL_DATA_WIDTH / CFG_MEM_IF_DQ_PER_DQS) - 1 : 0] wdatap_dm;
    wire [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH         - 1 : 0] wdatap_ecc_code;
    wire [CFG_ECC_MULTIPLES                              - 1 : 0] wdatap_ecc_code_overwrite;
    
    // alt_mem_ddrx_rdata_path
    wire                                rdatap_free_id_valid;
    wire [CFG_DATA_ID_WIDTH    - 1 : 0] rdatap_free_id_dataid;
    wire [CFG_RDDATA_ID_WIDTH  - 1 : 0] rdatap_free_id_rddataid;
    wire                                read_data_valid;
    wire [CFG_LOCAL_DATA_WIDTH - 1 : 0] read_data;
    wire                                read_data_error;
    wire [CFG_LOCAL_ID_WIDTH   - 1 : 0] read_data_localid;
    wire                                errcmd_ready;
    wire                                errcmd_valid;
    wire [CFG_MEM_IF_CS_WIDTH  - 1 : 0] errcmd_chipsel;
    wire [CFG_MEM_IF_BA_WIDTH  - 1 : 0] errcmd_bank;
    wire [CFG_MEM_IF_ROW_WIDTH - 1 : 0] errcmd_row;
    wire [CFG_MEM_IF_COL_WIDTH - 1 : 0] errcmd_column;
    wire [CFG_INT_SIZE_WIDTH   - 1 : 0] errcmd_size;
    wire [CFG_LOCAL_ID_WIDTH   - 1 : 0] errcmd_localid;
    wire [CFG_LOCAL_ADDR_WIDTH - 1 : 0] rdatap_rcvd_addr;
    wire                                rdatap_rcvd_cmd;
    wire                                rdatap_rcvd_corr_dropped;
    wire                                rmwfifo_data_valid; 
    wire [CFG_LOCAL_DATA_WIDTH - 1 : 0] rmwfifo_data;
    wire [CFG_ECC_MULTIPLES                      - 1 : 0] rmwfifo_ecc_dbe;
    wire [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rmwfifo_ecc_code;
    
    // alt_mem_ddrx_ecc_encoder_decoder_wrapper
    wire [CFG_LOCAL_DATA_WIDTH                   - 1 : 0] ecc_rdata;
    wire                                                  ecc_rdata_valid;
    wire [CFG_ECC_DM_WIDTH                       - 1 : 0] ecc_dm;
    wire [CFG_ECC_DATA_WIDTH                     - 1 : 0] ecc_wdata;
    wire [CFG_ECC_MULTIPLES                      - 1 : 0] ecc_sbe;
    wire [CFG_ECC_MULTIPLES                      - 1 : 0] ecc_dbe;
    wire [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] ecc_code;
    wire                                                  ecc_interrupt;
    wire [STS_PORT_WIDTH_SBE_ERROR               - 1 : 0] sts_sbe_error;
    wire [STS_PORT_WIDTH_DBE_ERROR               - 1 : 0] sts_dbe_error;
    wire [STS_PORT_WIDTH_SBE_COUNT               - 1 : 0] sts_sbe_count;
    wire [STS_PORT_WIDTH_DBE_COUNT               - 1 : 0] sts_dbe_count;
    wire [CFG_LOCAL_ADDR_WIDTH                   - 1 : 0] sts_err_addr;
    wire [STS_PORT_WIDTH_CORR_DROP_ERROR         - 1 : 0] sts_corr_dropped;
    wire [STS_PORT_WIDTH_CORR_DROP_COUNT         - 1 : 0] sts_corr_dropped_count;
    wire [CFG_LOCAL_ADDR_WIDTH                   - 1 : 0] sts_corr_dropped_addr;
    
    // alt_mem_ddrx_sideband
    wire                                       rfsh_ack;
    wire                                       self_rfsh_ack;
    wire                                       deep_powerdn_ack;
    wire                                       power_down_ack;
    wire                                       stall_row_arbiter;
    wire                                       stall_col_arbiter;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   stall_chip;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   sb_do_precharge_all;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   sb_do_refresh;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   sb_do_self_refresh;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   sb_do_power_down;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   sb_do_deep_pdown;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   sb_do_zq_cal;
    wire [CFG_CTL_TBP_NUM           - 1 : 0]   sb_tbp_precharge_all;
    wire [CFG_MEM_IF_CLK_PAIR_COUNT - 1 : 0]   ctl_mem_clk_disable;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   afi_ctl_refresh_done;
    wire [CFG_MEM_IF_CHIP           - 1 : 0]   afi_ctl_long_idle;
    
    // alt_mem_ddrx_rank_timer
    wire [CFG_CTL_TBP_NUM - 1 : 0] can_activate;
    wire [CFG_CTL_TBP_NUM - 1 : 0] can_precharge;
    wire [CFG_CTL_TBP_NUM - 1 : 0] can_read;
    wire [CFG_CTL_TBP_NUM - 1 : 0] can_write;
    
    // alt_mem_ddrx_timing_param
    wire [T_PARAM_ACT_TO_RDWR_WIDTH          - 1 : 0] t_param_act_to_rdwr;
    wire [T_PARAM_ACT_TO_PCH_WIDTH           - 1 : 0] t_param_act_to_pch;
    wire [T_PARAM_ACT_TO_ACT_WIDTH           - 1 : 0] t_param_act_to_act;
    wire [T_PARAM_RD_TO_RD_WIDTH             - 1 : 0] t_param_rd_to_rd;
    wire [T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH   - 1 : 0] t_param_rd_to_rd_diff_chip;
    wire [T_PARAM_RD_TO_WR_WIDTH             - 1 : 0] t_param_rd_to_wr;
    wire [T_PARAM_RD_TO_WR_BC_WIDTH          - 1 : 0] t_param_rd_to_wr_bc;
    wire [T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH   - 1 : 0] t_param_rd_to_wr_diff_chip;
    wire [T_PARAM_RD_TO_PCH_WIDTH            - 1 : 0] t_param_rd_to_pch;
    wire [T_PARAM_RD_AP_TO_VALID_WIDTH       - 1 : 0] t_param_rd_ap_to_valid;
    wire [T_PARAM_WR_TO_WR_WIDTH             - 1 : 0] t_param_wr_to_wr;
    wire [T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH   - 1 : 0] t_param_wr_to_wr_diff_chip;
    wire [T_PARAM_WR_TO_RD_WIDTH             - 1 : 0] t_param_wr_to_rd;
    wire [T_PARAM_WR_TO_RD_BC_WIDTH          - 1 : 0] t_param_wr_to_rd_bc;
    wire [T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH   - 1 : 0] t_param_wr_to_rd_diff_chip;
    wire [T_PARAM_WR_TO_PCH_WIDTH            - 1 : 0] t_param_wr_to_pch;
    wire [T_PARAM_WR_AP_TO_VALID_WIDTH       - 1 : 0] t_param_wr_ap_to_valid;
    wire [T_PARAM_PCH_TO_VALID_WIDTH         - 1 : 0] t_param_pch_to_valid;
    wire [T_PARAM_PCH_ALL_TO_VALID_WIDTH     - 1 : 0] t_param_pch_all_to_valid;
    wire [T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH - 1 : 0] t_param_act_to_act_diff_bank;
    wire [T_PARAM_FOUR_ACT_TO_ACT_WIDTH      - 1 : 0] t_param_four_act_to_act;
    wire [T_PARAM_ARF_TO_VALID_WIDTH         - 1 : 0] t_param_arf_to_valid;
    wire [T_PARAM_PDN_TO_VALID_WIDTH         - 1 : 0] t_param_pdn_to_valid;
    wire [T_PARAM_SRF_TO_VALID_WIDTH         - 1 : 0] t_param_srf_to_valid;
    wire [T_PARAM_SRF_TO_ZQ_CAL_WIDTH        - 1 : 0] t_param_srf_to_zq_cal;
    wire [T_PARAM_ARF_PERIOD_WIDTH           - 1 : 0] t_param_arf_period;
    wire [T_PARAM_PDN_PERIOD_WIDTH           - 1 : 0] t_param_pdn_period;
    wire [T_PARAM_POWER_SAVING_EXIT_WIDTH    - 1 : 0] t_param_power_saving_exit;
    
    // Log 2 function
    function integer log2;
       input [31:0] value;
       integer    i;
       begin
          log2 = 0;
          for(i = 0; 2**i < value; i = i + 1)
       log2 = i + 1;
       end
    endfunction
	
	// register init_done signal
	reg  init_done_reg;
	always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            init_done_reg            <= 0;
        end
        else
        begin
            init_done_reg            <= init_done;
        end
    end
    
//==============================================================================
// alt_mem_ddrx_input_if
//------------------------------------------------------------------------------
//
//  Input interface block
//
//  Info: Includes cmd channel, and both read and write channels
//        * Optional half-rate bridge logic
//
//==============================================================================
    
    alt_mem_ddrx_input_if #
    (
        .CFG_LOCAL_DATA_WIDTH          (CFG_LOCAL_DATA_WIDTH      ),
        .CFG_LOCAL_ID_WIDTH            (CFG_LOCAL_ID_WIDTH        ),
        .CFG_LOCAL_ADDR_WIDTH          (CFG_LOCAL_ADDR_WIDTH      ),
        .CFG_LOCAL_SIZE_WIDTH          (CFG_LOCAL_SIZE_WIDTH      ),
        .CFG_MEM_IF_CHIP               (CFG_MEM_IF_CHIP           ),
        .CFG_AFI_INTF_PHASE_NUM        (CFG_AFI_INTF_PHASE_NUM    ),
        .CFG_CTL_ARBITER_TYPE          (CFG_CTL_ARBITER_TYPE      )
    )
    input_if_inst
    (
        .itf_cmd_ready             (itf_cmd_ready              ),
        .itf_cmd_valid             (itf_cmd_valid              ),
        .itf_cmd                   (itf_cmd                    ),
        .itf_cmd_address           (itf_cmd_address            ),
        .itf_cmd_burstlen          (itf_cmd_burstlen           ),
        .itf_cmd_id                (itf_cmd_id                 ),
        .itf_cmd_priority          (itf_cmd_priority           ),
        .itf_cmd_autopercharge     (itf_cmd_autopercharge      ),
        .itf_cmd_multicast         (itf_cmd_multicast          ),
        .itf_wr_data_ready         (itf_wr_data_ready          ),
        .itf_wr_data_valid         (itf_wr_data_valid          ),
        .itf_wr_data               (itf_wr_data                ),
        .itf_wr_data_byte_en       (itf_wr_data_byte_en        ),
        .itf_wr_data_begin         (itf_wr_data_begin          ),
        .itf_wr_data_last          (itf_wr_data_last           ),
        .itf_wr_data_id            (itf_wr_data_id             ),
        .itf_rd_data_ready         (itf_rd_data_ready          ),
        .itf_rd_data_valid         (itf_rd_data_valid          ),
        .itf_rd_data               (itf_rd_data                ),
        .itf_rd_data_error         (itf_rd_data_error          ),
        .itf_rd_data_begin         (itf_rd_data_begin          ),
        .itf_rd_data_last          (itf_rd_data_last           ),
        .itf_rd_data_id            (itf_rd_data_id             ),
        .itf_rd_data_id_early      (itf_rd_data_id_early       ),
        .itf_rd_data_id_early_valid(itf_rd_data_id_early_valid ),
        .cmd_gen_full              (cmd_gen_full               ),
        .cmd_valid                 (cmd_valid                  ),
        .cmd_address               (cmd_address                ),
        .cmd_write                 (cmd_write                  ),
        .cmd_read                  (cmd_read                   ),
        .cmd_multicast             (cmd_multicast              ),
        .cmd_size                  (cmd_size                   ),
        .cmd_priority              (cmd_priority               ),
        .cmd_autoprecharge         (cmd_autoprecharge          ),
        .cmd_id                    (cmd_id                     ),
        .write_data                (write_data                 ),
        .wr_data_mem_full          (wr_data_mem_full           ),
        .write_data_id             (write_data_id              ),
        .byte_en                   (byte_en                    ),
        .write_data_valid          (write_data_valid           ),
        .read_data                 (read_data                  ),
        .read_data_valid           (read_data_valid            ),
        .read_data_error           (read_data_error            ),
        .read_data_localid         (read_data_localid          ),
        .read_data_begin           (                           ),         // NOTICE: not connected?
        .read_data_last            (                           ),         // NOTICE: not connected?
        .bg_do_read                (bg_do_read                 ),
        .bg_localid                (bg_localid                 ),
        .bg_do_rmw_correct         (bg_do_rmw_correct          ),
        .bg_do_rmw_partial         (bg_do_rmw_partial          ),
        .local_refresh_req         (local_refresh_req          ),
        .local_refresh_chip        (local_refresh_chip         ),
        .local_deep_powerdn_req    (local_deep_powerdn_req     ),
        .local_deep_powerdn_chip   (local_deep_powerdn_chip    ),
        .local_self_rfsh_req       (local_self_rfsh_req        ),
        .local_self_rfsh_chip      (local_self_rfsh_chip       ),
        .local_refresh_ack         (local_refresh_ack          ),
        .local_deep_powerdn_ack    (local_deep_powerdn_ack     ),
        .local_power_down_ack      (local_power_down_ack       ),
        .local_self_rfsh_ack       (local_self_rfsh_ack        ),
        .local_init_done           (local_init_done            ),
        .rfsh_req                  (rfsh_req                   ),
        .rfsh_chip                 (rfsh_chip                  ),
        .deep_powerdn_req          (deep_powerdn_req           ),
        .deep_powerdn_chip         (deep_powerdn_chip          ),
        .self_rfsh_req             (self_rfsh_req              ),
        .self_rfsh_chip            (self_rfsh_chip             ),
        .rfsh_ack                  (rfsh_ack                   ),
        .deep_powerdn_ack          (deep_powerdn_ack           ),
        .power_down_ack            (power_down_ack             ),
        .self_rfsh_ack             (self_rfsh_ack              ),
        .init_done                 (init_done_reg              )
    );
    
//==============================================================================
// alt_mem_ddrx_cmd_gen
//------------------------------------------------------------------------------
//
//  Command generator block
//
//  Info: * generates cmd from local and internal ECC block
//        * splitting and merging of all commands
//        * optional queue for latency reduction purpose when no merging is required
//
//==============================================================================
    
    alt_mem_ddrx_cmd_gen #
    (
        .CFG_LOCAL_ADDR_WIDTH               (CFG_LOCAL_ADDR_WIDTH               ),
        .CFG_LOCAL_SIZE_WIDTH               (CFG_LOCAL_SIZE_WIDTH               ),
        .CFG_LOCAL_ID_WIDTH                 (CFG_LOCAL_ID_WIDTH                 ),
        .CFG_INT_SIZE_WIDTH                 (CFG_INT_SIZE_WIDTH                 ),
        .CFG_PORT_WIDTH_COL_ADDR_WIDTH      (CFG_PORT_WIDTH_COL_ADDR_WIDTH      ),
        .CFG_PORT_WIDTH_ROW_ADDR_WIDTH      (CFG_PORT_WIDTH_ROW_ADDR_WIDTH      ),
        .CFG_PORT_WIDTH_BANK_ADDR_WIDTH     (CFG_PORT_WIDTH_BANK_ADDR_WIDTH     ),
        .CFG_PORT_WIDTH_CS_ADDR_WIDTH       (CFG_PORT_WIDTH_CS_ADDR_WIDTH       ),
        .CFG_PORT_WIDTH_BURST_LENGTH        (CFG_PORT_WIDTH_BURST_LENGTH        ),
        .CFG_PORT_WIDTH_ADDR_ORDER          (CFG_PORT_WIDTH_ADDR_ORDER          ),
        .CFG_DWIDTH_RATIO                   (CFG_DWIDTH_RATIO                   ),
        .CFG_CTL_QUEUE_DEPTH                (CFG_CTL_QUEUE_DEPTH                ),
        .CFG_MEM_IF_CHIP                    (CFG_MEM_IF_CHIP                    ),
        .CFG_MEM_IF_CS_WIDTH                (CFG_MEM_IF_CS_WIDTH                ),
        .CFG_MEM_IF_BA_WIDTH                (CFG_MEM_IF_BA_WIDTH                ),
        .CFG_MEM_IF_ROW_WIDTH               (CFG_MEM_IF_ROW_WIDTH               ),
        .CFG_MEM_IF_COL_WIDTH               (CFG_MEM_IF_COL_WIDTH               ),
        .CFG_DATA_ID_WIDTH                  (CFG_DATA_ID_WIDTH                  ),
        .CFG_ENABLE_QUEUE                   (CFG_ENABLE_QUEUE                   ),
        .CFG_ENABLE_BURST_MERGE             (CFG_ENABLE_BURST_MERGE             ),
        .CFG_CMD_GEN_OUTPUT_REG             (CFG_CMD_GEN_OUTPUT_REG             ),
        .CFG_CTL_TBP_NUM                    (CFG_CTL_TBP_NUM                    ),
        .CFG_CTL_SHADOW_TBP_NUM             (CFG_CTL_SHADOW_TBP_NUM             )
    )
    cmd_gen_inst
    (
        .ctl_clk                            (ctl_clk                            ),
        .ctl_reset_n                        (ctl_reset_n                        ),
        .tbp_full                           (tbp_full                           ),
        .tbp_load                           (tbp_load                           ),
        .tbp_read                           (tbp_read                           ),
        .tbp_write                          (tbp_write                          ),
        .tbp_chipsel                        (tbp_chipsel                        ),
        .tbp_bank                           (tbp_bank                           ),
        .tbp_row                            (tbp_row                            ),
        .tbp_col                            (tbp_col                            ),
        .tbp_shadow_chipsel                 (tbp_shadow_chipsel                 ),
        .tbp_shadow_bank                    (tbp_shadow_bank                    ),
        .tbp_shadow_row                     (tbp_shadow_row                     ),
        .cmd_gen_load                       (cmd_gen_load                       ),
        .cmd_gen_chipsel                    (cmd_gen_chipsel                    ),
        .cmd_gen_bank                       (cmd_gen_bank                       ),
        .cmd_gen_row                        (cmd_gen_row                        ),
        .cmd_gen_col                        (cmd_gen_col                        ),
        .cmd_gen_write                      (cmd_gen_write                      ),
        .cmd_gen_read                       (cmd_gen_read                       ),
        .cmd_gen_multicast                  (cmd_gen_multicast                  ),
        .cmd_gen_size                       (cmd_gen_size                       ),
        .cmd_gen_localid                    (cmd_gen_localid                    ),
        .cmd_gen_dataid                     (cmd_gen_dataid                     ),
        .cmd_gen_priority                   (cmd_gen_priority                   ),
        .cmd_gen_rmw_correct                (cmd_gen_rmw_correct                ),
        .cmd_gen_rmw_partial                (cmd_gen_rmw_partial                ),
        .cmd_gen_autopch                    (cmd_gen_autopch                    ),
        .cmd_gen_complete                   (cmd_gen_complete                   ),
        .cmd_gen_same_chipsel_addr          (cmd_gen_same_chipsel_addr          ),
        .cmd_gen_same_bank_addr             (cmd_gen_same_bank_addr             ),
        .cmd_gen_same_row_addr              (cmd_gen_same_row_addr              ),
        .cmd_gen_same_col_addr              (cmd_gen_same_col_addr              ),
        .cmd_gen_same_read_cmd              (cmd_gen_same_read_cmd              ),
        .cmd_gen_same_write_cmd             (cmd_gen_same_write_cmd             ),
        .cmd_gen_same_shadow_chipsel_addr   (cmd_gen_same_shadow_chipsel_addr   ),
        .cmd_gen_same_shadow_bank_addr      (cmd_gen_same_shadow_bank_addr      ),
        .cmd_gen_same_shadow_row_addr       (cmd_gen_same_shadow_row_addr       ),
        .cmd_gen_full                       (cmd_gen_full                       ),
        .cmd_valid                          (cmd_valid                          ),
        .cmd_address                        (cmd_address                        ),
        .cmd_write                          (cmd_write                          ),
        .cmd_read                           (cmd_read                           ),
        .cmd_id                             (cmd_id                             ),
        .cmd_multicast                      (cmd_multicast                      ),
        .cmd_size                           (cmd_size                           ),
        .cmd_priority                       (cmd_priority                       ),
        .cmd_autoprecharge                  (cmd_autoprecharge                  ),
        .proc_busy                          (proc_busy                          ),
        .proc_load                          (proc_load                          ),
        .proc_load_dataid                   (proc_load_dataid                   ),
        .proc_write                         (proc_write                         ),
        .proc_read                          (proc_read                          ),
        .proc_size                          (proc_size                          ),
        .proc_localid                       (proc_localid                       ),
        .wdatap_free_id_valid               (wdatap_free_id_valid               ),
        .wdatap_free_id_dataid              (wdatap_free_id_dataid              ),
        .rdatap_free_id_valid               (rdatap_free_id_valid               ),
        .rdatap_free_id_dataid              (rdatap_free_id_dataid              ),
        .tbp_load_index                     (tbp_load_index                     ),
        .data_complete                      (data_complete                      ),
        .data_rmw_complete                  (data_rmw_complete                  ),
        .errcmd_ready                       (errcmd_ready                       ),
        .errcmd_valid                       (errcmd_valid                       ),
        .errcmd_chipsel                     (errcmd_chipsel                     ),
        .errcmd_bank                        (errcmd_bank                        ),
        .errcmd_row                         (errcmd_row                         ),
        .errcmd_column                      (errcmd_column                      ),
        .errcmd_size                        (errcmd_size                        ),
        .errcmd_localid                     (errcmd_localid                     ),
        .data_partial_be                    (data_partial_be                    ),
        .cfg_enable_cmd_split               (CFG_ENABLE_CMD_SPLIT               ),
        .cfg_burst_length                   (cfg_burst_length                   ),
        .cfg_addr_order                     (cfg_addr_order                     ),
        .cfg_enable_ecc                     (cfg_enable_ecc                     ),
        .cfg_enable_no_dm                   (cfg_enable_no_dm                   ),
        .cfg_col_addr_width                 (cfg_col_addr_width                 ),
        .cfg_row_addr_width                 (cfg_row_addr_width                 ),
        .cfg_bank_addr_width                (cfg_bank_addr_width                ),
        .cfg_cs_addr_width                  (cfg_cs_addr_width                  )
    );
    
//==============================================================================
// alt_mem_ddrx_tbp
//------------------------------------------------------------------------------
//
//  Timing bank pool block
//
//  Info: * parallel queue in which a cmd is present
//        * tracks timer and bank status information of the command it hold
//        * monitor other TBPs content to update status bit in itself such
//          as the autoprecharge bit
//	      * pass timer value to another TBP if need arises
//
//==============================================================================
    
    alt_mem_ddrx_tbp #
    (
        .CFG_CTL_TBP_NUM                        (CFG_CTL_TBP_NUM                        ),
        .CFG_CTL_SHADOW_TBP_NUM                 (CFG_CTL_SHADOW_TBP_NUM                 ),
        .CFG_ENABLE_SHADOW_TBP                  (CFG_ENABLE_SHADOW_TBP                  ),
        .CFG_DWIDTH_RATIO                       (CFG_DWIDTH_RATIO                       ),
        .CFG_CTL_ARBITER_TYPE                   (CFG_CTL_ARBITER_TYPE                   ),
        .CFG_MEM_IF_CHIP                        (CFG_MEM_IF_CHIP                        ),
        .CFG_MEM_IF_CS_WIDTH                    (CFG_MEM_IF_CS_WIDTH                    ),
        .CFG_MEM_IF_BA_WIDTH                    (CFG_MEM_IF_BA_WIDTH                    ),
        .CFG_MEM_IF_ROW_WIDTH                   (CFG_MEM_IF_ROW_WIDTH                   ),
        .CFG_MEM_IF_COL_WIDTH                   (CFG_MEM_IF_COL_WIDTH                   ),
        .CFG_LOCAL_ID_WIDTH                     (CFG_LOCAL_ID_WIDTH                     ),
        .CFG_INT_SIZE_WIDTH                     (CFG_INT_SIZE_WIDTH                     ),
        .CFG_DATA_ID_WIDTH                      (CFG_DATA_ID_WIDTH                      ),
        .CFG_PORT_WIDTH_STARVE_LIMIT            (CFG_PORT_WIDTH_STARVE_LIMIT            ),
        .CFG_PORT_WIDTH_TYPE                    (CFG_PORT_WIDTH_TYPE                    ),
        .CFG_PORT_WIDTH_REORDER_DATA            (CFG_PORT_WIDTH_REORDER_DATA            ),
        .CFG_REG_REQ                            (CFG_REG_REQ                            ),
        .CFG_REG_GRANT                          (CFG_REG_GRANT                          ),
        .CFG_DATA_REORDERING_TYPE               (CFG_DATA_REORDERING_TYPE               ),
        .CFG_DISABLE_READ_REODERING             (CFG_DISABLE_READ_REODERING             ),
        .CFG_DISABLE_PRIORITY                   (CFG_DISABLE_PRIORITY                   ),
        .T_PARAM_ACT_TO_RDWR_WIDTH              (T_PARAM_ACT_TO_RDWR_WIDTH              ),
        .T_PARAM_ACT_TO_ACT_WIDTH               (T_PARAM_ACT_TO_ACT_WIDTH               ),
        .T_PARAM_ACT_TO_PCH_WIDTH               (T_PARAM_ACT_TO_PCH_WIDTH               ),
        .T_PARAM_RD_TO_PCH_WIDTH                (T_PARAM_RD_TO_PCH_WIDTH                ),
        .T_PARAM_WR_TO_PCH_WIDTH                (T_PARAM_WR_TO_PCH_WIDTH                ),
        .T_PARAM_PCH_TO_VALID_WIDTH             (T_PARAM_PCH_TO_VALID_WIDTH             ),
        .T_PARAM_RD_AP_TO_VALID_WIDTH           (T_PARAM_RD_AP_TO_VALID_WIDTH           ),
        .T_PARAM_WR_AP_TO_VALID_WIDTH           (T_PARAM_WR_AP_TO_VALID_WIDTH           )
    )
    tbp_inst
    (
        .ctl_clk                                (ctl_clk                                ),
        .ctl_reset_n                            (ctl_reset_n                            ),
        .tbp_full                               (tbp_full                               ),
        .tbp_empty                              (tbp_empty                              ),
        .cmd_gen_load                           (cmd_gen_load                           ),
        .cmd_gen_chipsel                        (cmd_gen_chipsel                        ),
        .cmd_gen_bank                           (cmd_gen_bank                           ),
        .cmd_gen_row                            (cmd_gen_row                            ),
        .cmd_gen_col                            (cmd_gen_col                            ),
        .cmd_gen_write                          (cmd_gen_write                          ),
        .cmd_gen_read                           (cmd_gen_read                           ),
        .cmd_gen_size                           (cmd_gen_size                           ),
        .cmd_gen_localid                        (cmd_gen_localid                        ),
        .cmd_gen_dataid                         (cmd_gen_dataid                         ),
        .cmd_gen_priority                       (cmd_gen_priority                       ),
        .cmd_gen_rmw_correct                    (cmd_gen_rmw_correct                    ),
        .cmd_gen_rmw_partial                    (cmd_gen_rmw_partial                    ),
        .cmd_gen_autopch                        (cmd_gen_autopch                        ),
        .cmd_gen_complete                       (cmd_gen_complete                       ),
        .cmd_gen_same_chipsel_addr              (cmd_gen_same_chipsel_addr              ),
        .cmd_gen_same_bank_addr                 (cmd_gen_same_bank_addr                 ),
        .cmd_gen_same_row_addr                  (cmd_gen_same_row_addr                  ),
        .cmd_gen_same_col_addr                  (cmd_gen_same_col_addr                  ),
        .cmd_gen_same_read_cmd                  (cmd_gen_same_read_cmd                  ),
        .cmd_gen_same_write_cmd                 (cmd_gen_same_write_cmd                 ),
        .cmd_gen_same_shadow_chipsel_addr       (cmd_gen_same_shadow_chipsel_addr       ),
        .cmd_gen_same_shadow_bank_addr          (cmd_gen_same_shadow_bank_addr          ),
        .cmd_gen_same_shadow_row_addr           (cmd_gen_same_shadow_row_addr           ),
        .row_req                                (row_req                                ),
        .act_req                                (act_req                                ),
        .pch_req                                (pch_req                                ),
        .col_req                                (col_req                                ),
        .rd_req                                 (rd_req                                 ),
        .wr_req                                 (wr_req                                 ),
        .row_grant                              (row_grant                              ),
        .col_grant                              (col_grant                              ),
        .act_grant                              (act_grant                              ),
        .pch_grant                              (pch_grant                              ),
        .rd_grant                               (rd_grant                               ),
        .wr_grant                               (wr_grant                               ),
        .log2_row_grant                         (log2_row_grant                         ),
        .log2_col_grant                         (log2_col_grant                         ),
        .log2_act_grant                         (log2_act_grant                         ),
        .log2_pch_grant                         (log2_pch_grant                         ),
        .log2_rd_grant                          (log2_rd_grant                          ),
        .log2_wr_grant                          (log2_wr_grant                          ),
        .or_row_grant                           (or_row_grant                           ),
        .or_col_grant                           (or_col_grant                           ),
        .tbp_read                               (tbp_read                               ),
        .tbp_write                              (tbp_write                              ),
        .tbp_precharge                          (tbp_precharge                          ),
        .tbp_activate                           (tbp_activate                           ),
        .tbp_chipsel                            (tbp_chipsel                            ),
        .tbp_bank                               (tbp_bank                               ),
        .tbp_row                                (tbp_row                                ),
        .tbp_col                                (tbp_col                                ),
        .tbp_shadow_chipsel                     (tbp_shadow_chipsel                     ),
        .tbp_shadow_bank                        (tbp_shadow_bank                        ),
        .tbp_shadow_row                         (tbp_shadow_row                         ),
        .tbp_size                               (tbp_size                               ),
        .tbp_localid                            (tbp_localid                            ),
        .tbp_dataid                             (tbp_dataid                             ),
        .tbp_ap                                 (tbp_ap                                 ),
        .tbp_burst_chop                         (tbp_burst_chop                         ),
        .tbp_age                                (tbp_age                                ),
        .tbp_priority                           (tbp_priority                           ),
        .tbp_rmw_correct                        (tbp_rmw_correct                        ),
        .tbp_rmw_partial                        (tbp_rmw_partial                        ),
        .sb_tbp_precharge_all                   (sb_tbp_precharge_all                   ),
        .sb_do_precharge_all                    (sb_do_precharge_all                    ),
        .t_param_act_to_rdwr                    (t_param_act_to_rdwr                    ),
        .t_param_act_to_act                     (t_param_act_to_act                     ),
        .t_param_act_to_pch                     (t_param_act_to_pch                     ),
        .t_param_rd_to_pch                      (t_param_rd_to_pch                      ),
        .t_param_wr_to_pch                      (t_param_wr_to_pch                      ),
        .t_param_pch_to_valid                   (t_param_pch_to_valid                   ),
        .t_param_rd_ap_to_valid                 (t_param_rd_ap_to_valid                 ),
        .t_param_wr_ap_to_valid                 (t_param_wr_ap_to_valid                 ),
        .tbp_bank_active                        (tbp_bank_active                        ),
        .tbp_timer_ready                        (tbp_timer_ready                        ),
        .cfg_reorder_data                       (cfg_reorder_data                       ),
        .tbp_load                               (tbp_load                               ),
        .data_complete                          (data_complete                          ),
        .cfg_starve_limit                       (cfg_starve_limit                       ),
        .cfg_type                               (cfg_type                               )
    );
    
//==============================================================================
// alt_mem_ddrx_arbiter
//------------------------------------------------------------------------------
//
//  Arbiter block
//
//  Info: Priority command-aging arbiter, it will grant command with priority
//        first, during tie-break situation, oldest command will be granted.
//        Read comment in arbiter code for more information
//
//==============================================================================
    
    alt_mem_ddrx_arbiter #
    (
        .CFG_DWIDTH_RATIO           (CFG_DWIDTH_RATIO           ),
        .CFG_CTL_TBP_NUM            (CFG_CTL_TBP_NUM            ),
        .CFG_CTL_ARBITER_TYPE       (CFG_CTL_ARBITER_TYPE       ),
        .CFG_REG_GRANT              (CFG_REG_GRANT              ),
        .CFG_REG_REQ                (CFG_REG_REQ                ),
        .CFG_MEM_IF_CHIP            (CFG_MEM_IF_CHIP            ),
        .CFG_MEM_IF_CS_WIDTH        (CFG_MEM_IF_CS_WIDTH        ),
        .CFG_MEM_IF_BA_WIDTH        (CFG_MEM_IF_BA_WIDTH        ),
        .CFG_MEM_IF_ROW_WIDTH       (CFG_MEM_IF_ROW_WIDTH       ),
        .CFG_MEM_IF_COL_WIDTH       (CFG_MEM_IF_COL_WIDTH       ),
        .CFG_LOCAL_ID_WIDTH         (CFG_LOCAL_ID_WIDTH         ),
        .CFG_DATA_ID_WIDTH          (CFG_DATA_ID_WIDTH          ),
        .CFG_INT_SIZE_WIDTH         (CFG_INT_SIZE_WIDTH         ),
        .CFG_AFI_INTF_PHASE_NUM     (CFG_AFI_INTF_PHASE_NUM     ),
        .CFG_DISABLE_PRIORITY       (CFG_DISABLE_PRIORITY       )
    )
    arbiter_inst
    (
        .ctl_clk                    (ctl_clk                    ),
        .ctl_reset_n                (ctl_reset_n                ),
        .stall_row_arbiter          (stall_row_arbiter          ),
        .stall_col_arbiter          (stall_col_arbiter          ),
        .sb_do_precharge_all        (sb_do_precharge_all        ),
        .sb_do_refresh              (sb_do_refresh              ),
        .sb_do_self_refresh         (sb_do_self_refresh         ),
        .sb_do_power_down           (sb_do_power_down           ),
        .sb_do_deep_pdown           (sb_do_deep_pdown           ),
        .sb_do_zq_cal               (sb_do_zq_cal               ),
        .row_req                    (row_req                    ),
        .col_req                    (col_req                    ),
        .act_req                    (act_req                    ),
        .pch_req                    (pch_req                    ),
        .rd_req                     (rd_req                     ),
        .wr_req                     (wr_req                     ),
        .row_grant                  (row_grant                  ),
        .col_grant                  (col_grant                  ),
        .act_grant                  (act_grant                  ),
        .pch_grant                  (pch_grant                  ),
        .rd_grant                   (rd_grant                   ),
        .wr_grant                   (wr_grant                   ),
        .log2_row_grant             (log2_row_grant             ),
        .log2_col_grant             (log2_col_grant             ),
        .log2_act_grant             (log2_act_grant             ),
        .log2_pch_grant             (log2_pch_grant             ),
        .log2_rd_grant              (log2_rd_grant              ),
        .log2_wr_grant              (log2_wr_grant              ),
        .or_row_grant               (or_row_grant               ),
        .or_col_grant               (or_col_grant               ),
        .tbp_activate               (tbp_activate               ),
        .tbp_precharge              (tbp_precharge              ),
        .tbp_read                   (tbp_read                   ),
        .tbp_write                  (tbp_write                  ),
        .tbp_chipsel                (tbp_chipsel                ),
        .tbp_bank                   (tbp_bank                   ),
        .tbp_row                    (tbp_row                    ),
        .tbp_col                    (tbp_col                    ),
        .tbp_size                   (tbp_size                   ),
        .tbp_localid                (tbp_localid                ),
        .tbp_dataid                 (tbp_dataid                 ),
        .tbp_ap                     (tbp_ap                     ),
        .tbp_burst_chop             (tbp_burst_chop             ),
        .tbp_rmw_correct            (tbp_rmw_correct            ),
        .tbp_rmw_partial            (tbp_rmw_partial            ),
        .tbp_age                    (tbp_age                    ),
        .tbp_priority               (tbp_priority               ),
        .can_activate               (can_activate               ),
        .can_precharge              (can_precharge              ),
        .can_write                  (can_write                  ),
        .can_read                   (can_read                   ),
        .arb_do_write               (arb_do_write               ),
        .arb_do_read                (arb_do_read                ),
        .arb_do_burst_chop          (arb_do_burst_chop          ),
        .arb_do_burst_terminate     (arb_do_burst_terminate     ),
        .arb_do_auto_precharge      (arb_do_auto_precharge      ),
        .arb_do_rmw_correct         (arb_do_rmw_correct         ),
        .arb_do_rmw_partial         (arb_do_rmw_partial         ),
        .arb_do_activate            (arb_do_activate            ),
        .arb_do_precharge           (arb_do_precharge           ),
        .arb_do_precharge_all       (arb_do_precharge_all       ),
        .arb_do_refresh             (arb_do_refresh             ),
        .arb_do_self_refresh        (arb_do_self_refresh        ),
        .arb_do_power_down          (arb_do_power_down          ),
        .arb_do_deep_pdown          (arb_do_deep_pdown          ),
        .arb_do_zq_cal              (arb_do_zq_cal              ),
        .arb_do_lmr                 (arb_do_lmr                 ),
        .arb_to_chipsel             (arb_to_chipsel             ),
        .arb_to_chip                (arb_to_chip                ),
        .arb_to_bank                (arb_to_bank                ),
        .arb_to_row                 (arb_to_row                 ),
        .arb_to_col                 (arb_to_col                 ),
        .arb_localid                (arb_localid                ),
        .arb_dataid                 (arb_dataid                 ),
        .arb_size                   (arb_size                   )
    );
    
//==============================================================================
// alt_mem_ddrx_burst_gen
//------------------------------------------------------------------------------
//
//  Burst generation block
//
//  Info: Create DQ/DQS burst information for AFI block
//
//==============================================================================
    
    alt_mem_ddrx_burst_gen #
    (
        .CFG_DWIDTH_RATIO                       (CFG_DWIDTH_RATIO                       ),
        .CFG_CTL_ARBITER_TYPE                   (CFG_CTL_ARBITER_TYPE                   ),
        .CFG_REG_GRANT                          (CFG_REG_GRANT                          ),
        .CFG_MEM_IF_CHIP                        (CFG_MEM_IF_CHIP                        ),
        .CFG_MEM_IF_CS_WIDTH                    (CFG_MEM_IF_CS_WIDTH                    ),
        .CFG_MEM_IF_BA_WIDTH                    (CFG_MEM_IF_BA_WIDTH                    ),
        .CFG_MEM_IF_ROW_WIDTH                   (CFG_MEM_IF_ROW_WIDTH                   ),
        .CFG_MEM_IF_COL_WIDTH                   (CFG_MEM_IF_COL_WIDTH                   ),
        .CFG_LOCAL_ID_WIDTH                     (CFG_LOCAL_ID_WIDTH                     ),
        .CFG_DATA_ID_WIDTH                      (CFG_DATA_ID_WIDTH                      ),
        .CFG_INT_SIZE_WIDTH                     (CFG_INT_SIZE_WIDTH                     ),
        .CFG_AFI_INTF_PHASE_NUM                 (CFG_AFI_INTF_PHASE_NUM                 ),
        .CFG_PORT_WIDTH_TYPE                    (CFG_PORT_WIDTH_TYPE                    ),
        .CFG_PORT_WIDTH_BURST_LENGTH            (CFG_PORT_WIDTH_BURST_LENGTH            ),
        .CFG_PORT_WIDTH_TCCD                    (CFG_PORT_WIDTH_TCCD                    ),
        .CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT  (CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT  ),
        .CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE  (CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE  ),
        .CFG_ENABLE_BURST_GEN_OUTPUT_REG        (CFG_ENABLE_BURST_GEN_OUTPUT_REG        )
    )
    burst_gen_inst
    (
        .ctl_clk                                (ctl_clk                                ),
        .ctl_reset_n                            (ctl_reset_n                            ),
        .cfg_type                               (cfg_type                               ),
        .cfg_burst_length                       (cfg_burst_length                       ),
        .cfg_tccd                               (cfg_tccd                               ),
        .cfg_enable_burst_interrupt             (cfg_enable_burst_interrupt             ),
        .cfg_enable_burst_terminate             (cfg_enable_burst_terminate             ),
        .arb_do_write                           (arb_do_write                           ),
        .arb_do_read                            (arb_do_read                            ),
        .arb_do_burst_chop                      (arb_do_burst_chop                      ),
        .arb_do_burst_terminate                 (arb_do_burst_terminate                 ),
        .arb_do_auto_precharge                  (arb_do_auto_precharge                  ),
        .arb_do_rmw_correct                     (arb_do_rmw_correct                     ),
        .arb_do_rmw_partial                     (arb_do_rmw_partial                     ),
        .arb_do_activate                        (arb_do_activate                        ),
        .arb_do_precharge                       (arb_do_precharge                       ),
        .arb_do_precharge_all                   (arb_do_precharge_all                   ),
        .arb_do_refresh                         (arb_do_refresh                         ),
        .arb_do_self_refresh                    (arb_do_self_refresh                    ),
        .arb_do_power_down                      (arb_do_power_down                      ),
        .arb_do_deep_pdown                      (arb_do_deep_pdown                      ),
        .arb_do_zq_cal                          (arb_do_zq_cal                          ),
        .arb_do_lmr                             (arb_do_lmr                             ),
        .arb_to_chipsel                         (arb_to_chipsel                         ),
        .arb_to_chip                            (arb_to_chip                            ),
        .arb_to_bank                            (arb_to_bank                            ),
        .arb_to_row                             (arb_to_row                             ),
        .arb_to_col                             (arb_to_col                             ),
        .arb_localid                            (arb_localid                            ),
        .arb_dataid                             (arb_dataid                             ),
        .arb_size                               (arb_size                               ),
        .bg_do_write_combi                      (bg_do_write_combi                      ),
        .bg_do_read_combi                       (bg_do_read_combi                       ),
        .bg_do_burst_chop_combi                 (bg_do_burst_chop_combi                 ),
        .bg_do_burst_terminate_combi            (bg_do_burst_terminate_combi            ),
        .bg_do_activate_combi                   (bg_do_activate_combi                   ),
        .bg_do_precharge_combi                  (bg_do_precharge_combi                  ),
        .bg_to_chip_combi                       (bg_to_chip_combi                       ),
        .bg_effective_size_combi                (bg_effective_size_combi                ),
        .bg_interrupt_ready_combi               (bg_interrupt_ready_combi               ),
        .bg_do_write                            (bg_do_write                            ),
        .bg_do_read                             (bg_do_read                             ),
        .bg_do_burst_chop                       (bg_do_burst_chop                       ),
        .bg_do_burst_terminate                  (bg_do_burst_terminate                  ),
        .bg_do_auto_precharge                   (bg_do_auto_precharge                   ),
        .bg_do_rmw_correct                      (bg_do_rmw_correct                      ),
        .bg_do_rmw_partial                      (bg_do_rmw_partial                      ),
        .bg_do_activate                         (bg_do_activate                         ),
        .bg_do_precharge                        (bg_do_precharge                        ),
        .bg_do_precharge_all                    (bg_do_precharge_all                    ),
        .bg_do_refresh                          (bg_do_refresh                          ),
        .bg_do_self_refresh                     (bg_do_self_refresh                     ),
        .bg_do_power_down                       (bg_do_power_down                       ),
        .bg_do_deep_pdown                       (bg_do_deep_pdown                       ),
        .bg_do_zq_cal                           (bg_do_zq_cal                           ),
        .bg_do_lmr                              (bg_do_lmr                              ),
        .bg_to_chipsel                          (bg_to_chipsel                          ),
        .bg_to_chip                             (bg_to_chip                             ),
        .bg_to_bank                             (bg_to_bank                             ),
        .bg_to_row                              (bg_to_row                              ),
        .bg_to_col                              (bg_to_col                              ),
        .bg_doing_write                         (bg_doing_write                         ),
        .bg_doing_read                          (bg_doing_read                          ),
        .bg_rdwr_data_valid                     (bg_rdwr_data_valid                     ),
        .bg_interrupt_ready                     (bg_interrupt_ready                     ),
        .bg_localid                             (bg_localid                             ),
        .bg_dataid                              (bg_dataid                              ),
        .bg_size                                (bg_size                                ),
        .bg_effective_size                      (bg_effective_size                      )
    );
    
//==============================================================================
// alt_mem_ddrx_addr_cmd_wrap
//------------------------------------------------------------------------------
//
//  Address and command decoder block
//
//  Info: Trasalate controller internal command into AFI command
//
//==============================================================================
    
    // wire [CFG_MEM_IF_CHIP      - 1 : 0] temp_to_chip = bg_to_chip [CFG_MEM_IF_CHIP      - 1 : 0] | bg_to_chip [2 * CFG_MEM_IF_CHIP      - 1 : CFG_MEM_IF_CHIP     ];
    // wire [CFG_MEM_IF_BA_WIDTH  - 1 : 0] temp_to_bank = bg_to_bank [CFG_MEM_IF_BA_WIDTH  - 1 : 0] | bg_to_bank [2 * CFG_MEM_IF_BA_WIDTH  - 1 : CFG_MEM_IF_BA_WIDTH ];
    // wire [CFG_MEM_IF_ROW_WIDTH - 1 : 0] temp_to_row  = bg_to_row  [CFG_MEM_IF_ROW_WIDTH - 1 : 0] | bg_to_row  [2 * CFG_MEM_IF_ROW_WIDTH - 1 : CFG_MEM_IF_ROW_WIDTH];
    // wire [CFG_MEM_IF_COL_WIDTH - 1 : 0] temp_to_col  = bg_to_col  [CFG_MEM_IF_COL_WIDTH - 1 : 0] | bg_to_col  [2 * CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_COL_WIDTH];
    // 
    // wire [CFG_MEM_IF_CHIP - 1 : 0] temp_do_refresh       = bg_do_refresh       [CFG_MEM_IF_CHIP - 1 : 0] | bg_do_refresh       [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
    // wire [CFG_MEM_IF_CHIP - 1 : 0] temp_do_power_down    = bg_do_power_down    [CFG_MEM_IF_CHIP - 1 : 0] | bg_do_power_down    [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
    // wire [CFG_MEM_IF_CHIP - 1 : 0] temp_do_self_refresh  = bg_do_self_refresh  [CFG_MEM_IF_CHIP - 1 : 0] | bg_do_self_refresh  [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
    // wire [CFG_MEM_IF_CHIP - 1 : 0] temp_do_precharge_all = bg_do_precharge_all [CFG_MEM_IF_CHIP - 1 : 0] | bg_do_precharge_all [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
    // wire [CFG_MEM_IF_CHIP - 1 : 0] temp_do_deep_pdown    = bg_do_deep_pdown    [CFG_MEM_IF_CHIP - 1 : 0] | bg_do_deep_pdown    [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
    // wire [CFG_MEM_IF_CHIP - 1 : 0] temp_do_zq_cal        = bg_do_zq_cal        [CFG_MEM_IF_CHIP - 1 : 0] | bg_do_zq_cal        [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
    
    alt_mem_ddrx_addr_cmd_wrap #
    (
        .CFG_MEM_IF_CHIP                (CFG_MEM_IF_CHIP                ),
        .CFG_MEM_IF_CKE_WIDTH           (CFG_MEM_IF_CKE_WIDTH           ),
        .CFG_MEM_IF_ADDR_WIDTH          (CFG_AFI_IF_FR_ADDR_WIDTH       ),
        .CFG_MEM_IF_ROW_WIDTH           (CFG_MEM_IF_ROW_WIDTH           ),
        .CFG_MEM_IF_COL_WIDTH           (CFG_MEM_IF_COL_WIDTH           ),
        .CFG_MEM_IF_BA_WIDTH            (CFG_MEM_IF_BA_WIDTH            ),
        .CFG_LPDDR2_ENABLED             (CFG_LPDDR2_ENABLED             ),
        .CFG_DWIDTH_RATIO               (CFG_DWIDTH_RATIO               ),
        .CFG_ODT_ENABLED                (CFG_ODT_ENABLED                ),
        .CFG_MEM_IF_ODT_WIDTH           (CFG_MEM_IF_ODT_WIDTH           ),
        .CFG_AFI_INTF_PHASE_NUM         (CFG_AFI_INTF_PHASE_NUM         ),
        .CFG_LOCAL_ID_WIDTH             (CFG_LOCAL_ID_WIDTH             ),
        .CFG_DATA_ID_WIDTH              (CFG_DATA_ID_WIDTH              ),
        .CFG_INT_SIZE_WIDTH             (CFG_INT_SIZE_WIDTH             ),
        .CFG_PORT_WIDTH_TYPE            (CFG_PORT_WIDTH_TYPE            ),
        .CFG_PORT_WIDTH_CAS_WR_LAT      (CFG_PORT_WIDTH_CAS_WR_LAT      ),
        .CFG_PORT_WIDTH_TCL             (CFG_PORT_WIDTH_TCL             ),
        .CFG_PORT_WIDTH_ADD_LAT         (CFG_PORT_WIDTH_ADD_LAT         ),
        .CFG_PORT_WIDTH_WRITE_ODT_CHIP  (CFG_PORT_WIDTH_WRITE_ODT_CHIP  ),
        .CFG_PORT_WIDTH_READ_ODT_CHIP   (CFG_PORT_WIDTH_READ_ODT_CHIP   ),
        .CFG_PORT_WIDTH_OUTPUT_REGD     (CFG_PORT_WIDTH_OUTPUT_REGD     )
    )
    addr_cmd_wrap_inst
    (
        .ctl_clk                        (ctl_clk                        ),
        .ctl_reset_n                    (ctl_reset_n                    ),
        .ctl_cal_success                (ctl_cal_success                ),
        .cfg_type                       (cfg_type                       ),
        .cfg_tcl                        (cfg_tcl                        ),
        .cfg_cas_wr_lat                 (cfg_cas_wr_lat                 ),
        .cfg_add_lat                    (cfg_add_lat                    ),
        .cfg_write_odt_chip             (cfg_write_odt_chip             ),
        .cfg_read_odt_chip              (cfg_read_odt_chip              ),
        .cfg_burst_length               (cfg_burst_length               ),
        .cfg_output_regd_for_afi_output (cfg_output_regd_for_afi_output ),
        .bg_do_write                    (bg_do_write                    ),      
        .bg_do_read                     (bg_do_read                     ),      
        .bg_do_auto_precharge           (bg_do_auto_precharge           ),      
        .bg_do_burst_chop               (bg_do_burst_chop               ),      
        .bg_do_activate                 (bg_do_activate                 ),      
        .bg_do_precharge                (bg_do_precharge                ),      
        .bg_do_refresh                  (bg_do_refresh                  ),      
        .bg_do_power_down               (bg_do_power_down               ),      
        .bg_do_self_refresh             (bg_do_self_refresh             ),      
        .bg_do_rmw_correct              (bg_do_rmw_correct              ),      
        .bg_do_rmw_partial              (bg_do_rmw_partial              ),      
        .bg_do_lmr                      (bg_do_lmr                      ),      
        .bg_do_precharge_all            (bg_do_precharge_all            ),      
        .bg_do_zq_cal                   (bg_do_zq_cal                   ),      
        .bg_do_lmr_read                 (bg_do_lmr_read                 ),
        .bg_do_refresh_1bank            (bg_do_refresh_1bank            ),
        .bg_do_burst_terminate          (bg_do_burst_terminate          ),      
        .bg_do_deep_pdown               (bg_do_deep_pdown               ),      
        .bg_to_chip                     (bg_to_chip                     ),      
        .bg_to_bank                     (bg_to_bank                     ),      
        .bg_to_row                      (bg_to_row                      ),      
        .bg_to_col                      (bg_to_col                      ),      
        .bg_to_lmr                      (bg_to_lmr                      ),
        .bg_dataid                      (bg_dataid                      ),
        .bg_localid                     (bg_localid                     ),
        .bg_size                        (bg_size                        ),
        .lmr_opcode                     (lmr_opcode                     ),
        .afi_cke                        (afi_cke                        ),
        .afi_cs_n                       (afi_cs_n                       ),
        .afi_ras_n                      (afi_ras_n                      ),
        .afi_cas_n                      (afi_cas_n                      ),
        .afi_we_n                       (afi_we_n                       ),
        .afi_ba                         (afi_ba                         ),
        .afi_addr                       (afi_addr                       ),
        .afi_rst_n                      (afi_rst_n                      ),
        .afi_odt                        (afi_odt                        )
    );
    
//==============================================================================
// alt_mem_ddrx_odt_gen
//------------------------------------------------------------------------------
//
//  ODT generation block
//
//  Info: Generate ODT information based on user configuration
//
//==============================================================================
    
    // alt_mem_ddrx_odt_gen #
    // (
    //     .CFG_DWIDTH_RATIO               (CFG_DWIDTH_RATIO               ),
    //     .CFG_ODT_ENABLED                (CFG_ODT_ENABLED                ),
    //     .CFG_MEM_IF_CHIP                (CFG_MEM_IF_CHIP                ),
    //     .CFG_MEM_IF_ODT_WIDTH           (CFG_MEM_IF_ODT_WIDTH           ),
    //     .CFG_OUTPUT_REGD                (CFG_OUTPUT_REGD                ),
    //     .CFG_PORT_WIDTH_CAS_WR_LAT      (CFG_PORT_WIDTH_CAS_WR_LAT      ),
    //     .CFG_PORT_WIDTH_TCL             (CFG_PORT_WIDTH_TCL             ),
    //     .CFG_PORT_WIDTH_ADD_LAT         (CFG_PORT_WIDTH_ADD_LAT         ),
    //     .CFG_PORT_WIDTH_TYPE            (CFG_PORT_WIDTH_TYPE            )
    // )
    // odt_gen_inst
    // (
    //     .ctl_clk                        (ctl_clk                        ),
    //     .ctl_reset_n                    (ctl_reset_n                    ),
    //     .cfg_type                       (cfg_type                       ),
    //     .cfg_tcl                        (cfg_tcl                        ),
    //     .cfg_cas_wr_lat                 (cfg_cas_wr_lat                 ),
    //     .cfg_add_lat                    (cfg_add_lat                    ),
    //     .cfg_write_odt_chip             (cfg_write_odt_chip             ),
    //     .cfg_read_odt_chip              (cfg_read_odt_chip              ),
    //     .cfg_burst_length               (cfg_burst_length               ),
    //     .bg_do_read                     (bg_do_read                     ),
    //     .bg_do_write                    (bg_do_write                    ),
    //     .bg_to_chip                     (bg_to_chip                     ),
    //     .afi_odt                        (afi_odt                        )
    // );
    
//==============================================================================
// alt_mem_ddrx_rdwr_data_tmg
//------------------------------------------------------------------------------
//
//  Read / write data timing block
//
//  Info: Adjust read and write data timing based on AFI information
//
//==============================================================================
 	
    alt_mem_ddrx_rdwr_data_tmg #
    (
        .CFG_DWIDTH_RATIO                   (CFG_DWIDTH_RATIO                   ),
        .CFG_MEM_IF_DQ_WIDTH                (CFG_MEM_IF_DQ_WIDTH                ),
        .CFG_MEM_IF_DQS_WIDTH               (CFG_MEM_IF_DQS_WIDTH               ),
        .CFG_MEM_IF_DM_WIDTH                (CFG_MEM_IF_DM_WIDTH                ),
        .CFG_WLAT_BUS_WIDTH                 (CFG_WLAT_BUS_WIDTH                 ),
        .CFG_DRAM_WLAT_GROUP                (CFG_DRAM_WLAT_GROUP                ),
        .CFG_DATA_ID_WIDTH                  (CFG_DATA_ID_WIDTH                  ),
        .CFG_WDATA_REG                      (CFG_WDATA_REG                      ),
        .CFG_ECC_ENC_REG                    (CFG_ECC_ENC_REG                    ),
        .CFG_AFI_INTF_PHASE_NUM             (CFG_AFI_INTF_PHASE_NUM             ),
        .CFG_PORT_WIDTH_ENABLE_ECC          (CFG_PORT_WIDTH_ENABLE_ECC          ),
        .CFG_PORT_WIDTH_OUTPUT_REGD         (CFG_PORT_WIDTH_OUTPUT_REGD         )
    )
    rdwr_data_tmg_inst
    (
        .ctl_clk                            (ctl_clk                            ),
        .ctl_reset_n                        (ctl_reset_n                        ),
        .cfg_enable_ecc                     (cfg_enable_ecc                     ),
        .cfg_output_regd                    (cfg_output_regd                    ),
        .cfg_output_regd_for_afi_output     (cfg_output_regd_for_afi_output     ),
        .bg_doing_read                      (bg_doing_read                      ),
        .bg_doing_write                     (bg_doing_write                     ),
        .bg_rdwr_data_valid                 (bg_rdwr_data_valid                 ),
        .dataid                             (bg_dataid                          ),
        .bg_do_rmw_correct                  (bg_do_rmw_correct                  ),      
        .bg_do_rmw_partial                  (bg_do_rmw_partial                  ),      
        .ecc_wdata                          (ecc_wdata                          ),
        .ecc_dm                             (ecc_dm                             ),
        .afi_wlat                           (afi_wlat                           ),
        .afi_doing_read                     (afi_rdata_en                       ),
        .afi_doing_read_full                (afi_rdata_en_full                  ),
        .ecc_wdata_fifo_read                (ecc_wdata_fifo_read                ),
        .ecc_wdata_fifo_dataid              (ecc_wdata_fifo_dataid              ),
        .ecc_wdata_fifo_dataid_vector       (ecc_wdata_fifo_dataid_vector       ),
        .ecc_wdata_fifo_rmw_correct         (ecc_wdata_fifo_rmw_correct         ),
        .ecc_wdata_fifo_rmw_partial         (ecc_wdata_fifo_rmw_partial         ),
        .ecc_wdata_fifo_read_first          (ecc_wdata_fifo_read_first          ),
        .ecc_wdata_fifo_dataid_first        (ecc_wdata_fifo_dataid_first        ),
        .ecc_wdata_fifo_dataid_vector_first (ecc_wdata_fifo_dataid_vector_first ),
        .ecc_wdata_fifo_rmw_correct_first   (ecc_wdata_fifo_rmw_correct_first   ),
        .ecc_wdata_fifo_rmw_partial_first   (ecc_wdata_fifo_rmw_partial_first   ),
        .ecc_wdata_fifo_first_vector        (ecc_wdata_fifo_first_vector        ),
        .ecc_wdata_fifo_read_last           (ecc_wdata_fifo_read_last           ),
        .ecc_wdata_fifo_dataid_last         (ecc_wdata_fifo_dataid_last         ),
        .ecc_wdata_fifo_dataid_vector_last  (ecc_wdata_fifo_dataid_vector_last  ),
        .ecc_wdata_fifo_rmw_correct_last    (ecc_wdata_fifo_rmw_correct_last    ),
        .ecc_wdata_fifo_rmw_partial_last    (ecc_wdata_fifo_rmw_partial_last    ),
        .afi_dqs_burst                      (afi_dqs_burst                      ),
        .afi_wdata_valid                    (afi_wdata_valid                    ),
        .afi_wdata                          (afi_wdata                          ),
        .afi_dm                             (afi_dm                             )
    );
    
//==============================================================================
// alt_mem_ddrx_wdata_path
//------------------------------------------------------------------------------
//
//  Write data path block
//
//  Info: Handles write data processing
//
//==============================================================================
   
    // match datapath id width, with command path id width
    generate
    begin : gen_resolve_datap_id
        genvar i;
        for (i = 0;i < CFG_DRAM_WLAT_GROUP;i = i + 1)
        begin : write_dataid_per_dqs_group
            if (CFG_WRDATA_ID_WIDTH < CFG_DATA_ID_WIDTH)
            begin
                assign ecc_wdata_wrdataid        [(i + 1) * CFG_WRDATA_ID_WIDTH     - 1 : i * CFG_WRDATA_ID_WIDTH    ] = ecc_wdata_fifo_dataid        [(i * CFG_DATA_ID_WIDTH     ) + CFG_WRDATA_ID_WIDTH     - 1 : i * CFG_DATA_ID_WIDTH     ];
                assign ecc_wdata_wrdataid_vector [(i + 1) * CFG_WRDATA_VEC_ID_WIDTH - 1 : i * CFG_WRDATA_VEC_ID_WIDTH] = ecc_wdata_fifo_dataid_vector [(i * CFG_DATAID_ARRAY_DEPTH) + CFG_WRDATA_VEC_ID_WIDTH - 1 : i * CFG_DATAID_ARRAY_DEPTH];
            end
            else    // (CFG_WRDATA_ID_WIDTH >= CFG_DATA_ID_WIDTH)
            begin
                assign ecc_wdata_wrdataid        [(i + 1) * CFG_WRDATA_ID_WIDTH     - 1 : i * CFG_WRDATA_ID_WIDTH    ] = {{(CFG_WRDATA_ID_WIDTH-CFG_DATA_ID_WIDTH){1'b0}},ecc_wdata_fifo_dataid        [(i * CFG_DATA_ID_WIDTH     ) + CFG_WRDATA_ID_WIDTH     - 1 : i * CFG_DATA_ID_WIDTH     ]};
                assign ecc_wdata_wrdataid_vector [(i + 1) * CFG_WRDATA_VEC_ID_WIDTH - 1 : i * CFG_WRDATA_VEC_ID_WIDTH] = {{CFG_DATA_ID_REMAINDER                  {1'b0}},ecc_wdata_fifo_dataid_vector [(i * CFG_DATAID_ARRAY_DEPTH) + CFG_WRDATA_VEC_ID_WIDTH - 1 : i * CFG_DATAID_ARRAY_DEPTH]};
            end
        end
        
        if (CFG_WRDATA_ID_WIDTH < CFG_DATA_ID_WIDTH)
        begin
            assign wdatap_free_id_dataid           = {{(CFG_DATA_ID_WIDTH-CFG_WRDATA_ID_WIDTH){1'b0}},wdatap_free_id_wrdataid};
            assign ecc_wdata_wrdataid_first        = ecc_wdata_fifo_dataid_first;
            assign ecc_wdata_wrdataid_vector_first = ecc_wdata_fifo_dataid_vector_first;
            assign ecc_wdata_wrdataid_last         = ecc_wdata_fifo_dataid_last;
            assign ecc_wdata_wrdataid_vector_last  = ecc_wdata_fifo_dataid_vector_last;
        end
        else    // (CFG_WRDATA_ID_WIDTH >= CFG_DATA_ID_WIDTH)
        begin
            assign wdatap_free_id_dataid           = wdatap_free_id_wrdataid[CFG_DATA_ID_WIDTH-1:0];
            assign ecc_wdata_wrdataid_first        = {{(CFG_WRDATA_ID_WIDTH-CFG_DATA_ID_WIDTH){1'b0}},ecc_wdata_fifo_dataid_first};
            assign ecc_wdata_wrdataid_vector_first = {{CFG_DATA_ID_REMAINDER{1'b0}},ecc_wdata_fifo_dataid_vector_first};
            assign ecc_wdata_wrdataid_last         = {{(CFG_WRDATA_ID_WIDTH-CFG_DATA_ID_WIDTH){1'b0}},ecc_wdata_fifo_dataid_last};
            assign ecc_wdata_wrdataid_vector_last  = {{CFG_DATA_ID_REMAINDER{1'b0}},ecc_wdata_fifo_dataid_vector_last};
        end
        
        if (CFG_RDDATA_ID_WIDTH < CFG_DATA_ID_WIDTH)
        begin
            assign rdatap_free_id_dataid = {{(CFG_DATA_ID_WIDTH-CFG_RDDATA_ID_WIDTH){1'b0}},rdatap_free_id_rddataid};
            assign bg_rddataid           = bg_dataid[CFG_RDDATA_ID_WIDTH-1:0];
        end
        else    // (CFG_RDDATA_ID_WIDTH >= CFG_DATA_ID_WIDTH)
        begin
            assign rdatap_free_id_dataid = rdatap_free_id_rddataid[CFG_DATA_ID_WIDTH-1:0];
            assign bg_rddataid           = {{(CFG_RDDATA_ID_WIDTH-CFG_DATA_ID_WIDTH){1'b0}},bg_dataid};
        end
    end
    endgenerate


    alt_mem_ddrx_wdata_path #
    (
        .CFG_LOCAL_DATA_WIDTH                       (CFG_LOCAL_DATA_WIDTH           ),
        .CFG_MEM_IF_DQ_WIDTH                        (CFG_MEM_IF_DQ_WIDTH            ),
        .CFG_MEM_IF_DQS_WIDTH                       (CFG_MEM_IF_DQS_WIDTH           ),
        .CFG_INT_SIZE_WIDTH                         (CFG_INT_SIZE_WIDTH             ),
        .CFG_DATA_ID_WIDTH                          (CFG_WRDATA_ID_WIDTH            ),
        .CFG_DRAM_WLAT_GROUP                        (CFG_DRAM_WLAT_GROUP            ),
        .CFG_LOCAL_WLAT_GROUP                       (CFG_LOCAL_WLAT_GROUP           ),
        .CFG_TBP_NUM                                (CFG_CTL_TBP_NUM                ),
        .CFG_BUFFER_ADDR_WIDTH                      (CFG_WRBUFFER_ADDR_WIDTH        ),
        .CFG_DWIDTH_RATIO                           (CFG_DWIDTH_RATIO               ),
        .CFG_ECC_MULTIPLES                          (CFG_ECC_MULTIPLES              ),
        .CFG_WDATA_REG                              (CFG_WDATA_REG                  ),
        .CFG_PARTIAL_BE_PER_WORD_ENABLE             (CFG_PARTIAL_BE_PER_WORD_ENABLE ),
        .CFG_ECC_CODE_WIDTH                         (CFG_ECC_CODE_WIDTH             ),
        .CFG_PORT_WIDTH_BURST_LENGTH                (CFG_PORT_WIDTH_BURST_LENGTH    ),
        .CFG_PORT_WIDTH_ENABLE_ECC                  (CFG_PORT_WIDTH_ENABLE_ECC      ),
        .CFG_PORT_WIDTH_ENABLE_AUTO_CORR            (CFG_PORT_WIDTH_ENABLE_AUTO_CORR),
        .CFG_PORT_WIDTH_ENABLE_NO_DM                (CFG_PORT_WIDTH_ENABLE_NO_DM    ),
        .CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES  (CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES),
        .CFG_PORT_WIDTH_INTERFACE_WIDTH             (CFG_PORT_WIDTH_INTERFACE_WIDTH )
    )
    wdata_path_inst
    (
        .ctl_clk                                    (ctl_clk                            ),
        .ctl_reset_n                                (ctl_reset_n                        ),
        .cfg_burst_length                           (cfg_burst_length                   ),
        .cfg_enable_ecc                             (cfg_enable_ecc                     ),
        .cfg_enable_auto_corr                       (cfg_enable_auto_corr               ),
        .cfg_enable_no_dm                           (cfg_enable_no_dm                   ),
        .cfg_enable_ecc_code_overwrites             (cfg_enable_ecc_code_overwrites     ),
        .cfg_interface_width                        (cfg_interface_width                ),
        .wdatap_free_id_valid                       (wdatap_free_id_valid               ),
        .wdatap_free_id_dataid                      (wdatap_free_id_wrdataid            ),
        .proc_busy                                  (proc_busy                          ),
        .proc_load                                  (proc_load                          ),
        .proc_load_dataid                           (proc_load_dataid                   ),
        .proc_write                                 (proc_write                         ),
        .tbp_load_index                             (tbp_load_index                     ),
        .proc_size                                  (proc_size                          ),
        .wr_data_mem_full                           (wr_data_mem_full                   ),
        .write_data_en                              (write_data_valid                   ),
        .write_data                                 (write_data                         ),
        .byte_en                                    (byte_en                            ),
        .data_complete                              (data_complete                      ),
        .data_rmw_complete                          (data_rmw_complete                  ),
        .data_partial_be                            (data_partial_be                    ),
        .doing_write                                (ecc_wdata_fifo_read                ),
        .dataid                                     (ecc_wdata_wrdataid                 ),
        .dataid_vector                              (ecc_wdata_wrdataid_vector          ),
        .rdwr_data_valid                            (ecc_wdata_fifo_read                ),
        .rmw_correct                                (ecc_wdata_fifo_rmw_correct         ),
        .rmw_partial                                (ecc_wdata_fifo_rmw_partial         ),
        .doing_write_first                          (ecc_wdata_fifo_read_first          ),
        .dataid_first                               (ecc_wdata_wrdataid_first           ),
        .dataid_vector_first                        (ecc_wdata_wrdataid_vector_first    ),
        .rdwr_data_valid_first                      (ecc_wdata_fifo_read_first          ),
        .rmw_correct_first                          (ecc_wdata_fifo_rmw_correct_first   ),
        .rmw_partial_first                          (ecc_wdata_fifo_rmw_partial_first   ),
        .doing_write_first_vector                   (ecc_wdata_fifo_first_vector        ),
        .rdwr_data_valid_first_vector               (ecc_wdata_fifo_first_vector        ),
        .doing_write_last                           (ecc_wdata_fifo_read_last           ),
        .dataid_last                                (ecc_wdata_wrdataid_last            ),
        .dataid_vector_last                         (ecc_wdata_wrdataid_vector_last     ),
        .rdwr_data_valid_last                       (ecc_wdata_fifo_read_last           ),
        .rmw_correct_last                           (ecc_wdata_fifo_rmw_correct_last    ),
        .rmw_partial_last                           (ecc_wdata_fifo_rmw_partial_last    ),
        .wdatap_data                                (wdatap_data                        ),
        .wdatap_rmw_partial_data                    (wdatap_rmw_partial_data            ),
        .wdatap_rmw_correct_data                    (wdatap_rmw_correct_data            ),
        .wdatap_rmw_partial                         (wdatap_rmw_partial                 ),
        .wdatap_rmw_correct                         (wdatap_rmw_correct                 ),
        .wdatap_dm                                  (wdatap_dm                          ),
        .wdatap_ecc_code                            (wdatap_ecc_code                    ),
        .wdatap_ecc_code_overwrite                  (wdatap_ecc_code_overwrite          ),
        .rmwfifo_data_valid                         (rmwfifo_data_valid                 ),
        .rmwfifo_data                               (rmwfifo_data                       ),
        .rmwfifo_ecc_dbe                            (rmwfifo_ecc_dbe                    ),
        .rmwfifo_ecc_code                           (rmwfifo_ecc_code                   )
    );
    
//==============================================================================
// alt_mem_ddrx_rdata_path
//------------------------------------------------------------------------------
//
//  Read data path block
//
//  Info: Handles read data processing
//
//==============================================================================

    alt_mem_ddrx_rdata_path #
    (
        .CFG_LOCAL_DATA_WIDTH               (CFG_LOCAL_DATA_WIDTH               ),
        .CFG_INT_SIZE_WIDTH                 (CFG_INT_SIZE_WIDTH                 ),
        .CFG_DATA_ID_WIDTH                  (CFG_RDDATA_ID_WIDTH                ),
        .CFG_LOCAL_ID_WIDTH                 (CFG_LOCAL_ID_WIDTH                 ),
        .CFG_LOCAL_ADDR_WIDTH               (CFG_LOCAL_ADDR_WIDTH               ),
        .CFG_BUFFER_ADDR_WIDTH              (CFG_RDBUFFER_ADDR_WIDTH            ),
        .CFG_MEM_IF_CS_WIDTH                (CFG_MEM_IF_CS_WIDTH                ),
        .CFG_MEM_IF_BA_WIDTH                (CFG_MEM_IF_BA_WIDTH                ),
        .CFG_MEM_IF_ROW_WIDTH               (CFG_MEM_IF_ROW_WIDTH               ),
        .CFG_MEM_IF_COL_WIDTH               (CFG_MEM_IF_COL_WIDTH               ),
        .CFG_MAX_READ_CMD_NUM_WIDTH         (CFG_MAX_PENDING_RD_CMD_WIDTH       ),
        .CFG_RDATA_RETURN_MODE              (CFG_RDATA_RETURN_MODE              ),
        .CFG_AFI_INTF_PHASE_NUM             (CFG_AFI_INTF_PHASE_NUM             ),
        .CFG_ERRCMD_FIFO_ADDR_WIDTH         (CFG_ERRCMD_FIFO_ADDR_WIDTH         ),
        .CFG_DWIDTH_RATIO                   (CFG_DWIDTH_RATIO                   ),
        .CFG_ECC_MULTIPLES                  (CFG_ECC_MULTIPLES                  ),
        .CFG_ECC_CODE_WIDTH                 (CFG_ECC_CODE_WIDTH                 ),
        .CFG_PORT_WIDTH_TYPE                (CFG_PORT_WIDTH_TYPE                ),
        .CFG_PORT_WIDTH_ENABLE_ECC          (CFG_PORT_WIDTH_ENABLE_ECC          ),
        .CFG_PORT_WIDTH_ENABLE_AUTO_CORR    (CFG_PORT_WIDTH_ENABLE_AUTO_CORR    ),
        .CFG_PORT_WIDTH_ENABLE_NO_DM        (CFG_PORT_WIDTH_ENABLE_NO_DM        ),
        .CFG_PORT_WIDTH_BURST_LENGTH        (CFG_PORT_WIDTH_BURST_LENGTH        ),
        .CFG_PORT_WIDTH_ADDR_ORDER          (CFG_PORT_WIDTH_ADDR_ORDER          ),
        .CFG_PORT_WIDTH_COL_ADDR_WIDTH      (CFG_PORT_WIDTH_COL_ADDR_WIDTH      ),
        .CFG_PORT_WIDTH_ROW_ADDR_WIDTH      (CFG_PORT_WIDTH_ROW_ADDR_WIDTH      ),
        .CFG_PORT_WIDTH_BANK_ADDR_WIDTH     (CFG_PORT_WIDTH_BANK_ADDR_WIDTH     ),
        .CFG_PORT_WIDTH_CS_ADDR_WIDTH       (CFG_PORT_WIDTH_CS_ADDR_WIDTH       )
    )
    rdata_path_inst
    (
        .ctl_clk                            (ctl_clk                            ),
        .ctl_reset_n                        (ctl_reset_n                        ),
        .cfg_type                           (cfg_type                           ),
        .cfg_enable_ecc                     (cfg_enable_ecc                     ),
        .cfg_enable_auto_corr               (cfg_enable_auto_corr               ),
        .cfg_enable_no_dm                   (cfg_enable_no_dm                   ),
        .cfg_burst_length                   (cfg_burst_length                   ),
        .cfg_addr_order                     (cfg_addr_order                     ),
        .cfg_col_addr_width                 (cfg_col_addr_width                 ),
        .cfg_row_addr_width                 (cfg_row_addr_width                 ),
        .cfg_bank_addr_width                (cfg_bank_addr_width                ),
        .cfg_cs_addr_width                  (cfg_cs_addr_width                  ),
        .rdatap_free_id_valid               (rdatap_free_id_valid               ),
        .rdatap_free_id_dataid              (rdatap_free_id_rddataid            ),
        .proc_busy                          (proc_busy                          ),
        .proc_load                          (proc_load                          ),
        .proc_load_dataid                   (proc_load_dataid                   ),
        .proc_read                          (proc_read                          ),
        .proc_size                          (proc_size                          ),
        .proc_localid                       (proc_localid                       ),
        .read_data_valid                    (read_data_valid                    ),
        .read_data                          (read_data                          ),
        .read_data_error                    (read_data_error                    ),
        .read_data_localid                  (read_data_localid                  ),
        .bg_do_read                         (bg_do_read                         ),
        .bg_to_chipsel                      (bg_to_chipsel                      ),
        .bg_to_bank                         (bg_to_bank                         ),
        .bg_to_row                          (bg_to_row                          ),
        .bg_to_column                       (bg_to_col                          ),
        .bg_dataid                          (bg_rddataid                        ),
        .bg_localid                         (bg_localid                         ),
        .bg_size                            (bg_size                            ),
        .bg_do_rmw_correct                  (bg_do_rmw_correct                  ),
        .bg_do_rmw_partial                  (bg_do_rmw_partial                  ),
        .ecc_rdata                          (ecc_rdata                          ),
        .ecc_rdatav                         (ecc_rdata_valid                    ),
        .ecc_sbe                            (ecc_sbe                            ),
        .ecc_dbe                            (ecc_dbe                            ),
        .ecc_code                           (ecc_code                           ),
        .errcmd_ready                       (errcmd_ready                       ),
        .errcmd_valid                       (errcmd_valid                       ),
        .errcmd_chipsel                     (errcmd_chipsel                     ),
        .errcmd_bank                        (errcmd_bank                        ),
        .errcmd_row                         (errcmd_row                         ),
        .errcmd_column                      (errcmd_column                      ),
        .errcmd_size                        (errcmd_size                        ),
        .errcmd_localid                     (errcmd_localid                     ),
        .rdatap_rcvd_addr                   (rdatap_rcvd_addr                   ),
        .rdatap_rcvd_cmd                    (rdatap_rcvd_cmd                    ),
        .rdatap_rcvd_corr_dropped           (rdatap_rcvd_corr_dropped           ),
        .rmwfifo_data_valid                 (rmwfifo_data_valid                 ),
        .rmwfifo_data                       (rmwfifo_data                       ),
        .rmwfifo_ecc_dbe                    (rmwfifo_ecc_dbe                    ),
        .rmwfifo_ecc_code                   (rmwfifo_ecc_code                   )
    );
    
//==============================================================================
//  alt_mem_ddrx_ecc_encoder_decoder_wrapper
//------------------------------------------------------------------------------
//
//  ECC encoder/decoder block
//
//  Info: Encode write data and decode read data, correct single bit error
//        and detect double bit errors
//
//==============================================================================
    
    alt_mem_ddrx_ecc_encoder_decoder_wrapper #
    (
        .CFG_LOCAL_ADDR_WIDTH                   (CFG_LOCAL_ADDR_WIDTH               ),
        .CFG_LOCAL_DATA_WIDTH                   (CFG_LOCAL_DATA_WIDTH               ),
        .CFG_DWIDTH_RATIO                       (CFG_DWIDTH_RATIO                   ),
        .CFG_ECC_MULTIPLES                      (CFG_ECC_MULTIPLES                  ),
        .CFG_MEM_IF_DQ_WIDTH                    (CFG_MEM_IF_DQ_WIDTH                ),
        .CFG_MEM_IF_DQS_WIDTH                   (CFG_MEM_IF_DQS_WIDTH               ),
        .CFG_ECC_CODE_WIDTH                     (CFG_ECC_CODE_WIDTH                 ),
        .CFG_ECC_ENC_REG                        (CFG_ECC_ENC_REG                    ),
        .CFG_ECC_DEC_REG                        (CFG_ECC_DEC_REG                    ),
        .CFG_ECC_RDATA_REG                      (CFG_ECC_RDATA_REG                  ),
        .CFG_PORT_WIDTH_INTERFACE_WIDTH         (CFG_PORT_WIDTH_INTERFACE_WIDTH     ),
        .CFG_PORT_WIDTH_ENABLE_ECC              (CFG_PORT_WIDTH_ENABLE_ECC          ),
        .CFG_PORT_WIDTH_GEN_SBE                 (CFG_PORT_WIDTH_GEN_SBE             ),
        .CFG_PORT_WIDTH_GEN_DBE                 (CFG_PORT_WIDTH_GEN_DBE             ),
        .CFG_PORT_WIDTH_ENABLE_INTR             (CFG_PORT_WIDTH_ENABLE_INTR         ),
        .CFG_PORT_WIDTH_MASK_SBE_INTR           (CFG_PORT_WIDTH_MASK_SBE_INTR       ),
        .CFG_PORT_WIDTH_MASK_DBE_INTR           (CFG_PORT_WIDTH_MASK_DBE_INTR       ),
        .CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR  (CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR),
        .CFG_PORT_WIDTH_CLR_INTR                (CFG_PORT_WIDTH_CLR_INTR            ),
        .STS_PORT_WIDTH_SBE_ERROR               (STS_PORT_WIDTH_SBE_ERROR           ),
        .STS_PORT_WIDTH_DBE_ERROR               (STS_PORT_WIDTH_DBE_ERROR           ),
        .STS_PORT_WIDTH_SBE_COUNT               (STS_PORT_WIDTH_SBE_COUNT           ),
        .STS_PORT_WIDTH_DBE_COUNT               (STS_PORT_WIDTH_DBE_COUNT           ),
        .STS_PORT_WIDTH_CORR_DROP_ERROR         (STS_PORT_WIDTH_CORR_DROP_ERROR     ),
        .STS_PORT_WIDTH_CORR_DROP_COUNT         (STS_PORT_WIDTH_CORR_DROP_COUNT     )
    )
    ecc_encoder_decoder_wrapper_inst
    (
        .ctl_clk                            (ctl_clk                            ),
        .ctl_reset_n                        (ctl_reset_n                        ),
        .cfg_interface_width                (cfg_interface_width                ),
        .cfg_enable_ecc                     (cfg_enable_ecc                     ),
        .cfg_gen_sbe                        (cfg_gen_sbe                        ),
        .cfg_gen_dbe                        (cfg_gen_dbe                        ),
        .cfg_enable_intr                    (cfg_enable_intr                    ),
        .cfg_mask_sbe_intr                  (cfg_mask_sbe_intr                  ),
        .cfg_mask_dbe_intr                  (cfg_mask_dbe_intr                  ),
        .cfg_mask_corr_dropped_intr         (cfg_mask_corr_dropped_intr         ),
        .cfg_clr_intr                       (cfg_clr_intr                       ),
        .wdatap_dm                          (wdatap_dm                          ),
        .wdatap_data                        (wdatap_data                        ),
        .wdatap_rmw_partial_data            (wdatap_rmw_partial_data            ),
        .wdatap_rmw_correct_data            (wdatap_rmw_correct_data            ),
        .wdatap_rmw_partial                 (wdatap_rmw_partial                 ),
        .wdatap_rmw_correct                 (wdatap_rmw_correct                 ),
        .wdatap_ecc_code                    (wdatap_ecc_code                    ),
        .wdatap_ecc_code_overwrite          (wdatap_ecc_code_overwrite          ),
        .rdatap_rcvd_addr                   (rdatap_rcvd_addr                   ),
        .rdatap_rcvd_cmd                    (rdatap_rcvd_cmd                    ),
        .rdatap_rcvd_corr_dropped           (rdatap_rcvd_corr_dropped           ),
        .afi_rdata                          (afi_rdata                          ),
        .afi_rdata_valid                    (afi_rdata_valid                    ),
        .ecc_rdata                          (ecc_rdata                          ),
        .ecc_rdata_valid                    (ecc_rdata_valid                    ),
        .ecc_dm                             (ecc_dm                             ),
        .ecc_wdata                          (ecc_wdata                          ),
        .ecc_sbe                            (ecc_sbe                            ),
        .ecc_dbe                            (ecc_dbe                            ),
        .ecc_code                           (ecc_code                           ),
        .ecc_interrupt                      (ecc_interrupt                      ),
        .sts_sbe_error                      (sts_sbe_error                      ),
        .sts_dbe_error                      (sts_dbe_error                      ),
        .sts_sbe_count                      (sts_sbe_count                      ),
        .sts_dbe_count                      (sts_dbe_count                      ),
        .sts_err_addr                       (sts_err_addr                       ),
        .sts_corr_dropped                   (sts_corr_dropped                   ),
        .sts_corr_dropped_count             (sts_corr_dropped_count             ),
        .sts_corr_dropped_addr              (sts_corr_dropped_addr              )
    );
    
//==============================================================================
//  alt_mem_ddrx_sideband
//------------------------------------------------------------------------------
//
//  Sideband block
//
//  Info: Monitor and issue sideband specific commands such as user/auto
//        refresh, self refresh, power down, deep power down, 
//        precharge all and zq calibration commands
//
//==============================================================================
    
    alt_mem_ddrx_sideband #
    (
        .CFG_PORT_WIDTH_TYPE                    (CFG_PORT_WIDTH_TYPE                    ),
        .CFG_DWIDTH_RATIO                       (CFG_DWIDTH_RATIO                       ),
        .CFG_REG_GRANT                          (CFG_REG_GRANT                          ),
        .CFG_CTL_TBP_NUM                        (CFG_CTL_TBP_NUM                        ),
        .CFG_MEM_IF_CS_WIDTH                    (CFG_MEM_IF_CS_WIDTH                    ),
        .CFG_MEM_IF_CHIP                        (CFG_MEM_IF_CHIP                        ),
        .CFG_MEM_IF_BA_WIDTH                    (CFG_MEM_IF_BA_WIDTH                    ),
        .CFG_PORT_WIDTH_TCL                     (CFG_PORT_WIDTH_TCL                     ),
        .CFG_MEM_IF_CLK_PAIR_COUNT              (CFG_MEM_IF_CLK_PAIR_COUNT              ),
        .CFG_RANK_TIMER_OUTPUT_REG              (CFG_RANK_TIMER_OUTPUT_REG              ),
        .T_PARAM_ARF_TO_VALID_WIDTH             (T_PARAM_ARF_TO_VALID_WIDTH             ),
        .T_PARAM_ARF_PERIOD_WIDTH               (T_PARAM_ARF_PERIOD_WIDTH               ),
        .T_PARAM_PCH_ALL_TO_VALID_WIDTH         (T_PARAM_PCH_ALL_TO_VALID_WIDTH         ),
        .T_PARAM_SRF_TO_VALID_WIDTH             (T_PARAM_SRF_TO_VALID_WIDTH             ),
        .T_PARAM_SRF_TO_ZQ_CAL_WIDTH            (T_PARAM_SRF_TO_ZQ_CAL_WIDTH            ),
        .T_PARAM_PDN_TO_VALID_WIDTH             (T_PARAM_PDN_TO_VALID_WIDTH             ),
        .T_PARAM_PDN_PERIOD_WIDTH               (T_PARAM_PDN_PERIOD_WIDTH               ),
        .T_PARAM_POWER_SAVING_EXIT_WIDTH        (T_PARAM_POWER_SAVING_EXIT_WIDTH        )
    )
    sideband_inst
    (
        .ctl_clk                                (ctl_clk                                ),
        .ctl_reset_n                            (ctl_reset_n                            ),
        .rfsh_req                               (rfsh_req                               ),
        .rfsh_chip                              (rfsh_chip                              ),
        .rfsh_ack                               (rfsh_ack                               ),
        .self_rfsh_req                          (self_rfsh_req                          ),
        .self_rfsh_chip                         (self_rfsh_chip                         ),
        .self_rfsh_ack                          (self_rfsh_ack                          ),
        .deep_powerdn_req                       (deep_powerdn_req                       ),
        .deep_powerdn_chip                      (deep_powerdn_chip                      ),
        .deep_powerdn_ack                       (deep_powerdn_ack                       ),
        .power_down_ack                         (power_down_ack                         ),
        .stall_row_arbiter                      (stall_row_arbiter                      ),
        .stall_col_arbiter                      (stall_col_arbiter                      ),
        .stall_chip                             (stall_chip                             ),
        .sb_do_precharge_all                    (sb_do_precharge_all                    ),
        .sb_do_refresh                          (sb_do_refresh                          ),
        .sb_do_self_refresh                     (sb_do_self_refresh                     ),
        .sb_do_power_down                       (sb_do_power_down                       ),
        .sb_do_deep_pdown                       (sb_do_deep_pdown                       ),
        .sb_do_zq_cal                           (sb_do_zq_cal                           ),
        .sb_tbp_precharge_all                   (sb_tbp_precharge_all                   ),
        .ctl_mem_clk_disable                    (ctl_mem_clk_disable                    ),
        .ctl_init_req                           (ctl_init_req                           ),
        .ctl_cal_success                        (ctl_cal_success                        ),
        .cmd_gen_chipsel                        (cmd_gen_chipsel                        ),
        .tbp_chipsel                            (tbp_chipsel                            ),
        .tbp_load                               (tbp_load                               ),
        .t_param_arf_to_valid                   (t_param_arf_to_valid                   ),
        .t_param_arf_period                     (t_param_arf_period                     ),
        .t_param_pch_all_to_valid               (t_param_pch_all_to_valid               ),
        .t_param_srf_to_valid                   (t_param_srf_to_valid                   ),
        .t_param_srf_to_zq_cal                  (t_param_srf_to_zq_cal                  ),
        .t_param_pdn_to_valid                   (t_param_pdn_to_valid                   ),
        .t_param_pdn_period                     (t_param_pdn_period                     ),
        .t_param_power_saving_exit              (t_param_power_saving_exit              ),
        .tbp_empty                              (tbp_empty                              ),
        .tbp_bank_active                        (tbp_bank_active                        ),
        .tbp_timer_ready                        (tbp_timer_ready                        ),
        .row_grant                              (or_row_grant                           ),
        .col_grant                              (or_col_grant                           ),
        .afi_ctl_refresh_done                   (afi_ctl_refresh_done                   ),
        .afi_seq_busy                           (afi_seq_busy                           ),
        .afi_ctl_long_idle                      (afi_ctl_long_idle                      ),
        .cfg_enable_dqs_tracking                (cfg_enable_dqs_tracking                ),
        .cfg_user_rfsh                          (cfg_user_rfsh                          ),
        .cfg_type                               (cfg_type                               ),
        .cfg_tcl                                (cfg_tcl                                ),
        .cfg_regdimm_enable                     (cfg_regdimm_enable                     )
    );
    
//==============================================================================
//  alt_mem_ddrx_rank_timer
//------------------------------------------------------------------------------
//
//  Rank timer block
//
//  Info: Monitor rank specific timing parameter for activate, precharge,
//        read and write commands
//
//============================================================================== 
    
    alt_mem_ddrx_rank_timer #
    (
        .CFG_DWIDTH_RATIO                       (CFG_DWIDTH_RATIO                       ),
        .CFG_CTL_TBP_NUM                        (CFG_CTL_TBP_NUM                        ),
        .CFG_CTL_ARBITER_TYPE                   (CFG_CTL_ARBITER_TYPE                   ),
        .CFG_MEM_IF_CHIP                        (CFG_MEM_IF_CHIP                        ),
        .CFG_MEM_IF_CS_WIDTH                    (CFG_MEM_IF_CS_WIDTH                    ),
        .CFG_INT_SIZE_WIDTH                     (CFG_INT_SIZE_WIDTH                     ),
        .CFG_AFI_INTF_PHASE_NUM                 (CFG_AFI_INTF_PHASE_NUM                 ),
        .CFG_REG_GRANT                          (CFG_REG_GRANT                          ),
        .CFG_RANK_TIMER_OUTPUT_REG              (CFG_RANK_TIMER_OUTPUT_REG              ),
        .CFG_PORT_WIDTH_BURST_LENGTH            (CFG_PORT_WIDTH_BURST_LENGTH            ),
        .T_PARAM_FOUR_ACT_TO_ACT_WIDTH          (T_PARAM_FOUR_ACT_TO_ACT_WIDTH          ),
        .T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH     (T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH     ),
        .T_PARAM_WR_TO_WR_WIDTH                 (T_PARAM_WR_TO_WR_WIDTH                 ),
        .T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH       (T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH       ),
        .T_PARAM_WR_TO_RD_WIDTH                 (T_PARAM_WR_TO_RD_WIDTH                 ),
        .T_PARAM_WR_TO_RD_BC_WIDTH              (T_PARAM_WR_TO_RD_BC_WIDTH              ),
        .T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH       (T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH       ),
        .T_PARAM_RD_TO_RD_WIDTH                 (T_PARAM_RD_TO_RD_WIDTH                 ),
        .T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH       (T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH       ),
        .T_PARAM_RD_TO_WR_WIDTH                 (T_PARAM_RD_TO_WR_WIDTH                 ),
        .T_PARAM_RD_TO_WR_BC_WIDTH              (T_PARAM_RD_TO_WR_BC_WIDTH              ),
        .T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH       (T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH       )
    )
    rank_timer_inst
    (
        .ctl_clk                                (ctl_clk                                ),
        .ctl_reset_n                            (ctl_reset_n                            ),
        .cfg_burst_length                       (cfg_burst_length                       ),
        .t_param_four_act_to_act                (t_param_four_act_to_act                ),
        .t_param_act_to_act_diff_bank           (t_param_act_to_act_diff_bank           ),
        .t_param_wr_to_wr                       (t_param_wr_to_wr                       ),
        .t_param_wr_to_wr_diff_chip             (t_param_wr_to_wr_diff_chip             ),
        .t_param_wr_to_rd                       (t_param_wr_to_rd                       ),
        .t_param_wr_to_rd_bc                    (t_param_wr_to_rd_bc                    ),
        .t_param_wr_to_rd_diff_chip             (t_param_wr_to_rd_diff_chip             ),
        .t_param_rd_to_rd                       (t_param_rd_to_rd                       ),
        .t_param_rd_to_rd_diff_chip             (t_param_rd_to_rd_diff_chip             ),
        .t_param_rd_to_wr                       (t_param_rd_to_wr                       ),
        .t_param_rd_to_wr_bc                    (t_param_rd_to_wr_bc                    ),
        .t_param_rd_to_wr_diff_chip             (t_param_rd_to_wr_diff_chip             ),
        .bg_do_write                            (bg_do_write_combi                      ),
        .bg_do_read                             (bg_do_read_combi                       ),
        .bg_do_burst_chop                       (bg_do_burst_chop_combi                 ),
        .bg_do_burst_terminate                  (bg_do_burst_terminate_combi            ),
        .bg_do_activate                         (bg_do_activate_combi                   ),
        .bg_do_precharge                        (bg_do_precharge_combi                  ),
        .bg_to_chip                             (bg_to_chip_combi                       ),
        .bg_effective_size                      (bg_effective_size_combi                ),
        .bg_interrupt_ready                     (bg_interrupt_ready_combi               ),
        .cmd_gen_chipsel                        (cmd_gen_chipsel                        ),
        .tbp_chipsel                            (tbp_chipsel                            ),
        .tbp_load                               (tbp_load                               ),
        .stall_chip                             (stall_chip                             ),
        .can_activate                           (can_activate                           ),
        .can_precharge                          (can_precharge                          ),
        .can_read                               (can_read                               ),
        .can_write                              (can_write                              )
    );
    
//==============================================================================
//  alt_mem_ddrx_timing_param
//------------------------------------------------------------------------------
//
//  Timing parameter block
//
//  Info: Pre-calculate required timing parameters for each memory commands
//        based on memory type
//
//==============================================================================
    
    alt_mem_ddrx_timing_param #
    (
        .CFG_DWIDTH_RATIO                                       (CFG_DWIDTH_RATIO                                       ),
        .CFG_CTL_ARBITER_TYPE                                   (CFG_CTL_ARBITER_TYPE                                   ),
        .CFG_PORT_WIDTH_TYPE                                    (CFG_PORT_WIDTH_TYPE                                    ),
        .CFG_PORT_WIDTH_BURST_LENGTH                            (CFG_PORT_WIDTH_BURST_LENGTH                            ),
        .CFG_PORT_WIDTH_CAS_WR_LAT                              (CFG_PORT_WIDTH_CAS_WR_LAT                              ),
        .CFG_PORT_WIDTH_ADD_LAT                                 (CFG_PORT_WIDTH_ADD_LAT                                 ),
        .CFG_PORT_WIDTH_TCL                                     (CFG_PORT_WIDTH_TCL                                     ),
        .CFG_PORT_WIDTH_TRRD                                    (CFG_PORT_WIDTH_TRRD                                    ),
        .CFG_PORT_WIDTH_TFAW                                    (CFG_PORT_WIDTH_TFAW                                    ),
        .CFG_PORT_WIDTH_TRFC                                    (CFG_PORT_WIDTH_TRFC                                    ),
        .CFG_PORT_WIDTH_TREFI                                   (CFG_PORT_WIDTH_TREFI                                   ),
        .CFG_PORT_WIDTH_TRCD                                    (CFG_PORT_WIDTH_TRCD                                    ),
        .CFG_PORT_WIDTH_TRP                                     (CFG_PORT_WIDTH_TRP                                     ),
        .CFG_PORT_WIDTH_TWR                                     (CFG_PORT_WIDTH_TWR                                     ),
        .CFG_PORT_WIDTH_TWTR                                    (CFG_PORT_WIDTH_TWTR                                    ),
        .CFG_PORT_WIDTH_TRTP                                    (CFG_PORT_WIDTH_TRTP                                    ),
        .CFG_PORT_WIDTH_TRAS                                    (CFG_PORT_WIDTH_TRAS                                    ),
        .CFG_PORT_WIDTH_TRC                                     (CFG_PORT_WIDTH_TRC                                     ),
        .CFG_PORT_WIDTH_TCCD                                    (CFG_PORT_WIDTH_TCCD                                    ),
        .CFG_PORT_WIDTH_TMRD                                    (CFG_PORT_WIDTH_TMRD                                    ),
        .CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES                   (CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES                   ),
        .CFG_PORT_WIDTH_PDN_EXIT_CYCLES                         (CFG_PORT_WIDTH_PDN_EXIT_CYCLES                         ),
        .CFG_PORT_WIDTH_AUTO_PD_CYCLES                          (CFG_PORT_WIDTH_AUTO_PD_CYCLES                          ),
        .CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES                (CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES                ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR               (CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR               ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH                (CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH                ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT                (CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT                ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD                  (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD                  ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP        (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP        ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR                  (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR                  ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC               (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC               ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP        (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP        ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH                 (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH                 ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID            (CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID            ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR                  (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR                  ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP        (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP        ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD                  (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD                  ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC               (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC               ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP        (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP        ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH                 (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH                 ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID            (CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID            ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID              (CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID              ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID          (CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID          ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK      (CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK      ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT           (CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT           ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID              (CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID              ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID              (CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID              ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID              (CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID              ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL             (CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL             ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD                (CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD                ),
        .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD                (CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD                ),
        .T_PARAM_ACT_TO_RDWR_WIDTH                              (T_PARAM_ACT_TO_RDWR_WIDTH                              ),
        .T_PARAM_ACT_TO_PCH_WIDTH                               (T_PARAM_ACT_TO_PCH_WIDTH                               ),
        .T_PARAM_ACT_TO_ACT_WIDTH                               (T_PARAM_ACT_TO_ACT_WIDTH                               ),
        .T_PARAM_RD_TO_RD_WIDTH                                 (T_PARAM_RD_TO_RD_WIDTH                                 ),
        .T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH                       (T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH                       ),
        .T_PARAM_RD_TO_WR_WIDTH                                 (T_PARAM_RD_TO_WR_WIDTH                                 ),
        .T_PARAM_RD_TO_WR_BC_WIDTH                              (T_PARAM_RD_TO_WR_BC_WIDTH                              ),
        .T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH                       (T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH                       ),
        .T_PARAM_RD_TO_PCH_WIDTH                                (T_PARAM_RD_TO_PCH_WIDTH                                ),
        .T_PARAM_RD_AP_TO_VALID_WIDTH                           (T_PARAM_RD_AP_TO_VALID_WIDTH                           ),
        .T_PARAM_WR_TO_WR_WIDTH                                 (T_PARAM_WR_TO_WR_WIDTH                                 ),
        .T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH                       (T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH                       ),
        .T_PARAM_WR_TO_RD_WIDTH                                 (T_PARAM_WR_TO_RD_WIDTH                                 ),
        .T_PARAM_WR_TO_RD_BC_WIDTH                              (T_PARAM_WR_TO_RD_BC_WIDTH                              ),
        .T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH                       (T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH                       ),
        .T_PARAM_WR_TO_PCH_WIDTH                                (T_PARAM_WR_TO_PCH_WIDTH                                ),
        .T_PARAM_WR_AP_TO_VALID_WIDTH                           (T_PARAM_WR_AP_TO_VALID_WIDTH                           ),
        .T_PARAM_PCH_TO_VALID_WIDTH                             (T_PARAM_PCH_TO_VALID_WIDTH                             ),
        .T_PARAM_PCH_ALL_TO_VALID_WIDTH                         (T_PARAM_PCH_ALL_TO_VALID_WIDTH                         ),
        .T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH                     (T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH                     ),
        .T_PARAM_FOUR_ACT_TO_ACT_WIDTH                          (T_PARAM_FOUR_ACT_TO_ACT_WIDTH                          ),
        .T_PARAM_ARF_TO_VALID_WIDTH                             (T_PARAM_ARF_TO_VALID_WIDTH                             ),
        .T_PARAM_PDN_TO_VALID_WIDTH                             (T_PARAM_PDN_TO_VALID_WIDTH                             ),
        .T_PARAM_SRF_TO_VALID_WIDTH                             (T_PARAM_SRF_TO_VALID_WIDTH                             ),
        .T_PARAM_SRF_TO_ZQ_CAL_WIDTH                            (T_PARAM_SRF_TO_ZQ_CAL_WIDTH                            ),
        .T_PARAM_ARF_PERIOD_WIDTH                               (T_PARAM_ARF_PERIOD_WIDTH                               ),
        .T_PARAM_PDN_PERIOD_WIDTH                               (T_PARAM_PDN_PERIOD_WIDTH                               ),
        .T_PARAM_POWER_SAVING_EXIT_WIDTH                        (T_PARAM_POWER_SAVING_EXIT_WIDTH                        )
    )
    timing_param_inst
    (
        .ctl_clk                                                (ctl_clk                                                ),
        .ctl_reset_n                                            (ctl_reset_n                                            ),
        .cfg_burst_length                                       (cfg_burst_length                                       ),
        .cfg_type                                               (cfg_type                                               ),
        .cfg_cas_wr_lat                                         (cfg_cas_wr_lat                                         ),
        .cfg_add_lat                                            (cfg_add_lat                                            ),
        .cfg_tcl                                                (cfg_tcl                                                ),
        .cfg_trrd                                               (cfg_trrd                                               ),
        .cfg_tfaw                                               (cfg_tfaw                                               ),
        .cfg_trfc                                               (cfg_trfc                                               ),
        .cfg_trefi                                              (cfg_trefi                                              ),
        .cfg_trcd                                               (cfg_trcd                                               ),
        .cfg_trp                                                (cfg_trp                                                ),
        .cfg_twr                                                (cfg_twr                                                ),
        .cfg_twtr                                               (cfg_twtr                                               ),
        .cfg_trtp                                               (cfg_trtp                                               ),
        .cfg_tras                                               (cfg_tras                                               ),
        .cfg_trc                                                (cfg_trc                                                ),
        .cfg_tccd                                               (cfg_tccd                                               ),
        .cfg_tmrd                                               (cfg_tmrd                                               ),
        .cfg_self_rfsh_exit_cycles                              (cfg_self_rfsh_exit_cycles                              ),
        .cfg_pdn_exit_cycles                                    (cfg_pdn_exit_cycles                                    ),
        .cfg_auto_pd_cycles                                     (cfg_auto_pd_cycles                                     ),
        .cfg_power_saving_exit_cycles                           (cfg_power_saving_exit_cycles                           ),
        .cfg_extra_ctl_clk_act_to_rdwr                          (cfg_extra_ctl_clk_act_to_rdwr                          ),
        .cfg_extra_ctl_clk_act_to_pch                           (cfg_extra_ctl_clk_act_to_pch                           ),
        .cfg_extra_ctl_clk_act_to_act                           (cfg_extra_ctl_clk_act_to_act                           ),
        .cfg_extra_ctl_clk_rd_to_rd                             (cfg_extra_ctl_clk_rd_to_rd                             ),
        .cfg_extra_ctl_clk_rd_to_rd_diff_chip                   (cfg_extra_ctl_clk_rd_to_rd_diff_chip                   ),
        .cfg_extra_ctl_clk_rd_to_wr                             (cfg_extra_ctl_clk_rd_to_wr                             ),
        .cfg_extra_ctl_clk_rd_to_wr_bc                          (cfg_extra_ctl_clk_rd_to_wr_bc                          ),
        .cfg_extra_ctl_clk_rd_to_wr_diff_chip                   (cfg_extra_ctl_clk_rd_to_wr_diff_chip                   ),
        .cfg_extra_ctl_clk_rd_to_pch                            (cfg_extra_ctl_clk_rd_to_pch                            ),
        .cfg_extra_ctl_clk_rd_ap_to_valid                       (cfg_extra_ctl_clk_rd_ap_to_valid                       ),
        .cfg_extra_ctl_clk_wr_to_wr                             (cfg_extra_ctl_clk_wr_to_wr                             ),
        .cfg_extra_ctl_clk_wr_to_wr_diff_chip                   (cfg_extra_ctl_clk_wr_to_wr_diff_chip                   ),
        .cfg_extra_ctl_clk_wr_to_rd                             (cfg_extra_ctl_clk_wr_to_rd                             ),
        .cfg_extra_ctl_clk_wr_to_rd_bc                          (cfg_extra_ctl_clk_wr_to_rd_bc                          ),
        .cfg_extra_ctl_clk_wr_to_rd_diff_chip                   (cfg_extra_ctl_clk_wr_to_rd_diff_chip                   ),
        .cfg_extra_ctl_clk_wr_to_pch                            (cfg_extra_ctl_clk_wr_to_pch                            ),
        .cfg_extra_ctl_clk_wr_ap_to_valid                       (cfg_extra_ctl_clk_wr_ap_to_valid                       ),
        .cfg_extra_ctl_clk_pch_to_valid                         (cfg_extra_ctl_clk_pch_to_valid                         ),
        .cfg_extra_ctl_clk_pch_all_to_valid                     (cfg_extra_ctl_clk_pch_all_to_valid                     ),
        .cfg_extra_ctl_clk_act_to_act_diff_bank                 (cfg_extra_ctl_clk_act_to_act_diff_bank                 ),
        .cfg_extra_ctl_clk_four_act_to_act                      (cfg_extra_ctl_clk_four_act_to_act                      ),
        .cfg_extra_ctl_clk_arf_to_valid                         (cfg_extra_ctl_clk_arf_to_valid                         ),
        .cfg_extra_ctl_clk_pdn_to_valid                         (cfg_extra_ctl_clk_pdn_to_valid                         ),
        .cfg_extra_ctl_clk_srf_to_valid                         (cfg_extra_ctl_clk_srf_to_valid                         ),
        .cfg_extra_ctl_clk_srf_to_zq_cal                        (cfg_extra_ctl_clk_srf_to_zq_cal                        ),
        .cfg_extra_ctl_clk_arf_period                           (cfg_extra_ctl_clk_arf_period                           ),
        .cfg_extra_ctl_clk_pdn_period                           (cfg_extra_ctl_clk_pdn_period                           ),
        .t_param_act_to_rdwr                                    (t_param_act_to_rdwr                                    ),
        .t_param_act_to_pch                                     (t_param_act_to_pch                                     ),
        .t_param_act_to_act                                     (t_param_act_to_act                                     ),
        .t_param_rd_to_rd                                       (t_param_rd_to_rd                                       ),
        .t_param_rd_to_rd_diff_chip                             (t_param_rd_to_rd_diff_chip                             ),
        .t_param_rd_to_wr                                       (t_param_rd_to_wr                                       ),
        .t_param_rd_to_wr_bc                                    (t_param_rd_to_wr_bc                                    ),
        .t_param_rd_to_wr_diff_chip                             (t_param_rd_to_wr_diff_chip                             ),
        .t_param_rd_to_pch                                      (t_param_rd_to_pch                                      ),
        .t_param_rd_ap_to_valid                                 (t_param_rd_ap_to_valid                                 ),
        .t_param_wr_to_wr                                       (t_param_wr_to_wr                                       ),
        .t_param_wr_to_wr_diff_chip                             (t_param_wr_to_wr_diff_chip                             ),
        .t_param_wr_to_rd                                       (t_param_wr_to_rd                                       ),
        .t_param_wr_to_rd_bc                                    (t_param_wr_to_rd_bc                                    ),
        .t_param_wr_to_rd_diff_chip                             (t_param_wr_to_rd_diff_chip                             ),
        .t_param_wr_to_pch                                      (t_param_wr_to_pch                                      ),
        .t_param_wr_ap_to_valid                                 (t_param_wr_ap_to_valid                                 ),
        .t_param_pch_to_valid                                   (t_param_pch_to_valid                                   ),
        .t_param_pch_all_to_valid                               (t_param_pch_all_to_valid                               ),
        .t_param_act_to_act_diff_bank                           (t_param_act_to_act_diff_bank                           ),
        .t_param_four_act_to_act                                (t_param_four_act_to_act                                ),
        .t_param_arf_to_valid                                   (t_param_arf_to_valid                                   ),
        .t_param_pdn_to_valid                                   (t_param_pdn_to_valid                                   ),
        .t_param_srf_to_valid                                   (t_param_srf_to_valid                                   ),
        .t_param_srf_to_zq_cal                                  (t_param_srf_to_zq_cal                                  ),
        .t_param_arf_period                                     (t_param_arf_period                                     ),
        .t_param_pdn_period                                     (t_param_pdn_period                                     ),
        .t_param_power_saving_exit                              (t_param_power_saving_exit                              )
    );
    
endmodule
