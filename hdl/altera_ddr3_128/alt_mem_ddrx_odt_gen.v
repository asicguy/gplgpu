
//altera message_off 10036

`include "alt_mem_ddrx_define.iv"

`timescale 1 ps / 1 ps
module alt_mem_ddrx_odt_gen
    #( parameter
        CFG_DWIDTH_RATIO                = 2,
        CFG_ODT_ENABLED                 = 1,
        CFG_MEM_IF_CHIP                 = 2, //one_hot
        CFG_MEM_IF_ODT_WIDTH            = 2,
        CFG_PORT_WIDTH_OUTPUT_REGD      = 1,
        CFG_PORT_WIDTH_CAS_WR_LAT       = 4,
        CFG_PORT_WIDTH_TCL              = 4,
        CFG_PORT_WIDTH_ADD_LAT          = 3,
        CFG_PORT_WIDTH_TYPE             = 3,
        CFG_PORT_WIDTH_WRITE_ODT_CHIP   = 4,
        CFG_PORT_WIDTH_READ_ODT_CHIP    = 4
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        //Configuration Interface
        cfg_type,
        cfg_tcl,
        cfg_cas_wr_lat,
        cfg_add_lat,
        cfg_write_odt_chip,
        cfg_read_odt_chip,
        cfg_burst_length,
        cfg_output_regd,
        
        //Arbiter Interface
        bg_do_read,
        bg_do_write,
        bg_do_burst_chop,
        bg_to_chip, //one_hot
        
        //AFI Interface
        afi_odt
    );
    
    //=================================================================================================//
    //        input/output declaration                                                                 //
    //=================================================================================================//
    
    input                                                     ctl_clk;
    input                                                     ctl_reset_n;
    
    //Input from Configuration Interface
    
    input   [CFG_PORT_WIDTH_TYPE                -1:0]         cfg_type;
    input   [CFG_PORT_WIDTH_TCL                 -1:0]         cfg_tcl;
    input   [CFG_PORT_WIDTH_CAS_WR_LAT          -1:0]         cfg_cas_wr_lat;
    input   [CFG_PORT_WIDTH_ADD_LAT             -1:0]         cfg_add_lat;
    input   [CFG_PORT_WIDTH_WRITE_ODT_CHIP      -1:0]         cfg_write_odt_chip;
    input   [CFG_PORT_WIDTH_READ_ODT_CHIP       -1:0]         cfg_read_odt_chip;
    input   [4:0]                                             cfg_burst_length;
    input   [CFG_PORT_WIDTH_OUTPUT_REGD         -1:0]         cfg_output_regd;
     
    //Inputs from Arbiter Interface
    
    input                                                     bg_do_read;
    input                                                     bg_do_write;
    input                                                     bg_do_burst_chop;
    input   [CFG_MEM_IF_CHIP                         -1:0]    bg_to_chip;
    
    //Output to AFI Interface
    
    output  [(CFG_MEM_IF_ODT_WIDTH*(CFG_DWIDTH_RATIO/2))-1:0] afi_odt;
    
    //=================================================================================================//
    //        reg/wire declaration                                                                     //
    //=================================================================================================//
    
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  write_odt_chip  [CFG_MEM_IF_CHIP-1:0];
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  read_odt_chip   [CFG_MEM_IF_CHIP-1:0];
    
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  ddr2_odt_l;
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  ddr2_odt_h;
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  ddr3_odt_l;
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  ddr3_odt_h;
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  ddr3_odt_i_1;
    wire    [CFG_MEM_IF_ODT_WIDTH-1:0]                  ddr3_odt_i_2;
    
    reg     [CFG_MEM_IF_ODT_WIDTH-1:0]                  int_odt_l;
    reg     [CFG_MEM_IF_ODT_WIDTH-1:0]                  int_odt_h;
    reg     [CFG_MEM_IF_ODT_WIDTH-1:0]                  int_odt_i_1;
    reg     [CFG_MEM_IF_ODT_WIDTH-1:0]                  int_odt_i_2;
    reg     [CFG_MEM_IF_ODT_WIDTH-1:0]                  int_write_odt_chip;
    reg     [CFG_MEM_IF_ODT_WIDTH-1:0]                  int_read_odt_chip;
    
    integer i;
    
    //=================================================================================================//
    //        cfg_write_odt_chip & cfg_read_odt_chip definition                                        //
    //=================================================================================================//
    
    /*
    DDR3
    four chip selects odt scheme, for two ranks per dimm configuration
    .---------------------------------------++---------------------------------------.
    |               write to                ||                odt to                 |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |  chip 0 |  chip 1 |  chip 2 |  chip 3 ||  chip 0 |  chip 1 |  chip 2 |  chip 3 |
    |=--------+---------+---------+---------++---------+---------+---------+--------=|
    |    1    |         |         |         ||    1    |         |    1    |         |    //cfg_write_odt_chip[0] = 4'b0101; //chip[3] -> chip[0]
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |    1    |         |         ||         |    1    |         |    1    |    //cfg_write_odt_chip[1] = 4'b1010; //chip[3] -> chip[0]
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |    1    |         ||    1    |         |    1    |         |    //cfg_write_odt_chip[2] = 4'b0101; //chip[3] -> chip[0]
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |         |    1    ||         |    1    |         |    1    |    //cfg_write_odt_chip[3] = 4'b1010; //chip[3] -> chip[0]
    '---------+---------+---------+---------++---------+---------+---------+---------'
    .---------------------------------------++---------------------------------------.
    |                read to                ||                odt to                 |
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |  chip 0 |  chip 1 |  chip 2 |  chip 3 ||  chip 0 |  chip 1 |  chip 2 |  chip 3 |
    |=--------+---------+---------+---------++---------+---------+---------+--------=|
    |    1    |         |         |         ||         |         |    1    |         |    //cfg_read_odt_chip[0] = 4'b0100; //chip[3] -> chip[0]
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |    1    |         |         ||         |         |         |    1    |    //cfg_read_odt_chip[1] = 4'b1000; //chip[3] -> chip[0]
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |    1    |         ||    1    |         |         |         |    //cfg_read_odt_chip[2] = 4'b0001; //chip[3] -> chip[0]
    +---------+---------+---------+---------++---------+---------+---------+---------+
    |         |         |         |    1    ||         |    1    |         |         |    //cfg_read_odt_chip[3] = 4'b0010; //chip[3] -> chip[0]
    '---------+---------+---------+---------++---------+---------+---------+---------'
    */
    
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
    
    //Unpack read/write_odt_chip array into per chip array
    
    generate
    genvar a;
    begin : unpack_odt_config
        for (a=0; a<CFG_MEM_IF_CHIP; a=a+1)
        begin : unpack_odt_config_per_chip
            assign write_odt_chip[a] = cfg_write_odt_chip [(a*CFG_MEM_IF_ODT_WIDTH)+CFG_MEM_IF_ODT_WIDTH-1:a*CFG_MEM_IF_ODT_WIDTH];
            assign read_odt_chip[a]  = cfg_read_odt_chip  [(a*CFG_MEM_IF_ODT_WIDTH)+CFG_MEM_IF_ODT_WIDTH-1:a*CFG_MEM_IF_ODT_WIDTH];
        end
    end
    endgenerate
    
    always @(*)
    begin
        int_write_odt_chip = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
        int_read_odt_chip = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
        for (i=0; i<CFG_MEM_IF_CHIP; i=i+1)
        begin
            if (bg_to_chip[i])
            begin
                int_write_odt_chip = write_odt_chip[i];
                int_read_odt_chip = read_odt_chip[i];
            end
        end
    end
    
    //=================================================================================================//
    //        Instantiate DDR2 ODT generation Block                                                    //
    //=================================================================================================//
    
    generate
        genvar b;
        for (b=0; b<CFG_MEM_IF_ODT_WIDTH; b=b+1)
        begin : ddr2_odt_gen
            alt_mem_ddrx_ddr2_odt_gen
            # (
                .CFG_DWIDTH_RATIO           (CFG_DWIDTH_RATIO),
                .CFG_PORT_WIDTH_ADD_LAT     (CFG_PORT_WIDTH_ADD_LAT),
                .CFG_PORT_WIDTH_OUTPUT_REGD (CFG_PORT_WIDTH_OUTPUT_REGD),
                .CFG_PORT_WIDTH_TCL         (CFG_PORT_WIDTH_TCL)
            )
            alt_mem_ddrx_ddr2_odt_gen_inst
            (
                .ctl_clk                    (ctl_clk),
                .ctl_reset_n                (ctl_reset_n),
                .cfg_tcl                    (cfg_tcl),
                .cfg_add_lat                (cfg_add_lat),
                .cfg_burst_length           (cfg_burst_length),
                .cfg_output_regd            (cfg_output_regd),
                .bg_do_write                (bg_do_write & int_write_odt_chip[b]),
                .bg_do_read                 (bg_do_read & int_read_odt_chip[b]),
                .int_odt_l                  (ddr2_odt_l[b]),
                .int_odt_h                  (ddr2_odt_h[b])
            );
        end
    endgenerate
    
    //=================================================================================================//
    //        Instantiate DDR3 ODT generation Block                                                    //
    //=================================================================================================//
    
    generate
        genvar c; 
        for (c=0; c<CFG_MEM_IF_ODT_WIDTH; c=c+1)
        begin : ddr3_odt_gen
            alt_mem_ddrx_ddr3_odt_gen
            # (
                .CFG_DWIDTH_RATIO           (CFG_DWIDTH_RATIO),
                .CFG_PORT_WIDTH_OUTPUT_REGD (CFG_PORT_WIDTH_OUTPUT_REGD),
                .CFG_PORT_WIDTH_TCL         (CFG_PORT_WIDTH_TCL),
                .CFG_PORT_WIDTH_CAS_WR_LAT  (CFG_PORT_WIDTH_CAS_WR_LAT)
            )
            alt_mem_ddrx_ddr3_odt_gen_inst
            (
                .ctl_clk                    (ctl_clk),
                .ctl_reset_n                (ctl_reset_n),
                .cfg_tcl                    (cfg_tcl),
                .cfg_cas_wr_lat             (cfg_cas_wr_lat),
                .cfg_output_regd            (cfg_output_regd),
                .bg_do_write                (bg_do_write & int_write_odt_chip[c]),
                .bg_do_read                 (bg_do_read & int_read_odt_chip[c]),
                .bg_do_burst_chop           (bg_do_burst_chop),
                .int_odt_l                  (ddr3_odt_l[c]),
                .int_odt_h                  (ddr3_odt_h[c]),
                .int_odt_i_1                (ddr3_odt_i_1[c]),
                .int_odt_i_2                (ddr3_odt_i_2[c])
            );
        end
    endgenerate
    
    //=================================================================================================//
    //        ODT Output generation based on memory type and ODT feature turned ON or not              //
    //=================================================================================================//
    
    always @(*)
    begin
        if (cfg_type == `MMR_TYPE_DDR2)
        begin
            int_odt_l   = ddr2_odt_l;
            int_odt_h   = ddr2_odt_h;
            int_odt_i_1 = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
            int_odt_i_2 = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
        end
        else if (cfg_type == `MMR_TYPE_DDR3)
        begin
            int_odt_l   = ddr3_odt_l;
            int_odt_h   = ddr3_odt_h;
            int_odt_i_1 = ddr3_odt_i_1;
            int_odt_i_2 = ddr3_odt_i_2;
        end
        else
        begin
            int_odt_l   = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
            int_odt_h   = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
            int_odt_i_1 = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
            int_odt_i_2 = {(CFG_MEM_IF_ODT_WIDTH){1'b0}};
        end
    end
    
    generate
        if (CFG_ODT_ENABLED == 1)
        begin
            if (CFG_DWIDTH_RATIO == 2) // quarter rate
                assign afi_odt = int_odt_l;
            else if (CFG_DWIDTH_RATIO == 4) // half rate
                assign afi_odt = {int_odt_h,int_odt_l};
            else if (CFG_DWIDTH_RATIO == 8) // quarter rate
                assign afi_odt = {int_odt_h,int_odt_i_2, int_odt_i_1, int_odt_l};
        end
        else
            assign afi_odt = {(CFG_MEM_IF_ODT_WIDTH * (CFG_DWIDTH_RATIO/2)){1'b0}};
    endgenerate

endmodule
