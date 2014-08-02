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
`ifdef MODEL_TECH
`mti_v2k_int_delays_on

`endif

// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

primitive CYCLONEIIILS_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
   input D;   
   input CLRN;
   input PRN;
   input CLK;
   input ENA;
   input notifier;
   output Q; reg Q;

   initial Q = 1'b0;

    table

    //  ENA  D   CLK   CLRN  PRN  notifier  :   Qt  :   Qt+1

        (??) ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         x   ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         1   1   (01)    1    1      ?      :   ?   :   1;  // clocked data
         1   1   (01)    1    x      ?      :   ?   :   1;  // pessimism
 
         1   1    ?      1    x      ?      :   1   :   1;  // pessimism
 
         1   0    0      1    x      ?      :   1   :   1;  // pessimism
         1   0    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   0    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   x    0      1    x      ?      :   1   :   1;  // pessimism
         1   x    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   x    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   0   (01)    1    1      ?      :   ?   :   0;  // clocked data

         1   0   (01)    x    1      ?      :   ?   :   0;  // pessimism

         1   0    ?      x    1      ?      :   0   :   0;  // pessimism
         0   ?    ?      x    1      ?      :   ?   :   -;

         1   1    0      x    1      ?      :   0   :   0;  // pessimism
         1   1    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   1    1    (?x)   1      ?      :   0   :   0;  // pessimism

         1   x    0      x    1      ?      :   0   :   0;  // pessimism
         1   x    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   x    1    (?x)   1      ?      :   0   :   0;  // pessimism

//       1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
//       1   0   (x1)    1    1      ?      :   0   :   0;
         1   ?   (x1)    1    1      ?      :   ?   :   -;  // spr 80166-ignore
                                                            // x->1 edge
         1   1   (0x)    1    1      ?      :   1   :   1;
         1   0   (0x)    1    1      ?      :   0   :   0;

         ?   ?   ?       0    0      ?      :   ?   :   0;  // clear wins preset
         ?   ?   ?       0    1      ?      :   ?   :   0;  // asynch clear

         ?   ?   ?       1    0      ?      :   ?   :   1;  // asynch set

         1   ?   (?0)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   ?   (1x)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   *    ?      ?    ?      ?      :   ?   :   -; // ignore data edges

         1   ?   ?     (?1)   ?      ?      :   ?   :   -;  // ignore edges on
         1   ?   ?       ?  (?1)     ?      :   ?   :   -;  //  set and clear

         0   ?   ?       1    1      ?      :   ?   :   -;  //  set and clear

	 ?   ?   ?       1    1      *      :   ?   :   x; // spr 36954 - at any
							   // notifier event,
							   // output 'x'
    endtable

endprimitive

primitive CYCLONEIIILS_PRIM_DFFEAS (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
    input d,clk,ena,clr,pre,ald,adt,sclr,sload, notifier;
    output q;
    reg q;
    initial
    q = 1'b0;

    table
    ////d,clk, ena,clr,pre,ald,adt,sclr,sload,notifier: q : q'
        ? ?    ?   1   ?   ?   ?   ?    ?     ?       : ? : 0; // aclr
        ? ?    ?   0   1   ?   ?   ?    ?     ?       : ? : 1; // apre
        ? ?    ?   0   0   1   0   ?    ?     ?       : ? : 0; // aload 0
        ? ?    ?   0   0   1   1   ?    ?     ?       : ? : 1; // aload 1

        0 (01) 1   0   0   0   ?   0    0     ?       : ? : 0; // din 0
        1 (01) 1   0   0   0   ?   0    0     ?       : ? : 1; // din 1
        ? (01) 1   0   0   0   ?   1    ?     ?       : ? : 0; // sclr
        ? (01) 1   0   0   0   0   0    1     ?       : ? : 0; // sload 0
        ? (01) 1   0   0   0   1   0    1     ?       : ? : 1; // sload 1

        ? ?    0   0   0   0   ?   ?    ?     ?       : ? : -; // no asy no ena
        * ?    ?   ?   ?   ?   ?   ?    ?     ?       : ? : -; // data edges
        ? (?0) ?   ?   ?   ?   ?   ?    ?     ?       : ? : -; // ignore falling clk
        ? ?    *   ?   ?   ?   ?   ?    ?     ?       : ? : -; // enable edges
        ? ?    ?   (?0)?   ?   ?   ?    ?     ?       : ? : -; // falling asynchs
        ? ?    ?   ?  (?0) ?   ?   ?    ?     ?       : ? : -;
        ? ?    ?   ?   ?  (?0) ?   ?    ?     ?       : ? : -;
        ? ?    ?   ?   ?   0   *   ?    ?     ?       : ? : -; // ignore adata edges when not aloading
        ? ?    ?   ?   ?   ?   ?   *    ?     ?       : ? : -; // sclr edges
        ? ?    ?   ?   ?   ?   ?   ?    *     ?       : ? : -; // sload edges

        ? (x1) 1   0   0   0   ?   0    0     ?        : ? : -; // ignore x->1 transition of clock
        ? ?    1   0   0   x   ?   0    0     ?        : ? : -; // ignore x input of aload
        ? ?    ?   1   1   ?   ?   ?    ?     *       : ? : x; // at any notifier event, output x

    endtable
endprimitive

primitive CYCLONEIIILS_PRIM_DFFEAS_HIGH (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
    input d,clk,ena,clr,pre,ald,adt,sclr,sload, notifier;
    output q;
    reg q;
    initial
    q = 1'b1;

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

        ? (x1) 1   0   0   0   ?   0    0     ?        : ? : -; // ignore x->1 transition of clock
        ? ?    1   0   0   x   ?   0    0     ?        : ? : -; // ignore x input of aload
        ? ?    ?   1   1   ?   ?   ?    ?     *        : ? : x; // at any notifier event, output x

    endtable
endprimitive

module cycloneiiils_dffe ( Q, CLK, ENA, D, CLRN, PRN );
   input D;
   input CLK;
   input CLRN;
   input PRN;
   input ENA;
   output Q;
   
   wire D_ipd;
   wire ENA_ipd;
   wire CLK_ipd;
   wire PRN_ipd;
   wire CLRN_ipd;
   
   buf (D_ipd, D);
   buf (ENA_ipd, ENA);
   buf (CLK_ipd, CLK);
   buf (PRN_ipd, PRN);
   buf (CLRN_ipd, CLRN);
   
   wire   legal;
   reg 	  viol_notifier;
   
   CYCLONEIIILS_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
   and(legal, ENA_ipd, CLRN_ipd, PRN_ipd);
   specify
      
      specparam TREG = 0;
      specparam TREN = 0;
      specparam TRSU = 0;
      specparam TRH  = 0;
      specparam TRPR = 0;
      specparam TRCL = 0;
      
      $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
      $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
      $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
      $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
      ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
      ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
      ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
      
   endspecify
endmodule     


// ***** cycloneiiils_mux21

module cycloneiiils_mux21 (MO, A, B, S);
   input A, B, S;
   output MO;
   
   wire A_in;
   wire B_in;
   wire S_in;

   buf(A_in, A);
   buf(B_in, B);
   buf(S_in, S);

   wire   tmp_MO;
   
   specify
      (A => MO) = (0, 0);
      (B => MO) = (0, 0);
      (S => MO) = (0, 0);
   endspecify

   assign tmp_MO = (S_in == 1) ? B_in : A_in;
   
   buf (MO, tmp_MO);
endmodule

// ***** cycloneiiils_mux41

module cycloneiiils_mux41 (MO, IN0, IN1, IN2, IN3, S);
   input IN0;
   input IN1;
   input IN2;
   input IN3;
   input [1:0] S;
   output MO;
   
   wire IN0_in;
   wire IN1_in;
   wire IN2_in;
   wire IN3_in;
   wire S1_in;
   wire S0_in;

   buf(IN0_in, IN0);
   buf(IN1_in, IN1);
   buf(IN2_in, IN2);
   buf(IN3_in, IN3);
   buf(S1_in, S[1]);
   buf(S0_in, S[0]);

   wire   tmp_MO;
   
   specify
      (IN0 => MO) = (0, 0);
      (IN1 => MO) = (0, 0);
      (IN2 => MO) = (0, 0);
      (IN3 => MO) = (0, 0);
      (S[1] => MO) = (0, 0);
      (S[0] => MO) = (0, 0);
   endspecify

   assign tmp_MO = S1_in ? (S0_in ? IN3_in : IN2_in) : (S0_in ? IN1_in : IN0_in);

   buf (MO, tmp_MO);

endmodule

// ***** cycloneiiils_and1

module cycloneiiils_and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** cycloneiiils_and16

module cycloneiiils_and16 (Y, IN1);
   input [15:0] IN1;
   output [15:0] Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y[0], IN1[0]);
   buf (Y[1], IN1[1]);
   buf (Y[2], IN1[2]);
   buf (Y[3], IN1[3]);
   buf (Y[4], IN1[4]);
   buf (Y[5], IN1[5]);
   buf (Y[6], IN1[6]);
   buf (Y[7], IN1[7]);
   buf (Y[8], IN1[8]);
   buf (Y[9], IN1[9]);
   buf (Y[10], IN1[10]);
   buf (Y[11], IN1[11]);
   buf (Y[12], IN1[12]);
   buf (Y[13], IN1[13]);
   buf (Y[14], IN1[14]);
   buf (Y[15], IN1[15]);
   
endmodule

// ***** cycloneiiils_bmux21

module cycloneiiils_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** cycloneiiils_b17mux21

module cycloneiiils_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** cycloneiiils_nmux21

module cycloneiiils_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** cycloneiiils_b5mux21

module cycloneiiils_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********



// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** cycloneiiils_latch

module cycloneiiils_latch(D, ENA, PRE, CLR, Q);
   
   input D;
   input ENA, PRE, CLR;
   output Q;
   
   reg 	  q_out;
   
   specify
      $setup (D, negedge ENA, 0) ;
      $hold (negedge ENA, D, 0) ;
      
      (D => Q) = (0, 0);
      (negedge ENA => (Q +: q_out)) = (0, 0);
      (negedge PRE => (Q +: q_out)) = (0, 0);
      (negedge CLR => (Q +: q_out)) = (0, 0);
   endspecify
   
   wire D_in;
   wire ENA_in;
   wire PRE_in;
   wire CLR_in;
   
   buf (D_in, D);
   buf (ENA_in, ENA);
   buf (PRE_in, PRE);
   buf (CLR_in, CLR);
   
   initial
      begin
	 q_out <= 1'b0;
      end
   
   always @(D_in or ENA_in or PRE_in or CLR_in)
      begin
	 if (PRE_in == 1'b0)
	    begin
	       // latch being preset, preset is active low
	       q_out <= 1'b1;
	    end
	 else if (CLR_in == 1'b0)
	    begin
	       // latch being cleared, clear is active low
	       q_out <= 1'b0;
	    end
	      else if (ENA_in == 1'b1)
		 begin
		    // latch is transparent
		    q_out <= D_in;
		 end
      end
   
   and (Q, q_out, 1'b1);
   
endmodule


// ********** END PRIMITIVE DEFINITIONS **********


//------------------------------------------------------------------
//
// Module Name : cycloneiiils_routing_wire
//
// Description : Simulation model for a simple routing wire
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module cycloneiiils_routing_wire (
                               datain,
                               dataout
                               );

    // INPUT PORTS
    input datain;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES
    wire dataout_tmp;

    specify

        (datain => dataout) = (0, 0) ;

    endspecify

    assign dataout_tmp = datain;

    and (dataout, dataout_tmp, 1'b1);

endmodule // cycloneiiils_routing_wire
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneiiils_m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the CYCLONEIIILS PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module cycloneiiils_m_cntr   ( clk,
                            reset,
                            cout,
                            initial_value,
                            modulus,
                            time_delay);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] initial_value;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
            cout_tmp <= tmp_cout;
        end
        else begin
            if (clk_last_value !== clk)
            begin
                if (clk === 1'b1 && first_rising_edge)
            begin
                first_rising_edge = 0;
                tmp_cout = clk;
                cout_tmp <= #(time_delay) tmp_cout;
            end
            else if (first_rising_edge == 0)
            begin
                if (count < modulus)
                    count = count + 1;
                else
                begin
                    count = 1;
                    tmp_cout = ~tmp_cout;
                    cout_tmp <= #(time_delay) tmp_cout;
                end
            end
        end
        end
        clk_last_value = clk;

//        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // cycloneiiils_m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneiiils_n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the CYCLONEIIILS PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module cycloneiiils_n_cntr   ( clk,
                            reset,
                            cout,
                            modulus);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] modulus;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
        end
        else begin
            if (clk == 1 && clk_last_value !== clk && first_rising_edge)
            begin
                first_rising_edge = 0;
                tmp_cout = clk;
            end
            else if (first_rising_edge == 0)
            begin
                if (count < modulus)
                    count = count + 1;
                else
                begin
                    count = 1;
                    tmp_cout = ~tmp_cout;
                end
            end
        end
        clk_last_value = clk;

    end

    assign cout = tmp_cout;

endmodule // cycloneiiils_n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneiiils_scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the C0-C9
//               output counters of the CYCLONEIIILS PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module cycloneiiils_scale_cntr   ( clk,
                                reset,
                                cout,
                                high,
                                low,
                                initial_value,
                                mode,
                                ph_tap);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] high;
    input [31:0] low;
    input [31:0] initial_value;
    input [8*6:1] mode;
    input [31:0] ph_tap;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg init;
    integer count;
    integer output_shift_count;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 0;
        tmp_cout = 0;
        output_shift_count = 1;
    end

    always @(clk or reset)
    begin
        if (init !== 1'b1)
        begin
            clk_last_value = 0;
            init = 1'b1;
        end
        if (reset)
        begin
            count = 1;
            output_shift_count = 1;
            tmp_cout = 0;
            first_rising_edge = 0;
        end
        else if (clk_last_value !== clk)
        begin
            if (mode == "   off")
                tmp_cout = 0;
            else if (mode == "bypass")
            begin
                tmp_cout = clk;
                first_rising_edge = 1;
            end
            else if (first_rising_edge == 0)
            begin
                if (clk == 1)
                begin
                    if (output_shift_count == initial_value)
                    begin
                        tmp_cout = clk;
                        first_rising_edge = 1;
                    end
                    else
                        output_shift_count = output_shift_count + 1;
                end
            end
            else if (output_shift_count < initial_value)
            begin
                if (clk == 1)
                    output_shift_count = output_shift_count + 1;
            end
            else
            begin
                count = count + 1;
                if (mode == "  even" && (count == (high*2) + 1))
                    tmp_cout = 0;
                else if (mode == "   odd" && (count == (high*2)))
                    tmp_cout = 0;
                else if (count == (high + low)*2 + 1)
                begin
                    tmp_cout = 1;
                    count = 1;        // reset count
                end
            end
        end
        clk_last_value = clk;
        cout_tmp <= tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // cycloneiiils_scale_cntr

//BEGIN MF PORTING DELETE
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneiiils_pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module cycloneiiils_pll_reg  ( q,
                            clk,
                            ena,
                            d,
                            clrn,
                            prn);

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // INTERNAL VARIABLES
    reg q;
    reg clk_last_value;

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q = 0;

    always @ (clk or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q <= 1;
        else if (clrn == 1'b0)
            q <= 0;
        else if ((clk === 1'b1) && (clk_last_value === 1'b0) && (ena === 1'b1))
            q <= d;

        clk_last_value = clk;
    end

endmodule // cycloneiiils_pll_reg
//END MF PORTING DELETE

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneiiils_pll
//
// Description : Timing simulation model for the Cyclone III LS PLL.
//               In the functional mode, it is also the model for the altpll
//               megafunction.
// 
// Limitations : Does not support Spread Spectrum and Bandwidth.
//
// Outputs     : Up to 10 output clocks, each defined by its own set of
//               parameters. Locked output (active high) indicates when the
//               PLL locks. clkbad and activeclock are used for
//               clock switchover to indicate which input clock has gone
//               bad, when the clock switchover initiates and which input
//               clock is being used as the reference, respectively.
//               scandataout is the data output of the serial scan chain.
//
// New Features : The list below outlines key new features in CYCLONEIIILS:
//                1. Dynamic Phase Reconfiguration
//                2. Dynamic PLL Reconfiguration (different protocol)
//                3. More output counters
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
`define WORD_LENGTH 18

module cycloneiiils_pll (inclk,
                    fbin,
                    fbout,
                    clkswitch,
                    areset,
                    pfdena,
                    scanclk,
                    scandata,
                    scanclkena,
                    configupdate,
                    clk,
                    phasecounterselect,
                    phaseupdown,
                    phasestep,
                    clkbad,
                    activeclock,
                    locked,
                    scandataout,
                    scandone,
                    phasedone,
                    vcooverrange,
                    vcounderrange
                    );

    parameter operation_mode                       = "normal";
    parameter pll_type                             = "auto"; // auto,fast(left_right),enhanced(top_bottom)
    parameter compensate_clock                     = "clock0";


    parameter inclk0_input_frequency               = 0;
    parameter inclk1_input_frequency               = 0;

    parameter self_reset_on_loss_lock        = "off";
    parameter switch_over_type                     = "auto";

    parameter switch_over_counter                  = 1;
    parameter enable_switch_over_counter           = "off";

    parameter bandwidth                            = 0;
    parameter bandwidth_type                       = "auto";
    parameter use_dc_coupling                      = "false";

    parameter lock_high = 0; // 0 .. 4095
    parameter lock_low = 0;  // 0 .. 7
    parameter lock_window_ui = "0.05"; // "0.05", "0.1", "0.15", "0.2"
    parameter test_bypass_lock_detect              = "off";
    
    parameter clk0_output_frequency                = 0;
    parameter clk0_multiply_by                     = 0;
    parameter clk0_divide_by                       = 0;
    parameter clk0_phase_shift                     = "0";
    parameter clk0_duty_cycle                      = 50;

    parameter clk1_output_frequency                = 0;
    parameter clk1_multiply_by                     = 0;
    parameter clk1_divide_by                       = 0;
    parameter clk1_phase_shift                     = "0";
    parameter clk1_duty_cycle                      = 50;

    parameter clk2_output_frequency                = 0;
    parameter clk2_multiply_by                     = 0;
    parameter clk2_divide_by                       = 0;
    parameter clk2_phase_shift                     = "0";
    parameter clk2_duty_cycle                      = 50;

    parameter clk3_output_frequency                = 0;
    parameter clk3_multiply_by                     = 0;
    parameter clk3_divide_by                       = 0;
    parameter clk3_phase_shift                     = "0";
    parameter clk3_duty_cycle                      = 50;

    parameter clk4_output_frequency                = 0;
    parameter clk4_multiply_by                     = 0;
    parameter clk4_divide_by                       = 0;
    parameter clk4_phase_shift                     = "0";
    parameter clk4_duty_cycle                      = 50;

    
    
    
    
    

    parameter pfd_min                              = 0;
    parameter pfd_max                              = 0;
    parameter vco_min                              = 0;
    parameter vco_max                              = 0;
    parameter vco_center                           = 0;

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 0;
    parameter n = 1;

    parameter c0_high = 1;
    parameter c0_low = 1;
    parameter c0_initial = 1;
    parameter c0_mode = "bypass";
    parameter c0_ph = 0;

    parameter c1_high = 1;
    parameter c1_low = 1;
    parameter c1_initial = 1;
    parameter c1_mode = "bypass";
    parameter c1_ph = 0;

    parameter c2_high = 1;
    parameter c2_low = 1;
    parameter c2_initial = 1;
    parameter c2_mode = "bypass";
    parameter c2_ph = 0;

    parameter c3_high = 1;
    parameter c3_low = 1;
    parameter c3_initial = 1;
    parameter c3_mode = "bypass";
    parameter c3_ph = 0;

    parameter c4_high = 1;
    parameter c4_low = 1;
    parameter c4_initial = 1;
    parameter c4_mode = "bypass";
    parameter c4_ph = 0;

    
    
    
    
    

    parameter m_ph = 0;

    parameter clk0_counter = "unused";
    parameter clk1_counter = "unused";
    parameter clk2_counter = "unused";
    parameter clk3_counter = "unused";
    parameter clk4_counter = "unused";

    parameter c1_use_casc_in = "off";
    parameter c2_use_casc_in = "off";
    parameter c3_use_casc_in = "off";
    parameter c4_use_casc_in = "off";

    parameter m_test_source  = -1;
    parameter c0_test_source = -1;
    parameter c1_test_source = -1;
    parameter c2_test_source = -1;
    parameter c3_test_source = -1;
    parameter c4_test_source = -1;

    parameter vco_multiply_by = 0;
    parameter vco_divide_by = 0;
    parameter vco_post_scale = 1; // 1 .. 2
    parameter vco_frequency_control = "auto";
    parameter vco_phase_shift_step = 0;
    
    parameter charge_pump_current = 10;
    parameter loop_filter_r = "1.0";    // "1.0", "2.0", "4.0", "6.0", "8.0", "12.0", "16.0", "20.0"
    parameter loop_filter_c = 0;        // 0 , 2 , 4

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "functional";
    parameter lpm_type = "cycloneiiils_pll";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter down_spread                          = "0.0";
    parameter lock_c = 4;

    parameter sim_gate_lock_device_behavior        = "off";

    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;
    parameter clk3_phase_shift_num = 0;
    parameter clk4_phase_shift_num = 0;
    parameter family_name = "Cyclone III LS";

    parameter clk0_use_even_counter_mode = "off";
    parameter clk1_use_even_counter_mode = "off";
    parameter clk2_use_even_counter_mode = "off";
    parameter clk3_use_even_counter_mode = "off";
    parameter clk4_use_even_counter_mode = "off";

    parameter clk0_use_even_counter_value = "off";
    parameter clk1_use_even_counter_value = "off";
    parameter clk2_use_even_counter_value = "off";
    parameter clk3_use_even_counter_value = "off";
    parameter clk4_use_even_counter_value = "off";

    // TEST ONLY
    
    parameter init_block_reset_a_count = 1;
    parameter init_block_reset_b_count = 1;

// SIMULATION_ONLY_PARAMETERS_END
    
// LOCAL_PARAMETERS_BEGIN

    parameter phase_counter_select_width = 3;
    parameter lock_window = 5;
    parameter inclk0_freq = inclk0_input_frequency;
    parameter inclk1_freq = inclk1_input_frequency;
   
parameter charge_pump_current_bits = 0;
parameter lock_window_ui_bits = 0;
parameter loop_filter_c_bits = 0;
parameter loop_filter_r_bits = 0;
parameter test_counter_c0_delay_chain_bits = 0;
parameter test_counter_c1_delay_chain_bits = 0;
parameter test_counter_c2_delay_chain_bits = 0;
parameter test_counter_c3_delay_chain_bits = 0;
parameter test_counter_c4_delay_chain_bits = 0;
parameter test_counter_c5_delay_chain_bits = 0;
parameter test_counter_m_delay_chain_bits = 0;
parameter test_counter_n_delay_chain_bits = 0;
parameter test_feedback_comp_delay_chain_bits = 0;
parameter test_input_comp_delay_chain_bits = 0;
parameter test_volt_reg_output_mode_bits = 0;
parameter test_volt_reg_output_voltage_bits = 0;
parameter test_volt_reg_test_mode = "false";
parameter vco_range_detector_high_bits = -1;
parameter vco_range_detector_low_bits = -1;
parameter scan_chain_mif_file = ""; 


parameter auto_settings = "true";

// LOCAL_PARAMETERS_END
 
    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input clkswitch;
    input areset;
    input pfdena;
    input [phase_counter_select_width - 1:0] phasecounterselect;
    input phaseupdown;
    input phasestep;
    input scanclk;
    input scanclkena;
    input scandata;
    input configupdate;

    // OUTPUT PORTS
    output [4:0] clk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output scandataout;
    output scandone;
    output fbout;
    output phasedone;
    output vcooverrange;
    output vcounderrange;
    
    // TIMING CHECKS
    specify
        $setuphold(negedge scanclk, scandata, 0, 0);
        $setuphold(negedge scanclk, scanclkena, 0, 0);
        
    endspecify

    // INTERNAL VARIABLES AND NETS
    reg [8*6:1] clk_num[0:4];
    integer scan_chain_length;
    integer i;
    integer j;
    integer k;
    integer x;
    integer y;
    integer l_index;
    integer gate_count;
    integer egpp_offset;
    integer sched_time;
    integer delay_chain;
    integer low;
    integer high;
    integer initial_delay;
    integer fbk_phase;
    integer fbk_delay;
    integer phase_shift[0:7];
    integer last_phase_shift[0:7];

    integer m_times_vco_period;
    integer new_m_times_vco_period;
    integer refclk_period;
    integer fbclk_period;
    integer high_time;
    integer low_time;
    integer my_rem;
    integer tmp_rem;
    integer rem;
    integer tmp_vco_per;
    integer vco_per;
    integer offset;
    integer temp_offset;
    integer cycles_to_lock;
    integer cycles_to_unlock;
    integer loop_xplier;
    integer loop_initial;
    integer loop_ph;
    integer cycle_to_adjust;
    integer total_pull_back;
    integer pull_back_M;

    time    fbclk_time;
    time    first_fbclk_time;
    time    refclk_time;

    reg switch_clock;

    reg [31:0] real_lock_high;

    reg got_first_refclk;
    reg got_second_refclk;
    reg got_first_fbclk;
    reg refclk_last_value;
    reg fbclk_last_value;
    reg inclk_last_value;
    reg pll_is_locked;
    reg locked_tmp;
    reg areset_last_value;
    reg pfdena_last_value;
    reg inclk_out_of_range;
    reg schedule_vco_last_value;
    
    // Test bypass lock detect
    reg pfd_locked;
    integer cycles_pfd_low, cycles_pfd_high;

    reg gate_out;
    reg vco_val;

    reg [31:0] m_initial_val;
    reg [31:0] m_val[0:1];
    reg [31:0] n_val[0:1];
    reg [31:0] m_delay;
    reg [8*6:1] m_mode_val[0:1];
    reg [8*6:1] n_mode_val[0:1];

    reg [31:0] c_high_val[0:9];
    reg [31:0] c_low_val[0:9];
    reg [8*6:1] c_mode_val[0:9];
    reg [31:0] c_initial_val[0:9];
    integer c_ph_val[0:9];

    reg [31:0] c_val; // placeholder for c_high,c_low values

    // VCO Frequency Range control
    reg vco_over, vco_under;
   
    // temporary registers for reprogramming
    integer c_ph_val_tmp[0:9];
    reg [31:0] c_high_val_tmp[0:9];
    reg [31:0] c_hval[0:9];
    reg [31:0] c_low_val_tmp[0:9];
    reg [31:0] c_lval[0:9];
    reg [8*6:1] c_mode_val_tmp[0:9];

    // hold registers for reprogramming
    integer c_ph_val_hold[0:9];
    reg [31:0] c_high_val_hold[0:9];
    reg [31:0] c_low_val_hold[0:9];
    reg [8*6:1] c_mode_val_hold[0:9];

    // old values
    reg [31:0] m_val_old[0:1];
    reg [31:0] m_val_tmp[0:1];
    reg [31:0] n_val_old[0:1];
    reg [8*6:1] m_mode_val_old[0:1];
    reg [8*6:1] n_mode_val_old[0:1];
    reg [31:0] c_high_val_old[0:9];
    reg [31:0] c_low_val_old[0:9];
    reg [8*6:1] c_mode_val_old[0:9];
    integer c_ph_val_old[0:9];
    integer   m_ph_val_old;
    integer   m_ph_val_tmp;

    integer cp_curr_old;
    integer cp_curr_val;
    integer lfc_old;
    integer lfc_val;
    integer vco_cur;
    integer vco_old;
    reg [9*8:1] lfr_val;
    reg [9*8:1] lfr_old;
    reg [1:2] lfc_val_bit_setting, lfc_val_old_bit_setting;
    reg vco_val_bit_setting, vco_val_old_bit_setting;
    reg [3:7] lfr_val_bit_setting, lfr_val_old_bit_setting;
    reg [14:16] cp_curr_bit_setting, cp_curr_old_bit_setting;
    
    // Setting on  - display real values
    // Setting off - display only bits
    reg pll_reconfig_display_full_setting;

    reg [7:0] m_hi;
    reg [7:0] m_lo;
    reg [7:0] n_hi;
    reg [7:0] n_lo;

    // ph tap orig values (POF)
    integer c_ph_val_orig[0:9];
    integer m_ph_val_orig;

    reg schedule_vco;
    reg stop_vco;
    reg inclk_n;
    reg inclk_man;
    reg inclk_es;

    reg [7:0] vco_out;
    reg [7:0] vco_tap;
    reg [7:0] vco_out_last_value;
    reg [7:0] vco_tap_last_value;
    wire inclk_c0;
    wire inclk_c1;
    wire inclk_c2;
    wire inclk_c3;
    wire inclk_c4;
    
    wire  inclk_c0_from_vco;
    wire  inclk_c1_from_vco;
    wire  inclk_c2_from_vco;
    wire  inclk_c3_from_vco;
    wire  inclk_c4_from_vco;
    
    wire  inclk_m_from_vco;

    wire inclk_m;
    wire pfdena_wire;
    wire [4:0] clk_tmp, clk_out_pfd;


    wire [4:0] clk_out;

    wire c0_clk;
    wire c1_clk;
    wire c2_clk;
    wire c3_clk;
    wire c4_clk;

    reg first_schedule;

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    wire refclk;
    wire fbclk;
    
    wire pllena_reg;
    wire test_mode_inclk;
 
    // Self Reset
    wire reset_self;

    // Clock Switchover
    reg clk0_is_bad;
    reg clk1_is_bad;
    reg inclk0_last_value;
    reg inclk1_last_value;
    reg other_clock_value;
    reg other_clock_last_value;
    reg primary_clk_is_bad;
    reg current_clk_is_bad;
    reg external_switch;
    reg active_clock;
    reg got_curr_clk_falling_edge_after_clkswitch;

    integer clk0_count;
    integer clk1_count;
    integer switch_over_count;

    wire scandataout_tmp;
    reg scandata_in, scandata_out; // hold scan data in negative-edge triggered ff (on either side on chain)
    reg scandone_tmp;
    reg initiate_reconfig;
    integer quiet_time;
    integer slowest_clk_old;
    integer slowest_clk_new;

    reg reconfig_err;
    reg error;
    time    scanclk_last_rising_edge;
    time    scanread_active_edge;
    reg got_first_scanclk;
    reg got_first_gated_scanclk;
    reg gated_scanclk;
    integer scanclk_period;
    reg scanclk_last_value;
    wire update_conf_latches;
    reg  update_conf_latches_reg;
    reg [-1:142]  scan_data;
    reg scanclkena_reg; // register scanclkena on negative edge of scanclk
    reg c0_rising_edge_transfer_done;
    reg c1_rising_edge_transfer_done;
    reg c2_rising_edge_transfer_done;
    reg c3_rising_edge_transfer_done;
    reg c4_rising_edge_transfer_done;
    reg scanread_setup_violation;
    integer index;
    integer scanclk_cycles;
    reg d_msg;

    integer num_output_cntrs;
    reg no_warn;
    
    // Phase reconfig
    
    reg [2:0] phasecounterselect_reg;
    reg phaseupdown_reg;
    reg phasestep_reg;
    integer select_counter;
    integer phasestep_high_count;
    reg update_phase;
    

// LOCAL_PARAMETERS_BEGIN

    parameter SCAN_CHAIN = 144;
    parameter GPP_SCAN_CHAIN  = 234;
    parameter FAST_SCAN_CHAIN = 180;
    // primary clk is always inclk0
    parameter num_phase_taps = 8;

// LOCAL_PARAMETERS_END


    // internal variables for scaling of multiply_by and divide_by values
    integer i_clk0_mult_by;
    integer i_clk0_div_by;
    integer i_clk1_mult_by;
    integer i_clk1_div_by;
    integer i_clk2_mult_by;
    integer i_clk2_div_by;
    integer i_clk3_mult_by;
    integer i_clk3_div_by;
    integer i_clk4_mult_by;
    integer i_clk4_div_by;
    integer i_clk5_mult_by;
    integer i_clk5_div_by;
    integer i_clk6_mult_by;
    integer i_clk6_div_by;
    integer i_clk7_mult_by;
    integer i_clk7_div_by;
    integer i_clk8_mult_by;
    integer i_clk8_div_by;
    integer i_clk9_mult_by;
    integer i_clk9_div_by;
    integer max_d_value;
    integer new_multiplier;

    // internal variables for storing the phase shift number.(used in lvds mode only)
    integer i_clk0_phase_shift;
    integer i_clk1_phase_shift;
    integer i_clk2_phase_shift;
    integer i_clk3_phase_shift;
    integer i_clk4_phase_shift;

    // user to advanced internal signals

    integer   i_m_initial;
    integer   i_m;
    integer   i_n;
    integer   i_c_high[0:9];
    integer   i_c_low[0:9];
    integer   i_c_initial[0:9];
    integer   i_c_ph[0:9];
    reg       [8*6:1] i_c_mode[0:9];

    integer   i_vco_min;
    integer   i_vco_max;
    integer   i_vco_min_no_division;
    integer   i_vco_max_no_division;
    integer   i_vco_center;
    integer   i_pfd_min;
    integer   i_pfd_max;
    integer   i_m_ph;
    integer   m_ph_val;
    reg [8*2:1] i_clk4_counter;
    reg [8*2:1] i_clk3_counter;
    reg [8*2:1] i_clk2_counter;
    reg [8*2:1] i_clk1_counter;
    reg [8*2:1] i_clk0_counter;
    integer   i_charge_pump_current;
    integer   i_loop_filter_r;
    integer   max_neg_abs;
    integer   output_count;
    integer   new_divisor;

    integer loop_filter_c_arr[0:3];
    integer fpll_loop_filter_c_arr[0:3];
    integer charge_pump_curr_arr[0:15];

    reg pll_in_test_mode;
    reg pll_is_in_reset;
    reg pll_has_just_been_reconfigured;

    // uppercase to lowercase parameter values
    reg [8*`WORD_LENGTH:1] l_operation_mode;
    reg [8*`WORD_LENGTH:1] l_pll_type;
    reg [8*`WORD_LENGTH:1] l_compensate_clock;
    reg [8*`WORD_LENGTH:1] l_scan_chain;
    reg [8*`WORD_LENGTH:1] l_switch_over_type;
    reg [8*`WORD_LENGTH:1] l_bandwidth_type;
    reg [8*`WORD_LENGTH:1] l_simulation_type;
    reg [8*`WORD_LENGTH:1] l_sim_gate_lock_device_behavior;
    reg [8*`WORD_LENGTH:1] l_vco_frequency_control;
    reg [8*`WORD_LENGTH:1] l_enable_switch_over_counter;
    reg [8*`WORD_LENGTH:1] l_self_reset_on_loss_lock;
    


    integer current_clock;
    integer current_clock_man;
    reg is_fast_pll;
    reg ic1_use_casc_in;
    reg ic2_use_casc_in;
    reg ic3_use_casc_in;
    reg ic4_use_casc_in;

    reg init;
    reg tap0_is_active;

    real inclk0_period, last_inclk0_period,inclk1_period, last_inclk1_period;
    real last_inclk0_edge,last_inclk1_edge,diff_percent_period;
    reg first_inclk0_edge_detect,first_inclk1_edge_detect;


    specify
    endspecify

    // finds the closest integer fraction of a given pair of numerator and denominator. 
    task find_simple_integer_fraction;
        input numerator;
        input denominator;
        input max_denom;
        output fraction_num; 
        output fraction_div; 
        parameter max_iter = 20;
        
        integer numerator;
        integer denominator;
        integer max_denom;
        integer fraction_num; 
        integer fraction_div; 
        
        integer quotient_array[max_iter-1:0];
        integer int_loop_iter;
        integer int_quot;
        integer m_value;
        integer d_value;
        integer old_m_value;
        integer swap;

        integer loop_iter;
        integer num;
        integer den;
        integer i_max_iter;

    begin      
        loop_iter = 0;
        num = (numerator == 0) ? 1 : numerator;
        den = (denominator == 0) ? 1 : denominator;
        i_max_iter = max_iter;
       
        while (loop_iter < i_max_iter)
        begin
            int_quot = num / den;
            quotient_array[loop_iter] = int_quot;
            num = num - (den*int_quot);
            loop_iter=loop_iter+1;
            
            if ((num == 0) || (max_denom != -1) || (loop_iter == i_max_iter)) 
            begin
                // calculate the numerator and denominator if there is a restriction on the
                // max denom value or if the loop is ending
                m_value = 0;
                d_value = 1;
                // get the rounded value at this stage for the remaining fraction
                if (den != 0)
                begin
                    m_value = (2*num/den);
                end
                // calculate the fraction numerator and denominator at this stage
                for (int_loop_iter = loop_iter-1; int_loop_iter >= 0; int_loop_iter=int_loop_iter-1)
                begin
                    if (m_value == 0)
                    begin
                        m_value = quotient_array[int_loop_iter];
                        d_value = 1;
                    end
                    else
                    begin
                        old_m_value = m_value;
                        m_value = quotient_array[int_loop_iter]*m_value + d_value;
                        d_value = old_m_value;
                    end
                end
                // if the denominator is less than the maximum denom_value or if there is no restriction save it
                if ((d_value <= max_denom) || (max_denom == -1))
                begin
                    fraction_num = m_value;
                    fraction_div = d_value;
                end
                // end the loop if the denomitor has overflown or the numerator is zero (no remainder during this round)
                if (((d_value > max_denom) && (max_denom != -1)) || (num == 0))
                begin
                    i_max_iter = loop_iter;
                end
            end
            // swap the numerator and denominator for the next round
            swap = den;
            den = num;
            num = swap;
        end
    end
    endtask // find_simple_integer_fraction

    // get the absolute value
    function integer abs;
    input value;
    integer value;
    begin
        if (value < 0)
            abs = value * -1;
        else abs = value;
    end
    endfunction

    // find twice the period of the slowest clock
    function integer slowest_clk;
    input C0, C0_mode, C1, C1_mode, C2, C2_mode, C3, C3_mode, C4, C4_mode, C5, C5_mode, C6, C6_mode, C7, C7_mode, C8, C8_mode, C9, C9_mode, refclk, m_mod;
    integer C0, C1, C2, C3, C4, C5, C6, C7, C8, C9;
    reg [8*6:1] C0_mode, C1_mode, C2_mode, C3_mode, C4_mode, C5_mode, C6_mode, C7_mode, C8_mode, C9_mode;
    integer refclk;
    reg [31:0] m_mod;
    integer max_modulus;
    begin
        max_modulus = 1;
        if (C0_mode != "bypass" && C0_mode != "   off")
            max_modulus = C0;
        if (C1 > max_modulus && C1_mode != "bypass" && C1_mode != "   off")
            max_modulus = C1;
        if (C2 > max_modulus && C2_mode != "bypass" && C2_mode != "   off")
            max_modulus = C2;
        if (C3 > max_modulus && C3_mode != "bypass" && C3_mode != "   off")
            max_modulus = C3;
        if (C4 > max_modulus && C4_mode != "bypass" && C4_mode != "   off")
            max_modulus = C4;
        if (C5 > max_modulus && C5_mode != "bypass" && C5_mode != "   off")
            max_modulus = C5;
        if (C6 > max_modulus && C6_mode != "bypass" && C6_mode != "   off")
            max_modulus = C6;
        if (C7 > max_modulus && C7_mode != "bypass" && C7_mode != "   off")
            max_modulus = C7;
        if (C8 > max_modulus && C8_mode != "bypass" && C8_mode != "   off")
            max_modulus = C8;
        if (C9 > max_modulus && C9_mode != "bypass" && C9_mode != "   off")
            max_modulus = C9;

        slowest_clk = (refclk * max_modulus *2 / m_mod);
    end
    endfunction

    // count the number of digits in the given integer
    function integer count_digit;
    input X;
    integer X;
    integer count, result;
    begin
        count = 0;
        result = X;
        while (result != 0)
        begin
            result = (result / 10);
            count = count + 1;
        end
        
        count_digit = count;
    end
    endfunction

    // reduce the given huge number(X) to Y significant digits
    function integer scale_num;
    input X, Y;
    integer X, Y;
    integer count;
    integer fac_ten, lc;
    begin
        fac_ten = 1;
        count = count_digit(X);
        
        for (lc = 0; lc < (count-Y); lc = lc + 1)
            fac_ten = fac_ten * 10;

        scale_num = (X / fac_ten);
    end
    endfunction

    // find the greatest common denominator of X and Y
    function integer gcd;
    input X,Y;
    integer X,Y;
    integer L, S, R, G;
    begin
        if (X < Y) // find which is smaller.
        begin
            S = X;
            L = Y;
        end
        else
        begin
            S = Y;
            L = X;
        end

        R = S;
        while ( R > 1)
        begin
            S = L;
            L = R;
            R = S % L;  // divide bigger number by smaller.
                        // remainder becomes smaller number.
        end
        if (R == 0)     // if evenly divisible then L is gcd else it is 1.
            G = L;
        else
            G = R;
        gcd = G;
    end
    endfunction

    // find the least common multiple of A1 to A10
    function integer lcm;
    input A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer M1, M2, M3, M4, M5 , M6, M7, M8, M9, R;
    begin
        M1 = (A1 * A2)/gcd(A1, A2);
        M2 = (M1 * A3)/gcd(M1, A3);
        M3 = (M2 * A4)/gcd(M2, A4);
        M4 = (M3 * A5)/gcd(M3, A5);
        M5 = (M4 * A6)/gcd(M4, A6);
        M6 = (M5 * A7)/gcd(M5, A7);
        M7 = (M6 * A8)/gcd(M6, A8);
        M8 = (M7 * A9)/gcd(M7, A9);
        M9 = (M8 * A10)/gcd(M8, A10);
        if (M9 < 3)
            R = 10;
        else if ((M9 <= 10) && (M9 >= 3))
            R = 4 * M9;
        else if (M9 > 1000)
            R = scale_num(M9, 3);
        else
            R = M9;
        lcm = R; 
    end
    endfunction

    // find the M and N values for Manual phase based on the following 5 criterias:
    // 1. The PFD frequency (i.e. Fin / N) must be in the range 5 MHz to 720 MHz
    // 2. The VCO frequency (i.e. Fin * M / N) must be in the range 300 MHz to 1300 MHz
    // 3. M is less than 512
    // 4. N is less than 512
    // 5. It's the smallest M/N which satisfies all the above constraints, and is within 2ps
    //    of the desired vco-phase-shift-step
    task find_m_and_n_4_manual_phase;
        input inclock_period;
        input vco_phase_shift_step;
        input clk0_mult, clk1_mult, clk2_mult, clk3_mult, clk4_mult;
        input clk5_mult, clk6_mult, clk7_mult, clk8_mult, clk9_mult;
        input clk0_div,  clk1_div,  clk2_div,  clk3_div,  clk4_div;
        input clk5_div,  clk6_div,  clk7_div,  clk8_div,  clk9_div;
        input clk0_used,  clk1_used,  clk2_used,  clk3_used,  clk4_used;
        input clk5_used,  clk6_used,  clk7_used,  clk8_used,  clk9_used;
        output m; 
        output n; 

        parameter max_m = 511;
        parameter max_n = 511;
        parameter max_pfd = 720;
        parameter min_pfd = 5;
        parameter max_vco = 1600; // max vco frequency. (in mHz)
        parameter min_vco = 300;  // min vco frequency. (in mHz)
        parameter max_offset = 0.004;
        
        reg[160:1] clk0_used,  clk1_used,  clk2_used,  clk3_used,  clk4_used;
        reg[160:1] clk5_used,  clk6_used,  clk7_used,  clk8_used,  clk9_used;
        
        integer inclock_period;
        integer vco_phase_shift_step;
        integer clk0_mult, clk1_mult, clk2_mult, clk3_mult, clk4_mult;
        integer clk5_mult, clk6_mult, clk7_mult, clk8_mult, clk9_mult;
        integer clk0_div,  clk1_div,  clk2_div,  clk3_div,  clk4_div;
        integer clk5_div,  clk6_div,  clk7_div,  clk8_div,  clk9_div;
        integer m; 
        integer n;
        integer pre_m;
        integer pre_n;
        integer m_out;
        integer n_out;
        integer closest_vco_step_value;
        
        integer vco_period;
        integer pfd_freq;
        integer vco_freq;
        integer vco_ps_step_value;
        real    clk0_div_factor_real;
        real    clk1_div_factor_real;
        real    clk2_div_factor_real;
        real    clk3_div_factor_real;
        real    clk4_div_factor_real;
        real    clk5_div_factor_real;
        real    clk6_div_factor_real;
        real    clk7_div_factor_real;
        real    clk8_div_factor_real;
        real    clk9_div_factor_real;
        real    clk0_div_factor_diff;
        real    clk1_div_factor_diff;
        real    clk2_div_factor_diff;
        real    clk3_div_factor_diff;
        real    clk4_div_factor_diff;
        real    clk5_div_factor_diff;
        real    clk6_div_factor_diff;
        real    clk7_div_factor_diff;
        real    clk8_div_factor_diff;
        real    clk9_div_factor_diff;
        integer clk0_div_factor_int;
        integer clk1_div_factor_int;
        integer clk2_div_factor_int;
        integer clk3_div_factor_int;
        integer clk4_div_factor_int;
        integer clk5_div_factor_int;
        integer clk6_div_factor_int;
        integer clk7_div_factor_int;
        integer clk8_div_factor_int;
        integer clk9_div_factor_int;
    begin

        vco_period = vco_phase_shift_step * 8;

        pre_m = 0;
        pre_n = 0;
        closest_vco_step_value = 0;

        begin : LOOP_1
                for (n_out = 1; n_out < max_n; n_out = n_out +1)
                begin
                    for (m_out = 1; m_out < max_m; m_out = m_out +1)
                    begin
                        clk0_div_factor_real = (clk0_div * m_out * 1.0 ) / (clk0_mult * n_out);
                        clk1_div_factor_real = (clk1_div * m_out * 1.0) / (clk1_mult * n_out);
                        clk2_div_factor_real = (clk2_div * m_out * 1.0) / (clk2_mult * n_out);
                        clk3_div_factor_real = (clk3_div * m_out * 1.0) / (clk3_mult * n_out);
                        clk4_div_factor_real = (clk4_div * m_out * 1.0) / (clk4_mult * n_out);
                        clk5_div_factor_real = (clk5_div * m_out * 1.0) / (clk5_mult * n_out);
                        clk6_div_factor_real = (clk6_div * m_out * 1.0) / (clk6_mult * n_out);
                        clk7_div_factor_real = (clk7_div * m_out * 1.0) / (clk7_mult * n_out);
                        clk8_div_factor_real = (clk8_div * m_out * 1.0) / (clk8_mult * n_out);
                        clk9_div_factor_real = (clk9_div * m_out * 1.0) / (clk9_mult * n_out);
        
                        clk0_div_factor_int = clk0_div_factor_real;
                        clk1_div_factor_int = clk1_div_factor_real;
                        clk2_div_factor_int = clk2_div_factor_real;
                        clk3_div_factor_int = clk3_div_factor_real;
                        clk4_div_factor_int = clk4_div_factor_real;
                        clk5_div_factor_int = clk5_div_factor_real;
                        clk6_div_factor_int = clk6_div_factor_real;
                        clk7_div_factor_int = clk7_div_factor_real;
                        clk8_div_factor_int = clk8_div_factor_real;
                        clk9_div_factor_int = clk9_div_factor_real;
                        
                        clk0_div_factor_diff = (clk0_div_factor_real - clk0_div_factor_int < 0) ? (clk0_div_factor_real - clk0_div_factor_int) * -1.0 : clk0_div_factor_real - clk0_div_factor_int;
                        clk1_div_factor_diff = (clk1_div_factor_real - clk1_div_factor_int < 0) ? (clk1_div_factor_real - clk1_div_factor_int) * -1.0 : clk1_div_factor_real - clk1_div_factor_int;
                        clk2_div_factor_diff = (clk2_div_factor_real - clk2_div_factor_int < 0) ? (clk2_div_factor_real - clk2_div_factor_int) * -1.0 : clk2_div_factor_real - clk2_div_factor_int;
                        clk3_div_factor_diff = (clk3_div_factor_real - clk3_div_factor_int < 0) ? (clk3_div_factor_real - clk3_div_factor_int) * -1.0 : clk3_div_factor_real - clk3_div_factor_int;
                        clk4_div_factor_diff = (clk4_div_factor_real - clk4_div_factor_int < 0) ? (clk4_div_factor_real - clk4_div_factor_int) * -1.0 : clk4_div_factor_real - clk4_div_factor_int;
                        clk5_div_factor_diff = (clk5_div_factor_real - clk5_div_factor_int < 0) ? (clk5_div_factor_real - clk5_div_factor_int) * -1.0 : clk5_div_factor_real - clk5_div_factor_int;
                        clk6_div_factor_diff = (clk6_div_factor_real - clk6_div_factor_int < 0) ? (clk6_div_factor_real - clk6_div_factor_int) * -1.0 : clk6_div_factor_real - clk6_div_factor_int;
                        clk7_div_factor_diff = (clk7_div_factor_real - clk7_div_factor_int < 0) ? (clk7_div_factor_real - clk7_div_factor_int) * -1.0 : clk7_div_factor_real - clk7_div_factor_int;
                        clk8_div_factor_diff = (clk8_div_factor_real - clk8_div_factor_int < 0) ? (clk8_div_factor_real - clk8_div_factor_int) * -1.0 : clk8_div_factor_real - clk8_div_factor_int;
                        clk9_div_factor_diff = (clk9_div_factor_real - clk9_div_factor_int < 0) ? (clk9_div_factor_real - clk9_div_factor_int) * -1.0 : clk9_div_factor_real - clk9_div_factor_int;
                        
        
                        if (((clk0_div_factor_diff < max_offset) || (clk0_used == "unused")) &&
                            ((clk1_div_factor_diff < max_offset) || (clk1_used == "unused")) &&
                            ((clk2_div_factor_diff < max_offset) || (clk2_used == "unused")) &&
                            ((clk3_div_factor_diff < max_offset) || (clk3_used == "unused")) &&
                            ((clk4_div_factor_diff < max_offset) || (clk4_used == "unused")) &&
                            ((clk5_div_factor_diff < max_offset) || (clk5_used == "unused")) &&
                            ((clk6_div_factor_diff < max_offset) || (clk6_used == "unused")) &&
                            ((clk7_div_factor_diff < max_offset) || (clk7_used == "unused")) &&
                            ((clk8_div_factor_diff < max_offset) || (clk8_used == "unused")) &&
                            ((clk9_div_factor_diff < max_offset) || (clk9_used == "unused")) )
                        begin                
                            if ((m_out != 0) && (n_out != 0))
                            begin
                                pfd_freq = 1000000 / (inclock_period * n_out);
                                vco_freq = (1000000 * m_out) / (inclock_period * n_out);
                                vco_ps_step_value = (inclock_period * n_out) / (8 * m_out);
                
                                if ( (m_out < max_m) && (n_out < max_n) && (pfd_freq >= min_pfd) && (pfd_freq <= max_pfd) &&
                                    (vco_freq >= min_vco) && (vco_freq <= max_vco) )
                                begin
                                    if (abs(vco_ps_step_value - vco_phase_shift_step) <= 2)
                                    begin
                                        pre_m = m_out;
                                        pre_n = n_out;
                                        disable LOOP_1;
                                    end
                                    else
                                    begin
                                        if ((closest_vco_step_value == 0) || (abs(vco_ps_step_value - vco_phase_shift_step) < abs(closest_vco_step_value - vco_phase_shift_step)))
                                        begin
                                            pre_m = m_out;
                                            pre_n = n_out;
                                            closest_vco_step_value = vco_ps_step_value;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
        end
        
        if ((pre_m != 0) && (pre_n != 0))
        begin
            find_simple_integer_fraction(pre_m, pre_n,
                        max_n, m, n);
        end
        else
        begin
            n = 1;
            m = lcm  (clk0_mult, clk1_mult, clk2_mult, clk3_mult,
                    clk4_mult, clk5_mult, clk6_mult,
                    clk7_mult, clk8_mult, clk9_mult, inclock_period);           
        end
    end
    endtask // find_m_and_n_4_manual_phase

    // find the factor of division of the output clock frequency
    // compared to the VCO
    function integer output_counter_value;
    input clk_divide, clk_mult, M, N;
    integer clk_divide, clk_mult, M, N;
    real r;
    integer r_int;
    begin
        r = (clk_divide * M * 1.0)/(clk_mult * N);
        r_int = r;
        output_counter_value = r_int;
    end
    endfunction

    // find the mode of each of the PLL counters - bypass, even or odd
    function [8*6:1] counter_mode;
    input duty_cycle;
    input output_counter_value;
    integer duty_cycle;
    integer output_counter_value;
    integer half_cycle_high;
    reg [8*6:1] R;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100.0;
        if (output_counter_value == 1)
            R = "bypass";
        else if ((half_cycle_high % 2) == 0)
            R = "  even";
        else
            R = "   odd";
        counter_mode = R;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock high
    function integer counter_high;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle;
    integer half_cycle_high;
    integer tmp_counter_high;
    integer mode;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100.0;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_high = tmp_counter_high + !mode;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock low
    function integer counter_low;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle, counter_h;
    integer half_cycle_high;
    integer mode;
    integer tmp_counter_high;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100.0;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_h = tmp_counter_high + !mode;
        counter_low =  output_counter_value - counter_h;
    end
    endfunction

    // find the smallest time delay amongst t1 to t10
    function integer mintimedelay;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2)
            m1 = t1;
        else
            m1 = t2;
        if (m1 < t3)
            m2 = m1;
        else
            m2 = t3;
        if (m2 < t4)
            m3 = m2;
        else
            m3 = t4;
        if (m3 < t5)
            m4 = m3;
        else
            m4 = t5;
        if (m4 < t6)
            m5 = m4;
        else
            m5 = t6;
        if (m5 < t7)
            m6 = m5;
        else
            m6 = t7;
        if (m6 < t8)
            m7 = m6;
        else
            m7 = t8;
        if (m7 < t9)
            m8 = m7;
        else
            m8 = t9;
        if (m8 < t10)
            m9 = m8;
        else
            m9 = t10;
        if (m9 > 0)
            mintimedelay = m9;
        else
            mintimedelay = 0;
    end
    endfunction

    // find the numerically largest negative number, and return its absolute value
    function integer maxnegabs;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2) m1 = t1; else m1 = t2;
        if (m1 < t3) m2 = m1; else m2 = t3;
        if (m2 < t4) m3 = m2; else m3 = t4;
        if (m3 < t5) m4 = m3; else m4 = t5;
        if (m4 < t6) m5 = m4; else m5 = t6;
        if (m5 < t7) m6 = m5; else m6 = t7;
        if (m6 < t8) m7 = m6; else m7 = t8;
        if (m7 < t9) m8 = m7; else m8 = t9;
        if (m8 < t10) m9 = m8; else m9 = t10;
        maxnegabs = (m9 < 0) ? 0 - m9 : 0;
    end
    endfunction

    // adjust the given tap_phase by adding the largest negative number (ph_base) 
    function integer ph_adjust;
    input tap_phase, ph_base;
    integer tap_phase, ph_base;
    begin
        ph_adjust = tap_phase + ph_base;
    end
    endfunction

    // find the number of VCO clock cycles to wait initially before the first 
    // rising edge of the output clock
    function integer counter_initial;
    input tap_phase, m, n;
    integer tap_phase, m, n, phase;
    begin
        if (tap_phase < 0) tap_phase = 0 - tap_phase;
        // adding 0.5 for rounding correction (required in order to round
        // to the nearest integer instead of truncating)
        phase = ((tap_phase * m) / (360.0 * n)) + 0.6;
        counter_initial = phase;
    end
    endfunction

    // find which VCO phase tap to align the rising edge of the output clock to
    function integer counter_ph;
    input tap_phase;
    input m,n;
    integer m,n, phase;
    integer tap_phase;
    begin
    // adding 0.5 for rounding correction
        phase = (tap_phase * m / n) + 0.5;
        counter_ph = (phase % 360) / 45.0;

        if (counter_ph == 8)
            counter_ph = 0;
    end
    endfunction

    // convert the given string to length 6 by padding with spaces
    function [8*6:1] translate_string;
    input [8*6:1] mode;
    reg [8*6:1] new_mode;
    begin
        if (mode == "bypass")
            new_mode = "bypass";
        else if (mode == "even")
            new_mode = "  even";
        else if (mode == "odd")
            new_mode = "   odd";

        translate_string = new_mode;
    end
    endfunction

    // convert string to integer with sign
    function integer str2int; 
    input [8*16:1] s;

    reg [8*16:1] reg_s;
    reg [8:1] digit;
    reg [8:1] tmp;
    integer m, magnitude;
    integer sign;

    begin
        sign = 1;
        magnitude = 0;
        reg_s = s;
        for (m=1; m<=16; m=m+1)
        begin
            tmp = reg_s[128:121];
            digit = tmp & 8'b00001111;
            reg_s = reg_s << 8;
            // Accumulate ascii digits 0-9 only.
            if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
            if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
        end
        str2int = sign*magnitude;
    end
    endfunction

    // this is for cycloneiiils lvds only
    // convert phase delay to integer
    function integer get_int_phase_shift; 
    input [8*16:1] s;
    input i_phase_shift;
    integer i_phase_shift;

    begin
        if (i_phase_shift != 0)
        begin                   
            get_int_phase_shift = i_phase_shift;
        end       
        else
        begin
            get_int_phase_shift = str2int(s);
        end        
    end
    endfunction

    // calculate the given phase shift (in ps) in terms of degrees
    function integer get_phase_degree; 
    input phase_shift;
    integer phase_shift, result;
    begin
        result = (phase_shift * 360) / inclk0_freq;
        // this is to round up the calculation result
        if ( result > 0 )
            result = result + 1;
        else if ( result < 0 )
            result = result - 1;
        else
            result = 0;

        // assign the rounded up result
        get_phase_degree = result;
    end
    endfunction

    // convert uppercase parameter values to lowercase
    // assumes that the maximum character length of a parameter is 18
    function [8*`WORD_LENGTH:1] alpha_tolower;
    input [8*`WORD_LENGTH:1] given_string;

    reg [8*`WORD_LENGTH:1] return_string;
    reg [8*`WORD_LENGTH:1] reg_string;
    reg [8:1] tmp;
    reg [8:1] conv_char;
    integer byte_count;
    begin
        return_string = "                    "; // initialise strings to spaces
        conv_char = "        ";
        reg_string = given_string;
        for (byte_count = `WORD_LENGTH; byte_count >= 1; byte_count = byte_count - 1)
        begin
            tmp = reg_string[8*`WORD_LENGTH:(8*(`WORD_LENGTH-1)+1)];
            reg_string = reg_string << 8;
            if ((tmp >= 65) && (tmp <= 90)) // ASCII number of 'A' is 65, 'Z' is 90
            begin
                conv_char = tmp + 32; // 32 is the difference in the position of 'A' and 'a' in the ASCII char set
                return_string = {return_string, conv_char};
            end
            else
                return_string = {return_string, tmp};
        end
    
        alpha_tolower = return_string;
    end
    endfunction

    function integer display_msg;
    input [8*2:1] cntr_name;
    input msg_code;
    integer msg_code;
    begin
        if (msg_code == 1)
            $display ("Warning : %s counter switched from BYPASS mode to enabled. PLL may lose lock.", cntr_name);
        else if (msg_code == 2)
            $display ("Warning : Illegal 1 value for %s counter. Instead, the %s counter should be BYPASSED. Reconfiguration may not work.", cntr_name, cntr_name);
        else if (msg_code == 3)
            $display ("Warning : Illegal value for counter %s in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.", cntr_name);
        else if (msg_code == 4)
            $display ("Warning : %s counter switched from enabled to BYPASS mode. PLL may lose lock.", cntr_name);
        $display ("Time: %0t  Instance: %m", $time);
        display_msg = 1;
    end
    endfunction

    initial
    begin
        scandata_out = 1'b0;
        first_inclk0_edge_detect = 1'b0;
        first_inclk1_edge_detect = 1'b0;
        pll_reconfig_display_full_setting = 1'b0;
        initiate_reconfig = 1'b0;
    switch_over_count = 0;
        // convert string parameter values from uppercase to lowercase,
        // as expected in this model
        l_operation_mode             = alpha_tolower(operation_mode);
        l_pll_type                   = alpha_tolower(pll_type);
        l_compensate_clock           = alpha_tolower(compensate_clock);
        l_switch_over_type           = alpha_tolower(switch_over_type);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);
        l_sim_gate_lock_device_behavior = alpha_tolower(sim_gate_lock_device_behavior);
        l_vco_frequency_control      = alpha_tolower(vco_frequency_control);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_self_reset_on_loss_lock    = alpha_tolower(self_reset_on_loss_lock);
    
        real_lock_high = (l_sim_gate_lock_device_behavior == "on") ? lock_high : 0;    
        // initialize charge_pump_current, and loop_filter tables
        loop_filter_c_arr[0] = 0;
        loop_filter_c_arr[1] = 0;
        loop_filter_c_arr[2] = 0;
        loop_filter_c_arr[3] = 0;
        
        fpll_loop_filter_c_arr[0] = 0;
        fpll_loop_filter_c_arr[1] = 0;
        fpll_loop_filter_c_arr[2] = 0;
        fpll_loop_filter_c_arr[3] = 0;
        
        charge_pump_curr_arr[0] = 0;
        charge_pump_curr_arr[1] = 0;
        charge_pump_curr_arr[2] = 0;
        charge_pump_curr_arr[3] = 0;
        charge_pump_curr_arr[4] = 0;
        charge_pump_curr_arr[5] = 0;
        charge_pump_curr_arr[6] = 0;
        charge_pump_curr_arr[7] = 0;
        charge_pump_curr_arr[8] = 0;
        charge_pump_curr_arr[9] = 0;
        charge_pump_curr_arr[10] = 0;
        charge_pump_curr_arr[11] = 0;
        charge_pump_curr_arr[12] = 0;
        charge_pump_curr_arr[13] = 0;
        charge_pump_curr_arr[14] = 0;
        charge_pump_curr_arr[15] = 0;

        i_vco_max = vco_max;
        i_vco_min = vco_min; 

        if(vco_post_scale == 1)
        begin
            i_vco_max_no_division = vco_max * 2;
            i_vco_min_no_division = vco_min * 2;    
        end
        else
        begin
            i_vco_max_no_division = vco_max;
            i_vco_min_no_division = vco_min;    
        end


        if (m == 0)
        begin
            i_clk4_counter    = "c4" ;
            i_clk3_counter    = "c3" ;
            i_clk2_counter    = "c2" ;
            i_clk1_counter    = "c1" ;
            i_clk0_counter    = "c0" ;
        end
        else begin
            i_clk4_counter    = alpha_tolower(clk4_counter);
            i_clk3_counter    = alpha_tolower(clk3_counter);
            i_clk2_counter    = alpha_tolower(clk2_counter);
            i_clk1_counter    = alpha_tolower(clk1_counter);
            i_clk0_counter    = alpha_tolower(clk0_counter);
        end

        if (m == 0)
        begin 

            // set the limit of the divide_by value that can be returned by
            // the following function.
            max_d_value = 500;
            
            // scale down the multiply_by and divide_by values provided by the design
            // before attempting to use them in the calculations below
            find_simple_integer_fraction(clk0_multiply_by, clk0_divide_by,
                            max_d_value, i_clk0_mult_by, i_clk0_div_by);
            find_simple_integer_fraction(clk1_multiply_by, clk1_divide_by,
                            max_d_value, i_clk1_mult_by, i_clk1_div_by);
            find_simple_integer_fraction(clk2_multiply_by, clk2_divide_by,
                            max_d_value, i_clk2_mult_by, i_clk2_div_by);
            find_simple_integer_fraction(clk3_multiply_by, clk3_divide_by,
                            max_d_value, i_clk3_mult_by, i_clk3_div_by);
            find_simple_integer_fraction(clk4_multiply_by, clk4_divide_by,
                            max_d_value, i_clk4_mult_by, i_clk4_div_by);

            // convert user parameters to advanced
            if (l_vco_frequency_control == "manual_phase")
            begin
                find_m_and_n_4_manual_phase(inclk0_freq, vco_phase_shift_step,
                            i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,i_clk4_mult_by,
                1, 1, 1, 1, 1, 
                            i_clk0_div_by, i_clk1_div_by,
                            i_clk2_div_by, i_clk3_div_by,i_clk4_div_by,
                1, 1, 1, 1, 1, 
                            clk0_counter, clk1_counter,
                            clk2_counter, clk3_counter,clk4_counter,
                "unused", "unused", "unused", "unused", "unused", 
                            i_m, i_n);
            end
            else if (((l_pll_type == "fast") || (l_pll_type == "lvds") || (l_pll_type == "left_right")) && (vco_multiply_by != 0) && (vco_divide_by != 0))
            begin
                i_n = vco_divide_by;
                i_m = vco_multiply_by;
            end
            else begin
                i_n = 1;
                if (((l_pll_type == "fast") || (l_pll_type == "left_right")) && (l_compensate_clock == "lvdsclk"))
                    i_m = i_clk0_mult_by;
                else
                    i_m = lcm  (i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,i_clk4_mult_by,
                1, 1, 1, 1, 1, 
                            inclk0_freq);
            end

            i_c_high[0] = counter_high (output_counter_value(i_clk0_div_by,
                                        i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);
            i_c_high[1] = counter_high (output_counter_value(i_clk1_div_by,
                                        i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
            i_c_high[2] = counter_high (output_counter_value(i_clk2_div_by,
                                        i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
            i_c_high[3] = counter_high (output_counter_value(i_clk3_div_by,
                                        i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
            i_c_high[4] = counter_high (output_counter_value(i_clk4_div_by,
                                        i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);

            i_c_low[0]  = counter_low  (output_counter_value(i_clk0_div_by,
                                        i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
            i_c_low[1]  = counter_low  (output_counter_value(i_clk1_div_by,
                                        i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
            i_c_low[2]  = counter_low  (output_counter_value(i_clk2_div_by,
                                        i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
            i_c_low[3]  = counter_low  (output_counter_value(i_clk3_div_by,
                                        i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
            i_c_low[4]  = counter_low  (output_counter_value(i_clk4_div_by,
                                        i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);

            if (l_pll_type == "flvds")
            begin
                // Need to readjust phase shift values when the clock multiply value has been readjusted.
                new_multiplier = clk0_multiply_by / i_clk0_mult_by;
                i_clk0_phase_shift = (clk0_phase_shift_num * new_multiplier);
                i_clk1_phase_shift = (clk1_phase_shift_num * new_multiplier);
                i_clk2_phase_shift = (clk2_phase_shift_num * new_multiplier);
                i_clk3_phase_shift = 0;
                i_clk4_phase_shift = 0;
            end
            else
            begin
                i_clk0_phase_shift = get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num);
                i_clk1_phase_shift = get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num);
                i_clk2_phase_shift = get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num);
                i_clk3_phase_shift = get_int_phase_shift(clk3_phase_shift, clk3_phase_shift_num);
                i_clk4_phase_shift = get_int_phase_shift(clk4_phase_shift, clk4_phase_shift_num);
            end

            max_neg_abs = maxnegabs   ( i_clk0_phase_shift,
                                        i_clk1_phase_shift,
                                        i_clk2_phase_shift,
                                        i_clk3_phase_shift,
                                        i_clk4_phase_shift,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0
                                        );

            i_c_initial[0] = counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[1] = counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[2] = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[3] = counter_initial(get_phase_degree(ph_adjust(i_clk3_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[4] = counter_initial(get_phase_degree(ph_adjust(i_clk4_phase_shift, max_neg_abs)), i_m, i_n);

            i_c_mode[0] = counter_mode(clk0_duty_cycle,output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
            i_c_mode[1] = counter_mode(clk1_duty_cycle,output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
            i_c_mode[2] = counter_mode(clk2_duty_cycle,output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            i_c_mode[3] = counter_mode(clk3_duty_cycle,output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
            i_c_mode[4] = counter_mode(clk4_duty_cycle,output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));

            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            
            i_c_ph[0] = counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[1] = counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[2] = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[3] = counter_ph(get_phase_degree(ph_adjust(i_clk3_phase_shift,max_neg_abs)), i_m, i_n);
            i_c_ph[4] = counter_ph(get_phase_degree(ph_adjust(i_clk4_phase_shift,max_neg_abs)), i_m, i_n);


        end
        else 
        begin //  m != 0

            i_n = n;
            i_m = m;
            i_c_high[0] = c0_high;
            i_c_high[1] = c1_high;
            i_c_high[2] = c2_high;
            i_c_high[3] = c3_high;
            i_c_high[4] = c4_high;
            i_c_low[0]  = c0_low;
            i_c_low[1]  = c1_low;
            i_c_low[2]  = c2_low;
            i_c_low[3]  = c3_low;
            i_c_low[4]  = c4_low;
            i_c_initial[0] = c0_initial;
            i_c_initial[1] = c1_initial;
            i_c_initial[2] = c2_initial;
            i_c_initial[3] = c3_initial;
            i_c_initial[4] = c4_initial;
            i_c_mode[0] = translate_string(alpha_tolower(c0_mode));
            i_c_mode[1] = translate_string(alpha_tolower(c1_mode));
            i_c_mode[2] = translate_string(alpha_tolower(c2_mode));
            i_c_mode[3] = translate_string(alpha_tolower(c3_mode));
            i_c_mode[4] = translate_string(alpha_tolower(c4_mode));
            i_c_ph[0]  = c0_ph;
            i_c_ph[1]  = c1_ph;
            i_c_ph[2]  = c2_ph;
            i_c_ph[3]  = c3_ph;
            i_c_ph[4]  = c4_ph;
            i_m_ph   = m_ph;        // default
            i_m_initial = m_initial;

        end // user to advanced conversion
        
        switch_clock = 1'b0;

        refclk_period = inclk0_freq * i_n;

        m_times_vco_period = refclk_period;
        new_m_times_vco_period = refclk_period;

        fbclk_period = 0;
        high_time = 0;
        low_time = 0;
        schedule_vco = 0;
        vco_out[7:0] = 8'b0;
        vco_tap[7:0] = 8'b0;
        fbclk_last_value = 0;
        offset = 0;
        temp_offset = 0;
        got_first_refclk = 0;
        got_first_fbclk = 0;
        fbclk_time = 0;
        first_fbclk_time = 0;
        refclk_time = 0;
        first_schedule = 1;
        sched_time = 0;
        vco_val = 0;
        gate_count = 0;
        gate_out = 0;
        initial_delay = 0;
        fbk_phase = 0;
        for (i = 0; i <= 7; i = i + 1)
        begin
            phase_shift[i] = 0;
            last_phase_shift[i] = 0;
        end
        fbk_delay = 0;
        inclk_n = 0;
        inclk_es = 0;
        inclk_man = 0;
        cycle_to_adjust = 0;
        m_delay = 0;
        total_pull_back = 0;
        pull_back_M = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;
        inclk_out_of_range = 0;
        scandone_tmp = 1'b0;
        schedule_vco_last_value = 0;

        scan_chain_length = SCAN_CHAIN;
        num_output_cntrs  = 5;

        
        phasestep_high_count = 0;
        update_phase = 0;
        // set initial values for counter parameters
        m_initial_val = i_m_initial;
        m_val[0] = i_m;
        n_val[0] = i_n;
        m_ph_val = i_m_ph;
        m_ph_val_orig = i_m_ph;
        m_ph_val_tmp = i_m_ph;
        m_val_tmp[0] = i_m;


        if (m_val[0] == 1)
            m_mode_val[0] = "bypass";
        else m_mode_val[0] = "";
        if (m_val[1] == 1)
            m_mode_val[1] = "bypass";
        if (n_val[0] == 1)
            n_mode_val[0] = "bypass";
        if (n_val[1] == 1)
            n_mode_val[1] = "bypass";

        for (i = 0; i < 10; i=i+1)
        begin
            c_high_val[i] = i_c_high[i];
            c_low_val[i] = i_c_low[i];
            c_initial_val[i] = i_c_initial[i];
            c_mode_val[i] = i_c_mode[i];
            c_ph_val[i] = i_c_ph[i];
            c_high_val_tmp[i] = i_c_high[i];
            c_hval[i] = i_c_high[i];
            c_low_val_tmp[i] = i_c_low[i];
            c_lval[i] = i_c_low[i];
            if (c_mode_val[i] == "bypass")
            begin
                if (l_pll_type == "fast" || l_pll_type == "lvds" || l_pll_type == "left_right")
                begin
                    c_high_val[i] = 5'b10000;
                    c_low_val[i] = 5'b10000;
                    c_high_val_tmp[i] = 5'b10000;
                    c_low_val_tmp[i] = 5'b10000;
                end
                else begin
                    c_high_val[i] = 9'b100000000;
                    c_low_val[i] = 9'b100000000;
                    c_high_val_tmp[i] = 9'b100000000;
                    c_low_val_tmp[i] = 9'b100000000;
                end
            end

            c_mode_val_tmp[i] = i_c_mode[i];
            c_ph_val_tmp[i] = i_c_ph[i];

            c_ph_val_orig[i] = i_c_ph[i];
            c_high_val_hold[i] = i_c_high[i];
            c_low_val_hold[i] = i_c_low[i];
            c_mode_val_hold[i] = i_c_mode[i];
        end

        lfc_val = loop_filter_c;
        lfr_val = loop_filter_r;
        cp_curr_val = charge_pump_current;
        vco_cur = vco_post_scale;

        i = 0;
        j = 0;
        inclk_last_value = 0;

    
        // initialize clkswitch variables

        clk0_is_bad = 0;
        clk1_is_bad = 0;
        inclk0_last_value = 0;
        inclk1_last_value = 0;
        other_clock_value = 0;
        other_clock_last_value = 0;
        primary_clk_is_bad = 0;
        current_clk_is_bad = 0;
        external_switch = 0;
        current_clock = 0;
        current_clock_man = 0;

        active_clock = 0;   // primary_clk is always inclk0
        if (l_pll_type == "fast" || (l_pll_type == "left_right"))
            l_switch_over_type = "manual";

        if (l_switch_over_type == "manual" && clkswitch === 1'b1)
        begin
            current_clock_man = 1;
            active_clock = 1;
        end
        got_curr_clk_falling_edge_after_clkswitch = 0;
        clk0_count = 0;
        clk1_count = 0;

        // initialize reconfiguration variables
        // quiet_time
        quiet_time = slowest_clk  ( c_high_val[0]+c_low_val[0], c_mode_val[0],
                                    c_high_val[1]+c_low_val[1], c_mode_val[1],
                                    c_high_val[2]+c_low_val[2], c_mode_val[2],
                                    c_high_val[3]+c_low_val[3], c_mode_val[3],
                                    c_high_val[4]+c_low_val[4], c_mode_val[4],
                                    c_high_val[5]+c_low_val[5], c_mode_val[5],
                                    c_high_val[6]+c_low_val[6], c_mode_val[6],
                                    c_high_val[7]+c_low_val[7], c_mode_val[7],
                                    c_high_val[8]+c_low_val[8], c_mode_val[8],
                                    c_high_val[9]+c_low_val[9], c_mode_val[9],
                                    refclk_period, m_val[0]);
        reconfig_err = 0;
        error = 0;
        
        
        c0_rising_edge_transfer_done = 0;
        c1_rising_edge_transfer_done = 0;
        c2_rising_edge_transfer_done = 0;
        c3_rising_edge_transfer_done = 0;
        c4_rising_edge_transfer_done = 0;
        got_first_scanclk = 0;
        got_first_gated_scanclk = 0;
        gated_scanclk = 1;
        scanread_setup_violation = 0;
        index = 0;

        vco_over  = 1'b0;
        vco_under = 1'b0;
        
        // Initialize the scan chain 
        
        // LF unused : bit 1
        scan_data[-1:0] = 2'b00;
        // LF Capacitance : bits 1,2 : all values are legal
        scan_data[1:2] = loop_filter_c_bits;
        // LF Resistance : bits 3-7
        scan_data[3:7] = loop_filter_r_bits;
        
        // VCO post scale
        if(vco_post_scale == 1)
        begin
            scan_data[8] = 1'b1;
            vco_val_old_bit_setting = 1'b1;
        end
        else
        begin
            scan_data[8] = 1'b0;
            vco_val_old_bit_setting = 1'b0;
        end
            
        scan_data[9:13] = 5'b00000;
        // CP
        // Bit 8 : CRBYPASS
        // Bit 9-13 : unused
        // Bits 14-16 : all values are legal                 
                scan_data[14:16] = charge_pump_current_bits;
        // store as old values
        
        cp_curr_old_bit_setting = charge_pump_current_bits;
        lfc_val_old_bit_setting = loop_filter_c_bits;
        lfr_val_old_bit_setting = loop_filter_r_bits;
            
        // C counters (start bit 53) bit 1:mode(bypass),bit 2-9:high,bit 10:mode(odd/even),bit 11-18:low
        for (i = 0; i < num_output_cntrs; i = i + 1)
        begin
            // 1. Mode - bypass
            if (c_mode_val[i] == "bypass")
            begin
                scan_data[53 + i*18 + 0] = 1'b1;
                if (c_mode_val[i] == "   odd")
                    scan_data[53 + i*18 + 9] = 1'b1;
                else
                    scan_data[53 + i*18 + 9] = 1'b0;
            end
            else
            begin
                scan_data[53 + i*18 + 0] = 1'b0;
                // 3. Mode - odd/even
                if (c_mode_val[i] == "   odd")
                    scan_data[53 + i*18 + 9] = 1'b1;
                else
                    scan_data[53 + i*18 + 9] = 1'b0;
            end
            // 2. Hi
            c_val = c_high_val[i];
            for (j = 1; j <= 8; j = j + 1)
                scan_data[53 + i*18 + j]  = c_val[8 - j];
   
            // 4. Low
            c_val = c_low_val[i];
            for (j = 10; j <= 17; j = j + 1)
                scan_data[53 + i*18 + j] = c_val[17 - j];
        end
            
        // M counter
        // 1. Mode - bypass (bit 17)
        if (m_mode_val[0] == "bypass")
                scan_data[35] = 1'b1;
        else
                scan_data[35] = 1'b0;
       
        // 2. High (bit 18-25)
        // 3. Mode - odd/even (bit 26)
        if (m_val[0] % 2 == 0)
        begin
            // M is an even no. : set M high = low,
            // set odd/even bit to 0
                scan_data[36:43]= m_val[0]/2;
                scan_data[44] = 1'b0;
        end
        else 
        begin 
            // M is odd : M high = low + 1
                scan_data[36:43] = m_val[0]/2 + 1;
                scan_data[44] = 1'b1;             
        end
        // 4. Low (bit 27-34)
            scan_data[45:52] = m_val[0]/2;

        
        // N counter
        // 1. Mode - bypass (bit 35)
        if (n_mode_val[0] == "bypass")
                scan_data[17] = 1'b1;
        else 
                scan_data[17] = 1'b0;
        // 2. High (bit 36-43)
        // 3. Mode - odd/even (bit 44)
        if (n_val[0] % 2 == 0)
        begin
            // N is an even no. : set N high = low,
            // set odd/even bit to 0
                scan_data[18:25] = n_val[0]/2;
                scan_data[26] = 1'b0;         
        end
        else 
        begin // N is odd : N high = N low + 1
                scan_data[18:25] = n_val[0]/2+ 1;
                scan_data[26] = 1'b1;         
        end
        // 4. Low (bit 45-52)
                scan_data[27:34] = n_val[0]/2;


        l_index = 1;
        stop_vco = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;
        locked_tmp = 0;
        pll_is_locked = 0;
        no_warn = 1'b0;
        
        pfd_locked = 1'b0;
        cycles_pfd_high = 0;
        cycles_pfd_low  = 0;

        // check if pll is in test mode
        if (m_test_source != -1 || c0_test_source != -1 || c1_test_source != -1 || c2_test_source != -1 || c3_test_source != -1 || c4_test_source != -1)
            pll_in_test_mode = 1'b1;
        else
            pll_in_test_mode = 1'b0;

        pll_is_in_reset = 0;
        pll_has_just_been_reconfigured = 0;
        if (l_pll_type == "fast" || l_pll_type == "lvds" || l_pll_type == "left_right")
            is_fast_pll = 1;
        else is_fast_pll = 0;

        if (c1_use_casc_in == "on")
            ic1_use_casc_in = 1;
        else
            ic1_use_casc_in = 0;
        if (c2_use_casc_in == "on")
            ic2_use_casc_in = 1;
        else
            ic2_use_casc_in = 0;
        if (c3_use_casc_in == "on")
            ic3_use_casc_in = 1;
        else
            ic3_use_casc_in = 0;
        if (c4_use_casc_in == "on")
            ic4_use_casc_in = 1;
        else
            ic4_use_casc_in = 0;

        tap0_is_active = 1;
        
// To display clock mapping       
    case( i_clk0_counter)
            "c0" : clk_num[0] = "  clk0";
            "c1" : clk_num[0] = "  clk1";
            "c2" : clk_num[0] = "  clk2";
            "c3" : clk_num[0] = "  clk3";
            "c4" : clk_num[0] = "  clk4";
            default:clk_num[0] = "unused";
    endcase
    
        case( i_clk1_counter)
            "c0" : clk_num[1] = "  clk0";
            "c1" : clk_num[1] = "  clk1";
            "c2" : clk_num[1] = "  clk2";
            "c3" : clk_num[1] = "  clk3";
            "c4" : clk_num[1] = "  clk4";
            default:clk_num[1] = "unused";
    endcase
        
    case( i_clk2_counter)
            "c0" : clk_num[2] = "  clk0";
            "c1" : clk_num[2] = "  clk1";
            "c2" : clk_num[2] = "  clk2";
            "c3" : clk_num[2] = "  clk3";
            "c4" : clk_num[2] = "  clk4";
            default:clk_num[2] = "unused";
    endcase
        
    case( i_clk3_counter)
            "c0" : clk_num[3] = "  clk0";
            "c1" : clk_num[3] = "  clk1";
            "c2" : clk_num[3] = "  clk2";
            "c3" : clk_num[3] = "  clk3";
            "c4" : clk_num[3] = "  clk4";
            default:clk_num[3] = "unused";
    endcase
        
    case( i_clk4_counter)
            "c0" : clk_num[4] = "  clk0";
            "c1" : clk_num[4] = "  clk1";
            "c2" : clk_num[4] = "  clk2";
            "c3" : clk_num[4] = "  clk3";
            "c4" : clk_num[4] = "  clk4";
            default:clk_num[4] = "unused";
    endcase
        

        end


// Clock Switchover

always @(clkswitch)
begin
    if (clkswitch === 1'b1 && l_switch_over_type == "auto")
        external_switch = 1;
    else if (l_switch_over_type == "manual") 
    begin
        if(clkswitch === 1'b1)
            switch_clock = 1'b1;
        else
            switch_clock = 1'b0;
    end
end


always @(posedge inclk[0])
begin
// Determine the inclk0 frequency
    if (first_inclk0_edge_detect == 1'b0)
        begin
            first_inclk0_edge_detect = 1'b1;
        end
    else
        begin
            last_inclk0_period = inclk0_period;
            inclk0_period = $realtime - last_inclk0_edge;
        end
    last_inclk0_edge = $realtime;

end

always @(posedge inclk[1])
begin
// Determine the inclk1 frequency
    if (first_inclk1_edge_detect == 1'b0)
        begin
            first_inclk1_edge_detect = 1'b1;
        end
    else
        begin
            last_inclk1_period = inclk1_period;
            inclk1_period = $realtime - last_inclk1_edge;
        end
    last_inclk1_edge = $realtime;

end

    always @(inclk[0] or inclk[1])
    begin
        if(switch_clock == 1'b1)
        begin
                if(current_clock_man == 0)
                begin
                    current_clock_man = 1;
                    active_clock = 1;
                end
                else
                begin
                    current_clock_man = 0;
                    active_clock = 0;
                end
                switch_clock = 1'b0;
            end

        if (current_clock_man == 0)
            inclk_man = inclk[0];
        else
            inclk_man = inclk[1];


        // save the inclk event value
        if (inclk[0] !== inclk0_last_value)
        begin
            if (current_clock != 0)
                other_clock_value = inclk[0];
        end
        if (inclk[1] !== inclk1_last_value)
        begin
            if (current_clock != 1)
                other_clock_value = inclk[1];
        end

        // check if either input clk is bad
        if (inclk[0] === 1'b1 && inclk[0] !== inclk0_last_value)
        begin
            clk0_count = clk0_count + 1;
            clk0_is_bad = 0;
            clk1_count = 0;
            if (clk0_count > 2)
            begin
                // no event on other clk for 2 cycles
                clk1_is_bad = 1;
                if (current_clock == 1)
                    current_clk_is_bad = 1;
            end
        end
        if (inclk[1] === 1'b1 && inclk[1] !== inclk1_last_value)
        begin
            clk1_count = clk1_count + 1;
            clk1_is_bad = 0;
            clk0_count = 0;
            if (clk1_count > 2)
            begin
                // no event on other clk for 2 cycles
                clk0_is_bad = 1;
                if (current_clock == 0)
                    current_clk_is_bad = 1;
            end
        end

        // check if the bad clk is the primary clock, which is always clk0
        if (clk0_is_bad == 1'b1)
            primary_clk_is_bad = 1;
        else
            primary_clk_is_bad = 0;

        // actual switching -- manual switch
        if ((inclk[0] !== inclk0_last_value) && current_clock == 0)
        begin
            if (external_switch == 1'b1)
            begin
                if (!got_curr_clk_falling_edge_after_clkswitch)
                begin
                    if (inclk[0] === 1'b0)
                        got_curr_clk_falling_edge_after_clkswitch = 1;
                    inclk_es = inclk[0];
                end
            end
            else inclk_es = inclk[0];
        end
        if ((inclk[1] !== inclk1_last_value) && current_clock == 1)
        begin
            if (external_switch == 1'b1)
            begin
                if (!got_curr_clk_falling_edge_after_clkswitch)
                begin
                    if (inclk[1] === 1'b0)
                        got_curr_clk_falling_edge_after_clkswitch = 1;
                    inclk_es = inclk[1];
                end
            end
            else inclk_es = inclk[1];
        end

        // actual switching -- automatic switch
        if ((other_clock_value == 1'b1) && (other_clock_value != other_clock_last_value) && l_enable_switch_over_counter == "on" && primary_clk_is_bad)
            switch_over_count = switch_over_count + 1;
        
        if ((other_clock_value == 1'b0) && (other_clock_value != other_clock_last_value))
        begin
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (primary_clk_is_bad && (clkswitch !== 1'b1) && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
            begin
                if (areset === 1'b0)
                begin
                    if ((inclk0_period > inclk1_period) && (inclk1_period != 0))
                        diff_percent_period = (( inclk0_period - inclk1_period ) * 100) / inclk1_period;
                    else if (inclk0_period != 0)
                        diff_percent_period = (( inclk1_period - inclk0_period ) * 100) / inclk0_period;

                    if((diff_percent_period > 20)&& (l_switch_over_type == "auto"))
                    begin
                        $display ("Warning : The input clock frequencies specified for the specified PLL are too far apart for auto-switch-over feature to work properly. Please make sure that the clock frequencies are 20 percent apart for correct functionality.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end

                got_curr_clk_falling_edge_after_clkswitch = 0;
                if (current_clock == 0)
                    current_clock = 1;
                else
                    current_clock = 0;
                    
                active_clock = ~active_clock;
                switch_over_count = 0;
                external_switch = 0;
                current_clk_is_bad = 0;
            end
            else if(l_switch_over_type == "auto")
                begin
                    if(current_clock == 0 && clk0_is_bad == 1'b1 && clk1_is_bad == 1'b0 )
                        begin
                            current_clock = 1;
                            active_clock = ~active_clock;
                        end 
                
                    if(current_clock == 1 && clk1_is_bad == 1'b1 && clk0_is_bad == 1'b0 )
                        begin
                            current_clock = 0;
                            active_clock = ~active_clock;
                        end
                end     
        end
        
        if(l_switch_over_type == "manual")
            inclk_n = inclk_man;
        else
            inclk_n = inclk_es;
            
        inclk0_last_value = inclk[0];
        inclk1_last_value = inclk[1];
        other_clock_last_value = other_clock_value;

    end

    and (clkbad[0], clk0_is_bad, 1'b1);
    and (clkbad[1], clk1_is_bad, 1'b1);
    and (activeclock, active_clock, 1'b1);


    assign inclk_m = (m_test_source == 0) ? fbclk : (m_test_source == 1) ? refclk : inclk_m_from_vco; 
                       

    cycloneiiils_m_cntr m1 (.clk(inclk_m),
                        .reset(areset || stop_vco),
                        .cout(fbclk),
                        .initial_value(m_initial_val),
                        .modulus(m_val[0]),
                        .time_delay(m_delay));

    cycloneiiils_n_cntr n1 (.clk(inclk_n),
                        .reset(areset),
                        .cout(refclk),
                        .modulus(n_val[0]));



    // Update clock on /o counters from corresponding VCO tap
    assign inclk_m_from_vco  = vco_tap[m_ph_val];
    assign inclk_c0_from_vco = vco_tap[c_ph_val[0]];
    assign inclk_c1_from_vco = vco_tap[c_ph_val[1]];
    assign inclk_c2_from_vco = vco_tap[c_ph_val[2]];
    assign inclk_c3_from_vco = vco_tap[c_ph_val[3]];
    assign inclk_c4_from_vco = vco_tap[c_ph_val[4]];
always @(vco_out)
    begin
        // check which VCO TAP has event
        for (x = 0; x <= 7; x = x + 1)
        begin
            if (vco_out[x] !== vco_out_last_value[x])
            begin
                // TAP 'X' has event
                if ((x == 0) && (!pll_is_in_reset) && (stop_vco !== 1'b1))
                begin
                    if (vco_out[0] == 1'b1)
                        tap0_is_active = 1;
                    if (tap0_is_active == 1'b1)
                        vco_tap[0] <= vco_out[0];
                end
                else if (tap0_is_active == 1'b1)
                    vco_tap[x] <= vco_out[x];
                if (stop_vco === 1'b1)
                    vco_out[x] <= 1'b0;
            end
        end
        vco_out_last_value = vco_out;
    end

    always @(vco_tap)
    begin
        // Update phase taps for C/M counters on negative edge of VCO clock output
        
        if (update_phase == 1'b1)
        begin
            for (x = 0; x <= 7; x = x + 1)
            begin
                if ((vco_tap[x] === 1'b0) && (vco_tap[x] !== vco_tap_last_value[x]))
                begin
                    for (y = 0; y < 10; y = y + 1)
                    begin
                        if (c_ph_val_tmp[y] == x)
                            c_ph_val[y] = c_ph_val_tmp[y];
                    end
                    if (m_ph_val_tmp == x)
                        m_ph_val = m_ph_val_tmp;
                end
            end
            update_phase <= #(0.5*scanclk_period) 1'b0;
        end

        // On reset, set all C/M counter phase taps to POF programmed values
        if (areset === 1'b1)
        begin
            m_ph_val = m_ph_val_orig;
            m_ph_val_tmp = m_ph_val_orig;
            for (i=0; i<= 9; i=i+1)
            begin
                c_ph_val[i] = c_ph_val_orig[i];
                c_ph_val_tmp[i] = c_ph_val_orig[i];
            end
        end

        vco_tap_last_value = vco_tap;
    end

    assign inclk_c0 = (c0_test_source == 0) ? fbclk : (c0_test_source == 1) ? refclk : inclk_c0_from_vco;

    cycloneiiils_scale_cntr c0 (.clk(inclk_c0),
                            .reset(areset  || stop_vco),
                            .cout(c0_clk),
                            .high(c_high_val[0]),
                            .low(c_low_val[0]),
                            .initial_value(c_initial_val[0]),
                            .mode(c_mode_val[0]),
                            .ph_tap(c_ph_val[0]));

    // Update /o counters mode and duty cycle immediately after configupdate is asserted
    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[0] <= c_high_val_tmp[0];
            c_mode_val[0] <= c_mode_val_tmp[0];
            c0_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c0_rising_edge_transfer_done)
        begin
            c_low_val[0] <= c_low_val_tmp[0];
        end
    end

    assign inclk_c1 = (c1_test_source == 0) ? fbclk : (c1_test_source == 1) ? refclk : (ic1_use_casc_in == 1) ? c0_clk : inclk_c1_from_vco;
    
    cycloneiiils_scale_cntr c1 (.clk(inclk_c1),
                            .reset(areset || stop_vco),
                            .cout(c1_clk),
                            .high(c_high_val[1]),
                            .low(c_low_val[1]),
                            .initial_value(c_initial_val[1]),
                            .mode(c_mode_val[1]),
                            .ph_tap(c_ph_val[1]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[1] <= c_high_val_tmp[1];
            c_mode_val[1] <= c_mode_val_tmp[1];
            c1_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c1_rising_edge_transfer_done)
        begin
            c_low_val[1] <= c_low_val_tmp[1];
        end
    end

    assign inclk_c2 = (c2_test_source == 0) ? fbclk : (c2_test_source == 1) ? refclk :(ic2_use_casc_in == 1) ? c1_clk : inclk_c2_from_vco;

    cycloneiiils_scale_cntr c2 (.clk(inclk_c2),
                            .reset(areset || stop_vco),
                            .cout(c2_clk),
                            .high(c_high_val[2]),
                            .low(c_low_val[2]),
                            .initial_value(c_initial_val[2]),
                            .mode(c_mode_val[2]),
                            .ph_tap(c_ph_val[2]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[2] <= c_high_val_tmp[2];
            c_mode_val[2] <= c_mode_val_tmp[2];
            c2_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c2_rising_edge_transfer_done)
        begin
            c_low_val[2] <= c_low_val_tmp[2];
        end
    end

    assign inclk_c3 = (c3_test_source == 0) ? fbclk : (c3_test_source == 1) ? refclk : (ic3_use_casc_in == 1) ? c2_clk : inclk_c3_from_vco;
    
    cycloneiiils_scale_cntr c3 (.clk(inclk_c3),
                            .reset(areset  || stop_vco),
                            .cout(c3_clk),
                            .high(c_high_val[3]),
                            .low(c_low_val[3]),
                            .initial_value(c_initial_val[3]),
                            .mode(c_mode_val[3]),
                            .ph_tap(c_ph_val[3]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[3] <= c_high_val_tmp[3];
            c_mode_val[3] <= c_mode_val_tmp[3];
            c3_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c3_rising_edge_transfer_done)
        begin
            c_low_val[3] <= c_low_val_tmp[3];
        end
    end

    assign inclk_c4 = ((c4_test_source == 0) ? fbclk : (c4_test_source == 1) ? refclk :  (ic4_use_casc_in == 1) ? c3_clk : inclk_c4_from_vco);
    cycloneiiils_scale_cntr c4 (.clk(inclk_c4),
                            .reset(areset || stop_vco),
                            .cout(c4_clk),
                            .high(c_high_val[4]),
                            .low(c_low_val[4]),
                            .initial_value(c_initial_val[4]),
                            .mode(c_mode_val[4]),
                            .ph_tap(c_ph_val[4]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[4] <= c_high_val_tmp[4];
            c_mode_val[4] <= c_mode_val_tmp[4];
            c4_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c4_rising_edge_transfer_done)
        begin
            c_low_val[4] <= c_low_val_tmp[4];
        end
    end

    
assign locked = (test_bypass_lock_detect == "on") ? pfd_locked : locked_tmp;

// Register scanclk enable
    always @(negedge scanclk)
        scanclkena_reg <= scanclkena;
        
// Negative edge flip-flop in front of scan-chain

    always @(negedge scanclk)
    begin
        if (scanclkena_reg)
        begin
            scandata_in <= scandata;
        end
    end
   
// Scan chain
    always @(posedge scanclk)
    begin
        if (got_first_scanclk === 1'b0)
                got_first_scanclk = 1'b1;
        else
                scanclk_period = $time - scanclk_last_rising_edge;
        if (scanclkena_reg) 
        begin        
            for (j = scan_chain_length-2; j >= 0; j = j - 1)
                scan_data[j] = scan_data[j - 1];
            scan_data[-1] <= scandata_in;
        end
        scanclk_last_rising_edge = $realtime;
    end
    
// Scan output
    assign scandataout_tmp = scan_data[SCAN_CHAIN - 2];

// Negative edge flip-flop in rear of scan-chain

    always @(negedge scanclk)
    begin
        if (scanclkena_reg)
        begin
            scandata_out <= scandataout_tmp;
        end
    end
    
// Scan complete
    always @(negedge scandone_tmp)
    begin
            if (got_first_scanclk === 1'b1)
            begin
            if (reconfig_err == 1'b0)
            begin
                $display("NOTE : PLL Reprogramming completed with the following values (Values in parantheses are original values) : ");
                $display ("Time: %0t  Instance: %m", $time);

                $display("               N modulus =   %0d (%0d) ", n_val[0], n_val_old[0]);
                $display("               M modulus =   %0d (%0d) ", m_val[0], m_val_old[0]);
                

                for (i = 0; i < num_output_cntrs; i=i+1)
                begin
                    $display("              %s :    C%0d  high = %0d (%0d),       C%0d  low = %0d (%0d),       C%0d  mode = %s (%s)", clk_num[i],i, c_high_val[i], c_high_val_old[i], i, c_low_val_tmp[i], c_low_val_old[i], i, c_mode_val[i], c_mode_val_old[i]);
                end

                // display Charge pump and loop filter values
                if (pll_reconfig_display_full_setting == 1'b1)
                begin
                    $display ("               Charge Pump Current (uA) =   %0d (%0d) ", cp_curr_val, cp_curr_old);
                    $display ("               Loop Filter Capacitor (pF) =   %0d (%0d) ", lfc_val, lfc_old);
                    $display ("               Loop Filter Resistor (Kohm) =   %s (%s) ", lfr_val, lfr_old);
                    $display ("               VCO_Post_Scale  =   %0d (%0d) ", vco_cur, vco_old);
                end
                else
                begin
                    $display ("               Charge Pump Current  =   %0d (%0d) ", cp_curr_bit_setting, cp_curr_old_bit_setting);
                    $display ("               Loop Filter Capacitor  =   %0d (%0d) ", lfc_val_bit_setting, lfc_val_old_bit_setting);
                    $display ("               Loop Filter Resistor   =   %0d (%0d) ", lfr_val_bit_setting, lfr_val_old_bit_setting);
                    $display ("               VCO_Post_Scale   =   %b (%b) ", vco_val_bit_setting, vco_val_old_bit_setting);
                end
                cp_curr_old_bit_setting = cp_curr_bit_setting;
                lfc_val_old_bit_setting = lfc_val_bit_setting;
                lfr_val_old_bit_setting = lfr_val_bit_setting;
                vco_val_old_bit_setting = vco_val_bit_setting;
            end
            else begin
                $display("Warning : Errors were encountered during PLL reprogramming. Please refer to error/warning messages above.");
                $display ("Time: %0t  Instance: %m", $time);
            end
            end
    end

// ************ PLL Phase Reconfiguration ************* //

// Latch updown,counter values at pos edge of scan clock
always @(posedge scanclk)
begin
    if (phasestep_reg == 1'b1)
    begin
        if (phasestep_high_count == 1)
        begin
            phasecounterselect_reg <= phasecounterselect;
            phaseupdown_reg <= phaseupdown;
            // start reconfiguration
            if (phasecounterselect < 3'b111) // no counters selected
            begin
                if (phasecounterselect == 0) // all output counters selected
                begin
                    for (i = 0; i < num_output_cntrs; i = i + 1)
                        c_ph_val_tmp[i] = (phaseupdown == 1'b1) ? 
                                    (c_ph_val_tmp[i] + 1) % num_phase_taps :
                                    (c_ph_val_tmp[i] == 0) ? num_phase_taps - 1 : (c_ph_val_tmp[i] - 1) % num_phase_taps ;
                end
                else if (phasecounterselect == 1) // select M counter
                begin
                    m_ph_val_tmp = (phaseupdown == 1'b1) ? 
                                (m_ph_val + 1) % num_phase_taps :
                                (m_ph_val == 0) ? num_phase_taps - 1 : (m_ph_val - 1) % num_phase_taps ;
                end
                else // select C counters
                begin
                    select_counter = phasecounterselect - 2;
                    c_ph_val_tmp[select_counter] =  (phaseupdown == 1'b1) ? 
                                            (c_ph_val_tmp[select_counter] + 1) % num_phase_taps :
                                            (c_ph_val_tmp[select_counter] == 0) ? num_phase_taps - 1 : (c_ph_val_tmp[select_counter] - 1) % num_phase_taps ;
                end
                update_phase <= 1'b1;
            end 
           
        end
        phasestep_high_count = phasestep_high_count + 1;
       
    end
end

// Latch phase enable (same as phasestep) on neg edge of scan clock
always @(negedge scanclk)
begin
    phasestep_reg <= phasestep;
end

always @(posedge phasestep) 
begin
    if (update_phase == 1'b0) phasestep_high_count = 0; // phase adjustments must be 1 cycle apart
                                                        // if not, next phasestep cycle is skipped
end

// ************ PLL Full Reconfiguration ************* //
assign update_conf_latches = configupdate;


        // reset counter transfer flags
    always @(negedge scandone_tmp)
    begin
        c0_rising_edge_transfer_done = 0;
        c1_rising_edge_transfer_done = 0;
        c2_rising_edge_transfer_done = 0;
        c3_rising_edge_transfer_done = 0;
        c4_rising_edge_transfer_done = 0;
        update_conf_latches_reg <= 1'b0;
    end


    always @(posedge update_conf_latches)
    begin
        initiate_reconfig <= 1'b1;
    end
   
    always @(posedge areset)
    begin
        if (scandone_tmp == 1'b1) scandone_tmp = 1'b0;
    end
   
    always @(posedge scanclk)
    begin
        if (initiate_reconfig == 1'b1) 
        begin
            initiate_reconfig <= 1'b0;
            $display ("NOTE : PLL Reprogramming initiated ....");
            $display ("Time: %0t  Instance: %m", $time);

            scandone_tmp <= #(scanclk_period) 1'b1;
            update_conf_latches_reg <= update_conf_latches;

            error = 0;
            reconfig_err = 0;
            scanread_setup_violation = 0;

            // save old values
            cp_curr_old = cp_curr_val;
            lfc_old = lfc_val;
            lfr_old = lfr_val;
            vco_old = vco_cur;
            // save old values of bit settings
            cp_curr_bit_setting = scan_data[14:16];
            lfc_val_bit_setting = scan_data[1:2];
            lfr_val_bit_setting = scan_data[3:7];
            vco_val_bit_setting = scan_data[8];

            // LF unused : bit 1
            // LF Capacitance : bits 1,2 : all values are legal
            if ((l_pll_type == "fast") || (l_pll_type == "lvds") || (l_pll_type == "left_right"))
                lfc_val = fpll_loop_filter_c_arr[scan_data[1:2]];
            else
                lfc_val = loop_filter_c_arr[scan_data[1:2]];

            // LF Resistance : bits 3-7
            // valid values - 00000,00100,10000,10100,11000,11011,11100,11110
            if (((scan_data[3:7] == 5'b00000) || (scan_data[3:7] == 5'b00100)) || 
                ((scan_data[3:7] == 5'b10000) || (scan_data[3:7] == 5'b10100)) ||
                ((scan_data[3:7] == 5'b11000) || (scan_data[3:7] == 5'b11011)) ||
                ((scan_data[3:7] == 5'b11100) || (scan_data[3:7] == 5'b11110))
            )
            begin
                lfr_val =   (scan_data[3:7] == 5'b00000) ? "20" :
                            (scan_data[3:7] == 5'b00100) ? "16" :
                            (scan_data[3:7] == 5'b10000) ? "12" :
                            (scan_data[3:7] == 5'b10100) ? "8" :
                            (scan_data[3:7] == 5'b11000) ? "6" :
                            (scan_data[3:7] == 5'b11011) ? "4" : 
                            (scan_data[3:7] == 5'b11100) ? "2" : "1";
            end

            //VCO post scale value
            if (scan_data[8] === 1'b1)  // vco_post_scale = 1
            begin
                i_vco_max = i_vco_max_no_division/2;
                i_vco_min = i_vco_min_no_division/2;
                vco_cur = 1;
            end
            else
            begin
                i_vco_max = vco_max;
                i_vco_min = vco_min; 
                vco_cur = 2;
            end          

            // CP
            // Bit 8 : CRBYPASS
            // Bit 9-13 : unused
            // Bits 14-16 : all values are legal
            cp_curr_val = scan_data[14:16];

            // save old values for display info.
            for (i=0; i<=1; i=i+1)
            begin
                m_val_old[i] = m_val[i];
                n_val_old[i] = n_val[i];
                m_mode_val_old[i] = m_mode_val[i];
                n_mode_val_old[i] = n_mode_val[i];
            end
            for (i=0; i< num_output_cntrs; i=i+1)
            begin
                c_high_val_old[i] = c_high_val[i];
                c_low_val_old[i] = c_low_val[i];
                c_mode_val_old[i] = c_mode_val[i];
            end

            // M counter
            // 1. Mode - bypass (bit 17)
            if (scan_data[17] == 1'b1)
                n_mode_val[0] = "bypass";
            // 3. Mode - odd/even (bit 26)
            else if (scan_data[26] == 1'b1)
                n_mode_val[0] = "   odd";         
            else
                n_mode_val[0] = "  even";         
            // 2. High (bit 18-25)
                n_hi = scan_data[18:25];
            // 4. Low (bit 27-34)
                n_lo = scan_data[27:34]; 


            // N counter
            // 1. Mode - bypass (bit 35)
            if (scan_data[35] == 1'b1)
                m_mode_val[0] = "bypass";
            // 3. Mode - odd/even (bit 44)
            else if (scan_data[44] == 1'b1)
                m_mode_val[0] = "   odd";
            else
                m_mode_val[0] = "  even";
            
            // 2. High (bit 36-43)
                m_hi = scan_data[36:43];
            
            // 4. Low (bit 45-52)
                m_lo = scan_data[45:52]; 


            
//Update the current M and N counter values if the counters are NOT bypassed

if (m_mode_val[0] != "bypass")
m_val[0] = m_hi + m_lo;
if (n_mode_val[0] != "bypass")  
n_val[0] = n_hi + n_lo;
            


            // C counters (start bit 53) bit 1:mode(bypass),bit 2-9:high,bit 10:mode(odd/even),bit 11-18:low

            for (i = 0; i < num_output_cntrs; i = i + 1)
            begin
                // 1. Mode - bypass
                if (scan_data[53 + i*18 + 0] == 1'b1)
                        c_mode_val_tmp[i] = "bypass";
                // 3. Mode - odd/even
                else if (scan_data[53 + i*18 + 9] == 1'b1)
                    c_mode_val_tmp[i] = "   odd";
                else
                    c_mode_val_tmp[i] = "  even";
                    
                // 2. Hi
                for (j = 1; j <= 8; j = j + 1)
                    c_val[8-j] = scan_data[53 + i*18 + j];
                c_hval[i] = c_val[7:0];
                if (c_hval[i] !== 32'h00000000)
                    c_high_val_tmp[i] = c_hval[i];
                else
                    c_high_val_tmp[i] = 9'b100000000;
                // 4. Low 
                for (j = 10; j <= 17; j = j + 1)
                    c_val[17 - j] = scan_data[53 + i*18 + j]; 
                c_lval[i] = c_val[7:0];
                if (c_lval[i] !== 32'h00000000)
                    c_low_val_tmp[i] = c_lval[i];  
                else
                    c_low_val_tmp[i] = 9'b100000000; 
            end

            // Legality Checks
            
            if (m_mode_val[0] != "bypass")
            begin
            if ((m_hi !== m_lo) && (m_mode_val[0] != "   odd"))
            begin
                    reconfig_err = 1;
                    $display ("Warning : The M counter of the %s Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
            end
            else if (m_hi !== 8'b00000000)
            begin
                    // counter value
                    m_val_tmp[0] = m_hi + m_lo;
            end
            else
                m_val_tmp[0] =  9'b100000000; 
            end
            else
                m_val_tmp[0] = 8'b00000001;
                
            if (n_mode_val[0] != "bypass")
            begin
            if ((n_hi !== n_lo) && (n_mode_val[0] != "   odd"))
            begin
                    reconfig_err = 1;
                    $display ("Warning : The N counter of the %s Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
            end
            else if (n_hi !== 8'b00000000)
            begin
                    // counter value
                    n_val[0] = n_hi + n_lo;
            end
            else
                n_val[0] =  9'b100000000; 
            end
            else
                n_val[0] = 8'b00000001;
                           
                 

// TODO : Give warnings/errors in the following cases?
// 1. Illegal counter values (error)
// 2. Change of mode (warning)
// 3. Only 50% duty cycle allowed for M counter (odd mode - hi-lo=1,even - hi-lo=0)

        end
    end
    
    // Self reset on loss of lock
    assign reset_self = (l_self_reset_on_loss_lock == "on") ? ~pll_is_locked : 1'b0;

    always @(posedge reset_self)
    begin
        $display (" Note : %s PLL self reset due to loss of lock", family_name);
        $display ("Time: %0t  Instance: %m", $time);
    end
    
    // Phase shift on /o counters
    
    always @(schedule_vco or areset)
    begin
        sched_time = 0;
    
        for (i = 0; i <= 7; i=i+1)
            last_phase_shift[i] = phase_shift[i];
     
        cycle_to_adjust = 0;
        l_index = 1;
        m_times_vco_period = new_m_times_vco_period;
            
        // give appropriate messages
        // if areset was asserted
        if (areset === 1'b1 && areset_last_value !== areset)
        begin
            $display (" Note : %s PLL was reset", family_name);
            $display ("Time: %0t  Instance: %m", $time);
            // reset lock parameters
            pll_is_locked = 0;
            cycles_to_lock = 0;
            cycles_to_unlock = 0;
            tap0_is_active = 0;
            phase_adjust_was_scheduled = 0;
            for (x = 0; x <= 7; x=x+1)
                vco_tap[x] <= 1'b0;
        end
    
        // illegal value on areset
        if (areset === 1'bx && (areset_last_value === 1'b0 || areset_last_value === 1'b1))
        begin
            $display("Warning : Illegal value 'X' detected on ARESET input");
            $display ("Time: %0t  Instance: %m", $time);
        end
    
        if ((areset == 1'b1))
        begin
            pll_is_in_reset = 1;
            got_first_refclk = 0;
            got_second_refclk = 0;
        end
                            
        if ((schedule_vco !== schedule_vco_last_value) && (areset == 1'b1 || stop_vco == 1'b1))
        begin
   
            // drop VCO taps to 0
            for (i = 0; i <= 7; i=i+1)
            begin
                for (j = 0; j <= last_phase_shift[i] + 1; j=j+1)
                    vco_out[i] <= #(j) 1'b0;
                phase_shift[i] = 0;
                last_phase_shift[i] = 0;
            end
    
            // reset lock parameters
            pll_is_locked = 0;
            cycles_to_lock = 0;
            cycles_to_unlock = 0;
    
            got_first_refclk = 0;
            got_second_refclk = 0;
            refclk_time = 0;
            got_first_fbclk = 0;
            fbclk_time = 0;
            first_fbclk_time = 0;
            fbclk_period = 0;
    
            first_schedule = 1;
            vco_val = 0;
            vco_period_was_phase_adjusted = 0;
            phase_adjust_was_scheduled = 0;

            // reset all counter phase tap values to POF programmed values
            m_ph_val = m_ph_val_orig;
            for (i=0; i<= 5; i=i+1)
                c_ph_val[i] = c_ph_val_orig[i];
    
        end else if (areset === 1'b0 && stop_vco === 1'b0)
        begin
            // else note areset deassert time
            // note it as refclk_time to prevent false triggering
            // of stop_vco after areset
            if (areset === 1'b0 && areset_last_value === 1'b1 && pll_is_in_reset === 1'b1)
            begin
                refclk_time = $time;
                locked_tmp = 1'b0;
            end
            pll_is_in_reset = 0;
    
            // calculate loop_xplier : this will be different from m_val in ext. fbk mode
            loop_xplier = m_val[0];
            loop_initial = i_m_initial - 1;
            loop_ph = m_ph_val;
    
            // convert initial value to delay
            initial_delay = (loop_initial * m_times_vco_period)/loop_xplier;
    
            // convert loop ph_tap to delay
            rem = m_times_vco_period % loop_xplier;
            vco_per = m_times_vco_period/loop_xplier;
            if (rem != 0)
                vco_per = vco_per + 1;
            fbk_phase = (loop_ph * vco_per)/8;
    
            pull_back_M = initial_delay + fbk_phase;
    
            total_pull_back = pull_back_M;
            if (l_simulation_type == "timing")
                total_pull_back = total_pull_back + pll_compensation_delay;
    
            while (total_pull_back > refclk_period)
                total_pull_back = total_pull_back - refclk_period;
    
            if (total_pull_back > 0)
                offset = refclk_period - total_pull_back;
            else
                offset = 0;
    
            fbk_delay = total_pull_back - fbk_phase;
            if (fbk_delay < 0)
            begin
                offset = offset - fbk_phase;
                fbk_delay = total_pull_back;
            end
    
            // assign m_delay
            m_delay = fbk_delay;
    
            for (i = 1; i <= loop_xplier; i=i+1)
            begin
                // adjust cycles
                tmp_vco_per = m_times_vco_period/loop_xplier;
                if (rem != 0 && l_index <= rem)
                begin
                    tmp_rem = (loop_xplier * l_index) % rem;
                    cycle_to_adjust = (loop_xplier * l_index) / rem;
                    if (tmp_rem != 0)
                        cycle_to_adjust = cycle_to_adjust + 1;
                end
                if (cycle_to_adjust == i)
                begin
                    tmp_vco_per = tmp_vco_per + 1;
                    l_index = l_index + 1;
                end
    
                // calculate high and low periods
                high_time = tmp_vco_per/2;
                if (tmp_vco_per % 2 != 0)
                    high_time = high_time + 1;
                low_time = tmp_vco_per - high_time;
    
                // schedule the rising and falling egdes
                for (j=0; j<=1; j=j+1)
                begin
                    vco_val = ~vco_val;
                    if (vco_val == 1'b0)
                        sched_time = sched_time + high_time;
                    else
                        sched_time = sched_time + low_time;
    
                    // schedule taps with appropriate phase shifts
                    for (k = 0; k <= 7; k=k+1)
                    begin
                        phase_shift[k] = (k*tmp_vco_per)/8;
                        if (first_schedule)
                            vco_out[k] <= #(sched_time + phase_shift[k]) vco_val;
                        else
                            vco_out[k] <= #(sched_time + last_phase_shift[k]) vco_val;
                    end
                end
            end
            if (first_schedule)
            begin
                vco_val = ~vco_val;
                if (vco_val == 1'b0)
                    sched_time = sched_time + high_time;
                else
                    sched_time = sched_time + low_time;
                for (k = 0; k <= 7; k=k+1)
                begin
                    phase_shift[k] = (k*tmp_vco_per)/8;
                    vco_out[k] <= #(sched_time+phase_shift[k]) vco_val;
                end
                first_schedule = 0;
            end

            schedule_vco <= #(sched_time) ~schedule_vco;
            if (vco_period_was_phase_adjusted)
            begin
                m_times_vco_period = refclk_period;
                new_m_times_vco_period = refclk_period;
                vco_period_was_phase_adjusted = 0;
                phase_adjust_was_scheduled = 1;
    
                tmp_vco_per = m_times_vco_period/loop_xplier;
                for (k = 0; k <= 7; k=k+1)
                    phase_shift[k] = (k*tmp_vco_per)/8;
            end
        end
    
        areset_last_value = areset;
        schedule_vco_last_value = schedule_vco;
    
    end

    assign pfdena_wire = (pfdena === 1'b0) ? 1'b0 : 1'b1; 
    // PFD enable
    always @(pfdena_wire)
    begin
        if (pfdena_wire === 1'b0)
        begin
            if (pll_is_locked)
                locked_tmp = 1'bx;
            pll_is_locked = 0;
            cycles_to_lock = 0;
            $display (" Note : PFDENA was deasserted");
            $display ("Time: %0t  Instance: %m", $time);
        end
        else if (pfdena_wire === 1'b1 && pfdena_last_value === 1'b0)
        begin
            // PFD was disabled, now enabled again
            got_first_refclk = 0;
            got_second_refclk = 0;
            refclk_time = $time;
        end
        pfdena_last_value = pfdena_wire;
    end

    always @(negedge refclk or negedge fbclk)
    begin
        refclk_last_value = refclk;
        fbclk_last_value = fbclk;
    end

    // Bypass lock detect
        
    always @(posedge refclk)
    begin
    if (test_bypass_lock_detect == "on")
        begin
            if (pfdena_wire === 1'b1)
            begin
                    cycles_pfd_low = 0;
                    if (pfd_locked == 1'b0)
                    begin
                    if (cycles_pfd_high == lock_high)
                    begin
                        $display ("Note : %s PLL locked in test mode on PFD enable assert", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
                        pfd_locked <= 1'b1;
                    end
                    cycles_pfd_high = cycles_pfd_high + 1;
                        end
                end
            if (pfdena_wire === 1'b0)
            begin
                    cycles_pfd_high = 0;
                    if (pfd_locked == 1'b1)
                    begin
                    if (cycles_pfd_low == lock_low)
                    begin
                        $display ("Note : %s PLL lost lock in test mode on PFD enable deassert", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
                        pfd_locked <= 1'b0;
                    end
                    cycles_pfd_low = cycles_pfd_low + 1;
                        end
                end
        end
    end
    
    always @(posedge scandone_tmp or posedge locked_tmp)
    begin
        if(scandone_tmp == 1)
            pll_has_just_been_reconfigured <= 1;
        else
            pll_has_just_been_reconfigured <= 0;
    end
    
    // VCO Frequency Range check
    always @(posedge refclk or posedge fbclk)
    begin
        if (refclk == 1'b1 && refclk_last_value !== refclk && areset === 1'b0)
        begin
            if (! got_first_refclk)
            begin
                got_first_refclk = 1;
            end else
            begin
                got_second_refclk = 1;
                refclk_period = $time - refclk_time;

                // check if incoming freq. will cause VCO range to be
                // exceeded
                if ((i_vco_max != 0 && i_vco_min != 0) && (pfdena_wire === 1'b1) &&        
                    ((refclk_period/loop_xplier > i_vco_max) || 
                    (refclk_period/loop_xplier < i_vco_min)) ) 
                begin
                    if (pll_is_locked == 1'b1)
                    begin
                        if (refclk_period/loop_xplier > i_vco_max)
                        begin
                            $display ("Warning : Input clock freq. is over VCO range. %s PLL may lose lock", family_name);
                            vco_over = 1'b1;
                        end
                        if (refclk_period/loop_xplier < i_vco_min)
                        begin
                            $display ("Warning : Input clock freq. is under VCO range. %s PLL may lose lock", family_name);
                            vco_under = 1'b1;
                        end

                        $display ("Time: %0t  Instance: %m", $time);
                        if (inclk_out_of_range === 1'b1)
                        begin
                            // unlock
                            pll_is_locked = 0;
                            locked_tmp = 0;
                            cycles_to_lock = 0;
                            $display ("Note : %s PLL lost lock", family_name);
                            $display ("Time: %0t  Instance: %m", $time);
                            vco_period_was_phase_adjusted = 0;
                            phase_adjust_was_scheduled = 0;
                        end
                    end
                    else begin
                        if (no_warn == 1'b0)
                        begin
                            if (refclk_period/loop_xplier > i_vco_max)
                            begin
                                $display ("Warning : Input clock freq. is over VCO range. %s PLL may lose lock", family_name);
                                vco_over = 1'b1;
                            end
                            if (refclk_period/loop_xplier < i_vco_min)
                            begin
                                $display ("Warning : Input clock freq. is under VCO range. %s PLL may lose lock", family_name);
                                vco_under = 1'b1;
                            end
                            $display ("Time: %0t  Instance: %m", $time);
                            no_warn = 1'b1;
                        end
                    end
                    inclk_out_of_range = 1;
                end
                else begin
                    vco_over  = 1'b0;
                    vco_under = 1'b0;
                    inclk_out_of_range = 0;
                    no_warn = 1'b0;
                end

            end
            if (stop_vco == 1'b1)
            begin
                stop_vco = 0;
                schedule_vco = ~schedule_vco;
            end
            refclk_time = $time;
        end

        // Update M counter value on feedback clock edge
        
        if (fbclk == 1'b1 && fbclk_last_value !== fbclk)
        begin
            if (update_conf_latches === 1'b1)
            begin
                m_val[0] <= m_val_tmp[0];
                m_val[1] <= m_val_tmp[1];
            end
            if (!got_first_fbclk)
            begin
                got_first_fbclk = 1;
                first_fbclk_time = $time;
            end
            else
                fbclk_period = $time - fbclk_time;

            // need refclk_period here, so initialized to proper value above
            if ( ( ($time - refclk_time > 1.5 * refclk_period) && pfdena_wire === 1'b1 && pll_is_locked === 1'b1) ||
                ( ($time - refclk_time > 5 * refclk_period) && (pfdena_wire === 1'b1) && (pll_has_just_been_reconfigured == 0) ) ||
                ( ($time - refclk_time > 50 * refclk_period) && (pfdena_wire === 1'b1) && (pll_has_just_been_reconfigured == 1) ) )
            begin
                stop_vco = 1;
                // reset
                got_first_refclk = 0;
                got_first_fbclk = 0;
                got_second_refclk = 0;
                if (pll_is_locked == 1'b1)
                begin
                    pll_is_locked = 0;
                    locked_tmp = 0;
                    $display ("Note : %s PLL lost lock due to loss of input clock or the input clock is not detected within the allowed time frame.", family_name);
                    if ((i_vco_max == 0) && (i_vco_min == 0))
                        $display ("Note : Please run timing simulation to check whether the input clock is operating within the supported VCO range or not.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
                cycles_to_lock = 0;
                cycles_to_unlock = 0;
                first_schedule = 1;
                vco_period_was_phase_adjusted = 0;
                phase_adjust_was_scheduled = 0;
                tap0_is_active = 0;
                for (x = 0; x <= 7; x=x+1)
                    vco_tap[x] <= 1'b0;
            end
            fbclk_time = $time;
        end
        
                
        // Core lock functionality
        
        if (got_second_refclk && pfdena_wire === 1'b1 && (!inclk_out_of_range))
        begin
            // now we know actual incoming period
            if (abs(fbclk_time - refclk_time) <= lock_window || (got_first_fbclk && abs(refclk_period - abs(fbclk_time - refclk_time)) <= lock_window))
            begin
                // considered in phase
                if (cycles_to_lock == real_lock_high)
                begin
                    if (pll_is_locked === 1'b0)
                    begin
                        $display (" Note : %s PLL locked to incoming clock", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    pll_is_locked = 1;
                    locked_tmp = 1;
                    cycles_to_unlock = 0;
                end
                // increment lock counter only if the second part of the above
                // time check is not true
                if (!(abs(refclk_period - abs(fbclk_time - refclk_time)) <= lock_window))
                begin
                    cycles_to_lock = cycles_to_lock + 1;
                end

                // adjust m_times_vco_period
                new_m_times_vco_period = refclk_period;

            end else
            begin
                // if locked, begin unlock
                if (pll_is_locked)
                begin
                    cycles_to_unlock = cycles_to_unlock + 1;
                    if (cycles_to_unlock == lock_low)
                    begin
                        pll_is_locked = 0;
                        locked_tmp = 0;
                        cycles_to_lock = 0;
                        $display ("Note : %s PLL lost lock", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
                        vco_period_was_phase_adjusted = 0;
                        phase_adjust_was_scheduled = 0;
                        got_first_refclk = 0;
                        got_first_fbclk = 0;
                        got_second_refclk = 0;
                    end
                end
                if (abs(refclk_period - fbclk_period) <= 2)
                begin
                    // frequency is still good
                    if ($time == fbclk_time && (!phase_adjust_was_scheduled))
                    begin
                        if (abs(fbclk_time - refclk_time) > refclk_period/2)
                        begin
                            new_m_times_vco_period = abs(m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time)));
                            vco_period_was_phase_adjusted = 1;
                        end else
                        begin
                            new_m_times_vco_period = abs(m_times_vco_period - abs(fbclk_time - refclk_time));
                            vco_period_was_phase_adjusted = 1;
                        end
                    end
                end else
                begin
                    new_m_times_vco_period = refclk_period;
                    phase_adjust_was_scheduled = 0;
                end
            end
        end

        if (reconfig_err == 1'b1)
        begin
            locked_tmp = 0;
        end

        refclk_last_value = refclk;
        fbclk_last_value = fbclk;
    end

    assign clk_tmp[0] = i_clk0_counter == "c0" ? c0_clk : i_clk0_counter == "c1" ? c1_clk : i_clk0_counter == "c2" ? c2_clk : i_clk0_counter == "c3" ? c3_clk : i_clk0_counter == "c4" ? c4_clk : 1'b0;
    assign clk_tmp[1] = i_clk1_counter == "c0" ? c0_clk : i_clk1_counter == "c1" ? c1_clk : i_clk1_counter == "c2" ? c2_clk : i_clk1_counter == "c3" ? c3_clk : i_clk1_counter == "c4" ? c4_clk : 1'b0;
    assign clk_tmp[2] = i_clk2_counter == "c0" ? c0_clk : i_clk2_counter == "c1" ? c1_clk : i_clk2_counter == "c2" ? c2_clk : i_clk2_counter == "c3" ? c3_clk : i_clk2_counter == "c4" ? c4_clk : 1'b0;
    assign clk_tmp[3] = i_clk3_counter == "c0" ? c0_clk : i_clk3_counter == "c1" ? c1_clk : i_clk3_counter == "c2" ? c2_clk : i_clk3_counter == "c3" ? c3_clk : i_clk3_counter == "c4" ? c4_clk : 1'b0;
    assign clk_tmp[4] = i_clk4_counter == "c0" ? c0_clk : i_clk4_counter == "c1" ? c1_clk : i_clk4_counter == "c2" ? c2_clk : i_clk4_counter == "c3" ? c3_clk : i_clk4_counter == "c4" ? c4_clk : 1'b0;

assign clk_out_pfd[0] = (pfd_locked == 1'b1) ? clk_tmp[0] : 1'bx;
assign clk_out_pfd[1] = (pfd_locked == 1'b1) ? clk_tmp[1] : 1'bx;
assign clk_out_pfd[2] = (pfd_locked == 1'b1) ? clk_tmp[2] : 1'bx;
assign clk_out_pfd[3] = (pfd_locked == 1'b1) ? clk_tmp[3] : 1'bx;
assign clk_out_pfd[4] = (pfd_locked == 1'b1) ? clk_tmp[4] : 1'bx;

    assign clk_out[0] = (test_bypass_lock_detect == "on") ? clk_out_pfd[0] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[0] : 1'bx);
    assign clk_out[1] = (test_bypass_lock_detect == "on") ? clk_out_pfd[1] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[1] : 1'bx);
    assign clk_out[2] = (test_bypass_lock_detect == "on") ? clk_out_pfd[2] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[2] : 1'bx);
    assign clk_out[3] = (test_bypass_lock_detect == "on") ? clk_out_pfd[3] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[3] : 1'bx);
    assign clk_out[4] = (test_bypass_lock_detect == "on") ? clk_out_pfd[4] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[4] : 1'bx);

    // ACCELERATE OUTPUTS
    and (clk[0], 1'b1, clk_out[0]);
    and (clk[1], 1'b1, clk_out[1]);
    and (clk[2], 1'b1, clk_out[2]);
    and (clk[3], 1'b1, clk_out[3]);
    and (clk[4], 1'b1, clk_out[4]);

    and (scandataout, 1'b1, scandata_out);
    and (scandone, 1'b1, scandone_tmp);

assign fbout = fbclk;
assign vcooverrange  = (vco_range_detector_high_bits == -1) ? 1'bz : vco_over;
assign vcounderrange = (vco_range_detector_low_bits == -1) ? 1'bz :vco_under;
assign phasedone = ~update_phase;

endmodule // cycloneiiils_pll
//------------------------------------------------------------------
//
// Module Name : cycloneiiils_lcell_comb
//
// Description : Cyclone III LS LCELL_COMB Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_lcell_comb (
                             dataa, 
                             datab, 
                             datac, 
                             datad,
                             cin,
                             combout,
                             cout
                            );
   
input dataa;
input datab;
input datac;
input datad;
input cin;

output combout;
output cout;

parameter lut_mask = 16'hFFFF;
parameter sum_lutc_input = "datac";
 parameter dont_touch = "off";
parameter lpm_type = "cycloneiiils_lcell_comb";
   
reg cout_tmp;
reg combout_tmp;

reg [1:0] isum_lutc_input;
   
wire dataa_in;
wire datab_in;
wire datac_in;
wire datad_in;
wire cin_in;
   
buf (dataa_in, dataa);
buf (datab_in, datab);
buf (datac_in, datac);
buf (datad_in, datad);
buf (cin_in, cin);
   
specify
      
    (dataa => combout) = (0, 0) ;
    (datab => combout) = (0, 0) ;
    (datac => combout) = (0, 0) ;
    (datad => combout) = (0, 0) ;
    (cin => combout) = (0, 0) ;
              
    (dataa => cout) = (0, 0);
    (datab => cout) = (0, 0);
    (cin => cout) = (0, 0) ;
              
endspecify
   
// 4-input LUT function
function lut4;
input [15:0] mask;
input dataa;
input datab;
input datac;
input datad;
      
begin

    lut4 = datad ? ( datac ? ( datab ? ( dataa ? mask[15] : mask[14])
                                     : ( dataa ? mask[13] : mask[12]))
                           : ( datab ? ( dataa ? mask[11] : mask[10]) 
                                     : ( dataa ? mask[ 9] : mask[ 8])))
                 : ( datac ? ( datab ? ( dataa ? mask[ 7] : mask[ 6]) 
                                     : ( dataa ? mask[ 5] : mask[ 4]))
                           : ( datab ? ( dataa ? mask[ 3] : mask[ 2]) 
                                     : ( dataa ? mask[ 1] : mask[ 0])));

end
endfunction

initial
begin
    if (sum_lutc_input == "datac") 
        isum_lutc_input = 0;
    else if (sum_lutc_input == "cin") 
        isum_lutc_input = 1;
    else
    begin
        $display ("Error: Invalid sum_lutc_input specified\n");
        $display ("Time: %0t  Instance: %m", $time);
        isum_lutc_input = 2;
    end

end

always @(datad_in or datac_in or datab_in or dataa_in or cin_in)
begin
	
    if (isum_lutc_input == 0) // datac 
    begin
        combout_tmp = lut4(lut_mask, dataa_in, datab_in, 
                            datac_in, datad_in);
    end
    else if (isum_lutc_input == 1) // cin
    begin
        combout_tmp = lut4(lut_mask, dataa_in, datab_in, 
                            cin_in, datad_in);
    end

    cout_tmp = lut4(lut_mask, dataa_in, datab_in, cin_in, 'b0);
end

and (combout, combout_tmp, 1'b1) ;
and (cout, cout_tmp, 1'b1) ;
   
endmodule

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_ff
//
// Description : Cyclone III LS FF Verilog simulation model 
//
//------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module cycloneiiils_ff (
    d, 
    clk, 
    clrn, 
    aload, 
    sclr, 
    sload, 
    asdata, 
    ena, 
    devclrn, 
    devpor, 
    q
    );
   
parameter power_up = "low";
parameter x_on_violation = "on";
parameter lpm_type = "cycloneiiils_ff";

input d;
input clk;
input clrn;
input aload; 
input sclr; 
input sload; 
input asdata; 
input ena; 
input devclrn; 
input devpor; 

output q;

tri1 devclrn;
tri1 devpor;

reg q_tmp;
wire reset;
   
reg d_viol;
reg sclr_viol;
reg sload_viol;
reg asdata_viol;
reg ena_viol; 
reg violation;

reg clk_last_value;
   
reg ix_on_violation;

wire d_in;
wire clk_in;
wire clrn_in;
wire aload_in;
wire sclr_in;
wire sload_in;
wire asdata_in;
wire ena_in;
   
wire nosloadsclr;
wire sloaddata;

buf (d_in, d);
buf (clk_in, clk);
buf (clrn_in, clrn);
buf (aload_in, aload);
buf (sclr_in, sclr);
buf (sload_in, sload);
buf (asdata_in, asdata);
buf (ena_in, ena);
   
assign reset = devpor && devclrn && clrn_in && ena_in;
assign nosloadsclr = reset && (!sload_in && !sclr_in);
assign sloaddata = reset && sload_in;
   
specify

    $setuphold (posedge clk &&& nosloadsclr, d, 0, 0, d_viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
    $setuphold (posedge clk &&& sloaddata, asdata, 0, 0, asdata_viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
      
    (posedge clk => (q +: q_tmp)) = 0 ;
    (posedge clrn => (q +: 1'b0)) = (0, 0) ;
    (posedge aload => (q +: q_tmp)) = (0, 0) ;
    (asdata => q) = (0, 0) ;
      
endspecify
   
initial
begin
    violation = 'b0;
    clk_last_value = 'b0;

    if (power_up == "low")
        q_tmp = 'b0;
    else if (power_up == "high")
        q_tmp = 'b1;

    if (x_on_violation == "on")
        ix_on_violation = 1;
    else
        ix_on_violation = 0;
end
   
always @ (d_viol or sclr_viol or sload_viol or ena_viol or asdata_viol)
begin
    if (ix_on_violation == 1)
        violation = 'b1;
end
   
always @ (asdata_in or clrn_in or posedge aload_in or 
          devclrn or devpor)
begin
    if (devpor == 'b0)
        q_tmp <= 'b0;
    else if (devclrn == 'b0)
        q_tmp <= 'b0;
    else if (clrn_in == 'b0) 
        q_tmp <= 'b0;
    else if (aload_in == 'b1) 
        q_tmp <= asdata_in;
end
   
always @ (clk_in or posedge clrn_in or posedge aload_in or 
          devclrn or devpor or posedge violation)
begin
    if (violation == 1'b1)
    begin
        violation = 'b0;
        q_tmp <= 'bX;
    end
    else
    begin
        if (devpor == 'b0 || devclrn == 'b0 || clrn_in === 'b0)
            q_tmp <= 'b0;
        else if (aload_in === 'b1) 
            q_tmp <= asdata_in;
        else if (ena_in === 'b1 && clk_in === 'b1 && clk_last_value === 'b0)
        begin
            if (sclr_in === 'b1)
                q_tmp <= 'b0 ;
            else if (sload_in === 'b1)
                q_tmp <= asdata_in;
            else 
                q_tmp <= d_in;
        end
    end

    clk_last_value = clk_in;
end

and (q, q_tmp, 1'b1);

endmodule


//--------------------------------------------------------------------------
// Module Name     : cycloneiiils_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_ram_pulse_generator (
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
// Module Name     : cycloneiiils_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_ram_register (
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
// Module Name     : cycloneiiils_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module cycloneiiils_ram_block
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
     portabyteenamasks,
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     portadataout,
     portbdataout
     );
// -------- GLOBAL PARAMETERS ---------
parameter operation_mode = "single_port";
parameter mixed_port_feed_through_mode = "dont_care";
parameter ram_block_type = "auto";
parameter logical_ram_name = "ram_name";

parameter init_file = "init_file.hex";
parameter init_file_layout = "none";

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
parameter lpm_type = "cycloneiiils_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

 parameter mem_init0 = 2048'b0;
 parameter mem_init1 = 2048'b0;
 parameter mem_init2 = 2048'b0;
 parameter mem_init3 = 2048'b0;
 parameter mem_init4 = 2048'b0;

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;
parameter safe_write = "err_on_2clk";
parameter init_file_restructured = "unused";

parameter clk0_input_clock_enable  = "none"; // ena0,ena2,none
parameter clk0_core_clock_enable   = "none"; // ena0,ena2,none
parameter clk0_output_clock_enable = "none"; // ena0,none
parameter clk1_input_clock_enable  = "none"; // ena1,ena3,none
parameter clk1_core_clock_enable   = "none"; // ena1,ena3,none
parameter clk1_output_clock_enable = "none"; // ena1,none

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_address_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";
parameter port_a_read_enable_clock = "clock0";

// SIMULATION_ONLY_PARAMETERS_END

// LOCAL_PARAMETERS_BEGIN

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
 parameter delay_write_pulse_a = (hw_write_mode_a != "FW") ? 1'b1 : 1'b0;
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

input devclrn,devpor;
input portaaddrstall;
input portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;


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

tri0 portaaddrstall_int;
assign portaaddrstall_int = portaaddrstall;
tri0 portbaddrstall_int;
assign portbaddrstall_int = portbaddrstall;
tri1 devclrn;
tri1 devpor;


// -------- INTERNAL signals ---------
// clock / clock enable
wire clk_a_in,clk_a_byteena,clk_a_out,clkena_a_out;
wire clk_a_rena, clk_a_wena;
wire clk_a_core;
wire clk_b_in,clk_b_byteena,clk_b_out,clkena_b_out;
wire clk_b_rena, clk_b_wena;
wire clk_b_core;

wire write_cycle_a,write_cycle_b;

// asynch clear
wire datain_a_clr,dataout_a_clr,datain_b_clr,dataout_b_clr;
wire dataout_a_clr_reg, dataout_b_clr_reg;
 wire dataout_a_clr_reg_latch, dataout_b_clr_reg_latch;

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
wire [port_b_data_width - 1:0] datain_b_reg, dataout_b_reg;
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
        mem_init = {
            mem_init4  , mem_init3  , mem_init2  ,
            mem_init1  , mem_init0
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

assign clk_a_in      = clk0_int;
assign clk_a_wena = (port_a_write_enable_clock == "none") ? 1'b0 : clk_a_in;
assign clk_a_rena = (port_a_read_enable_clock  == "none") ? 1'b0 : clk_a_in;
assign clk_a_byteena = (port_a_byte_enable_clock == "none") ? 1'b0 : clk_a_in;
assign clk_a_out     = (port_a_data_out_clock == "none")    ? 1'b0 : (
                       (port_a_data_out_clock == "clock0")  ? clk0_int : clk1_int);

assign clk_b_in      = (port_b_address_clock == "clock0") ? clk0_int : clk1_int;
assign clk_b_byteena = (port_b_byte_enable_clock == "none")   ? 1'b0 : (
                       (port_b_byte_enable_clock == "clock0") ? clk0_int : clk1_int);
assign clk_b_wena = (port_b_write_enable_clock == "none")   ? 1'b0 : (
                    (port_b_write_enable_clock == "clock0") ? clk0_int : clk1_int);
assign clk_b_rena = (port_b_read_enable_clock  == "none")   ? 1'b0 : (
                    (port_b_read_enable_clock  == "clock0") ? clk0_int : clk1_int);

assign clk_b_out     = (port_b_data_out_clock == "none")      ? 1'b0 : (
                       (port_b_data_out_clock == "clock0")    ? clk0_int : clk1_int);

assign addr_a_clr_in = (port_a_address_clear == "none")   ? 1'b0 : clr0_int;
assign addr_b_clr_in = (port_b_address_clear == "none")   ? 1'b0 : (
                       (port_b_address_clear == "clear0") ? clr0_int : clr1_int);

assign datain_a_clr_in = 1'b0;
 assign dataout_a_clr    = (port_a_data_out_clock == "none") ?  (
                                        (port_a_data_out_clear == "none")   ? 1'b0 : (
                                        (port_a_data_out_clear == "clear0") ? clr0_int : clr1_int)) : 1'b0;
 assign dataout_a_clr_reg = (port_a_data_out_clear == "none")   ? 1'b0 : (
                            (port_a_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign datain_b_clr_in = 1'b0;
 assign dataout_b_clr    = (port_b_data_out_clock == "none") ?  (
                           (port_b_data_out_clear == "none")   ? 1'b0 : (
                           (port_b_data_out_clear == "clear0") ? clr0_int : clr1_int)) : 1'b0;
 assign dataout_b_clr_reg = (port_b_data_out_clear == "none")   ? 1'b0 : (
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


assign active_write_a = (byteena_a_reg !== 'b0);


assign active_write_b = (byteena_b_reg !== 'b0);

// Store core clock enable value for delayed write
// port A core active
cycloneiiils_ram_register active_core_port_a (
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
cycloneiiils_ram_register active_core_port_b (
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
cycloneiiils_ram_register we_a_register (
        .d(mode_is_rom ? 1'b0 : portawe_int),
        .clk(clk_a_wena),
        .aclr(we_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(active_a_in),
        .q(we_a_reg),
        .aclrout(we_a_clr)
        );
defparam we_a_register.width = 1;

// read enable
cycloneiiils_ram_register re_a_register (
        .d(portare_int),
        .clk(clk_a_rena),
        .aclr(re_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
                  .ena(active_a_in),
        .q(re_a_reg),
        .aclrout(re_a_clr)
        );

// address
cycloneiiils_ram_register addr_a_register (
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
cycloneiiils_ram_register datain_a_register (
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
cycloneiiils_ram_register byteena_a_register (
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
defparam byteena_a_register.preset = 1'b1;

// ------- B input registers -------

// write enable

cycloneiiils_ram_register we_b_register (
        .d(portbwe_int),
        .clk(clk_b_wena),
        .aclr(we_b_clr_in),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
               .ena(active_b_in),
        .q(we_b_reg),
        .aclrout(we_b_clr)
        );
defparam we_b_register.width = 1;
defparam we_b_register.preset = 1'b0;

// read enable

cycloneiiils_ram_register re_b_register (
        .d(portbre_int),
        .clk(clk_b_rena),
        .aclr(re_b_clr_in),
        .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
                  .ena(active_b_in),
        .q(re_b_reg),
        .aclrout(re_b_clr)
        );
defparam re_b_register.width = 1;
defparam re_b_register.preset = 1'b0;



// address
cycloneiiils_ram_register addr_b_register (
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
cycloneiiils_ram_register datain_b_register (
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
cycloneiiils_ram_register byteena_b_register (
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
defparam byteena_b_register.preset = 1'b1;

assign datain_prime_reg = (primary_port_is_a) ? datain_a_reg : datain_b_reg;
assign addr_prime_reg   = (primary_port_is_a) ? addr_a_reg   : addr_b_reg;

assign datain_sec_reg   = (primary_port_is_a) ? datain_b_reg : datain_a_reg;
assign addr_sec_reg     = (primary_port_is_a) ? addr_b_reg   : addr_a_reg;

assign mask_vector_prime     = (primary_port_is_a) ? mask_vector_a     : mask_vector_b;
assign mask_vector_prime_int = (primary_port_is_a) ? mask_vector_a_int :  mask_vector_b_int;

assign mask_vector_sec       = (primary_port_is_a) ? mask_vector_b     : mask_vector_a;
assign mask_vector_sec_int   = (primary_port_is_a) ? mask_vector_b_int : mask_vector_a_int;

// Hardware Write Modes
// CYCLONEIIILS
// Write pulse generation
cycloneiiils_ram_pulse_generator wpgen_a (
       .clk(clk_a_in),
       .ena(active_a_core & active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );
defparam wpgen_a.delay_pulse = delay_write_pulse_a;

cycloneiiils_ram_pulse_generator wpgen_b (
       .clk(clk_b_in),
       .ena(active_b_core & active_write_b & mode_is_bdp & we_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );
defparam wpgen_b.delay_pulse = delay_write_pulse_b;

// Read pulse generation
cycloneiiils_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
       .ena(active_a_core & re_a_reg & ~we_a_reg & ~dataout_a_clr),
        .pulse(read_pulse_a),
       .cycle(clk_a_core)
        );

cycloneiiils_ram_pulse_generator rpgen_b (
        .clk(clk_b_in),
       .ena((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg & ~we_b_reg & ~dataout_b_clr),
        .pulse(read_pulse_b),
       .cycle(clk_b_core)
        );

// Read during write pulse generation
cycloneiiils_ram_pulse_generator rwpgen_a (
    .clk(clk_a_in),
          .ena(active_a_core & re_a_reg & we_a_reg & read_before_write_a & ~dataout_a_clr),
    .pulse(rw_pulse_a),.cycle()
);

cycloneiiils_ram_pulse_generator rwpgen_b (
    .clk(clk_b_in),
     .ena(active_b_core & mode_is_bdp & re_b_reg & we_b_reg & read_before_write_b & ~dataout_b_clr),
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
always @(byteena_a_reg)
begin
    for (i = 0; i < port_a_data_width; i = i + 1)
    begin
        mask_vector_a[i]     = (byteena_a_reg[i/byte_size_a] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_a_int[i] = (byteena_a_reg[i/byte_size_a] === 1'b0) ? 1'b0 : 1'bx;
    end
end

always @(byteena_b_reg)
begin
    for (l = 0; l < port_b_data_width; l = l + 1)
    begin
        mask_vector_b[l]     = (byteena_b_reg[l/byte_size_b] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_b_int[l] = (byteena_b_reg[l/byte_size_b] === 1'b0) ? 1'b0 : 1'bx;
    end
end

 // Latch Clear port A
 always @(posedge dataout_a_clr)
 begin
     if (primary_port_is_a) begin read_data_latch = 'b0; dataout_a = 'b0; end
     else                   begin read_unit_data_latch = 'b0; dataout_a = 'b0; end
 end


 // Latch Clear port B
 always @(posedge dataout_b_clr)
 begin
     if (primary_port_is_b) begin read_data_latch = 'b0; dataout_b = 'b0; end
     else                   begin read_unit_data_latch = 'b0; dataout_b = 'b0; end
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
cycloneiiils_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in),
                    .ena(active_a_core & ~mode_is_dp & ~old_data_write_a & we_a_reg & re_a_reg & ~dataout_a_clr),
        .pulse(read_pulse_a_feedthru),.cycle()
        );

cycloneiiils_ram_pulse_generator ftpgen_b (
        .clk(clk_b_in),
                    .ena(active_b_core & mode_is_bdp & ~old_data_write_b & we_b_reg & re_b_reg & ~dataout_b_clr),
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
 else if (active_a_core & re_a_reg & ~dataout_a_clr & ~dataout_a_clr_reg_latch)

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
       else if ((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg & ~dataout_b_clr & ~dataout_b_clr_reg_latch)
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
 cycloneiiils_ram_register aclr__a__mux_register (
        .d(dataout_a_clr),
        .clk(clk_a_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(1'b1),
        .q(dataout_a_clr_reg_latch),.aclrout()
        );
 // port B
 cycloneiiils_ram_register aclr__b__mux_register (
        .d(dataout_b_clr),
        .clk(clk_b_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(1'b1),
        .q(dataout_b_clr_reg_latch),.aclrout()
        );


// ------- Output registers --------

assign clkena_a_out = (port_a_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

cycloneiiils_ram_register dataout_a_register (
        .d(dataout_a),
        .clk(clk_a_out),
        .aclr(dataout_a_clr_reg),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(clkena_a_out),
        .q(dataout_a_reg),.aclrout()
        );
defparam dataout_a_register.width = port_a_data_width;

 assign portadataout = (out_a_is_reg) ? dataout_a_reg : dataout_a;


assign clkena_b_out = (port_b_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

cycloneiiils_ram_register dataout_b_register (
        .d( dataout_b ),
        .clk(clk_b_out),
        .aclr(dataout_b_clr_reg),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(dataout_b_reg),.aclrout()
        );
defparam dataout_b_register.width = port_b_data_width;

 assign portbdataout = (out_b_is_reg) ? dataout_b_reg : dataout_b;


endmodule // cycloneiiils_ram_block




//---------------------------------------------------------------------
//
// Module Name : cycloneiiils_mac_data_reg
//
// Description : Simulation model for the data input register of 
//               Cyclone III LS MAC_MULT
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module cycloneiiils_mac_data_reg (clk,
                               data,
                               ena,
                               aclr,
                               dataout
                              );

    parameter data_width = 18;

    // INPUT PORTS
    input clk;
    input [17 : 0] data;
    input ena;
    input aclr;

    // OUTPUT PORTS
    output [17:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg clk_last_value;
    reg [17:0] dataout_tmp;
    wire [17:0] dataout_wire;

    // INTERNAL VARIABLES
    wire [17:0] data_ipd; 
    wire enable;
    wire no_clr;
    reg d_viol;
    reg ena_viol;
    wire clk_ipd;
    wire ena_ipd;
    wire aclr_ipd;

 
    // BUFFER INPUTS
    buf (clk_ipd, clk);
    buf (ena_ipd, ena);
    buf (aclr_ipd, aclr);

    buf (data_ipd[0], data[0]);
    buf (data_ipd[1], data[1]);
    buf (data_ipd[2], data[2]);
    buf (data_ipd[3], data[3]);
    buf (data_ipd[4], data[4]);
    buf (data_ipd[5], data[5]);
    buf (data_ipd[6], data[6]);
    buf (data_ipd[7], data[7]);
    buf (data_ipd[8], data[8]);
    buf (data_ipd[9], data[9]);
    buf (data_ipd[10], data[10]);
    buf (data_ipd[11], data[11]);
    buf (data_ipd[12], data[12]);
    buf (data_ipd[13], data[13]);
    buf (data_ipd[14], data[14]);
    buf (data_ipd[15], data[15]);
    buf (data_ipd[16], data[16]);
    buf (data_ipd[17], data[17]);

    assign enable = (!aclr_ipd) && (ena_ipd);
    assign no_clr = (!aclr_ipd);

    // TIMING PATHS
    specify
        $setuphold (posedge clk &&& enable, data, 0, 0, d_viol);
        $setuphold (posedge clk &&& no_clr, ena, 0, 0, ena_viol);

        (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
        (posedge aclr => (dataout +: 1'b0)) = (0, 0);

    endspecify

    initial
    begin
        clk_last_value <= 'b0;
        dataout_tmp <= 18'b0;
    end

    always @(clk_ipd or aclr_ipd)
    begin
        if (d_viol == 1'b1 || ena_viol == 1'b1)
        begin
            dataout_tmp <= 'bX;
        end
        else if (aclr_ipd == 1'b1)
        begin
            dataout_tmp <= 'b0;
        end
        else 
        begin
            if ((clk_ipd === 1'b1) && (clk_last_value == 1'b0))
                if (ena_ipd === 1'b1)
                    dataout_tmp <= data_ipd;
        end

        clk_last_value <= clk_ipd;

    end // always

    assign dataout_wire = dataout_tmp;
      
    and (dataout[0], dataout_wire[0], 1'b1);
    and (dataout[1], dataout_wire[1], 1'b1);
    and (dataout[2], dataout_wire[2], 1'b1);
    and (dataout[3], dataout_wire[3], 1'b1);
    and (dataout[4], dataout_wire[4], 1'b1);
    and (dataout[5], dataout_wire[5], 1'b1);
    and (dataout[6], dataout_wire[6], 1'b1);
    and (dataout[7], dataout_wire[7], 1'b1);
    and (dataout[8], dataout_wire[8], 1'b1);
    and (dataout[9], dataout_wire[9], 1'b1);
    and (dataout[10], dataout_wire[10], 1'b1);
    and (dataout[11], dataout_wire[11], 1'b1);
    and (dataout[12], dataout_wire[12], 1'b1);
    and (dataout[13], dataout_wire[13], 1'b1);
    and (dataout[14], dataout_wire[14], 1'b1);
    and (dataout[15], dataout_wire[15], 1'b1);
    and (dataout[16], dataout_wire[16], 1'b1);
    and (dataout[17], dataout_wire[17], 1'b1);

endmodule //cycloneiiils_mac_data_reg

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_mac_sign_reg
//
// Description : Simulation model for the sign input register of 
//               Cyclone III LS MAC_MULT
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module cycloneiiils_mac_sign_reg (
                               clk,
                               d,
                               ena,
                               aclr,
                               q
                              );

    // INPUT PORTS
    input clk;
    input d;
    input ena;
    input aclr;
    
    // OUTPUT PORTS
    output q;
    
    // INTERNAL VARIABLES
    reg clk_last_value;
    reg q_tmp;
    reg ena_viol;
    reg d_viol;
    
    wire enable;
    
    // DEFAULT VALUES THRO' PULLUPs
    tri1 aclr, ena;
    
    wire d_ipd;
    wire clk_ipd;
    wire ena_ipd;
    wire aclr_ipd;
    
    buf (d_ipd, d);
    buf (clk_ipd, clk);
    buf (ena_ipd, ena);
    buf (aclr_ipd, aclr);
    
    assign enable = (!aclr_ipd) && (ena_ipd);
    
    specify
    
        $setuphold (posedge clk &&& enable, d, 0, 0, d_viol) ;
        $setuphold (posedge clk &&& enable, ena, 0, 0, ena_viol) ;
          
        (posedge clk => (q +: q_tmp)) = 0 ;
        (posedge aclr => (q +: 1'b0)) = 0 ;
          
    endspecify

    initial
    begin
        clk_last_value <= 'b0;
        q_tmp <= 'b0;
    end
    
        always @ (clk_ipd or aclr_ipd)
        begin
            if (d_viol == 1'b1 || ena_viol == 1'b1)
            begin
                q_tmp <= 'bX;
            end
            else
            begin
            if (aclr_ipd == 1'b1)
                q_tmp <= 0;
            else if ((clk_ipd == 1'b1) && (clk_last_value == 1'b0))
                if (ena_ipd == 1'b1)
                    q_tmp <= d_ipd;
            end
    
            clk_last_value <= clk_ipd;
        end
    
    and (q, q_tmp, 'b1);

endmodule // cycloneiiils_mac_sign_reg

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_mac_mult_internal
//
// Description : Cyclone III LS MAC_MULT_INTERNAL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_mac_mult_internal
   (
    dataa, 
    datab,
    signa, 
    signb,
    dataout
    );
    
    parameter dataa_width    = 18;
    parameter datab_width    = 18;
    parameter dataout_width  = dataa_width + datab_width;
    
    // INPUT
    input [dataa_width-1:0] dataa;
    input [datab_width-1:0] datab;
    input 	signa;
    input 	signb;
 
    // OUTPUT
    output [dataout_width-1:0] dataout;

    // Internal variables
    wire [17:0] dataa_ipd; 
    wire [17:0] datab_ipd;
    wire signa_ipd; 
    wire signb_ipd;

    wire [dataout_width-1:0] dataout_tmp; 
 
    wire ia_is_positive;
    wire ib_is_positive;
    wire [17:0] iabsa;		// absolute value (i.e. positive) form of dataa input
    wire [17:0] iabsb;		// absolute value (i.e. positive) form of datab input
    wire [35:0] iabsresult;	// absolute value (i.e. positive) form of product (a * b)
 
    
    reg [17:0] i_ones;		// padding with 1's for input negation

    // Input buffers
    buf (signa_ipd, signa);
    buf (signb_ipd, signb);

    buf dataa_buf [dataa_width-1:0] (dataa_ipd[dataa_width-1:0], dataa);
    buf datab_buf [datab_width-1:0] (datab_ipd[datab_width-1:0], datab);

    specify
        (dataa *> dataout) = (0, 0);
        (datab *> dataout) = (0, 0);
        (signa *> dataout) = (0, 0);
        (signb *> dataout) = (0, 0);
    endspecify

    initial
    begin
        // 1's padding for 18-bit wide inputs
        i_ones = ~0;
    end
    
    // get signs of a and b, and get absolute values since Verilog '*' operator
    // is an unsigned multiplication
    assign ia_is_positive = ~signa_ipd | ~dataa_ipd[dataa_width-1];
    assign ib_is_positive = ~signb_ipd | ~datab_ipd[datab_width-1];
 
    assign iabsa = ia_is_positive == 1 ? dataa_ipd[dataa_width-1:0] : -(dataa_ipd | (i_ones << dataa_width));
    assign iabsb = ib_is_positive == 1 ? datab_ipd[datab_width-1:0] : -(datab_ipd | (i_ones << datab_width));
 
    // multiply a * b
    assign iabsresult = iabsa * iabsb;
    assign dataout_tmp = (ia_is_positive ^ ib_is_positive) == 1 ? -iabsresult : iabsresult;
 
    buf dataout_buf [dataout_width-1:0] (dataout, dataout_tmp);

endmodule

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_mac_mult
//
// Description : Cyclone III LS MAC_MULT Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_mac_mult	
   (
    dataa, 
    datab,
    signa, 
    signb,
    clk, 
    aclr, 
    ena,
    dataout,
    devclrn,
    devpor
    );
    
    parameter dataa_width    = 18;
    parameter datab_width    = 18;
    parameter dataa_clock	= "none";
    parameter datab_clock	= "none";
    parameter signa_clock	= "none"; 
    parameter signb_clock	= "none";
    parameter lpm_hint       = "true";
    parameter lpm_type       = "cycloneiiils_mac_mult";
    
// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter dataout_width  = dataa_width + datab_width;

// SIMULATION_ONLY_PARAMETERS_END

    input [dataa_width-1:0] dataa;
    input [datab_width-1:0] datab;
    input 	signa;
    input 	signb;
    input clk;
    input aclr;
    input ena;
    input 	devclrn;
    input 	devpor;
 
    output [dataout_width-1:0] dataout;
    
    tri1 devclrn;
    tri1 devpor;

    wire [dataout_width-1:0] dataout_tmp; 
 
    wire [17:0] idataa_reg;	// optional register for dataa input
    wire [17:0] idatab_reg;	// optional register for datab input
    wire [17:0] dataa_pad;	// padded dataa input
    wire [17:0] datab_pad;	// padded datab input
    wire isigna_reg;			// optional register for signa input
    wire isignb_reg;			// optional register for signb input
    
    wire [17:0] idataa_int;	// dataa as seen by the multiplier input
    wire [17:0] idatab_int;	// datab as seen by the multiplier input
    wire isigna_int;			// signa as seen by the multiplier input
    wire isignb_int;			// signb as seen by the multiplier input
 
    wire ia_is_positive;
    wire ib_is_positive;
    wire [17:0] iabsa;		// absolute value (i.e. positive) form of dataa input
    wire [17:0] iabsb;		// absolute value (i.e. positive) form of datab input
    wire [35:0] iabsresult;	// absolute value (i.e. positive) form of product (a * b)
 
    wire dataa_use_reg;		// equivalent to dataa_clock parameter
    wire datab_use_reg;		// equivalent to datab_clock parameter
    wire signa_use_reg;		// equivalent to signa_clock parameter
    wire signb_use_reg;		// equivalent to signb_clock parameter
    
    reg [17:0] i_ones;		// padding with 1's for input negation

    wire reg_aclr;

    assign reg_aclr = (!devpor) || (!devclrn) || (aclr);

    // optional registering parameters
    assign dataa_use_reg = (dataa_clock != "none") ? 1'b1 : 1'b0;
    assign datab_use_reg = (datab_clock != "none") ? 1'b1 : 1'b0;
    assign signa_use_reg = (signa_clock != "none") ? 1'b1 : 1'b0;
    assign signb_use_reg = (signb_clock != "none") ? 1'b1 : 1'b0;
    assign dataa_pad = ((18-dataa_width) == 0) ? dataa : {{(18-dataa_width){1'b0}},dataa};
    assign datab_pad = ((18-datab_width) == 0) ? datab : {{(18-datab_width){1'b0}},datab};
       
    initial
    begin
        // 1's padding for 18-bit wide inputs
        i_ones = ~0;
    end
    
    // Optional input registers for dataa,b and signa,b
    cycloneiiils_mac_data_reg dataa_reg (
                                      .clk(clk),
                                      .data(dataa_pad),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .dataout(idataa_reg)
                                     );
        defparam dataa_reg.data_width = dataa_width;

    cycloneiiils_mac_data_reg datab_reg (
                                      .clk(clk),
                                      .data(datab_pad),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .dataout(idatab_reg)
                                     );
        defparam datab_reg.data_width = datab_width;

    cycloneiiils_mac_sign_reg signa_reg (
                                      .clk(clk),
                                      .d(signa),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .q(isigna_reg)
                                     );

    cycloneiiils_mac_sign_reg signb_reg (
                                      .clk(clk),
                                      .d(signb),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .q(isignb_reg)
                                     );

    // mux input sources from direct inputs or optional registers
    assign idataa_int = dataa_use_reg == 1'b1 ? idataa_reg : dataa;
    assign idatab_int = datab_use_reg == 1'b1 ? idatab_reg : datab;
    assign isigna_int = signa_use_reg == 1'b1 ? isigna_reg : signa;
    assign isignb_int = signb_use_reg == 1'b1 ? isignb_reg : signb;
 
    cycloneiiils_mac_mult_internal mac_multiply (
                                              .dataa(idataa_int[dataa_width-1:0]),
                                              .datab(idatab_int[datab_width-1:0]),
                                              .signa(isigna_int), 
                                              .signb(isignb_int),
                                              .dataout(dataout)
                                             );
        defparam mac_multiply.dataa_width = dataa_width;
        defparam mac_multiply.datab_width = datab_width;
        defparam mac_multiply.dataout_width = dataout_width;

endmodule


//------------------------------------------------------------------
//
// Module Name : cycloneiiils_mac_out
//
// Description : Cyclone III LS MAC_OUT Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
module cycloneiiils_mac_out	
   (
    dataa, 
    clk,
    aclr,
    ena,
    dataout,
    devclrn,
    devpor
    );
 
    parameter dataa_width   = 1;
    parameter output_clock  = "none";
    parameter lpm_hint      = "true";
    parameter lpm_type      = "cycloneiiils_mac_out";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter dataout_width = dataa_width;

// SIMULATION_ONLY_PARAMETERS_END
    
    input [dataa_width-1:0] dataa;
    input clk;
    input aclr;
    input ena;
    input 	devclrn;
    input 	devpor;
    output [dataout_width-1:0] dataout; 
    
    tri1 devclrn;
    tri1 devpor;

    wire [dataa_width-1:0] dataa_ipd; // internal dataa
    wire clk_ipd; // internal clk
    wire aclr_ipd; // internal aclr
    wire ena_ipd; // internal ena
 
    // internal variable
    wire [dataout_width-1:0] dataout_tmp;

    reg [dataa_width-1:0] idataout_reg; // optional register for dataout output
 
    wire use_reg; // equivalent to dataout_clock parameter
    
    wire enable;
    wire no_aclr;

    // Input buffers
    buf (clk_ipd, clk);
    buf (aclr_ipd, aclr);
    buf (ena_ipd, ena);

    buf dataa_buf [dataa_width-1:0] (dataa_ipd, dataa);

    // optional registering parameter
    assign use_reg = (output_clock != "none") ? 1 : 0;
    assign enable = (!aclr) && (ena) && use_reg;
    assign no_aclr = (!aclr) && use_reg;
       
    specify

        if (use_reg)
            (posedge clk => (dataout +: dataout_tmp)) = 0;
            (posedge aclr => (dataout +: 1'b0)) = 0;
        ifnone
            (dataa *> dataout) = (0, 0);
    
        $setuphold (posedge clk &&& enable, dataa, 0, 0);

        $setuphold (posedge clk &&& no_aclr, ena, 0, 0);

    endspecify

    initial
    begin
       // initial values for optional register
       idataout_reg = 0;
    end
 
    // Optional input registers for dataa,b and signa,b
    always @ (posedge clk_ipd or posedge aclr_ipd or negedge devclrn or negedge devpor)
    begin
       if (devclrn == 0 || devpor == 0 || aclr_ipd == 1)
       begin
          idataout_reg <= 0;
       end
       else if (ena_ipd == 1)
       begin
          idataout_reg <= dataa_ipd;
       end
    end
 
    // mux input sources from direct inputs or optional registers
    assign dataout_tmp = use_reg == 1 ? idataout_reg : dataa_ipd;
 
    // accelerate outputs
    buf dataout_buf [dataout_width-1:0] (dataout, dataout_tmp);

endmodule
//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    cycloneiiils_io_ibuf                                 //
//Description:                    Simulation model for Cyclone III LS IO Input Buffer    //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module cycloneiiils_io_ibuf (
                      i,
                      ibar,
                      o
                     );

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter differential_mode = "false";
parameter bus_hold = "false";
parameter simulate_z_as = "Z";
parameter lpm_type = "cycloneiiils_io_ibuf";

// SIMULATION_ONLY_PARAMETERS_END

//Input Ports Declaration
input i;
input ibar;

//Output Ports Declaration
output o;

// Internal signals
reg out_tmp;
reg o_tmp;
wire out_val ;
reg prev_value;

specify
    (i => o)    = (0, 0);
    (ibar => o) = (0, 0);
endspecify

initial
    begin
        prev_value = 1'b0;
    end

always@(i or ibar)
    begin
        if(differential_mode == "false")
            begin
                if(i == 1'b1)
                    begin
                        o_tmp = 1'b1;
                        prev_value = 1'b1;
                    end
                else if(i == 1'b0)
                    begin
                        o_tmp = 1'b0;
                        prev_value = 1'b0;
                    end
                else if( i === 1'bz)
                    o_tmp = out_val;
                else
                    o_tmp = i;
                    
                if( bus_hold == "true")
                    out_tmp = prev_value;
                else
                    out_tmp = o_tmp;
            end
        else
            begin
                case({i,ibar})
                    2'b00: out_tmp = 1'bX;
                    2'b01: out_tmp = 1'b0;
                    2'b10: out_tmp = 1'b1;
                    2'b11: out_tmp = 1'bX;
                    default: out_tmp = 1'bX;
                endcase

        end
    end
    
assign out_val = (simulate_z_as == "Z") ? 1'bz :
                 (simulate_z_as == "X") ? 1'bx :
                 (simulate_z_as == "vcc")? 1'b1 :
                 (simulate_z_as == "gnd") ? 1'b0 : 1'bz;

pmos (o, out_tmp, 1'b0);

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    cycloneiiils_io_obuf                                 //
//Description:                    Simulation model for Cyclone III LS IO Output Buffer   //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module cycloneiiils_io_obuf (
                      i,
                      oe,
                      seriesterminationcontrol,
                      devoe,
                      o,
                      obar
                    );

//Parameter Declaration
parameter open_drain_output = "false";
parameter bus_hold = "false";
parameter lpm_type = "cycloneiiils_io_obuf";

//Input Ports Declaration
input i;
input oe;
input devoe;
input [15:0] seriesterminationcontrol; 

//Outout Ports Declaration
output o;
output obar;

//INTERNAL Signals
reg out_tmp;
reg out_tmp_bar;
reg prev_value;
wire tmp;
wire tmp_bar;
wire tmp1;
wire tmp1_bar;

tri1 devoe;

specify
    (i => o)    = (0, 0);
    (i => obar) = (0, 0);
    (oe => o)   = (0, 0);
    (oe => obar)   = (0, 0);
endspecify

initial
    begin
        prev_value = 'b0;
        out_tmp = 'bz;
    end

always@(i or oe)
    begin
        if(oe == 1'b1)
            begin
                if(open_drain_output == "true")
                    begin
                        if(i == 'b0)
                             begin
                                 out_tmp = 'b0;
                                 out_tmp_bar = 'b1;
                                 prev_value = 'b0;
                             end
                        else
                             begin
                                 out_tmp = 'bz;
                                 out_tmp_bar = 'bz;
                             end
                    end
                else
                    begin
                        if( i == 'b0)
                            begin
                                out_tmp = 'b0;
                                out_tmp_bar = 'b1;
                                prev_value = 'b0;
                            end
                        else if( i == 'b1)
                            begin
                                out_tmp = 'b1;
                                out_tmp_bar = 'b0;
                                prev_value = 'b1;
                            end
                        else
                            begin
                                out_tmp = i;
                                out_tmp_bar = i;
                            end
                    end
            end
        else if(oe == 1'b0)
            begin
                out_tmp = 'bz;
                out_tmp_bar = 'bz;
            end
        else
            begin
                out_tmp = 'bx;
                out_tmp_bar = 'bx;
            end
    end

assign tmp = (bus_hold == "true") ? prev_value : out_tmp;
assign tmp_bar = (bus_hold == "true") ? !prev_value : out_tmp_bar;
assign tmp1 = (devoe == 1'b1) ? tmp : 1'bz; 
assign tmp1_bar = (devoe == 1'b1) ? tmp_bar : 1'bz; 



pmos (o, tmp1, 1'b0);
pmos (obar, tmp1_bar, 1'b0);

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    cycloneiiils_ddio_out                                //
//Description:                    Simulation model for Cyclone III LS DDIO Output        //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module cycloneiiils_ddio_out (
                        datainlo,
                        datainhi,
                        clk,
                        clkhi,
                        clklo,
                        muxsel,
                        ena,
                        areset,
                        sreset,
                        dataout,
                        dfflo,
                        dffhi,
                        devpor,
                        devclrn
                     );

//Parameters Declaration
parameter power_up = "low";
parameter async_mode = "none";
parameter sync_mode = "none";
parameter use_new_clocking_model = "false";
parameter lpm_type = "cycloneiiils_ddio_out";

//Input Ports Declaration
input datainlo;
input datainhi;
input clk;
input clkhi;
input clklo;
input muxsel;
input ena;
input areset;
input sreset;
input devpor;
input devclrn;

//Output Ports Declaration
output dataout;

//Buried Ports Declaration
output dfflo;
output dffhi ;

tri1 devclrn;
tri1 devpor;

//Internal Signals
reg ddioreg_aclr;
reg ddioreg_adatasdata;
reg ddioreg_sclr;
reg ddioreg_sload;
reg ddioreg_prn;
reg viol_notifier;

wire dfflo_tmp;
wire dffhi_tmp;
wire mux_sel;
wire sel_mux_hi_in;
wire clk_hi;
wire clk_lo;
wire datainlo_tmp;
wire datainhi_tmp;
reg dinhi_tmp;
reg dinlo_tmp;

reg clk1;
reg clk2;

reg muxsel1;
reg muxsel2;
reg muxsel_tmp;
reg sel_mux_lo_in_tmp;
reg sel_mux_hi_in_tmp;   
reg dffhi_tmp1;  
wire muxsel3;
wire clk3;
wire sel_mux_lo_in;

initial
begin
	ddioreg_aclr = 1'b1;
	ddioreg_prn = 1'b1;
	ddioreg_adatasdata = (sync_mode == "preset") ? 1'b1: 1'b0;
    ddioreg_sclr = 1'b0;
    ddioreg_sload = 1'b0;
end


assign dfflo = dfflo_tmp;
assign dffhi = dffhi_tmp; 

always@(clk)
begin
    clk1 = clk;
    clk2 <= clk1;
end

always@(muxsel)
begin
    muxsel1 = muxsel;
    muxsel2 <= muxsel1;
end

always@(dfflo_tmp)
begin
    sel_mux_lo_in_tmp <= dfflo_tmp;
end

always@(datainlo)
begin
    dinlo_tmp <= datainlo;
end

always@(datainhi)
begin
    dinhi_tmp <= datainhi;
end

always @(mux_sel) begin		
   muxsel_tmp <= mux_sel;		
end

always@(dffhi_tmp)                      
begin                                   
    dffhi_tmp1 <= dffhi_tmp;            
end                                     
                                        
always@(dffhi_tmp1)                     
begin                                   
    sel_mux_hi_in_tmp <= dffhi_tmp1;    
end                                     


always@(areset)
begin
        if(async_mode == "clear")
            begin
                ddioreg_aclr = !areset;
            end
        else if(async_mode == "preset")
            begin
                ddioreg_prn = !areset;
            end
end

always@(sreset )
begin
         if(sync_mode == "clear")
            begin
                ddioreg_sclr = sreset;
            end
        else if(sync_mode == "preset")
            begin
                ddioreg_sload = sreset;
            end
end

//DDIO HIGH Register

cycloneiiils_latch  ddioreg_hi(                          
                            .D(datainhi_tmp),          
                            .ENA(!clk_hi & ena),             
                            .PRE(ddioreg_prn),         
                            .CLR(ddioreg_aclr),        
                            .Q(dffhi_tmp)              
                            );                         

assign clk_hi = (use_new_clocking_model == "true") ?  clkhi : clk;
assign datainhi_tmp =  (ddioreg_sclr == 1'b0 && ddioreg_sload == 1'b1)? 1'b1 : (ddioreg_sclr == 1'b1 && ddioreg_sload == 1'b0)? 1'b0: dinhi_tmp;       

//DDIO Low Register
dffeas  ddioreg_lo(
                   .d(datainlo_tmp),
                   .clk(clk_lo),
                   .clrn(ddioreg_aclr),
                   .aload(1'b0),
                   .sclr(ddioreg_sclr),
                   .sload(ddioreg_sload),
                   .asdata(ddioreg_adatasdata),
                   .ena(ena),
                   .prn(ddioreg_prn),
                   .q(dfflo_tmp),
                   .devpor(devpor),
                   .devclrn(devclrn)
                  );
defparam ddioreg_lo.power_up = power_up;
assign clk_lo = (use_new_clocking_model == "true") ?  clklo : clk;
assign datainlo_tmp = dinlo_tmp;

//DDIO High Register

//registered output selection
cycloneiiils_mux21 sel_mux(
                    .MO(dataout),
                    .A(sel_mux_hi_in),
                    .B(sel_mux_lo_in),
                    .S(!muxsel_tmp)
                   );

assign muxsel3 = muxsel2;
assign clk3 = clk2;
assign  mux_sel = (use_new_clocking_model == "true")? muxsel3 : clk3;
assign sel_mux_lo_in = sel_mux_lo_in_tmp;
assign sel_mux_hi_in  =  sel_mux_hi_in_tmp;       

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    cycloneiiils_ddio_oe                                 //
//Description:                    Simulation model for Cyclone III LS DDIO OE            //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
module cycloneiiils_ddio_oe (
                       oe,
                       clk,
                       ena,
                       areset,
                       sreset,
                       dataout,
                       dfflo,
                       dffhi,
                       devpor,
                       devclrn
                    );

//Parameters Declaration
parameter power_up = "low";
parameter async_mode = "none";
parameter sync_mode = "none";
parameter lpm_type = "cycloneiiils_ddio_oe";

//Input Ports Declaration
input oe;
input clk;
input ena;
input areset;
input sreset;
input devpor;
input devclrn;

//Output Ports Declaration
output dataout;

//Buried Ports Declaration
output dfflo;
output dffhi;

tri1 devclrn;
tri1 devpor;

//Internal Signals
reg ddioreg_aclr;
reg ddioreg_prn;
reg ddioreg_adatasdata;
reg ddioreg_sclr;
reg ddioreg_sload;
reg viol_notifier;

initial
begin
	ddioreg_aclr = 1'b1;
	ddioreg_prn = 1'b1;
	ddioreg_adatasdata = 1'b0;
    ddioreg_sclr = 1'b0;
    ddioreg_sload = 1'b0;
end

wire dfflo_tmp;
wire dffhi_tmp;

always@(areset or sreset )
    begin
        if(async_mode == "clear")
            begin
                ddioreg_aclr = !areset;
                ddioreg_prn = 1'b1;
            end
        else if(async_mode == "preset")
            begin
                ddioreg_aclr = 'b1;
                ddioreg_prn = !areset;
            end
         else
            begin
                ddioreg_aclr = 'b1;
                ddioreg_prn = 'b1;
            end
            
         if(sync_mode == "clear")
            begin
                ddioreg_adatasdata = 'b0;
                ddioreg_sclr = sreset;
                ddioreg_sload = 'b0;
            end
        else if(sync_mode == "preset")
            begin
                ddioreg_adatasdata = 'b1;
                ddioreg_sclr = 'b0;
                ddioreg_sload = sreset;
            end
        else
            begin
                ddioreg_adatasdata = 'b0;
                ddioreg_sclr = 'b0;
                ddioreg_sload = 'b0;
            end
    end

//DDIO OE Register
dffeas  ddioreg_hi(
                   .d(oe),
                   .clk(clk),
                   .clrn(ddioreg_aclr),
                   .aload(1'b0),
                   .sclr(ddioreg_sclr),
                   .sload(ddioreg_sload),
                   .asdata(ddioreg_adatasdata),
                   .ena(ena),
                   .prn(ddioreg_prn),
                   .q(dffhi_tmp),
                   .devpor(devpor),
                   .devclrn(devclrn)
                );
defparam ddioreg_hi.power_up = power_up;

//DDIO Low Register
dffeas  ddioreg_lo(
                   .d(dffhi_tmp),
                   .clk(!clk),
                   .clrn(ddioreg_aclr),
                   .aload(1'b0),
                   .sclr(ddioreg_sclr),
                   .sload(ddioreg_sload),
                   .asdata(ddioreg_adatasdata),
                   .ena(ena),
                   .prn(ddioreg_prn),
                   .q(dfflo_tmp),
                   .devpor(devpor),
                   .devclrn(devclrn)
                   );
defparam ddioreg_lo.power_up = power_up;

//registered output
cycloneiiils_mux21 or_gate(
                    .MO(dataout),
                    .A(dffhi_tmp),
                    .B(dfflo_tmp),
                    .S(dfflo_tmp)
                   );
assign dfflo = dfflo_tmp;
assign dffhi = dffhi_tmp;

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    cycloneiiils_pseudo_diff_out                          //
//Description:                    Simulation model for Cyclone III LS Pseudo Differential //
//                                Output Buffer                                  //
//////////////////////////////////////////////////////////////////////////////////

module cycloneiiils_pseudo_diff_out(
                             i,
                             o,
                             obar
                             );
parameter lpm_type = "cycloneiiils_pseudo_diff_out";

input i;
output o;
output obar;

reg o_tmp;
reg obar_tmp;

assign o = o_tmp;
assign obar = obar_tmp;

always@(i)
    begin
        if( i == 1'b1)
            begin
                o_tmp = 1'b1;
                obar_tmp = 1'b0;
            end
        else if( i == 1'b0)
            begin
                o_tmp = 1'b0;
                obar_tmp = 1'b1;
            end
        else
            begin
                o_tmp = i;
                obar_tmp = i;
            end
    end
endmodule
//--------------------------------------------------------------------------
// Module Name     : cycloneiiils_io_pad
// Description     : Simulation model for cycloneiiils IO pad
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_io_pad ( 
		      padin, 
                      padout
	            );

parameter lpm_type = "cycloneiiils_io_pad";
//INPUT PORTS
input padin; //Input Pad

//OUTPUT PORTS
output padout;//Output Pad

//INTERNAL SIGNALS
wire padin_ipd;
wire padout_opd;

//INPUT BUFFER INSERTION FOR VERILOG-XL
buf padin_buf  (padin_ipd,padin);


assign padout_opd = padin_ipd;

//OUTPUT BUFFER INSERTION FOR VERILOG-XL
buf padout_buf (padout, padout_opd);

endmodule
//------------------------------------------------------------------
//
// Module Name : cycloneiiils_ena_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for the gated clock generation.
//               Powers upto 1.
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module cycloneiiils_ena_reg (
                clk,
                ena,
                d,
                clrn,
                prn,
                q
               );

// INPUT PORTS
input d;
input clk;
input clrn;
input prn;
input ena;

// OUTPUT PORTS
output q;

// INTERNAL VARIABLES
reg q_tmp;
reg violation;
reg d_viol;

reg clk_last_value;

wire reset;

// DEFAULT VALUES THRO' PULLUPs
tri1 prn, clrn, ena;

wire d_in;
wire clk_in;

buf (d_in, d);
buf (clk_in, clk);

assign reset = (!clrn) && (ena);

specify

    $setuphold (posedge clk &&& reset, d, 0, 0, d_viol) ;
      
    (posedge clk => (q +: q_tmp)) = 0 ;
      
endspecify

initial
begin
    q_tmp = 'b1;
    violation = 'b0;
    clk_last_value = clk_in;
end

    always @ (clk_in or negedge clrn or negedge prn )
    begin
        if (d_viol == 1'b1)
        begin
            violation = 1'b0;
            q_tmp <= 'bX;
        end
        else
        if (prn == 1'b0)
            q_tmp <= 1;
        else if (clrn == 1'b0)
            q_tmp <= 0;
        else if ((clk_last_value === 'b0) & (clk_in === 1'b1) & (ena == 1'b1))
            q_tmp <= d_in;


        clk_last_value = clk_in;
    end

and (q, q_tmp, 'b1);

endmodule // cycloneiiils_ena_reg

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_clkctrl
//
// Description : Cyclone III LS CLKCTRL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module cycloneiiils_clkctrl (
                        inclk, 
                        clkselect, 
                        ena, 
                        devpor, 
                        devclrn, 
                        outclk
                        );
   
input [3:0] inclk;
input [1:0] clkselect;
input ena; 
input devpor; 
input devclrn; 

output outclk;

tri1 devclrn;
tri1 devpor;
  
parameter clock_type = "auto";
parameter ena_register_mode = "falling edge";
parameter lpm_type = "cycloneiiils_clkctrl";

wire clkmux_out; // output of CLK mux
wire cereg1_out; // output of ENA register1 
wire cereg2_out; // output of ENA register2 
wire ena_out; // choice of registered ENA or none.
   
wire inclk3_ipd;
wire inclk2_ipd;
wire inclk1_ipd;
wire inclk0_ipd;
wire clkselect1_ipd;
wire clkselect0_ipd;
wire ena_ipd;
   
buf (inclk3_ipd, inclk[3]);
buf (inclk2_ipd, inclk[2]);
buf (inclk1_ipd, inclk[1]);
buf (inclk0_ipd, inclk[0]);
buf (clkselect1_ipd, clkselect[1]);
buf (clkselect0_ipd, clkselect[0]);
buf (ena_ipd, ena);
   
specify
    (inclk *> outclk) = (0, 0) ;
endspecify

cycloneiiils_mux41 clk_mux (.MO(clkmux_out),
               .IN0(inclk0_ipd),
               .IN1(inclk1_ipd),
               .IN2(inclk2_ipd),
               .IN3(inclk3_ipd),
               .S({clkselect1_ipd, clkselect0_ipd}));

cycloneiiils_ena_reg extena0_reg(
                    .clk(!clkmux_out),
                    .ena(1'b1),
                    .d(ena_ipd),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg1_out)
                   );

cycloneiiils_ena_reg extena1_reg(
                    .clk(!clkmux_out),
                    .ena(1'b1),
                    .d(cereg1_out),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg2_out)
                   );
   
assign ena_out = (ena_register_mode == "falling edge") ? cereg1_out :
                 ((ena_register_mode == "none") ? ena_ipd : cereg2_out);

and (outclk, ena_out, clkmux_out);
   
endmodule

///////////////////////////////////////////////////////////////////////
//
//              	CYCLONEIIILS RUBLOCK ATOM 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  cycloneiiils_rublock 
	(
	clk, 
	shiftnld, 
	captnupdt, 
	regin, 
	rsttimer, 
	rconfig, 
	regout
	);

	parameter sim_init_config = "factory";
	parameter sim_init_watchdog_value = 0;
	parameter sim_init_status = 0;
	parameter lpm_type = "cycloneiiils_rublock";

	input clk;
	input shiftnld;
	input captnupdt;
	input regin;
	input rsttimer;
	input rconfig;

	output regout;

endmodule


//--------------------------------------------------------------------
//
// Module Name : cycloneiiils_controller
//
// Description : cycloneiiils CONTROLLER Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module cycloneiiils_controller (
    nceout
    );

output nceout;

parameter lpm_type = "cycloneiiils_controller";

endmodule // cycloneiiils_controller
//------------------------------------------------------------------
//
// Module Name : cycloneiiils_termination_ctrl_sub
//
// Description : Cyclone III LS Termination Ctrl Sub-block 
//          
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_termination_ctrl (
    clkusr,
    intosc,
    nclrusr,
    nfrzdrv,
    rclkdiv,
    rclrusrinv,
    rdivsel,
    roctusr,
    rsellvrefdn,
    rsellvrefup,
    rtest,
    vccnx,
    vssn,
    
    clken,
    clkin,
    maskbit,
    nclr,
    noctdoneuser,
    octdone,
    oregclk,
    oregnclr,
    vref,
    vrefh,
    vrefl);
    
input        clkusr;
input        intosc;       // clk source in powerup mode
input        nclrusr;      
input        nfrzdrv;      // devclrn
input        rclkdiv;      //                       - 14
input        rclrusrinv;   // invert nclrusr signal - 13
input        rdivsel;      // 0 = /32; 1 = /4;      - 16
input        roctusr;      // run_time_control      - 15
input        rsellvrefdn;  // shift_vref_rdn        - 26
input        rsellvrefup;  // shift_vref_rup        - 25
input        rtest;        // test_mode             - 2
input        vccnx;        // VCC voltage src
input        vssn;         // GND voltage src

output       clken;        
output       clkin;
output [8:0] maskbit;
output       nclr;
output       noctdoneuser;
output       octdone;
output       oregclk;
output       oregnclr;
output       vref;
output       vrefh;
output       vrefl;

parameter	REG_TCO_DLY	= 0;  // 1;

   reg		divby2;
   reg		divby4;
   reg		divby8;
   reg		divby16;
   reg		divby32;
   reg		oregclk;
   reg	 	oregclkclk;
   reg		intosc_div4;
   reg		intosc_div32;
   reg 		clken;
   reg 		octdoneuser;
   reg 		startbit;
   reg	  [8:0] maskbit;
   reg 		octdone;

   wire	  [8:0] maskbit_d;
   wire		intoscin;
   wire		clk_sel;
   wire		intosc_clk;
   wire		clkin;
   wire		oregnclr;
   wire		clr_invert;
   wire		nclr;
   wire 	adcclk;

   // data flow in user mode:
   // oregnclr = 1 forever so clkin is clkusr
   //
   // deasserting nclrusr starts off USER calibration
   //    upon rising edge of nclrusr
   //    (1). at 1st neg edge of clkin, clken = 1
   //    (2). enable adcclk
   //    (3). Mask bits [8:0] shifts from MSB=1 into LSB=1
   //    (4). oregclkclk = bit[0] (=1); 7th cycle
   //    (5). oregclk = 1 (after falling edge of oregclkclk) 8th cycle
   //    (6). clken = 0 (!oregclk)
   //    (7). octdoneuser = 1 (falling edge of clken)
   initial 
   begin
       octdone     = 1'b1;    // from powerup stage
       octdoneuser = 1'b0;
       startbit    = 1'b0;
       maskbit     = 9'b000000000;
       oregclk     = 1'b0;
       oregclkclk  = 1'b0;
       clken       = 1'b0;
       
       divby2 = 1'b0;
       divby4 = 1'b0;
       divby8 = 1'b0;
       divby16 = 1'b0;
       divby32 = 1'b0;
       intosc_div4 = 1'b0;
       intosc_div32 = 1'b0;
   end
   
   
   assign noctdoneuser	= ~octdoneuser;

    // c7216 clkdiv
    always @(posedge intosc or negedge nfrzdrv) begin
	if (!nfrzdrv) 	divby2 <= #(REG_TCO_DLY) 1'b0;
	else 		divby2 <= #(REG_TCO_DLY) ~divby2;
    end

    always @(posedge divby2 or negedge nfrzdrv) begin
	if (!nfrzdrv) 	divby4 <= #(REG_TCO_DLY) 1'b0;
	else 		divby4 <= #(REG_TCO_DLY) ~divby4;
    end

    always @(posedge divby4 or negedge nfrzdrv) begin
	if (!nfrzdrv) 	divby8 <= #(REG_TCO_DLY) 1'b0;
	else 		divby8 <= #(REG_TCO_DLY) ~divby8;
    end

    always @(posedge divby8 or negedge nfrzdrv) begin
	if (!nfrzdrv) 	divby16 <= #(REG_TCO_DLY) 1'b0;
	else 		divby16 <= #(REG_TCO_DLY) ~divby16;
    end

    always @(posedge divby16 or negedge nfrzdrv) begin
	if (!nfrzdrv) 	divby32 <= #(REG_TCO_DLY) 1'b0;
	else 		divby32 <= #(REG_TCO_DLY) ~divby32;
    end

    assign intoscin	= rdivsel ? divby4 : divby32;    

    assign clk_sel	= octdone & roctusr; // always 1
    assign intosc_clk	= rclkdiv ? intoscin : intosc;
    assign clkin	= clk_sel ? clkusr : intosc_clk;
    assign oregnclr	= rtest | nfrzdrv;   // always 1
    assign clr_invert	= rclrusrinv ? ~nclrusr : nclrusr;
    assign nclr		= clk_sel ? clr_invert : nfrzdrv;

    // c7206 
    always @(negedge clkin or negedge nclr) begin
	if (!nclr) 	clken <= #(REG_TCO_DLY) 1'b0;
	else	   	clken <= #(REG_TCO_DLY) ~oregclk;
    end 

    always @(negedge clken or negedge oregnclr) begin
	if (!oregnclr)  octdone <= #(REG_TCO_DLY) 1'b0;
	else	    	octdone <= #(REG_TCO_DLY) 1'b1;
    end

    assign adcclk	= clkin & clken;

    always @(posedge adcclk or negedge nclr) begin
	if (!nclr) 
	    startbit	<= #(REG_TCO_DLY) 1'b0;
	else
	    startbit	<= #(REG_TCO_DLY) 1'b1;
    end

    assign maskbit_d	= {~startbit, maskbit[8:1]};

    always @(posedge adcclk or negedge nclr) begin
	if (!nclr) begin
	    maskbit 	<= #(REG_TCO_DLY) 9'b0;
	    oregclkclk	<= #(REG_TCO_DLY) 1'b0;
	end
	else begin
	    maskbit	<= #(REG_TCO_DLY) maskbit_d;
	    oregclkclk	<= #(REG_TCO_DLY) maskbit[0];
	end
    end

    always @(negedge oregclkclk or negedge nclr) begin
	if (~nclr) 	oregclk <= #(REG_TCO_DLY) 1'b0;
	else	   	oregclk <= #(REG_TCO_DLY) 1'b1;
    end

    always @(negedge clken or negedge nclr) begin
	if (~nclr)	octdoneuser <= #(REG_TCO_DLY) 1'b0;
	else		octdoneuser <= #(REG_TCO_DLY) 1'b1;
    end


    // OCT VREF c7207 xvref (
    // Functional code
    assign vrefh = 1'b1;
    assign vref  = 1'b1;
    assign vrefl = 1'b0;

endmodule

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_termination_ctrl_sub
//
// Description : Cyclone III LS Termination Ctrl Sub-block 
//          
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_termination_rupdn (
    clken, 
    clkin, 
    compout, 
    maskbit, 
    nclr, 
    octcal, 
    octpin, 
    octrpcd, 
    oregclk, 
    oregnclr,
    radd, 
    rcompoutinv, 
    roctdone, 
    rpwrdn, 
    rshift, 
    rshiftvref, 
    rtest, 
    shiftedvref, 
    vccnx, 
    vref
);

    input        clken;
    input        clkin;
    input  [8:0] maskbit;
    input        nclr;
    input        octpin;
    input        oregclk;
    input        oregnclr;
    input  [7:0] radd;
    input        rcompoutinv;
    input        roctdone;
    input        rpwrdn;
    input        rshift;
    input        rshiftvref;
    input        rtest;
    input        shiftedvref;
    input        vccnx;
    input        vref;

    output       compout;
    output [7:0] octcal;   // to IO bank
    output [7:0] octrpcd;  // to the reference RUP/RDN

    parameter	is_rdn	= "false";// initial value of octcal differ
    parameter	OCTCAL_DLY	= 0;  // 1;
    parameter	REG_TCO_DLY	= 0;  // 1;

    //supply0	vss;

    reg	  [7:0] comp_octrpcd;
    reg	  [7:0] octcal_reg;
 
    wire        octref;
    wire        shftref_out;
    wire        compout_tmp;
    wire        nout;
    wire        nbias;
    wire        pbias;
    wire  [7:0] octrpcd;
    wire  [7:0] octcal_reg_in;
    wire  [7:0] reg_clk;
    wire  [7:0] srpcd;
    wire  [7:0] rpcdi;
    wire  [8:0] rpcdi_temp;
    wire 	    shift;
    wire        shftvrefhv;
    wire        compout;
    wire        clr;
    wire        reg_clkin;
    wire        reg_nclr;
    wire        shiftvref;
    wire        compadcen;

    assign shift	= rtest & ~clken;
    assign compadcen	= ~roctdone & clken;

    assign shiftvref	= ~(rshiftvref | maskbit[1]);

    //c6419 xinverted_ls ( 
	//vss, shiftvref, shftvrefhv, vccnx );
   
    //c7223 xbias_ckt (
    assign nbias = (compadcen === 1'b1) ? 1'b1 : 1'b0;
    assign pbias = (compadcen === 1'b1) ? 1'b0 : 1'bz;

    //c7202 xoct_comp (
    assign compout_tmp = (compadcen === 1'b1) ? octpin : 1'b0;

    assign shftvrefhv	= shftref_out;
    assign octref	= shftvrefhv ? shiftedvref : vref;
    assign compout	= rcompoutinv ? compout_tmp : ~compout_tmp;
    
    // c7208
    assign reg_clk[7:0]	= maskbit[7:0];
    assign reg_nclr	= (compadcen | ~rpwrdn) & nclr;

    always @(posedge reg_clk[7] or negedge reg_nclr) begin 
	if (!reg_nclr)		comp_octrpcd[7] <= #(REG_TCO_DLY) 1'b0;
	else 			comp_octrpcd[7] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[6] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[6] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[6] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[5] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[5] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[5] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[4] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[4] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[4] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[3] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[3] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[3] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[2] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[2] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[2] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[1] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[1] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[1] <= #(REG_TCO_DLY) compout;
    end

    always @(posedge reg_clk[0] or negedge reg_nclr) begin
        if (!reg_nclr)   	comp_octrpcd[0] <= #(REG_TCO_DLY) 1'b0;
        else            	comp_octrpcd[0] <= #(REG_TCO_DLY) compout;
    end

    // output sends to RUP/DN reference pins
    assign octrpcd[7] = maskbit[8] ? 1'b1 : comp_octrpcd[7];
    assign octrpcd[6] = maskbit[7] ? 1'b1 : comp_octrpcd[6];
    // below: set octrpcd[5] and clear prior bit octrpcd[6] based on compout
    assign octrpcd[5] = maskbit[6] ? 1'b1 : comp_octrpcd[5];
    assign octrpcd[4] = maskbit[5] ? 1'b1 : comp_octrpcd[4];
    assign octrpcd[3] = maskbit[4] ? 1'b1 : comp_octrpcd[3];
    assign octrpcd[2] = maskbit[3] ? 1'b1 : comp_octrpcd[2];
    assign octrpcd[1] = maskbit[2] ? 1'b1 : comp_octrpcd[1];
    assign octrpcd[0] = maskbit[1] ? 1'b1 : comp_octrpcd[0];
    
    // c7210 - leftshift
    assign srpcd 	= rshift ? {octrpcd[6:0], 1'b0} : octrpcd;

    // c7214 - Adder: 
    //               overflow => max value 8'b1
    //               underflow => 0;
    assign rpcdi_temp[8:0]	= srpcd[7:0] + radd[7:0];
    assign rpcdi[7:0]		= {8{(~radd[7] & rpcdi_temp[8])}} | rpcdi_temp[7:0];

    // left shift rotation in test mode - only when calibration is done (clken=0)
    // calibration code (octcal) is 0 until calibration completed
    // oregclk indicates 10th cycle since masket[8]=1 --> masket[0]=1 + one cycle
    // clken is ~oregclk
    assign reg_clkin		= ~shift ? oregclk : clkin;  
    assign octcal_reg_in[7:0]	= ~shift ? rpcdi[7:0] : ({octcal[6:0], octcal[7]});

    initial begin
	   if (is_rdn == "true")
           octcal_reg[7:0] =  8'hFF;
       else
           octcal_reg[7:0] =  8'h00;
    end
    
    // calibrated code cannot be cleared by user_clr
    // it is only changed by code from calibration block which is
    always @(posedge reg_clkin or negedge oregnclr) begin
	if (!oregnclr)  octcal_reg[7:0]	<= #(REG_TCO_DLY) 8'h00;
	else		octcal_reg[7:0]	<= #(REG_TCO_DLY) octcal_reg_in[7:0];
    end

    assign #(OCTCAL_DLY) octcal	= octcal_reg;

endmodule

//------------------------------------------------------------------
//
// Module Name : cycloneiiils_termination
//
// Description : Cyclone III LS Termination Atom Verilog simulation model 
//          
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneiiils_termination (
    rup,
    rdn,
    terminationclock,
    terminationclear,
    devpor,
    devclrn,
    comparatorprobe,
    terminationcontrolprobe,
    calibrationdone,
    terminationcontrol);
    
input         rup;
input 	      rdn;
input 	      terminationclock;
input 	      terminationclear;
input         devpor;
input         devclrn;

output        comparatorprobe;
output        terminationcontrolprobe;
output        calibrationdone;
output [15:0] terminationcontrol;

parameter pullup_control_to_core = "false";
parameter power_down = "true";
parameter test_mode = "false";
parameter left_shift_termination_code = "false";
parameter pullup_adder = 0;        // -128, 127
parameter pulldown_adder = 0;      // -128, 127
parameter clock_divide_by = 32;    // 1, 4, 32
parameter runtime_control = "false";
parameter shift_vref_rup = "true";
parameter shift_vref_rdn = "true";
parameter shifted_vref_control = "true";

parameter lpm_type = "cycloneiiils_termination";

tri1 devclrn;
tri1 devpor;

wire           m_gnd;
wire           m_vcc;

// interconnecting wires

// ctrl -----------------------------------------
wire           xcbout_clken;        
wire           xcbout_clkin;
wire [8:0]     xcbout_maskbit;
wire           xcbout_nclr;
wire           xcbout_noctdoneuser;
wire           xcbout_octdone;
wire           xcbout_oregclk;
wire           xcbout_oregnclr;
wire           xcbout_vref;       // to run/dn comparator
wire           xcbout_vrefh;      // to rdn - shfitedvref
wire           xcbout_vrefl;      // to rup - shiftedvref

wire           xcbin_clkusr;
wire           xcbin_intosc;       // clk source in powerup mode
wire           xcbin_nclrusr;      
wire           xcbin_nfrzdrv;      // devclrn
wire           xcbin_rclkdiv;      //                       - 14
wire           xcbin_rclrusrinv;   // invert nclrusr signal - 13
wire           xcbin_rdivsel;      // 0 = /32; 1 = /4;      - 16
wire           xcbin_roctusr;      // run_time_control      - 15
wire           xcbin_rsellvrefdn;  // shift_vref_rdn        - 26
wire           xcbin_rsellvrefup;  // shift_vref_rup        - 25
wire           xcbin_rtest;        // test_mode             - 2
wire           xcbin_vccnx;        // VCC voltage src
wire           xcbin_vssn;         // GND voltage src

// rup and rdn ------------------------------------
// common
wire           rshift_in;
wire           rpwrdn_in;

wire           rup_compout;
wire [7:0]     rup_octrupn;        // out from XRUP to rupref pin 
wire [7:0]     rup_octcalnout;     // to the I/O bank
wire           rupin;
reg  [7:0]     rup_radd;

wire           rdn_compout;
wire [7:0]     rdn_octrdnp;        // out from XRDN to rdnref pin 
wire [7:0]     rdn_octcalpout;     // to the I/O bank
wire           rdnin;
reg  [7:0]     rdn_radd;

wire           calout;             // MSB of the calibration code

// primary input and outputs
assign rupin = rup;
assign rdnin = rdn;
// terminationclk and clear feeding into CTRL sub directly

assign calibrationdone    = xcbout_octdone;
assign terminationcontrol = {rup_octcalnout, rdn_octcalpout};
assign comparatorprobe    = (pullup_control_to_core == "true") ? rup_compout : rdn_compout;

assign calout = (pullup_control_to_core == "true") ? rup_octcalnout[7] : rdn_octcalpout[7];
assign terminationcontrolprobe = (test_mode == "true") ? calout : xcbout_noctdoneuser;
                                 
initial begin
    rup_radd = pullup_adder;
    rdn_radd = pulldown_adder;
end

// CTRL sub-block
assign xcbin_clkusr       = terminationclock;
assign xcbin_intosc       = 1'b0;              // clk source in powerup mode
assign xcbin_nclrusr      = (terminationclear === 1'b1) ? 1'b0 : 1'b1;      
assign xcbin_nfrzdrv      = (devclrn === 1'b0) ? 1'b0 : 1'b1; 
assign xcbin_vccnx        = 1'b1;              // VCC voltage src
assign xcbin_vssn         = 1'b0;              // GND voltage src
assign xcbin_rclkdiv      = (clock_divide_by != 1) ? 1'b1 : 1'b0;      //- 14
assign xcbin_rclrusrinv   = 1'b0;              // invert nclrusr signal  - 13
assign xcbin_rdivsel      = (clock_divide_by == 32) ? 1'b0 : 1'b1;     //- 16
assign xcbin_roctusr      = (runtime_control == "true") ? 1'b1 : 1'b0; //- 15
assign xcbin_rsellvrefdn  = (shift_vref_rdn == "true") ? 1'b1 : 1'b0;  //- 26
assign xcbin_rsellvrefup  = (shift_vref_rup == "true") ? 1'b1 : 1'b0;  //- 25
assign xcbin_rtest        = (test_mode == "true") ? 1'b1 : 1'b0;       // - 2

cycloneiiils_termination_ctrl m_ctrl (
    .clken          (xcbout_clken          ), 
    .clkin          (xcbout_clkin          ), 
    .maskbit        (xcbout_maskbit         ),
    .nclr           (xcbout_nclr           ), 
    .noctdoneuser   (xcbout_noctdoneuser   ),
    .octdone        (xcbout_octdone        ), 
    .oregclk        (xcbout_oregclk        ), 
    .oregnclr       (xcbout_oregnclr       ), 
    .vref           (xcbout_vref           ), 
    .vrefh          (xcbout_vrefh          ),
    .vrefl          (xcbout_vrefl          ), 
    
    .clkusr         (xcbin_clkusr          ), 
    .intosc         (xcbin_intosc          ), 
    .nclrusr        (xcbin_nclrusr         ), 
    .nfrzdrv        (xcbin_nfrzdrv         ), 
    .vccnx          (xcbin_vccnx           ), 
    .vssn           (xcbin_vssn            ),
    
    .rclkdiv        (xcbin_rclkdiv         ),
    .rclrusrinv     (xcbin_rclrusrinv      ), 
    .rdivsel        (xcbin_rdivsel         ), 
    .roctusr        (xcbin_roctusr         ), 
    .rsellvrefdn    (xcbin_rsellvrefdn     ),
    .rsellvrefup    (xcbin_rsellvrefup     ), 
    .rtest          (xcbin_rtest           )
);

assign m_vcc = 1'b1;
assign m_gnd = 1'b0;

assign rshift_in = (left_shift_termination_code == "true") ? 1'b1 : 1'b0;
assign rpwrdn_in = (power_down == "true") ? 1'b1 : 1'b0;

cycloneiiils_termination_rupdn m_rup (
    .compout        (rup_compout    ), 
    .octrpcd        (rup_octrupn    ), 
    .octcal         (rup_octcalnout ), 
    
    .octpin         (rupin          ), 
    .rcompoutinv    (m_vcc          ),   // no inversion
    .radd           (rup_radd       ), 
    
    .clken          (xcbout_clken   ), 
    .clkin          (xcbout_clkin   ), 
    .maskbit        (xcbout_maskbit ), 
    .nclr           (xcbout_nclr    ),
    .oregclk        (xcbout_oregclk ), 
    .oregnclr       (xcbout_oregnclr),
    .shiftedvref    (xcbout_vrefl   ),
    .vccnx          (xcbin_vccnx    ), 
    .vref           (xcbout_vref    ), 
    .roctdone       (m_gnd          ),   // [12]
    .rpwrdn         (rpwrdn_in      ),   // [1]
    .rshift         (rshift_in      ),   // [3] 
    .rshiftvref     (m_vcc          ),   // [27]
    .rtest          (xcbin_rtest    ) 
);
defparam m_rup.is_rdn = "false";

cycloneiiils_termination_rupdn m_rdn (
    .compout        (rdn_compout    ), 
    .octrpcd        (rdn_octrdnp    ), 
    .octcal         (rdn_octcalpout ), 
    
    .octpin         (rdnin          ), 
    .rcompoutinv    (m_gnd          ),    // invert compout
    .radd           (rdn_radd       ),
    
    .clken          (xcbout_clken   ), 
    .clkin          (xcbout_clkin   ), 
    .maskbit        (xcbout_maskbit ), 
    .nclr           (xcbout_nclr    ),
    .oregclk        (xcbout_oregclk ), 
    .oregnclr       (xcbout_oregnclr),
    .shiftedvref    (xcbout_vrefh   ),
    .vccnx          (xcbin_vccnx    ), 
    .vref           (xcbout_vref    ),
    .roctdone       (m_gnd          ),     // [12]
    .rpwrdn         (rpwrdn_in      ),     // [1]
    .rshift         (rshift_in      ),     // [3] 
    .rshiftvref     (m_vcc          ),     // [27] 
    .rtest          (xcbin_rtest    )
);
defparam m_rdn.is_rdn = "true";

endmodule
//--------------------------------------------------------------------
//
// Module Name : cycloneiiils_jtag
//
// Description : cycloneiiils JTAG Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  cycloneiiils_jtag (
    tms, 
    tck,
    tdi, 
    tdoutap,
    tdouser, 
    tdo,
    tmsutap,
    tckutap,
    tdiutap,
    shiftuser,
    clkdruser,
    updateuser,
    runidleuser,
    usr1user);

input tms;
input tck;
input tdi;
input tdoutap;
input tdouser;

output tdo;
output tmsutap;
output tckutap;
output tdiutap;
output shiftuser;
output clkdruser;
output updateuser;
output runidleuser;
output usr1user;

parameter lpm_type = "cycloneiiils_jtag";

endmodule

//--------------------------------------------------------------------
//
// Module Name : cycloneiiils_crcblock
//
// Description : Cyclone III LS CRCBLOCK Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  cycloneiiils_crcblock (
    clk,
    shiftnld,
    ldsrc,
    crcerror,
    cyclecomplete,
    regout);

input clk;
input shiftnld;
input ldsrc;

output crcerror;
output cyclecomplete;
output regout;

assign crcerror = 1'b0;
assign regout = 1'b0;

parameter oscillator_divider = 1;
parameter lpm_type = "cycloneiiils_crcblock";

endmodule

///////////////////////////////////////////////////////////////////////
//
//              	CYCLONEIIILS OSCILLATOR ATOM 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  cycloneiiils_oscillator 
    (
    oscena,
    clkout1,
    observableoutputport,
    clkout 
    );

    parameter lpm_type = "cycloneiiils_oscillator";

    input oscena;
    
    output clkout1;
    output observableoutputport;
    output clkout;

// LOCAL_PARAMETERS_BEGIN

    parameter OSC_PW = 6250; // fixed 80HZ running clock

// LOCAL_PARAMETERS_END

    // INTERNAL wire
    reg int_osc; // internal oscillator

    specify
        (posedge oscena => (clkout +: 1'b1)) = (0, 0);
    endspecify

    initial
        int_osc = 1'b0;

    always @(int_osc or oscena)
    begin
        if (oscena == 1'b1)
            int_osc <= #OSC_PW ~int_osc;
    end

    and (clkout, int_osc, 1'b1);

endmodule


`ifdef MODEL_TECH
`mti_v2k_int_delays_off

`endif
