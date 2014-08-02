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
// Title         : DDR command translator/generator block
//
// File          : alt_ddrx_cmd_gen.v
//
// Abstract      : Command generator block
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_cmd_gen
    # (parameter
    
        MEM_IF_CSR_COL_WIDTH        = 4,
        MEM_IF_CSR_ROW_WIDTH        = 5,
        MEM_IF_CSR_BANK_WIDTH       = 2,
        MEM_IF_CSR_CS_WIDTH         = 2, 
        MEM_IF_ROW_WIDTH            = 16,
        MEM_IF_COL_WIDTH            = 12,
        MEM_IF_BA_WIDTH             = 3, 
        MEM_IF_CHIP_BITS            = 2, 
        LOCAL_ADDR_WIDTH            = 33,
        INTERNAL_SIZE_WIDTH         = 6,
        DWIDTH_RATIO                = 4,
        MEMORY_BURSTLENGTH          = 8,
        MIN_COL                     = 8,
        MIN_ROW                     = 12,
        MIN_BANK                    = 2,
        MIN_CS                      = 1
        
    )
    (
    
        ctl_clk,
        ctl_reset_n,
        
        //local input
        local_read_req,
        local_write_req,
        processed_write_req,
        local_size,
        local_autopch_req,
        local_addr,
        local_multicast,
        
		//input from CSR
		addr_order,
        col_width_from_csr,
        row_width_from_csr,
        bank_width_from_csr,
        cs_width_from_csr,
        
		//misc
        ready_out,
        ready_in,
		
		//output
        read_req,
        write_req,
        size,
        autopch_req,
        cs_addr,
        bank_addr,
        row_addr,
        col_addr,
        multicast
    );
    
    localparam   MAX_COL              = MEM_IF_COL_WIDTH;
    localparam   MAX_ROW              = MEM_IF_ROW_WIDTH;
    localparam   MAX_BANK             = MEM_IF_BA_WIDTH;
    localparam   MAX_CS               = MEM_IF_CHIP_BITS;
    
    input                                 ctl_clk;
    input                                 ctl_reset_n;
    
    input 		     		              local_read_req;
	input 		     		              local_write_req;
    input                                 processed_write_req;
	input [INTERNAL_SIZE_WIDTH-1:0]       local_size;
	input		     		              local_autopch_req;
	input [LOCAL_ADDR_WIDTH-1:0]          local_addr;
    input                                 local_multicast;
    
    input [1:0]	addr_order;
    input [MEM_IF_CSR_COL_WIDTH-1:0]      col_width_from_csr;
	input [MEM_IF_CSR_ROW_WIDTH-1:0]      row_width_from_csr;
    input [MEM_IF_CSR_BANK_WIDTH-1:0]     bank_width_from_csr;
    input [MEM_IF_CSR_CS_WIDTH-1:0]       cs_width_from_csr; 
    
    output                                ready_out;
    input                                 ready_in;
    
    output 		     		              read_req;
	output 		     		              write_req;
	output [1:0]                          size;
	output		     		              autopch_req;
	output [MEM_IF_CHIP_BITS-1:0]         cs_addr;
    output [MEM_IF_BA_WIDTH-1:0]          bank_addr;
    output [MEM_IF_ROW_WIDTH-1:0]         row_addr;
    output [MEM_IF_COL_WIDTH-1:0]         col_addr;
    output                                multicast;
	
    integer                               n;
	integer                               j;
	integer                               k;
	integer                               m;
    
    reg [MEM_IF_CHIP_BITS-1:0]            cs_addr;
	reg [MEM_IF_BA_WIDTH-1:0]             bank_addr;
	reg [MEM_IF_ROW_WIDTH-1:0]            row_addr;
	reg [MEM_IF_COL_WIDTH-1:0]            col_addr;
    
	reg [MEM_IF_CHIP_BITS-1:0]            int_cs_addr;
	reg [MEM_IF_BA_WIDTH-1:0]             int_bank_addr;
	reg [MEM_IF_ROW_WIDTH-1:0]            int_row_addr;
	reg [MEM_IF_COL_WIDTH-1:0]            int_col_addr;
    
    reg  		     		              read_req;
	reg  		     		              write_req;
	reg [1:0]                             size;
	reg                                   autopch_req;
    reg                                   multicast;
    
    reg                                buf_read_req;
	reg                                buf_write_req;
	reg                                buf_autopch_req;
    reg                                buf_multicast;
    
	reg [INTERNAL_SIZE_WIDTH-1:0]      buf_size;
	reg [MEM_IF_CHIP_BITS-1:0]         buf_cs_addr;
    reg [MEM_IF_BA_WIDTH-1:0]          buf_bank_addr;
    reg [MEM_IF_ROW_WIDTH-1:0]         buf_row_addr;
    reg [MEM_IF_COL_WIDTH-1:0]         buf_col_addr;
    
    reg [INTERNAL_SIZE_WIDTH-1:0]      decrmntd_size;
    reg [MEM_IF_CHIP_BITS-1:0]         incrmntd_cs_addr;
    reg [MEM_IF_BA_WIDTH-1:0]          incrmntd_bank_addr;
    reg [MEM_IF_ROW_WIDTH-1:0]         incrmntd_row_addr;
    reg [MEM_IF_COL_WIDTH-1:0]         incrmntd_col_addr;
    
    wire    [MEM_IF_CHIP_BITS-1:0]      max_chip_from_csr;
    wire    [MEM_IF_BA_WIDTH-1:0]       max_bank_from_csr;
    wire    [MEM_IF_ROW_WIDTH-1:0]      max_row_from_csr;
    wire    [MEM_IF_COL_WIDTH-1:0]      max_col_from_csr;
    
    wire    copy;
    wire    unaligned_burst;
    wire    require_gen;
    reg     hold_ready;
    reg     registered;
    reg     generating;
    reg     pass_write;
    
    //=======================   local_addr remapping   ===========================
    
    //derive column address from local_addr
    always @(*) 
    begin : Col_addr_loop
        int_col_addr[MIN_COL - DWIDTH_RATIO/2 - 1 : 0] = local_addr[MIN_COL - DWIDTH_RATIO/2 - 1 : 0];    
        for (n=MIN_COL - DWIDTH_RATIO/2; n<MAX_COL; n=n+1'b1) begin
            if(n < col_width_from_csr - DWIDTH_RATIO/2) begin // bit of col_addr can be configured in CSR using col_width_from_csr
                 int_col_addr[n] = local_addr[n]; 
            end
            else begin
                 int_col_addr[n] = 1'b0; 
            end    
        end
        int_col_addr = (int_col_addr << (log2 (DWIDTH_RATIO)));
    end
    
    //derive row address from local_addr
    always @(*) 
    begin : Row_addr_loop
        for (j=0; j<MIN_ROW; j=j+1'b1) begin    //The purpose of using this for-loop is to get rid of "if(j < row_width_from_csr) begin" which causes multiplexers
            if(addr_order == 2'd1)  // local_addr can arrange in 2 patterns depending on addr_order (i) cs, bank, row, col (ii) cs, row, bank, col
                    int_row_addr[j] = local_addr[j + col_width_from_csr - DWIDTH_RATIO/2];  //address order pattern 1
            else  // addr_order == 2'd0 or others
                    int_row_addr[j] = local_addr[j + bank_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
        end
        for (j=MIN_ROW; j<MAX_ROW; j=j+1'b1) begin               
            if(j < row_width_from_csr) begin    // bit of row_addr can be configured in CSR using row_width_from_csr
                if(addr_order == 2'd1)
                    int_row_addr[j] = local_addr[j + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 1
                else  // addr_order == 2'd0 or others
                    int_row_addr[j] = local_addr[j + bank_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
            end
            else begin
                int_row_addr[j] = 1'b0;  
            end
        end
    end
    
    always @(*) 
    begin : Bank_addr_loop
        for (k=0; k<MIN_BANK; k=k+1'b1) begin    //The purpose of using this for-loop is to get rid of "if(k < bank_width_from_csr) begin" which causes multiplexers
            if(addr_order == 2'd1) // local_addr can arrange in 2 patterns depending on addr_order (i) cs, bank, row, col (ii) cs, row, bank, col
                    int_bank_addr[k] = local_addr[k + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 1
                else  // addr_order == 2'd0 or others
                    int_bank_addr[k] = local_addr[k + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
        end
        for (k=MIN_BANK; k<MAX_BANK; k=k+1'b1) begin               
            if(k < bank_width_from_csr) begin   // bit of bank_addr can be configured in CSR using bank_width_from_csr
                if(addr_order == 2'd1)
                    int_bank_addr[k] = local_addr[k + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 1
                else  // addr_order == 2'd0 or others
                    int_bank_addr[k] = local_addr[k + col_width_from_csr - DWIDTH_RATIO/2]; //address order pattern 2
            end
            else begin
                int_bank_addr[k] = 1'b0; 
            end
         end
    end
      
    always @(*) 
    begin
        m=0;
        if (cs_width_from_csr > 1'b0) begin    //if cs_width_from_csr =< 1'b1, local_addr doesn't have cs_addr bit
            for (m=0; m<MIN_CS; m=m+1'b1) begin  //The purpose of using this for-loop is to get rid of "if(m < cs_width_from_csr) begin" which causes multiplexers
                int_cs_addr[m] = local_addr[m + bank_width_from_csr + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; 
            end
            for (m=MIN_CS; m<MAX_CS; m=m+1'b1) begin                
                if(m < cs_width_from_csr) begin     // bit of cs_addr can be configured in CSR using cs_width_from_csr
                    int_cs_addr[m] = local_addr[m + bank_width_from_csr + row_width_from_csr + col_width_from_csr - DWIDTH_RATIO/2]; 
                end    
                else begin
                    int_cs_addr[m] = 1'b0;
                end
            end
        end
        else begin 
            int_cs_addr = {MEM_IF_CHIP_BITS{1'b0}}; //if MEM_IF_CS_WIDTH = 1, then set cs_addr to 0 (one chip, one rank)
        end
    end
    
    //=====================   end of local_addr remapping   =========================
    
    // csr wiring
    assign  max_chip_from_csr   =   (2**cs_width_from_csr) - 1'b1;
    assign  max_bank_from_csr   =   (2**bank_width_from_csr) - 1'b1;
    assign  max_row_from_csr    =   (2**row_width_from_csr) - 1'b1;
    assign  max_col_from_csr    =   (2**col_width_from_csr) - 1'b1;
    
    assign  ready_out   =   ready_in & ~hold_ready;
    assign  copy    =   ready_in & (local_read_req | processed_write_req);
    assign  unaligned_burst   =   (DWIDTH_RATIO == 2 && int_col_addr[1]) || (DWIDTH_RATIO == 4 && int_col_addr[2]);
    assign  require_gen =   local_size > 2 | (local_size > 1 & unaligned_burst);
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                hold_ready  <=  0;
            else
                begin
                    if (copy && require_gen)
                        hold_ready  <=  1;
                    else if (buf_read_req && buf_size > 4)
                        hold_ready  <=  1;
                    else if ((generating && buf_read_req && ready_in) || (buf_write_req))
                        hold_ready  <=  0;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                registered  <=  0;
            else
                begin
                    if (copy && require_gen)
                        registered  <=  1;
                    else
                        registered  <=  0;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                generating  <=  0;
            else
                begin
                    if (registered)
                        generating  <=  1;
                    else if (generating && buf_size > 4)
                        generating  <=  1;
                    else if ((buf_read_req && ready_in) || (local_write_req && ready_in && pass_write))
                        generating  <=  0;
                end
        end
    
    always @(*)
        begin
            if (INTERNAL_SIZE_WIDTH > 1)
                begin
                    if (!generating)
                        if (local_size > 1 && !unaligned_burst)
                            size    <=  2;
                        else
                            size    <=  1;
                    else
                        if (decrmntd_size > 1)
                            size    <=  2;
                        else
                            size    <=  1;
                end
            else
                size    <=  1;
        end
    
    always @(*)
        if (!generating) // not generating so take direct input from avalon if
            begin
                read_req    <=  local_read_req;
                write_req   <=  processed_write_req;
                autopch_req <=  local_autopch_req;
                multicast   <=  local_multicast;
                cs_addr     <=  int_cs_addr;
                bank_addr   <=  int_bank_addr;
                row_addr    <=  int_row_addr;
                col_addr    <=  int_col_addr;
            end
        else // generating cmd so process buffer content
            begin
                read_req    <=  buf_read_req & ready_in;
                write_req   <=  local_write_req & ready_in & pass_write;
                autopch_req <=  buf_autopch_req;
                multicast   <=  buf_multicast;
                cs_addr     <=  incrmntd_cs_addr;
                bank_addr   <=  incrmntd_bank_addr;
                row_addr    <=  incrmntd_row_addr;
                if (DWIDTH_RATIO == 2)
                    col_addr    <=  {incrmntd_col_addr[MEM_IF_COL_WIDTH-1:2],2'b00};
                else
                    col_addr    <=  {incrmntd_col_addr[MEM_IF_COL_WIDTH-1:3],3'b000};
            end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                pass_write  <=  0;
            else
                begin
                    if (copy && require_gen && !unaligned_burst)
                        pass_write  <=  0;
                    else if (copy && require_gen && unaligned_burst)
                        pass_write  <=  1;
                    else if (local_write_req && !registered)
                        pass_write  <=  ~pass_write;
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    buf_read_req    <=  1'b0;
                    buf_write_req   <=  1'b0;
                    buf_autopch_req <=  1'b0;
                    buf_multicast   <=  1'b0;
                end
            else
                if (copy)
                    begin
                        buf_read_req    <=  local_read_req;
                        buf_write_req   <=  local_write_req;
                        buf_autopch_req <=  local_autopch_req;
                        buf_multicast   <=  local_multicast;
                    end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                buf_size    <=  0;
            else
                begin
                    if (copy)
                        buf_size    <=  local_size + unaligned_burst;
                    else if (!registered && buf_read_req && buf_size > 2 && ready_in)
                        buf_size    <=  buf_size - 2'b10;
                    else if (!registered && local_write_req && buf_size > 2 && ready_in && pass_write)
                        buf_size    <=  buf_size - 2'b10;
                end
        end
    
    always @(*)
        decrmntd_size   <=  buf_size - 2'b10;
    
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
                else if (registered || (buf_read_req && generating && ready_in) || (local_write_req && generating && ready_in && pass_write))
                    if ((MEMORY_BURSTLENGTH == 8 && buf_col_addr[MEM_IF_COL_WIDTH-1:3] == max_col_from_csr[MEM_IF_COL_WIDTH-1:3]) || (MEMORY_BURSTLENGTH == 4 && buf_col_addr[MEM_IF_COL_WIDTH-1:2] == max_col_from_csr[MEM_IF_COL_WIDTH-1:2]))
                        begin
                            if (MEMORY_BURSTLENGTH == 8)
                                buf_col_addr[MEM_IF_COL_WIDTH-1:3]   <=  0;
                            else
                                buf_col_addr[MEM_IF_COL_WIDTH-1:2]   <=  0;
                            
                            if (addr_order == 1) // 1 is chipbankrowcol
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
                        begin
                            if (MEMORY_BURSTLENGTH == 8)
                                buf_col_addr <=  buf_col_addr + 4'b1000;
                            else
                                buf_col_addr <=  buf_col_addr + 3'b100;
                        end
        end
    
    always @(*)
        begin
            incrmntd_cs_addr    =   buf_cs_addr;
            incrmntd_bank_addr  =   buf_bank_addr;
            incrmntd_row_addr   =   buf_row_addr;
            incrmntd_col_addr   =   buf_col_addr;
        end
    
    function integer log2;  //constant function
       input integer value;
       begin
           for (log2=0; value>0; log2=log2+1)
               value = value>>1;
           log2 = log2 - 1;
       end
    endfunction

endmodule
