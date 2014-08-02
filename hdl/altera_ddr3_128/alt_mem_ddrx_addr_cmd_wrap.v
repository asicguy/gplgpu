
//altera message_off 10036

`include "alt_mem_ddrx_define.iv"

module alt_mem_ddrx_addr_cmd_wrap
# ( parameter
    CFG_MEM_IF_CHIP                 =   2,
    CFG_MEM_IF_CKE_WIDTH            =   2,  // same width as CS_WIDTH
    CFG_MEM_IF_ADDR_WIDTH           =   16, // max supported address bits, must be >= row bits
    CFG_MEM_IF_ROW_WIDTH            =   16, // max supported row bits
    CFG_MEM_IF_COL_WIDTH            =   12, // max supported column bits  
    CFG_MEM_IF_BA_WIDTH             =   3,  // max supported bank bits
    CFG_LPDDR2_ENABLED              =   1,
    CFG_PORT_WIDTH_TYPE             =   3,
    CFG_DWIDTH_RATIO                =   2,
    CFG_AFI_INTF_PHASE_NUM          =   2,
    CFG_LOCAL_ID_WIDTH              =   8,
    CFG_DATA_ID_WIDTH               =   4,
    CFG_INT_SIZE_WIDTH              =   4,
    CFG_ODT_ENABLED                 =   1,
    CFG_MEM_IF_ODT_WIDTH            =   2,
    CFG_PORT_WIDTH_CAS_WR_LAT       =   5,
    CFG_PORT_WIDTH_TCL              =   5,
    CFG_PORT_WIDTH_ADD_LAT          =   5,
    CFG_PORT_WIDTH_WRITE_ODT_CHIP   =   4,
    CFG_PORT_WIDTH_READ_ODT_CHIP    =   4,
    CFG_PORT_WIDTH_OUTPUT_REGD      =   1
)
(
    
    ctl_clk,
    ctl_reset_n,
    ctl_cal_success,
    
    cfg_type,
    cfg_tcl,
    cfg_cas_wr_lat,
    cfg_add_lat,
    cfg_write_odt_chip,
    cfg_read_odt_chip,
    cfg_burst_length,
    
    cfg_output_regd_for_afi_output,
    
    // burst generator command signals
    bg_do_write,
    bg_do_read,
    bg_do_burst_chop,
    bg_do_burst_terminate,
    bg_do_auto_precharge,
    bg_do_activate,
    bg_do_precharge,
    bg_do_precharge_all,
    bg_do_refresh,
    bg_do_self_refresh,
    bg_do_power_down,
    bg_do_deep_pdown,
    bg_do_rmw_correct,
    bg_do_rmw_partial,
    
    bg_do_lmr_read,
    bg_do_refresh_1bank,
    
    bg_do_zq_cal,
    bg_do_lmr,
    
    bg_localid,
    bg_dataid,
    bg_size,
    
    // burst generator address signals
    bg_to_chip, // active high input (one hot)
    bg_to_bank,
    bg_to_row,
    bg_to_col,
    bg_to_lmr,
    lmr_opcode,
    
    //output
    afi_cke,
    afi_cs_n,
    afi_ras_n,
    afi_cas_n,
    afi_we_n,
    afi_ba,
    afi_addr,
    afi_rst_n,
    afi_odt
);

    // -----------------------------
    // local parameter declaration
    // -----------------------------
    
    localparam CFG_FR_DWIDTH_RATIO = 2;
    
    // -----------------------------
    // port declaration
    // -----------------------------
    
    input                                                             ctl_clk                       ;
    input                                                             ctl_reset_n                   ;
    input                                                             ctl_cal_success               ;
    
    //run-time csr chain input
    input   [CFG_PORT_WIDTH_TYPE                             - 1 : 0] cfg_type                      ;
    input   [CFG_PORT_WIDTH_TCL                              - 1 : 0] cfg_tcl                       ;
    input   [CFG_PORT_WIDTH_CAS_WR_LAT                       - 1 : 0] cfg_cas_wr_lat                ;
    input   [CFG_PORT_WIDTH_ADD_LAT                          - 1 : 0] cfg_add_lat                   ;
    input   [CFG_PORT_WIDTH_WRITE_ODT_CHIP                   - 1 : 0] cfg_write_odt_chip            ;
    input   [CFG_PORT_WIDTH_READ_ODT_CHIP                    - 1 : 0] cfg_read_odt_chip             ;
    input   [4:0]                                                     cfg_burst_length              ;
    
    //output regd signal from rdwr_tmg block
    input   [CFG_PORT_WIDTH_OUTPUT_REGD                      - 1 : 0] cfg_output_regd_for_afi_output;
    
    //command inputs
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write                   ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read                    ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop              ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate         ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_auto_precharge          ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_correct             ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_partial             ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate                ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge               ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_precharge_all           ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_refresh                 ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_self_refresh            ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_power_down              ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_deep_pdown              ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_zq_cal                  ;
    input   [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_lmr                     ;
    
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip                    ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] bg_to_bank                    ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] bg_to_row                     ;
    input   [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] bg_to_col                     ;
    
    input                                                             bg_do_lmr_read                ;
    input                                                             bg_do_refresh_1bank           ;
    
    input    [7:0]                                                    bg_to_lmr                     ;
    
    input   [CFG_LOCAL_ID_WIDTH                              - 1 : 0] bg_localid                    ;
    input   [CFG_DATA_ID_WIDTH                               - 1 : 0] bg_dataid                     ;
    input   [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_size                       ;
    
    input   [CFG_MEM_IF_ADDR_WIDTH-1:0]                              lmr_opcode                     ;
    
    output  [(CFG_MEM_IF_CKE_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]    afi_cke                        ;
    output  [(CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO/2)) - 1:0]         afi_cs_n                       ;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_ras_n                      ;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_cas_n                      ;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_we_n                       ;
    output  [(CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]     afi_ba                         ;
    output  [(CFG_MEM_IF_ADDR_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]   afi_addr                       ;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_rst_n                      ;
    output  [(CFG_MEM_IF_ODT_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]    afi_odt                        ;
    
    // -----------------------------
    // port type declaration
    // -----------------------------
    
    reg     [(CFG_MEM_IF_CKE_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]    afi_cke                        ;
    reg     [(CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO/2)) - 1:0]         afi_cs_n                       ;
    reg     [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_ras_n                      ;
    reg     [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_cas_n                      ;
    reg     [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_we_n                       ;
    reg     [(CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]     afi_ba                         ;
    reg     [(CFG_MEM_IF_ADDR_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]   afi_addr                       ;
    reg     [(CFG_DWIDTH_RATIO/2) - 1:0]                             afi_rst_n                      ;
    reg     [(CFG_MEM_IF_ODT_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]    afi_odt                        ;
    
    // -----------------------------
    // signal declaration
    // -----------------------------
    
    reg     [(CFG_DWIDTH_RATIO/2) - 1:0]                               afi_rmw_correct                                       ;
    reg     [(CFG_DWIDTH_RATIO/2) - 1:0]                               afi_rmw_partial                                       ;
    
    wire    [CFG_MEM_IF_CKE_WIDTH- 1:0]                                int_afi_cke                 [(CFG_DWIDTH_RATIO/2)-1:0];
    wire    [CFG_MEM_IF_CHIP- 1:0]                                     int_afi_cs_n                [(CFG_DWIDTH_RATIO/2)-1:0];
    wire                                                               int_afi_ras_n               [(CFG_DWIDTH_RATIO/2)-1:0];
    wire                                                               int_afi_cas_n               [(CFG_DWIDTH_RATIO/2)-1:0];
    wire                                                               int_afi_we_n                [(CFG_DWIDTH_RATIO/2)-1:0];
    wire    [CFG_MEM_IF_BA_WIDTH - 1:0]                                int_afi_ba                  [(CFG_DWIDTH_RATIO/2)-1:0];
    wire    [CFG_MEM_IF_ADDR_WIDTH:0]                                  int_afi_addr                [(CFG_DWIDTH_RATIO/2)-1:0];
    wire                                                               int_afi_rst_n               [(CFG_DWIDTH_RATIO/2)-1:0];
    wire                                                               int_afi_rmw_correct         [(CFG_DWIDTH_RATIO/2)-1:0];
    wire                                                               int_afi_rmw_partial         [(CFG_DWIDTH_RATIO/2)-1:0];
    
    reg     [(CFG_MEM_IF_CKE_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]   phase_afi_cke               [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_MEM_IF_CHIP * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]        phase_afi_cs_n              [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            phase_afi_ras_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            phase_afi_cas_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            phase_afi_we_n              [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_MEM_IF_BA_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]    phase_afi_ba                [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_MEM_IF_ADDR_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]  phase_afi_addr              [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            phase_afi_rst_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            phase_afi_rmw_correct       [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            phase_afi_rmw_partial       [CFG_AFI_INTF_PHASE_NUM-1:0];
    
    wire    [(CFG_MEM_IF_CKE_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]   int_ddrx_afi_cke               [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_CHIP * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]        int_ddrx_afi_cs_n              [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_ddrx_afi_ras_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_ddrx_afi_cas_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_ddrx_afi_we_n              [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_BA_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]    int_ddrx_afi_ba                [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_ADDR_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]  int_ddrx_afi_addr              [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_ddrx_afi_rst_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_ddrx_afi_rmw_correct       [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_ddrx_afi_rmw_partial       [CFG_AFI_INTF_PHASE_NUM-1:0];
    
    wire    [(CFG_MEM_IF_CKE_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]   int_lpddr2_afi_cke               [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_CHIP * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]        int_lpddr2_afi_cs_n              [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_ADDR_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]  int_lpddr2_afi_addr              [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_lpddr2_afi_rst_n             [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_lpddr2_afi_rmw_correct       [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            int_lpddr2_afi_rmw_partial       [CFG_AFI_INTF_PHASE_NUM-1:0];
    
    wire    [(CFG_MEM_IF_CKE_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]   mux_afi_cke                 [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_CHIP * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]        mux_afi_cs_n                [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            mux_afi_ras_n               [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            mux_afi_cas_n               [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            mux_afi_we_n                [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_BA_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]    mux_afi_ba                  [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_ADDR_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]  mux_afi_addr                [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            mux_afi_rst_n               [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            mux_afi_rmw_correct         [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            mux_afi_rmw_partial         [CFG_AFI_INTF_PHASE_NUM-1:0];
    
    wire    [(CFG_MEM_IF_CKE_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]   fr_afi_cke                  ;
    wire    [(CFG_MEM_IF_CHIP * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]        fr_afi_cs_n                 ;
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            fr_afi_ras_n                ;
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            fr_afi_cas_n                ;
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            fr_afi_we_n                 ;
    wire    [(CFG_MEM_IF_BA_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]    fr_afi_ba                   ;
    wire    [(CFG_MEM_IF_ADDR_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) - 1:0]  fr_afi_addr                 ;
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            fr_afi_rst_n                ;
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            fr_afi_rmw_correct          ;
    wire    [(CFG_FR_DWIDTH_RATIO/2) - 1:0]                            fr_afi_rmw_partial          ;
    
    wire    [(CFG_MEM_IF_CKE_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]      lpddr2_cke;
    wire    [(CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO/2)) - 1:0]           lpddr2_cs_n;
    wire    [(CFG_DWIDTH_RATIO/2) - 1:0]                               lpddr2_ras_n;
    wire    [(CFG_DWIDTH_RATIO/2) - 1:0]                               lpddr2_cas_n;
    wire    [(CFG_DWIDTH_RATIO/2) - 1:0]                               lpddr2_we_n;
    wire    [(CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]       lpddr2_ba;
    wire    [(CFG_MEM_IF_ADDR_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]     lpddr2_addr;
    wire    [(CFG_DWIDTH_RATIO/2) - 1:0]                               lpddr2_rst_n;
    
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_write                                          ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_read                                           ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_burst_chop                                     ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_burst_terminate                                ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_auto_precharge                                 ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_rmw_correct                                    ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_rmw_partial                                    ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_activate                                       ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_precharge                                      ;
    
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_rmw_correct_r                                  ;
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_rmw_partial_r                                  ;
    
    reg     [CFG_MEM_IF_CHIP                   - 1 : 0]                int_bg_do_precharge_all     [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_CHIP                   - 1 : 0]                int_bg_do_refresh           [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_CHIP                   - 1 : 0]                int_bg_do_self_refresh      [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_CHIP                   - 1 : 0]                int_bg_do_power_down        [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_CHIP                   - 1 : 0]                int_bg_do_deep_pdown        [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_CHIP                   - 1 : 0]                int_bg_do_zq_cal            [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                int_bg_do_lmr                                           ;
    
    reg     [CFG_MEM_IF_CHIP       -1:0]                               int_bg_to_chip              [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_BA_WIDTH   -1:0]                               int_bg_to_bank              [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_ROW_WIDTH  -1:0]                               int_bg_to_row               [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg     [CFG_MEM_IF_COL_WIDTH  -1:0]                               int_bg_to_col               [CFG_AFI_INTF_PHASE_NUM-1:0];
    
    reg     [CFG_LOCAL_ID_WIDTH                - 1 : 0]                int_bg_localid;
    reg     [CFG_DATA_ID_WIDTH                 - 1 : 0]                int_bg_dataid;
    reg     [CFG_INT_SIZE_WIDTH                - 1 : 0]                int_bg_size;
    
    reg                                                                int_bg_do_lmr_read;
    reg                                                                int_bg_do_refresh_1bank;
    
    wire    [(CFG_MEM_IF_ODT_WIDTH*(CFG_DWIDTH_RATIO/2)) - 1 : 0]      afi_odt_h_l                 [CFG_AFI_INTF_PHASE_NUM-1:0];
    wire    [(CFG_MEM_IF_ODT_WIDTH*(CFG_DWIDTH_RATIO/2)) - 1 : 0]      mux_afi_odt_h_l             [CFG_AFI_INTF_PHASE_NUM-1:0];
    
    reg     [CFG_AFI_INTF_PHASE_NUM            - 1 : 0]                cfg_enable_chipsel_for_sideband;
    
    reg     [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0]  bg_do_self_refresh_r;
    reg     [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0]  bg_do_deep_pdown_r;
    
    wire    one  = 1'b1;
    wire    zero = 1'b0;
    
    // -----------------------------
    // module definition
    // -----------------------------
    
    genvar afi_j, afi_n;
    generate
        // map int_afi_* multi-dimensional array signals to afi_* output port signals
        for (afi_n = 0; afi_n < (CFG_DWIDTH_RATIO/2); afi_n = afi_n + 1'b1)
        begin : gen_afi_signals
            always @ (*) 
            begin
                    afi_cke         [((afi_n+1) * CFG_MEM_IF_CKE_WIDTH) -1 : (afi_n * CFG_MEM_IF_CKE_WIDTH)]  = int_afi_cke           [afi_n] ;
                    afi_cs_n        [((afi_n+1) * CFG_MEM_IF_CHIP)      -1 : (afi_n * CFG_MEM_IF_CHIP)]       = int_afi_cs_n          [afi_n] ;
                    afi_ras_n       [afi_n]                                                                   = int_afi_ras_n         [afi_n] ;
                    afi_cas_n       [afi_n]                                                                   = int_afi_cas_n         [afi_n] ;
                    afi_we_n        [afi_n]                                                                   = int_afi_we_n          [afi_n] ;
                    afi_ba          [((afi_n+1) * CFG_MEM_IF_BA_WIDTH)  -1 : (afi_n * CFG_MEM_IF_BA_WIDTH)]   = int_afi_ba            [afi_n] ;
                    afi_addr        [((afi_n+1) * CFG_MEM_IF_ADDR_WIDTH)-1 : (afi_n * CFG_MEM_IF_ADDR_WIDTH)] = int_afi_addr          [afi_n] ;
                    afi_rst_n       [afi_n]                                                                   = int_afi_rst_n         [afi_n] ;
                    //afi_odt         [((afi_n+1) * CFG_MEM_IF_ODT_WIDTH) -1 : (afi_n * CFG_MEM_IF_ODT_WIDTH)]  = int_afi_odt           [afi_n] ;
                    afi_rmw_correct [afi_n]                                                                   = int_afi_rmw_correct   [afi_n] ;
                    afi_rmw_partial [afi_n]                                                                   = int_afi_rmw_partial   [afi_n] ;
            end
        end
        
        // generate int_afi_* signals based on CFG_DWIDTH_RATIO & CFG_AFI_INTF_PHASE_NUM
        
        if (CFG_DWIDTH_RATIO == 2)
        begin
            // full rate, with any phase
            assign int_afi_cke         [0] = fr_afi_cke         ;
            assign int_afi_cs_n        [0] = fr_afi_cs_n        ;
            assign int_afi_ras_n       [0] = fr_afi_ras_n       ;
            assign int_afi_cas_n       [0] = fr_afi_cas_n       ;
            assign int_afi_we_n        [0] = fr_afi_we_n        ;
            assign int_afi_ba          [0] = fr_afi_ba          ;
            assign int_afi_addr        [0] = fr_afi_addr        ;
            assign int_afi_rst_n       [0] = fr_afi_rst_n       ;
            assign int_afi_rmw_correct [0] = fr_afi_rmw_correct ;
            assign int_afi_rmw_partial [0] = fr_afi_rmw_partial ;
        end
        else if ((CFG_DWIDTH_RATIO/2) == CFG_AFI_INTF_PHASE_NUM)
        begin
            // map phase_afi_* signals to int_afi_* signals
            // half rate   , with phase=2
            // quarter rate, with phase=4
            for (afi_j = 0; afi_j < CFG_AFI_INTF_PHASE_NUM; afi_j = afi_j + 1'b1)
            begin : gen_afi_signals_0
                assign int_afi_cke         [afi_j] = phase_afi_cke         [afi_j] ;
                assign int_afi_cs_n        [afi_j] = phase_afi_cs_n        [afi_j] ;
                assign int_afi_ras_n       [afi_j] = phase_afi_ras_n       [afi_j] ;
                assign int_afi_cas_n       [afi_j] = phase_afi_cas_n       [afi_j] ;
                assign int_afi_we_n        [afi_j] = phase_afi_we_n        [afi_j] ;
                assign int_afi_ba          [afi_j] = phase_afi_ba          [afi_j] ;
                assign int_afi_addr        [afi_j] = phase_afi_addr        [afi_j] ;
                assign int_afi_rst_n       [afi_j] = phase_afi_rst_n       [afi_j] ;
                assign int_afi_rmw_correct [afi_j] = phase_afi_rmw_correct [afi_j] ;
                assign int_afi_rmw_partial [afi_j] = phase_afi_rmw_partial [afi_j] ;
            end
        end
        else    // only supports case CFG_AFI_INTF_PHASE_NUM < (CFG_DWIDTH_RATIO/2)
        begin
            // map phase_afi_* signals to selected int_afi_* signals, and drive the rest to default values
            
            // for cs_n signals:
            // half rate    , with phase=1, drives int_afi_* 1 only
            // quarter rate , with phase=2, drives int_afi_* 1 & 3
            
            // for other signals:
            // half rate    , with phase=1, drives int_afi_* 0 & 1 with the same value
            // quarter rate , with phase=2, drives int_afi_* 0 & 1 or 2 & 3 with the same value
            // Why? to improve timing margin on PHY side
            
            for (afi_j = 0; afi_j < (CFG_DWIDTH_RATIO/2); afi_j = afi_j + 1) 
            begin : gen_afi_signals_1
                // Assign even phase with '1' because we only issue on odd phase (2T timing)
                assign int_afi_cs_n        [afi_j] = ((afi_j % CFG_AFI_INTF_PHASE_NUM) == 1) ? phase_afi_cs_n [afi_j / CFG_AFI_INTF_PHASE_NUM] : { CFG_MEM_IF_CHIP {1'b1} };
                
                // Assign the last CKE with phase_afi_cs_n[1], the rest with phase_afi_cs_n[0]
                assign int_afi_cke         [afi_j] = (afi_j == ((CFG_DWIDTH_RATIO/2) - 1))   ? phase_afi_cke  [1]                              : phase_afi_cke  [0];
                
                assign int_afi_ras_n       [afi_j] = phase_afi_ras_n       [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_cas_n       [afi_j] = phase_afi_cas_n       [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_we_n        [afi_j] = phase_afi_we_n        [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_ba          [afi_j] = phase_afi_ba          [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_addr        [afi_j] = phase_afi_addr        [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_rst_n       [afi_j] = phase_afi_rst_n       [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_rmw_correct [afi_j] = phase_afi_rmw_correct [afi_j / CFG_AFI_INTF_PHASE_NUM];
                assign int_afi_rmw_partial [afi_j] = phase_afi_rmw_partial [afi_j / CFG_AFI_INTF_PHASE_NUM];
            end
        end
    endgenerate
    
    // phase_afi_* signal generation
    // instantiates an alt_mem_ddrx_addr_cmd for every phase
    // maps bg_* signals to the correct instantiation
    genvar afi_k;
    generate
        for (afi_k = 0; afi_k < CFG_AFI_INTF_PHASE_NUM; afi_k = afi_k + 1) 
        begin : gen_bg_afi_signal_decode

            always @ (*)
            begin
                int_bg_do_write             [afi_k] = bg_do_write           [afi_k];
                int_bg_do_read              [afi_k] = bg_do_read            [afi_k];
                int_bg_do_burst_chop        [afi_k] = bg_do_burst_chop      [afi_k];
                int_bg_do_burst_terminate   [afi_k] = bg_do_burst_terminate [afi_k];
                int_bg_do_auto_precharge    [afi_k] = bg_do_auto_precharge  [afi_k];
                int_bg_do_rmw_correct       [afi_k] = bg_do_rmw_correct     [afi_k];
                int_bg_do_rmw_partial       [afi_k] = bg_do_rmw_partial     [afi_k];
                int_bg_do_activate          [afi_k] = bg_do_activate        [afi_k];
                int_bg_do_precharge         [afi_k] = bg_do_precharge       [afi_k];
                                                                                   
                int_bg_to_chip              [afi_k] = bg_to_chip            [(((afi_k+1)*CFG_MEM_IF_CHIP     )-1):(afi_k*CFG_MEM_IF_CHIP     )];
                int_bg_to_bank              [afi_k] = bg_to_bank            [(((afi_k+1)*CFG_MEM_IF_BA_WIDTH )-1):(afi_k*CFG_MEM_IF_BA_WIDTH )];
                int_bg_to_row               [afi_k] = bg_to_row             [(((afi_k+1)*CFG_MEM_IF_ROW_WIDTH)-1):(afi_k*CFG_MEM_IF_ROW_WIDTH)];
                int_bg_to_col               [afi_k] = bg_to_col             [(((afi_k+1)*CFG_MEM_IF_COL_WIDTH)-1):(afi_k*CFG_MEM_IF_COL_WIDTH)];
            end
            
            if (CFG_DWIDTH_RATIO == 2) // full rate
            begin
                always @ (*)
                begin
                    int_bg_do_precharge_all     [afi_k] = bg_do_precharge_all   [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )];
                    int_bg_do_refresh           [afi_k] = bg_do_refresh         [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )];
                    int_bg_do_self_refresh      [afi_k] = bg_do_self_refresh    [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )];
                    int_bg_do_power_down        [afi_k] = bg_do_power_down      [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )];
                    int_bg_do_deep_pdown        [afi_k] = bg_do_deep_pdown      [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )];
                    int_bg_do_zq_cal            [afi_k] = bg_do_zq_cal          [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )];
                    int_bg_do_lmr               [afi_k] = bg_do_lmr             [afi_k];
                end
                
                always @ (*)
                begin
                    cfg_enable_chipsel_for_sideband [afi_k] = one;
                end
            end
            else // half and quarter rate
            begin
                always @ (*)
                begin
                    int_bg_do_precharge_all     [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? bg_do_precharge_all   [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )] : 0;
                    int_bg_do_refresh           [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? bg_do_refresh         [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )] : 0;
                    int_bg_do_zq_cal            [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? bg_do_zq_cal          [(((afi_k+1)*CFG_MEM_IF_CHIP    )-1):(afi_k*CFG_MEM_IF_CHIP      )] : 0;
                    int_bg_do_lmr               [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? bg_do_lmr             [afi_k                                                            ] : 0;
                    
                    // We need to assign these command to all phase
                    // because these command might take one or more controller clock cycles
                    // and we want to prevent CKE from toggling due to prolong commands
                    int_bg_do_power_down        [afi_k] = bg_do_power_down   [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)];
                    
                    int_bg_do_self_refresh      [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? bg_do_self_refresh [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)] :
                                                                                                    bg_do_self_refresh [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)] & bg_do_self_refresh_r [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)];
                    int_bg_do_deep_pdown        [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? bg_do_deep_pdown   [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)] :
                                                                                                    bg_do_deep_pdown   [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)] & bg_do_deep_pdown_r   [(((afi_k+1)*CFG_MEM_IF_CHIP)-1):(afi_k*CFG_MEM_IF_CHIP)];
                end
                
                always @ (*)
                begin
                    // We need to disable one phase of chipsel logic for sideband in half/quarter rate
                    // in order to prevent CS_N from going low for 2 clock cycles (deep power down and self refresh only)
                    cfg_enable_chipsel_for_sideband [afi_k] = ((afi_k % CFG_AFI_INTF_PHASE_NUM) == 1) ? one : zero;
                end
            end
            
            // addresss command block instantiated based on number of phases
            alt_mem_ddrx_addr_cmd  # (
                .CFG_PORT_WIDTH_TYPE                ( CFG_PORT_WIDTH_TYPE                     ),
                .CFG_PORT_WIDTH_OUTPUT_REGD         ( CFG_PORT_WIDTH_OUTPUT_REGD              ),
                .CFG_MEM_IF_CHIP                    ( CFG_MEM_IF_CHIP                         ),
                .CFG_MEM_IF_CKE_WIDTH               ( CFG_MEM_IF_CKE_WIDTH                    ),
                .CFG_MEM_IF_ADDR_WIDTH              ( CFG_MEM_IF_ADDR_WIDTH                   ),
                .CFG_MEM_IF_ROW_WIDTH               ( CFG_MEM_IF_ROW_WIDTH                    ),
                .CFG_MEM_IF_COL_WIDTH               ( CFG_MEM_IF_COL_WIDTH                    ),
                .CFG_MEM_IF_BA_WIDTH                ( CFG_MEM_IF_BA_WIDTH                     ),
                .CFG_DWIDTH_RATIO                   ( CFG_FR_DWIDTH_RATIO                     )
            ) alt_mem_ddrx_addr_cmd_inst (
                .ctl_clk                            ( ctl_clk                                 ),
                .ctl_reset_n                        ( ctl_reset_n                             ),
                .ctl_cal_success                    ( ctl_cal_success                         ),
                .cfg_type                           ( cfg_type                                ),
                .cfg_output_regd                    ( cfg_output_regd_for_afi_output          ),
                .cfg_enable_chipsel_for_sideband    ( cfg_enable_chipsel_for_sideband [afi_k] ),
                .bg_do_write                        ( int_bg_do_write                 [afi_k] ),
                .bg_do_read                         ( int_bg_do_read                  [afi_k] ),
                .bg_do_auto_precharge               ( int_bg_do_auto_precharge        [afi_k] ),
                .bg_do_burst_chop                   ( int_bg_do_burst_chop            [afi_k] ),
                .bg_do_activate                     ( int_bg_do_activate              [afi_k] ),
                .bg_do_precharge                    ( int_bg_do_precharge             [afi_k] ),
                .bg_do_refresh                      ( int_bg_do_refresh               [afi_k] ),
                .bg_do_power_down                   ( int_bg_do_power_down            [afi_k] ),
                .bg_do_self_refresh                 ( int_bg_do_self_refresh          [afi_k] ),
                .bg_do_lmr                          ( int_bg_do_lmr                   [afi_k] ),
                .bg_do_precharge_all                ( int_bg_do_precharge_all         [afi_k] ),
                .bg_do_zq_cal                       ( int_bg_do_zq_cal                [afi_k] ),
                .bg_do_deep_pdown                   ( int_bg_do_deep_pdown            [afi_k] ),
                .bg_do_burst_terminate              ( int_bg_do_burst_terminate       [afi_k] ),
                .bg_to_chip                         ( int_bg_to_chip                  [afi_k] ),
                .bg_to_bank                         ( int_bg_to_bank                  [afi_k] ),
                .bg_to_row                          ( int_bg_to_row                   [afi_k] ),
                .bg_to_col                          ( int_bg_to_col                   [afi_k] ),
                .bg_to_lmr                          (                                         ),
                .lmr_opcode                         ( lmr_opcode                              ),
                .afi_cke                            ( int_ddrx_afi_cke                [afi_k] ),
                .afi_cs_n                           ( int_ddrx_afi_cs_n               [afi_k] ),
                .afi_ras_n                          ( int_ddrx_afi_ras_n              [afi_k] ),
                .afi_cas_n                          ( int_ddrx_afi_cas_n              [afi_k] ),
                .afi_we_n                           ( int_ddrx_afi_we_n               [afi_k] ),
                .afi_ba                             ( int_ddrx_afi_ba                 [afi_k] ),
                .afi_addr                           ( int_ddrx_afi_addr               [afi_k] ),
                .afi_rst_n                          ( int_ddrx_afi_rst_n              [afi_k] )
            );

            if (CFG_LPDDR2_ENABLED)
            begin
                alt_mem_ddrx_lpddr2_addr_cmd  # (
                    .CFG_PORT_WIDTH_OUTPUT_REGD     (CFG_PORT_WIDTH_OUTPUT_REGD        ),
                    .CFG_MEM_IF_CHIP                (CFG_MEM_IF_CHIP                   ),
                    .CFG_MEM_IF_CKE_WIDTH           (CFG_MEM_IF_CKE_WIDTH              ),
                    .CFG_MEM_IF_ADDR_WIDTH          (CFG_MEM_IF_ADDR_WIDTH             ),
                    .CFG_MEM_IF_ROW_WIDTH           (CFG_MEM_IF_ROW_WIDTH              ),
                    .CFG_MEM_IF_COL_WIDTH           (CFG_MEM_IF_COL_WIDTH              ),
                    .CFG_MEM_IF_BA_WIDTH            (CFG_MEM_IF_BA_WIDTH               ),
                    .CFG_DWIDTH_RATIO               (CFG_FR_DWIDTH_RATIO               )
                ) alt_mem_ddrx_lpddr2_addr_cmd_inst (
                    .ctl_clk                        (ctl_clk                           ),
                    .ctl_reset_n                    (ctl_reset_n                       ),
                    .ctl_cal_success                (ctl_cal_success                   ),
                    .cfg_output_regd                (cfg_output_regd_for_afi_output    ),
                    .do_write                       (int_bg_do_write           [afi_k] ),
                    .do_read                        (int_bg_do_read            [afi_k] ),
                    .do_auto_precharge              (int_bg_do_auto_precharge  [afi_k] ),
                    .do_activate                    (int_bg_do_activate        [afi_k] ),
                    .do_precharge                   (int_bg_do_precharge       [afi_k] ),
                    .do_refresh                     (int_bg_do_refresh         [afi_k] ),
                    .do_power_down                  (int_bg_do_power_down      [afi_k] ),
                    .do_self_refresh                (int_bg_do_self_refresh    [afi_k] ),
                    .do_lmr                         (int_bg_do_lmr             [afi_k] ),
                    .do_precharge_all               (int_bg_do_precharge_all   [afi_k] ),
                    .do_deep_pwrdwn                 (int_bg_do_deep_pdown      [afi_k] ),
                    .do_burst_terminate             (int_bg_do_burst_terminate [afi_k] ),
                    .do_lmr_read                    (int_bg_do_lmr_read                ),
                    .do_refresh_1bank               (int_bg_do_refresh_1bank           ),
                    .to_chip                        (int_bg_to_chip            [afi_k] ),
                    .to_bank                        (int_bg_to_bank            [afi_k] ),
                    .to_row                         (int_bg_to_row             [afi_k] ),
                    .to_col                         (int_bg_to_col             [afi_k] ),
                    .to_lmr                         (                                  ),
                    .lmr_opcode                     (lmr_opcode[7:0]                   ),
                    .afi_cke                        (int_lpddr2_afi_cke        [afi_k] ),
                    .afi_cs_n                       (int_lpddr2_afi_cs_n       [afi_k] ),
                    .afi_addr                       (int_lpddr2_afi_addr       [afi_k] ),
                    .afi_rst_n                      (int_lpddr2_afi_rst_n      [afi_k] )
                );
            end
            else
            begin
                assign int_lpddr2_afi_cke   [afi_k] = {(CFG_MEM_IF_CKE_WIDTH    * (CFG_FR_DWIDTH_RATIO/2)) {1'b0}}; 
                assign int_lpddr2_afi_cs_n  [afi_k] = {(CFG_MEM_IF_CHIP         * (CFG_FR_DWIDTH_RATIO/2)) {1'b0}};
                assign int_lpddr2_afi_addr  [afi_k] = {(CFG_MEM_IF_ADDR_WIDTH   * (CFG_FR_DWIDTH_RATIO/2)) {1'b0}};
                assign int_lpddr2_afi_rst_n [afi_k] = {                           (CFG_FR_DWIDTH_RATIO/2)  {1'b0}};
            end
            
            always @ (*)
            begin
                // Mux to select ddrx or lpddr2 addrcmd decoder blocks
                if (cfg_type == `MMR_TYPE_LPDDR2)
                begin
                    phase_afi_cke   [afi_k] = int_lpddr2_afi_cke  [afi_k] ;
                    phase_afi_cs_n  [afi_k] = int_lpddr2_afi_cs_n [afi_k] ;
                    phase_afi_ras_n [afi_k] = {(CFG_FR_DWIDTH_RATIO/2){1'b0}};
                    phase_afi_cas_n [afi_k] = {(CFG_FR_DWIDTH_RATIO/2){1'b0}};
                    phase_afi_we_n  [afi_k] = {(CFG_FR_DWIDTH_RATIO/2){1'b0}};
                    phase_afi_ba    [afi_k] = {(CFG_MEM_IF_BA_WIDTH * (CFG_FR_DWIDTH_RATIO/2)) {1'b0}};
                    phase_afi_addr  [afi_k] = int_lpddr2_afi_addr [afi_k] ;
                    phase_afi_rst_n [afi_k] = int_lpddr2_afi_rst_n[afi_k] ;
                end
                else
                begin
                    phase_afi_cke   [afi_k] = int_ddrx_afi_cke   [afi_k] ;
                    phase_afi_cs_n  [afi_k] = int_ddrx_afi_cs_n  [afi_k] ;
                    phase_afi_ras_n [afi_k] = int_ddrx_afi_ras_n [afi_k] ;
                    phase_afi_cas_n [afi_k] = int_ddrx_afi_cas_n [afi_k] ;
                    phase_afi_we_n  [afi_k] = int_ddrx_afi_we_n  [afi_k] ;
                    phase_afi_ba    [afi_k] = int_ddrx_afi_ba    [afi_k] ;
                    phase_afi_addr  [afi_k] = int_ddrx_afi_addr  [afi_k] ;
                    phase_afi_rst_n [afi_k] = int_ddrx_afi_rst_n [afi_k] ;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n) 
            begin
                if (~ctl_reset_n)
                begin
                    int_bg_do_rmw_correct_r[afi_k] <= {(CFG_FR_DWIDTH_RATIO/2){1'b0}};
                    int_bg_do_rmw_partial_r[afi_k] <= {(CFG_FR_DWIDTH_RATIO/2){1'b0}};
                end
                else
                begin
                    int_bg_do_rmw_correct_r[afi_k] <= int_bg_do_rmw_correct [afi_k];
                    int_bg_do_rmw_partial_r[afi_k] <= int_bg_do_rmw_partial [afi_k];
                end
            end
            
            always @ (*) 
            begin
                if (cfg_output_regd_for_afi_output)
                begin
                    phase_afi_rmw_correct[afi_k] = int_bg_do_rmw_correct_r [afi_k];
                    phase_afi_rmw_partial[afi_k] = int_bg_do_rmw_partial_r [afi_k];
                end
                else
                begin
                    phase_afi_rmw_correct[afi_k] = int_bg_do_rmw_correct [afi_k];
                    phase_afi_rmw_partial[afi_k] = int_bg_do_rmw_partial [afi_k];
                end
            end
            
            alt_mem_ddrx_odt_gen #
            (
                .CFG_DWIDTH_RATIO               (CFG_DWIDTH_RATIO               ),
                .CFG_ODT_ENABLED                (CFG_ODT_ENABLED                ),
                .CFG_MEM_IF_CHIP                (CFG_MEM_IF_CHIP                ),
                .CFG_MEM_IF_ODT_WIDTH           (CFG_MEM_IF_ODT_WIDTH           ),
                .CFG_PORT_WIDTH_CAS_WR_LAT      (CFG_PORT_WIDTH_CAS_WR_LAT      ),
                .CFG_PORT_WIDTH_TCL             (CFG_PORT_WIDTH_TCL             ),
                .CFG_PORT_WIDTH_ADD_LAT         (CFG_PORT_WIDTH_ADD_LAT         ),
                .CFG_PORT_WIDTH_TYPE            (CFG_PORT_WIDTH_TYPE            ),
                .CFG_PORT_WIDTH_WRITE_ODT_CHIP  (CFG_PORT_WIDTH_WRITE_ODT_CHIP  ),
                .CFG_PORT_WIDTH_READ_ODT_CHIP   (CFG_PORT_WIDTH_READ_ODT_CHIP   ),
                .CFG_PORT_WIDTH_OUTPUT_REGD     (CFG_PORT_WIDTH_OUTPUT_REGD     )
            )
            odt_gen_inst
            (
                .ctl_clk                        (ctl_clk                        ),
                .ctl_reset_n                    (ctl_reset_n                    ),
                .cfg_type                       (cfg_type                       ),
                .cfg_tcl                        (cfg_tcl                        ),
                .cfg_cas_wr_lat                 (cfg_cas_wr_lat                 ),
                .cfg_add_lat                    (cfg_add_lat                    ),
                .cfg_write_odt_chip             (cfg_write_odt_chip             ),
                .cfg_read_odt_chip              (cfg_read_odt_chip              ),
                .cfg_burst_length               (cfg_burst_length               ),
                .cfg_output_regd                (cfg_output_regd_for_afi_output ),
                .bg_do_read                     (int_bg_do_read          [afi_k]),
                .bg_do_write                    (int_bg_do_write         [afi_k]),
                .bg_do_burst_chop               (int_bg_do_burst_chop    [afi_k]),
                .bg_to_chip                     (int_bg_to_chip          [afi_k]),
                .afi_odt                        (afi_odt_h_l             [afi_k])
            );
        end
        
        always @ (*)
        begin
            int_bg_dataid           = bg_dataid;
            int_bg_localid          = bg_localid;
            int_bg_size             = bg_size;
            int_bg_do_lmr_read      = bg_do_lmr_read;
            int_bg_do_refresh_1bank = bg_do_refresh_1bank;
        end
    endgenerate
    
    // ODT output generation
    always @ (*)
    begin
        afi_odt = mux_afi_odt_h_l [CFG_AFI_INTF_PHASE_NUM-1];
    end
    
    // generate ODT output signal from odt_gen
    assign mux_afi_odt_h_l [0] = afi_odt_h_l [0];
    
    genvar afi_m;
    generate
        for (afi_m = 1; afi_m < CFG_AFI_INTF_PHASE_NUM; afi_m = afi_m + 1)
        begin : mux_for_odt
            assign mux_afi_odt_h_l [afi_m] = mux_afi_odt_h_l [afi_m-1] | afi_odt_h_l [afi_m];
        end
    endgenerate
    
    // generate fr_* signals from phase_* signals
    assign mux_afi_cke               [0]  =     phase_afi_cke               [0];
    assign mux_afi_cs_n              [0]  =     phase_afi_cs_n              [0];
    assign mux_afi_ras_n             [0]  =     phase_afi_ras_n             [0];
    assign mux_afi_cas_n             [0]  =     phase_afi_cas_n             [0];
    assign mux_afi_we_n              [0]  =     phase_afi_we_n              [0];
    assign mux_afi_ba                [0]  =     phase_afi_ba                [0];
    assign mux_afi_addr              [0]  =     phase_afi_addr              [0];
    assign mux_afi_rst_n             [0]  =     phase_afi_rst_n             [0];
    assign mux_afi_rmw_correct       [0]  =     phase_afi_rmw_correct       [0];
    assign mux_afi_rmw_partial       [0]  =     phase_afi_rmw_partial       [0];
    
    genvar afi_l;
    generate
        for (afi_l = 1; afi_l < CFG_AFI_INTF_PHASE_NUM; afi_l = afi_l + 1)
        begin : gen_resolve_phase_for_fullrate
            assign mux_afi_cke               [afi_l]  =  mux_afi_cke         [(afi_l-1)] & phase_afi_cke         [afi_l];
            assign mux_afi_cs_n              [afi_l]  =  mux_afi_cs_n        [(afi_l-1)] & phase_afi_cs_n        [afi_l];
            assign mux_afi_ras_n             [afi_l]  =  mux_afi_ras_n       [(afi_l-1)] & phase_afi_ras_n       [afi_l];
            assign mux_afi_cas_n             [afi_l]  =  mux_afi_cas_n       [(afi_l-1)] & phase_afi_cas_n       [afi_l];
            assign mux_afi_we_n              [afi_l]  =  mux_afi_we_n        [(afi_l-1)] & phase_afi_we_n        [afi_l];
            assign mux_afi_ba                [afi_l]  =  mux_afi_ba          [(afi_l-1)] | phase_afi_ba          [afi_l];
            assign mux_afi_addr              [afi_l]  =  mux_afi_addr        [(afi_l-1)] | phase_afi_addr        [afi_l];
            assign mux_afi_rst_n             [afi_l]  =  mux_afi_rst_n       [(afi_l-1)] | phase_afi_rst_n       [afi_l];
            assign mux_afi_rmw_correct       [afi_l]  =  mux_afi_rmw_correct [(afi_l-1)] | phase_afi_rmw_correct [afi_l];
            assign mux_afi_rmw_partial       [afi_l]  =  mux_afi_rmw_partial [(afi_l-1)] | phase_afi_rmw_partial [afi_l];
        end
    endgenerate
    
    assign fr_afi_cke         = mux_afi_cke         [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_cs_n        = mux_afi_cs_n        [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_ras_n       = mux_afi_ras_n       [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_cas_n       = mux_afi_cas_n       [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_we_n        = mux_afi_we_n        [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_ba          = mux_afi_ba          [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_addr        = mux_afi_addr        [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_rst_n       = mux_afi_rst_n       [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_rmw_correct = mux_afi_rmw_correct [CFG_AFI_INTF_PHASE_NUM-1];
    assign fr_afi_rmw_partial = mux_afi_rmw_partial [CFG_AFI_INTF_PHASE_NUM-1];
    
    // Registered version of self refresh and power down
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            bg_do_self_refresh_r <= 0;
            bg_do_deep_pdown_r   <= 0;
        end
        else
        begin
            bg_do_self_refresh_r <= bg_do_self_refresh;
            bg_do_deep_pdown_r   <= bg_do_deep_pdown;
        end
    end
    
endmodule
