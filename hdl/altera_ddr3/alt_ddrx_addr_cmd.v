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
// Title         : DDR controller address and command decoder
//
// File          : alt_ddrx_addr_cmd.v
//
// Abstract      : Address and command decoder
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_addr_cmd
    # (parameter
    
        // memory interface bus sizing parameters
        MEM_IF_CS_WIDTH     = 1,
        MEM_IF_CKE_WIDTH    = 1,  // same width as CS_WIDTH
        MEM_IF_ADDR_WIDTH   = 13, // max supported address bits, must be >= row bits
        MEM_IF_ROW_WIDTH    = 13, // max supported row bits
        MEM_IF_COL_WIDTH    = 10, // max supported column bits  
        MEM_IF_BA_WIDTH     = 3,  // max supported bank bits
        MEM_TYPE            = "DDR2",
        MEM_IF_PCHADDR_BIT  = 10,
        CTL_OUTPUT_REGD     = 0,
        DWIDTH_RATIO        = 2
    
    )
    (
    
        ctl_clk,
        ctl_reset_n,
        ctl_cal_success,
        
        // state machine command inputs
        do_write,
        do_read,
        do_auto_precharge,
        do_burst_chop,
        do_activate,
        do_precharge,
        do_refresh,
        do_power_down,
        do_self_rfsh,
        do_lmr,
        do_precharge_all,
        do_zqcal,
        
        // address information
        to_chip, // active high input (one hot)
        to_bank_addr,
        to_row_addr,
        to_col_addr,
        
        //output
        afi_cke,
        afi_cs_n,
        afi_ras_n,
        afi_cas_n,
        afi_we_n,
        afi_ba,
        afi_addr,
        afi_rst_n
    );
    
    input ctl_clk;
    input ctl_reset_n;
    input ctl_cal_success;
    
    // state machine command inputs
    input do_write;
    input do_read;
    input do_auto_precharge;
    input do_burst_chop;
    input do_activate;
    input do_precharge;
    input do_refresh;
    input do_power_down;
    input do_self_rfsh;
    input do_lmr;
    input do_precharge_all;
    input do_zqcal;
    
    input   [MEM_IF_CS_WIDTH-1:0]   to_chip;
    input   [MEM_IF_BA_WIDTH-1:0]   to_bank_addr;
    input   [MEM_IF_ROW_WIDTH-1:0]  to_row_addr;
    input   [MEM_IF_COL_WIDTH-1:0]  to_col_addr;
    
    //output
    output  [(MEM_IF_CKE_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_cke;
    output  [(MEM_IF_CS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_cs_n;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_ras_n;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_cas_n;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_we_n;
    output  [(MEM_IF_BA_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_ba;
    output  [(MEM_IF_ADDR_WIDTH * (DWIDTH_RATIO/2)) - 1:0]  afi_addr;
    output  [(DWIDTH_RATIO/2) - 1:0]                        afi_rst_n;
    
    wire do_write;
    wire do_read;
    wire do_activate;
    wire do_precharge;
    wire do_refresh;
    wire do_power_down;
    wire do_self_rfsh;
    wire do_lmr;
    wire do_auto_precharge;
    wire do_precharge_all;
    
    wire    [(MEM_IF_CKE_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_cke;
    wire    [(MEM_IF_CS_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_cs_n;
    wire    [(DWIDTH_RATIO/2) - 1:0]                        afi_ras_n;
    wire    [(DWIDTH_RATIO/2) - 1:0]                        afi_cas_n;
    wire    [(DWIDTH_RATIO/2) - 1:0]                        afi_we_n;
    wire    [(MEM_IF_BA_WIDTH * (DWIDTH_RATIO/2)) - 1:0]    afi_ba;
    wire    [(MEM_IF_ADDR_WIDTH * (DWIDTH_RATIO/2)) - 1:0]  afi_addr;
    wire    [(DWIDTH_RATIO/2) - 1:0]                        afi_rst_n;
    
    reg [(MEM_IF_CKE_WIDTH) - 1:0]      int_cke;
    reg [(MEM_IF_CKE_WIDTH) - 1:0]      int_cke_r;
    reg [(MEM_IF_CS_WIDTH) - 1:0]       int_cs_n;
    reg                                 int_ras_n;
    reg                                 int_cas_n;
    reg                                 int_we_n;
    reg [(MEM_IF_BA_WIDTH) - 1:0]       int_ba;
    reg [(MEM_IF_ADDR_WIDTH) - 1:0]     int_addr;
    
    reg [(MEM_IF_CKE_WIDTH) - 1:0]      combi_cke;
    reg [(MEM_IF_CS_WIDTH) - 1:0]       combi_cs_n;
    reg                                 combi_ras_n;
    reg                                 combi_cas_n;
    reg                                 combi_we_n;
    reg [(MEM_IF_BA_WIDTH) - 1:0]       combi_ba;
    reg [(MEM_IF_ADDR_WIDTH) - 1:0]     combi_addr;
    
    wire    [(MEM_IF_ADDR_WIDTH) - 1:0] int_row;
    wire    [(MEM_IF_ADDR_WIDTH) - 1:0] temp_col;
    wire    [(MEM_IF_ADDR_WIDTH) - 1:0] int_col;

    reg [MEM_IF_CS_WIDTH-1:0]   chip_in_self_rfsh;
    
    assign int_row = {{(MEM_IF_ADDR_WIDTH - MEM_IF_ROW_WIDTH){1'b0}},to_row_addr};
    assign temp_col = {{(MEM_IF_ADDR_WIDTH - MEM_IF_COL_WIDTH){1'b0}},to_col_addr};
    assign afi_rst_n = {(DWIDTH_RATIO/2){1'b1}};
    
    generate
        if (MEM_TYPE == "DDR3" && MEM_IF_ADDR_WIDTH-3 < 11)
            assign int_col = {~do_burst_chop,temp_col[10:MEM_IF_PCHADDR_BIT],do_auto_precharge,temp_col[MEM_IF_PCHADDR_BIT-1:0]};
        else if (MEM_TYPE == "DDR3")
            assign int_col = {temp_col[MEM_IF_ADDR_WIDTH-3:11],~do_burst_chop,temp_col[10:MEM_IF_PCHADDR_BIT],do_auto_precharge,temp_col[MEM_IF_PCHADDR_BIT-1:0]};
        else if (MEM_IF_ADDR_WIDTH-2 < MEM_IF_PCHADDR_BIT)
            assign int_col = {do_auto_precharge,temp_col[MEM_IF_PCHADDR_BIT-1:0]};
        else
            assign int_col = {temp_col[MEM_IF_ADDR_WIDTH-2:MEM_IF_PCHADDR_BIT],do_auto_precharge,temp_col[MEM_IF_PCHADDR_BIT-1:0]};
    endgenerate
    
    generate
        if (DWIDTH_RATIO == 2)
            begin
                assign afi_cke      = int_cke;
                assign afi_cs_n     = int_cs_n;
                assign afi_ras_n    = int_ras_n;
                assign afi_cas_n    = int_cas_n;
                assign afi_we_n     = int_we_n;
                assign afi_ba       = int_ba;
                assign afi_addr     = int_addr;
            end
        else
            begin
                assign afi_cke      = {int_cke,int_cke_r};
                assign afi_cs_n     = {int_cs_n,{MEM_IF_CS_WIDTH{1'b1}}};
                assign afi_ras_n    = {int_ras_n,int_ras_n};
                assign afi_cas_n    = {int_cas_n,int_cas_n};
                assign afi_we_n     = {int_we_n,int_we_n};
                assign afi_ba       = {int_ba,int_ba};
                assign afi_addr     = {int_addr,int_addr};
            end
    endgenerate
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_cke_r   <=  {(MEM_IF_CKE_WIDTH){1'b0}};
            else
                int_cke_r   <=  int_cke;
        end
   
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                chip_in_self_rfsh   <=  {(MEM_IF_CS_WIDTH){1'b0}};
            else
                if (do_self_rfsh)
                    chip_in_self_rfsh   <=  to_chip;
                else
                    chip_in_self_rfsh   <=  {(MEM_IF_CS_WIDTH){1'b0}};
        end
   


    generate
        if (CTL_OUTPUT_REGD == 1)
            begin
                always @(posedge ctl_clk, negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            begin
                                int_cke     <=  {(MEM_IF_CKE_WIDTH){1'b1}};
                                int_cs_n    <=  {(MEM_IF_CS_WIDTH){1'b1}};
                                int_ras_n   <=  1'b1;
                                int_cas_n   <=  1'b1;
                                int_we_n    <=  1'b1;
                                int_ba      <=  {(MEM_IF_BA_WIDTH){1'b0}};
                                int_addr    <=  {(MEM_IF_ADDR_WIDTH){1'b0}};
                            end
                        else
                            begin
                                int_cke     <=  combi_cke;
                                int_cs_n    <=  combi_cs_n;
                                int_ras_n   <=  combi_ras_n;
                                int_cas_n   <=  combi_cas_n;
                                int_we_n    <=  combi_we_n;
                                int_ba      <=  combi_ba;
                                int_addr    <=  combi_addr;
                            end
                    end
            end
        else // no register
            begin
                always @(*)
                    begin
                        int_cke     <=  combi_cke;
                        int_cs_n    <=  combi_cs_n;
                        int_ras_n   <=  combi_ras_n;
                        int_cas_n   <=  combi_cas_n;
                        int_we_n    <=  combi_we_n;
                        int_ba      <=  combi_ba;
                        int_addr    <=  combi_addr;
                    end
            end
    endgenerate
    
    always @(*)
        begin
            if (ctl_cal_success)
                begin
                    combi_cke     =   {(MEM_IF_CKE_WIDTH){1'b1}};
                    combi_cs_n    =   {(MEM_IF_CS_WIDTH){1'b1}};
                    combi_ras_n   =   1'b1;
                    combi_cas_n   =   1'b1;
                    combi_we_n    =   1'b1;
                    combi_ba      =   {(MEM_IF_BA_WIDTH){1'b0}};
                    combi_addr    =   {(MEM_IF_ADDR_WIDTH){1'b0}};
                    
                    if (do_refresh)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b1;
                        end
                    
                    if (do_precharge_all)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b0;
                            combi_ba      =  to_bank_addr;
                            combi_addr[10]=  1'b1;
                        end
                    
                    if (do_activate)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b1;
                            combi_ba      =  to_bank_addr;
                            combi_addr    =  int_row;
                        end
                    
                    if (do_precharge)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b0;
                            combi_ba      =  to_bank_addr;
                        end
                    
                    if (do_write)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b0;
                            combi_ba      =  to_bank_addr;
                            combi_addr    =  int_col;
                        end
                    
                    if (do_read)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b1;
                            combi_ba      =  to_bank_addr;
                            combi_addr    =  int_col;
                        end
                    
                    if (do_power_down)
                        begin
                            combi_cke     =  ~to_chip;
                            combi_cs_n    =  {(MEM_IF_CS_WIDTH){1'b1}};
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b1;
                        end
                    
                    if (do_self_rfsh)
                        begin
                            combi_cke     =  ~to_chip;
                            combi_cs_n    =  (~to_chip | chip_in_self_rfsh);
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b1;
                        end
                    
                    if (do_zqcal)
                        begin
                            combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~to_chip;
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b0;
                            combi_addr[10]=  1'b0; // short ZQcal
                        end
                end
            else
                begin
                    combi_cke     =  {(MEM_IF_CKE_WIDTH){1'b1}};
                    combi_cs_n    =  {(MEM_IF_CS_WIDTH){1'b1}};
                    combi_ras_n   =  1'b1;
                    combi_cas_n   =  1'b1;
                    combi_we_n    =  1'b1;
                    combi_ba      =  {(MEM_IF_BA_WIDTH){1'b0}};
                    combi_addr    =  {(MEM_IF_ADDR_WIDTH){1'b0}};
                end
        end

endmodule
