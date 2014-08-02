
//altera message_off 10230 10036

//For tCL = 3 and tCWL = 2 rdwr_data_tmg block output must be registered in order to support ODT

`timescale 1 ps / 1 ps

module alt_mem_ddrx_ddr2_odt_gen
    # ( parameter
        CFG_DWIDTH_RATIO              =   2,
        CFG_PORT_WIDTH_ADD_LAT        =   3,
        CFG_PORT_WIDTH_OUTPUT_REGD    =   1,
        CFG_PORT_WIDTH_TCL            =   4
    )
    (
        ctl_clk,
        ctl_reset_n,
        cfg_tcl,
        cfg_add_lat,
        cfg_burst_length,
        cfg_output_regd,
        bg_do_write,
        bg_do_read,
        int_odt_l,
        int_odt_h
    );
    
    //=================================================================================================//
    //        Local parameter definition                                                               //
    //=================================================================================================//
    
    localparam  integer CFG_TCL_PIPE_LENGTH =   2**CFG_PORT_WIDTH_TCL; // okay to size this to 4 since max latency in DDR2 is 7+6=13
    localparam          CFG_TAOND           =   2;
    localparam          CFG_TAOFD           =   2.5;
    
    //=================================================================================================//
    //        input/output declaration                                                                 //
    //=================================================================================================//
    
    input                                    ctl_clk;
    input                                    ctl_reset_n;
    input   [CFG_PORT_WIDTH_TCL-1:0]         cfg_tcl;
    input   [CFG_PORT_WIDTH_ADD_LAT-1:0]     cfg_add_lat;
    input   [4:0]                            cfg_burst_length;
    input   [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd;
    
    input                                    bg_do_write;
    input                                    bg_do_read;
    
    output                                   int_odt_l;
    output                                   int_odt_h;
    
    //=================================================================================================//
    //        reg/wire declaration                                                                     //
    //=================================================================================================//
    
    wire bg_do_write;
    wire bg_do_read;
    
    reg  [1:0] regd_output;
    
    reg  [CFG_PORT_WIDTH_TCL-1:0] int_tcwl_unreg;
    reg  [CFG_PORT_WIDTH_TCL-1:0] int_tcwl;
    reg                           int_tcwl_even;
    reg                           int_tcwl_odd;
    
    reg  [CFG_PORT_WIDTH_TCL-1:0] write_latency;
    reg  [CFG_PORT_WIDTH_TCL-1:0] read_latency;
    
    wire int_odt_l;
    wire int_odt_h;
    
    reg reg_odt_l;
    reg reg_odt_h;
    
    reg combi_odt_l;
    reg combi_odt_h;
    
    reg [1:0] offset_code;
    
    reg start_odt_write;
    reg start_odt_read;
    
    reg [CFG_TCL_PIPE_LENGTH-1:0] do_write_pipe;
    reg [CFG_TCL_PIPE_LENGTH-1:0] do_read_pipe;
    
    reg [3:0]   doing_write_count;
    reg [3:0]   doing_read_count;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    regd_output <= 0;
                end
            else
                begin
                    if (cfg_output_regd)
                        regd_output <= (CFG_DWIDTH_RATIO / 2);
                    else
                        regd_output <= 2'd0;
                end
        end
    
    always @ (*)
        begin
            int_tcwl_unreg = cfg_tcl + cfg_add_lat + regd_output - 1'b1;
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_tcwl    <=  0;
            else
                int_tcwl    <=  int_tcwl_unreg;
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_tcwl_even <= 1'b0;
                    int_tcwl_odd  <= 1'b0;
                end
            else
                begin
                    if (int_tcwl % 2 == 0)
                        begin
                            int_tcwl_even <= 1'b1;
                            int_tcwl_odd  <= 1'b0;
                        end
                    else
                        begin
                            int_tcwl_even <= 1'b0;
                            int_tcwl_odd  <= 1'b1;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    write_latency <= 0;
                    read_latency  <= 0;
                end
            else
                begin
                    write_latency <= (int_tcwl - 4) / (CFG_DWIDTH_RATIO / 2);
                    read_latency  <= (int_tcwl - 3) / (CFG_DWIDTH_RATIO / 2);
                end
        end
    
    //=================================================================================================//
    //        Delay ODT signal to match READ DQ/DQS                                                    //
    //=================================================================================================//
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                do_read_pipe    <=  0;
            else
                if (bg_do_read)
                    do_read_pipe    <=  {do_read_pipe[CFG_TCL_PIPE_LENGTH-2:0],bg_do_read};
                else
                    do_read_pipe    <=  {do_read_pipe[CFG_TCL_PIPE_LENGTH-2:0],1'b0};
        end
    
    always @(*)
        begin
            if (int_tcwl < 3)
                start_odt_read  =  bg_do_read;
            else
                start_odt_read  =  do_read_pipe[read_latency];
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin doing_read_count   <=  0; end
            else
                begin
                    if (start_odt_read)
                        begin
                            if ((cfg_burst_length / CFG_DWIDTH_RATIO) > 1)
                                doing_read_count   <=  1;
                            else
                                doing_read_count   <=  0;
                        end
                    else if (doing_read_count >= ((cfg_burst_length / CFG_DWIDTH_RATIO) - 1))
                        begin
                            doing_read_count   <=  0;
                        end
                    else if (doing_read_count > 0)
                        begin
                            doing_read_count   <=  doing_read_count + 1'b1;
                        end
                end
        end
    
    //=================================================================================================//
    //        Delay ODT signal to match WRITE DQ/DQS                                                   //
    //=================================================================================================//
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                do_write_pipe    <=  0;
            else
                if (bg_do_write)
                    do_write_pipe    <=  {do_write_pipe[CFG_TCL_PIPE_LENGTH-2:0],bg_do_write};
                else
                    do_write_pipe    <=  {do_write_pipe[CFG_TCL_PIPE_LENGTH-2:0],1'b0};
        end
    
    always @(*)
        begin
            if (int_tcwl < 4)
                start_odt_write =  bg_do_write;
            else
                start_odt_write =  do_write_pipe[write_latency];
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                doing_write_count   <=  0;
            else
                if (start_odt_write)
                    begin
                        if ((cfg_burst_length / CFG_DWIDTH_RATIO) > 1)
                            doing_write_count   <=  1;
                        else
                            doing_write_count   <=  0;
                    end
                else if (doing_write_count >= ((cfg_burst_length / CFG_DWIDTH_RATIO) - 1))
                    begin
                        doing_write_count   <=  0;
                    end
                else if (doing_write_count > 0)
                    begin
                        doing_write_count   <=  doing_write_count + 1'b1;
                    end
        end
    
    //=================================================================================================//
    //        ODT signal generation block                                                              //
    //=================================================================================================//
    
    always @ (*)
        begin
            if (CFG_DWIDTH_RATIO == 2) // full rate
                begin
                    if (start_odt_write || start_odt_read)
                        begin
                            combi_odt_h = 1'b1;
                            combi_odt_l = 1'b1;
                        end
                    else
                        begin
                            combi_odt_h = 1'b0;
                            combi_odt_l = 1'b0;
                        end
                end
            else // half and quarter rate
                begin
                    if (int_tcwl_even)
                        begin
                            if (start_odt_write)
                                begin
                                    combi_odt_h = 1'b1;
                                    combi_odt_l = 1'b1;
                                end
                            else if (start_odt_read)
                                begin
                                    combi_odt_h = 1'b1;
                                    combi_odt_l = 1'b0;
                                end
                            else
                                begin
                                    combi_odt_h = 1'b0;
                                    combi_odt_l = 1'b0;
                                end
                        end
                    else
                        begin
                            if (start_odt_write)
                                begin
                                    combi_odt_h = 1'b1;
                                    combi_odt_l = 1'b0;
                                end
                            else if (start_odt_read)
                                begin
                                    combi_odt_h = 1'b1;
                                    combi_odt_l = 1'b1;
                                end
                            else
                                begin
                                    combi_odt_h = 1'b0;
                                    combi_odt_l = 1'b0;
                                end
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    reg_odt_h <= 1'b0;
                    reg_odt_l <= 1'b0;
                end
            else
                begin
                    if (CFG_DWIDTH_RATIO == 2) // full rate
                        begin
                            if (start_odt_write || start_odt_read)
                                begin
                                    reg_odt_h <= 1'b1;
                                    reg_odt_l <= 1'b1;
                                end
                            else if (doing_write_count > 0 || doing_read_count > 0)
                                begin
                                    reg_odt_h <= 1'b1;
                                    reg_odt_l <= 1'b1;
                                end
                            else
                                begin
                                    reg_odt_h <= 1'b0;
                                    reg_odt_l <= 1'b0;
                                end
                        end
                    else // half and quarter rate
                        begin
                            if (start_odt_write)
                                begin
                                    if ((cfg_burst_length / CFG_DWIDTH_RATIO) > 1)
                                        begin
                                            reg_odt_h <= 1'b1;
                                            reg_odt_l <= 1'b1;
                                        end
                                    else
                                        begin
                                            if (int_tcwl_even)
                                                begin
                                                    reg_odt_h <= 1'b0;
                                                    reg_odt_l <= 1'b1;
                                                end
                                            else
                                                begin
                                                    reg_odt_h <= 1'b1;
                                                    reg_odt_l <= 1'b1;
                                                end
                                        end
                                end
                            else if (start_odt_read)
                                begin
                                    if ((cfg_burst_length / CFG_DWIDTH_RATIO) > 1)
                                        begin
                                            reg_odt_h <= 1'b1;
                                            reg_odt_l <= 1'b1;
                                        end
                                    else
                                        begin
                                            if (int_tcwl_odd)
                                                begin
                                                    reg_odt_h <= 1'b0;
                                                    reg_odt_l <= 1'b1;
                                                end
                                            else
                                                begin
                                                    reg_odt_h <= 1'b1;
                                                    reg_odt_l <= 1'b1;
                                                end
                                        end
                                end
                            else if (doing_write_count > 0)
                                begin
                                    if (doing_write_count < ((cfg_burst_length / CFG_DWIDTH_RATIO) - 1))
                                        begin
                                            reg_odt_h <= 1'b1;
                                            reg_odt_l <= 1'b1;
                                        end
                                    else
                                        begin
                                            if (int_tcwl_even)
                                                begin
                                                    reg_odt_h <= 1'b0;
                                                    reg_odt_l <= 1'b1;
                                                end
                                            else
                                                begin
                                                    reg_odt_h <= 1'b1;
                                                    reg_odt_l <= 1'b1;
                                                end
                                        end
                                end
                            else if (doing_read_count > 0)
                                begin
                                    if (doing_read_count < ((cfg_burst_length / CFG_DWIDTH_RATIO) - 1))
                                        begin
                                            reg_odt_h <= 1'b1;
                                            reg_odt_l <= 1'b1;
                                        end
                                    else
                                        begin
                                            if (int_tcwl_odd)
                                                begin
                                                    reg_odt_h <= 1'b0;
                                                    reg_odt_l <= 1'b1;
                                                end
                                            else
                                                begin
                                                    reg_odt_h <= 1'b1;
                                                    reg_odt_l <= 1'b1;
                                                end
                                        end
                                end
                            else
                                begin
                                    reg_odt_h <= 1'b0;
                                    reg_odt_l <= 1'b0;
                                end
                        end
                end
        end
    
    generate
        if (CFG_DWIDTH_RATIO == 2) // full rate
            begin
                assign  int_odt_h   = combi_odt_h | reg_odt_h;
                assign  int_odt_l   = combi_odt_h | reg_odt_h;
            end
        else if (CFG_DWIDTH_RATIO == 4) // half rate
            begin
                assign  int_odt_h   = combi_odt_h | reg_odt_h;
                assign  int_odt_l   = combi_odt_l | reg_odt_l;
            end
        else if (CFG_DWIDTH_RATIO == 8) // quarter rate
            begin
                
            end
    endgenerate

endmodule
