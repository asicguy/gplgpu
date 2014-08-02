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
// Title         : DDR controller ODT block
//
// File          : alt_ddrx_odt_gen.v
//
// Abstract      : ODT signal generator block
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_odt_gen
    # (parameter
    
        DWIDTH_RATIO        =   2,
        MEM_TYPE            =   "DDR2",
        MEM_IF_CS_WIDTH     =   1,
        MEM_IF_ODT_WIDTH    =   1,
        CTL_ODT_ENABLED     =   1,
        CTL_OUTPUT_REGD     =   0,
        MEM_IF_CS_PER_DIMM  =   1,
        MEMORY_BURSTLENGTH  =   8,
        ADD_LAT_BUS_WIDTH   =   3,
        CAS_WR_LAT_BUS_WIDTH=   4,
        CTL_REGDIMM_ENABLED =   0,
        TCL_BUS_WIDTH       =   4
    
    )
    (
    
        ctl_clk,
        ctl_reset_n,
        mem_tcl,
        mem_cas_wr_lat,
        mem_add_lat,
        
        // state machine command inputs
        do_write,
        do_read,
        
        // address information
        to_chip, // active high input (one hot)
        
        // ODT output
        afi_odt
    );
    
    input                               ctl_clk;
    input                               ctl_reset_n;
    input   [TCL_BUS_WIDTH-1:0]         mem_tcl;
    input   [CAS_WR_LAT_BUS_WIDTH-1:0]  mem_cas_wr_lat;
    input   [ADD_LAT_BUS_WIDTH-1:0]     mem_add_lat;
    
    // state machine command inputs
    input do_write;
    input do_read;
    
    // address information
    input   [MEM_IF_CS_WIDTH-1:0]  to_chip;
    
    // ODT output
    output  [(MEM_IF_ODT_WIDTH * (DWIDTH_RATIO/2)) - 1:0]   afi_odt;
    
    wire [MEM_IF_ODT_WIDTH - 1:0]   write_to_this_chip;
    wire [MEM_IF_ODT_WIDTH - 1:0]   read_to_this_chip;
    wire [MEM_IF_ODT_WIDTH - 1:0]   odt_bus_l; // second half
    wire [MEM_IF_ODT_WIDTH - 1:0]   odt_bus_h; // first half
    wire [MEM_IF_ODT_WIDTH - 1:0]   correct_odt_l;
    wire [MEM_IF_ODT_WIDTH - 1:0]   correct_odt_h;
    
    wire                            do_write;
    wire                            do_read;
    wire    [MEM_IF_CS_WIDTH-1:0]   to_chip;
    
    reg                             do_write_r;
    reg                             do_read_r;
    reg     [MEM_IF_CS_WIDTH-1:0]   to_chip_r;
    
    reg     [MEM_IF_CS_WIDTH-1:0]   to_chip_gen;
    
    // generate block for *_r signals, these signals are only used by DDR3 ODT block
    // DDR2 ODT block uses the original signal and register them inside their blocks
    generate
        if (CTL_OUTPUT_REGD == 1)
            begin
                always @(posedge ctl_clk, negedge ctl_reset_n)
                    begin
                        if (!ctl_reset_n)
                            begin
                                do_write_r  <=  0;
                                do_read_r   <=  0;
                                to_chip_r   <=  0;
                            end
                        else
                            begin
                                do_write_r  <=  do_write;
                                do_read_r   <=  do_read;
                                to_chip_r   <=  to_chip;
                            end
                    end
            end
        else
            begin
                always @(do_write)
                    do_write_r  <=  do_write;
                
                always @(do_read)
                    do_read_r  <=  do_read;
                
                always @(to_chip)
                    to_chip_r  <=  to_chip;
            end
    endgenerate
    
    generate
        if (CTL_ODT_ENABLED == 1)
            begin
                if (DWIDTH_RATIO == 2)
                    assign afi_odt      = correct_odt_l;
                else
                    assign afi_odt     = {correct_odt_h,correct_odt_l};
            end
        else
            assign afi_odt = {(MEM_IF_ODT_WIDTH * (DWIDTH_RATIO/2)){1'b0}};
    endgenerate
    
    /*
    DDR3
    four chip selects odt scheme, for two ranks per dimm configuration
    .---------------------------------------++---------------------------------------.
    |               write to                ||                odt to                 |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |  chip 0 |  chip 1 |  chip 2 |  chip 3 ||  chip 0 |  chip 1 |  chip 2 |  chip 3 |
    |=--------+---------+---------+---------++---------+---------+---------+--------=|
    |    1    |         |         |         ||    1    |         |    1    |         |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |    1    |         |         ||         |    1    |         |    1    |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |    1    |         ||    1    |         |    1    |         |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |         |    1    ||         |    1    |         |    1    |
    '---------+---------+---------+---------++---------+---------+---------+---------'
    .---------------------------------------++---------------------------------------.
    |                read to                ||                odt to                 |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |  chip 0 |  chip 1 |  chip 2 |  chip 3 ||  chip 0 |  chip 1 |  chip 2 |  chip 3 |
    |=--------+---------+---------+---------++---------+---------+---------+--------=|
    |    1    |         |         |         ||         |         |    1    |         |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |    1    |         |         ||         |         |         |    1    |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |    1    |         ||    1    |         |         |         |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |         |    1    ||         |    1    |         |         |
    '---------+---------+---------+---------++---------+---------+---------+---------'
    */
    
    generate
        if (MEM_TYPE == "DDR3")
            begin
                assign  correct_odt_l   =   odt_bus_l;
                assign  correct_odt_h   =   odt_bus_h;
            end
    endgenerate
    
    /*
    DDR2
    four or more chip selects odt scheme, assumes two ranks per dimm
    .---------------------------------------++---------------------------------------.
    |             write/read to             ||                odt to                 |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    | chipJ+0 | chipJ+1 | chipJ+2 | chipJ+3 || chipJ+0 | chipJ+1 | chipJ+2 | chipJ+3 |
    |=--------+---------+---------+---------++---------+---------+---------+--------=|
    |    1    |         |         |         ||         |         |    1    |         |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |    1    |         |         ||         |         |         |    1    |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |    1    |         ||    1    |         |         |         |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |         |    1    ||         |    1    |         |         |
    '---------+---------+---------+---------++---------+---------+---------+---------'
    */
    
    generate
        if (MEM_TYPE == "DDR2")
            begin
                assign  correct_odt_l   =   odt_bus_l;
                assign  correct_odt_h   =   odt_bus_h;
            end
    endgenerate
    
    generate
        if (MEM_TYPE == "DDR3")
            begin
                integer i;
                integer j;
                always @(*)
                    begin
                        if (MEM_IF_CS_PER_DIMM == 1)
                            begin
                                if (MEM_IF_ODT_WIDTH == 1)
                                    begin
                                        if (do_read_r)
                                            to_chip_gen <=  {MEM_IF_CS_WIDTH{1'b0}};
                                        else
                                            to_chip_gen <=  to_chip_r;
                                    end
                                else if (MEM_IF_ODT_WIDTH == 2)
                                    begin
                                        if (do_read_r)
                                            to_chip_gen <=  ~to_chip_r;
                                        else
                                            to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                    end
                                else // when 2 rank per slot ODT width can only be 2 or more, so this is for 4 and 8
                                    begin
                                        if (do_read_r)
                                            begin
                                                for (i = 0; i < MEM_IF_ODT_WIDTH/4; i = i + 1)
                                                begin : H
                                                    for (j = 0; j < 4; j = j + 1)
                                                    begin : G
                                                        if (j < 2)
                                                            to_chip_gen[(i*4)+(j+2)]    <=  to_chip_r[(i*4)+j];
                                                        else
                                                            to_chip_gen[(i*4)+(j-2)]    <=  to_chip_r[(i*4)+j];
                                                    end
                                                end
                                            end
                                        else // write
                                            begin
                                                if (&to_chip_r)
                                                    to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                                else
                                                    begin
                                                        for (i = 0; i < MEM_IF_ODT_WIDTH/4; i = i + 1)
                                                        begin : L
                                                            for (j = 0; j < 4; j = j + 1)
                                                            begin : K
                                                                if (j < 2)
                                                                    to_chip_gen[(i*4)+(j+2)]    <=  to_chip_r[(i*4)+j] | to_chip_r[(i*4)+(j+2)];
                                                                else
                                                                    to_chip_gen[(i*4)+(j-2)]    <=  to_chip_r[(i*4)+j] | to_chip_r[(i*4)+(j-2)];
                                                            end
                                                        end
                                                    end
                                            end
                                    end
                            end
                        else if (MEM_IF_CS_PER_DIMM == 2)
                            begin
                                if (MEM_IF_ODT_WIDTH == 2)
                                    begin
                                        if (do_read_r)
                                            to_chip_gen <=  {MEM_IF_CS_WIDTH{1'b0}};
                                        else
                                            begin
                                                if (&to_chip_r)
                                                    to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                                else
                                                    to_chip_gen <=  to_chip_r;
                                            end
                                    end
                                else // when 2 rank per slot ODT width can only be 2 or more, so this is for 4 and 8
                                    begin
                                        if (do_read_r)
                                            begin
                                                for (i = 0; i < MEM_IF_ODT_WIDTH/4; i = i + 1)
                                                begin : N
                                                    for (j = 0; j < 4; j = j + 1)
                                                    begin : M
                                                        if (j < 2)
                                                            to_chip_gen[(i*4)+(j+2)]    <=  to_chip_r[(i*4)+j];
                                                        else
                                                            to_chip_gen[(i*4)+(j-2)]    <=  to_chip_r[(i*4)+j];
                                                    end
                                                end
                                            end
                                        else // write
                                            begin
                                                if (&to_chip_r)
                                                    to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                                else
                                                    begin
                                                        for (i = 0; i < MEM_IF_ODT_WIDTH/4; i = i + 1)
                                                        begin : P
                                                            for (j = 0; j < 4; j = j + 1)
                                                            begin : O
                                                                if (j < 2)
                                                                    to_chip_gen[(i*4)+(j+2)]    <=  to_chip_r[(i*4)+j] | to_chip_r[(i*4)+(j+2)];
                                                                else
                                                                    to_chip_gen[(i*4)+(j-2)]    <=  to_chip_r[(i*4)+j] | to_chip_r[(i*4)+(j-2)];
                                                            end
                                                        end
                                                    end
                                            end
                                    end
                            end
                        else // 4 ranks per slot
                            begin
                                if (MEM_IF_ODT_WIDTH == 4)
                                    begin
                                        if (do_read_r)
                                            to_chip_gen <=  0;
                                        else
                                            begin
                                                if (&to_chip_r)
                                                    to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                                else
                                                    to_chip_gen <=  to_chip_r;
                                            end
                                    end
                                else // when 4 rank per slot ODT width can only be 4 or more, so this is for 8
                                    begin
                                        if (do_read_r)
                                            begin
                                                for (i = 0; i < MEM_IF_ODT_WIDTH/8; i = i + 1)
                                                begin : R
                                                    for (j = 0; j < 8; j = j + 1)
                                                    begin : Q
                                                        if (j < 4)
                                                            to_chip_gen[(i*4)+(j+4)]    <=  to_chip_r[(i*4)+j];
                                                        else
                                                            to_chip_gen[(i*4)+(j-4)]    <=  to_chip_r[(i*4)+j];
                                                    end
                                                end
                                            end
                                        else // write
                                            begin
                                                if (&to_chip_r)
                                                    to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                                else
                                                    begin
                                                        for (i = 0; i < MEM_IF_ODT_WIDTH/8; i = i + 1)
                                                        begin : T
                                                            for (j = 0; j < 8; j = j + 1)
                                                            begin : S
                                                                if (j < 4)
                                                                    to_chip_gen[(i*4)+(j+4)]    <=  to_chip_r[(i*4)+j] | to_chip_r[(i*4)+(j+4)];
                                                                else
                                                                    to_chip_gen[(i*4)+(j-4)]    <=  to_chip_r[(i*4)+j] | to_chip_r[(i*4)+(j-4)];
                                                            end
                                                        end
                                                    end
                                            end
                                    end
                            end
                    end
                
                genvar I;
                for (I = 0; I < MEM_IF_ODT_WIDTH; I = I + 1)
                begin : F
                    assign write_to_this_chip[I] = do_write_r & to_chip_gen[I];
                    assign read_to_this_chip[I] = do_read_r & to_chip_gen[I];
                    
                    alt_ddrx_ddr3_odt_gen # (
                        .DWIDTH_RATIO (DWIDTH_RATIO),
                        .TCL_BUS_WIDTH (TCL_BUS_WIDTH),
                        .CAS_WR_LAT_BUS_WIDTH (CAS_WR_LAT_BUS_WIDTH)
                    ) odt_gen_inst (
                        .ctl_clk (ctl_clk),
                        .ctl_reset_n (ctl_reset_n),
                        .mem_tcl (mem_tcl),
                        .mem_cas_wr_lat (mem_cas_wr_lat),
                        .do_write (write_to_this_chip[I]),
                        .do_read (read_to_this_chip[I]),
                        .int_odt_l (odt_bus_l[I]),
                        .int_odt_h (odt_bus_h[I])
                    );
                end
            end
        else
            begin
                integer i;
                integer j;
                always @(*)
                    begin
                        if (MEM_IF_CS_PER_DIMM == 1)
                            begin
                                if (MEM_IF_ODT_WIDTH == 1)
                                    begin
                                        if (do_read)
                                            to_chip_gen <=  {MEM_IF_CS_WIDTH{1'b0}};
                                        else
                                            to_chip_gen <=  to_chip;
                                    end
                                else if (MEM_IF_ODT_WIDTH == 2)
                                    to_chip_gen <=  ~to_chip;
                                else // when 2 rank per slot ODT width can only be 2 or more, so this is for 4 and 8
                                    begin
                                        if (&to_chip)
                                            to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                        else
                                            begin
                                                for (i = 0; i < MEM_IF_ODT_WIDTH/4; i = i + 1)
                                                begin : L
                                                    for (j = 0; j < 4; j = j + 1)
                                                    begin : K
                                                        if (j < 2)
                                                            to_chip_gen[(i*4)+(j+2)]    <=  to_chip[(i*4)+j];
                                                        else
                                                            to_chip_gen[(i*4)+(j-2)]    <=  to_chip[(i*4)+j];
                                                    end
                                                end
                                            end
                                    end
                            end
                        else if (MEM_IF_CS_PER_DIMM == 2)
                            begin
                                if (MEM_IF_ODT_WIDTH == 2)
                                    begin
                                        if (do_read)
                                            to_chip_gen <=  {MEM_IF_CS_WIDTH{1'b0}};
                                        else
                                            begin
                                                if (&to_chip)
                                                    to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                                else
                                                    to_chip_gen <=  to_chip;
                                            end
                                    end
                                else // when 2 rank per slot ODT width can only be 2 or more, so this is for 4 and 8
                                    begin
                                        if (&to_chip)
                                            to_chip_gen <= {MEM_IF_CS_WIDTH{1'b1}};
                                        else
                                            begin
                                                for (i = 0; i < MEM_IF_ODT_WIDTH/4; i = i + 1)
                                                begin : P
                                                    for (j = 0; j < 4; j = j + 1)
                                                    begin : O
                                                        if (j < 2)
                                                            to_chip_gen[(i*4)+(j+2)]    <=  to_chip[(i*4)+j];
                                                        else
                                                            to_chip_gen[(i*4)+(j-2)]    <=  to_chip[(i*4)+j];
                                                    end
                                                end
                                            end
                                    end
                            end
                    end
                
                genvar I;
                for (I = 0; I < MEM_IF_ODT_WIDTH; I = I + 1)
                begin : F
                    assign write_to_this_chip[I] = do_write & to_chip_gen[I];
                    assign read_to_this_chip[I] = do_read & to_chip_gen[I];
                    
                    alt_ddrx_ddr2_odt_gen # (
                        .DWIDTH_RATIO (DWIDTH_RATIO),
                        .MEMORY_BURSTLENGTH (MEMORY_BURSTLENGTH),
                        .ADD_LAT_BUS_WIDTH (ADD_LAT_BUS_WIDTH),
                        .CTL_OUTPUT_REGD (CTL_OUTPUT_REGD),
                        .TCL_BUS_WIDTH (TCL_BUS_WIDTH)
                    ) odt_gen_inst (
                        .ctl_clk (ctl_clk),
                        .ctl_reset_n (ctl_reset_n),
                        .mem_tcl (mem_tcl),
                        .mem_add_lat (mem_add_lat),
                        .do_write (write_to_this_chip[I]),
                        .do_read (read_to_this_chip[I]),
                        .int_odt_l (odt_bus_l[I]),
                        .int_odt_h (odt_bus_h[I])
                    );
                end
            end
    endgenerate
    
    
endmodule
