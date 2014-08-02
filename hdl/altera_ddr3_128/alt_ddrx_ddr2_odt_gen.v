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
// Title         : DDR2 controller ODT block
//
// File          : alt_ddrx_ddr2_odt_gen.v
//
// Abstract      : DDR2 ODT signal generator block
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_ddr2_odt_gen
    # (parameter
        DWIDTH_RATIO        =   2,
        MEMORY_BURSTLENGTH  =   8,
        ADD_LAT_BUS_WIDTH   =   3,
        CTL_OUTPUT_REGD     =   0,
        TCL_BUS_WIDTH       =   4
    )
    (
        ctl_clk,
        ctl_reset_n,
        mem_tcl,
        mem_add_lat,
        do_write,
        do_read,
        int_odt_l,
        int_odt_h
    );
    
    input                           ctl_clk;
    input                           ctl_reset_n;
    input   [TCL_BUS_WIDTH-1:0]     mem_tcl;
    input   [ADD_LAT_BUS_WIDTH-1:0] mem_add_lat;
    
    input do_write;
    input do_read;
    
    output  int_odt_l;
    output  int_odt_h;
    
    localparam   TCL_PIPE_LENGTH =   2**TCL_BUS_WIDTH; // okay to size this to 4 since max latency in DDR2 is 7+6=13
    localparam   TAOND           =   2;
    localparam   TAOFD           =   2.5;
    
    wire do_write;
    wire do_read;
    wire [1:0] regd_output;
    
    wire [TCL_BUS_WIDTH-1:0]    int_tcwl_unreg;
    reg  [TCL_BUS_WIDTH-1:0]    int_tcwl;
    
    wire int_odt_l;
    wire int_odt_h;
    
    reg reg_odt_l;
    reg reg_odt_h;
    
    reg combi_odt_l;
    reg combi_odt_h;
    
    reg [1:0] offset_code;
    
    reg start_odt_write;
    reg start_odt_read;
    reg [TCL_PIPE_LENGTH-1:0]   do_write_pipe;
    reg [TCL_PIPE_LENGTH-1:0]   do_read_pipe;
    
    assign  int_odt_l   =   combi_odt_l | reg_odt_l;
    assign  int_odt_h   =   combi_odt_h | reg_odt_h;
    assign  regd_output = (DWIDTH_RATIO == 2) ? (CTL_OUTPUT_REGD ? 2'd1 : 2'd0) : (CTL_OUTPUT_REGD ? 2'd2 : 2'd0);
    assign  int_tcwl_unreg    = (mem_tcl + mem_add_lat + regd_output - 1'b1);
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_tcwl    <=  0;
            else
                int_tcwl    <=  int_tcwl_unreg;
        end
    
    always @(*)
        begin
            if (DWIDTH_RATIO == 2)
                begin
                    if (int_tcwl < 4)
                        start_odt_write <=  do_write;
                    else
                        start_odt_write <=  do_write_pipe[int_tcwl - 4];
                end
            else // half rate
                begin
                    if (int_tcwl < 4)
                        start_odt_write <=  do_write;
                    else
                        start_odt_write <=  do_write_pipe[(int_tcwl - 4)/2];
                end
        end
    
    always @(*)
        begin
            if (DWIDTH_RATIO == 2)
                begin
                    if (int_tcwl < 3)
                        start_odt_read  <=  do_read;
                    else
                        start_odt_read  <=  do_read_pipe[int_tcwl - 3];
                end
            else // half rate
                begin
                    if (int_tcwl < 3)
                        start_odt_read  <=  do_read;
                    else
                        start_odt_read  <=  do_read_pipe[(int_tcwl - 3)/2];
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                do_write_pipe    <=  0;
            else
                if (do_write)
                    do_write_pipe    <=  {do_write_pipe[TCL_PIPE_LENGTH-2:0],do_write};
                else
                    do_write_pipe    <=  {do_write_pipe[TCL_PIPE_LENGTH-2:0],1'b0};
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                do_read_pipe    <=  0;
            else
                if (do_read)
                    do_read_pipe    <=  {do_read_pipe[TCL_PIPE_LENGTH-2:0],do_read};
                else
                    do_read_pipe    <=  {do_read_pipe[TCL_PIPE_LENGTH-2:0],1'b0};
        end
    
    // these blocks already assumes burstlength 8 in half rate and BL4 in full rate
    always @(*)
        begin
            if (DWIDTH_RATIO == 2)
                begin
                    if (start_odt_write || start_odt_read)
                        combi_odt_l <=  1'b1;
                    else
                        combi_odt_l <=  1'b0;
                end
            else // half rate
                begin
                    if (int_tcwl % 2 == 0) //even
                        begin
                            if (start_odt_write)
                                begin
                                    combi_odt_l   <=  1'b1;
                                    combi_odt_h   <=  1'b1;
                                end
                            else if (start_odt_read)
                                begin
                                    combi_odt_l   <=  1'b0;
                                    combi_odt_h   <=  1'b1;
                                end
                            else
                                begin
                                    combi_odt_l   <=  1'b0;
                                    combi_odt_h   <=  1'b0;
                                end
                        end
                    else
                        begin
                            if (start_odt_read)
                                begin
                                    combi_odt_l   <=  1'b1;
                                    combi_odt_h   <=  1'b1;
                                end
                            else if (start_odt_write)
                                begin
                                    combi_odt_l   <=  1'b0;
                                    combi_odt_h   <=  1'b1;
                                end
                            else
                                begin
                                    combi_odt_l   <=  1'b0;
                                    combi_odt_h   <=  1'b0;
                                end
                        end
                end
        end
    
    always @(posedge ctl_clk, negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                begin
                    reg_odt_l   <=  1'b0;
                    reg_odt_h   <=  1'b0;
                    offset_code <=  0;
                end
            else
                if (DWIDTH_RATIO == 2)
                    begin
                        reg_odt_h   <=  1'b0;
                        if (start_odt_write || start_odt_read)
                            begin
                                reg_odt_l   <=  1'b1;
                                offset_code <=  2;
                            end
                        else if (offset_code == 2)
                            offset_code <=  3;
                        else if (offset_code == 3)
                            begin
                                offset_code <=  0;
                                reg_odt_l   <=  1'b0;
                            end
                    end
                else
                    begin
                        if (int_tcwl % 2 == 0) //even
                            begin
                                if (start_odt_write)
                                    begin
                                        reg_odt_l   <=  1'b1;
                                        reg_odt_h   <=  1'b1;
                                        offset_code <=  3;
                                    end
                                else if (start_odt_read)
                                    begin
                                        reg_odt_l   <=  1'b1;
                                        reg_odt_h   <=  1'b1;
                                        offset_code <=  0;
                                    end
                                else if (reg_odt_h && reg_odt_l && offset_code == 0)
                                    offset_code <=  1;
                                else if (reg_odt_h && reg_odt_l && offset_code == 1)
                                    begin
                                        reg_odt_l   <=  1'b0;
                                        reg_odt_h   <=  1'b0;
                                        offset_code <=  0;
                                    end
                                else if (reg_odt_h && reg_odt_l && offset_code == 3)
                                    begin
                                        reg_odt_h   <=  1'b0;
                                        offset_code <=  0;
                                    end
                                else if (!reg_odt_h && reg_odt_l)
                                    begin
                                        reg_odt_l   <=  1'b0;
                                        offset_code <=  0;
                                    end
                            end
                        else
                            begin
                                if (start_odt_read)
                                    begin
                                        reg_odt_l   <=  1'b1;
                                        reg_odt_h   <=  1'b1;
                                        offset_code <=  3;
                                    end
                                else if (start_odt_write)
                                    begin
                                        reg_odt_l   <=  1'b1;
                                        reg_odt_h   <=  1'b1;
                                        offset_code <=  0;
                                    end
                                else if (reg_odt_h && reg_odt_l && offset_code == 0)
                                    offset_code <=  1;
                                else if (reg_odt_h && reg_odt_l && offset_code == 1)
                                    begin
                                        reg_odt_l   <=  1'b0;
                                        reg_odt_h   <=  1'b0;
                                        offset_code <=  0;
                                    end
                                else if (reg_odt_h && reg_odt_l && offset_code == 3)
                                    begin
                                        reg_odt_h   <=  1'b0;
                                        offset_code <=  0;
                                    end
                                else if (!reg_odt_h && reg_odt_l)
                                    begin
                                        reg_odt_l   <=  1'b0;
                                        offset_code <=  0;
                                    end
                            end
                    end
        end

endmodule
