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

primitive STRATIXII_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
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

primitive STRATIXII_PRIM_DFFEAS (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

primitive STRATIXII_PRIM_DFFEAS_HIGH (q, d, clk, ena, clr, pre, ald, adt, sclr, sload, notifier  );
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

module stratixii_dffe ( Q, CLK, ENA, D, CLRN, PRN );
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
   
   STRATIXII_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
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


// ***** stratixii_mux21

module stratixii_mux21 (MO, A, B, S);
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

// ***** stratixii_mux41

module stratixii_mux41 (MO, IN0, IN1, IN2, IN3, S);
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

// ***** stratixii_and1

module stratixii_and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** stratixii_and16

module stratixii_and16 (Y, IN1);
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

// ***** stratixii_bmux21

module stratixii_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixii_b17mux21

module stratixii_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** stratixii_nmux21

module stratixii_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** stratixii_b5mux21

module stratixii_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********



//--------------------------------------------------------------------------
// Module Name     : stratixii_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixii_ram_pulse_generator (
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
// Module Name     : stratixii_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixii_ram_register (
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
// Module Name     : stratixii_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module stratixii_ram_block
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
parameter lpm_type = "stratixii_ram_block";
parameter lpm_hint = "true";
parameter connectivity_checking = "off";

 parameter mem_init0 = 2048'b0;
 parameter mem_init1 = 2560'b0;

parameter port_a_byte_size = 0;
parameter port_a_disable_ce_on_input_registers = "off";
parameter port_a_disable_ce_on_output_registers = "off";
parameter port_b_byte_size = 0;
parameter port_b_disable_ce_on_input_registers = "off";
parameter port_b_disable_ce_on_output_registers = "off";


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
input portaaddrstall;
input portbaddrstall;
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

tri0 portaaddrstall_int;
assign portaaddrstall_int = portaaddrstall;
tri0 portbaddrstall_int;
assign portbaddrstall_int = portbaddrstall;
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
`ifdef QUARTUS_MEMORY_PLI
     $memory_connect(mem);
`endif
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

     assign active_a_in = ena0_int || (port_a_disable_ce_on_input_registers == "on");


     assign active_b_in = ((port_b_read_enable_write_enable_clock == "clock0") ? ena0_int : ena1_int) ||
                           (port_b_disable_ce_on_input_registers == "on");


// Store clock enable value for SEAB/MEAB
// port A active
stratixii_ram_register active_port_a (
        .d(active_a_in),
        .clk(clk_a_in),
        .aclr(1'b0),
        .devclrn(1'b1),
        .devpor(1'b1),
.stall(1'b0),
        .ena(1'b1),
        .q(active_a),.aclrout()
);
defparam active_port_a.width = 1;

assign active_write_a = active_a && (byteena_a_reg !== 'b0);

// port B active
stratixii_ram_register active_port_b (
        .d(active_b_in),
        .clk(clk_b_in),
        .aclr(1'b0),
        .devclrn(1'b1),
        .devpor(1'b1),
.stall(1'b0),
        .ena(1'b1),
        .q(active_b),.aclrout()
);
defparam active_port_b.width = 1;

assign active_write_b = active_b && (byteena_b_reg !== 'b0);




// ------- A input registers -------
// write enable
stratixii_ram_register we_a_register (
        .d(mode_is_rom ? 1'b0 : portawe_int),
       .clk(clk_a_in),
        .aclr(we_a_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
        .stall(1'b0),
       .ena(active_a_in),
        .q(we_a_reg),
        .aclrout(we_a_clr)
        );
defparam we_a_register.width = 1;


// address
stratixii_ram_register addr_a_register (
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
stratixii_ram_register datain_a_register (
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
stratixii_ram_register byteena_a_register (
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






// read/write enable
stratixii_ram_register rewe_b_register (
        .d(portbrewe_int),
        .clk(clk_b_in),
        .aclr(rewe_b_clr_in),
 .stall(1'b0),
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(active_b_in),
        .q(rewe_b_reg),
        .aclrout(rewe_b_clr)
        );
defparam rewe_b_register.width = 1;
defparam rewe_b_register.preset = mode_is_dp;

// address
stratixii_ram_register addr_b_register (
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
stratixii_ram_register datain_b_register (
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
stratixii_ram_register byteena_b_register (
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

// Write pulse generation
stratixii_ram_pulse_generator wpgen_a (
       .clk(ram_type ? clk_a_in : ~clk_a_in),
        .ena(active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );

stratixii_ram_pulse_generator wpgen_b (
       .clk(ram_type ? clk_b_in : ~clk_b_in),
        .ena(active_write_b & mode_is_bdp & rewe_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );

// Read pulse generation
stratixii_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
       .ena(active_a & ~we_a_reg),
        .pulse(read_pulse_a),
       .cycle()
        );

stratixii_ram_pulse_generator rpgen_b (
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
stratixii_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in),
       .ena(active_a & ~mode_is_dp & we_a_reg),
        .pulse(read_pulse_a_feedthru),.cycle()
        );

stratixii_ram_pulse_generator ftpgen_b (
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

   assign clkena_a_out = (port_a_data_out_clock == "clock0") ?
                          ena0_int || (port_a_disable_ce_on_output_registers == "on") :
                          ena1_int || (port_a_disable_ce_on_output_registers == "on") ;

stratixii_ram_register dataout_a_register (
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

assign portadataout = (out_a_is_reg) ? dataout_a_reg : dataout_a;


   assign clkena_b_out = (port_b_data_out_clock == "clock0") ?
                          ena0_int || (port_b_disable_ce_on_output_registers == "on") :
                          ena1_int || (port_b_disable_ce_on_output_registers == "on") ;

stratixii_ram_register dataout_b_register (
        .d( dataout_b ),
        .clk(clk_b_out),
        .aclr(dataout_b_clr),
        .devclrn(devclrn),.devpor(devpor),
        .stall(1'b0),
        .ena(clkena_b_out),
        .q(dataout_b_reg),.aclrout()
        );
defparam dataout_b_register.width = port_b_data_width;

assign portbdataout = (out_b_is_reg) ? dataout_b_reg : dataout_b;


endmodule // stratixii_ram_block




//--------------------------------------------------------------------
//
// Module Name : stratixii_jtag
//
// Description : StratixII JTAG Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixii_jtag (
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

parameter lpm_type = "stratixii_jtag";

endmodule

//--------------------------------------------------------------------
//
// Module Name : stratixii_crcblock
//
// Description : StratixII CRCBLOCK Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixii_crcblock (
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
parameter lpm_type = "stratixii_crcblock";

endmodule

//---------------------------------------------------------------------
//
// Module Name : stratixii_asmiblock
//
// Description : StratixII ASMIBLOCK Verilog Simulation model
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixii_asmiblock 
	(
	dclkin,
	scein,
	sdoin,
	data0out,
	oe
	);

input dclkin;
input scein;
input sdoin;
input oe;

output data0out;

parameter lpm_type = "stratixii_asmiblock";

endmodule  // stratixii_asmiblock
//------------------------------------------------------------------
//
// Module Name : stratixii_lcell_ff
//
// Description : StratixII LCELL_FF Verilog simulation model 
//
//------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixii_lcell_ff (
                           datain, 
                           clk, 
                           aclr, 
                           aload, 
                           sclr, 
                           sload, 
                           adatasdata, 
                           ena, 
                           devclrn, 
                           devpor, 
                           regout
                          );
   
parameter x_on_violation = "on";
parameter lpm_type = "stratixii_lcell_ff";

input datain;
input clk;
input aclr;
input aload; 
input sclr; 
input sload; 
input adatasdata; 
input ena; 
input devclrn; 
input devpor; 

output regout;

tri1 devclrn;
tri1 devpor;
   
reg regout_tmp;
wire reset;
   
reg datain_viol;
reg sclr_viol;
reg sload_viol;
reg adatasdata_viol;
reg ena_viol; 
reg violation;

wire wviolation;

reg clk_last_value;
   
reg ix_on_violation;

wire datain_in;
wire clk_in;
wire aclr_in;
wire aload_in;
wire sclr_in;
wire sload_in;
wire adatasdata_in;
wire ena_in;
   
wire nosloadsclr;
wire sloaddata;

buf(wviolation, violation);

buf (datain_in, datain);
buf (clk_in, clk);
buf (aclr_in, aclr);
buf (aload_in, aload);
buf (sclr_in, sclr);
buf (sload_in, sload);
buf (adatasdata_in, adatasdata);
buf (ena_in, ena);
   
assign reset = devpor && devclrn && (!aclr_in) && (ena_in);
assign nosloadsclr = reset && (!sload_in && !sclr_in &&!aload_in);
assign sloaddata = reset && sload_in;
   
specify

    $setuphold (posedge clk &&& nosloadsclr, datain, 0, 0, datain_viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
    $setuphold (posedge clk &&& sloaddata, adatasdata, 0, 0, adatasdata_viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
      
    (posedge clk => (regout +: regout_tmp)) = 0 ;
    (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
    (posedge aload => (regout +: regout_tmp)) = (0, 0) ;
    (adatasdata => regout) = (0, 0) ;
      
endspecify
   
initial
begin
    violation = 'b0;
    clk_last_value = 'b0;
    regout_tmp = 'b0;

    if (x_on_violation == "on")
        ix_on_violation = 1;
    else
        ix_on_violation = 0;
end
   
always @ (datain_viol or sclr_viol or sload_viol or ena_viol or adatasdata_viol)
begin
    if (ix_on_violation == 1)
        violation = 'b1;
end
   
always @ (adatasdata_in or aclr_in or posedge aload_in or 
          devclrn or devpor)
begin
    if (devpor == 'b0)
        regout_tmp <= 'b0;
    else if (devclrn == 'b0)
        regout_tmp <= 'b0;
    else if (aclr_in == 'b1) 
        regout_tmp <= 'b0;
    else if (aload_in == 'b1) 
        regout_tmp <= adatasdata_in;
end
   
always @ (clk_in or posedge aclr_in or posedge aload_in or 
          devclrn or devpor or posedge wviolation)
begin
    if (violation == 1'b1)
    begin
        violation = 'b0;
        regout_tmp <= 1'bX;
    end
    else
    begin
        if (devpor == 'b0 || devclrn == 'b0 || aclr_in === 'b1)
            regout_tmp <= 'b0;
        else if (aload_in === 'b1) 
            regout_tmp <= adatasdata_in;
        else if (ena_in === 'b1 && clk_in === 'b1 && clk_last_value === 'b0)
        begin
            if (sclr_in === 'b1)
                regout_tmp <= 'b0 ;
            else if (sload_in === 'b1)
                regout_tmp <= adatasdata_in;
            else 
                regout_tmp <= datain_in;
        end
    end

    clk_last_value = clk_in;
end

   
and (regout, regout_tmp, 'b1);
   
endmodule

//------------------------------------------------------------------
//
// Module Name : stratixii_lcell_comb
//
// Description : StratixII LCELL_COMB Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixii_lcell_comb (
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
parameter lpm_type = "stratixii_lcell_comb";

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
///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXII_ASYNCH_IO
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module stratixii_asynch_io (
                            datain, 
                            oe, 
                            regin, 
                            ddioregin, 
                            padio, 
                            delayctrlin,
                            offsetctrlin,
                            dqsupdateen,
                            dqsbusout,
                            combout, 
                            regout, 
                            ddioregout
                           );
   
   input datain;
   input oe;
   input regin;
   input ddioregin;
   input [5:0] delayctrlin;
   input [5:0] offsetctrlin;
   input       dqsupdateen;
   output      dqsbusout;
   output combout;
   output regout;
   output ddioregout;
   inout  padio;
   
   parameter operation_mode = "input";
   parameter bus_hold = "false";
   parameter open_drain_output = "false";

   parameter dqs_input_frequency = "10000 ps";
   parameter dqs_out_mode = "none";
   parameter dqs_delay_buffer_mode = "low";
   parameter dqs_phase_shift = 0;
   parameter dqs_offsetctrl_enable = "false";
   parameter dqs_ctrl_latches_enable = "false";
   parameter dqs_edge_detect_enable = "false";  
   parameter sim_dqs_intrinsic_delay = 0;
   parameter sim_dqs_delay_increment = 0;
   parameter sim_dqs_offset_increment = 0;
   parameter gated_dqs = "false";
   
   reg buf_control;
   reg prev_value;
   reg tmp_padio;
   tri padio_tmp;
   
   reg tmp_combout;
   reg combout_tmp;
   reg tmp_dqsbusout;
   wire dqsbusout_tmp;

   reg [1:0] iop_mode;
   
   integer dqs_delay;
   integer tmp_delayctrl;
   integer tmp_offsetctrl;
   wire    dqs_ctrl_latches_ena;
   reg     para_dqs_ctrl_latches_enable;
   reg     para_dqs_offsetctrl_enable;
   reg     para_dqs_edge_detect_enable;

   wire [5:0] delayctrlin_in;
   wire [5:0] offsetctrlin_in;

   wire datain_in;
   wire oe_in;
   wire dqsupdateen_in;
   wire delayctrlin_in0;
   wire delayctrlin_in1;
   wire delayctrlin_in2;
   wire delayctrlin_in3;
   wire delayctrlin_in4;
   wire delayctrlin_in5;
   wire offsetctrlin_in0;
   wire offsetctrlin_in1;
   wire offsetctrlin_in2;
   wire offsetctrlin_in3;
   wire offsetctrlin_in4;
   wire offsetctrlin_in5;

   buf(datain_in, datain);
   buf(oe_in, oe);
   buf(dqsupdateen_in, dqsupdateen);
   buf(delayctrlin_in0, delayctrlin[0]);
   buf(delayctrlin_in1, delayctrlin[1]);
   buf(delayctrlin_in2, delayctrlin[2]);
   buf(delayctrlin_in3, delayctrlin[3]);
   buf(delayctrlin_in4, delayctrlin[4]);
   buf(delayctrlin_in5, delayctrlin[5]);
   buf(offsetctrlin_in0, offsetctrlin[0]);
   buf(offsetctrlin_in1, offsetctrlin[1]);
   buf(offsetctrlin_in2, offsetctrlin[2]);
   buf(offsetctrlin_in3, offsetctrlin[3]);
   buf(offsetctrlin_in4, offsetctrlin[4]);
   buf(offsetctrlin_in5, offsetctrlin[5]);
   assign delayctrlin_in = {delayctrlin_in5, delayctrlin_in4,
                            delayctrlin_in3, delayctrlin_in2,
							delayctrlin_in1, delayctrlin_in0};
   assign offsetctrlin_in = {offsetctrlin_in5, offsetctrlin_in4,
                             offsetctrlin_in3, offsetctrlin_in2,
							 offsetctrlin_in1, offsetctrlin_in0};
   
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
      (datain => padio) = (0, 0);
      (posedge oe => (padio +: padio_tmp)) = (0, 0);
      (negedge oe => (padio +: 1'bz)) = (0, 0);
      (ddioregin => ddioregout) = (0, 0);
      (regin => regout) = (0, 0);
	  (padio => dqsbusout) = (0, 0);
	  (regin => dqsbusout) = (0, 0);
   endspecify
   
   initial
   begin
      prev_value = 'b0;
      tmp_padio = 'bz;
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

      dqs_delay = 0;
      tmp_delayctrl = 0;
      tmp_offsetctrl = 0;
      para_dqs_ctrl_latches_enable = dqs_ctrl_latches_enable == "true" ? 1'b1 : 1'b0;
      para_dqs_offsetctrl_enable = dqs_offsetctrl_enable == "true" ? 1'b1 : 1'b0;
      para_dqs_edge_detect_enable = dqs_edge_detect_enable == "true" ? 1'b1 : 1'b0;
   end

   assign dqs_ctrl_latches_ena = dqs_ctrl_latches_enable == "false" ? 1'b1 : 
                                 dqs_edge_detect_enable == "false" ? dqsupdateen_in :
                                 (~(combout_tmp ^ tmp_dqsbusout) & dqsupdateen_in);

   always @(delayctrlin_in or offsetctrlin_in or dqs_ctrl_latches_ena)
   begin
      tmp_delayctrl  = (dqs_delay_buffer_mode == "high" && delayctrlin_in[5] == 1'b1) ? 31 : delayctrlin_in;
      tmp_offsetctrl = (para_dqs_offsetctrl_enable == 1'b0) ? 0 : 
                       (dqs_delay_buffer_mode == "high" && offsetctrlin_in[5] == 1'b1) ? 31 : offsetctrlin_in;
                       
      if (dqs_ctrl_latches_ena === 1'b1)
	     dqs_delay = sim_dqs_intrinsic_delay + sim_dqs_delay_increment*tmp_delayctrl + sim_dqs_offset_increment*tmp_offsetctrl;

      if (dqs_delay_buffer_mode == "high" && delayctrlin_in[5] == 1'b1)
      begin
         $display($time, " Warning: delayctrlin of DQS I/O instannce %m exceeds a 5-bit range in high-frequency mode.");
      end
      if (dqs_delay_buffer_mode == "high" && offsetctrlin_in[5] == 1'b1)
      begin
         $display($time, " Warning: offsetctrlin of DQS I/O instannce %m exceeds a 5-bit range in high-frequency mode.");
      end
   end
 
    always @(datain_in or oe_in or padio)
    begin   
        if (bus_hold == "true" )
        begin
            buf_control = 'b1;
            if (iop_mode == 0)
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
                $display ("Error: Invalid operation_mode specified in stratixii io atom!\n");
                $display ("Time: %0t  Instance: %m", $time);
            end
        end      
        combout_tmp <= tmp_combout;
        tmp_dqsbusout <= #(dqs_delay) tmp_combout;
   end  
   
   assign dqsbusout_tmp = gated_dqs == "true" ? (tmp_dqsbusout & regin) : tmp_dqsbusout;
   
   bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
   pmos (padio_tmp, tmp_padio, 'b0);
   pmos (combout, combout_tmp, 'b0);
   pmos (dqsbusout, dqsbusout_tmp, 'b0);
   pmos (padio, padio_tmp, 'b0);
   and (regout, regin, 1'b1);
   and (ddioregout, ddioregin, 1'b1);

endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                             STRATIXII_IO_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

module  stratixii_io_register (
                               clk, 
                               datain, 
                               ena, 
                               sreset, 
                               areset, 
                               devclrn, 
                               devpor, 
                               regout
                              );
   parameter async_reset = 1'bx;
   parameter sync_reset = "none";
   parameter power_up = "low";
   
   input clk;
   input ena;
   input datain;
   input areset;
   input sreset;
   input devclrn;
   input devpor ;
   output regout;
   
   reg iregout;
   wire reset;
   wire is_areset_clear;
   wire is_areset_preset;
   
   reg datain_viol;
   reg sreset_viol;
   reg ena_viol;
   reg violation;
   
   reg clk_last_value;
   
wire w_violation;

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
   
buf(w_violation, violation);

   assign reset = devpor && devclrn && !(iareset && async_reset != 1'bx) && (iena);
   assign is_areset_clear = (async_reset == 1'b0)?1'b1:1'b0;
   assign is_areset_preset = (async_reset == 1'b1)?1'b1:1'b0;
   
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
         iregout <= 'b0;
      else if (power_up == "high")
         iregout <= 'b1;
      end
   
   always @ (datain_viol or sreset_viol or ena_viol)
   begin
      violation = 1;
   end
   
   always @ (clk_in or posedge iareset or negedge devclrn or negedge devpor or posedge w_violation)
   begin
      if (violation == 1'b1)
      begin
         violation = 0;
         iregout <= 1'bx;
      end
      else if (devpor == 'b0)
      begin
         if (power_up == "low")
            iregout <= 'b0;
         else if (power_up == "high")
            iregout <= 'b1;
      end
      else if (devclrn == 'b0)
         iregout <= 'b0;
      else if (async_reset == "clear" && iareset == 'b1) 
         iregout <= 'b0 ;
      else if (async_reset == "preset" && iareset == 'b1 )
         iregout <= 'b1;
      else if (iena == 'b1 && clk_in == 'b1 && clk_last_value == 'b0)
      begin
          if (sync_reset == "clear" && isreset == 'b1)
              iregout <= 'b0 ;
          else if (sync_reset == "preset" && isreset == 'b1)
              iregout <= 'b1;
         else
              iregout <= idatain ;
      end
      clk_last_value = clk_in;
   end
   and (regout, iregout, 'b1) ;
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                             STRATIXII_IO_LATCH
//
///////////////////////////////////////////////////////////////////////////////

module  stratixii_io_latch (
                               clk, 
                               datain, 
                               ena, 
                               sreset, 
                               areset, 
                               devclrn, 
                               devpor, 
                               regout
                              );
   parameter async_reset = 1'bx;
   parameter sync_reset = "none";
   parameter power_up = "low";
   
   input clk;
   input ena;
   input datain;
   input areset;
   input sreset;
   input devclrn;
   input devpor ;
   output regout;
   
   reg iregout;
   wire reset;
   wire is_areset_clear;
   wire is_areset_preset;
   
   reg datain_viol;
   reg sreset_viol;
   reg ena_viol;
   reg violation;
   
   wire w_violation;
   
   reg clk_last_value;
   
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
   
   buf(w_violation, violation);
   
   assign reset = devpor && devclrn && !(iareset && async_reset != 1'bx) && (iena);
   
   assign is_areset_clear = (async_reset == 1'b0)?1'b1:1'b0;
   assign is_areset_preset = (async_reset == 1'b1)?1'b1:1'b0;
   
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
   
   always @ (idatain or clk_in or posedge iareset or negedge devclrn or negedge devpor or posedge w_violation)
   begin
      if (violation == 1'b1)
      begin
         violation = 0;
         iregout = 1'bx;
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
      else if (async_reset == 1'b0 && iareset == 'b1) 
         iregout = 'b0 ;
      else if (async_reset == 1'b1 && iareset == 'b1 )
         iregout = 'b1;
      else if (iena == 'b1 && clk_in == 'b1)
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

///////////////////////////////////////////////////////////////////////////////
//
//                                STRATIXII_IO
//
///////////////////////////////////////////////////////////////////////////////

module stratixii_io (
                     datain,
                     ddiodatain,
                     oe,
                     outclk,
                     outclkena,
                     inclk,
                     inclkena,
                     areset,
                     sreset,
                     ddioinclk,
                     delayctrlin,
                     offsetctrlin,
                     dqsupdateen,
                     linkin,
                     terminationcontrol,
                     devclrn,
                     devpor,
                     devoe,
                     padio,
                     combout,
                     regout,
                     ddioregout,
                     dqsbusout,
                     linkout
                    );
   
parameter operation_mode = "input";
parameter ddio_mode = "none";
parameter open_drain_output = "false";
parameter bus_hold = "false";
   
parameter output_register_mode = "none";
parameter output_async_reset = "none";
parameter output_power_up = "low";
parameter output_sync_reset = "none";
parameter tie_off_output_clock_enable = "false";
   
parameter oe_register_mode = "none";
parameter oe_async_reset = "none";
parameter oe_power_up = "low";
parameter oe_sync_reset = "none";
parameter tie_off_oe_clock_enable = "false";
   
parameter input_register_mode = "none";
parameter input_async_reset = "none";
parameter input_power_up = "low";
parameter input_sync_reset = "none";
   
parameter extend_oe_disable = "false";
 
parameter dqs_input_frequency = "10000 ps";
parameter dqs_out_mode = "none";
parameter dqs_delay_buffer_mode = "low";
parameter dqs_phase_shift = 0;
parameter inclk_input = "normal";
parameter ddioinclk_input = "negated_inclk";
parameter dqs_offsetctrl_enable = "false";
parameter dqs_ctrl_latches_enable = "false";
parameter dqs_edge_detect_enable = "false";
parameter gated_dqs = "false";

parameter sim_dqs_intrinsic_delay = 0;
parameter sim_dqs_delay_increment = 0;
parameter sim_dqs_offset_increment = 0;
  
parameter lpm_type = "stratixii_io";
  
input datain;
input ddiodatain;
input oe;
input outclk;
input outclkena;
input inclk;
input inclkena;
input areset;
input sreset;
input ddioinclk;
input [5:0] delayctrlin;
input [5:0] offsetctrlin;
input dqsupdateen;
input linkin;
input [13:0] terminationcontrol;
input devclrn;
input devpor;
input devoe;
  
inout padio;
  
output combout;
output regout;
output ddioregout;
output dqsbusout;
output linkout;

tri1 devclrn;
tri1 devpor;
tri1 devoe;
     
wire      oe_reg_out, oe_pulse_reg_out;
wire      in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out;
wire      out_reg_out, out_ddio_reg_out;
   
wire      out_clk_ena, oe_clk_ena;
wire      tmp_datain;
wire      ddio_data;
wire      oe_out;
wire      outclk_delayed;

wire      para_ddioinclk_input;
wire      neg_ireg_clk;
wire      para_gated_dqs;

assign para_ddioinclk_input = ddioinclk_input == "dqsb_bus" ? 1'b1 : 1'b0;
assign neg_ireg_clk = para_ddioinclk_input === 1'b1 ? !ddioinclk : inclk;
assign para_gated_dqs = gated_dqs == "true" ? 1'b1 : 1'b0;
  
assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : 1'b1;
   
   //input register
   stratixii_io_register in_reg (
                                 .regout(in_reg_out), 
                                 .clk(inclk), 
                                 .ena(inclkena),
                                 .datain(padio), 
                                 .areset(areset),
                                 .sreset(sreset), 
                                 .devpor(devpor),
                                 .devclrn(devclrn)
                                );
   defparam in_reg.async_reset = input_async_reset;
   defparam in_reg.sync_reset = input_sync_reset;
   defparam in_reg.power_up = input_power_up;
   
   // in_ddio0_reg
   stratixii_io_register in_ddio0_reg (
                                       .regout(in_ddio0_reg_out),
                                       .clk(!neg_ireg_clk), 
                                       .ena (inclkena),
                                       .datain(padio), 
                                       .areset(areset),
                                       .sreset(sreset),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam in_ddio0_reg.async_reset = input_async_reset;
   defparam in_ddio0_reg.sync_reset = input_sync_reset;
   defparam in_ddio0_reg.power_up = input_power_up;
   
   // in_ddio1_latch
   stratixii_io_latch in_ddio1_reg (
                                       .regout(in_ddio1_reg_out),
                                       .clk(inclk), 
                                       .ena(inclkena),
                                       .datain(in_ddio0_reg_out),
                                       .areset(areset),
                                       .sreset(1'b0),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam in_ddio1_reg.async_reset = input_async_reset;
   defparam in_ddio1_reg.sync_reset = "none"; // this register has no sync_reset
   defparam in_ddio1_reg.power_up = input_power_up;
   
   // out_reg
   stratixii_io_register out_reg (
                                  .regout(out_reg_out),
                                  .clk(outclk), 
                                  .ena(out_clk_ena),
                                  .datain(datain), 
                                  .areset(areset),
                                  .sreset(sreset),
                                  .devpor(devpor),
                                  .devclrn(devclrn)
                                 );
   defparam out_reg.async_reset = output_async_reset;
   defparam out_reg.sync_reset = output_sync_reset;
   defparam out_reg.power_up = output_power_up;
   
   // out ddio reg
   stratixii_io_register out_ddio_reg (
                                       .regout(out_ddio_reg_out), 
                                       .clk(outclk), 
                                       .ena(out_clk_ena),
                                       .datain(ddiodatain), 
                                       .areset(areset),
                                       .sreset(sreset),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam out_ddio_reg.async_reset = output_async_reset;
   defparam out_ddio_reg.sync_reset = output_sync_reset;
   defparam out_ddio_reg.power_up = output_power_up;
   
   // oe reg
   stratixii_io_register oe_reg (
                                 .regout (oe_reg_out),
                                 .clk(outclk), 
                                 .ena(oe_clk_ena),
                                 .datain(oe), 
                                 .areset(areset),
                                 .sreset(sreset),
                                 .devpor(devpor),
                                 .devclrn(devclrn) 
                                );
   defparam oe_reg.async_reset = oe_async_reset;
   defparam oe_reg.sync_reset = oe_sync_reset;
   defparam oe_reg.power_up = oe_power_up;
   
   // oe_pulse reg
   stratixii_io_register oe_pulse_reg (
                                       .regout(oe_pulse_reg_out),
                                       .clk(!outclk),
                                       .ena(oe_clk_ena),
                                       .datain(oe_reg_out), 
                                       .areset(areset),
                                       .sreset(sreset),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam oe_pulse_reg.async_reset = oe_async_reset;
   defparam oe_pulse_reg.sync_reset = oe_sync_reset;
   defparam oe_pulse_reg.power_up = oe_power_up;
   
   assign oe_out = (oe_register_mode == "register") ? 
		   (extend_oe_disable == "true" ? oe_pulse_reg_out && oe_reg_out : oe_reg_out) : oe;
    
   stratixii_and1    sel_delaybuf (.Y(outclk_delayed), .IN1(outclk));
   
   stratixii_mux21   ddio_data_mux (
                          .MO (ddio_data),
                          .A (out_ddio_reg_out),
                          .B (out_reg_out),
                          .S (outclk_delayed)
                         );
   
   assign tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? 
                ddio_data : ((operation_mode == "output" || operation_mode == "bidir") ? 
                   ((output_register_mode == "register") ? out_reg_out : datain) : 'b0);
         
   // timing info in case output and/or input are not registered.
   stratixii_asynch_io inst1 (
                              .datain(tmp_datain),
                              .oe(oe_out),
                              .regin(in_reg_out),
                              .ddioregin(in_ddio1_reg_out),
                              .padio(padio),
                              .delayctrlin(delayctrlin),
                              .offsetctrlin(offsetctrlin),
							  .dqsupdateen(dqsupdateen),
							  .dqsbusout(dqsbusout),
                              .combout(combout),
                              .regout(regout),
                              .ddioregout(ddioregout)
                             );
   defparam inst1.operation_mode = operation_mode;
   defparam inst1.bus_hold = bus_hold;
   defparam inst1.open_drain_output = open_drain_output;

   defparam inst1.dqs_input_frequency = dqs_input_frequency;
   defparam inst1.dqs_out_mode = dqs_out_mode;
   defparam inst1.dqs_delay_buffer_mode = dqs_delay_buffer_mode;
   defparam inst1.dqs_phase_shift = dqs_phase_shift;
   defparam inst1.dqs_offsetctrl_enable = dqs_offsetctrl_enable;
   defparam inst1.dqs_ctrl_latches_enable = dqs_ctrl_latches_enable;
   defparam inst1.dqs_edge_detect_enable = dqs_edge_detect_enable;    
   defparam inst1.sim_dqs_intrinsic_delay = sim_dqs_intrinsic_delay;
   defparam inst1.sim_dqs_delay_increment = sim_dqs_delay_increment;
   defparam inst1.sim_dqs_offset_increment = sim_dqs_offset_increment;
   defparam inst1.gated_dqs = gated_dqs;
   
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixII_dll
//
// Description : Simulation model for StratixII DLL block
//
// Outputs     : delayctrlout - current delay chain settings for DQS pin
//               offsetctrlout - current delay offset setting
//               dqsupdate - update enable signal for delay setting latces
//               upndnout - raw output of the phase comparator
//
// Inputs      : clk - reference clock matching in frequency to DQS clock
//               aload - asychronous load signal for delay setting counter
//                       when asserted, counter is loaded with initial value
//               offset - offset added/subtracted from delayctrlout
//               upndnin - up/down input port for delay setting counter in
//                         use_updndnin mode (user control mode)
//               upndninclkena - clock enable for the delaying setting counter
//               addnsub - dynamically control +/- on offsetctrlout
//
// Formulae    : delay (input_period) = sim_loop_intrinsic_delay + 
//                                      sim_loop_delay_increment * dllcounter;
//
// Latency     : 3 (clk8 cycles) = pc + dc + dr
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixii_dll (
    clk, 
    aload, 
    offset, 
    upndnin, 
    upndninclkena, 
    addnsub, 
    delayctrlout, 
    offsetctrlout, 
    dqsupdate, 
    upndnout, 
    devclrn, 
    devpor);

// GLOBAL PARAMETERS - total 15
parameter input_frequency    = "10000 ps";
parameter delay_chain_length = 16;
parameter delay_buffer_mode  = "low";   // consistent with dqs
parameter delayctrlout_mode  = "normal";
parameter static_delay_ctrl  = 0;        // for test
parameter offsetctrlout_mode = "static";
parameter static_offset      = "0";
parameter jitter_reduction   = "false";
parameter use_upndnin        = "false";
parameter use_upndninclkena  = "false";
parameter sim_valid_lock     = 1;
parameter sim_loop_intrinsic_delay = 1000;
parameter sim_loop_delay_increment = 100;
parameter sim_valid_lockcount      = 90;  // 10000 = 1000 + 100*dllcounter
parameter lpm_type                 = "stratixii_dll";

// INPUT PORTS
input        clk;
input        aload;
input [5:0]  offset;
input        upndnin;
input        upndninclkena;
input        addnsub;
input        devclrn;
input        devpor;

// OUTPUT PORTS
output [5:0] delayctrlout;
output [5:0] offsetctrlout;
output       dqsupdate;
output       upndnout;

tri1 devclrn;
tri1 devpor;

// BUFFERED BUS INPUTS
wire [5:0] offset_in;

// TMP OUTPUTS
wire [5:0] delayctrl_out;
wire [5:0] offsetctrl_out;
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
reg [1:0] para_offsetctrlout_mode;
integer   para_static_offset;
integer   para_static_delay_ctrl;
reg       para_jitter_reduction;
reg       para_use_upndnin;
reg       para_use_upndninclkena;
 

// INTERNAL NETS AND VARIABLES

// for functionality - by modules

// delay and offset control out resolver
wire [5:0] dr_delayctrl_out;
wire [5:0] dr_delayctrl_int;
wire [5:0] dr_offsetctrl_out;
wire [5:0] dr_offsetctrl_int;
wire [5:0] dr_offset_in;
wire [5:0] dr_dllcount_in;
wire       dr_addnsub_in;
wire       dr_clk8_in;
wire       dr_aload_in;

reg  [5:0] dr_reg_offset;
reg  [5:0] dr_reg_dllcount;

// delay chain setting counter
wire [5:0] dc_dllcount_out;
wire       dc_dqsupdate_out;
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

integer    jc_count;
reg        jc_reg_upndn;
reg        jc_reg_upndnclkena;

// phase comparator
wire       pc_upndn_out;
wire [5:0] pc_dllcount_in;
wire       pc_clk1_in;
wire       pc_clk8_in;
wire       pc_aload_in;

reg        pc_reg_upndn;
integer    pc_delay; 

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
wire aload_in;
wire offset_in5;
wire offset_in4;
wire offset_in3;
wire offset_in2;
wire offset_in1;
wire offset_in0;
wire upndn_in;
wire upndninclkena_in; 
wire addnsub_in;

buf (clk_in, clk);
buf (aload_in, aload);
buf (offset_in5, offset[5]);
buf (offset_in4, offset[4]);
buf (offset_in3, offset[3]);
buf (offset_in2, offset[2]);
buf (offset_in1, offset[1]);
buf (offset_in0, offset[0]);
buf (upndn_in, upndnin);
buf (upndninclkena_in, upndninclkena); 
buf (addnsub_in, addnsub);

assign offset_in = {offset_in5, offset_in4, 
                    offset_in3, offset_in2, 
                    offset_in1, offset_in0};

// TCO DELAYS, IO PATH and SETUP-HOLD CHECKS
specify
	(posedge clk => (delayctrlout[0] +: delayctrl_out[0])) = (0, 0);
	(posedge clk => (delayctrlout[1] +: delayctrl_out[1])) = (0, 0);
	(posedge clk => (delayctrlout[2] +: delayctrl_out[2])) = (0, 0);
	(posedge clk => (delayctrlout[3] +: delayctrl_out[3])) = (0, 0);
	(posedge clk => (delayctrlout[4] +: delayctrl_out[4])) = (0, 0);
	(posedge clk => (delayctrlout[5] +: delayctrl_out[5])) = (0, 0);

    (posedge clk  => (upndnout +: upndn_out)) = (0, 0);
    (offset => delayctrlout) = (0, 0);

	$setuphold(posedge clk, offset[0], 0, 0);
	$setuphold(posedge clk, offset[1], 0, 0);
	$setuphold(posedge clk, offset[2], 0, 0);
	$setuphold(posedge clk, offset[3], 0, 0);
	$setuphold(posedge clk, offset[4], 0, 0);
	$setuphold(posedge clk, offset[5], 0, 0);
	$setuphold(posedge clk, upndnin, 0, 0);
	$setuphold(posedge clk, upndninclkena, 0, 0);
	$setuphold(posedge clk, addnsub, 0, 0);
endspecify

// DRIVERs FOR outputs
and (delayctrlout[0], delayctrl_out[0], 1'b1);
and (delayctrlout[1], delayctrl_out[1], 1'b1);
and (delayctrlout[2], delayctrl_out[2], 1'b1);
and (delayctrlout[3], delayctrl_out[3], 1'b1);
and (delayctrlout[4], delayctrl_out[4], 1'b1);
and (delayctrlout[5], delayctrl_out[5], 1'b1);
and (offsetctrlout[0], offsetctrl_out[0], 1'b1);
and (offsetctrlout[1], offsetctrl_out[1], 1'b1);
and (offsetctrlout[2], offsetctrl_out[2], 1'b1);
and (offsetctrlout[3], offsetctrl_out[3], 1'b1);
and (offsetctrlout[4], offsetctrl_out[4], 1'b1);
and (offsetctrlout[5], offsetctrl_out[5], 1'b1);
and (dqsupdate, dqsupdate_out, 1'b1);
and (upndnout, upndn_out, 1'b1);


// INITIAL BLOCK - info messsage and legaity checks
initial
begin
    input_period = str2int(input_frequency);
    $display("Note: DLL instance %m has input frequency %0d ps", input_period);
    $display("      sim_valid_lock %0d", sim_valid_lock);
    $display("      sim_valid_lockcount %0d", sim_valid_lockcount);
    $display("      sim_loop_intrinsic_delay %0d", sim_loop_intrinsic_delay);
    $display("      sim_loop_delay_increment %0d", sim_loop_delay_increment);

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
    para_delayctrlout_mode = delayctrlout_mode == "offset_only" ? 2'b01 : 
	                         delayctrlout_mode == "normal_offset" ? 2'b10 : 
                     		 delayctrlout_mode == "static" ? 2'b11 : 2'b00;
    para_offsetctrlout_mode = offsetctrlout_mode == "dynamic_addnsub" ? 2'b11 :
                              offsetctrlout_mode == "dynamic_sub" ? 2'b10 :
	                          offsetctrlout_mode == "dynamic_add" ? 2'b01 : 2'b00;
    para_static_offset = str2int(static_offset);
	para_static_delay_ctrl = static_delay_ctrl;
    para_jitter_reduction = jitter_reduction == "true" ? 1'b1 : 1'b0;
    para_use_upndnin = use_upndnin == "true" ? 1'b1 : 1'b0;
    para_use_upndninclkena = use_upndninclkena == "true" ? 1'b1 : 1'b0;

    $display("      delay_buffer_mode %0s", delay_buffer_mode);
    $display("      delayctrlout_mode %0s", delayctrlout_mode);
    $display("      static_delay_ctrl %0d", para_static_delay_ctrl);
    $display("      offsetctrlout_mode %0s", offsetctrlout_mode);
    $display("      static_offset %0d", para_static_offset);
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
assign offsetctrl_out = dr_offsetctrl_out;
assign dqsupdate_out  = cg_clk8a_out;
assign upndn_out      = pc_upndn_out;

// Delay and offset ctrl out resolver -----------------------------------------

    // inputs
    assign dr_clk8_in = ~cg_clk8b_out;       // inverted
    assign dr_offset_in = ((offsetctrlout_mode == "dynamic_addnsub" &&  dr_addnsub_in === 1'b0) || (offsetctrlout_mode == "dynamic_sub"))  ? 
                           (6'b111111 - offset_in + 6'b000001) : offset_in;
    assign dr_dllcount_in = dc_dllcount_out; 
    assign dr_addnsub_in = addnsub_in;
    assign dr_aload_in = aload_in;

    // outputs
    assign dr_delayctrl_out = (delayctrlout_mode == "test") ? {cg_clk1_out,aload,addnsub,dr_reg_dllcount[2:0]} :
                              (delayctrlout_mode == "offset_only")   ?  dr_offset_in  :
                              (delayctrlout_mode == "normal_offset") ?  dr_reg_offset 
							  : dr_reg_dllcount;  // both static and normal

	assign dr_offsetctrl_out = dr_reg_offset; 

    // model

	assign dr_delayctrl_int = (delayctrlout_mode == "static") ? para_static_delay_ctrl : dr_dllcount_in;
    
    assign dr_offsetctrl_int = (offsetctrlout_mode == "static") ? para_static_offset : dr_offset_in;
     
	// por
    initial
    begin
        dr_reg_offset = 6'b000000;
        dr_reg_dllcount = 6'b000000;
    end

    always @(posedge dr_clk8_in or posedge dr_aload_in )
    begin
        if (dr_aload_in === 1'b1)
            dr_reg_dllcount <= 6'b000000;
        else    
            dr_reg_dllcount <= dr_delayctrl_int;
    end

    always @(posedge dr_clk8_in or posedge dr_aload_in)
    begin
        if (dr_aload_in === 1'b1)
        begin
            dr_reg_offset <= 6'b000000;
        end
        else if (offsetctrlout_mode == "dynamic_addnsub")      // addnsub
        begin
            if (dr_addnsub_in === 1'b1)
                if (dr_delayctrl_int < 6'b111111 - dr_offset_in)
                    dr_reg_offset <= dr_delayctrl_int + dr_offset_in;
                else 
				    dr_reg_offset <= 6'b111111;
            else if (dr_addnsub_in === 1'b0)
                if (dr_delayctrl_int > dr_offset_in)
                    dr_reg_offset <= dr_delayctrl_int - dr_offset_in;
                else
                    dr_reg_offset <= 6'b000000;
        end
        else if (offsetctrlout_mode == "dynamic_sub")  // sub
        begin
            if (dr_delayctrl_int > dr_offset_in)
                dr_reg_offset <= dr_delayctrl_int - dr_offset_in;
            else
                dr_reg_offset <= 6'b000000;
        end     
        else if (offsetctrlout_mode == "dynamic_add")  // add
        begin
            if (dr_delayctrl_int < 6'b111111 - dr_offset_in)
                dr_reg_offset <= dr_delayctrl_int + dr_offset_in;
            else 
                dr_reg_offset <= 6'b111111;
        end
        else if (offsetctrlout_mode == "static")       // static
        begin
	        if (para_static_offset >= 0)
                if (para_static_offset < 64 && para_static_offset < 6'b111111 - dr_delayctrl_int)
                    dr_reg_offset <= dr_delayctrl_int + para_static_offset;
				else
				    dr_reg_offset <= 6'b111111;
            else
                if (para_static_offset > -63 && dr_delayctrl_int > (-1)*para_static_offset)
                    dr_reg_offset <= dr_delayctrl_int + para_static_offset;
                else
                    dr_reg_offset <= 6'b000000;
        end
        else
    	    dr_reg_offset <= 6'b001110;  // Error
    end

// Delay Setting Control Counter ----------------------------------------------
            
    //inputs
    assign dc_dlltolock_in = dll_to_lock;
    assign dc_aload_in = aload_in;
    assign dc_clk1_in = cg_clk1_out;
    assign dc_clk8_in = ~cg_clk8b_out;      // inverted
    assign dc_upndnclkena_in = (para_jitter_reduction === 1'b1) ? jc_upndnclkena_out : 
	                           (para_use_upndninclkena === 1'b1) ? upndninclkena : 1'b1;
    assign dc_upndn_in = (para_use_upndnin === 1'b1) ? upndnin :
	                     (para_jitter_reduction === 1'b1) ? jc_upndn_out : pc_upndn_out;

    // outputs
    assign dc_dllcount_out = dc_reg_dllcount;

    // parameters used
    // sim_valid_lockcount - ideal dll count value
    // delay_buffer_mode - 

    // Model
    initial
    begin		
        // low=32=6'b100000 others=16
        dc_reg_dllcount = delay_buffer_mode == "low" ? 6'b100000 : 6'b010000;
		dc_reg_dlltolock_pulse = 1'b0;
    end

	// dll counter logic
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
        else if (jc_count == 12)
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
           
// Phase comparator -----------------------------------------------------------
              
	// inputs
	assign pc_clk1_in = cg_clk1_out;
	assign pc_clk8_in = cg_clk8b_out;        // positive edge
    assign pc_dllcount_in = dc_dllcount_out; // for phase loop calculation
    assign pc_aload_in = aload_in;
           
	// outputs
	assign pc_upndn_out = pc_reg_upndn;
           
    // parameter used
	// sim_loop_intrinsic_delay, sim_loop_delay_increment
           
    // Model
    initial
    begin
        pc_reg_upndn = 1'b1;
        pc_delay = 0;
    end
              
    always @(posedge pc_clk8_in or posedge pc_aload_in)
    begin
        if (pc_aload_in === 1'b1)
            pc_reg_upndn <= 1'b1;
        else
            pc_delay = sim_loop_intrinsic_delay + sim_loop_delay_increment * pc_dllcount_in;
            if (pc_delay > input_period)
                pc_reg_upndn <= 1'b0;
            else
            pc_reg_upndn <= 1'b1;
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
               
endmodule

//------------------------------------------------------------------
//
// Module Name : ena_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for the gated clock generation.
//               Powers upto 1.
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixii_ena_reg (
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
        else if ((clk_in == 1'b1) & (clk_last_value == 1'b0) & (ena == 1'b1))
            q_tmp <= d_in;

        clk_last_value = clk_in;
    end

and (q, q_tmp, 'b1);

endmodule // ena_reg

//------------------------------------------------------------------
//
// Module Name : stratixii_clkctrl
//
// Description : StratixII CLKCTRL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixii_clkctrl (
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
   
parameter clock_type = "auto";
parameter lpm_type = "stratixii_clkctrl";

wire clkmux_out; // output of CLK mux
wire cereg_out; // output of ENA register 
   
wire inclk3_ipd;
wire inclk2_ipd;
wire inclk1_ipd;
wire inclk0_ipd;
wire clkselect1_ipd;
wire clkselect0_ipd;
wire ena_ipd;

tri1 devclrn;
tri1 devpor;
   
buf (inclk3_ipd, inclk[3]);
buf (inclk2_ipd, inclk[2]);
buf (inclk1_ipd, inclk[1]);
buf (inclk0_ipd, inclk[0]);
buf (clkselect1_ipd, clkselect[1]);
buf (clkselect0_ipd, clkselect[0]);
buf (ena_ipd, ena);
   
stratixii_mux41 clk_mux (.MO(clkmux_out),
               .IN0(inclk0_ipd),
               .IN1(inclk1_ipd),
               .IN2(inclk2_ipd),
               .IN3(inclk3_ipd),
               .S({clkselect1_ipd, clkselect0_ipd}));

stratixii_ena_reg extena0_reg(
                    .clk(!clkmux_out),
                    .ena(1'b1),
                    .d(ena_ipd),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg_out)
                   );
   
and (outclk, cereg_out, clkmux_out);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_tx_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for registering the enable inputs.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixii_lvds_tx_reg (q,
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

endmodule // stratixii_lvds_tx_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_tx_parallel_register
//
// Description : Register for the 10 data input channels of the StratixII
//               LVDS Tx
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_tx_parallel_register (clk,
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

endmodule //stratixii_lvds_tx_parallel_register

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_tx_out_block
//
// Description : Negative edge triggered register on the Tx output.
//               Also, optionally generates an identical/inverted output clock
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_tx_out_block (clk,
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

endmodule //stratixii_lvds_tx_out_block

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_transmitter
//
// Description : Timing simulation model for the StratixII LVDS Tx WYSIWYG.
//               It instantiates the following sub-modules :
//               1) primitive DFFE
//               2) StratixII_lvds_tx_parallel_register and
//               3) StratixII_lvds_tx_out_block
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_transmitter (clk0,
                                   enable0,
                                   datain,
                                   serialdatain,
                                   postdpaserialdatain,
                                   dataout,
                                   serialfdbkout,
                                   devclrn,
                                   devpor
                                  );

    parameter bypass_serializer              = "false";
    parameter invert_clock                   = "false";
    parameter use_falling_clock_edge         = "false";
    parameter use_serial_data_input          = "false";
    parameter use_post_dpa_serial_data_input = "false";
    parameter preemphasis_setting            = 0;
    parameter vod_setting                    = 0;
    parameter differential_drive             = 0;
    parameter lpm_type                       = "stratixii_lvds_transmitter";

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

    // TIMING PATHS
    specify
        if (serial_din_mode == 1'b1)
            (serialdatain => dataout) = (0, 0);

        if (postdpa_serial_din_mode == 1'b1)
            (postdpaserialdatain => dataout) = (0, 0);

    endspecify

    initial
    begin
        i = 0;
        clk0_last_value = 0;
        shift_data = 'b0;
    end

    stratixii_lvds_tx_reg txload0_reg (.d(enable0),
                             .clrn(1'b1),
                             .prn(1'b1),
                             .ena(1'b1),
                             .clk(clk0_in),
                             .q(txload0)
                            );

    stratixii_lvds_tx_out_block output_module (.clk(clk0_in),
                                               .datain(shift_out),
                                               .dataout(dataout_tmp),
                                               .devclrn(devclrn),
                                               .devpor(devpor)
                                              );
    defparam output_module.bypass_serializer      = bypass_serializer;
    defparam output_module.invert_clock           = invert_clock;
    defparam output_module.use_falling_clock_edge = use_falling_clock_edge;

    stratixii_lvds_tx_parallel_register input_reg (.clk(txload0),
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
                           dataout_tmp;

    and (dataout, dataout_wire, 1'b1);
    and (serialfdbkout, dataout_wire, 1'b1);

endmodule // stratixii_lvds_transmitter
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the StratixII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixii_m_cntr   ( clk,
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

    end

    and (cout, cout_tmp, 1'b1);

endmodule // stratixii_m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the StratixII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixii_n_cntr   ( clk,
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
                    $display("Warning : Invalid transition to 'X' detected on StratixII PLL input clk. This edge will be ignored.");
                    $display("Time: %0t  Instance: %m", $time);
                end
                else if (clk === 1'b1 && first_rising_edge)
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

    end

    assign cout = tmp_cout;

endmodule // stratixii_n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the C0, C1, C2, C3, C4 and
//               C5 output counters of the StratixII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module stratixii_scale_cntr   ( clk,
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

endmodule // stratixii_scale_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixii_pll_reg  ( q,
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

endmodule // stratixii_pll_reg

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_pll
//
// Description : Timing simulation model for the StratixII PLL.
//               In the functional mode, it is also the model for the altpll
//               megafunction.
// 
// Limitations : Does not support Spread Spectrum and Bandwidth.
//
// Outputs     : Up to 6 output clocks, each defined by its own set of
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

module stratixii_pll (inclk,
                    fbin,
                    ena,
                    clkswitch,
                    areset,
                    pfdena,
                    scanclk,
                    scanread,
                    scanwrite,
                    scandata,
                    testin,
                    clk,
                    clkbad,
                    activeclock,
                    locked,
                    clkloss,
                    scandataout,
                    scandone,
                    enable0,
                    enable1,
                    testupout,
                    testdownout,
                    sclkout
                    );

    parameter operation_mode                       = "normal";
    parameter pll_type                             = "auto";
    parameter compensate_clock                     = "clk0";
    parameter feedback_source                      = "clk0";
    parameter qualify_conf_done                    = "off";

    parameter test_input_comp_delay_chain_bits     = 0;
    parameter test_feedback_comp_delay_chain_bits  = 0;

    parameter inclk0_input_frequency               = 10000;
    parameter inclk1_input_frequency               = 10000;

    parameter gate_lock_signal                     = "no";
    parameter gate_lock_counter                    = 1;
    parameter self_reset_on_gated_loss_lock        = "off";
    parameter valid_lock_multiplier                = 1;
    parameter invalid_lock_multiplier              = 5;

    parameter switch_over_type                     = "auto";
    parameter switch_over_on_lossclk               = "off";
    parameter switch_over_on_gated_lock            = "off";
    parameter switch_over_counter                  = 1;
    parameter enable_switch_over_counter           = "on";

    parameter bandwidth                            = 0;
    parameter bandwidth_type                       = "auto";
    parameter spread_frequency                     = 0;
    parameter common_rx_tx                         = "off";
    parameter use_dc_coupling                      = "false";

    parameter clk0_output_frequency                = 0;
    parameter clk0_multiply_by                     = 1;
    parameter clk0_divide_by                       = 1;
    parameter clk0_phase_shift                     = "0";
    parameter clk0_duty_cycle                      = 50;

    parameter clk1_output_frequency                = 0;
    parameter clk1_multiply_by                     = 1;
    parameter clk1_divide_by                       = 1;
    parameter clk1_phase_shift                     = "0";
    parameter clk1_duty_cycle                      = 50;

    parameter clk2_output_frequency                = 0;
    parameter clk2_multiply_by                     = 1;
    parameter clk2_divide_by                       = 1;
    parameter clk2_phase_shift                     = "0";
    parameter clk2_duty_cycle                      = 50;

    parameter clk3_output_frequency                = 0;
    parameter clk3_multiply_by                     = 1;
    parameter clk3_divide_by                       = 1;
    parameter clk3_phase_shift                     = "0";
    parameter clk3_duty_cycle                      = 50;

    parameter clk4_output_frequency                = 0;
    parameter clk4_multiply_by                     = 1;
    parameter clk4_divide_by                       = 1;
    parameter clk4_phase_shift                     = "0";
    parameter clk4_duty_cycle                      = 50;

    parameter clk5_output_frequency                = 0;
    parameter clk5_multiply_by                     = 1;
    parameter clk5_divide_by                       = 1;
    parameter clk5_phase_shift                     = "0";
    parameter clk5_duty_cycle                      = 50;

    parameter pfd_min                              = 0;
    parameter pfd_max                              = 0;
    parameter vco_min                              = 0;
    parameter vco_max                              = 0;
    parameter vco_center                           = 0;

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 0;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;

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

    parameter m_ph = 0;

    parameter clk0_counter = "c0";
    parameter clk1_counter = "c1";
    parameter clk2_counter = "c2";
    parameter clk3_counter = "c3";
    parameter clk4_counter = "c4";
    parameter clk5_counter = "c5";

    parameter c1_use_casc_in = "off";
    parameter c2_use_casc_in = "off";
    parameter c3_use_casc_in = "off";
    parameter c4_use_casc_in = "off";
    parameter c5_use_casc_in = "off";

    parameter m_test_source = 5;
    parameter c0_test_source = 5;
    parameter c1_test_source = 5;
    parameter c2_test_source = 5;
    parameter c3_test_source = 5;
    parameter c4_test_source = 5;
    parameter c5_test_source = 5;

    // LVDS mode parameters
    parameter enable0_counter = "c0";
    parameter enable1_counter = "c1";
    parameter sclkout0_phase_shift = "0";
    parameter sclkout1_phase_shift = "0";

    parameter vco_multiply_by = 0;
    parameter vco_divide_by = 0;
    parameter vco_post_scale = 1;

    parameter charge_pump_current = 52;
    parameter loop_filter_r = "1.0";
    parameter loop_filter_c = 16;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "functional";
    parameter lpm_type = "stratixii_pll";

// SIMULATION_ONLY_PARAMETERS_BEGIN

    parameter down_spread                          = "0.0";

    parameter sim_gate_lock_device_behavior        = "off";

    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;
    parameter family_name = "StratixII";

    parameter clk0_use_even_counter_mode = "off";
    parameter clk1_use_even_counter_mode = "off";
    parameter clk2_use_even_counter_mode = "off";
    parameter clk3_use_even_counter_mode = "off";
    parameter clk4_use_even_counter_mode = "off";
    parameter clk5_use_even_counter_mode = "off";

    parameter clk0_use_even_counter_value = "off";
    parameter clk1_use_even_counter_value = "off";
    parameter clk2_use_even_counter_value = "off";
    parameter clk3_use_even_counter_value = "off";
    parameter clk4_use_even_counter_value = "off";
    parameter clk5_use_even_counter_value = "off";

// SIMULATION_ONLY_PARAMETERS_END

    parameter scan_chain_mif_file = "";

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input scanclk;
    input scanread;
    input scanwrite;
    input scandata;
    input [3:0] testin;

    // OUTPUT PORTS
    output [5:0] clk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    output scandone;
    // lvds specific output ports
    output enable0;
    output enable1;
    output [1:0] sclkout;
    // test ports
    output testupout;
    output testdownout;

    // BUFFER INPUTS
    wire inclk0_ipd;
    wire inclk1_ipd;
    wire ena_ipd;
    wire fbin_ipd;
    wire clkswitch_ipd;
    wire areset_ipd;
    wire pfdena_ipd;
    wire scanclk_ipd;
    wire scanread_ipd;
    wire scanwrite_ipd;
    wire scandata_ipd;
    buf (inclk0_ipd, inclk[0]);
    buf (inclk1_ipd, inclk[1]);
    buf (ena_ipd, ena);
    buf (fbin_ipd, fbin);
    buf (clkswitch_ipd, clkswitch);
    buf (areset_ipd, areset);
    buf (pfdena_ipd, pfdena);
    buf (scanclk_ipd, scanclk);
    buf (scanread_ipd, scanread);
    buf (scanwrite_ipd, scanwrite);
    buf (scandata_ipd, scandata);

    // TIMING CHECKS
    specify
        $setuphold(posedge scanclk, scanread, 0, 0);
        $setuphold(posedge scanclk, scanwrite, 0, 0);
        $setuphold(posedge scanclk, scandata, 0, 0);
    endspecify

    // INTERNAL VARIABLES AND NETS
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
    integer c0_count;
    integer c0_initial_count;
    integer c1_count;
    integer c1_initial_count;
    integer loop_xplier;
    integer loop_initial;
    integer loop_ph;
    integer cycle_to_adjust;
    integer total_pull_back;
    integer pull_back_M;

    time    fbclk_time;
    time    first_fbclk_time;
    time    refclk_time;
    time    next_vco_sched_time;

    reg got_first_refclk;
    reg got_second_refclk;
    reg got_first_fbclk;
    reg refclk_last_value;
    reg fbclk_last_value;
    reg inclk_last_value;
    reg pll_is_locked;
    reg pll_about_to_lock;
    reg locked_tmp;
    reg c0_got_first_rising_edge;
    reg c1_got_first_rising_edge;
    reg vco_c0_last_value;
    reg vco_c1_last_value;
    reg areset_ipd_last_value;
    reg ena_ipd_last_value;
    reg pfdena_ipd_last_value;
    reg inclk_out_of_range;
    reg schedule_vco_last_value;

    reg gate_out;
    reg vco_val;

    reg [31:0] m_initial_val;
    reg [31:0] m_val[0:1];
    reg [31:0] n_val[0:1];
    reg [31:0] m_delay;
    reg [8*6:1] m_mode_val[0:1];
    reg [8*6:1] n_mode_val[0:1];

    reg [31:0] c_high_val[0:5];
    reg [31:0] c_low_val[0:5];
    reg [8*6:1] c_mode_val[0:5];
    reg [31:0] c_initial_val[0:5];
    integer c_ph_val[0:5];

    // temporary registers for reprogramming
    integer c_ph_val_tmp[0:5];
    reg [31:0] c_high_val_tmp[0:5];
    reg [31:0] c_low_val_tmp[0:5];
    reg [8*6:1] c_mode_val_tmp[0:5];

    // hold registers for reprogramming
    integer c_ph_val_hold[0:5];
    reg [31:0] c_high_val_hold[0:5];
    reg [31:0] c_low_val_hold[0:5];
    reg [8*6:1] c_mode_val_hold[0:5];

    // old values
    reg [31:0] m_val_old[0:1];
    reg [31:0] m_val_tmp[0:1];
    reg [31:0] n_val_old[0:1];
    reg [8*6:1] m_mode_val_old[0:1];
    reg [8*6:1] n_mode_val_old[0:1];
    reg [31:0] c_high_val_old[0:5];
    reg [31:0] c_low_val_old[0:5];
    reg [8*6:1] c_mode_val_old[0:5];
    integer c_ph_val_old[0:5];
    integer   m_ph_val_old;
    integer   m_ph_val_tmp;

    integer cp_curr_old;
    integer cp_curr_val;
    integer lfc_old;
    integer lfc_val;
    reg [9*8:1] lfr_val;
    reg [9*8:1] lfr_old;

    reg [31:0] m_hi;
    reg [31:0] m_lo;

    // ph tap orig values (POF)
    integer c_ph_val_orig[0:5];
    integer m_ph_val_orig;

    reg schedule_vco;
    reg stop_vco;
    reg inclk_n;

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
    reg  inclk_c0_from_vco;
    reg  inclk_c1_from_vco;
    reg  inclk_c2_from_vco;
    reg  inclk_c3_from_vco;
    reg  inclk_c4_from_vco;
    reg  inclk_c5_from_vco;
    reg  inclk_m_from_vco;
    reg inclk_sclkout0_from_vco;
    reg inclk_sclkout1_from_vco;

    wire inclk_m;
    wire [5:0] clk_tmp;

    wire ena_pll;
    wire n_cntr_inclk;
    reg sclkout0_tmp;
    reg sclkout1_tmp;

    reg vco_c0;
    reg vco_c1;

    wire [5:0] clk_out;
    wire sclkout0;
    wire sclkout1;

    wire c0_clk;
    wire c1_clk;
    wire c2_clk;
    wire c3_clk;
    wire c4_clk;
    wire c5_clk;

    reg first_schedule;

    wire enable0_tmp;
    wire enable1_tmp;
    wire enable_0;
    wire enable_1;
    reg c0_tmp;
    reg c1_tmp;

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    wire refclk;
    wire fbclk;
    
    wire pllena_reg;
    wire test_mode_inclk;

    // for external feedback mode

    reg [31:0] ext_fbk_cntr_high;
    reg [31:0] ext_fbk_cntr_low;
    reg [31:0] ext_fbk_cntr_modulus;
    reg [8*2:1] ext_fbk_cntr;
    reg [8*6:1] ext_fbk_cntr_mode;
    integer ext_fbk_cntr_ph;
    integer ext_fbk_cntr_initial;
    integer ext_fbk_cntr_index;

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
    reg active_clock;
    reg clkloss_tmp;
    reg got_curr_clk_falling_edge_after_clkswitch;

    integer clk0_count;
    integer clk1_count;
    integer switch_over_count;

    wire scandataout_tmp;
    reg scandone_tmp;
    reg scandone_tmp_last_value;
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
    reg scanread_reg;
    reg scanwrite_reg;
    reg scanwrite_enabled;
    reg scanwrite_last_value;
    reg [173:0] scan_data;
    reg [173:0] tmp_scan_data;
    reg c0_rising_edge_transfer_done;
    reg c1_rising_edge_transfer_done;
    reg c2_rising_edge_transfer_done;
    reg c3_rising_edge_transfer_done;
    reg c4_rising_edge_transfer_done;
    reg c5_rising_edge_transfer_done;
    reg scanread_setup_violation;
    integer index;
    integer scanclk_cycles;
    reg d_msg;

    integer num_output_cntrs;
    reg no_warn;

// LOCAL_PARAMETERS_BEGIN

    parameter GPP_SCAN_CHAIN = 174;
    parameter FAST_SCAN_CHAIN = 75;
    // primary clk is always inclk0
    parameter prim_clk = "inclk0";
    parameter GATE_LOCK_CYCLES = 7;

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
    integer   i_c_high[0:5];
    integer   i_c_low[0:5];
    integer   i_c_initial[0:5];
    integer   i_c_ph[0:5];
    reg       [8*6:1] i_c_mode[0:5];

    integer   i_vco_min;
    integer   i_vco_max;
    integer   i_vco_center;
    integer   i_pfd_min;
    integer   i_pfd_max;
    integer   i_m_ph;
    integer   m_ph_val;
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
    reg [9*8:1] loop_filter_r_arr[0:39];

    reg pll_in_test_mode;
    reg pll_is_in_reset;
    reg pll_is_disabled;

    // uppercase to lowercase parameter values
    reg [8*`WORD_LENGTH:1] l_operation_mode;
    reg [8*`WORD_LENGTH:1] l_pll_type;
    reg [8*`WORD_LENGTH:1] l_qualify_conf_done;
    reg [8*`WORD_LENGTH:1] l_compensate_clock;
    reg [8*`WORD_LENGTH:1] l_scan_chain;
    reg [8*`WORD_LENGTH:1] l_primary_clock;
    reg [8*`WORD_LENGTH:1] l_gate_lock_signal;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_lossclk;
    reg [8*`WORD_LENGTH:1] l_switch_over_type;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_gated_lock;
    reg [8*`WORD_LENGTH:1] l_enable_switch_over_counter;
    reg [8*`WORD_LENGTH:1] l_feedback_source;
    reg [8*`WORD_LENGTH:1] l_bandwidth_type;
    reg [8*`WORD_LENGTH:1] l_simulation_type;
    reg [8*`WORD_LENGTH:1] l_sim_gate_lock_device_behavior;
    reg [8*`WORD_LENGTH:1] l_enable0_counter;
    reg [8*`WORD_LENGTH:1] l_enable1_counter;

    integer current_clock;
    integer ena0_cntr;
    integer ena1_cntr;
    reg is_fast_pll;
    reg ic1_use_casc_in;
    reg ic2_use_casc_in;
    reg ic3_use_casc_in;
    reg ic4_use_casc_in;
    reg ic5_use_casc_in;
    reg op_mode;

    reg init;
    reg tap0_is_active;


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
    input C0, C0_mode, C1, C1_mode, C2, C2_mode, C3, C3_mode, C4, C4_mode, C5, C5_mode, refclk, m_mod;
    integer C0, C1, C2, C3, C4, C5;
    reg [8*6:1] C0_mode, C1_mode, C2_mode, C3_mode, C4_mode, C5_mode;
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

        if ((2 * refclk) > (refclk * max_modulus *2 / m_mod))
            slowest_clk = 2 * refclk;
        else
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
    integer counter_l, tmp_counter_low;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_h = tmp_counter_high + !mode;
        tmp_counter_low =  output_counter_value - counter_h;
        if (tmp_counter_low == 0)
            counter_l = 1;
        else counter_l = tmp_counter_low;

        counter_low = counter_l;    
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

    // this is for stratixii lvds only
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

        // convert string parameter values from uppercase to lowercase,
        // as expected in this model
        l_operation_mode             = alpha_tolower(operation_mode);
        l_pll_type                   = alpha_tolower(pll_type);
        l_qualify_conf_done          = alpha_tolower(qualify_conf_done);
        l_compensate_clock           = alpha_tolower(compensate_clock);
        l_primary_clock              = alpha_tolower(prim_clk);
        l_gate_lock_signal           = alpha_tolower(gate_lock_signal);
        l_switch_over_on_lossclk     = alpha_tolower(switch_over_on_lossclk);
        l_switch_over_on_gated_lock  = alpha_tolower(switch_over_on_gated_lock);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_switch_over_type           = alpha_tolower(switch_over_type);
        l_feedback_source            = alpha_tolower(feedback_source);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);
        l_sim_gate_lock_device_behavior     = alpha_tolower(sim_gate_lock_device_behavior);
        l_enable0_counter            = alpha_tolower(enable0_counter);
        l_enable1_counter            = alpha_tolower(enable1_counter);

        if (l_enable0_counter == "c0")
            ena0_cntr = 0;
        else
            ena0_cntr = 1;
        if (l_enable1_counter == "c0")
            ena1_cntr = 0;
        else
            ena1_cntr = 1;

        // initialize charge_pump_current, and loop_filter tables
        loop_filter_c_arr[0] = 57;
        loop_filter_c_arr[1] = 16;
        loop_filter_c_arr[2] = 36;
        loop_filter_c_arr[3] = 5;
        
        fpll_loop_filter_c_arr[0] = 18;
        fpll_loop_filter_c_arr[1] = 13;
        fpll_loop_filter_c_arr[2] = 8;
        fpll_loop_filter_c_arr[3] = 2;
        
        charge_pump_curr_arr[0] = 6;
        charge_pump_curr_arr[1] = 12;
        charge_pump_curr_arr[2] = 30;
        charge_pump_curr_arr[3] = 36;
        charge_pump_curr_arr[4] = 52;
        charge_pump_curr_arr[5] = 57;
        charge_pump_curr_arr[6] = 72;
        charge_pump_curr_arr[7] = 77;
        charge_pump_curr_arr[8] = 92;
        charge_pump_curr_arr[9] = 96;
        charge_pump_curr_arr[10] = 110;
        charge_pump_curr_arr[11] = 114;
        charge_pump_curr_arr[12] = 127;
        charge_pump_curr_arr[13] = 131;
        charge_pump_curr_arr[14] = 144;
        charge_pump_curr_arr[15] = 148;

        loop_filter_r_arr[0] = " 1.000000";
        loop_filter_r_arr[1] = " 1.500000";
        loop_filter_r_arr[2] = " 2.000000";
        loop_filter_r_arr[3] = " 2.500000";
        loop_filter_r_arr[4] = " 3.000000";
        loop_filter_r_arr[5] = " 3.500000";
        loop_filter_r_arr[6] = " 4.000000";
        loop_filter_r_arr[7] = " 4.500000";
        loop_filter_r_arr[8] = " 5.000000";
        loop_filter_r_arr[9] = " 5.500000";
        loop_filter_r_arr[10] = " 6.000000";
        loop_filter_r_arr[11] = " 6.500000";
        loop_filter_r_arr[12] = " 7.000000";
        loop_filter_r_arr[13] = " 7.500000";
        loop_filter_r_arr[14] = " 8.000000";
        loop_filter_r_arr[15] = " 8.500000";
        loop_filter_r_arr[16] = " 9.000000";
        loop_filter_r_arr[17] = " 9.500000";
        loop_filter_r_arr[18] = "10.000000";
        loop_filter_r_arr[19] = "10.500000";
        loop_filter_r_arr[20] = "11.000000";
        loop_filter_r_arr[21] = "11.500000";
        loop_filter_r_arr[22] = "12.000000";
        loop_filter_r_arr[23] = "12.500000";
        loop_filter_r_arr[24] = "13.000000";
        loop_filter_r_arr[25] = "13.500000";
        loop_filter_r_arr[26] = "14.000000";
        loop_filter_r_arr[27] = "14.500000";
        loop_filter_r_arr[28] = "15.000000";
        loop_filter_r_arr[29] = "15.500000";
        loop_filter_r_arr[30] = "16.000000";
        loop_filter_r_arr[31] = "16.500000";
        loop_filter_r_arr[32] = "17.000000";
        loop_filter_r_arr[33] = "17.500000";
        loop_filter_r_arr[34] = "18.000000";
        loop_filter_r_arr[35] = "18.500000";
        loop_filter_r_arr[36] = "19.000000";
        loop_filter_r_arr[37] = "19.500000";
        loop_filter_r_arr[38] = "20.000000";
        loop_filter_r_arr[39] = "20.500000";

        if (m == 0)
        begin
            i_clk5_counter    = "c5" ;
            i_clk4_counter    = "c4" ;
            i_clk3_counter    = "c3" ;
            i_clk2_counter    = "c2" ;
            i_clk1_counter    = "c1" ;
            i_clk0_counter    = "c0" ;
        end
        else begin
            i_clk5_counter    = alpha_tolower(clk5_counter);
            i_clk4_counter    = alpha_tolower(clk4_counter);
            i_clk3_counter    = alpha_tolower(clk3_counter);
            i_clk2_counter    = alpha_tolower(clk2_counter);
            i_clk1_counter    = alpha_tolower(clk1_counter);
            i_clk0_counter    = alpha_tolower(clk0_counter);
        end

        // VCO feedback loop settings for external feedback mode
        // first find which counter is used for feedback
        if (l_operation_mode == "external_feedback")
        begin
            op_mode = 1;
            if (l_feedback_source == "clk0")
                ext_fbk_cntr = i_clk0_counter;
            else if (l_feedback_source == "clk1")
                ext_fbk_cntr = i_clk1_counter;
            else if (l_feedback_source == "clk2")
                ext_fbk_cntr = i_clk2_counter;
            else if (l_feedback_source == "clk3")
                ext_fbk_cntr = i_clk3_counter;
            else if (l_feedback_source == "clk4")
                ext_fbk_cntr = i_clk4_counter;
            else if (l_feedback_source == "clk5")
                ext_fbk_cntr = i_clk5_counter;
            else ext_fbk_cntr = "c0";

            if (ext_fbk_cntr == "c0")
                ext_fbk_cntr_index = 0;
            else if (ext_fbk_cntr == "c1")
                ext_fbk_cntr_index = 1;
            else if (ext_fbk_cntr == "c2")
                ext_fbk_cntr_index = 2;
            else if (ext_fbk_cntr == "c3")
                ext_fbk_cntr_index = 3;
            else if (ext_fbk_cntr == "c4")
                ext_fbk_cntr_index = 4;
            else if (ext_fbk_cntr == "c5")
                ext_fbk_cntr_index = 5;
        end
        else
        begin
            op_mode = 0;
            ext_fbk_cntr_index = 0;
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

            // convert user parameters to advanced
            if (((l_pll_type == "fast") || (l_pll_type == "lvds")) && (vco_multiply_by != 0) && (vco_divide_by != 0))
            begin
                i_n = vco_divide_by;
                i_m = vco_multiply_by;
            end
            else begin
                i_n = 1;
                i_m = lcm  (i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,
                            i_clk4_mult_by, i_clk5_mult_by,
                            1, 1, 1, 1, inclk0_input_frequency);
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

            max_neg_abs = maxnegabs   ( i_clk0_phase_shift,
                                        i_clk1_phase_shift,
                                        i_clk2_phase_shift,
                                        str2int(clk3_phase_shift),
                                        str2int(clk4_phase_shift),
                                        str2int(clk5_phase_shift),
                                        0, 0, 0, 0);

            i_c_initial[0] = counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[1] = counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[2] = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_initial[3] = counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[4] = counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[5] = counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs)), i_m, i_n);

            i_c_mode[0] = counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
            i_c_mode[1] = counter_mode(clk1_duty_cycle,output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
            i_c_mode[2] = counter_mode(clk2_duty_cycle,output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            i_c_mode[3] = counter_mode(clk3_duty_cycle,output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
            i_c_mode[4] = counter_mode(clk4_duty_cycle,output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
            i_c_mode[5] = counter_mode(clk5_duty_cycle,output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));

            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            
            i_c_ph[0] = counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[1] = counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[2] = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_c_ph[3] = counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[4] = counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[5] = counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs)), i_m, i_n);

            // in external feedback mode, need to adjust M value to take
            // into consideration the external feedback counter value
            if (l_operation_mode == "external_feedback")
            begin
                // if there is a negative phase shift, m_initial can only be 1
                if (max_neg_abs > 0)
                    i_m_initial = 1;

                if (i_c_mode[ext_fbk_cntr_index] == "bypass")
                    output_count = 1;
                else
                    output_count = i_c_high[ext_fbk_cntr_index] + i_c_low[ext_fbk_cntr_index];

                new_divisor = gcd(i_m, output_count);
                i_m = i_m / new_divisor;
                i_n = output_count / new_divisor;
            end

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
            i_c_low[0]  = c0_low;
            i_c_low[1]  = c1_low;
            i_c_low[2]  = c2_low;
            i_c_low[3]  = c3_low;
            i_c_low[4]  = c4_low;
            i_c_low[5]  = c5_low;
            i_c_initial[0] = c0_initial;
            i_c_initial[1] = c1_initial;
            i_c_initial[2] = c2_initial;
            i_c_initial[3] = c3_initial;
            i_c_initial[4] = c4_initial;
            i_c_initial[5] = c5_initial;
            i_c_mode[0] = translate_string(alpha_tolower(c0_mode));
            i_c_mode[1] = translate_string(alpha_tolower(c1_mode));
            i_c_mode[2] = translate_string(alpha_tolower(c2_mode));
            i_c_mode[3] = translate_string(alpha_tolower(c3_mode));
            i_c_mode[4] = translate_string(alpha_tolower(c4_mode));
            i_c_mode[5] = translate_string(alpha_tolower(c5_mode));
            i_c_ph[0]  = c0_ph;
            i_c_ph[1]  = c1_ph;
            i_c_ph[2]  = c2_ph;
            i_c_ph[3]  = c3_ph;
            i_c_ph[4]  = c4_ph;
            i_c_ph[5]  = c5_ph;
            i_m_ph   = m_ph;        // default
            i_m_initial = m_initial;

        end // user to advanced conversion

        refclk_period = inclk0_input_frequency * i_n;

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
        c0_got_first_rising_edge = 0;
        c1_got_first_rising_edge = 0;
        vco_c0_last_value = 0;
        c0_count = 2;
        c0_initial_count = 1;
        c1_count = 2;
        c1_initial_count = 1;
        c0_tmp = 0;
        c1_tmp = 0;
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
        vco_c0 = 0;
        vco_c1 = 0;
        total_pull_back = 0;
        pull_back_M = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;
        ena_ipd_last_value = 0;
        inclk_out_of_range = 0;
        scandone_tmp = 0;
        schedule_vco_last_value = 0;

        // set initial values for counter parameters
        m_initial_val = i_m_initial;
        m_val[0] = i_m;
        n_val[0] = i_n;
        m_ph_val = i_m_ph;
        m_ph_val_orig = i_m_ph;
        m_ph_val_tmp = i_m_ph;
        m_val_tmp[0] = i_m;

        m_val[1] = m2;
        n_val[1] = n2;

        if (m_val[0] == 1)
            m_mode_val[0] = "bypass";
        else m_mode_val[0] = "";
        if (m_val[1] == 1)
            m_mode_val[1] = "bypass";
        if (n_val[0] == 1)
            n_mode_val[0] = "bypass";
        if (n_val[1] == 1)
            n_mode_val[1] = "bypass";

        for (i = 0; i < 6; i=i+1)
        begin
            c_high_val[i] = i_c_high[i];
            c_low_val[i] = i_c_low[i];
            c_initial_val[i] = i_c_initial[i];
            c_mode_val[i] = i_c_mode[i];
            c_ph_val[i] = i_c_ph[i];
            c_high_val_tmp[i] = i_c_high[i];
            c_low_val_tmp[i] = i_c_low[i];
            if (c_mode_val[i] == "bypass")
            begin
                if (l_pll_type == "fast" || l_pll_type == "lvds")
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
        if (l_primary_clock == "inclk0")
            current_clock = 0;
        else current_clock = 1;

        active_clock = 0;   // primary_clk is always inclk0
        if (l_pll_type == "fast")
            l_switch_over_type = "manual";

        if (l_switch_over_type == "manual" && clkswitch_ipd === 1'b1)
        begin
            current_clock = 1;
            active_clock = 1;
        end
        clkloss_tmp = 0;
        got_curr_clk_falling_edge_after_clkswitch = 0;
        clk0_count = 0;
        clk1_count = 0;
        switch_over_count = 0;

        // initialize reconfiguration variables
        // quiet_time
        quiet_time = slowest_clk  ( c_high_val[0]+c_low_val[0], c_mode_val[0],
                                    c_high_val[1]+c_low_val[1], c_mode_val[1],
                                    c_high_val[2]+c_low_val[2], c_mode_val[2],
                                    c_high_val[3]+c_low_val[3], c_mode_val[3],
                                    c_high_val[4]+c_low_val[4], c_mode_val[4],
                                    c_high_val[5]+c_low_val[5], c_mode_val[5],
                                    refclk_period, m_val[0]);
        reconfig_err = 0;
        error = 0;
        scanread_active_edge = 0;
        if ((l_pll_type == "fast") || (l_pll_type == "lvds"))
        begin
            scan_chain_length = FAST_SCAN_CHAIN;
            num_output_cntrs = 4;
        end
        else
        begin
            scan_chain_length = GPP_SCAN_CHAIN;
            num_output_cntrs = 6;
        end
        scanread_reg = 0;
        scanwrite_reg = 0;
        scanwrite_enabled = 0;
        c0_rising_edge_transfer_done = 0;
        c1_rising_edge_transfer_done = 0;
        c2_rising_edge_transfer_done = 0;
        c3_rising_edge_transfer_done = 0;
        c4_rising_edge_transfer_done = 0;
        c5_rising_edge_transfer_done = 0;
        got_first_scanclk = 0;
        got_first_gated_scanclk = 0;
        gated_scanclk = 1;
        scanread_setup_violation = 0;
        index = 0;

        // initialize the scan_chain contents
        // CP/LF  bits
        scan_data[11:0] = 12'b0;
        for (i = 0; i <= 3; i = i + 1)
        begin
            if ((l_pll_type == "fast") || (l_pll_type == "lvds"))
            begin
                if (fpll_loop_filter_c_arr[i] == loop_filter_c)
                    scan_data[11:10] = i;
            end
            else begin
                if (loop_filter_c_arr[i] == loop_filter_c)
                    scan_data[11:10] = i;
            end
        end
        for (i = 0; i <= 15; i = i + 1)
        begin
            if (charge_pump_curr_arr[i] == charge_pump_current)
                scan_data[3:0] = i;
        end
        for (i = 0; i <= 39; i = i + 1)
        begin
            if (loop_filter_r_arr[i] == loop_filter_r)
            begin
                if ((i >= 16) && (i <= 23))
                    scan_data[9:4] = i+8;
                else if ((i >= 24) && (i <= 31))
                    scan_data[9:4] = i+16;
                else if (i >= 32)
                    scan_data[9:4] = i+24;
                else
                    scan_data[9:4] = i;
            end
        end

        if (l_pll_type == "fast" || l_pll_type == "lvds")
        begin
            scan_data[21:12] = 10'b0; // M, C3-C0 ph
            // C0-C3 high
            scan_data[25:22] = c_high_val[0];
            scan_data[35:32] = c_high_val[1];
            scan_data[45:42] = c_high_val[2];
            scan_data[55:52] = c_high_val[3];
            // C0-C3 low
            scan_data[30:27] = c_low_val[0];
            scan_data[40:37] = c_low_val[1];
            scan_data[50:47] = c_low_val[2];
            scan_data[60:57] = c_low_val[3];
            // C0-C3 mode
            for (i = 0; i < 4; i = i + 1)
            begin
                if (c_mode_val[i] == "   off" || c_mode_val[i] == "bypass")
                begin
                    scan_data[26 + (10*i)] = 1;
                    if (c_mode_val[i] == "   off")
                        scan_data[31 + (10*i)] = 1;
                    else
                        scan_data[31 + (10*i)] = 0;
                end
                else begin
                    scan_data[26 + (10*i)] = 0;
                    if (c_mode_val[i] == "   odd")
                        scan_data[31 + (10*i)] = 1;
                    else
                        scan_data[31 + (10*i)] = 0;
                end
            end
            // M
            if (m_mode_val[0] == "bypass")
            begin
                scan_data[66] = 1;
                scan_data[71] = 0;
                scan_data[65:62] = 4'b0;
                scan_data[70:67] = 4'b0;
            end
            else begin
                scan_data[66] = 0;       // set BYPASS bit to 0
                scan_data[70:67] = m_val[0]/2;   // set M low
                if (m_val[0] % 2 == 0)
                begin
                    // M is an even no. : set M high = low,
                    // set odd/even bit to 0
                    scan_data[65:62] = scan_data[70:67];
                    scan_data[71] = 0;
                end
                else begin // M is odd : M high = low + 1
                    scan_data[65:62] = (m_val[0]/2) + 1;
                    scan_data[71] = 1;
                end
            end
            // N
            scan_data[73:72] = n_val[0];
            if (n_mode_val[0] == "bypass")
            begin
                scan_data[74] = 1;
                scan_data[73:72] = 2'b0;
            end
        end
        else begin             // PLL type is enhanced/auto
            scan_data[25:12] = 14'b0;

            // C5-C0 high
            scan_data[33:26] = c_high_val[5];
            scan_data[51:44] = c_high_val[4];
            scan_data[69:62] = c_high_val[3];
            scan_data[87:80] = c_high_val[2];
            scan_data[105:98] = c_high_val[1];
            scan_data[123:116] = c_high_val[0];
            // C5-C0 low
            scan_data[42:35] = c_low_val[5];
            scan_data[60:53] = c_low_val[4];
            scan_data[78:71] = c_low_val[3];
            scan_data[96:89] = c_low_val[2];
            scan_data[114:107] = c_low_val[1];
            scan_data[132:125] = c_low_val[0];

            for (i = 5; i >= 0; i = i - 1)
            begin
                if (c_mode_val[i] == "   off" || c_mode_val[i] == "bypass")
                begin
                    scan_data[124 - (18*i)] = 1;
                    if (c_mode_val[i] == "   off")
                        scan_data[133 - (18*i)] = 1;
                    else
                        scan_data[133 - (18*i)] = 0;
                end
                else begin
                    scan_data[124 - (18*i)] = 0;
                    if (c_mode_val[i] == "   odd")
                        scan_data[133 - (18*i)] = 1;
                    else
                        scan_data[133 - (18*i)] = 0;
                end
            end

            scan_data[142:134] = m_val[0];
            scan_data[143] = 0;
            scan_data[152:144] = m_val[1];
            scan_data[153] = 0;
            if (m_mode_val[0] == "bypass")
            begin
                scan_data[143] = 1;
                scan_data[142:134] = 9'b0;
            end
            if (m_mode_val[1] == "bypass")
            begin
                scan_data[153] = 1;
                scan_data[152:144] = 9'b0;
            end

            scan_data[162:154] = n_val[0];
            scan_data[172:164] = n_val[1];
            if (n_mode_val[0] == "bypass")
            begin
                scan_data[163] = 1;
                scan_data[162:154] = 9'b0;
            end
            if (n_mode_val[1] == "bypass")
            begin
                scan_data[173] = 1;
                scan_data[172:164] = 9'b0;
            end
        end

        // now save this counter's parameters
        ext_fbk_cntr_high = c_high_val[ext_fbk_cntr_index];
        ext_fbk_cntr_low = c_low_val[ext_fbk_cntr_index];
        ext_fbk_cntr_ph = c_ph_val[ext_fbk_cntr_index];
        ext_fbk_cntr_initial = c_initial_val[ext_fbk_cntr_index];
        ext_fbk_cntr_mode = c_mode_val[ext_fbk_cntr_index];

        if (ext_fbk_cntr_mode == "bypass")
            ext_fbk_cntr_modulus = 1;
        else
            ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;

        l_index = 1;
        stop_vco = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;
        locked_tmp = 0;
        pll_is_locked = 0;
        pll_about_to_lock = 0;
        no_warn = 1'b0;

        // check if pll is in test mode
        if (m_test_source != 5 || c0_test_source != 5 || c1_test_source != 5 || c2_test_source != 5 || c3_test_source != 5 || c4_test_source != 5 || c5_test_source != 5)
            pll_in_test_mode = 1'b1;
        else
            pll_in_test_mode = 1'b0;


        pll_is_in_reset = 0;
        pll_is_disabled = 0;
        if (l_pll_type == "fast" || l_pll_type == "lvds")
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

        tap0_is_active = 1;
        next_vco_sched_time = 0;
    end

    always @(clkswitch_ipd)
    begin
        if (clkswitch_ipd === 1'b1 && l_switch_over_type == "auto")
            external_switch = 1;
        else if (l_switch_over_type == "manual")
        begin
            if (clkswitch_ipd === 1'b1)
            begin
                current_clock = 1;
                active_clock = 1;
                inclk_n = inclk1_ipd;
            end
            else if (clkswitch_ipd === 1'b0)
            begin
                current_clock = 0;
                active_clock = 0;
                inclk_n = inclk0_ipd;
            end
        end
    end

    always @(inclk0_ipd or inclk1_ipd)
    begin
        // save the inclk event value
        if (inclk0_ipd !== inclk0_last_value)
        begin
            if (current_clock != 0)
                other_clock_value = inclk0_ipd;
        end
        if (inclk1_ipd !== inclk1_last_value)
        begin
            if (current_clock != 1)
                other_clock_value = inclk1_ipd;
        end

        // check if either input clk is bad
        if (inclk0_ipd === 1'b1 && inclk0_ipd !== inclk0_last_value)
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
        if (inclk1_ipd === 1'b1 && inclk1_ipd !== inclk1_last_value)
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
        if ((inclk0_ipd !== inclk0_last_value) && current_clock == 0)
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
        if ((inclk1_ipd !== inclk1_last_value) && current_clock == 1)
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

        // actual switching -- automatic switch
        if ((other_clock_value == 1'b1) && (other_clock_value != other_clock_last_value) && (l_switch_over_on_lossclk == "on") && l_enable_switch_over_counter == "on" && primary_clk_is_bad)
            switch_over_count = switch_over_count + 1;

        if ((other_clock_value == 1'b0) && (other_clock_value != other_clock_last_value))
        begin
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (l_switch_over_on_lossclk == "on" && primary_clk_is_bad && l_pll_type !== "fast" && l_pll_type !== "lvds" && (clkswitch_ipd !== 1'b1) && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
            begin
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
        end

        if (l_switch_over_on_lossclk == "on" && (clkswitch_ipd != 1'b1))
        begin
            if (primary_clk_is_bad)
                clkloss_tmp = 1;
            else
                clkloss_tmp = 0;
        end
        else clkloss_tmp = clkswitch_ipd;

        inclk0_last_value = inclk0_ipd;
        inclk1_last_value = inclk1_ipd;
        other_clock_last_value = other_clock_value;

    end

    and (clkbad[0], clk0_is_bad, 1'b1);
    and (clkbad[1], clk1_is_bad, 1'b1);
    and (activeclock, active_clock, 1'b1);
    and (clkloss, clkloss_tmp, 1'b1);

    stratixii_pll_reg ena_reg ( .clk(!inclk_n),
                                .ena(1'b1),
                                .d(ena_ipd),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .q(pllena_reg));

    and (test_mode_inclk, inclk_n, pllena_reg);
    assign n_cntr_inclk = (pll_in_test_mode === 1'b1) ? test_mode_inclk : inclk_n;
    assign ena_pll = (pll_in_test_mode === 1'b1) ? pllena_reg : ena_ipd;

    assign inclk_m = (m_test_source == 0) ? n_cntr_inclk : op_mode == 1 ? (l_feedback_source == "clk0" ? clk_tmp[0] :
                        l_feedback_source == "clk1" ? clk_tmp[1] :
                        l_feedback_source == "clk2" ? clk_tmp[2] :
                        l_feedback_source == "clk3" ? clk_tmp[3] :
                        l_feedback_source == "clk4" ? clk_tmp[4] :
                        l_feedback_source == "clk5" ? clk_tmp[5] : 1'b0) :
                        inclk_m_from_vco;


    stratixii_m_cntr m1 (.clk(inclk_m),
                        .reset(areset_ipd || (!ena_pll) || stop_vco),
                        .cout(fbclk),
                        .initial_value(m_initial_val),
                        .modulus(m_val[0]),
                        .time_delay(m_delay));

    stratixii_n_cntr n1 (.clk(n_cntr_inclk),
                        .reset(areset_ipd),
                        .cout(refclk),
                        .modulus(n_val[0]));


    always @(vco_out[0])
    begin
        // now schedule the other taps with the appropriate phase-shift
        for (k = 1; k <= 7; k=k+1)
        begin
            phase_shift[k] = (k*tmp_vco_per)/8;
            vco_out[k] <= #(phase_shift[k]) vco_out[0];
        end
    end

    always @(vco_out)
    begin
        // check which VCO TAP has event
        for (x = 0; x <= 7; x = x + 1)
        begin
            if (vco_out[x] !== vco_out_last_value[x])
            begin
                // TAP 'X' has event
                if ((x == 0) && (!pll_is_in_reset) && (!pll_is_disabled) && (stop_vco !== 1'b1))
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
        // check which VCO TAP has event
        for (x = 0; x <= 7; x = x + 1)
        begin
            if (vco_tap[x] !== vco_tap_last_value[x])
            begin
                if (c_ph_val[0] == x)
                begin
                    inclk_c0_from_vco <= vco_tap[x];
                    if (is_fast_pll == 1'b1)
                    begin
                    if (ena0_cntr == 0)
                        inclk_sclkout0_from_vco <= vco_tap[x];
                    if (ena1_cntr == 0)
                        inclk_sclkout1_from_vco <= vco_tap[x];
                    end
                end
                if (c_ph_val[1] == x)
                begin
                    inclk_c1_from_vco <= vco_tap[x];
                    if (is_fast_pll == 1'b1)
                    begin
                    if (ena0_cntr == 1)
                        inclk_sclkout0_from_vco <= vco_tap[x];
                    if (ena1_cntr == 1)
                        inclk_sclkout1_from_vco <= vco_tap[x];
                    end
                end
                if (c_ph_val[2] == x)
                    inclk_c2_from_vco <= vco_tap[x];
                if (c_ph_val[3] == x)
                    inclk_c3_from_vco <= vco_tap[x];
                if (c_ph_val[4] == x)
                    inclk_c4_from_vco <= vco_tap[x];
                if (c_ph_val[5] == x)
                    inclk_c5_from_vco <= vco_tap[x];
                if (m_ph_val == x)
                    inclk_m_from_vco <= vco_tap[x];
            end
        end
        if (scanwrite_enabled === 1'b1)
        begin
        for (x = 0; x <= 7; x = x + 1)
        begin
            if ((vco_tap[x] === 1'b0) && (vco_tap[x] !== vco_tap_last_value[x]))
            begin
                for (y = 0; y <= 5; y = y + 1)
                begin
                    if (c_ph_val[y] == x)
                        c_ph_val[y] <= c_ph_val_tmp[y];
                end
                if (m_ph_val == x)
                    m_ph_val <= m_ph_val_tmp;
            end
        end
        end

        // reset all counter phase tap values to POF programmed values
        if (areset_ipd === 1'b1)
        begin
            m_ph_val <= m_ph_val_orig;
            m_ph_val_tmp <= m_ph_val_orig;
            for (i=0; i<= 5; i=i+1)
            begin
                c_ph_val[i] <= c_ph_val_orig[i];
                c_ph_val_tmp[i] <= c_ph_val_orig[i];
            end
        end

        vco_tap_last_value = vco_tap;
    end

    always @(inclk_sclkout0_from_vco)
    begin
        sclkout0_tmp <= inclk_sclkout0_from_vco;
    end
    always @(inclk_sclkout1_from_vco)
    begin
        sclkout1_tmp <= inclk_sclkout1_from_vco;
    end

    assign inclk_c0 = (c0_test_source == 0) ? n_cntr_inclk : (c0_test_source == 1) ? refclk : inclk_c0_from_vco;

    stratixii_scale_cntr c0 (.clk(inclk_c0),
                            .reset(areset_ipd || (!ena_pll) || stop_vco),
                            .cout(c0_clk),
                            .high(c_high_val[0]),
                            .low(c_low_val[0]),
                            .initial_value(c_initial_val[0]),
                            .mode(c_mode_val[0]),
                            .ph_tap(c_ph_val[0]));

    always @(posedge c0_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val[0] <= c_high_val_tmp[0];
            c_mode_val[0] <= c_mode_val_tmp[0];
            c0_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c0_clk)
    begin
        if (c0_rising_edge_transfer_done)
        begin
            c_low_val[0] <= c_low_val_tmp[0];
        end
    end

    assign inclk_c1 = (c1_test_source == 0) ? n_cntr_inclk : (c1_test_source == 2) ? fbclk : (ic1_use_casc_in == 1) ? c0_clk : inclk_c1_from_vco;

    stratixii_scale_cntr c1 (.clk(inclk_c1),
                            .reset(areset_ipd || (!ena_pll) || stop_vco),
                            .cout(c1_clk),
                            .high(c_high_val[1]),
                            .low(c_low_val[1]),
                            .initial_value(c_initial_val[1]),
                            .mode(c_mode_val[1]),
                            .ph_tap(c_ph_val[1]));

    always @(posedge c1_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val[1] <= c_high_val_tmp[1];
            c_mode_val[1] <= c_mode_val_tmp[1];
            c1_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c1_clk)
    begin
        if (c1_rising_edge_transfer_done)
        begin
            c_low_val[1] <= c_low_val_tmp[1];
        end
    end

    assign inclk_c2 = (c2_test_source == 0) ? n_cntr_inclk : (ic2_use_casc_in == 1) ? c1_clk : inclk_c2_from_vco;

    stratixii_scale_cntr c2 (.clk(inclk_c2),
                            .reset(areset_ipd || (!ena_pll) || stop_vco),
                            .cout(c2_clk),
                            .high(c_high_val[2]),
                            .low(c_low_val[2]),
                            .initial_value(c_initial_val[2]),
                            .mode(c_mode_val[2]),
                            .ph_tap(c_ph_val[2]));

    always @(posedge c2_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val[2] <= c_high_val_tmp[2];
            c_mode_val[2] <= c_mode_val_tmp[2];
            c2_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c2_clk)
    begin
        if (c2_rising_edge_transfer_done)
        begin
            c_low_val[2] <= c_low_val_tmp[2];
        end
    end

    assign inclk_c3 = (c3_test_source == 0) ? n_cntr_inclk : (ic3_use_casc_in == 1) ? c2_clk : inclk_c3_from_vco;
    stratixii_scale_cntr c3 (.clk(inclk_c3),
                            .reset(areset_ipd || (!ena_pll) || stop_vco),
                            .cout(c3_clk),
                            .high(c_high_val[3]),
                            .low(c_low_val[3]),
                            .initial_value(c_initial_val[3]),
                            .mode(c_mode_val[3]),
                            .ph_tap(c_ph_val[3]));

    always @(posedge c3_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val[3] <= c_high_val_tmp[3];
            c_mode_val[3] <= c_mode_val_tmp[3];
            c3_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c3_clk)
    begin
        if (c3_rising_edge_transfer_done)
        begin
            c_low_val[3] <= c_low_val_tmp[3];
        end
    end

    assign inclk_c4 = ((c4_test_source == 0) ? n_cntr_inclk : (ic4_use_casc_in == 1) ? c3_clk : inclk_c4_from_vco);
    stratixii_scale_cntr c4 (.clk(inclk_c4),
                            .reset(areset_ipd || (!ena_pll) || stop_vco),
                            .cout(c4_clk),
                            .high(c_high_val[4]),
                            .low(c_low_val[4]),
                            .initial_value(c_initial_val[4]),
                            .mode(c_mode_val[4]),
                            .ph_tap(c_ph_val[4]));

    always @(posedge c4_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val[4] <= c_high_val_tmp[4];
            c_mode_val[4] <= c_mode_val_tmp[4];
            c4_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c4_clk)
    begin
        if (c4_rising_edge_transfer_done)
        begin
            c_low_val[4] <= c_low_val_tmp[4];
        end
    end

    assign inclk_c5 = ((c5_test_source == 0) ? n_cntr_inclk : (ic5_use_casc_in == 1) ? c4_clk : inclk_c5_from_vco);
    stratixii_scale_cntr c5 (.clk(inclk_c5),
                            .reset(areset_ipd || (!ena_pll) || stop_vco),
                            .cout(c5_clk),
                            .high(c_high_val[5]),
                            .low(c_low_val[5]),
                            .initial_value(c_initial_val[5]),
                            .mode(c_mode_val[5]),
                            .ph_tap(c_ph_val[5]));

    always @(posedge c5_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val[5] <= c_high_val_tmp[5];
            c_mode_val[5] <= c_mode_val_tmp[5];
            c5_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c5_clk)
    begin
        if (c5_rising_edge_transfer_done)
        begin
            c_low_val[5] <= c_low_val_tmp[5];
        end
    end

    always @(vco_tap[c_ph_val[0]] or posedge areset_ipd or negedge ena_pll or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_pll == 1'b0 || stop_vco == 1'b1)
        begin
            c0_count = 2;
            c0_initial_count = 1;
            c0_got_first_rising_edge = 0;

        end
        else begin
            if (c0_got_first_rising_edge == 1'b0)
            begin
                if (vco_tap[c_ph_val[0]] == 1'b1 && vco_tap[c_ph_val[0]] != vco_c0_last_value)
                begin
                    if (c0_initial_count == c_initial_val[0])
                        c0_got_first_rising_edge = 1;
                    else
                        c0_initial_count = c0_initial_count + 1;
                end
            end
            else if (vco_tap[c_ph_val[0]] != vco_c0_last_value)
            begin
                c0_count = c0_count + 1;
                if (c0_count == (c_high_val[0] + c_low_val[0]) * 2)
                    c0_count  = 1;
            end
            if (vco_tap[c_ph_val[0]] == 1'b0 && vco_tap[c_ph_val[0]] != vco_c0_last_value)
            begin
                if (c0_count == 1)
                begin
                    c0_tmp = 1;
                    c0_got_first_rising_edge = 0;
                end
                else c0_tmp = 0;
            end
        end
        vco_c0_last_value = vco_tap[c_ph_val[0]];
    end

    always @(vco_tap[c_ph_val[1]] or posedge areset_ipd or negedge ena_pll or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_pll == 1'b0 || stop_vco == 1'b1)
        begin
            c1_count = 2;
            c1_initial_count = 1;
            c1_got_first_rising_edge = 0;
        end
        else begin
            if (c1_got_first_rising_edge == 1'b0)
            begin
                if (vco_tap[c_ph_val[1]] == 1'b1 && vco_tap[c_ph_val[1]] != vco_c1_last_value)
                begin
                    if (c1_initial_count == c_initial_val[1])
                        c1_got_first_rising_edge = 1;
                    else
                        c1_initial_count = c1_initial_count + 1;
                end
            end
            else if (vco_tap[c_ph_val[1]] != vco_c1_last_value)
            begin
                c1_count = c1_count + 1;
                if (c1_count == (c_high_val[1] + c_low_val[1]) * 2)
                    c1_count  = 1;
            end
            if (vco_tap[c_ph_val[1]] == 1'b0 && vco_tap[c_ph_val[1]] != vco_c1_last_value)
            begin
                if (c1_count == 1)
                begin
                    c1_tmp = 1;
                    c1_got_first_rising_edge = 0;
                end
                else c1_tmp = 0;
            end
        end
        vco_c1_last_value = vco_tap[c_ph_val[1]];
    end

    assign enable0_tmp = (ena0_cntr == 0) ? c0_tmp : c1_tmp;
    assign enable1_tmp = (ena1_cntr == 0) ? c0_tmp : c1_tmp;

    always @ (inclk_n or ena_pll or areset_ipd)
    begin
        if (areset_ipd == 1'b1 || ena_pll == 1'b0)
        begin
            gate_count = 0;
            gate_out = 0; 
        end
        else if (inclk_n == 1'b1 && inclk_last_value != inclk_n)
        begin
            gate_count = gate_count + 1;
            if (l_sim_gate_lock_device_behavior == "on")
            begin
                if (gate_count == gate_lock_counter)
                    gate_out = 1;
            end
            else begin
                if (gate_count == GATE_LOCK_CYCLES)
                    gate_out = 1;
            end
        end
        inclk_last_value = inclk_n;
    end

    assign locked = (l_gate_lock_signal == "yes") ? gate_out && locked_tmp : locked_tmp;

    always @(posedge scanread_ipd)
    begin
        scanread_active_edge = $time;
    end

    always @ (scanclk_ipd)
    begin
        if (scanclk_ipd === 1'b0 && scanclk_last_value === 1'b1)
        begin
            // enable scanwrite on falling edge
            scanwrite_enabled <= scanwrite_reg;
        end
        if (scanread_reg === 1'b1)
            gated_scanclk <= scanclk_ipd && scanread_reg;
        else
            gated_scanclk <= 1'b1;
        if (scanclk_ipd === 1'b1 && scanclk_last_value === 1'b0)
        begin
            // register scanread and scanwrite
            scanread_reg <= scanread_ipd;
            scanwrite_reg <= scanwrite_ipd;

            if (got_first_scanclk)
                scanclk_period = $time - scanclk_last_rising_edge;
            else begin
                got_first_scanclk = 1;
            end
            // reset got_first_scanclk on falling edge of scanread_reg
            if (scanread_ipd == 1'b0 && scanread_reg == 1'b1)
            begin
                got_first_scanclk = 0;
                got_first_gated_scanclk = 0;
            end

            scanclk_last_rising_edge = $time;
        end
        scanclk_last_value = scanclk_ipd;
    end

    always @(posedge gated_scanclk)
    begin
        if ($time > 0)
        begin
        if (!got_first_gated_scanclk)
        begin
            got_first_gated_scanclk = 1;
//            if ($time - scanread_active_edge < scanclk_period)
//            begin
//                scanread_setup_violation = 1;
//                $display("Warning : SCANREAD must go high at least one cycle before SCANDATA is read in.");
//                $display ("Time: %0t  Instance: %m", $time);
//            end
        end
        for (j = scan_chain_length-1; j >= 1; j = j - 1)
        begin
            scan_data[j] = scan_data[j - 1];
        end
        scan_data[0] <= scandata_ipd;
        end
    end

    assign scandataout_tmp = (l_pll_type == "fast" || l_pll_type == "lvds") ? scan_data[FAST_SCAN_CHAIN-1] : scan_data[GPP_SCAN_CHAIN-1];

    always @(posedge scandone_tmp)
    begin
            if (reconfig_err == 1'b0)
            begin
                $display("NOTE : %s PLL Reprogramming completed with the following values (Values in parantheses are original values) : ", family_name);
                $display ("Time: %0t  Instance: %m", $time);

                $display("               N modulus =   %0d (%0d) ", n_val[0], n_val_old[0]);
                $display("               M modulus =   %0d (%0d) ", m_val[0], m_val_old[0]);
                $display("               M ph_tap =    %0d (%0d) ", m_ph_val, m_ph_val_old);
                if (ss > 0)
                begin
                    $display(" M2 modulus =   %0d (%0d) ", m_val[1], m_val_old[1]);
                    $display(" N2 modulus =   %0d (%0d) ", n_val[1], n_val_old[1]);
                end

                for (i = 0; i < num_output_cntrs; i=i+1)
                begin
                    $display("              C%0d  high = %0d (%0d),       C%0d  low = %0d (%0d),       C%0d  mode = %s (%s),       C%0d  phase tap = %0d (%0d)", i, c_high_val[i], c_high_val_old[i], i, c_low_val_tmp[i], c_low_val_old[i], i, c_mode_val[i], c_mode_val_old[i], i, c_ph_val[i], c_ph_val_old[i]);
                end

                // display Charge pump and loop filter values
                $display ("               Charge Pump Current (uA) =   %0d (%0d) ", cp_curr_val, cp_curr_old);
                $display ("               Loop Filter Capacitor (pF) =   %0d (%0d) ", lfc_val, lfc_old);
                $display ("               Loop Filter Resistor (Kohm) =   %s (%s) ", lfr_val, lfr_old);
            end
            else begin
                $display("Warning : Errors were encountered during PLL reprogramming. Please refer to error/warning messages above.");
                $display ("Time: %0t  Instance: %m", $time);
            end
    end

    always @(scanwrite_enabled)
    begin
        if (scanwrite_enabled === 1'b0 && scanwrite_last_value === 1'b1)
        begin
            // falling edge : deassert scandone
            scandone_tmp <= #(1.5*scanclk_period) 1'b0;
            // reset counter transfer flags
            c0_rising_edge_transfer_done = 0;
            c1_rising_edge_transfer_done = 0;
            c2_rising_edge_transfer_done = 0;
            c3_rising_edge_transfer_done = 0;
            c4_rising_edge_transfer_done = 0;
            c5_rising_edge_transfer_done = 0;
        end
        if (scanwrite_enabled === 1'b1 && scanwrite_last_value !== scanwrite_enabled)
        begin

            $display ("NOTE : %s PLL Reprogramming initiated ....", family_name);
            $display ("Time: %0t  Instance: %m", $time);

            error = 0;
            reconfig_err = 0;
            scanread_setup_violation = 0;

            // make temp. copy of scan_data for processing
            tmp_scan_data = scan_data;

            // save old values
            cp_curr_old = cp_curr_val;
            lfc_old = lfc_val;
            lfr_old = lfr_val;

            // CP
            // Bits 0-3 : all values are legal
            cp_curr_val = charge_pump_curr_arr[scan_data[3:0]];

            // LF Resistance : bits 4-9
            // values from 010000 - 010111, 100000 - 100111, 
            //             110000- 110111 are illegal
            if (((tmp_scan_data[9:4] >= 6'b010000) && (tmp_scan_data[9:4] <= 6'b010111)) || 
                ((tmp_scan_data[9:4] >= 6'b100000) && (tmp_scan_data[9:4] <= 6'b100111)) ||
                ((tmp_scan_data[9:4] >= 6'b110000) && (tmp_scan_data[9:4] <= 6'b110111)))
            begin
                $display ("Illegal bit settings for Loop Filter Resistance. Legal bit values range from 000000 to 001111, 011000 to 011111, 101000 to 101111 and 111000 to 111111. Reconfiguration may not work.");
                $display ("Time: %0t  Instance: %m", $time);
                reconfig_err = 1;
            end
            else begin
                i = scan_data[9:4];
                if (i >= 56 )
                    i = i - 24;
                else if ((i >= 40) && (i <= 47))
                    i = i - 16;
                else if ((i >= 24) && (i <= 31))
                    i = i - 8;
                lfr_val = loop_filter_r_arr[i];
            end

            // LF Capacitance : bits 10,11 : all values are legal
            if ((l_pll_type == "fast") || (l_pll_type == "lvds"))
                lfc_val = fpll_loop_filter_c_arr[scan_data[11:10]];
            else
                lfc_val = loop_filter_c_arr[scan_data[11:10]];

            // save old values for display info.
            for (i=0; i<=1; i=i+1)
            begin
                m_val_old[i] = m_val[i];
                n_val_old[i] = n_val[i];
                m_mode_val_old[i] = m_mode_val[i];
                n_mode_val_old[i] = n_mode_val[i];
            end
            m_ph_val_old = m_ph_val;
            for (i=0; i<=5; i=i+1)
            begin
                c_high_val_old[i] = c_high_val[i];
                c_low_val_old[i] = c_low_val[i];
                c_ph_val_old[i] = c_ph_val[i];
                c_mode_val_old[i] = c_mode_val[i];
            end

            // first the M counter phase : bit order same for fast and GPP
            if (scan_data[12] == 1'b0)
            begin
                // do nothing
            end
            else if (scan_data[12] === 1'b1 && scan_data[13] === 1'b1)
            begin
                m_ph_val_tmp = m_ph_val_tmp + 1;
                if (m_ph_val_tmp > 7)
                    m_ph_val_tmp = 0;
            end
            else if (scan_data[12] === 1'b1 && scan_data[13] === 1'b0)
            begin
                m_ph_val_tmp = m_ph_val_tmp - 1;
                if (m_ph_val_tmp < 0)
                    m_ph_val_tmp = 7;
            end
            else 
            begin
                $display ("Warning : Illegal bit settings for M counter phase tap. Reconfiguration may not work.");
                $display ("Time: %0t  Instance: %m", $time);
                reconfig_err = 1;
            end

            // read the fast PLL bits.
            if (l_pll_type == "fast" || l_pll_type == "lvds")
            begin
                // C3-C0 phase bits
                for (i = 3; i >= 0; i=i-1)
                begin
                    if (tmp_scan_data[14] == 1'b0)
                    begin
                        // do nothing
                    end
                    else if (tmp_scan_data[14] === 1'b1)
                    begin
                        if (tmp_scan_data[15] === 1'b1)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] + 1;
                            if (c_ph_val_tmp[i] > 7)
                                c_ph_val_tmp[i] = 0;
                        end
                        else if (tmp_scan_data[15] === 1'b0)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] - 1;
                            if (c_ph_val_tmp[i] < 0)
                                c_ph_val_tmp[i] = 7;
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 2;
                end
                // C0-C3 counter moduli
                tmp_scan_data = scan_data;
                for (i = 0; i < 4; i=i+1)
                begin
                    if (tmp_scan_data[26] == 1'b1)
                    begin
                        c_mode_val_tmp[i] = "bypass";
                        if (tmp_scan_data[31] === 1'b1)
                        begin
                            c_mode_val_tmp[i] = "   off";
                            $display("Warning : The specified bit settings will turn OFF the C%0d counter. It cannot be turned on unless the part is re-initialized.", i);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                    end
                    else if (tmp_scan_data[31] == 1'b1)
                        c_mode_val_tmp[i] = "   odd";
                    else
                        c_mode_val_tmp[i] = "  even";
                    if (tmp_scan_data[25:22] === 4'b0000)
                        c_high_val_tmp[i] = 5'b10000;
                    else
                        c_high_val_tmp[i] = {1'b0, tmp_scan_data[25:22]};
                    if (tmp_scan_data[30:27] === 4'b0000)
                        c_low_val_tmp[i] = 5'b10000;
                    else
                        c_low_val_tmp[i] = {1'b0, tmp_scan_data[30:27]};

                    tmp_scan_data = tmp_scan_data >> 10;
                end
                // M
                error = 0;
                // some temporary storage
                if (scan_data[65:62] == 4'b0000)
                    m_hi = 5'b10000;
                else
                    m_hi = {1'b0, scan_data[65:62]};

                if (scan_data[70:67] == 4'b0000)
                    m_lo = 5'b10000;
                else
                    m_lo = {1'b0, scan_data[70:67]};

                m_val_tmp[0] = m_hi + m_lo;
                if (scan_data[66] === 1'b1)
                begin
                    if (scan_data[71] === 1'b1)
                    begin
                        // this will turn off the M counter : error
                        reconfig_err = 1;
                        error = 1;
                        $display ("The specified bit settings will turn OFF the M counter. This is illegal. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                    else begin
                        // M counter is being bypassed
                        if (m_mode_val[0] !== "bypass")
                        begin
                            // Mode is switched : give warning
                            d_msg = display_msg(" M", 4);
                        end
                        m_val_tmp[0] = 32'b1;
                        m_mode_val[0] = "bypass";
                    end
                end
                else begin
                    if (m_mode_val[0] === "bypass")
                    begin
                        // Mode is switched : give warning
                        d_msg = display_msg(" M", 1);
                    end
                    m_mode_val[0] = "";
                    if (scan_data[71] === 1'b1)
                    begin
                        // odd : check for duty cycle, if not 50% -- error
                        if (m_hi - m_lo !== 1)
                        begin
                            reconfig_err = 1;
                            $display ("Warning : The M counter of the %s Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work", family_name);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                    end
                    else begin // even mode
                        if (m_hi !== m_lo)
                        begin
                            reconfig_err = 1;
                            $display ("Warning : The M counter of the %s Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work", family_name);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                    end
                end

                // N
                error = 0;
                n_val[0] = {1'b0, scan_data[73:72]};
                if (scan_data[74] !== 1'b1)
                begin
                    if (scan_data[73:72] == 2'b01)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        // Cntr value is illegal : give warning
                        d_msg = display_msg(" N", 2);
                    end
                    else if (scan_data[73:72] == 2'b00)
                        n_val[0] = 3'b100;
                    if (error == 1'b0)
                    begin
                        if (n_mode_val[0] === "bypass")
                        begin
                            // Mode is switched : give warning
                            d_msg = display_msg(" N", 1);
                        end
                        n_mode_val[0] = "";
                    end
                end
                else if (scan_data[74] == 1'b1)     // bypass
                begin
                    if (scan_data[72] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        // Cntr value is illegal : give warning
                        d_msg = display_msg(" N", 3);
                    end
                    else begin
                        if (n_mode_val[0] != "bypass")
                        begin
                            // Mode is switched : give warning
                            d_msg = display_msg(" N", 4);
                        end
                        n_val[0] = 2'b01;
                        n_mode_val[0] = "bypass";
                    end
                end
            end
            else begin      // pll type is auto or enhanced
                for (i = 0; i < 6; i=i+1)
                begin
                    if (tmp_scan_data[124] == 1'b1)
                    begin
                        c_mode_val_tmp[i] = "bypass";
                        if (tmp_scan_data[133] === 1'b1)
                        begin
                            c_mode_val_tmp[i] = "   off";
                            $display("Warning : The specified bit settings will turn OFF the C%0d counter. It cannot be turned on unless the part is re-initialized.", i);
                            $display ("Time: %0t  Instance: %m", $time);
                        end
                    end
                    else if (tmp_scan_data[133] == 1'b1)
                        c_mode_val_tmp[i] = "   odd";
                    else
                        c_mode_val_tmp[i] = "  even";
                    if (tmp_scan_data[123:116] === 8'b00000000)
                        c_high_val_tmp[i] = 9'b100000000;
                    else
                        c_high_val_tmp[i] = {1'b0, tmp_scan_data[123:116]};
                    if (tmp_scan_data[132:125] === 8'b00000000)
                        c_low_val_tmp[i] = 9'b100000000;
                    else
                        c_low_val_tmp[i] = {1'b0, tmp_scan_data[132:125]};

                    tmp_scan_data = tmp_scan_data << 18;
                end

                // the phase_taps
                tmp_scan_data = scan_data;
                for (i = 0; i < 6; i=i+1)
                begin
                    if (tmp_scan_data[14] == 1'b0)
                    begin
                        // do nothing
                    end
                    else if (tmp_scan_data[14] === 1'b1)
                    begin
                        if (tmp_scan_data[15] === 1'b1)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] + 1;
                            if (c_ph_val_tmp[i] > 7)
                                c_ph_val_tmp[i] = 0;
                        end
                        else if (tmp_scan_data[15] === 1'b0)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] - 1;
                            if (c_ph_val_tmp[i] < 0)
                                c_ph_val_tmp[i] = 7;
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 2;
                end
                ext_fbk_cntr_high = c_high_val[ext_fbk_cntr_index];
                ext_fbk_cntr_low = c_low_val[ext_fbk_cntr_index];
                ext_fbk_cntr_ph = c_ph_val[ext_fbk_cntr_index];
                ext_fbk_cntr_mode = c_mode_val[ext_fbk_cntr_index];

                // cntrs M/M2
                tmp_scan_data = scan_data;
                for (i=0; i<2; i=i+1)
                begin
                    if (i == 0 || (i == 1 && ss > 0))
                    begin
                        error = 0;
                        m_val_tmp[i] = {1'b0, tmp_scan_data[142:134]};
                        if (tmp_scan_data[143] !== 1'b1)
                        begin
                            if (tmp_scan_data[142:134] == 9'b000000001)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" M", 2);
                                else
                                    d_msg = display_msg("M2", 2);
                            end
                            else if (tmp_scan_data[142:134] == 9'b000000000)
                                m_val_tmp[i] = 10'b1000000000;
                            if (error == 1'b0)
                            begin
                                if (m_mode_val[i] === "bypass")
                                begin
                                    // Mode is switched : give warning
                                    if (i == 0)
                                        d_msg = display_msg(" M", 1);
                                    else
                                        d_msg = display_msg("M2", 1);
                                end
                                m_mode_val[i] = "";
                            end
                        end
                        else if (tmp_scan_data[143] == 1'b1)
                        begin
                            if (tmp_scan_data[134] !== 1'b0)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" M", 3);
                                else
                                    d_msg = display_msg("M2", 3);
                            end
                            else begin
                                if (m_mode_val[i] !== "bypass")
                                begin
                                    // Mode is switched: give warning
                                    if (i == 0)
                                        d_msg = display_msg(" M", 4);
                                    else
                                        d_msg = display_msg("M2", 4);
                                end
                                m_val_tmp[i] = 10'b0000000001;
                                m_mode_val[i] = "bypass";
                            end
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 10;
                end
                if (ss > 0)
                begin
                    if (m_mode_val[0] != m_mode_val[1])
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Incompatible modes for M/M2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end

                // cntrs N/N2
                tmp_scan_data = scan_data;
                for (i=0; i<2; i=i+1)
                begin
                    if (i == 0 || (i == 1 && ss > 0))
                    begin
                        error = 0;
                        n_val[i] = 0;
                        n_val[i] = {1'b0, tmp_scan_data[162:154]};
                        if (tmp_scan_data[163] !== 1'b1)
                        begin
                            if (tmp_scan_data[162:154] == 9'b000000001)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" N", 2);
                                else
                                    d_msg = display_msg("N2", 2);
                            end
                            else if (tmp_scan_data[162:154] == 9'b000000000)
                                n_val[i] = 10'b1000000000;
                            if (error == 1'b0)
                            begin
                                if (n_mode_val[i] === "bypass")
                                begin
                                    // Mode is switched : give warning
                                    if (i == 0)
                                        d_msg = display_msg(" N", 1);
                                    else
                                        d_msg = display_msg("N2", 1);
                                end
                                n_mode_val[i] = "";
                            end
                        end
                        else if (tmp_scan_data[163] == 1'b1)     // bypass
                        begin
                            if (tmp_scan_data[154] !== 1'b0)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" N", 3);
                                else
                                    d_msg = display_msg("N2", 3);
                            end
                            else begin
                                if (n_mode_val[i] != "bypass")
                                begin
                                    // Mode is switched : give warning
                                    if (i == 0)
                                        d_msg = display_msg(" N", 4);
                                    else
                                        d_msg = display_msg("N2", 4);
                                end
                                n_val[i] = 10'b0000000001;
                                n_mode_val[i] = "bypass";
                            end
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 10;
                end
                if (ss > 0)
                begin
                    if (n_mode_val[0] != n_mode_val[1])
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Incompatible modes for N/N2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                        $display ("Time: %0t  Instance: %m", $time);
                    end
                end
            end
            
            slowest_clk_old = slowest_clk  ( c_high_val[0]+c_low_val[0], c_mode_val[0],
                                        c_high_val[1]+c_low_val[1], c_mode_val[1],
                                        c_high_val[2]+c_low_val[2], c_mode_val[2],
                                        c_high_val[3]+c_low_val[3], c_mode_val[3],
                                        c_high_val[4]+c_low_val[4], c_mode_val[4],
                                        c_high_val[5]+c_low_val[5], c_mode_val[5],
                                        refclk_period, m_val[0]);

            slowest_clk_new = slowest_clk  ( c_high_val_tmp[0]+c_low_val_tmp[0], c_mode_val_tmp[0],
                                        c_high_val_tmp[1]+c_low_val_tmp[1], c_mode_val_tmp[1],
                                        c_high_val_tmp[2]+c_low_val_tmp[2], c_mode_val_tmp[2],
                                        c_high_val_tmp[3]+c_low_val_tmp[3], c_mode_val_tmp[3],
                                        c_high_val_tmp[4]+c_low_val_tmp[4], c_mode_val_tmp[4],
                                        c_high_val_tmp[5]+c_low_val_tmp[5], c_mode_val_tmp[5],
                                        refclk_period, m_val_tmp[0]);

            quiet_time = (slowest_clk_new > slowest_clk_old) ? slowest_clk_new : slowest_clk_old;
                                        
            // get quiet time in terms of scanclk cycles
            my_rem = quiet_time % scanclk_period;
            scanclk_cycles = quiet_time/scanclk_period;
            if (my_rem != 0)
                scanclk_cycles = scanclk_cycles + 1;

            scandone_tmp <= #((scanclk_cycles+0.5) * scanclk_period) 1'b1;
        end

        scanwrite_last_value = scanwrite_enabled;
    end

    always @(schedule_vco or areset_ipd or ena_pll)
    begin
        sched_time = 0;
    
        for (i = 0; i <= 7; i=i+1)
            last_phase_shift[i] = phase_shift[i];
     
        cycle_to_adjust = 0;
        l_index = 1;
        m_times_vco_period = new_m_times_vco_period;
    
        // give appropriate messages
        // if areset was asserted
        if (areset_ipd === 1'b1 && areset_ipd_last_value !== areset_ipd)
        begin
            $display (" Note : %s PLL was reset", family_name);
            $display ("Time: %0t  Instance: %m", $time);
            // reset lock parameters
            locked_tmp = 0;
            pll_is_locked = 0;
            pll_about_to_lock = 0;
            cycles_to_lock = 0;
            cycles_to_unlock = 0;
            pll_is_in_reset = 1;
            tap0_is_active = 0;
            for (x = 0; x <= 7; x=x+1)
                vco_tap[x] <= 1'b0;
        end
    
        // areset deasserted : note time
        // note it as refclk_time to prevent false triggering
        // of stop_vco after areset
        if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1 && pll_is_in_reset === 1'b1)
        begin
            refclk_time = $time;
            pll_is_in_reset = 0;
            if ((ena_pll === 1'b1) && (stop_vco !== 1'b1) && (next_vco_sched_time <= $time))
                schedule_vco = ~ schedule_vco;
        end

        // if ena was deasserted
        if (ena_pll == 1'b0 && ena_ipd_last_value !== ena_pll)
        begin
            $display (" Note : %s PLL is disabled", family_name);
            $display ("Time: %0t  Instance: %m", $time);
            pll_is_disabled = 1;
            tap0_is_active = 0;
            for (x = 0; x <= 7; x=x+1)
                vco_tap[x] <= 1'b0;
        end

        if (ena_pll == 1'b1 && ena_ipd_last_value !== ena_pll)
        begin
            $display (" Note : %s PLL is enabled", family_name);
            $display ("Time: %0t  Instance: %m", $time);
            pll_is_disabled = 0;
            if ((areset_ipd !== 1'b1) && (stop_vco !== 1'b1) && (next_vco_sched_time < $time))
                schedule_vco = ~ schedule_vco;
        end
    
        // illegal value on areset_ipd
        if (areset_ipd === 1'bx && (areset_ipd_last_value === 1'b0 || areset_ipd_last_value === 1'b1))
        begin
            $display("Warning : Illegal value 'X' detected on ARESET input");
            $display ("Time: %0t  Instance: %m", $time);
        end
    
        if (areset_ipd == 1'b1 || ena_pll == 1'b0 || stop_vco == 1'b1)
        begin
   
            // reset lock parameters
            locked_tmp = 0;
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
    
            vco_period_was_phase_adjusted = 0;
            phase_adjust_was_scheduled = 0;
        end
 
        if ( ($time == 0 && first_schedule == 1'b1) || (schedule_vco !== schedule_vco_last_value && (stop_vco !== 1'b1) && (ena_pll === 1'b1) && (areset_ipd !== 1'b1)) )
        begin
            // calculate loop_xplier : this will be different from m_val in ext. fbk mode
            loop_xplier = m_val[0];
            loop_initial = i_m_initial - 1;
            loop_ph = m_ph_val;
    
            if (op_mode == 1)
            begin
                if (ext_fbk_cntr_mode == "bypass")
                    ext_fbk_cntr_modulus = 1;
                else
                    ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;

                loop_xplier = m_val[0] * (ext_fbk_cntr_modulus);
                loop_ph = ext_fbk_cntr_ph;
                loop_initial = ext_fbk_cntr_initial - 1 + ((i_m_initial - 1) * ext_fbk_cntr_modulus);
            end
    
            // convert initial value to delay
            initial_delay = (loop_initial * m_times_vco_period)/loop_xplier;
    
            // convert loop ph_tap to delay
            rem = m_times_vco_period % loop_xplier;
            vco_per = m_times_vco_period/loop_xplier;
            if (rem != 0)
                vco_per = vco_per + 1;
            fbk_phase = (loop_ph * vco_per)/8;
    
            if (op_mode == 1)
            begin
                pull_back_M = (i_m_initial - 1) * (ext_fbk_cntr_modulus) * (m_times_vco_period/loop_xplier);
    
                while (pull_back_M > refclk_period)
                    pull_back_M = pull_back_M - refclk_period;
            end
            else begin
                pull_back_M = initial_delay + fbk_phase;
            end
    
            total_pull_back = pull_back_M;
            if (l_simulation_type == "timing")
                total_pull_back = total_pull_back + pll_compensation_delay;
    
            while (total_pull_back > refclk_period)
                total_pull_back = total_pull_back - refclk_period;
    
            if (total_pull_back > 0)
                offset = refclk_period - total_pull_back;
            else
                offset = 0;
    
            if (op_mode == 1)
            begin
                fbk_delay = pull_back_M;
                if (l_simulation_type == "timing")
                    fbk_delay = fbk_delay + pll_compensation_delay;
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
    
                    // schedule tap 0
                    vco_out[0] <= #(sched_time) vco_val;

                end
            end
            if (first_schedule)
            begin
                vco_val = ~vco_val;
                if (vco_val == 1'b0)
                    sched_time = sched_time + high_time;
                else
                    sched_time = sched_time + low_time;
                // schedule tap 0
                vco_out[0] <= #(sched_time) vco_val;
                first_schedule = 0;
            end

            schedule_vco <= #(sched_time) ~schedule_vco;
            next_vco_sched_time = $time + sched_time;

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
        ena_ipd_last_value = ena_pll;
        schedule_vco_last_value = schedule_vco;
    
    end

    always @(pfdena_ipd)
    begin
        if (pfdena_ipd === 1'b0)
        begin
            if (pll_is_locked)
                locked_tmp = 1'bx;
            pll_is_locked = 0;
            cycles_to_lock = 0;
            $display (" Note : %s PFDENA was deasserted", family_name);
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

    always @(negedge refclk or negedge fbclk)
    begin
        refclk_last_value = refclk;
        fbclk_last_value = fbclk;
    end

    always @(posedge refclk or posedge fbclk)
    begin
        if (refclk == 1'b1 && refclk_last_value !== refclk && areset_ipd === 1'b0)
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
                if ((vco_max != 0 && vco_min != 0) && (pfdena_ipd === 1'b1) &&
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
                            pll_about_to_lock = 0;
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
                            $display ("Warning : Input clock freq. is not within VCO range. PLL may not lock");
                            $display ("Time: %0t  Instance: %m", $time);
                            no_warn = 1'b1;
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
            if (scanwrite_enabled === 1'b1)
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
            if ( ( ($time - refclk_time > 1.5 * refclk_period) && pfdena_ipd === 1'b1 && pll_is_locked === 1'b1) || ( ($time - refclk_time > 5 * refclk_period) && pfdena_ipd === 1'b1) )
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
                    $display ("Note : %s PLL lost lock due to loss of input clock", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
                end
                pll_about_to_lock = 0;
                cycles_to_lock = 0;
                cycles_to_unlock = 0;
                first_schedule = 1;
                vco_period_was_phase_adjusted = 0;
                phase_adjust_was_scheduled = 0;
                tap0_is_active = 0;
                for (x = 0; x <= 7; x=x+1)
                    vco_tap[x] <= 1'b0;
            end
            else if (!pll_is_locked && ($time - refclk_time > 2 * refclk_period) && pfdena_ipd === 1'b1)
            begin
                inclk_out_of_range = 1;
            end
            fbclk_time = $time;
        end

        if (got_second_refclk && pfdena_ipd === 1'b1 && (!inclk_out_of_range))
        begin
            // now we know actual incoming period
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
                    cycles_to_unlock = 0;
                end
                // increment lock counter only if the second part of the above
                // time check is not true
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
                        pll_about_to_lock = 0;
                        cycles_to_lock = 0;
                        $display ("Note : %s PLL lost lock", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
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
                            new_m_times_vco_period = m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                            vco_period_was_phase_adjusted = 1;
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

        if (reconfig_err == 1'b1)
        begin
            locked_tmp = 0;
        end

        refclk_last_value = refclk;
        fbclk_last_value = fbclk;
    end

    assign clk_tmp[0] = i_clk0_counter == "c0" ? c0_clk : i_clk0_counter == "c1" ? c1_clk : i_clk0_counter == "c2" ? c2_clk : i_clk0_counter == "c3" ? c3_clk : i_clk0_counter == "c4" ? c4_clk : i_clk0_counter == "c5" ? c5_clk : 1'b0;
    assign clk_tmp[1] = i_clk1_counter == "c0" ? c0_clk : i_clk1_counter == "c1" ? c1_clk : i_clk1_counter == "c2" ? c2_clk : i_clk1_counter == "c3" ? c3_clk : i_clk1_counter == "c4" ? c4_clk : i_clk1_counter == "c5" ? c5_clk : 1'b0;
    assign clk_tmp[2] = i_clk2_counter == "c0" ? c0_clk : i_clk2_counter == "c1" ? c1_clk : i_clk2_counter == "c2" ? c2_clk : i_clk2_counter == "c3" ? c3_clk : i_clk2_counter == "c4" ? c4_clk : i_clk2_counter == "c5" ? c5_clk : 1'b0;
    assign clk_tmp[3] = i_clk3_counter == "c0" ? c0_clk : i_clk3_counter == "c1" ? c1_clk : i_clk3_counter == "c2" ? c2_clk : i_clk3_counter == "c3" ? c3_clk : i_clk3_counter == "c4" ? c4_clk : i_clk3_counter == "c5" ? c5_clk : 1'b0;
    assign clk_tmp[4] = i_clk4_counter == "c0" ? c0_clk : i_clk4_counter == "c1" ? c1_clk : i_clk4_counter == "c2" ? c2_clk : i_clk4_counter == "c3" ? c3_clk : i_clk4_counter == "c4" ? c4_clk : i_clk4_counter == "c5" ? c5_clk : 1'b0;
    assign clk_tmp[5] = i_clk5_counter == "c0" ? c0_clk : i_clk5_counter == "c1" ? c1_clk : i_clk5_counter == "c2" ? c2_clk : i_clk5_counter == "c3" ? c3_clk : i_clk5_counter == "c4" ? c4_clk : i_clk5_counter == "c5" ? c5_clk : 1'b0;

    assign clk_out[0] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[0] : 1'bx;
    assign clk_out[1] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[1] : 1'bx;
    assign clk_out[2] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[2] : 1'bx;
    assign clk_out[3] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[3] : 1'bx;
    assign clk_out[4] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[4] : 1'bx;
    assign clk_out[5] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[5] : 1'bx;

    assign sclkout0 = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode == 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? sclkout0_tmp : 1'bx;

    assign sclkout1 = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode == 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? sclkout1_tmp : 1'bx;

    assign enable_0 = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode == 1'b1) || pll_about_to_lock == 1'b1 ? enable0_tmp : 1'bx;
    assign enable_1 = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode == 1'b1) || pll_about_to_lock == 1'b1 ? enable1_tmp : 1'bx;


    // ACCELERATE OUTPUTS
    and (clk[0], 1'b1, clk_out[0]);
    and (clk[1], 1'b1, clk_out[1]);
    and (clk[2], 1'b1, clk_out[2]);
    and (clk[3], 1'b1, clk_out[3]);
    and (clk[4], 1'b1, clk_out[4]);
    and (clk[5], 1'b1, clk_out[5]);

    and (sclkout[0], 1'b1, sclkout0);
    and (sclkout[1], 1'b1, sclkout1);

    and (enable0, 1'b1, enable_0);
    and (enable1, 1'b1, enable_1);

    and (scandataout, 1'b1, scandataout_tmp);
    and (scandone, 1'b1, scandone_tmp);

endmodule // stratixii_pll
///////////////////////////////////////////////////////////////////////////////
//
//                           stratixii_MAC_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_register (
                               datain,
                               clk,
                               aclr,
                               ena,
                               bypass_register,
                               dataout
                              );


//PARAMETER
parameter data_width = 18;

//INPUT PORTS
input[data_width -1 :0]  datain;
input                     clk;
input                     aclr;
input                     ena;
input                     bypass_register;

//OUTPUT PORTS
output [data_width -1 :0] dataout;

//INTERNAL SIGNALS
wire   [data_width -1:0] dataout_tmp;
reg      [data_width -1:0] dataout_reg;   //registered data
reg                            viol_notifier;
reg prev_clk_val;

wire    [data_width -1 :0] datain_ipd;
wire clk_ipd;
wire aclr_ipd;
wire ena_ipd;

buf buf_datain    [data_width -1 :0] (datain_ipd,datain);
buf buf_clk (clk_ipd,clk);
buf buf_aclr (aclr_ipd,aclr);
buf buf_ena (ena_ipd,ena);
wire    [data_width -1 :0] dataout_opd;

buf buf_dataout    [data_width -1 :0] (dataout,dataout_opd);

//TIMING SPECIFICATION
specify
    specparam TSU           = 0;          // Set up time
    specparam TH            = 0;          // Hold time
    specparam TCO           = 0;          // Clock to Output time
    specparam TCLR          = 0;          // Clear time
    specparam TCLR_MIN_PW   = 0;          // Minimum pulse width of clear
    specparam TPRE          = 0;             // Preset time
    specparam TPRE_MIN_PW   = 0;          // Minimum pulse width of preset
    specparam TCLK_MIN_PW   = 0;          // Minimum pulse width of clock
    specparam TCE_MIN_PW    = 0;          // Minimum pulse width of clock enable
    specparam TCLKL         = 0;             // Minimum clock low time
    specparam TCLKH         = 0;          // Minimum clock high time

    $setup  (datain, posedge clk, 0, viol_notifier);
    $hold   (posedge clk, datain, 0, viol_notifier);
    $setup  (ena, posedge clk, 0, viol_notifier );
    $hold   (posedge clk, ena, 0, viol_notifier );
    (posedge aclr => (dataout  +: 'b0))          = (0,0);
    (posedge clk  => (dataout  +: dataout_tmp))  = (0,0);
endspecify

initial
begin
    dataout_reg = 0;
end

//Register the datain
always @(clk_ipd or posedge aclr_ipd)
    begin
        if (aclr_ipd == 1'b1)
            dataout_reg <= 0;
        else if (prev_clk_val == 1'b0 && clk_ipd == 1'b1)
	begin
		if (ena_ipd == 1'b1)
			dataout_reg <= datain_ipd;
		else
			dataout_reg <= dataout_reg;
	end
	prev_clk_val = clk_ipd;
    end
//assign the dataout depending on the bypass_register value
assign dataout_opd = bypass_register ? datain_ipd :dataout_reg ;
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                      stratixii_MAC_MULT_BLOCK
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_mult_block (
                                 dataa,
                                 datab,
                                 signa,
                                 signb,
                                 bypass_multiplier,
                                 scanouta,
                                 scanoutb,
                                 dataout
                               );
//PARAMETER
parameter dataa_width   = 18;
parameter datab_width   = 18;
parameter dataout_width = dataa_width + datab_width;
parameter dynamic_mode = "no";

//INPUT PORTS
input [dataa_width-1:0] dataa;
input [datab_width-1:0] datab;
input                    signa;
input                    signb;
input                    bypass_multiplier;

//OUTPUT PORTS
output [dataa_width-1:0]       scanouta;
output [datab_width-1:0]       scanoutb;
output [dataout_width -1 :0]   dataout;

//INTERNAL SIGNALS
wire [dataout_width -1:0]       product;             //product of dataa and datab
wire [dataout_width -1:0]       abs_product;         //|product| of dataa and datab
wire [dataa_width-1:0]          abs_a;               //absolute value of dataa
wire [datab_width-1:0]          abs_b;               //absolute value of dadab
wire                            product_sign;        // product sign bit
wire                            dataa_sign;          //dataa sign bit
wire                            datab_sign;          //datab sign bit

wire [dataa_width-1:0] dataa_ipd;
wire [datab_width-1:0] datab_ipd;
wire    signa_ipd;
wire signb_ipd;
wire bypass_multiplier_ipd;

buf buf_dataa [dataa_width-1:0] (dataa_ipd,dataa);
buf buf_datab [datab_width-1:0] (datab_ipd,datab);
buf buf_signa    (signa_ipd,signa);
buf buf_signb (signb_ipd,signb);
buf buf_bypass_multiplier (bypass_multiplier_ipd,bypass_multiplier);
wire  [dataa_width-1:0] scanouta_opd;
wire [datab_width-1:0] scanoutb_opd;
wire [dataout_width -1 :0] dataout_opd;

buf buf_scanouta  [dataa_width-1:0] (scanouta,scanouta_opd);
buf buf_scanoutb [datab_width-1:0] (scanoutb,scanoutb_opd);
buf buf_dataout [dataout_width -1 :0] (dataout,dataout_opd);

//TIMING SPECIFICATION
specify
    (dataa *> dataout)              = (0, 0);
    (datab *> dataout)              = (0, 0);
    (bypass_multiplier *> dataout)  = (0, 0);
    (dataa => scanouta)             = (0, 0);
    (datab => scanoutb)             = (0, 0);
    (signa *> dataout)              = (0, 0);
    (signb *> dataout)              = (0, 0);
endspecify

//Output assignment
assign scanouta_opd     = dataa_ipd;
assign scanoutb_opd     = datab_ipd;
assign dataa_sign   = dataa_ipd[dataa_width-1] && signa_ipd;
assign datab_sign   = datab_ipd[datab_width-1] && signb_ipd;
assign product_sign = dataa_sign ^ datab_sign;
assign abs_a        = dataa_sign ? (~dataa_ipd + 1) : dataa_ipd;
assign abs_b        = datab_sign ? (~datab_ipd + 1) : datab_ipd;
assign abs_product  = abs_a * abs_b;
assign product      = product_sign ? (~abs_product + 1) : abs_product;
assign dataout_opd = ((dynamic_mode == "yes") && (bypass_multiplier_ipd)) ? {datab_ipd, dataa_ipd} : ((bypass_multiplier_ipd)  ? {dataa_ipd,datab_ipd} : product);
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                           stratixii_MAC_RS_BLOCK
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_rs_block(
                              operation,
                              round,
                              saturate,
                              addnsub,
                              signa,
                              signb,
                              signsize,
                              roundsize,
                              dataoutsize,
                              dataa,
                              datab,
                              datain,
                              dataout
                            );
//PARAMETERS
parameter    block_type = "mac_mult";
parameter    dataa_width = 18;
parameter    datab_width = 18;

//INPUT PORTS
input          round;
input          saturate;
input          addnsub;
input          signa;
input          signb;
input [3:0]      operation;
input [5:0]      signsize;
input [7:0]      roundsize;
input [7:0]      dataoutsize;
input [71:0]  dataa;
input [71:0]  datab;
input [71:0]  datain;

//OUTPUT PORTS
output [71:0] dataout;

//INTERNAL SIGNALS
reg [71:0]   dataout_round;
reg [71:0]   dataout_saturate;
reg [71:0]   dataout_dly;
reg                saturated;
reg [71:0]   min;
reg [71:0]   max;

wire [71:0]      rs_saturate;
wire [71:0]      rs_mac_mult;
wire [71:0]      rs_mac_out;
reg                 msb;
integer          i;

reg [6:0] dataa_local;
reg [6 :0] datab_local; 
reg [6:0] width_local;
reg[72:0] dataout_saturate_tmp;
reg[73:0] max_tmp;
reg[73:0] min_tmp;

wire round_ipd;
wire saturate_ipd;
wire addnsub_ipd;
wire signa_ipd;
wire signb_ipd;
wire [71:0]dataa_ipd;
wire [71:0]datab_ipd;
wire [71:0]datain_ipd;

buf buf_round (round_ipd,round);
buf buf_saturate (saturate_ipd,saturate);
buf buf_addnsub (addnsub_ipd,addnsub);
buf buf_signa (signa_ipd,signa);
buf buf_signb (signb_ipd,signb);
buf buf_dataa [71:0](dataa_ipd,dataa);
buf buf_datab [71:0](datab_ipd,datab);
buf buf_datain [71:0](datain_ipd,datain);
wire  [71:0] dataout_opd;

buf buf_dataout  [71:0] (dataout,dataout_opd);

initial
begin
    dataa_local = 7'd0;
    datab_local = 7'd0;
    width_local = 7'd0;
end
// TIMING SPECIFICATION
specify
   (round    *> dataout) = (0, 0);
   (saturate *> dataout) = (0, 0);
   (dataa    *> dataout) = (0, 0);
   (datab    *> dataout) = (0, 0);
   (datain   *> dataout) = (0, 0);
endspecify

always @ (datain_ipd or round_ipd)
    begin
        if(round_ipd)
            dataout_round = datain_ipd +(1 << (dataoutsize - signsize - roundsize -1));
        else
            dataout_round = datain_ipd;
    end

always @ (operation or dataa_ipd or datab_ipd or datain_ipd or signa_ipd or signb_ipd or round_ipd or saturate_ipd or addnsub_ipd or dataout_round)
    begin
        if(saturate_ipd)
            begin
                if (block_type == "mac_mult")
                    begin
                        if (!dataout_round[dataa_width+datab_width-1] &&
                            dataout_round[dataa_width+datab_width-2])
                            begin
		                        dataout_saturate_tmp[72:0] = {{(74-dataa_width-datab_width){1'b0}},{(dataa_width+datab_width-1){1'b1}}};
		                        dataout_saturate[71:0] = dataout_saturate_tmp[72:1];
                                min = dataout_saturate;
                                max = dataout_saturate;
                                saturated = 1'b1;
                            end
                        else
                            begin
                                dataout_saturate = dataout_round;
                                saturated = 1'b0;
                             end
                    end
                else if  ((operation[2] == 1'b1) &&
                           ((block_type == "R") ||
                           (block_type == "T")))
                    begin
                        saturated = 1'b0;
                        if(datab_width > 1)
                            datab_local = datab_width-2;
                        for (i = datab_local; i < (datab_width + signsize - 2); i = i + 1)
                            begin
                               if(dataout_round[datab_local] != dataout_round[i])
                                           saturated = 1'b1;
                                    end  
                        if(saturated)
                            begin
                                max_tmp[73:0] = {{(74 - datab_width){1'b1}},{(datab_width){1'b0}}};
                                min_tmp[73:0] = {{(74 - datab_width){1'b0}},{(datab_width){1'b1}}};
                                max[71:0] = max_tmp[73:2];
                                min[71:0] = min_tmp[73:2];
                            end
                        else
                            begin
                                dataout_saturate = dataout_round;
                            end
                        msb = dataout_round[datab_width+15];
                    end
                else
                     begin
                         if(signa_ipd || signb_ipd || ~addnsub_ipd)
                             begin
                                 min = 1 << dataa_width;
                                 max = (1 << dataa_width)-1;
                             end
                         else
                             begin
                                 min = 0;
                                 max = (1 << (dataa_width + 1))-1;
                             end
                         saturated = 1'b0;
                         if(dataa_width > 1 )
                             dataa_local = dataa_width-2;                          
                         for (i = dataa_local; i < (dataa_width + signsize - 1); i = i + 1)
                             begin
                                 if(dataout_round[dataa_local] != dataout_round[i])
                                             saturated = 1'b1;
                                     end
                         msb = dataout_round[i];
                     end
                     if(saturated)
                          begin
                              if(msb)
                                  dataout_saturate = max;
                              else
                                  dataout_saturate = min;
                          end
                     else
                         dataout_saturate = dataout_round;
            end
        else
            begin
                saturated = 1'b0;
                dataout_saturate = dataout_round;
            end
    end

always @ (round_ipd or dataout_saturate)
    begin
        if(round_ipd)
            begin
                dataout_dly = dataout_saturate;
                width_local = dataoutsize - signsize - roundsize;
                if(width_local > 0)
                    begin
               	        for (i = 0; i < width_local; i = i + 1)
               	            dataout_dly[i] = 1'b0;
               	    end
             end
        else
            dataout_dly = dataout_saturate;
    end

assign rs_mac_mult = (saturate_ipd && (block_type == "mac_mult") && saturated)
                     ?({dataout_dly[71:3], 2'b0, saturated})
                     : rs_mac_out;

assign rs_mac_out  =  (saturate_ipd && (block_type != "mac_mult"))
                      ? ({dataout_dly[71:3],saturated, datain_ipd[1:0]})
                      : dataout_dly;

assign rs_saturate = saturate_ipd ? rs_mac_mult : rs_mac_out;

assign dataout_opd = ((operation == 4'b0000) || (operation == 4'b0111)) ? datain_ipd : rs_saturate;
endmodule


///////////////////////////////////////////////////////////////////////////////
//
//                           stratixii_MAC_MULT
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_mult(
                           dataa,
                           datab,
                           scanina,
                           scaninb,
                           sourcea,
                           sourceb,
                           signa,
                           signb,
                           round,
                           saturate,
                           clk,
                           aclr,
                           ena,
                           mode,     
                           zeroacc,  
                           dataout,
                           scanouta,
                           scanoutb,
                           devclrn,
                           devpor
                        );

//PARAMETERS
parameter dataa_width       = 18;
parameter datab_width       = 18;
parameter dataa_clock         = "none";
parameter datab_clock       = "none";
parameter signa_clock         = "none";
parameter signb_clock         = "none";
parameter round_clock       = "none";
parameter saturate_clock    = "none";
parameter output_clock       = "none";
parameter dataa_clear         = "none";
parameter datab_clear         = "none";
parameter signa_clear         = "none";
parameter signb_clear         = "none";
parameter round_clear       = "none";
parameter saturate_clear    = "none";
parameter output_clear       = "none";
parameter bypass_multiplier = "no";
parameter mode_clock        = "none";
parameter zeroacc_clock     = "none";
parameter mode_clear        = "none";
parameter zeroacc_clear     = "none";

// SIMULATION_ONLY_PARAMETERS_BEGIN

parameter signa_internally_grounded   = "false";
parameter signb_internally_grounded   = "false";
parameter lpm_hint                    = "true";
parameter lpm_type                    = "stratixii_mac_mult";
parameter dynamic_mode                = "no";
parameter dataout_width               = dataa_width + datab_width;

// SIMULATION_ONLY_PARAMETERS_END

//INPUT PORTS
input [dataa_width-1:0]  dataa;
input [datab_width-1:0]  datab;
input [dataa_width-1:0]  scanina;
input [datab_width-1:0]  scaninb;
input                     sourcea;
input                     sourceb;
input                     signa;
input                     signb;
input                     round;
input                     saturate;
input [3:0]                 clk;
input [3:0]                 aclr;
input [3:0]                 ena;
input                     mode; 
input   zeroacc; 

input                     devclrn;
input                     devpor;

//OUTPUT PORTS
output [dataout_width-1:0] dataout;
output [dataa_width-1:0] scanouta;
output [datab_width-1:0] scanoutb;

tri1 devclrn;
tri1 devpor;

//Internal Signals
wire [dataa_width-1:0] dataa_in; //dataa or scaninA depending on sourceA
wire [datab_width-1:0] datab_in;//datab or scaninB depending on sourceB

//Internal signals to instantiate the dataa input register unit
wire [3:0] dataa_clk_value;
wire [3:0] dataa_aclr_value;
wire dataa_clk;
wire dataa_aclr;
wire dataa_ena;
wire dataa_bypass_register;
wire [dataa_width-1:0] dataa_in_reg;

//Internal signals to instantiate the datab input register unit
wire [3:0] datab_clk_value;
wire [3:0] datab_aclr_value;
wire datab_clk;
wire datab_aclr;
wire datab_ena;
wire datab_bypass_register;
wire [datab_width-1:0] datab_in_reg;

//Internal signals to instantiate the signa input register unit
wire [3:0] signa_clk_value;
wire [3:0] signa_aclr_value;
wire signa_clk;
wire signa_aclr;
wire signa_ena;
wire signa_bypass_register;
wire  signa_in_reg;

//Internal signals to instantiate the signb input register unit
wire [3:0] signb_clk_value;
wire [3:0] signb_aclr_value;
wire signb_clk;
wire signb_aclr;
wire signb_ena;
wire signb_bypass_register;
wire  signb_in_reg;

//Internal signals to instantiate the round input register unit
wire [3:0] round_clk_value;
wire [3:0] round_aclr_value;
wire round_clk;
wire round_aclr;
wire round_ena;
wire round_bypass_register;
wire round_in_reg;

//Internal signals to instantiate the saturate input register unit
wire [3:0] saturate_clk_value;
wire [3:0] saturate_aclr_value;
wire saturate_clk;
wire saturate_aclr;
wire saturate_ena;
wire saturate_bypass_register;
wire saturate_in_reg;

//Internal signals to instantiate the mode input register unit 
wire [3:0] mode_clk_value;  
wire [3:0] mode_aclr_value; 
wire mode_clk;          
wire mode_aclr;         
wire mode_ena;          
wire mode_bypass_register;  
wire  mode_in_reg;      

//Internal signals to instantiate the zeroacc input register unit 
wire [3:0] zeroacc_clk_value;       
wire [3:0] zeroacc_aclr_value;  
wire zeroacc_clk;               
wire zeroacc_aclr;          
wire zeroacc_ena;               
wire zeroacc_bypass_register;       
wire  zeroacc_in_reg;           

//Internal signals to instantiate the multiplier block
wire bypass_mult;
wire signa_mult;
wire signb_mult;
wire [dataa_width-1:0] scanouta_mult;
wire [datab_width-1:0] scanoutb_mult;
wire [dataout_width-1:0] dataout_mult;

//Internal signals to instantiate round and saturate block
wire[7:0] mac_rs_dataout_size;
wire [71:0] mac_rs_dataa;
wire [71:0] mac_rs_datab;
wire [71:0] mac_rs_datain;
wire [71:0] mac_rs_dataout;
wire [71:0] dataout_reg;

//Internal signals to instantiate the output register unit
wire [3:0] output_clk_value;
wire [3:0] output_aclr_value;
wire output_clk;
wire output_aclr;
wire output_ena;
wire output_bypass_register;

//Select the scanin data or the multiplier data
assign  dataa_in = (sourcea == 1'b1) ? scanina : dataa;
assign  datab_in = (sourceb == 1'b1) ? scaninb : datab;

//Instantiate the dataa input Register
stratixii_mac_register dataa_input_register (
                                             .datain(dataa_in),
                                             .clk(dataa_clk),
                                             .aclr(dataa_aclr),
                                             .ena(dataa_ena),
                                             .bypass_register(dataa_bypass_register),
                                             .dataout(dataa_in_reg)
                                             );

defparam dataa_input_register.data_width = dataa_width;

//decode the clk and aclr values
assign dataa_clk_value =((dataa_clock == "0") || (dataa_clock == "none")) ? 4'b0000 :
                        (dataa_clock == "1") ? 4'b0001 :
                        (dataa_clock == "2") ? 4'b0010 :
                        (dataa_clock == "3") ? 4'b0011 : 4'b0000;

assign dataa_aclr_value = ((dataa_clear == "0") ||(dataa_clear == "none")) ? 4'b0000 :
                          (dataa_clear == "1") ? 4'b0001 :
                          (dataa_clear == "2") ? 4'b0010 :
                          (dataa_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign dataa_clk = clk[dataa_clk_value] ? 'b1 : 'b0;
assign dataa_aclr = aclr[dataa_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign dataa_ena = ena[dataa_clk_value] ? 'b1 : 'b0;
assign dataa_bypass_register = (dataa_clock == "none") ? 'b1 : 'b0;

//Instantiate the datab input Register
stratixii_mac_register datab_input_register (
                                             .datain(datab_in),
                                             .clk(datab_clk),
                                             .aclr(datab_aclr),
                                             .ena(datab_ena),
                                             .bypass_register(datab_bypass_register),
                                             .dataout(datab_in_reg)
                                             );

defparam datab_input_register.data_width = datab_width;

//decode the clk and aclr values
assign datab_clk_value =((datab_clock == "0") || (datab_clock == "none")) ? 4'b0000 :
                        (datab_clock == "1") ? 4'b0001 :
                        (datab_clock == "2") ? 4'b0010 :
                        (datab_clock == "3") ? 4'b0011 : 4'b0000;

assign   datab_aclr_value = ((datab_clear == "0") ||(datab_clear == "none")) ? 4'b0000 :
                            (datab_clear == "1") ? 4'b0001 :
                            (datab_clear == "2") ? 4'b0010 :
                            (datab_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign datab_clk = clk[datab_clk_value] ? 'b1 : 'b0;
assign datab_aclr = aclr[datab_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign datab_ena = ena[datab_clk_value] ? 'b1 : 'b0;
assign datab_bypass_register = (datab_clock == "none") ? 'b1 : 'b0;


//Instantiate the signa input Register
stratixii_mac_register signa_input_register (
                                             .datain(signa),
                                             .clk(signa_clk),
                                             .aclr(signa_aclr),
                                             .ena(signa_ena),
                                             .bypass_register(signa_bypass_register),
                                             .dataout(signa_in_reg)
                                             );

defparam signa_input_register.data_width = 1;

//decode the clk and aclr values
assign signa_clk_value =((signa_clock == "0") || (signa_clock == "none")) ? 4'b0000 :
                        (signa_clock == "1") ? 4'b0001 :
                        (signa_clock == "2") ? 4'b0010 :
                        (signa_clock == "3") ? 4'b0011 : 4'b0000;

assign   signa_aclr_value = ((signa_clear == "0") ||(signa_clear == "none")) ? 4'b0000 :
                            (signa_clear == "1") ? 4'b0001 :
                            (signa_clear == "2") ? 4'b0010 :
                            (signa_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signa_clk = clk[signa_clk_value] ? 'b1 : 'b0;
assign signa_aclr = aclr[signa_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign signa_ena = ena[signa_clk_value] ? 'b1 : 'b0;
assign signa_bypass_register = (signa_clock == "none") ? 'b1 : 'b0;

//Instantiate the signb input Register
stratixii_mac_register signb_input_register (
                                             .datain(signb),
                                             .clk(signb_clk),
                                             .aclr(signb_aclr),
                                             .ena(signb_ena),
                                             .bypass_register(signb_bypass_register),
                                             .dataout(signb_in_reg)
                                             );

defparam signb_input_register.data_width = 1;

//decode the clk and aclr values
assign signb_clk_value =((signb_clock == "0") || (signb_clock == "none")) ? 4'b0000 :
                        (signb_clock == "1") ? 4'b0001 :
                        (signb_clock == "2") ? 4'b0010 :
                        (signb_clock == "3") ? 4'b0011 : 4'b0000;

assign   signb_aclr_value = ((signb_clear == "0") ||(signb_clear == "none")) ? 4'b0000 :
                            (signb_clear == "1") ? 4'b0001 :
                            (signb_clear == "2") ? 4'b0010 :
                            (signb_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign signb_clk = clk[signb_clk_value] ? 'b1 : 'b0;
assign signb_aclr = aclr[signb_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign signb_ena = ena[signb_clk_value] ? 'b1 : 'b0;
assign signb_bypass_register = (signb_clock == "none") ? 'b1 : 'b0;



//Instantiate the round input Register
stratixii_mac_register round_input_register (
                                             .datain(round),
                                             .clk(round_clk),
                                             .aclr(round_aclr),
                                             .ena(round_ena),
                                             .bypass_register(round_bypass_register),
                                             .dataout(round_in_reg)
                                             );

defparam round_input_register.data_width = 1;

//decode the clk and aclr values
assign round_clk_value =((round_clock == "0") || (round_clock == "none")) ? 4'b0000 :
                        (round_clock == "1") ? 4'b0001 :
                        (round_clock == "2") ? 4'b0010 :
                        (round_clock == "3") ? 4'b0011 : 4'b0000;

assign   round_aclr_value = ((round_clear == "0") ||(round_clear == "none")) ? 4'b0000 :
                            (round_clear == "1") ? 4'b0001 :
                            (round_clear == "2") ? 4'b0010 :
                            (round_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign round_clk = clk[round_clk_value] ? 'b1 : 'b0;
assign round_aclr = aclr[round_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign round_ena = ena[round_clk_value] ? 'b1 : 'b0;
assign round_bypass_register = (round_clock == "none") ? 'b1 : 'b0;

//Instantiate the saturate input Register
stratixii_mac_register saturate_input_register (
                                             .datain(saturate),
                                             .clk(saturate_clk),
                                             .aclr(saturate_aclr),
                                             .ena(saturate_ena),
                                             .bypass_register(saturate_bypass_register),
                                             .dataout(saturate_in_reg)
                                             );

defparam saturate_input_register.data_width = 1;

//decode the clk and aclr values
assign saturate_clk_value =((saturate_clock == "0") || (saturate_clock == "none")) ? 4'b0000 :
                           (saturate_clock == "1") ? 4'b0001 :
                           (saturate_clock == "2") ? 4'b0010 :
                           (saturate_clock == "3") ? 4'b0011 : 4'b0000;

assign   saturate_aclr_value = ((saturate_clear == "0") ||(saturate_clear == "none")) ? 4'b0000 :
                               (saturate_clear == "1") ? 4'b0001 :
                               (saturate_clear == "2") ? 4'b0010 :
                               (saturate_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign saturate_clk = clk[saturate_clk_value] ? 'b1 : 'b0;
assign saturate_aclr = aclr[saturate_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign saturate_ena = ena[saturate_clk_value] ? 'b1 : 'b0;
assign saturate_bypass_register = (saturate_clock == "none") ? 'b1 : 'b0;

//Instantiate the mode input Register   
stratixii_mac_register mode_input_register (                            
                                            .datain(mode),                 
                                            .clk(mode_clk),                
                                            .aclr(mode_aclr),              
                                            .ena(mode_ena),                
                                            .bypass_register(mode_bypass_register), 
                                            .dataout(mode_in_reg)          
                                            );                         

defparam mode_input_register.data_width = 1;   

//decode the clk and aclr values  
assign mode_clk_value =((mode_clock == "0") || (mode_clock == "none")) ? 4'b0000 :  
                       (mode_clock == "1") ? 4'b0001 :     
                       (mode_clock == "2") ? 4'b0010 :     
                       (mode_clock == "3") ? 4'b0011 : 4'b0000;  

assign   mode_aclr_value = ((mode_clear == "0") ||(mode_clear == "none")) ? 4'b0000 :   
                           (mode_clear == "1") ? 4'b0001 :        
                           (mode_clear == "2") ? 4'b0010 :        
                           (mode_clear == "3") ? 4'b0011 : 4'b0000; 

//assign the corresponding clk,aclr,enable and bypass register values.
assign mode_clk = clk[mode_clk_value] ? 'b1 : 'b0;                  
assign mode_aclr = aclr[mode_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign mode_ena = ena[mode_clk_value] ? 'b1 : 'b0;                  
assign mode_bypass_register = (mode_clock == "none") ? 'b1 : 'b0;       


//Instantiate the zeroacc input Register
stratixii_mac_register zeroacc_input_register (                             
                                             .datain(zeroacc),                  
                                             .clk(zeroacc_clk),                 
                                             .aclr(zeroacc_aclr),                   
                                             .ena(zeroacc_ena),                     
                                             .bypass_register(zeroacc_bypass_register),   
                                             .dataout(zeroacc_in_reg)               
                                             );                             

defparam zeroacc_input_register.data_width = 1;   

//decode the clk and aclr values   
assign zeroacc_clk_value =((zeroacc_clock == "0") || (zeroacc_clock == "none")) ? 4'b0000 : 
                          (zeroacc_clock == "1") ? 4'b0001 :              
                          (zeroacc_clock == "2") ? 4'b0010 :              
                          (zeroacc_clock == "3") ? 4'b0011 : 4'b0000;         

assign   zeroacc_aclr_value = ((zeroacc_clear == "0") ||(zeroacc_clear == "none")) ? 4'b0000 :  
                              (zeroacc_clear == "1") ? 4'b0001 :         
                              (zeroacc_clear == "2") ? 4'b0010 :         
                              (zeroacc_clear == "3") ? 4'b0011 : 4'b0000;    

//assign the corresponding clk,aclr,enable and bypass register values.
assign zeroacc_clk = clk[zeroacc_clk_value] ? 'b1 : 'b0;                        
assign zeroacc_aclr = aclr[zeroacc_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;    
assign zeroacc_ena = ena[zeroacc_clk_value] ? 'b1 : 'b0;                        
assign zeroacc_bypass_register = (zeroacc_clock == "none") ? 'b1 : 'b0;             

//Instantiate mac_multiplier block
stratixii_mac_mult_block mac_multiplier (
                                         .dataa(dataa_in_reg),
                                         .datab(datab_in_reg),
                                         .signa(signa_mult),
                                         .signb(signb_mult),
                                         .bypass_multiplier(bypass_mult),
                                         .scanouta(scanouta_mult),
                                         .scanoutb(scanoutb_mult),
                                         .dataout(dataout_mult)
                                          );

defparam mac_multiplier.dataa_width = dataa_width;
defparam mac_multiplier.datab_width = datab_width;
defparam mac_multiplier.dynamic_mode = dynamic_mode;

assign    signa_mult = ((signa_internally_grounded == "true") 
                        &&(dynamic_mode == "no")) ||
                         ((signa_internally_grounded == "true") &&
                         (dynamic_mode == "yes")
                         &&(zeroacc_in_reg == 1'b1) 
                         &&(mode_in_reg == 1'b0)
                         ) ? 1'b0 : signa_in_reg;

assign    signb_mult = ((signb_internally_grounded == "true") 
                        &&(dynamic_mode == "no")) ||
                         ((signb_internally_grounded == "true") &&
                         (dynamic_mode == "yes")
                         &&(zeroacc_in_reg == 1'b1) 
                         &&(mode_in_reg == 1'b0)
                          ) ? 1'b0 : signb_in_reg;

assign    bypass_mult = ((bypass_multiplier == "yes")
                        &&(dynamic_mode == "no")) ||
                        ((bypass_multiplier == "yes")&&
                        (dynamic_mode == "yes")
                        &&(mode_in_reg == 'b1)
                        ) ? 1'b1 : 1'b0;

//Instantiate round and saturate block
stratixii_mac_rs_block mac_rs_block(
                                    .operation(4'b1111),
                                    .round(round_in_reg),
                                    .saturate(saturate_in_reg),
                                    .addnsub(1'b0),
                                    .signa(signa_in_reg),
                                    .signb(signb_in_reg),
                                    .signsize(6'd2),
                                    .roundsize(8'd15),
                                    .dataoutsize(mac_rs_dataout_size),
                                    .dataa(mac_rs_dataa),
                                    .datab(mac_rs_datab),
                                    .datain(mac_rs_datain),
                                    .dataout(mac_rs_dataout)
                                    );
defparam mac_rs_block.block_type = "mac_mult";
defparam mac_rs_block.dataa_width = dataa_width;
defparam mac_rs_block.datab_width = datab_width;

assign   mac_rs_dataout_size = dataa_width + datab_width;
assign mac_rs_dataa = scanouta_mult;
assign mac_rs_datab = scanoutb_mult;
assign mac_rs_datain = dataout_mult;
assign   dataout_reg = (bypass_mult == 1'b1) ? mac_rs_datain : mac_rs_dataout;


stratixii_mac_register mult_output_register(
                                             .datain(dataout_reg[dataout_width -1:0]),
                                             .clk(output_clk),
                                             .aclr(output_aclr),
                                             .ena(output_ena),
                                             .bypass_register(output_bypass_register),
                                             .dataout(dataout)
                                             );

defparam mult_output_register.data_width = dataout_width;
   //decode the clk and aclr values
assign output_clk_value =((output_clock == "0") || (output_clock == "none")) ? 4'b0000 :
                          (output_clock == "1") ? 4'b0001 :
                          (output_clock == "2") ? 4'b0010 :
                          (output_clock == "3") ? 4'b0011 : 4'b0000;

assign   output_aclr_value = ((output_clear == "0") ||(output_clear == "none")) ? 4'b0000 :
                              (output_clear == "1") ? 4'b0001 :
                              (output_clear == "2") ? 4'b0010 :
                              (output_clear == "3") ? 4'b0011 : 4'b0000;

//assign the corresponding clk,aclr,enable and bypass register values.
assign output_clk = clk[output_clk_value] ? 'b1 : 'b0;
assign output_aclr = aclr[output_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign output_ena = ena[output_clk_value] ? 'b1 : 'b0;
assign output_bypass_register = (output_clock == "none") ? 'b1 : 'b0;

//assign the scanout values
assign scanouta = dataa_in_reg;
assign scanoutb = datab_in_reg;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                         stratixii_MAC_OUT_Input_Interface
//
///////////////////////////////////////////////////////////////////////////////


module  stratixii_mac_out_input_interface(
                                           accuma,
                                           accumc,
                                           dataa,
                                           datab,
                                           datac,
                                           datad,
                                           sign,
                                           multabsaturate,
                                           multcdsaturate,
                                           zeroacc,
                                           zeroacc1,    
                                           operation,
                                           outa,
                                           outb,
                                           outc,
                                           outd,
                                           sata,
                                           satb,
                                           satc,
                                           satd,
                                           satab,
                                           satcd
                                           );

//PARAMETERS
parameter dataa_width = 36;
parameter datab_width = 36;
parameter datac_width = 36;
parameter datad_width = 36;
parameter accuma_width = datab_width + 16;
parameter accumc_width = datad_width + 16;

// INPUT PORTS
input [51:0] accuma;
input [51:0] accumc;
input [71:0] dataa;
input [71:0] datab;
input [71:0] datac;
input [71:0] datad;
input sign;
input   multabsaturate;
input   multcdsaturate;
input   zeroacc;
input   zeroacc1; 

input [3:0]     operation;

// OUTPUT PORTS
output [71:0] outa;
output [71:0] outb;
output [71:0] outc;
output [71:0] outd;
output   sata;
output   satb;
output   satc;
output   satd;
output   satab;
output   satcd;

// INTERNAL SIGNALS
reg [71:0] outa_tmp;
reg [71:0] outb_tmp;
reg [71:0] outc_tmp;
reg [71:0] outd_tmp;
reg sata_tmp;
reg satb_tmp;
reg satc_tmp;
reg satd_tmp;
reg satab_tmp;
reg satcd_tmp;
integer i,j;
reg[6:0] width_tmp;

//sign extended signals
wire [71:0] dataa_se;
wire [71:0] datab_se;
wire [71:0] datac_se;
wire [71:0] datad_se;
wire [71:0] accuma_se;
wire [71:0] accumc_se;

initial
	begin
		width_tmp = 7'd0;
	end
	
assign outa = outa_tmp;
assign outb = outb_tmp;
assign outc = outc_tmp;
assign outd = outd_tmp;
assign sata = sata_tmp;
assign satb = satb_tmp;
assign satc = satc_tmp;
assign satd = satd_tmp;
assign satab = satab_tmp;
assign satcd = satcd_tmp;


//Sign Extension for inputs
assign dataa_se = (dataa[dataa_width-1]&& sign)
                  ?{{(72-dataa_width){1'b1}},dataa[dataa_width -1 : 0]}
                  :{{(72-dataa_width){1'b0}},dataa[dataa_width -1 : 0]} ;

assign datab_se = (datab[datab_width-1]&& sign)
                  ?{{(72-datab_width){1'b1}},datab[datab_width -1 : 0]}
                  :{{(72-datab_width){1'b0}},datab[datab_width -1 : 0]} ;

assign datac_se = (datac[datac_width-1]&& sign)
                  ?{{(72-datac_width){1'b1}},datac[datac_width -1 : 0]}
                  :{{(72-datac_width){1'b0}},datac[datac_width -1 : 0]} ;

assign datad_se = (datad[datad_width-1]&& sign)
                  ?{{(72-datad_width){1'b1}},datad[datad_width -1 : 0]}
                  :{{(72-datad_width){1'b0}},datad[datad_width -1 : 0]} ;

assign accuma_se = (accuma[accuma_width-1]&& sign)
                   ?{{(72-accuma_width){1'b1}},accuma[accuma_width -1 : 0]}
                   :{{(72-accuma_width){1'b0}},accuma[accuma_width -1 : 0]} ;

assign accumc_se = (accumc[accumc_width-1]&& sign)
                   ?{{(72-accumc_width){1'b1}},accumc[accumc_width -1 : 0]}
                   :{{(72-accumc_width){1'b0}},accumc[accumc_width -1 : 0]} ;

always @ (accuma_se or
accumc_se or
dataa_se or
datab_se or
datac_se or
datad_se or
multabsaturate or
multcdsaturate or
zeroacc or
zeroacc1 or 
operation)
    begin
        case (operation)
         //Output Only
        4'b0000 :
            begin
                outa_tmp = dataa_se;
                outb_tmp = datab_se;
                outc_tmp = datac_se;
                outd_tmp = datad_se;
            end

          // ACCUMULATOR
        4'b0100 :
            begin
                if(zeroacc == 1'b1)
                    begin
                        if(accuma_width > dataa_width)
                    	width_tmp = accuma_width - dataa_width;
                    if(accuma_width > dataa_width)
                        begin
                        	outa_tmp[71:accuma_width] = dataa_se[71:accuma_width];
                        	j= 0;
                        	for ( i = width_tmp; i < accuma_width; i = i+1)
                        		begin
                        			outa_tmp[i] = dataa[j];
                        			j= j+1;
                        		end
                        	for( i = 0; i < width_tmp; i = i +1)
                        		begin
                        			outa_tmp[i]=1'b0;
                        		end
                        end
                        else
                            begin
				outa_tmp[71:accuma_width] = dataa_se[71:accuma_width];
			        j = dataa_width - accuma_width;
			        for( i = 0 ; i < accuma_width; i = i + 1)
				    begin
					outa_tmp[i] = dataa[j];
					j = j + 1;
				    end
			    end
             
                    end
                else
                    outa_tmp = accuma_se;
                outb_tmp = datab_se;
                outc_tmp = datac_se;
                outd_tmp = datad_se;
            end

           // TWO ACCUMULATORS
        4'b1100 :
            begin
                case ({zeroacc1, zeroacc})
                    2'b00:
                        begin
                            outa_tmp = accuma_se;
                            outc_tmp = accumc_se;
                        end
                    2'b01:
                        begin
                            outa_tmp = {dataa_se[71:52],dataa[15:0],dataa[35:18],dataa[17:16],16'h0000};
                            outc_tmp = accumc_se;
                        end
                    2'b10:
                        begin
                            outa_tmp = accuma_se;
                            outc_tmp = {datac_se[71:52],datac[15:0],datac[35:18],datac[17:16],16'h0000};
                        end
                     2'b11:
                         begin
                             outa_tmp = {dataa_se[71:52],dataa[15:0],dataa[35:18],dataa[17:16],16'h0000};
                             outc_tmp = {datac_se[71:52],datac[15:0],datac[35:18],datac[17:16],16'h0000};
                         end
                    default :
                        begin
                            outa_tmp = accuma_se;
                            outc_tmp = accumc_se;
                        end
                endcase
                outb_tmp = datab_se;
                outd_tmp = datad_se;
             end
        // OUTPUT_ONLY / ACCUMULATOR -- Dynamic Mode
       4'b1101 :
           begin
               if(zeroacc == 1'b1)
                   outa_tmp = {dataa_se[71:52],dataa[15:0],dataa[35:18],dataa[17:16],16'h0000};
               else
                   outa_tmp= accuma_se;
               outb_tmp = datab_se;
               outc_tmp = datac_se;
               outd_tmp = datad_se;
           end
         //Accumulator /Output Only --Dynamic Mode
        4'b1110 :
            begin
                if(zeroacc1 == 1'b1)
                    outc_tmp = {datac_se[71:52],datac[15:0],datac[35:18],datac[17:16],16'h0000};
                else
                    outc_tmp = accumc_se;
                outa_tmp = dataa_se;
                outb_tmp = datab_se;
                outd_tmp = datad_se;
            end
        default :
            begin
                outa_tmp = dataa_se;
                outb_tmp = datab_se;
                outc_tmp = datac_se;
                outd_tmp = datad_se;
            end
        endcase

//  MULTABSATURATE
        if(multabsaturate)
            begin
                if(outa_tmp[0] == 1'b1 && ((zeroacc && operation[2]) || ~operation[2]))
                    begin
                        sata_tmp = 1'b1;
                        outa_tmp[0] = 1'b0;
                    end
                else
                    sata_tmp = 1'b0;

                if(outb_tmp[0] == 1'b1)
                    begin
                        satb_tmp = 1'b1;
                        outb_tmp[0] = 1'b0;
                    end
                else
                    satb_tmp = 1'b0;
            end
        else
            begin
                sata_tmp = 1'b0;
                satb_tmp = 1'b0;
            end

         // MULTCDSATURATE
        if(multcdsaturate)
            begin
                if(outc_tmp[0] == 1'b1 && ((zeroacc1 && operation[2]) || ~operation[2]))
                    begin
                        satc_tmp = 1'b1;
                        outc_tmp[0] = 1'b0;
                    end
                else
                    satc_tmp = 1'b0;

                if(outd_tmp[0] == 1'b1)
                    begin
                        satd_tmp = 1'b1;
                        outd_tmp[0] = 1'b0;
                    end
                else
                    satd_tmp = 1'b0;
            end
        else
            begin
                satc_tmp = 1'b0;
                satd_tmp = 1'b0;
            end

         // SATURATE (A || B)
            if(sata_tmp || satb_tmp)
                satab_tmp = 1'b1;
            else
                satab_tmp = 1'b0;
//          SATURATE (C || D)
            if(satc_tmp || satd_tmp)
                satcd_tmp = 1'b1;
            else
                satcd_tmp = 1'b0;
    end
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                         stratixii_MAC_OUT_ADD_SUB_ACC_UNIT
//
///////////////////////////////////////////////////////////////////////////////
module stratixii_mac_out_add_sub_acc_unit(
                                          dataa,
                                          datab,
                                          datac,
                                          datad,
                                          signa,
                                          signb,
                                          operation,
                                          addnsub,
                                          dataout,
                                          overflow
                                          );
//PARAMETERS
parameter    dataa_width = 36;
parameter    datab_width = 36;
parameter    datac_width = 36;
parameter    datad_width = 36;
parameter   accuma_width = datab_width + 16;
parameter   accumc_width = datad_width + 16;
parameter   block_type  = "R";

// INPUT PORTS
input [71 : 0 ]  dataa;
input [71 : 0 ]datab;
input [71 :0]  datac;
input [71:0]datad;
input signa;
input signb;
input [3:0]      operation;
input    addnsub;

// OUTPUT PORTS
output [71 :0] dataout;
output   overflow;

//INTERNAL SIGNALS
reg[71:0] dataout_tmp;
reg overflow_tmp;
reg sign_a;
reg sign_b;
reg [71 :0] abs_a;
reg [71 :0 ] abs_b;

reg [71:0] datac_s;
reg [71:0] datad_s;


//assign the output values
assign dataout = dataout_tmp;
assign overflow = overflow_tmp;

always @(dataa or datab or datac or datad or signa or signb or operation or addnsub)
    begin
   //36 bit multiply
        if(operation == 4'b0111)
            begin
                datac_s = signa ? {{(18){datac[35]}}, datac[35:0]} : {{18'b0, datac[35:0]}};
                datad_s = signb ? {{(18){datad[35]}}, datad[35:0]} : {{18'b0, datad[35:0]}};
                dataout_tmp = ({datab[35:0],36'b0}) + ({datac_s,18'b0}) + ({datad_s,18'b0}) + ({36'b0,dataa[35:0]});
                overflow_tmp = 1'b0;
            end
     // Accumulator, Block R
        else if ((block_type == "R") &&(operation[2]))
            begin
                sign_a  = (signa && dataa[accuma_width -1]);
                abs_a = (sign_a) ? (~dataa[accuma_width -1 :0] + 1'b1) : dataa[accuma_width -1 :0];
                sign_b  = (signb && datab[datab_width-1]);
                abs_b = (sign_b) ? (~datab[datab_width -1 :0] + 1'b1) : datab[datab_width -1 :0];
                if (addnsub == 1'b0)
                    dataout_tmp = (sign_a ? -abs_a[accuma_width -1 :0] : abs_a[accuma_width -1 :0]) - (sign_b ? -abs_b[datab_width -1 :0] : abs_b[datab_width -1 :0]);
                else
                    dataout_tmp = (sign_a ? -abs_a[accuma_width -1 :0] : abs_a[accuma_width -1 :0]) + (sign_b ? -abs_b[datab_width -1 :0] : abs_b[datab_width -1 :0]);
                if(signa || signb)
                   overflow_tmp = dataout_tmp[accuma_width] ^ dataout_tmp[accuma_width -1];
                else
                   overflow_tmp = dataout_tmp[accuma_width];
            end
       //ACCUMULATOR, Block S
        else if ((block_type == "S") &&(operation[2]))
            begin
                sign_a  = (signa && datac[accumc_width -1]);
                abs_a = (sign_a) ? (~datac[accumc_width -1 :0] + 1'b1) : datac[accumc_width -1 :0];
                sign_b  = (signb && datad[datad_width-1]);
                abs_b = (sign_b) ? (~datad[datad_width -1 :0] + 1'b1) : datad[datad_width -1 :0];

                if (addnsub == 1'b0)
                    dataout_tmp = (sign_a ? -abs_a[accumc_width -1 :0] : abs_a[accumc_width -1 :0]) - (sign_b ? -abs_b[datad_width -1 :0] : abs_b[datad_width -1 :0]);
                else
                    dataout_tmp = (sign_a ? -abs_a[accumc_width -1 :0] : abs_a[accumc_width -1 :0]) + (sign_b ? -abs_b[datad_width -1 :0] : abs_b[datad_width -1 :0]);
                if(signa || signb)
                    overflow_tmp = dataout_tmp[accumc_width] ^ dataout_tmp[accumc_width -1];
                else
                    overflow_tmp = dataout_tmp[accumc_width];
            end
     // Two level adder
        else if(block_type == "T")
            begin
                sign_a  = ( signa && dataa[dataa_width]);
                sign_b  = ( signb && datab[datab_width]);
                abs_a = ( sign_a ) ? (~dataa[dataa_width:0] + 1'b1) : dataa[dataa_width:0];
                abs_b = ( sign_b ) ? (~datab[datab_width:0] + 1'b1) : datab[datab_width:0];
                if (addnsub == 1'b0)
                    dataout_tmp = (sign_a ? -abs_a[dataa_width:0]: abs_a[dataa_width:0]) - (sign_b ? -abs_b[datab_width:0] : abs_b[datab_width:0]);
                else
                    dataout_tmp = (sign_a ? -abs_a[dataa_width:0]: abs_a[dataa_width:0]) + (sign_b ? -abs_b[datab_width:0] : abs_b[datab_width:0]);
                overflow_tmp = 1'b0;
            end
     //One level Adder S block
        else if (block_type == "S")
            begin
                sign_a  = (signa && datac[datac_width -1]);
                abs_a = (sign_a) ? (~datac[datac_width -1:0]+ 1'b1) : datac[datac_width -1:0];
                sign_b  = (signb && datad[datad_width-1]);
                abs_b = (sign_b) ? (~datad[datad_width -1:0] + 1'b1) : datad[datad_width -1:0];

                if (addnsub == 1'b0)
                    dataout_tmp = (sign_a ? -abs_a[datac_width -1:0] : abs_a[datac_width -1:0]) - (sign_b ? -abs_b[datad_width -1:0] : abs_b[datad_width -1:0]);
                else
                    dataout_tmp = (sign_a ? -abs_a[datac_width -1:0] : abs_a[datac_width -1:0]) + (sign_b ? -abs_b[datad_width -1:0] : abs_b[datad_width -1:0]);
                if(signa || signb)
                    overflow_tmp = dataout_tmp[datac_width + 1] ^ dataout_tmp[datac_width];
                else
                    overflow_tmp = dataout_tmp[datac_width + 1];
            end
      //One level Adder R block. Default
        else
            begin
                sign_a  = (signa && dataa[dataa_width -1]);
                abs_a = (sign_a) ? (~dataa[dataa_width -1:0]+ 1'b1) : dataa[dataa_width -1:0];
                sign_b  = (signb && datab[datab_width-1]);
                abs_b = (sign_b) ? (~datab[datab_width -1:0] + 1'b1) : datab[datab_width -1:0];

                if (addnsub == 1'b0)
                    dataout_tmp = (sign_a ? -abs_a[dataa_width -1:0] : abs_a[dataa_width -1:0]) - (sign_b ? -abs_b[datab_width -1:0] : abs_b[datab_width -1:0]);
                else
                    dataout_tmp = (sign_a ? -abs_a[dataa_width -1:0] : abs_a[dataa_width -1:0]) + (sign_b ? -abs_b[datab_width -1:0] : abs_b[datab_width -1:0]);
                if(signa || signb)
                    overflow_tmp = dataout_tmp[dataa_width + 1] ^ dataout_tmp[dataa_width];
                else
                    overflow_tmp = dataout_tmp[dataa_width + 1];
            end
    end
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                         stratixii_MAC_OUT_Output_Interface
//
///////////////////////////////////////////////////////////////////////////////

  module stratixii_mac_out_output_interface(
                                             dataa,
                                             datab,
                                             datac,
                                             datad,
                                             datar,
                                             datas,
                                             datat,
                                             data_36_mult,
                                             sata,
                                             satb,
                                             satc,
                                             satd,
                                             satab,
                                             satcd,
                                             satr,
                                             sats,
                                             multabsaturate,
                                             multcdsaturate,
                                             saturate0,
                                             saturate1,
                                             overflowr,
                                             overflows,
                                             operation,
                                             dataout,
                                             accoverflow
                                           );

// INPUT PORTS
input [35:0] dataa;
input [35:0] datab;
input [35:0] datac;
input [35:0] datad;
input [71:0] datar;
input [71:0] datas;
input [71:0] datat;
input [71:0] data_36_mult;
input   sata;
input   satb;
input   satc;
input   satd;
input   satab;
input   satcd;
input   satr;
input   sats;
input   multabsaturate;
input   multcdsaturate;
input   saturate0;
input   saturate1;
input   overflowr;
input   overflows;
input [3:0]      operation;

// OUTPUT PORTS
output [143:0] dataout;
output    accoverflow;

//INTERNAL SIGNALS
reg [143:0]       dataout_tmp;
reg           accoverflow_tmp;

always @( dataa or datab or datac or datad or  data_36_mult or datar or datas or datat or
          sata or satb or satc or satd or satab or satcd or satr or sats or multabsaturate or
          multcdsaturate or saturate0 or saturate1 or overflowr or overflows or operation)
    begin
        case (operation)
           //Output Only
        4'b0000 :
            begin
                dataout_tmp = {datad,datac,datab,dataa};
                accoverflow_tmp = 1'b0;
            end
          //Accumulator
        4'b0100 :
            begin
                case ({saturate0, multabsaturate})
                    2'b00 :dataout_tmp ={datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:0]};
                    2'b01 :dataout_tmp = {datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:2], satab, datar[0]};
                    2'b10 :dataout_tmp = {datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:3], satr, datar[1:0]};
                    2'b11 : dataout_tmp =  {datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:3], satr, satab, datar[0]};
                    default : dataout_tmp =  {datad,datac, datar[71:53], overflowr, datar[51:36], datar[35:0]};
                endcase
                accoverflow_tmp = overflowr;
            end
        // ONE LEVEL ADDER
        4'b0001 :
            begin
                if (multabsaturate)
                    dataout_tmp = {datad,datac, datar[71:2], satb, sata};
                else
                    dataout_tmp = {datad,datac, datar[71:0]};
                accoverflow_tmp = 1'b0;
           end
        // TWO LEVEL ADDER
        4'b0010 :
            begin
                case ({satcd, satab})
                    2'b00 :
                        begin
                            dataout_tmp = {datad,datac, datat[71:0]};
                            accoverflow_tmp = 1'b0;
                        end
                    2'b01 :
                        begin
                            dataout_tmp = {datad,datac, datat[71:2], satb, sata};
                            accoverflow_tmp = 1'b0;
                        end
                    2'b10 :
                        begin
                            dataout_tmp = {datad,datac, datat[71:3], satc, datat[1:0]};
                            accoverflow_tmp = satd;
                        end
                    2'b11 :
                        begin
                            dataout_tmp = {datad,datac, datat[71:3], satc, satb, sata};
                            accoverflow_tmp = satd;
                        end
                    default :
                        begin
                            dataout_tmp = {datad,datac, datat[71:0]};
                            accoverflow_tmp = 1'b0;
                        end
                endcase
            end
        // 36-BIT MULTIPLY
        4'b0111 :
            begin
                dataout_tmp = {datad,datac,data_36_mult};
                accoverflow_tmp = 1'b0;
            end
        // TWO ACCUMULATORS
        4'b1100 :
            begin
                case ({saturate1, saturate0, satcd, satab})
                    4'b0000 : dataout_tmp = {datas[71:53], overflows, datas[51:0],datar[71:53], overflowr, datar[51:0]};
                    4'b0001 : dataout_tmp = {datas[71:53], overflows, datas[51:0], datar[71:53], overflowr, datar[51:2], satab, datar[0]};
                    4'b0010 : dataout_tmp = {datas[71:53], overflows, datas[51:2], satcd, datas[0],datar[71:53], overflowr, datar[51:0]};
                    4'b0011 : dataout_tmp = {datas[71:53], overflows, datas[51:2], satcd, datas[0],datar[71:53], overflowr, datar[51:2], satab, datar[0]};
                    4'b0100 :dataout_tmp = {datas[71:53], overflows, datas[51:0], datar[71:53], overflowr, datar[51:3], satr, datar[1:0]};
                    4'b0101 :dataout_tmp = {datas[71:53], overflows, datas[51:0], datar[71:53], overflowr, datar[51:3], satr, satab, datar[0]};
                    4'b0110 :dataout_tmp = {datas[71:53], overflows, datas[51:2], satcd, datas[0],datar[71:53], overflowr, datar[51:3], satr, datar[1:0]};
                    4'b0111 :dataout_tmp = {datas[71:53], overflows, datas[51:2], satcd, datas[0],datar[71:53], overflowr, datar[51:3], satr, satab, datar[0]};
                    4'b1000 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, datas[1:0], datar[71:53], overflowr, datar[51:0]};
                    4'b1001 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, datas[1:0], datar[71:53], overflowr, datar[51:2], satab, datar[0]};
                    4'b1010 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, satcd, datas[0],datar[71:53], overflowr, datar[51:0]};
                    4'b1011 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, satcd, datas[0],datar[71:53], overflowr, datar[51:2], satab, datar[0]};
                    4'b1100 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, datas[1:0], datar[71:53], overflowr, datar[51:3], satr, datar[1:0]};
                    4'b1101 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, datas[1:0], datar[71:53], overflowr, datar[51:3], satr, satab, datar[0]};
                    4'b1110 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, satcd, datas[0],datar[71:53], overflowr, datar[51:3], satr, datar[1:0]};
                    4'b1111 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, satcd, datas[0],datar[71:53], overflowr, datar[51:3], satr, satab, datar[0]};
                    default :dataout_tmp = {datas[71:53], overflows, datas[51:0],datar[71:53], overflowr, datar[51:0]};
                endcase
                accoverflow_tmp = overflowr;
            end
        // OUTPUT ONLY / ACCUMULATOR
        4'b1101 :
            begin
                case ({saturate0, multabsaturate})
                    2'b00 :dataout_tmp ={datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:0]};
                    2'b01 :dataout_tmp = {datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:2], satab, datar[0]};
                    2'b10 :dataout_tmp = {datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:3], satr, datar[1:0]};
                    2'b11 : dataout_tmp =  {datad,datac, datar[71:53], overflowr,datar[51:36], datar[35:3], satr, satab, datar[0]};
                    default : dataout_tmp =  {datad,datac, datar[71:53], overflowr, datar[51:36], datar[35:0]};
                endcase
                accoverflow_tmp = overflowr;
            end
      // ACCUMULATOR / OUTPUT ONLY
        4'b1110 :
            begin
                case ({saturate1, multcdsaturate})
                    2'b00 :dataout_tmp = {datas[71:53], overflows, datas[51:0],datab,dataa};
                    2'b01 : dataout_tmp = {datas[71:53], overflows, datas[51:2], satcd, datas[0],datab,dataa};
                    2'b10 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, datas[1:0],datab,dataa};
                    2'b11 :dataout_tmp = {datas[71:53], overflows, datas[51:3], sats, satcd, datas[0],datab,dataa};
                    default :dataout_tmp = {datas[71:53], overflows, datas[51:0],datab,dataa};
                endcase
                accoverflow_tmp = overflows;
            end
        default :
            begin
                dataout_tmp = {datad,datac,datab,dataa};
                accoverflow_tmp = 1'b0;
            end
        endcase
    end

   assign dataout = dataout_tmp;
   assign accoverflow = accoverflow_tmp;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                          stratixii_Reooder_Output
//
///////////////////////////////////////////////////////////////////////////////


`timescale 1 ps/1 ps

  module stratixii_reorder_output(
                                  datain,
                                  addnsub,
                                  operation,
                                  dataout
                                 );

//PARAMETERS
parameter  operation_mode = "dynamic";

//INPUT PORTS
input [143:0] datain;
input [3:0]      operation;
input  addnsub;

//OUTPUT PORTS
output [143:0] dataout;

//INTERNAL SIGNALS
reg [143:0]       dataout_tmp;
wire [3:0]    operation;

//Output Assignment
assign dataout = dataout_tmp;

always @ (datain or addnsub)
    begin
        if(operation_mode == "dynamic")
            begin
                case (operation)
                    4'b1100 : // TWO ACCUMULATORS
                        dataout_tmp = {18'bX, datain[124:108],1'bX, datain[107:72],18'bX, datain[52:36], 1'bX, datain[35:0]};
                    4'b1101 : // OUTPUT ONLY / ACCUMULATOR
                        dataout_tmp = {datain[143:72], 18'bX, datain[52:36], 1'bX, datain[35:0]};
                    4'b1110 :// ACCUMULATOR / OUTPUT ONLY
                        dataout_tmp = {18'bX, datain[124:108], 1'bX, datain[107:0]};
                    4'b0111 :
                        begin // 36 BIT MULTIPLY
                            dataout_tmp[17:0] = (addnsub) ? datain[17:0] : 18'bX;
                            dataout_tmp[35:18] = (addnsub) ? datain[53:36] : 18'bX;
                            dataout_tmp[53:36] = (addnsub) ? datain[35:18] : 18'bX;
                            dataout_tmp[71:54] = (addnsub) ? datain[71:54] : 18'bX;
                            dataout_tmp[143:72] = 72'bX;
                        end
                    default :
                         dataout_tmp = datain;
                endcase
            end
       else
           dataout_tmp = datain;
    end
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                          stratixii_MAC_OUT_Internal_Logic
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

  module stratixii_mac_out_internal (
                                      dataa,
                                      datab,
                                      datac,
                                      datad,
                                      mode0, 
                                      mode1, 
                                      roundab,
                                      saturateab,
                                      roundcd,
                                      saturatecd,
                                      multabsaturate,
                                      multcdsaturate,
                                      signa,
                                      signb,
                                      addnsub0,
                                      addnsub1,
                                      zeroacc,
                                      zeroacc1,
                                      feedback,
                                      dataout,
                                      accoverflow
                                   );

  //Parameter Declaration
parameter operation_mode = "output_only";
parameter dataa_width = 36;
parameter datab_width = 36;
parameter datac_width = 36;
parameter datad_width = 36;



//Input Ports
input [35:0] dataa;
input [35:0] datab;
input [35:0] datac;
input [35:0] datad;
input   mode0; 
input   mode1; 
input   roundab;
input   roundcd;
input   saturateab;
input   saturatecd;
input   multabsaturate;
input   multcdsaturate;
input   signa;
input   signb;
input   addnsub0;
input   addnsub1;
input   zeroacc;
input   zeroacc1; 
input [143:0] feedback;


//Output Ports
output [143:0] dataout;
output   accoverflow;

//Internal Signal Declaration
wire [143:0]  dataout_tmp;
wire     accoverflow_tmp;
wire [5:0] sign_size;

//Define the signals for instantiating the input interface block(iib)
wire[51:0] iib_accuma;
wire[51:0] iib_accumc;
wire[71:0] iib_dataa;
wire[71:0] iib_datab;
wire[71:0] iib_datac;
wire[71:0] iib_datad;
wire iib_sata;
wire iib_satb;
wire iib_satc;
wire iib_satd;
wire iib_satab;
wire iib_satcd;
wire[71:0] iib_outa;
wire[71:0] iib_outb;
wire[71:0] iib_outc;
wire[71:0] iib_outd;


//Define the signals for the R add_sub_acc block(rb)
wire rb_signa;
wire rb_signb;
wire [71:0] rb_dataout;
wire rb_overflow;

//Define the signals for the round_saturate R block(rs_rb)
wire [7:0] rs_rb_dataout_size;
wire [71:0] rs_rb_dataout;
wire rs_rb_saturate_overflow;

//Define the signals for the S add_sub_acc block(sb)
wire [71:0] sb_dataout;
wire sb_overflow;

 //Define the signals for the round_saturate S block(rs_sb)
wire [7:0] rs_sb_dataout_size;
wire [71:0] rs_sb_dataout;
wire rs_sb_saturate_overflow;

//Define the signals for the t add_sub_acc block(tb)
wire tb_signa;
wire tb_signb;
wire [71:0] tb_dataout;
wire tb_overflow;

  //Define signals for instantiating the output interface block
wire [143:0] oib_dataout;
wire [35:0] oib_dataa;
wire [35:0] oib_datab;
wire [35:0] oib_datac;
wire [35:0] oib_datad;

//Define signals for instantiating the reorder output block
wire ro_addnsub;
wire [3:0] operation;
wire signab;



wire [35:0] dataa_ipd;
wire [35:0] datab_ipd;
wire [35:0] datac_ipd;
wire [35:0] datad_ipd;
wire  [143:0] feedback_ipd;

buf buf_dataa [35:0] (dataa_ipd,dataa);
buf buf_datab [35:0] (datab_ipd,datab);
buf buf_datac [35:0] (datac_ipd,datac);
buf buf_datad [35:0] (datad_ipd,datad);
buf buf_feedback  [143:0] (feedback_ipd,feedback);
wire  [143:0] dataout_opd;
wire accoverflow_opd;

buf buf_dataout  [143:0] (dataout,dataout_opd);
buf buf_accoverflow (accoverflow,accoverflow_opd);

 // TIMING SPECIFICATION
specify
    (dataa          *> dataout) = (0,0);
    (datab          *> dataout) = (0,0);
    (datac          *> dataout) = (0,0);
    (datad          *> dataout) = (0,0);
    (signa          *> dataout) = (0,0);
    (signb          *> dataout) = (0,0);
    (mode0          *> dataout) = (0,0); 
    (mode1          *> dataout) = (0,0); 
    (addnsub0       *> dataout) = (0,0);
    (addnsub1       *> dataout) = (0,0);
    (zeroacc        *> dataout) = (0,0);
    (zeroacc1       *> dataout) = (0,0); 
    (multabsaturate *> dataout) = (0,0);
    (multcdsaturate *> dataout) = (0,0);
    (feedback       *> dataout) = (0,0);
    (dataa          *> accoverflow) = (0,0);
    (datab          *> accoverflow) = (0,0);
    (datac          *> accoverflow) = (0,0);
    (datad          *> accoverflow) = (0,0);
    (signa          *> accoverflow) = (0,0);
    (signb          *> accoverflow) = (0,0);
    (mode0          *> accoverflow) = (0,0); 
    (mode1          *> accoverflow) = (0,0); 
    (addnsub0       *> accoverflow) = (0,0);
    (addnsub1       *> accoverflow) = (0,0);
    (zeroacc        *> accoverflow) = (0,0);
    (zeroacc1       *> accoverflow) = (0,0); 
    (feedback       *> accoverflow) = (0,0);
endspecify

//Decode the operation value depending on the operation mode


assign   operation = (operation_mode == "output_only") ? 4'b0000 :
                     (operation_mode == "one_level_adder") ? 4'b0001 :
                     (operation_mode == "two_level_adder") ? 4'b0010 :
                     (operation_mode == "accumulator") ? 4'b0100 :
                     (operation_mode == "36_bit_multiply") ? 4'b0111 :
                     ((operation_mode == "dynamic") && (mode0== 1'b0) && (mode1== 1'b0) &&(zeroacc == 1'b0) && (zeroacc1== 1'b0)) ? 4'b0000 :
                     ((operation_mode == "dynamic") &&(mode0 == 1'b1) && (mode1 == 1'b1)) ? 4'b1100 :
                     ((operation_mode == "dynamic") &&(mode0 == 1'b1) && (mode1 == 1'b0)) ? 4'b1101 :
                     ((operation_mode == "dynamic") &&(mode0 == 1'b0) && (mode1 == 1'b1)) ? 4'b1110 :
                     ((operation_mode == "dynamic") &&(mode0 == 1'b0) && (mode1 == 1'b0) && (zeroacc == 1'b1) && (zeroacc1 == 1'b1)) ? 4'b0111 : 4'b0000;

 //Assign the sign size depending on the mode of operation
     assign sign_size =((operation[2] == 1'b1) ? 18 :
                      (operation == 4'b0001) ||(operation == 4'b0010) ? 3 : 2);

   //Instantiate stratixii_Input_Interface
stratixii_mac_out_input_interface input_interface(
                                                  .accuma(iib_accuma),
                                                  .accumc(iib_accumc),
                                                  .dataa(iib_dataa),
                                                  .datab(iib_datab),
                                                  .datac(iib_datac),
                                                  .datad(iib_datad),
                                                  .sign(signab),
                                                  .multabsaturate(multabsaturate),
                                                  .multcdsaturate(multcdsaturate),
                                                  .zeroacc(zeroacc),
                                                  .zeroacc1(zeroacc1), 
                                                  .operation(operation),
                                                  .outa(iib_outa),
                                                  .outb(iib_outb),
                                                  .outc(iib_outc),
                                                  .outd(iib_outd),
                                                  .sata(iib_sata),
                                                  .satb(iib_satb),
                                                  .satc(iib_satc),
                                                  .satd(iib_satd),
                                                  .satab(iib_satab),
                                                  .satcd(iib_satcd)
                                                 );
defparam input_interface.dataa_width = dataa_width;
defparam input_interface.datab_width = datab_width;
defparam input_interface.datac_width = datac_width;
defparam input_interface.datad_width = datad_width;

assign signab = signa || signb;
assign iib_accuma = (operation_mode == "dynamic") ? {feedback_ipd[52:37], feedback_ipd[35:0]} : feedback_ipd[51:0];
assign iib_accumc = (operation_mode == "dynamic") ? {feedback_ipd[124:109], feedback_ipd[107:72]} :feedback_ipd[123:72];
assign iib_dataa = {36'b0, dataa_ipd};
assign iib_datab = {36'b0, datab_ipd};
assign iib_datac = {36'b0, datac_ipd};
assign iib_datad = {36'b0, datad_ipd};


//Instantiate the Add_Sub_Acc Block R (upper half of operations)
stratixii_mac_out_add_sub_acc_unit block_r(
                                           .dataa(iib_outa),
                                           .datab(iib_outb),
                                           .datac(iib_outc),
                                           .datad(iib_outd),
                                           .signa(rb_signa),
                                           .signb(rb_signb),
                                           .operation(operation),
                                           .addnsub(addnsub0),
                                           .dataout(rb_dataout),
                                           .overflow(rb_overflow)
                                          );
defparam     block_r.dataa_width = dataa_width;
defparam     block_r.datab_width = datab_width;
defparam     block_r.datac_width = datac_width;
defparam     block_r.datad_width = datad_width;
defparam   block_r.block_type  = "R";


assign   rb_signa =(operation_mode == "36_bit_multiply") ? signa :
                   ((operation_mode == "dynamic") &&(mode0 == 1'b0) && (mode1 == 1'b0) && (zeroacc == 1'b1) && (zeroacc1 == 1'b1)) ? signa : signab;

assign   rb_signb =(operation_mode == "36_bit_multiply") ? signb :
                   ((operation_mode == "dynamic") &&(mode0 == 1'b0) && (mode1 == 1'b0) && (zeroacc == 1'b1) && (zeroacc1 == 1'b1)) ? signb : signab;


   //Instantiate the Add_Sub_Acc Block S (sb--lower half of operations)
stratixii_mac_out_add_sub_acc_unit block_s(
                                           .dataa(iib_outa),
                                           .datab(iib_outb),
                                           .datac(iib_outc),
                                           .datad(iib_outd),
                                           .signa(signab),
                                           .signb(signab),
                                           .operation(operation),
                                           .addnsub(addnsub1),
                                           .dataout(sb_dataout),
                                           .overflow(sb_overflow)
                                         );

defparam     block_s.dataa_width = dataa_width;
defparam     block_s.datab_width = datab_width;
defparam     block_s.datac_width = datac_width;
defparam     block_s.datad_width = datad_width;
defparam   block_s.block_type  = "S";

  //Instantiate Round_Saturate block for the R block
 stratixii_mac_rs_block mac_rs_rb(
                                  .operation(operation),
                                  .round(roundab),
                                  .saturate(saturateab),
                                  .addnsub(addnsub0),
                                  .signa(signab),
                                  .signb(signab),
                                  .signsize(sign_size),
                                  .roundsize(8'hf),
                                  .dataoutsize(rs_rb_dataout_size),
                                  .dataa(iib_outa),
                                  .datab(iib_outb),
                                  .datain(rb_dataout),
                                  .dataout(rs_rb_dataout)
                                );
defparam mac_rs_rb.block_type    = "R";
defparam mac_rs_rb.dataa_width   = dataa_width;
defparam mac_rs_rb.datab_width   = datab_width;

assign   rs_rb_dataout_size = ((operation[2] == 1'b1) ? (datab_width + 16) :
                (operation == 4'b0001) ? (dataa_width + 1) :
                (operation == 4'b0010) ? (dataa_width + 1) : 36);

//Instantiate Round_Saturate block for the S block
stratixii_mac_rs_block mac_rs_sb(
                                 .operation(operation),
                                 .round(roundcd),
                                 .saturate(saturatecd),
                                 .addnsub(addnsub1),
                                 .signa(signab),
                                 .signb(signab),
                                 .signsize(sign_size),
                                 .roundsize(8'hf),
                                 .dataoutsize(rs_sb_dataout_size),
                                 .dataa(iib_outc),
                                 .datab(iib_outd),
                                 .datain(sb_dataout),
                                 .dataout(rs_sb_dataout)
                                );
defparam mac_rs_sb.block_type    = "S";
defparam mac_rs_sb.dataa_width   = datac_width;
defparam mac_rs_sb.datab_width   = datad_width;

assign   rs_sb_dataout_size = ((operation[2] == 1'b1) ? (datad_width + 16) :
                (operation == 4'b0001) ? (datac_width + 1) :
                (operation == 4'b0010) ? (datac_width + 1) : 36);

   //Instantiate the second level adder T(tb--t block)
stratixii_mac_out_add_sub_acc_unit block_t(
                                            .dataa(rs_rb_dataout),
                                            .datab(rs_sb_dataout),
                                            .datac(iib_outc),
                                            .datad(iib_outd),
                                            .signa(tb_signa),
                                            .signb(tb_signb),
                                            .operation(operation),
                                            .addnsub(1'b1),
                                            .dataout(tb_dataout),
                                            .overflow(tb_overflow)
                                           );

defparam     block_t.dataa_width = dataa_width;
defparam     block_t.datab_width = datab_width;
defparam     block_t.datac_width = datac_width;
defparam     block_t.datad_width = datad_width;
defparam   block_t.block_type  = "T";


assign   tb_signa = signab || ~addnsub0;
assign   tb_signb = signab || ~addnsub1;

   //Instantiate the oputput interface block
stratixii_mac_out_output_interface output_interface(
                                                    .dataa(oib_dataa),
                                                    .datab(oib_datab),
                                                    .datac(oib_datac),
                                                    .datad(oib_datad),
                                                    .datar(rs_rb_dataout),
                                                    .datas(rs_sb_dataout),
                                                    .datat(tb_dataout),
                                                    .data_36_mult(rb_dataout),
                                                    .sata(iib_sata),
                                                    .satb(iib_satb),
                                                    .satc(iib_satc),
                                                    .satd(iib_satd),
                                                    .satab(iib_satab),
                                                    .satcd(iib_satcd),
                                                    .satr(rs_rb_dataout[2]),
                                                    .sats(rs_sb_dataout[2]),
                                                    .multabsaturate(multabsaturate),
                                                    .multcdsaturate(multcdsaturate),
                                                    .saturate0(saturateab),
                                                    .saturate1(saturatecd),
                                                    .overflowr(rb_overflow),
                                                    .overflows(sb_overflow),
                                                    .operation(operation),
                                                    .dataout(oib_dataout),
                                                    .accoverflow(accoverflow_tmp)
                                                   );

assign oib_dataa = dataa_ipd;
assign oib_datab = datab_ipd;
assign oib_datac = datac_ipd;
assign oib_datad = datad_ipd;

   //Instantiate the reorder block
stratixii_reorder_output reorder_unit(
                                      .datain(oib_dataout),
                                      .addnsub(ro_addnsub),
                                      .operation(operation),
                                      .dataout(dataout_tmp)
                                     );

defparam  reorder_unit.operation_mode = operation_mode;
assign ro_addnsub = addnsub0 && addnsub1;

assign accoverflow_opd = accoverflow_tmp;
assign dataout_opd = dataout_tmp;

endmodule

   ///////////////////////////////////////////////////////////////////////////////
   //
   //                            stratixii_MAC_OUT
   //
   ///////////////////////////////////////////////////////////////////////////////

  `timescale 1 ps/1 ps

module stratixii_mac_out(
                          dataa,
                          datab,
                          datac,
                          datad,
                          zeroacc,
                          addnsub0,
                          addnsub1,
                          round0,
                          round1,
                          saturate,
                          multabsaturate,
                          multcdsaturate,
                          signa,
                          signb,
                          clk,
                          aclr,
                          ena,
                          mode0,  
                          mode1,  
                          zeroacc1,  
                          saturate1,
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
parameter dataout_width = 144;
parameter addnsub0_clock = "none";
parameter addnsub1_clock = "none";
parameter zeroacc_clock = "none";
parameter round0_clock= "none";
parameter round1_clock= "none";
parameter saturate_clock = "none";
parameter multabsaturate_clock = "none";
parameter multcdsaturate_clock = "none";
parameter signa_clock = "none";
parameter signb_clock = "none";
parameter output_clock = "none";
parameter addnsub0_clear = "none";
parameter addnsub1_clear = "none";
parameter zeroacc_clear = "none";
parameter round0_clear = "none";
parameter round1_clear = "none";
parameter saturate_clear = "none";
parameter multabsaturate_clear = "none";
parameter multcdsaturate_clear = "none";
parameter signa_clear = "none";
parameter signb_clear = "none";
parameter output_clear = "none";
parameter addnsub0_pipeline_clock = "none";
parameter addnsub1_pipeline_clock = "none";
parameter round0_pipeline_clock  = "none";
parameter round1_pipeline_clock  = "none";
parameter saturate_pipeline_clock= "none";
parameter multabsaturate_pipeline_clock = "none";
parameter multcdsaturate_pipeline_clock = "none";
parameter zeroacc_pipeline_clock = "none";
parameter signa_pipeline_clock = "none";
parameter signb_pipeline_clock = "none";
parameter addnsub0_pipeline_clear = "none";
parameter addnsub1_pipeline_clear = "none";
parameter round0_pipeline_clear  = "none";
parameter round1_pipeline_clear  = "none";
parameter saturate_pipeline_clear= "none";
parameter multabsaturate_pipeline_clear = "none";
parameter multcdsaturate_pipeline_clear = "none";
parameter zeroacc_pipeline_clear = "none";
parameter signa_pipeline_clear = "none";
parameter signb_pipeline_clear = "none";
parameter mode0_clock = "none";                     
parameter mode1_clock = "none";                     
parameter zeroacc1_clock = "none";                  
parameter saturate1_clock= "none";                  
parameter output1_clock  = "none";                  
parameter output2_clock  = "none";                  
parameter output3_clock  = "none";                  
parameter output4_clock  = "none";                  
parameter output5_clock  = "none";                  
parameter output6_clock  = "none";                  
parameter output7_clock  = "none";                  
parameter mode0_clear = "none";                     
parameter mode1_clear = "none";                     
parameter zeroacc1_clear = "none";                  
parameter saturate1_clear= "none";                  
parameter output1_clear  = "none";                  
parameter output2_clear  = "none";                  
parameter output3_clear  = "none";                  
parameter output4_clear  = "none";                  
parameter output5_clear  = "none";                  
parameter output6_clear  = "none";                  
parameter output7_clear  = "none";                  
parameter mode0_pipeline_clock  = "none";           
parameter mode1_pipeline_clock  = "none";           
parameter zeroacc1_pipeline_clock  = "none";        
parameter saturate1_pipeline_clock = "none";        
parameter mode0_pipeline_clear  = "none";           
parameter mode1_pipeline_clear  = "none";           
parameter zeroacc1_pipeline_clear  = "none";        
parameter saturate1_pipeline_clear = "none";        
parameter dataa_forced_to_zero= "no";               
parameter datac_forced_to_zero= "no";               
parameter lpm_hint  = "true";
parameter lpm_type  = "stratixii_mac_out";

input [dataa_width-1:0] dataa;
input [datab_width-1:0] datab;
input [datac_width-1:0] datac;
input [datad_width-1:0] datad;
input   zeroacc;
input   addnsub0;
input   addnsub1;
input   round0;
input   round1;
input   saturate;
input   saturate1;
input   mode0;  
input   mode1;  
input   zeroacc1; 


input   multabsaturate;
input   multcdsaturate;
input   signa;
input   signb;
input [3:0]     clk;
input [3:0]     aclr;
input [3:0]     ena;
input   devclrn;
input   devpor;

output [dataout_width-1:0] dataout;
output   accoverflow;

tri1 devclrn;
tri1 devpor;

    //Internal signals to instantiate the signa input register unit
wire [3:0] signa_inreg_clk_value;
wire [3:0] signa_inreg_aclr_value;
wire signa_inreg_clk;
wire signa_inreg_aclr;
wire signa_inreg_ena;
wire signa_inreg_bypass_register;
wire  signa_inreg_pipreg;


    //Internal signals to instantiate the signa pipeline register unit
wire [3:0] signa_pipreg_clk_value;
wire [3:0] signa_pipreg_aclr_value;
wire signa_pipreg_clk;
wire signa_pipreg_aclr;
wire signa_pipreg_ena;
wire signa_pipreg_bypass_register;
wire  signa_pipreg_out;

    //Internal signals to instantiate the signb input register unit
wire [3:0] signb_inreg_clk_value;
wire [3:0] signb_inreg_aclr_value;
wire signb_inreg_clk;
wire signb_inreg_aclr;
wire signb_inreg_ena;
wire signb_inreg_bypass_register;
wire  signb_inreg_pipreg;


    //Internal signals to instantiate the signb pipeline register unit
wire [3:0] signb_pipreg_clk_value;
wire [3:0] signb_pipreg_aclr_value;
wire signb_pipreg_clk;
wire signb_pipreg_aclr;
wire signb_pipreg_ena;
wire signb_pipreg_bypass_register;
wire  signb_pipreg_out;


    //Internal signals to instantiate the zeroacc input register unit
wire [3:0] zeroacc_inreg_clk_value;
wire [3:0] zeroacc_inreg_aclr_value;
wire zeroacc_inreg_clk;
wire zeroacc_inreg_aclr;
wire zeroacc_inreg_ena;
wire zeroacc_inreg_bypass_register;
wire  zeroacc_inreg_pipreg;


    //Internal signals to instantiate the zeroacc pipeline register unit
wire [3:0] zeroacc_pipreg_clk_value;
wire [3:0] zeroacc_pipreg_aclr_value;
wire zeroacc_pipreg_clk;
wire zeroacc_pipreg_aclr;
wire zeroacc_pipreg_ena;
wire zeroacc_pipreg_bypass_register;
wire  zeroacc_pipreg_out;

//Internal signals to instantiate the zeroacc1 input register unit 
wire [3:0] zeroacc1_inreg_clk_value;    
wire [3:0] zeroacc1_inreg_aclr_value;   
wire zeroacc1_inreg_clk;            
wire zeroacc1_inreg_aclr;           
wire zeroacc1_inreg_ena;            
wire zeroacc1_inreg_bypass_register;    
wire  zeroacc1_inreg_pipreg;            



    //Internal signals to instantiate the zeroacc1 pipeline register unit 
wire [3:0] zeroacc1_pipreg_clk_value;
wire [3:0] zeroacc1_pipreg_aclr_value;
wire zeroacc1_pipreg_clk;
wire zeroacc1_pipreg_aclr;
wire zeroacc1_pipreg_ena;
wire zeroacc1_pipreg_bypass_register;
wire  zeroacc1_pipreg_out;


    //Internal signals to instantiate the addnsub0 input register unit
wire [3:0] addnsub0_inreg_clk_value;
wire [3:0] addnsub0_inreg_aclr_value;
wire addnsub0_inreg_clk;
wire addnsub0_inreg_aclr;
wire addnsub0_inreg_ena;
wire addnsub0_inreg_bypass_register;
wire  addnsub0_inreg_pipreg;


    //Internal signals to instantiate the addnsub0 pipeline register unit
wire [3:0] addnsub0_pipreg_clk_value;
wire [3:0] addnsub0_pipreg_aclr_value;
wire addnsub0_pipreg_clk;
wire addnsub0_pipreg_aclr;
wire addnsub0_pipreg_ena;
wire addnsub0_pipreg_bypass_register;
wire  addnsub0_pipreg_out;

    //Internal signals to instantiate the addnsub1 input register unit
wire [3:1] addnsub1_inreg_clk_value;
wire [3:1] addnsub1_inreg_aclr_value;
wire addnsub1_inreg_clk;
wire addnsub1_inreg_aclr;
wire addnsub1_inreg_ena;
wire addnsub1_inreg_bypass_register;
wire  addnsub1_inreg_pipreg;


    //Internal signals to instantiate the addnsub1 pipeline register unit
wire [3:1] addnsub1_pipreg_clk_value;
wire [3:1] addnsub1_pipreg_aclr_value;
wire addnsub1_pipreg_clk;
wire addnsub1_pipreg_aclr;
wire addnsub1_pipreg_ena;
wire addnsub1_pipreg_bypass_register;
wire  addnsub1_pipreg_out;

 //Internal signals to instantiate the round0 input register unit
wire [3:0] round0_inreg_clk_value;
wire [3:0] round0_inreg_aclr_value;
wire round0_inreg_clk;
wire round0_inreg_aclr;
wire round0_inreg_ena;
wire round0_inreg_bypass_register;
wire  round0_inreg_pipreg;


    //Internal signals to instantiate the round0 pipeline register unit
wire [3:0] round0_pipreg_clk_value;
wire [3:0] round0_pipreg_aclr_value;
wire round0_pipreg_clk;
wire round0_pipreg_aclr;
wire round0_pipreg_ena;
wire round0_pipreg_bypass_register;
wire  round0_pipreg_out;

    //Internal signals to instantiate the round1 input register unit
wire [3:1] round1_inreg_clk_value;
wire [3:1] round1_inreg_aclr_value;
wire round1_inreg_clk;
wire round1_inreg_aclr;
wire round1_inreg_ena;
wire round1_inreg_bypass_register;
wire  round1_inreg_pipreg;


    //Internal signals to instantiate the round1 pipeline register unit
wire [3:1] round1_pipreg_clk_value;
wire [3:1] round1_pipreg_aclr_value;
wire round1_pipreg_clk;
wire round1_pipreg_aclr;
wire round1_pipreg_ena;
wire round1_pipreg_bypass_register;
wire  round1_pipreg_out;

  // Internal signals to instantiate the saturate input register unit
wire [3:0] saturate_inreg_clk_value;
wire [3:0] saturate_inreg_aclr_value;
wire saturate_inreg_clk;
wire saturate_inreg_aclr;
wire saturate_inreg_ena;
wire saturate_inreg_bypass_register;
wire  saturate_inreg_pipreg;


    //Internal signals to instantiate the saturate pipeline register unit
wire [3:0] saturate_pipreg_clk_value;
wire [3:0] saturate_pipreg_aclr_value;
wire saturate_pipreg_clk;
wire saturate_pipreg_aclr;
wire saturate_pipreg_ena;
wire saturate_pipreg_bypass_register;
wire  saturate_pipreg_out;

    //Internal signals to instantiate the saturate1 input register unit 
wire [3:1] saturate1_inreg_clk_value;
wire [3:1] saturate1_inreg_aclr_value;
wire saturate1_inreg_clk;
wire saturate1_inreg_aclr;
wire saturate1_inreg_ena;
wire saturate1_inreg_bypass_register;
wire  saturate1_inreg_pipreg;


    //Internal signals to instantiate the saturate1 pipeline register unit 
wire [3:1] saturate1_pipreg_clk_value;
wire [3:1] saturate1_pipreg_aclr_value;
wire saturate1_pipreg_clk;
wire saturate1_pipreg_aclr;
wire saturate1_pipreg_ena;
wire saturate1_pipreg_bypass_register;
wire  saturate1_pipreg_out;

//Internal signals to instantiate the mode0 input register unit 
wire [3:0] mode0_inreg_clk_value;
wire [3:0] mode0_inreg_aclr_value;
wire mode0_inreg_clk;
wire mode0_inreg_aclr;
wire mode0_inreg_ena;
wire mode0_inreg_bypass_register;
wire  mode0_inreg_pipreg;


    //Internal signals to instantiate the mode0 pipeline register unit 
wire [3:0] mode0_pipreg_clk_value;
wire [3:0] mode0_pipreg_aclr_value;
wire mode0_pipreg_clk;
wire mode0_pipreg_aclr;
wire mode0_pipreg_ena;
wire mode0_pipreg_bypass_register;
wire  mode0_pipreg_out;

    //Internal signals to instantiate the mode1 input register unit 
wire [3:1] mode1_inreg_clk_value;
wire [3:1] mode1_inreg_aclr_value;
wire mode1_inreg_clk;
wire mode1_inreg_aclr;
wire mode1_inreg_ena;
wire mode1_inreg_bypass_register;
wire  mode1_inreg_pipreg;


    //Internal signals to instantiate the mode1 pipeline register unit 
wire [3:1] mode1_pipreg_clk_value;
wire [3:1] mode1_pipreg_aclr_value;
wire mode1_pipreg_clk;
wire mode1_pipreg_aclr;
wire mode1_pipreg_ena;
wire mode1_pipreg_bypass_register;
wire  mode1_pipreg_out;

//Internal signals to instantiate the multabsaturate input register unit
wire [3:0] multabsaturate_inreg_clk_value;
wire [3:0] multabsaturate_inreg_aclr_value;
wire multabsaturate_inreg_clk;
wire multabsaturate_inreg_aclr;
wire multabsaturate_inreg_ena;
wire multabsaturate_inreg_bypass_register;
wire  multabsaturate_inreg_pipreg;


    //Internal signals to instantiate the multabsaturate pipeline register unit
wire [3:0] multabsaturate_pipreg_clk_value;
wire [3:0] multabsaturate_pipreg_aclr_value;
wire multabsaturate_pipreg_clk;
wire multabsaturate_pipreg_aclr;
wire multabsaturate_pipreg_ena;
wire multabsaturate_pipreg_bypass_register;
wire  multabsaturate_pipreg_out;

    //Internal signals to instantiate the multcdsaturate input register unit
wire [3:1] multcdsaturate_inreg_clk_value;
wire [3:1] multcdsaturate_inreg_aclr_value;
wire multcdsaturate_inreg_clk;
wire multcdsaturate_inreg_aclr;
wire multcdsaturate_inreg_ena;
wire multcdsaturate_inreg_bypass_register;
wire  multcdsaturate_inreg_pipreg;


    //Internal signals to instantiate the multcdsaturate pipeline register unit
wire [3:1] multcdsaturate_pipreg_clk_value;
wire [3:1] multcdsaturate_pipreg_aclr_value;
wire multcdsaturate_pipreg_clk;
wire multcdsaturate_pipreg_aclr;
wire multcdsaturate_pipreg_ena;
wire multcdsaturate_pipreg_bypass_register;
wire  multcdsaturate_pipreg_out;

//Declare the signals for instantiating the mac_out internal logic
wire[35:0] mac_out_dataa;
wire[35:0] mac_out_datab;
wire[35:0] mac_out_datac;
wire[35:0] mac_out_datad;
wire [143:0] mac_out_feedback;
wire[143:0] mac_out_dataout;
wire mac_out_accoverflow;

    //Internal signals to instantiate the output register unit
wire [3:1] outreg_clk_value;
wire [3:1] outreg_aclr_value;
wire outreg_clk;
wire outreg_aclr;
wire outreg_ena;
wire outreg_bypass_register;
wire [71:0] outreg_dataout;
wire outreg_accoverflow;


    //Internal signals to instantiate the output register1 unit
wire [3:1] outreg1_clk_value;
wire [3:1] outreg1_aclr_value;
wire outreg1_clk;
wire outreg1_aclr;
wire outreg1_ena;
wire outreg1_bypass_register;
wire [17:0] outreg1_dataout;

//Internal signals to instantiate the output register2 unit
wire [3:1] outreg2_clk_value;
wire [3:1] outreg2_aclr_value;
wire outreg2_clk;
wire outreg2_aclr;
wire outreg2_ena;
wire outreg2_bypass_register;
wire [17:0] outreg2_dataout;

  //Internal signals to instantiate the output register3 unit
wire [3:1] outreg3_clk_value;
wire [3:1] outreg3_aclr_value;
wire outreg3_clk;
wire outreg3_aclr;
wire outreg3_ena;
wire outreg3_bypass_register;
wire [17:0] outreg3_dataout;

//Internal signals to instantiate the output register4 unit
wire [3:1] outreg4_clk_value;
wire [3:1] outreg4_aclr_value;
wire outreg4_clk;
wire outreg4_aclr;
wire outreg4_ena;
wire outreg4_bypass_register;
wire [17:0] outreg4_dataout;

//Internal signals to instantiate the output register5 unit
wire [3:1] outreg5_clk_value;
wire [3:1] outreg5_aclr_value;
wire outreg5_clk;
wire outreg5_aclr;
wire outreg5_ena;
wire outreg5_bypass_register;
wire [17:0] outreg5_dataout;

//Internal signals to instantiate the output register6 unit
wire [3:1] outreg6_clk_value;
wire [3:1] outreg6_aclr_value;
wire outreg6_clk;
wire outreg6_aclr;
wire outreg6_ena;
wire outreg6_bypass_register;
wire [17:0] outreg6_dataout;

 //Internal signals to instantiate the output register7 unit
wire [3:1] outreg7_clk_value;
wire [3:1] outreg7_aclr_value;
wire outreg7_clk;
wire outreg7_aclr;
wire outreg7_ena;
wire outreg7_bypass_register;
wire [17:0] outreg7_dataout;

//Define the internal signals
wire [143:0] dataout_dynamic;
wire [143:0] dataout_tmp;




   //Instantiate signa input register
stratixii_mac_register  signa_inreg(
                                    .datain(signa),
                                    .clk(signa_inreg_clk),
                                    .aclr(signa_inreg_aclr),
                                    .ena(signa_inreg_ena),
                                    .bypass_register(signa_inreg_bypass_register),
                                    .dataout(signa_inreg_pipreg)
                                   );
                                    
defparam signa_inreg.data_width = 1;
      //decode the clk and aclr values
assign signa_inreg_clk_value =((signa_clock == "0") || (signa_clock == "none")) ? 4'b0000 :
                              (signa_clock == "1") ? 4'b0001 :
                              (signa_clock == "2") ? 4'b0010 :
                              (signa_clock == "3") ? 4'b0011 : 4'b0000;

assign   signa_inreg_aclr_value = ((signa_clear == "0") ||(signa_clear == "none")) ? 4'b0000 :
                                 (signa_clear == "1") ? 4'b0001 :
                                 (signa_clear == "2") ? 4'b0010 :
                                 (signa_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign signa_inreg_clk = clk[signa_inreg_clk_value] ? 'b1 : 'b0;
assign signa_inreg_aclr = aclr[signa_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign signa_inreg_ena = ena[signa_inreg_clk_value] ? 'b1 : 'b0;
assign signa_inreg_bypass_register = (signa_clock == "none") ? 'b1 : 'b0;

         //Instantiate signa pipeline register
stratixii_mac_register  signa_pipreg(
                                     .datain(signa_inreg_pipreg),
                                     .clk(signa_pipreg_clk),
                                     .aclr(signa_pipreg_aclr),
                                     .ena(signa_pipreg_ena),
                                     .bypass_register(signa_pipreg_bypass_register),
                                     .dataout(signa_pipreg_out)
                                    );

defparam signa_pipreg.data_width = 1;
      //decode the clk and aclr values
assign signa_pipreg_clk_value =((signa_pipeline_clock == "0") || (signa_pipeline_clock == "none")) ? 4'b0000 :
                               (signa_pipeline_clock == "1") ? 4'b0001 :
                               (signa_pipeline_clock == "2") ? 4'b0010 :
                               (signa_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   signa_pipreg_aclr_value = ((signa_pipeline_clear == "0") ||(signa_pipeline_clear == "none")) ? 4'b0000 :
                                   (signa_pipeline_clear == "1") ? 4'b0001 :
                                   (signa_pipeline_clear == "2") ? 4'b0010 :
                                    (signa_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign signa_pipreg_clk = clk[signa_pipreg_clk_value] ? 'b1 : 'b0;
assign signa_pipreg_aclr = aclr[signa_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign signa_pipreg_ena = ena[signa_pipreg_clk_value] ? 'b1 : 'b0;
assign signa_pipreg_bypass_register = (signa_pipeline_clock == "none") ? 'b1 : 'b0;


         //Instantiate signb input register
stratixii_mac_register  signb_inreg(
                                    .datain(signb),
                                    .clk(signb_inreg_clk),
                                    .aclr(signb_inreg_aclr),
                                    .ena(signb_inreg_ena),
                                    .bypass_register(signb_inreg_bypass_register),
                                    .dataout(signb_inreg_pipreg)
                                   );
                                    
defparam signb_inreg.data_width = 1;
      //decode the clk and aclr values
assign signb_inreg_clk_value =((signb_clock == "0") || (signb_clock == "none")) ? 4'b0000 :
                               (signb_clock == "1") ? 4'b0001 :
                               (signb_clock == "2") ? 4'b0010 :
                               (signb_clock == "3") ? 4'b0011 : 4'b0000;

assign   signb_inreg_aclr_value = ((signb_clear == "0") ||(signb_clear == "none")) ? 4'b0000 :
                                   (signb_clear == "1") ? 4'b0001 :
                                   (signb_clear == "2") ? 4'b0010 :
                                   (signb_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign signb_inreg_clk = clk[signb_inreg_clk_value] ? 'b1 : 'b0;
assign signb_inreg_aclr = aclr[signb_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign signb_inreg_ena = ena[signb_inreg_clk_value] ? 'b1 : 'b0;
assign signb_inreg_bypass_register = (signb_clock == "none") ? 'b1 : 'b0;

         //Instantiate signb pipeline register
stratixii_mac_register  signb_pipreg(
                                     .datain(signb_inreg_pipreg),
                                     .clk(signb_pipreg_clk),
                                     .aclr(signb_pipreg_aclr),
                                     .ena(signb_pipreg_ena),
                                     .bypass_register(signb_pipreg_bypass_register),
                                     .dataout(signb_pipreg_out)
                                    );

defparam signb_pipreg.data_width = 1;
      //decode the clk and aclr values
assign signb_pipreg_clk_value =((signb_pipeline_clock == "0") || (signb_pipeline_clock == "none")) ? 4'b0000 :
                               (signb_pipeline_clock == "1") ? 4'b0001 :
                               (signb_pipeline_clock == "2") ? 4'b0010 :
                               (signb_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   signb_pipreg_aclr_value = ((signb_pipeline_clear == "0") ||(signb_pipeline_clear == "none")) ? 4'b0000 :
                                    (signb_pipeline_clear == "1") ? 4'b0001 :
                                    (signb_pipeline_clear == "2") ? 4'b0010 :
                                    (signb_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign signb_pipreg_clk = clk[signb_pipreg_clk_value] ? 'b1 : 'b0;
assign signb_pipreg_aclr = aclr[signb_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign signb_pipreg_ena = ena[signb_pipreg_clk_value] ? 'b1 : 'b0;
assign signb_pipreg_bypass_register = (signb_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate zeroacc input register
stratixii_mac_register  zeroacc_inreg(
                                      .datain(zeroacc),
                                      .clk(zeroacc_inreg_clk),
                                      .aclr(zeroacc_inreg_aclr),
                                      .ena(zeroacc_inreg_ena),
                                      .bypass_register(zeroacc_inreg_bypass_register),
                                      .dataout(zeroacc_inreg_pipreg)
                                     );

defparam zeroacc_inreg.data_width = 1;
      //decode the clk and aclr values
assign zeroacc_inreg_clk_value =((zeroacc_clock == "0") || (zeroacc_clock == "none")) ? 4'b0000 :
                                (zeroacc_clock == "1") ? 4'b0001 :
                                (zeroacc_clock == "2") ? 4'b0010 :
                                (zeroacc_clock == "3") ? 4'b0011 : 4'b0000;

assign   zeroacc_inreg_aclr_value = ((zeroacc_clear == "0") ||(zeroacc_clear == "none")) ? 4'b0000 :
                                    (zeroacc_clear == "1") ? 4'b0001 :
                                    (zeroacc_clear == "2") ? 4'b0010 :
                                    (zeroacc_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign zeroacc_inreg_clk = clk[zeroacc_inreg_clk_value] ? 'b1 : 'b0;
assign zeroacc_inreg_aclr = aclr[zeroacc_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign zeroacc_inreg_ena = ena[zeroacc_inreg_clk_value] ? 'b1 : 'b0;
assign zeroacc_inreg_bypass_register = (zeroacc_clock == "none") ? 'b1 : 'b0;

         //Instantiate zeroacc pipeline register
stratixii_mac_register  zeroacc_pipreg(
                                       .datain(zeroacc_inreg_pipreg),
                                       .clk(zeroacc_pipreg_clk),
                                       .aclr(zeroacc_pipreg_aclr),
                                       .ena(zeroacc_pipreg_ena),
                                       .bypass_register(zeroacc_pipreg_bypass_register),
                                       .dataout(zeroacc_pipreg_out)
                                     );
                                       
defparam zeroacc_pipreg.data_width = 1;
      //decode the clk and aclr values
assign zeroacc_pipreg_clk_value =((zeroacc_pipeline_clock == "0") || (zeroacc_pipeline_clock == "none")) ? 4'b0000 :
                                 (zeroacc_pipeline_clock == "1") ? 4'b0001 :
                                 (zeroacc_pipeline_clock == "2") ? 4'b0010 :
                                 (zeroacc_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   zeroacc_pipreg_aclr_value = ((zeroacc_pipeline_clear == "0") ||(zeroacc_pipeline_clear == "none")) ? 4'b0000 :
                                    (zeroacc_pipeline_clear == "1") ? 4'b0001 :
                                    (zeroacc_pipeline_clear == "2") ? 4'b0010 :
                                    (zeroacc_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign zeroacc_pipreg_clk = clk[zeroacc_pipreg_clk_value] ? 'b1 : 'b0;
assign zeroacc_pipreg_aclr = aclr[zeroacc_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign zeroacc_pipreg_ena = ena[zeroacc_pipreg_clk_value] ? 'b1 : 'b0;
assign zeroacc_pipreg_bypass_register = (zeroacc_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate zeroacc1 input register 
stratixii_mac_register  zeroacc1_inreg (                            
                                         .datain(zeroacc1), 
                                         .clk(zeroacc1_inreg_clk), 
                                         .aclr(zeroacc1_inreg_aclr),
                                         .ena(zeroacc1_inreg_ena), 
                                         .bypass_register(zeroacc1_inreg_bypass_register), 
                                         .dataout(zeroacc1_inreg_pipreg)      
                                        );   

defparam zeroacc1_inreg.data_width = 1;  
      //decode the clk and aclr values   
assign zeroacc1_inreg_clk_value =((zeroacc1_clock == "0") || (zeroacc1_clock == "none")) ? 4'b0000 :
                                (zeroacc1_clock == "1") ? 4'b0001 :
                                (zeroacc1_clock == "2") ? 4'b0010 :
                                (zeroacc1_clock == "3") ? 4'b0011 : 4'b0000;    

assign   zeroacc1_inreg_aclr_value = ((zeroacc1_clear == "0") ||(zeroacc1_clear == "none")) ? 4'b0000 :
                                    (zeroacc1_clear == "1") ? 4'b0001 :
                                    (zeroacc1_clear == "2") ? 4'b0010 :
                                    (zeroacc1_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign zeroacc1_inreg_clk = clk[zeroacc1_inreg_clk_value] ? 'b1 : 'b0; 
assign zeroacc1_inreg_aclr = aclr[zeroacc1_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign zeroacc1_inreg_ena = ena[zeroacc1_inreg_clk_value] ? 'b1 : 'b0;
assign zeroacc1_inreg_bypass_register = (zeroacc1_clock == "none") ? 'b1 : 'b0; 

         //Instantiate zeroacc1 pipeline register
stratixii_mac_register  zeroacc1_pipreg(
                                        .datain(zeroacc1_inreg_pipreg), 
                                        .clk(zeroacc1_pipreg_clk), 
                                        .aclr(zeroacc1_pipreg_aclr),
                                        .ena(zeroacc1_pipreg_ena), 
                                        .bypass_register(zeroacc1_pipreg_bypass_register), 
                                        .dataout(zeroacc1_pipreg_out)  
                                       );   

defparam zeroacc1_pipreg.data_width = 1;  
      //decode the clk and aclr values 
assign zeroacc1_pipreg_clk_value =((zeroacc1_pipeline_clock == "0") || (zeroacc1_pipeline_clock == "none")) ? 4'b0000 :
                                   (zeroacc1_pipeline_clock == "1") ? 4'b0001 :
                                   (zeroacc1_pipeline_clock == "2") ? 4'b0010 :
                                   (zeroacc1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;   

assign   zeroacc1_pipreg_aclr_value = ((zeroacc1_pipeline_clear == "0") ||(zeroacc1_pipeline_clear == "none")) ? 4'b0000 :
                                     (zeroacc1_pipeline_clear == "1") ? 4'b0001 :
                                     (zeroacc1_pipeline_clear == "2") ? 4'b0010 :
                                    (zeroacc1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign zeroacc1_pipreg_clk = clk[zeroacc1_pipreg_clk_value] ? 'b1 : 'b0; 
assign zeroacc1_pipreg_aclr = aclr[zeroacc1_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;    
assign zeroacc1_pipreg_ena = ena[zeroacc1_pipreg_clk_value] ? 'b1 : 'b0;
assign zeroacc1_pipreg_bypass_register = (zeroacc1_pipeline_clock == "none") ? 'b1 : 'b0; 

         //Instantiate addnsub0 input register
stratixii_mac_register  addnsub0_inreg(
                                       .datain(addnsub0),
                                       .clk(addnsub0_inreg_clk),
                                       .aclr(addnsub0_inreg_aclr),
                                       .ena(addnsub0_inreg_ena),
                                       .bypass_register(addnsub0_inreg_bypass_register),
                                       .dataout(addnsub0_inreg_pipreg)
                                       );

defparam addnsub0_inreg.data_width = 1;
      //decode the clk and aclr values
assign addnsub0_inreg_clk_value =((addnsub0_clock == "0") || (addnsub0_clock == "none")) ? 4'b0000 :
                                 (addnsub0_clock == "1") ? 4'b0001 :
                                 (addnsub0_clock == "2") ? 4'b0010 :
                                 (addnsub0_clock == "3") ? 4'b0011 : 4'b0000;

assign   addnsub0_inreg_aclr_value = ((addnsub0_clear == "0") ||(addnsub0_clear == "none")) ? 4'b0000 :
                                    (addnsub0_clear == "1") ? 4'b0001 :
                                    (addnsub0_clear == "2") ? 4'b0010 :
                                    (addnsub0_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign addnsub0_inreg_clk = clk[addnsub0_inreg_clk_value] ? 'b1 : 'b0;
assign addnsub0_inreg_aclr = aclr[addnsub0_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign addnsub0_inreg_ena = ena[addnsub0_inreg_clk_value] ? 'b1 : 'b0;
assign addnsub0_inreg_bypass_register = (addnsub0_clock == "none") ? 'b1 : 'b0;

         //Instantiate addnsub0 pipeline register
stratixii_mac_register  addnsub0_pipreg(
                                        .datain(addnsub0_inreg_pipreg),
                                        .clk(addnsub0_pipreg_clk),
                                        .aclr(addnsub0_pipreg_aclr),
                                        .ena(addnsub0_pipreg_ena),
                                        .bypass_register(addnsub0_pipreg_bypass_register),
                                        .dataout(addnsub0_pipreg_out)
                                        );
                                       
defparam addnsub0_pipreg.data_width = 1;
      //decode the clk and aclr values
assign addnsub0_pipreg_clk_value =((addnsub0_pipeline_clock == "0") || (addnsub0_pipeline_clock == "none")) ? 4'b0000 :
                                  (addnsub0_pipeline_clock == "1") ? 4'b0001 :
                                  (addnsub0_pipeline_clock == "2") ? 4'b0010 :
                                  (addnsub0_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   addnsub0_pipreg_aclr_value = ((addnsub0_pipeline_clear == "0") ||(addnsub0_pipeline_clear == "none")) ? 4'b0000 :
                                     (addnsub0_pipeline_clear == "1") ? 4'b0001 :
                                     (addnsub0_pipeline_clear == "2") ? 4'b0010 :
                                    (addnsub0_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign addnsub0_pipreg_clk = clk[addnsub0_pipreg_clk_value] ? 'b1 : 'b0;
assign addnsub0_pipreg_aclr = aclr[addnsub0_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign addnsub0_pipreg_ena = ena[addnsub0_pipreg_clk_value] ? 'b1 : 'b0;
assign addnsub0_pipreg_bypass_register = (addnsub0_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate addnsub1 input register
stratixii_mac_register  addnsub1_inreg(
                                       .datain(addnsub1),
                                       .clk(addnsub1_inreg_clk),
                                       .aclr(addnsub1_inreg_aclr),
                                       .ena(addnsub1_inreg_ena),
                                       .bypass_register(addnsub1_inreg_bypass_register),
                                       .dataout(addnsub1_inreg_pipreg)
                                       );

defparam addnsub1_inreg.data_width = 1;
      //decode the clk and aclr values
assign addnsub1_inreg_clk_value =((addnsub1_clock == "0") || (addnsub1_clock == "none")) ? 4'b0000 :
                                 (addnsub1_clock == "1") ? 4'b0001 :
                                 (addnsub1_clock == "2") ? 4'b0010 :
                                 (addnsub1_clock == "3") ? 4'b0011 : 4'b0000;

assign   addnsub1_inreg_aclr_value = ((addnsub1_clear == "0") ||(addnsub1_clear == "none")) ? 4'b0000 :
                                     (addnsub1_clear == "1") ? 4'b0001 :
                                     (addnsub1_clear == "2") ? 4'b0010 :
                                    (addnsub1_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign addnsub1_inreg_clk = clk[addnsub1_inreg_clk_value] ? 'b1 : 'b0;
assign addnsub1_inreg_aclr = aclr[addnsub1_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign addnsub1_inreg_ena = ena[addnsub1_inreg_clk_value] ? 'b1 : 'b0;
assign addnsub1_inreg_bypass_register = (addnsub1_clock == "none") ? 'b1 : 'b0;

         //Instantiate addnsub1 pipeline register
stratixii_mac_register  addnsub1_pipreg(
                                        .datain(addnsub1_inreg_pipreg),
                                        .clk(addnsub1_pipreg_clk),
                                        .aclr(addnsub1_pipreg_aclr),
                                        .ena(addnsub1_pipreg_ena),
                                        .bypass_register(addnsub1_pipreg_bypass_register),
                                        .dataout(addnsub1_pipreg_out)
                                       );

defparam addnsub1_pipreg.data_width = 1;
      //decode the clk and aclr values
assign addnsub1_pipreg_clk_value =((addnsub1_pipeline_clock == "0") || (addnsub1_pipeline_clock == "none")) ? 4'b0000 :
                                  (addnsub1_pipeline_clock == "1") ? 4'b0001 :
                                  (addnsub1_pipeline_clock == "2") ? 4'b0010 :
                                  (addnsub1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   addnsub1_pipreg_aclr_value = ((addnsub1_pipeline_clear == "0") ||(addnsub1_pipeline_clear == "none")) ? 4'b0000 :
                                     (addnsub1_pipeline_clear == "1") ? 4'b0001 :
                                     (addnsub1_pipeline_clear == "2") ? 4'b0010 :
                                    (addnsub1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign addnsub1_pipreg_clk = clk[addnsub1_pipreg_clk_value] ? 'b1 : 'b0;
assign addnsub1_pipreg_aclr = aclr[addnsub1_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign addnsub1_pipreg_ena = ena[addnsub1_pipreg_clk_value] ? 'b1 : 'b0;
assign addnsub1_pipreg_bypass_register = (addnsub1_pipeline_clock == "none") ? 'b1 : 'b0;

         //Instantiate round0 input register
stratixii_mac_register  round0_inreg(
                                     .datain(round0),
                                     .clk(round0_inreg_clk),
                                     .aclr(round0_inreg_aclr),
                                     .ena(round0_inreg_ena),
                                     .bypass_register(round0_inreg_bypass_register),
                                     .dataout(round0_inreg_pipreg)
                                    );

defparam round0_inreg.data_width = 1;
      //decode the clk and aclr values
assign round0_inreg_clk_value =((round0_clock == "0") || (round0_clock == "none")) ? 4'b0000 :
                                   (round0_clock == "1") ? 4'b0001 :
                                   (round0_clock == "2") ? 4'b0010 :
                                   (round0_clock == "3") ? 4'b0011 : 4'b0000;

assign   round0_inreg_aclr_value = ((round0_clear == "0") ||(round0_clear == "none")) ? 4'b0000 :
                                   (round0_clear == "1") ? 4'b0001 :
                                   (round0_clear == "2") ? 4'b0010 :
                                   (round0_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign round0_inreg_clk = clk[round0_inreg_clk_value] ? 'b1 : 'b0;
assign round0_inreg_aclr = aclr[round0_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign round0_inreg_ena = ena[round0_inreg_clk_value] ? 'b1 : 'b0;
assign round0_inreg_bypass_register = (round0_clock == "none") ? 'b1 : 'b0;

         //Instantiate round0 pipeline register
stratixii_mac_register  round0_pipreg(
                                      .datain(round0_inreg_pipreg),
                                      .clk(round0_pipreg_clk),
                                      .aclr(round0_pipreg_aclr),
                                      .ena(round0_pipreg_ena),
                                      .bypass_register(round0_pipreg_bypass_register),
                                      .dataout(round0_pipreg_out)
                                     );

defparam round0_pipreg.data_width = 1;
      //decode the clk and aclr values
assign round0_pipreg_clk_value =((round0_pipeline_clock == "0") || (round0_pipeline_clock == "none")) ? 4'b0000 :
                                (round0_pipeline_clock == "1") ? 4'b0001 :
                                (round0_pipeline_clock == "2") ? 4'b0010 :
                                (round0_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   round0_pipreg_aclr_value = ((round0_pipeline_clear == "0") ||(round0_pipeline_clear == "none")) ? 4'b0000 :
                                    (round0_pipeline_clear == "1") ? 4'b0001 :
                                    (round0_pipeline_clear == "2") ? 4'b0010 :
                                    (round0_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign round0_pipreg_clk = clk[round0_pipreg_clk_value] ? 'b1 : 'b0;
assign round0_pipreg_aclr = aclr[round0_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign round0_pipreg_ena = ena[round0_pipreg_clk_value] ? 'b1 : 'b0;
assign round0_pipreg_bypass_register = (round0_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate round1 input register
stratixii_mac_register  round1_inreg(
                                     .datain(round1),
                                     .clk(round1_inreg_clk),
                                     .aclr(round1_inreg_aclr),
                                     .ena(round1_inreg_ena),
                                     .bypass_register(round1_inreg_bypass_register),
                                     .dataout(round1_inreg_pipreg)
                                    );

defparam round1_inreg.data_width = 1;
      //decode the clk and aclr values
assign round1_inreg_clk_value =((round1_clock == "0") || (round1_clock == "none")) ? 4'b0000 :
                               (round1_clock == "1") ? 4'b0001 :
                               (round1_clock == "2") ? 4'b0010 :
                               (round1_clock == "3") ? 4'b0011 : 4'b0000;

assign   round1_inreg_aclr_value = ((round1_clear == "0") ||(round1_clear == "none")) ? 4'b0000 :
                                   (round1_clear == "1") ? 4'b0001 :
                                   (round1_clear == "2") ? 4'b0010 :
                                   (round1_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign round1_inreg_clk = clk[round1_inreg_clk_value] ? 'b1 : 'b0;
assign round1_inreg_aclr = aclr[round1_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign round1_inreg_ena = ena[round1_inreg_clk_value] ? 'b1 : 'b0;
assign round1_inreg_bypass_register = (round1_clock == "none") ? 'b1 : 'b0;

         //Instantiate round1 pipeline register
stratixii_mac_register  round1_pipreg(
                                      .datain(round1_inreg_pipreg),
                                      .clk(round1_pipreg_clk),
                                      .aclr(round1_pipreg_aclr),
                                      .ena(round1_pipreg_ena),
                                      .bypass_register(round1_pipreg_bypass_register),
                                      .dataout(round1_pipreg_out)
                                     );

defparam round1_pipreg.data_width = 1;
      //decode the clk and aclr values
assign round1_pipreg_clk_value =((round1_pipeline_clock == "0") || (round1_pipeline_clock == "none")) ? 4'b0000 :
                                (round1_pipeline_clock == "1") ? 4'b0001 :
                                (round1_pipeline_clock == "2") ? 4'b0010 :
                                (round1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   round1_pipreg_aclr_value = ((round1_pipeline_clear == "0") ||(round1_pipeline_clear == "none")) ? 4'b0000 :
                                    (round1_pipeline_clear == "1") ? 4'b0001 :
                                    (round1_pipeline_clear == "2") ? 4'b0010 :
                                    (round1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign round1_pipreg_clk = clk[round1_pipreg_clk_value] ? 'b1 : 'b0;
assign round1_pipreg_aclr = aclr[round1_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign round1_pipreg_ena = ena[round1_pipreg_clk_value] ? 'b1 : 'b0;
assign round1_pipreg_bypass_register = (round1_pipeline_clock == "none") ? 'b1 : 'b0;


         //Instantiate saturate input register
stratixii_mac_register  saturate_inreg(
                                       .datain(saturate),
                                       .clk(saturate_inreg_clk),
                                       .aclr(saturate_inreg_aclr),
                                       .ena(saturate_inreg_ena),
                                       .bypass_register(saturate_inreg_bypass_register),
                                       .dataout(saturate_inreg_pipreg)
                                      );

defparam saturate_inreg.data_width = 1;
      //decode the clk and aclr values
assign saturate_inreg_clk_value =((saturate_clock == "0") || (saturate_clock == "none")) ? 4'b0000 :
                                 (saturate_clock == "1") ? 4'b0001 :
                                 (saturate_clock == "2") ? 4'b0010 :
                                 (saturate_clock == "3") ? 4'b0011 : 4'b0000;

assign   saturate_inreg_aclr_value = ((saturate_clear == "0") ||(saturate_clear == "none")) ? 4'b0000 :
                                    (saturate_clear == "1") ? 4'b0001 :
                                    (saturate_clear == "2") ? 4'b0010 :
                                    (saturate_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign saturate_inreg_clk = clk[saturate_inreg_clk_value] ? 'b1 : 'b0;
assign saturate_inreg_aclr = aclr[saturate_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign saturate_inreg_ena = ena[saturate_inreg_clk_value] ? 'b1 : 'b0;
assign saturate_inreg_bypass_register = (saturate_clock == "none") ? 'b1 : 'b0;

         //Instantiate saturate pipeline register
stratixii_mac_register  saturate_pipreg(
                                        .datain(saturate_inreg_pipreg),
                                        .clk(saturate_pipreg_clk),
                                        .aclr(saturate_pipreg_aclr),
                                        .ena(saturate_pipreg_ena),
                                        .bypass_register(saturate_pipreg_bypass_register),
                                        .dataout(saturate_pipreg_out)
                                       );

defparam saturate_pipreg.data_width = 1;
      //decode the clk and aclr values
assign saturate_pipreg_clk_value =((saturate_pipeline_clock == "0") || (saturate_pipeline_clock == "none")) ? 4'b0000 :
                                   (saturate_pipeline_clock == "1") ? 4'b0001 :
                                   (saturate_pipeline_clock == "2") ? 4'b0010 :
                                   (saturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   saturate_pipreg_aclr_value = ((saturate_pipeline_clear == "0") ||(saturate_pipeline_clear == "none")) ? 4'b0000 :
                                      (saturate_pipeline_clear == "1") ? 4'b0001 :
                                      (saturate_pipeline_clear == "2") ? 4'b0010 :
                                    (saturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign saturate_pipreg_clk = clk[saturate_pipreg_clk_value] ? 'b1 : 'b0;
assign saturate_pipreg_aclr = aclr[saturate_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign saturate_pipreg_ena = ena[saturate_pipreg_clk_value] ? 'b1 : 'b0;
assign saturate_pipreg_bypass_register = (saturate_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate saturate1 input register 
stratixii_mac_register  saturate1_inreg(
                                        .datain(saturate1), 
                                        .clk(saturate1_inreg_clk), 
                                        .aclr(saturate1_inreg_aclr),
                                        .ena(saturate1_inreg_ena), 
                                        .bypass_register(saturate1_inreg_bypass_register),
                                        .dataout(saturate1_inreg_pipreg)    
                                       ); 

defparam saturate1_inreg.data_width = 1; 
      //decode the clk and aclr values   
assign saturate1_inreg_clk_value =((saturate1_clock == "0") || (saturate1_clock == "none")) ? 4'b0000 :
                                   (saturate1_clock == "1") ? 4'b0001 :
                                   (saturate1_clock == "2") ? 4'b0010 :
                                   (saturate1_clock == "3") ? 4'b0011 : 4'b0000;    

assign   saturate1_inreg_aclr_value = ((saturate1_clear == "0") ||(saturate1_clear == "none")) ? 4'b0000 :
                                     (saturate1_clear == "1") ? 4'b0001 :
                                     (saturate1_clear == "2") ? 4'b0010 :
                                    (saturate1_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign saturate1_inreg_clk = clk[saturate1_inreg_clk_value] ? 'b1 : 'b0; 
assign saturate1_inreg_aclr = aclr[saturate1_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;    
assign saturate1_inreg_ena = ena[saturate1_inreg_clk_value] ? 'b1 : 'b0;
assign saturate1_inreg_bypass_register = (saturate1_clock == "none") ? 'b1 : 'b0; 

         //Instantiate saturate1 pipeline register
stratixii_mac_register  saturate1_pipreg(           
                                         .datain(saturate1_inreg_pipreg), 
                                         .clk(saturate1_pipreg_clk), 
                                         .aclr(saturate1_pipreg_aclr),
                                         .ena(saturate1_pipreg_ena), 
                                         .bypass_register(saturate1_pipreg_bypass_register), 
                                         .dataout(saturate1_pipreg_out)  
                                       );   
                                        
defparam saturate1_pipreg.data_width = 1; 
      //decode the clk and aclr values  
assign saturate1_pipreg_clk_value =((saturate1_pipeline_clock == "0") || (saturate1_pipeline_clock == "none")) ? 4'b0000 :
                                   (saturate1_pipeline_clock == "1") ? 4'b0001 :
                                   (saturate1_pipeline_clock == "2") ? 4'b0010 :
                                   (saturate1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;  

assign   saturate1_pipreg_aclr_value = ((saturate1_pipeline_clear == "0") ||(saturate1_pipeline_clear == "none")) ? 4'b0000 :
                                     (saturate1_pipeline_clear == "1") ? 4'b0001 :
                                     (saturate1_pipeline_clear == "2") ? 4'b0010 :
                                    (saturate1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign saturate1_pipreg_clk = clk[saturate1_pipreg_clk_value] ? 'b1 : 'b0; 
assign saturate1_pipreg_aclr = aclr[saturate1_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;  
assign saturate1_pipreg_ena = ena[saturate1_pipreg_clk_value] ? 'b1 : 'b0;
assign saturate1_pipreg_bypass_register = (saturate1_pipeline_clock == "none") ? 'b1 : 'b0; 

         //Instantiate mode0 input register
stratixii_mac_register  mode0_inreg(      
                                    .datain(mode0), 
                                    .clk(mode0_inreg_clk), 
                                    .aclr(mode0_inreg_aclr),
                                    .ena(mode0_inreg_ena), 
                                    .bypass_register(mode0_inreg_bypass_register), 
                                    .dataout(mode0_inreg_pipreg)  
                                   );

defparam mode0_inreg.data_width = 1;  
      //decode the clk and aclr values   
assign mode0_inreg_clk_value =((mode0_clock == "0") || (mode0_clock == "none")) ? 4'b0000 :
                              (mode0_clock == "1") ? 4'b0001 :
                              (mode0_clock == "2") ? 4'b0010 :
                              (mode0_clock == "3") ? 4'b0011 : 4'b0000;  

assign   mode0_inreg_aclr_value = ((mode0_clear == "0") ||(mode0_clear == "none")) ? 4'b0000 :
                                   (mode0_clear == "1") ? 4'b0001 :
                                   (mode0_clear == "2") ? 4'b0010 :
                                   (mode0_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign mode0_inreg_clk = clk[mode0_inreg_clk_value] ? 'b1 : 'b0; 
assign mode0_inreg_aclr = aclr[mode0_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;    
assign mode0_inreg_ena = ena[mode0_inreg_clk_value] ? 'b1 : 'b0;
assign mode0_inreg_bypass_register = (mode0_clock == "none") ? 'b1 : 'b0; 

         //Instantiate mode0 pipeline register
stratixii_mac_register  mode0_pipreg(
                                     .datain(mode0_inreg_pipreg), 
                                     .clk(mode0_pipreg_clk), 
                                     .aclr(mode0_pipreg_aclr),
                                     .ena(mode0_pipreg_ena), 
                                     .bypass_register(mode0_pipreg_bypass_register), 
                                     .dataout(mode0_pipreg_out)
                                   );   

defparam mode0_pipreg.data_width = 1;  
      //decode the clk and aclr values   
assign mode0_pipreg_clk_value =((mode0_pipeline_clock == "0") || (mode0_pipeline_clock == "none")) ? 4'b0000 :
                               (mode0_pipeline_clock == "1") ? 4'b0001 :
                               (mode0_pipeline_clock == "2") ? 4'b0010 :
                               (mode0_pipeline_clock == "3") ? 4'b0011 : 4'b0000;  

assign   mode0_pipreg_aclr_value = ((mode0_pipeline_clear == "0") ||(mode0_pipeline_clear == "none")) ? 4'b0000 :
                                   (mode0_pipeline_clear == "1") ? 4'b0001 :
                                   (mode0_pipeline_clear == "2") ? 4'b0010 :
                                   (mode0_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign mode0_pipreg_clk = clk[mode0_pipreg_clk_value] ? 'b1 : 'b0; 
assign mode0_pipreg_aclr = aclr[mode0_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;  
assign mode0_pipreg_ena = ena[mode0_pipreg_clk_value] ? 'b1 : 'b0;
assign mode0_pipreg_bypass_register = (mode0_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate mode1 input register
stratixii_mac_register  mode1_inreg (
                                     .datain(mode1), 
                                     .clk(mode1_inreg_clk), 
                                     .aclr(mode1_inreg_aclr),
                                     .ena(mode1_inreg_ena), 
                                     .bypass_register(mode1_inreg_bypass_register),
                                     .dataout(mode1_inreg_pipreg)
                                   ); 

defparam mode1_inreg.data_width = 1; 
      //decode the clk and aclr values
assign mode1_inreg_clk_value =((mode1_clock == "0") || (mode1_clock == "none")) ? 4'b0000 :
                              (mode1_clock == "1") ? 4'b0001 :
                              (mode1_clock == "2") ? 4'b0010 :
                              (mode1_clock == "3") ? 4'b0011 : 4'b0000;  

assign   mode1_inreg_aclr_value = ((mode1_clear == "0") ||(mode1_clear == "none")) ? 4'b0000 :
                                  (mode1_clear == "1") ? 4'b0001 :
                                  (mode1_clear == "2") ? 4'b0010 :
                                  (mode1_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign mode1_inreg_clk = clk[mode1_inreg_clk_value] ? 'b1 : 'b0; 
assign mode1_inreg_aclr = aclr[mode1_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign mode1_inreg_ena = ena[mode1_inreg_clk_value] ? 'b1 : 'b0;
assign mode1_inreg_bypass_register = (mode1_clock == "none") ? 'b1 : 'b0; 

         //Instantiate mode1 pipeline register
stratixii_mac_register  mode1_pipreg (
                                       .datain(mode1_inreg_pipreg), 
                                       .clk(mode1_pipreg_clk), 
                                       .aclr(mode1_pipreg_aclr),
                                       .ena(mode1_pipreg_ena), 
                                       .bypass_register(mode1_pipreg_bypass_register), 
                                       .dataout(mode1_pipreg_out)
                                      );   

defparam mode1_pipreg.data_width = 1;  
      //decode the clk and aclr values 
assign mode1_pipreg_clk_value =((mode1_pipeline_clock == "0") || (mode1_pipeline_clock == "none")) ? 4'b0000 :
                               (mode1_pipeline_clock == "1") ? 4'b0001 :
                               (mode1_pipeline_clock == "2") ? 4'b0010 :
                               (mode1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   mode1_pipreg_aclr_value = ((mode1_pipeline_clear == "0") ||(mode1_pipeline_clear == "none")) ? 4'b0000 :
                                   (mode1_pipeline_clear == "1") ? 4'b0001 :
                                   (mode1_pipeline_clear == "2") ? 4'b0010 :
                                   (mode1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign mode1_pipreg_clk = clk[mode1_pipreg_clk_value] ? 'b1 : 'b0; 
assign mode1_pipreg_aclr = aclr[mode1_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;  
assign mode1_pipreg_ena = ena[mode1_pipreg_clk_value] ? 'b1 : 'b0;
assign mode1_pipreg_bypass_register = (mode1_pipeline_clock == "none") ? 'b1 : 'b0; 


         //Instantiate multabsaturate input register
stratixii_mac_register  multabsaturate_inreg(
                                             .datain(multabsaturate),
                                             .clk(multabsaturate_inreg_clk),
                                             .aclr(multabsaturate_inreg_aclr),
                                             .ena(multabsaturate_inreg_ena),
                                             .bypass_register(multabsaturate_inreg_bypass_register),
                                             .dataout(multabsaturate_inreg_pipreg)
                                            );

defparam multabsaturate_inreg.data_width = 1;
      //decode the clk and aclr values
assign multabsaturate_inreg_clk_value =((multabsaturate_clock == "0") || (multabsaturate_clock == "none")) ? 4'b0000 :
                                   (multabsaturate_clock == "1") ? 4'b0001 :
                                   (multabsaturate_clock == "2") ? 4'b0010 :
                                   (multabsaturate_clock == "3") ? 4'b0011 : 4'b0000;

assign   multabsaturate_inreg_aclr_value = ((multabsaturate_clear == "0") ||(multabsaturate_clear == "none")) ? 4'b0000 :
                                        (multabsaturate_clear == "1") ? 4'b0001 :
                                        (multabsaturate_clear == "2") ? 4'b0010 :
                                        (multabsaturate_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign multabsaturate_inreg_clk = clk[multabsaturate_inreg_clk_value] ? 'b1 : 'b0;
assign multabsaturate_inreg_aclr = aclr[multabsaturate_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign multabsaturate_inreg_ena = ena[multabsaturate_inreg_clk_value] ? 'b1 : 'b0;
assign multabsaturate_inreg_bypass_register = (multabsaturate_clock == "none") ? 'b1 : 'b0;

         //Instantiate multabsaturate pipeline register
stratixii_mac_register  multabsaturate_pipreg(
                                              .datain(multabsaturate_inreg_pipreg),
                                              .clk(multabsaturate_pipreg_clk),
                                              .aclr(multabsaturate_pipreg_aclr),
                                              .ena(multabsaturate_pipreg_ena),
                                              .bypass_register(multabsaturate_pipreg_bypass_register),
                                              .dataout(multabsaturate_pipreg_out)
                                             );

defparam multabsaturate_pipreg.data_width = 1;
      //decode the clk and aclr values
assign multabsaturate_pipreg_clk_value =((multabsaturate_pipeline_clock == "0") || (multabsaturate_pipeline_clock == "none")) ? 4'b0000 :
                                        (multabsaturate_pipeline_clock == "1") ? 4'b0001 :
                                        (multabsaturate_pipeline_clock == "2") ? 4'b0010 :
                                        (multabsaturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   multabsaturate_pipreg_aclr_value = ((multabsaturate_pipeline_clear == "0") ||(multabsaturate_pipeline_clear == "none")) ? 4'b0000 :
                                            (multabsaturate_pipeline_clear == "1") ? 4'b0001 :
                                            (multabsaturate_pipeline_clear == "2") ? 4'b0010 :
                                            (multabsaturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign multabsaturate_pipreg_clk = clk[multabsaturate_pipreg_clk_value] ? 'b1 : 'b0;
assign multabsaturate_pipreg_aclr = aclr[multabsaturate_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign multabsaturate_pipreg_ena = ena[multabsaturate_pipreg_clk_value] ? 'b1 : 'b0;
assign multabsaturate_pipreg_bypass_register = (multabsaturate_pipeline_clock == "none") ? 'b1 : 'b0;


  //Instantiate multcdsaturate input register
stratixii_mac_register  multcdsaturate_inreg(
                                              .datain(multcdsaturate),
                                              .clk(multcdsaturate_inreg_clk),
                                              .aclr(multcdsaturate_inreg_aclr),
                                              .ena(multcdsaturate_inreg_ena),
                                              .bypass_register(multcdsaturate_inreg_bypass_register),
                                              .dataout(multcdsaturate_inreg_pipreg)
                                            );

defparam multcdsaturate_inreg.data_width = 1;
      //decode the clk and aclr values
assign multcdsaturate_inreg_clk_value =((multcdsaturate_clock == "0") || (multcdsaturate_clock == "none")) ? 4'b0000 :
                                       (multcdsaturate_clock == "1") ? 4'b0001 :
                                       (multcdsaturate_clock == "2") ? 4'b0010 :
                                       (multcdsaturate_clock == "3") ? 4'b0011 : 4'b0000;

assign   multcdsaturate_inreg_aclr_value = ((multcdsaturate_clear == "0") ||(multcdsaturate_clear == "none")) ? 4'b0000 :
                                        (multcdsaturate_clear == "1") ? 4'b0001 :
                                        (multcdsaturate_clear == "2") ? 4'b0010 :
                                        (multcdsaturate_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign multcdsaturate_inreg_clk = clk[multcdsaturate_inreg_clk_value] ? 'b1 : 'b0;
assign multcdsaturate_inreg_aclr = aclr[multcdsaturate_inreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign multcdsaturate_inreg_ena = ena[multcdsaturate_inreg_clk_value] ? 'b1 : 'b0;
assign multcdsaturate_inreg_bypass_register = (multcdsaturate_clock == "none") ? 'b1 : 'b0;

         //Instantiate multcdsaturate pipeline register
stratixii_mac_register  multcdsaturate_pipreg(
                                               .datain(multcdsaturate_inreg_pipreg),
                                               .clk(multcdsaturate_pipreg_clk),
                                               .aclr(multcdsaturate_pipreg_aclr),
                                               .ena(multcdsaturate_pipreg_ena),
                                               .bypass_register(multcdsaturate_pipreg_bypass_register),
                                               .dataout(multcdsaturate_pipreg_out)
                                             );

defparam multcdsaturate_pipreg.data_width = 1;
      //decode the clk and aclr values
assign multcdsaturate_pipreg_clk_value =((multcdsaturate_pipeline_clock == "0") || (multcdsaturate_pipeline_clock == "none")) ? 4'b0000 :
                                        (multcdsaturate_pipeline_clock == "1") ? 4'b0001 :
                                        (multcdsaturate_pipeline_clock == "2") ? 4'b0010 :
                                        (multcdsaturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;

assign   multcdsaturate_pipreg_aclr_value = ((multcdsaturate_pipeline_clear == "0") ||(multcdsaturate_pipeline_clear == "none")) ? 4'b0000 :
                                        (multcdsaturate_pipeline_clear == "1") ? 4'b0001 :
                                        (multcdsaturate_pipeline_clear == "2") ? 4'b0010 :
                                        (multcdsaturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.

assign multcdsaturate_pipreg_clk = clk[multcdsaturate_pipreg_clk_value] ? 'b1 : 'b0;
assign multcdsaturate_pipreg_aclr = aclr[multcdsaturate_pipreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign multcdsaturate_pipreg_ena = ena[multcdsaturate_pipreg_clk_value] ? 'b1 : 'b0;
assign multcdsaturate_pipreg_bypass_register = (multcdsaturate_pipeline_clock == "none") ? 'b1 : 'b0;

     //Instantiate the mac_out internal logic
stratixii_mac_out_internal mac_out_block(
                                         .dataa(mac_out_dataa),
                                         .datab(mac_out_datab),
                                         .datac(mac_out_datac),
                                         .datad(mac_out_datad),
                                         .mode0(mode0_pipreg_out), 
                                         .mode1(mode1_pipreg_out), 
                                         .roundab(round0_pipreg_out),
                                         .saturateab(saturate_pipreg_out),
                                         .roundcd(round1_pipreg_out),
                                         .saturatecd(saturate1_pipreg_out),
                                         .multabsaturate(multabsaturate_pipreg_out),
                                         .multcdsaturate(multcdsaturate_pipreg_out),
                                         .signa(signa_pipreg_out),
                                         .signb(signb_pipreg_out),
                                         .addnsub0(addnsub0_pipreg_out),
                                         .addnsub1(addnsub1_pipreg_out),
                                         .zeroacc(zeroacc_pipreg_out),
                                         .zeroacc1(zeroacc1_pipreg_out),
                                         .feedback(mac_out_feedback),
                                         .dataout(mac_out_dataout),
                                         .accoverflow(mac_out_accoverflow)
                                        );
                                         
defparam  mac_out_block.operation_mode = operation_mode;
defparam  mac_out_block.dataa_width = dataa_width;
defparam  mac_out_block.datab_width = datab_width;
defparam  mac_out_block.datac_width = datac_width;
defparam  mac_out_block.datad_width = datad_width;

assign    mac_out_dataa = (dataa_forced_to_zero == "yes") ? 36'b0 : dataa;       
assign    mac_out_datac = (datac_forced_to_zero == "yes") ? 36'b0 : datac;       

assign mac_out_datab = datab;
assign mac_out_datad = datad;

   //Instantiate the output register
stratixii_mac_register  output_register(
                                        .datain(mac_out_dataout[71:0]),
                                        .clk(outreg_clk),
                                        .aclr(outreg_aclr),
                                        .ena(outreg_ena),
                                        .bypass_register(outreg_bypass_register),
                                        .dataout(outreg_dataout)
                                       );

defparam output_register.data_width = 72;
      //decode the clk and aclr values
assign outreg_clk_value =((output_clock== "0") || (output_clock== "none")) ? 4'b0000 :
                         (output_clock== "1") ? 4'b0001 :
                         (output_clock== "2") ? 4'b0010 :
                         (output_clock== "3") ? 4'b0011 : 4'b0000;

assign   outreg_aclr_value = ((output_clear == "0") ||(output_clear == "none")) ? 4'b0000 :
                             (output_clear == "1") ? 4'b0001 :
                             (output_clear == "2") ? 4'b0010 :
                             (output_clear == "3") ? 4'b0011 : 4'b0000;

        //assign the corresponding clk,aclr,enable and bypass register values.
assign outreg_clk = clk[outreg_clk_value] ? 'b1 : 'b0;
assign outreg_aclr = aclr[outreg_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;
assign outreg_ena = ena[outreg_clk_value] ? 'b1 : 'b0;
assign outreg_bypass_register = (output_clock== "none") ? 'b1 : 'b0;

   //Instantiate the accum overflow register
stratixii_mac_register  accoverflow_register(
                                              .datain(mac_out_accoverflow),
                                              .clk(outreg_clk),
                                              .aclr(outreg_aclr),
                                              .ena(outreg_ena),
                                              .bypass_register(outreg_bypass_register),
                                              .dataout(accoverflow)
                                             );

defparam accoverflow_register.data_width = 1;

      //Instantiate the output register1                                                       
stratixii_mac_register  output_register1(                                                      
                                         .datain(mac_out_dataout[35:18]),                      
                                         .clk(outreg1_clk),                                    
                                         .aclr(outreg1_aclr),                                  
                                         .ena(outreg1_ena),                                    
                                         .bypass_register(outreg1_bypass_register),            
                                         .dataout(outreg1_dataout)                             
                                         );                                                    
                                                                                               
defparam output_register1.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg1_clk_value =((output1_clock== "0") || (output1_clock== "none")) ? 4'b0000 :      
                           (output1_clock== "1") ? 4'b0001 :                                   
                           (output1_clock== "2") ? 4'b0010 :                                   
                           (output1_clock== "3") ? 4'b0011 : 4'b0000;                          
                                                                                               
assign   outreg1_aclr_value = ((output1_clear == "0") ||(output1_clear == "none")) ? 4'b0000 : 
                              (output1_clear == "1") ? 4'b0001 :                               
                              (output1_clear == "2") ? 4'b0010 :                               
                              (output1_clear == "3") ? 4'b0011 : 4'b0000;                      
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg1_clk = clk[outreg1_clk_value] ? 'b1 : 'b0;                                       
assign outreg1_aclr = aclr[outreg1_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg1_ena = ena[outreg1_clk_value] ? 'b1 : 'b0;                                       
assign outreg1_bypass_register = (output1_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
        //Instantiate the output register2                                                     
stratixii_mac_register  output_register2(                                                      
                                         .datain(mac_out_dataout[53:36]),                      
                                         .clk(outreg2_clk),                                    
                                         .aclr(outreg2_aclr),                                  
                                         .ena(outreg2_ena),                                    
                                         .bypass_register(outreg2_bypass_register),            
                                         .dataout(outreg2_dataout)                             
                                        );                                                     
                                                                                               
defparam output_register2.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg2_clk_value =((output2_clock== "0") || (output2_clock== "none")) ? 4'b0000 :      
                          (output2_clock== "1") ? 4'b0001 :                                    
                          (output2_clock== "2") ? 4'b0010 :                                    
                          (output2_clock== "3") ? 4'b0011 : 4'b0000;                           
                                                                                               
assign   outreg2_aclr_value = ((output2_clear == "0") ||(output2_clear == "none")) ? 4'b0000 : 
                              (output2_clear == "1") ? 4'b0001 :                               
                              (output2_clear == "2") ? 4'b0010 :                               
                              (output2_clear == "3") ? 4'b0011 : 4'b0000;                      
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg2_clk = clk[outreg2_clk_value] ? 'b1 : 'b0;                                       
assign outreg2_aclr = aclr[outreg2_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg2_ena = ena[outreg2_clk_value] ? 'b1 : 'b0;                                       
assign outreg2_bypass_register = (output2_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
         //Instantiate the output register3                                                    
stratixii_mac_register  output_register3(                                                      
                                         .datain(mac_out_dataout[71:54]),                      
                                         .clk(outreg3_clk),                                    
                                         .aclr(outreg3_aclr),                                  
                                         .ena(outreg3_ena),                                    
                                         .bypass_register(outreg3_bypass_register),            
                                         .dataout(outreg3_dataout)                             
                                       );                                                      
                                                                                               
defparam output_register3.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg3_clk_value =((output3_clock== "0") || (output3_clock== "none")) ? 4'b0000 :      
                           (output3_clock== "1") ? 4'b0001 :                                   
                           (output3_clock== "2") ? 4'b0010 :                                   
                           (output3_clock== "3") ? 4'b0011 : 4'b0000;                          
                                                                                               
assign   outreg3_aclr_value = ((output3_clear == "0") ||(output3_clear == "none")) ? 4'b0000 : 
                              (output3_clear == "1") ? 4'b0001 :                               
                              (output3_clear == "2") ? 4'b0010 :                               
                              (output3_clear == "3") ? 4'b0011 : 4'b0000;                      
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg3_clk = clk[outreg3_clk_value] ? 'b1 : 'b0;                                       
assign outreg3_aclr = aclr[outreg3_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg3_ena = ena[outreg3_clk_value] ? 'b1 : 'b0;                                       
assign outreg3_bypass_register = (output3_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
         //Instantiate the output register4                                                    
stratixii_mac_register  output_register4(                                                      
                                        .datain(mac_out_dataout[89:72]),                       
                                        .clk(outreg4_clk),                                     
                                        .aclr(outreg4_aclr),                                   
                                        .ena(outreg4_ena),                                     
                                        .bypass_register(outreg4_bypass_register),             
                                        .dataout(outreg4_dataout)                              
                                       );                                                      
                                                                                               
defparam output_register4.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg4_clk_value =((output4_clock== "0") || (output4_clock== "none")) ? 4'b0000 :      
                          (output4_clock== "1") ? 4'b0001 :                                    
                          (output4_clock== "2") ? 4'b0010 :                                    
                          (output4_clock== "3") ? 4'b0011 : 4'b0000;                           
                                                                                               
assign   outreg4_aclr_value = ((output4_clear == "0") ||(output4_clear == "none")) ? 4'b0000 : 
                              (output4_clear == "1") ? 4'b0001 :                               
                              (output4_clear == "2") ? 4'b0010 :                               
                              (output4_clear == "3") ? 4'b0011 : 4'b0000;                      
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg4_clk = clk[outreg4_clk_value] ? 'b1 : 'b0;                                       
assign outreg4_aclr = aclr[outreg4_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg4_ena = ena[outreg4_clk_value] ? 'b1 : 'b0;                                       
assign outreg4_bypass_register = (output4_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
 //Instantiate the output register5                                                            
stratixii_mac_register  output_register5(                                                      
                                         .datain(mac_out_dataout[107:90]),                     
                                         .clk(outreg5_clk),                                    
                                         .aclr(outreg5_aclr),                                  
                                         .ena(outreg5_ena),                                    
                                         .bypass_register(outreg5_bypass_register),            
                                         .dataout(outreg5_dataout)                             
                                        );                                                     
                                                                                               
defparam output_register5.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg5_clk_value =((output5_clock== "0") || (output5_clock== "none")) ? 4'b0000 :      
                          (output5_clock== "1") ? 4'b0001 :                                    
                          (output5_clock== "2") ? 4'b0010 :                                    
                          (output5_clock== "3") ? 4'b0011 : 4'b0000;                           
                                                                                               
assign   outreg5_aclr_value = ((output5_clear == "0") ||(output5_clear == "none")) ? 4'b0000 : 
                               (output5_clear == "1") ? 4'b0001 :                              
                               (output5_clear == "2") ? 4'b0010 :                              
                               (output5_clear == "3") ? 4'b0011 : 4'b0000;                     
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg5_clk = clk[outreg5_clk_value] ? 'b1 : 'b0;                                       
assign outreg5_aclr = aclr[outreg5_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg5_ena = ena[outreg5_clk_value] ? 'b1 : 'b0;                                       
assign outreg5_bypass_register = (output5_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
        //Instantiate the output register6                                                     
stratixii_mac_register  output_register6(                                                      
                                         .datain(mac_out_dataout[125:108]),                    
                                         .clk(outreg6_clk),                                    
                                         .aclr(outreg6_aclr),                                  
                                         .ena(outreg6_ena),                                    
                                         .bypass_register(outreg6_bypass_register),            
                                         .dataout(outreg6_dataout)                             
                                       );                                                      
                                                                                               
defparam output_register6.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg6_clk_value =((output6_clock== "0") || (output6_clock== "none")) ? 4'b0000 :      
                          (output6_clock== "1") ? 4'b0001 :                                    
                          (output6_clock== "2") ? 4'b0010 :                                    
                          (output6_clock== "3") ? 4'b0011 : 4'b0000;                           
                                                                                               
assign   outreg6_aclr_value = ((output6_clear == "0") ||(output6_clear == "none")) ? 4'b0000 : 
                              (output6_clear == "1") ? 4'b0001 :                               
                              (output6_clear == "2") ? 4'b0010 :                               
                              (output6_clear == "3") ? 4'b0011 : 4'b0000;                      
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg6_clk = clk[outreg6_clk_value] ? 'b1 : 'b0;                                       
assign outreg6_aclr = aclr[outreg6_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg6_ena = ena[outreg6_clk_value] ? 'b1 : 'b0;                                       
assign outreg6_bypass_register = (output6_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
        //Instantiate the output register7                                                     
stratixii_mac_register  output_register7(                                                      
                                         .datain(mac_out_dataout[143:126]),                    
                                         .clk(outreg7_clk),                                    
                                         .aclr(outreg7_aclr),                                  
                                         .ena(outreg7_ena),                                    
                                         .bypass_register(outreg7_bypass_register),            
                                         .dataout(outreg7_dataout)                             
                                        );                                                     
                                                                                               
defparam output_register7.data_width = 18;                                                     
      //decode the clk and aclr values                                                         
assign outreg7_clk_value =((output7_clock== "0") || (output7_clock== "none")) ? 4'b0000 :      
                           (output7_clock== "1") ? 4'b0001 :                                   
                           (output7_clock== "2") ? 4'b0010 :                                   
                           (output7_clock== "3") ? 4'b0011 : 4'b0000;                          
                                                                                               
assign   outreg7_aclr_value = ((output7_clear == "0") ||(output7_clear == "none")) ? 4'b0000 : 
                              (output7_clear == "1") ? 4'b0001 :                               
                              (output7_clear == "2") ? 4'b0010 :                               
                              (output7_clear == "3") ? 4'b0011 : 4'b0000;                      
                                                                                               
        //assign the corresponding clk,aclr,enable and bypass register values.                 
assign outreg7_clk = clk[outreg7_clk_value] ? 'b1 : 'b0;                                       
assign outreg7_aclr = aclr[outreg7_aclr_value] || ~devclrn || ~devpor   ? 'b1 : 'b0;           
assign outreg7_ena = ena[outreg7_clk_value] ? 'b1 : 'b0;                                       
assign outreg7_bypass_register = (output7_clock== "none") ? 'b1 : 'b0;                         
                                                                                               
    //assign the dynamic-mode output                                                                    
assign dataout_dynamic = {outreg7_dataout,outreg6_dataout,outreg5_dataout,outreg4_dataout,              
                               outreg3_dataout,outreg2_dataout,outreg1_dataout,outreg_dataout[17:0]};   
                                                                                                        
    //assign the dataout depending on the mode of operation                                             
assign dataout_tmp = (operation_mode == "dynamic") ? dataout_dynamic : outreg_dataout;                  
assign dataout = dataout_tmp;
    //assign the feedback for accumulator mode of operation
assign mac_out_feedback = dataout_tmp;

endmodule


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_fifo_sync_ram
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_fifo_sync_ram (clk,
                                        datain,
                                        write_reset, 
                                        waddr,
                                        raddr,
                                        we,
                                        dataout
                                       );

//    parameter ram_width = 10;

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
// Module Name : stratixii_lvds_rx_fifo
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_fifo (wclk, 
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

    // BUFFER INPUTS
    wire wclk_in;
    wire rclk_in;
    wire dparst_in;
    wire fiforst_in;
    wire datain_in;
        
    buf (wclk_in, wclk);
    buf (rclk_in, rclk);
    buf (dparst_in, dparst);
    buf (fiforst_in, fiforst);
    buf (datain_in, datain);
        
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

    stratixii_lvds_rx_fifo_sync_ram  s_fifo_ram (.clk(wclk_in),
                                                 .datain(ram_datain),
                                                 .write_reset(write_side_sync_reset), 
                                                 .waddr(wrPtr),
                                                 .raddr(rdAddr), // rdPtr ??
                                                 .we(ram_we),
                                                 .dataout(ram_dataout)
                                                ); 

    // update pointer and RAM input

    always @(wclk_in or dparst_in)
    begin
        if (dparst_in === 1'b1 || (fiforst_in === 1'b1 && wclk_in === 1'b1 && wclk_last_value === 1'b0)) 
        begin
            write_side_sync_reset <= 1'b1;
            ram_datain <= 1'b0;
            wrPtr <= 0;
            ram_we <= 'b0;
        end
        else if (dparst_in === 1'b0 && (fiforst_in === 1'b0 && wclk_in === 1'b1 && wclk_last_value === 1'b0))
        begin
            write_side_sync_reset <= 1'b0;
        end
        if (wclk_in === 1'b1 && wclk_last_value === 1'b0 && write_side_sync_reset === 1'b0 && fiforst_in === 1'b0 && dparst_in === 1'b0)
        begin
            ram_datain <= datain_in;       // input register
            ram_we <= 'b1;
            wrPtr <= wrPtr + 1;
            if (wrPtr == 5)
                wrPtr <= 0;
        end
        wclk_last_value = wclk_in;
    end

    always @(rclk_in or dparst_in)
    begin
        if (dparst_in === 1'b1 || (fiforst_in === 1'b1 && rclk_in === 1'b1 && rclk_last_value === 1'b0))
        begin
            read_side_sync_reset <= 1'b1;
            rdPtr <= 3;
            dataout_tmp <= 0;
        end
        else if (dparst_in === 1'b0 && (fiforst_in === 1'b0 && rclk_in === 1'b1 && rclk_last_value === 1'b0))
        begin
            read_side_sync_reset <= 0;
        end
        if (rclk_in === 1'b1 && rclk_last_value === 1'b0 && read_side_sync_reset === 1'b0 && fiforst_in === 1'b0 && dparst_in === 1'b0)
        begin
            rdPtr <= rdPtr + 1;
            if (rdPtr == 5)
                rdPtr <= 0;
            dataout_tmp <= ram_dataout;     // output register
        end
        rclk_last_value = rclk_in;
    end

    assign data_out = dataout_tmp;

    buf (dataout, data_out);

endmodule // stratixii_lvds_rx_fifo


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_bitslip
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_bitslip (clk0, 
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
 
    // BUFFER INPUTS 
    wire clk0_in;
    wire bslipcntl_in;
    wire bsliprst_in;
    wire datain_in;
   
    buf (clk0_in, clk0);
    buf (bslipcntl_in, bslipcntl);
    buf (bsliprst_in, bsliprst);
    buf (datain_in, datain);
   
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

    stratixii_lvds_reg bslipcntlreg (.d(bslipcntl_in),
                           .clk(clk0_in),
                           .ena(1'b1),
                           .clrn(!bsliprst_in),
                           .prn(1'b1),
                           .q(bslipcntl_reg)
                          );

    // 4-bit slip counter
    always @(bslipcntl_reg or bsliprst_in)
    begin
        if (bsliprst_in === 1'b1)
        begin
            slip_count <= 0;
            bslipmax_tmp <= 1'b0;
            if (bsliprst_in === 1'b1 && bsliprst_last_value === 1'b0)
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
             else begin
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
        bsliprst_last_value <= bsliprst_in;
    end

    // Bit Slip shift register
    always @(clk0_in)
    begin
        if (clk0_in === 1'b1 && clk0_last_value === 1'b0)
        begin
            bitslip_arr[0] <= datain_in;
            for (i = 0; i < bitslip_rollover; i=i+1)
                bitslip_arr[i+1] <= bitslip_arr[i];

            if (start_corrupt_bits == 1'b1)
                num_corrupt_bits <= num_corrupt_bits + 1;
            if (num_corrupt_bits+1 == 3)
                start_corrupt_bits <= 0;
        end

        clk0_last_value <= clk0_in;
    end

    stratixii_lvds_reg dataoutreg (.d(bitslip_arr[slip_count]),
                         .clk(clk0_in),
                         .ena(1'b1),
                         .clrn(1'b1),
                         .prn(1'b1),
                         .q(dataout_tmp)
                        );

    assign dataout_wire = (start_corrupt_bits == 1'b0) ? dataout_tmp : (num_corrupt_bits < 3) ? 1'bx : dataout_tmp;
    assign bslipmax_wire = bslipmax_tmp;

    and (dataout, dataout_wire, 1'b1);
    and (bslipmax, bslipmax_wire, 1'b1);

endmodule // stratixii_lvds_rx_bitslip

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_deser
//
// Description : Timing simulation model for the STRATIXII LVDS RECEIVER
//               Deserializer. This module receives serial data and outputs
//               parallel data word of width = channel_width
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_deser (clk,
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

wire clk_ipd;
wire [channel_width - 1:0] datain_ipd;

buf buf_clk (clk_ipd,clk);
buf buf_datain [channel_width - 1:0] (datain_ipd,datain);
wire  [channel_width - 1:0] dataout_opd;

buf buf_dataout  [channel_width - 1:0] (dataout,dataout_opd);
    
    specify
       (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 'b0;
    end

    always @(clk_ipd or devclrn or devpor)
    begin
        if (devclrn === 1'b0 || devpor === 1'b0)
        begin
            dataout_tmp <= 'b0;
        end
        else if (clk_ipd === 1'b1 && clk_last_value === 1'b0)
        begin
            for (i = (channel_width-1); i > 0; i=i-1)
                dataout_tmp[i] <= dataout_tmp[i-1];

            dataout_tmp[0] <= datain_ipd;
        end

        clk_last_value <= clk_ipd;
    end
    assign dataout_opd = dataout_tmp; 

endmodule //stratixii_lvds_rx_deser

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_parallel_reg
//
// Description : Timing simulation model for the STRATIXII LVDS RECEIVER
//               PARALLEL REGISTER. The data width equals max. channel width,
//               which is 10.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_parallel_reg (clk, 
                                       enable, 
                                       datain, 
                                       dataout, 
//                                       reset,
                                       devclrn, 
                                       devpor
                                      );

    parameter channel_width = 10;

    // INPUT PORTS
    input [channel_width - 1:0] datain;
    input clk;
    input enable;
//    input reset;
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
    specify
       (posedge clk => (dataout +: dataout_tmp)) = (0, 0);
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
        else begin
            if ((clk_ipd === 1) && (clk_last_value !== clk_ipd))
            begin
//                if (reset === 1)
//                begin
//                    dataout_tmp <= 10'b0;
//                end
//                else if (enable_in === 1)
                if (enable_ipd === 1)
                begin
                    dataout_tmp <= datain_ipd;
                end
            end
        end

        clk_last_value <= clk_ipd;

    end //always
    
    assign dataout_opd = dataout_tmp; 

endmodule //stratixii_lvds_rx_parallel_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for registering the enable inputs.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module stratixii_lvds_reg (q,
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

endmodule // stratixii_lvds_reg


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : STRATIXII_LVDS_RECEIVER
//
// Description : Timing simulation model for the STRATIXII LVDS RECEIVER
//               atom. This module instantiates the following sub-modules :
//               1) stratixii_lvds_rx_fifo
//               2) stratixii_lvds_rx_bitslip
//               3) DFFEs for the LOADEN signals
//               4) stratixii_lvds_rx_deser
//               5) stratixii_lvds_rx_parallel_reg
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixii_lvds_receiver (clk0,
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
    parameter lpm_type                  = "stratixii_lvds_receiver";
  
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
 
    tri1 devclrn;
    tri1 devpor;

    // BUFFER INPUTS 
    wire clk0_in;
    wire datain_in;
    wire enable0_in;
    wire dpareset_in;
    wire dpahold_in;
    wire dpaswitch_ipd;
    wire fiforeset_in;
    wire bitslip_in;
    wire bitslipreset_in;
    wire serialfbk_in;

    buf (clk0_in, clk0);
    buf (datain_in, datain);
    buf (enable0_in, enable0);
    buf (dpareset_in, dpareset);
    buf (dpahold_in, dpahold);
    buf (dpaswitch_ipd, dpaswitch);
    buf (fiforeset_in, fiforeset);
    buf (bitslip_in, bitslip);
    buf (bitslipreset_in, bitslipreset);
    buf (serialfbk_in, serialfbk);

    // INTERNAL NETS AND VARIABLES
    wire fifo_wclk;
    wire fifo_rclk;
    wire fifo_datain;
    wire fifo_dataout;
    wire fifo_reset;

    wire slip_datain;
    wire slip_dataout;
    wire bitslip_reset;

    wire [channel_width - 1:0] deser_dataout;
    wire dpareg0_out;
    wire dpareg1_out;
    wire dpa_clk;
    wire dpa_rst;
 
    wire datain_reg;
    wire datain_reg_neg;
    wire datain_reg_tmp;
    reg clk0_last_value;
    reg dpa_is_locked;
    reg dparst_msg;
    reg reset_fifo;
    reg first_dpa_lock;
    reg [3:0] dpa_lock_count;

    wire reset_int;
    wire gnd;
    wire serialdataout_tmp;
    wire postdpaserialdataout_tmp;
    wire in_reg_data;
    wire datain_tmp;
    wire dpalock_tmp;
    wire rxload;

    wire slip_datain_tmp;
    wire s_bitslip_clk;
    wire loaden;

    integer i;

    
// LOCAL_PARAMETERS_BEGIN

    parameter DPA_CYCLES_TO_LOCK = 2;

// LOCAL_PARAMETERS_END


    // TIMING PATHS
    specify
        (posedge clk0 => (dpalock +: dpalock_tmp)) = (0, 0);
    endspecify

    assign gnd = 1'b0;

    // fifo read and write clks
    assign fifo_rclk = (enable_dpa == "on") ? clk0_in : gnd;
    assign fifo_wclk = dpa_clk;

    assign fifo_datain = (enable_dpa == "on") ? dpareg1_out : gnd;

    assign reset_int = (!devpor) || (!devclrn);
    assign fifo_reset = (!devpor) || (!devclrn) || fiforeset_in || reset_fifo;
    assign bitslip_reset = (!devpor) || (!devclrn) || bitslipreset_in;

    assign in_reg_data = (use_serial_feedback_input == "on") ? serialfbk_in : datain_in;

    initial
    begin
        dpa_is_locked = 0;
        dparst_msg = 0;
        first_dpa_lock = 1;
        dpa_lock_count = 0;
        if (reset_fifo_at_first_lock == "on")
            reset_fifo = 1;
        else
            reset_fifo = 0;

        if (enable_dpa == "on")
        begin
            $display("Warning : DPA Phase tracking is not modeled and once locked, DPA will continue to lock until the next reset is asserted. Please refer to the StratixII device handbook for further details.");
            $display("Time: %0t, Instance: %m", $time);
        end
    end

    // SUB-MODULE INSTANTIATION

    // input register in non-DPA mode for sampling incoming data
    stratixii_lvds_reg in_reg (.d(in_reg_data),
                     .clk(clk0_in),
                     .ena(1'b1),
                     .clrn(devclrn || devpor),
                     .prn(1'b1),
                     .q(datain_reg)
                    );
   assign  datain_reg_tmp = datain_reg;
	           
   assign dpa_clk = (enable_dpa == "on") ? clk0_in : 1'b0;

    assign dpa_rst = (enable_dpa == "on") ? dpareset_in : 1'b0;

    always @(posedge dpa_clk or posedge dpa_rst)
    begin
            if (dpa_rst === 1'b1)
            begin
                dpa_is_locked <= 0;
                dpa_lock_count = 0;
                // give message only once
                if (dparst_msg === 1'b0)
                begin
                    $display("DPA was reset");
                    $display("Time: %0t, Instance: %m", $time);
                    dparst_msg = 1;
                end
            end
            else begin
                dparst_msg = 0;
                if (dpa_is_locked === 1'b0)
                begin
                    dpa_lock_count = dpa_lock_count + 1;
                    if (dpa_lock_count > DPA_CYCLES_TO_LOCK)
                    begin
                        dpa_is_locked <= 1;
                        $display("DPA locked");
                        $display("Time: %0t, Instance: %m", $time);
                        reset_fifo <= 0;
                    end
                end
            end
    end

    // ?????????? insert delay to mimic DPLL dataout ?????????

    // DPA registers
    stratixii_lvds_reg dpareg0 (.d(in_reg_data),
                     .clk(dpa_clk),
                     .clrn(1'b1),
                     .prn(1'b1),
                     .ena(1'b1),
                     .q(dpareg0_out)
                    );

    stratixii_lvds_reg dpareg1 (.d(dpareg0_out),
                     .clk(dpa_clk),
                     .clrn(1'b1),
                     .prn(1'b1),
                     .ena(1'b1),
                     .q(dpareg1_out)
                    );

    stratixii_lvds_rx_fifo    s_fifo (.wclk(fifo_wclk),
                                      .rclk(fifo_rclk),
                                      .fiforst(fifo_reset),
                                      .dparst(dpa_rst),
                                      .datain(fifo_datain),
                                      .dataout(fifo_dataout)
                                     );
    defparam s_fifo.channel_width = channel_width;

    assign slip_datain_tmp = (enable_dpa == "on" && dpaswitch_ipd === 1'b1) ? fifo_dataout : datain_reg_tmp;
  assign slip_datain = slip_datain_tmp; 

    assign s_bitslip_clk = clk0_in; 

    stratixii_lvds_rx_bitslip    s_bslip (.clk0(s_bitslip_clk),
                                          .bslipcntl(bitslip_in),
                                          .bsliprst(bitslip_reset),
                                          .datain(slip_datain),
                                          .bslipmax(bitslipmax),
                                          .dataout(slip_dataout)
                                         );
    defparam s_bslip.channel_width = channel_width;
    defparam s_bslip.bitslip_rollover = data_align_rollover;
    defparam s_bslip.x_on_bitslip = x_on_bitslip;


    //********* DESERIALISER *********//
 assign loaden = enable0_in; 

    // only 1 enable signal used for StratixII
    stratixii_lvds_reg rxload_reg (.d(loaden),
                     .clk(s_bitslip_clk),
                     .ena(1'b1),
                     .clrn(1'b1),
                     .prn(1'b1),
                     .q(rxload)
                    );
    
    
    stratixii_lvds_rx_deser    s_deser (.clk(s_bitslip_clk),
                                        .datain(slip_dataout),
                                        .devclrn(devclrn),
                                        .devpor(devpor),
                                        .dataout(deser_dataout)
                                       );
    defparam s_deser.channel_width = channel_width;

    stratixii_lvds_rx_parallel_reg  output_reg  (.clk(s_bitslip_clk),
                                               .enable(rxload),
                                               .datain(deser_dataout), 
                                               .devpor(devpor),
                                               .devclrn(devclrn),
                                               .dataout(dataout)
                                              );
    defparam output_reg.channel_width = channel_width;


    // generate outputs
    assign dpalock_tmp = (enable_dpa == "on") ? dpa_is_locked : gnd;

    assign postdpaserialdataout_tmp = dpareg1_out;
    assign datain_tmp = datain_in;
    and (postdpaserialdataout, postdpaserialdataout_tmp, 1'b1);
    and (serialdataout, datain_tmp, 1'b1);
    and (dpalock, dpalock_tmp, 1'b1);

endmodule // stratixii_lvds_receiver
///////////////////////////////////////////////////////////////////////
//
//              	STRATIXII RUBLOCK ATOM 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  stratixii_rublock 
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
	parameter lpm_type					= "stratixii_rublock";

	input clk;
	input shiftnld;
	input captnupdt;
	input regin;
	input rsttimer;
	input rconfig;

	output regout;
	output [2:0] pgmout;

	reg [20:0] update_reg;
	reg [4:0] status_reg;
	reg [25:0] shift_reg;

	reg [2:0] pgmout_update;

	integer i;

	// initialize registers
	initial
	begin
		if (operation_mode == "local")
			// PGM[] output
			pgmout_update = 1;	
		else if (operation_mode == "remote")
			// PGM[] output
			pgmout_update = 0;	
		else
			pgmout_update <= 'bx;			


		// Shift reg
		shift_reg = 0;

		// Status reg
		status_reg = sim_init_status;
		
		// wd_timeout field
		update_reg[20:9] = sim_init_watchdog_value;

		// wd enable field
		if (sim_init_watchdog_value > 0)
			update_reg[8] = 1;
		else
			update_reg[8] = 0;
		
		// PGM[] field
		update_reg[7:1] = sim_init_page_select;

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
		$display("        -> Field PGM[] Page Select is set to %d", update_reg[7:1]);
		$display("        -> Field User Watchdog is set to %s", update_reg[8] ? "Enabled" : "Disabled");
		$display("        -> Field User Watchdog Timeout Value is set to %d", update_reg[20:9]);

	end

	// regout is output of shift-reg bit 0
	// note that in Stratix, there is an inverter to regout.
	// but in Stratix II, there is no inverter.
	assign regout = shift_reg[0];

	// pgmout is set when reconfig is asserted
	assign pgmout = pgmout_update;

	always @(clk)
	begin
		if (clk == 1)
		begin
			if (shiftnld == 1)
			begin
				// register shifting
				for (i=0; i<=24; i=i+1)
				begin
					shift_reg[i] <= shift_reg[i+1];
				end

				shift_reg[25] <= regin;
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

					if ( (operation_mode == "remote" || operation_mode =="active_serial_remote")
							&& sim_init_config == "factory")
					begin
						// every bit in Update Reg gets updated
						update_reg[20:0] <= shift_reg[25:5];

						$display("Info: Remote Update Block: Update Register updated at time %d ps", $time);
						$display("        -> Field Configuration Mode is set to %s", shift_reg[5] ? "Application" : "Factory");
						$display("        -> Field PGM[] Page Select is set to %d", shift_reg[12:6]);
						$display("        -> Field User Watchdog is set to %s", (shift_reg[13] == 1) ? "Enabled" : (shift_reg[13] == 0) ? "Disabled" : "x");
						$display("        -> Field User Watchdog Timeout Value is set to %d", shift_reg[25:14]);
					end
					else
					begin
						// trying to do update in Application mode
						$display("Warning: Remote Update Block: Attempted update of Update Register at time %d ps when Configuration is set to Application", $time);
					end

				end
				else
				begin
					// invalid captnupdt
					// destroys update and shift regs
					shift_reg <= 'bx;
					if (sim_init_config == "factory")
					begin
						update_reg[20:1] <= 'bx;
					end
				end
			end
			else
			begin
				// invalid shiftnld: destroys update and shift regs
				shift_reg <= 'bx;
				if (sim_init_config == "factory")
				begin
					update_reg[20:1] <= 'bx;
				end
			end
		end
		else if (clk != 0)
		begin
			// invalid clk: destroys registers
			shift_reg <= 'bx;
			if (sim_init_config == "factory")
			begin
				update_reg[20:1] <= 'bx;
			end
		end
	end

	always @(rconfig)
	begin
		if (rconfig == 1)
		begin
			// start reconfiguration
			$display("Info: Remote Update Block: Reconfiguration initiated at time %d ps", $time);
			$display("        -> Field Configuration Mode is set to %s", update_reg[0] ? "Application" : "Factory");
			$display("        -> Field PGM[] Page Select is set to %d", update_reg[7:1]);
			$display("        -> Field User Watchdog is set to %s", (update_reg[8] == 1) ? "Enabled" : (update_reg[8] == 0) ? "Disabled" : "x");
			$display("        -> Field User Watchdog Timeout Value is set to %d", update_reg[20:9]);

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
// Module Name : stratixii_termination_digital
//
// Description : Simualtion model for digital portion of 
//               StratixII Calibration Block 
//
// ** Note **  : Termination calibration block does not have
//               digital outputs that are observable in PLD by
//               users. The model below is for internal verification.
//               
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixii_termination_digital (
    rin,
    clk,
    clr,
    ena,
    padder,
    devpor,
    devclrn,
     
    ctrlout);
    
input         rin;
input 	      clk;
input 	      clr;
input 	      ena;
input [6:0]   padder;
input         devpor;
input         devclrn;

output [6:0]  ctrlout;

parameter runtime_control = "false";
parameter use_core_control = "false";
parameter use_both_compares = "false";
parameter pull_adder = 0;
parameter power_down = "true";
parameter left_shift = "false";
parameter test_mode = "false";

// internal variables

reg       rin_reg_n;
reg [6:0] counter1;

// pattern detect
reg  pdetect_reg_n;
reg  pdetect_reg_1;
reg  pdetect_reg_2;
wire pdetect_out;

wire pre_adder_reg_n_ena;
reg [6:0]  pre_adder_reg_n;

wire pre_adder_reg_ena;
reg [6:0] pre_adder_reg;

wire [6:0] adder_in;
wire [6:0] adder1; 

// Model
initial
begin
    rin_reg_n = 1'b0;
    counter1 = 7'b1000000;
    pdetect_reg_n = 1'b0;
    pdetect_reg_1 = 1'b0;
    pdetect_reg_2 = 1'b0;
    pre_adder_reg_n = 7'b0100000;
    pre_adder_reg = 7'b0100000;
end

assign ctrlout = (use_core_control == "true") ? padder : adder1;

// negative-edge register
always @(negedge clk or posedge clr)
begin
    if (clr === 1'b1)
        rin_reg_n <= 1'b0;
    else
        rin_reg_n <= rin;
end

// counter
always @(posedge clk or posedge clr)
begin
    if (clr === 1'b1)
        counter1 <= 7'b1000000;
    else if (ena === 1'b1)
    begin
        if (rin_reg_n === 1'b0 && counter1 > 7'b000000)
            counter1 <= counter1 - 7'b0000001;
        else if (rin_reg_n === 1'b1 && counter1 < 7'b1111111)
            counter1 <= counter1 + 7'b0000001;       
    end
end

// 01 patter detector
assign pdetect_out = ((pdetect_reg_2 === 1'b0) && (pdetect_reg_1 === 1'b1))? 1'b1 : 1'b0;

always @(negedge clk)
    pdetect_reg_n <= rin_reg_n;

always @(posedge clk)
begin
    pdetect_reg_1 <= rin_reg_n;
    pdetect_reg_2 <= pdetect_reg_1;
end

// pre adder registers
assign pre_adder_reg_n_ena = (test_mode === "true") ? ena
                             : (ena && pdetect_out);
always @(negedge clk or posedge clr)
begin
    if (clr === 1'b1)
        pre_adder_reg_n <= 7'b0100000;
    else if (pre_adder_reg_n_ena === 1'b1)
        pre_adder_reg_n <= counter1;
end

// 0101/1010 pdetector always returns false

// adder
assign adder_in = (left_shift === "false") ? pre_adder_reg_n
                  : (pre_adder_reg_n << 1);

// no clock for adder
assign adder1 = adder_in + pull_adder;

    
endmodule

//------------------------------------------------------------------
//
// Module Name : stratixii_termination
//
// Description : StratixII Termination Atom Verilog simulation model 
//
// ** Note **  : Termination calibration block does not have
//               digital outputs that are observable in PLD by
//               users. The model below is for internal verification.
//               
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module stratixii_termination (
    rup,
    rdn,
    terminationclock,
    terminationclear,
    terminationenable,
    terminationpullup,
    terminationpulldown,
    devpor,
    devclrn,
     
    incrup,
    incrdn,
    terminationcontrol,
    terminationcontrolprobe);
    
input         rup;
input 	      rdn;
input 	      terminationclock;
input 	      terminationclear;
input 	      terminationenable;
input [6:0]   terminationpullup;
input [6:0]   terminationpulldown;
input         devpor;
input         devclrn;

output 	      incrup;
output 	      incrdn;
output [13:0] terminationcontrol;
output [6:0]  terminationcontrolprobe;
  
parameter runtime_control = "false";
parameter use_core_control = "false";
parameter pullup_control_to_core = "true";
parameter use_high_voltage_compare = "true";
parameter use_both_compares = "false";
parameter pullup_adder = 0;
parameter pulldown_adder = 0;
parameter half_rate_clock = "false";
parameter power_down = "true";
parameter left_shift = "false";
parameter test_mode = "false";
parameter lpm_type = "stratixii_termination";
   
tri1 devclrn;
tri1 devpor;

// BUFFERED BUS INPUTS
wire       rup_in;
wire 	   rdn_in;
wire 	   clock_in;
wire 	   clear_in;
wire 	   enable_in;
wire [6:0] pullup_in;
wire [6:0] pulldown_in;

// TMP OUTPUTS
wire        incrup_out;
wire        incrdn_out;
wire [13:0] control_out;
wire [6:0]  controlprobe_out;

wire [6:0]  rup_control_out;
wire [6:0]  rdn_control_out;

wire        ena1;

// FUNCTIONS


// INTERNAL NETS AND VARIABLES

// TIMING HOOKS   
buf (rup_in, rup);
buf (rdn_in, rdn);
buf (clock_in,terminationclock);
buf (clear_in,terminationclear);
buf (enable_in,terminationenable);
buf buf_pullup [6:0] (pullup_in, terminationpullup);
buf buf_pulldn [6:0] (pulldown_in, terminationpulldown);

specify
    (posedge terminationclock => (terminationcontrol +: control_out)) = (0,0);
    (posedge terminationclock => (terminationcontrolprobe +: controlprobe_out)) = (0,0);    
endspecify

// output driver
buf buf_ctrl_out [13:0] (terminationcontrol,control_out);
buf buf_ctrlprobe_out [6:0] (terminationcontrolprobe,controlprobe_out);


// MODEL
assign incrup = incrup_out;
assign incrdn = incrdn_out;
assign incrup_out = (power_down == "true") ? (enable_in & rup_in) : rup_in;
assign incrdn_out = (power_down == "true") ? ~(enable_in & rdn_in) : ~rdn_in;

assign control_out = {rup_control_out, rdn_control_out};
assign controlprobe_out =  pullup_control_to_core == "true" ? 
                           rdn_control_out : rup_control_out;
                                
assign ena1 = (runtime_control === "true")? enable_in : 1'b0;

stratixii_termination_digital rup_block(
    .rin(incrup_out),
    .clk(clock_in),
    .clr(clear_in),
    .ena(ena1),
    .padder(pulldown_in),
    .devpor(devpor),
    .devclrn(devclrn),
    
    .ctrlout(rup_control_out)
);
defparam rup_block.runtime_control = runtime_control;
defparam rup_block.use_core_control = use_core_control;
defparam rup_block.use_both_compares = use_both_compares;
defparam rup_block.pull_adder = pulldown_adder;
defparam rup_block.power_down = power_down;
defparam rup_block.left_shift = left_shift;
defparam rup_block.test_mode = test_mode;
    
stratixii_termination_digital rdn_block(
    .rin(incrdn_out),
    .clk(clock_in),
    .clr(clear_in),
    .ena(ena1),
    .padder(pullup_in),
    .devpor(devpor),
    .devclrn(devclrn),
    
    .ctrlout(rdn_control_out)
);
defparam rdn_block.runtime_control = runtime_control;
defparam rdn_block.use_core_control = use_core_control;
defparam rdn_block.use_both_compares = use_both_compares;
defparam rdn_block.pull_adder = pullup_adder;
defparam rdn_block.power_down = power_down;
defparam rdn_block.left_shift = left_shift;
defparam rdn_block.test_mode = test_mode;

endmodule

//------------------------------------------------------------------
//
// Module Name : stratixii_routing_wire
//
// Description : Simulation model for a simple routing wire
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module stratixii_routing_wire (
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

endmodule // stratixii_routing_wire
