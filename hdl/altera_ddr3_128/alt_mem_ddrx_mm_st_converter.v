///////////////////////////////////////////////////////////////////////////////
// Title         : alt_mem_ddrx_mm_st_converter
//
// File          : alt_mem_ddrx_mm_st_converter.v
//
// Abstract      : take in Avalon MM interface and convert it to single cmd and 
//                 multiple data Avalon ST
//
///////////////////////////////////////////////////////////////////////////////

module alt_mem_ddrx_mm_st_converter # (
	parameter       
        AVL_SIZE_WIDTH   = 3,
        AVL_ADDR_WIDTH   = 25,
        AVL_DATA_WIDTH   = 32,
        LOCAL_ID_WIDTH = 8,
        CFG_DWIDTH_RATIO = 4
	
	) 
	(

	    ctl_clk, // controller clock
        ctl_reset_n, // controller reset_n, synchronous to ctl_clk

        ctl_half_clk, // controller clock, half-rate 
        ctl_half_clk_reset_n, // controller reset_n, synchronous to ctl_half_clk 

        // Avalon data slave interface
        avl_ready, // Avalon wait_n
        avl_read_req, // Avalon read 
        avl_write_req, // Avalon write
        avl_size, // Avalon burstcount
        avl_burstbegin, // Avalon burstbegin
        avl_addr, // Avalon address 
        avl_rdata_valid, // Avalon readdata_valid
        avl_rdata, // Avalon readdata
        avl_wdata, // Avalon writedata
        avl_be, // Avalon byteenble
        
        local_rdata_error, // Avalon readdata_error
        local_multicast, // In-band multicast
        local_autopch_req, // In-band auto-precharge request signal 
        local_priority, // In-band priority signal
        
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
		itf_rd_data_id	
);

    input ctl_clk;
    input ctl_reset_n;

    input ctl_half_clk;
    input ctl_half_clk_reset_n;

    output avl_ready;
    input avl_read_req;
    input avl_write_req;
    input  [AVL_SIZE_WIDTH-1:0] avl_size;
    input avl_burstbegin;
    input  [AVL_ADDR_WIDTH-1:0] avl_addr;
    output avl_rdata_valid;
    output [3:0] local_rdata_error;
    output [AVL_DATA_WIDTH-1:0] avl_rdata;
    input  [AVL_DATA_WIDTH-1:0] avl_wdata;
    input  [AVL_DATA_WIDTH/8-1:0] avl_be;
        
    input local_multicast;
    input local_autopch_req;
    input local_priority;
        
    input itf_cmd_ready;
    output itf_cmd_valid;
    output itf_cmd;
    output [AVL_ADDR_WIDTH-1:0] itf_cmd_address;
    output [AVL_SIZE_WIDTH-1:0] itf_cmd_burstlen;
    output [LOCAL_ID_WIDTH-1:0] itf_cmd_id;
    output itf_cmd_priority;
    output itf_cmd_autopercharge;
    output itf_cmd_multicast;
	
    input itf_wr_data_ready;
    output itf_wr_data_valid;
    output [AVL_DATA_WIDTH-1:0] itf_wr_data;
    output [AVL_DATA_WIDTH/8-1:0] itf_wr_data_byte_en;
    output itf_wr_data_begin;
    output itf_wr_data_last;
    output [LOCAL_ID_WIDTH-1:0] itf_wr_data_id;
		
    output itf_rd_data_ready;
    input itf_rd_data_valid;
    input [AVL_DATA_WIDTH-1:0] itf_rd_data;
    input itf_rd_data_error;
    input itf_rd_data_begin;
    input itf_rd_data_last;
    input [LOCAL_ID_WIDTH-1:0] itf_rd_data_id;
    

    reg [AVL_SIZE_WIDTH-1:0] burst_count;
	
    wire    int_ready;
    wire    itf_cmd; // high is write
    wire    itf_wr_if_ready;

    reg     data_pass;
    reg     [AVL_SIZE_WIDTH-1:0] burst_counter;
		
    // when cmd_ready = 1'b1, avl_ready = 1'b1;
    // when avl_write_req = 1'b1,
    // take this write req and then then drive avl_ready until receive # of beats = avl_size? 
    // we will look at cmd_ready, if cmd_ready = 1'b0, avl_ready = 1'b0
    // when cmd_ready = 1'b1, avl_ready = 1'b1;
    // when local_ready_req = 1'b1,
    // take this read_req
    // we will look at cmd_ready, if cmd_ready = 1'b0, avl_ready = 1'b0

    assign itf_cmd_valid = avl_read_req | itf_wr_if_ready;

    assign itf_wr_if_ready = itf_wr_data_ready & avl_write_req & ~data_pass;
    
    assign avl_ready = int_ready;
    assign itf_rd_data_ready = 1'b1;
    assign itf_cmd_address = avl_addr ;
    assign itf_cmd_burstlen = avl_size ;
    assign itf_cmd_autopercharge = local_autopch_req ;
    assign itf_cmd_priority = local_priority ;
    assign itf_cmd_multicast = local_multicast ;
    assign itf_cmd = avl_write_req;

    // write data channel
    assign itf_wr_data_valid = (data_pass) ? avl_write_req : itf_cmd_ready & avl_write_req;
    assign itf_wr_data = avl_wdata ;
    assign itf_wr_data_byte_en = avl_be ;
			 
    // read data channel
    assign avl_rdata_valid = itf_rd_data_valid;
    assign avl_rdata =  itf_rd_data;
    assign local_rdata_error = itf_rd_data_error;
    
    assign int_ready = (data_pass) ? itf_wr_data_ready : ((itf_cmd) ? (itf_wr_data_ready & itf_cmd_ready) : itf_cmd_ready);
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                burst_counter  <=  0;
            else
                begin
                    if (itf_wr_if_ready && avl_size > 1 && itf_cmd_ready)
                        burst_counter   <=  avl_size - 1;
                    else if (avl_write_req && itf_wr_data_ready)
                        burst_counter   <=  burst_counter - 1;
                end
        end                    
            
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                data_pass  <=  0;
            else
                begin
                    if (itf_wr_if_ready && avl_size > 1 && itf_cmd_ready)
                        data_pass  <=  1;
                    else if (burst_counter == 1 && avl_write_req && itf_wr_data_ready)
                        data_pass  <=  0;
                end
        end
		
endmodule
