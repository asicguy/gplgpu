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
// Title         : DDR controller CSR Interface
//
// File          : alt_ddrx_csr.v
//
// Abstract      : CSR Interface for run time reconfigurability
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_csr #
    ( parameter
        DWIDTH_RATIO                = 2,
        CTL_CSR_ENABLED             = 0,
        CTL_ECC_CSR_ENABLED         = 0,
        CSR_ADDR_WIDTH              = 8,
        CSR_DATA_WIDTH              = 32,
        
        MEM_IF_CLK_PAIR_COUNT       = 1,
        MEM_IF_DQS_WIDTH            = 72,
        
        MEM_IF_CS_WIDTH             = 2,
        MEM_IF_CHIP_BITS            = 1,
        MEM_IF_ROW_WIDTH            = 13,      // max supported row bits
        MEM_IF_COL_WIDTH            = 10,      // max supported column bits
        MEM_IF_BA_WIDTH             = 3,       // max supported bank bits
        
        CTL_ECC_ENABLED             = 1,
        CTL_ECC_RMW_ENABLED         = 1,
        CTL_REGDIMM_ENABLED         = 0,
        
        // timing parameter width
        CAS_WR_LAT_BUS_WIDTH        = 4,       // max will be 8 in DDR3
        ADD_LAT_BUS_WIDTH           = 3,       // max will be 6 in DDR2
        TCL_BUS_WIDTH               = 4,       // max will be 11 in DDR3
        TRRD_BUS_WIDTH              = 4,       // 2 - 8
        TFAW_BUS_WIDTH              = 6,       // 6 - 32
        TRFC_BUS_WIDTH              = 8,       // 12 - 140?
        TREFI_BUS_WIDTH             = 13,      // 780 - 6240
        TRCD_BUS_WIDTH              = 4,       // 2 - 11
        TRP_BUS_WIDTH               = 4,       // 2 - 11
        TWR_BUS_WIDTH               = 4,       // 2 - 12
        TWTR_BUS_WIDTH              = 4,       // 1 - 10
        TRTP_BUS_WIDTH              = 4,       // 2 - 8
        TRAS_BUS_WIDTH              = 5,       // 4 - 29
        TRC_BUS_WIDTH               = 6,       // 8 - 40
        AUTO_PD_BUS_WIDTH           = 16,      // same as CSR interface
        
        // timing parameter
        MEM_CAS_WR_LAT              = 0,        // these timing parameter must be set properly for controller to work
        MEM_ADD_LAT                 = 0,        // these timing parameter must be set properly for controller to work
        MEM_TCL                     = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRRD                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TFAW                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRFC                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TREFI                   = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRCD                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRP                     = 0,        // these timing parameter must be set properly for controller to work
        MEM_TWR                     = 0,        // these timing parameter must be set properly for controller to work
        MEM_TWTR                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRTP                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRAS                    = 0,        // these timing parameter must be set properly for controller to work
        MEM_TRC                     = 0,        // these timing parameter must be set properly for controller to work
        MEM_AUTO_PD_CYCLES          = 0,        // these timing parameter must be set properly for controller to work
        
        // parameters used by input interface
        ADDR_ORDER                  = 1,        // normally we will use '1' for chip, bank, row, column arrangement
        MEM_IF_CSR_COL_WIDTH        = 4,
        MEM_IF_CSR_ROW_WIDTH        = 5,
        MEM_IF_CSR_BANK_WIDTH       = 2,
        MEM_IF_CSR_CS_WIDTH         = 2
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // csr interface (Avalon)
        csr_addr,
        csr_be,
        csr_write_req,
        csr_wdata,
        csr_read_req,
        csr_rdata,
        csr_rdata_valid,
        csr_waitrequest,
        
        // input from PHY
        ctl_cal_success,
        ctl_cal_fail,
        
        // input from state machine
        local_power_down_ack,
        local_self_rfsh_ack,
        
        // input from ecc
        ecc_sbe_error,
        ecc_dbe_error,
        ecc_sbe_count,
        ecc_dbe_count,
        ecc_error_addr,
        
        // output to PHY
        ctl_cal_req,
        ctl_mem_clk_disable,
        ctl_cal_byte_lane_sel_n,
        
        // output to timer
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
        
        // output to input interface
        addr_order,
        col_width_from_csr,
        row_width_from_csr,
        bank_width_from_csr,
        cs_width_from_csr,
        
        // output to ecc
        ecc_enable,
        ecc_enable_auto_corr,
        ecc_gen_sbe,
        ecc_gen_dbe,
        ecc_enable_intr,
        ecc_mask_sbe_intr,
        ecc_mask_dbe_intr,
        ecc_clear,

        // output to others
        regdimm_enable
    );

input ctl_clk;
input ctl_reset_n;

input csr_write_req;
input csr_read_req;
input [CSR_ADDR_WIDTH - 1       : 0] csr_addr;
input [CSR_DATA_WIDTH - 1       : 0] csr_wdata;
input [(CSR_DATA_WIDTH / 8) - 1 : 0] csr_be;

output csr_waitrequest;
output csr_rdata_valid;
output [CSR_DATA_WIDTH - 1 : 0] csr_rdata;

// input from AFI
input ctl_cal_success;
input ctl_cal_fail;

// input from state machine
input local_power_down_ack;
input local_self_rfsh_ack;

// input from ecc
input           ecc_sbe_error;
input           ecc_dbe_error;
input  [7  : 0] ecc_sbe_count;
input  [7  : 0] ecc_dbe_count;
input  [31 : 0] ecc_error_addr;

// output to PHY
output                                              ctl_cal_req;
output [MEM_IF_CLK_PAIR_COUNT              - 1 : 0] ctl_mem_clk_disable;
output [MEM_IF_DQS_WIDTH * MEM_IF_CS_WIDTH - 1 : 0] ctl_cal_byte_lane_sel_n;

// output to timer
output [CAS_WR_LAT_BUS_WIDTH - 1 : 0] mem_cas_wr_lat;
output [ADD_LAT_BUS_WIDTH    - 1 : 0] mem_add_lat;
output [TCL_BUS_WIDTH        - 1 : 0] mem_tcl;
output [TRRD_BUS_WIDTH       - 1 : 0] mem_trrd;
output [TFAW_BUS_WIDTH       - 1 : 0] mem_tfaw;
output [TRFC_BUS_WIDTH       - 1 : 0] mem_trfc;
output [TREFI_BUS_WIDTH      - 1 : 0] mem_trefi;
output [TRCD_BUS_WIDTH       - 1 : 0] mem_trcd;
output [TRP_BUS_WIDTH        - 1 : 0] mem_trp;
output [TWR_BUS_WIDTH        - 1 : 0] mem_twr;
output [TWTR_BUS_WIDTH       - 1 : 0] mem_twtr;
output [TRTP_BUS_WIDTH       - 1 : 0] mem_trtp;
output [TRAS_BUS_WIDTH       - 1 : 0] mem_tras;
output [TRC_BUS_WIDTH        - 1 : 0] mem_trc;
output [AUTO_PD_BUS_WIDTH    - 1 : 0] mem_auto_pd_cycles;

// output to input interface
output [1 : 0]                         addr_order;
output [MEM_IF_CSR_COL_WIDTH  - 1 : 0] col_width_from_csr;
output [MEM_IF_CSR_ROW_WIDTH  - 1 : 0] row_width_from_csr;
output [MEM_IF_CSR_BANK_WIDTH - 1 : 0] bank_width_from_csr;
output [MEM_IF_CSR_CS_WIDTH   - 1 : 0] cs_width_from_csr;

//output to ecc
output ecc_enable;
output ecc_enable_auto_corr;
output ecc_gen_sbe;
output ecc_gen_dbe;
output ecc_enable_intr;
output ecc_mask_sbe_intr;
output ecc_mask_dbe_intr;
output ecc_clear;

output regdimm_enable;

wire csr_waitrequest;
wire csr_rdata_valid;
wire [CSR_DATA_WIDTH - 1 : 0] csr_rdata;

reg int_write_req;
reg int_read_req;
reg int_rdata_valid;
reg [8              - 1       : 0] int_addr; // hard-coded to only 8 bits
reg [CSR_DATA_WIDTH - 1       : 0] int_wdata;
reg [CSR_DATA_WIDTH - 1       : 0] int_rdata;
reg [(CSR_DATA_WIDTH / 8) - 1 : 0] int_be;

// output to PHY
wire                                              ctl_cal_req;
wire [MEM_IF_CLK_PAIR_COUNT              - 1 : 0] ctl_mem_clk_disable;
wire [MEM_IF_DQS_WIDTH * MEM_IF_CS_WIDTH - 1 : 0] ctl_cal_byte_lane_sel_n;

// output to timer
wire [CAS_WR_LAT_BUS_WIDTH - 1 : 0] mem_cas_wr_lat;
wire [ADD_LAT_BUS_WIDTH    - 1 : 0] mem_add_lat;
wire [TCL_BUS_WIDTH        - 1 : 0] mem_tcl;
wire [TRRD_BUS_WIDTH       - 1 : 0] mem_trrd;
wire [TFAW_BUS_WIDTH       - 1 : 0] mem_tfaw;
wire [TRFC_BUS_WIDTH       - 1 : 0] mem_trfc;
wire [TREFI_BUS_WIDTH      - 1 : 0] mem_trefi;
wire [TRCD_BUS_WIDTH       - 1 : 0] mem_trcd;
wire [TRP_BUS_WIDTH        - 1 : 0] mem_trp;
wire [TWR_BUS_WIDTH        - 1 : 0] mem_twr;
wire [TWTR_BUS_WIDTH       - 1 : 0] mem_twtr;
wire [TRTP_BUS_WIDTH       - 1 : 0] mem_trtp;
wire [TRAS_BUS_WIDTH       - 1 : 0] mem_tras;
wire [TRC_BUS_WIDTH        - 1 : 0] mem_trc;
wire [AUTO_PD_BUS_WIDTH    - 1 : 0] mem_auto_pd_cycles;

// output to input interface
wire [1 : 0]                         addr_order;
wire [MEM_IF_CSR_COL_WIDTH  - 1 : 0] col_width_from_csr;
wire [MEM_IF_CSR_ROW_WIDTH  - 1 : 0] row_width_from_csr;
wire [MEM_IF_CSR_BANK_WIDTH - 1 : 0] bank_width_from_csr;
wire [MEM_IF_CSR_CS_WIDTH   - 1 : 0] cs_width_from_csr;

//output to ecc
wire ecc_enable;
wire ecc_enable_auto_corr;
wire ecc_gen_sbe;
wire ecc_gen_dbe;
wire ecc_enable_intr;
wire ecc_mask_sbe_intr;
wire ecc_mask_dbe_intr;
wire ecc_clear;

// output to others
wire regdimm_enable;

// CSR read registers
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_100;

reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_110;

reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_120;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_121;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_122;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_123;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_124;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_125;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_126;

reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_130;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_131;
reg [CSR_DATA_WIDTH - 1 : 0] read_csr_register_132;

/*------------------------------------------------------------------------------

   CSR Interface

------------------------------------------------------------------------------*/
// Assign waitrequest signal to '0'
assign csr_waitrequest = 1'b0;

generate
    if (!CTL_CSR_ENABLED && !CTL_ECC_CSR_ENABLED)
    begin
        // when both csr and ecc csr is disabled
        assign csr_rdata       = 0;
        assign csr_rdata_valid = 0;
    end
    else
    begin
        // register all inputs
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_write_req <= 0;
                int_read_req  <= 0;
                int_addr      <= 0;
                int_wdata     <= 0;
                int_be        <= 0;
            end
            else
            begin
                int_addr  <= csr_addr [7 : 0]; // we only need the bottom 8 bits
                int_wdata <= csr_wdata;
                int_be    <= csr_be;
                
                if (csr_write_req)
                    int_write_req <= 1'b1;
                else
                    int_write_req <= 1'b0;
                
                if (csr_read_req)
                    int_read_req <= 1'b1;
                else
                    int_read_req <= 1'b0;
            end
        end
        
        /*------------------------------------------------------------------------------
        
           Read Interface
        
        ------------------------------------------------------------------------------*/
        assign csr_rdata       = int_rdata;
        assign csr_rdata_valid = int_rdata_valid;
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_rdata       <= 0;
                int_rdata_valid <= 0;
            end
            else
            begin
                if (int_read_req)
                begin
                    if (int_addr == 8'h00)
                        int_rdata <= read_csr_register_100;
                    else if (int_addr == 8'h10)
                        int_rdata <= read_csr_register_110;
                    else if (int_addr == 8'h20)
                        int_rdata <= read_csr_register_120;
                    else if (int_addr == 8'h21)
                        int_rdata <= read_csr_register_121;
                    else if (int_addr == 8'h22)
                        int_rdata <= read_csr_register_122;
                    else if (int_addr == 8'h23)
                        int_rdata <= read_csr_register_123;
                    else if (int_addr == 8'h24)
                        int_rdata <= read_csr_register_124;
                    else if (int_addr == 8'h25)
                        int_rdata <= read_csr_register_125;
                    else if (int_addr == 8'h26)
                        int_rdata <= read_csr_register_126;
                    else if (int_addr == 8'h30)
                        int_rdata <= read_csr_register_130;
                    else if (int_addr == 8'h31)
                        int_rdata <= read_csr_register_131;
                    else if (int_addr == 8'h32)
                        int_rdata <= read_csr_register_132;
                end
                
                if (int_read_req)
                    int_rdata_valid <= 1'b1;
                else
                    int_rdata_valid <= 1'b0;
            end
        end
    end
endgenerate

/*------------------------------------------------------------------------------

   CSR Registers

------------------------------------------------------------------------------*/
generate
    genvar i;
    if (!CTL_CSR_ENABLED) // when csr is disabled
    begin
        // assigning values to the top
        assign mem_cas_wr_lat          = MEM_CAS_WR_LAT;
        assign mem_add_lat             = MEM_ADD_LAT;
        assign mem_tcl                 = MEM_TCL;
        assign mem_trrd                = MEM_TRRD;
        assign mem_tfaw                = MEM_TFAW;
        assign mem_trfc                = MEM_TRFC;
        assign mem_trefi               = MEM_TREFI;
        assign mem_trcd                = MEM_TRCD;
        assign mem_trp                 = MEM_TRP;
        assign mem_twr                 = MEM_TWR;
        assign mem_twtr                = MEM_TWTR;
        assign mem_trtp                = MEM_TRTP;
        assign mem_tras                = MEM_TRAS;
        assign mem_trc                 = MEM_TRC;
        assign mem_auto_pd_cycles      = MEM_AUTO_PD_CYCLES;
        
        assign addr_order              = ADDR_ORDER;
        assign cs_width_from_csr       = MEM_IF_CS_WIDTH > 1 ? MEM_IF_CHIP_BITS : 0;
        assign bank_width_from_csr     = MEM_IF_BA_WIDTH;
        assign row_width_from_csr      = MEM_IF_ROW_WIDTH;
        assign col_width_from_csr      = MEM_IF_COL_WIDTH;
        
        assign ctl_cal_req             = 0;
        assign ctl_mem_clk_disable     = 0;
        assign ctl_cal_byte_lane_sel_n = 0;
        
        assign regdimm_enable          = 1'b1; // udimm or rdimm determined by parameter CTL_REGDIMM_ENABLED
    end
    else
    begin
        /*------------------------------------------------------------------------------
        
           0x100 ALTMEPHY Status and Control Register
        
        ------------------------------------------------------------------------------*/
        reg         csr_cal_success;
        reg         csr_cal_fail;
        reg         csr_cal_req;
        reg [5 : 0] csr_clock_off;
        
        // assign value back to top
        assign ctl_cal_req         = csr_cal_req;
        assign ctl_mem_clk_disable = csr_clock_off [MEM_IF_CLK_PAIR_COUNT - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_cal_req     <= 0;
                csr_clock_off   <= 0;
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h00)
                begin
                    if (int_be [0])
                    begin
                        csr_cal_req   <= int_wdata [2]     ;
                    end
                    
                    if (int_be [1])
                    begin
                        csr_clock_off <= int_wdata [13 : 8];
                    end
                end
            end
        end
        
        // read only registers
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_cal_success <= 0;
                csr_cal_fail    <= 0;
            end
            else
            begin
                csr_cal_success <= ctl_cal_success;
                csr_cal_fail    <= ctl_cal_fail;
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_100 = 0;
            
            // then we set individual bits
            read_csr_register_100 [0]      = csr_cal_success;
            read_csr_register_100 [1]      = csr_cal_fail;
            read_csr_register_100 [2]      = csr_cal_req;
            read_csr_register_100 [13 : 8] = csr_clock_off;
        end
        
        /*------------------------------------------------------------------------------
        
           0x110 Controller Status and Control Register
        
        ------------------------------------------------------------------------------*/
        reg [15 : 0] csr_auto_pd_cycles;
        reg          csr_auto_pd_ack;
        reg          csr_self_rfsh;    // yyong: remember to handle this
        reg          csr_self_rfsh_ack;
        reg          csr_ganged_arf;   // yyong: remember to handle this
        reg [1  : 0] csr_addr_order;
        reg          csr_reg_dimm;     // yyong: remember to handle this
        reg [1  : 0] csr_drate;
        
        // assign value back to top
        assign mem_auto_pd_cycles = csr_auto_pd_cycles;
        assign addr_order         = csr_addr_order;
        assign regdimm_enable     = csr_reg_dimm;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_auto_pd_cycles <= MEM_AUTO_PD_CYCLES;  // reset to default value
                csr_self_rfsh      <= 0;
                csr_ganged_arf     <= 0;
                csr_addr_order     <= 2'b01;               // reset to default value
                csr_reg_dimm       <= CTL_REGDIMM_ENABLED; // reset to default value
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h10)
                begin
                    if (int_be [0])
                    begin
                        csr_auto_pd_cycles [ 7 :  0] <= int_wdata [ 7 :  0];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_auto_pd_cycles [15 :  8] <= int_wdata [15 :  8];
                    end
                    
                    if (int_be [2])
                    begin
                        csr_self_rfsh      <= int_wdata [17]     ;
                        csr_ganged_arf     <= int_wdata [19]     ;
                        csr_addr_order     <= int_wdata [21 : 20];
                        csr_reg_dimm       <= int_wdata [22]     ;
                    end
                end
            end
        end
        
        // read only registers
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_auto_pd_ack   <= 0;
                csr_self_rfsh_ack <= 0;
                csr_drate         <= 0;
            end
            else
            begin
                csr_auto_pd_ack   <= local_power_down_ack;
                csr_self_rfsh_ack <= local_self_rfsh_ack;
                csr_drate         <= (DWIDTH_RATIO == 2) ? 2'b00 : 2'b01; // Fullrate - 00, Halfrate - 01
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_110 = 0;
            
            // then we set individual bits
            read_csr_register_110 [15 : 0 ] = csr_auto_pd_cycles;
            read_csr_register_110 [16]      = csr_auto_pd_ack;
            read_csr_register_110 [17]      = csr_self_rfsh;
            read_csr_register_110 [18]      = csr_self_rfsh_ack;
            read_csr_register_110 [19]      = csr_ganged_arf;
            read_csr_register_110 [21 : 20] = csr_addr_order;
            read_csr_register_110 [22]      = csr_reg_dimm;
        end
        
        /*------------------------------------------------------------------------------
        
           0x120 Memory Address Sizes 0
        
        ------------------------------------------------------------------------------*/
        reg [7 : 0] csr_col_width;
        reg [7 : 0] csr_row_width;
        reg [3 : 0] csr_bank_width;
        reg [3 : 0] csr_chip_width;
        
        // assign value back to top
        assign cs_width_from_csr    = csr_chip_width [MEM_IF_CSR_CS_WIDTH   - 1 : 0];
        assign bank_width_from_csr  = csr_bank_width [MEM_IF_CSR_BANK_WIDTH - 1 : 0];
        assign row_width_from_csr   = csr_row_width  [MEM_IF_CSR_ROW_WIDTH  - 1 : 0];
        assign col_width_from_csr   = csr_col_width  [MEM_IF_CSR_COL_WIDTH  - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_col_width  <= MEM_IF_COL_WIDTH;                           // reset to default value
                csr_row_width  <= MEM_IF_ROW_WIDTH;                           // reset to default value
                csr_bank_width <= MEM_IF_BA_WIDTH;                            // reset to default value
                csr_chip_width <= MEM_IF_CS_WIDTH > 1 ? MEM_IF_CHIP_BITS : 0; // reset to default value
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h20)
                begin
                    if (int_be [0])
                    begin
                        csr_col_width  <= int_wdata [7  : 0 ];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_row_width  <= int_wdata [15 : 8 ];
                    end
                    
                    if (int_be [2])
                    begin
                         csr_bank_width <= int_wdata [19 : 16];
                         csr_chip_width <= int_wdata [23 : 20];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_120 = 0;
            
            // then we set individual bits
            read_csr_register_120 [7  : 0 ] = csr_col_width;
            read_csr_register_120 [15 : 8 ] = csr_row_width;
            read_csr_register_120 [19 : 16] = csr_bank_width;
            read_csr_register_120 [23 : 20] = csr_chip_width;
        end
        
        /*------------------------------------------------------------------------------
        
           0x121 Memory Address Sizes 1
        
        ------------------------------------------------------------------------------*/
        reg [31 : 0] csr_data_binary_representation;
        reg [7 : 0] csr_chip_binary_representation;
        
        reg [MEM_IF_DQS_WIDTH * MEM_IF_CS_WIDTH - 1 : 0] cal_byte_lane;
        
        // assign value back to top
        assign ctl_cal_byte_lane_sel_n = ~cal_byte_lane;
        
        // determine cal_byte_lane base on csr data
        for (i = 0;i < MEM_IF_CS_WIDTH;i = i + 1)
        begin : ctl_cal_byte_lane_per_chip
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    cal_byte_lane [(i + 1) * MEM_IF_DQS_WIDTH - 1 : i * MEM_IF_DQS_WIDTH] <= {MEM_IF_DQS_WIDTH{1'b1}}; // setting to all ones
                else
                begin
                    if (csr_chip_binary_representation[i])
                        cal_byte_lane [(i + 1) * MEM_IF_DQS_WIDTH - 1 : i * MEM_IF_DQS_WIDTH] <= csr_data_binary_representation [MEM_IF_DQS_WIDTH - 1 : 0];
                    else
                        cal_byte_lane [(i + 1) * MEM_IF_DQS_WIDTH - 1 : i * MEM_IF_DQS_WIDTH] <= 0;
                end
            end
        end
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_data_binary_representation <= {MEM_IF_DQS_WIDTH{1'b1}};
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h21)
                begin
                    if (int_be [0])
                    begin
                        csr_data_binary_representation [ 7 :  0] <= int_wdata [ 7 :  0];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_data_binary_representation [15 :  8] <= int_wdata [15 :  8];
                    end
                    
                    if (int_be [2])
                    begin
                        csr_data_binary_representation [23 : 16] <= int_wdata [23 : 16];
                    end
                    
                    if (int_be [3])
                    begin
                        csr_data_binary_representation [31 : 24] <= int_wdata [31 : 24];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_121 = 0;
            
            // then we set individual bits
            read_csr_register_121 [31 : 0 ] = csr_data_binary_representation;
        end
        
        /*------------------------------------------------------------------------------
        
           0x122 Memory Address Sizes 2
        
        ------------------------------------------------------------------------------*/
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_chip_binary_representation <= {MEM_IF_CS_WIDTH{1'b1}};
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h22)
                begin
                    if (int_be [0])
                    begin
                        csr_chip_binary_representation [ 7 :  0] <= int_wdata [7  : 0 ];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_122 = 0;
            
            // then we set individual bits
            read_csr_register_122 [7  : 0 ] <= csr_chip_binary_representation;
        end
        
        /*------------------------------------------------------------------------------
        
           0x123 Memory Timing Parameters Registers 0
        
        ------------------------------------------------------------------------------*/
        reg [3 : 0] csr_trcd;
        reg [3 : 0] csr_trrd;
        reg [3 : 0] csr_trp;
        reg [3 : 0] csr_tmrd; // yyong: might remove this
        reg [7 : 0] csr_tras;
        reg [7 : 0] csr_trc;
        
        // assign value back to top
        assign mem_trcd = csr_trcd [TRCD_BUS_WIDTH - 1 : 0];
        assign mem_trrd = csr_trrd [TRRD_BUS_WIDTH - 1 : 0];
        assign mem_trp  = csr_trp  [TRP_BUS_WIDTH  - 1 : 0];
        assign mem_tras = csr_tras [TRAS_BUS_WIDTH - 1 : 0];
        assign mem_trc  = csr_trc  [TRC_BUS_WIDTH  - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_trcd <= MEM_TRCD; // reset to default value
                csr_trrd <= MEM_TRRD; // reset to default value
                csr_trp  <= MEM_TRP;  // reset to default value
                csr_tmrd <= 0;        // yyong: might remove this
                csr_tras <= MEM_TRAS; // reset to default value
                csr_trc  <= MEM_TRC;  // reset to default value
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h23)
                begin
                    if (int_be [0])
                    begin
                        csr_trcd <= int_wdata [3  : 0 ];
                        csr_trrd <= int_wdata [7  : 4 ];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_trp  <= int_wdata [11 : 8 ];
                        csr_tmrd <= int_wdata [15 : 12];
                    end
                    
                    if (int_be [2])
                    begin
                        csr_tras <= int_wdata [23 : 16];
                    end
                    
                    if (int_be [3])
                    begin
                        csr_trc  <= int_wdata [31 : 24];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_123 = 0;
            
            // then we set individual bits
            read_csr_register_123 [3  : 0 ] = csr_trcd;
            read_csr_register_123 [7  : 4 ] = csr_trrd;
            read_csr_register_123 [11 : 8 ] = csr_trp;
            read_csr_register_123 [15 : 12] = csr_tmrd;
            read_csr_register_123 [23 : 16] = csr_tras;
            read_csr_register_123 [31 : 24] = csr_trc;
        end
        
        /*------------------------------------------------------------------------------
        
           0x124 Memory Timing Parameters Registers 1
        
        ------------------------------------------------------------------------------*/
        reg [3 : 0] csr_twtr;
        reg [3 : 0] csr_trtp;
        reg [7 : 0] csr_tfaw;
        
        // assign value back to top
        assign mem_twtr = csr_twtr [TWTR_BUS_WIDTH - 1 : 0];
        assign mem_trtp = csr_trtp [TRTP_BUS_WIDTH - 1 : 0];
        assign mem_tfaw = csr_tfaw [TFAW_BUS_WIDTH - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_twtr <= MEM_TWTR;
                csr_trtp <= MEM_TRTP;
                csr_tfaw <= MEM_TFAW;
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h24)
                begin
                    if (int_be [0])
                    begin
                        csr_twtr <= int_wdata [3  : 0 ];
                        csr_trtp <= int_wdata [7  : 4 ];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_tfaw <= int_wdata [15 : 8 ];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_124 = 0;
            
            // then we set individual bits
            read_csr_register_124 [3  : 0 ] = csr_twtr;
            read_csr_register_124 [7  : 4 ] = csr_trtp;
            read_csr_register_124 [15 : 8 ] = csr_tfaw;
        end
        
        /*------------------------------------------------------------------------------
        
           0x125 Memory Timing Parameters Registers 2
        
        ------------------------------------------------------------------------------*/
        reg [15 : 0] csr_trefi;
        reg [7  : 0] csr_trfc;
        
        // assign value back to top
        assign mem_trefi = csr_trefi [TREFI_BUS_WIDTH - 1 : 0];
        assign mem_trfc  = csr_trfc  [TRFC_BUS_WIDTH  - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_trefi <= MEM_TREFI;
                csr_trfc  <= MEM_TRFC;
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h25)
                begin
                    if (int_be [0])
                    begin
                        csr_trefi [ 7 :  0] <= int_wdata [ 7 :  0];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_trefi [15 :  8] <= int_wdata [15 :  8];
                    end
                    
                    if (int_be [2])
                    begin
                        csr_trfc  <= int_wdata [23 : 16];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_125 = 0;
            
            // then we set individual bits
            read_csr_register_125 [15 : 0 ] = csr_trefi;
            read_csr_register_125 [23 : 16] = csr_trfc;
        end
        
        /*------------------------------------------------------------------------------
        
           0x126 Memory Timing Parameters Registers 3
        
        ------------------------------------------------------------------------------*/
        reg [3 : 0] csr_tcl;
        reg [3 : 0] csr_al;
        reg [3 : 0] csr_cwl;
        reg [3 : 0] csr_twr;
        
        // assign value back to top
        assign mem_tcl        = csr_tcl [TCL_BUS_WIDTH        - 1 : 0];
        assign mem_add_lat    = csr_al  [ADD_LAT_BUS_WIDTH    - 1 : 0];
        assign mem_cas_wr_lat = csr_cwl [CAS_WR_LAT_BUS_WIDTH - 1 : 0];
        assign mem_twr        = csr_twr [TWR_BUS_WIDTH        - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_tcl <= MEM_TCL;
                csr_al  <= MEM_ADD_LAT;
                csr_cwl <= MEM_CAS_WR_LAT;
                csr_twr <= MEM_TWR;
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h26)
                begin
                    if (int_be [0])
                    begin
                        csr_tcl <= int_wdata [3  : 0 ];
                        csr_al  <= int_wdata [7  : 4 ];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_cwl <= int_wdata [11 : 8 ];
                        csr_twr <= int_wdata [15 : 12];
                    end
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_126 = 0;
            
            // then we set individual bits
            read_csr_register_126 [3  : 0 ] = csr_tcl;
            read_csr_register_126 [7  : 4 ] = csr_al;
            read_csr_register_126 [11 : 8 ] = csr_cwl;
            read_csr_register_126 [15 : 12] = csr_twr;
        end
    end
    
    if (!CTL_ECC_CSR_ENABLED)
    begin
        assign ecc_enable              = 1'b1; // default value
        assign ecc_enable_auto_corr    = 1'b1; // default value
        assign ecc_gen_sbe             = 0;
        assign ecc_gen_dbe             = 0;
        assign ecc_enable_intr         = 1'b1; // default value
        assign ecc_mask_sbe_intr       = 0;
        assign ecc_mask_dbe_intr       = 0;
        assign ecc_clear               = 0;
    end
    else
    begin
        /*------------------------------------------------------------------------------
        
           0x130 ECC Control Register
        
        ------------------------------------------------------------------------------*/
        reg csr_enable_ecc;
        reg csr_enable_auto_corr;
        reg csr_gen_sbe;
        reg csr_gen_dbe;
        reg csr_enable_intr;
        reg csr_mask_sbe_intr;
        reg csr_mask_dbe_intr;
        reg csr_ecc_clear;
        
        // assign value back to top
        assign ecc_enable           = csr_enable_ecc;
        assign ecc_enable_auto_corr = csr_enable_auto_corr;
        assign ecc_gen_sbe          = csr_gen_sbe;
        assign ecc_gen_dbe          = csr_gen_dbe;
        assign ecc_enable_intr      = csr_enable_intr;
        assign ecc_mask_sbe_intr    = csr_mask_sbe_intr;
        assign ecc_mask_dbe_intr    = csr_mask_dbe_intr;
        assign ecc_clear            = csr_ecc_clear;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_enable_ecc       <= CTL_ECC_ENABLED;
                csr_enable_auto_corr <= CTL_ECC_RMW_ENABLED;
                csr_gen_sbe          <= 0;
                csr_gen_dbe          <= 0;
                csr_enable_intr      <= 1'b1;
                csr_mask_sbe_intr    <= 0;
                csr_mask_dbe_intr    <= 0;
                csr_ecc_clear        <= 0;
            end
            else
            begin
                // write request
                if (int_write_req && int_addr == 8'h30)
                begin
                    if (int_be [0])
                    begin
                        csr_enable_ecc       <= int_wdata [0];
                        csr_enable_auto_corr <= int_wdata [1];
                        csr_gen_sbe          <= int_wdata [2];
                        csr_gen_dbe          <= int_wdata [3];
                        csr_enable_intr      <= int_wdata [4];
                        csr_mask_sbe_intr    <= int_wdata [5];
                        csr_mask_dbe_intr    <= int_wdata [6];
                        csr_ecc_clear        <= int_wdata [7];
                    end
                end
                
                // set csr_clear to zero after one clock cycle
                if (csr_ecc_clear)
                    csr_ecc_clear     <= 1'b0;
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_130 = 0;
            
            // then we set individual bits
            read_csr_register_130 [0] = csr_enable_ecc;
            read_csr_register_130 [1] = csr_enable_auto_corr;
            read_csr_register_130 [2] = csr_gen_sbe;
            read_csr_register_130 [3] = csr_gen_dbe;
            read_csr_register_130 [4] = csr_enable_intr;
            read_csr_register_130 [5] = csr_mask_sbe_intr;
            read_csr_register_130 [6] = csr_mask_dbe_intr;
            read_csr_register_130 [7] = csr_ecc_clear;
        end
        
        /*------------------------------------------------------------------------------
        
           0x131 ECC Status Register (Read Only)
        
        ------------------------------------------------------------------------------*/
        reg         csr_sbe_error;
        reg         csr_dbe_error;
        reg [7 : 0] csr_sbe_count;
        reg [7 : 0] csr_dbe_count;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_sbe_error <= 0;
                csr_dbe_error <= 0;
                csr_sbe_count <= 0;
                csr_dbe_count <= 0;
            end
            else
            begin
                // all registers are read only registers
                if (csr_ecc_clear)
                begin
                    csr_sbe_error <= 0;
                    csr_dbe_error <= 0;
                    csr_sbe_count <= 0;
                    csr_dbe_count <= 0;
                end
                else
                begin
                    csr_sbe_error <= ecc_sbe_error;
                    csr_dbe_error <= ecc_dbe_error;
                    csr_sbe_count <= ecc_sbe_count;
                    csr_dbe_count <= ecc_dbe_count;
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_131 = 0;
            
            // then we set individual bits
            read_csr_register_131 [0      ] = csr_sbe_error;
            read_csr_register_131 [1      ] = csr_dbe_error;
            read_csr_register_131 [15 : 8 ] = csr_sbe_count;
            read_csr_register_131 [23 : 16] = csr_dbe_count;
        end
        
        /*------------------------------------------------------------------------------
        
           0x132 ECC Error Address Register (Read Only)
        
        ------------------------------------------------------------------------------*/
        reg [31 : 0] csr_error_addr;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                csr_error_addr <= 0;
            end
            else
            begin
                // all registers are read only registers
                if (csr_ecc_clear)
                    csr_error_addr <= 0;
                else
                    csr_error_addr <= ecc_error_addr;
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // then we set individual bits
            read_csr_register_132 = csr_error_addr;
        end
    end
endgenerate
























endmodule
