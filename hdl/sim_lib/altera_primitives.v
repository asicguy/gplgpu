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
// START_FILE_HEADER -----------------------------------------------------------
// Filename    : altera_primitives.v
//
// Description : Contains the behavioral models for Altera primitives.
//
// Limitation  : None
//
// Owner       : Wuei Hong Lai
//
// Copyright (c) Altera Corporation 1997-2005
// All rights reserved
//
// END_FILE_HEADER -------------------------------------------------------------


`timescale 1 ps / 1 ps
module global (in, out);
    input in;
    output out;

    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module carry (in, out);
    input in;
    output out;

    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module cascade (in, out);
    input in;
    output out;

    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module carry_sum (sin, cin, sout, cout);
    input sin;
    input cin;
    output sout;
    output cout;

    assign sout = sin;
    assign cout = cin;
endmodule

`timescale 1 ps / 1 ps
module exp (in, out);
    input in;
    output out;

    assign out = ~in;
endmodule

`timescale 1 ps / 1 ps
module soft (in, out);
    input in;
    output out;
    
    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module opndrn (in, out);
    input in;
    output out;
    
    bufif0 (out, in, in);
endmodule

`timescale 1 ps / 1 ps
module row_global (in, out);
    input in;
    output out;
    
    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module TRI (in, oe, out);
    input in;
    input oe;
    output out;
    
    bufif1 (out, in, oe);
endmodule

`timescale 1 ps / 1 ps
module lut_input (in, out);
    input in;
    output out;
    
    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module lut_output (in, out);
    input in;
    output out;
    
    assign out = in;
endmodule

`timescale 1 ps / 1 ps
module latch (d, ena, q);
    input d, ena;
    output q;
    reg q;
    initial q = 1'b0;
    
    always@ (d or ena)
    begin
        if (ena)
            q <= d;
    end
endmodule

`timescale 1 ps / 1 ps
module dlatch (d, ena, clrn, prn, q);
    input d, ena, clrn, prn;
    output q;
    reg q;
    initial q = 1'b0;
    
    always@ (d or ena or clrn or prn)
    begin
        if (clrn == 1'b0)
            q <= 1'b0;
        else if (prn == 1'b0)
            q <= 1'b1;
        else if (ena)
            q <= d;
    end
endmodule

`timescale 1 ps / 1 ps
module prim_gdff (q, d, clk, ena, clr, pre, ald, adt, sclr, sload );
    input d,clk,ena,clr,pre,ald,adt,sclr,sload;
    output q;
    reg q;
    reg clk_pre;
    initial q = 1'b0;

    always@ (clk or clr or pre or ald or adt)
    begin
        if (clr ==  1'b1)
            q <= 1'b0;
        else if (pre == 1'b1)
            q <= 1'b1;
        else if (ald == 1'b1)
            q <= adt;
        else if ((clk == 1'b1) && (clk_pre == 1'b0))
        begin
            if (ena == 1'b1)
            begin
                if (sclr == 1'b1)
                    q <= 1'b0;
                else if (sload == 1'b1)
                    q <= adt;
                else
                    q <= d;
            end
        end
        clk_pre <= clk;
    end
endmodule

`timescale 1 ps / 1 ps
module dff (d, clk, clrn, prn, q );
    input d,clk,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn;

    prim_gdff inst (q, d, clk, 1'b1, !clrn, !prn, 1'b0, 1'b0, 1'b0, 1'b0);

endmodule

`timescale 1 ps / 1 ps
module dffe (d, clk, ena, clrn, prn,q );
    input d,clk,ena,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn, ena;

    prim_gdff inst (q, d, clk, ena, !clrn, !prn, 1'b0, 1'b0, 1'b0, 1'b0);

endmodule

`timescale 1 ps / 1 ps
module dffea (d, clk, ena, clrn, prn, aload, adata,q );
    input d,clk,ena,clrn,prn,aload,adata;
    output q;
    wire q;
    tri0 aload;
    tri1 prn, clrn, ena;

    reg stalled_adata;
    initial
    begin
        stalled_adata = adata;
    end

    always @(adata) begin
        #1 stalled_adata = adata;
    end

    prim_gdff inst (q, d, clk, ena, !clrn, !prn, aload, stalled_adata, 1'b0, 1'b0);

endmodule
    
`timescale 1 ps / 1 ps
module dffeas (d, clk, ena, clrn, prn, aload, asdata, sclr, sload, devclrn, devpor, q );

parameter power_up = "DONT_CARE";
parameter is_wysiwyg = "false";
parameter x_on_violation = "on";
parameter lpm_type = "dffeas";

    input d,clk,ena,clrn,prn,aload,asdata,sclr,sload,devclrn,devpor;
output q;
wire q, q_high, q_low;

tri0 aload_in, sclr_in, sload_in, asdata_in;
tri1 prn_in, clrn_in, ena_in, devclrn_in, devpor_in;

assign aload_in = aload;
assign sclr_in = sclr;
assign sload_in = sload;
assign asdata_in = asdata;
assign prn_in = prn;
assign clrn_in = clrn;
assign ena_in = ena;
assign devclrn_in = devclrn;
assign devpor_in = devpor;
   
    wire q_tmp;

reg viol;

reg q_tmp_dly;
   
    wire reset;
wire nosloadsclr;
wire sloaddata;

    assign reset = devpor_in && devclrn_in && clrn_in && prn_in && ena_in;
    assign nosloadsclr = reset && (!sload_in && !sclr_in);
    assign sloaddata = reset && sload_in;
   
    assign q = q_tmp_dly;
   
specify

    $setuphold (posedge clk &&& nosloadsclr, d, 0, 0, viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, viol) ;
    $setuphold (posedge clk &&& sloaddata, asdata, 0, 0, viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, viol) ;
      
    (posedge clk => (q +: q_tmp)) = 0 ;
    (negedge clrn => (q +: 1'b0)) = (0, 0) ;
    (negedge prn => (q +: 1'b1)) = (0, 0) ;
    (posedge aload => (q +: q_tmp)) = (0, 0) ;
    (asdata => q) = (0, 0) ;
      
endspecify
   
initial
begin
    if (power_up == "high")
        q_tmp_dly = 1'b1;
    else
        q_tmp_dly = 1'b0;
end

always @(q_tmp)
begin
    q_tmp_dly <= q_tmp;
end

generate
    if (power_up != "high") begin
        PRIM_GDFF_LOW (q_tmp,d,clk,ena_in, !clrn_in || !devpor_in || !devclrn_in,!prn_in,aload_in,asdata_in,sclr_in,sload_in,viol);
    end
endgenerate

generate
    if (power_up == "high") begin
        PRIM_GDFF_HIGH (q_tmp,d,clk,ena_in,!clrn_in || !devpor_in || !devclrn_in,!prn_in,aload_in,asdata_in,sclr_in,sload_in,viol);
    end
endgenerate

endmodule

`timescale 1 ps / 1 ps
module prim_gtff (q, t, clk, ena, clr, pre );
    input t,clk,ena,clr,pre;
    output q;
    reg q;
    reg clk_pre;
    initial q = 1'b0;

    always@ (clk or clr or pre)
    begin
        if (clr ==  1'b1)
            q <= 1'b0;
        else if (pre == 1'b1)
            q <= 1'b1;
        else if ((clk == 1'b1) && (clk_pre == 1'b0))
        begin
            if (ena == 1'b1)
            begin
                if (t == 1'b1)
                    q <= ~q;
            end
        end
        clk_pre <= clk;
    end
endmodule

`timescale 1 ps / 1 ps
module tff (t, clk, clrn, prn, q );
    input t,clk,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn;

    prim_gtff inst (q, t, clk, 1'b1, !clrn, !prn);

endmodule

`timescale 1 ps / 1 ps
module tffe (t, clk, ena, clrn, prn,q );
    input t,clk,ena,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn, ena;

    prim_gtff inst (q, t, clk, ena, !clrn, !prn);

endmodule

`timescale 1 ps / 1 ps
module prim_gjkff (q, j, k, clk, ena, clr, pre );
    input j,k,clk,ena,clr,pre;
    output q;
    reg q;
    reg clk_pre;
    initial q = 1'b0;

    always@ (clk or clr or pre)
    begin
        if (clr)
            q <= 1'b0;
        else if (pre)
            q <= 1'b1;
        else if ((clk == 1'b1) && (clk_pre == 1'b0))
        begin
            if (ena == 1'b1)
            begin
                if (j && !k)
                    q <= 1'b1;
                else if (!j && k)
                    q <= 1'b0;
                else if (k && j)
                    q <= ~q;
            end
        end
        clk_pre <= clk;
    end
endmodule

`timescale 1 ps / 1 ps
module jkff (j, k, clk, clrn, prn, q );
    input j,k,clk,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn;

    prim_gjkff inst (q, j, k, clk, 1'b1, !clrn, !prn);

endmodule

`timescale 1 ps / 1 ps
module jkffe (j, k, clk, ena, clrn, prn,q );
    input j,k,clk,ena,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn, ena;

    prim_gjkff inst (q, j, k, clk, ena, !clrn, !prn);

endmodule

`timescale 1 ps / 1 ps
module prim_gsrff (q, s, r, clk, ena, clr, pre );
    input s,r,clk,ena,clr,pre;
    output q;
    reg q;
    reg clk_pre;
    initial q = 1'b0;

    always@ (clk or clr or pre)
    begin
        if (clr)
            q <= 1'b0;
        else if (pre)
            q <= 1'b1;
        else if ((clk == 1'b1) && (clk_pre == 1'b0))
        begin
            if (ena == 1'b1)
            begin
                if (s && !r)
                    q <= 1'b1;
                else if (!s && r)
                    q <= 1'b0;
                else if (s && r)
                    q <= ~q;
            end
        end
        clk_pre <= clk;
    end
endmodule

`timescale 1 ps / 1 ps
module srff (s, r, clk, clrn, prn, q );
    input s,r,clk,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn;

    prim_gsrff inst (q, s, r, clk, 1'b1, !clrn, !prn);

endmodule

`timescale 1 ps / 1 ps
module srffe (s, r, clk, ena, clrn, prn,q );
    input s,r,clk,ena,clrn,prn;
    output q;
    wire q;
    tri1 prn, clrn, ena;

    prim_gsrff inst (q, s, r, clk, ena, !clrn, !prn);

endmodule

`timescale 1 ps / 1 ps

// MODULE DECLARATION
module clklock (
    inclk,     // input reference clock
    outclk     // output clock
);

// GLOBAL PARAMETER DECLARATION
parameter input_frequency = 10000;  // units in ps
parameter clockboost = 1;

// INTERNAL PARAMETER DECLARATION
parameter valid_lock_cycles = 1;
parameter invalid_lock_cycles = 2;

// INPUT PORT DECLARATION
input inclk;

// OUTPUT PORT DECLARATION
output outclk;

// INTERNAL VARIABLE/REGISTER DECLARATION
reg outclk;

reg start_outclk;
reg outclk_tmp;
reg pll_lock;
reg clk_last_value;
reg violation;
reg clk_check;
reg [1:0] next_clk_check;

reg init;
    
real pll_last_rising_edge;
real pll_last_falling_edge;
real actual_clk_cycle;
real expected_clk_cycle;
real pll_duty_cycle;
real inclk_period;
real expected_next_clk_edge;
integer pll_rising_edge_count;
integer stop_lock_count;
integer start_lock_count;
integer clk_per_tolerance;


// variables for clock synchronizing
time last_synchronizing_rising_edge_for_outclk;
time outclk_synchronizing_period;
integer input_cycles_per_outclk;
integer outclk_cycles_per_sync_period;
integer input_cycle_count_to_sync0;

// variables for shedule_outclk
reg schedule_outclk;
reg output_value0;
time sched_time0;
integer rem0;
integer tmp_rem0;
integer clk_cnt0;
integer cyc0;
integer inc0;
integer cycle_to_adjust0;
time tmp_per0;
time ori_per0;
time high_time0;
time low_time0;


// INITIAL BLOCK
initial
begin

    // check for invalid parameters
    if (input_frequency <= 0)
    begin
        $display("ERROR: The period of the input clock (input_frequency) must be greater than 0");
        $stop;
    end

    if ((clockboost != 1) && (clockboost != 2))
    begin
        $display("ERROR: The clock multiplication factor (clockboost) must be a value of 1 or 2.");
        $stop;
    end


    stop_lock_count = 0;
    violation = 0;

    // clock synchronizing variables
    last_synchronizing_rising_edge_for_outclk = 0;
    outclk_synchronizing_period = 0;
    input_cycles_per_outclk = 1;
    outclk_cycles_per_sync_period = clockboost;
    input_cycle_count_to_sync0 = 0;
    inc0 = 1;
    cycle_to_adjust0 = 0;

    outclk_cycles_per_sync_period = clockboost;
    input_cycles_per_outclk = 1;

    clk_per_tolerance = 0.1 * input_frequency;
end

always @(next_clk_check)
begin
    if (next_clk_check == 1)
    begin
        if ((clk_check === 1'b1) || (clk_check === 1'b0))
            #((inclk_period+clk_per_tolerance)/2) clk_check = ~clk_check;
        else
            #((inclk_period+clk_per_tolerance)/2) clk_check = 1'b1;
    end
    else if (next_clk_check == 2)
    begin
        if ((clk_check === 1'b1) || (clk_check === 1'b0))
            #(expected_next_clk_edge - $realtime) clk_check = ~clk_check;
        else
            #(expected_next_clk_edge - $realtime) clk_check = 1'b1;
    end
    next_clk_check = 0;
end

always @(inclk or clk_check)
begin

    if(init !== 1'b1)
    begin
        start_lock_count = 0;
        pll_rising_edge_count = 0;
        pll_last_rising_edge = 0;
        pll_last_falling_edge = 0;
        pll_lock = 0;
        init = 1'b1;
    end

    if ((inclk == 1'b1) && (clk_last_value !== inclk))
    begin
        if (pll_lock === 1)
            next_clk_check = 1;

        if (pll_rising_edge_count == 0)   // this is first rising edge
        begin
            inclk_period = input_frequency;
            pll_duty_cycle = inclk_period/2;
            start_outclk = 0;
        end
        else if (pll_rising_edge_count == 1) // this is second rising edge
        begin
            expected_clk_cycle = inclk_period;
            actual_clk_cycle = $realtime - pll_last_rising_edge;
            if (actual_clk_cycle < (expected_clk_cycle - clk_per_tolerance) ||
                actual_clk_cycle > (expected_clk_cycle + clk_per_tolerance))
            begin
                $display($realtime, "ps Warning: Inclock_Period Violation");
                $display ("Instance: %m");
                violation = 1;
                if (pll_lock == 1'b1)
                begin
                    stop_lock_count = stop_lock_count + 1;
                    if ((pll_lock == 1'b1) && (stop_lock_count == invalid_lock_cycles))
                    begin
                        pll_lock = 0;
                        $display ($realtime, "ps Warning: altclklock out of lock.");
                        $display ("Instance: %m");                        
                        start_lock_count = 1;
                        stop_lock_count = 0;
                        outclk_tmp = 1'bx;
                    end
                end
                else begin
                    start_lock_count = 1;
                end
            end
            else
            begin
                if (($realtime - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) ||
                    ($realtime - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2))
                begin
                    $display($realtime, "ps Warning: Duty Cycle Violation");
                    $display ("Instance: %m");
                    violation = 1;
                end
                else
                    violation = 0;
            end
        end
        else if (($realtime - pll_last_rising_edge) < (expected_clk_cycle - clk_per_tolerance) ||
                ($realtime - pll_last_rising_edge) > (expected_clk_cycle + clk_per_tolerance))
        begin
            $display($realtime, "ps Warning: Cycle Violation");
            $display ("Instance: %m");
            violation = 1;
            if (pll_lock == 1'b1)
            begin
                stop_lock_count = stop_lock_count + 1;
                if (stop_lock_count == invalid_lock_cycles)
                begin
                    pll_lock = 0;
                    $display ($realtime, "ps Warning: altclklock out of lock.");
                    $display ("Instance: %m");
                    start_lock_count = 1;
                    stop_lock_count = 0;
                    outclk_tmp = 1'bx;
                end
            end
            else
            begin
                start_lock_count = 1;
            end
        end
        else
        begin
            violation = 0;
            actual_clk_cycle = $realtime - pll_last_rising_edge;
        end
        pll_last_rising_edge = $realtime;
        pll_rising_edge_count = pll_rising_edge_count + 1;
        if (!violation)
        begin
            if (pll_lock == 1'b1)
            begin
                input_cycle_count_to_sync0 = input_cycle_count_to_sync0 + 1;
                if (input_cycle_count_to_sync0 == input_cycles_per_outclk)
                begin
                    outclk_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_outclk;
                    last_synchronizing_rising_edge_for_outclk = $realtime;
                    schedule_outclk = 1;
                    input_cycle_count_to_sync0 = 0;
                end
            end
            else
            begin
                start_lock_count = start_lock_count + 1;
                if (start_lock_count >= valid_lock_cycles)
                begin
                    pll_lock = 1;
                    input_cycle_count_to_sync0 = 0;
                    outclk_synchronizing_period = actual_clk_cycle * input_cycles_per_outclk;
                    last_synchronizing_rising_edge_for_outclk = $realtime;
                    schedule_outclk = 1;
                end
            end
        end
        else
            start_lock_count = 1;
    end
    else if ((inclk == 1'b0) && (clk_last_value !== inclk))
    begin
        if (pll_lock == 1)
        begin
            next_clk_check = 1;
            if (($realtime - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) ||
                ($realtime - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2))
            begin
                $display($realtime, "ps Warning: Duty Cycle Violation");
                $display ("Instance: %m");
                violation = 1;
                if (pll_lock == 1'b1)
                begin
                    stop_lock_count = stop_lock_count + 1;
                    if (stop_lock_count == invalid_lock_cycles)
                    begin
                        pll_lock = 0;
                        $display ($realtime, "ps Warning: clklock out of lock.");
                        $display ("Instance: %m");
                        start_lock_count = 0;

                        stop_lock_count = 0;
                        outclk_tmp = 1'bx;
                    end
                end
            end
            else
                violation = 0;
        end
        pll_last_falling_edge = $realtime;
    end
    else if (pll_lock == 1)
    begin
    if (inclk == 1'b1)
        expected_next_clk_edge = pll_last_rising_edge + (inclk_period+clk_per_tolerance)/2;
    else if (inclk == 'b0)
        expected_next_clk_edge = pll_last_falling_edge + (inclk_period+clk_per_tolerance)/2;
    else
        expected_next_clk_edge = 0;
        violation = 0;
        if ($realtime < expected_next_clk_edge)
            next_clk_check = 2;
        else if ($realtime == expected_next_clk_edge)
            next_clk_check = 1;
        else
        begin
            $display($realtime, "ps Warning: Inclock_Period Violation");
            $display ("Instance: %m");
            violation = 1;

            if (pll_lock == 1'b1)
            begin
                stop_lock_count = stop_lock_count + 1;
                expected_next_clk_edge = $realtime + (inclk_period/2);
                if (stop_lock_count == invalid_lock_cycles)
                begin
                    pll_lock = 0;
                    $display ($realtime, "ps Warning: altclklock out of lock.");
                    $display ("Instance: %m");
                    start_lock_count = 1;
                    stop_lock_count = 0;
                    outclk_tmp = 1'bx;
                end
                else
                    next_clk_check = 2;
            end
        end
    end
    clk_last_value = inclk;
end

// outclk output
always @(posedge schedule_outclk)
begin
    // initialise variables
    inc0 = 1;
    cycle_to_adjust0 = 0;
    output_value0 = 1'b1;
    sched_time0 = 0;
    rem0 = outclk_synchronizing_period % outclk_cycles_per_sync_period;
    ori_per0 = outclk_synchronizing_period / outclk_cycles_per_sync_period;

    // schedule <outclk_cycles_per_sync_period> number of outclk cycles in this
    // loop - in order to synchronize the output clock always to the input clock
    // to get rid of clock drift for cases where the input clock period is
    // not evenly divisible
    for (clk_cnt0 = 1; clk_cnt0 <= outclk_cycles_per_sync_period;
        clk_cnt0 = clk_cnt0 + 1)
    begin
        tmp_per0 = ori_per0;
        if ((rem0 != 0) && (inc0 <= rem0))
        begin
            tmp_rem0 = (outclk_cycles_per_sync_period * inc0) % rem0;
            cycle_to_adjust0 = (outclk_cycles_per_sync_period * inc0) / rem0;
            if (tmp_rem0 != 0)
                cycle_to_adjust0 = cycle_to_adjust0 + 1;
        end

        // if this cycle is the one to adjust the output clock period, then
        // increment the period by 1 unit
        if (cycle_to_adjust0 == clk_cnt0)
        begin
            tmp_per0 = tmp_per0 + 1;
            inc0 = inc0 + 1;
        end

        // adjust the high and low cycle period
        high_time0 = tmp_per0 / 2;
        if ((tmp_per0 % 2) != 0)
            high_time0 = high_time0 + 1;

        low_time0 = tmp_per0 - high_time0;

        // schedule the high and low cycle of 1 output clock period
        for (cyc0 = 0; cyc0 <= 1; cyc0 = cyc0 + 1)
        begin
            // Avoid glitch in vcs when high_time0 and low_time0 is 0
            // (due to outclk_synchronizing_period is 0)
            if (outclk_synchronizing_period != 0)
                outclk_tmp = #(sched_time0) output_value0;
            else
                outclk_tmp = #(sched_time0) 1'b0;
            output_value0 = ~output_value0;
            if (output_value0 == 1'b0)
            begin
                sched_time0 = high_time0;
            end
            else if (output_value0 == 1'b1)
            begin
                sched_time0 = low_time0;
            end
        end
    end

    // drop the schedule_outclk to 0 so that the "always@(inclk)" block can
    // trigger this block again when the correct time comes
    schedule_outclk = #1 1'b0;
end

always @(outclk_tmp)
begin
        outclk <= outclk_tmp;
end

endmodule // clklock
// END OF MODULE CLKLOCK

`timescale 1 ps / 1 ps
module alt_inbuf (i, o);
    input i;
    output o;
    
    parameter io_standard = "NONE";
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter lpm_type = "alt_inbuf";
    
    assign o = i;
endmodule

`timescale 1 ps / 1 ps
module alt_outbuf (i, o);
    input i;
    output o;

    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter slow_slew_rate = "NONE";
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter lpm_type = "alt_outbuf";
    
    assign o = i;
endmodule

`timescale 1 ps / 1 ps
module alt_outbuf_tri (i, oe, o);
    input i;
    input oe;
    output o;

    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter slow_slew_rate = "NONE";
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter lpm_type = "alt_outbuf_tri";
    
    bufif1 (o, i, oe);
endmodule

`timescale 1 ps / 1 ps
module alt_iobuf (i, oe, io, o);
    input i;
    input oe;
    inout io;
    output o;
    reg    o;

    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter slow_slew_rate = "NONE";
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter input_termination = "NONE"; 
    parameter output_termination = "NONE";     
    parameter lpm_type = "alt_iobuf";
    
    always @(io)
    begin
        o = io;
    end

    assign io = (oe == 1) ? i : 1'bz;
endmodule

`timescale 1 ps / 1 ps
module alt_inbuf_diff (i, ibar, o);
    input i;
    input ibar;
    output o;
        
    parameter io_standard = "NONE";
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter lpm_type = "alt_inbuf_diff";

    reg out_tmp;

    always@(i or ibar)
    begin
        casex({i,ibar})
            2'b00: out_tmp = 1'bx;
            2'b01: out_tmp = 1'b0;
            2'b10: out_tmp = 1'b1;
            2'b11: out_tmp = 1'bx;
            default: out_tmp = 1'bx;
        endcase
    end

    assign o = out_tmp; 

endmodule

`timescale 1 ps / 1 ps
module alt_outbuf_diff (i, o, obar);
    input i;
    output o;
    output obar;
        
    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter lpm_type = "alt_outbuf_diff";

    assign o = i;
    assign obar = !i; 

endmodule

`timescale 1 ps / 1 ps
module alt_outbuf_tri_diff (i, oe, o, obar);
    input i;
    input oe;
    output o;
    output obar;
        
    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter lpm_type = "alt_outbuf_tri_diff";
    
    bufif1 (o, i, oe);
    bufif1 (obar, !i, oe);

endmodule

`timescale 1 ps / 1 ps
module alt_iobuf_diff (i, oe, io, iobar, o);
    input i;
    input oe;
    inout io;
    inout iobar;
    output o;
        
    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter input_termination = "NONE"; 
    parameter output_termination = "NONE"; 
    parameter lpm_type = "alt_iobuf_diff";

    reg out_tmp;

    always @(io or iobar)
    begin
    casex({io,iobar})
            2'b00: out_tmp = 1'bx;
            2'b01: out_tmp = 1'b0;
            2'b10: out_tmp = 1'b1;
            2'b11: out_tmp = 1'bx;
            default: out_tmp = 1'bx;
        endcase
    end

    assign o = out_tmp;
    assign io = (oe === 1'b1) ? i : (oe === 1'b0) ? 1'bz : 1'bx;
    assign iobar = (oe == 1'b1) ? !i : (oe == 1'b0) ?  1'bz : 1'bx;

endmodule

`timescale 1 ps / 1 ps
module alt_bidir_diff (oe, bidirin, io, iobar);
    input oe;
    inout bidirin;
    inout io;
    inout iobar;
        
    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter input_termination = "NONE"; 
    parameter output_termination = "NONE"; 
    parameter lpm_type = "alt_bidir_diff";
    
    reg out_tmp;

    always @(io or iobar)
    begin
    casex({io,iobar})
            2'b00: out_tmp = 1'bx;
            2'b01: out_tmp = 1'b0;
            2'b10: out_tmp = 1'b1;
            2'b11: out_tmp = 1'bx;
            default: out_tmp = 1'bx;
        endcase
    end

    assign bidirin = (oe === 1'b0) ? out_tmp : (oe === 1'b1) ? 1'bz : 1'bx;
    assign io = (oe === 1'b1) ? bidirin : (oe === 1'b0) ? 1'bz : 1'bx;
    assign iobar = (oe == 1'b1) ? !bidirin : (oe == 1'b0) ?  1'bz : 1'bx;

endmodule

`timescale 1 ps / 1 ps
module alt_bidir_buf (oe, bidirin, io);
    input oe;
    inout bidirin;
    inout io;
        
    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter input_termination = "NONE"; 
    parameter output_termination = "NONE"; 
    parameter lpm_type = "alt_bidir_diff";
    
    reg out_tmp;

    always @(io)
    begin
    casex(io)
            1'b0: out_tmp = 1'b0;
            1'b1: out_tmp = 1'b1;
            default: out_tmp = 1'bx;
        endcase
    end

    assign bidirin = (oe === 1'b0) ? out_tmp : (oe === 1'b1) ? 1'bz : 1'bx;
    assign io = (oe === 1'b1) ? bidirin : (oe === 1'b0) ? 1'bz : 1'bx;

endmodule

primitive PRIM_GDFF_LOW (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier );
    input d,clk,ena,clr,pre,ald,adt,sclr,sload,notifier;
    output q;
    reg q;
    initial q = 1'b0;

    table
    ////d,clk, ena,clr,pre,ald,adt,sclr,sload,notifier : q : q'
        ? ?    ?   1   ?   ?   ?   ?    ?     ?        : ? : 0; // aclr
        ? ?    ?   0   1   ?   ?   ?    ?     ?        : ? : 1; // apre
        ? ?    ?   0   0   1   0   ?    ?     ?        : ? : 0; // aload 0
        ? ?    ?   0   0   1   1   ?    ?     ?        : ? : 1; // aload 1

        0 (01) 1   0   0   0   ?   0    0     ?        : ? : 0; // din 0
        1 (01) 1   0   0   0   ?   0    0     ?        : ? : 1; // din 1
        ? (01) 1   0   0   0   ?   1    ?     ?        : ? : 0; // sclr
        ? (01) 1   0   0   0   0   0    1     ?        : ? : 0; // sload 0
        ? (01) 1   0   0   0   1   0    1     ?        : ? : 1; // sload 1

        ? ?    0   0   0   0   ?   ?    ?     ?        : ? : -; // no asy no ena
        * ?    ?   ?   ?   ?   ?   ?    ?     ?        : ? : -; // data edges
        ? (?0) ?   ?   ?   ?   ?   ?    ?     ?        : ? : -; // ignore falling clk
        ? ?    *   ?   ?   ?   ?   ?    ?     ?        : ? : -; // enable edges
        ? ?    ?   (?0)?   ?   ?   ?    ?     ?        : ? : -; // falling asynchs
        ? ?    ?   ?  (?0) ?   ?   ?    ?     ?        : ? : -;
        ? ?    ?   ?   ?  (?0) ?   ?    ?     ?        : ? : -;
        ? ?    ?   ?   ?   0   *   ?    ?     ?        : ? : -; // ignore adata edges when not aloading
        ? ?    ?   ?   ?   ?   ?   *    ?     ?        : ? : -; // sclr edges
        ? ?    ?   ?   ?   ?   ?   ?    *     ?        : ? : -; // sload edges

        ? (x?) 1   0   0   0   ?   ?    ?     ?        : ? : -; // ignore x transition of clock
        ? (?x) 1   0   0   0   ?   ?    ?     ?        : ? : -; // ignore x transition of clock
        ? ?    ?   x   ?   ?   ?   ?    ?     ?        : ? : -; // ignore x input of clrn
        ? ?    ?   0   x   ?   ?   ?    ?     ?        : ? : -; // ignore x input of pre
        ? ?    ?   0   0   x   ?   ?    ?     ?        : ? : -; // ignore x input of aload
        ? ?    x   0   0   0   ?   ?    ?     ?        : ? : -; // ignore x input of ena
        ? (01) 1   0   0   0   ?   x    ?     ?        : ? : -; // ignore x input of sclr
        ? (01) 1   0   0   0   ?   0    x     ?        : ? : -; // ignore x input of sload
        ? ?    ?   0   0   ?   ?   ?    ?     *        : ? : x; // at any notifier event, output x

    endtable
endprimitive

primitive PRIM_GDFF_HIGH (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier );
    input d,clk,ena,clr,pre,ald,adt,sclr,sload,notifier;
output q;
    reg q;
    initial q = 1'b1;

    table
    ////d,clk, ena,clr,pre,ald,adt,sclr,sload,notifier : q : q'
        ? ?    ?   1   ?   ?   ?   ?    ?     ?        : ? : 0; // aclr
        ? ?    ?   0   1   ?   ?   ?    ?     ?        : ? : 1; // apre
        ? ?    ?   0   0   1   0   ?    ?     ?        : ? : 0; // aload 0
        ? ?    ?   0   0   1   1   ?    ?     ?        : ? : 1; // aload 1

        0 (01) 1   0   0   0   ?   0    0     ?        : ? : 0; // din 0
        1 (01) 1   0   0   0   ?   0    0     ?        : ? : 1; // din 1
        ? (01) 1   0   0   0   ?   1    ?     ?        : ? : 0; // sclr
        ? (01) 1   0   0   0   0   0    1     ?        : ? : 0; // sload 0
        ? (01) 1   0   0   0   1   0    1     ?        : ? : 1; // sload 1

        ? ?    0   0   0   0   ?   ?    ?     ?        : ? : -; // no asy no ena
        * ?    ?   ?   ?   ?   ?   ?    ?     ?        : ? : -; // data edges
        ? (?0) ?   ?   ?   ?   ?   ?    ?     ?        : ? : -; // ignore falling clk
        ? ?    *   ?   ?   ?   ?   ?    ?     ?        : ? : -; // enable edges
        ? ?    ?   (?0)?   ?   ?   ?    ?     ?        : ? : -; // falling asynchs
        ? ?    ?   ?  (?0) ?   ?   ?    ?     ?        : ? : -;
        ? ?    ?   ?   ?  (?0) ?   ?    ?     ?        : ? : -;
        ? ?    ?   ?   ?   0   *   ?    ?     ?        : ? : -; // ignore adata edges when not aloading
        ? ?    ?   ?   ?   ?   ?   *    ?     ?        : ? : -; // sclr edges
        ? ?    ?   ?   ?   ?   ?   ?    *     ?        : ? : -; // sload edges
        
        ? (x?) 1   0   0   0   ?   ?    ?     ?        : ? : -; // ignore x transition of clock
        ? (?x) 1   0   0   0   ?   ?    ?     ?        : ? : -; // ignore x transition of clock
        ? ?    ?   x   ?   ?   ?   ?    ?     ?        : ? : -; // ignore x input of clrn
        ? ?    ?   0   x   ?   ?   ?    ?     ?        : ? : -; // ignore x input of pre
        ? ?    ?   0   0   x   ?   ?    ?     ?        : ? : -; // ignore x input of aload
        ? ?    x   0   0   0   ?   ?    ?     ?        : ? : -; // ignore x input of ena
        ? (01) 1   0   0   0   ?   x    ?     ?        : ? : -; // ignore x input of sclr
        ? (01) 1   0   0   0   ?   0    x     ?        : ? : -; // ignore x input of sload
        ? ?    ?   0   0   ?   ?   ?    ?     *        : ? : x; // at any notifier event, output x

    endtable
endprimitive
