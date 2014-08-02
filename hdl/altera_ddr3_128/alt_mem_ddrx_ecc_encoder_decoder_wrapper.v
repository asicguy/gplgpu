
//altera message_off 10230 10036

`timescale 1 ps / 1 ps
module alt_mem_ddrx_ecc_encoder_decoder_wrapper #
    ( parameter
        CFG_LOCAL_DATA_WIDTH                    =   80,
        CFG_LOCAL_ADDR_WIDTH                    =   32,
        CFG_DWIDTH_RATIO                        =   2,
        
        CFG_MEM_IF_DQ_WIDTH                     =   40,
        CFG_MEM_IF_DQS_WIDTH                    =   5,
        
        CFG_ECC_CODE_WIDTH                      =   8,
        CFG_ECC_MULTIPLES                       =   1,
        
        CFG_ECC_ENC_REG                         =   0,
        CFG_ECC_DEC_REG                         =   0,
        CFG_ECC_RDATA_REG                       =   0,
        
        CFG_PORT_WIDTH_INTERFACE_WIDTH          =   8,
        CFG_PORT_WIDTH_ENABLE_ECC               =   1,
        CFG_PORT_WIDTH_GEN_SBE                  =   1,
        CFG_PORT_WIDTH_GEN_DBE                  =   1,
        CFG_PORT_WIDTH_ENABLE_INTR              =   1,
        CFG_PORT_WIDTH_MASK_SBE_INTR            =   1,
        CFG_PORT_WIDTH_MASK_DBE_INTR            =   1,
        CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR   =   1,
        CFG_PORT_WIDTH_CLR_INTR                 =   1,
        
        STS_PORT_WIDTH_SBE_ERROR                =   1,
        STS_PORT_WIDTH_DBE_ERROR                =   1,
        STS_PORT_WIDTH_SBE_COUNT                =   8,
        STS_PORT_WIDTH_DBE_COUNT                =   8,
        STS_PORT_WIDTH_CORR_DROP_ERROR          =   1,
        STS_PORT_WIDTH_CORR_DROP_COUNT          =   8
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // MMR Interface
        cfg_interface_width,
        cfg_enable_ecc,
        cfg_gen_sbe,
        cfg_gen_dbe,
        cfg_enable_intr,
        cfg_mask_sbe_intr,
        cfg_mask_dbe_intr,
        cfg_mask_corr_dropped_intr,
        cfg_clr_intr,
        
        // Wdata & Rdata Interface Inputs
        wdatap_dm,
        wdatap_data,
        wdatap_rmw_partial_data,
        wdatap_rmw_correct_data,
        wdatap_rmw_partial,
        wdatap_rmw_correct,
        wdatap_ecc_code,
        wdatap_ecc_code_overwrite,
        rdatap_rcvd_addr,
        rdatap_rcvd_cmd,
        rdatap_rcvd_corr_dropped,
        
        // AFI Interface Inputs
        afi_rdata,
        afi_rdata_valid,
        
        // Wdata & Rdata Interface Outputs
        ecc_rdata,
        ecc_rdata_valid,
        
        // AFI Inteface Outputs
        ecc_dm,
        ecc_wdata,
        
        // ECC Error Information
        ecc_sbe,
        ecc_dbe,
        ecc_code,
        ecc_interrupt,
        
        // MMR ECC Information
        sts_sbe_error,
        sts_dbe_error,
        sts_sbe_count,
        sts_dbe_count,
        sts_err_addr,
        sts_corr_dropped,
        sts_corr_dropped_count,
        sts_corr_dropped_addr
    );
//--------------------------------------------------------------------------------------------------------
//
//  Important Note:
//  
//  This block is coded with the following consideration in mind
//  - Parameter
//      - maximum LOCAL_DATA_WIDTH will be (40 * DWIDTH_RATIO)
//      - maximum ECC_DATA_WIDTH will be (40 * DWIDTH_RATIO)
//  - MMR configuration
//      - ECC option disabled:
//          - maximum DQ width is 40
//          - maximum LOCAL_DATA width is (40 * DWIDTH_RATIO)
//          - WDATAP_DATA and ECC_DATA size will match (no ECC code)
//      - ECC option enabled:
//          - maximum DQ width is 40
//          - maximum LOCAL_DATA width is (32 * DWIDTH_RATIO)
//          - WDATAP_DATA width will be (8 * DWIDTH_RATIO) lesser than ECC_DATA (ECC code)
//  
//  Block level diagram
//  -----------------------------------                                                                               
//      Write Data Path (Per DRATE)                                                                                   
//  -----------------------------------                                                                               
//                     __________                    ___________                    ___________                       
//                    |          |                  |           |                  |           |                      
//  Local Write Data  |   Data   |                  |           |                  |           |                      
//  ---- 40 bits ---->|   Mask   |---- 32 bits ---->|  Encoder  |---- 40 bits ---->|  ECC MUX  |---- 40 bits ---->    
//                |   |          |                  |           |                  |           |                      
//                |   |__________|                  |___________|                  |___________|                      
//                |                                                                      ^                            
//                |---------------------------------- 40 bits ---------------------------|                            
//                                                                                                                    
//                                                                                                                    
//  -----------------------------------                                                                               
//      Read Data Path (Per DRATE)                                                                                    
//  -----------------------------------                                                                               
//                     __________                    ___________                    ___________                       
//                    |          |                  |           |                  |           |                      
//    AFI Read Data   |   Data   |                  |           |                  |           |                      
//  ---- 40 bits ---->|   Mask   |---- 40 bits ---->|  Decoder  |---- 32 bits ---->|  ECC MUX  |---- 40 bits ---->    
//                |   |          |                  |           |                  |           |                      
//                |   |__________|                  |___________|                  |___________|                      
//                |                                                                      ^                            
//                |---------------------------------- 40 bits ---------------------------|                            
//                                                                                                                    
//--------------------------------------------------------------------------------------------------------

localparam CFG_MEM_IF_DQ_PER_DQS         = CFG_MEM_IF_DQ_WIDTH / CFG_MEM_IF_DQS_WIDTH;

localparam CFG_ECC_DATA_WIDTH            = CFG_MEM_IF_DQ_WIDTH  * CFG_DWIDTH_RATIO;

localparam CFG_LOCAL_DM_WIDTH            = CFG_LOCAL_DATA_WIDTH / CFG_MEM_IF_DQ_PER_DQS;
localparam CFG_ECC_DM_WIDTH              = CFG_ECC_DATA_WIDTH   / CFG_MEM_IF_DQ_PER_DQS;

localparam CFG_LOCAL_DATA_PER_WORD_WIDTH = CFG_LOCAL_DATA_WIDTH / CFG_ECC_MULTIPLES;
localparam CFG_LOCAL_DM_PER_WORD_WIDTH   = CFG_LOCAL_DM_WIDTH   / CFG_ECC_MULTIPLES;
localparam CFG_ECC_DATA_PER_WORD_WIDTH   = CFG_ECC_DATA_WIDTH   / CFG_ECC_MULTIPLES;
localparam CFG_ECC_DM_PER_WORD_WIDTH     = CFG_ECC_DM_WIDTH     / CFG_ECC_MULTIPLES;

localparam CFG_MMR_DRAM_DATA_WIDTH       = CFG_PORT_WIDTH_INTERFACE_WIDTH;
localparam CFG_MMR_LOCAL_DATA_WIDTH      = CFG_PORT_WIDTH_INTERFACE_WIDTH;

localparam CFG_MMR_DRAM_DM_WIDTH         = CFG_PORT_WIDTH_INTERFACE_WIDTH - 2;  // Minus 3 because byte enable will be divided by 4/8
localparam CFG_MMR_LOCAL_DM_WIDTH        = CFG_PORT_WIDTH_INTERFACE_WIDTH - 2;  // Minus 3 because byte enable will be divided by 4/8

// The following 2 parameters should match!
localparam CFG_ENCODER_DATA_WIDTH       = CFG_ECC_DATA_PER_WORD_WIDTH;          // supports only 24, 40 and 72
localparam CFG_DECODER_DATA_WIDTH       = CFG_ECC_DATA_PER_WORD_WIDTH;          // supports only 24, 40 and 72

input  ctl_clk;
input  ctl_reset_n;

// MMR Interface
input  [CFG_PORT_WIDTH_INTERFACE_WIDTH          - 1 : 0] cfg_interface_width;
input  [CFG_PORT_WIDTH_ENABLE_ECC               - 1 : 0] cfg_enable_ecc;
input  [CFG_PORT_WIDTH_GEN_SBE                  - 1 : 0] cfg_gen_sbe;
input  [CFG_PORT_WIDTH_GEN_DBE                  - 1 : 0] cfg_gen_dbe;
input  [CFG_PORT_WIDTH_ENABLE_INTR              - 1 : 0] cfg_enable_intr;
input  [CFG_PORT_WIDTH_MASK_SBE_INTR            - 1 : 0] cfg_mask_sbe_intr;
input  [CFG_PORT_WIDTH_MASK_DBE_INTR            - 1 : 0] cfg_mask_dbe_intr;
input  [CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR   - 1 : 0] cfg_mask_corr_dropped_intr;
input  [CFG_PORT_WIDTH_CLR_INTR                 - 1 : 0] cfg_clr_intr;

// Wdata & Rdata Interface Inputs
input  [CFG_LOCAL_DM_WIDTH                     - 1 : 0] wdatap_dm;
input  [CFG_LOCAL_DATA_WIDTH                   - 1 : 0] wdatap_data;
input  [CFG_LOCAL_DATA_WIDTH                   - 1 : 0] wdatap_rmw_partial_data;
input  [CFG_LOCAL_DATA_WIDTH                   - 1 : 0] wdatap_rmw_correct_data;
input                                                   wdatap_rmw_partial;
input                                                   wdatap_rmw_correct;
input  [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] wdatap_ecc_code;
input  [CFG_ECC_MULTIPLES                      - 1 : 0] wdatap_ecc_code_overwrite;
input  [CFG_LOCAL_ADDR_WIDTH                   - 1 : 0] rdatap_rcvd_addr;
input                                                   rdatap_rcvd_cmd;
input                                                   rdatap_rcvd_corr_dropped;

// AFI Interface Inputs
input  [CFG_ECC_DATA_WIDTH   - 1 : 0] afi_rdata;
input  [CFG_DWIDTH_RATIO / 2 - 1 : 0] afi_rdata_valid;

// Wdata & Rdata Interface Outputs
output [CFG_LOCAL_DATA_WIDTH - 1 : 0] ecc_rdata;
output                                ecc_rdata_valid;

// AFI Inteface Outputs
output [CFG_ECC_DM_WIDTH     - 1 : 0] ecc_dm;
output [CFG_ECC_DATA_WIDTH   - 1 : 0] ecc_wdata;

// ECC Error Information
output [CFG_ECC_MULTIPLES                      - 1 : 0] ecc_sbe;
output [CFG_ECC_MULTIPLES                      - 1 : 0] ecc_dbe;
output [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] ecc_code;
output                                                  ecc_interrupt;

// MMR ECC Information
output [STS_PORT_WIDTH_SBE_ERROR        - 1 : 0] sts_sbe_error;
output [STS_PORT_WIDTH_DBE_ERROR        - 1 : 0] sts_dbe_error;
output [STS_PORT_WIDTH_SBE_COUNT        - 1 : 0] sts_sbe_count;
output [STS_PORT_WIDTH_DBE_COUNT        - 1 : 0] sts_dbe_count;
output [CFG_LOCAL_ADDR_WIDTH            - 1 : 0] sts_err_addr;
output [STS_PORT_WIDTH_CORR_DROP_ERROR  - 1 : 0] sts_corr_dropped;
output [STS_PORT_WIDTH_CORR_DROP_COUNT  - 1 : 0] sts_corr_dropped_count;
output [CFG_LOCAL_ADDR_WIDTH            - 1 : 0] sts_corr_dropped_addr;

//--------------------------------------------------------------------------------------------------------
//
//  [START] Register & Wires
//
//--------------------------------------------------------------------------------------------------------
    // Output registers
    reg  [CFG_LOCAL_DATA_WIDTH                   - 1 : 0] ecc_rdata;
    reg                                                   ecc_rdata_valid;
    reg  [CFG_ECC_DM_WIDTH                       - 1 : 0] ecc_dm;
    reg  [CFG_ECC_DATA_WIDTH                     - 1 : 0] ecc_wdata;
    reg  [CFG_ECC_MULTIPLES                      - 1 : 0] ecc_sbe;
    reg  [CFG_ECC_MULTIPLES                      - 1 : 0] ecc_dbe;
    reg  [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] ecc_code;
    reg                                                   ecc_interrupt;
    reg  [STS_PORT_WIDTH_SBE_ERROR               - 1 : 0] sts_sbe_error;
    reg  [STS_PORT_WIDTH_DBE_ERROR               - 1 : 0] sts_dbe_error;
    reg  [STS_PORT_WIDTH_SBE_COUNT               - 1 : 0] sts_sbe_count;
    reg  [STS_PORT_WIDTH_DBE_COUNT               - 1 : 0] sts_dbe_count;
    reg  [CFG_LOCAL_ADDR_WIDTH                   - 1 : 0] sts_err_addr;
    reg  [STS_PORT_WIDTH_CORR_DROP_ERROR         - 1 : 0] sts_corr_dropped;
    reg  [STS_PORT_WIDTH_CORR_DROP_COUNT         - 1 : 0] sts_corr_dropped_count;
    reg  [CFG_LOCAL_ADDR_WIDTH                   - 1 : 0] sts_corr_dropped_addr;
    
    // Common
    reg  [CFG_MMR_DRAM_DATA_WIDTH  - 1 : 0] cfg_dram_data_width;
    reg  [CFG_MMR_LOCAL_DATA_WIDTH - 1 : 0] cfg_local_data_width;
    
    reg  [CFG_MMR_DRAM_DM_WIDTH    - 1 : 0] cfg_dram_dm_width;
    reg  [CFG_MMR_LOCAL_DM_WIDTH   - 1 : 0] cfg_local_dm_width;
    
    // Input Logic
    reg  [CFG_LOCAL_DATA_WIDTH - 1 : 0] int_encoder_input_data;
    reg  [CFG_LOCAL_DATA_WIDTH - 1 : 0] int_encoder_input_rmw_partial_data;
    reg  [CFG_LOCAL_DATA_WIDTH - 1 : 0] int_encoder_input_rmw_correct_data;
    
    reg                                 int_encoder_input_rmw_partial;
    reg                                 int_encoder_input_rmw_correct;
    reg                                 wdatap_rmw_partial_r;
    reg                                 wdatap_rmw_correct_r;
    
    reg  [CFG_ECC_DATA_WIDTH   - 1 : 0] int_decoder_input_data;
    reg                                 int_decoder_input_data_valid;
    
    // Output Logic
    reg  [CFG_ECC_MULTIPLES    - 1 : 0] int_sbe;
    reg  [CFG_ECC_MULTIPLES    - 1 : 0] int_dbe;
    
    reg  [CFG_ECC_DM_WIDTH     - 1 : 0] int_encoder_output_dm;
    reg  [CFG_ECC_DM_WIDTH     - 1 : 0] int_encoder_output_dm_r;
    wire [CFG_ECC_MULTIPLES    - 1 : 0] int_decoder_output_data_valid;
    
    reg  [CFG_ECC_DATA_WIDTH                     - 1 : 0] int_encoder_output_data;
    reg  [CFG_ECC_DATA_WIDTH                     - 1 : 0] int_encoder_output_data_r;
    wire [CFG_LOCAL_DATA_WIDTH                   - 1 : 0] int_decoder_output_data;
    wire [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] int_ecc_code;
    
    // ECC specific logic
    reg  [1                            : 0] inject_data_error;
    
    reg                                     int_sbe_detected;
    reg                                     int_dbe_detected;
    wire                                    int_be_detected;
    reg                                     int_sbe_store;
    reg                                     int_dbe_store;
    reg                                     int_sbe_valid;
    reg                                     int_dbe_valid;
    reg                                     int_sbe_valid_r;
    reg                                     int_dbe_valid_r;
    
    reg                                     int_ecc_interrupt;
    wire                                    int_interruptable_error_detected;
    
    reg  [STS_PORT_WIDTH_SBE_ERROR          - 1 : 0] int_sbe_error;
    reg  [STS_PORT_WIDTH_DBE_ERROR          - 1 : 0] int_dbe_error;
    reg  [STS_PORT_WIDTH_SBE_COUNT          - 1 : 0] int_sbe_count;
    reg  [STS_PORT_WIDTH_DBE_COUNT          - 1 : 0] int_dbe_count;
    reg  [CFG_LOCAL_ADDR_WIDTH              - 1 : 0] int_err_addr ;
    reg  [STS_PORT_WIDTH_CORR_DROP_ERROR    - 1 : 0] int_corr_dropped;
    reg  [STS_PORT_WIDTH_CORR_DROP_COUNT    - 1 : 0] int_corr_dropped_count;
    reg  [CFG_LOCAL_ADDR_WIDTH              - 1 : 0] int_corr_dropped_addr ;
    reg                                              int_corr_dropped_detected;
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Register & Wires
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Common
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // DRAM and local data width
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            cfg_dram_data_width <= 0;
        end
        else
        begin
            cfg_dram_data_width <= cfg_interface_width;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            cfg_local_data_width <= 0;
        end
        else
        begin
            // Important note, if we set memory interface width (DQ width) to 8 and enable_ecc to 1,
            // this will result in local data width of 0, this case is not supported
            // this must be checked with assertion so that this case will not happen in regression
            if (cfg_enable_ecc)
            begin
                cfg_local_data_width <= cfg_interface_width - CFG_ECC_CODE_WIDTH;
            end
            else
            begin
                cfg_local_data_width <= cfg_interface_width;
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // DRAM and local be width
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            cfg_dram_dm_width <= 0;
        end
        else
        begin
            cfg_dram_dm_width <= cfg_dram_data_width / CFG_MEM_IF_DQ_PER_DQS;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            cfg_local_dm_width <= 0;
        end
        else
        begin
            cfg_local_dm_width <= cfg_local_data_width / CFG_MEM_IF_DQ_PER_DQS;
        end
    end
    
    // Registered version
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            wdatap_rmw_partial_r <= 1'b0;
            wdatap_rmw_correct_r <= 1'b0;
        end
        else
        begin
            wdatap_rmw_partial_r <= wdatap_rmw_partial;
            wdatap_rmw_correct_r <= wdatap_rmw_correct;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_encoder_output_data_r <= 0;
            int_encoder_output_dm_r   <= 0;
        end
        else
        begin
            int_encoder_output_data_r <= int_encoder_output_data;
            int_encoder_output_dm_r   <= int_encoder_output_dm;
        end
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [ENC] Common
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Input Logic
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Write data & byte enable from wdata_path
    //----------------------------------------------------------------------------------------------------
    always @ (*)
    begin
        int_encoder_input_data             = wdatap_data;
        int_encoder_input_rmw_partial_data = wdatap_rmw_partial_data;
        int_encoder_input_rmw_correct_data = wdatap_rmw_correct_data;
        
        if (CFG_ECC_ENC_REG)
        begin
            int_encoder_input_rmw_partial = wdatap_rmw_partial_r;
            int_encoder_input_rmw_correct = wdatap_rmw_correct_r;
        end
        else
        begin
            int_encoder_input_rmw_partial = wdatap_rmw_partial;
            int_encoder_input_rmw_correct = wdatap_rmw_correct;
        end
    end
    
    generate
        genvar i_drate;
        for (i_drate = 0;i_drate < CFG_ECC_MULTIPLES;i_drate = i_drate + 1)
        begin : encoder_input_dm_mux_per_dm_drate
            
            wire [CFG_LOCAL_DM_PER_WORD_WIDTH-1:0] int_encoder_input_dm = wdatap_dm [(i_drate + 1) * CFG_LOCAL_DM_PER_WORD_WIDTH - 1 : i_drate * CFG_LOCAL_DM_PER_WORD_WIDTH];
            wire int_encoder_input_dm_all_zeros = ~(|int_encoder_input_dm);
            
            always @ (*)
            begin
                if (cfg_enable_ecc)
                begin
                    if (int_encoder_input_dm_all_zeros)
                    begin
                        int_encoder_output_dm [ ((i_drate + 1) * CFG_ECC_DM_PER_WORD_WIDTH) - 1 : (i_drate * CFG_ECC_DM_PER_WORD_WIDTH)] = {{(CFG_ECC_DM_PER_WORD_WIDTH - CFG_LOCAL_DM_PER_WORD_WIDTH){1'b0}},int_encoder_input_dm};
                    end
                    else
                    begin
                        int_encoder_output_dm [ ((i_drate + 1) * CFG_ECC_DM_PER_WORD_WIDTH) - 1 : (i_drate * CFG_ECC_DM_PER_WORD_WIDTH)] = {{(CFG_ECC_DM_PER_WORD_WIDTH - CFG_LOCAL_DM_PER_WORD_WIDTH){1'b1}},int_encoder_input_dm};
                    end
                end
                else
                begin
                    int_encoder_output_dm [ ((i_drate + 1) * CFG_ECC_DM_PER_WORD_WIDTH) - 1 : (i_drate * CFG_ECC_DM_PER_WORD_WIDTH)] = {{(CFG_ECC_DM_PER_WORD_WIDTH - CFG_LOCAL_DM_PER_WORD_WIDTH){1'b0}},int_encoder_input_dm};
                end
            end
        end
    endgenerate
    
    //----------------------------------------------------------------------------------------------------
    // Read data & read data valid from AFI
    //----------------------------------------------------------------------------------------------------
    always @ (*)
    begin
        int_decoder_input_data = afi_rdata;
    end
    
    always @ (*)
    begin
        int_decoder_input_data_valid = afi_rdata_valid [0];
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Input Logic
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Output Logic
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Write data & byte enable to AFI interface
    //----------------------------------------------------------------------------------------------------
    always @ (*)
    begin
        ecc_wdata = int_encoder_output_data;
    end
    
    always @ (*)
    begin
        if (CFG_ECC_ENC_REG)
        begin
            ecc_dm = int_encoder_output_dm_r;
        end
        else
        begin
            ecc_dm = int_encoder_output_dm;
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Read data to rdata_path
    //----------------------------------------------------------------------------------------------------
    always @ (*)
    begin
        ecc_rdata = int_decoder_output_data;
    end
    
    always @ (*)
    begin
        ecc_rdata_valid = |int_decoder_output_data_valid;
    end

    //----------------------------------------------------------------------------------------------------
    // ECC specific logic
    //----------------------------------------------------------------------------------------------------

    // Single bit error
    always @ (*)
    begin
        if (cfg_enable_ecc)
            ecc_sbe = int_sbe;
        else
            ecc_sbe = 0;
    end
    
    // Double bit error
    always @ (*)
    begin
        if (cfg_enable_ecc)
            ecc_dbe = int_dbe;
        else
            ecc_dbe = 0;
    end
    
    // ECC code
    always @ (*)
    begin
        if (cfg_enable_ecc)
            ecc_code = int_ecc_code;
        else
            ecc_code = 0;
    end
    
    // Interrupt signal
    always @ (*)
    begin
        ecc_interrupt = int_ecc_interrupt;
    end

    
    //----------------------------------------------------------------------------------------------------
    // MMR ECC specific logic
    //----------------------------------------------------------------------------------------------------
    // Single bit error
    always @ (*)
    begin
        sts_sbe_error = int_sbe_error;
    end
    
    // Double bit error
    always @ (*)
    begin
        sts_dbe_error = int_dbe_error;
    end
    
    // Single bit error count
    always @ (*)
    begin
        sts_sbe_count = int_sbe_count;
    end
    
    // Double bit error count
    always @ (*)
    begin
        sts_dbe_count = int_dbe_count;
    end
    
    // Error address
    always @ (*)
    begin
        sts_err_addr = int_err_addr;
    end
    
    // Correctable Error dropped
    always @ (*)
    begin
        sts_corr_dropped = int_corr_dropped;
    end
    
    // Single bit error count
    always @ (*)
    begin
        sts_corr_dropped_count = int_corr_dropped_count;
    end
    
    // Correctable Error dropped address
    always @ (*)
    begin
        sts_corr_dropped_addr = int_corr_dropped_addr;
    end

//--------------------------------------------------------------------------------------------------------
//
//  [END] Output Logic
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Encoder / Decoder Instantiation
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Encoder
    //----------------------------------------------------------------------------------------------------
    generate
        genvar m_drate;
        for (m_drate = 0;m_drate < CFG_ECC_MULTIPLES;m_drate = m_drate + 1)
        begin : encoder_inst_per_drate
            wire [CFG_ENCODER_DATA_WIDTH - 1 : 0] input_data               = {{CFG_ENCODER_DATA_WIDTH - CFG_LOCAL_DATA_PER_WORD_WIDTH{1'b0}}, int_encoder_input_data             [(m_drate + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : m_drate * CFG_LOCAL_DATA_PER_WORD_WIDTH]};
            wire [CFG_ENCODER_DATA_WIDTH - 1 : 0] input_rmw_partial_data   = {{CFG_ENCODER_DATA_WIDTH - CFG_LOCAL_DATA_PER_WORD_WIDTH{1'b0}}, int_encoder_input_rmw_partial_data [(m_drate + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : m_drate * CFG_LOCAL_DATA_PER_WORD_WIDTH]};
            wire [CFG_ENCODER_DATA_WIDTH - 1 : 0] input_rmw_correct_data   = {{CFG_ENCODER_DATA_WIDTH - CFG_LOCAL_DATA_PER_WORD_WIDTH{1'b0}}, int_encoder_input_rmw_correct_data [(m_drate + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : m_drate * CFG_LOCAL_DATA_PER_WORD_WIDTH]};
            wire [CFG_ECC_CODE_WIDTH     - 1 : 0] input_ecc_code           = wdatap_ecc_code [(m_drate + 1) * CFG_ECC_CODE_WIDTH - 1 : m_drate * CFG_ECC_CODE_WIDTH];
            wire                                  input_ecc_code_overwrite = wdatap_ecc_code_overwrite [m_drate];
            wire [CFG_ENCODER_DATA_WIDTH - 1 : 0] output_data;
            wire [CFG_ENCODER_DATA_WIDTH - 1 : 0] output_rmw_partial_data;
            wire [CFG_ENCODER_DATA_WIDTH - 1 : 0] output_rmw_correct_data;
            
            always @ (*)
            begin
                if (int_encoder_input_rmw_partial)
                begin
                    int_encoder_output_data [(m_drate + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : m_drate * CFG_ECC_DATA_PER_WORD_WIDTH] = {output_rmw_partial_data [CFG_ECC_DATA_PER_WORD_WIDTH - 1 : 2], (output_rmw_partial_data [1 : 0] ^ inject_data_error [1 : 0])};
                end
                else if (int_encoder_input_rmw_correct)
                begin
                    int_encoder_output_data [(m_drate + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : m_drate * CFG_ECC_DATA_PER_WORD_WIDTH] = {output_rmw_correct_data [CFG_ECC_DATA_PER_WORD_WIDTH - 1 : 2], (output_rmw_correct_data [1 : 0] ^ inject_data_error [1 : 0])};
                end
                else
                begin
                    int_encoder_output_data [(m_drate + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : m_drate * CFG_ECC_DATA_PER_WORD_WIDTH] = {output_data             [CFG_ECC_DATA_PER_WORD_WIDTH - 1 : 2], (output_data             [1 : 0] ^ inject_data_error [1 : 0])};
                end
            end
            
            alt_mem_ddrx_ecc_encoder #
            (
                .CFG_DATA_WIDTH             (CFG_ENCODER_DATA_WIDTH     ),
                .CFG_ECC_CODE_WIDTH         (CFG_ECC_CODE_WIDTH         ),
                .CFG_ECC_ENC_REG            (CFG_ECC_ENC_REG            ),
                .CFG_MMR_DRAM_DATA_WIDTH    (CFG_MMR_DRAM_DATA_WIDTH    ),
                .CFG_MMR_LOCAL_DATA_WIDTH   (CFG_MMR_LOCAL_DATA_WIDTH   ),
                .CFG_PORT_WIDTH_ENABLE_ECC  (CFG_PORT_WIDTH_ENABLE_ECC  )
            )
            encoder_inst
            (
                .ctl_clk                    (ctl_clk                    ),
                .ctl_reset_n                (ctl_reset_n                ),
                .cfg_local_data_width       (cfg_local_data_width       ),
                .cfg_dram_data_width        (cfg_dram_data_width        ),
                .cfg_enable_ecc             (cfg_enable_ecc             ),
                .input_data                 (input_data                 ),
                .input_ecc_code             (input_ecc_code             ),
                .input_ecc_code_overwrite   (1'b0                       ),  // ECC code overwrite feature is only needed during RMW correct phase
                .output_data                (output_data                )
            );
            
            alt_mem_ddrx_ecc_encoder #
            (
                .CFG_DATA_WIDTH             (CFG_ENCODER_DATA_WIDTH     ),
                .CFG_ECC_CODE_WIDTH         (CFG_ECC_CODE_WIDTH         ),
                .CFG_ECC_ENC_REG            (CFG_ECC_ENC_REG            ),
                .CFG_MMR_DRAM_DATA_WIDTH    (CFG_MMR_DRAM_DATA_WIDTH    ),
                .CFG_MMR_LOCAL_DATA_WIDTH   (CFG_MMR_LOCAL_DATA_WIDTH   ),
                .CFG_PORT_WIDTH_ENABLE_ECC  (CFG_PORT_WIDTH_ENABLE_ECC  )
            )
            rmw_partial_encoder_inst
            (
                .ctl_clk                    (ctl_clk                    ),
                .ctl_reset_n                (ctl_reset_n                ),
                .cfg_local_data_width       (cfg_local_data_width       ),
                .cfg_dram_data_width        (cfg_dram_data_width        ),
                .cfg_enable_ecc             (cfg_enable_ecc             ),
                .input_data                 (input_rmw_partial_data     ),
                .input_ecc_code             (input_ecc_code             ),
                .input_ecc_code_overwrite   (1'b0                       ),  // ECC code overwrite feature is only needed during RMW correct phase
                .output_data                (output_rmw_partial_data    )
            );
            
            alt_mem_ddrx_ecc_encoder #
            (
                .CFG_DATA_WIDTH             (CFG_ENCODER_DATA_WIDTH     ),
                .CFG_ECC_CODE_WIDTH         (CFG_ECC_CODE_WIDTH         ),
                .CFG_ECC_ENC_REG            (CFG_ECC_ENC_REG            ),
                .CFG_MMR_DRAM_DATA_WIDTH    (CFG_MMR_DRAM_DATA_WIDTH    ),
                .CFG_MMR_LOCAL_DATA_WIDTH   (CFG_MMR_LOCAL_DATA_WIDTH   ),
                .CFG_PORT_WIDTH_ENABLE_ECC  (CFG_PORT_WIDTH_ENABLE_ECC  )
            )
            rmw_correct_encoder_inst
            (
                .ctl_clk                    (ctl_clk                    ),
                .ctl_reset_n                (ctl_reset_n                ),
                .cfg_local_data_width       (cfg_local_data_width       ),
                .cfg_dram_data_width        (cfg_dram_data_width        ),
                .cfg_enable_ecc             (cfg_enable_ecc             ),
                .input_data                 (input_rmw_correct_data     ),
                .input_ecc_code             (input_ecc_code             ),
                .input_ecc_code_overwrite   (input_ecc_code_overwrite   ),
                .output_data                (output_rmw_correct_data    )
            );
        end
    endgenerate
    
    //----------------------------------------------------------------------------------------------------
    // Decoder
    //----------------------------------------------------------------------------------------------------
    generate
        genvar n_drate;
        for (n_drate = 0;n_drate < CFG_ECC_MULTIPLES;n_drate = n_drate + 1)
        begin : decoder_inst_per_drate
            wire err_corrected;
            wire err_detected;
            wire err_fatal;
            wire err_sbe;
            
            wire [CFG_DECODER_DATA_WIDTH - 1 : 0] input_data  = {{CFG_DECODER_DATA_WIDTH - CFG_ECC_DATA_PER_WORD_WIDTH{1'b0}}, int_decoder_input_data [(n_drate + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : n_drate * CFG_ECC_DATA_PER_WORD_WIDTH]};
            wire                                  input_data_valid = int_decoder_input_data_valid;
            wire [CFG_DECODER_DATA_WIDTH - 1 : 0] output_data;
            wire                                  output_data_valid;
            wire [CFG_ECC_CODE_WIDTH     - 1 : 0] output_ecc_code;
            
            assign int_decoder_output_data [(n_drate + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : n_drate * CFG_LOCAL_DATA_PER_WORD_WIDTH] = output_data [CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : 0];
            assign int_ecc_code            [(n_drate + 1) * CFG_ECC_CODE_WIDTH            - 1 : n_drate * CFG_ECC_CODE_WIDTH           ] = output_ecc_code;
            assign int_decoder_output_data_valid [n_drate] = output_data_valid;
            
            alt_mem_ddrx_ecc_decoder #
            (
                .CFG_DATA_WIDTH                (CFG_DECODER_DATA_WIDTH        ),
                .CFG_ECC_CODE_WIDTH            (CFG_ECC_CODE_WIDTH            ),
                .CFG_ECC_DEC_REG               (CFG_ECC_DEC_REG               ),
                .CFG_ECC_RDATA_REG             (CFG_ECC_RDATA_REG             ),
                .CFG_MMR_DRAM_DATA_WIDTH       (CFG_MMR_DRAM_DATA_WIDTH       ),
                .CFG_MMR_LOCAL_DATA_WIDTH      (CFG_MMR_LOCAL_DATA_WIDTH      ),
                .CFG_PORT_WIDTH_ENABLE_ECC     (CFG_PORT_WIDTH_ENABLE_ECC     )
            )
            decoder_inst
            (
                .ctl_clk                       (ctl_clk                       ),
                .ctl_reset_n                   (ctl_reset_n                   ),
                .cfg_local_data_width          (cfg_local_data_width          ),
                .cfg_dram_data_width           (cfg_dram_data_width           ),
                .cfg_enable_ecc                (cfg_enable_ecc                ),
                .input_data                    (input_data                    ),
                .input_data_valid              (input_data_valid              ),
                .output_data                   (output_data                   ),
                .output_data_valid             (output_data_valid             ),
                .output_ecc_code               (output_ecc_code               ),
                .err_corrected                 (err_corrected                 ),
                .err_detected                  (err_detected                  ),
                .err_fatal                     (err_fatal                     ),
                .err_sbe                       (err_sbe                       )
            );
            
            // Error detection
            always @ (*)
            begin
                if (err_detected || err_sbe)
                begin
                    if (err_corrected || err_sbe)
                    begin
                        int_sbe [n_drate] = 1'b1;
                        int_dbe [n_drate] = 1'b0;
                    end
                    else if (err_fatal)
                    begin
                        int_sbe [n_drate] = 1'b0;
                        int_dbe [n_drate] = 1'b1;
                    end
                    else
                    begin
                        int_sbe [n_drate] = 1'b0;
                        int_dbe [n_drate] = 1'b0;
                    end
                end
                else
                begin
                    int_sbe [n_drate] = 1'b0;
                    int_dbe [n_drate] = 1'b0;
                end
            end
        end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Encoder / Decoder Instantiation
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] ECC Specific Logic
//
//--------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    // Common Logic
    //----------------------------------------------------------------------------------------------------

    // Below information valid on same clock, when rdatap_rcvd_cmd is asserted (at end of every dram command)
    // - int_sbe_detected
    // - int_dbe_detected
    // - int_be_detected
    // - int_corr_dropped_detected
    // - rdatap_rcvd_addr
    //
    //  see SPR:362993

    always @ (*)
    begin
        int_sbe_valid               = |int_sbe & ecc_rdata_valid;
        int_dbe_valid               = |int_dbe & ecc_rdata_valid;
        int_sbe_detected            = ( int_sbe_store | int_sbe_valid_r ) & rdatap_rcvd_cmd;
        int_dbe_detected            = ( int_dbe_store | int_dbe_valid_r ) & rdatap_rcvd_cmd;
        int_corr_dropped_detected   = rdatap_rcvd_corr_dropped;
    end

    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (~ctl_reset_n)
        begin
            int_sbe_valid_r     <= 0;
            int_dbe_valid_r     <= 0;

            int_sbe_store       <= 0;
            int_dbe_store       <= 0;
        end
        else
        begin

            int_sbe_valid_r     <= int_sbe_valid;
            int_dbe_valid_r     <= int_dbe_valid;

            int_sbe_store       <= (int_sbe_store | int_sbe_valid_r) & ~rdatap_rcvd_cmd;
            int_dbe_store       <= (int_dbe_store | int_dbe_valid_r) & ~rdatap_rcvd_cmd;
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Error Innjection Logic
    //----------------------------------------------------------------------------------------------------
    // Data error injection, this will cause output data to be injected with single/double bit error
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            inject_data_error <= 0;
        end
        else
        begin
            // Put DBE 1st so that when user sets both gen_sbe and gen_dbe, DBE will have higher priority
            if (cfg_gen_dbe)
                inject_data_error <= 2'b11;
            else if (cfg_gen_sbe)
                inject_data_error <= 2'b01;
            else
                inject_data_error <= 2'b00;
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Single bit error
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_sbe_error <= 1'b0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (int_sbe_detected)
                    int_sbe_error <= 1'b1;
                else if (cfg_clr_intr)
                    int_sbe_error <= 1'b0;
            end
            else
            begin
                int_sbe_error <= 1'b0;
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Single bit error count
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_sbe_count <= 0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (cfg_clr_intr)
                    if (int_sbe_detected)
                        int_sbe_count <= 1;
                    else
                        int_sbe_count <= 0;
                else if (int_sbe_detected)
                    int_sbe_count <= int_sbe_count + 1'b1;
            end
            else
            begin
                int_sbe_count <= {STS_PORT_WIDTH_SBE_COUNT{1'b0}};
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Double bit error
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_dbe_error <= 1'b0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (int_dbe_detected)
                    int_dbe_error <= 1'b1;
                else if (cfg_clr_intr)
                    int_dbe_error <= 1'b0;
            end
            else
            begin
                int_dbe_error <= 1'b0;
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Double bit error count
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_dbe_count <= 0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (cfg_clr_intr)
                    if (int_dbe_detected)
                        int_dbe_count <= 1;
                    else
                        int_dbe_count <= 0;
                else if (int_dbe_detected)
                    int_dbe_count <= int_dbe_count + 1'b1;
            end
            else
            begin
                int_dbe_count <= {STS_PORT_WIDTH_DBE_COUNT{1'b0}};
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Error address
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_err_addr <= 0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (int_be_detected)
                    int_err_addr <= rdatap_rcvd_addr;
                else if (cfg_clr_intr)
                    int_err_addr <= 0;
            end
            else
            begin
                int_err_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
            end
        end
    end

    //----------------------------------------------------------------------------------------------------
    // Dropped Correctable Error
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_corr_dropped <= 1'b0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (int_corr_dropped_detected)
                    int_corr_dropped <= 1'b1;
                else if (cfg_clr_intr)
                    int_corr_dropped <= 1'b0;
            end
            else
            begin
                int_corr_dropped <= 1'b0;
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Dropped Correctable Error count
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_corr_dropped_count <= 0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (cfg_clr_intr)
                    if (int_corr_dropped_detected)
                        int_corr_dropped_count <= 1;
                    else
                        int_corr_dropped_count <= 0;
                else if (int_corr_dropped_detected)
                    int_corr_dropped_count <= int_corr_dropped_count + 1'b1;
            end
            else
            begin
                int_corr_dropped_count <= {STS_PORT_WIDTH_CORR_DROP_COUNT{1'b0}};
            end
        end
    end
    
    //----------------------------------------------------------------------------------------------------
    // Dropped Correctable Error address
    //----------------------------------------------------------------------------------------------------
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_corr_dropped_addr <= 0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                if (int_corr_dropped_detected)
                    int_corr_dropped_addr <= rdatap_rcvd_addr;
                else if (cfg_clr_intr)
                    int_corr_dropped_addr <= 0;
            end
            else
            begin
                int_corr_dropped_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
            end
        end
    end


    //----------------------------------------------------------------------------------------------------
    // Interrupt logic
    //----------------------------------------------------------------------------------------------------

    assign int_interruptable_error_detected = (int_sbe_detected & ~cfg_mask_sbe_intr) | (int_dbe_detected & ~cfg_mask_dbe_intr) | (int_corr_dropped_detected & ~cfg_mask_corr_dropped_intr);
    assign int_be_detected = int_sbe_detected | int_dbe_detected;

    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_ecc_interrupt <= 1'b0;
        end
        else
        begin
            if (cfg_enable_ecc && cfg_enable_intr)
            begin
                if (int_interruptable_error_detected)
                    int_ecc_interrupt <= 1'b1;
                else if (cfg_clr_intr)
                    int_ecc_interrupt <= 1'b0;
            end
            else
            begin
                int_ecc_interrupt <= 1'b0;
            end
        end
    end
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] ECC Specific Logic
//
//--------------------------------------------------------------------------------------------------------




endmodule
