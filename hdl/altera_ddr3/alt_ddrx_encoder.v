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
// Title         : DDR controller ECC Encoder
//
// File          : alt_ddrx_encoder.v
//
// Abstract      : Encode ECC information
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_ddrx_encoder #
    ( parameter
        INPUT_DATA_WIDTH  = 64,
        OUTPUT_DATA_WIDTH = 72
    )
    (
        ctl_clk,
        input_data,
        output_data
    );

input  ctl_clk;
input  [INPUT_DATA_WIDTH  - 1 : 0] input_data;
output [OUTPUT_DATA_WIDTH - 1 : 0] output_data;

wire   [OUTPUT_DATA_WIDTH - 1 : 0] output_data;

generate
    if (OUTPUT_DATA_WIDTH == 40)
    begin
        alt_ddrx_encoder_40 encoder_40_inst
            (
	            .clock (ctl_clk),
	            .data  (input_data),
	            .q     (output_data [OUTPUT_DATA_WIDTH - 2 : 0])
            );
        
        // encoder only have 32/29 combination, will have to hardcode MSB to '0'
        assign output_data [OUTPUT_DATA_WIDTH - 1] = 1'b0;
    end
    else if (OUTPUT_DATA_WIDTH == 72)
    begin
        alt_ddrx_encoder_72 encoder_72_inst
            (
	            .clock (ctl_clk),
	            .data  (input_data),
	            .q     (output_data)
            );
    end
endgenerate

endmodule
