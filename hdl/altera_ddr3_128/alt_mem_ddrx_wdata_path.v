//altera message_off 10230 10036

module alt_mem_ddrx_wdata_path
# (
    // module parameter port list
    parameter
        CFG_LOCAL_DATA_WIDTH                      = 16,
        CFG_MEM_IF_DQ_WIDTH                       = 8,
        CFG_MEM_IF_DQS_WIDTH                      = 1,
        CFG_INT_SIZE_WIDTH                        = 5,
        CFG_DATA_ID_WIDTH                         = 4,
        CFG_DRAM_WLAT_GROUP                       = 1,
        CFG_LOCAL_WLAT_GROUP                      = 1,
        CFG_TBP_NUM                               = 8,
        CFG_BUFFER_ADDR_WIDTH                     = 10,
        CFG_DWIDTH_RATIO                          = 2,
        CFG_ECC_MULTIPLES                         = 1,
        CFG_WDATA_REG                             = 0,
        CFG_PARTIAL_BE_PER_WORD_ENABLE            = 1,
        CFG_ECC_CODE_WIDTH                        = 8,
        CFG_PORT_WIDTH_BURST_LENGTH               = 5,
        CFG_PORT_WIDTH_ENABLE_ECC                 = 1,
        CFG_PORT_WIDTH_ENABLE_AUTO_CORR           = 1,
        CFG_PORT_WIDTH_ENABLE_NO_DM               = 1,
        CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES = 1,
        CFG_PORT_WIDTH_INTERFACE_WIDTH            = 8
)
(
    // port list
    ctl_clk,
    ctl_reset_n,

    // configuration signals
    cfg_burst_length,
    cfg_enable_ecc,
    cfg_enable_auto_corr,
    cfg_enable_no_dm,
    cfg_enable_ecc_code_overwrites,
    cfg_interface_width,

    // command generator & TBP command load interface / cmd update interface
    wdatap_free_id_valid,
    wdatap_free_id_dataid,
    proc_busy,
    proc_load,
    proc_load_dataid,
    proc_write,
    tbp_load_index,
    proc_size,

    // input interface data channel / buffer write interface
    wr_data_mem_full,
    write_data_en,
    write_data,
    byte_en,
    
    // notify TBP interface
    data_complete,
    data_rmw_complete,
    data_partial_be,
    
    // AFI interface / buffer read interface
    doing_write,
    dataid,
    dataid_vector,
    rdwr_data_valid,
    rmw_correct,
    rmw_partial,
    
    doing_write_first,
    dataid_first,
    dataid_vector_first,
    rdwr_data_valid_first,
    rmw_correct_first,
    rmw_partial_first,
    doing_write_first_vector,
    rdwr_data_valid_first_vector,
    
    doing_write_last,
    dataid_last,
    dataid_vector_last,
    rdwr_data_valid_last,
    rmw_correct_last,
    rmw_partial_last,
    
    wdatap_data,
    wdatap_rmw_partial_data,
    wdatap_rmw_correct_data,
    wdatap_rmw_partial,
    wdatap_rmw_correct,
    wdatap_dm,
    wdatap_ecc_code,
    wdatap_ecc_code_overwrite,

    // RMW fifo interface, from rdatap
    rmwfifo_data_valid,
    rmwfifo_data,
    rmwfifo_ecc_dbe,
    rmwfifo_ecc_code

);

    // -----------------------------
    // local parameter declarations
    // -----------------------------

    localparam CFG_MEM_IF_DQ_PER_DQS                = CFG_MEM_IF_DQ_WIDTH / CFG_MEM_IF_DQS_WIDTH;
    
    localparam CFG_BURSTCOUNT_TRACKING_WIDTH        = CFG_BUFFER_ADDR_WIDTH+1;
    
    localparam CFG_RMWFIFO_ECC_DBE_WIDTH            = CFG_ECC_MULTIPLES;
    localparam CFG_RMWFIFO_ECC_CODE_WIDTH           = CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH;
    localparam CFG_RMWDATA_FIFO_DATA_WIDTH          = CFG_LOCAL_DATA_WIDTH + CFG_RMWFIFO_ECC_DBE_WIDTH + CFG_RMWFIFO_ECC_CODE_WIDTH;
    localparam CFG_RMWDATA_FIFO_ADDR_WIDTH          = (CFG_INT_SIZE_WIDTH == 1) ? CFG_INT_SIZE_WIDTH : CFG_INT_SIZE_WIDTH-1;

    localparam CFG_LOCAL_BE_WIDTH                   = CFG_LOCAL_DATA_WIDTH / 8;
    localparam CFG_LOCAL_DM_WIDTH                   = CFG_LOCAL_DATA_WIDTH / CFG_MEM_IF_DQ_PER_DQS; // to get the correct DM width based on x4 or x8 mode
    localparam CFG_MMR_DRAM_DATA_WIDTH              = CFG_PORT_WIDTH_INTERFACE_WIDTH;
    localparam CFG_MMR_DRAM_DM_WIDTH                = CFG_PORT_WIDTH_INTERFACE_WIDTH - 2; // Minus 3 because byte enable will be divided by 4/8

    localparam integer CFG_DATAID_ARRAY_DEPTH       = (2**CFG_DATA_ID_WIDTH);
    
    localparam CFG_WR_DATA_WIDTH_PER_DQS_GROUP      = CFG_LOCAL_DATA_WIDTH / CFG_LOCAL_WLAT_GROUP / CFG_DWIDTH_RATIO;
    localparam CFG_WR_DM_WIDTH_PER_DQS_GROUP        = CFG_LOCAL_DM_WIDTH   / CFG_LOCAL_WLAT_GROUP / CFG_DWIDTH_RATIO;
    
    
    // -----------------------------
    // port declaration
    // -----------------------------

    // clock and reset
    input                                           ctl_clk;
    input                                           ctl_reset_n;

    // configuration signals
    input   [CFG_PORT_WIDTH_BURST_LENGTH     - 1 : 0]           cfg_burst_length;
    input   [CFG_PORT_WIDTH_ENABLE_ECC       - 1 : 0]           cfg_enable_ecc;
    input   [CFG_PORT_WIDTH_ENABLE_AUTO_CORR - 1 : 0]           cfg_enable_auto_corr;
    input   [CFG_PORT_WIDTH_ENABLE_NO_DM     - 1 : 0]           cfg_enable_no_dm;
    input   [CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES - 1 : 0] cfg_enable_ecc_code_overwrites; // overwrite (and don't re-calculate) ecc code on DBE
    input   [CFG_PORT_WIDTH_INTERFACE_WIDTH  - 1 : 0]           cfg_interface_width;
    
    //  command generator free dataid interface
    output                                          wdatap_free_id_valid;
    output  [CFG_DATA_ID_WIDTH-1:0]                 wdatap_free_id_dataid;

    // command generator & TBP command load interface / cmd update interface
    input                                           proc_busy;       
    input                                           proc_load;
    input                                           proc_load_dataid;
    input                                           proc_write;
    input   [CFG_TBP_NUM-1:0]                       tbp_load_index;
    input   [CFG_INT_SIZE_WIDTH-1:0]                proc_size;   

    // input interface data channel / buffer write interface
    output                                          wr_data_mem_full;  
    input                                           write_data_en;
    input   [CFG_LOCAL_DATA_WIDTH-1:0]              write_data;
    input   [CFG_LOCAL_BE_WIDTH-1:0]                byte_en;
    
    // notify TBP interface
    output  [CFG_TBP_NUM-1:0]                       data_complete;
    output                                          data_rmw_complete;      // broadcast to TBP's
    output                                          data_partial_be;
    
    // AFI interface / buffer read interface
    input   [CFG_DRAM_WLAT_GROUP-1:0]                        doing_write;
    input   [CFG_DRAM_WLAT_GROUP*CFG_DATA_ID_WIDTH-1:0]      dataid;
    input   [CFG_DRAM_WLAT_GROUP*CFG_DATAID_ARRAY_DEPTH-1:0] dataid_vector;
    input   [CFG_DRAM_WLAT_GROUP-1:0]                        rdwr_data_valid;
    input   [CFG_DRAM_WLAT_GROUP-1:0]                        rmw_correct;
    input   [CFG_DRAM_WLAT_GROUP-1:0]                        rmw_partial;
    
    input                                                    doing_write_first;
    input   [CFG_DATA_ID_WIDTH-1:0]                          dataid_first;
    input   [CFG_DATAID_ARRAY_DEPTH-1:0]                     dataid_vector_first;
    input                                                    rdwr_data_valid_first;
    input                                                    rmw_correct_first;
    input                                                    rmw_partial_first;
    input   [CFG_DRAM_WLAT_GROUP-1:0]                        doing_write_first_vector;
    input   [CFG_DRAM_WLAT_GROUP-1:0]                        rdwr_data_valid_first_vector;
    
    input                                                    doing_write_last;
    input   [CFG_DATA_ID_WIDTH-1:0]                          dataid_last;
    input   [CFG_DATAID_ARRAY_DEPTH-1:0]                     dataid_vector_last;
    input                                                    rdwr_data_valid_last;
    input                                                    rmw_correct_last;
    input                                                    rmw_partial_last;
    
    output  [CFG_LOCAL_DATA_WIDTH-1:0]                       wdatap_data;
    output  [CFG_LOCAL_DATA_WIDTH-1:0]                       wdatap_rmw_partial_data;
    output  [CFG_LOCAL_DATA_WIDTH-1:0]                       wdatap_rmw_correct_data;
    output                                                   wdatap_rmw_partial;
    output                                                   wdatap_rmw_correct;
    output  [CFG_LOCAL_DM_WIDTH-1:0]                         wdatap_dm;
    output  [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] wdatap_ecc_code;
    output  [CFG_ECC_MULTIPLES                      - 1 : 0] wdatap_ecc_code_overwrite;

    // RMW fifo interface
    input                                                   rmwfifo_data_valid; 
    input  [CFG_LOCAL_DATA_WIDTH-1:0]                       rmwfifo_data;
    input  [CFG_ECC_MULTIPLES- 1 : 0]                       rmwfifo_ecc_dbe;
    input  [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rmwfifo_ecc_code;

    // -----------------------------
    // port type declaration
    // -----------------------------

    // clock and reset
    wire                                            ctl_clk;
    wire                                            ctl_reset_n;

    // configuration signals
    wire    [CFG_PORT_WIDTH_BURST_LENGTH     - 1 : 0]           cfg_burst_length;
    wire    [CFG_PORT_WIDTH_ENABLE_ECC       - 1 : 0]           cfg_enable_ecc;
    wire    [CFG_PORT_WIDTH_ENABLE_AUTO_CORR - 1 : 0]           cfg_enable_auto_corr;
    wire    [CFG_PORT_WIDTH_ENABLE_NO_DM     - 1 : 0]           cfg_enable_no_dm;
    wire    [CFG_PORT_WIDTH_ENABLE_ECC_CODE_OVERWRITES - 1 : 0] cfg_enable_ecc_code_overwrites;             // overwrite (and don't re-calculate) ecc code on DBE
    wire    [CFG_PORT_WIDTH_INTERFACE_WIDTH  - 1 : 0]           cfg_interface_width;
    
    //  command generator free dataid interface
    wire                                            wdatap_free_id_valid;
    wire                                            wdatap_int_free_id_valid;
    wire    [CFG_DATA_ID_WIDTH-1:0]                 wdatap_free_id_dataid;
    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]            wdatap_free_id_dataid_vector;

    // command generator & TBP command load interface / cmd update interface
    wire                                            proc_busy;       
    wire                                            proc_load;
    wire                                            proc_load_dataid;
    wire                                            proc_write;
    wire    [CFG_TBP_NUM-1:0]                       tbp_load_index;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                proc_size;   

    // input interface data channel / buffer write interface
    wire                                            wr_data_mem_full;  
    wire                                            write_data_en;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]              write_data;
    wire    [CFG_LOCAL_BE_WIDTH-1:0]                byte_en;
    
    // notify TBP interface
    wire    [CFG_TBP_NUM-1:0]                       data_complete;
    wire                                            data_rmw_complete;
    wire                                            data_partial_be;
    
    // AFI interface / buffer read interface
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                        doing_write;
    wire    [CFG_DRAM_WLAT_GROUP*CFG_DATA_ID_WIDTH-1:0]      dataid;
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                        rdwr_data_valid;
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                        rmw_correct;
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                        rmw_partial;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                       wdatap_data;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                       wdatap_rmw_partial_data;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                       wdatap_rmw_correct_data;
    wire                                                     wdatap_rmw_partial;
    wire                                                     wdatap_rmw_correct;
    wire    [CFG_LOCAL_DM_WIDTH-1:0]                         wdatap_dm;
    reg     [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] wdatap_ecc_code;
    reg     [CFG_ECC_MULTIPLES                      - 1 : 0] wdatap_ecc_code_overwrite;

    // RMW fifo interface
    wire                                                   rmwfifo_data_valid; 
    wire  [CFG_LOCAL_DATA_WIDTH-1:0]                       rmwfifo_data;
    wire  [CFG_ECC_MULTIPLES- 1 : 0]                       rmwfifo_ecc_dbe;
    wire  [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rmwfifo_ecc_code;


    // -----------------------------
    // signal declaration
    // -----------------------------

    // configuration
    reg  [CFG_MMR_DRAM_DATA_WIDTH  - 1 : 0]             cfg_dram_data_width;
    reg  [CFG_MMR_DRAM_DM_WIDTH    - 1 : 0]             cfg_dram_dm_width;

    // command generator & TBP command load interface / cmd update interface
    wire                                                wdatap_cmdload_ready;
    wire                                                wdatap_cmdload_valid;
    wire    [CFG_DATA_ID_WIDTH-1:0]                     wdatap_cmdload_dataid;
    wire    [CFG_TBP_NUM-1:0]                           wdatap_cmdload_tbp_index;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                    wdatap_cmdload_burstcount;

    // input interface data channel / buffer write interface
    wire                                                wdatap_datawrite_ready;
    wire                                                wdatap_datawrite_valid;
    wire                                                wdatap_datawrite_accepted;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                  wdatap_datawrite_data;
    wire    [CFG_LOCAL_BE_WIDTH-1:0]                    wdatap_datawrite_be;
    reg     [CFG_LOCAL_DM_WIDTH-1:0]                    wdatap_datawrite_dm;
    reg     [CFG_LOCAL_DM_WIDTH-1:0]                    int_datawrite_dm;
    wire                                                wdatap_datawrite_partial_dm;
    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]                 wdatap_datawrite_address;
    reg     [CFG_ECC_MULTIPLES-1:0]                     int_datawrite_partial_dm;


    // notify TBP interface
    wire    [CFG_TBP_NUM-1:0]                           wdatap_tbp_data_ready;
    wire                                                wdatap_tbp_data_partial_be;

    // AFI interface data channel / buffer read interface
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                           wdatap_dataread_valid;
    wire    [CFG_DRAM_WLAT_GROUP*CFG_DATA_ID_WIDTH-1:0]         wdatap_dataread_dataid;
    wire    [CFG_DRAM_WLAT_GROUP*CFG_DATAID_ARRAY_DEPTH-1:0]    wdatap_dataread_dataid_vector;
    reg     [CFG_DRAM_WLAT_GROUP*CFG_DATA_ID_WIDTH-1:0]         wdatap_dataread_dataid_r;
    wire                                                        wdatap_dataread_valid_first;
    wire    [CFG_DATA_ID_WIDTH-1:0]                             wdatap_dataread_dataid_first;
    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]                        wdatap_dataread_dataid_vector_first;
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                           wdatap_dataread_valid_first_vector;
    wire                                                        wdatap_dataread_valid_last;
    wire    [CFG_DATA_ID_WIDTH-1:0]                             wdatap_dataread_dataid_last;
    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]                        wdatap_dataread_dataid_vector_last;
    wire    [CFG_DRAM_WLAT_GROUP-1:0]                           wdatap_dataread_datavalid;
    reg     [CFG_LOCAL_DATA_WIDTH-1:0]                          wdatap_dataread_data;
    reg     [CFG_LOCAL_DATA_WIDTH-1:0]                          wdatap_dataread_rmw_partial_data;
    reg     [CFG_LOCAL_DATA_WIDTH-1:0]                          wdatap_dataread_rmw_correct_data;
    reg                                                         wdatap_dataread_rmw_partial;
    reg                                                         wdatap_dataread_rmw_correct;
    reg     [CFG_LOCAL_DM_WIDTH-1:0]                            wdatap_dataread_dm;
    wire    [CFG_DRAM_WLAT_GROUP*CFG_BUFFER_ADDR_WIDTH-1:0]     wdatap_dataread_address;
    wire                                                        wdatap_dataread_done;
    wire                                                        wdatap_dataread_ready;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]                          wdatap_dataread_buffer_data;
    wire    [CFG_LOCAL_DM_WIDTH-1:0]                            wdatap_dataread_buffer_dm;

    wire                                                        wdatap_free_id_get_ready;
    wire                                                        wdatap_allocated_put_ready;
    wire                                                        wdatap_allocated_put_valid;

    wire                                                        wdatap_update_data_dataid_valid;
    wire    [CFG_DATA_ID_WIDTH-1:0]                             wdatap_update_data_dataid;
    wire    [CFG_DATAID_ARRAY_DEPTH-1:0]                        wdatap_update_data_dataid_vector;
    wire    [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]                 wdatap_update_data_burstcount;
    wire    [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]                 wdatap_update_data_next_burstcount;
    wire                                                        wdatap_notify_data_valid;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                            wdatap_notify_data_burstcount_consumed;

    // buffer read/write signals
    wire                                                        wdatap_buffwrite_valid;
    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]                         wdatap_buffwrite_address;
    wire                                                        wdatap_buffread_valid;
    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]                         wdatap_buffread_address;

    wire    [CFG_RMWDATA_FIFO_DATA_WIDTH-1:0]       rmwfifo_input;
    wire    [CFG_RMWDATA_FIFO_DATA_WIDTH-1:0]       rmwfifo_output;
    wire                                            rmwfifo_output_read;
    wire                                            rmwfifo_output_valid;
    reg                                             rmwfifo_output_valid_r;
    wire                                            rmwfifo_output_valid_pulse;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0]              rmwfifo_output_data;
    wire    [CFG_ECC_MULTIPLES- 1 : 0]              rmwfifo_output_ecc_dbe;
    wire    [CFG_ECC_MULTIPLES * CFG_ECC_CODE_WIDTH - 1 : 0] rmwfifo_output_ecc_code;

    reg     [CFG_LOCAL_DATA_WIDTH-1:0]              rmw_merged_data;
    reg                                             rmw_correct_r;
    reg                                             rmw_partial_r;
    wire                                            rmwfifo_ready; 

    // debug signals, for assertions
    wire                                                        err_rmwfifo_overflow;

    // -----------------------------
    // module definition
    // -----------------------------

    // renaming port names to more meaningfull internal names
    
    assign wdatap_cmdload_valid         = ~proc_busy & proc_load & proc_write & proc_load_dataid;
    assign wdatap_cmdload_tbp_index     = tbp_load_index;
    assign wdatap_cmdload_burstcount    = proc_size;
    assign wdatap_cmdload_dataid        = wdatap_free_id_dataid;

    assign wr_data_mem_full             = ~wdatap_datawrite_ready;
    assign wdatap_datawrite_valid       = write_data_en;
    assign wdatap_datawrite_data        = write_data;
    assign wdatap_datawrite_be          = byte_en; // we need to replicate

    assign data_complete                = wdatap_tbp_data_ready;
    assign data_rmw_complete            = rmwfifo_output_valid_pulse;       // broadcast to all TBP's
    assign data_partial_be              = wdatap_tbp_data_partial_be;
    
    assign wdatap_dataread_valid               = doing_write & rdwr_data_valid & ~rmw_correct;
    assign wdatap_dataread_dataid              = dataid;
    assign wdatap_dataread_dataid_vector       = dataid_vector;
    assign wdatap_dataread_valid_first         = doing_write_first & rdwr_data_valid_first & ~rmw_correct_first;
    assign wdatap_dataread_dataid_first        = dataid_first;
    assign wdatap_dataread_dataid_vector_first = dataid_vector_first;
    assign wdatap_dataread_valid_first_vector  = rdwr_data_valid_first_vector;
    assign wdatap_dataread_valid_last          = doing_write_last  & rdwr_data_valid_last  & ~rmw_correct_last ;
    assign wdatap_dataread_dataid_last         = dataid_last;
    assign wdatap_dataread_dataid_vector_last  = dataid_vector_last;
    assign wdatap_data                         = wdatap_dataread_data;
    assign wdatap_rmw_partial_data             = wdatap_dataread_rmw_partial_data;
    assign wdatap_rmw_correct_data             = wdatap_dataread_rmw_correct_data;
    assign wdatap_rmw_partial                  = wdatap_dataread_rmw_partial;
    assign wdatap_rmw_correct                  = wdatap_dataread_rmw_correct;
    assign wdatap_dm                           = wdatap_dataread_dm;

    // internal signals

    // flow control between free list & allocated list
    assign wdatap_free_id_get_ready = wdatap_cmdload_valid;
    assign wdatap_allocated_put_valid= wdatap_free_id_get_ready & wdatap_free_id_valid;
    assign wdatap_free_id_valid = wdatap_int_free_id_valid & wdatap_cmdload_ready;


    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            cfg_dram_data_width <= 0;
        end
        else
        begin
            if (cfg_enable_ecc)
            begin
                cfg_dram_data_width <= cfg_interface_width - CFG_ECC_CODE_WIDTH;            // SPR:362973
            end
            else
            begin
                cfg_dram_data_width <= cfg_interface_width;
            end
        end
    end

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
        if (~ctl_reset_n)
        begin
            //reset state ...
            wdatap_dataread_dataid_r <= 0;
        end
        else
        begin
            //active state ...
            wdatap_dataread_dataid_r <= wdatap_dataread_dataid;
        end
    end
    
    alt_mem_ddrx_list
    #(
        .CTL_LIST_WIDTH                             (CFG_DATA_ID_WIDTH),
        .CTL_LIST_DEPTH                             (CFG_DATAID_ARRAY_DEPTH),
        .CTL_LIST_INIT_VALUE_TYPE                   ("INCR"),
        .CTL_LIST_INIT_VALID                        ("VALID")
    )
    wdatap_list_freeid_inst
    (
     .ctl_clk                                       (ctl_clk),
     .ctl_reset_n                                   (ctl_reset_n),
                                                                        
     .list_get_entry_ready                          (wdatap_free_id_get_ready),
     .list_get_entry_valid                          (wdatap_int_free_id_valid),
     .list_get_entry_id                             (wdatap_free_id_dataid),   
     .list_get_entry_id_vector                      (wdatap_free_id_dataid_vector),   
    
     // wdatap_dataread_ready can be ignored, list entry availability is guaranteed
     .list_put_entry_ready                          (wdatap_dataread_ready),                             
     .list_put_entry_valid                          (wdatap_dataread_done),         
     .list_put_entry_id                             (wdatap_dataread_dataid_r)
    );

    alt_mem_ddrx_list
    #(
        .CTL_LIST_WIDTH                             (CFG_DATA_ID_WIDTH),
        .CTL_LIST_DEPTH                             (CFG_DATAID_ARRAY_DEPTH),
        .CTL_LIST_INIT_VALUE_TYPE                   ("ZERO"),
        .CTL_LIST_INIT_VALID                        ("INVALID")
    )
    wdatap_list_allocated_id_inst
    (
     .ctl_clk                                       (ctl_clk),
     .ctl_reset_n                                   (ctl_reset_n),
                                                                               
     .list_get_entry_ready                          (wdatap_notify_data_valid),
     .list_get_entry_valid                          (wdatap_update_data_dataid_valid),
     .list_get_entry_id                             (wdatap_update_data_dataid),   
     .list_get_entry_id_vector                      (wdatap_update_data_dataid_vector),   

     // wdatap_allocated_put_ready can be ignored, list entry availability is guaranteed
     .list_put_entry_ready                          (wdatap_allocated_put_ready),
     .list_put_entry_valid                          (wdatap_allocated_put_valid),    
     .list_put_entry_id                             (wdatap_free_id_dataid)
    );
    
    alt_mem_ddrx_burst_tracking
    # (
        .CFG_BURSTCOUNT_TRACKING_WIDTH              (CFG_BURSTCOUNT_TRACKING_WIDTH),
        .CFG_BUFFER_ADDR_WIDTH                      (CFG_BUFFER_ADDR_WIDTH),
        .CFG_INT_SIZE_WIDTH                         (CFG_INT_SIZE_WIDTH)
    )
    wdatap_burst_tracking_inst
    (
        // port list
        .ctl_clk                                    (ctl_clk),
        .ctl_reset_n                                (ctl_reset_n),
                                                                      
        // data burst interface                                       
        .burst_ready                                (wdatap_datawrite_ready),
        .burst_valid                                (wdatap_datawrite_valid),

        // burstcount counter sent to data_id_manager
        .burst_pending_burstcount                   (wdatap_update_data_burstcount),
        .burst_next_pending_burstcount              (wdatap_update_data_next_burstcount),

        // burstcount consumed by data_id_manager
        .burst_consumed_valid                       (wdatap_notify_data_valid),
        .burst_counsumed_burstcount                 (wdatap_notify_data_burstcount_consumed)
    );

    alt_mem_ddrx_dataid_manager
    # (
        .CFG_DATA_ID_WIDTH                          (CFG_DATA_ID_WIDTH),
        .CFG_LOCAL_WLAT_GROUP                       (CFG_LOCAL_WLAT_GROUP),
        .CFG_DRAM_WLAT_GROUP                        (CFG_DRAM_WLAT_GROUP),
        .CFG_BUFFER_ADDR_WIDTH                      (CFG_BUFFER_ADDR_WIDTH),
        .CFG_INT_SIZE_WIDTH                         (CFG_INT_SIZE_WIDTH),
        .CFG_TBP_NUM                                (CFG_TBP_NUM),
        .CFG_BURSTCOUNT_TRACKING_WIDTH              (CFG_BURSTCOUNT_TRACKING_WIDTH),
        .CFG_PORT_WIDTH_BURST_LENGTH                (CFG_PORT_WIDTH_BURST_LENGTH),
        .CFG_DWIDTH_RATIO                           (CFG_DWIDTH_RATIO)
    )
    wdatap_dataid_manager_inst
    (

        // clock & reset
        .ctl_clk                                    (ctl_clk),
        .ctl_reset_n                                (ctl_reset_n),

        // configuration signals
        .cfg_burst_length                           (cfg_burst_length),
        .cfg_enable_ecc                             (cfg_enable_ecc),
        .cfg_enable_auto_corr                       (cfg_enable_auto_corr),
        .cfg_enable_no_dm                           (cfg_enable_no_dm),

        // update cmd interface                                                                                                        
        .update_cmd_if_ready                        (wdatap_cmdload_ready),
        .update_cmd_if_valid                        (wdatap_cmdload_valid),
        .update_cmd_if_data_id                      (wdatap_cmdload_dataid),    
        .update_cmd_if_burstcount                   (wdatap_cmdload_burstcount),
        .update_cmd_if_tbp_id                       (wdatap_cmdload_tbp_index),    
                                                                                                
        // update data interface                                                               
        .update_data_if_valid                       (wdatap_update_data_dataid_valid),
        .update_data_if_data_id                     (wdatap_update_data_dataid),
        .update_data_if_data_id_vector              (wdatap_update_data_dataid_vector),
        .update_data_if_burstcount                  (wdatap_update_data_burstcount),    
        .update_data_if_next_burstcount             (wdatap_update_data_next_burstcount),    
                                                                                                                                       
        // notify data interface                                                                                                       
        .notify_data_if_valid                       (wdatap_notify_data_valid),
        .notify_data_if_burstcount                  (wdatap_notify_data_burstcount_consumed),    
                                                                                                                                       
        // notify tbp interface                                                                                               
        .notify_tbp_data_ready                      (wdatap_tbp_data_ready),
        .notify_tbp_data_partial_be                 (wdatap_tbp_data_partial_be),
         
        // buffer write address generate interface
        .write_data_if_ready                        (wdatap_datawrite_ready),
        .write_data_if_valid                        (wdatap_datawrite_valid),
        .write_data_if_accepted                     (wdatap_datawrite_accepted),
        .write_data_if_address                      (wdatap_datawrite_address),
        .write_data_if_partial_dm                   (wdatap_datawrite_partial_dm),

        // read data interface
        .read_data_if_valid                         (wdatap_dataread_valid),
        .read_data_if_data_id                       (wdatap_dataread_dataid),
        .read_data_if_data_id_vector                (wdatap_dataread_dataid_vector),
        .read_data_if_valid_first                   (wdatap_dataread_valid_first),
        .read_data_if_data_id_first                 (wdatap_dataread_dataid_first),
        .read_data_if_data_id_vector_first          (wdatap_dataread_dataid_vector_first),
        .read_data_if_valid_first_vector            (wdatap_dataread_valid_first_vector),
        .read_data_if_valid_last                    (wdatap_dataread_valid_last),
        .read_data_if_data_id_last                  (wdatap_dataread_dataid_last),
        .read_data_if_data_id_vector_last           (wdatap_dataread_dataid_vector_last),
        .read_data_if_address                       (wdatap_dataread_address),
        .read_data_if_datavalid                     (wdatap_dataread_datavalid),
        .read_data_if_done                          (wdatap_dataread_done)          // use with wdatap_dataread_dataid_r
    );

    genvar wdatap_m;
    genvar wdatap_n;
    generate
        for (wdatap_m = 0;wdatap_m < CFG_DWIDTH_RATIO;wdatap_m = wdatap_m + 1)
        begin : wdata_buffer_per_dwidth_ratio
            for (wdatap_n = 0;wdatap_n < CFG_LOCAL_WLAT_GROUP;wdatap_n = wdatap_n + 1)
            begin : wdata_buffer_per_dqs_group
                alt_mem_ddrx_buffer
                # (
                    .ADDR_WIDTH                                 (CFG_BUFFER_ADDR_WIDTH),
                    .DATA_WIDTH                                 (CFG_WR_DATA_WIDTH_PER_DQS_GROUP)
                )
                wdatap_buffer_data_inst
                (
                    // port list
                    .ctl_clk                                    (ctl_clk),
                    .ctl_reset_n                                (ctl_reset_n),
                    
                    // write interface
                    .write_valid                                (wdatap_datawrite_accepted),
                    .write_address                              (wdatap_datawrite_address),
                    .write_data                                 (wdatap_datawrite_data       [(wdatap_m * CFG_WR_DATA_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + ((wdatap_n + 1) * CFG_WR_DATA_WIDTH_PER_DQS_GROUP) - 1 : (wdatap_m * CFG_WR_DATA_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + (wdatap_n * CFG_WR_DATA_WIDTH_PER_DQS_GROUP)]),
                    
                    // read interface
                    .read_valid                                 (wdatap_dataread_valid       [wdatap_n]),
                    .read_address                               (wdatap_dataread_address     [(wdatap_n + 1) * CFG_BUFFER_ADDR_WIDTH - 1 : wdatap_n * CFG_BUFFER_ADDR_WIDTH]),
                    .read_data                                  (wdatap_dataread_buffer_data [(wdatap_m * CFG_WR_DATA_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + ((wdatap_n + 1) * CFG_WR_DATA_WIDTH_PER_DQS_GROUP) - 1 : (wdatap_m * CFG_WR_DATA_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + (wdatap_n * CFG_WR_DATA_WIDTH_PER_DQS_GROUP)])
                );
                
                alt_mem_ddrx_buffer
                # (
                    .ADDR_WIDTH                                 (CFG_BUFFER_ADDR_WIDTH),
                    .DATA_WIDTH                                 (CFG_WR_DM_WIDTH_PER_DQS_GROUP)
                )
                wdatap_buffer_be_inst
                (
                    // port list
                    .ctl_clk                                    (ctl_clk),
                    .ctl_reset_n                                (ctl_reset_n),
                    
                    // write interface
                    .write_valid                                (wdatap_datawrite_accepted),
                    .write_address                              (wdatap_datawrite_address),
                    .write_data                                 (int_datawrite_dm          [(wdatap_m * CFG_WR_DM_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + ((wdatap_n + 1) * CFG_WR_DM_WIDTH_PER_DQS_GROUP) - 1 : (wdatap_m * CFG_WR_DM_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + (wdatap_n * CFG_WR_DM_WIDTH_PER_DQS_GROUP)]),
                    
                    // read interface
                    .read_valid                                 (wdatap_dataread_valid     [wdatap_n]),
                    .read_address                               (wdatap_dataread_address   [(wdatap_n + 1) * CFG_BUFFER_ADDR_WIDTH - 1 : wdatap_n * CFG_BUFFER_ADDR_WIDTH]),
                    .read_data                                  (wdatap_dataread_buffer_dm [(wdatap_m * CFG_WR_DM_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + ((wdatap_n + 1) * CFG_WR_DM_WIDTH_PER_DQS_GROUP) - 1 : (wdatap_m * CFG_WR_DM_WIDTH_PER_DQS_GROUP * CFG_LOCAL_WLAT_GROUP) + (wdatap_n * CFG_WR_DM_WIDTH_PER_DQS_GROUP)])
                );
            end
        end
    endgenerate


    //
    // byteenables analysis & generation
    //
    //  -   generate partial byteenable signal, per DQ word or per local word
    //  -   set unused interface width byteenables to either 0 or 1
    //

    genvar wdatap_j, wdatap_k;
    generate
        reg     [(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1:0] wdatap_datawrite_dm_widthratio    [CFG_ECC_MULTIPLES-1:0];
        reg     [(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1:0] int_datawrite_dm_unused1          [CFG_ECC_MULTIPLES-1:0];
        reg     [(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1:0] int_datawrite_dm_unused0          [CFG_ECC_MULTIPLES-1:0];
        
        assign wdatap_datawrite_partial_dm = |int_datawrite_partial_dm;
        
        for (wdatap_k = 0;wdatap_k < CFG_LOCAL_DM_WIDTH;wdatap_k = wdatap_k + 1)
        begin : local_dm
            always @ (*)
            begin
                if (CFG_MEM_IF_DQ_PER_DQS == 4)
                begin
                    wdatap_datawrite_dm [wdatap_k] = wdatap_datawrite_be [wdatap_k / 2];
                end
                else
                begin
                    wdatap_datawrite_dm [wdatap_k] = wdatap_datawrite_be [wdatap_k];
                end
            end
        end
        
        for (wdatap_j = 0; wdatap_j < CFG_ECC_MULTIPLES; wdatap_j = wdatap_j + 1) 
        begin : gen_partial_be
            wire dm_all_ones    = &int_datawrite_dm_unused1[wdatap_j];
            wire dm_all_zeros   = ~(|int_datawrite_dm_unused0[wdatap_j]);
            
            always @ (*) 
            begin
                    wdatap_datawrite_dm_widthratio [wdatap_j] =  wdatap_datawrite_dm [(wdatap_j+1)*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1 : (wdatap_j*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES))];
            end
            
            for (wdatap_k = 0; wdatap_k < (CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES); wdatap_k = wdatap_k + 1'b1)
            begin : gen_dm_unused_bits
                always @ (*) 
                begin
                    if (wdatap_k < cfg_dram_dm_width)
                    begin
                        int_datawrite_dm_unused1 [wdatap_j] [wdatap_k] =  wdatap_datawrite_dm_widthratio [wdatap_j][wdatap_k];
                        int_datawrite_dm_unused0 [wdatap_j] [wdatap_k] =  wdatap_datawrite_dm_widthratio [wdatap_j][wdatap_k];
                    end
                    else
                    begin
                        int_datawrite_dm_unused1 [wdatap_j] [wdatap_k] =  {1'b1};
                        int_datawrite_dm_unused0 [wdatap_j] [wdatap_k] =  {1'b0};
                    end
                end
            end
            
            always @ (*) 
            begin
                // partial be calculated for every dq width if byteenables, not partial be if either all ones, or all zeros
                if (cfg_enable_no_dm)
                begin
                    int_datawrite_partial_dm[wdatap_j] =  ~dm_all_ones;
                end
                else
                begin
                    int_datawrite_partial_dm[wdatap_j] =  ~( dm_all_ones | dm_all_zeros );
                end
                
                if (cfg_enable_ecc)
                begin
                    if (dm_all_zeros)
                    begin
                        // no ECC code will be written
                        int_datawrite_dm [(wdatap_j+1)*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1 : (wdatap_j*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES))] = int_datawrite_dm_unused0 [wdatap_j];
                    end
                    else
                    begin
                        // higher unused be bit will be used for ECC word
                        int_datawrite_dm [(wdatap_j+1)*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1 : (wdatap_j*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES))] = int_datawrite_dm_unused1 [wdatap_j];
                    end
                end
                else
                begin
                        int_datawrite_dm [(wdatap_j+1)*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES)-1 : (wdatap_j*(CFG_LOCAL_DM_WIDTH/CFG_ECC_MULTIPLES))] = int_datawrite_dm_unused0 [wdatap_j];
                end
            end
        end
    endgenerate


    //
    // rmw data fifo
    //

    // assume rmw data for 2 commands doesn't came back to back, causing rmwfifo_output_valid_pulse not to be generated for 2nd commands data
    assign rmwfifo_output_valid_pulse = rmwfifo_output_valid & ~rmwfifo_output_valid_r;

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            rmwfifo_output_valid_r  <= 1'b0;
            rmw_correct_r           <= 1'b0;
            rmw_partial_r           <= 1'b0;
        end
        else
        begin
            rmwfifo_output_valid_r  <= rmwfifo_output_valid;
            rmw_correct_r           <= rmw_correct;
            rmw_partial_r           <= rmw_partial;
        end
    end


    assign rmwfifo_input = {rmwfifo_ecc_code, rmwfifo_ecc_dbe, rmwfifo_data};
    assign {rmwfifo_output_ecc_code, rmwfifo_output_ecc_dbe, rmwfifo_output_data} = rmwfifo_output;
    assign rmwfifo_output_read = rmw_correct_r | (&wdatap_dataread_datavalid & rmw_partial_r); // wdatap_dataread_datavalid must be all high together in ECC case (afi_wlat same for all DQS group), limitation in 11.0sp1
    assign err_rmwfifo_overflow = rmwfifo_data_valid & ~rmwfifo_ready;

    alt_mem_ddrx_fifo
    #(
        .CTL_FIFO_DATA_WIDTH (CFG_RMWDATA_FIFO_DATA_WIDTH),
        .CTL_FIFO_ADDR_WIDTH (CFG_RMWDATA_FIFO_ADDR_WIDTH)
    )
    rmw_data_fifo_inst
    (
        .ctl_clk            (ctl_clk),
        .ctl_reset_n        (ctl_reset_n),

        .get_ready          (rmwfifo_output_read),
        .get_valid          (rmwfifo_output_valid),
        .get_data           (rmwfifo_output),

        .put_ready          (rmwfifo_ready),
        .put_valid          (rmwfifo_data_valid),
        .put_data           (rmwfifo_input)
    );


    //
    // rmw data merge block
    //

    genvar wdatap_i;
    generate
        for (wdatap_i = 0; wdatap_i < ((CFG_LOCAL_DM_WIDTH)); wdatap_i = wdatap_i + 1) 
        begin : gen_rmw_data_merge

            always @ (*) 
            begin
                if (wdatap_dataread_buffer_dm[wdatap_i])
                begin
                    // data from wdatap buffer
                    rmw_merged_data [ ((wdatap_i + 1) * CFG_MEM_IF_DQ_PER_DQS) - 1 : (wdatap_i * CFG_MEM_IF_DQ_PER_DQS) ] = wdatap_dataread_buffer_data [ ((wdatap_i + 1) * CFG_MEM_IF_DQ_PER_DQS) - 1 : (wdatap_i * CFG_MEM_IF_DQ_PER_DQS) ];
                end
                else
                begin
                    // data from rmwfifo
                    rmw_merged_data [ ((wdatap_i + 1) * CFG_MEM_IF_DQ_PER_DQS) - 1 : (wdatap_i * CFG_MEM_IF_DQ_PER_DQS) ] = rmwfifo_output_data [ ((wdatap_i + 1) * CFG_MEM_IF_DQ_PER_DQS) - 1 : (wdatap_i * CFG_MEM_IF_DQ_PER_DQS) ];
                end
            end

        end
    endgenerate


    //
    // wdata output mux
    //
    // drives wdatap_data & wdatap_be from either of
    // if cfg_enabled etc ?
    // - wdatap buffer                      (~rmw_correct & ~rmw_partial)
    // - rmwfifo                            (rmw_correct)
    // - merged wdatap buffer & rmwfifo     (rmw_partial)
    //

    generate
        if (CFG_WDATA_REG)
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    wdatap_dataread_dm               <= 0;
                    wdatap_dataread_data             <= 0;
                    wdatap_dataread_rmw_partial_data <= 0;
                    wdatap_dataread_rmw_correct_data <= 0;
                    wdatap_dataread_rmw_partial      <= 0;
                    wdatap_dataread_rmw_correct      <= 0;
                end
                else
                begin
                    if (cfg_enable_ecc | cfg_enable_no_dm)
                    begin
                        wdatap_dataread_data             <= wdatap_dataread_buffer_data;
                        wdatap_dataread_rmw_partial_data <= rmw_merged_data;
                        wdatap_dataread_rmw_correct_data <= rmwfifo_output_data;
                        wdatap_dataread_rmw_partial      <= rmw_partial_r;
                        wdatap_dataread_rmw_correct      <= rmw_correct_r;
                        
                        if (rmw_correct_r | rmw_partial_r)
                        begin
                            wdatap_dataread_dm <= {(CFG_LOCAL_DM_WIDTH){1'b1}};
                        end
                        else
                        begin
                            wdatap_dataread_dm <= wdatap_dataread_buffer_dm;
                        end
                    end
                    else
                    begin
                        wdatap_dataread_dm               <= wdatap_dataread_buffer_dm;
                        wdatap_dataread_data             <= wdatap_dataread_buffer_data;
                        wdatap_dataread_rmw_partial_data <= 0;
                        wdatap_dataread_rmw_correct_data <= 0;
                        wdatap_dataread_rmw_partial      <= 1'b0;
                        wdatap_dataread_rmw_correct      <= 1'b0;
                    end
                end
            end
            
            
            // ecc code overwrite
            // - is asserted when we don't want controller to re-calculate the ecc code
            // - only allowed when we're not doing any writes in this clock
            // - only allowed when rmwfifo output is valid
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    wdatap_ecc_code           <= 0;
                    wdatap_ecc_code_overwrite <= 0;
                end
                else
                begin
                    wdatap_ecc_code <= rmwfifo_output_ecc_code;
                    
                    if (cfg_enable_ecc_code_overwrites)
                    begin
                        if (rmw_correct_r)
                        begin
                            wdatap_ecc_code_overwrite <= rmwfifo_output_ecc_dbe;
                        end
                        else if (rmw_partial_r)
                        begin
                            if ( (|wdatap_dataread_buffer_dm) | (~rmwfifo_output_valid) )
                            begin
                                wdatap_ecc_code_overwrite <= {CFG_ECC_MULTIPLES{1'b0}};
                            end
                            else
                            begin
                                wdatap_ecc_code_overwrite <= rmwfifo_output_ecc_dbe;
                            end
                        end
                        else
                        begin
                            wdatap_ecc_code_overwrite <= {CFG_ECC_MULTIPLES{1'b0}};
                        end
                    end
                    else
                    begin
                        wdatap_ecc_code_overwrite <= {CFG_ECC_MULTIPLES{1'b0}};
                    end
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                if (cfg_enable_ecc | cfg_enable_no_dm)
                begin
                    wdatap_dataread_data             = wdatap_dataread_buffer_data;
                    wdatap_dataread_rmw_partial_data = rmw_merged_data;
                    wdatap_dataread_rmw_correct_data = rmwfifo_output_data;
                    wdatap_dataread_rmw_partial      = rmw_partial_r;
                    wdatap_dataread_rmw_correct      = rmw_correct_r;
                    
                    if (rmw_correct_r | rmw_partial_r)
                    begin
                        wdatap_dataread_dm = {(CFG_LOCAL_DM_WIDTH){1'b1}};
                    end
                    else
                    begin
                        wdatap_dataread_dm = wdatap_dataread_buffer_dm;
                    end
                end
                else
                begin
                    wdatap_dataread_dm               = wdatap_dataread_buffer_dm;
                    wdatap_dataread_data             = wdatap_dataread_buffer_data;
                    wdatap_dataread_rmw_partial_data = 0;
                    wdatap_dataread_rmw_correct_data = 0;
                    wdatap_dataread_rmw_partial      = 1'b0;
                    wdatap_dataread_rmw_correct      = 1'b0;
                end
            end
            
            // ecc code overwrite
            // - is asserted when we don't want controller to re-calculate the ecc code
            // - only allowed when we're not doing any writes in this clock
            // - only allowed when rmwfifo output is valid
            always @ (*)
            begin
                wdatap_ecc_code         = rmwfifo_output_ecc_code;
                
                if (cfg_enable_ecc_code_overwrites)
                begin
                    if (rmw_correct_r)
                    begin
                        wdatap_ecc_code_overwrite = rmwfifo_output_ecc_dbe;
                    end
                    else if (rmw_partial_r)
                    begin
                        if ( (|wdatap_dataread_buffer_dm) | (~rmwfifo_output_valid) )
                        begin
                            wdatap_ecc_code_overwrite = {CFG_ECC_MULTIPLES{1'b0}};
                        end
                        else
                        begin
                            wdatap_ecc_code_overwrite = rmwfifo_output_ecc_dbe;
                        end
                    end
                    else
                    begin
                        wdatap_ecc_code_overwrite = {CFG_ECC_MULTIPLES{1'b0}};
                    end
                end
                else
                begin
                    wdatap_ecc_code_overwrite = {CFG_ECC_MULTIPLES{1'b0}};
                end
            end
        end
    endgenerate

endmodule
