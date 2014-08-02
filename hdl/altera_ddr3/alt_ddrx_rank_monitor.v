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
// Title         : 
//
// File          : alt_ddrx_rank_monitor.v
//
// Abstract      : 
///////////////////////////////////////////////////////////////////////////////

module alt_ddrx_rank_monitor #
    ( parameter
        // memory interface bus sizing parameters
        MEM_IF_CHIP_BITS                          = 2,
        MEM_IF_CS_WIDTH                           = 4,
        MEM_IF_ROW_WIDTH                          = 16,             // max supported row bits
        MEM_IF_BA_WIDTH                           = 3,              // max supported bank bits
        MEM_TYPE                                  = "DDR3",
        
        DWIDTH_RATIO                              = 2,              // 2 - fullrate, 4 - halfrate
        
        // bank timer settings
        BANK_TIMER_INFO_INPUT_REGD                = 1,
        BANK_TIMER_COUNTER_OFFSET                 = 4,
        
        // controller settings
        CTL_LOOK_AHEAD_DEPTH                      = 4,
        CTL_CMD_QUEUE_DEPTH                       = 8,
        CTL_USR_REFRESH                           = 0,              // enabled user refresh
        
        BURST_LENGTH_BUS_WIDTH                    = 4,
        TMRD_BUS_WIDTH                            = 3,
        TMOD_BUS_WIDTH                            = 4,
        SELF_RFSH_EXIT_CYCLES_BUS_WIDTH           = 10,
        ACT_TO_RDWR_WIDTH                         = 4,
        ACT_TO_PCH_WIDTH                          = 5,
        ACT_TO_ACT_WIDTH                          = 6,
        RD_TO_RD_WIDTH                            = 3,
        RD_TO_WR_WIDTH                            = 5,
        RD_TO_WR_BC_WIDTH                         = 4,
        RD_TO_PCH_WIDTH                           = 4,
        WR_TO_WR_WIDTH                            = 3,
        WR_TO_RD_WIDTH                            = 5,
        WR_TO_PCH_WIDTH                           = 5,
        RD_AP_TO_ACT_WIDTH                        = 5,
        WR_AP_TO_ACT_WIDTH                        = 6,
        PCH_TO_ACT_WIDTH                          = 4,
        PCH_ALL_TO_VALID_WIDTH                    = 4,
        ARF_TO_VALID_WIDTH                        = 8,
        PDN_TO_VALID_WIDTH                        = 2,
        SRF_TO_VALID_WIDTH                        = 10,
        ARF_PERIOD_WIDTH                          = 13,
        PDN_PERIOD_WIDTH                          = 16,
        ACT_TO_ACT_DIFF_BANK_WIDTH                = 4,
        FOUR_ACT_TO_ACT_WIDTH                     = 6
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // state machine command inputs
        do_write,
        do_read,
        do_burst_chop,
        do_auto_precharge,
        do_activate,
        do_precharge,
        do_precharge_all,
        do_refresh,
        do_power_down,
        do_self_rfsh,
        
        to_chip,
        to_bank_addr,
        
        // timing param input
        act_to_rdwr,
        act_to_pch,
        act_to_act,
        rd_to_rd,
        rd_to_wr,
        rd_to_wr_bc,
        rd_to_pch,
        wr_to_wr,
        wr_to_rd,
        wr_to_rd_diff_chips,
        wr_to_pch,
        rd_ap_to_act,
        wr_ap_to_act,
        pch_to_act,
        pch_all_to_valid,
        arf_to_valid,
        pdn_to_valid,
        srf_to_valid,
        srf_to_zq,
        arf_period,
        pdn_period,
        act_to_act_diff_bank,
        four_act_to_act,
        
        more_than_x1_act_to_rdwr,
        more_than_x1_act_to_pch,
        more_than_x1_act_to_act,
        more_than_x1_rd_to_rd,
        more_than_x1_rd_to_wr,
        more_than_x1_rd_to_wr_bc,
        more_than_x1_rd_to_pch,
        more_than_x1_wr_to_wr,
        more_than_x1_wr_to_rd,
        more_than_x1_wr_to_pch,
        more_than_x1_rd_ap_to_act,
        more_than_x1_wr_ap_to_act,
        more_than_x1_pch_to_act,
        more_than_x1_act_to_act_diff_bank,
        more_than_x1_four_act_to_act,
        
        less_than_x1_act_to_rdwr,
        less_than_x1_act_to_pch,
        less_than_x1_act_to_act,
        less_than_x1_rd_to_rd,
        less_than_x1_rd_to_wr,
        less_than_x1_rd_to_wr_bc,
        less_than_x1_rd_to_pch,
        less_than_x1_wr_to_wr,
        less_than_x1_wr_to_rd,
        less_than_x1_wr_to_rd_diff_chips,
        less_than_x1_wr_to_pch,
        less_than_x1_rd_ap_to_act,
        less_than_x1_wr_ap_to_act,
        less_than_x1_pch_to_act,
        less_than_x1_act_to_act_diff_bank,
        less_than_x1_four_act_to_act,
        
        more_than_x2_act_to_rdwr,
        more_than_x2_act_to_pch,
        more_than_x2_act_to_act,
        more_than_x2_rd_to_rd,
        more_than_x2_rd_to_wr,
        more_than_x2_rd_to_wr_bc,
        more_than_x2_rd_to_pch,
        more_than_x2_wr_to_wr,
        more_than_x2_wr_to_rd,
        more_than_x2_wr_to_pch,
        more_than_x2_rd_ap_to_act,
        more_than_x2_wr_ap_to_act,
        more_than_x2_pch_to_act,
        more_than_x2_act_to_act_diff_bank,
        more_than_x2_four_act_to_act,
        
        less_than_x2_act_to_rdwr,
        less_than_x2_act_to_pch,
        less_than_x2_act_to_act,
        less_than_x2_rd_to_rd,
        less_than_x2_rd_to_wr,
        less_than_x2_rd_to_wr_bc,
        less_than_x2_rd_to_pch,
        less_than_x2_wr_to_wr,
        less_than_x2_wr_to_rd,
        less_than_x2_wr_to_rd_diff_chips,
        less_than_x2_wr_to_pch,
        less_than_x2_rd_ap_to_act,
        less_than_x2_wr_ap_to_act,
        less_than_x2_pch_to_act,
        less_than_x2_act_to_act_diff_bank,
        less_than_x2_four_act_to_act,
        
        // common logic inputs
        no_command,
        chip_change,
        
        // rank info outputs
        act_tfaw_ready,
        act_trrd_ready,
        read_dqs_ready,
        write_dqs_ready,
        write_to_read_finish_twtr,
        power_saving_enter_ready,
        power_saving_exit_ready,
        
        // rank request outputs
        cs_zq_cal_req,
        cs_power_down_req,
        cs_refresh_req
    );

input ctl_clk;
input ctl_reset_n;

// timing value inputs
input  [ACT_TO_RDWR_WIDTH               - 1 : 0] act_to_rdwr;
input  [ACT_TO_PCH_WIDTH                - 1 : 0] act_to_pch;
input  [ACT_TO_ACT_WIDTH                - 1 : 0] act_to_act;
input  [RD_TO_RD_WIDTH                  - 1 : 0] rd_to_rd;
input  [RD_TO_WR_WIDTH                  - 1 : 0] rd_to_wr;
input  [RD_TO_WR_BC_WIDTH               - 1 : 0] rd_to_wr_bc;
input  [RD_TO_PCH_WIDTH                 - 1 : 0] rd_to_pch;
input  [WR_TO_WR_WIDTH                  - 1 : 0] wr_to_wr;
input  [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd;
input  [WR_TO_RD_WIDTH                  - 1 : 0] wr_to_rd_diff_chips;
input  [WR_TO_PCH_WIDTH                 - 1 : 0] wr_to_pch;
input  [RD_AP_TO_ACT_WIDTH              - 1 : 0] rd_ap_to_act;
input  [WR_AP_TO_ACT_WIDTH              - 1 : 0] wr_ap_to_act;
input  [PCH_TO_ACT_WIDTH                - 1 : 0] pch_to_act;
input  [PCH_ALL_TO_VALID_WIDTH          - 1 : 0] pch_all_to_valid;
input  [ARF_TO_VALID_WIDTH              - 1 : 0] arf_to_valid;
input  [PDN_TO_VALID_WIDTH              - 1 : 0] pdn_to_valid;
input  [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_valid;
input  [SRF_TO_VALID_WIDTH              - 1 : 0] srf_to_zq;
input  [ARF_PERIOD_WIDTH                - 1 : 0] arf_period;
input  [PDN_PERIOD_WIDTH                - 1 : 0] pdn_period;
input  [ACT_TO_ACT_DIFF_BANK_WIDTH      - 1 : 0] act_to_act_diff_bank;
input  [FOUR_ACT_TO_ACT_WIDTH           - 1 : 0] four_act_to_act;

input  more_than_x1_act_to_rdwr;
input  more_than_x1_act_to_pch;
input  more_than_x1_act_to_act;
input  more_than_x1_rd_to_rd;
input  more_than_x1_rd_to_wr;
input  more_than_x1_rd_to_wr_bc;
input  more_than_x1_rd_to_pch;
input  more_than_x1_wr_to_wr;
input  more_than_x1_wr_to_rd;
input  more_than_x1_wr_to_pch;
input  more_than_x1_rd_ap_to_act;
input  more_than_x1_wr_ap_to_act;
input  more_than_x1_pch_to_act;
input  more_than_x1_act_to_act_diff_bank;
input  more_than_x1_four_act_to_act;

input  less_than_x1_act_to_rdwr;
input  less_than_x1_act_to_pch;
input  less_than_x1_act_to_act;
input  less_than_x1_rd_to_rd;
input  less_than_x1_rd_to_wr;
input  less_than_x1_rd_to_wr_bc;
input  less_than_x1_rd_to_pch;
input  less_than_x1_wr_to_wr;
input  less_than_x1_wr_to_rd;
input  less_than_x1_wr_to_rd_diff_chips;
input  less_than_x1_wr_to_pch;
input  less_than_x1_rd_ap_to_act;
input  less_than_x1_wr_ap_to_act;
input  less_than_x1_pch_to_act;
input  less_than_x1_act_to_act_diff_bank;
input  less_than_x1_four_act_to_act;

input  more_than_x2_act_to_rdwr;
input  more_than_x2_act_to_pch;
input  more_than_x2_act_to_act;
input  more_than_x2_rd_to_rd;
input  more_than_x2_rd_to_wr;
input  more_than_x2_rd_to_wr_bc;
input  more_than_x2_rd_to_pch;
input  more_than_x2_wr_to_wr;
input  more_than_x2_wr_to_rd;
input  more_than_x2_wr_to_pch;
input  more_than_x2_rd_ap_to_act;
input  more_than_x2_wr_ap_to_act;
input  more_than_x2_pch_to_act;
input  more_than_x2_act_to_act_diff_bank;
input  more_than_x2_four_act_to_act;

input  less_than_x2_act_to_rdwr;
input  less_than_x2_act_to_pch;
input  less_than_x2_act_to_act;
input  less_than_x2_rd_to_rd;
input  less_than_x2_rd_to_wr;
input  less_than_x2_rd_to_wr_bc;
input  less_than_x2_rd_to_pch;
input  less_than_x2_wr_to_wr;
input  less_than_x2_wr_to_rd;
input  less_than_x2_wr_to_rd_diff_chips;
input  less_than_x2_wr_to_pch;
input  less_than_x2_rd_ap_to_act;
input  less_than_x2_wr_ap_to_act;
input  less_than_x2_pch_to_act;
input  less_than_x2_act_to_act_diff_bank;
input  less_than_x2_four_act_to_act;

// common logic inputs
input  no_command;
input  chip_change;

// state machine command outputs
input  do_write;
input  do_read;
input  do_burst_chop;
input  do_auto_precharge;
input  do_activate;
input  do_precharge;
input  do_precharge_all;
input  do_refresh;
input  do_power_down;
input  do_self_rfsh;

input  [MEM_IF_CS_WIDTH - 1 : 0] to_chip;
input  [MEM_IF_BA_WIDTH - 1 : 0] to_bank_addr;

//rank info outputs
output [MEM_IF_CS_WIDTH - 1 : 0] act_tfaw_ready;
output [MEM_IF_CS_WIDTH - 1 : 0] act_trrd_ready;
output                           read_dqs_ready;
output                           write_dqs_ready;
output [MEM_IF_CS_WIDTH - 1 : 0] write_to_read_finish_twtr;
output [MEM_IF_CS_WIDTH - 1 : 0] power_saving_enter_ready;
output [MEM_IF_CS_WIDTH - 1 : 0] power_saving_exit_ready;

//rank request outputs
output [MEM_IF_CS_WIDTH - 1 : 0] cs_zq_cal_req;
output [MEM_IF_CS_WIDTH - 1 : 0] cs_power_down_req;
output [MEM_IF_CS_WIDTH - 1 : 0] cs_refresh_req;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Registers & Wires

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Parameters
    ------------------------------------------------------------------------------*/
    // states for our DQS bus monitor state machine
    localparam IDLE  = 32'h49444C45;
    localparam WR    = 32'h20205752;
    localparam RD    = 32'h20205244;
    localparam ARF   = 32'h20415246;
    localparam PDN   = 32'h2050444E;
    localparam SRF   = 32'h20535246;
    
    // width parameters for our counters
    localparam RDWR_COUNTER_WIDTH         = 7;
    localparam ACTIVATE_COUNTER_WIDTH     = FOUR_ACT_TO_ACT_WIDTH;
    localparam PDN_COUNTER_WIDTH          = PDN_PERIOD_WIDTH;
    localparam ARF_COUNTER_WIDTH          = ARF_PERIOD_WIDTH;
    localparam POWER_SAVING_COUNTER_WIDTH = SELF_RFSH_EXIT_CYCLES_BUS_WIDTH;
    
    localparam MAX_NUM_OF_TFAW            = 32;
    
    /*------------------------------------------------------------------------------
        Activate Rank Monitor
    ------------------------------------------------------------------------------*/
    reg    [MEM_IF_CS_WIDTH    - 1 : 0] act_tfaw_ready;
    reg    [MEM_IF_CS_WIDTH    - 1 : 0] act_trrd_ready;
    
    /*------------------------------------------------------------------------------
        DQ Rank Monitor
    ------------------------------------------------------------------------------*/
    reg    [RDWR_COUNTER_WIDTH - 1 : 0] rdwr_cnt;
    reg    [31                     : 0] rdwr_state;
    reg                                 doing_burst_chop;
    reg                                 read_dqs_ready;
    reg                                 write_dqs_ready;
    
    reg    [WR_TO_RD_WIDTH     - 1 : 0] twtr_cnt [MEM_IF_CS_WIDTH - 1 : 0];
    reg    [MEM_IF_CS_WIDTH    - 1 : 0] write_to_read_finish_twtr;
    
    /*------------------------------------------------------------------------------
        Power Saving Rank Monitor
    ------------------------------------------------------------------------------*/
    reg    [PDN_COUNTER_WIDTH  - 1 : 0] power_down_cnt;
    reg                                 no_command_r1;
    reg                                 int_power_down_req;
    
    wire   [MEM_IF_CS_WIDTH    - 1 : 0] power_saving_enter_ready;
    wire   [MEM_IF_CS_WIDTH    - 1 : 0] power_saving_exit_ready;
    
    wire   [MEM_IF_CS_WIDTH    - 1 : 0] cs_zq_cal_req;
    wire   [MEM_IF_CS_WIDTH    - 1 : 0] cs_power_down_req;
    wire   [MEM_IF_CS_WIDTH    - 1 : 0] cs_refresh_req;
    
    /*------------------------------------------------------------------------------
        Assignment
    ------------------------------------------------------------------------------*/
    assign cs_power_down_req = {MEM_IF_CS_WIDTH{int_power_down_req}};
/*------------------------------------------------------------------------------

    [END] Registers & Wires

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Activate Rank Monitor

------------------------------------------------------------------------------*/
    generate
        genvar t_cs;
        genvar t_tfaw;
        for (t_cs = 0;t_cs < MEM_IF_CS_WIDTH;t_cs = t_cs + 1)
        begin : act_cmd_monitor_per_chip
            reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] act_trrd_cnt;
            reg [2                          : 0] act_cmd_cnt;
            reg [MAX_NUM_OF_TFAW        - 1 : 0] act_tfaw_shift_reg;
            
            if (MEM_TYPE == "DDR") // there is no tFAW in DDR
            begin
                wire one = 1'b1;
                
                always @ (*)
                begin
                    act_tfaw_ready [t_cs] = one;
                end
            end
            else
            begin
                /*------------------------------------------------------------------------------
                    tFAW Monitor
                ------------------------------------------------------------------------------*/
                // Shift register to keep track of tFAW
                // Shift in -> n, n-1, n-2, n-3.......2, 1, 0 -> Shift out
                // Shift in '1' when there is an activate else shift in '0'
                // Shift out every clock cycles
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        act_tfaw_shift_reg [0] <= 1'b0;
                    end
                    else
                    begin
                        if (do_activate && to_chip [t_cs])
                            act_tfaw_shift_reg [0] <= 1'b1;
                        else
                            act_tfaw_shift_reg [0] <= 1'b0;
                    end
                end
                
                for (t_tfaw = 1;t_tfaw < MAX_NUM_OF_TFAW;t_tfaw = t_tfaw + 1)
                begin : tfaw_shift_register
                    always @ (posedge ctl_clk or negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                        begin
                            act_tfaw_shift_reg [t_tfaw] <= 1'b0;
                        end
                        else
                        begin
                            act_tfaw_shift_reg [t_tfaw] <= act_tfaw_shift_reg [t_tfaw - 1];
                        end
                    end
                end
                
                // Activate command counter
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        act_cmd_cnt <= 0;
                    end
                    else
                    begin
                        if (do_activate && to_chip [t_cs])
                        begin
                            if (act_tfaw_shift_reg [four_act_to_act]) // shift out
                                act_cmd_cnt <= act_cmd_cnt; // remain value
                            else
                                act_cmd_cnt <= act_cmd_cnt + 1'b1;
                        end
                        else if (act_tfaw_shift_reg [four_act_to_act]) // shift out
                            act_cmd_cnt <= act_cmd_cnt - 1'b1;
                    end
                end
                
                // tFAW ready signal
                always @ (*)
                begin
                    if (do_activate && to_chip [t_cs] && act_cmd_cnt == 3'd3)
                        act_tfaw_ready [t_cs] = 1'b0;
                    else if (act_cmd_cnt < 3'd4)
                        act_tfaw_ready [t_cs] = 1'b1;
                    else
                        act_tfaw_ready [t_cs] = 1'b0;
                end
            end
            
            /*------------------------------------------------------------------------------
                tRRD Monitor
            ------------------------------------------------------------------------------*/
            // tRRD counter
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_trrd_cnt <= 0;
                end
                else
                begin
                    if (do_activate && to_chip [t_cs])
                        act_trrd_cnt <= BANK_TIMER_COUNTER_OFFSET;
                    else if (act_trrd_cnt != {ACTIVATE_COUNTER_WIDTH{1'b1}})
                        act_trrd_cnt <= act_trrd_cnt + 1'b1;
                end
            end
            
            // tRRD monitor
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_trrd_ready [t_cs] <= 1'b0;
                end
                else
                begin
                    if (do_activate && to_chip [t_cs])
                    begin
                        if (more_than_x2_act_to_act_diff_bank)
                            act_trrd_ready [t_cs] <= 1'b0;
                        else
                            act_trrd_ready [t_cs] <= 1'b1;
                    end
                    else if (act_trrd_cnt >= act_to_act_diff_bank)
                        act_trrd_ready [t_cs] <= 1'b1;
                    else
                        act_trrd_ready [t_cs] <= 1'b0;
                end
            end
        end
    endgenerate
/*------------------------------------------------------------------------------

    [END] Activate Rank Monitor

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] DQ Rank Monitor

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        DQS Bus Monitor
    ------------------------------------------------------------------------------*/
    // read write counter for dqs bus monitor
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            rdwr_cnt <= 0;
        end
        else
        begin
            if (do_write || do_read)
                rdwr_cnt <= BANK_TIMER_COUNTER_OFFSET + 1; // add one due to state machine logic require can_read/write one clock cycle earlier
            else if (rdwr_cnt != {RDWR_COUNTER_WIDTH{1'b1}})
                rdwr_cnt <= rdwr_cnt + 1'b1;
        end
    end
    
    // keep track of burst chop
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            doing_burst_chop <= 1'b0;
        end
        else
        begin
            if (do_read || do_write)
            begin
                if (do_burst_chop)
                    doing_burst_chop <= 1'b1;
                else
                    doing_burst_chop <= 1'b0;
            end
        end
    end
    
    // dqs bus monitor state machine
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            rdwr_state      <= IDLE;
            read_dqs_ready  <= 1'b0;
            write_dqs_ready <= 1'b0;
        end
        else
        begin
            case (rdwr_state)
                IDLE :
                    begin
                        if (do_write)
                        begin
                            rdwr_state <= WR;
                            
                            if (less_than_x2_wr_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (less_than_x2_wr_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else if (do_read)
                        begin
                            rdwr_state <= RD;
                            
                            if (less_than_x2_rd_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (!do_burst_chop)
                            begin
                                if (less_than_x2_rd_to_wr)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                            else // BC4 OTF
                            begin
                                if (less_than_x2_rd_to_wr_bc)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                        end
                        else
                        begin
                            rdwr_state      <= IDLE;
                            read_dqs_ready  <= 1'b1;
                            write_dqs_ready <= 1'b1;
                        end
                    end
                WR :
                    begin
                        if (do_write)
                        begin
                            rdwr_state <= WR;
                            
                            if (chip_change && less_than_x2_wr_to_rd_diff_chips)
                                read_dqs_ready  <= 1'b1;
                            else if (less_than_x2_wr_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (less_than_x2_wr_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else if (do_read)
                        begin
                            rdwr_state <= RD;
                            
                            if (less_than_x2_rd_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (!do_burst_chop)
                            begin
                                if (less_than_x2_rd_to_wr)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                            else // BC4 OTF
                            begin
                                if (less_than_x2_rd_to_wr_bc)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                        end
                        else
                        begin
                            // if there will be a wr to rd to different chipselects
                            // we will maximize the efficiency by not checking for twtr
                            if (chip_change)
                            begin
                                if (rdwr_cnt >= wr_to_rd_diff_chips)
                                    read_dqs_ready  <= 1'b1;
                                else
                                    read_dqs_ready  <= 1'b0;
                            end
                            else
                            begin
                                if (rdwr_cnt >= wr_to_rd)
                                    read_dqs_ready  <= 1'b1;
                                else
                                    read_dqs_ready  <= 1'b0;
                            end
                            
                            if (rdwr_cnt >= wr_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                    end
                RD :
                    begin
                        if (do_write)
                        begin
                            rdwr_state <= WR;
                            
                            if (chip_change && less_than_x2_wr_to_rd_diff_chips)
                                read_dqs_ready  <= 1'b1;
                            else if (less_than_x2_wr_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (less_than_x2_wr_to_wr)
                                write_dqs_ready <= 1'b1;
                            else
                                write_dqs_ready <= 1'b0;
                        end
                        else if (do_read)
                        begin
                            rdwr_state <= RD;
                            
                            if (less_than_x2_rd_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (!do_burst_chop)
                            begin
                                if (less_than_x2_rd_to_wr)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                            else // BC4 OTF
                            begin
                                if (less_than_x2_rd_to_wr_bc)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                        end
                        else
                        begin
                            if (rdwr_cnt >= rd_to_rd)
                                read_dqs_ready  <= 1'b1;
                            else
                                read_dqs_ready  <= 1'b0;
                            
                            if (!doing_burst_chop)
                            begin
                                if (rdwr_cnt >= rd_to_wr)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                            else
                            begin
                                if (rdwr_cnt >= rd_to_wr_bc)
                                    write_dqs_ready <= 1'b1;
                                else
                                    write_dqs_ready <= 1'b0;
                            end
                        end
                    end
                default :
                    rdwr_state <= IDLE;
            endcase
        end
    end
    
    /*------------------------------------------------------------------------------
        tWTR Monitor
    ------------------------------------------------------------------------------*/
    // There is a problem where we need to keep track of write to read transactions
    // to avoid the following case:
    // X Write Rank 0 X Read Rank 1 X Read Rank 0 X
    //        <-----------tWTR------------>
    generate
        genvar z_cs;
        for (z_cs = 0;z_cs < MEM_IF_CS_WIDTH;z_cs = z_cs + 1)
        begin: tWTR_monitor_per_chip
            // tWTR counter
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    twtr_cnt [z_cs] <= 0;
                end
                else
                begin
                    if (do_write && to_chip [z_cs])
                        twtr_cnt [z_cs] <= BANK_TIMER_COUNTER_OFFSET + 1; // add one due to state machine logic require can_read/write one clock cycle earlier
                    else if (twtr_cnt [z_cs] != {WR_TO_RD_WIDTH{1'b1}})
                        twtr_cnt [z_cs] <= twtr_cnt [z_cs] + 1'b1;
                end
            end
            
            // this signal will indicate previous write to a particular chip has met tWTR
            // this will be used in can_read logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    write_to_read_finish_twtr [z_cs] <= 1'b0;
                end
                else
                begin
                    if (twtr_cnt [z_cs] >= wr_to_rd)
                        write_to_read_finish_twtr [z_cs] <= 1'b1;
                    else
                        write_to_read_finish_twtr [z_cs] <= 1'b0;
                end
            end
        end
    endgenerate
/*------------------------------------------------------------------------------

    [END] DQ Rank Monitor

------------------------------------------------------------------------------*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------

    [START] Power Saving Rank Monitor

------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
        Power Saving State Machine
    ------------------------------------------------------------------------------*/
    generate
        genvar u_cs;
        for (u_cs = 0;u_cs < MEM_IF_CS_WIDTH;u_cs = u_cs + 1)
        begin : power_saving_logic_per_chip
            reg  [POWER_SAVING_COUNTER_WIDTH - 1 : 0] power_saving_cnt;
            reg  [31                             : 0] power_saving_state;
            reg                                       int_enter_power_saving_ready;
            reg                                       int_exit_power_saving_ready;
            reg                                       int_zq_cal_req;
            reg                                       int_do_power_down;
            reg                                       int_do_power_down_r1;
            reg                                       int_do_self_rfsh;
            reg                                       int_do_self_rfsh_r1;
            
            // assignment
            assign power_saving_enter_ready [u_cs] = int_enter_power_saving_ready;
            assign power_saving_exit_ready  [u_cs] = int_exit_power_saving_ready;
            
            assign cs_zq_cal_req            [u_cs] = int_zq_cal_req;
            
            // counter for power saving state machine
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    power_saving_cnt <= 0;
                else
                begin
                    if ((do_precharge_all || do_refresh || do_self_rfsh || do_power_down) && to_chip [u_cs])
                        power_saving_cnt <= BANK_TIMER_COUNTER_OFFSET;
                    else if (power_saving_cnt != {POWER_SAVING_COUNTER_WIDTH{1'b1}})
                        power_saving_cnt <= power_saving_cnt + 1'b1;
                end
            end
            
            // Do power down and self refresh register
            always @ (*)
            begin
                int_do_power_down = do_power_down & to_chip [u_cs];
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    int_do_power_down_r1 <= 1'b0;
                else
                    int_do_power_down_r1 <= int_do_power_down;
            end
            
            always @ (*)
            begin
                int_do_self_rfsh = do_self_rfsh & to_chip [u_cs];
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    int_do_self_rfsh_r1 <= 1'b0;
                else
                    int_do_self_rfsh_r1 <= int_do_self_rfsh;
            end
            
            // exit power saving mode, power down and self refresh need to be at least 3 clock cycle before exiting
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_exit_power_saving_ready <= 1'b0;
                end
                else
                begin
                    if      (( int_do_power_down) && (!int_do_power_down_r1)) // positive edge detector
                        int_exit_power_saving_ready <= 1'b1;
                    else if ((!int_do_power_down) && ( int_do_power_down_r1)) // negative edge detector
                        int_exit_power_saving_ready <= 1'b0;
                    else if (( int_do_self_rfsh ) && (!int_do_self_rfsh_r1 )) // positive edge detector
                        int_exit_power_saving_ready <= 1'b1;
                    else if ((!int_do_self_rfsh ) && ( int_do_self_rfsh_r1 )) // negative edge detector
                        int_exit_power_saving_ready <= 1'b0;
                end
            end
            
            // power saving state machine
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    power_saving_state           <= IDLE;
                    int_enter_power_saving_ready <= 1'b0;
                    int_zq_cal_req               <= 1'b0;
                end
                else
                begin
                    case (power_saving_state)
                        IDLE :
                            begin
                                int_zq_cal_req <= 1'b0;
                                
                                if (do_precharge_all && to_chip [u_cs])
                                    int_enter_power_saving_ready <= 1'b0;
                                else if (power_saving_cnt >= pch_all_to_valid)
                                    int_enter_power_saving_ready <= 1'b1;
                                else
                                    int_enter_power_saving_ready <= 1'b0;
                                
                                if (do_refresh && to_chip [u_cs])
                                begin
                                    power_saving_state           <= ARF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                                
                                if (do_self_rfsh && to_chip [u_cs])
                                begin
                                    power_saving_state           <= SRF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                                
                                if (do_power_down && to_chip [u_cs])
                                begin
                                    power_saving_state           <= PDN;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        ARF :
                            begin
                                int_zq_cal_req <= 1'b0;
                                
                                if (power_saving_cnt >= arf_to_valid)
                                begin
                                    power_saving_state           <= IDLE;
                                    int_enter_power_saving_ready <= 1'b1;
                                end
                                else
                                begin
                                    power_saving_state           <= ARF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        SRF :
                            begin
                                // ZQ request to state machine
                                if (power_saving_cnt == srf_to_zq) // only one cycle
                                    int_zq_cal_req <= 1'b1;
                                else
                                    int_zq_cal_req <= 1'b0;
                                
                                if (!(do_self_rfsh && to_chip [u_cs]) && power_saving_cnt >= srf_to_valid)
                                begin
                                    power_saving_state           <= IDLE;
                                    int_enter_power_saving_ready <= 1'b1;
                                end
                                else
                                begin
                                    power_saving_state           <= SRF;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        PDN :
                            begin
                                int_zq_cal_req <= 1'b0;
                                
                                if (!(do_power_down && to_chip [u_cs]))
                                begin
                                    power_saving_state           <= IDLE;
                                    int_enter_power_saving_ready <= 1'b1;
                                end
                                else
                                begin
                                    power_saving_state           <= PDN;
                                    int_enter_power_saving_ready <= 1'b0;
                                end
                            end
                        default :
                            begin
                                power_saving_state <= IDLE;
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
        if (!CTL_USR_REFRESH)
        begin
            for (s_cs = 0;s_cs < MEM_IF_CS_WIDTH;s_cs = s_cs + 1)
            begin : auto_refresh_logic_per_chip
                reg [ARF_COUNTER_WIDTH - 1 : 0] refresh_cnt;
                reg                             int_refresh_req;
                
                // assignment
                assign cs_refresh_req [s_cs] = int_refresh_req;
                
                // refresh counter
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        refresh_cnt <= 0;
                    end
                    else
                    begin
                        if (do_refresh & to_chip[s_cs])
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
                        int_refresh_req <= 1'b0;
                    end
                    else
                    begin
                        if (do_refresh & to_chip[s_cs])
                            int_refresh_req <= 1'b0;
                        else if (refresh_cnt >= arf_period)
                            int_refresh_req <= 1'b1;
                        else
                            int_refresh_req <= 1'b0;
                    end
                end
            end
        end
        else
        begin
            // assignment
            assign cs_refresh_req = 0;
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
            no_command_r1 <= no_command;
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
            if (!no_command && no_command_r1) // negative edge detector
                power_down_cnt <= 3;
            else if (no_command && power_down_cnt != {PDN_COUNTER_WIDTH{1'b1}})
                power_down_cnt <= power_down_cnt + 1'b1;
        end
    end
    
    // power down request logic
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_power_down_req <= 1'b0;
        end
        else
        begin
            if (pdn_period == 0) // when auto power down cycles is set to '0', auto power down mode will be disabled
                int_power_down_req <= 1'b0;
            else
            begin
                if (!no_command) // we need to make sure power down request to go low as fast as possible to avoid unnecessary power down
                    int_power_down_req <= 1'b0;
                else if (power_down_cnt >= pdn_period)
                    int_power_down_req <= 1'b1;
                else
                    int_power_down_req <= 1'b0;
            end
        end
    end

/*------------------------------------------------------------------------------

    [END] Power Saving Rank Monitor

------------------------------------------------------------------------------*/

endmodule
