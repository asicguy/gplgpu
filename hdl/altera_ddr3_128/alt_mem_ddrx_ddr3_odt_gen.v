
//altera message_off 10036

`timescale 1 ps / 1 ps
module alt_mem_ddrx_ddr3_odt_gen
    # (parameter
        CFG_DWIDTH_RATIO             =   2,
        CFG_PORT_WIDTH_OUTPUT_REGD   =   1,
        CFG_PORT_WIDTH_TCL           =   4,
        CFG_PORT_WIDTH_CAS_WR_LAT    =   4
    )
    (
        ctl_clk,
        ctl_reset_n,
        cfg_tcl,
        cfg_cas_wr_lat,
        cfg_output_regd,
        bg_do_write,
        bg_do_read,
        bg_do_burst_chop,
        int_odt_l,
        int_odt_h,
        int_odt_i_1,
        int_odt_i_2
    );
    
    localparam  integer CFG_TCL_PIPE_LENGTH =   2**CFG_PORT_WIDTH_TCL;
    //=================================================================================================//
    //        DDR3 ODT timing parameters                                                               //
    //=================================================================================================//
    
    localparam integer    CFG_ODTH8             = 6; //Indicates No. of cycles ODT signal should stay high
    localparam integer    CFG_ODTH4             = 4; //Indicates No. of cycles ODT signal should stay high
    localparam integer    CFG_ODTPIPE_THRESHOLD = CFG_DWIDTH_RATIO / 2;
    // AL also applies to ODT signal so ODT logic is AL agnostic
    // also regdimm because ODT is registered too
    // ODTLon = CWL + AL - 2
    // ODTLoff = CWL + AL - 2
    
    //=================================================================================================//
    //        input/output declaration                                                                 //
    //=================================================================================================//
    
    input   ctl_clk;
    input   ctl_reset_n;
    input   [CFG_PORT_WIDTH_TCL-1:0]         cfg_tcl;
    input   [CFG_PORT_WIDTH_CAS_WR_LAT-1:0]  cfg_cas_wr_lat;
    input   [CFG_PORT_WIDTH_OUTPUT_REGD-1:0] cfg_output_regd;
    input   bg_do_write;
    input   bg_do_read;
    input   bg_do_burst_chop;
    output  int_odt_l;
    output  int_odt_h;
    output  int_odt_i_1;
    output  int_odt_i_2;
    
    //=================================================================================================//
    //        reg/wire declaration                                                                     //
    //=================================================================================================//
    
    wire    bg_do_write;
    reg     int_do_read;
    reg     int_do_write_burst_chop;
    reg     int_do_read_burst_chop;
    reg     int_do_read_burst_chop_c;
    reg     do_read_r;
    
    wire [3:0]  diff_unreg;                 // difference between CL and CWL
    reg  [3:0]  diff;
    wire [3:0]  diff_modulo_unreg;
    reg  [3:0]  diff_modulo;
    wire [3:0]  sel_do_read_pipe_unreg;
    reg  [3:0]  sel_do_read_pipe;
    reg         diff_modulo_not_zero;
    reg         diff_modulo_one;
    reg         diff_modulo_two;
    reg         diff_modulo_three;
    
    reg     int_odt_l_int;
    reg     int_odt_l_int_r;
    
    reg     premux_odt_h;
    reg     premux_odt_h_r;
    reg     int_odt_h_int;
    reg     int_odt_h_int_r;
    
    reg     int_odt_i_1_int;
    reg     int_odt_i_2_int;
    reg     int_odt_i_1_int_r;
    reg     int_odt_i_2_int_r;
    
    wire    int_odt_l;
    wire    int_odt_h;
    wire    int_odt_i_1;
    wire    int_odt_i_2;
    reg  [3:0]   doing_write_count;
    reg  [3:0]   doing_read_count;
    wire         doing_read_count_not_zero;
    reg          doing_read_count_not_zero_r;
    wire [3:0]   doing_write_count_limit;
    wire [3:0]   doing_read_count_limit;
   
    reg [CFG_TCL_PIPE_LENGTH        -1:0]   do_read_pipe;
    reg [CFG_TCL_PIPE_LENGTH        -1:0]   do_burst_chop_pipe;

    //=================================================================================================//
    //        Define ODT pulse width during READ operation                                             //
    //=================================================================================================//
    
    //ODTLon/ODTLoff are calculated based on CWL, Below logic is to compensate for that timing during read, Needs to delay ODT signal by cfg_tcl - cfg_cas_wr_lat
    
    assign  diff_unreg              = cfg_tcl - cfg_cas_wr_lat;
    assign  diff_modulo_unreg       = (diff % CFG_ODTPIPE_THRESHOLD); 
    assign  sel_do_read_pipe_unreg  = (diff / CFG_ODTPIPE_THRESHOLD) + diff_modulo_not_zero;
    //assign  diff_modulo_not_zero    = (|diff_modulo);
    //assign sel_do_read_pipe = diff - CFG_ODTPIPE_THRESHOLD;
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin 
                    diff                <= 0; 
                    diff_modulo         <= 0;
                    sel_do_read_pipe    <= 0;
                end
            else
                begin 
                    diff                <= diff_unreg; 
                    diff_modulo         <= diff_modulo_unreg;
                    sel_do_read_pipe    <= (sel_do_read_pipe_unreg > 0) ? (sel_do_read_pipe_unreg - 1'b1) : 0;
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    diff_modulo_not_zero <= 1'b0;
                    diff_modulo_one      <= 1'b0;
                    diff_modulo_two      <= 1'b0;
                    diff_modulo_three    <= 1'b0;
                end
            else
                begin
                    diff_modulo_not_zero <= |diff_modulo;
                    diff_modulo_one      <= (diff_modulo == 1) ? 1'b1 : 1'b0;
                    diff_modulo_two      <= (diff_modulo == 2) ? 1'b1 : 1'b0;
                    diff_modulo_three    <= (diff_modulo == 3) ? 1'b1 : 1'b0;
                end
        end

    always @ (*) 
        begin
            int_do_read              = (diff < CFG_ODTPIPE_THRESHOLD) ? bg_do_read       : do_read_pipe       [sel_do_read_pipe] ;
            int_do_read_burst_chop_c = (diff < CFG_ODTPIPE_THRESHOLD) ? bg_do_burst_chop : do_burst_chop_pipe [sel_do_read_pipe] ;
        end

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
        begin
            if (~ctl_reset_n)
                begin
                    int_do_read_burst_chop <= 1'b0;
                end
            else
                begin
                    if (int_do_read)
                        begin
                            int_do_read_burst_chop <= int_do_read_burst_chop_c;
                        end
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    do_read_pipe <= 0;
                end
            else
                begin
                    do_read_pipe[CFG_TCL_PIPE_LENGTH-1:0] <= {do_read_pipe[CFG_TCL_PIPE_LENGTH-2:0], bg_do_read};
                end
        end

    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    do_burst_chop_pipe <= 0;
                end
            else
                begin
                    do_burst_chop_pipe[CFG_TCL_PIPE_LENGTH-1:0] <= {do_burst_chop_pipe[CFG_TCL_PIPE_LENGTH-2:0], bg_do_burst_chop};
                end
        end
    
    assign doing_read_count_limit    = int_do_read_burst_chop ? ((CFG_ODTH4 / (CFG_DWIDTH_RATIO / 2)) - 1) : ((CFG_ODTH8 / (CFG_DWIDTH_RATIO / 2)) - 1);
    assign doing_read_count_not_zero = (|doing_read_count);
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    doing_read_count <= 0;
                end
            else
                begin
                    if (int_do_read)
                        begin
                            doing_read_count <= 1;
                        end
                    else if (doing_read_count >= doing_read_count_limit)
                        begin
                            doing_read_count <= 0;
                        end
                    else if (doing_read_count > 0)
                        begin
                            doing_read_count <= doing_read_count + 1'b1;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (~ctl_reset_n)
                begin
                    doing_read_count_not_zero_r <= 1'b0;
                end
            else
                begin
                    doing_read_count_not_zero_r <= doing_read_count_not_zero;
                end
        end

    //=================================================================================================//
    //        Define ODT pulse width during WRITE operation                                            //
    //=================================================================================================//

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
        begin
            if (~ctl_reset_n)
                begin
                    int_do_write_burst_chop <= 1'b0;
                end
            else
                begin
                    if (bg_do_write)
                        begin
                            int_do_write_burst_chop <= bg_do_burst_chop;
                        end
                end
        end

    assign doing_write_count_limit = int_do_write_burst_chop ? ((CFG_ODTH4 / (CFG_DWIDTH_RATIO / 2)) - 1) : ((CFG_ODTH8 / (CFG_DWIDTH_RATIO / 2)) - 1);
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    doing_write_count <= 0;
                end
            else
                begin
                    if (bg_do_write)
                        begin
                            doing_write_count <= 1;
                        end
                    else if (doing_write_count >= doing_write_count_limit)
                        begin
                            doing_write_count <= 0;
                        end
                    else if (doing_write_count > 0)
                        begin
                            doing_write_count <= doing_write_count + 1'b1;
                        end
            end
        end
    
    //=================================================================================================//
    //        ODT signal generation block                                                              //
    //=================================================================================================//
    
    always @ (*)
        begin
            if (bg_do_write || int_do_read)
                begin
                    premux_odt_h = 1'b1;
                end
            else if (doing_write_count > 0 || doing_read_count > 0)
                begin
                    premux_odt_h = 1'b1;
                end
            else
                begin
                    premux_odt_h = 1'b0;
                end
        end
  
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
        begin
            if (~ctl_reset_n)
                begin
                    premux_odt_h_r  <= 1'b0;
                end
            else
                begin
                    if (int_do_read)
                        begin
                            premux_odt_h_r <= 1'b1;
                        end
                    else if ((doing_read_count > 1 && ((diff_modulo_one && CFG_ODTPIPE_THRESHOLD == 4) || diff_modulo_two)) || (doing_read_count > 0 && ((diff_modulo_one && CFG_ODTPIPE_THRESHOLD == 2) || diff_modulo_three)))
                        begin
                            premux_odt_h_r <= 1'b1;
                        end
                    else
                        begin
                            premux_odt_h_r <= 1'b0;
                        end
                end
        end

    always @ (*)
        begin
            if (diff_modulo_not_zero & (int_do_read|doing_read_count_not_zero_r))
                begin
                    int_odt_h_int = premux_odt_h_r;
                end
            else // write, read with normal odt
                begin 
                    int_odt_h_int = premux_odt_h;
                end
        end

    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_odt_l_int <= 1'b0;
                end
            else
                begin
                    if (bg_do_write || (int_do_read && !diff_modulo_two && !diff_modulo_three))
                        begin
                            int_odt_l_int <= 1'b1;
                        end
                    else if (doing_write_count > 0 || doing_read_count > 0)
                        begin
                            int_odt_l_int <= 1'b1;
                        end
                    else
                        begin
                            int_odt_l_int <= 1'b0;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_odt_i_1_int <= 1'b0;
                end
            else
                begin
                    if (bg_do_write || int_do_read)
                        begin
                            int_odt_i_1_int <= 1'b1;
                        end
                    else if (doing_write_count > 1 || (doing_read_count > 1 && !diff_modulo_not_zero) || (doing_read_count > 0 && diff_modulo_not_zero))
                        begin
                            int_odt_i_1_int <= 1'b1;
                        end
                    else
                        begin
                            int_odt_i_1_int <= 1'b0;
                        end
                end
        end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_odt_i_2_int <= 1'b0;
                end
            else
                begin
                    if (bg_do_write || int_do_read)
                        begin
                            int_odt_i_2_int <= 1'b1;
                        end
                    else if (doing_write_count > 1 || (doing_read_count > 1 && (!diff_modulo_not_zero || diff_modulo_one)) || (doing_read_count > 0 && (diff_modulo_two || diff_modulo_three)))
                        begin
                            int_odt_i_2_int <= 1'b1;
                        end
                    else
                        begin
                            int_odt_i_2_int <= 1'b0;
                        end
                end
        end
    
    //Generate registered output
    always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    int_odt_h_int_r   <= 1'b0;
                    int_odt_l_int_r   <= 1'b0;
                    int_odt_i_1_int_r <= 1'b0;
                    int_odt_i_2_int_r <= 1'b0;
                end
            else
                begin
                    int_odt_h_int_r   <= int_odt_h_int;
                    int_odt_l_int_r   <= int_odt_l_int;
                    int_odt_i_1_int_r <= int_odt_i_1_int;
                    int_odt_i_2_int_r <= int_odt_i_2_int;
                end
        end
    
    generate
        if (CFG_DWIDTH_RATIO == 2) // full rate
            begin
                assign  int_odt_h   = (cfg_output_regd) ? int_odt_h_int_r : int_odt_h_int;
                assign  int_odt_l   = (cfg_output_regd) ? int_odt_h_int_r : int_odt_h_int;
                assign  int_odt_i_1 = 1'b0;
                assign  int_odt_i_2 = 1'b0;
            end
        else if (CFG_DWIDTH_RATIO == 4) // half rate
            begin
                assign  int_odt_h   = (cfg_output_regd) ? int_odt_h_int_r : int_odt_h_int;
                assign  int_odt_l   = (cfg_output_regd) ? int_odt_l_int_r : int_odt_l_int;
                assign  int_odt_i_1 = 1'b0;
                assign  int_odt_i_2 = 1'b0;
            end
        else if (CFG_DWIDTH_RATIO == 8) // quarter rate
            begin
                assign  int_odt_h   = (cfg_output_regd) ? int_odt_h_int_r   : int_odt_h_int;
                assign  int_odt_l   = (cfg_output_regd) ? int_odt_l_int_r   : int_odt_l_int;
                assign  int_odt_i_1 = (cfg_output_regd) ? int_odt_i_1_int_r : int_odt_i_1_int;
                assign  int_odt_i_2 = (cfg_output_regd) ? int_odt_i_2_int_r : int_odt_i_2_int;
            end
    endgenerate
    
endmodule
