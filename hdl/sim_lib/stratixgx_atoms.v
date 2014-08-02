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

// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

primitive STRATIXGX_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
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

primitive STRATIXGX_PRIM_DFFEAS (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

primitive STRATIXGX_PRIM_DFFEAS_HIGH (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

module stratixgx_dffe ( Q, CLK, ENA, D, CLRN, PRN );
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
   
   STRATIXGX_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
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


// ***** stratixgx_mux21

module stratixgx_mux21 (MO, A, B, S);
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

// ***** stratixgx_mux41

module stratixgx_mux41 (MO, IN0, IN1, IN2, IN3, S);
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

// ***** stratixgx_and1

module stratixgx_and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** stratixgx_and16

module stratixgx_and16 (Y, IN1);
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

// ***** stratixgx_bmux21

module stratixgx_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixgx_b17mux21

module stratixgx_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixgx_nmux21

module stratixgx_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** stratixgx_b5mux21

module stratixgx_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********



///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_asynch_lcell
//
// Description : Verilog simulation model for asynchronous LUT based
//               module in Stratixgx Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_asynch_lcell (
                             dataa, 
                             datab, 
                             datac, 
                             datad,
                             cin,
                             cin0,
                             cin1,
                             inverta,
                             qfbkin,
                             regin,
                             combout,
                             cout,
                             cout0,
                             cout1
                            );
   
    parameter operation_mode = "normal" ;
    parameter sum_lutc_input = "datac";
    parameter lut_mask = "ffff" ;
    parameter cin_used = "false";
    parameter cin0_used = "false";
    parameter cin1_used = "false";
       
    // INPUT PORTS
    input dataa;
    input datab;
    input datac;
    input datad ;
    input cin;
    input cin0;
    input cin1;
    input inverta;
    input qfbkin;
    
    // OUTPUT PORTS
    output combout;
    output cout;
    output cout0;
    output cout1;
    output regin;
    
    // INTERNAL VARIABLES
    reg icout;
    reg icout0;
    reg icout1;
    reg data;
    reg lut_data;
    reg inverta_dataa;
    reg [15:0] bin_mask;
    
    integer iop_mode;
    reg [1:0] isum_lutc_input;
    reg icin_used;
    reg icin0_used;
    reg icin1_used;
       
    wire qfbk_mode;
    
    // INPUT BUFFERS
    wire idataa;
    wire idatab;
    wire idatac;
    wire idatad;
    wire icin;
    wire icin0;
    wire icin1;
    wire iinverta;
       
    buf (idataa, dataa);
    buf (idatab, datab);
    buf (idatac, datac);
    buf (idatad, datad);
    buf (icin, cin);
    buf (icin0, cin0);
    buf (icin1, cin1);
    buf (iinverta, inverta);
       
    assign qfbk_mode = (sum_lutc_input == "qfbk") ? 1'b1 : 1'b0;

    specify
      
        (dataa => combout) = (0, 0) ;
        (datab => combout) = (0, 0) ;
        (datac => combout) = (0, 0) ;
        (datad => combout) = (0, 0) ;
        (cin => combout) = (0, 0) ;
        (cin0 => combout) = (0, 0) ;
        (cin1 => combout) = (0, 0) ;
        (inverta => combout) = (0, 0) ;
        if (qfbk_mode == 1'b1)
            (qfbkin => combout) = (0, 0) ;
              
        (dataa => cout) = (0, 0);
        (datab => cout) = (0, 0);
        (cin => cout) = (0, 0) ;
        (cin0 => cout) = (0, 0) ;
        (cin1 => cout) = (0, 0) ;
        (inverta => cout) = (0, 0);
              
        (dataa => cout0) = (0, 0);
        (datab => cout0) = (0, 0);
        (cin0 => cout0) = (0, 0) ;
        (inverta => cout0) = (0, 0);
              
        (dataa => cout1) = (0, 0);
        (datab => cout1) = (0, 0);
        (cin1 => cout1) = (0, 0) ;
        (inverta => cout1) = (0, 0);
              
        (dataa => regin) = (0, 0) ;
        (datab => regin) = (0, 0) ;
        (datac => regin) = (0, 0) ;
        (datad => regin) = (0, 0) ;
        (cin => regin) = (0, 0) ;
        (cin0 => regin) = (0, 0) ;
        (cin1 => regin) = (0, 0) ;
        (inverta => regin) = (0, 0) ;
        if (qfbk_mode == 1'b1)
            (qfbkin => regin) = (0, 0) ;
    endspecify
   
    function [16:1] str_to_bin ;
        input [8*4:1] s;
        reg [8*4:1] reg_s;
        reg [4:1] digit [8:1];
        reg [8:1] tmp;
        integer m;
        integer ivalue ;
        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=4; m= m+1 )
            begin
                tmp = reg_s[32:25];
                digit[m] = tmp & 8'b00001111;
                reg_s = reg_s << 8;
                if (tmp[7] == 'b1)
                    digit[m] = digit[m] + 9;
            end
            str_to_bin = {digit[1], digit[2], digit[3], digit[4]};
        end   
    endfunction
   
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
        bin_mask = str_to_bin(lut_mask);

        if (operation_mode == "normal") 
            iop_mode = 0;	// normal mode
        else if (operation_mode == "arithmetic") 
            iop_mode = 1;	// arithmetic mode
        else
        begin
            $display ("Error: Invalid operation_mode specified\n");
            $display ("Time: %0t  Instance: %m", $time);
            iop_mode = 2;
        end

        if (sum_lutc_input == "datac") 
            isum_lutc_input = 0;
        else if (sum_lutc_input == "cin") 
            isum_lutc_input = 1;
        else if (sum_lutc_input == "qfbk") 
            isum_lutc_input = 2;
        else
        begin
            $display ("Error: Invalid sum_lutc_input specified\n");
            $display ("Time: %0t  Instance: %m", $time);
            isum_lutc_input = 3;
        end
        
        if (cin_used == "true") 
            icin_used = 1;
        else if (cin_used == "false") 
            icin_used = 0;
        
        if (cin0_used == "true") 
            icin0_used = 1;
        else if (cin0_used == "false") 
            icin0_used = 0;
        
        if (cin1_used == "true") 
            icin1_used = 1;
        else if (cin1_used == "false") 
            icin1_used = 0;

    end

    always @(idatad or idatac or idatab or idataa or icin or 
             icin0 or icin1 or iinverta or qfbkin)
    begin
	
        if (iinverta === 'b1) //invert dataa
            inverta_dataa = !idataa;
        else
            inverta_dataa = idataa;
    	
        if (iop_mode == 0) // normal mode
        begin
            if (isum_lutc_input == 0) // datac 
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            idatac, idatad);
            end
            else if (isum_lutc_input == 1) // cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                begin
                    if (icin_used == 1)
                        data = (icin === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                idatad) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                idatad);
                    else   // if cin is not used then inverta 
                           // should be used in place of cin
                        data = (iinverta === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                idatad) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                idatad);
                    end
                else
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                icin, idatad);
            end
            else if(isum_lutc_input == 2) // qfbk
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            qfbkin, idatad);
            end
        end
        else if (iop_mode == 1) // arithmetic mode
        begin
            // sum LUT
            if (isum_lutc_input == 0) // datac 
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            idatac, 'b1);
            end
            else if (isum_lutc_input == 1) // cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                begin
                    if (icin_used == 1)
                        data = (icin === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                'b1) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                'b1);
                    else   // if cin is not used then inverta 
                           // should be used in place of cin
                        data = (iinverta === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                'b1) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                'b1);
                end
                else if (icin_used == 1)
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                icin, 'b1);
                else  // cin is not used, inverta is used as cin
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                iinverta, 'b1);
            end
            else if(isum_lutc_input == 2) // qfbk
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            qfbkin, 'b1);
            end
            	 
            // carry LUT
            icout0 = lut4(bin_mask, inverta_dataa, idatab, icin0, 'b0);
            icout1 = lut4(bin_mask, inverta_dataa, idatab, icin1, 'b0);
            	 
            if (icin_used == 1)
            begin
                if (icin0_used == 1 || icin1_used == 1)
                    icout = (icin === 'b0) ? icout0 : icout1;
                else
                    icout = lut4(bin_mask, inverta_dataa, idatab, 
                                 icin, 'b0);
            end
            else  // inverta is used in place of cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                    icout = (iinverta === 'b0) ? icout0 : icout1; 
                else
                    icout = lut4(bin_mask, inverta_dataa, idatab, 
                                 iinverta, 'b0);
            end
        end
    end

    and (combout, data, 1'b1) ;
    and (cout, icout, 1'b1) ;
    and (cout0, icout0, 1'b1) ;
    and (cout1, icout1, 1'b1) ;
    and (regin, data, 1'b1) ;
   
endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lcell_register
//
// Description : Verilog simulation model for register with control
//               signals module in Stratixgx Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  
module stratixgx_lcell_register (
                               clk, 
                               aclr, 
                               aload, 
                               sclr, 
                               sload, 
                               ena, 
                               datain,
                               datac, 
                               regcascin, 
                               devclrn, 
                               devpor, 
                               regout, 
                               qfbkout
                              );

    parameter synch_mode = "off";
    parameter register_cascade_mode = "off";
    parameter power_up = "low";
    parameter x_on_violation = "on";
       
    // INPUT PORTS
    input clk;
    input ena;
    input aclr;
    input aload;
    input sclr;
    input sload;
    input datain;
    input datac;
    input regcascin;
    input devclrn;
    input devpor ;
    
    // OUTPUT PORTS
    output regout;
    output qfbkout;
    
    // INTERNAL VARIABLES
    reg iregout;
    wire reset;
    wire nosload;
       
    reg regcascin_viol;
    reg datain_viol, datac_viol;
    reg sclr_viol, sload_viol;
    reg ena_viol, clk_per_viol;
    reg violation;
    reg clk_last_value;
       
    reg ipower_up;
    reg icascade_mode;
    reg isynch_mode;
    reg ix_on_violation;
    
    // INPUT BUFFERS
    wire clk_in;
    wire iaclr;
    wire iaload;
    wire isclr;
    wire isload;
    wire iena;
    wire idatac;
    wire iregcascin;
    wire idatain;
   
    buf (clk_in, clk);
    buf (iaclr, aclr);
    buf (iaload, aload);
    buf (isclr, sclr);
    buf (isload, sload);
    buf (iena, ena);
       
    buf (idatac, datac);
    buf (iregcascin, regcascin);
    buf (idatain, datain);
   
    assign reset = devpor && devclrn && (!iaclr) && (iena);
    assign nosload = reset && (!isload);
   
    specify
        $setuphold (posedge clk &&& reset, regcascin, 0, 0, regcascin_viol) ;
        $setuphold (posedge clk &&& nosload, datain, 0, 0, datain_viol) ;
        $setuphold (posedge clk &&& reset, datac, 0, 0, datac_viol) ;
        $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
        $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
        $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
        
        (posedge clk => (regout +: iregout)) = 0 ;
        (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
        (posedge aload => (regout +: iregout)) = (0, 0) ;
        (datac => regout) = (0, 0) ;
        (posedge clk => (qfbkout +: iregout)) = 0 ;
        (posedge aclr => (qfbkout +: 1'b0)) = (0, 0) ;
        (posedge aload => (qfbkout +: iregout)) = (0, 0) ;
        (datac => qfbkout) = (0, 0) ;
    
    endspecify
   
    initial
    begin
        violation = 0;
        clk_last_value = 'b0;
        if (power_up == "low")
        begin
            iregout <= 'b0;
            ipower_up = 0;
        end
        else if (power_up == "high")
        begin
            iregout <= 'b1;
            ipower_up = 1;
        end

        if (register_cascade_mode == "on")
            icascade_mode = 1;
        else
            icascade_mode = 0;

        if (synch_mode == "on" )
            isynch_mode = 1;
        else
            isynch_mode = 0;

        if (x_on_violation == "on")
            ix_on_violation = 1;
        else
            ix_on_violation = 0;
    end
   
    always @ (regcascin_viol or datain_viol or datac_viol or sclr_viol 
              or sload_viol or ena_viol or clk_per_viol)
    begin
        if (ix_on_violation == 1)
            violation = 1;
    end
   
    always @ (clk_in or idatac or iaclr or posedge iaload 
              or devclrn or devpor or posedge violation)
    begin
        if (violation == 1'b1)
        begin
            violation = 0;
            iregout <= 'bx;
        end
        else
        begin
            if (devpor == 'b0)
            begin
                if (ipower_up == 0) // "low"
                    iregout <= 'b0;
                else if (ipower_up == 1) // "high"
                    iregout <= 'b1;
            end
            else if (devclrn == 'b0)
                iregout <= 'b0;
            else if (iaclr === 'b1) 
                iregout <= 'b0 ;
            else if (iaload === 'b1) 
                iregout <= idatac;
            else if (iena === 'b1 && clk_in === 'b1 && 
                     clk_last_value === 'b0)
            begin
                if (isynch_mode == 1)
                begin
                    if (isclr === 'b1)
                        iregout <= 'b0 ;
                    else if (isload === 'b1)
                        iregout <= idatac;
                    else if (icascade_mode == 1)
                        iregout <= iregcascin;
                    else
                        iregout <= idatain;
                end
                else if (icascade_mode == 1)
                    iregout <= iregcascin;
                else 
                    iregout <= idatain;
            end
        end
        clk_last_value = clk_in;
    end
       
    and (regout, iregout, 1'b1);
    and (qfbkout, iregout, 1'b1);
   
endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lcell
//
// Description : Verilog simulation model for Stratixgx Lcell, including
//               the following sub module(s):
//               1. stratixgx_asynch_lcell
//               2. stratixgx_lcell_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lcell (
                      clk, 
                      dataa, 
                      datab, 
                      datac, 
                      datad, 
                      aclr, 
                      aload, 
                      sclr,
                      sload,
                      ena,
                      cin,
                      cin0,
                      cin1,
                      inverta,
                      regcascin,
                      devclrn,
                      devpor,
                      combout,
                      regout,
                      cout, 
                      cout0,
                      cout1
                     );

    parameter operation_mode = "normal" ;
    parameter synch_mode = "off";
    parameter register_cascade_mode = "off";
    parameter sum_lutc_input = "datac";
    parameter lut_mask = "ffff" ;
    parameter power_up = "low";
    parameter cin_used = "false";
    parameter cin0_used = "false";
    parameter cin1_used = "false";
    parameter output_mode = "reg_and_comb";
    parameter lpm_type = "stratixgx_lcell";
    parameter x_on_violation = "on";
       
    // INPUT PORTS
    input dataa;
    input datab;
    input datac;
    input datad;
    input clk; 
    input aclr; 
    input aload; 
    input sclr; 
    input sload; 
    input ena; 
    input cin;
    input cin0;
    input cin1;
    input inverta;
    input regcascin;
    input devclrn;
    input devpor ;
    
    // OUTPUT PORTS
    output combout;
    output regout;
    output cout;
    output cout0;
    output cout1;
    
    tri1 devclrn;
    tri1 devpor;

    
    // INTERNAL VARIABLES
    wire dffin, qfbkin;
   
    stratixgx_asynch_lcell lecomb (
                                 .dataa(dataa),
                                 .datab(datab), 
                                 .datac(datac),
                                 .datad(datad),
                                 .cin(cin),
                                 .cin0(cin0),
                                 .cin1(cin1), 
                                 .inverta(inverta),
                                 .qfbkin(qfbkin),
                                 .regin(dffin),
                                 .combout(combout),
                                 .cout(cout),
                                 .cout0(cout0),
                                 .cout1(cout1)
                                );
        defparam lecomb.operation_mode = operation_mode;
        defparam lecomb.sum_lutc_input = sum_lutc_input;
        defparam lecomb.cin_used = cin_used;
        defparam lecomb.cin0_used = cin0_used;
        defparam lecomb.cin1_used = cin1_used;
        defparam lecomb.lut_mask = lut_mask;
       
    stratixgx_lcell_register lereg (
                                  .clk(clk),
                                  .aclr(aclr),
                                  .aload(aload),
                                  .sclr(sclr),
                                  .sload(sload),
                                  .ena(ena), 
                                  .datain(dffin), 
                                  .datac(datac),
                                  .regcascin(regcascin),
                                  .devclrn(devclrn),
                                  .devpor(devpor), 
                                  .regout(regout),
                                  .qfbkout(qfbkin)
                                 );
        defparam lereg.synch_mode = synch_mode;
        defparam lereg.register_cascade_mode = register_cascade_mode;
        defparam lereg.power_up = power_up;
        defparam lereg.x_on_violation = x_on_violation;
   
endmodule


///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_asynch_io
//
// Description : Verilog simulation model for asynchronous 
//               module in Stratixgx IO.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_asynch_io 
    (
     datain, 
     oe, 
     regin, 
     ddioregin, 
     padio, 
     delayctrlin, 
     combout, 
     regout, 
     ddioregout,
     dqsundelayedout
     );
   
    // INPUT PORTS
    input datain;
    input oe;
    input regin;
    input ddioregin;
    input delayctrlin;

    // OUTPUT PORTS
    output combout;
    output regout;
    output ddioregout;
    output dqsundelayedout;

    // INPUT/OUTPUT PORTS
    inout  padio;
   
    parameter operation_mode = "input";
    parameter bus_hold = "false";
    parameter open_drain_output = "false";
    parameter phase_shift = "0";
    parameter input_frequency = "10000 ps";
   
    // INTERNAL VARIABLES
    reg 	     prev_value;
   
    reg 	     tmp_padio, tmp_combout;
    reg 	     buf_control;
    reg 	     combout_tmp;
   
    reg [1:0] iop_mode;
    
    integer   dqs_delay;
   
    // INPUT BUFFERS
    wire datain_in;
    wire oe_in;
    wire  delayctrlin_ipd;
   
    buf(datain_in, datain);
    buf(oe_in, oe);
    buf (delayctrlin_ipd, delayctrlin);
   
    tri 	     padio_tmp;
   
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
   
    specify
        (padio => combout) = (0,0);
        (padio => dqsundelayedout) = (0,0);
        (datain => padio) = (0, 0);
        (posedge oe => (padio +: padio_tmp)) = (0, 0);
        (negedge oe => (padio +: 1'bz)) = (0, 0);
        (ddioregin => ddioregout) = (0, 0);
        (regin => regout) = (0, 0);
    endspecify
   
    initial
    begin
        prev_value = 'b0;
        tmp_padio = 'bz;
        dqs_delay = (str2int(phase_shift) * str2int(input_frequency))/360;
        if (operation_mode == "input")
            iop_mode = 0;
        else if (operation_mode == "output")
            iop_mode = 1;
        else if (operation_mode == "bidir")
            iop_mode = 2;
        else
        begin
            $display ("Error: Invalid operation_mode specified\n");
            $display ("Time: %0t  Instance: %m", $time);
            iop_mode = 3;
        end
    end
   
    always @(delayctrlin_ipd)
    begin
        if (delayctrlin_ipd == 1'b1)
            dqs_delay = (str2int(phase_shift) * str2int(input_frequency))/360;
        else if (delayctrlin_ipd == 1'b0)
            dqs_delay = 0;
        else 
        begin
            $display($time, " Warning: Illegal value detected on 'delayctrlin' input.");
            $display ("Time: %0t  Instance: %m", $time);
            dqs_delay = 0;
        end
    end
   
    always @(datain_in or oe_in or padio)
    begin
        if (bus_hold == "true" )
        begin
            buf_control = 'b1;
            if ( operation_mode == "input")
            begin
                if (padio == 1'bz)
                    tmp_combout = prev_value;
                else
                begin
                    prev_value = padio; 
                    tmp_combout = padio;
                end
                tmp_padio = 1'bz;
            end
            else
            begin
                if (iop_mode == 1 || iop_mode == 2) // output or bidir
                begin
                    if ( oe_in == 1)
                    begin
                        if ( open_drain_output == "true" )
                        begin
                            if (datain_in == 0)
                            begin
                                tmp_padio =  1'b0;
                                prev_value = 1'b0;
                            end
                            else if (datain_in == 1'bx)
                            begin
                                tmp_padio = 1'bx;
                                prev_value = 1'bx;
                            end
                            else   // output of tri is 'Z'
                            begin
                                if (iop_mode == 2) // bidir
                                    prev_value = padio;
                                tmp_padio = 1'bz;
                            end
                        end  
                        else  // open drain_output = false;
                        begin
                            tmp_padio = datain_in;
                            prev_value = datain_in;
                        end
                    end   
                    else if ( oe_in == 0 )
                    begin
                        if (iop_mode == 2) // bidir
                            prev_value = padio;
                        tmp_padio = 1'bz;
                    end
                    else   // oe == 'X' 
                    begin
                        tmp_padio = 1'bx;
                        prev_value = 1'bx;
                    end
                end
    	     
                if (iop_mode == 1) // output
                    tmp_combout = 1'bz;
                else
                    tmp_combout = padio;
            end
        end
	else    // bus hold is false
        begin
            buf_control = 'b0;
            if (iop_mode == 0) // input
            begin
                tmp_combout = padio;
            end
            else if (iop_mode == 1 || iop_mode == 2) // output or bidir
            begin
                if (iop_mode  == 2) // bidir
                    tmp_combout = padio;

                if ( oe_in == 1 )
                begin
                    if ( open_drain_output == "true" )
                    begin
                        if (datain_in == 0)
                            tmp_padio = 1'b0;
                        else if ( datain_in == 1'bx)
                            tmp_padio = 1'bx;
                        else
                            tmp_padio = 1'bz;
                    end
                    else
                        tmp_padio = datain_in;
                end
                else if ( oe_in == 0 )
                    tmp_padio = 1'bz;
                else
                    tmp_padio = 1'bx;
            end
            else
            begin
                $display ("Error: Invalid operation_mode specified in stratixgx io atom!\n");
                $display ("Time: %0t  Instance: %m", $time);
            end
        end
        combout_tmp <= #(dqs_delay) tmp_combout;
    end
    
    bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
    pmos (padio_tmp, tmp_padio, 'b0);
    pmos (combout, combout_tmp, 'b0);
    pmos (padio, padio_tmp, 'b0);
    and (regout, regin, 1'b1);
    and (ddioregout, ddioregin, 1'b1);
    and (dqsundelayedout, tmp_combout, 1'b1);
   
endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_io_register
//
// Description : Verilog simulation model for register with control
//               signals module in Stratixgx IO. 
//
///////////////////////////////////////////////////////////////////////

module  stratixgx_io_register 
    (
     clk, 
     datain, 
     ena, 
     sreset, 
     areset, 
     devclrn, 
     devpor, 
     regout
     );
   
    parameter	async_reset = "none";
    parameter 	sync_reset = "none";
    parameter 	power_up = "low";
    
    // INPUT PORTS
    input 	clk;
    input 	ena;
    input 	datain;
    input 	areset;
    input 	sreset;
    input 	devclrn;
    input 	devpor;

    // OUTPUT PORTS
    output 	regout;
    
    // INTERNAL VARIABLES
    reg         iregout;
    wire 	reset, is_areset_clear, is_areset_preset;
    
    reg 		datain_viol;
    reg 		sreset_viol;
    reg 		ena_viol;
    reg 		violation;
    
    reg 		clk_last_value;
   
    // INPUT BUFFERS
    wire clk_in;
    wire idatain;
    wire iareset;
    wire isreset;
    wire iena;

    buf (clk_in, clk);
    buf (idatain, datain);
    buf (iareset, areset);
    buf (isreset, sreset);
    buf (iena, ena);
   
    assign 	reset = devpor && devclrn 
                           && !(iareset && async_reset != "none") && (iena);
    
    assign 	is_areset_clear = (async_reset == "clear")?1'b1:1'b0;
    assign 	is_areset_preset = (async_reset == "preset")?1'b1:1'b0;
   
    specify
    
        $setuphold (posedge clk &&& reset, datain, 0, 0, datain_viol) ;
        $setuphold (posedge clk &&& reset, sreset, 0, 0, sreset_viol) ;
        $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
        
        (posedge clk => (regout +: iregout)) = 0 ;
        
        if (is_areset_clear == 1'b1)
            (posedge areset => (regout +: 1'b0)) = (0,0);
        if ( is_areset_preset == 1'b1)
            (posedge areset => (regout +: 1'b1)) = (0,0);
    
    endspecify
   
    initial
    begin
        violation = 0;
        if (power_up == "low")
            iregout = 'b0;
        else if (power_up == "high")
            iregout = 'b1;
    end
   
    always @ (datain_viol or sreset_viol or ena_viol)
    begin
        violation = 1;
    end
   
    always @ (clk_in or posedge iareset or negedge devclrn or 
              negedge devpor or posedge violation)
    begin
        if (violation == 1'b1)
        begin
            violation = 0;
            iregout = 'bx;
        end
        else if (devpor == 'b0)
        begin
            if (power_up == "low")
                iregout = 'b0;
            else if (power_up == "high")
                iregout = 'b1;
        end
        else if (devclrn == 'b0)
            iregout = 'b0;
        else if (async_reset == "clear" && iareset == 'b1) 
            iregout = 'b0 ;
        else if (async_reset == "preset" && iareset == 'b1 )
            iregout = 'b1;
        else if (iena == 'b1 && clk_in == 'b1 && clk_last_value == 'b0)
        begin
            if (sync_reset == "clear" && isreset == 'b1)
                iregout = 'b0 ;
            else if (sync_reset == "preset" && isreset == 'b1)
                iregout = 'b1;
            else
                iregout = idatain ;
            end
            clk_last_value = clk_in;
        end
    and (regout, iregout, 'b1) ;
endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lcell_register
//
// Description : Verilog simulation model for register with control
//               signals module in Stratixgx Lcell. 
//
///////////////////////////////////////////////////////////////////////

module stratixgx_io 
    (
     datain, 
     ddiodatain, 
     oe, 
     outclk, 
     outclkena,
     inclk, 
     inclkena, 
     areset, 
     sreset, 
     delayctrlin, 
     devclrn, 
     devpor, 
     devoe,
     padio, 
     combout, 
     regout, 
     ddioregout,
     dqsundelayedout
     );
   
    parameter operation_mode = "input";
    parameter ddio_mode = "none";
    parameter open_drain_output = "false";
    parameter bus_hold = "false";
   
    parameter output_register_mode = "none";
    parameter output_async_reset = "none";
    parameter output_sync_reset = "none";
    parameter output_power_up = "low";
    parameter tie_off_output_clock_enable = "false";
    
    parameter oe_register_mode = "none";
    parameter oe_async_reset = "none";
    parameter oe_sync_reset = "none";
    parameter oe_power_up = "low";
    parameter tie_off_oe_clock_enable = "false";
    
    parameter input_register_mode = "none";
    parameter input_async_reset = "none";
    parameter input_sync_reset = "none";
    parameter input_power_up = "low";
    
    parameter extend_oe_disable = "false";
    
    parameter sim_dll_phase_shift = "0";
    parameter sim_dqs_input_frequency = "10000 ps";
    parameter lpm_type = "stratixgx_io";
   
    // INPUT/OUTPUT PORTS
    inout     padio;
    
    // INPUT PORTS
    input     datain;
    input     ddiodatain;
    input     oe;
    input     outclk;
    input     outclkena;
    input     inclk;
    input     inclkena;
    input     areset;
    input     sreset;
    input     delayctrlin;
    input     devclrn;
    input     devpor;
    input     devoe;

    // OUTPUT PORTS
    output    combout;
    output    regout;
    output    ddioregout;
    output    dqsundelayedout;
    
    tri1 devclrn;
    tri1 devpor;
    tri1 devoe;
    
    // INTERNAL VARIABLES
    wire      oe_reg_out, oe_pulse_reg_out;
    wire      in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out;
    wire      out_reg_out, out_ddio_reg_out;
    
    wire      out_clk_ena, oe_clk_ena;
    
    wire      tmp_datain;
    wire      ddio_data;
    wire      oe_out;
    wire      outclk_delayed;
   
   
    assign    out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
    assign    oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : 1'b1;
   
    //input register
    stratixgx_io_register in_reg  
        (
        .regout(in_reg_out), 
        .clk(inclk), 
        .ena(inclkena), 
        .datain(padio), 
        .areset(areset), 
        .sreset(sreset), 
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  in_reg.async_reset = input_async_reset;
    defparam  in_reg.sync_reset = input_sync_reset;
    defparam  in_reg.power_up = input_power_up;
   
    // in_ddio0_reg
    stratixgx_io_register in_ddio0_reg 
        (
        .regout(in_ddio0_reg_out), 
        .clk(!inclk), 
        .ena (inclkena), 
        .datain(padio), 
        .areset(areset), 
        .sreset(sreset),
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  in_ddio0_reg.async_reset = input_async_reset;
    defparam  in_ddio0_reg.sync_reset = input_sync_reset;
    defparam  in_ddio0_reg.power_up = input_power_up;
   
    // in_ddio1_reg
    // this register has no sync_reset   
    stratixgx_io_register in_ddio1_reg 
        (
        .regout(in_ddio1_reg_out), 
        .clk(inclk), 
        .ena(inclkena), 
        .datain(in_ddio0_reg_out),
        .areset(areset), 
        .sreset(1'b0),
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  in_ddio1_reg.async_reset = input_async_reset;
    defparam  in_ddio1_reg.sync_reset = "none"; 
    defparam  in_ddio1_reg.power_up = input_power_up;
    
    // out_reg
    stratixgx_io_register out_reg 
        (
        .regout(out_reg_out), 
        .clk(outclk), 
        .ena(out_clk_ena), 
        .datain(datain), 
        .areset(areset), 
        .sreset(sreset),
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  out_reg.async_reset = output_async_reset;
    defparam  out_reg.sync_reset = output_sync_reset;
    defparam  out_reg.power_up = output_power_up;
   
    // out ddio reg
    stratixgx_io_register out_ddio_reg 
        (
        .regout(out_ddio_reg_out), 
        .clk(outclk), 
        .ena(out_clk_ena), 
        .datain(ddiodatain), 
        .areset(areset), 
        .sreset(sreset),
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  out_ddio_reg.async_reset = output_async_reset;
    defparam  out_ddio_reg.sync_reset = output_sync_reset;
    defparam  out_ddio_reg.power_up = output_power_up;
   
    // oe reg
    stratixgx_io_register oe_reg 
        (
        .regout (oe_reg_out), 
        .clk(outclk), 
        .ena(oe_clk_ena), 
        .datain(oe), 
        .areset(areset), 
        .sreset(sreset),
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  oe_reg.async_reset = oe_async_reset;
    defparam  oe_reg.sync_reset = oe_sync_reset;
    defparam  oe_reg.power_up = oe_power_up;
   
    // oe_pulse reg
    stratixgx_io_register oe_pulse_reg  
        (
        .regout(oe_pulse_reg_out), 
        .clk(!outclk),
        .ena(oe_clk_ena), 
        .datain(oe_reg_out), 
        .areset(areset), 
        .sreset(sreset),
        .devpor(devpor), 
        .devclrn(devclrn)
        );
    defparam  oe_pulse_reg.async_reset = oe_async_reset;
    defparam  oe_pulse_reg.sync_reset = oe_sync_reset;
    defparam  oe_pulse_reg.power_up = oe_power_up;
   
    assign    oe_out = (oe_register_mode == "register") ? 
    		(extend_oe_disable == "true" ? oe_pulse_reg_out 
    		 && oe_reg_out : oe_reg_out) : oe;
   
    stratixgx_and1    sel_delaybuf 
        (
        .Y(outclk_delayed), 
        .IN1(outclk)
        );
    
    stratixgx_mux21   ddio_data_mux 
        (
        .MO (ddio_data),
        .A (out_ddio_reg_out),
        .B (out_reg_out),
        .S (outclk_delayed)
        );
   
    assign    tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? 
    		    ddio_data : ((operation_mode == "output" || 
    				  operation_mode == "bidir") ? 
    				 ((output_register_mode == "register")
    				  ? out_reg_out : datain) : 'b0);
   
    // timing info in case output and/or input are not registered.
    stratixgx_asynch_io inst1 
        (
        .datain(tmp_datain),
        .oe(oe_out),
        .regin(in_reg_out),
        .ddioregin(in_ddio1_reg_out),
        .padio(padio),
        .delayctrlin(delayctrlin),
        .combout(combout),
        .regout(regout),
        .ddioregout(ddioregout),
        .dqsundelayedout(dqsundelayedout)
        );
    defparam  inst1.operation_mode = operation_mode;
    defparam  inst1.bus_hold = bus_hold;
    defparam  inst1.open_drain_output = open_drain_output;
    defparam  inst1.phase_shift = sim_dll_phase_shift;
    defparam  inst1.input_frequency = sim_dqs_input_frequency;
   
endmodule // stratixgx_io

///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXGX_MAC_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixgx_mac_register 
  (
   data, 
   clk, 
   aclr,
   if_aclr,
   ena, 
   async, 
   dataout
   );
   
   parameter data_width = 72;
   parameter power_up = 1'b0;
      
   input [71:0] data;
   input 	clk;
   input 	aclr; 
   input 	ena;
   input 	async;
   input 	if_aclr;
   output [71:0] dataout;

   wire [71:0] 	 data_ipd;
   wire 	 clk_ipd;
   wire 	 aclr_ipd;
   wire 	 ena_ipd;
   wire 	 reset;
   wire [71:0] 	 dataout_tbuf;
   wire [71:0] 	 dataout_tmp;
   reg [71:0] 	 dataout_reg;
   reg [71:0] 	 dataout_reg_c;
   reg 		 viol_notifier; // USED FOR DELAY
   
   assign dataout_tbuf = dataout_tmp;
   assign reset = (!aclr_ipd) && (ena_ipd);
  
   buf data_buf0(data_ipd[0], data[0]);
   buf data_buf1(data_ipd[1], data[1]);
   buf data_buf2(data_ipd[2], data[2]);
   buf data_buf3(data_ipd[3], data[3]);
   buf data_buf4(data_ipd[4], data[4]);
   buf data_buf5(data_ipd[5], data[5]);
   buf data_buf6(data_ipd[6], data[6]);
   buf data_buf7(data_ipd[7], data[7]);
   buf data_buf8(data_ipd[8], data[8]);
   buf data_buf9(data_ipd[9], data[9]);
   buf data_buf10(data_ipd[10], data[10]);
   buf data_buf11(data_ipd[11], data[11]);
   buf data_buf12(data_ipd[12], data[12]);
   buf data_buf13(data_ipd[13], data[13]);
   buf data_buf14(data_ipd[14], data[14]);
   buf data_buf15(data_ipd[15], data[15]);
   buf data_buf16(data_ipd[16], data[16]);
   buf data_buf17(data_ipd[17], data[17]);
   buf data_buf18(data_ipd[18], data[18]);
   buf data_buf19(data_ipd[19], data[19]);
   buf data_buf20(data_ipd[20], data[20]);
   buf data_buf21(data_ipd[21], data[21]);
   buf data_buf22(data_ipd[22], data[22]);
   buf data_buf23(data_ipd[23], data[23]);
   buf data_buf24(data_ipd[24], data[24]);
   buf data_buf25(data_ipd[25], data[25]);
   buf data_buf26(data_ipd[26], data[26]);
   buf data_buf27(data_ipd[27], data[27]);
   buf data_buf28(data_ipd[28], data[28]);
   buf data_buf29(data_ipd[29], data[29]);
   buf data_buf30(data_ipd[30], data[30]);
   buf data_buf31(data_ipd[31], data[31]);
   buf data_buf32(data_ipd[32], data[32]);
   buf data_buf33(data_ipd[33], data[33]);
   buf data_buf34(data_ipd[34], data[34]);
   buf data_buf35(data_ipd[35], data[35]);
   buf data_buf36(data_ipd[36], data[36]);
   buf data_buf37(data_ipd[37], data[37]);
   buf data_buf38(data_ipd[38], data[38]);
   buf data_buf39(data_ipd[39], data[39]);
   buf data_buf40(data_ipd[40], data[40]);
   buf data_buf41(data_ipd[41], data[41]);
   buf data_buf42(data_ipd[42], data[42]);
   buf data_buf43(data_ipd[43], data[43]);
   buf data_buf44(data_ipd[44], data[44]);
   buf data_buf45(data_ipd[45], data[45]);
   buf data_buf46(data_ipd[46], data[46]);
   buf data_buf47(data_ipd[47], data[47]);
   buf data_buf48(data_ipd[48], data[48]);
   buf data_buf49(data_ipd[49], data[49]);
   buf data_buf50(data_ipd[50], data[50]);
   buf data_buf51(data_ipd[51], data[51]);
   buf data_buf52(data_ipd[52], data[52]);
   buf data_buf53(data_ipd[53], data[53]);
   buf data_buf54(data_ipd[54], data[54]);
   buf data_buf55(data_ipd[55], data[55]);
   buf data_buf56(data_ipd[56], data[56]);
   buf data_buf57(data_ipd[57], data[57]);
   buf data_buf58(data_ipd[58], data[58]);
   buf data_buf59(data_ipd[59], data[59]);
   buf data_buf60(data_ipd[60], data[60]);
   buf data_buf61(data_ipd[61], data[61]);
   buf data_buf62(data_ipd[62], data[62]);
   buf data_buf63(data_ipd[63], data[63]);
   buf data_buf64(data_ipd[64], data[64]);
   buf data_buf65(data_ipd[65], data[65]);
   buf data_buf66(data_ipd[66], data[66]);
   buf data_buf67(data_ipd[67], data[67]);
   buf data_buf68(data_ipd[68], data[68]);
   buf data_buf69(data_ipd[69], data[69]);
   buf data_buf70(data_ipd[70], data[70]);
   buf data_buf71(data_ipd[71], data[71]);

   buf dataout_buf0(dataout[0], dataout_tbuf[0]);
   buf dataout_buf1(dataout[1], dataout_tbuf[1]);
   buf dataout_buf2(dataout[2], dataout_tbuf[2]);
   buf dataout_buf3(dataout[3], dataout_tbuf[3]);
   buf dataout_buf4(dataout[4], dataout_tbuf[4]);
   buf dataout_buf5(dataout[5], dataout_tbuf[5]);
   buf dataout_buf6(dataout[6], dataout_tbuf[6]);
   buf dataout_buf7(dataout[7], dataout_tbuf[7]);
   buf dataout_buf8(dataout[8], dataout_tbuf[8]);
   buf dataout_buf9(dataout[9], dataout_tbuf[9]);
   buf dataout_buf10(dataout[10], dataout_tbuf[10]);
   buf dataout_buf11(dataout[11], dataout_tbuf[11]);
   buf dataout_buf12(dataout[12], dataout_tbuf[12]);
   buf dataout_buf13(dataout[13], dataout_tbuf[13]);
   buf dataout_buf14(dataout[14], dataout_tbuf[14]);
   buf dataout_buf15(dataout[15], dataout_tbuf[15]);
   buf dataout_buf16(dataout[16], dataout_tbuf[16]);
   buf dataout_buf17(dataout[17], dataout_tbuf[17]);
   buf dataout_buf18(dataout[18], dataout_tbuf[18]);
   buf dataout_buf19(dataout[19], dataout_tbuf[19]);
   buf dataout_buf20(dataout[20], dataout_tbuf[20]);
   buf dataout_buf21(dataout[21], dataout_tbuf[21]);
   buf dataout_buf22(dataout[22], dataout_tbuf[22]);
   buf dataout_buf23(dataout[23], dataout_tbuf[23]);
   buf dataout_buf24(dataout[24], dataout_tbuf[24]);
   buf dataout_buf25(dataout[25], dataout_tbuf[25]);
   buf dataout_buf26(dataout[26], dataout_tbuf[26]);
   buf dataout_buf27(dataout[27], dataout_tbuf[27]);
   buf dataout_buf28(dataout[28], dataout_tbuf[28]);
   buf dataout_buf29(dataout[29], dataout_tbuf[29]);
   buf dataout_buf30(dataout[30], dataout_tbuf[30]);
   buf dataout_buf31(dataout[31], dataout_tbuf[31]);
   buf dataout_buf32(dataout[32], dataout_tbuf[32]);
   buf dataout_buf33(dataout[33], dataout_tbuf[33]);
   buf dataout_buf34(dataout[34], dataout_tbuf[34]);
   buf dataout_buf35(dataout[35], dataout_tbuf[35]);
   buf dataout_buf36(dataout[36], dataout_tbuf[36]);
   buf dataout_buf37(dataout[37], dataout_tbuf[37]);
   buf dataout_buf38(dataout[38], dataout_tbuf[38]);
   buf dataout_buf39(dataout[39], dataout_tbuf[39]);
   buf dataout_buf40(dataout[40], dataout_tbuf[40]);
   buf dataout_buf41(dataout[41], dataout_tbuf[41]);
   buf dataout_buf42(dataout[42], dataout_tbuf[42]);
   buf dataout_buf43(dataout[43], dataout_tbuf[43]);
   buf dataout_buf44(dataout[44], dataout_tbuf[44]);
   buf dataout_buf45(dataout[45], dataout_tbuf[45]);
   buf dataout_buf46(dataout[46], dataout_tbuf[46]);
   buf dataout_buf47(dataout[47], dataout_tbuf[47]);
   buf dataout_buf48(dataout[48], dataout_tbuf[48]);
   buf dataout_buf49(dataout[49], dataout_tbuf[49]);
   buf dataout_buf50(dataout[50], dataout_tbuf[50]);
   buf dataout_buf51(dataout[51], dataout_tbuf[51]);
   buf dataout_buf52(dataout[52], dataout_tbuf[52]);
   buf dataout_buf53(dataout[53], dataout_tbuf[53]);
   buf dataout_buf54(dataout[54], dataout_tbuf[54]);
   buf dataout_buf55(dataout[55], dataout_tbuf[55]);
   buf dataout_buf56(dataout[56], dataout_tbuf[56]);
   buf dataout_buf57(dataout[57], dataout_tbuf[57]);
   buf dataout_buf58(dataout[58], dataout_tbuf[58]);
   buf dataout_buf59(dataout[59], dataout_tbuf[59]);
   buf dataout_buf60(dataout[60], dataout_tbuf[60]);
   buf dataout_buf61(dataout[61], dataout_tbuf[61]);
   buf dataout_buf62(dataout[62], dataout_tbuf[62]);
   buf dataout_buf63(dataout[63], dataout_tbuf[63]);
   buf dataout_buf64(dataout[64], dataout_tbuf[64]);
   buf dataout_buf65(dataout[65], dataout_tbuf[65]);
   buf dataout_buf66(dataout[66], dataout_tbuf[66]);
   buf dataout_buf67(dataout[67], dataout_tbuf[67]);
   buf dataout_buf68(dataout[68], dataout_tbuf[68]);
   buf dataout_buf69(dataout[69], dataout_tbuf[69]);
   buf dataout_buf70(dataout[70], dataout_tbuf[70]);
   buf dataout_buf71(dataout[71], dataout_tbuf[71]);

   buf (clk_ipd, clk);
   buf (aclr_ipd, aclr);
   buf (ena_ipd, ena);
   
   initial 
     begin
	if(power_up)
	  begin
	     dataout_reg <= ~(71'b0);
	     dataout_reg_c <= ~(71'b0);
	  end
	else
	  begin
	     dataout_reg <= 'b0;
	     dataout_reg_c <= 'b0;
	  end
     end
   
   specify
      
      specparam TSU = 0;        // Set up time 
      specparam TH  = 0;        // Hold time
      specparam TCO = 0;        // Clock to Output time
      specparam TCLR = 0;       // Clear time
      specparam TCLR_MIN_PW = 0;// Minimum pulse width of clear
      specparam TPRE = 0; 	// Preset time
      specparam TPRE_MIN_PW = 0;// Minimum pulse width of preset
      specparam TCLK_MIN_PW = 0;// Minimum pulse width of clock
      specparam TCE_MIN_PW = 0; // Minimum pulse width of clock enable
      specparam TCLKL = 0; 	// Minimum clock low time
      specparam TCLKH = 0; 	// Minimum clock high time
      
      $setup  (data, posedge clk &&& reset, 0, viol_notifier);
      $hold   (posedge clk &&& reset, data, 0, viol_notifier);
      $setup  (ena, posedge clk &&& reset, 0, viol_notifier );
      $hold   (posedge clk &&& reset, ena, 0, viol_notifier );
      
      (posedge aclr => (dataout  +: 'b0)) = (0,0);
      (posedge clk  => (dataout  +: dataout_tmp)) = (0,0); 
      
   endspecify

   // ACLR
   always @(posedge clk_ipd or posedge aclr_ipd)
     begin
	if (aclr_ipd == 1'b1)
	  dataout_reg_c <= 'b0;
	else if (ena_ipd == 1'b1) 
	  dataout_reg_c <= data_ipd;
	else 
	  dataout_reg_c <= dataout_reg_c;
     end

   // !ACLR
   always @(posedge clk_ipd)
     begin
	if (ena_ipd == 1'b1) 
	  dataout_reg <= data_ipd;
	else 
	  dataout_reg <= dataout_reg;
     end

   assign dataout_tmp = (async ? data_ipd : (if_aclr ? dataout_reg_c : dataout_reg));

endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                         STRATIXGX_MAC_MULT_INTERNAL
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixgx_mac_mult_internal 
  (
   dataa, 
   datab, 
   signa, 
   signb,
   scanouta, 
   scanoutb, 
   dataout
   );
   parameter dataa_width = 18;
   parameter datab_width = 18;
   parameter dataout_width = 36;
   input [dataa_width-1:0] dataa;
   input [datab_width-1:0] datab;
   input 	signa;
   input 	signb;
   output [dataa_width-1:0] scanouta;
   output [datab_width-1:0] scanoutb;
   output [35:0] dataout;

   wire [35:0] 	 dataout_s;
   wire 	 neg;
   wire [35:0] 	 dataout_tmp;
   wire [dataa_width-1:0] abs_a;
   wire [datab_width-1:0] abs_b;
   wire [17:0] 		  dataa_tmp;
   wire [17:0] 		  datab_tmp;
   wire [17:0] 		  scanouta_tmp;
   wire [17:0] 		  scanoutb_tmp;
   wire [(dataa_width+datab_width)-1:0] abs_output; 
   
   specify
      (dataa *> dataout)     = (0, 0);
      (datab *> dataout)     = (0, 0);
      (dataa => scanouta)    = (0, 0);
      (datab => scanoutb)    = (0, 0);
      (signa *> dataout)     = (0, 0);
      (signb *> dataout)     = (0, 0);
   endspecify

   buf dataa_buf [dataa_width-1:0] (dataa_tmp[dataa_width-1:0], dataa);
   buf datab_buf [datab_width-1:0] (datab_tmp[datab_width-1:0], datab);

   assign neg = ((dataa_tmp[dataa_width-1] && signa) ^ (datab_tmp[datab_width-1] && signb)); 
   assign abs_a = (signa && dataa_tmp[dataa_width-1]) ? (~dataa_tmp[dataa_width-1:0] + 1) : dataa_tmp[dataa_width-1:0];
   assign abs_b = (signb && datab_tmp[datab_width-1]) ? (~datab_tmp[datab_width-1:0] + 1) : datab_tmp[datab_width-1:0];
   assign scanouta_tmp = dataa_tmp;
   assign scanoutb_tmp = datab_tmp;
   assign abs_output = abs_a * abs_b;
   assign dataout_tmp = neg ? (~abs_output + 1) : abs_output;
   
   buf scanouta_buf [dataa_width-1:0] (scanouta, scanouta_tmp[dataa_width-1:0]);
   buf scanoutb_buf [datab_width-1:0] (scanoutb, scanoutb_tmp[datab_width-1:0]);
   
   buf dataout_buf0(dataout[0], dataout_tmp[0]);
   buf dataout_buf1(dataout[1], dataout_tmp[1]);
   buf dataout_buf2(dataout[2], dataout_tmp[2]);
   buf dataout_buf3(dataout[3], dataout_tmp[3]);
   buf dataout_buf4(dataout[4], dataout_tmp[4]);
   buf dataout_buf5(dataout[5], dataout_tmp[5]);
   buf dataout_buf6(dataout[6], dataout_tmp[6]);
   buf dataout_buf7(dataout[7], dataout_tmp[7]);
   buf dataout_buf8(dataout[8], dataout_tmp[8]);
   buf dataout_buf9(dataout[9], dataout_tmp[9]);
   buf dataout_buf10(dataout[10], dataout_tmp[10]);
   buf dataout_buf11(dataout[11], dataout_tmp[11]);
   buf dataout_buf12(dataout[12], dataout_tmp[12]);
   buf dataout_buf13(dataout[13], dataout_tmp[13]);
   buf dataout_buf14(dataout[14], dataout_tmp[14]);
   buf dataout_buf15(dataout[15], dataout_tmp[15]);
   buf dataout_buf16(dataout[16], dataout_tmp[16]);
   buf dataout_buf17(dataout[17], dataout_tmp[17]);
   buf dataout_buf18(dataout[18], dataout_tmp[18]);
   buf dataout_buf19(dataout[19], dataout_tmp[19]);
   buf dataout_buf20(dataout[20], dataout_tmp[20]);
   buf dataout_buf21(dataout[21], dataout_tmp[21]);
   buf dataout_buf22(dataout[22], dataout_tmp[22]);
   buf dataout_buf23(dataout[23], dataout_tmp[23]);
   buf dataout_buf24(dataout[24], dataout_tmp[24]);
   buf dataout_buf25(dataout[25], dataout_tmp[25]);
   buf dataout_buf26(dataout[26], dataout_tmp[26]);
   buf dataout_buf27(dataout[27], dataout_tmp[27]);
   buf dataout_buf28(dataout[28], dataout_tmp[28]);
   buf dataout_buf29(dataout[29], dataout_tmp[29]);
   buf dataout_buf30(dataout[30], dataout_tmp[30]);
   buf dataout_buf31(dataout[31], dataout_tmp[31]);
   buf dataout_buf32(dataout[32], dataout_tmp[32]);
   buf dataout_buf33(dataout[33], dataout_tmp[33]);
   buf dataout_buf34(dataout[34], dataout_tmp[34]);
   buf dataout_buf35(dataout[35], dataout_tmp[35]);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXGX_MAC_MULT
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixgx_mac_mult	
  (
   dataa, 
   datab,
   signa, 
   signb,
   clk, 
   aclr, 
   ena,
   dataout, 
   scanouta, 
   scanoutb, 
   devclrn, 
   devpor
   );
   
   parameter dataa_width        = 18;
   parameter datab_width        = 18;
   parameter dataa_clock	= "none";
   parameter datab_clock	= "none";
   parameter signa_clock	= "none"; 
   parameter signb_clock	= "none";
   parameter output_clock	= "none";
   parameter dataa_clear	= "none";
   parameter datab_clear	= "none";
   parameter signa_clear	= "none"; 
   parameter signb_clear	= "none"; 
   parameter output_clear	= "none";
   parameter signa_internally_grounded = "false"; 
   parameter signb_internally_grounded = "false"; 
   parameter lpm_hint           = "true";         
   parameter lpm_type           = "stratixgx_mac_mult";

// SIMULATION_ONLY_PARAMETERS_BEGIN

   parameter dataout_width      = dataa_width + datab_width;

// SIMULATION_ONLY_PARAMETERS_END
   
   input [dataa_width-1:0] dataa;
   input [datab_width-1:0] datab;
   input 	signa;
   input 	signb;
   input [3:0] 	clk;
   input [3:0] 	aclr;
   input [3:0] 	ena;
   input 	devclrn;
   input 	devpor;

   output [dataout_width-1:0] dataout;
   output [dataa_width-1:0] scanouta;
   output [datab_width-1:0] scanoutb;
   
   tri1 devclrn;
   tri1 devpor;

   wire [35:0] 	 mult_output;
   wire [71:0] 	 signa_out; 
   wire [71:0] 	 signb_out;
   wire [71:0] 	 dataout_tmp;
   wire [71:0] 	 scanouta_tmp;
   wire [71:0] 	 scanoutb_tmp;

   assign dataout = dataout_tmp[35:0];
      
   stratixgx_mac_register	dataa_mac_reg 
      (
       .data ({{(72-dataa_width){1'b0}},dataa}),
       .clk (clk[select_the(dataa_clock)]),
       .aclr (aclr[select_the(dataa_clear)] || ~devclrn || ~devpor),
       .if_aclr ((dataa_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(dataa_clock)]),
       .dataout (scanouta_tmp),
       .async ((dataa_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam  dataa_mac_reg.data_width = dataa_width;
   defparam  dataa_mac_reg.power_up = 1'b0;

   stratixgx_mac_register	datab_mac_reg 
      (
       .data ({{(72-datab_width){1'b0}},datab}),       
       .clk (clk[select_the(datab_clock)]),
       .aclr (aclr[select_the(datab_clear)] || ~devclrn || ~devpor),
       .if_aclr ((datab_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(datab_clock)]),
       .dataout (scanoutb_tmp),
       .async ((datab_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam  datab_mac_reg.data_width = datab_width;
   defparam  datab_mac_reg.power_up = 1'b0;
   
   stratixgx_mac_register	signa_mac_reg 
      (
       .data ({{(71){1'b0}},signa}),
       .clk (clk[select_the(signa_clock)]),
       .aclr (aclr[select_the(signa_clear)] || ~devclrn || ~devpor),
       .if_aclr ((signa_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(signa_clock)]),
       .dataout (signa_out),
       .async ((signa_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam  signa_mac_reg.data_width = 1;
   defparam  signa_mac_reg.power_up = 1'b0;
   
   stratixgx_mac_register	signb_mac_reg 
      (
       .data ({{(71){1'b0}},signb}),
       .clk (clk[select_the(signb_clock)]),
       .aclr (aclr[select_the(signb_clear)] || ~devclrn || ~devpor),
       .if_aclr ((signb_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(signb_clock)]),
       .dataout (signb_out),
       .async ((signb_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam  signb_mac_reg.data_width = 1;
   defparam  signb_mac_reg.power_up = 1'b0;

   stratixgx_mac_mult_internal mac_multiply 
      (
       .dataa (scanouta_tmp[dataa_width-1:0]),
       .datab (scanoutb_tmp[datab_width-1:0]),
       .signa ((signa_internally_grounded == "false") ? signa_out[0] : 1'b0),
       .signb ((signb_internally_grounded == "false") ? signb_out[0] : 1'b0),
       .scanouta(scanouta),
       .scanoutb(scanoutb),
       .dataout(mult_output)
       );
   defparam  mac_multiply.dataa_width  = dataa_width;
   defparam  mac_multiply.datab_width  = datab_width;
   defparam  mac_multiply.dataout_width = (dataa_width+datab_width);

   stratixgx_mac_register	dataout_mac_reg 
      (
       .data ({{(36){1'b0}},mult_output}),
       .clk (clk[select_the(output_clock)]),
       .aclr (aclr[select_the(output_clear)] || ~devclrn || ~devpor),
       .if_aclr ((output_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(output_clock)]),
       .dataout (dataout_tmp),
       .async ((output_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam  dataout_mac_reg.data_width = (dataa_width+datab_width);
   defparam  dataout_mac_reg.power_up = 1'b0;

//////////////////////////////////////////////////////////////////////////////
//
//                                 SELECT_THE
//
//////////////////////////////////////////////////////////////////////////////

   function integer select_the;
      input [8*4:1] string_name;
      begin 
	 if (string_name == "0")
	    select_the = 0;
	 else if (string_name == "1")
	    select_the = 1;
	      else if (string_name == "2")
		 select_the = 2;
		   else if (string_name == "3")
		      select_the = 3;
			else if (string_name == "none")
			   select_the = 0;
      end
   endfunction
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXGX_MAC_OUT_INTERNAL
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixgx_mac_out_internal (dataa, datab, datac, datad, signx, signy, 
				 addnsub0, addnsub1, zeroacc, dataout_global, 
				 dataout, accoverflow);
   `define ADD 1'b1
   `define SUB 1'b0
   parameter operation_mode = "output_only";
   parameter dataa_width = 36;
   parameter datab_width = 36;
   parameter datac_width = 36;
   parameter datad_width = 36;
   parameter dataout_width = 72; 
   
   input [36:0] dataa;
   input [36:0] datab;
   input [36:0] datac;
   input [36:0] datad;
   input 		   signx;
   input 		   signy;
   input 		   addnsub0;
   input 		   addnsub1;
   input 		   zeroacc;
   input [71:0] 	   dataout_global; 
   output [71:0] 	   dataout;
   output 		   accoverflow;
   
   reg [72:0] 		   dataout_tmp; 
   reg 			   accoverflow_tmp;
   reg [72:0] 		   last_dataout; 
   reg [71:0] 		   dataa_u;
   reg [71:0] 		   datab_u;
   reg [71:0] 		   datab_s;
   reg [71:0] 		   datac_u;
   reg [71:0] 		   datac_s;
   reg [71:0] 		   datad_u;
   reg [71:0] 		   datad_s;
   reg [72:0] 		   data_tmp; 
   
   wire [71:0] 		   dataout_tbuf; 
   wire 		   accoverflow_tbuf;
   
   specify
      (dataa *> dataout) = (0,0);
      (datab *> dataout) = (0,0);
      (datac *> dataout) = (0,0);
      (datad *> dataout) = (0,0);
      (signx *> dataout) = (0,0);
      (signy *> dataout) = (0,0);
      (addnsub0 *> dataout) = (0,0);
      (addnsub1 *> dataout) = (0,0);
      (zeroacc *> dataout)  = (0,0);
      (dataa *> accoverflow) = (0,0);
      (signx *> accoverflow) = (0,0);
      (signy *> accoverflow) = (0,0);
      (addnsub0 *> accoverflow) = (0,0);
      (addnsub1 *> accoverflow) = (0,0);
      (zeroacc *> accoverflow)  = (0,0);
   endspecify
   
   buf dataout_buf0(dataout[0], dataout_tbuf[0]);
   buf dataout_buf1(dataout[1], dataout_tbuf[1]);
   buf dataout_buf2(dataout[2], dataout_tbuf[2]);
   buf dataout_buf3(dataout[3], dataout_tbuf[3]);
   buf dataout_buf4(dataout[4], dataout_tbuf[4]);
   buf dataout_buf5(dataout[5], dataout_tbuf[5]);
   buf dataout_buf6(dataout[6], dataout_tbuf[6]);
   buf dataout_buf7(dataout[7], dataout_tbuf[7]);
   buf dataout_buf8(dataout[8], dataout_tbuf[8]);
   buf dataout_buf9(dataout[9], dataout_tbuf[9]);
   buf dataout_buf10(dataout[10], dataout_tbuf[10]);
   buf dataout_buf11(dataout[11], dataout_tbuf[11]);
   buf dataout_buf12(dataout[12], dataout_tbuf[12]);
   buf dataout_buf13(dataout[13], dataout_tbuf[13]);
   buf dataout_buf14(dataout[14], dataout_tbuf[14]);
   buf dataout_buf15(dataout[15], dataout_tbuf[15]);
   buf dataout_buf16(dataout[16], dataout_tbuf[16]);
   buf dataout_buf17(dataout[17], dataout_tbuf[17]);
   buf dataout_buf18(dataout[18], dataout_tbuf[18]);
   buf dataout_buf19(dataout[19], dataout_tbuf[19]);
   buf dataout_buf20(dataout[20], dataout_tbuf[20]);
   buf dataout_buf21(dataout[21], dataout_tbuf[21]);
   buf dataout_buf22(dataout[22], dataout_tbuf[22]);
   buf dataout_buf23(dataout[23], dataout_tbuf[23]);
   buf dataout_buf24(dataout[24], dataout_tbuf[24]);
   buf dataout_buf25(dataout[25], dataout_tbuf[25]);
   buf dataout_buf26(dataout[26], dataout_tbuf[26]);
   buf dataout_buf27(dataout[27], dataout_tbuf[27]);
   buf dataout_buf28(dataout[28], dataout_tbuf[28]);
   buf dataout_buf29(dataout[29], dataout_tbuf[29]);
   buf dataout_buf30(dataout[30], dataout_tbuf[30]);
   buf dataout_buf31(dataout[31], dataout_tbuf[31]);
   buf dataout_buf32(dataout[32], dataout_tbuf[32]);
   buf dataout_buf33(dataout[33], dataout_tbuf[33]);
   buf dataout_buf34(dataout[34], dataout_tbuf[34]);
   buf dataout_buf35(dataout[35], dataout_tbuf[35]);
   buf dataout_buf36(dataout[36], dataout_tbuf[36]);
   buf dataout_buf37(dataout[37], dataout_tbuf[37]);
   buf dataout_buf38(dataout[38], dataout_tbuf[38]);
   buf dataout_buf39(dataout[39], dataout_tbuf[39]);
   buf dataout_buf40(dataout[40], dataout_tbuf[40]);
   buf dataout_buf41(dataout[41], dataout_tbuf[41]);
   buf dataout_buf42(dataout[42], dataout_tbuf[42]);
   buf dataout_buf43(dataout[43], dataout_tbuf[43]);
   buf dataout_buf44(dataout[44], dataout_tbuf[44]);
   buf dataout_buf45(dataout[45], dataout_tbuf[45]);
   buf dataout_buf46(dataout[46], dataout_tbuf[46]);
   buf dataout_buf47(dataout[47], dataout_tbuf[47]);
   buf dataout_buf48(dataout[48], dataout_tbuf[48]);
   buf dataout_buf49(dataout[49], dataout_tbuf[49]);
   buf dataout_buf50(dataout[50], dataout_tbuf[50]);
   buf dataout_buf51(dataout[51], dataout_tbuf[51]);
   buf dataout_buf52(dataout[52], dataout_tbuf[52]);
   buf dataout_buf53(dataout[53], dataout_tbuf[53]);
   buf dataout_buf54(dataout[54], dataout_tbuf[54]);
   buf dataout_buf55(dataout[55], dataout_tbuf[55]);
   buf dataout_buf56(dataout[56], dataout_tbuf[56]);
   buf dataout_buf57(dataout[57], dataout_tbuf[57]);
   buf dataout_buf58(dataout[58], dataout_tbuf[58]);
   buf dataout_buf59(dataout[59], dataout_tbuf[59]);
   buf dataout_buf60(dataout[60], dataout_tbuf[60]);
   buf dataout_buf61(dataout[61], dataout_tbuf[61]);
   buf dataout_buf62(dataout[62], dataout_tbuf[62]);
   buf dataout_buf63(dataout[63], dataout_tbuf[63]);
   buf dataout_buf64(dataout[64], dataout_tbuf[64]);
   buf dataout_buf65(dataout[65], dataout_tbuf[65]);
   buf dataout_buf66(dataout[66], dataout_tbuf[66]);
   buf dataout_buf67(dataout[67], dataout_tbuf[67]);
   buf dataout_buf68(dataout[68], dataout_tbuf[68]);
   buf dataout_buf69(dataout[69], dataout_tbuf[69]);
   buf dataout_buf70(dataout[70], dataout_tbuf[70]);
   buf dataout_buf71(dataout[71], dataout_tbuf[71]);

   buf accoverflow_buf(accoverflow, accoverflow_tbuf);

   assign dataout_tbuf[71:0] = dataout_tmp[71:0];
   assign accoverflow_tbuf = accoverflow_tmp;
   
   always @(dataa or datab or datac or datad or dataout_global 
	    or signx or signy or addnsub0 or addnsub1 
	    or zeroacc or operation_mode)
      begin
	 case (operation_mode)
	   "output_only": // dataout_tmp = dataa
	      begin 
		 dataout_tmp = dataa;
	      end 
	   "accumulator": // dataout_tmp += dataa
	      begin 
		 if (signx || signy) begin
		     data_tmp     = {{73 - dataa_width{dataa[dataa_width-1]}},
		                                       dataa[dataa_width-1:0]};
 	             last_dataout = {{73-dataout_width{dataout_global[dataout_width-1]}},
                                                       dataout_global[dataout_width-1:0]};
                 end else begin  
		     data_tmp     = {{73 - dataa_width{1'b0}},
                                                       dataa[dataa_width-1:0]};
 	             last_dataout = {{73-dataout_width{1'b0}},
                                                       dataout_global[dataout_width-1:0]};
                 end
		  
		 if (zeroacc) begin
 		   if (`ADD == addnsub0)
 		     dataout_tmp[dataout_width:0] = data_tmp;
		   else
		     dataout_tmp[dataout_width:0] = - data_tmp;
		 end else begin
 		   if (`ADD == addnsub0)
 		     dataout_tmp[dataout_width:0] = last_dataout + data_tmp;
		   else
		     dataout_tmp[dataout_width:0] = last_dataout - data_tmp;
                 end                  	

	         if (signx || signy)
		     accoverflow_tmp = dataout_tmp[dataout_width] ^ dataout_tmp[dataout_width-1];
		 else
		     accoverflow_tmp = dataout_tmp[dataout_width];
	      end
	   "one_level_adder": // dataout_tmp = dataa +/- datab
	      begin 
		 if(addnsub0)
		   dataout_tmp[dataout_width-1:0] = 
		    add_or_sub(signx || signy, dataa[35:0], signx || signy, datab[35:0], addnsub0);
		 else
		   dataout_tmp[dataout_width-1:0] = 
		    add_or_sub(signx || signy , dataa[35:0], signx || signy, datab[35:0], 1'b0);
	      end
	   "two_level_adder": // dataout_tmp = (dataa +/- datab) + (datac +/- datad)
	      // DEFAULT TO ADD (say if the addnsub0,1 signal is set to GROUND)
	      begin // dataout_width = dataa_width + 2;
		 dataout_tmp[dataout_width-1:0] = 
			add_or_sub(signx || signy, dataa[35:0], signx || signy, datab[35:0], addnsub0) +
			add_or_sub(signx || signy, datac[35:0], signx || signy, datad[35:0], addnsub1);
	      end
	   "36_bit_multiply": 
	      begin 
		 dataa_u = dataa[35:0];
		 datab_u = datab[35:0];
		 datab_s = {{(72-36){datab[35]}}, datab[35:0]};
		 datac_u = datac[35:0];
		 datac_s = {{(72-36){datac[35]}}, datac[35:0]};
		 datad_u = datad[35:0];
		 datad_s = {{(72-36){datad[35]}}, datad[35:0]};
		 if(signx == 1'b0 && signy == 1'b0)
		    begin
		       dataout_tmp = (datab_u << 36) + (datac_u << 18) + 
			   (datad_u << 18) + dataa_u;
		    end // if (signx == 1'b0 && signy == 1'b0)
		 else if(signx == 1'b0 && signy == 1'b1)
		    begin
		       dataout_tmp = (datab_s << 36) + (datac_u << 18) + 
				(datad_s << 18) + dataa_u;
		    end // if (signx == 1'b0 && signy == 1'b1)
		 else if(signx == 1'b1 && signy == 1'b0)
		    begin
		       dataout_tmp = (datab_s << 36) + (datac_s << 18) + 
				(datad_u << 18) + dataa_u;
		    end // if (signx == 1'b1 && signy == 1'b0)
		 else if(signx == 1'b1 && signy == 1'b1)
		    begin
		       dataout_tmp = (datab_s << 36) + (datac_s << 18) + 
				(datad_s << 18) + dataa_u;
		    end // if (signx == 1'b1 && signy == 1'b1)
	      end
	   default :
	      begin
		 $display ("INFO: Default operation not specified\n");
		 $display ("Time: %0t  Instance: %m", $time);
	      end
	 endcase
      end
   
//////////////////////////////////////////////////////////////////////////////
//
//                                 ADD_OR_SUB
//
//////////////////////////////////////////////////////////////////////////////

   function [52:0] add_or_sub; 
      
      input sign_a;
      input [dataa_width-1:0] data_a;
      input 		      sign_b;
      input [datab_width-1:0] data_b;
      input 		      operation;
      
      reg 		      sa;
      reg 		      sb;
      reg [dataa_width-1:0]   abs_a;
      reg [datab_width-1:0]   abs_b;
      
      begin 
	 
	 sa    = ( sign_a && data_a[dataa_width-1] );
	 sb    = ( sign_b && data_b[datab_width-1] );
	 abs_a = ( sign_a && data_a[dataa_width-1] ) ? (~data_a + 1) : data_a;
	 abs_b = ( sign_b && data_b[datab_width-1] ) ? (~data_b + 1) : data_b;
	 
	 if (operation == `ADD)
	    begin
	       add_or_sub = (sa ? -abs_a : abs_a) + (sb ? -abs_b : abs_b);
	    end 
	 else if (operation == `SUB)
	    begin
	       add_or_sub = (sa ? -abs_a : abs_a) - (sb ? -abs_b : abs_b);
	    end 
	      else
	      begin
		  $display ("INFO: Default operation not specified\n");
		  $display ("Time: %0t  Instance: %m", $time);
		  end
      end
      
   endfunction // add_or_sub
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                               STRATIXGX_MAC_OUT
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixgx_mac_out	
  (
   dataa, 
   datab, 
   datac, 
   datad, 
   zeroacc, 
   addnsub0, 
   addnsub1,
   signa, 
   signb, 
   clk, 
   aclr, 
   ena,
   dataout, 
   accoverflow,
   devclrn, 
   devpor
   );
   
   parameter operation_mode = "output_only";
   parameter dataa_width = 1;
   parameter datab_width = 1;
   parameter datac_width = 1;
   parameter datad_width = 1;
   parameter addnsub0_clock = "none";
   parameter addnsub1_clock = "none";
   parameter zeroacc_clock = "none";
   parameter signa_clock = "none";
   parameter signb_clock = "none";
   parameter output_clock = "none";
   parameter addnsub0_clear = "none";
   parameter addnsub1_clear = "none";
   parameter zeroacc_clear = "none"; 
   parameter signa_clear = "none";
   parameter signb_clear = "none";
   parameter output_clear = "none";
   parameter addnsub0_pipeline_clock = "none";
   parameter addnsub1_pipeline_clock = "none";
   parameter zeroacc_pipeline_clock = "none";
   parameter signa_pipeline_clock = "none";
   parameter signb_pipeline_clock = "none";
   parameter addnsub0_pipeline_clear = "none";
   parameter addnsub1_pipeline_clear = "none";
   parameter zeroacc_pipeline_clear = "none";
   parameter signa_pipeline_clear = "none";
   parameter signb_pipeline_clear = "none";
   parameter lpm_hint           = "true";
   parameter lpm_type           = "stratixgx_mac_out";

// SIMULATION_ONLY_PARAMETERS_BEGIN

   parameter dataout_width = (dataa_width > datab_width ? dataa_width : datab_width)
                                + (datac_width > datad_width ? datac_width : datad_width);
   parameter overflow_programmable_invert = 1'b0;
   parameter data_out_programmable_invert = 72'b0;
   
// SIMULATION_ONLY_PARAMETERS_END

   input [dataa_width-1:0] dataa;
   input [datab_width-1:0] datab;
   input [datac_width-1:0] datac;
   input [datad_width-1:0] datad;
   input 	zeroacc;
   input 	addnsub0;
   input 	addnsub1;
   input 	signa;
   input 	signb;
   input [3:0] 	clk;
   input [3:0] 	aclr;
   input [3:0] 	ena;
   input 	devclrn;
   input 	devpor;
   output [dataout_width-1:0] dataout; 
   output 	 accoverflow;
   
   tri1 devclrn;
   tri1 devpor;
   
   wire [71:0] 	 signa_pipe;
   wire [71:0] 	 signb_pipe;
   wire [71:0] 	 signa_out;
   wire [71:0] 	 signb_out;
   wire [71:0] 	 addnsub0_pipe;
   wire [71:0] 	 addnsub1_pipe;
   wire [71:0] 	 addnsub0_out;
   wire [71:0] 	 addnsub1_out;
   wire [71:0] 	 zeroacc_pipe;
   wire [71:0] 	 zeroacc_out;
   wire [71:0] 	 dataout_wire; 
   wire 	 accoverflow_wire;
   wire [71:0] 	 dataout_tmp;
   wire [71:0] 	 accoverflow_tmp;
   

   stratixgx_mac_register	signa_mac_reg 
      (
       .data ({{(71){1'b0}},signa}),
       .clk (clk[select_the(signa_clock)]),
       .aclr (aclr[select_the(signa_clear)] || ~devclrn || ~devpor), 
       .if_aclr ((signa_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(signa_clock)]),
       .dataout (signa_pipe),
       .async ((signa_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam signa_mac_reg.data_width = 1;
   defparam signa_mac_reg.power_up = 1'b0;
   
   stratixgx_mac_register	signb_mac_reg 
      (
       .data ({{(71){1'b0}},signb}),
       .clk (clk[select_the(signb_clock)]),
       .aclr (aclr[select_the(signb_clear)] || ~devclrn || ~devpor),
       .if_aclr ((signb_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(signb_clock)]),
       .dataout (signb_pipe),
       .async ((signb_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam signb_mac_reg.data_width = 1;
   defparam signb_mac_reg.power_up = 1'b0;

   stratixgx_mac_register	zeroacc_mac_reg 
      (
       .data ({{(71){1'b0}},zeroacc}),
       .clk (clk[select_the(zeroacc_clock)]),
       .aclr (aclr[select_the(zeroacc_clear)] || ~devclrn || ~devpor),
       .if_aclr ((zeroacc_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(zeroacc_clock)]),
       .dataout (zeroacc_pipe),
       .async ((zeroacc_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam zeroacc_mac_reg.data_width = 1;
   defparam zeroacc_mac_reg.power_up = 1'b0;

   stratixgx_mac_register	addnsub0_mac_reg 
      (
       .data ({{(71){1'b0}},addnsub0}),
       .clk (clk[select_the(addnsub0_clock)]),
       .aclr (aclr[select_the(addnsub0_clear)] || ~devclrn || ~devpor),
       .if_aclr ((addnsub0_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(addnsub0_clock)]),
       .dataout (addnsub0_pipe),
       .async ((addnsub0_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam addnsub0_mac_reg.data_width = 1;
   defparam addnsub0_mac_reg.power_up = 1'b0;

   stratixgx_mac_register	addnsub1_mac_reg 
      (
       .data ({{(71){1'b0}},addnsub1}),
       .clk (clk[select_the(addnsub1_clock)]),
       .aclr (aclr[select_the(addnsub1_clear)] || ~devclrn || ~devpor),
       .if_aclr ((addnsub1_clear != "none") ? 1'b1 : 1'b0),
       .ena (ena[select_the(addnsub1_clock)]),
       .dataout (addnsub1_pipe),
       .async ((addnsub1_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam addnsub1_mac_reg.data_width = 1;
   defparam addnsub1_mac_reg.power_up = 1'b0;

   stratixgx_mac_register	signa_mac_pipeline_reg 
      (
       .data (signa_pipe),
       .clk (clk[select_the(signa_pipeline_clock)]),
       .aclr (aclr[select_the(signa_pipeline_clear)] || ~devclrn || ~devpor),
       .if_aclr ((signa_pipeline_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(signa_pipeline_clock)]),
       .dataout (signa_out),
       .async ((signa_pipeline_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam signa_mac_pipeline_reg.data_width = 1;
   defparam signa_mac_pipeline_reg.power_up = 1'b0;
   
   stratixgx_mac_register	signb_mac_pipeline_reg 
      (
       .data (signb_pipe),
       .clk (clk[select_the(signb_pipeline_clock)]),
       .aclr (aclr[select_the(signb_pipeline_clear)] || ~devclrn || ~devpor),
       .if_aclr ((signb_pipeline_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(signb_pipeline_clock)]),
       .dataout (signb_out),
       .async ((signb_pipeline_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam signb_mac_pipeline_reg.data_width = 1;
   defparam signb_mac_pipeline_reg.power_up = 1'b0;
   
   stratixgx_mac_register	zeroacc_mac_pipeline_reg 
      (
       .data (zeroacc_pipe),
       .clk (clk[select_the(zeroacc_pipeline_clock)]),
       .aclr (aclr[select_the(zeroacc_pipeline_clear)] || ~devclrn || ~devpor),
       .if_aclr ((zeroacc_pipeline_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(zeroacc_pipeline_clock)]),
       .dataout (zeroacc_out),
       .async ((zeroacc_pipeline_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam zeroacc_mac_pipeline_reg.data_width = 1;
   defparam zeroacc_mac_pipeline_reg.power_up = 1'b0;
   
   stratixgx_mac_register	addnsub0_mac_pipeline_reg 
      (
       .data (addnsub0_pipe),
       .clk (clk[select_the(addnsub0_pipeline_clock)]),
       .aclr (aclr[select_the(addnsub0_pipeline_clear)] || ~devclrn || ~devpor),
       .if_aclr ((addnsub0_pipeline_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(addnsub0_pipeline_clock)]),
       .dataout (addnsub0_out),
       .async ((addnsub0_pipeline_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam addnsub0_mac_pipeline_reg.data_width = 1;
   defparam addnsub0_mac_pipeline_reg.power_up = 1'b0;

   stratixgx_mac_register	addnsub1_mac_pipeline_reg 
      (
       .data (addnsub1_pipe),
       .clk (clk[select_the(addnsub1_pipeline_clock)]),
       .aclr (aclr[select_the(addnsub1_pipeline_clear)] || ~devclrn || ~devpor),
       .if_aclr ((addnsub1_pipeline_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(addnsub1_pipeline_clock)]),
       .dataout (addnsub1_out),
       .async ((addnsub1_pipeline_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam addnsub1_mac_pipeline_reg.data_width = 1;
   defparam addnsub1_mac_pipeline_reg.power_up = 1'b0;

   stratixgx_mac_out_internal mac_adder 
      (
       .dataa ({{37-dataa_width{1'bz}},dataa}),
       .datab ({{37-datab_width{1'bz}},datab}),
       .datac ({{37-datac_width{1'bz}},datac}),
       .datad ({{37-datad_width{1'bz}},datad}),
       .signx (signa_out[0]),
       .signy (signb_out[0]),
       .addnsub0 (addnsub0_out[0]),
       .addnsub1 (addnsub1_out[0]),
       .zeroacc (zeroacc_out[0]),
       .dataout_global (dataout_tmp[71:0]),
       .dataout (dataout_wire[71:0]),
       .accoverflow (accoverflow_wire)
       );
   defparam mac_adder.dataa_width = dataa_width;
   defparam mac_adder.datab_width = datab_width;
   defparam mac_adder.datac_width = datac_width;
   defparam mac_adder.datad_width = datad_width;
   defparam mac_adder.dataout_width = dataout_width;
   defparam mac_adder.operation_mode = operation_mode;
   
   stratixgx_mac_register	dataout_out_reg 
      (
       .data (dataout_wire),        
       .clk (clk[select_the(output_clock)]),
       .aclr (aclr[select_the(output_clear)] || ~devclrn || ~devpor),
       .if_aclr ((output_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(output_clock)]),
       .dataout (dataout_tmp),
       .async ((output_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam dataout_out_reg.data_width = dataout_width; 
   defparam dataout_out_reg.power_up = 1'b0; 
   
   stratixgx_mac_register	accoverflow_out_reg 
      (
       .data ({{(71){1'b0}},accoverflow_wire}),
       .clk (clk[select_the(output_clock)]),
       .aclr (aclr[select_the(output_clear)] || ~devclrn || ~devpor),
       .if_aclr ((output_clear != "none") ? 1'b1 : 1'b0 ),
       .ena (ena[select_the(output_clock)]),
       .dataout (accoverflow_tmp),
       .async ((output_clock == "none") ? 1'b1 : 1'b0 )
       );
   defparam accoverflow_out_reg.data_width = 1;
   defparam accoverflow_out_reg.power_up = 1'b0;

   assign   dataout = dataout_tmp ^ data_out_programmable_invert;
   assign   accoverflow = accoverflow_tmp[0] ^ overflow_programmable_invert;
   
//////////////////////////////////////////////////////////////////////////////
//
//                                   SELECT_THE
//
//////////////////////////////////////////////////////////////////////////////
   
   function integer select_the;
      input [8*4:1] string_name;
      begin 
	 if (string_name == "0")
	   select_the = 0;
	 else if (string_name == "1")
	   select_the = 1;
	 else if (string_name == "2")
	   select_the = 2;
	 else if (string_name == "3")
	   select_the = 3;
	 else if (string_name == "none")
	   select_the = 0; 
      end 
   endfunction 
   
endmodule

//--------------------------------------------------------------------------
// Module Name     : stratixgx_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixgx_ram_pulse_generator (
                                    clk,
                                    ena,
                                    pulse,
                                    cycle
                                   );
input  clk;   // clock
input  ena;   // pulse enable
output pulse; // pulse
output cycle; // delayed clock

parameter start_delay = 1;
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
// Module Name     : stratixgx_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixgx_ram_register (
                             d,
                             clk,
                             aclr,
                             devclrn,
                             devpor,
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
      $hold   (posedge clk &&& reset, d   , 0, viol_notifier);
      $hold   (posedge clk, aclr, 0, viol_notifier);
      $hold   (posedge clk &&& reset, ena , 0, viol_notifier );
      (posedge clk =>  (q +: q_reg)) = (0,0);
      (posedge aclr => (q +: q_reg)) = (0,0);
endspecify

initial q_reg <= (preset) ? {width{1'b1}} : 'b0;

always @(posedge clk_ipd or posedge aclr_ipd or negedge devclrn or negedge devpor)
begin
    if (aclr_ipd || ~devclrn || ~devpor)
        q_reg <= (preset) ? {width{1'b1}} : 'b0;
              else if (ena_ipd)
        q_reg <= d_ipd;
end
assign aclrout = aclr_ipd;

assign q_opd = q_reg; 

endmodule

`timescale 1 ps/1 ps

`define PRIME 1
`define SEC   0

//--------------------------------------------------------------------------
// Module Name     : stratixgx_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module stratixgx_ram_block
    (
     portadatain,
     portaaddr,
     portawe,
     portbdatain,
     portbaddr,
     portbrewe,
     clk0, clk1,
     ena0, ena1,
     clr0, clr1,
     portabyteenamasks,
     portbbyteenamasks,
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

parameter port_b_data_in_clear = "none";
parameter port_b_address_clear = "none";
parameter port_b_read_enable_write_enable_clear = "none";
parameter port_b_byte_enable_clear = "none";
parameter port_b_data_out_clear = "none";

parameter port_b_data_in_clock = "clock1";
parameter port_b_address_clock = "clock1";
parameter port_b_read_enable_write_enable_clock = "clock1";
parameter port_b_byte_enable_clock = "clock1";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1;
parameter port_b_byte_enable_mask_width = 1;

parameter power_up_uninitialized = "false";
parameter lpm_type = "stratixgx_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

 parameter mem_init0 = 2048'b0;
 parameter mem_init1 = 2560'b0;



// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter port_a_data_in_clear = "none";
parameter port_a_address_clear = "none";
parameter port_a_write_enable_clear = "none";
parameter port_a_byte_enable_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";

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



// LOCAL_PARAMETERS_END

// -------- PORT DECLARATIONS ---------
input portawe;
input [port_a_data_width - 1:0] portadatain;
input [port_a_address_width - 1:0] portaaddr;
input [port_a_byte_enable_mask_width - 1:0] portabyteenamasks;

input portbrewe;
input [port_b_data_width - 1:0] portbdatain;
input [port_b_address_width - 1:0] portbaddr;
input [port_b_byte_enable_mask_width - 1:0] portbbyteenamasks;

input clr0,clr1;
input clk0,clk1;
input ena0,ena1;

input devclrn,devpor;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout;


tri0 portawe_int;
assign portawe_int = portawe;
tri0 [port_a_data_width - 1:0] portadatain_int;
assign portadatain_int = portadatain;
tri0 [port_a_address_width - 1:0] portaaddr_int;
assign portaaddr_int = portaaddr;
tri1 [port_a_byte_enable_mask_width - 1:0] portabyteenamasks_int;
assign portabyteenamasks_int = portabyteenamasks;

tri0 portbrewe_int;
assign portbrewe_int = portbrewe;
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

tri1 devclrn;
tri1 devpor;


// -------- INTERNAL signals ---------
// clock / clock enable
wire clk_a_in,clk_a_byteena,clk_a_out,clkena_a_out;
wire clk_b_in,clk_b_byteena,clk_b_out,clkena_b_out;

wire write_cycle_a,write_cycle_b;

// asynch clear
wire datain_a_clr,dataout_a_clr,datain_b_clr,dataout_b_clr;

wire addr_a_clr,addr_b_clr;
wire byteena_a_clr,byteena_b_clr;
wire we_a_clr,rewe_b_clr;

wire datain_a_clr_in,datain_b_clr_in;
wire addr_a_clr_in,addr_b_clr_in;
wire byteena_a_clr_in,byteena_b_clr_in;
wire we_a_clr_in,rewe_b_clr_in;

reg  mem_invalidate;
wire [`PRIME:`SEC] clear_asserted_during_write;
reg  clear_asserted_during_write_a,clear_asserted_during_write_b;

// port A registers
wire we_a_reg;
wire [port_a_address_width - 1:0] addr_a_reg;
wire [port_a_data_width - 1:0] datain_a_reg, dataout_a_reg;
reg  [port_a_data_width - 1:0] dataout_a;
wire [port_a_byte_enable_mask_width - 1:0] byteena_a_reg;
reg  out_a_is_reg;

// port B registers
wire rewe_b_reg;
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


wire [address_unit_width - 1:0] addr_prime_reg; // registered address
wire [address_width - 1:0]      addr_sec_reg;

wire [data_width - 1:0]       datain_prime_reg; // registered data
wire [data_unit_width - 1:0]  datain_sec_reg;


// pulses for primary/secondary ports
wire write_pulse_prime,write_pulse_sec;
wire read_pulse_prime,read_pulse_sec;
wire read_pulse_prime_feedthru,read_pulse_sec_feedthru;


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
wire  active_a, active_b;
wire  active_a_in, active_b_in;
wire  active_write_a,active_write_b,active_write_clear_a,active_write_clear_b;

reg  mode_is_rom,mode_is_sp,mode_is_bdp; // ram mode
reg  ram_type;                               // ram type eg. MRAM








initial
begin
   ram_type = (ram_block_type == "M-RAM" || ram_block_type == "m-ram" || ram_block_type == "MegaRAM" ||
              (ram_block_type == "auto"  && mixed_port_feed_through_mode == "dont_care" && port_b_read_enable_write_enable_clock == "clock0"));



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
       mem_init = {mem_init1,mem_init0};
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
assign clk_a_byteena = (port_a_byte_enable_clock == "none") ? 1'b0 : clk_a_in;
assign clk_a_out     = (port_a_data_out_clock == "none")    ? 1'b0 : (
                       (port_a_data_out_clock == "clock0")  ? clk0_int : clk1_int);

assign clk_b_in      = (port_b_read_enable_write_enable_clock == "clock0") ? clk0_int : clk1_int;
assign clk_b_byteena = (port_b_byte_enable_clock == "none")   ? 1'b0 : (
                       (port_b_byte_enable_clock == "clock0") ? clk0_int : clk1_int);

assign clk_b_out     = (port_b_data_out_clock == "none")      ? 1'b0 : (
                       (port_b_data_out_clock == "clock0")    ? clk0_int : clk1_int);

assign addr_a_clr_in = (port_a_address_clear == "none")   ? 1'b0 : clr0_int;
assign addr_b_clr_in = (port_b_address_clear == "none")   ? 1'b0 : (
                       (port_b_address_clear == "clear0") ? clr0_int : clr1_int);

assign datain_a_clr_in  = (port_a_data_in_clear == "none")    ? 1'b0 : clr0_int;
assign dataout_a_clr    = (port_a_data_out_clear == "none")   ? 1'b0 : (
                          (port_a_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign datain_b_clr_in  = (port_b_data_in_clear == "none")    ? 1'b0 : (
                         (port_b_data_in_clear == "clear0")  ? clr0_int : clr1_int);
assign dataout_b_clr    = (port_b_data_out_clear == "none")   ? 1'b0 : (
                          (port_b_data_out_clear == "clear0") ? clr0_int : clr1_int);

assign byteena_a_clr_in = (port_a_byte_enable_clear == "none")   ? 1'b0 : clr0_int;
assign byteena_b_clr_in = (port_b_byte_enable_clear == "none")   ? 1'b0 : (
                         (port_b_byte_enable_clear == "clear0") ? clr0_int : clr1_int);

assign we_a_clr_in      = (port_a_write_enable_clear == "none") ? 1'b0 : clr0_int;

assign rewe_b_clr_in    = (port_b_read_enable_write_enable_clear == "none")   ? 1'b0 : (
                          (port_b_read_enable_write_enable_clear == "clear0") ? clr0_int : clr1_int);

  assign active_a_in = ena0_int;


  assign active_b_in = (port_b_read_enable_write_enable_clock == "clock0") ? ena0_int : ena1_int;


// Store clock enable value for SEAB/MEAB
// port A active
stratixgx_ram_register active_port_a (
        .d(active_a_in),
        .clk(clk_a_in),
        .aclr(1'b0),
        .devclrn(1'b1),
        .devpor(1'b1),
        .ena(1'b1),
        .q(active_a),.aclrout()
);
defparam active_port_a.width = 1;

assign active_write_a = active_a && (byteena_a_reg !== 'b0);

// port B active
stratixgx_ram_register active_port_b (
        .d(active_b_in),
        .clk(clk_b_in),
        .aclr(1'b0),
        .devclrn(1'b1),
        .devpor(1'b1),
        .ena(1'b1),
        .q(active_b),.aclrout()
);
defparam active_port_b.width = 1;

assign active_write_b = active_b && (byteena_b_reg !== 'b0);




// ------- A input registers -------
// write enable
stratixgx_ram_register we_a_register (
        .d(mode_is_rom ? 1'b0 : portawe_int),
       .clk(clk_a_in),
        .aclr(we_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
       .ena(active_a_in),
        .q(we_a_reg),
        .aclrout(we_a_clr)
        );
defparam we_a_register.width = 1;


// address
stratixgx_ram_register addr_a_register (
        .d(portaaddr_int),
        .clk(clk_a_in),
        .aclr(addr_a_clr_in),
        .devclrn(devclrn),.devpor(devpor),
        .ena(active_a_in),
        .q(addr_a_reg),
        .aclrout(addr_a_clr)
        );
defparam addr_a_register.width = port_a_address_width;

// data
stratixgx_ram_register datain_a_register (
        .d(portadatain_int),
        .clk(clk_a_in),
        .aclr(datain_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_a_in),
        .q(datain_a_reg),
        .aclrout(datain_a_clr)
        );
defparam datain_a_register.width = port_a_data_width;

// byte enable
stratixgx_ram_register byteena_a_register (
        .d(portabyteenamasks_int),
        .clk(clk_a_byteena),
        .aclr(byteena_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_a_in),
        .q(byteena_a_reg),
        .aclrout(byteena_a_clr)
        );
defparam byteena_a_register.width = port_a_byte_enable_mask_width;
defparam byteena_a_register.preset = 1'b1;

// ------- B input registers -------






// read/write enable
stratixgx_ram_register rewe_b_register (
        .d(portbrewe_int),
        .clk(clk_b_in),
        .aclr(rewe_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_b_in),
        .q(rewe_b_reg),
        .aclrout(rewe_b_clr)
        );
defparam rewe_b_register.width = 1;
defparam rewe_b_register.preset = mode_is_dp;

// address
stratixgx_ram_register addr_b_register (
        .d(portbaddr_int),
        .clk(clk_b_in),
        .aclr(addr_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_b_in),
        .q(addr_b_reg),
        .aclrout(addr_b_clr)
        );
defparam addr_b_register.width = port_b_address_width;

// data
stratixgx_ram_register datain_b_register (
        .d(portbdatain_int),
        .clk(clk_b_in),
        .aclr(datain_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_b_in),
        .q(datain_b_reg),
        .aclrout(datain_b_clr)
        );
defparam datain_b_register.width = port_b_data_width;

// byte enable
stratixgx_ram_register byteena_b_register (
        .d(portbbyteenamasks_int),
        .clk(clk_b_byteena),
        .aclr(byteena_b_clr_in),
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

// Write pulse generation
stratixgx_ram_pulse_generator wpgen_a (
       .clk(ram_type ? clk_a_in : ~clk_a_in),
        .ena(active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );

stratixgx_ram_pulse_generator wpgen_b (
       .clk(ram_type ? clk_b_in : ~clk_b_in),
        .ena(active_write_b & mode_is_bdp & rewe_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );

// Read pulse generation
stratixgx_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
       .ena(active_a & ~we_a_reg),
        .pulse(read_pulse_a),
       .cycle()
        );

stratixgx_ram_pulse_generator rpgen_b (
        .clk(clk_b_in),
       .ena(active_b & (mode_is_dp ? rewe_b_reg : ~rewe_b_reg)),
        .pulse(read_pulse_b),
       .cycle()
        );



assign write_pulse_prime = (primary_port_is_a) ? write_pulse_a : write_pulse_b;
assign read_pulse_prime  = (primary_port_is_a) ? read_pulse_a : read_pulse_b;
assign read_pulse_prime_feedthru = (primary_port_is_a) ? read_pulse_a_feedthru : read_pulse_b_feedthru;

assign write_pulse_sec = (primary_port_is_a) ? write_pulse_b : write_pulse_a;
assign read_pulse_sec  = (primary_port_is_a) ? read_pulse_b : read_pulse_a;
assign read_pulse_sec_feedthru = (primary_port_is_a) ? read_pulse_b_feedthru : read_pulse_a_feedthru;

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
        )
begin


    // Write stage 1 : write X to memory
    if (write_pulse_prime)
    begin
        old_mem_data = mem[addr_prime_reg];
        mem_data = mem[addr_prime_reg] ^ mask_vector_prime_int;
        mem[addr_prime_reg] = mem_data;
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

    if (read_pulse_prime)
       read_data_latch = mem[addr_prime_reg];

    if (read_pulse_sec)
    begin
        row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
        if ((row_sec == addr_prime_reg) && (write_pulse_prime))
            mem_unit_data = old_mem_data;
        else
            mem_unit_data = mem[row_sec];
        for (j = col_sec; j <= col_sec + data_unit_width - 1; j = j + 1)
            read_unit_data_latch[j - col_sec] = mem_unit_data[j];
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




// Same port feed through
stratixgx_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in),
       .ena(active_a & ~mode_is_dp & we_a_reg),
        .pulse(read_pulse_a_feedthru),.cycle()
        );

stratixgx_ram_pulse_generator ftpgen_b (
        .clk(clk_b_in),
       .ena(active_b & mode_is_bdp & rewe_b_reg),
        .pulse(read_pulse_b_feedthru),.cycle()
        );

always @(negedge read_pulse_prime_feedthru)
begin
    if (primary_port_is_a)
       dataout_a = datain_prime_reg ^ mask_vector_prime;
    else
       dataout_b = datain_prime_reg ^ mask_vector_prime;
end

always @(negedge read_pulse_sec_feedthru)
begin
    if (primary_port_is_b)
      dataout_a = datain_sec_reg ^ mask_vector_sec;
    else
       dataout_b = datain_sec_reg ^ mask_vector_sec;
end

// Input register clears

always @(posedge addr_a_clr or posedge datain_a_clr or posedge we_a_clr)
    clear_asserted_during_write_a = write_pulse_a;

assign active_write_clear_a = active_write_a & write_cycle_a;

always @(posedge addr_a_clr)
begin
    if (active_write_clear_a & we_a_reg)
        mem_invalidate = 1'b1;
   else if (active_a & ~we_a_reg)

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
        posedge rewe_b_clr)
    clear_asserted_during_write_b = write_pulse_b;

always @(posedge addr_b_clr)
begin
   if (mode_is_bdp & active_write_clear_b & rewe_b_reg)
        mem_invalidate = 1'b1;
   else if (active_b & (mode_is_dp & rewe_b_reg || mode_is_bdp & ~rewe_b_reg))
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

always @(posedge datain_b_clr or posedge rewe_b_clr)
begin
   if (mode_is_bdp & active_write_clear_b & rewe_b_reg)

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




// ------- Output registers --------

assign clkena_a_out = (port_a_data_out_clock == "clock0") ? ena0_int : ena1_int;

stratixgx_ram_register dataout_a_register (
        .d(dataout_a),
        .clk(clk_a_out),
        .aclr(dataout_a_clr),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(clkena_a_out),
        .q(dataout_a_reg),.aclrout()
        );
defparam dataout_a_register.width = port_a_data_width;

assign portadataout = (out_a_is_reg) ? dataout_a_reg : dataout_a;


assign clkena_b_out = (port_b_data_out_clock == "clock0") ? ena0_int : ena1_int;

stratixgx_ram_register dataout_b_register (
        .d( dataout_b ),
        .clk(clk_b_out),
        .aclr(dataout_b_clr),
        .devclrn(devclrn),.devpor(devpor),
        .ena(clkena_b_out),
        .q(dataout_b_reg),.aclrout()
        );
defparam dataout_b_register.width = port_b_data_width;

assign portbdataout = (out_b_is_reg) ? dataout_b_reg : dataout_b;


endmodule // stratixgx_ram_block




///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the Stratixgx PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixgx_m_cntr  (clk,
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
        end
        else begin
            if (clk_last_value !== clk)
            begin
                if (clk === 1'b1 && first_rising_edge)
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
        end
        clk_last_value = clk;

        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // stratixgx_m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the Stratixgx PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixgx_n_cntr  (clk,
                        reset,
                        cout,
                        modulus,
                        time_delay);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg clk_last_valid_value;
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
            if (clk_last_value !== clk)
            begin
                if (clk === 1'bx)
                begin
                    $display("Warning : Invalid transition to 'X' detected on PLL input clk. This edge will be ignored.");
                    $display("Time: %0t  Instance: %m", $time);
                end
                else if ((clk === 1'b1) && first_rising_edge)
                begin
                    first_rising_edge = 0;
                    tmp_cout = clk;
                end
                else if ((first_rising_edge == 0) && (clk_last_valid_value !== clk))
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
        end
        clk_last_value = clk;
        if (clk !== 1'bx)
            clk_last_valid_value = clk;

        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // stratixgx_n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the L0, L1, G0, G1, G2, G3, E0,
//               E1, E2 and E3 output counters of the Stratixgx PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixgx_scale_cntr  (clk,
                            reset,
                            cout,
                            high,
                            low,
                            initial_value,
                            mode,
                            time_delay,
                            ph_tap);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] high;
    input [31:0] low;
    input [31:0] initial_value;
    input [8*6:1] mode;
    input [31:0] time_delay;
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
    reg [31:0] high_reg;
    reg [31:0] low_reg;
    reg high_cnt_xfer_done;

    initial
    begin
        count = 1;
        first_rising_edge = 0;
        tmp_cout = 0;
        output_shift_count = 0;
        high_cnt_xfer_done = 0;
    end

    always @(clk or reset)
    begin
        if (init !== 1'b1)
        begin
            high_reg = high;
            low_reg = low;
            clk_last_value = 0;
            init = 1'b1;
        end
        if (reset)
        begin
            count = 1;
            output_shift_count = 0;
            tmp_cout = 0;
            first_rising_edge = 0;
        end
        else if (clk_last_value !== clk)
        begin
            if (mode == "off")
                tmp_cout = 0;
            else if (mode == "bypass")
                tmp_cout = clk;
            else if (first_rising_edge == 0)
            begin
                if (clk == 1)
                begin
                    output_shift_count = output_shift_count + 1;
                    if (output_shift_count == initial_value)
                    begin
                        tmp_cout = clk;
                        first_rising_edge = 1;
                    end
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
                if (mode == "even" && (count == (high_reg*2) + 1))
                begin
                    tmp_cout = 0;
                    if (high_cnt_xfer_done === 1'b1)
                    begin
                        low_reg = low;
                        high_cnt_xfer_done = 0;
                    end
                end
                else if (mode == "odd" && (count == (high_reg*2)))
                begin
                    tmp_cout = 0;
                    if (high_cnt_xfer_done === 1'b1)
                    begin
                        low_reg = low;
                        high_cnt_xfer_done = 0;
                    end
                end
                else if (count == (high_reg + low_reg)*2 + 1)
                begin
                    tmp_cout = 1;
                    count = 1;        // reset count
                    if (high_reg != high)
                    begin
                        high_reg = high;
                        high_cnt_xfer_done = 1;
                    end
                end
            end
        end
        clk_last_value = clk;
        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // stratixgx_scale_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixgx_pll_reg (q,
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

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q = 0;

    always @ (posedge clk or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q <= 1;
        else if (clrn == 1'b0)
            q <= 0;
        else if ((clk == 1) & (ena == 1'b1))
            q <= d;
    end

endmodule // stratixgx_pll_reg

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_pll
//
// Description : Timing simulation model for the Stratixgx StratixgxGX PLL.
//               In the functional mode, it is also the model for the altpll
//               megafunction.
// 
// Limitations : Does not support Spread Spectrum and Bandwidth.
//
// Outputs     : Up to 10 output clocks, each defined by its own set of
//               parameters. Locked output (active high) indicates when the
//               PLL locks. clkbad, clkloss and activeclock are used for
//               clock switchover to indicate which input clock has gone
//               bad, when the clock switchover initiates and which input
//               clock is being used as the reference, respectively.
//               scandataout is the data output of the serial scan chain.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
`define WORD_LENGTH 18

module stratixgx_pll (inclk,
                    fbin,
                    ena,
                    clkswitch,
                    areset,
                    pfdena,
                    clkena,
                    extclkena,
                    scanclk,
                    scanaclr,
                    scandata,
                    clk,
                    extclk,
                    clkbad,
                    activeclock,
                    locked,
                    clkloss,
                    scandataout,
                    // lvds mode specific ports
                    comparator,
                    enable0,
                    enable1);

    parameter operation_mode = "normal";
    parameter qualify_conf_done = "off";
    parameter compensate_clock = "clk0";
    parameter pll_type = "auto";
    parameter scan_chain = "long";
    parameter lpm_type = "stratixgx_pll";

    parameter clk0_multiply_by = 1;
    parameter clk0_divide_by = 1;
    parameter clk0_phase_shift = 0;
    parameter clk0_time_delay = 0;
    parameter clk0_duty_cycle = 50;

    parameter clk1_multiply_by = 1;
    parameter clk1_divide_by = 1;
    parameter clk1_phase_shift = 0;
    parameter clk1_time_delay = 0;
    parameter clk1_duty_cycle = 50;

    parameter clk2_multiply_by = 1;
    parameter clk2_divide_by = 1;
    parameter clk2_phase_shift = 0;
    parameter clk2_time_delay = 0;
    parameter clk2_duty_cycle = 50;

    parameter clk3_multiply_by = 1;
    parameter clk3_divide_by = 1;
    parameter clk3_phase_shift = 0;
    parameter clk3_time_delay = 0;
    parameter clk3_duty_cycle = 50;

    parameter clk4_multiply_by = 1;
    parameter clk4_divide_by = 1;
    parameter clk4_phase_shift = 0;
    parameter clk4_time_delay = 0;
    parameter clk4_duty_cycle = 50;

    parameter clk5_multiply_by = 1;
    parameter clk5_divide_by = 1;
    parameter clk5_phase_shift = 0;
    parameter clk5_time_delay = 0;
    parameter clk5_duty_cycle = 50;

    parameter extclk0_multiply_by = 1;
    parameter extclk0_divide_by = 1;
    parameter extclk0_phase_shift = 0;
    parameter extclk0_time_delay = 0;
    parameter extclk0_duty_cycle = 50;

    parameter extclk1_multiply_by = 1;
    parameter extclk1_divide_by = 1;
    parameter extclk1_phase_shift = 0;
    parameter extclk1_time_delay = 0;
    parameter extclk1_duty_cycle = 50;

    parameter extclk2_multiply_by = 1;
    parameter extclk2_divide_by = 1;
    parameter extclk2_phase_shift = 0;
    parameter extclk2_time_delay = 0;
    parameter extclk2_duty_cycle = 50;

    parameter extclk3_multiply_by = 1;
    parameter extclk3_divide_by = 1;
    parameter extclk3_phase_shift = 0;
    parameter extclk3_time_delay = 0;
    parameter extclk3_duty_cycle = 50;

    parameter primary_clock = "inclk0";
    parameter inclk0_input_frequency = 10000;
    parameter inclk1_input_frequency = 10000;
    parameter gate_lock_signal = "no";
    parameter gate_lock_counter = 1;
    parameter valid_lock_multiplier = 5;
    parameter invalid_lock_multiplier = 5;

    parameter switch_over_on_lossclk = "off";
    parameter switch_over_on_gated_lock = "off";
    parameter switch_over_counter = 1;
    parameter enable_switch_over_counter = "off";
    parameter feedback_source = "extclk0";
    parameter bandwidth = 0;
    parameter bandwidth_type = "auto";
    parameter spread_frequency = 0;
    parameter common_rx_tx = "off";
    parameter rx_outclock_resource = "auto";
    parameter use_vco_bypass = "false";
    parameter use_dc_coupling = "false";

    parameter pfd_min = 0;
    parameter pfd_max = 0;
    parameter vco_min = 0;
    parameter vco_max = 0;
    parameter vco_center = 0;

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 0;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;

    parameter l0_high = 1;
    parameter l0_low = 1;
    parameter l0_initial = 1;
    parameter l0_mode = "bypass";
    parameter l0_ph = 0;
    parameter l0_time_delay = 0;

    parameter l1_high = 1;
    parameter l1_low = 1;
    parameter l1_initial = 1;
    parameter l1_mode = "bypass";
    parameter l1_ph = 0;
    parameter l1_time_delay = 0;

    parameter g0_high = 1;
    parameter g0_low = 1;
    parameter g0_initial = 1;
    parameter g0_mode = "bypass";
    parameter g0_ph = 0;
    parameter g0_time_delay = 0;

    parameter g1_high = 1;
    parameter g1_low = 1;
    parameter g1_initial = 1;
    parameter g1_mode = "bypass";
    parameter g1_ph = 0;
    parameter g1_time_delay = 0;

    parameter g2_high = 1;
    parameter g2_low = 1;
    parameter g2_initial = 1;
    parameter g2_mode = "bypass";
    parameter g2_ph = 0;
    parameter g2_time_delay = 0;

    parameter g3_high = 1;
    parameter g3_low = 1;
    parameter g3_initial = 1;
    parameter g3_mode = "bypass";
    parameter g3_ph = 0;
    parameter g3_time_delay = 0;

    parameter e0_high = 1;
    parameter e0_low = 1;
    parameter e0_initial = 1;
    parameter e0_mode = "bypass";
    parameter e0_ph = 0;
    parameter e0_time_delay = 0;

    parameter e1_high = 1;
    parameter e1_low = 1;
    parameter e1_initial = 1;
    parameter e1_mode = "bypass";
    parameter e1_ph = 0;
    parameter e1_time_delay = 0;

    parameter e2_high = 1;
    parameter e2_low = 1;
    parameter e2_initial = 1;
    parameter e2_mode = "bypass";
    parameter e2_ph = 0;
    parameter e2_time_delay = 0;

    parameter e3_high = 1;
    parameter e3_low = 1;
    parameter e3_initial = 1;
    parameter e3_mode = "bypass";
    parameter e3_ph = 0;
    parameter e3_time_delay = 0;

    parameter m_ph = 0;
    parameter m_time_delay = 0;
    parameter n_time_delay = 0;

    parameter extclk0_counter = "e0";
    parameter extclk1_counter = "e1";
    parameter extclk2_counter = "e2";
    parameter extclk3_counter = "e3";

    parameter clk0_counter = "g0";
    parameter clk1_counter = "g1";
    parameter clk2_counter = "g2";
    parameter clk3_counter = "g3";
    parameter clk4_counter = "l0";
    parameter clk5_counter = "l1";

    // LVDS mode parameters
    parameter enable0_counter = "l0";
    parameter enable1_counter = "l0";

    parameter charge_pump_current = 0;
    parameter loop_filter_r = "1.0";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "timing";
    parameter source_is_pll = "off";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter down_spread = "0.0";

    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;
    parameter family_name = "Stratixgx";

    parameter skip_vco = "off";

    parameter clk0_use_even_counter_mode = "off";
    parameter clk1_use_even_counter_mode = "off";
    parameter clk2_use_even_counter_mode = "off";
    parameter clk3_use_even_counter_mode = "off";
    parameter clk4_use_even_counter_mode = "off";
    parameter clk5_use_even_counter_mode = "off";
    parameter extclk0_use_even_counter_mode = "off";
    parameter extclk1_use_even_counter_mode = "off";
    parameter extclk2_use_even_counter_mode = "off";
    parameter extclk3_use_even_counter_mode = "off";

    parameter clk0_use_even_counter_value = "off";
    parameter clk1_use_even_counter_value = "off";
    parameter clk2_use_even_counter_value = "off";
    parameter clk3_use_even_counter_value = "off";
    parameter clk4_use_even_counter_value = "off";
    parameter clk5_use_even_counter_value = "off";
    parameter extclk0_use_even_counter_value = "off";
    parameter extclk1_use_even_counter_value = "off";
    parameter extclk2_use_even_counter_value = "off";
    parameter extclk3_use_even_counter_value = "off";

// SIMULATION_ONLY_PARAMETERS_END

    parameter scan_chain_mif_file = "";

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input [5:0] clkena;
    input [3:0] extclkena;
    input scanclk;
    input scanaclr;
    input scandata;
    // lvds specific input ports
    input comparator;

    // OUTPUT PORTS
    output [5:0] clk;
    output [3:0] extclk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    // lvds specific output ports
    output enable0;
    output enable1;

    // BUFFER INPUTS
    wire inclk0_ipd;
    wire inclk1_ipd;
    wire ena_ipd;
    wire fbin_ipd;
    wire areset_ipd;
    wire pfdena_ipd;
    wire clkena0_ipd;
    wire clkena1_ipd;
    wire clkena2_ipd;
    wire clkena3_ipd;
    wire clkena4_ipd;
    wire clkena5_ipd;
    wire extclkena0_ipd;
    wire extclkena1_ipd;
    wire extclkena2_ipd;
    wire extclkena3_ipd;
    wire scanclk_ipd;
    wire scanaclr_ipd;
    wire scandata_ipd;
    wire comparator_ipd;
    wire clkswitch_ipd;

    buf (inclk0_ipd, inclk[0]);
    buf (inclk1_ipd, inclk[1]);
    buf (ena_ipd, ena);
    buf (fbin_ipd, fbin);
    buf (areset_ipd, areset);
    buf (pfdena_ipd, pfdena);
    buf (clkena0_ipd, clkena[0]);
    buf (clkena1_ipd, clkena[1]);
    buf (clkena2_ipd, clkena[2]);
    buf (clkena3_ipd, clkena[3]);
    buf (clkena4_ipd, clkena[4]);
    buf (clkena5_ipd, clkena[5]);
    buf (extclkena0_ipd, extclkena[0]);
    buf (extclkena1_ipd, extclkena[1]);
    buf (extclkena2_ipd, extclkena[2]);
    buf (extclkena3_ipd, extclkena[3]);
    buf (scanclk_ipd, scanclk);
    buf (scanaclr_ipd, scanaclr);
    buf (scandata_ipd, scandata);
    buf (comparator_ipd, comparator);
    buf (clkswitch_ipd, clkswitch);

    // INTERNAL VARIABLES AND NETS
    integer scan_chain_length;
    integer i;
    integer j;
    integer k;
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
    integer primary_clock_frequency;
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
    integer l0_count;
    integer l1_count;
    integer loop_xplier;
    integer loop_initial;
    integer loop_ph;
    integer loop_time_delay;
    integer cycle_to_adjust;
    integer total_pull_back;
    integer pull_back_M;
    integer pull_back_ext_cntr;

    time    fbclk_time;
    time    first_fbclk_time;
    time    refclk_time;
    time    scanaclr_rising_time;
    time    scanaclr_falling_time;
 
    reg got_first_refclk;
    reg got_second_refclk;
    reg got_first_fbclk;
    reg refclk_last_value;
    reg fbclk_last_value;
    reg inclk_last_value;
    reg pll_is_locked;
    reg pll_about_to_lock;
    reg locked_tmp;
    reg l0_got_first_rising_edge;
    reg l1_got_first_rising_edge;
    reg vco_l0_last_value;
    reg vco_l1_last_value;
    reg areset_ipd_last_value;
    reg ena_ipd_last_value;
    reg pfdena_ipd_last_value;
    reg inclk_out_of_range;
    reg schedule_vco_last_value;

    reg gate_out;
    reg vco_val;

    reg [31:0] m_initial_val;
    reg [31:0] m_val;
    reg [31:0] m_val_tmp;
    reg [31:0] m2_val;
    reg [31:0] n_val;
    reg [31:0] n_val_tmp;
    reg [31:0] n2_val;
    reg [31:0] m_time_delay_val;
    reg [31:0] n_time_delay_val;
    reg [31:0] m_delay;
    reg [8*6:1] m_mode_val;
    reg [8*6:1] m2_mode_val;
    reg [8*6:1] n_mode_val;
    reg [8*6:1] n2_mode_val;
    reg [31:0] l0_high_val;
    reg [31:0] l0_low_val;
    reg [31:0] l0_initial_val;
    reg [31:0] l0_time_delay_val;
    reg [8*6:1] l0_mode_val;
    reg [31:0] l1_high_val;
    reg [31:0] l1_low_val;
    reg [31:0] l1_initial_val;
    reg [31:0] l1_time_delay_val;
    reg [8*6:1] l1_mode_val;

    reg [31:0] g0_high_val;
    reg [31:0] g0_low_val;
    reg [31:0] g0_initial_val;
    reg [31:0] g0_time_delay_val;
    reg [8*6:1] g0_mode_val;

    reg [31:0] g1_high_val;
    reg [31:0] g1_low_val;
    reg [31:0] g1_initial_val;
    reg [31:0] g1_time_delay_val;
    reg [8*6:1] g1_mode_val;

    reg [31:0] g2_high_val;
    reg [31:0] g2_low_val;
    reg [31:0] g2_initial_val;
    reg [31:0] g2_time_delay_val;
    reg [8*6:1] g2_mode_val;

    reg [31:0] g3_high_val;
    reg [31:0] g3_low_val;
    reg [31:0] g3_initial_val;
    reg [31:0] g3_time_delay_val;
    reg [8*6:1] g3_mode_val;

    reg [31:0] e0_high_val;
    reg [31:0] e0_low_val;
    reg [31:0] e0_initial_val;
    reg [31:0] e0_time_delay_val;
    reg [8*6:1] e0_mode_val;

    reg [31:0] e1_high_val;
    reg [31:0] e1_low_val;
    reg [31:0] e1_initial_val;
    reg [31:0] e1_time_delay_val;
    reg [8*6:1] e1_mode_val;

    reg [31:0] e2_high_val;
    reg [31:0] e2_low_val;
    reg [31:0] e2_initial_val;
    reg [31:0] e2_time_delay_val;
    reg [8*6:1] e2_mode_val;

    reg [31:0] e3_high_val;
    reg [31:0] e3_low_val;
    reg [31:0] e3_initial_val;
    reg [31:0] e3_time_delay_val;
    reg [8*6:1] e3_mode_val;

    reg scanclk_last_value;
    reg scanaclr_last_value;
    reg transfer;
    reg transfer_enable;
    reg [288:0] scan_data;
    reg schedule_vco;
    reg schedule_offset;
    reg stop_vco;
    reg inclk_n;

    reg [7:0] vco_out;
    wire inclk_l0;
    wire inclk_l1;
    wire inclk_m;
    wire clk0_tmp;
    wire clk1_tmp;
    wire clk2_tmp;
    wire clk3_tmp;
    wire clk4_tmp;
    wire clk5_tmp;
    wire extclk0_tmp;
    wire extclk1_tmp;
    wire extclk2_tmp;
    wire extclk3_tmp;
    wire nce_l0;
    wire nce_l1;
    wire nce_temp;

    reg vco_l0;
    reg vco_l1;

    wire clk0;
    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    wire clk5;
    wire extclk0;
    wire extclk1;
    wire extclk2;
    wire extclk3;
    wire ena0;
    wire ena1;
    wire ena2;
    wire ena3;
    wire ena4;
    wire ena5;
    wire extena0;
    wire extena1;
    wire extena2;
    wire extena3;
    wire refclk;
    wire fbclk;
    wire l0_clk;
    wire l1_clk;
    wire g0_clk;
    wire g1_clk;
    wire g2_clk;
    wire g3_clk;
    wire e0_clk;
    wire e1_clk;
    wire e2_clk;
    wire e3_clk;
    wire dffa_out;
    wire dffb_out;
    wire dffc_out;
    wire dffd_out;
    wire lvds_dffb_clk;
    wire lvds_dffc_clk;
    wire lvds_dffd_clk;
    
    reg first_schedule;

    wire enable0_tmp;
    wire enable1_tmp;
    wire enable_0;
    wire enable_1;
    reg l0_tmp;
    reg l1_tmp;

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    // for external feedback mode

    reg [31:0] ext_fbk_cntr_high;
    reg [31:0] ext_fbk_cntr_low;
    reg [31:0] ext_fbk_cntr_modulus;
    reg [31:0] ext_fbk_cntr_delay;
    reg [8*2:1] ext_fbk_cntr;
    reg [8*6:1] ext_fbk_cntr_mode;
    integer ext_fbk_cntr_ph;
    integer ext_fbk_cntr_initial;

    wire inclk_e0;
    wire inclk_e1;
    wire inclk_e2;
    wire inclk_e3;
    wire [31:0] cntr_e0_initial;
    wire [31:0] cntr_e1_initial;
    wire [31:0] cntr_e2_initial;
    wire [31:0] cntr_e3_initial;
    wire [31:0] cntr_e0_delay;
    wire [31:0] cntr_e1_delay;
    wire [31:0] cntr_e2_delay;
    wire [31:0] cntr_e3_delay;
    reg  [31:0] ext_fbk_delay;

    // variables for clk_switch
    reg clk0_is_bad;
    reg clk1_is_bad;
    reg inclk0_last_value;
    reg inclk1_last_value;
    reg other_clock_value;
    reg other_clock_last_value;
    reg primary_clk_is_bad;
    reg current_clk_is_bad;
    reg external_switch;
//    reg [8*6:1] current_clock;
    reg active_clock;
    reg clkloss_tmp;
    reg got_curr_clk_falling_edge_after_clkswitch;
    reg active_clk_was_switched;

    integer clk0_count;
    integer clk1_count;
    integer switch_over_count;

    reg scandataout_tmp;
    reg scandataout_trigger;
    integer quiet_time;
    reg pll_in_quiet_period;
    time start_quiet_time;
    reg quiet_period_violation;
    reg reconfig_err;
    reg scanclr_violation;
    reg scanclr_clk_violation;
    reg got_first_scanclk_after_scanclr_inactive_edge;
    reg error;

    reg no_warn;

// LOCAL_PARAMETERS_BEGIN

    parameter EGPP_SCAN_CHAIN = 289;
    parameter GPP_SCAN_CHAIN = 193;
    parameter TRST = 5000;
    parameter TRSTCLK = 5000;

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
    integer i_extclk0_mult_by;
    integer i_extclk0_div_by;
    integer i_extclk1_mult_by;
    integer i_extclk1_div_by;
    integer i_extclk2_mult_by;
    integer i_extclk2_div_by;
    integer i_extclk3_mult_by;
    integer i_extclk3_div_by;
    integer max_d_value;
    integer new_multiplier;

    // internal variables for storing the phase shift number.(used in lvds mode only)
    integer i_clk0_phase_shift;
    integer i_clk1_phase_shift;
    integer i_clk2_phase_shift;

    // user to advanced internal signals

    integer   i_m_initial;
    integer   i_m;
    integer   i_n;
    integer   i_m2;
    integer   i_n2;
    integer   i_ss;
    integer   i_l0_high;
    integer   i_l1_high;
    integer   i_g0_high;
    integer   i_g1_high;
    integer   i_g2_high;
    integer   i_g3_high;
    integer   i_e0_high;
    integer   i_e1_high;
    integer   i_e2_high;
    integer   i_e3_high;
    integer   i_l0_low;
    integer   i_l1_low;
    integer   i_g0_low;
    integer   i_g1_low;
    integer   i_g2_low;
    integer   i_g3_low;
    integer   i_e0_low;
    integer   i_e1_low;
    integer   i_e2_low;
    integer   i_e3_low;
    integer   i_l0_initial;
    integer   i_l1_initial;
    integer   i_g0_initial;
    integer   i_g1_initial;
    integer   i_g2_initial;
    integer   i_g3_initial;
    integer   i_e0_initial;
    integer   i_e1_initial;
    integer   i_e2_initial;
    integer   i_e3_initial;
    reg [8*6:1]   i_l0_mode;
    reg [8*6:1]   i_l1_mode;
    reg [8*6:1]   i_g0_mode;
    reg [8*6:1]   i_g1_mode;
    reg [8*6:1]   i_g2_mode;
    reg [8*6:1]   i_g3_mode;
    reg [8*6:1]   i_e0_mode;
    reg [8*6:1]   i_e1_mode;
    reg [8*6:1]   i_e2_mode;
    reg [8*6:1]   i_e3_mode;
    integer   i_vco_min;
    integer   i_vco_max;
    integer   i_vco_center;
    integer   i_pfd_min;
    integer   i_pfd_max;
    integer   i_l0_ph;
    integer   i_l1_ph;
    integer   i_g0_ph;
    integer   i_g1_ph;
    integer   i_g2_ph;
    integer   i_g3_ph;
    integer   i_e0_ph;
    integer   i_e1_ph;
    integer   i_e2_ph;
    integer   i_e3_ph;
    integer   i_m_ph;
    integer   m_ph_val;
    integer   i_l0_time_delay;
    integer   i_l1_time_delay;
    integer   i_g0_time_delay;
    integer   i_g1_time_delay;
    integer   i_g2_time_delay;
    integer   i_g3_time_delay;
    integer   i_e0_time_delay;
    integer   i_e1_time_delay;
    integer   i_e2_time_delay;
    integer   i_e3_time_delay;
    integer   i_m_time_delay;
    integer   i_n_time_delay;
    integer   i_extclk3_counter;
    integer   i_extclk2_counter;
    integer   i_extclk1_counter;
    integer   i_extclk0_counter;
    integer   i_clk5_counter;
    integer   i_clk4_counter;
    integer   i_clk3_counter;
    integer   i_clk2_counter;
    integer   i_clk1_counter;
    integer   i_clk0_counter;
    integer   i_charge_pump_current;
    integer   i_loop_filter_r;
    integer   max_neg_abs;
    integer   output_count;
    integer   new_divisor;

    reg pll_is_in_reset;

    // uppercase to lowercase parameter values
    reg [8*`WORD_LENGTH:1] l_operation_mode;
    reg [8*`WORD_LENGTH:1] l_pll_type;
    reg [8*`WORD_LENGTH:1] l_qualify_conf_done;
    reg [8*`WORD_LENGTH:1] l_compensate_clock;
    reg [8*`WORD_LENGTH:1] l_scan_chain;
    reg [8*`WORD_LENGTH:1] l_primary_clock;
    reg [8*`WORD_LENGTH:1] l_gate_lock_signal;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_lossclk;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_gated_lock;
    reg [8*`WORD_LENGTH:1] l_enable_switch_over_counter;
    reg [8*`WORD_LENGTH:1] l_feedback_source;
    reg [8*`WORD_LENGTH:1] l_bandwidth_type;
    reg [8*`WORD_LENGTH:1] l_simulation_type;
    reg [8*`WORD_LENGTH:1] l_enable0_counter;
    reg [8*`WORD_LENGTH:1] l_enable1_counter;

    integer current_clock;
    reg is_fast_pll;
    reg op_mode;

    reg init;

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
        num = numerator;
        den = denominator;
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
                    if ((m_value == 0) || (d_value == 0))
                    begin
                        fraction_num = numerator;
                        fraction_div = denominator;
                    end
                    else
                    begin
                        fraction_num = m_value;
                        fraction_div = d_value;
                    end
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
    input L0, L0_mode, L1, L1_mode, G0, G0_mode, G1, G1_mode, G2, G2_mode, G3, G3_mode, E0, E0_mode, E1, E1_mode, E2, E2_mode, E3, E3_mode, scan_chain, refclk, m_mod;
    integer L0, L1, G0, G1, G2, G3, E0, E1, E2, E3;
    reg [8*6:1] L0_mode, L1_mode, G0_mode, G1_mode, G2_mode, G3_mode, E0_mode, E1_mode, E2_mode, E3_mode;
    reg [8*5:1] scan_chain;
    integer refclk;
    reg [31:0] m_mod;
    integer max_modulus;
    begin
        max_modulus = 1;
        if (L0_mode != "bypass" && L0_mode != "   off")
            max_modulus = L0;
        if (L1 > max_modulus && L1_mode != "bypass" && L1_mode != "   off")
            max_modulus = L1;
        if (G0 > max_modulus && G0_mode != "bypass" && G0_mode != "   off")
            max_modulus = G0;
        if (G1 > max_modulus && G1_mode != "bypass" && G1_mode != "   off")
            max_modulus = G1;
        if (G2 > max_modulus && G2_mode != "bypass" && G2_mode != "   off")
            max_modulus = G2;
        if (G3 > max_modulus && G3_mode != "bypass" && G3_mode != "   off")
            max_modulus = G3;
        if (scan_chain == "long")
        begin
            if (E0 > max_modulus && E0_mode != "bypass" && E0_mode != "   off")
                max_modulus = E0;
            if (E1 > max_modulus && E1_mode != "bypass" && E1_mode != "   off")
                max_modulus = E1;
            if (E2 > max_modulus && E2_mode != "bypass" && E2_mode != "   off")
                max_modulus = E2;
            if (E3 > max_modulus && E3_mode != "bypass" && E3_mode != "   off")
                max_modulus = E3;
        end

        slowest_clk = ((refclk/m_mod) * max_modulus *2);
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
        if (R == 0)    // if evenly divisible then L is gcd else it is 1.
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
            R = scale_num(M9,3);
        else
            R = M9;
        lcm = R; 
    end
    endfunction

    // find the factor of division of the output clock frequency
    // compared to the VCO
    function integer output_counter_value;
    input clk_divide, clk_mult, M, N;
    integer clk_divide, clk_mult, M, N;
    integer R;
    begin
        R = (clk_divide * M)/(clk_mult * N);
        output_counter_value = R;
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
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        if (output_counter_value == 1)
            R = "bypass";
        else if ((half_cycle_high % 2) == 0)
            R = "even";
        else
            R = "odd";
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
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
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
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_h = tmp_counter_high + !mode;
        counter_low =  output_counter_value - counter_h;
        if (counter_low == 0)
            counter_low = 1;
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

    // find the actual time delay for each PLL counter
    function integer counter_time_delay;
    input clk_time_delay, m_time_delay, n_time_delay;
    integer clk_time_delay, m_time_delay, n_time_delay;
    begin
        counter_time_delay = clk_time_delay + m_time_delay - n_time_delay;
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
        phase = ((tap_phase * m) / (360 * n)) + 0.5;
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
        counter_ph = (phase % 360) / 45;
    end
    endfunction

    // convert the given string to length 6 by padding with spaces
    function [8*6:1] translate_string;
    input mode;
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

    // this is for stratixgx lvds only
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
        result = (phase_shift * 360) / inclk0_input_frequency;
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

    initial
    begin
        // convert string parameter values from uppercase to lowercase,
        // as expected in this model
        l_operation_mode             = alpha_tolower(operation_mode);
        l_pll_type                   = alpha_tolower(pll_type);
        l_qualify_conf_done          = alpha_tolower(qualify_conf_done);
        l_compensate_clock           = alpha_tolower(compensate_clock);
        l_scan_chain                 = alpha_tolower(scan_chain);
        l_primary_clock              = alpha_tolower(primary_clock);
        l_gate_lock_signal           = alpha_tolower(gate_lock_signal);
        l_switch_over_on_lossclk     = alpha_tolower(switch_over_on_lossclk);
        l_switch_over_on_gated_lock  = alpha_tolower(switch_over_on_gated_lock);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_feedback_source            = alpha_tolower(feedback_source);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);
        l_enable0_counter            = alpha_tolower(enable0_counter);
        l_enable1_counter            = alpha_tolower(enable1_counter);

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
            find_simple_integer_fraction(extclk0_multiply_by, extclk0_divide_by,
                            max_d_value, i_extclk0_mult_by, i_extclk0_div_by);
            find_simple_integer_fraction(extclk1_multiply_by, extclk1_divide_by,
                            max_d_value, i_extclk1_mult_by, i_extclk1_div_by);
            find_simple_integer_fraction(extclk2_multiply_by, extclk2_divide_by,
                            max_d_value, i_extclk2_mult_by, i_extclk2_div_by);
            find_simple_integer_fraction(extclk3_multiply_by, extclk3_divide_by,
                            max_d_value, i_extclk3_mult_by, i_extclk3_div_by);

            // convert user parameters to advanced
            i_n = 1;
            if (l_pll_type == "lvds")
                i_m = clk0_multiply_by;
            else
                i_m = lcm  (i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,
                            i_clk4_mult_by, i_clk5_mult_by,
                            i_extclk0_mult_by,
                            i_extclk1_mult_by, i_extclk2_mult_by,
                            i_extclk3_mult_by, inclk0_input_frequency);
            i_m_time_delay = maxnegabs (str2int(clk0_time_delay),
                                        str2int(clk1_time_delay),
                                        str2int(clk2_time_delay),
                                        str2int(clk3_time_delay),
                                        str2int(clk4_time_delay),
                                        str2int(clk5_time_delay),
                                        str2int(extclk0_time_delay),
                                        str2int(extclk1_time_delay),
                                        str2int(extclk2_time_delay),
                                        str2int(extclk3_time_delay));
            i_n_time_delay = mintimedelay(str2int(clk0_time_delay),
                                        str2int(clk1_time_delay),
                                        str2int(clk2_time_delay),
                                        str2int(clk3_time_delay),
                                        str2int(clk4_time_delay),
                                        str2int(clk5_time_delay),
                                        str2int(extclk0_time_delay),
                                        str2int(extclk1_time_delay),
                                        str2int(extclk2_time_delay),
                                        str2int(extclk3_time_delay));
            if (l_pll_type == "lvds")
                i_g0_high = counter_high(output_counter_value(i_clk2_div_by,
                            i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
            else
                i_g0_high = counter_high(output_counter_value(i_clk0_div_by,
                            i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);

            
            i_g1_high = counter_high(output_counter_value(i_clk1_div_by,
                        i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
            i_g2_high = counter_high(output_counter_value(i_clk2_div_by,
                        i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
            i_g3_high = counter_high(output_counter_value(i_clk3_div_by,
                        i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
            if (l_pll_type == "lvds")
            begin
                i_l0_high = i_g0_high;
                i_l1_high = i_g0_high;
            end
            else
            begin
                i_l0_high = counter_high(output_counter_value(i_clk4_div_by,
                            i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_l1_high = counter_high(output_counter_value(i_clk5_div_by,
                            i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
            end
            i_e0_high = counter_high(output_counter_value(i_extclk0_div_by,
                        i_extclk0_mult_by,  i_m, i_n), extclk0_duty_cycle);
            i_e1_high = counter_high(output_counter_value(i_extclk1_div_by,
                        i_extclk1_mult_by,  i_m, i_n), extclk1_duty_cycle);
            i_e2_high = counter_high(output_counter_value(i_extclk2_div_by,
                        i_extclk2_mult_by,  i_m, i_n), extclk2_duty_cycle);
            i_e3_high = counter_high(output_counter_value(i_extclk3_div_by,
                        i_extclk3_mult_by,  i_m, i_n), extclk3_duty_cycle);
            if (l_pll_type == "lvds")
                i_g0_low  = counter_low(output_counter_value(i_clk2_div_by,
                            i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
            else
                i_g0_low  = counter_low(output_counter_value(i_clk0_div_by,
                            i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
            i_g1_low  = counter_low(output_counter_value(i_clk1_div_by,
                        i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
            i_g2_low  = counter_low(output_counter_value(i_clk2_div_by,
                        i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
            i_g3_low  = counter_low(output_counter_value(i_clk3_div_by,
                        i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
            if (l_pll_type == "lvds")
            begin
                i_l0_low  = i_g0_low;
                i_l1_low  = i_g0_low;
            end
            else
            begin
                i_l0_low  = counter_low(output_counter_value(i_clk4_div_by,
                            i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_l1_low  = counter_low(output_counter_value(i_clk5_div_by,
                            i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
            end
            i_e0_low  = counter_low(output_counter_value(i_extclk0_div_by,
                        i_extclk0_mult_by,  i_m, i_n), extclk0_duty_cycle);
            i_e1_low  = counter_low(output_counter_value(i_extclk1_div_by,
                        i_extclk1_mult_by,  i_m, i_n), extclk1_duty_cycle);
            i_e2_low  = counter_low(output_counter_value(i_extclk2_div_by,
                        i_extclk2_mult_by,  i_m, i_n), extclk2_duty_cycle);
            i_e3_low  = counter_low(output_counter_value(i_extclk3_div_by,
                        i_extclk3_mult_by,  i_m, i_n), extclk3_duty_cycle);            
            
            if (l_pll_type == "flvds")
            begin
                // Need to readjust phase shift values when the clock multiply value has been readjusted.
                new_multiplier = clk0_multiply_by / i_clk0_mult_by;
                i_clk0_phase_shift = (clk0_phase_shift_num * new_multiplier);
                i_clk1_phase_shift = (clk1_phase_shift_num * new_multiplier);
                i_clk2_phase_shift = (clk2_phase_shift_num * new_multiplier);
            end
            else
            begin
                i_clk0_phase_shift = get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num);
                i_clk1_phase_shift = get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num);
                i_clk2_phase_shift = get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num);
            end
            
            max_neg_abs = maxnegabs(i_clk0_phase_shift,
                                    i_clk1_phase_shift,
                                    i_clk2_phase_shift,
                                    str2int(clk3_phase_shift),
                                    str2int(clk4_phase_shift),
                                    str2int(clk5_phase_shift),
                                    str2int(extclk0_phase_shift),
                                    str2int(extclk1_phase_shift),
                                    str2int(extclk2_phase_shift),
                                    str2int(extclk3_phase_shift));
            if (l_pll_type == "lvds")
                i_g0_initial = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            else
                i_g0_initial = counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);

            i_g1_initial = counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_g2_initial = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_g3_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs)), i_m, i_n);
            if (l_pll_type == "lvds")
            begin
                i_l0_initial = i_g0_initial;
                i_l1_initial = i_g0_initial;
            end
            else
            begin
                i_l0_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs)), i_m, i_n);
                i_l1_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs)), i_m, i_n);
            end
            i_e0_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift), max_neg_abs)), i_m, i_n);
            i_e1_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift), max_neg_abs)), i_m, i_n);
            i_e2_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift), max_neg_abs)), i_m, i_n);
            i_e3_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift), max_neg_abs)), i_m, i_n);
            if (l_pll_type == "lvds")
                i_g0_mode = counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            else
                i_g0_mode = counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
            i_g1_mode = counter_mode(clk1_duty_cycle,output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
            i_g2_mode = counter_mode(clk2_duty_cycle,output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            i_g3_mode = counter_mode(clk3_duty_cycle,output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
            if (l_pll_type == "lvds")
            begin
                i_l0_mode = "bypass";
                i_l1_mode = "bypass";
            end
            else
            begin
                i_l0_mode = counter_mode(clk4_duty_cycle,output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
                i_l1_mode = counter_mode(clk5_duty_cycle,output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));
            end
            i_e0_mode = counter_mode(extclk0_duty_cycle,output_counter_value(i_extclk0_div_by, i_extclk0_mult_by,  i_m, i_n));
            i_e1_mode = counter_mode(extclk1_duty_cycle,output_counter_value(i_extclk1_div_by, i_extclk1_mult_by,  i_m, i_n));
            i_e2_mode = counter_mode(extclk2_duty_cycle,output_counter_value(i_extclk2_div_by, i_extclk2_mult_by,  i_m, i_n));
            i_e3_mode = counter_mode(extclk3_duty_cycle,output_counter_value(i_extclk3_div_by, i_extclk3_mult_by,  i_m, i_n));
            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            if (l_pll_type == "lvds")
                i_g0_ph = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            else
                i_g0_ph = counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);

            i_g1_ph = counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_g2_ph = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_g3_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs)), i_m, i_n);
            if (l_pll_type == "lvds")
            begin
                i_l0_ph = i_g0_ph;
                i_l1_ph = i_g0_ph;
            end
            else
            begin
                i_l0_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs)), i_m, i_n);
                i_l1_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs)), i_m, i_n);
            end
            i_e0_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift),max_neg_abs)), i_m, i_n);
            i_e1_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift),max_neg_abs)), i_m, i_n);
            i_e2_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift),max_neg_abs)), i_m, i_n);
            i_e3_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift),max_neg_abs)), i_m, i_n);

            if (l_pll_type == "lvds")
                i_g0_time_delay = counter_time_delay  ( str2int(clk2_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
            else
                i_g0_time_delay = counter_time_delay  ( str2int(clk0_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
            i_g1_time_delay = counter_time_delay  ( str2int(clk1_time_delay),
                                                    i_m_time_delay,
                                                    i_n_time_delay);
            i_g2_time_delay = counter_time_delay  ( str2int(clk2_time_delay),
                                                    i_m_time_delay,
                                                    i_n_time_delay);
            i_g3_time_delay = counter_time_delay  ( str2int(clk3_time_delay),
                                                    i_m_time_delay,
                                                    i_n_time_delay);
            if (l_pll_type == "lvds")
            begin
                i_l0_time_delay = i_g0_time_delay;
                i_l1_time_delay = i_g0_time_delay;
            end
            else
            begin
                i_l0_time_delay = counter_time_delay  ( str2int(clk4_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
                i_l1_time_delay = counter_time_delay  ( str2int(clk5_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
            end
            i_e0_time_delay = counter_time_delay ( str2int( extclk0_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_e1_time_delay = counter_time_delay ( str2int( extclk1_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_e2_time_delay = counter_time_delay ( str2int( extclk2_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_e3_time_delay = counter_time_delay ( str2int( extclk3_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_extclk3_counter = "e3" ;
            i_extclk2_counter = "e2" ;
            i_extclk1_counter = "e1" ;
            i_extclk0_counter = "e0" ;
            i_clk5_counter    = "l1" ;
            i_clk4_counter    = "l0" ;
            i_clk3_counter    = "g3" ;
            i_clk2_counter    = "g2" ;
            i_clk1_counter    = "g1" ;

            if (l_pll_type == "lvds")
            begin
                l_enable0_counter = "l0";
                l_enable1_counter = "l1";
                i_clk0_counter    = "l0" ;
            end
            else
                i_clk0_counter    = "g0" ;

            // in external feedback mode, need to adjust M value to take
            // into consideration the external feedback counter value
            if (l_operation_mode == "external_feedback")
            begin
                // if there is a negative phase shift, m_initial can only be 1
                if (max_neg_abs > 0)
                    i_m_initial = 1;

                if (l_feedback_source == "extclk0")
                begin
                    if (i_e0_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e0_high + i_e0_low;
                end
                else if (l_feedback_source == "extclk1")
                begin
                    if (i_e1_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e1_high + i_e1_low;
                end
                else if (l_feedback_source == "extclk2")
                begin
                    if (i_e2_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e2_high + i_e2_low;
                end
                else if (l_feedback_source == "extclk3")
                begin
                    if (i_e3_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e3_high + i_e3_low;
                end
                else // default to e0
                begin
                    if (i_e0_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e0_high + i_e0_low;
                end

                new_divisor = gcd(i_m, output_count);
                i_m = i_m / new_divisor;
                i_n = output_count / new_divisor;
            end

        end
        else 
        begin //  m != 0

            i_n = n;
            i_m = m;
            i_l0_high = l0_high;
            i_l1_high = l1_high;
            i_g0_high = g0_high;
            i_g1_high = g1_high;
            i_g2_high = g2_high;
            i_g3_high = g3_high;
            i_e0_high = e0_high;
            i_e1_high = e1_high;
            i_e2_high = e2_high;
            i_e3_high = e3_high;
            i_l0_low  = l0_low;
            i_l1_low  = l1_low;
            i_g0_low  = g0_low;
            i_g1_low  = g1_low;
            i_g2_low  = g2_low;
            i_g3_low  = g3_low;
            i_e0_low  = e0_low;
            i_e1_low  = e1_low;
            i_e2_low  = e2_low;
            i_e3_low  = e3_low;
            i_l0_initial = l0_initial;
            i_l1_initial = l1_initial;
            i_g0_initial = g0_initial;
            i_g1_initial = g1_initial;
            i_g2_initial = g2_initial;
            i_g3_initial = g3_initial;
            i_e0_initial = e0_initial;
            i_e1_initial = e1_initial;
            i_e2_initial = e2_initial;
            i_e3_initial = e3_initial;
            i_l0_mode = alpha_tolower(l0_mode);
            i_l1_mode = alpha_tolower(l1_mode);
            i_g0_mode = alpha_tolower(g0_mode);
            i_g1_mode = alpha_tolower(g1_mode);
            i_g2_mode = alpha_tolower(g2_mode);
            i_g3_mode = alpha_tolower(g3_mode);
            i_e0_mode = alpha_tolower(e0_mode);
            i_e1_mode = alpha_tolower(e1_mode);
            i_e2_mode = alpha_tolower(e2_mode);
            i_e3_mode = alpha_tolower(e3_mode);
            i_l0_ph  = l0_ph;
            i_l1_ph  = l1_ph;
            i_g0_ph  = g0_ph;
            i_g1_ph  = g1_ph;
            i_g2_ph  = g2_ph;
            i_g3_ph  = g3_ph;
            i_e0_ph  = e0_ph;
            i_e1_ph  = e1_ph;
            i_e2_ph  = e2_ph;
            i_e3_ph  = e3_ph;
            i_m_ph   = m_ph;        // default
            i_m_initial = m_initial;
            i_l0_time_delay = l0_time_delay;
            i_l1_time_delay = l1_time_delay;
            i_g0_time_delay = g0_time_delay;
            i_g1_time_delay = g1_time_delay;
            i_g2_time_delay = g2_time_delay;
            i_g3_time_delay = g3_time_delay;
            i_e0_time_delay = e0_time_delay;
            i_e1_time_delay = e1_time_delay;
            i_e2_time_delay = e2_time_delay;
            i_e3_time_delay = e3_time_delay;
            i_m_time_delay  = m_time_delay;
            i_n_time_delay  = n_time_delay;
            i_extclk3_counter = alpha_tolower(extclk3_counter);
            i_extclk2_counter = alpha_tolower(extclk2_counter);
            i_extclk1_counter = alpha_tolower(extclk1_counter);
            i_extclk0_counter = alpha_tolower(extclk0_counter);
            i_clk5_counter    = alpha_tolower(clk5_counter);
            i_clk4_counter    = alpha_tolower(clk4_counter);
            i_clk3_counter    = alpha_tolower(clk3_counter);
            i_clk2_counter    = alpha_tolower(clk2_counter);
            i_clk1_counter    = alpha_tolower(clk1_counter);
            i_clk0_counter    = alpha_tolower(clk0_counter);

        end // user to advanced conversion

        // set the scan_chain length
        if (l_scan_chain == "long")
            scan_chain_length = EGPP_SCAN_CHAIN;
        else if (l_scan_chain == "short")
            scan_chain_length = GPP_SCAN_CHAIN;

        if (l_primary_clock == "inclk0")
        begin
            refclk_period = inclk0_input_frequency * i_n;
            primary_clock_frequency = inclk0_input_frequency;
        end
        else if (l_primary_clock == "inclk1")
        begin
            refclk_period = inclk1_input_frequency * i_n;
            primary_clock_frequency = inclk1_input_frequency;
        end

        m_times_vco_period = refclk_period;
        new_m_times_vco_period = refclk_period;

        fbclk_period = 0;
        high_time = 0;
        low_time = 0;
        schedule_vco = 0;
        schedule_offset = 1;
        vco_out[7:0] = 8'b0;
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
        l0_got_first_rising_edge = 0;
        l1_got_first_rising_edge = 0;
        vco_l0_last_value = 0;
        l0_count = 1;
        l1_count = 1;
        l0_tmp = 0;
        l1_tmp = 0;
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
        cycle_to_adjust = 0;
        m_delay = 0;
        vco_l0 = 0;
        vco_l1 = 0;
        total_pull_back = 0;
        pull_back_M = 0;
        pull_back_ext_cntr = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;
        ena_ipd_last_value = 0;
        inclk_out_of_range = 0;
        scandataout_tmp = 0;
        scandataout_trigger = 0;
        schedule_vco_last_value = 0;

        // set initial values for counter parameters
        m_initial_val = i_m_initial;
        m_val = i_m;
        m_time_delay_val = i_m_time_delay;
        n_val = i_n;
        n_time_delay_val = i_n_time_delay;
        m_ph_val = i_m_ph;

        m2_val = m2;
        n2_val = n2;

        if (m_val == 1)
            m_mode_val = "bypass";
        if (m2_val == 1)
            m2_mode_val = "bypass";
        if (n_val == 1)
            n_mode_val = "bypass";
        if (n2_val == 1)
            n2_mode_val = "bypass";

        if (skip_vco == "on")
        begin
            m_val = 1;
            m_initial_val = 1;
            m_time_delay_val = 0;
            m_ph_val = 0;
        end

        l0_high_val = i_l0_high;
        l0_low_val = i_l0_low;
        l0_initial_val = i_l0_initial;
        l0_mode_val = i_l0_mode;
        l0_time_delay_val = i_l0_time_delay;

        l1_high_val = i_l1_high;
        l1_low_val = i_l1_low;
        l1_initial_val = i_l1_initial;
        l1_mode_val = i_l1_mode;
        l1_time_delay_val = i_l1_time_delay;

        g0_high_val = i_g0_high;
        g0_low_val = i_g0_low;
        g0_initial_val = i_g0_initial;
        g0_mode_val = i_g0_mode;
        g0_time_delay_val = i_g0_time_delay;

        g1_high_val = i_g1_high;
        g1_low_val = i_g1_low;
        g1_initial_val = i_g1_initial;
        g1_mode_val = i_g1_mode;
        g1_time_delay_val = i_g1_time_delay;

        g2_high_val = i_g2_high;
        g2_low_val = i_g2_low;
        g2_initial_val = i_g2_initial;
        g2_mode_val = i_g2_mode;
        g2_time_delay_val = i_g2_time_delay;

        g3_high_val = i_g3_high;
        g3_low_val = i_g3_low;
        g3_initial_val = i_g3_initial;
        g3_mode_val = i_g3_mode;
        g3_time_delay_val = i_g3_time_delay;

        e0_high_val = i_e0_high;
        e0_low_val = i_e0_low;
        e0_initial_val = i_e0_initial;
        e0_mode_val = i_e0_mode;
        e0_time_delay_val = i_e0_time_delay;

        e1_high_val = i_e1_high;
        e1_low_val = i_e1_low;
        e1_initial_val = i_e1_initial;
        e1_mode_val = i_e1_mode;
        e1_time_delay_val = i_e1_time_delay;

        e2_high_val = i_e2_high;
        e2_low_val = i_e2_low;
        e2_initial_val = i_e2_initial;
        e2_mode_val = i_e2_mode;
        e2_time_delay_val = i_e2_time_delay;

        e3_high_val = i_e3_high;
        e3_low_val = i_e3_low;
        e3_initial_val = i_e3_initial;
        e3_mode_val = i_e3_mode;
        e3_time_delay_val = i_e3_time_delay;

        i = 0;
        j = 0;
        inclk_last_value = 0;

        ext_fbk_cntr_ph = 0;
        ext_fbk_cntr_initial = 1;

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
//        current_clock = l_primary_clock;
        if (l_primary_clock == "inclk0")
            current_clock = 0;
        else
            current_clock = 1;
        if (l_primary_clock == "inclk0")
            active_clock = 0;
        else
            active_clock = 1;
        clkloss_tmp = 0;
        got_curr_clk_falling_edge_after_clkswitch = 0;
        clk0_count = 0;
        clk1_count = 0;
        switch_over_count = 0;
        active_clk_was_switched = 0;

        // initialize quiet_time
        quiet_time = slowest_clk  ( l0_high_val+l0_low_val, l0_mode_val,
                                    l1_high_val+l1_low_val, l1_mode_val,
                                    g0_high_val+g0_low_val, g0_mode_val,
                                    g1_high_val+g1_low_val, g1_mode_val,
                                    g2_high_val+g2_low_val, g2_mode_val,
                                    g3_high_val+g3_low_val, g3_mode_val,
                                    e0_high_val+e0_low_val, e0_mode_val,
                                    e1_high_val+e1_low_val, e1_mode_val,
                                    e2_high_val+e2_low_val, e2_mode_val,
                                    e3_high_val+e3_low_val, e3_mode_val,
                                    l_scan_chain,
                                    refclk_period, m_val);
        pll_in_quiet_period = 0;
        start_quiet_time = 0; 
        quiet_period_violation = 0;
        reconfig_err = 0;
        scanclr_violation = 0;
        scanclr_clk_violation = 0;
        got_first_scanclk_after_scanclr_inactive_edge = 0;
        error = 0;
        scanaclr_rising_time = 0;
        scanaclr_falling_time = 0;

        // VCO feedback loop settings for external feedback mode
        // first find which ext counter is used for feedback

        if (l_operation_mode == "external_feedback")
        begin
            if (l_feedback_source == "extclk0")
            begin
                if (i_extclk0_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk0_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk0_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk0_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end
            else if (l_feedback_source == "extclk1")
            begin
                if (i_extclk1_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk1_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk1_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk1_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end
            else if (l_feedback_source == "extclk2")
            begin
                if (i_extclk2_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk2_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk2_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk2_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end
            else if (l_feedback_source == "extclk3")
            begin
                if (i_extclk3_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk3_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk3_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk3_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end

            // now save this counter's parameters
            if (ext_fbk_cntr == "e0")
            begin
                ext_fbk_cntr_high = e0_high_val;
                ext_fbk_cntr_low = e0_low_val;
                ext_fbk_cntr_ph = i_e0_ph;
                ext_fbk_cntr_initial = i_e0_initial;
                ext_fbk_cntr_delay = e0_time_delay_val;
                ext_fbk_cntr_mode = e0_mode_val;
            end
            else if (ext_fbk_cntr == "e1")
            begin
                ext_fbk_cntr_high = e1_high_val;
                ext_fbk_cntr_low = e1_low_val;
                ext_fbk_cntr_ph = i_e1_ph;
                ext_fbk_cntr_initial = i_e1_initial;
                ext_fbk_cntr_delay = e1_time_delay_val;
                ext_fbk_cntr_mode = e1_mode_val;
            end
            else if (ext_fbk_cntr == "e2")
            begin
                ext_fbk_cntr_high = e2_high_val;
                ext_fbk_cntr_low = e2_low_val;
                ext_fbk_cntr_ph = i_e2_ph;
                ext_fbk_cntr_initial = i_e2_initial;
                ext_fbk_cntr_delay = e2_time_delay_val;
                ext_fbk_cntr_mode = e2_mode_val;
            end
            else if (ext_fbk_cntr == "e3")
            begin
                ext_fbk_cntr_high = e3_high_val;
                ext_fbk_cntr_low = e3_low_val;
                ext_fbk_cntr_ph = i_e3_ph;
                ext_fbk_cntr_initial = i_e3_initial;
                ext_fbk_cntr_delay = e3_time_delay_val;
                ext_fbk_cntr_mode = e3_mode_val;
            end

            if (ext_fbk_cntr_mode == "bypass")
                ext_fbk_cntr_modulus = 1;
            else
                ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;
        end

        l_index = 1;
        stop_vco = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
        else
            locked_tmp = 0;
        pll_is_locked = 0;
        pll_about_to_lock = 0;

        no_warn = 0;
        m_val_tmp = m_val;
        n_val_tmp = n_val;

        pll_is_in_reset = 0;
        if (l_pll_type == "fast" || l_pll_type == "lvds")
            is_fast_pll = 1;
        else is_fast_pll = 0;
    end

    assign inclk_m  =   l_operation_mode == "external_feedback" ? (l_feedback_source == "extclk0" ? extclk0_tmp :
                        l_feedback_source == "extclk1" ? extclk1_tmp :
                        l_feedback_source == "extclk2" ? extclk2_tmp :
                        l_feedback_source == "extclk3" ? extclk3_tmp : 1'b0) :
                        vco_out[m_ph_val];

    stratixgx_m_cntr m1 (.clk(inclk_m),
                .reset(areset_ipd || (!ena_ipd) || stop_vco),
                .cout(fbclk),
                .initial_value(m_initial_val),
                .modulus(m_val),
                .time_delay(m_delay));

    always @(clkswitch_ipd)
    begin
        if (clkswitch_ipd == 1'b1)
            external_switch = 1;
        clkloss_tmp <= clkswitch_ipd;
    end

    always @(inclk0_ipd or inclk1_ipd)
    begin
        // save the inclk event value
        if (inclk0_ipd !== inclk0_last_value)
        begin
            if (current_clock !== 0)
                other_clock_value = inclk0_ipd;
        end
        if (inclk1_ipd !== inclk1_last_value)
        begin
            if (current_clock !== 1)
                other_clock_value = inclk1_ipd;
        end

        // check if either input clk is bad
        if (inclk0_ipd === 1'b1 && inclk0_ipd !== inclk0_last_value)
        begin
            clk0_count = clk0_count + 1;
            clk0_is_bad = 0;
            if (current_clock == 0)
                current_clk_is_bad = 0;
            clk1_count = 0;
            if (clk0_count > 2)
            begin
                // no event on other clk for 2 cycles
                clk1_is_bad = 1;
                if (current_clock == 1)
                    current_clk_is_bad = 1;
            end
        end
        if (inclk1_ipd === 1'b1 && inclk1_ipd !== inclk1_last_value)
        begin
            clk1_count = clk1_count + 1;
            clk1_is_bad = 0;
            if (current_clock == 1)
                current_clk_is_bad = 0;
            clk0_count = 0;
            if (clk1_count > 2)
            begin
                // no event on other clk for 2 cycles
                clk0_is_bad = 1;
                if (current_clock == 0)
                    current_clk_is_bad = 1;
            end
        end

        // check if the bad clk is the primary clock
        if (((l_primary_clock == "inclk0") && (clk0_is_bad == 1'b1)) || ((l_primary_clock == "inclk1") && (clk1_is_bad == 1'b1)))
            primary_clk_is_bad = 1;
        else
            primary_clk_is_bad = 0;

        // actual switching
        if ((inclk0_ipd !== inclk0_last_value) && (current_clock == 0))
        begin
            if (external_switch == 1'b1)
            begin
                if (!got_curr_clk_falling_edge_after_clkswitch)
                begin
                    if (inclk0_ipd === 1'b0)
                        got_curr_clk_falling_edge_after_clkswitch = 1;
                    inclk_n = inclk0_ipd;
                end
            end
            else inclk_n = inclk0_ipd;
        end
        if ((inclk1_ipd !== inclk1_last_value) && (current_clock == 1))
        begin
            if (external_switch == 1'b1)
            begin
                if (!got_curr_clk_falling_edge_after_clkswitch)
                begin
                    if (inclk1_ipd === 1'b0)
                        got_curr_clk_falling_edge_after_clkswitch = 1;
                    inclk_n = inclk1_ipd;
                end
            end
            else inclk_n = inclk1_ipd;
        end
        if ((other_clock_value == 1'b1) && (other_clock_value != other_clock_last_value) && (l_switch_over_on_lossclk == "on") && (l_enable_switch_over_counter == "on") && primary_clk_is_bad)
            switch_over_count = switch_over_count + 1;
        if ((other_clock_value == 1'b0) && (other_clock_value != other_clock_last_value))
        begin
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (l_switch_over_on_lossclk == "on" && primary_clk_is_bad && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
            begin
                got_curr_clk_falling_edge_after_clkswitch = 0;
                if (current_clock == 0)
                begin
                    current_clock = 1;
                end
                else
                begin
                    current_clock = 0;
                end
                active_clock = ~active_clock;
                active_clk_was_switched = 1;
                switch_over_count = 0;
                external_switch = 0;
                current_clk_is_bad = 0;
            end
        end

        if (l_switch_over_on_lossclk == "on" && (clkswitch_ipd != 1'b1))
        begin
            if (primary_clk_is_bad)
                clkloss_tmp = 1;
            else
                clkloss_tmp = 0;
        end

        inclk0_last_value = inclk0_ipd;
        inclk1_last_value = inclk1_ipd;
        other_clock_last_value = other_clock_value;

    end

    and (clkbad[0], clk0_is_bad, 1'b1);
    and (clkbad[1], clk1_is_bad, 1'b1);
    and (activeclock, active_clock, 1'b1);
    and (clkloss, clkloss_tmp, 1'b1);

    stratixgx_n_cntr n1 ( .clk(inclk_n),
                        .reset(areset_ipd),
                        .cout(refclk),
                        .modulus(n_val),
                        .time_delay(n_time_delay_val));

    stratixgx_scale_cntr l0 ( .clk(vco_out[i_l0_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(l0_clk),
                            .high(l0_high_val),
                            .low(l0_low_val),
                            .initial_value(l0_initial_val),
                            .mode(l0_mode_val),
                            .time_delay(l0_time_delay_val),
                            .ph_tap(i_l0_ph));

    stratixgx_scale_cntr l1 ( .clk(vco_out[i_l1_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(l1_clk),
                            .high(l1_high_val),
                            .low(l1_low_val),
                            .initial_value(l1_initial_val),
                            .mode(l1_mode_val),
                            .time_delay(l1_time_delay_val),
                            .ph_tap(i_l1_ph));

    stratixgx_scale_cntr g0 ( .clk(vco_out[i_g0_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g0_clk),
                            .high(g0_high_val),
                            .low(g0_low_val),
                            .initial_value(g0_initial_val),
                            .mode(g0_mode_val),
                            .time_delay(g0_time_delay_val),
                            .ph_tap(i_g0_ph));

    stratixgx_pll_reg lvds_dffa ( .d(comparator_ipd),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(g0_clk),
                                .q(dffa_out));

    stratixgx_pll_reg lvds_dffb ( .d(dffa_out),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(lvds_dffb_clk),
                                .q(dffb_out));

    assign lvds_dffb_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    stratixgx_pll_reg lvds_dffc ( .d(dffb_out),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(lvds_dffc_clk),
                                .q(dffc_out));

    assign lvds_dffc_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    assign nce_temp = ~dffc_out && dffb_out;

    stratixgx_pll_reg lvds_dffd ( .d(nce_temp),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(~lvds_dffd_clk),
                                .q(dffd_out));

    assign lvds_dffd_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    assign nce_l0 = (l_enable0_counter == "l0") ? dffd_out : 1'b0;
    assign nce_l1 = (l_enable0_counter == "l1") ? dffd_out : 1'b0;

    stratixgx_scale_cntr g1 ( .clk(vco_out[i_g1_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g1_clk),
                            .high(g1_high_val),
                            .low(g1_low_val),
                            .initial_value(g1_initial_val),
                            .mode(g1_mode_val),
                            .time_delay(g1_time_delay_val),
                            .ph_tap(i_g1_ph));

    stratixgx_scale_cntr g2 ( .clk(vco_out[i_g2_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g2_clk),
                            .high(g2_high_val),
                            .low(g2_low_val),
                            .initial_value(g2_initial_val),
                            .mode(g2_mode_val),
                            .time_delay(g2_time_delay_val),
                            .ph_tap(i_g2_ph));

    stratixgx_scale_cntr g3 ( .clk(vco_out[i_g3_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g3_clk),
                            .high(g3_high_val),
                            .low(g3_low_val),
                            .initial_value(g3_initial_val),
                            .mode(g3_mode_val),
                            .time_delay(g3_time_delay_val),
                            .ph_tap(i_g3_ph));
    assign cntr_e0_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e0") ? 1 : e0_initial_val;
    assign cntr_e0_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e0") ? ext_fbk_delay : e0_time_delay_val;

    stratixgx_scale_cntr e0 ( .clk(vco_out[i_e0_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e0_clk),
                            .high(e0_high_val),
                            .low(e0_low_val),
                            .initial_value(cntr_e0_initial),
                            .mode(e0_mode_val),
                            .time_delay(cntr_e0_delay),
                            .ph_tap(i_e0_ph));

    assign cntr_e1_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e1") ? 1 : e1_initial_val;
    assign cntr_e1_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e1") ? ext_fbk_delay : e1_time_delay_val;
    stratixgx_scale_cntr e1 ( .clk(vco_out[i_e1_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e1_clk),
                            .high(e1_high_val),
                            .low(e1_low_val),
                            .initial_value(cntr_e1_initial),
                            .mode(e1_mode_val),
                            .time_delay(cntr_e1_delay),
                            .ph_tap(i_e1_ph));

    assign cntr_e2_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e2") ? 1 : e2_initial_val;
    assign cntr_e2_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e2") ? ext_fbk_delay : e2_time_delay_val;
    stratixgx_scale_cntr e2 ( .clk(vco_out[i_e2_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e2_clk),
                            .high(e2_high_val),
                            .low(e2_low_val),
                            .initial_value(cntr_e2_initial),
                            .mode(e2_mode_val),
                            .time_delay(cntr_e2_delay),
                            .ph_tap(i_e2_ph));

    assign cntr_e3_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e3") ? 1 : e3_initial_val;
    assign cntr_e3_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e3") ? ext_fbk_delay : e3_time_delay_val;
    stratixgx_scale_cntr e3 ( .clk(vco_out[i_e3_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e3_clk),
                            .high(e3_high_val),
                            .low(e3_low_val),
                            .initial_value(cntr_e3_initial),
                            .mode(e3_mode_val),
                            .time_delay(cntr_e3_delay),
                            .ph_tap(i_e3_ph));


    always @((vco_out[i_l0_ph] && is_fast_pll) or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if ((areset_ipd == 1'b1) || (ena_ipd == 1'b0) || (stop_vco == 1'b1))
        begin
            l0_count = 1;
            l0_got_first_rising_edge = 0;
        end
        else begin
            if (nce_l0 == 1'b0)
            begin
                if (l0_got_first_rising_edge == 1'b0)
                begin
                    if (vco_out[i_l0_ph] == 1'b1 && vco_out[i_l0_ph] != vco_l0_last_value)
                        l0_got_first_rising_edge = 1;
                end
                else if (vco_out[i_l0_ph] != vco_l0_last_value)
                begin
                    l0_count = l0_count + 1;
                    if (l0_count == (l0_high_val + l0_low_val) * 2)
                        l0_count  = 1;
                end
            end
            if (vco_out[i_l0_ph] == 1'b0 && vco_out[i_l0_ph] != vco_l0_last_value)
            begin
                if (l0_count == 1)
                begin
                    l0_tmp = 1;
                    l0_got_first_rising_edge = 0;
                end
                else l0_tmp = 0;
            end
        end
        vco_l0_last_value = vco_out[i_l0_ph];
    end

    always @((vco_out[i_l1_ph] && is_fast_pll) or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1)
        begin
            l1_count = 1;
            l1_got_first_rising_edge = 0;
        end
        else begin
            if (nce_l1 == 1'b0)
            begin
                if (l1_got_first_rising_edge == 1'b0)
                begin
                    if (vco_out[i_l1_ph] == 1'b1 && vco_out[i_l1_ph] != vco_l1_last_value)
                        l1_got_first_rising_edge = 1;
                end
                else if (vco_out[i_l1_ph] != vco_l1_last_value)
                begin
                    l1_count = l1_count + 1;
                    if (l1_count == (l1_high_val + l1_low_val) * 2)
                        l1_count  = 1;
                end
            end
            if (vco_out[i_l1_ph] == 1'b0 && vco_out[i_l1_ph] != vco_l1_last_value)
            begin
                if (l1_count == 1)
                begin
                    l1_tmp = 1;
                    l1_got_first_rising_edge = 0;
                end
                else l1_tmp = 0;
            end
        end
        vco_l1_last_value = vco_out[i_l1_ph];
    end

    assign enable0_tmp = (l_enable0_counter == "l0") ? l0_tmp : l1_tmp;
    assign enable1_tmp = (l_enable1_counter == "l0") ? l0_tmp : l1_tmp;

    always @ (inclk_n or ena_ipd or areset_ipd)
    begin
        if (areset_ipd == 'b1)
        begin
            gate_count = 0;
            gate_out = 0; 
        end
        else if (inclk_n == 'b1 && inclk_last_value != inclk_n)
            if (ena_ipd == 'b1)
            begin
                gate_count = gate_count + 1;
                if (gate_count == gate_lock_counter)
                    gate_out = 1;
            end
        inclk_last_value = inclk_n;
    end

    assign locked = (l_gate_lock_signal == "yes") ? gate_out && locked_tmp : locked_tmp;

    always @ (scanclk_ipd or scanaclr_ipd)
    begin
        if (scanaclr_ipd === 1'b1 && scanaclr_last_value === 1'b0)
            scanaclr_rising_time = $time;
        else if (scanaclr_ipd === 1'b0 && scanaclr_last_value === 1'b1)
        begin
            scanaclr_falling_time = $time;
            // check for scanaclr active pulse width
            if ($time - scanaclr_rising_time < TRST)
            begin
                scanclr_violation = 1;
                $display ("Warning : Detected SCANACLR ACTIVE pulse width violation. Required is 5000 ps, actual is %0t. Reconfiguration may not work.", $time - scanaclr_rising_time);
                $display ("Time: %0t  Instance: %m", $time);
            end
            else begin
                scanclr_violation = 0;
                for (i = 0; i <= scan_chain_length; i = i + 1)
                    scan_data[i] = 0;
            end
            got_first_scanclk_after_scanclr_inactive_edge = 0;
        end
        else if ((scanclk_ipd === 'b1 && scanclk_last_value !== scanclk_ipd) && (got_first_scanclk_after_scanclr_inactive_edge === 1'b0) && ($time - scanaclr_falling_time < TRSTCLK))
        begin
            scanclr_clk_violation = 1;
            $display ("Warning : Detected SCANACLR INACTIVE time violation before rising edge of SCANCLK. Required is 5000 ps, actual is %0t. Reconfiguration may not work.", $time - scanaclr_falling_time);
            $display ("Time: %0t  Instance: %m", $time);
            got_first_scanclk_after_scanclr_inactive_edge = 1;
        end
        else if (scanclk_ipd == 'b1 && scanclk_last_value != scanclk_ipd && scanaclr_ipd === 1'b0)
        begin
            if (pll_in_quiet_period && ($time - start_quiet_time < quiet_time))
            begin
                $display("Time: %0t", $time, "   Warning : Detected transition on SCANCLK during quiet time. PLL may not function correctly."); 
                $display ("Time: %0t  Instance: %m", $time);
                quiet_period_violation = 1;
            end
            else begin
                pll_in_quiet_period = 0;
                for (j = scan_chain_length-1; j >= 1; j = j - 1)
                begin
                    scan_data[j] = scan_data[j - 1];
                end
                scan_data[0] = scandata_ipd;
            end
            if (got_first_scanclk_after_scanclr_inactive_edge === 1'b0)
            begin
                got_first_scanclk_after_scanclr_inactive_edge = 1;
                scanclr_clk_violation = 0;
            end
        end
        else if (scanclk_ipd === 1'b0 && scanclk_last_value !== scanclk_ipd && scanaclr_ipd === 1'b0)
        begin
            if (pll_in_quiet_period && ($time - start_quiet_time < quiet_time))
            begin
                $display("Time: %0t", $time, "   Warning : Detected transition on SCANCLK during quiet time. PLL may not function correctly."); 
                $display ("Time: %0t  Instance: %m", $time);
                quiet_period_violation = 1;
            end
            else if (scan_data[scan_chain_length-1] == 1'b1)
            begin
                pll_in_quiet_period = 1;
                quiet_period_violation = 0;
                reconfig_err = 0;
                start_quiet_time = $time;
                // initiate transfer
                scandataout_tmp <= 1'b1;
                quiet_time = slowest_clk  ( l0_high_val+l0_low_val, l0_mode_val,
                                            l1_high_val+l1_low_val, l1_mode_val,
                                            g0_high_val+g0_low_val, g0_mode_val,
                                            g1_high_val+g1_low_val, g1_mode_val,
                                            g2_high_val+g2_low_val, g2_mode_val,
                                            g3_high_val+g3_low_val, g3_mode_val,
                                            e0_high_val+e0_low_val, e0_mode_val,
                                            e1_high_val+e1_low_val, e1_mode_val,
                                            e2_high_val+e2_low_val, e2_mode_val,
                                            e3_high_val+e3_low_val, e3_mode_val,
                                            l_scan_chain,
                                            refclk_period, m_val);
                scandataout_trigger <= #(quiet_time) ~scandataout_trigger;
                transfer <= 1;
            end
        end
        scanclk_last_value = scanclk_ipd;
        scanaclr_last_value = scanaclr_ipd;
    end

    always @(scandataout_trigger)
    begin
        if (areset_ipd === 1'b0)
            scandataout_tmp <= 1'b0;
    end

    always @(posedge transfer)
    begin
        if (transfer == 1'b1)
        begin
            $display("NOTE : Reconfiguring PLL");
            $display ("Time: %0t  Instance: %m", $time);
            if (l_scan_chain == "long")
            begin
                // cntr e3
                error = 0;
                if (scan_data[273] == 1'b1)
                begin
                    e3_mode_val = "bypass";
                    if (scan_data[283] == 1'b1)
                    begin
                        e3_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E3 counter. It cannot be turned on unless the part is re-initialized.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
                else if (scan_data[283] == 1'b1)
                    e3_mode_val = "odd";
                else
                    e3_mode_val = "even";
                // before reading delay bits, clear e3_time_delay_val
                e3_time_delay_val = 32'b0;
                e3_time_delay_val = scan_data[287:284];
                e3_time_delay_val = e3_time_delay_val * 250;
                if (e3_time_delay_val > 3000)
                    e3_time_delay_val = 3000;
                e3_high_val[8:0] <= scan_data[272:264];
                e3_low_val[8:0] <= scan_data[282:274];
                if (scan_data[272:264] == 9'b000000000)
                    e3_high_val[9:0] <= 10'b1000000000;
                else
                    e3_high_val[9] <= 1'b0;
                if (scan_data[282:274] == 9'b000000000)
                    e3_low_val[9:0] <= 10'b1000000000;
                else
                    e3_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e3")
                begin
                    ext_fbk_cntr_high = e3_high_val;
                    ext_fbk_cntr_low = e3_low_val;
                    ext_fbk_cntr_delay = e3_time_delay_val;
                    ext_fbk_cntr_mode = e3_mode_val;
                end

                // cntr e2
                if (scan_data[249] == 1'b1)
                begin
                    e2_mode_val = "bypass";
                    if (scan_data[259] == 1'b1)
                    begin
                        e2_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E2 counter. It cannot be turned on unless the part is re-initialized.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
                else if (scan_data[259] == 1'b1)
                    e2_mode_val = "odd";
                else
                    e2_mode_val = "even";
                e2_time_delay_val = 32'b0;
                e2_time_delay_val = scan_data[263:260];
                e2_time_delay_val = e2_time_delay_val * 250;
                if (e2_time_delay_val > 3000)
                    e2_time_delay_val = 3000;
                e2_high_val[8:0] <= scan_data[248:240];
                e2_low_val[8:0] <= scan_data[258:250];
                if (scan_data[248:240] == 9'b000000000)
                    e2_high_val[9:0] <= 10'b1000000000;
                else
                    e2_high_val[9] <= 1'b0;
                if (scan_data[258:250] == 9'b000000000)
                    e2_low_val[9:0] <= 10'b1000000000;
                else
                    e2_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e2")
                begin
                    ext_fbk_cntr_high = e2_high_val;
                    ext_fbk_cntr_low = e2_low_val;
                    ext_fbk_cntr_delay = e2_time_delay_val;
                    ext_fbk_cntr_mode = e2_mode_val;
                end

                // cntr e1
                if (scan_data[225] == 1'b1)
                begin
                    e1_mode_val = "bypass";
                    if (scan_data[235] == 1'b1)
                    begin
                        e1_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E1 counter. It cannot be turned on unless the part is re-initialized.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
                else if (scan_data[235] == 1'b1)
                    e1_mode_val = "odd";
                else
                    e1_mode_val = "even";
                e1_time_delay_val = 32'b0;
                e1_time_delay_val = scan_data[239:236];
                e1_time_delay_val = e1_time_delay_val * 250;
                if (e1_time_delay_val > 3000)
                    e1_time_delay_val = 3000;
                e1_high_val[8:0] <= scan_data[224:216];
                e1_low_val[8:0] <= scan_data[234:226];
                if (scan_data[224:216] == 9'b000000000)
                    e1_high_val[9:0] <= 10'b1000000000;
                else
                    e1_high_val[9] <= 1'b0;
                if (scan_data[234:226] == 9'b000000000)
                    e1_low_val[9:0] <= 10'b1000000000;
                else
                    e1_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e1")
                begin
                    ext_fbk_cntr_high = e1_high_val;
                    ext_fbk_cntr_low = e1_low_val;
                    ext_fbk_cntr_delay = e1_time_delay_val;
                    ext_fbk_cntr_mode = e1_mode_val;
                end

                // cntr e0
                if (scan_data[201] == 1'b1)
                begin
                    e0_mode_val = "bypass";
                    if (scan_data[211] == 1'b1)
                    begin
                        e0_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E0 counter. It cannot be turned on unless the part is re-initialized.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
                else if (scan_data[211] == 1'b1)
                    e0_mode_val = "odd";
                else
                    e0_mode_val = "even";
                e0_time_delay_val = 32'b0;
                e0_time_delay_val = scan_data[215:212];
                e0_time_delay_val = e0_time_delay_val * 250;
                if (e0_time_delay_val > 3000)
                    e0_time_delay_val = 3000;
                e0_high_val[8:0] <= scan_data[200:192];
                e0_low_val[8:0] <= scan_data[210:202];
                if (scan_data[200:192] == 9'b000000000)
                    e0_high_val[9:0] <= 10'b1000000000;
                else
                    e0_high_val[9] <= 1'b0;
                if (scan_data[210:202] == 9'b000000000)
                    e0_low_val[9:0] <= 10'b1000000000;
                else
                    e0_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e0")
                begin
                    ext_fbk_cntr_high = e0_high_val;
                    ext_fbk_cntr_low = e0_low_val;
                    ext_fbk_cntr_delay = e0_time_delay_val;
                    ext_fbk_cntr_mode = e0_mode_val;
                end
            end

            // cntr l1
            if (scan_data[177] == 1'b1)
            begin
                l1_mode_val = "bypass";
                if (scan_data[187] == 1'b1)
                begin
                    l1_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the L1 counter. It cannot be turned on unless the part is re-initialized.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end
            else if (scan_data[187] == 1'b1)
                l1_mode_val = "odd";
            else
                l1_mode_val = "even";
            l1_time_delay_val = 32'b0;
            l1_time_delay_val = scan_data[191:188];
            l1_time_delay_val = l1_time_delay_val * 250;
            if (l1_time_delay_val > 3000)
                l1_time_delay_val = 3000;
            l1_high_val[8:0] <= scan_data[176:168];
            l1_low_val[8:0] <= scan_data[186:178];
            if (scan_data[176:168] == 9'b000000000)
                l1_high_val[9:0] <= 10'b1000000000;
            else
                l1_high_val[9] <= 1'b0;
            if (scan_data[186:178] == 9'b000000000)
                l1_low_val[9:0] <= 10'b1000000000;
            else
                l1_low_val[9] <= 1'b0;

            // cntr l0
            if (scan_data[153] == 1'b1)
            begin
                l0_mode_val = "bypass";
                if (scan_data[163] == 1'b1)
                begin
                    l0_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the L0 counter. It cannot be turned on unless the part is re-initialized.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end
            else if (scan_data[163] == 1'b1)
                l0_mode_val = "odd";
            else
                l0_mode_val = "even";
            l0_time_delay_val = 32'b0;
            l0_time_delay_val = scan_data[167:164];
            l0_time_delay_val = l0_time_delay_val * 250;
            if (l0_time_delay_val > 3000)
                l0_time_delay_val = 3000;
            l0_high_val[8:0] <= scan_data[152:144];
            l0_low_val[8:0] <= scan_data[162:154];
            if (scan_data[152:144] == 9'b000000000)
                l0_high_val[9:0] <= 10'b1000000000;
            else
                l0_high_val[9] <= 1'b0;
            if (scan_data[162:154] == 9'b000000000)
                l0_low_val[9:0] <= 10'b1000000000;
            else
                l0_low_val[9] <= 1'b0;

            // cntr g3
            if (scan_data[129] == 1'b1)
            begin
                g3_mode_val = "bypass";
                if (scan_data[139] == 1'b1)
                begin
                    g3_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G3 counter. It cannot be turned on unless the part is re-initialized.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end
            else if (scan_data[139] == 1'b1)
                g3_mode_val = "odd";
            else
                g3_mode_val = "even";
            g3_time_delay_val = 32'b0;
            g3_time_delay_val = scan_data[143:140];
            g3_time_delay_val = g3_time_delay_val * 250;
            if (g3_time_delay_val > 3000)
                g3_time_delay_val = 3000;
            g3_high_val[8:0] <= scan_data[128:120];
            g3_low_val[8:0] <= scan_data[138:130];
            if (scan_data[128:120] == 9'b000000000)
                g3_high_val[9:0] <= 10'b1000000000;
            else
                g3_high_val[9] <= 1'b0;
            if (scan_data[138:130] == 9'b000000000)
                g3_low_val[9:0] <= 10'b1000000000;
            else
                g3_low_val[9] <= 1'b0;

            // cntr g2
            if (scan_data[105] == 1'b1)
            begin
                g2_mode_val = "bypass";
                if (scan_data[115] == 1'b1)
                begin
                    g2_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G2 counter. It cannot be turned on unless the part is re-initialized.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end
            else if (scan_data[115] == 1'b1)
                g2_mode_val = "odd";
            else
                g2_mode_val = "even";
            g2_time_delay_val = 32'b0;
            g2_time_delay_val = scan_data[119:116];
            g2_time_delay_val = g2_time_delay_val * 250;
            if (g2_time_delay_val > 3000)
                g2_time_delay_val = 3000;
            g2_high_val[8:0] <= scan_data[104:96];
            g2_low_val[8:0] <= scan_data[114:106];
            if (scan_data[104:96] == 9'b000000000)
                g2_high_val[9:0] <= 10'b1000000000;
            else
                g2_high_val[9] <= 1'b0;
            if (scan_data[114:106] == 9'b000000000)
                g2_low_val[9:0] <= 10'b1000000000;
            else
                g2_low_val[9] <= 1'b0;

            // cntr g1
            if (scan_data[81] == 1'b1)
            begin
                g1_mode_val = "bypass";
                if (scan_data[91] == 1'b1)
                begin
                    g1_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G1 counter. It cannot be turned on unless the part is re-initialized.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end
            else if (scan_data[91] == 1'b1)
                g1_mode_val = "odd";
            else
                g1_mode_val = "even";
            g1_time_delay_val = 32'b0;
            g1_time_delay_val = scan_data[95:92];
            g1_time_delay_val = g1_time_delay_val * 250;
            if (g1_time_delay_val > 3000)
                g1_time_delay_val = 3000;
            g1_high_val[8:0] <= scan_data[80:72];
            g1_low_val[8:0] <= scan_data[90:82];
            if (scan_data[80:72] == 9'b000000000)
                g1_high_val[9:0] <= 10'b1000000000;
            else
                g1_high_val[9] <= 1'b0;
            if (scan_data[90:82] == 9'b000000000)
                g1_low_val[9:0] <= 10'b1000000000;
            else
                g1_low_val[9] <= 1'b0;

            // cntr g0
            if (scan_data[57] == 1'b1)
            begin
                g0_mode_val = "bypass";
                if (scan_data[67] == 1'b1)
                begin
                    g0_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G0 counter. It cannot be turned on unless the part is re-initialized.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end
            else if (scan_data[67] == 1'b1)
                g0_mode_val = "odd";
            else
                g0_mode_val = "even";
            g0_time_delay_val = 32'b0;
            g0_time_delay_val = scan_data[71:68];
            g0_time_delay_val = g0_time_delay_val * 250;
            if (g0_time_delay_val > 3000)
                g0_time_delay_val = 3000;
            g0_high_val[8:0] <= scan_data[56:48];
            g0_low_val[8:0] <= scan_data[66:58];
            if (scan_data[56:48] == 9'b000000000)
                g0_high_val[9:0] <= 10'b1000000000;
            else
                g0_high_val[9] <= 1'b0;
            if (scan_data[66:58] == 9'b000000000)
                g0_low_val[9:0] <= 10'b1000000000;
            else
                g0_low_val[9] <= 1'b0;

            // cntr M
            error = 0;
            m_val_tmp = 0;
            m_val_tmp[8:0] = scan_data[32:24];
            if (scan_data[33] !== 1'b1)
            begin
                if (m_val_tmp[8:0] == 9'b000000001)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal 1 value for M counter. Instead, the M counter should be BYPASSED. Reconfiguration may not work.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
                else if (m_val_tmp[8:0] == 9'b000000000)
                    m_val_tmp[9:0] = 10'b1000000000;
                if (error == 1'b0)
                begin
                    if (m_mode_val === "bypass")
                        $display ("Warning : M counter switched from BYPASS mode to enabled (M modulus = %d). PLL may lose lock.", m_val_tmp[9:0]);
                    else
                        $display("PLL reconfigured with : M modulus = %d ", m_val_tmp[9:0]);
                    $display ("Time: %0t  Instance: %m", $time);
                    m_mode_val = "";
                end
            end
            else if (scan_data[33] == 1'b1)
            begin
                if (scan_data[24] !== 1'b0)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal value for counter M in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
                else begin
                    if (m_mode_val !== "bypass")
                        $display ("Warning : M counter switched from enabled to BYPASS mode. PLL may lose lock.");
                    m_val_tmp[9:0] = 10'b0000000001;
                    m_mode_val = "bypass";
                    $display("PLL reconfigured with : M modulus = %d ", m_val_tmp[9:0]);
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end

            if (skip_vco == "on")
                m_val_tmp[9:0] = 10'b0000000001;

            // cntr M2
            if (ss > 0)
            begin
                error = 0;
                m2_val[8:0] = scan_data[42:34];
                if (scan_data[43] !== 1'b1)
                begin
                    if (m2_val[8:0] == 9'b000000001)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal 1 value for M2 counter. Instead, the M2 counter should be BYPASSED. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    else if (m2_val[8:0] == 9'b000000000)
                        m2_val[9:0] = 10'b1000000000;
                    if (error == 1'b0)
                    begin
                        if (m2_mode_val === "bypass")
                        begin
                            $display ("Warning : M2 counter switched from BYPASS mode to enabled (M2 modulus = %d). Pll may lose lock.", m2_val[9:0]);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                        else
                        begin
                            $display(" M2 modulus = %d ", m2_val[9:0]);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                        m2_mode_val = "";
                    end
                end
                else if (scan_data[43] == 1'b1)
                begin
                    if (scan_data[34] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal value for counter M2 in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    else begin
                        if (m2_mode_val !== "bypass")
                        begin
                            $display ("Warning : M2 counter switched from enabled to BYPASS mode. PLL may lose lock.");
                        end
                        m2_val[9:0] = 10'b0000000001;
                        m2_mode_val = "bypass";
                        $display(" M2 modulus = %d ", m2_val[9:0]);
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
                if (m_mode_val != m2_mode_val)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Incompatible modes for M1/M2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end

            m_time_delay_val = 32'b0;
            m_time_delay_val = scan_data[47:44];
            m_time_delay_val = m_time_delay_val * 250;
            if (m_time_delay_val > 3000)
                m_time_delay_val = 3000;
            if (skip_vco == "on")
                m_time_delay_val = 32'b0;
            $display("                                     M time delay = %0d", m_time_delay_val);
            $display ("Time: %0t  Instance: %m", $time);

            // cntr N
            error = 0;
            n_val_tmp[8:0] = scan_data[8:0];
            n_val_tmp[9] = 1'b0;
            if (scan_data[9] !== 1'b1)
            begin
                if (n_val_tmp[8:0] == 9'b000000001)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal 1 value for N counter. Instead, the N counter should be BYPASSED. Reconfiguration may not work.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
                else if (n_val_tmp[8:0] == 9'b000000000)
                    n_val_tmp[9:0] = 10'b1000000000;
                if (error == 1'b0)
                begin
                    if (n_mode_val === "bypass")
                    begin
                        $display ("Warning : N counter switched from BYPASS mode to enabled (N modulus = %d). PLL may lose lock.", n_val_tmp[9:0]);
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    else
                    begin
                        $display("                                     N modulus = %d ", n_val_tmp[9:0]);
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    n_mode_val = "";
                end
            end
            else if (scan_data[9] == 1'b1)     // bypass
            begin
                if (scan_data[0] !== 1'b0)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal value for counter N in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
                else begin
                    if (n_mode_val !== "bypass")
                    begin
                        $display ("Warning : N counter switched from enabled to BYPASS mode. PLL may lose lock.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    n_val_tmp[9:0] = 10'b0000000001;
                    n_mode_val = "bypass";
                    $display("                                     N modulus = %d ", n_val_tmp[9:0]);
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end

            // cntr N2
            if (ss > 0)
            begin
                error = 0;
                n2_val[8:0] = scan_data[18:10];
                if (scan_data[19] !== 1'b1)
                begin
                    if (n2_val[8:0] == 9'b000000001)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal 1 value for N2 counter. Instead, the N2 counter should be BYPASSED. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    else if (n2_val[8:0] == 9'b000000000)
                        n2_val = 10'b1000000000;
                    if (error == 1'b0)
                    begin
                        if (n2_mode_val === "bypass")
                        begin
                            $display ("Warning : N2 counter switched from BYPASS mode to enabled (N2 modulus = %d). PLL may lose lock.", n2_val[9:0]);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                        else
                        begin
                            $display(" N2 modulus = %d ", n2_val[9:0]);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                        n2_mode_val = "";
                    end
                end
                else if (scan_data[19] == 1'b1)     // bypass
                begin
                    if (scan_data[10] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal value for counter N2 in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    else begin
                        if (n2_mode_val !== "bypass")
                        begin
                            $display ("Warning : N2 counter switched from enabled to BYPASS mode. PLL may lose lock.");
                            $display ("Time: %0t  Instance: %m", $time);
                        end    
                        n2_val[9:0] = 10'b0000000001;
                        n2_mode_val = "bypass";
                        $display(" N2 modulus = %d ", n2_val[9:0]);
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
                if (n_mode_val != n2_mode_val)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Incompatible modes for N1/N2 counters. Either both should be BYASSED or both NON-BYPASSED.");
                    $display ("Time: %0t  Instance: %m", $time);
                end
            end // ss > 0

            n_time_delay_val = 32'b0;
            n_time_delay_val = scan_data[23:20];
            n_time_delay_val = n_time_delay_val * 250;
            if (n_time_delay_val > 3000)
                n_time_delay_val = 3000;
            $display("                                     N time delay = %0d", n_time_delay_val);
            $display ("Time: %0t  Instance: %m", $time);

            transfer <= 0;
            // clear the scan_chain
            for (i = 0; i <= scan_chain_length; i = i + 1)
                scan_data[i] = 0;
        end
    end

    always @(negedge transfer)
    begin
        if (l_scan_chain == "long")
        begin
            $display("                                     E3 high = %d, E3 low = %d, E3 mode = %s, E3 time delay = %0d", e3_high_val[9:0], e3_low_val[9:0], e3_mode_val, e3_time_delay_val);
            $display("                                     E2 high = %d, E2 low = %d, E2 mode = %s, E2 time delay = %0d", e2_high_val[9:0], e2_low_val[9:0], e2_mode_val, e2_time_delay_val);
            $display("                                     E1 high = %d, E1 low = %d, E1 mode = %s, E1 time delay = %0d", e1_high_val[9:0], e1_low_val[9:0], e1_mode_val, e1_time_delay_val);
            $display("                                     E0 high = %d, E0 low = %d, E0 mode = %s, E0 time delay = %0d", e0_high_val[9:0], e0_low_val[9:0], e0_mode_val, e0_time_delay_val);
        end
        $display("                                     L1 high = %d, L1 low = %d, L1 mode = %s, L1 time delay = %0d", l1_high_val[9:0], l1_low_val[9:0], l1_mode_val, l1_time_delay_val);
        $display("                                     L0 high = %d, L0 low = %d, L0 mode = %s, L0 time delay = %0d", l0_high_val[9:0], l0_low_val[9:0], l0_mode_val, l0_time_delay_val);
        $display("                                     G3 high = %d, G3 low = %d, G3 mode = %s, G3 time delay = %0d", g3_high_val[9:0], g3_low_val[9:0], g3_mode_val, g3_time_delay_val);
        $display("                                     G2 high = %d, G2 low = %d, G2 mode = %s, G2 time delay = %0d", g2_high_val[9:0], g2_low_val[9:0], g2_mode_val, g2_time_delay_val);
        $display("                                     G1 high = %d, G1 low = %d, G1 mode = %s, G1 time delay = %0d", g1_high_val[9:0], g1_low_val[9:0], g1_mode_val, g1_time_delay_val);
        $display("                                     G0 high = %d, G0 low = %d, G0 mode = %s, G0 time delay = %0d", g0_high_val[9:0], g0_low_val[9:0], g0_mode_val, g0_time_delay_val);
        $display ("Time: %0t  Instance: %m", $time);
    end

always @(schedule_vco or areset_ipd or ena_ipd)
begin
    sched_time = 0;

    for (i = 0; i <= 7; i=i+1)
        last_phase_shift[i] = phase_shift[i];
 
    cycle_to_adjust = 0;
    l_index = 1;
    m_times_vco_period = new_m_times_vco_period;

    // give appropriate messages
    // if areset was asserted
    if (areset_ipd == 1'b1 && areset_ipd_last_value !== areset_ipd)
    begin
        $display (" Note : %s PLL was reset", family_name);
        $display ("Time: %0t  Instance: %m", $time);
    end

    // if areset is deasserted
    if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1)
    begin
        // deassert scandataout now and allow reconfig to complete if
        // areset was high during reconfig
        if (scandataout_tmp === 1'b1)
            scandataout_tmp <= #(quiet_time) 1'b0;
    end

    // if ena was deasserted
    if (ena_ipd == 1'b0 && ena_ipd_last_value !== ena_ipd)
    begin
        $display (" Note : %s PLL was disabled", family_name);
        $display ("Time: %0t  Instance: %m", $time);
    end

    // illegal value on areset_ipd
    if (areset_ipd === 1'bx && (areset_ipd_last_value === 1'b0 || areset_ipd_last_value === 1'b1))
    begin
        $display("Warning : Illegal value 'X' detected on ARESET input");
        $display ("Time: %0t  Instance: %m", $time);
    end

    if ((schedule_vco !== schedule_vco_last_value) && (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1))
    begin
            if (areset_ipd === 1'b1)
                pll_is_in_reset = 1;

        // drop VCO taps to 0
        for (i = 0; i <= 7; i=i+1)
        begin
            for (j = 0; j <= last_phase_shift[i] + 1; j=j+1)
                vco_out[i] <= #(j) 1'b0;
            phase_shift[i] = 0;
            last_phase_shift[i] = 0;
        end

        // reset lock parameters
        locked_tmp = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
        pll_is_locked = 0;
        pll_about_to_lock = 0;
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
        schedule_offset = 1;
        vco_val = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;

        // reset enable0 and enable1 counter parameters
//      l0_count = 1;
//      l1_count = 1;
//      l0_got_first_rising_edge = 0;
//      l1_got_first_rising_edge = 0;

    end else if (ena_ipd === 1'b1 && areset_ipd === 1'b0 && stop_vco === 1'b0)
    begin

        // else note areset deassert time
        // note it as refclk_time to prevent false triggering
        // of stop_vco after areset
        if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1 && pll_is_in_reset === 1'b1)
        begin
            refclk_time = $time;
            pll_is_in_reset = 0;
        end

        // calculate loop_xplier : this will be different from m_val in ext. fbk mode
        loop_xplier = m_val;
        loop_initial = i_m_initial - 1;
        loop_ph = i_m_ph;
        loop_time_delay = m_time_delay_val;

        if (l_operation_mode == "external_feedback")
        begin
            if (ext_fbk_cntr_mode == "bypass")
                ext_fbk_cntr_modulus = 1;
            else
                ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;

            loop_xplier = m_val * (ext_fbk_cntr_modulus);
            loop_ph = ext_fbk_cntr_ph;
            loop_initial = ext_fbk_cntr_initial - 1 + ((i_m_initial - 1) * (ext_fbk_cntr_modulus));
            loop_time_delay = m_time_delay_val + ext_fbk_cntr_delay;
        end

        // convert initial value to delay
        initial_delay = (loop_initial * m_times_vco_period)/loop_xplier;

        // convert loop ph_tap to delay
        rem = m_times_vco_period % loop_xplier;
        vco_per = m_times_vco_period/loop_xplier;
        if (rem != 0)
            vco_per = vco_per + 1;
        fbk_phase = (loop_ph * vco_per)/8;

        if (l_operation_mode == "external_feedback")
        begin
            pull_back_ext_cntr = ext_fbk_cntr_delay + (ext_fbk_cntr_initial - 1) * (m_times_vco_period/loop_xplier) + fbk_phase;

            while (pull_back_ext_cntr > refclk_period)
                pull_back_ext_cntr = pull_back_ext_cntr - refclk_period;

            pull_back_M =  m_time_delay_val + (i_m_initial - 1) * (ext_fbk_cntr_modulus) * (m_times_vco_period/loop_xplier);

            while (pull_back_M > refclk_period)
                pull_back_M = pull_back_M - refclk_period;
        end
        else begin
            pull_back_ext_cntr = 0;
            pull_back_M = initial_delay + m_time_delay_val + fbk_phase;
        end

        total_pull_back = pull_back_M + pull_back_ext_cntr;
        if (l_simulation_type == "timing")
            total_pull_back = total_pull_back + pll_compensation_delay;

        while (total_pull_back > refclk_period)
            total_pull_back = total_pull_back - refclk_period;

        if (total_pull_back > 0)
            offset = refclk_period - total_pull_back;

        if (l_operation_mode == "external_feedback")
        begin
            fbk_delay = pull_back_M;
            if (l_simulation_type == "timing")
                fbk_delay = fbk_delay + pll_compensation_delay;

            ext_fbk_delay = pull_back_ext_cntr - fbk_phase;
        end
        else begin
            fbk_delay = total_pull_back - fbk_phase;
            if (fbk_delay < 0)
            begin
                offset = offset - fbk_phase;
                fbk_delay = total_pull_back;
            end
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

                // add offset
                if (schedule_offset == 1'b1)
                begin
                    sched_time = sched_time + offset;
                    schedule_offset = 0;
                end

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

        // this may no longer be required

        if (sched_time > 0)
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

    areset_ipd_last_value = areset_ipd;
    ena_ipd_last_value = ena_ipd;
    schedule_vco_last_value = schedule_vco;

end

always @(pfdena_ipd)
begin
    if (pfdena_ipd === 1'b0)
    begin
        locked_tmp = 1'bx;
        pll_is_locked = 0;
        cycles_to_lock = 0;
        $display (" Note : PFDENA was deasserted");
        $display ("Time: %0t  Instance: %m", $time);
    end
    else if (pfdena_ipd === 1'b1 && pfdena_ipd_last_value === 1'b0)
    begin
        // PFD was disabled, now enabled again
        got_first_refclk = 0;
        got_second_refclk = 0;
        refclk_time = $time;
    end
    pfdena_ipd_last_value = pfdena_ipd;
end

always @(negedge refclk)
begin
    refclk_last_value = refclk;
end

always @(negedge fbclk)
begin
    fbclk_last_value = fbclk;
end

always @(posedge refclk or posedge fbclk)
begin
    if (refclk == 1'b1 && refclk_last_value !== refclk && areset_ipd === 1'b0)
    begin
        n_val <= n_val_tmp;
        if (! got_first_refclk)
        begin
            got_first_refclk = 1;
        end else
        begin
            got_second_refclk = 1;
            refclk_period = $time - refclk_time;

            // check if incoming freq. will cause VCO range to be
            // exceeded
            if ( (vco_max != 0 && vco_min != 0) && (skip_vco == "off") && (pfdena_ipd === 1'b1) &&
                ((refclk_period/loop_xplier > vco_max) ||
                (refclk_period/loop_xplier < vco_min)) )
            begin
                if (pll_is_locked == 1'b1)
                begin
                    $display ("Warning : Input clock freq. is not within VCO range. PLL may lose lock");
                    $display ("Time: %0t  Instance: %m", $time);
                    if (inclk_out_of_range === 1'b1)
                    begin
                        // unlock
                        pll_is_locked = 0;
                        locked_tmp = 0;
                        if (l_pll_type == "fast")
                            locked_tmp = 1;
                        pll_about_to_lock = 0;
                        cycles_to_lock = 0;
                        $display ("Note : %s PLL lost lock", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
                        first_schedule = 1;
                        schedule_offset = 1;
                        vco_period_was_phase_adjusted = 0;
                        phase_adjust_was_scheduled = 0;
                    end
                end
                else begin
                    if (no_warn == 0)
                    begin
                        $display ("Warning : Input clock freq. is not within VCO range. PLL may not lock");
                        $display ("Time: %0t  Instance: %m", $time);
                        no_warn = 1;
                    end
                end
                inclk_out_of_range = 1;
            end
            else begin
                inclk_out_of_range = 0;
            end

        end
        if (stop_vco == 1'b1)
        begin
            stop_vco = 0;
            schedule_vco = ~schedule_vco;
        end
        refclk_time = $time;
    end

    if (fbclk == 1'b1 && fbclk_last_value !== fbclk)
    begin
        m_val <= m_val_tmp;
        if (!got_first_fbclk)
        begin
            got_first_fbclk = 1;
            first_fbclk_time = $time;
        end
        else
            fbclk_period = $time - fbclk_time;

        // need refclk_period here, so initialized to proper value above
        if ( ( ($time - refclk_time > 1.5 * refclk_period) && pfdena_ipd === 1'b1 && pll_is_locked == 1'b1) || ( ($time - refclk_time > 5 * refclk_period) && pfdena_ipd === 1'b1) )
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
                if (l_pll_type == "fast")
                    locked_tmp = 1;
                $display ("Note : %s PLL lost lock due to loss of input clock", family_name);
                $display ("Time: %0t  Instance: %m", $time);
            end
            pll_about_to_lock = 0;
            cycles_to_lock = 0;
            cycles_to_unlock = 0;
            first_schedule = 1;
            vco_period_was_phase_adjusted = 0;
            phase_adjust_was_scheduled = 0;
        end
        fbclk_time = $time;
    end

    if (got_second_refclk && pfdena_ipd === 1'b1 && (!inclk_out_of_range))
    begin
        // now we know actual incoming period
//       if (abs(refclk_period - fbclk_period) > 2)
//       begin
//           new_m_times_vco_period = refclk_period;
//       end
//       else if (abs(fbclk_time - refclk_time) <= 2 || (refclk_period - abs(fbclk_time - refclk_time) <= 2))
        if (abs(fbclk_time - refclk_time) <= 5 || (got_first_fbclk && abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
        begin
            // considered in phase
            if (cycles_to_lock == valid_lock_multiplier - 1)
                pll_about_to_lock <= 1;
            if (cycles_to_lock == valid_lock_multiplier)
            begin
                if (pll_is_locked === 1'b0)
                begin
                    $display (" Note : %s PLL locked to incoming clock", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
                end
                pll_is_locked = 1;
                locked_tmp = 1;
                if (l_pll_type == "fast")
                    locked_tmp = 0;
            end
            // increment lock counter only if the second part of the above
            // time check is NOT true
            if (!(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
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
                if (cycles_to_unlock == invalid_lock_multiplier)
                begin
                    pll_is_locked = 0;
                    locked_tmp = 0;
                    if (l_pll_type == "fast")
                        locked_tmp = 1;
                    pll_about_to_lock = 0;
                    cycles_to_lock = 0;
                    $display ("Note : %s PLL lost lock", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
                    first_schedule = 1;
                    schedule_offset = 1;
                    vco_period_was_phase_adjusted = 0;
                    phase_adjust_was_scheduled = 0;
                end
            end
            if (abs(refclk_period - fbclk_period) <= 2)
            begin
                // frequency is still good
                if ($time == fbclk_time && (!phase_adjust_was_scheduled))
                begin
                    if (abs(fbclk_time - refclk_time) > refclk_period/2)
                    begin
                        if (abs(fbclk_time - refclk_time) > 1.5 * refclk_period)
                        begin
                            // input clock may have stopped : do nothing
                        end
                        else begin
                        new_m_times_vco_period = m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                        vco_period_was_phase_adjusted = 1;
                        end
                    end else
                    begin
                        new_m_times_vco_period = m_times_vco_period - abs(fbclk_time - refclk_time);
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

    if (quiet_period_violation == 1'b1 || reconfig_err == 1'b1 || scanclr_violation == 1'b1 || scanclr_clk_violation == 1'b1)
    begin
        locked_tmp = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
    end

    refclk_last_value = refclk;
    fbclk_last_value = fbclk;
end

    assign clk0_tmp = i_clk0_counter == "l0" ? l0_clk : i_clk0_counter == "l1" ? l1_clk : i_clk0_counter == "g0" ? g0_clk : i_clk0_counter == "g1" ? g1_clk : i_clk0_counter == "g2" ? g2_clk : i_clk0_counter == "g3" ? g3_clk : 1'b0;

    assign clk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk0_tmp : 1'bx;

    stratixgx_dffe ena0_reg ( .D(clkena0_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk0_tmp),
                            .Q(ena0));

    assign clk1_tmp = i_clk1_counter == "l0" ? l0_clk : i_clk1_counter == "l1" ? l1_clk : i_clk1_counter == "g0" ? g0_clk : i_clk1_counter == "g1" ? g1_clk : i_clk1_counter == "g2" ? g2_clk : i_clk1_counter == "g3" ? g3_clk : 1'b0;

    assign clk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk1_tmp : 1'bx;

    stratixgx_dffe ena1_reg ( .D(clkena1_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk1_tmp),
                            .Q(ena1));

    assign clk2_tmp = i_clk2_counter == "l0" ? l0_clk : i_clk2_counter == "l1" ? l1_clk : i_clk2_counter == "g0" ? g0_clk : i_clk2_counter == "g1" ? g1_clk : i_clk2_counter == "g2" ? g2_clk : i_clk2_counter == "g3" ? g3_clk : 1'b0;

    assign clk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk2_tmp : 1'bx;

    stratixgx_dffe ena2_reg ( .D(clkena2_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk2_tmp),
                            .Q(ena2));

    assign clk3_tmp = i_clk3_counter == "l0" ? l0_clk : i_clk3_counter == "l1" ? l1_clk : i_clk3_counter == "g0" ? g0_clk : i_clk3_counter == "g1" ? g1_clk : i_clk3_counter == "g2" ? g2_clk : i_clk3_counter == "g3" ? g3_clk : 1'b0;

    assign clk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk3_tmp : 1'bx;

    stratixgx_dffe ena3_reg ( .D(clkena3_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk3_tmp),
                            .Q(ena3));

    assign clk4_tmp = i_clk4_counter == "l0" ? l0_clk : i_clk4_counter == "l1" ? l1_clk : i_clk4_counter == "g0" ? g0_clk : i_clk4_counter == "g1" ? g1_clk : i_clk4_counter == "g2" ? g2_clk : i_clk4_counter == "g3" ? g3_clk : 1'b0;

    assign clk4 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk4_tmp : 1'bx;

    stratixgx_dffe ena4_reg ( .D(clkena4_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk4_tmp),
                            .Q(ena4));

    assign clk5_tmp = i_clk5_counter == "l0" ? l0_clk : i_clk5_counter == "l1" ? l1_clk : i_clk5_counter == "g0" ? g0_clk : i_clk5_counter == "g1" ? g1_clk : i_clk5_counter == "g2" ? g2_clk : i_clk5_counter == "g3" ? g3_clk : 1'b0;

    assign clk5 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk5_tmp : 1'bx;

    stratixgx_dffe ena5_reg ( .D(clkena5_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk5_tmp),
                            .Q(ena5));

    assign extclk0_tmp = i_extclk0_counter == "e0" ? e0_clk : i_extclk0_counter == "e1" ? e1_clk : i_extclk0_counter == "e2" ? e2_clk : i_extclk0_counter == "e3" ? e3_clk : i_extclk0_counter == "g0" ? g0_clk : 1'b0;

    assign extclk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk0_tmp : 1'bx;

    stratixgx_dffe extena0_reg  ( .D(extclkena0_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk0_tmp),
                                .Q(extena0));

    assign extclk1_tmp = i_extclk1_counter == "e0" ? e0_clk : i_extclk1_counter == "e1" ? e1_clk : i_extclk1_counter == "e2" ? e2_clk : i_extclk1_counter == "e3" ? e3_clk : i_extclk1_counter == "g0" ? g0_clk : 1'b0;

    assign extclk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk1_tmp : 1'bx;

    stratixgx_dffe extena1_reg  ( .D(extclkena1_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk1_tmp),
                                .Q(extena1));

    assign extclk2_tmp = i_extclk2_counter == "e0" ? e0_clk : i_extclk2_counter == "e1" ? e1_clk : i_extclk2_counter == "e2" ? e2_clk : i_extclk2_counter == "e3" ? e3_clk : i_extclk2_counter == "g0" ? g0_clk : 1'b0;

    assign extclk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk2_tmp : 1'bx;

    stratixgx_dffe extena2_reg  ( .D(extclkena2_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk2_tmp),
                                .Q(extena2));

    assign extclk3_tmp = i_extclk3_counter == "e0" ? e0_clk : i_extclk3_counter == "e1" ? e1_clk : i_extclk3_counter == "e2" ? e2_clk : i_extclk3_counter == "e3" ? e3_clk : i_extclk3_counter == "g0" ? g0_clk : 1'b0;

    assign extclk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk3_tmp : 1'bx;

    stratixgx_dffe extena3_reg  ( .D(extclkena3_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk3_tmp),
                                .Q(extena3));

    assign enable_0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable0_tmp : 1'bx;
    assign enable_1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable1_tmp : 1'bx;

    // ACCELERATE OUTPUTS
    and (clk[0], ena0, clk0);
    and (clk[1], ena1, clk1);
    and (clk[2], ena2, clk2);
    and (clk[3], ena3, clk3);
    and (clk[4], ena4, clk4);
    and (clk[5], ena5, clk5);

    and (extclk[0], extena0, extclk0);
    and (extclk[1], extena1, extclk1);
    and (extclk[2], extena2, extclk2);
    and (extclk[3], extena3, extclk3);

    and (enable0, 1'b1, enable_0);
    and (enable1, 1'b1, enable_1);

    and (scandataout, 1'b1, scandataout_tmp);

endmodule // stratixgx_pll
//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_dll
//
// Description : Simulation model for the Stratixgx DLL.
//
// Outputs     : Delayctrlout output (active high) indicates when the
//               DLL locks to the incoming clock
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_dll (clk,
                    delayctrlout
                   );

    // GLOBAL PARAMETERS
    parameter input_frequency   = "10000 ps";
    parameter phase_shift       = "0";
    parameter sim_valid_lock    = 1;
    parameter sim_invalid_lock  = 5;
    parameter lpm_type          = "stratixgx_dll";

    // INPUT PORTS
    input clk;

    // OUTPUT PORTS
    output delayctrlout;

    // INTERNAL NETS AND VARIABLES
    reg clk_ipd_last_value;
    reg got_first_rising_edge;
    reg got_first_falling_edge;
    reg dll_is_locked;
    reg start_clk_detect;
    reg start_clk_detect_last_value;
    reg violation;
    reg duty_cycle_warn;
    reg input_freq_warn;

    time clk_ipd_last_rising_edge;
    time clk_ipd_last_falling_edge;

    integer clk_per_tolerance;
    integer duty_cycle;
    integer clk_detect_count;
    integer half_cycles_to_lock;
    integer half_cycles_to_keep_lock;

    integer input_period;

    // BUFFER INPUTS
    wire clk_ipd;

    buf (clk_ipd, clk);

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
    endfunction

    initial
    begin
        clk_ipd_last_value = 0;
        got_first_rising_edge = 0;
        got_first_falling_edge = 0;
        clk_ipd_last_rising_edge = 0;
        clk_ipd_last_falling_edge = 0;
        input_period = str2int(input_frequency);
        duty_cycle = input_period/2;
        clk_per_tolerance = input_period * 0.1;

        // if sim_valid_lock == 0, DLL starts out locked.
        if (sim_valid_lock == 0)
            dll_is_locked = 1;
        else
            dll_is_locked = 0;

        clk_detect_count = 0;
        start_clk_detect = 0;
        start_clk_detect_last_value = 0;
        half_cycles_to_lock = 0;
        half_cycles_to_keep_lock = 0;
        violation = 0;
        duty_cycle_warn = 1;
        input_freq_warn = 1;
    end

    always @(clk_ipd)
    begin
        if (clk_ipd == 1'b1 && clk_ipd != clk_ipd_last_value)
        begin
            // rising edge
            if (got_first_rising_edge == 1'b0)
            begin
                got_first_rising_edge = 1;
                half_cycles_to_lock = half_cycles_to_lock + 1;
                if (sim_valid_lock > 0 && half_cycles_to_lock >= sim_valid_lock && violation == 1'b0)
                begin
                    dll_is_locked <= 1;
                    $display(" Note : DLL locked to incoming clock.");
                    $display("Time: %0t  Instance: %m", $time);
                end

                // start the internal clock that will monitor
                // the input clock
                start_clk_detect <= 1;
            end
            else
            begin
                // reset clock event counter
                clk_detect_count = 0;
                // check for clk_period violation
                if ( (($time - clk_ipd_last_rising_edge) < (input_period - clk_per_tolerance)) || (($time - clk_ipd_last_rising_edge) > (input_period + clk_per_tolerance)) )
                begin
                    violation = 1;
                    if (input_freq_warn === 1'b1)
                    begin
                        $display(" Warning : Input frequency violation");
                        $display("Time: %0t  Instance: %m", $time);
                        input_freq_warn = 0;
                    end
                end
                else if ( (($time - clk_ipd_last_falling_edge) < (duty_cycle - clk_per_tolerance/2)) || (($time - clk_ipd_last_falling_edge) > (duty_cycle + clk_per_tolerance/2)) )
                begin
                    // duty cycle violation
                    violation = 1;
                    if (duty_cycle_warn === 1'b1)
                    begin
                        $display(" Warning : Duty Cycle violation");
                        $display("Time: %0t  Instance: %m", $time);
                        duty_cycle_warn = 0;
                    end
                end
                else
                    violation = 0;
                if (violation)
                begin
                    if (dll_is_locked)
                    begin
                        half_cycles_to_keep_lock = half_cycles_to_keep_lock + 1;
                        if (half_cycles_to_keep_lock > sim_invalid_lock)
                        begin
                            dll_is_locked <= 0;
                            $display(" Warning : DLL lost lock due to input frequency/Duty cycle violation.");
                            $display("Time: %0t  Instance: %m", $time);
                            // reset lock and unlock counters
                            half_cycles_to_lock = 0;
                            half_cycles_to_keep_lock = 0;
                            got_first_rising_edge = 0;
                            got_first_falling_edge = 0;
                        end
                    end
                    else
                        half_cycles_to_lock = 0;
                end
                else begin
                    if (dll_is_locked == 1'b0)
                    begin
                        // increment lock counter
                        half_cycles_to_lock = half_cycles_to_lock + 1;
                        if (half_cycles_to_lock > sim_valid_lock)
                        begin
                            dll_is_locked <= 1;
                            $display(" Note : DLL locked to incoming clock.");
                            $display("Time: %0t  Instance: %m", $time);
                        end
                    end
                    else
                        half_cycles_to_keep_lock = 0;
                end
            end
            clk_ipd_last_rising_edge = $time;
        end
        else if (clk_ipd == 1'b0 && clk_ipd != clk_ipd_last_value)
        begin
            // falling edge
            // reset clock event counter
            clk_detect_count = 0;
            got_first_falling_edge = 1;
            if (got_first_rising_edge == 1'b1)
            begin
                // check for duty cycle violation
                if ( (($time - clk_ipd_last_rising_edge) < (duty_cycle - clk_per_tolerance/2)) || (($time - clk_ipd_last_rising_edge) > (duty_cycle + clk_per_tolerance/2)) )
                begin
                    violation = 1;
                    if (duty_cycle_warn === 1'b1)
                    begin
                        $display(" Warning : Duty Cycle violation");
                        $display("Time: %0t  Instance: %m", $time);
                        duty_cycle_warn = 0;
                    end
                end
                else
                    violation = 0;
                if (dll_is_locked)
                begin
                    if (violation)
                    begin
                        half_cycles_to_keep_lock = half_cycles_to_keep_lock + 1;
                        if (half_cycles_to_keep_lock > sim_invalid_lock)
                        begin
                            dll_is_locked <= 0;
                            $display(" Warning : DLL lost lock due to input frequency/Duty cycle violation.");
                            $display("Time: %0t  Instance: %m", $time);
                            // reset lock and unlock counters
                            half_cycles_to_lock = 0;
                            half_cycles_to_keep_lock = 0;
                            got_first_rising_edge = 0;
                            got_first_falling_edge = 0;
                        end
                    end
                    else
                        half_cycles_to_keep_lock = 0;
                end
                else
                begin
                    if (violation)
                    begin
                        // reset_lock_counter
                        half_cycles_to_lock = 0;
                    end
                    else
                    begin
                        // increment lock counter
                        half_cycles_to_lock = half_cycles_to_lock + 1;
                    end
                end
            end
            else
            begin
                // first clk edge is falling edge, do nothing
            end
            clk_ipd_last_falling_edge = $time;
        end
        else
        begin
            // illegal value
            if (dll_is_locked && (got_first_rising_edge == 1'b1 || got_first_falling_edge == 1'b1))
            begin
                dll_is_locked <= 0;
                // reset lock and unlock counters
                half_cycles_to_lock = 0;
                half_cycles_to_keep_lock = 0;
                got_first_rising_edge = 0;
                got_first_falling_edge = 0;
                $display(" Error : Illegal value detected on input clock. DLL will lose lock.");
                $display("Time: %0t  Instance: %m", $time);
            end
            else if (got_first_rising_edge == 1'b1 || got_first_falling_edge == 1'b1)
            begin
                // clock started up, then went to 'X'
                // this is to weed out the 'X' at start of simulation
                $display(" Error : Illegal value detected on input clock.");
                $display("Time: %0t  Instance: %m", $time);
                // reset lock counter
                half_cycles_to_lock = 0;
            end
        end
        clk_ipd_last_value = clk_ipd;
    end

    // ********************************************************************
    // The following block generates the internal clock that is used to
    // track loss of input clock. A counter counts events on this internal
    // clock, and is reset to 0 on event on input clock. If input clock
    // flatlines, the counter will exceed the limit and DLL will lose lock.
    // Events on internal clock are scheduled at the max. allowable input
    // clock tolerance, to allow 'sim_invalid_lock' parameter value = 1.
    // ********************************************************************

    always @(start_clk_detect)
    begin
        if (start_clk_detect != start_clk_detect_last_value)
        begin
            // increment clock event counter
            clk_detect_count = clk_detect_count + 1;
            if (dll_is_locked)
            begin
                if (clk_detect_count > sim_invalid_lock)
                begin
                    dll_is_locked = 0;
                    $display(" Warning : DLL lost lock due to loss of input clock.");
                    $display("Time: %0t  Instance: %m", $time);
                    // reset lock and unlock counters
                    half_cycles_to_lock = 0;
                    half_cycles_to_keep_lock = 0;
                    got_first_rising_edge = 0;
                    got_first_falling_edge = 0;
                    clk_detect_count = 0;
                    start_clk_detect <= #(input_period/2) 1'b0;
                end
                else
                    start_clk_detect <= #(input_period/2 + clk_per_tolerance/2) ~start_clk_detect;
            end
            else if (clk_detect_count > 10)
            begin
                $display(" Warning : No input clock. DLL will not lock.");
                $display("Time: %0t  Instance: %m", $time);
                clk_detect_count = 0;
            end
            else
                start_clk_detect <= #(input_period/2 + clk_per_tolerance/2) ~start_clk_detect;
        end
        // save this event value
        start_clk_detect_last_value = start_clk_detect;
    end

    // ACCELERATE OUTPUTS
    and (delayctrlout, 1'b1, dll_is_locked);

endmodule
///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_tx_parallel_register
//
// Description : Parallel register used in the Transmitter module
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_tx_parallel_register (clk, 
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
    
    // INTERNAL VARIABLES
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
    
    specify
        (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
            
        $setuphold(posedge clk, datain, 0, 0);
    
    endspecify
    
    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 'b0;
    end

    always @(clk_ipd or devpor or devclrn)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 'b0;
        end
        else
        begin
            if ((clk_ipd === 1'b1) && (clk_last_value !== clk_ipd))
            begin
                if (enable_ipd === 1)
                begin
                    dataout_tmp <= datain_ipd;
                end
            end
        end
            
        clk_last_value <= clk_ipd;
    
    end //always
    
    assign dataout_opd = dataout_tmp; 
    
endmodule //stratixgx_lvds_tx_register

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_tx_out_block
//
// Description : Negative edge triggered register on the TX output
//               side. It also optionally generates an clock output,
//               which could be identical or inverted of the input
//               clock.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_tx_out_block (clk,
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
    
    // INTERNAL VARIABLES
    reg dataout_tmp;
    reg clk_last_value;
    
    wire bypass_mode;
    wire invert_mode;
    wire falling_clk_out;
    
    // INPUT BUFFERS
    wire clk_in;
    wire datain_in;
    
    buf (clk_in, clk);
    buf (datain_in, datain);
    
    assign falling_clk_out = (use_falling_clock_edge == "true")?1'b1:1'b0;
    assign bypass_mode = (bypass_serializer == "true")?1'b1:1'b0;
    assign invert_mode = (invert_clock == "true")?1'b1:1'b0;
    
    specify
    
        (datain => dataout) = (0, 0);
    
        if (bypass_mode == 1'b1)
            (clk => dataout) = (0, 0);
            
        if (bypass_mode == 1'b0 && falling_clk_out == 1'b1)
            (negedge clk => (dataout +: dataout_tmp)) = (0, 0);
    
    endspecify
    
    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 0;
    end
    
    always @(clk_in or datain_in or devclrn or devpor)
    begin
    	if ((devpor === 'b0) || (devclrn === 'b0))
    	begin
    		dataout_tmp <= 0;
    	end
    	else
    	begin
    		if (bypass_serializer == "false")
    		begin
    			if (use_falling_clock_edge == "false")
    				dataout_tmp <= datain_in;
    			else if ((clk_in === 1'b0) && (clk_last_value !== clk_in))
  					dataout_tmp <= datain_in;
    		end //bypass is off
    		else //generate clk_out 
    			dataout_tmp <= (invert_clock == "false") ? clk_in : !clk_in;
    	end //devpor
    
    	clk_last_value <= clk_in;
    end // always
    
    and (dataout, dataout_tmp, 1'b1);

endmodule //stratixgx_lvds_tx_out_block

////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_transmitter
//
// Description : Timing simulation model for Stratixgx LVDS Transmitter,
//               including the following sub module(s):
//               1. DFFE
//               2. stratixgx_lvds_tx_parallel_register
//               3. stratixgx_lvds_tx_out_block
//
////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_transmitter (clk0, 
                                 enable0, 
                                 datain, 
                                 dataout, 
                                 devclrn, 
                                 devpor
                                );

    parameter bypass_serializer = "false";
    parameter invert_clock = "false";
    parameter use_falling_clock_edge = "false";
    parameter lpm_type = "stratixgx_lvds_transmitter";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter channel_width = 4;

// SIMULATION_ONLY_PARAMETERS_END
    
    // INPUT PORTS
    input [channel_width - 1:0] datain;
    input clk0;
    input enable0;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output dataout;
    
    tri1 devclrn;
    tri1 devpor;
    
    // INTERNAL VARIABLES
    reg shift_out;
    reg clk0_last_value;
    wire [channel_width - 1:0] input_data;
    reg [channel_width - 1:0] shift_data;
    wire txload0;
    wire txload1;
    wire txload2;
            
    wire bypass_mode;
    
    reg [channel_width - 1:0] datain_dly;
    reg [channel_width - 1:0] datain_dly2;

    reg tmp_bit;

    // INPUT BUFFERS
    wire clk0_in;
    
    buf (clk0_in, clk0);
    
    initial
    begin
        clk0_last_value = 1'b0;
        shift_out = 1'b0;
        shift_data = {channel_width{1'b0}};
    end
    
    stratixgx_dffe txload0_reg (.D(enable0),
                              .CLRN(1'b1),
                              .PRN(1'b1),
                              .ENA(1'b1),
                              .CLK(clk0_in),
                              .Q(txload0));
    
    stratixgx_dffe txload1_reg (.D(txload0),
                              .CLRN(1'b1),
                              .PRN(1'b1),
                              .ENA(1'b1),
                              .CLK(clk0_in),
                              .Q(txload1));
    
    stratixgx_dffe txload2_reg (.D(txload1),
                              .CLRN(1'b1),
                              .PRN(1'b1),
                              .ENA(1'b1),
                              .CLK(!clk0_in),
                              .Q(txload2));
    
    stratixgx_lvds_tx_out_block output_module (.clk(clk0_in),
                                             .datain(shift_out),
                                             .dataout(dataout),
                                             .devclrn(devclrn),
                                             .devpor(devpor));
    defparam output_module.bypass_serializer = bypass_serializer;
    defparam output_module.invert_clock = invert_clock;
    defparam output_module.use_falling_clock_edge = use_falling_clock_edge;
    
    stratixgx_lvds_tx_parallel_register input_reg (.clk(txload0),
                                                 .enable(1'b1),
                                                 .datain(datain_dly2),
                                                 .dataout(input_data),
                                                 .devclrn(devclrn),
                                                 .devpor(devpor));
    defparam input_reg.channel_width = channel_width;
        
    always @(datain)
    begin
	    datain_dly <= datain;
    end
    
    always @(datain_dly)
    begin
	    datain_dly2 <= datain_dly;
    end
    
    always @(clk0_in or devclrn or devpor)
    begin
        if ((devpor == 'b0) || (devclrn == 'b0))
        begin
            shift_out <= 1'b0;
            shift_data <= {channel_width{1'b0}};
        end
        else
        begin
            if (bypass_serializer == "false")
            begin
                if ((clk0_in === 1'b1) && (clk0_last_value !== clk0_in))
                begin
                    if (txload2 === 1'b1)
                    begin
                        shift_out <= input_data[channel_width - 1];
                        {tmp_bit, shift_data} <= {input_data, input_data[0]};
                    end
                    else
                    begin
                        shift_out <= shift_data[channel_width - 1];
                        {tmp_bit, shift_data} <= {shift_data, shift_data[0]};
                    end
                end
            end //bypass is off
        end //devpor
                    
        clk0_last_value <= clk0_in;
    end // always

endmodule // stratixgx_lvds_transmitter
//--------------------------------------------------------------------
//
// Module Name : stratixgx_jtag
//
// Description : Stratixgx JTAG Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixgx_jtag (
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

parameter lpm_type = "stratixgx_jtag";

endmodule

//--------------------------------------------------------------------
//
// Module Name : stratixgx_crcblock
//
// Description : Stratixgx CRCBLOCK Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixgx_crcblock (
    clk,
    shiftnld,
   ldsrc,
    crcerror,
    regout);

input clk;
input shiftnld;
input ldsrc;

output crcerror;
output regout;

assign crcerror = 1'b0;
assign regout = 1'b0;

parameter oscillator_divider = 1;
parameter lpm_type = "stratixgx_crcblock";

endmodule

//---------------------------------------------------------------------
//
// Module Name : stratixgx_rublock
//
// Description : Stratixgx RUBLOCK Verilog Simulation model
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixgx_rublock 
	(
	clk, 
	shiftnld, 
	captnupdt, 
	regin, 
	rsttimer, 
	rconfig, 
	regout, 
	pgmout
	);

	parameter operation_mode			= "remote";
	parameter sim_init_config			= "factory";
	parameter sim_init_watchdog_value	= 0;
	parameter sim_init_page_select		= 0;
	parameter sim_init_status			= 0;
	parameter lpm_type					= "stratixgx_rublock";

	input clk;
	input shiftnld;
	input captnupdt;
	input regin;
	input rsttimer;
	input rconfig;

	output regout;
	output [2:0] pgmout;

	reg [16:0] update_reg;
	reg [4:0] status_reg;
	reg [21:0] shift_reg;

	reg [2:0] pgmout_update;

	integer i;

	// initialize registers
	initial
	begin
		if (operation_mode == "local")
			// PGM[] output
			pgmout_update = 1;	
		else
			// PGM[] output
			pgmout_update = 0;	

		// Shift reg
		shift_reg = 0;

		// Status reg
		status_reg = sim_init_status;
		
		// wd_timeout field
		update_reg[16:5] = sim_init_watchdog_value;

		// wd enable field
		if (sim_init_watchdog_value > 0)
			update_reg[4] = 1;
		else
			update_reg[4] = 0;
		
		// PGM[] field
		update_reg[3:1] = sim_init_page_select;

		// AnF bit
		if (sim_init_config == "factory")
			update_reg[0] = 0;
		else
			update_reg[0] = 1;

		$display("Info: Remote Update Block: Initial configuration:");
		$display ("Time: %0t  Instance: %m", $time);
		$display("        -> Field CRC, POF ID, SW ID Error Caused Reconfiguration is set to %s", status_reg[0] ? "True" : "False");
		$display("        -> Field nSTATUS Caused Reconfiguration is set to %s", status_reg[1] ? "True" : "False");
		$display("        -> Field Core nCONFIG Caused Reconfiguration is set to %s", status_reg[2] ? "True" : "False");
		$display("        -> Field Pin nCONFIG Caused Reconfiguration is set to %s", status_reg[3] ? "True" : "False");
		$display("        -> Field Watchdog Timeout Caused Reconfiguration is set to %s", status_reg[4] ? "True" : "False");
		$display("        -> Field Configuration Mode is set to %s", update_reg[0] ? "Application" : "Factory");
		$display("        -> Field PGM[] Page Select is set to %d", update_reg[3:1]);
		$display("        -> Field User Watchdog is set to %s", update_reg[4] ? "Enabled" : "Disabled");
		$display("        -> Field User Watchdog Timeout Value is set to %d", update_reg[16:5]);

	end

	// regout is inverted output of shift-reg bit 0
	assign regout = !shift_reg[0];

	// pgmout is set when reconfig is asserted
	assign pgmout = pgmout_update;

	always @(clk)
	begin
		if (clk == 1)
		begin
			if (shiftnld == 1)
			begin
				// register shifting
				for (i=0; i<=20; i=i+1)
				begin
					shift_reg[i] <= shift_reg[i+1];
				end

				shift_reg[21] <= regin;
			end
			else if (shiftnld == 0)
			begin
				// register loading
				if (captnupdt == 1)
				begin
					// capture data into shift register
					shift_reg <= {update_reg, status_reg};
				end
				else if (captnupdt == 0)
				begin
					// update data from shift into Update Register

					if (operation_mode == "remote" && sim_init_config == "factory")
					begin
						// every bit in Update Reg gets updated
						update_reg[16:0] <= shift_reg[21:5];

						$display("Info: Remote Update Block: Update Register updated at time %d ps", $time);
						$display ("Time: %0t  Instance: %m", $time);
						$display("        -> Field Configuration Mode is set to %s", shift_reg[5] ? "Application" : "Factory");
						$display("        -> Field PGM[] Page Select is set to %d", shift_reg[8:6]);
						$display("        -> Field User Watchdog is set to %s", (shift_reg[9] == 1) ? "Enabled" : (shift_reg[9] == 0) ? "Disabled" : "x");
						$display("        -> Field User Watchdog Timeout Value is set to %d", shift_reg[21:10]);
					end
					else
					begin
						// trying to do update in Application mode
						$display("Warning: Remote Update Block: Attempted update of Update Register at time %d ps when Configuration is set to Application", $time);
						$display ("Time: %0t  Instance: %m", $time);
					end

				end
				else
				begin
					// invalid captnupdt
					// destroys update and shift regs
					shift_reg <= 'bx;
					if (sim_init_config == "factory")
					begin
						update_reg[16:1] <= 'bx;
					end
				end
			end
			else
			begin
				// invalid shiftnld: destroys update and shift regs
				shift_reg <= 'bx;
				if (sim_init_config == "factory")
				begin
					update_reg[16:1] <= 'bx;
				end
			end
		end
		else if (clk != 0)
		begin
			// invalid clk: destroys registers
			shift_reg <= 'bx;
			if (sim_init_config == "factory")
			begin
				update_reg[16:1] <= 'bx;
			end
		end
	end

	always @(rconfig)
	begin
		if (rconfig == 1)
		begin
			// start reconfiguration
			$display("Info: Remote Update Block: Reconfiguration initiated at time %d ps", $time);
			$display ("Time: %0t  Instance: %m", $time);
			$display("        -> Field Configuration Mode is set to %s", update_reg[0] ? "Application" : "Factory");
			$display("        -> Field PGM[] Page Select is set to %d", update_reg[3:1]);
			$display("        -> Field User Watchdog is set to %s", (update_reg[4] == 1) ? "Enabled" : (update_reg[4] == 0) ? "Disabled" : "x");
			$display("        -> Field User Watchdog Timeout Value is set to %d", update_reg[16:5]);

			if (operation_mode == "remote")
			begin
				// set pgm[] to page as set in Update Register
				pgmout_update <= update_reg[3:1];
			end
			else if (operation_mode == "local")
			begin
				// set pgm[] to page as 001
				pgmout_update <= 'b001;
			end
			else
			begin
				// invalid rconfig: destroys pgmout
				pgmout_update <= 'bx;			
			end
		end
		else if (rconfig != 0)
		begin
			// invalid rconfig: destroys pgmout
			pgmout_update <= 'bx;			
		end
	end

endmodule

//------------------------------------------------------------------
//
// Module Name : stratixgx_routing_wire
//
// Description : Simulation model for a simple routing wire
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixgx_routing_wire (
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

endmodule // stratixgx_routing_wire

///////////////////////////////////////////////////////////////////////
//
//                     STRATIXGX_DPA_RECEIVER
//
///////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_rs_deserializer
//
// Description : Verilog simulation model for Deserializer module
//               for Stratixgx DPA reciver. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_rx_deserializer 
    (
    clk0, 
    coreclk, 
    datain, 
    reset, 
    dataout, 
    pclk
    );

    parameter channel_width = 10;
    
    input clk0;
    input coreclk;
    input datain;
    input reset;
    
    output [channel_width - 1:0] dataout;
    output pclk;
    
    
    
    integer i;
    integer clk_count;
    integer clk_count_neg;
    reg clk0_last_value, coreclk_last_value, clkout_last_value;
    reg [channel_width-1:0] deser_data_arr;
    reg clkout_tmp;
    reg [channel_width - 1:0] dataout_tmp;
    wire [channel_width - 1:0] data_out;
    
    // delayed data from DPLL
    reg datain_neg;
    
    reg sync_reset;
    
    reg coreclk_in_dly;
    reg tmp_bit;
    
    // clock delays
    reg coreclk_in;
    
    wire clk0_in;
    wire coreclk_in_pre;
    wire datain_in;
    wire reset_in;
    
    buf (clk0_in, clk0);
    buf (coreclk_in_pre, coreclk);
    buf (datain_in, datain);
    buf (reset_in, reset);
    
wire  [channel_width - 1:0] dataout_opd;

buf buf_dataout  [channel_width - 1:0] (dataout,dataout_opd);
    
    specify
        (posedge clk0 => (dataout +: dataout_tmp)) = (0, 0);
    endspecify
    
    initial
    begin
        i = 0;
        clk_count = 0;
        clk_count_neg = 0;
        clk0_last_value = 1'b0;
        coreclk_last_value = 1'b0;
        sync_reset = 1'b0;
        clkout_tmp = 1'b0;
        datain_neg = 1'b0;
        dataout_tmp = 10'b0;
        deser_data_arr = {channel_width{1'b0}};
    end
    
    always @(coreclk_in_pre)
    begin
        coreclk_in_dly <= coreclk_in_pre;
    end
    
    always @(coreclk_in_dly)
    begin
        coreclk_in <= coreclk_in_dly;
    end
    
    always @(clk0_in or coreclk_in or reset_in)
    begin
        if ((clk0_in == 1'b1) && (clk0_last_value !== clk0_in))
        begin
            clk_count <= (clk_count + 1) % channel_width;
    
            if (sync_reset == 1'b0)
            begin
                if (clk_count % (channel_width / 2) == 0)
                    clkout_tmp <= !clkout_last_value;
                else
                    clkout_tmp <= clkout_last_value;
            end
    
            if (sync_reset == 1'b1) 
                dataout_tmp[channel_width-1:0] <= {channel_width{1'b0}};
            else if ((clk_count_neg == 2)) 
                dataout_tmp[channel_width-1:0] <= deser_data_arr;
    
            {tmp_bit, deser_data_arr} <= {deser_data_arr, datain_neg};
        end
    
        if ((clk0_in == 'b0) && (clk0_last_value !== clk0_in))
        begin
            clk_count_neg <= clk_count_neg + 1;
            datain_neg <= datain_in;
        end
    
        if ((coreclk_in == 1'b1) && (coreclk_last_value !== coreclk_in))
        begin
            if (reset_in == 1'b1)
                sync_reset <= 1'b1;
            else
            begin
                sync_reset <= 1'b0;
              clk_count_neg <= 0;
            end
        end
    
        clk0_last_value <= clk0_in;
        coreclk_last_value <= coreclk_in;
        clkout_last_value <= clkout_tmp;
    end
    
    assign dataout_opd = dataout_tmp; 
    
    and (pclk, clkout_tmp, 1'b1);

endmodule // stratixgx_lvds_rx_deserializer

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_rx_fifo_sync_ram
//
// Description : Verilog simulation model for RX_FIFO SYNC RAM module
//               for Stratixgx DPA reciver. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_rx_fifo_sync_ram 
    (
    clk,
    datain,
    reset, 
    waddr,
    raddr,
    we,
    dataout
    );

    parameter ram_width = 10;
    
    input clk;
    input reset;
    input [ram_width - 1:0] datain;
    input [1:0] waddr;
    input [1:0] raddr;
    input we;
    
    output [ram_width - 1:0] dataout;
    
    
    
    reg [ram_width-1:0] dataout_tmp;
    reg [ram_width-1:0] ram_d0, ram_d1, ram_d2, ram_d3, 
                                ram_q0, ram_q1, ram_q2, ram_q3; 
    wire [ram_width-1:0] data_reg0, data_reg1, data_reg2, data_reg3;  
    
    initial
    begin
        dataout_tmp = 'b0;
        ram_q0 = 1'b0;
        ram_q1 = 1'b0;
        ram_q2 = 1'b0; 
        ram_q3 = 1'b0; 
    end
    
    // Write port 
    
    always @(posedge clk or posedge reset) 
    begin
        if(reset == 1'b1)
        begin
            ram_q0 <= 1'b0;
            ram_q1 <= 1'b0;
            ram_q2 <= 1'b0; 
            ram_q3 <= 1'b0; 
        end
        else 
        begin
            ram_q0 <= ram_d0;
            ram_q1 <= ram_d1;
            ram_q2 <= ram_d2;
            ram_q3 <= ram_d3;
        end
    end
    
    always @(we or 
             data_reg0 or data_reg1 or 
             data_reg2 or data_reg3 or 
             ram_q0 or ram_q1 or
             ram_q2 or ram_q3)    
    begin
        if(we == 1'b1) 
        begin
            ram_d0 <= data_reg0;
            ram_d1 <= data_reg1;
            ram_d2 <= data_reg2;
            ram_d3 <= data_reg3;
       end
       else begin
            ram_d0 <= ram_q0;
            ram_d1 <= ram_q1;
            ram_d2 <= ram_q2;
            ram_d3 <= ram_q3;
       end
    end
    
    // Read port 
    
    assign data_reg0 = ( waddr == 2'b00 ) ? datain : ram_q0;
    assign data_reg1 = ( waddr == 2'b01 ) ? datain : ram_q1;
    assign data_reg2 = ( waddr == 2'b10 ) ? datain : ram_q2;
    assign data_reg3 = ( waddr == 2'b11 ) ? datain : ram_q3;
    
    always @(ram_q0 or ram_q1 or ram_q2 or ram_q3 or we or waddr or raddr)
    begin
        case ( raddr )  
            2'b00 : dataout_tmp = ram_q0;
            2'b01 : dataout_tmp = ram_q1;
            2'b10 : dataout_tmp = ram_q2;
            2'b11 : dataout_tmp = ram_q3;
        endcase
    end
    
    // set output
    assign dataout = dataout_tmp;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_rx_fifo
//
// Description : Verilog simulation model for RX_FIFO module
//               for Stratixgx DPA reciver. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_rx_fifo 
    (
    wclk, 
    rclk, 
    reset, 
    datain, 
    dataout
    );

    parameter channel_width = 10;
    input wclk;
    input rclk;
    input reset;
    input [channel_width - 1 : 0] datain;
    
    output [channel_width - 1 : 0] dataout;
    
    reg [channel_width - 1 : 0] dataout_tmp;
    
    integer i;
    reg [channel_width - 1:0] ram_datain;
    wire [channel_width - 1:0] ram_dataout;
    
    reg [1:0]  wrPtr; // writer pointer
    reg [1:0]  rdPtr; // read pointer
    wire [1:0]  rdAddr;      // read address
    reg ram_we;
    
    reg sync_reset;
    
wire wclk_ipd;
wire rclk_ipd;
wire reset_ipd;
wire [channel_width - 1:0] datain_ipd;

buf buf_wclk (wclk_ipd,wclk);
buf buf_rclk (rclk_ipd,rclk);
buf buf_reset (reset_ipd,reset);
buf buf_datain [channel_width - 1:0] (datain_ipd,datain);
wire  [channel_width - 1:0] dataout_opd;

buf buf_dataout  [channel_width - 1:0] (dataout,dataout_opd);
        
    specify
    
        (posedge rclk => (dataout +: dataout_tmp)) = (0, 0);
    
    endspecify
    
    initial
    begin
        dataout_tmp = 'b0;
        wrPtr = 2'b00;
        rdPtr = 2'b10;
        sync_reset = 1'b0;
    end
    
    assign rdAddr = rdPtr;
    
    stratixgx_lvds_rx_fifo_sync_ram s_fifo_ram (
                                            .clk(wclk_ipd),
                                            .datain(ram_datain),
                                            .reset(sync_reset), 
                                            .waddr(wrPtr),
                                            .raddr(rdAddr),
                                            .we(ram_we),
                                            .dataout(ram_dataout)
                                            ); 
        defparam s_fifo_ram.ram_width = channel_width;
    
    // update pointer and RAM input
    
    always @(posedge wclk_ipd or posedge sync_reset) 
    begin
        if(sync_reset == 'b1) 
        begin
            wrPtr <= 0;
            ram_we <= 1'b0;
        end
        else 
        begin
            ram_datain <= datain_ipd;       // input latch
            ram_we <= 1'b1;
            wrPtr <= (wrPtr + 1) % 4;
        end
    end
    
    always @(posedge rclk_ipd) 
    begin
         sync_reset <= (reset_ipd == 1'b1) ? 1'b1 : 1'b0;
    end
    
    // read from FIFO 
    
    always @(posedge rclk_ipd) 
    begin
        if(reset_ipd == 1'b1) 
            rdPtr <= 2;
        else 
        begin
            if (sync_reset == 1'b1) 
               dataout_tmp <= 'b0;
            else 
            begin
                rdPtr <= (rdPtr + 1) % 4;
                dataout_tmp <= ram_dataout;     //  memory output latch
            end
        end
    end
    
    assign dataout_opd = dataout_tmp; 

endmodule // stratixgx_lvds_rx_fifo

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_rx_bitslip
//
// Description : Verilog simulation model for RX_BITSLIP module
//               for Stratixgx DPA reciver. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_rx_bitslip 
    (
    coreclk, 
    bitslip, 
    rxpdat2, 
    rxpdat3, 
    reset,
    dataout
    );

    parameter channel_width = 10;

    input   coreclk;
    input   bitslip; 
    input   [channel_width - 1 : 0] rxpdat2;
    input   [channel_width - 1 : 0] rxpdat3;
    input   reset;
    
    output [channel_width - 1 : 0] dataout;
    
    
    reg bitslip0;
    reg bitslip1;
    reg bitslip_cntl;
    
    integer slip_count;
    integer i;
    
    reg [channel_width - 1 : 0] dataout_tmp;
    
wire bitslip_ipd;
wire coreclk_ipd;
wire reset_ipd;

buf buf_bitslip (bitslip_ipd,bitslip);
buf buf_coreclk (coreclk_ipd,coreclk);
buf buf_reset (reset_ipd,reset);
wire  [channel_width - 1 : 0] dataout_opd;

buf buf_dataout  [channel_width - 1 : 0] (dataout,dataout_opd);
    
    specify
        (posedge coreclk => (dataout +: dataout_tmp)) = (0, 0);
    endspecify
    
    initial
    begin
        slip_count = 0;
        dataout_tmp = 'b0;
        bitslip0 = 1'b0;
        bitslip1 = 1'b0;
    end
    
    always @(posedge coreclk_ipd)
    begin
        if (reset_ipd)
        begin 
            slip_count <= 0;
            dataout_tmp <= 'b0;
            bitslip0 <= 1'b0;
            bitslip1 <= 1'b0;
            bitslip_cntl <= 1'b0;
        end
        else
        begin
            bitslip_cntl <= bitslip1 & (~bitslip0);
            bitslip1 <= bitslip_ipd;
            bitslip0 <= bitslip1;
        
            if (bitslip_cntl)
            begin
                slip_count <= (slip_count +1) % channel_width;

                // set output
                if(slip_count == (channel_width -1))
                    dataout_tmp <= rxpdat3;
                else
                begin
                    for (i = 0; i < slip_count+1; i = i + 1)
                        dataout_tmp[i] <= rxpdat2[(channel_width - slip_count-1) + i];
        
                    for (i = 0; i < (channel_width - slip_count-1); i = i + 1)
                        dataout_tmp[slip_count+1 + i] <= rxpdat3[i];
                end
            end
            else
            begin
                // set output
                if(slip_count == 0)
                    dataout_tmp <= rxpdat3;
                else
                begin
                    for (i = 0; i < slip_count; i = i + 1)
                        dataout_tmp[i] <= rxpdat2[(channel_width - slip_count) + i];
    
                    for (i = 0; i < (channel_width - slip_count); i = i + 1)
                        dataout_tmp[slip_count + i] <= rxpdat3[i];
                end
            end
        end
    end
    assign dataout_opd = dataout_tmp; 
    
endmodule // stratixgx_lvds_rx_bitslip
    
///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_dpa_receiver
//
// Description : Verilog simulation model for Stratixgx DPA reciver. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_dpa_receiver 
    (
    clk0, 
    coreclk, 
    datain, 
    enable0,
    enable1,
    dpareset, 
    dpllreset, 
    bitslip, 
    devclrn, 
    devpor,
    dataout, 
    dpalock 
    );
    
    parameter channel_width = 10;
    parameter use_enable1 = "false";
    parameter enable_dpa = "off";
    parameter dpll_rawperror = "off";
    parameter dpll_lockwin = 100;
    parameter dpll_lockcnt = 1;
    parameter enable_fifo = "on";
    
    input clk0;
    input coreclk;
    input datain;
    input enable0;
    input enable1;
    input dpareset;
    input dpllreset;
    input bitslip;
    input devclrn;
    input devpor;
    
    output [channel_width - 1:0] dataout;
    output dpalock;
    
    // internal reset signal
    wire reset_int;
    
    // dpalock
    reg dpalock_tmp;
    
    // output from rx_deserializer
    wire [channel_width - 1 : 0] deser_dataout;
    wire deser_pclk;
    
    // input/output of FIFO
    wire [channel_width - 1 : 0] fifo_datain;
    wire fifo_wclk;
    wire fifo_rclk;
    
    wire [channel_width - 1 : 0] fifo_dataout;
    
    // input/output of RXPDAT2
    wire [channel_width - 1 : 0] rxpdat2_datain;
    wire [channel_width - 1 : 0] rxpdat2_dataout;
    
    // input/output of RXPDAT3
    wire [channel_width - 1 : 0] rxpdat3_datain;
    wire [channel_width - 1 : 0] rxpdat3_dataout;
    
    // input/output of bitslip
    wire [channel_width - 1 : 0] slip_pdat2;
    wire [channel_width - 1 : 0] slip_pdat3;
    
    wire dpareset_in;
    wire dpllreset_in;
    
    buf (dpareset_in, dpareset);
    buf (dpllreset_in, dpllreset);
    
    initial
    begin
        dpalock_tmp = 1'b1;
    end
    
    assign reset_int = (!devpor) || (!devclrn) || dpareset_in || dpllreset_in;
    
    // FIFO inputs
    assign fifo_datain = deser_dataout;
    assign fifo_wclk = deser_pclk;
    assign fifo_rclk = coreclk;
    
    // RXPDAT2/3 inputs
    assign rxpdat2_datain = (enable_fifo == "on") ? fifo_dataout : deser_dataout;
    assign rxpdat3_datain = rxpdat2_dataout;
    
    // bitslip inputs
    assign slip_pdat2 = rxpdat2_dataout;
    assign slip_pdat3 = rxpdat3_dataout;
    
    stratixgx_lvds_rx_deserializer s_deserializer (
                                               .clk0(clk0), 
                                               .coreclk(coreclk), 
                                               .datain(datain), 
                                               .reset(reset_int), 
                                               .dataout(deser_dataout), 
                                               .pclk(deser_pclk)
                                               );
        defparam s_deserializer.channel_width = channel_width;
    
    stratixgx_lvds_rx_fifo s_fifo (
                                .wclk(fifo_wclk), 
                                .rclk(fifo_rclk), 
                                .reset(reset_int), 
                                .datain(fifo_datain), 
                                .dataout(fifo_dataout)
                                );
        defparam s_fifo.channel_width = channel_width;
    
    stratixgx_lvds_rx_parallel_register s_rxpdat2 (
                                               .clk(coreclk), 
                                               .enable(1'b1),
                                               .datain(rxpdat2_datain), 
                                               .reset(reset_int),
                                               .devpor(1'b1),
                                               .devclrn(1'b1),
                                               .dataout(rxpdat2_dataout)
                                                );
        defparam s_rxpdat2.channel_width = channel_width;
    
    stratixgx_lvds_rx_parallel_register s_rxpdat3 (
                                               .clk(coreclk), 
                                               .enable(1'b1),
                                               .datain(rxpdat3_datain), 
                                               .reset(reset_int),
                                               .devpor(1'b1),
                                               .devclrn(1'b1),
                                               .dataout(rxpdat3_dataout)
                                                );
        defparam s_rxpdat3.channel_width = channel_width;
    
    stratixgx_lvds_rx_bitslip s_bitslip (
                                     .coreclk(coreclk), 
                                     .bitslip(bitslip), 
                                     .rxpdat2(slip_pdat2), 
                                     .rxpdat3(slip_pdat3), 
                                     .reset(reset_int),
                                     .dataout(dataout)
                                     );
        defparam s_bitslip.channel_width = channel_width;
    
    and (dpalock, dpalock_tmp, 1'b1);

endmodule //stratixgx_dpa_receiver

///////////////////////////////////////////////////////////////////////
//
//                    STRATIXGX_NONDPA_LVDS_RECEIVER
//
///////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_rx_parallel_register
//
// Description : Parallel register used in the Receiver module
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_rx_parallel_register 
    (
    clk, 
    enable, 
    datain, 
    dataout, 
    reset,
    devclrn, 
    devpor
    );

    parameter channel_width = 4;

    // INPUT PORTS
    input [channel_width - 1:0] datain;
    input clk;
    input enable;
    input reset;
    input devclrn;
    input devpor;
    
    // OUTPUT PORTS
    output [channel_width - 1:0] dataout;

    // INTERNAL VARIABLES
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
    specify
        (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
    endspecify
    
    initial
    begin
        clk_last_value = 1'b0;
        dataout_tmp <= 'b0;
    end
    always @(clk_ipd or enable_ipd or devpor or devclrn)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 'b0;
        end
        else
        begin
            if ((clk_ipd === 1'b1) && (clk_last_value !== clk_ipd))
            begin
                if (reset == 1'b1)
                begin
                    dataout_tmp <= 'b0;
                end
                else
                begin
                    if (enable_ipd === 1'b1)
                    begin
                        dataout_tmp <= datain_ipd;
                    end
                end
            end
        end
    
        clk_last_value <= clk_ipd;
    
    end //always
    assign dataout_opd = dataout_tmp; 

endmodule //stratixgx_lvds_rx_parallel_register

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_nondpa_lvds_receiver
//
// Description : Verilog simulation model for Stratixgx LVDS Receiver (non DPA)
//               including the following sub module(s):
//               1. stratixgx_dffe
//               2. stratixgx_lvds_rx_parallel_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_nondpa_lvds_receiver 
    (
    clk0,
    enable0,
    enable1,
    datain,
    dataout,
    devclrn,
    devpor
    );

    parameter channel_width = 4;
    parameter use_enable1 = "false";

    // INPUT PORTS
    input datain;
    input clk0;
    input enable0;
    input enable1;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [channel_width - 1:0] dataout;

    // INTERNAL VARIABLES
    reg clk0_last_value;
    reg [channel_width - 1:0] shift_data;
    wire [channel_width - 1:0] load_data;
    wire rxload0;
    wire rxload1;
    wire rxload2;

    wire txload_in;
    wire txload_out;

    wire clk0_in;
    wire datain_in;

    reg tmp_bit;
    reg rxload2_dly;

    initial
    begin
        clk0_last_value = 1'b0;
        shift_data = 10'b0;
    end
    
    stratixgx_and1 clkdelaybuffer (
                        .Y(clk0_in),
                        .IN1(clk0)
                        );
    
    stratixgx_and1 dataindelaybuffer (
                           .Y(datain_in),
                           .IN1(datain)
                           );
    
    stratixgx_dffe rxload0_reg (
                     .D(enable0),
                     .CLRN(1'b1),
                     .PRN(1'b1),
                     .ENA(1'b1),
                     .CLK(clk0_in),
                     .Q(rxload0)
                     );
    
    stratixgx_dffe rxload1_reg (
                     .D(rxload0),
                     .CLRN(1'b1),
                     .PRN(1'b1),
                     .ENA(1'b1),
                     .CLK(clk0_in),
                     .Q(rxload1)
                     );
    
    stratixgx_dffe rxload2_reg (
                     .D(rxload1),
                     .CLRN(1'b1),
                     .PRN(1'b1),
                     .ENA(1'b1),
                     .CLK(!clk0_in),
                     .Q(rxload2)
                     );
    
    assign txload_in = (use_enable1 == "true") ? enable1 : enable0;
    
    stratixgx_dffe txload_reg (
                    .D(txload_in),
                    .CLRN(1'b1),
                    .PRN(1'b1),
                    .ENA(1'b1),
                    .CLK(clk0_in),
                    .Q(txload_out)
                    );
    
    stratixgx_lvds_rx_parallel_register load_reg (
                                              .clk(!clk0_in),
                                              .enable(rxload2_dly),
                                              .datain(shift_data),
                                              .dataout(load_data),
                                              .reset(1'b0),
                                              .devclrn(devclrn),
                                              .devpor(devpor)
                                              );
        defparam load_reg.channel_width = channel_width;
    
    stratixgx_lvds_rx_parallel_register output_reg (
                                                .clk(txload_out),
                                                .enable(1'b1),
                                                .datain(load_data),
                                                .dataout(dataout),
                                                .reset(1'b0),
                                                .devclrn(devclrn),
                                                .devpor(devpor)
                                                );
        defparam output_reg.channel_width = channel_width;
        
    always @(rxload2)
    begin
        rxload2_dly <= rxload2;
    end
    
    always @(clk0_in or devpor or devclrn) 
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            shift_data <= 10'b0;
        end
        else
        begin
            if ((clk0_in === 1'b0) && (clk0_last_value !== clk0_in))
            begin
                {tmp_bit, shift_data} <= {shift_data, datain_in};
            end
        end //devpor
    
        clk0_last_value <= clk0_in;
    
    end //always

endmodule //stratixgx_nondpa_lvds_receiver

///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixgx_lvds_receiver
//
// Description : Verilog simulation model for Stratixgx LVDS Receiver
//               including the following sub module(s):
//               1. stratixgx_nondpa_lvds_receiver
//               2. stratixgx_dpa_lvds_receiver
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_lvds_receiver 
    (
    clk0, 
    coreclk, 
    datain, 
    enable0,
    enable1,
    dpareset, 
    dpllreset, 
    bitslip, 
    devclrn, 
    devpor,
    dataout, 
    dpalock 
    );

    parameter channel_width = 10;
    parameter use_enable1 = "false";
    parameter enable_dpa = "off";
    parameter dpll_rawperror = "off";
    parameter dpll_lockwin = 100;
    parameter dpll_lockcnt = 1;
    parameter enable_fifo = "on";

    // INPUT PORTS
    input clk0;
    input coreclk;
    input datain;
    input enable0;
    input enable1;
    input dpareset;
    input dpllreset;
    input bitslip;
    input devclrn;
    input devpor;

    // OUTPUT PORTS 
    output [channel_width - 1:0] dataout;
    output dpalock;
    
    tri1 devclrn;
    tri1 devpor;

    // signals for DPA mode
    wire dpa_clk0;
    wire dpa_coreclk;
    wire dpa_datain;
    wire dpa_enable0;
    wire dpa_enable1;
    wire dpa_dpareset;
    wire dpa_dpllreset;
    wire dpa_bitslip;
    wire dpa_devclrn;
    wire dpa_devpor;
    
    wire [channel_width - 1:0] dpa_dataout;
    wire dpa_dpalock;

    // signals for NONDPA mode
    wire nondpa_clk0;
    wire nondpa_datain;
    wire nondpa_enable0;
    wire nondpa_enable1;
    wire nondpa_devclrn;
    wire nondpa_devpor;
    
    wire [channel_width - 1:0] nondpa_dataout;
    
    wire gnd;
    
    assign gnd = 1'b0;

    // inputs to DPA mode
    assign dpa_clk0 = (enable_dpa == "on") ? clk0 : gnd;
    assign dpa_coreclk = (enable_dpa == "on") ? coreclk : gnd;
    assign dpa_datain = (enable_dpa == "on") ? datain : gnd;
    assign dpa_enable0 = gnd;
    assign dpa_enable1 = gnd;
    assign dpa_dpareset = (enable_dpa == "on") ? dpareset : gnd;
    assign dpa_dpllreset = (enable_dpa == "on") ? dpllreset : gnd;
    assign dpa_bitslip = (enable_dpa == "on") ? bitslip : gnd;
    assign dpa_devclrn = (enable_dpa == "on") ? devclrn : gnd;
    assign dpa_devpor = (enable_dpa == "on") ? devpor : gnd;
    
    // inputs to DPA mode
    assign nondpa_clk0 = (enable_dpa == "off") ? clk0 : gnd;
    assign nondpa_datain = (enable_dpa == "off") ? datain : gnd;
    assign nondpa_enable0 = (enable_dpa == "off") ? enable0 : gnd;
    assign nondpa_enable1 = (enable_dpa == "off") ? enable1 : gnd;
    assign nondpa_devclrn = (enable_dpa == "off") ? devclrn : gnd;
    assign nondpa_devpor = (enable_dpa == "off") ? devpor : gnd;

    // sub modules
    stratixgx_nondpa_lvds_receiver s_nondpa_receiver (
                                                  .clk0(nondpa_clk0),
                                                  .enable0(nondpa_enable0), 
                                                  .enable1(nondpa_enable1), 
                                                  .datain(nondpa_datain), 
                                                  .dataout(nondpa_dataout),
                                                  .devclrn(nondpa_devclrn), 
                                                  .devpor(nondpa_devpor)
                                                  );
        defparam s_nondpa_receiver.channel_width = channel_width;
        defparam s_nondpa_receiver.use_enable1 = use_enable1;
    
    stratixgx_dpa_receiver s_dpa_receiver (
                                       .clk0(dpa_clk0),
                                       .coreclk(dpa_coreclk),
                                       .datain(dpa_datain), 
                                       .enable0(dpa_enable0), 
                                       .enable1(dpa_enable1), 
                                       .dpareset(dpa_dpareset), 
                                       .dpllreset(dpa_dpllreset), 
                                       .bitslip(dpa_bitslip), 
                                       .devclrn(dpa_devclrn), 
                                       .devpor(dpa_devpor),
                                       .dataout(dpa_dataout),
                                       .dpalock(dpa_dpalock)
                                       );
        defparam s_dpa_receiver.channel_width = channel_width;
        defparam s_dpa_receiver.use_enable1 = use_enable1;
        defparam s_dpa_receiver.enable_dpa = enable_dpa;
        defparam s_dpa_receiver.dpll_rawperror = dpll_rawperror;
        defparam s_dpa_receiver.dpll_lockwin = dpll_lockwin;
        defparam s_dpa_receiver.dpll_lockcnt = dpll_lockcnt;
        defparam s_dpa_receiver.enable_fifo = enable_fifo;
    
    // generate outputs
    assign dataout = (enable_dpa == "on") ? dpa_dataout : nondpa_dataout;
    assign dpalock = (enable_dpa == "on") ? dpa_dpalock : gnd;

endmodule // stratixgx_lvds_receiver
