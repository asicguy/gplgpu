`timescale 1 ps / 1 ps
module alt_mem_ddrx_input_if 
    #(parameter 
    CFG_LOCAL_DATA_WIDTH    = 64,
    CFG_LOCAL_ID_WIDTH      = 8,
    CFG_LOCAL_ADDR_WIDTH    = 33,
    CFG_LOCAL_SIZE_WIDTH    = 3,
    CFG_MEM_IF_CHIP         = 1,
    CFG_AFI_INTF_PHASE_NUM  = 2,
    CFG_CTL_ARBITER_TYPE    = "ROWCOL"
    )
    (
        // cmd channel
        itf_cmd_ready,
        itf_cmd_valid,
        itf_cmd,
        itf_cmd_address,
        itf_cmd_burstlen,
        itf_cmd_id,
        itf_cmd_priority,
        itf_cmd_autopercharge,
        itf_cmd_multicast,
    
        // write data channel
        itf_wr_data_ready,
        itf_wr_data_valid,
        itf_wr_data,
        itf_wr_data_byte_en,
        itf_wr_data_begin,
        itf_wr_data_last,
        itf_wr_data_id,
        
        // read data channel
        itf_rd_data_ready,
        itf_rd_data_valid,
        itf_rd_data,
        itf_rd_data_error,
        itf_rd_data_begin,
        itf_rd_data_last,
        itf_rd_data_id,
        itf_rd_data_id_early,
        itf_rd_data_id_early_valid,

        // command generator
        cmd_gen_full,
        cmd_valid,
        cmd_address,
        cmd_write,
        cmd_read,
        cmd_multicast,
        cmd_size,
        cmd_priority,
        cmd_autoprecharge,
        cmd_id,
        
        // write data path
        wr_data_mem_full,
        write_data_id,
        write_data,
        byte_en,
        write_data_valid,
        
        // read data path
        read_data,
        read_data_valid,
        read_data_error,
        read_data_localid,
        read_data_begin,
        read_data_last, 
        
        //side band
        local_refresh_req,
        local_refresh_chip,
        local_deep_powerdn_req,
        local_deep_powerdn_chip,
        local_self_rfsh_req,
        local_self_rfsh_chip,
        local_refresh_ack,
        local_deep_powerdn_ack,
        local_power_down_ack,
        local_self_rfsh_ack,
        local_init_done,
        
        bg_do_read,
        bg_do_rmw_correct,
        bg_do_rmw_partial,
        bg_localid,
        rfsh_req,
        rfsh_chip,
        deep_powerdn_req,
        deep_powerdn_chip,
        self_rfsh_req,
        self_rfsh_chip,
        rfsh_ack,
        deep_powerdn_ack,
        power_down_ack,
        self_rfsh_ack,
        init_done
    
    );

    localparam AFI_INTF_LOW_PHASE  = 0;
    localparam AFI_INTF_HIGH_PHASE = 1;

    // command channel
    output  itf_cmd_ready;
    input   [CFG_LOCAL_ADDR_WIDTH-1:0] itf_cmd_address;
    input   itf_cmd_valid;
    input   itf_cmd;
    input   [CFG_LOCAL_SIZE_WIDTH-1:0] itf_cmd_burstlen;
    input   [CFG_LOCAL_ID_WIDTH - 1 : 0] itf_cmd_id;
    input   itf_cmd_priority;
    input   itf_cmd_autopercharge;
    input   itf_cmd_multicast;
    
    // write data channel
    output  itf_wr_data_ready;
    input   itf_wr_data_valid;
    input   [CFG_LOCAL_DATA_WIDTH-1:0] itf_wr_data;
    input   [CFG_LOCAL_DATA_WIDTH/8-1:0] itf_wr_data_byte_en;
    input   itf_wr_data_begin;
    input   itf_wr_data_last;
    input   [CFG_LOCAL_ID_WIDTH-1:0] itf_wr_data_id;
        
    // read data channel
    input   itf_rd_data_ready;
    output  itf_rd_data_valid;
    output  [CFG_LOCAL_DATA_WIDTH-1:0] itf_rd_data;
    output  itf_rd_data_error;
    output  itf_rd_data_begin;
    output  itf_rd_data_last;
    output  [CFG_LOCAL_ID_WIDTH-1:0] itf_rd_data_id;
    output  [CFG_LOCAL_ID_WIDTH-1:0] itf_rd_data_id_early;
    output                           itf_rd_data_id_early_valid;
    
    // command generator
    input   cmd_gen_full;
    output  cmd_valid;
    output  [CFG_LOCAL_ADDR_WIDTH-1:0] cmd_address;
    output  cmd_write;
    output  cmd_read;
    output  cmd_multicast;
    output  [CFG_LOCAL_SIZE_WIDTH-1:0] cmd_size;
    output  cmd_priority;
    output  cmd_autoprecharge;
    output  [CFG_LOCAL_ID_WIDTH-1:0] cmd_id;

    // write data path
    output  [CFG_LOCAL_DATA_WIDTH-1:0] write_data;
    output  [CFG_LOCAL_DATA_WIDTH/8-1:0] byte_en;
    output  write_data_valid;
    input   wr_data_mem_full;
    output  [CFG_LOCAL_ID_WIDTH-1:0] write_data_id;

    // read data path
    input   [CFG_LOCAL_DATA_WIDTH-1:0] read_data;
    input   read_data_valid;
    input   read_data_error;
    input   [CFG_LOCAL_ID_WIDTH-1:0]read_data_localid;
    input   read_data_begin;
    input   read_data_last;
        
    //side band
    input   local_refresh_req;
    input   [CFG_MEM_IF_CHIP-1:0] local_refresh_chip;
    input   local_deep_powerdn_req;
    input   [CFG_MEM_IF_CHIP-1:0] local_deep_powerdn_chip;
    input   local_self_rfsh_req;
    input   [CFG_MEM_IF_CHIP-1:0] local_self_rfsh_chip;
    output  local_refresh_ack;
    output  local_deep_powerdn_ack;
    output  local_power_down_ack;
    output  local_self_rfsh_ack;
    output  local_init_done;
    
    //side band
    input   [CFG_AFI_INTF_PHASE_NUM - 1 : 0] bg_do_read;
    input   [CFG_LOCAL_ID_WIDTH     - 1 : 0] bg_localid;
    input   [CFG_AFI_INTF_PHASE_NUM - 1 : 0] bg_do_rmw_correct;
    input   [CFG_AFI_INTF_PHASE_NUM - 1 : 0] bg_do_rmw_partial;
    output  rfsh_req;
    output  [CFG_MEM_IF_CHIP-1:0] rfsh_chip;
    output  deep_powerdn_req;
    output  [CFG_MEM_IF_CHIP-1:0] deep_powerdn_chip;
    output  self_rfsh_req;
    output  [CFG_MEM_IF_CHIP-1:0] self_rfsh_chip;
    input   rfsh_ack;
    input   deep_powerdn_ack;
    input   power_down_ack;
    input   self_rfsh_ack;
    input   init_done;
        
    // command generator
    wire    cmd_priority;
    wire    [CFG_LOCAL_ADDR_WIDTH-1:0] cmd_address;
    wire    cmd_read;
    wire    cmd_write;
    wire    cmd_multicast;
    wire    cmd_gen_full;
    wire    cmd_valid;
    wire    itf_cmd_ready;
    wire    cmd_autoprecharge;
    wire    [CFG_LOCAL_SIZE_WIDTH-1:0] cmd_size;
    
    //side band
    wire   [CFG_AFI_INTF_PHASE_NUM - 1 : 0] bg_do_read;
    wire   [CFG_LOCAL_ID_WIDTH     - 1 : 0] bg_localid;
    wire   [CFG_AFI_INTF_PHASE_NUM - 1 : 0] bg_do_rmw_correct;
    wire   [CFG_AFI_INTF_PHASE_NUM - 1 : 0] bg_do_rmw_partial;
    wire rfsh_req;
    wire [CFG_MEM_IF_CHIP-1:0] rfsh_chip;
    wire deep_powerdn_req;
    wire [CFG_MEM_IF_CHIP-1:0] deep_powerdn_chip;
    wire    self_rfsh_req;
    //wire  rfsh_ack;
    //wire  deep_powerdn_ack;
    wire    power_down_ack;
    //wire  self_rfsh_ack;
    // wire init_done;
    
    //write data path
    wire    itf_wr_data_ready;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0] write_data;
    wire    write_data_valid;
    wire    [CFG_LOCAL_DATA_WIDTH/8-1:0] byte_en;
    wire    [CFG_LOCAL_ID_WIDTH-1:0] write_data_id; 
    
    //read data path
    wire    itf_rd_data_valid;
    wire    [CFG_LOCAL_DATA_WIDTH-1:0] itf_rd_data;
    wire    itf_rd_data_error;
    wire    itf_rd_data_begin;
    wire    itf_rd_data_last;
    wire    [CFG_LOCAL_ID_WIDTH-1:0] itf_rd_data_id;
    wire    [CFG_LOCAL_ID_WIDTH-1:0] itf_rd_data_id_early;
    wire    itf_rd_data_id_early_valid;
    
    // commmand generator
    assign cmd_priority                 = itf_cmd_priority;
    assign cmd_address                  = itf_cmd_address;
    assign cmd_multicast                = itf_cmd_multicast;
    assign cmd_size                     = itf_cmd_burstlen;
    assign cmd_autoprecharge            = itf_cmd_autopercharge;
    assign cmd_id                       = itf_cmd_id;
    
    // side band    
    assign rfsh_req                     = local_refresh_req;
    assign rfsh_chip                    = local_refresh_chip;
    assign deep_powerdn_req             = local_deep_powerdn_req;
    assign deep_powerdn_chip            = local_deep_powerdn_chip;
    assign self_rfsh_req                = local_self_rfsh_req;
    assign self_rfsh_chip               = local_self_rfsh_chip;
    assign local_refresh_ack            = rfsh_ack;
    assign local_deep_powerdn_ack       = deep_powerdn_ack;
    assign local_power_down_ack         = power_down_ack;
    assign local_self_rfsh_ack          = self_rfsh_ack;
    assign local_init_done              = init_done;
    
    //write data path
    assign write_data                   = itf_wr_data;
    assign byte_en                      = itf_wr_data_byte_en;
    assign write_data_valid             = itf_wr_data_valid;
    assign write_data_id                = itf_wr_data_id;
    
    // read data path
    assign itf_rd_data_id               = read_data_localid;
    assign itf_rd_data_error            = read_data_error;
    assign itf_rd_data_valid            = read_data_valid;
    assign itf_rd_data_begin            = read_data_begin;
    assign itf_rd_data_last             = read_data_last;
    assign itf_rd_data                  = read_data;
    assign itf_rd_data_id_early         = (itf_rd_data_id_early_valid) ? bg_localid : {CFG_LOCAL_ID_WIDTH{1'b0}};
	
	//==============================================================================
	// Logic below is to tie low itf_cmd_ready, itf_cmd_valid and itf_wr_data_ready when local_init_done is low
	assign itf_cmd_ready      = ~cmd_gen_full & local_init_done;
	assign itf_wr_data_ready  = ~wr_data_mem_full & local_init_done;
	assign cmd_read           = ~itf_cmd & itf_cmd_valid & local_init_done;
    assign cmd_write          = itf_cmd & itf_cmd_valid & local_init_done;
	assign cmd_valid          = itf_cmd_valid & local_init_done;

    generate
    begin : gen_rd_data_id_early_valid
        if (CFG_CTL_ARBITER_TYPE == "COLROW")
        begin
            assign itf_rd_data_id_early_valid = bg_do_read [AFI_INTF_LOW_PHASE] & ~(bg_do_rmw_correct[AFI_INTF_LOW_PHASE]|bg_do_rmw_partial[AFI_INTF_LOW_PHASE]);
        end
        else
        begin
            assign itf_rd_data_id_early_valid = bg_do_read [AFI_INTF_HIGH_PHASE] & ~(bg_do_rmw_correct[AFI_INTF_HIGH_PHASE]|bg_do_rmw_partial[AFI_INTF_HIGH_PHASE]);
        end
    end
    endgenerate

    
endmodule
