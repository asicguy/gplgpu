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
// Title         : DDR controller
//
// File          : alt_ddrx_controller.v
//
// Abstract      : This file instantiates all controller blocks
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_controller # (
    parameter
    
        MEM_TYPE           = "DDR3",
        
        // local interface bus sizing parameters
        LOCAL_SIZE_WIDTH   = 3,
        LOCAL_ADDR_WIDTH   = 25,
        LOCAL_DATA_WIDTH   = 32,
        LOCAL_IF_TYPE      = "AVALON",
        
        // memory interface bus sizing parameters
        MEM_IF_CS_WIDTH    = 2,
        MEM_IF_CHIP_BITS   = 1,
        MEM_IF_CKE_WIDTH   = MEM_IF_CS_WIDTH,
        MEM_IF_ODT_WIDTH   = MEM_IF_CS_WIDTH,
        MEM_IF_ADDR_WIDTH  = 13, // max supported address bits, must be >= row bits
        MEM_IF_ROW_WIDTH   = 13, // max supported row bits
        MEM_IF_COL_WIDTH   = 10, // max supported column bits  
        MEM_IF_BA_WIDTH    = 3,  // max supported bank bits
        MEM_IF_DQS_WIDTH   = 1,
        MEM_IF_DQ_WIDTH    = 8,
        MEM_IF_DM_WIDTH    = 1,
        MEM_IF_CLK_PAIR_COUNT = 2,
        MEM_IF_CS_PER_DIMM = 2, // 2 ranks 1 slot
        MEM_IF_PCHADDR_BIT = 10,
        DWIDTH_RATIO       = 4,
              
        // controller settings
        CTL_LOOK_AHEAD_DEPTH    = 4,
        CTL_CMD_QUEUE_DEPTH     = 8,
        CTL_HRB_ENABLED         = 0, // off by default
        CTL_ECC_ENABLED         = 0,
        CTL_ECC_RMW_ENABLED     = 0,
        CTL_ECC_CSR_ENABLED     = 0,
        CTL_ECC_MULTIPLES_40_72 = 1,
        CTL_CSR_ENABLED         = 0, // off by default
        CTL_ODT_ENABLED         = 1,
        CTL_REGDIMM_ENABLED     = 0,
        CSR_ADDR_WIDTH          = 16,
        CSR_DATA_WIDTH          = 32,
        CTL_OUTPUT_REGD         = 0, // 1 is registered version and tested, low latency is being tested
        CTL_USR_REFRESH         = 0, // 1 when user has control over refresh
        CTL_DYNAMIC_BANK_ALLOCATION = 0,
        CTL_DYNAMIC_BANK_NUM = 4,
        
        // timing parameter
        MEM_CAS_WR_LAT                 = 0,        // these timing parameter must be set properly for controller to work
        MEM_ADD_LAT                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TCL                        = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRRD                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TFAW                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRFC                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TREFI                      = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRCD                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRP                        = 0,        // these timing parameter must be set properly for controller to work
        MEM_TWR                        = 0,        // these timing parameter must be set properly for controller to work
        MEM_TWTR                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRTP                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRAS                       = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRC                        = 0,        // these timing parameter must be set properly for controller to work
        MEM_AUTO_PD_CYCLES             = 0,        // these timing parameter must be set properly for controller to work
        MEM_IF_RD_TO_WR_TURNAROUND_OCT = 0,        // these timing parameter must be set properly for controller to work
        MEM_IF_WR_TO_RD_TURNAROUND_OCT = 0,        // these timing parameter must be set properly for controller to work
        
        // others
        ENABLE_AUTO_AP_LOGIC    = 1,
        CLOSE_PAGE_POLICY       = 1,
        ENABLE_BURST_MERGE      = 1,
        LOW_LATENCY             = 1,
        MULTICAST_WR_EN         = 0,
        ADDR_ORDER              = 1     // normally we will use '1' for chip, bank, row, column arrangement
    )
    (

        input wire                      ctl_clk       , // controller clock
        input wire                      ctl_reset_n   , // controller reset_n, synchronous to ctl_clk

        input                           ctl_half_clk          , // controller clock, half-rate 
        input                           ctl_half_clk_reset_n  , // controller reset_n, synchronous to ctl_half_clk 

        // Avalon data slave interface
        output                          local_ready          , // Avalon wait_n
        input                           local_read_req       , // Avalon read 
        input                           local_write_req      , // Avalon write
        input  [LOCAL_SIZE_WIDTH-1:0]   local_size           , // Avalon burstcount
        input                           local_burstbegin     , // Avalon burstbegin
        input  [LOCAL_ADDR_WIDTH-1:0]   local_addr           , // Avalon address 
        output                          local_rdata_valid    , // Avalon readdata_valid
        output                          local_rdata_error    , // Avalon readdata_error
        output [LOCAL_DATA_WIDTH-1:0]   local_rdata          , // Avalon readdata
        input  [LOCAL_DATA_WIDTH-1:0]   local_wdata          , // Avalon writedata
        input  [LOCAL_DATA_WIDTH/8-1:0] local_be             , // Avalon byteenble
                                                              
        // side band           
        output                          local_wdata_req      , // Native interface write data request
        input                           local_autopch_req    , // In-band auto-precharge request signal  
        input                           local_multicast      ,
        output                          local_init_done      , // The memory is ready to use
        input                           local_refresh_req    , // Side-band refresh request signal
        input  [MEM_IF_CS_WIDTH-1:0]    local_refresh_chip   , // Side-band refresh request signal
        output                          local_refresh_ack    , // Side-band refresh acknowledge signal
        input                           local_self_rfsh_req  , // Side-band self-refresh request signal
        input  [MEM_IF_CS_WIDTH-1:0]    local_self_rfsh_chip , // Side-band self-refresh request signal
        output                          local_self_rfsh_ack  , // Side-band self-refresh acknowledge signal
        output                          local_power_down_ack , // Side-band power-down acknowledge signal
                                        
        // Controller commands to the AFI interface 
        output  [(MEM_IF_CKE_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_cke,
        output  [(MEM_IF_CS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_cs_n,
        output  [(DWIDTH_RATIO/2) - 1:0]                        afi_ras_n,
        output  [(DWIDTH_RATIO/2) - 1:0]                        afi_cas_n,
        output  [(DWIDTH_RATIO/2) - 1:0]                        afi_we_n,
        output  [(MEM_IF_BA_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_ba,
        output  [(MEM_IF_ADDR_WIDTH * (DWIDTH_RATIO/2)) - 1:0]  afi_addr,
        output  [(MEM_IF_ODT_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_odt,
        output  [(DWIDTH_RATIO/2) - 1:0]                        afi_rst_n,
    
        // Controller read and write data to the AFI Interface
        output [MEM_IF_DQS_WIDTH*DWIDTH_RATIO/2-1:0]    afi_dqs_burst    ,
        output [MEM_IF_DQS_WIDTH*DWIDTH_RATIO/2-1:0]    afi_wdata_valid  ,
        output [MEM_IF_DQ_WIDTH*DWIDTH_RATIO-1:0]       afi_wdata        ,
        output [MEM_IF_DM_WIDTH*DWIDTH_RATIO-1:0]       afi_dm           ,
        input  [4:0]                                    afi_wlat         ,
                                                        
        output [MEM_IF_DQS_WIDTH*DWIDTH_RATIO/2-1:0]    afi_doing_read   ,
        output [MEM_IF_DQS_WIDTH*DWIDTH_RATIO/2-1:0]    afi_doing_read_full,
        input  [MEM_IF_DQ_WIDTH*DWIDTH_RATIO-1:0]       afi_rdata        ,
        input  [DWIDTH_RATIO/2-1:0]                     afi_rdata_valid  ,
                                                        
        input                                           ctl_cal_success, 
        input                                           ctl_cal_fail, 
        output                                          ctl_cal_req, 
        output [MEM_IF_CLK_PAIR_COUNT-1:0]              ctl_mem_clk_disable, 
        output [MEM_IF_DQS_WIDTH*MEM_IF_CS_WIDTH-1:0]   ctl_cal_byte_lane_sel_n,
        
        // CSR ports
        input                                           csr_write_req,
        input                                           csr_read_req,
        input  [CSR_ADDR_WIDTH - 1 : 0]                 csr_addr,
        input  [(CSR_DATA_WIDTH / 8) - 1 : 0]           csr_be,
        input  [CSR_DATA_WIDTH - 1 : 0]                 csr_wdata,
        output                                          csr_waitrequest,
        output [CSR_DATA_WIDTH - 1 : 0]                 csr_rdata,
        output                                          csr_rdata_valid,
        
        // ECC ports
        output                                          ecc_interrupt,

        // bank page open/close information
        output [MEM_IF_CS_WIDTH * (2**MEM_IF_BA_WIDTH) * MEM_IF_ROW_WIDTH - 1 : 0] bank_information,
        output [MEM_IF_CS_WIDTH * (2**MEM_IF_BA_WIDTH) - 1 : 0]                    bank_open
    );
    
    // timing parameter width
    localparam   CAS_WR_LAT_BUS_WIDTH        = 4;       // max will be 8 in DDR3
    localparam   ADD_LAT_BUS_WIDTH           = 3;       // max will be 6 in DDR2
    localparam   TCL_BUS_WIDTH               = 4;       // max will be 11 in DDR3
    localparam   TRRD_BUS_WIDTH              = 4;       // 2 - 8
    localparam   TFAW_BUS_WIDTH              = 6;       // 6 - 32
    localparam   TRFC_BUS_WIDTH              = 8;       // 12 - 140?
    localparam   TREFI_BUS_WIDTH             = 13;      // 780 - 6240
    localparam   TRCD_BUS_WIDTH              = 4;       // 2 - 11
    localparam   TRP_BUS_WIDTH               = 4;       // 2 - 11
    localparam   TWR_BUS_WIDTH               = 4;       // 2 - 12
    localparam   TWTR_BUS_WIDTH              = 4;       // 1 - 10
    localparam   TRTP_BUS_WIDTH              = 4;       // 2 - 8
    localparam   TRAS_BUS_WIDTH              = 5;       // 4 - 29
    localparam   TRC_BUS_WIDTH               = 6;       // 8 - 40
    localparam   AUTO_PD_BUS_WIDTH           = 16;      // same as CSR interface
    
    // csr width, used by input interface
    localparam   MEM_IF_CSR_COL_WIDTH        = 4;
    localparam   MEM_IF_CSR_ROW_WIDTH        = 5;
    localparam   MEM_IF_CSR_BANK_WIDTH       = 2;
    localparam   MEM_IF_CSR_CS_WIDTH         = 2;
    
    localparam   INTERNAL_DATA_WIDTH         = LOCAL_DATA_WIDTH >> CTL_HRB_ENABLED;
    localparam   INTERNAL_SIZE_WIDTH         = LOCAL_SIZE_WIDTH + CTL_HRB_ENABLED;
    localparam   WDATA_BEATS_WIDTH           = INTERNAL_SIZE_WIDTH + log2 (CTL_CMD_QUEUE_DEPTH);
    
    localparam   MEMORY_BURSTLENGTH          = (DWIDTH_RATIO == 2 && MEM_TYPE != "DDR3") ? 4 : 8;
    
    localparam   CTL_RESET_SYNC_STAGES       = 4;
    localparam   CTL_NUM_RESET_OUTPUT        = 17;
    localparam   CTL_HALF_RESET_SYNC_STAGES  = 4;
    localparam   CTL_HALF_NUM_RESET_OUTPUT   = 1;
    
//==============================================================================
// Internal wires declaration
//==============================================================================
    // output from clock_and_reset block
    wire    [CTL_NUM_RESET_OUTPUT - 1 : 0]      resynced_ctl_reset_n;
    wire    [CTL_HALF_NUM_RESET_OUTPUT - 1 : 0] resynced_ctl_half_clk_reset_n;
    
    // output from input_if block
    wire                                cmd_fifo_wren;
                                        
    wire                                cmd0_is_a_read;
    wire                                cmd0_is_a_write;
    wire                                cmd0_autopch_req;
    wire    [1:0]                       cmd0_burstcount;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd0_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd0_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd0_bank_addr;
    wire    [MEM_IF_COL_WIDTH-1:0]      cmd0_col_addr;
    wire                                cmd0_is_valid;
    wire                                cmd0_multicast_req;
                                        
    wire                                cmd1_is_a_read;
    wire                                cmd1_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd1_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd1_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd1_bank_addr;
    wire                                cmd1_is_valid;
    wire                                cmd1_multicast_req;
                                        
    wire                                cmd2_is_a_read;
    wire                                cmd2_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd2_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd2_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd2_bank_addr;
    wire                                cmd2_is_valid;
    wire                                cmd2_multicast_req;
                                        
    wire                                cmd3_is_a_read;
    wire                                cmd3_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd3_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd3_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd3_bank_addr;
    wire                                cmd3_is_valid;
    wire                                cmd3_multicast_req;
    
    wire                                cmd4_is_a_read;
    wire                                cmd4_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd4_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd4_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd4_bank_addr;
    wire                                cmd4_is_valid;
    wire                                cmd4_multicast_req;
    
    wire                                cmd5_is_a_read;
    wire                                cmd5_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd5_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd5_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd5_bank_addr;
    wire                                cmd5_is_valid;
    wire                                cmd5_multicast_req;
    
    wire                                cmd6_is_a_read;
    wire                                cmd6_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd6_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd6_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd6_bank_addr;
    wire                                cmd6_is_valid;
    wire                                cmd6_multicast_req;
    
    wire                                cmd7_is_a_read;
    wire                                cmd7_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      cmd7_chip_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      cmd7_row_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       cmd7_bank_addr;
    wire                                cmd7_is_valid;
    wire                                cmd7_multicast_req;
                                        
    wire                                cmd_fifo_empty;
    wire                                cmd_fifo_full;
    
    wire                                wdata_fifo_full;
    wire    [INTERNAL_DATA_WIDTH-1:0]   wdata_fifo_wdata;
    wire    [INTERNAL_DATA_WIDTH/8-1:0] wdata_fifo_be;
    wire    [WDATA_BEATS_WIDTH-1:0]     beats_in_wfifo;
    wire                                write_req_to_wfifo;
    wire    [INTERNAL_DATA_WIDTH/8-1:0] be_to_wfifo;
    
    // output from bank management block
    wire    [MEM_IF_CS_WIDTH-1:0]       all_banks_closed;
    wire                                current_bank_info_valid;
    wire                                current_bank_is_open;
    wire                                current_row_is_open;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  bank_info_valid;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  bank_is_open;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  row_is_open;
    
    // output from timer block
    wire    [MEM_IF_CS_WIDTH-1:0]       can_auto_refresh;
    wire                                auto_refresh_req;
    wire    [MEM_IF_CS_WIDTH-1:0]       auto_refresh_chip;
    wire    [MEM_IF_CS_WIDTH-1:0]       can_enter_power_down;
    wire    [MEM_IF_CS_WIDTH-1:0]       can_exit_power_saving_mode;
    wire                                power_down_req;
    wire                                zq_cal_req;
    wire    [MEM_IF_CS_WIDTH-1:0]       can_self_rfsh;
    wire                                can_al_activate_write;
    wire                                can_al_activate_read;
    wire                                add_lat_on;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  can_activate;
    wire    [CTL_LOOK_AHEAD_DEPTH-1:0]  can_precharge;
    wire                                can_read_current;
    wire                                can_write_current;
    wire                                can_activate_current;
    wire                                can_precharge_current;
    wire    [MEM_IF_CS_WIDTH-1:0]       can_lmr;
    wire    [MEM_IF_CS_WIDTH-1:0]       can_precharge_all;
    wire    [MEM_IF_CS_WIDTH-1:0]       can_refresh;
    wire                                cam_full;
    
    // output from state machine
    wire                                auto_refresh_ack;
    
    wire                                fetch;
    
    wire                                current_is_a_read;
    wire                                current_is_a_write;
    wire    [MEM_IF_CHIP_BITS-1:0]      current_chip_addr;
    wire    [MEM_IF_BA_WIDTH-1:0]       current_bank_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      current_row_addr;
    wire                                current_multicast_req;
    
    wire    do_write;
    wire    do_read;
    wire    do_burst_chop;
    wire    do_activate;
    wire    do_precharge;
    wire    do_refresh;
    wire    do_power_down;
    wire    do_self_rfsh;
    wire    do_lmr;
    wire    do_auto_precharge;
    wire    do_precharge_all;
    wire    do_zqcal;
    wire    rdwr_data_valid;
    wire    [MEM_IF_CS_WIDTH-1:0]       to_chip;
    wire    [MEM_IF_BA_WIDTH-1:0]       to_bank_addr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      to_row_addr;
    wire    [MEM_IF_COL_WIDTH-1:0]      to_col_addr;
    
    wire    do_write_var;
    wire    do_read_var;
    wire    do_burst_chop_var;
    wire    do_activate_var;
    wire    do_precharge_var;
    wire    do_refresh_var;
    wire    do_power_down_var;
    wire    do_self_rfsh_var;
    wire    do_lmr_var;
    wire    do_auto_precharge_var;
    wire    do_precharge_all_var;
    wire    do_zqcal_var;
    wire    rdwr_data_valid_var;
    wire    [MEM_IF_CS_WIDTH-1:0]       to_chip_var;
    wire    [MEM_IF_BA_WIDTH-1:0]       to_bank_addr_var;
    wire    [MEM_IF_ROW_WIDTH-1:0]      to_row_addr_var;
    wire    [MEM_IF_COL_WIDTH-1:0]      to_col_addr_var;
    
    wire    do_ecc;
    wire    do_partial;
    wire    ecc_fetch_error_addr;
    
    // output from AFI block
    wire    ecc_wdata_fifo_read;
    
    // output from ECC block
    wire                                                        rmw_data_ready;
    wire                                                        ecc_single_bit_error;
    wire   [MEM_IF_CHIP_BITS - 1 : 0]                           ecc_error_chip_addr;
    wire   [MEM_IF_BA_WIDTH  - 1 : 0]                           ecc_error_bank_addr;
    wire   [MEM_IF_ROW_WIDTH - 1 : 0]                           ecc_error_row_addr;
    wire   [MEM_IF_COL_WIDTH - 1 : 0]                           ecc_error_col_addr;
    wire                                                        wdata_is_partial;
    
    wire                                                        ecc_rdata_error;
    wire   [DWIDTH_RATIO / 2 - 1 : 0]                           ecc_rdata_valid;
    wire   [INTERNAL_DATA_WIDTH -1 : 0]                         ecc_rdata;
    wire   [((MEM_IF_DQ_WIDTH * DWIDTH_RATIO) / 8) - 1 : 0]     ecc_be;
    wire   [(MEM_IF_DQ_WIDTH * DWIDTH_RATIO) - 1 : 0]           ecc_wdata;
    
    wire                                                        wdata_fifo_read;
    
    wire                                                        ecc_sbe_error;
    wire                                                        ecc_dbe_error;
    wire   [7 : 0]                                              ecc_sbe_count;
    wire   [7 : 0]                                              ecc_dbe_count;
    wire   [31 : 0]                                             ecc_error_addr;
    
    // output from CSR block
    wire   [CAS_WR_LAT_BUS_WIDTH - 1 : 0]                       mem_cas_wr_lat;
    wire   [ADD_LAT_BUS_WIDTH    - 1 : 0]                       mem_add_lat;
    wire   [TCL_BUS_WIDTH        - 1 : 0]                       mem_tcl;
    wire   [TRRD_BUS_WIDTH       - 1 : 0]                       mem_trrd;
    wire   [TFAW_BUS_WIDTH       - 1 : 0]                       mem_tfaw;
    wire   [TRFC_BUS_WIDTH       - 1 : 0]                       mem_trfc;
    wire   [TREFI_BUS_WIDTH      - 1 : 0]                       mem_trefi;
    wire   [TRCD_BUS_WIDTH       - 1 : 0]                       mem_trcd;
    wire   [TRP_BUS_WIDTH        - 1 : 0]                       mem_trp;
    wire   [TWR_BUS_WIDTH        - 1 : 0]                       mem_twr;
    wire   [TWTR_BUS_WIDTH       - 1 : 0]                       mem_twtr;
    wire   [TRTP_BUS_WIDTH       - 1 : 0]                       mem_trtp;
    wire   [TRAS_BUS_WIDTH       - 1 : 0]                       mem_tras;
    wire   [TRC_BUS_WIDTH        - 1 : 0]                       mem_trc;
    wire   [AUTO_PD_BUS_WIDTH    - 1 : 0]                       mem_auto_pd_cycles;
    
    wire   [1:0]                                                addr_order;
    wire   [MEM_IF_CSR_COL_WIDTH  - 1 : 0]                      col_width_from_csr;
    wire   [MEM_IF_CSR_ROW_WIDTH  - 1 : 0]                      row_width_from_csr;
    wire   [MEM_IF_CSR_BANK_WIDTH - 1 : 0]                      bank_width_from_csr;
    wire   [MEM_IF_CSR_CS_WIDTH   - 1 : 0]                      cs_width_from_csr;
    
    wire                                                        ecc_enable;
    wire                                                        ecc_enable_auto_corr;
    wire                                                        ecc_gen_sbe;
    wire                                                        ecc_gen_dbe;
    wire                                                        ecc_enable_intr;
    wire                                                        ecc_mask_sbe_intr;
    wire                                                        ecc_mask_dbe_intr;
    wire                                                        ecc_clear;
    
    wire                                                        regdimm_enable;

//==============================================================================
// Clock and reset logic
//------------------------------------------------------------------------------
//    
//    Reset sync logic
//    
//==============================================================================
    
    alt_ddrx_clock_and_reset #(
        .CTL_RESET_SYNC_STAGES         (CTL_RESET_SYNC_STAGES        ),
        .CTL_NUM_RESET_OUTPUT          (CTL_NUM_RESET_OUTPUT         ),
        .CTL_HALF_RESET_SYNC_STAGES    (CTL_HALF_RESET_SYNC_STAGES   ),
        .CTL_HALF_NUM_RESET_OUTPUT     (CTL_HALF_NUM_RESET_OUTPUT    )
    ) clock_and_reset_inst (
        .ctl_clk                       (ctl_clk                      ),
        .ctl_reset_n                   (ctl_reset_n                  ),
        .ctl_half_clk                  (ctl_half_clk                 ),
        .ctl_half_clk_reset_n          (ctl_half_clk_reset_n         ),
        .resynced_ctl_reset_n          (resynced_ctl_reset_n         ),
        .resynced_ctl_half_clk_reset_n (resynced_ctl_half_clk_reset_n)
    );
    
//==============================================================================
// Input logic
//------------------------------------------------------------------------------
//    
// Input interface, which includes
//    Avalon-MM slave interface logic
//    Optional half-rate bridge logic
//    Command queue logic
//    Write data FIFO and optional write data request logic
//    
//==============================================================================
    
    alt_ddrx_input_if #(
        .MEM_TYPE              (MEM_TYPE                       ),
        .INTERNAL_DATA_WIDTH   (INTERNAL_DATA_WIDTH            ),
        .CTL_HRB_ENABLED       (CTL_HRB_ENABLED                ),
        .CTL_CSR_ENABLED       (CTL_CSR_ENABLED                ),
        .CTL_REGDIMM_ENABLED   (CTL_REGDIMM_ENABLED            ),
        .MEM_IF_CSR_COL_WIDTH  (MEM_IF_CSR_COL_WIDTH           ),
        .MEM_IF_CSR_ROW_WIDTH  (MEM_IF_CSR_ROW_WIDTH           ),
        .MEM_IF_CSR_BANK_WIDTH (MEM_IF_CSR_BANK_WIDTH          ),
        .MEM_IF_CSR_CS_WIDTH   (MEM_IF_CSR_CS_WIDTH            ),
        .LOCAL_DATA_WIDTH      (LOCAL_DATA_WIDTH               ),
        .WDATA_BEATS_WIDTH     (WDATA_BEATS_WIDTH              ),
        .LOCAL_ADDR_WIDTH      (LOCAL_ADDR_WIDTH               ),
        .LOCAL_SIZE_WIDTH      (LOCAL_SIZE_WIDTH               ),
        .INTERNAL_SIZE_WIDTH   (INTERNAL_SIZE_WIDTH            ),
        .CTL_LOOK_AHEAD_DEPTH  (CTL_LOOK_AHEAD_DEPTH           ),
        .CTL_CMD_QUEUE_DEPTH   (CTL_CMD_QUEUE_DEPTH            ),
        .MEM_IF_ROW_WIDTH      (MEM_IF_ROW_WIDTH               ),
        .MEM_IF_COL_WIDTH      (MEM_IF_COL_WIDTH               ),
        .MEM_IF_BA_WIDTH       (MEM_IF_BA_WIDTH                ),
        .MEM_IF_CHIP_BITS	   (MEM_IF_CHIP_BITS	           ), 
        .DWIDTH_RATIO          (DWIDTH_RATIO                   ),
        .MEMORY_BURSTLENGTH    (MEMORY_BURSTLENGTH             ),
        .ENABLE_BURST_MERGE    (ENABLE_BURST_MERGE             ),
        .MIN_COL               (8                              ), // need to add this to the top level list of parameters
        .MIN_ROW               (12                             ), // need to add this to the top level list of parameters
        .MIN_BANK              (2                              ),  // need to add this to the top level list of parameters
        .MIN_CS                (1                              ), // need to add this to the top level list of parameters
        .LOCAL_IF_TYPE         (LOCAL_IF_TYPE                  )
    ) input_if_inst (
        .ctl_clk              (ctl_clk                         ),
        .ctl_reset_n          (resynced_ctl_reset_n[4:0]       ),
        .ctl_half_clk         (ctl_half_clk                    ),
        .ctl_half_clk_reset_n (resynced_ctl_half_clk_reset_n[0]),
        .local_read_req       (local_read_req                  ),
        .local_write_req      (local_write_req                 ),
        .local_ready          (local_ready                     ),
        .local_size           (local_size                      ),
        .local_autopch_req    (local_autopch_req               ),
        .local_multicast      (local_multicast                 ),
        .local_burstbegin     (local_burstbegin                ),
        .local_init_done      (local_init_done                 ),
        .local_addr           (local_addr                      ),
        .local_rdata_error    (local_rdata_error               ),
        .local_rdata_valid    (local_rdata_valid               ),
        .local_rdata          (local_rdata                     ),
        .local_wdata          (local_wdata                     ),
        .local_be             (local_be                        ),
        .local_wdata_req      (local_wdata_req                 ),
        .ecc_rdata            (ecc_rdata                       ),
        .ecc_rdata_valid      (ecc_rdata_valid                 ),
        .ecc_rdata_error      (ecc_rdata_error                 ),
        .wdata_fifo_wdata     (wdata_fifo_wdata                ),
        .wdata_fifo_be        (wdata_fifo_be                   ),
        .beats_in_wfifo       (beats_in_wfifo                  ),
        .write_req_to_wfifo   (write_req_to_wfifo              ),
        .be_to_wfifo          (be_to_wfifo                     ),
        .addr_order           (addr_order                      ),
        .col_width_from_csr   (col_width_from_csr              ),
        .row_width_from_csr   (row_width_from_csr              ),
        .bank_width_from_csr  (bank_width_from_csr             ),
        .regdimm_enable       (regdimm_enable                  ),
        .cs_width_from_csr    (cs_width_from_csr               ),
        .wdata_fifo_read      (wdata_fifo_read                 ),
        .fetch                (fetch                           ),
        .ctl_cal_success      (ctl_cal_success                 ),
        .ctl_cal_fail         (ctl_cal_fail                    ),
        .cmd_fifo_empty       (cmd_fifo_empty                  ),
        .cmd_fifo_full        (cmd_fifo_full                   ),
        .cmd_fifo_wren        (cmd_fifo_wren                   ),
        .cmd0_is_a_read       (cmd0_is_a_read                  ),
        .cmd0_is_a_write      (cmd0_is_a_write                 ),
        .cmd0_autopch_req     (cmd0_autopch_req                ),
        .cmd0_burstcount      (cmd0_burstcount                 ),
        .cmd0_chip_addr       (cmd0_chip_addr                  ),
        .cmd0_row_addr        (cmd0_row_addr                   ),
        .cmd0_bank_addr       (cmd0_bank_addr                  ),
        .cmd0_col_addr        (cmd0_col_addr                   ),
        .cmd0_is_valid        (cmd0_is_valid                   ),
        .cmd0_multicast_req   (cmd0_multicast_req              ),
        .cmd1_is_a_read       (cmd1_is_a_read                  ),
        .cmd1_is_a_write      (cmd1_is_a_write                 ),
        .cmd1_chip_addr       (cmd1_chip_addr                  ),
        .cmd1_row_addr        (cmd1_row_addr                   ),
        .cmd1_bank_addr       (cmd1_bank_addr                  ),
        .cmd1_is_valid        (cmd1_is_valid                   ),
        .cmd1_multicast_req   (cmd1_multicast_req              ),
        .cmd2_is_a_read       (cmd2_is_a_read                  ),
        .cmd2_is_a_write      (cmd2_is_a_write                 ),
        .cmd2_chip_addr       (cmd2_chip_addr                  ),
        .cmd2_row_addr        (cmd2_row_addr                   ),
        .cmd2_bank_addr       (cmd2_bank_addr                  ),
        .cmd2_is_valid        (cmd2_is_valid                   ),
        .cmd2_multicast_req   (cmd2_multicast_req              ),
        .cmd3_is_a_read       (cmd3_is_a_read                  ),
        .cmd3_is_a_write      (cmd3_is_a_write                 ),
        .cmd3_chip_addr       (cmd3_chip_addr                  ),
        .cmd3_row_addr        (cmd3_row_addr                   ),
        .cmd3_bank_addr       (cmd3_bank_addr                  ),
        .cmd3_is_valid        (cmd3_is_valid                   ),
        .cmd3_multicast_req   (cmd3_multicast_req              ),
        .cmd4_is_a_read       (cmd4_is_a_read                  ),
        .cmd4_is_a_write      (cmd4_is_a_write                 ),
        .cmd4_chip_addr       (cmd4_chip_addr                  ),
        .cmd4_row_addr        (cmd4_row_addr                   ),
        .cmd4_bank_addr       (cmd4_bank_addr                  ),
        .cmd4_is_valid        (cmd4_is_valid                   ),
        .cmd4_multicast_req   (cmd4_multicast_req              ),
        .cmd5_is_a_read       (cmd5_is_a_read                  ),
        .cmd5_is_a_write      (cmd5_is_a_write                 ),
        .cmd5_chip_addr       (cmd5_chip_addr                  ),
        .cmd5_row_addr        (cmd5_row_addr                   ),
        .cmd5_bank_addr       (cmd5_bank_addr                  ),
        .cmd5_is_valid        (cmd5_is_valid                   ),
        .cmd5_multicast_req   (cmd5_multicast_req              ),
        .cmd6_is_a_read       (cmd6_is_a_read                  ),
        .cmd6_is_a_write      (cmd6_is_a_write                 ),
        .cmd6_chip_addr       (cmd6_chip_addr                  ),
        .cmd6_row_addr        (cmd6_row_addr                   ),
        .cmd6_bank_addr       (cmd6_bank_addr                  ),
        .cmd6_is_valid        (cmd6_is_valid                   ),
        .cmd6_multicast_req   (cmd6_multicast_req              ),
        .cmd7_is_a_read       (cmd7_is_a_read                  ),
        .cmd7_is_a_write      (cmd7_is_a_write                 ),
        .cmd7_chip_addr       (cmd7_chip_addr                  ),
        .cmd7_row_addr        (cmd7_row_addr                   ),
        .cmd7_bank_addr       (cmd7_bank_addr                  ),
        .cmd7_is_valid        (cmd7_is_valid                   ),
        .cmd7_multicast_req   (cmd7_multicast_req              )
    );
    
//==============================================================================
// Processing logic
//------------------------------------------------------------------------------
//    
// Timers
// Bank management
// ECC encoder/decoders/address FIFO
//==============================================================================

    alt_ddrx_bank_timer_wrapper #
    (
        .MEM_IF_CHIP_BITS                             (MEM_IF_CHIP_BITS                             ),
        .MEM_IF_CS_WIDTH                              (MEM_IF_CS_WIDTH                              ),
        .MEM_IF_BA_WIDTH                              (MEM_IF_BA_WIDTH                              ),
        .MEM_IF_ROW_WIDTH                             (MEM_IF_ROW_WIDTH                             ),
        .MEM_TYPE                                     (MEM_TYPE                                     ),
        .MEMORY_BURSTLENGTH                           (MEMORY_BURSTLENGTH                           ),
        .DWIDTH_RATIO                                 (DWIDTH_RATIO                                 ),
        .CLOSE_PAGE_POLICY                            (CLOSE_PAGE_POLICY                            ),
        .MEM_IF_RD_TO_WR_TURNAROUND_OCT               (MEM_IF_RD_TO_WR_TURNAROUND_OCT               ),
        .MEM_IF_WR_TO_RD_TURNAROUND_OCT               (MEM_IF_WR_TO_RD_TURNAROUND_OCT               ),
        .MEM_IF_WR_TO_RD_DIFF_CHIPS_TURNAROUND_OCT    (MEM_IF_WR_TO_RD_TURNAROUND_OCT               ), // temp
        .CTL_LOOK_AHEAD_DEPTH                         (CTL_LOOK_AHEAD_DEPTH                         ),
        .CTL_DYNAMIC_BANK_ALLOCATION                  (CTL_DYNAMIC_BANK_ALLOCATION                  ),
        .CTL_DYNAMIC_BANK_NUM                         (CTL_DYNAMIC_BANK_NUM                         ),
        .CTL_CMD_QUEUE_DEPTH                          (CTL_CMD_QUEUE_DEPTH                          ),
        .CTL_USR_REFRESH                              (CTL_USR_REFRESH                              ),
        .CAS_WR_LAT_BUS_WIDTH                         (CAS_WR_LAT_BUS_WIDTH                         ),
        .ADD_LAT_BUS_WIDTH                            (ADD_LAT_BUS_WIDTH                            ),
        .TCL_BUS_WIDTH                                (TCL_BUS_WIDTH                                ),
        .TRRD_BUS_WIDTH                               (TRRD_BUS_WIDTH                               ),
        .TFAW_BUS_WIDTH                               (TFAW_BUS_WIDTH                               ),
        .TRFC_BUS_WIDTH                               (TRFC_BUS_WIDTH                               ),
        .TREFI_BUS_WIDTH                              (TREFI_BUS_WIDTH                              ),
        .TRCD_BUS_WIDTH                               (TRCD_BUS_WIDTH                               ),
        .TRP_BUS_WIDTH                                (TRP_BUS_WIDTH                                ),
        .TWR_BUS_WIDTH                                (TWR_BUS_WIDTH                                ),
        .TWTR_BUS_WIDTH                               (TWTR_BUS_WIDTH                               ),
        .TRTP_BUS_WIDTH                               (TRTP_BUS_WIDTH                               ),
        .TRAS_BUS_WIDTH                               (TRAS_BUS_WIDTH                               ),
        .TRC_BUS_WIDTH                                (TRC_BUS_WIDTH                                ),
        .AUTO_PD_BUS_WIDTH                            (AUTO_PD_BUS_WIDTH                            )
    )
    bank_timer_wrapper_inst
    (
        .ctl_clk                                      (ctl_clk                                      ),
        .ctl_reset_n                                  (resynced_ctl_reset_n[10 : 5]                 ),
        .cmd0_is_valid                                (cmd0_is_valid                                ),
        .cmd0_chip_addr                               (cmd0_chip_addr                               ),
        .cmd0_bank_addr                               (cmd0_bank_addr                               ),
        .cmd0_row_addr                                (cmd0_row_addr                                ),
        .cmd0_multicast_req                           (cmd0_multicast_req                           ),
        .cmd1_is_valid                                (cmd1_is_valid                                ),
        .cmd1_chip_addr                               (cmd1_chip_addr                               ),
        .cmd1_bank_addr                               (cmd1_bank_addr                               ),
        .cmd1_row_addr                                (cmd1_row_addr                                ),
        .cmd1_multicast_req                           (cmd1_multicast_req                           ),
        .cmd2_is_valid                                (cmd2_is_valid                                ),
        .cmd2_chip_addr                               (cmd2_chip_addr                               ),
        .cmd2_bank_addr                               (cmd2_bank_addr                               ),
        .cmd2_row_addr                                (cmd2_row_addr                                ),
        .cmd2_multicast_req                           (cmd2_multicast_req                           ),
        .cmd3_is_valid                                (cmd3_is_valid                                ),
        .cmd3_chip_addr                               (cmd3_chip_addr                               ),
        .cmd3_bank_addr                               (cmd3_bank_addr                               ),
        .cmd3_row_addr                                (cmd3_row_addr                                ),
        .cmd3_multicast_req                           (cmd3_multicast_req                           ),
        .cmd4_is_valid                                (cmd4_is_valid                                ),
        .cmd4_chip_addr                               (cmd4_chip_addr                               ),
        .cmd4_bank_addr                               (cmd4_bank_addr                               ),
        .cmd4_row_addr                                (cmd4_row_addr                                ),
        .cmd4_multicast_req                           (cmd4_multicast_req                           ),
        .cmd5_is_valid                                (cmd5_is_valid                                ),
        .cmd5_chip_addr                               (cmd5_chip_addr                               ),
        .cmd5_bank_addr                               (cmd5_bank_addr                               ),
        .cmd5_row_addr                                (cmd5_row_addr                                ),
        .cmd5_multicast_req                           (cmd5_multicast_req                           ),
        .cmd6_is_valid                                (cmd6_is_valid                                ),
        .cmd6_chip_addr                               (cmd6_chip_addr                               ),
        .cmd6_bank_addr                               (cmd6_bank_addr                               ),
        .cmd6_row_addr                                (cmd6_row_addr                                ),
        .cmd6_multicast_req                           (cmd6_multicast_req                           ),
        .cmd7_is_valid                                (cmd7_is_valid                                ),
        .cmd7_chip_addr                               (cmd7_chip_addr                               ),
        .cmd7_bank_addr                               (cmd7_bank_addr                               ),
        .cmd7_row_addr                                (cmd7_row_addr                                ),
        .cmd7_multicast_req                           (cmd7_multicast_req                           ),
        .current_chip_addr                            (current_chip_addr                            ),
        .current_bank_addr                            (current_bank_addr                            ),
        .current_row_addr                             (current_row_addr                             ),
        .current_multicast_req                        (current_multicast_req                        ),
        .do_write                                     (do_write                                     ),
        .do_read                                      (do_read                                      ),
        .do_burst_chop                                (do_burst_chop                                ),
        .do_auto_precharge                            (do_auto_precharge                            ),
        .do_activate                                  (do_activate                                  ),
        .do_precharge                                 (do_precharge                                 ),
        .do_precharge_all                             (do_precharge_all                             ),
        .do_refresh                                   (do_refresh                                   ),
        .do_power_down                                (do_power_down                                ),
        .do_self_rfsh                                 (do_self_rfsh                                 ),
        .to_chip                                      (to_chip                                      ),
        .to_bank_addr                                 (to_bank_addr                                 ),
        .to_row_addr                                  (to_row_addr                                  ),
        .fetch                                        (fetch                                        ),
        .ecc_fetch_error_addr                         (ecc_fetch_error_addr                         ),
        .local_init_done                              (local_init_done                              ),
        .cmd_fifo_empty                               (cmd_fifo_empty                               ),
        .mem_cas_wr_lat                               (mem_cas_wr_lat                               ),
        .mem_add_lat                                  (mem_add_lat                                  ),
        .mem_tcl                                      (mem_tcl                                      ),
        .mem_trrd                                     (mem_trrd                                     ),
        .mem_tfaw                                     (mem_tfaw                                     ),
        .mem_trfc                                     (mem_trfc                                     ),
        .mem_trefi                                    (mem_trefi                                    ),
        .mem_trcd                                     (mem_trcd                                     ),
        .mem_trp                                      (mem_trp                                      ),
        .mem_twr                                      (mem_twr                                      ),
        .mem_twtr                                     (mem_twtr                                     ),
        .mem_trtp                                     (mem_trtp                                     ),
        .mem_tras                                     (mem_tras                                     ),
        .mem_trc                                      (mem_trc                                      ),
        .mem_auto_pd_cycles                           (mem_auto_pd_cycles                           ),
        .all_banks_closed                             (all_banks_closed                             ),
        .current_bank_is_open                         (current_bank_is_open                         ),
        .current_row_is_open                          (current_row_is_open                          ),
        .current_bank_info_valid                      (current_bank_info_valid                      ),
        .bank_is_open                                 (bank_is_open                                 ),
        .row_is_open                                  (row_is_open                                  ),
        .bank_info_valid                              (bank_info_valid                              ),
        .can_read_current                             (can_read_current                             ),
        .can_write_current                            (can_write_current                            ),
        .can_activate_current                         (can_activate_current                         ),
        .can_precharge_current                        (can_precharge_current                        ),
        .can_activate                                 (can_activate                                 ),
        .can_precharge                                (can_precharge                                ),
        .can_precharge_all                            (can_precharge_all                            ),
        .can_refresh                                  (can_refresh                                  ),
        .auto_refresh_req                             (auto_refresh_req                             ),
        .auto_refresh_chip                            (auto_refresh_chip                            ),
        .can_enter_power_down                         (can_enter_power_down                         ),
        .can_self_rfsh                                (can_self_rfsh                                ),
        .can_exit_power_saving_mode                   (can_exit_power_saving_mode                   ),
        .power_down_req                               (power_down_req                               ),
        .zq_cal_req                                   (zq_cal_req                                   ),
        .can_al_activate_write                        (can_al_activate_write                        ),
        .can_al_activate_read                         (can_al_activate_read                         ),
        .add_lat_on                                   (add_lat_on                                   ),
        .cam_full                                     (cam_full                                     )
    );

//==============================================================================
// State machine
//------------------------------------------------------------------------------
//
//==============================================================================

    alt_ddrx_state_machine  # (
        .MEM_TYPE               (MEM_TYPE),
        .MEM_IF_CHIP_BITS       (MEM_IF_CHIP_BITS),
        .MEM_IF_CS_WIDTH        (MEM_IF_CS_WIDTH),
        .MEM_IF_BA_WIDTH        (MEM_IF_BA_WIDTH),
        .MEM_IF_ROW_WIDTH       (MEM_IF_ROW_WIDTH),
        .MEM_IF_COL_WIDTH       (MEM_IF_COL_WIDTH),
        .MEM_IF_CSR_CS_WIDTH    (MEM_IF_CSR_CS_WIDTH),
        .MEM_IF_CSR_BANK_WIDTH  (MEM_IF_CSR_BANK_WIDTH),
        .MEM_IF_CSR_ROW_WIDTH   (MEM_IF_CSR_ROW_WIDTH),
        .MEM_IF_CSR_COL_WIDTH   (MEM_IF_CSR_COL_WIDTH),
        .CTL_LOOK_AHEAD_DEPTH   (CTL_LOOK_AHEAD_DEPTH),
        .WDATA_BEATS_WIDTH      (WDATA_BEATS_WIDTH),
        .DWIDTH_RATIO           (DWIDTH_RATIO),
        .MEMORY_BURSTLENGTH     (MEMORY_BURSTLENGTH),
        .ENABLE_AUTO_AP_LOGIC   (ENABLE_AUTO_AP_LOGIC),
        .CLOSE_PAGE_POLICY      (CLOSE_PAGE_POLICY),
        .LOW_LATENCY            (LOW_LATENCY),
        .MULTICAST_WR_EN        (MULTICAST_WR_EN),
        .CTL_CSR_ENABLED        (CTL_CSR_ENABLED),
        .CTL_ECC_ENABLED        (CTL_ECC_ENABLED),
        .CTL_REGDIMM_ENABLED    (CTL_REGDIMM_ENABLED),
        .CTL_USR_REFRESH        (CTL_USR_REFRESH)
    ) state_machine_inst (
        .ctl_clk                    (ctl_clk                   ),
        .ctl_reset_n                (resynced_ctl_reset_n[11]  ),
        .ctl_cal_success            (ctl_cal_success           ),
        .cmd_fifo_empty             (cmd_fifo_empty            ),
        .cmd_fifo_wren              (cmd_fifo_wren             ),
        .write_req_to_wfifo         (write_req_to_wfifo        ),
        .fetch                      (fetch                     ),
        .cmd0_is_a_read             (cmd0_is_a_read            ),
        .cmd0_is_a_write            (cmd0_is_a_write           ),
        .cmd0_autopch_req           (cmd0_autopch_req          ),
        .cmd0_multicast_req         (cmd0_multicast_req        ),
        .cmd0_burstcount            (cmd0_burstcount           ),
        .cmd0_chip_addr             (cmd0_chip_addr            ),
        .cmd0_bank_addr             (cmd0_bank_addr            ),
        .cmd0_row_addr              (cmd0_row_addr             ),
        .cmd0_col_addr              (cmd0_col_addr             ),
        .cmd0_is_valid              (cmd0_is_valid             ),
        .cmd1_multicast_req         (cmd1_multicast_req        ),
        .cmd1_chip_addr             (cmd1_chip_addr            ),
        .cmd1_bank_addr             (cmd1_bank_addr            ),
        .cmd1_row_addr              (cmd1_row_addr             ),
        .cmd1_is_valid              (cmd1_is_valid             ),
        .cmd2_multicast_req         (cmd2_multicast_req        ),
        .cmd2_chip_addr             (cmd2_chip_addr            ),
        .cmd2_bank_addr             (cmd2_bank_addr            ),
        .cmd2_row_addr              (cmd2_row_addr             ),
        .cmd2_is_valid              (cmd2_is_valid             ),
        .cmd3_multicast_req         (cmd3_multicast_req        ),
        .cmd3_chip_addr             (cmd3_chip_addr            ),
        .cmd3_bank_addr             (cmd3_bank_addr            ),
        .cmd3_row_addr              (cmd3_row_addr             ),
        .cmd3_is_valid              (cmd3_is_valid             ),
        .cmd4_multicast_req         (cmd4_multicast_req        ),
        .cmd4_chip_addr             (cmd4_chip_addr            ),
        .cmd4_bank_addr             (cmd4_bank_addr            ),
        .cmd4_row_addr              (cmd4_row_addr             ),
        .cmd4_is_valid              (cmd4_is_valid             ),
        .cmd5_multicast_req         (cmd5_multicast_req        ),
        .cmd5_chip_addr             (cmd5_chip_addr            ),
        .cmd5_bank_addr             (cmd5_bank_addr            ),
        .cmd5_row_addr              (cmd5_row_addr             ),
        .cmd5_is_valid              (cmd5_is_valid             ),
        .cmd6_multicast_req         (cmd6_multicast_req        ),
        .cmd6_chip_addr             (cmd6_chip_addr            ),
        .cmd6_bank_addr             (cmd6_bank_addr            ),
        .cmd6_row_addr              (cmd6_row_addr             ),
        .cmd6_is_valid              (cmd6_is_valid             ),
        .cmd7_multicast_req         (cmd7_multicast_req        ),
        .cmd7_chip_addr             (cmd7_chip_addr            ),
        .cmd7_bank_addr             (cmd7_bank_addr            ),
        .cmd7_row_addr              (cmd7_row_addr             ),
        .cmd7_is_valid              (cmd7_is_valid             ),
        .current_is_a_read          (current_is_a_read         ),
        .current_is_a_write         (current_is_a_write        ),
        .current_chip_addr          (current_chip_addr         ),
        .current_bank_addr          (current_bank_addr         ),
        .current_row_addr           (current_row_addr          ),
        .current_multicast_req      (current_multicast_req     ),
        .all_banks_closed           (all_banks_closed          ),
        .bank_info_valid            (bank_info_valid           ),
        .bank_is_open               (bank_is_open              ),
        .row_is_open                (row_is_open               ),
        .current_bank_info_valid    (current_bank_info_valid   ),
        .current_bank_is_open       (current_bank_is_open      ),
        .current_row_is_open        (current_row_is_open       ),
        .zq_cal_req                 (zq_cal_req                ),
        .add_lat_on                 (add_lat_on                ),
        .can_al_activate_write      (can_al_activate_write     ),
        .can_al_activate_read       (can_al_activate_read      ),
        .can_activate               (can_activate              ),
        .can_precharge              (can_precharge             ),
        .can_read_current           (can_read_current          ),
        .can_write_current          (can_write_current         ),
        .can_activate_current       (can_activate_current      ),
        .can_precharge_current      (can_precharge_current     ),
        .can_lmr                    (can_lmr                   ),
        .can_precharge_all          (can_precharge_all         ),
        .can_refresh                (can_refresh               ),
        .can_enter_power_down       (can_enter_power_down      ),
        .can_exit_power_saving_mode (can_exit_power_saving_mode),
        .can_self_rfsh              (can_self_rfsh             ),
        .cam_full                   (cam_full                  ),
        .auto_refresh_req           (auto_refresh_req          ),
        .auto_refresh_chip          (auto_refresh_chip         ),
        .local_refresh_req          (local_refresh_req         ),
        .local_refresh_chip         (local_refresh_chip        ),
        .local_refresh_ack          (local_refresh_ack         ),
        .power_down_req             (power_down_req            ),
        .local_power_down_ack       (local_power_down_ack      ),
        .local_self_rfsh_req        (local_self_rfsh_req       ),
        .local_self_rfsh_chip       (local_self_rfsh_chip      ),
        .local_self_rfsh_ack        (local_self_rfsh_ack       ),
        .do_ecc                     (do_ecc                    ),
        .do_partial                 (do_partial                ),
        .ecc_fetch_error_addr       (ecc_fetch_error_addr      ),
        .wdata_is_partial           (wdata_is_partial          ),
        .ecc_single_bit_error       (ecc_single_bit_error      ),
        .rmw_data_ready             (rmw_data_ready            ),
        .ecc_error_chip_addr        (ecc_error_chip_addr       ),
        .ecc_error_bank_addr        (ecc_error_bank_addr       ),
        .ecc_error_row_addr         (ecc_error_row_addr        ),
        .ecc_error_col_addr         (ecc_error_col_addr        ),
        .do_write_r                 (do_write                  ),
        .do_read_r                  (do_read                   ),
        .do_auto_precharge_r        (do_auto_precharge         ),
        .do_burst_chop_r            (do_burst_chop             ),
        .do_activate_r              (do_activate               ),
        .do_precharge_r             (do_precharge              ),
        .do_refresh_r               (do_refresh                ),
        .do_power_down_r            (do_power_down             ),
        .do_self_rfsh_r             (do_self_rfsh              ),
        .do_lmr_r                   (do_lmr                    ),
        .do_precharge_all_r         (do_precharge_all          ),
        .do_zqcal_r                 (do_zqcal                  ),
        .rdwr_data_valid_r          (rdwr_data_valid           ),
        .to_chip_r                  (to_chip                   ),
        .to_bank_addr_r             (to_bank_addr              ),
        .to_row_addr_r              (to_row_addr               ),
        .to_col_addr_r              (to_col_addr               ),
        .do_write_var_r             (do_write_var              ),
        .do_read_var_r              (do_read_var               ),
        .do_auto_precharge_var_r    (do_auto_precharge_var     ),
        .do_burst_chop_var_r        (do_burst_chop_var         ),
        .do_activate_var_r          (do_activate_var           ),
        .do_precharge_var_r         (do_precharge_var          ),
        .do_refresh_var_r           (do_refresh_var            ),
        .do_power_down_var_r        (do_power_down_var         ),
        .do_self_rfsh_var_r         (do_self_rfsh_var          ),
        .do_lmr_var_r               (do_lmr_var                ),
        .do_precharge_all_var_r     (do_precharge_all_var      ),
        .do_zqcal_var_r             (do_zqcal_var              ),
        .rdwr_data_valid_var_r      (rdwr_data_valid_var       ),
        .to_chip_var_r              (to_chip_var               ),
        .to_bank_addr_var_r         (to_bank_addr_var          ),
        .to_row_addr_var_r          (to_row_addr_var           ),
        .to_col_addr_var_r          (to_col_addr_var           ),
        .addr_order                 (addr_order                ),
        .regdimm_enable             (regdimm_enable            )
    );

//==============================================================================
// Output logic
//------------------------------------------------------------------------------
// 
// Address and command decode
// ODT generation
// Write data timing 
//==============================================================================


    alt_ddrx_addr_cmd  # (
        .MEM_IF_CS_WIDTH     (MEM_IF_CS_WIDTH         ),
        .MEM_IF_CKE_WIDTH    (MEM_IF_CKE_WIDTH        ),
        .MEM_IF_ADDR_WIDTH   (MEM_IF_ADDR_WIDTH       ),
        .MEM_IF_ROW_WIDTH    (MEM_IF_ROW_WIDTH        ),
        .MEM_IF_COL_WIDTH    (MEM_IF_COL_WIDTH        ),
        .MEM_IF_BA_WIDTH     (MEM_IF_BA_WIDTH         ),
        .MEM_TYPE            (MEM_TYPE                ),
        .MEM_IF_PCHADDR_BIT  (MEM_IF_PCHADDR_BIT      ),
        .CTL_OUTPUT_REGD     (CTL_OUTPUT_REGD         ),
        .DWIDTH_RATIO        (DWIDTH_RATIO            )
    ) addr_cmd_inst (
        .ctl_clk             (ctl_clk                 ),
        .ctl_reset_n         (resynced_ctl_reset_n[12]),
        .ctl_cal_success     (ctl_cal_success         ),
        .do_write            (do_write_var            ),
        .do_read             (do_read_var             ),
        .do_auto_precharge   (do_auto_precharge_var   ),
        .do_burst_chop       (do_burst_chop_var       ),
        .do_activate         (do_activate_var         ),
        .do_precharge        (do_precharge_var        ),
        .do_refresh          (do_refresh_var          ),
        .do_power_down       (do_power_down_var       ),
        .do_self_rfsh        (do_self_rfsh_var        ),
        .do_lmr              (do_lmr_var              ),
        .do_precharge_all    (do_precharge_all_var    ),
        .do_zqcal            (do_zqcal_var            ),
        .to_chip             (to_chip_var             ),
        .to_bank_addr        (to_bank_addr_var        ),
        .to_row_addr         (to_row_addr_var         ),
        .to_col_addr         (to_col_addr_var         ),
        .afi_cke             (afi_cke                 ),
        .afi_cs_n            (afi_cs_n                ),
        .afi_ras_n           (afi_ras_n               ),
        .afi_cas_n           (afi_cas_n               ),
        .afi_we_n            (afi_we_n                ),
        .afi_ba              (afi_ba                  ),
        .afi_addr            (afi_addr                ),
        .afi_rst_n           (afi_rst_n               )
    );
    
    alt_ddrx_afi_block # (
        .MEM_IF_DQ_WIDTH     (MEM_IF_DQ_WIDTH         ),
        .MEM_IF_DQS_WIDTH    (MEM_IF_DQS_WIDTH        ),
        .MEM_IF_DM_WIDTH     (MEM_IF_DM_WIDTH         ),
        .DWIDTH_RATIO        (DWIDTH_RATIO            ),
        .CTL_OUTPUT_REGD     (CTL_OUTPUT_REGD         ),
        .CTL_ECC_ENABLED     (CTL_ECC_ENABLED         )
    ) afi_block_inst (
        .ctl_clk             (ctl_clk                 ),
        .ctl_reset_n         (resynced_ctl_reset_n[13]),
        .afi_wlat            (afi_wlat                ),
        .do_write            (do_write_var            ),
        .do_read             (do_read_var             ),
        .do_burst_chop       (do_burst_chop_var       ),
        .rdwr_data_valid     (rdwr_data_valid_var     ),
        .ecc_wdata           (ecc_wdata               ),
        .ecc_be              (ecc_be                  ),
        .ecc_wdata_fifo_read (ecc_wdata_fifo_read     ),
        .afi_dqs_burst       (afi_dqs_burst           ),
        .afi_wdata_valid     (afi_wdata_valid         ),
        .afi_wdata           (afi_wdata               ),
        .afi_dm              (afi_dm                  ),
        .afi_doing_read      (afi_doing_read          ),
        .afi_doing_read_full (afi_doing_read_full     )
    );
    
    alt_ddrx_odt_gen # (
        .DWIDTH_RATIO         (DWIDTH_RATIO            ),
        .MEM_TYPE             (MEM_TYPE                ),
        .MEM_IF_CS_WIDTH      (MEM_IF_CS_WIDTH         ),
        .MEM_IF_ODT_WIDTH     (MEM_IF_ODT_WIDTH        ),
        .CTL_ODT_ENABLED      (CTL_ODT_ENABLED         ),
        .CTL_OUTPUT_REGD      (CTL_OUTPUT_REGD         ),
        .MEM_IF_CS_PER_DIMM   (MEM_IF_CS_PER_DIMM      ),
        .MEMORY_BURSTLENGTH   (MEMORY_BURSTLENGTH      ),
        .ADD_LAT_BUS_WIDTH    (ADD_LAT_BUS_WIDTH       ),
        .CTL_REGDIMM_ENABLED  (CTL_REGDIMM_ENABLED     ),
        .TCL_BUS_WIDTH        (TCL_BUS_WIDTH           ),
        .CAS_WR_LAT_BUS_WIDTH (CAS_WR_LAT_BUS_WIDTH    )
    ) odt_gen_inst (
        .ctl_clk              (ctl_clk                 ),
        .ctl_reset_n          (resynced_ctl_reset_n[14]),
        .mem_tcl              (mem_tcl                 ),
        .mem_cas_wr_lat       (mem_cas_wr_lat          ),
        .mem_add_lat          (mem_add_lat             ),
        .do_write             (do_write_var            ),
        .do_read              (do_read_var             ),
        .to_chip              (to_chip_var             ),
        .afi_odt              (afi_odt                 )
    );

//==============================================================================
// ECC logic
//------------------------------------------------------------------------------
// 
// ECC generation
//==============================================================================

    alt_ddrx_ecc # (
        .LOCAL_DATA_WIDTH        (INTERNAL_DATA_WIDTH     ),
        .DWIDTH_RATIO            (DWIDTH_RATIO            ),
        .CTL_ECC_ENABLED         (CTL_ECC_ENABLED         ),
        .CTL_ECC_RMW_ENABLED     (CTL_ECC_RMW_ENABLED     ),
        .CTL_ECC_CSR_ENABLED     (CTL_ECC_CSR_ENABLED     ),
        .CTL_ECC_MULTIPLES_40_72 (CTL_ECC_MULTIPLES_40_72 ),
        .MEMORY_BURSTLENGTH      (MEMORY_BURSTLENGTH      ),
        .MEM_IF_CS_WIDTH         (MEM_IF_CS_WIDTH         ),
        .MEM_IF_CHIP_BITS        (MEM_IF_CHIP_BITS        ),
        .MEM_IF_ROW_WIDTH        (MEM_IF_ROW_WIDTH        ),
        .MEM_IF_COL_WIDTH        (MEM_IF_COL_WIDTH        ),
        .MEM_IF_BA_WIDTH         (MEM_IF_BA_WIDTH         ),
        .MEM_IF_DQ_WIDTH         (MEM_IF_DQ_WIDTH         )
    ) ecc_inst (
        .ctl_clk                 (ctl_clk                 ),
        .ctl_reset_n             (resynced_ctl_reset_n[15]),
        .do_read                 (do_read                 ),
        .do_write                (do_write                ),
        .do_ecc                  (do_ecc                  ),
        .do_partial              (do_partial              ),
        .do_burst_chop           (do_burst_chop           ),
        .rdwr_data_valid         (rdwr_data_valid         ),
        .ecc_fetch_error_addr    (ecc_fetch_error_addr    ),
        .to_chip                 (to_chip                 ),
        .to_bank_addr            (to_bank_addr            ),
        .to_row_addr             (to_row_addr             ),
        .to_col_addr             (to_col_addr             ),
        .afi_rdata               (afi_rdata               ),
        .afi_rdata_valid         (afi_rdata_valid         ),
        .ecc_wdata_fifo_read     (ecc_wdata_fifo_read     ),
        .write_req_to_wfifo      (write_req_to_wfifo      ),
        .be_to_wfifo             (be_to_wfifo             ),
        .wdata_fifo_be           (wdata_fifo_be           ),
        .wdata_fifo_wdata        (wdata_fifo_wdata        ),
        .ecc_enable              (ecc_enable              ),
        .ecc_enable_auto_corr    (ecc_enable_auto_corr    ),
        .ecc_gen_sbe             (ecc_gen_sbe             ),
        .ecc_gen_dbe             (ecc_gen_dbe             ),
        .ecc_enable_intr         (ecc_enable_intr         ),
        .ecc_mask_sbe_intr       (ecc_mask_sbe_intr       ),
        .ecc_mask_dbe_intr       (ecc_mask_dbe_intr       ),
        .ecc_clear               (ecc_clear               ),
        .ecc_single_bit_error    (ecc_single_bit_error    ),
        .ecc_error_chip_addr     (ecc_error_chip_addr     ),
        .ecc_error_bank_addr     (ecc_error_bank_addr     ),
        .ecc_error_row_addr      (ecc_error_row_addr      ),
        .ecc_error_col_addr      (ecc_error_col_addr      ),
        .rmw_data_ready          (rmw_data_ready          ),
        .wdata_is_partial        (wdata_is_partial        ),
        .ecc_interrupt           (ecc_interrupt           ),
        .ecc_rdata_valid         (ecc_rdata_valid         ),
        .ecc_rdata_error         (ecc_rdata_error         ),
        .ecc_rdata               (ecc_rdata               ),
        .ecc_be                  (ecc_be                  ),
        .ecc_wdata               (ecc_wdata               ),
        .wdata_fifo_read         (wdata_fifo_read         ),
        .ecc_sbe_error           (ecc_sbe_error           ),
        .ecc_dbe_error           (ecc_dbe_error           ),
        .ecc_sbe_count           (ecc_sbe_count           ),
        .ecc_dbe_count           (ecc_dbe_count           ),
        .ecc_error_addr          (ecc_error_addr          )
    );

//==============================================================================
// CSR logic
//------------------------------------------------------------------------------
// 
//==============================================================================

    alt_ddrx_csr # (
        .DWIDTH_RATIO                (DWIDTH_RATIO             ),
        .CTL_CSR_ENABLED             (CTL_CSR_ENABLED          ),
        .CTL_ECC_CSR_ENABLED         (CTL_ECC_CSR_ENABLED      ),
        .CSR_ADDR_WIDTH              (CSR_ADDR_WIDTH           ),
        .CSR_DATA_WIDTH              (CSR_DATA_WIDTH           ),
        .MEM_IF_CLK_PAIR_COUNT       (MEM_IF_CLK_PAIR_COUNT    ),
        .MEM_IF_DQS_WIDTH            (MEM_IF_DQS_WIDTH         ),
        .MEM_IF_CS_WIDTH             (MEM_IF_CS_WIDTH          ),
        .MEM_IF_CHIP_BITS            (MEM_IF_CHIP_BITS         ),
        .MEM_IF_ROW_WIDTH            (MEM_IF_ROW_WIDTH         ),
        .MEM_IF_COL_WIDTH            (MEM_IF_COL_WIDTH         ),
        .MEM_IF_BA_WIDTH             (MEM_IF_BA_WIDTH          ),
        .CTL_ECC_ENABLED             (CTL_ECC_ENABLED          ),
        .CTL_ECC_RMW_ENABLED         (CTL_ECC_RMW_ENABLED      ),
        .CTL_REGDIMM_ENABLED         (CTL_REGDIMM_ENABLED      ),
        .CAS_WR_LAT_BUS_WIDTH        (CAS_WR_LAT_BUS_WIDTH     ),
        .ADD_LAT_BUS_WIDTH           (ADD_LAT_BUS_WIDTH        ),
        .TCL_BUS_WIDTH               (TCL_BUS_WIDTH            ),
        .TRRD_BUS_WIDTH              (TRRD_BUS_WIDTH           ),
        .TFAW_BUS_WIDTH              (TFAW_BUS_WIDTH           ),
        .TRFC_BUS_WIDTH              (TRFC_BUS_WIDTH           ),
        .TREFI_BUS_WIDTH             (TREFI_BUS_WIDTH          ),
        .TRCD_BUS_WIDTH              (TRCD_BUS_WIDTH           ),
        .TRP_BUS_WIDTH               (TRP_BUS_WIDTH            ),
        .TWR_BUS_WIDTH               (TWR_BUS_WIDTH            ),
        .TWTR_BUS_WIDTH              (TWTR_BUS_WIDTH           ),
        .TRTP_BUS_WIDTH              (TRTP_BUS_WIDTH           ),
        .TRAS_BUS_WIDTH              (TRAS_BUS_WIDTH           ),
        .TRC_BUS_WIDTH               (TRC_BUS_WIDTH            ),
        .AUTO_PD_BUS_WIDTH           (AUTO_PD_BUS_WIDTH        ),
        .MEM_CAS_WR_LAT              (MEM_CAS_WR_LAT           ),
        .MEM_ADD_LAT                 (MEM_ADD_LAT              ),
        .MEM_TCL                     (MEM_TCL                  ),
        .MEM_TRRD                    (MEM_TRRD                 ),
        .MEM_TFAW                    (MEM_TFAW                 ),
        .MEM_TRFC                    (MEM_TRFC                 ),
        .MEM_TREFI                   (MEM_TREFI                ),
        .MEM_TRCD                    (MEM_TRCD                 ),
        .MEM_TRP                     (MEM_TRP                  ),
        .MEM_TWR                     (MEM_TWR                  ),
        .MEM_TWTR                    (MEM_TWTR                 ),
        .MEM_TRTP                    (MEM_TRTP                 ),
        .MEM_TRAS                    (MEM_TRAS                 ),
        .MEM_TRC                     (MEM_TRC                  ),
        .MEM_AUTO_PD_CYCLES          (MEM_AUTO_PD_CYCLES       ),
        .ADDR_ORDER                  (ADDR_ORDER               ),
        .MEM_IF_CSR_COL_WIDTH        (MEM_IF_CSR_COL_WIDTH     ),
        .MEM_IF_CSR_ROW_WIDTH        (MEM_IF_CSR_ROW_WIDTH     ),
        .MEM_IF_CSR_BANK_WIDTH       (MEM_IF_CSR_BANK_WIDTH    ),
        .MEM_IF_CSR_CS_WIDTH         (MEM_IF_CSR_CS_WIDTH      )
    ) csr_inst (
        .ctl_clk                     (ctl_clk                  ),
        .ctl_reset_n                 (resynced_ctl_reset_n[16] ),
        .csr_addr                    (csr_addr                 ),
        .csr_be                      (csr_be                   ),
        .csr_write_req               (csr_write_req            ),
        .csr_wdata                   (csr_wdata                ),
        .csr_read_req                (csr_read_req             ),
        .csr_rdata                   (csr_rdata                ),
        .csr_rdata_valid             (csr_rdata_valid          ),
        .csr_waitrequest             (csr_waitrequest          ),
        .ctl_cal_success             (ctl_cal_success          ),
        .ctl_cal_fail                (ctl_cal_fail             ),
        .local_power_down_ack        (local_power_down_ack     ),
        .local_self_rfsh_ack         (local_self_rfsh_ack      ),
        .ecc_sbe_error               (ecc_sbe_error            ),
        .ecc_dbe_error               (ecc_dbe_error            ),
        .ecc_sbe_count               (ecc_sbe_count            ),
        .ecc_dbe_count               (ecc_dbe_count            ),
        .ecc_error_addr              (ecc_error_addr           ),
        .ctl_cal_req                 (ctl_cal_req              ),
        .ctl_mem_clk_disable         (ctl_mem_clk_disable      ),
        .ctl_cal_byte_lane_sel_n     (ctl_cal_byte_lane_sel_n  ),
        .mem_cas_wr_lat              (mem_cas_wr_lat           ),
        .mem_add_lat                 (mem_add_lat              ),
        .mem_tcl                     (mem_tcl                  ),
        .mem_trrd                    (mem_trrd                 ),
        .mem_tfaw                    (mem_tfaw                 ),
        .mem_trfc                    (mem_trfc                 ),
        .mem_trefi                   (mem_trefi                ),
        .mem_trcd                    (mem_trcd                 ),
        .mem_trp                     (mem_trp                  ),
        .mem_twr                     (mem_twr                  ),
        .mem_twtr                    (mem_twtr                 ),
        .mem_trtp                    (mem_trtp                 ),
        .mem_tras                    (mem_tras                 ),
        .mem_trc                     (mem_trc                  ),
        .mem_auto_pd_cycles          (mem_auto_pd_cycles       ),
        .addr_order                  (addr_order               ),
        .col_width_from_csr          (col_width_from_csr       ),
        .row_width_from_csr          (row_width_from_csr       ),
        .bank_width_from_csr         (bank_width_from_csr      ),
        .cs_width_from_csr           (cs_width_from_csr        ),
        .ecc_enable                  (ecc_enable               ),
        .ecc_enable_auto_corr        (ecc_enable_auto_corr     ),
        .ecc_gen_sbe                 (ecc_gen_sbe              ),
        .ecc_gen_dbe                 (ecc_gen_dbe              ),
        .ecc_enable_intr             (ecc_enable_intr          ),
        .ecc_mask_sbe_intr           (ecc_mask_sbe_intr        ),
        .ecc_mask_dbe_intr           (ecc_mask_dbe_intr        ),
        .ecc_clear                   (ecc_clear                ),
        .regdimm_enable              (regdimm_enable           )
    );

    function integer log2;  //constant function
           input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
    endfunction

endmodule
