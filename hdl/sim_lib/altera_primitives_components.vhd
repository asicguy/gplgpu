-- Copyright (C) 1991-2011 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.
-- Quartus II 11.0 Build 157 04/27/2011

----------------------------------------------------------------------------
-- ALtera Primitives Component Declaration File
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package dffeas_pack is

-- default generic values
    CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
    CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
    CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
    CONSTANT DefGlitchMode       : VitalGlitchKindType   := VitalTransport;
    CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
    CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
    CONSTANT DefMsgOnChecks      : BOOLEAN       := TRUE;
    CONSTANT DefXOnChecks        : BOOLEAN       := TRUE;

end dffeas_pack;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.dffeas_pack.all;

package altera_primitives_components is

component carry
    port (
        a_in : in std_logic;
        a_out : out std_logic );
end component;

component cascade
    port (
        a_in : in std_logic;
        a_out : out std_logic );
end component;

component global
    port (
        a_in : in std_logic;
        a_out : out std_logic);
end component;

component tri
    port(
        a_in  :  in    std_logic;
        oe    :  in    std_logic;
        a_out :  out   std_logic);
end component;

component carry_sum
    port (
        sin : in std_logic;
        cin : in std_logic;
        sout : out std_logic;
        cout : out std_logic );
end component;

component exp
    port (
        a_in : in std_logic;
        a_out : out std_logic);
end component;

component soft
    port (
        a_in : in std_logic;
        a_out : out std_logic );
end component;

component opndrn
    port (
        a_in : in std_logic;
        a_out : out std_logic );
end component;

component row_global
    port (
        a_in : in std_logic;
        a_out : out std_logic );
end component;

component lut_input
    port(
        a_in  :  in    std_logic;
        a_out :  out   std_logic);
end component;

component lut_output
    port(
        a_in  :  in    std_logic;
        a_out :  out   std_logic);
end component;

component dlatch
    port(
        d    :  in    std_logic;
        ena  :  in    std_logic;
        clrn :  in    std_logic;
        prn  :  in    std_logic;
        q    :  out   std_logic);
end component;

component latch
    port(
        d   :  in    std_logic;
        ena :  in    std_logic;
        q   :  out   std_logic);
end component;

component dff
    port(
        d, clk, clrn, prn :  in  std_logic;
        q                 :  out std_logic);
end component;

component dffe
    port(
        d, clk, ena, clrn, prn :  in  std_logic;
        q                      :  out std_logic);
end component;

component dffea
    port(
        d, clk, ena, clrn, prn, aload, adata :  in  std_logic;
        q                                    :  out std_logic);
end component;

component dffeas
    generic (
        power_up : string := "DONT_CARE";
        is_wysiwyg : string := "false";
        x_on_violation : string := "on";
        lpm_type : string := "DFFEAS";
        tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_prn_q_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_asdata_q: VitalDelayType01 := DefPropDelay01;
        tipd_clk : VitalDelayType01 := DefPropDelay01;
        tipd_d : VitalDelayType01 := DefPropDelay01;
        tipd_asdata : VitalDelayType01 := DefPropDelay01;
        tipd_sclr : VitalDelayType01 := DefPropDelay01; 
        tipd_sload : VitalDelayType01 := DefPropDelay01;
        tipd_clrn : VitalDelayType01 := DefPropDelay01; 
        tipd_prn : VitalDelayType01 := DefPropDelay01; 
        tipd_aload : VitalDelayType01 := DefPropDelay01; 
        tipd_ena : VitalDelayType01 := DefPropDelay01; 
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*" );
    
    port (
        d : in std_logic := '0';
        clk : in std_logic := '0';
        ena : in std_logic := '1';
        clrn : in std_logic := '1';
        prn : in std_logic := '1';
        aload : in std_logic := '0';
        asdata : in std_logic := '1';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        devclrn : in std_logic := '1';
        devpor : in std_logic := '1';
        q : out std_logic );
end component;

component tff
    port(
        t, clk, clrn, prn :  in  std_logic;
        q                 :  out std_logic);
end component;

component tffe
    port(
        t, clk, ena, clrn, prn :  in  std_logic;
        q                      :  out std_logic);
end component;

component jkff
    port(
        j, k, clk, clrn, prn :  in  std_logic;
        q                    :  out std_logic);
end component;

component jkffe
    port(
        j, k, clk, ena, clrn, prn :  in  std_logic;
        q                         :  out std_logic);
end component;

component srff
    port(
        s, r, clk, clrn, prn :  in  std_logic;
        q                    :  out std_logic);
end component;

component srffe
    port(
        s, r, clk, ena, clrn, prn :  in  std_logic;
        q                         :  out std_logic);
end component;

component clklock
    generic(
        input_frequency       : natural := 10000;
        clockboost            : natural := 1);

    port(
        inclk   : in std_logic;
        outclk  : out std_logic);
end component;

component alt_inbuf
    generic(
        io_standard           : string := "NONE";
        location              : string := "NONE";
        enable_bus_hold       : string := "NONE";
        weak_pull_up_resistor : string := "NONE"; 
        termination           : string := "NONE";
        lpm_type              : string := "alt_inbuf" );

    port(
        i  : in std_logic;
        o  : out std_logic);
end component;

component alt_outbuf
    generic(
        io_standard           : string  := "NONE";
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        slow_slew_rate        : string  := "NONE";
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf" );

    port(
        i  : in std_logic;
        o  : out std_logic);
end component;

component alt_outbuf_tri
    generic(
        io_standard           : string  := "NONE";
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        slow_slew_rate        : string  := "NONE";
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf_tri" );

    port(
        i  : in std_logic;
        oe : in std_logic;
        o  : out std_logic);
end component;

component alt_iobuf
    generic(
        io_standard           : string  := "NONE";
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        slow_slew_rate        : string  := "NONE";
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_iobuf" );

    port(
        i  : in std_logic;
        oe : in std_logic;
        io : inout std_logic;
        o  : out std_logic);
end component;

component alt_inbuf_diff
    generic(
        io_standard           : string := "NONE"; 
        location              : string := "NONE";
        enable_bus_hold       : string := "NONE";
        weak_pull_up_resistor : string := "NONE"; 
        termination           : string := "NONE";
        lpm_type              : string := "alt_inbuf_diff" );

    port(
        i    : in std_logic; 
        ibar : in std_logic;
        o    : out std_logic); 
end component;

component alt_outbuf_diff
    generic (
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf_diff" ); 

    port(
        i    : in std_logic; 
        o    : out std_logic;
        obar : out std_logic ); 
end component;
 
component alt_outbuf_tri_diff
    generic (
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE"; 
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf_tri_diff" );  
    port(
        i    : in std_logic; 
        oe   : in std_logic; 
        o    : out std_logic;
        obar : out std_logic ); 
end component;

component alt_iobuf_diff
    generic (
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE"; 
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_iobuf_diff" );  
    port(
        i     : in std_logic; 
        oe    : in std_logic; 
        io    : inout std_logic; 
        iobar : inout std_logic; 
        o     : out std_logic );
end component;

component alt_bidir_diff
    generic (
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_bidir_diff" );  
    port(
        oe      : in std_logic;
        bidirin : inout std_logic;
        io      : inout std_logic;
        iobar   : inout std_logic );
end component;

component alt_bidir_buf
    generic (
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_bidir_buf" );  
    port(
        oe      : in std_logic;
        bidirin : inout std_logic;
        io      : inout std_logic );
end component;

end altera_primitives_components;

