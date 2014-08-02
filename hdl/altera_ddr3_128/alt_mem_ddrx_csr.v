`timescale 1 ps / 1 ps

//altera message_off 10230

module alt_mem_ddrx_csr #
    ( parameter
        DWIDTH_RATIO                = 2,
        CTL_CSR_ENABLED             = 1,
        CTL_ECC_CSR_ENABLED         = 1,
        CTL_CSR_READ_ONLY           = 0,
        CTL_ECC_CSR_READ_ONLY       = 0,
        CFG_AVALON_ADDR_WIDTH              = 8,
        CFG_AVALON_DATA_WIDTH              = 32,
        
        MEM_IF_CLK_PAIR_COUNT       = 1,
        MEM_IF_DQS_WIDTH            = 72,
        
        CFG_CS_ADDR_WIDTH            = 1,        // same as MEM_IF_CHIP
        CFG_ROW_ADDR_WIDTH            = 13,      // max supported row bits
        CFG_COL_ADDR_WIDTH            = 10,      // max supported column bits
        CFG_BANK_ADDR_WIDTH             = 3,       // max supported bank bits
        
        CFG_ENABLE_ECC             = 1,
        CFG_ENABLE_AUTO_CORR         = 1,
        CFG_REGDIMM_ENABLE         = 0,
        
        // timing parameter width
        CAS_WR_LAT_BUS_WIDTH        = 4,       // max will be 8 in DDR3
        ADD_LAT_BUS_WIDTH           = 3,       // max will be 6 in DDR2
        TCL_BUS_WIDTH               = 4,       // max will be 11 in DDR3
        BL_BUS_WIDTH                = 5,       // 
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
        STARVE_LIMIT_BUS_WIDTH      = 8,
        
        // timing parameter
        CFG_CAS_WR_LAT              = 0,        // these timing parameter must be set properly for controller to work
        CFG_ADD_LAT                 = 0,        // these timing parameter must be set properly for controller to work
        CFG_TCL                     = 0,        // these timing parameter must be set properly for controller to work
        CFG_BURST_LENGTH                      = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRRD                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TFAW                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRFC                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TREFI                   = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRCD                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRP                     = 0,        // these timing parameter must be set properly for controller to work
        CFG_TWR                     = 0,        // these timing parameter must be set properly for controller to work
        CFG_TWTR                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRTP                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRAS                    = 0,        // these timing parameter must be set properly for controller to work
        CFG_TRC                     = 0,        // these timing parameter must be set properly for controller to work
        CFG_AUTO_PD_CYCLES          = 0,        // these timing parameter must be set properly for controller to work
        
        // parameters used by input interface
        CFG_ADDR_ORDER                  = 1,        // normally we will use '1' for chip, bank, row, column arrangement
        CFG_REORDER_DATA         = 0,
        CFG_STARVE_LIMIT                = 0,
        MEM_IF_CSR_COL_WIDTH        = 5,
        MEM_IF_CSR_ROW_WIDTH        = 5,
        MEM_IF_CSR_BANK_WIDTH       = 3,
        MEM_IF_CSR_CS_WIDTH         = 3
    )
    (
        ctl_clk,
        ctl_rst_n,
        
        // csr interface (Avalon)
        avalon_mm_addr,
        avalon_mm_be,
        avalon_mm_write,
        avalon_mm_wdata,
        avalon_mm_read,
        avalon_mm_rdata,
        avalon_mm_rdata_valid,
        avalon_mm_waitrequest,
        
        // input from PHY
        sts_cal_success,
        sts_cal_fail,
        
        // input from state machine
        local_power_down_ack,
        local_self_rfsh_ack,
        
        // input from ecc
        sts_sbe_error,
        sts_dbe_error,
        sts_corr_dropped,
        sts_sbe_count,
        sts_dbe_count,
        sts_corr_dropped_count,
        sts_err_addr,
        sts_corr_dropped_addr,
        
        // output to PHY
        cfg_cal_req,
        cfg_clock_off,
        ctl_cal_byte_lane_sel_n,
        
        // output to timer
        cfg_cas_wr_lat,
        cfg_add_lat,
        cfg_tcl,
        cfg_burst_length,
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
        cfg_auto_pd_cycles,
        
        // output to input interface
        cfg_addr_order,
        cfg_col_addr_width,
        cfg_row_addr_width,
        cfg_bank_addr_width,
        cfg_cs_addr_width,
        
        // output to ecc
        cfg_enable_ecc,
        cfg_enable_auto_corr,
        cfg_gen_sbe,
        cfg_gen_dbe,
        cfg_enable_intr,
        cfg_mask_sbe_intr,
        cfg_mask_dbe_intr,
        cfg_mask_corr_dropped_intr,
        cfg_clr_intr,

        // output to others
        cfg_regdimm_enable,
        cfg_reorder_data,
        cfg_starve_limit
    );

localparam integer CFG_MEM_IF_CS_WIDTH  = (2**CFG_CS_ADDR_WIDTH);

input ctl_clk;
input ctl_rst_n;

input avalon_mm_write;
input avalon_mm_read;
input [CFG_AVALON_ADDR_WIDTH - 1       : 0] avalon_mm_addr;
input [CFG_AVALON_DATA_WIDTH - 1       : 0] avalon_mm_wdata;
input [(CFG_AVALON_DATA_WIDTH / 8) - 1 : 0] avalon_mm_be;

output avalon_mm_waitrequest;
output avalon_mm_rdata_valid;
output [CFG_AVALON_DATA_WIDTH - 1 : 0] avalon_mm_rdata;

// input from AFI
input sts_cal_success;
input sts_cal_fail;

// input from state machine
input local_power_down_ack;
input local_self_rfsh_ack;

// input from ecc
input           sts_sbe_error;
input           sts_dbe_error;
input           sts_corr_dropped;
input  [7  : 0] sts_sbe_count;
input  [7  : 0] sts_dbe_count;
input  [7  : 0] sts_corr_dropped_count;
input  [31 : 0] sts_err_addr;
input  [31 : 0] sts_corr_dropped_addr;

// output to PHY
output                                              cfg_cal_req;
output [MEM_IF_CLK_PAIR_COUNT              - 1 : 0] cfg_clock_off;
output [MEM_IF_DQS_WIDTH * CFG_MEM_IF_CS_WIDTH - 1 : 0] ctl_cal_byte_lane_sel_n;

// output to timer
output [CAS_WR_LAT_BUS_WIDTH - 1 : 0] cfg_cas_wr_lat;
output [ADD_LAT_BUS_WIDTH    - 1 : 0] cfg_add_lat;
output [TCL_BUS_WIDTH        - 1 : 0] cfg_tcl;
output [BL_BUS_WIDTH         - 1 : 0] cfg_burst_length;
output [TRRD_BUS_WIDTH       - 1 : 0] cfg_trrd;
output [TFAW_BUS_WIDTH       - 1 : 0] cfg_tfaw;
output [TRFC_BUS_WIDTH       - 1 : 0] cfg_trfc;
output [TREFI_BUS_WIDTH      - 1 : 0] cfg_trefi;
output [TRCD_BUS_WIDTH       - 1 : 0] cfg_trcd;
output [TRP_BUS_WIDTH        - 1 : 0] cfg_trp;
output [TWR_BUS_WIDTH        - 1 : 0] cfg_twr;
output [TWTR_BUS_WIDTH       - 1 : 0] cfg_twtr;
output [TRTP_BUS_WIDTH       - 1 : 0] cfg_trtp;
output [TRAS_BUS_WIDTH       - 1 : 0] cfg_tras;
output [TRC_BUS_WIDTH        - 1 : 0] cfg_trc;
output [AUTO_PD_BUS_WIDTH    - 1 : 0] cfg_auto_pd_cycles;

// output to input interface
output [1 : 0]                         cfg_addr_order;
output                                 cfg_reorder_data;
output [STARVE_LIMIT_BUS_WIDTH-1: 0] cfg_starve_limit;
output [MEM_IF_CSR_COL_WIDTH  - 1 : 0] cfg_col_addr_width;
output [MEM_IF_CSR_ROW_WIDTH  - 1 : 0] cfg_row_addr_width;
output [MEM_IF_CSR_BANK_WIDTH - 1 : 0] cfg_bank_addr_width;
output [MEM_IF_CSR_CS_WIDTH   - 1 : 0] cfg_cs_addr_width;

//output to ecc
output cfg_enable_ecc;
output cfg_enable_auto_corr;
output cfg_gen_sbe;
output cfg_gen_dbe;
output cfg_enable_intr;
output cfg_mask_sbe_intr;
output cfg_mask_dbe_intr;
output cfg_mask_corr_dropped_intr;
output cfg_clr_intr;

output cfg_regdimm_enable;

wire avalon_mm_waitrequest;
wire avalon_mm_rdata_valid;
wire [CFG_AVALON_DATA_WIDTH - 1 : 0] avalon_mm_rdata;

reg int_write_req;
reg int_read_req;
reg int_rdata_valid;
reg [8              - 1       : 0] int_addr; // hard-coded to only 8 bits
reg [CFG_AVALON_DATA_WIDTH - 1       : 0] int_wdata;
reg [CFG_AVALON_DATA_WIDTH - 1       : 0] int_rdata;
reg [(CFG_AVALON_DATA_WIDTH / 8) - 1 : 0] int_be;

reg int_mask_avalon_mm_write;
reg int_mask_avalon_mm_read;
reg int_mask_ecc_avalon_mm_write;
reg int_mask_ecc_avalon_mm_read;

// output to PHY
wire                                              cfg_cal_req;
wire [MEM_IF_CLK_PAIR_COUNT              - 1 : 0] cfg_clock_off;
wire [MEM_IF_DQS_WIDTH * CFG_MEM_IF_CS_WIDTH - 1 : 0] ctl_cal_byte_lane_sel_n;

// output to timer
wire [CAS_WR_LAT_BUS_WIDTH - 1 : 0] cfg_cas_wr_lat;
wire [ADD_LAT_BUS_WIDTH    - 1 : 0] cfg_add_lat;
wire [TCL_BUS_WIDTH        - 1 : 0] cfg_tcl;
wire [BL_BUS_WIDTH         - 1 : 0] cfg_burst_length;
wire [TRRD_BUS_WIDTH       - 1 : 0] cfg_trrd;
wire [TFAW_BUS_WIDTH       - 1 : 0] cfg_tfaw;
wire [TRFC_BUS_WIDTH       - 1 : 0] cfg_trfc;
wire [TREFI_BUS_WIDTH      - 1 : 0] cfg_trefi;
wire [TRCD_BUS_WIDTH       - 1 : 0] cfg_trcd;
wire [TRP_BUS_WIDTH        - 1 : 0] cfg_trp;
wire [TWR_BUS_WIDTH        - 1 : 0] cfg_twr;
wire [TWTR_BUS_WIDTH       - 1 : 0] cfg_twtr;
wire [TRTP_BUS_WIDTH       - 1 : 0] cfg_trtp;
wire [TRAS_BUS_WIDTH       - 1 : 0] cfg_tras;
wire [TRC_BUS_WIDTH        - 1 : 0] cfg_trc;
wire [AUTO_PD_BUS_WIDTH    - 1 : 0] cfg_auto_pd_cycles;

// output to input interface
wire [1 : 0]                         cfg_addr_order;
wire                                 cfg_reorder_data;
wire [STARVE_LIMIT_BUS_WIDTH-1: 0] cfg_starve_limit;
wire [MEM_IF_CSR_COL_WIDTH  - 1 : 0] cfg_col_addr_width;
wire [MEM_IF_CSR_ROW_WIDTH  - 1 : 0] cfg_row_addr_width;
wire [MEM_IF_CSR_BANK_WIDTH - 1 : 0] cfg_bank_addr_width;
wire [MEM_IF_CSR_CS_WIDTH   - 1 : 0] cfg_cs_addr_width;

//output to ecc
wire cfg_enable_ecc;
wire cfg_enable_auto_corr;
wire cfg_gen_sbe;
wire cfg_gen_dbe;
wire cfg_enable_intr;
wire cfg_mask_sbe_intr;
wire cfg_mask_dbe_intr;
wire cfg_mask_corr_dropped_intr;
wire cfg_clr_intr;

// output to others
wire cfg_regdimm_enable;

// CSR read registers
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_100;

reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_110;

reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_120;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_121;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_122;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_123;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_124;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_125;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_126;

reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_130;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_131;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_132;

reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_133;
reg [CFG_AVALON_DATA_WIDTH - 1 : 0] read_csr_register_134;

/*------------------------------------------------------------------------------

   CSR Interface

------------------------------------------------------------------------------*/
// Assign waitrequest signal to '0'
assign avalon_mm_waitrequest = 1'b0;

generate
    if (!CTL_CSR_ENABLED && !CTL_ECC_CSR_ENABLED)
    begin
        // when both csr and ecc csr is disabled
        assign avalon_mm_rdata       = 0;
        assign avalon_mm_rdata_valid = 0;
    end
    else
    begin
        // register all inputs
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                int_write_req <= 0;
                int_read_req  <= 0;
                int_addr      <= 0;
                int_wdata     <= 0;
                int_be        <= 0;
            end
            else
            begin
                int_addr  <= avalon_mm_addr [7 : 0]; // we only need the bottom 8 bits
                int_wdata <= avalon_mm_wdata;
                int_be    <= avalon_mm_be;
                
                if (avalon_mm_write)
                    int_write_req <= 1'b1;
                else
                    int_write_req <= 1'b0;
                
                if (avalon_mm_read)
                    int_read_req <= 1'b1;
                else
                    int_read_req <= 1'b0;
            end
        end
        
        // Write and read request mask
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                int_mask_avalon_mm_write     <= 1'b0;
                int_mask_avalon_mm_read      <= 1'b0;
                int_mask_ecc_avalon_mm_write <= 1'b0;
                int_mask_ecc_avalon_mm_read  <= 1'b0;
            end
            else
            begin
                if (CTL_CSR_READ_ONLY)
                begin
                    int_mask_avalon_mm_write <= 1'b1;
                    int_mask_avalon_mm_read  <= 1'b0;
                end
                else
                begin
                    int_mask_avalon_mm_write <= 1'b0;
                    int_mask_avalon_mm_read  <= 1'b0;
                end
                
                if (CTL_ECC_CSR_READ_ONLY)
                begin
                    int_mask_ecc_avalon_mm_write <= 1'b1;
                    int_mask_ecc_avalon_mm_read  <= 1'b0;
                end
                else
                begin
                    int_mask_ecc_avalon_mm_write <= 1'b0;
                    int_mask_ecc_avalon_mm_read  <= 1'b0;
                end
            end
        end
        
        /*------------------------------------------------------------------------------
        
           Read Interface
        
        ------------------------------------------------------------------------------*/
        assign avalon_mm_rdata       = int_rdata;
        assign avalon_mm_rdata_valid = int_rdata_valid;
        
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
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
                    else if (int_addr == 8'h33)
                        int_rdata <= read_csr_register_133;
                    else if (int_addr == 8'h34)
                        int_rdata <= read_csr_register_134;
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
        assign cfg_cas_wr_lat          = CFG_CAS_WR_LAT;
        assign cfg_add_lat             = CFG_ADD_LAT;
        assign cfg_tcl                 = CFG_TCL;
        assign cfg_burst_length        = CFG_BURST_LENGTH;
        assign cfg_trrd                = CFG_TRRD;
        assign cfg_tfaw                = CFG_TFAW;
        assign cfg_trfc                = CFG_TRFC;
        assign cfg_trefi               = CFG_TREFI;
        assign cfg_trcd                = CFG_TRCD;
        assign cfg_trp                 = CFG_TRP;
        assign cfg_twr                 = CFG_TWR;
        assign cfg_twtr                = CFG_TWTR;
        assign cfg_trtp                = CFG_TRTP;
        assign cfg_tras                = CFG_TRAS;
        assign cfg_trc                 = CFG_TRC;
        assign cfg_auto_pd_cycles      = CFG_AUTO_PD_CYCLES;
        
        assign cfg_addr_order              = CFG_ADDR_ORDER;
        assign cfg_reorder_data     = CFG_REORDER_DATA;
        assign cfg_starve_limit            = CFG_STARVE_LIMIT;
        assign cfg_cs_addr_width       = CFG_MEM_IF_CS_WIDTH > 1 ? CFG_CS_ADDR_WIDTH : 0;
        assign cfg_bank_addr_width     = CFG_BANK_ADDR_WIDTH;
        assign cfg_row_addr_width      = CFG_ROW_ADDR_WIDTH;
        assign cfg_col_addr_width      = CFG_COL_ADDR_WIDTH;
        
        assign cfg_cal_req             = 0;
        assign cfg_clock_off     = 0;
        assign ctl_cal_byte_lane_sel_n = 0;
        
        assign cfg_regdimm_enable          = 1'b1; // udimm or rdimm determined by parameter CFG_REGDIMM_ENABLE
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
        assign cfg_cal_req         = csr_cal_req;
        assign cfg_clock_off = csr_clock_off [MEM_IF_CLK_PAIR_COUNT - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
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
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_cal_success <= 0;
                csr_cal_fail    <= 0;
            end
            else
            begin
                csr_cal_success <= sts_cal_success;
                csr_cal_fail    <= sts_cal_fail;
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
        assign cfg_auto_pd_cycles = csr_auto_pd_cycles;
        assign cfg_addr_order         = csr_addr_order;
        assign cfg_regdimm_enable     = csr_reg_dimm;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_auto_pd_cycles <= CFG_AUTO_PD_CYCLES;  // reset to default value
                csr_self_rfsh      <= 0;
                csr_ganged_arf     <= 0;
                csr_addr_order     <= CFG_ADDR_ORDER;          // reset to default value
                csr_reg_dimm       <= CFG_REGDIMM_ENABLE; // reset to default value
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h10)
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
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
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
            read_csr_register_110 [24 : 23] = csr_drate;
        end
        
        /*------------------------------------------------------------------------------
        
           0x120 Memory Address Sizes 0
        
        ------------------------------------------------------------------------------*/
        reg [7 : 0] csr_col_width;
        reg [7 : 0] csr_row_width;
        reg [3 : 0] csr_bank_width;
        reg [3 : 0] csr_chip_width;
        
        // assign value back to top
        assign cfg_cs_addr_width    = csr_chip_width [MEM_IF_CSR_CS_WIDTH   - 1 : 0];
        assign cfg_bank_addr_width  = csr_bank_width [MEM_IF_CSR_BANK_WIDTH - 1 : 0];
        assign cfg_row_addr_width   = csr_row_width  [MEM_IF_CSR_ROW_WIDTH  - 1 : 0];
        assign cfg_col_addr_width   = csr_col_width  [MEM_IF_CSR_COL_WIDTH  - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_col_width  <= CFG_COL_ADDR_WIDTH;                           // reset to default value
                csr_row_width  <= CFG_ROW_ADDR_WIDTH;                           // reset to default value
                csr_bank_width <= CFG_BANK_ADDR_WIDTH;                            // reset to default value
                csr_chip_width <= CFG_MEM_IF_CS_WIDTH > 1 ? CFG_CS_ADDR_WIDTH : 0; // reset to default value
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h20)
                begin
                    if (int_be [0])
                    begin
                        if (int_wdata [7 : 0] <= CFG_COL_ADDR_WIDTH)
                        begin
                            csr_col_width  <= int_wdata [7  : 0 ];
                        end
                    end
                    
                    if (int_be [1])
                    begin
                        if (int_wdata [15 : 8] <= CFG_ROW_ADDR_WIDTH)
                        begin
                            csr_row_width  <= int_wdata [15 : 8 ];
                        end
                    end
                    
                    if (int_be [2])
                    begin
                        if (int_wdata [19 : 16] <= CFG_BANK_ADDR_WIDTH)
                        begin
                            csr_bank_width <= int_wdata [19 : 16];
                        end
                        
                        if (int_wdata [23 : 20] <= (CFG_MEM_IF_CS_WIDTH > 1 ? CFG_CS_ADDR_WIDTH : 0))
                        begin
                            csr_chip_width <= int_wdata [23 : 20];
                        end
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
        
        reg [MEM_IF_DQS_WIDTH * CFG_MEM_IF_CS_WIDTH - 1 : 0] cal_byte_lane;
        
        // assign value back to top
        assign ctl_cal_byte_lane_sel_n = ~cal_byte_lane;
        
        // determine cal_byte_lane base on csr data
        for (i = 0;i < CFG_MEM_IF_CS_WIDTH;i = i + 1)
        begin : ctl_cal_byte_lane_per_chip
            always @ (posedge ctl_clk or negedge ctl_rst_n)
            begin
                if (!ctl_rst_n)
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
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_data_binary_representation <= {MEM_IF_DQS_WIDTH{1'b1}};
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h21)
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
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_chip_binary_representation <= {CFG_MEM_IF_CS_WIDTH{1'b1}};
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h22)
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
            read_csr_register_122 [7  : 0 ] = csr_chip_binary_representation;
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
        assign cfg_trcd = csr_trcd [TRCD_BUS_WIDTH - 1 : 0];
        assign cfg_trrd = csr_trrd [TRRD_BUS_WIDTH - 1 : 0];
        assign cfg_trp  = csr_trp  [TRP_BUS_WIDTH  - 1 : 0];
        assign cfg_tras = csr_tras [TRAS_BUS_WIDTH - 1 : 0];
        assign cfg_trc  = csr_trc  [TRC_BUS_WIDTH  - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_trcd <= CFG_TRCD; // reset to default value
                csr_trrd <= CFG_TRRD; // reset to default value
                csr_trp  <= CFG_TRP;  // reset to default value
                csr_tmrd <= 0;        // yyong: might remove this
                csr_tras <= CFG_TRAS; // reset to default value
                csr_trc  <= CFG_TRC;  // reset to default value
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h23)
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
        reg [5 : 0] csr_tfaw;
        
        // assign value back to top
        assign cfg_twtr = csr_twtr [TWTR_BUS_WIDTH - 1 : 0];
        assign cfg_trtp = csr_trtp [TRTP_BUS_WIDTH - 1 : 0];
        assign cfg_tfaw = csr_tfaw [TFAW_BUS_WIDTH - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_twtr <= CFG_TWTR;
                csr_trtp <= CFG_TRTP;
                csr_tfaw <= CFG_TFAW;
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h24)
                begin
                    if (int_be [0])
                    begin
                        csr_twtr <= int_wdata [3  : 0 ];
                        csr_trtp <= int_wdata [7  : 4 ];
                    end
                    
                    if (int_be [1])
                    begin
                        csr_tfaw <= int_wdata [13 : 8 ];
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
        assign cfg_trefi = csr_trefi [TREFI_BUS_WIDTH - 1 : 0];
        assign cfg_trfc  = csr_trfc  [TRFC_BUS_WIDTH  - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_trefi <= CFG_TREFI;
                csr_trfc  <= CFG_TRFC;
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h25)
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
        reg [7 : 0] csr_bl;
        
        // assign value back to top
        assign cfg_tcl          = csr_tcl [TCL_BUS_WIDTH        - 1 : 0];
        assign cfg_add_lat      = csr_al  [ADD_LAT_BUS_WIDTH    - 1 : 0];
        assign cfg_cas_wr_lat   = csr_cwl [CAS_WR_LAT_BUS_WIDTH - 1 : 0];
        assign cfg_twr          = csr_twr [TWR_BUS_WIDTH        - 1 : 0];
        assign cfg_burst_length = csr_bl  [BL_BUS_WIDTH         - 1 : 0];
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_tcl <= CFG_TCL;
                csr_al  <= CFG_ADD_LAT;
                csr_cwl <= CFG_CAS_WR_LAT;
                csr_twr <= CFG_TWR;
                csr_bl  <= CFG_BURST_LENGTH;
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h26)
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

                    if (int_be [2])
                    begin
                        csr_bl  <= int_wdata [23 : 16];
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
            read_csr_register_126 [23 : 16] = csr_bl;
        end
    end
    
    if (!CTL_ECC_CSR_ENABLED)
    begin
        assign cfg_enable_ecc              = 1'b1; // default value
        assign cfg_enable_auto_corr    = 1'b1; // default value
        assign cfg_gen_sbe             = 0;
        assign cfg_gen_dbe             = 0;
        assign cfg_enable_intr         = 1'b1; // default value
        assign cfg_mask_sbe_intr       = 0;
        assign cfg_mask_dbe_intr       = 0;
        assign cfg_clr_intr               = 0;
        assign cfg_mask_corr_dropped_intr=0;
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
        reg csr_mask_corr_dropped_intr;
        
        // assign value back to top
        assign cfg_enable_ecc                   = csr_enable_ecc;
        assign cfg_enable_auto_corr         = csr_enable_auto_corr;
        assign cfg_gen_sbe                  = csr_gen_sbe;
        assign cfg_gen_dbe                  = csr_gen_dbe;
        assign cfg_enable_intr              = csr_enable_intr;
        assign cfg_mask_sbe_intr            = csr_mask_sbe_intr;
        assign cfg_mask_dbe_intr            = csr_mask_dbe_intr;
        assign cfg_clr_intr                    = csr_ecc_clear;
        assign cfg_mask_corr_dropped_intr   = csr_mask_corr_dropped_intr;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_enable_ecc              <= CFG_ENABLE_ECC;
                csr_enable_auto_corr        <= CFG_ENABLE_AUTO_CORR;
                csr_gen_sbe                 <= 0;
                csr_gen_dbe                 <= 0;
                csr_enable_intr             <= 1'b1;
                csr_mask_sbe_intr           <= 0;
                csr_mask_dbe_intr           <= 0;
                csr_ecc_clear               <= 0;
                csr_mask_corr_dropped_intr  <= 0;
            end
            else
            begin
                // write request
                if (!int_mask_ecc_avalon_mm_write && int_write_req && int_addr == 8'h30)
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
                    if (int_be [1])
                    begin
                        csr_mask_corr_dropped_intr    <= int_wdata [8];
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
            read_csr_register_130 [8] = csr_mask_corr_dropped_intr;
        end
        
        /*------------------------------------------------------------------------------
        
           0x131 ECC Status Register (Read Only)
        
        ------------------------------------------------------------------------------*/
        reg         csr_sbe_error;
        reg         csr_dbe_error;
        reg         csr_corr_dropped;
        reg [7 : 0] csr_sbe_count;
        reg [7 : 0] csr_dbe_count;
        reg [7 : 0] csr_corr_dropped_count;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_sbe_error <= 0;
                csr_dbe_error <= 0;
                csr_sbe_count <= 0;
                csr_dbe_count <= 0;
                csr_corr_dropped <= 0;
                csr_corr_dropped_count <= 0;
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
                    csr_corr_dropped <= 0;
                    csr_corr_dropped_count <= 0;
                end
                else
                begin
                    csr_sbe_error <= sts_sbe_error;
                    csr_dbe_error <= sts_dbe_error;
                    csr_sbe_count <= sts_sbe_count;
                    csr_dbe_count <= sts_dbe_count;
                    csr_corr_dropped <= sts_corr_dropped;
                    csr_corr_dropped_count <= sts_corr_dropped_count;
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
            read_csr_register_131 [2      ] = csr_corr_dropped;
            read_csr_register_131 [15 : 8 ] = csr_sbe_count;
            read_csr_register_131 [23 : 16] = csr_dbe_count;
            read_csr_register_131 [31 : 24] = csr_corr_dropped_count;
        end
        
        /*------------------------------------------------------------------------------
        
           0x132 ECC Error Address Register (Read Only)
        
        ------------------------------------------------------------------------------*/
        reg [31 : 0] csr_error_addr;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_error_addr <= 0;
            end
            else
            begin
                // all registers are read only registers
                if (csr_ecc_clear)
                    csr_error_addr <= 0;
                else
                    csr_error_addr <= sts_err_addr;
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // then we set individual bits
            read_csr_register_132 = csr_error_addr;
        end


        /*------------------------------------------------------------------------------
        
           0x133 ECC Correction Dropped Address Register (Read Only)
        
        ------------------------------------------------------------------------------*/
        reg [31 : 0] csr_corr_dropped_addr;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_corr_dropped_addr <= 0;
            end
            else
            begin
                // all registers are read only registers
                if (csr_ecc_clear)
                    csr_corr_dropped_addr <= 0;
                else
                    csr_corr_dropped_addr <= sts_corr_dropped_addr;
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // then we set individual bits
            read_csr_register_133 = csr_corr_dropped_addr;
        end




        /*------------------------------------------------------------------------------
        
           0x134 Controller Status and Control Register - Advanced Features
        
        ------------------------------------------------------------------------------*/
        reg          csr_reorder_data;
        reg [7 : 0]  csr_starve_limit;
        
        // assign value back to top
        assign cfg_reorder_data = csr_reorder_data;
        assign cfg_starve_limit = csr_starve_limit;
        
        // register arrays to store CSR informations
        always @ (posedge ctl_clk or negedge ctl_rst_n)
        begin
            if (!ctl_rst_n)
            begin
                csr_reorder_data    <= CFG_REORDER_DATA;
                csr_starve_limit    <= CFG_STARVE_LIMIT;  // reset to default value
            end
            else
            begin
                // write request
                if (!int_mask_avalon_mm_write && int_write_req && int_addr == 8'h34)
                begin
                    if (int_be [0])
                    begin
                        csr_reorder_data <= int_wdata [ 0];
                    end
                    
                    if (int_be [2])
                    begin
                        csr_starve_limit <= int_wdata [23 :  16];
                    end
                    
                end
            end
        end
        
        // assigning read datas back to 32 bit bus
        always @ (*)
        begin
            // first, set all to zeros
            read_csr_register_134 = 0;
            
            // then we set individual bits
            read_csr_register_134 [ 0 ]       = csr_reorder_data;
            read_csr_register_134 [ 23 : 16 ] = csr_starve_limit;
        end
        
    end
endgenerate
























endmodule
