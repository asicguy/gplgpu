// Copyright (C) 1991-2011 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.
// Quartus II 11.0 Build 157 04/27/2011

`timescale 1 ps / 1ps

module oper_add ( a, b, cin, cout, o );

	parameter width_a = 32;
	parameter width_b = 32;
	parameter width_o = 32;
	parameter sgate_representation = 1;

	input [width_a-1:0] a;
	input [width_b-1:0] b;
	input cin;
	output cout;
	output [width_o-1:0] o;


   initial
    begin

        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_b > 0
        if (width_b <= 0)
        begin
            $display("Error!  width_b must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if (width_o <= 0)
        begin
            $display("Error!  width_o must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a != width_b)
        begin
            $display("Error!  width_a must be equal to width_b.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a != width_o)
        begin
            $display("Error!  width_a must be equal to width_o.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check for valid lpm_rep value
        if (sgate_representation != 1 && sgate_representation != 0)
        begin    
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");
            $display ("Time: %0t  Instance: %m", $time);
		end
    end


 	lpm_add_sub	lpm_add_sub_component (
				.dataa (a),
				.datab (b),
				.cin (cin),
				.cout (cout),
				.result (o),
				.add_sub (),
				.clock (),
				.aclr (),
				.clken (),
				.overflow ()
				);
	defparam
		lpm_add_sub_component.lpm_width = width_a,
		lpm_add_sub_component.lpm_direction = "ADD",
		lpm_add_sub_component.lpm_representation = (sgate_representation == 1) ? "SIGNED" : "UNSIGNED",
		lpm_add_sub_component.lpm_type = "LPM_ADD_SUB",
		lpm_add_sub_component.lpm_hint = "ONE_INPUT_IS_CONSTANT=NO";

endmodule 
////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_addsub ( a, b, addnsub, o );

	parameter width_a = 32;
	parameter width_b = 32;
	parameter width_o = 32;
	
	parameter sgate_representation = 0;

	input  [width_a-1:0] a;
	input  [width_b-1:0] b;
	
	input  addnsub;
	output [width_o-1:0] o;

    reg [width_a-1:0] not_a;
    reg [width_b-1:0] not_b;
    reg [width_o-1:0] tmp_result;
//    reg signed [width_a+2-1:0] a_int, b_int; //(not_a)*(-1)-1
//	reg signed [width_a+5-1:0] result_int, i; // a_int + (-b_int) 

    integer a_int, b_int; //(not_a)*(-1)-1
	integer result_int, i; // a_int + (-b_int) 

	wire i_add_sub;

	buf (i_add_sub, addnsub);

   initial
    begin
        // check if width_a > 0
        if (width_a <= 0)
            $display("Error!  width_a must be greater than 0.\n");
        // check if width_b > 0
        if (width_b <= 0)
            $display("Error!  width_b must be greater than 0.\n");
        // check if width_o > 0
        if (width_o <= 0)
            $display("Error!  width_o must be greater than 0.\n");

        if (width_a != width_b)
            $display("Error!  width_a must be equal to width_b.\n");

        if (width_a != width_o)
            $display("Error!  width_a must be equal to width_o.\n");

        if (sgate_representation != 1 &&
            sgate_representation != 0)
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");

            tmp_result = 'b0;
    end

 
    always @(a or b or i_add_sub)
	begin
    
            if (i_add_sub == 1)
            begin
                tmp_result = a + b;
            end
            else if (i_add_sub == 0)
            begin
                tmp_result = a - b;
            end
     
            if (sgate_representation == 1)
            begin
                not_a = ~a;
                not_b = ~b;

                a_int = (a[width_a-1]) ? (not_a)*(-1)-1 : a;
                b_int = (b[width_b-1]) ? (not_b)*(-1)-1 : b;
    
                // perform the addtion or subtraction operation
                if (i_add_sub == 1)
                begin
                    result_int = a_int + b_int;
                    tmp_result = result_int;
                end
                else if (i_add_sub == 0)
                begin
                    result_int = a_int - b_int;
                    tmp_result = result_int;
                end
                tmp_result = result_int;
        end
	end	

    assign o = tmp_result;

endmodule //oper_addsub

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module mux21 ( dataa, datab, dataout, outputselect);

	input dataa;
	input datab;
	output dataout;
	input outputselect;

	reg tmp_result;
    integer i;

    always @(dataa or datab or outputselect)
	begin
		tmp_result = 0;
		if (outputselect)
		begin
	        tmp_result = datab;
		end
		else
		begin
	        tmp_result = dataa;
		end
	end

    assign dataout = tmp_result;

endmodule //mux21

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module io_buf_tri (datain, dataout, oe);

	input  datain;
	input  oe;
	output dataout;

	reg tmp_tridata;
	
	always @(datain or oe)
	begin
        if (oe == 0)
		begin
			tmp_tridata = 1'bz;
		end
        else 
		begin
			tmp_tridata = datain;	
		end
	end

	assign dataout = tmp_tridata;

endmodule // io_buf_tri


////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module io_buf_opdrn (datain, dataout);

	input  datain;
	output dataout;

	reg tmp_tridata;
	
	always @(datain)
	begin
        if (datain == 0)
		begin
			tmp_tridata = 1'b0;
		end
        else 
		begin
			tmp_tridata = 1'bz;	
		end
	end

	assign dataout = tmp_tridata;

endmodule // io_buf_tri

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_mult ( a, b,  o );

	parameter width_a = 32;
	parameter width_b = 32;
	parameter width_o = 32;
	parameter sgate_representation = 1;


	input [width_a-1:0] a;
	input [width_b-1:0] b;
	output [width_o-1:0] o;

	// local parameter
	parameter width_result = (width_o >= width_a + width_b) ? width_o : width_a + width_b;
	wire [width_result-1:0] result;


	initial
	begin
        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_b > 0
        if (width_b <= 0)
        begin
            $display("Error!  width_b must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if (width_o <= 0)
        begin
            $display("Error!  width_o must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check for valid lpm_rep value
        if ((sgate_representation != 1) && (sgate_representation != 0))
        begin
            $display("Error!  sgate_representation value must be 1 (signed) or 0 (unsigned).", $time);
            $display ("Time: %0t  Instance: %m", $time);
		end
	end
	
	lpm_mult	lpm_mult_component (
				.dataa (a),
				.datab (b),
				.result (result),
			    .sum (),
				.aclr (),
				.clock (),
				.clken ()
				);
	defparam
		lpm_mult_component.lpm_widtha = width_a,
		lpm_mult_component.lpm_widthb = width_b,
		lpm_mult_component.lpm_widthp = width_result,
		lpm_mult_component.lpm_widths = width_result,
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_representation = sgate_representation ? "SIGNED" : "UNSIGNED",
		lpm_mult_component.lpm_hint = "MAXIMIZE_SPEED=6";

	assign o[width_o-1:0] = result[width_o-1:0];
	


endmodule // oper_mult


////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module tri_bus ( datain, dataout );

	parameter width_datain = 1;
	parameter width_dataout = 1;

	input [(width_datain)-1:0] datain;
	output [width_dataout-1:0] dataout;

    reg [width_dataout-1:0] tmp_result;
    integer i;

   initial
    begin
            tmp_result = 1'bz;

        // check if width_a > 0
        if (width_datain <= 0)
        begin
            $display("Error!  width_datain must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_b > 0
        if (width_dataout != 1)
        begin
            $display("Error!  width_dataout must be equal to 1.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0

    end


    always @(datain)
	begin
            for (i = 0; i < width_datain; i = i + 1)
				if ((datain[i] == 1)||(datain[i] == 0))
				begin
				tmp_result[0]=datain[i];
				end
	end

    assign dataout = tmp_result;
endmodule // tri_bus

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_div ( a, b, o);

	parameter width_a = 6;
	parameter width_b = 6;
	parameter width_o = 6;
	parameter sgate_representation = 0;

	input  [width_a-1:0] a;
	input  [width_b-1:0] b;
	output [width_o-1:0] o;
	
	wire [width_a-1:0] tmp_result;
	reg [width_o-1:0] tmp_result2;
	wire [width_b-1:0] hold_rem;

	integer i;

	lpm_divide u1 (
			.numer (a), 
			.denom (b), 
			.quotient (tmp_result), 
			.remain (hold_rem),
		    .clock (),
		    .aclr (),
			.clken ()
			);
		defparam u1.lpm_widthn= width_a,
			   u1.lpm_widthd= width_b,
			   u1.lpm_nrepresentation= sgate_representation ? "SIGNED" : "UNSIGNED",
			   u1.lpm_drepresentation= sgate_representation ? "SIGNED" : "UNSIGNED",
			   u1.lpm_type = "LPM_DIVIDE",
			   u1.lpm_hint = sgate_representation ? "LPM_REMAINDERPOSITIVE=FALSE" : "LPM_REMAINDERPOSITIVE=TRUE";

   initial
    begin

        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_b > 0
        if (width_b <= 0)
        begin
            $display("Error!  width_b must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if (width_o <= 0)
        begin
            $display("Error!  width_o must greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if ((sgate_representation != 1) && (sgate_representation != 0))
        begin
            $display("Error!  sgate_representation value must be 1 (signed) or 0 (unsigned).", $time);
            $display ("Time: %0t  Instance: %m", $time);
		end
    end

	always @(tmp_result)
	begin
		if (width_a > width_o)
		begin
			tmp_result2[width_o-1:0] = tmp_result[width_a-1:0];
		end
		else
		begin
			tmp_result2[width_a-1:0] = tmp_result[width_a-1:0];
		end
		if ((width_o - width_a) > 0)
		begin
			for (i = width_a; i < width_o; i = i + 1)
			begin
				tmp_result2[i] = sgate_representation ? tmp_result[width_a-1] : 1'b0;  
			end
		end	
	end
	
	assign o = tmp_result2;	
		
		
endmodule // oper_div

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_mod ( a, b, o);

	parameter width_a = 6;
	parameter width_b = 6;
	parameter width_o = 6;
	parameter sgate_representation = 0;

	input  [width_a-1:0] a;
	input  [width_b-1:0] b;
	output [width_o-1:0] o;
	
	wire [width_a-1:0] tmp_result;
	reg [width_o-1:0] tmp_result2;
	wire [width_b-1:0] hold_rem;

	integer i;

	lpm_divide u1 (
			.numer (a), 
			.denom (b), 
			.quotient (tmp_result), 
			.remain (hold_rem),
		    .clock (),
		    .aclr (),
			.clken ()
			);
		defparam u1.lpm_widthn= width_a,
			   u1.lpm_widthd= width_b,
			   u1.lpm_nrepresentation= sgate_representation ? "SIGNED" : "UNSIGNED",
			   u1.lpm_drepresentation= sgate_representation ? "SIGNED" : "UNSIGNED",
			   u1.lpm_type = "LPM_DIVIDE",
			   u1.lpm_hint = sgate_representation ? "LPM_REMAINDERPOSITIVE=FALSE" : "LPM_REMAINDERPOSITIVE=TRUE";

   initial
    begin

        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_b > 0
        if (width_b <= 0)
        begin
            $display("Error!  width_b must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if (width_o <= 0)
        begin
            $display("Error!  width_o must greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if ((sgate_representation != 1) && (sgate_representation != 0))
        begin
            $display("Error!  sgate_representation value must be 1 (signed) or 0 (unsigned).", $time);
            $display ("Time: %0t  Instance: %m", $time);
		end
    end

	always @(hold_rem)
	begin
		if (width_b > width_o)
		begin
			tmp_result2[width_o-1:0] = hold_rem[width_o-1:0];
		end
		else
		begin
			tmp_result2[width_b-1:0] = hold_rem[width_b-1:0];
		end
		if ((width_o - width_b) > 0)
		begin
			for (i = width_b; i < width_o; i = i + 1)
			begin
				tmp_result2[i] = sgate_representation ? hold_rem[width_b-1] : 1'b0;  
			end
		end	
	end
	
	assign o = tmp_result2;	
		
		
endmodule // oper_mod

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_left_shift ( a, amount, cin, o);

	parameter width_a = 6;
	parameter width_amount = 6;
	parameter width_o = 6;
	parameter sgate_representation = 0;

	input  [width_a-1:0] a;
	input  [width_amount-1:0] amount;
	input  cin;
	output [width_o-1:0] o;
	integer i;

	reg [width_a-1:0] ONES;
	reg [width_a-1:0] tmp_buf;
	
	reg [width_a-1:0] temp_result2;

	initial
	begin

        // check if width_amount > 0
        if (width_amount <= 0)
        begin
            $display("Error!  width_amount must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_a = width_o
        if (width_a < width_o)
        begin
            $display("Error!  width_a must be greater than or equal to width_o.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if (sgate_representation != 1 && sgate_representation != 0)
        begin
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");     
            $display ("Time: %0t  Instance: %m", $time);
		end
	end

		
	always @(a or amount or cin)
	begin
	
		tmp_buf[width_a-1:0]=a[width_a-1:0];
		
		if (sgate_representation)
		begin
			for (i=0; i < width_a; i=i+1)
				ONES[i] = cin;				
		end
		else
		begin
			for (i=0; i < width_a; i=i+1)
				ONES[i] = cin;							
		end
		
		temp_result2 = (tmp_buf << amount) | (ONES >> (width_a-amount)) ;
	
	end
				
	
	assign o = temp_result2[width_o-1:0];	

endmodule // oper_left_shift

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
	
`timescale 1 ps / 1ps
module oper_right_shift ( a, amount, cin, o);

	parameter width_a = 6;
	parameter width_amount = 6;
	parameter width_o = 6;
	parameter sgate_representation = 0;

	input  [width_a-1:0] a;
	input  [width_amount-1:0] amount;
	input  cin;
	output [width_o-1:0] o;
	integer i;

	reg [width_a-1:0] ONES;
	reg [width_a-1:0] tmp_buf;
	
	reg [width_a-1:0] temp_result2;

	initial
	begin

        // check if width_amount > 0
        if (width_amount <= 0)
        begin
            $display("Error!  width_amount must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_a = width_o
        if (width_a < width_o)
        begin
            $display("Error!  width_a must be greater than or equal to width_o.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0
        if (sgate_representation != 1 && sgate_representation != 0)
        begin
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");     
            $display ("Time: %0t  Instance: %m", $time);
		end
	end

		
	always @(a or amount or cin)
	begin
	
		tmp_buf[width_a-1:0]=a[width_a-1:0];
		
		if (sgate_representation)
		begin
			for (i=0; i < width_a; i=i+1)
				ONES[i] = cin;				
		end
		else
		begin
			for (i=0; i < width_a; i=i+1)
				ONES[i] = cin;							
		end
		
		if (a[width_a-1] == 0)
		begin
			temp_result2 = (tmp_buf >> amount);	
		end
		else
		begin
		temp_result2 = (tmp_buf >> amount) | (ONES << (width_a-amount)) ;
		end
	
	end
				
	
	assign o = temp_result2[width_o-1:0];	

endmodule // oper_right_shift

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_rotate_left ( amount,	a, o);

	parameter width_a = 6;
	parameter width_amount = 6;
	parameter width_o = 6;
	parameter sgate_representation = 0;

	input	[width_amount-1:0]  amount;
	input	[width_a-1:0]  a;
	output	[width_o-1:0]  o;

	wire [width_a-1:0] temp_result;
	wire temp_direction = 1'h0;


	lpm_clshift	lpm_clshift_component (
				.distance (amount),
				.direction (temp_direction),
				.data (a),
				.result (temp_result),
			    .underflow (),
			    .overflow ()
				);
	defparam
		lpm_clshift_component.lpm_type = "LPM_CLSHIFT",
		lpm_clshift_component.lpm_shifttype = "ROTATE",
		lpm_clshift_component.lpm_width = width_a,
		lpm_clshift_component.lpm_widthdist = width_amount;

	assign o = temp_result[width_o-1:0];

   initial
    begin
        // check if width_a > 0
        if (width_amount <= 0)
        begin
            $display("Error!  width_amount must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a != width_o)
        begin
            $display("Error!  width_a must be equal to width_o.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (sgate_representation != 1 && sgate_representation != 0)
        begin
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");
            $display ("Time: %0t  Instance: %m", $time);
		end
    end

endmodule //oper_rotate_left

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_rotate_right ( amount,	a, o);

	parameter width_a = 6;
	parameter width_amount = 6;
	parameter width_o = 6;
	parameter sgate_representation = 0;

	input	[width_amount-1:0]  amount;
	input	[width_a-1:0]  a;
	output	[width_o-1:0]  o;

	wire [width_a-1:0] temp_result;
	wire temp_direction = 1'h1;

	assign o = temp_result[width_o-1:0];

	lpm_clshift	lpm_clshift_component (
				.distance (amount),
				.direction (temp_direction),
				.data (a),
				.result (temp_result),
			    .underflow (),
			    .overflow ()
				);
	defparam
		lpm_clshift_component.lpm_type = "LPM_CLSHIFT",
		lpm_clshift_component.lpm_shifttype = "ROTATE",
		lpm_clshift_component.lpm_width = width_a,
		lpm_clshift_component.lpm_widthdist = width_amount;

   initial
    begin
        // check if width_a > 0
        if (width_amount <= 0)
        begin
            $display("Error!  width_amount must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a != width_o)
        begin
            $display("Error!  width_a must be equal to width_o.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (sgate_representation != 1 && sgate_representation != 0)
        begin
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");
            $display ("Time: %0t  Instance: %m", $time);
		end
    end

endmodule //oper_rotate_right

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_less_than (a, b, cin, o);

	parameter width_a = 6;
	parameter width_b = 6;
	parameter sgate_representation = 0;

	parameter width_max= width_a>width_b ? width_a : width_b;

	input [width_a-1:0] a;
	input [width_b-1:0] b;
	input cin;
	output o;
	
	integer sa;
	integer sb;
    reg [width_a-1:0] not_a;
    reg [width_b-1:0] not_b;

	reg tmp_result;
	initial
    begin
 
        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_b <= 0)
        begin
            $display("Error!  width_b must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (sgate_representation != 1 && sgate_representation != 0)
        begin
            $display("Error!  sgate_representation value must be 1 (SIGNED) or 0 (UNSIGNED).");
            $display ("Time: %0t  Instance: %m", $time);
		end
    end
	
    always @(a or b or cin)
	begin
        sa = a;
        sb = b;
        not_a = ~a;
        not_b = ~b;

        if (sgate_representation == "SIGNED")
        begin
            if (a[width_a-1] == 1)
                sa = (not_a) * (-1) - 1;
            if (b[width_b-1] == 1)
                sb = (not_b) * (-1) - 1;

			if (sa<sb)
			begin
				tmp_result = 1;
			end
			else if ((sa==sb)&&(cin))
			begin
				tmp_result = 1;		
			end
			else
			begin
				tmp_result = 0;		
			end

        end
		else
		begin
			if (a<b)
			begin
				tmp_result = 1;
			end
			else if ((a==b)&&(cin))
			begin
				tmp_result = 1;		
			end
			else
			begin
				tmp_result = 0;		
			end
		end
	end
	
    assign o = tmp_result;

endmodule // oper_less_than
	
////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_mux ( sel,	data, o);

	parameter width_sel = 6;
	parameter width_data = 6;

	input	[width_sel-1:0]  sel;
	input	[width_data-1:0]  data;
	output	o;

	reg  temp_result;

   initial
    begin
            temp_result = 'bz;

        // check if width_a > 0
        if (width_data <= 0)
        begin
            $display("Error!  width_data must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_b > 0
        if (width_sel <= 0)
        begin
            $display("Error!  width_sel must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        // check if width_o > 0

    end



    always @(data or sel)
	begin
         temp_result = data[sel];
	end


    assign o = temp_result;

endmodule //oper_mux

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_selector ( sel, data, o);
 
 parameter width_sel = 6;
 parameter width_data = 6;
 
 input [width_sel-1:0]  sel;
 input [width_data-1:0]  data;
 output o;
 reg  temp_result;
 reg [width_data-1:0]  result;
 integer i;
 
   initial
    begin
        // check if width_a > 0
        if (width_sel <= 0)
        begin
            $display("Error!  width_sel must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_data != width_sel)
        begin
            $display("Error!  width_sel must be equal to width_data.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
 
    end
 
 always @(data or sel)
 begin
  temp_result = 1'b0;
  for (i = 0; i < width_sel; i = i + 1)
   if (sel[i] == 1)
   begin
    temp_result= temp_result | data[i];
   end
 end

 assign o = temp_result;
 
endmodule //oper_selector

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_decoder ( i, o);

	parameter width_i = 6;
	parameter width_o = 6;

	input	[width_i-1:0]  i;
	output	[width_o-1:0] o;

   initial
    begin
        // check if width_i > 0
        if (width_i <= 0)
            $display("Error!  width_i must be greater than 0.\n");
        if (width_o <= 0)
            $display("Error!  width_o must be greater than 0.\n");
    end

	lpm_decode	lpm_decode_component (
				.data (i),
				.eq (o),
				.enable (),
			    .clock (),
    			.aclr (),
    			.clken ()
				);
	defparam
		lpm_decode_component.lpm_width = width_i,
		lpm_decode_component.lpm_decodes = width_o,
		lpm_decode_component.lpm_type = "LPM_DECODE";


endmodule //oper_decoder

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_bus_mux ( a, b, sel, o);

	parameter width_a = 6;
	parameter width_b = 6;

	parameter width_o = 6;

	input	[width_a-1:0]  a;
	input	[width_b-1:0]  b;
	input	 sel;	
	output	[width_o-1:0] o;
	
	wire [width_a+width_b-1:0] all_inps;
	
	assign all_inps[width_a-1:0]=a[width_a-1:0];
	assign all_inps[width_a+width_b-1:width_a]=b[width_b-1:0];
	 

   initial
    begin
        // check if width_a > 0
        if (width_a <= 0)
        begin
            $display("Error!  width_a must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_b <= 0)
        begin
            $display("Error!  width_o must be greater than 0.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a != width_b)
        begin
            $display("Error!  width_a must equal width_b.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
        if (width_a != width_o)
        begin
            $display("Error!  width_a must equal width_o.\n");
            $display ("Time: %0t  Instance: %m", $time);
		end
    end

	lpm_mux	lpm_mux_component (
				.data (all_inps),
				.sel(sel),
				.result (o),
			    .clock (),
			    .aclr (),
    			.clken ()
				);
	defparam
		lpm_mux_component.lpm_width = width_o,
		lpm_mux_component.lpm_size = 2,
		lpm_mux_component.lpm_widths = 1,		
		lpm_mux_component.lpm_type = "lpm_mux";


endmodule //oper_bus_mux

////------------------------------------------------------------------------------------------
////------------------------------------------------------------------------------------------
`timescale 1 ps / 1ps
module oper_latch(datain, dataout, latch_enable, aclr, preset);

	input datain, latch_enable, aclr, preset;
	output dataout;
	
	reg dataout;
	always @(datain or latch_enable or aclr or preset)
	begin
		if (aclr === 1'b1)
			dataout = 1'b0;
		else if (preset === 1'b1)
			dataout = 1'b1;
		else if (latch_enable)
			dataout = datain;
	end

endmodule //oper_latch

