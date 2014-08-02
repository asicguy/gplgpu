-- Copyright (C) Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.


LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;

USE IEEE.vital_timing.ALL;
USE IEEE.vital_primitives.ALL;


package ARRIAGX_HSSI_COMPONENTS is



-- VITAL constants BEGIN
-- default generic values
    CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
    CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
    CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
-- default control options
--    CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
-- change default delay type to Transport : for spr 68748
    CONSTANT DefGlitchMode       : VitalGlitchKindType   := VitalTransport;
    CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
    CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
    CONSTANT DefMsgOnChecks      : BOOLEAN       := TRUE;
    CONSTANT DefXOnChecks        : BOOLEAN       := TRUE;
-- output strength mapping
                                                --  UX01ZWHL-
    CONSTANT PullUp      : VitalOutputMapType    := "UX01HX01X";
    CONSTANT NoPullUpZ   : VitalOutputMapType    := "UX01ZX01X";
    CONSTANT PullDown    : VitalOutputMapType    := "UX01LX01X";
-- primitive result strength mapping
    CONSTANT wiredOR     : VitalResultMapType    := ( 'U', 'X', 'L', '1' );
    CONSTANT wiredAND    : VitalResultMapType    := ( 'U', 'X', '0', 'H' );
    CONSTANT L : VitalTableSymbolType := '0';
    CONSTANT H : VitalTableSymbolType := '1';
    CONSTANT x : VitalTableSymbolType := '-';
    CONSTANT S : VitalTableSymbolType := 'S';
    CONSTANT R : VitalTableSymbolType := '/';
    CONSTANT U : VitalTableSymbolType := 'X';
    CONSTANT V : VitalTableSymbolType := 'B'; -- valid clock signal (non-rising)
-- VITAL constants END

-- GENERIC utility functions BEGIN
function str2bin (s : string) return std_logic_vector;
function str2int (s : string) return integer;
function int2bin (arg : integer; size : integer) return std_logic_vector;
function tx_top_ctrl_in_width(
        double_data_mode : string;
        ser_double_data_mode : string
) return integer;
function rx_top_a1k1_out_width(des_double_data_mode : string) return integer; 
function rx_top_ctrl_out_width(
	double_data_mode : string; 
        des_double_data_mode : string
) return integer; 

function hssiSelectDelay (CONSTANT Paths: IN  VitalPathArray01Type) return TIME;

-- GENERIC utility functions END


TYPE CMU_MULT_STATE_TYPE IS (INITIAL,INACTIVE,ACTIVE);


--
-- arriagx_hssi_refclk_divider
--

COMPONENT arriagx_hssi_refclk_divider
    GENERIC (
        enable_divider : STRING := "true";
        divider_number : INTEGER := 0;  -- 0 or 1 for logical numbering
        refclk_coupling_termination : STRING := "dc_coupling_external_termination"; -- new in 5.1 SP1
        dprio_config_mode              :  INTEGER := 0;                 -- 6.1
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        tipd_inclk        : VitalDelayType01 := DefPropDelay01;
        tipd_dprioin      : VitalDelayType01 := DefPropDelay01;
        tipd_dpriodisable : VitalDelayType01 := DefPropDelay01;
        tpd_inclk_clkout  : VitalDelayType01 := DefPropDelay01
    );
    PORT (
        inclk                   : IN STD_LOGIC;   
        dprioin                 : IN STD_LOGIC := '0';   
        dpriodisable            : IN STD_LOGIC := '1';   
        clkout                  : OUT STD_LOGIC;   
        dprioout                : OUT STD_LOGIC);   
END COMPONENT;

--
-- arriagx_hssi_cmu_clock_divider
--

COMPONENT arriagx_hssi_cmu_clock_divider
    GENERIC (
      inclk_select          :  integer := 0;    
      use_vco_bypass        :  string := "false";    
      use_digital_refclk_post_divider :  string := "false";    
      use_coreclk_out_post_divider    :  string := "false";    
      divide_by             :  integer := 4;    
      enable_refclk_out     :  string := "true";    
      enable_pclk_x8_out    :  string := "false";    
      select_neighbor_pclk  :  string := "false";    
      coreclk_out_gated_by_quad_reset:  string := "false";    
      select_refclk_dig     :  string := "false";
      dprio_config_mode              :  INTEGER := 0;                 -- 6.1
      tipd_clk           : VitalDelayArrayType01(2 DOWNTO 0) := (OTHERS => DefPropDelay01);
      tipd_pclkin        : VitalDelayType01 := DefPropDelay01;
      tipd_dprioin       : VitalDelayArrayType01(29 DOWNTO 0) := (OTHERS => DefPropDelay01);
      tipd_dpriodisable  : VitalDelayType01 := DefPropDelay01;
      tipd_powerdn       : VitalDelayType01 := DefPropDelay01;
      tipd_quadreset     : VitalDelayType01 := DefPropDelay01;
      tipd_refclkdig     : VitalDelayType01 := DefPropDelay01;
      tipd_scanclk       : VitalDelayType01 := DefPropDelay01;
      tipd_scanin        : VitalDelayArrayType01(22 DOWNTO 0) := (OTHERS => DefPropDelay01);
      tipd_scanshift     : VitalDelayType01 := DefPropDelay01;
      tipd_scanmode      : VitalDelayType01 := DefPropDelay01;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_clk_coreclkout  : VitalDelayType01 := DefPropDelay01;
      tpd_clk_pclkx8out   : VitalDelayType01 := DefPropDelay01;
      tpd_pclkin_coreclkout : VitalDelayType01 := DefPropDelay01;
      sim_analogrefclkout_phase_shift : INTEGER := 0;     
      sim_analogfastrefclkout_phase_shift : INTEGER := 0;     
      sim_digitalrefclkout_phase_shift  : INTEGER := 0;     
      sim_pclkx8out_phase_shift  : INTEGER := 0;     
      sim_coreclkout_phase_shift  : INTEGER := 0 
    );
    PORT (
        clk                     : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');   
        pclkin                  : IN STD_LOGIC := '0';   
        dprioin                 : IN STD_LOGIC_VECTOR(29 DOWNTO 0) := (OTHERS => '0');   
        dpriodisable            : IN STD_LOGIC := '1';   
        powerdn                 : IN STD_LOGIC := '0';   
        quadreset               : IN STD_LOGIC := '0';   
        refclkdig               : IN STD_LOGIC := '0';   
        scanclk                 : IN STD_LOGIC := '0';   
        scanin                  : IN STD_LOGIC_VECTOR(22 DOWNTO 0) := (OTHERS => '0');   
        scanshift               : IN STD_LOGIC := '0';   
        scanmode                : IN STD_LOGIC := '0';
        vcobypassin             : IN STD_LOGIC := '0';   
        analogrefclkout         : OUT STD_LOGIC;   
        analogfastrefclkout     : OUT STD_LOGIC;   
        digitalrefclkout        : OUT STD_LOGIC;   
        pclkx8out               : OUT STD_LOGIC;   
        coreclkout              : OUT STD_LOGIC;   
        dprioout                : OUT STD_LOGIC_VECTOR(29 DOWNTO 0);   
        scanout                 : OUT STD_LOGIC_VECTOR(22 DOWNTO 0));   
END COMPONENT;

--
-- arriagx_hssi_calibration_block
--

COMPONENT arriagx_hssi_calibration_block
    GENERIC (
        use_continuous_calibration_mode:  string  := "false";    
        rx_calibration_write_test_value:  integer := 0;    
        tx_calibration_write_test_value:  integer := 0;    
        enable_rx_calibration_test_write: string  := "false";    
        enable_tx_calibration_test_write: string  := "false";    
        send_rx_calibration_status     :  string  := "true");    
    PORT (
        clk                     : IN std_logic := '0';   
        powerdn                 : IN std_logic := '0';   
        enabletestbus           : IN std_logic := '0';   
        calibrationstatus       : OUT std_logic_vector(4 DOWNTO 0));   
END COMPONENT;

--
-- arriagx_hssi_cmu_pll
--

COMPONENT arriagx_hssi_cmu_pll
    GENERIC (
        inclk0_period : INTEGER := 0;  -- time period in ps
        inclk1_period : INTEGER := 0;
        inclk2_period : INTEGER := 0;
        inclk3_period : INTEGER := 0;
        inclk4_period : INTEGER := 0;
        inclk5_period : INTEGER := 0;
        inclk6_period : INTEGER := 0;
        inclk7_period : INTEGER := 0;
        pfd_clk_select : INTEGER := 0;
        multiply_by : INTEGER := 1;
        divide_by : INTEGER := 1;
        low_speed_test_sel : INTEGER := 0;
        pll_type : STRING := "normal"; -- normal,fast,auto
        charge_pump_current_test_enable : INTEGER := 0;
        vco_range : STRING := "low";
        loop_filter_resistor_control : INTEGER := 0;
        loop_filter_ripple_capacitor_control : INTEGER := 0;
        use_default_charge_pump_current_selection : STRING := "false";
        use_default_charge_pump_supply_vccm_vod_control : STRING := "false";
        pll_number : INTEGER := 0;     -- PLL 0-2
        charge_pump_current_control : INTEGER := 0;
        up_down_control_percent : INTEGER := 0;
        charge_pump_tristate_enable : STRING := "false";
        enable_pll_cascade : STRING := "false";           -- 6.1
        dprio_config_mode : INTEGER := 0;                 -- 6.1
        protocol_hint : STRING := "basic";                -- 6.1
        remapped_to_new_loop_filter_charge_pump_settings : STRING := "false";
        tipd_clk           : VitalDelayArrayType01(7 DOWNTO 0)  := (OTHERS => DefPropDelay01);
        tipd_dprioin       : VitalDelayArrayType01(39 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dpriodisable  : VitalDelayType01 := DefPropDelay01;
        tipd_pllreset      : VitalDelayType01 := DefPropDelay01;
        tipd_pllpowerdn    : VitalDelayType01 := DefPropDelay01;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        tpd_clk_clkout  : VitalDelayType01 := DefPropDelay01;
        sim_clkout_phase_shift : INTEGER := 0; 
        sim_clkout_latency : INTEGER := 0
    );
    PORT (
        clk                     : IN std_logic_vector(7 DOWNTO 0);   
        dprioin                 : IN std_logic_vector(39 DOWNTO 0) := (OTHERS => '0');   
        dpriodisable            : IN std_logic := '1';   
        pllreset                : IN std_logic := '0';   
        pllpowerdn              : IN std_logic := '0';   
        clkout                  : OUT std_logic;   
        locked                  : OUT std_logic;   
        dprioout                : OUT std_logic_vector(39 DOWNTO 0);
        fbclkout                : OUT std_logic;
        vcobypassout            : OUT std_logic);   
END COMPONENT;

--
-- arriagx_hssi_central_management_unit
--

COMPONENT arriagx_hssi_central_management_unit
    GENERIC (
        in_xaui_mode          :  string := "false";    
        portaddr              :  integer := 1;        -- 1-based
        devaddr               :  integer := 1;        -- 1-based
        bonded_quad_mode      :  string := "none";    
        use_deskew_fifo       :  string := "false";    
        num_con_errors_for_align_loss  :  integer := 2;    
        num_con_good_data_for_align_approach: integer := 3;    
        num_con_align_chars_for_align  :  integer := 4;    
        offset_all_errors_align        :  string := "false";    
        dprio_config_mode              :  INTEGER := 0;                 -- 6.1
        rx_dprio_width                 :  INTEGER := 800;               -- 6.1
        tx_dprio_width                 :  INTEGER := 400;               -- 6.1        
        lpm_type                       :  string := "arriagx_hssi_central_management_unit";
        rx0_cru_clock0_physical_mapping:  string := "refclk0";    
        rx0_cru_clock1_physical_mapping:  string := "refclk1";    
        rx0_cru_clock2_physical_mapping:  string := "iq0";    
        rx0_cru_clock3_physical_mapping:  string := "iq1";    
        rx0_cru_clock4_physical_mapping:  string := "iq2";    
        rx0_cru_clock5_physical_mapping:  string := "iq3";    
        rx0_cru_clock6_physical_mapping:  string := "iq4";    
        rx0_cru_clock7_physical_mapping:  string := "pld_cru_clk";    
        rx0_cru_clock8_physical_mapping:  string := "cmu_div_clk";    
        rx1_cru_clock0_physical_mapping:  string := "refclk0";    
        rx1_cru_clock1_physical_mapping:  string := "refclk1";    
        rx1_cru_clock2_physical_mapping:  string := "iq0";    
        rx1_cru_clock3_physical_mapping:  string := "iq1";    
        rx1_cru_clock4_physical_mapping:  string := "iq2";    
        rx1_cru_clock5_physical_mapping:  string := "iq3";    
        rx1_cru_clock6_physical_mapping:  string := "iq4";    
        rx1_cru_clock7_physical_mapping:  string := "pld_cru_clk";    
        rx1_cru_clock8_physical_mapping:  string := "cmu_div_clk";    
        rx2_cru_clock0_physical_mapping:  string := "refclk0";    
        rx2_cru_clock1_physical_mapping:  string := "refclk1";    
        rx2_cru_clock2_physical_mapping:  string := "iq0";    
        rx2_cru_clock3_physical_mapping:  string := "iq1";    
        rx2_cru_clock4_physical_mapping:  string := "iq2";    
        rx2_cru_clock5_physical_mapping:  string := "iq3";    
        rx2_cru_clock6_physical_mapping:  string := "iq4";    
        rx2_cru_clock7_physical_mapping:  string := "pld_cru_clk";    
        rx2_cru_clock8_physical_mapping:  string := "cmu_div_clk";    
        rx3_cru_clock0_physical_mapping:  string := "refclk0";    
        rx3_cru_clock1_physical_mapping:  string := "refclk1";    
        rx3_cru_clock2_physical_mapping:  string := "iq0";    
        rx3_cru_clock3_physical_mapping:  string := "iq1";    
        rx3_cru_clock4_physical_mapping:  string := "iq2";    
        rx3_cru_clock5_physical_mapping:  string := "iq3";    
        rx3_cru_clock6_physical_mapping:  string := "iq4";    
        rx3_cru_clock7_physical_mapping:  string := "pld_cru_clk";    
        rx3_cru_clock8_physical_mapping:  string := "cmu_div_clk";  
        tx0_pll_fast_clk0_physical_mapping: string := "pll0";    
        tx0_pll_fast_clk1_physical_mapping: string := "pll1";    
        tx1_pll_fast_clk0_physical_mapping: string := "pll0";    
        tx1_pll_fast_clk1_physical_mapping: string := "pll1";    
        tx2_pll_fast_clk0_physical_mapping: string := "pll0";    
        tx2_pll_fast_clk1_physical_mapping: string := "pll1";    
        tx3_pll_fast_clk0_physical_mapping: string := "pll0";    
        tx3_pll_fast_clk1_physical_mapping: string := "pll1";   
        pll0_inclk0_logical_to_physical_mapping: string := "iq0";
        pll0_inclk1_logical_to_physical_mapping: string := "iq1";
        pll0_inclk2_logical_to_physical_mapping: string := "iq2";
        pll0_inclk3_logical_to_physical_mapping: string := "iq3";
        pll0_inclk4_logical_to_physical_mapping: string := "iq4";
        pll0_inclk5_logical_to_physical_mapping: string := "pld_clk";
        pll0_inclk6_logical_to_physical_mapping: string := "clkrefclk0";
        pll0_inclk7_logical_to_physical_mapping: string := "clkrefclk1";
        pll1_inclk0_logical_to_physical_mapping: string := "iq0";
        pll1_inclk1_logical_to_physical_mapping: string := "iq1";
        pll1_inclk2_logical_to_physical_mapping: string := "iq2";
        pll1_inclk3_logical_to_physical_mapping: string := "iq3";
        pll1_inclk4_logical_to_physical_mapping: string := "iq4";
        pll1_inclk5_logical_to_physical_mapping: string := "pld_clk";
        pll1_inclk6_logical_to_physical_mapping: string := "clkrefclk0";
        pll1_inclk7_logical_to_physical_mapping: string := "clkrefclk1";
        pll2_inclk0_logical_to_physical_mapping: string := "iq0";
        pll2_inclk1_logical_to_physical_mapping: string := "iq1";
        pll2_inclk2_logical_to_physical_mapping: string := "iq2";
        pll2_inclk3_logical_to_physical_mapping: string := "iq3";
        pll2_inclk4_logical_to_physical_mapping: string := "iq4";
        pll2_inclk5_logical_to_physical_mapping: string := "pld_clk";
        pll2_inclk6_logical_to_physical_mapping: string := "clkrefclk0";
        pll2_inclk7_logical_to_physical_mapping: string := "clkrefclk1";
        cmu_divider_inclk0_physical_mapping: string := "pll0";    
        cmu_divider_inclk1_physical_mapping: string := "pll1";    
        cmu_divider_inclk2_physical_mapping: string := "pll2";  
        rx0_logical_to_physical_mapping:  integer := 0;    
        rx1_logical_to_physical_mapping:  integer := 1;    
        rx2_logical_to_physical_mapping:  integer := 2;    
        rx3_logical_to_physical_mapping:  integer := 3;    
        tx0_logical_to_physical_mapping:  integer := 0;    
        tx1_logical_to_physical_mapping:  integer := 1;    
        tx2_logical_to_physical_mapping:  integer := 2;    
        tx3_logical_to_physical_mapping:  integer := 3;    
        pll0_logical_to_physical_mapping: integer := 0;    
        pll1_logical_to_physical_mapping: integer := 1;    
        pll2_logical_to_physical_mapping: integer := 2;   
        refclk_divider0_logical_to_physical_mapping: integer := 0;    
        refclk_divider1_logical_to_physical_mapping: integer := 1;    
        sim_dump_dprio_internal_reg_at_time: integer := 0;
        sim_dump_filename: string := "sim_dprio_dump.txt";
        analog_test_bus_enable:  string := "false";    
        bypass_bandgap:  string := "true";    
        central_test_bus_select:  integer := 5;
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: String  := "*";
        tipd_dpclk: VitalDelayType01 := DefpropDelay01;
        tipd_dpriodisable: VitalDelayType01 := DefpropDelay01;
        tipd_dprioin: VitalDelayType01 := DefpropDelay01;
        tipd_dprioload: VitalDelayType01 := DefpropDelay01;
        tipd_fixedclk: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tipd_quadenable: VitalDelayType01 := DefpropDelay01;
        tipd_quadreset: VitalDelayType01 := DefpropDelay01;
        tipd_rxanalogreset: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tipd_rxclk: VitalDelayType01 := DefpropDelay01;
        tipd_rxdigitalreset: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tipd_rxpowerdown: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tipd_txclk: VitalDelayType01 := DefpropDelay01;
        tipd_txdigitalreset: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
		tsetup_dprioin_dpclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_dprioin_dpclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        tpd_dpclk_dprioout_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_dpclk_dpriooe_posedge: VitalDelayType01 := DefPropDelay01
    );
    PORT (
        adet                    : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        cmudividerdprioin       : IN std_logic_vector(29 DOWNTO 0)  := (OTHERS => '0');   
        cmuplldprioin           : IN std_logic_vector(119 DOWNTO 0)  := (OTHERS => '0');   
        dpclk                   : IN std_logic := '0';   
        dpriodisable            : IN std_logic := '1';   
        dprioin                 : IN std_logic := '0';   
        dprioload               : IN std_logic := '0';   
        fixedclk                : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        quadenable              : IN std_logic := '1';   
        quadreset               : IN std_logic := '0';   
        rdalign                 : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        rdenablesync            : IN std_logic := '1';   
        recovclk                : IN std_logic := '0';   
        refclkdividerdprioin    : IN std_logic_vector(1 DOWNTO 0)  := (OTHERS => '0');   
        rxanalogreset           : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        rxclk                   : IN std_logic := '0';   
        rxctrl                  : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        rxdatain                : IN std_logic_vector(31 DOWNTO 0)  := (OTHERS => '0');   
        rxdatavalid             : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        rxdprioin               : IN std_logic_vector(rx_dprio_width - 1 DOWNTO 0)  := (OTHERS => '0');   
        rxpowerdown             : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        rxrunningdisp           : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        syncstatus              : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        txclk                   : IN std_logic := '0';   
        txctrl                  : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        txdatain                : IN std_logic_vector(31 DOWNTO 0)  := (OTHERS => '0');   
        txdigitalreset          : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   
        txdprioin               : IN std_logic_vector(tx_dprio_width - 1 DOWNTO 0)  := (OTHERS => '0');   
        alignstatus             : OUT std_logic;   
        clkdivpowerdn           : OUT std_logic;   
        cmudividerdprioout      : OUT std_logic_vector(29 DOWNTO 0);   
        cmuplldprioout          : OUT std_logic_vector(119 DOWNTO 0);   
        dpriodisableout         : OUT std_logic;   
        dpriooe                 : OUT std_logic;   
        dprioout                : OUT std_logic;   
        enabledeskew            : OUT std_logic;   
        fiforesetrd             : OUT std_logic;   
        pllresetout             : OUT std_logic_vector(2 DOWNTO 0);   
        pllpowerdn              : OUT std_logic_vector(2 DOWNTO 0);   
        quadresetout            : OUT std_logic;   
        refclkdividerdprioout   : OUT std_logic_vector(1 DOWNTO 0);   
        rxadcepowerdn           : OUT std_logic_vector(3 DOWNTO 0);   
        rxadceresetout          : OUT std_logic_vector(3 DOWNTO 0);   
        rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
        rxcruresetout           : OUT std_logic_vector(3 DOWNTO 0);   
        rxcrupowerdn            : OUT std_logic_vector(3 DOWNTO 0);   
        rxctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
        rxdataout               : OUT std_logic_vector(31 DOWNTO 0);   
        rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
        rxdprioout              : OUT std_logic_vector(rx_dprio_width - 1 DOWNTO 0);   
        rxibpowerdn             : OUT std_logic_vector(3 DOWNTO 0);   
        txctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
        txdataout               : OUT std_logic_vector(31 DOWNTO 0);   
        txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
        txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
        txdetectrxpowerdn       : OUT std_logic_vector(3 DOWNTO 0);   
        txdividerpowerdn        : OUT std_logic_vector(3 DOWNTO 0);   
        txobpowerdn             : OUT std_logic_vector(3 DOWNTO 0);   
        txdprioout              : OUT std_logic_vector(tx_dprio_width - 1 DOWNTO 0);   
        digitaltestout          : OUT std_logic_vector(9 DOWNTO 0)
        );   
END COMPONENT;

--
-- arriagx_hssi_receiver
--

COMPONENT arriagx_hssi_receiver
    GENERIC (
        adaptive_equalization_mode     :  string  := "none";    --  <continuous/stopped/none>; 
        align_loss_sync_error_num      :  integer := 4;    --  <integer 0-7>;// wordalign
        align_ordered_set_based        :  string  := "false";    --  <true/false>;           
        align_pattern                  :  string := "0101111100";    --   word align: size of align_pattern_length; 
        align_pattern_length           :  integer := 10;    --  <7, 8, 10, 16, 20, 32, 40>; 
        align_to_deskew_pattern_pos_disp_only: string := "false";    --  <true/false>;
        allow_align_polarity_inversion :  string := "false";    --  <true/false>; 
        allow_pipe_polarity_inversion  :  string := "false";    --  <true/false>;
        allow_serial_loopback          :  string := "false";    --  <true/false>;
        bandwidth_mode                 :  integer := 0;    --  <integer 0-3>;
        bit_slip_enable                :  string := "false";    --  <true/false>;
        byte_order_pad_pattern         :  string := "0101111100";    --  <10-bit binary string>;            
        byte_order_pattern             :  string := "0101111100";    --  <10-bit binary string>;
        byte_ordering_mode             :  string  := "none";    --  <none/pattern-based/syncstatus-based>;
        channel_number                 :  integer := 0;    --  <integer 0-3>;
        channel_bonding                :  string  := "none";    --  <none, x4, x8>;
        channel_width                  :  integer := 10;    --  <integer 8,10,16,20,32,40>;
        clk1_mux_select                :  string := "recvd_clk";    --  <recvd_clk, master_clk, local_refclk, digital_refclk>;      
        clk2_mux_select                :  string := "recvd_clk";    --  <recvd_clk, local_refclk, digital_refclk, core_clk>;
        cru_clock_select               :  integer := 0;    --   <CRUCLK<n> where n is 0 through 7 >
        cru_divide_by                  :  integer := 1;    --  <1,2,4>;
        cru_multiply_by                :  integer := 10;    --  <1,2,4,5,8,10,16,20,25>;
        cru_pre_divide_by              :  integer := 1;    --  <1,2,4,8>;
        cruclk0_period                 :  integer := 10000;    --   in ps
        cruclk1_period                 :  integer := 10000;    --   in ps
        cruclk2_period                 :  integer := 10000;    --   in ps
        cruclk3_period                 :  integer := 10000;    --   in ps
        cruclk4_period                 :  integer := 10000;    --   in ps
        cruclk5_period                 :  integer := 10000;    --   in ps
        cruclk6_period                 :  integer := 10000;    --   in ps
        cruclk7_period                 :  integer := 10000;    --   in ps
        datapath_protocol              :  string := "basic";    --  <basic/pipe/xaui>;
        dec_8b_10b_compatibility_mode  :  string := "true";    --  <true/false>;
        dec_8b_10b_mode                :  string  := "none";    --  <normal/cascaded/none>;
        deskew_pattern                 :  string := "1100111100";    --  K28.3
        disable_auto_idle_insertion    :  string := "false";    --  <true/false>;  
        disable_ph_low_latency_mode    :  string  := "false";    --  <true/false>;       
        disable_running_disp_in_word_align: string := "false";    --  <true/false>; 
        disallow_kchar_after_pattern_ordered_set: string := "false";    --  <true/false>;
        dprio_mode                     :  string  := "none";    --  <none/pma_electricals/full>;
        enable_bit_reversal            :  string  := "false";    --  <true/false>;
        enable_byte_order_control_sig  :  string  := "false";    --  <true/false>;           
        enable_dc_coupling             :  string  := "false";    --  <true/false>;
        enable_deep_align              :  string  := "false";    --  <true/false>;                          
        enable_deep_align_byte_swap    :  string  := "false";    --  <true/false>;
        enable_lock_to_data_sig        :  string  := "false";    --  <true/false>;
        enable_lock_to_refclk_sig      :  string  := "true";    --  <true/false>;
        enable_self_test_mode          :  string  := "false";    --  <true/false>;
        enable_true_complement_match_in_word_align: string  := "true";    --  <true/false>; 
        eq_adapt_seq_control           :  integer := 0;    --  <integer 0-3>; 
        eq_max_gradient_control        :  integer := 0;    --  <integer 0-7>;
        equalizer_ctrl_a               :  integer := 0;    --  <integer 0-7>;
        equalizer_ctrl_b               :  integer := 0;    --  < integer 0-7>;
        equalizer_ctrl_c               :  integer := 0;    --  < integer 0-7>;
        equalizer_ctrl_d               :  integer := 0;    --  < integer 0-7>;
        equalizer_ctrl_v               :  integer := 0;    --  < integer 0-7>;
        equalizer_dc_gain              :  integer := 0;    --  <integer 0-3>;
        force_freq_det_high            :  string  := "false";    --  <true/false>;
        force_freq_det_low             :  string  := "false";    --  <true/false>;
        force_signal_detect            :  string  := "false";    --  <true/false>;
        force_signal_detect_dig        :  string  := "false";    --  <true/false>;
        ignore_lock_detect             :  string  := "false";    --  <true/false>;
        infiniband_invalid_code        :  integer := 0;    --  <integer 0-3>;
        insert_pad_on_underflow        :  string  := "false";    
        num_align_code_groups_in_ordered_set: integer := 1;    --  <integer 0-3>;   
        num_align_cons_good_data       :  integer := 3;    --  wordalign<Integer 1-256>;
        num_align_cons_pat             :  integer := 4;    --  <Integer 1-256>;
        phystatus_reset_toggle         :  string  := "false";    --  new in 6.0 - default false
        ppmselect                      :  integer := 20;    --  <integer 0-63>;           
        prbs_all_one_detect            :  string  := "false";    --  <true/false>;
        rate_match_almost_empty_threshold: integer := 11;    --  <integer 0-15>;           
        rate_match_almost_full_threshold: integer := 13;    --  <integer 0-15>;           
        rate_match_back_to_back        :  string  := "false";    --  <true/false>;           
        rate_match_fifo_mode           :  string  := "none";    --  <normal/cascaded/generic/cascaded_generic/none>;
        rate_match_ordered_set_based   :  string  := "false";
        rate_match_pattern_size        :  integer := 10;    --  <integer 10 or 20>;
        rate_match_pattern1            :  string := "00000000000010111100";    --  <20-bit binary string>;           
        rate_match_pattern2            :  string := "00000000000010111100";    --  <20-bit binary string>;           
        rate_match_skip_set_based      :  string  := "false";    --  <true/false>;  
        rd_clk_mux_select              :  string := "int_clk";    --  <int_clk, core_clk>;
        recovered_clk_mux_select       :  string := "recvd_clk";    --  <recvd_clk, local_refclk, digital_refclk>; 
        reset_clock_output_during_digital_reset: string  := "false";    --  <true/false>;
        run_length                     :  integer := 200;    --  <5-320 or 4-254 depending on the deserialization factor>; 
        run_length_enable              :  string  := "false";    --  <true/false>; 
        rx_detect_bypass               :  string  := "false";    
        self_test_mode                 :  string := "incremental";    --  <PRBS_7,PRBS_8,PRBS_10,PRBS_23,low_freq,mixed_freq,high_freq,incremental,cjpat,crpat>;
        send_direct_reverse_serial_loopback: string  := "false";    --  <true/false>;
        signal_detect_threshold        :  integer := 0;    --  <integer 0-7 (actual values determined after PE char)>;
        termination                    :  string  := "OCT_100_OHMS";    --  new in 5.1 SP1
        use_align_state_machine        :  string  := "false";    --  <true/false>;
        use_deserializer_double_data_mode: string  := "false";    --  <true/false>;
        use_deskew_fifo                :  string  := "false";    --  <true/false>;                                                  
        use_double_data_mode           :  string  := "false";    --  <true/false>; 
        use_parallel_loopback          :  string  := "false";    --  <true/false>;
        use_rate_match_pattern1_only   :  string  := "false";    --  <true/false>;           
        use_rising_edge_triggered_pattern_align: string  := "false";    --  <true/false>; 
        common_mode                        :  string  := "0.9V";    -- new in 5.1 SP1
        loop_filter_resistor_control         :  integer := 0;    --  new in 6.0;
        loop_filter_ripple_capacitor_control :  integer := 0;    --  new in 6.0;
        pd_mode_charge_pump_current_control  :  integer := 0;    --  new in 6.0;
        signal_detect_hysteresis_enabled   :  string  := "false";    -- new in 5.1 SP1
        single_detect_hysteresis_enabled   :  string  := "false";   -- new in 5.1 SP1 - used in code
        use_termvoltage_signal             :  string  := "true";    -- new in 5.1 SP1
        vco_range                          :  string  := "high";    -- new in 6.0
        sim_offset_cycle_count             :  integer := 10;        -- new in 7.1 for adce
        protocol_hint                      :  string  := "basic";   -- new in 6.0
        dprio_config_mode                  :  INTEGER := 0;                 -- 6.1
        dprio_width                        :  INTEGER := 200;               -- 6.1
        allow_vco_bypass               :  string  := "false";    --  <true/false>
        charge_pump_current_control    :  integer := 0;    --  <integer 0-3>;
        up_dn_mismatch_control         :  integer := 0;    --  <integer 0-3>;
        charge_pump_test_enable        :  string  := "false";    --  <true/false>;
        charge_pump_current_test_control_pos: string  := "false";    --  <true/false>
        charge_pump_tristate_enable    :  string  := "false";    --  <true/false>;
        low_speed_test_select          :  integer := 0;    --  <integer 0-15>;
        cru_clk_sel_during_vco_bypass  :  string := "refclk1";    --  <refclk1/refclk2/ext1/ext2>
        test_bus_sel                   :  integer := 0 ;   --  <integer 0-7>;
        enable_phfifo_bypass           :  string := "false";
        sim_rxpll_clkout_phase_shift   :  integer := 0;
        sim_rxpll_clkout_latency       :  integer := 0;
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: String  := "*";
        tipd_a1a2size: VitalDelayType01 := DefpropDelay01;
        tipd_adcepowerdn: VitalDelayType01 := DefpropDelay01;
        tipd_adcereset: VitalDelayType01 := DefpropDelay01;
        tipd_alignstatus: VitalDelayType01 := DefpropDelay01;
        tipd_alignstatussync: VitalDelayType01 := DefpropDelay01;
        tipd_analogreset: VitalDelayType01 := DefpropDelay01;
        tipd_bitslip: VitalDelayType01 := DefpropDelay01;
        tipd_coreclk: VitalDelayType01 := DefpropDelay01;
        tipd_cruclk: VitalDelayArrayType01(8 downto 0) := (OTHERS => DefPropDelay01);
        tipd_crupowerdn: VitalDelayType01 := DefpropDelay01;
        tipd_crureset: VitalDelayType01 := DefpropDelay01;
        tipd_datain: VitalDelayType01 := DefpropDelay01;
        tipd_digitalreset: VitalDelayType01 := DefpropDelay01;
        tipd_disablefifordin: VitalDelayType01 := DefpropDelay01;
        tipd_disablefifowrin: VitalDelayType01 := DefpropDelay01;
        tipd_dpriodisable: VitalDelayType01 := DefpropDelay01;
        tipd_enabledeskew: VitalDelayType01 := DefpropDelay01;
        tipd_enabyteord: VitalDelayType01 := DefpropDelay01;
        tipd_enapatternalign: VitalDelayType01 := DefpropDelay01;
        tipd_fifordin: VitalDelayType01 := DefpropDelay01;
        tipd_fiforesetrd: VitalDelayType01 := DefpropDelay01;
        tipd_ibpowerdn: VitalDelayType01 := DefpropDelay01;
        tipd_invpol: VitalDelayType01 := DefpropDelay01;
        tipd_localrefclk: VitalDelayType01 := DefpropDelay01;
        tipd_locktodata: VitalDelayType01 := DefpropDelay01;
        tipd_locktorefclk: VitalDelayType01 := DefpropDelay01;
        tipd_masterclk: VitalDelayType01 := DefpropDelay01;
        tipd_parallelfdbk: VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
        tipd_phfifordenable: VitalDelayType01 := DefpropDelay01;
        tipd_phfiforeset: VitalDelayType01 := DefpropDelay01;
        tipd_phfifowrdisable: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox4bytesel: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox4rdenable: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox4wrclk: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox4wrenable: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox8bytesel: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox8rdenable: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox8wrclk: VitalDelayType01 := DefpropDelay01;
        tipd_phfifox8wrenable: VitalDelayType01 := DefpropDelay01;
        tipd_pipe8b10binvpolarity: VitalDelayType01 := DefpropDelay01;
        tipd_pipepowerdown: VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
        tipd_pipepowerstate: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tipd_quadreset: VitalDelayType01 := DefpropDelay01;
        tipd_refclk: VitalDelayType01 := DefpropDelay01;
        tipd_revbitorderwa: VitalDelayType01 := DefpropDelay01;
        tipd_revbyteorderwa: VitalDelayType01 := DefpropDelay01;
        tipd_rmfifordena: VitalDelayType01 := DefpropDelay01;
        tipd_rmfiforeset: VitalDelayType01 := DefpropDelay01;
        tipd_rmfifowrena: VitalDelayType01 := DefpropDelay01;
        tipd_rxdetectvalid: VitalDelayType01 := DefpropDelay01;
        tipd_rxfound: VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
        tipd_serialfdbk: VitalDelayType01 := DefpropDelay01;
        tipd_seriallpbken: VitalDelayType01 := DefpropDelay01;
        tipd_termvoltage: VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
        tipd_testsel: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tipd_xgmctrlin: VitalDelayType01 := DefpropDelay01;
        tipd_xgmdatain: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
        tsetup_phfifordenable_coreclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_phfifordenable_coreclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        tpd_coreclk_a1a2sizeout_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_ctrldetect_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_dataout_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_dataoutfull_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_disperr_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_errdetect_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_patterndetect_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_rmfifodatadeleted_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_rmfifodatainserted_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_runningdisp_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_syncstatus_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_pipebufferstat_posedge : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
        tpd_coreclk_byteorderalignstatus_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_phfifooverflow_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_phfifounderflow_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_pipestatus_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_pipephydonestatus_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_pipedatavalid_posedge: VitalDelayType01 := DefPropDelay01
        );   
    PORT (
        a1a2size                : IN std_logic := '0';   
        adcepowerdn             : IN std_logic := '0';   
        adcereset               : IN std_logic := '0';   
        alignstatus             : IN std_logic := '0';   
        alignstatussync         : IN std_logic := '0';   
        analogreset             : IN std_logic := '0';   
        bitslip                 : IN std_logic := '0';   
        coreclk                 : IN std_logic := '0';   
        cruclk                  : IN std_logic_vector(8 DOWNTO 0)  := (OTHERS => '0');   
        crupowerdn              : IN std_logic := '0';   
        crureset                : IN std_logic := '0';   
        datain                  : IN std_logic := '0';   
        digitalreset            : IN std_logic := '0';   
        disablefifordin         : IN std_logic := '0';   
        disablefifowrin         : IN std_logic := '0';   
        dpriodisable            : IN std_logic := '1';   
        dprioin                 : IN std_logic_vector(dprio_width - 1 DOWNTO 0) := (OTHERS => '0');   
        enabledeskew            : IN std_logic := '0';   
        enabyteord              : IN std_logic := '0';   
        enapatternalign         : IN std_logic := '0';   
        fifordin                : IN std_logic := '0';   
        fiforesetrd             : IN std_logic := '0';   
        ibpowerdn               : IN std_logic := '0';   
        invpol                  : IN std_logic := '0';   
        localrefclk             : IN std_logic := '0';   
        locktodata              : IN std_logic := '0';   
        locktorefclk            : IN std_logic := '0';   
        masterclk               : IN std_logic := '0';   
        parallelfdbk            : IN std_logic_vector(19 DOWNTO 0) := (OTHERS => '0');   
        phfifordenable          : IN std_logic := '1';   
        phfiforeset             : IN std_logic := '0';   
        phfifowrdisable         : IN std_logic := '0';   
        phfifox4bytesel         : IN std_logic := '0';   
        phfifox4rdenable        : IN std_logic := '0';   
        phfifox4wrclk           : IN std_logic := '0';   
        phfifox4wrenable        : IN std_logic := '0';   
        phfifox8bytesel         : IN std_logic := '0';   
        phfifox8rdenable        : IN std_logic := '0';   
        phfifox8wrclk           : IN std_logic := '0';   
        phfifox8wrenable        : IN std_logic := '0';   
        pipe8b10binvpolarity    : IN std_logic := '0';   --  new in rev1.2
        pipepowerdown           : IN std_logic_vector(1 DOWNTO 0)  := (OTHERS => '0');   --  width from 1 -> 2 in rev1.2
        pipepowerstate          : IN std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');   --  width change from 3 to 4 in rev1.3
        quadreset               : IN std_logic := '0';   
        refclk                  : IN std_logic := '0';   
        revbitorderwa           : IN std_logic := '0';   
        revbyteorderwa          : IN std_logic := '0';   
        rmfifordena             : IN std_logic := '1';   
        rmfiforeset             : IN std_logic := '0';   
        rmfifowrena             : IN std_logic := '1';   
        rxdetectvalid           : IN std_logic := '0';   
        rxfound                 : IN std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');   
        serialfdbk              : IN std_logic := '0';   
        seriallpbken            : IN std_logic := '0';   
        termvoltage             : IN std_logic_vector(2 DOWNTO 0) := (OTHERS => '0');   
        testsel                 : IN std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');   
        xgmctrlin               : IN std_logic := '0';   
        xgmdatain               : IN std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');   
        a1a2sizeout             : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        a1detect                : OUT std_logic_vector(rx_top_a1k1_out_width(use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        a2detect                : OUT std_logic_vector(rx_top_a1k1_out_width(use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        adetectdeskew           : OUT std_logic;   
        alignstatussyncout      : OUT std_logic;   
        analogtestbus           : OUT std_logic_vector(7 DOWNTO 0);   
        bistdone                : OUT std_logic;   
        bisterr                 : OUT std_logic;   
        byteorderalignstatus    : OUT std_logic;   
        clkout                  : OUT std_logic;   
        cmudivclkout            : OUT std_logic;   
        ctrldetect              : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);   
        dataoutfull             : OUT std_logic_vector(63 DOWNTO 0);   
        disablefifordout        : OUT std_logic;   
        disablefifowrout        : OUT std_logic;   
        disperr                 : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        dprioout                : OUT std_logic_vector(dprio_width - 1 DOWNTO 0);   
        errdetect               : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        fifordout               : OUT std_logic;   
        freqlock                : OUT std_logic;   
        k1detect                : OUT std_logic_vector(rx_top_a1k1_out_width(use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        k2detect                : OUT std_logic_vector(1 DOWNTO 0);   
        patterndetect           : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        phaselockloss           : OUT std_logic;   
        phfifobyteselout        : OUT std_logic;   
        phfifooverflow          : OUT std_logic;   
        phfifordenableout       : OUT std_logic;   
        phfifounderflow         : OUT std_logic;   
        phfifowrclkout          : OUT std_logic;   
        phfifowrenableout       : OUT std_logic;   
        pipebufferstat          : OUT std_logic_vector(3 DOWNTO 0);   
        pipedatavalid           : OUT std_logic;   
        pipeelecidle            : OUT std_logic;   
        pipephydonestatus       : OUT std_logic;   
        pipestatus              : OUT std_logic_vector(2 DOWNTO 0);   
        pipestatetransdoneout   : OUT std_logic;   
        rdalign                 : OUT std_logic;   
        recovclkout             : OUT std_logic;   
        revparallelfdbkdata     : OUT std_logic_vector(19 DOWNTO 0);   
        revserialfdbkout        : OUT std_logic;   
        rlv                     : OUT std_logic;   
        rmfifoalmostempty       : OUT std_logic;   
        rmfifoalmostfull        : OUT std_logic;   
        rmfifodatadeleted       : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        rmfifodatainserted      : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        rmfifoempty             : OUT std_logic;   
        rmfifofull              : OUT std_logic;   
        runningdisp             : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        signaldetect            : OUT std_logic;   
        syncstatus              : OUT std_logic_vector(rx_top_ctrl_out_width(use_double_data_mode,use_deserializer_double_data_mode) - 1 DOWNTO 0);   
        syncstatusdeskew        : OUT std_logic;   
        xgmctrldet              : OUT std_logic;   
        xgmdataout              : OUT std_logic_vector(7 DOWNTO 0);   
        xgmdatavalid            : OUT std_logic;   
        xgmrunningdisp          : OUT std_logic);   
END COMPONENT;

--
-- arriagx_hssi_transmitter
--

COMPONENT arriagx_hssi_transmitter
    GENERIC (
        allow_polarity_inversion       :  string := "false";    
        channel_bonding                :  string := "none";    --  none, x8, x4
        channel_number                 :  integer := 0;    
        channel_width                  :  integer := 8;    
        disable_ph_low_latency_mode    :  string := "false";    
        disparity_mode                 :  string := "none";    --  legacy, new, none
        divider_refclk_select_pll_fast_clk0: string := "true";    
        dprio_mode                     :  string := "none";    
        elec_idle_delay                :  integer := 5;        -- new in 6.0   
        enable_bit_reversal            :  string := "false";    
        enable_idle_selection          :  string := "false";    
        enable_symbol_swap             :  string := "false";    
        enable_reverse_parallel_loopback: string := "false";    
        enable_reverse_serial_loopback :  string := "false";    
        enable_self_test_mode          :  string := "false";    
        enc_8b_10b_compatibility_mode  :  string := "true";    
        enc_8b_10b_mode                :  string := "none";    --  cascade, normal, none
        force_echar                    :  string := "false";    
        force_kchar                    :  string := "false";    
        low_speed_test_select          :  integer := 0;    
        prbs_all_one_detect            :  string := "false";    
        protocol_hint                  :  string  := "basic";   -- new in 6.0
        refclk_divide_by               :  integer := 1;    
        refclk_select                  :  string := "local";    --  cmu_clk_divider
        reset_clock_output_during_digital_reset: string := "false";    
        rxdetect_ctrl                  :  integer := 0;    
        self_test_mode                 :  string := "incremental";    
        serializer_clk_select          :  string := "local";    --  analogx4refclk, anlogx8refclk
        transmit_protocol              :  string := "basic";    --  xaui-pipe-gige-basic?
        use_double_data_mode           :  string := "false";    
        use_serializer_double_data_mode:  string := "false";    
        wr_clk_mux_select              :  string := "CORE_CLK";    --  INT_CLK                  -- int_clk
        vod_selection                  :  integer := 0;    
        enable_slew_rate               :  string := "false";    
        preemp_tap_1                   :  integer := 0;    
        preemp_tap_2                   :  integer := 0;    
        preemp_pretap                  :  integer := 0;    
        termination                    :  string  := "OCT_100_OHMS";    --  new in 5.1 SP1
        preemp_tap_2_inv               :  string  := "false";           -- New in rev 2.1
        preemp_pretap_inv              :  string  := "false";           -- New in rev 2.1
        use_termvoltage_signal         :  string  := "true";    --  new in 5.1 SP1
        common_mode                    :  string  := "0.6V";    --  new in 5.1 SP1
        analog_power                   :  string  := "1.5V";     --  new in 5.1 SP1
        dprio_config_mode              :  INTEGER := 0;                 -- 6.1
        dprio_width                    :  INTEGER := 100;               -- 6.1
        allow_vco_bypass               :  string := "false";
        enable_phfifo_bypass           :  string := "false";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: String  := "*";
        tipd_coreclk   : VitalDelayType01 := DefPropDelay01;
        tipd_ctrlenable : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_xgmctrl   : VitalDelayType01 := DefPropDelay01;
        tipd_quadreset   : VitalDelayType01 := DefPropDelay01;
        tipd_datain : VitalDelayArrayType01(39 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_datainfull : VitalDelayArrayType01(43 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_pipestatetransdone   : VitalDelayType01 := DefPropDelay01;
        tipd_phfifowrenable   : VitalDelayType01 := DefPropDelay01;
        tipd_analogx8fastrefclk   : VitalDelayType01 := DefPropDelay01;
        tipd_phfifox4wrenable   : VitalDelayType01 := DefPropDelay01;
        tipd_phfifox4bytesel   : VitalDelayType01 := DefPropDelay01;
        tipd_analogx8refclk   : VitalDelayType01 := DefPropDelay01;
        tipd_pma_width   : VitalDelayType01 := DefPropDelay01;
        tipd_phfiforeset   : VitalDelayType01 := DefPropDelay01;
        tipd_pma_doublewidth   : VitalDelayType01 := DefPropDelay01;
        tipd_revparallelfdbk : VitalDelayArrayType01(19 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_phfifox8rdclk   : VitalDelayType01 := DefPropDelay01;
        tipd_obpowerdn   : VitalDelayType01 := DefPropDelay01;
        tipd_termvoltage : VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_forceelecidle   : VitalDelayType01 := DefPropDelay01;
        tipd_powerdn : VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_forcedisp : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_forcedispcompliance   : VitalDelayType01 := DefPropDelay01;
        tipd_xgmdatain : VitalDelayArrayType01(7 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_dispval : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_analogx4fastrefclk   : VitalDelayType01 := DefPropDelay01;
        tipd_refclk   : VitalDelayType01 := DefPropDelay01;
        tipd_analogreset   : VitalDelayType01 := DefPropDelay01;
        tipd_dprioin : VitalDelayArrayType01(149 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_phfifox8rdenable   : VitalDelayType01 := DefPropDelay01;
        tipd_invpol   : VitalDelayType01 := DefPropDelay01;
        tipd_enrevparallellpbk   : VitalDelayType01 := DefPropDelay01;
        tipd_digitalreset   : VitalDelayType01 := DefPropDelay01;
        tipd_phfifox8bytesel   : VitalDelayType01 := DefPropDelay01;
        tipd_dividerpowerdn   : VitalDelayType01 := DefPropDelay01;
        tipd_analogx4refclk   : VitalDelayType01 := DefPropDelay01;
        tipd_phfifox8wrenable   : VitalDelayType01 := DefPropDelay01;
        tipd_revserialfdbk   : VitalDelayType01 := DefPropDelay01;
        tipd_clkin0   : VitalDelayType01 := DefPropDelay01;
        tipd_clkin1   : VitalDelayType01 := DefPropDelay01;
        tipd_reset   : VitalDelayType01 := DefPropDelay01;
        tipd_detectrxloop   : VitalDelayType01 := DefPropDelay01;
        tipd_pllfastclk : VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
        tipd_phfifox4rdclk   : VitalDelayType01 := DefPropDelay01;
        tipd_dpriodisable   : VitalDelayType01 := DefPropDelay01;
        tipd_phfifox4rdenable   : VitalDelayType01 := DefPropDelay01;
        tipd_detectrxpowerdn   : VitalDelayType01 := DefPropDelay01;
        tipd_phfiforddisable   : VitalDelayType01 := DefPropDelay01;
        tsetup_ctrlenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_datain_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_datainfull_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_detectrxloop_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_dispval_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_forcedisp_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_forcedispcompliance_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_forceelecidle_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_phfifowrenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_powerdn_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_ctrlenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_datain_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_datainfull_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_detectrxloop_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_dispval_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_forcedisp_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_forcedispcompliance_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_forceelecidle_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_phfifowrenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_powerdn_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tpd_coreclk_phfifooverflow_posedge  :  VitalDelayType01 := DefPropDelay01;
        tpd_coreclk_phfifounderflow_posedge :  VitalDelayType01 := DefPropDelay01
    );    
    PORT (
        analogreset             : IN std_logic := '0';   
        analogx4fastrefclk      : IN std_logic := '0';   
        analogx4refclk          : IN std_logic := '0';   
        analogx8fastrefclk      : IN std_logic := '0';   
        analogx8refclk          : IN std_logic := '0';   
        coreclk                 : IN std_logic := '0';   
        ctrlenable              : IN std_logic_vector(tx_top_ctrl_in_width(use_double_data_mode,use_serializer_double_data_mode) - 1 DOWNTO 0)  := (OTHERS => '0');   
        datain                  : IN std_logic_vector(channel_width - 1 DOWNTO 0)  := (OTHERS => '0');   
        datainfull              : IN std_logic_vector(43 DOWNTO 0)  := (OTHERS => '0');   
        detectrxloop            : IN std_logic := '0';   
        detectrxpowerdn         : IN std_logic := '0';   
        digitalreset            : IN std_logic := '0';   
        dispval                 : IN std_logic_vector(tx_top_ctrl_in_width(use_double_data_mode,use_serializer_double_data_mode) - 1 DOWNTO 0)  := (OTHERS => '0');   
        dividerpowerdn          : IN std_logic := '0';   
        dpriodisable            : IN std_logic := '1';   
        dprioin                 : IN std_logic_vector(dprio_width - 1 DOWNTO 0)  := (OTHERS => '0');   
        enrevparallellpbk       : IN std_logic := '0';   
        forcedispcompliance     : IN std_logic := '0';   
        forcedisp               : IN std_logic_vector(tx_top_ctrl_in_width(use_double_data_mode,use_serializer_double_data_mode) - 1 DOWNTO 0)  := (OTHERS => '0');   
        forceelecidle           : IN std_logic := '0';   
        invpol                  : IN std_logic := '0';   
        obpowerdn               : IN std_logic := '0';   
        phfiforddisable         : IN std_logic := '0';   
        phfiforeset             : IN std_logic := '0';   
        phfifowrenable          : IN std_logic := '1';   
        phfifox4bytesel         : IN std_logic := '0';   
        phfifox4rdclk           : IN std_logic := '0';   
        phfifox4rdenable        : IN std_logic := '0';   
        phfifox4wrenable        : IN std_logic := '0';   
        phfifox8bytesel         : IN std_logic := '0';   
        phfifox8rdclk           : IN std_logic := '0';   
        phfifox8rdenable        : IN std_logic := '0';   
        phfifox8wrenable        : IN std_logic := '0';   
        pipestatetransdone      : IN std_logic := '0';   
        pllfastclk              : IN std_logic_vector(1 DOWNTO 0)  := (OTHERS => '0');   
        powerdn                 : IN std_logic_vector(1 DOWNTO 0)  := (OTHERS => '0');   
        quadreset               : IN std_logic := '0';   
        refclk                  : IN std_logic := '0';   
        revserialfdbk           : IN std_logic := '0';   
        revparallelfdbk         : IN std_logic_vector(19 DOWNTO 0)  := (OTHERS => '0');   
        termvoltage             : IN std_logic_vector(1 DOWNTO 0)  := (OTHERS => '0');   
        vcobypassin             : IN std_logic := '0';   -- PE-POF only
        xgmctrl                 : IN std_logic := '0';   
        xgmdatain               : IN std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');   
        clkout                  : OUT std_logic;   
        dataout                 : OUT std_logic;   
        dprioout                : OUT std_logic_vector(dprio_width - 1 DOWNTO 0);   
        parallelfdbkout         : OUT std_logic_vector(19 DOWNTO 0);   
        phfifooverflow          : OUT std_logic;   
        phfifounderflow         : OUT std_logic;   
        phfifobyteselout        : OUT std_logic;   
        phfifordclkout          : OUT std_logic;   
        phfifordenableout       : OUT std_logic;   
        phfifowrenableout       : OUT std_logic;   
        pipepowerdownout        : OUT std_logic_vector(1 DOWNTO 0);   
        pipepowerstateout       : OUT std_logic_vector(3 DOWNTO 0);   
        rdenablesync            : OUT std_logic;   
        refclkout               : OUT std_logic;   
        rxdetectvalidout        : OUT std_logic;   
        rxfoundout              : OUT std_logic_vector(1 DOWNTO 0);   
        serialfdbkout           : OUT std_logic;   
        xgmctrlenable           : OUT std_logic;   
        xgmdataout              : OUT std_logic_vector(7 DOWNTO 0));   
END COMPONENT;

end arriagx_hssi_components;

package body ARRIAGX_HSSI_COMPONENTS is




function str2bin (s : string) return std_logic_vector is
variable len : integer := s'length;
variable result : std_logic_vector(39 DOWNTO 0) := (OTHERS => '0');
variable i : integer;
begin
    for i in 1 to len loop
        case s(i) is
            when '0' => result(len - i) := '0';
            when '1' => result(len - i) := '1';
            when others =>
                ASSERT FALSE
                REPORT "Illegal Character "&  s(i) & "in string parameter! "
                SEVERITY ERROR;
        end case;
    end loop;
    return result;
end;

function str2int (s : string) return integer is
variable len : integer := s'length;
variable newdigit : integer := 0;
variable sign : integer := 1;
variable digit : integer := 0;
begin
    for i in 1 to len loop
        case s(i) is
            when '-' =>
                if i = 1 then
                    sign := -1;
                else
                    ASSERT FALSE
                    REPORT "Illegal Character "&  s(i) & "i n string parameter! " SEVERITY ERROR;
                end if;
            when '0' =>
                digit := 0;
            when '1' =>
                digit := 1;
            when '2' =>
                digit := 2;
            when '3' =>
                digit := 3;
            when '4' =>
                digit := 4;
            when '5' =>
                digit := 5;
            when '6' =>
                digit := 6;
            when '7' =>
                digit := 7;
            when '8' =>
                digit := 8;
            when '9' =>
                digit := 9;
            when others =>
                ASSERT FALSE
                REPORT "Illegal Character "&  s(i) & "in string parameter! "
                SEVERITY ERROR;
        end case;
        newdigit := newdigit * 10 + digit;
    end loop;

    return (sign*newdigit);
end;

function int2bin (arg : integer; size : integer) return std_logic_vector is
    variable int_val : integer := arg;
    variable result : std_logic_vector(size-1 downto 0);
    begin
        for i in 0 to result'left loop
            if ((int_val mod 2) = 0) then
                result(i) := '0';
            else
                result(i) := '1';
            end if;
            int_val := int_val/2;
        end loop;
        return result;
    end int2bin;

function tx_top_ctrl_in_width(double_data_mode : string; 
                               ser_double_data_mode : string
                              ) return integer is
    variable real_widthb : integer;
    begin
        real_widthb := 1;
        if (ser_double_data_mode = "true" AND double_data_mode = "true") then
            real_widthb := 4;
	elsif (ser_double_data_mode = "false" AND double_data_mode = "false") then
	    real_widthb := 1;
        else
	    real_widthb := 2;
        end if;
 
        return real_widthb;
    end tx_top_ctrl_in_width;

function rx_top_a1k1_out_width(des_double_data_mode : string) return integer is
    variable real_widthb : integer;
    begin
        if (des_double_data_mode = "true") then
            real_widthb := 2;
        else 
            real_widthb := 1;
        end if;
        return real_widthb;
    end rx_top_a1k1_out_width;

function rx_top_ctrl_out_width(double_data_mode : string; 
                               des_double_data_mode : string
                              ) return integer is
    variable real_widthb : integer;
    begin
        real_widthb := 1;
        if (des_double_data_mode = "true" AND double_data_mode = "true") then
            real_widthb := 4;
        elsif (des_double_data_mode = "false" AND double_data_mode = "false") then
            real_widthb := 1;
        else
            real_widthb := 2;
        end if;
 
        return real_widthb;
    end rx_top_ctrl_out_width;

function hssiSelectDelay (CONSTANT Paths : IN  VitalPathArray01Type) return TIME IS

variable Temp  : TIME;
variable TransitionTime  : TIME := TIME'HIGH;
variable PathDelay : TIME := TIME'HIGH;

begin

    for i IN Paths'RANGE loop
        next when not Paths(i).PathCondition;

        next when Paths(i).InputChangeTime > TransitionTime;

        Temp := Paths(i).PathDelay(tr01);

        if Paths(i).InputChangeTime < TransitionTime then
            PathDelay := Temp;
        else
            if Temp < PathDelay then
                PathDelay := Temp;
            end if;
        end if;
        TransitionTime := Paths(i).InputChangeTime;
    end loop;

    return PathDelay;

end;

end ARRIAGX_HSSI_COMPONENTS;
