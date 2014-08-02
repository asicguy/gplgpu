// Copyright (C) 1991-2011 Altera Corporation
// This simulation model contains highly confidential and
// proprietary information of Altera and is being provided
// in accordance with and subject to the protections of the
// applicable Altera Program License Subscription Agreement
// which governs its use and disclosure. Your use of Altera
// Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions,
// and any output files any of the foregoing (including device
// programming or simulation files), and any associated
// documentation or information are expressly subject to the
// terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other
// applicable license agreement, including, without limitation,
// that your use is for the sole purpose of simulating designs for
// use exclusively in logic devices manufactured by Altera and sold
// by Altera or its authorized distributors. Please refer to the
// applicable agreement for further details. Altera products and
// services are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
// Altera assumes no responsibility or liability arising out of the
// application or use of this simulation model.
// Quartus II 11.0 Build 157 04/27/2011

// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

primitive STRATIXV_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
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

primitive STRATIXV_PRIM_DFFEAS (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

primitive STRATIXV_PRIM_DFFEAS_HIGH (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

module stratixv_dffe ( Q, CLK, ENA, D, CLRN, PRN );
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
   
   STRATIXV_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
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


// ***** stratixv_mux21

module stratixv_mux21 (MO, A, B, S);
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

// ***** stratixv_mux41

module stratixv_mux41 (MO, IN0, IN1, IN2, IN3, S);
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

// ***** stratixv_and1

module stratixv_and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** stratixv_and16

module stratixv_and16 (Y, IN1);
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

// ***** stratixv_bmux21

module stratixv_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixv_b17mux21

module stratixv_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixv_nmux21

module stratixv_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** stratixv_b5mux21

module stratixv_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********


//------------------------------------------------------------------
//
// Module Name : stratixv_ff
//
// Description : STRATIXV FF Verilog simulation model 
//
//------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixv_ff (
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
parameter lpm_type = "stratixv_ff";

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

//------------------------------------------------------------------
//
// Module Name : stratixv_lcell_comb
//
// Description : STRATIXV LCELL_COMB Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixv_lcell_comb (
                             dataa, 
                             datab, 
                             datac, 
                             datad, 
                             datae, 
                             dataf, 
                             datag, 
                             cin,
                             sharein, 
                             combout, 
                             sumout,
                             cout, 
                             shareout 
                            );

input dataa;
input datab;
input datac;
input datad;
input datae;
input dataf;
input datag;
input cin;
input sharein;

output combout;
output sumout;
output cout;
output shareout;

parameter lut_mask = 64'hFFFFFFFFFFFFFFFF;
parameter shared_arith = "off";
parameter extended_lut = "off";
parameter dont_touch = "off";
parameter lpm_type = "stratixv_lcell_comb";

// sub masks
wire [15:0] f0_mask;
wire [15:0] f1_mask;
wire [15:0] f2_mask;
wire [15:0] f3_mask;

// sub lut outputs
reg f0_out;
reg f1_out;
reg f2_out;
reg f3_out;

// mux output for extended mode
reg g0_out;
reg g1_out;

// either datac or datag
reg f2_input3;

// F2 output using dataf
reg f2_f;

// second input to the adder
reg adder_input2;

// tmp output variables
reg combout_tmp;
reg sumout_tmp;
reg cout_tmp;

// integer representations for string parameters
reg ishared_arith;
reg iextended_lut;

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

// 5-input LUT function
function lut5;
input [31:0] mask;
input dataa;
input datab;
input datac;
input datad;
input datae;
reg e0_lut;
reg e1_lut;
reg [15:0] e0_mask;
reg [31:16] e1_mask;

      
begin

    e0_mask = mask[15:0];
    e1_mask = mask[31:16];

	 begin
        e0_lut = lut4(e0_mask, dataa, datab, datac, datad);
        e1_lut = lut4(e1_mask, dataa, datab, datac, datad);

        if (datae === 1'bX) // X propogation
        begin
            if (e0_lut == e1_lut)
            begin
                lut5 = e0_lut;
            end
            else
            begin
                lut5 = 1'bX;
            end
        end
        else
        begin
            lut5 = (datae == 1'b1) ? e1_lut : e0_lut;
        end
    end
end
endfunction

// 6-input LUT function
function lut6;
input [63:0] mask;
input dataa;
input datab;
input datac;
input datad;
input datae;
input dataf;
reg f0_lut;
reg f1_lut;
reg [31:0] f0_mask;
reg [63:32] f1_mask ;
      
begin

    f0_mask = mask[31:0];
    f1_mask = mask[63:32];

	 begin

        lut6 = mask[{dataf, datae, datad, datac, datab, dataa}];

        if (lut6 === 1'bX)
        begin
            f0_lut = lut5(f0_mask, dataa, datab, datac, datad, datae);
            f1_lut = lut5(f1_mask, dataa, datab, datac, datad, datae);
    
            if (dataf === 1'bX) // X propogation
            begin
                if (f0_lut == f1_lut)
                begin
                    lut6 = f0_lut;
                end
                else
                begin
                    lut6 = 1'bX;
                end
            end
            else
            begin
                lut6 = (dataf == 1'b1) ? f1_lut : f0_lut;
            end
        end
    end
end
endfunction

wire dataa_in;
wire datab_in;
wire datac_in;
wire datad_in;
wire datae_in;
wire dataf_in;
wire datag_in;
wire cin_in;
wire sharein_in;

buf(dataa_in, dataa);
buf(datab_in, datab);
buf(datac_in, datac);
buf(datad_in, datad);
buf(datae_in, datae);
buf(dataf_in, dataf);
buf(datag_in, datag);
buf(cin_in, cin);
buf(sharein_in, sharein);

specify

    (dataa => combout) = (0, 0);
    (datab => combout) = (0, 0);
    (datac => combout) = (0, 0);
    (datad => combout) = (0, 0);
    (datae => combout) = (0, 0);
    (dataf => combout) = (0, 0);
    (datag => combout) = (0, 0);

    (dataa => sumout) = (0, 0);
    (datab => sumout) = (0, 0);
    (datac => sumout) = (0, 0);
    (datad => sumout) = (0, 0);
    (dataf => sumout) = (0, 0);
    (cin => sumout) = (0, 0);
    (sharein => sumout) = (0, 0);

    (dataa => cout) = (0, 0);
    (datab => cout) = (0, 0);
    (datac => cout) = (0, 0);
    (datad => cout) = (0, 0);
    (dataf => cout) = (0, 0);
    (cin => cout) = (0, 0);
    (sharein => cout) = (0, 0);

    (dataa => shareout) = (0, 0);
    (datab => shareout) = (0, 0);
    (datac => shareout) = (0, 0);
    (datad => shareout) = (0, 0);

endspecify

initial
begin
    if (shared_arith == "on")
        ishared_arith = 1;
    else
        ishared_arith = 0;

    if (extended_lut == "on")
        iextended_lut = 1;
    else
        iextended_lut = 0;

    f0_out = 1'b0;
    f1_out = 1'b0;
    f2_out = 1'b0;
    f3_out = 1'b0;
    g0_out = 1'b0;
    g1_out = 1'b0;
    f2_input3 = 1'b0;
    adder_input2 = 1'b0;
    f2_f = 1'b0;
    combout_tmp = 1'b0;
    sumout_tmp = 1'b0;
    cout_tmp = 1'b0;
end

// sub masks and outputs
assign f0_mask = lut_mask[15:0];
assign f1_mask = lut_mask[31:16];
assign f2_mask = lut_mask[47:32];
assign f3_mask = lut_mask[63:48];

always @(datag_in or dataf_in or datae_in or datad_in or datac_in or 
         datab_in or dataa_in or cin_in or sharein_in)
begin

    // check for extended LUT mode
    if (iextended_lut == 1) 
        f2_input3 = datag_in;
    else
        f2_input3 = datac_in;

    f0_out = lut4(f0_mask, dataa_in, datab_in, datac_in, datad_in);
    f1_out = lut4(f1_mask, dataa_in, datab_in, f2_input3, datad_in);
    f2_out = lut4(f2_mask, dataa_in, datab_in, datac_in, datad_in);
    f3_out = lut4(f3_mask, dataa_in, datab_in, f2_input3, datad_in);

    // combout is the 6-input LUT
    if (iextended_lut == 1)
    begin
        if (datae_in == 1'b0)
        begin
            g0_out = f0_out;
            g1_out = f2_out;
        end
        else if (datae_in == 1'b1)
        begin
            g0_out = f1_out;
            g1_out = f3_out;
        end
        else
        begin
            if (f0_out == f1_out)
                g0_out = f0_out;
            else
                g0_out = 1'bX;

            if (f2_out == f3_out)
                g1_out = f2_out;
            else
                g1_out = 1'bX;
        end
    
        if (dataf_in == 1'b0)
            combout_tmp = g0_out;
        else if ((dataf_in == 1'b1) || (g0_out == g1_out))
            combout_tmp = g1_out;
        else
            combout_tmp = 1'bX;
    end
    else
        combout_tmp = lut6(lut_mask, dataa_in, datab_in, datac_in, 
                           datad_in, datae_in, dataf_in);

    // check for shareed arithmetic mode
    if (ishared_arith == 1) 
        adder_input2 = sharein_in;
    else
    begin
        f2_f = lut4(f2_mask, dataa_in, datab_in, datac_in, dataf_in);
        adder_input2 = !f2_f;
    end

    // sumout & cout
    sumout_tmp = cin_in ^ f0_out ^ adder_input2;
    cout_tmp = (cin_in & f0_out) | (cin_in & adder_input2) | 
               (f0_out & adder_input2);

end

and (combout, combout_tmp, 1'b1);
and (sumout, sumout_tmp, 1'b1);
and (cout, cout_tmp, 1'b1);
and (shareout, f2_out, 1'b1);

endmodule
//------------------------------------------------------------------
//
// Module Name : stratixv_routing_wire
//
// Description : Simulation model for a simple routing wire
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixv_routing_wire (
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

endmodule // stratixv_routing_wire

// Deactivate the LEDA rule that requires uppercase letters for all
// parameter names
// leda rule_G_521_3_B off

`timescale 1 ps/1 ps

//--------------------------------------------------------------------------
// Module Name     : stratixv_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module stratixv_ram_block
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
generic_m20k ram_core0
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

endmodule // stratixv_ram_block

// Activate again the LEDA rule that requires uppercase letters for all
// parameter names
// leda rule_G_521_3_B on



//--------------------------------------------------------------------------
// Module Name     : stratixv_mlab_cell
// Description     : Main RAM module
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixv_mlab_cell
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

parameter lpm_type = "stratixv_mlab_cell";
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

generic_mlab_cell my_lutram0
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

endmodule // stratixv_mlab_cell
//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixv_io_ibuf                                 //
//Description:                    Simulation model for STRATIXV IO Input Buffer    //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module stratixv_io_ibuf (
                      i,
                      ibar,
                      dynamicterminationcontrol,      
                      o
                     );

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter differential_mode = "false";
parameter bus_hold = "false";
parameter simulate_z_as = "Z";
parameter lpm_type = "stratixv_io_ibuf";

// SIMULATION_ONLY_PARAMETERS_END

//Input Ports Declaration
input i;
input ibar;
input dynamicterminationcontrol; 

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
//Module Name:                    stratixv_io_obuf                                 //
//Description:                    Simulation model for STRATIXV IO Output Buffer   //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module stratixv_io_obuf (
                      i,
                      oe,
                      dynamicterminationcontrol,      
                      seriesterminationcontrol,
                      parallelterminationcontrol,     
                      devoe,
                      o,
                      obar
                    );

//Parameter Declaration
parameter open_drain_output = "false";
parameter bus_hold = "false";
parameter shift_series_termination_control = "false";  
parameter sim_dynamic_termination_control_is_connected = "false"; 
parameter lpm_type = "stratixv_io_obuf";

//Input Ports Declaration
input i;
input oe;
input devoe;
input dynamicterminationcontrol; 
input [15:0] seriesterminationcontrol;
input [15:0] parallelterminationcontrol;

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
assign tmp1 = ((oe == 1'b1) && (dynamicterminationcontrol == 1'b1) && (sim_dynamic_termination_control_is_connected == "true")) ? 1'bx :(devoe == 1'b1) ? tmp : 1'bz; 
assign tmp1_bar =((oe == 1'b1) && (dynamicterminationcontrol == 1'b1)&& (sim_dynamic_termination_control_is_connected == "true")) ? 1'bx : (devoe == 1'b1) ? tmp_bar : 1'bz; 



pmos (o, tmp1, 1'b0);
pmos (obar, tmp1_bar, 1'b0);

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixv_ddio_out                                //
//Description:                    Simulation model for STRATIXV DDIO Output        //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module stratixv_ddio_out (
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
parameter half_rate_mode = "false"; 
parameter use_new_clocking_model = "false";
parameter lpm_type = "stratixv_ddio_out";

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
output [1:0] dffhi; 

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
wire dffhi1_tmp; 
wire sel_mux_hi_in;
wire clk_hi;
wire clk_lo;
wire datainlo_tmp;
wire datainhi_tmp;
reg dinhi_tmp;
reg dinlo_tmp;
wire clk_hr; 

reg clk1;
reg clk2;

reg muxsel1;
reg muxsel2;
reg muxsel_tmp;
reg sel_mux_lo_in_tmp;
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
assign dffhi[0] = dffhi_tmp; 
assign dffhi[1] = dffhi1_tmp;

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
   if (half_rate_mode == "true")	
	muxsel_tmp <= mux_sel;		
   else					
	muxsel_tmp <= !mux_sel;		
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
dffeas  ddioreg_hi(                                    
                   .d(datainhi_tmp),                   
                   .clk(clk_hi),                       
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


assign clk_hi = (use_new_clocking_model == "true") ?  clkhi : clk;
assign datainhi_tmp = dinhi_tmp; 

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
dffeas  ddioreg_hi1(                                               
                   .d(dffhi_tmp),                                  
                   .clk(!clk_hr),                                  
                   .clrn(ddioreg_aclr),                            
                   .aload(1'b0),                                   
                   .sclr(ddioreg_sclr),                            
                   .sload(ddioreg_sload),                          
                   .asdata(ddioreg_adatasdata),                    
                   .ena(ena),                                      
                   .prn(ddioreg_prn),                              
                   .q(dffhi1_tmp),                                 
                   .devpor(devpor),                                
                   .devclrn(devclrn)                               
                  );                                               
defparam ddioreg_hi1.power_up = power_up;                          
assign clk_hr = (use_new_clocking_model == "true") ?  clkhi : clk; 

//registered output selection
stratixv_mux21 sel_mux(
                    .MO(dataout),
                    .A(sel_mux_lo_in),
                    .B(sel_mux_hi_in),
                    .S(muxsel_tmp)
                   );

assign muxsel3 = muxsel2;
assign clk3 = clk2;
assign  mux_sel = (use_new_clocking_model == "true")? muxsel3 : clk3;
assign sel_mux_lo_in = sel_mux_lo_in_tmp;
assign sel_mux_hi_in = dffhi_tmp; 

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixv_ddio_oe                                 //
//Description:                    Simulation model for STRATIXV DDIO OE            //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
module stratixv_ddio_oe (
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
parameter lpm_type = "stratixv_ddio_oe";

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
stratixv_mux21 or_gate(
                    .MO(dataout),
                    .A(dffhi_tmp),
                    .B(dfflo_tmp),
                    .S(dfflo_tmp)
                   );
assign dfflo = dfflo_tmp;
assign dffhi = dffhi_tmp;

endmodule

////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixv_ddio_in                                 
//Description:                    Simulation model for STRATIXV DDIO IN            
//                                                                              
////////////////////////////////////////////////////////////////////////////////
                                                                                
                                                                                
module stratixv_ddio_in (                                                          
                      datain,                                                   
                      clk,                                                      
                      clkn,                                                     
                      ena,                                                      
                      areset,                                                   
                      sreset,                                                   
                      regoutlo,                                                 
                      regouthi,                                                 
                      dfflo,                                                    
                      devpor,                                                   
                      devclrn                                                   
                    );                                                          
                                                                                
//Parameters Declaration                                                        
parameter power_up = "low";                                                     
parameter async_mode = "none";                                                  
parameter sync_mode = "none";                                                   
parameter use_clkn = "false";                                                   
parameter lpm_type = "stratixv_ddio_in";                                           
                                                                                
//Input Ports Declaration                                                       
input datain;                                                                   
input clk;                                                                      
input clkn;                                                                     
input ena;                                                                      
input areset;                                                                   
input sreset;                                                                   
input devpor;                                                                   
input devclrn;                                                                  
                                                                                
//Output Ports Declaration                                                      
output regoutlo;                                                                
output regouthi;                                                                
                                                                                
//burried port;                                                                 
output dfflo;                                                                   
                                                                                
tri1 devclrn;                                                                   
tri1 devpor;                                                                    
                                                                                
//Internal Signals                                                              
reg ddioreg_aclr;                                                               
reg ddioreg_prn;                                                                
reg ddioreg_adatasdata;                                                         
reg ddioreg_sclr;                                                               
reg ddioreg_sload;                                                              
reg viol_notifier;                                                              
                                                                                
wire ddioreg_clk;                                                               
wire dfflo_tmp;                                                                 
wire regout_tmp_hi;                                                             
wire regout_tmp_lo;                                                             
wire dff_ena;                                                                   
                                                                                
initial                                                                         
begin                                                                           
	ddioreg_aclr = 1'b1;                                                        
	ddioreg_prn = 1'b1;                                                         
	ddioreg_adatasdata = 1'b0;                                                  
    ddioreg_sclr = 1'b0;                                                        
    ddioreg_sload = 1'b0;                                                       
end                                                                             
                                                                                
assign ddioreg_clk = (use_clkn == "false") ? !clk : clkn;                       
                                                                                
//Decode the control values for the DDIO registers                              
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
//DDIO high Register                                                            
dffeas  ddioreg_hi(                                                             
                   .d(datain),                                                  
                   .clk(clk),                                                   
                   .clrn(ddioreg_aclr),                                         
                   .aload(1'b0),                                                
                   .sclr(ddioreg_sclr),                                         
                   .sload(ddioreg_sload),                                       
                   .asdata(ddioreg_adatasdata),                                 
                   .ena(ena),                                                   
                   .prn(ddioreg_prn),                                           
                   .q(regout_tmp_hi),                                           
                   .devpor(devpor),                                             
                   .devclrn(devclrn)                                            
                   );                                                           
defparam ddioreg_hi.power_up = power_up;                                        
                                                                                
//DDIO Low Register                                                             
dffeas  ddioreg_lo(                                                             
                   .d(datain),                                                  
                   .clk(ddioreg_clk),                                           
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
                                                                                
dffeas  ddioreg_lo1(                                                            
                    .d(dfflo_tmp),                                              
                    .clk(clk),                                                  
                    .clrn(ddioreg_aclr),                                        
                    .aload(1'b0),                                               
                    .sclr(ddioreg_sclr),                                        
                    .sload(ddioreg_sload),                                      
                    .asdata(ddioreg_adatasdata),                                
                    .ena(ena),                                                  
                    .prn(ddioreg_prn),                                          
                    .q(regout_tmp_lo),                                          
                    .devpor(devpor),                                            
                    .devclrn(devclrn)                                           
                   );                                                           
defparam ddioreg_lo1.power_up = power_up;                                       
                                                                                
                                                                                
assign regouthi = regout_tmp_hi;                                                
assign regoutlo = regout_tmp_lo;                                                
assign dfflo = dfflo_tmp;                                                       
                                                                                
endmodule                                                                       
//--------------------------------------------------------------------------
// Module Name     : stratixv_io_pad
// Description     : Simulation model for stratixv IO pad
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixv_io_pad ( 
		      padin, 
                      padout
	            );

parameter lpm_type = "stratixv_io_pad";
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
//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixv_pseudo_diff_out                          //
//Description:                    Simulation model for Stratixv Pseudo Differential //
//                                Output Buffer                                  //
//////////////////////////////////////////////////////////////////////////////////

module stratixv_pseudo_diff_out(
                             i,
                             o,
                             obar,
// ports new for StratixV
				dtcin,
				dtc,
				dtcbar,
				oein,
				oeout,
				oebout
                             );
parameter lpm_type = "stratixv_pseudo_diff_out";

input i;
output o;
output obar;
// ports new for StratixV
   
input dtcin, oein;
output dtc, dtcbar, oeout, oebout;
   

reg o_tmp;
reg obar_tmp;
reg dtc_tmp, dtcbar_tmp, oeout_tmp, oebout_tmp;

assign dtc    = dtcin;
assign dtcbar = dtcin;
assign oeout  = oein;
assign oebout = oein;
   
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
    end // always@ (i)
   
endmodule

// -----------------------------------------------------------
//
// Module Name : stratixv_bias_logic
//
// Description : STRATIXV Bias Block's Logic Block
//               Verilog simulation model
//
// -----------------------------------------------------------

`timescale 1 ps/1 ps

module stratixv_bias_logic (
    clk,
    shiftnld,
    captnupdt,
    mainclk,
    updateclk,
    capture,
    update
    );

// INPUT PORTS
input  clk;
input  shiftnld;
input  captnupdt;
    
// OUTPUTPUT PORTS
output mainclk;
output updateclk;
output capture;
output update;

// INTERNAL VARIABLES
reg mainclk_tmp;
reg updateclk_tmp;
reg capture_tmp;
reg update_tmp;

initial
begin
    mainclk_tmp <= 'b0;
    updateclk_tmp <= 'b0;
    capture_tmp <= 'b0;
    update_tmp <= 'b0;
end

    always @(captnupdt or shiftnld or clk)
    begin
        case ({captnupdt, shiftnld})
        2'b10, 2'b11 :
            begin
                mainclk_tmp <= 'b0;
                updateclk_tmp <= clk;
                capture_tmp <= 'b1;
                update_tmp <= 'b0;
            end
        2'b01 :
            begin
                mainclk_tmp <= 'b0;
                updateclk_tmp <= clk;
                capture_tmp <= 'b0;
                update_tmp <= 'b0;
            end
        2'b00 :
            begin
                mainclk_tmp <= clk;
                updateclk_tmp <= 'b0;
                capture_tmp <= 'b0;
                update_tmp <= 'b1;
            end
        default :
            begin
                mainclk_tmp <= 'b0;
                updateclk_tmp <= 'b0;
                capture_tmp <= 'b0;
                update_tmp <= 'b0;
            end
        endcase
    end

and (mainclk, mainclk_tmp, 1'b1);
and (updateclk, updateclk_tmp, 1'b1);
and (capture, capture_tmp, 1'b1);
and (update, update_tmp, 1'b1);

endmodule // stratixv_bias_logic

// -----------------------------------------------------------
//
// Module Name : stratixv_bias_generator
//
// Description : STRATIXV Bias Generator Verilog simulation model
//
// -----------------------------------------------------------

`timescale 1 ps/1 ps

module stratixv_bias_generator (
    din,
    mainclk,
    updateclk,
    capture,
    update,
    dout 
    );

// INPUT PORTS
input  din;
input  mainclk;
input  updateclk;
input  capture;
input  update;
    
// OUTPUTPUT PORTS
output dout;
    
parameter TOTAL_REG = 202;

// INTERNAL VARIABLES
reg dout_tmp;
reg generator_reg [TOTAL_REG - 1:0];
reg update_reg [TOTAL_REG - 1:0];
integer i;

initial
begin
    dout_tmp <= 'b0;
    for (i = 0; i < TOTAL_REG; i = i + 1)
    begin
        generator_reg [i] <= 'b0;
        update_reg [i] <= 'b0;
    end
end

// main generator registers
always @(posedge mainclk)
begin
    if ((capture == 'b0) && (update == 'b1)) //update main registers
    begin
        for (i = 0; i < TOTAL_REG; i = i + 1)
        begin
            generator_reg[i] <= update_reg[i];
        end
    end
end

// update registers
always @(posedge updateclk)
begin
    dout_tmp <= update_reg[TOTAL_REG - 1];

    if ((capture == 'b0) && (update == 'b0)) //shift update registers
    begin
        for (i = (TOTAL_REG - 1); i > 0; i = i - 1)
        begin
            update_reg[i] <= update_reg[i - 1];
        end
        update_reg[0] <= din; 
    end
    else if ((capture == 'b1) && (update == 'b0)) //load update registers
    begin
        for (i = 0; i < TOTAL_REG; i = i + 1)
        begin
            update_reg[i] <= generator_reg[i];
        end
    end

end

and (dout, dout_tmp, 1'b1);

endmodule // stratixv_bias_generator

// -----------------------------------------------------------
//
// Module Name : stratixv_bias_block
//
// Description : STRATIXV Bias Block Verilog simulation model
//
// -----------------------------------------------------------

`timescale 1 ps/1 ps

module stratixv_bias_block(
			clk,
			shiftnld,
			captnupdt,
			din,
			dout 
			);

// INPUT PORTS
input  clk;
input  shiftnld;
input  captnupdt;
input  din;
    
// OUTPUTPUT PORTS
output dout;
    
parameter lpm_type = "stratixv_bias_block";
    
// INTERNAL VARIABLES
reg din_viol;
reg shiftnld_viol;
reg captnupdt_viol;

wire mainclk_wire;
wire updateclk_wire;
wire capture_wire;
wire update_wire;
wire dout_tmp;

specify

    $setuphold (posedge clk, din, 0, 0, din_viol) ;
    $setuphold (posedge clk, shiftnld, 0, 0, shiftnld_viol) ;
    $setuphold (posedge clk, captnupdt, 0, 0, captnupdt_viol) ;

    (posedge clk => (dout +: dout_tmp)) = 0 ;

endspecify

stratixv_bias_logic logic_block (
                             .clk(clk),
                             .shiftnld(shiftnld),
                             .captnupdt(captnupdt),
                             .mainclk(mainclk_wire),
                             .updateclk(updateclk_wire),
                             .capture(capture_wire),
                             .update(update_wire)
                             );

stratixv_bias_generator bias_generator (
                                    .din(din),
                                    .mainclk(mainclk_wire),
                                    .updateclk(updateclk_wire),
                                    .capture(capture_wire),
                                    .update(update_wire),
                                    .dout(dout_tmp) 
                                    );

and (dout, dout_tmp, 1'b1);

endmodule // stratixv_bias_block

///////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixv_mac                                    //
//  Description:             Stratix-V MAC                                   //
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixv_mac(
			accumulate,
			aclr,
			ax,
			ay,
			az,
			bx,
			by,
			chainin,
			cin,
			clk,
			coefsela,
			coefselb,
			complex,
			ena,
			loadconst,
			negate,
			scanin,
			sub,

			chainout,
			cout,
			dftout,
			resulta,
			resultb,
			scanout 
		);
//PARAMETERS
parameter lpm_type = "stratixv_mac";

parameter ax_width = 16;
parameter ay_scan_in_width = 16;
parameter az_width = 1;
parameter bx_width = 16;
parameter by_width = 16;
parameter scan_out_width = 1;
parameter result_a_width = 33;
parameter result_b_width = 1;

parameter operation_mode = "m18x18_sumof2";
parameter mode_sub_location = 0;
parameter operand_source_max = "input";
parameter operand_source_may = "input";
parameter operand_source_mbx = "input";
parameter operand_source_mby = "input";
parameter preadder_subtract_a = "false";
parameter preadder_subtract_b = "false";
parameter signed_max = "false";
parameter signed_may = "false";
parameter signed_mbx = "false";
parameter signed_mby = "false";

parameter ay_use_scan_in = "false";
parameter by_use_scan_in = "false";
parameter delay_scan_out_ay = "false";
parameter delay_scan_out_by = "false";
parameter use_chainadder = "false";
parameter [5:0] load_const_value = 6'b0;

parameter signed [26:0] coef_a_0 = 0;
parameter signed [26:0] coef_a_1 = 0;
parameter signed [26:0] coef_a_2 = 0;
parameter signed [26:0] coef_a_3 = 0;
parameter signed [26:0] coef_a_4 = 0;
parameter signed [26:0] coef_a_5 = 0;
parameter signed [26:0] coef_a_6 = 0;
parameter signed [26:0] coef_a_7 = 0;
parameter signed [17:0] coef_b_0 = 0;
parameter signed [17:0] coef_b_1 = 0;
parameter signed [17:0] coef_b_2 = 0;
parameter signed [17:0] coef_b_3 = 0;
parameter signed [17:0] coef_b_4 = 0;
parameter signed [17:0] coef_b_5 = 0;
parameter signed [17:0] coef_b_6 = 0;
parameter signed [17:0] coef_b_7 = 0;

parameter ax_clock = "none";
parameter ay_scan_in_clock = "none";
parameter az_clock = "none";
parameter bx_clock = "none";
parameter by_clock = "none";
parameter coef_sel_a_clock = "none";
parameter coef_sel_b_clock = "none";
parameter sub_clock = "none";
parameter negate_clock = "none";
parameter accumulate_clock = "none";
parameter load_const_clock = "none";
parameter complex_clock = "none";
parameter output_clock = "none";

//INPUT PORTS
input	sub;
input	negate;
input	accumulate;
input	loadconst;
input	complex;
input 	cin;
input	[ax_width-1 : 0]	ax;
input	[ay_scan_in_width-1 : 0]	ay;
input	[ay_scan_in_width-1 : 0]	scanin;
input	[az_width-1 : 0]	az;
input	[bx_width-1 : 0]	bx;
input	[by_width-1 : 0]	by;
input	[2:0] coefsela;
input	[2:0] coefselb;
input	[2:0] clk;
input	[1:0] aclr;
input	[2:0] ena;
input	[63 : 0] chainin;

//OUTPUT PORTS
output	cout;
output	dftout;
output	[result_a_width-1 : 0] resulta;
output	[result_b_width-1 : 0] resultb;
output	[scan_out_width-1 : 0] scanout;
output	[63 : 0] chainout;

stratixv_mac_encrypted	mac_core0
(
	.sub(sub),
	.negate(negate),
	.accumulate(accumulate),
	.loadconst(loadconst),
	.complex(complex),
	.cin(cin),
	.ax(ax),
	.ay(ay),
	.az(az),
	.bx(bx),
	.by(by),
	.scanin(scanin),
	.coefsela(coefsela),
	.coefselb(coefselb),
	.clk(clk),
	.aclr(aclr),
	.ena(ena),
	.chainin(chainin),

	.dftout(dftout),
	.cout(cout), 
	.resulta(resulta),
	.resultb(resultb),
	.scanout(scanout),
	.chainout(chainout)
);
defparam mac_core0.ax_width = ax_width;
defparam mac_core0.ay_scan_in_width = ay_scan_in_width;
defparam mac_core0.az_width = az_width;
defparam mac_core0.bx_width = bx_width;
defparam mac_core0.by_width = by_width;
defparam mac_core0.scan_out_width = scan_out_width;
defparam mac_core0.result_a_width = result_a_width;
defparam mac_core0.result_b_width = result_b_width;

defparam mac_core0.operation_mode = operation_mode;
defparam mac_core0.mode_sub_location = mode_sub_location;
defparam mac_core0.operand_source_max = operand_source_max;
defparam mac_core0.operand_source_may = operand_source_may;
defparam mac_core0.operand_source_mbx = operand_source_mbx;
defparam mac_core0.operand_source_mby = operand_source_mby;
defparam mac_core0.preadder_subtract_a = preadder_subtract_a;
defparam mac_core0.preadder_subtract_b = preadder_subtract_b;
defparam mac_core0.signed_max = signed_max;
defparam mac_core0.signed_may = signed_may;
defparam mac_core0.signed_mbx = signed_mbx;
defparam mac_core0.signed_mby = signed_mby;

defparam mac_core0.ay_use_scan_in = ay_use_scan_in;
defparam mac_core0.by_use_scan_in = by_use_scan_in;
defparam mac_core0.delay_scan_out_ay = delay_scan_out_ay;
defparam mac_core0.delay_scan_out_by = delay_scan_out_by;
defparam mac_core0.use_chainadder = use_chainadder;
defparam mac_core0.load_const_value = load_const_value;

defparam mac_core0.coef_a_0 = coef_a_0;
defparam mac_core0.coef_a_1 = coef_a_1;
defparam mac_core0.coef_a_2 = coef_a_2;
defparam mac_core0.coef_a_3 = coef_a_3;
defparam mac_core0.coef_a_4 = coef_a_4;
defparam mac_core0.coef_a_5 = coef_a_5;
defparam mac_core0.coef_a_6 = coef_a_6;
defparam mac_core0.coef_a_7 = coef_a_7;
defparam mac_core0.coef_b_0 = coef_b_0;
defparam mac_core0.coef_b_1 = coef_b_1;
defparam mac_core0.coef_b_2 = coef_b_2;
defparam mac_core0.coef_b_3 = coef_b_3;
defparam mac_core0.coef_b_4 = coef_b_4;
defparam mac_core0.coef_b_5 = coef_b_5;
defparam mac_core0.coef_b_6 = coef_b_6;
defparam mac_core0.coef_b_7 = coef_b_7;

defparam mac_core0.ax_clock = ax_clock;
defparam mac_core0.ay_scan_in_clock = ay_scan_in_clock;
defparam mac_core0.az_clock = az_clock;
defparam mac_core0.bx_clock = bx_clock;
defparam mac_core0.by_clock = by_clock;
defparam mac_core0.coef_sel_a_clock = coef_sel_a_clock;
defparam mac_core0.coef_sel_b_clock = coef_sel_b_clock;
defparam mac_core0.sub_clock = sub_clock;
defparam mac_core0.negate_clock = negate_clock;
defparam mac_core0.accumulate_clock = accumulate_clock;
defparam mac_core0.load_const_clock = load_const_clock;
defparam mac_core0.complex_clock = complex_clock;
defparam mac_core0.output_clock = output_clock;

endmodule

`timescale 1 ps/1 ps

module    stratixv_clk_phase_select    (
    clkin,
    phasectrlin,
    phaseinvertctrl,
    powerdown,
    clkout);

    parameter    use_phasectrlin    =    "true";
    parameter    phase_setting    =    0;
    parameter    invert_phase    =    "false";
	parameter    physical_clock_source	= "auto";

    input    [3:0]    clkin;
    input    [1:0]    phasectrlin;
    input    phaseinvertctrl;
    input    powerdown;
    output    clkout;

    stratixv_clk_phase_select_encrypted inst (
        .clkin(clkin),
        .phasectrlin(phasectrlin),
        .phaseinvertctrl(phaseinvertctrl),
        .powerdown(powerdown),
        .clkout(clkout) );
    defparam inst.use_phasectrlin = use_phasectrlin;
    defparam inst.phase_setting = phase_setting;
    defparam inst.invert_phase = invert_phase;
    defparam inst.physical_clock_source = physical_clock_source;

endmodule //stratixv_clk_phase_select

`timescale 1 ps/1 ps

module    stratixv_clkena    (
    inclk,
    ena,
    enaout,
    outclk);

// leda G_521_3_B off
    parameter    clock_type    =    "auto";
    parameter    ena_register_mode    =    "always enabled";
    parameter    lpm_type    =    "stratixv_clkena";
    parameter    ena_register_power_up    =    "high";
    parameter    disable_mode    =    "low";
    parameter    test_syn    =    "high";
// leda G_521_3_B on

    input    inclk;
    input    ena;
    output    enaout;
    output    outclk;

    stratixv_clkena_encrypted inst (
        .inclk(inclk),
        .ena(ena),
        .enaout(enaout),
        .outclk(outclk) );
    defparam inst.clock_type = clock_type;
    defparam inst.ena_register_mode = ena_register_mode;
    defparam inst.lpm_type = lpm_type;
    defparam inst.ena_register_power_up = ena_register_power_up;
    defparam inst.disable_mode = disable_mode;
    defparam inst.test_syn = test_syn;

endmodule //stratixv_clkena

`timescale 1 ps/1 ps

module    stratixv_clkselect    (
    inclk,
    clkselect,
    outclk);

// leda G_521_3_B off
    parameter    lpm_type    =    "stratixv_clkselect";
    parameter    test_cff    =    "low";
// leda G_521_3_B on

    input    [3:0]    inclk;
    input    [1:0]    clkselect;
    output   outclk;

    stratixv_clkselect_encrypted inst (
        .inclk(inclk),
        .clkselect(clkselect),
        .outclk(outclk) );
    defparam inst.lpm_type = lpm_type;
    defparam inst.test_cff = test_cff;

endmodule //stratixv_clkselect

`timescale 1 ps/1 ps

module    stratixv_delay_chain    (
    datain,
    delayctrlin,
    dataout);

    parameter    sim_intrinsic_rising_delay    =    200;
    parameter    sim_intrinsic_falling_delay    =    200;
    parameter    sim_rising_delay_increment    =    10;
    parameter    sim_falling_delay_increment    =    10;
    parameter    lpm_type    =    "stratixv_delay_chain";


    input    datain;
    input    [7:0]    delayctrlin;
    output    dataout;

    stratixv_delay_chain_encrypted inst (
        .datain(datain),
        .delayctrlin(delayctrlin),
        .dataout(dataout) );
    defparam inst.sim_intrinsic_rising_delay = sim_intrinsic_rising_delay;
    defparam inst.sim_intrinsic_falling_delay = sim_intrinsic_falling_delay;
    defparam inst.sim_rising_delay_increment = sim_rising_delay_increment;
    defparam inst.sim_falling_delay_increment = sim_falling_delay_increment;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_delay_chain

`timescale 1 ps/1 ps

module    stratixv_dll_offset_ctrl    (
    clk,
    offsetdelayctrlin,
    offset,
    addnsub,
    aload,
    offsetctrlout,
    offsettestout);

    parameter    use_offset    =    "false";
    parameter    static_offset    =    0;
    parameter    use_pvt_compensation    =    "false";


    input    clk;
    input    [6:0]    offsetdelayctrlin;
    input    [6:0]    offset;
    input    addnsub;
    input    aload;
    output    [6:0]    offsetctrlout;
    output    [6:0]    offsettestout;

    stratixv_dll_offset_ctrl_encrypted inst (
        .clk(clk),
        .offsetdelayctrlin(offsetdelayctrlin),
        .offset(offset),
        .addnsub(addnsub),
        .aload(aload),
        .offsetctrlout(offsetctrlout),
        .offsettestout(offsettestout) );
    defparam inst.use_offset = use_offset;
    defparam inst.static_offset = static_offset;
    defparam inst.use_pvt_compensation = use_pvt_compensation;

endmodule //stratixv_dll_offset_ctrl

`timescale 1 ps/1 ps

module    stratixv_dll    (
    aload,
    clk,
    upndnin,
    upndninclkena,
    delayctrlout,
    dqsupdate,
    offsetdelayctrlout,
    offsetdelayctrlclkout,
    upndnout,
    dffin,
    locked);

    parameter    input_frequency    =    "0 MHz";
    parameter    delayctrlout_mode    =    "normal";
    parameter    jitter_reduction    =    "false";
    parameter    use_upndnin    =    "false";
    parameter    use_upndninclkena    =    "false";
    parameter    dual_phase_comparators    =    "true";
    parameter    sim_valid_lock    =    16;
    parameter    sim_valid_lockcount    =    0;
    parameter    sim_buffer_intrinsic_delay    =    175;
    parameter    sim_buffer_delay_increment    =    10;
    parameter    static_delay_ctrl    =    0;
    parameter    lpm_type    =    "stratixv_dll";
    parameter    delay_chain_length    =    8;


    input    aload;
    input    clk;
    input    upndnin;
    input    upndninclkena;
    output    [6:0]    delayctrlout;
    output    dqsupdate;
    output    [6:0]    offsetdelayctrlout;
    output    offsetdelayctrlclkout;
    output    upndnout;
    output    dffin;
    output    locked;	

    stratixv_dll_encrypted inst (
        .aload(aload),
        .clk(clk),
        .upndnin(upndnin),
        .upndninclkena(upndninclkena),
        .delayctrlout(delayctrlout),
        .dqsupdate(dqsupdate),
        .offsetdelayctrlout(offsetdelayctrlout),
        .offsetdelayctrlclkout(offsetdelayctrlclkout),
        .upndnout(upndnout),
        .dffin(dffin),
        .locked(locked));
    defparam inst.input_frequency = input_frequency;
    defparam inst.delayctrlout_mode = delayctrlout_mode;
    defparam inst.jitter_reduction = jitter_reduction;
    defparam inst.use_upndnin = use_upndnin;
    defparam inst.use_upndninclkena = use_upndninclkena;
    defparam inst.dual_phase_comparators = dual_phase_comparators;
    defparam inst.sim_valid_lock = sim_valid_lock;
    defparam inst.sim_valid_lockcount = sim_valid_lockcount;
    defparam inst.sim_buffer_intrinsic_delay = sim_buffer_intrinsic_delay;
    defparam inst.sim_buffer_delay_increment = sim_buffer_delay_increment;
    defparam inst.static_delay_ctrl = static_delay_ctrl;
    defparam inst.lpm_type = lpm_type;
    defparam inst.delay_chain_length = delay_chain_length;

endmodule //stratixv_dll

`timescale 1 ps/1 ps

module    stratixv_dqs_config    (
    datain,
  	clk,
  	ena,
  	update,
	postamblepowerdown,
  	dqsbusoutdelaysetting,
  	dqsbusoutdelaysetting2,
  	dqsinputphasesetting,
  	dqsoutputphasesetting,
  	dqoutputphasesetting,
  	resyncinputphasesetting,
  	enaoctcycledelaysetting,
  	enainputcycledelaysetting,
  	enaoutputcycledelaysetting,
  	dqsenabledelaysetting,
  	octdelaysetting1,
  	octdelaysetting2,
  	enadqsenablephasetransferreg, 
  	enaoctphasetransferreg,       
  	enaoutputphasetransferreg,    
  	enainputphasetransferreg,
	enadqscycledelaysetting,
	enadqsphasetransferreg,
  	resyncinputphaseinvert,         
  	dqoutputphaseinvert,           
  	dqsoutputphaseinvert,           	
  	dataout,
  	resyncinputzerophaseinvert,
  	dqs2xoutputphasesetting,
  	dqs2xoutputphaseinvert,
  	ck2xoutputphasesetting,
    ck2xoutputphaseinvert,
    dq2xoutputphasesetting,
    dq2xoutputphaseinvert,
    postamblephasesetting,
    postamblephaseinvert,
    dividerphaseinvert,
    addrphasesetting, 
    addrphaseinvert,
    dqoutputzerophasesetting,
    postamblezerophasesetting,
    dividerioehratephaseinvert,
    dqsdisablendelaysetting,
    addrpowerdown,
	dqsoutputpowerdown,
	dqoutputpowerdown,
	resyncinputpowerdown,
	dqs2xoutputpowerdown,
	ck2xoutputpowerdown,
	dq2xoutputpowerdown);

    parameter    lpm_type    =    "stratixv_dqs_config";


    // INPUT PORTS
	input        datain;
	input        clk;
	input        ena;
	input        update;
  
	// OUTPUT PORTS                                               
	output       dqoutputpowerdown;
	output       dqsoutputpowerdown;
	output       resyncinputpowerdown;
	output       postamblepowerdown;
	output [5:0] dqsbusoutdelaysetting;         
	output [5:0] dqsbusoutdelaysetting2; // SPR 362735      
	output [1:0] dqsinputphasesetting;  // SPR 362735
	output [1:0] dqsoutputphasesetting; // SPR 362735
	output [1:0] dqoutputphasesetting; // SPR 362735
	output [1:0] resyncinputphasesetting; // SPR 362735
	output [2:0] enaoctcycledelaysetting; // SPR 362735
	output       enainputcycledelaysetting;
	output [2:0] enaoutputcycledelaysetting; // SPR 362735
	output [7:0] dqsenabledelaysetting; // SPR 362735
	output [4:0] octdelaysetting1; // SPR 362735
	output [4:0] octdelaysetting2; // SPR 362735
	output       enadqsenablephasetransferreg; 
	output       enaoctphasetransferreg;        
	output       enaoutputphasetransferreg;    
	output       enainputphasetransferreg;
	output [2:0] enadqscycledelaysetting; // SPR 362735
	output       enadqsphasetransferreg;
	output       resyncinputphaseinvert;         
	output       dqoutputphaseinvert;            
	output       dqsoutputphaseinvert;           
	output       dataout;
	output       resyncinputzerophaseinvert;
	output [1:0] dqs2xoutputphasesetting; // SPR 362735
	output       dqs2xoutputphaseinvert;
	output [1:0] ck2xoutputphasesetting; // SPR 362735
	output       ck2xoutputphaseinvert;
	output [1:0] dq2xoutputphasesetting; // SPR 362735
	output       dq2xoutputphaseinvert;
	output [1:0] postamblephasesetting; // SPR 362735
	output       postamblephaseinvert;
	output [1:0] addrphasesetting; // SPR 362735
	output       addrphaseinvert; 
	output [1:0] dqoutputzerophasesetting; //SPR 362735
	output [2:0] postamblezerophasesetting; //SPR 362735
	output       dividerioehratephaseinvert; // SPR 362735
	output       dividerphaseinvert; // SPR 362735
	output [7:0] dqsdisablendelaysetting; // SPR 362735
	output 		 addrpowerdown;
	output 		 dqs2xoutputpowerdown;
	output		 ck2xoutputpowerdown;
	output	     dq2xoutputpowerdown;

    stratixv_dqs_config_encrypted inst (
    	.datain(datain),
  		.clk(clk),
  		.ena(ena),
  		.update(update),
  		.dqsbusoutdelaysetting(dqsbusoutdelaysetting),
  		.dqsbusoutdelaysetting2(dqsbusoutdelaysetting2),
  		.dqsinputphasesetting(dqsinputphasesetting),
  		.dqsoutputphasesetting(dqsoutputphasesetting),
  		.dqoutputphasesetting(dqoutputphasesetting),
  		.resyncinputphasesetting(resyncinputphasesetting),
  		.enaoctcycledelaysetting(enaoctcycledelaysetting),
  		.enainputcycledelaysetting(enainputcycledelaysetting),
  		.enaoutputcycledelaysetting(enaoutputcycledelaysetting),
  		.dqsenabledelaysetting(dqsenabledelaysetting),
  		.octdelaysetting1(octdelaysetting1),
  		.octdelaysetting2(octdelaysetting2),
  		.enadqsenablephasetransferreg(enadqsenablephasetransferreg), 
  		.enaoctphasetransferreg(enaoctphasetransferreg),       
  		.enaoutputphasetransferreg(enaoutputphasetransferreg),    
  		.enainputphasetransferreg(enainputphasetransferreg),
		.enadqscycledelaysetting(enadqscycledelaysetting),
		.enadqsphasetransferreg(enadqsphasetransferreg),
  		.resyncinputphaseinvert(resyncinputphaseinvert),         
  		.dqoutputphaseinvert(dqoutputphaseinvert),           
  		.dqsoutputphaseinvert(dqsoutputphaseinvert),           	
  		.dataout(dataout),
  		.resyncinputzerophaseinvert(resyncinputzerophaseinvert),
  		.dqs2xoutputphasesetting(dqs2xoutputphasesetting),
  		.dqs2xoutputphaseinvert(dqs2xoutputphaseinvert),
  		.ck2xoutputphasesetting(ck2xoutputphasesetting),
    	.ck2xoutputphaseinvert(ck2xoutputphaseinvert),
    	.dq2xoutputphasesetting(dq2xoutputphasesetting),
    	.dq2xoutputphaseinvert(dq2xoutputphaseinvert),
    	.postamblephasesetting(postamblephasesetting),
    	.postamblephaseinvert(postamblephaseinvert),
    	.dividerphaseinvert(dividerphaseinvert),
    	.addrphasesetting(addrphasesetting), 
    	.addrphaseinvert(addrphaseinvert),
    	.dqoutputzerophasesetting(dqoutputzerophasesetting),
    	.postamblezerophasesetting(postamblezerophasesetting),
    	.dividerioehratephaseinvert(dividerioehratephaseinvert),
    	.dqsdisablendelaysetting(dqsdisablendelaysetting),
    	.addrpowerdown(addrpowerdown),
		.dqsoutputpowerdown(dqsoutputpowerdown),
		.dqoutputpowerdown(dqoutputpowerdown),
		.resyncinputpowerdown(resyncinputpowerdown),
		.dqs2xoutputpowerdown(dqs2xoutputpowerdown),
		.ck2xoutputpowerdown(ck2xoutputpowerdown),
		.dq2xoutputpowerdown(dq2xoutputpowerdown),
		.postamblepowerdown(postamblepowerdown));
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_dqs_config

`timescale 1 ps/1 ps

module    stratixv_dqs_delay_chain    (
    dqsin,
    dqsenable,
    dqsdisablen,
    delayctrlin,
    offsetctrlin,
    dqsupdateen,
    phasectrlin,
    testin,
    dffin,
    dqsbusout);

    parameter    dqs_input_frequency    =    "unused";
    parameter    dqs_phase_shift    =    0;
    parameter    use_phasectrlin    =    "false";
    parameter    phase_setting    =    0;
    parameter    dqs_offsetctrl_enable    =    "false";
    parameter    dqs_ctrl_latches_enable    =    "false";
    parameter    use_alternate_input_for_first_stage_delayctrl    =    "false";
    parameter    sim_buffer_intrinsic_delay    =    175;
    parameter    sim_buffer_delay_increment    =    10;
    parameter    test_enable    =    "false";


    input    dqsin;
    input    dqsenable;
    input    [6:0]    delayctrlin;
    input    [6:0]    offsetctrlin;
    input    dqsupdateen;
    input    [1:0]    phasectrlin;
    input    testin;
    input    dqsdisablen;
    output    dffin;
    output    dqsbusout;

    stratixv_dqs_delay_chain_encrypted inst (
        .dqsin(dqsin),
        .dqsenable(dqsenable),
        .delayctrlin(delayctrlin),
        .offsetctrlin(offsetctrlin),
        .dqsupdateen(dqsupdateen),
        .phasectrlin(phasectrlin),
        .testin(testin),
        .dqsdisablen(dqsdisablen),
        .dffin(dffin),
        .dqsbusout(dqsbusout) );
    defparam inst.dqs_input_frequency = dqs_input_frequency;
    defparam inst.dqs_phase_shift = dqs_phase_shift;
    defparam inst.use_phasectrlin = use_phasectrlin;
    defparam inst.phase_setting = phase_setting;
    defparam inst.dqs_offsetctrl_enable = dqs_offsetctrl_enable;
    defparam inst.dqs_ctrl_latches_enable = dqs_ctrl_latches_enable;
    defparam inst.use_alternate_input_for_first_stage_delayctrl = use_alternate_input_for_first_stage_delayctrl;
    defparam inst.sim_buffer_intrinsic_delay = sim_buffer_intrinsic_delay;
    defparam inst.sim_buffer_delay_increment = sim_buffer_delay_increment;
    defparam inst.test_enable = test_enable;

endmodule //stratixv_dqs_delay_chain

`timescale 1 ps/1 ps

module    stratixv_dqs_enable_ctrl    (
    dqsenablein,
    zerophaseclk,
    enaphasetransferreg,
    levelingclk,
    dffin,
    dffphasetransfer,
    dffextenddqsenable,
    dqsenableout,
    prevphasevalid,
    enatrackingreset,
    enatrackingevent,
    enatrackingupdwn,
    nextphasealign,
    prevphasealign,
    prevphasedelaysetting);

    parameter    bypass_output_register    =    "false";
    parameter    delay_dqs_enable_by_half_cycle    =    "false";
    parameter    add_phase_transfer_reg    =    "false";
    parameter    ext_delay_chain_setting = 0;
    parameter    int_delay_chain_setting = 0;
    parameter    use_enable_tracking = "false";
    parameter    use_on_die_variation_tracking = "false";
    parameter    use_pvt_compensation = "false";
    parameter    sim_dqsenablein_pre_delay = 0;


    input    dqsenablein;
    input    zerophaseclk;
    input    enaphasetransferreg;
    input    levelingclk;
    input    enatrackingreset;
    output    dffin;
    output    dffphasetransfer;
    output    dffextenddqsenable;
    output    dqsenableout;
    output   prevphasevalid; 
    output   enatrackingevent;
    output   enatrackingupdwn;
    output   nextphasealign;
    output   prevphasealign;
    output   [5:0] prevphasedelaysetting;

    stratixv_dqs_enable_ctrl_encrypted inst (
        .dqsenablein(dqsenablein),
        .zerophaseclk(zerophaseclk),
        .enaphasetransferreg(enaphasetransferreg),
        .levelingclk(levelingclk),
        .dffin(dffin),
        .dffphasetransfer(dffphasetransfer),
        .dffextenddqsenable(dffextenddqsenable),
        .dqsenableout(dqsenableout),
        .prevphasevalid(prevphasevalid),
        .enatrackingreset(enatrackingreset),
        .enatrackingevent(enatrackingevent),
        .enatrackingupdwn(enatrackingupdwn),
        .nextphasealign(nextphasealign),
        .prevphasealign(prevphasealign),
        .prevphasedelaysetting(prevphasedelaysetting));
    defparam inst.bypass_output_register = bypass_output_register;
    defparam inst.delay_dqs_enable_by_half_cycle = delay_dqs_enable_by_half_cycle;
    defparam inst.add_phase_transfer_reg = add_phase_transfer_reg;
    defparam inst.sim_dqsenablein_pre_delay = sim_dqsenablein_pre_delay;
    defparam inst.ext_delay_chain_setting = ext_delay_chain_setting;
    defparam inst.int_delay_chain_setting = int_delay_chain_setting;
    defparam inst.use_enable_tracking = use_enable_tracking;
    defparam inst.use_on_die_variation_tracking = use_on_die_variation_tracking;
    defparam inst.use_pvt_compensation = use_pvt_compensation;

endmodule //stratixv_dqs_enable_ctrl

`timescale 1 ps/1 ps

module    stratixv_duty_cycle_adjustment    (
    clkin,
    delaymode,
    delayctrlin,
    clkout);

    parameter    duty_cycle_delay_mode    =    "none";
    parameter    lpm_type    =    "stratixv_duty_cycle_adjustment";


    input    clkin;
    input    delaymode;
    input    [3:0]    delayctrlin;
    output    clkout;

    stratixv_duty_cycle_adjustment_encrypted inst (
        .clkin(clkin),
        .delaymode(delaymode),
        .delayctrlin(delayctrlin),
        .clkout(clkout) );
    defparam inst.duty_cycle_delay_mode = duty_cycle_delay_mode;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_duty_cycle_adjustment

`timescale 1 ps/1 ps
module stratixv_fractional_pll
#(
	// parameter declaration and default value assignemnt
	parameter output_clock_frequency = "",	//Valid values: 
	parameter reference_clock_frequency = "",	//Valid values: 
	parameter mimic_fbclk_type = "cdb_pll_mimic_fbclk_gclk",	//Valid values: gclk|qclk|none
	parameter dsm_accumulator_reset_value = 0,	//Valid values: 0|1
	parameter forcelock = "false",	//Valid values: false|true
	parameter nreset_invert = "false",	//Valid values: false|true
	parameter pll_atb = 0,	//Valid values: 0..15
	parameter pll_bwctrl = 10000,	//Valid values: 18000|16000|14000|12000|10000|8000|6000|4000|2000|1000|500
	parameter pll_cmp_buf_dly = "0 ps",	//Valid values: 0 ps|1000 ps|2000 ps|3000 ps|4000 ps|5000 ps
	parameter pll_cp_comp = "true",	//Valid values: false|true
	parameter pll_cp_current = 20,	//Valid values: 5|10|20|30|40
	parameter pll_ctrl_override_setting = "false",	//Valid values: false|true
	parameter pll_dsm_dither = "disable",	//Valid values: disable|pattern1|pattern2|pattern3
	parameter pll_dsm_out_sel = "disable",	//Valid values: disable|1st_order|2nd_order|3rd_order
	parameter pll_dsm_reset = "false",	//Valid values: false|true
	parameter pll_ecn_bypass = "false",	//Valid values: false|true
	parameter pll_ecn_test_en = "false",	//Valid values: false|true
	parameter pll_enable = "true",	//Valid values: false|true
	parameter pll_fbclk_mux_1 = "glb",	//Valid values: glb|zbd|lvds|fbclk_fpll
	parameter pll_fbclk_mux_2 = "fb_1",	//Valid values: fb_1|m_cnt
	parameter pll_fractional_carry_out = 24,	//Valid values: 8|16|24|32
	parameter pll_fractional_division = 1,	//Valid values: 1..
	parameter pll_fractional_value_ready = "true",	//Valid values: 
	parameter pll_lf_testen = "false",	//Valid values: false|true
	parameter pll_lock_fltr_cfg = 0,	//Valid values: 0..4095
	parameter pll_lock_fltr_test = "false",	//Valid values: false|true
	parameter pll_m_cnt_bypass_en = "false",	//Valid values: false|true
	parameter pll_m_cnt_coarse_dly = "0 ps",	//Valid values: 0 ps|200 ps|400 ps|600 ps|800 ps|1000 ps
	parameter pll_m_cnt_fine_dly = "0 ps",	//Valid values: 0 ps|50 ps|100 ps|150 ps
	parameter pll_m_cnt_hi_div = 1,	//Valid values: 1..256
	parameter pll_m_cnt_in_src = "ph_mux_clk",	//Valid values: ph_mux_clk|fblvds|test_clk|vss
	parameter pll_m_cnt_lo_div = 1,	//Valid values: 1..256
	parameter pll_m_cnt_odd_div_duty_en = "false",	//Valid values: false|true
	parameter pll_m_cnt_ph_mux_prst = 0,	//Valid values: 0..7
	parameter pll_m_cnt_prst = 1,	//Valid values: 1..256
	parameter pll_n_cnt_bypass_en = "false",	//Valid values: false|true
	parameter pll_n_cnt_coarse_dly = "0 ps",	//Valid values: 0 ps|200 ps|400 ps|600 ps|800 ps|1000 ps
	parameter pll_n_cnt_fine_dly = "0 ps",	//Valid values: 0 ps|50 ps|100 ps|150 ps
	parameter pll_n_cnt_hi_div = 1,	//Valid values: 1..256
	parameter pll_n_cnt_lo_div = 1,	//Valid values: 1..256
	parameter pll_n_cnt_odd_div_duty_en = "false",	//Valid values: false|true
	parameter pll_ref_buf_dly = "0 ps",	//Valid values: 0 ps|1000 ps|2000 ps|3000 ps|4000 ps|5000 ps
	parameter pll_reg_boost = 0,	//Valid values: 0|10|15|20|30|40|50|60
	parameter pll_regulator_bypass = "false",	//Valid values: false|true
	parameter pll_ripplecap_ctrl = 0,	//Valid values: 0|2
	parameter pll_slf_rst = "false",	//Valid values: false|true
	parameter pll_tclk_mux_en = "false",	//Valid values: 
	parameter pll_tclk_sel = "cdb_pll_tclk_sel_m_src",	//Valid values: n_src|m_src
	parameter pll_test_enable = "false",	//Valid values: false|true
	parameter pll_testdn_enable = "false",	//Valid values: false|true
	parameter pll_testup_enable = "false",	//Valid values: false|true
	parameter pll_unlock_fltr_cfg = 0,	//Valid values: 0..7
	parameter pll_vco_div = 2,	//Valid values: 1|2
	parameter pll_vco_ph0_en = "false",	//Valid values: false|true
	parameter pll_vco_ph1_en = "false",	//Valid values: false|true
	parameter pll_vco_ph2_en = "false",	//Valid values: false|true
	parameter pll_vco_ph3_en = "false",	//Valid values: false|true
	parameter pll_vco_ph4_en = "false",	//Valid values: false|true
	parameter pll_vco_ph5_en = "false",	//Valid values: false|true
	parameter pll_vco_ph6_en = "false",	//Valid values: false|true
	parameter pll_vco_ph7_en = "false",	//Valid values: false|true
	parameter pll_vctrl_test_voltage = 750,	//Valid values: 0|450|600|750|900|1050|1350|1500
	parameter vccd0g_atb = "disable",	//Valid values: disable|vccregx_vregb|vregs_vregc
	parameter vccd0g_output = 0,	//Valid values: 0|4|8|13|16|-8|-14|-19
	parameter vccd1g_atb = "disable",	//Valid values: disable|vccregx_vregb|vregs_vregc
	parameter vccd1g_output = 0,	//Valid values: 0|4|8|13|16|-8|-14|-19
	parameter vccm1g_tap = 2,	//Valid values: 0..3
	parameter vccr_pd = "false",	//Valid values: false|true
	parameter vcodiv_override = "false"	//Valid values: false|true
)
(
//input and output port declaration
	input [ 0:0 ] coreclkfb,
	input [ 0:0 ] ecnc1test,
	input [ 0:0 ] ecnc2test,
	input [ 0:0 ] fbclkfpll,
	input [ 0:0 ] lvdsfbin,
	input [ 0:0 ] nresync,
	input [ 0:0 ] pfden,
	input [ 0:0 ] refclkin,
	input [ 0:0 ] shift,
	input [ 0:0 ] shiftdonein,
	input [ 0:0 ] shiften,
	input [ 0:0 ] up,
	input [ 0:0 ] vsspl,
	input [ 0:0 ] zdb,
	output [ 0:0 ] cntnen,
	output [ 0:0 ] fbclk,
	output [ 0:0 ] fblvdsout,
	output [ 0:0 ] lock,
	output [ 7:0 ] mhi,
	output [ 0:0 ] mcntout,
	output [ 0:0 ] plniotribuf,
	output [ 0:0 ] shiftdoneout,
	output [ 0:0 ] tclk,
	output [ 7:0 ] vcoph
); 

	stratixv_fractional_pll_encrypted 
	#(
		.output_clock_frequency(output_clock_frequency),
		.reference_clock_frequency(reference_clock_frequency),
		.mimic_fbclk_type(mimic_fbclk_type),
		.dsm_accumulator_reset_value(dsm_accumulator_reset_value),
		.forcelock(forcelock),
		.nreset_invert(nreset_invert),
		.pll_atb(pll_atb),
		.pll_bwctrl(pll_bwctrl),
		.pll_cmp_buf_dly(pll_cmp_buf_dly),
		.pll_cp_comp(pll_cp_comp),
		.pll_cp_current(pll_cp_current),
		.pll_ctrl_override_setting(pll_ctrl_override_setting),
		.pll_dsm_dither(pll_dsm_dither),
		.pll_dsm_out_sel(pll_dsm_out_sel),
		.pll_dsm_reset(pll_dsm_reset),
		.pll_ecn_bypass(pll_ecn_bypass),
		.pll_ecn_test_en(pll_ecn_test_en),
		.pll_enable(pll_enable),
		.pll_fbclk_mux_1(pll_fbclk_mux_1),
		.pll_fbclk_mux_2(pll_fbclk_mux_2),
		.pll_fractional_carry_out(pll_fractional_carry_out),
		.pll_fractional_division(pll_fractional_division),
		.pll_fractional_value_ready(pll_fractional_value_ready),
		.pll_lf_testen(pll_lf_testen),
		.pll_lock_fltr_cfg(pll_lock_fltr_cfg),
		.pll_lock_fltr_test(pll_lock_fltr_test),
		.pll_m_cnt_bypass_en(pll_m_cnt_bypass_en),
		.pll_m_cnt_coarse_dly(pll_m_cnt_coarse_dly),
		.pll_m_cnt_fine_dly(pll_m_cnt_fine_dly),
		.pll_m_cnt_hi_div(pll_m_cnt_hi_div),
		.pll_m_cnt_in_src(pll_m_cnt_in_src),
		.pll_m_cnt_lo_div(pll_m_cnt_lo_div),
		.pll_m_cnt_odd_div_duty_en(pll_m_cnt_odd_div_duty_en),
		.pll_m_cnt_ph_mux_prst(pll_m_cnt_ph_mux_prst),
		.pll_m_cnt_prst(pll_m_cnt_prst),
		.pll_n_cnt_bypass_en(pll_n_cnt_bypass_en),
		.pll_n_cnt_coarse_dly(pll_n_cnt_coarse_dly),
		.pll_n_cnt_fine_dly(pll_n_cnt_fine_dly),
		.pll_n_cnt_hi_div(pll_n_cnt_hi_div),
		.pll_n_cnt_lo_div(pll_n_cnt_lo_div),
		.pll_n_cnt_odd_div_duty_en(pll_n_cnt_odd_div_duty_en),
		.pll_ref_buf_dly(pll_ref_buf_dly),
		.pll_reg_boost(pll_reg_boost),
		.pll_regulator_bypass(pll_regulator_bypass),
		.pll_ripplecap_ctrl(pll_ripplecap_ctrl),
		.pll_slf_rst(pll_slf_rst),
		.pll_tclk_mux_en(pll_tclk_mux_en),
		.pll_tclk_sel(pll_tclk_sel),
		.pll_test_enable(pll_test_enable),
		.pll_testdn_enable(pll_testdn_enable),
		.pll_testup_enable(pll_testup_enable),
		.pll_unlock_fltr_cfg(pll_unlock_fltr_cfg),
		.pll_vco_div(pll_vco_div),
		.pll_vco_ph0_en(pll_vco_ph0_en),
		.pll_vco_ph1_en(pll_vco_ph1_en),
		.pll_vco_ph2_en(pll_vco_ph2_en),
		.pll_vco_ph3_en(pll_vco_ph3_en),
		.pll_vco_ph4_en(pll_vco_ph4_en),
		.pll_vco_ph5_en(pll_vco_ph5_en),
		.pll_vco_ph6_en(pll_vco_ph6_en),
		.pll_vco_ph7_en(pll_vco_ph7_en),
		.pll_vctrl_test_voltage(pll_vctrl_test_voltage),
		.vccd0g_atb(vccd0g_atb),
		.vccd0g_output(vccd0g_output),
		.vccd1g_atb(vccd1g_atb),
		.vccd1g_output(vccd1g_output),
		.vccm1g_tap(vccm1g_tap),
		.vccr_pd(vccr_pd),
		.vcodiv_override(vcodiv_override)

	)
	stratixv_fractional_pll_encrypted_inst	(
		.cntnen(cntnen),
		.coreclkfb(coreclkfb),
		.ecnc1test(ecnc1test),
		.ecnc2test(ecnc2test),
		.fbclkfpll(fbclkfpll),
		.lvdsfbin(lvdsfbin),
		.nresync(nresync),
		.pfden(pfden),
		.refclkin(refclkin),
		.shift(shift),
		.shiftdonein(shiftdonein),
		.shiften(shiften),
		.up(up),
		.vsspl(vsspl),
		.zdb(zdb),
		.fbclk(fbclk),
		.fblvdsout(fblvdsout),
		.lock(lock),
		.mhi(mhi),
		.mcntout(mcntout),
		.plniotribuf(plniotribuf),
		.shiftdoneout(shiftdoneout),
		.tclk(tclk),
		.vcoph(vcoph)
	);

endmodule

`timescale 1 ps/1 ps
module stratixv_pll_dll_output
#(
	// parameter declaration and default value assignemnt
	parameter pll_dll_src = "vss"	//Valid values: c_0_cnt|c_1_cnt|c_2_cnt|c_3_cnt|c_4_cnt|c_5_cnt|c_6_cnt|c_7_cnt|c_8_cnt|c_9_cnt|c_10_cnt|c_11_cnt|c_12_cnt|c_13_cnt|c_14_cnt|c_15_cnt|c_16_cnt|c_17_cnt|clkin_0|clkin_1|clkin_2|clkin_3|vss
)
(
//input and output port declaration
	input [ 17:0 ] cclk,
	input [ 3:0 ] clkin,
	output [ 0:0 ] clkout
); 

	stratixv_pll_dll_output_encrypted 
	#(
		.pll_dll_src(pll_dll_src)

	)
	stratixv_pll_dll_output_encrypted_inst	(
		.cclk(cclk),
		.clkin(clkin),
		.clkout(clkout)
	);


endmodule

`timescale 1 ps/1 ps
module stratixv_pll_dpa_output
#(
	// parameter declaration and default value assignemnt
	parameter output_clock_frequency = "",	//Valid values: 
	parameter pll_vcoph_div = 1	//Valid values: 1|2|4
)
(
//input and output port declaration
	input [ 0:0 ] pd,
	input [ 7:0 ] phin,
	output [ 7:0 ] phout
); 

	stratixv_pll_dpa_output_encrypted 
	#(
		.output_clock_frequency(output_clock_frequency),
		.pll_vcoph_div(pll_vcoph_div)

	)
	stratixv_pll_dpa_output_encrypted_inst	(
		.pd(pd),
		.phin(phin),
		.phout(phout)
	);


endmodule

`timescale 1 ps/1 ps
module stratixv_pll_extclk_output
#(
	// parameter declaration and default value assignemnt
	parameter pll_extclk_cnt_src = "vss",	//Valid values: c_0_cnt|c_1_cnt|c_2_cnt|c_3_cnt|c_4_cnt|c_5_cnt|c_6_cnt|c_7_cnt|c_8_cnt|c_9_cnt|c_10_cnt|c_11_cnt|c_12_cnt|c_13_cnt|c_14_cnt|c_15_cnt|c_16_cnt|c_17_cnt|m0_cnt|m1_cnt|clkin0|clkin1|clkin2|clkin3|vss
	parameter pll_extclk_enable = "true",	//Valid values: false|true
	parameter pll_extclk_invert = "false"	//Valid values: false|true
)
(
//input and output port declaration
	input [ 17:0 ] cclk,
	input [ 0:0 ] clken,
	input [ 0:0 ] mcnt0,
	input [ 0:0 ] mcnt1,
	output [ 0:0 ] extclk
); 

	stratixv_pll_extclk_output_encrypted 
	#(
		.pll_extclk_cnt_src(pll_extclk_cnt_src),
		.pll_extclk_enable(pll_extclk_enable),
		.pll_extclk_invert(pll_extclk_invert)

	)
	stratixv_pll_extclk_output_encrypted_inst	(
		.cclk(cclk),
		.clken(clken),
		.mcnt0(mcnt0),
		.mcnt1(mcnt1),
		.extclk(extclk)
	);


endmodule

`timescale 1 ps/1 ps
module stratixv_pll_lvds_output
#(
	// parameter declaration and default value assignemnt
	parameter pll_loaden_coarse_dly = "0 ps",	//Valid values: 0 ps|200 ps|400 ps|600 ps|800 ps|1000 ps
	parameter pll_loaden_enable_disable = "false",	//Valid values: false|true
	parameter pll_loaden_fine_dly = "0 ps",	//Valid values: 0 ps|50 ps|100 ps|150 ps
	parameter pll_lvdsclk_coarse_dly = "0 ps",	//Valid values: 0 ps|200 ps|400 ps|600 ps|800 ps|1000 ps
	parameter pll_lvdsclk_enable_disable = "false",	//Valid values: false|true
	parameter pll_lvdsclk_fine_dly = "0 ps"	//Valid values: 0 ps|50 ps|100 ps|150 ps
)
(
//input and output port declaration
	input [ 1:0 ] ccout,
	output [ 0:0 ] loaden,
	output [ 0:0 ] lvdsclk
); 

	stratixv_pll_lvds_output_encrypted 
	#(
		.pll_loaden_coarse_dly(pll_loaden_coarse_dly),
		.pll_loaden_enable_disable(pll_loaden_enable_disable),
		.pll_loaden_fine_dly(pll_loaden_fine_dly),
		.pll_lvdsclk_coarse_dly(pll_lvdsclk_coarse_dly),
		.pll_lvdsclk_enable_disable(pll_lvdsclk_enable_disable),
		.pll_lvdsclk_fine_dly(pll_lvdsclk_fine_dly)

	)
	stratixv_pll_lvds_output_encrypted_inst	(
		.ccout(ccout),
		.loaden(loaden),
		.lvdsclk(lvdsclk)
	);


endmodule

`timescale 1 ps/1 ps
module stratixv_pll_output_counter
#(
	// parameter declaration and default value assignemnt
	parameter output_clock_frequency = "",	//Valid values: 
	parameter phase_shift = "",	//Valid values: 
	parameter duty_cycle = 50,	//Valid values: 1..99
	parameter c_cnt_coarse_dly = "0 ps",	//Valid values: 0 ps|200 ps|400 ps|600 ps|800 ps|1000 ps
	parameter c_cnt_fine_dly = "0 ps",	//Valid values: 0 ps|50 ps|100 ps|150 ps
	parameter c_cnt_in_src = "test_clk0",	//Valid values: ph_mux_clk|cscd_clk|test_clk0|test_clk1
	parameter c_cnt_ph_mux_prst = 0,	//Valid values: 0..7
	parameter c_cnt_prst = 1,	//Valid values: 1..256
	parameter cnt_fpll_src = "fpll_0",	//Valid values: fpll_0|fpll_1
	parameter dprio0_cnt_bypass_en = "false",	//Valid values: false|true
	parameter dprio0_cnt_hi_div = 1,	//Valid values: 1..256
	parameter dprio0_cnt_lo_div = 1,	//Valid values: 1..256
	parameter dprio0_cnt_odd_div_even_duty_en = "false",	//Valid values: false|true
	parameter dprio1_cnt_bypass_en = "false",	//Valid values: false|true
	parameter dprio1_cnt_hi_div = 1,	//Valid values: 1..256
	parameter dprio1_cnt_lo_div = 1,	//Valid values: 1..256
	parameter dprio1_cnt_odd_div_even_duty_en = "false"	//Valid values: false|true
)
(
//input and output port declaration
	input [ 0:0 ] cascadein,
	input [ 0:0 ] nen0,
	input [ 0:0 ] nen1,
	input [ 0:0 ] shift0,
	input [ 0:0 ] shift1,
	input [ 0:0 ] shiftdone0i,
	input [ 0:0 ] shiftdone1i,
	input [ 0:0 ] shiften,
	input [ 0:0 ] tclk0,
	input [ 0:0 ] tclk1,
	input [ 0:0 ] up0,
	input [ 0:0 ] up1,
	input [ 7:0 ] vco0ph,
	input [ 7:0 ] vco1ph,
	output [ 0:0 ] cascadeout,
	output [ 0:0 ] divclk,
	output [ 0:0 ] shiftdone0o,
	output [ 0:0 ] shiftdone1o
); 

	stratixv_pll_output_counter_encrypted 
	#(
		.output_clock_frequency(output_clock_frequency),
		.phase_shift(phase_shift),
		.duty_cycle(duty_cycle),
		.c_cnt_coarse_dly(c_cnt_coarse_dly),
		.c_cnt_fine_dly(c_cnt_fine_dly),
		.c_cnt_in_src(c_cnt_in_src),
		.c_cnt_ph_mux_prst(c_cnt_ph_mux_prst),
		.c_cnt_prst(c_cnt_prst),
		.cnt_fpll_src(cnt_fpll_src),
		.dprio0_cnt_bypass_en(dprio0_cnt_bypass_en),
		.dprio0_cnt_hi_div(dprio0_cnt_hi_div),
		.dprio0_cnt_lo_div(dprio0_cnt_lo_div),
		.dprio0_cnt_odd_div_even_duty_en(dprio0_cnt_odd_div_even_duty_en),
		.dprio1_cnt_bypass_en(dprio1_cnt_bypass_en),
		.dprio1_cnt_hi_div(dprio1_cnt_hi_div),
		.dprio1_cnt_lo_div(dprio1_cnt_lo_div),
		.dprio1_cnt_odd_div_even_duty_en(dprio1_cnt_odd_div_even_duty_en)

	)
	stratixv_pll_output_counter_encrypted_inst	(
		.cascadein(cascadein),
		.nen0(nen0),
		.nen1(nen1),
		.shift0(shift0),
		.shift1(shift1),
		.shiftdone0i(shiftdone0i),
		.shiftdone1i(shiftdone1i),
		.shiften(shiften),
		.tclk0(tclk0),
		.tclk1(tclk1),
		.up0(up0),
		.up1(up1),
		.vco0ph(vco0ph),
		.vco1ph(vco1ph),
		.cascadeout(cascadeout),
		.divclk(divclk),
		.shiftdone0o(shiftdone0o),
		.shiftdone1o(shiftdone1o)
	);


endmodule

`timescale 1 ps/1 ps
module stratixv_pll_reconfig
(
//input and output port declaration
	input [ 5:0 ] addr,
	input [ 0:0 ] atpgmode,
	input [ 1:0 ] byteen,
	input [ 0:0 ] clk,
	input [ 0:0 ] cntnen,
	input [ 4:0 ] cntsel,
	input [ 15:0 ] din,
	input [ 0:0 ] fpllcsrtest,
	input [ 0:0 ] iocsrclkin,
	input [ 0:0 ] iocsrdatain,
	input [ 0:0 ] iocsren,
	input [ 0:0 ] iocsrrstn,
	input [ 0:0 ] mdiodis,
	input [ 7:0 ] mhi,
	input [ 0:0 ] phaseen,
	input [ 0:0 ] read,
	input [ 0:0 ] rstn,
	input [ 0:0 ] scanen,
	input [ 0:0 ] sershiftload,
	input [ 0:0 ] shiftdonei,
	input [ 0:0 ] updn,
	input [ 0:0 ] write,
	output [ 0:0 ] blockselect,
	output [ 15:0 ] dout,
	output [ 815:0 ] dprioout,
	output [ 0:0 ] iocsrdataout,
	output [ 0:0 ] iocsrenbuf,
	output [ 0:0 ] iocsrrstnbuf,
	output [ 0:0 ] phasedone,
	output [ 0:0 ] shift,
	output [ 17:0 ] shiften,
	output [ 0:0 ] shiftenm,
	output [ 0:0 ] up
); 

	stratixv_pll_reconfig_encrypted stratixv_pll_reconfig_encrypted_inst
	(
		.addr(addr),
        .atpgmode ( atpgmode ),
		.byteen(byteen),
		.clk(clk),
		.cntnen(cntnen),
		.cntsel(cntsel),
		.din(din),
        .fpllcsrtest ( fpllcsrtest ),
		.iocsrclkin(iocsrclkin),
		.iocsrdatain(iocsrdatain),
		.iocsren(iocsren),
		.iocsrrstn(iocsrrstn),
		.mdiodis(mdiodis),
		.phaseen(phaseen),
		.read(read),
		.rstn(rstn),
		.scanen(scanen),
		.sershiftload(sershiftload),
		.shiftdonei(shiftdonei),
		.updn(updn),
		.write(write),
		.blockselect(blockselect),
		.dout(dout),
		.dprioout(dprioout),
		.iocsrdataout(iocsrdataout),
		.iocsrenbuf(iocsrenbuf),
		.iocsrrstnbuf(iocsrrstnbuf),
		.phasedone(phasedone),
		.shift(shift),
		.shiften(shiften),
		.shiftenm(shiftenm),
		.up(up)
	);

endmodule

`timescale 1 ps/1 ps
module stratixv_pll_refclk_select
#(
	// parameter declaration and default value assignemnt
	parameter pll_auto_clk_sw_en = "false",	//Valid values: false|true
	parameter pll_clk_loss_edge = "both_edges",	//Valid values: both_edges|rising_edge
	parameter pll_clk_loss_sw_en = "false",	//Valid values: false|true
	parameter pll_clk_sw_dly = 0,	//Valid values: 0..7
	parameter pll_clkin_0_src = "ref_clk0",	//Valid values: core_ref_clk|adj_pll_clk|ref_clk0|ref_clk1|clk_0|clk_1|clk_2|clk_3|vss|cmu_iqclk|iqtxrxclk|fpll|pll_iqclk
	parameter pll_clkin_1_src = "ref_clk1",	//Valid values: core_ref_clk|adj_pll_clk|ref_clk0|ref_clk1|clk_0|clk_1|clk_2|clk_3|vss|cmu_iqclk|iqtxrxclk|fpll|pll_iqclk
	parameter pll_manu_clk_sw_en = "false",	//Valid values: false|true
	parameter pll_sw_refclk_src = "clk_0"	//Valid values: clk_0|clk_1
)
(
//input and output port declaration
	input [ 0:0 ] adjpllin,
	input [ 0:0 ] cclk,
	input [ 3:0 ] clkin,
	input [ 0:0 ] coreclkin,
	input [ 0:0 ] extswitch,
	input [ 0:0 ] iqtxrxclkin,
	input [ 0:0 ] plliqclkin,
	input [ 1:0 ] refiqclk,
	input [ 0:0 ] rxiqclkin,
	output [ 0:0 ] clk0bad,
	output [ 0:0 ] clk1bad,
	output [ 0:0 ] clkout,
	output [ 0:0 ] extswitchbuf,
	output [ 0:0 ] pllclksel
); 

	stratixv_pll_refclk_select_encrypted 
	#(
		.pll_auto_clk_sw_en(pll_auto_clk_sw_en),
		.pll_clk_loss_edge(pll_clk_loss_edge),
		.pll_clk_loss_sw_en(pll_clk_loss_sw_en),
		.pll_clk_sw_dly(pll_clk_sw_dly),
		.pll_clkin_0_src(pll_clkin_0_src),
		.pll_clkin_1_src(pll_clkin_1_src),
		.pll_manu_clk_sw_en(pll_manu_clk_sw_en),
		.pll_sw_refclk_src(pll_sw_refclk_src)

	)
	stratixv_pll_refclk_select_encrypted_inst	(
		.adjpllin(adjpllin),
		.cclk(cclk),
		.clkin(clkin),
		.coreclkin(coreclkin),
		.extswitch(extswitch),
		.iqtxrxclkin(iqtxrxclkin),
		.plliqclkin(plliqclkin),
		.refiqclk(refiqclk),
		.rxiqclkin(rxiqclkin),
		.clk0bad(clk0bad),
		.clk1bad(clk1bad),
		.clkout(clkout),
		.extswitchbuf(extswitchbuf),
		.pllclksel(pllclksel)
	);


endmodule

`timescale 1 ps/1 ps

module    stratixv_half_rate_input    (
    datain,
    directin,
    clk,
    areset,
    dataoutbypass,
    dataout,
    dffin);

    parameter    power_up    =    "low";
    parameter    async_mode    =    "no_reset";
    parameter    use_dataoutbypass    =    "false";


    input    [1:0]    datain;
    input    directin;
    input    clk;
    input    areset;
    input    dataoutbypass;
    output    [3:0]    dataout;
    output    [1:0]    dffin;

    stratixv_half_rate_input_encrypted inst (
        .datain(datain),
        .directin(directin),
        .clk(clk),
        .areset(areset),
        .dataoutbypass(dataoutbypass),
        .dataout(dataout),
        .dffin(dffin) );
    defparam inst.power_up = power_up;
    defparam inst.async_mode = async_mode;
    defparam inst.use_dataoutbypass = use_dataoutbypass;

endmodule //stratixv_half_rate_input

`timescale 1 ps/1 ps

module    stratixv_input_phase_alignment    (
    datain,
    levelingclk,
    zerophaseclk,
    areset,
    enainputcycledelay,
    enaphasetransferreg,
    dataout,
    dffin,
    dff1t,
    dffphasetransfer);

    parameter    power_up    =    "low";
    parameter    async_mode    =    "no_reset";
    parameter    add_input_cycle_delay    =    "false";
    parameter    bypass_output_register    =    "false";
    parameter    add_phase_transfer_reg    =    "false";
    parameter    lpm_type    =    "stratixv_input_phase_alignment";


    input    datain;
    input    levelingclk;
    input    zerophaseclk;
    input    areset;
    input    enainputcycledelay;
    input    enaphasetransferreg;
    output    dataout;
    output    dffin;
    output    dff1t;
    output    dffphasetransfer;

    stratixv_input_phase_alignment_encrypted inst (
        .datain(datain),
        .levelingclk(levelingclk),
        .zerophaseclk(zerophaseclk),
        .areset(areset),
        .enainputcycledelay(enainputcycledelay),
        .enaphasetransferreg(enaphasetransferreg),
        .dataout(dataout),
        .dffin(dffin),
        .dff1t(dff1t),
        .dffphasetransfer(dffphasetransfer) );
    defparam inst.power_up = power_up;
    defparam inst.async_mode = async_mode;
    defparam inst.add_input_cycle_delay = add_input_cycle_delay;
    defparam inst.bypass_output_register = bypass_output_register;
    defparam inst.add_phase_transfer_reg = add_phase_transfer_reg;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_input_phase_alignment

`timescale 1 ps/1 ps

module    stratixv_io_clock_divider    (
    clk,
    phaseinvertctrl,
    masterin,
    clkout,
    slaveout);

    parameter    power_up    =    "low";
    parameter    invert_phase    =    "false";
    parameter    use_masterin    =    "false";
    parameter    lpm_type    =    "stratixv_io_clock_divider";


    input    clk;
    input    phaseinvertctrl;
    input    masterin;
    output    clkout;
    output    slaveout;

    stratixv_io_clock_divider_encrypted inst (
        .clk(clk),
        .phaseinvertctrl(phaseinvertctrl),
        .masterin(masterin),
        .clkout(clkout),
        .slaveout(slaveout) );
    defparam inst.power_up = power_up;
    defparam inst.invert_phase = invert_phase;
    defparam inst.use_masterin = use_masterin;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_io_clock_divider

`timescale 1 ps/1 ps

module    stratixv_io_config    (
    datain,
    clk,
    ena,
    update,
    outputdelaysetting1,
    outputdelaysetting2,
    padtoinputregisterdelaysetting,
    padtoinputregisterrisefalldelaysetting,
    inputclkdelaysetting,
    inputclkndelaysetting,
    dutycycledelaymode,
    dutycycledelaysetting,
    dataout);

    parameter    lpm_type    =    "stratixv_io_config";


    input    datain;
    input    clk;
    input    ena;
    input    update;
    output    [5:0] outputdelaysetting1;
    output    [5:0] outputdelaysetting2;
    output    [5:0] padtoinputregisterdelaysetting;
    output    [5:0] padtoinputregisterrisefalldelaysetting;
    output    [1:0] inputclkdelaysetting;
    output    [1:0] inputclkndelaysetting;
    output    dutycycledelaymode;
    output    [3:0] dutycycledelaysetting;
    output    dataout;

    stratixv_io_config_encrypted inst (
        .datain(datain),
        .clk(clk),
        .ena(ena),
        .update(update),
        .outputdelaysetting1(outputdelaysetting1),
        .outputdelaysetting2(outputdelaysetting2),
        .padtoinputregisterdelaysetting(padtoinputregisterdelaysetting),
        .padtoinputregisterrisefalldelaysetting(padtoinputregisterrisefalldelaysetting),
        .inputclkdelaysetting(inputclkdelaysetting),
        .inputclkndelaysetting(inputclkndelaysetting),
        .dutycycledelaymode(dutycycledelaymode),
        .dutycycledelaysetting(dutycycledelaysetting),
        .dataout(dataout) );
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_io_config

`timescale 1 ps/1 ps

module    stratixv_leveling_delay_chain    (
    clkin,
    delayctrlin,
    clkout);

    parameter    physical_clock_source    =    "dqs";
    parameter    sim_buffer_intrinsic_delay    =    175;
    parameter    sim_buffer_delay_increment    =    10;
    parameter    use_duty_cycle_correction = "false";
    parameter    test_mode = "false";

    input    clkin;
    input    [6:0]    delayctrlin;
    output    [3:0]    clkout;

    stratixv_leveling_delay_chain_encrypted inst (
        .clkin(clkin),
        .delayctrlin(delayctrlin),
        .clkout(clkout) );
    //defparam inst.use_duty_cycle_correction = use_duty_cycle_correction;
    defparam inst.physical_clock_source = physical_clock_source;
    defparam inst.sim_buffer_intrinsic_delay = sim_buffer_intrinsic_delay;
    defparam inst.sim_buffer_delay_increment = sim_buffer_delay_increment;

endmodule //stratixv_leveling_delay_chain

`timescale 1 ps/1 ps

module    stratixv_lvds_rx    (
    clock0,
    datain,
    enable0,
    dpareset,
    dpahold,
    dpaswitch,
    fiforeset,
    bitslip,
    bitslipreset,
    serialfbk,
    devclrn,
    devpor,
    dpaclkin,
    dataout,
    dpalock,
    bitslipmax,
    serialdataout,
    postdpaserialdataout,
    divfwdclk,
    dpaclkout,
    observableout);

    parameter    data_align_rollover    =    2;
    parameter    enable_dpa    =    "false";
    parameter    lose_lock_on_one_change    =    "false";
    parameter    reset_fifo_at_first_lock    =    "true";
    parameter    align_to_rising_edge_only    =    "true";
    parameter    use_serial_feedback_input    =    "off";
    parameter    dpa_debug    =    "false";
    parameter    x_on_bitslip    =    "true";
    parameter    enable_soft_cdr    =    "false";
    parameter    dpa_clock_output_phase_shift    =    0;
    parameter    enable_dpa_initial_phase_selection    =    "false";
    parameter    dpa_initial_phase_value    =    0;
    parameter    enable_dpa_align_to_rising_edge_only    =    "false";
    parameter    net_ppm_variation    =    0;
    parameter    is_negative_ppm_drift    =    "false";
    parameter    rx_input_path_delay_engineering_bits    =    2;
    parameter    lpm_type    =    "stratixv_lvds_rx";
    parameter    data_width    =    10;


    input    clock0;
    input    datain;
    input    enable0;
    input    dpareset;
    input    dpahold;
    input    dpaswitch;
    input    fiforeset;
    input    bitslip;
    input    bitslipreset;
    input    serialfbk;
    input    devclrn;
    input    devpor;
    input    [7:0]    dpaclkin;
    output    [data_width-1:0]    dataout;
    output    dpalock;
    output    bitslipmax;
    output    serialdataout;
    output    postdpaserialdataout;
    output    divfwdclk;
    output    dpaclkout;
    output    [3:0]    observableout;

    stratixv_lvds_rx_encrypted inst (
        .clock0(clock0),
        .datain(datain),
        .enable0(enable0),
        .dpareset(dpareset),
        .dpahold(dpahold),
        .dpaswitch(dpaswitch),
        .fiforeset(fiforeset),
        .bitslip(bitslip),
        .bitslipreset(bitslipreset),
        .serialfbk(serialfbk),
        .devclrn(devclrn),
        .devpor(devpor),
        .dpaclkin(dpaclkin),
        .dataout(dataout),
        .dpalock(dpalock),
        .bitslipmax(bitslipmax),
        .serialdataout(serialdataout),
        .postdpaserialdataout(postdpaserialdataout),
        .divfwdclk(divfwdclk),
        .dpaclkout(dpaclkout),
        .observableout(observableout) );
    defparam inst.data_align_rollover = data_align_rollover;
    defparam inst.enable_dpa = enable_dpa;
    defparam inst.lose_lock_on_one_change = lose_lock_on_one_change;
    defparam inst.reset_fifo_at_first_lock = reset_fifo_at_first_lock;
    defparam inst.align_to_rising_edge_only = align_to_rising_edge_only;
    defparam inst.use_serial_feedback_input = use_serial_feedback_input;
    defparam inst.dpa_debug = dpa_debug;
    defparam inst.x_on_bitslip = x_on_bitslip;
    defparam inst.enable_soft_cdr = enable_soft_cdr;
    defparam inst.dpa_clock_output_phase_shift = dpa_clock_output_phase_shift;
    defparam inst.enable_dpa_initial_phase_selection = enable_dpa_initial_phase_selection;
    defparam inst.dpa_initial_phase_value = dpa_initial_phase_value;
    defparam inst.enable_dpa_align_to_rising_edge_only = enable_dpa_align_to_rising_edge_only;
    defparam inst.net_ppm_variation = net_ppm_variation;
    defparam inst.is_negative_ppm_drift = is_negative_ppm_drift;
    defparam inst.rx_input_path_delay_engineering_bits = rx_input_path_delay_engineering_bits;
    defparam inst.lpm_type = lpm_type;
    defparam inst.data_width = data_width;

endmodule //stratixv_lvds_rx

`timescale 1 ps/1 ps

module    stratixv_lvds_tx    (
    datain,
    clock0,
    enable0,
    serialdatain,
    postdpaserialdatain,
    devclrn,
    devpor,
    dpaclkin,
    dataout,
    serialfdbkout,
    observableout);

    parameter    bypass_serializer    =    "false";
    parameter    invert_clock    =    "false";
    parameter    use_falling_clock_edge    =    "false";
    parameter    use_serial_data_input    =    "false";
    parameter    use_post_dpa_serial_data_input    =    "false";
    parameter    is_used_as_outclk    =    "false";
    parameter    tx_output_path_delay_engineering_bits    =    -1;
    parameter    enable_dpaclk_to_lvdsout    =    "false";
    parameter    lpm_type    =    "stratixv_lvds_tx";
    parameter    data_width    =    10;


    input    [data_width-1:0]    datain;
    input    clock0;
    input    enable0;
    input    serialdatain;
    input    postdpaserialdatain;
    input    devclrn;
    input    devpor;
    input    dpaclkin;
    output    dataout;
    output    serialfdbkout;
    output    [2:0]    observableout;

    stratixv_lvds_tx_encrypted inst (
        .datain(datain),
        .clock0(clock0),
        .enable0(enable0),
        .serialdatain(serialdatain),
        .postdpaserialdatain(postdpaserialdatain),
        .devclrn(devclrn),
        .devpor(devpor),
        .dpaclkin(dpaclkin),
        .dataout(dataout),
        .serialfdbkout(serialfdbkout),
        .observableout(observableout) );
    defparam inst.bypass_serializer = bypass_serializer;
    defparam inst.invert_clock = invert_clock;
    defparam inst.use_falling_clock_edge = use_falling_clock_edge;
    defparam inst.use_serial_data_input = use_serial_data_input;
    defparam inst.use_post_dpa_serial_data_input = use_post_dpa_serial_data_input;
    defparam inst.is_used_as_outclk = is_used_as_outclk;
    defparam inst.tx_output_path_delay_engineering_bits = tx_output_path_delay_engineering_bits;
    defparam inst.enable_dpaclk_to_lvdsout = enable_dpaclk_to_lvdsout;
    defparam inst.lpm_type = lpm_type;
    defparam inst.data_width = data_width;

endmodule //stratixv_lvds_tx

`timescale 1 ps/1 ps

module    stratixv_output_alignment    (
    datain,
    clk,
    areset,
    sreset,
    enaoutputcycledelay,
    enaphasetransferreg,
    dataout,
    dffin,
    dff1t,
    dff2t,
    dffphasetransfer);

    parameter    power_up    =    "low";
    parameter    async_mode    =    "none";
    parameter    sync_mode    =    "none";
    parameter    add_output_cycle_delay    =    "false";
    parameter    add_phase_transfer_reg    =    "false";


    input    datain;
    input    clk;
    input    areset;
    input    sreset;
    input [2:0] enaoutputcycledelay;
    input    enaphasetransferreg;
    output    dataout;
    output    dffin;
    output    dff1t;
    output    dff2t;
    output    dffphasetransfer;

    stratixv_output_alignment_encrypted inst (
        .datain(datain),
        .clk(clk),
        .areset(areset),
        .sreset(sreset),
        .enaoutputcycledelay(enaoutputcycledelay),
        .enaphasetransferreg(enaphasetransferreg),
        .dataout(dataout),
        .dffin(dffin),
        .dff1t(dff1t),
        .dff2t(dff2t),
        .dffphasetransfer(dffphasetransfer) );
    defparam inst.power_up = power_up;
    defparam inst.async_mode = async_mode;
    defparam inst.sync_mode = sync_mode;
    defparam inst.add_output_cycle_delay = add_output_cycle_delay;
    defparam inst.add_phase_transfer_reg = add_phase_transfer_reg;

endmodule //stratixv_output_alignment

`timescale 1 ps/1 ps

module    stratixv_termination_logic    (
    s2pload,
    serdata,
    scanenable,
    scanclk,
	enser,
    seriesterminationcontrol,
    parallelterminationcontrol
    );

    parameter    lpm_type    =    "stratixv_termination_logic";
    parameter 	 a_iob_oct_test = "a_iob_oct_test_off";

    input  s2pload;
    input  serdata;
    input  scanenable;
    input  scanclk;
	input enser;

    output [15 : 0] parallelterminationcontrol;
    output [15 : 0] seriesterminationcontrol;

    stratixv_termination_logic_encrypted inst (
        .s2pload(s2pload),
        .serdata(serdata),
        .scanenable(scanenable),
        .scanclk(scanclk),
			.enser(enser),
        .seriesterminationcontrol(seriesterminationcontrol),
        .parallelterminationcontrol(parallelterminationcontrol)
	);
					       
    defparam inst.lpm_type = lpm_type;
    defparam  inst.a_iob_oct_test  = a_iob_oct_test;

endmodule //stratixv_termination_logic

`timescale 1 ps/1 ps

module    stratixv_termination    (
    rzqin,
    enserusr,
    nclrusr,
    clkenusr,
    clkusr,
    scanen,
    serdatafromcore,
    scanclk,
    otherenser,
	 serdatain,
    serdataout,
    enserout,
    compoutrup,
    compoutrdn,
    serdatatocore,
    scanin,
    scanout,
    clkusrdftout);

    parameter lpm_type = "stratixv_termination";
	parameter a_oct_cal_mode = "a_oct_cal_mode_none";
	parameter a_oct_user_oct = "a_oct_user_oct_off";
	parameter a_oct_nclrusr_inv = "a_oct_nclrusr_inv_off";
	parameter a_oct_pwrdn = "a_oct_pwrdn_on";
	parameter a_oct_intosc = "a_oct_intosc_none";
	parameter a_oct_test_0 = "a_oct_test_0_off";
	parameter a_oct_test_1 = "a_oct_test_1_off";
	parameter a_oct_test_4 = "a_oct_test_4_off";
	parameter a_oct_test_5 = "a_oct_test_5_off";
	parameter a_oct_pllbiasen = "a_oct_pllbiasen_dis";
	parameter a_oct_clkenusr_inv = "a_oct_clkenusr_inv_off";
	parameter a_oct_enserusr_inv = "a_oct_enserusr_inv_off";
	parameter a_oct_scanen_inv = "a_oct_scanen_inv_off";
	parameter a_oct_vrefl = "a_oct_vrefl_m";
	parameter a_oct_vrefh = "a_oct_vrefh_m";
	parameter a_oct_rsmult = "a_oct_rsmult_1";
	parameter a_oct_rsadjust = "a_oct_rsadjust_none";
	parameter a_oct_calclr = "a_oct_calclr_off";
	parameter a_oct_rshft_rup = "a_oct_rshft_rup_enable";
	parameter a_oct_rshft_rdn = "a_oct_rshft_rdn_enable";
	parameter a_oct_usermode = "false";

    input rzqin;
    input enserusr;
    input nclrusr;
    input clkenusr;
    input clkusr;
    input scanen;
    input serdatafromcore;
    input serdatain;
    input scanclk;
    input [9 : 0] otherenser;
    output serdataout;
    output enserout;
    output compoutrup;
    output compoutrdn;
    output serdatatocore;
    input scanin;
    output scanout;
    output clkusrdftout;

    stratixv_termination_encrypted inst (
        .rzqin(rzqin),
	.enserusr(enserusr),
    	.nclrusr(nclrusr),
    	.clkenusr(clkenusr),
    	.clkusr(clkusr),
    	.scanen(scanen),
    	.serdatafromcore(serdatafromcore),
    	.scanclk(scanclk),
    	.otherenser(otherenser),
    	.serdataout(serdataout),
    	.enserout(enserout),
    	.compoutrup(compoutrup),
    	.compoutrdn(compoutrdn),
    	.serdatatocore(serdatatocore),
    	.scanin(scanin),
    	.scanout(scanout),
        .clkusrdftout(clkusrdftout));
    defparam inst.lpm_type = lpm_type;
/*
    defparam inst.a_oct_nclrusr_inv = a_oct_nclrusr_inv;
    defparam inst.a_oct_pwrdn = a_oct_pwrdn;
    defparam inst.a_oct_clkdiv = a_oct_clkdiv;
    defparam inst.a_oct_intosc = a_oct_intosc;
    defparam inst.a_oct_vref = a_oct_vref;
    defparam inst.a_oct_test_0 = a_oct_test_0;
    defparam inst.a_oct_test_1 = a_oct_test_1;
    defparam inst.a_oct_test_2 = a_oct_test_2;
    defparam inst.a_oct_test_3 = a_oct_test_3;
    defparam inst.a_oct_test_4 = a_oct_test_4;
    defparam inst.a_oct_test_5 = a_oct_test_5;
    defparam inst.a_oct_pllbiasen = a_oct_pllbiasen;
    defparam inst.a_oct_usermode = a_oct_usermode;
*/
	defparam inst.a_oct_cal_mode = "a_oct_cal_mode_none";
	defparam inst.a_oct_user_oct = "a_oct_user_oct_off";
	defparam inst.a_oct_nclrusr_inv = "a_oct_nclrusr_inv_off";
	defparam inst.a_oct_pwrdn = "a_oct_pwrdn_on";
	defparam inst.a_oct_intosc = "a_oct_intosc_none";
	defparam inst.a_oct_test_0 = "a_oct_test_0_off";
	defparam inst.a_oct_test_1 = "a_oct_test_1_off";
	defparam inst.a_oct_test_4 = "a_oct_test_4_off";
	defparam inst.a_oct_test_5 = "a_oct_test_5_off";
	defparam inst.a_oct_pllbiasen = "a_oct_pllbiasen_dis";
	defparam inst.a_oct_clkenusr_inv = "a_oct_clkenusr_inv_off";
	defparam inst.a_oct_enserusr_inv = "a_oct_enserusr_inv_off";
	defparam inst.a_oct_scanen_inv = "a_oct_scanen_inv_off";
	defparam inst.a_oct_vrefl = "a_oct_vrefl_m";
	defparam inst.a_oct_vrefh = "a_oct_vrefh_m";
	defparam inst.a_oct_rsmult = "a_oct_rsmult_1";
	defparam inst.a_oct_rsadjust = "a_oct_rsadjust_none";
	defparam inst.a_oct_calclr = "a_oct_calclr_off";
	defparam inst.a_oct_rshft_rup = "a_oct_rshft_rup_enable";
	defparam inst.a_oct_rshft_rdn = "a_oct_rshft_rdn_enable";
	defparam inst.a_oct_usermode = "false";
endmodule //stratixv_termination

`timescale 1 ps/1 ps

module    stratixv_asmiblock    (
    dclk,
    sce,
    oe,
    data0out,
    data1out,
    data2out,
    data3out,
    data0oe,
    data1oe,
    data2oe,
    data3oe,
    data0in,
    data1in,
    data2in,
    data3in);

    parameter    lpm_type    =    "stratixv_asmiblock";


    input    dclk;
    input    sce;
    input    oe;
    input    data0out;
    input    data1out;
    input    data2out;
    input    data3out;
    input    data0oe;
    input    data1oe;
    input    data2oe;
    input    data3oe;
    output    data0in;
    output    data1in;
    output    data2in;
    output    data3in;

    stratixv_asmiblock_encrypted inst (
        .dclk(dclk),
        .sce(sce),
        .oe(oe),
        .data0out(data0out),
        .data1out(data1out),
        .data2out(data2out),
        .data3out(data3out),
        .data0oe(data0oe),
        .data1oe(data1oe),
        .data2oe(data2oe),
        .data3oe(data3oe),
        .data0in(data0in),
        .data1in(data1in),
        .data2in(data2in),
        .data3in(data3in) );
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_asmiblock

`timescale 1 ps/1 ps

module    stratixv_chipidblock    (
    clk,
    shiftnld,
    regout);

    parameter    lpm_type    =    "stratixv_chipidblock";


    input    clk;
    input    shiftnld;
    output    regout;

    stratixv_chipidblock_encrypted inst (
        .clk(clk),
        .shiftnld(shiftnld),
        .regout(regout) );
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_chipidblock

`timescale 1 ps/1 ps

module    stratixv_controller    (
    nceout);

    parameter    lpm_type    =    "stratixv_controller";


    output    nceout;

    stratixv_controller_encrypted inst (
        .nceout(nceout) );
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_controller

`timescale 1 ps/1 ps

module    stratixv_crcblock    (
    clk,
    shiftnld,
    crcerror,
    regout);

    parameter    oscillator_divider    =    256;
    parameter    lpm_type    =    "stratixv_crcblock";


    input    clk;
    input    shiftnld;
    output    crcerror;
    output    regout;

    stratixv_crcblock_encrypted inst (
        .clk(clk),
        .shiftnld(shiftnld),
        .crcerror(crcerror),
        .regout(regout) );
    defparam inst.oscillator_divider = oscillator_divider;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_crcblock

`timescale 1 ps/1 ps

module    stratixv_jtag    (
    tms,
    tck,
    tdi,
    ntrst,
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
    usr1user,
    ntrstcore);

    parameter    lpm_type    =    "stratixv_jtag";


    input    tms;
    input    tck;
    input    tdi;
    input    ntrst;
    input    tdoutap;
    input    tdouser;
    output    tdo;
    output    tmsutap;
    output    tckutap;
    output    tdiutap;
    output    shiftuser;
    output    clkdruser;
    output    updateuser;
    output    runidleuser;
    output    usr1user;
    input     ntrstcore;

    stratixv_jtag_encrypted inst (
        .tms(tms),
        .tck(tck),
        .tdi(tdi),
        .ntrst(ntrst),
        .tdoutap(tdoutap),
        .tdouser(tdouser),
        .tdo(tdo),
        .tmsutap(tmsutap),
        .tckutap(tckutap),
        .tdiutap(tdiutap),
        .shiftuser(shiftuser),
        .clkdruser(clkdruser),
        .updateuser(updateuser),
        .runidleuser(runidleuser),
        .usr1user(usr1user) );
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_jtag

`timescale 1 ps/1 ps

module    stratixv_prblock    (
    clk,
    corectl,
    prrequest,
    data,
    externalrequest,
    error,
    ready,
    done);

    parameter    lpm_type    =    "stratixv_prblock";


    input    clk;
    input    corectl;
    input    prrequest;
    input    [15:0]    data;
    output    externalrequest;
    output    error;
    output    ready;
    output    done;

    stratixv_prblock_encrypted inst (
        .clk(clk),
        .corectl(corectl),
        .prrequest(prrequest),
        .data(data),
        .externalrequest(externalrequest),
        .error(error),
        .ready(ready),
        .done(done) );
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_prblock

`timescale 1 ps/1 ps

module    stratixv_rublock    (
    clk,
    shiftnld,
    captnupdt,
    regin,
    rsttimer,
    rconfig,
    regout);

    parameter    sim_init_watchdog_value    =    0;
    parameter    sim_init_status    =    0;
    parameter    sim_init_config_is_application    =    "false";
    parameter    sim_init_watchdog_enabled    =    "false";
    parameter    lpm_type    =    "stratixv_rublock";


    input    clk;
    input    shiftnld;
    input    captnupdt;
    input    regin;
    input    rsttimer;
    input    rconfig;
    output    regout;

    stratixv_rublock_encrypted inst (
        .clk(clk),
        .shiftnld(shiftnld),
        .captnupdt(captnupdt),
        .regin(regin),
        .rsttimer(rsttimer),
        .rconfig(rconfig),
        .regout(regout) );
    defparam inst.sim_init_watchdog_value = sim_init_watchdog_value;
    defparam inst.sim_init_status = sim_init_status;
    defparam inst.sim_init_config_is_application = sim_init_config_is_application;
    defparam inst.sim_init_watchdog_enabled = sim_init_watchdog_enabled;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_rublock

`timescale 1 ps/1 ps

module    stratixv_tsdblock    (
    clk,
    ce,
    clr,
    tsdcalo,
    tsdcaldone);

    parameter    clock_divider_enable    =    "on";
    parameter    clock_divider_value    =    40;
    parameter    sim_tsdcalo    =    0;
    parameter    lpm_type    =    "stratixv_tsdblock";


    input    clk;
    input    ce;
    input    clr;
    output    [7:0]    tsdcalo;
    output    tsdcaldone;

    stratixv_tsdblock_encrypted inst (
        .clk(clk),
        .ce(ce),
        .clr(clr),
        .tsdcalo(tsdcalo),
        .tsdcaldone(tsdcaldone) );
    defparam inst.clock_divider_enable = clock_divider_enable;
    defparam inst.clock_divider_value = clock_divider_value;
    defparam inst.sim_tsdcalo = sim_tsdcalo;
    defparam inst.lpm_type = lpm_type;

endmodule //stratixv_tsdblock

`timescale 1 ps/1 ps

module stratixv_read_fifo (
                           datain,
                           wclk,
                           we,
                           rclk,
                           re,
                           areset,
                           plus2,
                           dataout
                          );

    parameter use_half_rate_read = "false";
    parameter sim_wclk_pre_delay = 0;


    input [1:0] datain; 
    input wclk;
    input we;
    input rclk;
    input re;
    input areset;
    input plus2;

    output [3:0]dataout;

    stratixv_read_fifo_encrypted inst (
    	.datain(datain),
        .wclk(wclk),
        .we(we),
        .rclk(rclk),
        .re(re),
        .areset(areset),
        .plus2(plus2),
        .dataout(dataout));
    defparam inst.use_half_rate_read = use_half_rate_read;
    defparam inst.sim_wclk_pre_delay = sim_wclk_pre_delay;
 
endmodule //stratixv_read_fifo

`timescale 1 ps/1 ps

module stratixv_read_fifo_read_enable (
                           re,
                           rclk,
                           plus2,
                           areset,
                           reout,
                           plus2out
                          );

    parameter use_stalled_read_enable = "false";

    input re;
    input rclk;
    input plus2;
    input areset;

    output reout;
    output plus2out;

    stratixv_read_fifo_read_enable_encrypted inst (
    	.re(re),
    	.rclk(rclk),
    	.plus2(plus2),
    	.areset(areset),
    	.reout(reout),
    	.plus2out(plus2out));
    	
    defparam inst.use_stalled_read_enable = use_stalled_read_enable;
 
endmodule //stratixv_read_fifo_read_enable

`timescale 1 ps/1 ps

module stratixv_phy_clkbuf (
                           inclk,
                           outclk
                          );

    parameter	 level1_mux = "VALUE_FAST";
    parameter 	 level2_mux  = "VALUE_FAST";

    input [3:0] inclk;
    
    output [3:0] outclk;

    stratixv_phy_clkbuf_encrypted inst (
    	.inclk(inclk),
    	.outclk(outclk));
    	
    defparam inst.level1_mux = level1_mux;
    defparam inst.level2_mux = level2_mux;
 
endmodule //stratixv_phy_clkbuf_atom

