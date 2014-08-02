//////////////////////////////////////////////////////////////////////////////
// This module is a wrapper for the soft IP NextGen controller and the MMR
// This file is only used for the ALTMEMPHY flow
//////////////////////////////////////////////////////////////////////////////

//altera message_off 10230

`include "alt_mem_ddrx_define.iv"


//
module ddr3_int_alt_mem_ddrx_controller_top(
    clk,
    half_clk,
    reset_n,
    local_ready,
    local_write,
    local_read,
    local_address,
    local_byteenable,
    local_writedata,
    local_burstcount,
    local_beginbursttransfer,
    local_readdata,
    local_readdatavalid,
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
    afi_mem_clk_disable,
    afi_cal_byte_lane_sel_n,
    afi_ctl_refresh_done,
    afi_seq_busy,
    afi_ctl_long_idle,
    local_init_done,
    local_refresh_ack,
    local_powerdn_ack,
    local_self_rfsh_ack,
    local_autopch_req,
    local_refresh_req,
    local_refresh_chip,
    local_powerdn_req,
    local_self_rfsh_req,
    local_self_rfsh_chip,
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
// << START MEGAWIZARD INSERT GENERICS
// Inserted Generics
   localparam MEM_TYPE                       = "DDR3";
   localparam LOCAL_SIZE_WIDTH               = 5;
   localparam LOCAL_ADDR_WIDTH               = 24;
   localparam LOCAL_DATA_WIDTH               = 256;
   localparam LOCAL_BE_WIDTH                 = 32;
   localparam LOCAL_IF_TYPE                  = "AVALON";
   localparam MEM_IF_CS_WIDTH                = 1;
   localparam MEM_IF_CKE_WIDTH               = 1;
   localparam MEM_IF_ODT_WIDTH               = 1;
   localparam MEM_IF_ADDR_WIDTH              = 13;
   localparam MEM_IF_ROW_WIDTH               = 13;
   localparam MEM_IF_COL_WIDTH               = 10;
   localparam MEM_IF_BA_WIDTH                = 3;
   localparam MEM_IF_DQS_WIDTH               = 8;
   localparam MEM_IF_DQ_WIDTH                = 64;
   localparam MEM_IF_DM_WIDTH                = 8;
   localparam MEM_IF_CLK_PAIR_COUNT          = 1;
   localparam MEM_IF_CS_PER_DIMM             = 1;
   localparam DWIDTH_RATIO                   = 4;
   localparam CTL_LOOK_AHEAD_DEPTH           = 4;
   localparam CTL_CMD_QUEUE_DEPTH            = 8;
   localparam CTL_HRB_ENABLED                = 0;
   localparam CTL_ECC_ENABLED                = 0;
   localparam CTL_ECC_RMW_ENABLED            = 0;
   localparam CTL_ECC_CSR_ENABLED            = 0;
   localparam CTL_CSR_ENABLED                = 0;
   localparam CTL_ODT_ENABLED                = 1;
   localparam CSR_ADDR_WIDTH                 = 16;
   localparam CSR_DATA_WIDTH                 = 32;
   localparam CSR_BE_WIDTH                   = 4;
   localparam CTL_OUTPUT_REGD                = 0;
   localparam MEM_CAS_WR_LAT                 = 6;
   localparam MEM_ADD_LAT                    = 0;
   localparam MEM_TCL                        = 6;
   localparam MEM_TRRD                       = 2;
   localparam MEM_TFAW                       = 10;
   localparam MEM_TRFC                       = 37;
   localparam MEM_TREFI                      = 1299;
   localparam MEM_TRCD                       = 5;
   localparam MEM_TRP                        = 5;
   localparam MEM_TWR                        = 5;
   localparam MEM_TWTR                       = 4;
   localparam MEM_TRTP                       = 3;
   localparam MEM_TRAS                       = 12;
   localparam MEM_TRC                        = 17;
   localparam ADDR_ORDER                     = 0;
   localparam MEM_AUTO_PD_CYCLES             = 0;
   localparam MEM_IF_RD_TO_WR_TURNAROUND_OCT = 2;
   localparam MEM_IF_WR_TO_RD_TURNAROUND_OCT = 0;
   localparam CTL_RD_TO_PCH_EXTRA_CLK        = 0;
   localparam CTL_ECC_MULTIPLES_16_24_40_72  = 1;
   localparam CTL_USR_REFRESH                = 0;
   localparam CTL_REGDIMM_ENABLED            = 0;
   localparam MULTICAST_WR_EN                = 0;
   localparam LOW_LATENCY                    = 0;
   localparam CTL_DYNAMIC_BANK_ALLOCATION    = 0;
   localparam CTL_DYNAMIC_BANK_NUM           = 4;
   localparam ENABLE_BURST_MERGE             = 0;
   localparam LOCAL_ID_WIDTH                 = 8;
   localparam LOCAL_CS_WIDTH                 = 0;
   localparam CTL_TBP_NUM                    = 4;
   localparam WRBUFFER_ADDR_WIDTH            = 6;
   localparam RDBUFFER_ADDR_WIDTH            = 7;
   localparam MEM_IF_CHIP                    = 1;
   localparam MEM_IF_BANKADDR_WIDTH          = 3;
   localparam MEM_IF_DWIDTH                  = 64;
   localparam MAX_MEM_IF_CS_WIDTH            = 30;
   localparam MAX_MEM_IF_CHIP                = 4;
   localparam MAX_MEM_IF_BANKADDR_WIDTH      = 3;
   localparam MAX_MEM_IF_ROWADDR_WIDTH       = 16;
   localparam MAX_MEM_IF_COLADDR_WIDTH       = 12;
   localparam MAX_MEM_IF_ODT_WIDTH           = 1;
   localparam MAX_MEM_IF_DQS_WIDTH           = 5;
   localparam MAX_MEM_IF_DQ_WIDTH            = 40;
   localparam MAX_MEM_IF_MASK_WIDTH          = 5;
   localparam MAX_LOCAL_DATA_WIDTH           = 80;
   localparam CFG_TYPE                       = 'b010;
   localparam CFG_INTERFACE_WIDTH            = 64;
   localparam CFG_BURST_LENGTH               = 'b01000;
   localparam CFG_DEVICE_WIDTH               = 1;
   localparam CFG_REORDER_DATA               = 0;
   localparam CFG_DATA_REORDERING_TYPE       = "INTER_BANK";
   localparam CFG_STARVE_LIMIT               = 10;
   localparam CFG_ADDR_ORDER                 = 'b00;
   localparam CFG_TCCD                       = 2;
   localparam CFG_SELF_RFSH_EXIT_CYCLES      = 512;
   localparam CFG_PDN_EXIT_CYCLES            = 3;
   localparam CFG_POWER_SAVING_EXIT_CYCLES   = 5;
   localparam CFG_MEM_CLK_ENTRY_CYCLES       = 10;
   localparam CTL_ENABLE_BURST_INTERRUPT     = 0;
   localparam CTL_ENABLE_BURST_TERMINATE     = 0;
   localparam MEM_TMRD_CK                    = 6;
   localparam CFG_GEN_SBE                    = 0;
   localparam CFG_GEN_DBE                    = 0;
   localparam CFG_ENABLE_INTR                = 0;
   localparam CFG_MASK_SBE_INTR              = 0;
   localparam CFG_MASK_DBE_INTR              = 0;
   localparam CFG_MASK_CORRDROP_INTR         = 0;
   localparam CFG_CLR_INTR                   = 0;
   localparam CFG_WRITE_ODT_CHIP             = 'h1;
   localparam CFG_READ_ODT_CHIP              = 'h0;
   localparam CFG_PORT_WIDTH_WRITE_ODT_CHIP  = 1;
   localparam CFG_PORT_WIDTH_READ_ODT_CHIP   = 1;
   localparam CFG_ENABLE_NO_DM               = 0;
// << END MEGAWIZARD INSERT GENERICS
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
localparam CFG_EXTRA_CTL_CLK_RD_TO_WR                           = 0;
localparam CFG_EXTRA_CTL_CLK_RD_TO_WR_BC                        = 0;
localparam CFG_EXTRA_CTL_CLK_RD_TO_WR_DIFF_CHIP                 = 0;
localparam CFG_EXTRA_CTL_CLK_RD_TO_PCH                          = 0;
localparam CFG_EXTRA_CTL_CLK_RD_AP_TO_VALID                     = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_WR                           = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_WR_DIFF_CHIP                 = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_RD                           = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_RD_BC                        = 0;
localparam CFG_EXTRA_CTL_CLK_WR_TO_RD_DIFF_CHIP                 = 0;
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
localparam CFG_ENABLE_DQS_TRACKING                              = 0;
localparam CFG_OUTPUT_REGD                                      = CTL_OUTPUT_REGD;
localparam CFG_MASK_CORR_DROPPED_INTR                           = 0;
localparam CFG_USER_RFSH                                        = CTL_USR_REFRESH;
localparam CFG_REGDIMM_ENABLE                                   = CTL_REGDIMM_ENABLED;

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
localparam CFG_WLAT_BUS_WIDTH                                   = 5;
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

// KALEN HACK: We are supposed to use these parameters when the CSR is enabled
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
localparam AFI_RLAT_WIDTH                                       = 5;
localparam AFI_OTF_BITNUM                                       = 12;
localparam AFI_AUTO_PRECHARGE_BITNUM                            = 10;
localparam AFI_MEM_CLK_DISABLE_WIDTH                            = CFG_MEM_IF_CLK_PAIR_COUNT;


//////////////////////////////////////////////////////////////////////////////
// BEGIN PORT SECTION

// Clk and reset signals
input                                                                  clk;
input                                                                  half_clk;
input                                                                  reset_n;

// Avalon signals
output                                                                 local_ready;
input                                                                  local_write;
input                                                                  local_read;
input   [LOCAL_ADDR_WIDTH                              - 1 : 0]    local_address;
input   [LOCAL_BE_WIDTH                                - 1 : 0]    local_byteenable;
input   [LOCAL_DATA_WIDTH                              - 1 : 0]    local_writedata;
input   [LOCAL_SIZE_WIDTH                              - 1 : 0]    local_burstcount;
input                                                                  local_beginbursttransfer;
output  [LOCAL_DATA_WIDTH                              - 1 : 0]    local_readdata;
output                                                                 local_readdatavalid;

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
input                                                                  local_autopch_req;
input                                                                  local_refresh_req;
input   [CFG_MEM_IF_CHIP                                   - 1 : 0]    local_refresh_chip;
input                                                                  local_powerdn_req;
input                                                                  local_self_rfsh_req;
input   [CFG_MEM_IF_CHIP                                   - 1 : 0]    local_self_rfsh_chip;
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

wire                                                                   itf_cmd_ready;
wire                                                                   itf_cmd_valid;
wire                                                                   itf_cmd;
wire    [LOCAL_ADDR_WIDTH                              - 1 : 0]    itf_cmd_address;
wire    [LOCAL_SIZE_WIDTH                              - 1 : 0]    itf_cmd_burstlen;
wire                                                                   itf_cmd_id;
wire                                                                   itf_cmd_priority;
wire                                                                   itf_cmd_autopercharge;
wire                                                                   itf_cmd_multicast;
wire                                                                   itf_wr_data_ready;
wire                                                                   itf_wr_data_valid;
wire    [LOCAL_DATA_WIDTH                              - 1 : 0]    itf_wr_data;
wire    [LOCAL_BE_WIDTH                                - 1 : 0]    itf_wr_data_byte_en;
wire                                                                   itf_wr_data_begin;
wire                                                                   itf_wr_data_last;
wire    [CFG_LOCAL_ID_WIDTH                                - 1 : 0]    itf_wr_data_id;
wire                                                                   itf_rd_data_ready;
wire                                                                   itf_rd_data_valid;
wire    [LOCAL_DATA_WIDTH                              - 1 : 0]    itf_rd_data;
wire    [2                                                 - 1 : 0]    itf_rd_data_error;
wire                                                                   itf_rd_data_begin;
wire                                                                   itf_rd_data_last;
wire    [CFG_LOCAL_ID_WIDTH                                - 1 : 0]    itf_rd_data_id;

// Converter
alt_mem_ddrx_mm_st_converter # (
    .AVL_SIZE_WIDTH                                   ( LOCAL_SIZE_WIDTH                               ),
    .AVL_ADDR_WIDTH                                   ( LOCAL_ADDR_WIDTH                               ),
    .AVL_DATA_WIDTH                                   ( LOCAL_DATA_WIDTH                               )
) mm_st_converter_inst (
    .ctl_clk                                            ( clk                                                ),
    .ctl_reset_n                                        ( reset_n                                            ),
    .ctl_half_clk                                       ( half_clk                                           ),
    .ctl_half_clk_reset_n                               ( reset_n                                            ),
    .avl_ready                                          ( local_ready                                        ),
    .avl_read_req                                       ( local_read                                         ),
    .avl_write_req                                      ( local_write                                        ),
    .avl_size                                           ( local_burstcount                                   ),
    .avl_burstbegin                                     ( local_beginbursttransfer                           ),
    .avl_addr                                           ( local_address                                      ),
    .avl_rdata_valid                                    ( local_readdatavalid                                ),
    .local_rdata_error                                  (                                                    ),
    .avl_rdata                                          ( local_readdata                                     ),
    .avl_wdata                                          ( local_writedata                                    ),
    .avl_be                                             ( local_byteenable                                   ),
    .local_multicast                                    ( local_multicast                                    ),
    .local_autopch_req                                  ( local_autopch_req                                  ),
    .local_priority                                     ( local_priority                                     ),

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
    .itf_rd_data_id                                     ( itf_rd_data_id                                     )
);


// Next Gen Controller
//////////////////////////////////////////////////////////////////////////////

alt_mem_ddrx_controller_st_top #(
	.LOCAL_SIZE_WIDTH(LOCAL_SIZE_WIDTH),
	.LOCAL_ADDR_WIDTH(LOCAL_ADDR_WIDTH),
	.LOCAL_DATA_WIDTH(LOCAL_DATA_WIDTH),
	.LOCAL_BE_WIDTH(LOCAL_BE_WIDTH),
	.LOCAL_ID_WIDTH(LOCAL_ID_WIDTH),
	.LOCAL_CS_WIDTH(LOCAL_CS_WIDTH),
	.MEM_IF_ADDR_WIDTH(MEM_IF_ADDR_WIDTH),
	.MEM_IF_CLK_PAIR_COUNT(MEM_IF_CLK_PAIR_COUNT),
	.LOCAL_IF_TYPE(LOCAL_IF_TYPE),
	.DWIDTH_RATIO(DWIDTH_RATIO),
	.CTL_ODT_ENABLED(CTL_ODT_ENABLED),
	.CTL_OUTPUT_REGD(CTL_OUTPUT_REGD),
	.CTL_TBP_NUM(CTL_TBP_NUM),
	.WRBUFFER_ADDR_WIDTH(WRBUFFER_ADDR_WIDTH),
	.RDBUFFER_ADDR_WIDTH(RDBUFFER_ADDR_WIDTH),
	.MEM_IF_CS_WIDTH(MEM_IF_CS_WIDTH),
	.MEM_IF_CHIP(MEM_IF_CHIP),
	.MEM_IF_BANKADDR_WIDTH(MEM_IF_BANKADDR_WIDTH),
	.MEM_IF_ROW_WIDTH(MEM_IF_ROW_WIDTH),
	.MEM_IF_COL_WIDTH(MEM_IF_COL_WIDTH),
	.MEM_IF_ODT_WIDTH(MEM_IF_ODT_WIDTH),
	.MEM_IF_DQS_WIDTH(MEM_IF_DQS_WIDTH),
	.MEM_IF_DWIDTH(MEM_IF_DWIDTH),
	.MEM_IF_DM_WIDTH(MEM_IF_DM_WIDTH),
	.MAX_MEM_IF_CS_WIDTH(MAX_MEM_IF_CS_WIDTH),
	.MAX_MEM_IF_CHIP(MAX_MEM_IF_CHIP),
	.MAX_MEM_IF_BANKADDR_WIDTH(MAX_MEM_IF_BANKADDR_WIDTH),
	.MAX_MEM_IF_ROWADDR_WIDTH(MAX_MEM_IF_ROWADDR_WIDTH),
	.MAX_MEM_IF_COLADDR_WIDTH(MAX_MEM_IF_COLADDR_WIDTH),
	.MAX_MEM_IF_ODT_WIDTH(MAX_MEM_IF_ODT_WIDTH),
	.MAX_MEM_IF_DQS_WIDTH(MAX_MEM_IF_DQS_WIDTH),
	.MAX_MEM_IF_DQ_WIDTH(MAX_MEM_IF_DQ_WIDTH),
	.MAX_MEM_IF_MASK_WIDTH(MAX_MEM_IF_MASK_WIDTH),
	.MAX_LOCAL_DATA_WIDTH(MAX_LOCAL_DATA_WIDTH),
	.CFG_TYPE(CFG_TYPE),
	.CFG_INTERFACE_WIDTH(CFG_INTERFACE_WIDTH),
	.CFG_BURST_LENGTH(CFG_BURST_LENGTH),
	.CFG_DEVICE_WIDTH(CFG_DEVICE_WIDTH),
	.CFG_REORDER_DATA(CFG_REORDER_DATA),
	.CFG_DATA_REORDERING_TYPE(CFG_DATA_REORDERING_TYPE),
	.CFG_STARVE_LIMIT(CFG_STARVE_LIMIT),
	.CFG_ADDR_ORDER(CFG_ADDR_ORDER),
	.MEM_CAS_WR_LAT(MEM_CAS_WR_LAT),
	.MEM_ADD_LAT(MEM_ADD_LAT),
	.MEM_TCL(MEM_TCL),
	.MEM_TRRD(MEM_TRRD),
	.MEM_TFAW(MEM_TFAW),
	.MEM_TRFC(MEM_TRFC),
	.MEM_TREFI(MEM_TREFI),
	.MEM_TRCD(MEM_TRCD),
	.MEM_TRP(MEM_TRP),
	.MEM_TWR(MEM_TWR),
	.MEM_TWTR(MEM_TWTR),
	.MEM_TRTP(MEM_TRTP),
	.MEM_TRAS(MEM_TRAS),
	.MEM_TRC(MEM_TRC),
	.CFG_TCCD(CFG_TCCD),
	.MEM_AUTO_PD_CYCLES(MEM_AUTO_PD_CYCLES),
	.CFG_SELF_RFSH_EXIT_CYCLES(CFG_SELF_RFSH_EXIT_CYCLES),
	.CFG_PDN_EXIT_CYCLES(CFG_PDN_EXIT_CYCLES),
	.CFG_POWER_SAVING_EXIT_CYCLES(CFG_POWER_SAVING_EXIT_CYCLES),
	.CFG_MEM_CLK_ENTRY_CYCLES(CFG_MEM_CLK_ENTRY_CYCLES),
	.MEM_TMRD_CK(MEM_TMRD_CK),
	.CTL_ECC_ENABLED(CTL_ECC_ENABLED),
	.CTL_ECC_RMW_ENABLED(CTL_ECC_RMW_ENABLED),
	.CTL_ECC_MULTIPLES_16_24_40_72(CTL_ECC_MULTIPLES_16_24_40_72),
	.CFG_GEN_SBE(CFG_GEN_SBE),
	.CFG_GEN_DBE(CFG_GEN_DBE),
	.CFG_ENABLE_INTR(CFG_ENABLE_INTR),
	.CFG_MASK_SBE_INTR(CFG_MASK_SBE_INTR),
	.CFG_MASK_DBE_INTR(CFG_MASK_DBE_INTR),
	.CFG_MASK_CORRDROP_INTR(CFG_MASK_CORRDROP_INTR),
	.CFG_CLR_INTR(CFG_CLR_INTR),
	.CTL_USR_REFRESH(CTL_USR_REFRESH),
	.CTL_REGDIMM_ENABLED(CTL_REGDIMM_ENABLED),
	.CFG_WRITE_ODT_CHIP(CFG_WRITE_ODT_CHIP),
	.CFG_READ_ODT_CHIP(CFG_READ_ODT_CHIP),
	.CFG_PORT_WIDTH_WRITE_ODT_CHIP(CFG_PORT_WIDTH_WRITE_ODT_CHIP),
	.CFG_PORT_WIDTH_READ_ODT_CHIP(CFG_PORT_WIDTH_READ_ODT_CHIP),
	.MEM_IF_CKE_WIDTH(MEM_IF_CKE_WIDTH),
	.CTL_CSR_ENABLED(CTL_CSR_ENABLED),
	.CFG_ENABLE_NO_DM(CFG_ENABLE_NO_DM),
	.CSR_ADDR_WIDTH(CSR_ADDR_WIDTH),
	.CSR_DATA_WIDTH(CSR_DATA_WIDTH),
	.CSR_BE_WIDTH(CSR_BE_WIDTH),
	.CFG_WLAT_BUS_WIDTH(AFI_WLAT_WIDTH),
	.CFG_RLAT_BUS_WIDTH(AFI_RLAT_WIDTH),
	.MEM_IF_RD_TO_WR_TURNAROUND_OCT(MEM_IF_RD_TO_WR_TURNAROUND_OCT),
	.MEM_IF_WR_TO_RD_TURNAROUND_OCT(MEM_IF_WR_TO_RD_TURNAROUND_OCT),
	.CTL_RD_TO_PCH_EXTRA_CLK(CTL_RD_TO_PCH_EXTRA_CLK)
) controller_inst (
	.clk(clk),
	.half_clk(half_clk),
	.reset_n(reset_n),
	.itf_cmd_ready(itf_cmd_ready),
	.itf_cmd_valid(itf_cmd_valid),
	.itf_cmd(itf_cmd),
	.itf_cmd_address(itf_cmd_address),
	.itf_cmd_burstlen(itf_cmd_burstlen),
	.itf_cmd_id(itf_cmd_id),
	.itf_cmd_priority(itf_cmd_priority),
	.itf_cmd_autopercharge(itf_cmd_autopercharge),
	.itf_cmd_multicast(itf_cmd_multicast),
	.itf_wr_data_ready(itf_wr_data_ready),
	.itf_wr_data_valid(itf_wr_data_valid),
	.itf_wr_data(itf_wr_data),
	.itf_wr_data_byte_en(itf_wr_data_byte_en),
	.itf_wr_data_begin(itf_wr_data_begin),
	.itf_wr_data_last(itf_wr_data_last),
	.itf_wr_data_id(itf_wr_data_id),
	.itf_rd_data_ready(itf_rd_data_ready),
	.itf_rd_data_valid(itf_rd_data_valid),
	.itf_rd_data(itf_rd_data),
	.itf_rd_data_error(itf_rd_data_error),
	.itf_rd_data_begin(itf_rd_data_begin),
	.itf_rd_data_last(itf_rd_data_last),
	.itf_rd_data_id(itf_rd_data_id),
	.afi_rst_n(afi_rst_n),
	.afi_cs_n(afi_cs_n),
	.afi_cke(afi_cke),
	.afi_odt(afi_odt),
	.afi_addr(afi_addr),
	.afi_ba(afi_ba),
	.afi_ras_n(afi_ras_n),
	.afi_cas_n(afi_cas_n),
	.afi_we_n(afi_we_n),
	.afi_dqs_burst(afi_dqs_burst),
	.afi_wdata_valid(afi_wdata_valid),
	.afi_wdata(afi_wdata),
	.afi_dm(afi_dm),
	.afi_wlat(afi_wlat),
	.afi_rdata_en(afi_rdata_en),
	.afi_rdata_en_full(afi_rdata_en_full),
	.afi_rdata(afi_rdata),
	.afi_rdata_valid(afi_rdata_valid),
	.afi_rlat(afi_rlat),
	.afi_cal_success(afi_cal_success),
	.afi_cal_fail(afi_cal_fail),
	.afi_cal_req(afi_cal_req),
	.afi_mem_clk_disable(afi_mem_clk_disable),
	.afi_cal_byte_lane_sel_n(afi_cal_byte_lane_sel_n),
	.afi_ctl_refresh_done(afi_ctl_refresh_done),
	.afi_seq_busy(afi_seq_busy),
	.afi_ctl_long_idle(afi_ctl_long_idle),
	.local_init_done(local_init_done),
	.local_refresh_ack(local_refresh_ack),
	.local_powerdn_ack(local_powerdn_ack),
	.local_self_rfsh_ack(local_self_rfsh_ack),
	.local_refresh_req(local_refresh_req),
	.local_refresh_chip(local_refresh_chip),
	.local_powerdn_req(local_powerdn_req),
	.local_self_rfsh_req(local_self_rfsh_req),
	.local_self_rfsh_chip(local_self_rfsh_chip),
	.local_multicast(local_multicast),
	.local_priority(local_priority),
	.ecc_interrupt(ecc_interrupt),
	.csr_read_req(csr_read_req),
	.csr_write_req(csr_write_req),
	.csr_burst_count(csr_burst_count),
	.csr_beginbursttransfer(csr_beginbursttransfer),
	.csr_addr(csr_addr),
	.csr_wdata(csr_wdata),
	.csr_rdata(csr_rdata),
	.csr_be(csr_be),
	.csr_rdata_valid(csr_rdata_valid),
	.csr_waitrequest(csr_waitrequest)
);



endmodule
