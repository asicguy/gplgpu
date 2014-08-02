module alt_mem_ddrx_ecc_decoder #
    ( parameter
        CFG_DATA_WIDTH              =   40,
        CFG_ECC_CODE_WIDTH          =   8,

        CFG_ECC_DEC_REG             =   1,
        CFG_ECC_RDATA_REG           =   0,
        
        CFG_MMR_DRAM_DATA_WIDTH     =   7,
        CFG_MMR_LOCAL_DATA_WIDTH    =   7,
        
        CFG_PORT_WIDTH_ENABLE_ECC   =   1
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        cfg_local_data_width,
        cfg_dram_data_width,
        cfg_enable_ecc,
        
        input_data,
        input_data_valid,
        output_data,
        output_data_valid,
        output_ecc_code,
        
        err_corrected,
        err_detected,
        err_fatal,
        err_sbe
    );

localparam CFG_ECC_DATA_WIDTH = (CFG_DATA_WIDTH > 8) ? (CFG_DATA_WIDTH - CFG_ECC_CODE_WIDTH) : (CFG_DATA_WIDTH);

input  ctl_clk;
input  ctl_reset_n;

input  [CFG_MMR_DRAM_DATA_WIDTH   - 1 : 0] cfg_local_data_width;
input  [CFG_MMR_LOCAL_DATA_WIDTH  - 1 : 0] cfg_dram_data_width;
input  [CFG_PORT_WIDTH_ENABLE_ECC - 1 : 0] cfg_enable_ecc;

input  [CFG_DATA_WIDTH     - 1 : 0] input_data;
input                               input_data_valid;

output [CFG_DATA_WIDTH     - 1 : 0] output_data;
output                              output_data_valid;
output [CFG_ECC_CODE_WIDTH - 1 : 0] output_ecc_code;

output                          err_corrected;
output                          err_detected;
output                          err_fatal;
output                          err_sbe;

//--------------------------------------------------------------------------------------------------------
//
//  [START] Register & Wires
//
//--------------------------------------------------------------------------------------------------------
    reg  [CFG_DATA_WIDTH     - 1 : 0] int_decoder_input;
    
    reg  [CFG_DATA_WIDTH     - 1 : 0] int_decoder_input_data;
    reg  [CFG_DATA_WIDTH     - 1 : 0] int_decoder_input_ecc_code;
    reg  [CFG_DATA_WIDTH     - 1 : 0] or_int_decoder_input_ecc_code;
    
    reg  [CFG_DATA_WIDTH     - 1 : 0] output_data;
    reg                               output_data_valid;
    reg  [CFG_ECC_CODE_WIDTH - 1 : 0] output_ecc_code;
    
    reg                               err_corrected;
    reg                               err_detected;
    reg                               err_fatal;
    reg                               err_sbe;

    wire                              int_err_corrected;
    wire                              int_err_detected;
    wire                              int_err_fatal;
    wire                              int_err_sbe;
    reg  [CFG_ECC_CODE_WIDTH - 1 : 0] int_output_ecc_code;

    wire [CFG_DATA_WIDTH     - 1 : 0] decoder_input;
    wire [CFG_ECC_DATA_WIDTH - 1 : 0] decoder_output;
    reg                               decoder_output_valid;

    reg  [CFG_ECC_DATA_WIDTH - 1 : 0] decoder_output_r;
    reg                               decoder_output_valid_r;
    reg                               int_err_corrected_r;
    reg                               int_err_detected_r;
    reg                               int_err_fatal_r;
    reg                               int_err_sbe_r;
    reg  [CFG_ECC_CODE_WIDTH - 1 : 0] int_output_ecc_code_r;
    
    wire zero = 1'b0;
//--------------------------------------------------------------------------------------------------------
//
//  [END] Register & Wires
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Common Logic
//
//--------------------------------------------------------------------------------------------------------
    // Input data splitting/masking logic:
    // change
    // <Empty data> - <ECC code> - <Data>
    // into
    // <ECC code> - <Empty data> - <Data>
    generate
        genvar i_data;
        for (i_data = 0;i_data < CFG_DATA_WIDTH;i_data = i_data + 1)
        begin : decoder_input_per_data_width
            always @ (*)
            begin
                int_decoder_input_data [i_data] = input_data [i_data];
            end
        end
    endgenerate
    
    generate
        if (CFG_ECC_RDATA_REG)
        begin
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_decoder_input <= 0;
                end
                else
                begin
                    int_decoder_input <= int_decoder_input_data;
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    decoder_output_valid <= 0;
                end
                else
                begin
                    decoder_output_valid <= input_data_valid;
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                int_decoder_input = int_decoder_input_data;
            end
            
            always @ (*)
            begin
                decoder_output_valid = input_data_valid;
            end
        end
    endgenerate
    
    // Decoder input assignment
    assign decoder_input = int_decoder_input;
    
    

    // Decoder output, registered
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            decoder_output_r        <= {CFG_ECC_DATA_WIDTH{1'b0}};
            decoder_output_valid_r  <= 1'b0;
            int_err_corrected_r     <= 1'b0;
            int_err_detected_r      <= 1'b0;
            int_err_fatal_r         <= 1'b0;
            int_err_sbe_r           <= 1'b0;
            int_output_ecc_code_r   <= {CFG_ECC_CODE_WIDTH{1'b0}};
        end
        else
        begin
            decoder_output_r        <= decoder_output;
            decoder_output_valid_r  <= decoder_output_valid;
            int_err_corrected_r     <= int_err_corrected;
            int_err_detected_r      <= int_err_detected;
            int_err_fatal_r         <= int_err_fatal;
            int_err_sbe_r           <= int_err_sbe;
            int_output_ecc_code_r   <= int_output_ecc_code;
        end
    end
    
    // Decoder output ecc code
    generate
        if (CFG_DATA_WIDTH <= 8)
        begin
            // No support for ECC case
            always @ (*)
            begin
                int_output_ecc_code = {CFG_ECC_CODE_WIDTH{zero}};
            end
        end
        else
        begin
            always @ (*)
            begin
                if (cfg_enable_ecc)
                    int_output_ecc_code = int_decoder_input_data [CFG_DATA_WIDTH - 1 : CFG_ECC_DATA_WIDTH];
                else
                    int_output_ecc_code = 0;
            end
        end
    endgenerate

    // Decoder wrapper output assignment
    generate
    begin : gen_decoder_output_reg_select
        if (CFG_ECC_DEC_REG)
        begin
            always @ (*)
            begin
                if (cfg_enable_ecc)
                begin
                    output_data         = {{CFG_ECC_CODE_WIDTH{1'b0}}, decoder_output_r};     // Assign '0' to ECC code portions
                    output_data_valid   = decoder_output_valid_r;
                    err_corrected       = int_err_corrected_r;
                    err_detected        = int_err_detected_r;
                    err_fatal           = int_err_fatal_r;
                    err_sbe             = int_err_sbe_r;
                    output_ecc_code     = int_output_ecc_code_r;
                end
                else
                begin
                    output_data         = input_data;
                    output_data_valid   = input_data_valid;
                    err_corrected       = 1'b0;
                    err_detected        = 1'b0;
                    err_fatal           = 1'b0;
                    err_sbe             = 1'b0;
                    output_ecc_code     = int_output_ecc_code;
                end
            end
        end
        else
        begin
            always @ (*)
            begin
                if (cfg_enable_ecc)
                begin
                    output_data         = {{CFG_ECC_CODE_WIDTH{1'b0}}, decoder_output};     // Assign '0' to ECC code portions
                    output_data_valid   = decoder_output_valid;
                    err_corrected       = int_err_corrected;
                    err_detected        = int_err_detected;
                    err_fatal           = int_err_fatal;
                    err_sbe             = int_err_sbe;
                    output_ecc_code     = int_output_ecc_code;
                end
                else
                begin
                    output_data         = input_data;
                    output_data_valid   = input_data_valid;
                    err_corrected       = 1'b0;
                    err_detected        = 1'b0;
                    err_fatal           = 1'b0;
                    err_sbe             = 1'b0;
                    output_ecc_code     = int_output_ecc_code;
                end
            end
        end
    end
    endgenerate

//--------------------------------------------------------------------------------------------------------
//
//  [END] Common Logic
//
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
//
//  [START] Instantiation
//
//--------------------------------------------------------------------------------------------------------
    
    generate
    begin
        if (CFG_ECC_DATA_WIDTH == 8 && CFG_DATA_WIDTH > 8) // Make sure this is an ECC case else it will cause compilation error
        begin
            wire [39 : 0] int_decoder_input;
            wire [32 : 0] int_decoder_output;
            
            // Assign decoder output
            assign int_decoder_input = {decoder_input [CFG_DATA_WIDTH - 1 : CFG_ECC_DATA_WIDTH], 24'd0, decoder_input [CFG_ECC_DATA_WIDTH - 1 : 0]};
            
            // Assign decoder output
            assign decoder_output    = int_decoder_output [CFG_ECC_DATA_WIDTH - 1 : 0];
            
            // 32/39 bit decoder instantiation
            alt_mem_ddrx_ecc_decoder_32 decoder_inst
                (
            	    .data          (int_decoder_input [38 : 0]),
            	    .err_corrected (int_err_corrected         ),
            	    .err_detected  (int_err_detected          ),
            	    .err_fatal     (int_err_fatal             ),
                    .err_sbe       (int_err_sbe               ),
            	    .q             (int_decoder_output        )
                );
        end
        else if (CFG_ECC_DATA_WIDTH == 16)
        begin
            wire [39 : 0] int_decoder_input;
            wire [32 : 0] int_decoder_output;
            
            // Assign decoder output
            assign int_decoder_input = {decoder_input [CFG_DATA_WIDTH - 1 : CFG_ECC_DATA_WIDTH], 16'd0, decoder_input [CFG_ECC_DATA_WIDTH - 1 : 0]};
            
            // Assign decoder output
            assign decoder_output    = int_decoder_output [CFG_ECC_DATA_WIDTH - 1 : 0];
            
            // 32/39 bit decoder instantiation
            alt_mem_ddrx_ecc_decoder_32 decoder_inst
                (
            	    .data          (int_decoder_input [38 : 0]),
            	    .err_corrected (int_err_corrected         ),
            	    .err_detected  (int_err_detected          ),
            	    .err_fatal     (int_err_fatal             ),
                    .err_sbe       (int_err_sbe               ),
            	    .q             (int_decoder_output        )
                );
        end
        else if (CFG_ECC_DATA_WIDTH == 32)
        begin
            // 32/39 bit decoder instantiation
            alt_mem_ddrx_ecc_decoder_32 decoder_inst
                (
            	    .data          (decoder_input [38 : 0]),
            	    .err_corrected (int_err_corrected     ),
            	    .err_detected  (int_err_detected      ),
            	    .err_fatal     (int_err_fatal         ),
                    .err_sbe       (int_err_sbe           ),
            	    .q             (decoder_output        )
                );
        end
        else if (CFG_ECC_DATA_WIDTH == 64)
        begin
            // 32/39 bit decoder instantiation
            alt_mem_ddrx_ecc_decoder_64 decoder_inst
                (
            	    .data          (decoder_input    ),
            	    .err_corrected (int_err_corrected),
            	    .err_detected  (int_err_detected ),
            	    .err_fatal     (int_err_fatal    ),
                    .err_sbe       (int_err_sbe      ),
            	    .q             (decoder_output   )
                );
        end
    end
    endgenerate
    
//--------------------------------------------------------------------------------------------------------
//
//  [END] Instantiation
//
//--------------------------------------------------------------------------------------------------------

endmodule
