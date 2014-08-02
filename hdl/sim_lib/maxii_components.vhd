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

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.maxii_atom_pack.all;

package maxii_components is


--
-- maxii_jtag
--

COMPONENT maxii_jtag
    generic (
        lpm_type : string := "maxii_jtag"
        );	
    port (
        tms : in std_logic := '0'; 
        tck : in std_logic := '0'; 
        tdi : in std_logic := '0'; 
        ntrst : in std_logic := '0'; 
        tdoutap : in std_logic := '0'; 
        tdouser : in std_logic := '0'; 
        tdo: out std_logic; 
        tmsutap: out std_logic; 
        tckutap: out std_logic; 
        tdiutap: out std_logic; 
        shiftuser: out std_logic; 
        clkdruser: out std_logic; 
        updateuser: out std_logic; 
        runidleuser: out std_logic; 
        usr1user: out std_logic
        );
END COMPONENT;

--
-- maxii_lcell
--

COMPONENT maxii_lcell
    GENERIC (
             operation_mode  : string := "normal";
             synch_mode      : string := "off";
             register_cascade_mode : string := "off";
             sum_lutc_input  : string := "datac";
             lut_mask        : string := "ffff";
             power_up        : string := "low";
             cin_used        : string := "false";
             cin0_used       : string := "false";
             cin1_used       : string := "false";
             output_mode     : string := "reg_and_comb";
             x_on_violation  : string := "on";
             lpm_type        : string := "maxii_lcell"
            );
    PORT (
          clk       : in std_logic := '0';
          dataa     : in std_logic := '1';
          datab     : in std_logic := '1';
          datac     : in std_logic := '1';
          datad     : in std_logic := '1';
          aclr      : in std_logic := '0';
          aload     : in std_logic := '0';
          sclr      : in std_logic := '0';
          sload     : in std_logic := '0';
          ena       : in std_logic := '1';
          cin       : in std_logic := '0';
          cin0      : in std_logic := '0';
          cin1      : in std_logic := '1';
          inverta   : in std_logic := '0';
          regcascin : in std_logic := '0';
          devclrn   : in std_logic := '1';
          devpor    : in std_logic := '1';
          combout   : out std_logic;
          regout    : out std_logic;
          cout      : out std_logic;
          cout0     : out std_logic;
          cout1     : out std_logic
);
END COMPONENT;

--
-- maxii_ufm
--

COMPONENT maxii_ufm
    generic (
        address_width   : integer := 9;
        init_file       : string := "none";
        lpm_type        : string := "maxii_ufm";
        mem1            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem2            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem3            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem4            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem5            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem6            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem7            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem8            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem9            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem10           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem11           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem12           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem13           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem14           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem15           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem16           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        osc_sim_setting : integer := 180000; -- default osc frequency to 5.56MHz
        program_time    : integer := 1600000; -- default program_time is 1600ns
        erase_time      : integer := 500000000; -- default erase time is 500us
        TimingChecksOn: Boolean := True;
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;
        tpd_program_busy_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_erase_busy_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_drclk_drdout_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_oscena_osc_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_sbdin_sbdout : VitalDelayType01 := DefPropDelay01;
        tsetup_arshft_arclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        tsetup_ardin_arclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_drshft_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        tsetup_drdin_drclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_oscena_program_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_oscena_erase_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_arshft_arclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_ardin_arclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_drshft_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_drdin_drclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_program_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_erase_arclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        thold_oscena_program_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_oscena_erase_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_program_busy_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_erase_busy_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tipd_program  : VitalDelayType01 := DefPropDelay01;
        tipd_erase : VitalDelayType01 := DefPropDelay01;
        tipd_oscena : VitalDelayType01 := DefPropDelay01;
        tipd_arclk : VitalDelayType01 := DefPropDelay01;
        tipd_arshft : VitalDelayType01 := DefPropDelay01;
        tipd_ardin : VitalDelayType01 := DefPropDelay01;
        tipd_drclk : VitalDelayType01 := DefPropDelay01;
        tipd_drshft : VitalDelayType01 := DefPropDelay01;
        tipd_drdin : VitalDelayType01 := DefPropDelay01;
        tipd_sbdin : VitalDelayType01 := DefPropDelay01
        );
    port (
        program       : in std_logic := '0';
        erase         : in std_logic := '0';
        oscena        : in std_logic;
        arclk         : in std_logic;
        arshft        : in std_logic;
        ardin         : in std_logic;
        drclk         : in std_logic;
        drshft        : in std_logic;
        drdin         : in std_logic := '0';
        sbdin         : in std_logic := '0';
        devclrn       : in std_logic := '1'; -- simulation only port
        devpor        : in std_logic := '1'; -- simulation only port
        ctrl_bgpbusy  : in std_logic := '0'; -- simulation only port, to control
        busy          : out std_logic;
        osc           : out std_logic := 'X';
        drdout        : out std_logic;
        sbdout        : out std_logic;
        bgpbusy       : out std_logic);
END COMPONENT;

--
-- maxii_io
--

COMPONENT maxii_io
    generic(
            lpm_type  : STRING := "maxii_io";
            operation_mode  : STRING := "input";
            open_drain_output : STRING := "false";
            bus_hold : STRING := "false";
            XOn: Boolean := DefGlitchXOn;
            MsgOn: Boolean := DefGlitchMsgOn;
            tpd_datain_padio : VitalDelayType01 := DefPropDelay01;
            tpd_oe_padio_posedge : VitalDelayType01 := DefPropDelay01;
            tpd_oe_padio_negedge : VitalDelayType01 := DefPropDelay01;
            tpd_padio_combout : VitalDelayType01 := DefPropDelay01;
            tipd_datain : VitalDelayType01 := DefPropDelay01;
            tipd_oe : VitalDelayType01 := DefPropDelay01;
            tipd_padio : VitalDelayType01 := DefPropDelay01
           );
    port(
        datain : in  STD_LOGIC := '0';
        oe : in  STD_LOGIC := '1';
        padio : inout STD_LOGIC;
        combout : out STD_LOGIC
        );
END COMPONENT;

--
-- maxii_routing_wire
--

COMPONENT maxii_routing_wire
    generic (
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             tpd_datain_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_datainglitch_dataout : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          datain : in std_logic;
          dataout : out std_logic
         );
END COMPONENT;

end maxii_components;
