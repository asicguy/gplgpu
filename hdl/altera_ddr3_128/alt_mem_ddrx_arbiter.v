
//altera message_off 10230 10036

`timescale 1 ps / 1 ps
module alt_mem_ddrx_arbiter #
    ( parameter
        CFG_DWIDTH_RATIO            =   4,
        CFG_CTL_TBP_NUM             =   4,
        CFG_CTL_ARBITER_TYPE        =   "ROWCOL",
        CFG_REG_GRANT               =   0,
        CFG_REG_REQ                 =   0,
        CFG_MEM_IF_CHIP             =   1,
        CFG_MEM_IF_CS_WIDTH         =   1,
        CFG_MEM_IF_BA_WIDTH         =   3,
        CFG_MEM_IF_ROW_WIDTH        =   13,
        CFG_MEM_IF_COL_WIDTH        =   10,
        CFG_LOCAL_ID_WIDTH          =   10,
        CFG_DATA_ID_WIDTH           =   10,
        CFG_INT_SIZE_WIDTH          =   4,
        CFG_AFI_INTF_PHASE_NUM      =   2,
        CFG_DISABLE_PRIORITY        =   1
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // Common
        stall_row_arbiter,
        stall_col_arbiter,
        
        // Sideband Interface
        sb_do_precharge_all,
        sb_do_refresh,
        sb_do_self_refresh,
        sb_do_power_down,
        sb_do_deep_pdown,
        sb_do_zq_cal,
        
        // TBP Interface
        row_req,
        col_req,
        act_req,
        pch_req,
        rd_req,
        wr_req,
        row_grant,
        col_grant,
        act_grant,
        pch_grant,
        rd_grant,
        wr_grant,
        log2_row_grant,
        log2_col_grant,
        log2_act_grant,
        log2_pch_grant,
        log2_rd_grant,
        log2_wr_grant,
        or_row_grant,
        or_col_grant,
        tbp_activate,
        tbp_precharge,
        tbp_read,
        tbp_write,
        tbp_chipsel,
        tbp_bank,
        tbp_row,
        tbp_col,
        tbp_size,
        tbp_localid,
        tbp_dataid,
        tbp_ap,
        tbp_burst_chop,
        tbp_rmw_correct,
        tbp_rmw_partial,
        tbp_age,
        tbp_priority,
        
        // Rank Timer Interface
        can_activate,
        can_precharge,
        can_write,
        can_read,
        
        // Arbiter Output Interface
        arb_do_write,
        arb_do_read,
        arb_do_burst_chop,
        arb_do_burst_terminate,
        arb_do_auto_precharge,
        arb_do_rmw_correct,
        arb_do_rmw_partial,
        arb_do_activate,
        arb_do_precharge,
        arb_do_precharge_all,
        arb_do_refresh,
        arb_do_self_refresh,
        arb_do_power_down,
        arb_do_deep_pdown,
        arb_do_zq_cal,
        arb_do_lmr,
        arb_to_chipsel,
        arb_to_chip,
        arb_to_bank,
        arb_to_row,
        arb_to_col,
        arb_localid,
        arb_dataid,
        arb_size
    );

localparam AFI_INTF_LOW_PHASE  = 0;
localparam AFI_INTF_HIGH_PHASE = 1;

input  ctl_clk;
input  ctl_reset_n;

// Common
input  stall_row_arbiter;
input  stall_col_arbiter;

// Sideband Interface
input  [CFG_MEM_IF_CHIP                                 - 1 : 0] sb_do_precharge_all;
input  [CFG_MEM_IF_CHIP                                 - 1 : 0] sb_do_refresh;
input  [CFG_MEM_IF_CHIP                                 - 1 : 0] sb_do_self_refresh;
input  [CFG_MEM_IF_CHIP                                 - 1 : 0] sb_do_power_down;
input  [CFG_MEM_IF_CHIP                                 - 1 : 0] sb_do_deep_pdown;
input  [CFG_MEM_IF_CHIP                                 - 1 : 0] sb_do_zq_cal;

// TBP Interface
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] row_req;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] col_req;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] act_req;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] pch_req;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] rd_req;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] wr_req;
output [CFG_CTL_TBP_NUM                                 - 1 : 0] row_grant;
output [CFG_CTL_TBP_NUM                                 - 1 : 0] col_grant;
output [CFG_CTL_TBP_NUM                                 - 1 : 0] act_grant;
output [CFG_CTL_TBP_NUM                                 - 1 : 0] pch_grant;
output [CFG_CTL_TBP_NUM                                 - 1 : 0] rd_grant;
output [CFG_CTL_TBP_NUM                                 - 1 : 0] wr_grant;
output [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_row_grant;
output [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_col_grant;
output [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_act_grant;
output [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_pch_grant;
output [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_rd_grant;
output [log2(CFG_CTL_TBP_NUM)                           - 1 : 0] log2_wr_grant;
output                                                           or_row_grant;
output                                                           or_col_grant;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_activate;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_precharge;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_read;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_write;
input  [(CFG_CTL_TBP_NUM * CFG_MEM_IF_CS_WIDTH)         - 1 : 0] tbp_chipsel;
input  [(CFG_CTL_TBP_NUM * CFG_MEM_IF_BA_WIDTH)         - 1 : 0] tbp_bank;
input  [(CFG_CTL_TBP_NUM * CFG_MEM_IF_ROW_WIDTH)        - 1 : 0] tbp_row;
input  [(CFG_CTL_TBP_NUM * CFG_MEM_IF_COL_WIDTH)        - 1 : 0] tbp_col;
input  [(CFG_CTL_TBP_NUM * CFG_INT_SIZE_WIDTH)          - 1 : 0] tbp_size;
input  [(CFG_CTL_TBP_NUM * CFG_LOCAL_ID_WIDTH)          - 1 : 0] tbp_localid;
input  [(CFG_CTL_TBP_NUM * CFG_DATA_ID_WIDTH)           - 1 : 0] tbp_dataid;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_ap;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_burst_chop;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_rmw_correct;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_rmw_partial;
input  [(CFG_CTL_TBP_NUM * CFG_CTL_TBP_NUM)             - 1 : 0] tbp_age;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] tbp_priority;

// Rank Timer Interface
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] can_activate;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] can_precharge;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] can_write;
input  [CFG_CTL_TBP_NUM                                 - 1 : 0] can_read;

// Arbiter Output Interface
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_write;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_read;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_chop;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_terminate;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_auto_precharge;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_correct;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_partial;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_activate;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_precharge;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_precharge_all;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_refresh;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_self_refresh;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_power_down;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_deep_pdown;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_zq_cal;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_lmr;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] arb_to_chipsel;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_to_chip;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] arb_to_bank;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] arb_to_row;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] arb_to_col;
output [CFG_LOCAL_ID_WIDTH                              - 1 : 0] arb_localid;
output [CFG_DATA_ID_WIDTH                               - 1 : 0] arb_dataid;
output [CFG_INT_SIZE_WIDTH                              - 1 : 0] arb_size;

//--------------------------------------------------------------------------------------------------------
//
//  [START] Registers & Wires
//
//--------------------------------------------------------------------------------------------------------
    // General
    wire one  = 1'b1;
    wire zero = 1'b0;
    
    // TBP Interface
    reg  [CFG_CTL_TBP_NUM       - 1 : 0] row_grant;
    reg  [CFG_CTL_TBP_NUM       - 1 : 0] col_grant;
    reg  [CFG_CTL_TBP_NUM       - 1 : 0] act_grant;
    reg  [CFG_CTL_TBP_NUM       - 1 : 0] pch_grant;
    reg  [CFG_CTL_TBP_NUM       - 1 : 0] rd_grant;
    reg  [CFG_CTL_TBP_NUM       - 1 : 0] wr_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_row_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_col_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_act_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_pch_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_rd_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_wr_grant;
    reg                                  or_row_grant;
    reg                                  or_col_grant;
    
    // Arbiter Output Interface
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_write;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_read;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_chop;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_terminate;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_auto_precharge;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_correct;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_partial;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_activate;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_precharge;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_precharge_all;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_refresh;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_self_refresh;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_power_down;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_deep_pdown;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_zq_cal;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_lmr;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] arb_to_chipsel;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_to_chip;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] arb_to_bank;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] arb_to_row;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] arb_to_col;
    reg  [CFG_LOCAL_ID_WIDTH                              - 1 : 0] arb_localid;
    reg  [CFG_DATA_ID_WIDTH                               - 1 : 0] arb_dataid;
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] arb_size;
    
    // Common
    reg                                 granted_read        [CFG_CTL_TBP_NUM - 1 : 0];
    reg                                 granted_write       [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_CS_WIDTH  - 1 : 0] granted_chipsel_r   [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_CS_WIDTH  - 1 : 0] granted_chipsel_c   [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_CHIP      - 1 : 0] granted_to_chip_r                            ;
    reg  [CFG_MEM_IF_CHIP      - 1 : 0] granted_to_chip_c                            ;
    reg  [CFG_MEM_IF_BA_WIDTH  - 1 : 0] granted_bank_r      [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_BA_WIDTH  - 1 : 0] granted_bank_c      [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_ROW_WIDTH - 1 : 0] granted_row_r       [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_ROW_WIDTH - 1 : 0] granted_row_c       [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_MEM_IF_COL_WIDTH - 1 : 0] granted_col         [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_INT_SIZE_WIDTH   - 1 : 0] granted_size        [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_DATA_ID_WIDTH    - 1 : 0] granted_dataid      [CFG_CTL_TBP_NUM - 1 : 0];
    reg  [CFG_LOCAL_ID_WIDTH   - 1 : 0] granted_localid     [CFG_CTL_TBP_NUM - 1 : 0];
    reg                                 granted_ap          [CFG_CTL_TBP_NUM - 1 : 0];
    reg                                 granted_burst_chop  [CFG_CTL_TBP_NUM - 1 : 0];
    reg                                 granted_rmw_correct [CFG_CTL_TBP_NUM - 1 : 0];
    reg                                 granted_rmw_partial [CFG_CTL_TBP_NUM - 1 : 0];
    
    // Arbiter
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_act_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_pch_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_col_priority;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] oldest_act_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] oldest_pch_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] oldest_rd_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] oldest_wr_req_with_priority;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] oldest_row_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] oldest_col_req_with_priority;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] act_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] pch_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] rd_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] wr_req_with_priority;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] row_req_with_priority;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] col_req_with_priority;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_row_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_col_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_act_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_pch_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_rd_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_wr_grant;
    
    reg                            int_or_row_grant;
    reg                            int_or_col_grant;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] granted_row_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] granted_col_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] granted_act_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] granted_pch_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] granted_rd_grant;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] granted_wr_grant;
    
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_granted_row_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_granted_col_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_granted_act_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_granted_pch_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_granted_rd_grant;
    reg  [log2(CFG_CTL_TBP_NUM) - 1 : 0] log2_granted_wr_grant;
    
    wire [CFG_CTL_TBP_NUM - 1 : 0] all_grant;
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Registers & Wires
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Outputs
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Granted logic specific grant signals
    //----------------------------------------------------------------------------------------------------
    always @ (*)
    begin
        granted_row_grant      = row_grant;
        granted_col_grant      = col_grant;
        
        granted_act_grant      = act_grant;
        granted_pch_grant      = pch_grant;
        granted_rd_grant       = rd_grant;
        granted_wr_grant       = wr_grant;
        
        log2_granted_row_grant = log2_row_grant;
        log2_granted_col_grant = log2_col_grant;
        
        log2_granted_act_grant = log2_act_grant;
        log2_granted_pch_grant = log2_pch_grant;
        log2_granted_rd_grant  = log2_rd_grant;
        log2_granted_wr_grant  = log2_wr_grant;
    end
    
    //----------------------------------------------------------------------------------------------------
    // Sideband outputs
    //----------------------------------------------------------------------------------------------------
    // Precharge all
    always @ (*)
    begin
        arb_do_precharge_all = {CFG_AFI_INTF_PHASE_NUM{sb_do_precharge_all}};
    end
    
    // Refresh
    always @ (*)
    begin
        arb_do_refresh = {CFG_AFI_INTF_PHASE_NUM{sb_do_refresh}};
    end
    
    // Self refresh
    always @ (*)
    begin
        arb_do_self_refresh = {CFG_AFI_INTF_PHASE_NUM{sb_do_self_refresh}};
    end
    
    // Power down
    always @ (*)
    begin
        arb_do_power_down = {CFG_AFI_INTF_PHASE_NUM{sb_do_power_down}};
    end
    
    // Power down
    always @ (*)
    begin
        arb_do_deep_pdown = {CFG_AFI_INTF_PHASE_NUM{sb_do_deep_pdown}};
    end
    
    // ZQ calibration
    always @ (*)
    begin
        arb_do_zq_cal = {CFG_AFI_INTF_PHASE_NUM{sb_do_zq_cal}};
    end
    
    // LMR
    always @ (*)
    begin
        arb_do_lmr = {CFG_AFI_INTF_PHASE_NUM{zero}};
    end
    
    //----------------------------------------------------------------------------------------------------
    // Non arbiter type aware outputs
    //----------------------------------------------------------------------------------------------------
    // Burst chop
    always @ (*)
    begin
        arb_do_burst_chop = {CFG_AFI_INTF_PHASE_NUM{granted_burst_chop [CFG_CTL_TBP_NUM - 1]}};
    end
    
    // Burst terminate
    always @ (*)
    begin
        arb_do_burst_terminate = 0;
    end
    
    // RMW Correct
    always @ (*)
    begin
        arb_do_rmw_correct = {CFG_AFI_INTF_PHASE_NUM{granted_rmw_correct [CFG_CTL_TBP_NUM - 1]}};
    end
    
    // RMW Partial
    always @ (*)
    begin
        arb_do_rmw_partial = {CFG_AFI_INTF_PHASE_NUM{granted_rmw_partial [CFG_CTL_TBP_NUM - 1]}};
    end
    
    // LMR
    always @ (*)
    begin
        arb_do_lmr = 0;
    end
    
    // Local ID
    always @ (*)
    begin
        arb_localid = granted_localid [CFG_CTL_TBP_NUM - 1];
    end
    
    // Data ID
    always @ (*)
    begin
        arb_dataid = granted_dataid [CFG_CTL_TBP_NUM - 1];
    end
    
    // Size
    always @ (*)
    begin
        arb_size = granted_size [CFG_CTL_TBP_NUM - 1];
    end
    
    // Column address
    // column command will only require column address, therefore there will be no conflcting column addresses
    always @ (*)
    begin
        arb_to_col = {CFG_AFI_INTF_PHASE_NUM{granted_col [CFG_CTL_TBP_NUM - 1]}};
    end
    
    //----------------------------------------------------------------------------------------------------
    // Arbiter type aware outputs
    //----------------------------------------------------------------------------------------------------
    generate
    begin
        if (CFG_CTL_ARBITER_TYPE == "COLROW")
        begin
            // Write
            always @ (*)
            begin
                arb_do_write = 0;
                
                arb_do_write [AFI_INTF_LOW_PHASE] = |(tbp_write & granted_col_grant);
            end
            
            // Read
            always @ (*)
            begin
                arb_do_read = 0;
                
                arb_do_read [AFI_INTF_LOW_PHASE] = |(tbp_read & granted_col_grant);
            end
            
            // Auto precharge
            always @ (*)
            begin
                arb_do_auto_precharge = 0;
                
                arb_do_auto_precharge [AFI_INTF_LOW_PHASE] = granted_ap [CFG_CTL_TBP_NUM - 1];
            end
            
            // Activate
            always @ (*)
            begin
                arb_do_activate = 0;
                
                arb_do_activate [AFI_INTF_HIGH_PHASE] = |(tbp_activate & granted_row_grant);
            end
            
            // Precharge
            always @ (*)
            begin
                arb_do_precharge = 0;
                
                arb_do_precharge [AFI_INTF_HIGH_PHASE] = |(tbp_precharge & granted_row_grant);
            end
            
            // Chip address
            // chipsel to to_chip address conversion
            always @ (*)
            begin
                granted_to_chip_r = 0;
                
                if (|granted_row_grant)
                    granted_to_chip_r [granted_chipsel_r [CFG_CTL_TBP_NUM - 1]] = 1'b1;
            end
            
            always @ (*)
            begin
                granted_to_chip_c = 0;
                
                if (|granted_col_grant)
                    granted_to_chip_c [granted_chipsel_c [CFG_CTL_TBP_NUM - 1]] = 1'b1;
            end
            
            always @ (*)
            begin
                arb_to_chipsel = {granted_chipsel_r [CFG_CTL_TBP_NUM - 1], granted_chipsel_c [CFG_CTL_TBP_NUM - 1]};
            end
            
            always @ (*)
            begin
                arb_to_chip = {granted_to_chip_r, granted_to_chip_c};
            end
            
            // Bank address
            always @ (*)
            begin
                arb_to_bank = {granted_bank_r [CFG_CTL_TBP_NUM - 1], granted_bank_c [CFG_CTL_TBP_NUM - 1]};
            end
            
            // Row address
            always @ (*)
            begin
                arb_to_row = {granted_row_r [CFG_CTL_TBP_NUM - 1], granted_row_c [CFG_CTL_TBP_NUM - 1]};
            end
        end
        else
        begin
            // Write
            always @ (*)
            begin
                arb_do_write = 0;
                
                arb_do_write [AFI_INTF_HIGH_PHASE] = |(tbp_write & granted_col_grant);
            end
            
            // Read
            always @ (*)
            begin
                arb_do_read = 0;
                
                arb_do_read [AFI_INTF_HIGH_PHASE] = |(tbp_read & granted_col_grant);
            end
            
            // Auto precharge
            always @ (*)
            begin
                arb_do_auto_precharge = 0;
                
                arb_do_auto_precharge [AFI_INTF_HIGH_PHASE] = granted_ap [CFG_CTL_TBP_NUM - 1];
            end
            
            // Activate
            always @ (*)
            begin
                arb_do_activate = 0;
                
                arb_do_activate [AFI_INTF_LOW_PHASE] = |(tbp_activate & granted_row_grant);
            end
            
            // Precharge
            always @ (*)
            begin
                arb_do_precharge = 0;
                
                arb_do_precharge [AFI_INTF_LOW_PHASE] = |(tbp_precharge & granted_row_grant);
            end
            
            // Chip address
            // chipsel to to_chip address conversion
            always @ (*)
            begin
                granted_to_chip_r = 0;
                
                if (|granted_row_grant)
                    granted_to_chip_r [granted_chipsel_r [CFG_CTL_TBP_NUM - 1]] = 1'b1;
            end
            
            always @ (*)
            begin
                granted_to_chip_c = 0;
                
                if (|granted_col_grant)
                    granted_to_chip_c [granted_chipsel_c [CFG_CTL_TBP_NUM - 1]] = 1'b1;
            end
            
            always @ (*)
            begin
                arb_to_chipsel = {granted_chipsel_c [CFG_CTL_TBP_NUM - 1], granted_chipsel_r [CFG_CTL_TBP_NUM - 1]};
            end
            
            always @ (*)
            begin
                arb_to_chip = {granted_to_chip_c, granted_to_chip_r};
            end
            
            // Bank address
            always @ (*)
            begin
                arb_to_bank = {granted_bank_c [CFG_CTL_TBP_NUM - 1], granted_bank_r [CFG_CTL_TBP_NUM - 1]};
            end
            
            // Row address
            always @ (*)
            begin
                arb_to_row = {granted_row_c [CFG_CTL_TBP_NUM - 1], granted_row_r [CFG_CTL_TBP_NUM - 1]};
            end
        end
    end
    endgenerate
    
    //----------------------------------------------------------------------------------------------------
    // Granted outputs
    //----------------------------------------------------------------------------------------------------
    // Chip address
    always @ (*)
    begin
        granted_chipsel_r   [0] = {CFG_MEM_IF_CS_WIDTH {granted_row_grant [0]}} & tbp_chipsel     [CFG_MEM_IF_CS_WIDTH  - 1 : 0];
        granted_chipsel_c   [0] = {CFG_MEM_IF_CS_WIDTH {granted_col_grant [0]}} & tbp_chipsel     [CFG_MEM_IF_CS_WIDTH  - 1 : 0];
    end
    
    // Bank address
    always @ (*)
    begin
        granted_bank_r      [0] = {CFG_MEM_IF_BA_WIDTH {granted_row_grant [0]}} & tbp_bank        [CFG_MEM_IF_BA_WIDTH  - 1 : 0];
        granted_bank_c      [0] = {CFG_MEM_IF_BA_WIDTH {granted_col_grant [0]}} & tbp_bank        [CFG_MEM_IF_BA_WIDTH  - 1 : 0];
    end
    
    // Row address
    always @ (*)
    begin
        granted_row_r       [0] = {CFG_MEM_IF_ROW_WIDTH{granted_row_grant [0]}} & tbp_row         [CFG_MEM_IF_ROW_WIDTH - 1 : 0];
        granted_row_c       [0] = {CFG_MEM_IF_ROW_WIDTH{granted_col_grant [0]}} & tbp_row         [CFG_MEM_IF_ROW_WIDTH - 1 : 0];
    end
    
    // Column address
    always @ (*)
    begin
        granted_col         [0] = {CFG_MEM_IF_COL_WIDTH{granted_col_grant [0]}} & tbp_col         [CFG_MEM_IF_COL_WIDTH - 1 : 0];
    end
    
    // Size
    always @ (*)
    begin
        granted_size        [0] = {CFG_INT_SIZE_WIDTH  {granted_col_grant [0]}} & tbp_size        [CFG_INT_SIZE_WIDTH   - 1 : 0];
    end
    
    // Local ID
    always @ (*)
    begin
        granted_localid     [0] = {CFG_LOCAL_ID_WIDTH  {granted_col_grant [0]}} & tbp_localid     [CFG_LOCAL_ID_WIDTH   - 1 : 0];
    end
    
    // Data ID
    always @ (*)
    begin
        granted_dataid      [0] = {CFG_DATA_ID_WIDTH   {granted_col_grant [0]}} & tbp_dataid      [CFG_DATA_ID_WIDTH    - 1 : 0];
    end
    
    // Auto precharge
    always @ (*)
    begin
        granted_ap          [0] =                       granted_col_grant [0]   & tbp_ap          [                           0];
    end
    
    // Burst Chop
    always @ (*)
    begin
        granted_burst_chop  [0] =                       granted_col_grant [0]   & tbp_burst_chop  [                           0];
    end
    
    // RMW Correct
    always @ (*)
    begin
        granted_rmw_correct [0] =                       granted_col_grant [0]   & tbp_rmw_correct [                           0];
    end
    
    // RMW Partial
    always @ (*)
    begin
        granted_rmw_partial [0] =                       granted_col_grant [0]   & tbp_rmw_partial [                           0];
    end
    
    generate
    begin
        genvar j_tbp;
        for (j_tbp = 1;j_tbp < CFG_CTL_TBP_NUM;j_tbp = j_tbp + 1)
        begin : granted_information_per_tbp
            wire [CFG_MEM_IF_CS_WIDTH  - 1 : 0] chipsel_addr = tbp_chipsel     [(j_tbp + 1) * CFG_MEM_IF_CS_WIDTH  - 1 : j_tbp * CFG_MEM_IF_CS_WIDTH ];
            wire [CFG_MEM_IF_BA_WIDTH  - 1 : 0] bank_addr    = tbp_bank        [(j_tbp + 1) * CFG_MEM_IF_BA_WIDTH  - 1 : j_tbp * CFG_MEM_IF_BA_WIDTH ];
            wire [CFG_MEM_IF_ROW_WIDTH - 1 : 0] row_addr     = tbp_row         [(j_tbp + 1) * CFG_MEM_IF_ROW_WIDTH - 1 : j_tbp * CFG_MEM_IF_ROW_WIDTH];
            wire [CFG_MEM_IF_COL_WIDTH - 1 : 0] col_addr     = tbp_col         [(j_tbp + 1) * CFG_MEM_IF_COL_WIDTH - 1 : j_tbp * CFG_MEM_IF_COL_WIDTH];
            wire [CFG_INT_SIZE_WIDTH   - 1 : 0] size         = tbp_size        [(j_tbp + 1) * CFG_INT_SIZE_WIDTH   - 1 : j_tbp * CFG_INT_SIZE_WIDTH  ];
            wire [CFG_LOCAL_ID_WIDTH   - 1 : 0] localid      = tbp_localid     [(j_tbp + 1) * CFG_LOCAL_ID_WIDTH   - 1 : j_tbp * CFG_LOCAL_ID_WIDTH  ];
            wire [CFG_DATA_ID_WIDTH    - 1 : 0] dataid       = tbp_dataid      [(j_tbp + 1) * CFG_DATA_ID_WIDTH    - 1 : j_tbp * CFG_DATA_ID_WIDTH   ];
            wire                                ap           = tbp_ap          [(j_tbp + 1)                        - 1 : j_tbp                       ];
            wire                                burst_chop   = tbp_burst_chop  [(j_tbp + 1)                        - 1 : j_tbp                       ];
            wire                                rmw_correct  = tbp_rmw_correct [(j_tbp + 1)                        - 1 : j_tbp                       ];
            wire                                rmw_partial  = tbp_rmw_partial [(j_tbp + 1)                        - 1 : j_tbp                       ];
            
            // Chip address
            always @ (*)
            begin
                granted_chipsel_r   [j_tbp] = ({CFG_MEM_IF_CS_WIDTH {granted_row_grant [j_tbp]}} & chipsel_addr) | granted_chipsel_r   [j_tbp - 1];
                granted_chipsel_c   [j_tbp] = ({CFG_MEM_IF_CS_WIDTH {granted_col_grant [j_tbp]}} & chipsel_addr) | granted_chipsel_c   [j_tbp - 1];
            end
            
            // Bank address
            always @ (*)
            begin
                granted_bank_r      [j_tbp] = ({CFG_MEM_IF_BA_WIDTH {granted_row_grant [j_tbp]}} & bank_addr   ) | granted_bank_r      [j_tbp - 1];
                granted_bank_c      [j_tbp] = ({CFG_MEM_IF_BA_WIDTH {granted_col_grant [j_tbp]}} & bank_addr   ) | granted_bank_c      [j_tbp - 1];
            end
            
            // Row address
            always @ (*)
            begin
                granted_row_r       [j_tbp] = ({CFG_MEM_IF_ROW_WIDTH{granted_row_grant [j_tbp]}} & row_addr    ) | granted_row_r       [j_tbp - 1];
                granted_row_c       [j_tbp] = ({CFG_MEM_IF_ROW_WIDTH{granted_col_grant [j_tbp]}} & row_addr    ) | granted_row_c       [j_tbp - 1];
            end
            
            // Column address
            always @ (*)
            begin
                granted_col         [j_tbp] = ({CFG_MEM_IF_COL_WIDTH{granted_col_grant [j_tbp]}} & col_addr    ) | granted_col         [j_tbp - 1];
            end
            
            // Size
            always @ (*)
            begin
                granted_size        [j_tbp] = ({CFG_INT_SIZE_WIDTH  {granted_col_grant [j_tbp]}} & size        ) | granted_size        [j_tbp - 1];
            end
            
            // Local ID
            always @ (*)
            begin
                granted_localid     [j_tbp] = ({CFG_LOCAL_ID_WIDTH  {granted_col_grant [j_tbp]}} & localid     ) | granted_localid     [j_tbp - 1];
            end
            
            // Data ID
            always @ (*)
            begin
                granted_dataid      [j_tbp] = ({CFG_DATA_ID_WIDTH   {granted_col_grant [j_tbp]}} & dataid      ) | granted_dataid      [j_tbp - 1];
            end
            
            // Auto precharge
            always @ (*)
            begin
                granted_ap          [j_tbp] = (                      granted_col_grant [j_tbp]   & ap          ) | granted_ap          [j_tbp - 1];
            end
            
            // Auto precharge
            always @ (*)
            begin
                granted_burst_chop  [j_tbp] = (                      granted_col_grant [j_tbp]   & burst_chop  ) | granted_burst_chop  [j_tbp - 1];
            end
            
            // RMW Correct
            always @ (*)
            begin
                granted_rmw_correct [j_tbp] = (                      granted_col_grant [j_tbp]   & rmw_correct ) | granted_rmw_correct [j_tbp - 1];
            end
            
            // RMW Partial
            always @ (*)
            begin
                granted_rmw_partial [j_tbp] = (                      granted_col_grant [j_tbp]   & rmw_partial ) | granted_rmw_partial [j_tbp - 1];
            end
        end
    end
    endgenerate
//--------------------------------------------------------------------------------------------------------
//
//  [END] Outputs
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Arbiter
//  
//  Arbitration Rules (Priority Command-Aging Arbiter):
//  
//  - If only one master is requesting, grant that master immediately ELSE
//  - If two of more masters are requesting:
//      - Grant the request with priority ELSE
//      - Grant read request over write request ELSE
//      - Grant oldest request
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Common logic
    //----------------------------------------------------------------------------------------------------
    // Indicate OR of both grant signal
    assign all_grant = row_grant | col_grant;
    
    //----------------------------------------------------------------------------------------------------
    // Priority Command-aging logic
    //----------------------------------------------------------------------------------------------------
    // ==========Command-Aging==========
    // 
    // The following logic will check for the oldest requesting commands by cross checking between age dependencies & request
    // eg:  Let say we have 4 TBPs and TBP is loaded in the following fashion: TBP0, TBP1, TBP2, TBP3
    //      Age dependecies will have the following value:
    //          TBP0 age - 0000
    //          TBP1 age - 0001
    //          TBP2 age - 0011
    //          TBP3 age - 0111
    //      Let say TBP1 and TBP2 are requesting at the same time, we would want the command-aging logic to pick TBP1 instead of TBP2
    //      TBP2 have age dependencies on TBP1, this will cause oldest_req[2] signal to be set to '0'
    //      TBP1 have no age dependencies on TBP2, this will cause oldest_req[1] signal to be set to '1'
    //      So the oldest_req signal will have "0010"
    // 
    // ==========Priority==========
    // 
    // The following logic will have similar logic as command-aging logic, this logic will pick commands with priority bit set
    // if there are more than 1 priority command, it will pick the oldest priority command
    // eg:  Let say we have 4 TBPs and TBP is loaded in the following fashion: TBP0, TBP1, TBP2, TBP3
    //      Age dependecies and priority bit will have the following value:
    //          TBP0 age - 0000 priority - 0
    //          TBP1 age - 0001 priority - 1
    //          TBP2 age - 0011 priority - 1
    //          TBP3 age - 0111 priority - 0
    //      Let say all TBPs are requesting at the same time, priority_req [1] will be set to '1' because it is the oldest priority command
    //      and the rest will be set to '0'
    
    // If there is/are priority command/s, we need to select between those priority command
    // if there is no priority command, we set int_priority to all '1'
    // this will cause arbiter to select between all commands which will provide with similar result as non-priority command-aging arbiter
    
    always @ (*)
    begin
        int_act_priority = {CFG_CTL_TBP_NUM{one}};
        
        int_pch_priority = {CFG_CTL_TBP_NUM{one}};
        
        if (CFG_DISABLE_PRIORITY == 1)
        begin
            int_col_priority = {CFG_CTL_TBP_NUM{one}};
        end
        else
        begin
            if ((tbp_priority & col_req) == 0)
            begin
                int_col_priority = {CFG_CTL_TBP_NUM{one}};
            end
            else
            begin
                int_col_priority = tbp_priority;
            end
        end
    end
    
    generate
    begin
        genvar k_tbp;
        for (k_tbp = 0;k_tbp < CFG_CTL_TBP_NUM;k_tbp = k_tbp + 1)
        begin : priority_request_per_tbp
            wire [CFG_CTL_TBP_NUM - 1 : 0] current_age = tbp_age [(k_tbp + 1) * CFG_CTL_TBP_NUM - 1 : k_tbp * CFG_CTL_TBP_NUM];
            
            reg                            pre_calculated_act_info;
            reg                            pre_calculated_pch_info;
            reg                            pre_calculated_rd_info;
            reg                            pre_calculated_wr_info;
            
            reg  [CFG_CTL_TBP_NUM - 1 : 0] pre_calculated_act_age_info;
            reg  [CFG_CTL_TBP_NUM - 1 : 0] pre_calculated_pch_age_info;
            reg  [CFG_CTL_TBP_NUM - 1 : 0] pre_calculated_rd_age_info;
            reg  [CFG_CTL_TBP_NUM - 1 : 0] pre_calculated_wr_age_info;
            
            if (CFG_REG_REQ)
            begin
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        pre_calculated_act_info <= 1'b0;
                        pre_calculated_pch_info <= 1'b0;
                        pre_calculated_rd_info  <= 1'b0;
                        pre_calculated_wr_info  <= 1'b0;
                    end
                    else
                    begin
                        pre_calculated_act_info <= int_act_priority [k_tbp];
                        pre_calculated_pch_info <= int_pch_priority [k_tbp];
                        pre_calculated_rd_info  <= int_col_priority [k_tbp];
                        pre_calculated_wr_info  <= int_col_priority [k_tbp];
                    end
                end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        pre_calculated_act_age_info <= 0;
                        pre_calculated_pch_age_info <= 0;
                        pre_calculated_rd_age_info  <= 0;
                        pre_calculated_wr_age_info  <= 0;
                    end
                    else
                    begin
                        pre_calculated_act_age_info <= current_age & int_act_priority;
                        pre_calculated_pch_age_info <= current_age & int_pch_priority;
                        pre_calculated_rd_age_info  <= current_age & int_col_priority;
                        pre_calculated_wr_age_info  <= current_age & int_col_priority;
                    end
                end
            end
            else
            begin
                always @ (*)
                begin
                    pre_calculated_act_info = int_act_priority [k_tbp];
                    pre_calculated_pch_info = int_pch_priority [k_tbp];
                    pre_calculated_rd_info  = int_col_priority [k_tbp];
                    pre_calculated_wr_info  = int_col_priority [k_tbp];
                end
                
                always @ (*)
                begin
                    pre_calculated_act_age_info = current_age & int_act_priority;
                    pre_calculated_pch_age_info = current_age & int_pch_priority;
                    pre_calculated_rd_age_info  = current_age & int_col_priority;
                    pre_calculated_wr_age_info  = current_age & int_col_priority;
                end
            end
            
            always @ (*)
            begin
                oldest_act_req_with_priority [k_tbp] = pre_calculated_act_info & act_req [k_tbp] & can_activate  [k_tbp] & ~|(pre_calculated_act_age_info & act_req & can_activate );
                oldest_pch_req_with_priority [k_tbp] = pre_calculated_pch_info & pch_req [k_tbp] & can_precharge [k_tbp] & ~|(pre_calculated_pch_age_info & pch_req & can_precharge);
                oldest_rd_req_with_priority  [k_tbp] = pre_calculated_rd_info  & rd_req  [k_tbp] & can_read      [k_tbp] & ~|(pre_calculated_rd_age_info  & rd_req  & can_read     );
                oldest_wr_req_with_priority  [k_tbp] = pre_calculated_wr_info  & wr_req  [k_tbp] & can_write     [k_tbp] & ~|(pre_calculated_wr_age_info  & wr_req  & can_write    );
            end
            
            always @ (*)
            begin
                act_req_with_priority [k_tbp] = pre_calculated_act_info & act_req [k_tbp] & can_activate  [k_tbp];
                pch_req_with_priority [k_tbp] = pre_calculated_pch_info & pch_req [k_tbp] & can_precharge [k_tbp];
                rd_req_with_priority  [k_tbp] = pre_calculated_rd_info  & rd_req  [k_tbp] & can_read      [k_tbp];
                wr_req_with_priority  [k_tbp] = pre_calculated_wr_info  & wr_req  [k_tbp] & can_write     [k_tbp];
            end
        end
    end
    endgenerate
    
    
    
    //----------------------------------------------------------------------------------------------------
    // Arbiter logic
    //----------------------------------------------------------------------------------------------------
    generate
    begin
        if (CFG_DWIDTH_RATIO == 2)
        begin
            // Full rate arbiter
            always @ (*)
            begin
                int_row_grant    = 0;
                int_col_grant    = 0;
                int_act_grant    = 0;
                int_pch_grant    = 0;
                int_rd_grant     = 0;
                int_wr_grant     = 0;
                
                int_or_row_grant = 1'b0;
                int_or_col_grant = 1'b0;
                
                if (!stall_col_arbiter && !or_col_grant && |rd_req_with_priority)
                begin
                    int_col_grant    = oldest_rd_req_with_priority;
                    int_rd_grant     = oldest_rd_req_with_priority;
                    int_or_col_grant = 1'b1;
                end
                else if (!stall_col_arbiter && !or_col_grant && |wr_req_with_priority)
                begin
                    int_col_grant    = oldest_wr_req_with_priority;
                    int_wr_grant     = oldest_wr_req_with_priority;
                    int_or_col_grant = 1'b1;
                end
                else if (!stall_row_arbiter && !or_row_grant && |pch_req_with_priority)
                begin
                    int_row_grant    = oldest_pch_req_with_priority;
                    int_pch_grant    = oldest_pch_req_with_priority;
                    int_or_row_grant = 1'b1;
                end
                else if (!stall_row_arbiter && !or_row_grant && |act_req_with_priority)
                begin
                    int_row_grant    = oldest_act_req_with_priority;
                    int_act_grant    = oldest_act_req_with_priority;
                    int_or_row_grant = 1'b1;
                end
            end
        end
        else
        begin
            // Half and quarter rate arbiter
            
            // Row arbiter
            always @ (*)
            begin
                int_row_grant    = 0;
                int_act_grant    = 0;
                int_pch_grant    = 0;
                
                int_or_row_grant = 1'b0;
                
                if (!stall_row_arbiter && !or_row_grant && |pch_req_with_priority)
                begin
                    int_row_grant    = oldest_pch_req_with_priority;
                    int_pch_grant    = oldest_pch_req_with_priority;
                    int_or_row_grant = 1'b1;
                end
                else if (!stall_row_arbiter && !or_row_grant && |act_req_with_priority)
                begin
                    int_row_grant    = oldest_act_req_with_priority;
                    int_act_grant    = oldest_act_req_with_priority;
                    int_or_row_grant = 1'b1;
                end
            end
            
            // Column arbiter
            always @ (*)
            begin
                int_col_grant    = 0;
                int_rd_grant     = 0;
                int_wr_grant     = 0;
                
                int_or_col_grant = 1'b0;
                
                if (!stall_col_arbiter && !or_col_grant && |rd_req_with_priority)
                begin
                    int_col_grant    = oldest_rd_req_with_priority;
                    int_rd_grant     = oldest_rd_req_with_priority;
                    int_or_col_grant = 1'b1;
                end
                else if (!stall_col_arbiter && !or_col_grant && |wr_req_with_priority)
                begin
                    int_col_grant    = oldest_wr_req_with_priority;
                    int_wr_grant     = oldest_wr_req_with_priority;
                    int_or_col_grant = 1'b1;
                end
            end
        end
    end
    endgenerate
    
    generate
    begin
        if (CFG_REG_GRANT == 1)
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    row_grant      <= 0;
                    col_grant      <= 0;
                    
                    act_grant      <= 0;
                    pch_grant      <= 0;
                    rd_grant       <= 0;
                    wr_grant       <= 0;
                    
                    or_row_grant   <= 0;
                    or_col_grant   <= 0;
                end
                else
                begin
                    row_grant      <= int_row_grant;
                    col_grant      <= int_col_grant;
                    
                    act_grant      <= int_act_grant;
                    pch_grant      <= int_pch_grant;
                    rd_grant       <= int_rd_grant;
                    wr_grant       <= int_wr_grant;
                    
                    or_row_grant   <= int_or_row_grant;
                    or_col_grant   <= int_or_col_grant;
                end
            end
            
            always @ (*)
            begin
                log2_row_grant = log2(row_grant);
                log2_col_grant = log2(col_grant);
                
                log2_act_grant = log2(act_grant);
                log2_pch_grant = log2(pch_grant);
                log2_rd_grant  = log2(rd_grant );
                log2_wr_grant  = log2(wr_grant );
            end
        end
        else
        begin
            always @ (*)
            begin
                row_grant      = int_row_grant;
                col_grant      = int_col_grant;
                
                act_grant      = int_act_grant;
                pch_grant      = int_pch_grant;
                rd_grant       = int_rd_grant;
                wr_grant       = int_wr_grant;
                
                log2_row_grant = log2(int_row_grant);
                log2_col_grant = log2(int_col_grant);
                
                log2_act_grant = log2(int_act_grant);
                log2_pch_grant = log2(int_pch_grant);
                log2_rd_grant  = log2(int_rd_grant );
                log2_wr_grant  = log2(int_wr_grant );
                
                or_row_grant   = 1'b0; // Hardwire this to 0 in non register-grant mode
                or_col_grant   = 1'b0; // Hardwire this to 0 in non register-grant mode
            end
        end
    end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Arbiter
//
//--------------------------------------------------------------------------------------------------------

function integer log2;
    input [31 : 0] value;
    integer        i;
    begin
        log2 = 0;
        for(i = 0;2 ** i < value;i = i + 1)
        begin
            log2 = i + 1;
        end
    end
endfunction

endmodule
