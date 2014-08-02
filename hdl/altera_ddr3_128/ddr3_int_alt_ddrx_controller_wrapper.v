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
// Title         : DDR controller wrapper
//
// File          : alt_ddrx_controller_wrapper.v
//
// Abstract      : This file is a wrapper that configures DDRx controller
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
//
module ddr3_int_alt_ddrx_controller_wrapper (
    ctl_clk,
    ctl_reset_n,
    ctl_half_clk,
    ctl_half_clk_reset_n,
    
    local_ready,
    local_read_req,
    local_write_req,
    local_wdata_req,
    local_size,
    local_burstbegin,
    local_addr,
    local_rdata_valid,
    local_rdata_error,
    local_rdata,
    local_wdata,
    local_be,
    local_autopch_req,
    local_multicast,
    local_init_done,
    local_refresh_req,
    local_refresh_chip,
    local_refresh_ack,
    local_self_rfsh_req,
    local_self_rfsh_chip,
    local_self_rfsh_ack,
    local_power_down_ack,
    
    ctl_cal_success,
    ctl_cal_fail,
    ctl_cal_req,
    ctl_mem_clk_disable,
    ctl_cal_byte_lane_sel_n,
    
    afi_cke,
    afi_cs_n,
    afi_ras_n,
    afi_cas_n,
    afi_we_n,
    afi_ba,
    afi_addr,
    afi_odt,
    afi_rst_n,
    afi_dqs_burst,
    afi_wdata_valid,
    afi_wdata,
    afi_dm,
    afi_wlat,
    afi_doing_read,
    afi_rdata,
    afi_rdata_valid,
    
    csr_write_req,
    csr_read_req,
    csr_addr,
    csr_be,
    csr_wdata,
    csr_waitrequest,
    csr_rdata,
    csr_rdata_valid,
    
    ecc_interrupt,

    bank_information,
    bank_open
    
);
    
	//Inserted Generics
          localparam MEM_TYPE                       = "DDR3";
          localparam LOCAL_SIZE_WIDTH               = 6;
          localparam LOCAL_ADDR_WIDTH               = 24;
          localparam LOCAL_DATA_WIDTH               = 128;
          localparam LOCAL_IF_TYPE                  = "AVALON";
          localparam MEM_IF_CS_WIDTH                = 1;
          localparam MEM_IF_CHIP_BITS               = 1;
          localparam MEM_IF_CKE_WIDTH               = 1;
          localparam MEM_IF_ODT_WIDTH               = 1;
          localparam MEM_IF_ADDR_WIDTH              = 13;
          localparam MEM_IF_ROW_WIDTH               = 13;
          localparam MEM_IF_COL_WIDTH               = 10;
          localparam MEM_IF_BA_WIDTH                = 3;
          localparam MEM_IF_DQS_WIDTH               = 4;
          localparam MEM_IF_DQ_WIDTH                = 32;
          localparam MEM_IF_DM_WIDTH                = 4;
          localparam MEM_IF_CLK_PAIR_COUNT          = 1;
          localparam MEM_IF_CS_PER_DIMM             = 1;
          localparam DWIDTH_RATIO                   = 4;
          localparam CTL_LOOK_AHEAD_DEPTH           = 8;
          localparam CTL_CMD_QUEUE_DEPTH            = 8;
          localparam CTL_HRB_ENABLED                = 0;
          localparam CTL_ECC_ENABLED                = 0;
          localparam CTL_ECC_RMW_ENABLED            = 0;
          localparam CTL_ECC_CSR_ENABLED            = 0;
          localparam CTL_CSR_ENABLED                = 0;
          localparam CTL_ODT_ENABLED                = 1;
          localparam CSR_ADDR_WIDTH                 = 16;
          localparam CSR_DATA_WIDTH                 = 32;
          localparam CTL_OUTPUT_REGD                = 0;
          localparam MEM_CAS_WR_LAT                 = 7;
          localparam MEM_ADD_LAT                    = 0;
          localparam MEM_TCL                        = 9;
          localparam MEM_TRRD                       = 2;
          localparam MEM_TFAW                       = 10;
          localparam MEM_TRFC                       = 34;
          localparam MEM_TREFI                      = 2341;
          localparam MEM_TRCD                       = 5;
          localparam MEM_TRP                        = 5;
          localparam MEM_TWR                        = 5;
          localparam MEM_TWTR                       = 4;
          localparam MEM_TRTP                       = 3;
          localparam MEM_TRAS                       = 11;
          localparam MEM_TRC                        = 15;
          localparam ADDR_ORDER                     = 0;
          localparam MEM_AUTO_PD_CYCLES             = 0;
          localparam MEM_IF_RD_TO_WR_TURNAROUND_OCT = 2;
          localparam MEM_IF_WR_TO_RD_TURNAROUND_OCT = 0;
          localparam CTL_ECC_MULTIPLES_40_72        = 0;
          localparam CTL_USR_REFRESH                = 0;
          localparam CTL_REGDIMM_ENABLED            = 0;
          localparam MULTICAST_WR_EN                = 0;
          localparam LOW_LATENCY                    = 0;
          localparam CTL_DYNAMIC_BANK_ALLOCATION    = 0;
          localparam CTL_DYNAMIC_BANK_NUM           = 4;
          localparam ENABLE_BURST_MERGE             = 0;
    
    input                               ctl_clk;
    input                               ctl_reset_n;
    input                               ctl_half_clk;
    input                               ctl_half_clk_reset_n;
    
    output                              local_ready;
    input                               local_read_req;
    input                               local_write_req;
    output                              local_wdata_req;
    input  [LOCAL_SIZE_WIDTH-1:0]       local_size;
    input                               local_burstbegin;
    input  [LOCAL_ADDR_WIDTH-1:0]       local_addr;
    output                              local_rdata_valid;
    output                              local_rdata_error;
    output [LOCAL_DATA_WIDTH-1:0]       local_rdata;
    input  [LOCAL_DATA_WIDTH-1:0]       local_wdata;
    input  [LOCAL_DATA_WIDTH/8-1:0]     local_be;
    input                               local_autopch_req;
    input                               local_multicast;
    output                              local_init_done;
    input                               local_refresh_req;
    input  [MEM_IF_CS_WIDTH-1:0]        local_refresh_chip;
    output                              local_refresh_ack;
    input                               local_self_rfsh_req;
    input  [MEM_IF_CS_WIDTH-1:0]        local_self_rfsh_chip;
    output                              local_self_rfsh_ack;
    output                              local_power_down_ack;
    
    input                                                   ctl_cal_success;
    input                                                   ctl_cal_fail;
    output                                                  ctl_cal_req;
    output  [MEM_IF_CLK_PAIR_COUNT - 1:0]                   ctl_mem_clk_disable;
    output  [(MEM_IF_DQS_WIDTH*MEM_IF_CS_WIDTH) - 1:0]      ctl_cal_byte_lane_sel_n;
    
    output  [(MEM_IF_CKE_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_cke;
    output  [(MEM_IF_CS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_cs_n;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_ras_n;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_cas_n;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_we_n;
    output  [(MEM_IF_BA_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_ba;
    output  [(MEM_IF_ADDR_WIDTH * (DWIDTH_RATIO/2)) - 1:0]  afi_addr;
    output  [(MEM_IF_ODT_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_odt;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_rst_n;
    output  [(MEM_IF_DQS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_dqs_burst;
    output  [(MEM_IF_DQS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_wdata_valid;
    output  [(MEM_IF_DQ_WIDTH*DWIDTH_RATIO) - 1:0]          afi_wdata;
    output  [(MEM_IF_DM_WIDTH*DWIDTH_RATIO) - 1:0]          afi_dm;
    input   [4:0]                                           afi_wlat;
    output  [(MEM_IF_DQS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_doing_read;
    input   [(MEM_IF_DQ_WIDTH * DWIDTH_RATIO) - 1:0]        afi_rdata;
    input   [(DWIDTH_RATIO/2) - 1:0]                        afi_rdata_valid;
    
    input                                                   csr_write_req;
    input                                                   csr_read_req;
    input   [CSR_ADDR_WIDTH - 1 : 0]                        csr_addr;
    input   [(CSR_DATA_WIDTH / 8) - 1 : 0]                  csr_be;
    input   [CSR_DATA_WIDTH - 1 : 0]                        csr_wdata;
    output                                                  csr_waitrequest;
    output  [CSR_DATA_WIDTH - 1 : 0]                        csr_rdata;
    output                                                  csr_rdata_valid;
    
    output                                                  ecc_interrupt;

    output  [(MEM_IF_CS_WIDTH * (2 ** MEM_IF_BA_WIDTH) * MEM_IF_ROW_WIDTH) - 1:0]  bank_information;
    output  [(MEM_IF_CS_WIDTH * (2 ** MEM_IF_BA_WIDTH)) - 1:0]                     bank_open;
    
alt_ddrx_controller # (
    
    .MEM_TYPE                       ( MEM_TYPE                       ),
    .LOCAL_SIZE_WIDTH               ( LOCAL_SIZE_WIDTH               ),
    .LOCAL_ADDR_WIDTH               ( LOCAL_ADDR_WIDTH               ),
    .LOCAL_DATA_WIDTH               ( LOCAL_DATA_WIDTH               ),
    .LOCAL_IF_TYPE                  ( LOCAL_IF_TYPE                  ),
    .MEM_IF_CS_WIDTH                ( MEM_IF_CS_WIDTH                ),
    .MEM_IF_CHIP_BITS               ( MEM_IF_CHIP_BITS               ),
    .MEM_IF_CKE_WIDTH               ( MEM_IF_CKE_WIDTH               ),
    .MEM_IF_ODT_WIDTH               ( MEM_IF_ODT_WIDTH               ),
    .MEM_IF_ADDR_WIDTH              ( MEM_IF_ADDR_WIDTH              ),
    .MEM_IF_ROW_WIDTH               ( MEM_IF_ROW_WIDTH               ),
    .MEM_IF_COL_WIDTH               ( MEM_IF_COL_WIDTH               ),
    .MEM_IF_BA_WIDTH                ( MEM_IF_BA_WIDTH                ),
    .MEM_IF_DQS_WIDTH               ( MEM_IF_DQS_WIDTH               ),
    .MEM_IF_DQ_WIDTH                ( MEM_IF_DQ_WIDTH                ),
    .MEM_IF_DM_WIDTH                ( MEM_IF_DM_WIDTH                ),
    .MEM_IF_CLK_PAIR_COUNT          ( MEM_IF_CLK_PAIR_COUNT          ),
    .MEM_IF_CS_PER_DIMM             ( MEM_IF_CS_PER_DIMM             ),
    .DWIDTH_RATIO                   ( DWIDTH_RATIO                   ),
    .CTL_LOOK_AHEAD_DEPTH           ( CTL_LOOK_AHEAD_DEPTH           ),
    .CTL_CMD_QUEUE_DEPTH            ( CTL_CMD_QUEUE_DEPTH            ),
    .CTL_HRB_ENABLED                ( CTL_HRB_ENABLED                ),
    .CTL_ECC_ENABLED                ( CTL_ECC_ENABLED                ),
    .CTL_ECC_RMW_ENABLED            ( CTL_ECC_RMW_ENABLED            ),
    .CTL_ECC_CSR_ENABLED            ( CTL_ECC_CSR_ENABLED            ),
    .CTL_ECC_MULTIPLES_40_72        ( CTL_ECC_MULTIPLES_40_72        ),
    .CTL_CSR_ENABLED                ( CTL_CSR_ENABLED                ),
    .CTL_ODT_ENABLED                ( CTL_ODT_ENABLED                ),
    .CTL_REGDIMM_ENABLED            ( CTL_REGDIMM_ENABLED            ),
    .CSR_ADDR_WIDTH                 ( CSR_ADDR_WIDTH                 ),
    .CSR_DATA_WIDTH                 ( CSR_DATA_WIDTH                 ),
    .CTL_OUTPUT_REGD                ( CTL_OUTPUT_REGD                ),
    .CTL_USR_REFRESH                ( CTL_USR_REFRESH                ),
    .MEM_CAS_WR_LAT                 ( MEM_CAS_WR_LAT                 ),
    .MEM_ADD_LAT                    ( MEM_ADD_LAT                    ),
    .MEM_TCL                        ( MEM_TCL                        ),
    .MEM_TRRD                       ( MEM_TRRD                       ),
    .MEM_TFAW                       ( MEM_TFAW                       ),
    .MEM_TRFC                       ( MEM_TRFC                       ),
    .MEM_TREFI                      ( MEM_TREFI                      ),
    .MEM_TRCD                       ( MEM_TRCD                       ),
    .MEM_TRP                        ( MEM_TRP                        ),
    .MEM_TWR                        ( MEM_TWR                        ),
    .MEM_TWTR                       ( MEM_TWTR                       ),
    .MEM_TRTP                       ( MEM_TRTP                       ),
    .MEM_TRAS                       ( MEM_TRAS                       ),
    .MEM_TRC                        ( MEM_TRC                        ),
    .MEM_AUTO_PD_CYCLES             ( MEM_AUTO_PD_CYCLES             ),
    .MEM_IF_RD_TO_WR_TURNAROUND_OCT ( MEM_IF_RD_TO_WR_TURNAROUND_OCT ),
    .MEM_IF_WR_TO_RD_TURNAROUND_OCT ( MEM_IF_WR_TO_RD_TURNAROUND_OCT ),
    .ADDR_ORDER                     ( ADDR_ORDER                     ),
    .MULTICAST_WR_EN                ( MULTICAST_WR_EN                ),
    .LOW_LATENCY                    ( LOW_LATENCY                    ),
    .CTL_DYNAMIC_BANK_ALLOCATION    ( CTL_DYNAMIC_BANK_ALLOCATION    ),
    .CTL_DYNAMIC_BANK_NUM           ( CTL_DYNAMIC_BANK_NUM           ),
    .ENABLE_BURST_MERGE             ( ENABLE_BURST_MERGE             )
    
) alt_ddrx_controller_inst (
    
    .ctl_clk                        ( ctl_clk                        ),
    .ctl_reset_n                    ( ctl_reset_n                    ),
    .ctl_half_clk                   ( ctl_half_clk                   ),
    .ctl_half_clk_reset_n           ( ctl_half_clk_reset_n           ),
    .local_ready                    ( local_ready                    ),
    .local_read_req                 ( local_read_req                 ),
    .local_write_req                ( local_write_req                ),
    .local_wdata_req                ( local_wdata_req                ),
    .local_size                     ( local_size                     ),
    .local_burstbegin               ( local_burstbegin               ),
    .local_addr                     ( local_addr                     ),
    .local_rdata_valid              ( local_rdata_valid              ),
    .local_rdata_error              ( local_rdata_error              ),
    .local_rdata                    ( local_rdata                    ),
    .local_wdata                    ( local_wdata                    ),
    .local_be                       ( local_be                       ),
    .local_autopch_req              ( local_autopch_req              ),
    .local_multicast                ( local_multicast                ),
    .local_init_done                ( local_init_done                ),
    .local_refresh_req              ( local_refresh_req              ),
    .local_refresh_chip             ( local_refresh_chip             ),
    .local_refresh_ack              ( local_refresh_ack              ),
    .local_self_rfsh_req            ( local_self_rfsh_req            ),
    .local_self_rfsh_chip           ( local_self_rfsh_chip           ),
    .local_self_rfsh_ack            ( local_self_rfsh_ack            ),
    .local_power_down_ack           ( local_power_down_ack           ),
    .ctl_cal_success                ( ctl_cal_success                ),
    .ctl_cal_fail                   ( ctl_cal_fail                   ),
    .ctl_cal_req                    ( ctl_cal_req                    ),
    .ctl_mem_clk_disable            ( ctl_mem_clk_disable            ),
    .ctl_cal_byte_lane_sel_n        ( ctl_cal_byte_lane_sel_n        ),
    .afi_cke                        ( afi_cke                        ),
    .afi_cs_n                       ( afi_cs_n                       ),
    .afi_ras_n                      ( afi_ras_n                      ),
    .afi_cas_n                      ( afi_cas_n                      ),
    .afi_we_n                       ( afi_we_n                       ),
    .afi_ba                         ( afi_ba                         ),
    .afi_addr                       ( afi_addr                       ),
    .afi_odt                        ( afi_odt                        ),
    .afi_rst_n                      ( afi_rst_n                      ),
    .afi_dqs_burst                  ( afi_dqs_burst                  ),
    .afi_wdata_valid                ( afi_wdata_valid                ),
    .afi_wdata                      ( afi_wdata                      ),
    .afi_dm                         ( afi_dm                         ),
    .afi_wlat                       ( afi_wlat                       ),
    .afi_doing_read                 ( afi_doing_read                 ),
    .afi_doing_read_full            (                                ),
    .afi_rdata                      ( afi_rdata                      ),
    .afi_rdata_valid                ( afi_rdata_valid                ),
    .csr_write_req                  ( csr_write_req                  ),
    .csr_read_req                   ( csr_read_req                   ),
    .csr_addr                       ( csr_addr                       ),
    .csr_be                         ( csr_be                         ),
    .csr_wdata                      ( csr_wdata                      ),
    .csr_waitrequest                ( csr_waitrequest                ),
    .csr_rdata                      ( csr_rdata                      ),
    .csr_rdata_valid                ( csr_rdata_valid                ),
    .ecc_interrupt                  ( ecc_interrupt                  ),
    .bank_information               ( bank_information               ),
    .bank_open                      ( bank_open                      )
    
);

endmodule
