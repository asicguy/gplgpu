//////////////////////////////////////////////////////////////////////////////
// This module is a ST wrapper for the soft IP NextGen controller and the MMR
//////////////////////////////////////////////////////////////////////////////

//altera message_off 10230

`include "alt_mem_ddrx_define.iv"

module alt_mem_ddrx_controller_st_top(
    clk,
    half_clk,
    reset_n,
    itf_cmd_ready,
    itf_cmd_valid,
    itf_cmd,
    itf_cmd_address,
    itf_cmd_burstlen,
    itf_cmd_id,
    itf_cmd_priority,
    itf_cmd_autopercharge,
    itf_cmd_multicast,
    itf_wr_data_ready,
    itf_wr_data_valid,
    itf_wr_data,
    itf_wr_data_byte_en,
    itf_wr_data_begin,
    itf_wr_data_last,
    itf_wr_data_id,
    itf_rd_data_ready,
    itf_rd_data_valid,
    itf_rd_data,
    itf_rd_data_error,
    itf_rd_data_begin,
    itf_rd_data_last,
    itf_rd_data_id,
    afi_rst_n,
    afi_cs_n,
    afi_cke,
    afi_odt,
    afi_addr,
    afi_ba,
    afi_ras_n,
    afi_cas_n,
    afi_we_n,
    afi_dqs_burst,
    afi_wdata_valid,
    afi_wdata,
    afi_dm,
    afi_wlat,
    afi_rdata_en,
    afi_rdata_en_full,
    afi_rdata,
    afi_rdata_valid,
    afi_rlat,
    afi_cal_success,
    afi_cal_fail,
    afi_cal_req,
    afi_init_req,
    afi_mem_clk_disable,
    afi_cal_byte_lane_sel_n,
    afi_ctl_refresh_done,
    afi_seq_busy,
    afi_ctl_long_idle,
    local_init_done,
    local_refresh_ack,
    local_powerdn_ack,
    local_self_rfsh_ack,
	local_deep_powerdn_ack,
    local_refresh_req,
    local_refresh_chip,
    local_powerdn_req,
    local_self_rfsh_req,
    local_self_rfsh_chip,
	local_deep_powerdn_req,
	local_deep_powerdn_chip,
    local_multicast,
    local_priority,
    ecc_interrupt,
    csr_read_req,
    csr_write_req,
    csr_burst_count,
    csr_beginbursttransfer,
    csr_addr,
    csr_wdata,
    csr_rdata,
    csr_be,
    csr_rdata_valid,
    csr_waitrequest
);

//////////////////////////////////////////////////////////////////////////////
parameter LOCAL_SIZE_WIDTH                          = "";
parameter LOCAL_ADDR_WIDTH                          = "";
parameter LOCAL_DATA_WIDTH                          = "";
parameter LOCAL_BE_WIDTH                            = "";
parameter LOCAL_ID_WIDTH                            = "";
parameter LOCAL_CS_WIDTH                            = "";
parameter MEM_IF_ADDR_WIDTH                         = "";
parameter MEM_IF_CLK_PAIR_COUNT                     = "";
parameter LOCAL_IF_TYPE                             = "";
parameter DWIDTH_RATIO                              = "";
parameter CTL_ODT_ENABLED                           = "";
parameter CTL_OUTPUT_REGD                           = "";
parameter CTL_TBP_NUM                               = "";
parameter WRBUFFER_ADDR_WIDTH                       = "";
parameter RDBUFFER_ADDR_WIDTH                       = "";
parameter MEM_IF_CS_WIDTH                           = "";
parameter MEM_IF_CHIP                               = "";
parameter MEM_IF_BANKADDR_WIDTH                     = "";
parameter MEM_IF_ROW_WIDTH                          = "";
parameter MEM_IF_COL_WIDTH                          = "";
parameter MEM_IF_ODT_WIDTH                          = "";
parameter MEM_IF_DQS_WIDTH                          = "";
parameter MEM_IF_DWIDTH                             = "";
parameter MEM_IF_DM_WIDTH                           = "";
parameter MAX_MEM_IF_CS_WIDTH                       = "";
parameter MAX_MEM_IF_CHIP                           = "";
parameter MAX_MEM_IF_BANKADDR_WIDTH                 = "";
parameter MAX_MEM_IF_ROWADDR_WIDTH                  = "";
parameter MAX_MEM_IF_COLADDR_WIDTH                  = "";
parameter MAX_MEM_IF_ODT_WIDTH                      = "";
parameter MAX_MEM_IF_DQS_WIDTH                      = "";
parameter MAX_MEM_IF_DQ_WIDTH                       = "";
parameter MAX_MEM_IF_MASK_WIDTH                     = "";
parameter MAX_LOCAL_DATA_WIDTH                      = "";
parameter CFG_TYPE                                  = "";
parameter CFG_INTERFACE_WIDTH                       = "";
parameter CFG_BURST_LENGTH                          = "";
parameter CFG_DEVICE_WIDTH                          = "";
parameter CFG_REORDER_DATA                          = "";
parameter CFG_DATA_REORDERING_TYPE                  = "";
parameter CFG_STARVE_LIMIT                          = "";
parameter CFG_ADDR_ORDER                            = "";
parameter MEM_CAS_WR_LAT                            = "";
parameter MEM_ADD_LAT                               = "";
parameter MEM_TCL                                   = "";
parameter MEM_TRRD                                  = "";
parameter MEM_TFAW                                  = "";
parameter MEM_TRFC                                  = "";
parameter MEM_TREFI                                 = "";
parameter MEM_TRCD                                  = "";
parameter MEM_TRP                                   = "";
parameter MEM_TWR                                   = "";
parameter MEM_TWTR                                  = "";
parameter MEM_TRTP                                  = "";
parameter MEM_TRAS                                  = "";
parameter MEM_TRC                                   = "";
parameter CFG_TCCD                                  = "";
parameter MEM_AUTO_PD_CYCLES                        = "";
parameter CFG_SELF_RFSH_EXIT_CYCLES                 = "";
parameter CFG_PDN_EXIT_CYCLES                       = "";
parameter CFG_POWER_SAVING_EXIT_CYCLES              = "";
parameter CFG_MEM_CLK_ENTRY_CYCLES                  = "";
parameter MEM_TMRD_CK                               = "";
parameter CTL_ECC_ENABLED                           = "";
parameter CTL_ECC_RMW_ENABLED                       = "";
parameter CTL_ECC_MULTIPLES_16_24_40_72             = "";
parameter CFG_GEN_SBE                               = "";
parameter CFG_GEN_DBE                               = "";
parameter CFG_ENABLE_INTR                           = "";
parameter CFG_MASK_SBE_INTR                         = "";
parameter CFG_MASK_DBE_INTR                         = "";
parameter CFG_MASK_CORRDROP_INTR                    = 0;
parameter CFG_CLR_INTR                              = "";
parameter CTL_USR_REFRESH                           = "";
parameter CTL_REGDIMM_ENABLED                       = "";
parameter CTL_ENABLE_BURST_INTERRUPT				= "";
parameter CTL_ENABLE_BURST_TERMINATE				= "";
parameter CFG_WRITE_ODT_CHIP                        = "";
parameter CFG_READ_ODT_CHIP                         = "";
parameter CFG_PORT_WIDTH_WRITE_ODT_CHIP             = "";
parameter CFG_PORT_WIDTH_READ_ODT_CHIP              = "";
parameter MEM_IF_CKE_WIDTH                          = "";//check
parameter CTL_CSR_ENABLED                           = "";
parameter CFG_ENABLE_NO_DM                          = "";
parameter CSR_ADDR_WIDTH                            = "";
parameter CSR_DATA_WIDTH                            = "";
parameter CSR_BE_WIDTH                              = "";
parameter CFG_ENABLE_DQS_TRACKING                   = 0;
parameter CFG_WLAT_BUS_WIDTH                        = 6;
parameter CFG_RLAT_BUS_WIDTH                        = 6;

parameter MEM_IF_RD_TO_WR_TURNAROUND_OCT            = "";
parameter MEM_IF_WR_TO_RD_TURNAROUND_OCT            = "";
parameter CTL_RD_TO_PCH_EXTRA_CLK                   = 0;

//////////////////////////////////////////////////////////////////////////////

localparam CFG_LOCAL_SIZE_WIDTH                                 = LOCAL_SIZE_WIDTH;
localparam CFG_LOCAL_ADDR_WIDTH                                 = LOCAL_ADDR_WIDTH;
localparam CFG_LOCAL_DATA_WIDTH                                 = LOCAL_DATA_WIDTH;
localparam CFG_LOCAL_BE_WIDTH                                   = LOCAL_BE_WIDTH;
localparam CFG_LOCAL_ID_WIDTH                                   = LOCAL_ID_WIDTH;
localparam CFG_LOCAL_IF_TYPE                                    = LOCAL_IF_TYPE;
localparam CFG_MEM_IF_ADDR_WIDTH                                = MEM_IF_ADDR_WIDTH;
localparam CFG_MEM_IF_CLK_PAIR_COUNT                            = MEM_IF_CLK_PAIR_COUNT;
localparam CFG_DWIDTH_RATIO                                     = DWIDTH_RATIO;
localparam CFG_ODT_ENABLED                                      = CTL_ODT_ENABLED;
localparam CFG_CTL_TBP_NUM                                      = CTL_TBP_NUM;
localparam CFG_WRBUFFER_ADDR_WIDTH                              = WRBUFFER_ADDR_WIDTH;
localparam CFG_RDBUFFER_ADDR_WIDTH                              = RDBUFFER_ADDR_WIDTH;
localparam CFG_MEM_IF_CS_WIDTH                                  = MEM_IF_CS_WIDTH;
localparam CFG_MEM_IF_CHIP                                      = MEM_IF_CHIP;
localparam CFG_MEM_IF_BA_WIDTH                                  = MEM_IF_BANKADDR_WIDTH;
localparam CFG_MEM_IF_ROW_WIDTH                                 = MEM_IF_ROW_WIDTH;
localparam CFG_MEM_IF_COL_WIDTH                                 = MEM_IF_COL_WIDTH;
localparam CFG_MEM_IF_CKE_WIDTH                                 = MEM_IF_CKE_WIDTH;
localparam CFG_MEM_IF_ODT_WIDTH                                 = MEM_IF_ODT_WIDTH;
localparam CFG_MEM_IF_DQS_WIDTH                                 = MEM_IF_DQS_WIDTH;
localparam CFG_MEM_IF_DQ_WIDTH                                  = MEM_IF_DWIDTH;
localparam CFG_MEM_IF_DM_WIDTH                                  = MEM_IF_DM_WIDTH;
localparam CFG_COL_ADDR_WIDTH                                   = MEM_IF_COL_WIDTH;
localparam CFG_ROW_ADDR_WIDTH                                   = MEM_IF_ROW_WIDTH;
localparam CFG_BANK_ADDR_WIDTH                                  = MEM_IF_BANKADDR_WIDTH;
localparam CFG_CS_ADDR_WIDTH                                    = LOCAL_CS_WIDTH;
localparam CFG_CAS_WR_LAT                                       = MEM_CAS_WR_LAT;
localparam CFG_ADD_LAT                                          = MEM_ADD_LAT;
localparam CFG_TCL                                              = MEM_TCL;
localparam CFG_TRRD                                             = MEM_TRRD;
localparam CFG_TFAW                                             = MEM_TFAW;
localparam CFG_TRFC                                             = MEM_TRFC;
localparam CFG_TREFI                                            = MEM_TREFI;
localparam CFG_TRCD                                             = MEM_TRCD;
localparam CFG_TRP                                              = MEM_TRP;
localparam CFG_TWR                                              = MEM_TWR;
localparam CFG_TWTR                                             = MEM_TWTR;
localparam CFG_TRTP                                             = MEM_TRTP;
localparam CFG_TRAS                                             = MEM_TRAS;
localparam CFG_TRC                                              = MEM_TRC;
localparam CFG_AUTO_PD_CYCLES                                   = MEM_AUTO_PD_CYCLES;
localparam CFG_TMRD                                             = MEM_TMRD_CK;
localparam CFG_ENABLE_ECC                                       = CTL_ECC_ENABLED;
localparam CFG_ENABLE_AUTO_CORR                                 = CTL_ECC_RMW_ENABLED;
localparam CFG_ECC_MULTIPLES_16_24_40_72                        = CTL_ECC_MULTIPLES_16_24_40_72;
localparam CFG_ENABLE_ECC_CODE_OVERWRITES                       = 1'b1;
localparam CFG_CAL_REQ                                          = 0;
localparam CFG_EXTRA_CTL_CLK_ACT_TO_RDWR                        = 0;
localparam CFG_EXTRA_CTL_CLK_ACT_TO_PCH                         = 0;
localparam CFG_EXTRA_CTL_CLK_ACT_TO_ACT                         = 0;
localparam CFG_EXTRA_CTL_CLK_RD_TO_RD                           = 0;
localparam CFG_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP                 = 0;
localparam CFG_EXTRA_CTL_CLK_RD_TO_WR                           = 0 + ((MEM_IF_RD_TO_WR_TURNAROUND_OCT / (DWIDTH_RATIO / 2)) + ((MEM_IF_RD_TO_WR_TURNAROUND_OCT % (DWIDTH_RATIO / 2)) > 0 ? 1 : 0)); // Please do not remove the latter calculation
localparam CFG_EXTRA_CTL_CLK_RD_TO_WR_BC                        = 0 + ((MEM_IF_RD_TO_WR_TURNAROUND_OCT / (DWIDTH_RATIO / 2)) + ((MEM_IF_RD_TO_WR_TURNAROUND_OCT % (DWIDTH_RATIO / 2)) > 0 ? 1 : 0)); // Please do not remove the latter calculation
localparam CFG_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP                 = 0 + ((MEM_IF_RD_TO_WR_TURNAROUND_OCT / (DWIDTH_RATIO / 2)) + ((MEM_IF_RD_TO_WR_TURNAROUND_OCT % (DWIDTH_RATIO / 2)) > 0 ? 1 : 0)); // Please do not remove the latter calculation
localparam CFG_EXTRA_CTL_CLK_RD_TO_PCH                          = 0 + CTL_RD_TO_PCH_EXTRA_CLK;
localparam CFG_EXTRA_CTL_CLK_RD_AP_TO_VALID                     = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_WR                           = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP                 = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_RD                           = 0 + ((MEM_IF_WR_TO_RD_TURNAROUND_OCT / (DWIDTH_RATIO / 2)) + ((MEM_IF_WR_TO_RD_TURNAROUND_OCT % (DWIDTH_RATIO / 2)) > 0 ? 1 : 0)); // Please do not remove the latter calculation
localparam CFG_EXTRA_CTL_CLK_WR_TO_RD_BC                        = 0 + ((MEM_IF_WR_TO_RD_TURNAROUND_OCT / (DWIDTH_RATIO / 2)) + ((MEM_IF_WR_TO_RD_TURNAROUND_OCT % (DWIDTH_RATIO / 2)) > 0 ? 1 : 0)); // Please do not remove the latter calculation
localparam CFG_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP                 = 0 + ((MEM_IF_WR_TO_RD_TURNAROUND_OCT / (DWIDTH_RATIO / 2)) + ((MEM_IF_WR_TO_RD_TURNAROUND_OCT % (DWIDTH_RATIO / 2)) > 0 ? 1 : 0)); // Please do not remove the latter calculation
localparam CFG_EXTRA_CTL_CLK_WR_TO_PCH                          = 0;
localparam CFG_EXTRA_CTL_CLK_WR_AP_TO_VALID                     = 0;
localparam CFG_EXTRA_CTL_CLK_PCH_TO_VALID                       = 0;
localparam CFG_EXTRA_CTL_CLK_PCH_ALL_TO_VALID                   = 0;
localparam CFG_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK               = 0;
localparam CFG_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT                    = 0;
localparam CFG_EXTRA_CTL_CLK_ARF_TO_VALID                       = 0;
localparam CFG_EXTRA_CTL_CLK_PDN_TO_VALID                       = 0;
localparam CFG_EXTRA_CTL_CLK_SRF_TO_VALID                       = 0;
localparam CFG_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL                      = 0;
localparam CFG_EXTRA_CTL_CLK_ARF_PERIOD                         = 0;
localparam CFG_EXTRA_CTL_CLK_PDN_PERIOD                         = 0;
localparam CFG_OUTPUT_REGD                                      = CTL_OUTPUT_REGD;
localparam CFG_MASK_CORR_DROPPED_INTR                           = 0;
localparam CFG_USER_RFSH                                        = CTL_USR_REFRESH;
localparam CFG_REGDIMM_ENABLE                                   = CTL_REGDIMM_ENABLED;
localparam CFG_ENABLE_BURST_INTERRUPT                           = CTL_ENABLE_BURST_INTERRUPT;
localparam CFG_ENABLE_BURST_TERMINATE                           = CTL_ENABLE_BURST_TERMINATE;

localparam CFG_PORT_WIDTH_TYPE                                  = 3;
localparam CFG_PORT_WIDTH_INTERFACE_WIDTH                       = 8;
localparam CFG_PORT_WIDTH_BURST_LENGTH                          = 5;
localparam CFG_PORT_WIDTH_DEVICE_WIDTH                          = 4;
localparam CFG_PORT_WIDTH_REORDER_DATA                          = 1;
localparam CFG_PORT_WIDTH_STARVE_LIMIT                          = 6;
localparam CFG_PORT_WIDTH_OUTPUT_REGD                           = 1;
localparam CFG_PORT_WIDTH_ADDR_ORDER                            = 2;
localparam CFG_PORT_WIDTH_COL_ADDR_WIDTH                        = 5;
localparam CFG_PORT_WIDTH_ROW_ADDR_WIDTH                        = 5;
localparam CFG_PORT_WIDTH_BANK_ADDR_WIDTH                       = 3;
localparam CFG_PORT_WIDTH_CS_ADDR_WIDTH                         = 3;
localparam CFG_PORT_WIDTH_CAS_WR_LAT                            = 4;
localparam CFG_PORT_WIDTH_ADD_LAT                               = 3;
localparam CFG_PORT_WIDTH_TCL                                   = 4;
localparam CFG_PORT_WIDTH_TRRD                                  = 4;
localparam CFG_PORT_WIDTH_TFAW                                  = 6;
localparam CFG_PORT_WIDTH_TRFC                                  = 8;
localparam CFG_PORT_WIDTH_TREFI                                 = 13;
localparam CFG_PORT_WIDTH_TRCD                                  = 4;
localparam CFG_PORT_WIDTH_TRP                                   = 4;
localparam CFG_PORT_WIDTH_TWR                                   = 4;
localparam CFG_PORT_WIDTH_TWTR                                  = 4;
localparam CFG_PORT_WIDTH_TRTP                                  = 4;
localparam CFG_PORT_WIDTH_TRAS                                  = 5;
localparam CFG_PORT_WIDTH_TRC                                   = 6;
localparam CFG_PORT_WIDTH_TCCD                                  = 4;
localparam CFG_PORT_WIDTH_TMRD                                  = 3;
localparam CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES                 = 10;
localparam CFG_PORT_WIDTH_PDN_EXIT_CYCLES                       = 4;
localparam CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES              = 4;
localparam CFG_PORT_WIDTH_MEM_CLK_ENTRY_CYCLES                  = 4;
localparam CFG_PORT_WIDTH_AUTO_PD_CYCLES                        = 16;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR             = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH              = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT              = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD                = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP      = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR                = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC             = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP      = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH               = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID          = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR                = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP      = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD                = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC             = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP      = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH               = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID          = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID            = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID        = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK    = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT         = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID            = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID            = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID            = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL           = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD              = 4;
localparam CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD              = 4;
localparam CFG_PORT_WIDTH_ENABLE_ECC                            = 1;
localparam CFG_PORT_WIDTH_ENABLE_AUTO_CORR                      = 1;
localparam CFG_PORT_WIDTH_GEN_SBE                               = 1;
localparam CFG_PORT_WIDTH_GEN_DBE                               = 1;
localparam CFG_PORT_WIDTH_ENABLE_INTR                           = 1;
localparam CFG_PORT_WIDTH_MASK_SBE_INTR                         = 1;
localparam CFG_PORT_WIDTH_MASK_DBE_INTR                         = 1;
localparam CFG_PORT_WIDTH_CLR_INTR                              = 1;
localparam CFG_PORT_WIDTH_USER_RFSH                             = 1;
localparam CFG_PORT_WIDTH_SELF_RFSH                             = 1;
localparam CFG_PORT_WIDTH_REGDIMM_ENABLE                        = 1;
localparam CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT                = 1;
localparam CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE                = 1;
localparam CFG_RDATA_RETURN_MODE                                = (CFG_REORDER_DATA == 1) ? "INORDER" : "PASSTHROUGH";

localparam CFG_LPDDR2_ENABLED                                   = (CFG_TYPE == `MMR_TYPE_LPDDR2) ? 1 : 0;
localparam CFG_ADDR_RATE_RATIO                                  = (CFG_LPDDR2_ENABLED == 1) ? 2 : 1;
localparam CFG_AFI_IF_FR_ADDR_WIDTH                             = (CFG_ADDR_RATE_RATIO * CFG_MEM_IF_ADDR_WIDTH);

localparam STS_PORT_WIDTH_SBE_ERROR                             = 1;
localparam STS_PORT_WIDTH_DBE_ERROR                             = 1;
localparam STS_PORT_WIDTH_CORR_DROP_ERROR                       = 1;
localparam STS_PORT_WIDTH_SBE_COUNT                             = 8;
localparam STS_PORT_WIDTH_DBE_COUNT                             = 8;
localparam STS_PORT_WIDTH_CORR_DROP_COUNT                       = 8;

// We are supposed to use these parameters when the CSR is enabled
// but the MAX_ parameters are not defined
//localparam AFI_CS_WIDTH                                         = (MAX_MEM_IF_CHIP * (CFG_DWIDTH_RATIO / 2));
//localparam AFI_CKE_WIDTH                                        = (MAX_CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO / 2));
//localparam AFI_ODT_WIDTH                                        = (MAX_CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO / 2));
//localparam AFI_ADDR_WIDTH                                       = (MAX_CFG_MEM_IF_ADDR_WIDTH * (CFG_DWIDTH_RATIO / 2));
//localparam AFI_BA_WIDTH                                         = (MAX_CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO / 2));
//localparam AFI_CAL_BYTE_LANE_SEL_N_WIDTH                        = (CFG_MEM_IF_DQS_WIDTH * MAX_CFG_MEM_IF_CHIP);

localparam AFI_CS_WIDTH                                         = (CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO / 2));
localparam AFI_CKE_WIDTH                                        = (CFG_MEM_IF_CKE_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_ODT_WIDTH                                        = (CFG_MEM_IF_ODT_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_ADDR_WIDTH                                       = (CFG_AFI_IF_FR_ADDR_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_BA_WIDTH                                         = (CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_CAL_BYTE_LANE_SEL_N_WIDTH                        = (CFG_MEM_IF_DQS_WIDTH * CFG_MEM_IF_CHIP);

localparam AFI_CMD_WIDTH                                        = (CFG_DWIDTH_RATIO / 2);
localparam AFI_DQS_BURST_WIDTH                                  = (CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_WDATA_VALID_WIDTH                                = (CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_WDATA_WIDTH                                      = (CFG_MEM_IF_DQ_WIDTH * CFG_DWIDTH_RATIO);
localparam AFI_DM_WIDTH                                         = (CFG_MEM_IF_DM_WIDTH * CFG_DWIDTH_RATIO);
localparam AFI_WLAT_WIDTH                                       = CFG_WLAT_BUS_WIDTH;
localparam AFI_RDATA_EN_WIDTH                                   = (CFG_MEM_IF_DQS_WIDTH * (CFG_DWIDTH_RATIO / 2));
localparam AFI_RDATA_WIDTH                                      = (CFG_MEM_IF_DQ_WIDTH * CFG_DWIDTH_RATIO);
localparam AFI_RDATA_VALID_WIDTH                                = (CFG_DWIDTH_RATIO / 2);
localparam AFI_RLAT_WIDTH                                       = CFG_RLAT_BUS_WIDTH;
localparam AFI_OTF_BITNUM                                       = 12;
localparam AFI_AUTO_PRECHARGE_BITNUM                            = 10;
localparam AFI_MEM_CLK_DISABLE_WIDTH                            = CFG_MEM_IF_CLK_PAIR_COUNT;

//////////////////////////////////////////////////////////////////////////////
// BEGIN PORT SECTION

// Clk and reset signals
input                                                                  clk;
input                                                                  half_clk;
input                                                                  reset_n;

// Command channel
output                                                                 itf_cmd_ready;
input                                                                  itf_cmd_valid;
input                                                                  itf_cmd;
input   [CFG_LOCAL_ADDR_WIDTH                              - 1 : 0]    itf_cmd_address;
input   [CFG_LOCAL_SIZE_WIDTH                              - 1 : 0]    itf_cmd_burstlen;
input   [CFG_LOCAL_ID_WIDTH                                - 1 : 0]    itf_cmd_id;
input                                                                  itf_cmd_priority;
input                                                                  itf_cmd_autopercharge;
input                                                                  itf_cmd_multicast;
// Write data channel
output                                                                 itf_wr_data_ready;
input                                                                  itf_wr_data_valid;
input   [CFG_LOCAL_DATA_WIDTH                              - 1 : 0]    itf_wr_data;
input   [CFG_LOCAL_BE_WIDTH                                - 1 : 0]    itf_wr_data_byte_en;
input                                                                  itf_wr_data_begin;
input                                                                  itf_wr_data_last;
input   [CFG_LOCAL_ID_WIDTH                                - 1 : 0]    itf_wr_data_id;
// Read data channel
input                                                                  itf_rd_data_ready;
output                                                                 itf_rd_data_valid;
output  [CFG_LOCAL_DATA_WIDTH                              - 1 : 0]    itf_rd_data;
output                                                                 itf_rd_data_error;
output                                                                 itf_rd_data_begin;
output                                                                 itf_rd_data_last;
output  [CFG_LOCAL_ID_WIDTH                                - 1 : 0]    itf_rd_data_id;

// AFI signals
output  [AFI_CMD_WIDTH                                     - 1 : 0]    afi_rst_n;
output  [AFI_CS_WIDTH                                      - 1 : 0]    afi_cs_n;
output  [AFI_CKE_WIDTH                                     - 1 : 0]    afi_cke;
output  [AFI_ODT_WIDTH                                     - 1 : 0]    afi_odt;
output  [AFI_ADDR_WIDTH                                    - 1 : 0]    afi_addr;
output  [AFI_BA_WIDTH                                      - 1 : 0]    afi_ba;
output  [AFI_CMD_WIDTH                                     - 1 : 0]    afi_ras_n;
output  [AFI_CMD_WIDTH                                     - 1 : 0]    afi_cas_n;
output  [AFI_CMD_WIDTH                                     - 1 : 0]    afi_we_n;
output  [AFI_DQS_BURST_WIDTH                               - 1 : 0]    afi_dqs_burst;
output  [AFI_WDATA_VALID_WIDTH                             - 1 : 0]    afi_wdata_valid;
output  [AFI_WDATA_WIDTH                                   - 1 : 0]    afi_wdata;
output  [AFI_DM_WIDTH                                      - 1 : 0]    afi_dm;
input   [AFI_WLAT_WIDTH                                    - 1 : 0]    afi_wlat;
output  [AFI_RDATA_EN_WIDTH                                - 1 : 0]    afi_rdata_en;
output  [AFI_RDATA_EN_WIDTH                                - 1 : 0]    afi_rdata_en_full;
input   [AFI_RDATA_WIDTH                                   - 1 : 0]    afi_rdata;
input   [AFI_RDATA_VALID_WIDTH                             - 1 : 0]    afi_rdata_valid;
input   [AFI_RLAT_WIDTH                                    - 1 : 0]    afi_rlat;
input                                                                  afi_cal_success;
input                                                                  afi_cal_fail;
output                                                                 afi_cal_req;
output                                                                 afi_init_req;
output  [AFI_MEM_CLK_DISABLE_WIDTH                         - 1 : 0]    afi_mem_clk_disable;
output  [AFI_CAL_BYTE_LANE_SEL_N_WIDTH                     - 1 : 0]    afi_cal_byte_lane_sel_n;
output  [CFG_MEM_IF_CHIP                                   - 1 : 0]    afi_ctl_refresh_done;
input   [CFG_MEM_IF_CHIP                                   - 1 : 0]    afi_seq_busy;
output  [CFG_MEM_IF_CHIP                                   - 1 : 0]    afi_ctl_long_idle;

// Sideband signals
output                                                                 local_init_done;
output                                                                 local_refresh_ack;
output                                                                 local_powerdn_ack;
output                                                                 local_self_rfsh_ack;
output  															   local_deep_powerdn_ack;
input                                                                  local_refresh_req;
input   [CFG_MEM_IF_CHIP                                   - 1 : 0]    local_refresh_chip;
input                                                                  local_powerdn_req;
input                                                                  local_self_rfsh_req;
input   [CFG_MEM_IF_CHIP                                   - 1 : 0]    local_self_rfsh_chip;
input																   local_deep_powerdn_req;
input   [CFG_MEM_IF_CHIP                                   - 1 : 0]    local_deep_powerdn_chip;
input                                                                  local_multicast;
input                                                                  local_priority;

// Csr & ecc signals
output                                                                 ecc_interrupt;
input                                                                  csr_read_req;
input                                                                  csr_write_req;
input   [1                                                 - 1 : 0]    csr_burst_count;
input                                                                  csr_beginbursttransfer;
input   [CSR_ADDR_WIDTH                                    - 1 : 0]    csr_addr;
input   [CSR_DATA_WIDTH                                    - 1 : 0]    csr_wdata;
output  [CSR_DATA_WIDTH                                    - 1 : 0]    csr_rdata;
input   [CSR_BE_WIDTH                                      - 1 : 0]    csr_be;
output                                                                 csr_rdata_valid;
output                                                                 csr_waitrequest;

// END PORT SECTION
//////////////////////////////////////////////////////////////////////////////

wire    [CFG_PORT_WIDTH_TYPE                               - 1 : 0]    cfg_type;
wire    [CFG_PORT_WIDTH_BURST_LENGTH                       - 1 : 0]    cfg_burst_length;
wire    [CFG_PORT_WIDTH_ADDR_ORDER                         - 1 : 0]    cfg_addr_order;
wire                                                                   cfg_enable_ecc;
wire                                                                   cfg_enable_auto_corr;
wire                                                                   cfg_gen_sbe;
wire                                                                   cfg_gen_dbe;
wire                                                                   cfg_reorder_data;
wire                                                                   cfg_user_rfsh;
wire                                                                   cfg_regdimm_enable;
wire                                                                   cfg_enable_burst_interrupt;
wire                                                                   cfg_enable_burst_terminate;
wire                                                                   cfg_enable_dqs_tracking;
wire                                                                   cfg_output_regd;
wire                                                                   cfg_enable_no_dm;
wire                                                                   cfg_enable_ecc_code_overwrites;
wire    [CFG_PORT_WIDTH_CAS_WR_LAT                         - 1 : 0]    cfg_cas_wr_lat;
wire    [CFG_PORT_WIDTH_ADD_LAT                            - 1 : 0]    cfg_add_lat;
wire    [CFG_PORT_WIDTH_TCL                                - 1 : 0]    cfg_tcl;
wire    [CFG_PORT_WIDTH_TRRD                               - 1 : 0]    cfg_trrd;
wire    [CFG_PORT_WIDTH_TFAW                               - 1 : 0]    cfg_tfaw;
wire    [CFG_PORT_WIDTH_TRFC                               - 1 : 0]    cfg_trfc;
wire    [CFG_PORT_WIDTH_TREFI                              - 1 : 0]    cfg_trefi;
wire    [CFG_PORT_WIDTH_TRCD                               - 1 : 0]    cfg_trcd;
wire    [CFG_PORT_WIDTH_TRP                                - 1 : 0]    cfg_trp;
wire    [CFG_PORT_WIDTH_TWR                                - 1 : 0]    cfg_twr;
wire    [CFG_PORT_WIDTH_TWTR                               - 1 : 0]    cfg_twtr;
wire    [CFG_PORT_WIDTH_TRTP                               - 1 : 0]    cfg_trtp;
wire    [CFG_PORT_WIDTH_TRAS                               - 1 : 0]    cfg_tras;
wire    [CFG_PORT_WIDTH_TRC                                - 1 : 0]    cfg_trc;
wire    [CFG_PORT_WIDTH_AUTO_PD_CYCLES                     - 1 : 0]    cfg_auto_pd_cycles;
wire    [CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES              - 1 : 0]    cfg_self_rfsh_exit_cycles;
wire    [CFG_PORT_WIDTH_PDN_EXIT_CYCLES                    - 1 : 0]    cfg_pdn_exit_cycles;
wire    [CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES           - 1 : 0]    cfg_power_saving_exit_cycles;
wire    [CFG_PORT_WIDTH_MEM_CLK_ENTRY_CYCLES               - 1 : 0]    cfg_mem_clk_entry_cycles;
wire    [CFG_PORT_WIDTH_TMRD                               - 1 : 0]    cfg_tmrd;
wire    [CFG_PORT_WIDTH_COL_ADDR_WIDTH                     - 1 : 0]    cfg_col_addr_width;
wire    [CFG_PORT_WIDTH_ROW_ADDR_WIDTH                     - 1 : 0]    cfg_row_addr_width;
wire    [CFG_PORT_WIDTH_BANK_ADDR_WIDTH                    - 1 : 0]    cfg_bank_addr_width;
wire    [CFG_PORT_WIDTH_CS_ADDR_WIDTH                      - 1 : 0]    cfg_cs_addr_width;
wire                                                                   cfg_enable_intr;
wire                                                                   cfg_mask_sbe_intr;
wire                                                                   cfg_mask_dbe_intr;
wire                                                                   cfg_clr_intr;
wire                                                                   cfg_cal_req;

wire    [4                                                 - 1 : 0]    cfg_clock_off;
wire                                                                   cfg_self_rfsh;
wire                                                                   cfg_ganged_arf;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR          - 1 : 0]    cfg_extra_ctl_clk_act_to_rdwr;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH           - 1 : 0]    cfg_extra_ctl_clk_act_to_pch;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT           - 1 : 0]    cfg_extra_ctl_clk_act_to_act;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD             - 1 : 0]    cfg_extra_ctl_clk_rd_to_rd;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP   - 1 : 0]    cfg_extra_ctl_clk_rd_to_rd_diff_chip;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR             - 1 : 0]    cfg_extra_ctl_clk_rd_to_wr;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC          - 1 : 0]    cfg_extra_ctl_clk_rd_to_wr_bc;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP   - 1 : 0]    cfg_extra_ctl_clk_rd_to_wr_diff_chip;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH            - 1 : 0]    cfg_extra_ctl_clk_rd_to_pch;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID       - 1 : 0]    cfg_extra_ctl_clk_rd_ap_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR             - 1 : 0]    cfg_extra_ctl_clk_wr_to_wr;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP   - 1 : 0]    cfg_extra_ctl_clk_wr_to_wr_diff_chip;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD             - 1 : 0]    cfg_extra_ctl_clk_wr_to_rd;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC          - 1 : 0]    cfg_extra_ctl_clk_wr_to_rd_bc;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP   - 1 : 0]    cfg_extra_ctl_clk_wr_to_rd_diff_chip;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH            - 1 : 0]    cfg_extra_ctl_clk_wr_to_pch;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID       - 1 : 0]    cfg_extra_ctl_clk_wr_ap_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID         - 1 : 0]    cfg_extra_ctl_clk_pch_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID     - 1 : 0]    cfg_extra_ctl_clk_pch_all_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK - 1 : 0]    cfg_extra_ctl_clk_act_to_act_diff_bank;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT      - 1 : 0]    cfg_extra_ctl_clk_four_act_to_act;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID         - 1 : 0]    cfg_extra_ctl_clk_arf_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID         - 1 : 0]    cfg_extra_ctl_clk_pdn_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID         - 1 : 0]    cfg_extra_ctl_clk_srf_to_valid;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL        - 1 : 0]    cfg_extra_ctl_clk_srf_to_zq_cal;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD           - 1 : 0]    cfg_extra_ctl_clk_arf_period;
wire    [CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD           - 1 : 0]    cfg_extra_ctl_clk_pdn_period;
wire    [CFG_PORT_WIDTH_STARVE_LIMIT                       - 1 : 0]    cfg_starve_limit;
wire    [CFG_PORT_WIDTH_WRITE_ODT_CHIP                     - 1 : 0]    cfg_write_odt_chip;
wire    [CFG_PORT_WIDTH_READ_ODT_CHIP                      - 1 : 0]    cfg_read_odt_chip;
wire    [CFG_PORT_WIDTH_INTERFACE_WIDTH                    - 1 : 0]    cfg_interface_width;
wire    [CFG_PORT_WIDTH_DEVICE_WIDTH                       - 1 : 0]    cfg_device_width;
wire    [CFG_PORT_WIDTH_TCCD                               - 1 : 0]    cfg_tccd;
wire                                                                   cfg_mask_corr_dropped_intr;
wire    [2                                                 - 1 : 0]    cfg_mem_bl;
wire                                                                   cfg_user_ecc_en;

//ECC related outputs from controller to csr
wire    [STS_PORT_WIDTH_SBE_ERROR                          - 1 : 0]    sts_sbe_error;
wire    [STS_PORT_WIDTH_DBE_ERROR                          - 1 : 0]    sts_dbe_error;
wire    [STS_PORT_WIDTH_SBE_COUNT                          - 1 : 0]    sts_sbe_count;
wire    [STS_PORT_WIDTH_DBE_COUNT                          - 1 : 0]    sts_dbe_count;
wire    [CFG_LOCAL_ADDR_WIDTH                              - 1 : 0]    sts_err_addr;
wire    [STS_PORT_WIDTH_CORR_DROP_ERROR                    - 1 : 0]    sts_corr_dropped;
wire    [STS_PORT_WIDTH_CORR_DROP_COUNT                    - 1 : 0]    sts_corr_dropped_count;
wire    [CFG_LOCAL_ADDR_WIDTH                              - 1 : 0]    sts_corr_dropped_addr;

//
// Reconfiguration Support
//
// cfg_* signals may be reconfigured to different values using the Configuration Status Registers
//      - some cfg_* signals are not reconfigurable, and are always assigned to parameters
//      - When CSR is not enabled
//          - cfg_* signals are assigned to parameters
//      - when CSR is enabled
//          - cfg_* signals are assigned to csr_* signals
//              - csr_* signal generation based on Configuration Registers
//              - default value for csr_* signals are based on parameters

// cfg_* signals that are not reconfigurable
       assign   cfg_type                                = CFG_TYPE;
       assign   cfg_interface_width                     = CFG_INTERFACE_WIDTH;
       assign   cfg_device_width                        = CFG_DEVICE_WIDTH;
       assign   cfg_enable_ecc_code_overwrites          = CFG_ENABLE_ECC_CODE_OVERWRITES;
       assign   cfg_enable_no_dm                        = CFG_ENABLE_NO_DM;
       assign   cfg_output_regd                         = CFG_OUTPUT_REGD;
       assign   cfg_pdn_exit_cycles                     = CFG_PDN_EXIT_CYCLES;
       assign   cfg_power_saving_exit_cycles            = CFG_POWER_SAVING_EXIT_CYCLES;
       assign   cfg_mem_clk_entry_cycles                = CFG_MEM_CLK_ENTRY_CYCLES;
       assign   cfg_self_rfsh_exit_cycles               = CFG_SELF_RFSH_EXIT_CYCLES;
       assign   cfg_tccd                                = CFG_TCCD;
       assign   cfg_tmrd                                = CFG_TMRD;
       assign   cfg_user_rfsh                           = CFG_USER_RFSH;
       assign   cfg_write_odt_chip                      = CFG_WRITE_ODT_CHIP;
       assign   cfg_read_odt_chip                       = CFG_READ_ODT_CHIP;
       assign   cfg_enable_dqs_tracking                 = CFG_ENABLE_DQS_TRACKING;
       assign   cfg_enable_burst_interrupt              = CFG_ENABLE_BURST_INTERRUPT;
       assign   cfg_enable_burst_terminate              = CFG_ENABLE_BURST_TERMINATE;
       assign   cfg_extra_ctl_clk_act_to_rdwr           = CFG_EXTRA_CTL_CLK_ACT_TO_RDWR;
       assign   cfg_extra_ctl_clk_act_to_pch            = CFG_EXTRA_CTL_CLK_ACT_TO_PCH;
       assign   cfg_extra_ctl_clk_act_to_act            = CFG_EXTRA_CTL_CLK_ACT_TO_ACT;
       assign   cfg_extra_ctl_clk_rd_to_rd              = CFG_EXTRA_CTL_CLK_RD_TO_RD;
       assign   cfg_extra_ctl_clk_rd_to_rd_diff_chip    = CFG_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP;
       assign   cfg_extra_ctl_clk_rd_to_wr              = CFG_EXTRA_CTL_CLK_RD_TO_WR;
       assign   cfg_extra_ctl_clk_rd_to_wr_bc           = CFG_EXTRA_CTL_CLK_RD_TO_WR_BC;
       assign   cfg_extra_ctl_clk_rd_to_wr_diff_chip    = CFG_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP;
       assign   cfg_extra_ctl_clk_rd_to_pch             = CFG_EXTRA_CTL_CLK_RD_TO_PCH;
       assign   cfg_extra_ctl_clk_rd_ap_to_valid        = CFG_EXTRA_CTL_CLK_RD_AP_TO_VALID;
       assign   cfg_extra_ctl_clk_wr_to_wr              = CFG_EXTRA_CTL_CLK_WR_TO_WR;
       assign   cfg_extra_ctl_clk_wr_to_wr_diff_chip    = CFG_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP;
       assign   cfg_extra_ctl_clk_wr_to_rd              = CFG_EXTRA_CTL_CLK_WR_TO_RD;
       assign   cfg_extra_ctl_clk_wr_to_rd_bc           = CFG_EXTRA_CTL_CLK_WR_TO_RD_BC;
       assign   cfg_extra_ctl_clk_wr_to_rd_diff_chip    = CFG_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP;
       assign   cfg_extra_ctl_clk_wr_to_pch             = CFG_EXTRA_CTL_CLK_WR_TO_PCH;
       assign   cfg_extra_ctl_clk_wr_ap_to_valid        = CFG_EXTRA_CTL_CLK_WR_AP_TO_VALID;
       assign   cfg_extra_ctl_clk_pch_to_valid          = CFG_EXTRA_CTL_CLK_PCH_TO_VALID;
       assign   cfg_extra_ctl_clk_pch_all_to_valid      = CFG_EXTRA_CTL_CLK_PCH_ALL_TO_VALID;
       assign   cfg_extra_ctl_clk_act_to_act_diff_bank  = CFG_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK;
       assign   cfg_extra_ctl_clk_four_act_to_act       = CFG_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT;
       assign   cfg_extra_ctl_clk_arf_to_valid          = CFG_EXTRA_CTL_CLK_ARF_TO_VALID;
       assign   cfg_extra_ctl_clk_pdn_to_valid          = CFG_EXTRA_CTL_CLK_PDN_TO_VALID;
       assign   cfg_extra_ctl_clk_srf_to_valid          = CFG_EXTRA_CTL_CLK_SRF_TO_VALID;
       assign   cfg_extra_ctl_clk_srf_to_zq_cal         = CFG_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL;
       assign   cfg_extra_ctl_clk_arf_period            = CFG_EXTRA_CTL_CLK_ARF_PERIOD;
       assign   cfg_extra_ctl_clk_pdn_period            = CFG_EXTRA_CTL_CLK_PDN_PERIOD;

// cfg_* signals that are reconfigurable
generate
    if (CTL_CSR_ENABLED == 1) begin

        wire    [CFG_PORT_WIDTH_TYPE                               - 1 : 0]    csr_cfg_type;
        wire    [CFG_PORT_WIDTH_BURST_LENGTH                       - 1 : 0]    csr_cfg_burst_length;
        wire    [CFG_PORT_WIDTH_ADDR_ORDER                         - 1 : 0]    csr_cfg_addr_order;
        wire                                                                   csr_cfg_enable_ecc;
        wire                                                                   csr_cfg_enable_auto_corr;
        wire                                                                   csr_cfg_gen_sbe;
        wire                                                                   csr_cfg_gen_dbe;
        wire                                                                   csr_cfg_reorder_data;
        wire                                                                   csr_cfg_regdimm_enable;
        wire    [CFG_PORT_WIDTH_CAS_WR_LAT                         - 1 : 0]    csr_cfg_cas_wr_lat;
        wire    [CFG_PORT_WIDTH_ADD_LAT                            - 1 : 0]    csr_cfg_add_lat;
        wire    [CFG_PORT_WIDTH_TCL                                - 1 : 0]    csr_cfg_tcl;
        wire    [CFG_PORT_WIDTH_TRRD                               - 1 : 0]    csr_cfg_trrd;
        wire    [CFG_PORT_WIDTH_TFAW                               - 1 : 0]    csr_cfg_tfaw;
        wire    [CFG_PORT_WIDTH_TRFC                               - 1 : 0]    csr_cfg_trfc;
        wire    [CFG_PORT_WIDTH_TREFI                              - 1 : 0]    csr_cfg_trefi;
        wire    [CFG_PORT_WIDTH_TRCD                               - 1 : 0]    csr_cfg_trcd;
        wire    [CFG_PORT_WIDTH_TRP                                - 1 : 0]    csr_cfg_trp;
        wire    [CFG_PORT_WIDTH_TWR                                - 1 : 0]    csr_cfg_twr;
        wire    [CFG_PORT_WIDTH_TWTR                               - 1 : 0]    csr_cfg_twtr;
        wire    [CFG_PORT_WIDTH_TRTP                               - 1 : 0]    csr_cfg_trtp;
        wire    [CFG_PORT_WIDTH_TRAS                               - 1 : 0]    csr_cfg_tras;
        wire    [CFG_PORT_WIDTH_TRC                                - 1 : 0]    csr_cfg_trc;
        wire    [CFG_PORT_WIDTH_AUTO_PD_CYCLES                     - 1 : 0]    csr_cfg_auto_pd_cycles;
        wire    [CFG_PORT_WIDTH_COL_ADDR_WIDTH                     - 1 : 0]    csr_cfg_col_addr_width;
        wire    [CFG_PORT_WIDTH_ROW_ADDR_WIDTH                     - 1 : 0]    csr_cfg_row_addr_width;
        wire    [CFG_PORT_WIDTH_BANK_ADDR_WIDTH                    - 1 : 0]    csr_cfg_bank_addr_width;
        wire    [CFG_PORT_WIDTH_CS_ADDR_WIDTH                      - 1 : 0]    csr_cfg_cs_addr_width;
        wire                                                                   csr_cfg_enable_intr;
        wire                                                                   csr_cfg_mask_sbe_intr;
        wire                                                                   csr_cfg_mask_dbe_intr;
        wire                                                                   csr_cfg_clr_intr;
        wire                                                                   csr_cfg_cal_req;

        wire    [4                                                 - 1 : 0]    csr_cfg_clock_off;
        wire                                                                   csr_cfg_self_rfsh;
        wire                                                                   csr_cfg_ganged_arf;
        wire    [CFG_PORT_WIDTH_STARVE_LIMIT                       - 1 : 0]    csr_cfg_starve_limit;
        wire    [CFG_PORT_WIDTH_INTERFACE_WIDTH                    - 1 : 0]    csr_cfg_interface_width;
        wire    [CFG_PORT_WIDTH_DEVICE_WIDTH                       - 1 : 0]    csr_cfg_device_width;
        wire                                                                   csr_cfg_mask_corr_dropped_intr;
        wire    [2                                                 - 1 : 0]    csr_cfg_mem_bl;
        wire                                                                   csr_cfg_user_ecc_en;

        assign cfg_burst_length                         = csr_cfg_burst_length;
        assign cfg_reorder_data                         = csr_cfg_reorder_data;
        assign cfg_starve_limit                         = csr_cfg_starve_limit;
        assign cfg_addr_order                           = csr_cfg_addr_order;
        assign cfg_col_addr_width                       = csr_cfg_col_addr_width;
        assign cfg_row_addr_width                       = csr_cfg_row_addr_width;
        assign cfg_bank_addr_width                      = csr_cfg_bank_addr_width;
        assign cfg_cs_addr_width                        = csr_cfg_cs_addr_width;
        assign cfg_cas_wr_lat                           = csr_cfg_cas_wr_lat;
        assign cfg_add_lat                              = csr_cfg_add_lat;
        assign cfg_tcl                                  = csr_cfg_tcl;
        assign cfg_trrd                                 = csr_cfg_trrd;
        assign cfg_tfaw                                 = csr_cfg_tfaw;
        assign cfg_trfc                                 = csr_cfg_trfc;
        assign cfg_trefi                                = csr_cfg_trefi;
        assign cfg_trcd                                 = csr_cfg_trcd;
        assign cfg_trp                                  = csr_cfg_trp;
        assign cfg_twr                                  = csr_cfg_twr;
        assign cfg_twtr                                 = csr_cfg_twtr;
        assign cfg_trtp                                 = csr_cfg_trtp;
        assign cfg_tras                                 = csr_cfg_tras;
        assign cfg_trc                                  = csr_cfg_trc;
        assign cfg_enable_ecc                           = csr_cfg_enable_ecc;
        assign cfg_enable_auto_corr                     = csr_cfg_enable_auto_corr;
        assign cfg_gen_sbe                              = csr_cfg_gen_sbe;
        assign cfg_gen_dbe                              = csr_cfg_gen_dbe;
        assign cfg_enable_intr                          = csr_cfg_enable_intr;
        assign cfg_mask_sbe_intr                        = csr_cfg_mask_sbe_intr;
        assign cfg_mask_dbe_intr                        = csr_cfg_mask_dbe_intr;
        assign cfg_mask_corr_dropped_intr               = csr_cfg_mask_corr_dropped_intr;
        assign cfg_clr_intr                             = csr_cfg_clr_intr;
        assign cfg_regdimm_enable                       = csr_cfg_regdimm_enable;
        assign cfg_cal_req                              = csr_cfg_cal_req;
        assign cfg_auto_pd_cycles                       = csr_cfg_auto_pd_cycles;

        alt_mem_ddrx_csr # (
            .CFG_AVALON_ADDR_WIDTH                              ( CSR_ADDR_WIDTH                                     ),
            .CFG_AVALON_DATA_WIDTH                              ( CSR_DATA_WIDTH                                     ),
            .CFG_BURST_LENGTH                                   ( CFG_BURST_LENGTH                                   ),
            .CFG_REORDER_DATA                                   ( CFG_REORDER_DATA                                   ),
            .CFG_STARVE_LIMIT                                   ( CFG_STARVE_LIMIT                                   ),
            .CFG_ADDR_ORDER                                     ( CFG_ADDR_ORDER                                     ),
            .CFG_COL_ADDR_WIDTH                                 ( CFG_COL_ADDR_WIDTH                                 ),
            .CFG_ROW_ADDR_WIDTH                                 ( CFG_ROW_ADDR_WIDTH                                 ),
            .CFG_BANK_ADDR_WIDTH                                ( CFG_BANK_ADDR_WIDTH                                ),
            .CFG_CS_ADDR_WIDTH                                  ( CFG_CS_ADDR_WIDTH                                  ),
            .CFG_CAS_WR_LAT                                     ( CFG_CAS_WR_LAT                                     ),
            .CFG_ADD_LAT                                        ( CFG_ADD_LAT                                        ),
            .CFG_TCL                                            ( CFG_TCL                                            ),
            .CFG_TRRD                                           ( CFG_TRRD                                           ),
            .CFG_TFAW                                           ( CFG_TFAW                                           ),
            .CFG_TRFC                                           ( CFG_TRFC                                           ),
            .CFG_TREFI                                          ( CFG_TREFI                                          ),
            .CFG_TRCD                                           ( CFG_TRCD                                           ),
            .CFG_TRP                                            ( CFG_TRP                                            ),
            .CFG_TWR                                            ( CFG_TWR                                            ),
            .CFG_TWTR                                           ( CFG_TWTR                                           ),
            .CFG_TRTP                                           ( CFG_TRTP                                           ),
            .CFG_TRAS                                           ( CFG_TRAS                                           ),
            .CFG_TRC                                            ( CFG_TRC                                            ),
            .CFG_AUTO_PD_CYCLES                                 ( CFG_AUTO_PD_CYCLES                                 ),
            .CFG_ENABLE_ECC                                     ( CFG_ENABLE_ECC                                     ),
            .CFG_ENABLE_AUTO_CORR                               ( CFG_ENABLE_AUTO_CORR                               ),
            .CFG_REGDIMM_ENABLE                                 ( CFG_REGDIMM_ENABLE                                 ),
            .MEM_IF_DQS_WIDTH                                   ( CFG_MEM_IF_DQS_WIDTH                               )

        ) register_control_inst (
            .avalon_mm_read                                     ( csr_read_req                                       ),
            .avalon_mm_write                                    ( csr_write_req                                      ),
            .avalon_mm_addr                                     ( csr_addr                                           ),
            .avalon_mm_wdata                                    ( csr_wdata                                          ),
            .avalon_mm_rdata                                    ( csr_rdata                                          ),
            .avalon_mm_be                                       ( csr_be                                             ),
            .avalon_mm_waitrequest                              ( csr_waitrequest                                    ),
            .avalon_mm_rdata_valid                              ( csr_rdata_valid                                    ),

            .cfg_burst_length                                   ( csr_cfg_burst_length                               ),
            .cfg_addr_order                                     ( csr_cfg_addr_order                                 ),
            .cfg_enable_ecc                                     ( csr_cfg_enable_ecc                                 ),
            .cfg_enable_auto_corr                               ( csr_cfg_enable_auto_corr                           ),
            .cfg_gen_sbe                                        ( csr_cfg_gen_sbe                                    ),
            .cfg_gen_dbe                                        ( csr_cfg_gen_dbe                                    ),
            .cfg_reorder_data                                   ( csr_cfg_reorder_data                               ),
            .cfg_regdimm_enable                                 ( csr_cfg_regdimm_enable                             ),
            .cfg_cas_wr_lat                                     ( csr_cfg_cas_wr_lat                                 ),
            .cfg_add_lat                                        ( csr_cfg_add_lat                                    ),
            .cfg_tcl                                            ( csr_cfg_tcl                                        ),
            .cfg_trrd                                           ( csr_cfg_trrd                                       ),
            .cfg_tfaw                                           ( csr_cfg_tfaw                                       ),
            .cfg_trfc                                           ( csr_cfg_trfc                                       ),
            .cfg_trefi                                          ( csr_cfg_trefi                                      ),
            .cfg_trcd                                           ( csr_cfg_trcd                                       ),
            .cfg_trp                                            ( csr_cfg_trp                                        ),
            .cfg_twr                                            ( csr_cfg_twr                                        ),
            .cfg_twtr                                           ( csr_cfg_twtr                                       ),
            .cfg_trtp                                           ( csr_cfg_trtp                                       ),
            .cfg_tras                                           ( csr_cfg_tras                                       ),
            .cfg_trc                                            ( csr_cfg_trc                                        ),
            .cfg_auto_pd_cycles                                 ( csr_cfg_auto_pd_cycles                             ),
            .cfg_col_addr_width                                 ( csr_cfg_col_addr_width                             ),
            .cfg_row_addr_width                                 ( csr_cfg_row_addr_width                             ),
            .cfg_bank_addr_width                                ( csr_cfg_bank_addr_width                            ),
            .cfg_cs_addr_width                                  ( csr_cfg_cs_addr_width                              ),
            .cfg_enable_intr                                    ( csr_cfg_enable_intr                                ),
            .cfg_mask_sbe_intr                                  ( csr_cfg_mask_sbe_intr                              ),
            .cfg_mask_dbe_intr                                  ( csr_cfg_mask_dbe_intr                              ),
            .cfg_clr_intr                                       ( csr_cfg_clr_intr                                   ),
            .cfg_clock_off                                      ( csr_cfg_clock_off                                  ),
            .cfg_starve_limit                                   ( csr_cfg_starve_limit                               ),
            .cfg_mask_corr_dropped_intr                         ( csr_cfg_mask_corr_dropped_intr                     ),
            .cfg_cal_req                                        ( csr_cfg_cal_req                                    ),
            
            .local_power_down_ack                               ( local_powerdn_ack                                  ),
            .local_self_rfsh_ack                                ( local_self_rfsh_ack                                ),
            
            .sts_cal_success                                    ( afi_cal_success                                    ),
            .sts_cal_fail                                       ( afi_cal_fail                                       ),
            .sts_sbe_error                                      ( sts_sbe_error                                      ),
            .sts_dbe_error                                      ( sts_dbe_error                                      ),
            .sts_sbe_count                                      ( sts_sbe_count                                      ),
            .sts_dbe_count                                      ( sts_dbe_count                                      ),
            .sts_err_addr                                       ( sts_err_addr                                       ),
            .sts_corr_dropped                                   ( sts_corr_dropped                                   ),
            .sts_corr_dropped_count                             ( sts_corr_dropped_count                             ),
            .sts_corr_dropped_addr                              ( sts_corr_dropped_addr                              ),

            .ctl_clk                                            ( clk                                                ),
            .ctl_rst_n                                          ( reset_n                                            )
        );
    end
    else begin

        assign csr_rdata = 0;
        assign csr_rdata_valid = 0;
        assign csr_waitrequest = 0;

        assign cfg_burst_length                         = CFG_BURST_LENGTH;
        assign cfg_reorder_data                         = CFG_REORDER_DATA;
        assign cfg_starve_limit                         = CFG_STARVE_LIMIT;
        assign cfg_addr_order                           = CFG_ADDR_ORDER;
        assign cfg_col_addr_width                       = CFG_COL_ADDR_WIDTH;
        assign cfg_row_addr_width                       = CFG_ROW_ADDR_WIDTH;
        assign cfg_bank_addr_width                      = CFG_BANK_ADDR_WIDTH;
        assign cfg_cs_addr_width                        = CFG_CS_ADDR_WIDTH;
        assign cfg_cas_wr_lat                           = CFG_CAS_WR_LAT;
        assign cfg_add_lat                              = CFG_ADD_LAT;
        assign cfg_tcl                                  = CFG_TCL;
        assign cfg_trrd                                 = CFG_TRRD;
        assign cfg_tfaw                                 = CFG_TFAW;
        assign cfg_trfc                                 = CFG_TRFC;
        assign cfg_trefi                                = CFG_TREFI;
        assign cfg_trcd                                 = CFG_TRCD;
        assign cfg_trp                                  = CFG_TRP;
        assign cfg_twr                                  = CFG_TWR;
        assign cfg_twtr                                 = CFG_TWTR;
        assign cfg_trtp                                 = CFG_TRTP;
        assign cfg_tras                                 = CFG_TRAS;
        assign cfg_trc                                  = CFG_TRC;
        assign cfg_auto_pd_cycles                       = CFG_AUTO_PD_CYCLES;
        assign cfg_enable_ecc                           = CFG_ENABLE_ECC;
        assign cfg_enable_auto_corr                     = CFG_ENABLE_AUTO_CORR;
        assign cfg_gen_sbe                              = CFG_GEN_SBE;
        assign cfg_gen_dbe                              = CFG_GEN_DBE;
        assign cfg_enable_intr                          = CFG_ENABLE_INTR;
        assign cfg_mask_sbe_intr                        = CFG_MASK_SBE_INTR;
        assign cfg_mask_dbe_intr                        = CFG_MASK_DBE_INTR;
        assign cfg_mask_corr_dropped_intr               = CFG_MASK_CORR_DROPPED_INTR;
        assign cfg_clr_intr                             = CFG_CLR_INTR;
        assign cfg_regdimm_enable                       = CFG_REGDIMM_ENABLE;
        assign cfg_cal_req                              = CFG_CAL_REQ;

    end
endgenerate


// Next Gen Controller
alt_mem_ddrx_controller # (
    .CFG_LOCAL_SIZE_WIDTH                               ( CFG_LOCAL_SIZE_WIDTH                               ),
    .CFG_LOCAL_ADDR_WIDTH                               ( CFG_LOCAL_ADDR_WIDTH                               ),
    .CFG_LOCAL_DATA_WIDTH                               ( CFG_LOCAL_DATA_WIDTH                               ),
    .CFG_LOCAL_ID_WIDTH                                 ( CFG_LOCAL_ID_WIDTH                                 ),
    .CFG_LOCAL_IF_TYPE                                  ( CFG_LOCAL_IF_TYPE                                  ),
    .CFG_MEM_IF_ADDR_WIDTH                              ( CFG_MEM_IF_ADDR_WIDTH                              ),
    .CFG_MEM_IF_CLK_PAIR_COUNT                          ( CFG_MEM_IF_CLK_PAIR_COUNT                          ),
    .CFG_DWIDTH_RATIO                                   ( CFG_DWIDTH_RATIO                                   ),
    .CFG_ODT_ENABLED                                    ( CFG_ODT_ENABLED                                    ),
    .CFG_LPDDR2_ENABLED                                 ( CFG_LPDDR2_ENABLED                                 ),
    .CFG_CTL_TBP_NUM                                    ( CFG_CTL_TBP_NUM                                    ),
    .CFG_DATA_REORDERING_TYPE                           ( CFG_DATA_REORDERING_TYPE                           ),
    .CFG_WRBUFFER_ADDR_WIDTH                            ( CFG_WRBUFFER_ADDR_WIDTH                            ),
    .CFG_RDBUFFER_ADDR_WIDTH                            ( CFG_RDBUFFER_ADDR_WIDTH                            ),
    .CFG_ECC_MULTIPLES_16_24_40_72                      ( CFG_ECC_MULTIPLES_16_24_40_72                      ),
    .CFG_MEM_IF_CS_WIDTH                                ( CFG_MEM_IF_CS_WIDTH                                ),
    .CFG_MEM_IF_CHIP                                    ( CFG_MEM_IF_CHIP                                    ),
    .CFG_MEM_IF_BA_WIDTH                                ( CFG_MEM_IF_BA_WIDTH                                ),
    .CFG_MEM_IF_ROW_WIDTH                               ( CFG_MEM_IF_ROW_WIDTH                               ),
    .CFG_MEM_IF_COL_WIDTH                               ( CFG_MEM_IF_COL_WIDTH                               ),
    .CFG_MEM_IF_CKE_WIDTH                               ( CFG_MEM_IF_CKE_WIDTH                               ),
    .CFG_MEM_IF_ODT_WIDTH                               ( CFG_MEM_IF_ODT_WIDTH                               ),
    .CFG_MEM_IF_DQS_WIDTH                               ( CFG_MEM_IF_DQS_WIDTH                               ),
    .CFG_MEM_IF_DQ_WIDTH                                ( CFG_MEM_IF_DQ_WIDTH                                ),
    .CFG_MEM_IF_DM_WIDTH                                ( CFG_MEM_IF_DM_WIDTH                                ),
    .CFG_PORT_WIDTH_TYPE                                ( CFG_PORT_WIDTH_TYPE                                ),
    .CFG_PORT_WIDTH_INTERFACE_WIDTH                     ( CFG_PORT_WIDTH_INTERFACE_WIDTH                     ),
    .CFG_PORT_WIDTH_BURST_LENGTH                        ( CFG_PORT_WIDTH_BURST_LENGTH                        ),
    .CFG_PORT_WIDTH_DEVICE_WIDTH                        ( CFG_PORT_WIDTH_DEVICE_WIDTH                        ),
    .CFG_PORT_WIDTH_REORDER_DATA                        ( CFG_PORT_WIDTH_REORDER_DATA                        ),
    .CFG_PORT_WIDTH_STARVE_LIMIT                        ( CFG_PORT_WIDTH_STARVE_LIMIT                        ),
    .CFG_PORT_WIDTH_OUTPUT_REGD                         ( CFG_PORT_WIDTH_OUTPUT_REGD                         ),
    .CFG_PORT_WIDTH_ADDR_ORDER                          ( CFG_PORT_WIDTH_ADDR_ORDER                          ),
    .CFG_PORT_WIDTH_COL_ADDR_WIDTH                      ( CFG_PORT_WIDTH_COL_ADDR_WIDTH                      ),
    .CFG_PORT_WIDTH_ROW_ADDR_WIDTH                      ( CFG_PORT_WIDTH_ROW_ADDR_WIDTH                      ),
    .CFG_PORT_WIDTH_BANK_ADDR_WIDTH                     ( CFG_PORT_WIDTH_BANK_ADDR_WIDTH                     ),
    .CFG_PORT_WIDTH_CS_ADDR_WIDTH                       ( CFG_PORT_WIDTH_CS_ADDR_WIDTH                       ),
    .CFG_PORT_WIDTH_CAS_WR_LAT                          ( CFG_PORT_WIDTH_CAS_WR_LAT                          ),
    .CFG_PORT_WIDTH_ADD_LAT                             ( CFG_PORT_WIDTH_ADD_LAT                             ),
    .CFG_PORT_WIDTH_TCL                                 ( CFG_PORT_WIDTH_TCL                                 ),
    .CFG_PORT_WIDTH_TRRD                                ( CFG_PORT_WIDTH_TRRD                                ),
    .CFG_PORT_WIDTH_TFAW                                ( CFG_PORT_WIDTH_TFAW                                ),
    .CFG_PORT_WIDTH_TRFC                                ( CFG_PORT_WIDTH_TRFC                                ),
    .CFG_PORT_WIDTH_TREFI                               ( CFG_PORT_WIDTH_TREFI                               ),
    .CFG_PORT_WIDTH_TRCD                                ( CFG_PORT_WIDTH_TRCD                                ),
    .CFG_PORT_WIDTH_TRP                                 ( CFG_PORT_WIDTH_TRP                                 ),
    .CFG_PORT_WIDTH_TWR                                 ( CFG_PORT_WIDTH_TWR                                 ),
    .CFG_PORT_WIDTH_TWTR                                ( CFG_PORT_WIDTH_TWTR                                ),
    .CFG_PORT_WIDTH_TRTP                                ( CFG_PORT_WIDTH_TRTP                                ),
    .CFG_PORT_WIDTH_TRAS                                ( CFG_PORT_WIDTH_TRAS                                ),
    .CFG_PORT_WIDTH_TRC                                 ( CFG_PORT_WIDTH_TRC                                 ),
    .CFG_PORT_WIDTH_TCCD                                ( CFG_PORT_WIDTH_TCCD                                ),
    .CFG_PORT_WIDTH_TMRD                                ( CFG_PORT_WIDTH_TMRD                                ),
    .CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES               ( CFG_PORT_WIDTH_SELF_RFSH_EXIT_CYCLES               ),
    .CFG_PORT_WIDTH_PDN_EXIT_CYCLES                     ( CFG_PORT_WIDTH_PDN_EXIT_CYCLES                     ),
    .CFG_PORT_WIDTH_AUTO_PD_CYCLES                      ( CFG_PORT_WIDTH_AUTO_PD_CYCLES                      ),
    .CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES            ( CFG_PORT_WIDTH_POWER_SAVING_EXIT_CYCLES            ),
    .CFG_PORT_WIDTH_MEM_CLK_ENTRY_CYCLES                ( CFG_PORT_WIDTH_MEM_CLK_ENTRY_CYCLES                ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR           ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_RDWR           ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH            ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_PCH            ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT            ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT            ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD              ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD              ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP    ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_RD_DIFF_CHIP    ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR              ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR              ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC           ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_BC           ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP    ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP    ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH             ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_TO_PCH             ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID        ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_RD_AP_TO_VALID        ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR              ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR              ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP    ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP    ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD              ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD              ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC           ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_BC           ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP    ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP    ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH             ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_TO_PCH             ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID        ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_WR_AP_TO_VALID        ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID          ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_TO_VALID          ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID      ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_PCH_ALL_TO_VALID      ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK  ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_ACT_TO_ACT_DIFF_BANK  ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT       ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_FOUR_ACT_TO_ACT       ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID          ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_TO_VALID          ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID          ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_TO_VALID          ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID          ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_VALID          ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL         ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_SRF_TO_ZQ_CAL         ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD            ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_ARF_PERIOD            ),
    .CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD            ( CFG_PORT_WIDTH_EXTRA_CTL_CLK_PDN_PERIOD            ),
    .CFG_PORT_WIDTH_ENABLE_ECC                          ( CFG_PORT_WIDTH_ENABLE_ECC                          ),
    .CFG_PORT_WIDTH_ENABLE_AUTO_CORR                    ( CFG_PORT_WIDTH_ENABLE_AUTO_CORR                    ),
    .CFG_PORT_WIDTH_GEN_SBE                             ( CFG_PORT_WIDTH_GEN_SBE                             ),
    .CFG_PORT_WIDTH_GEN_DBE                             ( CFG_PORT_WIDTH_GEN_DBE                             ),
    .CFG_PORT_WIDTH_ENABLE_INTR                         ( CFG_PORT_WIDTH_ENABLE_INTR                         ),
    .CFG_PORT_WIDTH_MASK_SBE_INTR                       ( CFG_PORT_WIDTH_MASK_SBE_INTR                       ),
    .CFG_PORT_WIDTH_MASK_DBE_INTR                       ( CFG_PORT_WIDTH_MASK_DBE_INTR                       ),
    .CFG_PORT_WIDTH_CLR_INTR                            ( CFG_PORT_WIDTH_CLR_INTR                            ),
    .CFG_PORT_WIDTH_USER_RFSH                           ( CFG_PORT_WIDTH_USER_RFSH                           ),
    .CFG_PORT_WIDTH_SELF_RFSH                           ( CFG_PORT_WIDTH_SELF_RFSH                           ),
    .CFG_PORT_WIDTH_REGDIMM_ENABLE                      ( CFG_PORT_WIDTH_REGDIMM_ENABLE                      ),
    .CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT              ( CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT              ),
    .CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE              ( CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE              ),
    .CFG_PORT_WIDTH_WRITE_ODT_CHIP                      ( CFG_PORT_WIDTH_WRITE_ODT_CHIP                      ),
    .CFG_PORT_WIDTH_READ_ODT_CHIP                       ( CFG_PORT_WIDTH_READ_ODT_CHIP                       ),
    .CFG_WLAT_BUS_WIDTH                                 ( CFG_WLAT_BUS_WIDTH                                 ),
    .CFG_RDATA_RETURN_MODE                              ( CFG_RDATA_RETURN_MODE                              )

) controller_inst (
    .ctl_clk                                            ( clk                                                ),
    .ctl_reset_n                                        ( reset_n                                            ),

    .itf_cmd_ready                                      ( itf_cmd_ready                                      ),
    .itf_cmd_valid                                      ( itf_cmd_valid                                      ),
    .itf_cmd                                            ( itf_cmd                                            ),
    .itf_cmd_address                                    ( itf_cmd_address                                    ),
    .itf_cmd_burstlen                                   ( itf_cmd_burstlen                                   ),
    .itf_cmd_id                                         ( itf_cmd_id                                         ),
    .itf_cmd_priority                                   ( itf_cmd_priority                                   ),
    .itf_cmd_autopercharge                              ( itf_cmd_autopercharge                              ),
    .itf_cmd_multicast                                  ( itf_cmd_multicast                                  ),

    .itf_wr_data_ready                                  ( itf_wr_data_ready                                  ),
    .itf_wr_data_valid                                  ( itf_wr_data_valid                                  ),
    .itf_wr_data                                        ( itf_wr_data                                        ),
    .itf_wr_data_byte_en                                ( itf_wr_data_byte_en                                ),
    .itf_wr_data_begin                                  ( itf_wr_data_begin                                  ),
    .itf_wr_data_last                                   ( itf_wr_data_last                                   ),
    .itf_wr_data_id                                     ( itf_wr_data_id                                     ),

    .itf_rd_data_ready                                  ( itf_rd_data_ready                                  ),
    .itf_rd_data_valid                                  ( itf_rd_data_valid                                  ),
    .itf_rd_data                                        ( itf_rd_data                                        ),
    .itf_rd_data_error                                  ( itf_rd_data_error                                  ),
    .itf_rd_data_begin                                  ( itf_rd_data_begin                                  ),
    .itf_rd_data_last                                   ( itf_rd_data_last                                   ),
    .itf_rd_data_id                                     ( itf_rd_data_id                                     ),

    .local_refresh_req                                  ( local_refresh_req                                  ),
    .local_refresh_chip                                 ( local_refresh_chip                                 ),
    .local_deep_powerdn_req                             ( local_deep_powerdn_req                             ),
	.local_deep_powerdn_chip                            ( local_deep_powerdn_chip                            ),
    .local_self_rfsh_req                                ( local_self_rfsh_req                                ),
    .local_self_rfsh_chip                               ( local_self_rfsh_chip                               ),
    .local_refresh_ack                                  ( local_refresh_ack                                  ),
    .local_deep_powerdn_ack                             ( local_deep_powerdn_ack	                         ),
    .local_power_down_ack                               ( local_powerdn_ack                                  ),
    .local_self_rfsh_ack                                ( local_self_rfsh_ack                                ),
    .local_init_done                                    ( local_init_done                                    ),

    .afi_cke                                            ( afi_cke                                            ),
    .afi_cs_n                                           ( afi_cs_n                                           ),
    .afi_ras_n                                          ( afi_ras_n                                          ),
    .afi_cas_n                                          ( afi_cas_n                                          ),
    .afi_we_n                                           ( afi_we_n                                           ),
    .afi_ba                                             ( afi_ba                                             ),
    .afi_addr                                           ( afi_addr                                           ),
    .afi_odt                                            ( afi_odt                                            ),
    .afi_rst_n                                          ( afi_rst_n                                          ),

    .afi_dqs_burst                                      ( afi_dqs_burst                                      ),
    .afi_wdata_valid                                    ( afi_wdata_valid                                    ),
    .afi_wdata                                          ( afi_wdata                                          ),
    .afi_dm                                             ( afi_dm                                             ),
    .afi_wlat                                           ( afi_wlat                                           ),
    .afi_rdata_en                                       ( afi_rdata_en                                       ),
    .afi_rdata_en_full                                  ( afi_rdata_en_full                                  ),
    .afi_rdata                                          ( afi_rdata                                          ),
    .afi_rdata_valid                                    ( afi_rdata_valid                                    ),
    .ctl_cal_success                                    ( afi_cal_success                                    ),
    .ctl_cal_fail                                       ( afi_cal_fail                                       ),
    .ctl_cal_req                                        ( afi_cal_req                                        ),
    .ctl_init_req                                       ( afi_init_req                                       ),
    .ctl_mem_clk_disable                                ( afi_mem_clk_disable                                ),
    .ctl_cal_byte_lane_sel_n                            ( afi_cal_byte_lane_sel_n                            ),

    .cfg_type                                           ( cfg_type                                           ),
    .cfg_interface_width                                ( cfg_interface_width                                ),
    .cfg_burst_length                                   ( cfg_burst_length                                   ),
    .cfg_device_width                                   ( cfg_device_width                                   ),
    .cfg_reorder_data                                   ( cfg_reorder_data                                   ),
    .cfg_starve_limit                                   ( cfg_starve_limit                                   ),
    .cfg_output_regd                                    ( cfg_output_regd                                    ),

    .cfg_addr_order                                     ( cfg_addr_order                                     ),
    .cfg_col_addr_width                                 ( cfg_col_addr_width                                 ),
    .cfg_row_addr_width                                 ( cfg_row_addr_width                                 ),
    .cfg_bank_addr_width                                ( cfg_bank_addr_width                                ),
    .cfg_cs_addr_width                                  ( cfg_cs_addr_width                                  ),
    .cfg_cas_wr_lat                                     ( cfg_cas_wr_lat                                     ),
    .cfg_add_lat                                        ( cfg_add_lat                                        ),
    .cfg_tcl                                            ( cfg_tcl                                            ),
    .cfg_trrd                                           ( cfg_trrd                                           ),
    .cfg_tfaw                                           ( cfg_tfaw                                           ),
    .cfg_trfc                                           ( cfg_trfc                                           ),
    .cfg_trefi                                          ( cfg_trefi                                          ),
    .cfg_trcd                                           ( cfg_trcd                                           ),
    .cfg_trp                                            ( cfg_trp                                            ),
    .cfg_twr                                            ( cfg_twr                                            ),
    .cfg_twtr                                           ( cfg_twtr                                           ),
    .cfg_trtp                                           ( cfg_trtp                                           ),
    .cfg_tras                                           ( cfg_tras                                           ),
    .cfg_trc                                            ( cfg_trc                                            ),
    .cfg_tccd                                           ( cfg_tccd                                           ),
    .cfg_auto_pd_cycles                                 ( cfg_auto_pd_cycles                                 ),
    .cfg_self_rfsh_exit_cycles                          ( cfg_self_rfsh_exit_cycles                          ),
    .cfg_pdn_exit_cycles                                ( cfg_pdn_exit_cycles                                ),
    .cfg_power_saving_exit_cycles                       ( cfg_power_saving_exit_cycles                       ),
    .cfg_mem_clk_entry_cycles                           ( cfg_mem_clk_entry_cycles                           ),
    .cfg_tmrd                                           ( cfg_tmrd                                           ),
    .cfg_enable_ecc                                     ( cfg_enable_ecc                                     ),
    .cfg_enable_auto_corr                               ( cfg_enable_auto_corr                               ),
    .cfg_enable_no_dm                                   ( cfg_enable_no_dm                                   ),
    .cfg_enable_ecc_code_overwrites                     ( cfg_enable_ecc_code_overwrites                     ),
    .cfg_cal_req                                        ( cfg_cal_req                                        ),
    .cfg_gen_sbe                                        ( cfg_gen_sbe                                        ),
    .cfg_gen_dbe                                        ( cfg_gen_dbe                                        ),
    .cfg_enable_intr                                    ( cfg_enable_intr                                    ),
    .cfg_mask_sbe_intr                                  ( cfg_mask_sbe_intr                                  ),
    .cfg_mask_dbe_intr                                  ( cfg_mask_dbe_intr                                  ),
    .cfg_mask_corr_dropped_intr                         ( cfg_mask_corr_dropped_intr                         ),

    .cfg_clr_intr                                       ( cfg_clr_intr                                       ),
    .cfg_user_rfsh                                      ( cfg_user_rfsh                                      ),
    .cfg_regdimm_enable                                 ( cfg_regdimm_enable                                 ),
    .cfg_enable_burst_interrupt                         ( cfg_enable_burst_interrupt                         ),
    .cfg_enable_burst_terminate                         ( cfg_enable_burst_terminate                         ),
    .cfg_write_odt_chip                                 ( cfg_write_odt_chip                                 ),
    .cfg_read_odt_chip                                  ( cfg_read_odt_chip                                  ),
    .cfg_extra_ctl_clk_act_to_rdwr                      ( cfg_extra_ctl_clk_act_to_rdwr                      ),
    .cfg_extra_ctl_clk_act_to_pch                       ( cfg_extra_ctl_clk_act_to_pch                       ),
    .cfg_extra_ctl_clk_act_to_act                       ( cfg_extra_ctl_clk_act_to_act                       ),
    .cfg_extra_ctl_clk_rd_to_rd                         ( cfg_extra_ctl_clk_rd_to_rd                         ),
    .cfg_extra_ctl_clk_rd_to_rd_diff_chip               ( cfg_extra_ctl_clk_rd_to_rd_diff_chip               ),
    .cfg_extra_ctl_clk_rd_to_wr                         ( cfg_extra_ctl_clk_rd_to_wr                         ),
    .cfg_extra_ctl_clk_rd_to_wr_bc                      ( cfg_extra_ctl_clk_rd_to_wr_bc                      ),
    .cfg_extra_ctl_clk_rd_to_wr_diff_chip               ( cfg_extra_ctl_clk_rd_to_wr_diff_chip               ),
    .cfg_extra_ctl_clk_rd_to_pch                        ( cfg_extra_ctl_clk_rd_to_pch                        ),
    .cfg_extra_ctl_clk_rd_ap_to_valid                   ( cfg_extra_ctl_clk_rd_ap_to_valid                   ),
    .cfg_extra_ctl_clk_wr_to_wr                         ( cfg_extra_ctl_clk_wr_to_wr                         ),
    .cfg_extra_ctl_clk_wr_to_wr_diff_chip               ( cfg_extra_ctl_clk_wr_to_wr_diff_chip               ),
    .cfg_extra_ctl_clk_wr_to_rd                         ( cfg_extra_ctl_clk_wr_to_rd                         ),
    .cfg_extra_ctl_clk_wr_to_rd_bc                      ( cfg_extra_ctl_clk_wr_to_rd_bc                      ),
    .cfg_extra_ctl_clk_wr_to_rd_diff_chip               ( cfg_extra_ctl_clk_wr_to_rd_diff_chip               ),
    .cfg_extra_ctl_clk_wr_to_pch                        ( cfg_extra_ctl_clk_wr_to_pch                        ),
    .cfg_extra_ctl_clk_wr_ap_to_valid                   ( cfg_extra_ctl_clk_wr_ap_to_valid                   ),
    .cfg_extra_ctl_clk_pch_to_valid                     ( cfg_extra_ctl_clk_pch_to_valid                     ),
    .cfg_extra_ctl_clk_pch_all_to_valid                 ( cfg_extra_ctl_clk_pch_all_to_valid                 ),
    .cfg_extra_ctl_clk_act_to_act_diff_bank             ( cfg_extra_ctl_clk_act_to_act_diff_bank             ),
    .cfg_extra_ctl_clk_four_act_to_act                  ( cfg_extra_ctl_clk_four_act_to_act                  ),
    .cfg_extra_ctl_clk_arf_to_valid                     ( cfg_extra_ctl_clk_arf_to_valid                     ),
    .cfg_extra_ctl_clk_pdn_to_valid                     ( cfg_extra_ctl_clk_pdn_to_valid                     ),
    .cfg_extra_ctl_clk_srf_to_valid                     ( cfg_extra_ctl_clk_srf_to_valid                     ),
    .cfg_extra_ctl_clk_srf_to_zq_cal                    ( cfg_extra_ctl_clk_srf_to_zq_cal                    ),
    .cfg_extra_ctl_clk_arf_period                       ( cfg_extra_ctl_clk_arf_period                       ),
    .cfg_extra_ctl_clk_pdn_period                       ( cfg_extra_ctl_clk_pdn_period                       ),
    .cfg_enable_dqs_tracking                            ( cfg_enable_dqs_tracking                            ),
    .ecc_interrupt                                      ( ecc_interrupt                                      ),
    .sts_sbe_error                                      ( sts_sbe_error                                      ),
    .sts_dbe_error                                      ( sts_dbe_error                                      ),
    .sts_sbe_count                                      ( sts_sbe_count                                      ),
    .sts_dbe_count                                      ( sts_dbe_count                                      ),
    .sts_err_addr                                       ( sts_err_addr                                       ),
    .sts_corr_dropped                                   ( sts_corr_dropped                                   ),
    .sts_corr_dropped_count                             ( sts_corr_dropped_count                             ),
    .sts_corr_dropped_addr                              ( sts_corr_dropped_addr                              ),

    .afi_ctl_refresh_done                               ( afi_ctl_refresh_done                               ),
    .afi_seq_busy                                       ( afi_seq_busy                                       ),
    .afi_ctl_long_idle                                  ( afi_ctl_long_idle                                  )
);

endmodule
