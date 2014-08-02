
//altera message_off 10230

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_sideband
    # (parameter
    
        // parameters
        CFG_PORT_WIDTH_TYPE                     =   3,
        CFG_DWIDTH_RATIO                        =   2, //2-FR,4-HR,8-QR
        CFG_REG_GRANT                           =   1,
        CFG_CTL_TBP_NUM                         =   4,
        CFG_MEM_IF_CS_WIDTH                     =   1,
        CFG_MEM_IF_CHIP                         =   1, // one hot
        CFG_MEM_IF_BA_WIDTH                     =   3,
        CFG_PORT_WIDTH_TCL                      =   4,
        CFG_MEM_IF_CLK_PAIR_COUNT               =   2,
        CFG_RANK_TIMER_OUTPUT_REG               =   0,
        T_PARAM_ARF_TO_VALID_WIDTH              =   10,
        T_PARAM_ARF_PERIOD_WIDTH                =   13,
        T_PARAM_PCH_ALL_TO_VALID_WIDTH          =   10,
        T_PARAM_SRF_TO_VALID_WIDTH              =   10,
        T_PARAM_SRF_TO_ZQ_CAL_WIDTH             =   10,
        T_PARAM_PDN_TO_VALID_WIDTH              =   6,
        BANK_TIMER_COUNTER_OFFSET               =   2, //used to be 4
        T_PARAM_PDN_PERIOD_WIDTH                =   16,// temporary
        T_PARAM_POWER_SAVING_EXIT_WIDTH         =   6
    )
    (
    
        ctl_clk,
        ctl_reset_n,
        
        // local interface
        rfsh_req,
        rfsh_chip,
        rfsh_ack,
        self_rfsh_req,
        self_rfsh_chip,
        self_rfsh_ack,
        deep_powerdn_req,
        deep_powerdn_chip,
        deep_powerdn_ack,
        power_down_ack,
        
        // sideband output
        stall_row_arbiter,
        stall_col_arbiter,
        stall_chip,
        sb_do_precharge_all,
        sb_do_refresh,
        sb_do_self_refresh,
        sb_do_power_down,
        sb_do_deep_pdown,
        sb_do_zq_cal,
        sb_tbp_precharge_all,
        
        // PHY interface
        ctl_mem_clk_disable,
        ctl_init_req,
        ctl_cal_success,
        
        // tbp & cmd gen
        cmd_gen_chipsel,
        tbp_chipsel,
        tbp_load,
        
        // timing
        t_param_arf_to_valid,
        t_param_arf_period,
        t_param_pch_all_to_valid,
        t_param_srf_to_valid,
        t_param_srf_to_zq_cal,
        t_param_pdn_to_valid,
        t_param_pdn_period,
        t_param_power_saving_exit,
        
        // block status
        tbp_empty,
        tbp_bank_active,
        tbp_timer_ready,
        row_grant,
        col_grant,
        
        // dqs tracking
        afi_ctl_refresh_done,
        afi_seq_busy,
        afi_ctl_long_idle,
        
        // config ports
        cfg_enable_dqs_tracking,
        cfg_user_rfsh,
        cfg_type,
        cfg_tcl,
        cfg_regdimm_enable
        
    );
    
    // states for our DQS bus monitor state machine
    localparam IDLE  = 32'h49444C45;
    localparam ARF   = 32'h20415246;
    localparam PDN   = 32'h2050444E;
    localparam SRF   = 32'h20535246;
    
    localparam INIT         = 32'h696e6974;
    localparam PCHALL       = 32'h70636861;
    localparam REFRESH      = 32'h72667368;
    localparam PDOWN        = 32'h7064776e;
    localparam SELFRFSH     = 32'h736c7266;
    localparam DEEPPDN      = 32'h64656570;
    localparam ZQCAL        = 32'h7a63616c;
    localparam DQSTRK       = 32'h6471746b;
    localparam DQSLONG      = 32'h64716c6e;
    
    localparam POWER_SAVING_COUNTER_WIDTH      = T_PARAM_SRF_TO_VALID_WIDTH;
    localparam POWER_SAVING_EXIT_COUNTER_WIDTH = T_PARAM_POWER_SAVING_EXIT_WIDTH;
    localparam ARF_COUNTER_WIDTH               = T_PARAM_ARF_PERIOD_WIDTH;
    localparam PDN_COUNTER_WIDTH               = T_PARAM_PDN_PERIOD_WIDTH;
    
    localparam integer CFG_MEM_IF_BA_WIDTH_SQRD = 2**CFG_MEM_IF_BA_WIDTH;
    localparam integer CFG_PORT_WIDTH_TCL_SQRD = 2**CFG_PORT_WIDTH_TCL;
    
    input   ctl_clk;
    input   ctl_reset_n;
    
    input                           rfsh_req;
    input   [CFG_MEM_IF_CHIP-1:0]   rfsh_chip;
    output                          rfsh_ack;
    input                           self_rfsh_req;
    input   [CFG_MEM_IF_CHIP-1:0]   self_rfsh_chip;
    output                          self_rfsh_ack;
    input                           deep_powerdn_req;
    input   [CFG_MEM_IF_CHIP-1:0]   deep_powerdn_chip;
    output                          deep_powerdn_ack;
    output                          power_down_ack;
    
    output                          stall_row_arbiter;
    output                          stall_col_arbiter;
    output  [CFG_MEM_IF_CHIP-1:0]   stall_chip;
    output  [CFG_MEM_IF_CHIP-1:0]   sb_do_precharge_all;
    output  [CFG_MEM_IF_CHIP-1:0]   sb_do_refresh;
    output  [CFG_MEM_IF_CHIP-1:0]   sb_do_self_refresh;
    output  [CFG_MEM_IF_CHIP-1:0]   sb_do_power_down;
    output  [CFG_MEM_IF_CHIP-1:0]   sb_do_deep_pdown;
    output  [CFG_MEM_IF_CHIP-1:0]   sb_do_zq_cal;
    output  [CFG_CTL_TBP_NUM-1:0]   sb_tbp_precharge_all;
    
    output  [CFG_MEM_IF_CLK_PAIR_COUNT-1:0] ctl_mem_clk_disable;
    output                                  ctl_init_req;
    input                                   ctl_cal_success;
    
    input   [CFG_MEM_IF_CS_WIDTH-1:0]                   cmd_gen_chipsel;
    input   [(CFG_CTL_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0] tbp_chipsel;
    input   [CFG_CTL_TBP_NUM-1:0]                       tbp_load;
    
    input   [T_PARAM_ARF_TO_VALID_WIDTH         - 1 : 0] t_param_arf_to_valid;
    input   [T_PARAM_ARF_PERIOD_WIDTH           - 1 : 0] t_param_arf_period;
    input   [T_PARAM_PCH_ALL_TO_VALID_WIDTH     - 1 : 0] t_param_pch_all_to_valid;
    input   [T_PARAM_SRF_TO_VALID_WIDTH         - 1 : 0] t_param_srf_to_valid;
    input   [T_PARAM_SRF_TO_ZQ_CAL_WIDTH        - 1 : 0] t_param_srf_to_zq_cal;
    input   [T_PARAM_PDN_TO_VALID_WIDTH         - 1 : 0] t_param_pdn_to_valid;
    input   [T_PARAM_PDN_PERIOD_WIDTH           - 1 : 0] t_param_pdn_period;
    input   [T_PARAM_POWER_SAVING_EXIT_WIDTH    - 1 : 0] t_param_power_saving_exit;
    
    input   tbp_empty;
    input   [CFG_MEM_IF_CHIP-1:0] tbp_bank_active;
    input   [CFG_MEM_IF_CHIP-1:0] tbp_timer_ready;
    input   row_grant;
    input   col_grant;
    
    output  [CFG_MEM_IF_CHIP-1:0] afi_ctl_refresh_done;
    input   [CFG_MEM_IF_CHIP-1:0] afi_seq_busy;
    output  [CFG_MEM_IF_CHIP-1:0] afi_ctl_long_idle;
    
    input   cfg_enable_dqs_tracking;
    input                       cfg_user_rfsh;
    input   [CFG_PORT_WIDTH_TYPE - 1 : 0] cfg_type;
    input   [CFG_PORT_WIDTH_TCL - 1 : 0] cfg_tcl;
    input   cfg_regdimm_enable;
    
    // end of port declaration
    
    wire    self_rfsh_ack;
    wire    deep_powerdn_ack;
    wire    power_down_ack;
    
    wire [CFG_MEM_IF_CLK_PAIR_COUNT-1:0] ctl_mem_clk_disable;
    wire                                 ctl_init_req;
    
    reg  [CFG_MEM_IF_CHIP-1:0] sb_do_precharge_all;
    reg  [CFG_MEM_IF_CHIP-1:0] sb_do_refresh;
    reg  [CFG_MEM_IF_CHIP-1:0] sb_do_self_refresh;
    reg  [CFG_MEM_IF_CHIP-1:0] sb_do_power_down;
    reg  [CFG_MEM_IF_CHIP-1:0] sb_do_deep_pdown;
    reg  [CFG_MEM_IF_CHIP-1:0] sb_do_zq_cal;
    reg  [CFG_CTL_TBP_NUM-1:0] sb_tbp_precharge_all;
    
    reg     [CFG_MEM_IF_CHIP-1:0]       do_refresh;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_power_down;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_deep_pdown;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_self_rfsh;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_self_rfsh_r;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_precharge_all;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_zqcal;
    reg     [CFG_MEM_IF_CHIP-1:0]       stall_chip;
    reg     [CFG_MEM_IF_CHIP-1:0]       int_stall_chip;
    reg     [CFG_MEM_IF_CHIP-1:0]       int_stall_chip_combi;
    reg     [CFG_MEM_IF_CHIP-1:0]       stall_arbiter;
    reg     [CFG_MEM_IF_CHIP-1:0]       afi_ctl_refresh_done;
    reg     [CFG_MEM_IF_CHIP-1:0]       afi_ctl_long_idle;
    reg     [CFG_MEM_IF_CHIP-1:0]       dqstrk_exit;
    reg     [CFG_MEM_IF_CHIP-1:0]       dqslong_exit;
    reg     [CFG_MEM_IF_CHIP-1:0]       doing_zqcal;
    
    reg     [CFG_MEM_IF_CHIP-1:0]   refresh_chip_req;
    reg     [CFG_MEM_IF_CHIP-1:0]   self_refresh_chip_req;
    reg                             self_rfsh_req_r;
    reg     [CFG_MEM_IF_CHIP-1:0]   deep_pdown_chip_req;
    reg     [CFG_MEM_IF_CHIP-1:0]   power_down_chip_req;
    wire    [CFG_MEM_IF_CHIP-1:0]   power_down_chip_req_combi;
    
    wire    [CFG_MEM_IF_CHIP-1:0]   all_banks_closed;
    wire    [CFG_MEM_IF_CHIP-1:0]   tcom_not_running;
    reg     [CFG_PORT_WIDTH_TCL_SQRD-1:0] tcom_not_running_pipe [CFG_MEM_IF_CHIP-1:0];
    reg     [CFG_MEM_IF_CHIP-1:0]   can_refresh;
    reg     [CFG_MEM_IF_CHIP-1:0]   can_self_rfsh;
    reg     [CFG_MEM_IF_CHIP-1:0]   can_deep_pdown;
    reg     [CFG_MEM_IF_CHIP-1:0]   can_power_down;
    reg     [CFG_MEM_IF_CHIP-1:0]   can_exit_power_saving_mode;
    reg     [CFG_MEM_IF_CHIP-1:0]   cs_refresh_req;
    wire    grant;
    wire    [CFG_MEM_IF_CHIP-1:0]   cs_zq_cal_req;
    wire    [CFG_MEM_IF_CHIP-1:0]   power_saving_enter_ready;
    wire    [CFG_MEM_IF_CHIP-1:0]   power_saving_exit_ready;
    reg     [PDN_COUNTER_WIDTH  - 1 : 0] power_down_cnt;
    reg                             no_command_r1;
    reg     [CFG_MEM_IF_CHIP-1:0]   afi_seq_busy_r; // synchronizer
    reg     [CFG_MEM_IF_CHIP-1:0]   afi_seq_busy_r2; // synchronizer
    
    //new! to avoid contention
    reg     [CFG_MEM_IF_CHIP-1:0]       do_refresh_req;
    reg                                 refresh_req_ack;
    reg                                 dummy_do_refresh;
    reg                                 dummy_do_refresh_r;
    reg                                 do_refresh_r;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_self_rfsh_req;
    reg                                 self_rfsh_req_ack;
    reg                                 dummy_do_self_rfsh;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_zqcal_req;
    reg                                 zqcal_req_ack;
    reg                                 dummy_do_zqcal;
    reg     [CFG_MEM_IF_CHIP-1:0]       do_pch_all_req;
    reg                                 pch_all_req_ack;
    reg                                 dummy_do_pch_all;
    
    integer i;
    
    assign ctl_mem_clk_disable = {CFG_MEM_IF_CLK_PAIR_COUNT{1'b0}};
    
    //generate *_chip_ok signals by checking can_*[chip], only when for_chip[chip] is 1   
    generate
        genvar chip;
        for (chip = 0; chip < CFG_MEM_IF_CHIP; chip = chip + 1)
        begin : gen_chip_ok
            // check can_* only for chips that we'd like to precharge_all to, ^~ is XNOR
            assign tcom_not_running[chip] =  tbp_timer_ready[chip];
            assign all_banks_closed[chip] = ~tbp_bank_active[chip];
            
            always @(posedge ctl_clk, negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                        begin
                            tcom_not_running_pipe[chip] <=  0;
                        end
                    else
                        begin
                            if (!tcom_not_running[chip])
                                tcom_not_running_pipe[chip] <=  0;
                            else
                                tcom_not_running_pipe[chip] <=  {tcom_not_running_pipe[chip][CFG_PORT_WIDTH_TCL_SQRD -2 :0],tcom_not_running[chip]};
                        end
                end
        end
    endgenerate
    
    assign  rfsh_ack   =   (!(cfg_regdimm_enable && cfg_type == `MMR_TYPE_DDR3 && CFG_MEM_IF_CHIP != 1)) ? |do_refresh : ((|do_refresh | do_refresh_r) & refresh_req_ack);
    assign  self_rfsh_ack =   |do_self_rfsh;
    assign  deep_powerdn_ack = |do_deep_pdown;
    assign  power_down_ack =   |do_power_down;
    
    // Register sideband signals when CFG_REG_GRANT is '1'
    // to prevent sideband request going out on the same cycle as tbp request
    generate
    begin
        genvar j;
        if (CFG_REG_GRANT == 1)
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    sb_do_precharge_all  <= 0;
                    sb_do_refresh        <= 0;
                    sb_do_self_refresh   <= 0;
                    sb_do_power_down     <= 0;
                    sb_do_deep_pdown     <= 0;
                    sb_do_zq_cal         <= 0;
                end
                else
                begin
                    sb_do_precharge_all  <= do_precharge_all;
                    sb_do_refresh        <= do_refresh;
                    sb_do_self_refresh   <= do_self_rfsh;
                    sb_do_power_down     <= do_power_down;
                    sb_do_deep_pdown     <= do_deep_pdown;
                    sb_do_zq_cal         <= do_zqcal;
                end
            end
            
            for (j = 0;j < CFG_CTL_TBP_NUM;j = j + 1)
            begin : tbp_loop_1
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        sb_tbp_precharge_all [j] <= 1'b0;
                    end
                    else
                    begin
                        if (tbp_load[j])
                        begin
                            sb_tbp_precharge_all [j] <= do_precharge_all [cmd_gen_chipsel];
                        end
                        else
                        begin
                            sb_tbp_precharge_all [j] <= do_precharge_all [tbp_chipsel [(j + 1) * CFG_MEM_IF_CS_WIDTH - 1 : j * CFG_MEM_IF_CS_WIDTH]];
                        end
                    end
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                sb_do_precharge_all = do_precharge_all;
                sb_do_refresh       = do_refresh;
                sb_do_self_refresh  = do_self_rfsh;
                sb_do_power_down    = do_power_down;
                sb_do_deep_pdown    = do_deep_pdown;
                sb_do_zq_cal        = do_zqcal;
            end
            
            for (j = 0;j < CFG_CTL_TBP_NUM;j = j + 1)
            begin : tbp_loop_2
                always @ (*)
                begin
                    sb_tbp_precharge_all [j] = do_precharge_all [tbp_chipsel [(j + 1) * CFG_MEM_IF_CS_WIDTH - 1 : j * CFG_MEM_IF_CS_WIDTH]];
                end
            end
        end
    end
    endgenerate
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    refresh_req_ack    <=  0;
                    zqcal_req_ack      <=  0;
                    pch_all_req_ack    <=  0;
                    self_rfsh_req_ack  <=  0;
                    dummy_do_refresh_r <=  dummy_do_refresh;
                    do_refresh_r       <=  0;
                end
            else
                begin
                    refresh_req_ack    <=  dummy_do_refresh;
                    zqcal_req_ack      <=  dummy_do_zqcal;
                    pch_all_req_ack    <=  dummy_do_pch_all;
                    self_rfsh_req_ack  <=  dummy_do_self_rfsh;
                    dummy_do_refresh_r <=  dummy_do_refresh;
                    if (dummy_do_refresh && !dummy_do_refresh_r)
                        do_refresh_r   <=  |do_refresh;
                    else
                        do_refresh_r   <=  0;
                end
        end
    
    always @(*)
        begin

            i = 0;
            dummy_do_refresh =  0;
            dummy_do_pch_all =  0;
            dummy_do_zqcal   =  0;

            if (|do_refresh_req)
                begin
                    if (!(cfg_regdimm_enable && cfg_type == `MMR_TYPE_DDR3 && CFG_MEM_IF_CHIP != 1)) // if not (regdimm and DDR3), normal refresh
                        do_refresh          =  do_refresh_req;
                    else
                        begin
                            for (i = 0;i < CFG_MEM_IF_CHIP;i = i + 1)
                                begin
                                    if (i%2 == 0)
                                        begin
                                            do_refresh[i]   =  do_refresh_req[i];
                                            dummy_do_refresh=  |do_refresh_req;
                                        end
                                    else if (i%2 == 1 && refresh_req_ack)
                                        do_refresh[i]   =  do_refresh_req[i];
                                    else
                                        do_refresh[i]   =  0;
                                end
                        end
                    do_precharge_all    =  0;
                    do_zqcal            =  0;
                end
            else if (|do_pch_all_req)
                begin
                    do_refresh          =  0;
                    if (!(cfg_regdimm_enable && cfg_type == `MMR_TYPE_DDR3 && CFG_MEM_IF_CHIP != 1))
                        do_precharge_all    =  do_pch_all_req;
                    else
                        begin
                            for (i = 0;i < CFG_MEM_IF_CHIP;i = i + 1)
                                begin
                                    if (i%2 == 0)
                                        begin
                                            do_precharge_all[i]   =  do_pch_all_req[i];
                                            dummy_do_pch_all      =  |do_pch_all_req;
                                        end
                                    else if (i%2 == 1 && pch_all_req_ack)
                                        do_precharge_all[i]   =  do_pch_all_req[i];
                                    else
                                        do_precharge_all[i]   =  0;
                                end
                        end
                    do_zqcal            =  0;
                end
            else if (|do_zqcal_req)
                begin
                    do_refresh          =  0;
                    do_precharge_all    =  0;
                    if (!(cfg_regdimm_enable && cfg_type == `MMR_TYPE_DDR3 && CFG_MEM_IF_CHIP != 1))
                        do_zqcal            =  do_zqcal_req;
                    else
                        begin
                            for (i = 0;i < CFG_MEM_IF_CHIP;i = i + 1)
                                begin
                                    if (i%2 == 0)
                                        begin
                                            do_zqcal[i]   =  do_zqcal_req[i];
                                            dummy_do_zqcal=  |do_zqcal_req;
                                        end
                                    else if (i%2 == 1 && zqcal_req_ack)
                                        do_zqcal[i]   =  do_zqcal_req[i];
                                    else
                                        do_zqcal[i]   =  0;
                                end
                        end
                end
            else
                begin
                    do_refresh          =  0;
                    dummy_do_refresh    =  0;
                    do_precharge_all    =  0;
                    dummy_do_pch_all    =  0;
                    do_zqcal            =  0;
                    dummy_do_zqcal      =  0;
                end
        end
    
    always @(*)
        begin
            i = 0;
            dummy_do_self_rfsh  =  1'b0;

            if (|do_refresh || |do_precharge_all || |do_zqcal)
                begin
                    if (|do_self_rfsh_r)
                        begin
                            do_self_rfsh    =  do_self_rfsh_req;
                            dummy_do_self_rfsh  =   1'b1;
                        end
                    else
                        do_self_rfsh    =  0;
                end
            else
                begin
                    if (!(cfg_regdimm_enable && cfg_type == `MMR_TYPE_DDR3 && CFG_MEM_IF_CHIP != 1))
                        do_self_rfsh    =  do_self_rfsh_req;
                    else
                        begin
                            for (i = 0;i < CFG_MEM_IF_CHIP;i = i + 1)
                                begin
                                    if (i%2 == 0)
                                        begin
                                            do_self_rfsh[i]   =  do_self_rfsh_req[i];
                                            dummy_do_self_rfsh=  |do_self_rfsh_req;
                                        end
                                    else if (i%2 == 1 && self_rfsh_req_ack)
                                        do_self_rfsh[i]   =  do_self_rfsh_req[i];
                                    else
                                        do_self_rfsh[i]   =  0;
                                end
                        end
                end
        end
    
    assign  stall_row_arbiter   =   |stall_arbiter;
    assign  stall_col_arbiter   =   |stall_arbiter;
    
    assign  grant   =   (CFG_REG_GRANT == 1) ? (row_grant | col_grant) : 1'b0;
    
    //register self_rfsh_req and deep_powerdn_req
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    self_refresh_chip_req   <=  0;
                    deep_pdown_chip_req     <=  0;
                    self_rfsh_req_r         <=  0;
                    do_self_rfsh_r          <=  0;
                end
            else
                begin
                    if (self_rfsh_req)
                        self_refresh_chip_req   <=  self_rfsh_chip;
                    else
                        self_refresh_chip_req   <=  0;
                    
                    self_rfsh_req_r <=  self_rfsh_req & |self_rfsh_chip;
                    do_self_rfsh_r  <=  do_self_rfsh;
                    
                    if (deep_powerdn_req)
                        deep_pdown_chip_req     <=  deep_powerdn_chip;
                    else
                        deep_pdown_chip_req     <=  0;
                end
        end
    
    //combi user refresh
    always @(*)
        begin
            if (cfg_user_rfsh)
                begin
                    if (rfsh_req)
                        refresh_chip_req    =  rfsh_chip;
                    else
                        refresh_chip_req    =  0;
                end
            else
                refresh_chip_req    =  cs_refresh_req;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    afi_seq_busy_r  <=  0;
                    afi_seq_busy_r2 <=  0;
                end
            else
                begin
                    afi_seq_busy_r  <=  afi_seq_busy;
                    afi_seq_busy_r2 <=  afi_seq_busy_r;
                end
        end
    
    // cans
    generate
        genvar w_cs;
        for (w_cs = 0;w_cs < CFG_MEM_IF_CHIP;w_cs = w_cs + 1)
        begin : can_signal_per_chip

            // Can refresh signal for each rank
            always @ (*)
            begin
                can_refresh [w_cs] = power_saving_enter_ready [w_cs] & all_banks_closed[w_cs] & tcom_not_running[w_cs] & ~grant;
            end
            
            // Can self refresh signal for each rank
            always @ (*)
            begin
                can_self_rfsh [w_cs] = power_saving_enter_ready [w_cs] & all_banks_closed[w_cs] & tcom_not_running[w_cs] & tcom_not_running_pipe[w_cs][cfg_tcl] & ~grant;
            end
            
            always @ (*)
            begin
                can_deep_pdown [w_cs] = power_saving_enter_ready [w_cs] & all_banks_closed[w_cs] & tcom_not_running[w_cs] & ~grant;
            end
            
            // Can power down signal for each rank
            always @ (*)
            begin
                can_power_down [w_cs] = power_saving_enter_ready [w_cs] & all_banks_closed[w_cs] & tcom_not_running[w_cs] & tcom_not_running_pipe[w_cs][cfg_tcl] & ~grant;
            end
            
            // Can exit power saving mode signal for each rank
            always @ (*)
            begin
                can_exit_power_saving_mode [w_cs] = power_saving_exit_ready [w_cs];
            end
        end
    endgenerate
    
/*------------------------------------------------------------------------------

    [START] Power Saving Rank Monitor

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Power Saving State Machine
    ------------------------------------------------------------------------------*/
    generate
        genvar u_cs;
        for (u_cs = 0;u_cs < CFG_MEM_IF_CHIP;u_cs = u_cs + 1)
        begin : power_saving_logic_per_chip
            reg  [POWER_SAVING_COUNTER_WIDTH      - 1 : 0] power_saving_cnt;
            reg  [POWER_SAVING_EXIT_COUNTER_WIDTH - 1 : 0] power_saving_exit_cnt;
            reg  [31                                  : 0] state;
            reg  [31                                  : 0] sideband_state;
            reg                                            int_enter_power_saving_ready;
            reg                                            int_exit_power_saving_ready;
            reg                                            registered_reset;
            reg                                            int_zq_cal_req;
            reg                                            int_do_power_down;
            reg                                            int_do_power_down_r1;
            reg                                            int_do_power_down_r2;
            reg                                            int_do_self_refresh;
            reg                                            int_do_self_refresh_r1;
            reg                                            int_do_self_refresh_r2;
            reg                                            int_do_self_refresh_r3;
            
            // assignment
            assign power_saving_enter_ready [u_cs] = int_enter_power_saving_ready;
            assign power_saving_exit_ready  [u_cs] = int_exit_power_saving_ready & ~((int_do_power_down & ~int_do_power_down_r1) | (int_do_self_refresh & ~int_do_self_refresh_r1));
            
            assign cs_zq_cal_req            [u_cs] = int_zq_cal_req;
            
            // counter for power saving state machine
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    power_saving_cnt <= 0;
                else
                begin
                    if (do_precharge_all[u_cs] || do_refresh[u_cs] || do_self_rfsh[u_cs] || do_power_down[u_cs])
                        power_saving_cnt <= BANK_TIMER_COUNTER_OFFSET;
                    else if (power_saving_cnt != {POWER_SAVING_COUNTER_WIDTH{1'b1}})
                        power_saving_cnt <= power_saving_cnt + 1'b1;
                end
            end
            
            // Do power down and self refresh register
            always @ (*)
            begin
                int_do_power_down = do_power_down[u_cs];
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    begin
                        int_do_power_down_r1 <= 1'b0;
                        int_do_power_down_r2 <= 1'b0;
                    end
                else
                    begin
                        int_do_power_down_r1 <= int_do_power_down;
                        int_do_power_down_r2 <= int_do_power_down_r1;
                    end
            end
            
            always @ (*)
            begin
                int_do_self_refresh = do_self_rfsh[u_cs];
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    begin
                        int_do_self_refresh_r1 <= 1'b0;
                        int_do_self_refresh_r2 <= 1'b0;
                        int_do_self_refresh_r3 <= 1'b0;
                    end
                else
                    begin
                        int_do_self_refresh_r1 <= int_do_self_refresh;
                        int_do_self_refresh_r2 <= int_do_self_refresh_r1;
                        int_do_self_refresh_r3 <= int_do_self_refresh_r2;
                    end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    power_saving_exit_cnt <= 0;
                end
                else
                begin
                    if ((int_do_power_down & !int_do_power_down_r1) || (int_do_self_refresh & !int_do_self_refresh_r1))
                    begin
                        power_saving_exit_cnt <= BANK_TIMER_COUNTER_OFFSET;
                    end
                    else if (power_saving_exit_cnt != {POWER_SAVING_EXIT_COUNTER_WIDTH{1'b1}})
                    begin
                        power_saving_exit_cnt = power_saving_exit_cnt + 1'b1;
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_exit_power_saving_ready <= 1'b0;
                end
                else
                begin
                    if (( int_do_power_down) && (!int_do_power_down_r1)) // positive edge detector but late by one clock cycle
                    begin
                        int_exit_power_saving_ready <= 1'b0;
                    end
                    else if (( int_do_self_refresh ) && (!int_do_self_refresh_r1 )) // positive edge detector
                    begin
                        int_exit_power_saving_ready <= 1'b0;
                    end
                    else if (power_saving_exit_cnt >= t_param_power_saving_exit)
                    begin
                        int_exit_power_saving_ready <= 1'b1;
                    end
                    else
                    begin
                        int_exit_power_saving_ready <= 1'b0;
                    end
                end
            end
            
            // stall_chip output signal
            always @ (*)
                begin
                    if (CFG_RANK_TIMER_OUTPUT_REG)
                        begin
                            stall_chip[u_cs] = int_stall_chip[u_cs] | int_stall_chip_combi[u_cs];
                        end
                    else
                        begin
                            stall_chip[u_cs] = int_stall_chip[u_cs];
                        end
                end
            
            // int_stall_chip_combi signal, we need to issue stall chip one clock cycle earlier to rank timer
            // because rank timer is using a register output
            always @ (*)
                begin
                    if (state == IDLE)
                        begin
                            if (refresh_chip_req[u_cs] && !do_refresh[u_cs])
                                begin
                                    int_stall_chip_combi[u_cs]  =  1'b1;
                                end
                            else if (self_refresh_chip_req[u_cs])
                                begin
                                    int_stall_chip_combi[u_cs]  =  1'b1;
                                end
                            else if (deep_pdown_chip_req[u_cs])
                                begin
                                    int_stall_chip_combi[u_cs]  =  1'b1;
                                end
                            else if (power_down_chip_req_combi[u_cs])
                                begin
                                    int_stall_chip_combi[u_cs]  =  1'b1;
                                end
                            else
                                begin
                                    int_stall_chip_combi[u_cs]  =  1'b0;
                                end
                        end
                    else
                        begin
                            int_stall_chip_combi[u_cs] = 1'b0;
                        end
                end
            
            // command issuing state machine
            always @(posedge ctl_clk, negedge ctl_reset_n)
            begin : FSM
            if (!ctl_reset_n)
                begin
                    state <= INIT;
                    int_stall_chip[u_cs] <= 1'b0;
                    stall_arbiter[u_cs] <= 1'b0;
                    do_power_down[u_cs] <= 1'b0;
                    do_deep_pdown[u_cs] <= 1'b0;
                    do_self_rfsh_req[u_cs] <= 1'b0;
                    do_zqcal_req[u_cs] <= 1'b0;
                    doing_zqcal[u_cs] <= 1'b0;
                    do_pch_all_req[u_cs] <= 1'b0;
                    do_refresh_req[u_cs] <= 1'b0;
                    afi_ctl_refresh_done[u_cs] <= 1'b0;
                    afi_ctl_long_idle[u_cs] <= 1'b0;
                    dqstrk_exit[u_cs] <= 1'b0;
                    dqslong_exit[u_cs] <= 1'b0;
                end
            else
                case(state)
                    INIT :
                        if (ctl_cal_success == 1'b1)
                            begin
                                state <= IDLE;
                                int_stall_chip[u_cs] <= 1'b0;
                            end
                        else
                            begin
                                state <= INIT;
                                int_stall_chip[u_cs] <= 1'b1;
                            end
                    IDLE :
                        begin
                            do_pch_all_req[u_cs] <= 1'b0;
                            if (do_zqcal_req[u_cs])
                                begin
                                    if (do_zqcal[u_cs])
                                        begin
                                            do_zqcal_req[u_cs] <= 1'b0;
                                            doing_zqcal[u_cs] <= 1'b0;
                                            stall_arbiter[u_cs] <= 1'b0;
                                        end
                                end
                            else if (refresh_chip_req[u_cs] && !do_refresh[u_cs])
                                begin
                                    int_stall_chip[u_cs]    <=  1'b1;
                                    if (all_banks_closed[u_cs])
                                        state <= REFRESH;
                                    else
                                        state <= PCHALL;
                                end
                            else if (self_refresh_chip_req[u_cs])
                                begin
                                    int_stall_chip[u_cs]    <=  1'b1;
                                    if (all_banks_closed[u_cs])
                                        state <= SELFRFSH;
                                    else
                                        state <= PCHALL;
                                end
                            else if (deep_pdown_chip_req[u_cs])
                                begin
                                    int_stall_chip[u_cs]    <=  1'b1;
                                    if (all_banks_closed[u_cs])
                                        state <= DEEPPDN;
                                    else
                                        state <= PCHALL;
                                end
                            else if (power_down_chip_req_combi[u_cs])
                                begin
                                    int_stall_chip[u_cs]    <=  1'b1;
                                    if (all_banks_closed[u_cs])
                                        state <= PDOWN;
                                    else
                                        state <= PCHALL;
                                end
                            else if (int_stall_chip[u_cs] && !do_refresh[u_cs] && power_saving_enter_ready[u_cs])
                                int_stall_chip[u_cs]    <=  1'b0;
                        end
                    PCHALL :
                        begin
                            if (refresh_chip_req[u_cs] | self_refresh_chip_req[u_cs] | power_down_chip_req_combi[u_cs])
                                begin
                                    if (do_precharge_all[u_cs] || all_banks_closed[u_cs]) 
                                        begin
                                            do_pch_all_req[u_cs] <= 1'b0;
                                            stall_arbiter[u_cs] <= 1'b0;
                                            
                                            if (refresh_chip_req[u_cs])
                                                state <= REFRESH;
                                            else if (self_refresh_chip_req[u_cs])
                                                state <= SELFRFSH;
                                            else state <= PDOWN;
                                        end
                                    else if (refresh_chip_req[u_cs])
                                        begin
                                            if ((~all_banks_closed&refresh_chip_req)==(~all_banks_closed&tcom_not_running&refresh_chip_req) && !grant)
                                                begin
                                                    do_pch_all_req[u_cs] <= 1'b1;
                                                    stall_arbiter[u_cs] <= 1'b1;
                                                end
                                        end
                                    else if (self_refresh_chip_req[u_cs])
                                        begin
                                            if ((~all_banks_closed&self_refresh_chip_req)==(~all_banks_closed&tcom_not_running&self_refresh_chip_req) && !grant)
                                                begin
                                                    do_pch_all_req[u_cs] <= 1'b1;
                                                    stall_arbiter[u_cs] <= 1'b1;
                                                end
                                        end
                                    else if (&tcom_not_running && !grant)
                                        begin
                                            do_pch_all_req[u_cs] <= 1'b1;
                                            stall_arbiter[u_cs] <= 1'b1;
                                        end
                                end
                            else 
                                begin
                                    state <= IDLE;
                                    do_pch_all_req[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
                                end
                        end
                    REFRESH :
                        begin
                            if (do_refresh[u_cs])
                                begin
                                    do_refresh_req[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
                                    
                                    if (cfg_enable_dqs_tracking && &do_refresh)
                                        state <= DQSTRK;
                                    else if (!refresh_chip_req[u_cs] && power_down_chip_req_combi[u_cs])
                                        state <= PDOWN;
                                    else
                                        state <= IDLE;                                    
                                end
                            else if (refresh_chip_req[u_cs])
                                begin
                                    if (!all_banks_closed[u_cs])
                                        state <= PCHALL;
                                    else if (refresh_chip_req==(can_refresh&refresh_chip_req))
                                        begin
                                            do_refresh_req[u_cs] <= 1'b1;
                                            stall_arbiter[u_cs] <= 1'b1;
                                        end
                                end
                            else
                                begin
                                    state <= IDLE;
                                    stall_arbiter[u_cs] <= 1'b0;
                                end
                        end
                    DQSTRK :
                        begin
                            if (!dqstrk_exit[u_cs] && !afi_ctl_refresh_done[u_cs] && !do_refresh[u_cs] && power_saving_enter_ready[u_cs])
                                afi_ctl_refresh_done[u_cs]    <=  1'b1;
                            else if (!dqstrk_exit[u_cs] && afi_seq_busy_r2[u_cs] && afi_ctl_refresh_done[u_cs]) // stall until seq_busy is deasserted
                                dqstrk_exit[u_cs]   <=  1;
                            else if (dqstrk_exit[u_cs] && !afi_seq_busy_r2[u_cs])
                                begin
                                    afi_ctl_refresh_done[u_cs]  <=  1'b0;
                                    dqstrk_exit[u_cs]   <=  1'b0;
                                    if (!refresh_chip_req[u_cs] && power_down_chip_req_combi[u_cs])
                                        state <= PDOWN;
                                    else
                                        state <= IDLE;
                                end
                        end
                    DQSLONG :
                        begin
                            if (do_zqcal[u_cs])
                                begin
                                    do_zqcal_req[u_cs] <= 1'b0;
                                    doing_zqcal[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
                                end
                            
                            if (!dqslong_exit[u_cs] && !afi_ctl_long_idle[u_cs] && power_saving_enter_ready[u_cs])
                                afi_ctl_long_idle[u_cs]    <=  1'b1;
                            else if (!dqslong_exit[u_cs] && afi_seq_busy_r2[u_cs] && afi_ctl_long_idle[u_cs])
                                dqslong_exit[u_cs]  <=  1;
                            else if (dqslong_exit[u_cs] && !afi_seq_busy_r2[u_cs])
                                begin
                                    afi_ctl_long_idle[u_cs]  <=  1'b0;
                                    dqslong_exit[u_cs]  <=  1'b0;
                                    state <= IDLE;
                                end
                        end
                    PDOWN :
                        begin
                            if (refresh_chip_req[u_cs] && !do_refresh[u_cs] && can_exit_power_saving_mode[u_cs])
                                begin
                                    state <= REFRESH;
                                    do_power_down[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
                                end
                            else if (!power_down_chip_req_combi[u_cs] && can_exit_power_saving_mode[u_cs])
                                begin
                                    if (self_refresh_chip_req[u_cs])
                                        state <= SELFRFSH;
                                    else
                                        state <= IDLE;
                                    do_power_down[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
                                end
                            else if (&can_power_down && !(|refresh_chip_req))
                                begin
                                    do_power_down[u_cs] <= 1'b1;
                                    stall_arbiter[u_cs] <= 1'b1;
                                end
                            else
                                state <= PDOWN;
                        end
                    DEEPPDN :
                        begin
                            if (!deep_pdown_chip_req[u_cs] && can_exit_power_saving_mode[u_cs])
                                begin
                                    do_deep_pdown[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
                                    
                                    if (cfg_enable_dqs_tracking)
                                        state <= DQSLONG;
                                    else
                                        state <= IDLE;
                                end
                            else if (can_deep_pdown[u_cs] && !do_precharge_all[u_cs])
                                begin
                                    do_deep_pdown[u_cs] <= 1'b1;
                                    stall_arbiter[u_cs] <= 1'b1;
                                end
                        end
                    SELFRFSH :
                        begin
                            if (!all_banks_closed[u_cs])
                                state <= PCHALL;
                            else if (!self_refresh_chip_req[u_cs] && can_exit_power_saving_mode[u_cs])
                                begin
                                    do_self_rfsh_req[u_cs] <= 1'b0;
                                    stall_arbiter[u_cs] <= 1'b0;
            
                                    if (cfg_type == `MMR_TYPE_DDR3) // DDR3
                                        begin
                                            state <= ZQCAL;
                                            doing_zqcal[u_cs] <= 1'b1;
                                        end
                                    else if (cfg_enable_dqs_tracking && &do_self_rfsh)
                                        state <= DQSLONG;
                                    else
                                        state <= IDLE;
                                end
                            else if (self_refresh_chip_req==(can_self_rfsh&self_refresh_chip_req) && !(|do_precharge_all))
                                begin
                                    do_self_rfsh_req[u_cs] <= 1'b1;
                                    stall_arbiter[u_cs] <= 1'b1;
                                end
                        end
                    ZQCAL :
                        begin
                            if (cs_zq_cal_req[u_cs])
                                begin
                                    do_zqcal_req[u_cs] <= 1'b1;
                                    stall_arbiter[u_cs] <= 1'b1;
                                    if (cfg_enable_dqs_tracking && &cs_zq_cal_req)
                                        state <= DQSLONG;
                                    else
                                        state <= IDLE;
                                end
                        end
                    default : state <= IDLE;
                endcase
            end
            
            // sideband state machine
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    sideband_state           <= IDLE;
                    int_enter_power_saving_ready <= 1'b0;
                    int_zq_cal_req               <= 1'b0;
                end
                else
                begin
                    case (sideband_state)
                        IDLE :
                            begin
                                int_zq_cal_req <= 1'b0;
                                
                                if (power_saving_cnt >= t_param_pch_all_to_valid)
                                    int_enter_power_saving_ready <= 1'b1;
                                else
                                    int_enter_power_saving_ready <= 1'b0;
                                
                                if (do_precharge_all[u_cs])
                                begin
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                                
                                if (do_refresh[u_cs])
                                begin
                                    sideband_state           <= ARF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                                
                                if (do_self_rfsh[u_cs])
                                begin
                                    sideband_state           <= SRF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                                
                                if (do_power_down[u_cs])
                                begin
                                    sideband_state           <= PDN;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        ARF :
                            begin
                                int_zq_cal_req <= 1'b0;
                                
                                if (power_saving_cnt >= t_param_arf_to_valid)
                                begin
                                    sideband_state           <= IDLE;
                                    int_enter_power_saving_ready <= 1'b1;
                                end
                                else
                                begin
                                    sideband_state           <= ARF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        SRF :
                            begin
                                // ZQ request to state machine
                                if (power_saving_cnt == t_param_srf_to_zq_cal) // only one cycle
                                    int_zq_cal_req <= 1'b1;
                                else
                                    int_zq_cal_req <= 1'b0;
                                
                                if (!do_self_rfsh[u_cs] && power_saving_cnt >= t_param_srf_to_valid)
                                begin
                                    sideband_state           <= IDLE;
                                    int_enter_power_saving_ready <= 1'b1;
                                end
                                else
                                begin
                                    sideband_state           <= SRF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        PDN :
                            begin
                                int_zq_cal_req <= 1'b0;
                                
                                if (!do_power_down[u_cs] && power_saving_cnt >= t_param_pdn_to_valid)
                                begin
                                    sideband_state           <= IDLE;
                                    int_enter_power_saving_ready <= 1'b1;
                                end
                                else
                                begin
                                    sideband_state           <= PDN;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        default :
                            begin
                                sideband_state <= IDLE;
                            end
                    endcase
                end
            end
        end
    endgenerate
    
    /*------------------------------------------------------------------------------
        Refresh Request
    ------------------------------------------------------------------------------*/
    generate
        genvar s_cs;
        for (s_cs = 0;s_cs < CFG_MEM_IF_CHIP;s_cs = s_cs + 1)
        begin : auto_refresh_logic_per_chip
            reg [ARF_COUNTER_WIDTH - 1 : 0] refresh_cnt;
            
            // refresh counter
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    refresh_cnt <= 0;
                end
                else
                begin
                    if (self_rfsh_req && |self_rfsh_chip && !self_rfsh_req_r)
                        refresh_cnt <= {ARF_COUNTER_WIDTH{1'b1}};
                    else if (do_refresh[s_cs])
                        refresh_cnt <= 3;
                    else if (refresh_cnt != {ARF_COUNTER_WIDTH{1'b1}})
                        refresh_cnt <= refresh_cnt + 1'b1;
                end
            end
            
            // refresh request logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    cs_refresh_req [s_cs] <= 1'b0;
                end
                else
                begin
                    if (self_rfsh_req && |self_rfsh_chip && !self_rfsh_req_r)
                        cs_refresh_req [s_cs] <= 1'b1;
                    else if (do_refresh[s_cs] || do_self_rfsh[s_cs])
                        cs_refresh_req [s_cs] <= 1'b0;
                    else if (refresh_cnt >= t_param_arf_period)
                        cs_refresh_req [s_cs] <= 1'b1;
                    else
                        cs_refresh_req [s_cs] <= 1'b0;
                end
            end
        end
    endgenerate
    
    /*------------------------------------------------------------------------------
        Power Down Request
    ------------------------------------------------------------------------------*/
    // register no command signal
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            no_command_r1 <= 1'b0;
        end
        else
        begin
            no_command_r1 <= tbp_empty;
        end
    end
    
    // power down counter
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            power_down_cnt <= 0;
        end
        else
        begin
            if ((!tbp_empty && no_command_r1) || self_rfsh_req) // negative edge detector
                power_down_cnt <= 3;
            else if (tbp_empty && power_down_cnt != {PDN_COUNTER_WIDTH{1'b1}} && ctl_cal_success)
                power_down_cnt <= power_down_cnt + 1'b1;
        end
    end
    
    // power down request logic
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            power_down_chip_req <= 0;
        end
        else
        begin
            if (t_param_pdn_period == 0) // when auto power down cycles is set to '0', auto power down mode will be disabled
                power_down_chip_req <= 0;
            else
            begin
                if (!tbp_empty || self_rfsh_req) // we need to make sure power down request to go low as fast as possible to avoid unnecessary power down
                    power_down_chip_req <= 0;
                else if (power_down_chip_req == 0)
                    begin
                        if (power_down_cnt >= t_param_pdn_period && !(|doing_zqcal))
                            power_down_chip_req <= {CFG_MEM_IF_CHIP{1'b1}};
                        else
                            power_down_chip_req <= 0;
                    end
                else if (!(power_down_cnt >= t_param_pdn_period))
                    power_down_chip_req <= 0;
            end
        end
    end
    
    assign power_down_chip_req_combi = power_down_chip_req & {CFG_MEM_IF_CHIP{tbp_empty}} & {CFG_MEM_IF_CHIP{~(|refresh_chip_req)}};

/*------------------------------------------------------------------------------

    [END] Power Saving Rank Monitor

------------------------------------------------------------------------------*/
    
    
endmodule
