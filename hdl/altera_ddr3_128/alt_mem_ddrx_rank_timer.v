
//altera message_off 10230 10036

`timescale 1 ps / 1 ps

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *)
module alt_mem_ddrx_rank_timer #
    ( parameter
        CFG_DWIDTH_RATIO                        =   2,
        CFG_CTL_TBP_NUM                         =   4,
        CFG_CTL_ARBITER_TYPE                    =   "ROWCOL",
        CFG_MEM_IF_CHIP                         =   1,
        CFG_MEM_IF_CS_WIDTH                     =   1,
        CFG_INT_SIZE_WIDTH                      =   4,
        CFG_AFI_INTF_PHASE_NUM                  =   2,
        CFG_REG_GRANT                           =   0,
        CFG_RANK_TIMER_OUTPUT_REG               =   0,
        CFG_PORT_WIDTH_BURST_LENGTH             =   5,
        T_PARAM_FOUR_ACT_TO_ACT_WIDTH           =   0,
        T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH      =   0,
        T_PARAM_WR_TO_WR_WIDTH                  =   0,
        T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH        =   0,
        T_PARAM_WR_TO_RD_WIDTH                  =   0,
        T_PARAM_WR_TO_RD_BC_WIDTH               =   0,
        T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH        =   0,
        T_PARAM_RD_TO_RD_WIDTH                  =   0,
        T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH        =   0,
        T_PARAM_RD_TO_WR_WIDTH                  =   0,
        T_PARAM_RD_TO_WR_BC_WIDTH               =   0,
        T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH        =   0
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // MMR Configurations
        cfg_burst_length,
        
        // Timing parameters
        t_param_four_act_to_act,
        t_param_act_to_act_diff_bank,
        t_param_wr_to_wr,
        t_param_wr_to_wr_diff_chip,
        t_param_wr_to_rd,
        t_param_wr_to_rd_bc,
        t_param_wr_to_rd_diff_chip,
        t_param_rd_to_rd,
        t_param_rd_to_rd_diff_chip,
        t_param_rd_to_wr,
        t_param_rd_to_wr_bc,
        t_param_rd_to_wr_diff_chip,
        
        // Arbiter Interface
        bg_do_write,
        bg_do_read,
        bg_do_burst_chop,
        bg_do_burst_terminate,
        bg_do_activate,
        bg_do_precharge,
        bg_to_chip,
        bg_effective_size,
        bg_interrupt_ready,
        
        // Command Generator Interface
        cmd_gen_chipsel,
        
        // TBP Interface
        tbp_chipsel,
        tbp_load,
        
        // Sideband Interface
        stall_chip,
        
        can_activate,
        can_precharge,
        can_read,
        can_write
    );

input                                                       ctl_clk;
input                                                       ctl_reset_n;

input  [CFG_PORT_WIDTH_BURST_LENGTH                - 1 : 0] cfg_burst_length;

input  [T_PARAM_FOUR_ACT_TO_ACT_WIDTH              - 1 : 0] t_param_four_act_to_act;
input  [T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH         - 1 : 0] t_param_act_to_act_diff_bank;
input  [T_PARAM_WR_TO_WR_WIDTH                     - 1 : 0] t_param_wr_to_wr;
input  [T_PARAM_WR_TO_WR_DIFF_CHIP_WIDTH           - 1 : 0] t_param_wr_to_wr_diff_chip;
input  [T_PARAM_WR_TO_RD_WIDTH                     - 1 : 0] t_param_wr_to_rd;
input  [T_PARAM_WR_TO_RD_BC_WIDTH                  - 1 : 0] t_param_wr_to_rd_bc;
input  [T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH           - 1 : 0] t_param_wr_to_rd_diff_chip;
input  [T_PARAM_RD_TO_RD_WIDTH                     - 1 : 0] t_param_rd_to_rd;
input  [T_PARAM_RD_TO_RD_DIFF_CHIP_WIDTH           - 1 : 0] t_param_rd_to_rd_diff_chip;
input  [T_PARAM_RD_TO_WR_WIDTH                     - 1 : 0] t_param_rd_to_wr;
input  [T_PARAM_RD_TO_WR_BC_WIDTH                  - 1 : 0] t_param_rd_to_wr_bc;
input  [T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH           - 1 : 0] t_param_rd_to_wr_diff_chip;

input  [CFG_AFI_INTF_PHASE_NUM                     - 1 : 0] bg_do_write;
input  [CFG_AFI_INTF_PHASE_NUM                     - 1 : 0] bg_do_read;
input  [CFG_AFI_INTF_PHASE_NUM                     - 1 : 0] bg_do_burst_chop;
input  [CFG_AFI_INTF_PHASE_NUM                     - 1 : 0] bg_do_burst_terminate;
input  [CFG_AFI_INTF_PHASE_NUM                     - 1 : 0] bg_do_activate;
input  [CFG_AFI_INTF_PHASE_NUM                     - 1 : 0] bg_do_precharge;
input  [(CFG_AFI_INTF_PHASE_NUM * CFG_MEM_IF_CHIP) - 1 : 0] bg_to_chip;
input  [CFG_INT_SIZE_WIDTH                         - 1 : 0] bg_effective_size;
input                                                       bg_interrupt_ready;

input  [CFG_MEM_IF_CS_WIDTH                        - 1 : 0] cmd_gen_chipsel;

input  [(CFG_CTL_TBP_NUM * CFG_MEM_IF_CS_WIDTH)    - 1 : 0] tbp_chipsel;
input  [CFG_CTL_TBP_NUM                            - 1 : 0] tbp_load;

input  [CFG_MEM_IF_CHIP                            - 1 : 0] stall_chip;

output [CFG_CTL_TBP_NUM                            - 1 : 0] can_activate;
output [CFG_CTL_TBP_NUM                            - 1 : 0] can_precharge;
output [CFG_CTL_TBP_NUM                            - 1 : 0] can_read;
output [CFG_CTL_TBP_NUM                            - 1 : 0] can_write;

//--------------------------------------------------------------------------------------------------------
//
//  [START] Register & Wires
//
//--------------------------------------------------------------------------------------------------------
    // General
    localparam RANK_TIMER_COUNTER_OFFSET = (CFG_RANK_TIMER_OUTPUT_REG) ? ((CFG_REG_GRANT) ? 4 : 3) : ((CFG_REG_GRANT) ? 3 : 2);
    localparam RANK_TIMER_TFAW_OFFSET    = (CFG_RANK_TIMER_OUTPUT_REG) ? ((CFG_REG_GRANT) ? 2 : 1) : ((CFG_REG_GRANT) ? 1 : 0);
    
    localparam ENABLE_BETTER_TRRD_EFFICIENCY = 1; // ONLY set to '1' when CFG_RANK_TIMER_OUTPUT_REG is enabled, else it will fail
    
    wire one  = 1'b1;
    wire zero = 1'b0;
    
    // Timing Parameter Comparison Logic
    reg less_than_1_act_to_act_diff_bank;
    reg less_than_2_act_to_act_diff_bank;
    reg less_than_3_act_to_act_diff_bank;
    reg less_than_4_act_to_act_diff_bank;
    reg less_than_4_four_act_to_act;
    
    reg less_than_1_rd_to_rd;
    reg less_than_1_rd_to_wr;
    reg less_than_1_wr_to_wr;
    reg less_than_1_wr_to_rd;
    reg less_than_1_rd_to_wr_bc;
    reg less_than_1_wr_to_rd_bc;
    reg less_than_1_rd_to_rd_diff_chip;
    reg less_than_1_rd_to_wr_diff_chip;
    reg less_than_1_wr_to_wr_diff_chip;
    reg less_than_1_wr_to_rd_diff_chip;
    
    reg less_than_2_rd_to_rd;
    reg less_than_2_rd_to_wr;
    reg less_than_2_wr_to_wr;
    reg less_than_2_wr_to_rd;
    reg less_than_2_rd_to_wr_bc;
    reg less_than_2_wr_to_rd_bc;
    reg less_than_2_rd_to_rd_diff_chip;
    reg less_than_2_rd_to_wr_diff_chip;
    reg less_than_2_wr_to_wr_diff_chip;
    reg less_than_2_wr_to_rd_diff_chip;
    
    reg less_than_3_rd_to_rd;
    reg less_than_3_rd_to_wr;
    reg less_than_3_wr_to_wr;
    reg less_than_3_wr_to_rd;
    reg less_than_3_rd_to_wr_bc;
    reg less_than_3_wr_to_rd_bc;
    reg less_than_3_rd_to_rd_diff_chip;
    reg less_than_3_rd_to_wr_diff_chip;
    reg less_than_3_wr_to_wr_diff_chip;
    reg less_than_3_wr_to_rd_diff_chip;
    
    reg less_than_4_rd_to_rd;
    reg less_than_4_rd_to_wr;
    reg less_than_4_wr_to_wr;
    reg less_than_4_wr_to_rd;
    reg less_than_4_rd_to_wr_bc;
    reg less_than_4_wr_to_rd_bc;
    reg less_than_4_rd_to_rd_diff_chip;
    reg less_than_4_rd_to_wr_diff_chip;
    reg less_than_4_wr_to_wr_diff_chip;
    reg less_than_4_wr_to_rd_diff_chip;
    
    reg more_than_3_rd_to_rd;
    reg more_than_3_rd_to_wr;
    reg more_than_3_wr_to_wr;
    reg more_than_3_wr_to_rd;
    reg more_than_3_rd_to_wr_bc;
    reg more_than_3_wr_to_rd_bc;
    reg more_than_3_rd_to_rd_diff_chip;
    reg more_than_3_rd_to_wr_diff_chip;
    reg more_than_3_wr_to_wr_diff_chip;
    reg more_than_3_wr_to_rd_diff_chip;
    
    reg less_than_xn1_act_to_act_diff_bank;
    reg less_than_xn1_rd_to_rd;
    reg less_than_xn1_rd_to_wr;
    reg less_than_xn1_wr_to_wr;
    reg less_than_xn1_wr_to_rd;
    reg less_than_xn1_rd_to_wr_bc;
    reg less_than_xn1_wr_to_rd_bc;
    reg less_than_xn1_rd_to_rd_diff_chip;
    reg less_than_xn1_rd_to_wr_diff_chip;
    reg less_than_xn1_wr_to_wr_diff_chip;
    reg less_than_xn1_wr_to_rd_diff_chip;
    
    reg less_than_x0_act_to_act_diff_bank;
    reg less_than_x0_rd_to_rd;
    reg less_than_x0_rd_to_wr;
    reg less_than_x0_wr_to_wr;
    reg less_than_x0_wr_to_rd;
    reg less_than_x0_rd_to_wr_bc;
    reg less_than_x0_wr_to_rd_bc;
    reg less_than_x0_rd_to_rd_diff_chip;
    reg less_than_x0_rd_to_wr_diff_chip;
    reg less_than_x0_wr_to_wr_diff_chip;
    reg less_than_x0_wr_to_rd_diff_chip;
    
    reg less_than_x1_act_to_act_diff_bank;
    reg less_than_x1_rd_to_rd;
    reg less_than_x1_rd_to_wr;
    reg less_than_x1_wr_to_wr;
    reg less_than_x1_wr_to_rd;
    reg less_than_x1_rd_to_wr_bc;
    reg less_than_x1_wr_to_rd_bc;
    reg less_than_x1_rd_to_rd_diff_chip;
    reg less_than_x1_rd_to_wr_diff_chip;
    reg less_than_x1_wr_to_wr_diff_chip;
    reg less_than_x1_wr_to_rd_diff_chip;
    
    // Input
    reg                               int_do_activate;
    reg                               int_do_precharge;
    reg                               int_do_burst_chop;
    reg                               int_do_burst_terminate;
    reg                               int_do_write;
    reg                               int_do_read;
    reg  [CFG_MEM_IF_CHIP    - 1 : 0] int_to_chip_r;
    reg  [CFG_MEM_IF_CHIP    - 1 : 0] int_to_chip_c;
    reg  [CFG_INT_SIZE_WIDTH - 1 : 0] int_effective_size;
    reg                               int_interrupt_ready;
    
    // Activate Monitor
    localparam ACTIVATE_COUNTER_WIDTH = T_PARAM_ACT_TO_ACT_DIFF_BANK_WIDTH;
    localparam ACTIVATE_COMMAND_WIDTH = 3;
    localparam NUM_OF_TFAW_SHIFT_REG  = 2 ** T_PARAM_FOUR_ACT_TO_ACT_WIDTH;
    
    reg  [CFG_MEM_IF_CHIP        - 1 : 0] act_tfaw_ready;
    reg  [CFG_MEM_IF_CHIP        - 1 : 0] act_tfaw_ready_combi;
    reg  [CFG_MEM_IF_CHIP        - 1 : 0] act_trrd_ready;
    reg  [CFG_MEM_IF_CHIP        - 1 : 0] act_trrd_ready_combi;
    reg  [CFG_MEM_IF_CHIP        - 1 : 0] act_ready;
    wire [ACTIVATE_COMMAND_WIDTH - 1 : 0] act_tfaw_cmd_count [CFG_MEM_IF_CHIP - 1 : 0];
    
    // Read/Write Monitor
    localparam IDLE               = 32'h49444C45;
    localparam WR                 = 32'h20205752;
    localparam RD                 = 32'h20205244;
    localparam RDWR_COUNTER_WIDTH = (T_PARAM_RD_TO_WR_WIDTH > T_PARAM_WR_TO_RD_WIDTH) ? T_PARAM_RD_TO_WR_WIDTH : T_PARAM_WR_TO_RD_WIDTH;
    
    reg  [CFG_INT_SIZE_WIDTH               - 1 : 0] max_local_burst_size;
    
    reg  [T_PARAM_RD_TO_WR_WIDTH           - 1 : 0] effective_rd_to_wr_combi;
    reg  [T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH - 1 : 0] effective_rd_to_wr_diff_chip_combi;
    reg  [T_PARAM_WR_TO_RD_WIDTH           - 1 : 0] effective_wr_to_rd_combi;
    reg  [T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH - 1 : 0] effective_wr_to_rd_diff_chip_combi;
    
    reg  [T_PARAM_RD_TO_WR_WIDTH           - 1 : 0] effective_rd_to_wr;
    reg  [T_PARAM_RD_TO_WR_DIFF_CHIP_WIDTH - 1 : 0] effective_rd_to_wr_diff_chip;
    reg  [T_PARAM_WR_TO_RD_WIDTH           - 1 : 0] effective_wr_to_rd;
    reg  [T_PARAM_WR_TO_RD_DIFF_CHIP_WIDTH - 1 : 0] effective_wr_to_rd_diff_chip;
    
    reg  [CFG_MEM_IF_CHIP                  - 1 : 0] read_ready;
    reg  [CFG_MEM_IF_CHIP                  - 1 : 0] write_ready;
    
    // Precharge Monitor
    reg  [CFG_MEM_IF_CHIP - 1 : 0] pch_ready;
    
    // Output
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_can_activate;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_can_precharge;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_can_read;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] int_can_write;
    
    reg  [CFG_CTL_TBP_NUM - 1 : 0] can_activate;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] can_precharge;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] can_read;
    reg  [CFG_CTL_TBP_NUM - 1 : 0] can_write;
    
    reg  [T_PARAM_FOUR_ACT_TO_ACT_WIDTH   - 1 : 0] sel_act_tfaw_shift_out_point;
//--------------------------------------------------------------------------------------------------------
//
//  [END] Register & Wires
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Input
//
//--------------------------------------------------------------------------------------------------------
    // Do activate
    always @ (*)
    begin
        int_do_activate = |bg_do_activate;
    end
    
    // Do precharge
    always @ (*)
    begin
        int_do_precharge = |bg_do_precharge;
    end
    
    //Do burst chop
    always @ (*)
    begin
        int_do_burst_chop = |bg_do_burst_chop;
    end
    
    //Do burst terminate
    always @ (*)
    begin
        int_do_burst_terminate = |bg_do_burst_terminate;
    end
    
    // Do write
    always @ (*)
    begin
        int_do_write = |bg_do_write;
    end
    
    // Do read
    always @ (*)
    begin
        int_do_read = |bg_do_read;
    end
    
    // To chip
    always @ (*)
    begin
        // _r for row command and _c for column command
        if (CFG_CTL_ARBITER_TYPE == "COLROW")
        begin
            int_to_chip_c = bg_to_chip [CFG_MEM_IF_CHIP     - 1 : 0              ];
            int_to_chip_r = bg_to_chip [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
        end
        else if (CFG_CTL_ARBITER_TYPE == "ROWCOL")
        begin
            int_to_chip_r = bg_to_chip [CFG_MEM_IF_CHIP     - 1 : 0              ];
            int_to_chip_c = bg_to_chip [2 * CFG_MEM_IF_CHIP - 1 : CFG_MEM_IF_CHIP];
        end
    end
    
    // Effective size
    always @ (*)
    begin
        int_effective_size = bg_effective_size;
    end
    
    // Interrupt ready
    always @ (*)
    begin
        int_interrupt_ready = bg_interrupt_ready;
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Input
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Output
//
//--------------------------------------------------------------------------------------------------------
    generate
        genvar x_cs;
        for (x_cs = 0; x_cs < CFG_CTL_TBP_NUM;x_cs = x_cs + 1)
        begin : can_logic_per_chip
            reg [CFG_MEM_IF_CS_WIDTH - 1 : 0] chip_addr;
            
            always @ (*)
            begin
                if (CFG_RANK_TIMER_OUTPUT_REG && tbp_load [x_cs])
                begin
                    chip_addr = cmd_gen_chipsel;
                end
                else
                begin
                    chip_addr = tbp_chipsel [(x_cs + 1) * CFG_MEM_IF_CS_WIDTH - 1 : x_cs * CFG_MEM_IF_CS_WIDTH];
                end
            end
            
            if (CFG_RANK_TIMER_OUTPUT_REG)
            begin
                always @ (*)
                begin
                    can_activate  [x_cs] = int_can_activate  [x_cs]                      ;
                    can_precharge [x_cs] = int_can_precharge [x_cs]                      ;
                    can_read      [x_cs] = int_can_read      [x_cs] & int_interrupt_ready;
                    can_write     [x_cs] = int_can_write     [x_cs] & int_interrupt_ready;
                end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        int_can_activate [x_cs] <= 1'b0;
                    end
                    else
                    begin
                        if (stall_chip [chip_addr])
                        begin
                            int_can_activate [x_cs] <= 1'b0;
                        end
                        else if (int_do_activate && int_to_chip_r [chip_addr] && !ENABLE_BETTER_TRRD_EFFICIENCY)
                        begin
                            int_can_activate [x_cs] <= 1'b0;
                        end
                        else
                        begin
                            int_can_activate [x_cs] <= act_ready [chip_addr];
                        end
                    end
                end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        int_can_precharge [x_cs] <= 1'b0;
                    end
                    else
                    begin
                        if (stall_chip [chip_addr])
                        begin
                            int_can_precharge [x_cs] <= 1'b0;
                        end
                        else
                        begin
                            int_can_precharge [x_cs] <= pch_ready [chip_addr];
                        end
                    end
                end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        int_can_read [x_cs] <= 1'b0;
                    end
                    else
                    begin
                        if (stall_chip [chip_addr])
                        begin
                            int_can_read [x_cs] <= 1'b0;
                        end
                        else if (int_do_write)
                        begin
                            if (int_to_chip_c [chip_addr]) // to same chip addr as compared to current TBP
                            begin
                                if (int_do_burst_chop && more_than_3_wr_to_rd_bc)
                                begin
                                    int_can_read [x_cs] <= 1'b0;
                                end
                                else if (!int_do_burst_chop && more_than_3_wr_to_rd)
                                begin
                                    int_can_read [x_cs] <= 1'b0;
                                end
                                else
                                begin
                                    int_can_read [x_cs] <= 1'b1;
                                end
                            end
                            else // to other chip addr as compared to current TBP
                            begin
                                int_can_read [x_cs] <= 1'b0;
                            end
                        end
                        else if (int_do_read)
                        begin
                            if (int_to_chip_c [chip_addr]) // to same chip addr as compared to current TBP
                            begin
                                if (more_than_3_rd_to_rd)
                                begin
                                    int_can_read [x_cs] <= 1'b0;
                                end
                                else
                                begin
                                    int_can_read [x_cs] <= 1'b1;
                                end
                            end
                            else // to other chip addr as compared to current TBP
                            begin
                                int_can_read [x_cs] <= 1'b0;
                            end
                        end
                        else
                        begin
                            int_can_read [x_cs] <= read_ready [chip_addr];
                        end
                    end
                end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                begin
                    if (!ctl_reset_n)
                    begin
                        int_can_write [x_cs] <= 1'b0;
                    end
                    else
                    begin
                        if (stall_chip [chip_addr])
                        begin
                            int_can_write [x_cs] <= 1'b0;
                        end
                        else if (int_do_read)
                        begin
                            if (int_to_chip_c [chip_addr]) // to same chip addr as compared to current TBP
                            begin
                                if (int_do_burst_chop && more_than_3_rd_to_wr_bc)
                                begin
                                    int_can_write [x_cs] <= 1'b0;
                                end
                                else if (!int_do_burst_chop && more_than_3_rd_to_wr)
                                begin
                                    int_can_write [x_cs] <= 1'b0;
                                end
                                else
                                begin
                                    int_can_write [x_cs] <= 1'b1;
                                end
                            end
                            else // to other chip addr as compared to current TBP
                            begin
                                int_can_write [x_cs] <= 1'b0;
                            end
                        end
                        else if (int_do_write)
                        begin
                            if (int_to_chip_c [chip_addr]) // to same chip addr as compared to current TBP
                            begin
                                if (more_than_3_wr_to_wr)
                                begin
                                    int_can_write [x_cs] <= 1'b0;
                                end
                                else
                                begin
                                    int_can_write [x_cs] <= 1'b1;
                                end
                            end
                            else // to other chip addr as compared to current TBP
                            begin
                                int_can_write [x_cs] <= 1'b0;
                            end
                        end
                        else
                        begin
                            int_can_write [x_cs] <= write_ready [chip_addr];
                        end
                    end
                end
            end
            else
            begin
                // Can activate
                always @ (*)
                begin
                    can_activate [x_cs] = act_ready [chip_addr];
                end
                
                // Can precharge
                always @ (*)
                begin
                    can_precharge [x_cs] = pch_ready [chip_addr];
                end
                
                // Can read
                always @ (*)
                begin
                    can_read [x_cs] = read_ready [chip_addr];
                end
                
                // Can write
                always @ (*)
                begin
                    can_write [x_cs] = write_ready [chip_addr];
                end
            end
        end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Output
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Timing Parameter Comparison Logic
//
//--------------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_act_to_act_diff_bank <= 1'b0;
        end
        else
        begin
            if (t_param_act_to_act_diff_bank <= 1)
                less_than_1_act_to_act_diff_bank <= 1'b1;
            else
                less_than_1_act_to_act_diff_bank <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_act_to_act_diff_bank <= 1'b0;
        end
        else
        begin
            if (t_param_act_to_act_diff_bank <= 2)
                less_than_2_act_to_act_diff_bank <= 1'b1;
            else
                less_than_2_act_to_act_diff_bank <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_act_to_act_diff_bank <= 1'b0;
        end
        else
        begin
            if (t_param_act_to_act_diff_bank <= 3)
                less_than_3_act_to_act_diff_bank <= 1'b1;
            else
                less_than_3_act_to_act_diff_bank <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_act_to_act_diff_bank <= 1'b0;
        end
        else
        begin
            if (t_param_act_to_act_diff_bank <= 4)
                less_than_4_act_to_act_diff_bank <= 1'b1;
            else
                less_than_4_act_to_act_diff_bank <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_four_act_to_act <= 1'b0;
        end
        else
        begin
            if (t_param_four_act_to_act <= 4)
                less_than_4_four_act_to_act <= 1'b1;
            else
                less_than_4_four_act_to_act <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_rd_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd <= 1)
                less_than_1_rd_to_rd <= 1'b1;
            else
                less_than_1_rd_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_rd_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr <= 1)
                less_than_1_rd_to_wr <= 1'b1;
            else
                less_than_1_rd_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_wr_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr <= 1)
                less_than_1_wr_to_wr <= 1'b1;
            else
                less_than_1_wr_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_wr_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd <= 1)
                less_than_1_wr_to_rd <= 1'b1;
            else
                less_than_1_wr_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_rd_to_wr_bc <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_bc <= 1)
                less_than_1_rd_to_wr_bc <= 1'b1;
            else
                less_than_1_rd_to_wr_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_wr_to_rd_bc <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_bc <= 1)
                less_than_1_wr_to_rd_bc <= 1'b1;
            else
                less_than_1_wr_to_rd_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_rd_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd_diff_chip <= 1)
                less_than_1_rd_to_rd_diff_chip <= 1'b1;
            else
                less_than_1_rd_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_rd_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_diff_chip <= 1)
                less_than_1_rd_to_wr_diff_chip <= 1'b1;
            else
                less_than_1_rd_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_wr_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr_diff_chip <= 1)
                less_than_1_wr_to_wr_diff_chip <= 1'b1;
            else
                less_than_1_wr_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_1_wr_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_diff_chip <= 1)
                less_than_1_wr_to_rd_diff_chip <= 1'b1;
            else
                less_than_1_wr_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_rd_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd <= 2)
                less_than_2_rd_to_rd <= 1'b1;
            else
                less_than_2_rd_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_rd_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr <= 2)
                less_than_2_rd_to_wr <= 1'b1;
            else
                less_than_2_rd_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_wr_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr <= 2)
                less_than_2_wr_to_wr <= 1'b1;
            else
                less_than_2_wr_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_wr_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd <= 2)
                less_than_2_wr_to_rd <= 1'b1;
            else
                less_than_2_wr_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_rd_to_wr_bc <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_bc <= 2)
                less_than_2_rd_to_wr_bc <= 1'b1;
            else
                less_than_2_rd_to_wr_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_wr_to_rd_bc <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_bc <= 2)
                less_than_2_wr_to_rd_bc <= 1'b1;
            else
                less_than_2_wr_to_rd_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_rd_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd_diff_chip <= 2)
                less_than_2_rd_to_rd_diff_chip <= 1'b1;
            else
                less_than_2_rd_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_rd_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_diff_chip <= 2)
                less_than_2_rd_to_wr_diff_chip <= 1'b1;
            else
                less_than_2_rd_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_wr_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr_diff_chip <= 2)
                less_than_2_wr_to_wr_diff_chip <= 1'b1;
            else
                less_than_2_wr_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_2_wr_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_diff_chip <= 2)
                less_than_2_wr_to_rd_diff_chip <= 1'b1;
            else
                less_than_2_wr_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_rd_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd <= 3)
                less_than_3_rd_to_rd <= 1'b1;
            else
                less_than_3_rd_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_rd_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr <= 3)
                less_than_3_rd_to_wr <= 1'b1;
            else
                less_than_3_rd_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_wr_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr <= 3)
                less_than_3_wr_to_wr <= 1'b1;
            else
                less_than_3_wr_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_wr_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd <= 3)
                less_than_3_wr_to_rd <= 1'b1;
            else
                less_than_3_wr_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_rd_to_wr_bc <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_bc <= 3)
                less_than_3_rd_to_wr_bc <= 1'b1;
            else
                less_than_3_rd_to_wr_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_wr_to_rd_bc <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_bc <= 3)
                less_than_3_wr_to_rd_bc <= 1'b1;
            else
                less_than_3_wr_to_rd_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_rd_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd_diff_chip <= 3)
                less_than_3_rd_to_rd_diff_chip <= 1'b1;
            else
                less_than_3_rd_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_rd_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_diff_chip <= 3)
                less_than_3_rd_to_wr_diff_chip <= 1'b1;
            else
                less_than_3_rd_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_wr_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr_diff_chip <= 3)
                less_than_3_wr_to_wr_diff_chip <= 1'b1;
            else
                less_than_3_wr_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_3_wr_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_diff_chip <= 3)
                less_than_3_wr_to_rd_diff_chip <= 1'b1;
            else
                less_than_3_wr_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_rd_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd <= 4)
                less_than_4_rd_to_rd <= 1'b1;
            else
                less_than_4_rd_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_rd_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr <= 4)
                less_than_4_rd_to_wr <= 1'b1;
            else
                less_than_4_rd_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_wr_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr <= 4)
                less_than_4_wr_to_wr <= 1'b1;
            else
                less_than_4_wr_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_wr_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd <= 4)
                less_than_4_wr_to_rd <= 1'b1;
            else
                less_than_4_wr_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_rd_to_wr_bc <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_bc <= 4)
                less_than_4_rd_to_wr_bc <= 1'b1;
            else
                less_than_4_rd_to_wr_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_wr_to_rd_bc <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_bc <= 4)
                less_than_4_wr_to_rd_bc <= 1'b1;
            else
                less_than_4_wr_to_rd_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_rd_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd_diff_chip <= 4)
                less_than_4_rd_to_rd_diff_chip <= 1'b1;
            else
                less_than_4_rd_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_rd_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_diff_chip <= 4)
                less_than_4_rd_to_wr_diff_chip <= 1'b1;
            else
                less_than_4_rd_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_wr_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr_diff_chip <= 4)
                less_than_4_wr_to_wr_diff_chip <= 1'b1;
            else
                less_than_4_wr_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            less_than_4_wr_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_diff_chip <= 4)
                less_than_4_wr_to_rd_diff_chip <= 1'b1;
            else
                less_than_4_wr_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_rd_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd >= 3)
                more_than_3_rd_to_rd <= 1'b1;
            else
                more_than_3_rd_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_rd_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr >= 3)
                more_than_3_rd_to_wr <= 1'b1;
            else
                more_than_3_rd_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_wr_to_wr <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr >= 3)
                more_than_3_wr_to_wr <= 1'b1;
            else
                more_than_3_wr_to_wr <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_wr_to_rd <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd >= 3)
                more_than_3_wr_to_rd <= 1'b1;
            else
                more_than_3_wr_to_rd <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_rd_to_wr_bc <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_bc >= 3)
                more_than_3_rd_to_wr_bc <= 1'b1;
            else
                more_than_3_rd_to_wr_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_wr_to_rd_bc <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_bc >= 3)
                more_than_3_wr_to_rd_bc <= 1'b1;
            else
                more_than_3_wr_to_rd_bc <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_rd_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_rd_diff_chip >= 3)
                more_than_3_rd_to_rd_diff_chip <= 1'b1;
            else
                more_than_3_rd_to_rd_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_rd_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_rd_to_wr_diff_chip >= 3)
                more_than_3_rd_to_wr_diff_chip <= 1'b1;
            else
                more_than_3_rd_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_wr_to_wr_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_wr_diff_chip >= 3)
                more_than_3_wr_to_wr_diff_chip <= 1'b1;
            else
                more_than_3_wr_to_wr_diff_chip <= 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            more_than_3_wr_to_rd_diff_chip <= 1'b0;
        end
        else
        begin
            if (t_param_wr_to_rd_diff_chip >= 3)
                more_than_3_wr_to_rd_diff_chip <= 1'b1;
            else
                more_than_3_wr_to_rd_diff_chip <= 1'b0;
        end
    end
    
    generate
    begin
        if (CFG_REG_GRANT)
        begin
            always @ (*)
            begin
                if (CFG_RANK_TIMER_OUTPUT_REG)
                begin
                    less_than_xn1_act_to_act_diff_bank = less_than_2_act_to_act_diff_bank;
                    less_than_xn1_rd_to_rd             = less_than_2_rd_to_rd;
                    less_than_xn1_rd_to_wr             = less_than_2_rd_to_wr;
                    less_than_xn1_wr_to_wr             = less_than_2_wr_to_wr;
                    less_than_xn1_wr_to_rd             = less_than_2_wr_to_rd;
                    less_than_xn1_rd_to_wr_bc          = less_than_2_rd_to_wr_bc;
                    less_than_xn1_wr_to_rd_bc          = less_than_2_wr_to_rd_bc;
                    less_than_xn1_rd_to_rd_diff_chip   = less_than_2_rd_to_rd_diff_chip;
                    less_than_xn1_rd_to_wr_diff_chip   = less_than_2_rd_to_wr_diff_chip;
                    less_than_xn1_wr_to_wr_diff_chip   = less_than_2_wr_to_wr_diff_chip;
                    less_than_xn1_wr_to_rd_diff_chip   = less_than_2_wr_to_rd_diff_chip;
                    
                    less_than_x0_act_to_act_diff_bank  = less_than_3_act_to_act_diff_bank;
                    less_than_x0_rd_to_rd              = less_than_3_rd_to_rd;
                    less_than_x0_rd_to_wr              = less_than_3_rd_to_wr;
                    less_than_x0_wr_to_wr              = less_than_3_wr_to_wr;
                    less_than_x0_wr_to_rd              = less_than_3_wr_to_rd;
                    less_than_x0_rd_to_wr_bc           = less_than_3_rd_to_wr_bc;
                    less_than_x0_wr_to_rd_bc           = less_than_3_wr_to_rd_bc;
                    less_than_x0_rd_to_rd_diff_chip    = less_than_3_rd_to_rd_diff_chip;
                    less_than_x0_rd_to_wr_diff_chip    = less_than_3_rd_to_wr_diff_chip;
                    less_than_x0_wr_to_wr_diff_chip    = less_than_3_wr_to_wr_diff_chip;
                    less_than_x0_wr_to_rd_diff_chip    = less_than_3_wr_to_rd_diff_chip;
                    
                    less_than_x1_act_to_act_diff_bank  = less_than_4_act_to_act_diff_bank;
                    less_than_x1_rd_to_rd              = less_than_4_rd_to_rd;
                    less_than_x1_rd_to_wr              = less_than_4_rd_to_wr;
                    less_than_x1_wr_to_wr              = less_than_4_wr_to_wr;
                    less_than_x1_wr_to_rd              = less_than_4_wr_to_rd;
                    less_than_x1_rd_to_wr_bc           = less_than_4_rd_to_wr_bc;
                    less_than_x1_wr_to_rd_bc           = less_than_4_wr_to_rd_bc;
                    less_than_x1_rd_to_rd_diff_chip    = less_than_4_rd_to_rd_diff_chip;
                    less_than_x1_rd_to_wr_diff_chip    = less_than_4_rd_to_wr_diff_chip;
                    less_than_x1_wr_to_wr_diff_chip    = less_than_4_wr_to_wr_diff_chip;
                    less_than_x1_wr_to_rd_diff_chip    = less_than_4_wr_to_rd_diff_chip;
                end
                else
                begin
                    // Doesn't matter for less_than_xn1_* if CFG_RANK_TIMER_OUTPUT_REG is '0'
                    less_than_xn1_act_to_act_diff_bank = less_than_2_act_to_act_diff_bank;
                    less_than_xn1_rd_to_rd             = less_than_2_rd_to_rd;
                    less_than_xn1_rd_to_wr             = less_than_2_rd_to_wr;
                    less_than_xn1_wr_to_wr             = less_than_2_wr_to_wr;
                    less_than_xn1_wr_to_rd             = less_than_2_wr_to_rd;
                    less_than_xn1_rd_to_wr_bc          = less_than_2_rd_to_wr_bc;
                    less_than_xn1_wr_to_rd_bc          = less_than_2_wr_to_rd_bc;
                    less_than_xn1_rd_to_rd_diff_chip   = less_than_2_rd_to_rd_diff_chip;
                    less_than_xn1_rd_to_wr_diff_chip   = less_than_2_rd_to_wr_diff_chip;
                    less_than_xn1_wr_to_wr_diff_chip   = less_than_2_wr_to_wr_diff_chip;
                    less_than_xn1_wr_to_rd_diff_chip   = less_than_2_wr_to_rd_diff_chip;
                    
                    less_than_x0_act_to_act_diff_bank  = less_than_2_act_to_act_diff_bank;
                    less_than_x0_rd_to_rd              = less_than_2_rd_to_rd;
                    less_than_x0_rd_to_wr              = less_than_2_rd_to_wr;
                    less_than_x0_wr_to_wr              = less_than_2_wr_to_wr;
                    less_than_x0_wr_to_rd              = less_than_2_wr_to_rd;
                    less_than_x0_rd_to_wr_bc           = less_than_2_rd_to_wr_bc;
                    less_than_x0_wr_to_rd_bc           = less_than_2_wr_to_rd_bc;
                    less_than_x0_rd_to_rd_diff_chip    = less_than_2_rd_to_rd_diff_chip;
                    less_than_x0_rd_to_wr_diff_chip    = less_than_2_rd_to_wr_diff_chip;
                    less_than_x0_wr_to_wr_diff_chip    = less_than_2_wr_to_wr_diff_chip;
                    less_than_x0_wr_to_rd_diff_chip    = less_than_2_wr_to_rd_diff_chip;
                    
                    less_than_x1_act_to_act_diff_bank  = less_than_3_act_to_act_diff_bank;
                    less_than_x1_rd_to_rd              = less_than_3_rd_to_rd;
                    less_than_x1_rd_to_wr              = less_than_3_rd_to_wr;
                    less_than_x1_wr_to_wr              = less_than_3_wr_to_wr;
                    less_than_x1_wr_to_rd              = less_than_3_wr_to_rd;
                    less_than_x1_rd_to_wr_bc           = less_than_3_rd_to_wr_bc;
                    less_than_x1_wr_to_rd_bc           = less_than_3_wr_to_rd_bc;
                    less_than_x1_rd_to_rd_diff_chip    = less_than_3_rd_to_rd_diff_chip;
                    less_than_x1_rd_to_wr_diff_chip    = less_than_3_rd_to_wr_diff_chip;
                    less_than_x1_wr_to_wr_diff_chip    = less_than_3_wr_to_wr_diff_chip;
                    less_than_x1_wr_to_rd_diff_chip    = less_than_3_wr_to_rd_diff_chip;
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                if (CFG_RANK_TIMER_OUTPUT_REG)
                begin
                    less_than_xn1_act_to_act_diff_bank = less_than_1_act_to_act_diff_bank;
                    less_than_xn1_rd_to_rd             = less_than_1_rd_to_rd;
                    less_than_xn1_rd_to_wr             = less_than_1_rd_to_wr;
                    less_than_xn1_wr_to_wr             = less_than_1_wr_to_wr;
                    less_than_xn1_wr_to_rd             = less_than_1_wr_to_rd;
                    less_than_xn1_rd_to_wr_bc          = less_than_1_rd_to_wr_bc;
                    less_than_xn1_wr_to_rd_bc          = less_than_1_wr_to_rd_bc;
                    less_than_xn1_rd_to_rd_diff_chip   = less_than_1_rd_to_rd_diff_chip;
                    less_than_xn1_rd_to_wr_diff_chip   = less_than_1_rd_to_wr_diff_chip;
                    less_than_xn1_wr_to_wr_diff_chip   = less_than_1_wr_to_wr_diff_chip;
                    less_than_xn1_wr_to_rd_diff_chip   = less_than_1_wr_to_rd_diff_chip;
                    
                    less_than_x0_act_to_act_diff_bank  = less_than_2_act_to_act_diff_bank;
                    less_than_x0_rd_to_rd              = less_than_2_rd_to_rd;
                    less_than_x0_rd_to_wr              = less_than_2_rd_to_wr;
                    less_than_x0_wr_to_wr              = less_than_2_wr_to_wr;
                    less_than_x0_wr_to_rd              = less_than_2_wr_to_rd;
                    less_than_x0_rd_to_wr_bc           = less_than_2_rd_to_wr_bc;
                    less_than_x0_wr_to_rd_bc           = less_than_2_wr_to_rd_bc;
                    less_than_x0_rd_to_rd_diff_chip    = less_than_2_rd_to_rd_diff_chip;
                    less_than_x0_rd_to_wr_diff_chip    = less_than_2_rd_to_wr_diff_chip;
                    less_than_x0_wr_to_wr_diff_chip    = less_than_2_wr_to_wr_diff_chip;
                    less_than_x0_wr_to_rd_diff_chip    = less_than_2_wr_to_rd_diff_chip;
                    
                    less_than_x1_act_to_act_diff_bank = less_than_3_act_to_act_diff_bank;
                    less_than_x1_rd_to_rd             = less_than_3_rd_to_rd;
                    less_than_x1_rd_to_wr             = less_than_3_rd_to_wr;
                    less_than_x1_wr_to_wr             = less_than_3_wr_to_wr;
                    less_than_x1_wr_to_rd             = less_than_3_wr_to_rd;
                    less_than_x1_rd_to_wr_bc          = less_than_3_rd_to_wr_bc;
                    less_than_x1_wr_to_rd_bc          = less_than_3_wr_to_rd_bc;
                    less_than_x1_rd_to_rd_diff_chip   = less_than_3_rd_to_rd_diff_chip;
                    less_than_x1_rd_to_wr_diff_chip   = less_than_3_rd_to_wr_diff_chip;
                    less_than_x1_wr_to_wr_diff_chip   = less_than_3_wr_to_wr_diff_chip;
                    less_than_x1_wr_to_rd_diff_chip   = less_than_3_wr_to_rd_diff_chip;
                end
                else
                begin
                    // Doesn't matter for less_than_xn1_* if CFG_RANK_TIMER_OUTPUT_REG is '0'
                    less_than_xn1_act_to_act_diff_bank = less_than_1_act_to_act_diff_bank;
                    less_than_xn1_rd_to_rd             = less_than_1_rd_to_rd;
                    less_than_xn1_rd_to_wr             = less_than_1_rd_to_wr;
                    less_than_xn1_wr_to_wr             = less_than_1_wr_to_wr;
                    less_than_xn1_wr_to_rd             = less_than_1_wr_to_rd;
                    less_than_xn1_rd_to_wr_bc          = less_than_1_rd_to_wr_bc;
                    less_than_xn1_wr_to_rd_bc          = less_than_1_wr_to_rd_bc;
                    less_than_xn1_rd_to_rd_diff_chip   = less_than_1_rd_to_rd_diff_chip;
                    less_than_xn1_rd_to_wr_diff_chip   = less_than_1_rd_to_wr_diff_chip;
                    less_than_xn1_wr_to_wr_diff_chip   = less_than_1_wr_to_wr_diff_chip;
                    less_than_xn1_wr_to_rd_diff_chip   = less_than_1_wr_to_rd_diff_chip;
                    
                    less_than_x0_act_to_act_diff_bank  = less_than_1_act_to_act_diff_bank;
                    less_than_x0_rd_to_rd              = less_than_1_rd_to_rd;
                    less_than_x0_rd_to_wr              = less_than_1_rd_to_wr;
                    less_than_x0_wr_to_wr              = less_than_1_wr_to_wr;
                    less_than_x0_wr_to_rd              = less_than_1_wr_to_rd;
                    less_than_x0_rd_to_wr_bc           = less_than_1_rd_to_wr_bc;
                    less_than_x0_wr_to_rd_bc           = less_than_1_wr_to_rd_bc;
                    less_than_x0_rd_to_rd_diff_chip    = less_than_1_rd_to_rd_diff_chip;
                    less_than_x0_rd_to_wr_diff_chip    = less_than_1_rd_to_wr_diff_chip;
                    less_than_x0_wr_to_wr_diff_chip    = less_than_1_wr_to_wr_diff_chip;
                    less_than_x0_wr_to_rd_diff_chip    = less_than_1_wr_to_rd_diff_chip;
                    
                    less_than_x1_act_to_act_diff_bank  = less_than_2_act_to_act_diff_bank;
                    less_than_x1_rd_to_rd              = less_than_2_rd_to_rd;
                    less_than_x1_rd_to_wr              = less_than_2_rd_to_wr;
                    less_than_x1_wr_to_wr              = less_than_2_wr_to_wr;
                    less_than_x1_wr_to_rd              = less_than_2_wr_to_rd;
                    less_than_x1_rd_to_wr_bc           = less_than_2_rd_to_wr_bc;
                    less_than_x1_wr_to_rd_bc           = less_than_2_wr_to_rd_bc;
                    less_than_x1_rd_to_rd_diff_chip    = less_than_2_rd_to_rd_diff_chip;
                    less_than_x1_rd_to_wr_diff_chip    = less_than_2_rd_to_wr_diff_chip;
                    less_than_x1_wr_to_wr_diff_chip    = less_than_2_wr_to_wr_diff_chip;
                    less_than_x1_wr_to_rd_diff_chip    = less_than_2_wr_to_rd_diff_chip;
                end
            end
        end
    end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Timing Parameter Comparison Logic
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Activate Monitor
//  
//  Monitors the following rank timing parameters:
//  
//  - tFAW, four activate window, only four activate is allowed in a specific timing window
//  - tRRD, activate to activate different bank
//
//--------------------------------------------------------------------------------------------------------

    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            sel_act_tfaw_shift_out_point <= 0;
        end
        else
        begin
            if (ENABLE_BETTER_TRRD_EFFICIENCY)
            begin
                sel_act_tfaw_shift_out_point <= t_param_four_act_to_act - RANK_TIMER_TFAW_OFFSET + 1;
            end
            else
            begin
                sel_act_tfaw_shift_out_point <= t_param_four_act_to_act - RANK_TIMER_TFAW_OFFSET;
            end
        end
    end
    
    generate
        genvar t_cs;
        genvar t_tfaw;
        for (t_cs = 0;t_cs < CFG_MEM_IF_CHIP;t_cs = t_cs + 1)
        begin : act_monitor_per_chip
            //----------------------------------------------------------------------------------------------------
            // tFAW Monitor
            //----------------------------------------------------------------------------------------------------
            reg [ACTIVATE_COMMAND_WIDTH - 1 : 0] act_tfaw_cmd_cnt;
            reg [NUM_OF_TFAW_SHIFT_REG  - 1 : 0] act_tfaw_shift_reg;
            
            assign act_tfaw_cmd_count [t_cs] = act_tfaw_cmd_cnt;
            
            // Shift register to keep track of tFAW
            // Shift in -> n, n-1, n-2, n-3.......4, 3 -> Shift out
            // Shift in '1' when there is an activate else shift in '0'
            // Shift out every clock cycles
            
            // Shift register [3]
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_tfaw_shift_reg [3] <= 1'b0;
                end
                else
                begin
                    // Shift in '1' if there is an activate
                    // else shift in '0'
                    if (int_do_activate && int_to_chip_r [t_cs])
                        act_tfaw_shift_reg [3] <= 1'b1;
                    else
                        act_tfaw_shift_reg [3] <= 1'b0;
                end
            end
            
            // Shift register [n : 3]
            for (t_tfaw = 4;t_tfaw < NUM_OF_TFAW_SHIFT_REG;t_tfaw = t_tfaw + 1)
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
                    act_tfaw_cmd_cnt <= 0;
                end
                else
                begin
                    if (int_do_activate && int_to_chip_r [t_cs])
                    begin
                        if (act_tfaw_shift_reg [sel_act_tfaw_shift_out_point]) // Shift out when activate reaches tFAW point in shift register
                            act_tfaw_cmd_cnt <= act_tfaw_cmd_cnt;
                        else
                            act_tfaw_cmd_cnt <= act_tfaw_cmd_cnt + 1'b1;
                    end
                    else if (act_tfaw_shift_reg [sel_act_tfaw_shift_out_point]) // Shift out when activate reaches tFAW point in shift register
                        act_tfaw_cmd_cnt <= act_tfaw_cmd_cnt - 1'b1;
                end
            end
            
            // tFAW ready signal
            always @ (*)
            begin
                // If tFAW is lesser than 4, this means we can do back-to-back activate without tFAW constraint
                if (less_than_4_four_act_to_act)
                begin
                    act_tfaw_ready_combi [t_cs] = 1'b1;
                end
                else
                begin
                    if (int_do_activate && int_to_chip_r [t_cs] && act_tfaw_cmd_cnt == 3'd3)
                        act_tfaw_ready_combi [t_cs] = 1'b0;
                    else if (act_tfaw_cmd_cnt < 3'd4)
                        act_tfaw_ready_combi [t_cs] = 1'b1;
                    else
                        act_tfaw_ready_combi [t_cs] = 1'b0;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_tfaw_ready [t_cs] <= 1'b0;
                end
                else
                begin
                    act_tfaw_ready [t_cs] <= act_tfaw_ready_combi [t_cs];
                end
            end
            
            //----------------------------------------------------------------------------------------------------
            // tRRD Monitor
            //----------------------------------------------------------------------------------------------------
            reg [ACTIVATE_COUNTER_WIDTH - 1 : 0] act_trrd_cnt;
            
            // tRRD counter
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_trrd_cnt <= 0;
                end
                else
                begin
                    if (int_do_activate && int_to_chip_r [t_cs])
                    begin
                        if (ENABLE_BETTER_TRRD_EFFICIENCY)
                        begin
                            act_trrd_cnt <= RANK_TIMER_COUNTER_OFFSET - 1;
                        end
                        else
                        begin
                            act_trrd_cnt <= RANK_TIMER_COUNTER_OFFSET;
                        end
                    end
                    else if (act_trrd_cnt != {ACTIVATE_COUNTER_WIDTH{1'b1}})
                    begin
                        act_trrd_cnt <= act_trrd_cnt + 1'b1;
                    end
                end
            end
            
            // tRRD monitor
            always @ (*)
            begin
                if (int_do_activate && int_to_chip_r [t_cs])
                begin
                    if (!ENABLE_BETTER_TRRD_EFFICIENCY && less_than_x0_act_to_act_diff_bank)
                        act_trrd_ready_combi [t_cs] = 1'b1;
                    else if (ENABLE_BETTER_TRRD_EFFICIENCY && less_than_xn1_act_to_act_diff_bank)
                        act_trrd_ready_combi [t_cs] = 1'b1;
                    else
                        act_trrd_ready_combi [t_cs] = 1'b0;
                end
                else if (act_trrd_cnt >= t_param_act_to_act_diff_bank)
                    act_trrd_ready_combi [t_cs] = 1'b1;
                else
                    act_trrd_ready_combi [t_cs] = 1'b0;
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    act_trrd_ready [t_cs] <= 1'b0;
                end
                else
                begin
                    act_trrd_ready [t_cs] <= act_trrd_ready_combi [t_cs];
                end
            end
            
            //----------------------------------------------------------------------------------------------------
            // Overall activate ready
            //----------------------------------------------------------------------------------------------------
            always @ (*)
            begin
                if (!CFG_RANK_TIMER_OUTPUT_REG && stall_chip [t_cs])
                begin
                    act_ready [t_cs] = 1'b0;
                end
                else
                begin
                    if (ENABLE_BETTER_TRRD_EFFICIENCY)
                    begin
                        act_ready [t_cs] = act_trrd_ready_combi [t_cs] & act_tfaw_ready_combi [t_cs];
                    end
                    else
                    begin
                        act_ready [t_cs] = act_trrd_ready [t_cs] & act_tfaw_ready [t_cs];
                    end
                end
            end
        end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Activate Monitor
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Read/Write Monitor
//  
//  Monitors the following rank timing parameters:
//  
//  - Write to read timing parameter (tWTR)
//  - Read to write timing parameter
//  
//  Missing Features:
//  
//  - Burst interrupt
//  - Burst terminate
//
//--------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------
    // Effective Timing Parameters
    // Only when burst interrupt option is enabled
    //----------------------------------------------------------------------------------------------------
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
            effective_rd_to_wr           <= 0;
            effective_rd_to_wr_diff_chip <= 0;
            effective_wr_to_rd           <= 0;
            effective_wr_to_rd_diff_chip <= 0;
        end
        else
        begin
            if (int_do_burst_chop)
            begin
                effective_rd_to_wr           <= t_param_rd_to_wr_bc;
                effective_rd_to_wr_diff_chip <= t_param_rd_to_wr_diff_chip;
                effective_wr_to_rd           <= t_param_wr_to_rd_bc;
                effective_wr_to_rd_diff_chip <= t_param_wr_to_rd_diff_chip;
            end
            else if (int_do_burst_terminate)
            begin
                if (t_param_rd_to_wr > (max_local_burst_size - int_effective_size))
                    effective_rd_to_wr           <= t_param_rd_to_wr           - (max_local_burst_size - int_effective_size);
                else
                    effective_rd_to_wr           <= 1'b1;
                
                if (t_param_rd_to_wr_diff_chip > (max_local_burst_size - int_effective_size))
                    effective_rd_to_wr_diff_chip <= t_param_rd_to_wr_diff_chip - (max_local_burst_size - int_effective_size);
                else
                    effective_rd_to_wr_diff_chip <= 1'b1;
                
                if (t_param_wr_to_rd > (max_local_burst_size - int_effective_size))
                    effective_wr_to_rd           <= t_param_wr_to_rd           - (max_local_burst_size - int_effective_size);
                else
                    effective_wr_to_rd           <= 1'b1;
                
                if (t_param_wr_to_rd_diff_chip > (max_local_burst_size - int_effective_size))
                    effective_wr_to_rd_diff_chip <= t_param_wr_to_rd_diff_chip - (max_local_burst_size - int_effective_size);
                else
                    effective_wr_to_rd_diff_chip <= 1'b1;
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Read / Write State Machine
    //----------------------------------------------------------------------------------------------------
    generate
        genvar s_cs;
        for (s_cs = 0;s_cs < CFG_MEM_IF_CHIP;s_cs = s_cs + 1)
        begin : rdwr_monitor_per_chip
            reg [31                     : 0] rdwr_state;
            reg [RDWR_COUNTER_WIDTH - 1 : 0] read_cnt_this_chip;
            reg [RDWR_COUNTER_WIDTH - 1 : 0] write_cnt_this_chip;
            reg [RDWR_COUNTER_WIDTH - 1 : 0] read_cnt_diff_chip;
            reg [RDWR_COUNTER_WIDTH - 1 : 0] write_cnt_diff_chip;
            reg                              int_do_read_this_chip;
            reg                              int_do_write_this_chip;
            reg                              int_do_read_diff_chip;
            reg                              int_do_write_diff_chip;
            
            reg                              doing_burst_chop;
            reg                              doing_burst_terminate;
            
            reg                              int_read_ready;
            reg                              int_write_ready;
            
            // Do read/write to this/different chip
            always @ (*)
            begin
                if (int_do_read)
                begin
                    if (int_to_chip_c [s_cs])
                    begin
                        int_do_read_this_chip = 1'b1;
                        int_do_read_diff_chip = 1'b0;
                    end
                    else
                    begin
                        int_do_read_this_chip = 1'b0;
                        int_do_read_diff_chip = 1'b1;
                    end
                end
                else
                begin
                    int_do_read_this_chip = 1'b0;
                    int_do_read_diff_chip = 1'b0;
                end
            end
            
            always @ (*)
            begin
                if (int_do_write)
                begin
                    if (int_to_chip_c [s_cs])
                    begin
                        int_do_write_this_chip = 1'b1;
                        int_do_write_diff_chip = 1'b0;
                    end
                    else
                    begin
                        int_do_write_this_chip = 1'b0;
                        int_do_write_diff_chip = 1'b1;
                    end
                end
                else
                begin
                    int_do_write_this_chip = 1'b0;
                    int_do_write_diff_chip = 1'b0;
                end
            end
            
            // Read write counter to this chip address
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    read_cnt_this_chip  <= 0;
                    write_cnt_this_chip <= 0;
                end
                else
                begin
                    if (int_do_read_this_chip)
                        read_cnt_this_chip <= RANK_TIMER_COUNTER_OFFSET;
                    else if (read_cnt_this_chip != {RDWR_COUNTER_WIDTH{1'b1}})
                        read_cnt_this_chip <= read_cnt_this_chip + 1'b1;
                    
                    if (int_do_write_this_chip)
                        write_cnt_this_chip <= RANK_TIMER_COUNTER_OFFSET;
                    else if (write_cnt_this_chip != {RDWR_COUNTER_WIDTH{1'b1}})
                        write_cnt_this_chip <= write_cnt_this_chip + 1'b1;
                end
            end
            
            // Read write counter to different chip address
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    read_cnt_diff_chip  <= 0;
                    write_cnt_diff_chip <= 0;
                end
                else
                begin
                    if (int_do_read_diff_chip)
                        read_cnt_diff_chip <= RANK_TIMER_COUNTER_OFFSET;
                    else if (read_cnt_diff_chip != {RDWR_COUNTER_WIDTH{1'b1}})
                        read_cnt_diff_chip <= read_cnt_diff_chip + 1'b1;
                    
                    if (int_do_write_diff_chip)
                        write_cnt_diff_chip <= RANK_TIMER_COUNTER_OFFSET;
                    else if (write_cnt_diff_chip != {RDWR_COUNTER_WIDTH{1'b1}})
                        write_cnt_diff_chip <= write_cnt_diff_chip + 1'b1;
                end
            end
            
            // Doing burst chop signal
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    doing_burst_chop <= 1'b0;
                end
                else
                begin
                    if (int_do_read || int_do_write)
                    begin
                        if (int_do_burst_chop)
                            doing_burst_chop <= 1'b1;
                        else
                            doing_burst_chop <= 1'b0;
                    end
                end
            end
            
            // Doing burst terminate signal
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    doing_burst_terminate <= 1'b0;
                end
                else
                begin
                    if (int_do_read || int_do_write)
                        doing_burst_terminate <= 1'b0;
                    else if (int_do_burst_terminate)
                        doing_burst_terminate <= 1'b1;
                end
            end
            
            // Register comparison logic for better fMAX
            reg compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd;
            reg compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip;
            reg compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr;
            reg compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip;
            reg compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr;
            reg compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip;
            reg compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd;
            reg compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip;
            
            reg compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr;
            reg compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip;
            reg compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd;
            reg compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip;
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           <= 1'b0;
                    compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip <= 1'b0;
                    compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           <= 1'b0;
                    compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip <= 1'b0;
                    compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           <= 1'b0;
                    compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip <= 1'b0;
                    compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           <= 1'b0;
                    compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip <= 1'b0;
                end
                else
                begin
                    // Read to this chip comparison
                    if (int_do_read_this_chip)
                    begin
                        if (less_than_x1_rd_to_rd)
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           <= 1'b0;
                        end
                        
                        if (less_than_x1_rd_to_wr)
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (read_cnt_this_chip >= (t_param_rd_to_rd - 1'b1))
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           <= 1'b0;
                        end
                        
                        if (read_cnt_this_chip >= (t_param_rd_to_wr - 1'b1))
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           <= 1'b0;
                        end
                    end
                    
                    // Read to different chip comparison
                    if (int_do_read_diff_chip)
                    begin
                        if (less_than_x1_rd_to_rd_diff_chip)
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip <= 1'b0;
                        end
                        
                        if (less_than_x1_rd_to_wr_diff_chip)
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (read_cnt_diff_chip >= (t_param_rd_to_rd_diff_chip - 1'b1))
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip <= 1'b0;
                        end
                        
                        if (read_cnt_diff_chip >= (t_param_rd_to_wr_diff_chip - 1'b1))
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip <= 1'b0;
                        end
                    end
                    
                    // Write to this chip comparison
                    if (int_do_write_this_chip)
                    begin
                        if (less_than_x1_wr_to_wr)
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           <= 1'b0;
                        end
                        
                        if (less_than_x1_wr_to_rd)
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (write_cnt_this_chip >= (t_param_wr_to_wr - 1'b1))
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           <= 1'b0;
                        end
                        
                        if (write_cnt_this_chip >= (t_param_wr_to_rd - 1'b1))
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           <= 1'b0;
                        end
                    end
                    
                    // Write to different chip comparison
                    if (int_do_write_diff_chip)
                    begin
                        if (less_than_x1_wr_to_wr_diff_chip)
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip <= 1'b0;
                        end
                        
                        if (less_than_x1_wr_to_rd_diff_chip)
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (write_cnt_diff_chip >= (t_param_wr_to_wr_diff_chip - 1'b1))
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip <= 1'b0;
                        end
                        
                        if (write_cnt_diff_chip >= (t_param_wr_to_rd_diff_chip - 1'b1))
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           <= 1'b0;
                    compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip <= 1'b0;
                    compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd           <= 1'b0;
                    compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip <= 1'b0;
                end
                else
                begin
                    // Read to this chip comparison
                    if (int_do_read_this_chip)
                    begin
                        if (t_param_rd_to_wr <= RANK_TIMER_COUNTER_OFFSET)
                        // We're not comparing against effective_timing_param because it is not loaded yet!
                        // It'll take one clock cycle to load, therefore we'r taking the worst case parameter (to be safe on all scenario)
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (read_cnt_this_chip >= (effective_rd_to_wr - 1'b1))
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           <= 1'b0;
                        end
                    end
                    
                    // Read to different chip comparison
                    if (int_do_read_diff_chip)
                    begin
                        if (t_param_rd_to_wr_diff_chip <= RANK_TIMER_COUNTER_OFFSET)
                        // We're not comparing against effective_timing_param because it is not loaded yet!
                        // It'll take one clock cycle to load, therefore we'r taking the worst case parameter (to be safe on all scenario)
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (read_cnt_diff_chip >= (effective_rd_to_wr_diff_chip - 1'b1))
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip <= 1'b0;
                        end
                    end
                    
                    // Write to this chip comparison
                    if (int_do_write_this_chip)
                    begin
                        if (t_param_wr_to_rd <= RANK_TIMER_COUNTER_OFFSET)
                        // We're not comparing against effective_timing_param because it is not loaded yet!
                        // It'll take one clock cycle to load, therefore we'r taking the worst case parameter (to be safe on all scenario)
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd           <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd           <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (write_cnt_this_chip >= (effective_wr_to_rd - 1'b1))
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd           <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd           <= 1'b0;
                        end
                    end
                    
                    // Write to different chip comparison
                    if (int_do_write_diff_chip)
                    begin
                        if (t_param_wr_to_rd_diff_chip <= RANK_TIMER_COUNTER_OFFSET)
                        // We're not comparing against effective_timing_param because it is not loaded yet!
                        // It'll take one clock cycle to load, therefore we'r taking the worst case parameter (to be safe on all scenario)
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (write_cnt_diff_chip >= (effective_wr_to_rd_diff_chip - 1'b1))
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip <= 1'b1;
                        end
                        else
                        begin
                            compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip <= 1'b0;
                        end
                    end
                end
            end
            
            // Read write monitor state machine
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    rdwr_state      <= IDLE;
                    int_read_ready  <= 1'b0;
                    int_write_ready <= 1'b0;
                end
                else
                begin
                    case (rdwr_state)
                        IDLE :
                            begin
                                if (int_do_write_this_chip)
                                begin
                                    rdwr_state <= WR;
                                    
                                    if (int_do_burst_chop) // burst chop
                                    begin
                                        if (less_than_x0_wr_to_rd_bc)
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (less_than_x0_wr_to_rd)
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                    end
                                    
                                    if (less_than_x0_wr_to_wr)
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else if (int_do_write_diff_chip)
                                begin
                                    rdwr_state <= WR;
                                    
                                    if (less_than_x0_wr_to_rd_diff_chip)
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (less_than_x0_wr_to_wr_diff_chip)
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else if (int_do_read_this_chip)
                                begin
                                    rdwr_state <= RD;
                                    
                                    if (less_than_x0_rd_to_rd)
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (int_do_burst_chop) // burst chop
                                    begin
                                        if (less_than_x0_rd_to_wr_bc)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (less_than_x0_rd_to_wr)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                end
                                else if (int_do_read_diff_chip)
                                begin
                                    rdwr_state <= RD;
                                    
                                    if (less_than_x0_rd_to_rd_diff_chip)
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (less_than_x0_rd_to_wr_diff_chip)
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else
                                begin
                                    rdwr_state      <= IDLE;
                                    int_read_ready  <= 1'b1;
                                    int_write_ready <= 1'b1;
                                end
                            end
                        WR :
                            begin
                                if (int_do_write_this_chip)
                                begin
                                    rdwr_state <= WR;
                                    
                                    if (int_do_burst_chop) // burst chop
                                    begin
                                        if (less_than_x0_wr_to_rd_bc)
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (less_than_x0_wr_to_rd)
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                    end
                                    
                                    if (less_than_x0_wr_to_wr)
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else if (int_do_write_diff_chip)
                                begin
                                    rdwr_state <= WR;
                                    
                                    if (less_than_x0_wr_to_rd_diff_chip && compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd) // making sure previous write timing is satisfied
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (less_than_x0_wr_to_wr_diff_chip && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr) // making sure previous read timing is satisfied
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else if (int_do_read_this_chip)
                                begin
                                    rdwr_state <= RD;
                                    
                                    if (less_than_x0_rd_to_rd)
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (int_do_burst_chop) // burst chop
                                    begin
                                        if (less_than_x0_rd_to_wr_bc)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (less_than_x0_rd_to_wr)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                end
                                else if (int_do_read_diff_chip)
                                begin
                                    rdwr_state <= RD;
                                    
                                    if (less_than_x0_rd_to_rd_diff_chip && compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd) // making sure previous write timing is satisfied
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (less_than_x0_rd_to_wr_diff_chip && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr) // making sure previous read timing is satisfied
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else
                                begin
                                    if (doing_burst_chop || doing_burst_terminate) // burst chop or burst terminate
                                    begin
                                        if (compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd           && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           &&
                                            compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip && compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip   )
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                        
                                        if (compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           && compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           &&
                                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip && compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip   )
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           &&
                                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip && compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip   )
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                        
                                        if (compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           &&
                                            compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip && compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip   )
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                end
                            end
                        RD :
                            begin
                                if (int_do_write_this_chip)
                                begin
                                    rdwr_state <= WR;
                                    
                                    if (int_do_burst_chop) // burst chop
                                    begin
                                        if (less_than_x0_wr_to_rd_bc)
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (less_than_x0_wr_to_rd)
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                    end
                                    
                                    if (less_than_x0_wr_to_wr)
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else if (int_do_write_diff_chip)
                                begin
                                    rdwr_state <= WR;
                                    
                                    if (less_than_x0_wr_to_rd_diff_chip && compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd) // making sure previous write timing is satisfied
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (less_than_x0_wr_to_wr_diff_chip && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr) // making sure previous read timing is satisfied
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else if (int_do_read_this_chip)
                                begin
                                    rdwr_state <= RD;
                                    
                                    if (less_than_x0_rd_to_rd)
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (int_do_burst_chop) // burst chop
                                    begin
                                        if (less_than_x0_rd_to_wr_bc)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (less_than_x0_rd_to_wr)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                end
                                else if (int_do_read_diff_chip)
                                begin
                                    rdwr_state <= RD;
                                    
                                    if (less_than_x0_rd_to_rd_diff_chip && compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd) // making sure previous write timing is satisfied
                                        int_read_ready  <= 1'b1;
                                    else
                                        int_read_ready  <= 1'b0;
                                    
                                    if (less_than_x0_rd_to_wr_diff_chip && compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr) // making sure previous read timing is satisfied
                                        int_write_ready <= 1'b1;
                                    else
                                        int_write_ready <= 1'b0;
                                end
                                else
                                begin
                                    if (doing_burst_chop || doing_burst_terminate) // burst chop or burst terminate
                                    begin
                                        if (compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           && compare_wr_cnt_this_chip_greater_eq_than_effective_wr_to_rd          &&
                                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip && compare_wr_cnt_diff_chip_greater_eq_than_effective_wr_to_rd_diff_chip  )
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                        
                                        if (compare_rd_cnt_this_chip_greater_eq_than_effective_rd_to_wr           && compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           &&
                                            compare_rd_cnt_diff_chip_greater_eq_than_effective_rd_to_wr_diff_chip && compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip   )
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                    else
                                    begin
                                        if (compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_rd           && compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_rd           &&
                                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_rd_diff_chip && compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_rd_diff_chip   )
                                            int_read_ready  <= 1'b1;
                                        else
                                            int_read_ready  <= 1'b0;
                                        
                                        if (compare_rd_cnt_this_chip_greater_eq_than_t_param_rd_to_wr           && compare_wr_cnt_this_chip_greater_eq_than_t_param_wr_to_wr           &&
                                            compare_rd_cnt_diff_chip_greater_eq_than_t_param_rd_to_wr_diff_chip && compare_wr_cnt_diff_chip_greater_eq_than_t_param_wr_to_wr_diff_chip)
                                            int_write_ready <= 1'b1;
                                        else
                                            int_write_ready <= 1'b0;
                                    end
                                end
                            end
                        default :
                            rdwr_state <= IDLE;
                    endcase
                end
            end
            
            // Assign read/write ready signal to top
            always @ (*)
            begin
                if (!CFG_RANK_TIMER_OUTPUT_REG && stall_chip [s_cs])
                begin
                    read_ready  [s_cs] = 1'b0;
                    write_ready [s_cs] = 1'b0;
                end
                else
                begin
                    if (CFG_RANK_TIMER_OUTPUT_REG)
                    begin
                        read_ready  [s_cs] = int_read_ready;
                        write_ready [s_cs] = int_write_ready;
                    end
                    else
                    begin
                        read_ready  [s_cs] = int_read_ready  & int_interrupt_ready;
                        write_ready [s_cs] = int_write_ready & int_interrupt_ready;
                    end
                end
            end
        end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Read/Write Monitor
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Precharge Monitor
//
//--------------------------------------------------------------------------------------------------------
    generate
        genvar u_cs;
        for (u_cs = 0;u_cs < CFG_MEM_IF_CHIP;u_cs = u_cs + 1)
        begin : pch_monitor_per_chip
            always @ (*)
            begin
                if (!CFG_RANK_TIMER_OUTPUT_REG && stall_chip [u_cs])
                    pch_ready [u_cs] = 1'b0;
                else
                    pch_ready [u_cs] = one;
            end
        end
    endgenerate
//--------------------------------------------------------------------------------------------------------
//
//  [END] Precharge Monitor
//
//--------------------------------------------------------------------------------------------------------









endmodule

