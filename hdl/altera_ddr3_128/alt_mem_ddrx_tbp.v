
// altera message_off 10230 10036

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_tbp
    #( parameter
        CFG_CTL_TBP_NUM                 =   4,
        CFG_CTL_SHADOW_TBP_NUM          =   4,
        CFG_ENABLE_SHADOW_TBP           =   0,
        CFG_DWIDTH_RATIO                =   2,
        CFG_CTL_ARBITER_TYPE            =   "ROWCOL",
        CFG_MEM_IF_CHIP                 =   1, // one hot
        CFG_MEM_IF_CS_WIDTH             =   1, // binary encoded
        CFG_MEM_IF_BA_WIDTH             =   3,
        CFG_MEM_IF_ROW_WIDTH            =   13,
        CFG_MEM_IF_COL_WIDTH            =   10,
        CFG_LOCAL_ID_WIDTH              =   8,
        CFG_INT_SIZE_WIDTH              =   4,
        CFG_DATA_ID_WIDTH               =   10,
        CFG_REG_REQ                     =   0,
        CFG_REG_GRANT                   =   0,
        CFG_DATA_REORDERING_TYPE        =   "INTER_BANK",
        CFG_DISABLE_READ_REODERING      =   0,
        CFG_DISABLE_PRIORITY            =   0,
        CFG_PORT_WIDTH_REORDER_DATA     =   1,
        CFG_PORT_WIDTH_STARVE_LIMIT     =   6,
        CFG_PORT_WIDTH_TYPE             =   3,
        T_PARAM_ACT_TO_RDWR_WIDTH       =   4,
        T_PARAM_ACT_TO_ACT_WIDTH        =   4,
        T_PARAM_ACT_TO_PCH_WIDTH        =   4,
        T_PARAM_RD_TO_PCH_WIDTH         =   4,
        T_PARAM_WR_TO_PCH_WIDTH         =   4,
        T_PARAM_PCH_TO_VALID_WIDTH      =   4,
        T_PARAM_RD_AP_TO_VALID_WIDTH    =   4,
        T_PARAM_WR_AP_TO_VALID_WIDTH    =   4
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // Cmd gen interface
        tbp_full,
        tbp_empty,
        cmd_gen_load,
        cmd_gen_chipsel,
        cmd_gen_bank,
        cmd_gen_row,
        cmd_gen_col,
        cmd_gen_write,
        cmd_gen_read,
        cmd_gen_size,
        cmd_gen_localid,
        cmd_gen_dataid,
        cmd_gen_priority,
        cmd_gen_rmw_correct,
        cmd_gen_rmw_partial,
        cmd_gen_autopch,
        cmd_gen_complete,
        cmd_gen_same_chipsel_addr,
        cmd_gen_same_bank_addr,
        cmd_gen_same_row_addr,
        cmd_gen_same_col_addr,
        cmd_gen_same_read_cmd,
        cmd_gen_same_write_cmd,
        cmd_gen_same_shadow_chipsel_addr,
        cmd_gen_same_shadow_bank_addr,
        cmd_gen_same_shadow_row_addr,
        
        // Arbiter interface
        row_req,
        act_req,
        pch_req,
        row_grant,
        act_grant,
        pch_grant,
        col_req,
        rd_req,
        wr_req,
        col_grant,
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
        tbp_read,
        tbp_write,
        tbp_precharge,
        tbp_activate,
        tbp_chipsel,
        tbp_bank,
        tbp_row,
        tbp_col,
        tbp_shadow_chipsel,
        tbp_shadow_bank,
        tbp_shadow_row,
        tbp_size,
        tbp_localid,
        tbp_dataid,
        tbp_ap,
        tbp_burst_chop,
        tbp_age,
        tbp_priority,
        tbp_rmw_correct,
        tbp_rmw_partial,
        sb_tbp_precharge_all,
        sb_do_precharge_all,
        
        // Timer value
        t_param_act_to_rdwr,
        t_param_act_to_act,
        t_param_act_to_pch,
        t_param_rd_to_pch,
        t_param_wr_to_pch,
        t_param_pch_to_valid,
        t_param_rd_ap_to_valid,
        t_param_wr_ap_to_valid,
        
        // Misc interface
        tbp_bank_active,
        tbp_timer_ready,
        tbp_load,
        data_complete,
        
        // Config interface
        cfg_reorder_data,
        cfg_starve_limit,
        cfg_type
    );
    
    localparam integer CFG_MEM_IF_BA_WIDTH_SQRD     = 2**CFG_MEM_IF_BA_WIDTH;
    localparam         TBP_COUNTER_OFFSET           = (CFG_REG_GRANT) ? 2 : 1;
    localparam          RDWR_AP_TO_VALID_WIDTH      = (T_PARAM_RD_AP_TO_VALID_WIDTH > T_PARAM_WR_AP_TO_VALID_WIDTH) ? T_PARAM_RD_AP_TO_VALID_WIDTH : T_PARAM_WR_AP_TO_VALID_WIDTH;
    localparam          COL_TIMER_WIDTH             = T_PARAM_ACT_TO_RDWR_WIDTH;
    localparam          ROW_TIMER_WIDTH             = (T_PARAM_ACT_TO_ACT_WIDTH > RDWR_AP_TO_VALID_WIDTH) ? T_PARAM_ACT_TO_ACT_WIDTH : RDWR_AP_TO_VALID_WIDTH;
    localparam          TRC_TIMER_WIDTH             = T_PARAM_ACT_TO_ACT_WIDTH;
    
    // Start of port declaration
    input   ctl_clk;
    input   ctl_reset_n;
    
    output                               tbp_full;
    output                               tbp_empty;
    input                                cmd_gen_load;
    input   [CFG_MEM_IF_CS_WIDTH-1:0]    cmd_gen_chipsel;
    input   [CFG_MEM_IF_BA_WIDTH-1:0]    cmd_gen_bank;
    input   [CFG_MEM_IF_ROW_WIDTH-1:0]   cmd_gen_row;
    input   [CFG_MEM_IF_COL_WIDTH-1:0]   cmd_gen_col;
    input                                cmd_gen_write;
    input                                cmd_gen_read;
    input   [CFG_INT_SIZE_WIDTH-1:0]     cmd_gen_size;
    input   [CFG_LOCAL_ID_WIDTH-1:0]     cmd_gen_localid;
    input   [CFG_DATA_ID_WIDTH-1:0]      cmd_gen_dataid;
    input                                cmd_gen_priority;
    input                                cmd_gen_rmw_correct;
    input                                cmd_gen_rmw_partial;
    input                                cmd_gen_autopch;
    input                                cmd_gen_complete;
    input   [CFG_CTL_TBP_NUM-1:0]        cmd_gen_same_chipsel_addr;
    input   [CFG_CTL_TBP_NUM-1:0]        cmd_gen_same_bank_addr;
    input   [CFG_CTL_TBP_NUM-1:0]        cmd_gen_same_row_addr;
    input   [CFG_CTL_TBP_NUM-1:0]        cmd_gen_same_col_addr;
    input   [CFG_CTL_TBP_NUM-1:0]        cmd_gen_same_read_cmd;
    input   [CFG_CTL_TBP_NUM-1:0]        cmd_gen_same_write_cmd;
    input   [CFG_CTL_SHADOW_TBP_NUM-1:0] cmd_gen_same_shadow_chipsel_addr;
    input   [CFG_CTL_SHADOW_TBP_NUM-1:0] cmd_gen_same_shadow_bank_addr;
    input   [CFG_CTL_SHADOW_TBP_NUM-1:0] cmd_gen_same_shadow_row_addr;
    
    output  [CFG_CTL_TBP_NUM-1:0]                               row_req;
    output  [CFG_CTL_TBP_NUM-1:0]                               act_req;
    output  [CFG_CTL_TBP_NUM-1:0]                               pch_req;
    input   [CFG_CTL_TBP_NUM-1:0]                               row_grant;
    input   [CFG_CTL_TBP_NUM-1:0]                               act_grant;
    input   [CFG_CTL_TBP_NUM-1:0]                               pch_grant;
    output  [CFG_CTL_TBP_NUM-1:0]                               col_req;
    output  [CFG_CTL_TBP_NUM-1:0]                               rd_req;
    output  [CFG_CTL_TBP_NUM-1:0]                               wr_req;
    input   [CFG_CTL_TBP_NUM-1:0]                               col_grant;
    input   [CFG_CTL_TBP_NUM-1:0]                               rd_grant;
    input   [CFG_CTL_TBP_NUM-1:0]                               wr_grant;
    input   [log2(CFG_CTL_TBP_NUM)-1:0]                         log2_row_grant;
    input   [log2(CFG_CTL_TBP_NUM)-1:0]                         log2_col_grant;
    input   [log2(CFG_CTL_TBP_NUM)-1:0]                         log2_act_grant;
    input   [log2(CFG_CTL_TBP_NUM)-1:0]                         log2_pch_grant;
    input   [log2(CFG_CTL_TBP_NUM)-1:0]                         log2_rd_grant;
    input   [log2(CFG_CTL_TBP_NUM)-1:0]                         log2_wr_grant;
    input                                                       or_row_grant;
    input                                                       or_col_grant;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_read;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_write;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_precharge;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_activate;
    output  [(CFG_CTL_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0]         tbp_chipsel;
    output  [(CFG_CTL_TBP_NUM*CFG_MEM_IF_BA_WIDTH)-1:0]         tbp_bank;
    output  [(CFG_CTL_TBP_NUM*CFG_MEM_IF_ROW_WIDTH)-1:0]        tbp_row;
    output  [(CFG_CTL_TBP_NUM*CFG_MEM_IF_COL_WIDTH)-1:0]        tbp_col;
    output  [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0]  tbp_shadow_chipsel;
    output  [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_BA_WIDTH)-1:0]  tbp_shadow_bank;
    output  [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_ROW_WIDTH)-1:0] tbp_shadow_row;
    output  [(CFG_CTL_TBP_NUM*CFG_INT_SIZE_WIDTH)-1:0]          tbp_size;
    output  [(CFG_CTL_TBP_NUM*CFG_LOCAL_ID_WIDTH)-1:0]          tbp_localid;
    output  [(CFG_CTL_TBP_NUM*CFG_DATA_ID_WIDTH)-1:0]           tbp_dataid;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_ap;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_burst_chop;
    output  [(CFG_CTL_TBP_NUM*CFG_CTL_TBP_NUM)-1:0]             tbp_age;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_priority;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_rmw_correct;
    output  [CFG_CTL_TBP_NUM-1:0]                               tbp_rmw_partial;
    input   [CFG_CTL_TBP_NUM-1:0]                               sb_tbp_precharge_all;
    input   [CFG_MEM_IF_CHIP-1:0]                               sb_do_precharge_all;
    
    input   [T_PARAM_ACT_TO_RDWR_WIDTH-1:0]    t_param_act_to_rdwr;
    input   [T_PARAM_ACT_TO_ACT_WIDTH-1:0]     t_param_act_to_act;
    input   [T_PARAM_ACT_TO_PCH_WIDTH-1:0]     t_param_act_to_pch;
    input   [T_PARAM_RD_TO_PCH_WIDTH-1:0]      t_param_rd_to_pch;
    input   [T_PARAM_WR_TO_PCH_WIDTH-1:0]      t_param_wr_to_pch;
    input   [T_PARAM_PCH_TO_VALID_WIDTH-1:0]   t_param_pch_to_valid;
    input   [T_PARAM_RD_AP_TO_VALID_WIDTH-1:0] t_param_rd_ap_to_valid;
    input   [T_PARAM_WR_AP_TO_VALID_WIDTH-1:0] t_param_wr_ap_to_valid;
    
    output  [CFG_MEM_IF_CHIP-1:0]              tbp_bank_active;
    output  [CFG_MEM_IF_CHIP-1:0]              tbp_timer_ready;
    output  [CFG_CTL_TBP_NUM-1:0]              tbp_load;
    input   [CFG_CTL_TBP_NUM-1:0]              data_complete;
    
    input   [CFG_PORT_WIDTH_REORDER_DATA-1:0] cfg_reorder_data;
    input   [CFG_PORT_WIDTH_STARVE_LIMIT-1:0] cfg_starve_limit;
    input   [CFG_PORT_WIDTH_TYPE-1:0]         cfg_type;
    // End of port declaration
    
    // Logic operators
    wire                          tbp_full;
    wire                          tbp_empty;
    wire    [CFG_CTL_TBP_NUM-1:0] tbp_load;
    wire    [CFG_CTL_TBP_NUM-1:0] load_tbp;
    reg     [CFG_CTL_TBP_NUM-1:0] load_tbp_index;
    wire    [CFG_CTL_TBP_NUM-1:0] flush_tbp;
    reg     [CFG_CTL_TBP_NUM-1:0] precharge_tbp;
    reg     [CFG_CTL_TBP_NUM-1:0] row_req;
    reg     [CFG_CTL_TBP_NUM-1:0] act_req;
    reg     [CFG_CTL_TBP_NUM-1:0] pch_req;
    reg     [CFG_CTL_TBP_NUM-1:0] col_req;
    reg     [CFG_CTL_TBP_NUM-1:0] rd_req;
    reg     [CFG_CTL_TBP_NUM-1:0] wr_req;
    
    reg                           int_tbp_full;
    wire                          int_tbp_empty;
    
    reg     [CFG_CTL_TBP_NUM-1:0]             valid;
    wire    [CFG_CTL_TBP_NUM-1:0]             valid_combi;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]         chipsel      [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]         bank         [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]        row          [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]        col          [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]             write;
    reg     [CFG_CTL_TBP_NUM-1:0]             read;
    wire    [CFG_CTL_TBP_NUM-1:0]             precharge;
    wire    [CFG_CTL_TBP_NUM-1:0]             activate;
    reg     [CFG_INT_SIZE_WIDTH-1:0]          size    [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]             autopch;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]          localid      [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_DATA_ID_WIDTH-1:0]           dataid       [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]             priority_a;
    reg     [CFG_CTL_TBP_NUM-1:0]             activated;
    reg     [CFG_CTL_TBP_NUM-1:0]             activated_p;
    reg     [CFG_CTL_TBP_NUM-1:0]             activated_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]             precharged;
    reg     [CFG_CTL_TBP_NUM-1:0]             precharged_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]             not_done_tbp_row_pass_flush;
    reg     [CFG_CTL_TBP_NUM-1:0]             not_done_tbp_row_pass_flush_r;
    reg     [CFG_CTL_TBP_NUM-1:0]             done_tbp_row_pass_flush;
    reg     [CFG_CTL_TBP_NUM-1:0]             done_tbp_row_pass_flush_r;
    reg     [CFG_CTL_TBP_NUM-1:0]             open_row_pass;
    reg     [CFG_CTL_TBP_NUM-1:0]             open_row_pass_r;
    wire    [CFG_CTL_TBP_NUM-1:0]             open_row_pass_flush;
    reg     [CFG_CTL_TBP_NUM-1:0]             open_row_pass_flush_r;
    reg     [CFG_CTL_TBP_NUM-1:0]             log2_open_row_pass_flush   [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]             log2_open_row_pass_flush_r [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]             done;
    reg     [CFG_CTL_TBP_NUM-1:0]             done_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]             complete;
    reg     [CFG_CTL_TBP_NUM-1:0]             complete_rd;
    reg     [CFG_CTL_TBP_NUM-1:0]             complete_wr;
    reg     [CFG_CTL_TBP_NUM-1:0]             complete_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]             complete_combi_rd;
    reg     [CFG_CTL_TBP_NUM-1:0]             complete_combi_wr;
    reg     [CFG_CTL_TBP_NUM-1:0]             wst;
    reg     [CFG_CTL_TBP_NUM-1:0]             wst_p;
    reg     [CFG_CTL_TBP_NUM-1:0]             ssb;
    reg     [CFG_CTL_TBP_NUM-1:0]             ssbr;
    reg     [CFG_CTL_TBP_NUM-1:0]             ap;
    reg     [CFG_CTL_TBP_NUM-1:0]             real_ap;
    reg     [CFG_CTL_TBP_NUM-1:0]             rmw_correct;
    reg     [CFG_CTL_TBP_NUM-1:0]             rmw_partial;
    reg     [CFG_CTL_TBP_NUM-1:0]             require_flush;
    reg     [CFG_CTL_TBP_NUM-1:0]             require_flush_calc;
    reg     [CFG_CTL_TBP_NUM-1:0]             require_pch_combi [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]             require_pch;
    reg     [CFG_CTL_TBP_NUM-1:0]             burst_chop;
    reg     [CFG_CTL_TBP_NUM-1:0]             age         [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_PORT_WIDTH_STARVE_LIMIT-1:0] starvation  [CFG_CTL_TBP_NUM-1:0];
    
    // bit vectors
    reg     [CFG_CTL_TBP_NUM-1:0] apvo_combi;   // vector for smart autopch open page
    reg     [CFG_CTL_TBP_NUM-1:0] apvo;         // vector for smart autopch open page
    reg     [CFG_CTL_TBP_NUM-1:0] apvc_combi;   // vector for smart autopch close page
    reg     [CFG_CTL_TBP_NUM-1:0] apvc;         // vector for smart autopch close page
    reg     [CFG_CTL_TBP_NUM-1:0] rpv_combi         [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] rpv               [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] cpv_combi         [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] cpv               [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] wrt_combi         [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] wrt               [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] sbv_combi         [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] sbv               [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] sbvt_combi        [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] sbvt              [CFG_CTL_TBP_NUM-1:0];
    
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_rpv_combi  [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_rpv        [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_sbvt_combi [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_sbvt       [CFG_CTL_TBP_NUM-1:0];
    
    reg     [CFG_CTL_TBP_NUM-1:0] or_wrt;
    
    reg     [CFG_CTL_TBP_NUM-1:0] nor_rpv;
    reg     [CFG_CTL_TBP_NUM-1:0] nor_cpv;
    reg     [CFG_CTL_TBP_NUM-1:0] nor_wrt;
    reg     [CFG_CTL_TBP_NUM-1:0] nor_sbv;
    reg     [CFG_CTL_TBP_NUM-1:0] nor_sbvt;
    
    wire    [CFG_CTL_TBP_NUM-1:0]                               tbp_read;
    wire    [CFG_CTL_TBP_NUM-1:0]                               tbp_write;
    wire    [CFG_CTL_TBP_NUM-1:0]                               tbp_ap;
    wire    [(CFG_CTL_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0]         tbp_chipsel;
    wire    [(CFG_CTL_TBP_NUM*CFG_MEM_IF_BA_WIDTH)-1:0]         tbp_bank;
    wire    [(CFG_CTL_TBP_NUM*CFG_MEM_IF_ROW_WIDTH)-1:0]        tbp_row;
    wire    [(CFG_CTL_TBP_NUM*CFG_MEM_IF_COL_WIDTH)-1:0]        tbp_col;
    wire    [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0]  tbp_shadow_chipsel;
    wire    [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_BA_WIDTH)-1:0]  tbp_shadow_bank;
    wire    [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_ROW_WIDTH)-1:0] tbp_shadow_row;
    wire    [(CFG_CTL_TBP_NUM*CFG_INT_SIZE_WIDTH)-1:0]          tbp_size;
    wire    [(CFG_CTL_TBP_NUM*CFG_LOCAL_ID_WIDTH)-1:0]          tbp_localid;
    wire    [(CFG_CTL_TBP_NUM*CFG_DATA_ID_WIDTH)-1:0]           tbp_dataid;
    wire    [(CFG_CTL_TBP_NUM*CFG_CTL_TBP_NUM)-1:0]             tbp_age;
    wire    [CFG_CTL_TBP_NUM-1:0]                               tbp_priority;
    wire    [CFG_CTL_TBP_NUM-1:0]                               tbp_rmw_correct;
    wire    [CFG_CTL_TBP_NUM-1:0]                               tbp_rmw_partial;
    
    wire    [CFG_MEM_IF_CHIP-1:0]                               tbp_bank_active;
    wire    [CFG_MEM_IF_CHIP-1:0]                               tbp_timer_ready;
    reg     [CFG_MEM_IF_CHIP-1:0]                               bank_active;
    reg     [CFG_MEM_IF_CHIP-1:0]                               timer_ready;
    reg     [CFG_CTL_TBP_NUM-1:0]                               int_bank_active        [CFG_MEM_IF_CHIP-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]                               int_timer_ready        [CFG_MEM_IF_CHIP-1:0];
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]                        int_shadow_timer_ready [CFG_MEM_IF_CHIP-1:0];
    
    reg     [CFG_CTL_TBP_NUM-1:0]        same_command_read;
    reg     [CFG_CTL_TBP_NUM-1:0]        same_chip_bank_row;
    reg     [CFG_CTL_TBP_NUM-1:0]        same_chip_bank_diff_row;
    reg     [CFG_CTL_TBP_NUM-1:0]        same_chip_bank;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] same_shadow_command_read;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] same_shadow_chip_bank_row;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] same_shadow_chip_bank_diff_row;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] same_shadow_chip_bank;
    reg     [CFG_CTL_TBP_NUM-1:0]        pre_calculated_same_chip_bank_diff_row [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]        pre_calculated_same_chip_bank_row      [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0]        pre_calculated_same_chip_bank          [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] pre_calculated_same_shadow_chip_bank   [CFG_CTL_TBP_NUM-1:0];
    
    reg     [COL_TIMER_WIDTH-1:0] col_timer           [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] col_timer_ready;
    reg     [CFG_CTL_TBP_NUM-1:0] col_timer_pre_ready;
    
    reg     [ROW_TIMER_WIDTH-1:0] row_timer_combi     [CFG_CTL_TBP_NUM-1:0];
    reg     [ROW_TIMER_WIDTH-1:0] row_timer           [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] row_timer_ready;
    reg     [CFG_CTL_TBP_NUM-1:0] row_timer_pre_ready;
    
    reg     [TRC_TIMER_WIDTH-1:0] trc_timer           [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_CTL_TBP_NUM-1:0] trc_timer_ready;
    reg     [CFG_CTL_TBP_NUM-1:0] trc_timer_pre_ready;
    reg     [CFG_CTL_TBP_NUM-1:0] trc_timer_pre_ready_combi;
    
    reg     [CFG_CTL_TBP_NUM-1:0] pch_ready;
    
    reg     [CFG_CTL_TBP_NUM-1:0] compare_t_param_rd_ap_to_valid_greater_than_trc_timer;
    reg     [CFG_CTL_TBP_NUM-1:0] compare_t_param_wr_ap_to_valid_greater_than_trc_timer;
    reg     [CFG_CTL_TBP_NUM-1:0] compare_t_param_rd_to_pch_greater_than_row_timer;
    reg     [CFG_CTL_TBP_NUM-1:0] compare_t_param_wr_to_pch_greater_than_row_timer;
    
    reg                           compare_t_param_act_to_rdwr_less_than_offset;
    reg                           compare_t_param_act_to_act_less_than_offset;
    reg                           compare_t_param_act_to_pch_less_than_offset;
    reg                           compare_t_param_rd_to_pch_less_than_offset;
    reg                           compare_t_param_wr_to_pch_less_than_offset;
    reg                           compare_t_param_pch_to_valid_less_than_offset;
    reg                           compare_t_param_rd_ap_to_valid_less_than_offset;
    reg                           compare_t_param_wr_ap_to_valid_less_than_offset;
    
    reg                           compare_offset_t_param_act_to_rdwr_less_than_0;
    reg                           compare_offset_t_param_act_to_rdwr_less_than_1;
    
    reg     [T_PARAM_ACT_TO_RDWR_WIDTH-1:0]    offset_t_param_act_to_rdwr;
    reg     [T_PARAM_ACT_TO_ACT_WIDTH-1:0]     offset_t_param_act_to_act;
    reg     [T_PARAM_ACT_TO_PCH_WIDTH-1:0]     offset_t_param_act_to_pch;
    reg     [T_PARAM_RD_TO_PCH_WIDTH-1:0]      offset_t_param_rd_to_pch;
    reg     [T_PARAM_WR_TO_PCH_WIDTH-1:0]      offset_t_param_wr_to_pch;
    reg     [T_PARAM_PCH_TO_VALID_WIDTH-1:0]   offset_t_param_pch_to_valid;
    reg     [T_PARAM_RD_AP_TO_VALID_WIDTH-1:0] offset_t_param_rd_ap_to_valid;
    reg     [T_PARAM_WR_AP_TO_VALID_WIDTH-1:0] offset_t_param_wr_ap_to_valid;
    
    reg     [CFG_CTL_TBP_NUM-1:0] can_act;
    reg     [CFG_CTL_TBP_NUM-1:0] can_pch;
    reg     [CFG_CTL_TBP_NUM-1:0] can_rd;
    reg     [CFG_CTL_TBP_NUM-1:0] can_wr;
    
    reg     [CFG_CTL_TBP_NUM-1:0] finish_tbp;
    
    wire    [CFG_CTL_SHADOW_TBP_NUM-1:0] flush_shadow_tbp;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] push_tbp_combi;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] push_tbp;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] ready_to_push_tbp_combi;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] ready_to_push_tbp;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_valid;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]    shadow_chipsel             [CFG_CTL_SHADOW_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]    shadow_bank                [CFG_CTL_SHADOW_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]   shadow_row                 [CFG_CTL_SHADOW_TBP_NUM-1:0];
    reg     [ROW_TIMER_WIDTH-1:0]        shadow_row_timer           [CFG_CTL_SHADOW_TBP_NUM-1:0];
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_row_timer_pre_ready;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] shadow_row_timer_ready;
    
    wire    one  = 1'b1;
    wire    zero = 1'b0;
    
    integer i;
    integer j;
    genvar  k;
    
    //----------------------------------------------------------------------------------------------------
    // Output port assignments
    //----------------------------------------------------------------------------------------------------
    assign tbp_read        = read;
    assign tbp_write       = write;
    assign tbp_ap          = real_ap;
    assign tbp_burst_chop  = burst_chop;
    assign tbp_precharge   = precharge;
    assign tbp_activate    = activate;
    assign tbp_priority    = priority_a;
    assign tbp_rmw_correct = rmw_correct;
    assign tbp_rmw_partial = rmw_partial;
    
    generate
        begin
            for(k=0; k<CFG_CTL_TBP_NUM; k=k+1)
                begin : tbp_name
                    assign tbp_chipsel[(k*CFG_MEM_IF_CS_WIDTH)+CFG_MEM_IF_CS_WIDTH-1:k*CFG_MEM_IF_CS_WIDTH]    = chipsel[k];
                    assign tbp_bank   [(k*CFG_MEM_IF_BA_WIDTH)+CFG_MEM_IF_BA_WIDTH-1:k*CFG_MEM_IF_BA_WIDTH]    = bank   [k];
                    assign tbp_row    [(k*CFG_MEM_IF_ROW_WIDTH)+CFG_MEM_IF_ROW_WIDTH-1:k*CFG_MEM_IF_ROW_WIDTH] = row    [k];
                    assign tbp_col    [(k*CFG_MEM_IF_COL_WIDTH)+CFG_MEM_IF_COL_WIDTH-1:k*CFG_MEM_IF_COL_WIDTH] = col    [k];
                    assign tbp_localid[(k*CFG_LOCAL_ID_WIDTH)+CFG_LOCAL_ID_WIDTH-1:k*CFG_LOCAL_ID_WIDTH]       = localid[k];
                    assign tbp_dataid [(k*CFG_DATA_ID_WIDTH)+CFG_DATA_ID_WIDTH-1:k*CFG_DATA_ID_WIDTH]          = dataid [k];
                    assign tbp_age    [(k*CFG_CTL_TBP_NUM)+CFG_CTL_TBP_NUM-1:k*CFG_CTL_TBP_NUM]                = age    [k];
                    assign tbp_size   [(k*CFG_INT_SIZE_WIDTH)+CFG_INT_SIZE_WIDTH-1:k*CFG_INT_SIZE_WIDTH]       = size   [k];
                end
            
            for(k=0; k<CFG_CTL_SHADOW_TBP_NUM; k=k+1)
                begin : tbp_shadow_name
                    if (CFG_ENABLE_SHADOW_TBP)
                        begin
                            assign tbp_shadow_chipsel[(k*CFG_MEM_IF_CS_WIDTH)+CFG_MEM_IF_CS_WIDTH-1:k*CFG_MEM_IF_CS_WIDTH]    = shadow_chipsel[k];
                            assign tbp_shadow_bank   [(k*CFG_MEM_IF_BA_WIDTH)+CFG_MEM_IF_BA_WIDTH-1:k*CFG_MEM_IF_BA_WIDTH]    = shadow_bank   [k];
                            assign tbp_shadow_row    [(k*CFG_MEM_IF_ROW_WIDTH)+CFG_MEM_IF_ROW_WIDTH-1:k*CFG_MEM_IF_ROW_WIDTH] = shadow_row    [k];
                        end
                    else
                        begin
                            assign tbp_shadow_chipsel[(k*CFG_MEM_IF_CS_WIDTH)+CFG_MEM_IF_CS_WIDTH-1:k*CFG_MEM_IF_CS_WIDTH]    = 0;
                            assign tbp_shadow_bank   [(k*CFG_MEM_IF_BA_WIDTH)+CFG_MEM_IF_BA_WIDTH-1:k*CFG_MEM_IF_BA_WIDTH]    = 0;
                            assign tbp_shadow_row    [(k*CFG_MEM_IF_ROW_WIDTH)+CFG_MEM_IF_ROW_WIDTH-1:k*CFG_MEM_IF_ROW_WIDTH] = 0;
                        end
                end
        end
    endgenerate
    
    assign  tbp_full          = int_tbp_full;
    assign  tbp_empty         = int_tbp_empty;
    assign  int_tbp_empty     = &(valid ^~ done); // empty if valid and done are the same
    assign  load_tbp          = (~int_tbp_full & cmd_gen_load) ? load_tbp_index : 0;
    assign  flush_tbp         = open_row_pass_flush_r | finish_tbp | (done & precharge_tbp);
    assign  tbp_load          = load_tbp;
    assign  tbp_bank_active   = bank_active;
    assign  tbp_timer_ready   = timer_ready;
    assign  precharge         = activated;
    assign  activate          = ~activated;
    
    //----------------------------------------------------------------------------------------------------
    // TBP General Functions
    //----------------------------------------------------------------------------------------------------
    assign valid_combi = (valid | load_tbp) & ~flush_tbp;
    
    // Decide which TBP to load
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    load_tbp_index <= 0;
                end
            else
                begin
                    load_tbp_index <= ~valid_combi & (valid_combi + 1);
                end
        end
    
    // Assert when TBP is full to prevent further load
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_tbp_full <= 0;
                end
            else
                begin
                    int_tbp_full <= &valid_combi;
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Finish TBP
    //----------------------------------------------------------------------------------------------------
    // Logic to determine when can we flush a done TBP
    // in non-shadow TBP case, we can only flush once the timer finished counting
    // in shadow TBP case, we can flush once it is pushed into shadow TBP
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                begin
                    if (CFG_ENABLE_SHADOW_TBP)
                        begin
                            finish_tbp[i] = push_tbp[i] | (done[i] & precharged[i] & row_timer_pre_ready[i]);
                        end
                    else
                        begin
                            finish_tbp[i] = done[i] & precharged[i] & row_timer_pre_ready[i];
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Shadow TBP Logic
    //----------------------------------------------------------------------------------------------------
    // Determine when can we flush TBP
    assign flush_shadow_tbp   = shadow_valid & shadow_row_timer_pre_ready;
    
    // Determine when it's ready to push into shadow TBP
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                begin
                    if (CFG_ENABLE_SHADOW_TBP)
                        begin
                            if (flush_tbp[i]) // TBP might flush before shadow TBP is still allocated
                                begin
                                    ready_to_push_tbp_combi[i] = 1'b0;
                                end
                            else if (push_tbp[i]) // we want push_tbp to pulse for one clock cycle only
                                begin
                                    ready_to_push_tbp_combi[i] = 1'b0;
                                end
                            else if ((col_grant[i] && real_ap[i]) || (pch_grant[i] && done[i])) // indicate ready to push TBP once TBP is done
                                begin
                                    ready_to_push_tbp_combi[i] = 1'b1;
                                end
                            else
                                begin
                                    ready_to_push_tbp_combi[i] = ready_to_push_tbp[i];
                                end
                        end
                    else
                        begin
                            ready_to_push_tbp_combi[i] = zero;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            ready_to_push_tbp[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            ready_to_push_tbp[i] <= ready_to_push_tbp_combi[i];
                        end
                end
        end
    
    // Determine when to push into shadow TBP
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                begin
                    if (CFG_ENABLE_SHADOW_TBP)
                        begin
                            if (push_tbp[i]) // we want push_tbp to pulse for one clock cycle only
                                begin
                                    push_tbp_combi[i] = 1'b0;
                                end
                            else if (ready_to_push_tbp_combi[i] && shadow_row_timer_pre_ready[i]) // prevent pushing into an allocated shadow TBP
                                begin
                                    push_tbp_combi[i] = 1'b1;
                                end
                            else
                                begin
                                    push_tbp_combi[i] = push_tbp[i];
                                end
                        end
                    else
                        begin
                            push_tbp_combi[i] = zero;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            push_tbp[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            push_tbp[i] <= push_tbp_combi[i];
                        end
                end
        end
    
    // Shadow TBP information
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            shadow_chipsel[i] <= 0;
                            shadow_bank   [i] <= 0;
                            shadow_row    [i] <= 0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            if (CFG_ENABLE_SHADOW_TBP)
                                begin
                                    if (push_tbp_combi[i])
                                        begin
                                            shadow_chipsel[i] <= chipsel[i];
                                            shadow_bank   [i] <= bank   [i];
                                            shadow_row    [i] <= row    [i];
                                        end
                                end
                            else
                                begin
                                    shadow_chipsel[i] <= 0;
                                    shadow_bank   [i] <= 0;
                                    shadow_row    [i] <= 0;
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            shadow_valid[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            if (CFG_ENABLE_SHADOW_TBP)
                                begin
                                    if (flush_shadow_tbp[i])
                                        begin
                                            shadow_valid[i] <= 1'b0;
                                        end
                                    else if (push_tbp[i])
                                        begin
                                            shadow_valid[i] <= 1'b1;
                                        end
                                end
                            else
                                begin
                                    shadow_valid[i] <= 1'b0;
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            shadow_row_timer          [i] <= 0;
                            shadow_row_timer_pre_ready[i] <= 1'b0;
                            shadow_row_timer_ready    [i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_SHADOW_TBP_NUM; i=i+1)
                        begin
                            if (CFG_ENABLE_SHADOW_TBP)
                                begin
                                    if (push_tbp[i])
                                        begin
                                            if (!row_timer_pre_ready[i] || !trc_timer_pre_ready[i])
                                                begin
                                                    // Decide to take the larger timer value between row/trc timer
                                                    if (row_timer[i] > trc_timer[i])
                                                        begin
                                                            shadow_row_timer[i] <= row_timer[i] - 1'b1;
                                                        end
                                                    else
                                                        begin
                                                            shadow_row_timer[i] <= trc_timer[i] - 1'b1;
                                                        end
                                                    
                                                    shadow_row_timer_pre_ready[i] <= 1'b0;
                                                    shadow_row_timer_ready    [i] <= 1'b0;
                                                end
                                            else
                                                begin
                                                    shadow_row_timer          [i] <= 0;
                                                    shadow_row_timer_pre_ready[i] <= 1'b1;
                                                    shadow_row_timer_ready    [i] <= 1'b1;
                                                end
                                        end
                                    else
                                        begin
                                            if (shadow_row_timer[i] != 0)
                                                begin
                                                    shadow_row_timer[i] <= shadow_row_timer[i] - 1'b1;
                                                end
                                            
                                            if (shadow_row_timer[i] <= 1)
                                                begin
                                                    shadow_row_timer_ready[i] <= 1'b1;
                                                end
                                            
                                            if (shadow_row_timer[i] <= 2)
                                                begin
                                                    shadow_row_timer_pre_ready[i] <= 1'b1;
                                                end
                                        end
                                end
                            else
                                begin
                                    shadow_row_timer          [i] <= 0;
                                    shadow_row_timer_pre_ready[i] <= 1'b0;
                                    shadow_row_timer_ready    [i] <= 1'b0;
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Request logic
    //----------------------------------------------------------------------------------------------------
    // Can_* logic for request logic, indicate whether TBP can request now
    // Can activate
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            can_act[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (activated_combi[i]) // activated, so there is no need to enable activate again
                                begin
                                    can_act[i] <= 1'b0;
                                end
                            else if (col_grant[i]) //done, there is no need to enable activate again
                                begin
                                    can_act[i] <= 1'b0;
                                end
                            else if (load_tbp[i]) // new TBP command, assume no open-row-pass (handled by statement above)
                                begin
                                    can_act[i] <= 1'b1;
                                end
                            else if
                                (
                                    !done[i] && valid[i] &&
                                    (
                                        ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && (precharge_tbp[i] || pch_grant[i])) ||
                                        ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && (precharge_tbp[i]                )) ||
                                        (!cfg_reorder_data && precharge_tbp[i])
                                    )
                                )
                                // precharge or precharge all command, re-enable since it is not done
                                // (INTER_ROW) we need to validate pch_grant because precharge might happen to a newly loaded TBP due to TBP interlock case (see require_pch logic)
                                begin
                                    can_act[i] <= 1'b1;
                                end
                        end
                end
        end
    
    // Can precharge
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            can_pch[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            can_pch[i] <= one; // there is no logic required for precharge, keeping this for future use
                        end
                end
        end
    
    // Can read
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            can_rd[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (col_grant[i] || done[i]) // done, there is no need to enable read again
                                begin
                                    can_rd[i] <= 1'b0;
                                end
                            else if
                                (
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && (precharge_tbp[i] || pch_grant[i])) ||
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && (precharge_tbp[i]                )) ||
                                    (!cfg_reorder_data && precharge_tbp[i])
                                )
                                // precharge or precharge all command, can't read since bank is not active
                                // (INTER_ROW) we need to validate pch_grant because precharge might happen to a newly loaded TBP due to TBP interlock case (see require_pch logic)
                                begin
                                    can_rd[i] <= 1'b0;
                                end
                            else if (((act_grant[i] && compare_t_param_act_to_rdwr_less_than_offset) || open_row_pass[i] || activated[i]) && col_timer_pre_ready[i]) // activated and timer is ready
                                begin
                                    can_rd[i] <= 1'b1;
                                end
                        end
                end
        end
    
    // Can write
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            can_wr[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (col_grant[i] || done[i]) // done, there is no need to enable read again
                                begin
                                    can_wr[i] <= 1'b0;
                                end
                            else if
                                (
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && (precharge_tbp[i] || pch_grant[i])) ||
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && (precharge_tbp[i]                )) ||
                                    (!cfg_reorder_data && precharge_tbp[i])
                                )
                                // precharge or precharge all command, can't write since bank is not active
                                // (INTER_ROW) we need to validate pch_grant because precharge might happen to a newly loaded TBP due to TBP interlock case (see require_pch logic)
                                begin
                                    can_wr[i] <= 1'b0;
                                end
                            else if (((act_grant[i] && compare_t_param_act_to_rdwr_less_than_offset) || open_row_pass[i] || activated[i]) && col_timer_pre_ready[i]) // activated and timer is ready
                                begin
                                    can_wr[i] <= 1'b1;
                                end
                        end
                end
        end
    
    // Row request
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    row_req[i] = act_req[i] | pch_req[i];
                end
        end
    
    // Column request
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    col_req[i] = rd_req[i] | wr_req[i];
                end
        end
    
    // Individual activate, precharge, read and write request logic
    always @ (*)
        begin
            for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                begin
                    act_req[i] = nor_rpv[i] & nor_sbv[i] & nor_sbvt[i] & ~or_wrt[i] & can_act[i];
                    pch_req[i] = require_pch[i] & pch_ready[i]  & can_pch[i];
                    
                    rd_req [i] = nor_cpv[i] & can_rd[i] & complete_rd[i];
                    wr_req [i] = nor_cpv[i] & can_wr[i] & complete_wr[i];
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Valid logic
    //----------------------------------------------------------------------------------------------------
    // Indicates that current TBP is valid after load an invalid after flush
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            valid[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (load_tbp[i])
                                begin
                                    valid[i] <= 1'b1;
                                end
                            else if (flush_tbp[i])
                                begin
                                    valid[i] <= 1'b0;
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // TBP information
    //----------------------------------------------------------------------------------------------------
    // Keeps information from cmd_gen after load
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        chipsel    [i] <= 0;
                        bank       [i] <= 0;
                        row        [i] <= 0;
                        col        [i] <= 0;
                        write      [i] <= 0;
                        read       [i] <= 0;
                        size       [i] <= 0;
                        autopch    [i] <= 0;
                        localid    [i] <= 0;
                        dataid     [i] <= 0;
                        rmw_correct[i] <= 0;
                        rmw_partial[i] <= 0;
                    end
            else
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        if (load_tbp[i])
                            begin
                                chipsel    [i] <= cmd_gen_chipsel;
                                bank       [i] <= cmd_gen_bank;
                                row        [i] <= cmd_gen_row;
                                col        [i] <= cmd_gen_col;
                                write      [i] <= cmd_gen_write;
                                read       [i] <= cmd_gen_read;
                                size       [i] <= cmd_gen_size;
                                autopch    [i] <= cmd_gen_autopch;
                                localid    [i] <= cmd_gen_localid;
                                dataid     [i] <= cmd_gen_dataid;
                                rmw_correct[i] <= cmd_gen_rmw_correct;
                                rmw_partial[i] <= cmd_gen_rmw_partial;
                            end
                    end
        end
    
    // Priority information
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        priority_a[i] <=  1'b0;
                    end
            else
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        if (CFG_DISABLE_PRIORITY == 1)
                            begin
                                priority_a[i] <= zero;
                            end
                        else
                            begin
                                if (load_tbp[i])
                                    begin
                                        if (cfg_reorder_data) // priority will be ignored when data reordering is OFF
                                            begin
                                                priority_a[i] <= cmd_gen_priority;
                                            end
                                        else
                                            begin
                                                priority_a[i] <= 1'b0;
                                            end
                                    end
                                else if (starvation[i] == cfg_starve_limit) // assert priority when starvation limit is reached
                                    begin
                                        priority_a[i] <=  1'b1;
                                    end
                            end
                    end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Row dependency vector
    //----------------------------------------------------------------------------------------------------
    // RPV, TBP is only allowed to request row command when RPV is all zero, meaning no dependencies on other TBPs
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                        begin
                            if (load_tbp[i])
                                begin
                                    if
                                        (
                                            !flush_tbp[j] && !push_tbp[j] &&
                                            (
                                                ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && valid[j] && (same_chip_bank_row[j] || (same_chip_bank[j] && (rmw_partial[j] || rmw_correct[j])))) ||
                                                ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && valid[j] && same_chip_bank[j]) ||
                                                (!cfg_reorder_data && valid[j] && same_chip_bank[j])
                                            )
                                        )
                                        // (INTER_ROW)   Set RPV to '1' when a new TBP has same-chip-bank-row address with any other existing TBPs
                                        // (INTER_ROW)   Set RPV to '1' when existing TBP is a RMW command, we don't allow reordering between RMW commands
                                        //               This is to prevent activate going to the later RMW commands
                                        // (INTER_BANK)  Set RPV to '1' when a new TBP has same-chip-bank address with any other existing TBPs
                                        // (NON_REORDER) Set RPV to '1' when a new TBP has same-chip-bank address with any other existing TBPs, to allow command reordering
                                        begin
                                            rpv_combi[i][j] = 1'b1;
                                        end
                                    else
                                        begin
                                            rpv_combi[i][j] = 1'b0;
                                        end
                                end
                            else if (flush_tbp[j] || push_tbp[j])
                                // (INTER_ROW)  Set RPV to '0' after flush
                                // (INTER_BANK) Set RPV to '0' after flush
                                begin
                                    rpv_combi[i][j] = 1'b0;
                                end
                            else
                                begin
                                    rpv_combi[i][j] = rpv[i][j];
                                end
                        end
                end
        end
    
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                        begin
                            if (CFG_ENABLE_SHADOW_TBP)
                                begin
                                    if (load_tbp[i])
                                        begin
                                            if (!flush_shadow_tbp[j] && ((shadow_valid[j] && same_shadow_chip_bank[j]) || (push_tbp[j] && same_chip_bank[j])))
                                                // Set Shadow RPV to '1' when a new TBP has same-chip-bank address with any other existing TBPs
                                                begin
                                                    shadow_rpv_combi[i][j] = 1'b1;
                                                end
                                            else
                                                begin
                                                    shadow_rpv_combi[i][j] = 1'b0;
                                                end
                                        end
                                    else if (push_tbp[j] && rpv[i][j])
                                        // If there is a push_tbp and RPV is set to '1'
                                        // We need to shift RPV to Shadow RPV
                                        begin
                                            shadow_rpv_combi[i][j] = 1'b1;
                                        end
                                    else if (flush_shadow_tbp[j])
                                        // (INTER_ROW)  Set RPV to '0' after flush
                                        // (INTER_BANK) Set RPV to '0' after flush
                                        begin
                                            shadow_rpv_combi[i][j] = 1'b0;
                                        end
                                    else
                                        begin
                                            shadow_rpv_combi[i][j] = shadow_rpv[i][j];
                                        end
                                end
                            else
                                begin
                                    shadow_rpv_combi[i][j] = zero;
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_rpv[i] <= 1'b0;
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    rpv[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_rpv[i] <= ~|{shadow_rpv_combi[i], rpv_combi[i]};
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (i == j) // Hard-coded to '0' for own vector bit, since we only need to know the dependencies for other TBPs not ourself
                                        begin
                                            rpv[i][j] <= 1'b0;
                                        end
                                    else
                                        begin
                                            rpv[i][j] <= rpv_combi[i][j];
                                        end
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                                begin
                                    shadow_rpv[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                                begin
                                    shadow_rpv[i][j] <= shadow_rpv_combi[i][j];
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Column dependency vector
    //----------------------------------------------------------------------------------------------------
    // CPV, TBP is only allowed to request column command when CPV is all zero, meaning no dependencies on other TBPs
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                        begin
                            if (load_tbp[i])
                                begin
                                    if
                                        (
                                            !flush_tbp[j] && !col_grant[j] &&
                                            (
                                                ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && valid[j] && !done[j] && (priority_a[j] || same_chip_bank_row[j] || rmw_partial[j] || rmw_correct[j] || same_command_read[j])) ||
                                                ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && valid[j] && !done[j] && (priority_a[j] || same_chip_bank    [j] || rmw_partial[j] || rmw_correct[j] || same_command_read[j])) ||
                                                (!cfg_reorder_data && valid[j] && !done[j])
                                            )
                                        )
                                        // (INTER_ROW)   Set CPV to '1' when a new TBP has same-chip-bank-row address with any other existing TBPs
                                        // (INTER_ROW)   Set CPV to '1' when existing TBP is a RMW command, we don't allow reordering between RMW commands
                                        // (INTER_ROW)   Set CPV to '1' when existing TBP is a priority command, we don't want new TBP to take over priority command
                                        // (INTER_BANK)  Set CPV to '1' when a new TBP has same-chip-bank address with any other existing TBPs
                                        // (INTER_BANK)  Set CPV to '1' when existing TBP is a RMW command, we don't allow reordering between RMW commands
                                        // (INTER_BANK)  Set CPV to '1' when existing TBP is a priority command, we don't want new TBP to take over priority command
                                        // (NON_REORDER) Set CPV to '1' when a new TBP is loaded, all column command must be executed in order
                                        begin
                                            cpv_combi[i][j] = 1'b1;
                                        end
                                    else
                                        begin
                                            cpv_combi[i][j] = 1'b0;
                                        end
                                end
                            else if (col_grant[j])
                                // (INTER_ROW)  Set CPV to '0' after col_grant
                                // (INTER_BANK) Set CPV to '0' after col_grant
                                begin
                                    cpv_combi[i][j] = 1'b0;
                                end
                            else
                                begin
                                    cpv_combi[i][j] = cpv[i][j];
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_cpv[i] <= 1'b0;
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    cpv[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_cpv[i] <= ~|cpv_combi[i];
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (i == j)  // Hard-coded to '0' for own vector bit, since we only need to know the dependencies for other TBPs not ourself
                                        begin
                                            cpv[i][j] <= 1'b0;
                                        end
                                    else
                                        begin
                                            cpv[i][j] <= cpv_combi[i][j];
                                        end
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Activate related logic
    //----------------------------------------------------------------------------------------------------
    // Open-row-pass flush logic
    // after a granted command and WST (open row pass to another TBP with same page from just granted command) OR
    // after a done command and WST (open row pass to another TBP with same page from a done command with page open)
    
    // Logic to determine which not-done TBP should be flushed to perform open-row-pass
    always @ (*)
        begin
            not_done_tbp_row_pass_flush = col_grant & wst_p;
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            not_done_tbp_row_pass_flush_r[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            not_done_tbp_row_pass_flush_r[i] <= not_done_tbp_row_pass_flush[i];
                        end
                end
        end
    
    // Logic to determine which done TBP should be flushed to perform open-row-pass
    always @ (*)
        begin
            done_tbp_row_pass_flush = done & wst_p & ~row_grant & ~precharge_tbp;
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            done_tbp_row_pass_flush_r[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (done_tbp_row_pass_flush_r[i])
                                begin
                                    done_tbp_row_pass_flush_r[i] <= 1'b0;
                                end
                            else
                                begin
                                    done_tbp_row_pass_flush_r[i] <= done_tbp_row_pass_flush[i];
                                end
                        end
                end
        end
    
    // Using done_tbp_row_pass_flush_r to improve timing
    // it's acceptable to add one clock cycle latency when performing open-row-pass from a done command
    // [REMARK] there is potential to optimize the flush logic (for done-open-row-pass case), because flush_tbp depends on open_row_pass_flush logic
    assign  open_row_pass_flush = not_done_tbp_row_pass_flush | done_tbp_row_pass_flush;
    
    // Open-row-pass logic, TBP will pass related information to same page command (increase efficiency)
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    open_row_pass[i] = |open_row_pass_flush && or_wrt[i] && |(wrt[i] & open_row_pass_flush);
                end
        end
    
    // Registered version
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            open_row_pass_r      [i] <= 1'b0;
                            open_row_pass_flush_r[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            open_row_pass_r      [i] <= open_row_pass      [i];
                            open_row_pass_flush_r[i] <= open_row_pass_flush[i];
                        end
                end
        end
    
    // Activated logic
    // indicate that current TBP is activated by activate command or open-row-pass
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (act_grant[i] || open_row_pass[i])
                        begin
                            activated_combi[i] = 1'b1;
                        end
                    else
                        begin
                            activated_combi[i] = 1'b0;
                        end
                end
        end
    
    // activated need not to be validated with valid
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            activated  [i] <= 1'b0;
                            activated_p[i] <= 1'b0;
                        end
                end
            else
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        activated_p[i] <= activated_combi[i]; // activated pulse
                        
                        if (flush_tbp[i] || pch_grant[i])
                            begin
                                activated[i] <= 1'b0;
                            end
                        else if (precharge_tbp[i])
                            begin
                                activated[i] <= 1'b0;
                            end
                        else if (activated_combi[i])
                            begin
                                activated[i] <= 1'b1;
                            end
                    end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Precharge related logic
    //----------------------------------------------------------------------------------------------------
    // Precharge all logic
    // indicate which TBP is precharged cause of sideband precharge all command
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    precharge_tbp[i] = sb_tbp_precharge_all[i];
                end
        end
    
    // Precharge logic
    // indicate which TBP is precharged
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (load_tbp[i])
                        begin
                            precharged_combi[i] = 1'b0;
                        end
                    else if (activated_combi[i] && cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW")
                        // Only required in INTER-ROW reordering case since TBP might request precharge after TBP load
                        // due to TBP interlock case
                        begin
                            precharged_combi[i] = 1'b0;
                        end
                    else if (col_grant[i] && real_ap[i])
                        begin
                            precharged_combi[i] = 1'b1;
                        end
                    else if (pch_grant[i])
                        begin
                            precharged_combi[i] = 1'b1;
                        end
                    else
                        begin
                            precharged_combi[i] = precharged[i];
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            precharged[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            precharged[i] <= precharged_combi[i];
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Auto-precharge related logic
    //----------------------------------------------------------------------------------------------------
    // Auto precharge related logic, to determine which TBP should be closed or kept open
    // OPP - autoprecharge when there is another command to same chip-bank different row
    // CPP - do not autoprecharge when there is another command to the same chip-bank-row
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (flush_tbp[i])
                        begin
                            apvo_combi[i] = 1'b0;
                            apvc_combi[i] = 1'b0;
                        end
                    else if
                        (
                            (load_tbp[i] && CFG_DATA_REORDERING_TYPE == "INTER_ROW") || // load self
                            (
                                (|load_tbp && !load_tbp[i]) && // load other TBP
                                (
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW") ||
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && !ssb[i]) ||
                                    (!cfg_reorder_data && !ssb[i])
                                )
                            )
                        )
                        // (INTER_ROW)   update multiple times whenever there is a load so that it'll get the latest AP info
                        // (INTER_BANK)  only update this once after same chip-bank command is loaded, masked by SSB (seen same bank)
                        // (NON_REORDER) only update this once after same chip-bank command is loaded, masked by SSB (seen same bank)
                        begin
                            if
                                (
                                    (load_tbp[i] && |(valid & same_chip_bank_diff_row) && cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW") ||
                                    ((|load_tbp && !load_tbp[i]) && valid[i] && same_chip_bank_diff_row[i])
                                )
                                // (INTER_ROW) on self load, set to '1' if other valid TBP is same-chip-bank-diff-row with self
                                // set to '1' if there is a new command with same-chip-bank-diff-row with current TBP
                                begin
                                    apvo_combi[i] = 1'b1;
                                end
                            else
                                begin
                                    apvo_combi[i] = apvo[i];
                                end
                            
                            if ((|load_tbp && !load_tbp[i]) && valid[i] && same_chip_bank_row[i])
                                // set to '1' if there is a new command with same-chip-bank-row with current TBP
                                begin
                                    apvc_combi[i] = 1'b1;
                                end
                            else
                                begin
                                    apvc_combi[i] = apvc[i];
                                end
                        end
                    else
                        begin
                            apvo_combi[i] = apvo[i];
                            apvc_combi[i] = apvc[i];
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            apvo[i] <= 1'b0;
                            apvc[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            apvo[i] <= apvo_combi[i];
                            apvc[i] <= apvc_combi[i];
                        end
                end
        end
    
    // Auto precharge
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (apvc[i]) // keeping a page open have higher priority that keeping a close page (improve efficiency)
                        begin
                            ap[i] = 1'b0;
                        end
                    else if (apvo[i])
                        begin
                            ap[i] = 1'b1;
                        end
                    else
                        begin
                            ap[i] = autopch[i] | require_flush[i];
                        end
                end
        end
    
    // Real auto-precharge
    // purpose is to make pipelining easier in the future (if needed)
    always @ (*)
    begin
        real_ap = ap;
    end
    
    //----------------------------------------------------------------------------------------------------
    // Done logic
    //----------------------------------------------------------------------------------------------------
    // Indicate that current TBP has finished issuing column command
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (load_tbp[i])
                        begin
                            done_combi[i] = 1'b0;
                        end
                    else if (flush_tbp[i])
                        begin
                            done_combi[i] = 1'b0;
                        end
                    else if (col_grant[i])
                        begin
                            done_combi[i] = 1'b1;
                        end
                    else
                        begin
                            done_combi[i] = done[i];
                        end
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            done[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            done[i] <= done_combi[i];
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Complete logic
    //----------------------------------------------------------------------------------------------------
    // Indicate that the data for current TBP is complete and ready to be issued
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (load_tbp[i])
                        begin
                            if (cmd_gen_read)
                                begin
                                    complete_combi_rd[i] =  cmd_gen_complete;
                                    complete_combi_wr[i] =  1'b0;
                                end
                            else
                                begin
                                    complete_combi_rd[i] =  1'b0;
                                    complete_combi_wr[i] =  cmd_gen_complete;
                                end
                        end
                    else if (write[i] && !complete[i])
                        begin
                            complete_combi_rd[i] =  complete_rd[i];
                            complete_combi_wr[i] =  data_complete[i];
                        end
                    else
                        begin
                            complete_combi_rd[i] = complete_rd[i];
                            complete_combi_wr[i] = complete_wr[i];
                        end
                end
        end
    
    always @ (*)
        begin
            complete_combi = complete_combi_rd | complete_combi_wr;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    complete    <=  0;
                    complete_rd <=  0;
                    complete_wr <=  0;
                end
            else
                begin
                    complete    <=  complete_combi;
                    complete_rd <=  complete_combi_rd;
                    complete_wr <=  complete_combi_wr;
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Same bank vector logic
    //----------------------------------------------------------------------------------------------------
    // This bit vector (same bank vector) is to stop a TBP from requesting activate when another row in the same chip-bank was granted
    // SBV stops TBP from requesting activate when there is another same-chip-bank-diff-row was granted
    // prevents activate to and activated bank
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                        begin
                            if (CFG_DATA_REORDERING_TYPE == "INTER_BANK")
                                begin
                                    // There is no need to SBV in INTER_BANK case
                                    sbv_combi[i][j] = zero;
                                end
                            else if (CFG_DATA_REORDERING_TYPE == "INTER_ROW")
                                begin
                                    if
                                        (
                                            (load_tbp[i] && !flush_tbp[j] && (activated[j] || activated_combi[j]) && same_chip_bank_diff_row[j]) ||
                                            (activated_combi[j] && valid[i] && pre_calculated_same_chip_bank_diff_row [i][j])
                                        )
                                        // Set SBV to '1' if new TBP is same-chip-bank-diff-row with other existing TBP
                                        // Set SBV to '1' if there is a row_grant or open-row-pass to other existing TBP with same-chip-bank-diff-row
                                        begin
                                            sbv_combi[i][j] = 1'b1;
                                        end
                                    else if (flush_tbp[j] || pch_grant[j] || precharge_tbp[j])
                                        // Set SBV to '0' if there is a flush to other TBP
                                        // Set SBV to '0' if there is a precharge to other TBP
                                        // Set SBV to '0' if there is a precharge all command from sideband
                                        begin
                                            sbv_combi[i][j] = 1'b0;
                                        end
                                    else
                                        begin
                                            sbv_combi[i][j] = sbv[i][j];
                                        end
                                end
                            else
                                begin
                                    sbv_combi[i][j] = sbv[i][j];
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_sbv[i] <= 1'b0;
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    sbv[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_sbv[i] <= ~|sbv_combi[i];
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (i == j) // Hard-coded to '0' for own vector bit, since we only need to know the dependencies for other TBPs not ourself
                                        begin
                                            sbv[i][j] <= 1'b0;
                                        end
                                    else
                                        begin
                                            sbv[i][j] <= sbv_combi[i][j];
                                        end
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Same bank timer vector logic
    //----------------------------------------------------------------------------------------------------
    // SBTV stops TBP from requesting activate when the timer for same-chip-bank is still running
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                        begin
                            if (CFG_DATA_REORDERING_TYPE == "INTER_BANK")
                                begin
                                    sbvt_combi[i][j] = zero;
                                end
                            else if (CFG_DATA_REORDERING_TYPE == "INTER_ROW")
                                begin
                                    if (flush_tbp[i])
                                        begin
                                            sbvt_combi[i][j] = 1'b0;
                                        end
                                    else if (push_tbp[j])
                                        begin
                                            sbvt_combi[i][j] = 1'b0;
                                        end
                                    else if
                                        (
                                            (pch_grant[j] || (col_grant[j] && real_ap[j])) &&
                                            (
                                                (load_tbp[i] && same_chip_bank[j]) ||
                                                (valid[i] && pre_calculated_same_chip_bank[i][j])
                                            )
                                        )
                                        // Set to '1' when there is a precharge/auto-precharge to same-chip-bank address
                                        begin
                                            sbvt_combi[i][j] = 1'b1;
                                        end
                                    else if
                                        (
                                             precharged[j] && valid[j] &&
                                            (
                                                (load_tbp[i] && same_chip_bank[j]) ||
                                                (valid[i] && pre_calculated_same_chip_bank[i][j])
                                            )
                                        )
                                        // Set to '1' when same-chip-bank address TBP is still in precharge state
                                        begin
                                            sbvt_combi[i][j] = ~row_timer_pre_ready[j];
                                        end
                                    else
                                        begin
                                            sbvt_combi[i][j] = zero;
                                        end
                                end
                            else
                                begin
                                    sbvt_combi[i][j] = sbvt[i][j];
                                end
                        end
                end
        end
    
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                        begin
                            if (CFG_ENABLE_SHADOW_TBP)
                                begin
                                    if (CFG_DATA_REORDERING_TYPE == "INTER_BANK")
                                        begin
                                            shadow_sbvt_combi[i][j] = zero;
                                        end
                                    else if (CFG_DATA_REORDERING_TYPE == "INTER_ROW")
                                        begin
                                            if (flush_shadow_tbp[j])
                                                begin
                                                    shadow_sbvt_combi[i][j] = 1'b0;
                                                end
                                            else if (push_tbp[j] && sbvt[i][j])
                                                begin
                                                    shadow_sbvt_combi[i][j] = 1'b1;
                                                end
                                            else if (valid[i] && shadow_valid[j] && pre_calculated_same_shadow_chip_bank[i][j])
                                                // Set to 'timer-pre-ready' when own TBP is valid, shadow TBP is valid and same chip-bank address
                                                begin
                                                    shadow_sbvt_combi[i][j] = ~shadow_row_timer_pre_ready[j];
                                                end
                                            else
                                                begin
                                                    shadow_sbvt_combi[i][j] = shadow_sbvt[i][j];
                                                end
                                        end
                                    else
                                        begin
                                            shadow_sbvt_combi[i][j] = zero;
                                        end
                                end
                            else
                                begin
                                    shadow_sbvt_combi[i][j] = zero;
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    sbvt[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            nor_sbvt[i] <= ~|{shadow_sbvt_combi[i], sbvt_combi[i]};
                            
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (i == j) // Hard-coded to '0' for own vector bit, since we only need to know the dependencies for other TBPs not ourself
                                        begin
                                            sbvt[i][j] <= 1'b0;
                                        end
                                    else
                                        begin
                                            sbvt[i][j] <= sbvt_combi[i][j];
                                        end
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                                begin
                                    shadow_sbvt[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                                begin
                                    shadow_sbvt[i][j] <= shadow_sbvt_combi[i][j];
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Seen same bank logic
    //----------------------------------------------------------------------------------------------------
    // Indicate that it sees a new TBP which is same-chip-bank with current TBP
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            ssb[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (flush_tbp[i])
                                        begin
                                            ssb[i] <= 1'b0;
                                        end
                                    else if (load_tbp[j] && valid[i] && same_chip_bank[i])
                                        begin
                                            ssb[i] <= 1'b1;
                                        end
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Seen same bank row logic
    //----------------------------------------------------------------------------------------------------
    // Indicate that it sees a new TBP which is same-chip-bank-row with current TBP
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            ssbr[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (flush_tbp[i])
                                        begin
                                            ssbr[i] <= 1'b0;
                                        end
                                    else if (load_tbp[j] && valid[i] && same_chip_bank_row[i])
                                        begin
                                            ssbr[i] <= 1'b1;
                                        end
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Will send transfer logic
    //----------------------------------------------------------------------------------------------------
    // Indicate that it will pass current TBP information (timing/page) over to other TBP
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            wst  [i] <= 1'b0;
                            wst_p[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (load_tbp[i]) // Reset back to '0'
                                        begin
                                            wst  [i] <= 1'b0;
                                            wst_p[i] <= 1'b0;
                                        end
                                    else if
                                        (
                                            ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && precharged_combi[i] && done_combi[i]) ||
                                            ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && precharged_combi[i]                 ) ||
                                            (!cfg_reorder_data && precharged_combi[i])
                                        )
                                        // Set to '0' when there is a precharge to current TBP, after a precharge, it's not possible to perform open-row-pass anymore
                                        // (INTER_ROW) included done_combi because precharge can happen to a newly loaded TBP due to TBP interlock case (see require_pch logic)
                                        //               to make sure we're able to open-row-pass a not-done precharged command
                                        begin
                                            wst  [i] <= 1'b0;
                                            wst_p[i] <= 1'b0;
                                        end
                                    else if (open_row_pass_flush[i]) // make sure open-row-pass only asserts for one clock cycle
                                        begin
                                            wst_p[i] <= 1'b0;
                                        end
                                    else if
                                        (
                                            load_tbp[j] && same_chip_bank_row[i] &&
                                            (
                                                ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && !ssbr[i] && !(precharged_combi[i] && done_combi[i])) ||
                                                ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && !ssb [i] && !(precharged_combi[i]                 )) ||
                                                (!cfg_reorder_data && !ssb[i] && !precharged_combi[i])
                                            )
                                        )
                                        // Set to '1' when there is a new TBP being loaded, with same-chip-bank-row with current TBP
                                        // make sure current TBP is not precharged so that information can be pass over to same-chip-bank-row TBP
                                        // (INTER_ROW)   included done_combi because precharge can happen to a newly loaded TBP due to TBP interlock case (see require_pch logic)
                                        //               to make sure we're able to open-row-pass a not-done precharged command
                                        // (INTER_BANK)  make sure SSB is not set (only set WST once)
                                        // (NON_REORDER) make sure SSB is not set (only set WST once)
                                        begin
                                            wst  [i] <= 1'b1;
                                            wst_p[i] <= 1'b1;
                                        end
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Will receive transfer logic
    //----------------------------------------------------------------------------------------------------
    // Indicate that it will receive TBP information (timing/page) from other TBP (also tells which TBP it is receiving from)
    always @ (*)
    begin
        for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
            begin
                for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                    begin
                        if
                            (
                                load_tbp[i] && !flush_tbp[j] && valid[j] && same_chip_bank_row[j] &&
                                (
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_ROW"  && !ssbr[j]) ||
                                    ( cfg_reorder_data && CFG_DATA_REORDERING_TYPE == "INTER_BANK" && !ssb [j]) ||
                                    (!cfg_reorder_data && !ssb[j])
                                )
                            )
                            // Set to '1' when there is a new TBp being loaded, with same-chip-bank-row with other existing TBP
                            // provided other TBP is valid and not precharged
                            // (INTER_BANK) make sure SSB of other TBP is not set, to handle row interrupt case
                            begin
                                wrt_combi[i][j] = 1'b1;
                            end
                        else if (flush_tbp[j])
                            begin
                                wrt_combi[i][j] = 1'b0;
                            end
                        else
                            begin
                                wrt_combi[i][j] = wrt[i][j];
                            end
                    end
            end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                        begin
                            wrt    [i] <= 0;
                            or_wrt [i] <= 1'b0;
                            nor_wrt[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                        begin
                            or_wrt [i] <=  |wrt_combi[i];
                            nor_wrt[i] <= ~|wrt_combi[i];
                            
                            for (j = 0;j < CFG_CTL_TBP_NUM;j = j + 1)
                                begin
                                    if (i == j)
                                        wrt[i][j] <= 1'b0;
                                    else
                                        wrt[i][j] <= wrt_combi[i][j];
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Require flush logic
    //----------------------------------------------------------------------------------------------------
    // On demand flush selection, command with same chip-bank-diff-row first, we dont want to precharge twice
    // if there are none, flush cmd to diff chip-bank, we might have cmd to the same row in tbp already
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            require_flush[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (CFG_CTL_TBP_NUM == 1)
                                begin
                                    require_flush[i] <= cmd_gen_load;
                                end
                            else
                                begin
                                    if (|flush_tbp) // tbp will not be full on the next clock cycle
                                        begin
                                            require_flush[i] <= 1'b0;
                                        end
                                    else if (int_tbp_full && cmd_gen_load)
                                        begin
                                            if (same_chip_bank_row[i])
                                                require_flush[i] <= 1'b0;
                                            else
                                                require_flush[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            require_flush[i] <= 1'b0;
                                        end
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Require precharge logic
    //----------------------------------------------------------------------------------------------------
    // Precharge request logic, to clear up lockup state in TBP
    always @(*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                        begin
                            if (CFG_DATA_REORDERING_TYPE == "INTER_BANK")
                                begin
                                    require_pch_combi[i][j] = zero;
                                end
                            else
                                begin
                                    if (i == j)
                                        begin
                                            require_pch_combi[i][j] = 1'b0;
                                        end
                                    else if (activated[i] && !done[i])
                                        begin
                                            if (cpv[i][j] && sbv[j][i])
                                                begin
                                                    require_pch_combi[i][j] = 1'b1;
                                                end
                                            else
                                                begin
                                                    require_pch_combi[i][j] = 1'b0;
                                                end
                                        end
                                    else
                                        begin
                                            require_pch_combi[i][j] = 1'b0;
                                        end
                                end
                        end
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            require_pch[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (flush_tbp[i])
                                begin
                                    require_pch[i] <= 1'b0;
                                end
                            else
                                begin
                                    // included real_ap since real_ap is part of precharge request (!apvc so that it will deassert pch_req when not needed)
                                    require_pch[i] <= |require_pch_combi[i] | (done[i] & real_ap[i] & !apvc_combi[i]);
                                end
                        end
                end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Address/command comparison logic
    //----------------------------------------------------------------------------------------------------
    // Command comparator
    always @ (*)
        begin
            if (CFG_DISABLE_READ_REODERING) // logic only enabled when parameter is set to '1'
                begin
                    same_command_read = cmd_gen_same_read_cmd;
                end
            else
                begin
                    same_command_read = {CFG_CTL_TBP_NUM{zero}};
                end
        end
    
    always @ (*)
        begin
            same_shadow_command_read = {CFG_CTL_SHADOW_TBP_NUM{zero}};
        end
    
    // Address comparator
    always @(*)
        begin
            same_chip_bank          = cmd_gen_same_chipsel_addr & cmd_gen_same_bank_addr;
            same_chip_bank_row      = cmd_gen_same_chipsel_addr & cmd_gen_same_bank_addr &  cmd_gen_same_row_addr;
            same_chip_bank_diff_row = cmd_gen_same_chipsel_addr & cmd_gen_same_bank_addr & ~cmd_gen_same_row_addr;
        end
    
    always @ (*)
        begin
            same_shadow_chip_bank          = cmd_gen_same_shadow_chipsel_addr & cmd_gen_same_shadow_bank_addr;
            same_shadow_chip_bank_row      = cmd_gen_same_shadow_chipsel_addr & cmd_gen_same_shadow_bank_addr &  cmd_gen_same_shadow_row_addr;
            same_shadow_chip_bank_diff_row = cmd_gen_same_shadow_chipsel_addr & cmd_gen_same_shadow_bank_addr & ~cmd_gen_same_shadow_row_addr;
        end
    
    // Registered version, to improve fMAX
    generate
        begin
            genvar i_tbp;
            genvar j_tbp;
            for (i_tbp = 0;i_tbp < CFG_CTL_TBP_NUM;i_tbp = i_tbp + 1)
                begin : i_compare_loop
                    for (j_tbp = 0;j_tbp < CFG_CTL_TBP_NUM;j_tbp = j_tbp + 1)
                        begin : j_compare_loop
                            always @ (posedge ctl_clk or negedge ctl_reset_n)
                                begin
                                    if (!ctl_reset_n)
                                        begin
                                            pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= 1'b0;
                                            pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= 1'b0;
                                            pre_calculated_same_chip_bank          [i_tbp][j_tbp] <= 1'b0;
                                        end
                                    else
                                        begin
                                            if (load_tbp [i_tbp])
                                                begin
                                                    pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= same_chip_bank_diff_row [j_tbp];
                                                    pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= same_chip_bank_row      [j_tbp];
                                                    pre_calculated_same_chip_bank          [i_tbp][j_tbp] <= same_chip_bank          [j_tbp];
                                                end
                                            else if (load_tbp [j_tbp])
                                                begin
                                                    if (chipsel [i_tbp] == cmd_gen_chipsel && bank [i_tbp] == cmd_gen_bank && row [i_tbp] != cmd_gen_row)
                                                        pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= 1'b1;
                                                    else
                                                        pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= 1'b0;
                                                    
                                                    if (chipsel [i_tbp] == cmd_gen_chipsel && bank [i_tbp] == cmd_gen_bank && row [i_tbp] == cmd_gen_row)
                                                        pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= 1'b1;
                                                    else
                                                        pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= 1'b0;
                                                    
                                                    if (chipsel [i_tbp] == cmd_gen_chipsel && bank [i_tbp] == cmd_gen_bank)
                                                        pre_calculated_same_chip_bank          [i_tbp][j_tbp] <= 1'b1;
                                                    else
                                                        pre_calculated_same_chip_bank          [i_tbp][j_tbp] <= 1'b0;
                                                end
                                            else if (chipsel [i_tbp] == chipsel [j_tbp] && bank [i_tbp] == bank [j_tbp])
                                                begin
                                                    if (row [i_tbp] != row [j_tbp])
                                                        begin
                                                            pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= 1'b1;
                                                            pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= 1'b0;
                                                        end
                                                    else
                                                        begin
                                                            pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= 1'b0;
                                                            pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= 1'b1;
                                                        end
                                                    
                                                    pre_calculated_same_chip_bank [i_tbp][j_tbp] <= 1'b1;
                                                end
                                            else
                                                begin
                                                    pre_calculated_same_chip_bank_diff_row [i_tbp][j_tbp] <= 1'b0;
                                                    pre_calculated_same_chip_bank_row      [i_tbp][j_tbp] <= 1'b0;
                                                    pre_calculated_same_chip_bank          [i_tbp][j_tbp] <= 1'b0;
                                                end
                                        end
                                end
                        end
                end
                
                for (i_tbp = 0;i_tbp < CFG_CTL_TBP_NUM;i_tbp = i_tbp + 1)
                begin : i_compare_loop_shadow
                    for (j_tbp = 0;j_tbp < CFG_CTL_SHADOW_TBP_NUM;j_tbp = j_tbp + 1)
                        begin : j_compare_loop_shadow
                            always @ (posedge ctl_clk or negedge ctl_reset_n)
                                begin
                                    if (!ctl_reset_n)
                                        begin
                                            pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= 1'b0;
                                        end
                                    else
                                        begin
                                            if (load_tbp [i_tbp])
                                                begin
                                                    if (push_tbp [j_tbp])
                                                        pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= same_chip_bank        [j_tbp];
                                                    else
                                                        pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= same_shadow_chip_bank [j_tbp];
                                                end
                                            else if (push_tbp [j_tbp])
                                                begin
                                                    if (chipsel [i_tbp] == chipsel [j_tbp] && bank [i_tbp] == bank [j_tbp])
                                                        pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= 1'b1;
                                                    else
                                                        pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= 1'b0;
                                                end
                                            else if (chipsel [i_tbp] == shadow_chipsel [j_tbp] && bank [i_tbp] == shadow_bank [j_tbp])
                                                begin
                                                    pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= 1'b1;
                                                end
                                            else
                                                begin
                                                    pre_calculated_same_shadow_chip_bank [i_tbp][j_tbp] <= 1'b0;
                                                end
                                        end
                                end
                        end
                end
        end
    endgenerate
    
    //----------------------------------------------------------------------------------------------------
    // Bank specific timer related logic
    //----------------------------------------------------------------------------------------------------
    // Offset timing paramter to achieve accurate timing gap between commands
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    compare_t_param_act_to_rdwr_less_than_offset    <= 0;
                    compare_t_param_act_to_act_less_than_offset     <= 0;
                    compare_t_param_act_to_pch_less_than_offset     <= 0;
                    compare_t_param_rd_to_pch_less_than_offset      <= 0;
                    compare_t_param_wr_to_pch_less_than_offset      <= 0;
                    compare_t_param_pch_to_valid_less_than_offset   <= 0;
                    compare_t_param_rd_ap_to_valid_less_than_offset <= 0;
                    compare_t_param_wr_ap_to_valid_less_than_offset <= 0;
                    
                    compare_offset_t_param_act_to_rdwr_less_than_0  <= 0;
                    compare_offset_t_param_act_to_rdwr_less_than_1  <= 0;
                end
            else
                begin
                    if (t_param_act_to_rdwr > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_act_to_rdwr_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_act_to_rdwr_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_act_to_act > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_act_to_act_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_act_to_act_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_act_to_pch > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_act_to_pch_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_act_to_pch_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_rd_to_pch > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_rd_to_pch_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_rd_to_pch_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_wr_to_pch > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_wr_to_pch_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_wr_to_pch_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_pch_to_valid > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_pch_to_valid_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_pch_to_valid_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_rd_ap_to_valid > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_rd_ap_to_valid_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_rd_ap_to_valid_less_than_offset <= 1'b1;
                        end
                    
                    if (t_param_wr_ap_to_valid > TBP_COUNTER_OFFSET)
                        begin
                            compare_t_param_wr_ap_to_valid_less_than_offset <= 1'b0;
                        end
                    else
                        begin
                            compare_t_param_wr_ap_to_valid_less_than_offset <= 1'b1;
                        end
                    
                    if (offset_t_param_act_to_rdwr <= 0)
                        begin
                            compare_offset_t_param_act_to_rdwr_less_than_0 <= 1'b1;
                        end
                    else
                        begin
                            compare_offset_t_param_act_to_rdwr_less_than_0 <= 1'b0;
                        end
                    
                    if (offset_t_param_act_to_rdwr <= 1)
                        begin
                            compare_offset_t_param_act_to_rdwr_less_than_1 <= 1'b1;
                        end
                    else
                        begin
                            compare_offset_t_param_act_to_rdwr_less_than_1 <= 1'b0;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    offset_t_param_act_to_rdwr    <= 0;
                    offset_t_param_act_to_act     <= 0;
                    offset_t_param_act_to_pch     <= 0;
                    offset_t_param_rd_to_pch      <= 0;
                    offset_t_param_wr_to_pch      <= 0;
                    offset_t_param_pch_to_valid   <= 0;
                    offset_t_param_rd_ap_to_valid <= 0;
                    offset_t_param_wr_ap_to_valid <= 0;
                end
            else
                begin
                    if (!compare_t_param_act_to_rdwr_less_than_offset)
                        begin
                            offset_t_param_act_to_rdwr <= t_param_act_to_rdwr - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_act_to_rdwr <= 0;
                        end
                    
                    if (!compare_t_param_act_to_act_less_than_offset)
                        begin
                            offset_t_param_act_to_act <= t_param_act_to_act - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_act_to_act <= 0;
                        end
                    
                    if (!compare_t_param_act_to_pch_less_than_offset)
                        begin
                            offset_t_param_act_to_pch <= t_param_act_to_pch - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_act_to_pch <= 0;
                        end
                    
                    if (!compare_t_param_rd_to_pch_less_than_offset)
                        begin
                            offset_t_param_rd_to_pch <= t_param_rd_to_pch - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_rd_to_pch <= 0;
                        end
                    
                    if (!compare_t_param_wr_to_pch_less_than_offset)
                        begin
                            offset_t_param_wr_to_pch <= t_param_wr_to_pch - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_wr_to_pch <= 0;
                        end
                    
                    if (!compare_t_param_pch_to_valid_less_than_offset)
                        begin
                            offset_t_param_pch_to_valid <= t_param_pch_to_valid - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_pch_to_valid <= 0;
                        end
                    
                    if (!compare_t_param_rd_ap_to_valid_less_than_offset)
                        begin
                            offset_t_param_rd_ap_to_valid <= t_param_rd_ap_to_valid - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_rd_ap_to_valid <= 0;
                        end
                    
                    if (!compare_t_param_wr_ap_to_valid_less_than_offset)
                        begin
                            offset_t_param_wr_ap_to_valid <= t_param_wr_ap_to_valid - TBP_COUNTER_OFFSET;
                        end
                    else
                        begin
                            offset_t_param_wr_ap_to_valid <= 0;
                        end
                end
        end
    
    // Pre-calculated logic to improve timing, for row_timer and trc_timer
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                            compare_t_param_rd_to_pch_greater_than_row_timer      [i] <= 1'b0;
                            compare_t_param_wr_to_pch_greater_than_row_timer      [i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (CFG_REG_GRANT == 0 && open_row_pass[i])
                                begin
                                    if (t_param_rd_ap_to_valid > ((trc_timer[log2_open_row_pass_flush[i]] > 1) ? (trc_timer[log2_open_row_pass_flush[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_wr_ap_to_valid > ((trc_timer[log2_open_row_pass_flush[i]] > 1) ? (trc_timer[log2_open_row_pass_flush[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_rd_to_pch > ((row_timer[log2_open_row_pass_flush[i]] > 1) ? (row_timer[log2_open_row_pass_flush[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_rd_to_pch_greater_than_row_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_rd_to_pch_greater_than_row_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_wr_to_pch > ((row_timer[log2_open_row_pass_flush[i]] > 1) ? (row_timer[log2_open_row_pass_flush[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_wr_to_pch_greater_than_row_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_wr_to_pch_greater_than_row_timer[i] <= 1'b0;
                                        end
                                end
                            else if (CFG_REG_GRANT == 1 && open_row_pass_r[i])
                                begin
                                    if (t_param_rd_ap_to_valid > ((trc_timer[log2_open_row_pass_flush_r[i]] > 1) ? (trc_timer[log2_open_row_pass_flush_r[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_wr_ap_to_valid > ((trc_timer[log2_open_row_pass_flush_r[i]] > 1) ? (trc_timer[log2_open_row_pass_flush_r[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_rd_to_pch > ((row_timer[log2_open_row_pass_flush_r[i]] > 1) ? (row_timer[log2_open_row_pass_flush_r[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_rd_to_pch_greater_than_row_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_rd_to_pch_greater_than_row_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_wr_to_pch > ((row_timer[log2_open_row_pass_flush_r[i]] > 1) ? (row_timer[log2_open_row_pass_flush_r[i]] - 1'b1) : 0))
                                        begin
                                            compare_t_param_wr_to_pch_greater_than_row_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_wr_to_pch_greater_than_row_timer[i] <= 1'b0;
                                        end
                                end
                            else
                                begin
                                    if (t_param_rd_ap_to_valid > ((trc_timer[i] > 1) ? (trc_timer[i] - 1'b1) : 0))
                                        begin
                                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_wr_ap_to_valid > ((trc_timer[i] > 1) ? (trc_timer[i] - 1'b1) : 0))
                                        begin
                                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_rd_to_pch > ((row_timer[i] > 1) ? (row_timer[i] - 1'b1) : 0))
                                        begin
                                            compare_t_param_rd_to_pch_greater_than_row_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_rd_to_pch_greater_than_row_timer[i] <= 1'b0;
                                        end
                                    
                                    if (t_param_wr_to_pch > ((row_timer[i] > 1) ? (row_timer[i] - 1'b1) : 0))
                                        begin
                                            compare_t_param_wr_to_pch_greater_than_row_timer[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            compare_t_param_wr_to_pch_greater_than_row_timer[i] <= 1'b0;
                                        end
                                end
                        end
                end
        end
    
    // Column timer logic
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        col_timer          [i] <= 0;
                        col_timer_ready    [i] <= 1'b0;
                        col_timer_pre_ready[i] <= 1'b0;
                    end
            else
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        if (row_grant[i])
                            begin
                                if (compare_t_param_act_to_rdwr_less_than_offset)
                                    begin
                                        col_timer          [i] <= 0;
                                        col_timer_ready    [i] <= 1'b1;
                                        col_timer_pre_ready[i] <= 1'b1;
                                    end
                                else
                                    begin
                                        col_timer          [i] <= offset_t_param_act_to_rdwr;
                                        
                                        if (compare_offset_t_param_act_to_rdwr_less_than_0)
                                            begin
                                                col_timer_ready    [i] <= 1'b1;
                                            end
                                        else
                                            begin
                                                col_timer_ready    [i] <= 1'b0;
                                            end
                                        
                                        if (compare_offset_t_param_act_to_rdwr_less_than_1)
                                            begin
                                                col_timer_pre_ready[i] <= 1'b1;
                                            end
                                        else
                                            begin
                                                col_timer_pre_ready[i] <= 1'b0;
                                            end
                                    end
                            end
                        else
                            begin
                                if (col_timer[i] != 0)
                                    begin
                                        col_timer[i] <= col_timer[i] - 1'b1;
                                    end
                                
                                if (col_timer[i] <= 1)
                                    begin
                                        col_timer_ready[i] <= 1'b1;
                                    end
                                else
                                    begin
                                        col_timer_ready[i] <= 1'b0;
                                    end
                                
                                if (col_timer[i] <= 2)
                                    begin
                                        col_timer_pre_ready[i] <= 1'b1;
                                    end
                                else
                                    begin
                                        col_timer_pre_ready[i] <= 1'b0;
                                    end
                            end
                    end
        end
    
    // log2 result of open-row-pass-flush, to be used during timer information pass
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    log2_open_row_pass_flush[i] = log2(open_row_pass_flush & wrt[i]);
                end
        end
    
    // Registered version
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            log2_open_row_pass_flush_r[i] <= 0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            log2_open_row_pass_flush_r[i] <= log2_open_row_pass_flush[i];
                        end
                end
        end
    
    // Row timer logic
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                begin
                    if (trc_timer[i] <= 1)
                        begin
                            trc_timer_pre_ready_combi[i] = 1'b1;
                        end
                    else
                        begin
                            trc_timer_pre_ready_combi[i] = 1'b0;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            trc_timer          [i] <= 0;
                            trc_timer_ready    [i] <= 1'b0;
                            trc_timer_pre_ready[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            // Reset row_timer after push
                            if (push_tbp[i])
                                begin
                                    trc_timer          [i] <= 0;
                                    trc_timer_ready    [i] <= 1'b1;
                                    trc_timer_pre_ready[i] <= 1'b1;
                                end
                            // We need to update the timer as soon as possible when CFG_REG_GRANT == 0
                            // because after open-row-pass, row grant can happen on the next clock cycle
                            else if
                                (
                                    (CFG_REG_GRANT == 0 && open_row_pass  [i]) ||
                                    (CFG_REG_GRANT == 1 && open_row_pass_r[i])
                                )
                                begin
                                    if (CFG_REG_GRANT == 0 && !trc_timer_pre_ready_combi[log2_open_row_pass_flush[i]])
                                        begin
                                            trc_timer          [i] <= trc_timer[log2_open_row_pass_flush[i]] - 1'b1;
                                            trc_timer_ready    [i] <= 1'b0;
                                            trc_timer_pre_ready[i] <= 1'b0;
                                        end
                                    else if (CFG_REG_GRANT == 1 && !trc_timer_pre_ready[log2_open_row_pass_flush_r[i]])
                                        begin
                                            trc_timer          [i] <= trc_timer[log2_open_row_pass_flush_r[i]] - 1'b1;
                                            trc_timer_ready    [i] <= 1'b0;
                                            trc_timer_pre_ready[i] <= 1'b0;
                                        end
                                    else
                                        begin
                                            trc_timer          [i] <= 0;
                                            trc_timer_ready    [i] <= 1'b1;
                                            trc_timer_pre_ready[i] <= 1'b1;
                                        end
                                end
                            else if (act_grant[i])
                                begin
                                    trc_timer          [i] <= offset_t_param_act_to_act;
                                    trc_timer_ready    [i] <= 1'b0;
                                    trc_timer_pre_ready[i] <= 1'b0;
                                end
                            else
                                begin
                                    if (trc_timer[i] != 0)
                                        begin
                                            trc_timer[i] <= trc_timer[i] - 1'b1;
                                        end
                                    
                                    if (trc_timer[i] <= 1)
                                        begin
                                            trc_timer_ready[i] <= 1'b1;
                                        end
                                    
                                    if (trc_timer[i] <= 2)
                                        begin
                                            trc_timer_pre_ready[i] <= 1'b1;
                                        end
                                end
                        end
                end
        end
    
    always @ (*)
        begin
            for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
            begin
                if (rd_grant[i])
                    begin
                        if (real_ap[i])
                            begin
                                if
                                    (
                                        (CFG_REG_GRANT == 1 && compare_t_param_rd_ap_to_valid_greater_than_trc_timer[i]) ||
                                        (CFG_REG_GRANT == 0 && t_param_rd_ap_to_valid > trc_timer[i])
                                    )
                                    begin
                                        row_timer_combi[i] = offset_t_param_rd_ap_to_valid;
                                    end
                                else
                                    begin
                                        row_timer_combi[i] = trc_timer[i] - 1'b1;
                                    end
                            end
                        else
                            begin
                                if
                                    (
                                        (CFG_REG_GRANT == 1 && compare_t_param_rd_to_pch_greater_than_row_timer[i]) ||
                                        (CFG_REG_GRANT == 0 && t_param_rd_to_pch > row_timer[i])
                                    )
                                    begin
                                        row_timer_combi[i] = offset_t_param_rd_to_pch;
                                    end
                                else
                                    begin
                                        row_timer_combi[i] = row_timer[i] - 1'b1;
                                    end
                            end
                    end
                else if (wr_grant[i])
                    begin
                        if (real_ap[i])
                            begin
                                if
                                    (
                                        (CFG_REG_GRANT == 1 && compare_t_param_wr_ap_to_valid_greater_than_trc_timer[i]) ||
                                        (CFG_REG_GRANT == 0 && t_param_wr_ap_to_valid > trc_timer[i])
                                    )
                                    begin
                                        row_timer_combi[i] = offset_t_param_wr_ap_to_valid;
                                    end
                                else
                                    begin
                                        row_timer_combi[i] = trc_timer[i] - 1'b1;
                                    end
                            end
                        else
                            begin
                                if
                                    (
                                        (CFG_REG_GRANT == 1 && compare_t_param_wr_to_pch_greater_than_row_timer[i]) ||
                                        (CFG_REG_GRANT == 0 && t_param_wr_to_pch > row_timer[i])
                                    )
                                    begin
                                        row_timer_combi[i] = offset_t_param_wr_to_pch;
                                    end
                                else
                                    begin
                                        row_timer_combi[i] = row_timer[i] - 1'b1;
                                    end
                            end
                    end
                else
                    begin
                        if (row_timer[i] != 0)
                            begin
                                row_timer_combi[i] = row_timer[i] - 1'b1;
                            end
                        else
                            begin
                                row_timer_combi[i] = 0;
                            end
                    end
            end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            row_timer          [i] <= 0;
                            row_timer_ready    [i] <= 1'b0;
                            row_timer_pre_ready[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            // Reset row_timer after push
                            if (push_tbp[i])
                                begin
                                    row_timer          [i] <= 0;
                                    row_timer_ready    [i] <= 1'b1;
                                    row_timer_pre_ready[i] <= 1'b1;
                                end
                            // We need to update the timer as soon as possible when CFG_REG_GRANT == 0
                            // because after open-row-pass, row grant can happen on the next clock cycle
                            else if
                                (
                                    (CFG_REG_GRANT == 0 && open_row_pass  [i]) ||
                                    (CFG_REG_GRANT == 1 && open_row_pass_r[i])
                                )
                                begin
                                    if (CFG_REG_GRANT == 0)
                                        begin
                                            row_timer          [i] <= row_timer_combi[log2_open_row_pass_flush[i]];
                                            row_timer_ready    [i] <= 1'b0;
                                            row_timer_pre_ready[i] <= 1'b0;
                                        end
                                    else if (CFG_REG_GRANT == 1 && !row_timer_pre_ready[log2_open_row_pass_flush_r[i]])
                                        begin
                                            row_timer          [i] <= row_timer[log2_open_row_pass_flush_r[i]] - 1'b1;
                                            row_timer_ready    [i] <= 1'b0;
                                            row_timer_pre_ready[i] <= 1'b0;
                                        end
                                    else
                                        begin
                                            row_timer          [i] <= 1'b0;
                                            row_timer_ready    [i] <= 1'b1;
                                            row_timer_pre_ready[i] <= 1'b1;
                                        end
                                end
                            else if (act_grant[i])
                                begin
                                    if (compare_t_param_act_to_pch_less_than_offset)
                                        begin
                                            row_timer          [i] <= 0;
                                            row_timer_ready    [i] <= 1'b1;
                                            row_timer_pre_ready[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            // Load tRAS after precharge command
                                            row_timer          [i] <= offset_t_param_act_to_pch;
                                            row_timer_ready    [i] <= 1'b0;
                                            row_timer_pre_ready[i] <= 1'b0;
                                        end
                                end
                            else if (pch_grant[i])
                                begin
                                    if (compare_t_param_pch_to_valid_less_than_offset)
                                        begin
                                            row_timer          [i] <= 0;
                                            row_timer_ready    [i] <= 1'b1;
                                            row_timer_pre_ready[i] <= 1'b1;
                                        end
                                    else
                                        begin
                                            // Load tRP after precharge command
                                            row_timer          [i] <= offset_t_param_pch_to_valid;
                                            row_timer_ready    [i] <= 1'b0;
                                            row_timer_pre_ready[i] <= 1'b0;
                                        end
                                end
                            else if (col_grant[i])
                                begin
                                     row_timer          [i] <= row_timer_combi[i];
                                     row_timer_ready    [i] <= 1'b0;
                                     row_timer_pre_ready[i] <= 1'b0;
                                end
                            else
                                begin
                                    if (row_timer[i] != 0)
                                        begin
                                            row_timer[i] <= row_timer[i] - 1'b1;
                                        end
                                    
                                    if (row_timer[i] <= 1)
                                        begin
                                            row_timer_ready[i] <= 1'b1;
                                        end
                                    
                                    if (row_timer[i] <= 2)
                                        begin
                                            row_timer_pre_ready[i] <= 1'b1;
                                        end
                                end
                        end
                end
        end
    
    // Logic to let precharge request logic that it is ready to request now
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            pch_ready[i] <= 1'b0;
                        end
                end
            else
                begin
                    for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                        begin
                            if (open_row_pass[i] || open_row_pass_r[i] || pch_grant[i] || col_grant[i])
                                // disable pch_ready after open-row-pass and grant
                                // since precharge is not needed immediately after TBP is loaded
                                begin
                                    pch_ready[i] <= 1'b0;
                                end
                            else if (row_timer_pre_ready[i])
                                begin
                                    pch_ready[i] <= 1'b1;
                                end
                            else
                                begin
                                    pch_ready[i] <= 1'b0;
                                end
                        end
                end
        end
    
    // Logic to let sideband know which chip contains active banks
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    int_bank_active[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (chipsel[j] == i && valid[j])
                                        begin
                                            if (sb_tbp_precharge_all[j])
                                                begin
                                                    int_bank_active[i][j] <= 1'b0;
                                                end
                                            else if (precharged_combi[j])
                                                begin
                                                    int_bank_active[i][j] <= 1'b0;
                                                end
                                            else if (activated_combi[j])
                                                begin
                                                    int_bank_active[i][j] <= 1'b1;
                                                end
                                        end
                                    else
                                        begin
                                            int_bank_active[i][j] <= 1'b0; // else default to '0'
                                        end
                                end
                        end
                end
        end
    
    // Logic to let sideband know which chip contains running timer
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    int_timer_ready[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                                begin
                                    if (chipsel[j] == i)
                                        begin
                                            if (col_grant[j] || row_grant[j])
                                                begin
                                                    int_timer_ready[i][j] <= 1'b0;
                                                end
                                            else if (trc_timer_pre_ready[j] && row_timer_pre_ready[j])
                                                begin
                                                    int_timer_ready[i][j] <= 1'b1;
                                                end
                                            else
                                                begin
                                                    int_timer_ready[i][j] <= 1'b0;
                                                end
                                        end
                                    else
                                        begin
                                            int_timer_ready[i][j] <= 1'b1; // else default to '1'
                                        end
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                                begin
                                    int_shadow_timer_ready[i][j] <= 1'b0;
                                end
                        end
                end
            else
                begin
                    for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
                        begin
                            for (j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                                begin
                                    if (CFG_ENABLE_SHADOW_TBP)
                                        begin
                                            if (shadow_chipsel[j] == i)
                                                begin
                                                    if (push_tbp[j])
                                                        begin
                                                            int_shadow_timer_ready[i][j] <= 1'b0;
                                                        end
                                                    else if (shadow_row_timer_pre_ready[j])
                                                        begin
                                                            int_shadow_timer_ready[i][j] <= 1'b1;
                                                        end
                                                    else
                                                        begin
                                                            int_shadow_timer_ready[i][j] <= 1'b0;
                                                        end
                                                end
                                            else
                                                begin
                                                    int_shadow_timer_ready[i][j] <= 1'b1; // else default to '1'
                                                end
                                        end
                                    else
                                        begin
                                            int_shadow_timer_ready[i][j] <= one;
                                        end
                                end
                        end
                end
        end
    
    always @ (*)
    begin
        for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
            begin
                bank_active[i] = |int_bank_active[i];
                timer_ready[i] = &{int_shadow_timer_ready[i], int_timer_ready[i]};
            end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Age logic
    //----------------------------------------------------------------------------------------------------
    // To tell the current age of each TBP entry
    // so that arbiter will be able to grant the oldest entry (if there is a tie-break)
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    age[i]  <=  0;
            else
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        for (j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                            begin
                                if (i == j)
                                    begin
                                        age[i][j]  <=  1'b0;
                                    end
                                else
                                    begin
                                        if (load_tbp[i])
                                            if (!flush_tbp[j] && (valid[j]))
                                                age[i][j]  <=  1'b1;
                                            else
                                                age[i][j]  <=  1'b0;
                                        else if (flush_tbp[j])
                                            age[i][j]  <=  1'b0;
                                    end
                            end
                    end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Starvation logic
    //----------------------------------------------------------------------------------------------------
    // Logic will increments when there is a col_grant to other TBP
    // will cause priority to be asserted when the count reaches starvation threshold
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    starvation[i]   <=  0;
            else
                for (i=0; i<CFG_CTL_TBP_NUM; i=i+1)
                    begin
                        if (load_tbp[i] || done[i]) // stop starvation count when the current TBP is done
                            starvation[i]   <=  0;
                        else if (|col_grant && starvation[i] < cfg_starve_limit)
                            starvation[i]   <=  starvation[i]+1'b1;
                    end
        end
    
    //----------------------------------------------------------------------------------------------------
    // Burst chop logic
    //----------------------------------------------------------------------------------------------------
    // Logic to determine whether we will issue burst chop in DDR3 mode only
    generate
        begin
            if (CFG_DWIDTH_RATIO == 2)
                begin
                    always @ (posedge ctl_clk or negedge ctl_reset_n)
                        begin
                            if (!ctl_reset_n)
                                begin
                                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                                        begin
                                            burst_chop [i] <= 1'b0;
                                        end
                                end
                            else
                                begin
                                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                                        begin
                                            if (cfg_type == `MMR_TYPE_DDR3)
                                                begin
                                                    if (load_tbp [i])
                                                        begin
                                                            if (cmd_gen_size <= 2'd2 && cmd_gen_col [(CFG_DWIDTH_RATIO / 2)] == 1'b0)
                                                                burst_chop [i] <= 1'b1;
                                                            else if (cmd_gen_size == 1'b1)
                                                                burst_chop [i] <= 1'b1;
                                                            else
                                                                burst_chop [i] <= 1'b0;
                                                        end
                                                end
                                            else
                                                begin
                                                    burst_chop [i] <= 1'b0;
                                                end
                                        end
                                end
                        end
                end
            else if (CFG_DWIDTH_RATIO == 4)
                begin
                    always @ (posedge ctl_clk or negedge ctl_reset_n)
                        begin
                            if (!ctl_reset_n)
                                begin
                                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                                        begin
                                            burst_chop [i] <= 1'b0;
                                        end
                                end
                            else
                                begin
                                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                                        begin
                                            if (cfg_type == `MMR_TYPE_DDR3)
                                                begin
                                                    if (load_tbp [i])
                                                        begin
                                                            if (cmd_gen_size == 1'b1)
                                                                burst_chop [i] <= 1'b1;
                                                            else
                                                                burst_chop [i] <= 1'b0;
                                                        end
                                                end
                                            else
                                                begin
                                                    burst_chop [i] <= 1'b0;
                                                end
                                        end
                                end
                        end
                end
            else if (CFG_DWIDTH_RATIO == 8)
                begin
                    // Burst chop is not available in quarter rate
                    always @ (posedge ctl_clk or negedge ctl_reset_n)
                        begin
                            if (!ctl_reset_n)
                                begin
                                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                                        begin
                                            burst_chop [i] <= 1'b0;
                                        end
                                end
                            else
                                begin
                                    for (i = 0;i < CFG_CTL_TBP_NUM;i = i + 1)
                                        begin
                                            burst_chop [i] <= 1'b0;
                                        end
                                end
                        end
                end
        end
    endgenerate
    
    //----------------------------------------------------------------------------------------------------------------
    
    function integer log2;
        input [31:0] value;
        integer      i;
        begin
            log2 = 0;
            
            for(i = 0; 2**i < value; i = i + 1)
                begin
                    log2 = i + 1;
                end
        end
    endfunction
    
endmodule
