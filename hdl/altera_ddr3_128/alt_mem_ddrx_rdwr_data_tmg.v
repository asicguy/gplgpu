
//altera message_off 10036

///////////////////////////////////////////////////////////////////////////////
// Title         : DDR controller AFi interfacing block
//
// File          : afi_block.v
//
// Abstract      : AFi block
///////////////////////////////////////////////////////////////////////////////

//Things to check
//1. Does afi_wlat need to be registered?
//2. Does ecc_wdata_fifo_read generation changes with ECC
//3. Why in ddrx controller int_dqs_burst and int_wdata_valid signals are registered when CFG_OUTPUT_REGD is 1. Why complex logic instead of simple registering??
//4. We need rdwr_data_valid signal from arbiter to determine how many datas are valid within one dram burst
//5. Do we need to end rdwr_data_valid with doing_write to generate ecc_wdata_fifo_read? Yes
//6. Look at all comments and SPRs for old ddrx afi block
//7. Currently additive_latency, ECC, HR features are not supported

`timescale 1 ps / 1 ps
module alt_mem_ddrx_rdwr_data_tmg
    # (parameter
        CFG_DWIDTH_RATIO              =    2,
        CFG_MEM_IF_DQ_WIDTH           =    8,
        CFG_MEM_IF_DQS_WIDTH          =    1,
        CFG_MEM_IF_DM_WIDTH           =    1,
        CFG_WLAT_BUS_WIDTH            =    6,
        CFG_DRAM_WLAT_GROUP           =    1,
        CFG_DATA_ID_WIDTH             =    10,
        CFG_WDATA_REG                 =    0,
        CFG_ECC_ENC_REG               =    0,
        CFG_AFI_INTF_PHASE_NUM        =    2,
        CFG_PORT_WIDTH_ENABLE_ECC     =    1,
        CFG_PORT_WIDTH_OUTPUT_REGD    =    1
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // configuration
        cfg_enable_ecc,
        cfg_output_regd,
        cfg_output_regd_for_afi_output,
        
        //Arbiter command input
        bg_doing_read,
        bg_doing_write,
        bg_rdwr_data_valid,        //Required for user burst length lesser than dram burst length
        dataid,
        bg_do_rmw_correct,
        bg_do_rmw_partial,
        
        //Inputs from ECC/WFIFO blocks
        ecc_wdata,
        ecc_dm,
        
        //Input from AFI Block
        afi_wlat,
        
        //Output from AFI Block
        afi_doing_read,            //Use to generate rdata_valid signals in PHY
        afi_doing_read_full,      //AFI 2.0 signal, used by UniPHY for dqs enable control
        
        ecc_wdata_fifo_read,
        ecc_wdata_fifo_dataid,
        ecc_wdata_fifo_dataid_vector,
        ecc_wdata_fifo_rmw_correct,
        ecc_wdata_fifo_rmw_partial,
        
        ecc_wdata_fifo_read_first,
        ecc_wdata_fifo_dataid_first,
        ecc_wdata_fifo_dataid_vector_first,
        ecc_wdata_fifo_rmw_correct_first,
        ecc_wdata_fifo_rmw_partial_first,
        ecc_wdata_fifo_first_vector,
        
        ecc_wdata_fifo_read_last,
        ecc_wdata_fifo_dataid_last,
        ecc_wdata_fifo_dataid_vector_last,
        ecc_wdata_fifo_rmw_correct_last,
        ecc_wdata_fifo_rmw_partial_last,
        
        afi_dqs_burst,
        afi_wdata_valid,
        afi_wdata,
        afi_dm
    );
    
    localparam integer  CFG_WLAT_PIPE_LENGTH     = 2**(CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP);
    localparam integer  CFG_DATAID_ARRAY_DEPTH   = 2**CFG_DATA_ID_WIDTH;
    integer i;
    
    //=================================================================================================//
    //        input/output declaration                                                                 //
    //=================================================================================================//
    
    input  ctl_clk;
    input  ctl_reset_n;
    
    // configuration
    input  [CFG_PORT_WIDTH_ENABLE_ECC-1:0]  cfg_enable_ecc;
    input  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd;
    output [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_afi_output;
    
    //Arbiter command input
    input                          bg_doing_read;
    input                          bg_doing_write;
    input                          bg_rdwr_data_valid;
    input  [CFG_DATA_ID_WIDTH-1:0] dataid;
    
    input  [CFG_AFI_INTF_PHASE_NUM-1:0] bg_do_rmw_correct;
    input  [CFG_AFI_INTF_PHASE_NUM-1:0] bg_do_rmw_partial;
    
    //Inputs from ECC/WFIFO blocks
    input  [CFG_MEM_IF_DQ_WIDTH*CFG_DWIDTH_RATIO-1:0]                                              ecc_wdata;
    input  [(CFG_MEM_IF_DQ_WIDTH*CFG_DWIDTH_RATIO)/(CFG_MEM_IF_DQ_WIDTH/CFG_MEM_IF_DQS_WIDTH)-1:0] ecc_dm;
    
    //Input from AFI Block
    input  [CFG_WLAT_BUS_WIDTH-1:0]                       afi_wlat;
    
    //output to AFI block
    output [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_doing_read;
    output [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_doing_read_full;
    
    output [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_read;
    output [CFG_DRAM_WLAT_GROUP*CFG_DATA_ID_WIDTH-1:0]       ecc_wdata_fifo_dataid;
    output [CFG_DRAM_WLAT_GROUP*CFG_DATAID_ARRAY_DEPTH-1:0]  ecc_wdata_fifo_dataid_vector;
    output [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_rmw_correct;
    output [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_rmw_partial;
    
    output                                                   ecc_wdata_fifo_read_first;
    output [CFG_DATA_ID_WIDTH-1:0]                           ecc_wdata_fifo_dataid_first;
    output [CFG_DATAID_ARRAY_DEPTH-1:0]                      ecc_wdata_fifo_dataid_vector_first;
    output                                                   ecc_wdata_fifo_rmw_correct_first;
    output                                                   ecc_wdata_fifo_rmw_partial_first;
    output [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_first_vector;
    
    output                                                   ecc_wdata_fifo_read_last;
    output [CFG_DATA_ID_WIDTH-1:0]                           ecc_wdata_fifo_dataid_last;
    output [CFG_DATAID_ARRAY_DEPTH-1:0]                      ecc_wdata_fifo_dataid_vector_last;
    output                                                   ecc_wdata_fifo_rmw_correct_last;
    output                                                   ecc_wdata_fifo_rmw_partial_last;
    
    output [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_dqs_burst;
    output [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_wdata_valid;
    output [CFG_MEM_IF_DQ_WIDTH*CFG_DWIDTH_RATIO-1:0]        afi_wdata;
    output [CFG_MEM_IF_DM_WIDTH*CFG_DWIDTH_RATIO-1:0]        afi_dm;
    
    //=================================================================================================//
    //        reg/wire declaration                                                                     //
    //=================================================================================================//
    
    wire                               bg_doing_read;
    wire                               bg_doing_write;
    wire                               bg_rdwr_data_valid;
    wire  [CFG_DATA_ID_WIDTH-1:0]      dataid;
    wire  [CFG_AFI_INTF_PHASE_NUM-1:0] bg_do_rmw_correct;
    wire  [CFG_AFI_INTF_PHASE_NUM-1:0] bg_do_rmw_partial;
    
    wire  [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_doing_read;
    wire  [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_doing_read_full;
    
    wire  [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_read;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_read_r;
    wire  [CFG_DRAM_WLAT_GROUP*CFG_DATA_ID_WIDTH-1:0]       ecc_wdata_fifo_dataid;
    wire  [CFG_DRAM_WLAT_GROUP*CFG_DATAID_ARRAY_DEPTH-1:0]  ecc_wdata_fifo_dataid_vector;
    wire  [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_rmw_correct;
    wire  [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_rmw_partial;
    
    wire                                                    ecc_wdata_fifo_read_first;
    wire  [CFG_DATA_ID_WIDTH-1:0]                           ecc_wdata_fifo_dataid_first;
    wire  [CFG_DATAID_ARRAY_DEPTH-1:0]                      ecc_wdata_fifo_dataid_vector_first;
    wire                                                    ecc_wdata_fifo_rmw_correct_first;
    wire                                                    ecc_wdata_fifo_rmw_partial_first;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]                         ecc_wdata_fifo_first_vector;
    
    wire                                                    ecc_wdata_fifo_read_last;
    wire  [CFG_DATA_ID_WIDTH-1:0]                           ecc_wdata_fifo_dataid_last;
    wire  [CFG_DATAID_ARRAY_DEPTH-1:0]                      ecc_wdata_fifo_dataid_vector_last;
    wire                                                    ecc_wdata_fifo_rmw_correct_last;
    wire                                                    ecc_wdata_fifo_rmw_partial_last;
    
    wire  [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_dqs_burst;
    wire  [CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2)-1:0]   afi_wdata_valid;
    wire  [CFG_MEM_IF_DQ_WIDTH*CFG_DWIDTH_RATIO-1:0]        afi_wdata;
    wire  [CFG_MEM_IF_DM_WIDTH*CFG_DWIDTH_RATIO-1:0]        afi_dm;
    
    //Internal signals
    reg  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_afi_output_combi [CFG_DRAM_WLAT_GROUP-1:0];
    reg  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_wdata_path_combi [CFG_DRAM_WLAT_GROUP-1:0];
    reg  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_afi_output_mux   [CFG_DRAM_WLAT_GROUP-1:0];
    reg  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_wdata_path_mux   [CFG_DRAM_WLAT_GROUP-1:0];
    reg  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_afi_output;
    reg  [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd_for_wdata_path;
    
    reg                                   doing_read_combi;
    reg                                   doing_read_full_combi;
    reg                                   doing_read_r;
    reg                                   doing_read_full_r;
    reg   [CFG_WLAT_PIPE_LENGTH-1:0]      doing_write_pipe;
    reg   [CFG_WLAT_PIPE_LENGTH-1:0]      rdwr_data_valid_pipe;
    reg   [CFG_WLAT_PIPE_LENGTH-1:0]      rmw_correct_pipe;
    reg   [CFG_WLAT_PIPE_LENGTH-1:0]      rmw_partial_pipe;
    reg   [CFG_DATA_ID_WIDTH-1:0]         dataid_pipe         [CFG_WLAT_PIPE_LENGTH-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    dataid_vector_pipe  [CFG_WLAT_PIPE_LENGTH-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    dataid_vector;
    reg                                   int_dqs_burst;
    reg                                   int_dqs_burst_r;
    reg                                   int_wdata_valid;
    reg                                   int_wdata_valid_r;
    reg                                   int_real_wdata_valid;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]       int_ecc_wdata_fifo_read;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]       int_ecc_wdata_fifo_read_r;
    reg   [CFG_DATA_ID_WIDTH-1:0]         int_ecc_wdata_fifo_dataid          [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATA_ID_WIDTH-1:0]         int_ecc_wdata_fifo_dataid_r        [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    int_ecc_wdata_fifo_dataid_vector   [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    int_ecc_wdata_fifo_dataid_vector_r [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DRAM_WLAT_GROUP-1:0]       int_ecc_wdata_fifo_rmw_correct;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]       int_ecc_wdata_fifo_rmw_correct_r;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]       int_ecc_wdata_fifo_rmw_partial;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]       int_ecc_wdata_fifo_rmw_partial_r;
    
    wire                                  int_do_rmw_correct;
    wire                                  int_do_rmw_partial;
    
    // DQS burst logic for half rate design
    reg                                   int_dqs_burst_half_rate;
    reg                                   int_dqs_burst_half_rate_r;
    
    reg   [CFG_DRAM_WLAT_GROUP-1:0]                     first_afi_wlat;
    reg   [CFG_DRAM_WLAT_GROUP-1:0]                     last_afi_wlat;
    
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  smallest_afi_wlat                                 [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  largest_afi_wlat                                  [CFG_DRAM_WLAT_GROUP-1:0];
    
    reg                                                 smallest_afi_wlat_eq_0;
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  smallest_afi_wlat_minus_1;
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  smallest_afi_wlat_minus_2;
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  smallest_afi_wlat_minus_3;
    reg                                                 smallest_doing_write_pipe_eq_afi_wlat_minus_0;
    reg                                                 smallest_doing_write_pipe_eq_afi_wlat_minus_1;
    reg                                                 smallest_doing_write_pipe_eq_afi_wlat_minus_2;
    reg                                                 smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1;
    reg                                                 smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2;
    reg   [CFG_DATA_ID_WIDTH-1:0]                       smallest_dataid_pipe_eq_afi_wlat_minus_1;
    reg   [CFG_DATA_ID_WIDTH-1:0]                       smallest_dataid_pipe_eq_afi_wlat_minus_2;
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  smallest_dataid_vector_pipe_eq_afi_wlat_minus_1;
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  smallest_dataid_vector_pipe_eq_afi_wlat_minus_2;
    reg                                                 smallest_rmw_correct_pipe_eq_afi_wlat_minus_1;
    reg                                                 smallest_rmw_correct_pipe_eq_afi_wlat_minus_2;
    reg                                                 smallest_rmw_partial_pipe_eq_afi_wlat_minus_1;
    reg                                                 smallest_rmw_partial_pipe_eq_afi_wlat_minus_2;
    reg                                                 smallest_doing_write_pipe_eq_afi_wlat_minus_x;
    reg                                                 smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x;
    reg   [CFG_DATA_ID_WIDTH-1:0]                       smallest_dataid_pipe_eq_afi_wlat_minus_x;
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  smallest_dataid_vector_pipe_eq_afi_wlat_minus_x;
    reg                                                 smallest_rmw_correct_pipe_eq_afi_wlat_minus_x;
    reg                                                 smallest_rmw_partial_pipe_eq_afi_wlat_minus_x;
    
    reg                                                 largest_afi_wlat_eq_0;
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  largest_afi_wlat_minus_1;
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  largest_afi_wlat_minus_2;
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  largest_afi_wlat_minus_3;
    reg                                                 largest_doing_write_pipe_eq_afi_wlat_minus_0;
    reg                                                 largest_doing_write_pipe_eq_afi_wlat_minus_1;
    reg                                                 largest_doing_write_pipe_eq_afi_wlat_minus_2;
    reg                                                 largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1;
    reg                                                 largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2;
    reg   [CFG_DATA_ID_WIDTH-1:0]                       largest_dataid_pipe_eq_afi_wlat_minus_1;
    reg   [CFG_DATA_ID_WIDTH-1:0]                       largest_dataid_pipe_eq_afi_wlat_minus_2;
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  largest_dataid_vector_pipe_eq_afi_wlat_minus_1;
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  largest_dataid_vector_pipe_eq_afi_wlat_minus_2;
    reg                                                 largest_rmw_correct_pipe_eq_afi_wlat_minus_1;
    reg                                                 largest_rmw_correct_pipe_eq_afi_wlat_minus_2;
    reg                                                 largest_rmw_partial_pipe_eq_afi_wlat_minus_1;
    reg                                                 largest_rmw_partial_pipe_eq_afi_wlat_minus_2;
    reg                                                 largest_doing_write_pipe_eq_afi_wlat_minus_x;
    reg                                                 largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x;
    reg   [CFG_DATA_ID_WIDTH-1:0]                       largest_dataid_pipe_eq_afi_wlat_minus_x;
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  largest_dataid_vector_pipe_eq_afi_wlat_minus_x;
    reg                                                 largest_rmw_correct_pipe_eq_afi_wlat_minus_x;
    reg                                                 largest_rmw_partial_pipe_eq_afi_wlat_minus_x;
    
    reg                                                 afi_wlat_eq_0                            [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  afi_wlat_minus_1                         [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  afi_wlat_minus_2                         [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_WLAT_BUS_WIDTH/CFG_DRAM_WLAT_GROUP-1:0]  afi_wlat_minus_3                         [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 doing_write_pipe_eq_afi_wlat_minus_0     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 doing_write_pipe_eq_afi_wlat_minus_1     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 doing_write_pipe_eq_afi_wlat_minus_2     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATA_ID_WIDTH-1:0]                       dataid_pipe_eq_afi_wlat_minus_1          [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATA_ID_WIDTH-1:0]                       dataid_pipe_eq_afi_wlat_minus_2          [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  dataid_vector_pipe_eq_afi_wlat_minus_1   [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  dataid_vector_pipe_eq_afi_wlat_minus_2   [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rmw_correct_pipe_eq_afi_wlat_minus_1     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rmw_correct_pipe_eq_afi_wlat_minus_2     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rmw_partial_pipe_eq_afi_wlat_minus_1     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rmw_partial_pipe_eq_afi_wlat_minus_2     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 doing_write_pipe_eq_afi_wlat_minus_x     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rdwr_data_valid_pipe_eq_afi_wlat_minus_x [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATA_ID_WIDTH-1:0]                       dataid_pipe_eq_afi_wlat_minus_x          [CFG_DRAM_WLAT_GROUP-1:0];
    reg   [CFG_DATAID_ARRAY_DEPTH-1:0]                  dataid_vector_pipe_eq_afi_wlat_minus_x   [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rmw_correct_pipe_eq_afi_wlat_minus_x     [CFG_DRAM_WLAT_GROUP-1:0];
    reg                                                 rmw_partial_pipe_eq_afi_wlat_minus_x     [CFG_DRAM_WLAT_GROUP-1:0];
    
    //=================================================================================================//
    //            Internal cfg_output_regd                                                             //
    //=================================================================================================//
    generate
        genvar N;
        for (N = 0;N < CFG_DRAM_WLAT_GROUP;N = N + 1)
        begin : output_regd_logic_per_dqs_group
            always @ (*)
            begin
                if (CFG_WDATA_REG || CFG_ECC_ENC_REG)
                begin
                    if (afi_wlat [(N + 1) * (CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : N * (CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP)] <= 1)
                    begin
                        // We enable output_regd for signals going to PHY
                        // because we need to fetch data 2 clock cycles earlier
                        cfg_output_regd_for_afi_output_combi [N] = 1'b1;
                        
                        // We disable output_regd for signals going to wdata_path
                        // because we need to fecth data 2 clock cycles earlier
                        cfg_output_regd_for_wdata_path_combi [N] = 1'b0;
                    end
                    else
                    begin
                        cfg_output_regd_for_afi_output_combi [N] = cfg_output_regd;
                        cfg_output_regd_for_wdata_path_combi [N] = cfg_output_regd;
                    end
                end
                else
                begin
                    cfg_output_regd_for_afi_output_combi [N] = cfg_output_regd;
                    cfg_output_regd_for_wdata_path_combi [N] = cfg_output_regd;
                end
            end
        end
        
        for (N = 1;N < CFG_DRAM_WLAT_GROUP;N = N + 1)
        begin : output_regd_mux_logic
            always @ (*)
            begin
                cfg_output_regd_for_afi_output_mux [N] = cfg_output_regd_for_afi_output_combi [N] | cfg_output_regd_for_afi_output_mux [N-1];
                cfg_output_regd_for_wdata_path_mux [N] = cfg_output_regd_for_wdata_path_combi [N] | cfg_output_regd_for_wdata_path_mux [N-1];
            end
        end
    endgenerate
    
    always @ (*)
    begin
        cfg_output_regd_for_afi_output_mux [0] = cfg_output_regd_for_afi_output_combi [0];
        cfg_output_regd_for_wdata_path_mux [0] = cfg_output_regd_for_wdata_path_combi [0];
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            cfg_output_regd_for_afi_output <= 1'b0;
            cfg_output_regd_for_wdata_path <= 1'b0;
        end
        else
        begin
            cfg_output_regd_for_afi_output <= cfg_output_regd_for_afi_output_mux [CFG_DRAM_WLAT_GROUP-1];
            cfg_output_regd_for_wdata_path <= cfg_output_regd_for_wdata_path_mux [CFG_DRAM_WLAT_GROUP-1];
        end
    end
    
    //=================================================================================================//
    //            Read timing logic                                                                    //
    //=================================================================================================//
    
    //*************************************************************************************************//
    //            afi_doing_read generation logic                                                      //
    //*************************************************************************************************//
    always @(*)
    begin
        if (bg_doing_read && bg_rdwr_data_valid)
        begin
            doing_read_combi = 1'b1;
        end
        else
        begin
            doing_read_combi = 1'b0;
        end
        
        doing_read_full_combi = bg_doing_read;
    end
    
    // registered output
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            doing_read_r      <= 1'b0;
            doing_read_full_r <= 1'b0;
        end
        else
        begin
            doing_read_r      <= doing_read_combi;
            doing_read_full_r <= doing_read_full_combi;
        end
    end
    
    generate
        genvar I;
        for (I = 0; I < CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2); I = I + 1)
            begin : B
                assign afi_doing_read      [I] = (cfg_output_regd_for_afi_output) ? doing_read_r      : doing_read_combi;
                assign afi_doing_read_full [I] = (cfg_output_regd_for_afi_output) ? doing_read_full_r : doing_read_full_combi;
            end
    endgenerate
    
    //=================================================================================================//
    //            Write timing logic                                                                   //
    //=================================================================================================//
    // Content of pipe shows how long dqs should toggle, used to generate dqs_burst
    // content of pipe is also used to generate wdata_valid signal
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            doing_write_pipe <= 0;
        end
        else
        begin
            doing_write_pipe <= {doing_write_pipe[CFG_WLAT_PIPE_LENGTH -2 :0],bg_doing_write};
        end
    end
    
    // content of pipe shows how much data should be read out of the write data FIFO
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            rdwr_data_valid_pipe <= 0;
        end
        else
        begin
            rdwr_data_valid_pipe <= {rdwr_data_valid_pipe[CFG_WLAT_PIPE_LENGTH - 2:0],bg_rdwr_data_valid};
        end
    end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            for (i=0; i<CFG_WLAT_PIPE_LENGTH; i=i+1)
            begin
                 dataid_pipe [i] <= 0;
            end
        end
        else
        begin
            dataid_pipe [0] <= dataid;
            
            for (i=1; i<CFG_WLAT_PIPE_LENGTH; i=i+1)
            begin
                dataid_pipe [i] <= dataid_pipe[i-1];
            end
        end
    end
    
    //pre-calculated dataid comparison logic
    always @ (*)
    begin
        for (i=0; i<(CFG_DATAID_ARRAY_DEPTH); i=i+1)
        begin
            if (dataid == i)
            begin
                dataid_vector [i] = 1'b1;
            end
            else
            begin
                dataid_vector [i] = 1'b0;
            end
        end
    end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            dataid_vector_pipe [0] <= 0;
            
            for (i=1; i<CFG_WLAT_PIPE_LENGTH; i=i+1)
            begin
                dataid_vector_pipe [i] <= 0;
            end
        end
        else
        begin
            dataid_vector_pipe [0] <= dataid_vector;
            
            for (i=1; i<CFG_WLAT_PIPE_LENGTH; i=i+1)
            begin
                dataid_vector_pipe [i] <= dataid_vector_pipe[i-1];
            end
        end
    end
    
    assign int_do_rmw_correct = |bg_do_rmw_correct;
    assign int_do_rmw_partial = |bg_do_rmw_partial;
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            rmw_correct_pipe <= 0;
        end
        else
        begin
            rmw_correct_pipe <= {rmw_correct_pipe[CFG_WLAT_PIPE_LENGTH - 2:0],int_do_rmw_correct};
        end
    end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            rmw_partial_pipe <= 0;
        end
        else
        begin
            rmw_partial_pipe <= {rmw_partial_pipe[CFG_WLAT_PIPE_LENGTH - 2:0],int_do_rmw_partial};
        end
    end
    
    // Pre-calculated logic for each DQS group
    generate
        genvar P;
        for (P = 0;P < CFG_DRAM_WLAT_GROUP;P = P + 1)
        begin : pre_calculate_logic_per_dqs_group
            // afi_wlat for current DQS group
            wire [(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : 0] current_afi_wlat = afi_wlat [(P + 1) * (CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : P * (CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP)];
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    afi_wlat_eq_0    [P] <= 1'b0;
                    afi_wlat_minus_1 [P] <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                    afi_wlat_minus_2 [P] <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                    afi_wlat_minus_3 [P] <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                end
                else
                begin
                    if (current_afi_wlat == 0)
                    begin
                        afi_wlat_eq_0 [P] <= 1'b1;
                    end
                    else
                    begin
                        afi_wlat_eq_0 [P] <= 1'b0;
                    end
            
                    afi_wlat_minus_1 [P] <= current_afi_wlat - 1;
                    afi_wlat_minus_2 [P] <= current_afi_wlat - 2;
                    afi_wlat_minus_3 [P] <= current_afi_wlat - 3;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b0;
                    doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                    doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                end
                else
                begin
                    if (current_afi_wlat == 0)
                    begin
                        doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b0;
                        doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                    end
                    else if (current_afi_wlat == 1)
                    begin
                        if (doing_write_pipe[0])
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b0;
                        end
                        
                        if (bg_doing_write)
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (bg_doing_write) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                    else if (current_afi_wlat == 2)
                    begin
                        if (doing_write_pipe[1])
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b0;
                        end
                        
                        if (doing_write_pipe[0])
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (bg_doing_write)
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (doing_write_pipe[afi_wlat_minus_1 [P]])
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_0 [P] <= 1'b0;
                        end
                        
                        if (doing_write_pipe[afi_wlat_minus_2 [P]])
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (doing_write_pipe[afi_wlat_minus_3 [P]])
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            doing_write_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                    rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                end
                else
                begin
                    if (current_afi_wlat == 0)
                    begin
                        rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                    end
                    else if (current_afi_wlat == 1)
                    begin
                        if (bg_rdwr_data_valid)
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (bg_rdwr_data_valid) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                    else if (current_afi_wlat == 2)
                    begin
                        if (rdwr_data_valid_pipe[0])
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (bg_rdwr_data_valid)
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (rdwr_data_valid_pipe[afi_wlat_minus_2 [P]])
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (rdwr_data_valid_pipe[afi_wlat_minus_3 [P]])
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    dataid_pipe_eq_afi_wlat_minus_1        [P] <= 0;
                    dataid_pipe_eq_afi_wlat_minus_2        [P] <= 0;
                    dataid_vector_pipe_eq_afi_wlat_minus_1 [P] <= 0;
                    dataid_vector_pipe_eq_afi_wlat_minus_2 [P] <= 0;
                end
                else
                begin
                    if (current_afi_wlat == 0)
                    begin
                        dataid_pipe_eq_afi_wlat_minus_1        [P] <= 0;
                        dataid_pipe_eq_afi_wlat_minus_2        [P] <= 0;
                        dataid_vector_pipe_eq_afi_wlat_minus_1 [P] <= 0;
                        dataid_vector_pipe_eq_afi_wlat_minus_2 [P] <= 0;
                    end
                    else if (current_afi_wlat == 1)
                    begin
                        dataid_pipe_eq_afi_wlat_minus_1        [P] <= dataid;
                        dataid_pipe_eq_afi_wlat_minus_2        [P] <= dataid;          // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        dataid_vector_pipe_eq_afi_wlat_minus_1 [P] <= dataid_vector;
                        dataid_vector_pipe_eq_afi_wlat_minus_2 [P] <= dataid_vector;   // we must disable int_cfg_output_regd when (afi_wlat < 2)
                    end
                    else if (current_afi_wlat == 2)
                    begin
                        dataid_pipe_eq_afi_wlat_minus_1        [P] <= dataid_pipe       [0];
                        dataid_pipe_eq_afi_wlat_minus_2        [P] <= dataid;
                        dataid_vector_pipe_eq_afi_wlat_minus_1 [P] <= dataid_vector_pipe[0];
                        dataid_vector_pipe_eq_afi_wlat_minus_2 [P] <= dataid_vector;
                    end
                    else
                    begin
                        dataid_pipe_eq_afi_wlat_minus_1        [P] <= dataid_pipe       [afi_wlat_minus_2 [P]];
                        dataid_pipe_eq_afi_wlat_minus_2        [P] <= dataid_pipe       [afi_wlat_minus_3 [P]];
                        dataid_vector_pipe_eq_afi_wlat_minus_1 [P] <= dataid_vector_pipe[afi_wlat_minus_2 [P]];
                        dataid_vector_pipe_eq_afi_wlat_minus_2 [P] <= dataid_vector_pipe[afi_wlat_minus_3 [P]];
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                    rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                    rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                    rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                end
                else
                begin
                    if (current_afi_wlat == 0)
                    begin
                        rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                    end
                    else if (current_afi_wlat == 1)
                    begin
                        if (int_do_rmw_correct)
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial)
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (int_do_rmw_correct) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                    else if (current_afi_wlat == 2)
                    begin
                        if (rmw_correct_pipe[0])
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[0])
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (int_do_rmw_correct)
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial)
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (rmw_correct_pipe[afi_wlat_minus_2 [P]])
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[afi_wlat_minus_2 [P]])
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_1 [P] <= 1'b0;
                        end
                        
                        if (rmw_correct_pipe[afi_wlat_minus_3 [P]])
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_correct_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[afi_wlat_minus_3 [P]])
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b1;
                        end
                        else
                        begin
                            rmw_partial_pipe_eq_afi_wlat_minus_2 [P] <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (*)
            begin
                if (CFG_WDATA_REG || CFG_ECC_ENC_REG)
                begin
                    doing_write_pipe_eq_afi_wlat_minus_x     [P] = doing_write_pipe_eq_afi_wlat_minus_2     [P];
                    rdwr_data_valid_pipe_eq_afi_wlat_minus_x [P] = rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [P];
                    dataid_pipe_eq_afi_wlat_minus_x          [P] = dataid_pipe_eq_afi_wlat_minus_2          [P];
                    dataid_vector_pipe_eq_afi_wlat_minus_x   [P] = dataid_vector_pipe_eq_afi_wlat_minus_2   [P];
                    rmw_correct_pipe_eq_afi_wlat_minus_x     [P] = rmw_correct_pipe_eq_afi_wlat_minus_2     [P];
                    rmw_partial_pipe_eq_afi_wlat_minus_x     [P] = rmw_partial_pipe_eq_afi_wlat_minus_2     [P];
                end
                else
                begin
                    doing_write_pipe_eq_afi_wlat_minus_x     [P] = doing_write_pipe_eq_afi_wlat_minus_1     [P];
                    rdwr_data_valid_pipe_eq_afi_wlat_minus_x [P] = rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [P];
                    dataid_pipe_eq_afi_wlat_minus_x          [P] = dataid_pipe_eq_afi_wlat_minus_1          [P];
                    dataid_vector_pipe_eq_afi_wlat_minus_x   [P] = dataid_vector_pipe_eq_afi_wlat_minus_1   [P];
                    rmw_correct_pipe_eq_afi_wlat_minus_x     [P] = rmw_correct_pipe_eq_afi_wlat_minus_1     [P];
                    rmw_partial_pipe_eq_afi_wlat_minus_x     [P] = rmw_partial_pipe_eq_afi_wlat_minus_1     [P];
                end
            end
            
            // First vector
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    ecc_wdata_fifo_first_vector [P] <= 1'b0;
                end
                else
                begin
                    if (current_afi_wlat == smallest_afi_wlat [CFG_DRAM_WLAT_GROUP - 1])
                    begin
                        ecc_wdata_fifo_first_vector [P] <= 1'b1;
                    end
                    else
                    begin
                        ecc_wdata_fifo_first_vector [P] <= 1'b0;
                    end
                end
            end
        end
        
        for (P = 1;P < CFG_DRAM_WLAT_GROUP;P = P + 1)
        begin : afi_wlat_info_logic
            // afi_wlat for current DQS group
            wire [(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : 0] current_afi_wlat = afi_wlat [(P + 1) * (CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : P * (CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP)];
            
            // Smallest/largest afi_wlat logic
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    smallest_afi_wlat [P] <= 0;
                    largest_afi_wlat  [P] <= 0;
                end
                else
                begin
                    if (current_afi_wlat < smallest_afi_wlat [P-1])
                    begin
                        smallest_afi_wlat [P] <= current_afi_wlat;
                    end
                    else
                    begin
                        smallest_afi_wlat [P] <= smallest_afi_wlat [P-1];
                    end
                    
                    if (current_afi_wlat > largest_afi_wlat [P-1])
                    begin
                        largest_afi_wlat [P] <= current_afi_wlat;
                    end
                    else
                    begin
                        largest_afi_wlat [P] <= largest_afi_wlat [P-1];
                    end
                end
            end
        end
    endgenerate
    
    // Smallest/largest afi_wlat logic
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            smallest_afi_wlat [0] <= 0;
            largest_afi_wlat  [0] <= 0;
        end
        else
        begin
            smallest_afi_wlat [0] <= afi_wlat [(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : 0];
            largest_afi_wlat  [0] <= afi_wlat [(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP) - 1 : 0];
        end
    end
    
    generate
        if (CFG_DRAM_WLAT_GROUP == 1) // only one group of afi_wlat
        begin
            always @ (*)
            begin
                smallest_afi_wlat_eq_0                            = afi_wlat_eq_0                            [0];
                smallest_afi_wlat_minus_1                         = afi_wlat_minus_1                         [0];
                smallest_afi_wlat_minus_2                         = afi_wlat_minus_2                         [0];
                smallest_afi_wlat_minus_3                         = afi_wlat_minus_3                         [0];
                smallest_doing_write_pipe_eq_afi_wlat_minus_0     = doing_write_pipe_eq_afi_wlat_minus_0     [0];
                smallest_doing_write_pipe_eq_afi_wlat_minus_1     = doing_write_pipe_eq_afi_wlat_minus_1     [0];
                smallest_doing_write_pipe_eq_afi_wlat_minus_2     = doing_write_pipe_eq_afi_wlat_minus_2     [0];
                smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 = rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [0];
                smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 = rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [0];
                smallest_dataid_pipe_eq_afi_wlat_minus_1          = dataid_pipe_eq_afi_wlat_minus_1          [0];
                smallest_dataid_pipe_eq_afi_wlat_minus_2          = dataid_pipe_eq_afi_wlat_minus_2          [0];
                smallest_dataid_vector_pipe_eq_afi_wlat_minus_1   = dataid_vector_pipe_eq_afi_wlat_minus_1   [0];
                smallest_dataid_vector_pipe_eq_afi_wlat_minus_2   = dataid_vector_pipe_eq_afi_wlat_minus_2   [0];
                smallest_rmw_correct_pipe_eq_afi_wlat_minus_1     = rmw_correct_pipe_eq_afi_wlat_minus_1     [0];
                smallest_rmw_correct_pipe_eq_afi_wlat_minus_2     = rmw_correct_pipe_eq_afi_wlat_minus_2     [0];
                smallest_rmw_partial_pipe_eq_afi_wlat_minus_1     = rmw_partial_pipe_eq_afi_wlat_minus_1     [0];
                smallest_rmw_partial_pipe_eq_afi_wlat_minus_2     = rmw_partial_pipe_eq_afi_wlat_minus_2     [0];
                smallest_doing_write_pipe_eq_afi_wlat_minus_x     = doing_write_pipe_eq_afi_wlat_minus_x     [0];
                smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x = rdwr_data_valid_pipe_eq_afi_wlat_minus_x [0];
                smallest_dataid_pipe_eq_afi_wlat_minus_x          = dataid_pipe_eq_afi_wlat_minus_x          [0];
                smallest_dataid_vector_pipe_eq_afi_wlat_minus_x   = dataid_vector_pipe_eq_afi_wlat_minus_x   [0];
                smallest_rmw_correct_pipe_eq_afi_wlat_minus_x     = rmw_correct_pipe_eq_afi_wlat_minus_x     [0];
                smallest_rmw_partial_pipe_eq_afi_wlat_minus_x     = rmw_partial_pipe_eq_afi_wlat_minus_x     [0];
                
                largest_afi_wlat_eq_0                             = afi_wlat_eq_0                            [0];
                largest_afi_wlat_minus_1                          = afi_wlat_minus_1                         [0];
                largest_afi_wlat_minus_2                          = afi_wlat_minus_2                         [0];
                largest_afi_wlat_minus_3                          = afi_wlat_minus_3                         [0];
                largest_doing_write_pipe_eq_afi_wlat_minus_0      = doing_write_pipe_eq_afi_wlat_minus_0     [0];
                largest_doing_write_pipe_eq_afi_wlat_minus_1      = doing_write_pipe_eq_afi_wlat_minus_1     [0];
                largest_doing_write_pipe_eq_afi_wlat_minus_2      = doing_write_pipe_eq_afi_wlat_minus_2     [0];
                largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1  = rdwr_data_valid_pipe_eq_afi_wlat_minus_1 [0];
                largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2  = rdwr_data_valid_pipe_eq_afi_wlat_minus_2 [0];
                largest_dataid_pipe_eq_afi_wlat_minus_1           = dataid_pipe_eq_afi_wlat_minus_1          [0];
                largest_dataid_pipe_eq_afi_wlat_minus_2           = dataid_pipe_eq_afi_wlat_minus_2          [0];
                largest_dataid_vector_pipe_eq_afi_wlat_minus_1    = dataid_vector_pipe_eq_afi_wlat_minus_1   [0];
                largest_dataid_vector_pipe_eq_afi_wlat_minus_2    = dataid_vector_pipe_eq_afi_wlat_minus_2   [0];
                largest_rmw_correct_pipe_eq_afi_wlat_minus_1      = rmw_correct_pipe_eq_afi_wlat_minus_1     [0];
                largest_rmw_correct_pipe_eq_afi_wlat_minus_2      = rmw_correct_pipe_eq_afi_wlat_minus_2     [0];
                largest_rmw_partial_pipe_eq_afi_wlat_minus_1      = rmw_partial_pipe_eq_afi_wlat_minus_1     [0];
                largest_rmw_partial_pipe_eq_afi_wlat_minus_2      = rmw_partial_pipe_eq_afi_wlat_minus_2     [0];
                largest_doing_write_pipe_eq_afi_wlat_minus_x      = doing_write_pipe_eq_afi_wlat_minus_x     [0];
                largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x  = rdwr_data_valid_pipe_eq_afi_wlat_minus_x [0];
                largest_dataid_pipe_eq_afi_wlat_minus_x           = dataid_pipe_eq_afi_wlat_minus_x          [0];
                largest_dataid_vector_pipe_eq_afi_wlat_minus_x    = dataid_vector_pipe_eq_afi_wlat_minus_x   [0];
                largest_rmw_correct_pipe_eq_afi_wlat_minus_x      = rmw_correct_pipe_eq_afi_wlat_minus_x     [0];
                largest_rmw_partial_pipe_eq_afi_wlat_minus_x      = rmw_partial_pipe_eq_afi_wlat_minus_x     [0];
            end
        end
        else
        begin
            // Pre-calculated logic for smallest/largest afi_wlat (for afi addr/cmd logic)
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    smallest_afi_wlat_eq_0     <= 1'b0;
                    smallest_afi_wlat_minus_1  <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                    smallest_afi_wlat_minus_2  <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                    smallest_afi_wlat_minus_3  <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                end
                else
                begin
                    if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        smallest_afi_wlat_eq_0  <= 1'b1;
                    end
                    else
                    begin
                        smallest_afi_wlat_eq_0  <= 1'b0;
                    end
                    
                    smallest_afi_wlat_minus_1  <= smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] - 1;
                    smallest_afi_wlat_minus_2  <= smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] - 2;
                    smallest_afi_wlat_minus_3  <= smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] - 3;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                    smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                    smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                end
                else
                begin
                    if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        if (doing_write_pipe[0])
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        end
                        
                        if (bg_doing_write)
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        end
                        
                        if (bg_doing_write) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                        end
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        if (doing_write_pipe[1])
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        end
                        
                        if (doing_write_pipe[0])
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        end
                        
                        if (bg_doing_write)
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (doing_write_pipe[smallest_afi_wlat_minus_1])
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        end
                        
                        if (doing_write_pipe[smallest_afi_wlat_minus_2])
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        end
                        
                        if (doing_write_pipe[smallest_afi_wlat_minus_3])
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b1;
                        end
                        else
                        begin
                            smallest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                    smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                end
                else
                begin
                    if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        if (bg_rdwr_data_valid)
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (bg_rdwr_data_valid) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        if (rdwr_data_valid_pipe[0])
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (bg_rdwr_data_valid)
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (rdwr_data_valid_pipe[smallest_afi_wlat_minus_2])
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rdwr_data_valid_pipe[smallest_afi_wlat_minus_3])
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    smallest_dataid_pipe_eq_afi_wlat_minus_1        <= 0;
                    smallest_dataid_pipe_eq_afi_wlat_minus_2        <= 0;
                    smallest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= 0;
                    smallest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= 0;
                end
                else
                begin
                    if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        smallest_dataid_pipe_eq_afi_wlat_minus_1        <= 0;
                        smallest_dataid_pipe_eq_afi_wlat_minus_2        <= 0;
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= 0;
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= 0;
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        smallest_dataid_pipe_eq_afi_wlat_minus_1        <= dataid;
                        smallest_dataid_pipe_eq_afi_wlat_minus_2        <= dataid;          // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= dataid_vector;
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= dataid_vector;   // we must disable int_cfg_output_regd when (afi_wlat < 2)
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        smallest_dataid_pipe_eq_afi_wlat_minus_1        <= dataid_pipe       [0];
                        smallest_dataid_pipe_eq_afi_wlat_minus_2        <= dataid;
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= dataid_vector_pipe[0];
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= dataid_vector;
                    end
                    else
                    begin
                        smallest_dataid_pipe_eq_afi_wlat_minus_1        <= dataid_pipe       [smallest_afi_wlat_minus_2];
                        smallest_dataid_pipe_eq_afi_wlat_minus_2        <= dataid_pipe       [smallest_afi_wlat_minus_3];
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= dataid_vector_pipe[smallest_afi_wlat_minus_2];
                        smallest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= dataid_vector_pipe[smallest_afi_wlat_minus_3];
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                    smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                    smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                    smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                end
                else
                begin
                    if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        if (int_do_rmw_correct)
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial)
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (int_do_rmw_correct) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else if (smallest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        if (rmw_correct_pipe[0])
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[0])
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (int_do_rmw_correct)
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial)
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (rmw_correct_pipe[smallest_afi_wlat_minus_2])
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[smallest_afi_wlat_minus_2])
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rmw_correct_pipe[smallest_afi_wlat_minus_3])
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[smallest_afi_wlat_minus_3])
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            smallest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (*)
            begin
                if (CFG_WDATA_REG || CFG_ECC_ENC_REG)
                begin
                    smallest_doing_write_pipe_eq_afi_wlat_minus_x     = smallest_doing_write_pipe_eq_afi_wlat_minus_2    ;
                    smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x = smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2;
                    smallest_dataid_pipe_eq_afi_wlat_minus_x          = smallest_dataid_pipe_eq_afi_wlat_minus_2         ;
                    smallest_dataid_vector_pipe_eq_afi_wlat_minus_x   = smallest_dataid_vector_pipe_eq_afi_wlat_minus_2  ;
                    smallest_rmw_correct_pipe_eq_afi_wlat_minus_x     = smallest_rmw_correct_pipe_eq_afi_wlat_minus_2    ;
                    smallest_rmw_partial_pipe_eq_afi_wlat_minus_x     = smallest_rmw_partial_pipe_eq_afi_wlat_minus_2    ;
                end
                else
                begin
                    smallest_doing_write_pipe_eq_afi_wlat_minus_x     = smallest_doing_write_pipe_eq_afi_wlat_minus_1    ;
                    smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x = smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1;
                    smallest_dataid_pipe_eq_afi_wlat_minus_x          = smallest_dataid_pipe_eq_afi_wlat_minus_1         ;
                    smallest_dataid_vector_pipe_eq_afi_wlat_minus_x   = smallest_dataid_vector_pipe_eq_afi_wlat_minus_1  ;
                    smallest_rmw_correct_pipe_eq_afi_wlat_minus_x     = smallest_rmw_correct_pipe_eq_afi_wlat_minus_1    ;
                    smallest_rmw_partial_pipe_eq_afi_wlat_minus_x     = smallest_rmw_partial_pipe_eq_afi_wlat_minus_1    ;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    largest_afi_wlat_eq_0     <= 1'b0;
                    largest_afi_wlat_minus_1  <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                    largest_afi_wlat_minus_2  <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                    largest_afi_wlat_minus_3  <= {(CFG_WLAT_BUS_WIDTH / CFG_DRAM_WLAT_GROUP){1'b0}};
                end
                else
                begin
                    if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        largest_afi_wlat_eq_0  <= 1'b1;
                    end
                    else
                    begin
                        largest_afi_wlat_eq_0  <= 1'b0;
                    end
                    
                    largest_afi_wlat_minus_1  <= largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] - 1;
                    largest_afi_wlat_minus_2  <= largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] - 2;
                    largest_afi_wlat_minus_3  <= largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] - 3;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                    largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                    largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                end
                else
                begin
                    if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        if (doing_write_pipe[0])
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        end
                        
                        if (bg_doing_write)
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        end
                        
                        if (bg_doing_write) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                        end
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        if (doing_write_pipe[1])
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        end
                        
                        if (doing_write_pipe[0])
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        end
                        
                        if (bg_doing_write)
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (doing_write_pipe[largest_afi_wlat_minus_1])
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_0  <= 1'b0;
                        end
                        
                        if (doing_write_pipe[largest_afi_wlat_minus_2])
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_1  <= 1'b0;
                        end
                        
                        if (doing_write_pipe[largest_afi_wlat_minus_3])
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b1;
                        end
                        else
                        begin
                            largest_doing_write_pipe_eq_afi_wlat_minus_2  <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                    largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                end
                else
                begin
                    if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        if (bg_rdwr_data_valid)
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (bg_rdwr_data_valid) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        if (rdwr_data_valid_pipe[0])
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (bg_rdwr_data_valid)
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (rdwr_data_valid_pipe[largest_afi_wlat_minus_2])
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rdwr_data_valid_pipe[largest_afi_wlat_minus_3])
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    largest_dataid_pipe_eq_afi_wlat_minus_1        <= 0;
                    largest_dataid_pipe_eq_afi_wlat_minus_2        <= 0;
                    largest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= 0;
                    largest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= 0;
                end
                else
                begin
                    if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        largest_dataid_pipe_eq_afi_wlat_minus_1        <= 0;
                        largest_dataid_pipe_eq_afi_wlat_minus_2        <= 0;
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= 0;
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= 0;
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        largest_dataid_pipe_eq_afi_wlat_minus_1        <= dataid;
                        largest_dataid_pipe_eq_afi_wlat_minus_2        <= dataid;          // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= dataid_vector;
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= dataid_vector;   // we must disable int_cfg_output_regd when (afi_wlat < 2)
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        largest_dataid_pipe_eq_afi_wlat_minus_1        <= dataid_pipe       [0];
                        largest_dataid_pipe_eq_afi_wlat_minus_2        <= dataid;
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= dataid_vector_pipe[0];
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= dataid_vector;
                    end
                    else
                    begin
                        largest_dataid_pipe_eq_afi_wlat_minus_1        <= dataid_pipe       [largest_afi_wlat_minus_2];
                        largest_dataid_pipe_eq_afi_wlat_minus_2        <= dataid_pipe       [largest_afi_wlat_minus_3];
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_1 <= dataid_vector_pipe[largest_afi_wlat_minus_2];
                        largest_dataid_vector_pipe_eq_afi_wlat_minus_2 <= dataid_vector_pipe[largest_afi_wlat_minus_3];
                    end
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                    largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                    largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                    largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                end
                else
                begin
                    if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 0)
                    begin
                        largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 1)
                    begin
                        if (int_do_rmw_correct)
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial)
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (int_do_rmw_correct) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial) // we must disable int_cfg_output_regd when (afi_wlat < 2)
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else if (largest_afi_wlat [CFG_DRAM_WLAT_GROUP-1] == 2)
                    begin
                        if (rmw_correct_pipe[0])
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[0])
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (int_do_rmw_correct)
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                        
                        if (int_do_rmw_partial)
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                    else
                    begin
                        if (rmw_correct_pipe[largest_afi_wlat_minus_2])
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[largest_afi_wlat_minus_2])
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_1 <= 1'b0;
                        end
                        
                        if (rmw_correct_pipe[largest_afi_wlat_minus_3])
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_correct_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                        
                        if (rmw_partial_pipe[largest_afi_wlat_minus_3])
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b1;
                        end
                        else
                        begin
                            largest_rmw_partial_pipe_eq_afi_wlat_minus_2 <= 1'b0;
                        end
                    end
                end
            end
            
            always @ (*)
            begin
                if (CFG_WDATA_REG || CFG_ECC_ENC_REG)
                begin
                    largest_doing_write_pipe_eq_afi_wlat_minus_x     = largest_doing_write_pipe_eq_afi_wlat_minus_2    ;
                    largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x = largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_2;
                    largest_dataid_pipe_eq_afi_wlat_minus_x          = largest_dataid_pipe_eq_afi_wlat_minus_2         ;
                    largest_dataid_vector_pipe_eq_afi_wlat_minus_x   = largest_dataid_vector_pipe_eq_afi_wlat_minus_2  ;
                    largest_rmw_correct_pipe_eq_afi_wlat_minus_x     = largest_rmw_correct_pipe_eq_afi_wlat_minus_2    ;
                    largest_rmw_partial_pipe_eq_afi_wlat_minus_x     = largest_rmw_partial_pipe_eq_afi_wlat_minus_2    ;
                end
                else
                begin
                    largest_doing_write_pipe_eq_afi_wlat_minus_x     = largest_doing_write_pipe_eq_afi_wlat_minus_1    ;
                    largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x = largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_1;
                    largest_dataid_pipe_eq_afi_wlat_minus_x          = largest_dataid_pipe_eq_afi_wlat_minus_1         ;
                    largest_dataid_vector_pipe_eq_afi_wlat_minus_x   = largest_dataid_vector_pipe_eq_afi_wlat_minus_1  ;
                    largest_rmw_correct_pipe_eq_afi_wlat_minus_x     = largest_rmw_correct_pipe_eq_afi_wlat_minus_1    ;
                    largest_rmw_partial_pipe_eq_afi_wlat_minus_x     = largest_rmw_partial_pipe_eq_afi_wlat_minus_1    ;
                end
            end
        end
    endgenerate
    
    //*************************************************************************************************//
    //            afi_dqs_burst generation logic                                                       //
    //*************************************************************************************************//
    // high earlier than wdata_valid but ends the same
    // for writes only, where dqs should toggle, use doing_write_pipe
    always @(*)
    begin
        if (smallest_afi_wlat_eq_0)
        begin
            if (bg_doing_write || doing_write_pipe[0])
            begin
                int_dqs_burst = 1'b1;
            end
            else
            begin
                int_dqs_burst = 1'b0;
            end
        end
        else
        begin
            if (smallest_doing_write_pipe_eq_afi_wlat_minus_1 || smallest_doing_write_pipe_eq_afi_wlat_minus_0)
            begin
                int_dqs_burst = 1'b1;
            end
            else
            begin
                int_dqs_burst = 1'b0;
            end
        end
    end
    
    // registered output
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_dqs_burst_r <= 1'b0;
        end
        else
        begin
            int_dqs_burst_r <= int_dqs_burst;
        end
    end
    
    always @ (*)
    begin
        if (smallest_afi_wlat_eq_0)
        begin
            if (doing_write_pipe[0])
            begin
                int_dqs_burst_half_rate = 1'b1;
            end
            else
            begin
                int_dqs_burst_half_rate = 1'b0;
            end
        end
        else
        begin
            if (smallest_doing_write_pipe_eq_afi_wlat_minus_0)
            begin
                int_dqs_burst_half_rate = 1'b1;
            end
            else
            begin
                int_dqs_burst_half_rate = 1'b0;
            end
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_dqs_burst_half_rate_r <= 1'b0;
        end
        else
        begin
            int_dqs_burst_half_rate_r <= int_dqs_burst_half_rate;
        end
    end
    
    generate
        genvar K;
        if (CFG_DWIDTH_RATIO == 2) // fullrate
        begin
            for (K = 0; K < CFG_MEM_IF_DQS_WIDTH; K = K + 1)
            begin : C
                assign afi_dqs_burst[K] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_r : int_dqs_burst;
            end
        end
        else if (CFG_DWIDTH_RATIO == 4) // halfrate
        begin
            for (K = 0; K < CFG_MEM_IF_DQS_WIDTH; K = K + 1)
            begin : C
                assign afi_dqs_burst[K + CFG_MEM_IF_DQS_WIDTH] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_r           : int_dqs_burst          ;
                assign afi_dqs_burst[K                       ] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_half_rate_r : int_dqs_burst_half_rate;
            end
        end
        else if (CFG_DWIDTH_RATIO == 8) // quarterrate
        begin
            for (K = 0; K < CFG_MEM_IF_DQS_WIDTH; K = K + 1)
            begin : C
                assign afi_dqs_burst[K + CFG_MEM_IF_DQS_WIDTH * 3] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_r           : int_dqs_burst          ;
                assign afi_dqs_burst[K + CFG_MEM_IF_DQS_WIDTH * 2] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_half_rate_r : int_dqs_burst_half_rate;
                assign afi_dqs_burst[K + CFG_MEM_IF_DQS_WIDTH * 1] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_half_rate_r : int_dqs_burst_half_rate;
                assign afi_dqs_burst[K                           ] = (cfg_output_regd_for_afi_output == 1) ? int_dqs_burst_half_rate_r : int_dqs_burst_half_rate;
            end
        end
    endgenerate
    
    //*************************************************************************************************//
    //            afi_wdata_valid generation logic                                                     //
    //*************************************************************************************************//
    always @(*)
    begin
        if (smallest_afi_wlat_eq_0)
        begin
            if (doing_write_pipe[0])
            begin
                int_wdata_valid = 1'b1;
            end
            else
            begin
                int_wdata_valid = 1'b0;
            end
        end
        else
        begin
            if (smallest_doing_write_pipe_eq_afi_wlat_minus_0)
            begin
                int_wdata_valid = 1'b1;
            end
            else
            begin
                int_wdata_valid = 1'b0;
            end
        end
    end
    
    // registered output
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_wdata_valid_r <= 1'b0;
        end
        else
        begin
            int_wdata_valid_r <= int_wdata_valid;
        end
    end
    
    generate
        genvar L;
        for (L = 0; L < CFG_MEM_IF_DQS_WIDTH*(CFG_DWIDTH_RATIO/2); L = L + 1)
        begin : D
            assign afi_wdata_valid[L] = (cfg_output_regd_for_afi_output) ? int_wdata_valid_r : int_wdata_valid;
        end
    endgenerate
    
    //*************************************************************************************************//
    //            afi_wdata generation logic                                                           //
    //*************************************************************************************************//
    generate
        genvar M;
        for (M = 0;M < CFG_DRAM_WLAT_GROUP;M = M + 1) // generate wlat logic for each DQS group
        begin : wlat_logic_per_dqs_group
            //*************************************************************************************************//
            //            ecc_wdata_fifo_read                                                                  //
            //*************************************************************************************************//
            // Indicate when to read from write data buffer
            // based on burst_gen signals
            always @(*)
            begin
                if (afi_wlat_eq_0 [M])
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_read [M] = 1'b1;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_read [M] = 1'b0;
                    end
                end
                else
                begin
                    if (rdwr_data_valid_pipe_eq_afi_wlat_minus_x [M] && doing_write_pipe_eq_afi_wlat_minus_x [M])
                    begin
                        int_ecc_wdata_fifo_read [M] = 1'b1;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_read [M] = 1'b0;
                    end
                end
            end
            
            // Registered output
            always @(posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_read_r [M] <= 1'b0;
                end
                else
                begin
                    int_ecc_wdata_fifo_read_r [M] <= int_ecc_wdata_fifo_read [M];
                end
            end
            
            // Determine write data buffer read signal based on output_regd info
            // output_regd info is derived based on afi_wlat value
            assign ecc_wdata_fifo_read [M] = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_read_r [M] : int_ecc_wdata_fifo_read [M];
            
            // Registered output
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    ecc_wdata_fifo_read_r [M] <= 1'b0;
                end
                else
                begin
                    ecc_wdata_fifo_read_r [M] <= ecc_wdata_fifo_read [M];
                end
            end
            
            //*************************************************************************************************//
            //            ecc_wdata_fifo_dataid/dataid_vector                                                  //
            //*************************************************************************************************//
            // Dataid generation to write buffer, to indicate which wdata should be passed to AFI
            always @(*)
            begin
                if (afi_wlat_eq_0 [M])
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_dataid        [M] = dataid;
                        int_ecc_wdata_fifo_dataid_vector [M] = dataid_vector;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_dataid        [M] = {(CFG_DATA_ID_WIDTH){1'b0}};
                        int_ecc_wdata_fifo_dataid_vector [M] = {(CFG_DATAID_ARRAY_DEPTH){1'b0}};
                    end
                end
                else
                begin
                    if (rdwr_data_valid_pipe_eq_afi_wlat_minus_x [M] && doing_write_pipe_eq_afi_wlat_minus_x [M])
                    begin
                        int_ecc_wdata_fifo_dataid        [M] = dataid_pipe_eq_afi_wlat_minus_x        [M];
                        int_ecc_wdata_fifo_dataid_vector [M] = dataid_vector_pipe_eq_afi_wlat_minus_x [M];
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_dataid        [M] = {(CFG_DATA_ID_WIDTH){1'b0}};
                        int_ecc_wdata_fifo_dataid_vector [M] = {(CFG_DATAID_ARRAY_DEPTH){1'b0}};
                    end
                end
            end
            
            // Registered output
            always @ (posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (~ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_dataid_r        [M] <= 0;
                    int_ecc_wdata_fifo_dataid_vector_r [M] <= 0;
                end
                else
                begin
                    int_ecc_wdata_fifo_dataid_r        [M] <= int_ecc_wdata_fifo_dataid        [M];
                    int_ecc_wdata_fifo_dataid_vector_r [M] <= int_ecc_wdata_fifo_dataid_vector [M];
                end
            end
            
            assign ecc_wdata_fifo_dataid        [(M + 1) * CFG_DATA_ID_WIDTH      - 1 : M * CFG_DATA_ID_WIDTH     ] = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_dataid_r        [M] : int_ecc_wdata_fifo_dataid        [M];
            assign ecc_wdata_fifo_dataid_vector [(M + 1) * CFG_DATAID_ARRAY_DEPTH - 1 : M * CFG_DATAID_ARRAY_DEPTH] = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_dataid_vector_r [M] : int_ecc_wdata_fifo_dataid_vector [M];
            
            //*************************************************************************************************//
            //            ecc_wdata_fifo_rmw_correct/partial                                                   //
            //*************************************************************************************************//
            // Read modify write info logic
            always @(*)
            begin
                if (afi_wlat_eq_0 [M])
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_rmw_correct [M] = int_do_rmw_correct;
                        int_ecc_wdata_fifo_rmw_partial [M] = int_do_rmw_partial;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_rmw_correct [M] = 1'b0;
                        int_ecc_wdata_fifo_rmw_partial [M] = 1'b0;
                    end
                end
                else
                begin
                    if (rdwr_data_valid_pipe_eq_afi_wlat_minus_x [M] && doing_write_pipe_eq_afi_wlat_minus_x [M])
                    begin
                        int_ecc_wdata_fifo_rmw_correct [M] = rmw_correct_pipe_eq_afi_wlat_minus_x [M];
                        int_ecc_wdata_fifo_rmw_partial [M] = rmw_partial_pipe_eq_afi_wlat_minus_x [M];
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_rmw_correct [M] = 1'b0;
                        int_ecc_wdata_fifo_rmw_partial [M] = 1'b0;
                    end
                end
            end
            
            always @ (posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (~ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_rmw_correct_r [M] <= 0;
                    int_ecc_wdata_fifo_rmw_partial_r [M] <= 0;
                end
                else
                begin
                    int_ecc_wdata_fifo_rmw_correct_r [M] <= int_ecc_wdata_fifo_rmw_correct [M];
                    int_ecc_wdata_fifo_rmw_partial_r [M] <= int_ecc_wdata_fifo_rmw_partial [M];
                end
            end
            
            assign ecc_wdata_fifo_rmw_correct [M] = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_rmw_correct_r [M] : int_ecc_wdata_fifo_rmw_correct [M];
            assign ecc_wdata_fifo_rmw_partial [M] = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_rmw_partial_r [M] : int_ecc_wdata_fifo_rmw_partial [M];
        end
    endgenerate
    
    generate
        if (CFG_DRAM_WLAT_GROUP == 1) // only one group of afi_wlat
        begin
            assign ecc_wdata_fifo_read_first          = ecc_wdata_fifo_read;
            assign ecc_wdata_fifo_dataid_first        = ecc_wdata_fifo_dataid;
            assign ecc_wdata_fifo_dataid_vector_first = ecc_wdata_fifo_dataid_vector;
            assign ecc_wdata_fifo_rmw_correct_first   = ecc_wdata_fifo_rmw_correct;
            assign ecc_wdata_fifo_rmw_partial_first   = ecc_wdata_fifo_rmw_partial;
            
            assign ecc_wdata_fifo_read_last           = ecc_wdata_fifo_read;
            assign ecc_wdata_fifo_dataid_last         = ecc_wdata_fifo_dataid;
            assign ecc_wdata_fifo_dataid_vector_last  = ecc_wdata_fifo_dataid_vector;
            assign ecc_wdata_fifo_rmw_correct_last    = ecc_wdata_fifo_rmw_correct;
            assign ecc_wdata_fifo_rmw_partial_last    = ecc_wdata_fifo_rmw_partial;
        end
        else
        begin
            reg                                   ecc_wdata_fifo_read_first_r;
            reg                                   int_ecc_wdata_fifo_read_first;
            reg                                   int_ecc_wdata_fifo_read_first_r;
            reg   [CFG_DATA_ID_WIDTH-1:0]         int_ecc_wdata_fifo_dataid_first;
            reg   [CFG_DATA_ID_WIDTH-1:0]         int_ecc_wdata_fifo_dataid_first_r;
            reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    int_ecc_wdata_fifo_dataid_vector_first;
            reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    int_ecc_wdata_fifo_dataid_vector_first_r;
            reg                                   int_ecc_wdata_fifo_rmw_correct_first;
            reg                                   int_ecc_wdata_fifo_rmw_correct_first_r;
            reg                                   int_ecc_wdata_fifo_rmw_partial_first;
            reg                                   int_ecc_wdata_fifo_rmw_partial_first_r;
            
            reg                                   ecc_wdata_fifo_read_last_r;
            reg                                   int_ecc_wdata_fifo_read_last;
            reg                                   int_ecc_wdata_fifo_read_last_r;
            reg   [CFG_DATA_ID_WIDTH-1:0]         int_ecc_wdata_fifo_dataid_last;
            reg   [CFG_DATA_ID_WIDTH-1:0]         int_ecc_wdata_fifo_dataid_last_r;
            reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    int_ecc_wdata_fifo_dataid_vector_last;
            reg   [CFG_DATAID_ARRAY_DEPTH-1:0]    int_ecc_wdata_fifo_dataid_vector_last_r;
            reg                                   int_ecc_wdata_fifo_rmw_correct_last;
            reg                                   int_ecc_wdata_fifo_rmw_correct_last_r;
            reg                                   int_ecc_wdata_fifo_rmw_partial_last;
            reg                                   int_ecc_wdata_fifo_rmw_partial_last_r;
            
            // Determine first ecc_wdata_fifo_* info
            //*************************************************************************************************//
            //            ecc_wdata_fifo_read                                                                  //
            //*************************************************************************************************//
            // Indicate when to read from write data buffer
            // based on burst_gen signals
            always @(*)
            begin
                if (smallest_afi_wlat_eq_0)
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_read_first = 1'b1;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_read_first = 1'b0;
                    end
                end
                else
                begin
                    if (smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x && smallest_doing_write_pipe_eq_afi_wlat_minus_x)
                    begin
                        int_ecc_wdata_fifo_read_first = 1'b1;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_read_first = 1'b0;
                    end
                end
            end
            
            // Registered output
            always @(posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_read_first_r <= 1'b0;
                end
                else
                begin
                    int_ecc_wdata_fifo_read_first_r <= int_ecc_wdata_fifo_read_first;
                end
            end
            
            // Determine write data buffer read signal based on output_regd info
            // output_regd info is derived based on afi_wlat value
            assign ecc_wdata_fifo_read_first = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_read_first_r : int_ecc_wdata_fifo_read_first;
            
            // Registered output
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    ecc_wdata_fifo_read_first_r <= 1'b0;
                end
                else
                begin
                    ecc_wdata_fifo_read_first_r <= ecc_wdata_fifo_read_first;
                end
            end
            
            //*************************************************************************************************//
            //            ecc_wdata_fifo_dataid/dataid_vector                                                  //
            //*************************************************************************************************//
            // Dataid generation to write buffer, to indicate which wdata should be passed to AFI
            always @(*)
            begin
                if (smallest_afi_wlat_eq_0)
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_dataid_first        = dataid;
                        int_ecc_wdata_fifo_dataid_vector_first = dataid_vector;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_dataid_first        = {(CFG_DATA_ID_WIDTH){1'b0}};
                        int_ecc_wdata_fifo_dataid_vector_first = {(CFG_DATAID_ARRAY_DEPTH){1'b0}};
                    end
                end
                else
                begin
                    if (smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x && smallest_doing_write_pipe_eq_afi_wlat_minus_x)
                    begin
                        int_ecc_wdata_fifo_dataid_first        = smallest_dataid_pipe_eq_afi_wlat_minus_x       ;
                        int_ecc_wdata_fifo_dataid_vector_first = smallest_dataid_vector_pipe_eq_afi_wlat_minus_x;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_dataid_first        = {(CFG_DATA_ID_WIDTH){1'b0}};
                        int_ecc_wdata_fifo_dataid_vector_first = {(CFG_DATAID_ARRAY_DEPTH){1'b0}};
                    end
                end
            end
            
            // Registered output
            always @ (posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (~ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_dataid_first_r        <= 0;
                    int_ecc_wdata_fifo_dataid_vector_first_r <= 0;
                end
                else
                begin
                    int_ecc_wdata_fifo_dataid_first_r        <= int_ecc_wdata_fifo_dataid_first       ;
                    int_ecc_wdata_fifo_dataid_vector_first_r <= int_ecc_wdata_fifo_dataid_vector_first;
                end
            end
            
            assign ecc_wdata_fifo_dataid_first        = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_dataid_first_r        : int_ecc_wdata_fifo_dataid_first       ;
            assign ecc_wdata_fifo_dataid_vector_first = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_dataid_vector_first_r : int_ecc_wdata_fifo_dataid_vector_first;
            
            //*************************************************************************************************//
            //            ecc_wdata_fifo_rmw_correct/partial                                                   //
            //*************************************************************************************************//
            // Read modify write info logic
            always @(*)
            begin
                if (smallest_afi_wlat_eq_0)
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_rmw_correct_first = int_do_rmw_correct;
                        int_ecc_wdata_fifo_rmw_partial_first = int_do_rmw_partial;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_rmw_correct_first = 1'b0;
                        int_ecc_wdata_fifo_rmw_partial_first = 1'b0;
                    end
                end
                else
                begin
                    if (smallest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x && smallest_doing_write_pipe_eq_afi_wlat_minus_x)
                    begin
                        int_ecc_wdata_fifo_rmw_correct_first = smallest_rmw_correct_pipe_eq_afi_wlat_minus_x;
                        int_ecc_wdata_fifo_rmw_partial_first = smallest_rmw_partial_pipe_eq_afi_wlat_minus_x;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_rmw_correct_first = 1'b0;
                        int_ecc_wdata_fifo_rmw_partial_first = 1'b0;
                    end
                end
            end
            
            always @ (posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (~ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_rmw_correct_first_r <= 0;
                    int_ecc_wdata_fifo_rmw_partial_first_r <= 0;
                end
                else
                begin
                    int_ecc_wdata_fifo_rmw_correct_first_r <= int_ecc_wdata_fifo_rmw_correct_first;
                    int_ecc_wdata_fifo_rmw_partial_first_r <= int_ecc_wdata_fifo_rmw_partial_first;
                end
            end
            
            assign ecc_wdata_fifo_rmw_correct_first = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_rmw_correct_first_r : int_ecc_wdata_fifo_rmw_correct_first;
            assign ecc_wdata_fifo_rmw_partial_first = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_rmw_partial_first_r : int_ecc_wdata_fifo_rmw_partial_first;
            
            // Determine last ecc_wdata_fifo_* info
            //*************************************************************************************************//
            //            ecc_wdata_fifo_read                                                                  //
            //*************************************************************************************************//
            // Indicate when to read from write data buffer
            // based on burst_gen signals
            always @(*)
            begin
                if (largest_afi_wlat_eq_0)
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_read_last = 1'b1;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_read_last = 1'b0;
                    end
                end
                else
                begin
                    if (largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x && largest_doing_write_pipe_eq_afi_wlat_minus_x)
                    begin
                        int_ecc_wdata_fifo_read_last = 1'b1;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_read_last = 1'b0;
                    end
                end
            end
            
            // Registered output
            always @(posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_read_last_r <= 1'b0;
                end
                else
                begin
                    int_ecc_wdata_fifo_read_last_r <= int_ecc_wdata_fifo_read_last;
                end
            end
            
            // Determine write data buffer read signal based on output_regd info
            // output_regd info is derived based on afi_wlat value
            assign ecc_wdata_fifo_read_last = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_read_last_r : int_ecc_wdata_fifo_read_last;
            
            // Registered output
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    ecc_wdata_fifo_read_last_r <= 1'b0;
                end
                else
                begin
                    ecc_wdata_fifo_read_last_r <= ecc_wdata_fifo_read_last;
                end
            end
            
            //*************************************************************************************************//
            //            ecc_wdata_fifo_dataid/dataid_vector                                                  //
            //*************************************************************************************************//
            // Dataid generation to write buffer, to indicate which wdata should be passed to AFI
            always @(*)
            begin
                if (largest_afi_wlat_eq_0)
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_dataid_last        = dataid;
                        int_ecc_wdata_fifo_dataid_vector_last = dataid_vector;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_dataid_last        = {(CFG_DATA_ID_WIDTH){1'b0}};
                        int_ecc_wdata_fifo_dataid_vector_last = {(CFG_DATAID_ARRAY_DEPTH){1'b0}};
                    end
                end
                else
                begin
                    if (largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x && largest_doing_write_pipe_eq_afi_wlat_minus_x)
                    begin
                        int_ecc_wdata_fifo_dataid_last        = largest_dataid_pipe_eq_afi_wlat_minus_x       ;
                        int_ecc_wdata_fifo_dataid_vector_last = largest_dataid_vector_pipe_eq_afi_wlat_minus_x;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_dataid_last        = {(CFG_DATA_ID_WIDTH){1'b0}};
                        int_ecc_wdata_fifo_dataid_vector_last = {(CFG_DATAID_ARRAY_DEPTH){1'b0}};
                    end
                end
            end
            
            // Registered output
            always @ (posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (~ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_dataid_last_r        <= 0;
                    int_ecc_wdata_fifo_dataid_vector_last_r <= 0;
                end
                else
                begin
                    int_ecc_wdata_fifo_dataid_last_r        <= int_ecc_wdata_fifo_dataid_last       ;
                    int_ecc_wdata_fifo_dataid_vector_last_r <= int_ecc_wdata_fifo_dataid_vector_last;
                end
            end
            
            assign ecc_wdata_fifo_dataid_last        = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_dataid_last_r        : int_ecc_wdata_fifo_dataid_last       ;
            assign ecc_wdata_fifo_dataid_vector_last = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_dataid_vector_last_r : int_ecc_wdata_fifo_dataid_vector_last;
            
            //*************************************************************************************************//
            //            ecc_wdata_fifo_rmw_correct/partial                                                   //
            //*************************************************************************************************//
            // Read modify write info logic
            always @(*)
            begin
                if (largest_afi_wlat_eq_0)
                begin
                    if (bg_rdwr_data_valid && bg_doing_write)
                    begin
                        int_ecc_wdata_fifo_rmw_correct_last = int_do_rmw_correct;
                        int_ecc_wdata_fifo_rmw_partial_last = int_do_rmw_partial;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_rmw_correct_last = 1'b0;
                        int_ecc_wdata_fifo_rmw_partial_last = 1'b0;
                    end
                end
                else
                begin
                    if (largest_rdwr_data_valid_pipe_eq_afi_wlat_minus_x && largest_doing_write_pipe_eq_afi_wlat_minus_x)
                    begin
                        int_ecc_wdata_fifo_rmw_correct_last = largest_rmw_correct_pipe_eq_afi_wlat_minus_x;
                        int_ecc_wdata_fifo_rmw_partial_last = largest_rmw_partial_pipe_eq_afi_wlat_minus_x;
                    end
                    else
                    begin
                        int_ecc_wdata_fifo_rmw_correct_last = 1'b0;
                        int_ecc_wdata_fifo_rmw_partial_last = 1'b0;
                    end
                end
            end
            
            always @ (posedge ctl_clk, negedge ctl_reset_n)
            begin
                if (~ctl_reset_n)
                begin
                    int_ecc_wdata_fifo_rmw_correct_last_r <= 0;
                    int_ecc_wdata_fifo_rmw_partial_last_r <= 0;
                end
                else
                begin
                    int_ecc_wdata_fifo_rmw_correct_last_r <= int_ecc_wdata_fifo_rmw_correct_last;
                    int_ecc_wdata_fifo_rmw_partial_last_r <= int_ecc_wdata_fifo_rmw_partial_last;
                end
            end
            
            assign ecc_wdata_fifo_rmw_correct_last = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_rmw_correct_last_r : int_ecc_wdata_fifo_rmw_correct_last;
            assign ecc_wdata_fifo_rmw_partial_last = (cfg_output_regd_for_wdata_path) ? int_ecc_wdata_fifo_rmw_partial_last_r : int_ecc_wdata_fifo_rmw_partial_last;
        end
    endgenerate
    
    // No data manipulation on wdata
    assign afi_wdata = ecc_wdata;
    
    //*************************************************************************************************//
    //            afi_dm generation logic                                                              //
    //*************************************************************************************************//
    //Why do we need ecc_dm and rdwr_data_valid to determine DM
    // ecc_dm will not get updated till we read another data from wrfifo, so we need to drive DMs based on rdwr_data_valid
    //Output registered information already backed in ecc_wdata_fifo_read
    
    // data valid one clock cycle after read
    always @(posedge ctl_clk, negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_real_wdata_valid <=  1'b0;
        end
        else
        begin
            if (CFG_WDATA_REG || CFG_ECC_ENC_REG)
                begin
                    int_real_wdata_valid <=  ecc_wdata_fifo_read_r;
                end
            else
                begin
                    int_real_wdata_valid <=  ecc_wdata_fifo_read;
                end
        end
    end
    
    generate
        genvar J;
        for (J = 0; J < CFG_MEM_IF_DM_WIDTH*CFG_DWIDTH_RATIO; J = J + 1)
        begin : F
            assign afi_dm[J]    =   ~ecc_dm[J] | ~int_real_wdata_valid;
        end
    endgenerate
    
endmodule

