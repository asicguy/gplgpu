
//altera message_off 10230 10036

`include "alt_mem_ddrx_define.iv"

module alt_mem_ddrx_rdata_path
# (
    // module parameter port list
    parameter
        CFG_LOCAL_DATA_WIDTH            = 8,
        CFG_INT_SIZE_WIDTH              = 2,
        CFG_DATA_ID_WIDTH               = 3,                // number of buckets
        CFG_LOCAL_ID_WIDTH              = 3,
        CFG_LOCAL_ADDR_WIDTH            = 32,
        CFG_BUFFER_ADDR_WIDTH           = 5,
        CFG_MEM_IF_CS_WIDTH             = 2,
        CFG_MEM_IF_BA_WIDTH             = 3,
        CFG_MEM_IF_ROW_WIDTH            = 13,
        CFG_MEM_IF_COL_WIDTH            = 10,
        CFG_MAX_READ_CMD_NUM_WIDTH      = 4,                // expected in-flight read commands at a time
        CFG_RDATA_RETURN_MODE           = "PASSTHROUGH",    // INORDER, PASSTHROUGH
        CFG_AFI_INTF_PHASE_NUM          = 2,
        CFG_ERRCMD_FIFO_ADDR_WIDTH      = 3,
        CFG_DWIDTH_RATIO                = 2,
        CFG_ECC_MULTIPLES               = 1,
        CFG_ECC_CODE_WIDTH              = 8,
        CFG_PORT_WIDTH_TYPE             = 3,
        CFG_PORT_WIDTH_ENABLE_ECC       = 1,
        CFG_PORT_WIDTH_ENABLE_AUTO_CORR = 1,
        CFG_PORT_WIDTH_ENABLE_NO_DM     = 1,
        CFG_PORT_WIDTH_BURST_LENGTH     = 5,
        CFG_PORT_WIDTH_ADDR_ORDER       = 2, 
        CFG_PORT_WIDTH_COL_ADDR_WIDTH   = 9, 
        CFG_PORT_WIDTH_ROW_ADDR_WIDTH   = 12, 
        CFG_PORT_WIDTH_BANK_ADDR_WIDTH  = 3, 
        CFG_PORT_WIDTH_CS_ADDR_WIDTH    = 2 
)
(
    // port list
    ctl_clk,
    ctl_reset_n,

    // configuration
    cfg_type,
    cfg_enable_ecc,
    cfg_enable_auto_corr,
    cfg_enable_no_dm,
    cfg_burst_length,
    cfg_addr_order,
    cfg_col_addr_width,
    cfg_row_addr_width,
    cfg_bank_addr_width,
    cfg_cs_addr_width,

    // command generator & TBP command load interface / cmd update interface
    rdatap_free_id_valid,
    rdatap_free_id_dataid,
    proc_busy,
    proc_load,
    proc_load_dataid,
    proc_read,
    proc_size,
    proc_localid,

    // input interface data channel / buffer read interface
    read_data_valid,                // data sent to either dataid_manager, or input interface
    read_data,
    read_data_error,
    read_data_localid,
    
    // Arbiter issued reads interface
    bg_do_read,
    bg_to_chipsel,
    bg_to_bank,
    bg_to_row,
    bg_to_column,
    bg_dataid,
    bg_localid,
    bg_size,
    bg_do_rmw_correct,
    bg_do_rmw_partial,

    // read data from memory interface
    ecc_rdata,
    ecc_rdatav,
    ecc_sbe,
    ecc_dbe,
    ecc_code,

    // ECC Error commands interface, to command generator
    errcmd_ready,
    errcmd_valid,
    errcmd_chipsel,
    errcmd_bank,
    errcmd_row,
    errcmd_column,
    errcmd_size,
    errcmd_localid,

    // ECC Error address interface, to ECC block
    rdatap_rcvd_addr,
    rdatap_rcvd_cmd,
    rdatap_rcvd_corr_dropped,

    // RMW fifo interface, to wdatap
    rmwfifo_data_valid,
    rmwfifo_data,
    rmwfifo_ecc_dbe,
    rmwfifo_ecc_code

);


    // -----------------------------
    // local parameter declarations
    // -----------------------------
    localparam CFG_ECC_RDATA_COUNTER_REG   = 0;                // set to 1 to improve timing

    localparam CFG_RMW_BIT_WIDTH = 1;
    localparam CFG_RMW_PARTIAL_BIT_WIDTH = 1;
    localparam CFG_PENDING_RD_FIFO_WIDTH = CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_ROW_WIDTH + CFG_MEM_IF_COL_WIDTH + CFG_LOCAL_ID_WIDTH + CFG_INT_SIZE_WIDTH + CFG_DATA_ID_WIDTH + CFG_RMW_BIT_WIDTH + CFG_RMW_PARTIAL_BIT_WIDTH;
    localparam CFG_ERRCMD_FIFO_WIDTH     = CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_ROW_WIDTH + CFG_MEM_IF_COL_WIDTH + CFG_INT_SIZE_WIDTH + CFG_LOCAL_ID_WIDTH;
    localparam CFG_INORDER_INFO_FIFO_WIDTH = CFG_INT_SIZE_WIDTH+CFG_LOCAL_ID_WIDTH;
    localparam integer CFG_DATAID_ARRAY_DEPTH = 2**CFG_DATA_ID_WIDTH;
    localparam CFG_RDATA_ERROR_WIDTH = 1;
    localparam CFG_IN_ORDER_BUFFER_DATA_WIDTH = CFG_LOCAL_DATA_WIDTH + CFG_RDATA_ERROR_WIDTH;
    localparam CFG_MAX_READ_CMD_NUM = 2**CFG_MAX_READ_CMD_NUM_WIDTH;

    localparam MIN_COL              =   8;
    localparam MIN_ROW              =   12;
    localparam MIN_BANK             =   2;
    localparam MIN_CS               =   1;
    localparam MAX_COL              = CFG_MEM_IF_COL_WIDTH;
    localparam MAX_ROW              = CFG_MEM_IF_ROW_WIDTH;
    localparam MAX_BANK             = CFG_MEM_IF_BA_WIDTH;
    localparam MAX_CS               = CFG_MEM_IF_CS_WIDTH;

    localparam CFG_IGNORE_NUM_BITS_COL          = log2 (CFG_DWIDTH_RATIO);
    localparam CFG_LOCAL_ADDR_BITSELECT_WIDTH   = log2 (CFG_LOCAL_ADDR_WIDTH);

    integer j,k,m,n;


    // -----------------------------
    // port declaration
    // -----------------------------

    input   ctl_clk;
    input   ctl_reset_n;
    
    // configuration
    input   [CFG_PORT_WIDTH_TYPE- 1:0]              cfg_type;
    input   [CFG_PORT_WIDTH_ENABLE_ECC-1:0]         cfg_enable_ecc;
    input   [CFG_PORT_WIDTH_ENABLE_AUTO_CORR-1:0]   cfg_enable_auto_corr;
    input   [CFG_PORT_WIDTH_ENABLE_NO_DM-1:0]       cfg_enable_no_dm;
    input   [CFG_PORT_WIDTH_BURST_LENGTH-1:0]       cfg_burst_length;

    input  [CFG_PORT_WIDTH_ADDR_ORDER      - 1 : 0] cfg_addr_order;
    input  [CFG_PORT_WIDTH_COL_ADDR_WIDTH  - 1 : 0] cfg_col_addr_width;
    input  [CFG_PORT_WIDTH_ROW_ADDR_WIDTH  - 1 : 0] cfg_row_addr_width;
    input  [CFG_PORT_WIDTH_BANK_ADDR_WIDTH - 1 : 0] cfg_bank_addr_width;
    input  [CFG_PORT_WIDTH_CS_ADDR_WIDTH   - 1 : 0] cfg_cs_addr_width;
        
    // command generator & TBP command load interface / cmd update interface
    output                              rdatap_free_id_valid;
    output  [CFG_DATA_ID_WIDTH-1:0]     rdatap_free_id_dataid;
    input                               proc_busy;
    input                               proc_load;
    input                               proc_load_dataid;
    input                               proc_read;
    input   [CFG_INT_SIZE_WIDTH-1:0]    proc_size;
    input   [CFG_LOCAL_ID_WIDTH-1:0]    proc_localid;

    // input interface data channel
    output                              read_data_valid;                
    output  [CFG_LOCAL_DATA_WIDTH-1:0]  read_data;
    output                              read_data_error;
    output  [CFG_LOCAL_ID_WIDTH-1:0]    read_data_localid;

    // Arbiter issued reads interface
    input   [CFG_AFI_INTF_PHASE_NUM-1:0]                            bg_do_read;
    input   [CFG_AFI_INTF_PHASE_NUM-1:0]                            bg_do_rmw_correct;
    input   [CFG_AFI_INTF_PHASE_NUM-1:0]                            bg_do_rmw_partial;
    input   [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_CS_WIDTH  ) -1:0]   bg_to_chipsel;
    input   [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_BA_WIDTH  ) -1:0]   bg_to_bank;
    input   [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_ROW_WIDTH ) -1:0]   bg_to_row;
    input   [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_COL_WIDTH ) -1:0]   bg_to_column;
    input   [(                       CFG_DATA_ID_WIDTH    ) -1:0]   bg_dataid;
    input   [(                       CFG_LOCAL_ID_WIDTH   ) -1:0]   bg_localid;
    input   [(                       CFG_INT_SIZE_WIDTH   ) -1:0]   bg_size;

    // read data from memory interface
    input   [CFG_LOCAL_DATA_WIDTH-1:0]                       ecc_rdata;
    input                                                    ecc_rdatav;
    input   [CFG_ECC_MULTIPLES - 1 : 0]                      ecc_sbe;
    input   [CFG_ECC_MULTIPLES - 1 : 0]                      ecc_dbe;
    input   [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] ecc_code;

    // ECC Error commands interface, to command generator
    input                                 errcmd_ready;
    output                                errcmd_valid;
    output    [CFG_MEM_IF_CS_WIDTH-1:0]   errcmd_chipsel;
    output    [CFG_MEM_IF_BA_WIDTH-1:0]   errcmd_bank;
    output    [CFG_MEM_IF_ROW_WIDTH-1:0]  errcmd_row;
    output    [CFG_MEM_IF_COL_WIDTH-1:0]  errcmd_column;
    output    [CFG_INT_SIZE_WIDTH-1:0]    errcmd_size;
    output    [CFG_LOCAL_ID_WIDTH-1:0]    errcmd_localid;

    // ECC Error address interface, to ECC block
    output  [CFG_LOCAL_ADDR_WIDTH-1:0]                      rdatap_rcvd_addr;
    output                                                  rdatap_rcvd_cmd;
    output                                                  rdatap_rcvd_corr_dropped;

    // RMW fifo interface, to wdatap
    output                                                   rmwfifo_data_valid; 
    output  [CFG_LOCAL_DATA_WIDTH-1:0]                       rmwfifo_data;
    output  [CFG_ECC_MULTIPLES - 1 : 0]                      rmwfifo_ecc_dbe;
    output  [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rmwfifo_ecc_code;

    // -----------------------------
    // port type declaration
    // -----------------------------

    wire    ctl_clk;
    wire    ctl_reset_n;

    // configuration
    wire    [CFG_PORT_WIDTH_TYPE- 1:0]                  cfg_type;
    wire    [CFG_PORT_WIDTH_ENABLE_ECC-1:0]             cfg_enable_ecc;
    wire    [CFG_PORT_WIDTH_ENABLE_AUTO_CORR-1:0]       cfg_enable_auto_corr;
    wire    [CFG_PORT_WIDTH_BURST_LENGTH-1:0]           cfg_burst_length;

    wire  [CFG_PORT_WIDTH_ADDR_ORDER      - 1 : 0] cfg_addr_order;
    wire  [CFG_PORT_WIDTH_COL_ADDR_WIDTH  - 1 : 0] cfg_col_addr_width;
    wire  [CFG_PORT_WIDTH_ROW_ADDR_WIDTH  - 1 : 0] cfg_row_addr_width;
    wire  [CFG_PORT_WIDTH_BANK_ADDR_WIDTH - 1 : 0] cfg_bank_addr_width;
    wire  [CFG_PORT_WIDTH_CS_ADDR_WIDTH   - 1 : 0] cfg_cs_addr_width;
        
    // command generator & TBP command load interface / cmd update interface
    reg                                 rdatap_free_id_valid;
    reg     [CFG_DATA_ID_WIDTH-1:0]     rdatap_free_id_dataid;
    wire                               proc_busy;
    wire                               proc_load;
    wire                               proc_load_dataid;
    wire                               proc_read;
    wire   [CFG_INT_SIZE_WIDTH-1:0]    proc_size;
    wire   [CFG_LOCAL_ID_WIDTH-1:0]    proc_localid;

    // input interface data channel
    reg                              read_data_valid;                
    reg  [CFG_LOCAL_DATA_WIDTH-1:0]  read_data;
    reg                              read_data_error;
    reg  [CFG_LOCAL_ID_WIDTH-1:0]    read_data_localid;

    // Arbiter issued reads interface
    wire  [CFG_AFI_INTF_PHASE_NUM-1:0]                             bg_do_read;
    wire  [CFG_AFI_INTF_PHASE_NUM-1:0]                             bg_do_rmw_correct;
    wire  [CFG_AFI_INTF_PHASE_NUM-1:0]                             bg_do_rmw_partial;
    wire  [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_CS_WIDTH  ) -1:0]    bg_to_chipsel;
    wire  [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_BA_WIDTH  ) -1:0]    bg_to_bank;
    wire  [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_ROW_WIDTH ) -1:0]    bg_to_row;
    wire  [(CFG_AFI_INTF_PHASE_NUM*CFG_MEM_IF_COL_WIDTH ) -1:0]    bg_to_column;
    wire  [(                       CFG_DATA_ID_WIDTH    ) -1:0]    bg_dataid;
    wire  [(                       CFG_LOCAL_ID_WIDTH   ) -1:0]    bg_localid;
    wire  [(                       CFG_INT_SIZE_WIDTH   ) -1:0]    bg_size;

    reg   [CFG_AFI_INTF_PHASE_NUM-1:0]                             int_bg_do_read;
    reg   [CFG_AFI_INTF_PHASE_NUM-1:0]                             int_bg_do_rmw_correct;
    reg   [CFG_AFI_INTF_PHASE_NUM-1:0]                             int_bg_do_rmw_partial;
    reg   [CFG_MEM_IF_CS_WIDTH   -1:0]                             int_bg_to_chipsel[CFG_AFI_INTF_PHASE_NUM-1:0];
    reg   [CFG_MEM_IF_BA_WIDTH   -1:0]                             int_bg_to_bank   [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg   [CFG_MEM_IF_ROW_WIDTH  -1:0]                             int_bg_to_row    [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg   [CFG_MEM_IF_COL_WIDTH  -1:0]                             int_bg_to_column [CFG_AFI_INTF_PHASE_NUM-1:0];
    reg   [CFG_DATA_ID_WIDTH     -1:0]                             int_bg_dataid;
    reg   [CFG_LOCAL_ID_WIDTH    -1:0]                             int_bg_localid;
    reg   [CFG_INT_SIZE_WIDTH    -1:0]                             int_bg_size;

    // read data from memory interface
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                       ecc_rdata;
    wire                                                     ecc_rdatav;
    wire    [CFG_ECC_MULTIPLES- 1 : 0]                       ecc_sbe;
    wire    [CFG_ECC_MULTIPLES- 1 : 0]                       ecc_dbe;
    wire    [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] ecc_code;

    // ECC Error commands interface, to command generator
    wire                                errcmd_ready;
    wire                                errcmd_valid;
    wire    [CFG_MEM_IF_CS_WIDTH-1:0]   errcmd_chipsel;
    wire    [CFG_MEM_IF_BA_WIDTH-1:0]   errcmd_bank;
    wire    [CFG_MEM_IF_ROW_WIDTH-1:0]  errcmd_row;
    wire    [CFG_MEM_IF_COL_WIDTH-1:0]  errcmd_column;
    wire    [CFG_INT_SIZE_WIDTH-1:0]    errcmd_size;
    wire    [CFG_LOCAL_ID_WIDTH-1:0]    errcmd_localid;

    // RMW fifo interface, to wdatap
    wire                                                     rmwfifo_data_valid; 
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                       rmwfifo_data;
    wire    [CFG_ECC_MULTIPLES- 1 : 0]                       rmwfifo_ecc_dbe;
    wire    [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rmwfifo_ecc_code;

    reg                                                     rdatap_rcvd_cmd;
    reg                                                     rdatap_rcvd_corr_dropped;
    // -----------------------------
    // signal declaration
    // -----------------------------

    wire[CFG_INT_SIZE_WIDTH-1:0]                cfg_max_cmd_burstcount;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH -1 : 0] cfg_addr_bitsel_chipsel;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH -1 : 0] cfg_addr_bitsel_bank;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH -1 : 0] cfg_addr_bitsel_row;

    wire                                cmdload_valid;
    reg  [CFG_MAX_READ_CMD_NUM_WIDTH-1:0]   cmd_counter;
    reg                                 cmd_counter_full;
    wire                                cmd_counter_load;

    wire                                free_id_get_ready;
    wire                                free_id_valid;
    wire    [CFG_DATA_ID_WIDTH-1:0]     free_id_dataid;
    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]free_id_dataid_vector;
    wire                                allocated_put_ready;
    wire                                allocated_put_valid;
    wire                                int_free_id_valid;

    wire [CFG_PENDING_RD_FIFO_WIDTH-1:0] pfifo_input;
    wire [CFG_PENDING_RD_FIFO_WIDTH-1:0] pfifo_output;
    wire                                 pfifo_output_valid;
    wire                                 pfifo_input_ready;

    wire                                 rdata_burst_complete;
    reg                                  rdata_burst_complete_r;

    reg                                  rout_data_valid;                // rout_data sent to dataid_manager
    reg                                  rout_cmd_valid;                 // rout_cmd sent to dataid_manager
    reg                                  rout_data_rmwfifo_valid;        // rout_data sent to rmwfifo
    reg                                  rout_cmd_rmwfifo_valid;         // rout_cmd  sent to rmwfifo
    wire                                 rout_rmw_rmwpartial;
    reg                                  rout_data_error;
    reg                                  rout_sbecmd_valid;
    reg                                  rout_errnotify_valid;
    wire [CFG_LOCAL_DATA_WIDTH-1:0]      rout_data;
    wire [CFG_DATA_ID_WIDTH-1:0]         rout_data_dataid;
    wire [CFG_LOCAL_ID_WIDTH-1:0]        rout_data_localid;
    wire [CFG_INT_SIZE_WIDTH-1:0]        rout_data_burstcount;
    wire [CFG_ECC_MULTIPLES- 1 : 0]      rout_ecc_dbe;
    wire [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rout_ecc_code;


    reg                                 pfifo_input_do_read;
    reg                                 pfifo_input_rmw;
    reg                                 pfifo_input_rmw_partial;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]   pfifo_input_chipsel;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]   pfifo_input_bank;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]  pfifo_input_row;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]  pfifo_input_column;
    reg     [CFG_DATA_ID_WIDTH-1:0]     pfifo_input_dataid;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]    pfifo_input_localid;
    reg     [CFG_INT_SIZE_WIDTH-1:0]    pfifo_input_size;

    reg                                 mux_pfifo_input_rmw             [CFG_AFI_INTF_PHASE_NUM -1 : 0]; 
    reg                                 mux_pfifo_input_rmw_partial     [CFG_AFI_INTF_PHASE_NUM -1 : 0];
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]   mux_pfifo_input_chipsel         [CFG_AFI_INTF_PHASE_NUM -1 : 0];
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]   mux_pfifo_input_bank            [CFG_AFI_INTF_PHASE_NUM -1 : 0];
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]  mux_pfifo_input_row             [CFG_AFI_INTF_PHASE_NUM -1 : 0];
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]  mux_pfifo_input_column          [CFG_AFI_INTF_PHASE_NUM -1 : 0];

    wire                                pfifo_rmw;
    wire                                pfifo_rmw_partial;
    wire    [CFG_MEM_IF_CS_WIDTH-1:0]   pfifo_chipsel;
    wire    [CFG_MEM_IF_BA_WIDTH-1:0]   pfifo_bank;
    wire    [CFG_MEM_IF_ROW_WIDTH-1:0]  pfifo_row;
    wire    [CFG_MEM_IF_COL_WIDTH-1:0]  pfifo_column;
    wire    [CFG_MEM_IF_COL_WIDTH-1:0]  pfifo_column_burst_aligned;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]   pfifo_chipsel_r;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]   pfifo_bank_r;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]  pfifo_row_r;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]  pfifo_column_r;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]  pfifo_column_burst_aligned_r;
    wire    [CFG_DATA_ID_WIDTH-1:0]     pfifo_dataid;
    wire    [CFG_LOCAL_ID_WIDTH-1:0]    pfifo_localid;
    wire    [CFG_INT_SIZE_WIDTH-1:0]    pfifo_size;
    reg     [CFG_LOCAL_ADDR_WIDTH-1:0]  pfifo_addr;

    wire    [CFG_INT_SIZE_WIDTH-1:0]    ecc_rdata_current_count;
    reg     [CFG_INT_SIZE_WIDTH-1:0]    ecc_rdata_counter;
    wire    [CFG_INT_SIZE_WIDTH-1:0]    ecc_rdatavalid_count;
    wire    [CFG_INT_SIZE_WIDTH-1:0]    ecc_rdata_burst_complete_count;
    reg                                 ecc_sbe_cmd_detected;
    reg                                 ecc_dbe_cmd_detected;

    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]                dataid_array_valid;
    reg     [CFG_DATAID_ARRAY_DEPTH-1:0]                dataid_array_data_ready;
    reg     [CFG_BUFFER_ADDR_WIDTH-1:0]                 dataid_array_burstcount         [CFG_DATAID_ARRAY_DEPTH-1:0];
    reg     [CFG_LOCAL_ID_WIDTH-1:0]                    dataid_array_localid            [CFG_DATAID_ARRAY_DEPTH-1:0];

    wire                                                inordr_id_data_complete;
    reg                                                 inordr_id_data_complete_r;
    wire                                                inordr_id_valid;
    wire                                                inordr_id_list_valid;
    wire                                                inordr_read_data_valid;
    reg                                                 inordr_read_data_valid_r;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                  inordr_read_data;
    wire                                                inordr_read_data_error;
    wire    [CFG_DATA_ID_WIDTH-1:0]                     inordr_id_dataid;
    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]                inordr_id_dataid_vector;
    wire    [CFG_LOCAL_ID_WIDTH-1:0]                    inordr_id_localid;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]                    inordr_id_localid_r;
    reg     [CFG_INT_SIZE_WIDTH-1:0]                    inordr_data_counter;
    reg     [CFG_INT_SIZE_WIDTH-1:0]                    inordr_data_counter_plus_1;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                    inordr_next_data_counter;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                    inordr_id_expected_burstcount;
    reg     [CFG_DATAID_ARRAY_DEPTH-1:0]                mux_inordr_data_ready;

    wire                                                inordr_info_input_ready;
    wire                                                inordr_info_output_valid;
    wire    [CFG_INORDER_INFO_FIFO_WIDTH-1:0]           inordr_info_input;
    wire    [CFG_INORDER_INFO_FIFO_WIDTH-1:0]           inordr_info_output;

    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]                 buffwrite_address;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                    buffwrite_offset;
    wire    [CFG_IN_ORDER_BUFFER_DATA_WIDTH-1:0]        buffwrite_data;
    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]                 buffread_address;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                    buffread_offset;
    wire    [CFG_IN_ORDER_BUFFER_DATA_WIDTH-1:0]        buffread_data;

    wire                                                int_ecc_sbe;
    wire                                                int_ecc_dbe;

    wire                                                errcmd_fifo_in_cmddropped;
    reg                                                 errcmd_fifo_in_cmddropped_r;
    wire                                                errcmd_fifo_in_ready;
    wire                                                errcmd_fifo_in_valid;
    wire    [CFG_ERRCMD_FIFO_WIDTH-1:0]                 errcmd_fifo_in;
    wire    [CFG_ERRCMD_FIFO_WIDTH-1:0]                 errcmd_fifo_out;

    // -----------------------------
    // module definition
    // -----------------------------

    //
    // READ DATA MAIN OUTPUT MUX
    //

    generate
    begin : gen_rdata_output_mux
        if (CFG_RDATA_RETURN_MODE == "PASSTHROUGH")
        begin
            always @ (*) 
            begin
                read_data_valid         = rout_data_valid;
                read_data               = rout_data;
                read_data_error         = rout_data_error;
                read_data_localid       = rout_data_localid;

                rdatap_free_id_valid    = ~cmd_counter_full;
                rdatap_free_id_dataid   = 0;
            end
        end
        else
        begin
            always @ (*) 
            begin
                read_data_valid         = inordr_read_data_valid_r;
                read_data               = inordr_read_data;
                read_data_error         = inordr_read_data_error;
                read_data_localid       = inordr_id_localid_r;

                rdatap_free_id_valid    = ~cmd_counter_full & free_id_valid;
                rdatap_free_id_dataid   = free_id_dataid;
            end
        end
    end
    endgenerate


    // 
    // RDATA_ROUTER
    //

    // mux to select correct burst gen output phase for read command
    // assumes bg_do_read only asserted for 1 of the CFG_AFI_INTF_PHASE_NUM
    
    genvar rdp_k;
    generate
        for (rdp_k = 0; rdp_k < CFG_AFI_INTF_PHASE_NUM; rdp_k = rdp_k + 1) 
        begin : gen_bg_afi_signal_decode

            always @ (*) 
            begin

                int_bg_do_read              [rdp_k] = bg_do_read        [rdp_k];     
                int_bg_do_rmw_correct       [rdp_k] = bg_do_rmw_correct [rdp_k]; 
                int_bg_do_rmw_partial       [rdp_k] = bg_do_rmw_partial [rdp_k]; 

                int_bg_to_chipsel           [rdp_k] = bg_to_chipsel [(((rdp_k+1)*CFG_MEM_IF_CS_WIDTH )-1):(rdp_k*CFG_MEM_IF_CS_WIDTH )]; 
                int_bg_to_bank              [rdp_k] = bg_to_bank    [(((rdp_k+1)*CFG_MEM_IF_BA_WIDTH )-1):(rdp_k*CFG_MEM_IF_BA_WIDTH )]; 
                int_bg_to_row               [rdp_k] = bg_to_row     [(((rdp_k+1)*CFG_MEM_IF_ROW_WIDTH)-1):(rdp_k*CFG_MEM_IF_ROW_WIDTH)]; 
                int_bg_to_column            [rdp_k] = bg_to_column  [(((rdp_k+1)*CFG_MEM_IF_COL_WIDTH)-1):(rdp_k*CFG_MEM_IF_COL_WIDTH)]; 

            end

        end
    endgenerate

    always @ (*) 
    begin
           int_bg_dataid                       = bg_dataid;
           int_bg_localid                      = bg_localid; 
           int_bg_size                         = bg_size;    
    end


    always @ (*) 
    begin
       mux_pfifo_input_rmw             [0]     = (int_bg_do_read [0]) ?  int_bg_do_rmw_correct  [0] : 0;
       mux_pfifo_input_rmw_partial     [0]     = (int_bg_do_read [0]) ?  int_bg_do_rmw_partial  [0] : 0;
       mux_pfifo_input_chipsel         [0]     = (int_bg_do_read [0]) ?  int_bg_to_chipsel      [0] : 0;
       mux_pfifo_input_bank            [0]     = (int_bg_do_read [0]) ?  int_bg_to_bank         [0] : 0;
       mux_pfifo_input_row             [0]     = (int_bg_do_read [0]) ?  int_bg_to_row          [0] : 0;
       mux_pfifo_input_column          [0]     = (int_bg_do_read [0]) ?  int_bg_to_column       [0] : 0;
    end
    
    genvar rdp_j;
    generate
        for (rdp_j = 1; rdp_j < CFG_AFI_INTF_PHASE_NUM; rdp_j = rdp_j + 1) 
        begin : gen_bg_afi_phase_mux
            always @ (*) 
            begin
                mux_pfifo_input_rmw             [rdp_j]     = mux_pfifo_input_rmw             [rdp_j - 1] | ((int_bg_do_read [rdp_j]) ? int_bg_do_rmw_correct  [rdp_j] : 0);
                mux_pfifo_input_rmw_partial     [rdp_j]     = mux_pfifo_input_rmw_partial     [rdp_j - 1] | ((int_bg_do_read [rdp_j]) ? int_bg_do_rmw_partial  [rdp_j] : 0);
                mux_pfifo_input_chipsel         [rdp_j]     = mux_pfifo_input_chipsel         [rdp_j - 1] | ((int_bg_do_read [rdp_j]) ? int_bg_to_chipsel      [rdp_j] : 0);
                mux_pfifo_input_bank            [rdp_j]     = mux_pfifo_input_bank            [rdp_j - 1] | ((int_bg_do_read [rdp_j]) ? int_bg_to_bank         [rdp_j] : 0);
                mux_pfifo_input_row             [rdp_j]     = mux_pfifo_input_row             [rdp_j - 1] | ((int_bg_do_read [rdp_j]) ? int_bg_to_row          [rdp_j] : 0);
                mux_pfifo_input_column          [rdp_j]     = mux_pfifo_input_column          [rdp_j - 1] | ((int_bg_do_read [rdp_j]) ? int_bg_to_column       [rdp_j] : 0);
            end
        end
    endgenerate    

     always @ (*) 
     begin
        pfifo_input_do_read         = |int_bg_do_read;

        pfifo_input_rmw             = mux_pfifo_input_rmw             [CFG_AFI_INTF_PHASE_NUM-1]; 
        pfifo_input_rmw_partial     = mux_pfifo_input_rmw_partial     [CFG_AFI_INTF_PHASE_NUM-1];
        pfifo_input_chipsel         = mux_pfifo_input_chipsel         [CFG_AFI_INTF_PHASE_NUM-1];
        pfifo_input_bank            = mux_pfifo_input_bank            [CFG_AFI_INTF_PHASE_NUM-1];
        pfifo_input_row             = mux_pfifo_input_row             [CFG_AFI_INTF_PHASE_NUM-1];
        pfifo_input_column          = mux_pfifo_input_column          [CFG_AFI_INTF_PHASE_NUM-1];
        pfifo_input_dataid          = int_bg_dataid                                             ;
        pfifo_input_localid         = int_bg_localid                                            ;
        pfifo_input_size            = int_bg_size                                               ;
     end



    // format for pfifo_input & pfifo_output must be same
    assign pfifo_input = {pfifo_input_chipsel, pfifo_input_bank, pfifo_input_row, pfifo_input_column, pfifo_input_localid, pfifo_input_size, pfifo_input_rmw, pfifo_input_rmw_partial, pfifo_input_dataid};
    assign {pfifo_chipsel, pfifo_bank, pfifo_row, pfifo_column, pfifo_localid, pfifo_size, pfifo_rmw, pfifo_rmw_partial, pfifo_dataid} = pfifo_output;

    // read data for this command has been fully received from memory
    assign rdata_burst_complete = (pfifo_output_valid & (pfifo_size == ecc_rdata_current_count)) ? 1 : 0;

    alt_mem_ddrx_fifo
    #(
        .CTL_FIFO_DATA_WIDTH (CFG_PENDING_RD_FIFO_WIDTH),
        .CTL_FIFO_ADDR_WIDTH (CFG_MAX_READ_CMD_NUM_WIDTH)
    )
    pending_rd_fifo
    (
     .ctl_clk            (ctl_clk),
     .ctl_reset_n        (ctl_reset_n),

     .get_ready          (rdata_burst_complete),
     .get_valid          (pfifo_output_valid),
     .get_data           (pfifo_output),   

     .put_ready          (pfifo_input_ready),                      // no back-pressure allowed
     .put_valid          (pfifo_input_do_read),    
     .put_data           (pfifo_input)
    );


    assign cmd_counter_load     = ~proc_busy & proc_load & proc_read;
    assign cmdload_valid        = cmd_counter_load & proc_load_dataid;

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            cmd_counter      <= 0;
            cmd_counter_full <= 1'b0;
        end
        else
        begin

            if (cmd_counter_load & rdata_burst_complete)
            begin
                cmd_counter      <= cmd_counter;
                cmd_counter_full <= cmd_counter_full;
            end
            else if (cmd_counter_load)
            begin
                cmd_counter <= cmd_counter + 1;
                
                if (cmd_counter == {{(CFG_MAX_READ_CMD_NUM_WIDTH - 1){1'b1}}, 1'b0}) // when cmd counter is counting up to all_ones
                begin
                    cmd_counter_full <= 1'b1;
                end
                else
                begin
                    cmd_counter_full <= 1'b0;
                end
            end
            else if (rdata_burst_complete)
            begin
                cmd_counter      <= cmd_counter - 1;
                cmd_counter_full <= 1'b0;
            end
        end
    end

    assign rout_data            = ecc_rdata;
    assign rout_data_dataid     = pfifo_dataid;
    assign rout_data_localid    = pfifo_localid;
    assign rout_data_burstcount = ecc_rdata_current_count;
    assign rout_rmw_rmwpartial  = (pfifo_rmw | pfifo_rmw_partial);
    assign rout_ecc_dbe         = ecc_dbe;
    assign rout_ecc_code        = ecc_code;

    always @ (*) 
    begin
        //rout_data_valid         = 0;
        //rout_cmd_valid          = 0;
        rout_data_rmwfifo_valid = 0;
        rout_cmd_rmwfifo_valid  = 0;
        rout_sbecmd_valid       = 0;
        rout_data_error         = 0;
        rout_errnotify_valid    = 0;

        
        if (~cfg_enable_ecc & ~cfg_enable_no_dm)
        begin
            rout_data_valid = ecc_rdatav;
            rout_cmd_valid = rout_data_valid & rdata_burst_complete;
        end
        else
        begin

            rout_data_rmwfifo_valid = ecc_rdatav & rout_rmw_rmwpartial;
            rout_data_valid         = ecc_rdatav & ~rout_rmw_rmwpartial;
            rout_cmd_valid          = rout_data_valid & rdata_burst_complete;

            rout_cmd_rmwfifo_valid = rout_data_rmwfifo_valid & rdata_burst_complete;


            rout_data_error = int_ecc_dbe;

            rout_errnotify_valid =  ecc_rdatav & ( int_ecc_sbe | int_ecc_dbe );

            if (cfg_enable_auto_corr)
            begin
                rout_sbecmd_valid =  rout_cmd_valid & (ecc_sbe_cmd_detected | int_ecc_sbe);
            end

        end
        
    end

    
    // rmwfifo interface
    assign rmwfifo_data_valid           = rout_data_rmwfifo_valid;
    assign rmwfifo_data                 = rout_data;
    assign rmwfifo_ecc_dbe              = rout_ecc_dbe;
    assign rmwfifo_ecc_code             = rout_ecc_code;


    // ecc_sbe_cmd_detected 
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            ecc_sbe_cmd_detected <= 0;            
            ecc_dbe_cmd_detected <= 0;            
        end
        else
        begin
            if (rdata_burst_complete)
            begin
                ecc_sbe_cmd_detected <= 0;
                ecc_dbe_cmd_detected <= 0;
            end
            else if (int_ecc_sbe)
            begin
                ecc_sbe_cmd_detected <= 1;
            end
            else if (int_ecc_dbe)
            begin
                ecc_dbe_cmd_detected <= 1;
            end
        end
    end

    assign int_ecc_sbe = ecc_rdatav & (|ecc_sbe);
    assign int_ecc_dbe = ecc_rdatav & (|ecc_dbe);

    //
    // ECC_RDATA counter
    //

    assign ecc_rdata_current_count = (CFG_ECC_RDATA_COUNTER_REG) ? ecc_rdata_counter : ecc_rdatavalid_count;
    assign ecc_rdatavalid_count = (ecc_rdatav) ? ecc_rdata_counter + 1 : ecc_rdata_counter;
    assign ecc_rdata_burst_complete_count = pfifo_size;

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            ecc_rdata_counter <= 0;
        end
        else
        begin

            if (rdata_burst_complete)
            begin
                ecc_rdata_counter <= ecc_rdatavalid_count - ecc_rdata_burst_complete_count;
            end
            else
            begin
                ecc_rdata_counter <= ecc_rdatavalid_count;
            end

        end
    end

    assign errcmd_fifo_in_valid = rout_sbecmd_valid;
    assign errcmd_fifo_in = {pfifo_chipsel, pfifo_bank, pfifo_row, pfifo_column_burst_aligned, cfg_max_cmd_burstcount, pfifo_localid};
    assign {errcmd_chipsel, errcmd_bank, errcmd_row, errcmd_column, errcmd_size, errcmd_localid} = errcmd_fifo_out;
    assign errcmd_fifo_in_cmddropped = ~errcmd_fifo_in_ready & errcmd_fifo_in_valid;
    assign cfg_max_cmd_burstcount = (cfg_burst_length / CFG_DWIDTH_RATIO);

    // DDR3, pfifo_column_burst_aligned is burst length 8 aligned
    // DDR2, pfifo_column is already burst aligned
    assign pfifo_column_burst_aligned = (cfg_type == `MMR_TYPE_DDR3) ?  {pfifo_column[(CFG_MEM_IF_COL_WIDTH-1):3],{3{1'b0}} } : pfifo_column;

    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            pfifo_chipsel_r              <= 0;
            pfifo_bank_r                 <= 0;
            pfifo_row_r                  <= 0;
            pfifo_column_r               <= 0;
            pfifo_column_burst_aligned_r <= 0;
        end
        else
        begin
            pfifo_chipsel_r              <= pfifo_chipsel             ;
            pfifo_bank_r                 <= pfifo_bank                ;
            pfifo_row_r                  <= pfifo_row                 ;
            pfifo_column_r               <= pfifo_column              ;
            pfifo_column_burst_aligned_r <= pfifo_column_burst_aligned;
        end
    end
    
    alt_mem_ddrx_fifo
    # (
        .CTL_FIFO_DATA_WIDTH             (CFG_ERRCMD_FIFO_WIDTH),
        .CTL_FIFO_ADDR_WIDTH             (CFG_ERRCMD_FIFO_ADDR_WIDTH)
    )
    errcmd_fifo_inst
    (
        .ctl_clk		(ctl_clk),
        .ctl_reset_n	(ctl_reset_n),

        .get_ready		(errcmd_ready),
        .get_valid		(errcmd_valid),
        .get_data		(errcmd_fifo_out),   

        .put_ready		(errcmd_fifo_in_ready),
        .put_valid		(errcmd_fifo_in_valid),
        .put_data       (errcmd_fifo_in)

    );


    // 
    // error address information for MMR's
    //
    //  - rdatap_rcvd_addr, rdatap_rcvd_cmd & rdatap_rcvd_corr_dropped
    //  - rdatap_rcvd_addr generation takes 1 cycle after an error, so need to register 
    //    rdatap_rcvd_cmd & rdatap_rcvd_corr_dropped to keep in sync, see SPR:362993
    //

    assign rdatap_rcvd_addr                      = pfifo_addr;

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            rdata_burst_complete_r                  <= 0;
            errcmd_fifo_in_cmddropped_r             <= 0;

            rdatap_rcvd_cmd                         <= 0;
            rdatap_rcvd_corr_dropped                <= 0;
        end
        else
        begin

            rdata_burst_complete_r                  <= rdata_burst_complete;
            errcmd_fifo_in_cmddropped_r             <= errcmd_fifo_in_cmddropped;

            rdatap_rcvd_cmd                         <= rdata_burst_complete;
            rdatap_rcvd_corr_dropped                <= errcmd_fifo_in_cmddropped;
        end
    end


    // generate local address from chip, bank, row, column addresses
    always @(*) 
    begin : addr_loop

        pfifo_addr = 0;

        // column
        pfifo_addr[MIN_COL - CFG_IGNORE_NUM_BITS_COL - 1 : 0] = pfifo_column_burst_aligned_r[MIN_COL - 1 : CFG_IGNORE_NUM_BITS_COL];    
        for (n=MIN_COL; n<MAX_COL; n=n+1'b1) begin
            if(n < cfg_col_addr_width) begin // bit of col_addr can be configured in CSR using cfg_col_addr_width
                 pfifo_addr[n - CFG_IGNORE_NUM_BITS_COL] = pfifo_column_burst_aligned_r[n]; 
            end
        end

        // row
        for (j=0; j<MIN_ROW; j=j+1'b1) begin    //The purpose of using this for-loop is to get rid of "if(j < cfg_row_addr_width) begin" which causes multiplexers
            pfifo_addr[j + cfg_addr_bitsel_row] =  pfifo_row_r[j];
        end
        for (j=MIN_ROW; j<MAX_ROW; j=j+1'b1) begin               
            if(j < cfg_row_addr_width) begin    // bit of row_addr can be configured in CSR using cfg_row_addr_width
                pfifo_addr[j + cfg_addr_bitsel_row] =  pfifo_row_r[j];
            end
        end

        // bank
        for (k=0; k<MIN_BANK; k=k+1'b1) begin    //The purpose of using this for-loop is to get rid of "if(k < cfg_bank_addr_width) begin" which causes multiplexers
            pfifo_addr[k + cfg_addr_bitsel_bank] = pfifo_bank_r[k];
        end
        for (k=MIN_BANK; k<MAX_BANK; k=k+1'b1) begin               
            if(k < cfg_bank_addr_width) begin   // bit of bank_addr can be configured in CSR using cfg_bank_addr_width
                pfifo_addr[k + cfg_addr_bitsel_bank] = pfifo_bank_r[k];
            end
         end

        // cs
        m = 0;
        if (cfg_cs_addr_width > 1'b0) begin    //if cfg_cs_addr_width =< 1'b1, address doesn't have cs_addr bit
            for (m=0; m<MIN_CS; m=m+1'b1) begin  //The purpose of using this for-loop is to get rid of "if(m < cfg_cs_addr_width) begin" which causes multiplexers
                pfifo_addr[m + cfg_addr_bitsel_chipsel] = pfifo_chipsel_r[m]; 
            end
            for (m=MIN_CS; m<MAX_CS; m=m+1'b1) begin                
                if(m < cfg_cs_addr_width) begin     // bit of cs_addr can be configured in CSR using cfg_cs_addr_width
                    pfifo_addr[m + cfg_addr_bitsel_chipsel] = pfifo_chipsel_r[m]; 
                end    
            end
        end

    end



    // pre-calculate pfifo_addr chipsel, bank, row, col bit select offsets
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            cfg_addr_bitsel_chipsel <=  0;
            cfg_addr_bitsel_bank    <=  0;
            cfg_addr_bitsel_row     <=  0;
        end
        else
        begin
            //row
            if(cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL)
                cfg_addr_bitsel_row <= cfg_cs_addr_width + cfg_bank_addr_width + cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL;
            else if(cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL)
                cfg_addr_bitsel_row <= cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL;
            else  // cfg_addr_order == `MMR_ADDR_ORDER_CS_ROW_BA_COL
                cfg_addr_bitsel_row <= cfg_bank_addr_width + cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL;

            // bank
            if(cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL)
                cfg_addr_bitsel_bank <= cfg_row_addr_width + cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL;
            else  // cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL || `MMR_ADDR_ORDER_CS_ROW_BA_COL
                cfg_addr_bitsel_bank <= cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL;

            //chipsel
            if(cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL)
                cfg_addr_bitsel_chipsel <= cfg_bank_addr_width + cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL; 
            else  // cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL || `MMR_ADDR_ORDER_CS_ROW_BA_COL
                cfg_addr_bitsel_chipsel <= cfg_bank_addr_width + cfg_row_addr_width + cfg_col_addr_width - CFG_IGNORE_NUM_BITS_COL; 

        end
    end


    //
    // Everything below is for
    // CFG_RDATA_RETURN_MODE == INORDER support
    //

    generate
    begin : gen_rdata_return_inorder
    if (CFG_RDATA_RETURN_MODE == "INORDER")
    begin


        //
        // DATAID MANAGEMENT
        //

        genvar i;
        for (i = 0; i < CFG_DATAID_ARRAY_DEPTH; i = i + 1) 
        begin : gen_dataid_array

            assign dataid_array_valid[i] = |(dataid_array_burstcount[i]);

            // dataid_array
            always @ (posedge ctl_clk or negedge ctl_reset_n) 
            begin
                if (~ctl_reset_n)
                begin
                    dataid_array_data_ready[i]  <= 1'b0;
                    dataid_array_burstcount[i]  <= 0;
                    dataid_array_localid   [i]  <= 0;
                end
                else
                begin
                
                    // update command
                    if (cmdload_valid & free_id_dataid_vector[i])
                    begin
                       dataid_array_burstcount[i]     <= proc_size;
                    end


                    // writing data to buffer
                    if (rout_data_valid & (rout_data_dataid == i))
                    begin
                       dataid_array_data_ready[i]  <= 1'b1;
                       dataid_array_localid[i]     <= rout_data_localid;
                    end

                    // completed reading data from buffer
                    if (inordr_id_data_complete & inordr_id_dataid_vector[i])
                    begin
                       dataid_array_data_ready[i]  <= 1'b0;
                       dataid_array_burstcount[i]  <= 0;            
                    end
                end
            end
            
            // dataid_array output decode mux
            always @ (*) 
            begin
                if (inordr_id_valid & inordr_id_dataid_vector[i])
                begin
                    mux_inordr_data_ready[i] = dataid_array_data_ready[i];
                end
                else
                begin
                    mux_inordr_data_ready[i] = 1'b0;
                end
            end

        end

        assign inordr_read_data_valid = |mux_inordr_data_ready;



        // 
        // FREE & ALLOCATED DATAID LIST 
        //

        assign free_id_get_ready    = cmdload_valid;
        assign allocated_put_valid  = free_id_get_ready & free_id_valid;

        // list & fifo ready & valid assertion/de-assertion behavior may differ based on implementation, SPR:358527
        assign free_id_valid        = int_free_id_valid & inordr_info_input_ready;
        assign inordr_id_valid      = inordr_id_list_valid & inordr_info_output_valid;

        alt_mem_ddrx_list
        #(
            .CTL_LIST_WIDTH                     (CFG_DATA_ID_WIDTH),
            .CTL_LIST_DEPTH                     (CFG_DATAID_ARRAY_DEPTH),
            .CTL_LIST_INIT_VALUE_TYPE           ("INCR"),
            .CTL_LIST_INIT_VALID                ("VALID")
        )
        list_freeid_inst
        (
         .ctl_clk                               (ctl_clk),
         .ctl_reset_n                           (ctl_reset_n),
                                                                            
         .list_get_entry_ready                  (free_id_get_ready),
         .list_get_entry_valid                  (int_free_id_valid),
         .list_get_entry_id                     (free_id_dataid),   
         .list_get_entry_id_vector              (free_id_dataid_vector),   
        
         // ready can be ignored, list entry availability is guaranteed
         .list_put_entry_ready                  (),                             
         .list_put_entry_valid                  (inordr_id_data_complete),         
         .list_put_entry_id                     (inordr_id_dataid)
        );

        alt_mem_ddrx_list
        #(
            .CTL_LIST_WIDTH                     (CFG_DATA_ID_WIDTH),
            .CTL_LIST_DEPTH                     (CFG_DATAID_ARRAY_DEPTH),
            .CTL_LIST_INIT_VALUE_TYPE           ("ZERO"),
            .CTL_LIST_INIT_VALID                ("INVALID")
        )
        list_allocated_id_inst
        (
         .ctl_clk                               (ctl_clk),
         .ctl_reset_n                           (ctl_reset_n),
                                                                                   
         .list_get_entry_ready                  (inordr_id_data_complete),
         .list_get_entry_valid                  (inordr_id_list_valid),
         .list_get_entry_id                     (inordr_id_dataid),   
         .list_get_entry_id_vector              (inordr_id_dataid_vector),   

         // allocated_put_ready can be ignored, list entry availability is guaranteed
         .list_put_entry_ready                  (allocated_put_ready),
         .list_put_entry_valid                  (allocated_put_valid),    
         .list_put_entry_id                     (free_id_dataid)
        );

        // format for inordr_info_input & inordr_info_output must be same
        assign inordr_info_input = {proc_localid,proc_size};
        assign {inordr_id_localid,inordr_id_expected_burstcount} = inordr_info_output;

        alt_mem_ddrx_fifo
        # (
            .CTL_FIFO_DATA_WIDTH             (CFG_INORDER_INFO_FIFO_WIDTH),
            .CTL_FIFO_ADDR_WIDTH             (CFG_DATA_ID_WIDTH)
        )
        inordr_info_fifo_inst
        (
            .ctl_clk		(ctl_clk),
            .ctl_reset_n	(ctl_reset_n),

            .get_ready		(inordr_id_data_complete),
            .get_valid		(inordr_info_output_valid),
            .get_data		(inordr_info_output),   

            .put_ready		(inordr_info_input_ready),
            .put_valid		(allocated_put_valid),
            .put_data       (inordr_info_input)

        );

        //
        // IN-ORDER READ MANAGER
        //

        always @ (posedge ctl_clk or negedge ctl_reset_n) 
        begin
            if (~ctl_reset_n)
            begin
                inordr_data_counter        <= 0;
                inordr_data_counter_plus_1 <= 0;
                inordr_read_data_valid_r   <= 0;
                inordr_id_data_complete_r  <= 0;
                inordr_id_localid_r        <= 0;
            end
            else
            begin
                if (inordr_id_data_complete)
                begin
                    inordr_data_counter        <= 0;
                    inordr_data_counter_plus_1 <= 1;
                end
                else
                begin
                    inordr_data_counter        <= inordr_next_data_counter;
                    inordr_data_counter_plus_1 <= inordr_next_data_counter + 1;
                end

                inordr_id_localid_r     <= inordr_id_localid;

                // original signal used to read from buffer
                // _r version used to pop the fifos
                inordr_read_data_valid_r    <=  inordr_read_data_valid;
                inordr_id_data_complete_r   <= inordr_id_data_complete;
            end
        end

        assign inordr_next_data_counter = (inordr_read_data_valid) ? (inordr_data_counter_plus_1) : inordr_data_counter;
        assign inordr_id_data_complete  = inordr_read_data_valid & (inordr_data_counter_plus_1 == inordr_id_expected_burstcount);
        
        //
        // BUFFER
        //
        assign buffwrite_offset = ecc_rdata_counter;
        assign buffwrite_address = {rout_data_dataid,buffwrite_offset};
        assign buffwrite_data   = {rout_data_error,rout_data};

        assign buffread_offset = inordr_data_counter;
        assign buffread_address = {inordr_id_dataid,buffread_offset};
        assign {inordr_read_data_error,inordr_read_data} = buffread_data;

        alt_mem_ddrx_buffer                                                 
        # (                                                                 
            .ADDR_WIDTH                         (CFG_BUFFER_ADDR_WIDTH),
            .DATA_WIDTH                         (CFG_IN_ORDER_BUFFER_DATA_WIDTH) 
        )                                                                   
        in_order_buffer_inst                                               
        (                                                                   
            // port list                                                    
            .ctl_clk                            (ctl_clk),
            .ctl_reset_n                        (ctl_reset_n),
                                                                            
            // write interface                                              
            .write_valid                        (rout_data_valid),
            .write_address                      (buffwrite_address),
            .write_data                         (buffwrite_data),
                                                                            
            // read interface                                               
            .read_valid                         (inordr_read_data_valid),
            .read_address                       (buffread_address),
            .read_data                          (buffread_data)
        );

    end
    end
    endgenerate


    function integer log2; 
       input [31:0] value; 
       integer    i; 
       begin 
          log2 = 0; 
          for(i = 0; 2**i < value; i = i + 1) 
       log2 = i + 1; 
       end 
    endfunction    

endmodule

//
// assert
//
// - rdatap_free_id_valid XOR rdatap_allocated_put_ready must always be 1
// - CFG_BUFFER_ADDR_WIDTH must be >= CFG_INT_SIZE_WIDTH. must have enough location to store 1 dram command worth of data
// - put_ready goes low
// - ecc_rdatav is high, but pfifo_output_valid is low
// - buffer size must be dataid x max size per command
// - is rdata_burst_complete allowed to be high every cycle?
// - CFG_BUFFER_ADDR_WIDTH > CFG_DATA_ID_WIDTH
// - if cfg_enable_ecc is low, sbe, dbe, rdata error must all be low
// - if cfg_enable_auto_corr is low, rmw & rmw_partial must be low, errcmd_valid must never be high
// - cmd_counter_full & cmdload_valid
