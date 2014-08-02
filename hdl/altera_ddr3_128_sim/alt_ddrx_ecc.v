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
// Title         : DDR controller Error Correction Code
//
// File          : alt_ddrx_ecc.v
//
// Abstract      : Error correction code block
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_ecc #
    ( parameter
        LOCAL_DATA_WIDTH        = 128,
        DWIDTH_RATIO            = 2,
        CTL_ECC_ENABLED         = 0,
        CTL_ECC_RMW_ENABLED     = 0,
        CTL_ECC_CSR_ENABLED     = 0,
        CTL_ECC_MULTIPLES_40_72 = 1,
        CTL_ECC_RDATA_PATH_REGD = 0,            // only in effect when ECC is enable
        FAMILY                  = "Stratix",
        MEMORY_BURSTLENGTH      = 8,
        
        MEM_IF_CS_WIDTH         = 4,
        MEM_IF_CHIP_BITS        = 2,
        MEM_IF_ROW_WIDTH        = 13,
        MEM_IF_COL_WIDTH        = 10,
        MEM_IF_BA_WIDTH         = 3,
        MEM_IF_DQ_WIDTH         = 64
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        // input from state machine
        do_read,                        // need this to act as wr_req to rd_addr_fifo
        do_write,
        do_ecc,                         // need state machine to indicate that it is currently in ECC state
        do_partial,                     // need state machine to indicate that it is currently in Partial Write state
        do_burst_chop,
        rdwr_data_valid,                // we need to know the size (1 - 4) of current read request
        ecc_fetch_error_addr,           // state machine will need to issue this to ecc block in order to get error address
        to_chip,
        to_bank_addr,
        to_row_addr,
        to_col_addr,
        
        // input from afi-phy
        afi_rdata,
        afi_rdata_valid,
        
        // input from afi block
        ecc_wdata_fifo_read,
        
        // input from input if
        write_req_to_wfifo,
        be_to_wfifo,
        
        // input from wdata fifo
        wdata_fifo_be,                  // keep this future usage
        wdata_fifo_wdata,
        
        // input from csr
        ecc_enable,
        ecc_enable_auto_corr,
        ecc_gen_sbe,
        ecc_gen_dbe,
        ecc_enable_intr,
        ecc_mask_sbe_intr,
        ecc_mask_dbe_intr,
        ecc_clear,
        
        // output to state machine
        ecc_single_bit_error,
        ecc_error_chip_addr,
        ecc_error_bank_addr,
        ecc_error_row_addr,
        ecc_error_col_addr,
        rmw_data_ready,
        wdata_is_partial,
        
        // output
        ecc_interrupt,
        ecc_rdata_valid,
        ecc_rdata_error,
        ecc_rdata,
        ecc_be,
        ecc_wdata,
        
        wdata_fifo_read,
        
        // output to csr
        ecc_sbe_error,
        ecc_dbe_error,
        ecc_sbe_count,
        ecc_dbe_count,
        ecc_error_addr
    );

localparam LOCAL_BE_WIDTH  = LOCAL_DATA_WIDTH / 8;
localparam ECC_DATA_WIDTH  = MEM_IF_DQ_WIDTH * DWIDTH_RATIO;
localparam ECC_BE_WIDTH    = ECC_DATA_WIDTH / 8;
localparam ECC_CODE_WIDTH  = 8; // set to 8 because of 72 bit memory interface

localparam NUMBER_OF_INSTANCE = DWIDTH_RATIO * CTL_ECC_MULTIPLES_40_72; // indicate how many instances of encoder/decoder required

localparam LOCAL_BE_PER_WORD_WIDTH   = LOCAL_BE_WIDTH   / (NUMBER_OF_INSTANCE);
localparam LOCAL_DATA_PER_WORD_WIDTH = LOCAL_DATA_WIDTH / (NUMBER_OF_INSTANCE);
localparam ECC_DATA_PER_WORD_WIDTH   = ECC_DATA_WIDTH   / (NUMBER_OF_INSTANCE);
localparam ECC_BE_PER_WORD_WIDTH     = ECC_BE_WIDTH     / (NUMBER_OF_INSTANCE);

localparam ADDR_FIFO_WIDTH = MEM_IF_CHIP_BITS + MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH;

localparam RDWR_DATA_VALID_MAX_LENGTH = MEMORY_BURSTLENGTH / DWIDTH_RATIO;

input ctl_clk;
input ctl_reset_n;

input do_read;
input do_write;
input do_ecc;
input do_partial;
input do_burst_chop;
input rdwr_data_valid;
input ecc_fetch_error_addr;
input [MEM_IF_CS_WIDTH  - 1 : 0] to_chip;
input [MEM_IF_BA_WIDTH  - 1 : 0] to_bank_addr;
input [MEM_IF_ROW_WIDTH - 1 : 0] to_row_addr;
input [MEM_IF_COL_WIDTH - 1 : 0] to_col_addr;

input [ECC_DATA_WIDTH   - 1 : 0] afi_rdata;
input [DWIDTH_RATIO / 2 - 1 : 0] afi_rdata_valid;

input ecc_wdata_fifo_read;

input write_req_to_wfifo;
input [LOCAL_BE_WIDTH - 1 : 0] be_to_wfifo;

input [LOCAL_BE_WIDTH - 1 : 0]   wdata_fifo_be;
input [LOCAL_DATA_WIDTH - 1 : 0] wdata_fifo_wdata;

input ecc_enable;
input ecc_enable_auto_corr;
input ecc_gen_sbe;
input ecc_gen_dbe;
input ecc_enable_intr;
input ecc_mask_sbe_intr;
input ecc_mask_dbe_intr;
input ecc_clear;

output rmw_data_ready;
output ecc_single_bit_error;
output wdata_is_partial;
output [MEM_IF_CHIP_BITS - 1 : 0] ecc_error_chip_addr;
output [MEM_IF_BA_WIDTH  - 1 : 0] ecc_error_bank_addr;
output [MEM_IF_ROW_WIDTH - 1 : 0] ecc_error_row_addr;
output [MEM_IF_COL_WIDTH - 1 : 0] ecc_error_col_addr;

output ecc_interrupt;
output ecc_rdata_error;
output [DWIDTH_RATIO / 2 - 1 : 0] ecc_rdata_valid;
output [LOCAL_DATA_WIDTH - 1 : 0] ecc_rdata;
output [ECC_BE_WIDTH     - 1 : 0] ecc_be;
output [ECC_DATA_WIDTH   - 1 : 0] ecc_wdata;

output wdata_fifo_read;

output          ecc_sbe_error;
output          ecc_dbe_error;
output [7  : 0] ecc_sbe_count;
output [7  : 0] ecc_dbe_count;
output [31 : 0] ecc_error_addr;

wire rmw_data_ready;
wire ecc_single_bit_error;
wire wdata_is_partial;
wire [MEM_IF_CHIP_BITS - 1 : 0] ecc_error_chip_addr;
wire [MEM_IF_BA_WIDTH  - 1 : 0] ecc_error_bank_addr;
wire [MEM_IF_ROW_WIDTH - 1 : 0] ecc_error_row_addr;
wire [MEM_IF_COL_WIDTH - 1 : 0] ecc_error_col_addr;

wire ecc_interrupt;
wire ecc_rdata_error;
wire [DWIDTH_RATIO / 2 - 1 : 0] ecc_rdata_valid;
wire [LOCAL_DATA_WIDTH - 1 : 0] ecc_rdata;
wire [ECC_BE_WIDTH     - 1 : 0] ecc_be;
wire [ECC_DATA_WIDTH   - 1 : 0] ecc_wdata;

wire wdata_fifo_read;

wire          ecc_sbe_error;
wire          ecc_dbe_error;
wire [7  : 0] ecc_sbe_count;
wire [7  : 0] ecc_dbe_count;
wire [31 : 0] ecc_error_addr;

generate
    if (!CTL_ECC_ENABLED) // when ECC is not enabled
    begin
        assign rmw_data_ready       = 0;
        assign ecc_single_bit_error = 0;
        assign ecc_error_chip_addr  = 0;
        assign ecc_error_bank_addr  = 0;
        assign ecc_error_row_addr   = 0;
        assign ecc_error_col_addr   = 0;
        assign wdata_is_partial     = 0;
        
        assign ecc_interrupt        = 0;
        assign ecc_rdata_valid      = afi_rdata_valid;
        assign ecc_rdata_error      = 0;
        assign ecc_rdata            = afi_rdata;
        assign ecc_be               = wdata_fifo_be;
        assign ecc_wdata            = wdata_fifo_wdata;
        
        assign wdata_fifo_read      = ecc_wdata_fifo_read;
        
        assign ecc_sbe_error        = 0;
        assign ecc_dbe_error        = 0;
        assign ecc_sbe_count        = 0;
        assign ecc_dbe_count        = 0;
        assign ecc_error_addr       = 0;
    end
    else // when ECC is enabled
    begin
        // ECC coding start
        
        // read address fifo
        reg do_read_r1;
        reg do_read_r2;
        reg do_read_r3;
        reg do_burst_chop_r1;
        reg do_burst_chop_r2;
        reg do_burst_chop_r3;
        reg read_addr_fifo_rd;
        reg read_addr_fifo_wr;
        reg [ADDR_FIFO_WIDTH : 0] read_addr_fifo_wr_data;
        reg [ADDR_FIFO_WIDTH : 0] to_addr_r1;
        reg [ADDR_FIFO_WIDTH : 0] to_addr_r2;
        reg [ADDR_FIFO_WIDTH : 0] to_addr_r3;
        reg [2 : 0]               read_size_count;
        reg [2 : 0]               rdata_valid_count;
        
        wire scfifo_reset;
        
        wire read_addr_fifo_full;
        wire read_addr_fifo_empty;
        wire [ADDR_FIFO_WIDTH + 3 : 0] read_addr_fifo_rd_data; // add 1 bit for ecc and 3 bit for read size count
        
        // error address fifo
        reg  error_addr_fifo_wr;
        
        wire error_addr_fifo_rd;
        wire error_addr_fifo_full;
        wire error_addr_fifo_empty;
        wire [ADDR_FIFO_WIDTH - 1 : 0] error_addr_fifo_rd_data;
        wire [ADDR_FIFO_WIDTH - 1 : 0] error_addr_fifo_wr_data;
        
        // rmw data fifo
        reg  [LOCAL_DATA_WIDTH - 1 : 0] ecc_rdata_r1;
        
        reg  int_rmw_data_ready;
        reg  rmw_data_fifo_wr;
        reg  rmw_data_fifo_rd;
        reg  [NUMBER_OF_INSTANCE - 1 : 0]                  rmw_data_double_bit_error_r1;
        reg  [ECC_CODE_WIDTH * NUMBER_OF_INSTANCE - 1 : 0] rmw_data_ecc_code_r1;
        
        wire rmw_data_fifo_full;
        wire rmw_data_fifo_empty;
        wire [ECC_DATA_WIDTH + NUMBER_OF_INSTANCE - 1 : 0] rmw_data_fifo_rd_data;
        wire [ECC_DATA_WIDTH + NUMBER_OF_INSTANCE - 1 : 0] rmw_data_fifo_wr_data;
        wire [NUMBER_OF_INSTANCE                  - 1 : 0] rmw_data_double_bit_error;
        wire [ECC_CODE_WIDTH * NUMBER_OF_INSTANCE - 1 : 0] rmw_data_ecc_code;
        wire [NUMBER_OF_INSTANCE                  - 1 : 0] rmw_data_be;
        wire [LOCAL_DATA_WIDTH                    - 1 : 0] rmw_data;
        
        // encoder and decoder
        reg  [NUMBER_OF_INSTANCE - 1 : 0] int_single_bit_error;
        reg  [NUMBER_OF_INSTANCE - 1 : 0] int_double_bit_error;
        
        // others
        reg ecc_wdata_fifo_read_r1;
        reg ecc_wdata_fifo_read_r2;
        reg ecc_wdata_fifo_read_r3;
        
        reg int_afi_rdata_valid_r1; // we only require one bit
        
        reg afi_rdata_single_bit_error;
        
        reg [MEM_IF_CHIP_BITS - 1 : 0] to_chip_addr;
        
        reg int_ecc_rdata_valid;
        
        reg int_wdata_fifo_read;
        
        reg doing_partial_read;
        reg doing_partial_write;
        reg doing_partial_write_r1;
        reg doing_partial_write_r2;
        
        reg doing_ecc_read;
        reg doing_ecc_write;
        reg doing_ecc_write_r1;
        reg doing_ecc_write_r2;
        
        reg [LOCAL_DATA_WIDTH - 1 : 0] int_ecc_corrected_wdata;
        
        reg int_partial_write;
        
        reg int_ecc_interrupt;
        
        wire [NUMBER_OF_INSTANCE - 1 : 0] decoder_err_detected;
        wire [NUMBER_OF_INSTANCE - 1 : 0] decoder_err_corrected;
        wire [NUMBER_OF_INSTANCE - 1 : 0] decoder_err_fatal;
        
        wire zero = 1'b0;
        
        assign wdata_fifo_read = int_wdata_fifo_read;
        assign rmw_data_ready  = int_rmw_data_ready;
        assign ecc_rdata_valid = {{((DWIDTH_RATIO / 2) - 1){1'b0}}, int_ecc_rdata_valid};
        assign ecc_rdata_error = (ecc_enable) ? |decoder_err_fatal : 1'b0; // if any one of the decoder detects a fatal error, it means the current rdata has a double bit error (only when ecc is enabled)
        
        //assign wdata_is_partial = |int_partial_write;
        assign wdata_is_partial = int_partial_write;
        
        /*------------------------------------------------------------------------------
        
            AFI Read Data Path
        
        ------------------------------------------------------------------------------*/
        reg [ECC_DATA_WIDTH - 1 : 0] int_afi_rdata;
        reg [DWIDTH_RATIO/2 - 1 : 0] int_afi_rdata_valid;
        
        if (CTL_ECC_RDATA_PATH_REGD)
        begin
            // we will register read data path to achieve better fmax
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_afi_rdata       <= 0;
                    int_afi_rdata_valid <= 0;
                end
                else
                begin
                    int_afi_rdata       <= afi_rdata;
                    int_afi_rdata_valid <= afi_rdata_valid;
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                int_afi_rdata       = afi_rdata;
                int_afi_rdata_valid = afi_rdata_valid;
            end
        end
        
        /*------------------------------------------------------------------------------
        
            CSR Information
        
        ------------------------------------------------------------------------------*/
        reg          int_ecc_sbe_error;
        reg          int_ecc_dbe_error;
        reg [7  : 0] int_ecc_sbe_count;
        reg [7  : 0] int_ecc_dbe_count;
        reg [31 : 0] int_ecc_error_addr;
        
        if (!CTL_ECC_CSR_ENABLED) // if csr is disabled
        begin
            // assign csr information
            assign ecc_sbe_error  = 0;
            assign ecc_dbe_error  = 0;
            assign ecc_sbe_count  = 0;
            assign ecc_dbe_count  = 0;
            assign ecc_error_addr = 0;
        end
        else
        begin
            // assign csr information
            assign ecc_sbe_error  = int_ecc_sbe_error;
            assign ecc_dbe_error  = int_ecc_dbe_error;
            assign ecc_sbe_count  = int_ecc_sbe_count;
            assign ecc_dbe_count  = int_ecc_dbe_count;
            assign ecc_error_addr = int_ecc_error_addr;
            
            // assign csr sbe/dbe error
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_sbe_error <= 1'b0;
                    int_ecc_dbe_error <= 1'b0;
                end
                else
                begin
                    if (ecc_clear)
                        int_ecc_sbe_error <= 1'b0;
                    else if (|int_single_bit_error && int_afi_rdata_valid_r1)
                        int_ecc_sbe_error <= 1'b1;
                    
                    if (ecc_clear)
                        int_ecc_dbe_error <= 1'b0;
                    else if (|int_double_bit_error && int_afi_rdata_valid_r1)
                        int_ecc_dbe_error <= 1'b1;
                end
            end
            
            // there is a limitation to this logic, if there are 2 or more error in one afi read data, it will always be flagged as one
            // i think this is sufficient enough to keep track of ecc error counts
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_sbe_count <= 0;
                    int_ecc_dbe_count <= 0;
                end
                else
                begin
                    if (ecc_clear)
                        int_ecc_sbe_count <= 0;
                    else if (|int_single_bit_error && int_afi_rdata_valid_r1) // if there is an error
                        int_ecc_sbe_count <= int_ecc_sbe_count + 1;
                    
                    if (ecc_clear)
                        int_ecc_dbe_count <= 0;
                    else if (|int_double_bit_error && int_afi_rdata_valid_r1) // if there is an error
                        int_ecc_dbe_count <= int_ecc_dbe_count + 1;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_error_addr <= 0;
                end
                else
                begin
                    if (ecc_clear)
                        int_ecc_error_addr <= 0;
                    else if ((|int_single_bit_error || |int_double_bit_error) && int_afi_rdata_valid_r1) // when there is an ecc error
                        int_ecc_error_addr <= read_addr_fifo_rd_data [ADDR_FIFO_WIDTH - 1 : 0]; // output from read address fifo
                end
            end
        end
        
        /*------------------------------------------------------------------------------
        
            Encoder and Decoder Instantiation
        
        ------------------------------------------------------------------------------*/
        reg [1 : 0] bit_error;
        reg [ECC_DATA_WIDTH - 1 : 0] int_afi_rdata_r1;
        
        // bit error (2 bits) which will be used to generate sbe/dbe
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                bit_error <= 0;
            else
            begin
                if (ecc_gen_sbe)
                    bit_error <= 2'b01;
                else if (ecc_gen_dbe)
                    bit_error <= 2'b11;
                else
                    bit_error <= 2'b00;
            end
        end
        
        // register afi_rdata
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_afi_rdata_r1 <= 0;
            else
                int_afi_rdata_r1 <= int_afi_rdata;
        end
        
        genvar z;
        for (z = 0;z < NUMBER_OF_INSTANCE;z = z + 1)
        begin : encoder_instantiation
            wire [LOCAL_DATA_PER_WORD_WIDTH                - 1 : 0] int_wdata_fifo_wdata;
            wire [LOCAL_DATA_PER_WORD_WIDTH                - 1 : 0] int_rmw_wdata;
            wire [ECC_DATA_PER_WORD_WIDTH                  - 1 : 0] int_ecc_wdata;
            wire [ECC_DATA_PER_WORD_WIDTH                  - 1 : 0] int_ecc_wdata_rmw;
            wire [LOCAL_BE_PER_WORD_WIDTH                  - 1 : 0] int_wdata_fifo_be;
            wire [LOCAL_DATA_PER_WORD_WIDTH                - 1 : 0] int_ecc_rdata;
            
            reg  [ECC_BE_PER_WORD_WIDTH                    - 1 : 0] int_ecc_be;
            reg  [ECC_CODE_WIDTH                           - 1 : 0] altered_ecc_code;
            reg  [LOCAL_DATA_PER_WORD_WIDTH                - 1 : 0] altered_ecc_rdata;
            reg  [ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH - 1 : 0] altered_ecc_wdata;
            
            /*------------------------------------------------------------------------------
                Read Data
            ------------------------------------------------------------------------------*/
            // assign ecc read data
            assign ecc_rdata [(z + 1) * LOCAL_DATA_PER_WORD_WIDTH - 1 : z * LOCAL_DATA_PER_WORD_WIDTH] = altered_ecc_rdata;
            
            // select which read data to choose from, decoder or afi_rdata_r1
            always @ (*)
            begin
                if (ecc_enable)
                    altered_ecc_rdata = int_ecc_rdata;
                else
                    altered_ecc_rdata = int_afi_rdata_r1 [(z + 1) * ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH - 1 : z * ECC_DATA_PER_WORD_WIDTH];
            end
            
            /*------------------------------------------------------------------------------
                Write Data
            ------------------------------------------------------------------------------*/
            // assign ecc code part
            assign ecc_wdata [(z + 1) * ECC_DATA_PER_WORD_WIDTH - 1 : z * ECC_DATA_PER_WORD_WIDTH + LOCAL_DATA_PER_WORD_WIDTH] = altered_ecc_code;
            
            // assign only the data part excluding ecc codes
            assign ecc_wdata [(z + 1) * ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH - 1 : z * ECC_DATA_PER_WORD_WIDTH]            = altered_ecc_wdata;
            
            // assign ecc byte enable
            assign ecc_be    [(z + 1) * ECC_BE_PER_WORD_WIDTH - 1 : z * ECC_BE_PER_WORD_WIDTH]                                 = int_ecc_be;
            
            // XOR lower 2 bits to create sbe/dbe error
            // decide which data should be pass onto the output
            always @ (*)
            begin
                if (CTL_ECC_RMW_ENABLED && doing_ecc_write_r2)
                    altered_ecc_wdata = {int_ecc_wdata_rmw [ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH - 1 : 2], (bit_error [1] ^ int_ecc_wdata_rmw [1]), (bit_error [0] ^ int_ecc_wdata_rmw [0])};
                else if (doing_partial_write_r2)
                    altered_ecc_wdata = {int_ecc_wdata_rmw [ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH - 1 : 2], (bit_error [1] ^ int_ecc_wdata_rmw [1]), (bit_error [0] ^ int_ecc_wdata_rmw [0])};
                else
                    altered_ecc_wdata = {int_ecc_wdata [ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH - 1 : 2], (bit_error [1] ^ int_ecc_wdata [1]), (bit_error [0] ^ int_ecc_wdata [0])};
            end
            
            // select which ecc code should be pass onto the output
            // do not regenerate the ecc code if double bit error is detected
            // so that we can detect the error again when we read to that address
            always @ (*)
            begin
                if (CTL_ECC_RMW_ENABLED && doing_ecc_write_r2)
                begin
                    if (rmw_data_double_bit_error_r1 [z]) // it means double bit error
                        altered_ecc_code = rmw_data_ecc_code_r1 [(z + 1) * ECC_CODE_WIDTH - 1 : z * ECC_CODE_WIDTH];
                    else
                        altered_ecc_code = int_ecc_wdata_rmw [ECC_DATA_PER_WORD_WIDTH - 1 : LOCAL_DATA_PER_WORD_WIDTH];
                end
                else if (doing_partial_write_r2)
                    altered_ecc_code = int_ecc_wdata_rmw [ECC_DATA_PER_WORD_WIDTH - 1 : LOCAL_DATA_PER_WORD_WIDTH];
                else
                    altered_ecc_code = int_ecc_wdata [ECC_DATA_PER_WORD_WIDTH - 1 : LOCAL_DATA_PER_WORD_WIDTH];
            end
            
            // assign rmw data into ecc encoder
            assign int_rmw_wdata        = rmw_data [(z + 1) * LOCAL_DATA_PER_WORD_WIDTH - 1 : z * LOCAL_DATA_PER_WORD_WIDTH];
            
            // assign wdata_fifo wdata into ecc encoder
            assign int_wdata_fifo_wdata = wdata_fifo_wdata [(z + 1) * LOCAL_DATA_PER_WORD_WIDTH - 1 : z * LOCAL_DATA_PER_WORD_WIDTH];
            
            // get wdata fifo byte enable
            assign int_wdata_fifo_be    = wdata_fifo_be [(z + 1) * LOCAL_BE_PER_WORD_WIDTH - 1 : z * LOCAL_BE_PER_WORD_WIDTH];
            
            // we need to pass byte enables from wdata fifo or rmw data fifo
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_ecc_be <= 0;
                end
                else
                begin
                    // set byte enables to all zeros/ones when ECC is enabled (per word)
                    if (ecc_enable)
                    begin
                        int_ecc_be <= {ECC_BE_PER_WORD_WIDTH{1'b1}};
                    end
                    else
                        int_ecc_be <= {{(ECC_BE_PER_WORD_WIDTH - LOCAL_BE_PER_WORD_WIDTH){1'b0}}, int_wdata_fifo_be};
                end
            end
            
            // make sure we didn't re-generate the new ECC code for double bit error data during ECC correction state
            //always @ (*)
            //begin
            //    if (CTL_ECC_RMW_ENABLED && doing_ecc_write_r2 && rmw_data_double_bit_error_r1 [z]) // it means double bit error
            //        altered_ecc_code = rmw_data_ecc_code_r1 [(z + 1) * ECC_CODE_WIDTH - 1 : z * ECC_CODE_WIDTH];
            //    else
            //        altered_ecc_code = int_ecc_wdata [ECC_DATA_PER_WORD_WIDTH - 1 : LOCAL_DATA_PER_WORD_WIDTH];
            //end
            
            alt_ddrx_encoder # (
                .INPUT_DATA_WIDTH  (LOCAL_DATA_PER_WORD_WIDTH),
                .OUTPUT_DATA_WIDTH (ECC_DATA_PER_WORD_WIDTH)
            ) encoder_corrected_inst (
                .ctl_clk     (ctl_clk),
                .input_data  (int_rmw_wdata),
                .output_data (int_ecc_wdata_rmw)
            );
            
            alt_ddrx_encoder # (
                .INPUT_DATA_WIDTH  (LOCAL_DATA_PER_WORD_WIDTH),
                .OUTPUT_DATA_WIDTH (ECC_DATA_PER_WORD_WIDTH)
            ) encoder_inst (
                .ctl_clk     (ctl_clk),
                .input_data  (int_wdata_fifo_wdata),
                .output_data (int_ecc_wdata)
            );
            
            alt_ddrx_decoder # (
                .INPUT_DATA_WIDTH  (ECC_DATA_PER_WORD_WIDTH),
                .OUTPUT_DATA_WIDTH (LOCAL_DATA_PER_WORD_WIDTH)
            ) decoder_inst (
                .ctl_clk       (ctl_clk),
                .input_data    (int_afi_rdata [(z + 1) * ECC_DATA_PER_WORD_WIDTH - 1 : z * ECC_DATA_PER_WORD_WIDTH]),
                .err_corrected (decoder_err_corrected [z]),
                .err_detected  (decoder_err_detected [z]),
                .err_fatal     (decoder_err_fatal [z]),
                .output_data   (int_ecc_rdata)
            );
            
            // detect single bit error
            always @ (*)
            begin
                // we will only detect single/double bit error when ecc_enable signal is '1'
                if (decoder_err_detected [z] && ecc_enable)
                begin
                    if (decoder_err_corrected [z])
                    begin
                        int_single_bit_error [z] = 1'b1;
                        int_double_bit_error [z] = 1'b0;
                    end
                    else if (decoder_err_fatal [z])
                    begin
                        int_single_bit_error [z] = 1'b0;
                        int_double_bit_error [z] = 1'b1;
                    end
                    else
                    begin
                        int_single_bit_error [z] = 1'b0;
                        int_double_bit_error [z] = 1'b0;
                    end
                end
                else
                begin
                    int_single_bit_error [z] = 1'b0;
                    int_double_bit_error [z] = 1'b0;
                end
            end
        end
        
        /*------------------------------------------------------------------------------
        
            Partial Information
        
        ------------------------------------------------------------------------------*/
        always @ (*)
        begin
            // we will only tell state machine about partial information when ecc_enable is set to '1'
            if (ecc_enable)
            begin
                if (be_to_wfifo == {LOCAL_BE_WIDTH{1'b1}})
                    int_partial_write = 1'b0;
                else
                    int_partial_write = 1'b1;
            end
            else
                int_partial_write = 1'b0;
        end
        
        /*------------------------------------------------------------------------------
        
            Address FIFO
        
        ------------------------------------------------------------------------------*/
        assign scfifo_reset = !ctl_reset_n; // scfifo's reset is active high
        
        // chip address conversion
        if (MEM_IF_CS_WIDTH == 1)
        begin
            always @ (*)
            begin
                to_chip_addr = zero;
            end
        end
        else if (MEM_IF_CS_WIDTH == 2)
        begin
            always @ (*)
            begin
                if (to_chip [0])
                    to_chip_addr = 1'b0;
                else if (to_chip [1])
                    to_chip_addr = 1'b1;
                else
                    to_chip_addr = 1'b0;
            end
        end
        else if (MEM_IF_CS_WIDTH == 4)
        begin
            always @ (*)
            begin
                if (to_chip [0])
                    to_chip_addr = 2'b00;
                else if (to_chip [1])
                    to_chip_addr = 2'b01;
                else if (to_chip [2])
                    to_chip_addr = 2'b10;
                else if (to_chip [3])
                    to_chip_addr = 2'b11;
                else
                    to_chip_addr = 2'b00;
            end
        end
        else if (MEM_IF_CS_WIDTH == 8)
        begin
            always @ (*)
            begin
                if (to_chip [0])
                    to_chip_addr = 3'b000;
                else if (to_chip [1])
                    to_chip_addr = 3'b001;
                else if (to_chip [2])
                    to_chip_addr = 3'b010;
                else if (to_chip [3])
                    to_chip_addr = 3'b011;
                else if (to_chip [4])
                    to_chip_addr = 3'b100;
                else if (to_chip [5])
                    to_chip_addr = 3'b101;
                else if (to_chip [6])
                    to_chip_addr = 3'b110;
                else if (to_chip [7])
                    to_chip_addr = 3'b111;
                else
                    to_chip_addr = 3'b000;
            end
        end
        
        /*------------------------------------------------------------------------------
            Read Address FIFO
        ------------------------------------------------------------------------------*/
        // check for fifo overflow
        always @ (*)
        begin
            if (read_addr_fifo_full)
            begin
                $write($time);
                $write(" DDRX ECC Warning: Read address fifo overflow\n");
            end
        end
        
        // register do_burst_chop
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                do_burst_chop_r1 <= 1'b0;
                do_burst_chop_r2 <= 1'b0;
                do_burst_chop_r3 <= 1'b0;
            end
            else
            begin
                do_burst_chop_r1 <= do_burst_chop;
                do_burst_chop_r2 <= do_burst_chop_r1;
                do_burst_chop_r3 <= do_burst_chop_r2;
            end
        end
        
        // register do_read
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                do_read_r1 <= 1'b0;
                do_read_r2 <= 1'b0;
                do_read_r3 <= 1'b0;
            end
            else
            begin
                do_read_r1 <= do_read;
                do_read_r2 <= do_read_r1;
                do_read_r3 <= do_read_r2;
            end
        end
        
        // keep track of read size count
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                read_size_count <= 0;
            end
            else
            begin
                if (do_read && rdwr_data_valid) // if first data is valid, size must be at least one
                    read_size_count <= 1'b1;
                else if (do_read && !rdwr_data_valid) // if first data is not valid, size must be zero
                    read_size_count <= 1'b0;
                else
                begin
                    if (RDWR_DATA_VALID_MAX_LENGTH == 4) // memory burst length of 8 in full rate
                    begin
                        if (do_read_r1 && rdwr_data_valid)
                            read_size_count <= read_size_count + 1'b1;
                        else if (do_read_r2 && !do_burst_chop_r2 && rdwr_data_valid) // do not add when there is a burst chop
                            read_size_count <= read_size_count + 1'b1;
                        else if (do_read_r3 && !do_burst_chop_r3 && rdwr_data_valid) // do not add when there is a burst chop
                            read_size_count <= read_size_count + 1'b1;
                    end
                    else if (RDWR_DATA_VALID_MAX_LENGTH == 2) // memory burst length of 4/8 in full/half rate
                    begin
                        if (do_read_r1 && !do_burst_chop_r1 && rdwr_data_valid) // do not add when there is a burst chop
                            read_size_count <= read_size_count + 1'b1;
                    end
                end
            end
        end
        
        // register read_addr_fifo_wr
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                to_addr_r1 <= 0;
                to_addr_r2 <= 0;
                to_addr_r3 <= 0;
            end
            else
            begin
                to_addr_r1 <= {(do_ecc | do_partial), to_chip_addr, to_bank_addr, to_row_addr, to_col_addr}; // to indicate whethere this read is a ecc/partial read
                to_addr_r2 <= to_addr_r1;
                to_addr_r3 <= to_addr_r2;
            end
        end
        
        // determine when to write to read addr fifo
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                read_addr_fifo_wr      <= 1'b0;
                read_addr_fifo_wr_data <= 0;
            end
            else
            begin
                if (RDWR_DATA_VALID_MAX_LENGTH == 2) // memory burst length of 4/8 in full/half rate
                begin
                    read_addr_fifo_wr      <= do_read_r1;
                    read_addr_fifo_wr_data <= to_addr_r1;
                end
                else if (RDWR_DATA_VALID_MAX_LENGTH == 4) // memory burst length of 8 in full rate
                begin
                    read_addr_fifo_wr      <= do_read_r3;
                    read_addr_fifo_wr_data <= to_addr_r3;
                end
            end
        end
        
        // yyong: this part is latency insensitive, can be modified later for better fmax
        // determine the read_data_valid count
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                rdata_valid_count <= 0;
            end
            else
            begin
                if (int_afi_rdata_valid [0] && read_addr_fifo_rd) // when rdata valid cross over to another read request
                    rdata_valid_count <= 1'b1;
                else if (int_afi_rdata_valid [0])
                    rdata_valid_count <= rdata_valid_count + 1'b1;
                else
                    rdata_valid_count <= 0;
            end
        end
        
        // yyong: this part is latency insensitive, can be modified later for better fmax
        // determine when to read from read addr fifo
        always @ (*)
        begin
            if (rdata_valid_count != 0)
            begin
                if (rdata_valid_count == read_addr_fifo_rd_data [ADDR_FIFO_WIDTH + 3 : ADDR_FIFO_WIDTH + 1])
                    read_addr_fifo_rd = 1'b1;
                else
                    read_addr_fifo_rd = 1'b0;
            end
            else
                read_addr_fifo_rd = 1'b0;
        end
        
        /*
        // For Debug purpose
        reg [31 : 0] read_addr_fifo_rd_cnt;
        reg [31 : 0] read_addr_fifo_wr_cnt;
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                read_addr_fifo_rd_cnt <= 0;
                read_addr_fifo_wr_cnt <= 0;
            end
            else
            begin
                if (read_addr_fifo_rd)
                    read_addr_fifo_rd_cnt <= read_addr_fifo_rd_cnt + 1'b1;
                
                if (read_addr_fifo_wr)
                    read_addr_fifo_wr_cnt <= read_addr_fifo_wr_cnt + 1'b1;
            end
        end
        */
        /*
        // For Debug Purpose
        reg [31 : 0] ecc_read_count;
        reg [31 : 0] ecc_write_count;
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                ecc_read_count  <= 0;
                ecc_write_count <= 0;
            end
            else
            begin
                if (do_ecc && do_read)
                    ecc_read_count <= ecc_read_count + 1'b1;
                
                if (do_ecc && do_write)
                    ecc_write_count <= ecc_write_count + 1'b1;
            end
        end
        */
        
        // read address fifo, to store read addresses
        scfifo #
            (
                .intended_device_family  (FAMILY),
                .lpm_width               (ADDR_FIFO_WIDTH + 4),         // add one more for ecc/partial bit and another 3 for read size count
                .lpm_numwords            (16),                          // set to 16
                .lpm_widthu              (4),                           // log2 of lpm_numwords
                .almost_full_value       (16 - 4),                      // a bit of slack to avoid overflowing
                .lpm_type                ("scfifo"),
                .lpm_showahead           ("ON"),                        // lookahead function
                .overflow_checking       ("OFF"),
                .underflow_checking      ("OFF"),
                .use_eab                 ("ON"),
                .add_ram_output_register ("ON")
            )
            read_addr_fifo
            (
                .rdreq                   (read_addr_fifo_rd),
                .aclr                    (scfifo_reset),
                .clock                   (ctl_clk),
                .wrreq                   (read_addr_fifo_wr),
                .data                    ({read_size_count, read_addr_fifo_wr_data}),
                .full                    (read_addr_fifo_full),
                .q                       (read_addr_fifo_rd_data),
                .sclr                    (1'b0),
                .usedw                   (),
                .empty                   (read_addr_fifo_empty),
                .almost_full             (),
                .almost_empty            ()
           );
        
        /*------------------------------------------------------------------------------
        
            RMW Data FIFO
        
        ------------------------------------------------------------------------------*/
        // this fifo is used to store read modify write data during ECC state or masked data during Partial Write state
        
        // register ecc_rdata for rmw_data_fifo_wdata usage
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                ecc_rdata_r1 <= 0;
            else
                ecc_rdata_r1 <= ecc_rdata;
        end
        
        // determine when to write to rmw data fifo
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                rmw_data_fifo_wr <= 1'b0;
            end
            else
            begin
                //if (CTL_ECC_RMW_ENABLED && afi_rdata_valid [0] && doing_ecc_read && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // write to rmw data fifo during ecc read, this is enabled when auto correction is enabled
                if (CTL_ECC_RMW_ENABLED && int_afi_rdata_valid_r1 && doing_ecc_read && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // write to rmw data fifo during ecc read, this is enabled when auto correction is enabled
                    rmw_data_fifo_wr <= 1'b1;
                //else if (afi_rdata_valid [0] && doing_partial_read && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // write to rmw data during partial read, delay by one clock cycle because we will need tp read wdata fifo and mask the wdata before storing
                else if (int_afi_rdata_valid_r1 && doing_partial_read && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // write to rmw data during partial read, delay by one clock cycle because we will need tp read wdata fifo and mask the wdata before storing
                    rmw_data_fifo_wr <= 1'b1;
                else
                    rmw_data_fifo_wr <= 1'b0;
            end
        end
        
        // determine when to read from corrected data fifo
        always @ (*)
        begin
            if (CTL_ECC_RMW_ENABLED && doing_ecc_write && ecc_wdata_fifo_read)
                rmw_data_fifo_rd = 1'b1;
            else if (doing_partial_write && ecc_wdata_fifo_read)
                rmw_data_fifo_rd = 1'b1;
            else
                rmw_data_fifo_rd = 1'b0;
        end
        
        genvar y;
        for (y = 0;y < NUMBER_OF_INSTANCE;y = y + 1)
        begin : ecc_code_per_word
            reg [ECC_CODE_WIDTH            - 1 : 0] original_ecc_code;
            //reg                                     int_ecc_rdata_be; // one bit to determine whether all ones or all zeros
            reg [LOCAL_DATA_PER_WORD_WIDTH - 1 : 0] int_ecc_rdata_masked;
            reg [LOCAL_DATA_PER_WORD_WIDTH - 1 : 0] int_ecc_rdata;
            reg [LOCAL_BE_PER_WORD_WIDTH   - 1 : 0] int_wdata_fifo_be;
            reg [LOCAL_DATA_PER_WORD_WIDTH - 1 : 0] int_wdata_fifo_wdata;
            reg                                     int_double_bit_error_r1;
            
            /*------------------------------------------------------------------------------
                Inputs
            ------------------------------------------------------------------------------*/
            // assign wdata according to ecc code
            assign rmw_data_fifo_wr_data [(y + 1) * (ECC_DATA_PER_WORD_WIDTH + 1) - 1 : y * (ECC_DATA_PER_WORD_WIDTH + 1)] = {int_double_bit_error_r1, original_ecc_code, int_ecc_rdata_masked};
            
            always @ (*)
            begin
                int_ecc_rdata        = ecc_rdata_r1     [(y + 1) * LOCAL_DATA_PER_WORD_WIDTH - 1 : y * LOCAL_DATA_PER_WORD_WIDTH];
                int_wdata_fifo_be    = wdata_fifo_be    [(y + 1) * LOCAL_BE_PER_WORD_WIDTH   - 1 : y * LOCAL_BE_PER_WORD_WIDTH];
                int_wdata_fifo_wdata = wdata_fifo_wdata [(y + 1) * LOCAL_DATA_PER_WORD_WIDTH - 1 : y * LOCAL_DATA_PER_WORD_WIDTH];
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    int_double_bit_error_r1 <= 1'b0;
                else
                    int_double_bit_error_r1 <= int_double_bit_error [y];
            end
            
            // mask the wdata according to byte enables
            genvar i;
            for (i = 0;i < LOCAL_BE_PER_WORD_WIDTH;i = i + 1)
            begin : wdata_mask_per_byte_enable
                always @ (*)
                begin
                    if (doing_partial_read)
                    begin
                        if (int_wdata_fifo_be [i]) // if byte enable is '1', we will use wdata fifo wdata
                            int_ecc_rdata_masked [(i + 1) * 8 - 1 : i * 8] = int_wdata_fifo_wdata [(i + 1) * 8 - 1 : i * 8];
                        else // else use partial wdata
                            int_ecc_rdata_masked [(i + 1) * 8 - 1 : i * 8] = int_ecc_rdata [(i + 1) * 8 - 1 : i * 8];
                    end
                    else
                        int_ecc_rdata_masked [(i + 1) * 8 - 1 : i * 8] = int_ecc_rdata [(i + 1) * 8 - 1 : i * 8];
                end
            end
            
            // determine the byte enables
            //always @ (*)
            //begin
            //    if (!(|int_wdata_fifo_be)) // when be is all zeros, this will be zero
            //        int_ecc_rdata_be = 1'b0;
            //    else // else partial write which byte enables must be all ones
            //        int_ecc_rdata_be = 1'b1;
            //end
            
            // store the original ecc code
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                    original_ecc_code <= 0;
                else
                    original_ecc_code <= int_afi_rdata_r1 [(y + 1) * ECC_DATA_PER_WORD_WIDTH - 1 : (y * ECC_DATA_PER_WORD_WIDTH) + (ECC_DATA_PER_WORD_WIDTH - ECC_CODE_WIDTH)];
            end
            
            /*------------------------------------------------------------------------------
                Outputs
            ------------------------------------------------------------------------------*/
            // assign rdata accordingly for easier access
            assign rmw_data_double_bit_error [y]                                                      = rmw_data_fifo_rd_data [(y + 1) * (ECC_DATA_PER_WORD_WIDTH + 1) - 1];
            assign rmw_data_ecc_code [(y + 1) * ECC_CODE_WIDTH - 1 : y * ECC_CODE_WIDTH]              = rmw_data_fifo_rd_data [(y + 1) * (ECC_DATA_PER_WORD_WIDTH + 1) - 2 : y * (ECC_DATA_PER_WORD_WIDTH + 1) + LOCAL_DATA_PER_WORD_WIDTH];
            assign rmw_data [(y + 1) * LOCAL_DATA_PER_WORD_WIDTH - 1 : y * LOCAL_DATA_PER_WORD_WIDTH] = rmw_data_fifo_rd_data [(y + 1) * (ECC_DATA_PER_WORD_WIDTH + 1) - ECC_CODE_WIDTH - 2 : y * (ECC_DATA_PER_WORD_WIDTH + 1)];
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                rmw_data_double_bit_error_r1 <= 0;
                rmw_data_ecc_code_r1         <= 0;
                //rmw_data_r1                  <= 0;
            end
            else
            begin
                rmw_data_double_bit_error_r1 <= rmw_data_double_bit_error;
                rmw_data_ecc_code_r1         <= rmw_data_ecc_code;
                //rmw_data_r1                  <= rmw_data;
            end
        end
        
        // corrected data fifo, to store ecc read data
        // we choose to store data with ecc code because we musn't modify the hamming code when there is an double bit error
        // so that we can write back the original double bit erro data with original ecc code
        scfifo #
            (
                .intended_device_family  (FAMILY),
                .lpm_width               (ECC_DATA_WIDTH + NUMBER_OF_INSTANCE),           // in a 64/72 bit design, we will use up 576 in fullrate and 1152 in halfrate
                                                                                          // plus 2/4 (times multiple of 40/72 instance) more bits to indicate double bit error
                                                                                          // we need 2/4 bit to indicate whethere the be should be all ones or all zeros
                .lpm_numwords            (4),                                             // set to 4 now, might change
                .lpm_widthu              (2),                                             // log2 of lpm_numwords
                .almost_full_value       (4 - 2),                                         // a bit of slack to avoid overflowing
                .lpm_type                ("scfifo"),
                .lpm_showahead           ("OFF"),
                .overflow_checking       ("OFF"),
                .underflow_checking      ("OFF"),
                .use_eab                 ("ON"),
                .add_ram_output_register ("ON")
            )
            rmw_data_fifo
            (
                .rdreq                   (rmw_data_fifo_rd),
                .aclr                    (scfifo_reset),
                .clock                   (ctl_clk),
                .wrreq                   (rmw_data_fifo_wr),
                .data                    (rmw_data_fifo_wr_data),
                .full                    (rmw_data_fifo_full),
                .q                       (rmw_data_fifo_rd_data),
                .sclr                    (1'b0),
                .usedw                   (),
                .empty                   (rmw_data_fifo_empty),
                .almost_full             (),
                .almost_empty            ()
           );
        
        /*------------------------------------------------------------------------------
            rmw_data_ready
        ------------------------------------------------------------------------------*/
        // Logic to de-assert rmw_data_ready after partial/ecc write is detected
        // to avoid rmw_data_ready staying high for too long (eg: wlat of 10 case, tcl of 5 and al of 5)
        // so that it will not interrupt the next partial/ecc transaction
        always @ (*)
        begin
            if (doing_ecc_write || doing_partial_write)
                int_rmw_data_ready = 1'b0;
            else
                int_rmw_data_ready = !rmw_data_fifo_empty;
        end
        
        /*------------------------------------------------------------------------------
        
            Others
        
        ------------------------------------------------------------------------------*/
        
        /*------------------------------------------------------------------------------
            wdata fifo read
        ------------------------------------------------------------------------------*/
        
        // internal wdata fifo read, will only pass through this signal to wdata fifo during normal write operation
        always @ (*)
        begin
            if (CTL_ECC_RMW_ENABLED && doing_ecc_write) // only enabled when auto correction is enabled
                int_wdata_fifo_read = 1'b0; // during ecc write, don't pass the ecc wdata fifo read to wdata fifo instance
            else if (doing_partial_write)
                int_wdata_fifo_read = 1'b0; // during partial write, don't pass the ecc wdata fifo read to wdata fifo instance
            //else if (doing_partial_read && afi_rdata_valid [0] && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // we need to pull data out from wdata fifo when we are doing partial writes so that we can mask the data correctly
            else if (doing_partial_read && int_afi_rdata_valid_r1 && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // we need to pull data out from wdata fifo when we are doing partial writes so that we can mask the data correctly
                int_wdata_fifo_read = 1'b1; // when partial read data comes back, we need to pull data from wdata fifo
            else
                int_wdata_fifo_read = ecc_wdata_fifo_read;
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                ecc_wdata_fifo_read_r1 <= 1'b0;
                ecc_wdata_fifo_read_r2 <= 1'b0;
                ecc_wdata_fifo_read_r3 <= 1'b0;
            end
            else
            begin
                ecc_wdata_fifo_read_r1 <= ecc_wdata_fifo_read;
                ecc_wdata_fifo_read_r2 <= ecc_wdata_fifo_read_r1;
                ecc_wdata_fifo_read_r3 <= ecc_wdata_fifo_read_r2;
            end
        end
        
        /*------------------------------------------------------------------------------
            doing partial read write
        ------------------------------------------------------------------------------*/
        // remember that the current write is an partial write
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                doing_partial_write <= 1'b0;
            end
            else
            begin
                if (do_write && do_partial)
                    doing_partial_write <= 1'b1;
                else if (read_addr_fifo_rd_data [ADDR_FIFO_WIDTH + 3 : ADDR_FIFO_WIDTH + 1] == 1 && ecc_wdata_fifo_read) // size count of 1, de-assert doing_partial_write after wdata_fifo_read detected
                    doing_partial_write <= 1'b0;
                else if (read_addr_fifo_rd_data [ADDR_FIFO_WIDTH + 3 : ADDR_FIFO_WIDTH + 1] == 2 && ecc_wdata_fifo_read_r1) // size count of 2, de-assert doing_partial_write after wdata_fifo_read_r1 detected
                    doing_partial_write <= 1'b0;
                else if (read_addr_fifo_rd_data [ADDR_FIFO_WIDTH + 3 : ADDR_FIFO_WIDTH + 1] == 3 && ecc_wdata_fifo_read_r2) // size count of 3, de-assert doing_partial_write after wdata_fifo_read_r2 detected
                    doing_partial_write <= 1'b0;
                else if (ecc_wdata_fifo_read_r3) // must be size of 4
                    doing_partial_write <= 1'b0;
            end
        end
        
        // register doing partial write
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                doing_partial_write_r1 <= 1'b0;
                doing_partial_write_r2 <= 1'b0;
            end
            else
            begin
                doing_partial_write_r1 <= doing_partial_write;
                doing_partial_write_r2 <= doing_partial_write_r1;
            end
        end
        
        // remember that the current read is an partial read
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                doing_partial_read <= 1'b0;
            end
            else
            begin
                if (do_read && do_partial)
                    doing_partial_read <= 1'b1;
                else if (do_write && do_partial) // when partial write is done
                    doing_partial_read <= 1'b0;
            end
        end
        
        /*------------------------------------------------------------------------------
            ecc rdata valid
        ------------------------------------------------------------------------------*/
        // manipulate rdata valid base on encoder's information
        // we only pass on bit 0 because only that bit is passed on to local interface
        always @ (*)
        begin
            if (CTL_ECC_RMW_ENABLED && int_afi_rdata_valid_r1 && doing_ecc_read && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // do not assert rdata_valid during ecc read
                int_ecc_rdata_valid = 1'b0;
            else if (int_afi_rdata_valid_r1 && doing_partial_read && read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // do not assert rdata_valid during partial read
                int_ecc_rdata_valid = 1'b0;
            else
                int_ecc_rdata_valid = int_afi_rdata_valid_r1;
        end
        
        // register afi rdata valid by one cycle
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_afi_rdata_valid_r1 <= 1'b0;
            end
            else
            begin
                int_afi_rdata_valid_r1 <= int_afi_rdata_valid [0];
            end
        end
        
        /*------------------------------------------------------------------------------
            ECC Interrupt
        ------------------------------------------------------------------------------*/
        // assign interrupt signals to ecc_interrupt when error address fifo is not empty
        // but this signal will be masked by CSR sbe/dbe/all mask signal
        assign ecc_interrupt = int_ecc_interrupt;
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
                int_ecc_interrupt <= 1'b0;
            else
            begin
                if (!ecc_clear) // clear signal
                begin
                    if (ecc_enable_intr)
                    begin
                        if ((!ecc_mask_sbe_intr && |int_single_bit_error && int_afi_rdata_valid_r1) || (!ecc_mask_dbe_intr && |int_double_bit_error && int_afi_rdata_valid_r1)) // we will need to mask sbe/dbe errors
                        begin
                            int_ecc_interrupt <= 1'b1;
                        end
                    end
                    else
                        int_ecc_interrupt <= 1'b0;
                end
                else
                    int_ecc_interrupt <= 1'b0;
            end
        end
        
        /*------------------------------------------------------------------------------
        
            Auto Correction Specifics
        
        ------------------------------------------------------------------------------*/
        if (!CTL_ECC_RMW_ENABLED)
        begin
            // when auto correction is disabled
            assign ecc_single_bit_error = 0;
            
            assign ecc_error_chip_addr  = 0;
            assign ecc_error_bank_addr  = 0;
            assign ecc_error_row_addr   = 0;
            assign ecc_error_col_addr   = 0;
        end
        else
        begin
            // when auto correction is enabled, we will use 3 fifos to keep track of error addresses
            // read address fifo, error address fifo and corrected data fifo
            assign ecc_single_bit_error = !error_addr_fifo_empty;
            
            assign ecc_error_chip_addr = error_addr_fifo_rd_data [ADDR_FIFO_WIDTH - 1 : MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH];
            assign ecc_error_bank_addr = error_addr_fifo_rd_data [MEM_IF_BA_WIDTH + MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH];
            assign ecc_error_row_addr  = error_addr_fifo_rd_data [MEM_IF_ROW_WIDTH + MEM_IF_COL_WIDTH - 1 : MEM_IF_COL_WIDTH];
            assign ecc_error_col_addr  = error_addr_fifo_rd_data [MEM_IF_COL_WIDTH - 1 : 0];
            
            /*------------------------------------------------------------------------------
            
                Error Address FIFO
            
            ------------------------------------------------------------------------------*/
            assign error_addr_fifo_rd      = ecc_fetch_error_addr;
            assign error_addr_fifo_wr_data = read_addr_fifo_rd_data [ADDR_FIFO_WIDTH - 1 : 0];
            
            // yyong: this part is latency insensitive, can be modified later for better fmax
            always @ (*)
            begin
                if (ecc_enable_auto_corr) // only write to error address fifo when auto correction is enabled
                begin
                    if (read_addr_fifo_rd && (|int_single_bit_error || afi_rdata_single_bit_error) && !read_addr_fifo_rd_data [ADDR_FIFO_WIDTH]) // only write to ecc addr fifo during normal read
                        error_addr_fifo_wr = 1'b1;
                    else
                        error_addr_fifo_wr = 1'b0;
                end
                else
                    error_addr_fifo_wr = 1'b0;
            end
            
            // check for fifo overflow
            always @ (*)
            begin
                if (error_addr_fifo_full)
                begin
                    $write($time);
                    $write(" DDRX ECC Warning: Read address fifo overflow\n");
                end
            end
            
            // error address fifo, to store addresses with ecc single bit error
            scfifo #
                (
                    .intended_device_family  (FAMILY),
                    .lpm_width               (ADDR_FIFO_WIDTH),
                    .lpm_numwords            (128),                         // set to 16 now, might change
                    .lpm_widthu              (7),                           // log2 of lpm_numwords
                    .almost_full_value       (16 - 4),                      // a bit of slack to avoid overflowing
                    .lpm_type                ("scfifo"),
                    .lpm_showahead           ("ON"),
                    .overflow_checking       ("OFF"),
                    .underflow_checking      ("OFF"),
                    .use_eab                 ("ON"),
                    .add_ram_output_register ("ON")
                )
                error_addr_fifo
                (
                    .rdreq                   (error_addr_fifo_rd),
                    .aclr                    (scfifo_reset),
                    .clock                   (ctl_clk),
                    .wrreq                   (error_addr_fifo_wr),
                    .data                    (error_addr_fifo_wr_data),
                    .full                    (error_addr_fifo_full),
                    .q                       (error_addr_fifo_rd_data),
                    .sclr                    (1'b0),
                    .usedw                   (),
                    .empty                   (error_addr_fifo_empty),
                    .almost_full             (),
                    .almost_empty            ()
               );
            
            /*------------------------------------------------------------------------------
            
                Others
            
            ------------------------------------------------------------------------------*/
            
            /*------------------------------------------------------------------------------
                doing ecc read write
            ------------------------------------------------------------------------------*/
            // remember that the current write is an ecc write
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    doing_ecc_write <= 1'b0;
                end
                else
                begin
                    if (do_write && do_ecc)
                        doing_ecc_write <= 1'b1;
                    else if (RDWR_DATA_VALID_MAX_LENGTH == 4 && ecc_wdata_fifo_read && ecc_wdata_fifo_read_r3) // during the 4th fifo read (memory burst length of 8 in full rate)
                        doing_ecc_write <= 1'b0;
                    else if (RDWR_DATA_VALID_MAX_LENGTH == 2 && ecc_wdata_fifo_read && ecc_wdata_fifo_read_r1) // during the 2nd fifo read (memory burst length of 4/8 in full/half rate)
                        doing_ecc_write <= 1'b0;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    doing_ecc_write_r1 <= 1'b0;
                    doing_ecc_write_r2 <= 1'b0;
                end
                else
                begin
                    doing_ecc_write_r1 <= doing_ecc_write;
                    doing_ecc_write_r2 <= doing_ecc_write_r1;
                end
            end
            
            // remember that the current read is an ecc read
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    doing_ecc_read <= 1'b0;
                end
                else
                begin
                    if (do_read && do_ecc && !do_partial) // expect state machine to fix this!
                        doing_ecc_read <= 1'b1;
                    else if (do_write && do_ecc) // when ecc write is done
                        doing_ecc_read <= 1'b0;
                end
            end
            
            /*------------------------------------------------------------------------------
                afi rdata single bit error
            ------------------------------------------------------------------------------*/
            // this register will indicate there was a single bit error in this particular read command, to handle burst 2 and above read
            // this will be used in error addr fifo
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    afi_rdata_single_bit_error <= 1'b0;
                end
                else
                begin
                    if (read_addr_fifo_rd) // reset this back to zero after a read_addr_fifo read
                        afi_rdata_single_bit_error <= 1'b0;
                    else if (|int_single_bit_error && int_afi_rdata_valid_r1) // will only assert this when afi_rdata_valid_r1 is valid (use r1 because of decoder having one stage of reg)
                        afi_rdata_single_bit_error <= 1'b1;
                end
            end
        end
    end
endgenerate

/*------------------------------------------------------------------------------

    Debug Signals

------------------------------------------------------------------------------*/
// These signals are only used for debug purpose, Quartus will synthesis these
// signals away since it is not connected to anything

reg do_ecc_r1;
reg do_partial_r1;

always @ (posedge ctl_clk or negedge ctl_reset_n)
begin
    if (!ctl_reset_n)
    begin
        do_ecc_r1     <= 1'b0;
        do_partial_r1 <= 1'b0;
    end
    else
    begin
        do_ecc_r1     <= do_ecc;
        do_partial_r1 <= do_partial;
    end
end

endmodule
