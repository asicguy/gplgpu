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

primitive STRATIXIV_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
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

primitive STRATIXIV_PRIM_DFFEAS (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

primitive STRATIXIV_PRIM_DFFEAS_HIGH (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

module stratixiv_dffe ( Q, CLK, ENA, D, CLRN, PRN );
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
   
   STRATIXIV_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
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


// ***** stratixiv_mux21

module stratixiv_mux21 (MO, A, B, S);
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

// ***** stratixiv_mux41

module stratixiv_mux41 (MO, IN0, IN1, IN2, IN3, S);
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

// ***** stratixiv_and1

module stratixiv_and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** stratixiv_and16

module stratixiv_and16 (Y, IN1);
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

// ***** stratixiv_bmux21

module stratixiv_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixiv_b17mux21

module stratixiv_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixiv_nmux21

module stratixiv_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** stratixiv_b5mux21

module stratixiv_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********


//--------------------------------------------------------------------
//
// Module Name : stratixiv_jtag
//
// Description : Stratix JTAG Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixiv_jtag (
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
    usr1user);

input tms;
input tck;
input tdi;
input ntrst;
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

parameter lpm_type = "stratixiv_jtag";

endmodule

//--------------------------------------------------------------------
//
// Module Name : stratixiv_crcblock
//
// Description : Stratix CRCBLOCK Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixiv_crcblock (
    clk,
    shiftnld,
    crcerror,
    regout);

input clk;
input shiftnld;

output crcerror;
output regout;

assign crcerror = 1'b0;
assign regout = 1'b0;

parameter oscillator_divider = 1;
parameter lpm_type = "stratixiv_crcblock";
parameter crc_deld_disable = "off";
parameter error_delay =  0 ;
parameter error_dra_dl_bypass = "off";

endmodule

//------------------------------------------------------------------
//
// Module Name : stratixiv_lcell_comb
//
// Description : STRATIXIV LCELL_COMB Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixiv_lcell_comb (
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
parameter lpm_type = "stratixiv_lcell_comb";

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
// Module Name : stratixiv_routing_wire
//
// Description : Simulation model for a simple routing wire
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixiv_routing_wire (
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

endmodule // stratixiv_routing_wire
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_tx_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for registering the enable inputs.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixiv_lvds_tx_reg (q,
                clk,
                ena,
                d,
                clrn,
                prn
               );

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // BUFFER INPUTS
    wire clk_in;
    wire ena_in;
    wire d_in;

    buf (clk_in, clk);
    buf (ena_in, ena);
    buf (d_in, d);

    // INTERNAL VARIABLES
    reg q_tmp;
    wire q_wire;

    // TIMING PATHS
    specify
       $setuphold(posedge clk, d, 0, 0);
       (posedge clk => (q +: q_tmp)) = (0, 0);
       (negedge clrn => (q +: q_tmp)) = (0, 0);
       (negedge prn => (q +: q_tmp)) = (0, 0);
    endspecify

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q_tmp = 0;

    always @ (posedge clk_in or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q_tmp <= 1;
        else if (clrn == 1'b0)
            q_tmp <= 0;
        else if ((clk_in == 1) & (ena_in == 1'b1))
            q_tmp <= d_in;
    end

    assign q_wire = q_tmp;

    and (q, q_wire, 1'b1);

endmodule // stratixiv_lvds_tx_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_tx_parallel_register
//
// Description : Register for the 10 data input channels of the STRATIXIV
//               LVDS Tx
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_tx_parallel_register (clk,
                                            enable,
                                            datain,
                                            dataout,
                                            devclrn,
                                            devpor
                                           );

    parameter channel_width = 4;

    // INPUT PORTS
    input [channel_width - 1:0] datain;
    input clk;
    input enable;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [channel_width - 1:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg clk_last_value;
    reg [channel_width - 1:0] dataout_tmp;

wire clk_ipd;
wire enable_ipd;
wire [channel_width - 1:0] datain_ipd;

buf buf_clk (clk_ipd,clk);
buf buf_enable (enable_ipd,enable);
buf buf_datain [channel_width - 1:0] (datain_ipd,datain);
wire  [channel_width - 1:0] dataout_opd;

buf buf_dataout  [channel_width - 1:0] (dataout,dataout_opd);
    // TIMING PATHS
    specify
        (posedge clk => (dataout +: dataout_tmp)) = (0, 0);

        $setuphold(posedge clk, datain, 0, 0);

    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 'b0;
    end

    always @(clk_ipd or enable_ipd or devpor or devclrn)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 'b0;
        end
        else begin
            if ((clk_ipd === 1'b1) && (clk_last_value !== clk_ipd))
            begin
                if (enable_ipd === 1'b1)
                begin
                    dataout_tmp <= datain_ipd;
                end
            end
        end

        clk_last_value <= clk_ipd;

    end // always
    assign dataout_opd = dataout_tmp; 

endmodule //stratixiv_lvds_tx_parallel_register

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_tx_out_block
//
// Description : Negative edge triggered register on the Tx output.
//               Also, optionally generates an identical/inverted output clock
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_tx_out_block (clk,
                                    datain,
                                    dataout,
                                    devclrn,
                                    devpor
                                   );

    parameter bypass_serializer = "false";
    parameter invert_clock = "false";
    parameter use_falling_clock_edge = "false";

    // INPUT PORTS
    input datain;
    input clk;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES AND NETS
    reg dataout_tmp;
    reg clk_last_value;

    wire bypass_mode;
    wire invert_mode;
    wire falling_clk_out;

    // BUFFER INPUTS
    wire clk_in;
    wire datain_in;

    buf (clk_in, clk);
    buf (datain_in, datain);

    // TEST PARAMETER VALUES
    assign falling_clk_out = (use_falling_clock_edge == "true")?1'b1:1'b0;
    assign bypass_mode = (bypass_serializer == "true")?1'b1:1'b0;
    assign invert_mode = (invert_clock == "true")?1'b1:1'b0;

    // TIMING PATHS
    specify
        if (bypass_mode == 1'b1)
            (clk => dataout) = (0, 0);

        if (bypass_mode == 1'b0 && falling_clk_out == 1'b1)
            (negedge clk => (dataout +: dataout_tmp)) = (0, 0);

        if (bypass_mode == 1'b0 && falling_clk_out == 1'b0)
            (datain => (dataout +: dataout_tmp)) = (0, 0);

    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 0;
    end

    always @(clk_in or datain_in or devclrn or devpor)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 0;
        end
        else begin
            if (bypass_serializer == "false")
            begin
                if (use_falling_clock_edge == "false")
                    dataout_tmp <= datain_in;

                if ((clk_in === 1'b0) && (clk_last_value !== clk_in))
                begin
                    if (use_falling_clock_edge == "true")
                        dataout_tmp <= datain_in;
                end
            end // bypass is off
            else begin
                // generate clk_out
                if (invert_clock == "false")
                    dataout_tmp <= clk_in;
                else
                    dataout_tmp <= !clk_in;
            end // clk output
        end

        clk_last_value <= clk_in;
    end // always

    and (dataout, dataout_tmp, 1'b1);

endmodule //stratixiv_lvds_tx_out_block

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_transmitter
//
// Description : Timing simulation model for the STRATIXIV LVDS Tx WYSIWYG.
//               It instantiates the following sub-modules :
//               1) primitive DFFE
//               2) STRATIXIV_lvds_tx_parallel_register and
//               3) STRATIXIV_lvds_tx_out_block
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_transmitter (clk0,
                                   enable0,
                                   datain,
                                   serialdatain,
                                   postdpaserialdatain,
                                   dataout,
                                   serialfdbkout,
                                   dpaclkin,
                                   devclrn,
                                   devpor
                                  );

    parameter bypass_serializer              = "false";
    parameter invert_clock                   = "false";
    parameter use_falling_clock_edge         = "false";
    parameter use_serial_data_input          = "false";
    parameter use_post_dpa_serial_data_input = "false";
    parameter is_used_as_outclk            = "false";
    parameter tx_output_path_delay_engineering_bits = -1;
    parameter  enable_dpaclk_to_lvdsout   = "off";
    parameter preemphasis_setting            = 0;
    parameter vod_setting                    = 0;
    parameter differential_drive             = 0;
    parameter lpm_type                       = "stratixiv_lvds_transmitter";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter channel_width                  = 10;

// SIMULATION_ONLY_PARAMETERS_END

    // INPUT PORTS
    input [channel_width - 1:0] datain;
    input clk0;
    input enable0;
    input serialdatain;
    input postdpaserialdatain;
    input devclrn;
    input devpor;
    input dpaclkin;
    // OUTPUT PORTS
    output dataout;
    output serialfdbkout;

    tri1 devclrn;
    tri1 devpor;
    // INTERNAL VARIABLES AND NETS
    integer i;
    wire dataout_tmp;
    wire dataout_wire;
    wire shift_out;
    reg clk0_last_value;
    wire [channel_width - 1:0] input_data;
    reg [channel_width - 1:0] shift_data;
    wire txload0;

    reg [channel_width - 1:0] datain_dly;

    wire bypass_mode;

    wire [channel_width - 1:0] datain_in;
    wire serial_din_mode;
    wire postdpa_serial_din_mode;
    wire enable_dpaclk_to_lvdsout_signal;

    wire clk0_in;
    wire serialdatain_in;
    wire postdpaserialdatain_in;

    buf (clk0_in, clk0);
    buf datain_buf [channel_width - 1:0] (datain_in, datain);
    buf (serialdatain_in, serialdatain);
    buf (postdpaserialdatain_in, postdpaserialdatain);

    // TEST PARAMETER VALUES
    assign serial_din_mode = (use_serial_data_input == "true") ? 1'b1 : 1'b0;
    assign postdpa_serial_din_mode = (use_post_dpa_serial_data_input == "true") ? 1'b1 : 1'b0;
    assign enable_dpaclk_to_lvdsout_signal = (enable_dpaclk_to_lvdsout == "on") ? 1'b1 : 1'b0;

    // TIMING PATHS
    specify
        if (serial_din_mode == 1'b1)
            (serialdatain => dataout) = (0, 0);

        if (postdpa_serial_din_mode == 1'b1)
            (postdpaserialdatain => dataout) = (0, 0);

        if (enable_dpaclk_to_lvdsout_signal   == 1'b1)
               (dpaclkin => dataout) = (0, 0);
    endspecify

    initial
    begin
        i = 0;
        clk0_last_value = 0;
        shift_data = 'b0;
    end

    stratixiv_lvds_tx_reg txload0_reg (.d(enable0),
                             .clrn(1'b1),
                             .prn(1'b1),
                             .ena(1'b1),
                             .clk(clk0_in),
                             .q(txload0)
                            );

    stratixiv_lvds_tx_out_block output_module (.clk(clk0_in),
                                               .datain(shift_out),
                                               .dataout(dataout_tmp),
                                               .devclrn(devclrn),
                                               .devpor(devpor)
                                              );
    defparam output_module.bypass_serializer      = bypass_serializer;
    defparam output_module.invert_clock           = invert_clock;
    defparam output_module.use_falling_clock_edge = use_falling_clock_edge;

    stratixiv_lvds_tx_parallel_register input_reg (.clk(txload0),
                                                   .enable(1'b1),
                                                   .datain(datain_dly),
                                                   .dataout(input_data),
                                                   .devclrn(devclrn),
                                                   .devpor(devpor)
                                                  );
    defparam input_reg.channel_width = channel_width;

    always @(datain_in)
    begin
        datain_dly <= #1 datain_in;
    end

    assign shift_out = shift_data[channel_width - 1];

    always @(clk0_in or devclrn or devpor)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            shift_data <= 'b0;
        end
        else begin
            if (bypass_serializer == "false")
            begin
                if ((clk0_in === 1'b1) && (clk0_last_value !== clk0_in))
                begin
                    if (txload0 === 1'b1)
                    begin
                        for (i = 0; i < channel_width; i = i + 1)
                            shift_data[i] <= input_data[i];
                    end
                    else begin
                        for (i = (channel_width - 1); i > 0; i = i - 1 )
                             shift_data[i] <= shift_data[i-1];
                    end

                end
            end // bypass is off
        end // devpor

        clk0_last_value <= clk0_in;
    end // always

    assign dataout_wire = (use_serial_data_input == "true") ? serialdatain_in :
                          (use_post_dpa_serial_data_input == "true") ? postdpaserialdatain_in :
                           (enable_dpaclk_to_lvdsout == "on") ? dpaclkin:
                           dataout_tmp;

    and (dataout, dataout_wire, 1'b1);
    and (serialfdbkout, dataout_wire, 1'b1);

endmodule // stratixiv_lvds_transmitter
///////////////////////////////////////////////////////////////////////
//
//              	STRATIXIV RUBLOCK ATOM 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  stratixiv_rublock 
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
	parameter lpm_type = "stratixiv_rublock";

	input clk;
	input shiftnld;
	input captnupdt;
	input regin;
	input rsttimer;
	input rconfig;

	output regout;

endmodule


//--------------------------------------------------------------------------
// Module Name     : stratixiv_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_ram_pulse_generator (
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
// Module Name     : stratixiv_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_ram_register (
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
// Module Name     : stratixiv_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module stratixiv_ram_block
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

 parameter enable_ecc = "false";
 parameter width_eccstatus = 3;
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
parameter lpm_type = "stratixiv_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

 parameter mem_init0 = 2048'b0;
 parameter mem_init1 = 2048'b0;
 parameter mem_init2 = 2048'b0;
 parameter mem_init3 = 2048'b0;
 parameter mem_init4 = 2048'b0;
 parameter mem_init5 = 2048'b0;
 parameter mem_init6 = 2048'b0;
 parameter mem_init7 = 2048'b0;
 parameter mem_init8 = 2048'b0;
 parameter mem_init9 = 2048'b0;
 parameter mem_init10 = 2048'b0;
 parameter mem_init11 = 2048'b0;
 parameter mem_init12 = 2048'b0;
 parameter mem_init13 = 2048'b0;
 parameter mem_init14 = 2048'b0;
 parameter mem_init15 = 2048'b0;
 parameter mem_init16 = 2048'b0;
 parameter mem_init17 = 2048'b0;
 parameter mem_init18 = 2048'b0;
 parameter mem_init19 = 2048'b0;
 parameter mem_init20 = 2048'b0;
 parameter mem_init21 = 2048'b0;
 parameter mem_init22 = 2048'b0;
 parameter mem_init23 = 2048'b0;
 parameter mem_init24 = 2048'b0;
 parameter mem_init25 = 2048'b0;
 parameter mem_init26 = 2048'b0;
 parameter mem_init27 = 2048'b0;
 parameter mem_init28 = 2048'b0;
 parameter mem_init29 = 2048'b0;
 parameter mem_init30 = 2048'b0;
 parameter mem_init31 = 2048'b0;
 parameter mem_init32 = 2048'b0;
 parameter mem_init33 = 2048'b0;
 parameter mem_init34 = 2048'b0;
 parameter mem_init35 = 2048'b0;
 parameter mem_init36 = 2048'b0;
 parameter mem_init37 = 2048'b0;
 parameter mem_init38 = 2048'b0;
 parameter mem_init39 = 2048'b0;
 parameter mem_init40 = 2048'b0;
 parameter mem_init41 = 2048'b0;
 parameter mem_init42 = 2048'b0;
 parameter mem_init43 = 2048'b0;
 parameter mem_init44 = 2048'b0;
 parameter mem_init45 = 2048'b0;
 parameter mem_init46 = 2048'b0;
 parameter mem_init47 = 2048'b0;
 parameter mem_init48 = 2048'b0;
 parameter mem_init49 = 2048'b0;
 parameter mem_init50 = 2048'b0;
 parameter mem_init51 = 2048'b0;
 parameter mem_init52 = 2048'b0;
 parameter mem_init53 = 2048'b0;
 parameter mem_init54 = 2048'b0;
 parameter mem_init55 = 2048'b0;
 parameter mem_init56 = 2048'b0;
 parameter mem_init57 = 2048'b0;
 parameter mem_init58 = 2048'b0;
 parameter mem_init59 = 2048'b0;
 parameter mem_init60 = 2048'b0;
 parameter mem_init61 = 2048'b0;
 parameter mem_init62 = 2048'b0;
 parameter mem_init63 = 2048'b0;
 parameter mem_init64 = 2048'b0;
 parameter mem_init65 = 2048'b0;
 parameter mem_init66 = 2048'b0;
 parameter mem_init67 = 2048'b0;
 parameter mem_init68 = 2048'b0;
 parameter mem_init69 = 2048'b0;
 parameter mem_init70 = 2048'b0;
 parameter mem_init71 = 2048'b0;

parameter port_a_byte_size = 0;
parameter port_b_byte_size = 0;

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
 parameter delay_write_pulse_a = (mode_is_dp && mixed_port_feed_through_mode == "dont_care") ? 1'b0 : ((hw_write_mode_a != "FW") ? 1'b1 : 1'b0);
parameter delay_write_pulse_b = (hw_write_mode_b != "FW") ? 1'b1 : 1'b0;
parameter be_mask_write_a     = (port_a_read_during_write_mode == "new_data_with_nbe_read") ? 1'b1 : 1'b0;
parameter be_mask_write_b     = (port_b_read_during_write_mode == "new_data_with_nbe_read") ? 1'b1 : 1'b0;
parameter old_data_write_a     = (port_a_read_during_write_mode == "old_data") ? 1'b1 : 1'b0;
parameter old_data_write_b     = (port_b_read_during_write_mode == "old_data") ? 1'b1 : 1'b0;
parameter read_before_write_a = (hw_write_mode_a == "R+W") ? 1'b1 : 1'b0;
parameter read_before_write_b = (hw_write_mode_b == "R+W") ? 1'b1 : 1'b0;

parameter clock_duty_cycle_dependence = "ON";

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
            mem_init71 , mem_init70 , mem_init69 , mem_init68 , mem_init67 ,
            mem_init66 , mem_init65 , mem_init64 , mem_init63 , mem_init62 ,
            mem_init61 , mem_init60 , mem_init59 , mem_init58 , mem_init57 ,
            mem_init56 , mem_init55 , mem_init54 , mem_init53 , mem_init52 ,
            mem_init51 , mem_init50 , mem_init49 , mem_init48 , mem_init47 ,
            mem_init46 , mem_init45 , mem_init44 , mem_init43 , mem_init42 ,
            mem_init41 , mem_init40 , mem_init39 , mem_init38 , mem_init37 ,
            mem_init36 , mem_init35 , mem_init34 , mem_init33 , mem_init32 ,
            mem_init31 , mem_init30 , mem_init29 , mem_init28 , mem_init27 ,
            mem_init26 , mem_init25 , mem_init24 , mem_init23 , mem_init22 ,
            mem_init21 , mem_init20 , mem_init19 , mem_init18 , mem_init17 ,
            mem_init16 , mem_init15 , mem_init14 , mem_init13 , mem_init12 ,
            mem_init11 , mem_init10 , mem_init9  , mem_init8  , mem_init7  ,
            mem_init6  , mem_init5  ,
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


assign active_write_a = (byteena_a_reg !== 'b0);


assign active_write_b = (byteena_b_reg !== 'b0);

// Store core clock enable value for delayed write
// port A core active
stratixiv_ram_register active_core_port_a (
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
stratixiv_ram_register active_core_port_b (
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
stratixiv_ram_register we_a_register (
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
stratixiv_ram_register re_a_register (
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
stratixiv_ram_register addr_a_register (
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
stratixiv_ram_register datain_a_register (
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
stratixiv_ram_register byteena_a_register (
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

stratixiv_ram_register we_b_register (
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

stratixiv_ram_register re_b_register (
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
stratixiv_ram_register addr_b_register (
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
stratixiv_ram_register datain_b_register (
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
stratixiv_ram_register byteena_b_register (
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
// STRATIXIV
// Write pulse generation
stratixiv_ram_pulse_generator wpgen_a (
       .clk(clk_a_in),
       .ena(active_a_core & active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );
defparam wpgen_a.delay_pulse = delay_write_pulse_a;

stratixiv_ram_pulse_generator wpgen_b (
       .clk(clk_b_in),
       .ena(active_b_core & active_write_b & mode_is_bdp & we_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );
defparam wpgen_b.delay_pulse = delay_write_pulse_b;

// Read pulse generation
stratixiv_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
        .ena(active_a_core & re_a_reg & ~we_a_reg),
        .pulse(read_pulse_a),
       .cycle(clk_a_core)
        );

stratixiv_ram_pulse_generator rpgen_b (
        .clk(clk_b_in),
        .ena((mode_is_dp | mode_is_bdp) & active_b_core & re_b_reg & ~we_b_reg),
        .pulse(read_pulse_b),
       .cycle(clk_b_core)
        );

// Read during write pulse generation
stratixiv_ram_pulse_generator rwpgen_a (
    .clk(clk_a_in),
     .ena(active_a_core & re_a_reg & we_a_reg & read_before_write_a),
    .pulse(rw_pulse_a),.cycle()
);

stratixiv_ram_pulse_generator rwpgen_b (
    .clk(clk_b_in),
     .ena(active_b_core & mode_is_bdp & re_b_reg & we_b_reg & read_before_write_b),
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
stratixiv_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in),
           .ena(active_a_core & ~mode_is_dp & ~old_data_write_a & we_a_reg & re_a_reg),
        .pulse(read_pulse_a_feedthru),.cycle()
        );

stratixiv_ram_pulse_generator ftpgen_b (
        .clk(clk_b_in),
           .ena(active_b_core & mode_is_bdp & ~old_data_write_b & we_b_reg & re_b_reg),
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
 stratixiv_ram_register aclr__a__mux_register (
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
 stratixiv_ram_register aclr__b__mux_register (
        .d(dataout_b_clr),
        .clk(clk_b_core),
        .aclr(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
        .ena(1'b1),
        .q(dataout_b_clr_reg),.aclrout()
        );



// ------- Output registers --------

assign clkena_a_out = (port_a_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

stratixiv_ram_register dataout_a_register (
        .d(dataout_a),
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
                            (dataout_a_clr || dataout_a_clr_reg) ? portadataout_clr : dataout_a
                       );

assign clkena_b_out = (port_b_data_out_clock == "clock0") ?
                       ((clk0_output_clock_enable == "none") ? 1'b1 : ena0_int) :
                       ((clk1_output_clock_enable == "none") ? 1'b1 : ena1_int) ;

stratixiv_ram_register dataout_b_register (
        .d( dataout_b ),
        .clk(clk_b_out),
 .aclr(dataout_b_clr),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(dataout_b_reg),.aclrout()
        );
defparam dataout_b_register.width = port_b_data_width;

 assign portbdataout = (out_b_is_reg) ? dataout_b_reg : (
                          (dataout_b_clr || dataout_b_clr_reg) ? portbdataout_clr : dataout_b
                      );

 assign eccstatus = {width_eccstatus{1'b0}};

endmodule // stratixiv_ram_block




//------------------------------------------------------------------
//
// Module Name : stratixiv_ff
//
// Description : STRATIXIV FF Verilog simulation model 
//
//------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixiv_ff (
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
parameter lpm_type = "stratixiv_ff";

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
// Module Name : stratixiv_clkselect
//
// Description : STRATIXIV CLKSELECT Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixiv_clkselect 
(
    inclk, 
    clkselect, 
    outclk
);
   
input [3:0] inclk;
input [1:0] clkselect;

output outclk;
   
parameter lpm_type = "stratixiv_clkselect";

wire clkmux_out; // output of CLK mux
   
specify

    (inclk[3] => outclk) = (0, 0);
    (inclk[2] => outclk) = (0, 0);
    (inclk[1] => outclk) = (0, 0);
    (inclk[0] => outclk) = (0, 0);

    (clkselect[1] => outclk) = (0, 0);
    (clkselect[0] => outclk) = (0, 0);

endspecify

stratixiv_mux41 clk_mux (
                     .MO(clkmux_out),
                     .IN0(inclk[0]),
                     .IN1(inclk[1]),
                     .IN2(inclk[2]),
                     .IN3(inclk[3]),
                     .S({clkselect[1], clkselect[0]}));

and (outclk, clkmux_out, 1'b1);
   
endmodule

//------------------------------------------------------------------
//
// Module Name : stratixiv_and2
//
// Description : Simulation model for a simple 2-inputs AND gate.
//               This is used for the storing delays for STRATIXIV CLKENA.
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixiv_and2 (
                IN1,
                IN2,
                Y
               );

input IN1;
input IN2;
output Y;

    specify
        (IN1 => Y) = (0, 0);
        (IN2 => Y) = (0, 0);
    endspecify

and (Y, IN1, IN2);

endmodule

//------------------------------------------------------------------
//
// Module Name : stratixiv_ena_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for the gated clock generation.
//               Powers upto 1.
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixiv_ena_reg (
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

assign reset = (!clrn) && (ena);

specify

    $setuphold (posedge clk &&& reset, d, 0, 0, d_viol) ;
      
    (posedge clk => (q +: q_tmp)) = 0 ;
      
endspecify

initial
begin
    q_tmp = 'b1;
    violation = 'b0;
    clk_last_value = clk;
end

    always @ (clk or negedge clrn or negedge prn )
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
        else if ((clk_last_value === 'b0) & (clk === 1'b1) & (ena == 1'b1))
            q_tmp <= d;

        clk_last_value = clk;
    end

and (q, q_tmp, 1'b1);

endmodule // stratixiv_ena_reg

//------------------------------------------------------------------
//
// Module Name : stratixiv_clkena
//
// Description : STRATIXIV CLKENA Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixiv_clkena (
                        inclk, 
                        ena, 
                        devpor, 
                        devclrn, 
                        enaout, 
                        outclk
                        );
   
// INPUT PORTS
input inclk;
input ena; 
input devpor; 
input devclrn; 

// OUTPUT PORTS
output enaout;
output outclk;
   
parameter clock_type = "Auto";
parameter ena_register_mode = "falling edge";
parameter lpm_type = "stratixiv_clkena";

tri1 devclrn;
tri1 devpor;


wire cereg1_out; // output of ENA register1 
wire cereg2_out; // output of ENA register2 
wire ena_out; // choice of registered ENA or none.
   
   
stratixiv_ena_reg extena_reg1(
                    .clk(!inclk),
                    .ena(1'b1),
                    .d(ena),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg1_out)
                   );
   
stratixiv_ena_reg extena_reg2(
                    .clk(!inclk),
                    .ena(1'b1),
                    .d(cereg1_out),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg2_out)
                   );
   
assign ena_out = (ena_register_mode == "falling edge") ? cereg1_out : 
                 ((ena_register_mode == "none") ? ena : cereg2_out);

stratixiv_and2 outclk_and(
                .IN1(inclk),
                .IN2(ena_out),
                .Y(outclk)
                );

stratixiv_and2 enaout_and(
                .IN1(1'b1),
                .IN2(ena_out),
                .Y(enaout)
                );
   
endmodule


//--------------------------------------------------------------------------
// Module Name     : stratixiv_mlab_cell_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_mlab_cell_pulse_generator (
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
wire clk_ipd;

specify
    specparam t_decode = 0,t_access = 0;
    (posedge clk => (pulse +: state)) = (t_decode,t_access);
endspecify

buf #(1) (clk_ipd,clk);
wire  pulse_opd;

buf buf_pulse  (pulse,pulse_opd);

always @(posedge clk_ipd or posedge pulse) 
begin
    if      (pulse) state <= 1'b0;
    else if (ena)   state <= 1'b1;
end

assign cycle = clk_ipd;
assign pulse_opd = state; 

endmodule

`timescale 1 ps/1 ps

//--------------------------------------------------------------------------
// Module Name     : stratixiv_mlab_cell
// Description     : Main RAM module
//--------------------------------------------------------------------------

module stratixiv_mlab_cell
    (
     portadatain,
     portaaddr, 
     portabyteenamasks, 
     portbaddr, 
     clk0,
     ena0, 
     portbdataout
     );
// -------- GLOBAL PARAMETERS ---------

parameter logical_ram_name = "lutram";
 
parameter logical_ram_depth = 0;
parameter logical_ram_width = 0;
parameter first_address = 0;
parameter last_address = 0;
parameter first_bit_number = 0;

parameter init_file = "init_file.hex"; 

parameter data_width = 1;
parameter address_width = 1; 
parameter byte_enable_mask_width = 1; 

parameter lpm_type = "stratixiv_mlab_cell";
parameter lpm_hint = "true";

parameter mem_init0 = 640'b0; // 64x10 OR 32x20

parameter mixed_port_feed_through_mode = "dont_care";

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter byte_size = 1;

// SIMULATION_ONLY_PARAMETERS_END

// LOCAL_PARAMETERS_BEGIN

parameter num_rows = 1 << address_width;
parameter num_cols = 1;
parameter port_byte_size = data_width/byte_enable_mask_width;

// LOCAL_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input [data_width - 1:0] portadatain;
input [address_width - 1:0] portaaddr;
input [byte_enable_mask_width - 1:0] portabyteenamasks;
 
input [address_width - 1:0] portbaddr;

input clk0;
input ena0;

output [data_width - 1:0] portbdataout;

reg ena0_reg;

reg viol_notifier;
wire reset;
assign reset = ena0_reg;

specify
      $setup  (portaaddr,    negedge clk0 &&& reset, 0, viol_notifier);
      $setup  (portabyteenamasks,    negedge clk0 &&& reset, 0, viol_notifier);
      $setup  (ena0, posedge clk0, 0, viol_notifier);
      $hold   (negedge clk0 &&& reset, portaaddr, 0, viol_notifier);
      $hold   (negedge clk0 &&& reset, portabyteenamasks, 0, viol_notifier);
      $hold   (posedge clk0, ena0, 0, viol_notifier);
      (portbaddr *> portbdataout) = (0,0);
endspecify 

// -------- INTERNAL signals ---------
// clock / clock enable
wire clk_a_in;

// Input/Output registers (come from outside MLAB)

// placeholders for read/written data
reg  [data_width - 1:0] read_data_latch;
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

// data output
reg [data_width - 1:0] dataout_b;

initial
begin
    ena0_reg = 1'b0;
    // powerup output to 0
    dataout_b = 'b0;
    for (i = 0; i < num_rows; i = i + 1) mem[i] = 'b0;
    mem_init = mem_init0;
    addr_range_init  = last_address - first_address + 1;
    for (j = 0; j < addr_range_init; j = j + 1)
    begin
        for (k = 0; k < data_width; k = k + 1)
            init_mem_word[k] = mem_init[j*data_width + k];
        mem[j] = init_mem_word;
    end
end

assign clk_a_in = clk0;

always @(posedge clk_a_in) ena0_reg <= ena0;

// Write pulse generation
stratixiv_mlab_cell_pulse_generator wpgen_a (
        .clk(~clk_a_in),
        .ena(ena0_reg),
        .pulse(write_pulse),
	.cycle(write_cycle)
        );

// Read pulse generation
// -- none --

// Create internal masks for byte enable processing
always @(portabyteenamasks)
begin
    for (i = 0; i < data_width; i = i + 1)
    begin
        mask_vector[i]     = (portabyteenamasks[i/port_byte_size] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_int[i] = (portabyteenamasks[i/port_byte_size] === 1'b0) ? 1'b0 : 1'bx;
    end
end

                        
always @(posedge write_pulse) 
begin
    // Write stage 1 : write X to memory
    if (write_pulse) 
    begin
        mem_data = mem[portaaddr] ^ mask_vector_int;
        mem[portaaddr] = mem_data;
    end
end

// Write stage 2 : Write actual data to memory
always @(negedge write_pulse)
begin
    for (i = 0; i < data_width; i = i + 1)
        if (mask_vector[i] == 1'b0)
            mem_data[i] = portadatain[i];
    mem[portaaddr] = mem_data;
end

// Read stage : asynchronous continuous read

assign portbdataout = mem[portbaddr];

endmodule // stratixiv_mlab_cell_block

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixiv_io_ibuf                                 //
//Description:                    Simulation model for STRATIXIV IO Input Buffer    //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module stratixiv_io_ibuf (
                      i,
                      ibar,
                      dynamicterminationcontrol,      
                      o
                     );

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter differential_mode = "false";
parameter bus_hold = "false";
parameter simulate_z_as = "Z";
parameter lpm_type = "stratixiv_io_ibuf";

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
//Module Name:                    stratixiv_io_obuf                                 //
//Description:                    Simulation model for STRATIXIV IO Output Buffer   //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module stratixiv_io_obuf (
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
parameter lpm_type = "stratixiv_io_obuf";

//Input Ports Declaration
input i;
input oe;
input devoe;
input dynamicterminationcontrol; 
input [13:0] seriesterminationcontrol;  
input [13:0] parallelterminationcontrol;  

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
//Module Name:                    stratixiv_ddio_out                                //
//Description:                    Simulation model for STRATIXIV DDIO Output        //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

module stratixiv_ddio_out (
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
parameter lpm_type = "stratixiv_ddio_out";

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
   muxsel_tmp <= mux_sel;		
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
stratixiv_mux21 sel_mux(
                    .MO(dataout),
                    .A(sel_mux_lo_in),
                    .B(sel_mux_hi_in),
                    .S(muxsel_tmp)
                   );

assign muxsel3 = muxsel2;
assign clk3 = clk2;
assign  mux_sel = (use_new_clocking_model == "true")? muxsel3 : clk3;
assign sel_mux_lo_in = sel_mux_lo_in_tmp;
assign sel_mux_hi_in = (half_rate_mode == "true") ? dffhi1_tmp : dffhi_tmp;  

endmodule

//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixiv_ddio_oe                                 //
//Description:                    Simulation model for STRATIXIV DDIO OE            //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
module stratixiv_ddio_oe (
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
parameter lpm_type = "stratixiv_ddio_oe";

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
stratixiv_mux21 or_gate(
                    .MO(dataout),
                    .A(dffhi_tmp),
                    .B(dfflo_tmp),
                    .S(dfflo_tmp)
                   );
assign dfflo = dfflo_tmp;
assign dffhi = dffhi_tmp;

endmodule

////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixiv_ddio_in                                 
//Description:                    Simulation model for STRATIXIV DDIO IN            
//                                                                              
////////////////////////////////////////////////////////////////////////////////
                                                                                
                                                                                
module stratixiv_ddio_in (                                                          
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
parameter lpm_type = "stratixiv_ddio_in";                                           
                                                                                
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
///////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_mac_register                              //
//  Description:             STRATIXIV MAC variable width register               //
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_mac_register (
                           datain,
                           clk,
                           aclr,
                           sload,
                           bypass_register,
                           dataout
                          );


//PARAMETER
parameter data_width = 18;

//INPUT PORTS
input[data_width -1 :0]  datain;
input                     clk;
input                     aclr;
input                     sload;
input                    bypass_register;

//OUTPUT PORTS
output [data_width -1 :0] dataout;

//INTERNAL SIGNALS
reg     [data_width -1:0] dataout_tmp;
reg     viol_notifier;
reg prev_clk_val;

//TIMING SPECIFICATION
specify
    specparam TSU           = 0;          // Set up time
    specparam TH            = 0;          // Hold time
    specparam TCO           = 0;          // Clock to Output time
    specparam TCLR          = 0;          // Clear time
    specparam TCLR_MIN_PW   = 0;          // Minimum pulse width of clear
    specparam TPRE          = 0;          // Preset time
    specparam TPRE_MIN_PW   = 0;          // Minimum pulse width of preset
    specparam TCLK_MIN_PW   = 0;          // Minimum pulse width of clock
    specparam TCE_MIN_PW    = 0;          // Minimum pulse width of clock enable
    specparam TCLKL         = 0;          // Minimum clock low time
    specparam TCLKH         = 0;           // Minimum clock high time

    $setup  (datain, posedge clk, 0, viol_notifier);
    $hold   (posedge clk, datain, 0, viol_notifier);
    $setup  (sload, posedge clk, 0, viol_notifier );
    $hold   (posedge clk, sload, 0, viol_notifier );
    (posedge aclr => (dataout  +: 'b0))          = (0,0);
    (posedge clk  => (dataout  +: dataout_tmp))  = (0,0);
endspecify

initial
    begin
      dataout_tmp = 0;
      prev_clk_val = 1'b0;
    end

always @(clk or posedge aclr or bypass_register or datain)
begin
    if(bypass_register == 1'b1)
        dataout_tmp <= datain;
    else
        begin
            if  (aclr == 1'b1)
                dataout_tmp <= 0;
            else if (prev_clk_val == 1'b0 && clk == 1'b1)
                begin
                    if(sload == 1'b1)
                        dataout_tmp <= datain;
                    else
                        dataout_tmp <= dataout_tmp;
                end
        end
    prev_clk_val = clk;
end

assign dataout = dataout_tmp;
endmodule

///////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_mac_multiplier                            //
//  Description:             STRATIXIV MAC signed multiplier                     //
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_mac_multiplier (
                             dataa,
                             datab,
                             signa,
                             signb,
                             dataout
                            );
//PARAMETER
parameter dataa_width   = 18;
parameter datab_width   = 18;
parameter dataout_width = dataa_width + datab_width;

//INPUT PORTS
input [dataa_width-1:0] dataa;
input [datab_width-1:0] datab;
input                    signa;
input                    signb;

//OUTPUT PORTS
output [dataout_width -1 :0]   dataout;

//INTERNAL SIGNALS
wire [dataout_width -1:0]       product;             //product of dataa and datab
wire [dataout_width -1:0]       abs_product;         //|product| of dataa and datab
wire [dataa_width-1:0]          abs_a;               //absolute value of dataa
wire [datab_width-1:0]          abs_b;               //absolute value of dadab
wire                            product_sign;        // product sign bit
wire                            dataa_sign;          //dataa sign bit
wire                            datab_sign;          //datab sign bit


//TIMING SPECIFICATION
specify
    (dataa *> dataout)              = (0, 0);
    (datab *> dataout)              = (0, 0);
    (signa *> dataout)              = (0, 0);
    (signb *> dataout)              = (0, 0);
endspecify

//Outputassignment

assign dataa_sign   = dataa[dataa_width-1] && signa;
assign datab_sign   = datab[datab_width-1] && signb;
assign product_sign = dataa_sign ^ datab_sign;
assign abs_a        = dataa_sign ? (~dataa + 1'b1) : dataa;
assign abs_b        = datab_sign ? (~datab + 1'b1) : datab;
assign abs_product  = abs_a * abs_b;
assign product      = product_sign ? (~abs_product + 1) : abs_product;
assign dataout = product;


endmodule


//////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_mac_mult_atom                                //
//  Description:             Simulation model for stratixiv mac mult atom.          //
//                           This model instantiates the following components.  //
//                              1.stratixiv_mac_register.                           //
//                              2.stratixiv_mac_multiplier.                         //
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_mac_mult(
                      dataa,
                      datab,
                      signa,
                      signb,
                      clk,
                      aclr,
                      ena,
                      dataout,
                      scanouta,
                      devclrn,
                      devpor
                     );

//PARAMETERS
parameter dataa_width       = 18;
parameter datab_width       = 18;
parameter dataa_clock       = "none";
parameter datab_clock       = "none";
parameter signa_clock       = "none";
parameter signb_clock       = "none";
parameter scanouta_clock    = "none";
parameter dataa_clear       = "none";
parameter datab_clear       = "none";
parameter signa_clear       = "none";
parameter signb_clear       = "none";
parameter scanouta_clear    = "none";
parameter signa_internally_grounded   = "false";
parameter signb_internally_grounded   = "false";

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter dataout_width = dataa_width + datab_width;

// SIMULATION_ONLY_PARAMETERS_END

parameter lpm_type = "stratixiv_mac_mult";

//INPUT PORTS
input [dataa_width-1:0]  dataa;
input [datab_width-1:0]  datab;
input                     signa;
input                     signb;
input [3:0]               clk;
input [3:0]               aclr;
input [3:0]               ena;

input                     devclrn;
input                     devpor;

//OUTPUT PORTS
output [dataout_width-1:0] dataout;
output [dataa_width-1:0] scanouta;

tri1 devclrn;
tri1 devpor;

//Internal signals to instantiate the dataa input register unit
wire [3:0] dataa_clk_value;
wire [3:0] dataa_aclr_value;
wire dataa_clk;
wire dataa_aclr;
wire dataa_sload;
wire dataa_bypass_register;
wire [dataa_width-1:0] dataa_in_reg;


//Internal signals to instantiate the datab input register unit
wire [3:0] datab_clk_value;
wire [3:0] datab_aclr_value;
wire datab_clk;
wire datab_aclr;
wire datab_sload;
wire datab_bypass_register;
wire [datab_width-1:0] datab_in_reg;

//Internal signals to instantiate the signa input register unit
wire [3:0] signa_clk_value;
wire [3:0] signa_aclr_value;
wire signa_clk;
wire signa_aclr;
wire signa_sload;
wire signa_bypass_register;
wire signa_in_reg;

//Internal signbls to instantiate the signb input register unit
wire [3:0] signb_clk_value;
wire [3:0] signb_aclr_value;
wire signb_clk;
wire signb_aclr;
wire signb_sload;
wire signb_bypass_register;
wire signb_in_reg;

//Internal scanoutals to instantiate the scanouta input register unit
wire [3:0] scanouta_clk_value;
wire [3:0] scanouta_aclr_value;
wire scanouta_clk;
wire scanouta_aclr;
wire scanouta_sload;
wire scanouta_bypass_register;
wire [dataa_width -1 :0] scanouta_in_reg;

//Internal Signals to instantiate the mac multiplier
wire signa_mult;
wire signb_mult;


//Instantiate the dataa input Register
stratixiv_mac_register dataa_input_register (
                                         .datain(dataa),
                                         .clk(dataa_clk),
                                         .aclr(dataa_aclr),
                                         .sload(dataa_sload),
                                         .bypass_register(dataa_bypass_register),
                                         .dataout(dataa_in_reg)
                                        );

defparam dataa_input_register.data_width = dataa_width;

//decode the clk and aclr values
assign dataa_clk_value = (dataa_clock == "0") ? 4'b0000 :
                         (dataa_clock == "1") ? 4'b0001 :
                         (dataa_clock == "2") ? 4'b0010 :
                         (dataa_clock == "3") ? 4'b0011 : 4'b0000;

assign dataa_aclr_value =(dataa_clear == "0")  ? 4'b0000 :
                         (dataa_clear == "1") ? 4'b0001 :
                         (dataa_clear == "2") ? 4'b0010 :
                         (dataa_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign dataa_clk = clk[dataa_clk_value] ? 1'b1 : 1'b0;
assign dataa_aclr = aclr[dataa_aclr_value] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign dataa_sload = ena[dataa_clk_value] ? 1'b1 : 1'b0;
assign dataa_bypass_register = (dataa_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the datab input Register
stratixiv_mac_register datab_input_register (
                                         .datain(datab),
                                         .clk(datab_clk),
                                         .aclr(datab_aclr),
                                         .sload(datab_sload),
                                         .bypass_register(datab_bypass_register),
                                         .dataout(datab_in_reg)
                                        );

defparam datab_input_register.data_width = datab_width;

//decode the clk and aclr values
assign datab_clk_value = (datab_clock == "0") ? 4'b0000 :
                           (datab_clock == "1") ? 4'b0001 :
                           (datab_clock == "2") ? 4'b0010 :
                           (datab_clock == "3") ? 4'b0011 : 4'b0000;

assign datab_aclr_value = (datab_clear == "0")  ? 4'b0000 :
                           (datab_clear == "1") ? 4'b0001 :
                           (datab_clear == "2") ? 4'b0010 :
                           (datab_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign datab_clk = clk[datab_clk_value] ? 1'b1 : 1'b0;
assign datab_aclr = aclr[datab_aclr_value] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign datab_sload = ena[datab_clk_value] ? 1'b1 : 1'b0;
assign datab_bypass_register = (datab_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the signa input Register
stratixiv_mac_register signa_input_register (
                                         .datain(signa),
                                         .clk(signa_clk),
                                         .aclr(signa_aclr),
                                         .sload(signa_sload),
                                         .bypass_register(signa_bypass_register),
                                         .dataout(signa_in_reg)
                                         );

defparam signa_input_register.data_width = 1;

//decode the clk and aclr values
assign signa_clk_value =(signa_clock == "0") ? 4'b0000 :
                          (signa_clock == "1") ? 4'b0001 :
                          (signa_clock == "2") ? 4'b0010 :
                          (signa_clock == "3") ? 4'b0011 : 4'b0000;

assign signa_aclr_value = (signa_clear == "0")  ? 4'b0000 :
                           (signa_clear == "1") ? 4'b0001 :
                           (signa_clear == "2") ? 4'b0010 :
                           (signa_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signa_clk = clk[signa_clk_value] ? 1'b1 : 1'b0;
assign signa_aclr = aclr[signa_aclr_value] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign signa_sload = ena[signa_clk_value] ? 1'b1 : 1'b0;
assign signa_bypass_register = (signa_clock == "none") ? 1'b1 : 1'b0;


//Instantiate the signb input Register
stratixiv_mac_register signb_input_register (
                                         .datain(signb),
                                         .clk(signb_clk),
                                         .aclr(signb_aclr),
                                         .sload(signb_sload),
                                         .bypass_register(signb_bypass_register),
                                         .dataout(signb_in_reg)
                                        );

defparam signb_input_register.data_width = 1;

//decode the clk and aclr values
assign signb_clk_value =(signb_clock == "0") ? 4'b0000 :
                        (signb_clock == "1") ? 4'b0001 :
                        (signb_clock == "2") ? 4'b0010 :
                        (signb_clock == "3") ? 4'b0011 : 4'b0000;

assign signb_aclr_value =  (signb_clear == "0")  ? 4'b0000 :
                           (signb_clear == "1") ? 4'b0001 :
                           (signb_clear == "2") ? 4'b0010 :
                           (signb_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signb_clk = clk[signb_clk_value] ? 1'b1 : 1'b0;
assign signb_aclr = aclr[signb_aclr_value] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign signb_sload = ena[signb_clk_value] ? 1'b1 : 1'b0;
assign signb_bypass_register = (signb_clock == "none") ? 1'b1 : 1'b0;


//Instantiate the scanouta input Register
stratixiv_mac_register scanouta_input_register (
                                             .datain(dataa_in_reg),
                                             .clk(scanouta_clk),
                                             .aclr(scanouta_aclr),
                                             .sload(scanouta_sload),
                                             .bypass_register(scanouta_bypass_register),
                                             .dataout(scanouta)
                                             );

defparam scanouta_input_register.data_width = dataa_width;

//decode the clk and aclr values
assign scanouta_clk_value =(scanouta_clock == "0") ? 4'b0000 :
                           (scanouta_clock == "1") ? 4'b0001 :
                           (scanouta_clock == "2") ? 4'b0010 :
                           (scanouta_clock == "3") ? 4'b0011 : 4'b0000;

assign scanouta_aclr_value = (scanouta_clear == "0")  ? 4'b0000 :
                             (scanouta_clear == "1") ? 4'b0001 :
                             (scanouta_clear == "2") ? 4'b0010 :
                             (scanouta_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign scanouta_clk = clk[scanouta_clk_value] ? 1'b1 : 1'b0;
assign scanouta_aclr = aclr[scanouta_aclr_value] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign scanouta_sload = ena[scanouta_clk_value] ? 1'b1 : 1'b0;
assign scanouta_bypass_register = (scanouta_clock == "none") ? 1'b1 : 1'b0;

//Instantiate mac_multiplier block
stratixiv_mac_multiplier mac_multiplier (
                                     .dataa(dataa_in_reg),
                                     .datab(datab_in_reg),
                                     .signa(signa_mult),
                                     .signb(signb_mult),
                                     .dataout(dataout)
                                    );

defparam mac_multiplier.dataa_width = dataa_width;
defparam mac_multiplier.datab_width = datab_width;

assign    signa_mult = (signa_internally_grounded == "true")? 1'b0 : signa_in_reg;
assign    signb_mult = (signb_internally_grounded == "true")? 1'b0 : signb_in_reg;
endmodule



//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_fsa_isse                                                     //
//  Description:             STRATIXIV first stage adder input selection and sign extension block.  //
//////////////////////////////////////////////////////////////////////////////////////////////////
module stratixiv_fsa_isse(
                       dataa,
                       datab,
                       datac,
                       datad,
                       chainin,
                       signa,
                       signb,
                       dataa_out,
                       datab_out,
                       datac_out,
                       datad_out,
                       chainin_out,
                       operation
                      );
parameter dataa_width = 36;
parameter datab_width = 36;
parameter datac_width = 36;
parameter datad_width = 36;
parameter chainin_width = 44;
parameter operation_mode = "output_only";
parameter multa_signa_internally_grounded = "false";
parameter multa_signb_internally_grounded = "false";
parameter multb_signa_internally_grounded = "false";
parameter multb_signb_internally_grounded = "false";
parameter multc_signa_internally_grounded = "false";
parameter multc_signb_internally_grounded = "false";
parameter multd_signa_internally_grounded = "false";
parameter multd_signb_internally_grounded = "false";

input [dataa_width -1:0] dataa;
input [datab_width -1:0] datab;
input [datac_width -1:0] datac;
input [datad_width -1:0] datad;
input [chainin_width -1 :0] chainin;
input signa;
input signb;

output [71:0] dataa_out;
output [71:0] datab_out;
output [71:0] datac_out;
output [71:0] datad_out;
output [71:0] chainin_out;
output [3:0] operation;

wire sign;
wire [71:0] datab_out_fun;
wire [71:0] datac_out_fun;
wire [71:0] datad_out_fun;
wire [71:0] datab_out_tim;
wire [71:0] datac_out_tim;
wire [71:0] datad_out_tim;


assign sign = signa | signb;

//Decode the operation value depending on the mode of operation
assign   operation =  (operation_mode == "output_only")                ? 4'b0000 :
                      (operation_mode == "one_level_adder")            ? 4'b0001 :
                      (operation_mode == "loopback")                   ? 4'b0010 :
                      (operation_mode == "accumulator")                ? 4'b0011 :
                      (operation_mode == "accumulator_chain_out")      ? 4'b0100 :
                      (operation_mode == "two_level_adder")            ? 4'b0101 :
                      (operation_mode == "two_level_adder_chain_out")  ? 4'b0110 :
                      (operation_mode == "36_bit_multiply")            ? 4'b0111 :
                      (operation_mode == "shift")                      ? 4'b1000 :
                      (operation_mode == "double")                      ? 4'b1001 : 4'b0000;
                      
wire active_signb, active_signc, active_signd;
wire read_new_param;

assign read_new_param = (  multa_signa_internally_grounded == "false" && multa_signb_internally_grounded == "false" 
                        && multb_signa_internally_grounded == "false" && multb_signb_internally_grounded == "false" 
                        && multc_signa_internally_grounded == "false" && multc_signb_internally_grounded == "false"
                        && multd_signa_internally_grounded == "false" && multd_signb_internally_grounded == "false") ? 1'b0 : 1'b1;

assign active_signb = ((operation_mode == "36_bit_multiply") ||(operation_mode == "shift") || (operation_mode == "double")) ? 
                      ((multb_signb_internally_grounded == "false" && multb_signa_internally_grounded == "true") ? signb 
                     :((multb_signb_internally_grounded == "true" && multb_signa_internally_grounded == "false" )? signa 
                     :((multb_signb_internally_grounded == "false" && multb_signa_internally_grounded == "false")? sign : 1'b0)))
                     : sign; 

assign active_signc = ((operation_mode == "36_bit_multiply") ||(operation_mode == "shift") || (operation_mode == "double")) ? 
                      ((multc_signb_internally_grounded == "false" && multc_signa_internally_grounded == "true") ? signb 
                     :((multc_signb_internally_grounded == "true" && multc_signa_internally_grounded == "false" )? signa 
                     :((multc_signb_internally_grounded == "false" && multc_signa_internally_grounded == "false")? sign : 1'b0)))
                     : sign; 

assign active_signd = ((operation_mode == "36_bit_multiply") ||(operation_mode == "shift") || (operation_mode == "double")) ? 
                      ((multd_signb_internally_grounded == "false" && multd_signa_internally_grounded == "true") ? signb 
                     :((multd_signb_internally_grounded == "true" && multd_signa_internally_grounded == "false" )? signa 
                     :((multd_signb_internally_grounded == "false" && multd_signa_internally_grounded == "false")? sign : 1'b0)))
                     : sign; 
                                          
assign dataa_out = (dataa[dataa_width-1]&& sign)
                  ?{{(72-dataa_width){1'b1}},dataa[dataa_width -1 : 0]}
                  :{{(72-dataa_width){1'b0}},dataa[dataa_width -1 : 0]} ;
                                   
assign datab_out_tim = (datab[datab_width-1]&& active_signb)
                   ?{{(72-datab_width){1'b1}},datab[datab_width -1 : 0]}
                   :{{(72-datab_width){1'b0}},datab[datab_width -1 : 0]} ;

assign datac_out_tim = (datac[datac_width-1]&& active_signc)
                   ?{{(72-datac_width){1'b1}},datac[datac_width -1 : 0]}
                   :{{(72-datac_width){1'b0}},datac[datac_width -1 : 0]} ;

assign datad_out_tim = (datad[datad_width-1]&& active_signd)
                   ?{{(72-datad_width){1'b1}},datad[datad_width -1 : 0]}
                   :{{(72-datad_width){1'b0}},datad[datad_width -1 : 0]} ;

assign datab_out_fun = ((operation_mode == "36_bit_multiply") ||(operation_mode == "shift")) 
                   ?((datab[datab_width-1]&& signb)
                  ?{{(72-datab_width){1'b1}},datab[datab_width -1 : 0]}
                   :{{(72-datab_width){1'b0}},datab[datab_width -1 : 0]})
                   :(operation_mode == "double") 
                   ?((datab[datab_width-1]&& signa)
                  ?{{(72-datab_width){1'b1}},datab[datab_width -1 : 0]}
                   :{{(72-datab_width){1'b0}},datab[datab_width -1 : 0]})
                   :((datab[datab_width-1]&& sign)
                   ?{{(72-datab_width){1'b1}},datab[datab_width -1 : 0]}
                   :{{(72-datab_width){1'b0}},datab[datab_width -1 : 0]}) ;

assign datac_out_fun =((operation_mode == "36_bit_multiply") ||(operation_mode == "shift"))
                  ?((datac[datac_width-1]&& signa)
                  ?{{(72-datac_width){1'b1}},datac[datac_width -1 : 0]}
                  :{{(72-datac_width){1'b0}},datac[datac_width -1 : 0]} )
                  :((datac[datac_width-1]&& sign)
                  ?{{(72-datac_width){1'b1}},datac[datac_width -1 : 0]}
                  :{{(72-datac_width){1'b0}},datac[datac_width -1 : 0]}) ;

assign datad_out_fun = ((operation_mode == "36_bit_multiply") ||(operation_mode == "shift"))
                  ?{{(72-datad_width){1'b0}},datad[datad_width -1 : 0]}
                  :(operation_mode == "double")
                  ?((datad[datad_width-1]&& signa)
                  ?{{(72-datad_width){1'b1}},datad[datad_width -1 : 0]}
                  :{{(72-datad_width){1'b0}},datad[datad_width -1 : 0]} )
                  :((datad[datad_width-1]&& sign)
                  ?{{(72-datad_width){1'b1}},datad[datad_width -1 : 0]}
                  :{{(72-datad_width){1'b0}},datad[datad_width -1 : 0]}) ;
                  
assign datab_out = (read_new_param == 1'b1) ? datab_out_tim : datab_out_fun;
assign datac_out = (read_new_param == 1'b1) ? datac_out_tim : datac_out_fun;
assign datad_out = (read_new_param == 1'b1) ? datad_out_tim : datad_out_fun;

assign chainin_out = (chainin[chainin_width-1])
                  ?{{(72-chainin_width){1'b1}},chainin[chainin_width -1 : 0]}
                  :{{(72-chainin_width){1'b0}},chainin[chainin_width -1 : 0]} ;

endmodule


//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_first_stage_add_sub                                          //
//  Description:             STRATIXIV First Stage Adder Subtractor Unit                            //
//////////////////////////////////////////////////////////////////////////////////////////////////
module stratixiv_first_stage_add_sub(
                                 dataa,
                                 datab,
                                 sign,
                                 operation,
                                 dataout
                                );
//PARAMETERS
parameter    dataa_width = 36;
parameter    datab_width = 36;
parameter   fsa_mode = "add";

// INPUT PORTS
input [71  : 0 ] dataa;
input [71 : 0 ] datab;
input sign;
input [3:0] operation;

// OUTPUT PORTS
output [71: 0] dataout;

//INTERNAL SIGNALS
reg[71 :0] dataout_tmp;
reg[71:0] abs_b;
reg[71:0] abs_a;
reg sign_a;
reg sign_b;

specify
    (dataa *> dataout)              = (0, 0);
    (datab *> dataout)              = (0, 0);
    (sign *> dataout)               = (0, 0);
endspecify

//assign the output values
assign dataout = dataout_tmp;

always @(dataa or datab or sign or operation)
    begin
        if((operation == 4'b0111) ||(operation == 4'b1000)|| (operation == 4'b1001))  //36 bit multiply, shift and add
            begin
                dataout_tmp = {dataa[53:36],dataa[35:0],18'b0} + datab;
            end
    else
        begin
            sign_a  = (sign && dataa[dataa_width -1]);
            abs_a = (sign_a) ? (~dataa + 1'b1) : dataa;
            sign_b  = (sign && datab[datab_width-1]);
            abs_b = (sign_b) ? (~datab + 1'b1) : datab;
            if (fsa_mode == "add")
                dataout_tmp = (sign_a ? -abs_a : abs_a) + (sign_b ?-abs_b : abs_b);
            else
                dataout_tmp = (sign_a ? -abs_a : abs_a) - (sign_b ?-abs_b : abs_b);
        end
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_second_stage_add_accum                                       //
//  Description:             STRATIXIV Second stage Adder and Accumulator/Decimator Unit            //
//////////////////////////////////////////////////////////////////////////////////////////////////

module stratixiv_second_stage_add_accum(
                                    dataa,
                                    datab,
                                    accumin,
                                    sign,
                                    operation,
                                    dataout,
                                    overflow
                                   );
//PARAMETERS
parameter    dataa_width = 36;
parameter    datab_width = 36;
parameter   accum_width = dataa_width + 8;
parameter ssa_mode = "add";


// INPUT PORTS
input [71 : 0 ]  dataa;
input [71 : 0 ]  datab;
input [71 : 0]   accumin;
input sign;
input [3:0] operation;


// OUTPUT PORTS
output overflow;
output [71  :0] dataout;

//INTERNAL SIGNALS
reg[71 :0] dataout_tmp;
reg [71:0] dataa_tmp;
reg [71:0] datab_tmp;
reg[71:0] accum_tmp;
reg sign_a;
reg sign_b;
reg sign_accum;
reg sign_out;
reg overflow_tmp;

reg [71 :0] abs_a;
reg [71 :0] abs_b;
reg [71 :0] abs_accum;

specify
    (dataa *> dataout)              = (0, 0);
    (datab *> dataout)              = (0, 0);   
    (sign *> dataout)               = (0, 0);
    (dataa *> overflow)              = (0, 0);
    (datab *> overflow)              = (0, 0); 
    (sign *> overflow)               = (0, 0);

if(operation == 4'b0011 || operation == 4'b0100 )
    (accumin *> dataout)           = (0, 0);

if(operation == 4'b0011 || operation == 4'b0100 )
    (accumin *> overflow)           = (0, 0);

endspecify

//assign the output values
assign dataout = dataout_tmp;
assign overflow = overflow_tmp;


always@(dataa or datab or sign or accumin or operation)
    begin
        sign_accum  = (sign && accumin[accum_width -1]);
        abs_accum = (sign_accum) ? (~accumin + 1'b1) : accumin;
        sign_a  = (sign && dataa[dataa_width-1]);
        abs_a = (sign_a) ? (~dataa + 1'b1) : dataa;
        sign_b  = (sign && datab[datab_width-1]);
        abs_b = (sign_b) ? (~datab + 1'b1) : datab; 
        
        if(operation == 4'b0011 || operation == 4'b0100 )//Accumultor or Accumulator chainout
            begin
                if (ssa_mode == "add")
                    dataout_tmp = (sign_accum ? -abs_accum[accum_width -1 : 0] : abs_accum[accum_width -1 : 0]) + (sign_a ? -abs_a[accum_width -1 : 0] : abs_a[accum_width -1 : 0]) + (sign_b ? -abs_b[accum_width -1 : 0] : abs_b[accum_width -1 : 0]);
                else
                    dataout_tmp = (sign_accum ? -abs_accum[accum_width -1 : 0] : abs_accum[accum_width -1 : 0]) - (sign_a ? -abs_a[accum_width -1 : 0] : abs_a[accum_width -1 : 0]) - (sign_b ? -abs_b[accum_width -1 : 0] : abs_b[accum_width -1 : 0]);
                if(sign)
                    overflow_tmp = dataout_tmp[accum_width] ^ dataout_tmp[accum_width -1];
                else
                    begin
                        if(ssa_mode == "add")
                            overflow_tmp = dataout_tmp[accum_width];
                        else
                            overflow_tmp = 1'bX;
                    end                  
            end
        else if( operation == 4'b0101 || operation == 4'b0110)// two level adder or two level with chainout
            begin
                dataout_tmp = (sign_a ? -abs_a : abs_a) + (sign_b ?-abs_b : abs_b);
                overflow_tmp = 'b0;
            end
        else if(( operation == 4'b0111) ||(operation == 4'b1000)) //36 bit multiply; shift and add
            begin
                dataout_tmp[71:0] = {dataa[53:0],18'b0} + datab;
                overflow_tmp = 'b0;
            end
        else if(( operation == 4'b1001) ) //double mode
            begin
                dataout_tmp[71:0] = dataa + datab;
                overflow_tmp = 'b0;
            end
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_round_block                                                  //
//  Description:             STRATIXIV round block                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////

module stratixiv_round_block(
                        datain,
                        round,
                        datain_width,
                        dataout
                       );

parameter round_mode = "nearest_integer";
parameter operation_mode = "output_only";
parameter round_width = 15;

input [71 :0 ] datain;
input round;
input [7:0] datain_width;

output [71  : 0] dataout;

reg sign;
reg [71 :0] result_tmp;
reg [71:0] dataout_tmp;
reg [71 :0 ] dataout_value;
integer i,j;

initial
begin
    result_tmp = {(72){1'b0}};
end

assign dataout =  dataout_value;

always@(datain or round)
    begin
        if(round == 1'b0)
            dataout_value = datain;
        else
            begin
                j = 0;
                sign = 0;
                dataout_value = datain;
                if(datain_width > round_width)
                    begin
                        for(i = datain_width - round_width ; i < datain_width ; i = i+1)
                           begin
                               result_tmp[j]= datain[i];
                                j = j +1;
                           end
                        for (i = 0; i < datain_width - round_width -1 ; i = i +1)
                           begin
                               sign = sign | datain[i];
                               dataout_value[i] = 1'bX;
                           end
                       dataout_value[datain_width - round_width -1] = 1'bX;
                        //rounding logic
                        if(datain[datain_width - round_width -1 ] == 1'b0)// fractional < 0.5
                            begin
                                dataout_tmp = result_tmp;
                            end
                        else if((datain[datain_width - round_width -1 ] == 1'b1) && (sign == 1'b1))//fractional > 0.5
                            begin
                                dataout_tmp = result_tmp + 1'b1;
                            end
                        else
                            begin
                                if(round_mode == "nearest_even")//unbiased rounding
                                    begin
                                        if(result_tmp % 2) //check for odd integer
                                            dataout_tmp = result_tmp + 1'b1;
                                        else
                                            dataout_tmp = result_tmp;
                                    end
                                else //biased rounding
                                    begin
                                        dataout_tmp = result_tmp + 1'b1;
                                    end
                            end
                        j = 0;
                        for(i = datain_width - round_width ; i < datain_width  ; i = i+1)
                           begin
                               dataout_value[i]= dataout_tmp[j];
                               j = j+1;
                           end  
                    end
            end
    end         
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_saturation_block                                             //
//  Description:             STRATIXIV saturation block                                             //
//////////////////////////////////////////////////////////////////////////////////////////////////

module stratixiv_saturate_block(
                            datain,
                            saturate,
                            round,
                            signa,
                            signb,
                            datain_width,
                            dataout,
                            saturation_overflow
                           );
parameter dataa_width = 36;
parameter datab_width = 36;
parameter round_width = 15;
parameter saturate_width = 1;
parameter accum_width = dataa_width + 8;
parameter saturate_mode = " asymmetric";
parameter operation_mode = "output_only";

input [71:0] datain;
input saturate;
input round;
input signa;
input signb;
input [7:0] datain_width;

output[71 :0 ] dataout;
output saturation_overflow;

//Internal signals
reg [71 : 0] dataout_tmp;
reg saturation_overflow_tmp;
wire msb;
wire sign;
integer i;

reg [71 :0] max;
reg [71 :0] min;
reg sign_tmp;
reg data_tmp;

initial
begin
    max = {(72){1'b0}};
    min = {(72){1'b1}};
    sign_tmp = 1'b1;
    data_tmp = 1'b0;
end

assign sign = signa | signb;
assign msb = ((operation_mode == "accumulator")
             ||(operation_mode == "accumulator_chain_out")
             ||(operation_mode == "two_level_adder_chain_out"))  ? datain[accum_width] :
             (operation_mode == "two_level_adder") ? datain[dataa_width + 1] :
             ((operation_mode == "one_level_adder")||(operation_mode == "loopback")) ? datain[dataa_width] : datain[dataa_width -1];

assign dataout = dataout_tmp;
assign saturation_overflow = saturation_overflow_tmp;

always @(datain or datain_width or sign or round or msb or saturate)
    begin
        if(saturate == 1'b0)
            begin
                dataout_tmp = datain;
                saturation_overflow_tmp = 1'b0;
            end
            
        else
            begin
                saturation_overflow_tmp = 1'b0;
                data_tmp = 1'b0;
                sign_tmp = 1'b1; 
                // "X" when round is asserted.
                if((round == 1'b1))
                    begin
                        for(i = 0; i < datain_width - round_width; i = i +1)
                            begin     
                                min[i] = 1'bX;                     
                                max[i] = 1'bX;            
                            end
                    end
                // "X" for symmetric saturation, only if data is negative    
                if(( saturate_mode == "symmetric"))
                    begin  
                        for(i = 0; i < datain_width - round_width; i = i +1)
                            begin     
                                if(round == 1'b1)
                                begin
                                    max[i] = 1'bX; 
                                    min[i] = 1'bX;
                                end 
                                else
                                begin
                                    max[i] = 1'b1;                        
                                    min[i] = 1'b0; 
                                end 
                            end 
                        for( i= datain_width - round_width; i < datain_width - saturate_width; i = i+1)
                            begin
                                data_tmp = data_tmp | datain[i];
                                max[i] = 1'b1;
                                min[i] = 1'b0;
                            end
                        if (round == 1'b1)
                            min[datain_width - round_width] = 1'b1;
                        else
                            min[0] = 1'b1;
                    end
                        
                if(( saturate_mode == "asymmetric"))
                    begin    
                        for( i= 0; i < datain_width -saturate_width; i = i+1)
                            begin
                                max[i] = 1'b1;
                                min[i] = 1'b0;
                            end       
                    end                                                            
                                                             
                //check for overflow 
                if((saturate_width ==1))
                    begin
                         if(msb != datain[datain_width-1]) 
                                    saturation_overflow_tmp = 1'b1; 
                 else
                    sign_tmp = sign_tmp & datain[datain_width-1]; 

                    end 
                else
                    begin
                        for (i = datain_width - saturate_width; i < datain_width ; i = i + 1)
                            begin                                                                             
                                sign_tmp = sign_tmp & datain[i];                                                                           
                                if(datain[datain_width -1 ] != datain[i])                     
                                    saturation_overflow_tmp = 1'b1; 
                            end
                    end 
                    
                // Trigger the saturation overflow for data=-2^n in case of symmetric saturation.
                        if((sign_tmp == 1'b1) && (data_tmp == 1'b0) && (saturate_mode == "symmetric"))
                            saturation_overflow_tmp = 1'b1; 
                    
                                                                                               
                if(saturation_overflow_tmp)                                          
                    begin 
                        if((operation_mode == "output_only") || (operation_mode == "accumulator_chain_out") || (operation_mode == "two_level_adder_chain_out"))
                            begin                                                    
                                if(msb)                                              
                                    dataout_tmp = min;                          
                                else                                                 
                                    dataout_tmp = max;  
                            end
                        else
                            begin                                
                                if (sign)                                                    
                                    begin                                                    
                                        if(msb)                                              
                                            dataout_tmp = min;                          
                                        else                                                 
                                            dataout_tmp = max;                          
                                    end                                                      
                                else                                                            
                                    dataout_tmp = 72'bX;
                            end
                    end
                else
                    dataout_tmp = datain;
            end         
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_round_saturate_block                                         //
//  Description:             STRATIXIV round and saturation Unit.                                   //
//                           This unit instantiated the following components.                   //
//                            1.stratixiv_round_block.                                              //
//                            2.stratixiv_saturate_block.                                           //
//////////////////////////////////////////////////////////////////////////////////////////////////
module stratixiv_round_saturate_block(
                                   datain,
                                   round,
                                   saturate,
                                   signa,
                                   signb,
                                   datain_width,
                                   dataout,
                                   saturationoverflow
                                  );
parameter dataa_width = 36;
parameter datab_width = 36;
parameter saturate_width = 15;
parameter round_width = 15;
parameter saturate_mode = " asymmetric";
parameter round_mode = "nearest_integer";
parameter operation_mode = "output_only";

input [71:0] datain;
input round;
input saturate;
input signa;
input signb;
input [7:0] datain_width;

output[71:0] dataout;
output saturationoverflow;


wire [71:0] dataout_round;
wire [7:0] datain_width;
wire [7:0] fraction_width;
wire[7:0] datasize;

specify
    (datain *> dataout)                     = (0, 0);
    (round *> dataout)                      = (0, 0);
    (saturate *> dataout)                   = (0, 0);
    (signa *> dataout)                      = (0, 0);
    (signb *> dataout)                      = (0, 0);
    (datain *> saturationoverflow)         = (0, 0);
    (round *> saturationoverflow)          = (0, 0);
    (saturate *> saturationoverflow)       = (0, 0);
    (signa *> saturationoverflow)          = (0, 0);
    (signb *> saturationoverflow)          = (0, 0);
endspecify

stratixiv_round_block round_unit  (
                              .datain(datain),
                              .round(round),
                              .datain_width(datain_width),
                              .dataout(dataout_round)
                              );

defparam round_unit.round_mode = round_mode;
defparam round_unit.operation_mode = operation_mode;
defparam round_unit.round_width = round_width;

stratixiv_saturate_block saturate_unit(
                                    .datain(dataout_round),
                                    .saturate(saturate),
                                    .round(round),
                                    .signa(signa),
                                    .signb(signb),
                                    .datain_width(datain_width),
                                    .dataout(dataout),
                                    .saturation_overflow(saturationoverflow)
                                   );
defparam saturate_unit.dataa_width = dataa_width;
defparam saturate_unit.datab_width = datab_width;
defparam saturate_unit.round_width = round_width;
defparam saturate_unit.saturate_width = saturate_width;
defparam saturate_unit.saturate_mode = saturate_mode;
defparam saturate_unit.operation_mode = operation_mode;


endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_rotate_shift_block                                           //
//  Description:             STRATIXIV rotate and shift Unit.                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////

module stratixiv_rotate_shift_block(
                                 datain,
                                 rotate,
                                 shiftright,
                                 signa,
                                 signb,
                                 dataout
                                );
parameter dataa_width = 32;
parameter datab_width = 32;
parameter operation_mode = "output_only";

input [71:0] datain;
input rotate;
input shiftright;
input signa;
input signb;

wire sign;
output [71:0] dataout;

reg[71:0] dataout_tmp;

specify
    (datain *> dataout)             = (0, 0);
    (rotate *> dataout)             = (0, 0);
    (shiftright*> dataout)          = (0, 0);
endspecify

assign sign = signa ^ signb;
assign dataout = dataout_tmp;
always@(datain or rotate or shiftright)
    begin
        dataout_tmp = datain;
        if((rotate == 0) && (shiftright == 0))
            dataout_tmp[39:8] = datain[39:8];
        else if((rotate == 0) && (shiftright == 1))
            dataout_tmp[39:8]= datain[71:40];
        else if ((rotate == 1) && (shiftright == 0))
            dataout_tmp[39:8] = datain[71:40] | datain[39:8]; 
        else
            dataout_tmp = datain;  
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_carry_chain_adder                                            //
//  Description:             STRATIXIV carry chain adder Unit.                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////

module stratixiv_carry_chain_adder(
                               dataa,
                               datab,
                               dataout
                               );
// INPUT PORTS
input [71 : 0 ]  dataa;
input [71 : 0 ] datab;

// OUTPUT PORTS
output [71  :0] dataout;

reg[71:0] dataout_tmp;

specify
    (dataa  *> dataout)             = (0, 0);
    (datab *> dataout)             = (0, 0);
endspecify

assign dataout = dataout_tmp;

initial
    begin
        dataout_tmp = 72'b0;
    end

always@(dataa or datab)
    begin
       dataout_tmp = {dataa[43],dataa[43:0]}  + {datab[43],datab[43:0]};
    end
    
endmodule

//////////////////////////////////////////////////////////////////////////////////
//  Module Name:             stratixiv_mac_out_atom                                 //
//  Description:             Simulation model for stratixiv mac out atom            //
//                           This model instantiates the following components   //
//                              1.stratixiv_mac_bit_register                        //
//                              2.stratixiv_mac_register                            //
//                              3.stratixiv_fsa_isse                                //
//                              4.stratixiv_first_stage_add_sub                     //
//                              5.stratixiv_second_stage_add_accum                  //
//                              6.stratixiv_round_saturate_block                    //
//                              7.stratixiv_rotate_shift_block                      //
//                              8.stratixiv_carry_chain_adder                       //
//////////////////////////////////////////////////////////////////////////////////

module stratixiv_mac_out(
                     dataa,
                     datab,
                     datac,
                     datad,
                     signa,
                     signb,
                     chainin,
                     round,
                     saturate,
                     zeroacc,
                     roundchainout,
                     saturatechainout,
                     zerochainout,
                     zeroloopback,
                     rotate,
                     shiftright,
                     clk,
                     ena,
                     aclr,
                     loopbackout,
                     dataout,
                     overflow,
                     dftout,
                     saturatechainoutoverflow,
                     devpor,
                     devclrn
                    );

//Parameter declaration

parameter operation_mode = "output_only";
parameter dataa_width = 1;
parameter datab_width = 1;
parameter datac_width = 1;
parameter datad_width = 1;
parameter chainin_width = 1;
parameter round_width = 15;
parameter round_chain_out_width = 15;
parameter saturate_width = 15;
parameter saturate_chain_out_width = 15;

parameter first_adder0_clock = "none";
parameter first_adder0_clear = "none";
parameter first_adder1_clock = "none";
parameter first_adder1_clear = "none";
parameter second_adder_clock = "none";
parameter second_adder_clear = "none";
parameter output_clock = "none";
parameter output_clear = "none";
parameter signa_clock = "none";
parameter signa_clear = "none";
parameter signb_clock = "none";
parameter signb_clear = "none";
parameter round_clock = "none";
parameter round_clear = "none";
parameter roundchainout_clock = "none";
parameter roundchainout_clear = "none";
parameter saturate_clock = "none";
parameter saturate_clear = "none";
parameter saturatechainout_clock = "none";
parameter saturatechainout_clear = "none";
parameter zeroacc_clock = "none";
parameter zeroacc_clear = "none";
parameter zeroloopback_clock = "none";
parameter zeroloopback_clear = "none";
parameter rotate_clock = "none";
parameter rotate_clear = "none";
parameter shiftright_clock = "none";
parameter shiftright_clear = "none";

parameter signa_pipeline_clock = "none";
parameter signa_pipeline_clear = "none";
parameter signb_pipeline_clock = "none";
parameter signb_pipeline_clear = "none";
parameter round_pipeline_clock = "none";
parameter round_pipeline_clear = "none";
parameter roundchainout_pipeline_clock = "none";
parameter roundchainout_pipeline_clear = "none";
parameter saturate_pipeline_clock = "none";
parameter saturate_pipeline_clear = "none";
parameter saturatechainout_pipeline_clock = "none";
parameter saturatechainout_pipeline_clear = "none";
parameter zeroacc_pipeline_clock = "none";
parameter zeroacc_pipeline_clear = "none";
parameter zeroloopback_pipeline_clock = "none";
parameter zeroloopback_pipeline_clear = "none";
parameter rotate_pipeline_clock = "none";
parameter rotate_pipeline_clear = "none";
parameter shiftright_pipeline_clock = "none";
parameter shiftright_pipeline_clear = "none";

parameter roundchainout_output_clock = "none";
parameter roundchainout_output_clear = "none";
parameter saturatechainout_output_clock = "none";
parameter saturatechainout_output_clear = "none";
parameter zerochainout_output_clock = "none";
parameter zerochainout_output_clear = "none";
parameter zeroloopback_output_clock = "none";
parameter zeroloopback_output_clear = "none";
parameter rotate_output_clock = "none";
parameter rotate_output_clear = "none";
parameter shiftright_output_clock = "none";
parameter shiftright_output_clear = "none";

parameter first_adder0_mode = "add";
parameter first_adder1_mode = "add";
parameter acc_adder_operation = "add";
parameter round_mode = "nearest_integer";
parameter round_chain_out_mode = "nearest_integer";
parameter saturate_mode = "asymmetric";
parameter saturate_chain_out_mode = "asymmetric";

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter multa_signa_internally_grounded = "false";
parameter multa_signb_internally_grounded = "false";
parameter multb_signa_internally_grounded = "false";
parameter multb_signb_internally_grounded = "false";
parameter multc_signa_internally_grounded = "false";
parameter multc_signb_internally_grounded = "false";
parameter multd_signa_internally_grounded = "false";
parameter multd_signb_internally_grounded = "false";

// SIMULATION_ONLY_PARAMETERS_END

parameter lpm_type = "stratixiv_mac_out";

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter dataout_width = 72;

// SIMULATION_ONLY_PARAMETERS_END

input [dataa_width -1 :0] dataa;
input [datab_width -1 :0] datab;
input [datac_width -1 :0] datac;
input [datad_width -1 :0] datad;
input signa;
input signb;
input [chainin_width -1 : 0] chainin;
input round;
input saturate;
input roundchainout;
input saturatechainout;
input zeroacc;
input zerochainout;
input zeroloopback;
input rotate;
input shiftright;
input [3:0] clk;
input [3:0] aclr;
input [3:0] ena;
input devpor;
input devclrn;

output [17:0] loopbackout;
output [71:0] dataout;
output overflow;
output saturatechainoutoverflow;
output dftout;

tri1 devclrn;
tri1 devpor;

//signals for zeroloopback input register
wire [3:0] zeroloopback_clkval_ir;
wire [3:0] zeroloopback_aclrval_ir;
wire zeroloopback_clk_ir;
wire zeroloopback_aclr_ir;
wire zeroloopback_sload_ir;
wire zeroloopback_bypass_register_ir;
wire zeroloopback_in_reg;

//signals for zeroacc input register
wire [3:0] zeroacc_clkval_ir;
wire [3:0] zeroacc_aclrval_ir;
wire zeroacc_clk_ir;
wire zeroacc_aclr_ir;
wire zeroacc_sload_ir;
wire zeroacc_bypass_register_ir;
wire zeroacc_in_reg;

//Signals for signa input register
wire [3:0] signa_clkval_ir;
wire [3:0] signa_aclrval_ir;
wire signa_clk_ir;
wire signa_aclr_ir;
wire signa_sload_ir;
wire signa_bypass_register_ir;
wire signa_in_reg;

//signals for signb input register
wire [3:0] signb_clkval_ir;
wire [3:0] signb_aclrval_ir;
wire signb_clk_ir;
wire signb_aclr_ir;
wire signb_sload_ir;
wire signb_bypass_register_ir;
wire signb_in_reg;

//signals for rotate input register
wire [3:0] rotate_clkval_ir;
wire [3:0] rotate_aclrval_ir;
wire rotate_clk_ir;
wire rotate_aclr_ir;
wire rotate_sload_ir;
wire rotate_bypass_register_ir;
wire rotate_in_reg;

//signals for shiftright input register
wire [3:0] shiftright_clkval_ir;
wire [3:0] shiftright_aclrval_ir;
wire shiftright_clk_ir;
wire shiftright_aclr_ir;
wire shiftright_sload_ir;
wire shiftright_bypass_register_ir;
wire shiftright_in_reg;

//signals for round input register
wire [3:0] round_clkval_ir;
wire [3:0] round_aclrval_ir;
wire round_clk_ir;
wire round_aclr_ir;
wire round_sload_ir;
wire round_bypass_register_ir;
wire round_in_reg;

//signals for saturate input register
wire [3:0] saturate_clkval_ir;
wire [3:0] saturate_aclrval_ir;
wire saturate_clk_ir;
wire saturate_aclr_ir;
wire saturate_sload_ir;
wire saturate_bypass_register_ir;
wire saturate_in_reg;

//signals for roundchainout input register
wire [3:0] roundchainout_clkval_ir;
wire [3:0] roundchainout_aclrval_ir;
wire roundchainout_clk_ir;
wire roundchainout_aclr_ir;
wire roundchainout_sload_ir;
wire roundchainout_bypass_register_ir;
wire roundchainout_in_reg;


//signals for saturatechainout input register
wire [3:0] saturatechainout_clkval_ir;
wire [3:0] saturatechainout_aclrval_ir;
wire saturatechainout_clk_ir;
wire saturatechainout_aclr_ir;
wire saturatechainout_sload_ir;
wire saturatechainout_bypass_register_ir;
wire saturatechainout_in_reg;

//signals for fsa_input_interface
wire [71:0] dataa_fsa_in;
wire [71:0] datab_fsa_in;
wire [71:0] datac_fsa_in;
wire [71:0] datad_fsa_in;
wire [71:0] chainin_coa_in;
wire sign;
wire [3:0]operation;

//Signals for First Stage Adder units
wire [71:0] dataout_fsa0;
wire [71:0] fsa_pip_datain1;
wire [71:0] dataout_fsa1;
wire overflow_fsa0;
wire overflow_fsa1;

//signals for zeroloopback pipeline register
wire [3:0] zeroloopback_clkval_pip;
wire [3:0] zeroloopback_aclrval_pip;
wire zeroloopback_clk_pip;
wire zeroloopback_aclr_pip;
wire zeroloopback_sload_pip;
wire zeroloopback_bypass_register_pip;
wire zeroloopback_pip_reg;

//signals for zeroacc pipeline register
wire [3:0] zeroacc_clkval_pip;
wire [3:0] zeroacc_aclrval_pip;
wire zeroacc_clk_pip;
wire zeroacc_aclr_pip;
wire zeroacc_sload_pip;
wire zeroacc_bypass_register_pip;
wire zeroacc_pip_reg;

//Signals for signa pipeline register
wire [3:0] signa_clkval_pip;
wire [3:0] signa_aclrval_pip;
wire signa_clk_pip;
wire signa_aclr_pip;
wire signa_sload_pip;
wire signa_bypass_register_pip;
wire signa_pip_reg;

//signals for signb pipeline register
wire [3:0] signb_clkval_pip;
wire [3:0] signb_aclrval_pip;
wire signb_clk_pip;
wire signb_aclr_pip;
wire signb_sload_pip;
wire signb_bypass_register_pip;
wire signb_pip_reg;

//signals for rotate pipeline register
wire [3:0] rotate_clkval_pip;
wire [3:0] rotate_aclrval_pip;
wire rotate_clk_pip;
wire rotate_aclr_pip;
wire rotate_sload_pip;
wire rotate_bypass_register_pip;
wire rotate_pip_reg;

//signals for shiftright pipeline register
wire [3:0] shiftright_clkval_pip;
wire [3:0] shiftright_aclrval_pip;
wire shiftright_clk_pip;
wire shiftright_aclr_pip;
wire shiftright_sload_pip;
wire shiftright_bypass_register_pip;
wire shiftright_pip_reg;

//signals for round pipeline register
wire [3:0] round_clkval_pip;
wire [3:0] round_aclrval_pip;
wire round_clk_pip;
wire round_aclr_pip;
wire round_sload_pip;
wire round_bypass_register_pip;
wire round_pip_reg;

//signals for saturate pipeline register
wire [3:0] saturate_clkval_pip;
wire [3:0] saturate_aclrval_pip;
wire saturate_clk_pip;
wire saturate_aclr_pip;
wire saturate_sload_pip;
wire saturate_bypass_register_pip;
wire saturate_pip_reg;

//signals for roundchainout pipeline register
wire [3:0] roundchainout_clkval_pip;
wire [3:0] roundchainout_aclrval_pip;
wire roundchainout_clk_pip;
wire roundchainout_aclr_pip;
wire roundchainout_sload_pip;
wire roundchainout_bypass_register_pip;
wire roundchainout_pip_reg;


//signals for saturatechainout pipeline register
wire [3:0] saturatechainout_clkval_pip;
wire [3:0] saturatechainout_aclrval_pip;
wire saturatechainout_clk_pip;
wire saturatechainout_aclr_pip;
wire saturatechainout_sload_pip;
wire saturatechainout_bypass_register_pip;
wire saturatechainout_pip_reg;

//signals for fsa0 pipeline register
wire [3:0] fsa0_clkval_pip;
wire [3:0] fsa0_aclrval_pip;
wire fsa0_clk_pip;
wire fsa0_aclr_pip;
wire fsa0_sload_pip;
wire fsa0_bypass_register_pip;
wire[71:0] fsa0_pip_reg;

//signals for fsa1 pipeline register
wire [3:0] fsa1_clkval_pip;
wire [3:0] fsa1_aclrval_pip;
wire fsa1_clk_pip;
wire fsa1_aclr_pip;
wire fsa1_sload_pip;
wire fsa1_bypass_register_pip;
wire[71:0] fsa1_pip_reg;

//Signals for second stage adder
wire [71:0] ssa_accum_in;
wire ssa_sign;
wire [71:0] ssa_dataout;
wire ssa_overflow;

//Signals for RS block
wire[71:0] rs_datain;
wire [71:0] rs_dataout;
reg [71:0] rs_dataout_of;
wire [71:0] rs_dataout_tmp;
wire rs_saturation_overflow;
wire [7:0] ssa_datain_width;
wire [7:0] ssa_datain_width_tmp;
wire [3:0] ssa_round_width;
wire [7:0] ssa_fraction_width;

//signals for zeroloopback output register
wire [3:0] zeroloopback_clkval_or;
wire [3:0] zeroloopback_aclrval_or;
wire zeroloopback_clk_or;
wire zeroloopback_aclr_or;
wire zeroloopback_sload_or;
wire zeroloopback_bypass_register_or;
wire zeroloopback_out_reg;

//signals for zerochainout output register
wire [3:0] zerochainout_clkval_or;
wire [3:0] zerochainout_aclrval_or;
wire zerochainout_clk_or;
wire zerochainout_aclr_or;
wire zerochainout_sload_or;
wire zerochainout_bypass_register_or;
wire zerochainout_out_reg;

//Signals for saturation_overflow output register
wire [3:0] saturation_overflow_clkval_or;
wire [3:0] saturation_overflow_aclrval_or;
wire saturation_overflow_clk_or;
wire saturation_overflow_aclr_or;
wire saturation_overflow_sload_or;
wire saturation_overflow_bypass_register_or;
wire saturation_overflow_out_reg;

//signals for rs_dataout output register
wire [71:0] rs_dataout_in;
wire [3:0] rs_dataout_clkval_or;
wire [3:0] rs_dataout_aclrval_or;
wire [3:0] rs_dataout_clkval_or_co;
wire [3:0] rs_dataout_aclrval_or_co;
wire [3:0] rs_dataout_clkval_or_o;
wire [3:0] rs_dataout_aclrval_or_o;
wire rs_dataout_clk_or;
wire rs_dataout_aclr_or;
wire rs_dataout_sload_or;
wire rs_dataout_bypass_register_or;
wire rs_dataout_bypass_register_or_co;
wire rs_dataout_bypass_register_or_o;
wire[71:0] rs_dataout_out_reg;
wire rs_saturation_overflow_out_reg;
wire rs_saturation_overflow_in;



//signals for rotate output register
wire [3:0] rotate_clkval_or;
wire [3:0] rotate_aclrval_or;
wire rotate_clk_or;
wire rotate_aclr_or;
wire rotate_sload_or;
wire rotate_bypass_register_or;
wire rotate_out_reg;

//signals for shiftright output register
wire [3:0] shiftright_clkval_or;
wire [3:0] shiftright_aclrval_or;
wire shiftright_clk_or;
wire shiftright_aclr_or;
wire shiftright_sload_or;
wire shiftright_bypass_register_or;
wire shiftright_out_reg;


//signals for roundchainout output register
wire [3:0] roundchainout_clkval_or;
wire [3:0] roundchainout_aclrval_or;
wire roundchainout_clk_or;
wire roundchainout_aclr_or;
wire roundchainout_sload_or;
wire roundchainout_bypass_register_or;
wire roundchainout_out_reg;


//signals for saturatechainout output register
wire [3:0] saturatechainout_clkval_or;
wire [3:0] saturatechainout_aclrval_or;
wire saturatechainout_clk_or;
wire saturatechainout_aclr_or;
wire saturatechainout_sload_or;
wire saturatechainout_bypass_register_or;
wire saturatechainout_out_reg;

//Signals for chainout Adder RS Block
wire [71:0] coa_dataout;
wire [7:0] coa_datain_width;
wire [3:0] coa_round_width;
wire [7:0] coa_fraction_width;
wire [71:0] coa_rs_dataout;
wire coa_rs_saturation_overflow;

//signals for control signals for COA output register
wire [3:0] coa_reg_clkval_or;
wire [3:0] coa_reg_aclrval_or;
wire coa_reg_clk_or;
wire coa_reg_aclr_or;
wire coa_reg_sload_or;
wire coa_reg_bypass_register_or;
wire coa_reg_out_reg;
wire coa_rs_saturation_overflow_out_reg;
wire coa_rs_saturationchainout_overflow_out_reg;
wire [71:0] coa_rs_dataout_out_reg;

wire [71:0] dataout_shift_rot ;
reg  [5:0] dataa_width_local;
wire [71:0] dataout_tmp;
wire [71:0] loopbackout_tmp;

always@(rs_dataout or rs_saturation_overflow or saturate_pip_reg)
begin
 rs_dataout_of = rs_dataout;
 rs_dataout_of[dataa_width -1] = (((operation_mode == "output_only")||(operation_mode == "one_level_adder") ||(operation_mode == "loopback"))
                       &&(dataa_width > 1) && (saturate_pip_reg == 1'b1))? rs_saturation_overflow : rs_dataout[dataa_width -1];
                       
end

//Instantiate the zeroloopback input Register
stratixiv_mac_register zeroloopback_input_register (
                                                .datain(zeroloopback),
                                                .clk(zeroloopback_clk_ir),
                                                .aclr(zeroloopback_aclr_ir),
                                                .sload(zeroloopback_sload_ir),
                                                .bypass_register(zeroloopback_bypass_register_ir),
                                                .dataout(zeroloopback_in_reg)
                                              );

defparam zeroloopback_input_register.data_width = 1;

//decode the clk and aclr values
assign zeroloopback_clkval_ir = (zeroloopback_clock == "0") ? 4'b0000 :
                                  (zeroloopback_clock == "1") ? 4'b0001 :
                                  (zeroloopback_clock == "2") ? 4'b0010 :
                                  (zeroloopback_clock == "3") ? 4'b0011 : 4'b0000;


assign zeroloopback_aclrval_ir = (zeroloopback_clear == "0")  ? 4'b0000 :
                                  (zeroloopback_clear == "1") ? 4'b0001 :
                                  (zeroloopback_clear == "2") ? 4'b0010 :
                                  (zeroloopback_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign zeroloopback_clk_ir = clk[zeroloopback_clkval_ir] ? 1'b1 : 1'b0;
assign zeroloopback_aclr_ir = aclr[zeroloopback_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign zeroloopback_sload_ir = ena[zeroloopback_clkval_ir] ? 1'b1 : 1'b0;
assign zeroloopback_bypass_register_ir = (zeroloopback_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the zeroacc input Register
stratixiv_mac_register zeroacc_input_register (
                                           .datain(zeroacc),
                                           .clk(zeroacc_clk_ir),
                                           .aclr(zeroacc_aclr_ir),
                                           .sload(zeroacc_sload_ir),
                                           .bypass_register(zeroacc_bypass_register_ir),
                                           .dataout(zeroacc_in_reg)
                                          );
defparam zeroacc_input_register.data_width = 1;

//decode the clk and aclr values
assign zeroacc_clkval_ir =(zeroacc_clock == "0") ? 4'b0000 :
                            (zeroacc_clock == "1") ? 4'b0001 :
                            (zeroacc_clock == "2") ? 4'b0010 :
                            (zeroacc_clock == "3") ? 4'b0011 : 4'b0000;

assign zeroacc_aclrval_ir = (zeroacc_clear == "0")  ? 4'b0000 :
                             (zeroacc_clear == "1") ? 4'b0001 :
                             (zeroacc_clear == "2") ? 4'b0010 :
                             (zeroacc_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign zeroacc_clk_ir = clk[zeroacc_clkval_ir] ? 1'b1 : 1'b0;
assign zeroacc_aclr_ir = aclr[zeroacc_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign zeroacc_sload_ir = ena[zeroacc_clkval_ir] ? 1'b1 : 1'b0;
assign zeroacc_bypass_register_ir = (zeroacc_clock == "none") ? 1'b1 : 1'b0;


//Instantiate the signa input Register
stratixiv_mac_register signa_input_register (
                                         .datain(signa),
                                         .clk(signa_clk_ir),
                                         .aclr(signa_aclr_ir),
                                         .sload(signa_sload_ir),
                                         .bypass_register(signa_bypass_register_ir),
                                         .dataout(signa_in_reg)
                                        );
defparam signa_input_register.data_width = 1;

//decode the clk and aclr values
assign signa_clkval_ir =(signa_clock == "0") ? 4'b0000 :
                          (signa_clock == "1") ? 4'b0001 :
                          (signa_clock == "2") ? 4'b0010 :
                          (signa_clock == "3") ? 4'b0011 : 4'b0000;

assign signa_aclrval_ir = (signa_clear == "0")  ? 4'b0000 :
                           (signa_clear == "1") ? 4'b0001 :
                           (signa_clear == "2") ? 4'b0010 :
                           (signa_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signa_clk_ir = clk[signa_clkval_ir] ? 1'b1 : 1'b0;
assign signa_aclr_ir = aclr[signa_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign signa_sload_ir = ena[signa_clkval_ir] ? 1'b1 : 1'b0;
assign signa_bypass_register_ir = (signa_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the signb input Register
stratixiv_mac_register signb_input_register (
                                         .datain(signb),
                                         .clk(signb_clk_ir),
                                         .aclr(signb_aclr_ir),
                                         .sload(signb_sload_ir),
                                         .bypass_register(signb_bypass_register_ir),
                                         .dataout(signb_in_reg)
                                        );
defparam signb_input_register.data_width = 1;

//decode the clk and aclr values
assign signb_clkval_ir =(signb_clock == "0") ? 4'b0000 :
                          (signb_clock == "1") ? 4'b0001 :
                          (signb_clock == "2") ? 4'b0010 :
                          (signb_clock == "3") ? 4'b0011 : 4'b0000;

assign signb_aclrval_ir = (signb_clear == "0")  ? 4'b0000 :
                           (signb_clear == "1") ? 4'b0001 :
                           (signb_clear == "2") ? 4'b0010 :
                           (signb_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signb_clk_ir = clk[signb_clkval_ir] ? 1'b1 : 1'b0;
assign signb_aclr_ir = aclr[signb_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign signb_sload_ir = ena[signb_clkval_ir] ? 1'b1 : 1'b0;
assign signb_bypass_register_ir = (signb_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the rotate input Register
stratixiv_mac_register rotate_input_register (
                                         .datain(rotate),
                                         .clk(rotate_clk_ir),
                                         .aclr(rotate_aclr_ir),
                                         .sload(rotate_sload_ir),
                                         .bypass_register(rotate_bypass_register_ir),
                                         .dataout(rotate_in_reg)
                                        );
defparam rotate_input_register.data_width = 1;

//decode the clk and aclr values
assign rotate_clkval_ir =(rotate_clock == "0") ? 4'b0000 :
                          (rotate_clock == "1") ? 4'b0001 :
                          (rotate_clock == "2") ? 4'b0010 :
                          (rotate_clock == "3") ? 4'b0011 : 4'b0000;

assign rotate_aclrval_ir = (rotate_clear == "0")  ? 4'b0000 :
                           (rotate_clear == "1") ? 4'b0001 :
                           (rotate_clear == "2") ? 4'b0010 :
                           (rotate_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign rotate_clk_ir = clk[rotate_clkval_ir] ? 1'b1 : 1'b0;
assign rotate_aclr_ir = aclr[rotate_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign rotate_sload_ir = ena[rotate_clkval_ir] ? 1'b1 : 1'b0;
assign rotate_bypass_register_ir = (rotate_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the shiftright input Register
stratixiv_mac_register shiftright_input_register (
                                              .datain(shiftright),
                                              .clk(shiftright_clk_ir),
                                              .aclr(shiftright_aclr_ir),
                                              .sload(shiftright_sload_ir),
                                              .bypass_register(shiftright_bypass_register_ir),
                                              .dataout(shiftright_in_reg)
                                             );
defparam shiftright_input_register.data_width = 1;

//decode the clk and aclr values
assign shiftright_clkval_ir =(shiftright_clock == "0") ? 4'b0000 :
                               (shiftright_clock == "1") ? 4'b0001 :
                               (shiftright_clock == "2") ? 4'b0010 :
                               (shiftright_clock == "3") ? 4'b0011 : 4'b0000;

assign shiftright_aclrval_ir = (shiftright_clear == "0")  ? 4'b0000 :
                                (shiftright_clear == "1") ? 4'b0001 :
                                (shiftright_clear == "2") ? 4'b0010 :
                                (shiftright_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign shiftright_clk_ir = clk[shiftright_clkval_ir] ? 1'b1 : 1'b0;
assign shiftright_aclr_ir = aclr[shiftright_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign shiftright_sload_ir = ena[shiftright_clkval_ir] ? 1'b1 : 1'b0;
assign shiftright_bypass_register_ir = (shiftright_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the round input Register
stratixiv_mac_register round_input_register (
                                         .datain(round),
                                         .clk(round_clk_ir),
                                         .aclr(round_aclr_ir),
                                         .sload(round_sload_ir),
                                         .bypass_register(round_bypass_register_ir),
                                         .dataout(round_in_reg)
                                        );
defparam round_input_register.data_width = 1;

//decode the clk and aclr values
assign round_clkval_ir =(round_clock == "0") ? 4'b0000 :
                          (round_clock == "1") ? 4'b0001 :
                          (round_clock == "2") ? 4'b0010 :
                          (round_clock == "3") ? 4'b0011 : 4'b0000;

assign round_aclrval_ir = (round_clear == "0")  ? 4'b0000 :
                           (round_clear == "1") ? 4'b0001 :
                           (round_clear == "2") ? 4'b0010 :
                           (round_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign round_clk_ir = clk[round_clkval_ir] ? 1'b1 : 1'b0;
assign round_aclr_ir = aclr[round_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign round_sload_ir = ena[round_clkval_ir] ? 1'b1 : 1'b0;
assign round_bypass_register_ir = (round_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the saturate input Register
stratixiv_mac_register saturate_input_register (
                                            .datain(saturate),
                                            .clk(saturate_clk_ir),
                                            .aclr(saturate_aclr_ir),
                                            .sload(saturate_sload_ir),
                                            .bypass_register(saturate_bypass_register_ir),
                                            .dataout(saturate_in_reg)
                                        );
defparam saturate_input_register.data_width = 1;

//decode the clk and aclr values
assign saturate_clkval_ir =(saturate_clock == "0") ? 4'b0000 :
                             (saturate_clock == "1") ? 4'b0001 :
                             (saturate_clock == "2") ? 4'b0010 :
                             (saturate_clock == "3") ? 4'b0011 : 4'b0000;

assign saturate_aclrval_ir = (saturate_clear == "0")  ? 4'b0000 :
                              (saturate_clear == "1") ? 4'b0001 :
                              (saturate_clear == "2") ? 4'b0010 :
                              (saturate_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign saturate_clk_ir = clk[saturate_clkval_ir] ? 1'b1 : 1'b0;
assign saturate_aclr_ir = aclr[saturate_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign saturate_sload_ir = ena[saturate_clkval_ir] ? 1'b1 : 1'b0;
assign saturate_bypass_register_ir = (saturate_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the roundchainout input Register
stratixiv_mac_register roundchainout_input_register (
                                                 .datain(roundchainout),
                                                 .clk(roundchainout_clk_ir),
                                                 .aclr(roundchainout_aclr_ir),
                                                 .sload(roundchainout_sload_ir),
                                                 .bypass_register(roundchainout_bypass_register_ir),
                                                 .dataout(roundchainout_in_reg)
                                                );
defparam roundchainout_input_register.data_width = 1;

//decode the clk and aclr values
assign roundchainout_clkval_ir =(roundchainout_clock == "0") ? 4'b0000 :
                                  (roundchainout_clock == "1") ? 4'b0001 :
                                  (roundchainout_clock == "2") ? 4'b0010 :
                                  (roundchainout_clock == "3") ? 4'b0011 : 4'b0000;

assign roundchainout_aclrval_ir = (roundchainout_clear == "0")  ? 4'b0000 :
                                   (roundchainout_clear == "1") ? 4'b0001 :
                                   (roundchainout_clear == "2") ? 4'b0010 :
                                   (roundchainout_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign roundchainout_clk_ir = clk[roundchainout_clkval_ir] ? 1'b1 : 1'b0;
assign roundchainout_aclr_ir = aclr[roundchainout_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign roundchainout_sload_ir = ena[roundchainout_clkval_ir] ? 1'b1 : 1'b0;
assign roundchainout_bypass_register_ir = (roundchainout_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the saturatechainout input Register
stratixiv_mac_register saturatechainout_input_register (
                             .datain(saturatechainout),
                                                     .clk(saturatechainout_clk_ir),
                                                     .aclr(saturatechainout_aclr_ir),
                                                     .sload(saturatechainout_sload_ir),
                                                     .bypass_register(saturatechainout_bypass_register_ir),
                                                     .dataout(saturatechainout_in_reg)
                                                    );
defparam saturatechainout_input_register.data_width = 1;

//decode the clk and aclr values
assign saturatechainout_clkval_ir =(saturatechainout_clock == "0") ? 4'b0000 :
                                    (saturatechainout_clock == "1") ? 4'b0001 :
                                    (saturatechainout_clock == "2") ? 4'b0010 :
                                    (saturatechainout_clock == "3") ? 4'b0011 : 4'b0000;

assign saturatechainout_aclrval_ir =(saturatechainout_clear == "0")  ? 4'b0000 :
                                    (saturatechainout_clear == "1") ? 4'b0001 :
                                    (saturatechainout_clear == "2") ? 4'b0010 :
                                    (saturatechainout_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign saturatechainout_clk_ir = clk[saturatechainout_clkval_ir] ? 1'b1 : 1'b0;
assign saturatechainout_aclr_ir = aclr[saturatechainout_aclrval_ir] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign saturatechainout_sload_ir = ena[saturatechainout_clkval_ir] ? 1'b1 : 1'b0;
assign saturatechainout_bypass_register_ir = (saturatechainout_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the First level adder interface and sign extension block
 stratixiv_fsa_isse fsa_interface(
                              .dataa(dataa),
                              .datab(datab),
                              .datac(datac),
                              .datad(datad),
                              .chainin(chainin),
                              .signa(signa_in_reg),
                              .signb(signb_in_reg),
                              .dataa_out(dataa_fsa_in),
                              .datab_out(datab_fsa_in),
                              .datac_out(datac_fsa_in),
                              .datad_out(datad_fsa_in),
                              .chainin_out(chainin_coa_in),
                              .operation(operation)
                              );

defparam fsa_interface.dataa_width = dataa_width;
defparam fsa_interface.datab_width = datab_width;
defparam fsa_interface.datac_width = datac_width;
defparam fsa_interface.datad_width = datad_width;
defparam fsa_interface.chainin_width = chainin_width;
defparam fsa_interface.operation_mode = operation_mode;
defparam fsa_interface.multa_signa_internally_grounded = multa_signa_internally_grounded;
defparam fsa_interface.multa_signb_internally_grounded = multa_signb_internally_grounded;
defparam fsa_interface.multb_signa_internally_grounded = multb_signa_internally_grounded;
defparam fsa_interface.multb_signb_internally_grounded = multb_signb_internally_grounded;
defparam fsa_interface.multc_signa_internally_grounded = multc_signa_internally_grounded;
defparam fsa_interface.multc_signb_internally_grounded = multc_signb_internally_grounded;
defparam fsa_interface.multd_signa_internally_grounded = multd_signa_internally_grounded;
defparam fsa_interface.multd_signb_internally_grounded = multd_signb_internally_grounded;

assign sign = signa_in_reg | signb_in_reg;
//Instantiate First Stage Adder/Subtractor Unit0
stratixiv_first_stage_add_sub fsaunit0(
                                  .dataa(dataa_fsa_in),
                                  .datab(datab_fsa_in),
                                  .sign(sign),
                                  .operation(operation),
                                  .dataout(dataout_fsa0)
                                );
defparam fsaunit0.dataa_width = dataa_width;
defparam fsaunit0.datab_width = datab_width;
defparam fsaunit0.fsa_mode = first_adder0_mode;

//Instantiate First Stage Adder/Subtractor Unit1
stratixiv_first_stage_add_sub fsaunit1(
                                  .dataa(datac_fsa_in),
                                  .datab(datad_fsa_in),
                                  .sign(sign),
                                  .operation(operation),
                                  .dataout(dataout_fsa1)

                                  );
defparam fsaunit1.dataa_width = datac_width;
defparam fsaunit1.datab_width = datad_width;
defparam fsaunit1.fsa_mode = first_adder1_mode;

//Instantiate the zeroloopback pipeline Register
stratixiv_mac_register zeroloopback_pipeline_register (
                                                    .datain(zeroloopback_in_reg),
                                                    .clk(zeroloopback_clk_pip),
                                                    .aclr(zeroloopback_aclr_pip),
                                                    .sload(zeroloopback_sload_pip),
                                                    .bypass_register(zeroloopback_bypass_register_pip),
                                                    .dataout(zeroloopback_pip_reg)
                                                    );

defparam zeroloopback_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign zeroloopback_clkval_pip =(zeroloopback_pipeline_clock == "0") ? 4'b0000 :
                                (zeroloopback_pipeline_clock == "1") ? 4'b0001 :
                                (zeroloopback_pipeline_clock == "2") ? 4'b0010 :
                                (zeroloopback_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign zeroloopback_aclrval_pip = (zeroloopback_pipeline_clear == "0")  ? 4'b0000 :
                                   (zeroloopback_pipeline_clear == "1") ? 4'b0001 :
                                   (zeroloopback_pipeline_clear == "2") ? 4'b0010 :
                                   (zeroloopback_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign zeroloopback_clk_pip = clk[zeroloopback_clkval_pip] ? 1'b1 : 1'b0;
assign zeroloopback_aclr_pip = aclr[zeroloopback_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign zeroloopback_sload_pip = ena[zeroloopback_clkval_pip] ? 1'b1 : 1'b0;
assign zeroloopback_bypass_register_pip = (zeroloopback_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the zeroacc pipeline Register
stratixiv_mac_register zeroacc_pipeline_register (
                                              .datain(zeroacc_in_reg),
                                              .clk(zeroacc_clk_pip),
                                              .aclr(zeroacc_aclr_pip),
                                              .sload(zeroacc_sload_pip),
                                              .bypass_register(zeroacc_bypass_register_pip),
                                              .dataout(zeroacc_pip_reg)
                                             );

defparam zeroacc_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign zeroacc_clkval_pip =(zeroacc_pipeline_clock == "0") ? 4'b0000 :
                             (zeroacc_pipeline_clock == "1") ? 4'b0001 :
                             (zeroacc_pipeline_clock == "2") ? 4'b0010 :
                             (zeroacc_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign zeroacc_aclrval_pip = (zeroacc_pipeline_clear == "0")  ? 4'b0000 :
                              (zeroacc_pipeline_clear == "1") ? 4'b0001 :
                              (zeroacc_pipeline_clear == "2") ? 4'b0010 :
                              (zeroacc_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign zeroacc_clk_pip = clk[zeroacc_clkval_pip] ? 1'b1 : 1'b0;
assign zeroacc_aclr_pip = aclr[zeroacc_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign zeroacc_sload_pip = ena[zeroacc_clkval_pip] ? 1'b1 : 1'b0;
assign zeroacc_bypass_register_pip = (zeroacc_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the signa pipeline Register
stratixiv_mac_register signa_pipeline_register (
                                             .datain(signa_in_reg),
                                             .clk(signa_clk_pip),
                                             .aclr(signa_aclr_pip),
                                             .sload(signa_sload_pip),
                                             .bypass_register(signa_bypass_register_pip),
                                             .dataout(signa_pip_reg)
                                           );

defparam signa_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign signa_clkval_pip =(signa_pipeline_clock == "0") ? 4'b0000 :
                           (signa_pipeline_clock == "1") ? 4'b0001 :
                           (signa_pipeline_clock == "2") ? 4'b0010 :
                           (signa_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign signa_aclrval_pip = (signa_pipeline_clear == "0")  ? 4'b0000 :
                            (signa_pipeline_clear == "1") ? 4'b0001 :
                            (signa_pipeline_clear == "2") ? 4'b0010 :
                            (signa_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signa_clk_pip = clk[signa_clkval_pip] ? 1'b1 : 1'b0;
assign signa_aclr_pip = aclr[signa_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign signa_sload_pip = ena[signa_clkval_pip] ? 1'b1 : 1'b0;
assign signa_bypass_register_pip = (signa_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the signb pipeline Register
stratixiv_mac_register signb_pipeline_register (
                                             .datain(signb_in_reg),
                                             .clk(signb_clk_pip),
                                             .aclr(signb_aclr_pip),
                                             .sload(signb_sload_pip),
                                             .bypass_register(signb_bypass_register_pip),
                                             .dataout(signb_pip_reg)
                                            );

defparam signb_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign signb_clkval_pip = (signb_pipeline_clock == "0") ? 4'b0000 :
                            (signb_pipeline_clock == "1") ? 4'b0001 :
                            (signb_pipeline_clock == "2") ? 4'b0010 :
                            (signb_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign signb_aclrval_pip = (signb_pipeline_clear == "0")  ? 4'b0000 :
                            (signb_pipeline_clear == "1") ? 4'b0001 :
                            (signb_pipeline_clear == "2") ? 4'b0010 :
                            (signb_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signb_clk_pip = clk[signb_clkval_pip] ? 1'b1 : 1'b0;
assign signb_aclr_pip = aclr[signb_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign signb_sload_pip = ena[signb_clkval_pip] ? 1'b1 : 1'b0;
assign signb_bypass_register_pip = (signb_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the rotate pipeline Register
stratixiv_mac_register rotate_pipeline_register (
                                             .datain(rotate_in_reg),
                                             .clk(rotate_clk_pip),
                                             .aclr(rotate_aclr_pip),
                                             .sload(rotate_sload_pip),
                                             .bypass_register(rotate_bypass_register_pip),
                                             .dataout(rotate_pip_reg)
                                            );

defparam rotate_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign rotate_clkval_pip =(rotate_pipeline_clock == "0") ? 4'b0000 :
                            (rotate_pipeline_clock == "1") ? 4'b0001 :
                            (rotate_pipeline_clock == "2") ? 4'b0010 :
                            (rotate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign rotate_aclrval_pip =(rotate_pipeline_clear == "0")  ? 4'b0000 :
                            (rotate_pipeline_clear == "1") ? 4'b0001 :
                            (rotate_pipeline_clear == "2") ? 4'b0010 :
                            (rotate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign rotate_clk_pip = clk[rotate_clkval_pip] ? 1'b1 : 1'b0;
assign rotate_aclr_pip = aclr[rotate_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign rotate_sload_pip = ena[rotate_clkval_pip] ? 1'b1 : 1'b0;
assign rotate_bypass_register_pip = (rotate_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the shiftright pipeline Register
stratixiv_mac_register shiftright_pipeline_register (
                                                 .datain(shiftright_in_reg),
                                                 .clk(shiftright_clk_pip),
                                                 .aclr(shiftright_aclr_pip),
                                                 .sload(shiftright_sload_pip),
                                                 .bypass_register(shiftright_bypass_register_pip),
                                                 .dataout(shiftright_pip_reg)
                                                 );
defparam shiftright_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign shiftright_clkval_pip =(shiftright_pipeline_clock == "0") ? 4'b0000 :
                                (shiftright_pipeline_clock == "1") ? 4'b0001 :
                                (shiftright_pipeline_clock == "2") ? 4'b0010 :
                                (shiftright_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign shiftright_aclrval_pip = (shiftright_pipeline_clear == "0")  ? 4'b0000 :
                                 (shiftright_pipeline_clear == "1") ? 4'b0001 :
                                 (shiftright_pipeline_clear == "2") ? 4'b0010 :
                                 (shiftright_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign shiftright_clk_pip = clk[shiftright_clkval_pip] ? 1'b1 : 1'b0;
assign shiftright_aclr_pip = aclr[shiftright_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign shiftright_sload_pip = ena[shiftright_clkval_pip] ? 1'b1 : 1'b0;
assign shiftright_bypass_register_pip = (shiftright_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the round pipeline Register
stratixiv_mac_register round_pipeline_register (
                                             .datain(round_in_reg),
                                             .clk(round_clk_pip),
                                             .aclr(round_aclr_pip),
                                             .sload(round_sload_pip),
                                             .bypass_register(round_bypass_register_pip),
                                             .dataout(round_pip_reg)
                                           );

defparam round_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign round_clkval_pip = (round_pipeline_clock == "0") ? 4'b0000 :
                            (round_pipeline_clock == "1") ? 4'b0001 :
                            (round_pipeline_clock == "2") ? 4'b0010 :
                            (round_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign round_aclrval_pip = (round_pipeline_clear == "0")  ? 4'b0000 :
                            (round_pipeline_clear == "1") ? 4'b0001 :
                            (round_pipeline_clear == "2") ? 4'b0010 :
                            (round_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign round_clk_pip = clk[round_clkval_pip] ? 1'b1 : 1'b0;
assign round_aclr_pip = aclr[round_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign round_sload_pip = ena[round_clkval_pip] ? 1'b1 : 1'b0;
assign round_bypass_register_pip = (round_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the saturate pipeline Register
stratixiv_mac_register saturate_pipeline_register (
                                                .datain(saturate_in_reg),
                                                .clk(saturate_clk_pip),
                                                .aclr(saturate_aclr_pip),
                                                .sload(saturate_sload_pip),
                                                .bypass_register(saturate_bypass_register_pip),
                                                .dataout(saturate_pip_reg)
                                              );

defparam saturate_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign saturate_clkval_pip =(saturate_pipeline_clock == "0") ? 4'b0000 :
                              (saturate_pipeline_clock == "1") ? 4'b0001 :
                              (saturate_pipeline_clock == "2") ? 4'b0010 :
                              (saturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign saturate_aclrval_pip = (saturate_pipeline_clear == "0")  ? 4'b0000 :
                               (saturate_pipeline_clear == "1") ? 4'b0001 :
                               (saturate_pipeline_clear == "2") ? 4'b0010 :
                               (saturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign saturate_clk_pip = clk[saturate_clkval_pip] ? 1'b1 : 1'b0;
assign saturate_aclr_pip = aclr[saturate_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign saturate_sload_pip = ena[saturate_clkval_pip] ? 1'b1 : 1'b0;
assign saturate_bypass_register_pip = (saturate_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the roundchainout pipeline Register
stratixiv_mac_register roundchainout_pipeline_register (
                                                     .datain(roundchainout_in_reg),
                                                     .clk(roundchainout_clk_pip),
                                                     .aclr(roundchainout_aclr_pip),
                                                     .sload(roundchainout_sload_pip),
                                                     .bypass_register(roundchainout_bypass_register_pip),
                                                     .dataout(roundchainout_pip_reg)
                                                   );

defparam roundchainout_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign roundchainout_clkval_pip = (roundchainout_pipeline_clock == "0") ? 4'b0000 :
                                    (roundchainout_pipeline_clock == "1") ? 4'b0001 :
                                    (roundchainout_pipeline_clock == "2") ? 4'b0010 :
                                    (roundchainout_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign roundchainout_aclrval_pip = (roundchainout_pipeline_clear == "0")  ? 4'b0000 :
                                    (roundchainout_pipeline_clear == "1") ? 4'b0001 :
                                    (roundchainout_pipeline_clear == "2") ? 4'b0010 :
                                    (roundchainout_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign roundchainout_clk_pip = clk[roundchainout_clkval_pip] ? 1'b1 : 1'b0;
assign roundchainout_aclr_pip = aclr[roundchainout_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign roundchainout_sload_pip = ena[roundchainout_clkval_pip] ? 1'b1 : 1'b0;
assign roundchainout_bypass_register_pip = (roundchainout_pipeline_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the saturatechainout pipeline Register
stratixiv_mac_register saturatechainout_pipeline_register (
                                                        .datain(saturatechainout_in_reg),
                                                        .clk(saturatechainout_clk_pip),
                                                        .aclr(saturatechainout_aclr_pip),
                                                        .sload(saturatechainout_sload_pip),
                                                        .bypass_register(saturatechainout_bypass_register_pip),
                                                        .dataout(saturatechainout_pip_reg)
                                                      );

defparam saturatechainout_pipeline_register.data_width = 1;

//decode the clk and aclr values
assign saturatechainout_clkval_pip =(saturatechainout_pipeline_clock == "0") ? 4'b0000 :
                                     (saturatechainout_pipeline_clock == "1") ? 4'b0001 :
                                     (saturatechainout_pipeline_clock == "2") ? 4'b0010 :
                                     (saturatechainout_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign saturatechainout_aclrval_pip = (saturatechainout_pipeline_clear == "0")  ? 4'b0000 :
                                       (saturatechainout_pipeline_clear == "1") ? 4'b0001 :
                                       (saturatechainout_pipeline_clear == "2") ? 4'b0010 :
                                       (saturatechainout_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign saturatechainout_clk_pip = clk[saturatechainout_clkval_pip] ? 1'b1 : 1'b0;
assign saturatechainout_aclr_pip = aclr[saturatechainout_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign saturatechainout_sload_pip = ena[saturatechainout_clkval_pip] ? 1'b1 : 1'b0;
assign saturatechainout_bypass_register_pip = (saturatechainout_pipeline_clock == "none") ? 1'b1 : 1'b0;

// Instantiate fsa0 dataout pipline register
stratixiv_mac_register fsa0_pipeline_register (
                                           .datain(fsa_pip_datain1),
                                           .clk(fsa0_clk_pip),
                                           .aclr(fsa0_aclr_pip),
                                           .sload(fsa0_sload_pip),
                                           .bypass_register(fsa0_bypass_register_pip),
                                           .dataout(fsa0_pip_reg)
                                        );

defparam fsa0_pipeline_register.data_width = 72;


assign fsa_pip_datain1 = (operation_mode == "output_only") ? dataa_fsa_in : dataout_fsa0;


//decode the clk and aclr values
assign fsa0_clkval_pip =(first_adder0_clock == "0") ? 4'b0000 :
                         (first_adder0_clock == "1") ? 4'b0001 :
                         (first_adder0_clock == "2") ? 4'b0010 :
                         (first_adder0_clock == "3") ? 4'b0011 : 4'b0000;

assign fsa0_aclrval_pip =  (first_adder0_clear == "0")  ? 4'b0000 :
                            (first_adder0_clear == "1") ? 4'b0001 :
                            (first_adder0_clear == "2") ? 4'b0010 :
                            (first_adder0_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign fsa0_clk_pip = clk[fsa0_clkval_pip] ? 1'b1 : 1'b0;
assign fsa0_aclr_pip = aclr[fsa0_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign fsa0_sload_pip = ena[fsa0_clkval_pip] ? 1'b1 : 1'b0;
assign fsa0_bypass_register_pip = (first_adder0_clock == "none") ? 1'b1 : 1'b0;

// Instantiate fsa1 dataout pipline register
stratixiv_mac_register fsa1_pipeline_register (
                                           .datain(dataout_fsa1),
                                           .clk(fsa1_clk_pip),
                                           .aclr(fsa1_aclr_pip),
                                           .sload(fsa1_sload_pip),
                                           .bypass_register(fsa1_bypass_register_pip),
                                           .dataout(fsa1_pip_reg)
                                          );

defparam fsa1_pipeline_register.data_width = 72;

//decode the clk and aclr values
assign fsa1_clkval_pip =(first_adder1_clock == "0") ? 4'b0000 :
                          (first_adder1_clock == "1") ? 4'b0001 :
                          (first_adder1_clock == "2") ? 4'b0010 :
                          (first_adder1_clock == "3") ? 4'b0011 : 4'b0000;

assign fsa1_aclrval_pip =  (first_adder1_clear == "0")  ? 4'b0000 :
                            (first_adder1_clear == "1") ? 4'b0001 :
                            (first_adder1_clear == "2") ? 4'b0010 :
                            (first_adder1_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign fsa1_clk_pip = clk[fsa1_clkval_pip] ? 1'b1 : 1'b0;
assign fsa1_aclr_pip = aclr[fsa1_aclrval_pip] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign fsa1_sload_pip = ena[fsa1_clkval_pip] ? 1'b1 : 1'b0;
assign fsa1_bypass_register_pip = (first_adder1_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the second level adder/accumulator block
stratixiv_second_stage_add_accum ssa_unit(
                                      .dataa(fsa0_pip_reg),
                                      .datab(fsa1_pip_reg),
                                      .accumin(ssa_accum_in),
                                      .sign(ssa_sign),
                                      .operation(operation),
                                      .dataout(ssa_dataout),
                                      .overflow(ssa_overflow)
                                     );
defparam ssa_unit.dataa_width = dataa_width +1;
defparam ssa_unit.datab_width = datac_width + 1;
defparam ssa_unit.accum_width = dataa_width + 8;
defparam ssa_unit.ssa_mode = acc_adder_operation;

assign ssa_accum_in = (!zeroacc_pip_reg) ? rs_dataout_out_reg : 0;
assign ssa_sign = signa_pip_reg | signb_pip_reg;

// Instantiate round and saturation block
stratixiv_round_saturate_block rs_block(
                                   .datain(rs_datain),
                                   .round(round_pip_reg),
                                   .saturate(saturate_pip_reg),
                                   .signa(signa_pip_reg),
                                   .signb(signb_pip_reg),
                                   .datain_width(ssa_datain_width),
                                   .dataout(rs_dataout),
                                   .saturationoverflow(rs_saturation_overflow)
                                   );
defparam rs_block.dataa_width = dataa_width;
defparam rs_block.datab_width = datab_width;
defparam rs_block.saturate_width = saturate_width;
defparam rs_block.round_width = round_width;
defparam rs_block.saturate_mode = saturate_mode;
defparam rs_block.round_mode = round_mode;
defparam rs_block.operation_mode = operation_mode;

assign rs_datain = ((operation_mode == "output_only") ||
                   (operation_mode == "one_level_adder")||
                   (operation_mode == "loopback")) ? fsa0_pip_reg :ssa_dataout ;

assign ssa_datain_width_tmp = (((operation_mode == "accumulator")||(operation_mode == "accumulator_chain_out")||(operation_mode == "two_level_adder_chain_out"))  ? (dataa_width[7:0] + 4'h8) :
                          (operation_mode == "two_level_adder") ? (dataa_width[7:0] + 4'h2) :
                          ((operation_mode == "shift" ) || (operation_mode == "36_bit_multiply" )) ? (dataa_width[7:0] + datab_width[7:0]):
                          ((operation_mode == "double" )) ? (dataa_width[7:0] + 4'h8) : dataa_width[7:0]);

assign ssa_datain_width = (ssa_datain_width_tmp >= round_width) ? ssa_datain_width_tmp : round_width[7:0];



//Instantiate the zeroloopback output Register
stratixiv_mac_register zeroloopback_output_register (
                                                 .datain(zeroloopback_pip_reg),
                                                 .clk(zeroloopback_clk_or),
                                                 .aclr(zeroloopback_aclr_or),
                                                 .sload(zeroloopback_sload_or),
                                                 .bypass_register(zeroloopback_bypass_register_or),
                                                 .dataout(zeroloopback_out_reg)
                                                );

defparam zeroloopback_output_register.data_width = 1;

//decode the clk and aclr values
assign zeroloopback_clkval_or =(zeroloopback_output_clock == "0") ? 4'b0000 :
                                (zeroloopback_output_clock == "1") ? 4'b0001 :
                                (zeroloopback_output_clock == "2") ? 4'b0010 :
                                (zeroloopback_output_clock == "3") ? 4'b0011 : 4'b0000;

assign zeroloopback_aclrval_or =(zeroloopback_output_clear == "0")  ? 4'b0000 :
                                 (zeroloopback_output_clear == "1") ? 4'b0001 :
                                 (zeroloopback_output_clear == "2") ? 4'b0010 :
                                 (zeroloopback_output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign zeroloopback_clk_or = clk[zeroloopback_clkval_or] ? 1'b1 : 1'b0;
assign zeroloopback_aclr_or = aclr[zeroloopback_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign zeroloopback_sload_or = ena[zeroloopback_clkval_or] ? 1'b1 : 1'b0;
assign zeroloopback_bypass_register_or = (zeroloopback_output_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the zerochainout output Register
stratixiv_mac_register zerochainout_output_register (
                                                 .datain(zerochainout),
                                                 .clk(zerochainout_clk_or),
                                                 .aclr(zerochainout_aclr_or),
                                                 .sload(zerochainout_sload_or),
                                                 .bypass_register(zerochainout_bypass_register_or),
                                                 .dataout(zerochainout_out_reg)
                                                );

defparam zerochainout_output_register.data_width = 1;

//decode the clk and aclr values
assign zerochainout_clkval_or =(zerochainout_output_clock == "0") ? 4'b0000 :
                                 (zerochainout_output_clock == "1") ? 4'b0001 :
                                 (zerochainout_output_clock == "2") ? 4'b0010 :
                                 (zerochainout_output_clock == "3") ? 4'b0011 : 4'b0000;

assign zerochainout_aclrval_or =(zerochainout_output_clear == "0")  ? 4'b0000 :
                                 (zerochainout_output_clear == "1") ? 4'b0001 :
                                 (zerochainout_output_clear == "2") ? 4'b0010 :
                                 (zerochainout_output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign zerochainout_clk_or = clk[zerochainout_clkval_or] ? 1'b1 : 1'b0;
assign zerochainout_aclr_or = aclr[zerochainout_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign zerochainout_sload_or = ena[zerochainout_clkval_or] ? 1'b1 : 1'b0;
assign zerochainout_bypass_register_or = (zerochainout_output_clock == "none") ? 1'b1 : 1'b0;


// Instantiate Round_Saturate dataout output register
stratixiv_mac_register rs_dataout_output_register (
                                                .datain(rs_dataout_in),
                                                .clk(rs_dataout_clk_or),
                                                .aclr(rs_dataout_aclr_or),
                                                .sload(rs_dataout_sload_or),
                                                .bypass_register(rs_dataout_bypass_register_or),
                                                .dataout(rs_dataout_out_reg)
                                               );

defparam rs_dataout_output_register.data_width = 72;

assign rs_dataout_in = ((operation_mode == "36_bit_multiply" )||(operation_mode == "shift")) ?
                        ssa_dataout : rs_dataout_of;


// Instantiate Round_Saturate saturation_overflow output register
stratixiv_mac_register rs_saturation_overflow_output_register (
                                                            .datain(rs_saturation_overflow_in),
                                                            .clk(rs_dataout_clk_or),
                                                            .aclr(rs_dataout_aclr_or),
                                                            .sload(rs_dataout_sload_or),
                                                            .bypass_register(rs_dataout_bypass_register_or),
                                                            .dataout(rs_saturation_overflow_out_reg)
                                                          );

defparam rs_saturation_overflow_output_register.data_width = 1;


// rs_dataout and the saturation_overflow uses the same control signals "second_adder_clock/clear" in chainout mode else output_clock/clear
//decode the clk and aclr values
assign rs_saturation_overflow_in = (saturate_pip_reg == 1'b1) ? rs_saturation_overflow : ssa_overflow;
assign rs_dataout_clkval_or_co = (second_adder_clock == "0") ? 4'b0000 :
                                (second_adder_clock == "1") ? 4'b0001 :
                                (second_adder_clock == "2") ? 4'b0010 :
                                (second_adder_clock == "3") ? 4'b0011 : 4'b0000;

assign rs_dataout_aclrval_or_co = (second_adder_clear == "0")  ? 4'b0000 :
                                (second_adder_clear == "1") ? 4'b0001 :
                                (second_adder_clear == "2") ? 4'b0010 :
                                (second_adder_clear == "3") ? 4'b0011 : 4'b0000;

assign rs_dataout_clkval_or_o = (output_clock == "0") ? 4'b0000 :
                                (output_clock == "1") ? 4'b0001 :
                                (output_clock == "2") ? 4'b0010 :
                                (output_clock == "3") ? 4'b0011 : 4'b0000;

assign rs_dataout_aclrval_or_o = (output_clear == "0")  ? 4'b0000 :
                                (output_clear == "1") ? 4'b0001 :
                                (output_clear == "2") ? 4'b0010 :
                                (output_clear == "3") ? 4'b0011 : 4'b0000;
assign rs_dataout_clkval_or = ((operation_mode == "two_level_adder_chain_out") || (operation_mode == "accumulator_chain_out" )) ? rs_dataout_clkval_or_co : rs_dataout_clkval_or_o;
assign rs_dataout_aclrval_or = ((operation_mode == "two_level_adder_chain_out") || (operation_mode == "accumulator_chain_out" )) ? rs_dataout_aclrval_or_co : rs_dataout_aclrval_or_o;


//assign the corresponding clk,aclr,enable and bypass register values.
assign rs_dataout_clk_or = clk[rs_dataout_clkval_or] ? 1'b1 : 1'b0;
assign rs_dataout_aclr_or = aclr[rs_dataout_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign rs_dataout_sload_or = ena[rs_dataout_clkval_or] ? 1'b1 : 1'b0;
assign rs_dataout_bypass_register_or_co = (second_adder_clock == "none") ? 1'b1 : 1'b0;
assign rs_dataout_bypass_register_or_o = (output_clock == "none") ? 1'b1 : 1'b0;

assign rs_dataout_bypass_register_or = ((operation_mode == "two_level_adder_chain_out") || (operation_mode == "accumulator_chain_out" )) ? rs_dataout_bypass_register_or_co : rs_dataout_bypass_register_or_o;


//Instantiate the rotate output Register
stratixiv_mac_register rotate_output_register (
                                           .datain(rotate_pip_reg),
                                           .clk(rotate_clk_or),
                                           .aclr(rotate_aclr_or),
                                           .sload(rotate_sload_or),
                                           .bypass_register(rotate_bypass_register_or),
                                           .dataout(rotate_out_reg)
                                          );

defparam rotate_output_register.data_width = 1;

//decode the clk and aclr values
assign rotate_clkval_or = (rotate_output_clock == "0") ? 4'b0000 :
                            (rotate_output_clock == "1") ? 4'b0001 :
                            (rotate_output_clock == "2") ? 4'b0010 :
                            (rotate_output_clock == "3") ? 4'b0011 : 4'b0000;

assign rotate_aclrval_or = (rotate_output_clear == "0")  ? 4'b0000 :
                            (rotate_output_clear == "1") ? 4'b0001 :
                            (rotate_output_clear == "2") ? 4'b0010 :
                            (rotate_output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign rotate_clk_or = clk[rotate_clkval_or] ? 1'b1 : 1'b0;
assign rotate_aclr_or = aclr[rotate_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign rotate_sload_or = ena[rotate_clkval_or] ? 1'b1 : 1'b0;
assign rotate_bypass_register_or = (rotate_output_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the shiftright output Register
stratixiv_mac_register shiftright_output_register (
                                                .datain(shiftright_pip_reg),
                                                .clk(shiftright_clk_or),
                                                .aclr(shiftright_aclr_or),
                                                .sload(shiftright_sload_or),
                                                .bypass_register(shiftright_bypass_register_or),
                                                .dataout(shiftright_out_reg)
                                               );

defparam shiftright_output_register.data_width = 1;

//decode the clk and aclr values
assign shiftright_clkval_or = (shiftright_output_clock == "0") ? 4'b0000 :
                                (shiftright_output_clock == "1") ? 4'b0001 :
                                (shiftright_output_clock == "2") ? 4'b0010 :
                                (shiftright_output_clock == "3") ? 4'b0011 : 4'b0000;

assign shiftright_aclrval_or = (shiftright_output_clear == "0")  ? 4'b0000 :
                                (shiftright_output_clear == "1") ? 4'b0001 :
                                (shiftright_output_clear == "2") ? 4'b0010 :
                                (shiftright_output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign shiftright_clk_or = clk[shiftright_clkval_or] ? 1'b1 : 1'b0;
assign shiftright_aclr_or = aclr[shiftright_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign shiftright_sload_or = ena[shiftright_clkval_or] ? 1'b1 : 1'b0;
assign shiftright_bypass_register_or = (shiftright_output_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the roundchainout output Register
stratixiv_mac_register roundchainout_output_register (
                                                  .datain(roundchainout_pip_reg),
                                                  .clk(roundchainout_clk_or),
                                                  .aclr(roundchainout_aclr_or),
                                                  .sload(roundchainout_sload_or),
                                                  .bypass_register(roundchainout_bypass_register_or),
                                                  .dataout(roundchainout_out_reg)
                                                 );

defparam roundchainout_output_register.data_width = 1;

//decode the clk and aclr values
assign roundchainout_clkval_or =(roundchainout_output_clock == "0") ? 4'b0000 :
                                  (roundchainout_output_clock == "1") ? 4'b0001 :
                                  (roundchainout_output_clock == "2") ? 4'b0010 :
                                  (roundchainout_output_clock == "3") ? 4'b0011 : 4'b0000;

assign roundchainout_aclrval_or = (roundchainout_output_clear == "0")  ? 4'b0000 :
                                   (roundchainout_output_clear == "1") ? 4'b0001 :
                                   (roundchainout_output_clear == "2") ? 4'b0010 :
                                   (roundchainout_output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign roundchainout_clk_or = clk[roundchainout_clkval_or] ? 1'b1 : 1'b0;
assign roundchainout_aclr_or = aclr[roundchainout_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign roundchainout_sload_or = ena[roundchainout_clkval_or] ? 1'b1 : 1'b0;
assign roundchainout_bypass_register_or = (roundchainout_output_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the saturatechainout output Register
stratixiv_mac_register saturatechainout_output_register (
                                                     .datain(saturatechainout_pip_reg),
                                                     .clk(saturatechainout_clk_or),
                                                     .aclr(saturatechainout_aclr_or),
                                                     .sload(saturatechainout_sload_or),
                                                     .bypass_register(saturatechainout_bypass_register_or),
                                                     .dataout(saturatechainout_out_reg)
                                                    );
defparam saturatechainout_output_register.data_width = 1;

//decode the clk and aclr values
assign saturatechainout_clkval_or =(saturatechainout_output_clock == "0") ? 4'b0000 :
                                     (saturatechainout_output_clock == "1") ? 4'b0001 :
                                     (saturatechainout_output_clock == "2") ? 4'b0010 :
                                     (saturatechainout_output_clock == "3") ? 4'b0011 : 4'b0000;

assign saturatechainout_aclrval_or = (saturatechainout_output_clear == "0")  ? 4'b0000 :
                                      (saturatechainout_output_clear == "1") ? 4'b0001 :
                                      (saturatechainout_output_clear == "2") ? 4'b0010 :
                                      (saturatechainout_output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign saturatechainout_clk_or = clk[saturatechainout_clkval_or] ? 1'b1 : 1'b0;
assign saturatechainout_aclr_or = aclr[saturatechainout_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign saturatechainout_sload_or = ena[saturatechainout_clkval_or] ? 1'b1 : 1'b0;
assign saturatechainout_bypass_register_or = (saturatechainout_output_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the Carry chainout Adder
stratixiv_carry_chain_adder chainout_adder(
                                        .dataa(rs_dataout_out_reg),
                                        .datab(chainin_coa_in),
                                        .dataout(coa_dataout)
                      );
//Instantiate the carry chainout adder RS Block
stratixiv_round_saturate_block coa_rs_block(
                                        .datain(coa_dataout),
                                        .round(roundchainout_out_reg),
                                        .saturate(saturatechainout_out_reg),
                                        .signa(signa_pip_reg),
                                        .signb(signb_pip_reg),
                                        .datain_width(coa_datain_width),
                                        .dataout(coa_rs_dataout),
                                        .saturationoverflow(coa_rs_saturation_overflow)
                                       );
defparam coa_rs_block.dataa_width = dataa_width;
defparam coa_rs_block.datab_width = datab_width;
defparam coa_rs_block.saturate_width = saturate_chain_out_width;
defparam coa_rs_block.round_width =round_width;
defparam coa_rs_block.saturate_mode = saturate_chain_out_mode;
defparam coa_rs_block.round_mode = round_chain_out_mode;
defparam coa_rs_block.operation_mode = operation_mode;

assign coa_datain_width = ssa_datain_width;
assign coa_round_width = round_chain_out_width[3:0];
assign coa_fraction_width  = coa_datain_width - saturate_chain_out_width[7:0];
//Instantiate the rs_saturation_overflow output register (after COA)
stratixiv_mac_register coa_rs_saturation_overflow_register (
                                                        .datain(rs_saturation_overflow_out_reg),
                                                        .clk(coa_reg_clk_or),
                                                        .aclr(coa_reg_aclr_or),
                                                        .sload(coa_reg_sload_or),
                                                        .bypass_register(1'b1),
                                                        .dataout(coa_rs_saturation_overflow_out_reg)
                                                        );
defparam coa_rs_saturation_overflow_register.data_width = 1;

//Instantiate the rs_saturationchainout_overflow output register
stratixiv_mac_register coa_rs_saturationchainout_overflow_register (
                                                                .datain(coa_rs_saturation_overflow),
                                                                .clk(coa_reg_clk_or),
                                                                .aclr(coa_reg_aclr_or),
                                                                .sload(coa_reg_sload_or),
                                                                .bypass_register(coa_reg_bypass_register_or),
                                                                .dataout(coa_rs_saturationchainout_overflow_out_reg)
                                                                );
defparam coa_rs_saturationchainout_overflow_register.data_width = 1;

// Instantiate the coa_rs_dataout output register
stratixiv_mac_register coa_rs_dataout_register (
                                             .datain(coa_rs_dataout),
                                             .clk(coa_reg_clk_or),
                                             .aclr(coa_reg_aclr_or),
                                             .sload(coa_reg_sload_or),
                                             .bypass_register(coa_reg_bypass_register_or),
                                             .dataout(coa_rs_dataout_out_reg)
                                             );
defparam coa_rs_dataout_register.data_width = 72;

//decode the clk and aclr values
assign coa_reg_clkval_or =(output_clock == "0") ? 4'b0000 :
                            (output_clock == "1") ? 4'b0001 :
                            (output_clock == "2") ? 4'b0010 :
                            (output_clock == "3") ? 4'b0011 : 4'b0000;

assign coa_reg_aclrval_or =(output_clear == "0")  ? 4'b0000 :
                            (output_clear == "1") ? 4'b0001 :
                            (output_clear == "2") ? 4'b0010 :
                            (output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign coa_reg_clk_or = clk[coa_reg_clkval_or] ? 1'b1 : 1'b0;
assign coa_reg_aclr_or = aclr[coa_reg_aclrval_or] || ~devclrn || ~devpor   ? 1'b1 : 1'b0;
assign coa_reg_sload_or = ena[coa_reg_clkval_or] ? 1'b1 : 1'b0;
assign coa_reg_bypass_register_or = (output_clock == "none") ? 1'b1 : 1'b0;

//Instantiate the Shift/Rotate Unit

stratixiv_rotate_shift_block shift_rot_unit(
                                         .datain(rs_dataout_out_reg),
                                         .rotate(rotate_out_reg),
                                         .shiftright(shiftright_out_reg),
                                         .signa(signa_pip_reg),
                                         .signb(signb_pip_reg),
                                         .dataout(dataout_shift_rot)
                                        );
defparam shift_rot_unit.dataa_width = dataa_width;
defparam shift_rot_unit.datab_width = datab_width;



//Assign the dataout depending on the mode of operation
assign dataout_tmp = ((operation_mode == "accumulator_chain_out")||(operation_mode == "two_level_adder_chain_out"))
                     ? coa_rs_dataout_out_reg :
                     (operation_mode == "shift") ? dataout_shift_rot : rs_dataout_out_reg;


//Assign the loopbackout for loopback mode
assign loopbackout_tmp = ((operation_mode == "loopback") && (!zeroloopback_out_reg)) ? rs_dataout_out_reg : 0;

//Assign the saturation overflow output
assign overflow = ((operation_mode == "accumulator") ||(operation_mode == "two_level_adder"))
                  ? rs_saturation_overflow_out_reg :
                  ((operation_mode == "accumulator_chain_out")||(operation_mode == "two_level_adder_chain_out"))
                  ? coa_rs_saturation_overflow_out_reg : 1'b0;

//Assign the saturationchainout overflow output
assign saturatechainoutoverflow = ((operation_mode == "accumulator_chain_out") ||(operation_mode == "two_level_adder_chain_out"))
                                    ? coa_rs_saturationchainout_overflow_out_reg : 1'b0;

assign dataout = (((operation_mode == "accumulator_chain_out")||(operation_mode == "two_level_adder_chain_out")) &&(zerochainout_out_reg == 1'b1)) ? 72'b0 :dataout_tmp;
assign loopbackout = loopbackout_tmp[35:18];

endmodule


// begin_ddr
//-----------------------------------------------------------------------------
// Module Name: stratixiv_ddr_gray_decoder
// Description: auxilary module for ddr. Gray decoder
//-----------------------------------------------------------------------------
`timescale 1 ps/1 ps
module stratixiv_ddr_gray_decoder (
        gin, 
        bout
);

parameter width = 6;

input  [width-1 : 0] gin;
output [width-1 : 0] bout;

reg    [width-1 : 0] breg;
integer i;
assign bout = breg;
always @(gin)
begin
    breg[width-1] = gin[width-1];
    if (width > 1)
    begin
        for (i=width-2; i >= 0; i=i-1)
            breg[i] = breg[i+1] ^ gin[i];
    end
end
endmodule

//-----------------------------------------------------------------------------
// Module Name: stratixiv_ddr_delay_chain_s
// Description: auxilary module - delay chain-setting
//-----------------------------------------------------------------------------
`timescale 1 ps/1 ps
module stratixiv_ddr_delay_chain_s (
        clk, 
        delayctrlin, 
        phasectrlin, 
        delayed_clkout
);

parameter use_phasectrlin = "true";
parameter phase_setting   = 0;
parameter sim_buffer_intrinsic_delay  = 350;
parameter sim_buffer_delay_increment  = 10;
parameter phasectrlin_limit = 7;

input          clk;
input  [5 : 0] delayctrlin;
input  [3 : 0] phasectrlin;
output         delayed_clkout;

// decoded counter
wire [5:0]  delayctrl_bin;

// cell delay
integer     acell_delay;
integer     delay_chain_len;
integer     clk_delay;
// int signals
reg         delayed_clk;

// filtering X/U etc.
wire  [5 : 0] delayctrlin_in;
wire  [3 : 0] phasectrlin_in;
assign delayctrlin_in[0] = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
assign delayctrlin_in[1] = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
assign delayctrlin_in[2] = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
assign delayctrlin_in[3] = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
assign delayctrlin_in[4] = (delayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
assign delayctrlin_in[5] = (delayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
assign phasectrlin_in[0] = (phasectrlin[0] === 1'b1) ? 1'b1 : 1'b0;
assign phasectrlin_in[1] = (phasectrlin[1] === 1'b1) ? 1'b1 : 1'b0;
assign phasectrlin_in[2] = (phasectrlin[2] === 1'b1) ? 1'b1 : 1'b0;
assign phasectrlin_in[3] = (phasectrlin[3] === 1'b1) ? 1'b1 : 1'b0;

initial 
begin
    acell_delay = 0;
    delay_chain_len = 0;
    clk_delay = 0;

    delayed_clk = 1'b0;
end

stratixiv_ddr_gray_decoder m_delayctrl_in_dec(delayctrlin_in, delayctrl_bin);

always @(delayctrl_bin or phasectrlin_in)
begin
    // cell
    acell_delay = sim_buffer_intrinsic_delay + delayctrl_bin * sim_buffer_delay_increment;

    // no of cells
    if (use_phasectrlin == "false")
        delay_chain_len = phase_setting;
    else
        delay_chain_len = (phasectrlin_in > phasectrlin_limit) ? 0 : phasectrlin_in;

    // total delay        - added extra 1 ps for resolving racing
    clk_delay = delay_chain_len * acell_delay  + 1;
    
    if ((use_phasectrlin == "true") && (phasectrlin_in > phasectrlin_limit))
    begin
        $display($time, " Warning: DDR phasesetting %m has invalid setting %b", phasectrlin_in);
    end     
end

// delayed clock
always @(clk)
    delayed_clk <= #(clk_delay) clk;  
      
assign  delayed_clkout = delayed_clk;

endmodule

//-----------------------------------------------------------------------------
// Module Name: stratixiv_ddr_io_reg
// Description: io register model based on dffeas with 
//              input port 'rpt_viloation' addition
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps
module stratixiv_ddr_io_reg (
        d, 
        clk, 
        ena, 
        clrn, 
        prn, 
        aload, 
        asdata, 
        sclr, 
        sload, 
        devclrn, 
        devpor, 
        rpt_violation, 
        q 
);
// GLOBAL PARAMETER DECLARATION
parameter power_up = "DONT_CARE";
parameter is_wysiwyg = "false";

// LOCAL_PARAMETERS_BEGIN

parameter x_on_violation = "on";

// LOCAL_PARAMETERS_END

input d;
input clk;
input ena;
input clrn;
input prn;
input aload; 
input asdata;  
input sclr; 
input sload; 
input devclrn; 
input devpor; 
input rpt_violation;

output q;

wire q_tmp;

wire reset;
   
reg viol;

wire nosloadsclr;
wire sloaddata;

    assign reset = devpor && devclrn && clrn && ena && rpt_violation;
    assign nosloadsclr = reset && (~sload && ~sclr);
    assign sloaddata = reset && sload;

    assign q = q_tmp;
   
   dffeas  ddr_reg (                                    
                   .d(d),                   
                   .clk(clk),                       
                   .clrn(clrn),                
                   .aload(aload),                       
                   .sclr(sclr),                
                   .sload(sload),              
                   .asdata(asdata),        
                   .ena(ena),                          
                   .prn(prn),                  
                   .q(q_tmp),                      
                   .devpor(devpor),                    
                   .devclrn(devclrn)           
                  );                                   
    defparam ddr_reg.power_up = power_up;               

specify

    $setuphold (posedge clk &&& nosloadsclr, d, 0, 0, viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, viol) ;
    $setuphold (posedge clk &&& sloaddata, asdata, 0, 0, viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, viol) ;
      
    (posedge clk => (q +: d)) = 0 ;
    (posedge clrn => (q +: 1'b0)) = (0, 0) ;
    (posedge prn => (q +: 1'b1)) = (0, 0) ;
    (posedge aload => (q +: d)) = (0, 0) ;
    (asdata => q) = (0, 0) ;
      
endspecify
   

endmodule

//-----------------------------------------------------------------------------
//
// Module Name : stratixiv_dll
//
// Description : STRATIXIV Delay Locked Loop 
//               Verilog simulation model 
//
//-----------------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixiv_dll (
    clk, 
    aload, 
    upndnin, 
    upndninclkena, 
    devclrn,
    devpor,        
    offsetdelayctrlout, 
    offsetdelayctrlclkout, 
    delayctrlout, 
    dqsupdate,
    upndnout
);

// GLOBAL PARAMETERS - total 12
parameter input_frequency    = "0 ps";
parameter delay_buffer_mode  = "low";   // consistent with dqs
parameter delay_chain_length = 12;
parameter delayctrlout_mode  = "normal";
parameter jitter_reduction   = "false";
parameter use_upndnin        = "false";
parameter use_upndninclkena  = "false";
parameter sim_valid_lock     = 16;
parameter sim_valid_lockcount      = 0;  // 0 = 350 + 10*dllcounter
parameter sim_low_buffer_intrinsic_delay = 350;
parameter sim_high_buffer_intrinsic_delay = 175;
parameter sim_buffer_delay_increment = 10;
parameter static_delay_ctrl  = 0;        // for test
parameter dual_phase_comparators = "true"; // new in stratixiv

parameter lpm_type           = "stratixiv_dll";

// LOCAL_PARAMETERS_BEGIN

parameter sim_buffer_intrinsic_delay = (delay_buffer_mode == "low") ? sim_low_buffer_intrinsic_delay
                                       : sim_high_buffer_intrinsic_delay;

// LOCAL_PARAMETERS_END

// INPUT PORTS
input        aload;
input        clk;
input        upndnin;
input        upndninclkena;
input        devclrn;
input        devpor;

// OUTPUT PORTS
output [5:0] delayctrlout;
output       dqsupdate;
output [5:0] offsetdelayctrlout;
output       offsetdelayctrlclkout;
output       upndnout;

tri1 devclrn;
tri1 devpor;

// BUFFERED BUS INPUTS

// TMP OUTPUTS
wire [5:0] delayctrl_out;
wire [5:0] offsetdelayctrl_out;
wire       dqsupdate_out;
wire       upndn_out;


// FUNCTIONS

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
endfunction  // str2int

// Const VARIABLES to represent string parameters
reg [1:0] para_delay_buffer_mode;
reg [1:0] para_delayctrlout_mode;
reg [5:0] para_static_delay_ctrl;
reg       para_jitter_reduction;
reg       para_use_upndnin;
reg       para_use_upndninclkena;
 

// INTERNAL NETS AND VARIABLES

// for functionality - by modules

// two reg on the de-assertion of dll
wire aload_in;
reg  aload_reg1;
reg  aload_reg2;

// delay and offset control out resolver
wire [5:0] dr_delayctrl_out;
wire [5:0] dr_delayctrl_int;
wire [5:0] dr_offsetctrl_out;
wire [5:0] dr_dllcount_in;
wire       dr_clk8_in;
wire       dr_aload_in;

reg  [5:0] dr_reg_dllcount;

// delay chain setting counter
wire [5:0] dc_dllcount_out;
wire [5:0] dc_dllcount_out_gray;
wire       dc_upndn_in;
wire       dc_aload_in;
wire       dc_upndnclkena_in;
wire       dc_clk8_in;
wire       dc_clk1_in;
wire       dc_dlltolock_in;

reg [5:0]  dc_reg_dllcount;
reg        dc_reg_dlltolock_pulse;

// jitter reduction counter
wire       jc_upndn_out;
wire       jc_upndnclkena_out;
wire       jc_clk8_in;
wire       jc_upndn_in;
wire       jc_aload_in;
wire       jc_clkena_in;  // new in stratixiv

integer    jc_count;
reg        jc_reg_upndn;
reg        jc_reg_upndnclkena;

// phase comparator
wire       pc_lock;      // new in stratixiv
wire       pc_upndn_out;
wire [5:0] pc_dllcount_in;
wire       pc_clk1_in;
wire       pc_clk8_in;
wire       pc_aload_in;

reg        pc_reg_upndn;
integer    pc_delay;
reg        pc_lock_reg;   // new in stratixiv
integer    pc_comp_range; // new in stratixiv

// clock generator
wire       cg_clk_in;
wire       cg_aload_in;
wire       cg_clk1_out;
        
wire cg_clk8a_out;
wire cg_clk8b_out;
     
reg cg_reg_1;
reg cg_rega_2;
reg cg_rega_3;
       
reg cg_regb_2;
reg cg_regb_3;

// for violation checks
reg clk_in_last_value;
reg got_first_rising_edge;
reg got_first_falling_edge;

reg per_violation;
reg duty_violation;
reg sent_per_violation;
reg sent_duty_violation;


reg dll_to_lock;  // exported signal  

time clk_in_last_rising_edge;
time clk_in_last_falling_edge;

integer input_period;
integer clk_per_tolerance;
integer duty_cycle;
integer half_cycles_to_lock;
integer clk_in_period;
integer clk_in_duty_cycle;


// Timing hooks

// BUFFER INPUTS
wire clk_in;
wire aload_in_buf;
wire upndn_in;
wire upndninclkena_in; 

assign clk_in           =  clk;
assign aload_in_buf     =  (aload === 1'b1) ? 1'b1 : 1'b0;
assign upndn_in         =  (upndnin === 1'b1) ? 1'b1 : 1'b0;
assign upndninclkena_in =  (upndninclkena === 1'b1) ? 1'b1 : 1'b0; 

// TCO DELAYS, IO PATH and SETUP-HOLD CHECKS
specify
	(posedge clk => (delayctrlout[0] +: delayctrl_out[0])) = (0, 0);
	(posedge clk => (delayctrlout[1] +: delayctrl_out[1])) = (0, 0);
	(posedge clk => (delayctrlout[2] +: delayctrl_out[2])) = (0, 0);
	(posedge clk => (delayctrlout[3] +: delayctrl_out[3])) = (0, 0);
	(posedge clk => (delayctrlout[4] +: delayctrl_out[4])) = (0, 0);
	(posedge clk => (delayctrlout[5] +: delayctrl_out[5])) = (0, 0);

    (posedge clk  => (upndnout +: upndn_out)) = (0, 0);
    
	$setuphold(posedge clk, upndnin, 0, 0);
	$setuphold(posedge clk, upndninclkena, 0, 0);
endspecify

// DRIVERs FOR outputs
and (delayctrlout[0], delayctrl_out[0], 1'b1);
and (delayctrlout[1], delayctrl_out[1], 1'b1);
and (delayctrlout[2], delayctrl_out[2], 1'b1);
and (delayctrlout[3], delayctrl_out[3], 1'b1);
and (delayctrlout[4], delayctrl_out[4], 1'b1);
and (delayctrlout[5], delayctrl_out[5], 1'b1);
and (offsetdelayctrlout[5], offsetdelayctrl_out[5], 1'b1);
and (offsetdelayctrlout[0], offsetdelayctrl_out[0], 1'b1);
and (offsetdelayctrlout[1], offsetdelayctrl_out[1], 1'b1);
and (offsetdelayctrlout[2], offsetdelayctrl_out[2], 1'b1);
and (offsetdelayctrlout[3], offsetdelayctrl_out[3], 1'b1);
and (offsetdelayctrlout[4], offsetdelayctrl_out[4], 1'b1);
and (offsetdelayctrlout[5], offsetdelayctrl_out[5], 1'b1);
and (dqsupdate, dqsupdate_out, 1'b1);
and (upndnout, upndn_out, 1'b1);


// INITIAL BLOCK - info messsage and legaity checks
initial
begin
    input_period = str2int(input_frequency);
    $display("Note: DLL instance %m has input frequency %0d ps", input_period);
    $display("      sim_valid_lock %0d", sim_valid_lock);
    $display("      sim_valid_lockcount %0d", sim_valid_lockcount);
    $display("      sim_low_buffer_intrinsic_delay %0d", sim_buffer_intrinsic_delay);
    $display("      sim_high_buffer_intrinsic_delay %0d", sim_buffer_intrinsic_delay);
    $display("      delay_buffer_mode %0s", delay_buffer_mode);
    $display("      sim_buffer_intrinsic_delay %0d", sim_buffer_intrinsic_delay);
    $display("      sim_buffer_delay_increment %0d", sim_buffer_delay_increment);
    $display("      delay_chain_length %0d", delay_chain_length);

    clk_in_last_value = 0;
    clk_in_last_rising_edge = 0;
    clk_in_last_falling_edge = 0;
    got_first_rising_edge = 0;
    got_first_falling_edge = 0;
 
    per_violation = 1'b0;
    duty_violation = 1'b0;
    sent_per_violation = 1'b0;
    sent_duty_violation = 1'b0;
    duty_cycle = input_period/2;
    clk_per_tolerance = 2;
    clk_in_period = 0;
    clk_in_duty_cycle = 0;

    dll_to_lock = 0;
    half_cycles_to_lock = 0;

    // Resolve string parameters
    para_delay_buffer_mode = delay_buffer_mode == "auto" ? 2'b00 : 
	                         delay_buffer_mode == "low" ? 2'b01 : 2'b10;
    para_delayctrlout_mode = delayctrlout_mode == "test" ? 2'b01 : 
	                         delayctrlout_mode == "normal" ? 2'b10 : 
                     		 delayctrlout_mode == "static" ? 2'b11 : 2'b00;
	para_static_delay_ctrl = static_delay_ctrl;
    para_jitter_reduction = jitter_reduction == "true" ? 1'b1 : 1'b0;
    para_use_upndnin = use_upndnin == "true" ? 1'b1 : 1'b0;
    para_use_upndninclkena = use_upndninclkena == "true" ? 1'b1 : 1'b0;

    $display("      delayctrlout_mode %0s", delayctrlout_mode);
    $display("      static_delay_ctrl %0d", para_static_delay_ctrl);
    $display("      use_jitter_reduction %0s", jitter_reduction);
    $display("      use_upndnin %0s", use_upndnin);
    $display("      use_upndninclkena %0s", use_upndninclkena);
end

// CLOCK PERIOD and DUTY CYCLE VIOLATION CHECKS and DLL_TO_LOCK
// exported signals to outside of this block:
//     - dll_to_lock
always @(clk_in)
begin
    if (clk_in == 1'b1 && clk_in != clk_in_last_value) // rising edge
    begin
        if (got_first_rising_edge == 1'b0)
        begin
            got_first_rising_edge <= 1;
            half_cycles_to_lock = half_cycles_to_lock + 1;
            if (half_cycles_to_lock >= sim_valid_lock)
            begin
                dll_to_lock <= 1;
                $display($time, "  Note : DLL instance %m to lock to incoming clock per sim_valid_lock half clock cycles.");
            end
        end
        else   // subsequent rising edge 
	    begin
            // check for clk_period violation and duty cycle violation
            clk_in_period = $time - clk_in_last_rising_edge; 
            clk_in_duty_cycle = $time - clk_in_last_falling_edge;
            if ( (clk_in_period < (input_period - clk_per_tolerance)) ||
                 (clk_in_period > (input_period + clk_per_tolerance)) )
            begin
                per_violation = 1'b1;
                if (sent_per_violation != 1'b1)
                begin
                    $display($time, "  Warning : Input frequency violation on DLL instance %m. Specified input period is %0d ps but actual is %0d ps", 
				                input_period, clk_in_period);
                    sent_per_violation = 1'b1;
                end
            end
            else if ( (clk_in_duty_cycle < (duty_cycle - clk_per_tolerance/2 - 1)) || 
			          (clk_in_duty_cycle > (duty_cycle + clk_per_tolerance/2 + 1)) )
            begin
                duty_violation = 1'b1;
                if (sent_duty_violation != 1'b1)
                begin
                    $display($time, "  Warning : Duty Cycle violation DLL instance %m. Specified duty cycle is %0d ps but actual is %0d ps",
				                   duty_cycle, clk_in_duty_cycle);
                    sent_duty_violation = 1'b1;
                end
            end
            else
            begin
                if (per_violation === 1'b1)
                begin
                    $display($time, "  Note : Input frequency on DLL instance %m now matches with specified clock frequency.");
                    sent_per_violation = 1'b0;
                end
                per_violation = 1'b0;
                duty_violation = 1'b0;
	        end

            if ((duty_violation == 1'b0) && (per_violation == 1'b0) && (dll_to_lock == 1'b0))
            begin
                // increment lock counter
                half_cycles_to_lock = half_cycles_to_lock + 1;
                if (half_cycles_to_lock >= sim_valid_lock)
                begin
                    dll_to_lock <= 1;
                    $display($time, "  Note : DLL instance %m to lock to incoming clock per sim_valid_lock half clock cycles.");
                end
            end    
        end

        clk_in_last_rising_edge = $time;
    end
    else if (clk_in == 1'b0 && clk_in != clk_in_last_value) // falling edge
    begin
        got_first_falling_edge = 1;
        if (got_first_rising_edge == 1'b1)
        begin
            // check for duty cycle violation
			clk_in_duty_cycle = $time - clk_in_last_rising_edge;
            if ( (clk_in_duty_cycle < (duty_cycle - clk_per_tolerance/2 - 1)) || 
			     (clk_in_duty_cycle > (duty_cycle + clk_per_tolerance/2 + 1)) )
            begin
                duty_violation = 1'b1;
                if (sent_duty_violation != 1'b1)
                begin
                    $display($time, "  Warning : Duty Cycle violation DLL instance %m. Specified duty cycle is %0d ps but actual is %0d ps",
				                   duty_cycle, clk_in_duty_cycle);
                    sent_duty_violation = 1'b1;
                end
            end
            else
                duty_violation = 1'b0;

            if (dll_to_lock == 1'b0 && duty_violation == 1'b0)
            begin
                // increment lock counter
                half_cycles_to_lock = half_cycles_to_lock + 1;
            end
        end
        else
        begin
            // first clk edge is falling edge, do nothing
        end
        clk_in_last_falling_edge = $time;
    end
    else if (got_first_rising_edge == 1'b1 || got_first_falling_edge == 1'b1)     
    begin
        // 1 or 0 to X transitions - illegal
        // reset lock and unlock counters
            half_cycles_to_lock = 0;
        got_first_rising_edge = 0;
        got_first_falling_edge = 0;

        if (dll_to_lock)
        begin
            dll_to_lock <= 0;
            $display($time, "  Warning : clock switches from 0/1 to X. DLL instance %m will lose lock.");
        end
        else
        begin
            $display($time, "  Warning : clock switches from 0/1 to X on DLL instance %m");
        end
    end

    clk_in_last_value <= clk_in;
end

// CONNCECTING the DLL outputs ------------------------------------------------
assign delayctrl_out  = dr_delayctrl_out;
assign offsetdelayctrl_out = dr_offsetctrl_out;
assign offsetdelayctrlclkout = dr_clk8_in;
assign dqsupdate_out  = cg_clk8a_out;
assign upndn_out      = pc_upndn_out;

// two reg on the de-assertion of dll -----------------------------------------
assign aload_in = aload_in_buf | aload_reg2;

initial begin
    aload_reg1 = 1'b1;
    aload_reg2 = 1'b1;
end
always @(negedge clk_in)
begin
    aload_reg1 <= aload_in_buf;
    aload_reg2 <= aload_reg1;
end

// Delay and offset ctrl out resolver -----------------------------------------

    // inputs
    assign dr_clk8_in = ~cg_clk8b_out;       // inverted
    assign dr_dllcount_in = dc_dllcount_out_gray; // gray-coded for all outputs
    assign dr_aload_in = aload_in;

    // outputs
    //                                                                          ,addnsub,
    assign dr_delayctrl_out = (delayctrlout_mode == "test") ? {cg_clk1_out,aload,1'bx,dr_reg_dllcount[2:0]}
							  : dr_reg_dllcount;  // both static and normal

	assign dr_offsetctrl_out = dr_delayctrl_int;  // non-registered of delayout_out

    // model

	// assumed para_static_delay_ctrl is gray-coded
	assign dr_delayctrl_int = (delayctrlout_mode == "static") ? para_static_delay_ctrl : dr_dllcount_in;
         
	// por
    initial
    begin
        dr_reg_dllcount = 6'b000000;
    end

    always @(posedge dr_clk8_in or posedge dr_aload_in )
    begin
        if (dr_aload_in === 1'b1)
            dr_reg_dllcount <= 6'b000000;
        else    
            dr_reg_dllcount <= dr_delayctrl_int;
    end


// Delay Setting Control Counter ----------------------------------------------
            
    //inputs
    assign dc_dlltolock_in = dll_to_lock;
    assign dc_aload_in = aload_in;
    assign dc_clk1_in = cg_clk1_out;
    assign dc_clk8_in = ~cg_clk8b_out;      // inverted
    assign dc_upndnclkena_in = (para_use_upndninclkena === 1'b1) ? upndninclkena : 
                               (para_jitter_reduction === 1'b1) ? jc_upndnclkena_out :
                               (dual_phase_comparators == "true") ? ~pc_lock : 1'b1;  // new in stratixiv
    assign dc_upndn_in = (para_use_upndnin === 1'b1) ? upndnin :
	                     (para_jitter_reduction === 1'b1) ? jc_upndn_out : pc_upndn_out;

    // outputs 
    assign dc_dllcount_out_gray = dc_reg_dllcount ^ (dc_reg_dllcount >> 1);
    assign dc_dllcount_out = dc_reg_dllcount;

    // parameters used
    // sim_valid_lockcount - ideal dll count value
    // delay_buffer_mode - 

    // Model - registers to 0 in hardware by POR 
    initial
    begin		
        // low=32=6'b100000 others=16
        dc_reg_dllcount = (delay_buffer_mode == "low") ? 6'b000000 : 6'b000000;
		dc_reg_dlltolock_pulse = 1'b0;
    end

	// dll counter logic - binary
    always @(posedge dc_clk8_in or posedge dc_aload_in or posedge dc_dlltolock_in)
    begin
        if (dc_aload_in === 1'b1) 
            dc_reg_dllcount <= delay_buffer_mode == "low" ? 6'b100000 : 6'b010000;
        else if (dc_dlltolock_in === 1'b1 && dc_upndnclkena_in === 1'b1 && 
                 para_use_upndnin === 1'b0 && dc_reg_dlltolock_pulse != 1'b1)
        begin
            dc_reg_dllcount <= sim_valid_lockcount;
            dc_reg_dlltolock_pulse <= 1'b1;
        end
        else if (dc_upndnclkena_in === 1'b1) // posedge clk
        begin
            if (dc_upndn_in === 1'b1)
            begin
                if ((para_delay_buffer_mode == 2'b01 && dc_reg_dllcount < 6'b111111) ||
                    (para_delay_buffer_mode != 2'b01 && dc_reg_dllcount < 6'b011111))
                    dc_reg_dllcount <= dc_reg_dllcount + 1'b1;
            end
            else if (dc_upndn_in === 1'b0)
            begin
                if (dc_reg_dllcount > 6'b000000)
                    dc_reg_dllcount <= dc_reg_dllcount - 1'b1;
            end
        end
    end
             
// Jitter reduction counter ---------------------------------------------------

    // inputs
    assign jc_clk8_in = ~cg_clk8b_out;         // inverted
    assign jc_upndn_in = pc_upndn_out;
    assign jc_aload_in = aload_in;
    
    // new in stratixiv
    assign jc_clkena_in = (dual_phase_comparators == "false") ? 1'b1 : ~pc_lock;

    // outputs
    assign jc_upndn_out = jc_reg_upndn;
    assign jc_upndnclkena_out = jc_reg_upndnclkena;

    // Model
    initial
    begin
        jc_count = 8;
        jc_reg_upndnclkena = 1'b0;
        jc_reg_upndn = 1'b0;
    end

    always @(posedge jc_clk8_in or posedge jc_aload_in)
    begin
        if (jc_aload_in === 1'b1)
            jc_count <= 8;
        else if (jc_clkena_in === 1'b1)
        begin 
            if (jc_count == 12)
            begin
                jc_reg_upndn <= 1'b1;
                jc_reg_upndnclkena <= 1'b1;
                jc_count <= 8;
            end
            else if (jc_count == 4)
            begin
                jc_reg_upndn <= 1'b0;
                jc_reg_upndnclkena <= 1'b1;
                jc_count <= 8;
            end
            else  // increment/decrement counter
            begin
                jc_reg_upndnclkena <= 1'b0;

                if (jc_upndn_in === 1'b1)
                    jc_count <= jc_count + 1;
                else if (jc_upndn_in === 1'b0)
                    jc_count <= jc_count - 1;
            end
        end
        else
            jc_reg_upndnclkena <= 1'b0;
    end
           
// Phase comparator -----------------------------------------------------------
              
    // inputs
    assign pc_clk1_in = cg_clk1_out;
    assign pc_clk8_in = cg_clk8b_out;        // positive edge
    assign pc_dllcount_in = dc_dllcount_out; // for phase loop calculation: binary
    assign pc_aload_in = aload_in;
           
    // outputs
    assign pc_upndn_out = pc_reg_upndn;
    assign pc_lock = pc_lock_reg;
           
    // parameter used
    // sim_loop_intrinsic_delay, sim_buffer_delay_increment
           
    // Model
    initial
    begin
        pc_reg_upndn = 1'b1;
        pc_delay = 0;
        pc_lock_reg = 1'b0;
        pc_comp_range = (3*delay_chain_length*sim_buffer_delay_increment)/2;
    end
              
    always @(posedge pc_clk8_in or posedge pc_aload_in)
    begin
        if (pc_aload_in === 1'b1)
            pc_reg_upndn <= 1'b1;
        else
        begin
            pc_delay = delay_chain_length *(sim_buffer_intrinsic_delay + sim_buffer_delay_increment * pc_dllcount_in);
            
            if (dual_phase_comparators == "false")
            begin
                pc_lock_reg <= 1'b0;
                if (pc_delay > input_period)
                    pc_reg_upndn <= 1'b0;
                else
                    pc_reg_upndn <= 1'b1;
            end 
            else
            begin
                if (pc_delay < (input_period - pc_comp_range/2))
                begin
                    pc_reg_upndn <= 1'b1;
                    pc_lock_reg <= 1'b0;
                end
                else if ( pc_delay <= (input_period + pc_comp_range/2) )
                begin
                    pc_lock_reg <= 1'b1;
                    pc_reg_upndn <= 1'b0;
                end
                else
                begin
                    pc_lock_reg <= 1'b0;
                    pc_reg_upndn <= 1'b0;                
                end
            end
        end     
    end
                
// Clock Generator -----------------------------------------------------------
      
	// inputs
    assign cg_clk_in = clk_in;
    assign cg_aload_in = aload_in;
       	
	// outputs
    assign cg_clk8a_out = cg_rega_3;
    assign cg_clk8b_out = cg_regb_3;        
    assign cg_clk1_out = (cg_aload_in === 1'b1) ? 1'b0 : cg_clk_in;
     
	// Model
          
	// por
    initial
    begin
        cg_reg_1 = 1'b0;
          
        cg_rega_2 = 1'b0;
        cg_rega_3 = 1'b0;
        
        cg_regb_2 = 1'b1;
        cg_regb_3 = 1'b0;
    end

     
    always @(posedge cg_clk1_out or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
            cg_reg_1 <= 1'b0;
        else
            cg_reg_1 <= ~cg_reg_1;  
    end  
             
    always @(posedge cg_reg_1 or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
        begin
            cg_rega_2 <= 1'b0;
            cg_regb_2 <= 1'b1;
        end
        else
        begin
            cg_rega_2 <= ~cg_rega_2;
            cg_regb_2 <= ~cg_regb_2;
        end
    end  
            
    always @(posedge cg_rega_2 or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
            cg_rega_3 <= 1'b0;
        else
            cg_rega_3 <= ~cg_rega_3;  
    end  
            
    always @(posedge cg_regb_2 or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
            cg_regb_3 <= 1'b0;
        else if ($time != 0)
            cg_regb_3 <= ~cg_regb_3;  
    end  
               
endmodule    // stratixiv_dll

//-----------------------------------------------------------------------------
//
// Module Name : stratixiv_offset_ctrl
//
// Description : STRATIXIV Delay Locked Loop Offset Control 
//               Verilog simulation model 
//
//-----------------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixiv_dll_offset_ctrl (
	    clk, 
	    aload, 
	    offsetdelayctrlin, 
	    offset, 
	    addnsub,
	    devclrn, 
	    devpor,
	    offsettestout, 
	    offsetctrlout
);
parameter use_offset         = "false"; 
parameter static_offset      = "0";
parameter delay_buffer_mode  = "low";   // consistent with dqs

parameter lpm_type           = "stratixiv_dll_offset_ctrl";

// INPUT PORTS
input        clk;
input        aload;
input [5:0]  offsetdelayctrlin;
input [5:0]  offset;
input        addnsub;
input        devclrn;
input        devpor;

// OUTPUT PORTS
output [5:0] offsetctrlout;
output [5:0] offsettestout;

tri1 devclrn;
tri1 devpor;

// TMP OUTPUTS
wire [5:0] offsetctrl_out;

// FUNCTIONS

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
endfunction  // str2int

// Const VARIABLES to represent string parameters
reg [1:0] para_delay_buffer_mode;
reg [1:0] para_use_offset;
integer   para_static_offset;

// INTERNAL NETS AND VARIABLES

// for functionality - by modules
// two reg on the de-assertion of dll

reg  aload_reg1;
reg  aload_reg2;

// delay and offset control out resolver
wire [5:0] dr_offsettest_out;
wire [5:0] dr_offsetctrl_out;
wire [5:0] dr_offsetctrl_out_gray;
wire       dr_clk8_in;
wire       dr_aload_in;
wire       dr_addnsub_in;
wire [5:0] dr_offset_in_gray;
wire [5:0] dr_delayctrl_in_gray;
wire [5:0] para_static_offset_gray;

//decoder
wire [5:0] dr_delayctrl_in_bin;
wire [5:0] dr_offset_in_bin;
wire [5:0] dr_offset_in_bin_pos;
wire [5:0] para_static_offset_bin;
wire [5:0] para_static_offset_bin_pos;

reg  [5:0] dr_reg_offset;

// Timing hooks

// BUFFER INPUTS
wire clk_in;
wire aload_in;
wire offset_in5;
wire offset_in4;
wire offset_in3;
wire offset_in2;
wire offset_in1;
wire offset_in0;
wire addnsub_in;
wire [5:0] offsetdelayctrlin_in;
wire [5:0] offset_in;

assign clk_in =  clk;
assign aload_in =  (aload === 1'b1) ? 1'b1 : 1'b0;
assign offset_in5 =  (offset[5] === 1'b1) ? 1'b1 : 1'b0;
assign offset_in4 =  (offset[4] === 1'b1) ? 1'b1 : 1'b0;
assign offset_in3 =  (offset[3] === 1'b1) ? 1'b1 : 1'b0;
assign offset_in2 =  (offset[2] === 1'b1) ? 1'b1 : 1'b0;
assign offset_in1 =  (offset[1] === 1'b1) ? 1'b1 : 1'b0;
assign offset_in0 =  (offset[0] === 1'b1) ? 1'b1 : 1'b0;
assign addnsub_in =  (addnsub === 1'b1) ? 1'b1 : 1'b0;

assign offsetdelayctrlin_in[5] = (offsetdelayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
assign offsetdelayctrlin_in[4] = (offsetdelayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
assign offsetdelayctrlin_in[3] = (offsetdelayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
assign offsetdelayctrlin_in[2] = (offsetdelayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
assign offsetdelayctrlin_in[1] = (offsetdelayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
assign offsetdelayctrlin_in[0] = (offsetdelayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;

assign offset_in = {offset_in5, offset_in4, 
                    offset_in3, offset_in2, 
                    offset_in1, offset_in0};

// TCO DELAYS, IO PATH and SETUP-HOLD CHECKS
// These timing paths existed from STRATIXIV, currently not modeled in stratixiv
specify
	(posedge clk => (offsetctrlout[0] +: offsetctrl_out[0])) = (0, 0);
	(posedge clk => (offsetctrlout[1] +: offsetctrl_out[1])) = (0, 0);
	(posedge clk => (offsetctrlout[2] +: offsetctrl_out[2])) = (0, 0);
	(posedge clk => (offsetctrlout[3] +: offsetctrl_out[3])) = (0, 0);
	(posedge clk => (offsetctrlout[4] +: offsetctrl_out[4])) = (0, 0);
	(posedge clk => (offsetctrlout[5] +: offsetctrl_out[5])) = (0, 0);

    (offset => offsetctrlout) = (0, 0);

	$setuphold(posedge clk, offset[0], 0, 0);
	$setuphold(posedge clk, offset[1], 0, 0);
	$setuphold(posedge clk, offset[2], 0, 0);
	$setuphold(posedge clk, offset[3], 0, 0);
	$setuphold(posedge clk, offset[4], 0, 0);
	$setuphold(posedge clk, offset[5], 0, 0);
	$setuphold(posedge clk, addnsub, 0, 0);
endspecify

// DRIVERs FOR outputs
and (offsetctrlout[0], offsetctrl_out[0], 1'b1);
and (offsetctrlout[1], offsetctrl_out[1], 1'b1);
and (offsetctrlout[2], offsetctrl_out[2], 1'b1);
and (offsetctrlout[3], offsetctrl_out[3], 1'b1);
and (offsetctrlout[4], offsetctrl_out[4], 1'b1);
and (offsetctrlout[5], offsetctrl_out[5], 1'b1);

// INITIAL BLOCK - info messsage and legaity checks
initial
begin
    // Resolve string parameters
    para_delay_buffer_mode = delay_buffer_mode == "low" ? 2'b01 : 2'b00;
    para_use_offset = use_offset == "true" ? 2'b01 : 2'b00;
    para_static_offset = str2int(static_offset);

    $display("Note: DLL_offset_ctrl instance %m has delay_buffer_mode %0s", delay_buffer_mode);
    $display("      use_offset %0s", use_offset);
    $display("      static_offset %0d", para_static_offset);
end

// CONNCECTING primary outputs ------------------------------------------------
assign offsetctrl_out = dr_offsetctrl_out_gray;
assign offsettestout = dr_offsettest_out;

// ----------------------------------------------------------------------------
// offset ctrl out resolver:
//      adding offset_in into offsetdelayin according to offsetctrlout_mode
// ----------------------------------------------------------------------------

// two reg on the de-assertion of dll -----------------------------------------
// it is the clk feeding into DLL, not /8 clock.
initial begin
    aload_reg1 = 1'b1;
    aload_reg2 = 1'b1;
end
always @(negedge clk_in)
begin
    aload_reg1 <= aload_in;
    aload_reg2 <= aload_reg1;
end

    // inputs
    assign dr_clk8_in = clk_in;
    assign dr_aload_in = aload_in;  // aload_in | aload_reg2;
    assign dr_addnsub_in = addnsub_in;
    assign dr_delayctrl_in_gray = offsetdelayctrlin_in;   
    
    // ------------------------------------------------------------------------
    // substraction flow:
    //       - decode
    //       - ADD or (2's complement then sub - better for overflow check)
    //Addtion flow:
    //       - decode
    //       - add
    //------------------------------------------------------------------------     
    assign dr_offset_in_gray = offset_in;
    assign para_static_offset_gray = para_static_offset[5:0];
    // for counter overflow check - getting the binary abs() of the binary para_static
    assign para_static_offset_bin_pos = (para_static_offset > 0) ? para_static_offset_bin :
                                        (6'b111111 - para_static_offset_bin + 6'b000001);
    assign dr_offset_in_bin_pos       = ((use_offset == "true") && (dr_addnsub_in === 1'b0)) ?
                                        (6'b111111 - dr_offset_in_bin + 6'b000001) : dr_offset_in_bin;

   // outputs
   assign dr_offsetctrl_out = dr_reg_offset;
   assign dr_offsetctrl_out_gray = dr_reg_offset ^ (dr_reg_offset >> 1);
   assign dr_offsettest_out = (use_offset == "false") ? para_static_offset[5:0] : offset_in;

    // model
    
    // gray decoder
    stratixiv_ddr_gray_decoder mdr_delayctrl_in_dec(dr_delayctrl_in_gray, dr_delayctrl_in_bin);
    stratixiv_ddr_gray_decoder mdr_offset_in_dec(dr_offset_in_gray, dr_offset_in_bin);
    stratixiv_ddr_gray_decoder mpara_static_offset_dec(para_static_offset_gray, para_static_offset_bin);
    
     
   // por
    initial
    begin
        dr_reg_offset = 6'b000000;
    end

    // based on dr_delayctrl_in and dr_offset_in_bin (for dynamic) and para_static_offset_bin
    always @(posedge dr_clk8_in or posedge dr_aload_in)
    begin
        if (dr_aload_in === 1'b1)
        begin
            dr_reg_offset <= 6'b000000;
        end
        else if (use_offset == "true")      // addnsub
        begin
            if (dr_addnsub_in === 1'b1)
                if (dr_delayctrl_in_bin < 6'b111111 - dr_offset_in_bin)
                    dr_reg_offset <= dr_delayctrl_in_bin + dr_offset_in_bin;
                else 
                    dr_reg_offset <= 6'b111111;
            else if (dr_addnsub_in === 1'b0)
                if (dr_delayctrl_in_bin > dr_offset_in_bin_pos)
                    dr_reg_offset <= dr_delayctrl_in_bin + dr_offset_in_bin;  // same as - _pos
                else
                    dr_reg_offset <= 6'b000000;
        end
        else                               // static
        begin
            if (para_static_offset >= 0)
                if (para_static_offset_bin < 64 && para_static_offset_bin < 6'b111111 - dr_delayctrl_in_bin)
                    dr_reg_offset <= dr_delayctrl_in_bin + para_static_offset_bin;
                else
                    dr_reg_offset <= 6'b111111;
            else                                       // donot use a_vec - b_vec >=0 as it is always true
                if (para_static_offset_bin_pos < 63 && dr_delayctrl_in_bin > para_static_offset_bin_pos)
                    dr_reg_offset <= dr_delayctrl_in_bin + para_static_offset_bin;  // same as - *_pos
                else
                    dr_reg_offset <= 6'b000000;
        end
    end

endmodule    // stratixiv_offset_ctrl

 //-----------------------------------------------------------------------------
 //
 // Module Name : stratixiv_dqs_delay_chain
 //
 // Description : STRATIXIV DQS Delay Chain (within DQS I/O) 
 //               Verilog simulation model 
 //
 //-----------------------------------------------------------------------------
 `timescale 1 ps/1 ps
   
 module stratixiv_dqs_delay_chain (
 	    dqsin, 
 	    delayctrlin, 
 	    offsetctrlin, 
 	    dqsupdateen, 
 	    phasectrlin,
 	    devclrn, 
 	    devpor,
 	    dffin, 
 	    dqsbusout
 );
 parameter dqs_input_frequency     = "unused" ;    // not used
 parameter use_phasectrlin         = "false";        // rev 1.21
 parameter phase_setting           = 0;              // <0 - 4>
 parameter delay_buffer_mode       = "low";
 parameter dqs_phase_shift         = 0;              // <0..36000> for TAN only
 parameter dqs_offsetctrl_enable   = "false";
 parameter dqs_ctrl_latches_enable = "false";
 // test parameters added in WYS 1.33
 parameter test_enable             = "false";
 parameter test_select             = 0;
 // Simulation parameters
 parameter sim_low_buffer_intrinsic_delay = 350;
 parameter sim_high_buffer_intrinsic_delay = 175;
 parameter sim_buffer_delay_increment      = 10;
 parameter lpm_type           = "stratixiv_dqs_delay_chain";
 
 // INPUT PORTS
 input        dqsin;
 input [5:0]  delayctrlin;
 input [5:0]  offsetctrlin;
 input        dqsupdateen;
 input [2:0]  phasectrlin;
 input        devclrn, devpor;
 
 // OUTPUT PORTS
 output       dqsbusout;
 output       dffin;       // buried
 
 
 // LOCAL_PARAMETERS_BEGIN
 
 parameter sim_intrinsic_delay = (delay_buffer_mode == "low") ? sim_low_buffer_intrinsic_delay :
                                  sim_high_buffer_intrinsic_delay;
 
 // LOCAL_PARAMETERS_END
 
 tri1 devclrn;
 tri1 devpor;
                                 
 // decoded counter
 wire [5:0]  delayctrl_bin;
 wire [5:0]  offsetctrl_bin;
 
 // offsetctrl after "dqs_offsetctrl_enable" mux
 wire [5:0]  offsetctrl_mux;
 
 // reged outputs of delay count
 reg [5:0]  delayctrl_reg;
 reg [5:0]  offsetctrl_reg;
 
 // delay count after latch enable mux
 wire [5:0]  delayctrl_reg_mux;
 wire [5:0]  offsetctrl_reg_mux;
 
 // single cell delay
 integer     tmp_delayctrl;
 integer     tmp_offsetctrl;
 integer     acell_delay;
 integer     aoffsetcell_delay;
 integer     delay_chain_len;
 integer     dqs_delay;
  
 reg tmp_dqsbusout;
 
 // Buffer Layer
 wire        dqsin_in;
 wire [5:0]  delayctrlin_in;
 wire [5:0]  offsetctrlin_in;
 wire        dqsupdateen_in;
 wire [2:0]  phasectrlin_in;
 
 wire [12:0] test_bus;
 wire        test_lpbk;
 wire        tmp_dqsin;  // after and with test_loopback
 
 assign dqsin_in = dqsin;
 assign delayctrlin_in[5] = (delayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[4] = (delayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[3] = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[2] = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[1] = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[0] = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
 assign offsetctrlin_in[5] = (offsetctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
 assign offsetctrlin_in[4] = (offsetctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
 assign offsetctrlin_in[3] = (offsetctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
 assign offsetctrlin_in[2] = (offsetctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
 assign offsetctrlin_in[1] = (offsetctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
 assign offsetctrlin_in[0] = (offsetctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
 assign dqsupdateen_in = (dqsupdateen === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[2] = (phasectrlin[2] === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[1] = (phasectrlin[1] === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[0] = (phasectrlin[0] === 1'b1) ? 1'b1 : 1'b0;
 
 specify
     (dqsin => dqsbusout) = (0,0);
 
     $setuphold(posedge dqsupdateen, delayctrlin[0], 0, 0);
 	$setuphold(posedge dqsupdateen, delayctrlin[1], 0, 0);
 	$setuphold(posedge dqsupdateen, delayctrlin[2], 0, 0);
 	$setuphold(posedge dqsupdateen, delayctrlin[3], 0, 0);
 	$setuphold(posedge dqsupdateen, delayctrlin[4], 0, 0);
 	$setuphold(posedge dqsupdateen, delayctrlin[5], 0, 0);
 	
     $setuphold(posedge dqsupdateen, offsetctrlin[0], 0, 0);
 	$setuphold(posedge dqsupdateen, offsetctrlin[1], 0, 0);
 	$setuphold(posedge dqsupdateen, offsetctrlin[2], 0, 0);
 	$setuphold(posedge dqsupdateen, offsetctrlin[3], 0, 0);
 	$setuphold(posedge dqsupdateen, offsetctrlin[4], 0, 0);
 	$setuphold(posedge dqsupdateen, offsetctrlin[5], 0, 0);
 	
 endspecify
 
 // reg
 initial begin
     delayctrl_reg = 6'b111111;
     offsetctrl_reg = 6'b111111;   
 	
     tmp_delayctrl  = 0;   
     tmp_offsetctrl = 0;
     acell_delay    = 0;    
 end
 always @(posedge dqsupdateen_in)
 begin
     delayctrl_reg  <= delayctrlin_in;
     offsetctrl_reg <= offsetctrl_mux;
 end
 
 assign offsetctrl_mux = (dqs_offsetctrl_enable == "true") ? offsetctrlin_in : delayctrlin_in;
 
 // mux after reg
 assign delayctrl_reg_mux  = (dqs_ctrl_latches_enable == "true") ? delayctrl_reg  : delayctrlin_in;
 assign offsetctrl_reg_mux = (dqs_ctrl_latches_enable == "true") ? offsetctrl_reg : offsetctrl_mux;
 
 // decode
 stratixiv_ddr_gray_decoder m_delayctrl_in_dec (delayctrl_reg_mux,  delayctrl_bin);
 stratixiv_ddr_gray_decoder m_offsetctrl_in_dec(offsetctrl_reg_mux, offsetctrl_bin);
 
 always @(delayctrl_bin or offsetctrl_bin or phasectrlin_in)
 begin
     tmp_delayctrl  = (delay_buffer_mode == "high" && delayctrl_bin[5] == 1'b1) ? 31 : delayctrl_bin;
     tmp_offsetctrl = (delay_buffer_mode == "high" && offsetctrl_bin[5] == 1'b1) ? 31 : offsetctrl_bin;
     // cell
     acell_delay = sim_intrinsic_delay + tmp_delayctrl * sim_buffer_delay_increment;
     if (dqs_offsetctrl_enable == "true")
         aoffsetcell_delay = sim_intrinsic_delay + tmp_offsetctrl * sim_buffer_delay_increment;
     else 
         aoffsetcell_delay = acell_delay;
     // no of cells
     if (use_phasectrlin == "false")
         delay_chain_len = phase_setting;
     else if (phasectrlin_in[2] === 1'b1)
         delay_chain_len = 0;
     else
         delay_chain_len = phasectrlin_in + 3'b001;
     // total delay
     if (delay_chain_len == 0)
         dqs_delay = 0;
     else
         dqs_delay = (delay_chain_len - 1)*acell_delay + aoffsetcell_delay;  
 end
 
 // test bus loopback
 assign test_bus  = {~dqsupdateen_in, offsetctrl_reg_mux, delayctrl_reg_mux}; 
 assign test_lpbk = (0 <= test_select && test_select <= 12) ? test_bus[test_select] : 1'bz;
 assign tmp_dqsin = (test_enable == "true") ? (test_lpbk & dqsin_in) : dqsin_in;
 
 always @(tmp_dqsin)
     tmp_dqsbusout <= #(dqs_delay) tmp_dqsin;
 
 pmos (dqsbusout, tmp_dqsbusout, 1'b0);
 
 endmodule    // stratixiv_dqs_delay_chain
 
 
//-----------------------------------------------------------------------------
//
// Module Name : stratixiv_dqs_enable
//
// Description : STRATIXIV DQS Enable 
//               Verilog simulation model 
//
//-----------------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixiv_dqs_enable (
	    dqsin, 
	    dqsenable,
	    devclrn, 
	    devpor,
	    dqsbusout
);
parameter lpm_type = "stratixiv_dqs_enable";

// INPUT PORTS
input        dqsin;
input        dqsenable;
input        devclrn;
input        devpor;

// OUTPUT PORTS
output       dqsbusout;

tri1 devclrn;
tri1 devpor;

wire         tmp_dqsbusout;
reg          ena_reg;

// BUFFER wrapper
wire    dqsin_in;
wire    dqsenable_in;

assign dqsin_in = dqsin;
assign dqsenable_in =  (dqsenable === 1'b1) ? 1'b1 : 1'b0;

specify
    (dqsin => dqsbusout) = (0,0);
    (dqsenable => dqsbusout) = (0,0); // annotated on the dqsenable port
endspecify

initial ena_reg = 1'b1;
assign tmp_dqsbusout = ena_reg & dqsin_in;

always @(negedge tmp_dqsbusout or posedge dqsenable_in)
begin
    if (dqsenable_in === 1'b1)
        ena_reg <= 1'b1;
    else
        ena_reg <= 1'b0;
end

pmos (dqsbusout, tmp_dqsbusout, 1'b0);

endmodule    // stratixiv_dqs_enable


 //-----------------------------------------------------------------------------
 //
 // Module Name : stratixiv_dqs_enable_ctrl
 //
 // Description : STRATIXIV DQS Enable Control
 //               Verilog simulation model 
 //
 //-----------------------------------------------------------------------------
 `timescale 1 ps/1 ps
   
 module stratixiv_dqs_enable_ctrl (
 	    dqsenablein, 
 	    clk, 
 	    delayctrlin, 
 	    phasectrlin,
 	    enaphasetransferreg,
 	    phaseinvertctrl,
 	    devclrn, devpor,
 	    dffin, 
 	    dffextenddqsenable, 
 	    dqsenableout
 );
 parameter use_phasectrlin   = "true";
 parameter phase_setting     = 0;
 parameter delay_buffer_mode = "high";
 parameter level_dqs_enable  = "false";
 parameter delay_dqs_enable_by_half_cycle = "false";
 parameter add_phase_transfer_reg = "false";
 parameter invert_phase = "false";
 parameter sim_low_buffer_intrinsic_delay = 350;
 parameter sim_high_buffer_intrinsic_delay = 175;
 parameter sim_buffer_delay_increment = 10;
 
 parameter lpm_type = "stratixiv_dqs_enable_ctrl";
 
 // INPUT PORTS
 input	     dqsenablein;
 input        clk;
 input [5:0]  delayctrlin;
 input [3:0]  phasectrlin;
 input        enaphasetransferreg;
 input        phaseinvertctrl;
 input        devclrn;
 input        devpor;
 
 // OUTPUT PORTS
 output       dqsenableout;
 output       dffin;
 output       dffextenddqsenable;  // buried 
 
 // LOCAL_PARAMETERS_BEGIN
 
 parameter sim_intrinsic_delay = (delay_buffer_mode == "low") ? sim_low_buffer_intrinsic_delay :
                                  sim_high_buffer_intrinsic_delay;
 
 // LOCAL_PARAMETERS_END
 
 tri1 devclrn;
 tri1 devpor;
 
 // decoded counter
 wire [5:0]  delayctrl_bin;
 
 // cell delay
 integer     acell_delay;
 integer     delay_chain_len;
 integer     clk_delay;
 
 // int signals
 wire        phasectrl_clkout;
 wire        delayed_clk;
 wire        dqsenablein_reg_q;
 wire        dqsenablein_level_ena;
 
 // transfer delay
 wire        dqsenablein_reg_dly;
 wire        phasetransferdelay_mux_out;
 
 wire        dqsenable_delayed_regp;
 wire        dqsenable_delayed_regn;
 
 wire        tmp_dqsenableout;
 
 // BUFFER wrapper
 wire	    dqsenablein_in;
 wire        clk_in;
 wire [5:0]  delayctrlin_in;
 wire [3:0]  phasectrlin_in;
 wire        enaphasetransferreg_in;
 wire        phaseinvertctrl_in;
 wire        devclrn_in, devpor_in;
 
 assign phaseinvertctrl_in = (phaseinvertctrl === 1'b1) ? 1'b1 : 1'b0;
 assign dqsenablein_in     = (dqsenablein === 1'b1) ? 1'b1 : 1'b0;
 assign clk_in = clk;
 assign enaphasetransferreg_in = (enaphasetransferreg === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[5]      = (delayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[4]      = (delayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[3]      = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[2]      = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[1]      = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[0]      = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[3]      = (phasectrlin[3] === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[2]      = (phasectrlin[2] === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[1]      = (phasectrlin[1] === 1'b1) ? 1'b1 : 1'b0;
 assign phasectrlin_in[0]      = (phasectrlin[0] === 1'b1) ? 1'b1 : 1'b0;
 
 assign  devclrn_in = (devclrn === 1'b0) ? 1'b0 : 1'b1;
 assign  devpor_in  = (devpor  === 1'b0) ? 1'b0 : 1'b1;
 
 // no top-level timing delays 
 // specify
 //    (dqsenablein => dqsenableout) = (0,0);
 // endspecify
 
 // delay chain
 stratixiv_ddr_delay_chain_s m_delay_chain(
                         .clk(clk_in), 
                         .delayctrlin(delayctrlin_in), 
                         .phasectrlin(phasectrlin_in), 
                         .delayed_clkout(phasectrl_clkout)
                         );                      
 defparam m_delay_chain.phase_setting               = phase_setting;
 defparam m_delay_chain.use_phasectrlin             = use_phasectrlin;
 defparam m_delay_chain.sim_buffer_intrinsic_delay  = sim_intrinsic_delay;
 defparam m_delay_chain.sim_buffer_delay_increment  = sim_buffer_delay_increment;
 
 assign delayed_clk = (invert_phase == "true")  ?  (~phasectrl_clkout) :
                      (invert_phase == "false") ?  phasectrl_clkout :
                      (phaseinvertctrl_in === 1'b1) ? (~phasectrl_clkout) : phasectrl_clkout;
                 
 // disable data path
 
 stratixiv_ddr_io_reg  dqsenablein_reg(
                       .d(dqsenablein_in), 
                       .clk(clk_in), 
                       .ena(1'b1), 
                       .clrn(1'b1), 
                       .prn(1'b1),
                       .aload(1'b0), 
                       .asdata(1'b0), 
                       .sclr(1'b0), 
                       .sload(1'b0),
                       .devclrn(devclrn_in),
                       .devpor(devpor_in),
                       .rpt_violation(1'b1), 
                       .q(dqsenablein_reg_q)
                   );
   
 stratixiv_ddr_io_reg  dqsenable_transfer_reg(
                       .d(dqsenablein_reg_q), 
                       .clk(~delayed_clk), 
                       .ena(1'b1), 
                       .clrn(1'b1), 
                       .prn(1'b1),
                       .aload(1'b0), 
                       .asdata(1'b0), 
                       .sclr(1'b0), 
                       .sload(1'b0),
                       .devclrn(devclrn_in),
                       .devpor(devpor_in),
                       .rpt_violation(1'b0), 
                       .q(dqsenablein_reg_dly)
                   );
 
 // add phase transfer mux
 assign phasetransferdelay_mux_out = 
                   (add_phase_transfer_reg == "true")  ? dqsenablein_reg_dly : 
                   (add_phase_transfer_reg == "false") ? dqsenablein_reg_q :
                   (enaphasetransferreg_in === 1'b1)   ? dqsenablein_reg_dly : dqsenablein_reg_q;
 
     
 assign dqsenablein_level_ena = (level_dqs_enable == "true") ? phasetransferdelay_mux_out : dqsenablein_in;
 
 stratixiv_ddr_io_reg  dqsenableout_reg(
                       .d(dqsenablein_level_ena), 
                       .clk(delayed_clk), 
                       .ena(1'b1), 
                       .clrn(1'b1), 
                       .prn(1'b1),
                       .aload(1'b0), 
                       .asdata(1'b0), 
                       .sclr(1'b0), 
                       .sload(1'b0),
                       .devclrn(devclrn_in),
                       .devpor(devpor_in),
                       .rpt_violation(1'b1), 
                       .q(dqsenable_delayed_regp)
                   );
         
 stratixiv_ddr_io_reg  dqsenableout_extend_reg(
                       .d(dqsenable_delayed_regp), 
                       .clk(~delayed_clk), 
                       .ena(1'b1), 
                       .clrn(1'b1), 
                       .prn(1'b1),
                       .aload(1'b0), 
                       .asdata(1'b0), 
                       .sclr(1'b0), 
                       .sload(1'b0),
                       .devclrn(devclrn_in),
                       .devpor(devpor_in),
                       .rpt_violation(1'b0), 
                       .q(dqsenable_delayed_regn)
                   );
     
 assign tmp_dqsenableout = (delay_dqs_enable_by_half_cycle == "false") ? dqsenable_delayed_regp
                           : (dqsenable_delayed_regp & dqsenable_delayed_regn);
                           
 assign dqsenableout = tmp_dqsenableout;
 
 endmodule    // stratixiv_dqs_enable_ctrl
 
 
 //-----------------------------------------------------------------------------
 //
 // Module Name : stratixiv_delay_chain
 //
 // Description : STRATIXIV Delay Chain (dynamic adjustable delay chain) 
 //               Verilog simulation model 
 //
 //-----------------------------------------------------------------------------
 `timescale 1 ps/1 ps
   
 module stratixiv_delay_chain (
 	    datain, 
 	    delayctrlin,
 	    finedelayctrlin,
 	    devclrn, 
 	    devpor,
 	    dataout
 );
 parameter sim_delayctrlin_rising_delay_0  = 0;
 parameter sim_delayctrlin_rising_delay_1  = 50;
 parameter sim_delayctrlin_rising_delay_2  = 100;
 parameter sim_delayctrlin_rising_delay_3  = 150;
 parameter sim_delayctrlin_rising_delay_4  = 200;
 parameter sim_delayctrlin_rising_delay_5  = 250;
 parameter sim_delayctrlin_rising_delay_6  = 300;
 parameter sim_delayctrlin_rising_delay_7  = 350;
 parameter sim_delayctrlin_rising_delay_8  = 400;
 parameter sim_delayctrlin_rising_delay_9  = 450;
 parameter sim_delayctrlin_rising_delay_10  = 500;
 parameter sim_delayctrlin_rising_delay_11  = 550;
 parameter sim_delayctrlin_rising_delay_12  = 600;
 parameter sim_delayctrlin_rising_delay_13  = 650;
 parameter sim_delayctrlin_rising_delay_14  = 700;
 parameter sim_delayctrlin_rising_delay_15  = 750;
 
 parameter sim_delayctrlin_falling_delay_0  = 0;
 parameter sim_delayctrlin_falling_delay_1  = 50;
 parameter sim_delayctrlin_falling_delay_2  = 100;
 parameter sim_delayctrlin_falling_delay_3  = 150;
 parameter sim_delayctrlin_falling_delay_4  = 200;
 parameter sim_delayctrlin_falling_delay_5  = 250;
 parameter sim_delayctrlin_falling_delay_6  = 300;
 parameter sim_delayctrlin_falling_delay_7  = 350;
 parameter sim_delayctrlin_falling_delay_8  = 400;
 parameter sim_delayctrlin_falling_delay_9  = 450;
 parameter sim_delayctrlin_falling_delay_10  = 500;
 parameter sim_delayctrlin_falling_delay_11  = 550;
 parameter sim_delayctrlin_falling_delay_12  = 600;
 parameter sim_delayctrlin_falling_delay_13  = 650;
 parameter sim_delayctrlin_falling_delay_14  = 700;
 parameter sim_delayctrlin_falling_delay_15  = 750;

 //new STRATIXIV - ww30.2008
 parameter sim_finedelayctrlin_falling_delay_0 =  0 ;
 parameter sim_finedelayctrlin_falling_delay_1 =  25 ;
 parameter sim_finedelayctrlin_rising_delay_0  =  0 ;
 parameter sim_finedelayctrlin_rising_delay_1  =  25 ;
 parameter use_finedelayctrlin                 = "false";
 
 parameter lpm_type = "stratixiv_delay_chain";
 
 // parameter removed in rev 1.23
 parameter use_delayctrlin = "true";
 parameter delay_setting   = 0; // <0 - 15>
 
 // INPUT PORTS
 input        datain;
 input  [3:0] delayctrlin;
 input        devclrn;
 input        devpor;
 input        finedelayctrlin;  //new STRATIXIV - ww30.2008
 
 // OUTPUT PORTS
 output       dataout;
 
 tri1 devclrn;
 tri1 devpor;
 
 // delays
 integer      dly_table_rising[0:15];
 integer      dly_table_falling[0:15];
 integer      finedly_table_rising[0:1];
 integer      finedly_table_falling[0:1];
 integer      dly_setting;
 integer      rising_dly, falling_dly;
 reg          tmp_dataout;
 
 //Buffer layers
 wire        datain_in;
 wire [3:0]  delayctrlin_in;
 wire        finedelayctrlin_in;
 assign datain_in = datain;
 
 specify
     (datain => dataout) = (0,0);
 endspecify
  
 // filtering X/U etc.
 assign delayctrlin_in[0] = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[1] = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[2] = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
 assign delayctrlin_in[3] = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
 assign finedelayctrlin_in = (finedelayctrlin === 1'b1) ? 1'b1 : 1'b0;
 
 initial
 begin
     dly_table_rising[0] = sim_delayctrlin_rising_delay_0;
     dly_table_rising[1] = sim_delayctrlin_rising_delay_1;
     dly_table_rising[2] = sim_delayctrlin_rising_delay_2;
     dly_table_rising[3] = sim_delayctrlin_rising_delay_3;
     dly_table_rising[4] = sim_delayctrlin_rising_delay_4;
     dly_table_rising[5] = sim_delayctrlin_rising_delay_5;
     dly_table_rising[6] = sim_delayctrlin_rising_delay_6;
     dly_table_rising[7] = sim_delayctrlin_rising_delay_7;
     dly_table_rising[8] = sim_delayctrlin_rising_delay_8;
     dly_table_rising[9] = sim_delayctrlin_rising_delay_9;
     dly_table_rising[10] = sim_delayctrlin_rising_delay_10;
     dly_table_rising[11] = sim_delayctrlin_rising_delay_11;
     dly_table_rising[12] = sim_delayctrlin_rising_delay_12;
     dly_table_rising[13] = sim_delayctrlin_rising_delay_13;
     dly_table_rising[14] = sim_delayctrlin_rising_delay_14;
     dly_table_rising[15] = sim_delayctrlin_rising_delay_15;
 
     dly_table_falling[0] = sim_delayctrlin_falling_delay_0;
     dly_table_falling[1] = sim_delayctrlin_falling_delay_1;
     dly_table_falling[2] = sim_delayctrlin_falling_delay_2;
     dly_table_falling[3] = sim_delayctrlin_falling_delay_3;
     dly_table_falling[4] = sim_delayctrlin_falling_delay_4;
     dly_table_falling[5] = sim_delayctrlin_falling_delay_5;
     dly_table_falling[6] = sim_delayctrlin_falling_delay_6;
     dly_table_falling[7] = sim_delayctrlin_falling_delay_7;
     dly_table_falling[8] = sim_delayctrlin_falling_delay_8;
     dly_table_falling[9] = sim_delayctrlin_falling_delay_9;
     dly_table_falling[10] = sim_delayctrlin_falling_delay_10;
     dly_table_falling[11] = sim_delayctrlin_falling_delay_11;
     dly_table_falling[12] = sim_delayctrlin_falling_delay_12;
     dly_table_falling[13] = sim_delayctrlin_falling_delay_13;
     dly_table_falling[14] = sim_delayctrlin_falling_delay_14;
     dly_table_falling[15] = sim_delayctrlin_falling_delay_15;
 
     finedly_table_rising[0]  = sim_finedelayctrlin_rising_delay_0;
     finedly_table_rising[1]  = sim_finedelayctrlin_rising_delay_1;
     finedly_table_falling[0] = sim_finedelayctrlin_falling_delay_0;
     finedly_table_falling[1] = sim_finedelayctrlin_falling_delay_1;
 
     dly_setting = 0;
     rising_dly  = 0;
     falling_dly = 0;
     tmp_dataout = 1'bx;
 end
 
 always @(delayctrlin_in or finedelayctrlin_in)
 begin
     if (use_delayctrlin == "false")
         dly_setting = delay_setting;
     else
         dly_setting = delayctrlin_in;
 	
 	if (use_finedelayctrlin == "true")
    begin
 	    rising_dly  = dly_table_rising[dly_setting] + finedly_table_rising[finedelayctrlin_in];
 	    falling_dly = dly_table_falling[dly_setting] + finedly_table_falling[finedelayctrlin_in];
    end
 	else 
    begin
 	    rising_dly  = dly_table_rising[dly_setting];
 	    falling_dly = dly_table_falling[dly_setting];
    end
 end
 	
 always @(datain_in)
 begin
     if (datain_in === 1'b0)
         tmp_dataout <= #(falling_dly) datain_in;
     else
         tmp_dataout <= #(rising_dly) datain_in;
 end
 
 assign dataout = tmp_dataout;
 
 endmodule    // stratixiv_delay_chain
 
 
  //-----------------------------------------------------------------------------
  //
  // Module Name : stratixiv_io_clock_divider
  //
  // Description : STRATIXIV I/O Clock Divider 
  //               Verilog simulation model 
  //
  //-----------------------------------------------------------------------------
  `timescale 1 ps/1 ps
    
  module stratixiv_io_clock_divider (
          clk, 
          phaseselect, 
          delayctrlin, 
          phasectrlin,
          masterin,
  	    phaseinvertctrl,
          devclrn, 
          devpor,
          clkout, 
          slaveout
  );
  parameter use_phasectrlin   = "true";
  parameter phase_setting     = 0;      // <0 - 7>
  parameter delay_buffer_mode = "high";
  parameter use_masterin      = "false"; // new in 1.19
  parameter invert_phase = "false";
  parameter sim_low_buffer_intrinsic_delay  = 350;
  parameter sim_high_buffer_intrinsic_delay = 175;
  parameter sim_buffer_delay_increment      = 10;
  
  parameter lpm_type = "stratixiv_io_clock_divider";
  
  // INPUT PORTS
  input       clk;
  input       phaseselect;
  input [5:0] delayctrlin;
  input [3:0] phasectrlin;
  input       phaseinvertctrl;
  input       masterin;
  input       devclrn;
  input       devpor;
  
  // OUTPUT PORTS
  output       clkout;
  output       slaveout;
  
 // LOCAL_PARAMETERS_BEGIN
  
  parameter sim_intrinsic_delay = (delay_buffer_mode == "low") ? sim_low_buffer_intrinsic_delay :
                                   sim_high_buffer_intrinsic_delay;
  
 // LOCAL_PARAMETERS_END
  
  tri1 devclrn;
  tri1 devpor;
  
  // int signals
  wire        phasectrl_clkout;
  wire        delayed_clk;
  wire        divided_clk_in;
  reg         divided_clk;
  wire        tmp_clkout;
  
  // input buffer layer
  wire       clk_in, phaseselect_in;
  wire [5:0] delayctrlin_in;
  wire [3:0] phasectrlin_in;
  wire       masterin_in;
  wire       phaseinvertctrl_in;
  
  assign clk_in = clk;
  assign phaseselect_in = (phaseselect === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[5] = (delayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[4] = (delayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[3] = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[2] = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[1] = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[0] = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[3] = (phasectrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[2] = (phasectrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[1] = (phasectrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[0] = (phasectrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign masterin_in = masterin;
  assign phaseinvertctrl_in = (phaseinvertctrl === 1'b1) ? 1'b1 : 1'b0;
  
  specify
      (clk => clkout) = (0,0);
  endspecify
  
  // delay chain
  stratixiv_ddr_delay_chain_s m_delay_chain(
                          .clk(clk_in), 
                          .delayctrlin(delayctrlin_in), 
                          .phasectrlin(phasectrlin_in), 
                          .delayed_clkout(phasectrl_clkout)
                          );                      
  defparam m_delay_chain.phase_setting               = phase_setting;
  defparam m_delay_chain.use_phasectrlin             = use_phasectrlin;
  defparam m_delay_chain.sim_buffer_intrinsic_delay  = sim_intrinsic_delay;
  defparam m_delay_chain.sim_buffer_delay_increment  = sim_buffer_delay_increment;
  defparam m_delay_chain.phasectrlin_limit           = 7;
  
  assign delayed_clk = (invert_phase == "true")  ?  (~phasectrl_clkout) :
                       (invert_phase == "false") ?  phasectrl_clkout :
                       (phaseinvertctrl_in === 1'b1) ? (~phasectrl_clkout) : phasectrl_clkout;
  
  initial 
      divided_clk = 1'b0;
  
  assign divided_clk_in = (use_masterin == "true") ? masterin_in : divided_clk;
      
  always @(posedge delayed_clk)
  begin
      if (delayed_clk == 'b1)
          divided_clk <= ~divided_clk_in;
  end
      
  assign tmp_clkout = (phaseselect_in === 1'b1) ? ~divided_clk : divided_clk;
  
  assign clkout = tmp_clkout;
  assign slaveout = divided_clk;
  
  endmodule    // stratixiv_io_clock_divider
  
  
  //-----------------------------------------------------------------------------
  //
  // Module Name : stratixiv_output_phase_alignment
  //
  // Description : output phase alignment 
  //               Verilog simulation model 
  //
  //-----------------------------------------------------------------------------
  `timescale 1 ps/1 ps
    
  module stratixiv_output_phase_alignment (
      datain,
      clk,
      delayctrlin,
      phasectrlin,
      areset,
      sreset,
      clkena,
      enaoutputcycledelay,
      enaphasetransferreg,
  	  phaseinvertctrl,
      delaymode,
      dutycycledelayctrlin,
      devclrn, 
      devpor,
      dffin, 
      dff1t, 
      dffddiodataout,
      dataout
  );
  parameter operation_mode    = "ddio_out";
  parameter use_phasectrlin   = "true";
  parameter phase_setting     = 0;          // <0..10>
  parameter delay_buffer_mode = "high";
  parameter power_up          = "low";
  parameter async_mode        = "none";
  parameter sync_mode         = "none";
  parameter add_output_cycle_delay          = "false";
  parameter use_delayed_clock               = "false";  // new in 1.21
  parameter add_phase_transfer_reg          = "false";  // <false,true,dynamic>
  parameter use_phasectrl_clock             = "true";   // new in 1.21
  parameter use_primary_clock               = "true";   // new in 1.21
  parameter invert_phase                    = "false";  // new in 1.26
  parameter phase_setting_for_delayed_clock = 2;        // new in 1.28 
  parameter bypass_input_register           = "false";  // new in 1.36   
  parameter sim_low_buffer_intrinsic_delay  = 350;
  parameter sim_high_buffer_intrinsic_delay = 175;
  parameter sim_buffer_delay_increment      = 10;
  // new in STRATIXIV: ww30.2008
  parameter duty_cycle_delay_mode = "none";
  parameter sim_dutycycledelayctrlin_falling_delay_0 =  0 ;
  parameter sim_dutycycledelayctrlin_falling_delay_1 =  25 ;
  parameter sim_dutycycledelayctrlin_falling_delay_10 =  250 ;
  parameter sim_dutycycledelayctrlin_falling_delay_11 =  275 ;
  parameter sim_dutycycledelayctrlin_falling_delay_12 =  300 ;
  parameter sim_dutycycledelayctrlin_falling_delay_13 =  325 ;
  parameter sim_dutycycledelayctrlin_falling_delay_14 =  350 ;
  parameter sim_dutycycledelayctrlin_falling_delay_15 =  375 ;
  parameter sim_dutycycledelayctrlin_falling_delay_2 =  50 ;
  parameter sim_dutycycledelayctrlin_falling_delay_3 =  75 ;
  parameter sim_dutycycledelayctrlin_falling_delay_4 =  100 ;
  parameter sim_dutycycledelayctrlin_falling_delay_5 =  125 ;
  parameter sim_dutycycledelayctrlin_falling_delay_6 =  150 ;
  parameter sim_dutycycledelayctrlin_falling_delay_7 =  175 ;
  parameter sim_dutycycledelayctrlin_falling_delay_8 =  200 ;
  parameter sim_dutycycledelayctrlin_falling_delay_9 =  225 ;
  parameter sim_dutycycledelayctrlin_rising_delay_0 =  0 ;
  parameter sim_dutycycledelayctrlin_rising_delay_1 =  25 ;
  parameter sim_dutycycledelayctrlin_rising_delay_10 =  250 ;
  parameter sim_dutycycledelayctrlin_rising_delay_11 =  275 ;
  parameter sim_dutycycledelayctrlin_rising_delay_12 =  300 ;
  parameter sim_dutycycledelayctrlin_rising_delay_13 =  325 ;
  parameter sim_dutycycledelayctrlin_rising_delay_14 =  350 ;
  parameter sim_dutycycledelayctrlin_rising_delay_15 =  375 ;
  parameter sim_dutycycledelayctrlin_rising_delay_2 =  50 ;
  parameter sim_dutycycledelayctrlin_rising_delay_3 =  75 ;
  parameter sim_dutycycledelayctrlin_rising_delay_4 =  100 ;
  parameter sim_dutycycledelayctrlin_rising_delay_5 =  125 ;
  parameter sim_dutycycledelayctrlin_rising_delay_6 =  150 ;
  parameter sim_dutycycledelayctrlin_rising_delay_7 =  175 ;
  parameter sim_dutycycledelayctrlin_rising_delay_8 =  200 ;
  parameter sim_dutycycledelayctrlin_rising_delay_9 =  225 ;
  
  parameter lpm_type = "stratixiv_output_phase_alignment";
  
  // INPUT PORTS
  input [1:0]  datain;
  input        clk;
  input [5:0]  delayctrlin;
  input [3:0]  phasectrlin;
  input        areset;
  input        sreset;
  input        clkena;
  input        enaoutputcycledelay;
  input        enaphasetransferreg;
  input        phaseinvertctrl;
  // new in STRATIXIV: ww30.2008
  input        delaymode;
  input [3:0]  dutycycledelayctrlin;
  
  input        devclrn;
  input        devpor;
  
  // OUTPUT PORTS
  output       dataout;
  output [1:0] dffin;               // buried port
  output [1:0] dff1t;               // buried port
  output       dffddiodataout;      // buried port
  
 // LOCAL_PARAMETERS_BEGIN
  
  parameter sim_intrinsic_delay = (delay_buffer_mode == "low") ? sim_low_buffer_intrinsic_delay 
                                   : sim_high_buffer_intrinsic_delay;
  
 // LOCAL_PARAMETERS_END
  
  tri1 devclrn;
  tri1 devpor;
                                                                
  // int signals on clock paths
  wire        clk_in_delayed;
  wire        clk_in_mux;
  wire        phasectrl_clkout;
  wire        phaseinvertctrl_out;
  
  // IO registers
  // common
  reg         adatasdata_in_r;   //sync reset - common for transfer and output reg
  reg         sclr_in_r;
  reg         sload_in_r;  
  wire        sclr_in;
  wire        sload_in;
  wire        adatasdata_in;
  
  reg         clrn_in_r;         //async reset - common for all registers
  reg         prn_in_r;
  
  wire        datain_q;
  wire        ddio_datain_q;
  
  wire        cycledelay_q;
  wire        ddio_cycledelay_q;
  
  wire        cycledelay_mux_out;
  wire        ddio_cycledelay_mux_out;
  
  wire        bypass_input_reg_mux_out;
  wire        ddio_bypass_input_reg_mux_out;
  
  // transfer delay now by negative clk
  wire        transfer_q;
  wire        ddio_transfer_q;
  
  // Duty Cycle Delay
  wire        dcd_in;
  wire        dcd_out;
  wire        dcd_both;
  reg         dcd_both_gnd;
  reg         dcd_both_vcc;
  wire        dcd_fallnrise;
  reg         dcd_fallnrise_gnd;
  reg         dcd_fallnrise_vcc;
  integer     dcd_table_rising[0:15];
  integer     dcd_table_falling[0:15];
  integer     dcd_dly_setting;
  integer     dcd_rising_dly;
  integer     dcd_falling_dly;
  
  wire        dlyclk_clk;
  wire        dlyclk_d;
  wire        dlyclk_q;
  wire        ddio_dlyclk_d;
  wire        ddio_dlyclk_q;
  
  wire        ddio_out_clk_mux;
  wire        ddio_out_lo_q;
  wire        ddio_out_hi_q;
  
  wire        dlyclk_clkena_in;     // shared    
  wire        dlyclk_extended_q;
  wire        dlyclk_extended_clk;
  
  wire        normal_dataout;
  wire        extended_dataout;
  wire        ddio_dataout;
  wire        tmp_dataout;
  
  // buffer layer
  wire [1:0]  datain_in;
  wire        clk_in;
  wire [5:0]  delayctrlin_in;
  wire [3:0]  phasectrlin_in;
  wire        areset_in;
  wire        sreset_in;
  wire        clkena_in;
  wire        enaoutputcycledelay_in;
  wire        enaphasetransferreg_in;
  wire        devclrn_in, devpor_in;
  wire        phaseinvertctrl_in;
   
  wire        delaymode_in;
  wire [3:0]  dutycycledelayctrlin_in;
  
  assign  devclrn_in = (devclrn === 1'b0) ? 1'b0 : 1'b1;
  assign  devpor_in  = (devpor  === 1'b0) ? 1'b0 : 1'b1;
  
  assign datain_in =  datain;
  assign clk_in =  clk;
  assign delayctrlin_in[5] = (delayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[4] = (delayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[3] = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[2] = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[1] = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[0] = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[3] = (phasectrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[2] = (phasectrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[1] = (phasectrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[0] = (phasectrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign areset_in =  (areset === 1'b1) ? 1'b1 : 1'b0;
  assign sreset_in =  (sreset === 1'b1) ? 1'b1 : 1'b0;
  assign clkena_in =  (clkena === 1'b1) ? 1'b1 : 1'b0;
  assign enaoutputcycledelay_in = (enaoutputcycledelay === 1'b1) ? 1'b1 : 1'b0;
  assign enaphasetransferreg_in = (enaphasetransferreg === 1'b1) ? 1'b1 : 1'b0;
  assign phaseinvertctrl_in = (phaseinvertctrl === 1'b1) ? 1'b1 : 1'b0;
  
  assign delaymode_in = (delaymode === 1'b1) ? 1'b1 : 1'b0;
  assign dutycycledelayctrlin_in[0] = (dutycycledelayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign dutycycledelayctrlin_in[1] = (dutycycledelayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign dutycycledelayctrlin_in[2] = (dutycycledelayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign dutycycledelayctrlin_in[3] = (dutycycledelayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  
  // delay chain for clk_in delay
  stratixiv_ddr_delay_chain_s m_clk_in_delay_chain(
                          .clk(clk_in), 
                          .delayctrlin(delayctrlin_in), 
                          .phasectrlin(phasectrlin_in), 
                          .delayed_clkout(clk_in_delayed)
                          );                      
  defparam m_clk_in_delay_chain.phase_setting               = phase_setting_for_delayed_clock;
  defparam m_clk_in_delay_chain.use_phasectrlin             = "false";
  defparam m_clk_in_delay_chain.sim_buffer_intrinsic_delay  = sim_intrinsic_delay;
  defparam m_clk_in_delay_chain.sim_buffer_delay_increment  = sim_buffer_delay_increment;
  
  // clock source for datain and cycle delay registers
  assign clk_in_mux = (use_delayed_clock == "true") ? clk_in_delayed : clk_in;
  
  // delay chain for phase control
  stratixiv_ddr_delay_chain_s m_delay_chain(
                          .clk(clk_in), 
                          .delayctrlin(delayctrlin_in), 
                          .phasectrlin(phasectrlin_in), 
                          .delayed_clkout(phasectrl_clkout)
                          );                      
  defparam m_delay_chain.phase_setting               = phase_setting;
  defparam m_delay_chain.use_phasectrlin             = use_phasectrlin;
  defparam m_delay_chain.sim_buffer_intrinsic_delay  = sim_intrinsic_delay;
  defparam m_delay_chain.sim_buffer_delay_increment  = sim_buffer_delay_increment;
  defparam m_delay_chain.phasectrlin_limit           = (use_primary_clock == "true") ? 10 : 7;
  
  // primary outputs
  assign normal_dataout   = dlyclk_q;
  assign extended_dataout = dlyclk_q | dlyclk_extended_q;    // oe port is active low
  assign ddio_dataout     = (ddio_out_clk_mux === 1'b1) ? ddio_out_hi_q : ddio_out_lo_q;
  assign tmp_dataout      = (operation_mode == "ddio_out") ? ddio_dataout :
                            (operation_mode == "extended_oe" || operation_mode == "extended_rtena") ? extended_dataout :
                            (operation_mode == "output" || operation_mode == "oe" || operation_mode == "rtena") ? normal_dataout 
                            : 1'bz;
  assign dataout = tmp_dataout;                          
  
  assign #1 ddio_out_clk_mux = dlyclk_clk;  // symbolic T4 to remove glitch on data_h
  assign #2 ddio_out_lo_q = dlyclk_q;      // symbolic 2 T4 to remove glitch on data_l
  assign    ddio_out_hi_q = ddio_dlyclk_q;
  
  
  // resolve reset/areset modes
  initial begin
      adatasdata_in_r = (sync_mode == "preset") ? 1'b1: 1'b0;
      sclr_in_r       = 1'b0;
      sload_in_r      = 1'b0;  
  
      clrn_in_r       = 1'b1;
      prn_in_r        = 1'b1;
  end
  
  always @(areset_in)
  begin
      if (async_mode == "clear")
      begin
          clrn_in_r       = ~areset_in;
      end
      else if (async_mode == "preset")
      begin
          prn_in_r        = ~areset_in;
      end
  end
  
  always @(sreset_in)
  begin    
      if (sync_mode == "clear")
      begin
          sclr_in_r       = sreset_in;
      end
      else if(sync_mode == "preset")
      begin
          sload_in_r      = sreset_in;  
      end
  end
  
  assign sclr_in   = (operation_mode == "rtena" || operation_mode == "extended_rtena") ? 1'b0 : sclr_in_r;
  assign sload_in  = (operation_mode == "rtena" || operation_mode == "extended_rtena") ? 1'b0 : sload_in_r;
  assign adatasdata_in    = adatasdata_in_r;
  assign dlyclk_clkena_in = (operation_mode == "rtena" || operation_mode == "extended_rtena") ? 1'b1 : clkena_in;
  
  // Datain Register
  stratixiv_ddr_io_reg  datain_reg(
                        .d(datain_in[0]), 
                        .clk(clk_in_mux), 
                        .ena(1'b1), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b1), 
                        .q(datain_q)
                    );
           defparam datain_reg.power_up = power_up;
           
  // DDIO Datain Register  
  stratixiv_ddr_io_reg  ddio_datain_reg(
                        .d(datain_in[1]), 
                        .clk(clk_in_mux), 
                        .ena(1'b1), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b1), 
                        .q(ddio_datain_q)
                    );
           defparam ddio_datain_reg.power_up = power_up;
  
  // Cycle Delay Register  
  stratixiv_ddr_io_reg  cycledelay_reg(
                        .d(datain_q), 
                        .clk(clk_in_mux), 
                        .ena(1'b1), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(cycledelay_q)
                    );
           defparam cycledelay_reg.power_up = power_up;
           
  // DDIO Cycle Delay Register  
  stratixiv_ddr_io_reg  ddio_cycledelay_reg(
                        .d(ddio_datain_q), 
                        .clk(clk_in_mux), 
                        .ena(1'b1), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(ddio_cycledelay_q)
                    );
           defparam ddio_cycledelay_reg.power_up = power_up;
  
  // enaoutputcycledelay data path mux
  assign cycledelay_mux_out = (add_output_cycle_delay == "true")  ? cycledelay_q : 
                              (add_output_cycle_delay == "false") ? datain_q :
                              (enaoutputcycledelay_in === 1'b1)   ? cycledelay_q : datain_q;
  
  // input register bypass mux
  assign bypass_input_reg_mux_out = (bypass_input_register == "true") ? datain_in[0] : cycledelay_mux_out;
  
  //assign #300 transfer_q = cycledelay_mux_out;
  // transfer delay is implemented with negative register in rev1.26 
  stratixiv_ddr_io_reg  transferdelay_reg(
                        .d(bypass_input_reg_mux_out), 
                        .clk(~clk_in_mux), 
                        .ena(1'b1), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(sclr_in), 
                        .sload(sload_in),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(transfer_q)
                    );
           defparam transferdelay_reg.power_up = power_up;
  
  // add phase transfer (true/false/dynamic) data path mux
  assign dlyclk_d = (add_phase_transfer_reg == "true")  ? transfer_q : 
                    (add_phase_transfer_reg == "false") ? bypass_input_reg_mux_out :
                    (enaphasetransferreg_in === 1'b1)   ? transfer_q : bypass_input_reg_mux_out;
  
  // clock mux for the output register
  assign phaseinvertctrl_out = (invert_phase == "true") ? (~phasectrl_clkout) :
                               (invert_phase == "false") ? phasectrl_clkout :
                       (phaseinvertctrl_in === 1'b1) ? (~phasectrl_clkout) : phasectrl_clkout;
 
 // Duty Cycle Delay
  assign dcd_in = (use_phasectrl_clock == "true") ? phaseinvertctrl_out : clk_in_mux;
 
  initial
  begin
     dcd_table_rising[0] = sim_dutycycledelayctrlin_rising_delay_0;
     dcd_table_rising[1] = sim_dutycycledelayctrlin_rising_delay_1;
     dcd_table_rising[2] = sim_dutycycledelayctrlin_rising_delay_2;
     dcd_table_rising[3] = sim_dutycycledelayctrlin_rising_delay_3;
     dcd_table_rising[4] = sim_dutycycledelayctrlin_rising_delay_4;
     dcd_table_rising[5] = sim_dutycycledelayctrlin_rising_delay_5;
     dcd_table_rising[6] = sim_dutycycledelayctrlin_rising_delay_6;
     dcd_table_rising[7] = sim_dutycycledelayctrlin_rising_delay_7;
     dcd_table_rising[8] = sim_dutycycledelayctrlin_rising_delay_8;
     dcd_table_rising[9] = sim_dutycycledelayctrlin_rising_delay_9;
     dcd_table_rising[10] = sim_dutycycledelayctrlin_rising_delay_10;
     dcd_table_rising[11] = sim_dutycycledelayctrlin_rising_delay_11;
     dcd_table_rising[12] = sim_dutycycledelayctrlin_rising_delay_12;
     dcd_table_rising[13] = sim_dutycycledelayctrlin_rising_delay_13;
     dcd_table_rising[14] = sim_dutycycledelayctrlin_rising_delay_14;
     dcd_table_rising[15] = sim_dutycycledelayctrlin_rising_delay_15;
 
     dcd_table_falling[0] = sim_dutycycledelayctrlin_falling_delay_0;
     dcd_table_falling[1] = sim_dutycycledelayctrlin_falling_delay_1;
     dcd_table_falling[2] = sim_dutycycledelayctrlin_falling_delay_2;
     dcd_table_falling[3] = sim_dutycycledelayctrlin_falling_delay_3;
     dcd_table_falling[4] = sim_dutycycledelayctrlin_falling_delay_4;
     dcd_table_falling[5] = sim_dutycycledelayctrlin_falling_delay_5;
     dcd_table_falling[6] = sim_dutycycledelayctrlin_falling_delay_6;
     dcd_table_falling[7] = sim_dutycycledelayctrlin_falling_delay_7;
     dcd_table_falling[8] = sim_dutycycledelayctrlin_falling_delay_8;
     dcd_table_falling[9] = sim_dutycycledelayctrlin_falling_delay_9;
     dcd_table_falling[10] = sim_dutycycledelayctrlin_falling_delay_10;
     dcd_table_falling[11] = sim_dutycycledelayctrlin_falling_delay_11;
     dcd_table_falling[12] = sim_dutycycledelayctrlin_falling_delay_12;
     dcd_table_falling[13] = sim_dutycycledelayctrlin_falling_delay_13;
     dcd_table_falling[14] = sim_dutycycledelayctrlin_falling_delay_14;
     dcd_table_falling[15] = sim_dutycycledelayctrlin_falling_delay_15;
 
     dcd_dly_setting = 0;
     dcd_rising_dly  = 0;
     dcd_falling_dly = 0;
  end
 
  always @(dutycycledelayctrlin_in)
  begin
     dcd_dly_setting = dutycycledelayctrlin_in;
 	 dcd_rising_dly  = dcd_table_rising[dcd_dly_setting];
 	 dcd_falling_dly = dcd_table_falling[dcd_dly_setting];
  end
 
  always @(dcd_in)
  begin
     dcd_both_gnd <= dcd_in; 
 
     if (dcd_in === 1'b0)
     begin
         dcd_both_vcc <= #(dcd_falling_dly) dcd_in;
         dcd_fallnrise_gnd <= #(dcd_falling_dly) dcd_in;
         dcd_fallnrise_vcc <= dcd_in;
     end
     else
     begin
         dcd_both_vcc <= #(dcd_rising_dly) dcd_in;
         dcd_fallnrise_gnd <= dcd_in;
         dcd_fallnrise_vcc <= #(dcd_rising_dly) dcd_in;
     end
  end
 
  assign dcd_both = (delaymode_in === 1'b1) ? dcd_both_vcc : dcd_both_gnd; 
  assign dcd_fallnrise = (delaymode_in === 1'b1) ? dcd_fallnrise_vcc : dcd_fallnrise_gnd; 
  assign dlyclk_clk = (duty_cycle_delay_mode == "both") ? dcd_both :
                      (duty_cycle_delay_mode == "fallnrise") ? dcd_fallnrise : dcd_in;
  
  // Output Register clocked by phasectrl_clk
  stratixiv_ddr_io_reg  dlyclk_reg(
                        .d(dlyclk_d), 
                        .clk(dlyclk_clk), 
                        .ena(dlyclk_clkena_in), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(sclr_in), 
                        .sload(sload_in),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(dlyclk_q)
                    );
           defparam dlyclk_reg.power_up = power_up;
  
  // enaoutputcycledelay data path mux - DDIO
  assign ddio_cycledelay_mux_out = (add_output_cycle_delay == "true")  ? ddio_cycledelay_q : 
                                   (add_output_cycle_delay == "false") ? ddio_datain_q :
                                   (enaoutputcycledelay_in === 1'b1)   ? ddio_cycledelay_q : ddio_datain_q;
  
                                   // input register bypass mux
  assign ddio_bypass_input_reg_mux_out = (bypass_input_register == "true") ? datain_in[1] : ddio_cycledelay_mux_out;
  
  //assign #300 ddio_transfer_q = ddio_cycledelay_mux_out;
  // transfer delay is implemented with negative register in rev1.26 
  stratixiv_ddr_io_reg  ddio_transferdelay_reg(
                        .d(ddio_bypass_input_reg_mux_out), 
                        .clk(~clk_in_mux), 
                        .ena(1'b1), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(sclr_in), 
                        .sload(sload_in),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(ddio_transfer_q)
                    );
           defparam ddio_transferdelay_reg.power_up = power_up;
  
  
  // add phase transfer data path mux
  assign ddio_dlyclk_d = (add_phase_transfer_reg == "true")  ? ddio_transfer_q : 
                         (add_phase_transfer_reg == "false") ? ddio_bypass_input_reg_mux_out :
                         (enaphasetransferreg_in === 1'b1)   ? ddio_transfer_q : ddio_bypass_input_reg_mux_out;
  
  // Output Register clocked by phasectrl_clk
  stratixiv_ddr_io_reg  ddio_dlyclk_reg(
                        .d(ddio_dlyclk_d), 
                        .clk(dlyclk_clk), 
                        .ena(dlyclk_clkena_in), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(sclr_in), 
                        .sload(sload_in),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(ddio_dlyclk_q)
                    );
           defparam ddio_dlyclk_reg.power_up = power_up;
  
  // Extension Register
  assign dlyclk_extended_clk = ~dlyclk_clk;
  
  stratixiv_ddr_io_reg  dlyclk_extended_reg(
                        .d(dlyclk_q), 
                        .clk(dlyclk_extended_clk), 
                        .ena(dlyclk_clkena_in), 
                        .clrn(clrn_in_r), 
                        .prn(prn_in_r),
                        .aload(1'b0), 
                        .asdata(adatasdata_in), 
                        .sclr(sclr_in), 
                        .sload(sload_in),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(dlyclk_extended_q)
                    );
           defparam dlyclk_extended_reg.power_up = power_up;
              
  endmodule    // stratixiv_output_phase_alignment
  
  //-----------------------------------------------------------------------------
  //
  // Module Name : stratixiv_input_phase_alignment
  //
  // Description : input phase alignment 
  //               Verilog simulation model 
  //
  //-----------------------------------------------------------------------------
  `timescale 1 ps/1 ps
    
  module stratixiv_input_phase_alignment (
      datain,
      clk,
      delayctrlin,
      phasectrlin,
      areset,
      enainputcycledelay,
      enaphasetransferreg,                          // new in 1.19
  	phaseinvertctrl,
      devclrn, 
      devpor,
      dffin, 
      dff1t,
      dataout
  );
  parameter use_phasectrlin   = "true";
  parameter phase_setting     = 0;
  parameter delay_buffer_mode = "high";
  parameter power_up          = "low";
  parameter async_mode        = "none";
  parameter add_input_cycle_delay           = "false";
  parameter bypass_output_register          = "false";
  parameter add_phase_transfer_reg        = "false"; // new in 1.19
  parameter invert_phase                    = "false"; // new in 1.26
  parameter sim_low_buffer_intrinsic_delay  = 350;
  parameter sim_high_buffer_intrinsic_delay = 175;
  parameter sim_buffer_delay_increment      = 10;
  
  parameter lpm_type = "stratixiv_input_phase_alignment";
  
  input        datain;
  input        clk;
  input [5:0]  delayctrlin;
  input [3:0]  phasectrlin;
  input        areset;
  input        enainputcycledelay;
  input        enaphasetransferreg;
  input        phaseinvertctrl;
  input        devclrn;
  input        devpor;
  
  output       dataout;
  output       dffin;               // buried port
  output       dff1t;               // buried port
  
 // LOCAL_PARAMETERS_BEGIN
  
  parameter sim_intrinsic_delay = (delay_buffer_mode == "low") ? sim_low_buffer_intrinsic_delay 
                                   : sim_high_buffer_intrinsic_delay;
  
 // LOCAL_PARAMETERS_END
  
  tri1 devclrn;
  tri1 devpor;
  
  // int signals
  wire        phasectrl_clkout;
  wire        delayed_clk;
  
  // IO registers
  // common
  reg         adatasdata_in_r;
  reg         aload_in_r;
  
  wire        datain_q;
  
  wire        cycledelay_q;
  wire        cycledelay_mux_out;
  wire        cycledelay_mux_out_dly;
  
  wire        dlyclk_d;
  wire        dlyclk_q;
  
  wire        tmp_dataout;
  
  // buffer layer
  wire        datain_in;
  wire        clk_in;
  wire [5:0]  delayctrlin_in;
  wire [3:0]  phasectrlin_in;
  wire        areset_in;
  wire        enainputcycledelay_in;
  wire        enaphasetransferreg_in;
  wire        devclrn_in, devpor_in;
  wire        phaseinvertctrl_in;
  
  assign phaseinvertctrl_in = (phaseinvertctrl === 1'b1) ? 1'b1 : 1'b0;
  assign datain_in =  (datain === 1'b1) ? 1'b1 : 1'b0;
  assign clk_in =  clk;
  assign areset_in =  (areset === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[5] = (delayctrlin[5] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[4] = (delayctrlin[4] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[3] = (delayctrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[2] = (delayctrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[1] = (delayctrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign delayctrlin_in[0] = (delayctrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[3] = (phasectrlin[3] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[2] = (phasectrlin[2] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[1] = (phasectrlin[1] === 1'b1) ? 1'b1 : 1'b0;
  assign phasectrlin_in[0] = (phasectrlin[0] === 1'b1) ? 1'b1 : 1'b0;
  assign enainputcycledelay_in = (enainputcycledelay === 1'b1) ? 1'b1 : 1'b0;
  assign enaphasetransferreg_in = (enaphasetransferreg === 1'b1) ? 1'b1 : 1'b0;
  
  assign devclrn_in = (devclrn === 1'b0) ? 1'b0 : 1'b1;
  assign devpor_in  = (devpor  === 1'b0) ? 1'b0 : 1'b1;
  
  // delay chain
  stratixiv_ddr_delay_chain_s m_delay_chain(
                          .clk(clk_in), 
                          .delayctrlin(delayctrlin_in), 
                          .phasectrlin(phasectrlin_in), 
                          .delayed_clkout(phasectrl_clkout)
                          );                      
  defparam m_delay_chain.phase_setting               = phase_setting;
  defparam m_delay_chain.use_phasectrlin             = use_phasectrlin;
  defparam m_delay_chain.sim_buffer_intrinsic_delay  = sim_intrinsic_delay;
  defparam m_delay_chain.sim_buffer_delay_increment  = sim_buffer_delay_increment;
  defparam m_delay_chain.phasectrlin_limit           = 7;
  
  assign delayed_clk = (invert_phase == "true") ? (~phasectrl_clkout) :
                       (invert_phase == "false") ? phasectrl_clkout :
                       (phaseinvertctrl_in === 1'b1) ? (~phasectrl_clkout) : phasectrl_clkout;
                       
  
  // primary output
  assign dataout = tmp_dataout;
  assign tmp_dataout = (bypass_output_register == "true") ? dlyclk_d : dlyclk_q;
  
  // add phase transfer data path mux
  assign dlyclk_d = (add_phase_transfer_reg == "true")  ? cycledelay_mux_out_dly : 
                    (add_phase_transfer_reg == "false") ? cycledelay_mux_out :
                    (enaphasetransferreg_in === 1'b1)   ? cycledelay_mux_out_dly : cycledelay_mux_out;
  
  // enaoutputcycledelay data path mux
  assign cycledelay_mux_out = (add_input_cycle_delay == "true")  ? cycledelay_q : 
                              (add_input_cycle_delay == "false") ? datain_q :
                              (enainputcycledelay_in === 1'b1)   ? cycledelay_q : datain_q;
  
  // resolve reset modes
  always @(areset_in)
  begin
      if(async_mode == "clear")
      begin
          aload_in_r   = areset_in;
          adatasdata_in_r = 1'b0;
      end
      else if(async_mode == "preset")
      begin
          aload_in_r   = areset_in;
          adatasdata_in_r = 1'b1;
      end
      else  // async_mode == "none"
      begin
          aload_in_r   = 1'b0;
          adatasdata_in_r = 1'b0;
      end
  end
  
  // Datain Register  
  stratixiv_ddr_io_reg  datain_reg(
                        .d(datain_in), 
                        .clk(delayed_clk), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b1), 
                        .q(datain_q)
                    );
           defparam datain_reg.power_up = power_up;
           
  // Cycle Delay Register  
  stratixiv_ddr_io_reg  cycledelay_reg(
                        .d(datain_q), 
                        .clk(delayed_clk), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(cycledelay_q)
                    );
           defparam cycledelay_reg.power_up = power_up;
  
  // assign #300 cycledelay_mux_out_dly = cycledelay_mux_out;  replaced by neg reg   
  // Transfer Register  - clocked by negative edge
  stratixiv_ddr_io_reg  transfer_reg(
                        .d(cycledelay_mux_out), 
                        .clk(~delayed_clk), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(cycledelay_mux_out_dly)
                    );
           defparam transfer_reg.power_up = power_up;
           
           
  // Register clocked by actually by clk_in
  stratixiv_ddr_io_reg  dlyclk_reg(
                        .d(dlyclk_d), 
                        .clk(clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in), 
                        .rpt_violation(1'b0), 
                        .q(dlyclk_q)
                    );
           defparam dlyclk_reg.power_up = power_up;  
                  
  endmodule    // stratixiv_input_phase_alignment
  
  //-----------------------------------------------------------------------------
  //
  // Module Name : stratixiv_half_rate_input
  //
  // Description : STRATIXIV half rate input 
  //               Verilog simulation model 
  //
  //-----------------------------------------------------------------------------
  `timescale 1 ps/1 ps
    
  module stratixiv_half_rate_input (
  	datain,
  	directin,
  	clk,
  	areset,
  	dataoutbypass,
  	devclrn, 
  	devpor,
  	dffin,
  	dataout
  );
  parameter power_up = "low";
  parameter async_mode = "none";
  parameter use_dataoutbypass = "false";
  
  parameter lpm_type = "stratixiv_half_rate_input";
  
  input [1:0]  datain;
  input        directin;
  input        clk;
  input        areset;
  input        dataoutbypass;
  input        devclrn;
  input        devpor;
  
  output [3:0] dataout;
  output [1:0] dffin;     // buried
  
  tri1 devclrn;
  tri1 devpor;
  
  // delayed version to ensure one cycle of latency in functional as expected
  wire [1:0] datain_in;
  
  // IO registers
  // common
  wire        neg_clk_in;
  reg         adatasdata_in_r;
  reg         aload_in_r;
  
  // low_bank  = {1, 0} - capturing datain at falling edge then sending at falling rise 
  // high_bank = {3, 2} - output of register datain at rising 
  wire [1:0]  high_bank;
  wire [1:0]  low_bank;
  wire        low_bank_low;
  wire        low_bank_high;
  wire        high_bank_low;
  wire        high_bank_high;
  
  wire [1:0]  dataout_reg_n;
  
  wire [3:0]   tmp_dataout;
  
  // buffer layer
  wire [1:0]  datain_ipd;
  wire        directin_in;
  wire        clk_in;
  wire        areset_in;
  wire        dataoutbypass_in;
  wire        devclrn_in, devpor_in;
  assign datain_ipd =  datain;
  assign directin_in =  directin;
  assign clk_in =  clk;
  assign areset_in =  (areset === 1'b1) ? 1'b1 : 1'b0;
  assign dataoutbypass_in =  (dataoutbypass === 1'b1) ? 1'b1 : 1'b0;
  assign devclrn_in = (devclrn === 1'b0) ? 1'b0 : 1'b1;
  assign devpor_in  = (devpor  === 1'b0) ? 1'b0 : 1'b1;
  
  // primary input
  assign #2 datain_in = datain_ipd;
  
  // primary output
  assign dataout = tmp_dataout;
  assign tmp_dataout[3] = (dataoutbypass_in === 1'b0 && use_dataoutbypass == "true") ?  directin_in : high_bank_high;
  assign tmp_dataout[2] = (dataoutbypass_in === 1'b0 && use_dataoutbypass == "true") ?  directin_in : high_bank_low;
  assign tmp_dataout[1] = low_bank[1];
  assign tmp_dataout[0] = low_bank[0];
  
  assign low_bank  = {low_bank_high, low_bank_low};
  assign high_bank = {high_bank_high, high_bank_low};
  
  // resolve reset modes
  always @(areset_in)
  begin
      if(async_mode == "clear")
      begin
          aload_in_r   = areset_in;
          adatasdata_in_r = 1'b0;
      end
      else if(async_mode == "preset")
      begin
          aload_in_r   = areset_in;
          adatasdata_in_r = 1'b1;
      end
      else  // async_mode == "none"
      begin
          aload_in_r   = 1'b0;
          adatasdata_in_r = 1'b0;
      end
  end
  
  assign neg_clk_in = ~clk_in;
  
  // datain_1 - H  
  stratixiv_ddr_io_reg  reg1_h(
                        .d(datain_in[1]), 
                        .clk(clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b1), 
                        .q(high_bank_high)
                    );
           defparam reg1_h.power_up = power_up;
  
  // datain_0 - H  
  stratixiv_ddr_io_reg  reg0_h(
                        .d(datain_in[0]), 
                        .clk(clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b1), 
                        .q(high_bank_low)
                    );
           defparam reg0_h.power_up = power_up;
  
  // datain_1 - L (n)  
  stratixiv_ddr_io_reg  reg1_l_n(
                        .d(datain_in[1]), 
                        .clk(neg_clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b1), 
                        .q(dataout_reg_n[1])
                    );
           defparam reg1_l_n.power_up = power_up;
           
  // datain_1 - L  
  stratixiv_ddr_io_reg reg1_l(
                        .d(dataout_reg_n[1]), 
                        .clk(clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b0), 
                        .q(low_bank_high)
                    );
           defparam reg1_l.power_up = power_up;
  
  // datain_0 - L (n)  
  stratixiv_ddr_io_reg  reg0_l_n(
                        .d(datain_in[0]), 
                        .clk(neg_clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b1), 
                        .q(dataout_reg_n[0])
                    );
           defparam reg0_l_n.power_up = power_up;
           
  // datain_0 - L  
  stratixiv_ddr_io_reg reg0_l(
                        .d(dataout_reg_n[0]), 
                        .clk(clk_in), 
                        .ena(1'b1), 
                        .clrn(1'b1), 
                        .prn(1'b1),
                        .aload(aload_in_r), 
                        .asdata(adatasdata_in_r), 
                        .sclr(1'b0), 
                        .sload(1'b0),
                        .devclrn(devclrn_in),
                        .devpor(devpor_in),
                        .rpt_violation(1'b0), 
                        .q(low_bank_low)
                    );
           defparam reg0_l.power_up = power_up;
  
  endmodule    // stratixiv_half_rate_input
  
  
  //-----------------------------------------------------------------------------
  //
  // Module Name : stratixiv_io_config
  //
  // Description : STRATIXIV I/O Configuration Register 
  //               Verilog simulation model 
  //
  //-----------------------------------------------------------------------------
  `timescale 1 ps/1 ps
    
  module stratixiv_io_config (
  	datain,
  	clk,
  	ena,
  	update,
  	devclrn, 
  	devpor,
  	padtoinputregisterdelaysetting,
  	outputdelaysetting1,
  	outputdelaysetting2,
  	dutycycledelaymode,
  	dutycycledelaysettings,
  	outputfinedelaysetting1,
  	outputfinedelaysetting2,
  	outputonlydelaysetting2,
  	outputonlyfinedelaysetting2,
  	padtoinputregisterfinedelaysetting, 
  	dataout
  );
  parameter enhanced_mode = "false";
  parameter lpm_type = "stratixiv_io_config";
  
  input        datain;
  input        clk;
  input        ena;
  input        update;
  input        devclrn;
  input        devpor;
  
  output [3:0] padtoinputregisterdelaysetting;
  output [3:0] outputdelaysetting1;
  output [2:0] outputdelaysetting2;
  output       dataout;
  // new STRATIXIV: ww30.2008
  output       dutycycledelaymode;
  output [3:0] dutycycledelaysettings;
  output       outputfinedelaysetting1;
  output       outputfinedelaysetting2;
  output [2:0] outputonlydelaysetting2;
  output       outputonlyfinedelaysetting2;
  output       padtoinputregisterfinedelaysetting;
  
  tri1 devclrn;
  tri1 devpor;
  
  reg  [10:0] shift_reg;
  reg  [10:0] output_reg;
  wire        tmp_dataout;
  wire [10:0] tmp_output;
  
  reg  [22:0] enhance_shift_reg;
  reg  [22:0] enhance_output_reg;
  wire [22:0] enhance_tmp_output;
  
  // buffer layer
  wire        datain_in;
  wire        clk_in;
  wire        ena_in;
  wire        update_in;
  wire        devclrn_in, devpor_in;
  assign datain_in =  datain;
  assign clk_in =  clk;
  assign ena_in =  (ena === 1'b1) ? 1'b1 : 1'b0;
  assign update_in =  (update === 1'b1) ? 1'b1 : 1'b0;
  assign  devclrn_in = (devclrn === 1'b0) ? 1'b0 : 1'b1;
  assign  devpor_in  = (devpor  === 1'b0) ? 1'b0 : 1'b1;
  
  // TCO DELAYS, IO PATH and SETUP-HOLD CHECKS
  specify
  	(posedge clk => (dataout +: tmp_dataout)) = (0, 0);
      
  	$setuphold(posedge clk, datain, 0, 0);
  endspecify
  
  // DRIVERs FOR outputs
  and (dataout, tmp_dataout, 1'b1);
  // primary outputs
  assign tmp_dataout = (enhanced_mode == "true") ? enhance_shift_reg[22] : shift_reg[10];
  
  // bit order changed in wys revision 1.32
  assign outputdelaysetting1            = (enhanced_mode == "true") ? enhance_tmp_output[3:0]  : tmp_output[3:0];
  assign outputdelaysetting2            = (enhanced_mode == "true") ? enhance_tmp_output[6:4]  : tmp_output[6:4];
  assign padtoinputregisterdelaysetting = (enhanced_mode == "true") ? enhance_tmp_output[10:7] : tmp_output[10:7];
  
  assign outputfinedelaysetting1            = (enhanced_mode == "true") ? enhance_tmp_output[11]     : 1'b0;
  assign outputfinedelaysetting2            = (enhanced_mode == "true") ? enhance_tmp_output[12]     : 1'b0;
  assign padtoinputregisterfinedelaysetting = (enhanced_mode == "true") ? enhance_tmp_output[13]     : 1'b0;
  assign outputonlyfinedelaysetting2        = (enhanced_mode == "true") ? enhance_tmp_output[14]     : 1'b0;
  assign outputonlydelaysetting2            = (enhanced_mode == "true") ? enhance_tmp_output[17:15]  : 3'b000;
  assign dutycycledelaymode                 = (enhanced_mode == "true") ? enhance_tmp_output[18]     : 1'b0;
  assign dutycycledelaysettings             = (enhanced_mode == "true") ? enhance_tmp_output[22:19]  : 4'h0;
  
  assign tmp_output = output_reg;
  assign enhance_tmp_output = enhance_output_reg;
  
  initial 
  begin
      shift_reg = 'b0;
      output_reg = 'b0;
      enhance_shift_reg = 'b0;
      enhance_output_reg = 'b0;
  end
  
  always @(posedge clk_in)
  begin
      if (ena_in === 1'b1)
      begin
          shift_reg[0] <= datain_in;
          shift_reg[10:1] <= shift_reg[9:0];
          enhance_shift_reg[0] <= datain_in;
          enhance_shift_reg[22:1] <= enhance_shift_reg[21:0];
      end
  end
  
  always @(posedge clk_in)
  begin
      if (update_in === 1'b1)
      begin  
          output_reg <= shift_reg;
          enhance_output_reg <= enhance_shift_reg;
      end
  end
  
  endmodule    // stratixiv_io_config
  
  //-----------------------------------------------------------------------------
  //
  // Module Name : stratixiv_dqs_config
  //
  // Description : STRATIXIV DQS Configuration Register 
  //               Verilog simulation model 
  //
  //-----------------------------------------------------------------------------
  `timescale 1 ps/1 ps
    
  module stratixiv_dqs_config (
  	datain,
  	clk,
  	ena,
  	update,
  	devclrn, 
  	devpor,
  	dqsbusoutdelaysetting,
  	dqsinputphasesetting,
  	dqsenablectrlphasesetting,
  	dqsoutputphasesetting,
  	dqoutputphasesetting,
  	resyncinputphasesetting,
  	dividerphasesetting,
  	enaoctcycledelaysetting,
  	enainputcycledelaysetting,
  	enaoutputcycledelaysetting,
  	dqsenabledelaysetting,
  	octdelaysetting1,
  	octdelaysetting2,
  	enadataoutbypass,
  	enadqsenablephasetransferreg, // new in 1.23
  	enaoctphasetransferreg,       // new in 1.23 
  	enaoutputphasetransferreg,    // new in 1.23
  	enainputphasetransferreg,     // new in 1.23 
  	resyncinputphaseinvert,         // new in 1.26
  	dqsenablectrlphaseinvert,       // new in 1.26
  	dqoutputphaseinvert,            // new in 1.26
  	dqsoutputphaseinvert,           // new in 1.26
  	dqsbusoutfinedelaysetting, 
  	dqsenablefinedelaysetting, 
  	
  	dataout
  );
  parameter enhanced_mode = "false";
  parameter lpm_type = "stratixiv_dqs_config";
  
  // INPUT PORTS
  input        datain;
  input        clk;
  input        ena;
  input        update;
  input        devclrn;
  input        devpor;
  
  // OUTPUT PORTS                                               
  output [3:0] dqsbusoutdelaysetting;          
  output [2:0] dqsinputphasesetting;
  output [3:0] dqsenablectrlphasesetting;
  output [3:0] dqsoutputphasesetting;
  output [3:0] dqoutputphasesetting;
  output [3:0] resyncinputphasesetting;
  output       dividerphasesetting;
  output       enaoctcycledelaysetting;
  output       enainputcycledelaysetting;
  output       enaoutputcycledelaysetting;
  output [2:0] dqsenabledelaysetting;
  output [3:0] octdelaysetting1;
  output [2:0] octdelaysetting2;
  output       enadataoutbypass;
  output       enadqsenablephasetransferreg; // new in 1.23
  output       enaoctphasetransferreg;       // new in 1.23 
  output       enaoutputphasetransferreg;    // new in 1.23
  output       enainputphasetransferreg;     // new in 1.23
  output       resyncinputphaseinvert;         // new in 1.26
  output       dqsenablectrlphaseinvert;       // new in 1.26
  output       dqoutputphaseinvert;            // new in 1.26
  output       dqsoutputphaseinvert;           // new in 1.26
  output       dqsbusoutfinedelaysetting;  // new in 1.39
  output       dqsenablefinedelaysetting;  // new in 1.39
  
  output       dataout;
  
  tri1 devclrn;
  tri1 devpor;
  
  reg  [47:0] shift_reg;
  reg  [47:0] output_reg;
  wire        tmp_dataout;
  wire [47:0] tmp_output;
  
  // buffer layer
  wire        datain_in;
  wire        clk_in;
  wire        ena_in;
  wire        update_in;
  wire        devclrn_in, devpor_in;
  assign datain_in =  datain;
  assign clk_in =  clk;
  assign ena_in =  (ena === 1'b1) ? 1'b1 : 1'b0;
  assign update_in =  (update === 1'b1) ? 1'b1 : 1'b0;
  assign  devclrn_in = (devclrn === 1'b0) ? 1'b0 : 1'b1;
  assign  devpor_in  = (devpor  === 1'b0) ? 1'b0 : 1'b1;
  
  // TCO DELAYS, IO PATH and SETUP-HOLD CHECKS
  specify
  	(posedge clk => (dataout +: tmp_dataout)) = (0, 0);
      
  	$setuphold(posedge clk, datain, 0, 0);
  endspecify
  
  // DRIVERs FOR outputs
  and (dataout, tmp_dataout, 1'b1);
  
  // primary outputs
  assign tmp_dataout = (enhanced_mode == "true") ? shift_reg[47] : shift_reg[45];
  
  assign dqsbusoutdelaysetting     = tmp_output[3  : 0];
  assign dqsinputphasesetting      = tmp_output[6  : 4];
  assign dqsenablectrlphasesetting = tmp_output[10 : 7];
  assign dqsoutputphasesetting     = tmp_output[14 : 11];
  assign dqoutputphasesetting      = tmp_output[18 : 15];
  assign resyncinputphasesetting   = tmp_output[22 : 19];
  assign dividerphasesetting       = tmp_output[23];
  assign enaoctcycledelaysetting   = tmp_output[24];
  assign enainputcycledelaysetting = tmp_output[25];
  assign enaoutputcycledelaysetting= tmp_output[26];
  assign dqsenabledelaysetting     = tmp_output[29 : 27];
  assign octdelaysetting1          = tmp_output[33 : 30];
  assign octdelaysetting2          = tmp_output[36 : 34];
  assign enadataoutbypass          = tmp_output[37];
  assign enadqsenablephasetransferreg = tmp_output[38]; // new in 1.23
  assign enaoctphasetransferreg       = tmp_output[39]; // new in 1.23 
  assign enaoutputphasetransferreg    = tmp_output[40]; // new in 1.23
  assign enainputphasetransferreg     = tmp_output[41]; // new in 1.23
  assign resyncinputphaseinvert       = tmp_output[42];    // new in 1.26
  assign dqsenablectrlphaseinvert     = tmp_output[43];    // new in 1.26
  assign dqoutputphaseinvert          = tmp_output[44];    // new in 1.26
  assign dqsoutputphaseinvert         = tmp_output[45];    // new in 1.26
  // new in STRATIXIV: ww30.2008
  assign dqsbusoutfinedelaysetting    = (enhanced_mode == "true") ? tmp_output[46] : 1'b0;    
  assign dqsenablefinedelaysetting    = (enhanced_mode == "true") ? tmp_output[47] : 1'b0;    
  
  assign tmp_output         = output_reg;
  
  initial 
  begin
      shift_reg = 'b0;
      output_reg = 'b0;
  end
  
  always @(posedge clk_in)
  begin
      if (ena_in === 1'b1)
      begin
          shift_reg[0] <= datain_in;
          shift_reg[47:1] <= shift_reg[46:0];
      end
  end
  
  always @(posedge clk_in)
  begin
      if (update_in === 1'b1)
          output_reg <= shift_reg;
  end
  
  endmodule    // stratixiv_dqs_config

// end_ddr

// --------------------------------------------------------------------
// Module Name: stratixiv_rt_sm
// Description: Parallel Termination State Machine
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixiv_rt_sm (
	rup,rdn,clk,clken,clr,rtena,rscaldone,
	rtoffsetp,rtoffsetn,caldone,
	sel_rup_vref,sel_rdn_vref
);
input rup;
input rdn;
input clk;
input clken;
input clr;
input rtena;
input rscaldone;

output [3:0] rtoffsetp;
output [3:0] rtoffsetn;
output       caldone;
output [2:0] sel_rup_vref;
output [2:0] sel_rdn_vref;

parameter STRATIXIV_RTOCT_WAIT         = 5'b00000;
parameter RUP_VREF_M_RDN_VER_M     = 5'b00001;
parameter RUP_VREF_L_RDN_VER_L     = 5'b00010;
parameter RUP_VREF_H_RDN_VER_H     = 5'b00011;
parameter RUP_VREF_L_RDN_VER_H     = 5'b00100;
parameter RUP_VREF_H_RDN_VER_L     = 5'b00101;
parameter STRATIXIV_RTOCT_INC_PN       = 5'b01000;
parameter STRATIXIV_RTOCT_DEC_PN       = 5'b01001;
parameter STRATIXIV_RTOCT_INC_P        = 5'b01010;
parameter STRATIXIV_RTOCT_DEC_P        = 5'b01011;
parameter STRATIXIV_RTOCT_INC_N        = 5'b01100;
parameter STRATIXIV_RTOCT_DEC_N        = 5'b01101;
parameter STRATIXIV_RTOCT_SWITCH_REG   = 5'b10001;
parameter STRATIXIV_RTOCT_DONE         = 5'b11111;

// interface
wire      nclr;  // for synthesis
wire      rtcalclk;

// sm
reg [4:0] current_state, next_state;
reg       sel_rup_vref_h_d, sel_rup_vref_h;
reg       sel_rup_vref_m_d, sel_rup_vref_m;
reg       sel_rup_vref_l_d, sel_rup_vref_l;
reg       sel_rdn_vref_h_d, sel_rdn_vref_h;
reg       sel_rdn_vref_m_d, sel_rdn_vref_m;
reg       sel_rdn_vref_l_d, sel_rdn_vref_l;
reg       switch_region_d, switch_region;
reg       cmpup, cmpdn;
reg       rt_sm_done_d, rt_sm_done;

// cnt
reg [2:0] p_cnt_d, p_cnt, n_cnt_d, n_cnt;
reg       p_cnt_sub_d,p_cnt_sub,n_cnt_sub_d,n_cnt_sub;

// primary output - MSB is sign bit
assign    rtoffsetp = {p_cnt_sub, p_cnt};
assign    rtoffsetn = {n_cnt_sub, n_cnt};
assign    caldone = (rtena == 1'b1) ? rt_sm_done : 1'b1;
          
assign    sel_rup_vref = {sel_rup_vref_h,sel_rup_vref_m,sel_rup_vref_l};
assign    sel_rdn_vref = {sel_rdn_vref_h,sel_rdn_vref_m,sel_rdn_vref_l};

// input interface
assign nclr = ~clr;
assign rtcalclk = (rscaldone & clken & ~caldone & clk);
                         
// latch registers - rising on everything except cmpup and cmpdn
// cmpup/dn
always @(negedge rtcalclk or negedge nclr)
begin
    if (nclr == 1'b0)
    begin
        cmpup            <= 1'b0;
        cmpdn            <= 1'b0;
    end
    else
    begin
        cmpup            <= rup;
        cmpdn            <= rdn;
    end
end

// other regisers
always @(posedge rtcalclk or posedge clr)
begin
    if (clr == 1'b1)
    begin
        current_state    <= STRATIXIV_RTOCT_WAIT;
        switch_region    <= 1'b0;
        rt_sm_done       <= 1'b0;

		p_cnt            <= 3'b000;
        p_cnt_sub        <= 1'b0;
		n_cnt            <= 3'b000;
        n_cnt_sub        <= 1'b0;

        sel_rup_vref_h   <= 1'b0;
        sel_rup_vref_m   <= 1'b1;
        sel_rup_vref_l   <= 1'b0;
        sel_rdn_vref_h   <= 1'b0;
        sel_rdn_vref_m   <= 1'b1;
        sel_rdn_vref_l   <= 1'b0;
    end
    else
    begin
        current_state    <= next_state;
        switch_region    <= switch_region_d;
        rt_sm_done       <= rt_sm_done_d;    

        p_cnt            <= p_cnt_d;
        p_cnt_sub        <= p_cnt_sub_d;
        n_cnt            <= n_cnt_d;
        n_cnt_sub        <= n_cnt_sub_d;

        sel_rup_vref_h   <= sel_rup_vref_h_d;
        sel_rup_vref_m   <= sel_rup_vref_m_d;
        sel_rup_vref_l   <= sel_rup_vref_l_d;
        sel_rdn_vref_h   <= sel_rdn_vref_h_d;
        sel_rdn_vref_m   <= sel_rdn_vref_m_d;
        sel_rdn_vref_l   <= sel_rdn_vref_l_d;
    end
end

// state machine
always @(current_state or rtena or cmpup or cmpdn or p_cnt or n_cnt or switch_region)
begin
    p_cnt_d      = p_cnt;
    n_cnt_d      = n_cnt;
    p_cnt_sub_d  = 1'b0;
    n_cnt_sub_d  = 1'b0;   

    case (current_state)
    
    STRATIXIV_RTOCT_WAIT :
        if (rtena == 1'b0)
            next_state = STRATIXIV_RTOCT_WAIT;
        else
        begin
            next_state = RUP_VREF_M_RDN_VER_M;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b1;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b1;
            sel_rdn_vref_l_d = 1'b0;
        end
            
    RUP_VREF_M_RDN_VER_M :
        if (cmpup == 1'b0 && cmpdn == 1'b0)
        begin
            next_state = RUP_VREF_L_RDN_VER_L;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b1;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b1;
        end 
        else if (cmpup == 1'b1 && cmpdn == 1'b1)
        begin
            next_state = RUP_VREF_H_RDN_VER_H;
            sel_rup_vref_h_d = 1'b1;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b1;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b0;
        end 
        else if (cmpup == 1'b1 && cmpdn == 1'b0)
        begin
            next_state = STRATIXIV_RTOCT_INC_PN;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b0;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b0;   
        end 
        else if (cmpup == 1'b0 && cmpdn == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DEC_PN;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b1;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b1;   
        end 
            
    RUP_VREF_L_RDN_VER_L :
        if (cmpup == 1'b1 && cmpdn == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DONE;
        end 
        else if (cmpup == 1'b0)
        begin
            next_state = STRATIXIV_RTOCT_DEC_N;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b1;   
        end
        else if (cmpup == 1'b1 && cmpdn == 1'b0)
        begin
            next_state = STRATIXIV_RTOCT_INC_P;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b0;   
        end
    
    RUP_VREF_H_RDN_VER_H :
        if (cmpup == 1'b0 && cmpdn == 1'b0)
        begin
            next_state = STRATIXIV_RTOCT_DONE;
        end 
        else if (cmpup == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_INC_N;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b0;   
        end
        else if (cmpup == 1'b0 && cmpdn == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DEC_P;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b1;   
        end
    
    RUP_VREF_L_RDN_VER_H :
        if (cmpup == 1'b1 && cmpdn == 1'b0)
        begin
            next_state = STRATIXIV_RTOCT_DONE;
        end 
        else if (cmpup == 1'b1 && switch_region == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DEC_P;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b1;   
        end
        else if (cmpup == 1'b0 && switch_region == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DEC_N;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b1;   
        end
        else if ((switch_region == 1'b0) && (cmpup == 1'b0 || cmpdn == 1'b1))
        begin
            next_state = STRATIXIV_RTOCT_SWITCH_REG;
            switch_region_d = 1'b1;
        end
    
    RUP_VREF_H_RDN_VER_L :
        if (cmpup == 1'b0 && cmpdn == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DONE;
        end 
        else if (cmpup == 1'b1 && switch_region == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_INC_N;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b0;   
        end
        else if (cmpup == 1'b0 && switch_region == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_INC_P;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b0;   
        end
        else if ((switch_region == 1'b0) && (cmpup == 1'b1 || cmpdn == 1'b0))
        begin
            next_state = STRATIXIV_RTOCT_SWITCH_REG;
            switch_region_d = 1'b1;
        end
    
    STRATIXIV_RTOCT_INC_PN :
        if (cmpup == 1'b1 && cmpdn == 1'b0)
        begin
            next_state = STRATIXIV_RTOCT_INC_PN;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b0;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b0;   
        end 
        else if (cmpup == 1'b0 && cmpdn == 1'b0)
        begin
            next_state = RUP_VREF_L_RDN_VER_L;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b1;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b1;
        end
        else if (cmpup == 1'b1 && cmpdn == 1'b1)
        begin
            next_state = RUP_VREF_H_RDN_VER_H;
            sel_rup_vref_h_d = 1'b1;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b1;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b0;
        end
        else if (cmpup == 1'b0 && cmpdn == 1'b1)
        begin
            next_state = RUP_VREF_L_RDN_VER_H;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b1;
            sel_rdn_vref_h_d = 1'b1;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b0;
        end 

    STRATIXIV_RTOCT_DEC_PN :
        if (cmpup == 1'b0 && cmpdn == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DEC_PN;
            p_cnt_d      = p_cnt_d + 3'b001;
            p_cnt_sub_d  = 1'b1;
            n_cnt_d      = n_cnt_d + 3'b001;
            n_cnt_sub_d  = 1'b1;   
        end 
        else if (cmpup == 1'b0 && cmpdn == 1'b0)
        begin
            next_state = RUP_VREF_L_RDN_VER_L;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b1;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b1;
        end
        else if (cmpup == 1'b1 && cmpdn == 1'b1)
        begin
            next_state = RUP_VREF_H_RDN_VER_H;
            sel_rup_vref_h_d = 1'b1;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b1;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b0;
        end
        else if (cmpup == 1'b1 && cmpdn == 1'b0)
        begin
            next_state = RUP_VREF_H_RDN_VER_L;
            sel_rup_vref_h_d = 1'b1;
            sel_rup_vref_m_d = 1'b0;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b0;
            sel_rdn_vref_l_d = 1'b1;
        end 

    STRATIXIV_RTOCT_INC_P,STRATIXIV_RTOCT_DEC_P,STRATIXIV_RTOCT_INC_N,STRATIXIV_RTOCT_DEC_N :
        if (switch_region == 1'b1)
        begin
            next_state = STRATIXIV_RTOCT_DONE;
        end 
        else if (switch_region == 1'b0)
        begin
            next_state = RUP_VREF_M_RDN_VER_M;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b1;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b1;
            sel_rdn_vref_l_d = 1'b0; 
        end
        
    STRATIXIV_RTOCT_SWITCH_REG :
        begin
            next_state = RUP_VREF_M_RDN_VER_M;
            sel_rup_vref_h_d = 1'b0;
            sel_rup_vref_m_d = 1'b1;
            sel_rup_vref_l_d = 1'b0;
            sel_rdn_vref_h_d = 1'b0;
            sel_rdn_vref_m_d = 1'b1;
            sel_rdn_vref_l_d = 1'b0; 
        end
        
    STRATIXIV_RTOCT_DONE :
        begin
            next_state = STRATIXIV_RTOCT_DONE;
            rt_sm_done_d = 1'b1;
        end
        
    default :
        next_state = STRATIXIV_RTOCT_WAIT;

    endcase // case(current_state)

end // always


// initial registers for simulations
initial begin
    current_state = STRATIXIV_RTOCT_WAIT;
    next_state    = STRATIXIV_RTOCT_WAIT;
    
    sel_rup_vref_h_d = 1'b0;
    sel_rup_vref_h   = 1'b0;
    sel_rup_vref_m_d = 1'b1;
    sel_rup_vref_m   = 1'b1;
    sel_rup_vref_l_d = 1'b0;
    sel_rup_vref_l   = 1'b0;
    sel_rdn_vref_h_d = 1'b0;
    sel_rdn_vref_h   = 1'b0;
    sel_rdn_vref_m_d = 1'b1;
    sel_rdn_vref_m   = 1'b1;
    sel_rdn_vref_l_d = 1'b0;
    sel_rdn_vref_l   = 1'b0;
    switch_region_d  = 1'b0;
    switch_region    = 1'b0;
    cmpup            = 1'b0;
    cmpdn            = 1'b0;
    rt_sm_done_d     = 1'b0;
    rt_sm_done       = 1'b0;
    p_cnt            = 1'b0;
    n_cnt            = 1'b0;
    p_cnt_sub        = 1'b0;
    n_cnt_sub        = 1'b0;
end

endmodule

// --------------------------------------------------------------------
// Module Name: stratixiv_termination_aux_clock_div
// Description: auxilary clock divider
// --------------------------------------------------------------------

`timescale 1 ps / 1 ps
module stratixiv_termination_aux_clock_div (
    clk,     // input clock
    reset,   // reset
    clkout   // divided clock
);
input clk;
input reset;
output clkout;

parameter clk_divide_by  = 1;
parameter extra_latency  = 0;

integer clk_edges,m;
reg [2*extra_latency:0] div_n_register;

initial
begin
    div_n_register = 'b0;
    clk_edges = -1;
    m = 0;
end

always @(posedge clk or negedge clk or posedge reset)
begin
    if (reset === 1'b1) 
    begin
        clk_edges = -1;
        div_n_register <= 'b0;
    end
    else
    begin
        if (clk_edges == -1) 
        begin
            div_n_register[0] <= clk;
            if (clk == 1'b1) 
                clk_edges = 0;
        end
        else if (clk_edges % clk_divide_by == 0) 
            div_n_register[0] <= ~div_n_register[0];
        if (clk_edges >= 0 || clk == 1'b1)
            clk_edges = (clk_edges + 1) % (2*clk_divide_by) ;
    end
    for (m = 0; m < 2*extra_latency; m=m+1)
            div_n_register[m+1] <= div_n_register[m];
end

assign clkout = div_n_register[2*extra_latency];

endmodule


//-----------------------------------------------------------------------------
//
// Module Name : stratixiv_termination
//
// Description : STRATIXIV Termination Atom 
//               Verilog simulation model 
//
//-----------------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixiv_termination (
	rup,rdn,terminationclock,terminationclear,terminationenable,
	serializerenable,terminationcontrolin,
	scanin, scanen,
	otherserializerenable,
	devclrn,devpor,
	incrup,incrdn,
	serializerenableout,
	terminationcontrol,terminationcontrolprobe,
	scanout, 
	shiftregisterprobe
);
parameter runtime_control = "false";
parameter allow_serial_data_from_core = "false";
parameter power_down = "true";
parameter test_mode = "false";
parameter enable_parallel_termination = "false";

parameter enable_calclk_divider= "false";  // replaced by below to remove
parameter clock_divider_enable = "false";
parameter enable_pwrupmode_enser_for_usrmode = "false"; // to remove
parameter bypass_enser_logic   = "false";               // to remove
parameter bypass_rt_calclk     = "false";  //RTEST3
parameter enable_rt_scan_mode  = "false";               // to remove
parameter enable_loopback      = "false";

parameter force_rtcalen_for_pllbiasen = "false";
parameter enable_rt_sm_loopback       = "false"; // RTEST4
parameter select_vrefl_values         = 0; 
parameter select_vrefh_values         = 0;
parameter divide_intosc_by            = 2;
parameter use_usrmode_clear_for_configmode = "false";

parameter lpm_type = "stratixiv_termination";

input       rup;
input       rdn;
input       terminationclock;
input       terminationclear;
input       terminationenable;
input       serializerenable;           // ENSERUSR
input       terminationcontrolin;
input       scanin;                                     // to remove
input       scanen;
input [8:0] otherserializerenable;
input       devclrn;
input       devpor;

output incrup;
output incrdn;
output serializerenableout;
output terminationcontrol;
output terminationcontrolprobe; 
output shiftregisterprobe;
output scanout;

tri1 devclrn;
tri1 devpor;

// HW outputs
wire compout_rup_core, compout_rdn_core;
wire ser_data_io, ser_data_core; 

// HW inputs
wire usr_clk, cal_clk, rscal_clk, cal_clken, cal_nclr; 

// gated user control
reg  enserusr_reg, clkenusr_reg, nclrusr_reg;  // registered by neg clk
wire enserusr_gated;                           // (enserusr & !clkenusr) - for P2S, S2P to shift
wire clkenusr_gated;                           // (enserusr & clkenusr) - for calibration
wire nclrusr_gated;                            // (enserusr | nclrusr): enserusr = 1 forces no clear

// clk divider
wire clkdiv_out;

// generating calclk and clkenout - 1 cycle latency
reg calclken_reg;
//wire clkenout;

// legality check on enser
reg  enser_checked;


// Shift Register
reg [6:0]  sreg_bit_out;
reg        sreg_bit_BIT_0;
reg        sreg_vshift_bit_out;
reg        sreg_bit0_next;
reg        sreg_vshift_bit_tmp;
reg        sreg_rscaldone_prev, sreg_rscaldone_prev1, sregn_rscaldone_out;
reg        sreg_bit6_prev;


// nreg before SA-ADC
wire       regn_rup_in, regn_rdn_in;
reg [6:0]  regn_compout_rup, regn_compout_rdn;
reg        regn_compout_rup_extra, regn_compout_rdn_extra; // extra is bit[8] accomodate last move


// SA-ADC
wire [6:0] sa_octcaln_out_tmp;       // this + _extra ==> code 
wire [6:0] sa_octcalp_out_tmp;
wire [6:0] sa_octcaln_out_tmp_extra;  
wire [6:0] sa_octcalp_out_tmp_extra;

wire [6:0] sa_octcaln_out;  // RUP - NMOS
wire [6:0] sa_octcalp_out;  // RDN - PMOS
wire [6:0] sa_octcaln_in, sa_octcalp_in; 

// ENSER
wire       enser_out;
wire       enser_gen_out;
reg [5:0]  enser_cnt;
reg        enser_gen_usr_out;

// RT State Machine
wire       rtsm_rup_in, rtsm_rdn_in;
wire       rtsm_rtena_in, rtsm_rscaldone_in;
wire       rtsm_caldone_out;
wire [3:0] rtsm_rtoffsetp_out, rtsm_rtoffsetn_out;
wire [2:0] rtsm_sel_rup_vref_out, rtsm_sel_rdn_vref_out;

// RT State Machine Scan Chain
wire       rtsm_sc_clk;
wire       rtsm_sc_in;
reg  [17:0] rtsm_sc_out_reg;
wire [17:0] rtsm_sc_out_reg_d;
wire [17:0] rtsm_sc_lpbk_mux;

// RT Adder/Sub
wire [6:0] rtas_rs_rpcdp_in, rtas_rs_rpcdn_in;
wire [6:0] rtas_rtoffsetp_in, rtas_rtoffsetn_in;       
wire [6:0] rtas_rs_rpcdp_out, rtas_rs_rpcdn_out;
wire [6:0] rtas_rt_rpcdp_out, rtas_rt_rpcdn_out;
   
// P2S
wire [6:0] p2s_rs_rpcdp_in, p2s_rs_rpcdn_in;
wire [6:0] p2s_rt_rpcdp_in, p2s_rt_rpcdn_in;
wire       p2s_ser_data_out;
wire       p2s_clk_ser_data;
reg        p2s_enser_reg;
wire [27:0] p2s_parallel_code;
wire [27:0] p2s_shift_d;
reg [27:0] p2s_shift_regs;

// timing
wire       rup_ipd;   
wire       rdn_ipd;   
wire       terminationclock_ipd;   
wire       terminationclear_ipd;   
wire       terminationenable_ipd;   
wire       serializerenable_ipd;   
wire       terminationcontrolin_ipd;   
wire [8:0] otherserializerenable_ipd;   

// primary outputs
assign incrup = (enable_loopback == "true") ? terminationenable_ipd : compout_rup_core;
assign incrdn = (enable_loopback == "true") ? terminationclear_ipd  : compout_rdn_core;
assign serializerenableout     = (enable_loopback == "true") ? serializerenable : enser_gen_usr_out;
assign terminationcontrol      = ser_data_io;
assign terminationcontrolprobe = (enable_loopback == "true") ? serializerenable_ipd : ser_data_core;
assign shiftregisterprobe      = (enable_loopback == "true") ? terminationclock_ipd : sreg_vshift_bit_out;

// disabled comparator when calibration is not enabled
assign compout_rup_core = (calclken_reg === 1'b1) ? rup : 1'bx;
assign compout_rdn_core = (calclken_reg === 1'b1) ? rdn : 1'bx;

assign ser_data_io   = (allow_serial_data_from_core == "true") ? terminationcontrolin : p2s_ser_data_out;
assign ser_data_core = p2s_ser_data_out;

// primary inputs
assign usr_clk   = terminationclock_ipd;

// gating the enserusr, clken and nclrusr ----------------------------------------------------
initial begin
    enserusr_reg = 1'b0;
    clkenusr_reg = 1'b0;
    nclrusr_reg  = 1'b1;
end

always @(negedge usr_clk)
begin
    if (serializerenable_ipd === 1'b1) 
       enserusr_reg <= 1'b1;
    else
       enserusr_reg <= 1'b0;
    
    if (terminationenable_ipd === 1'b1)
        clkenusr_reg <= 1'b1;
    else
        clkenusr_reg <= 1'b0;
        
    if (terminationclear_ipd === 1'b1)  // active low to high
        nclrusr_reg  <= 1'b0;
    else
        nclrusr_reg  <= 1'b1;
end

assign enserusr_gated = enserusr_reg & ~clkenusr_reg;  // code transfer (P2S and S2P)
assign clkenusr_gated = enserusr_reg & clkenusr_reg;   // calibration
assign nclrusr_gated  = enserusr_reg | nclrusr_reg;    // active low


// clk divider ----------------------------------------------------------------
stratixiv_termination_aux_clock_div m_gen_calclk (
    .clk(usr_clk), 
    .reset(~clkenusr_gated), 
    .clkout(clkdiv_out));
defparam m_gen_calclk.clk_divide_by = 20; // user clock is of 20 Mhz updated from 100;
defparam m_gen_calclk.extra_latency = 4;  // 5th rising edge after reset

// generating clkenout - a registered version of clkensur_gated ---------------
initial calclken_reg = 1'b0;
always @(negedge clkdiv_out or negedge clkenusr_gated)
begin
    if (clkenusr_gated == 1'b0)
        calclken_reg <= 1'b0;
    else
        calclken_reg <= 1'b1;
end
//assign clkenout = calclken_reg;

// generating cal_clkout - 1 cycle latency of divided clock     ---------------
assign cal_clk   = calclken_reg & clkdiv_out;

assign cal_nclr  = nclrusr_gated;   // active low
assign cal_clken = clkenusr_gated;



assign rscal_clk = cal_clk & (~sregn_rscaldone_out);

// legality check on enser
initial begin
    enser_checked = 1'b0;
end
always @(posedge usr_clk)
begin
    if (serializerenable === 1'b1 && terminationenable === 1'b0)
    begin
        if (otherserializerenable[0] === 1'b1 || otherserializerenable[1] === 1'b1 ||
            otherserializerenable[2] === 1'b1 || otherserializerenable[3] === 1'b1 ||
            otherserializerenable[4] === 1'b1 || otherserializerenable[5] === 1'b1 ||
            otherserializerenable[6] === 1'b1 || otherserializerenable[7] === 1'b1 ||
            otherserializerenable[8] === 1'b1)
        begin
            if (enser_checked === 1'b0)
            begin
            	$display ("Warning: serializizerable and some bits of otherserializerenable are asserted at time %t ps. This is not allowed in hardware data transfer time", $realtime);
            	$display ("Time: %0t  Instance: %m", $time);
            	enser_checked <= 1'b1;
            end
        end
        else
        begin
            enser_checked <= 1'b0;  // for another check       
        end
    end
    else
    begin
        enser_checked <= 1'b0;  // for another check           
    end
    
end


// SHIFT regiter
// ICD BIT_7 .. BIT_1 ===> sreg_bit_out[6..0];
// ICD BIT_0          ===> sreg_bit_BIT_0;
initial begin
    sreg_bit6_prev           = 1'b1;
    sreg_bit_out             = 6'b000000;
    sreg_bit0_next           = 1'b0;
    sreg_bit_BIT_0           = 1'b0;
    sreg_vshift_bit_tmp      = 1'b0;
    sreg_vshift_bit_out      = 1'b0;        // sending to shiftreg_probe
    sregn_rscaldone_out      = 1'b0;
    sreg_rscaldone_prev      = 1'b0;
    sreg_rscaldone_prev1     = 1'b0;
end
always @(posedge rscal_clk or negedge cal_nclr)
begin
    if (cal_nclr == 1'b0)
    begin
        sreg_bit6_prev           <= 1'b1;
        sreg_bit_out             <= 6'b000000;
        sreg_bit0_next           <= 1'b0;
        sreg_bit_BIT_0           <= 1'b0;
        sreg_vshift_bit_tmp      <= 1'b0;
        sreg_vshift_bit_out      <= 1'b0;
        sreg_rscaldone_prev      <= 1'b0;
        sreg_rscaldone_prev1     <= 1'b0;
    end
    else if (cal_clken == 1'b1)
    begin
        sreg_bit_out[6] <= sreg_bit6_prev;
        sreg_bit_out[5:0]   <= sreg_bit_out[6:1];
        sreg_bit0_next  <= sreg_bit_out[0];    // extra latency for ICD BIT_0
        sreg_bit_BIT_0  <= sreg_bit0_next;
        sreg_vshift_bit_tmp <= sreg_bit_out[0];
        sreg_vshift_bit_out <= sreg_bit_out[0] | sreg_vshift_bit_tmp;

        sreg_bit6_prev  <= 1'b0;
    end
    
    // might falling outside of 10 cycles
    if (sreg_vshift_bit_tmp == 1'b1)
        sreg_rscaldone_prev  <= 1'b1;
    sreg_rscaldone_prev1 <= sreg_rscaldone_prev;
end
always @(negedge rscal_clk or negedge cal_nclr)
begin
    if (cal_nclr == 1'b0)
        sregn_rscaldone_out <= 1'b0;
    else // if (cal_clken == 1'b1) - outside of 10 cycles
    begin
        if (sreg_rscaldone_prev1 == 1'b1 && sregn_rscaldone_out == 1'b0)
            sregn_rscaldone_out <= 1'b1;
    end
end
 
// nreg and SA-ADC: 
//
//    RDN_vol < ref_voltage < RUP_voltage
//    after reset, ref_voltage=VCCN/2; after ref_voltage_shift, ref_voltage=neighbor(VCCN/2)
//    at 0 code, RUP=VCCN so voltage_compare_out for RUP = 0
//               RDN=GND  so voltage compare out for RDN = 0
assign regn_rup_in = rup;
assign regn_rdn_in = ~rdn;   // inverted --------------------------

initial begin
    regn_compout_rup = 6'b00000;
    regn_compout_rdn = 6'b00000;    
    regn_compout_rup_extra = 1'b0;
    regn_compout_rdn_extra = 1'b0;    
end
always @(negedge rscal_clk or negedge cal_nclr)
begin
    if (cal_nclr == 1'b0)
    begin
        regn_compout_rup <= 6'b00000;
        regn_compout_rdn <= 6'b00000;
        regn_compout_rup_extra <= 1'b0;
        regn_compout_rdn_extra <= 1'b0;    
    end
    else
    begin
        // rup
        if (sreg_bit_BIT_0 == 1'b1) 
            regn_compout_rup_extra <= regn_rup_in;
        if (sreg_bit_out[0] == 1'b1) 
            regn_compout_rup[0] <= regn_rup_in;
        if (sreg_bit_out[1] == 1'b1) 
            regn_compout_rup[1] <= regn_rup_in;
        if (sreg_bit_out[2] == 1'b1) 
            regn_compout_rup[2] <= regn_rup_in;
        if (sreg_bit_out[3] == 1'b1) 
            regn_compout_rup[3] <= regn_rup_in;
        if (sreg_bit_out[4] == 1'b1) 
            regn_compout_rup[4] <= regn_rup_in;
        if (sreg_bit_out[5] == 1'b1) 
            regn_compout_rup[5] <= regn_rup_in;
        if (sreg_bit_out[6] == 1'b1) 
            regn_compout_rup[6] <= regn_rup_in;
        // rdn
        if (sreg_bit_BIT_0 == 1'b1) 
            regn_compout_rdn_extra <= regn_rdn_in;
        if (sreg_bit_out[0] == 1'b1) 
            regn_compout_rdn[0] <= regn_rdn_in;
        if (sreg_bit_out[1] == 1'b1) 
            regn_compout_rdn[1] <= regn_rdn_in;
        if (sreg_bit_out[2] == 1'b1) 
            regn_compout_rdn[2] <= regn_rdn_in;
        if (sreg_bit_out[3] == 1'b1) 
            regn_compout_rdn[3] <= regn_rdn_in;
        if (sreg_bit_out[4] == 1'b1) 
            regn_compout_rdn[4] <= regn_rdn_in;
        if (sreg_bit_out[5] == 1'b1) 
            regn_compout_rdn[5] <= regn_rdn_in;
        if (sreg_bit_out[6] == 1'b1) 
            regn_compout_rdn[6] <= regn_rdn_in;
    end
end

assign sa_octcaln_in = sreg_bit_out;
assign sa_octcalp_in = sreg_bit_out;

// RUP - octcaln_in == 1 = (pin_voltage < ref_voltage): clear the bit setting
assign sa_octcaln_out_tmp_extra = (cal_nclr == 1'b0) ? 1'b0 :
                                  (sreg_bit_BIT_0 == 1'b1) ? 1'b1: regn_compout_rup_extra;
assign sa_octcaln_out_tmp[0] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[0] == 1'b1) ? 1'b1: regn_compout_rup[0];
assign sa_octcaln_out_tmp[1] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[1] == 1'b1) ? 1'b1: regn_compout_rup[1];
assign sa_octcaln_out_tmp[2] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[2] == 1'b1) ? 1'b1: regn_compout_rup[2];
assign sa_octcaln_out_tmp[3] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[3] == 1'b1) ? 1'b1: regn_compout_rup[3];
assign sa_octcaln_out_tmp[4] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[4] == 1'b1) ? 1'b1: regn_compout_rup[4];
assign sa_octcaln_out_tmp[5] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[5] == 1'b1) ? 1'b1: regn_compout_rup[5];
assign sa_octcaln_out_tmp[6] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcaln_in[6] == 1'b1) ? 1'b1: regn_compout_rup[6];

// RDN - octcalp_in == 1 = (pin_voltage > ref_voltage): clear the bit setting
assign sa_octcalp_out_tmp_extra = (cal_nclr == 1'b0) ? 1'b0 :
                                  (sreg_bit_BIT_0 == 1'b1) ? 1'b1: regn_compout_rdn_extra;
assign sa_octcalp_out_tmp[0] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[0] == 1'b1) ? 1'b1: regn_compout_rdn[0];
assign sa_octcalp_out_tmp[1] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[1] == 1'b1) ? 1'b1: regn_compout_rdn[1];
assign sa_octcalp_out_tmp[2] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[2] == 1'b1) ? 1'b1: regn_compout_rdn[2];
assign sa_octcalp_out_tmp[3] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[3] == 1'b1) ? 1'b1: regn_compout_rdn[3];
assign sa_octcalp_out_tmp[4] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[4] == 1'b1) ? 1'b1: regn_compout_rdn[4];
assign sa_octcalp_out_tmp[5] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[5] == 1'b1) ? 1'b1: regn_compout_rdn[5];
assign sa_octcalp_out_tmp[6] = (cal_nclr == 1'b0) ? 1'b0 :
                           (sa_octcalp_in[6] == 1'b1) ? 1'b1: regn_compout_rdn[6];

assign sa_octcaln_out = sa_octcaln_out_tmp + sa_octcaln_out_tmp_extra;
assign sa_octcalp_out = sa_octcalp_out_tmp + sa_octcalp_out_tmp_extra;

                           
// ENSER
assign enser_out = (runtime_control == "true") ? enser_gen_usr_out : enser_gen_out;

// user mode
initial enser_gen_usr_out = 1'b0;
always @(negedge usr_clk)
begin
    enser_gen_usr_out <= serializerenable;
end

// for powerup mode
assign enser_gen_out = (enser_cnt > 6'd00 && enser_cnt < 6'd31) ? 1'b1 : 1'b0;
initial begin
    enser_cnt = 'b0;
end
always @(posedge usr_clk or posedge sregn_rscaldone_out)
begin
    if (sregn_rscaldone_out == 1'b0)
        enser_cnt <= 6'b000000;
    else if (enser_cnt < 6'd63)
        enser_cnt <= enser_cnt + 6'b000001;
end

// RT SM
assign rtsm_rup_in = rup;
assign rtsm_rdn_in = rdn;
assign rtsm_rtena_in = (enable_parallel_termination == "true") ? 1'b1 : 1'b0;
assign rtsm_rscaldone_in = sregn_rscaldone_out;

stratixiv_rt_sm m_rt_sm(
	.rup(rtsm_rup_in),                     
	.rdn(rtsm_rdn_in), 
	.clk(cal_clk),      
	.clken(cal_clken), 
	.clr(~cal_nclr),
	.rtena(rtsm_rtena_in),                 
	.rscaldone(rtsm_rscaldone_in),
	.rtoffsetp(rtsm_rtoffsetp_out),        
	.rtoffsetn(rtsm_rtoffsetn_out),
	.caldone(rtsm_caldone_out),
	.sel_rup_vref(rtsm_sel_rup_vref_out),  
	.sel_rdn_vref(rtsm_sel_rdn_vref_out)
);

// RT State Machine Scan Chain
initial rtsm_sc_out_reg = 'b0;

assign rtsm_sc_clk = (bypass_rt_calclk == "true") ? cal_clk : cal_clk; // : rtcal_clk
assign rtsm_sc_in = terminationcontrolin_ipd;

//TEST4&RTEST3 not implemented  - requires identical RT_SM
assign rtsm_sc_lpbk_mux = (bypass_rt_calclk == "true" && enable_rt_sm_loopback == "true") ? 
                          18'bx : 18'bx; 
                          
assign rtsm_sc_out_reg_d[17] = (bypass_rt_calclk == "true" && scanen === 1'b0) ? rtsm_sc_in
                              : rtsm_sc_lpbk_mux[17];
assign rtsm_sc_out_reg_d[16:0] = (bypass_rt_calclk == "true" && scanen === 1'b0) ? rtsm_sc_out_reg[17:1]
                              : rtsm_sc_lpbk_mux[16:0];
							  
assign scanout = rtsm_sc_out_reg[0];

always @(posedge rtsm_sc_clk or negedge cal_nclr)
begin
    if (cal_nclr == 1'b0)
        rtsm_sc_out_reg <= 'b0;
    else
        rtsm_sc_out_reg <= rtsm_sc_out_reg_d;
end


// RT Adder/Sub
assign rtas_rs_rpcdp_in = sa_octcalp_out;
assign rtas_rs_rpcdn_in = sa_octcaln_out;
assign rtas_rtoffsetp_in = {4'b0000, rtsm_rtoffsetp_out[2:0]};
assign rtas_rtoffsetn_in = {4'b0000, rtsm_rtoffsetn_out[2:0]};

assign rtas_rs_rpcdp_out = rtas_rs_rpcdp_in;
assign rtas_rs_rpcdn_out = rtas_rs_rpcdn_in;

assign  rtas_rt_rpcdn_out = (rtsm_rtoffsetn_out[3] == 1'b0) ? (rtas_rs_rpcdn_in + rtas_rtoffsetn_in) :
                            (rtas_rs_rpcdn_in - rtas_rtoffsetn_in);
assign  rtas_rt_rpcdp_out = (rtsm_rtoffsetp_out[3] == 1'b0) ? (rtas_rs_rpcdp_in + rtas_rtoffsetp_in) :
                            (rtas_rs_rpcdp_in - rtas_rtoffsetp_in);
        
// P2S ------------------------------------------------------------------------

// during calibration - enser_reg = 0
//     - enser_reg is low D inputs of shfit_reg select parallel code
//       caldone generating a rising pulse on clk_ser_data: shift_regs read in D (parallel_load)
// during serial shift - enser_reg = 1 for 28 cycles
//     - clk_ser_data = clkusr
//       28-bit are barrel-shifting
//
assign p2s_rs_rpcdp_in = rtas_rs_rpcdp_out;
assign p2s_rs_rpcdn_in = rtas_rs_rpcdn_out;
assign p2s_rt_rpcdp_in = rtas_rt_rpcdp_out;
assign p2s_rt_rpcdn_in = rtas_rt_rpcdn_out;

// serial shift clock
assign p2s_clk_ser_data = (enserusr_gated === 1'b1) ? (~usr_clk) :  // serial mode
                          (calclken_reg === 1'b1) ? (rtsm_caldone_out & sregn_rscaldone_out) : 1'b1; // one pulse for pload

// load D of shift register through - mux selection enser_reg
initial p2s_enser_reg = 1'b1; // load parallel code into D of shift reg - cleared by pllbiasen
always @(negedge usr_clk)
begin
    p2s_enser_reg <= ~calclken_reg;
end

assign p2s_parallel_code = {p2s_rs_rpcdp_in,p2s_rs_rpcdn_in,p2s_rt_rpcdp_in,p2s_rt_rpcdn_in};
assign p2s_shift_d = (p2s_enser_reg === 1'b1) ? {p2s_shift_regs[26:0], p2s_shift_regs[27]} : p2s_parallel_code; 

// shifting - cleared by PLLBIASEN
initial p2s_shift_regs = 'b0;

always @(posedge p2s_clk_ser_data)
begin
    p2s_shift_regs <= p2s_shift_d;
end

assign p2s_ser_data_out = (enserusr_gated === 1'b1) ? p2s_shift_regs[27] : 1'bx;
        
// timing - input path
buf        buf_rup_ipd (rup_ipd,rup);   
buf        buf_rdn_ipd (rdn_ipd,rdn);   
buf        buf_terminationclock_ipd (terminationclock_ipd,terminationclock);   
buf        buf_terminationclear_ipd (terminationclear_ipd,terminationclear);   
buf        buf_terminationenable_ipd (terminationenable_ipd, terminationenable);   
buf        buf_serializerenable_ipd (serializerenable_ipd,serializerenable);   
buf        buf_terminationcontrolin_ipd (terminationcontrolin_ipd,terminationcontrolin);   
buf        buf_otherserializerenable_ipd [8:0] (otherserializerenable_ipd,otherserializerenable);   
    
endmodule    // stratixiv_termination

//-----------------------------------------------------------------------------
//
// Module Name : stratixiv_termination_logic
//
// Description : STRATIXIV Termination Logic Atom 
//               Verilog simulation model 
//
//-----------------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixiv_termination_logic (
	serialloadenable,terminationclock,parallelloadenable,terminationdata,
	devclrn,devpor,
	seriesterminationcontrol,parallelterminationcontrol
);
parameter test_mode = "false";
parameter lpm_type = "stratixiv_termination_logic";

input serialloadenable;
input terminationclock;
input parallelloadenable;
input terminationdata;
input devclrn;
input devpor;

output [13:0] seriesterminationcontrol; 
output [13:0] parallelterminationcontrol;

tri1 devclrn;
tri1 devpor;

wire usr_clk;
wire shift_clk;
wire pload_clk;

reg    [27:0] shift_reg;
reg    [27:0] output_reg;

assign seriesterminationcontrol   = output_reg[27:14]; 
assign parallelterminationcontrol = output_reg[13:0];

assign #11 usr_clk = terminationclock;
assign     shift_clk = (serialloadenable === 1'b0) ? 1'b0 : usr_clk;  // serena & clk
assign     pload_clk = (parallelloadenable === 1'b1) ? 1'b1 : 1'b0;   // ploaden

initial begin
    // does not get reset so whatever power-up values
    shift_reg    = 'b0;
    output_reg   = 'b0;
end

always @(posedge shift_clk)
    shift_reg <= {shift_reg[26:0], terminationdata};

always @(posedge pload_clk)
    output_reg <= shift_reg;

endmodule    // stratixiv_termination_logic
//--------------------------------------------------------------------------
// Module Name     : stratixiv_io_pad
// Description     : Simulation model for stratixiv IO pad
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_io_pad ( 
		      padin, 
                      padout
	            );

parameter lpm_type = "stratixiv_io_pad";
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
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the STRATIXIV PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixiv_m_cntr   ( clk,
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

endmodule // stratixiv_m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the STRATIXIV PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixiv_n_cntr   ( clk,
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

endmodule // stratixiv_n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the C0-C9
//               output counters of the STRATIXIV PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixiv_scale_cntr   ( clk,
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

endmodule // stratixiv_scale_cntr

//BEGIN MF PORTING DELETE
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixiv_pll_reg  ( q,
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

endmodule // stratixiv_pll_reg
//END MF PORTING DELETE

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_pll
//
// Description : Timing simulation model for the STRATIXIV PLL.
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
// New Features : The list below outlines key new features in STRATIXIV:
//                1. Dynamic Phase Reconfiguration
//                2. Dynamic PLL Reconfiguration (different protocol)
//                3. More output counters
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
`define WORD_LENGTH 18

module stratixiv_pll (inclk,
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
    parameter dpa_multiply_by = 0;
    parameter dpa_divide_by = 0;
    parameter dpa_divider = 0;       // 0, 1, 2, 4

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

    parameter clk5_output_frequency                = 0;
    parameter clk5_multiply_by                     = 0;
    parameter clk5_divide_by                       = 0;
    parameter clk5_phase_shift                     = "0";
    parameter clk5_duty_cycle                      = 50;
    
    parameter clk6_output_frequency                = 0;
    parameter clk6_multiply_by                     = 0;
    parameter clk6_divide_by                       = 0;
    parameter clk6_phase_shift                     = "0";
    parameter clk6_duty_cycle                      = 50;
    
    parameter clk7_output_frequency                = 0;
    parameter clk7_multiply_by                     = 0;
    parameter clk7_divide_by                       = 0;
    parameter clk7_phase_shift                     = "0";
    parameter clk7_duty_cycle                      = 50;
    
    parameter clk8_output_frequency                = 0;
    parameter clk8_multiply_by                     = 0;
    parameter clk8_divide_by                       = 0;
    parameter clk8_phase_shift                     = "0";
    parameter clk8_duty_cycle                      = 50;
    
    parameter clk9_output_frequency                = 0;
    parameter clk9_multiply_by                     = 0;
    parameter clk9_divide_by                       = 0;
    parameter clk9_phase_shift                     = "0";
    parameter clk9_duty_cycle                      = 50;
    

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

    parameter c5_high = 1;
    parameter c5_low = 1;
    parameter c5_initial = 1;
    parameter c5_mode = "bypass";
    parameter c5_ph = 0;
    
    parameter c6_high = 1;
    parameter c6_low = 1;
    parameter c6_initial = 1;
    parameter c6_mode = "bypass";
    parameter c6_ph = 0;
    
    parameter c7_high = 1;
    parameter c7_low = 1;
    parameter c7_initial = 1;
    parameter c7_mode = "bypass";
    parameter c7_ph = 0;
    
    parameter c8_high = 1;
    parameter c8_low = 1;
    parameter c8_initial = 1;
    parameter c8_mode = "bypass";
    parameter c8_ph = 0;
    
    parameter c9_high = 1;
    parameter c9_low = 1;
    parameter c9_initial = 1;
    parameter c9_mode = "bypass";
    parameter c9_ph = 0;
    

    parameter m_ph = 0;

    parameter clk0_counter = "unused";
    parameter clk1_counter = "unused";
    parameter clk2_counter = "unused";
    parameter clk3_counter = "unused";
    parameter clk4_counter = "unused";
    parameter clk5_counter = "unused";
    parameter clk6_counter = "unused";
    parameter clk7_counter = "unused";
    parameter clk8_counter = "unused";
    parameter clk9_counter = "unused";

    parameter c1_use_casc_in = "off";
    parameter c2_use_casc_in = "off";
    parameter c3_use_casc_in = "off";
    parameter c4_use_casc_in = "off";
    parameter c5_use_casc_in = "off";
    parameter c6_use_casc_in = "off";
    parameter c7_use_casc_in = "off";
    parameter c8_use_casc_in = "off";
    parameter c9_use_casc_in = "off";

    parameter m_test_source  = -1;
    parameter c0_test_source = -1;
    parameter c1_test_source = -1;
    parameter c2_test_source = -1;
    parameter c3_test_source = -1;
    parameter c4_test_source = -1;
    parameter c5_test_source = -1;
    parameter c6_test_source = -1;
    parameter c7_test_source = -1;
    parameter c8_test_source = -1;
    parameter c9_test_source = -1;

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
    parameter lpm_type = "stratixiv_pll";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter down_spread                          = "0.0";
    parameter lock_c = 4;

    parameter sim_gate_lock_device_behavior        = "off";

    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;
    parameter clk3_phase_shift_num = 0;
    parameter clk4_phase_shift_num = 0;
    parameter family_name = "STRATIXIV";

    parameter clk0_use_even_counter_mode = "off";
    parameter clk1_use_even_counter_mode = "off";
    parameter clk2_use_even_counter_mode = "off";
    parameter clk3_use_even_counter_mode = "off";
    parameter clk4_use_even_counter_mode = "off";
    parameter clk5_use_even_counter_mode = "off";
    parameter clk6_use_even_counter_mode = "off";
    parameter clk7_use_even_counter_mode = "off";
    parameter clk8_use_even_counter_mode = "off";
    parameter clk9_use_even_counter_mode = "off";

    parameter clk0_use_even_counter_value = "off";
    parameter clk1_use_even_counter_value = "off";
    parameter clk2_use_even_counter_value = "off";
    parameter clk3_use_even_counter_value = "off";
    parameter clk4_use_even_counter_value = "off";
    parameter clk5_use_even_counter_value = "off";
    parameter clk6_use_even_counter_value = "off";
    parameter clk7_use_even_counter_value = "off";
    parameter clk8_use_even_counter_value = "off";
    parameter clk9_use_even_counter_value = "off";

    // TEST ONLY
    
    parameter init_block_reset_a_count = 1;
    parameter init_block_reset_b_count = 1;

// SIMULATION_ONLY_PARAMETERS_END
    
// LOCAL_PARAMETERS_BEGIN

    parameter phase_counter_select_width = 4;
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
    parameter test_counter_c6_delay_chain_bits = 0;
    parameter test_counter_c7_delay_chain_bits = 0;
    parameter test_counter_c8_delay_chain_bits = 0;
    parameter test_counter_c9_delay_chain_bits = 0;
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

    parameter test_counter_c3_sclk_delay_chain_bits  = -1;
    parameter test_counter_c4_sclk_delay_chain_bits  = -1;
    parameter test_counter_c5_lden_delay_chain_bits  = -1;
    parameter test_counter_c6_lden_delay_chain_bits  = -1;

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
    output [9:0] clk;
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
    reg [8*6:1] clk_num[0:9];
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
    wire inclk_c5;
    wire inclk_c6;
    wire inclk_c7;
    wire inclk_c8;
    wire inclk_c9;
    
    wire  inclk_c0_from_vco;
    wire  inclk_c1_from_vco;
    wire  inclk_c2_from_vco;
    wire  inclk_c3_from_vco;
    wire  inclk_c4_from_vco;
    wire  inclk_c5_from_vco;
    wire  inclk_c6_from_vco;
    wire  inclk_c7_from_vco;
    wire  inclk_c8_from_vco;
    wire  inclk_c9_from_vco;
    
    wire  inclk_m_from_vco;

    wire inclk_m;
    wire pfdena_wire;
    wire [9:0] clk_tmp, clk_out_pfd;


    wire [9:0] clk_out;

    wire c0_clk;
    wire c1_clk;
    wire c2_clk;
    wire c3_clk;
    wire c4_clk;
    wire c5_clk;
    wire c6_clk;
    wire c7_clk;
    wire c8_clk;
    wire c9_clk;

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
    reg [-1:232] scan_data;
    reg scanclkena_reg; // register scanclkena on negative edge of scanclk
    reg c0_rising_edge_transfer_done;
    reg c1_rising_edge_transfer_done;
    reg c2_rising_edge_transfer_done;
    reg c3_rising_edge_transfer_done;
    reg c4_rising_edge_transfer_done;
    reg c5_rising_edge_transfer_done;
    reg c6_rising_edge_transfer_done;
    reg c7_rising_edge_transfer_done;
    reg c8_rising_edge_transfer_done;
    reg c9_rising_edge_transfer_done;
    reg scanread_setup_violation;
    integer index;
    integer scanclk_cycles;
    reg d_msg;

    integer num_output_cntrs;
    reg no_warn;
    
    // Phase reconfig
    
    reg [3:0] phasecounterselect_reg;
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
    reg [8*2:1] i_clk9_counter;
    reg [8*2:1] i_clk8_counter;
    reg [8*2:1] i_clk7_counter;
    reg [8*2:1] i_clk6_counter;
    reg [8*2:1] i_clk5_counter;
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
    reg ic5_use_casc_in;
    reg ic6_use_casc_in;
    reg ic7_use_casc_in;
    reg ic8_use_casc_in;
    reg ic9_use_casc_in;

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

    // this is for stratixiv lvds only
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
            i_clk9_counter    = "c9";
            i_clk8_counter    = "c8";
            i_clk7_counter    = "c7";
            i_clk6_counter    = "c6";
            i_clk5_counter    = "c5" ;
            i_clk4_counter    = "c4" ;
            i_clk3_counter    = "c3" ;
            i_clk2_counter    = "c2" ;
            i_clk1_counter    = "c1" ;
            i_clk0_counter    = "c0" ;
        end
        else begin
            i_clk9_counter    = alpha_tolower(clk9_counter);
            i_clk8_counter    = alpha_tolower(clk8_counter);
            i_clk7_counter    = alpha_tolower(clk7_counter);
            i_clk6_counter    = alpha_tolower(clk6_counter);
            i_clk5_counter    = alpha_tolower(clk5_counter);
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
            find_simple_integer_fraction(clk5_multiply_by, clk5_divide_by,
                            max_d_value, i_clk5_mult_by, i_clk5_div_by);
            find_simple_integer_fraction(clk6_multiply_by, clk6_divide_by,
                            max_d_value, i_clk6_mult_by, i_clk6_div_by);
            find_simple_integer_fraction(clk7_multiply_by, clk7_divide_by,
                            max_d_value, i_clk7_mult_by, i_clk7_div_by);
            find_simple_integer_fraction(clk8_multiply_by, clk8_divide_by,
                            max_d_value, i_clk8_mult_by, i_clk8_div_by);
            find_simple_integer_fraction(clk9_multiply_by, clk9_divide_by,
                            max_d_value, i_clk9_mult_by, i_clk9_div_by);

            // convert user parameters to advanced
            if (l_vco_frequency_control == "manual_phase")
            begin
                find_m_and_n_4_manual_phase(inclk0_freq, vco_phase_shift_step,
                            i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,i_clk4_mult_by,
                i_clk5_mult_by,
                i_clk6_mult_by, i_clk7_mult_by,
                i_clk8_mult_by, i_clk9_mult_by,
                            i_clk0_div_by, i_clk1_div_by,
                            i_clk2_div_by, i_clk3_div_by,i_clk4_div_by,
                i_clk5_div_by,
                i_clk6_div_by, i_clk7_div_by,
                i_clk8_div_by, i_clk9_div_by,
                            clk0_counter, clk1_counter,
                            clk2_counter, clk3_counter,clk4_counter,
                clk5_counter,
                clk6_counter, clk7_counter,
                clk8_counter, clk9_counter,
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
                i_clk5_mult_by,
                i_clk6_mult_by, i_clk7_mult_by,
                i_clk8_mult_by, i_clk9_mult_by,
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
            i_c_high[5] = counter_high (output_counter_value(i_clk5_div_by,
                                        i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
            i_c_high[6] = counter_high (output_counter_value(i_clk6_div_by,
                                        i_clk6_mult_by,  i_m, i_n), clk6_duty_cycle);
            i_c_high[7] = counter_high (output_counter_value(i_clk7_div_by,
                                        i_clk7_mult_by,  i_m, i_n), clk7_duty_cycle);
            i_c_high[8] = counter_high (output_counter_value(i_clk8_div_by,
                                        i_clk8_mult_by,  i_m, i_n), clk8_duty_cycle);
            i_c_high[9] = counter_high (output_counter_value(i_clk9_div_by,
                                        i_clk9_mult_by,  i_m, i_n), clk9_duty_cycle);

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
            i_c_low[5]  = counter_low  (output_counter_value(i_clk5_div_by,
                                        i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
            i_c_low[6]  = counter_low  (output_counter_value(i_clk6_div_by,
                                        i_clk6_mult_by,  i_m, i_n), clk6_duty_cycle);
            i_c_low[7]  = counter_low  (output_counter_value(i_clk7_div_by,
                                        i_clk7_mult_by,  i_m, i_n), clk7_duty_cycle);
            i_c_low[8]  = counter_low  (output_counter_value(i_clk8_div_by,
                                        i_clk8_mult_by,  i_m, i_n), clk8_duty_cycle);
            i_c_low[9]  = counter_low  (output_counter_value(i_clk9_div_by,
                                        i_clk9_mult_by,  i_m, i_n), clk9_duty_cycle);

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
                                            str2int(clk5_phase_shift),
                                            str2int(clk6_phase_shift),
                                            str2int(clk7_phase_shift),
                                            str2int(clk8_phase_shift),
                                            str2int(clk9_phase_shift)
                                        );

            i_c_initial[0] = counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[1] = counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[2] = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[3] = counter_initial(get_phase_degree(ph_adjust(i_clk3_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[4] = counter_initial(get_phase_degree(ph_adjust(i_clk4_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[5] = counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[6] = counter_initial(get_phase_degree(ph_adjust(str2int(clk6_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[7] = counter_initial(get_phase_degree(ph_adjust(str2int(clk7_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[8] = counter_initial(get_phase_degree(ph_adjust(str2int(clk8_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[9] = counter_initial(get_phase_degree(ph_adjust(str2int(clk9_phase_shift), max_neg_abs)), i_m, i_n);

            i_c_mode[0] = counter_mode(clk0_duty_cycle,output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
            i_c_mode[1] = counter_mode(clk1_duty_cycle,output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
            i_c_mode[2] = counter_mode(clk2_duty_cycle,output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            i_c_mode[3] = counter_mode(clk3_duty_cycle,output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
            i_c_mode[4] = counter_mode(clk4_duty_cycle,output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
            i_c_mode[5] = counter_mode(clk5_duty_cycle,output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));
            i_c_mode[6] = counter_mode(clk6_duty_cycle,output_counter_value(i_clk6_div_by, i_clk6_mult_by,  i_m, i_n));
            i_c_mode[7] = counter_mode(clk7_duty_cycle,output_counter_value(i_clk7_div_by, i_clk7_mult_by,  i_m, i_n));
            i_c_mode[8] = counter_mode(clk8_duty_cycle,output_counter_value(i_clk8_div_by, i_clk8_mult_by,  i_m, i_n));
            i_c_mode[9] = counter_mode(clk9_duty_cycle,output_counter_value(i_clk9_div_by, i_clk9_mult_by,  i_m, i_n));

            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            
            i_c_ph[0] = counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[1] = counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[2] = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[3] = counter_ph(get_phase_degree(ph_adjust(i_clk3_phase_shift,max_neg_abs)), i_m, i_n);
            i_c_ph[4] = counter_ph(get_phase_degree(ph_adjust(i_clk4_phase_shift,max_neg_abs)), i_m, i_n);
            i_c_ph[5] = counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[6] = counter_ph(get_phase_degree(ph_adjust(str2int(clk6_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[7] = counter_ph(get_phase_degree(ph_adjust(str2int(clk7_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[8] = counter_ph(get_phase_degree(ph_adjust(str2int(clk8_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[9] = counter_ph(get_phase_degree(ph_adjust(str2int(clk9_phase_shift),max_neg_abs)), i_m, i_n);


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
            i_c_high[5] = c5_high;
            i_c_high[6] = c6_high;
            i_c_high[7] = c7_high;
            i_c_high[8] = c8_high;
            i_c_high[9] = c9_high;
            i_c_low[0]  = c0_low;
            i_c_low[1]  = c1_low;
            i_c_low[2]  = c2_low;
            i_c_low[3]  = c3_low;
            i_c_low[4]  = c4_low;
            i_c_low[5]  = c5_low;
            i_c_low[6]  = c6_low;
            i_c_low[7]  = c7_low;
            i_c_low[8]  = c8_low;
            i_c_low[9]  = c9_low;
            i_c_initial[0] = c0_initial;
            i_c_initial[1] = c1_initial;
            i_c_initial[2] = c2_initial;
            i_c_initial[3] = c3_initial;
            i_c_initial[4] = c4_initial;
            i_c_initial[5] = c5_initial;
            i_c_initial[6] = c6_initial;
            i_c_initial[7] = c7_initial;
            i_c_initial[8] = c8_initial;
            i_c_initial[9] = c9_initial;
            i_c_mode[0] = translate_string(alpha_tolower(c0_mode));
            i_c_mode[1] = translate_string(alpha_tolower(c1_mode));
            i_c_mode[2] = translate_string(alpha_tolower(c2_mode));
            i_c_mode[3] = translate_string(alpha_tolower(c3_mode));
            i_c_mode[4] = translate_string(alpha_tolower(c4_mode));
            i_c_mode[5] = translate_string(alpha_tolower(c5_mode));
            i_c_mode[6] = translate_string(alpha_tolower(c6_mode));
            i_c_mode[7] = translate_string(alpha_tolower(c7_mode));
            i_c_mode[8] = translate_string(alpha_tolower(c8_mode));
            i_c_mode[9] = translate_string(alpha_tolower(c9_mode));
            i_c_ph[0]  = c0_ph;
            i_c_ph[1]  = c1_ph;
            i_c_ph[2]  = c2_ph;
            i_c_ph[3]  = c3_ph;
            i_c_ph[4]  = c4_ph;
            i_c_ph[5]  = c5_ph;
            i_c_ph[6]  = c6_ph;
            i_c_ph[7]  = c7_ph;
            i_c_ph[8]  = c8_ph;
            i_c_ph[9]  = c9_ph;
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


        if ((l_pll_type == "fast") || (l_pll_type == "lvds") || (l_pll_type == "left_right"))
        begin
            scan_chain_length = FAST_SCAN_CHAIN;
            num_output_cntrs = 7;
        end
        else
        begin
            scan_chain_length = GPP_SCAN_CHAIN;
            num_output_cntrs = 10;
        end
        
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
        c5_rising_edge_transfer_done = 0;
        c6_rising_edge_transfer_done = 0;
        c7_rising_edge_transfer_done = 0;
        c8_rising_edge_transfer_done = 0;
        c9_rising_edge_transfer_done = 0;
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
                scan_data[17] = 1'b1;
        else
                scan_data[17] = 1'b0;  // set bypass bit to 0
       
        // 2. High (bit 18-25)
        // 3. Mode - odd/even (bit 26)
        if (m_val[0] % 2 == 0)
        begin
            // M is an even no. : set M high = low,
            // set odd/even bit to 0
                scan_data[18:25] = m_val[0]/2;
                scan_data[26] = 1'b0;
        end
        else 
        begin 
            // M is odd : M high = low + 1
                scan_data[18:25] = m_val[0]/2 + 1;
                scan_data[26] = 1'b1;
        end
        // 4. Low (bit 27-34)
            scan_data[27:34] = m_val[0]/2;

        
        // N counter
        // 1. Mode - bypass (bit 35)
        if (n_mode_val[0] == "bypass")
                scan_data[35] = 1'b1;
        else 
                scan_data[35] = 1'b0;  // set bypass bit to 0
        // 2. High (bit 36-43)
        // 3. Mode - odd/even (bit 44)
        if (n_val[0] % 2 == 0)
        begin
            // N is an even no. : set N high = low,
            // set odd/even bit to 0
                scan_data[36:43] = n_val[0]/2;
                scan_data[44] = 1'b0;
        end
        else 
        begin // N is odd : N high = N low + 1
                scan_data[36:43] = n_val[0]/2 + 1;
                scan_data[44] = 1'b1;
        end
        // 4. Low (bit 45-52)
                scan_data[45:52] = n_val[0]/2;


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
        if (m_test_source != -1 || c0_test_source != -1 || c1_test_source != -1 || c2_test_source != -1 || c3_test_source != -1 || c4_test_source != -1 || c5_test_source != -1 || c6_test_source != -1 || c7_test_source != -1 || c8_test_source != -1 || c9_test_source != -1)
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
        if (c5_use_casc_in == "on")
            ic5_use_casc_in = 1;
        else
            ic5_use_casc_in = 0;
        if (c6_use_casc_in == "on")
            ic6_use_casc_in = 1;
        else
            ic6_use_casc_in = 0;
        if (c7_use_casc_in == "on")
            ic7_use_casc_in = 1;
        else
            ic7_use_casc_in = 0;
        if (c8_use_casc_in == "on")
            ic8_use_casc_in = 1;
        else
            ic8_use_casc_in = 0;
        if (c9_use_casc_in == "on")
            ic9_use_casc_in = 1;
        else
            ic9_use_casc_in = 0;

        tap0_is_active = 1;
        
// To display clock mapping       
    case( i_clk0_counter)
            "c0" : clk_num[0] = "  clk0";
            "c1" : clk_num[0] = "  clk1";
            "c2" : clk_num[0] = "  clk2";
            "c3" : clk_num[0] = "  clk3";
            "c4" : clk_num[0] = "  clk4";
            "c5" : clk_num[0] = "  clk5";
            "c6" : clk_num[0] = "  clk6";
            "c7" : clk_num[0] = "  clk7";
            "c8" : clk_num[0] = "  clk8";
            "c9" : clk_num[0] = "  clk9";
            default:clk_num[0] = "unused";
    endcase
    
        case( i_clk1_counter)
            "c0" : clk_num[1] = "  clk0";
            "c1" : clk_num[1] = "  clk1";
            "c2" : clk_num[1] = "  clk2";
            "c3" : clk_num[1] = "  clk3";
            "c4" : clk_num[1] = "  clk4";
            "c5" : clk_num[1] = "  clk5";
            "c6" : clk_num[1] = "  clk6";
            "c7" : clk_num[1] = "  clk7";
            "c8" : clk_num[1] = "  clk8";
            "c9" : clk_num[1] = "  clk9";
            default:clk_num[1] = "unused";
    endcase
        
    case( i_clk2_counter)
            "c0" : clk_num[2] = "  clk0";
            "c1" : clk_num[2] = "  clk1";
            "c2" : clk_num[2] = "  clk2";
            "c3" : clk_num[2] = "  clk3";
            "c4" : clk_num[2] = "  clk4";
            "c5" : clk_num[2] = "  clk5";
            "c6" : clk_num[2] = "  clk6";
            "c7" : clk_num[2] = "  clk7";
            "c8" : clk_num[2] = "  clk8";
            "c9" : clk_num[2] = "  clk9";
            default:clk_num[2] = "unused";
    endcase
        
    case( i_clk3_counter)
            "c0" : clk_num[3] = "  clk0";
            "c1" : clk_num[3] = "  clk1";
            "c2" : clk_num[3] = "  clk2";
            "c3" : clk_num[3] = "  clk3";
            "c4" : clk_num[3] = "  clk4";
            "c5" : clk_num[3] = "  clk5";
            "c6" : clk_num[3] = "  clk6";
            "c7" : clk_num[3] = "  clk7";
            "c8" : clk_num[3] = "  clk8";
            "c9" : clk_num[3] = "  clk9";
            default:clk_num[3] = "unused";
    endcase
        
    case( i_clk4_counter)
            "c0" : clk_num[4] = "  clk0";
            "c1" : clk_num[4] = "  clk1";
            "c2" : clk_num[4] = "  clk2";
            "c3" : clk_num[4] = "  clk3";
            "c4" : clk_num[4] = "  clk4";
            "c5" : clk_num[4] = "  clk5";
            "c6" : clk_num[4] = "  clk6";
            "c7" : clk_num[4] = "  clk7";
            "c8" : clk_num[4] = "  clk8";
            "c9" : clk_num[4] = "  clk9";
            default:clk_num[4] = "unused";
    endcase
        
    case( i_clk5_counter)
            "c0" : clk_num[5] = "  clk0";
            "c1" : clk_num[5] = "  clk1";
            "c2" : clk_num[5] = "  clk2";
            "c3" : clk_num[5] = "  clk3";
            "c4" : clk_num[5] = "  clk4";
            "c5" : clk_num[5] = "  clk5";
            "c6" : clk_num[5] = "  clk6";
            "c7" : clk_num[5] = "  clk7";
            "c8" : clk_num[5] = "  clk8";
            "c9" : clk_num[5] = "  clk9";
            default:clk_num[5] = "unused";
    endcase
        
    case( i_clk6_counter)
            "c0" : clk_num[6] = "  clk0";
            "c1" : clk_num[6] = "  clk1";
            "c2" : clk_num[6] = "  clk2";
            "c3" : clk_num[6] = "  clk3";
            "c4" : clk_num[6] = "  clk4";
            "c5" : clk_num[6] = "  clk5";
            "c6" : clk_num[6] = "  clk6";
            "c7" : clk_num[6] = "  clk7";
            "c8" : clk_num[6] = "  clk8";
            "c9" : clk_num[6] = "  clk9";
            default:clk_num[6] = "unused";
    endcase
    
    case( i_clk7_counter)
            "c0" : clk_num[7] = "  clk0";
            "c1" : clk_num[7] = "  clk1";
            "c2" : clk_num[7] = "  clk2";
            "c3" : clk_num[7] = "  clk3";
            "c4" : clk_num[7] = "  clk4";
            "c5" : clk_num[7] = "  clk5";
            "c6" : clk_num[7] = "  clk6";
            "c7" : clk_num[7] = "  clk7";
            "c8" : clk_num[7] = "  clk8";
            "c9" : clk_num[7] = "  clk9";
            default:clk_num[7] = "unused";
    endcase
        
    case( i_clk8_counter)
            "c0" : clk_num[8] = "  clk0";
            "c1" : clk_num[8] = "  clk1";
            "c2" : clk_num[8] = "  clk2";
            "c3" : clk_num[8] = "  clk3";
            "c4" : clk_num[8] = "  clk4";
            "c5" : clk_num[8] = "  clk5";
            "c6" : clk_num[8] = "  clk6";
            "c7" : clk_num[8] = "  clk7";
            "c8" : clk_num[8] = "  clk8";
            "c9" : clk_num[8] = "  clk9";
            default:clk_num[8] = "unused";
    endcase
        
    case( i_clk9_counter)
            "c0" : clk_num[9] = "  clk0";
            "c1" : clk_num[9] = "  clk1";
            "c2" : clk_num[9] = "  clk2";
            "c3" : clk_num[9] = "  clk3";
            "c4" : clk_num[9] = "  clk4";
            "c5" : clk_num[9] = "  clk5";
            "c6" : clk_num[9] = "  clk6";
            "c7" : clk_num[9] = "  clk7";
            "c8" : clk_num[9] = "  clk8";
            "c9" : clk_num[9] = "  clk9";
            default:clk_num[9] = "unused";
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
                       

    stratixiv_m_cntr m1 (.clk(inclk_m),
                        .reset(areset || stop_vco),
                        .cout(fbclk),
                        .initial_value(m_initial_val),
                        .modulus(m_val[0]),
                        .time_delay(m_delay));

    stratixiv_n_cntr n1 (.clk(inclk_n),
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
    assign inclk_c5_from_vco = vco_tap[c_ph_val[5]];
    assign inclk_c6_from_vco = vco_tap[c_ph_val[6]];
    assign inclk_c7_from_vco = vco_tap[c_ph_val[7]];
    assign inclk_c8_from_vco = vco_tap[c_ph_val[8]];
    assign inclk_c9_from_vco = vco_tap[c_ph_val[9]];
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

    stratixiv_scale_cntr c0 (.clk(inclk_c0),
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
    
    stratixiv_scale_cntr c1 (.clk(inclk_c1),
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

    stratixiv_scale_cntr c2 (.clk(inclk_c2),
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
    
    stratixiv_scale_cntr c3 (.clk(inclk_c3),
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
    stratixiv_scale_cntr c4 (.clk(inclk_c4),
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

    assign inclk_c5 = (c5_test_source == 0) ? fbclk : (c5_test_source == 1) ? refclk : (ic5_use_casc_in == 1) ? c4_clk : inclk_c5_from_vco;
    stratixiv_scale_cntr c5 (.clk(inclk_c5),
                            .reset(areset  || stop_vco),
                            .cout(c5_clk),
                            .high(c_high_val[5]),
                            .low(c_low_val[5]),
                            .initial_value(c_initial_val[5]),
                            .mode(c_mode_val[5]),
                            .ph_tap(c_ph_val[5]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[5] <= c_high_val_tmp[5];
            c_mode_val[5] <= c_mode_val_tmp[5];
            c5_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c5_rising_edge_transfer_done)
        begin
            c_low_val[5] <= c_low_val_tmp[5];
        end
    end
    
    assign inclk_c6 = ((c6_test_source == 0) ? fbclk : (c6_test_source == 1) ? refclk :  (ic6_use_casc_in == 1) ? c5_clk : inclk_c6_from_vco);
    stratixiv_scale_cntr c6 (.clk(inclk_c6),
                            .reset(areset  || stop_vco),
                            .cout(c6_clk),
                            .high(c_high_val[6]),
                            .low(c_low_val[6]),
                            .initial_value(c_initial_val[6]),
                            .mode(c_mode_val[6]),
                            .ph_tap(c_ph_val[6]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[6] <= c_high_val_tmp[6];
            c_mode_val[6] <= c_mode_val_tmp[6];
            c6_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c6_rising_edge_transfer_done)
        begin
            c_low_val[6] <= c_low_val_tmp[6];
        end
    end
    
    assign inclk_c7 = ((c7_test_source == 0) ? fbclk : (c7_test_source == 1) ? refclk :  (ic7_use_casc_in == 1) ? c6_clk : inclk_c7_from_vco);
    stratixiv_scale_cntr c7 (.clk(inclk_c7),
                            .reset(areset  || stop_vco),
                            .cout(c7_clk),
                            .high(c_high_val[7]),
                            .low(c_low_val[7]),
                            .initial_value(c_initial_val[7]),
                            .mode(c_mode_val[7]),
                            .ph_tap(c_ph_val[7]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[7] <= c_high_val_tmp[7];
            c_mode_val[7] <= c_mode_val_tmp[7];
            c7_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c7_rising_edge_transfer_done)
        begin
            c_low_val[7] <= c_low_val_tmp[7];
        end
    end
    
    assign inclk_c8 = ((c8_test_source == 0) ? fbclk : (c8_test_source == 1) ? refclk :  (ic8_use_casc_in == 1) ? c7_clk : inclk_c8_from_vco);
    stratixiv_scale_cntr c8 (.clk(inclk_c8),
                            .reset(areset || stop_vco),
                            .cout(c8_clk),
                            .high(c_high_val[8]),
                            .low(c_low_val[8]),
                            .initial_value(c_initial_val[8]),
                            .mode(c_mode_val[8]),
                            .ph_tap(c_ph_val[8]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[8] <= c_high_val_tmp[8];
            c_mode_val[8] <= c_mode_val_tmp[8];
            c8_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c8_rising_edge_transfer_done)
        begin
            c_low_val[8] <= c_low_val_tmp[8];
        end
    end
    
    assign inclk_c9 = ((c9_test_source == 0) ? fbclk : (c9_test_source == 1) ? refclk :  (ic9_use_casc_in == 1) ? c8_clk : inclk_c9_from_vco);
    stratixiv_scale_cntr c9 (.clk(inclk_c9),
                            .reset(areset  || stop_vco),
                            .cout(c9_clk),
                            .high(c_high_val[9]),
                            .low(c_low_val[9]),
                            .initial_value(c_initial_val[9]),
                            .mode(c_mode_val[9]),
                            .ph_tap(c_ph_val[9]));

    always @(posedge scanclk)
    begin
        if (update_conf_latches_reg == 1'b1)
        begin
            c_high_val[9] <= c_high_val_tmp[9];
            c_mode_val[9] <= c_mode_val_tmp[9];
            c9_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge scanclk)
    begin
        if (c9_rising_edge_transfer_done)
        begin
            c_low_val[9] <= c_low_val_tmp[9];
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
    assign scandataout_tmp = (l_pll_type == "fast" || l_pll_type == "lvds" || l_pll_type == "left_right") ? scan_data[FAST_SCAN_CHAIN-2] : scan_data[GPP_SCAN_CHAIN-2];

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
            if (phasecounterselect < 4'b1100) // no counters selected
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
        c5_rising_edge_transfer_done = 0;
        c6_rising_edge_transfer_done = 0;
        c7_rising_edge_transfer_done = 0;
        c8_rising_edge_transfer_done = 0;
        c9_rising_edge_transfer_done = 0;
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
                m_mode_val[0] = "bypass";
            // 3. Mode - odd/even (bit 26)
            else if (scan_data[26] == 1'b1)
                m_mode_val[0] = "   odd";
            else
                m_mode_val[0] = "  even";
            // 2. High (bit 18-25)
                m_hi = scan_data[18:25];
            // 4. Low (bit 27-34)
                m_lo = scan_data[27:34]; 


            // N counter
            // 1. Mode - bypass (bit 35)
            if (scan_data[35] == 1'b1)
                n_mode_val[0] = "bypass";
            // 3. Mode - odd/even (bit 44)
            else if (scan_data[44] == 1'b1)
                n_mode_val[0] = "   odd";
            else
                n_mode_val[0] = "  even";
            
            // 2. High (bit 36-43)
                n_hi = scan_data[36:43];
            
            // 4. Low (bit 45-52)
                n_lo = scan_data[45:52]; 


            
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

    assign clk_tmp[0] = i_clk0_counter == "c0" ? c0_clk : i_clk0_counter == "c1" ? c1_clk : i_clk0_counter == "c2" ? c2_clk : i_clk0_counter == "c3" ? c3_clk : i_clk0_counter == "c4" ? c4_clk : i_clk0_counter == "c5" ? c5_clk : i_clk0_counter == "c6" ? c6_clk : i_clk0_counter == "c7" ? c7_clk : i_clk0_counter == "c8" ? c8_clk : i_clk0_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[1] = i_clk1_counter == "c0" ? c0_clk : i_clk1_counter == "c1" ? c1_clk : i_clk1_counter == "c2" ? c2_clk : i_clk1_counter == "c3" ? c3_clk : i_clk1_counter == "c4" ? c4_clk : i_clk1_counter == "c5" ? c5_clk : i_clk1_counter == "c6" ? c6_clk : i_clk1_counter == "c7" ? c7_clk : i_clk1_counter == "c8" ? c8_clk : i_clk1_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[2] = i_clk2_counter == "c0" ? c0_clk : i_clk2_counter == "c1" ? c1_clk : i_clk2_counter == "c2" ? c2_clk : i_clk2_counter == "c3" ? c3_clk : i_clk2_counter == "c4" ? c4_clk : i_clk2_counter == "c5" ? c5_clk : i_clk2_counter == "c6" ? c6_clk : i_clk2_counter == "c7" ? c7_clk : i_clk2_counter == "c8" ? c8_clk : i_clk2_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[3] = i_clk3_counter == "c0" ? c0_clk : i_clk3_counter == "c1" ? c1_clk : i_clk3_counter == "c2" ? c2_clk : i_clk3_counter == "c3" ? c3_clk : i_clk3_counter == "c4" ? c4_clk : i_clk3_counter == "c5" ? c5_clk : i_clk3_counter == "c6" ? c6_clk : i_clk3_counter == "c7" ? c7_clk : i_clk3_counter == "c8" ? c8_clk : i_clk3_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[4] = i_clk4_counter == "c0" ? c0_clk : i_clk4_counter == "c1" ? c1_clk : i_clk4_counter == "c2" ? c2_clk : i_clk4_counter == "c3" ? c3_clk : i_clk4_counter == "c4" ? c4_clk : i_clk4_counter == "c5" ? c5_clk : i_clk4_counter == "c6" ? c6_clk : i_clk4_counter == "c7" ? c7_clk : i_clk4_counter == "c8" ? c8_clk : i_clk4_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[5] = i_clk5_counter == "c0" ? c0_clk : i_clk5_counter == "c1" ? c1_clk : i_clk5_counter == "c2" ? c2_clk : i_clk5_counter == "c3" ? c3_clk : i_clk5_counter == "c4" ? c4_clk : i_clk5_counter == "c5" ? c5_clk : i_clk5_counter == "c6" ? c6_clk : i_clk5_counter == "c7" ? c7_clk : i_clk5_counter == "c8" ? c8_clk : i_clk5_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[6] = i_clk6_counter == "c0" ? c0_clk : i_clk6_counter == "c1" ? c1_clk : i_clk6_counter == "c2" ? c2_clk : i_clk6_counter == "c3" ? c3_clk : i_clk6_counter == "c4" ? c4_clk : i_clk6_counter == "c5" ? c5_clk : i_clk6_counter == "c6" ? c6_clk : i_clk6_counter == "c7" ? c7_clk : i_clk6_counter == "c8" ? c8_clk : i_clk6_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[7] = i_clk7_counter == "c0" ? c0_clk : i_clk7_counter == "c1" ? c1_clk : i_clk7_counter == "c2" ? c2_clk : i_clk7_counter == "c3" ? c3_clk : i_clk7_counter == "c4" ? c4_clk : i_clk7_counter == "c5" ? c5_clk : i_clk7_counter == "c6" ? c6_clk : i_clk7_counter == "c7" ? c7_clk : i_clk7_counter == "c8" ? c8_clk : i_clk7_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[8] = i_clk8_counter == "c0" ? c0_clk : i_clk8_counter == "c1" ? c1_clk : i_clk8_counter == "c2" ? c2_clk : i_clk8_counter == "c3" ? c3_clk : i_clk8_counter == "c4" ? c4_clk : i_clk8_counter == "c5" ? c5_clk : i_clk8_counter == "c6" ? c6_clk : i_clk8_counter == "c7" ? c7_clk : i_clk8_counter == "c8" ? c8_clk : i_clk8_counter == "c9" ? c9_clk : 1'b0;
    assign clk_tmp[9] = i_clk9_counter == "c0" ? c0_clk : i_clk9_counter == "c1" ? c1_clk : i_clk9_counter == "c2" ? c2_clk : i_clk9_counter == "c3" ? c3_clk : i_clk9_counter == "c4" ? c4_clk : i_clk9_counter == "c5" ? c5_clk : i_clk9_counter == "c6" ? c6_clk : i_clk9_counter == "c7" ? c7_clk : i_clk9_counter == "c8" ? c8_clk : i_clk9_counter == "c9" ? c9_clk : 1'b0;

assign clk_out_pfd[0] = (pfd_locked == 1'b1) ? clk_tmp[0] : 1'bx;
assign clk_out_pfd[1] = (pfd_locked == 1'b1) ? clk_tmp[1] : 1'bx;
assign clk_out_pfd[2] = (pfd_locked == 1'b1) ? clk_tmp[2] : 1'bx;
assign clk_out_pfd[3] = (pfd_locked == 1'b1) ? clk_tmp[3] : 1'bx;
assign clk_out_pfd[4] = (pfd_locked == 1'b1) ? clk_tmp[4] : 1'bx;
    assign clk_out_pfd[5] = (pfd_locked == 1'b1) ? clk_tmp[5] : 1'bx;
    assign clk_out_pfd[6] = (pfd_locked == 1'b1) ? clk_tmp[6] : 1'bx;
    assign clk_out_pfd[7] = (pfd_locked == 1'b1) ? clk_tmp[7] : 1'bx;
    assign clk_out_pfd[8] = (pfd_locked == 1'b1) ? clk_tmp[8] : 1'bx;
    assign clk_out_pfd[9] = (pfd_locked == 1'b1) ? clk_tmp[9] : 1'bx;

    assign clk_out[0] = (test_bypass_lock_detect == "on") ? clk_out_pfd[0] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[0] : 1'bx);
    assign clk_out[1] = (test_bypass_lock_detect == "on") ? clk_out_pfd[1] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[1] : 1'bx);
    assign clk_out[2] = (test_bypass_lock_detect == "on") ? clk_out_pfd[2] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[2] : 1'bx);
    assign clk_out[3] = (test_bypass_lock_detect == "on") ? clk_out_pfd[3] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[3] : 1'bx);
    assign clk_out[4] = (test_bypass_lock_detect == "on") ? clk_out_pfd[4] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[4] : 1'bx);
    assign clk_out[5] = (test_bypass_lock_detect == "on") ? clk_out_pfd[5] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[5] : 1'bx);
    assign clk_out[6] = (test_bypass_lock_detect == "on") ? clk_out_pfd[6] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[6] : 1'bx);
    assign clk_out[7] = (test_bypass_lock_detect == "on") ? clk_out_pfd[7] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[7] : 1'bx);
    assign clk_out[8] = (test_bypass_lock_detect == "on") ? clk_out_pfd[8] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[8] : 1'bx);
    assign clk_out[9] = (test_bypass_lock_detect == "on") ? clk_out_pfd[9] : ((areset === 1'b1 || pll_in_test_mode === 1'b1) || (locked == 1'b1 && !reconfig_err) ? clk_tmp[9] : 1'bx);

    // ACCELERATE OUTPUTS
    and (clk[0], 1'b1, clk_out[0]);
    and (clk[1], 1'b1, clk_out[1]);
    and (clk[2], 1'b1, clk_out[2]);
    and (clk[3], 1'b1, clk_out[3]);
    and (clk[4], 1'b1, clk_out[4]);
    and (clk[5], 1'b1, clk_out[5]);
    and (clk[6], 1'b1, clk_out[6]);
    and (clk[7], 1'b1, clk_out[7]);
    and (clk[8], 1'b1, clk_out[8]);
    and (clk[9], 1'b1, clk_out[9]);

    and (scandataout, 1'b1, scandata_out);
    and (scandone, 1'b1, scandone_tmp);

assign fbout = fbclk;
assign vcooverrange  = (vco_range_detector_high_bits == -1) ? 1'bz : vco_over;
assign vcounderrange = (vco_range_detector_low_bits == -1) ? 1'bz :vco_under;
assign phasedone = ~update_phase;

endmodule // stratixiv_pll
//---------------------------------------------------------------------
//
// Module Name : stratixiv_asmiblock
//
// Description : STRATIXIV ASMIBLOCK Verilog Simulation model
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixiv_asmiblock 
	(
	dclkin,
	scein,
	sdoin,
	data0in,
	oe,
	dclkout,
	sceout,
	sdoout,
	data0out
	);

input dclkin;
input scein;
input sdoin;
input data0in;
input oe;

output dclkout;
output sceout;
output sdoout;
output data0out;

parameter lpm_type = "stratixiv_asmiblock";

endmodule  // stratixiv_asmiblock
//---------------------------------------------------------------------
//
// Module Name : stratixiv_tsdblock
//
// Description : STRATIXIV TSDBLOCK Verilog Simulation model
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixiv_tsdblock 
	(
        offset,
        clk,
        ce,
        clr,
        testin,
        tsdcalo,
        tsdcaldone,
        fdbkctrlfromcore,
        compouttest,
        tsdcompout,
        offsetout
	);


input [5:0] offset;
input [7:0] testin;
input clk;
input ce;
input clr;
input fdbkctrlfromcore;
input compouttest;

output [7:0] tsdcalo;
output tsdcaldone;
output tsdcompout;
output [5:0] offsetout;

parameter poi_cal_temperature = 85;
parameter clock_divider_enable = "on";
parameter clock_divider_value = 40;
parameter sim_tsdcalo = 0;
parameter user_offset_enable = "off";
parameter lpm_type = "stratixiv_tsdblock";

endmodule  // stratixiv_tsdblock
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_rx_fifo_sync_ram
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_rx_fifo_sync_ram (
                                    clk,
                                    datain,
                                    write_reset,
                                    waddr,
                                    raddr,
                                    we,
                                    dataout
                                   );

    // INPUT PORTS
    input clk;
    input write_reset;
    input datain;
    input [2:0]  waddr;
    input [2:0]  raddr;
    input we;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES AND NETS
    reg dataout_tmp;
    reg [0:5] ram_d;
    reg [0:5] ram_q;

    wire [0:5] data_reg;

    integer i;

    initial
    begin
        dataout_tmp = 0;
        for (i=0; i<= 5; i=i+1)
            ram_q[i] <= 1'b0;
    end

    // Write port

    always @(posedge clk or posedge write_reset)
    begin
        if(write_reset == 1'b1)
        begin
            for (i=0; i<= 5; i=i+1)
                ram_q[i] <= 1'b0;
        end
        else begin
        for (i=0; i<= 5; i=i+1)
            ram_q[i] <= ram_d[i];
        end
    end

    always @(we or data_reg or ram_q)
    begin
        if(we === 1'b1)
        begin
            ram_d <= data_reg;
        end
        else begin
            ram_d <= ram_q;
        end
    end

    // Read port

    assign data_reg[0] = ( waddr == 3'b000 ) ? datain : ram_q[0];
    assign data_reg[1] = ( waddr == 3'b001 ) ? datain : ram_q[1];
    assign data_reg[2] = ( waddr == 3'b010 ) ? datain : ram_q[2];
    assign data_reg[3] = ( waddr == 3'b011 ) ? datain : ram_q[3];
    assign data_reg[4] = ( waddr == 3'b100 ) ? datain : ram_q[4];
    assign data_reg[5] = ( waddr == 3'b101 ) ? datain : ram_q[5];

    always @(ram_q or we or waddr or raddr)
    begin
        case ( raddr )
            3'b000 : dataout_tmp = ram_q[0];
            3'b001 : dataout_tmp = ram_q[1];
            3'b010 : dataout_tmp = ram_q[2];
            3'b011 : dataout_tmp = ram_q[3];
            3'b100 : dataout_tmp = ram_q[4];
            3'b101 : dataout_tmp = ram_q[5];
            default : dataout_tmp = 0;
        endcase
    end

    // set output
    assign dataout = dataout_tmp;

endmodule


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_rx_fifo
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_rx_fifo (
                           wclk,
                           rclk,
                           dparst,
                           fiforst,
                           datain,
                           dataout
                          );

    parameter channel_width = 10;

    // INPUT PORTS
    input wclk;
    input rclk;
    input dparst;
    input fiforst;
    input datain;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES AND NETS
    reg dataout_tmp;
    wire data_out;

    integer i;
    reg ram_datain;
    wire ram_dataout;

    reg   [2:0]  wrPtr,rdPtr;        // writer pointer, read pointer
    wire  [2:0]  rdAddr;             // read address
    reg ram_we;

    reg wclk_last_value, rclk_last_value;
    reg write_side_sync_reset;
    reg read_side_sync_reset;


    specify
        (posedge rclk => (dataout +: data_out)) = (0, 0);
        (posedge dparst => (dataout +: data_out)) = (0, 0);
    endspecify

    initial
    begin
        dataout_tmp = 0;
        wrPtr = 2'b00;
        rdPtr = 2'b11;
        write_side_sync_reset = 1'b0;
        read_side_sync_reset = 1'b0;
    end

    assign rdAddr = rdPtr;

    stratixiv_lvds_rx_fifo_sync_ram  s_fifo_ram (
                                             .clk(wclk),
                                             .datain(ram_datain),
                                             .write_reset(write_side_sync_reset),
                                             .waddr(wrPtr),
                                             .raddr(rdAddr), // rdPtr ??
                                             .we(ram_we),
                                             .dataout(ram_dataout)
                                            );

    // update pointer and RAM input

always @(wclk or dparst)
    begin
        if (dparst === 1'b1 || (fiforst === 1'b1 && wclk === 1'b1 && wclk_last_value === 1'b0))
            begin
                write_side_sync_reset <= 1'b1;
                ram_datain <= 1'b0;
                wrPtr <= 0;
                ram_we <= 'b0;
            end
        else if (dparst === 1'b0 && (fiforst === 1'b0 && wclk === 1'b1 && wclk_last_value === 1'b0))
            begin
                write_side_sync_reset <= 1'b0;
            end
            if (wclk === 1'b1 && wclk_last_value === 1'b0 && write_side_sync_reset === 1'b0 && fiforst === 1'b0 && dparst === 1'b0)
                begin
                    ram_datain <= datain;       // input register
                    ram_we <= 'b1;
                    wrPtr <= wrPtr + 1;
                    if (wrPtr == 5)
                        wrPtr <= 0;
                end
        wclk_last_value = wclk;
    end

always @(rclk or dparst)
    begin
        if (dparst === 1'b1 || (fiforst === 1'b1 && rclk === 1'b1 && rclk_last_value === 1'b0))
            begin
                read_side_sync_reset <= 1'b1;
                rdPtr <= 3;
                dataout_tmp <= 0;
            end
        else if (dparst === 1'b0 && (fiforst === 1'b0 && rclk === 1'b1 && rclk_last_value === 1'b0))
            begin
                read_side_sync_reset <= 0;
            end
        if (rclk === 1'b1 && rclk_last_value === 1'b0 && read_side_sync_reset === 1'b0 && fiforst === 1'b0 && dparst === 1'b0)
            begin
                rdPtr <= rdPtr + 1;
                if (rdPtr == 5)
                    rdPtr <= 0;
                dataout_tmp <= ram_dataout;     // output register
            end
        rclk_last_value = rclk;
    end

assign data_out = dataout_tmp;

buf (dataout, data_out);

endmodule // stratixiv_lvds_rx_fifo


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_rx_bitslip
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_rx_bitslip (
                              clk0,
                              bslipcntl,
                              bsliprst,
                              datain,
                              bslipmax,
                              dataout
                            );

    parameter channel_width = 10;
    parameter bitslip_rollover = 12;
    parameter x_on_bitslip = "on";

    // INPUT PORTS
    input  clk0;
    input  bslipcntl;
    input  bsliprst;
    input  datain;

    // OUTPUT PORTS
    output bslipmax;
    output dataout;

    // INTERNAL VARIABLES AND NETS
    integer slip_count;
    integer i, j;

    wire dataout_tmp;
    wire dataout_wire;
    wire bslipmax_wire;

    reg clk0_last_value;
    reg bsliprst_last_value;
    reg bslipcntl_last_value;
    reg start_corrupt_bits;
    reg [1:0] num_corrupt_bits;

    reg [11:0] bitslip_arr;
    reg bslipmax_tmp;
    reg ix_on_bitslip;


    wire bslipcntl_reg;

    // TIMING PATHS
    specify
        (posedge clk0 => (bslipmax +: bslipmax_tmp)) = (0, 0);
        (posedge bsliprst => (bslipmax +: bslipmax_tmp)) = (0, 0);
    endspecify

    initial
    begin
        slip_count = 0;
        bslipmax_tmp = 0;
        bitslip_arr = 12'b0;
        start_corrupt_bits = 0;
        num_corrupt_bits = 0;
        if (x_on_bitslip == "on")
            ix_on_bitslip = 1;
        else
            ix_on_bitslip = 0;
    end

    stratixiv_lvds_reg bslipcntlreg (
                                .d(bslipcntl),
                                .clk(clk0),
                                .ena(1'b1),
                                .clrn(!bsliprst),
                                .prn(1'b1),
                                .q(bslipcntl_reg)
                                 );

    // 4-bit slip counter
always @(bslipcntl_reg or bsliprst)
    begin
        if (bsliprst === 1'b1)
             begin
                 slip_count <= 0;
                 bslipmax_tmp <= 1'b0;
                 if (bsliprst === 1'b1 && bsliprst_last_value === 1'b0)
                     begin
                         $display("Note: Bit Slip Circuit was reset. Serial Data stream will have 0 latency");
                         $display("Time: %0t, Instance: %m", $time);
                     end
             end
        else if (bslipcntl_reg === 1'b1 && bslipcntl_last_value === 1'b0)
            begin
                 if (ix_on_bitslip == 1)
                     start_corrupt_bits <= 1;
                 num_corrupt_bits <= 0;
                 if (slip_count == bitslip_rollover)
                     begin
                         $display("Note: Rollover occurred on Bit Slip circuit. Serial data stream will have 0 latency.");
                         $display("Time: %0t, Instance: %m", $time);
                         slip_count <= 0;
                         bslipmax_tmp <= 1'b0;
                     end
                 else
                    begin
                        slip_count <= slip_count + 1;
                        if ((slip_count+1) == bitslip_rollover)
                            begin
                                $display("Note: The Bit Slip circuit has reached the maximum Bit Slip limit. Rollover will occur on the next slip.");
                                $display("Time: %0t, Instance: %m", $time);
                                bslipmax_tmp <= 1'b1;
                            end
                    end
            end
        else if (bslipcntl_reg === 1'b0 && bslipcntl_last_value === 1'b1)
            begin
                start_corrupt_bits <= 0;
                num_corrupt_bits <= 0;
            end

        bslipcntl_last_value <= bslipcntl_reg;
        bsliprst_last_value <= bsliprst;
    end

    // Bit Slip shift register
always @(clk0)
    begin
        if (clk0 === 1'b1 && clk0_last_value === 1'b0)
            begin
                bitslip_arr[0] <= datain;
                for (i = 0; i < bitslip_rollover; i=i+1)
                    bitslip_arr[i+1] <= bitslip_arr[i];

                if (start_corrupt_bits == 1'b1)
                    num_corrupt_bits <= num_corrupt_bits + 1;
                if (num_corrupt_bits+1 == 3)
                    start_corrupt_bits <= 0;
            end

        clk0_last_value <= clk0;
    end

stratixiv_lvds_reg dataoutreg (
                            .d(bitslip_arr[slip_count]),
                            .clk(clk0),
                            .ena(1'b1),
                            .clrn(1'b1),
                            .prn(1'b1),
                            .q(dataout_tmp)
                        );

assign dataout_wire = (start_corrupt_bits == 1'b0) ? dataout_tmp : (num_corrupt_bits < 3) ? 1'bx : dataout_tmp;
assign bslipmax_wire = bslipmax_tmp;

and (dataout, dataout_wire, 1'b1);
and (bslipmax, bslipmax_wire, 1'b1);

endmodule // stratixiv_lvds_rx_bitslip

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_rx_deser
//
// Description : Timing simulation model for the stratixiv LVDS RECEIVER
//               Deserializer. This module receives serial data and outputs
//               parallel data word of width = channel_width
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_rx_deser (
                            clk,
                            datain,
                            devclrn,
                            devpor,
                            dataout
                          );

    parameter channel_width = 10;

    // INPUT PORTS
    input clk;
    input datain;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [channel_width - 1:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg [channel_width - 1:0] dataout_tmp;
    reg clk_last_value;
    integer i;


    specify
       (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
    endspecify

initial
    begin
        clk_last_value = 0;
        dataout_tmp = 'b0;
    end

always @(clk or devclrn or devpor)
    begin
        if (devclrn === 1'b0 || devpor === 1'b0)
            begin
                dataout_tmp <= 'b0;
            end
        else if (clk === 1'b1 && clk_last_value === 1'b0)
            begin
                for (i = (channel_width-1); i > 0; i=i-1)
                    dataout_tmp[i] <= dataout_tmp[i-1];

                dataout_tmp[0] <= datain;
            end

        clk_last_value <= clk;
    end
assign dataout = dataout_tmp;

endmodule //stratixiv_lvds_rx_deser

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_rx_parallel_reg
//
// Description : Timing simulation model for the stratixiv LVDS RECEIVER
//               PARALLEL REGISTER. The data width equals max. channel width,
//               which is 10.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixiv_lvds_rx_parallel_reg (
                                   clk,
                                   enable,
                                   datain,
                                   dataout,
                                   devclrn,
                                   devpor
                                  );

    parameter channel_width = 10;

    // INPUT PORTS
    input [channel_width - 1:0] datain;
    input clk;
    input enable;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [channel_width - 1:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg clk_last_value;
    reg [channel_width - 1:0] dataout_tmp;

    specify
       (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
    endspecify


initial
    begin
        clk_last_value = 0;
        dataout_tmp = 'b0;
    end

always @(clk or devpor or devclrn)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
            begin
                dataout_tmp <= 'b0;
            end
        else
            begin
                if ((clk === 1) && (clk_last_value !== clk))
                    begin
                        if (enable === 1)
                            begin
                                dataout_tmp <= datain;
                            end
                    end
            end
        clk_last_value <= clk;
    end //always

assign dataout = dataout_tmp;

endmodule //stratixiv_lvds_rx_parallel_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_lvds_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for registering the enable inputs.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixiv_lvds_reg (
                        q,
                        clk,
                        ena,
                        d,
                        clrn,
                        prn
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
    wire q_wire;

    // TIMING PATHS
    specify
       (posedge clk => (q +: q_tmp)) = (0, 0);
       (negedge clrn => (q +: q_tmp)) = (0, 0);
       (negedge prn => (q +: q_tmp)) = (0, 0);
    endspecify

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q_tmp = 0;

always @ (posedge clk or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q_tmp <= 1;
        else if (clrn == 1'b0)
            q_tmp <= 0;
        else if ((clk == 1) & (ena == 1'b1))
            q_tmp <= d;
    end

assign q_wire = q_tmp;
and (q, q_wire, 1'b1);

endmodule // stratixiv_lvds_reg

 ///////////////////////////////////////////////////////////////////////////////
 //
 // Module Name : stratixiv_pclk_divider
 //
 // Description : Simulation model for a clock divider
 //               output clock is divided by value specified
 //              in the parameter clk_divide_by
 //
 ///////////////////////////////////////////////////////////////////////////////
 `timescale 1 ps / 1 ps
 module stratixiv_pclk_divider (
                            clkin,
                            lloaden,
                            clkout
                          );
 parameter clk_divide_by =1;

 input clkin;
 output lloaden;
 output clkout;

 reg clkout_tmp;
 reg[4:0] cnt;
 reg start;
 reg count;
 reg lloaden_tmp;


 assign clkout = (clk_divide_by == 1) ? clkin :clkout_tmp;
 assign lloaden = lloaden_tmp;
 initial
 begin
    clkout_tmp = 1'b0;
    cnt = 5'b00000;
   start = 1'b0;
    count = 1'b0;
    lloaden_tmp = 1'b0;
 end


 always @(clkin)
    begin
         if (clkin == 1'b1 )
             begin
                 count = 1'b1;
             end
         if(count == 1'b1)
             begin
                 if(cnt < clk_divide_by)
                     begin
                         clkout_tmp = 1'b0;
                         cnt = cnt + 1'b1;
                     end
                 else
                     begin
                         if(cnt == 2*clk_divide_by -1)
                             cnt = 0;
                         else
                             begin
                                 clkout_tmp = 1'b1;
                                 cnt = cnt + 1;
                             end
                     end
             end
    end

 always@( clkin or cnt )
    begin
        if( cnt == 2*clk_divide_by -2)
            lloaden_tmp = 1'b1;
        else if(cnt == 0)
            lloaden_tmp = 1'b0;
    end

 endmodule

   ///////////////////////////////////////////////////////////////////////////////
   //
   // Module Name : stratixiv_select_ini_phase_dpaclk
   //
   // Description : Simulation model for selecting the initial phase of the dpa clock
   //
   //
   ///////////////////////////////////////////////////////////////////////////////

  module stratixiv_select_ini_phase_dpaclk(
                                        clkin,
                                        loaden,
                                        enable,
                                        clkout,
                                        loadenout
                                      );
 parameter initial_phase_select = 0;

 input clkin;
 input enable;
 input loaden;

 output clkout;
 output loadenout;
 wire clkout_tmp;
 wire loadenout_tmp;

real clk_period, last_clk_period;
real last_clkin_edge;

reg  first_clkin_edge_detect;
reg clk0_tmp;
reg clk1_tmp;
reg clk2_tmp;
reg clk3_tmp;
reg clk4_tmp;
reg clk5_tmp;
reg clk6_tmp;
reg clk7_tmp;
reg loaden0_tmp;
reg loaden1_tmp;
reg loaden2_tmp;
reg loaden3_tmp;
reg loaden4_tmp;
reg loaden5_tmp;
reg loaden6_tmp;
reg loaden7_tmp;

assign clkout_tmp = (initial_phase_select == 1) ? clk1_tmp :
                    (initial_phase_select == 2) ? clk2_tmp :
                    (initial_phase_select == 3) ? clk3_tmp :
                    (initial_phase_select == 4) ? clk4_tmp :
                    (initial_phase_select == 5) ? clk5_tmp :
                    (initial_phase_select == 6) ? clk6_tmp :
                    (initial_phase_select == 7) ? clk7_tmp :
                    clk0_tmp;
assign loadenout_tmp = (initial_phase_select == 1) ? loaden1_tmp :
                    (initial_phase_select == 2) ? loaden2_tmp :
                    (initial_phase_select == 3) ? loaden3_tmp :
                    (initial_phase_select == 4) ? loaden4_tmp :
                    (initial_phase_select == 5) ? loaden5_tmp :
                    (initial_phase_select == 6) ? loaden6_tmp :
                    (initial_phase_select == 7) ? loaden7_tmp :
                    loaden0_tmp;


assign clkout = (enable == 1'b1) ? clkout_tmp : clkin;
assign loadenout = (enable == 1'b1) ? loadenout_tmp : loaden;

 initial
    begin
        first_clkin_edge_detect = 1'b0;
    end


always @(posedge clkin)
begin
// Determine the clock frequency
    if (first_clkin_edge_detect == 1'b0)
        begin
            first_clkin_edge_detect = 1'b1;
        end
    else
        begin
            last_clk_period = clk_period;
            clk_period = $realtime - last_clkin_edge;
        end
    last_clkin_edge = $realtime;

end

    //assign phase shifted clock and data values
always@(clkin)
    begin
        clk0_tmp <= clkin;
        clk1_tmp <= #(clk_period * 0.125) clkin;
        clk2_tmp <= #(clk_period * 0.25) clkin;
        clk3_tmp <= #(clk_period * 0.375) clkin;
        clk4_tmp <= #(clk_period * 0.5) clkin;
        clk5_tmp <= #(clk_period * 0.625) clkin;
        clk6_tmp <= #(clk_period * 0.75) clkin;
        clk7_tmp <= #(clk_period * 0.875) clkin;
    end

always@(loaden)
    begin
        loaden0_tmp <= loaden;
        loaden1_tmp <= #(clk_period * 0.125) loaden;
        loaden2_tmp <= #(clk_period * 0.25)  loaden;
        loaden3_tmp <= #(clk_period * 0.375) loaden;
        loaden4_tmp <= #(clk_period * 0.5)  loaden;
        loaden5_tmp <= #(clk_period * 0.625) loaden;
        loaden6_tmp <= #(clk_period * 0.75) loaden;
        loaden7_tmp <= #(clk_period * 0.875) loaden;
    end

endmodule
   ///////////////////////////////////////////////////////////////////////////////
   //
   // Module Name : stratixiv_dpa_retime_block
   //
   // Description : Simulation model for generating the retimed clock,data and loaden.
   //               Each of the signals has 8 different phase shifted versions.
   //
   //
   ///////////////////////////////////////////////////////////////////////////////

  module stratixiv_dpa_retime_block(
                                clkin,
                                datain,
                                reset,
                                clk0,
                                clk1,
                                clk2,
                                clk3,
                                clk4,
                                clk5,
                                clk6,
                                clk7,
                                data0,
                                data1,
                                data2,
                                data3,
                                data4,
                                data5,
                                data6,
                                data7,
                                lock
                              );

input clkin;
input datain;
input reset;

output clk0;
output clk1;
output clk2;
output clk3;
output clk4;
output clk5;
output clk6;
output clk7;
output data0;
output data1;
output data2;
output data3;
output data4;
output data5;
output data6;
output data7;
output lock;

real clk_period, last_clk_period;
real last_clkin_edge;

reg  first_clkin_edge_detect;
reg clk0_tmp;
reg clk1_tmp;
reg clk2_tmp;
reg clk3_tmp;
reg clk4_tmp;
reg clk5_tmp;
reg clk6_tmp;
reg clk7_tmp;
reg data0_tmp;
reg data1_tmp;
reg data2_tmp;
reg data3_tmp;
reg data4_tmp;
reg data5_tmp;
reg data6_tmp;
reg data7_tmp;
reg lock_tmp;

assign clk0 = (reset == 1'b1) ? 1'b0 : clk0_tmp;
assign clk1 = (reset == 1'b1) ? 1'b0 : clk1_tmp;
assign clk2 = (reset == 1'b1) ? 1'b0 : clk2_tmp;
assign clk3 = (reset == 1'b1) ? 1'b0 : clk3_tmp;
assign clk4 = (reset == 1'b1) ? 1'b0 : clk4_tmp;
assign clk5 = (reset == 1'b1) ? 1'b0 : clk5_tmp;
assign clk6 = (reset == 1'b1) ? 1'b0 : clk6_tmp;
assign clk7 = (reset == 1'b1) ? 1'b0 : clk7_tmp;
assign data0 =(reset == 1'b1) ? 1'b0 :  data0_tmp;
assign data1 =(reset == 1'b1) ? 1'b0 :  data1_tmp;
assign data2 =(reset == 1'b1) ? 1'b0 :  data2_tmp;
assign data3 =(reset == 1'b1) ? 1'b0 :  data3_tmp;
assign data4 =(reset == 1'b1) ? 1'b0 :  data4_tmp;
assign data5 =(reset == 1'b1) ? 1'b0 :  data5_tmp;
assign data6 =(reset == 1'b1) ? 1'b0 :  data6_tmp;
assign data7 =(reset == 1'b1) ? 1'b0 :  data7_tmp;
assign lock = (reset == 1'b1) ? 1'b0 : lock_tmp;



initial
    begin
        first_clkin_edge_detect = 1'b0;
        lock_tmp = 1'b0;
    end


always @(posedge clkin)
begin
// Determine the clock frequency
    if (first_clkin_edge_detect == 1'b0)
        begin
            first_clkin_edge_detect = 1'b1;
        end
    else
        begin
            last_clk_period = clk_period;
            clk_period = $realtime - last_clkin_edge;
        end
    last_clkin_edge = $realtime;

    //assign dpa lock
    if(((clk_period ==last_clk_period) ||(clk_period == last_clk_period-1) || (clk_period ==last_clk_period +1)) && (clk_period != 0) && (last_clk_period != 0))
        lock_tmp = 1'b1;
    else
        lock_tmp = 1'b0;
end

    //assign phase shifted clock and data values
always@(clkin)
    begin
        clk0_tmp <= clkin;
        clk1_tmp <= #(clk_period * 0.125) clkin;
        clk2_tmp <= #(clk_period * 0.25) clkin;
        clk3_tmp <= #(clk_period * 0.375) clkin;
        clk4_tmp <= #(clk_period * 0.5) clkin;
        clk5_tmp <= #(clk_period * 0.625) clkin;
        clk6_tmp <= #(clk_period * 0.75) clkin;
        clk7_tmp <= #(clk_period * 0.875) clkin;
    end

always@(datain)
    begin
        data0_tmp <= datain;
        data1_tmp <= #(clk_period * 0.125) datain;
        data2_tmp <= #(clk_period * 0.25) datain;
        data3_tmp <= #(clk_period * 0.375) datain;
        data4_tmp <= #(clk_period * 0.5) datain;
        data5_tmp <= #(clk_period * 0.625) datain;
        data6_tmp <= #(clk_period * 0.75) datain;
        data7_tmp <= #(clk_period * 0.875) datain;
    end
endmodule

   ///////////////////////////////////////////////////////////////////////////////
   //
   // Module Name : stratixiv_dpa_block
   //
   // Description : Simulation model for selecting the retimed data, clock and loaden
   //               depending on the PPM varaiation and direction of shift.
   //
   ///////////////////////////////////////////////////////////////////////////////

module stratixiv_dpa_block(clkin,
                dpareset,
                dpahold,
                datain,
                clkout,
                dataout,
                dpalock
                );

parameter net_ppm_variation = 0;
parameter is_negative_ppm_drift = "off";
parameter enable_soft_cdr_mode= "on";

input clkin ;
input dpareset ;
input dpahold  ;
input datain   ;

output clkout;
output dataout;
output dpalock;

wire clk0_tmp;
wire clk1_tmp;
wire clk2_tmp;
wire clk3_tmp;
wire clk4_tmp;
wire clk5_tmp;
wire clk6_tmp;
wire clk7_tmp;
wire data0_tmp;
wire data1_tmp;
wire data2_tmp;
wire data3_tmp;
wire data4_tmp;
wire data5_tmp;
wire data6_tmp;
wire data7_tmp;

reg[2:0] select;
reg clkout_tmp ;
reg dataout_tmp;

real counter_reset_value;
integer count_value;
integer i;

initial
    begin
        if(net_ppm_variation != 0)
            begin
                counter_reset_value = 1000000/(net_ppm_variation  * 8);
                count_value =  counter_reset_value;
            end
        i =  0;
        select = 3'b000;
        clkout_tmp = clkin;
        dataout_tmp = datain;
    end


    assign dataout = (enable_soft_cdr_mode == "on") ? dataout_tmp : datain;
    assign clkout = (enable_soft_cdr_mode == "on") ?  clkout_tmp : clkin;

stratixiv_dpa_retime_block data_clock_retime(
                                        .clkin(clkin),
                                        .datain(datain),
                                        .reset(dpareset),
                                        .clk0(clk0_tmp),
                                        .clk1(clk1_tmp),
                                        .clk2(clk2_tmp),
                                        .clk3(clk3_tmp),
                                        .clk4(clk4_tmp),
                                        .clk5(clk5_tmp),
                                        .clk6(clk6_tmp),
                                        .clk7(clk7_tmp),
                                        .data0(data0_tmp),
                                        .data1(data1_tmp),
                                        .data2(data2_tmp),
                                        .data3(data3_tmp),
                                        .data4(data4_tmp),
                                        .data5(data5_tmp),
                                        .data6(data6_tmp),
                                        .data7(data7_tmp),
                                        .lock  (dpalock)
                                        );

always@(posedge clkin or posedge dpareset or posedge dpahold)
    begin
        if(net_ppm_variation == 0)
            begin
                 select = 3'b000;
            end
        else
            begin
                if(dpareset == 1'b1)
                    begin
                        i = 0;
                        select = 3'b000;
                    end
                else
                    begin
                        if(dpahold == 1'b0)
                            begin
                                if(i  < count_value)
                                    begin
                                        i = i + 1;
                                    end
                                else
                                    begin
                                        select = select + 1'b1;
                                        i = 0;
                                    end
                            end
                    end
            end
    end

always@(select or clk0_tmp or clk1_tmp or clk2_tmp or clk3_tmp or
        clk4_tmp or clk5_tmp or clk6_tmp or clk7_tmp or
        data0_tmp or data1_tmp or data2_tmp or data3_tmp or
        data4_tmp or data5_tmp or data6_tmp or data7_tmp )
    begin
        case(select)
            3'b000 :
                begin
                      clkout_tmp = clk0_tmp;
                      dataout_tmp = data0_tmp;
                end
            3'b001:
                begin
                    clkout_tmp = (is_negative_ppm_drift == "off") ? clk1_tmp : clk7_tmp    ;
                    dataout_tmp =( is_negative_ppm_drift == "off") ? data1_tmp : data7_tmp ;
                end
            3'b010:
                begin
                    clkout_tmp = (is_negative_ppm_drift == "off") ? clk2_tmp : clk6_tmp     ;
                    dataout_tmp =( is_negative_ppm_drift == "off") ? data2_tmp : data6_tmp  ;
                end
            3'b011:
                begin
                    clkout_tmp = ( is_negative_ppm_drift == "off") ? clk3_tmp : clk5_tmp    ;
                    dataout_tmp = ( is_negative_ppm_drift == "off") ? data3_tmp : data5_tmp ;
                end
            3'b100:
                begin
                    clkout_tmp = clk4_tmp    ;
                    dataout_tmp = data4_tmp ;
                end
            3'b101:
                begin
                    clkout_tmp = ( is_negative_ppm_drift == "off") ? clk5_tmp : clk3_tmp    ;
                    dataout_tmp = ( is_negative_ppm_drift == "off") ? data5_tmp : data3_tmp ;
                end
            3'b110:
                begin
                    clkout_tmp = ( is_negative_ppm_drift == "off") ? clk6_tmp : clk2_tmp    ;
                    dataout_tmp = ( is_negative_ppm_drift == "off") ? data6_tmp : data2_tmp ;
                end
            3'b111:
                begin
                    clkout_tmp = ( is_negative_ppm_drift == "off") ? clk7_tmp : clk1_tmp    ;
                    dataout_tmp = ( is_negative_ppm_drift == "off") ? data7_tmp : data1_tmp ;
                end
            default:
                begin
                      clkout_tmp = clk0_tmp;
                      dataout_tmp = data0_tmp;
                end
        endcase
    end

  endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_LVDS_RECEIVER
//
// Description : Timing simulation model for the stratixiv LVDS RECEIVER
//               atom. This module instantiates the following sub-modules :
//               1) stratixiv_lvds_rx_fifo
//               2) stratixiv_lvds_rx_bitslip
//               3) DFFEs for the LOADEN signals
//               4) stratixiv_lvds_rx_deser
//               5) stratixiv_lvds_rx_parallel_reg
//               6) stratixiv_select_ini_phase_dpaclk
//               7)stratixiv_dpa_block
//               8) stratixiv_pclk_divider
//
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixiv_lvds_receiver (
                            clk0,
                            datain,
                            enable0,
                            dpareset,
                            dpahold,
                            dpaswitch,
                            fiforeset,
                            bitslip,
                            bitslipreset,
                            serialfbk,
                            dataout,
                            dpalock,
                            bitslipmax,
                            serialdataout,
                            postdpaserialdataout,
                            divfwdclk,
                            dpaclkout,
                            devclrn,
                            devpor
                           );

    parameter data_align_rollover       = 2;
    parameter enable_dpa                = "off";
    parameter lose_lock_on_one_change   = "off";
    parameter reset_fifo_at_first_lock  = "on";
    parameter align_to_rising_edge_only = "on";
    parameter use_serial_feedback_input = "off";
    parameter dpa_debug                 = "off";
    parameter x_on_bitslip              = "on";
    parameter enable_soft_cdr           = "off";
    parameter dpa_output_clock_phase_shift   = 0;
    parameter enable_dpa_initial_phase_selection = "off";
    parameter dpa_initial_phase_value    = 0;
    parameter  enable_dpa_align_to_rising_edge_only  = "off";
    parameter  net_ppm_variation     = 0;
    parameter  is_negative_ppm_drift  = "off";
    parameter  rx_input_path_delay_engineering_bits  = 2;
    parameter lpm_type                  = "stratixiv_lvds_receiver";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter channel_width             = 10;

// SIMULATION_ONLY_PARAMETERS_END


    // INPUT PORTS
    input clk0;
    input datain;
    input enable0;
    input dpareset;
    input dpahold;
    input dpaswitch;
    input fiforeset;
    input bitslip;
    input bitslipreset;
    input serialfbk;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [channel_width - 1:0] dataout;
    output dpalock;
    output bitslipmax;
    output serialdataout;
    output postdpaserialdataout;
   output divfwdclk;
   output dpaclkout;

    tri1 devclrn;
    tri1 devpor;


    // Input registers
    wire in_reg_data;
 reg in_reg_data_dly;
    wire datain_reg;
    wire datain_reg_neg;
    wire datain_reg_tmp;

    // dpa phase select
    wire  ini_phase_select_enable;
    wire ini_dpa_clk;
    wire ini_dpa_load;

    // dpa circuit
   wire  dpareg0_out;
   wire dpareg1_out;
    wire dpa_clk_shift;
    wire dpa_data_shift;
    wire dpa_enable0_shift;
    wire dpa_clk;
    wire dpa_rst;
    wire lock_tmp;

    // fifo
    wire fifo_wclk;
    wire fifo_rclk;
    wire fifo_datain;
    wire fifo_dataout;
    wire fifo_reset;
    reg reset_fifo;

    // bitslip
    wire slip_datain;
    wire slip_dataout;
    wire bitslip_reset;
    wire slip_datain_tmp;
    wire s_bitslip_clk;

    //deserializer
    wire [channel_width - 1:0] deser_dataout;
    wire postdpaserialdataout_tmp;
    wire dpalock_tmp;
    wire rxload;
    wire loaden;
    wire lloaden;
    wire divfwdclk_tmp;

    wire gnd;
    integer i;

    // TIMING PATHS
    specify
        (posedge clk0 => (dpalock +: dpalock_tmp)) = (0, 0);
    endspecify

    assign gnd = 1'b0;

    initial
    begin
        if (reset_fifo_at_first_lock == "on")
            reset_fifo = 1;
        else
            reset_fifo = 0;
    end

    // reset_fifo at
    always @(lock_tmp)
        begin
        reset_fifo = !lock_tmp;
        end

   always @(in_reg_data)
   begin
   if( dpaswitch == 1'b1)
   begin
   	if(rx_input_path_delay_engineering_bits == 1 )
   		in_reg_data_dly <=  #60 in_reg_data ;
   	else if ( rx_input_path_delay_engineering_bits == 2) 
       	in_reg_data_dly <= #120 in_reg_data;
   	else if (  rx_input_path_delay_engineering_bits == 3)
        	 in_reg_data_dly <= #180 in_reg_data;
   	else
   	   	in_reg_data_dly <= in_reg_data;
    end
    else
    	    in_reg_data_dly <= in_reg_data;
    end


    // input register in non-DPA mode for sampling incoming data
    stratixiv_lvds_reg in_reg (
                          .d(in_reg_data_dly),
                            .clk(clk0),
                            .ena(1'b1),
                            .clrn(devclrn || devpor),
                            .prn(1'b1),
                            .q(datain_reg)
                        );
   assign in_reg_data = (use_serial_feedback_input == "on") ? serialfbk : datain;


   stratixiv_lvds_reg neg_reg (
                          .d(in_reg_data_dly),
                            .clk(!clk0),
                            .ena(1'b1),
                            .clrn(devclrn || devpor),
                            .prn(1'b1),
                            .q(datain_reg_neg)
                          );

   assign datain_reg_tmp = (align_to_rising_edge_only == "on") ? datain_reg :  datain_reg_neg;

    // Initial DPA clock phase select
   stratixiv_select_ini_phase_dpaclk ini_clk_phase_select(
                                                     .clkin(clk0),
                                                     .enable(ini_phase_select_enable),
                                                     .loaden(enable0),
                                                     .clkout(ini_dpa_clk),
                                                     .loadenout(ini_dpa_load)
                                                 );
 defparam  ini_clk_phase_select.initial_phase_select = dpa_initial_phase_value;

 assign   ini_phase_select_enable = (enable_dpa_initial_phase_selection == "on") ? 1'b1 : 1'b0;


     // DPA Circuitary
    stratixiv_lvds_reg dpareg0 (
                              .d(in_reg_data_dly),
                            .clk(ini_dpa_clk),
                            .clrn(1'b1),
                            .prn(1'b1),
                            .ena(1'b1),
                            .q(dpareg0_out)
                            );

    stratixiv_lvds_reg dpareg1 (
                            .d(dpareg0_out),
                            .clk(ini_dpa_clk),
                            .clrn(1'b1),
                            .prn(1'b1),
                            .ena(1'b1),
                            .q(dpareg1_out)
                            );

    stratixiv_dpa_block dpa_circuit(
                                .clkin(ini_dpa_clk),
                                .dpareset(dpa_rst),
                                .dpahold(dpahold),
                                .datain(dpareg1_out),
                                .clkout(dpa_clk_shift),
                                .dataout(dpa_data_shift),
                                .dpalock (lock_tmp)
                              );
defparam dpa_circuit.net_ppm_variation = net_ppm_variation;
defparam dpa_circuit.is_negative_ppm_drift = is_negative_ppm_drift;
defparam dpa_circuit.enable_soft_cdr_mode= enable_soft_cdr;

assign dpa_clk = ((enable_soft_cdr == "on")|| (enable_dpa == "on")) ? dpa_clk_shift : 1'b0;
assign dpa_rst = ((enable_soft_cdr == "on")|| (enable_dpa == "on")) ? dpareset : 1'b0;

 // DPA clock divide and generate lloaden for soft CDR mode
 stratixiv_pclk_divider  clk_forward(
                                 .clkin(dpa_clk),
                                 .lloaden(lloaden),
                                 .clkout(divfwdclk_tmp)
                                );
 defparam clk_forward.clk_divide_by = channel_width;


// FIFO
    stratixiv_lvds_rx_fifo    s_fifo (
                                  .wclk(dpa_clk),
                                  .rclk(fifo_rclk),
                                  .fiforst(fifo_reset),
                                  .dparst(dpa_rst),
                                  .datain(fifo_datain),
                                  .dataout(fifo_dataout)
                                 );
    defparam s_fifo.channel_width = channel_width;

    assign fifo_rclk = (enable_dpa == "on") ? clk0 : gnd;
    assign fifo_wclk = dpa_clk;
    assign fifo_datain = (enable_dpa == "on") ? dpa_data_shift : gnd;
    assign fifo_reset = (!devpor) || (!devclrn) || fiforeset || reset_fifo || dpa_rst;

// BIT SLIP
    stratixiv_lvds_rx_bitslip    s_bslip (
                                      .clk0(s_bitslip_clk),
                                      .bslipcntl(bitslip),
                                      .bsliprst(bitslip_reset),
                                      .datain(slip_datain),
                                      .bslipmax(bitslipmax),
                                      .dataout(slip_dataout)
                                     );
    defparam s_bslip.channel_width = channel_width;
    defparam s_bslip.bitslip_rollover = data_align_rollover;
    defparam s_bslip.x_on_bitslip = x_on_bitslip;

    assign bitslip_reset = (!devpor) || (!devclrn) || bitslipreset;
    assign slip_datain_tmp = (enable_dpa == "on") ? fifo_dataout : datain_reg_tmp;
    assign slip_datain = (enable_soft_cdr == "on") ? dpa_data_shift : slip_datain_tmp;
    assign s_bitslip_clk = (enable_soft_cdr == "on") ? dpa_clk : clk0;

    // DESERIALISER
    stratixiv_lvds_reg rxload_reg (
                                .d(loaden),
                                .clk(s_bitslip_clk),
                                .ena(1'b1),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .q(rxload)
                              );
    assign loaden = (enable_soft_cdr == "on") ? lloaden : ini_dpa_load;


    stratixiv_lvds_rx_deser    s_deser (
                                    .clk(s_bitslip_clk),
                                    .datain(slip_dataout),
                                    .devclrn(devclrn),
                                    .devpor(devpor),
                                    .dataout(deser_dataout)
                                   );
    defparam s_deser.channel_width = channel_width;

    stratixiv_lvds_rx_parallel_reg  output_reg  (
                                             .clk(s_bitslip_clk),
                                             .enable(rxload),
                                             .datain(deser_dataout),
                                             .devpor(devpor),
                                             .devclrn(devclrn),
                                             .dataout(dataout)
                                            );
    defparam output_reg.channel_width = channel_width;


    // generate outputs
    assign dpalock_tmp = gnd;

    assign postdpaserialdataout_tmp = dpa_data_shift;
    assign divfwdclk = divfwdclk_tmp;
    assign dpaclkout = dpa_clk_shift;
    and (postdpaserialdataout, postdpaserialdataout_tmp, 1'b1);
    and (serialdataout, datain, 1'b1);
    and (dpalock, dpalock_tmp, 1'b1);

endmodule // stratixiv_lvds_receiver
//////////////////////////////////////////////////////////////////////////////////
//Module Name:                    stratixiv_pseudo_diff_out                          //
//Description:                    Simulation model for STRATIXIV Pseudo Differential //
//                                Output Buffer                                  //
//////////////////////////////////////////////////////////////////////////////////

module stratixiv_pseudo_diff_out(
                             i,
                             o,
                             obar
                             );
parameter lpm_type = "stratixiv_pseudo_diff_out";

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

// -----------------------------------------------------------
//
// Module Name : stratixiv_bias_logic
//
// Description : STRATIXIV Bias Block's Logic Block
//               Verilog simulation model
//
// -----------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_bias_logic (
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

endmodule // stratixiv_bias_logic

// -----------------------------------------------------------
//
// Module Name : stratixiv_bias_generator
//
// Description : STRATIXIV Bias Generator Verilog simulation model
//
// -----------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_bias_generator (
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

endmodule // stratixiv_bias_generator

// -----------------------------------------------------------
//
// Module Name : stratixiv_bias_block
//
// Description : STRATIXIV Bias Block Verilog simulation model
//
// -----------------------------------------------------------

`timescale 1 ps/1 ps

module stratixiv_bias_block(
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
    
parameter lpm_type = "stratixiv_bias_block";
    
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

stratixiv_bias_logic logic_block (
                             .clk(clk),
                             .shiftnld(shiftnld),
                             .captnupdt(captnupdt),
                             .mainclk(mainclk_wire),
                             .updateclk(updateclk_wire),
                             .capture(capture_wire),
                             .update(update_wire)
                             );

stratixiv_bias_generator bias_generator (
                                    .din(din),
                                    .mainclk(mainclk_wire),
                                    .updateclk(updateclk_wire),
                                    .capture(capture_wire),
                                    .update(update_wire),
                                    .dout(dout_tmp) 
                                    );

and (dout, dout_tmp, 1'b1);

endmodule // stratixiv_bias_block


`ifdef MODEL_TECH
`mti_v2k_int_delays_off

`endif
