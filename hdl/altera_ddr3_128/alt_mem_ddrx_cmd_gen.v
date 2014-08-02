//altera message_off 10230

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_cmd_gen
    # (parameter
        // cmd_gen settings
        CFG_LOCAL_ADDR_WIDTH            = 33,
        CFG_LOCAL_SIZE_WIDTH            = 3,
        CFG_LOCAL_ID_WIDTH              = 8,
        CFG_INT_SIZE_WIDTH              = 4,
        CFG_PORT_WIDTH_COL_ADDR_WIDTH   = 4,
        CFG_PORT_WIDTH_ROW_ADDR_WIDTH   = 5,
        CFG_PORT_WIDTH_BANK_ADDR_WIDTH  = 2,
        CFG_PORT_WIDTH_CS_ADDR_WIDTH    = 2,
        CFG_PORT_WIDTH_BURST_LENGTH     = 5,
        CFG_PORT_WIDTH_ADDR_ORDER       = 2,
        CFG_DWIDTH_RATIO                = 2, // 2-FR,4-HR,8-QR
        CFG_CTL_QUEUE_DEPTH             = 8,
        CFG_MEM_IF_CHIP                 = 1, // one hot
        CFG_MEM_IF_CS_WIDTH             = 1, // binary coded
        CFG_MEM_IF_BA_WIDTH             = 3,
        CFG_MEM_IF_ROW_WIDTH            = 13,
        CFG_MEM_IF_COL_WIDTH            = 10,
        CFG_DATA_ID_WIDTH               = 10,
        CFG_ENABLE_QUEUE                = 1,
        CFG_ENABLE_BURST_MERGE          = 1,
        CFG_CMD_GEN_OUTPUT_REG          = 0,
        CFG_CTL_TBP_NUM                 = 4,
        CFG_CTL_SHADOW_TBP_NUM          = 4,
        MIN_COL                         = 8,
        MIN_ROW                         = 12,
        MIN_BANK                        = 2,
        MIN_CS                          = 1
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // tbp interface
        tbp_full,
        tbp_load,
        tbp_read,
        tbp_write,
        tbp_chipsel,
        tbp_bank,
        tbp_row,
        tbp_col,
        tbp_shadow_chipsel,
        tbp_shadow_bank,
        tbp_shadow_row,
        cmd_gen_load,
        cmd_gen_chipsel,
        cmd_gen_bank,
        cmd_gen_row,
        cmd_gen_col,
        cmd_gen_write,
        cmd_gen_read,
        cmd_gen_multicast,
        cmd_gen_size,
        cmd_gen_localid,
        cmd_gen_dataid,
        cmd_gen_priority,
        cmd_gen_rmw_correct,
        cmd_gen_rmw_partial,
        cmd_gen_autopch,
        cmd_gen_complete,
        cmd_gen_same_chipsel_addr,
        cmd_gen_same_bank_addr,
        cmd_gen_same_row_addr,
        cmd_gen_same_col_addr,
        cmd_gen_same_read_cmd,
        cmd_gen_same_write_cmd,
        cmd_gen_same_shadow_chipsel_addr,
        cmd_gen_same_shadow_bank_addr,
        cmd_gen_same_shadow_row_addr,
        
        // input interface
        cmd_gen_full,
        cmd_valid,
        cmd_address,
        cmd_write,
        cmd_read,
        cmd_id,
        cmd_multicast,
        cmd_size,
        cmd_priority,
        cmd_autoprecharge,
        
        // datapath interface
        proc_busy,
        proc_load,
        proc_load_dataid,
        proc_write,
        proc_read,
        proc_size,
        proc_localid,
        wdatap_free_id_valid, // from wdata path
        wdatap_free_id_dataid, // from wdata path
        rdatap_free_id_valid, // from rdata path
        rdatap_free_id_dataid, // from rdata path
        tbp_load_index,
        data_complete,
        data_rmw_complete,
        
        // nodm and ecc signal
        errcmd_ready,
        errcmd_valid,
        errcmd_chipsel,
        errcmd_bank,
        errcmd_row,
        errcmd_column,
        errcmd_size,
        errcmd_localid,
        data_partial_be,
        
        // configuration ports
        cfg_enable_cmd_split,
        cfg_burst_length,
        cfg_addr_order,
        cfg_enable_ecc,
        cfg_enable_no_dm,
        cfg_col_addr_width,
        cfg_row_addr_width,
        cfg_bank_addr_width,
        cfg_cs_addr_width
    );
    
    localparam MAX_COL                        = CFG_MEM_IF_COL_WIDTH;
    localparam MAX_ROW                        = CFG_MEM_IF_ROW_WIDTH;
    localparam MAX_BANK                       = CFG_MEM_IF_BA_WIDTH;
    localparam MAX_CS                         = CFG_MEM_IF_CS_WIDTH;
    localparam BUFFER_WIDTH                   = 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + CFG_DATA_ID_WIDTH + CFG_LOCAL_ID_WIDTH + CFG_INT_SIZE_WIDTH + CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_ROW_WIDTH + CFG_MEM_IF_COL_WIDTH;
    localparam CFG_LOCAL_ADDR_BITSELECT_WIDTH = log2(CFG_LOCAL_ADDR_WIDTH);
    localparam INT_LOCAL_ADDR_WIDTH           = 2**CFG_LOCAL_ADDR_BITSELECT_WIDTH;
    
    input   ctl_clk;
    input   ctl_reset_n;
    
    input                                                       tbp_full;
    input   [CFG_CTL_TBP_NUM-1:0]                               tbp_load;
    input   [CFG_CTL_TBP_NUM-1:0]                               tbp_read;
    input   [CFG_CTL_TBP_NUM-1:0]                               tbp_write;
    input   [(CFG_CTL_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0]         tbp_chipsel;
    input   [(CFG_CTL_TBP_NUM*CFG_MEM_IF_BA_WIDTH)-1:0]         tbp_bank;
    input   [(CFG_CTL_TBP_NUM*CFG_MEM_IF_ROW_WIDTH)-1:0]        tbp_row;
    input   [(CFG_CTL_TBP_NUM*CFG_MEM_IF_COL_WIDTH)-1:0]        tbp_col;
    input   [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_CS_WIDTH)-1:0]  tbp_shadow_chipsel;
    input   [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_BA_WIDTH)-1:0]  tbp_shadow_bank;
    input   [(CFG_CTL_SHADOW_TBP_NUM*CFG_MEM_IF_ROW_WIDTH)-1:0] tbp_shadow_row;
    output                                                      cmd_gen_load;
    output  [CFG_MEM_IF_CS_WIDTH-1:0]                           cmd_gen_chipsel;
    output  [CFG_MEM_IF_BA_WIDTH-1:0]                           cmd_gen_bank;
    output  [CFG_MEM_IF_ROW_WIDTH-1:0]                          cmd_gen_row;
    output  [CFG_MEM_IF_COL_WIDTH-1:0]                          cmd_gen_col;
    output                                                      cmd_gen_write;
    output                                                      cmd_gen_read;
    output                                                      cmd_gen_multicast;
    output  [CFG_INT_SIZE_WIDTH-1:0]                            cmd_gen_size;
    output  [CFG_LOCAL_ID_WIDTH-1:0]                            cmd_gen_localid;
    output  [CFG_DATA_ID_WIDTH-1:0]                             cmd_gen_dataid;
    output                                                      cmd_gen_priority;
    output                                                      cmd_gen_rmw_correct;
    output                                                      cmd_gen_rmw_partial;
    output                                                      cmd_gen_autopch;
    output                                                      cmd_gen_complete;
    output  [CFG_CTL_TBP_NUM-1:0]                               cmd_gen_same_chipsel_addr;
    output  [CFG_CTL_TBP_NUM-1:0]                               cmd_gen_same_bank_addr;
    output  [CFG_CTL_TBP_NUM-1:0]                               cmd_gen_same_row_addr;
    output  [CFG_CTL_TBP_NUM-1:0]                               cmd_gen_same_col_addr;
    output  [CFG_CTL_TBP_NUM-1:0]                               cmd_gen_same_read_cmd;
    output  [CFG_CTL_TBP_NUM-1:0]                               cmd_gen_same_write_cmd;
    output  [CFG_CTL_SHADOW_TBP_NUM-1:0]                        cmd_gen_same_shadow_chipsel_addr;
    output  [CFG_CTL_SHADOW_TBP_NUM-1:0]                        cmd_gen_same_shadow_bank_addr;
    output  [CFG_CTL_SHADOW_TBP_NUM-1:0]                        cmd_gen_same_shadow_row_addr;
    
    output                                       cmd_gen_full;
    input                                        cmd_valid;
    input   [CFG_LOCAL_ADDR_WIDTH-1:0]           cmd_address;
    input                                        cmd_write;
    input                                        cmd_read;
    input   [CFG_LOCAL_ID_WIDTH-1:0]             cmd_id;
    input                                        cmd_multicast;
    input   [CFG_LOCAL_SIZE_WIDTH-1:0]           cmd_size;
    input                                        cmd_priority;
    input                                        cmd_autoprecharge;
    
    output                                       proc_busy;
    output                                       proc_load;
    output                                       proc_load_dataid;
    output                                       proc_write;
    output                                       proc_read;
    output  [CFG_INT_SIZE_WIDTH-1:0]             proc_size;
    output  [CFG_LOCAL_ID_WIDTH-1:0]             proc_localid;
    input                                        wdatap_free_id_valid;
    input   [CFG_DATA_ID_WIDTH-1:0]              wdatap_free_id_dataid;
    input                                        rdatap_free_id_valid;
    input   [CFG_DATA_ID_WIDTH-1:0]              rdatap_free_id_dataid;
    output  [CFG_CTL_TBP_NUM-1:0]                tbp_load_index;
    input   [CFG_CTL_TBP_NUM-1:0]                data_complete;
    input                                        data_rmw_complete;
    
    output                                       errcmd_ready; // high means cmd_gen accepts command
    input                                        errcmd_valid;
    input   [CFG_MEM_IF_CS_WIDTH-1:0]            errcmd_chipsel;
    input   [CFG_MEM_IF_BA_WIDTH-1:0]            errcmd_bank;
    input   [CFG_MEM_IF_ROW_WIDTH-1:0]           errcmd_row;
    input   [CFG_MEM_IF_COL_WIDTH-1:0]           errcmd_column;
    input   [CFG_INT_SIZE_WIDTH-1:0]             errcmd_size;
    input   [CFG_LOCAL_ID_WIDTH   - 1 : 0]       errcmd_localid;
    input                                        data_partial_be;
    
    input                                        cfg_enable_cmd_split;
    input   [CFG_PORT_WIDTH_BURST_LENGTH-1:0]    cfg_burst_length;  // this contains immediate BL value, max is 31
    input   [CFG_PORT_WIDTH_ADDR_ORDER-1:0]      cfg_addr_order;    // 0 is chiprowbankcol , 1 is chipbankrowcol , 2 is rowchipbankcol
    input                                        cfg_enable_ecc;
    input                                        cfg_enable_no_dm;
    input   [CFG_PORT_WIDTH_COL_ADDR_WIDTH-1:0]  cfg_col_addr_width;
    input   [CFG_PORT_WIDTH_ROW_ADDR_WIDTH-1:0]  cfg_row_addr_width;
    input   [CFG_PORT_WIDTH_BANK_ADDR_WIDTH-1:0] cfg_bank_addr_width;
    input   [CFG_PORT_WIDTH_CS_ADDR_WIDTH-1:0]   cfg_cs_addr_width; 
    
    // === address mapping
    
    integer n;
    integer j;
    integer k;
    integer m;
    
    wire    [INT_LOCAL_ADDR_WIDTH-1:0]     int_cmd_address;
    
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      int_cs_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      int_bank_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     int_row_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     int_col_addr;
    
    // === command splitting block
    
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      split_cs_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      split_bank_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     split_row_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     split_col_addr;
    reg                                    split_read;
    reg                                    split_write;
    reg     [CFG_INT_SIZE_WIDTH-1:0]       split_size;
    reg                                    split_autopch;
    reg                                    split_multicast;
    reg                                    split_priority;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]       split_localid;
    
    reg                                    buf_read_req;
    reg                                    buf_write_req;
    reg                                    buf_autopch_req;
    reg                                    buf_multicast;
    reg                                    buf_priority;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]       buf_localid;
    reg     [CFG_LOCAL_SIZE_WIDTH:0]       buf_size;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      buf_cs_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      buf_bank_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     buf_row_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     buf_col_addr;
    
    reg     [CFG_LOCAL_SIZE_WIDTH-1:0]     decrmntd_size;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      incrmntd_cs_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      incrmntd_bank_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     incrmntd_row_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     incrmntd_col_addr;
    
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      max_chip_from_csr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      max_bank_from_csr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     max_row_from_csr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     max_col_from_csr;
    
    wire          copy;
    reg     [2:0] unaligned_burst;  // because planned max native size is 8, unaligned burst can be a max of 7
    reg     [3:0] native_size;      // support native size up to 15, bl16 FR have native size of 8
    wire          require_gen;
    reg           deassert_ready;
    reg           registered;
    reg           generating;
    
    // === ecc mux
    
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      ecc_cs_addr_combi;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      ecc_bank_addr_combi;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     ecc_row_addr_combi;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     ecc_col_addr_combi;
    reg                                    ecc_read_combi;
    reg                                    ecc_write_combi;
    reg     [CFG_INT_SIZE_WIDTH-1:0]       ecc_size_combi;
    reg                                    ecc_autopch_combi;
    reg                                    ecc_multicast_combi;
    reg                                    ecc_priority_combi;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]       ecc_localid_combi;
    reg     [CFG_DATA_ID_WIDTH-1:0]        ecc_dataid_combi;
    
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]      ecc_cs_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]      ecc_bank_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]     ecc_row_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]     ecc_col_addr;
    reg                                    ecc_read;
    reg                                    ecc_write;
    reg     [CFG_INT_SIZE_WIDTH-1:0]       ecc_size;
    reg                                    ecc_autopch;
    reg                                    ecc_multicast;
    reg                                    ecc_priority;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]       ecc_localid;
    reg     [CFG_DATA_ID_WIDTH-1:0]        ecc_dataid;
    
    reg     ecc_int_combi;
    reg     errcmd_ready_combi;
    reg     partial_combi;
    reg     correct_combi;
    reg     partial_opr_combi;
    
    reg     ecc_int;
    reg     ecc_int_r;
    reg     errcmd_ready;
    reg     partial;
    reg     correct;
    reg     partial_opr;
    
    wire    mux_busy;
    
    wire    [CFG_MEM_IF_CS_WIDTH-1:0]  muxed_cs_addr;
    wire    [CFG_MEM_IF_BA_WIDTH-1:0]  muxed_bank_addr;
    wire    [CFG_MEM_IF_ROW_WIDTH-1:0] muxed_row_addr;
    wire    [CFG_MEM_IF_COL_WIDTH-1:0] muxed_col_addr;
    wire                               muxed_read;
    wire                               muxed_write;
    wire    [CFG_INT_SIZE_WIDTH-1:0]   muxed_size;
    wire                               muxed_autopch;
    wire                               muxed_multicast;
    wire                               muxed_priority;
    wire    [CFG_LOCAL_ID_WIDTH-1:0]   muxed_localid;
    wire    [CFG_DATA_ID_WIDTH-1:0]    muxed_dataid;
    wire                               muxed_complete;
    wire                               muxed_correct;
    wire                               muxed_partial;
    
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_chipsel_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_bank_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_row_addr_0;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_row_addr_1;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_row_addr_2;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_row_addr_3;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_col_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_read_cmd;
    wire    [CFG_CTL_TBP_NUM-1:0]      muxed_same_write_cmd;
    
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_chipsel_addr_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_bank_addr_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_0_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_1_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_2_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_3_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_col_addr_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_read_cmd_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_write_cmd_combi;
    
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_chipsel_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_bank_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_0;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_1;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_2;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_row_addr_3;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_col_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_read_cmd;
    reg     [CFG_CTL_TBP_NUM-1:0]      split_same_write_cmd;
    
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_chipsel_addr_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_bank_addr_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_0_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_1_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_2_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_3_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_col_addr_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_read_cmd_combi;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_write_cmd_combi;
    
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_chipsel_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_bank_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_0;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_1;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_2;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_row_addr_3;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_col_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_read_cmd;
    reg     [CFG_CTL_TBP_NUM-1:0]      ecc_same_write_cmd;
    
    wire                               proc_busy;
    wire                               proc_load;
    wire                               proc_load_dataid;
    wire                               proc_write;
    wire                               proc_read;
    wire    [CFG_INT_SIZE_WIDTH-1:0]   proc_size;
    wire    [CFG_LOCAL_ID_WIDTH-1:0]   proc_localid;
    reg                                proc_busy_sig;
    reg                                proc_ecc_busy_sig;
    reg                                proc_load_sig;
    reg                                proc_load_dataid_sig;
    reg                                proc_write_sig;
    reg                                proc_read_sig;
    reg     [CFG_INT_SIZE_WIDTH-1:0]   proc_size_sig;
    reg     [CFG_LOCAL_ID_WIDTH-1:0]   proc_localid_sig;
    
    wire    [CFG_CTL_TBP_NUM-1:0]      tbp_load_index;
    
    // === merging signals
    
    reg     [log2(CFG_CTL_QUEUE_DEPTH)-1:0]  last;
    reg     [log2(CFG_CTL_QUEUE_DEPTH)-1:0]  last_minus_one;
    reg     [log2(CFG_CTL_QUEUE_DEPTH)-1:0]  last_minus_two;
    wire                                     can_merge;
    
    reg     [CFG_INT_SIZE_WIDTH-1:0]         last_size;
    reg                                      last_read_req;
    reg                                      last_write_req;
    reg                                      last_multicast;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]        last_chip_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]       last_row_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]        last_bank_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]       last_col_addr;
    
    reg     [CFG_INT_SIZE_WIDTH-1:0]         last2_size;
    reg                                      last2_read_req;
    reg                                      last2_write_req;
    reg                                      last2_multicast;
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]        last2_chip_addr;
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0]       last2_row_addr;
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]        last2_bank_addr;
    reg     [CFG_MEM_IF_COL_WIDTH-1:0]       last2_col_addr;
    
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] cfg_addr_bitsel_chipsel;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] cfg_addr_bitsel_bank;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] cfg_addr_bitsel_row;
    
    // === queue
    
    reg     [BUFFER_WIDTH-1:0]               pipe[CFG_CTL_QUEUE_DEPTH-1:0];
    reg                                      pipefull[CFG_CTL_QUEUE_DEPTH-1:0];
    
    wire                                     fetch;
    wire    [BUFFER_WIDTH-1:0]               buffer_input;
    wire                                     write_to_queue;
    wire                                     queue_empty;
    wire                                     queue_full;
    
    wire                                                 cmd_gen_load;
    wire    [CFG_MEM_IF_CS_WIDTH-1:0]                    cmd_gen_chipsel;
    wire    [CFG_MEM_IF_BA_WIDTH-1:0]                    cmd_gen_bank;
    wire    [CFG_MEM_IF_ROW_WIDTH-1:0]                   cmd_gen_row;
    wire    [CFG_MEM_IF_COL_WIDTH-1:0]                   cmd_gen_col;
    wire                                                 cmd_gen_write;
    wire                                                 cmd_gen_read;
    wire                                                 cmd_gen_multicast;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                     cmd_gen_size;
    wire    [CFG_LOCAL_ID_WIDTH-1:0]                     cmd_gen_localid;
    wire    [CFG_DATA_ID_WIDTH-1:0]                      cmd_gen_dataid;
    wire                                                 cmd_gen_priority;
    wire                                                 cmd_gen_rmw_correct;
    wire                                                 cmd_gen_rmw_partial;
    wire                                                 cmd_gen_autopch;
    wire                                                 cmd_gen_complete;
    wire    [CFG_CTL_TBP_NUM-1:0]                        cmd_gen_same_chipsel_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]                        cmd_gen_same_bank_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]                        cmd_gen_same_row_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]                        cmd_gen_same_col_addr;
    wire    [CFG_CTL_TBP_NUM-1:0]                        cmd_gen_same_read_cmd;
    wire    [CFG_CTL_TBP_NUM-1:0]                        cmd_gen_same_write_cmd;
    wire    [CFG_CTL_SHADOW_TBP_NUM-1:0]                 cmd_gen_same_shadow_chipsel_addr;
    wire    [CFG_CTL_SHADOW_TBP_NUM-1:0]                 cmd_gen_same_shadow_bank_addr;
    wire    [CFG_CTL_SHADOW_TBP_NUM-1:0]                 cmd_gen_same_shadow_row_addr;
    
    reg     [CFG_CTL_TBP_NUM-1:0]                        same_chipsel_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]                        same_bank_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]                        same_row_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]                        same_col_addr;
    reg     [CFG_CTL_TBP_NUM-1:0]                        same_read_cmd;
    reg     [CFG_CTL_TBP_NUM-1:0]                        same_write_cmd;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]                 same_shadow_chipsel_addr;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]                 same_shadow_bank_addr;
    reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]                 same_shadow_row_addr;
    
    reg                                read           [CFG_CTL_TBP_NUM-1:0];
    reg                                write          [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_CS_WIDTH-1:0]  chipsel        [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_BA_WIDTH-1:0]  bank           [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_ROW_WIDTH-1:0] row            [CFG_CTL_TBP_NUM-1:0];
    reg     [CFG_MEM_IF_COL_WIDTH-1:0] col            [CFG_CTL_TBP_NUM-1:0];
    
    wire    [CFG_MEM_IF_CS_WIDTH-1:0]  shadow_chipsel [CFG_CTL_SHADOW_TBP_NUM-1:0];
    wire    [CFG_MEM_IF_BA_WIDTH-1:0]  shadow_bank    [CFG_CTL_SHADOW_TBP_NUM-1:0];
    wire    [CFG_MEM_IF_ROW_WIDTH-1:0] shadow_row     [CFG_CTL_SHADOW_TBP_NUM-1:0];
    
    wire    one  = 1'b1;
    wire    zero = 1'b0;
    
    //=======================   TBP info   ===========================
    generate
        genvar p;
        for (p=0; p<CFG_CTL_TBP_NUM; p=p+1)
            begin : info_per_tbp
                always @ (*)
                    begin
                        if (tbp_load[p])
                            begin
                                read   [p] = cmd_gen_read;
                                write  [p] = cmd_gen_write;
                                chipsel[p] = cmd_gen_chipsel;
                                bank   [p] = cmd_gen_bank;
                                row    [p] = cmd_gen_row;
                                col    [p] = cmd_gen_col;
                            end
                        else
                            begin
                                read   [p] = tbp_read   [p];
                                write  [p] = tbp_write  [p];
                                chipsel[p] = tbp_chipsel[(p+1)*CFG_MEM_IF_CS_WIDTH-1:p*CFG_MEM_IF_CS_WIDTH];
                                bank   [p] = tbp_bank   [(p+1)*CFG_MEM_IF_BA_WIDTH-1:p*CFG_MEM_IF_BA_WIDTH];
                                row    [p] = tbp_row    [(p+1)*CFG_MEM_IF_ROW_WIDTH-1:p*CFG_MEM_IF_ROW_WIDTH];
                                col    [p] = tbp_col    [(p+1)*CFG_MEM_IF_COL_WIDTH-1:p*CFG_MEM_IF_COL_WIDTH];
                            end
                    end
            end
        
        for (p=0; p<CFG_CTL_SHADOW_TBP_NUM; p=p+1)
            begin : info_per_shadow_tbp
                assign shadow_chipsel[p] = tbp_shadow_chipsel[(p+1)*CFG_MEM_IF_CS_WIDTH-1:p*CFG_MEM_IF_CS_WIDTH];
                assign shadow_bank   [p] = tbp_shadow_bank   [(p+1)*CFG_MEM_IF_BA_WIDTH-1:p*CFG_MEM_IF_BA_WIDTH];
                assign shadow_row    [p] = tbp_shadow_row    [(p+1)*CFG_MEM_IF_ROW_WIDTH-1:p*CFG_MEM_IF_ROW_WIDTH];
            end
    endgenerate
    
    //=======================   Address Remapping   ===========================
    
    // Pre-calculate int_*_addr chipsel, bank, row, col bit select offsets
    always @ (*)
        begin
            // Row width info
            if (cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL)
                begin
                    cfg_addr_bitsel_row = cfg_cs_addr_width + cfg_bank_addr_width + cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
            else if (cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL)
                begin
                    cfg_addr_bitsel_row = cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
            else // cfg_addr_order == `MMR_ADDR_ORDER_CS_ROW_BA_COL
                begin
                    cfg_addr_bitsel_row = cfg_bank_addr_width + cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
            
            // Bank width info
            if (cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL)
                begin
                    cfg_addr_bitsel_bank = cfg_row_addr_width + cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
            else // cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL || `MMR_ADDR_ORDER_CS_ROW_BA_COL
                begin
                    cfg_addr_bitsel_bank = cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
            
            // Chipsel width info
            if (cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL)
                begin
                    cfg_addr_bitsel_chipsel = cfg_bank_addr_width + cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
            else // cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL || `MMR_ADDR_ORDER_CS_ROW_BA_COL
                begin
                    cfg_addr_bitsel_chipsel = cfg_bank_addr_width + cfg_row_addr_width + cfg_col_addr_width - log2(CFG_DWIDTH_RATIO);
                end
        end
    
    assign  int_cmd_address =   cmd_address;
    
    // Supported addr order
    // 0 - chip-row-bank-col
    // 1 - chip-bank-row-col
    // 2 - row-chip-bank-col
    
    // Derive column address from address
    always @(*)
        begin : Col_addr_loop
            int_col_addr[MIN_COL - log2(CFG_DWIDTH_RATIO) - 1 : 0] = int_cmd_address[MIN_COL - log2(CFG_DWIDTH_RATIO) - 1 : 0];
            
            for (n = MIN_COL - log2(CFG_DWIDTH_RATIO);n < MAX_COL;n = n + 1'b1)
                begin
                    if (n < (cfg_col_addr_width - log2(CFG_DWIDTH_RATIO))) // Bit of col_addr can be configured in CSR using cfg_col_addr_width
                        begin
                            int_col_addr[n] = int_cmd_address[n];
                        end
                    else
                        begin
                            int_col_addr[n] = 1'b0;
                        end
                end
            
            int_col_addr = int_col_addr << log2(CFG_DWIDTH_RATIO);
        end
    
    // Derive row address from address
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] row_addr_loop_1;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] row_addr_loop_2;
    
    always @(*)
        begin : Row_addr_loop
            for (j = 0;j < MIN_ROW;j = j + 1'b1) // The purpose of using this for-loop is to get rid of "if (j < cfg_row_addr_width) begin" which causes multiplexers
                begin
                    row_addr_loop_1 = j + cfg_addr_bitsel_row;
                    int_row_addr[j] = int_cmd_address[row_addr_loop_1];
                end
            
            for (j = MIN_ROW;j < MAX_ROW;j = j + 1'b1)
                begin
                    row_addr_loop_2 = j + cfg_addr_bitsel_row;
                    
                    if(j < cfg_row_addr_width) // Bit of row_addr can be configured in CSR using cfg_row_addr_width
                        begin
                            int_row_addr[j] = int_cmd_address[row_addr_loop_2];
                        end
                    else
                        begin
                            int_row_addr[j] = 1'b0;
                        end
                end
        end
    
    // Derive bank address from address
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] bank_addr_loop_1;
    reg [CFG_LOCAL_ADDR_BITSELECT_WIDTH-1:0] bank_addr_loop_2;
    
    always @(*)
        begin : Bank_addr_loop
            for (k = 0;k < MIN_BANK;k = k + 1'b1) // The purpose of using this for-loop is to get rid of "if (k < cfg_bank_addr_width) begin" which causes multiplexers
                begin
                    bank_addr_loop_1 = k + cfg_addr_bitsel_bank;
                    int_bank_addr[k] = int_cmd_address[bank_addr_loop_1];
                end
            
            for (k = MIN_BANK;k < MAX_BANK;k = k + 1'b1)
                begin
                    bank_addr_loop_2 = k + cfg_addr_bitsel_bank;
                    
                    if (k < cfg_bank_addr_width) // Bit of bank_addr can be configured in CSR using cfg_bank_addr_width
                        begin
                            int_bank_addr[k] = int_cmd_address[bank_addr_loop_2];
                        end
                    else
                        begin
                            int_bank_addr[k] = 1'b0;
                        end
                end
        end
    
    // Derive chipsel address from address
    always @(*)
        begin
            m = 0;
            
            if (cfg_cs_addr_width > 1'b0) // If cfg_cs_addr_width =< 1'b1, address doesn't have cs_addr bit
                begin
                    for (m=0; m<MIN_CS; m=m+1'b1) // The purpose of using this for-loop is to get rid of "if (m < cfg_cs_addr_width) begin" which causes multiplexers
                        begin
                            int_cs_addr[m] = int_cmd_address[m + cfg_addr_bitsel_chipsel];
                        end
                    for (m=MIN_CS; m<MAX_CS; m=m+1'b1)
                        begin
                            if (m < cfg_cs_addr_width) // Bit of cs_addr can be configured in CSR using cfg_cs_addr_width
                                begin
                                    int_cs_addr[m] = int_cmd_address[m + cfg_addr_bitsel_chipsel];
                                end
                            else
                                begin
                                    int_cs_addr[m] = 1'b0;
                                end
                        end
                end
            else  // If CFG_MEM_IF_CS_WIDTH = 1, then set cs_addr to 0 (one chip, one rank)
                begin
                    int_cs_addr = {CFG_MEM_IF_CS_WIDTH{1'b0}};
                end
        end
    
    //=====================   end of address remapping   =========================
    
    //=======================   burst splitting logic   ===========================
    
    assign  cmd_gen_full = mux_busy | deassert_ready;
    assign  copy         = ~cmd_gen_full & cmd_valid; // Copy current input command info into a register
    assign  require_gen  = (cmd_size > native_size | unaligned_burst + cmd_size > native_size) & cfg_enable_cmd_split; // Indicate that current input command require splitting
    
    // CSR address calculation
    always @ (*)
        begin
            max_chip_from_csr = (2**cfg_cs_addr_width)   - 1'b1;
            max_bank_from_csr = (2**cfg_bank_addr_width) - 1'b1;
            max_row_from_csr  = (2**cfg_row_addr_width)  - 1'b1;
            max_col_from_csr  = (2**cfg_col_addr_width)  - 1'b1;
        end
    
    // Calculate native size for selected burstlength and controller rate
    always @ (*)
        begin
            native_size = cfg_burst_length / CFG_DWIDTH_RATIO; // 1 for bl2 FR, 2 for bl8 HR, ...
        end
    
    always @(*)
        begin
            if (native_size == 1)
                begin
                    unaligned_burst = 0;
                end
            else if (native_size == 2)
                begin
                    unaligned_burst = {2'd0,int_col_addr[log2(CFG_DWIDTH_RATIO)]};
                end
            else if (native_size == 4)
                begin
                    unaligned_burst = {1'd0,int_col_addr[(log2(CFG_DWIDTH_RATIO)+1):log2(CFG_DWIDTH_RATIO)]};
                end
            else // native_size == 8
                begin
                    unaligned_burst = int_col_addr[(log2(CFG_DWIDTH_RATIO)+2):log2(CFG_DWIDTH_RATIO)];
                end
        end
    
    // Deassert local_ready signal because need to split local command into multiple memory commands
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    deassert_ready <= 0;
                end
            else
                begin
                    if (copy && require_gen)
                        begin
                            deassert_ready <= 1;
                        end
                    else if ((buf_size > native_size*2) && cfg_enable_cmd_split)
                        begin
                            deassert_ready <= 1;
                        end
                    else if (generating && ~mux_busy)
                        begin
                            deassert_ready <= 0;
                        end
                end
        end
    
    // Assert register signal so that we will pass split command into TBP
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    registered <= 0;
                end
            else
                begin
                    if (copy && require_gen)
                        begin
                            registered <= 1;
                        end
                    else
                        begin
                            registered <= 0;
                        end
                end
        end
    
    // Generating signal will notify that current command in under splitting process
    // Signal stays high until the last memory burst aligned command is generated
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    generating <= 0;
                end
            else
                begin
                    if (registered)
                        begin
                            generating <= 1;
                        end
                    else if ((generating && buf_size > native_size*2) && cfg_enable_cmd_split)
                        begin
                            generating <= 1;
                        end
                    else if (~mux_busy)
                        begin
                            generating <= 0;
                        end
                end
        end
    
    // Determine the correct size
    always @(*)
        begin
            if (!generating)
                begin
                    if ((unaligned_burst + cmd_size < native_size) || !cfg_enable_cmd_split) //(local_size > 1 && !unaligned_burst)
                        begin
                            split_size = cmd_size;
                        end
                    else
                        begin
                            split_size = native_size - unaligned_burst;
                        end
                end
            else
                begin
                    if (decrmntd_size > native_size - 1)
                        begin
                            split_size = native_size;
                        end
                    else
                        begin
                            split_size = decrmntd_size;
                        end
                end
        end
    
    // MUX logic to determine where to take the command info from
    always @(*)
        begin
            if (!generating) // not generating so take direct input from avalon if
                begin
                    split_read      = cmd_read & cmd_valid & ~registered;
                    split_write     = cmd_write & cmd_valid & ~registered;
                    split_autopch   = cmd_autoprecharge;
                    split_multicast = cmd_multicast;
                    split_priority  = cmd_priority;
                    split_localid   = cmd_id;
                    split_cs_addr   = int_cs_addr;
                    split_bank_addr = int_bank_addr;
                    split_row_addr  = int_row_addr;
                    split_col_addr  = int_col_addr;
                end
            else // generating cmd so process buffer content
                begin
                    split_read      = buf_read_req;
                    split_write     = buf_write_req;
                    split_autopch   = buf_autopch_req;
                    split_multicast = buf_multicast;
                    split_priority  = buf_priority;
                    split_localid   = buf_localid;
                    split_cs_addr   = incrmntd_cs_addr;
                    split_bank_addr = incrmntd_bank_addr;
                    split_row_addr  = incrmntd_row_addr;
                    
                    if (cfg_burst_length == 2)
                        begin
                            split_col_addr = {incrmntd_col_addr[CFG_MEM_IF_COL_WIDTH-1:1],1'b0};
                        end
                    else if (cfg_burst_length == 4)
                        begin
                            split_col_addr = {incrmntd_col_addr[CFG_MEM_IF_COL_WIDTH-1:2],2'b00};
                        end
                    else if (cfg_burst_length == 8)
                        begin
                            split_col_addr = {incrmntd_col_addr[CFG_MEM_IF_COL_WIDTH-1:3],3'b000};
                        end
                    else // if (cfg_burst_length == 16)
                        begin
                            split_col_addr = {incrmntd_col_addr[CFG_MEM_IF_COL_WIDTH-1:4],4'b0000};
                        end
                end
        end
    
    // Buffered command info, to be used in split process
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    buf_read_req    <= 1'b0;
                    buf_write_req   <= 1'b0;
                    buf_autopch_req <= 1'b0;
                    buf_multicast   <= 1'b0;
                    buf_priority    <= 1'b0;
                    buf_localid     <= 0;
                end
            else
                begin
                    if (copy)
                        begin
                            buf_read_req    <= cmd_read;
                            buf_write_req   <= cmd_write;
                            buf_autopch_req <= cmd_autoprecharge;
                            buf_multicast   <= cmd_multicast;
                            buf_priority    <= cmd_priority;
                            buf_localid     <= cmd_id;
                        end
                end
        end
    
    // Keep track of command size during a split process
    // will keep decreasing when a split command was sent to TBP
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    buf_size <= 0;
                end
            else
                begin
                    if (copy)
                        begin
                            buf_size <= cmd_size + unaligned_burst;
                        end
                    else if (!registered && buf_size > native_size && ~mux_busy)
                        begin
                            buf_size <= buf_size - native_size;
                        end
                end
        end
    
    always @(*)
        begin
            decrmntd_size = buf_size - native_size;
        end
    
    // Keep track of command address during a split process
    // will keep increasing when a split command was sent to TBP
    // also takes into account address order
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    buf_cs_addr     <=  0;
                    buf_bank_addr   <=  0;
                    buf_row_addr    <=  0;
                    buf_col_addr    <=  0;
                end
            else
                if (copy)
                    begin
                        buf_cs_addr     <=  int_cs_addr;
                        buf_bank_addr   <=  int_bank_addr;
                        buf_row_addr    <=  int_row_addr;
                        buf_col_addr    <=  int_col_addr;
                    end
                else if (registered || (generating && ~mux_busy))
                    if ((cfg_burst_length == 16 && buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:4] == max_col_from_csr[CFG_MEM_IF_COL_WIDTH-1:4])
                        ||
                        (cfg_burst_length == 8 && buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:3] == max_col_from_csr[CFG_MEM_IF_COL_WIDTH-1:3])
                        ||
                        (cfg_burst_length == 4 && buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:2] == max_col_from_csr[CFG_MEM_IF_COL_WIDTH-1:2])
                        ||
                        (cfg_burst_length == 2 && buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:1] == max_col_from_csr[CFG_MEM_IF_COL_WIDTH-1:1])
                        )
                        begin
                            if (cfg_burst_length == 16)
                                buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:4]   <=  0;
                            else if (cfg_burst_length == 8)
                                buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:3]   <=  0;
                            else if (cfg_burst_length == 4)
                                buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:2]   <=  0;
                            else //  if (cfg_burst_length == 2)
                                buf_col_addr[CFG_MEM_IF_COL_WIDTH-1:1]   <=  0;
                            
                            if (cfg_addr_order == `MMR_ADDR_ORDER_ROW_CS_BA_COL) // 2 is rowchipbankcol
                                begin
                                    if (buf_bank_addr == max_bank_from_csr)
                                        begin
                                            buf_bank_addr <=  0;
                                            if (buf_cs_addr == max_chip_from_csr)
                                                begin
                                                    buf_cs_addr    <=  0;
                                                    if (buf_row_addr == max_row_from_csr)
                                                        buf_row_addr <=  0;
                                                    else
                                                        buf_row_addr <=  buf_row_addr + 1'b1;
                                                end
                                            else
                                                buf_cs_addr <=  buf_cs_addr + 1'b1;
                                        end
                                    else
                                        buf_bank_addr <=  buf_bank_addr + 1'b1;
                                end
                            else if (cfg_addr_order == `MMR_ADDR_ORDER_CS_BA_ROW_COL) // 1 is chipbankrowcol
                                begin
                                    if (buf_row_addr == max_row_from_csr)
                                        begin
                                            buf_row_addr <=  0;
                                            if (buf_bank_addr == max_bank_from_csr)
                                                begin
                                                    buf_bank_addr <=  0;
                                                    if (buf_cs_addr == max_chip_from_csr)
                                                        buf_cs_addr    <=  0;
                                                    else
                                                        buf_cs_addr <=  buf_cs_addr + 1'b1;
                                                end
                                            else
                                                buf_bank_addr <=  buf_bank_addr + 1'b1;
                                        end
                                    else
                                        buf_row_addr <=  buf_row_addr + 1'b1;
                                end
                            else // 0 is chiprowbankcol
                                begin
                                    if (buf_bank_addr == max_bank_from_csr)
                                        begin
                                            buf_bank_addr <=  0;
                                            if (buf_row_addr == max_row_from_csr)
                                                begin
                                                    buf_row_addr <=  0;
                                                    if (buf_cs_addr == max_chip_from_csr)
                                                        buf_cs_addr    <=  0;
                                                    else
                                                        buf_cs_addr <=  buf_cs_addr + 1'b1;
                                                end
                                            else
                                                buf_row_addr <=  buf_row_addr + 1'b1;
                                        end
                                    else
                                        buf_bank_addr <=  buf_bank_addr + 1'b1;
                                end
                        end
                    else
                        buf_col_addr <=  buf_col_addr + cfg_burst_length;
        end
    
    always @(*)
        begin
            incrmntd_cs_addr    =   buf_cs_addr;
            incrmntd_bank_addr  =   buf_bank_addr;
            incrmntd_row_addr   =   buf_row_addr;
            incrmntd_col_addr   =   buf_col_addr;
        end
    
    //=======================   end of burst splitting logic   ===========================
    
    //======================   ecc mux start   ========================
    // ECC process info
    always @ (*)
        begin
            ecc_int_combi      = ecc_int;
            correct_combi      = correct;
            partial_combi      = partial;
            errcmd_ready_combi = errcmd_ready;
            ecc_dataid_combi   = ecc_dataid;
            
            if (partial)
                begin
                    if (ecc_write && !queue_full && wdatap_free_id_valid) // deassert partial after ECC write was sent to TBP
                        begin
                            partial_combi = 1'b0;
                            ecc_int_combi = 1'b0;
                        end
                end
            else if (correct)
                begin
                    errcmd_ready_combi = 1'b0;
                    if (ecc_write && !queue_full && wdatap_free_id_valid) // deassert correct after ECC write was sent to TBP
                        begin
                            correct_combi = 1'b0;
                            ecc_int_combi = 1'b0;
                        end
                end
            else if (cfg_enable_ecc && errcmd_valid) // if there is a auto correction request
                begin
                    ecc_int_combi      = 1'b1;
                    correct_combi      = 1'b1;
                    partial_combi      = 1'b0;
                    errcmd_ready_combi = 1'b1;
                end
            else if ((cfg_enable_no_dm || cfg_enable_ecc) && split_write && !mux_busy) // if there is a write request in no-DM or ECC case
                begin
                    ecc_int_combi    = 1'b1;
                    correct_combi    = 1'b0;
                    partial_combi    = 1'b1;
                    ecc_dataid_combi = wdatap_free_id_dataid;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    ecc_int      <= 0;
                    correct      <= 0;
                    partial      <= 0;
                    errcmd_ready <= 0;
                    ecc_dataid   <= 0;
                end
            else
                begin
                    ecc_int      <= ecc_int_combi;
                    correct      <= correct_combi;
                    partial      <= partial_combi;
                    errcmd_ready <= errcmd_ready_combi;
                    ecc_dataid   <= ecc_dataid_combi;
                end
        end
    
    // Buffer for ECC command information
    always @ (*)
        begin
            if (partial || correct)
                begin
                    ecc_cs_addr_combi   = ecc_cs_addr;
                    ecc_bank_addr_combi = ecc_bank_addr;
                    ecc_row_addr_combi  = ecc_row_addr;
                    ecc_col_addr_combi  = ecc_col_addr;
                    ecc_size_combi      = ecc_size;
                    ecc_autopch_combi   = ecc_autopch;
                    ecc_multicast_combi = ecc_multicast;
                    ecc_localid_combi   = ecc_localid;
                    ecc_priority_combi  = ecc_priority;
                end
            else if (cfg_enable_ecc && errcmd_valid) // take in error command info
                begin
                    ecc_cs_addr_combi   = errcmd_chipsel;
                    ecc_bank_addr_combi = errcmd_bank;
                    ecc_row_addr_combi  = errcmd_row;
                    ecc_col_addr_combi  = errcmd_column;
                    ecc_size_combi      = errcmd_size;
                    ecc_autopch_combi   = 1'b0;
                    ecc_multicast_combi = 1'b0;
                    ecc_localid_combi   = errcmd_localid;
                    ecc_priority_combi  = 1'b0;
                end
            else if ((cfg_enable_no_dm || cfg_enable_ecc) && split_write && !mux_busy) // take in command info from split logic
                begin
                    ecc_cs_addr_combi   = split_cs_addr;
                    ecc_bank_addr_combi = split_bank_addr;
                    ecc_row_addr_combi  = split_row_addr;
                    ecc_col_addr_combi  = split_col_addr;
                    ecc_size_combi      = split_size;
                    ecc_autopch_combi   = split_autopch;
                    ecc_multicast_combi = split_multicast;
                    ecc_localid_combi   = split_localid;
                    ecc_priority_combi  = split_priority;
                end
            else
                begin
                    ecc_cs_addr_combi   = ecc_cs_addr;
                    ecc_bank_addr_combi = ecc_bank_addr;
                    ecc_row_addr_combi  = ecc_row_addr;
                    ecc_col_addr_combi  = ecc_col_addr;
                    ecc_size_combi      = ecc_size;
                    ecc_autopch_combi   = ecc_autopch;
                    ecc_multicast_combi = ecc_multicast;
                    ecc_localid_combi   = ecc_localid;
                    ecc_priority_combi  = ecc_priority;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    ecc_cs_addr   <= 0;
                    ecc_bank_addr <= 0;
                    ecc_row_addr  <= 0;
                    ecc_col_addr  <= 0;
                    ecc_size      <= 0;
                    ecc_autopch   <= 0;
                    ecc_multicast <= 0;
                    ecc_localid   <= 0;
                    ecc_priority  <= 0;
                end
            else
                begin
                    ecc_cs_addr   <=  ecc_cs_addr_combi;
                    ecc_bank_addr <=  ecc_bank_addr_combi;
                    ecc_row_addr  <=  ecc_row_addr_combi;
                    ecc_col_addr  <=  ecc_col_addr_combi;
                    ecc_size      <=  ecc_size_combi;
                    ecc_autopch   <=  ecc_autopch_combi;
                    ecc_multicast <=  ecc_multicast_combi;
                    ecc_localid   <=  ecc_localid_combi;
                    ecc_priority  <=  ecc_priority_combi;
                end
        end
    
    // Logic to determine when to issue ECC read/write request
    // based on partial_be info from wdata path
    // if partial_be is high, it issues a read-modify-write command
    // else issues normal write command
    always @ (*)
        begin
            ecc_read_combi    = ecc_read;
            ecc_write_combi   = ecc_write;
            partial_opr_combi = partial_opr;
            
            if (partial)
                begin
                    if (ecc_write && !queue_full && wdatap_free_id_valid)
                        begin
                            ecc_write_combi   = 1'b0;
                            partial_opr_combi = 1'b0;
                        end
                    else if (ecc_read && !queue_full && rdatap_free_id_valid)
                        begin
                            ecc_read_combi    = 1'b0;
                        end
                    else if (data_complete[0]) // wait for data_complete from wdata path
                        begin
                            if (!data_partial_be) // if not partial_be, issues normal write
                                begin
                                    ecc_write_combi   = 1'b1;
                                end
                            else // else issues a RMW's read
                                begin
                                    ecc_read_combi    = 1'b1;
                                    partial_opr_combi = 1'b1;
                                end
                        end
                    else if (!ecc_write && !ecc_read)
                        begin
                            if (data_rmw_complete) // waits till RMW data is complate before issuing RMW's write
                                begin
                                    ecc_write_combi   = 1'b1;
                                end
                            else
                                begin
                                    ecc_write_combi   = 1'b0;
                                end
                        end
                end
            else if (correct)
                begin
                    if (ecc_write && !queue_full && wdatap_free_id_valid)
                        begin
                            ecc_write_combi   = 1'b0;
                        end
                    else if (ecc_read && !queue_full && rdatap_free_id_valid)
                        begin
                            ecc_read_combi    = 1'b0;
                        end
                    else if (!ecc_write && !ecc_read)
                        begin
                            if (data_rmw_complete) // waits till RMW data is complate before issuing RMW's write
                                ecc_write_combi   = 1'b1;
                            else
                                ecc_write_combi   = 1'b0;
                        end
                end
            else if (cfg_enable_ecc && errcmd_valid) // issues a RMW's read when there is a error correction
                begin
                    ecc_read_combi        = 1'b1;
                    ecc_write_combi       = 1'b0;
                end
            else if ((cfg_enable_no_dm || cfg_enable_ecc) && split_write && !mux_busy)
                begin
                    ecc_read_combi        = 1'b0;
                    ecc_write_combi       = 1'b0;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    ecc_read    <= 1'b0;
                    ecc_write   <= 1'b0;
                    partial_opr <= 1'b0;
                end
            else
                begin
                    ecc_read    <= ecc_read_combi;
                    ecc_write   <= ecc_write_combi;
                    partial_opr <= partial_opr_combi;
                end
        end
    
    // We only need to gate split_read/write in non cmd_gen registered output mode
    assign  mux_busy            = (
                                    queue_full |
                                    errcmd_valid |
                                    (
                                        (cfg_enable_no_dm | cfg_enable_ecc) &
                                        (
                                            ecc_int |
                                            (
                                                !(CFG_CMD_GEN_OUTPUT_REG & !CFG_ENABLE_QUEUE) &
                                                (
                                                    (split_read & ~rdatap_free_id_valid) |
                                                    (split_write & ~wdatap_free_id_valid)
                                                )
                                            )
                                        )
                                    )
                                  );
    
    assign  muxed_cs_addr           = ecc_int                              ? ecc_cs_addr                                                             : split_cs_addr;
    assign  muxed_bank_addr         = ecc_int                              ? ecc_bank_addr                                                           : split_bank_addr;
    assign  muxed_row_addr          = ecc_int                              ? ecc_row_addr                                                            : split_row_addr;
    assign  muxed_col_addr          = ecc_int                              ? ecc_col_addr                                                            : split_col_addr;
    assign  muxed_read              = ecc_int                              ? (CFG_CMD_GEN_OUTPUT_REG ? (ecc_read & rdatap_free_id_valid) : ecc_read) : split_read  & ~errcmd_valid; // We only need to check for free ID valid in CMD_GEN_OUTPUT_REG mode
    assign  muxed_write             = (cfg_enable_no_dm || cfg_enable_ecc) ? ecc_write                                                               : split_write & ~errcmd_valid;
    assign  muxed_size              = ecc_int                              ? ecc_size                                                                : split_size;
    assign  muxed_autopch           = ecc_int                              ? ecc_autopch                                                             : split_autopch;
    assign  muxed_multicast         = ecc_int                              ? ecc_multicast                                                           : split_multicast;
    assign  muxed_localid           = ecc_int                              ? ecc_localid                                                             : split_localid;
    assign  muxed_priority          = ecc_int                              ? ecc_priority                                                            : split_priority;
    assign  muxed_dataid            = ecc_int                              ? ecc_dataid                                                              : rdatap_free_id_dataid;
    assign  muxed_complete          = ecc_int                              ? 1'b1                                                                    : split_read;
    assign  muxed_correct           = ecc_int                              ? correct                                                                 : 1'b0;
    assign  muxed_partial           = ecc_int                              ? partial_opr                                                             : 1'b0;
    
    assign  muxed_same_chipsel_addr = ecc_int_r                            ? ecc_same_chipsel_addr                                                   : split_same_chipsel_addr;
    assign  muxed_same_bank_addr    = ecc_int_r                            ? ecc_same_bank_addr                                                      : split_same_bank_addr;
    assign  muxed_same_row_addr_0   = ecc_int_r                            ? ecc_same_row_addr_0                                                     : split_same_row_addr_0;
    assign  muxed_same_row_addr_1   = ecc_int_r                            ? ecc_same_row_addr_1                                                     : split_same_row_addr_1;
    assign  muxed_same_row_addr_2   = ecc_int_r                            ? ecc_same_row_addr_2                                                     : split_same_row_addr_2;
    assign  muxed_same_row_addr_3   = ecc_int_r                            ? ecc_same_row_addr_3                                                     : split_same_row_addr_3;
    assign  muxed_same_col_addr     = ecc_int_r                            ? ecc_same_col_addr                                                       : split_same_col_addr;
    assign  muxed_same_read_cmd     = ecc_int_r                            ? ecc_same_read_cmd                                                       : split_same_read_cmd;
    assign  muxed_same_write_cmd    = ecc_int_r                            ? ecc_same_write_cmd                                                      : split_same_write_cmd;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    ecc_int_r <= 1'b0;
                end
            else
                begin
                    ecc_int_r <= ecc_int;
                end
        end
    
    // Address comparison logic
    always @ (*)
        begin
            for(j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                begin
                    // Chipselect address
                    if (split_cs_addr == chipsel[j])
                        begin
                            split_same_chipsel_addr_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_chipsel_addr_combi[j] = 1'b0;
                        end
                    
                    // Bank addr
                    if (split_bank_addr == bank[j])
                        begin
                            split_same_bank_addr_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_bank_addr_combi[j] = 1'b0;
                        end
                    
                    // Row addr
                    if (split_row_addr[(1 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (0 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][(1 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (0 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            split_same_row_addr_0_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_row_addr_0_combi[j] = 1'b0;
                        end
                    
                    if (split_row_addr[(2 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (1 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][(2 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (1 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            split_same_row_addr_1_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_row_addr_1_combi[j] = 1'b0;
                        end
                    
                    if (split_row_addr[(3 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (2 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][(3 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (2 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            split_same_row_addr_2_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_row_addr_2_combi[j] = 1'b0;
                        end
                    
                    if (split_row_addr[CFG_MEM_IF_ROW_WIDTH             - 1 : (3 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][CFG_MEM_IF_ROW_WIDTH             - 1 : (3 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            split_same_row_addr_3_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_row_addr_3_combi[j] = 1'b0;
                        end
                    
                    // Col addr
                    if (split_col_addr == col[j])
                        begin
                            split_same_col_addr_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_col_addr_combi[j] = 1'b0;
                        end
                    
                    // Read command
                    if (split_read == read[j])
                        begin
                            split_same_read_cmd_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_read_cmd_combi[j] = 1'b0;
                        end
                    
                    // Write command
                    if (split_write == write[j])
                        begin
                            split_same_write_cmd_combi[j] = 1'b1;
                        end
                    else
                        begin
                            split_same_write_cmd_combi[j] = 1'b0;
                        end
                end
        end
    
    always @ (*)
        begin
            for(j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                begin
                    // Chipselect address
                    if (ecc_cs_addr == chipsel[j])
                        begin
                            ecc_same_chipsel_addr_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_chipsel_addr_combi[j] = 1'b0;
                        end
                    
                    // Bank addr
                    if (ecc_bank_addr == bank[j])
                        begin
                            ecc_same_bank_addr_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_bank_addr_combi[j] = 1'b0;
                        end
                    
                    // Row addr
                    if (ecc_row_addr[(1 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (0 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][(1 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (0 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            ecc_same_row_addr_0_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_row_addr_0_combi[j] = 1'b0;
                        end
                    
                    if (ecc_row_addr[(2 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (1 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][(2 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (1 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            ecc_same_row_addr_1_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_row_addr_1_combi[j] = 1'b0;
                        end
                    
                    if (ecc_row_addr[(3 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (2 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][(3 * (CFG_MEM_IF_ROW_WIDTH / 4)) - 1 : (2 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            ecc_same_row_addr_2_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_row_addr_2_combi[j] = 1'b0;
                        end
                    
                    if (ecc_row_addr[CFG_MEM_IF_ROW_WIDTH             - 1 : (3 * (CFG_MEM_IF_ROW_WIDTH / 4))] == row[j][CFG_MEM_IF_ROW_WIDTH             - 1 : (3 * (CFG_MEM_IF_ROW_WIDTH / 4))])
                        begin
                            ecc_same_row_addr_3_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_row_addr_3_combi[j] = 1'b0;
                        end
                    
                    // Col addr
                    if (ecc_col_addr == col[j])
                        begin
                            ecc_same_col_addr_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_col_addr_combi[j] = 1'b0;
                        end
                    
                    // Read command
                    if (ecc_read == read[j])
                        begin
                            ecc_same_read_cmd_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_read_cmd_combi[j] = 1'b0;
                        end
                    
                    // Write command
                    if (ecc_write == write[j])
                        begin
                            ecc_same_write_cmd_combi[j] = 1'b1;
                        end
                    else
                        begin
                            ecc_same_write_cmd_combi[j] = 1'b0;
                        end
                end
        end
    
    generate
        if (CFG_CMD_GEN_OUTPUT_REG & !CFG_ENABLE_QUEUE)
            begin
                always @ (*)
                    begin
                        proc_busy_sig        = queue_full;
                        proc_load_sig        = (proc_read_sig | proc_write_sig) & ((proc_read_sig & rdatap_free_id_valid) | (proc_write_sig & wdatap_free_id_valid));
                    end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            begin
                                proc_write_sig       <= 0;
                                proc_read_sig        <= 0;
                                proc_size_sig        <= 0;
                                proc_localid_sig     <= 0;
                                proc_load_dataid_sig <= 0;
                                
                                proc_ecc_busy_sig    <= 0;
                            end
                        else
                            begin
                                if (proc_busy_sig)
                                    begin
                                        // Do nothing, keep old value
                                    end
                                else
                                    begin
                                        proc_load_dataid_sig <= ~(ecc_int & (ecc_read | ecc_write));
                                        
                                        if (ecc_int)
                                            begin
                                                proc_write_sig       <= ecc_write & correct;
                                                proc_read_sig        <= ecc_read;
                                                proc_size_sig        <= ecc_size;
                                                proc_localid_sig     <= ecc_localid;
                                                
                                                proc_ecc_busy_sig    <= (ecc_read & ~rdatap_free_id_valid) | ((ecc_write & correct) & ~wdatap_free_id_valid);
                                            end
                                        else
                                            begin
                                                proc_write_sig       <= split_write & ~errcmd_valid;
                                                proc_read_sig        <= split_read  & ~errcmd_valid;
                                                proc_size_sig        <= split_size;
                                                proc_localid_sig     <= split_localid;
                                                
                                                proc_ecc_busy_sig    <= 1'b0;
                                            end
                                    end
                            end
                    end
                
                always @ (posedge ctl_clk or negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            begin
                                split_same_chipsel_addr <= 0;
                                split_same_bank_addr    <= 0;
                                split_same_row_addr_0   <= 0;
                                split_same_row_addr_1   <= 0;
                                split_same_row_addr_2   <= 0;
                                split_same_row_addr_3   <= 0;
                                split_same_col_addr     <= 0;
                                split_same_read_cmd     <= 0;
                                split_same_write_cmd    <= 0;
                                
                                ecc_same_chipsel_addr   <= 0;
                                ecc_same_bank_addr      <= 0;
                                ecc_same_row_addr_0     <= 0;
                                ecc_same_row_addr_1     <= 0;
                                ecc_same_row_addr_2     <= 0;
                                ecc_same_row_addr_3     <= 0;
                                ecc_same_col_addr       <= 0;
                                ecc_same_read_cmd       <= 0;
                                ecc_same_write_cmd      <= 0;
                            end
                        else
                            begin
                                split_same_chipsel_addr <= split_same_chipsel_addr_combi;
                                split_same_bank_addr    <= split_same_bank_addr_combi;
                                split_same_row_addr_0   <= split_same_row_addr_0_combi;
                                split_same_row_addr_1   <= split_same_row_addr_1_combi;
                                split_same_row_addr_2   <= split_same_row_addr_2_combi;
                                split_same_row_addr_3   <= split_same_row_addr_3_combi;
                                split_same_col_addr     <= split_same_col_addr_combi;
                                split_same_read_cmd     <= split_same_read_cmd_combi;
                                split_same_write_cmd    <= split_same_write_cmd_combi;
                                
                                ecc_same_chipsel_addr   <= ecc_same_chipsel_addr_combi;
                                ecc_same_bank_addr      <= ecc_same_bank_addr_combi;
                                ecc_same_row_addr_0     <= ecc_same_row_addr_0_combi;
                                ecc_same_row_addr_1     <= ecc_same_row_addr_1_combi;
                                ecc_same_row_addr_2     <= ecc_same_row_addr_2_combi;
                                ecc_same_row_addr_3     <= ecc_same_row_addr_3_combi;
                                ecc_same_col_addr       <= ecc_same_col_addr_combi;
                                ecc_same_read_cmd       <= ecc_same_read_cmd_combi;
                                ecc_same_write_cmd      <= ecc_same_write_cmd_combi;
                            end
                    end
            end
        else
            begin
                always @ (*)
                    begin
                        proc_busy_sig        = queue_full;
                        proc_ecc_busy_sig    = zero;
                        proc_load_sig        = (proc_read_sig | proc_write_sig) & ((proc_read_sig & rdatap_free_id_valid) | (proc_write_sig & wdatap_free_id_valid));
                        proc_load_dataid_sig = ~(ecc_int & (ecc_read | ecc_write));
                        proc_write_sig       = ecc_int ? ecc_write & correct : split_write & ~errcmd_valid;
                        proc_read_sig        = ecc_int ? ecc_read            : split_read  & ~errcmd_valid;
                        proc_size_sig        = ecc_int ? ecc_size            : split_size;
                        proc_localid_sig     = ecc_int ? ecc_localid         : split_localid;
                    end
                
                always @ (*)
                    begin
                        split_same_chipsel_addr = split_same_chipsel_addr_combi;
                        split_same_bank_addr    = split_same_bank_addr_combi;
                        split_same_row_addr_0   = split_same_row_addr_0_combi;
                        split_same_row_addr_1   = split_same_row_addr_1_combi;
                        split_same_row_addr_2   = split_same_row_addr_2_combi;
                        split_same_row_addr_3   = split_same_row_addr_3_combi;
                        split_same_col_addr     = split_same_col_addr_combi;
                        split_same_read_cmd     = split_same_read_cmd_combi;
                        split_same_write_cmd    = split_same_write_cmd_combi;
                        
                        ecc_same_chipsel_addr   = ecc_same_chipsel_addr_combi;
                        ecc_same_bank_addr      = ecc_same_bank_addr_combi;
                        ecc_same_row_addr_0     = ecc_same_row_addr_0_combi;
                        ecc_same_row_addr_1     = ecc_same_row_addr_1_combi;
                        ecc_same_row_addr_2     = ecc_same_row_addr_2_combi;
                        ecc_same_row_addr_3     = ecc_same_row_addr_3_combi;
                        ecc_same_col_addr       = ecc_same_col_addr_combi;
                        ecc_same_read_cmd       = ecc_same_read_cmd_combi;
                        ecc_same_write_cmd      = ecc_same_write_cmd_combi;
                    end
            end
    endgenerate
    
    //======================   ecc mux end   ========================
    
    //======================   sequential address detector   ========================
    
    //Last pipeline entry
    always @(posedge ctl_clk or negedge ctl_reset_n) begin
         if (!ctl_reset_n)
             begin
                last_read_req   <=  1'b0;
                last_write_req  <=  1'b0;
                last_chip_addr  <=  {CFG_MEM_IF_CS_WIDTH{1'b0}};
                last_row_addr   <=  {CFG_MEM_IF_ROW_WIDTH{1'b0}};
                last_bank_addr  <=  {CFG_MEM_IF_BA_WIDTH{1'b0}};
                last_col_addr   <=  {CFG_MEM_IF_COL_WIDTH{1'b0}};
                last_size       <=  {CFG_INT_SIZE_WIDTH{1'b0}};
                last_multicast  <=  1'b0;
             end
         else if (write_to_queue)
             begin
                last_read_req   <=  muxed_read;
                last_write_req  <=  muxed_write;
                last_multicast  <=  muxed_multicast;
                last_chip_addr  <=  muxed_cs_addr;
                last_bank_addr  <=  muxed_bank_addr;
                last_row_addr   <=  muxed_row_addr;
                last_col_addr   <=  muxed_col_addr;
                last_size       <=  muxed_size;
             end
         else if (can_merge)
             begin
                 last_size      <=  2;
             end
    end
    
    //Second last pipeline entry
    always @(posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    last2_read_req  <=  1'b0;
                    last2_write_req <=  1'b0;
                    last2_chip_addr <=  {CFG_MEM_IF_CS_WIDTH{1'b0}};
                    last2_row_addr  <=  {CFG_MEM_IF_ROW_WIDTH{1'b0}};
                    last2_bank_addr <=  {CFG_MEM_IF_BA_WIDTH{1'b0}};
                    last2_col_addr  <=  {CFG_MEM_IF_COL_WIDTH{1'b0}};
                    last2_size      <=  {CFG_INT_SIZE_WIDTH{1'b0}};
                    last2_multicast <=  1'b0;
                end
            else if (write_to_queue)
                begin
                    last2_read_req  <=  last_read_req;
                    last2_write_req <=  last_write_req;
                    last2_multicast <=  last_multicast;
                    last2_chip_addr <=  last_chip_addr;
                    last2_bank_addr <=  last_bank_addr;
                    last2_row_addr  <=  last_row_addr;
                    last2_col_addr  <=  last_col_addr;
                    last2_size      <=  last_size;
                end
        end
    
    always @(posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    last           <=   0;
                    last_minus_one <=   0;
                    last_minus_two <=   0;
                end
            else
                begin
                    if (fetch) // fetch and write
                        begin
                            if (can_merge && last != 1)
                                begin
                                    if (write_to_queue)
                                        begin
                                            last           <=  last - 1;
                                            last_minus_one <=  last - 2;
                                            last_minus_two <=  last - 3;
                                        end
                                    else
                                        begin
                                            last           <=  last - 2;
                                            last_minus_one <=  last - 3;
                                            last_minus_two <=  last - 4;
                                        end
                                end
                            else
                                begin
                                    if (write_to_queue) begin
                                        // do nothing
                                    end
                                    else if (last != 0)
                                        begin
                                            last           <=  last - 1;
                                            last_minus_one <=  last - 2;
                                            last_minus_two <=  last - 3;
                                        end
                                end
                        end
                    else if (write_to_queue) // write only
                        begin
                            if (can_merge)
                                begin
                                    // do nothing
                                end
                            else if (!queue_empty)
                                begin
                                    last           <=  last + 1;
                                    last_minus_one <=  last;
                                    last_minus_two <=  last - 1;
                                end
                        end
                    else if (can_merge)
                        begin
                            last           <=  last - 1;
                            last_minus_one <=  last - 2;
                            last_minus_two <=  last - 3;
                        end
                end
        end
    
    // Merging logic
    assign  can_merge   =   (CFG_ENABLE_BURST_MERGE == 1) ?
                            last != 0
                            & pipefull[last]
                            & last2_read_req == last_read_req
                            & last2_write_req == last_write_req
                            & last2_multicast == last_multicast
                            & last2_chip_addr == last_chip_addr
                            & last2_bank_addr == last_bank_addr
                            & last2_row_addr == last_row_addr
                            & ((CFG_DWIDTH_RATIO == 2) ? (last2_col_addr[CFG_MEM_IF_COL_WIDTH-1 : 2] == last_col_addr[CFG_MEM_IF_COL_WIDTH-1 : 2]) : (last2_col_addr[CFG_MEM_IF_COL_WIDTH-1 : 3] == last_col_addr[CFG_MEM_IF_COL_WIDTH-1 : 3]) )
                            & ((CFG_DWIDTH_RATIO == 2) ? (last2_col_addr[1] == 0 & last_col_addr[1] == 1) : (last2_col_addr[2] == 0 & last_col_addr[2] == 1) )
                            & last2_size == 1 & last_size == 1
                            :
                            1'b0;
    
    //===================   end of sequential address detector   ====================
    
    //===============================    queue    ===================================
    // mapping of buffer_input
    assign buffer_input = {muxed_read,muxed_write,muxed_multicast,muxed_autopch,muxed_priority,muxed_complete,muxed_correct,muxed_partial,muxed_dataid,muxed_localid,muxed_size,muxed_cs_addr,muxed_row_addr,muxed_bank_addr,muxed_col_addr};
    
    generate
        if (CFG_ENABLE_QUEUE == 1)
            begin
                reg     [CFG_CTL_TBP_NUM-1:0]        int_same_chipsel_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]        int_same_bank_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]        int_same_row_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]        int_same_col_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]        int_same_read_cmd;
                reg     [CFG_CTL_TBP_NUM-1:0]        int_same_write_cmd;
                
                reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] int_same_shadow_chipsel_addr;
                reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] int_same_shadow_bank_addr;
                reg     [CFG_CTL_SHADOW_TBP_NUM-1:0] int_same_shadow_row_addr;
                
                // TBP address and command comparison logic
                always @ (*)
                    begin
                        for(j=0; j<CFG_CTL_TBP_NUM; j=j+1)
                            begin
                                int_same_chipsel_addr = muxed_same_chipsel_addr;
                                int_same_bank_addr    = muxed_same_bank_addr;
                                int_same_row_addr     = muxed_same_row_addr_0 & muxed_same_row_addr_1 & muxed_same_row_addr_2 & muxed_same_row_addr_3;
                                int_same_col_addr     = muxed_same_col_addr;
                                int_same_read_cmd     = muxed_same_read_cmd;
                                int_same_write_cmd    = muxed_same_write_cmd;
                            end
                    end
                
                // Shadow TBP address and command comparison logic
                always @ (*)
                    begin
                        for(j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                            begin
                                // Chipselect address
                                if (cmd_gen_chipsel == shadow_chipsel[j])
                                    begin
                                        int_same_shadow_chipsel_addr[j] = 1'b1;
                                    end
                                else
                                    begin
                                        int_same_shadow_chipsel_addr[j] = 1'b0;
                                    end
                                
                                // Bank addr
                                if (cmd_gen_bank == shadow_bank[j])
                                    begin
                                        int_same_shadow_bank_addr[j] = 1'b1;
                                    end
                                else
                                    begin
                                        int_same_shadow_bank_addr[j] = 1'b0;
                                    end
                                
                                // Row addr
                                if (cmd_gen_row == shadow_row[j])
                                    begin
                                        int_same_shadow_row_addr[j] = 1'b1;
                                    end
                                else
                                    begin
                                        int_same_shadow_row_addr[j] = 1'b0;
                                    end
                            end
                    end
                
                always @ (*)
                    begin
                        same_chipsel_addr        = int_same_chipsel_addr;
                        same_bank_addr           = int_same_bank_addr;
                        same_row_addr            = int_same_row_addr;
                        same_col_addr            = int_same_col_addr;
                        same_read_cmd            = int_same_read_cmd;
                        same_write_cmd           = int_same_write_cmd;
                        
                        same_shadow_chipsel_addr = int_same_shadow_chipsel_addr;
                        same_shadow_bank_addr    = int_same_shadow_bank_addr;
                        same_shadow_row_addr     = int_same_shadow_row_addr;
                    end
                
                assign queue_empty                      = !pipefull[0];
                assign queue_full                       = pipefull[CFG_CTL_QUEUE_DEPTH-1] | (~(cfg_enable_no_dm | cfg_enable_ecc) & ((cmd_gen_read & ~rdatap_free_id_valid) | (~cmd_gen_read & ~wdatap_free_id_valid)));
                
                assign cmd_gen_load                     = pipefull[0] & ((cfg_enable_no_dm | cfg_enable_ecc) | ((cmd_gen_read & rdatap_free_id_valid) | (~cmd_gen_read & wdatap_free_id_valid)));
                assign cmd_gen_read                     = pipe[0][BUFFER_WIDTH-1];
                assign cmd_gen_write                    = pipe[0][BUFFER_WIDTH-2];
                assign cmd_gen_multicast                = pipe[0][BUFFER_WIDTH-3];
                assign cmd_gen_autopch                  = pipe[0][BUFFER_WIDTH-4];
                assign cmd_gen_priority                 = pipe[0][BUFFER_WIDTH-5];
                assign cmd_gen_complete                 = pipe[0][BUFFER_WIDTH-6];
                assign cmd_gen_rmw_correct              = pipe[0][BUFFER_WIDTH-7];
                assign cmd_gen_rmw_partial              = pipe[0][BUFFER_WIDTH-8];
                assign cmd_gen_dataid                   = cmd_gen_read ? rdatap_free_id_dataid : wdatap_free_id_dataid;
                assign cmd_gen_localid                  = pipe[0][CFG_LOCAL_ID_WIDTH + CFG_INT_SIZE_WIDTH + CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_INT_SIZE_WIDTH + CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH];
                assign cmd_gen_size                     = pipe[0][CFG_INT_SIZE_WIDTH + CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH];
                assign cmd_gen_chipsel                  = pipe[0][CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH];
                assign cmd_gen_row                      = pipe[0][CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH];
                assign cmd_gen_bank                     = pipe[0][CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_COL_WIDTH];
                assign cmd_gen_col                      = pipe[0][CFG_MEM_IF_COL_WIDTH - 1 : 0];
                assign cmd_gen_same_chipsel_addr        = same_chipsel_addr;
                assign cmd_gen_same_bank_addr           = same_bank_addr;
                assign cmd_gen_same_row_addr            = same_row_addr;
                assign cmd_gen_same_col_addr            = same_col_addr;
                assign cmd_gen_same_read_cmd            = same_read_cmd;
                assign cmd_gen_same_write_cmd           = same_write_cmd;
                assign cmd_gen_same_shadow_chipsel_addr = same_shadow_chipsel_addr;
                assign cmd_gen_same_shadow_bank_addr    = same_shadow_bank_addr;
                assign cmd_gen_same_shadow_row_addr     = same_shadow_row_addr;
            end
        else
            begin
                wire                                     int_queue_full;
                
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_chipsel_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_bank_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_0;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_1;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_2;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_3;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_col_addr;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_read_cmd;
                reg     [CFG_CTL_TBP_NUM-1:0]            int_same_write_cmd;
                
                reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]     int_same_shadow_chipsel_addr;
                reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]     int_same_shadow_bank_addr;
                reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]     int_same_shadow_row_addr;
                
                reg                                      int_register_valid;
                
                reg     [CFG_MEM_IF_CS_WIDTH-1:0]        int_cmd_gen_chipsel;
                reg     [CFG_MEM_IF_BA_WIDTH-1:0]        int_cmd_gen_bank;
                reg     [CFG_MEM_IF_ROW_WIDTH-1:0]       int_cmd_gen_row;
                reg     [CFG_MEM_IF_COL_WIDTH-1:0]       int_cmd_gen_col;
                reg                                      int_cmd_gen_write;
                reg                                      int_cmd_gen_read;
                reg                                      int_cmd_gen_multicast;
                reg     [CFG_INT_SIZE_WIDTH-1:0]         int_cmd_gen_size;
                reg     [CFG_LOCAL_ID_WIDTH-1:0]         int_cmd_gen_localid;
                reg     [CFG_DATA_ID_WIDTH-1:0]          int_cmd_gen_dataid;
                reg                                      int_cmd_gen_priority;
                reg                                      int_cmd_gen_rmw_correct;
                reg                                      int_cmd_gen_rmw_partial;
                reg                                      int_cmd_gen_autopch;
                reg                                      int_cmd_gen_complete;
                
                reg     [CFG_DATA_ID_WIDTH-1:0]          int_cmd_gen_dataid_mux;
                
                // TBP address and command comparison logic
                always @ (*)
                    begin
                        int_same_chipsel_addr = muxed_same_chipsel_addr;
                        int_same_bank_addr    = muxed_same_bank_addr;
                        int_same_row_addr_0   = muxed_same_row_addr_0;
                        int_same_row_addr_1   = muxed_same_row_addr_1;
                        int_same_row_addr_2   = muxed_same_row_addr_2;
                        int_same_row_addr_3   = muxed_same_row_addr_3;
                        int_same_col_addr     = muxed_same_col_addr;
                        int_same_read_cmd     = muxed_same_read_cmd;
                        int_same_write_cmd    = muxed_same_write_cmd;
                    end
                
                // Shadow TBP address and command comparison logic
                always @ (*)
                    begin
                        for(j=0; j<CFG_CTL_SHADOW_TBP_NUM; j=j+1)
                            begin
                                if (int_queue_full)
                                    begin
                                        // Chipselect address
                                        if (int_cmd_gen_chipsel == shadow_chipsel[j])
                                            begin
                                                int_same_shadow_chipsel_addr[j] = 1'b1;
                                            end
                                        else
                                            begin
                                                int_same_shadow_chipsel_addr[j] = 1'b0;
                                            end
                                        
                                        // Bank addr
                                        if (int_cmd_gen_bank == shadow_bank[j])
                                            begin
                                                int_same_shadow_bank_addr[j] = 1'b1;
                                            end
                                        else
                                            begin
                                                int_same_shadow_bank_addr[j] = 1'b0;
                                            end
                                        
                                        // Row addr
                                        if (int_cmd_gen_row == shadow_row[j])
                                            begin
                                                int_same_shadow_row_addr[j] = 1'b1;
                                            end
                                        else
                                            begin
                                                int_same_shadow_row_addr[j] = 1'b0;
                                            end
                                    end
                                else
                                    begin
                                        // Chipselect address
                                        if (muxed_cs_addr == shadow_chipsel[j])
                                            begin
                                                int_same_shadow_chipsel_addr[j] = 1'b1;
                                            end
                                        else
                                            begin
                                                int_same_shadow_chipsel_addr[j] = 1'b0;
                                            end
                                        
                                        // Bank addr
                                        if (muxed_bank_addr == shadow_bank[j])
                                            begin
                                                int_same_shadow_bank_addr[j] = 1'b1;
                                            end
                                        else
                                            begin
                                                int_same_shadow_bank_addr[j] = 1'b0;
                                            end
                                        
                                        // Row addr
                                        if (muxed_row_addr == shadow_row[j])
                                            begin
                                                int_same_shadow_row_addr[j] = 1'b1;
                                            end
                                        else
                                            begin
                                                int_same_shadow_row_addr[j] = 1'b0;
                                            end
                                    end
                            end
                    end
                
                if (CFG_CMD_GEN_OUTPUT_REG)
                    begin
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_chipsel_addr_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_bank_addr_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_0_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_1_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_2_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_row_addr_3_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_col_addr_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_read_cmd_r;
                        reg     [CFG_CTL_TBP_NUM-1:0]            int_same_write_cmd_r;
                        
                        reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]     int_same_shadow_chipsel_addr_r;
                        reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]     int_same_shadow_bank_addr_r;
                        reg     [CFG_CTL_SHADOW_TBP_NUM-1:0]     int_same_shadow_row_addr_r;
                        
                        reg                                      int_ecc_int;
                        reg                                      int_queue_full_r;
                        
                        assign int_queue_full = (tbp_full & int_register_valid) | ((cmd_gen_read & ~rdatap_free_id_valid) | (~cmd_gen_read & ~wdatap_free_id_valid));
                        
                        always @ (posedge ctl_clk or negedge ctl_reset_n)
                            begin
                                if (!ctl_reset_n)
                                    begin
                                        int_queue_full_r <= 1'b0;
                                    end
                                else
                                    begin
                                        int_queue_full_r <= int_queue_full;
                                    end
                            end
                        
                        always @ (posedge ctl_clk or negedge ctl_reset_n)
                            begin
                                if (!ctl_reset_n)
                                    begin
                                        int_register_valid       <= 1'b0;
                                        
                                        int_cmd_gen_read         <= 0;
                                        int_cmd_gen_write        <= 0;
                                        int_cmd_gen_multicast    <= 0;
                                        int_cmd_gen_autopch      <= 0;
                                        int_cmd_gen_priority     <= 0;
                                        int_cmd_gen_complete     <= 0;
                                        int_cmd_gen_rmw_correct  <= 0;
                                        int_cmd_gen_rmw_partial  <= 0;
                                        int_cmd_gen_dataid       <= 0;
                                        int_cmd_gen_localid      <= 0;
                                        int_cmd_gen_size         <= 0;
                                        int_cmd_gen_chipsel      <= 0;
                                        int_cmd_gen_row          <= 0;
                                        int_cmd_gen_bank         <= 0;
                                        int_cmd_gen_col          <= 0;
                                        int_ecc_int              <= 0;
                                    end
                                else
                                    begin
                                        if (fetch)
                                            begin
                                                int_register_valid <= 1'b0;
                                                int_cmd_gen_read   <= 1'b0;
                                                int_cmd_gen_write  <= 1'b0;
                                            end
                                        
                                        if (!int_queue_full)
                                            begin
                                                if (muxed_read || muxed_write)
                                                    begin
                                                        int_register_valid <= 1'b1;
                                                    end
                                                
                                                int_cmd_gen_read         <= muxed_read;
                                                int_cmd_gen_write        <= muxed_write;
                                                int_cmd_gen_multicast    <= muxed_multicast;
                                                int_cmd_gen_autopch      <= muxed_autopch;
                                                int_cmd_gen_priority     <= muxed_priority;
                                                int_cmd_gen_complete     <= muxed_complete;
                                                int_cmd_gen_rmw_correct  <= muxed_correct;
                                                int_cmd_gen_rmw_partial  <= muxed_partial;
                                                int_cmd_gen_dataid       <= muxed_dataid;
                                                int_cmd_gen_localid      <= muxed_localid;
                                                int_cmd_gen_size         <= muxed_size;
                                                int_cmd_gen_chipsel      <= muxed_cs_addr;
                                                int_cmd_gen_row          <= muxed_row_addr;
                                                int_cmd_gen_bank         <= muxed_bank_addr;
                                                int_cmd_gen_col          <= muxed_col_addr;
                                                int_ecc_int              <= ecc_int;
                                            end
                                    end
                            end
                        
                        always @ (*)
                            begin
                                int_cmd_gen_dataid_mux = int_ecc_int ? int_cmd_gen_dataid : rdatap_free_id_dataid;
                            end
                        
                        always @ (posedge ctl_clk or negedge ctl_reset_n)
                            begin
                                if (!ctl_reset_n)
                                    begin
                                        int_same_chipsel_addr_r        <= 0;
                                        int_same_bank_addr_r           <= 0;
                                        int_same_row_addr_0_r          <= 0;
                                        int_same_row_addr_1_r          <= 0;
                                        int_same_row_addr_2_r          <= 0;
                                        int_same_row_addr_3_r          <= 0;
                                        int_same_col_addr_r            <= 0;
                                        int_same_read_cmd_r            <= 0;
                                        int_same_write_cmd_r           <= 0;
                                        
                                        int_same_shadow_chipsel_addr_r <= 0;
                                        int_same_shadow_bank_addr_r    <= 0;
                                        int_same_shadow_row_addr_r     <= 0;
                                    end
                                else
                                    begin
                                        if (int_queue_full & !int_queue_full_r) // positive edge detector
                                            begin
                                                int_same_chipsel_addr_r        <= int_same_chipsel_addr;
                                                int_same_bank_addr_r           <= int_same_bank_addr;
                                                int_same_row_addr_0_r          <= int_same_row_addr_0;
                                                int_same_row_addr_1_r          <= int_same_row_addr_1;
                                                int_same_row_addr_2_r          <= int_same_row_addr_2;
                                                int_same_row_addr_3_r          <= int_same_row_addr_3;
                                                int_same_col_addr_r            <= int_same_col_addr;
                                                int_same_read_cmd_r            <= int_same_read_cmd;
                                                int_same_write_cmd_r           <= int_same_write_cmd;
                                            end
                                        
                                        int_same_shadow_chipsel_addr_r <= int_same_shadow_chipsel_addr;
                                        int_same_shadow_bank_addr_r    <= int_same_shadow_bank_addr;
                                        int_same_shadow_row_addr_r     <= int_same_shadow_row_addr;
                                    end
                            end
                        
                        always @ (*)
                            begin
                                if (!int_queue_full_r)
                                    begin
                                        same_chipsel_addr        = int_same_chipsel_addr;
                                        same_bank_addr           = int_same_bank_addr;
                                        same_row_addr            = int_same_row_addr_0 & int_same_row_addr_1 & int_same_row_addr_2 & int_same_row_addr_3;
                                        same_col_addr            = int_same_col_addr;
                                        same_read_cmd            = int_same_read_cmd;
                                        same_write_cmd           = int_same_write_cmd;
                                    end
                                else
                                    begin
                                        same_chipsel_addr        = int_same_chipsel_addr_r;
                                        same_bank_addr           = int_same_bank_addr_r;
                                        same_row_addr            = int_same_row_addr_0_r & int_same_row_addr_1_r & int_same_row_addr_2_r & int_same_row_addr_3_r;
                                        same_col_addr            = int_same_col_addr_r;
                                        same_read_cmd            = int_same_read_cmd_r;
                                        same_write_cmd           = int_same_write_cmd_r;
                                    end
                                
                                same_shadow_chipsel_addr = int_same_shadow_chipsel_addr_r;
                                same_shadow_bank_addr    = int_same_shadow_bank_addr_r;
                                same_shadow_row_addr     = int_same_shadow_row_addr_r;
                            end
                    end
                else
                    begin
                        assign int_queue_full = tbp_full | (~(cfg_enable_no_dm | cfg_enable_ecc) & ((cmd_gen_read & ~rdatap_free_id_valid) | (~cmd_gen_read & ~wdatap_free_id_valid)));
                        
                        always @ (*)
                            begin
                                int_register_valid       = one;
                                int_cmd_gen_read         = muxed_read;
                                int_cmd_gen_write        = muxed_write;
                                int_cmd_gen_multicast    = muxed_multicast;
                                int_cmd_gen_autopch      = muxed_autopch;
                                int_cmd_gen_priority     = muxed_priority;
                                int_cmd_gen_complete     = muxed_complete;
                                int_cmd_gen_rmw_correct  = muxed_correct;
                                int_cmd_gen_rmw_partial  = muxed_partial;
                                int_cmd_gen_dataid       = muxed_dataid;
                                int_cmd_gen_localid      = muxed_localid;
                                int_cmd_gen_size         = muxed_size;
                                int_cmd_gen_chipsel      = muxed_cs_addr;
                                int_cmd_gen_row          = muxed_row_addr;
                                int_cmd_gen_bank         = muxed_bank_addr;
                                int_cmd_gen_col          = muxed_col_addr;
                            end
                        
                        always @ (*)
                            begin
                                int_cmd_gen_dataid_mux = int_cmd_gen_dataid;
                            end
                        
                        always @ (*)
                            begin
                                same_chipsel_addr        = int_same_chipsel_addr;
                                same_bank_addr           = int_same_bank_addr;
                                same_row_addr            = int_same_row_addr_0 & int_same_row_addr_1;
                                same_col_addr            = int_same_col_addr;
                                same_read_cmd            = int_same_read_cmd;
                                same_write_cmd           = int_same_write_cmd;
                                
                                same_shadow_chipsel_addr = int_same_shadow_chipsel_addr;
                                same_shadow_bank_addr    = int_same_shadow_bank_addr;
                                same_shadow_row_addr     = int_same_shadow_row_addr;
                            end
                    end
                
                assign queue_empty                      = 1;
                assign queue_full                       = int_queue_full;
                assign cmd_gen_load                     = (cmd_gen_read | cmd_gen_write) & ((cmd_gen_read & rdatap_free_id_valid) | (~cmd_gen_read & wdatap_free_id_valid));
                assign cmd_gen_read                     = int_cmd_gen_read;
                assign cmd_gen_write                    = int_cmd_gen_write;
                assign cmd_gen_multicast                = int_cmd_gen_multicast;
                assign cmd_gen_autopch                  = int_cmd_gen_autopch;
                assign cmd_gen_priority                 = int_cmd_gen_priority;
                assign cmd_gen_complete                 = int_cmd_gen_complete;
                assign cmd_gen_rmw_correct              = int_cmd_gen_rmw_correct;
                assign cmd_gen_rmw_partial              = int_cmd_gen_rmw_partial;
                assign cmd_gen_dataid                   = (cfg_enable_no_dm || cfg_enable_ecc) ? int_cmd_gen_dataid_mux : (cmd_gen_read ? rdatap_free_id_dataid : wdatap_free_id_dataid);
                assign cmd_gen_localid                  = int_cmd_gen_localid;
                assign cmd_gen_size                     = int_cmd_gen_size;
                assign cmd_gen_chipsel                  = int_cmd_gen_chipsel;
                assign cmd_gen_row                      = int_cmd_gen_row;
                assign cmd_gen_bank                     = int_cmd_gen_bank;
                assign cmd_gen_col                      = int_cmd_gen_col;
                assign cmd_gen_same_chipsel_addr        = same_chipsel_addr;
                assign cmd_gen_same_bank_addr           = same_bank_addr;
                assign cmd_gen_same_row_addr            = same_row_addr;
                assign cmd_gen_same_col_addr            = same_col_addr;
                assign cmd_gen_same_read_cmd            = same_read_cmd;
                assign cmd_gen_same_write_cmd           = same_write_cmd;
                assign cmd_gen_same_shadow_chipsel_addr = same_shadow_chipsel_addr;
                assign cmd_gen_same_shadow_bank_addr    = same_shadow_bank_addr;
                assign cmd_gen_same_shadow_row_addr     = same_shadow_row_addr;
            end
    endgenerate
    
    // avalon_write_req & avalon_read_req is AND with internal_ready in alt_ddrx_avalon_if.v
    assign write_to_queue = (muxed_read | muxed_write) & ~queue_full;
    assign fetch = cmd_gen_load & ~tbp_full;
    
    // proc signals to datapath
    assign  proc_busy       = (cfg_enable_no_dm || cfg_enable_ecc) ? (proc_busy_sig | proc_ecc_busy_sig) : tbp_full;
    assign  proc_load       = (cfg_enable_no_dm || cfg_enable_ecc) ? proc_load_sig                       : cmd_gen_load;
    assign  proc_load_dataid= (cfg_enable_no_dm || cfg_enable_ecc) ? proc_load_dataid_sig                : cmd_gen_load;
    assign  proc_write      = (cfg_enable_no_dm || cfg_enable_ecc) ? proc_write_sig                      : cmd_gen_write;
    assign  proc_read       = (cfg_enable_no_dm || cfg_enable_ecc) ? proc_read_sig                       : cmd_gen_read;
    assign  proc_size       = (cfg_enable_no_dm || cfg_enable_ecc) ? proc_size_sig                       : cmd_gen_size;
    assign  proc_localid    = (cfg_enable_no_dm || cfg_enable_ecc) ? proc_localid_sig                    : cmd_gen_localid;
    assign  tbp_load_index  = (cfg_enable_no_dm || cfg_enable_ecc) ? 1                                   : tbp_load;
    
    //pipefull and pipe register chain
    //feed 0 to pipefull entry that is empty
    always @(posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    for(j=0; j<CFG_CTL_QUEUE_DEPTH; j=j+1)
                        begin
                            pipefull[j] <= 1'b0;
                            pipe    [j] <= 0;
                        end
                end
            else
                begin
                    if (fetch) // fetch and write
                        begin
                            if (can_merge && last != 1)
                                begin
                                    for(j=0; j<CFG_CTL_QUEUE_DEPTH-1; j=j+1)
                                        begin
                                            if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0)
                                                begin
                                                    pipefull[j] <= 1'b0;
                                                end
                                            else if (j == last_minus_one)
                                                begin
                                                    pipefull[j] <= write_to_queue;
                                                    pipe    [j] <= buffer_input;
                                                end
                                            else if (j == last_minus_two)
                                                begin
                                                    pipe[j] <= {pipe[j+1][BUFFER_WIDTH-1:BUFFER_WIDTH-4],2'd2,pipe[j+1][BUFFER_WIDTH-7:0]};
                                                end
                                            else
                                                begin
                                                    pipefull[j] <= pipefull[j+1];
                                                    pipe    [j] <= pipe    [j+1];
                                                end
                                        end
                                    
                                    pipefull[CFG_CTL_QUEUE_DEPTH-1] <= 1'b0;
                                    pipe    [CFG_CTL_QUEUE_DEPTH-1] <= pipe[CFG_CTL_QUEUE_DEPTH-1] & buffer_input;
                                end
                            else
                                begin
                                    for(j=0; j<CFG_CTL_QUEUE_DEPTH-1; j=j+1)
                                        begin
                                            if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0)
                                                begin
                                                    pipefull[j] <= write_to_queue;
                                                    pipe    [j] <= buffer_input;
                                                end
                                            else
                                                begin
                                                    pipefull[j] <= pipefull[j+1];
                                                    pipe    [j] <= pipe    [j+1];
                                                end
                                        end
                                    
                                    pipefull[CFG_CTL_QUEUE_DEPTH-1] <= pipefull[CFG_CTL_QUEUE_DEPTH-1] & write_to_queue;
                                    pipe    [CFG_CTL_QUEUE_DEPTH-1] <= pipe    [CFG_CTL_QUEUE_DEPTH-1] & buffer_input;
                                end
                        end
                    else if (write_to_queue) // write only
                        begin
                            if (can_merge)
                                begin
                                    pipe[last] <= buffer_input;
                                    pipe[last_minus_one][CFG_INT_SIZE_WIDTH + CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH] <= 2;
                                end
                            else
                                begin
                                    for(j=1; j<CFG_CTL_QUEUE_DEPTH; j=j+1)
                                        begin
                                            if(pipefull[j-1] == 1'b1 & pipefull[j] == 1'b0)
                                                begin
                                                    pipefull[j] <= 1'b1;
                                                    pipe    [j] <= buffer_input;
                                                end
                                        end
                                    
                                    if(pipefull[0] == 1'b0)
                                        begin
                                            pipefull[0] <= 1'b1;
                                            pipe    [0] <= buffer_input;
                                        end
                                end
                        end
                    else if (can_merge)
                        begin
                            for(j=0; j<CFG_CTL_QUEUE_DEPTH-1; j=j+1)
                                begin
                                    if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0)
                                        begin
                                            pipefull[j] <= 1'b0;
                                        end
                                    else
                                        begin
                                            pipefull[j] <= pipefull[j+1];
                                        end
                                end
                            
                            pipefull[CFG_CTL_QUEUE_DEPTH-1] <= 1'b0;
                            pipe[last_minus_one][CFG_INT_SIZE_WIDTH + CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH - 1 : CFG_MEM_IF_CS_WIDTH + CFG_MEM_IF_ROW_WIDTH  + CFG_MEM_IF_BA_WIDTH + CFG_MEM_IF_COL_WIDTH] <= 2;
                        end
                end
        end
    
    //============================    end of queue    ===============================  
    
    //----------------------------------------------------------------------------------------------------------------
    
    function integer log2;
        input [31:0] value;
        integer i;
        begin
            log2 = 0;
            
            for(i = 0; 2**i < value; i = i + 1)
                log2 = i + 1;
        end
    endfunction
    
endmodule
