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
// Title         : DDR controller Input Interface
//
// File          : alt_ddrx_input_if.v
//
// Abstract      : Input interface
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_input_if
     #(parameter     MEM_TYPE               = "DDR3",
                     INTERNAL_SIZE_WIDTH    = 7,
                     INTERNAL_DATA_WIDTH    = 64,
                     CTL_HRB_ENABLED        = 0,
                     CTL_CSR_ENABLED        = 0,
                     CTL_REGDIMM_ENABLED    = 0,
                     MEM_IF_CSR_COL_WIDTH   = 4,
                     MEM_IF_CSR_ROW_WIDTH   = 5,
                     MEM_IF_CSR_BANK_WIDTH  = 2,
                     MEM_IF_CSR_CS_WIDTH    = 2, 
                     WDATA_BEATS_WIDTH      = 9,
                     LOCAL_DATA_WIDTH       = 64, 
                     LOCAL_ADDR_WIDTH       = 33,
                     LOCAL_SIZE_WIDTH       = 6,
                     CTL_LOOK_AHEAD_DEPTH   = 4,
                     CTL_CMD_QUEUE_DEPTH    = 4,
                     MEM_IF_ROW_WIDTH       = 16, 
                     MEM_IF_COL_WIDTH       = 12,  
                     MEM_IF_BA_WIDTH        = 3,  
                     MEM_IF_CHIP_BITS	    = 2,  
                     DWIDTH_RATIO           = 2,
                     MEMORY_BURSTLENGTH     = 8,
                     ENABLE_BURST_MERGE     = 1,
                     FAMILY                 = "Stratix",
                     MIN_COL                = 8,
                     MIN_ROW                = 12,
                     MIN_BANK               = 2,
                     MIN_CS                 = 1,
                     LOCAL_IF_TYPE          = "AVALON"
                     
     )(
        // port connections
        ctl_clk ,
        ctl_reset_n ,
        ctl_half_clk ,
        ctl_half_clk_reset_n ,
        
        //---------------------------------------------------------------------
        // user side signals
        //---------------------------------------------------------------------
        local_read_req     ,
        local_write_req    ,
        local_ready        ,
        local_size         ,
        local_autopch_req  ,
        local_multicast    ,
        local_burstbegin   ,
        local_init_done    ,
        local_addr         ,
        local_rdata_error  ,
        local_rdata_valid  ,
        local_rdata        ,
        local_wdata        ,
        local_be           ,
        local_wdata_req    ,
        ecc_rdata          ,
        ecc_rdata_valid    ,
        ecc_rdata_error    ,
        

        wdata_fifo_wdata   ,
        wdata_fifo_be      ,
        beats_in_wfifo      ,
        write_req_to_wfifo  ,
        be_to_wfifo         ,

        addr_order	        ,    
        col_width_from_csr	,    
        row_width_from_csr	,    
        bank_width_from_csr ,    
        cs_width_from_csr 	,    
        regdimm_enable   	,    
        
        wdata_fifo_read     ,
        fetch		        , 
        
        ctl_cal_success     ,
        ctl_cal_fail        ,
                            
        cmd_fifo_empty	    , 
        cmd_fifo_full 		,
                            
        cmd_fifo_wren       ,
        cmd0_is_a_read		, 
        cmd0_is_a_write     ,
        cmd0_autopch_req    ,
        cmd0_burstcount     ,
        cmd0_chip_addr      ,
        cmd0_row_addr       ,
        cmd0_bank_addr      ,
        cmd0_col_addr       ,
        cmd0_is_valid		,
        cmd0_multicast_req  ,
                            
        cmd1_is_a_read		, 
        cmd1_is_a_write     ,
        cmd1_chip_addr      ,
        cmd1_row_addr       ,
        cmd1_bank_addr      ,
        cmd1_is_valid		,
        cmd1_multicast_req  ,
                            
        cmd2_is_a_read		, 
        cmd2_is_a_write     ,
        cmd2_chip_addr      ,
        cmd2_row_addr       ,
        cmd2_bank_addr      ,
        cmd2_is_valid		,
        cmd2_multicast_req  ,
                            
        cmd3_is_a_read		, 
        cmd3_is_a_write     ,
        cmd3_chip_addr      ,
        cmd3_row_addr       ,
        cmd3_bank_addr      ,
        cmd3_is_valid		, 
        cmd3_multicast_req  ,
        
        cmd4_is_a_read		, 
        cmd4_is_a_write     ,
        cmd4_chip_addr      ,
        cmd4_row_addr       ,
        cmd4_bank_addr      ,
        cmd4_is_valid		, 
        cmd4_multicast_req  ,
        
        cmd5_is_a_read		, 
        cmd5_is_a_write     ,
        cmd5_chip_addr      ,
        cmd5_row_addr       ,
        cmd5_bank_addr      ,
        cmd5_is_valid		, 
        cmd5_multicast_req  ,
        
        cmd6_is_a_read		, 
        cmd6_is_a_write     ,
        cmd6_chip_addr      ,
        cmd6_row_addr       ,
        cmd6_bank_addr      ,
        cmd6_is_valid		, 
        cmd6_multicast_req  ,
        
        cmd7_is_a_read		, 
        cmd7_is_a_write     ,
        cmd7_chip_addr      ,
        cmd7_row_addr       ,
        cmd7_bank_addr      ,
        cmd7_is_valid		,
        cmd7_multicast_req  

     );
     localparam   LOCAL_BE_WIDTH        = LOCAL_DATA_WIDTH/8;
     localparam   INTERNAL_ADDR_WIDTH   = LOCAL_ADDR_WIDTH + CTL_HRB_ENABLED;
     
     input                              ctl_clk             ;
     input [4 : 0]                      ctl_reset_n         ; // Resynced reset to remove revocery failure in HCx
     input                              ctl_half_clk        ;
     input                              ctl_half_clk_reset_n;
     input                              local_read_req      ;
     input                              local_write_req     ;
     input [LOCAL_SIZE_WIDTH-1:0]       local_size          ;
     input                              local_autopch_req   ;
     input                              local_multicast     ;
     input                              local_burstbegin    ;
     
     input [LOCAL_ADDR_WIDTH-1:0]       local_addr          ;
     input [LOCAL_DATA_WIDTH -1 : 0]    local_wdata         ;
     input [LOCAL_BE_WIDTH -1 : 0]      local_be            ;
     input [1:0] addr_order	;  
     input [MEM_IF_CSR_COL_WIDTH-1:0]   col_width_from_csr	;  
     input [MEM_IF_CSR_ROW_WIDTH-1:0]   row_width_from_csr	;  
     input [MEM_IF_CSR_BANK_WIDTH-1:0]  bank_width_from_csr ;  
     input [MEM_IF_CSR_CS_WIDTH-1:0]    cs_width_from_csr   ;
     input                              regdimm_enable      ;

     input [INTERNAL_DATA_WIDTH -1 : 0] ecc_rdata           ;
     input [DWIDTH_RATIO/2-1:0]         ecc_rdata_valid     ;
     input                              ecc_rdata_error     ;
     
     //input from state machine
     input                              wdata_fifo_read     ;
     input                              fetch		        ;
     
     //input from phy
     input                              ctl_cal_success     ;
     input                              ctl_cal_fail        ;
     
     output                             local_init_done     ;
     output                             local_ready         ;
     output                             local_rdata_valid   ;
     output                             local_rdata_error   ;
     output [LOCAL_DATA_WIDTH -1 : 0]   local_rdata         ;
     output                             local_wdata_req     ;
     output [INTERNAL_DATA_WIDTH -1 : 0]wdata_fifo_wdata    ;
     output [INTERNAL_DATA_WIDTH/8 -1 : 0]wdata_fifo_be     ;  
     output [WDATA_BEATS_WIDTH-1:0]     beats_in_wfifo      ;
     output                             write_req_to_wfifo  ;
     output [INTERNAL_DATA_WIDTH/8 -1 : 0]be_to_wfifo       ;
     
     output                             cmd_fifo_empty	    ;
     output                             cmd_fifo_full 		;
     output                             cmd_fifo_wren       ;
     output                             cmd0_is_a_read		;
     output                             cmd0_is_a_write     ;
     output                             cmd0_autopch_req    ;
     output [1:0]                       cmd0_burstcount     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd0_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd0_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd0_bank_addr      ;
     output [MEM_IF_COL_WIDTH-1:0]      cmd0_col_addr       ;
     output                             cmd0_is_valid		;
     output                             cmd0_multicast_req  ;
     output                             cmd1_is_a_read		;
     output                             cmd1_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd1_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd1_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd1_bank_addr      ;
     output                             cmd1_is_valid		;
     output                             cmd1_multicast_req  ;
     output                             cmd2_is_a_read		;
     output                             cmd2_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd2_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd2_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd2_bank_addr      ;
     output                             cmd2_is_valid		;
     output                             cmd2_multicast_req  ;
     output                             cmd3_is_a_read		;
     output                             cmd3_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd3_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd3_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd3_bank_addr      ;
     output                             cmd3_is_valid		;
     output                             cmd3_multicast_req  ;
     output                             cmd4_is_a_read		;
     output                             cmd4_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd4_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd4_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd4_bank_addr      ;
     output                             cmd4_is_valid		;
     output                             cmd4_multicast_req  ;
     output                             cmd5_is_a_read		;
     output                             cmd5_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd5_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd5_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd5_bank_addr      ;
     output                             cmd5_is_valid		;
     output                             cmd5_multicast_req  ;
     output                             cmd6_is_a_read		;
     output                             cmd6_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd6_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd6_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd6_bank_addr      ;
     output                             cmd6_is_valid		;
     output                             cmd6_multicast_req  ;
     output                             cmd7_is_a_read		;
     output                             cmd7_is_a_write     ;
     output [MEM_IF_CHIP_BITS-1:0]      cmd7_chip_addr      ;
     output [MEM_IF_ROW_WIDTH-1:0]      cmd7_row_addr       ;
     output [MEM_IF_BA_WIDTH-1:0]       cmd7_bank_addr      ;
     output                             cmd7_is_valid		;
     output                             cmd7_multicast_req  ;
     
     wire                               local_ready         ;
     wire                               internal_ready      ;
     wire                               wdata_fifo_full;
     wire                               read_req_to_cmd_gen  ;
     wire                               write_req_to_cmd_gen ;
     wire                               write_req_to_wfifo;
     wire [INTERNAL_DATA_WIDTH -1 : 0]  wdata_to_wfifo;
     wire [INTERNAL_DATA_WIDTH/8 -1 : 0]be_to_wfifo;
     wire                               avalon_write_req;
     wire [INTERNAL_DATA_WIDTH -1 : 0]  avalon_wdata;    
     wire [INTERNAL_ADDR_WIDTH -1 : 0]  avalon_addr;
     wire [INTERNAL_ADDR_WIDTH -1 : 0]  addr_to_cmd_gen;
     wire [INTERNAL_SIZE_WIDTH -1 : 0]  avalon_size;
     wire [INTERNAL_SIZE_WIDTH -1 : 0]  size_to_cmd_gen;
     wire [INTERNAL_DATA_WIDTH/8 -1 : 0]avalon_be;       
     wire                               avalon_read_req; 
     wire                               avalon_burstbegin;
     wire                               avalon_multicast;
     wire                               avalon_autopch_req;
     wire                               multicast_to_cmd_gen;
     wire                               autopch_to_cmd_gen;
     reg                                gate_ready_in_reset;
     wire                               int_local_multicast;
     wire                               ready_from_cmd_gen;
     wire                               read_req_from_cmd_gen;
     wire                               write_req_from_cmd_gen;
     wire [1 : 0]                       size_from_cmd_gen;
     wire                               autopch_from_cmd_gen;
     wire [MEM_IF_CHIP_BITS -1 : 0]     cs_addr_from_cmd_gen;
     wire [MEM_IF_BA_WIDTH -1 : 0]      bank_addr_from_cmd_gen;
     wire [MEM_IF_ROW_WIDTH -1 : 0]     row_addr_from_cmd_gen;
     wire [MEM_IF_COL_WIDTH -1 : 0]     col_addr_from_cmd_gen;
     wire                               multicast_from_cmd_gen;
     
//=======================   Instantiation of alt_ddrx_wdata_fifo   =========================  
    alt_ddrx_wdata_fifo #(
        .WDATA_BEATS_WIDTH          (WDATA_BEATS_WIDTH),
        .LOCAL_DATA_WIDTH           (INTERNAL_DATA_WIDTH),         
        .LOCAL_SIZE_WIDTH           (LOCAL_SIZE_WIDTH),        
        .DWIDTH_RATIO               (DWIDTH_RATIO),             
        .FAMILY                     (FAMILY)     
    ) wdata_fifo_inst (                  
        // input                    
        .ctl_clk 			        (ctl_clk),
        .ctl_reset_n                (ctl_reset_n[0]),
        .write_req_to_wfifo         (write_req_to_wfifo),
        .wdata_to_wfifo             (wdata_to_wfifo),
        .be_to_wfifo                (be_to_wfifo),
        .wdata_fifo_read            (wdata_fifo_read),
                                    
        //output                    
        .wdata_fifo_full            (wdata_fifo_full),
        .wdata_fifo_wdata           (wdata_fifo_wdata),
        .wdata_fifo_be              (wdata_fifo_be),
        .beats_in_wfifo             (beats_in_wfifo)
    );
//=======================   End of Instantiation of alt_ddrx_wdata_fifo   ===================  
//=======================   Instantiation of alt_ddrx_cmd_gen   ===========================    
    alt_ddrx_cmd_gen #(
        .MEM_IF_CSR_COL_WIDTH       (MEM_IF_CSR_COL_WIDTH        ),
        .MEM_IF_CSR_ROW_WIDTH       (MEM_IF_CSR_ROW_WIDTH        ),
        .MEM_IF_CSR_BANK_WIDTH      (MEM_IF_CSR_BANK_WIDTH       ),
        .MEM_IF_CSR_CS_WIDTH        (MEM_IF_CSR_CS_WIDTH         ),
		.MEM_IF_ROW_WIDTH           (MEM_IF_ROW_WIDTH),
		.MEM_IF_COL_WIDTH           (MEM_IF_COL_WIDTH),
		.MEM_IF_BA_WIDTH            (MEM_IF_BA_WIDTH),
		.MEM_IF_CHIP_BITS           (MEM_IF_CHIP_BITS),	
		.LOCAL_ADDR_WIDTH           (INTERNAL_ADDR_WIDTH),
		.INTERNAL_SIZE_WIDTH        (INTERNAL_SIZE_WIDTH),
        .DWIDTH_RATIO               (DWIDTH_RATIO),
        .MEMORY_BURSTLENGTH         (MEMORY_BURSTLENGTH),
        .MIN_COL                    (MIN_COL), 
        .MIN_ROW                    (MIN_ROW),
        .MIN_BANK                   (MIN_BANK),
        .MIN_CS                     (MIN_CS)
	) cmd_gen_inst (                   
		.ctl_clk       		        (ctl_clk), 
		.ctl_reset_n                (ctl_reset_n[1]),
        
        //local input
		.local_read_req      (read_req_to_cmd_gen),
		.local_write_req     (avalon_write_req),
        .processed_write_req (write_req_to_cmd_gen),
		.local_size          (size_to_cmd_gen),
		.local_autopch_req   (autopch_to_cmd_gen),
		.local_addr  	     (addr_to_cmd_gen),
        .local_multicast  	 (multicast_to_cmd_gen),
        
		//input from CSR  
		.addr_order	         (addr_order),
        .col_width_from_csr	 (col_width_from_csr ),
        .row_width_from_csr	 (row_width_from_csr ),
        .bank_width_from_csr (bank_width_from_csr),
        .cs_width_from_csr 	 (cs_width_from_csr),
        
		//misc
        .ready_out           (ready_from_cmd_gen),
        .ready_in            (internal_ready),
		
		//output
        .read_req       (read_req_from_cmd_gen),
        .write_req      (write_req_from_cmd_gen),
        .size           (size_from_cmd_gen),
        .autopch_req    (autopch_from_cmd_gen),
        .cs_addr        (cs_addr_from_cmd_gen),
        .bank_addr      (bank_addr_from_cmd_gen),
        .row_addr       (row_addr_from_cmd_gen),
        .col_addr       (col_addr_from_cmd_gen),
        .multicast      (multicast_from_cmd_gen)
	);
//=================   End of instantiation of alt_ddrx_cmd_gen   ====================== 
//=======================   Instantiation of alt_ddrx_cmd_queue   ===========================    
    alt_ddrx_cmd_queue #(
        .MEM_IF_CSR_COL_WIDTH       (MEM_IF_CSR_COL_WIDTH        ),
        .MEM_IF_CSR_ROW_WIDTH       (MEM_IF_CSR_ROW_WIDTH        ),
        .MEM_IF_CSR_BANK_WIDTH      (MEM_IF_CSR_BANK_WIDTH       ),
        .MEM_IF_CSR_CS_WIDTH        (MEM_IF_CSR_CS_WIDTH         ),
		.CTL_CMD_QUEUE_DEPTH        (CTL_CMD_QUEUE_DEPTH),
        .CTL_LOOK_AHEAD_DEPTH       (CTL_LOOK_AHEAD_DEPTH),
		.MEM_IF_ROW_WIDTH           (MEM_IF_ROW_WIDTH),
		.MEM_IF_COL_WIDTH           (MEM_IF_COL_WIDTH),
		.MEM_IF_BA_WIDTH            (MEM_IF_BA_WIDTH),
		.MEM_IF_CHIP_BITS           (MEM_IF_CHIP_BITS),	
		.LOCAL_ADDR_WIDTH           (INTERNAL_ADDR_WIDTH),
        .DWIDTH_RATIO               (DWIDTH_RATIO),
        .ENABLE_BURST_MERGE         (ENABLE_BURST_MERGE),
        .MIN_COL                    (MIN_COL), 
        .MIN_ROW                    (MIN_ROW),
        .MIN_BANK                   (MIN_BANK),
        .MIN_CS                     (MIN_CS)
	) cmd_queue_inst (                   
		.ctl_clk       		        (ctl_clk       	    ), 
		.ctl_reset_n                (ctl_reset_n[2]     ),
		.read_req_to_cmd_queue      (read_req_from_cmd_gen),
		.write_req_to_cmd_queue     (write_req_from_cmd_gen),
		.local_size                 (size_from_cmd_gen  ),
		.local_autopch_req          (autopch_from_cmd_gen  ),
		.local_cs_addr              (cs_addr_from_cmd_gen  ),
        .local_bank_addr            (bank_addr_from_cmd_gen  ),
        .local_row_addr             (row_addr_from_cmd_gen  ),
        .local_col_addr             (col_addr_from_cmd_gen  ),
        .local_multicast  	        (multicast_from_cmd_gen  ),
                                     
		//input from State Machine
		.fetch		                (fetch	        ),
		                            
		.cmd_fifo_empty	            (cmd_fifo_empty	),
        .cmd_fifo_full 		        (cmd_fifo_full 	),
		
		//output    
        .cmd_fifo_wren              (cmd_fifo_wren      ),
        .cmd0_is_a_read		        (cmd0_is_a_read	    ),
        .cmd0_is_a_write            (cmd0_is_a_write    ),
        .cmd0_autopch_req           (cmd0_autopch_req   ),
        .cmd0_burstcount            (cmd0_burstcount    ),
        .cmd0_chip_addr             (cmd0_chip_addr     ),
        .cmd0_row_addr              (cmd0_row_addr      ),
        .cmd0_bank_addr             (cmd0_bank_addr     ),
        .cmd0_col_addr              (cmd0_col_addr      ),
		.cmd0_is_valid		        (cmd0_is_valid      ),
        .cmd0_multicast_req         (cmd0_multicast_req ),
                                    
        .cmd1_is_a_read		        (cmd1_is_a_read	    ),       	
        .cmd1_is_a_write            (cmd1_is_a_write    ),
        .cmd1_chip_addr             (cmd1_chip_addr     ),
        .cmd1_row_addr              (cmd1_row_addr      ),
        .cmd1_bank_addr             (cmd1_bank_addr     ),
		.cmd1_is_valid		        (cmd1_is_valid      ),
        .cmd1_multicast_req         (cmd1_multicast_req ),
        
        .cmd2_is_a_read		        (cmd2_is_a_read	    ),       	
        .cmd2_is_a_write            (cmd2_is_a_write    ), 
        .cmd2_chip_addr             (cmd2_chip_addr     ),
        .cmd2_row_addr              (cmd2_row_addr      ),
        .cmd2_bank_addr             (cmd2_bank_addr     ),
		.cmd2_is_valid		        (cmd2_is_valid      ),
        .cmd2_multicast_req         (cmd2_multicast_req ),
        
        .cmd3_is_a_read		        (cmd3_is_a_read	    ),       	
        .cmd3_is_a_write            (cmd3_is_a_write    ),
        .cmd3_chip_addr             (cmd3_chip_addr     ),
        .cmd3_row_addr              (cmd3_row_addr      ),
        .cmd3_bank_addr             (cmd3_bank_addr     ),
        .cmd3_is_valid		        (cmd3_is_valid      ),
        .cmd3_multicast_req         (cmd3_multicast_req ),
        
        .cmd4_is_a_read		        (cmd4_is_a_read	    ),       	
        .cmd4_is_a_write            (cmd4_is_a_write    ),
        .cmd4_chip_addr             (cmd4_chip_addr     ),
        .cmd4_row_addr              (cmd4_row_addr      ),
        .cmd4_bank_addr             (cmd4_bank_addr     ),
        .cmd4_is_valid		        (cmd4_is_valid      ),
        .cmd4_multicast_req         (cmd4_multicast_req ),
        
        .cmd5_is_a_read		        (cmd5_is_a_read	    ),       	
        .cmd5_is_a_write            (cmd5_is_a_write    ),
        .cmd5_chip_addr             (cmd5_chip_addr     ),
        .cmd5_row_addr              (cmd5_row_addr      ),
        .cmd5_bank_addr             (cmd5_bank_addr     ),
        .cmd5_is_valid		        (cmd5_is_valid      ),
        .cmd5_multicast_req         (cmd5_multicast_req ),
        
        .cmd6_is_a_read		        (cmd6_is_a_read	    ),       	
        .cmd6_is_a_write            (cmd6_is_a_write    ),
        .cmd6_chip_addr             (cmd6_chip_addr     ),
        .cmd6_row_addr              (cmd6_row_addr      ),
        .cmd6_bank_addr             (cmd6_bank_addr     ),
        .cmd6_is_valid		        (cmd6_is_valid      ),
        .cmd6_multicast_req         (cmd6_multicast_req ),
        
        .cmd7_is_a_read		        (cmd7_is_a_read	    ),       	
        .cmd7_is_a_write            (cmd7_is_a_write    ),
        .cmd7_chip_addr             (cmd7_chip_addr     ),
        .cmd7_row_addr              (cmd7_row_addr      ),
        .cmd7_bank_addr             (cmd7_bank_addr     ),
        .cmd7_is_valid		        (cmd7_is_valid      ),
        .cmd7_multicast_req         (cmd7_multicast_req )
	);
//=================   End of instantiation of alt_ddrx_cmd_queue   ====================== 
    assign internal_ready = (cmd_fifo_full == 1'b0) & (wdata_fifo_full == 1'b0) & (gate_ready_in_reset == 1'b1);      
    assign local_init_done = ctl_cal_success & ~ctl_cal_fail;
      
    //registered gate_ready_in_reset
    always @(posedge ctl_clk or negedge ctl_reset_n[4]) begin   
         if (~ctl_reset_n[4]) begin
            gate_ready_in_reset <= 1'b0;
         end
         else begin
            gate_ready_in_reset <= 1'b1;
         end
    end
    
    generate if(LOCAL_IF_TYPE == "AVALON") begin
        assign local_wdata_req = 1'b0;
        assign write_req_to_wfifo = avalon_write_req;
        assign read_req_to_cmd_gen = avalon_read_req; 
        assign be_to_wfifo = avalon_be; 
        assign wdata_to_wfifo = avalon_wdata;
        assign addr_to_cmd_gen = avalon_addr;
        assign size_to_cmd_gen = avalon_size;
        assign multicast_to_cmd_gen = avalon_multicast;
        assign autopch_to_cmd_gen  = avalon_autopch_req;
        
        if (CTL_HRB_ENABLED == 0) begin
            reg      prolong_burstbegin;
            assign write_req_to_cmd_gen = avalon_write_req & (avalon_burstbegin | prolong_burstbegin);
            
            // Removed reset logic in order to capture burst begin signal when request is issued before internal resynced reset signal de-asserted
            always @(posedge ctl_clk) begin
                 //To detect the case where internal_ready gone low at the start of the burst.
                 //Burst begin gone high for one clock cycle only, so we need to manually prolong
                 //burst begin signal until internal_ready goes high.
                 if(ready_from_cmd_gen == 1'b0 & local_write_req == 1'b1)begin
                     if(avalon_burstbegin == 1'b1) begin
                         prolong_burstbegin <= 1'b1;
                     end
                     else 
                         prolong_burstbegin <= prolong_burstbegin;
                 end
                 else if(ready_from_cmd_gen == 1'b1 & local_write_req == 1'b1)begin 
                     prolong_burstbegin <= 1'b0;
                 end
            end
        end
        else begin
            assign write_req_to_cmd_gen = avalon_write_req & avalon_burstbegin;
        end
        
        //=======================   Instantiation of alt_ddrx_avalon_if   =========================  
        alt_ddrx_avalon_if #(
            .INTERNAL_SIZE_WIDTH        (INTERNAL_SIZE_WIDTH),
            .DWIDTH_RATIO               (DWIDTH_RATIO),
            .LOCAL_DATA_WIDTH           (LOCAL_DATA_WIDTH),
            .INTERNAL_DATA_WIDTH        (INTERNAL_DATA_WIDTH),
            .CTL_HRB_ENABLED            (CTL_HRB_ENABLED ),
            .LOCAL_ADDR_WIDTH           (LOCAL_ADDR_WIDTH),
            .INTERNAL_ADDR_WIDTH        (INTERNAL_ADDR_WIDTH),
            .LOCAL_SIZE_WIDTH           (LOCAL_SIZE_WIDTH)
        ) avalon_if_inst (                  
            // input                    
            .ctl_clk 		            (ctl_clk),
            .ctl_reset_n                (ctl_reset_n[3]),
            .ctl_half_clk               (ctl_half_clk),
            .ctl_half_clk_reset_n       (ctl_half_clk_reset_n),
            .local_write_req            (local_write_req),
            .local_wdata                (local_wdata),
            .local_be                   (local_be),
            .local_addr                 (local_addr),
            .internal_ready             (ready_from_cmd_gen),
            .local_read_req             (local_read_req),
            .local_size                 (local_size),
            .local_burstbegin           (local_burstbegin),
            .ecc_rdata                  (ecc_rdata),
            .ecc_rdata_valid            (ecc_rdata_valid ),
            .ecc_rdata_error            (ecc_rdata_error),
            .local_multicast            (int_local_multicast),
            .local_autopch_req          (local_autopch_req),
            
            //output                    
            .avalon_wdata               (avalon_wdata),
            .avalon_be                  (avalon_be),
            .avalon_write_req           (avalon_write_req),
            .avalon_read_req            (avalon_read_req),
            .avalon_addr                (avalon_addr),
            .avalon_size                (avalon_size),
            .local_ready                (local_ready),
            .avalon_burstbegin          (avalon_burstbegin),
            .local_rdata                (local_rdata),
            .local_rdata_error          (local_rdata_error),
            .local_rdata_valid          (local_rdata_valid),
            .avalon_multicast           (avalon_multicast),
            .avalon_autopch_req         (avalon_autopch_req)
            
            
        );
        //=======================   End of Instantiation of alt_ddrx_avalon_if   =================== 

    end
    else begin           //native mode
        reg                                wdata_req;
        reg                                wdata_req_r;
        reg  [WDATA_BEATS_WIDTH-1:0]       beats_to_ask_for;
        
        assign local_wdata_req = wdata_req;
        assign write_req_to_cmd_gen = local_write_req;               
        assign write_req_to_wfifo = wdata_req_r;
        assign read_req_to_cmd_gen = local_read_req; 
        assign be_to_wfifo = local_be; 
        assign wdata_to_wfifo = local_wdata;
        assign addr_to_cmd_gen = local_addr;
        assign size_to_cmd_gen = local_size;
        assign multicast_to_cmd_gen = int_local_multicast;
        assign autopch_to_cmd_gen = local_autopch_req;
    
        //used only in native mode
        always @(posedge ctl_clk or negedge ctl_reset_n[4]) begin   
             if (~ctl_reset_n[4]) begin
                wdata_req <= 1'b0;              //request signal to user
                wdata_req_r <= 1'b0;            //request signal to wdata fifo
                beats_to_ask_for <= 0;
             end
             else begin
                wdata_req_r <= wdata_req;
                    if ((internal_ready == 1'b1) & (local_write_req == 1'b1) & (LOCAL_IF_TYPE == "NATIVE")) begin
                        if (wdata_req == 1'b1) begin
                            wdata_req <= beats_to_ask_for > 0;
                            beats_to_ask_for <= beats_to_ask_for + local_size - 1; 
                        end
                        else begin
                            if (local_init_done == 1'b1) begin
                                wdata_req <= 1'b1;
                            end
                            beats_to_ask_for <= beats_to_ask_for + local_size;
                        end
                    end
                    else if ((beats_to_ask_for > 0) & (wdata_req == 1'b1) & (local_init_done == 1'b1)) begin 
                            beats_to_ask_for <= beats_to_ask_for - 1;
                            wdata_req <= beats_to_ask_for > 1;   
                        end
                    else begin         
                        wdata_req <= 1'b0;
                        beats_to_ask_for <= beats_to_ask_for;
                    end
             end
         end
    end
    endgenerate

    generate 
        if ((CTL_CSR_ENABLED == 1) && (MEM_TYPE == "DDR3")) begin

            assign int_local_multicast = (regdimm_enable == 1) ?  0 : local_multicast ;

        end
        else if ((CTL_REGDIMM_ENABLED == 1) && (MEM_TYPE == "DDR3")) begin

            assign int_local_multicast = 0;

        end
        else begin

            assign int_local_multicast = local_multicast ;

        end
    endgenerate


endmodule
