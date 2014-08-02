//Legal Notice: (C)2010 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

///////////////////////////////////////////////////////////////////////////////
// Title         : DDR controller Command Queue
//
// File          : alt_ddrx_command_queue.v
//
// Abstract      : Store incoming commands
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_cmd_queue 
    # (parameter	 MEM_IF_CSR_COL_WIDTH        = 4,
                     MEM_IF_CSR_ROW_WIDTH        = 5,
                     MEM_IF_CSR_BANK_WIDTH       = 2,
                     MEM_IF_CSR_CS_WIDTH         = 2, 
                     CTL_CMD_QUEUE_DEPTH         = 4,  
                     CTL_LOOK_AHEAD_DEPTH        = 4, 
                     MEM_IF_ROW_WIDTH            = 16, 
                     MEM_IF_COL_WIDTH            = 12,  
                     MEM_IF_BA_WIDTH             = 3,  
                     MEM_IF_CHIP_BITS            = 2,  
                     LOCAL_ADDR_WIDTH            = 33, 
                     DWIDTH_RATIO                = 4,
                     ENABLE_BURST_MERGE          = 1,
                     MIN_COL                     = 8,
                     MIN_ROW                     = 12,
                     MIN_BANK                    = 2,
                     MIN_CS                      = 1
	 )                                        
     (
	//input
	ctl_clk       , 								
	ctl_reset_n   ,                                                 		                                                	        
	read_req_to_cmd_queue  ,                                               		
	write_req_to_cmd_queue ,                                               		
	local_size      ,                                               		
	local_autopch_req ,  
    local_multicast ,
	local_cs_addr  	,
    local_bank_addr ,
    local_row_addr	,
    local_col_addr 	,
	                                                                                
	//input from State Machine                                      		
	fetch,                                               	                                                           		                                                   		
                                                                        		
	//output                                                        		
	cmd_fifo_empty, 			                                        
	cmd_fifo_full,   
	cmd_fifo_wren,
    
	cmd0_is_a_read,                                                                 
	cmd0_is_a_write,                                                                
	cmd0_autopch_req,                                                            
	cmd0_burstcount,                                                                
	cmd0_chip_addr,                                                                 
	cmd0_row_addr,                                                                  
	cmd0_bank_addr,                                                                 
	cmd0_col_addr,
	cmd0_is_valid,   
    cmd0_multicast_req,
	                                                                                
	cmd1_is_a_read,                                                                 
	cmd1_is_a_write,
	cmd1_chip_addr,                                                                 
	cmd1_row_addr,                                                                  
	cmd1_bank_addr,
	cmd1_is_valid,   
    cmd1_multicast_req,
	                                                                                
	cmd2_is_a_read,                                                                 
	cmd2_is_a_write,  
    cmd2_chip_addr,                                                                 
	cmd2_row_addr,                                                                  
	cmd2_bank_addr,
	cmd2_is_valid,  
    cmd2_multicast_req,
     
    cmd3_is_a_read,                                                                 
	cmd3_is_a_write,  
	cmd3_chip_addr,                                                                 
	cmd3_row_addr,                                                                  
	cmd3_bank_addr,		                                                                                                    		
	cmd3_is_valid, 
	cmd3_multicast_req,
    
    cmd4_is_a_read,                                                                 
	cmd4_is_a_write,
	cmd4_is_valid,                                                  		                                                           
	cmd4_chip_addr,                                                                 
	cmd4_row_addr,                                                  		
	cmd4_bank_addr,    
    cmd4_multicast_req,
	
    cmd5_is_a_read,                                                                 
	cmd5_is_a_write,
	cmd5_is_valid,                                                  		                                                          
	cmd5_chip_addr,                                                                 
	cmd5_row_addr,                                                  		
	cmd5_bank_addr,   
    cmd5_multicast_req,
	
    cmd6_is_a_read,                                                                 
	cmd6_is_a_write,
	cmd6_is_valid,                                                  		                                                         
	cmd6_chip_addr,                                                                 
	cmd6_row_addr,                                                  		
	cmd6_bank_addr,  
    cmd6_multicast_req,
	
    cmd7_is_a_read,                                                                 
	cmd7_is_a_write,
	cmd7_is_valid,                                                  		
	cmd7_chip_addr,                                                         
	cmd7_row_addr,                                                  		
	cmd7_bank_addr,
    cmd7_multicast_req
    ); 
    localparam   LOCAL_SIZE_WIDTH     = 2;
    localparam   BUFFER_WIDTH         = 1 + 1 + 1 + 1 + LOCAL_SIZE_WIDTH + MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH;
    localparam   THIS_ENTRY_WIDTH     = 1 + 1 + 1 + MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH;
    localparam   MAX_COL              = MEM_IF_COL_WIDTH;
    localparam   MAX_ROW              = MEM_IF_ROW_WIDTH;
    localparam   MAX_BANK             = MEM_IF_BA_WIDTH;
    localparam   MAX_CS               = MEM_IF_CHIP_BITS;
    
    input                		          ctl_clk       	; 	// controller clock
    input                		          ctl_reset_n   	; 	// controller reset_n, synchronous to ctl_clk
	                 		              
	input 		     		              read_req_to_cmd_queue  	;
	input 		     		              write_req_to_cmd_queue 	;
	input [LOCAL_SIZE_WIDTH-1:0]          local_size      	;
	input		     		              local_autopch_req ;
    input                                 local_multicast   ;
	input [MEM_IF_CHIP_BITS-1:0]          local_cs_addr	    ;
    input [MEM_IF_ROW_WIDTH-1:0]          local_row_addr    ;
    input [MEM_IF_BA_WIDTH-1:0]           local_bank_addr   ;
    input [MEM_IF_COL_WIDTH-1:0]          local_col_addr    ;
	output               		          cmd_fifo_empty	;      
	output               		          cmd_fifo_full	    ;    
    output                                cmd_fifo_wren     ;
	
	//input from State Machine
	input 				                  fetch;
	
	output               		          cmd0_is_valid;
    output                		          cmd0_is_a_read;
    output                		          cmd0_is_a_write;
	output		     		              cmd0_autopch_req;
    output [LOCAL_SIZE_WIDTH-1:0]         cmd0_burstcount;
    output [MEM_IF_CHIP_BITS-1:0]         cmd0_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd0_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd0_bank_addr;
	output [MEM_IF_COL_WIDTH-1:0]         cmd0_col_addr;
    output                                cmd0_multicast_req;
	
	output               		          cmd1_is_valid;
    output                		          cmd1_is_a_read;
    output                		          cmd1_is_a_write;
    output [MEM_IF_CHIP_BITS-1:0]         cmd1_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd1_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd1_bank_addr;
    output                                cmd1_multicast_req;
	
	output               		          cmd2_is_valid;
    output                		          cmd2_is_a_read;
    output                		          cmd2_is_a_write;
    output [MEM_IF_CHIP_BITS-1:0]         cmd2_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd2_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd2_bank_addr;
    output                                cmd2_multicast_req;
	
	output               		          cmd3_is_valid;
    output                		          cmd3_is_a_read;
    output                		          cmd3_is_a_write;
    output [MEM_IF_CHIP_BITS-1:0]         cmd3_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd3_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd3_bank_addr;
    output                                cmd3_multicast_req;
	
    output                		          cmd4_is_a_read;
    output                		          cmd4_is_a_write;
	output               		          cmd4_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd4_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd4_row_addr;
	output [MEM_IF_BA_WIDTH-1:0]          cmd4_bank_addr;
    output                                cmd4_multicast_req;
    
    output                		          cmd5_is_a_read;
    output                		          cmd5_is_a_write;
	output               		          cmd5_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd5_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd5_row_addr; 
	output [MEM_IF_BA_WIDTH-1:0]          cmd5_bank_addr;
    output                                cmd5_multicast_req;
    
    output                		          cmd6_is_a_read;
    output                		          cmd6_is_a_write;
	output               		          cmd6_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd6_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd6_row_addr; 
	output [MEM_IF_BA_WIDTH-1:0]          cmd6_bank_addr;
    output                                cmd6_multicast_req;
    
    output                		          cmd7_is_a_read;
    output                		          cmd7_is_a_write;
	output               		          cmd7_is_valid;
	output [MEM_IF_CHIP_BITS-1:0]         cmd7_chip_addr;
	output [MEM_IF_ROW_WIDTH-1:0]         cmd7_row_addr; 
	output [MEM_IF_BA_WIDTH-1:0]          cmd7_bank_addr;
    output                                cmd7_multicast_req;
	
    integer                               n;
	integer                               j;
	integer                               k;
	integer                               m;
    
    reg [BUFFER_WIDTH-1:0]		          pipe[CTL_CMD_QUEUE_DEPTH-1:0];		
	reg 				                  pipefull[CTL_CMD_QUEUE_DEPTH-1:0];
    
    reg [LOCAL_SIZE_WIDTH-1:0]            last_size;
    reg                                   last_read_req;
    reg                                   last_write_req;
    reg                                   last_multicast;
    reg [MEM_IF_CHIP_BITS-1:0]            last_chip_addr;
    reg [MEM_IF_ROW_WIDTH-1:0]            last_row_addr;
    reg [MEM_IF_BA_WIDTH-1:0]             last_bank_addr;
    reg [MEM_IF_COL_WIDTH-1:0]            last_col_addr;
    
    reg [LOCAL_SIZE_WIDTH-1:0]            last2_size;
    reg                                   last2_read_req;
    reg                                   last2_write_req;
    reg                                   last2_multicast;
    reg [MEM_IF_CHIP_BITS-1:0]            last2_chip_addr;
    reg [MEM_IF_ROW_WIDTH-1:0]            last2_row_addr;
    reg [MEM_IF_BA_WIDTH-1:0]             last2_bank_addr;
    reg [MEM_IF_COL_WIDTH-1:0]            last2_col_addr;
    
	wire [MEM_IF_CHIP_BITS-1:0]           cs_addr  ;
	wire [MEM_IF_ROW_WIDTH-1:0]           row_addr ;
	wire [MEM_IF_BA_WIDTH-1:0]            bank_addr;
	wire [MEM_IF_COL_WIDTH-1:0]           col_addr ;
    
	wire 		     		              read_req_to_cmd_queue  	;
	wire 		     		              write_req_to_cmd_queue 	;
	wire		     		              local_autopch_req ;
    wire                                  local_multicast;
    wire                                  local_multicast_gated;
	wire  [LOCAL_SIZE_WIDTH-1:0] 	      local_size;
	wire				                  fetch;
	wire [BUFFER_WIDTH-1:0]		          buffer_input;
	wire				                  wreq_to_fifo;  

    wire [MEM_IF_CHIP_BITS-1:0]           pipe_chip_addr     [CTL_CMD_QUEUE_DEPTH-1:0];
    wire [MEM_IF_ROW_WIDTH-1:0]           pipe_row_addr      [CTL_CMD_QUEUE_DEPTH-1:0];
    wire [MEM_IF_BA_WIDTH-1:0]            pipe_bank_addr     [CTL_CMD_QUEUE_DEPTH-1:0];
    wire [MEM_IF_COL_WIDTH-1:0]           pipe_col_addr      [CTL_CMD_QUEUE_DEPTH-1:0];
    wire                                  pipe_read_req      [CTL_CMD_QUEUE_DEPTH-1:0];
    wire                                  pipe_write_req     [CTL_CMD_QUEUE_DEPTH-1:0];
    wire                                  pipe_autopch_req   [CTL_CMD_QUEUE_DEPTH-1:0];
    wire                                  pipe_multicast_req [CTL_CMD_QUEUE_DEPTH-1:0];
    wire [LOCAL_SIZE_WIDTH-1:0]           pipe_burstcount    [CTL_CMD_QUEUE_DEPTH-1:0];
    
	reg  [log2(CTL_CMD_QUEUE_DEPTH)-1:0]    last;
    reg  [log2(CTL_CMD_QUEUE_DEPTH)-1:0]    last_minus_one;
    reg  [log2(CTL_CMD_QUEUE_DEPTH)-1:0]    last_minus_two;
    wire                                  can_merge;

    wire                                  cmd_fifo_wren;
	wire				                  cmd0_is_valid;
	wire                		          cmd0_is_a_read;
	wire                		          cmd0_is_a_write;
	wire		     		              cmd0_autopch_req;
	wire [LOCAL_SIZE_WIDTH-1:0]           cmd0_burstcount;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd0_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd0_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd0_bank_addr;
	wire [MEM_IF_COL_WIDTH-1:0]           cmd0_col_addr;
    wire                                  cmd0_multicast_req;

	wire               		              cmd1_is_valid;
    wire                		          cmd1_is_a_read;
    wire                		          cmd1_is_a_write;
    wire [MEM_IF_CHIP_BITS-1:0]           cmd1_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd1_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd1_bank_addr;
    wire                                  cmd1_multicast_req;

	wire               		              cmd2_is_valid;
    wire                		          cmd2_is_a_read;
    wire                		          cmd2_is_a_write;
    wire [MEM_IF_CHIP_BITS-1:0]           cmd2_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd2_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd2_bank_addr;
    wire                                  cmd2_multicast_req;

	wire               		              cmd3_is_valid;
    wire                		          cmd3_is_a_read;
    wire                		          cmd3_is_a_write;
    wire [MEM_IF_CHIP_BITS-1:0]           cmd3_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd3_row_addr;
	wire [MEM_IF_BA_WIDTH-1:0]            cmd3_bank_addr;
    wire                                  cmd3_multicast_req;
    
    wire                		          cmd4_is_a_read;
    wire                		          cmd4_is_a_write;
	wire               		              cmd4_is_valid;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd4_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd4_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd4_bank_addr;
    wire                                  cmd4_multicast_req;
    
    wire                		          cmd5_is_a_read;
    wire                		          cmd5_is_a_write;
	wire               		              cmd5_is_valid;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd5_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd5_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd5_bank_addr;
    wire                                  cmd5_multicast_req;
    
    wire                		          cmd6_is_a_read;
    wire                		          cmd6_is_a_write;
	wire               		              cmd6_is_valid;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd6_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd6_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd6_bank_addr;
    wire                                  cmd6_multicast_req;
    
    wire                		          cmd7_is_a_read;
    wire                		          cmd7_is_a_write;
	wire               		              cmd7_is_valid;
	wire [MEM_IF_CHIP_BITS-1:0]           cmd7_chip_addr;
	wire [MEM_IF_ROW_WIDTH-1:0]           cmd7_row_addr; 
	wire [MEM_IF_BA_WIDTH-1:0]            cmd7_bank_addr;
    wire                                  cmd7_multicast_req;

    genvar 			      	              i;     
    
    assign cs_addr = local_cs_addr;
    assign bank_addr = local_bank_addr;
    assign row_addr = local_row_addr;
    assign col_addr = local_col_addr;

// gate multicast request with write request, we only support multicast write
    assign local_multicast_gated = local_multicast & write_req_to_cmd_queue;

// mapping of buffer_input
	assign buffer_input = {read_req_to_cmd_queue,write_req_to_cmd_queue,local_multicast_gated,local_autopch_req,local_size,cs_addr,row_addr,bank_addr,col_addr};
	
//======================  Bus to output signals mapping   =======================
	//pipe address
    generate begin
        for(i=0; i<CTL_CMD_QUEUE_DEPTH; i=i+1) begin : pipe_loop
            assign pipe_read_req[i]         = pipe[i][BUFFER_WIDTH-1];
            assign pipe_write_req[i]        = pipe[i][BUFFER_WIDTH-2];
            assign pipe_multicast_req[i]    = pipe[i][BUFFER_WIDTH-3];
            assign pipe_autopch_req[i]      = pipe[i][BUFFER_WIDTH-4];
            assign pipe_burstcount[i]       = pipe[i][LOCAL_SIZE_WIDTH + MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH];
            assign pipe_chip_addr[i]        = pipe[i][MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH];
            assign pipe_row_addr[i]         = pipe[i][MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH];
            assign pipe_bank_addr[i]        = pipe[i][MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_COL_WIDTH];
            assign pipe_col_addr[i]         = pipe[i][MEM_IF_COL_WIDTH - 1 : 0];
        end
    end
	endgenerate 
    
    assign cmd0_is_valid                = pipefull[0];
    assign cmd0_is_a_read               = pipe_read_req   [0];
    assign cmd0_is_a_write              = pipe_write_req  [0];
    assign cmd0_autopch_req             = pipe_autopch_req[0];
    assign cmd0_burstcount              = pipe_burstcount [0];
    assign cmd0_chip_addr               = pipe_chip_addr  [0];
    assign cmd0_row_addr                = pipe_row_addr   [0];
    assign cmd0_bank_addr               = pipe_bank_addr  [0];
    assign cmd0_col_addr                = pipe_col_addr   [0];
    assign cmd0_multicast_req           = pipe_multicast_req [0];
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 0)
            begin
                assign cmd1_is_valid                = pipefull[1];
                assign cmd1_is_a_read               = pipe_read_req   [1];
                assign cmd1_is_a_write              = pipe_write_req  [1];
                assign cmd1_chip_addr               = pipe_chip_addr  [1];
                assign cmd1_row_addr                = pipe_row_addr   [1];
                assign cmd1_bank_addr               = pipe_bank_addr  [1];
                assign cmd1_multicast_req           = pipe_multicast_req [1];
            end
        else
            begin
                assign cmd1_is_valid                = 0;
                assign cmd1_is_a_read               = 0;
                assign cmd1_is_a_write              = 0;
                assign cmd1_chip_addr               = 0;
                assign cmd1_row_addr                = 0;
                assign cmd1_bank_addr               = 0;
                assign cmd1_multicast_req           = 0;
            end
    endgenerate
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 2)
            begin
                assign cmd2_is_valid                = pipefull[2];
                assign cmd2_is_a_read               = pipe_read_req   [2];
                assign cmd2_is_a_write              = pipe_write_req  [2];
                assign cmd2_chip_addr               = pipe_chip_addr  [2];
                assign cmd2_row_addr                = pipe_row_addr   [2];
                assign cmd2_bank_addr               = pipe_bank_addr  [2];
                assign cmd2_multicast_req           = pipe_multicast_req [2];
                
                assign cmd3_is_valid                = pipefull[3];
                assign cmd3_is_a_read               = pipe_read_req   [3];
                assign cmd3_is_a_write              = pipe_write_req  [3];
                assign cmd3_chip_addr               = pipe_chip_addr  [3];
                assign cmd3_row_addr                = pipe_row_addr   [3];
                assign cmd3_bank_addr               = pipe_bank_addr  [3];
                assign cmd3_multicast_req           = pipe_multicast_req [3];
            end
        else
            begin
                assign cmd2_is_valid                = 0;
                assign cmd2_is_a_read               = 0;
                assign cmd2_is_a_write              = 0;
                assign cmd2_chip_addr               = 0;
                assign cmd2_row_addr                = 0;
                assign cmd2_bank_addr               = 0;
                assign cmd2_multicast_req           = 0;
                
                assign cmd3_is_valid                = 0;
                assign cmd3_is_a_read               = 0;
                assign cmd3_is_a_write              = 0;
                assign cmd3_chip_addr               = 0;
                assign cmd3_row_addr                = 0;
                assign cmd3_bank_addr               = 0;
                assign cmd3_multicast_req           = 0;
            end
    endgenerate
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 4)
            begin
                assign cmd4_is_valid                = pipefull[4];
                assign cmd4_is_a_read               = pipe_read_req [4];
                assign cmd4_is_a_write              = pipe_write_req[4];
                assign cmd4_chip_addr               = pipe_chip_addr[4];
                assign cmd4_row_addr                = pipe_row_addr [4];
                assign cmd4_bank_addr               = pipe_bank_addr[4];
                assign cmd4_multicast_req           = pipe_multicast_req [4];
                
                assign cmd5_is_valid                = pipefull[5];
                assign cmd5_is_a_read               = pipe_read_req [5];
                assign cmd5_is_a_write              = pipe_write_req[5];
                assign cmd5_chip_addr               = pipe_chip_addr[5];
                assign cmd5_row_addr                = pipe_row_addr [5];
                assign cmd5_bank_addr               = pipe_bank_addr[5];
                assign cmd5_multicast_req           = pipe_multicast_req [5];
            end
        else
            begin
                assign cmd4_is_valid                = 0;
                assign cmd4_is_a_read               = 0;
                assign cmd4_is_a_write              = 0;
                assign cmd4_chip_addr               = 0;
                assign cmd4_row_addr                = 0;
                assign cmd4_bank_addr               = 0;
                assign cmd4_multicast_req           = 0;
                
                assign cmd5_is_valid                = 0;
                assign cmd5_is_a_read               = 0;
                assign cmd5_is_a_write              = 0;
                assign cmd5_chip_addr               = 0;
                assign cmd5_row_addr                = 0;
                assign cmd5_bank_addr               = 0;
                assign cmd5_multicast_req           = 0;
            end
    endgenerate
    
    generate
        if (CTL_LOOK_AHEAD_DEPTH > 6)
            begin
                assign cmd6_is_valid                = pipefull[6];
                assign cmd6_is_a_read               = pipe_read_req [6];
                assign cmd6_is_a_write              = pipe_write_req[6];
                assign cmd6_chip_addr               = pipe_chip_addr[6];
                assign cmd6_row_addr                = pipe_row_addr [6];
                assign cmd6_bank_addr               = pipe_bank_addr[6];
                assign cmd6_multicast_req           = pipe_multicast_req [6];
                
                assign cmd7_is_valid                = pipefull[7];
                assign cmd7_is_a_read               = pipe_read_req [7];
                assign cmd7_is_a_write              = pipe_write_req[7];
                assign cmd7_chip_addr               = pipe_chip_addr[7];
                assign cmd7_row_addr                = pipe_row_addr [7];
                assign cmd7_bank_addr               = pipe_bank_addr[7];
                assign cmd7_multicast_req           = pipe_multicast_req [7];
            end
        else
            begin
                assign cmd6_is_valid                = 0;
                assign cmd6_is_a_read               = 0;
                assign cmd6_is_a_write              = 0;
                assign cmd6_chip_addr               = 0;
                assign cmd6_row_addr                = 0;
                assign cmd6_bank_addr               = 0;
                assign cmd6_multicast_req           = 0;
                
                assign cmd7_is_valid                = 0;
                assign cmd7_is_a_read               = 0;
                assign cmd7_is_a_write              = 0;
                assign cmd7_chip_addr               = 0;
                assign cmd7_row_addr                = 0;
                assign cmd7_bank_addr               = 0;
                assign cmd7_multicast_req           = 0;
            end
    endgenerate
    
//======================  end of Bus to output signals mapping   ================  
	
//======================   sequential address detector   ========================
	
	//Last pipeline entry
    always @(posedge ctl_clk or negedge ctl_reset_n) begin   
         if (!ctl_reset_n) begin
             last_read_req      <= 1'b0; 
             last_write_req     <= 1'b0; 
             last_chip_addr     <= {MEM_IF_CHIP_BITS{1'b0}}; 
             last_row_addr      <= {MEM_IF_ROW_WIDTH{1'b0}}; 
             last_bank_addr     <= {MEM_IF_BA_WIDTH{1'b0}}; 
             last_col_addr      <= {MEM_IF_COL_WIDTH{1'b0}}; 
             last_size          <= {LOCAL_SIZE_WIDTH{1'b0}}; 
             last_multicast     <= 1'b0;
         end
         else  if (wreq_to_fifo) begin
                    last_read_req   <= read_req_to_cmd_queue;
                    last_write_req  <= write_req_to_cmd_queue;
                    last_multicast  <= local_multicast_gated;
                    last_chip_addr  <= cs_addr;
                    last_bank_addr  <= bank_addr;
                    last_row_addr   <= row_addr;
                    last_col_addr   <= col_addr;
                    last_size       <= local_size;
         end
         else if (can_merge)
             last_size          <= 2;
    end
    
    //Second last pipeline entry
    always @(posedge ctl_clk or negedge ctl_reset_n) begin   
         if (!ctl_reset_n) begin
             last2_read_req     <= 1'b0; 
             last2_write_req    <= 1'b0; 
             last2_chip_addr    <= {MEM_IF_CHIP_BITS{1'b0}}; 
             last2_row_addr     <= {MEM_IF_ROW_WIDTH{1'b0}}; 
             last2_bank_addr    <= {MEM_IF_BA_WIDTH{1'b0}}; 
             last2_col_addr     <= {MEM_IF_COL_WIDTH{1'b0}}; 
             last2_size         <= {LOCAL_SIZE_WIDTH{1'b0}}; 
             last2_multicast    <= 1'b0;
         end
         else  if (wreq_to_fifo) begin
                    last2_read_req  <= last_read_req;
                    last2_write_req <= last_write_req;
                    last2_multicast <= last_multicast;
                    last2_chip_addr <= last_chip_addr;
                    last2_bank_addr <= last_bank_addr;
                    last2_row_addr  <= last_row_addr;
                    last2_col_addr  <= last_col_addr;
                    last2_size      <= last_size;
         end
    end
    
    always @(posedge ctl_clk or negedge ctl_reset_n) begin
        if (!ctl_reset_n) begin
            last <= 0;
            last_minus_one <= 0;
            last_minus_two <= 0;
        end
        else 
            if (fetch) begin                    // fetch and write
                if (can_merge && last != 1)
                    begin
                        if (wreq_to_fifo)
                            begin
                                last <=  last - 1;
                                last_minus_one <=  last - 2;
                                last_minus_two <=  last - 3;
                            end
                        else
                            begin
                                last <=  last - 2;
                                last_minus_one <=  last - 3;
                                last_minus_two <=  last - 4;
                            end
                    end
                else
                    begin
                        if (wreq_to_fifo) begin
                            // do nothing
                        end
                        else if (last != 0)
                            begin
                                last <=  last - 1;
                                last_minus_one <=  last - 2;
                                last_minus_two <=  last - 3;
                            end
                    end
            end
            else if (wreq_to_fifo) begin   // write only
                if (can_merge)
                    begin
                        // do nothing
                    end
                else
                    if (!cmd_fifo_empty)
                        begin
                            last <=  last + 1;
                            last_minus_one <=  last;
                            last_minus_two <=  last - 1;
                        end
            end
            else if (can_merge)
                begin
                    last <=  last - 1;
                    last_minus_one <=  last - 2;
                    last_minus_two <=  last - 3;
                end
    end
    
    assign  can_merge   =   (ENABLE_BURST_MERGE == 1) ?
                            last != 0
                            & pipefull[last]
                            & last2_read_req == last_read_req
                            & last2_write_req == last_write_req
                            & last2_multicast == last_multicast
                            & last2_chip_addr == last_chip_addr
                            & last2_bank_addr == last_bank_addr
                            & last2_row_addr == last_row_addr
                            & ((DWIDTH_RATIO == 2) ? (last2_col_addr[MEM_IF_COL_WIDTH-1 : 2] == last_col_addr[MEM_IF_COL_WIDTH-1 : 2]) : (last2_col_addr[MEM_IF_COL_WIDTH-1 : 3] == last_col_addr[MEM_IF_COL_WIDTH-1 : 3]) )
                            & ((DWIDTH_RATIO == 2) ? (last2_col_addr[1] == 0 & last_col_addr[1] == 1) : (last2_col_addr[2] == 0 & last_col_addr[2] == 1) )
                            & last2_size == 1 & last_size == 1
                            :
                            1'b0;
	
//===================   end of sequential address detector   ====================

//===============================    queue    ===================================
    
	// avalon_write_req & avalon_read_req is AND with internal_ready in alt_ddrx_avalon_if.v
    assign wreq_to_fifo = (read_req_to_cmd_queue) | (write_req_to_cmd_queue);
    assign cmd_fifo_wren = (read_req_to_cmd_queue) | (write_req_to_cmd_queue);
	assign cmd_fifo_empty = !pipefull[0];
	assign cmd_fifo_full = pipefull[CTL_CMD_QUEUE_DEPTH-1];
    
    //pipefull and pipe register chain
    //feed 0 to pipefull entry that is empty
    always @(posedge ctl_clk or negedge ctl_reset_n) begin
        if (!ctl_reset_n) begin
            for(j=0; j<CTL_CMD_QUEUE_DEPTH; j=j+1) begin
                pipefull[j] <= 1'b0;
                pipe[j] <= 0;
            end
        end
        else 
            if (fetch) begin                    // fetch and write
                if (can_merge && last != 1)
                    begin
                        for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                            if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0) begin
                                pipefull[j] <= 1'b0;
                            end
                            else if (j == last_minus_one) begin
                                pipefull[j] <= wreq_to_fifo;
                                pipe[j] <= buffer_input;
                            end
                            else if (j == last_minus_two) begin
                                pipe[j] <= {pipe[j+1][BUFFER_WIDTH-1:BUFFER_WIDTH-4],2'd2,pipe[j+1][BUFFER_WIDTH-7:0]};
                            end
                            else begin
                                pipefull[j] <= pipefull[j+1];
                                pipe[j] <= pipe[j+1];
                            end
                        end
                        pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                        pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1] & buffer_input;
                    end
                else
                    begin
                        for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                            if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0) begin
                                pipefull[j] <= wreq_to_fifo;
                                pipe[j] <= buffer_input;
                            end
                            else begin
                                pipefull[j] <= pipefull[j+1];
                                pipe[j] <= pipe[j+1];
                            end
                        end
                        pipefull[CTL_CMD_QUEUE_DEPTH-1] <= pipefull[CTL_CMD_QUEUE_DEPTH-1] & wreq_to_fifo;
                        pipe[CTL_CMD_QUEUE_DEPTH-1] <= pipe[CTL_CMD_QUEUE_DEPTH-1] & buffer_input;
                    end
            end
            else if (wreq_to_fifo) begin   // write only
                if (can_merge)
                    begin
                        pipe[last] <= buffer_input;
                        pipe[last_minus_one][LOCAL_SIZE_WIDTH + MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH] <= 2;
                    end
                else
                    begin
                        for(j=1; j<CTL_CMD_QUEUE_DEPTH; j=j+1) begin
                            if(pipefull[j-1] == 1'b1 & pipefull[j] == 1'b0) begin
                                pipefull[j] <= 1'b1;
                                pipe[j] <= buffer_input;
                            end
                        end
                        if(pipefull[0] == 1'b0) begin
                            pipefull[0] <= 1'b1;
                            pipe[0] <= buffer_input;
                        end
                    end
            end
            else if (can_merge)
                begin
                    for(j=0; j<CTL_CMD_QUEUE_DEPTH-1; j=j+1) begin
                        if(pipefull[j] == 1'b1 & pipefull[j+1] == 1'b0)
                            pipefull[j] <= 1'b0;
                        else
                            pipefull[j] <= pipefull[j+1];
                    end
                    pipefull[CTL_CMD_QUEUE_DEPTH-1] <= 1'b0;
                    pipe[last_minus_one][LOCAL_SIZE_WIDTH + MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_CHIP_BITS + MEM_IF_ROW_WIDTH  + MEM_IF_BA_WIDTH + MEM_IF_COL_WIDTH] <= 2;
                end
    end
    
//============================    end of queue    ===============================  

    function integer log2;  //constant function
           input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
    endfunction
    
endmodule
