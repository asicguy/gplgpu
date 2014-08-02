//Legal Notice: (C)2009 Altera Corporation. All rights reserved.  Your
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
// Title         : DDR controller Timer FSM
//
// File          : alt_ddrx_timer_fsm.v
//
// Abstract      : Keep track of bank specific DDR timing information
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_timers_fsm #
    ( parameter
        BANK_ACTIVATE_WIDTH        = 10,
        ACT_TO_PCH_WIDTH           = 10,
        ACT_TO_ACT_WIDTH           = 10,
        RD_TO_RD_WIDTH             = 10,
        RD_TO_WR_WIDTH             = 10,
        RD_TO_PCH_WIDTH            = 10,
        WR_TO_WR_WIDTH             = 10,
        WR_TO_RD_WIDTH             = 10,
        WR_TO_PCH_WIDTH            = 10,
        PCH_TO_ACT_WIDTH           = 10,
        RD_AP_TO_ACT_WIDTH         = 10,
        WR_AP_TO_ACT_WIDTH         = 10,
        ARF_TO_VALID_WIDTH         = 10,
        PDN_TO_VALID_WIDTH         = 10,
        SRF_TO_VALID_WIDTH         = 10,
        LMR_TO_LMR_WIDTH           = 10,
        LMR_TO_VALID_WIDTH         = 10
    )
    (
        // inputs
        ctl_clk,
        ctl_reset_n,
        
        do_write,
        do_read,
        do_activate,
        do_precharge,
        do_auto_precharge,
        do_precharge_all,
        do_refresh,
        do_power_down,
        do_self_rfsh,
        do_lmr,
        
        do_enable,
        
        bank_active,
        act_to_pch,
        act_to_act,
        rd_to_rd,
        rd_to_wr,
        rd_to_pch,
        wr_to_wr,
        wr_to_rd,
        wr_to_pch,
        wr_to_rd_to_pch_all,
        pch_to_act,
        rd_ap_to_act,
        wr_ap_to_act,
        arf_to_valid,
        pdn_to_valid,
        srf_to_valid,
        srf_to_zq,
        lmr_to_lmr,
        lmr_to_valid,
        
        less_than_2_bank_active,
        less_than_2_act_to_pch,
        less_than_2_act_to_act,
        less_than_2_rd_to_rd,
        less_than_2_rd_to_wr,
        less_than_2_rd_to_pch,
        less_than_2_wr_to_wr,
        less_than_2_wr_to_rd,
        less_than_2_wr_to_pch,
        less_than_2_pch_to_act,
        less_than_2_rd_ap_to_act,
        less_than_2_wr_ap_to_act,
        less_than_2_arf_to_valid,
        less_than_2_pdn_to_valid,
        less_than_2_srf_to_valid,
        less_than_2_lmr_to_lmr,
        less_than_2_lmr_to_valid,
        
        less_than_3_bank_active,
        less_than_3_act_to_pch,
        less_than_3_act_to_act,
        less_than_3_rd_to_rd,
        less_than_3_rd_to_wr,
        less_than_3_rd_to_pch,
        less_than_3_wr_to_wr,
        less_than_3_wr_to_rd,
        less_than_3_wr_to_pch,
        less_than_3_wr_to_rd_to_pch_all,
        less_than_3_pch_to_act,
        less_than_3_rd_ap_to_act,
        less_than_3_wr_ap_to_act,
        less_than_3_arf_to_valid,
        less_than_3_pdn_to_valid,
        less_than_3_srf_to_valid,
        less_than_3_lmr_to_lmr,
        less_than_3_lmr_to_valid,
        
        less_than_4_bank_active,
        less_than_4_act_to_pch,
        less_than_4_act_to_act,
        less_than_4_rd_to_rd,
        less_than_4_rd_to_wr,
        less_than_4_rd_to_pch,
        less_than_4_wr_to_wr,
        less_than_4_wr_to_rd,
        less_than_4_wr_to_pch,
        less_than_4_wr_to_rd_to_pch_all,
        less_than_4_pch_to_act,
        less_than_4_rd_ap_to_act,
        less_than_4_wr_ap_to_act,
        less_than_4_arf_to_valid,
        less_than_4_pdn_to_valid,
        less_than_4_srf_to_valid,
        less_than_4_lmr_to_lmr,
        less_than_4_lmr_to_valid,
        
        more_than_2_bank_active,
        more_than_2_act_to_pch,
        more_than_2_act_to_act,
        more_than_2_rd_to_rd,
        more_than_2_rd_to_wr,
        more_than_2_rd_to_pch,
        more_than_2_wr_to_wr,
        more_than_2_wr_to_rd,
        more_than_2_wr_to_pch,
        more_than_2_pch_to_act,
        more_than_2_rd_ap_to_act,
        more_than_2_wr_ap_to_act,
        more_than_2_arf_to_valid,
        more_than_2_pdn_to_valid,
        more_than_2_srf_to_valid,
        more_than_2_lmr_to_lmr,
        more_than_2_lmr_to_valid,
        
        more_than_3_bank_active,
        more_than_3_act_to_pch,
        more_than_3_act_to_act,
        more_than_3_rd_to_rd,
        more_than_3_rd_to_wr,
        more_than_3_rd_to_pch,
        more_than_3_wr_to_wr,
        more_than_3_wr_to_rd,
        more_than_3_wr_to_pch,
        more_than_3_pch_to_act,
        more_than_3_rd_ap_to_act,
        more_than_3_wr_ap_to_act,
        more_than_3_arf_to_valid,
        more_than_3_pdn_to_valid,
        more_than_3_srf_to_valid,
        more_than_3_lmr_to_lmr,
        more_than_3_lmr_to_valid,
        
        more_than_5_pch_to_act,
        
        compare_wr_to_rd_to_pch_all,
        
        // outputs
        int_can_activate,
        int_can_activate_chip,
        int_can_precharge,
        int_can_read,
        int_can_write,
        int_can_refresh,
        int_can_power_down,
        int_can_self_rfsh,
        int_can_lmr,
        int_zq_cal_req
    );

input ctl_clk;
input ctl_reset_n;

input do_write;
input do_read;
input do_activate;
input do_precharge;
input do_auto_precharge;
input do_precharge_all;
input do_refresh;
input do_power_down;
input do_self_rfsh;
input do_lmr;

input do_enable;

input [BANK_ACTIVATE_WIDTH - 1 : 0] bank_active;
input [ACT_TO_PCH_WIDTH    - 1 : 0] act_to_pch;
input [ACT_TO_ACT_WIDTH    - 1 : 0] act_to_act;
input [RD_TO_RD_WIDTH      - 1 : 0] rd_to_rd;
input [RD_TO_WR_WIDTH      - 1 : 0] rd_to_wr;
input [RD_TO_PCH_WIDTH     - 1 : 0] rd_to_pch;
input [WR_TO_WR_WIDTH      - 1 : 0] wr_to_wr;
input [WR_TO_RD_WIDTH      - 1 : 0] wr_to_rd;
input [WR_TO_PCH_WIDTH     - 1 : 0] wr_to_pch;
input [WR_TO_PCH_WIDTH     - 1 : 0] wr_to_rd_to_pch_all;
input [PCH_TO_ACT_WIDTH    - 1 : 0] pch_to_act;
input [RD_AP_TO_ACT_WIDTH  - 1 : 0] rd_ap_to_act;
input [WR_AP_TO_ACT_WIDTH  - 1 : 0] wr_ap_to_act;
input [ARF_TO_VALID_WIDTH  - 1 : 0] arf_to_valid;
input [PDN_TO_VALID_WIDTH  - 1 : 0] pdn_to_valid;
input [SRF_TO_VALID_WIDTH  - 1 : 0] srf_to_valid;
input [SRF_TO_VALID_WIDTH  - 1 : 0] srf_to_zq;
input [LMR_TO_LMR_WIDTH    - 1 : 0] lmr_to_lmr;
input [LMR_TO_VALID_WIDTH  - 1 : 0] lmr_to_valid;

input less_than_2_bank_active;
input less_than_2_act_to_pch;
input less_than_2_act_to_act;
input less_than_2_rd_to_rd;
input less_than_2_rd_to_wr;
input less_than_2_rd_to_pch;
input less_than_2_wr_to_wr;
input less_than_2_wr_to_rd;
input less_than_2_wr_to_pch;
input less_than_2_pch_to_act;
input less_than_2_rd_ap_to_act;
input less_than_2_wr_ap_to_act;
input less_than_2_arf_to_valid;
input less_than_2_pdn_to_valid;
input less_than_2_srf_to_valid;
input less_than_2_lmr_to_lmr;
input less_than_2_lmr_to_valid;

input less_than_3_bank_active;
input less_than_3_act_to_pch;
input less_than_3_act_to_act;
input less_than_3_rd_to_rd;
input less_than_3_rd_to_wr;
input less_than_3_rd_to_pch;
input less_than_3_wr_to_wr;
input less_than_3_wr_to_rd;
input less_than_3_wr_to_pch;
input less_than_3_wr_to_rd_to_pch_all;
input less_than_3_pch_to_act;
input less_than_3_rd_ap_to_act;
input less_than_3_wr_ap_to_act;
input less_than_3_arf_to_valid;
input less_than_3_pdn_to_valid;
input less_than_3_srf_to_valid;
input less_than_3_lmr_to_lmr;
input less_than_3_lmr_to_valid;

input less_than_4_bank_active;
input less_than_4_act_to_pch;
input less_than_4_act_to_act;
input less_than_4_rd_to_rd;
input less_than_4_rd_to_wr;
input less_than_4_rd_to_pch;
input less_than_4_wr_to_wr;
input less_than_4_wr_to_rd;
input less_than_4_wr_to_pch;
input less_than_4_wr_to_rd_to_pch_all;
input less_than_4_pch_to_act;
input less_than_4_rd_ap_to_act;
input less_than_4_wr_ap_to_act;
input less_than_4_arf_to_valid;
input less_than_4_pdn_to_valid;
input less_than_4_srf_to_valid;
input less_than_4_lmr_to_lmr;
input less_than_4_lmr_to_valid;

input more_than_2_bank_active;
input more_than_2_act_to_pch;
input more_than_2_act_to_act;
input more_than_2_rd_to_rd;
input more_than_2_rd_to_wr;
input more_than_2_rd_to_pch;
input more_than_2_wr_to_wr;
input more_than_2_wr_to_rd;
input more_than_2_wr_to_pch;
input more_than_2_pch_to_act;
input more_than_2_rd_ap_to_act;
input more_than_2_wr_ap_to_act;
input more_than_2_arf_to_valid;
input more_than_2_pdn_to_valid;
input more_than_2_srf_to_valid;
input more_than_2_lmr_to_lmr;
input more_than_2_lmr_to_valid;

input more_than_3_bank_active;
input more_than_3_act_to_pch;
input more_than_3_act_to_act;
input more_than_3_rd_to_rd;
input more_than_3_rd_to_wr;
input more_than_3_rd_to_pch;
input more_than_3_wr_to_wr;
input more_than_3_wr_to_rd;
input more_than_3_wr_to_pch;
input more_than_3_pch_to_act;
input more_than_3_rd_ap_to_act;
input more_than_3_wr_ap_to_act;
input more_than_3_arf_to_valid;
input more_than_3_pdn_to_valid;
input more_than_3_srf_to_valid;
input more_than_3_lmr_to_lmr;
input more_than_3_lmr_to_valid;

input more_than_5_pch_to_act;

input compare_wr_to_rd_to_pch_all;

output int_can_activate;
output int_can_activate_chip;
output int_can_precharge;
output int_can_read;
output int_can_write;
output int_can_refresh;
output int_can_power_down;
output int_can_self_rfsh;
output int_can_lmr;
output int_zq_cal_req;

localparam IDLE  = 32'h49444C45;
localparam ACT   = 32'h20414354;
localparam WR    = 32'h20205752;
localparam RD    = 32'h20205244;
localparam WRAP  = 32'h57524150;
localparam RDAP  = 32'h52444150;
localparam PCH   = 32'h20504348;
localparam ARF   = 32'h20415246;
localparam PDN   = 32'h2050444E;
localparam SRF   = 32'h20535246;
localparam LMR   = 32'h204C4D52;

localparam GENERAL_COUNTER_BIT = 8;   // 1-140? (ARF)
localparam TRC_COUNTER_BIT     = 6;   // 8-40
localparam TRAS_COUNTER_BIT    = 5;   // 4-29
localparam EXIT_COUNTER_BIT    = 10;  // 512/200 (DDR3/2)

reg [31 : 0] state;
//reg [31 : 0] prev_state;

reg did_write;

reg int_do_write;
reg int_do_read;
reg int_do_activate;
reg int_do_precharge;
reg int_do_auto_precharge;
reg int_do_precharge_all;
reg int_do_refresh;
reg int_do_power_down;
reg int_do_self_rfsh;
reg int_do_lmr;

reg int_can_activate;
reg int_can_precharge;
reg int_can_read;
reg int_can_write;
reg int_can_refresh;
reg int_can_power_down;
reg int_can_self_rfsh;
reg int_can_lmr;
reg int_zq_cal_req;

reg int_do_self_rfsh_r1;

reg [GENERAL_COUNTER_BIT - 1 : 0] cnt;
reg [TRC_COUNTER_BIT - 1 : 0]     trc_cnt;
reg [TRAS_COUNTER_BIT - 1 : 0]    tras_cnt;
reg [EXIT_COUNTER_BIT - 1 : 0]    exit_cnt;

reg read_ok;
reg write_ok;
reg activate_ok;
reg precharge_ok;
reg chip_request_ok;
reg chip_activate_ok;
reg zq_cal_req;

wire int_can_activate_chip = chip_activate_ok;

always @ (*)
begin
    int_do_write          = do_write          & do_enable ;
    int_do_read           = do_read           & do_enable ;
    int_do_activate       = do_activate       & do_enable ;
    int_do_precharge      = do_precharge      & do_enable ;
    int_do_auto_precharge = do_auto_precharge & do_enable ;
    int_do_precharge_all  = do_precharge_all              ;
    int_do_refresh        = do_refresh                    ;
    int_do_power_down     = do_power_down                 ;
    int_do_self_rfsh      = do_self_rfsh                  ;
    int_do_lmr            = do_lmr                        ;
end

always @ (*)
begin
    int_can_activate    = activate_ok;
    int_can_precharge   = precharge_ok;
    int_can_write       = write_ok;
    int_can_read        = read_ok;
    int_can_refresh     = chip_request_ok;
    int_can_self_rfsh   = chip_request_ok;
    int_can_power_down  = chip_request_ok;
    int_can_lmr         = chip_request_ok;
    int_zq_cal_req      = zq_cal_req;
end

// int_do_self_rfsh register
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        int_do_self_rfsh_r1 <= 1'b0;
    end
    else
    begin
        int_do_self_rfsh_r1 <= int_do_self_rfsh;
    end
end

/*------------------------------------------------------------------------------
    Counter
------------------------------------------------------------------------------*/

// General counter
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        cnt <= 0;
    end
    else
    begin
        if (int_do_activate || int_do_precharge || int_do_precharge_all || int_do_write || int_do_read || int_do_refresh || int_do_lmr)
            //cnt <= 4;
            cnt <= 5;
        else if (cnt != {GENERAL_COUNTER_BIT{1'b1}})
            cnt <= cnt + 1'b1;
    end
end

// tRC counter
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        trc_cnt <= 0;
    end
    else
    begin
        if (int_do_activate)
            //trc_cnt <= 4;
            trc_cnt <= 5;
        else if (trc_cnt != {TRC_COUNTER_BIT{1'b1}})
            trc_cnt <= trc_cnt + 1'b1;
    end
end

// Exit counter used for self refresh
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        exit_cnt <= 0;
    end
    else
    begin
        if (int_do_self_rfsh)
            exit_cnt <= 0;
        else if (!int_do_self_rfsh && int_do_self_rfsh_r1)
            //exit_cnt <= 5;
            exit_cnt <= 6;
        else if (exit_cnt != {EXIT_COUNTER_BIT{1'b1}})
            exit_cnt <= exit_cnt + 1'b1;
    end
end

/*------------------------------------------------------------------------------
    State Machine
------------------------------------------------------------------------------*/

// Banks state machine
always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        state            <= IDLE;
        //prev_state       <= IDLE; // to keep track of previous state
        activate_ok      <= 1'b0;
        precharge_ok     <= 1'b0;
        read_ok          <= 1'b0;
        write_ok         <= 1'b0;
        chip_request_ok  <= 1'b0;
        
        // this signal is used to mask off other per bank activate signals in this current chip
        // because only the first bank of each chip is used to keep track of refresh and power down state
        chip_activate_ok <= 1'b1;
        
        zq_cal_req       <= 1'b0;
        
        // this signal is used to keep track of previous write
        // required because of write to read to precharge violation
        // when write to precharge timing is larger than sum of
        // write to read, read to precharge and precharge to valid delay
        did_write        <= 1'b0;
    end
    else
    begin
        case (state)
            IDLE :
                begin
                    state            <= IDLE;
                    precharge_ok     <= 1'b1;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    chip_activate_ok <= 1'b1;
                    
                    zq_cal_req       <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    // tRP timing cause by precharge and precharge all in IDLE state
                    // counter will reset when there is a precharge all in IDLE state
                    // set more than 3 because of tRPA in DDR2
                    //if (int_do_precharge_all && more_than_3_pch_to_act)
                    if ((int_do_precharge || int_do_precharge_all) && more_than_5_pch_to_act)
                    begin
                        activate_ok     <= 1'b0;
                        chip_request_ok <= 1'b0;
                    end
                    else if (cnt >= pch_to_act)
                    begin
                        activate_ok     <= 1'b1;
                        chip_request_ok <= 1'b1;
                    end
                    else
                    begin
                        activate_ok     <= 1'b0;
                        chip_request_ok <= 1'b0;
                    end
                    
                    if (int_do_activate)
                    begin
                        state            <= ACT;
                        //prev_state       <= IDLE;
                        activate_ok      <= 1'b0;
                        chip_request_ok  <= 1'b0;
                        chip_activate_ok <= 1'b1;
                        
                        //if (less_than_3_act_to_pch  && trc_cnt >= act_to_pch)
                        if (less_than_4_act_to_pch  && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                        
                        //if (less_than_3_bank_active)
                        if (less_than_4_bank_active)
                        begin
                            read_ok  <= 1'b1;
                            write_ok <= 1'b1;
                        end
                        else
                        begin
                            read_ok  <= 1'b0;
                            write_ok <= 1'b0;
                        end
                    end
                    
                    if (int_do_refresh)
                    begin
                        state            <= ARF;
                        //prev_state       <= IDLE;
                        activate_ok      <= 1'b0;
                        precharge_ok     <= 1'b0;
                        read_ok          <= 1'b0;
                        write_ok         <= 1'b0;
                        chip_activate_ok <= 1'b0;
                        
                        chip_request_ok <= 1'b0; // just set to zero because we won't do back-to-back refreshes
                    end
                    
                    if (int_do_power_down)
                    begin
                        state            <= PDN;
                        //prev_state       <= IDLE;
                        activate_ok      <= 1'b0;
                        precharge_ok     <= 1'b0;
                        read_ok          <= 1'b0;
                        write_ok         <= 1'b0;
                        chip_request_ok  <= 1'b0; // just set to zero because we won't do back-to-back power down entry
                        chip_activate_ok <= 1'b0;
                    end
                    
                    if (int_do_self_rfsh)
                    begin
                        state            <= SRF;
                        //prev_state       <= IDLE;
                        activate_ok      <= 1'b0;
                        precharge_ok     <= 1'b0;
                        read_ok          <= 1'b0;
                        write_ok         <= 1'b0;
                        chip_request_ok  <= 1'b0; // just set to zero because we won't do back-to-back self refresh entry
                        chip_activate_ok <= 1'b0;
                    end
                    
                    //if (int_do_lmr)
                    //begin
                    //    state <= LMR;
                    //    prev_state <= IDLE;
                    //    activate_ok  <= 1'b0;
                    //    precharge_ok <= 1'b0;
                    //    read_ok  <= 1'b0;
                    //    write_ok <= 1'b0;
                    //    chip_activate_ok <= 1'b0;
                    //    
                    //    chip_request_ok <= 1'b0; // just set to zero because we won't do back-to-back lmr (maybe?)
                    //end
                end
            ACT :
                begin
                    state            <= ACT;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b1;
                    activate_ok      <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    if (trc_cnt >= act_to_pch)
                        precharge_ok <= 1'b1;
                    else
                        precharge_ok <= 1'b0;
                    
                    if (cnt >= bank_active)
                    begin
                        read_ok  <= 1'b1;
                        write_ok <= 1'b1;
                    end
                    else
                    begin
                        read_ok  <= 1'b0;
                        write_ok <= 1'b0;
                    end
                    
                    if (int_do_activate)
                    begin
                        $write($time);
                        $write(" DDRX Timer Warning: Back to back activate to the same bank detected\n");
                    end
                    
                    if (int_do_write && !int_do_auto_precharge)
                    begin
                        state        <= WR;
                        //prev_state   <= ACT;
                        activate_ok  <= 1'b0;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b1;
                        write_ok     <= 1'b1;
                        
                        //if (less_than_3_wr_to_pch && trc_cnt >= act_to_pch)
                        if (less_than_4_wr_to_pch && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    
                    if (int_do_read && !int_do_auto_precharge)
                    begin
                        state       <= RD;
                        //prev_state  <= ACT;
                        activate_ok <= 1'b0;
                        read_ok     <= 1'b1;
                        write_ok    <= 1'b1;
                        
                        //if (less_than_3_rd_to_pch && trc_cnt >= act_to_pch)
                        if (less_than_4_rd_to_pch && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    
                    if (int_do_write && int_do_auto_precharge)
                    begin
                        state        <= WRAP;
                        //prev_state   <= ACT;
                        activate_ok  <= 1'b0;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        //if (less_than_3_wr_ap_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_wr_ap_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                    end
                    
                    if (int_do_read && int_do_auto_precharge)
                    begin
                        state        <= RDAP;
                        //prev_state   <= ACT;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        //if (less_than_3_rd_ap_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_rd_ap_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                    end
                    
                    if (int_do_precharge || int_do_precharge_all)
                    begin
                        state        <= PCH;
                        //prev_state   <= ACT;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        //if (less_than_3_pch_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_pch_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                        
                        //if (less_than_3_pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                        if (less_than_4_pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                            chip_request_ok <= 1'b1;
                        else
                            chip_request_ok <= 1'b0;
                    end
                end
            WR :
                begin
                    state            <= WR;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b1;
                    activate_ok      <= 1'b0;
                    read_ok          <= 1'b1;
                    write_ok         <= 1'b1;
                    
                    did_write        <= 1'b1;
                    
                    if (cnt >= wr_to_pch && trc_cnt >= act_to_pch)
                        precharge_ok <= 1'b1;
                    else
                        precharge_ok <= 1'b0;
                    
                    if (int_do_write && !int_do_auto_precharge)
                    begin
                        state        <= WR;
                        //prev_state   <= WR;
                        activate_ok  <= 1'b0;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b1;
                        write_ok     <= 1'b1;
                        
                        //if (less_than_3_wr_to_pch && trc_cnt >= act_to_pch)
                        if (less_than_4_wr_to_pch && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    
                    if (int_do_read && !int_do_auto_precharge)
                    begin
                        state        <= RD;
                        //prev_state   <= WR;
                        activate_ok  <= 1'b0;
                        read_ok      <= 1'b1;
                        write_ok     <= 1'b1;
                        
                        // fix for wr - rd - precharge all when tWR is set to a larger value
                        // eg: if tWR is set to 12 and tRP and tWTR is set to 4, read to precharge all happen to soon thus causing timing violation
                        if (compare_wr_to_rd_to_pch_all) // only do this when the wr_to_rd_to_pch_all value is larger than rd_to_pch
                        begin
                            //if (less_than_3_wr_to_rd_to_pch_all && trc_cnt >= act_to_pch)
                            if (less_than_4_wr_to_rd_to_pch_all && trc_cnt >= act_to_pch)
                                precharge_ok <= 1'b1;
                            else
                                precharge_ok <= 1'b0;
                        end
                        else
                        begin
                            //if (less_than_3_rd_to_pch && trc_cnt >= act_to_pch)
                            if (less_than_4_rd_to_pch && trc_cnt >= act_to_pch)
                                precharge_ok <= 1'b1;
                            else
                                precharge_ok <= 1'b0;
                        end
                    end
                    
                    if (int_do_write && int_do_auto_precharge)
                    begin
                        state        <= WRAP;
                        //prev_state   <= WR;
                        activate_ok  <= 1'b0;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        //if (less_than_3_wr_ap_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_wr_ap_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                    end
                    
                    if (int_do_read && int_do_auto_precharge)
                    begin
                        state        <= RDAP;
                        //prev_state   <= WR;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        //if (less_than_3_rd_ap_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_rd_ap_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                    end
                    
                    if (int_do_precharge || int_do_precharge_all)
                    begin
                        state        <= PCH;
                        //prev_state   <= WR;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        //if (less_than_3_pch_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_pch_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                        
                        //if (less_than_3_pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                        if (less_than_4_pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                            chip_request_ok <= 1'b1;
                        else
                            chip_request_ok <= 1'b0;
                    end
                end
            RD :
                begin
                    state            <= RD;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b1;
                    activate_ok      <= 1'b0;
                    read_ok          <= 1'b1;
                    write_ok         <= 1'b1;
                    
                    // fix for wr - rd - precharge all when tWR is set to a larger value
                    // eg: if tWR is set to 12 and tRP and tWTR is set to 4, read to precharge all happen to soon thus causing timing violation
                    //if (prev_state == WR && compare_wr_to_rd_to_pch_all) // only do this when the wr_to_rd_to_pch_all value is larger than rd_to_pch
                    if (did_write && compare_wr_to_rd_to_pch_all) // only do this when the wr_to_rd_to_pch_all value is larger than rd_to_pch
                    begin
                        if (cnt >= wr_to_rd_to_pch_all && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    else
                    begin
                        if (cnt >= rd_to_pch && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    
                    if (int_do_read && !int_do_auto_precharge)
                    begin
                        state        <= RD;
                        //prev_state   <= RD;
                        activate_ok  <= 1'b0;
                        read_ok      <= 1'b1;
                        write_ok     <= 1'b1;
                        
                        did_write    <= 1'b0;
                        
                        //if (less_than_3_rd_to_pch && trc_cnt >= act_to_pch)
                        if (less_than_4_rd_to_pch && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    
                    if (int_do_write && !int_do_auto_precharge)
                    begin
                        state        <= WR;
                        //prev_state   <= RD;
                        activate_ok  <= 1'b0;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b1;
                        write_ok     <= 1'b1;
                        
                        did_write    <= 1'b0;
                        
                        //if (less_than_3_wr_to_pch && trc_cnt >= act_to_pch)
                        if (less_than_4_wr_to_pch && trc_cnt >= act_to_pch)
                            precharge_ok <= 1'b1;
                        else
                            precharge_ok <= 1'b0;
                    end
                    
                    if (int_do_read && int_do_auto_precharge)
                    begin
                        state        <= RDAP;
                        //prev_state   <= RD;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        did_write    <= 1'b0;
                        
                        //if (less_than_3_rd_ap_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_rd_ap_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                    end
                    
                    if (int_do_write && int_do_auto_precharge)
                    begin
                        state        <= WRAP;
                        //prev_state   <= RD;
                        activate_ok  <= 1'b0;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        did_write    <= 1'b0;
                        
                        //if (less_than_3_wr_ap_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_wr_ap_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                    end
                    
                    if (int_do_precharge || int_do_precharge_all)
                    begin
                        state        <= PCH;
                        //prev_state   <= RD;
                        precharge_ok <= 1'b0;
                        read_ok      <= 1'b0;
                        write_ok     <= 1'b0;
                        
                        did_write    <= 1'b0;
                        
                        //if (less_than_3_pch_to_act && trc_cnt >= act_to_act)
                        if (less_than_4_pch_to_act && trc_cnt >= act_to_act)
                            activate_ok  <= 1'b1;
                        else
                            activate_ok  <= 1'b0;
                        
                        //if (less_than_3_pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                        if (less_than_4_pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                            chip_request_ok <= 1'b1;
                        else
                            chip_request_ok <= 1'b0;
                    end
                end
            PCH :
                begin
                    state            <= PCH;
                    chip_activate_ok <= 1'b1;
                    activate_ok      <= 1'b0;
                    precharge_ok     <= 1'b0;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    // we need to make sure that we will not assert activate_ok when there is a back-to-back precharge/precharge all
                    // this will cause a timing violation when pch_to_act is being set to 5
                    if (!int_do_precharge && !int_do_precharge_all)
                    begin
                        if (cnt >= pch_to_act && trc_cnt >= act_to_act)
                        begin
                            state <= IDLE;
                            //prev_state <= PCH;
                            activate_ok  <= 1'b1;
                        end
                        
                        if (cnt >= pch_to_act) // do not check for trc counter because this is used for pdn, arf, srf and lmr
                            chip_request_ok <= 1'b1;
                        else
                            chip_request_ok <= 1'b0;
                        
                        // we will need to cover cases from PCH state to ARF, PDN and SRF state
                        // because we allow state machine to do ARF, PDN SRF (chip_request_ok signal)
                        // even we are still in PCH state counting down tRC
                        if (do_refresh)
                        begin
                            state            <= ARF;
                            activate_ok      <= 1'b0;
                            precharge_ok     <= 1'b0;
                            read_ok          <= 1'b0;
                            write_ok         <= 1'b0;
                            chip_request_ok  <= 1'b0;
                            chip_activate_ok <= 1'b0;
                        end
                        else if (do_power_down)
                        begin
                            state            <= PDN;
                            activate_ok      <= 1'b0;
                            precharge_ok     <= 1'b0;
                            read_ok          <= 1'b0;
                            write_ok         <= 1'b0;
                            chip_request_ok  <= 1'b0;
                            chip_activate_ok <= 1'b0;
                        end
                        else if (do_self_rfsh)
                        begin
                            state            <= SRF;
                            activate_ok      <= 1'b0;
                            precharge_ok     <= 1'b0;
                            read_ok          <= 1'b0;
                            write_ok         <= 1'b0;
                            chip_request_ok  <= 1'b0;
                            chip_activate_ok <= 1'b0;
                        end
                    end
                end
            WRAP : // Write with auto precharge
                begin
                    state            <= WRAP;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b1;
                    activate_ok      <= 1'b0;
                    precharge_ok     <= 1'b0;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    if (cnt >= wr_ap_to_act && trc_cnt >= act_to_act)
                    begin
                        state <= IDLE;
                        //prev_state <= WRAP;
                        activate_ok  <= 1'b1;
                        precharge_ok <= 1'b1;
                        read_ok  <= 1'b0;
                        write_ok <= 1'b0;
                    end
                end
            RDAP : // Read with auto precharge
                begin
                    state            <= RDAP;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b1;
                    activate_ok      <= 1'b0;
                    precharge_ok     <= 1'b0;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    if (cnt >= rd_ap_to_act && trc_cnt >= act_to_act)
                    begin
                        state <= IDLE;
                        //prev_state <= RDAP;
                        activate_ok  <= 1'b1;
                        precharge_ok <= 1'b1;
                        read_ok  <= 1'b0;
                        write_ok <= 1'b0;
                    end
                end
            ARF :
                begin
                    state            <= ARF;
                    activate_ok      <= 1'b0;
                    precharge_ok     <= 1'b0;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    if (cnt >= arf_to_valid)
                    begin
                        state <= IDLE;
                        //prev_state <= ARF;
                        activate_ok  <= 1'b1;
                        precharge_ok <= 1'b0;
                        read_ok  <= 1'b0;
                        write_ok <= 1'b0;
                        chip_request_ok  <= 1'b1;
                        chip_activate_ok <= 1'b1;
                    end
                end
            PDN : // not optimized yet, also need to consider auto refresh transition
                begin
                    state            <= PDN;
                    activate_ok      <= 1'b0;
                    precharge_ok     <= 1'b0;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    if (!int_do_power_down) // power down exit only requires 3 clock cycles
                    begin
                        state <= IDLE;
                        //prev_state <= PDN;
                        activate_ok  <= 1'b1;
                        precharge_ok <= 1'b0;
                        read_ok  <= 1'b0;
                        write_ok <= 1'b0;
                        chip_request_ok  <= 1'b1;
                        chip_activate_ok <= 1'b1;
                    end
                end
            SRF :
                begin
                    state            <= SRF;
                    activate_ok      <= 1'b0;
                    precharge_ok     <= 1'b0;
                    read_ok          <= 1'b0;
                    write_ok         <= 1'b0;
                    chip_request_ok  <= 1'b0;
                    chip_activate_ok <= 1'b0;
                    
                    zq_cal_req       <= 1'b0;
                    
                    did_write        <= 1'b0;
                    
                    if (!int_do_self_rfsh && exit_cnt == srf_to_zq) // DDR3 specific, zq calibration request, only assert for one clock cycle
                        zq_cal_req <= 1'b1;
                    
                    if (!int_do_self_rfsh && exit_cnt > srf_to_valid) // assuming self refresh exit time is 200 clock cycles
                    begin
                        state <= IDLE;
                        //prev_state <= SRF;
                        activate_ok  <= 1'b1;
                        precharge_ok <= 1'b0;
                        read_ok  <= 1'b0;
                        write_ok <= 1'b0;
                        chip_request_ok  <= 1'b1;
                        chip_activate_ok <= 1'b1;
                    end
                end
            //LMR :
            //    begin
            //        if (int_do_lmr)
            //        begin
            //            state <= LMR;
            //            activate_ok  <= 1'b0;
            //            precharge_ok <= 1'b0;
            //            read_ok  <= 1'b0;
            //            write_ok <= 1'b0;
            //            chip_request_ok   <= 1'b0;
            //            chip_activate_ok <= 1'b0;
            //        end
            //        else
            //        begin
            //            if (cnt >= lmr_to_lmr)
            //                chip_request_ok   <= 1'b1;
            //            else
            //                chip_request_ok   <= 1'b0;
            //            
            //            if (cnt >= lmr_to_valid)
            //            begin
            //                state <= IDLE;
            //                prev_state <= LMR;
            //                activate_ok  <= 1'b1;
            //                precharge_ok <= 1'b0;
            //                read_ok  <= 1'b0;
            //                write_ok <= 1'b0;
            //                chip_request_ok   <= 1'b1;
            //                chip_activate_ok <= 1'b1;
            //            end
            //        end
            //    end
            default :
                state <= IDLE;
        endcase
    end
end

endmodule
