
//altera message_off 10230

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_burst_gen #
    ( parameter
        CFG_DWIDTH_RATIO                        =   4,
        CFG_CTL_ARBITER_TYPE                    =   "ROWCOL",
        CFG_REG_GRANT                           =   0,
        CFG_MEM_IF_CHIP                         =   1,
        CFG_MEM_IF_CS_WIDTH                     =   1,
        CFG_MEM_IF_BA_WIDTH                     =   3,
        CFG_MEM_IF_ROW_WIDTH                    =   13,
        CFG_MEM_IF_COL_WIDTH                    =   10,
        CFG_LOCAL_ID_WIDTH                      =   10,
        CFG_DATA_ID_WIDTH                       =   10,
        CFG_INT_SIZE_WIDTH                      =   4,
        CFG_AFI_INTF_PHASE_NUM                  =   2,
        CFG_PORT_WIDTH_TYPE                     =   3,
        CFG_PORT_WIDTH_BURST_LENGTH             =   5,
        CFG_PORT_WIDTH_TCCD                     =   4,
        CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT   =   1,
        CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE   =   1,
        CFG_ENABLE_BURST_GEN_OUTPUT_REG         =   0
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // MMR Interface
        cfg_type,
        cfg_burst_length,
        cfg_tccd,
        cfg_enable_burst_interrupt,
        cfg_enable_burst_terminate,
        
        // Arbiter Interface
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
        arb_size,
        
        // AFI Interface
        bg_do_write_combi,
        bg_do_read_combi,
        bg_do_burst_chop_combi,
        bg_do_burst_terminate_combi,
        bg_do_activate_combi,
        bg_do_precharge_combi,
        bg_to_chip_combi,
        bg_effective_size_combi,
        bg_interrupt_ready_combi,

        bg_do_write,
        bg_do_read,
        bg_do_burst_chop,
        bg_do_burst_terminate,
        bg_do_auto_precharge,
        bg_do_rmw_correct,
        bg_do_rmw_partial,
        bg_do_activate,
        bg_do_precharge,
        bg_do_precharge_all,
        bg_do_refresh,
        bg_do_self_refresh,
        bg_do_power_down,
        bg_do_deep_pdown,
        bg_do_zq_cal,
        bg_do_lmr,
        bg_to_chipsel,
        bg_to_chip,
        bg_to_bank,
        bg_to_row,
        bg_to_col,
        bg_doing_write,
        bg_doing_read,
        bg_rdwr_data_valid,
        bg_interrupt_ready,
        bg_localid,
        bg_dataid,
        bg_size,
        bg_effective_size
    );

localparam AFI_INTF_LOW_PHASE  = 0;
localparam AFI_INTF_HIGH_PHASE = 1;

input                                                            ctl_clk;
input                                                            ctl_reset_n;

// MMR Interface
input  [CFG_PORT_WIDTH_TYPE                             - 1 : 0] cfg_type;
input  [CFG_PORT_WIDTH_BURST_LENGTH                     - 1 : 0] cfg_burst_length;
input  [CFG_PORT_WIDTH_TCCD                             - 1 : 0] cfg_tccd;
input  [CFG_PORT_WIDTH_ENABLE_BURST_INTERRUPT           - 1 : 0] cfg_enable_burst_interrupt;
input  [CFG_PORT_WIDTH_ENABLE_BURST_TERMINATE           - 1 : 0] cfg_enable_burst_terminate;

// Arbiter Interface
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_write;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_read;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_chop;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_burst_terminate;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_auto_precharge;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_correct;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_rmw_partial;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_activate;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_precharge;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_precharge_all;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_refresh;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_self_refresh;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_power_down;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_deep_pdown;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_do_zq_cal;
input  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] arb_do_lmr;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] arb_to_chipsel;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] arb_to_chip;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] arb_to_bank;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] arb_to_row;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] arb_to_col;
input  [CFG_LOCAL_ID_WIDTH                              - 1 : 0] arb_localid;
input  [CFG_DATA_ID_WIDTH                               - 1 : 0] arb_dataid;
input  [CFG_INT_SIZE_WIDTH                              - 1 : 0] arb_size;

// AFI Interface
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write_combi;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read_combi;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop_combi;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate_combi;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate_combi;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge_combi;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip_combi;
output [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_effective_size_combi;
output                                                           bg_interrupt_ready_combi;

output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_auto_precharge;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_correct;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_partial;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_precharge_all;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_refresh;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_self_refresh;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_power_down;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_deep_pdown;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_zq_cal;
output [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_lmr;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] bg_to_chipsel;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] bg_to_bank;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] bg_to_row;
output [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] bg_to_col;
output                                                           bg_doing_write;
output                                                           bg_doing_read;
output                                                           bg_rdwr_data_valid;
output                                                           bg_interrupt_ready;
output [CFG_LOCAL_ID_WIDTH                              - 1 : 0] bg_localid;
output [CFG_DATA_ID_WIDTH                               - 1 : 0] bg_dataid;
output [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_size;
output [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_effective_size;

//--------------------------------------------------------------------------------------------------------
//
//  [START] Register & Wires
//
//--------------------------------------------------------------------------------------------------------
    // AFI Interface
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_auto_precharge;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_correct;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_rmw_partial;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_precharge_all;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_refresh;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_self_refresh;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_power_down;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_deep_pdown;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_do_zq_cal;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_lmr;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CS_WIDTH)  - 1 : 0] bg_to_chipsel;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_BA_WIDTH)  - 1 : 0] bg_to_bank;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_ROW_WIDTH) - 1 : 0] bg_to_row;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] bg_to_col;
    reg                                                            bg_doing_write;
    reg                                                            bg_doing_read;
    reg                                                            bg_rdwr_data_valid;
    reg                                                            bg_interrupt_ready;
    reg  [CFG_LOCAL_ID_WIDTH                              - 1 : 0] bg_localid;
    reg  [CFG_DATA_ID_WIDTH                               - 1 : 0] bg_dataid;
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_size;
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_effective_size;
    
    // Burst generation logic
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] int_size;
    reg  [CFG_DATA_ID_WIDTH                               - 1 : 0] int_dataid;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] int_to_col;
    reg  [2                                                   : 0] int_col_address;
    reg  [2                                                   : 0] int_address_left;
    reg                                                            int_do_row_req;
    reg                                                            int_do_col_req;
    reg                                                            int_do_rd_req;
    reg                                                            int_do_wr_req;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] int_do_burst_chop;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] int_do_rmw_correct;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] int_do_rmw_partial;
    
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] size;
    reg  [CFG_DATA_ID_WIDTH                               - 1 : 0] dataid;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] to_col;
    reg  [2                                                   : 0] col_address;
    reg  [2                                                   : 0] address_left;
    reg                                                            do_row_req;
    reg                                                            do_col_req;
    reg                                                            do_rd_req;
    reg                                                            do_wr_req;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] do_burst_chop;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] do_rmw_correct;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] do_rmw_partial;
    
    reg  [3 : 0] max_local_burst_size;
    reg  [3 : 0] max_local_burst_size_divide_2;
    reg  [3 : 0] max_local_burst_size_minus_2;
    reg  [3 : 0] max_local_burst_size_divide_2_and_minus_2;
    
    reg  [3 : 0] burst_left;
    reg          current_valid;
    reg          delayed_valid;
    reg          combined_valid;
    
    reg  [3 : 0] max_burst_left;
    reg          delayed_doing;
    reg          last_is_write;
    reg          last_is_read;
    
    // Burst interrupt logic
    reg [CFG_PORT_WIDTH_TCCD - 2 : 0] n_prefetch;
    reg                               int_allow_interrupt;
    reg                               int_interrupt_enable_ready;
    reg                               int_interrupt_disable_ready;
    reg                               int_interrupt_gate;
    
    // Burst terminate logic
    reg                              int_allow_terminate;
    reg                              int_do_burst_terminate;
    reg [CFG_INT_SIZE_WIDTH - 1 : 0] int_effective_size;
    reg                              int_do_req;
    reg                              doing_burst_terminate;
    reg                              terminate_doing;
    
    // RMW Info
    reg  [CFG_AFI_INTF_PHASE_NUM - 1 : 0] delayed_do_rmw_correct;
    reg  [CFG_AFI_INTF_PHASE_NUM - 1 : 0] delayed_do_rmw_partial;
    reg  [CFG_AFI_INTF_PHASE_NUM - 1 : 0] combined_do_rmw_correct;
    reg  [CFG_AFI_INTF_PHASE_NUM - 1 : 0] combined_do_rmw_partial;
    
    // Data ID
    reg  [CFG_DATA_ID_WIDTH - 1 : 0] delayed_dataid;
    reg  [CFG_DATA_ID_WIDTH - 1 : 0] combined_dataid;
    
    // Column address
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_COL_WIDTH) - 1 : 0] modified_to_col;
    
    // Common
    wire zero = 1'b0;
    
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_write_combi;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_read_combi;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_chop_combi;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_burst_terminate_combi;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_activate_combi;
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] bg_do_precharge_combi;
    reg  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP)      - 1 : 0] bg_to_chip_combi;
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] bg_effective_size_combi;
    reg                                                            bg_interrupt_ready_combi;
    
    reg  [CFG_AFI_INTF_PHASE_NUM                          - 1 : 0] do_burst_terminate;
    reg                                                            doing_write;
    reg                                                            doing_read;
    reg                                                            rdwr_data_valid;
    reg                                                            interrupt_ready;
    reg  [CFG_INT_SIZE_WIDTH                              - 1 : 0] effective_size;
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Register & Wires
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Outputs
//
//--------------------------------------------------------------------------------------------------------

    // Do signals
    generate
        if (CFG_ENABLE_BURST_GEN_OUTPUT_REG == 1)
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (! ctl_reset_n)
                begin
                    bg_do_write           <= 0;
                    bg_do_read            <= 0;
                    bg_do_auto_precharge  <= 0;
                    bg_do_rmw_correct     <= 0;
                    bg_do_rmw_partial     <= 0;
                    bg_do_activate        <= 0;
                    bg_do_precharge       <= 0;
                    bg_do_precharge_all   <= 0;
                    bg_do_refresh         <= 0;
                    bg_do_self_refresh    <= 0;
                    bg_do_power_down      <= 0;
                    bg_do_deep_pdown      <= 0;
                    bg_do_zq_cal          <= 0;
                    bg_do_lmr             <= 0;
                    bg_to_chip            <= 0;
                    bg_to_chipsel         <= 0;
                    bg_to_bank            <= 0;
                    bg_to_row             <= 0;
                    bg_localid            <= 0;
                    bg_size               <= 0;
                    bg_to_col             <= 0;
                    bg_dataid             <= 0;
                    bg_do_burst_chop      <= 0;
                    bg_do_burst_terminate <= 0;
                    bg_doing_write        <= 0;
                    bg_doing_read         <= 0;
                    bg_rdwr_data_valid    <= 0;
                    bg_interrupt_ready    <= 0;
                    bg_effective_size     <= 0;
                end
                else
                begin
                    bg_do_write           <= arb_do_write;
                    bg_do_read            <= arb_do_read;
                    bg_do_auto_precharge  <= arb_do_auto_precharge;
                    bg_do_rmw_correct     <= combined_do_rmw_correct;
                    bg_do_rmw_partial     <= combined_do_rmw_partial;
                    bg_do_activate        <= arb_do_activate;
                    bg_do_precharge       <= arb_do_precharge;
                    bg_do_precharge_all   <= arb_do_precharge_all;
                    bg_do_refresh         <= arb_do_refresh;
                    bg_do_self_refresh    <= arb_do_self_refresh;
                    bg_do_power_down      <= arb_do_power_down;
                    bg_do_deep_pdown      <= arb_do_deep_pdown;
                    bg_do_zq_cal          <= arb_do_zq_cal;
                    bg_do_lmr             <= arb_do_lmr;
                    bg_to_chip            <= arb_to_chip;
                    bg_to_chipsel         <= arb_to_chipsel;
                    bg_to_bank            <= arb_to_bank;
                    bg_to_row             <= arb_to_row;
                    bg_localid            <= arb_localid;
                    bg_size               <= arb_size;
                    bg_to_col             <= modified_to_col;
                    bg_dataid             <= combined_dataid;
                    bg_do_burst_chop      <= do_burst_chop;
                    bg_do_burst_terminate <= do_burst_terminate;
                    bg_doing_write        <= doing_write;
                    bg_doing_read         <= doing_read;
                    bg_rdwr_data_valid    <= rdwr_data_valid;
                    bg_interrupt_ready    <= interrupt_ready;
                    bg_effective_size     <= effective_size;
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                bg_do_write           = arb_do_write;
                bg_do_read            = arb_do_read;
                bg_do_auto_precharge  = arb_do_auto_precharge;
                bg_do_activate        = arb_do_activate;
                bg_do_precharge       = arb_do_precharge;
                bg_do_precharge_all   = arb_do_precharge_all;
                bg_do_refresh         = arb_do_refresh;
                bg_do_self_refresh    = arb_do_self_refresh;
                bg_do_power_down      = arb_do_power_down;
                bg_do_deep_pdown      = arb_do_deep_pdown;
                bg_do_zq_cal          = arb_do_zq_cal;
                bg_do_lmr             = arb_do_lmr;
                bg_to_chip            = arb_to_chip;
                bg_to_chipsel         = arb_to_chipsel;
                bg_to_bank            = arb_to_bank;
                bg_to_row             = arb_to_row;
                bg_localid            = arb_localid;
                bg_size               = arb_size;
                bg_do_burst_chop      = do_burst_chop;
                bg_do_burst_terminate = do_burst_terminate;
                bg_doing_write        = doing_write;
                bg_doing_read         = doing_read;
                bg_rdwr_data_valid    = rdwr_data_valid;
                bg_interrupt_ready    = interrupt_ready;
                bg_effective_size     = effective_size;
            end
            
            // To column
            always @ (*)
            begin
                bg_to_col = modified_to_col;
            end
            
            // RMW info
            always @ (*)
            begin
                bg_do_rmw_correct = combined_do_rmw_correct;
                bg_do_rmw_partial = combined_do_rmw_partial;
            end
            
            // Data ID
            always @ (*)
            begin
                bg_dataid = combined_dataid;
            end
        end
    endgenerate
    
    // Regardless whether CFG_ENABLE_BURST_GEN_OUTPUT_REG is 1/0 
    // following signals (inputs to rank_timer) need to be combi
    always @ (*)
    begin
        bg_do_write_combi           = arb_do_write;
        bg_do_read_combi            = arb_do_read;
        bg_do_burst_chop_combi      = do_burst_chop;
        bg_do_burst_terminate_combi = do_burst_terminate;
        bg_do_activate_combi        = arb_do_activate;
        bg_do_precharge_combi       = arb_do_precharge;
        bg_to_chip_combi            = arb_to_chip;
        bg_effective_size_combi     = effective_size;
        bg_interrupt_ready_combi    = interrupt_ready;
    end
//--------------------------------------------------------------------------------------------------------
//
//  [END] Outputs
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Burst Generation Logic
//  
//  Doing read/write signal will indicate the "FULL" burst duration of a request
//  Data Valid signal will indicate "VALID" burst duration of a request
//  
//  Example: Without address shifting (maximum local burst size of 4)
//  
//  Clock                          ____/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
//  
//  Input Request                  ----X W R X-----------------X W R X-----------------X W R X-----------------X W R X-----------------------
//  Input Column Address [2 : 0]   ----X  0  X-----------------X  0  X-----------------X  0  X-----------------X  0  X-----------------------
//  Input Size                     ----X  1  X-----------------X  2  X-----------------X  3  X-----------------X  4  X-----------------------
//  
//  Output Column Address [2 : 0]  ----X  0  X-----------------X  0  X-----------------X  0  X-----------------X  0  X-----------------------
//  Output Doing Signal            ____/  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  \_____
//  Output Valid Signal            ____/  1  \_________________/  1  X  2  \___________/  1  X  2  X  3  \_____/  1  X  2  X  3  X  4  \_____
//  
//  Example: With address shifting (maximum local burst size of 4)
//  
//  Clock                          ____/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
//  
//  Input Request                  ----X W R X-----------------X W R X-----------------X W R X-----------------------
//  Input Column Address [2 : 0]   ----X  1  X-----------------X  2  X-----------------X  2  X-----------------------
//  Input Size                     ----X  1  X-----------------X  1  X-----------------X  2  X-----------------------
//  
//  Output Column Address [2 : 0]  ----X  0  X-----------------X  0  X-----------------X  0  X-----------------------
//  Output Doing Signal            ____/  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  \_____
//  Output Valid Signal            __________/  1  \_______________________/  1  \_________________/  1  X  2  \_____
//                                     <----->                 <----------->           <----------->
//                                     Offset                     Offset                  Offset
//
//  Example: Burst chop for DDR3 only (maximum local burst size of 4)
//  
//  Clock                          ____/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
//  
//  Input Request                  ----X W R X-----------------X W R X-----------------X W R X-----------------X W R X-----------------------
//  Input Column Address [2 : 0]   ----X  0  X-----------------X  1  X-----------------X  2  X-----------------X  3  X-----------------------
//  Input Size                     ----X  1  X-----------------X  1  X-----------------X  1  X-----------------X  1  X-----------------------
//  
//  Output Column Address [2 : 0]  ----X  0  X-----------------X  0  X-----------------X  2  X-----------------X  2  X-----------------------
//  Output Burst Chop Signal       ____/  1  \_________________/  1  \_________________/  1  \_________________/  1  \_______________________
//  Output Doing Signal            ____/  1  X  2  \___________/  1  X  2  \___________/  1  X  2  \___________/  1  X  2  \_________________
//  Output Valid Signal            ____/  1  \_______________________/  1  \___________/  1  \_______________________/  1  \_________________
//                                                             <----->                                         <----->
//                                                             Offset                                          Offset
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Maximum local burst size
    //----------------------------------------------------------------------------------------------------
    // Calculate maximum local burst size
    // based on burst length and controller rate
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            max_local_burst_size <= 0;
        end
        else
        begin
            max_local_burst_size <= cfg_burst_length / CFG_DWIDTH_RATIO;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            max_local_burst_size_divide_2             <= 0;
            max_local_burst_size_minus_2              <= 0;
            max_local_burst_size_divide_2_and_minus_2 <= 0;
        end
        else
        begin
            max_local_burst_size_divide_2             <= max_local_burst_size / 2;
            max_local_burst_size_minus_2              <= max_local_burst_size - 2'd2;
            max_local_burst_size_divide_2_and_minus_2 <= (max_local_burst_size / 2) - 2'd2;
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Address shifting
    //----------------------------------------------------------------------------------------------------
    // Column address
    // we only require address [2 - 0] because the maximum supported
    // local burst count is 8 which is BL of 16 in full rate
    // we only take low phase of arb_to_col address because high and low phase is identical
    always @ (*)
    begin
        int_col_address = 0;
        
        if (cfg_type == `MMR_TYPE_DDR3 && do_burst_chop)     // DDR3 and burst chop, we don't want address shifting during burst chop
        begin
            if (max_local_burst_size [2])               // max local burst of 4
                int_col_address [0    ] = arb_to_col [(CFG_DWIDTH_RATIO / 2)];
            else
                // max local burst of 1, 2 - address shifting in burst chop is not possible
                // max local burst of 8    - not supported in DDR3, there is no BL 16 support in DDR3
                int_col_address = 0;
        end
        else if (max_local_burst_size [0])              // max local burst of 1
            int_col_address         = 0;
        else if (max_local_burst_size [1])              // max local burst of 2
            int_col_address [0    ] = arb_to_col [(CFG_DWIDTH_RATIO / 2)];
        else if (max_local_burst_size [2])              // max local burst of 4
            int_col_address [1 : 0] = arb_to_col [(CFG_DWIDTH_RATIO / 2) + 1 : (CFG_DWIDTH_RATIO / 2)];
        else if (max_local_burst_size [3])              // max local burst of 8
            int_col_address [2 : 0] = arb_to_col [(CFG_DWIDTH_RATIO / 2) + 2 : (CFG_DWIDTH_RATIO / 2)];
    end
    
    always @ (*)
    begin
        col_address = int_col_address;
    end
    
    //----------------------------------------------------------------------------------------------------
    // Command Info
    //----------------------------------------------------------------------------------------------------
    // To col address
    always @ (*)
    begin
        int_to_col = arb_to_col;
    end
    
    // Row request
    always @ (*)
    begin
        int_do_row_req = (|arb_do_activate) | (|arb_do_precharge);
    end
    
    // Column request
    always @ (*)
    begin
        int_do_col_req = (|arb_do_write) | (|arb_do_read);
    end
    
    // Read and write request
    always @ (*)
    begin
        int_do_rd_req = |arb_do_read;
        int_do_wr_req = |arb_do_write;
    end
    
    // Burst chop
    always @ (*)
    begin
        int_do_burst_chop = arb_do_burst_chop;
    end
    
    // RMW info
    always @ (*)
    begin
        int_do_rmw_correct = arb_do_rmw_correct;
        int_do_rmw_partial = arb_do_rmw_partial;
    end
    
    // Other Info: size, dataid
    always @ (*)
    begin
        int_size   = arb_size;
        int_dataid = arb_dataid;
    end
    
    always @ (*)
    begin
        size                = int_size;
        dataid              = int_dataid;
        to_col              = int_to_col;
        do_row_req          = int_do_row_req;
        do_col_req          = int_do_col_req;
        do_rd_req           = int_do_rd_req;
        do_wr_req           = int_do_wr_req;
        do_burst_chop       = int_do_burst_chop;
        do_rmw_correct      = int_do_rmw_correct;
        do_rmw_partial      = int_do_rmw_partial;
    end
    
    //----------------------------------------------------------------------------------------------------
    // Address Count
    //----------------------------------------------------------------------------------------------------
    // Address counting logic
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            address_left <= 0;
        end
        else
        begin
            if (do_col_req)
            begin
                if (col_address > 1'b1)
                    address_left <= col_address - 2'd2;
                else
                    address_left <= 0;
            end
            else if (address_left != 0)
                address_left <= address_left - 1'b1;
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Valid Signal
    //----------------------------------------------------------------------------------------------------
    // Burst counting logic
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            burst_left <= 0;
        end
        else
        begin
            if (do_col_req)
            begin
                if (col_address == 0) // no shifting required
                begin
                    if (size > 1'b1)
                        burst_left <= size - 2'd2;
                    else
                        burst_left <= 0;
                end
                else if (col_address == 1'b1) // require shifting
                begin
                    burst_left <= size - 1'b1;
                end
                else // require shifting
                begin
                    burst_left <= size;
                end
            end
            else if (address_left == 0 && burst_left != 0) // start decreasing only after addres shifting is completed
                burst_left <= burst_left - 1'b1;
        end
    end
    
    // Current valid signal
    // when there is a column request and column address is "0"
    // valid signal must be asserted along with column request
    always @ (*)
    begin
        if (do_col_req && col_address == 0)
            current_valid = 1'b1;
        else
            current_valid = 1'b0;
    end
    
    // Delayed valid signal
    // when there is a column request with size larger than "1"
    // valid signal will be asserted according to the request size
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            delayed_valid <= 0;
        end
        else
        begin
            if (do_col_req && ((col_address == 0 && size > 1) || col_address == 1'b1))
                delayed_valid <= 1'b1;
            else if (address_left == 0 && burst_left > 0)
                delayed_valid <= 1'b1;
            else
                delayed_valid <= 1'b0;
        end
    end
    
    // Combined valid signal
    always @ (*)
    begin
        combined_valid = current_valid | delayed_valid;
    end
    
    // Read write valid signal
    always @ (*)
    begin
        rdwr_data_valid = combined_valid;
    end
    
    //----------------------------------------------------------------------------------------------------
    // Doing Signal
    //----------------------------------------------------------------------------------------------------
    // Maximum burst counting logic
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            max_burst_left <= 0;
        end
        else
        begin
            if (do_col_req)
            begin
                if (do_burst_chop)
                begin
                    if (max_local_burst_size_divide_2 <= 2)
                        max_burst_left <= 0;
                    else
                        max_burst_left <= max_local_burst_size_divide_2_and_minus_2;
                end
                else
                begin
                    if (max_local_burst_size <= 2)
                        max_burst_left <= 0;
                    else
                        max_burst_left <= max_local_burst_size_minus_2;
                end
            end
            else if (max_burst_left != 0)
                max_burst_left <= max_burst_left - 1'b1;
        end
    end
    
    // Delayed doing signal
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            delayed_doing <= 0;
        end
        else
        begin
            if (do_col_req)
            begin
                if (max_local_burst_size <= 1'b1)   //do not generate delayed_doing if max burst count is 1
                    delayed_doing <= 1'b0;
                else if (do_burst_chop && max_local_burst_size <= 2'd2)
                    delayed_doing <= 1'b0;
                else
                    delayed_doing <= 1'b1;
            end
            else if (max_burst_left > 0)
                delayed_doing <= 1'b1;
            else
                delayed_doing <= 1'b0;
        end
    end
    
    // Keep track of last commands
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            last_is_write <= 1'b0;
            last_is_read  <= 1'b0;
        end
        else
        begin
            if (do_wr_req)
            begin
                last_is_write <= 1'b1;
                last_is_read  <= 1'b0;
            end
            else if (do_rd_req)
            begin
                last_is_write <= 1'b0;
                last_is_read  <= 1'b1;
            end
        end
    end
    
    // Doing write signal
    always @ (*)
    begin
        if (do_rd_req)
            doing_write = 1'b0;
        else if (do_wr_req)
            doing_write = ~terminate_doing;
        else if (last_is_write)
            doing_write = delayed_doing & ~terminate_doing;
        else
            doing_write = 1'b0;
    end
    
    // Doing read signal
    always @ (*)
    begin
        if (do_wr_req)
            doing_read = 1'b0;
        else if (do_rd_req)
            doing_read = ~terminate_doing;
        else if (last_is_read)
            doing_read = delayed_doing & ~terminate_doing;
        else
            doing_read = 1'b0;
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Burst Generation Logic
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] RMW Info
//
//--------------------------------------------------------------------------------------------------------
    // Registered arb_do_rmw_* signal when there is a coumn request
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            delayed_do_rmw_correct <= 0;
            delayed_do_rmw_partial <= 0;
        end
        else
        begin
            if (do_col_req)
            begin
                delayed_do_rmw_correct <= do_rmw_correct;
                delayed_do_rmw_partial <= do_rmw_partial;
            end
        end
    end
    
    // Prolong RMW information until doing signal is deasserted
    always @ (*)
    begin
        if (do_col_req)
        begin
            combined_do_rmw_correct = do_rmw_correct;
            combined_do_rmw_partial = do_rmw_partial;
        end
        else if (delayed_doing)
        begin
            combined_do_rmw_correct = delayed_do_rmw_correct;
            combined_do_rmw_partial = delayed_do_rmw_partial;
        end
        else
        begin
            combined_do_rmw_correct = 0;
            combined_do_rmw_partial = 0;
        end
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [START] RMW Info
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Data ID
//
//--------------------------------------------------------------------------------------------------------
    // Register data ID when there is a column request
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            delayed_dataid <= 0;
        end
        else
        begin
            if (do_col_req)
                delayed_dataid <= dataid;
        end
    end
    
    // Prolong data ID information until doing signal is deasserted
    always @ (*)
    begin
        if (do_col_req)
            combined_dataid = dataid;
        else if (delayed_doing)
            combined_dataid = delayed_dataid;
        else
            combined_dataid = 0;
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Data ID
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Column Address
//
//--------------------------------------------------------------------------------------------------------
    // Change column address bit [2 : 0]
    // see waveform examples in burst generation logic portion
    always @ (*)
    begin
         modified_to_col = to_col;
         
         // During burst chop in DDR3 only, retain original column address
         // maximum local burst in DDR3 is 4 which is BL8 in full rate
         if (do_burst_chop && cfg_type == `MMR_TYPE_DDR3)
         begin
             if (max_local_burst_size [1])                   // max local burst of 2
             begin
                 modified_to_col [(CFG_DWIDTH_RATIO / 4)                        + 0 : 0                   ] = 0;
                 modified_to_col [(CFG_DWIDTH_RATIO / 4) + CFG_MEM_IF_COL_WIDTH + 0 : CFG_MEM_IF_COL_WIDTH] = 0;
             end
             else if (max_local_burst_size [2])              // max local burst of 4
             begin
                 modified_to_col [(CFG_DWIDTH_RATIO / 4)                        + 1 : 0                   ] = 0;
                 modified_to_col [(CFG_DWIDTH_RATIO / 4) + CFG_MEM_IF_COL_WIDTH + 1 : CFG_MEM_IF_COL_WIDTH] = 0;
             end
         end
         else
         begin
             if (max_local_burst_size [0])                   // max local burst of 1
             begin
                 modified_to_col [(CFG_DWIDTH_RATIO / 4)                        + 0 : 0                   ] = 0;
                 modified_to_col [(CFG_DWIDTH_RATIO / 4) + CFG_MEM_IF_COL_WIDTH + 0 : CFG_MEM_IF_COL_WIDTH] = 0;
             end
             else if (max_local_burst_size [1])              // max local burst of 2
             begin
                 modified_to_col [(CFG_DWIDTH_RATIO / 4)                        + 1 : 0                   ] = 0;
                 modified_to_col [(CFG_DWIDTH_RATIO / 4) + CFG_MEM_IF_COL_WIDTH + 1 : CFG_MEM_IF_COL_WIDTH] = 0;
             end
             else if (max_local_burst_size [2])              // max local burst of 4
             begin
                 modified_to_col [(CFG_DWIDTH_RATIO / 4)                        + 2 : 0                   ] = 0;
                 modified_to_col [(CFG_DWIDTH_RATIO / 4) + CFG_MEM_IF_COL_WIDTH + 2 : CFG_MEM_IF_COL_WIDTH] = 0;
             end
             else if (max_local_burst_size [3])              // max local burst of 8
             begin
                 modified_to_col [(CFG_DWIDTH_RATIO / 4)                        + 3 : 0                   ] = 0;
                 modified_to_col [(CFG_DWIDTH_RATIO / 4) + CFG_MEM_IF_COL_WIDTH + 3 : CFG_MEM_IF_COL_WIDTH] = 0;
             end
         end
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Column Address
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Burst Interrupt
//  
//  DDR, DDR2, LPDDR and LPDDR2 specific
//  
//  This logic re-use most of the existing logic in burst generation section (valid signal)
//  This signal will be used in rank timer block to gate can_read and can_write signals
//  
//  Example: (DDR2 full rate, burst length of 8, this will result in maximum local burst of 4)
//  
//  Clock                          ____/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__
//  
//  Do Signal                      ____/  1  \_________________/  1  \_________________/  1  \_________________/  1  \_______________________
//  Doing Signal                   ____/  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  X  1  X  2  X  3  X  4  \_____
//  Valid Signal                   ____/  1  \_______________________/  1  \_______________________/  1  \_______________________/  1  \_____
//  
//  Interrupt Ready (tCCD = 1)     /              HIGH               \_____/      HIGH       \___________/    HIGH   \_________________/     
//  Interrupt Ready (tCCD = 2)     /   HIGH  \_____/      HIGH       \_____/      HIGH       \_________________/     \_________________/     
//
//--------------------------------------------------------------------------------------------------------
    // n-prefetch architecture, related tCCD value (only support 1, 2 and 4)
    // if tCCD is set to 1, command can be interrupted / terminated at every 2 memory burst boundary (1 memory clock cycle)
    // if tCCD is set to 2, command can be interrupted / terminated at every 4 memory burst boundary (2 memory clock cycle)
    // if tCCD is set to 4, command can be interrupted / terminated at every 8 memory burst boundary (4 memory clock cycle)
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            n_prefetch <= 0;
        end
        else
        begin
            n_prefetch <= cfg_tccd / (CFG_DWIDTH_RATIO / 2);
        end
    end
    
    // For n_prefetch of 0 and 1, we will allow interrupt at any controller clock cycles
    // for n_prefetch of n, we will allow interrupt at any n controller clock cycles interval
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_allow_interrupt <= 1'b1;
        end
        else
        begin
            if (cfg_type == `MMR_TYPE_DDR3) // DDR3 specific, interrupt masking is handled by setting read-to-read and write-to-write to BL/2
                int_allow_interrupt <= 1'b1;
            else
            begin
                if (n_prefetch <= 1) // allow interrupt at any clock cycle
                begin
                    if (do_col_req && ((col_address == 0 && size > 1) || col_address != 0))
                        int_allow_interrupt <= 1'b0;
                    else if (address_left == 0 && burst_left == 0)
                        int_allow_interrupt <= 1'b1;
                end
                else if (n_prefetch == 2)
                begin
                    if (do_col_req)
                        int_allow_interrupt <= 1'b0;
                    else if (address_left == 0 && burst_left == 0 && max_burst_left [0] == 0)
                        int_allow_interrupt <= 1'b1;
                end
                else if (n_prefetch == 4)
                begin
                    if (do_col_req)
                        int_allow_interrupt <= 1'b0;
                    else if (address_left == 0 && burst_left == 0 && max_burst_left [1 : 0] == 0)
                        int_allow_interrupt <= 1'b1;
                end
            end
        end
    end
    
    // Interrupt info when interrupt feature is enabled
    always @ (*)
    begin
        int_interrupt_enable_ready = int_allow_interrupt;
    end
    
    // Interrupt info when interrupt feature is disabled
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_interrupt_disable_ready <= 0;
        end
        else
        begin
            if (do_col_req)
            begin
                if (CFG_REG_GRANT)
                begin
                    if (max_local_burst_size <= 2'd2)   //do not generate int_interrupt_ready
                        int_interrupt_disable_ready <= 1'b0;
                    else if (do_burst_chop && max_local_burst_size <= 3'd4)
                        int_interrupt_disable_ready <= 1'b0;
                    else
                        int_interrupt_disable_ready <= 1'b1;
                end
                else
                begin
                    if (max_local_burst_size <= 1'b1)   //do not generate int_interrupt_ready if max burst count is 1
                        int_interrupt_disable_ready <= 1'b0;
                    else if (do_burst_chop && max_local_burst_size <= 2'd2)
                        int_interrupt_disable_ready <= 1'b0;
                    else
                        int_interrupt_disable_ready <= 1'b1;
                end
            end
            else if (!CFG_REG_GRANT && max_burst_left > 0)
                int_interrupt_disable_ready <= 1'b1;
            else if ( CFG_REG_GRANT && max_burst_left > 1'b1)
                int_interrupt_disable_ready <= 1'b1;
            else
                int_interrupt_disable_ready <= 1'b0;
        end
    end
    
    // Assign to output ports
    always @ (*)
    begin
        if (cfg_enable_burst_interrupt)
        begin
            interrupt_ready = ~int_interrupt_enable_ready;
        end
        else
        begin
            interrupt_ready = ~int_interrupt_disable_ready;
        end
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Burst Interrupt
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Burst Terminate
//  
//  LPDDR1 and LPDDR2 specific only
//
//--------------------------------------------------------------------------------------------------------
    // For n_prefetch of 0 and 1, we will allow terminate at any controller clock cycles
    // for n_prefetch of n, we will allow terminate at any n controller clock cycles interval
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_allow_terminate    <= 1'b0;
            int_do_burst_terminate <= 1'b0;
        end
        else
        begin
            if (cfg_type == `MMR_TYPE_LPDDR1 || cfg_type == `MMR_TYPE_LPDDR2) // LPDDR1 and LPDDR2 only
            begin
                if (n_prefetch <= 1) // allow terminate at any clock cycle
                begin
                    if (do_col_req && col_address != 0)
                    begin
                        int_allow_terminate    <= 1'b0;
                        int_do_burst_terminate <= 1'b0;
                    end
                    else if (do_col_req && col_address == 0 && size == 1'b1)
                    begin
                        int_allow_terminate    <= 1'b1;
                        
                        if (!int_allow_terminate)
                            int_do_burst_terminate <= 1'b1;
                        else
                            int_do_burst_terminate <= 1'b0;
                    end
                    else if (address_left == 0 && burst_left == 0 && max_burst_left > 0)
                    begin
                        int_allow_terminate <= 1'b1;
                        
                        if (!int_allow_terminate)
                            int_do_burst_terminate <= 1'b1;
                        else
                            int_do_burst_terminate <= 1'b0;
                    end
                    else
                    begin
                        int_allow_terminate    <= 1'b0;
                        int_do_burst_terminate <= 1'b0;
                    end
                end
                else if (n_prefetch == 2)
                begin
                    if (do_col_req)
                    begin
                        int_allow_terminate    <= 1'b0;
                        int_do_burst_terminate <= 1'b0;
                    end
                    else if (address_left == 0 && burst_left == 0 && max_burst_left > 0 && (max_burst_left [0] == 0 || int_allow_terminate == 1'b1))
                    begin
                        int_allow_terminate <= 1'b1;
                        
                        if (!int_allow_terminate)
                            int_do_burst_terminate <= 1'b1;
                        else
                            int_do_burst_terminate <= 1'b0;
                    end
                    else
                    begin
                        int_allow_terminate    <= 1'b0;
                        int_do_burst_terminate <= 1'b0;
                    end
                end
                else if (n_prefetch == 4)
                begin
                    if (do_col_req)
                    begin
                        int_allow_terminate    <= 1'b0;
                        int_do_burst_terminate <= 1'b0;
                    end
                    else if (address_left == 0 && burst_left == 0 && max_burst_left > 0 && (max_burst_left [1 : 0] == 0 || int_allow_terminate == 1'b1))
                    begin
                        int_allow_terminate <= 1'b1;
                        
                        if (!int_allow_terminate)
                            int_do_burst_terminate <= 1'b1;
                        else
                            int_do_burst_terminate <= 1'b0;
                    end
                    else
                    begin
                        int_allow_terminate    <= 1'b0;
                        int_do_burst_terminate <= 1'b0;
                    end
                end
            end
            else
            begin
                int_allow_terminate <= 1'b0;
            end
        end
    end
    
    // Effective size, actual issued size migh be smaller that maximum local burst size
    // we need to inform rank timer about this information for efficient DQ bus turnaround operation
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_effective_size <= 0;
        end
        else
        begin
            if (do_col_req)
                int_effective_size <= 1'b1;
            else if (int_effective_size != {CFG_INT_SIZE_WIDTH{1'b1}})
                int_effective_size <= int_effective_size + 1'b1;
        end
    end
    
    // Terminate doing signal, this signal will be used to mask off doing_read or doing_write signal
    // when we issue a burst terminate signal, we should also terminate doing_read and doing_write signal
    // to prevent unwanted DQS toggle on the memory interface
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            doing_burst_terminate <= 1'b0;
        end
        else
        begin
            if (address_left == 0 && burst_left == 0 && max_burst_left > 0 && ((|do_burst_terminate) == 1'b1 || doing_burst_terminate == 1'b1))
                doing_burst_terminate <= 1'b1;
            else
                doing_burst_terminate <= 1'b0;
        end
    end
    
    always @ (*)
    begin
        if (cfg_enable_burst_terminate)
        begin
            terminate_doing = (|do_burst_terminate) | doing_burst_terminate;
        end
        else
        begin
            terminate_doing = zero;
        end
    end
    
    // Burst terminate output ports
    // set burst terminate signal to '0' when there is a do_col_req (in half and quarter rate)
    // or both do_col_req and do_row_req (full rate) because this indicate there is a incoming command
    // any command from arbiter is have higher priority compared to burst terminate command
    always @ (*)
    begin
        if (CFG_DWIDTH_RATIO == 2)
            int_do_req = do_col_req | do_row_req;
        else
            int_do_req = do_col_req;
    end
    
    generate
    begin
        if (CFG_CTL_ARBITER_TYPE == "ROWCOL")
        begin
            always @ (*)
            begin
                do_burst_terminate = 0;
                
                if (cfg_enable_burst_terminate)
                begin
                    if (int_do_req)
                    begin
                        do_burst_terminate [AFI_INTF_HIGH_PHASE] = 0;
                    end
                    else
                    begin
                        do_burst_terminate [AFI_INTF_HIGH_PHASE] = int_do_burst_terminate;
                    end
                end
                else
                begin
                    do_burst_terminate [AFI_INTF_HIGH_PHASE] = 0;
                end
            end
        end
        else if (CFG_CTL_ARBITER_TYPE == "COLROW")
        begin
            always @ (*)
            begin
                do_burst_terminate = 0;
                
                if (cfg_enable_burst_terminate)
                begin
                    if (int_do_req)
                    begin
                        do_burst_terminate [AFI_INTF_LOW_PHASE] = 0;
                    end
                    else
                    begin
                        do_burst_terminate [AFI_INTF_LOW_PHASE] = int_do_burst_terminate;
                    end
                end
                else
                begin
                    do_burst_terminate [AFI_INTF_LOW_PHASE] = 0;
                end
            end
        end
    end
    endgenerate
    
    // Effective size output ports
    always @ (*)
    begin
        if (cfg_enable_burst_terminate)
        begin
            effective_size = int_effective_size;
        end
        else
        begin
            effective_size = {CFG_INT_SIZE_WIDTH{zero}};
        end
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Burst Terminate
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Burst Chop
//  
//  DDR3 specific only
//
//--------------------------------------------------------------------------------------------------------
    // yyong generate
    // yyong begin
    // yyong     if (CFG_DWIDTH_RATIO == 2)
    // yyong     begin
    // yyong         always @ (*)
    // yyong         begin
    // yyong             if (cfg_type == `MMR_TYPE_DDR3) // DDR3 only
    // yyong             begin
    // yyong                 if (arb_size <= 2 && arb_to_col [(CFG_DWIDTH_RATIO / 2)] == 1'b0)
    // yyong                     do_burst_chop = arb_do_write | arb_do_read;
    // yyong                 else if (arb_size == 1)
    // yyong                     do_burst_chop = arb_do_write | arb_do_read;
    // yyong                 else
    // yyong                     do_burst_chop = 0;
    // yyong             end
    // yyong             else // Other memory types
    // yyong             begin
    // yyong                 do_burst_chop = 0;
    // yyong             end
    // yyong         end
    // yyong     end
    // yyong     else if (CFG_DWIDTH_RATIO == 4)
    // yyong     begin
    // yyong         always @ (*)
    // yyong         begin
    // yyong             do_burst_chop = 0;
    // yyong             
    // yyong             if (cfg_type == `MMR_TYPE_DDR3) // DDR3 only
    // yyong             begin
    // yyong                 if (arb_size == 1)
    // yyong                     do_burst_chop = arb_do_write | arb_do_read;
    // yyong                 else
    // yyong                     do_burst_chop = 0;
    // yyong             end
    // yyong             else // Other memory types
    // yyong             begin
    // yyong                 do_burst_chop = 0;
    // yyong             end
    // yyong         end
    // yyong     end
    // yyong     else if (CFG_DWIDTH_RATIO == 8)
    // yyong     begin
    // yyong         // Burst chop is not available in quarter rate
    // yyong         always @ (*)
    // yyong         begin
    // yyong             do_burst_chop = {CFG_AFI_INTF_PHASE_NUM{zero}};
    // yyong         end
    // yyong     end
    // yyong end
    // yyong endgenerate
//--------------------------------------------------------------------------------------------------------
//
//  [END] Burst Chop
//
//--------------------------------------------------------------------------------------------------------









endmodule
