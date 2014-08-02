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
// Title         : DDR controller ECC Decoder
//
// File          : alt_ddrx_decoder.v
//
// Abstract      : Decode ECC information
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_decoder #
    ( parameter
        INPUT_DATA_WIDTH  = 72,
        OUTPUT_DATA_WIDTH = 64
    )
    (
        ctl_clk,
        input_data,
        err_corrected,
        err_detected,
	    err_fatal,
        output_data
    );

input  ctl_clk;
input  [INPUT_DATA_WIDTH  - 1 : 0] input_data;
output [OUTPUT_DATA_WIDTH - 1 : 0] output_data;
output err_corrected;
output err_detected;
output err_fatal;

wire   [OUTPUT_DATA_WIDTH - 1 : 0] output_data;
wire   err_corrected;
wire   err_detected;
wire   err_fatal;

generate
    if (INPUT_DATA_WIDTH == 40)
    begin
        // encoder only have 32/29 combination
        alt_ddrx_decoder_40 decoder_40_inst
            (
	            .clock         (ctl_clk),
	            .data          (input_data [INPUT_DATA_WIDTH - 2 : 0]),
                .err_corrected (err_corrected),
                .err_detected  (err_detected),
	            .err_fatal     (err_fatal),
	            .q             (output_data)
            );
    end
    else if (INPUT_DATA_WIDTH == 72)
    begin
        alt_ddrx_decoder_72 decoder_72_inst
            (
	            .clock         (ctl_clk),
	            .data          (input_data),
                .err_corrected (err_corrected),
                .err_detected  (err_detected),
	            .err_fatal     (err_fatal),
	            .q             (output_data)
            );
    end
endgenerate

endmodule
