//------------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from Altera Corporation.
//
// Legal Notice: (C)2010 Altera Corporation. All rights reserved.  Your
// use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any
// output files any of the foregoing (including device programming or
// simulation files), and any associated documentation or information are
// expressly subject to the terms and conditions of the Altera Program
// License Subscription Agreement or other applicable license agreement,
// including, without limitation, that your use is for the sole purpose
// of programming logic devices manufactured by Altera and sold by Altera
// or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
// The entire notice above must be reproduced on all authorized copies and any
// such reproduction must be pursuant to a licensing agreement from Altera.
//
// Title        : Example top level testbench for ddr3_int DDR/2/3 SDRAM High Performance Controller
// Project      : DDR/2/3 SDRAM High Performance Controller
//
// File         : ddr3_int_example_top_tb.v
//
// Revision     : V11.0
//
// Abstract:
// Automatically generated testbench for the example top level design to allow
// functional and timing simulation.
//
//------------------------------------------------------------------------------
//
// *************** This is a MegaWizard generated file ****************
//
// If you need to edit this file make sure the edits are not inside any 'MEGAWIZARD'
// text insertion areas.
// (between "<< START MEGAWIZARD INSERT" and "<< END MEGAWIZARD INSERT" comments)
//
// Any edits inside these delimiters will be overwritten by the megawizard if you
// re-run it.
//
// If you really need to make changes inside these delimiters then delete
// both 'START' and 'END' delimiters.  This will stop the megawizard updating this
// section again.
//
//----------------------------------------------------------------------------------
// << START MEGAWIZARD INSERT PARAMETER_LIST
// Parameters:
//
// Device Family                      : arria ii gx
// local Interface Data Width         : 256
// MEM_CHIPSELS                       : 1
// MEM_CS_PER_RANK                    : 1
// MEM_BANK_BITS                      : 3
// MEM_ROW_BITS                       : 13
// MEM_COL_BITS                       : 10
// LOCAL_DATA_BITS                    : 256
// NUM_CLOCK_PAIRS                    : 1
// CLOCK_TICK_IN_PS                   : 3333
// REGISTERED_DIMM                    : false
// TINIT_CLOCKS                       : 75008
// Data_Width_Ratio                   : 4
// << END MEGAWIZARD INSERT PARAMETER_LIST
//----------------------------------------------------------------------------------
// << MEGAWIZARD PARSE FILE DDR11.0


`timescale 1 ps/1 ps



// << START MEGAWIZARD INSERT MODULE
module ddr3_int_example_top_tb ();
// << END MEGAWIZARD INSERT MODULE

    // << START MEGAWIZARD INSERT PARAMS
    parameter gMEM_CHIPSELS     = 1;
    parameter gMEM_CS_PER_RANK  = 1;
    parameter gMEM_NUM_RANKS    = 1 / 1;
    parameter gMEM_BANK_BITS    = 3;
    parameter gMEM_ROW_BITS     = 13;
    parameter gMEM_COL_BITS     = 10;
    parameter gMEM_ADDR_BITS    = 13;
    parameter gMEM_DQ_PER_DQS   = 8;
    parameter DM_DQS_WIDTH	= 8;
    parameter gLOCAL_DATA_BITS  = 256;
    parameter gLOCAL_IF_DWIDTH_AFTER_ECC  = 256;
    parameter gNUM_CLOCK_PAIRS  = 1;
    parameter RTL_ROUNDTRIP_CLOCKS  = 0.0;
    parameter CLOCK_TICK_IN_PS  = 3333;
    parameter REGISTERED_DIMM   = 1'b0;
    parameter BOARD_DQS_DELAY   = 0;
    parameter BOARD_CLK_DELAY   = 0;
    parameter DWIDTH_RATIO      = 4;
    parameter TINIT_CLOCKS  = 75008;
    parameter REF_CLOCK_TICK_IN_PS  = 40000; 
    
    // Parameters below are for generic memory model
    parameter gMEM_TQHS_PS	    =	300;
    parameter gMEM_TAC_PS	    =	400;
    parameter gMEM_TDQSQ_PS 	=	125;
    parameter gMEM_IF_TRCD_NS	=	13.5;
    parameter gMEM_IF_TWTR_CK	=	4;
    parameter gMEM_TDSS_CK	    =	0.2;
    parameter gMEM_IF_TRFC_NS   =   110.0;
    parameter gMEM_IF_TRP_NS    =   13.5;
        
    parameter gMEM_IF_TRCD_PS	= 	gMEM_IF_TRCD_NS * 1000.0;
    parameter gMEM_IF_TWTR_PS	=	gMEM_IF_TWTR_CK * CLOCK_TICK_IN_PS;
    parameter gMEM_IF_TRFC_PS   =   gMEM_IF_TRFC_NS * 1000.0;
    parameter gMEM_IF_TRP_PS    =   gMEM_IF_TRP_NS * 1000.0;
    parameter CLOCK_TICK_IN_NS  =   CLOCK_TICK_IN_PS / 1000.0;
    parameter gMEM_TDQSQ_NS	    =	gMEM_TDQSQ_PS / 1000.0;
    parameter gMEM_TDSS_NS	    =	gMEM_TDSS_CK * CLOCK_TICK_IN_NS;
    
    
    // << END MEGAWIZARD INSERT PARAMS
    
    // set to zero for Gatelevel
    parameter RTL_DELAYS = 1;
    parameter USE_GENERIC_MEMORY_MODEL  = 1'b0;

    // The round trip delay is now modeled inside the datapath (<your core name>_auk_ddr_dqs_group.v/vhd) for RTL simulation.
    parameter D90_DEG_DELAY = 0; //RTL only

    parameter GATE_BOARD_DQS_DELAY = BOARD_DQS_DELAY * (RTL_DELAYS ? 0 : 1); // Gate level timing only
    parameter GATE_BOARD_CLK_DELAY = BOARD_CLK_DELAY * (RTL_DELAYS ? 0 : 1); // Gate level timing only
 
    // Below 5 lines for SPR272543: 
    // Testbench workaround for tests with "dedicated memory clock phase shift" failing, 
    // because dqs delay isnt' being modelled in simulations
    parameter gMEM_CLK_PHASE_EN = "false";
    parameter real gMEM_CLK_PHASE = 0;
    parameter real MEM_CLK_RATIO = ((360.0-gMEM_CLK_PHASE)/360.0);
    parameter MEM_CLK_DELAY = MEM_CLK_RATIO*CLOCK_TICK_IN_PS * ((gMEM_CLK_PHASE_EN=="true") ? 1 : 0);
    wire clk_to_ram0, clk_to_ram1, clk_to_ram2;
  
    wire cmd_bus_watcher_enabled;
    reg clk;
    reg clk_n;
    reg reset_n;
    wire mem_reset_n;
    wire[gMEM_ADDR_BITS - 1:0] a;
    wire[gMEM_BANK_BITS - 1:0] ba;
    wire[gMEM_CHIPSELS - 1:0] cs_n;
    wire[gMEM_NUM_RANKS - 1:0] cke;
    wire[gMEM_NUM_RANKS - 1:0] odt;       //DDR2 only
    wire ras_n;
    wire cas_n;
    wire we_n;
    wire[gLOCAL_DATA_BITS / DWIDTH_RATIO / gMEM_DQ_PER_DQS - 1:0] dm;
    //wire[gLOCAL_DATA_BITS / DWIDTH_RATIO / gMEM_DQ_PER_DQS - 1:0] dqs;
    //wire[gLOCAL_DATA_BITS / DWIDTH_RATIO / gMEM_DQ_PER_DQS - 1:0] dqs_n;

    //wire stratix_dqs_ref_clk;   // only used on stratix to provide external dll reference clock
    wire[gNUM_CLOCK_PAIRS - 1:0] clk_to_sdram;
    wire[gNUM_CLOCK_PAIRS - 1:0] clk_to_sdram_n;
    wire #(GATE_BOARD_CLK_DELAY * 1) clk_to_ram;
    wire clk_to_ram_n;
    wire[gMEM_ROW_BITS - 1:0] #(GATE_BOARD_CLK_DELAY * 1 + 1) a_delayed;
    wire[gMEM_BANK_BITS - 1:0] #(GATE_BOARD_CLK_DELAY * 1 + 1) ba_delayed;
    wire[gMEM_NUM_RANKS - 1:0] #(GATE_BOARD_CLK_DELAY * 1 + 1) cke_delayed;
    wire[gMEM_NUM_RANKS - 1:0] #(GATE_BOARD_CLK_DELAY * 1 + 1) odt_delayed;  //DDR2 only
    wire[gMEM_NUM_RANKS - 1:0] #(GATE_BOARD_CLK_DELAY * 1 + 1) cs_n_delayed;
    wire #(GATE_BOARD_CLK_DELAY * 1 + 1) ras_n_delayed;
    wire #(GATE_BOARD_CLK_DELAY * 1 + 1) cas_n_delayed;
    wire #(GATE_BOARD_CLK_DELAY * 1 + 1) we_n_delayed;
    wire[gLOCAL_DATA_BITS / DWIDTH_RATIO / gMEM_DQ_PER_DQS - 1:0] dm_delayed;
    
    // DDR3 parity only
    wire ac_parity;
    wire mem_err_out_n;
    assign mem_err_out_n = 1'b1;

    // pulldown (dm);
    assign (weak1, weak0) dm = 0;

    tri [gLOCAL_DATA_BITS / DWIDTH_RATIO - 1:0] mem_dq = 100'bz;
    tri [gLOCAL_DATA_BITS / DWIDTH_RATIO / gMEM_DQ_PER_DQS - 1:0] mem_dqs = 100'bz;
    tri [gLOCAL_DATA_BITS / DWIDTH_RATIO / gMEM_DQ_PER_DQS - 1:0] mem_dqs_n = 100'bz;
	assign (weak1, weak0) mem_dq = 0;
	assign (weak1, weak0) mem_dqs = 0;
	assign (weak1, weak0) mem_dqs_n = 1;

    wire [gMEM_BANK_BITS - 1:0] zero_one; //"01";
    assign zero_one = 1;
    
    wire test_complete;
    wire [7:0] test_status;
    // counter to count the number of sucessful read and write loops
    integer test_complete_count;
    wire pnf;
    wire [gLOCAL_IF_DWIDTH_AFTER_ECC / 8 - 1:0] pnf_per_byte;


    assign cmd_bus_watcher_enabled = 1'b0;

    // Below 5 lines for SPR272543: 
    // Testbench workaround for tests with "dedicated memory clock phase shift" failing, 
    // because dqs delay isnt' being modelled in simulations
    assign #(MEM_CLK_DELAY/4.0) clk_to_ram2 = clk_to_sdram[0];
    assign #(MEM_CLK_DELAY/4.0) clk_to_ram1 = clk_to_ram2;
    assign #(MEM_CLK_DELAY/4.0) clk_to_ram0 = clk_to_ram1;
    assign #((MEM_CLK_DELAY/4.0)) clk_to_ram = clk_to_ram0;
    assign clk_to_ram_n = ~clk_to_ram ; // mem model ignores clk_n ?

   	// ddr sdram interface

    // << START MEGAWIZARD INSERT ENTITY
    ddr3_int_example_top dut (
    // << END MEGAWIZARD INSERT ENTITY
        .clock_source(clk),
        .global_reset_n(reset_n),

        // << START MEGAWIZARD INSERT PORT_MAP
        .mem_clk(clk_to_sdram),
        .mem_clk_n(clk_to_sdram_n),
        .mem_odt(odt),
        .mem_dqsn(mem_dqs_n),
        .mem_reset_n(mem_reset_n),
        .mem_cke(cke),
        .mem_cs_n(cs_n),
        .mem_ras_n(ras_n),
        .mem_cas_n(cas_n),
        .mem_we_n(we_n),
        .mem_ba(ba),
        .mem_addr(a),
        .mem_dq(mem_dq),
        .mem_dqs(mem_dqs),
        .mem_dm(dm),

        // << END MEGAWIZARD INSERT PORT_MAP

        .test_complete(test_complete),
        .test_status(test_status),
        .pnf_per_byte(pnf_per_byte),
        .pnf(pnf)
    );


    // << START MEGAWIZARD INSERT MEMORY_ARRAY
    // This will need updating to match the memory models you are using.

    // Instantiate a generated DDR memory model to match the datawidth & chipselect requirements

    ddr3_int_mem_model mem (
    	.mem_rst_n   (mem_reset_n),
    	.mem_dq      (mem_dq),
        .mem_dqs     (mem_dqs),
    	.mem_dqs_n   (mem_dqs_n),
        .mem_addr    (a_delayed),
        .mem_ba      (ba_delayed),
        .mem_clk     (clk_to_ram),
        .mem_clk_n   (clk_to_ram_n),
        .mem_cke     (cke_delayed),
        .mem_cs_n    (cs_n_delayed),
        .mem_ras_n   (ras_n_delayed),
        .mem_cas_n   (cas_n_delayed),
        .mem_we_n    (we_n_delayed),
        .mem_dm      (dm_delayed),
        .mem_odt     (odt_delayed)
    );

    // << END MEGAWIZARD INSERT MEMORY_ARRAY


    always
    begin
        clk <= 1'b0 ;
        clk_n <= 1'b1 ;
        while (1'b1)
        begin
            #((REF_CLOCK_TICK_IN_PS / 2) * 1);
            clk <= ~clk ;
            clk_n <= ~clk_n ;
        end
    end


    initial
    begin
        reset_n <= 1'b0 ;
        @(clk);
        @(clk);
        @(clk);
        @(clk);
        @(clk);
        @(clk);
        reset_n <= 1'b1 ;
    end

    // control and data lines = 3 inches
    assign a_delayed = a[gMEM_ROW_BITS - 1:0] ;
    assign ba_delayed = ba ;
    assign cke_delayed = cke ;
    assign odt_delayed = odt ;
    assign cs_n_delayed = cs_n ;
    assign ras_n_delayed = ras_n ;
    assign cas_n_delayed = cas_n ;
    assign we_n_delayed = we_n ;
    assign dm_delayed = dm ;

    // ---------------------------------------------------------------
    initial
    begin : endit
        integer count;
        reg ln;
        count = 0;

        // Stop simulation after test_complete or TINIT + 600000 clocks
        while ((count < (TINIT_CLOCKS + 600000)) & (test_complete !== 1))
        begin
            count = count + 1;
            @(negedge clk_to_sdram[0]);
        end
        if (test_complete === 1)
        begin
            if (pnf)
            begin
                $write($time);
                $write("          --- SIMULATION PASSED --- ");
                $stop;
            end
            else
            begin
                $write($time);
                $write("          --- SIMULATION FAILED --- ");
                $stop;
            end
        end
        else
        begin
            $write($time);
            $write("          --- SIMULATION FAILED, DID NOT COMPLETE --- ");
            $stop;
        end
    end

    always @(clk_to_sdram[0] or reset_n)
    begin
        if (!reset_n)
        begin
            test_complete_count <= 0 ;
        end
        else if ((clk_to_sdram[0]))
        begin
            if (test_complete)
            begin
                test_complete_count <= test_complete_count + 1 ;
            end
        end
    end



    reg[2:0] cmd_bus;


    //***********************************************************
    // Watch the SDRAM command bus
    always @(clk_to_ram)
    begin
        if (clk_to_ram)
        begin
            if (1'b1)
            begin
                cmd_bus = {ras_n_delayed, cas_n_delayed, we_n_delayed};
                case (cmd_bus)
                    3'b000 :
                        begin
                            // LMR command
                            $write($time);
                            if (ba_delayed == zero_one)
                            begin
                                $write("          ELMR     settings = ");
                                if (!(a_delayed[0]))
                                begin
                                    $write("DLL enable");
                                end
                            end
                            else
                            begin
       							$write("          LMR      settings = ");
       			
            			    	case (a_delayed[1:0])
           	        				3'b00 : $write("BL = 8,");
                			   		3'b01 : $write("BL = On The Fly,");
             			      		3'b10 : $write("BL = 4,");
              			     		default : $write("BL = ??,");
             			       	endcase
                   
             				   	case (a_delayed[6:4])
            		   	    		3'b001 : $write(" CL = 5.0,");
                   					3'b010 : $write(" CL = 6.0,");
               		   		 		3'b011 : $write(" CL = 7.0,");
               		   		 		3'b100 : $write(" CL = 8.0,");
              		   		  		3'b101 : $write(" CL = 9.0,");
               		    			3'b110 : $write(" CL = 10.0,");
              		   		  		default : $write(" CL = ??,");
            		    		endcase
                
               			 		if ((a_delayed[8])) $write(" DLL reset");    	
                               
                            end
                            $write("\n");
                        end
                    3'b001 :
                        begin
                            // ARF command
                            $write($time);
                            $write("          ARF\n");
                        end
                    3'b010 :
                        begin
                            // PCH command
                            $write($time);
                            $write("          PCH");
                            if ((a_delayed[10]))
                            begin
                                $write(" all banks \n");
                            end
                            else
                            begin
                                $write(" bank ");
                                $write("%H\n", ba_delayed);
                            end
                        end
                    3'b011 :
                        begin
                            // ACT command
                            $write($time);
                            $write("          ACT     row address ");
                            $write("%H", a_delayed);
                            $write(" bank ");
                            $write("%H\n", ba_delayed);
                        end
                   3'b100 :
                        begin
                            // WR command
                            $write($time);
                            $write("          WR to   col address ");
                            $write("%H", a_delayed);
                            $write(" bank ");
                            $write("%H\n", ba_delayed);
                        end
                   3'b101 :
                        begin
                            // RD command
                            $write($time);
                            $write("          RD from col address ");
                            $write("%H", a_delayed);
                            $write(" bank ");
                            $write("%H\n", ba_delayed);
                        end
                   3'b110 :
                        begin
                            // BT command
                            $write($time);
                            $write("          BT ");
                        end
                   3'b111 :
                        begin
                            // NOP command
                        end
                endcase
            end
            else
            begin
            end // if enabled
        end
    end

endmodule

