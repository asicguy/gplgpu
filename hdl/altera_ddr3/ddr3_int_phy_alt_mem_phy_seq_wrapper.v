//

`ifdef ALT_MEM_PHY_DEFINES
`else
`include "alt_mem_phy_defines.v"
`endif

//
module ddr3_int_phy_alt_mem_phy_seq_wrapper (

// dss ports
                    phy_clk_1x,
                    reset_phy_clk_1x_n,
                    ctl_cal_success,
                    ctl_cal_fail,
                    ctl_cal_warning,
                    ctl_cal_req,
                    int_RANK_HAS_ADDR_SWAP,
                    ctl_cal_byte_lane_sel_n,
                    seq_pll_inc_dec_n,
                    seq_pll_start_reconfig,
                    seq_pll_select,
                    phs_shft_busy,
                    pll_resync_clk_index,
                    pll_measure_clk_index,
                    sc_clk_dp,
                    scan_enable_dqs_config,
                    scan_update,
                    scan_din,
                    scan_enable_ck,
                    scan_enable_dqs,
                    scan_enable_dqsn,
                    scan_enable_dq,
                    scan_enable_dm,
                    hr_rsc_clk,
                    seq_ac_addr,
                    seq_ac_ba,
                    seq_ac_cas_n,
                    seq_ac_ras_n,
                    seq_ac_we_n,
                    seq_ac_cke,
                    seq_ac_cs_n,
                    seq_ac_odt,
                    seq_ac_rst_n,
                    seq_ac_sel,
                    seq_mem_clk_disable,
                    ctl_add_1t_ac_lat_internal,
                    ctl_add_1t_odt_lat_internal,
                    ctl_add_intermediate_regs_internal,
                    seq_rdv_doing_rd,
                    seq_rdp_reset_req_n,
                    seq_rdp_inc_read_lat_1x,
                    seq_rdp_dec_read_lat_1x,
                    ctl_rdata,
                    int_rdata_valid_1t,
                    seq_rdata_valid_lat_inc,
                    seq_rdata_valid_lat_dec,
                    ctl_rlat,
                    seq_poa_lat_dec_1x,
                    seq_poa_lat_inc_1x,
                    seq_poa_protection_override_1x,
                    seq_oct_oct_delay,
                    seq_oct_oct_extend,
                    seq_oct_val,
                    seq_wdp_dqs_burst,
                    seq_wdp_wdata_valid,
                    seq_wdp_wdata,
                    seq_wdp_dm,
                    seq_wdp_dqs,
                    seq_wdp_ovride,
                    seq_dqs_add_2t_delay,
                    ctl_wlat,
                    seq_mmc_start,
                    mmc_seq_done,
                    mmc_seq_value,
                    mem_err_out_n,
                    parity_error_n,
                    dbg_clk,
                    dbg_reset_n,
                    dbg_addr,
                    dbg_wr,
                    dbg_rd,
                    dbg_cs,
                    dbg_wr_data,
                    dbg_rd_data,
                    dbg_waitrequest
                                );


//Inserted Generics
  localparam SPEED_GRADE                   = "C3";
  localparam MEM_IF_DQS_WIDTH              = 4;
  localparam MEM_IF_DWIDTH                 = 32;
  localparam MEM_IF_DM_WIDTH               = 4;
  localparam MEM_IF_DQ_PER_DQS             = 8;
  localparam DWIDTH_RATIO                  = 4;
  localparam CLOCK_INDEX_WIDTH             = 3;
  localparam MEM_IF_CLK_PAIR_COUNT         = 1;
  localparam MEM_IF_ADDR_WIDTH             = 14;
  localparam MEM_IF_BANKADDR_WIDTH         = 3;
  localparam MEM_IF_CS_WIDTH               = 1;
  localparam RESYNCHRONISE_AVALON_DBG      = 0;
  localparam DBG_A_WIDTH                   = 13;
  localparam DQS_PHASE_SETTING             = 2;
  localparam SCAN_CLK_DIVIDE_BY            = 2;
  localparam PLL_STEPS_PER_CYCLE           = 32;
  localparam MEM_IF_CLK_PS                 = 3333;
  localparam DQS_DELAY_CTL_WIDTH           = 6;
  localparam MEM_IF_MEMTYPE                = "DDR3";
  localparam RANK_HAS_ADDR_SWAP            = 0;
  localparam MEM_IF_MR_0                   = 4641;
  localparam MEM_IF_MR_1                   = 2;
  localparam MEM_IF_MR_2                   = 0;
  localparam MEM_IF_MR_3                   = 0;
  localparam MEM_IF_OCT_EN                 = 0;
  localparam IP_BUILDNUM                   = 0;
  localparam FAMILY                        = "Arria II GX";
  localparam FAMILYGROUP_ID                = 4;
  localparam MEM_IF_ADDR_CMD_PHASE         = 90;
  localparam CAPABILITIES                  = 0;
  localparam WRITE_DESKEW_T10              = 6;
  localparam WRITE_DESKEW_HC_T10           = 6;
  localparam WRITE_DESKEW_T9NI             = 6;
  localparam WRITE_DESKEW_HC_T9NI          = 6;
  localparam WRITE_DESKEW_T9I              = 0;
  localparam WRITE_DESKEW_HC_T9I           = 0;
  localparam WRITE_DESKEW_RANGE            = 0;
  localparam IOE_PHASES_PER_TCK            = 10;
  localparam ADV_LAT_WIDTH                 = 5;
  localparam RDP_ADDR_WIDTH                = 4;
  localparam IOE_DELAYS_PER_PHS            = 5;
  localparam SINGLE_DQS_DELAY_CONTROL_CODE = 0;
  localparam PRESET_RLAT                   = 0;
  localparam FORCE_HC                      = 0;
  localparam MEM_IF_DQS_CAPTURE_EN         = 1;
  localparam REDUCE_SIM_TIME               = 0;
  localparam TINIT_TCK                     = 75008;
  localparam TINIT_RST                     = 30004;
  localparam GENERATE_ADDITIONAL_DBG_RTL   = 0;
  localparam MEM_IF_CS_PER_RANK            = 1;
  localparam MEM_IF_RANKS_PER_SLOT         = 1;
  localparam CHIP_OR_DIMM                  = "Discrete Device";
  localparam RDIMM_CONFIG_BITS             = "0000000000000000000000000000000000000000000000000000000000000000";

localparam OCT_LAT_WIDTH                     = ADV_LAT_WIDTH;
localparam GENERATE_TRACKING_PHASE_STORE     = 0;

// note that num_ranks if the number of discrete chip select signals output from the sequencer
// cs_width is the total number of chip selects which go from the phy to the memory (there can
// be more than one chip select per rank).
localparam MEM_IF_NUM_RANKS                  = MEM_IF_CS_WIDTH/MEM_IF_CS_PER_RANK;


input  wire                                                      phy_clk_1x;
input  wire                                                      reset_phy_clk_1x_n;
output wire                                                      ctl_cal_success;
output wire                                                      ctl_cal_fail;
output wire                                                      ctl_cal_warning;
input  wire                                                      ctl_cal_req;
input  wire [MEM_IF_NUM_RANKS                         - 1 : 0]   int_RANK_HAS_ADDR_SWAP;
input  wire [MEM_IF_NUM_RANKS * MEM_IF_DQS_WIDTH      - 1 : 0]   ctl_cal_byte_lane_sel_n;
output wire                                                      seq_pll_inc_dec_n;
output wire                                                      seq_pll_start_reconfig;
output wire [CLOCK_INDEX_WIDTH                        - 1 : 0]   seq_pll_select;
input  wire                                                      phs_shft_busy;
input  wire [CLOCK_INDEX_WIDTH                        - 1 : 0]   pll_resync_clk_index;
input  wire [CLOCK_INDEX_WIDTH                        - 1 : 0]   pll_measure_clk_index;
output      [MEM_IF_DQS_WIDTH                         - 1 : 0]   sc_clk_dp;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   scan_enable_dqs_config;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   scan_update;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   scan_din;
output wire [MEM_IF_CLK_PAIR_COUNT                    - 1 : 0]   scan_enable_ck;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   scan_enable_dqs;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   scan_enable_dqsn;
output wire [MEM_IF_DWIDTH                            - 1 : 0]   scan_enable_dq;
output wire [MEM_IF_DM_WIDTH                          - 1 : 0]   scan_enable_dm;
input  wire                                                      hr_rsc_clk;
output wire [(DWIDTH_RATIO/2) * MEM_IF_ADDR_WIDTH     - 1 : 0]   seq_ac_addr;
output wire [(DWIDTH_RATIO/2) * MEM_IF_BANKADDR_WIDTH - 1 : 0]   seq_ac_ba;
output wire [(DWIDTH_RATIO/2)                         - 1 : 0]   seq_ac_cas_n;
output wire [(DWIDTH_RATIO/2)                         - 1 : 0]   seq_ac_ras_n;
output wire [(DWIDTH_RATIO/2)                         - 1 : 0]   seq_ac_we_n;
output wire [(DWIDTH_RATIO/2) * MEM_IF_NUM_RANKS      - 1 : 0]   seq_ac_cke;
output wire [(DWIDTH_RATIO/2) * MEM_IF_CS_WIDTH       - 1 : 0]   seq_ac_cs_n;
output wire [(DWIDTH_RATIO/2) * MEM_IF_NUM_RANKS      - 1 : 0]   seq_ac_odt;
output wire [(DWIDTH_RATIO/2)                         - 1 : 0]   seq_ac_rst_n;
output wire                                                      seq_ac_sel;
output wire                                                      seq_mem_clk_disable;

output wire                                                      ctl_add_1t_ac_lat_internal;
output wire                                                      ctl_add_1t_odt_lat_internal;
output wire                                                      ctl_add_intermediate_regs_internal;
output wire [MEM_IF_DQS_WIDTH * DWIDTH_RATIO/2        - 1 : 0]   seq_rdv_doing_rd;
output wire                                                      seq_rdp_reset_req_n;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   seq_rdp_inc_read_lat_1x;
output wire [MEM_IF_DQS_WIDTH                         - 1 : 0]   seq_rdp_dec_read_lat_1x;
input  wire [DWIDTH_RATIO     * MEM_IF_DWIDTH         - 1 : 0]   ctl_rdata;
input  wire [DWIDTH_RATIO/2                           - 1 : 0]   int_rdata_valid_1t;
output wire                                                      seq_rdata_valid_lat_inc;
output wire                                                      seq_rdata_valid_lat_dec;
output wire [ADV_LAT_WIDTH                    - 1 : 0]           ctl_rlat;
output wire [MEM_IF_DQS_WIDTH                 - 1 : 0]           seq_poa_lat_dec_1x;
output wire [MEM_IF_DQS_WIDTH                 - 1 : 0]           seq_poa_lat_inc_1x;
output wire                                                      seq_poa_protection_override_1x;
output wire [OCT_LAT_WIDTH                            - 1 : 0]   seq_oct_oct_delay;
output wire [OCT_LAT_WIDTH                            - 1 : 0]   seq_oct_oct_extend;
output wire                                                      seq_oct_val;
output wire [(DWIDTH_RATIO/2) * MEM_IF_DQS_WIDTH      - 1 : 0]   seq_wdp_dqs_burst;
output wire [(DWIDTH_RATIO/2) * MEM_IF_DQS_WIDTH      - 1 : 0]   seq_wdp_wdata_valid;
output wire [DWIDTH_RATIO     * MEM_IF_DWIDTH         - 1 : 0]   seq_wdp_wdata;
output wire [DWIDTH_RATIO     * MEM_IF_DM_WIDTH       - 1 : 0]   seq_wdp_dm;
output wire [DWIDTH_RATIO                             - 1 : 0]   seq_wdp_dqs;
output wire                                                      seq_wdp_ovride;
output wire [MEM_IF_DQS_WIDTH      - 1 : 0]                      seq_dqs_add_2t_delay;
output wire [ADV_LAT_WIDTH                            - 1 : 0]   ctl_wlat;
output wire                                                      seq_mmc_start;
input  wire                                                      mmc_seq_done;
input  wire                                                      mmc_seq_value;
input  wire                                                      dbg_clk;
input  wire                                                      dbg_reset_n;
input  wire [DBG_A_WIDTH                         - 1 : 0]   dbg_addr;
input  wire                                                      dbg_wr;
input  wire                                                      dbg_rd;
input  wire                                                      dbg_cs;
input  wire [                          31 : 0]                   dbg_wr_data;
output wire [                          31 : 0]                   dbg_rd_data;
output wire                                                      dbg_waitrequest;
input wire                                                       mem_err_out_n;
output wire                                                      parity_error_n;

(* altera_attribute = "-name global_signal off" *) wire [MEM_IF_DQS_WIDTH - 1 : 0] sc_clk_dp;

// instantiate the deskew (DDR3) or non-deskew (DDR/DDR2/DDR3) sequencer:
//
   ddr3_int_phy_alt_mem_phy_seq #(
        .MEM_IF_DQS_WIDTH               (MEM_IF_DQS_WIDTH),
        .MEM_IF_DWIDTH                  (MEM_IF_DWIDTH),
        .MEM_IF_DM_WIDTH                (MEM_IF_DM_WIDTH),
        .MEM_IF_DQ_PER_DQS              (MEM_IF_DQ_PER_DQS),
        .DWIDTH_RATIO                   (DWIDTH_RATIO),
        .CLOCK_INDEX_WIDTH              (CLOCK_INDEX_WIDTH),
        .MEM_IF_CLK_PAIR_COUNT          (MEM_IF_CLK_PAIR_COUNT),
        .MEM_IF_ADDR_WIDTH              (MEM_IF_ADDR_WIDTH),
        .MEM_IF_BANKADDR_WIDTH          (MEM_IF_BANKADDR_WIDTH),
        .MEM_IF_CS_WIDTH                (MEM_IF_CS_WIDTH),
        .MEM_IF_NUM_RANKS               (MEM_IF_NUM_RANKS),
        .MEM_IF_RANKS_PER_SLOT          (MEM_IF_RANKS_PER_SLOT),
        .ADV_LAT_WIDTH                  (ADV_LAT_WIDTH),
        .RESYNCHRONISE_AVALON_DBG       (RESYNCHRONISE_AVALON_DBG),
        .AV_IF_ADDR_WIDTH               (DBG_A_WIDTH),
        .NOM_DQS_PHASE_SETTING          (DQS_PHASE_SETTING),
        .SCAN_CLK_DIVIDE_BY             (SCAN_CLK_DIVIDE_BY),
        .RDP_ADDR_WIDTH                 (RDP_ADDR_WIDTH),
        .PLL_STEPS_PER_CYCLE            (PLL_STEPS_PER_CYCLE),
        .IOE_PHASES_PER_TCK             (IOE_PHASES_PER_TCK),
        .IOE_DELAYS_PER_PHS             (IOE_DELAYS_PER_PHS),
        .MEM_IF_CLK_PS                  (MEM_IF_CLK_PS),
        .PHY_DEF_MR_1ST                 (MEM_IF_MR_0),
        .PHY_DEF_MR_2ND                 (MEM_IF_MR_1),
        .PHY_DEF_MR_3RD                 (MEM_IF_MR_2),
        .PHY_DEF_MR_4TH                 (MEM_IF_MR_3),
        .MEM_IF_DQSN_EN                 (0),
        .MEM_IF_DQS_CAPTURE_EN          (MEM_IF_DQS_CAPTURE_EN),
        .FAMILY                         (FAMILY),
        .FAMILYGROUP_ID                 (FAMILYGROUP_ID),
        .SPEED_GRADE                    (SPEED_GRADE),
        .MEM_IF_MEMTYPE                 (MEM_IF_MEMTYPE),
        .WRITE_DESKEW_T10               (WRITE_DESKEW_T10),
        .WRITE_DESKEW_HC_T10            (WRITE_DESKEW_HC_T10),
        .WRITE_DESKEW_T9NI              (WRITE_DESKEW_T9NI),
        .WRITE_DESKEW_HC_T9NI           (WRITE_DESKEW_HC_T9NI),
        .WRITE_DESKEW_T9I               (WRITE_DESKEW_T9I),
        .WRITE_DESKEW_HC_T9I            (WRITE_DESKEW_HC_T9I),
        .WRITE_DESKEW_RANGE             (WRITE_DESKEW_RANGE),
        .SINGLE_DQS_DELAY_CONTROL_CODE  (SINGLE_DQS_DELAY_CONTROL_CODE),
        .PRESET_RLAT                    (PRESET_RLAT),
        .EN_OCT                         (MEM_IF_OCT_EN),
        .SIM_TIME_REDUCTIONS            (REDUCE_SIM_TIME),
        .FORCE_HC                       (FORCE_HC),
        .CAPABILITIES                   (CAPABILITIES),
        .GENERATE_ADDITIONAL_DBG_RTL    (GENERATE_ADDITIONAL_DBG_RTL),
        .TINIT_TCK                      (TINIT_TCK),
        .TINIT_RST                      (TINIT_RST),
        .GENERATE_TRACKING_PHASE_STORE  (0),
        .OCT_LAT_WIDTH                  (OCT_LAT_WIDTH),
        .IP_BUILDNUM                    (IP_BUILDNUM),
        .CHIP_OR_DIMM                   (CHIP_OR_DIMM),
        .RDIMM_CONFIG_BITS              (RDIMM_CONFIG_BITS)
) seq_inst (
        .clk                            (phy_clk_1x),
        .rst_n                          (reset_phy_clk_1x_n),
        .ctl_init_success               (ctl_cal_success),
        .ctl_init_fail                  (ctl_cal_fail),
        .ctl_init_warning               (ctl_cal_warning),
        .ctl_recalibrate_req            (ctl_cal_req),
        .MEM_AC_SWAPPED_RANKS           (int_RANK_HAS_ADDR_SWAP),
        .ctl_cal_byte_lanes             (ctl_cal_byte_lane_sel_n),
        .seq_pll_inc_dec_n              (seq_pll_inc_dec_n),
        .seq_pll_start_reconfig         (seq_pll_start_reconfig),
        .seq_pll_select                 (seq_pll_select),
        .seq_pll_phs_shift_busy         (phs_shft_busy),
        .pll_resync_clk_index           (pll_resync_clk_index),
        .pll_measure_clk_index          (pll_measure_clk_index),
        .seq_scan_clk                   (sc_clk_dp),
        .seq_scan_enable_dqs_config     (scan_enable_dqs_config),
        .seq_scan_update                (scan_update),
        .seq_scan_din                   (scan_din),
        .seq_scan_enable_ck             (scan_enable_ck),
        .seq_scan_enable_dqs            (scan_enable_dqs),
        .seq_scan_enable_dqsn           (scan_enable_dqsn),
        .seq_scan_enable_dq             (scan_enable_dq),
        .seq_scan_enable_dm             (scan_enable_dm),
        .hr_rsc_clk                     (hr_rsc_clk),
        .seq_ac_addr                    (seq_ac_addr),
        .seq_ac_ba                      (seq_ac_ba),
        .seq_ac_cas_n                   (seq_ac_cas_n),
        .seq_ac_ras_n                   (seq_ac_ras_n),
        .seq_ac_we_n                    (seq_ac_we_n),
        .seq_ac_cke                     (seq_ac_cke),
        .seq_ac_cs_n                    (seq_ac_cs_n),
        .seq_ac_odt                     (seq_ac_odt),
        .seq_ac_rst_n                   (seq_ac_rst_n),
        .seq_ac_sel                     (seq_ac_sel),
        .seq_mem_clk_disable            (seq_mem_clk_disable),
        .seq_ac_add_1t_ac_lat_internal  (ctl_add_1t_ac_lat_internal),
        .seq_ac_add_1t_odt_lat_internal (ctl_add_1t_odt_lat_internal),
        .seq_ac_add_2t                  (ctl_add_intermediate_regs_internal),
        .seq_rdv_doing_rd               (seq_rdv_doing_rd),
        .seq_rdp_reset_req_n            (seq_rdp_reset_req_n),
        .seq_rdp_inc_read_lat_1x        (seq_rdp_inc_read_lat_1x),
        .seq_rdp_dec_read_lat_1x        (seq_rdp_dec_read_lat_1x),
        .rdata                          (ctl_rdata),
        .rdata_valid                    (int_rdata_valid_1t),
        .seq_rdata_valid_lat_inc        (seq_rdata_valid_lat_inc),
        .seq_rdata_valid_lat_dec        (seq_rdata_valid_lat_dec),
        .seq_ctl_rlat                   (ctl_rlat),
        .seq_poa_lat_dec_1x             (seq_poa_lat_dec_1x),
        .seq_poa_lat_inc_1x             (seq_poa_lat_inc_1x),
        .seq_poa_protection_override_1x (seq_poa_protection_override_1x),
        .seq_oct_oct_delay              (seq_oct_oct_delay),
        .seq_oct_oct_extend             (seq_oct_oct_extend),
        .seq_oct_value                  (seq_oct_val),
        .seq_wdp_dqs_burst              (seq_wdp_dqs_burst),
        .seq_wdp_wdata_valid            (seq_wdp_wdata_valid),
        .seq_wdp_wdata                  (seq_wdp_wdata),
        .seq_wdp_dm                     (seq_wdp_dm),
        .seq_wdp_dqs                    (seq_wdp_dqs),
        .seq_wdp_ovride                 (seq_wdp_ovride),
        .seq_dqs_add_2t_delay           (seq_dqs_add_2t_delay),
        .seq_ctl_wlat                   (ctl_wlat),
        .seq_mmc_start                  (seq_mmc_start),
        .mmc_seq_done                   (mmc_seq_done),
        .mmc_seq_value                  (mmc_seq_value),
        .mem_err_out_n                  (mem_err_out_n),
        .parity_error_n                 (parity_error_n),
        .dbg_seq_clk                    (dbg_clk),
        .dbg_seq_rst_n                  (dbg_reset_n),
        .dbg_seq_addr                   (dbg_addr),
        .dbg_seq_wr                     (dbg_wr),
        .dbg_seq_rd                     (dbg_rd),
        .dbg_seq_cs                     (dbg_cs),
        .dbg_seq_wr_data                (dbg_wr_data),
        .seq_dbg_rd_data                (dbg_rd_data),
        .seq_dbg_waitrequest            (dbg_waitrequest)
    );


endmodule

