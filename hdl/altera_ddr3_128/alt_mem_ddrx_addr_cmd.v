///////////////////////////////////////////////////////////////////////////////
// Title         : (DDR1/2/3,LPDDR1) address and command decoder
//
// File          : alt_mem_ddrx_addr_cmd.v
//
// Abstract      : Address and command decoder
///////////////////////////////////////////////////////////////////////////////

//altera message_off 10036

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_addr_cmd
    # (parameter
        // Global parameters
        CFG_PORT_WIDTH_TYPE           = 3,
        CFG_PORT_WIDTH_OUTPUT_REGD    = 1,
        CFG_MEM_IF_CHIP               = 1,
        CFG_MEM_IF_CKE_WIDTH          = 1,    // same width as CS_WIDTH
        CFG_MEM_IF_ADDR_WIDTH         = 16,   // max supported address bits, must be >= row bits (For ddr3 >=13 even if row=12)
        CFG_MEM_IF_ROW_WIDTH          = 16,   // max supported row bits
        CFG_MEM_IF_COL_WIDTH          = 12,   // max supported column bits
        CFG_MEM_IF_BA_WIDTH           = 3,    // max supported bank bits
        CFG_CTL_RATE                  = "FULL",
        CFG_DWIDTH_RATIO              = 2
    )
    (
        ctl_clk,
        ctl_reset_n,
        ctl_cal_success,
        
        //run-time configuration interface
        cfg_type,
        cfg_output_regd,
        
        cfg_enable_chipsel_for_sideband, // to indicate should we de-assert cs_n for sideband signal (self refresh and deep power down specific)
        
        // AFI interface (Signals from Arbiter block)
        bg_do_write,
        bg_do_read,
        bg_do_burst_chop,
        bg_do_auto_precharge,
        bg_do_activate,
        bg_do_precharge,
        bg_do_precharge_all,
        bg_do_refresh,
        bg_do_self_refresh,
        bg_do_power_down,
        bg_do_zq_cal,
        bg_do_lmr,
        
        bg_do_burst_terminate,     //Currently does not exist in arbiter
        bg_do_deep_pdown,        //Currently does not exist in arbiter
        
        // address information
        bg_to_chip,                    // active high input (one hot)
        bg_to_bank,
        bg_to_row,
        bg_to_col,
        
        bg_to_lmr,            //Currently doesn not exist in arbiter
        lmr_opcode,
        
        //output to PHY
        afi_addr,
        afi_ba,
        afi_cke,
        afi_cs_n,
        afi_ras_n,
        afi_cas_n,
        afi_we_n,
        afi_rst_n
    );
    
    //=================================================================================================//
    //        input/output declaration                                                                 //
    //=================================================================================================//
    
    input ctl_clk;
    input ctl_reset_n;
    input ctl_cal_success;
    
    //run-time configuration input
    input [CFG_PORT_WIDTH_TYPE-1:0] cfg_type;
    input [CFG_PORT_WIDTH_OUTPUT_REGD -1:0] cfg_output_regd;
    
    input cfg_enable_chipsel_for_sideband;
    
    // Arbiter command inputs
    input bg_do_write;
    input bg_do_read;
    input bg_do_burst_chop;
    input bg_do_auto_precharge;
    input bg_do_activate;
    input bg_do_precharge;
    input [CFG_MEM_IF_CHIP-1:0]    bg_do_precharge_all;
    input [CFG_MEM_IF_CHIP-1:0]    bg_do_refresh;
    input [CFG_MEM_IF_CHIP-1:0]    bg_do_self_refresh;
    input [CFG_MEM_IF_CHIP-1:0]    bg_do_power_down;
    input [CFG_MEM_IF_CHIP-1:0]    bg_do_zq_cal;
    input bg_do_lmr;
    
    input bg_do_burst_terminate;
    input [CFG_MEM_IF_CHIP-1:0]    bg_do_deep_pdown;
    
    input   [CFG_MEM_IF_CHIP-1:0]       bg_to_chip;
    input   [CFG_MEM_IF_BA_WIDTH-1:0]   bg_to_bank;
    input   [CFG_MEM_IF_ROW_WIDTH-1:0]  bg_to_row;
    input   [CFG_MEM_IF_COL_WIDTH-1:0]  bg_to_col;
    input   [CFG_MEM_IF_BA_WIDTH-1:0]   bg_to_lmr;
    input   [CFG_MEM_IF_ADDR_WIDTH-1:0] lmr_opcode;
    
    //output
    output  [(CFG_MEM_IF_CKE_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]     afi_cke;
    output  [(CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO/2)) - 1:0]          afi_cs_n;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                              afi_ras_n;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                              afi_cas_n;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                              afi_we_n;
    output  [(CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]      afi_ba;
    output  [(CFG_MEM_IF_ADDR_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]    afi_addr;
    output  [(CFG_DWIDTH_RATIO/2) - 1:0]                              afi_rst_n;
    
    //=================================================================================================//
    //        reg/wire declaration                                                                     //
    //=================================================================================================//
    
    wire bg_do_write;
    wire bg_do_read;
    wire bg_do_burst_chop;
    wire bg_do_auto_precharge;
    wire bg_do_activate;
    wire bg_do_precharge;
    wire [CFG_MEM_IF_CHIP-1:0]    bg_do_precharge_all;
    wire [CFG_MEM_IF_CHIP-1:0]    bg_do_refresh;
    wire [CFG_MEM_IF_CHIP-1:0]    bg_do_self_refresh;
    wire [CFG_MEM_IF_CHIP-1:0]    bg_do_power_down;
    wire [CFG_MEM_IF_CHIP-1:0]    bg_do_zq_cal;
    wire bg_do_lmr;
    
    wire [CFG_MEM_IF_CHIP-1:0]    bg_do_deep_pdown; 
    wire bg_do_burst_terminate;
    
    reg [CFG_MEM_IF_CHIP-1:0]    do_self_refresh;
    reg [CFG_MEM_IF_CHIP-1:0]    do_power_down;
    reg [CFG_MEM_IF_CHIP-1:0]    do_deep_pdown;
    
    reg [CFG_MEM_IF_CHIP-1:0]    do_self_refresh_r;
    reg [CFG_MEM_IF_CHIP-1:0]    do_power_down_r;
    reg [CFG_MEM_IF_CHIP-1:0]    do_deep_pdown_r;
    
    wire  [(CFG_MEM_IF_CKE_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]       afi_cke;
    wire  [(CFG_MEM_IF_CHIP * (CFG_DWIDTH_RATIO/2)) - 1:0]            afi_cs_n;
    wire  [(CFG_DWIDTH_RATIO/2) - 1:0]                                afi_ras_n;
    wire  [(CFG_DWIDTH_RATIO/2) - 1:0]                                afi_cas_n;
    wire  [(CFG_DWIDTH_RATIO/2) - 1:0]                                afi_we_n;
    wire  [(CFG_MEM_IF_BA_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]        afi_ba;
    wire  [(CFG_MEM_IF_ADDR_WIDTH * (CFG_DWIDTH_RATIO/2)) - 1:0]      afi_addr;
    wire  [(CFG_DWIDTH_RATIO/2) - 1:0]                                afi_rst_n;
    
    
    reg   [(CFG_MEM_IF_CKE_WIDTH) - 1:0]     int_cke;
    reg   [(CFG_MEM_IF_CKE_WIDTH) - 1:0]     int_cke_r;
    reg   [(CFG_MEM_IF_CHIP) - 1:0]          int_cs_n;
    reg                                      int_ras_n;
    reg                                      int_cas_n;
    reg                                      int_we_n;
    reg [(CFG_MEM_IF_BA_WIDTH) - 1:0]        int_ba;
    reg [(CFG_MEM_IF_ADDR_WIDTH) - 1:0]      int_addr;
    
    reg [(CFG_MEM_IF_CKE_WIDTH) - 1:0]       combi_cke  ;
    reg [(CFG_MEM_IF_CHIP) - 1:0]            combi_cs_n ;
    reg                                         combi_ras_n;
    reg                                      combi_cas_n;
    reg                                         combi_we_n ;
    reg [(CFG_MEM_IF_BA_WIDTH) - 1:0]        combi_ba   ;
    reg [(CFG_MEM_IF_ADDR_WIDTH) - 1:0]      combi_addr ;
    
    reg [(CFG_MEM_IF_CKE_WIDTH) - 1:0]       combi_cke_r  ;
    reg [(CFG_MEM_IF_CHIP) - 1:0]            combi_cs_n_r ;
    reg                                         combi_ras_n_r;
    reg                                      combi_cas_n_r;
    reg                                         combi_we_n_r ;
    reg [(CFG_MEM_IF_BA_WIDTH) - 1:0]        combi_ba_r   ;
    reg [(CFG_MEM_IF_ADDR_WIDTH) - 1:0]      combi_addr_r ;
    
    wire    [(CFG_MEM_IF_ADDR_WIDTH) - 1:0] int_row;
    wire    [(CFG_MEM_IF_ADDR_WIDTH) - 1:0] temp_col;
    wire    [(CFG_MEM_IF_ADDR_WIDTH) - 1:0] int_col;
    wire                                    col12;
    
    wire     [(CFG_MEM_IF_ADDR_WIDTH) - 1:0] int_col_r;
    
    reg [CFG_MEM_IF_CHIP-1:0]   chip_in_self_refresh;
    
    //=================================================================================================//
    
    generate
        if (CFG_MEM_IF_ADDR_WIDTH > CFG_MEM_IF_ROW_WIDTH)
            begin
                assign int_row      = {{(CFG_MEM_IF_ADDR_WIDTH - CFG_MEM_IF_ROW_WIDTH){1'b0}},bg_to_row};
            end
        else
            begin
                assign int_row      = bg_to_row;
            end
    endgenerate
    
    assign temp_col     = {{(CFG_MEM_IF_ADDR_WIDTH - CFG_MEM_IF_COL_WIDTH){1'b0}},bg_to_col};
    assign afi_rst_n    = {(CFG_DWIDTH_RATIO/2){1'b1}};
    assign col12        = (cfg_type == `MMR_TYPE_DDR3) ? ~bg_do_burst_chop : temp_col[11]; //DDR3
    
    generate
        if (CFG_MEM_IF_ADDR_WIDTH < 13)
            begin
                assign int_col = {temp_col[CFG_MEM_IF_ADDR_WIDTH-1:10],bg_do_auto_precharge,temp_col[9:0]};
            end
        else if (CFG_MEM_IF_ADDR_WIDTH == 13)
            begin
                assign int_col = {col12,temp_col[10],bg_do_auto_precharge,temp_col[9:0]};
            end
        else
            begin
                assign int_col = {temp_col[CFG_MEM_IF_ADDR_WIDTH-3:11],col12,temp_col[10],bg_do_auto_precharge,temp_col[9:0]};
            end
    endgenerate
    
    generate
        if (CFG_DWIDTH_RATIO == 2)
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
                assign afi_cs_n     = {int_cs_n,{CFG_MEM_IF_CHIP{1'b1}}};    // to provide time for addr bus to settle at high freq, cs sent on 2nd phase
                assign afi_ras_n    = {int_ras_n,int_ras_n};
                assign afi_cas_n    = {int_cas_n,int_cas_n};
                assign afi_we_n     = {int_we_n,int_we_n};
                assign afi_ba       = {int_ba,int_ba};
                assign afi_addr     = {int_addr,int_addr};
            end
    endgenerate
    
    always @(posedge ctl_clk, negedge ctl_reset_n)            // aligns cke with cs for slf rfsh & pwrdwn(lpddr1)which is defined only when cs_n goes low
        begin
            if (!ctl_reset_n)
                int_cke_r   <=  {(CFG_MEM_IF_CKE_WIDTH){1'b0}};
            else
                int_cke_r   <=  int_cke;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)            // toogles cs_n for only one cyle when state machine continues to stay in slf rfsh mode
        begin
            if (!ctl_reset_n)
                chip_in_self_refresh   <=  {(CFG_MEM_IF_CHIP){1'b0}};
            else
                if ((bg_do_self_refresh) || (bg_do_deep_pdown && cfg_type == `MMR_TYPE_LPDDR1)) //LPDDDR1
                    chip_in_self_refresh   <=  bg_to_chip;
                else
                    chip_in_self_refresh   <=  {(CFG_MEM_IF_CHIP){1'b0}};
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    combi_cke_r    <=  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                    combi_cs_n_r   <=  {(CFG_MEM_IF_CHIP){1'b1}};
                    combi_ras_n_r  <=  1'b1;
                    combi_cas_n_r  <=  1'b1;
                    combi_we_n_r   <=  1'b1;
                    combi_ba_r     <=  {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                    combi_addr_r   <=  {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                end
            else
                begin
                    combi_cke_r    <=  combi_cke;
                    combi_cs_n_r   <=  combi_cs_n;
                    combi_ras_n_r  <=  combi_ras_n;
                    combi_cas_n_r  <=  combi_cas_n;
                    combi_we_n_r   <=  combi_we_n;
                    combi_ba_r     <=  combi_ba;
                    combi_addr_r   <=  combi_addr;
                end
        end
    
    always @(*)
        begin
            if (cfg_output_regd)
                begin
                    int_cke     =  combi_cke_r;
                    int_cs_n    =  combi_cs_n_r;
                    int_ras_n   =  combi_ras_n_r;
                    int_cas_n   =  combi_cas_n_r;
                    int_we_n    =  combi_we_n_r;
                    int_ba      =  combi_ba_r;
                    int_addr    =  combi_addr_r;
                end
            else
                begin
                    int_cke     =  combi_cke;
                    int_cs_n    =  combi_cs_n;
                    int_ras_n   =  combi_ras_n;
                    int_cas_n   =  combi_cas_n;
                    int_we_n    =  combi_we_n;
                    int_ba      =  combi_ba;
                    int_addr    =  combi_addr;
                end
        end
    
    //CKE generation block
    always @(*)
        begin
            if (ctl_cal_success)
               begin 
                    combi_cke = ~(bg_do_self_refresh | bg_do_power_down | bg_do_deep_pdown);
               end
            else
               begin
                    combi_cke = {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
               end
        end
    
    //Pulse generator for self refresh, power down and deep power down
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    do_self_refresh_r <= {(CFG_MEM_IF_CHIP){1'b0}};
                    do_power_down_r   <= {(CFG_MEM_IF_CHIP){1'b0}};
                    do_deep_pdown_r   <= {(CFG_MEM_IF_CHIP){1'b0}};
                end
            else
                begin
                   do_self_refresh_r <= ~bg_do_self_refresh;
                   do_power_down_r   <= ~bg_do_power_down;
                   do_deep_pdown_r   <= ~bg_do_deep_pdown;
                end
        end
    
    always @(*)
         begin
            do_self_refresh = bg_do_self_refresh & do_self_refresh_r;
            do_power_down   = bg_do_power_down & do_power_down_r;
            do_deep_pdown   = bg_do_deep_pdown & do_deep_pdown_r;
         end
    
    always @(*)        //All Command inputs are mutually exclusive
        begin
            if (ctl_cal_success)
                begin
                    // combi_cke     =   {(CFG_MEM_IF_CKE_WIDTH){1'b1}};        //Should we put default condition into if(!bg_do_refresh && !bg_do_activate....)??
                    combi_cs_n    =   {(CFG_MEM_IF_CHIP){1'b1}};
                    combi_ras_n   =   1'b1;
                    combi_cas_n   =   1'b1;
                    combi_we_n    =   1'b1;
                    combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                    combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                    
                    if (|bg_do_refresh)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~bg_do_refresh;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b1;
                            combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                            combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                        end
                    
                    if (|bg_do_precharge_all)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~bg_do_precharge_all;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b0;
                            combi_ba      =  bg_to_bank;
                            combi_addr[10]=  1'b1;
                        end
                    
                    if (bg_do_activate)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~bg_to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b1;
                            combi_ba      =  bg_to_bank;
                            combi_addr    =  int_row;
                        end
                    
                    if (bg_do_precharge)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~bg_to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b0;
                            combi_ba      =  bg_to_bank;
                            combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                        end
                    
                    if (bg_do_write)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~bg_to_chip;
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b0;
                            combi_ba      =  bg_to_bank;
                            combi_addr    =  int_col;
                        end
                    
                    if (bg_do_read)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                            combi_cs_n    =  ~bg_to_chip;
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b1;
                            combi_ba      =  bg_to_bank;
                            combi_addr    =  int_col;
                        end
                    
                    if (|do_power_down)
                        begin
                            // combi_cke     =  ~bg_to_chip;
                            combi_cs_n    =  {(CFG_MEM_IF_CHIP){1'b1}};
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b1;
                            combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                            combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                      end
                    
                    if (|do_deep_pdown)                                    //Put assertion for memory type ddr2 and ddr3 as an error
                        begin
                            // combi_cke     =  ~bg_to_chip;
                            if (cfg_enable_chipsel_for_sideband)
                                begin
                                    combi_cs_n    =  ~do_deep_pdown;                // toogles cs_n for only one cyle when state machine continues to stay in slf rfsh mode
                                end
                            else
                                begin
                                    combi_cs_n    =  {(CFG_MEM_IF_CHIP){1'b1}};
                                end
                            
                            combi_ras_n   =  1'b1;
                            combi_cas_n   =  1'b1;
                            combi_we_n    =  1'b0;
                            combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                            combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                      end
                    
                    if (|do_self_refresh)
                        begin
                            // combi_cke     =  ~bg_to_chip;
                            if (cfg_enable_chipsel_for_sideband)
                                begin
                                    combi_cs_n    =  ~do_self_refresh;                // toogles cs_n for only one cyle when state machine continues to stay in slf rfsh mode
                                end
                            else
                                begin
                                    combi_cs_n    =  {(CFG_MEM_IF_CHIP){1'b1}};
                                end
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b1;
                            combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                            combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                        end
                    
                    if (|bg_do_zq_cal) // Only short zqcal supported
                        begin
                            if (cfg_type == `MMR_TYPE_DDR3) //DDR3
                                begin
                                    // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                                    combi_cs_n    =  ~bg_do_zq_cal;
                                    combi_ras_n   =  1'b1;
                                    combi_cas_n   =  1'b1;
                                    combi_we_n    =  1'b0;
                                    combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                                    combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                                end
                            else // Should we flag error or issue as NOP
                                begin
                                    // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                                    combi_cs_n    =  {(CFG_MEM_IF_CHIP){1'b1}};
                                    combi_ras_n   =  1'b1;
                                    combi_cas_n   =  1'b1;
                                    combi_we_n    =  1'b1;
                                    combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                                    combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                                end
                        end
                    if (bg_do_lmr)
                        begin
                            // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};                // to support chng rfsh time based on temp
                            combi_cs_n    =  ~bg_to_chip;
                            combi_ras_n   =  1'b0;
                            combi_cas_n   =  1'b0;
                            combi_we_n    =  1'b0;
                            combi_ba      =  bg_to_lmr;
                            combi_addr    =  lmr_opcode;
                        end
                    if (bg_do_burst_terminate)
                        begin
                            if (cfg_type == `MMR_TYPE_LPDDR1) //lpddr1
                                begin
                                    // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                                    combi_cs_n    =  ~bg_to_chip;
                                    combi_ras_n   =  1'b1;
                                    combi_cas_n   =  1'b1;
                                    combi_we_n    =  1'b0;
                                    combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                                    combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                                end
                            else
                                begin
                                    // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                                    combi_cs_n    =  {(CFG_MEM_IF_CHIP){1'b1}};
                                    combi_ras_n   =  1'b1;
                                    combi_cas_n   =  1'b1;
                                    combi_we_n    =  1'b1;
                                    combi_ba      =   {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                                    combi_addr    =   {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                                end
                        end
                end
            else
                begin
                    // combi_cke     =  {(CFG_MEM_IF_CKE_WIDTH){1'b1}};
                    combi_cs_n    =  {(CFG_MEM_IF_CHIP){1'b1}};
                    combi_ras_n   =  1'b1;
                    combi_cas_n   =  1'b1;
                    combi_we_n    =  1'b1;
                    combi_ba      =  {(CFG_MEM_IF_BA_WIDTH){1'b0}};
                    combi_addr    =  {(CFG_MEM_IF_ADDR_WIDTH){1'b0}};
                end
        end

endmodule
