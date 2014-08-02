// Copyright (C) 1991-2006 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.


// Quartus II 6.0 Build 202 04/27/2006


// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

primitive CYCLONEII_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
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

module cycloneii_dffe ( Q, CLK, ENA, D, CLRN, PRN );
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
   
   CYCLONEII_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
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

// ***** cycloneii_latch

module cycloneii_latch(D, ENA, PRE, CLR, Q);
   
   input D;
   input ENA, PRE, CLR;
   output Q;
   
   reg 	  q_out;
   
   specify
      $setup (D, posedge ENA, 0) ;
      $hold (negedge ENA, D, 0) ;
      
      (D => Q) = (0, 0);
      (posedge ENA => (Q +: q_out)) = (0, 0);
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
	 q_out = 1'b0;
      end
   
   always @(D_in or ENA_in or PRE_in or CLR_in)
      begin
	 if (PRE_in == 1'b0)
	    begin
	       // latch being preset, preset is active low
	       q_out = 1'b1;
	    end
	 else if (CLR_in == 1'b0)
	    begin
	       // latch being cleared, clear is active low
	       q_out = 1'b0;
	    end
	      else if (ENA_in == 1'b1)
		 begin
		    // latch is transparent
		    q_out = D_in;
		 end
      end
   
   and (Q, q_out, 1'b1);
   
endmodule

// ***** cycloneii_mux21

module cycloneii_mux21 (MO, A, B, S);
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

// ***** cycloneii_mux41

module cycloneii_mux41 (MO, IN0, IN1, IN2, IN3, S);
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

// ***** cycloneii_and1

module cycloneii_and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** cycloneii_and16

module cycloneii_and16 (Y, IN1);
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

// ***** cycloneii_bmux21

module cycloneii_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** cycloneii_b17mux21

module cycloneii_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** cycloneii_nmux21

module cycloneii_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** cycloneii_b5mux21

module cycloneii_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********



//--------------------------------------------------------------------------
// Module Name     : cycloneii_ram_pulse_generator
// Description     : Generate pulse to initiate memory read/write operations
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneii_ram_pulse_generator (
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

//--------------------------------------------------------------------------
// Module Name     : cycloneii_ram_register
// Description     : Register module for RAM inputs/outputs
//--------------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneii_ram_register (
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
// Module Name     : cycloneii_ram_block
// Description     : Main RAM module
//--------------------------------------------------------------------------

module cycloneii_ram_block 
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
   
parameter port_a_data_in_clear = "none";
parameter port_a_address_clear = "none";
parameter port_a_write_enable_clear = "none";
parameter port_a_data_out_clear = "none";
parameter port_a_byte_enable_clear = "none";

parameter port_a_data_in_clock = "clock0";
parameter port_a_address_clock = "clock0";
parameter port_a_write_enable_clock = "clock0";
parameter port_a_byte_enable_clock = "clock0";

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
   
parameter port_b_data_in_clock = "clock0";
parameter port_b_address_clock = "clock0";
parameter port_b_read_enable_write_enable_clock = "clock0";
parameter port_b_byte_enable_clock = "none";
parameter port_b_data_out_clock = "none";

parameter port_b_data_width = 1;
parameter port_b_address_width = 1; 
parameter port_b_byte_enable_mask_width = 1; 

parameter power_up_uninitialized = "false";
parameter lpm_type = "cycloneii_ram_block";
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
parameter safe_write = "err_on_2clk";

// -------- LOCAL PARAMETERS ---------
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
   input      portaaddrstall;
   input      portbaddrstall;
output [port_a_data_width - 1:0] portadataout;
output [port_b_data_width - 1:0] portbdataout; 

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
integer i,j,k;
integer addr_range_init;
reg [data_width - 1:0] init_mem_word;
reg [(port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1:0] mem_init;

// port active for read/write
wire  active_a,active_a_in,active_b,active_b_in;
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

assign clk_a_in      = clk0;
assign clk_a_byteena = (port_a_byte_enable_clock == "none") ? 1'b0 : clk_a_in;
assign clk_a_out     = (port_a_data_out_clock == "none")    ? 1'b0 : (
                       (port_a_data_out_clock == "clock0")  ? clk0 : clk1);
            
assign clk_b_in      = (port_b_read_enable_write_enable_clock == "clock0") ? clk0 : clk1;
assign clk_b_byteena = (port_b_byte_enable_clock == "none")   ? 1'b0 : (
                       (port_b_byte_enable_clock == "clock0") ? clk0 : clk1);
assign clk_b_out     = (port_b_data_out_clock == "none")      ? 1'b0 : (
                       (port_b_data_out_clock == "clock0")    ? clk0 : clk1);
            
assign addr_a_clr_in = (port_a_address_clear == "none")   ? 1'b0 : clr0;
assign addr_b_clr_in = (port_b_address_clear == "none")   ? 1'b0 : (
                       (port_b_address_clear == "clear0") ? clr0 : clr1);
    
assign datain_a_clr_in  = (port_a_data_in_clear == "none")    ? 1'b0 : clr0;
assign dataout_a_clr    = (port_a_data_out_clear == "none")   ? 1'b0 : (
                          (port_a_data_out_clear == "clear0") ? clr0 : clr1);
            
assign datain_b_clr_in  = (port_b_data_in_clear == "none")    ? 1'b0 : (
                          (port_b_data_in_clear == "clear0")  ? clr0 : clr1);
assign dataout_b_clr    = (port_b_data_out_clear == "none")   ? 1'b0 : (
                          (port_b_data_out_clear == "clear0") ? clr0 : clr1);
    
assign byteena_a_clr_in = (port_a_byte_enable_clear == "none")   ? 1'b0 : clr0;
assign byteena_b_clr_in = (port_b_byte_enable_clear == "none")   ? 1'b0 : (
                          (port_b_byte_enable_clear == "clear0") ? clr0 : clr1);
            
assign we_a_clr_in      = (port_a_write_enable_clear == "none") ? 1'b0 : clr0;
assign rewe_b_clr_in    = (port_b_read_enable_write_enable_clear == "none")   ? 1'b0 : (
                          (port_b_read_enable_write_enable_clear == "clear0") ? clr0 : clr1);

     assign active_a_in = ena0 || (port_a_disable_ce_on_input_registers == "on");
     assign active_b_in = ((port_b_read_enable_write_enable_clock == "clock0") ? ena0 : ena1) ||
                           (port_b_disable_ce_on_input_registers == "on");

// Store clock enable value for SEAB/MEAB
// port A active
cycloneii_ram_register active_port_a (
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
cycloneii_ram_register active_port_b (
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
cycloneii_ram_register we_a_register (
        .d(mode_is_rom ? 1'b0 : portawe),
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
cycloneii_ram_register addr_a_register (
        .d(portaaddr),
        .clk(clk_a_in),
        .aclr(addr_a_clr_in),
        .devclrn(devclrn),.devpor(devpor),
 .stall(portaaddrstall),
        .ena(active_a_in),
        .q(addr_a_reg),
        .aclrout(addr_a_clr)
        );
defparam addr_a_register.width = port_a_address_width;

// data
cycloneii_ram_register datain_a_register (
        .d(portadatain),
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
cycloneii_ram_register byteena_a_register (
        .d(portabyteenamasks),
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
cycloneii_ram_register rewe_b_register (
        .d(portbrewe),
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
cycloneii_ram_register addr_b_register (
        .d(portbaddr),
        .clk(clk_b_in),
        .aclr(addr_b_clr_in),
        .devclrn(devclrn),
        .devpor(devpor),
 .stall(portbaddrstall),
        .ena(active_b_in),
        .q(addr_b_reg),
        .aclrout(addr_b_clr)
        );
defparam addr_b_register.width = port_b_address_width;

// data
cycloneii_ram_register datain_b_register (
        .d(portbdatain),
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
cycloneii_ram_register byteena_b_register (
        .d(portbbyteenamasks),
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
cycloneii_ram_pulse_generator wpgen_a (
        .clk(ram_type ? clk_a_in : ~clk_a_in),
        .ena(active_write_a & we_a_reg),
        .pulse(write_pulse_a),
        .cycle(write_cycle_a)
        );

cycloneii_ram_pulse_generator wpgen_b (
        .clk(ram_type ? clk_b_in : ~clk_b_in),
        .ena(active_write_b & mode_is_bdp & rewe_b_reg),
        .pulse(write_pulse_b),
        .cycle(write_cycle_b)
        );
    
// Read pulse generation
cycloneii_ram_pulse_generator rpgen_a (
        .clk(clk_a_in),
        .ena(active_a & ~we_a_reg),
        .pulse(read_pulse_a),.cycle()
        );
    
cycloneii_ram_pulse_generator rpgen_b (
        .clk(clk_b_in),
        .ena(active_b & (mode_is_dp ? rewe_b_reg : ~rewe_b_reg)),
        .pulse(read_pulse_b),.cycle()
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
    for (i = 0; i < port_b_data_width; i = i + 1)
    begin
        mask_vector_b[i]     = (byteena_b_reg[i/byte_size_b] === 1'b1) ? 1'b0 : 1'bx;
        mask_vector_b_int[i] = (byteena_b_reg[i/byte_size_b] === 1'b0) ? 1'b0 : 1'bx;
    end
end
                        
always @(posedge write_pulse_prime or posedge write_pulse_sec or 
         posedge read_pulse_prime or posedge read_pulse_sec) 
begin
    // Write stage 1 : write X to memory
    if (write_pulse_prime) 
    begin
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
    if (read_pulse_prime) read_data_latch = mem[addr_prime_reg];
    if (read_pulse_sec) 
    begin
        row_sec = addr_sec_reg / num_cols; col_sec = (addr_sec_reg % num_cols) * data_unit_width;
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
cycloneii_ram_pulse_generator ftpgen_a (
        .clk(clk_a_in), 
        .ena(active_a & ~mode_is_dp & we_a_reg),
        .pulse(read_pulse_a_feedthru),.cycle()
        );
    
cycloneii_ram_pulse_generator ftpgen_b (
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

// -------- Async clear logic ---------

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
            read_data_latch = 'bx;
        else
            read_unit_data_latch = 'bx;
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
            read_data_latch = 'bx;
        else
            read_unit_data_latch = 'bx;
    end
end

assign active_write_clear_b = active_write_b & write_cycle_b;

always @(posedge addr_b_clr or posedge datain_b_clr or posedge rewe_b_clr)
    clear_asserted_during_write_b = write_pulse_b;
         
always @(posedge addr_b_clr)
begin
    if (mode_is_bdp & active_write_clear_b & rewe_b_reg)
        mem_invalidate = 1'b1;
    else if (active_b & (mode_is_dp & rewe_b_reg || mode_is_bdp & ~rewe_b_reg))
    begin
        if (primary_port_is_b)
            read_data_latch = 'bx;
        else
            read_unit_data_latch = 'bx;
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
            read_data_latch = 'bx;
        else
            read_unit_data_latch = 'bx;
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
                          ena0 || (port_a_disable_ce_on_output_registers == "on") :
                          ena1 || (port_a_disable_ce_on_output_registers == "on") ;
                  
cycloneii_ram_register dataout_a_register (
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
                          ena0 || (port_b_disable_ce_on_output_registers == "on") :
                          ena1 || (port_b_disable_ce_on_output_registers == "on") ;
  
cycloneii_ram_register dataout_b_register (
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

endmodule // cycloneii_ram_block

//--------------------------------------------------------------------
//
// Module Name : cycloneii_jtag
//
// Description : CycloneII JTAG Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  cycloneii_jtag (tms, tck, tdi, ntrst, tdoutap, tdouser, tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser, updateuser, runidleuser, usr1user);

	input    tms, tck, tdi, ntrst, tdoutap, tdouser;

	output   tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser;
	output	updateuser, runidleuser, usr1user;

   parameter lpm_type = "cycloneii_jtag";

	initial
	begin
	end

	always @(tms or tck or tdi or ntrst or tdoutap or tdouser) 
	begin 
	end

endmodule

//--------------------------------------------------------------------
//
// Module Name : cycloneii_crcblock
//
// Description : CycloneII CRCBLOCK Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  cycloneii_crcblock 
	(
	clk,
	shiftnld,
	ldsrc,
	crcerror,
	regout
	);

input clk;
input shiftnld;
input ldsrc;

output crcerror;
output regout;

parameter oscillator_divider = 1;
parameter lpm_type = "cycloneii_crcblock";

endmodule

//---------------------------------------------------------------------
//
// Module Name : cycloneii_asmiblock
//
// Description : CycloneII ASMIBLOCK Verilog Simulation model
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module  cycloneii_asmiblock 
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

parameter lpm_type = "cycloneii_asmiblock";

endmodule  // cycloneii_asmiblock
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneii_m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the CycloneII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module cycloneii_m_cntr   ( clk,
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
            if (clk == 1 && clk_last_value !== clk && first_rising_edge)
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
        clk_last_value = clk;

//        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // cycloneii_m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneii_n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the CycloneII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module cycloneii_n_cntr   ( clk,
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

endmodule // cycloneii_n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneii_scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the C0, C1, C2, C3, C4 and
//               C5 output counters of the CycloneII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module cycloneii_scale_cntr   ( clk,
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

endmodule // cycloneii_scale_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneii_pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module cycloneii_pll_reg  ( q,
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

endmodule // cycloneii_pll_reg

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : cycloneii_pll
//
// Description : Timing simulation model for the CycloneII PLL.
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

module cycloneii_pll (inclk,
                    ena,
                    clkswitch,
                    areset,
                    pfdena,
                    testclearlock,
                    clk,
                    locked,
                    testupout,
                    testdownout,
                    sbdin,
                    sbdout
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

    parameter switch_over_type                     = "manual";
    parameter switch_over_on_lossclk               = "off";
    parameter switch_over_on_gated_lock            = "off";
    parameter switch_over_counter                  = 1;
    parameter enable_switch_over_counter           = "on";

    parameter bandwidth                            = 0;
    parameter bandwidth_type                       = "auto";
    parameter down_spread                          = "0.0";
    parameter spread_frequency                     = 0;
    parameter common_rx_tx                         = "off";
    parameter rx_outclock_resource                 = "auto";
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
    parameter m = 1;
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
    parameter vco_multiply_by = 0;
    parameter vco_divide_by = 0;
    parameter vco_post_scale = 1;

    parameter charge_pump_current = 0;
    parameter loop_filter_r = "1.0";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "functional";
    parameter lpm_type = "cycloneii_pll";

    //parameter for cycloneii lvds
    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;

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

    // INPUT PORTS
    input [1:0] inclk;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input testclearlock;
    input sbdin;

    // OUTPUT PORTS
    output [2:0] clk;
    output locked;
    output sbdout;
    // lvds specific output ports
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
    wire sbdin_ipd;
    buf (inclk0_ipd, inclk[0]);
    buf (inclk1_ipd, inclk[1]);
    buf (ena_ipd, ena);
    buf (fbin_ipd, 1'b0);
    buf (clkswitch_ipd, clkswitch);
    buf (areset_ipd, areset);
    buf (pfdena_ipd, pfdena);
    buf (scanclk_ipd, 1'b0);
    buf (scanread_ipd, 1'b0);
    buf (scanwrite_ipd, 1'b0);
    buf (scandata_ipd, 1'b0);
    buf (sbdin_ipd, sbdin);

    // TIMING CHECKS
    specify
        (sbdin => sbdout) = (0, 0);
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

    wire inclk_m;
    wire [5:0] clk_tmp;

    wire ena_pll;
    wire n_cntr_inclk;

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

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    wire refclk;
    wire fbclk;
    
    wire pllena_reg;
    wire test_mode_inclk;
    wire sbdout_tmp;

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

    // INTERNAL PARAMETERS
    parameter GPP_SCAN_CHAIN = 174;
    parameter FAST_SCAN_CHAIN = 75;
    // primary clk is always inclk0
    parameter primary_clock = "inclk0";

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

    integer current_clock;
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
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
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
        counter_ph = (phase % 360)/45;
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

    // this is for cycloneii lvds only
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
        l_primary_clock              = alpha_tolower(primary_clock);
        l_gate_lock_signal           = alpha_tolower(gate_lock_signal);
        l_switch_over_on_lossclk     = alpha_tolower(switch_over_on_lossclk);
        l_switch_over_on_gated_lock  = alpha_tolower(switch_over_on_gated_lock);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_switch_over_type           = alpha_tolower(switch_over_type);
        l_feedback_source            = alpha_tolower(feedback_source);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);


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
        else op_mode = 0;

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

        if (m_test_source == 1 || c0_test_source == 1 || c0_test_source == 2 || c1_test_source == 1 || c1_test_source == 2 || c2_test_source == 1 || c2_test_source == 2)
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
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (l_switch_over_on_lossclk == "on" && primary_clk_is_bad && l_pll_type !== "fast" && l_pll_type !== "lvds" && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
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


    cycloneii_pll_reg ena_reg ( .clk(!inclk_n),
                                .ena(1'b1),
                                .d(ena_ipd),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .q(pllena_reg));

    and (test_mode_inclk, inclk_n, pllena_reg);
    assign n_cntr_inclk = inclk_n;
    assign ena_pll = ena_ipd;


    assign inclk_m = (m_test_source == 1) ? refclk : (m_test_source == 2) ? 1'b0 : (m_test_source == 3) ? 1'b0 : op_mode == 1 ? (l_feedback_source == "clk0" ? clk_tmp[0] :
                        l_feedback_source == "clk1" ? clk_tmp[1] :
                        l_feedback_source == "clk2" ? clk_tmp[2] :
                        l_feedback_source == "clk3" ? clk_tmp[3] :
                        l_feedback_source == "clk4" ? clk_tmp[4] :
                        l_feedback_source == "clk5" ? clk_tmp[5] : 'b0) :
                        inclk_m_from_vco;

    cycloneii_m_cntr m1 (.clk(inclk_m),
                        .reset(areset_ipd || (!ena_pll) || stop_vco),
                        .cout(fbclk),
                        .initial_value(m_initial_val),
                        .modulus(m_val[0]),
                        .time_delay(m_delay));

    cycloneii_n_cntr n1 (.clk(n_cntr_inclk),
                        .reset(areset_ipd),
                        .cout(refclk),
                        .modulus(n_val[0]));


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
                end
                if (c_ph_val[1] == x)
                begin
                    inclk_c1_from_vco <= vco_tap[x];
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

    assign inclk_c0 = (c0_test_source == 1) ? refclk : (c0_test_source == 2) ? fbclk : (c0_test_source == 3) ? 1'b0 : inclk_c0_from_vco;

    cycloneii_scale_cntr c0 (.clk(inclk_c0),
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
            c_high_val_hold[0] <= c_high_val_tmp[0];
            c_mode_val_hold[0] <= c_mode_val_tmp[0];
            c_high_val[0] <= c_high_val_hold[0];
            c_mode_val[0] <= c_mode_val_hold[0];
            c0_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c0_clk)
    begin
        if (c0_rising_edge_transfer_done)
        begin
            c_low_val_hold[0] <= c_low_val_tmp[0];
            c_low_val[0] <= c_low_val_hold[0];
        end
    end

    assign inclk_c1 = (c1_test_source == 1) ? refclk : (c1_test_source == 2) ? fbclk : (c1_test_source == 3) ? 1'b0 : (ic1_use_casc_in == 1) ? c0_clk : inclk_c1_from_vco;

    cycloneii_scale_cntr c1 (.clk(inclk_c1),
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
            c_high_val_hold[1] <= c_high_val_tmp[1];
            c_mode_val_hold[1] <= c_mode_val_tmp[1];
            c_high_val[1] <= c_high_val_hold[1];
            c_mode_val[1] <= c_mode_val_hold[1];
            c1_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c1_clk)
    begin
        if (c1_rising_edge_transfer_done)
        begin
            c_low_val_hold[1] <= c_low_val_tmp[1];
            c_low_val[1] <= c_low_val_hold[1];
        end
    end

    assign inclk_c2 = (c2_test_source == 1) ? refclk : (c2_test_source == 2) ? fbclk : (c2_test_source == 3) ? 1'b0 : (ic2_use_casc_in == 1) ? c1_clk : inclk_c2_from_vco;

    cycloneii_scale_cntr c2 (.clk(inclk_c2),
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
            c_high_val_hold[2] <= c_high_val_tmp[2];
            c_mode_val_hold[2] <= c_mode_val_tmp[2];
            c_high_val[2] <= c_high_val_hold[2];
            c_mode_val[2] <= c_mode_val_hold[2];
            c2_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c2_clk)
    begin
        if (c2_rising_edge_transfer_done)
        begin
            c_low_val_hold[2] <= c_low_val_tmp[2];
            c_low_val[2] <= c_low_val_hold[2];
        end
    end

    assign inclk_c3 = (c3_test_source == 0) ? n_cntr_inclk : (ic3_use_casc_in == 1) ? c2_clk : inclk_c3_from_vco;
    cycloneii_scale_cntr c3 (.clk(inclk_c3),
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
            c_high_val_hold[3] <= c_high_val_tmp[3];
            c_mode_val_hold[3] <= c_mode_val_tmp[3];
            c_high_val[3] <= c_high_val_hold[3];
            c_mode_val[3] <= c_mode_val_hold[3];
            c3_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c3_clk)
    begin
        if (c3_rising_edge_transfer_done)
        begin
            c_low_val_hold[3] <= c_low_val_tmp[3];
            c_low_val[3] <= c_low_val_hold[3];
        end
    end

    assign inclk_c4 = ((c4_test_source == 0) ? n_cntr_inclk : (ic4_use_casc_in == 1) ? c3_clk : inclk_c4_from_vco);
    cycloneii_scale_cntr c4 (.clk(inclk_c4),
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
            c_high_val_hold[4] <= c_high_val_tmp[4];
            c_mode_val_hold[4] <= c_mode_val_tmp[4];
            c_high_val[4] <= c_high_val_hold[4];
            c_mode_val[4] <= c_mode_val_hold[4];
            c4_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c4_clk)
    begin
        if (c4_rising_edge_transfer_done)
        begin
            c_low_val_hold[4] <= c_low_val_tmp[4];
            c_low_val[4] <= c_low_val_hold[4];
        end
    end

    assign inclk_c5 = ((c5_test_source == 0) ? n_cntr_inclk : (ic5_use_casc_in == 1) ? c4_clk : inclk_c5_from_vco);
    cycloneii_scale_cntr c5 (.clk(inclk_c5),
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
            c_high_val_hold[5] <= c_high_val_tmp[5];
            c_mode_val_hold[5] <= c_mode_val_tmp[5];
            c_high_val[5] <= c_high_val_hold[5];
            c_mode_val[5] <= c_mode_val_hold[5];
            c5_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c5_clk)
    begin
        if (c5_rising_edge_transfer_done)
        begin
            c_low_val_hold[5] <= c_low_val_tmp[5];
            c_low_val[5] <= c_low_val_hold[5];
        end
    end

    always @ (inclk_n or ena_pll or areset_ipd)
    begin
        if (areset_ipd == 1'b1 || ena_pll == 1'b0)
        begin
            gate_count = 0;
            gate_out = 0; 
        end
        else if (inclk_n == 'b1 && inclk_last_value != inclk_n)
        begin
            gate_count = gate_count + 1;
            if (gate_count == gate_lock_counter)
                gate_out = 1;
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
                $display("NOTE : CycloneII PLL Reprogramming completed with the following values (Values in parantheses are original values) : ");
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

            $display ("NOTE : CycloneII PLL Reprogramming initiated ....");
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
            else begin
                $display ("Warning : Illegal bit settings for M counter phase tap. Reconfiguration may not work.");
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
                        end
                    end
                    else if (tmp_scan_data[31] == 1'b1)
                        c_mode_val_tmp[i] = "   odd";
                    else
                        c_mode_val_tmp[i] = "  even";
                    if (tmp_scan_data[25:22] === 4'b0000)
                        c_high_val_tmp[i] = 5'b10000;
                    else
                        c_high_val_tmp[i] = tmp_scan_data[25:22];
                    if (tmp_scan_data[30:27] === 4'b0000)
                        c_low_val_tmp[i] = 5'b10000;
                    else
                        c_low_val_tmp[i] = tmp_scan_data[30:27];

                    tmp_scan_data = tmp_scan_data >> 10;
                end
                // M
                error = 0;
                // some temporary storage
                if (scan_data[65:62] == 4'b0000)
                    m_hi = 5'b10000;
                else
                    m_hi = scan_data[65:62];

                if (scan_data[70:67] == 4'b0000)
                    m_lo = 5'b10000;
                else
                    m_lo = scan_data[70:67];

                m_val_tmp[0] = m_hi + m_lo;
                if (scan_data[66] === 1'b1)
                begin
                    if (scan_data[71] === 1'b1)
                    begin
                        // this will turn off the M counter : error
                        reconfig_err = 1;
                        error = 1;
                        $display ("The specified bit settings will turn OFF the M counter. This is illegal. Reconfiguration may not work.");
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
                            $display ("Warning : The M counter of the CycloneII Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work");
                        end
                    end
                    else begin // even mode
                        if (m_hi !== m_lo)
                        begin
                            reconfig_err = 1;
                            $display ("Warning : The M counter of the CycloneII Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work");
                        end
                    end
                end

                // N
                error = 0;
                n_val[0] = scan_data[73:72];
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
                        end
                    end
                    else if (tmp_scan_data[133] == 1'b1)
                        c_mode_val_tmp[i] = "   odd";
                    else
                        c_mode_val_tmp[i] = "  even";
                    if (tmp_scan_data[123:116] === 8'b00000000)
                        c_high_val_tmp[i] = 9'b100000000;
                    else
                        c_high_val_tmp[i] = tmp_scan_data[123:116];
                    if (tmp_scan_data[132:125] === 8'b00000000)
                        c_low_val_tmp[i] = 9'b100000000;
                    else
                        c_low_val_tmp[i] = tmp_scan_data[132:125];

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
                        m_val_tmp[i] = tmp_scan_data[142:134];
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
                    end
                end

                // cntrs N/N2
                tmp_scan_data = scan_data;
                for (i=0; i<2; i=i+1)
                begin
                    if (i == 0 || (i == 1 && ss > 0))
                    begin
                        error = 0;
                        n_val[i] = tmp_scan_data[162:154];
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

            slowest_clk_new = slowest_clk  ( c_high_val_tmp[0]+c_low_val[0], c_mode_val_tmp[0],
                                        c_high_val_tmp[1]+c_low_val[1], c_mode_val_tmp[1],
                                        c_high_val_tmp[2]+c_low_val[2], c_mode_val_tmp[2],
                                        c_high_val_tmp[3]+c_low_val[3], c_mode_val_tmp[3],
                                        c_high_val_tmp[4]+c_low_val[4], c_mode_val_tmp[4],
                                        c_high_val_tmp[5]+c_low_val[5], c_mode_val_tmp[5],
                                        refclk_period, m_val[0]);

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
            $display (" Note : CycloneII PLL was reset");
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
            if ((ena_pll === 1'b1) && (stop_vco !== 1'b1) && (next_vco_sched_time < $time))
                schedule_vco = ~ schedule_vco;
        end

        // if ena was deasserted
        if (ena_pll == 1'b0 && ena_ipd_last_value !== ena_pll)
        begin
            $display (" Note : CycloneII PLL is disabled");
            $display ("Time: %0t  Instance: %m", $time);
            pll_is_disabled = 1;
            tap0_is_active = 0;
            for (x = 0; x <= 7; x=x+1)
                 vco_tap[x] <= 1'b0;
        end

        if (ena_pll == 1'b1 && ena_ipd_last_value !== ena_pll)
        begin
            $display (" Note : CycloneII PLL is enabled");
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

            // reset all counter phase tap values to POF programmed values
            m_ph_val = m_ph_val_orig;
            for (i=0; i<= 5; i=i+1)
                c_ph_val[i] = c_ph_val_orig[i];
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
            $display (" Note : CycloneII PFDENA was deasserted");
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
                            $display ("Note : CycloneII PLL lost lock");
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
                    $display ("Note : CycloneII PLL lost lock due to loss of input clock");
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
                        $display (" Note : CycloneII PLL locked to incoming clock");
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
                        $display ("Note : CycloneII PLL lost lock");
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

    assign clk_tmp[0] = i_clk0_counter == "c0" ? c0_clk : i_clk0_counter == "c1" ? c1_clk : i_clk0_counter == "c2" ? c2_clk : i_clk0_counter == "c3" ? c3_clk : i_clk0_counter == "c4" ? c4_clk : i_clk0_counter == "c5" ? c5_clk : 'b0;
    assign clk_tmp[1] = i_clk1_counter == "c0" ? c0_clk : i_clk1_counter == "c1" ? c1_clk : i_clk1_counter == "c2" ? c2_clk : i_clk1_counter == "c3" ? c3_clk : i_clk1_counter == "c4" ? c4_clk : i_clk1_counter == "c5" ? c5_clk : 'b0;
    assign clk_tmp[2] = i_clk2_counter == "c0" ? c0_clk : i_clk2_counter == "c1" ? c1_clk : i_clk2_counter == "c2" ? c2_clk : i_clk2_counter == "c3" ? c3_clk : i_clk2_counter == "c4" ? c4_clk : i_clk2_counter == "c5" ? c5_clk : 'b0;
    assign clk_tmp[3] = i_clk3_counter == "c0" ? c0_clk : i_clk3_counter == "c1" ? c1_clk : i_clk3_counter == "c2" ? c2_clk : i_clk3_counter == "c3" ? c3_clk : i_clk3_counter == "c4" ? c4_clk : i_clk3_counter == "c5" ? c5_clk : 'b0;
    assign clk_tmp[4] = i_clk4_counter == "c0" ? c0_clk : i_clk4_counter == "c1" ? c1_clk : i_clk4_counter == "c2" ? c2_clk : i_clk4_counter == "c3" ? c3_clk : i_clk4_counter == "c4" ? c4_clk : i_clk4_counter == "c5" ? c5_clk : 'b0;
    assign clk_tmp[5] = i_clk5_counter == "c0" ? c0_clk : i_clk5_counter == "c1" ? c1_clk : i_clk5_counter == "c2" ? c2_clk : i_clk5_counter == "c3" ? c3_clk : i_clk5_counter == "c4" ? c4_clk : i_clk5_counter == "c5" ? c5_clk : 'b0;

    assign clk_out[0] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[0] : 'bx;
    assign clk_out[1] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[1] : 'bx;
    assign clk_out[2] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[2] : 'bx;
    assign clk_out[3] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[3] : 'bx;
    assign clk_out[4] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[4] : 'bx;
    assign clk_out[5] = (areset_ipd === 1'b1 || ena_pll === 1'b0 || pll_in_test_mode === 1'b1) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk_tmp[5] : 'bx;

    assign sbdout_tmp = sbdin_ipd;

    // ACCELERATE OUTPUTS
    and (clk[0], 1'b1, clk_out[0]);
    and (clk[1], 1'b1, clk_out[1]);
    and (clk[2], 1'b1, clk_out[2]);
    and (sbdout, 1'b1, sbdout_tmp);

endmodule // cycloneii_pll
//------------------------------------------------------------------
//
// Module Name : cycloneii_routing_wire
//
// Description : Simulation model for a simple routing wire
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module cycloneii_routing_wire (
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

endmodule // cycloneii_routing_wire
//------------------------------------------------------------------
//
// Module Name : cycloneii_lcell_ff
//
// Description : Cyclone II LCELL_FF Verilog simulation model 
//
//------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module cycloneii_lcell_ff (
                           datain, 
                           clk, 
                           aclr, 
                           sclr, 
                           sload, 
                           sdata, 
                           ena, 
                           devclrn, 
                           devpor, 
                           regout
                          );
   
parameter x_on_violation = "on";
parameter lpm_type = "cycloneii_lcell_ff";

input datain;
input clk;
input aclr;
input sclr; 
input sload; 
input sdata; 
input ena; 
input devclrn; 
input devpor; 

output regout;
   
reg regout_tmp;
wire reset;
   
reg datain_viol;
reg sclr_viol;
reg sload_viol;
reg sdata_viol;
reg ena_viol; 
reg violation;

reg clk_last_value;
   
reg ix_on_violation;

wire datain_in;
wire clk_in;
wire aclr_in;
wire sclr_in;
wire sload_in;
wire sdata_in;
wire ena_in;

wire nosloadsclr;
wire sloaddata;

buf (datain_in, datain);
buf (clk_in, clk);
buf (aclr_in, aclr);
buf (sclr_in, sclr);
buf (sload_in, sload);
buf (sdata_in, sdata);
buf (ena_in, ena);
   
assign reset = devpor && devclrn && (!aclr_in) && (ena_in);
assign nosloadsclr = reset && (!sload_in && !sclr_in);
assign sloaddata = reset && sload_in;
   
specify

    $setuphold (posedge clk &&& nosloadsclr, datain, 0, 0, datain_viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
    $setuphold (posedge clk &&& sloaddata, sdata, 0, 0, sdata_viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
      
    (posedge clk => (regout +: regout_tmp)) = 0 ;
    (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
      
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
   
always @ (datain_viol or sclr_viol or sload_viol or ena_viol or sdata_viol)
begin
    if (ix_on_violation == 1)
        violation = 'b1;
end
   
always @ (sdata_in or aclr_in or devclrn or devpor)
begin
    if (devpor == 'b0)
        regout_tmp <= 'b0;
    else if (devclrn == 'b0)
        regout_tmp <= 'b0;
    else if (aclr_in == 'b1) 
        regout_tmp <= 'b0;
end
   
always @ (clk_in or posedge aclr_in or 
          devclrn or devpor or posedge violation)
begin
    if (violation == 1'b1)
    begin
        violation = 'b0;
        regout_tmp <= 'bX;
    end
    else
    begin
        if (devpor == 'b0 || devclrn == 'b0 || aclr_in === 'b1)
            regout_tmp <= 'b0;
        else if (ena_in === 'b1 && clk_in === 'b1 && clk_last_value === 'b0)
        begin
            if (sclr_in === 'b1)
                regout_tmp <= 'b0 ;
            else if (sload_in === 'b1)
                regout_tmp <= sdata_in;
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
// Module Name : cycloneii_lcell_comb
//
// Description : Cyclone II LCELL_COMB Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneii_lcell_comb (
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
parameter lpm_type = "cycloneii_lcell_comb";
   
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
        isum_lutc_input = 2;
    end

end

always @(datad_in or datac_in or datab_in or dataa_in or cin_in)
begin
	
    if (isum_lutc_input == 0) // datac 
    begin
        combout_tmp = lut4(lut_mask, dataa_in, datab_in, 
                            datac_in, datad_in);
        cout_tmp = lut4(lut_mask, dataa_in, datab_in, datac_in, 'b0);
    end
    else if (isum_lutc_input == 1) // cin
        begin
        combout_tmp = lut4(lut_mask, dataa_in, datab_in, 
                            cin_in, datad_in);
        cout_tmp = lut4(lut_mask, dataa_in, datab_in, cin_in, 'b0);
    end
end

and (combout, combout_tmp, 1'b1) ;
and (cout, cout_tmp, 1'b1) ;
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// CYCLONEII ASYNCH IO Atom
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module cycloneii_asynch_io (datain, oe, regin,
                            differentialin, differentialout, 
                            padio, combout, regout);
   
   input datain, oe;
   input regin;
   input differentialin;
   output differentialout;
   output combout;
   output regout;
   inout  padio;
   
   parameter operation_mode = "input";
   parameter bus_hold = "false";
   parameter open_drain_output = "false";
   
   parameter use_differential_input  = "false";

   reg 	     prev_value;
   reg 	     tmp_padio, tmp_combout;
   reg 	     buf_control;

   wire      differentialout_tmp;
   wire      tmp_combout_differentialin_or_pad;
   wire      datain_in;

   wire differentialin_in;
   wire oe_in;

   buf(differentialin_in, differentialin);
   buf(oe_in, oe);
   buf(datain_in, datain);

   tri 	     padio_tmp;
   
   specify
      (padio => differentialout) = (0,0);
      (differentialin => combout) = (0,0);
      (padio => combout) = (0,0);
      (datain => padio) = (0, 0);
      (posedge oe => (padio +: padio_tmp)) = (0, 0);
      (negedge oe => (padio +: 1'bz)) = (0, 0);
      (regin => regout) = (0, 0);
   endspecify
   
   initial
      begin
         prev_value = 'b0;
         tmp_padio = 'bz;
      end
            
    always @(datain_in or oe_in or padio)
    begin
        if (bus_hold == "true" )
        begin
            buf_control = 'b1;
            if ( operation_mode == "input")
            begin
                if (padio === 1'bz)
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
                if ( operation_mode == "output" || operation_mode == "bidir")
                begin  
                    if ( oe_in == 1)
                    begin
                       if ( open_drain_output == "true" )
                       begin
                            if (datain_in == 1'b0)
                            begin
                                tmp_padio =  1'b0;
                                prev_value = 1'b0;
                            end
                            else if (datain_in === 1'bx)
                            begin
                                tmp_padio = 1'bx;
                                prev_value = 1'bx;
                            end
                            else   // output of tri is 'Z'
                            begin
                                if ( operation_mode == "bidir")
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
                        if (operation_mode == "bidir")
                            prev_value = padio;
	                                  
                        tmp_padio = 1'bz;
                    end      
                    else   // oe == 'X' 
                    begin
                        tmp_padio = 1'bx;
                        prev_value = 1'bx;
                    end
                end // bidir or output
                                     
                if ( operation_mode == "output")
                    tmp_combout = 1'bz;
                else
                    tmp_combout = padio;
            end         
        end         
        else    // bus hold is false
        begin
            buf_control = 'b0;
            if ( operation_mode == "input")
            begin
                tmp_combout = padio;
            end
            else if (operation_mode == "output" || operation_mode == "bidir")
            begin
                if ( operation_mode  == "bidir")
                    tmp_combout = padio;
                            
                if ( oe_in == 1 )
                begin
                    if ( open_drain_output == "true" )
                    begin
                        if (datain_in == 0)
                            tmp_padio = 1'b0;
                        else if ( datain_in === 1'bx)
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
                $display ("Error: Invalid operation_mode specified in cycloneii io atom!\n");
        end
   end     

   assign differentialout_tmp = (operation_mode == "input" || operation_mode == "bidir") ? padio : 1'bx;
   assign tmp_combout_differentialin_or_pad = (use_differential_input == "true") ? differentialin_in : tmp_combout;

   bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
   pmos (padio_tmp, tmp_padio, 'b0);
   pmos (combout, tmp_combout_differentialin_or_pad, 'b0);
   pmos (padio, padio_tmp, 'b0);
   and (regout, regin, 1'b1);

   pmos (differentialout, differentialout_tmp, 'b0);
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// CYCLONEII IO Atom
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module cycloneii_io (datain, oe, outclk, outclkena, inclk, inclkena, areset, sreset,
                    devclrn, devpor, devoe, linkin,
                    differentialin, differentialout,
                    padio, combout, regout, linkout);

	parameter operation_mode = "input";
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
	parameter lpm_type  = "cycloneii_io";

	parameter use_differential_input  = "false";

	inout		padio;
	input		datain, oe;
	input		outclk, outclkena, inclk, inclkena, areset, sreset;
	input		devclrn, devpor, devoe;
	input       linkin;
	input		differentialin;
	output		differentialout;
 	output		combout, regout;
	output      linkout;
	
	wire	out_reg_clk_ena, oe_reg_clk_ena;

	wire	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out; 
	
	wire	inreg_sreset_is_used, outreg_sreset_is_used, oereg_sreset_is_used;

	wire	inreg_sreset, outreg_sreset, oereg_sreset;

	wire	in_reg_aclr, in_reg_apreset;
	
	wire	oe_reg_aclr, oe_reg_apreset, oe_reg_sel;
	
	wire	out_reg_aclr, out_reg_apreset, out_reg_sel;
	
	wire	input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low;
	
	wire	inreg_D, outreg_D, oereg_D;

	wire	tmp_datain, tmp_oe;
	wire	iareset, isreset;

	wire    pad_or_differentialin;
	assign  pad_or_differentialin = (use_differential_input == "true") ? differentialin : padio;

	assign input_reg_pu_low = ( input_power_up == "low") ? 'b0 : 'b1;
	assign output_reg_pu_low = ( output_power_up == "low") ? 'b0 : 'b1;
	assign oe_reg_pu_low = ( oe_power_up == "low") ? 'b0 : 'b1;
	
	assign  out_reg_sel = (output_register_mode == "register" ) ? 'b1 : 'b0;
	assign	oe_reg_sel = ( oe_register_mode == "register" ) ? 'b1 : 'b0;
	 
	assign	iareset = ( areset === 'b0 || areset === 'b1 ) ? !areset : 'b1;
	assign	isreset = ( sreset === 'b0 || sreset === 'b1 ) ? sreset : 'b0;

	// output register signals
	assign out_reg_aclr = (output_async_reset == "clear") ? iareset : 'b1;
	assign out_reg_apreset = ( output_async_reset == "preset") ? iareset : 'b1;
    assign outreg_sreset_is_used = ( output_sync_reset == "none") ? 'b0 : 'b1;
	assign outreg_sreset = (output_sync_reset == "clear") ? 'b0 : 'b1;

	// oe register signals
	assign oe_reg_aclr = ( oe_async_reset == "clear") ? iareset : 'b1;
	assign oe_reg_apreset = ( oe_async_reset == "preset") ? iareset : 'b1;
	assign oereg_sreset_is_used = ( oe_sync_reset == "none") ? 'b0 : 'b1;
	assign oereg_sreset = (oe_sync_reset == "clear") ? 'b0 : 'b1;

	// input register signals
	assign in_reg_aclr = ( input_async_reset == "clear") ? iareset : 'b1;
	assign in_reg_apreset = ( input_async_reset == "preset") ? iareset : 'b1;
	assign inreg_sreset_is_used = ( input_sync_reset == "none") ? 'b0 : 'b1;
	assign inreg_sreset = (input_sync_reset == "clear") ? 'b0 : 'b1;

	// oe and output register clock enable signals
	assign out_reg_clk_ena = ( tie_off_output_clock_enable == "true") ? 'b1 : outclkena;
	assign oe_reg_clk_ena = ( tie_off_oe_clock_enable == "true") ? 'b1 : outclkena;

	// input reg
	cycloneii_mux21 inreg_D_mux (.MO (inreg_D),
			           .A (pad_or_differentialin), 
			           .B (inreg_sreset),
			           .S (isreset && inreg_sreset_is_used));
   
	cycloneii_dffe input_reg (.Q (tmp_input_reg_out),
                       .CLK (inclk),
                       .ENA (inclkena),
                       .D (inreg_D),
                       .CLRN (in_reg_aclr && devclrn && (input_reg_pu_low || devpor)),
                       .PRN (in_reg_apreset && (!input_reg_pu_low || devpor)));
	//output reg
	cycloneii_mux21 outreg_D_mux (.MO (outreg_D),
			           .A (datain),
			           .B (outreg_sreset),
			           .S (isreset && outreg_sreset_is_used));

	cycloneii_dffe output_reg (.Q (tmp_output_reg_out),
                     .CLK (outclk),
                     .ENA (out_reg_clk_ena),
                     .D (outreg_D),
                     .CLRN (out_reg_aclr && devclrn && (output_reg_pu_low || devpor)),
                     .PRN (out_reg_apreset && (!output_reg_pu_low || devpor)));
	//oe reg
	cycloneii_mux21 oereg_D_mux (.MO (oereg_D),
			           .A (oe),
			           .B (oereg_sreset),
			           .S (isreset && oereg_sreset_is_used));

	cycloneii_dffe oe_reg (.Q (tmp_oe_reg_out),
                 .CLK (outclk),
                 .ENA (oe_reg_clk_ena),
                 .D (oereg_D),
                 .CLRN (oe_reg_aclr && devclrn && (oe_reg_pu_low || devpor)),
				 .PRN (oe_reg_apreset && (!oe_reg_pu_low || devpor)));

	// asynchronous block
	assign tmp_oe = (oe_reg_sel == 'b1) ? tmp_oe_reg_out : oe;
	assign tmp_datain = ((operation_mode == "output" || operation_mode == "bidir") && out_reg_sel == 'b1 ) ? tmp_output_reg_out : datain;

	cycloneii_asynch_io	asynch_inst(.datain(tmp_datain),
                                    .oe(tmp_oe),
                                    .regin(tmp_input_reg_out),
                                    .differentialin(differentialin), 
                                    .differentialout(differentialout), 
                                    .padio(padio),
                                    .combout(combout),
                                    .regout(regout));
	defparam asynch_inst.operation_mode = operation_mode;
	defparam asynch_inst.bus_hold = bus_hold;
	defparam asynch_inst.open_drain_output = open_drain_output;
	defparam asynch_inst.use_differential_input = use_differential_input;

endmodule

//------------------------------------------------------------------
//
// Module Name : cycloneii_clk_delay_ctrl
//
// Description : Cycloneii CLK DELAY CTRL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module cycloneii_clk_delay_ctrl (
                        clk, 
                        delayctrlin, 
                        disablecalibration,
                        pllcalibrateclkdelayedin,
                        devpor, 
                        devclrn, 
                        clkout
                        );
   
input clk; 
input [5:0] delayctrlin; 
input disablecalibration;
input pllcalibrateclkdelayedin;
input devpor; 
input devclrn; 

output clkout;
   
parameter behavioral_sim_delay = 0;
parameter delay_chain          = "54";  // or "1362ps"
parameter delay_chain_mode     = "static";
parameter uses_calibration     = "false";
parameter use_new_style_dq_detection  = "false";
parameter tan_delay_under_delay_ctrl_signal = "unused";
parameter delay_ctrl_sim_delay_15_0  = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter delay_ctrl_sim_delay_31_16 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter delay_ctrl_sim_delay_47_32 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter delay_ctrl_sim_delay_63_48 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter lpm_type  = "cycloneii_clk_delay_ctrl";

// BUFFERED BUS INPUTS
wire [5:0] delayctrl_in;

// TMP OUTPUTS
wire clk_out_w;
wire clk_after_calib_mux_w;
reg clk_after_dly_chain_r;

integer dqs_dynamic_dly_index_i;
integer dqs_dynamic_dly_i;

// Dynamic Delay Table
reg [31:0] dly_table_r [0:63];
reg [2047:0] delay_ctrl_sim_delay_all_r;
reg [31:0] a_val_r;
integer i;
integer j;

// FUNCTIONS


// INTERNAL NETS AND VARIABLES

// TIMING HOOKS   
wire clk_in;
wire delayctrl_in5;
wire delayctrl_in4;
wire delayctrl_in3;
wire delayctrl_in2;
wire delayctrl_in1;
wire delayctrl_in0;
wire disablecalibration_in;
wire pllcalibrateclkdelayed_in;

buf (clk_in, clk);
buf (delayctrl_in5, delayctrlin[5]);
buf (delayctrl_in4, delayctrlin[4]);
buf (delayctrl_in3, delayctrlin[3]);
buf (delayctrl_in2, delayctrlin[2]);
buf (delayctrl_in1, delayctrlin[1]);
buf (delayctrl_in0, delayctrlin[0]);
buf (disablecalibration_in, disablecalibration);
buf (pllcalibrateclkdelayed_in, pllcalibrateclkdelayedin);

assign delayctrl_in = {delayctrl_in5, delayctrl_in4, delayctrl_in3,
                       delayctrl_in2,delayctrl_in1,delayctrl_in0};

specify
    (clk => clkout) = (0,0);
    (disablecalibration => clkout) = (0,0);
    (pllcalibrateclkdelayedin => clkout) = (0,0);

endspecify

// MODEL
         
initial
begin
    delay_ctrl_sim_delay_all_r = {delay_ctrl_sim_delay_63_48, delay_ctrl_sim_delay_47_32, delay_ctrl_sim_delay_31_16, delay_ctrl_sim_delay_15_0};
    // dly_table_r = delay_ctrl_sim_delay_all_r;    
    for (i=0; i<64; i=i+1)
    begin
        // dly_table_r[i] = delay_ctrl_sim_delay_all_r[32*i+31 : 32*i];
        for (j=0; j<32; j=j+1)
            a_val_r[j] = delay_ctrl_sim_delay_all_r[32*i+j];
        dly_table_r[i] = a_val_r;
    end
`ifdef CYCLONEII_CLK_DELAY_CTRL_DEBUG
    $display("DEBUG: CLK_DELAY_CTRL instance %m has dynamic delay table ...");
    for (i=0; i<64; i=i+1)
        $display("%0d", dly_table_r[i]);
`endif
end

// generate dynamic delay value
initial 
begin
    dqs_dynamic_dly_index_i = 0;
    dqs_dynamic_dly_i = 0;
end

always @(delayctrl_in)
begin
    dqs_dynamic_dly_index_i = delayctrl_in;
	if (dqs_dynamic_dly_index_i >= 0 && dqs_dynamic_dly_index_i < 64)
        dqs_dynamic_dly_i = dly_table_r[dqs_dynamic_dly_index_i];
end

// generating post delay chain clock
always @(clk_in)
begin
    if (delay_chain_mode == "dynamic")
        clk_after_dly_chain_r <= #(dqs_dynamic_dly_i) clk_in;
    else if (delay_chain_mode == "static")
        clk_after_dly_chain_r <= #(behavioral_sim_delay) clk_in;
end

// generating post calib mux clock
assign clk_after_calib_mux_w = (uses_calibration == "true" && disablecalibration_in === 1'b0) ? 
                                pllcalibrateclkdelayed_in : clk_after_dly_chain_r; 

// final clock
assign clk_out_w = (delay_chain_mode == "none") ? clk_in : clk_after_calib_mux_w;

and (clkout, clk_out_w, 1'b1);
   
endmodule


//-----------------------------------------------------------------------------
//
// Module Name : cycloneii_clk_delay_cal_ctrl
//
// Description : Cycloneii CLK DELAY CALIBRATION CTRL Verilog simulation model 
//
//-----------------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module cycloneii_clk_delay_cal_ctrl(
    pllcalibrateclk, plldataclk, delayctrlin, disablecalibration,
    devclrn, devpor,
    calibratedata, pllcalibrateclkdelayedout);
   
input pllcalibrateclk;
input plldataclk;
input [5:0] delayctrlin;
input disablecalibration;
input devclrn;
input devpor;

output calibratedata;
output pllcalibrateclkdelayedout;
   
parameter delay_ctrl_sim_delay_15_0  = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter delay_ctrl_sim_delay_31_16 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter delay_ctrl_sim_delay_47_32 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter delay_ctrl_sim_delay_63_48 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter lpm_type  = "cycloneii_clk_delay_cal_ctrl";

// BUFFERED BUS INPUTS
wire [5:0] delayctrl_in;

// TIMING HOOKS   
wire plldataclk_in;
wire pllcalibrateclk_in;
wire delayctrl_in5;
wire delayctrl_in4;
wire delayctrl_in3;
wire delayctrl_in2;
wire delayctrl_in1;
wire delayctrl_in0;
wire disablecalibration_in;

buf (plldataclk_in, plldataclk);
buf (pllcalibrateclk_in, pllcalibrateclk);
buf (delayctrl_in5, delayctrlin[5]);
buf (delayctrl_in4, delayctrlin[4]);
buf (delayctrl_in3, delayctrlin[3]);
buf (delayctrl_in2, delayctrlin[2]);
buf (delayctrl_in1, delayctrlin[1]);
buf (delayctrl_in0, delayctrlin[0]);
buf (disablecalibration_in, disablecalibration);

// TMP OUTPUTS
wire cal_clk_out_w;
wire cal_data_out_w;
reg clk_after_dly_chain_r;
reg cal_clk_by2_r;
reg cal_data_by2_r;
reg cal_clk_prev;
reg cal_data_prev;

integer dqs_dynamic_dly_index_i;
integer dqs_dynamic_dly_i;

// Dynamic Delay Table
reg [31:0] dly_table_r [0:63];
reg [2047:0] delay_ctrl_sim_delay_all_r;
reg [31:0] a_val_r;
integer i;
integer j;

// FUNCTIONS


// INTERNAL NETS AND VARIABLES


assign delayctrl_in = {delayctrl_in5, delayctrl_in4, delayctrl_in3,
                       delayctrl_in2,delayctrl_in1,delayctrl_in0};

specify
    (plldataclk => calibratedata) = (0,0);
    (disablecalibration => calibratedata) = (0,0);
    (pllcalibrateclk => pllcalibrateclkdelayedout) = (0,0);
    (disablecalibration => pllcalibrateclkdelayedout) = (0,0);
endspecify

// MODEL
         
initial
begin
    delay_ctrl_sim_delay_all_r = {delay_ctrl_sim_delay_63_48, delay_ctrl_sim_delay_47_32, delay_ctrl_sim_delay_31_16, delay_ctrl_sim_delay_15_0};
    for (i=0; i<64; i=i+1)
    begin
        for (j=0; j<32; j=j+1)
            a_val_r[j] = delay_ctrl_sim_delay_all_r[32*i+j];
        dly_table_r[i] = a_val_r;
    end
`ifdef CYCLONEII_CLK_DELAY_CTRL_DEBUG
    $display("DEBUG: CLK_DELAY_CAL_CTRL instance %m has dynamic delay table ...");
    for (i=0; i<64; i=i+1)
        $display("%0d", dly_table_r[i]);
`endif
end

// generate dynamic delay value
initial 
begin
    dqs_dynamic_dly_index_i = 0;
    dqs_dynamic_dly_i = 0;
end

always @(delayctrl_in)
begin
    dqs_dynamic_dly_index_i = delayctrl_in;
	if (dqs_dynamic_dly_index_i >= 0 && dqs_dynamic_dly_index_i < 64)
        dqs_dynamic_dly_i = dly_table_r[dqs_dynamic_dly_index_i];
end

// generate divided by 2 clocks
initial
begin
    cal_clk_by2_r = 1'b0;
end

always @(pllcalibrateclk_in or posedge disablecalibration_in or negedge devclrn or negedge devpor)
begin
    if (disablecalibration_in === 1'b1 || devclrn === 1'b0 || devpor === 1'b0) 
        begin
            cal_clk_prev <= 1'bx;
            cal_clk_by2_r <= 1'b0;
        end 
    else 
        begin
            cal_clk_prev <= pllcalibrateclk_in;
            if (pllcalibrateclk_in === 1'b1 && cal_clk_prev === 1'b0)
                cal_clk_by2_r <= ~cal_clk_by2_r;
        end 
end

initial
begin
    cal_data_by2_r = 1'b0;
end

always @(plldataclk_in or posedge disablecalibration_in or negedge devclrn or negedge devpor)
begin
    if (disablecalibration_in === 1'b1 || devclrn === 1'b0 || devpor === 1'b0)
        begin
            cal_data_prev <= 1'bx;
            cal_data_by2_r <= 1'b0;
        end
    else 
        begin
            cal_data_prev <= plldataclk_in;
            if (plldataclk_in === 1'b1 && cal_data_prev === 1'b0)
                cal_data_by2_r <= ~cal_data_by2_r;
        end
end

// generating post delay chain clock
always @(cal_clk_by2_r)
begin
    clk_after_dly_chain_r <= #(dqs_dynamic_dly_i) cal_clk_by2_r;
end

// final clocks
assign cal_clk_out_w = clk_after_dly_chain_r;
assign cal_data_out_w = cal_data_by2_r;

and (calibratedata, cal_data_out_w, 1'b1);
and (pllcalibrateclkdelayedout, cal_clk_out_w, 1'b1);

endmodule

//------------------------------------------------------------------
//
// Module Name : cycloneii_ena_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for the gated clock generation.
//               Powers upto 1.
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module cycloneii_ena_reg (
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
end

    always @ (posedge clk_in or negedge clrn or negedge prn )
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
        else if ((clk_in == 1'b1) & (ena == 1'b1))
            q_tmp <= d_in;

    end

and (q, q_tmp, 'b1);

endmodule // cycloneii_ena_reg

//------------------------------------------------------------------
//
// Module Name : cycloneii_clkctrl
//
// Description : Cycloneii CLKCTRL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module cycloneii_clkctrl (
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
parameter ena_register_mode = "falling edge";
parameter lpm_type = "cycloneii_clkctrl";

wire clkmux_out; // output of CLK mux
wire cereg_out; // output of ENA register 
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
   
cycloneii_mux41 clk_mux (.MO(clkmux_out),
               .IN0(inclk0_ipd),
               .IN1(inclk1_ipd),
               .IN2(inclk2_ipd),
               .IN3(inclk3_ipd),
               .S({clkselect1_ipd, clkselect0_ipd}));

cycloneii_ena_reg extena0_reg(
                    .clk(!clkmux_out),
                    .ena(1'b1),
                    .d(ena_ipd),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg_out)
                   );
   
assign ena_out = (ena_register_mode == "falling edge") ? cereg_out : ena_ipd;

and (outclk, ena_out, clkmux_out);
   
endmodule

//---------------------------------------------------------------------
//
// Module Name : cycloneii_mac_data_reg
//
// Description : Simulation model for the data input register of 
//               Cyclone II MAC_MULT
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module cycloneii_mac_data_reg (clk,
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

endmodule //cycloneii_mac_data_reg

//------------------------------------------------------------------
//
// Module Name : cycloneii_mac_sign_reg
//
// Description : Simulation model for the sign input register of 
//               Cyclone II MAC_MULT
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module cycloneii_mac_sign_reg (
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

endmodule // cycloneii_mac_sign_reg

//------------------------------------------------------------------
//
// Module Name : cycloneii_mac_mult_internal
//
// Description : Cyclone II MAC_MULT_INTERNAL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneii_mac_mult_internal
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
// Module Name : cycloneii_mac_mult
//
// Description : Cyclone II MAC_MULT Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps

module cycloneii_mac_mult	
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
    parameter dataout_width  = dataa_width + datab_width;
    parameter dataa_clock	= "none";
    parameter datab_clock	= "none";
    parameter signa_clock	= "none"; 
    parameter signb_clock	= "none";
    parameter lpm_hint       = "true";
    parameter lpm_type       = "cycloneii_mac_mult";
    
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
    cycloneii_mac_data_reg dataa_reg (
                                      .clk(clk),
                                      .data(dataa_pad),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .dataout(idataa_reg)
                                     );
        defparam dataa_reg.data_width = dataa_width;

    cycloneii_mac_data_reg datab_reg (
                                      .clk(clk),
                                      .data(datab_pad),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .dataout(idatab_reg)
                                     );
        defparam datab_reg.data_width = datab_width;

    cycloneii_mac_sign_reg signa_reg (
                                      .clk(clk),
                                      .d(signa),
                                      .ena(ena),
                                      .aclr(reg_aclr),
                                      .q(isigna_reg)
                                     );

    cycloneii_mac_sign_reg signb_reg (
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
 
    cycloneii_mac_mult_internal mac_multiply (
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
// Module Name : cycloneii_mac_out
//
// Description : Cyclone II MAC_OUT Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
module cycloneii_mac_out	
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
    parameter dataout_width = dataa_width;
    parameter output_clock  = "none";
    parameter lpm_hint      = "true";
    parameter lpm_type      = "cycloneii_mac_out";
    
    input [dataa_width-1:0] dataa;
    input clk;
    input aclr;
    input ena;
    input 	devclrn;
    input 	devpor;
    output [dataout_width-1:0] dataout; 
    
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
