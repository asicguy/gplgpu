// (C) 2001-2010 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1ps/1ps
module altera_pll
#(
	//parameter
	parameter reference_clock_frequency       = "0 ps",
	parameter pll_type                        = "General",
	parameter number_of_clocks 				  = 1,
	parameter operation_mode				  = "internal feedback",
	parameter deserialization_factor 		  = 4,
	parameter data_rate                 	  = 0,
	parameter clock_switchover_mode 		  = "Auto",
	parameter clock_switchover_delay 		  = 3,
	parameter sim_additional_refclk_cycles_to_lock	  = 0,
	parameter output_clock_frequency0 		  = "0 ps",
	parameter phase_shift0					  = "0 ps",
	parameter duty_cycle0					  = 50,
	
	parameter output_clock_frequency1 		  = "0 ps",
	parameter phase_shift1					  = "0 ps",
	parameter duty_cycle1					  = 50,
	
	parameter output_clock_frequency2 		  = "0 ps",
	parameter phase_shift2					  = "0 ps",
	parameter duty_cycle2					  = 50,
	
	parameter output_clock_frequency3 		  = "0 ps",
	parameter phase_shift3					  = "0 ps",
	parameter duty_cycle3					  = 50,
	
	parameter output_clock_frequency4 		  = "0 ps",
	parameter phase_shift4					  = "0 ps",
	parameter duty_cycle4					  = 50,
	
	parameter output_clock_frequency5 		  = "0 ps",
	parameter phase_shift5					  = "0 ps",
	parameter duty_cycle5					  = 50,
	
	parameter output_clock_frequency6 		  = "0 ps",
	parameter phase_shift6					  = "0 ps",
	parameter duty_cycle6					  = 50,
	
	parameter output_clock_frequency7 		  = "0 ps",
	parameter phase_shift7					  = "0 ps",
	parameter duty_cycle7					  = 50,
	
	parameter output_clock_frequency8 		  = "0 ps",
	parameter phase_shift8					  = "0 ps",
	parameter duty_cycle8					  = 50,
	
	parameter output_clock_frequency9 		  = "0 ps",
	parameter phase_shift9					  = "0 ps",
	parameter duty_cycle9					  = 50,	
	
	parameter output_clock_frequency10 		  = "0 ps",
	parameter phase_shift10					  = "0 ps",
	parameter duty_cycle10					  = 50,
	
	parameter output_clock_frequency11 		  = "0 ps",
	parameter phase_shift11					  = "0 ps",
	parameter duty_cycle11					  = 50,
	
	parameter output_clock_frequency12 		  = "0 ps",
	parameter phase_shift12					  = "0 ps",
	parameter duty_cycle12					  = 50,
	
	parameter output_clock_frequency13 		  = "0 ps",
	parameter phase_shift13					  = "0 ps",
	parameter duty_cycle13					  = 50,
	
	parameter output_clock_frequency14 		  = "0 ps",
	parameter phase_shift14					  = "0 ps",
	parameter duty_cycle14					  = 50,
	
	parameter output_clock_frequency15 		  = "0 ps",
	parameter phase_shift15					  = "0 ps",
	parameter duty_cycle15					  = 50,
	
	parameter output_clock_frequency16 		  = "0 ps",
	parameter phase_shift16					  = "0 ps",
	parameter duty_cycle16					  = 50,
	
	parameter output_clock_frequency17 		  = "0 ps",
	parameter phase_shift17					  = "0 ps",
	parameter duty_cycle17					  = 50
) ( 

	//input
	input	refclk,
	input	fbclk,
	input	rst,
	
	//output
	output	[ number_of_clocks -1 : 0] outclk,
	output	fboutclk,
	output	locked,
	
	//inout
	inout zdbfbclk
	
);

//wire
wire [ number_of_clocks -1 :0] fboutclk_wire;
wire [ number_of_clocks -1 :0] locked_wire;
wire [ number_of_clocks -1 :0] outclk_wire;
wire [ 17 : 0] divclk_wire;
wire fb_clkin;
wire fb_out_clk;
wire fb_obuf_clk;


generate
genvar i;  
    if (pll_type == "General")
    for (i=0; i<=number_of_clocks-1; i = i +1)
    begin : general
    generic_pll #(
	            .reference_clock_frequency(reference_clock_frequency),
		    .sim_additional_refclk_cycles_to_lock(sim_additional_refclk_cycles_to_lock),
	            .output_clock_frequency((i == 0) ? output_clock_frequency0 : 
        							(i == 1) ? output_clock_frequency1 :
        							(i == 2) ? output_clock_frequency2 :
        							(i == 3) ? output_clock_frequency3 :
        							(i == 4) ? output_clock_frequency4 :
        							(i == 5) ? output_clock_frequency5 :
        							(i == 6) ? output_clock_frequency6 :
        							(i == 7) ? output_clock_frequency7 :
        							(i == 8) ? output_clock_frequency8 :
        							(i == 9) ? output_clock_frequency9 :
        							(i == 10) ? output_clock_frequency10 :
        							(i == 11) ? output_clock_frequency11 :
        							(i == 12) ? output_clock_frequency12 :
        							(i == 13) ? output_clock_frequency13 :
        							(i == 14) ? output_clock_frequency14 :
        							(i == 15) ? output_clock_frequency15 :
        							(i == 16) ? output_clock_frequency16 : output_clock_frequency17), 
	            .duty_cycle((i == 0) ? duty_cycle0 : 
						(i == 1) ? duty_cycle1 :
        				(i == 2) ? duty_cycle2 :
        				(i == 3) ? duty_cycle3 :
        				(i == 4) ? duty_cycle4 :
        				(i == 5) ? duty_cycle5 :
        				(i == 6) ? duty_cycle6 :
        				(i == 7) ? duty_cycle7 :
        				(i == 8) ? duty_cycle8 :
        				(i == 9) ? duty_cycle9 :
        				(i == 10) ? duty_cycle10 :
        				(i == 11) ? duty_cycle11 :
        				(i == 12) ? duty_cycle12 :
        				(i == 13) ? duty_cycle13 :
        				(i == 14) ? duty_cycle14 :
        				(i == 15) ? duty_cycle15 :
        				(i == 16) ? duty_cycle16 : duty_cycle17), 
		    .phase_shift((i == 0) ? phase_shift0 : 
							(i == 1) ? phase_shift1 :
        					(i == 2) ? phase_shift2 :
        					(i == 3) ? phase_shift3 :
        					(i == 4) ? phase_shift4 :
        					(i == 5) ? phase_shift5 :
        					(i == 6) ? phase_shift6 :
        					(i == 7) ? phase_shift7 :
        					(i == 8) ? phase_shift8 :
        					(i == 9) ? phase_shift9 :
        					(i == 10) ? phase_shift10 :
        					(i == 11) ? phase_shift11 :
        					(i == 12) ? phase_shift12 :
        					(i == 13) ? phase_shift13 :
        					(i == 14) ? phase_shift14 :
        					(i == 15) ? phase_shift15 :
        					(i == 16) ? phase_shift16 : phase_shift17)
    ) gpll (
                     .refclk(refclk),
                     .fbclk((operation_mode == "external feedback") ? fb_clkin : (operation_mode == "zero delay buffer") ? fb_out_clk : fboutclk_wire[0]),
                     .rst(rst),
                     .fboutclk(fboutclk_wire[i]),
                     .outclk(outclk_wire[i]),
                     .locked(locked_wire[i])
                 );
    end   
endgenerate

assign fboutclk = (operation_mode == "external feedback" || operation_mode == "zero delay buffer") ? fb_out_clk : fboutclk_wire[0]; 
assign locked = locked_wire[0];
assign outclk = outclk_wire;
assign zdbfbclk = (operation_mode == "zero delay buffer") ? zdbfbclk : 1'b0;


	
generate
    if (operation_mode == "external feedback")
    begin: fb_ibuf
    alt_inbuf #(.enable_bus_hold("NONE")) fb_ibuf (
                          .i(fbclk),
                          .o(fb_clkin)
                      );
    end
endgenerate

generate 
    if (operation_mode == "external feedback")
    begin: fb_obuf
    alt_outbuf #(.enable_bus_hold("NONE"))  fb_obuf (
                           .i(fboutclk_wire[0]),
                           .o(fb_out_clk)
                       );
    end
endgenerate

generate
    if (operation_mode == "zero delay buffer")
    begin: fb_iobuf
    alt_iobuf #(.enable_bus_hold("NONE"))  fb_iobuf (
                           .i(fboutclk_wire[0]),
                           .oe(1'b1),
                           .io(zdbfbclk),
                           .o(fb_out_clk)
                       );
    end
endgenerate

endmodule

`ifndef ALTERA_LNSIM_FUNCTIONS_DEFINED
`define ALTERA_LNSIM_FUNCTIONS_DEFINED
package altera_lnsim_functions;
	localparam MEM_INIT_STRING_LENGTH = 512;
	localparam MAX_STRING_LENGTH = 20;

	function real get_real_value;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		real result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			result = 0.0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale to fs
			if (time_unit == "")
				result = result;
			else if (time_unit == "FS")
				result = result;
			else if (time_unit == "PS")
				result = result * 10**3;
			else if (time_unit == "NS")
				result = result * 10**6;
			else if (time_unit == "US")
				result = result * 10**9;
			else if (time_unit == "MS")
				result = result * 10**12;
			else if (time_unit == "KHZ")
				result = 10**12 / result;
			else if (time_unit == "MHZ")
				result = 10**9 / result;
			else if (time_unit == "GHZ")
				result = 10**6 / result;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			`ifdef GENERIC_PLL_TIMESCALE_1_FS
				result = result;

			`elsif GENERIC_PLL_TIMESCALE_10_FS
				result = result / 10**1;

			`elsif GENERIC_PLL_TIMESCALE_100_FS
				result = result / 10**2;

			`elsif GENERIC_PLL_TIMESCALE_1_PS
				result = result / 10**3;

			`elsif GENERIC_PLL_TIMESCALE_10_PS
				result = result / 10**4;

			`elsif GENERIC_PLL_TIMESCALE_100_PS
				result = result / 10**5;

			`elsif GENERIC_PLL_TIMESCALE_1_NS
				result = result / 10**6;

			`elsif GENERIC_PLL_TIMESCALE_10_NS
				result = result / 10**7;

			`elsif GENERIC_PLL_TIMESCALE_100_NS
				result = result / 10**8;

			`elsif GENERIC_PLL_TIMESCALE_1_US
				result = result / 10**9;

			`elsif GENERIC_PLL_TIMESCALE_10_US
				result = result / 10**10;

			`elsif GENERIC_PLL_TIMESCALE_100_US
				result = result / 10**11;

			`elsif GENERIC_PLL_TIMESCALE_1_MS
				result = result / 10**12;

			`elsif GENERIC_PLL_TIMESCALE_10_MS
				result = result / 10**13;

			`elsif GENERIC_PLL_TIMESCALE_100_MS
				result = result / 10**14;

			`elsif GENERIC_PLL_TIMESCALE_1_S
				result = result / 10**15;

			`else
				result = result / 10**3;

			`endif

			get_real_value = result;
		end
	endfunction

	function time get_time_value;
		input [8*MAX_STRING_LENGTH:1] time_string;

		integer index;
		time result;
		real integer_value;
		real fractional_value;
		real fractional_precision;
		reg [8*MAX_STRING_LENGTH:1] temp_str;
		reg [8:1] temp_char;
		reg [8:1] temp_digit;
		reg [8*3:1] time_unit;

		begin
			result = 0;
			index = 0;
			fractional_precision = 0.0;
			integer_value = 0.0;
			fractional_value = 0.0;
			time_unit = "";

			temp_str = time_string;
	        
			// Get the integer value and fractional value by switching on the decimal point
			for (index = 1; index <= MAX_STRING_LENGTH; index = index + 1)
				begin
					// 1. Get the most signifcant character
					// 2. Convert the char to decimal
					// 3. Shift the temporary string to get the next character
					temp_char = temp_str[160:153];
					temp_digit = temp_char & 8'b00001111;
					temp_str = temp_str << 8;

					// Found the decimal point
					if (temp_char == ".")
						fractional_precision = 1;
					// Found a digit
					else if ((temp_char >= "0") && (temp_char <= "9"))
						if (fractional_precision > 0)
							begin
								fractional_precision = fractional_precision / 10;
								fractional_value = fractional_value + (fractional_precision * temp_digit);
							end
						else
							integer_value = (integer_value * 10) + temp_digit;
					else if ((temp_char >= "a" && temp_char <= "z") || (temp_char >= "A" && temp_char <= "Z"))
						begin
							// Convert to upper case
							if (temp_char >= "a" && temp_char <= "z")
								temp_char = (temp_char & 8'h5f);
							time_unit = (time_unit << 8) | temp_char;
						end
				end

			// The result is the integer and fractional values      
			result = integer_value + fractional_value;

			// Convert the frequency unit to the resolution of the timescale (currently ps)
			if (time_unit == "")
				result = result;
			else if (time_unit == "FS")
				result = result / 10**3;
			else if (time_unit == "PS")
				result = result;
			else if (time_unit == "NS")
				result = result * 10**3;
			else if (time_unit == "US")
				result = result * 10**6;
			else if (time_unit == "MS")
				result = result * 10**9;
			else if (time_unit == "KHZ")
				result = 10**9 / result;
			else if (time_unit == "MHZ")
				result = 10**6 / result;
			else if (time_unit == "GHZ")
				result = 10**3 / result;
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			get_time_value = result;
		end
	endfunction

	function [8*MAX_STRING_LENGTH-1:0] get_time_string;
		input time time_value;
		input [8*MAX_STRING_LENGTH:1] time_unit;

		integer pos;
		integer initial_pos;
		integer f_unit;	// 10**f_unit is offset from Hz for larger unit

		begin
			// Convert the frequency unit to the resolution of the timescale (currently ps)
			if (time_unit == "")
				begin
					get_time_string = "0 ps";
					initial_pos = 3;
					f_unit = -1;
				end
			else if (time_unit == "fs")
				begin
					get_time_string = "0.000000 fs";
					initial_pos = 3;
				end
			else if (time_unit == "ps")
				begin
					get_time_string = "0 ps";
					initial_pos = 3;
					f_unit = -1;
				end
			else if (time_unit == "ns")
				begin
					get_time_string = "0.000000 ns";
					initial_pos = 3;
				end
			else if (time_unit == "us")
				begin
					get_time_string = "0.000000 us";
					initial_pos = 3;
				end
			else if (time_unit == "ms")
				begin
					get_time_string = "0.000000 ms";
					initial_pos = 3;
				end
			else if (time_unit == "kHz")
				begin
					get_time_string = "0.000000 kHz";
					initial_pos = 4;
				end
			else if (time_unit == "MHz")
				begin
					get_time_string = "0.000000 MHz";
					initial_pos = 4;
				end
			else if (time_unit == "GHz")
				begin
					get_time_string = "0.000000 GHz";
					initial_pos = 4;
				end
			else
				$display("Error: Unit \"%s\" is not supported", time_unit);

			// Convert time back to string with frequency units
			// Since char inital positions are used by <time_unit>, start with digits at initial_pos
			for (pos = initial_pos; pos < MAX_STRING_LENGTH && time_value > 0; pos = pos + 1)
				begin
					if (f_unit == 0)
						begin
							get_time_string[pos*8 +: 8] = 8'h2e;
							pos = pos + 1;
						end
					f_unit = f_unit - 1;
					get_time_string[pos*8 +: 8] = (time_value % 10) | 8'h30;
					time_value = time_value / 10;
				end
		end

	endfunction

	//--------------------------------------------------------------------------
	// Function Name    : hexToBits
	// Description      : takes in a hexadecimal character and returns the 4-bit 
	//                    value of the character. Returns 0 if character is not 
	//                    a hexadecimal character    
	//--------------------------------------------------------------------------
	
	function [3 : 0]  hexToBits;
		input [7 : 0] character;
		begin
			case ( character )
				"0" : hexToBits = 4'b0000;
				"1" : hexToBits = 4'b0001;
				"2" : hexToBits = 4'b0010;
				"3" : hexToBits = 4'b0011;
				"4" : hexToBits = 4'b0100;
				"5" : hexToBits = 4'b0101;
				"6" : hexToBits = 4'b0110;                    
				"7" : hexToBits = 4'b0111;
				"8" : hexToBits = 4'b1000;
				"9" : hexToBits = 4'b1001;
				"A" : hexToBits = 4'b1010;
				"a" : hexToBits = 4'b1010;
				"B" : hexToBits = 4'b1011;
				"b" : hexToBits = 4'b1011;
				"C" : hexToBits = 4'b1100;
				"c" : hexToBits = 4'b1100;          
				"D" : hexToBits = 4'b1101;
				"d" : hexToBits = 4'b1101;
				"E" : hexToBits = 4'b1110;
				"e" : hexToBits = 4'b1110;
				"F" : hexToBits = 4'b1111;
				"f" : hexToBits = 4'b1111;          
				default :
					begin 
						hexToBits = 4'b0000;
					end
			endcase        
		end
	endfunction
	
	//--------------------------------------------------------------------------
	// Function Name    : strtobits
	// Description      : takes in a string where each character represents a
	//                    hexadecimal number, transforms that number into 4-bits,
	//                    concatenates the result and returns it.
	//--------------------------------------------------------------------------
	
	function [4*MEM_INIT_STRING_LENGTH -1 : 0]  strtobits;
		input [8*MEM_INIT_STRING_LENGTH : 1] my_string;
		begin
			integer char_idx;
			integer bit_idx;
			reg[7 : 0] my_char;
			reg[3 : 0] hex_value;
			reg[4*MEM_INIT_STRING_LENGTH - 1 : 0] temp_bits;
			
			if(my_string == "")
				begin
					temp_bits = 'b0;
				end
			else
				begin
					bit_idx = 0;
					for (char_idx = 1; char_idx < 8*MEM_INIT_STRING_LENGTH; char_idx = char_idx + 8)
						begin : string_loop
							my_char[0] = my_string[char_idx];
							my_char[1] = my_string[char_idx+1];
							my_char[2] = my_string[char_idx+2];
							my_char[3] = my_string[char_idx+3];
							my_char[4] = my_string[char_idx+4];
							my_char[5] = my_string[char_idx+5];
							my_char[6] = my_string[char_idx+6];
							my_char[7] = my_string[char_idx+7];
							
							hex_value = hexToBits(my_char[7:0]);
							
							temp_bits[bit_idx] = hex_value[0];
							temp_bits[bit_idx+1] = hex_value[1];
							temp_bits[bit_idx+2] = hex_value[2];
							temp_bits[bit_idx+3] = hex_value[3];
							
							bit_idx = bit_idx + 4;
						end // string_loop
				end
			strtobits = temp_bits;
		end
	endfunction
	
endpackage
`endif
`ifdef GENERIC_PLL_TIMESCALE_1_FS
  `timescale 1 fs / 1 fs

`elsif GENERIC_PLL_TIMESCALE_10_FS
  `timescale 10 fs / 10 fs

`elsif GENERIC_PLL_TIMESCALE_100_FS
  `timescale 100 fs / 100 fs

`elsif GENERIC_PLL_TIMESCALE_1_PS
  `timescale 1 ps / 1 ps

`elsif GENERIC_PLL_TIMESCALE_10_PS
  `timescale 10 ps / 10 ps

`elsif GENERIC_PLL_TIMESCALE_100_PS
  `timescale 100 ps / 100 ps

`elsif GENERIC_PLL_TIMESCALE_1_NS
  `timescale 1 ns / 1 ns

`elsif GENERIC_PLL_TIMESCALE_10_NS
  `timescale 10 ns / 10 ns

`elsif GENERIC_PLL_TIMESCALE_100_NS
  `timescale 100 ns / 100 ns

`elsif GENERIC_PLL_TIMESCALE_1_US
  `timescale 1 us / 1 us

`elsif GENERIC_PLL_TIMESCALE_10_US
  `timescale 10 us / 10 us

`elsif GENERIC_PLL_TIMESCALE_100_US
  `timescale 100 us / 100 us

`elsif GENERIC_PLL_TIMESCALE_1_MS
  `timescale 1 ms / 1 ms

`elsif GENERIC_PLL_TIMESCALE_10_MS
  `timescale 10 ms / 10 ms

`elsif GENERIC_PLL_TIMESCALE_100_MS
  `timescale 100 ms / 100 ms

`elsif GENERIC_PLL_TIMESCALE_1_S
  `timescale 1 s / 1 s

`else
  `timescale 1 ps / 1 ps

`endif

module generic_pll
#(
	parameter lpm_type = "generic_pll",
	parameter duty_cycle =  50,
	parameter output_clock_frequency = "0 ps",
	parameter phase_shift = "0 ps",
	parameter reference_clock_frequency = "0 ps",
	parameter sim_additional_refclk_cycles_to_lock = 0
) (
	input wire          refclk,
	input wire          rst,
	input wire          fbclk,
	input wire  [63:0]  writerefclkdata,
	input wire  [63:0]  writeoutclkdata,
	input wire  [63:0]  writephaseshiftdata,
	input wire  [63:0]  writedutycycledata,
	
	output wire         outclk,
	output wire         locked,
	output wire         fboutclk,
	output wire [63:0]  readrefclkdata,
	output wire [63:0]  readoutclkdata,
	output wire [63:0]  readphaseshiftdata,
	output wire [63:0]  readdutycycledata
);

	import altera_lnsim_functions::*;

	real output_clock_high_period;
	real output_clock_low_period;
	real reference_clock_period_value;
	real output_clock_period_value;
	real phase_shift_value;
	real duty_cycle_value;
	real output_clock_period;
	reg outclk_reg;
	reg locked_reg;
	reg phase_shift_done_reg;
	integer refclk_cycles;

	initial
	begin
		reference_clock_period_value = get_real_value(reference_clock_frequency);
		output_clock_period_value = get_real_value(output_clock_frequency);
		phase_shift_value = get_real_value(phase_shift);
		duty_cycle_value = duty_cycle / 100.0;
		output_clock_high_period = output_clock_period_value * duty_cycle_value;
		output_clock_low_period = output_clock_period_value * (1.0 - duty_cycle_value);
		outclk_reg = 0;
		locked_reg = 0;
		phase_shift_done_reg = 0;
		refclk_cycles = 0;

		$display("Info: =================================================");
		$display("Info:           Generic PLL Summary");
		$display("Info: =================================================");
		$printtimescale;
		$display("Info: hierarchical_name = %m");
		$display("Info: reference_clock_frequency = %0s", reference_clock_frequency);
		$display("Info: output_clock_frequency = %0s", output_clock_frequency);
		$display("Info: phase_shift = %0s", phase_shift);
		$display("Info: duty_cycle = %0d", duty_cycle);
		$display("Info: sim_additional_refclk_cycles_to_lock = %0d", sim_additional_refclk_cycles_to_lock);
		$display("Info: output_clock_high_period = %0f", output_clock_high_period);
		$display("Info: output_clock_low_period = %0f", output_clock_low_period);
	end

	always @(posedge refclk or posedge rst)
		if (rst)
			begin
				refclk_cycles = 0;
				phase_shift_done_reg = 0;
				locked_reg = 0;
			end
		else if (refclk_cycles < sim_additional_refclk_cycles_to_lock)
			refclk_cycles = refclk_cycles + 1;
		else
		  locked_reg = 1;

	always @(posedge locked_reg)
		begin
		  outclk_reg = 0;
		  #phase_shift_value outclk_reg = 1;
		  phase_shift_done_reg = 1;
		end
    
  always
      wait (phase_shift_done_reg == 1)
        begin
          #output_clock_high_period outclk_reg = 0;
          #output_clock_low_period outclk_reg = 1;
        end

	assign outclk = outclk_reg && locked;
	assign locked = locked_reg;
	assign fboutclk = refclk && locked;

	// TODO - Temporarily driving AVMM adapter outputs to zero
	assign  readrefclkdata      = 64'd0;
	assign  readoutclkdata      = 64'd0;
	assign  readphaseshiftdata  = 64'd0;
	assign  readdutycycledata   = 64'd0;

endmodule

`timescale 1 ps/1 ps
module generic_cdr
#(
	parameter reference_clock_frequency = "0 ps",
	parameter output_clock_frequency = "0 ps",
	parameter sim_debug_msg = "false"
) (
	input wire extclk,
	input wire ltd,
	input wire ltr,
	input wire pciel,
	input wire pciem,
	input wire ppmlock,
	input wire refclk,
	input wire rst,
	input wire sd,
	input wire rxp,

	output wire clk90bdes,
	output wire clk270bdes,
	output wire clklow,
	output reg deven,
	output reg dodd,
	output wire fref,
	output wire pfdmodelock,
	output wire rxplllock
);

	import altera_lnsim_functions::*;

	wire clk0_wire;
	wire clk0_pcie_00_wire;
	wire clk0_pcie_01_wire;
	wire clk90_wire;
	wire clk90_pcie_00_wire;
	wire clk90_pcie_01_wire;
	wire clk180_wire;
	wire clk270_wire;
	wire datain_ipd;
	wire datain_dly;
	reg deven_int1_reg;
	reg deven_int2_reg;
	reg dodd_int1_reg;
	reg dodd_int2_reg;
	wire fboutclk_wire;
	wire lck2ref_wire;
	wire locked_wire;

	initial
	begin
		deven <= 1'b1;
		dodd <= 1'b1;
		deven_int1_reg = 1'b0;
		dodd_int1_reg = 1'b0;
		deven_int2_reg = 1'b0;
		dodd_int2_reg = 1'b0;
		$display("Info: =================================================");
		$display("Info:           Generic CDR Summary");
		$display("Info: =================================================");
		$printtimescale;
		$display("Info: hierarchical_name = %m");
		$display("Info: reference_clock_frequency = %0s", reference_clock_frequency);
		$display("Info: output_clock_frequency = %0s", output_clock_frequency);
	end

	//////////////////////////////////////////////////
	// clk0
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift("0 ps")
	) inst_cdr_clk0_pcie_00 (
		.refclk(refclk),
		.rst(rst),
		.fbclk(fboutclk_wire),
		
		.outclk(clk0_pcie_00_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire)
	);

	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(get_time_string(get_time_value(output_clock_frequency) * 2, "ps")),
		.phase_shift("0 ps")
	) inst_cdr_clk0_pcie_01 (
		.refclk(refclk),
		.rst(rst),
		.fbclk(fboutclk_wire),
		
		.outclk(clk0_pcie_01_wire),
		.locked(),
		.fboutclk()
	);
	
	assign clk0_wire = {pciem, pciel} == 2'b00 ? clk0_pcie_00_wire :
					   {pciem, pciel} == 2'b01 ? clk0_pcie_01_wire :
					   {pciem, pciel} == 2'b10 ? 1'bx :
					   1'bx;
	
	//////////////////////////////////////////////////
	// clk90
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(get_time_value(output_clock_frequency) / 4, "ps"))
	) inst_cdr_clk90_pcie_00 (
		.refclk(refclk),
		.rst(rst),
		.fbclk(fboutclk_wire),
		
		.outclk(clk90_pcie_00_wire),
		.locked(),
		.fboutclk()
	);

	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(get_time_string(get_time_value(output_clock_frequency) * 2, "ps")),
		.phase_shift(get_time_string(get_time_value(output_clock_frequency) * 2 / 4, "ps"))
	) inst_cdr_clk90_pcie_01 (
		.refclk(refclk),
		.rst(rst),
		.fbclk(fboutclk_wire),
		
		.outclk(clk90_pcie_01_wire),
		.locked(),
		.fboutclk()
	);

	assign clk90_wire = {pciem, pciel} == 2'b00 ? clk90_pcie_00_wire :
						{pciem, pciel} == 2'b01 ? clk90_pcie_01_wire :
						{pciem, pciel} == 2'b10 ? 1'bx :
						1'bx;

	//////////////////////////////////////////////////
	// clk180
	//////////////////////////////////////////////////
	assign clk180_wire = !clk0_wire;
	
	//////////////////////////////////////////////////
	// clk270
	//////////////////////////////////////////////////
	assign clk270_wire = !clk90_wire;

	//////////////////////////////////////////////////
	// clk90bdes
	//////////////////////////////////////////////////
	assign clk90bdes = clk90_wire;

	//////////////////////////////////////////////////
	// clk270bdes
	//////////////////////////////////////////////////
	assign clk270bdes = clk270_wire;
	
	//////////////////////////////////////////////////
	// clklow
	//////////////////////////////////////////////////
	assign clklow = fboutclk_wire && !rst;

	//////////////////////////////////////////////////
	// deven and dodd
	//////////////////////////////////////////////////
	assign datain_ipd = (rxp === 1'b1) ? 1'b1 : 1'b0;
	assign #5 datain_dly = datain_ipd;
	
	always @ (clk0_wire)
		if (clk0_wire == 1'b1)
			deven_int1_reg <= datain_dly;
		else if (clk0_wire == 1'b0)
			deven_int2_reg <= deven_int1_reg;

	always @ (clk180_wire)
		if (clk180_wire == 1'b1)
			dodd_int1_reg <= datain_dly;
		else if (clk180_wire == 1'b0)
			dodd_int2_reg <= dodd_int1_reg;

	always @ (posedge clk90_wire)
		{deven ,dodd} <= {deven_int2_reg, dodd_int2_reg};

	//////////////////////////////////////////////////
	// fref
	//////////////////////////////////////////////////
	assign fref = refclk && !rst;
	
	//////////////////////////////////////////////////
	// pciel, pciem, and rst
	//////////////////////////////////////////////////
	generate
		if (sim_debug_msg == "true")
			always @(ltd or ltr or pciel or pciem or ppmlock or rst or sd) 
				begin
					$display("Info: =================================================");
					$display("Info:           Generic CDR at time %0d", $time);
					$display("Info: =================================================");
					$display("Info: hierarchical_name = %m");
					$display("Info: ltd = %v ", ltd);
					$display("Info: ltr = %v ", ltr);
					$display("Info: pciel = %v", pciel);
					$display("Info: pciem = %v", pciem);
					$display("Info: ppmlock = %v", ppmlock);
					$display("Info: rst = %v ", rst);
					$display("Info: sd = %v", sd);
				end
	endgenerate

	//////////////////////////////////////////////////
	// pfdmodelock
	//////////////////////////////////////////////////
	assign pfdmodelock = locked_wire && ~rst;
	
	//////////////////////////////////////////////////
	// rxplllock
	//////////////////////////////////////////////////
	assign lck2ref_wire = ltd ? 1'b0 :
						 (~sd | ~ppmlock | ltr ) ? 1'b1 : 
						 (sd & ppmlock & ~ltr & ~pfdmodelock ) ? 1'b1 :
						 (sd & ppmlock & ~ltr &  pfdmodelock ) ? 1'b0 :
						 1'b0;
	assign rxplllock = !lck2ref_wire;

endmodule


`timescale 1 ps/1 ps

// Deactivate the LEDA rule that requires uppercase letters for all
// parameter names
// leda rule_G_521_3_B off


//--------------------------------------------------------------------------
// Module Name     : common_28nm_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

module common_28nm_ram_pulse_generator (
                                    clk,
                                    ena,
                                    pulse,
                                    cycle
                                   );
input  clk;   // clock
input  ena;   // pulse enable
output pulse; // pulse
output cycle; // delayed clock

parameter delay_pulse = 1'b0;
parameter start_delay = (delay_pulse == 1'b0) ? 1 : 2; // delay write
reg  state;
reg  clk_prev;
wire clk_ipd;

specify
    specparam t_decode = 0,t_access = 0;
    (posedge clk => (pulse +: state)) = (t_decode,t_access);
endspecify

buf #(start_delay) (clk_ipd,clk);
wire  pulse_opd;

buf buf_pulse  (pulse,pulse_opd);

initial clk_prev = 1'bx;

always @(clk_ipd or posedge pulse)
begin
    if      (pulse) state <= 1'b0;
    else if (ena && clk_ipd === 1'b1 && clk_prev === 1'b0)   state <= 1'b1;
  clk_prev = clk_ipd;
end

assign cycle = clk_ipd;
assign pulse_opd = state; 

endmodule

//--------------------------------------------------------------------------
// Module Name     : common_28nm_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module common_28nm_ram_register (
                             d,
                             clk,
                             aclr,
                             devclrn,
                             devpor,
                             stall,
                             ena,
                             q,
                             aclrout
                            );

parameter width = 1;      // data width
parameter preset = 1'b0;  // clear acts as preset

input [width - 1:0] d;    // data
input clk;                // clock
input aclr;               // asynch clear
input devclrn,devpor;     // device wide clear/reset
input stall; // address stall
input ena;                // clock enable
output [width - 1:0] q;   // register output
output aclrout;           // delayed asynch clear

wire ena_ipd;
wire clk_ipd;
wire aclr_ipd;
wire [width - 1:0] d_ipd;

buf buf_ena (ena_ipd,ena);
buf buf_clk (clk_ipd,clk);
buf buf_aclr (aclr_ipd,aclr);
buf buf_d [width - 1:0] (d_ipd,d);
wire stall_ipd;

buf buf_stall (stall_ipd,stall);
wire  [width - 1:0] q_opd;

buf buf_q  [width - 1:0] (q,q_opd);
reg   [width - 1:0] q_reg;

reg viol_notifier;
wire reset;

assign reset = devpor && devclrn && (!aclr_ipd) && (ena_ipd);
specify
      $setup  (d,    posedge clk &&& reset, 0, viol_notifier);
      $setup  (aclr, posedge clk, 0, viol_notifier);
      $setup  (ena,  posedge clk &&& reset, 0, viol_notifier );
      $setup  (stall, posedge clk &&& reset, 0, viol_notifier );
      $hold   (posedge clk &&& reset, d   , 0, viol_notifier);
      $hold   (posedge clk, aclr, 0, viol_notifier);
      $hold   (posedge clk &&& reset, ena , 0, viol_notifier );
      $hold   (posedge clk &&& reset, stall, 0, viol_notifier );
      (posedge clk =>  (q +: q_reg)) = (0,0);
      (posedge aclr => (q +: q_reg)) = (0,0);
endspecify

initial q_reg <= (preset) ? {width{1'b1}} : 'b0;

always @(posedge clk_ipd or posedge aclr_ipd or negedge devclrn or negedge devpor)
begin
    if (aclr_ipd || ~devclrn || ~devpor)
        q_reg <= (preset) ? {width{1'b1}} : 'b0;
        else if (ena_ipd & !stall_ipd)
        q_reg <= d_ipd;
end
assign aclrout = aclr_ipd;

assign q_opd = q_reg; 

endmodule

`timescale 1 ps/1 ps

`define PRIME 1
`define SEC   0

//--------------------------------------------------------------------------
// Module Name     : common_28nm_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module common_28nm_ram_block
    (
     portadatain,
     portaaddr,
     portawe,
     portare,
     portbdatain,
     portbaddr,
     portbwe,
     portbre,
     clk0, clk1,
     ena0, ena1,
     ena2, ena3,
     clr0, clr1,
     nerror,
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     eccstatus,
     portadataout,
     portbdataout
      ,dftout
     );

// -------- PACKAGES ------------------

import altera_lnsim_functions::*;

// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";
parameter ram_block_type = "auto";
parameter logical_ram_name = "ram_name";

parameter init_file = "init_file.hex";
parameter init_file_layout = "none";

parameter ecc_pipeline_stage_enabled = "false";
parameter enable_ecc = "false";
parameter width_eccstatus = 2;
parameter data_interleave_width_in_bits = 1;
parameter data_interleave_offset_in_bits = 1;
parameter port_a_logical_ram_depth = 0;
parameter port_a_logical_ram_width = 0;
parameter port_a_first_address = 0;
parameter port_a_last_address = 0;
parameter port_a_first_bit_number = 0;

parameter port_a_data_out_clear = "none";

parameter port_a_data_out_clock = "none";

parameter port_a_data_width = 1;
parameter port_a_address_width = 1;
parameter port_a_byte_enable_mask_width = 1;

parameter port_b_logical_ram_depth = 0;
parameter port_b_logical_ram_width = 0;
parameter port_b_first_address = 0;
parameter port_b_last_address = 0;
parameter port_b_first_bit_number = 0;

parameter port_b_address_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_write_enable_clock = "clock1";
parameter port_b_read_enable_clock  = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter port_a_read_during_write_mode = "new_data_no_nbe_read";
parameter port_b_read_during_write_mode = "new_data_no_nbe_read";
parameter power_up_uninitialized = "false";
parameter lpm_type = "stratixv_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

parameter mem_init0 = "";
parameter mem_init1 = "";
parameter mem_init2 = "";
parameter mem_init3 = "";
parameter mem_init4 = "";
parameter mem_init5 = "";
parameter mem_init6 = "";
parameter mem_init7 = "";
parameter mem_init8 = "";
parameter mem_init9 = "";

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

parameter bist_ena = "false"; //false, true 

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// LOCAL_PARAMETERS_BEGIN

parameter MEM_INIT_STRING_LENGTH = 512;
parameter primary_port_is_a  = (port_b_data_width <= port_a_data_width) ? 1'b1 : 1'b0;
parameter primary_port_is_b  = ~primary_port_is_a;

parameter mode_is_rom_or_sp  = ((operation_mode == "rom") || (operation_mode == "single_port")) ? 1'b1 : 1'b0;
parameter data_width         = (primary_port_is_a) ? port_a_data_width : port_b_data_width;
parameter data_unit_width    = (mode_is_rom_or_sp | primary_port_is_b) ? port_a_data_width : port_b_data_width;
parameter address_width      = (mode_is_rom_or_sp | primary_port_is_b) ? port_a_address_width : port_b_address_width;
parameter address_unit_width = (mode_is_rom_or_sp | primary_port_is_a) ? port_a_address_width : port_b_address_width;
parameter wired_mode         = ((port_a_address_width == 1) && (port_a_address_width == port_b_address_width)
                                                            && (port_a_data_width != port_b_data_width));

parameter num_rows = 1 << address_unit_width;
parameter num_cols = (mode_is_rom_or_sp) ? 1 : ( wired_mode ? 2 :
                      ( (primary_port_is_a) ?
                      1 << (port_b_address_width - port_a_address_width) :
                      1 << (port_a_address_width - port_b_address_width) ) ) ;

parameter mask_width_prime = (primary_port_is_a) ?
                              port_a_byte_enable_mask_width : port_b_byte_enable_mask_width;
parameter mask_width_sec   = (primary_port_is_a) ?
                              port_b_byte_enable_mask_width : port_a_byte_enable_mask_width;

parameter byte_size_a = port_a_data_width/port_a_byte_enable_mask_width;
parameter byte_size_b = port_b_data_width/port_b_byte_enable_mask_width;

parameter mode_is_dp  = (operation_mode == "dual_port") ? 1'b1 : 1'b0;

// Hardware write modes
parameter dual_clock = ((operation_mode == "dual_port")  ||
                        (operation_mode == "bidir_dual_port")) &&
                        (port_b_address_clock == "clock1");
parameter both_new_data_same_port = (
                                      ((port_a_read_during_write_mode == "new_data_no_nbe_read") ||
                                       (port_a_read_during_write_mode == "dont_care")) &&
                                      ((port_b_read_during_write_mode == "new_data_no_nbe_read") ||
                                       (port_b_read_during_write_mode == "dont_care"))
                                    ) ? 1'b1 : 1'b0;
parameter hw_write_mode_a = (
                                ((port_a_read_during_write_mode == "old_data") ||
                                 (port_a_read_during_write_mode == "new_data_with_nbe_read"))
                            ) ? "R+W" : (
                                            dual_clock || (
                                               mixed_port_feed_through_mode == "dont_care" &&
                                               both_new_data_same_port
                                            ) ? "FW" : "DW"
                                        );
parameter hw_write_mode_b = (
                                ((port_b_read_during_write_mode == "old_data") ||
                                 (port_b_read_during_write_mode == "new_data_with_nbe_read"))
                            ) ? "R+W" : (
                                            dual_clock || (
                                               mixed_port_feed_through_mode == "dont_care" &&
                                               both_new_data_same_port
                                            ) ? "FW" : "DW"
                                        );
 parameter delay_write_pulse_a = (mode_is_dp && mixed_port_feed_through_mode == "dont_care") ? 1'b0 : ((hw_write_mode_a != "FW") ? 1'b1 : 1'b0);
parameter delay_write_pulse_b = (hw_write_mode_b != "FW") ? 1'b1 : 1'b0;
parameter be_mask_write_a     = (port_a_read_during_write_mode == "new_data_with_nbe_read") ? 1'b1 : 1'b0;
parameter be_mask_write_b     = (port_b_read_during_write_mode == "new_data_with_nbe_read") ? 1'b1 : 1'b0;
parameter old_data_write_a     = (port_a_read_during_write_mode == "old_data") ? 1'b1 : 1'b0;
parameter old_data_write_b     = (port_b_read_during_write_mode == "old_data") ? 1'b1 : 1'b0;
parameter read_before_write_a = (hw_write_mode_a == "R+W") ? 1'b1 : 1'b0;
parameter read_before_write_b = (hw_write_mode_b == "R+W") ? 1'b1 : 1'b0;

// LOCAL_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input portare;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbwe, portbre;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;
input ena2,ena3;
input nerror;

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;
output [width_eccstatus - 1:0] eccstatus;
output [8:0] dftout;


tri0 portawe_int;
assign portawe_int = portawe;
tri1 portare_int;
assign portare_int = portare;
tri0 [port_a_data_width - 1:0] portadatain_int;
assign portadatain_int = portadatain;
tri0 [port_a_address_width - 1:0] portaaddr_int;
assign portaaddr_int = portaaddr;
tri1 [port_a_byte_enable_mask_width - 1:0] portabyteenamasks_int;
assign portabyteenamasks_int = portabyteenamasks;

tri0 portbwe_int;
assign portbwe_int = portbwe;
tri1 portbre_int;
assign portbre_int = portbre;
tri0 [port_b_data_width - 1:0] portbdatain_int;
assign portbdatain_int = portbdatain;
tri0 [port_b_address_width - 1:0] portbaddr_int;
assign portbaddr_int = portbaddr;
tri1 [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks_int;
assign portbbyteenamasks_int = portbbyteenamasks;

tri0 clr0_int,clr1_int;
assign clr0_int = clr0;
assign clr1_int = clr1;
tri0 clk0_int,clk1_int;
assign clk0_int = clk0;
assign clk1_int = clk1;
tri1 ena0_int,ena1_int;
assign ena0_int = ena0;
assign ena1_int = ena1;
tri1 ena2_int,ena3_int;
assign ena2_int = ena2;
assign ena3_int = ena3;
tri1 nerror_int;
assign nerror_int = nerror;

tri0 portaaddrstall_int;
assign portaaddrstall_int = portaaddrstall;
tri0 portbaddrstall_int;
assign portbaddrstall_int = portbaddrstall;
tri1 devclrn;
tri1 devpor;


// -------- INTERNAL signals ---------
// BIST infrastructure
wire bist_signal;
wire [port_a_byte_enable_mask_width - 1:0] port_a_bist_data;
wire [port_b_byte_enable_mask_width - 1:0] port_b_bist_data;
wire [port_a_byte_enable_mask_width - 1:0] byte_enable_a;
wire [port_b_byte_enable_mask_width - 1:0] byte_enable_b;
reg [port_a_data_width - 1:0] dataout_a_in_reg;
reg [port_b_data_width - 1:0] dataout_b_in_reg;
// clock / clock enable
wire clk_a_in,clk_a_byteena,clk_a_out,clk_a_out_secmux,clkena_a_out;
wire clk_a_rena, clk_a_wena;
wire clk_a_core;
wire clk_b_in,clk_b_byteena,clk_b_out,clk_b_out_secmux,clkena_b_out;
wire clk_b_rena, clk_b_wena;
wire clk_b_core;

wire write_cycle_a,write_cycle_b;

// asynch clear
wire datain_a_clr,dataout_a_clr,datain_b_clr,dataout_b_clr;
wire dataout_a_clr_reg, dataout_b_clr_reg;

wire addr_a_clr,addr_b_clr;
wire byteena_a_clr,byteena_b_clr;
wire we_a_clr, re_a_clr, we_b_clr, re_b_clr;

wire datain_a_clr_in,datain_b_clr_in;
wire addr_a_clr_in,addr_b_clr_in;
wire byteena_a_clr_in,byteena_b_clr_in;
wire we_a_clr_in, re_a_clr_in, we_b_clr_in, re_b_clr_in;

reg  mem_invalidate;
wire [`PRIME:`SEC] clear_asserted_during_write;
reg  clear_asserted_during_write_a,clear_asserted_during_write_b;

// port A registers
wire we_a_reg;
wire re_a_reg;
wire [port_a_address_width - 1:0] addr_a_reg;
wire [port_a_data_width - 1:0] datain_a_reg, dataout_a_reg;
reg  [port_a_data_width - 1:0] dataout_a;
wire [port_a_byte_enable_mask_width - 1:0] byteena_a_reg;
reg  out_a_is_reg;

// port B registers
wire we_b_reg, re_b_reg;
wire [port_b_address_width - 1:0] addr_b_reg;
wire [port_b_data_width - 1:0] datain_b_reg, dataout_b_reg, dataout_b_signal, ecc_pipeline_b_reg;
reg  [port_b_data_width - 1:0] dataout_b;
wire [port_b_byte_enable_mask_width - 1:0] byteena_b_reg;
reg  out_b_is_reg;

// placeholders for read/written data
reg  [data_width - 1:0] read_data_latch;
reg  [data_width - 1:0] mem_data;
reg  [data_width - 1:0] old_mem_data;

reg  [data_unit_width - 1:0] read_unit_data_latch;
reg  [data_width - 1:0]      mem_unit_data;

// pulses for A/B ports
wire write_pulse_a,write_pulse_b;
wire read_pulse_a,read_pulse_b;
wire read_pulse_a_feedthru,read_pulse_b_feedthru;
wire rw_pulse_a, rw_pulse_b;


wire [address_unit_width - 1:0] addr_prime_reg; // registered address
wire [address_width - 1:0]      addr_sec_reg;

wire [data_width - 1:0]       datain_prime_reg; // registered data
wire [data_unit_width - 1:0]  datain_sec_reg;


// pulses for primary/secondary ports
wire write_pulse_prime,write_pulse_sec;
wire read_pulse_prime,read_pulse_sec;
wire read_pulse_prime_feedthru,read_pulse_sec_feedthru;
wire rw_pulse_prime, rw_pulse_sec;

reg read_pulse_prime_last_value, read_pulse_sec_last_value;
reg rw_pulse_prime_last_value, rw_pulse_sec_last_value;

reg  [`PRIME:`SEC] dual_write;  // simultaneous write to same location

// (row,column) coordinates
reg  [address_unit_width - 1:0] row_sec;
reg  [address_width + data_unit_width - address_unit_width - 1:0] col_sec;

// memory core
reg  [data_width - 1:0] mem [num_rows - 1:0];

// byte enable
wire [data_width - 1:0]      mask_vector_prime, mask_vector_prime_int;
wire [data_unit_width - 1:0] mask_vector_sec,   mask_vector_sec_int;

reg  [data_unit_width - 1:0] mask_vector_common_int;

reg  [port_a_data_width - 1:0] mask_vector_a, mask_vector_a_int;
reg  [port_b_data_width - 1:0] mask_vector_b, mask_vector_b_int;

// memory initialization
integer i,j,k,l;
integer addr_range_init;
reg [data_width - 1:0] init_mem_word;
reg [(port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1:0] mem_init;

// port active for read/write
wire  active_a_in, active_b_in;
wire active_a_core,active_a_core_in,active_b_core,active_b_core_in;
wire  active_write_a,active_write_b,active_write_clear_a,active_write_clear_b;

reg  mode_is_rom,mode_is_sp,mode_is_bdp; // ram mode
reg  ram_type;                               // ram type eg. MRAM


initial
begin
`ifdef QUARTUS_MEMORY_PLI
     $memory_connect(mem);
`endif
   ram_type = 0;



    mode_is_rom = (operation_mode == "rom");
    mode_is_sp  = (operation_mode == "single_port");
    mode_is_bdp = (operation_mode == "bidir_dual_port");

    out_a_is_reg = (port_a_data_out_clock == "none") ? 1'b0 : 1'b1;
    out_b_is_reg = (port_b_data_out_clock == "none") ? 1'b0 : 1'b1;

    // powerup output latches to 0
        dataout_a = 'b0;
        if (mode_is_dp || mode_is_bdp) dataout_b = 'b0;
     if ((power_up_uninitialized == "false") && ~ram_type)
         for (i = 0; i < num_rows; i = i + 1) mem[i] = 'b0;
    if ((init_file_layout == "port_a") || (init_file_layout == "port_b"))
    begin
        mem_init = { strtobits(mem_init9), strtobits(mem_init8), 
	             strtobits(mem_init7), strtobits(mem_init6),
	             strtobits(mem_init5), strtobits(mem_init4),
	             strtobits(mem_init3), strtobits(mem_init2),
	             strtobits(mem_init1), strtobits(mem_init0)
        };
        addr_range_init  = (primary_port_is_a) ?
                        port_a_last_address - port_a_first_address + 1 :
                        port_b_last_address - port_b_first_address + 1 ;
        for (j = 0; j < addr_range_init; j = j + 1)
        begin
            for (k = 0; k < data_width; k = k + 1)
                init_mem_word[k] = mem_init[j*data_width + k];
            mem[j] = init_mem_word;
        end
    end
    dual_write = 'b0;
end

assign port_a_bist_data = (bist_ena == "true") ? portabyteenamasks_int : 1'b0 ;
assign port_b_bist_data = (bist_ena == "true") ? portbbyteenamasks_int : 1'b0 ;
assign byte_enable_a = (bist_ena == "true") ? 1'b1 : byteena_a_reg ;
assign byte_enable_b = (bist_ena == "true") ? 1'b1 : byteena_b_reg ;

assign clk_a_in      = clk0_int;
assign clk_a_wena = (port_a_write_enable_clock == "none") ? 1'b0 : clk_a_in;
assign clk_a_rena = (port_a_read_enable_clock  == "none") ? 1'b0 : clk_a_in;
// The byte enable registers are not preset to '1'.
assign clk_a_byteena = clk_a_in;
assign clk_a_out_secmux = (port_a_data_out_clock == "none")    ? 1'b0 : (
                       (port_a_data_out_clock == "clock0")  ? clk0_int : clk1_int);
assign clk_a_out = clk_a_out_secmux & nerror_int;

assign clk_b_in      = (port_b_address_clock == "clock0") ? clk0_int : clk1_int;
// The byte enable registers are not preset to '1'.
assign clk_b_byteena = (port_b_byte_enable_clock == "clock0") ? clk0_int : clk1_int;
assign clk_b_wena = (port_b_write_enable_clock == "none")   ? 1'b0 : (
                    (port_b_write_enable_clock == "clock0") ? clk0_int : clk1_int);
assign clk_b_rena = (port_b_read_enable_clock  == "none")   ? 1'b0 : (
                    (port_b_read_enable_clock  == "clock0") ? clk0_int : clk1_int);

assign clk_b_out_secmux = (port_b_data_out_clock == "none")      ? 1'b0 : (
                       (port_b_data_out_clock == "clock0")    ? clk0_int : clk1_int);
assign clk_b_out = clk_b_out_secmux & nerror_int;

assign addr_a_clr_in = (port_a_address_clear == "none")   ? 1'b0 : clr0_int;
assign addr_b_clr_in = (port_b_address_clear == "none")   ? 1'b0 : (
                       (port_b_address_clear == "clear0") ? clr0_int : clr1_int);

assign datain_a_clr_in = 1'b0;
assign dataout_a_clr    = (port_a_data_out_clear == "none")   ? 1'b0 : (
                           (port_a_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign datain_b_clr_in = 1'b0;
assign dataout_b_clr    = (port_b_data_out_clear == "none")   ? 1'b0 : (
                           (port_b_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign byteena_a_clr_in = 1'b0;
assign byteena_b_clr_in = 1'b0;

assign we_a_clr_in = 1'b0;
assign re_a_clr_in = 1'b0;

assign we_b_clr_in = 1'b0;
assign re_b_clr_in = 1'b0;

assign active_a_in = (clk0_input_clock_enable == "none") ? 1'b1 : (
                     (clk0_input_clock_enable == "ena0") ? ena0_int : ena2_int
                     );

assign active_a_core_in = (clk0_core_clock_enable == "none") ? 1'b1 : (
                          (clk0_core_clock_enable == "ena0") ? ena0_int : ena2_int
                          );

assign active_b_in = (port_b_address_clock == "clock0")  ? (
                           (clk0_input_clock_enable == "none") ? 1'b1 : ((clk0_input_clock_enable == "ena0") ? ena0_int : ena2_int)
                     ) : (
                           (clk1_input_clock_enable == "none") ? 1'b1 : ((clk1_input_clock_enable == "ena1") ? ena1_int : ena3_int)
                     );

assign active_b_core_in = (port_b_address_clock == "clock0")  ?  (
                              (clk0_core_clock_enable == "none") ? 1'b1 : ((clk0_core_clock_enable == "ena0") ? ena0_int : ena2_int)
                              ) : (
                                  (clk1_core_clock_enable == "none") ? 1'b1 : ((clk1_core_clock_enable == "ena1") ? ena1_int : ena3_int)
                              );


assign active_write_a = (byte_enable_a !== 'b0);


assign active_write_b = (byte_enable_b !== 'b0);

// Store core clock enable value for delayed write
// port A core active
common_28nm_ram_register active_core_port_a (
       .d(active_a_core_in),
       .clk(clk_a_in),
       .aclr(1'b0),
       .devclrn(1'b1),
       .devpor(1'b1),
       .stall(1'b0),
       .ena(1'b1),
       .q(active_a_core),.aclrout()
);
defparam active_core_port_a.width = 1;

// port B core active
common_28nm_ram_register active_core_port_b (
       .d(active_b_core_in),
       .clk(clk_b_in),
       .aclr(1'b0),
       .devclrn(1'b1),
       .devpor(1'b1),
       .stall(1'b0),
       .ena(1'b1),
       .q(active_b_core),.aclrout()
);
defparam active_core_port_b.width = 1;


// ------- A input registers -------
// write enable
common_28nm_ram_register we_a_register (
        .d(mode_is_rom ? 1'b0 : portawe_int),
        .clk(clk_a_wena),
        .aclr(we_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
 .ena(active_a_core_in),
        .q(we_a_reg),
        .aclrout(we_a_clr)
        );
defparam we_a_register.width = 1;

// read enable
common_28nm_ram_register re_a_register (
        .d(portare_int),
        .clk(clk_a_rena),
        .aclr(re_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
         .ena(active_a_core_in),
        .q(re_a_reg),
        .aclrout(re_a_clr)
        );

// address
common_28nm_ram_register addr_a_register (
        .d(portaaddr_int),
        .clk(clk_a_in),
        .aclr(addr_a_clr_in),
        .devclrn(devclrn),.devpor(devpor),
        .stall(portaaddrstall_int),
        .ena(active_a_in),
        .q(addr_a_reg),
        .aclrout(addr_a_clr)
        );
defparam addr_a_register.width = port_a_address_width;

// data
common_28nm_ram_register datain_a_register (
        .d(portadatain_int),
        .clk(clk_a_in),
        .aclr(datain_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_a_in),
        .q(datain_a_reg),
        .aclrout(datain_a_clr)
        );
defparam datain_a_register.width = port_a_data_width;

// byte enable
common_28nm_ram_register byteena_a_register (
        .d(portabyteenamasks_int),
        .clk(clk_a_byteena),
        .aclr(byteena_a_clr_in),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_a_in),
        .q(byteena_a_reg),
        .aclrout(byteena_a_clr)
        );
defparam byteena_a_register.width = port_a_byte_enable_mask_width;

// ------- B input registers -------

// write enable

common_28nm_ram_register we_b_register (
        .d(portbwe_int),
        .clk(clk_b_wena),
        .aclr(we_b_clr_in),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
         .ena(active_b_core_in),
        .q(we_b_reg),
        .aclrout(we_b_clr)
        );
defparam we_b_register.width = 1;
defparam we_b_register.preset = 1'b0;

// read enable

common_28nm_ram_register re_b_register (
        .d(portbre_int),
        .clk(clk_b_rena),
        .aclr(re_b_clr_in),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
         .ena(active_b_core_in),
        .q(re_b_reg),
        .aclrout(re_b_clr)
        );
defparam re_b_register.width = 1;
defparam re_b_register.preset = 1'b0;



// address
common_28nm_ram_register addr_b_register (
        .d(portbaddr_int),
        .clk(clk_b_in),
        .aclr(addr_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(portbaddrstall_int),
        .ena(active_b_in),
        .q(addr_b_reg),
        .aclrout(addr_b_clr)
        );
defparam addr_b_register.width = port_b_address_width;

// data
common_28nm_ram_register datain_b_register (
        .d(portbdatain_int),
        .clk(clk_b_in),
        .aclr(datain_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_b_in),
        .q(datain_b_reg),
        .aclrout(datain_b_clr)
        );
defparam datain_b_register.width = port_b_data_width;

// byte enable
common_28nm_ram_register byteena_b_register (
        .d(portbbyteenamasks_int),
        .clk(clk_b_byteena),
        .aclr(byteena_b_clr_in),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_b_in),
        .q(byteena_b_reg),
        .aclrout(byteena_b_clr)
        );
defparam byteena_b_register.width  = port_b_byte_enable_mask_width;

assign datain_prime_reg = (primary_port_is_a) ? datain_a_reg : datain_b_reg;
assign addr_prime_reg   = (primary_port_is_a) ? addr_a_reg   : addr_b_reg;

assign datain_sec_reg   = (primary_port_is_a) ? datain_b_reg : datain_a_reg;
assign addr_sec_reg     = (primary_port_is_a) ? addr_b_reg   : addr_a_reg;

assign mask_vector_prime     = (primary_port_is_a) ? mask_vector_a     : mask_vector_b;
assign mask_vector_prime_int = (primary_port_is_a) ? mask_vector_a_int :  mask_vector_b_int;

assign mask_vector_sec       = (primary_port_is_a) ? mask_vector_b     : mask_vector_a;
assign mask_vector_sec_int   = (primary_port_is_a) ? mask_vector_b_int : mask_vector_a_int;

// Hardware Write Modes
// Write pulse generation
common_28nm_ram_pulse_generator wpgen_a (
       .clk(clk_a_in),
       .ena(active_a_core & active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );
defparam wpgen_a.delay_pulse = delay_write_pulse_a;

common_28nm_ram_pulse_generator wpgen_b (
       .clk(clk_b_in),
       .ena(active_b_core & active_write_b & mode_is_bdp & we_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );
defparam wpgen_b.delay_pulse = delay_write_pulse_b;

// Read pulse generation
common_28nm_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
        .ena(active_a_core & re_a_reg & ~we_a_reg & (~dataout_a_clr || out_a_is_reg)),
        .pulse(read_pulse_a),
       .cycle(clk_a_core)
        );

common_28nm_ram_pulse_generator rpgen_b (
        .clk(clk_b_in),
        .ena((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg & ~we_b_reg & (~dataout_b_clr || out_b_is_reg)),
        .pulse(read_pulse_b),
       .cycle(clk_b_core)
        );

// Read during write pulse generation
common_28nm_ram_pulse_generator rwpgen_a (
    .clk(clk_a_in),
     .ena(active_a_core & re_a_reg & we_a_reg & read_before_write_a & (~dataout_a_clr || out_a_is_reg)),
    .pulse(rw_pulse_a),.cycle()
);

common_28nm_ram_pulse_generator rwpgen_b (
    .clk(clk_b_in),
     .ena(active_b_core & mode_is_bdp & re_b_reg & we_b_reg & read_before_write_b & (~dataout_b_clr || out_b_is_reg)),
    .pulse(rw_pulse_b),.cycle()
);

assign write_pulse_prime = (primary_port_is_a) ? write_pulse_a : write_pulse_b;
assign read_pulse_prime  = (primary_port_is_a) ? read_pulse_a : read_pulse_b;
assign read_pulse_prime_feedthru = (primary_port_is_a) ? read_pulse_a_feedthru : read_pulse_b_feedthru;
assign rw_pulse_prime = (primary_port_is_a) ? rw_pulse_a : rw_pulse_b;

assign write_pulse_sec = (primary_port_is_a) ? write_pulse_b : write_pulse_a;
assign read_pulse_sec  = (primary_port_is_a) ? read_pulse_b : read_pulse_a;
assign read_pulse_sec_feedthru = (primary_port_is_a) ? read_pulse_b_feedthru : read_pulse_a_feedthru;
assign rw_pulse_sec   = (primary_port_is_a) ? rw_pulse_b : rw_pulse_a;

// Create internal masks for byte enable processing
always @(byte_enable_a)
begin
    for (i = 0; i < port_a_data_width; i = i + 1)
    begin
        mask_vector_a[i]     = (byte_enable_a[i/byte_size_a] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_a_int[i] = (byte_enable_a[i/byte_size_a] === 1'b0) ? 1'b0 : 1'bx;
    end
end

always @(byte_enable_b)
begin
    for (l = 0; l < port_b_data_width; l = l + 1)
    begin
        mask_vector_b[l]     = (byte_enable_b[l/byte_size_b] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_b_int[l] = (byte_enable_b[l/byte_size_b] === 1'b0) ? 1'b0 : 1'bx;
    end
end

// BIST output handling
always @(dataout_a or port_a_bist_data)
begin
    if (bist_ena == "true")
    begin
        for (i = 0; i < port_a_data_width; i = i + 1)
        begin
            dataout_a_in_reg[i] = port_a_bist_data[i/byte_size_a] ^ dataout_a[i];
        end
    end
    else
    begin
    	dataout_a_in_reg = dataout_a;
    end
end

always @(dataout_b_signal or port_b_bist_data)
begin
    if (bist_ena == "true")
    begin
        for (i = 0; i < port_b_data_width; i = i + 1)
        begin
            dataout_b_in_reg[i] = port_b_bist_data[i/byte_size_b] ^ dataout_b_signal[i];
        end
    end
    else
    begin
    	dataout_b_in_reg = dataout_b_signal;
    end
end

// Latch Clear port A - only if the output is unregistered
always @(posedge dataout_a_clr)
begin
    if (primary_port_is_a) 
    begin 
    	if (port_a_data_out_clock == "none") 
	begin 
		read_data_latch <= 'b0;
		dataout_a <= 'b0; 
	end
    end
    else                   
    begin 
    	if (port_a_data_out_clock == "none") 
	begin 
		read_unit_data_latch <= 'b0;
		dataout_a <= 'b0; 
	end
    end
end


// Latch Clear port B - only if the output is unregistered
always @(posedge dataout_b_clr)
begin
    if (primary_port_is_b) 
    begin 
    	if (port_b_data_out_clock == "none") 
	begin 
		read_data_latch <= 'b0; 
		dataout_b <= 'b0; 
	end
    end
    else                   
    begin 
    	if (port_b_data_out_clock == "none") 
	begin 
		read_unit_data_latch <= 'b0;
		dataout_b <= 'b0; 
	end
    end
end

always @(posedge write_pulse_prime or posedge write_pulse_sec or
         posedge read_pulse_prime or posedge read_pulse_sec
         or posedge rw_pulse_prime or posedge rw_pulse_sec
        )
begin

    // Read before Write stage 1 : read data from memory
    if (rw_pulse_prime && (rw_pulse_prime !== rw_pulse_prime_last_value))
    begin
       read_data_latch = mem[addr_prime_reg];
       rw_pulse_prime_last_value = rw_pulse_prime;
    end
    if (rw_pulse_sec && (rw_pulse_sec !== rw_pulse_sec_last_value))
    begin
       row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
       mem_unit_data = mem[row_sec];
       for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
           read_unit_data_latch[j - col_sec] = mem_unit_data[j];
       rw_pulse_sec_last_value = rw_pulse_sec;
    end

    // Write stage 1 : write X to memory
    if (write_pulse_prime)
    begin
        old_mem_data = mem[addr_prime_reg];
        mem_data = mem[addr_prime_reg] ^ mask_vector_prime_int;
        mem[addr_prime_reg] = mem_data;
	if ((row_sec == addr_prime_reg) && (read_pulse_sec))
	begin
	    mem_unit_data = (mixed_port_feed_through_mode == "dont_care") ? {data_width{1'bx}} : old_mem_data;
	    for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
                read_unit_data_latch[j - col_sec] = mem_unit_data[j];
	end
    end
    if (write_pulse_sec)
    begin
        row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
        mem_unit_data = mem[row_sec];
        for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
            mem_unit_data[j] = mem_unit_data[j] ^ mask_vector_sec_int[j - col_sec];
        mem[row_sec] = mem_unit_data;
    end

    if ((addr_prime_reg == row_sec) && write_pulse_prime && write_pulse_sec) dual_write = 2'b11;

    // Read stage 1 : read data from memory

    if (read_pulse_prime && read_pulse_prime !== read_pulse_prime_last_value)
    begin
       read_data_latch = mem[addr_prime_reg];
       read_pulse_prime_last_value = read_pulse_prime;
    end

    if (read_pulse_sec && read_pulse_sec !== read_pulse_sec_last_value)
    begin
        row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
        if ((row_sec == addr_prime_reg) && (write_pulse_prime))
	    mem_unit_data = (mixed_port_feed_through_mode == "dont_care") ? {data_width{1'bx}} : old_mem_data;
        else
            mem_unit_data = mem[row_sec];
        for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
            read_unit_data_latch[j - col_sec] = mem_unit_data[j];
        read_pulse_sec_last_value = read_pulse_sec;
    end
end

// Simultaneous write to same/overlapping location by both ports
always @(dual_write)
begin
    if (dual_write == 2'b11)
    begin
           for (i = 0; i < data_unit_width; i = i + 1)
               mask_vector_common_int[i] = mask_vector_prime_int[col_sec + i] &
                                           mask_vector_sec_int[i];
    end
    else if (dual_write == 2'b01) mem_unit_data = mem[row_sec];
    else if (dual_write == 'b0)
    begin
       mem_data = mem[addr_prime_reg];
       for (i = 0; i < data_unit_width; i = i + 1)
               mem_data[col_sec + i] = mem_data[col_sec + i] ^ mask_vector_common_int[i];
       mem[addr_prime_reg] = mem_data;
    end
end

// Write stage 2 : Write actual data to memory
always @(negedge write_pulse_prime)
begin
    if (clear_asserted_during_write[`PRIME] !== 1'b1)
    begin
        for (i = 0; i < data_width; i = i + 1)
            if (mask_vector_prime[i] == 1'b0)
                mem_data[i] = datain_prime_reg[i];
        mem[addr_prime_reg] = mem_data;
    end
    dual_write[`PRIME] = 1'b0;
end

always @(negedge write_pulse_sec)
begin
    if (clear_asserted_during_write[`SEC] !== 1'b1)
    begin
        for (i = 0; i < data_unit_width; i = i + 1)
            if (mask_vector_sec[i] == 1'b0)
                mem_unit_data[col_sec + i] = datain_sec_reg[i];
        mem[row_sec] = mem_unit_data;
    end
    dual_write[`SEC] = 1'b0;
end

always @(negedge read_pulse_prime) read_pulse_prime_last_value = 1'b0;
always @(negedge read_pulse_sec)   read_pulse_sec_last_value = 1'b0;
always @(negedge rw_pulse_prime)   rw_pulse_prime_last_value = 1'b0;
always @(negedge rw_pulse_sec)     rw_pulse_sec_last_value = 1'b0;


// Read stage 2 : Send data to output
always @(negedge read_pulse_prime)
begin
    if (primary_port_is_a)
        dataout_a = read_data_latch;
    else
        dataout_b = read_data_latch;
end

always @(negedge read_pulse_sec)
begin
    if (primary_port_is_b)
        dataout_a = read_unit_data_latch;
    else
        dataout_b = read_unit_data_latch;
end

// Read during Write stage 2 : Send data to output

always @(negedge rw_pulse_prime)
begin
   if (primary_port_is_a)
   begin
       // BE mask write
       if (be_mask_write_a)
       begin
           for (i = 0; i < data_width; i = i + 1)
               if (mask_vector_prime[i] === 1'bx) // disabled byte
                   dataout_a[i] = read_data_latch[i];
       end
       else
           dataout_a = read_data_latch;
   end
   else
   begin
       // BE mask write
       if (be_mask_write_b)
       begin
           for (i = 0; i < data_width; i = i + 1)
               if (mask_vector_prime[i] === 1'bx) // disabled byte
                   dataout_b[i] = read_data_latch[i];
       end
       else
           dataout_b = read_data_latch;
   end
end

always @(negedge rw_pulse_sec)
begin
    if (primary_port_is_b)
    begin
        // BE mask write
        if (be_mask_write_a)
        begin
            for (i = 0; i < data_unit_width; i = i + 1)
                if (mask_vector_sec[i] === 1'bx) // disabled byte
                    dataout_a[i] = read_unit_data_latch[i];
        end
        else
            dataout_a = read_unit_data_latch;
    end
    else
    begin
        // BE mask write
        if (be_mask_write_b)
        begin
            for (i = 0; i < data_unit_width; i = i + 1)
                if (mask_vector_sec[i] === 1'bx) // disabled byte
                    dataout_b[i] = read_unit_data_latch[i];
        end
        else
            dataout_b = read_unit_data_latch;
    end
end

// Same port feed through
common_28nm_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in),
           .ena(active_a_core & ~mode_is_dp & ~old_data_write_a & we_a_reg & re_a_reg & (~dataout_a_clr || out_a_is_reg)),
        .pulse(read_pulse_a_feedthru),.cycle()
        );

common_28nm_ram_pulse_generator ftpgen_b (
        .clk(clk_b_in),
           .ena(active_b_core & mode_is_bdp & ~old_data_write_b & we_b_reg & re_b_reg & (~dataout_b_clr || out_b_is_reg)),
        .pulse(read_pulse_b_feedthru),.cycle()
        );

always @(negedge read_pulse_prime_feedthru)
begin
    if (primary_port_is_a)
    begin
       if (be_mask_write_a)
       begin
          for (i = 0; i < data_width; i = i + 1)
              if (mask_vector_prime[i] == 1'b0) // enabled byte
                  dataout_a[i] = datain_prime_reg[i];
       end
       else
          dataout_a = datain_prime_reg ^ mask_vector_prime;
    end
    else
    begin
       if (be_mask_write_b)
       begin
          for (i = 0; i < data_width; i = i + 1)
              if (mask_vector_prime[i] == 1'b0) // enabled byte
                  dataout_b[i] = datain_prime_reg[i];
       end
       else
          dataout_b = datain_prime_reg ^ mask_vector_prime;
    end
end

always @(negedge read_pulse_sec_feedthru)
begin
    if (primary_port_is_b)
    begin
       if (be_mask_write_a)
       begin
          for (i = 0; i < data_unit_width; i = i + 1)
              if (mask_vector_sec[i] == 1'b0) // enabled byte
                  dataout_a[i] = datain_sec_reg[i];
       end
       else
          dataout_a = datain_sec_reg ^ mask_vector_sec;
    end
    else
    begin
       if (be_mask_write_b)
       begin
          for (i = 0; i < data_unit_width; i = i + 1)
              if (mask_vector_sec[i] == 1'b0) // enabled byte
                  dataout_b[i] = datain_sec_reg[i];
       end
       else
          dataout_b = datain_sec_reg ^ mask_vector_sec;
    end
end

// Input register clears

always @(posedge addr_a_clr or posedge datain_a_clr or posedge we_a_clr)
    clear_asserted_during_write_a = write_pulse_a;

assign active_write_clear_a = active_write_a & write_cycle_a;

always @(posedge addr_a_clr)
begin
    if (active_write_clear_a & we_a_reg)
        mem_invalidate = 1'b1;
 else if (active_a_core & re_a_reg)
    begin
        if (primary_port_is_a)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
        dataout_a = 'bx;
    end
end

always @(posedge datain_a_clr or posedge we_a_clr)
begin
    if (active_write_clear_a & we_a_reg)
    begin
        if (primary_port_is_a)
            mem[addr_prime_reg] = 'bx;
        else
        begin
            mem_unit_data = mem[row_sec];
            for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
                mem_unit_data[j] = 1'bx;
            mem[row_sec] = mem_unit_data;
        end
        if (primary_port_is_a)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
    end
end

assign active_write_clear_b = active_write_b & write_cycle_b;

always @(posedge addr_b_clr or posedge datain_b_clr or
        posedge we_b_clr)
    clear_asserted_during_write_b = write_pulse_b;

always @(posedge addr_b_clr)
begin
   if (mode_is_bdp & active_write_clear_b & we_b_reg)
        mem_invalidate = 1'b1;
  else if ((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg)
    begin
        if (primary_port_is_b)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
        dataout_b = 'bx;
    end
end

always @(posedge datain_b_clr or posedge we_b_clr)
begin
   if (mode_is_bdp & active_write_clear_b & we_b_reg)

    begin
        if (primary_port_is_b)
            mem[addr_prime_reg] = 'bx;
        else
        begin
            mem_unit_data = mem[row_sec];
            for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
                 mem_unit_data[j] = 'bx;
            mem[row_sec] = mem_unit_data;
        end
        if (primary_port_is_b)
        begin
            read_data_latch = 'bx;
        end
        else
        begin
            read_unit_data_latch = 'bx;
        end
    end
end

assign clear_asserted_during_write[primary_port_is_a] = clear_asserted_during_write_a;
assign clear_asserted_during_write[primary_port_is_b] = clear_asserted_during_write_b;

always @(posedge mem_invalidate)
begin
    for (i = 0; i < num_rows; i = i + 1) mem[i] = 'bx;
    mem_invalidate = 1'b0;
end

 // ------- Aclr mux registers (Latch Clear) --------
 // port A
 common_28nm_ram_register aclr__a__mux_register (
        .d(dataout_a_clr),
        .clk(clk_a_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(1'b1),
        .q(dataout_a_clr_reg),.aclrout()
        );
 // port B
 common_28nm_ram_register aclr__b__mux_register (
        .d(dataout_b_clr),
        .clk(clk_b_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(1'b1),
        .q(dataout_b_clr_reg),.aclrout()
        );


// ------- ECC Pipeline registers --------

common_28nm_ram_register ecc_pipeline_b_register (
        .d( dataout_b ),
        .clk(clk_b_out),
 	.aclr(dataout_b_clr_reg),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(ecc_pipeline_b_reg),.aclrout()
        );
defparam ecc_pipeline_b_register.width = port_b_data_width;

assign dataout_b_signal = (enable_ecc == "true" && ecc_pipeline_stage_enabled == "true") ? ecc_pipeline_b_reg : dataout_b ;

// ------- Output registers --------

assign clkena_a_out = (port_a_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

common_28nm_ram_register dataout_a_register (
        .d(dataout_a_in_reg),
        .clk(clk_a_out),
 	.aclr(dataout_a_clr),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(clkena_a_out),
        .q(dataout_a_reg),.aclrout()
        );
defparam dataout_a_register.width = port_a_data_width;

 reg [port_a_data_width - 1:0] portadataout_clr;
 reg [port_b_data_width - 1:0] portbdataout_clr;
 initial
 begin
     portadataout_clr = 'b0;
     portbdataout_clr = 'b0;
 end

 assign portadataout =  (out_a_is_reg) ? dataout_a_reg : (
                            (dataout_a_clr || dataout_a_clr_reg) ? portadataout_clr : dataout_a_in_reg
                       );

assign clkena_b_out = (port_b_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

common_28nm_ram_register dataout_b_register (
        .d( dataout_b_in_reg ),
        .clk(clk_b_out),
 	.aclr(dataout_b_clr),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(dataout_b_reg),.aclrout()
        );
defparam dataout_b_register.width = port_b_data_width;

 assign portbdataout = (out_b_is_reg) ? dataout_b_reg : (
                          (dataout_b_clr || dataout_b_clr_reg) ? portbdataout_clr : dataout_b_in_reg
                      );

assign eccstatus = {width_eccstatus{1'b0}};

endmodule // common_28nm_ram_block

//--------------------------------------------------------------------------
// Module Name     : generic_m20k
// Description     : Wrapper around the common 28nm RAM block
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_m20k
    (
     portadatain,
     portaaddr,
     portawe,
     portare,
     portbdatain,
     portbaddr,
     portbwe,
     portbre,
     clk0, clk1,
     ena0, ena1,
     ena2, ena3,
     clr0, clr1,
     nerror,
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     eccstatus,
     portadataout,
     portbdataout
      ,dftout
     );
// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";
parameter ram_block_type = "auto";
parameter logical_ram_name = "ram_name";

parameter init_file = "init_file.hex";
parameter init_file_layout = "none";

parameter ecc_pipeline_stage_enabled = "false";
parameter enable_ecc = "false";
parameter width_eccstatus = 2;
parameter data_interleave_width_in_bits = 1;
parameter data_interleave_offset_in_bits = 1;
parameter port_a_logical_ram_depth = 0;
parameter port_a_logical_ram_width = 0;
parameter port_a_first_address = 0;
parameter port_a_last_address = 0;
parameter port_a_first_bit_number = 0;

parameter port_a_data_out_clear = "none";

parameter port_a_data_out_clock = "none";

parameter port_a_data_width = 1;
parameter port_a_address_width = 1;
parameter port_a_byte_enable_mask_width = 1;

parameter port_b_logical_ram_depth = 0;
parameter port_b_logical_ram_width = 0;
parameter port_b_first_address = 0;
parameter port_b_last_address = 0;
parameter port_b_first_bit_number = 0;

parameter port_b_address_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_write_enable_clock = "clock1";
parameter port_b_read_enable_clock  = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter port_a_read_during_write_mode = "new_data_no_nbe_read";
parameter port_b_read_during_write_mode = "new_data_no_nbe_read";
parameter power_up_uninitialized = "false";
parameter lpm_type = "stratixv_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

parameter mem_init0 = "";
parameter mem_init1 = "";
parameter mem_init2 = "";
parameter mem_init3 = "";
parameter mem_init4 = "";
parameter mem_init5 = "";
parameter mem_init6 = "";
parameter mem_init7 = "";
parameter mem_init8 = "";
parameter mem_init9 = "";

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

parameter bist_ena = "false"; //false, true 

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input portare;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbwe, portbre;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;
input ena2,ena3;
input nerror;

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;
output [width_eccstatus - 1:0] eccstatus;
output [8:0] dftout;


// -------- RAM BLOCK INSTANTIATION ---
common_28nm_ram_block ram_core0
(
	.portawe(portawe),
	.portare(portare),
	.portadatain(portadatain),
	.portaaddr(portaaddr),
	.portabyteenamasks(portabyteenamasks),
	.portbwe(portbwe),
	.portbre(portbre),
	.portbdatain(portbdatain),
	.portbaddr(portbaddr),
	.portbbyteenamasks(portbbyteenamasks),
	.clr0(clr0),
	.clr1(clr1),
	.clk0(clk0),
	.clk1(clk1),
	.ena0(ena0),
	.ena1(ena1),
	.ena2(ena2),
	.ena3(ena3),
	.nerror(nerror),
	.devclrn(devclrn),
	.devpor(devpor),
	.portaaddrstall(portaaddrstall),
	.portbaddrstall(portbaddrstall),
	.portadataout(portadataout),
	.portbdataout(portbdataout),
	.eccstatus(eccstatus),
	.dftout(dftout)
);
defparam ram_core0.operation_mode = operation_mode;
defparam ram_core0.mixed_port_feed_through_mode = mixed_port_feed_through_mode;
defparam ram_core0.ram_block_type = ram_block_type;
defparam ram_core0.logical_ram_name = logical_ram_name;
defparam ram_core0.init_file = init_file;
defparam ram_core0.init_file_layout = init_file_layout;
defparam ram_core0.ecc_pipeline_stage_enabled = ecc_pipeline_stage_enabled;
defparam ram_core0.enable_ecc = enable_ecc;
defparam ram_core0.width_eccstatus = width_eccstatus;
defparam ram_core0.data_interleave_width_in_bits = data_interleave_width_in_bits;
defparam ram_core0.data_interleave_offset_in_bits = data_interleave_offset_in_bits;
defparam ram_core0.port_a_logical_ram_depth = port_a_logical_ram_depth;
defparam ram_core0.port_a_logical_ram_width = port_a_logical_ram_width;
defparam ram_core0.port_a_first_address = port_a_first_address;
defparam ram_core0.port_a_last_address = port_a_last_address;
defparam ram_core0.port_a_first_bit_number = port_a_first_bit_number;
defparam ram_core0.port_a_data_out_clear = port_a_data_out_clear;
defparam ram_core0.port_a_data_out_clock = port_a_data_out_clock;
defparam ram_core0.port_a_data_width = port_a_data_width;
defparam ram_core0.port_a_address_width = port_a_address_width;
defparam ram_core0.port_a_byte_enable_mask_width = port_a_byte_enable_mask_width;
defparam ram_core0.port_b_logical_ram_depth = port_b_logical_ram_depth;
defparam ram_core0.port_b_logical_ram_width = port_b_logical_ram_width;
defparam ram_core0.port_b_first_address = port_b_first_address;
defparam ram_core0.port_b_last_address = port_b_last_address;
defparam ram_core0.port_b_first_bit_number = port_b_first_bit_number;
defparam ram_core0.port_b_address_clear = port_b_address_clear;
defparam ram_core0.port_b_data_out_clear = port_b_data_out_clear;
defparam ram_core0.port_b_data_in_clock = port_b_data_in_clock;
defparam ram_core0.port_b_address_clock = port_b_address_clock;
defparam ram_core0.port_b_write_enable_clock = port_b_write_enable_clock;
defparam ram_core0.port_b_read_enable_clock = port_b_read_enable_clock;
defparam ram_core0.port_b_byte_enable_clock = port_b_byte_enable_clock;
defparam ram_core0.port_b_data_out_clock = port_b_data_out_clock;
defparam ram_core0.port_b_data_width = port_b_data_width;
defparam ram_core0.port_b_address_width = port_b_address_width;
defparam ram_core0.port_b_byte_enable_mask_width = port_b_byte_enable_mask_width;
defparam ram_core0.port_a_read_during_write_mode = port_a_read_during_write_mode;
defparam ram_core0.port_b_read_during_write_mode = port_b_read_during_write_mode;
defparam ram_core0.power_up_uninitialized = power_up_uninitialized;
defparam ram_core0.lpm_type = lpm_type;
defparam ram_core0.lpm_hint = lpm_hint;
defparam ram_core0.connectivity_checking = connectivity_checking;
defparam ram_core0.mem_init0 = mem_init0;
defparam ram_core0.mem_init1 = mem_init1;
defparam ram_core0.mem_init2 = mem_init2;
defparam ram_core0.mem_init3 = mem_init3;
defparam ram_core0.mem_init4 = mem_init4;
defparam ram_core0.mem_init5 = mem_init5;
defparam ram_core0.mem_init6 = mem_init6;
defparam ram_core0.mem_init7 = mem_init7;
defparam ram_core0.mem_init8 = mem_init8;
defparam ram_core0.mem_init9 = mem_init9;
defparam ram_core0.port_a_byte_size = port_a_byte_size;
defparam ram_core0.port_b_byte_size = port_b_byte_size;
defparam ram_core0.clk0_input_clock_enable = clk0_input_clock_enable;
defparam ram_core0.clk0_core_clock_enable = clk0_core_clock_enable ;
defparam ram_core0.clk0_output_clock_enable = clk0_output_clock_enable;
defparam ram_core0.clk1_input_clock_enable = clk1_input_clock_enable;
defparam ram_core0.clk1_core_clock_enable = clk1_core_clock_enable;
defparam ram_core0.clk1_output_clock_enable = clk1_output_clock_enable;
defparam ram_core0.bist_ena = bist_ena;
defparam ram_core0.port_a_address_clear = port_a_address_clear;
defparam ram_core0.port_a_data_in_clock = port_a_data_in_clock;
defparam ram_core0.port_a_address_clock = port_a_address_clock;
defparam ram_core0.port_a_write_enable_clock = port_a_write_enable_clock;
defparam ram_core0.port_a_byte_enable_clock = port_a_byte_enable_clock;
defparam ram_core0.port_a_read_enable_clock = port_a_read_enable_clock;

endmodule // m20k_ram_block


//--------------------------------------------------------------------------
// Module Name     : generic_m10k
// Description     : Wrapper around the common 28nm RAM block
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_m10k
    (
     portadatain,
     portaaddr,
     portawe,
     portare,
     portbdatain,
     portbaddr,
     portbwe,
     portbre,
     clk0, clk1,
     ena0, ena1,
     ena2, ena3,
     clr0, clr1,
     nerror,
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     eccstatus,
     portadataout,
     portbdataout
      ,dftout
     );
// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";
parameter ram_block_type = "auto";
parameter logical_ram_name = "ram_name";

parameter init_file = "init_file.hex";
parameter init_file_layout = "none";

parameter ecc_pipeline_stage_enabled = "false";
parameter enable_ecc = "false";
parameter width_eccstatus = 2;
parameter data_interleave_width_in_bits = 1;
parameter data_interleave_offset_in_bits = 1;
parameter port_a_logical_ram_depth = 0;
parameter port_a_logical_ram_width = 0;
parameter port_a_first_address = 0;
parameter port_a_last_address = 0;
parameter port_a_first_bit_number = 0;

parameter port_a_data_out_clear = "none";

parameter port_a_data_out_clock = "none";

parameter port_a_data_width = 1;
parameter port_a_address_width = 1;
parameter port_a_byte_enable_mask_width = 1;

parameter port_b_logical_ram_depth = 0;
parameter port_b_logical_ram_width = 0;
parameter port_b_first_address = 0;
parameter port_b_last_address = 0;
parameter port_b_first_bit_number = 0;

parameter port_b_address_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_write_enable_clock = "clock1";
parameter port_b_read_enable_clock  = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter port_a_read_during_write_mode = "new_data_no_nbe_read";
parameter port_b_read_during_write_mode = "new_data_no_nbe_read";
parameter power_up_uninitialized = "false";
parameter lpm_type = "arriav_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

parameter mem_init0 = "";
parameter mem_init1 = "";
parameter mem_init2 = "";
parameter mem_init3 = "";
parameter mem_init4 = "";

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

parameter bist_ena = "false"; //false, true 

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input portare;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbwe, portbre;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;
input ena2,ena3;
input nerror;

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;
output [width_eccstatus - 1:0] eccstatus;
output [8:0] dftout;


// -------- RAM BLOCK INSTANTIATION ---
common_28nm_ram_block ram_core0
(
	.portawe(portawe),
	.portare(portare),
	.portadatain(portadatain),
	.portaaddr(portaaddr),
	.portabyteenamasks(portabyteenamasks),
	.portbwe(portbwe),
	.portbre(portbre),
	.portbdatain(portbdatain),
	.portbaddr(portbaddr),
	.portbbyteenamasks(portbbyteenamasks),
	.clr0(clr0),
	.clr1(clr1),
	.clk0(clk0),
	.clk1(clk1),
	.ena0(ena0),
	.ena1(ena1),
	.ena2(ena2),
	.ena3(ena3),
	.nerror(nerror),
	.devclrn(devclrn),
	.devpor(devpor),
	.portaaddrstall(portaaddrstall),
	.portbaddrstall(portbaddrstall),
	.portadataout(portadataout),
	.portbdataout(portbdataout),
	.eccstatus(eccstatus),
	.dftout(dftout)
);
defparam ram_core0.operation_mode = operation_mode;
defparam ram_core0.mixed_port_feed_through_mode = mixed_port_feed_through_mode;
defparam ram_core0.ram_block_type = ram_block_type;
defparam ram_core0.logical_ram_name = logical_ram_name;
defparam ram_core0.init_file = init_file;
defparam ram_core0.init_file_layout = init_file_layout;
defparam ram_core0.ecc_pipeline_stage_enabled = "false";
defparam ram_core0.enable_ecc = "false";
defparam ram_core0.width_eccstatus = width_eccstatus;
defparam ram_core0.data_interleave_width_in_bits = data_interleave_width_in_bits;
defparam ram_core0.data_interleave_offset_in_bits = data_interleave_offset_in_bits;
defparam ram_core0.port_a_logical_ram_depth = port_a_logical_ram_depth;
defparam ram_core0.port_a_logical_ram_width = port_a_logical_ram_width;
defparam ram_core0.port_a_first_address = port_a_first_address;
defparam ram_core0.port_a_last_address = port_a_last_address;
defparam ram_core0.port_a_first_bit_number = port_a_first_bit_number;
defparam ram_core0.port_a_data_out_clear = port_a_data_out_clear;
defparam ram_core0.port_a_data_out_clock = port_a_data_out_clock;
defparam ram_core0.port_a_data_width = port_a_data_width;
defparam ram_core0.port_a_address_width = port_a_address_width;
defparam ram_core0.port_a_byte_enable_mask_width = port_a_byte_enable_mask_width;
defparam ram_core0.port_b_logical_ram_depth = port_b_logical_ram_depth;
defparam ram_core0.port_b_logical_ram_width = port_b_logical_ram_width;
defparam ram_core0.port_b_first_address = port_b_first_address;
defparam ram_core0.port_b_last_address = port_b_last_address;
defparam ram_core0.port_b_first_bit_number = port_b_first_bit_number;
defparam ram_core0.port_b_address_clear = port_b_address_clear;
defparam ram_core0.port_b_data_out_clear = port_b_data_out_clear;
defparam ram_core0.port_b_data_in_clock = port_b_data_in_clock;
defparam ram_core0.port_b_address_clock = port_b_address_clock;
defparam ram_core0.port_b_write_enable_clock = port_b_write_enable_clock;
defparam ram_core0.port_b_read_enable_clock = port_b_read_enable_clock;
defparam ram_core0.port_b_byte_enable_clock = port_b_byte_enable_clock;
defparam ram_core0.port_b_data_out_clock = port_b_data_out_clock;
defparam ram_core0.port_b_data_width = port_b_data_width;
defparam ram_core0.port_b_address_width = port_b_address_width;
defparam ram_core0.port_b_byte_enable_mask_width = port_b_byte_enable_mask_width;
defparam ram_core0.port_a_read_during_write_mode = port_a_read_during_write_mode;
defparam ram_core0.port_b_read_during_write_mode = port_b_read_during_write_mode;
defparam ram_core0.power_up_uninitialized = power_up_uninitialized;
defparam ram_core0.lpm_type = lpm_type;
defparam ram_core0.lpm_hint = lpm_hint;
defparam ram_core0.connectivity_checking = connectivity_checking;
defparam ram_core0.mem_init0 = mem_init0;
defparam ram_core0.mem_init1 = mem_init1;
defparam ram_core0.mem_init2 = mem_init2;
defparam ram_core0.mem_init3 = mem_init3;
defparam ram_core0.mem_init4 = mem_init4;
defparam ram_core0.port_a_byte_size = port_a_byte_size;
defparam ram_core0.port_b_byte_size = port_b_byte_size;
defparam ram_core0.clk0_input_clock_enable = clk0_input_clock_enable;
defparam ram_core0.clk0_core_clock_enable = clk0_core_clock_enable ;
defparam ram_core0.clk0_output_clock_enable = clk0_output_clock_enable;
defparam ram_core0.clk1_input_clock_enable = clk1_input_clock_enable;
defparam ram_core0.clk1_core_clock_enable = clk1_core_clock_enable;
defparam ram_core0.clk1_output_clock_enable = clk1_output_clock_enable;
defparam ram_core0.bist_ena = bist_ena;
defparam ram_core0.port_a_address_clear = port_a_address_clear;
defparam ram_core0.port_a_data_in_clock = port_a_data_in_clock;
defparam ram_core0.port_a_address_clock = port_a_address_clock;
defparam ram_core0.port_a_write_enable_clock = port_a_write_enable_clock;
defparam ram_core0.port_a_byte_enable_clock = port_a_byte_enable_clock;
defparam ram_core0.port_a_read_enable_clock = port_a_read_enable_clock;

endmodule // m10k

// Activate again the LEDA rule that requires uppercase letters for all
// parameter names
// leda rule_G_521_3_B on





//--------------------------------------------------------------------------
// Module Name     : common_28nm_mlab_cell_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------
`timescale 1 ps/1 ps

module common_28nm_mlab_cell_pulse_generator (
                                    clk,
                                    ena,     
                                    pulse,
                                    cycle    
                                   );
input  clk;   // clock
input  ena;   // pulse enable
output pulse; // pulse
output cycle; // delayed clock

reg  state;
reg  clk_prev;
wire clk_ipd;

specify
    specparam t_decode = 0,t_access = 0;
    (posedge clk => (pulse +: state)) = (t_decode,t_access);
endspecify

buf #(1) (clk_ipd,clk);
wire  pulse_opd;

buf buf_pulse  (pulse,pulse_opd);

initial clk_prev = 1'bx;

always @(clk_ipd or posedge pulse) 
begin
    if      (pulse) state <= 1'b0;
    else if (ena && clk_ipd === 1'b1 && clk_prev === 1'b0)   state <= 1'b1;
    clk_prev = clk_ipd;
end

assign cycle = clk_ipd;
assign pulse_opd = state; 

endmodule


//--------------------------------------------------------------------------
// Module Name     : common_28nm_mlab_cell
// Description     : Main RAM module
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module common_28nm_mlab_cell
    (
     portadatain,
     portaaddr, 
     portabyteenamasks, 
     portbaddr,
     clk0, clk1,
     ena0, ena1,
     ena2,
     clr,
     devclrn,
     devpor,
     portbdataout
     );

// -------- PACKAGES ------------------

import altera_lnsim_functions::*;

// -------- GLOBAL PARAMETERS ---------

parameter logical_ram_name = "lutram";

parameter logical_ram_depth = 0;
parameter logical_ram_width = 0;
parameter first_address = 0;
parameter last_address = 0;
parameter first_bit_number = 0;

parameter mixed_port_feed_through_mode = "new";
parameter init_file = "NONE";

parameter data_width = 20;
parameter address_width = 6;
parameter byte_enable_mask_width = 1;
parameter byte_size = 1;
parameter port_b_data_out_clock = "none";
parameter port_b_data_out_clear = "none";

parameter lpm_type = "common_28nm_mlab_cell";
parameter lpm_hint = "true";

parameter mem_init0 = "";

// -------- PORT DECLARATIONS ---------
input [data_width - 1:0] portadatain;
input [address_width - 1:0] portaaddr;
input [byte_enable_mask_width - 1:0] portabyteenamasks;
input [address_width - 1:0] portbaddr;

input clk0;
input clk1;

input ena0;
input ena1;
input ena2;

input clr;

input devclrn;
input devpor;

output [data_width - 1:0] portbdataout;

tri1 devclrn;
tri1 devpor;

tri0 [data_width - 1:0] portadatain;
tri0 [address_width - 1:0] portaaddr;
tri1 [byte_enable_mask_width - 1:0] portabyteenamasks;
tri0 clr;
tri0 clk0,clk1;
tri1 ena0,ena1;
tri1 ena2;

// LOCAL_PARAMETERS_BEGIN

parameter MEM_INIT_STRING_LENGTH = 160;
parameter port_byte_size = data_width/byte_enable_mask_width;
parameter num_rows = 1 << address_width;
parameter num_cols = 1;

// LOCAL_PARAMETERS_END

reg ena0_reg;

specify
      (portbaddr *> portbdataout) = (0,0);
endspecify

// -------- INTERNAL signals ---------
// clock / clock enable
wire clk_a_in;
wire clk_b_out;

// asynch clear
wire dataout_b_clr_in;

wire dataout_b_clr;
wire addr_a_clr;
wire datain_a_clr;
wire byteena_a_clr;


// port A registers
wire [address_width - 1:0] addr_a_reg;
wire [data_width - 1:0] datain_a_reg;
wire [byte_enable_mask_width - 1:0] byteena_a_reg;

// port B registers
wire [data_width - 1:0] dataout_b;
wire [data_width - 1:0] dataout_b_reg;
wire [data_width - 1:0] portbdataout_tmp;

// placeholders for read/written data
reg  [data_width - 1:0] mem_data;

// pulses for A/B ports (no read pulse)
wire write_pulse;
wire write_cycle;

// memory core
reg  [data_width - 1:0] mem [num_rows - 1:0];

// byte enable
reg  [data_width - 1:0] mask_vector, mask_vector_int;

// memory initialization
integer i,j,k;
integer addr_range_init;
reg [data_width - 1:0] init_mem_word;
reg [(last_address - first_address + 1)*data_width - 1:0] mem_init;

// port active for read/write
wire  active_a,active_a_in;
wire  active_write_a;

initial
begin
    ena0_reg = 1'b0;

    // powerup output to 0
    for (i = 0; i < num_rows; i = i + 1) 
		mem[i] = {data_width{1'b0}};
    mem_init = strtobits(mem_init0);
    addr_range_init  = last_address - first_address + 1;
    for (j = 0; j < addr_range_init; j = j + 1)
    begin
        for (k = 0; k < data_width; k = k + 1)
            init_mem_word[k] = mem_init[j*data_width + k];
        mem[j] = init_mem_word;
    end
end

assign clk_a_in = clk0;
assign clk_b_out = (port_b_data_out_clock == "clock1") ? clk1 : 1'b0;

always @(posedge clk_a_in) ena0_reg <= ena0;

assign dataout_b_clr_in = (port_b_data_out_clear == "clear") ? clr : 1'b0;

// Port A registers
// address register
common_28nm_ram_register addr_a_register(
        .d(portaaddr),
        .clk(clk_a_in),
		.aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena2),
		.stall(1'b0),
        .q(addr_a_reg),
		.aclrout(addr_a_clr)
        );
defparam addr_a_register.width = address_width;

// data register
common_28nm_ram_register datain_a_register(
        .d(portadatain),
        .clk(clk_a_in),
		.aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena2),
		.stall(1'b0),
        .q(datain_a_reg),
		.aclrout(datain_a_clr)
        );
defparam datain_a_register.width = data_width;

// byte enable register
common_28nm_ram_register byteena_a_register(
        .d(portabyteenamasks),
        .clk(clk_a_in),
		.aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena2),
		.stall(1'b0),
        .q(byteena_a_reg),
		.aclrout(byteena_a_clr)
        );
defparam byteena_a_register.width = byte_enable_mask_width;

// data register
common_28nm_ram_register data_b_register(
        .d(dataout_b),
        .clk(clk_b_out),
		.aclr(dataout_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena1),
		.stall(1'b0),
        .q(dataout_b_reg),
		.aclrout(dataout_b_clr)
        );
defparam data_b_register.width = data_width;

// Write pulse generation
common_28nm_mlab_cell_pulse_generator wpgen_a (
        .clk(clk_a_in),
        .ena(ena0_reg),
        .pulse(write_pulse),
	    .cycle(write_cycle)
        );

// Read pulse generation
// -- none --

// Create internal masks for byte enable processing
always @(byteena_a_reg)
begin
	for (i = 0; i < data_width; i = i + 1)
	begin
		if (port_byte_size == 0)
		begin
			$display("Error: Parameter data_width is smaller than parameter byte_enable_mask_width.");
			$display("Time: %0t  Instance: %m", $time);
			$finish;
		end
		if (byteena_a_reg[i/port_byte_size] === 1'b1)
			mask_vector[i] = 1'b0;
		else
			mask_vector[i] = 1'bx;

		if (byteena_a_reg[i/port_byte_size] === 1'b0)
			mask_vector_int[i] = 1'b0;
		else
			mask_vector_int[i] = 1'bx;
	end
end
                        
always @(posedge write_pulse) 
begin
    // Write stage 1 : write X to memory
    if (write_pulse)
    begin
        mem_data = mem[addr_a_reg] ^ mask_vector_int;
        mem[addr_a_reg] = mem_data;
    end
end

// Write stage 2 : Write actual data to memory
always @(negedge write_pulse)
begin
    for (i = 0; i < data_width; i = i + 1)
        if (mask_vector[i] == 1'b0)
            mem_data[i] = datain_a_reg[i];
    mem[addr_a_reg] = mem_data;
end

// Read stage : asynchronous continuous read

assign dataout_b = mem[portbaddr];
assign portbdataout_tmp = (port_b_data_out_clock == "clock1") ? dataout_b_reg : dataout_b;
assign portbdataout = portbdataout_tmp;

endmodule // common_28nm_mlab_cell

//--------------------------------------------------------------------------
// Module Name     : generic_mlab_cell
// Description     : Main RAM module
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module generic_mlab_cell
    (
     portadatain,
     portaaddr, 
     portabyteenamasks, 
     portbaddr,
     clk0, clk1,
     ena0, ena1,
     ena2,
     clr,
     devclrn,
     devpor,
     portbdataout
     );
// -------- GLOBAL PARAMETERS ---------

parameter logical_ram_name = "lutram";

parameter logical_ram_depth = 0;
parameter logical_ram_width = 0;
parameter first_address = 0;
parameter last_address = 0;
parameter first_bit_number = 0;

parameter mixed_port_feed_through_mode = "new";
parameter init_file = "NONE";

parameter data_width = 20;
parameter address_width = 6;
parameter byte_enable_mask_width = 1;
parameter byte_size = 1;
parameter port_b_data_out_clock = "none";
parameter port_b_data_out_clear = "none";

parameter lpm_type = "common_28nm_mlab_cell";
parameter lpm_hint = "true";

parameter mem_init0 = "";

// -------- PORT DECLARATIONS ---------
input [data_width - 1:0] portadatain;
input [address_width - 1:0] portaaddr;
input [byte_enable_mask_width - 1:0] portabyteenamasks;
input [address_width - 1:0] portbaddr;

input clk0;
input clk1;

input ena0;
input ena1;
input ena2;

input clr;

input devclrn;
input devpor;

output [data_width - 1:0] portbdataout;

common_28nm_mlab_cell my_lutram0
(
	.portadatain(portadatain),
	.portaaddr(portaaddr),
	.portabyteenamasks(portabyteenamasks),
	.portbaddr(portbaddr),
	.clk0(clk0),
	.clk1(clk1),
	.ena0(ena0),
	.ena1(ena1),
	.ena2(ena2),
	.clr(clr),
	.devclrn(devclrn),
	.devpor(devpor),
	.portbdataout(portbdataout)
);
defparam my_lutram0.logical_ram_name = logical_ram_name;
defparam my_lutram0.logical_ram_depth = logical_ram_depth;
defparam my_lutram0.logical_ram_width = logical_ram_width;
defparam my_lutram0.first_address = first_address;
defparam my_lutram0.last_address = last_address;
defparam my_lutram0.first_bit_number = first_bit_number;
defparam my_lutram0.mixed_port_feed_through_mode = mixed_port_feed_through_mode;
defparam my_lutram0.init_file = init_file;
defparam my_lutram0.data_width = data_width;
defparam my_lutram0.address_width = address_width;
defparam my_lutram0.byte_enable_mask_width = byte_enable_mask_width;
defparam my_lutram0.byte_size = byte_size;
defparam my_lutram0.port_b_data_out_clock = port_b_data_out_clock;
defparam my_lutram0.port_b_data_out_clear = port_b_data_out_clear;
defparam my_lutram0.lpm_type = lpm_type;
defparam my_lutram0.lpm_hint = lpm_hint;
defparam my_lutram0.mem_init0 = mem_init0;

endmodule // generic_mlab_cell
`timescale 1 ps/1 ps
module generic_mux
(
	input wire [63:0] din,
	input wire [5:0] sel,

	output wire dout
);

	assign dout = din[sel];

endmodule
`timescale 1 ps/1 ps
module generic_device_pll
#(
	parameter reference_clock_frequency = "0 ps",
	parameter output_clock_frequency = "0 ps",
	parameter forcelock = "false",
	parameter nreset_invert = "false",
	parameter pll_enable = "false",
	parameter pll_fbclk_mux_1 = "glb",
	parameter pll_fbclk_mux_2 = "fb_1",
	parameter pll_m_cnt_bypass_en = "false",
	parameter pll_m_cnt_hi_div = 1,
	parameter pll_m_cnt_in_src = "ph_mux_clk",
	parameter pll_m_cnt_lo_div = 1,
	parameter pll_n_cnt_bypass_en = "false",
	parameter pll_n_cnt_hi_div = 1,
	parameter pll_n_cnt_lo_div = 1,
	parameter pll_vco_ph0_en = "false",
	parameter pll_vco_ph1_en = "false",
	parameter pll_vco_ph2_en = "false",
	parameter pll_vco_ph3_en = "false",
	parameter pll_vco_ph4_en = "false",
	parameter pll_vco_ph5_en = "false",
	parameter pll_vco_ph6_en = "false",
	parameter pll_vco_ph7_en = "false"
) (
	input	wire			coreclkfb,
	input	wire			fbclkfpll,
	input	wire			lvdsfbin,
	input	wire			nresync,
	input	wire			pfden,
	input	wire			refclkin,
	input	wire			zdb,

	output	wire			fbclk,
	output	wire			fblvdsout,
	output	wire			lock,
	output	wire	[ 7:0 ]	vcoph
);

	import altera_lnsim_functions::*;

	wire fboutclk_wire;
	wire locked_wire;
	wire nresync_wire;
	wire vcoph_0_wire;
	wire vcoph_1_wire;
	wire vcoph_2_wire;
	wire vcoph_3_wire;

	localparam phase_step = get_time_value(output_clock_frequency) / 8;

	//////////////////////////////////////////////////
	// nresync
	//////////////////////////////////////////////////

	assign nresync_wire = pll_enable == "false" ? 1'b0 : nresync;

	//////////////////////////////////////////////////
	// lock
	//////////////////////////////////////////////////
	
	assign lock = forcelock == "true" ? 1'b1 : locked_wire;

	//////////////////////////////////////////////////
	// vcoph[0]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift("0 ps")
	) inst_pll_phase_0 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_0_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire)
	);

	assign vcoph[0] = pll_vco_ph0_en == "true" ? vcoph_0_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[1]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(phase_step, "ps"))
	) inst_pll_phase_1 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_1_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire)
	);

	assign vcoph[1] = pll_vco_ph1_en == "true" ? vcoph_1_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[2]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(phase_step * 2, "ps"))
	) inst_pll_phase_2 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_2_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire)
	);

	assign vcoph[2] = pll_vco_ph2_en == "true" ? vcoph_2_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[3]
	//////////////////////////////////////////////////
	generic_pll
	#(
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(get_time_string(phase_step * 3, "ps"))
	) inst_pll_phase_3 (
		.refclk(refclkin),
		.rst(nresync_wire),
		.fbclk(fboutclk_wire),
		
		.outclk(vcoph_3_wire),
		.locked(locked_wire),
		.fboutclk(fboutclk_wire)
	);

	assign vcoph[3] = pll_vco_ph3_en == "true" ? vcoph_3_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[4]
	//////////////////////////////////////////////////

	assign vcoph[4] = pll_vco_ph4_en == "true" ? !vcoph_0_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[5]
	//////////////////////////////////////////////////

	assign vcoph[5] = pll_vco_ph5_en == "true" ? !vcoph_1_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[6]
	//////////////////////////////////////////////////

	assign vcoph[6] = pll_vco_ph6_en == "true" ? !vcoph_2_wire : 1'b0;

	//////////////////////////////////////////////////
	// vcoph[7]
	//////////////////////////////////////////////////
	
	assign vcoph[7] = pll_vco_ph7_en == "true" ? !vcoph_3_wire : 1'b0;

endmodule

`timescale 1ps/1ps


//--------------------------------------------------------------------------
// Module Name     : altera_mult_add
//
// Description     : Main module for altera_mult_add component
//--------------------------------------------------------------------------
module altera_mult_add (
		dataa, 
		datab,
		datac,
		scanina,
		scaninb,
		sourcea,
		sourceb,
		clock3, 
		clock2, 
		clock1, 
		clock0, 
		aclr3, 
		aclr2, 
		aclr1, 
		aclr0, 
		ena3, 
		ena2, 
		ena1, 
		ena0, 
		signa, 
		signb, 
		addnsub1, 
		addnsub3, 
		result, 
		scanouta, 
		scanoutb,
		mult01_round,
		mult23_round,
		mult01_saturation,
		mult23_saturation,
		addnsub1_round,
		addnsub3_round,
		mult0_is_saturated,
		mult1_is_saturated,
		mult2_is_saturated,
		mult3_is_saturated,
		output_round,
		chainout_round,
		output_saturate,
		chainout_saturate,
		overflow,
		chainout_sat_overflow,
		chainin,
		zero_chainout,
		rotate,
		shift_right,
		zero_loopback,
		accum_sload,
		coefsel0,
		coefsel1,
		coefsel2,
		coefsel3
	);

	//==========================================================
	// Altmult_add parameters declaration
	//==========================================================
	// general setting parameters
	parameter extra_latency                   = 0;
	parameter dedicated_multiplier_circuitry  = "AUTO";
	parameter dsp_block_balancing             = "AUTO";
	parameter selected_device_family          = "Stratix V";
	parameter lpm_type                        = "altmult_add";
	parameter lpm_hint                        = "UNUSED";
	
	
	// Input A related parameters
	parameter width_a  = 1;
	
	parameter input_register_a0  = "CLOCK0";
	parameter input_aclr_a0      = "ACLR0";
	parameter input_source_a0    = "DATAA";

	parameter input_register_a1  = "CLOCK0";
	parameter input_aclr_a1      = "ACLR0";
	parameter input_source_a1    = "DATAA";

	parameter input_register_a2  = "CLOCK0";
	parameter input_aclr_a2      = "ACLR0";
	parameter input_source_a2    = "DATAA";

	parameter input_register_a3  = "CLOCK0";
	parameter input_aclr_a3      = "ACLR0";
	parameter input_source_a3    = "DATAA";
	
	
	// Input B related parameters 
	parameter width_b  = 1;
	
	parameter input_register_b0  = "CLOCK0";
	parameter input_aclr_b0      = "ACLR0";
	parameter input_source_b0    = "DATAB";

	parameter input_register_b1  = "CLOCK0";
	parameter input_aclr_b1      = "ACLR0";
	parameter input_source_b1    = "DATAB";

	parameter input_register_b2  = "CLOCK0";
	parameter input_aclr_b2      = "ACLR0";
	parameter input_source_b2    = "DATAB";

	parameter input_register_b3  = "CLOCK0";
	parameter input_aclr_b3      = "ACLR0";
	parameter input_source_b3    = "DATAB";
	
	
	// Input C related parameters 
	parameter width_c  = 1;
	
	parameter input_register_c0  = "CLOCK0";
	parameter input_aclr_c0      = "ACLR0";
	
	parameter input_register_c1  = "CLOCK0";
	parameter input_aclr_c1      = "ACLR0";
	
	parameter input_register_c2  = "CLOCK0";
	parameter input_aclr_c2      = "ACLR0";
	
	parameter input_register_c3  = "CLOCK0";
	parameter input_aclr_c3      = "ACLR0";
	
	
	// Output related parameters
	parameter width_result     = 34;
	parameter output_register  = "CLOCK0";
	parameter output_aclr      = "ACLR3";
	
	
	// Signed related parameters
	parameter port_signa        = "PORT_CONNECTIVITY";
	parameter representation_a  = "UNSIGNED";
	
	parameter signed_register_a           = "CLOCK0";
	parameter signed_aclr_a               = "ACLR0";
	parameter signed_pipeline_register_a  = "CLOCK0";
	parameter signed_pipeline_aclr_a      = "ACLR3";
	
	parameter port_signb        = "PORT_CONNECTIVITY";
	parameter representation_b  = "UNSIGNED";
	
	parameter signed_register_b           = "CLOCK0";
	parameter signed_aclr_b               = "ACLR0";
	parameter signed_pipeline_register_b  = "CLOCK0";
	parameter signed_pipeline_aclr_b      = "ACLR3";
	
	
	// Multiplier related parameters
	parameter number_of_multipliers  = 1;
	
	parameter multiplier1_direction  = "UNUSED";
	parameter multiplier3_direction  = "UNUSED";
	
	parameter multiplier_register0  = "CLOCK0";
	parameter multiplier_aclr0      = "ACLR3";
	parameter multiplier_register1  = "CLOCK0";
	parameter multiplier_aclr1      = "ACLR3";
	parameter multiplier_register2  = "CLOCK0";
	parameter multiplier_aclr2      = "ACLR3";
	parameter multiplier_register3  = "CLOCK0";
	parameter multiplier_aclr3      = "ACLR3";
	
	
	// Adder related parameters
	parameter port_addnsub1                          = "PORT_CONNECTIVITY";
	parameter addnsub_multiplier_register1           = "CLOCK0";
	parameter addnsub_multiplier_aclr1               = "ACLR3";
	parameter addnsub_multiplier_pipeline_register1  = "CLOCK0";
	parameter addnsub_multiplier_pipeline_aclr1      = "ACLR3";
   
	parameter port_addnsub3                          = "PORT_CONNECTIVITY";
	parameter addnsub_multiplier_register3           = "CLOCK0";
	parameter addnsub_multiplier_aclr3               = "ACLR3";
	parameter addnsub_multiplier_pipeline_register3  = "CLOCK0";
	parameter addnsub_multiplier_pipeline_aclr3      = "ACLR3";

	
	// Rounding related parameters
	parameter adder1_rounding                   = "NO";
	parameter addnsub1_round_register           = "CLOCK0";
	parameter addnsub1_round_aclr               = "ACLR3";
	parameter addnsub1_round_pipeline_register  = "CLOCK0";
	parameter addnsub1_round_pipeline_aclr      = "ACLR3";
	
	parameter adder3_rounding                   = "NO";
	parameter addnsub3_round_register           = "CLOCK0";
	parameter addnsub3_round_aclr               = "ACLR3";
	parameter addnsub3_round_pipeline_register  = "CLOCK0";
	parameter addnsub3_round_pipeline_aclr		  = "ACLR3";
	
	parameter multiplier01_rounding  = "NO";
	parameter mult01_round_register  = "CLOCK0";
	parameter mult01_round_aclr      = "ACLR3";
	
	parameter multiplier23_rounding  = "NO";
	parameter mult23_round_register  = "CLOCK0";
	parameter mult23_round_aclr      = "ACLR3";
	
	parameter width_msb                       = 17;
	
	parameter output_rounding                 = "NO";
	parameter output_round_type               = "NEAREST_INTEGER";
	parameter output_round_register           = "UNREGISTERED";
	parameter output_round_aclr               = "NONE";
	parameter output_round_pipeline_register  = "UNREGISTERED";
	parameter output_round_pipeline_aclr      = "NONE";
	
	parameter chainout_rounding                 = "NO";
	parameter chainout_round_register           = "UNREGISTERED";
	parameter chainout_round_aclr               = "NONE";
	parameter chainout_round_pipeline_register  = "UNREGISTERED";
	parameter chainout_round_pipeline_aclr      = "NONE";
	parameter chainout_round_output_register    = "UNREGISTERED";
	parameter chainout_round_output_aclr        = "NONE";
	
	
	// Saturation related parameters
	parameter multiplier01_saturation     = "NO";
	parameter mult01_saturation_register  = "CLOCK0";
	parameter mult01_saturation_aclr      = "ACLR3";
	
	parameter multiplier23_saturation     = "NO";
	parameter mult23_saturation_register  = "CLOCK0";
	parameter mult23_saturation_aclr      = "ACLR3";
	
	parameter port_mult0_is_saturated  = "UNUSED";
	parameter port_mult1_is_saturated  = "UNUSED";
	parameter port_mult2_is_saturated  = "UNUSED";
	parameter port_mult3_is_saturated  = "UNUSED";
	
	parameter width_saturate_sign = 1;
	
	parameter output_saturation                  = "NO";
	parameter port_output_is_overflow            = "PORT_UNUSED";
	parameter output_saturate_type               = "ASYMMETRIC";
	parameter output_saturate_register           = "UNREGISTERED";
	parameter output_saturate_aclr               = "NONE";
	parameter output_saturate_pipeline_register  = "UNREGISTERED";
	parameter output_saturate_pipeline_aclr      = "NONE";
	
	parameter chainout_saturation                  = "NO";
	parameter port_chainout_sat_is_overflow        = "PORT_UNUSED";
	parameter chainout_saturate_register           = "UNREGISTERED";
	parameter chainout_saturate_aclr               = "NONE";
	parameter chainout_saturate_pipeline_register  = "UNREGISTERED";
	parameter chainout_saturate_pipeline_aclr      = "NONE";
	parameter chainout_saturate_output_register    = "UNREGISTERED";
	parameter chainout_saturate_output_aclr        = "NONE";
	
	
	// Scanchain related parameters
	parameter scanouta_register  = "UNREGISTERED";
	parameter scanouta_aclr      = "NONE";
	
	
	// Chain (chainin and chainout) related parameters
	parameter width_chainin  = 1;
	
	parameter chainout_adder     = "NO";
	parameter chainout_register  = "UNREGISTERED";
	parameter chainout_aclr      = "ACLR3";
	
	parameter zero_chainout_output_register  = "UNREGISTERED";
	parameter zero_chainout_output_aclr      = "NONE";
	
	
	// Rotate & shift related parameters
	parameter shift_mode  = "NO";
	
	parameter rotate_register           = "UNREGISTERED";
	parameter rotate_aclr               = "NONE";
	parameter rotate_pipeline_register  = "UNREGISTERED";
	parameter rotate_pipeline_aclr      = "NONE";
	parameter rotate_output_register    = "UNREGISTERED";
	parameter rotate_output_aclr        = "NONE";
	
	parameter shift_right_register           = "UNREGISTERED";
	parameter shift_right_aclr               = "NONE";
	parameter shift_right_pipeline_register  = "UNREGISTERED";
	parameter shift_right_pipeline_aclr      = "NONE";
	parameter shift_right_output_register    = "UNREGISTERED";
	parameter shift_right_output_aclr        = "NONE";
	
	
	// Loopback related parameters
	parameter zero_loopback_register           = "UNREGISTERED";
	parameter zero_loopback_aclr               = "NONE";
	parameter zero_loopback_pipeline_register  = "UNREGISTERED";
	parameter zero_loopback_pipeline_aclr      = "NONE";
	parameter zero_loopback_output_register    = "UNREGISTERED";
	parameter zero_loopback_output_aclr        = "NONE";
	
	
	// Accumulator and loadconst related parameters
	parameter accumulator      = "NO";
	parameter accum_direction  = "ADD";
	parameter loadconst_value = 0;
	
	parameter accum_sload_register           = "UNREGISTERED";
	parameter accum_sload_aclr               = "NONE";
	parameter accum_sload_pipeline_register  = "UNREGISTERED";
	parameter accum_sload_pipeline_aclr      = "NONE";
	
	parameter loadconst_control_register = "CLOCK0";
	parameter loadconst_control_aclr	 = "ACLR0";
	
	
	// Systolic related parameters
	parameter systolic_delay1 = "UNREGISTERED";
	parameter systolic_delay3 = "UNREGISTERED";
	parameter systolic_aclr1 = "NONE";
	parameter systolic_aclr3 = "NONE";
	
	// Preadder related parameters
	parameter preadder_mode  = "SIMPLE";
	
	parameter preadder_direction_0  = "ADD";
	parameter preadder_direction_1  = "ADD";
	parameter preadder_direction_2  = "ADD";
	parameter preadder_direction_3  = "ADD";
	
	parameter width_coef  = 1;
	
	parameter coefsel0_register  = "CLOCK0";
	parameter coefsel0_aclr	     = "ACLR0";
	parameter coefsel1_register  = "CLOCK0";
	parameter coefsel1_aclr	     = "ACLR0";
	parameter coefsel2_register  = "CLOCK0";
	parameter coefsel2_aclr	     = "ACLR0";
	parameter coefsel3_register  = "CLOCK0";
	parameter coefsel3_aclr	     = "ACLR0";

	parameter coef0_0  = 0;
	parameter coef0_1  = 0;
	parameter coef0_2  = 0;
	parameter coef0_3  = 0;
	parameter coef0_4  = 0;
	parameter coef0_5  = 0;
	parameter coef0_6  = 0;
	parameter coef0_7  = 0;

	parameter coef1_0  = 0;
	parameter coef1_1  = 0;
	parameter coef1_2  = 0;
	parameter coef1_3  = 0;
	parameter coef1_4  = 0;
	parameter coef1_5  = 0;
	parameter coef1_6  = 0;
	parameter coef1_7  = 0;

	parameter coef2_0  = 0;
	parameter coef2_1  = 0;
	parameter coef2_2  = 0;
	parameter coef2_3  = 0;
	parameter coef2_4  = 0;
	parameter coef2_5  = 0;
	parameter coef2_6  = 0;
	parameter coef2_7  = 0;

	parameter coef3_0  = 0;
	parameter coef3_1  = 0;
	parameter coef3_2  = 0;
	parameter coef3_3  = 0;
	parameter coef3_4  = 0;
	parameter coef3_5  = 0;
	parameter coef3_6  = 0;
	parameter coef3_7  = 0;
	
	
	//==========================================================
	// Internal parameters declaration
	//==========================================================
	// Width related parameters
		// Register related width parameters
		parameter width_clock_all_wire_msb = 3;   // Clock wire total width
		parameter width_aclr_all_wire_msb = 3;    // Aclr wire total width
		parameter width_ena_all_wire_msb = 3;     // Clock enable wire total width
		
		// Data input width related parameters
		parameter width_a_total_msb  = (width_a * number_of_multipliers) - 1;   // Total width of dataa input
		parameter width_a_msb  = width_a - 1;     // MSB for splited dataa width
		
		parameter width_b_total_msb  = (width_b * number_of_multipliers) - 1;   // Total width of data input
		parameter width_b_msb  = width_b - 1;     // MSB for splited datab width
		
		parameter datac_number_of_multiplier = 1;   // Number of multiplier for datac, force to one to prevent error
		parameter width_c_total_msb  = (width_c * datac_number_of_multiplier) - 1;   // Total width of datac input
		parameter width_c_msb  = width_c - 1;     // MSB for splited datac width

		// Scanchain width related parameters
		parameter width_scanina = width_a;                  // Width for scanina port
		parameter width_scanina_msb = width_scanina - 1;    // MSB for scanina port
		
		parameter width_scaninb = width_b;                  // Width for scaninb port
		parameter width_scaninb_msb = width_scaninb - 1;    // MSB for scaninb port
		
		parameter width_sourcea_msb = number_of_multipliers -1;    // MSB for sourcea port
		parameter width_sourceb_msb = number_of_multipliers -1;    // MSB for sourceb port
		
		parameter width_scanouta_msb = width_a -1;    // MSB for scanouta port
		parameter width_scanoutb_msb = width_b -1;    // MSB for scanoutb port

		// chain (chainin and chainout) width related parameters
		parameter width_chainin_msb = width_chainin - 1;    // MSB for chainin port
		
		// Result width related parameters
		parameter width_result_msb = width_result - 1;      // MSB for result port
		
		// Coef width related parameters
		parameter width_coef_msb = width_coef -1;           // MSB for selected coef output
	
	
	// Internal width related parameters
		// Input data width related parameters
		parameter dataa_split_ext_require = (port_signa === "PORT_USED") ? 1 : 0;        // Determine dynamic sign extension 
		parameter dataa_port_sign = port_signa;                                          // Dynamic sign port for dataa
		parameter width_a_ext = (dataa_split_ext_require == 1) ? width_a + 1 : width_a ; // Sign extension when require
		parameter width_a_ext_msb = width_a_ext - 1;                                     // MSB for dataa
		
		parameter datab_split_ext_require = (preadder_mode === "SIMPLE") ? ((port_signb === "PORT_USED") ? 1 : 0):
		                                                                   ((port_signa === "PORT_USED") ? 1 : 0) ;   // Determine dynamic sign extension 
		parameter datab_port_sign = (preadder_mode === "SIMPLE") ? port_signb : port_signa;    // Dynamic sign port for dataa
		parameter width_b_ext = (datab_split_ext_require == 1) ? width_b + 1 : width_b;        // Sign extension when require
		parameter width_b_ext_msb = width_b_ext - 1;                                           // MSB for datab
		
		parameter coef_ext_require = (port_signb === "PORT_USED") ? 1 : 0;                // Determine dynamic sign extension 
		parameter coef_port_sign  = port_signb;                                           // Dynamic sign port for coef
		parameter width_coef_ext = (coef_ext_require == 1) ? width_coef + 1 : width_coef; // Sign extension when require
		parameter width_coef_ext_msb = width_coef_ext - 1;                                // MSB for coef
		
		parameter datac_split_ext_require = (port_signb === "PORT_USED") ? 1 : 0;        // Determine dynamic sign extension 
		parameter datac_port_sign = port_signb;                                          // Dynamic sign port for datac
		parameter width_c_ext = (datac_split_ext_require == 1) ? width_c + 1 : width_c;  // Sign extension when require
		parameter width_c_ext_msb = width_c_ext - 1;                                     // MSB for datac
		
		
		// Scanchain width related parameters
		parameter width_scanchain = (port_signa === "PORT_USED") ? width_scanina + 1 : width_scanina;  // Sign extension when require
		parameter width_scanchain_msb = width_scanchain - 1;
		parameter scanchain_port_sign = port_signa;                                      // Dynamic sign port for scanchain
		
		
		// Preadder width related parameters
		parameter preadder_representation = (port_signa === "PORT_USED") ? "SIGNED" : representation_a;   // Representation for preadder adder
		
		parameter width_preadder_input_a = (input_source_a0 === "SCANA")? width_scanchain : width_a_ext;   // Preadder input a selection width
		parameter width_preadder_input_a_msb = width_preadder_input_a - 1;                                      // MSB for preadder input a
		
		parameter width_preadder_adder_result = (width_preadder_input_a > width_b_ext)? width_preadder_input_a + 1 : width_b_ext + 1; // Adder extension by one for the largest width
		
		parameter width_preadder_output_a = (preadder_mode === "INPUT" || preadder_mode === "SQUARE" || preadder_mode === "COEF")? width_preadder_adder_result:
		                                     width_preadder_input_a;              // Preadder first output width
		parameter width_preadder_output_a_msb = width_preadder_output_a - 1;      // MSB for preadder first output width
		
		parameter width_preadder_output_b = (preadder_mode === "INPUT")? width_c_ext :
		                                    (preadder_mode === "SQUARE")? width_preadder_adder_result :
		                                    (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? width_coef_ext :
														width_b_ext;                         // Preadder second output width
		parameter width_preadder_output_b_msb = width_preadder_output_b - 1;     // MSB for preadder second output width
		
		
		// Multiplier width related parameters
		parameter multiplier_input_representation_a = (port_signa === "PORT_USED") ? "SIGNED" : representation_a;   // Representation for multiplier first input
		parameter multiplier_input_representation_b = (preadder_mode === "SQUARE") ? multiplier_input_representation_a :
		                                              (port_signb === "PORT_USED") ? "SIGNED" : representation_b;   // Representation for multiplier second input
		
		parameter width_mult_source_a = width_preadder_output_a;        // Multiplier first input width
		parameter width_mult_source_a_msb = width_mult_source_a - 1;    // MSB for multiplier first input width
		
		parameter width_mult_source_b = width_preadder_output_b;        // Multiplier second input width
		parameter width_mult_source_b_msb = width_mult_source_b - 1;    // MSB for multiplier second input width
		
		parameter width_mult_result = width_mult_source_a + width_mult_source_b +
		                              ((multiplier_input_representation_a === "UNSIGNED") ? 1 : 0) +
		                              ((multiplier_input_representation_b === "UNSIGNED") ? 1 : 0);   // Multiplier result width
		parameter width_mult_result_msb = width_mult_result -1;                                       // MSB for multiplier result width
		
		
		// Adder width related parameters
		parameter width_adder_source = width_mult_result;             // Final adder or systolic adder source width
		parameter width_adder_source_msb = width_adder_source - 1;    // MSB for adder source width
		
		parameter width_adder_result = width_adder_source + ((number_of_multipliers <= 2)? 1 : 2);  // Adder extension (2 when excute two level adder, else 1) and sign extension
		parameter width_adder_result_msb = width_adder_result - 1;                                  // MSB for adder result
		
		
		// Chainout adder width related parameters
		parameter width_chainin_ext = width_result - width_chainin;
		
		// Original output width related parameters
		parameter width_original_result = width_adder_result;               // The original result width without truncated
		parameter width_original_result_msb = width_original_result - 1;    // The MSB for original result 
		
		// Output width related parameters
		parameter result_ext_width    = (width_result_msb > width_original_result_msb) ? width_result_msb - width_original_result_msb : 1;   // Width that require to extend
		
		parameter width_result_output = (width_result_msb > width_original_result_msb) ? width_result : width_original_result + 1;   // Output width that ready for truncated
		parameter width_result_output_msb = width_result_output - 1;    // MSB for output width that ready for truncated
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input related ports
	input [width_a_total_msb : 0] dataa;
	input [width_b_total_msb : 0] datab;
	input [width_c_total_msb : 0] datac;
	
	// Scanchain related ports
	input [width_scanina_msb : 0] scanina;
	input [width_scaninb_msb : 0] scaninb;
	input [width_sourcea_msb : 0] sourcea;
	input [width_sourceb_msb : 0] sourceb;
	
	output [width_scanouta_msb : 0] scanouta;
	output [width_scanoutb_msb : 0] scanoutb;
	
	// Clock related ports
	input clock0, clock1, clock2, clock3;
	
	// Clear related ports
	input aclr0, aclr1, aclr2, aclr3;
	
	// Clock enable related ports
	input ena0, ena1, ena2, ena3;
	
	// Signals control related ports
	input signa, signb;
	input addnsub1, addnsub3;
	
	// Rounding related ports
	input mult01_round, mult23_round;
	input addnsub1_round, addnsub3_round;
	input output_round;
	input chainout_round;
	
	// Saturation related ports
	input mult01_saturation, mult23_saturation;
	input output_saturate;
	input chainout_saturate;
	
	output mult0_is_saturated, mult1_is_saturated, mult2_is_saturated, mult3_is_saturated;
	output chainout_sat_overflow;
	
	// chain (chainin and chainout) related port
	input [width_chainin_msb : 0] chainin;
	input zero_chainout;
	
	// Rotate & shift related port
	input rotate;
	input shift_right;
	
	// Loopback related port
	input zero_loopback;
	
	// Accumulator related port
	input accum_sload;
	
	// Preadder related port
	input [2 : 0] coefsel0, coefsel1, coefsel2, coefsel3;
	
	// Output related port
	output [width_result_msb : 0] result;
	output overflow;
	
	//==========================================================
	// Declar default driver for unused output port
	//==========================================================
	
	// synthesis read_comments_as_HDL on
	//tri0 [width_scanouta_msb : 0] scanouta;
	//tri0 [width_scanoutb_msb : 0] scanoutb;
	//
	//tri0 mult0_is_saturated, mult1_is_saturated, mult2_is_saturated, mult3_is_saturated;
	//tri0 chainout_sat_overflow;
	//
	//tri0 overflow;
	// synthesis read_comments_as_HDL off
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Register related wires and registers
	wire [width_clock_all_wire_msb : 0] clock_all_wire = {clock3, clock2, clock1, clock0};
	wire [width_aclr_all_wire_msb : 0] aclr_all_wire = {aclr3, aclr2, aclr1, aclr0};
	wire [width_ena_all_wire_msb : 0] ena_all_wire = {ena3, ena2, ena1, ena0};
	
	// Input A related wires and registers
	wire [width_a_total_msb : 0] dataa_split_input = dataa;
	wire [width_a_ext_msb : 0] dataa_0_input, dataa_1_input, dataa_2_input, dataa_3_input;  // Wire contain data a after split, reg and ext
	
	// Input B related wires and registers
	wire [width_b_total_msb : 0] datab_split_input = datab;
	wire [width_b_ext_msb : 0] datab_0_input, datab_1_input, datab_2_input, datab_3_input;  // Wire contain data b after split, reg and ext
	
	// Input C related wires and registers
	wire [width_c_total_msb : 0] datac_split_input = datac;
	wire [width_c_ext_msb : 0] datac_0_input, datac_1_input, datac_2_input, datac_3_input;  // Wire contain data b after split, reg and ext
	
	// Input coef related wires and registers
	wire [width_coef_ext_msb : 0] coefsel0_input, coefsel1_input, coefsel2_input, coefsel3_input;  // Wire contain data b after split, reg and ext
	
	// Scanchain related wires and registers
	wire [width_scanchain_msb : 0] scanchain_output_0, scanchain_output_1, scanchain_output_2, scanchain_output_3;
	wire [width_scanchain_msb : 0] scanout_wire;
	
	// Signed related wire and registers
	wire signa_wire, signb_wire;  // Wire contain sign signal, before being used
	
	wire dataa_sign_wire = signa_wire;
	wire datab_sign_wire = (preadder_mode === "SIMPLE") ? signb_wire : signa_wire; // Sign representation for data a and b
	wire datac_sign_wire = signb_wire;
	wire scanchain_sign_wire = signa_wire;
	
	// Preadder related wires and registers
	wire [width_preadder_input_a_msb : 0] preadder_dataa_0_input, preadder_dataa_1_input, preadder_dataa_2_input, preadder_dataa_3_input;
	wire [width_preadder_output_a_msb : 0] preadder_output_a0, preadder_output_a1, preadder_output_a2, preadder_output_a3;
	wire [width_preadder_output_b_msb : 0] preadder_output_b0, preadder_output_b1, preadder_output_b2, preadder_output_b3;
	
	// Multiplier related wires and registers
	wire [width_mult_source_a_msb : 0] mult_input_source_a0, mult_input_source_a1, mult_input_source_a2, mult_input_source_a3;
	wire [width_mult_source_b_msb : 0] mult_input_source_b0, mult_input_source_b1, mult_input_source_b2, mult_input_source_b3;
	wire [width_mult_result_msb : 0] mult_output_0, mult_output_1, mult_output_2, mult_output_3;
	
	// Adder related wires and registers
	wire [width_adder_source_msb : 0] adder_source_0, adder_source_1, adder_source_2, adder_source_3;
	wire [width_adder_result_msb : 0] adder_output;
	
	// Systolic related wires and registers
	wire [width_result_msb : 0] systolic_adder_output;
	
	// Result related wires and registers
	wire [width_result_output_msb : 0] result_wire;
	wire [width_result_msb : 0] result_wire_ext;
	
	wire [width_result_msb : 0] result_reg_input;
	wire [width_result_msb : 0] result_reg_output;
	
	wire [width_result_msb : 0] output_wire;
	
	// Accumulator related wires and registers
	wire [width_result_msb : 0] accum_cal_source;
	wire [width_result_msb : 0] accum_prev_source;
	
	wire [width_result_msb : 0] accum_output;
	
	// Chainout adder related wires and registers
	wire [width_result_msb : 0] chainout_adder_output;
	
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Scanchain assignment
	assign scanouta = scanout_wire[width_scanouta_msb : 0];
	
	// Preadder assignment
	assign preadder_dataa_0_input = (input_source_a0 === "SCANA")? scanchain_output_0 : dataa_0_input;
	assign preadder_dataa_1_input = (input_source_a1 === "SCANA")? scanchain_output_1 : dataa_1_input;
	assign preadder_dataa_2_input = (input_source_a2 === "SCANA")? scanchain_output_2 : dataa_2_input;
	assign preadder_dataa_3_input = (input_source_a3 === "SCANA")? scanchain_output_3 : dataa_3_input;
	
	// Multiplier assignment
	assign mult_input_source_a0 = preadder_output_a0;
	assign mult_input_source_a1 = preadder_output_a1;
	assign mult_input_source_a2 = preadder_output_a2;
	assign mult_input_source_a3 = preadder_output_a3;
	
	assign mult_input_source_b0 = preadder_output_b0;
	assign mult_input_source_b1 = preadder_output_b1;
	assign mult_input_source_b2 = preadder_output_b2;
	assign mult_input_source_b3 = preadder_output_b3;
	
	// Final adder and systolic assignmnet
	assign adder_source_0 = mult_output_0;
	assign adder_source_1 = mult_output_1;
	assign adder_source_2 = mult_output_2;
	assign adder_source_3 = mult_output_3;
	
	// adder (result) related assignment
	assign result_wire = {{result_ext_width{adder_output[width_adder_result_msb]}},adder_output};
	assign result_wire_ext = (systolic_delay1 === "UNREGISTERED") ? result_wire[width_result_msb : 0] : systolic_adder_output;
	
	// Accumulator assignmnet
	assign accum_cal_source = result_wire_ext;
	assign accum_prev_source = output_wire;
	
	// Register (clock and aclr) assignment
	assign result_reg_input = chainout_adder_output;
	assign output_wire = result_reg_output;  
	
	// Final output assignment
	assign result = output_wire;  

	
	//==========================================================
	// Sign handling part
	//==========================================================
	// Sign signal registered
	ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(signed_register_a), .register_aclr(signed_aclr_a))
	signa_reg_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in(signa), .data_out(signa_wire));
	
	ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(signed_register_b), .register_aclr(signed_aclr_b))
	signb_reg_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in(signb), .data_out(signb_wire) );
	
	
	//==========================================================
	// Input data handling part
	//==========================================================
	// Dataa split and register function
	ama_data_split_reg_ext_function #(.width_data_in(width_a), .width_data_out(width_a_ext), .register_clock_0(input_register_a0), .register_aclr_0(input_aclr_a0), .register_clock_1(input_register_a1), .register_aclr_1(input_aclr_a1), .register_clock_2(input_register_a2), .register_aclr_2(input_aclr_a2), .register_clock_3(input_register_a3), .register_aclr_3(input_aclr_a3), .number_of_multipliers(number_of_multipliers), .port_sign(dataa_port_sign))
	dataa_split(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(dataa_sign_wire), .data_in(dataa_split_input), .data_out_0(dataa_0_input), .data_out_1(dataa_1_input), .data_out_2(dataa_2_input), .data_out_3(dataa_3_input));
	
	// Datab split and register function
	ama_data_split_reg_ext_function #(.width_data_in(width_b), .width_data_out(width_b_ext), .register_clock_0(input_register_b0), .register_aclr_0(input_aclr_b0), .register_clock_1(input_register_b1), .register_aclr_1(input_aclr_b1), .register_clock_2(input_register_b2), .register_aclr_2(input_aclr_b2), .register_clock_3(input_register_b3), .register_aclr_3(input_aclr_b3), .number_of_multipliers(number_of_multipliers), .port_sign(datab_port_sign))
	datab_split(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(datab_sign_wire), .data_in(datab_split_input), .data_out_0(datab_0_input), .data_out_1(datab_1_input), .data_out_2(datab_2_input), .data_out_3(datab_3_input));
	
	// Datac split and register function
	ama_data_split_reg_ext_function #(.width_data_in(width_c), .width_data_out(width_c_ext), .register_clock_0(input_register_c0), .register_aclr_0(input_aclr_c0), .register_clock_1(input_register_c1), .register_aclr_1(input_aclr_c1), .register_clock_2(input_register_c2), .register_aclr_2(input_aclr_c2), .register_clock_3(input_register_c3), .register_aclr_3(input_aclr_c3), .number_of_multipliers(datac_number_of_multiplier), .port_sign(datac_port_sign))
	datac_split(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(datac_sign_wire), .data_in(datac_split_input), .data_out_0(datac_0_input), .data_out_1(datac_1_input), .data_out_2(datac_2_input), .data_out_3(datac_3_input));
	
	// Coef selection and register function
	generate
		if (preadder_mode === "CONSTANT" || preadder_mode === "COEF")
		begin
			wire coef_sign_wire = signb_wire;
			
			ama_coef_reg_ext_function #(.width_coef(width_coef), .width_data_out(width_coef_ext), .register_clock_0(coefsel0_register), .register_aclr_0(coefsel0_aclr), .register_clock_1(coefsel1_register), .register_aclr_1(coefsel1_aclr), .register_clock_2(coefsel2_register), .register_aclr_2(coefsel2_aclr), .register_clock_3(coefsel3_register), .register_aclr_3(coefsel3_aclr), .number_of_multipliers(number_of_multipliers), .port_sign(coef_port_sign),
			.coef0_0(coef0_0), .coef0_1(coef0_1), .coef0_2(coef0_2), .coef0_3(coef0_3), .coef0_4(coef0_4), .coef0_5(coef0_5), .coef0_6(coef0_6), .coef0_7(coef0_7),
			.coef1_0(coef1_0), .coef1_1(coef1_1), .coef1_2(coef1_2), .coef1_3(coef1_3), .coef1_4(coef1_4), .coef1_5(coef1_5), .coef1_6(coef1_6), .coef1_7(coef1_7),
			.coef2_0(coef2_0), .coef2_1(coef2_1), .coef2_2(coef2_2), .coef2_3(coef2_3), .coef2_4(coef2_4), .coef2_5(coef2_5), .coef2_6(coef2_6), .coef2_7(coef2_7),
			.coef3_0(coef3_0), .coef3_1(coef3_1), .coef3_2(coef3_2), .coef3_3(coef3_3), .coef3_4(coef3_4), .coef3_5(coef3_5), .coef3_6(coef3_6), .coef3_7(coef3_7))
			coefsel_reg_ext_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(coef_sign_wire), .coefsel0(coefsel0), .coefsel1(coefsel1), .coefsel2(coefsel2), .coefsel3(coefsel3), .data_out_0(coefsel0_input), .data_out_1(coefsel1_input), .data_out_2(coefsel2_input), .data_out_3(coefsel3_input));
		end
	endgenerate
	
	
	// Scanchain selection and register function
	ama_scanchain #(.width_scanin(width_scanina), .width_scanchain(width_scanchain), .input_register_clock_0(input_register_a0), .input_register_aclr_0(input_aclr_a0), .input_register_clock_1(input_register_a1), .input_register_aclr_1(input_aclr_a1), .input_register_clock_2(input_register_a2), .input_register_aclr_2(input_aclr_a2), .input_register_clock_3(input_register_a3), .input_register_aclr_3(input_aclr_a3), .scanchain_register_clock(scanouta_register), .scanchain_register_aclr(scanouta_aclr), .port_sign(scanchain_port_sign), .number_of_multipliers(number_of_multipliers))
	scanchain_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .sign(scanchain_sign_wire), .scanin(scanina), .data_out_0(scanchain_output_0), .data_out_1(scanchain_output_1), .data_out_2(scanchain_output_2), .data_out_3(scanchain_output_3), .scanout(scanout_wire));
	
	
	//==========================================================
	// Preadder part (input selection)
	//==========================================================
	ama_preadder_function #(.preadder_mode(preadder_mode), .width_in_a(width_preadder_input_a), .width_in_b(width_b_ext), .width_in_c(width_c_ext), .width_in_coef(width_coef_ext), .width_result_a(width_preadder_output_a), .width_result_b(width_preadder_output_b), .preadder_direction_0(preadder_direction_0), .preadder_direction_1(preadder_direction_1), .preadder_direction_2(preadder_direction_2), .preadder_direction_3(preadder_direction_3), .representation_preadder_adder(preadder_representation))
	preadder_block(.dataa_in_0(preadder_dataa_0_input), .dataa_in_1(preadder_dataa_1_input), .dataa_in_2(preadder_dataa_2_input), .dataa_in_3(preadder_dataa_3_input), .datab_in_0(datab_0_input), .datab_in_1(datab_1_input), .datab_in_2(datab_2_input), .datab_in_3(datab_3_input), .datac_in_0(datac_0_input), .datac_in_1(datac_1_input), .datac_in_2(datac_2_input), .datac_in_3(datac_3_input), .coef0(coefsel0_input), .coef1(coefsel1_input), .coef2(coefsel2_input), .coef3(coefsel3_input), .result_a0(preadder_output_a0), .result_a1(preadder_output_a1), .result_a2(preadder_output_a2), .result_a3(preadder_output_a3), .result_b0(preadder_output_b0), .result_b1(preadder_output_b1), .result_b2(preadder_output_b2), .result_b3(preadder_output_b3));
	
	
	//==========================================================
	// Multiplier part
	//==========================================================
	// Multiplier function
	ama_multiplier_function #(.width_data_in_a(width_mult_source_a), .width_data_in_b(width_mult_source_b), .multiplier_input_representation_a(multiplier_input_representation_a), .multiplier_input_representation_b(multiplier_input_representation_b), .width_data_out(width_mult_result), .number_of_multipliers(number_of_multipliers), .multiplier_register0(multiplier_register0), .multiplier_aclr0(multiplier_aclr0), .multiplier_register1(multiplier_register1), .multiplier_aclr1(multiplier_aclr1), .multiplier_register2(multiplier_register2), .multiplier_aclr2(multiplier_aclr2), .multiplier_register3(multiplier_register3), .multiplier_aclr3(multiplier_aclr3))
	multiplier_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in_a0(mult_input_source_a0), .data_in_a1(mult_input_source_a1), .data_in_a2(mult_input_source_a2), .data_in_a3(mult_input_source_a3), .data_in_b0(mult_input_source_b0), .data_in_b1(mult_input_source_b1), .data_in_b2(mult_input_source_b2), .data_in_b3(mult_input_source_b3), .data_out_0(mult_output_0), .data_out_1(mult_output_1), .data_out_2(mult_output_2), .data_out_3(mult_output_3));
	
	
	//==========================================================
	// Final adder part
	//==========================================================
	// Final adder function
	ama_adder_function #(.width_data_in(width_adder_source), .width_data_out(width_adder_result), .number_of_adder_input(number_of_multipliers), .adder1_direction(multiplier1_direction), .adder3_direction(multiplier3_direction), .representation("SIGNED"))
	final_adder_block (.data_in_0(adder_source_0), .data_in_1(adder_source_1), .data_in_2(adder_source_2), .data_in_3(adder_source_3), .data_out(adder_output));
	
	
	//==========================================================
	// Systolic part
	//==========================================================
	// Systolic function
	generate
		if (systolic_delay1 != "UNREGISTERED")
		begin
			ama_systolic_adder_function #(.width_data_in(width_adder_source), .width_chainin(width_chainin), .width_data_out(width_result), .number_of_adder_input(number_of_multipliers), .systolic_delay1(systolic_delay1), .systolic_aclr1(systolic_aclr1), .systolic_delay3(systolic_delay3), .systolic_aclr3(systolic_aclr3), .adder1_direction(multiplier1_direction), .adder3_direction(multiplier3_direction))
			systolic_adder_block(.data_in_0(adder_source_0), .data_in_1(adder_source_1), .data_in_2(adder_source_2), .data_in_3(adder_source_3), .chainin(chainin), .clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_out(systolic_adder_output));
		end
	endgenerate
	
	
	//==========================================================
	// Accumulator part
	//==========================================================
	// Accumulator function
	ama_accumulator_function #(.width_result(width_result), .accumulator(accumulator), .accum_direction(accum_direction), .loadconst_value(loadconst_value), .accum_sload_register(accum_sload_register), .accum_sload_aclr(accum_sload_aclr))
	accumulator_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .accum_sload(accum_sload), .data_result(accum_cal_source), .prev_result(accum_prev_source), .result(accum_output));
	
	parameter width_chainout_adder_output = (chainout_adder === "YES")? width_result : width_chainin;
	//==========================================================
	// Chainout adder part
	//==========================================================
	// Chainout adder function
	generate
		if (chainout_adder === "YES")
		begin
			// Width extend for encryption model, due to encryption model will still compile the hierarchy and cause width mistmatch for the chainin input
			//   This happen when chainin width is not equal to result width
			wire [width_result_msb : 0] chainin_wire = (width_chainin_ext > 0) ? {{width_chainin_ext{1'b0}},chainin} : chainin;
			
			ama_adder_function #(.width_data_in(width_result), .width_data_out(width_result), .number_of_adder_input(2), .adder1_direction("ADD"), .adder3_direction("ADD"), .representation("SIGNED"))
			chainout_adder_block (.data_in_0(chainin_wire), .data_in_1(accum_output), .data_in_2(), .data_in_3(), .data_out(chainout_adder_output));
		end
		else
		begin
			assign chainout_adder_output = accum_output;
		end
	endgenerate
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_function #(.width_data_in(width_result), .width_data_out(width_result), .register_clock(output_register), .register_aclr(output_aclr))
	output_reg_block(.clock(clock_all_wire), .aclr(aclr_all_wire), .ena(ena_all_wire), .data_in(result_reg_input), .data_out(result_reg_output));
	
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_signed_extension_function
// Use in          : altera_mult_add
//
// Description     : Registered function with dynamic sign extension
//--------------------------------------------------------------------------
module ama_signed_extension_function (
	data_in,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter representation = "UNSIGNED";          // Representation for the sign extension
	parameter width_data_in = 1;                    // Input data bus width
	parameter width_data_out = width_data_in + 1;   // Output data bus width
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;    // MSB for input data
	parameter width_data_out_msb = width_data_out -1;   // MSB for output data
	
	parameter width_data_ext = width_data_in + 1;       // Extend data width
	parameter wdith_data_ext_msb = width_data_ext - 1;  // MSB for extend data width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_data_in_msb : 0] data_in;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Bit extension selection wire
	wire data_in_bit_ext = (representation === "UNSIGNED")? 1'b0 :
                          (representation === "SIGNED")? data_in[width_data_in_msb] : 
                           1'bz;  // Decide bit for the extansion
	
	// Extended data wire
	wire [wdith_data_ext_msb : 0] data_ext = {data_in_bit_ext, data_in};
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Output assignment
	assign data_out = data_ext[width_data_out_msb : 0];
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_dynamic_signed_function
// Use in          : altera_mult_add
//
// Description     : Determine dynamic sign extension function
//--------------------------------------------------------------------------
module ama_dynamic_signed_function (
	data_in,
	sign,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter port_sign = "PORT_CONNECTIVITY";       // Dynamic sign extension port condition
	parameter width_data_in = 1;                     // Data input bus width
	parameter width_data_out = width_data_in + 1;    // Data output bus width
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;     // MSB for input data
	parameter width_data_out_msb = width_data_out -1;    // MSB for output data
	
	parameter width_data_out_wire = width_data_in + 1;              // Output wire width with 1 bit extra
	parameter width_data_out_wire_msb = width_data_out_wire - 1;    // MSB for output wire width
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Input port define
	input [width_data_in_msb : 0] data_in;
	
	// Dynamic sign port define
	input sign;
	
	// Output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Bit extension selection
	wire data_in_bit_ext = (port_sign === "PORT_USED")? ((sign == 1'b0)? 1'b0 : data_in[width_data_in_msb]) :
									1'bz;  // Decide bit for the extansion
	
	// Bit extension wire
	wire [width_data_out_wire_msb : 0] data_out_wire = {data_in_bit_ext, data_in};
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Output assignment
	assign data_out = data_out_wire[width_data_out_msb : 0];
	
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_register_function
// Use in          : altera_mult_add
//
// Description     : Asynchronous clear register function
//--------------------------------------------------------------------------
module ama_register_function (
	clock,
	aclr,
	ena,
	data_in,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                 // Input data bus width
	parameter width_data_out = 1;                // Output data bus width
	parameter register_clock = "UNREGISTERED";   // Clock for register
	parameter register_aclr = "UNUSED";          // Aclr for register
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;   // MSB for input data
	
	parameter width_data_out_msb = width_data_out -1;  // MSB for output data

	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Input port define
	input [width_data_in_msb : 0] data_in;
	
	// Output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Clock that used for registered
	wire clock_used_wire;
	
	// Asynchronous clear that used for registered
	wire aclr_used_wire;
	
	// Clock enable that used for registered
	wire ena_used_wire;
	
	// Input wire
	wire [width_data_in_msb : 0] data_in_wire = data_in;
	
	// Data output after registered
	reg [width_data_out_msb : 0] data_out_wire;
	
	//==========================================================
	// Assignment
	//==========================================================
	assign clock_used_wire  = (register_clock === "CLOCK3")? clock[3] :
                             (register_clock === "CLOCK2")? clock[2] :
                             (register_clock === "CLOCK1")? clock[1] : 
                             (register_clock === "CLOCK0")? clock[0] : "";  // Clock select
	
	assign aclr_used_wire  = (register_aclr === "ACLR3")? aclr[3] : 
                            (register_aclr === "ACLR2")? aclr[2] :
                            (register_aclr === "ACLR1")? aclr[1] : 
                            (register_aclr === "ACLR0")? aclr[0] : ""; // Aclr select
	
	assign ena_used_wire  = (register_clock === "CLOCK3")? ena[3] :
                           (register_clock === "CLOCK2")? ena[2] :
                           (register_clock === "CLOCK1")? ena[1] : 
                           (register_clock === "CLOCK0")? ena[0] : 1'b1;  // Clock enable select
	
	// Output assignment
	assign data_out = (register_clock === "UNREGISTERED")? data_in_wire : data_out_wire;
	
	// Initial output data to prevent tri-state or don't careoutput happen
	initial 
	data_out_wire = {width_data_out{1'b0}};
	
	// Asynchronous clear register section
	always @(posedge clock_used_wire or posedge aclr_used_wire)
	begin
		if (aclr_used_wire == 1'b1 )
			data_out_wire <= {width_data_out{1'b0}};
		else if (ena_used_wire == 1'b1)
			data_out_wire <= data_in_wire;
	end
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
	begin
		if(register_clock != "UNREGISTERED" && register_clock != "CLOCK0" && register_clock != "CLOCK1" && register_clock != "CLOCK2" && register_clock != "CLOCK3")
			$display("Error: Clock source error: illegal value %s", register_clock);
		
		if(register_aclr != "UNUSED" && register_aclr != "ACLR0" && register_aclr != "ACLR1" && register_aclr != "ACLR2" && register_aclr != "ACLR3" && register_aclr != "NONE")
			$display("Error: Asynchronous clear source error: illegal value %s", register_aclr);
	end
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_register_with_ext_function
// Use in          : altera_mult_add
//
// Description     : Registered function with dynamic sign extension
//--------------------------------------------------------------------------
module ama_register_with_ext_function (
	clock,
	aclr,
	ena,
	sign,
	data_in,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                      // Data input bus width
	parameter width_data_out = width_data_in + 1;     // Data output bus width
	
	parameter register_clock = "UNREGISTERED";        // Clock for register
	parameter register_aclr = "UNUSED";               // Aclr for register
	parameter port_sign = "PORT_CONNECTIVITY";        // Dynamic sign extension port condition
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;   // MSB for input data
	
	parameter width_data_out_msb = width_data_out -1;  // MSB for output data
	
	parameter width_sign_ext_output = (port_sign === "PORT_USED")? width_data_in + 1 : width_data_in;   // output with extend or without extend
	parameter width_sign_ext_output_msb = width_sign_ext_output -1;  // MSB for sign extend output
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// Input port define
	input [width_data_in_msb : 0] data_in;
	
	// Output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Data after dynamic signed extension
	wire [width_sign_ext_output_msb : 0] sign_ext_output;
	
	
	//==========================================================
	// Main function execution
	//==========================================================
	// Sign extension
	ama_dynamic_signed_function #(.width_data_in(width_data_in), .width_data_out(width_sign_ext_output), .port_sign(port_sign))
	data_signed_extension_block (.data_in(data_in), .sign(sign), .data_out(sign_ext_output));
	
	// Registered
	ama_register_function #(.width_data_in(width_sign_ext_output), .width_data_out(width_data_out), .register_clock(register_clock), .register_aclr(register_aclr))
	data_register_block (.clock(clock), .aclr(aclr), .ena(ena), .data_in(sign_ext_output), .data_out(data_out));
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
		if( width_sign_ext_output != width_data_out)
		begin
			$display("Error: Function output width and assign output width not same. Happen in ama_register_with_ext_function function for altera_mult_add");
		end
	
endmodule



//--------------------------------------------------------------------------
// Module Name     : ama_data_split_reg_ext_function
// Use in          : altera_mult_add
//
// Description     : Split data evenly according to the number of multiplier
//--------------------------------------------------------------------------
module ama_data_split_reg_ext_function (
	clock,
	aclr,
	ena,
	sign,
	data_in,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                    // Input data bus width
	parameter width_data_out = width_data_in + 1;   // Output data bus width
	
	parameter register_clock_0 = "UNREGISTERED";    // Clock for first data output register
	parameter register_aclr_0 = "UNUSED";           // Aclr for first data output register
	
	parameter register_clock_1 = "UNREGISTERED";    // Clock for second data output register
	parameter register_aclr_1 = "UNUSED";           // Aclr for second data output register
	
	parameter register_clock_2 = "UNREGISTERED";    // Clock for third data output register
	parameter register_aclr_2 = "UNUSED";           // Aclr for third data output register
	
	parameter register_clock_3 = "UNREGISTERED";    // Clock for fourth data output register
	parameter register_aclr_3 = "UNUSED";           // Aclr for fourth data output register
	
	parameter number_of_multipliers = 1;            // Total number of data going to be splited    
	parameter port_sign = "PORT_CONNECTIVITY";      // Dynamic sign extension port condition
	
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;    // MSB of input data
	
	parameter width_data_in_total_msb  = width_data_in * number_of_multipliers - 1;   // MSB of total input data width
	
	parameter width_data_out_msb = width_data_out -1;    // MSB of output data
	
	// Width of the individual splited data width
	parameter width_data_in_0_msb  = width_data_in - 1;
	parameter width_data_in_0_lsb  = 0;
	parameter width_data_in_1_msb  = (number_of_multipliers >= 2)? (width_data_in * 2 - 1) : 0;
	parameter width_data_in_1_lsb  = (number_of_multipliers >= 2)? (width_data_in) : 0;
	parameter width_data_in_2_msb  = (number_of_multipliers >= 3)? (width_data_in * 3 - 1) : 0;
	parameter width_data_in_2_lsb  = (number_of_multipliers >= 3)? (width_data_in * 2) : 0;
	parameter width_data_in_3_msb  = (number_of_multipliers >= 4)? (width_data_in * 4 - 1) : 0;
	parameter width_data_in_3_lsb  = (number_of_multipliers >= 4)? (width_data_in * 3) : 0;
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// Data input port define
	input [width_data_in_total_msb : 0] data_in;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Split data
	wire [width_data_in_msb : 0] data_split_0, data_split_1, data_split_2, data_split_3;
	
	// Split data after registered and dynamic extension
	wire [width_data_out_msb : 0] data_out_wire_0, data_out_wire_1, data_out_wire_2, data_out_wire_3;
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Data split assignment
	assign data_split_0 = data_in[width_data_in_0_msb : width_data_in_0_lsb];
	assign data_split_1 = (number_of_multipliers >= 2)? data_in[width_data_in_1_msb : width_data_in_1_lsb] : {(width_data_in ){1'bx}};
	assign data_split_2 = (number_of_multipliers >= 3)? data_in[width_data_in_2_msb : width_data_in_2_lsb] : {(width_data_in ){1'bx}};
	assign data_split_3 = (number_of_multipliers == 4)? data_in[width_data_in_3_msb : width_data_in_3_lsb] : {(width_data_in ){1'bx}};
	
	// Output assignment
	assign data_out_0 = data_out_wire_0;
	assign data_out_1 = data_out_wire_1;
	assign data_out_2 = data_out_wire_2;
	assign data_out_3 = data_out_wire_3;
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_0), .register_aclr(register_aclr_0), .port_sign(port_sign))
	data_register_block_0(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_0), .data_out(data_out_wire_0));
	
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_1), .register_aclr(register_aclr_1), .port_sign(port_sign))
	data_register_block_1(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_1), .data_out(data_out_wire_1));
	
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_2), .register_aclr(register_aclr_2), .port_sign(port_sign))
	data_register_block_2(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_2), .data_out(data_out_wire_2));
	
	ama_register_with_ext_function #(.width_data_in(width_data_in), .width_data_out(width_data_out), .register_clock(register_clock_3), .register_aclr(register_aclr_3), .port_sign(port_sign))
	data_register_block_3(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(data_split_3), .data_out(data_out_wire_3));
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_coef_reg_ext_function
// Use in          : altera_mult_add
//
// Description     : Contain coef selection function
//--------------------------------------------------------------------------
module ama_coef_reg_ext_function (
	clock,
	aclr,
	ena,
	sign,
	coefsel0,
	coefsel1,
	coefsel2,
	coefsel3,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_coef = 1;                      // Coef bus width
	parameter width_data_out = width_coef + 1;     // Coef output bus width
	
	parameter register_clock_0 = "UNREGISTERED";   // Clock for first coefsel register
	parameter register_aclr_0 = "UNUSED";          // aclr for first coefsel register
	
	parameter register_clock_1 = "UNREGISTERED";   // Clock for second coefsel register
	parameter register_aclr_1 = "UNUSED";          // aclr for second coefsel register
	
	parameter register_clock_2 = "UNREGISTERED";   // Clock for third coefsel register
	parameter register_aclr_2 = "UNUSED";          // aclr for third coefsel register
	
	parameter register_clock_3 = "UNREGISTERED";   // Clock for fourth coefsel register
	parameter register_aclr_3 = "UNUSED";          // aclr for fourth coefsel register
	
	parameter number_of_multipliers = 1;           // Number of coef output
	parameter port_sign = "PORT_CONNECTIVITY";     // Dynamic sign extension port condition
	
	// Internal used parameters
	parameter width_coef_msb = (width_coef > 1) ? width_coef - 1 : 0;   // MSB for coef data
	
	parameter width_data_out_msb = width_data_out -1;   // MSB of output data
	
	parameter width_coef_ext = (port_sign === "PORT_USED") ? width_coef + 1 : width_coef;   // Coef width with extend or without extend
	
	// Inherite parameters (ROM value)
	parameter [width_coef_msb : 0] coef0_0  = 0;   // Coef pre-define value
	parameter [width_coef_msb : 0] coef0_1  = 0;
	parameter [width_coef_msb : 0] coef0_2  = 0;
	parameter [width_coef_msb : 0] coef0_3  = 0;
	parameter [width_coef_msb : 0] coef0_4  = 0;
	parameter [width_coef_msb : 0] coef0_5  = 0;
	parameter [width_coef_msb : 0] coef0_6  = 0;
	parameter [width_coef_msb : 0] coef0_7  = 0;

	parameter [width_coef_msb : 0] coef1_0  = 0;
	parameter [width_coef_msb : 0] coef1_1  = 0;
	parameter [width_coef_msb : 0] coef1_2  = 0;
	parameter [width_coef_msb : 0] coef1_3  = 0;
	parameter [width_coef_msb : 0] coef1_4  = 0;
	parameter [width_coef_msb : 0] coef1_5  = 0;
	parameter [width_coef_msb : 0] coef1_6  = 0;
	parameter [width_coef_msb : 0] coef1_7  = 0;

	parameter [width_coef_msb : 0] coef2_0  = 0;
	parameter [width_coef_msb : 0] coef2_1  = 0;
	parameter [width_coef_msb : 0] coef2_2  = 0;
	parameter [width_coef_msb : 0] coef2_3  = 0;
	parameter [width_coef_msb : 0] coef2_4  = 0;
	parameter [width_coef_msb : 0] coef2_5  = 0;
	parameter [width_coef_msb : 0] coef2_6  = 0;
	parameter [width_coef_msb : 0] coef2_7  = 0;

	parameter [width_coef_msb : 0] coef3_0  = 0;
	parameter [width_coef_msb : 0] coef3_1  = 0;
	parameter [width_coef_msb : 0] coef3_2  = 0;
	parameter [width_coef_msb : 0] coef3_3  = 0;
	parameter [width_coef_msb : 0] coef3_4  = 0;
	parameter [width_coef_msb : 0] coef3_5  = 0;
	parameter [width_coef_msb : 0] coef3_6  = 0;
	parameter [width_coef_msb : 0] coef3_7  = 0;
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// coefsel input port define
	input [2 : 0] coefsel0, coefsel1, coefsel2, coefsel3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Memory that store the predefine value
	reg [width_coef_msb : 0] coef0 [7:0], coef1 [7:0], coef2 [7:0], coef3 [7:0];
	
	// Register output for coefsel
	wire [2 : 0] coefsel0_reg_out, coefsel1_reg_out, coefsel2_reg_out, coefsel3_reg_out;
	
	// Selected coef value
	wire [width_coef_msb : 0] coef0_wire, coef1_wire, coef2_wire, coef3_wire;

	
	//==========================================================
	// Coef value initialize
	//==========================================================
	initial
	begin
		coef0[0] = coef0_0;   // Assign constant coef value
		coef0[1] = coef0_1;
		coef0[2] = coef0_2;
		coef0[3] = coef0_3;
		coef0[4] = coef0_4;
		coef0[5] = coef0_5;
		coef0[6] = coef0_6;
		coef0[7] = coef0_7;
		
		coef1[0] = coef1_0;
		coef1[1] = coef1_1;
		coef1[2] = coef1_2;
		coef1[3] = coef1_3;
		coef1[4] = coef1_4;
		coef1[5] = coef1_5;
		coef1[6] = coef1_6;
		coef1[7] = coef1_7;
		
		coef2[0] = coef2_0;
		coef2[1] = coef2_1;
		coef2[2] = coef2_2;
		coef2[3] = coef2_3;
		coef2[4] = coef2_4;
		coef2[5] = coef2_5;
		coef2[6] = coef2_6;
		coef2[7] = coef2_7;
		
		coef3[0] = coef3_0;
		coef3[1] = coef3_1;
		coef3[2] = coef3_2;
		coef3[3] = coef3_3;
		coef3[4] = coef3_4;
		coef3[5] = coef3_5;
		coef3[6] = coef3_6;
		coef3[7] = coef3_7;
	end
	
	
	//==========================================================
	// Sign extension part
	//==========================================================
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_0(.data_in(coef0_wire), .sign(sign), .data_out(data_out_0));
	
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_1(.data_in(coef1_wire), .sign(sign), .data_out(data_out_1));
	
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_2(.data_in(coef2_wire), .sign(sign), .data_out(data_out_2));
	
	ama_dynamic_signed_function #(.width_data_in(width_coef),.width_data_out(width_data_out),.port_sign(port_sign))
	coef_ext_block_3(.data_in(coef3_wire), .sign(sign), .data_out(data_out_3));
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_0),.register_aclr(register_aclr_0))
	coef_register_block_0(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel0),.data_out(coefsel0_reg_out));
	
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_1),.register_aclr(register_aclr_1))
	coef_register_block_1(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel1),.data_out(coefsel1_reg_out));
	
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_2),.register_aclr(register_aclr_2))
	coef_register_block_2(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel2),.data_out(coefsel2_reg_out));
	
	ama_register_function #(.width_data_in(3),.width_data_out(3),.register_clock(register_clock_3),.register_aclr(register_aclr_3))
	coef_register_block_3(.clock(clock),.aclr(aclr),.ena(ena),.data_in(coefsel3),.data_out(coefsel3_reg_out));
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Coef value selection and truncated into define width
	assign coef0_wire = coef0[coefsel0_reg_out];
	assign coef1_wire = coef1[coefsel1_reg_out];
	assign coef2_wire = coef2[coefsel2_reg_out];
	assign coef3_wire = coef3[coefsel3_reg_out];
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
		if( width_coef_ext != width_data_out)
		begin
			$display("Error: Function output width and assign output width not same. Happen in ama_coef_reg_ext_function function for altera_mult_add");
		end
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_adder_function
// Use in          : altera_mult_add
//
// Description     : Add input data with corresponding representation
//                     (data_in_0 + data_in_1) + (data_in_2 + data_in_3)
//--------------------------------------------------------------------------
module ama_adder_function (
	data_in_0,
	data_in_1,
	data_in_2,
	data_in_3,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;             // Input data bus width
	parameter width_data_out = 1;            // Output data bus width
	parameter number_of_adder_input = 1;     // Total of data input to be add
	
	parameter adder1_direction = "UNUSED";   // First adder direction
	parameter adder3_direction = "UNUSED";   // Third adder direction
	
	parameter representation = "UNSIGNED";   // Representation for all the adder input
	
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;    // MSB for input data
	parameter width_data_out_msb = width_data_out -1;   // MSB for output data
	
	parameter width_adder_lvl_1 = width_data_in + 1;           // First level adder result width
	parameter width_adder_lvl_1_msb = width_adder_lvl_1 - 1;   // MSB for first level adder result
	
	parameter width_adder_lvl_2 = width_adder_lvl_1 + 1;       // Second level adder result width
	parameter width_adder_lvl_2_msb = width_adder_lvl_2 - 1;   // MSB for second level adder result
	
	parameter width_data_out_wire = width_data_in + 2;             // General adder result width
	parameter width_data_out_wire_msb = width_data_out_wire - 1;   // MSB for general adder result width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_data_in_msb : 0] data_in_0, data_in_1, data_in_2, data_in_3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Adder input wire (with or without sign extension)
	wire signed [width_adder_lvl_1_msb : 0] data_in_ext_0, data_in_ext_1, data_in_ext_2, data_in_ext_3;
	
	// First level adder result wire
	wire signed [width_adder_lvl_1_msb : 0] adder_result_0, adder_result_1, adder_result_2, adder_result_3;

	// Second level adder result wire
	wire signed [width_adder_lvl_2_msb : 0] adder_result_ext_0, adder_result_ext_1, adder_result_ext_2, adder_result_ext_3;
	
	// General adder output wire
	wire [width_adder_lvl_2_msb : 0] data_out_wire;
	
	//==========================================================
	// Assignment
	//==========================================================
	// First level adder assignment
	assign adder_result_0 = data_in_ext_0;
	
	assign adder_result_1 = (adder1_direction === "SUB") ? adder_result_0 - data_in_ext_1 : adder_result_0 + data_in_ext_1;
									
	assign adder_result_2 = data_in_ext_2; 
	
	assign adder_result_3 = (adder3_direction === "SUB") ? adder_result_2 - data_in_ext_3 : adder_result_2 + data_in_ext_3;
	
	// Output assignment (with second level adder assignment)
	assign data_out_wire = (number_of_adder_input == 1) ? adder_result_0 :
	                       (number_of_adder_input == 2) ? adder_result_1 :
	                       (number_of_adder_input == 3) ? adder_result_ext_1 + adder_result_ext_2 :
	                       (number_of_adder_input == 4) ? adder_result_ext_1 + adder_result_ext_3 :
	                       {width_data_out{1'bz}};
	
	// Output data assignmnet (with proper width assign)
	assign data_out = data_out_wire[width_data_out_msb : 0];
	
	
	//==========================================================
	// Sign extension
	//==========================================================
	// First level adder extension
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_0(.data_in(data_in_0),.data_out(data_in_ext_0));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_1(.data_in(data_in_1),.data_out(data_in_ext_1));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_2(.data_in(data_in_2),.data_out(data_in_ext_2));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_data_in),.width_data_out(width_adder_lvl_1))
	first_adder_ext_block_3(.data_in(data_in_3),.data_out(data_in_ext_3));
	
	// Second level adder extension
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_0(.data_in(adder_result_0),.data_out(adder_result_ext_0));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_1(.data_in(adder_result_1),.data_out(adder_result_ext_1));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_2(.data_in(adder_result_2),.data_out(adder_result_ext_2));
	
	ama_signed_extension_function #(.representation(representation),.width_data_in(width_adder_lvl_1),.width_data_out(width_adder_lvl_2))
	second_adder_ext_block_3(.data_in(adder_result_3),.data_out(adder_result_ext_3));
	

endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_multiplier_function
// Use in          : altera_mult_add
//
// Description     : Multiply input data with corresponding representation
//                     data_in_a * data_in_b
//--------------------------------------------------------------------------
module ama_multiplier_function (
	clock,
	aclr,
	ena,
	data_in_a0,
	data_in_a1,
	data_in_a2,
	data_in_a3,
	data_in_b0,
	data_in_b1,
	data_in_b2,
	data_in_b3,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in_a = 1;          // Input dataa bus width
	parameter width_data_in_b = 1;          // Input datab bus width
	parameter width_data_out = 1;           // Output data bus width
	parameter number_of_multipliers = 1;    // Total of data input to be multiply
	
	parameter multiplier_input_representation_a = "UNSIGNED";   // First multiplier input sign representation
	parameter multiplier_input_representation_b = "UNSIGNED";   // Second multiplier input sign representation
	
	parameter multiplier_register0 = "UNREGISTERED";   // First multiplier register clock
	parameter multiplier_register1 = "UNREGISTERED";   // Second multiplier register clock
	parameter multiplier_register2 = "UNREGISTERED";   // Third multiplier register clock
	parameter multiplier_register3 = "UNREGISTERED";   // Fourth multiplier register clock
	
	parameter multiplier_aclr0 = "UNUSED";   // First multiplier register aclr
	parameter multiplier_aclr1 = "UNUSED";   // Second multiplier register aclr
	parameter multiplier_aclr2 = "UNUSED";   // Third multiplier register aclr
	parameter multiplier_aclr3 = "UNUSED";   // Fourth multiplier register aclr
	
	// Internal used parameters
	parameter width_data_in_a_msb = width_data_in_a - 1;   // MSB for input dataa
	parameter width_data_in_b_msb = width_data_in_b - 1;   // MSB for input datab
	parameter width_data_out_msb = width_data_out -1;      // MSB for output data
	
	
	parameter width_mult_input_a = (multiplier_input_representation_a === "UNSIGNED") ? width_data_in_a + 1 :
                                                                                       width_data_in_a;   // Multiplier first input data
	parameter width_mult_input_a_msb = width_mult_input_a - 1;   // MSB for multiplier first input data
	
	parameter width_mult_input_b = (multiplier_input_representation_b === "UNSIGNED") ? width_data_in_b + 1 :
                                                                                       width_data_in_b;   // Multiplier second input data
	parameter width_mult_input_b_msb = width_mult_input_b - 1;   // MSB for multiplier second input data

	parameter width_mult_output = width_mult_input_a + width_mult_input_b;   // Calculated multiplier result width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Data input port define
	input [width_data_in_a_msb : 0] data_in_a0, data_in_a1, data_in_a2, data_in_a3;
	input [width_data_in_b_msb : 0] data_in_b0, data_in_b1, data_in_b2, data_in_b3;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Multiplier input wires (after extend or no extend)
	wire signed [width_mult_input_a_msb : 0] mult_input_a0, mult_input_a1, mult_input_a2, mult_input_a3;
	wire signed [width_mult_input_b_msb : 0] mult_input_b0, mult_input_b1, mult_input_b2, mult_input_b3;
	
	wire [width_data_out_msb : 0] data_out_wire_0, data_out_wire_1, data_out_wire_2, data_out_wire_3;
	
	//==========================================================
	// Assignment
	//==========================================================
	// Signed multiplier assignment
	assign data_out_wire_0 = mult_input_a0 * mult_input_b0;
	assign data_out_wire_1 = mult_input_a1 * mult_input_b1;
	assign data_out_wire_2 = mult_input_a2 * mult_input_b2;
	assign data_out_wire_3 = mult_input_a3 * mult_input_b3;
	
	
	//==========================================================
	// Sign extension
	//==========================================================
	// Multiplier input a extension
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_0(.data_in(data_in_a0),.data_out(mult_input_a0));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_1(.data_in(data_in_a1),.data_out(mult_input_a1));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_2(.data_in(data_in_a2),.data_out(mult_input_a2));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_a),.width_data_in(width_data_in_a),.width_data_out(width_mult_input_a))
	mult_input_a_ext_block_3(.data_in(data_in_a3),.data_out(mult_input_a3));
	
	// Multiplier input b extension
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_0(.data_in(data_in_b0),.data_out(mult_input_b0));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_1(.data_in(data_in_b1),.data_out(mult_input_b1));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_2(.data_in(data_in_b2),.data_out(mult_input_b2));
	
	ama_signed_extension_function #(.representation(multiplier_input_representation_b),.width_data_in(width_data_in_b),.width_data_out(width_mult_input_b))
	mult_input_b_ext_block_3(.data_in(data_in_b3),.data_out(mult_input_b3));
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register0), .register_aclr(multiplier_aclr0))
	multiplier_register_block_0(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_0),.data_out(data_out_0));
	
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register1), .register_aclr(multiplier_aclr1))
	multiplier_register_block_1(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_1),.data_out(data_out_1));
	
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register2), .register_aclr(multiplier_aclr2))
	multiplier_register_block_2(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_2),.data_out(data_out_2));
	
	ama_register_function #(.width_data_in(width_data_out), .width_data_out(width_data_out), .register_clock(multiplier_register3), .register_aclr(multiplier_aclr3))
	multiplier_register_block_3(.clock(clock),.aclr(aclr),.ena(ena),.data_in(data_out_wire_3),.data_out(data_out_3));
	
	
	//==========================================================
	// Condition check
	//==========================================================
	initial /* synthesis enable_verilog_initial_construct */
		if( width_mult_output != width_data_out)
		begin
			$display("Error: Function output width and assign output width not same. Happen in ama_multiplier_function function for altera_mult_add");
		end
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_preadder_function
// Use in          : altera_mult_add
//
// Description     : Determine multiplier input source and contain pre-adder 
//                     for mode other that simple mode
//--------------------------------------------------------------------------
module ama_preadder_function (
	dataa_in_0,
	dataa_in_1,
	dataa_in_2,
	dataa_in_3,
	datab_in_0,
	datab_in_1,
	datab_in_2,
	datab_in_3,
	datac_in_0,
	datac_in_1,
	datac_in_2,
	datac_in_3,
	coef0,
	coef1,
	coef2,
	coef3,
	result_a0,
	result_a1,
	result_a2,
	result_a3,
	result_b0,
	result_b1,
	result_b2,
	result_b3
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter preadder_mode  = "SIMPLE";   // Mode to determine output value
	
	parameter width_in_a  = 1;         // Dataa input bus width
	parameter width_in_b  = 1;         // Datab input bus width
	parameter width_in_c  = 1;         // Datac input bus width
	parameter width_in_coef  = 1;      // Coef input bus width
	
	parameter width_result_a = 1;   // Output result a bus width
	parameter width_result_b = 1;   // Output result b bus width
	
	parameter preadder_direction_0  = "ADD";   // First pre-adder direction
	parameter preadder_direction_1  = "ADD";   // Second pre-adder direction
	parameter preadder_direction_2  = "ADD";   // Third pre-adder direction
	parameter preadder_direction_3  = "ADD";   // Forth pre-adder direction
	
	parameter representation_preadder_adder = "UNSIGNED";   // Representation for pre-adder 
	
	// Internal used parameters
	parameter width_in_a_msb = width_in_a - 1;                 // MSB for dataa input
	parameter width_in_b_msb = width_in_b - 1;                 // MSB for datab input
	parameter width_in_c_msb = width_in_c - 1;                 // MSB for datav input
	parameter width_in_coef_msb = width_in_coef - 1;           // MSB for coef input
	parameter width_result_a_msb = width_result_a - 1;   // MSB for result a output
	parameter width_result_b_msb = width_result_b - 1;   // MSB for result b output
	
	parameter width_preadder_adder_input = (width_in_a > width_in_b) ? width_in_a : width_in_b;   // Determine pre-adder input width 
	parameter width_preadder_adder_input_msb = width_preadder_adder_input - 1;        // MSB for pre-adder input
	
	parameter width_preadder_adder_result = width_preadder_adder_input + 1;           // Pre-adder result width
	parameter width_preadder_adder_result_msb = width_preadder_adder_result - 1;      // MSB for pre-adder result
	
	parameter width_preadder_adder_input_wire = width_preadder_adder_input + 1;            // Pre-adder input width after extend
	parameter width_preadder_adder_input_wire_msb = width_preadder_adder_input_wire - 1;   // MSB for extended pre-adder input
	
	parameter width_in_a_ext = (width_preadder_adder_input > width_in_a) ? width_preadder_adder_input - width_in_a + 1 : 1;   // Width of dataa require to be extend
	parameter width_in_b_ext = (width_preadder_adder_input > width_in_b) ? width_preadder_adder_input - width_in_b + 1 : 1;   // Width of datab require to be extend
	
	parameter width_output_preadder = (preadder_mode === "SQUARE")? width_preadder_adder_result : 1;   // Prevent truncated warning happen
	parameter width_output_preadder_msb = width_output_preadder -1;

	parameter width_output_coef = (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? width_in_coef : 1;   // Prevent truncated warning happen
	parameter width_output_coef_msb = width_output_coef -1;
	
	parameter width_output_datab = (preadder_mode === "SIMPLE")? width_in_b : 1;   // Prevent truncated warning happen
	parameter width_output_datab_msb = width_output_datab -1;
	
	parameter width_output_datac = (preadder_mode === "INPUT")? width_in_c : 1;   // Prevent truncated warning happen
	parameter width_output_datac_msb = width_output_datac -1;
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_in_a_msb : 0] dataa_in_0, dataa_in_1, dataa_in_2, dataa_in_3;
	input [width_in_b_msb : 0] datab_in_0, datab_in_1, datab_in_2, datab_in_3;
	input [width_in_c_msb : 0] datac_in_0, datac_in_1, datac_in_2, datac_in_3;
	input [width_in_coef_msb : 0] coef0, coef1, coef2, coef3;
	
	// Data output port define
	output [width_result_a_msb : 0] result_a0, result_a1, result_a2, result_a3;
	output [width_result_b_msb : 0] result_b0, result_b1, result_b2, result_b3;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Pre-adder input wire
	wire [width_preadder_adder_input_msb : 0] preadder_input_a0, preadder_input_a1, preadder_input_a2, preadder_input_a3;
	wire [width_preadder_adder_input_msb : 0] preadder_input_b0, preadder_input_b1, preadder_input_b2, preadder_input_b3;
	
	// Pre-adder input wire (for concatenate)
	wire [width_preadder_adder_input_wire_msb : 0] preadder_input_wire_a0, preadder_input_wire_a1, preadder_input_wire_a2, preadder_input_wire_a3;
	wire [width_preadder_adder_input_wire_msb : 0] preadder_input_wire_b0, preadder_input_wire_b1, preadder_input_wire_b2, preadder_input_wire_b3;
	
	// Determine bits to be extend
	wire preadder_ext_a0 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_0[width_in_a_msb];
	wire preadder_ext_a1 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_1[width_in_a_msb];
	wire preadder_ext_a2 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_2[width_in_a_msb];
	wire preadder_ext_a3 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : dataa_in_3[width_in_a_msb];
	
	wire preadder_ext_b0 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_0[width_in_b_msb];
	wire preadder_ext_b1 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_1[width_in_b_msb];
	wire preadder_ext_b2 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_2[width_in_b_msb];
	wire preadder_ext_b3 = (representation_preadder_adder === "UNSIGNED") ? 1'b0 : datab_in_3[width_in_b_msb];
	
	// Pre-adder result wire
	wire [width_preadder_adder_result_msb : 0] preadder_adder_result_0, preadder_adder_result_1, preadder_adder_result_2, preadder_adder_result_3;
	
	
	//==========================================================
	// Preadder adder (sum of 2)
	//==========================================================
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_0), .representation(representation_preadder_adder))
	preadder_adder_0(.data_in_0(preadder_input_a0), .data_in_1(preadder_input_b0), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_0));
	
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_1), .representation(representation_preadder_adder))
	preadder_adder_1(.data_in_0(preadder_input_a1), .data_in_1(preadder_input_b1), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_1));
	
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_2), .representation(representation_preadder_adder))
	preadder_adder_2(.data_in_0(preadder_input_a2), .data_in_1(preadder_input_b2), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_2));
	
	ama_adder_function #(.width_data_in(width_preadder_adder_input), .width_data_out(width_preadder_adder_result), .number_of_adder_input(2), .adder1_direction(preadder_direction_3), .representation(representation_preadder_adder))
	preadder_adder_3(.data_in_0(preadder_input_a3), .data_in_1(preadder_input_b3), .data_in_2(), .data_in_3(), .data_out(preadder_adder_result_3));
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Preadder input extend (extra one bit, prevent zero concatenate issue)
	assign preadder_input_wire_a0 = {{width_in_a_ext{preadder_ext_a0}},dataa_in_0};
	assign preadder_input_wire_a1 = {{width_in_a_ext{preadder_ext_a1}},dataa_in_1};
	assign preadder_input_wire_a2 = {{width_in_a_ext{preadder_ext_a2}},dataa_in_2};
	assign preadder_input_wire_a3 = {{width_in_a_ext{preadder_ext_a3}},dataa_in_3};
	
	assign preadder_input_wire_b0 = {{width_in_b_ext{preadder_ext_b0}},datab_in_0};
	assign preadder_input_wire_b1 = {{width_in_b_ext{preadder_ext_b1}},datab_in_1};
	assign preadder_input_wire_b2 = {{width_in_b_ext{preadder_ext_b2}},datab_in_2};
	assign preadder_input_wire_b3 = {{width_in_b_ext{preadder_ext_b3}},datab_in_3};
	
	// Preadder input
	assign preadder_input_a0 = preadder_input_wire_a0[width_preadder_adder_input_msb : 0];
	assign preadder_input_a1 = preadder_input_wire_a1[width_preadder_adder_input_msb : 0];
	assign preadder_input_a2 = preadder_input_wire_a2[width_preadder_adder_input_msb : 0];
	assign preadder_input_a3 = preadder_input_wire_a3[width_preadder_adder_input_msb : 0];
	
	assign preadder_input_b0 = preadder_input_wire_b0[width_preadder_adder_input_msb : 0];
	assign preadder_input_b1 = preadder_input_wire_b1[width_preadder_adder_input_msb : 0];
	assign preadder_input_b2 = preadder_input_wire_b2[width_preadder_adder_input_msb : 0];
	assign preadder_input_b3 = preadder_input_wire_b3[width_preadder_adder_input_msb : 0];
	
	// Preadder output selection
	assign result_a0 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_0[width_result_a_msb : 0] :
	                                                                                dataa_in_0;
	assign result_a1 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_1[width_result_a_msb : 0] :
	                                                                                dataa_in_1;
	assign result_a2 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_2[width_result_a_msb : 0] :
	                                                                                dataa_in_2;
	assign result_a3 = (preadder_mode != "SIMPLE" && preadder_mode != "CONSTANT") ? preadder_adder_result_3[width_result_a_msb : 0] :
	                                                                                dataa_in_3;
	
	assign result_b0 = (preadder_mode === "INPUT")? datac_in_0[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_0[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef0[width_output_coef_msb : 0] : 
                       datab_in_0[width_output_datab_msb : 0];
									
	assign result_b1 = (preadder_mode === "INPUT")? datac_in_1[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_1[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef1[width_output_coef_msb : 0] : 
                       datab_in_1[width_output_datab_msb : 0];
									
	assign result_b2 = (preadder_mode === "INPUT")? datac_in_2[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_2[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef2[width_output_coef_msb : 0] : 
                       datab_in_2[width_output_datab_msb : 0];
									
	assign result_b3 = (preadder_mode === "INPUT")? datac_in_3[width_output_datac_msb : 0] :
		                (preadder_mode === "SQUARE")? preadder_adder_result_3[width_output_preadder_msb : 0] :
                      (preadder_mode === "COEF" || preadder_mode === "CONSTANT")? coef3[width_output_coef_msb : 0] : 
                       datab_in_3[width_output_datab_msb : 0];
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_accumulator_function
// Use in          : altera_mult_add
//
// Description     : Accumulate the result according to setting or direct
//                     output the current input result (when accumulator 
//                     equal to no)
//--------------------------------------------------------------------------
module ama_accumulator_function (
	clock,
	aclr,
	ena,
	accum_sload,
	data_result,
	prev_result,
	result
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_result = 1;            // Result bus width
	
	parameter accumulator = "NO";          // Allow result to be accumulated
	parameter accum_direction = "ADD";     // Accumulated by adding or substracting current result
	parameter loadconst_value = 0;         // Constant value to be add with current result
	
	parameter accum_sload_register = "UNREGISTERED";   // Clock for accum_sload signal register
	parameter accum_sload_aclr = "NONE";               // Aclr for accum_sload signal register
	
	
	// Internal used parameters
	parameter width_result_msb = width_result - 1;   // MSB for  data
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Signal that select between loadconstant value or previous result for accumulate
	input accum_sload;
	
	// Input data port define
	input [width_result_msb : 0] data_result;    // Current result
	input [width_result_msb : 0] prev_result;    // Previous result
	
	// Data output port define
	output [width_result_msb : 0] result;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Loadconst value that prepare to be added
	wire [width_result_msb : 0]loadconst_reg = {{width_result_msb{1'b0}},1'b1} << loadconst_value;
	
	// Registered accum_sload signal 
	wire accum_sload_wire;
	
	// Contain the value that need to accumulated with current result
	wire [width_result_msb : 0] accum_add_source;
	
	// Contain the accumulated result
	wire [width_result_msb : 0] accum_result;
	
	//==========================================================
	// Assignment
	//==========================================================
	// Accumulator source assignment 
	assign accum_add_source = (accum_sload_wire == 1 && accum_sload_register !== "UNREGISTERED") ? loadconst_reg : 
	                          prev_result;
	
	// Accumulator result 
	assign accum_result = (accum_direction === "SUB") ? accum_add_source - data_result :
	                       accum_add_source + data_result;
	
	// Result assignment
	assign result = (accumulator === "NO") ? data_result : accum_result;
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	// Accum_sload signal register
	ama_register_function #(.width_data_in(1), .width_data_out(1), .register_clock(accum_sload_register), .register_aclr(accum_sload_aclr))
	accum_sload_register_block(.clock(clock), .aclr(aclr), .ena(ena), .data_in(accum_sload), .data_out(accum_sload_wire));
	
endmodule


//--------------------------------------------------------------------------
// Module Name     : ama_systolic_adder_function
// Use in          : altera_mult_add
//
// Description     : Contain systolic function 
//                   (((chainin + mult result 1)<reg> + mult result 2)<reg>
//                     + mult result 3)<reg> + mult result 4
//--------------------------------------------------------------------------
module ama_systolic_adder_function (
	data_in_0,
	data_in_1,
	data_in_2,
	data_in_3,
	chainin,
	clock,
	aclr,
	ena,
	data_out
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_data_in = 1;                   // Input data bus width
	parameter width_chainin  = 1;                  // Chainin data bus width
	parameter width_data_out = 1;                  // Output data bus width
	parameter number_of_adder_input = 1;           // Total of data input to be add
	
	parameter systolic_delay1 = "UNREGISTERED";    // Clock for first and second systolic register
	parameter systolic_aclr1 = "UNUSED";           // Aclr for first and second systolic register
	parameter systolic_delay3 = "UNREGISTERED";    // Clock for third systolic register
	parameter systolic_aclr3 = "UNUSED";           // Aclr for third systolic register
	
	parameter adder1_direction = "UNUSED";         // Second adder direction 
	parameter adder3_direction = "UNUSED";         // Forth adder direction
	
	
	// Internal used parameters
	parameter width_data_in_msb = width_data_in - 1;     // MSB for input data
	parameter width_data_out_msb = width_data_out -1;    // MSB for output data
	parameter width_chainin_msb = width_chainin -1;      // MSB for chainin data

	parameter width_systolic_ext = (width_chainin > width_data_in) ? width_chainin : width_data_in + 1;   // Width of adder data input and result
	parameter width_systolic_ext_msb = width_systolic_ext - 1;    // MSB for systolic ext

	parameter input_ext_width = (width_chainin > width_data_in) ? width_chainin - width_data_in : 1;   // Extend input data to be same as chainin width
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Data input port define
	input [width_data_in_msb : 0] data_in_0, data_in_1, data_in_2, data_in_3;
	
	// Chainin input port define
	input [width_chainin_msb : 0] chainin;   
	
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Data output port define
	output [width_data_out_msb : 0] data_out;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Input data extension wire
	wire signed [width_systolic_ext_msb : 0] data_in_ext_0, data_in_ext_1, data_in_ext_2, data_in_ext_3;
	
	// Adder registered result wire
	wire signed [width_systolic_ext_msb : 0] adder_result_reg_0, adder_result_reg_1, adder_result_reg_2;
	
	// Adder result wire
	wire signed [width_systolic_ext_msb : 0] adder_result_0, adder_result_1, adder_result_2, adder_result_3;
	
	
	//==========================================================
	// Assignment
	//==========================================================
	// Input data extension
	assign data_in_ext_0 = {{input_ext_width{data_in_0[width_data_in_msb]}},data_in_0};
	assign data_in_ext_1 = {{input_ext_width{data_in_1[width_data_in_msb]}},data_in_1};
	assign data_in_ext_2 = {{input_ext_width{data_in_2[width_data_in_msb]}},data_in_2};
	assign data_in_ext_3 = {{input_ext_width{data_in_3[width_data_in_msb]}},data_in_3};
	
	// Adder assignment
	assign adder_result_0 = chainin + data_in_ext_0;
	assign adder_result_1 = (adder1_direction === "SUB") ? adder_result_reg_0 - data_in_ext_1 : adder_result_reg_0 + data_in_ext_1;
	assign adder_result_2 = adder_result_reg_1 + data_in_ext_2;
	assign adder_result_3 = (adder3_direction === "SUB") ? adder_result_reg_2 - data_in_ext_3 : adder_result_reg_2 + data_in_ext_3;
	
	// Ouptut result selection
	assign data_out = (number_of_adder_input == 1) ? adder_result_0[width_data_out_msb : 0] : 
	                  (number_of_adder_input == 2) ? adder_result_1[width_data_out_msb : 0] : 
							(number_of_adder_input == 3) ? adder_result_2[width_data_out_msb : 0] : 
							(number_of_adder_input == 4) ? adder_result_3[width_data_out_msb : 0] : {width_data_out{1'bx}};
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	// First register (adder result for chainin and first input data) 
	ama_register_function #(.width_data_in(width_systolic_ext), .width_data_out(width_systolic_ext), .register_clock(systolic_delay1), .register_aclr(systolic_aclr1))
	systolic_reg_block_0(.clock(clock), .aclr(aclr), .ena(ena), .data_in(adder_result_0), .data_out(adder_result_reg_0));
	
	// Second register (for first adder result and second input data) 
	ama_register_function #(.width_data_in(width_systolic_ext), .width_data_out(width_systolic_ext), .register_clock(systolic_delay1), .register_aclr(systolic_aclr1))
	systolic_reg_block_1(.clock(clock), .aclr(aclr), .ena(ena), .data_in(adder_result_1), .data_out(adder_result_reg_1));
	
	// Third register (for second adder result and third input data) 
	ama_register_function #(.width_data_in(width_systolic_ext), .width_data_out(width_systolic_ext), .register_clock(systolic_delay3), .register_aclr(systolic_aclr3))
	systolic_reg_block_2(.clock(clock), .aclr(aclr), .ena(ena), .data_in(adder_result_2), .data_out(adder_result_reg_2));
	
	
endmodule

//--------------------------------------------------------------------------
// Module Name     : ama_data_split_reg_ext_function
// Use in          : altera_mult_add
//
// Description     : Split data evenly according to the number of multiplier
//--------------------------------------------------------------------------
module ama_scanchain (
	clock,
	aclr,
	ena,
	sign,
	scanin,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3,
	scanout
	);
	
	//==========================================================
	// Parameters declaration
	//==========================================================
	// Inherite parameters
	parameter width_scanin = 1;                    // Scanin data bus width
	parameter width_scanchain = 1;                 // Scanchain data bus width
	
	parameter input_register_clock_0 = "UNREGISTERED";    // Clock for first data output register
	parameter input_register_aclr_0  = "UNUSED";          // Aclr for first data output register
	parameter input_register_clock_1 = "UNREGISTERED";    // Clock for second data output register
	parameter input_register_aclr_1  = "UNUSED";          // Aclr for second data output register
	parameter input_register_clock_2 = "UNREGISTERED";    // Clock for third data output register
	parameter input_register_aclr_2  = "UNUSED";          // Aclr for third data output register
	parameter input_register_clock_3 = "UNREGISTERED";    // Clock for fourth data output register
	parameter input_register_aclr_3  = "UNUSED";          // Aclr for fourth data output register
	
	parameter scanchain_register_clock = "UNREGISTERED";    // Clock for scanchain data register
	parameter scanchain_register_aclr = "UNUSED";           // Aclr for scanchain data register
	
	parameter port_sign = "PORT_CONNECTIVITY";      // Dynamic sign extension port condition
	parameter number_of_multipliers = 1;            // Total number of data going to be splited 
	
	// Internal used parameters
	parameter width_scanin_msb = width_scanin - 1;         // MSB of input data
	parameter width_scanchain_msb = width_scanchain -1;    // MSB of output data
	
	
	//==========================================================
	// Port declaration
	//==========================================================
	// Clock, aclr and ena signal port define
	input [3:0] clock, aclr, ena;
	
	// Dynamic sign port define
	input sign;
	
	// Data input port define
	input [width_scanin_msb : 0] scanin;
	
	// Data output port define
	output [width_scanchain_msb : 0] data_out_0, data_out_1, data_out_2, data_out_3, scanout;
	
	
	//==========================================================
	// Wire and register defined
	//==========================================================
	// Split data after registered and dynamic extension
	wire [width_scanchain_msb : 0] scanchain_wire_0, scanchain_wire_1, scanchain_wire_2, scanchain_wire_3;
	wire [width_scanchain_msb : 0] scanchain_reg_wire_0, scanchain_reg_wire_1, scanchain_reg_wire_2, scanchain_reg_wire_3;
	wire [width_scanchain_msb : 0] scanout_reg_wire;
	
	//==========================================================
	// Assignment
	//==========================================================
	// Data output assignment
	assign data_out_0 = scanchain_reg_wire_0;
	assign data_out_1 = (number_of_multipliers >= 2)? scanchain_reg_wire_1 : {(width_scanchain ){1'bx}};
	assign data_out_2 = (number_of_multipliers >= 3)? scanchain_reg_wire_2 : {(width_scanchain ){1'bx}};
	assign data_out_3 = (number_of_multipliers == 4)? scanchain_reg_wire_3 : {(width_scanchain ){1'bx}};
	
	assign scanout_reg_wire = (number_of_multipliers == 2)? scanchain_reg_wire_1 :
	                          (number_of_multipliers == 3)? scanchain_reg_wire_2 :
	                          (number_of_multipliers == 4)? scanchain_reg_wire_3 :
	                          scanchain_reg_wire_0;
	
	
	//==========================================================
	// Register (clock and aclr) part
	//==========================================================
	// Scanchain register part
	// Only extend one time for dynamic sign extension
	ama_register_with_ext_function #(.width_data_in(width_scanin), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr), .port_sign(port_sign))
	scanchain_register_block_0(.clock(clock), .aclr(aclr),.ena(ena), .sign(sign), .data_in(scanin), .data_out(scanchain_wire_0));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanchain_register_block_1(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_reg_wire_0), .data_out(scanchain_wire_1));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanchain_register_block_2(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_reg_wire_1), .data_out(scanchain_wire_2));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanchain_register_block_3(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_reg_wire_2), .data_out(scanchain_wire_3));
	
	
	// Input register part
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_0), .register_aclr(input_register_aclr_0))
	input_register_block_0(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_0), .data_out(scanchain_reg_wire_0));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_1), .register_aclr(input_register_aclr_1))
	input_register_block_1(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_1), .data_out(scanchain_reg_wire_1));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_2), .register_aclr(input_register_aclr_2))
	input_register_block_2(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_2), .data_out(scanchain_reg_wire_2));
	
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(input_register_clock_3), .register_aclr(input_register_aclr_3))
	input_register_block_3(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanchain_wire_3), .data_out(scanchain_reg_wire_3));
	
	
	// Scanout register part
	ama_register_function #(.width_data_in(width_scanchain), .width_data_out(width_scanchain), .register_clock(scanchain_register_clock), .register_aclr(scanchain_register_aclr))
	scanout_register_block(.clock(clock), .aclr(aclr), .ena(ena), .data_in(scanout_reg_wire), .data_out(scanout));
	
endmodule
