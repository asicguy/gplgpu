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


package ARRIAII_HSSI_COMPONENTS is



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
function bin2int (s : std_logic_vector) return integer;
function bin2int (s : std_logic) return integer;
function int2bit (arg : boolean) return std_logic;
function str2bin (s : string) return std_logic_vector;
function str2int (s : string) return integer;
function int2bin (arg : integer; size : integer) return std_logic_vector;
function int2bin (arg : boolean; size : integer) return std_logic_vector;
function int2bit (arg : integer) return std_logic;

function tx_top_ctrl_in_width(
        double_data_mode : string;
        ser_double_data_mode : string
) return integer;
function rx_top_a1k1_out_width(des_double_data_mode : string) return integer; 
function rx_top_ctrl_out_width(
	double_data_mode : string; 
        des_double_data_mode : string
) return integer; 

function rx_top_basic_width (channel_width : integer) return integer;
function rx_top_num_of_basic (channel_width : integer) return integer;


function hssiSelectDelay (CONSTANT Paths: IN  VitalPathArray01Type) return TIME;
function mux_select (sel : boolean; data1 : std_logic_vector; data2 : std_logic_vector) return std_logic_vector;
function mux_select (sel : bit; data1 : std_logic_vector; data2 : std_logic_vector) return std_logic_vector;
function mux_select (sel : boolean; data1 : std_logic; data2 : std_logic) return std_logic;
function mux_select (sel : bit; data1 : std_logic; data2 : std_logic) return std_logic;
function reduction_or (val : std_logic_vector) return std_logic;
function reduction_nor (val : std_logic_vector) return std_logic;
function reduction_xor (val : std_logic_vector) return std_logic;
function reduction_and (val : std_logic_vector) return std_logic;
function reduction_nand (val : std_logic_vector) return std_logic;
function alpha_tolower (given_string : string) return string;

function arriaii_tx_pcs_mph_fifo_xn_mapping (ph_fifo_xn_select : integer; ph_fifo_xn_mapping0 : string; ph_fifo_xn_mapping1 : string; ph_fifo_xn_mapping2 : string) return string;
function arriaii_tx_pcs_mphfifo_index ( ph_fifo_xn_select : integer) return integer;
function arriaii_tx_pcs_miqp_phfifo_index ( ph_fifo_xn_select : integer) return integer;


-- GENERIC utility functions END


TYPE CMU_MULT_STATE_TYPE IS (INITIAL,INACTIVE,ACTIVE);


--
-- arriaii_hssi_clock_divider
--

COMPONENT arriaii_hssi_clock_divider
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_refclkin               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rateswitchdonein               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_dpriodisable                : VitalDelayType01 := DefpropDelay01;
      tipd_quadreset                : VitalDelayType01 := DefpropDelay01;
      tipd_clk0in               :VitalDelayArrayType01(4 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_vcobypassin                : VitalDelayType01 := DefpropDelay01;
      tipd_clk1in               :VitalDelayArrayType01(4 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rateswitchbaseclkin               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_refclkdig                : VitalDelayType01 := DefpropDelay01;
      tipd_dprioin               :VitalDelayArrayType01(100 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_powerdn                : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitch                : VitalDelayType01 := DefpropDelay01;
      lpm_type                             : STRING := "arriaii_hssi_clock_divider";
      channel_num                          : INTEGER := 0;
      coreclk_out_gated_by_quad_reset      : STRING := "false";
      data_rate                            : INTEGER := 0;
      divide_by                            : INTEGER := 4;
      divider_type                         : STRING := "CHANNEL_REGULAR";
      dprio_config_mode                    : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      effective_data_rate                  : STRING := "unused";
      enable_dynamic_divider               : STRING := "false";
      enable_refclk_out                    : STRING := "false";
      inclk_select                         : INTEGER := 0;
      logical_channel_address              : INTEGER := 0;
      pre_divide_by                        : INTEGER := 1;
      rate_switch_base_clk_in_select       : INTEGER := 0;
      rate_switch_done_in_select           : INTEGER := 0;
      refclk_divide_by                     : INTEGER := 0;
      refclk_multiply_by                   : INTEGER := 0;
      refclkin_select                      : INTEGER := 0;
      select_local_rate_switch_base_clock  : STRING := "false";
      select_local_rate_switch_done        : STRING := "true";		-- shawn
      select_local_refclk                  : STRING := "false";
      select_refclk_dig                    : STRING := "false";
      sim_analogfastrefclkout_phase_shift  : INTEGER := 0;
      sim_analogrefclkout_phase_shift      : INTEGER := 0;
      sim_coreclkout_phase_shift           : INTEGER := 0;
      sim_refclkout_phase_shift            : INTEGER := 0;
      use_coreclk_out_post_divider         : STRING := "false";
      use_refclk_post_divider              : STRING := "false";
      use_vco_bypass                       : STRING := "false"
   );
   PORT (
      clk0in                               : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (others => '0');
      clk1in                               : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (others => '0');
      dpriodisable                         : IN STD_LOGIC := '1';
      dprioin                              : IN STD_LOGIC_VECTOR(100 - 1 DOWNTO 0) := (others => '0');
      powerdn                              : IN STD_LOGIC := '0';
      quadreset                            : IN STD_LOGIC := '0';
      rateswitch                           : IN STD_LOGIC := '0';
      rateswitchbaseclkin                  : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      rateswitchdonein                     : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      refclkdig                            : IN STD_LOGIC := '0';
      refclkin                             : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      vcobypassin                          : IN STD_LOGIC := '0';
      analogfastrefclkout                  : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      analogfastrefclkoutshifted           : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      analogrefclkout                      : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      analogrefclkoutshifted               : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      analogrefclkpulse                    : OUT STD_LOGIC;
      analogrefclkpulseshifted             : OUT STD_LOGIC;
      coreclkout                           : OUT STD_LOGIC;
      dprioout                             : OUT STD_LOGIC_VECTOR(100 - 1 DOWNTO 0);
      rateswitchbaseclock                  : OUT STD_LOGIC;
      rateswitchdone                       : OUT STD_LOGIC;
      rateswitchout                        : OUT STD_LOGIC;
      refclkout                            : OUT STD_LOGIC
   );
END COMPONENT;

--
-- arriaii_hssi_pll
--

COMPONENT arriaii_hssi_pll
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_dpriodisable                : VitalDelayType01 := DefpropDelay01;
      tipd_datain                : VitalDelayType01 := DefpropDelay01;
      tipd_areset                : VitalDelayType01 := DefpropDelay01;
      tipd_earlyeios             : VitalDelayType01 := DefpropDelay01;
      tipd_locktorefclk                : VitalDelayType01 := DefpropDelay01;
      tipd_pfdfbclk                : VitalDelayType01 := DefpropDelay01;
      tipd_powerdown                : VitalDelayType01 := DefpropDelay01;
      tipd_inclk               :VitalDelayArrayType01(10 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_dprioin               :VitalDelayArrayType01(300 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rateswitch                : VitalDelayType01 := DefpropDelay01;
      tpd_inclk_clk : VitalDelayType01 := DefPropDelay01;
      lpm_type                       : STRING := "arriaii_hssi_pll";
      auto_settings                  : STRING := "true";
      bandwidth_type                 : STRING := "Auto";
      base_data_rate                 : STRING := "unused";
      channel_num                    : INTEGER := 0;
      charge_pump_current_bits       : INTEGER := 0;
      charge_pump_mode_bits          : INTEGER := 0;
      charge_pump_test_enable        : STRING := "false";
      dprio_config_mode              : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      effective_data_rate            : STRING := "unused";
      enable_dynamic_divider         : STRING := "false";
      fast_lock_control              : STRING := "false";
      inclk0_input_period            : INTEGER := 0;
      inclk1_input_period            : INTEGER := 0;
      inclk2_input_period            : INTEGER := 0;
      inclk3_input_period            : INTEGER := 0;
      inclk4_input_period            : INTEGER := 0;
      inclk5_input_period            : INTEGER := 0;
      inclk6_input_period            : INTEGER := 0;
      inclk7_input_period            : INTEGER := 0;
      inclk8_input_period            : INTEGER := 0;
      inclk9_input_period            : INTEGER := 0;
      input_clock_frequency          : STRING := "unused";
      logical_channel_address        : INTEGER := 0;
      logical_tx_pll_number          : INTEGER := 0;
      loop_filter_c_bits             : INTEGER := 0;
      loop_filter_r_bits             : INTEGER := 0;
      m                              : INTEGER := 0;
      n                              : INTEGER := 0;
      pd_charge_pump_current_bits    : INTEGER := 0;
      pd_loop_filter_r_bits          : INTEGER := 0;
      pfd_clk_select                 : INTEGER := 0;
      pfd_fb_select                  : STRING := "internal";
      pll_type                       : STRING := "Auto";
      protocol_hint                  : STRING := "basic";
      refclk_divide_by               : INTEGER := 0;
      refclk_multiply_by             : INTEGER := 0;
      sim_is_negative_ppm_drift      : STRING := "false";
      sim_net_ppm_variation          : INTEGER := 0;
      test_charge_pump_current_down  : STRING := "false";
      test_charge_pump_current_up    : STRING := "false";
      use_refclk_pin                 : STRING := "false";
      vco_data_rate                  : INTEGER := 0;
      vco_divide_by                  : INTEGER := 0;
      vco_range                      : STRING := "low";
      vco_multiply_by                : INTEGER := 0;
      vco_post_scale                 : INTEGER := 0;
      vco_tuning_bits                : INTEGER := 0;
      volt_reg_control_bits          : INTEGER := 0;
      volt_reg_output_bits           : INTEGER := 0;
      sim_clkout_phase_shift         : INTEGER := 0;
      sim_clkout_latency             : INTEGER := 0;
      PARAM_DELAY                    : INTEGER := 0
   );
   PORT (
      areset                         : IN STD_LOGIC := '0';
      datain                         : IN STD_LOGIC := '0';
      dpriodisable                   : IN STD_LOGIC := '1';
      dprioin                        : IN STD_LOGIC_VECTOR(300 - 1 DOWNTO 0) := (others => '0');
      earlyeios                      : IN STD_LOGIC := '0';
      extra10gin                     : IN STD_LOGIC_VECTOR(6 - 1 DOWNTO 0) := (others => '0');
      inclk                          : IN STD_LOGIC_VECTOR(10 - 1 DOWNTO 0) := (others => '0');
      locktorefclk                   : IN STD_LOGIC := '1';
      pfdfbclk                       : IN STD_LOGIC := '0';
      powerdown                      : IN STD_LOGIC := '0';
      rateswitch                     : IN STD_LOGIC := '0';
      clk                            : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      dataout                        : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      dprioout                       : OUT STD_LOGIC_VECTOR(300 - 1 DOWNTO 0);
      freqlocked                     : OUT STD_LOGIC;
      locked                         : OUT STD_LOGIC;
      pfdfbclkout                    : OUT STD_LOGIC;
      pfdrefclkout                   : OUT STD_LOGIC;
      vcobypassout                   : OUT STD_LOGIC
   );
END COMPONENT;

--
-- arriaii_hssi_tx_pma
--

COMPONENT arriaii_hssi_tx_pma
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_datain               :VitalDelayArrayType01(64 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_datainfull           :VitalDelayArrayType01(20 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_refclk0inpulse                : VitalDelayType01 := DefpropDelay01;
      tipd_forceelecidle                : VitalDelayType01 := DefpropDelay01;
      tipd_pclk                : VitalDelayArrayType01(5 - 1 DOWNTO 0) := (OTHERS => DefpropDelay01);
      tipd_fastrefclk4in                : VitalDelayArrayType01(2 - 1 DOWNTO 0) := (OTHERS => DefpropDelay01);
      tipd_refclk1in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_refclk0in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_refclk4inpulse                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk4in                : VitalDelayArrayType01(2 - 1 DOWNTO 0) := (OTHERS => DefpropDelay01);
      tipd_dpriodisable                : VitalDelayType01 := DefpropDelay01;
      tipd_rxdetecten                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk1inpulse                : VitalDelayType01 := DefpropDelay01;
      tipd_fastrefclk3in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txpmareset                : VitalDelayType01 := DefpropDelay01;
      tipd_fastrefclk0in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_revserialfdbk                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk3in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_powerdn                : VitalDelayType01 := DefpropDelay01;
      tipd_fastrefclk2in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_detectrxpowerdown                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk3inpulse                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk2inpulse                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk2in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxdetectclk                : VitalDelayType01 := DefpropDelay01;
      tipd_fastrefclk1in               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_dprioin               :VitalDelayArrayType01(300 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      lpm_type                        : STRING := "arriaii_hssi_tx_pma";
      analog_power                    : STRING := "1.5V";
      channel_number                  : INTEGER := 9999;
      channel_type                    : STRING := "auto";
      clkin_select                    : INTEGER := 0; -- 9999; out of bound in loading
      clkmux_delay                    : STRING := "false";
      common_mode                     : STRING := "0.6V";
      dprio_config_mode               : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      enable_reverse_serial_loopback  : STRING := "false";
      logical_channel_address         : INTEGER := 0;
      logical_protocol_hint_0         : STRING := "basic";
      logical_protocol_hint_1         : STRING := "basic";
      logical_protocol_hint_2         : STRING := "basic";
      logical_protocol_hint_3         : STRING := "basic";
      low_speed_test_select           : INTEGER := 9999;
      physical_clkin0_mapping         : STRING := "x1";
      physical_clkin1_mapping         : STRING := "x4";
      physical_clkin2_mapping         : STRING := "xn_top";
      physical_clkin3_mapping         : STRING := "xn_bottom";
      physical_clkin4_mapping         : STRING := "hypertransport";
      preemp_pretap                   : INTEGER := 0;
      preemp_pretap_inv               : STRING := "false";
      preemp_tap_1                    : INTEGER := 0;
      preemp_tap_1_a                  : INTEGER := 0;
      preemp_tap_1_b                  : INTEGER := 0;
      preemp_tap_1_c                  : INTEGER := 0;
      preemp_tap_2                    : INTEGER := 0;
      preemp_tap_2_inv                : STRING := "false";
      protocol_hint                   : STRING := "basic";
      rx_detect                       : INTEGER := 9999;
      serialization_factor            : INTEGER := 8;
      slew_rate                       : STRING := "low";
      termination                     : STRING := "OCT 100 Ohms";
      use_external_termination        : STRING := "false";
      use_pclk                        : STRING := "false";
      use_pma_direct                  : STRING := "false";
      use_rx_detect                   : STRING := "false";
      use_ser_double_data_mode        : STRING := "false";
      vod_selection                   : INTEGER := 0;
      vod_selection_a                 : INTEGER := 0;
      vod_selection_b                 : INTEGER := 0;
      vod_selection_c                 : INTEGER := 0;
      vod_selection_d                 : INTEGER := 0
   );
   PORT (
      datain                          : IN STD_LOGIC_VECTOR(64 - 1 DOWNTO 0) := (others => '0');
      datainfull                      : IN STD_LOGIC_VECTOR(20 - 1 DOWNTO 0) := (others => '0');
      detectrxpowerdown               : IN STD_LOGIC := '0';
      dpriodisable                    : IN STD_LOGIC := '1';
      dprioin                         : IN STD_LOGIC_VECTOR(300 - 1 DOWNTO 0) := (others => '0');
      extra10gin                      : IN STD_LOGIC_VECTOR(11 - 1 DOWNTO 0) := (others => '0');
      fastrefclk0in                   : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      fastrefclk1in                   : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      fastrefclk2in                   : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      fastrefclk3in                   : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      fastrefclk4in                   : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS => '0');
      forceelecidle                   : IN STD_LOGIC := '0';
      pclk                            : IN STD_LOGIC_VECTOR(5 - 1 DOWNTO 0) := (OTHERS => '0');
      powerdn                         : IN STD_LOGIC := '0';
      refclk0in                       : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      refclk0inpulse                  : IN STD_LOGIC := '0';
      refclk1in                       : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      refclk1inpulse                  : IN STD_LOGIC := '0';
      refclk2in                       : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      refclk2inpulse                  : IN STD_LOGIC := '0';
      refclk3in                       : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      refclk3inpulse                  : IN STD_LOGIC := '0';
      refclk4in                       : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS => '0');
      refclk4inpulse                  : IN STD_LOGIC := '0';
      revserialfdbk                   : IN STD_LOGIC := '0';
      rxdetectclk                     : IN STD_LOGIC := '0';
      rxdetecten                      : IN STD_LOGIC := '0';
      txpmareset                      : IN STD_LOGIC := '0';
      clockout                        : OUT STD_LOGIC;
      dataout                         : OUT STD_LOGIC;
      dftout                          : OUT STD_LOGIC_VECTOR(6 - 1 DOWNTO 0);
      dprioout                        : OUT STD_LOGIC_VECTOR(300 - 1 DOWNTO 0);
      rxdetectvalidout                : OUT STD_LOGIC;
      rxfoundout                      : OUT STD_LOGIC;
      seriallpbkout                   : OUT STD_LOGIC
   );
END COMPONENT;

--
-- arriaii_hssi_rx_pma
--

COMPONENT arriaii_hssi_rx_pma
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_ppmdetectdividedclk                : VitalDelayType01 := DefpropDelay01;
      tipd_datain                : VitalDelayType01 := DefpropDelay01;
      tipd_rxpmareset                : VitalDelayType01 := DefpropDelay01;
      tipd_plllocked                : VitalDelayType01 := DefpropDelay01;
      tipd_dpriodisable                : VitalDelayType01 := DefpropDelay01;
      tipd_ignorephslck                : VitalDelayType01 := DefpropDelay01;
      tipd_locktoref                : VitalDelayType01 := DefpropDelay01;
      tipd_adcepowerdn                : VitalDelayType01 := DefpropDelay01;
      tipd_ppmdetectrefclk                : VitalDelayType01 := DefpropDelay01;
      tipd_adcestandby                : VitalDelayType01 := DefpropDelay01;
      tipd_powerdn                : VitalDelayType01 := DefpropDelay01;
      tipd_seriallpbken                : VitalDelayType01 := DefpropDelay01;
      tipd_adcereset                : VitalDelayType01 := DefpropDelay01;
      tipd_deserclock               :VitalDelayArrayType01(4 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_locktodata                : VitalDelayType01 := DefpropDelay01;
      tipd_freqlock                : VitalDelayType01 := DefpropDelay01;
      tipd_offsetcancellationen                : VitalDelayType01 := DefpropDelay01;
      tipd_testbussel               :VitalDelayArrayType01(4 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_recoverdatain               :VitalDelayArrayType01(2 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_seriallpbkin                : VitalDelayType01 := DefpropDelay01;
      tipd_dprioin               :VitalDelayArrayType01(300 - 1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_adaptcapture                : VitalDelayType01 := DefpropDelay01;
      lpm_type                                  : STRING := "arriaii_hssi_rx_pma";
      adaptive_equalization_mode                : STRING := "none";
      allow_serial_loopback                     : STRING := "false";
      allow_vco_bypass                          : INTEGER := 0;
      analog_power                              : STRING := "1.4V";
      channel_number                            : INTEGER := 0;
      channel_type                              : STRING := "auto";
      common_mode                               : STRING := "0.82V";
      deserialization_factor                    : INTEGER := 8;
      dfe_piclk_bandwidth                       : INTEGER := 0;
      dfe_piclk_phase                           : INTEGER := 0;
      dfe_piclk_sel                             : INTEGER := 0;
      dprio_config_mode                         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      enable_ltd                                : STRING := "false";
      enable_ltr                                : STRING := "false";
      eq_adapt_seq_control                      : INTEGER := 0;
      eq_dc_gain                                : INTEGER := 0;
      eq_max_gradient_control                   : INTEGER := 0;
      eqa_ctrl                                  : INTEGER := 0;
      eqb_ctrl                                  : INTEGER := 0;
      eqc_ctrl                                  : INTEGER := 0;
      eqd_ctrl                                  : INTEGER := 0;
      eqv_ctrl                                  : INTEGER := 0;
      eyemon_bandwidth                          : INTEGER := 0;
      force_signal_detect                       : STRING := "true";
      ignore_lock_detect                        : STRING := "false";
      logical_channel_address                   : INTEGER := 0;
      low_speed_test_select                     : INTEGER := 0;
      offset_cancellation                       : INTEGER := 0;
      ppm_gen1_2_xcnt_en                        : INTEGER := 1;
      ppm_post_eidle                            : INTEGER := 0;
      ppmselect                                 : INTEGER := 0;
      protocol_hint                             : STRING := "basic";
      send_direct_reverse_serial_loopback       : STRING := "None";
      signal_detect_hysteresis                  : INTEGER := 4;
      signal_detect_hysteresis_valid_threshold  : INTEGER := 2;
      signal_detect_loss_threshold              : INTEGER := 3;
      termination                               : STRING := "OCT 100 Ohms";
      use_deser_double_data_width               : STRING := "false";
      use_external_termination                  : STRING := "false";
      use_pma_direct                            : STRING := "false";
      PARAM_DELAY                               : INTEGER := 0
   );
   PORT (
      adaptcapture                              : IN STD_LOGIC := '0';
      adcepowerdn                               : IN STD_LOGIC := '0';
      adcereset                                 : IN STD_LOGIC := '0';
      adcestandby                               : IN STD_LOGIC := '0';
      datain                                    : IN STD_LOGIC := '0';
      deserclock                                : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (others => '0');
      dpriodisable                              : IN STD_LOGIC := '1';
      dprioin                                   : IN STD_LOGIC_VECTOR(300 - 1 DOWNTO 0) := (others => '0');
      extra10gin                                : IN STD_LOGIC_VECTOR(38 - 1 DOWNTO 0) := (others => '0');
      freqlock                                  : IN STD_LOGIC := '0';
      ignorephslck                              : IN STD_LOGIC := '0';
      locktodata                                : IN STD_LOGIC := '0';
      locktoref                                 : IN STD_LOGIC := '0';
      offsetcancellationen                      : IN STD_LOGIC := '0';
      plllocked                                 : IN STD_LOGIC := '0';
      powerdn                                   : IN STD_LOGIC := '0';
      ppmdetectdividedclk                       : IN STD_LOGIC := '0';
      ppmdetectrefclk                           : IN STD_LOGIC := '0';
      recoverdatain                             : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      rxpmareset                                : IN STD_LOGIC := '0';
      seriallpbken                              : IN STD_LOGIC := '0';
      seriallpbkin                              : IN STD_LOGIC := '0';
      testbussel                                : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (others => '0');
      adaptdone                                 : OUT STD_LOGIC;
      analogtestbus                             : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      clockout                                  : OUT STD_LOGIC;
      dataout                                   : OUT STD_LOGIC;
      dataoutfull                               : OUT STD_LOGIC_VECTOR(20 - 1 DOWNTO 0);
      dprioout                                  : OUT STD_LOGIC_VECTOR(300 - 1 DOWNTO 0);
      locktorefout                              : OUT STD_LOGIC;
      ppmdetectclkrel                           : OUT STD_LOGIC;
      recoverdataout                            : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      reverselpbkout                            : OUT STD_LOGIC;
      revserialfdbkout                          : OUT STD_LOGIC;
      signaldetect                              : OUT STD_LOGIC
   );
END COMPONENT;

--
-- arriaii_hssi_tx_pcs
--

COMPONENT arriaii_hssi_tx_pcs
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_bitslipboundaryselect               :VitalDelayArrayType01(4 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_coreclk                : VitalDelayType01 := DefpropDelay01;
      tipd_ctrlenable               :VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_datain               :VitalDelayArrayType01(39 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_datainfull               :VitalDelayArrayType01(43 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_detectrxloop                : VitalDelayType01 := DefpropDelay01;
      tipd_digitalreset                : VitalDelayType01 := DefpropDelay01;
      tipd_dispval               :VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_dpriodisable                : VitalDelayType01 := DefpropDelay01;
      tipd_dprioin               :VitalDelayArrayType01(149 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_enrevparallellpbk                : VitalDelayType01 := DefpropDelay01;
      tipd_forcedisp               :VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_forcedispcompliance                : VitalDelayType01 := DefpropDelay01;
      tipd_forceelecidle                : VitalDelayType01 := DefpropDelay01;
      tipd_freezptr                : VitalDelayType01 := DefpropDelay01;
      tipd_hipdatain               :VitalDelayArrayType01(9 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_hipforceelecidle                : VitalDelayType01 := DefpropDelay01;
      tipd_hiptxdeemph                : VitalDelayType01 := DefpropDelay01;
      tipd_hiptxmargin               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_hippowerdn               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_hipdetectrxloop                : VitalDelayType01 := DefpropDelay01;
      tipd_invpol                : VitalDelayType01 := DefpropDelay01;
      tipd_iqpphfifoxnwrenable               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_iqpphfifoxnrdenable               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_iqpphfifoxnbytesel               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_iqpphfifoxnrdclk               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_localrefclk                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifobyteserdisable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnbytesel               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifoxnbottomwrenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxntopwrenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoptrsreset                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnptrsreset               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifoxnrdenable               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfiforddisable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxntopbytesel                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxntoprdclk                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox4bytesel                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox4rdclk                : VitalDelayType01 := DefpropDelay01;
      tipd_phfiforeset                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox4rdenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifowrenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnbottombytesel                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxntoprdenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnrdclk               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifox4wrenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnbottomrdenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnbottomrdclk                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnwrenable               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_pipestatetransdone                : VitalDelayType01 := DefpropDelay01;
      tipd_pipetxswing                : VitalDelayType01 := DefpropDelay01;
      tipd_pipetxmargin               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_pipetxdeemph                : VitalDelayType01 := DefpropDelay01;
      tipd_powerdn               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_prbscidenable                : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitch                : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitchisdone                : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitchxndone                : VitalDelayType01 := DefpropDelay01;
      tipd_refclk                : VitalDelayType01 := DefpropDelay01;
      tipd_revparallelfdbk               :VitalDelayArrayType01(19 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_quadreset                : VitalDelayType01 := DefpropDelay01;
      tipd_xgmctrl                : VitalDelayType01 := DefpropDelay01;
      tipd_xgmdatain               :VitalDelayArrayType01(7 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tsetup_ctrlenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_datain_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_detectrxloop_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_dispval_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_forcedisp_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_forcedispcompliance_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_phfifowrenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_forceelecidle_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_powerdn_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_pipetxdeemph_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_pipetxswing_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_pipetxmargin_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ctrlenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_datain_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_detectrxloop_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_dispval_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_forcedisp_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_forcedispcompliance_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_phfifowrenable_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_forceelecidle_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_powerdn_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_pipetxdeemph_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_pipetxswing_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_pipetxmargin_coreclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpd_coreclk_phfifooverflow_posedge : VitalDelayType01 := DefPropDelay01;
      tpd_coreclk_phfifounderflow_posedge : VitalDelayType01 := DefPropDelay01;
      lpm_type                                 : STRING := "arriaii_hssi_tx_pcs";
      allow_polarity_inversion                 : STRING := "false";
      auto_spd_self_switch_enable              : STRING := "false";
      bitslip_enable                           : STRING := "false";
      channel_bonding                          : STRING := "none";	-- none, x8, x4
      channel_number                           : INTEGER := 0;
      channel_width                            : INTEGER := 8;
      core_clock_0ppm                          : STRING := "false";
      datapath_low_latency_mode                : STRING := "false";	--NEW_PARAM, RTL=
      datapath_protocol                        : STRING := "basic";	--replaced by protocol_hint
      disable_ph_low_latency_mode              : STRING := "false";
      disparity_mode                           : STRING := "none";	-- legacy, new, none
      dprio_config_mode                        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      elec_idle_delay                          : INTEGER := 6;		-- new in 6.0 <3-6>
      enable_bit_reversal                      : STRING := "false";
      enable_idle_selection                    : STRING := "false";
      enable_phfifo_bypass                     : STRING := "false";
      enable_reverse_parallel_loopback         : STRING := "false";
      enable_self_test_mode                    : STRING := "false";
      enable_symbol_swap                       : STRING := "false";
      enc_8b_10b_compatibility_mode            : STRING := "true";
      enc_8b_10b_mode                          : STRING := "none";	-- cascade, normal, none
      force_echar                              : STRING := "false";
      force_kchar                              : STRING := "false";
      hip_enable                               : STRING := "false";
      iqp_bypass                               : STRING := "false";
      iqp_ph_fifo_xn_select                    : INTEGER := 9999;
      logical_channel_address                  : INTEGER := 0;		
      migrated_from_prev_family                : STRING := "false";
      ph_fifo_reg_mode                         : STRING := "false";
      ph_fifo_reset_enable                     : STRING := "false";
      ph_fifo_user_ctrl_enable                 : STRING := "false";
      ph_fifo_xn_mapping0                      : STRING := "none";
      ph_fifo_xn_mapping1                      : STRING := "none";
      ph_fifo_xn_mapping2                      : STRING := "none";
      ph_fifo_xn_select                        : INTEGER := 9999;
      pipe_auto_speed_nego_enable              : STRING := "false";	
      pipe_freq_scale_mode                     : STRING := "Data width";		
      pipe_voltage_swing_control               : STRING := "false";	--NEW_PARAM, RTL=
      prbs_all_one_detect                      : STRING := "false";
      prbs_cid_pattern                         : STRING := "false";
      prbs_cid_pattern_length                  : INTEGER := 0;
      protocol_hint                            : STRING := "basic";
      refclk_select                            : STRING := "local";	-- cmu_clk_divider
      reset_clock_output_during_digital_reset  : STRING := "false";
      self_test_mode                           : STRING := "incremental";
      use_double_data_mode                     : STRING := "false";
      use_serializer_double_data_mode          : STRING := "false";
      wr_clk_mux_select                        : STRING := "core_clk";	-- INT_CLK                  // int_clk
      use_top_quad_as_mater                    : STRING := "true";	-- NEW_PARAM todo: select top/bottom to provide phfifo pointers
      dprio_width                              : INTEGER := 150
   );
   PORT (
      bitslipboundaryselect                    : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');		
      coreclk                                  : IN STD_LOGIC := '0';
      ctrlenable                               : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      datain                                   : IN STD_LOGIC_VECTOR(39 DOWNTO 0) := (others => '0');
      datainfull                               : IN STD_LOGIC_VECTOR(43 DOWNTO 0) := (others => '0');		-- WYS_TO_CHANGE
      detectrxloop                             : IN STD_LOGIC := '0';
      digitalreset                             : IN STD_LOGIC := '0';
      dispval                                  : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      dpriodisable                             : IN STD_LOGIC := '1';
      dprioin                                  : IN STD_LOGIC_VECTOR(149 DOWNTO 0) := (others => '0');
      elecidleinfersel                         : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');   
      enrevparallellpbk                        : IN STD_LOGIC := '0';
      forcedisp                                : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');		--fix_width
      forcedispcompliance                      : IN STD_LOGIC := '0';
      forceelecidle                            : IN STD_LOGIC := '0';		
      freezptr                                 : IN STD_LOGIC := '0';
      hipdatain                                : IN STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');		
      hipdetectrxloop                          : IN STD_LOGIC := '0';		
      hipelecidleinfersel                      : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		
      hipforceelecidle                         : IN STD_LOGIC := '0';		
      hippowerdn                               : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		
      hiptxdeemph                              : IN STD_LOGIC := '0';		
      hiptxmargin                              : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		
      invpol                                   : IN STD_LOGIC := '0';
      iqpphfifoxnbytesel                       : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		
      iqpphfifoxnrdclk                         : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		
      iqpphfifoxnrdenable                      : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		
      iqpphfifoxnwrenable                      : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		
      localrefclk                              : IN STD_LOGIC := '0';		
      phfifobyteserdisable                     : IN STD_LOGIC := '0';		
      phfifoptrsreset                          : IN STD_LOGIC := '0';		
      phfiforddisable                          : IN STD_LOGIC := '0';
      phfiforeset                              : IN STD_LOGIC := '0';
      phfifowrenable                           : IN STD_LOGIC := '1';
      phfifox4bytesel                          : IN STD_LOGIC := '0';
      phfifox4rdclk                            : IN STD_LOGIC := '0';
      phfifox4rdenable                         : IN STD_LOGIC := '0';
      phfifox4wrenable                         : IN STD_LOGIC := '0';
      phfifoxnbottombytesel                    : IN STD_LOGIC := '0';		
      phfifoxnbottomrdclk                      : IN STD_LOGIC := '0';		
      phfifoxnbottomrdenable                   : IN STD_LOGIC := '0';		
      phfifoxnbottomwrenable                   : IN STD_LOGIC := '0';		
      phfifoxnbytesel                          : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');	
      phfifoxnptrsreset                        : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');	
      phfifoxnrdclk                            : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');	
      phfifoxnrdenable                         : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');	
      phfifoxntopbytesel                       : IN STD_LOGIC := '0';		
      phfifoxntoprdclk                         : IN STD_LOGIC := '0';		
      phfifoxntoprdenable                      : IN STD_LOGIC := '0';		
      phfifoxntopwrenable                      : IN STD_LOGIC := '0';		
      phfifoxnwrenable                         : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');	
      pipestatetransdone                       : IN STD_LOGIC := '0';
      pipetxdeemph                             : IN STD_LOGIC := '0';		--NEW;  RTL=txdeemph;
      pipetxmargin                             : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		--NEW;  RTL=txmargin[2:0]
      pipetxswing                              : IN STD_LOGIC := '0';		--NEW;  RTL=txswing
      powerdn                                  : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
      prbscidenable                            : IN STD_LOGIC := '0';		
      quadreset                                : IN STD_LOGIC := '0';
      rateswitch                               : IN STD_LOGIC := '0';		--NEW,  RTL=rate
      rateswitchisdone                         : IN STD_LOGIC := '0';		
      rateswitchxndone                         : IN STD_LOGIC := '0';		
      refclk                                   : IN STD_LOGIC := '0';
      revparallelfdbk                          : IN STD_LOGIC_VECTOR(19 DOWNTO 0) := (others => '0');
      xgmctrl                                  : IN STD_LOGIC := '0';
      xgmdatain                                : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
      clkout                                   : OUT STD_LOGIC;
      coreclkout                               : OUT STD_LOGIC;		
      dataout                                  : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
      dprioout                                 : OUT STD_LOGIC_VECTOR(149 DOWNTO 0);
      forceelecidleout                         : OUT STD_LOGIC;
      grayelecidleinferselout                  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);  
      hiptxclkout                              : OUT STD_LOGIC;		
      iqpphfifobyteselout                      : OUT STD_LOGIC;		
      iqpphfifordclkout                        : OUT STD_LOGIC;		
      iqpphfifordenableout                     : OUT STD_LOGIC;		
      iqpphfifowrenableout                     : OUT STD_LOGIC;		
      parallelfdbkout                          : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
      phfifobyteselout                         : OUT STD_LOGIC;
      phfifooverflow                           : OUT STD_LOGIC;
      phfifordclkout                           : OUT STD_LOGIC;
      phfiforddisableout                       : OUT STD_LOGIC;		
      phfifordenableout                        : OUT STD_LOGIC;
      phfiforesetout                           : OUT STD_LOGIC;		
      phfifounderflow                          : OUT STD_LOGIC;
      phfifowrenableout                        : OUT STD_LOGIC;
      pipeenrevparallellpbkout                 : OUT STD_LOGIC;     
      pipepowerdownout                         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      pipepowerstateout                        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rateswitchout                            : OUT STD_LOGIC;
      rdenablesync                             : OUT STD_LOGIC;
      txdetectrx                               : OUT STD_LOGIC;		
      xgmctrlenable                            : OUT STD_LOGIC;
      xgmdataout                               : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END COMPONENT;

--
-- arriaii_hssi_rx_pcs
--

COMPONENT arriaii_hssi_rx_pcs
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_phfifox8bytesel                : VitalDelayType01 := DefpropDelay01;
      tipd_xgmctrlin                : VitalDelayType01 := DefpropDelay01;
      tipd_pipepowerdown               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_parallelfdbk               :VitalDelayArrayType01(19 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_masterclk                : VitalDelayType01 := DefpropDelay01;
      tipd_iqpphfifoxnwrclk               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxelecidlerateswitch                : VitalDelayType01 := DefpropDelay01;
      tipd_pipepowerstate               :VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_alignstatussync                : VitalDelayType01 := DefpropDelay01;
      tipd_powerdn               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_refclk                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox4bytesel                : VitalDelayType01 := DefpropDelay01;
      tipd_bitslip                : VitalDelayType01 := DefpropDelay01;
      tipd_phfiforeset                : VitalDelayType01 := DefpropDelay01;
      tipd_dprioin               :VitalDelayArrayType01(399 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_disablefifowrin                : VitalDelayType01 := DefpropDelay01;
      tipd_ppmdetectdividedclk                : VitalDelayType01 := DefpropDelay01;
      tipd_datain               :VitalDelayArrayType01(19 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_enabledeskew                : VitalDelayType01 := DefpropDelay01;
      tipd_hippowerdown               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_revbyteorderwa                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox4wrenable                : VitalDelayType01 := DefpropDelay01;
      tipd_dpriodisable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox8wrclk                : VitalDelayType01 := DefpropDelay01;
      tipd_enabyteord                : VitalDelayType01 := DefpropDelay01;
      tipd_invpol                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox8rdenable                : VitalDelayType01 := DefpropDelay01;
      tipd_revbitorderwa                : VitalDelayType01 := DefpropDelay01;
      tipd_localrefclk                : VitalDelayType01 := DefpropDelay01;
      tipd_enapatternalign                : VitalDelayType01 := DefpropDelay01;
      tipd_iqpphfifoxnrdenable               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_iqpphfifoxnptrsreset               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifowrdisable                : VitalDelayType01 := DefpropDelay01;
      tipd_signaldetected                : VitalDelayType01 := DefpropDelay01;
      tipd_alignstatus                : VitalDelayType01 := DefpropDelay01;
      tipd_rxdetectvalid                : VitalDelayType01 := DefpropDelay01;
      tipd_quadreset                : VitalDelayType01 := DefpropDelay01;
      tipd_autospdxnconfigsel               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_recoveredclk                : VitalDelayType01 := DefpropDelay01;
      tipd_hiprateswitch                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifordenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox4wrclk                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnbytesel               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rmfifowrena                : VitalDelayType01 := DefpropDelay01;
      tipd_a1a2size                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifox8wrenable                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnptrsreset               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_iqpphfifoxnwrenable               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifoxnrdenable               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rateswitchisdone                : VitalDelayType01 := DefpropDelay01;
      tipd_elecidleinfersel               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_hip8b10binvpolarity                : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitchxndone                : VitalDelayType01 := DefpropDelay01;
      tipd_iqpautospdxnspgchg               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rmfiforeset                : VitalDelayType01 := DefpropDelay01;
      tipd_coreclk                : VitalDelayType01 := DefpropDelay01;
      tipd_rmfifordena                : VitalDelayType01 := DefpropDelay01;
      tipd_disablefifordin                : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitch                : VitalDelayType01 := DefpropDelay01;
      tipd_hipelecidleinfersel               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifox4rdenable                : VitalDelayType01 := DefpropDelay01;
      tipd_pipe8b10binvpolarity                : VitalDelayType01 := DefpropDelay01;
      tipd_fifordin                : VitalDelayType01 := DefpropDelay01;
      tipd_ppmdetectrefclk                : VitalDelayType01 := DefpropDelay01;
      tipd_prbscidenable                : VitalDelayType01 := DefpropDelay01;
      tipd_digitalreset                : VitalDelayType01 := DefpropDelay01;
      tipd_rxfound               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_cdrctrllocktorefcl                : VitalDelayType01 := DefpropDelay01;
      tipd_phfifoxnwrclk               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_iqpphfifoxnbytesel               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_autospdxnspdchg               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_phfifoxnwrenable               :VitalDelayArrayType01(2 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_fiforesetrd                : VitalDelayType01 := DefpropDelay01;
      tipd_xgmdatain               :VitalDelayArrayType01(7 DOWNTO 0)   := (OTHERS => DefPropDelay01);
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
        tpd_coreclk_pipedatavalid_posedge: VitalDelayType01 := DefPropDelay01;
      lpm_type                                    : STRING := "arriaii_hssi_rx_pcs";
      align_ordered_set_based                     : STRING := "false";           
      align_pattern                               : STRING := "0101111100";	--  word align: size of align_pattern_length; 
      align_pattern_length                        : INTEGER := 10;			-- <7, 8, 10, 16, 20, 32, 40>; 
      align_to_deskew_pattern_pos_disp_only       : STRING := "false";		-- <true/false>;
      allow_align_polarity_inversion              : STRING := "false"; 
      allow_pipe_polarity_inversion               : STRING := "false";
      auto_spd_deassert_ph_fifo_rst_count         : INTEGER := 0;		
      auto_spd_phystatus_notify_count             : INTEGER := 0;		
      auto_spd_self_switch_enable                 : STRING := "false";		
      bit_slip_enable                             : STRING := "false";
      byte_order_back_compat_enable               : STRING := "false";		
      byte_order_double_data_mode_mask_enable     : STRING := "false";		
      byte_order_invalid_code_or_run_disp_error   : STRING := "false";		
      byte_order_mode                             : STRING := "none";		--NEW_PARAM_replace byte_ordering_mode
      byte_order_pad_pattern                      : STRING := "0101111100";	-- <10-bit binary string>;            
      byte_order_pattern                          : STRING := "0101111100";	-- <10-bit binary string>;
      byte_order_pld_ctrl_enable                  : STRING := "false";		--ww47_cram added in build 165
      cdrctrl_bypass_ppm_detector_cycle           : INTEGER := 0;		
      cdrctrl_cid_mode_enable                     : STRING := "false";		
      cdrctrl_enable                              : STRING := "false";		
      cdrctrl_mask_cycle                          : INTEGER := 0;		
      cdrctrl_min_lock_to_ref_cycle               : INTEGER := 0;		
      cdrctrl_rxvalid_mask                        : STRING := "false";		
      channel_bonding                             : STRING := "none";		-- <none, x4, x8>;
      channel_number                              : INTEGER := 0;			-- <integer 0-3>;
      channel_width                               : INTEGER := 10;			-- <integer 8,10,16,20,32,40>;
      clk1_mux_select                             : STRING := "recvd_clk";	-- <RECVD_CLK, MASTER_CLK, LOCAL_REFCLK, DIGITAL_REFCLK>;      
      clk2_mux_select                             : STRING := "recvd_clk";	-- <RECVD_CLK, LOCAL_REFCLK, DIGITAL_REFCLK, CORE_CLK>;
      clk_pd_enable                               : STRING := "false";		--ww47_cram_p1
      core_clock_0ppm                             : STRING := "false";		
      datapath_low_latency_mode                   : STRING := "false";		
      datapath_protocol                           : STRING := "basic";		-- <basic/pipe/xaui> replaced by protocol_hint
      dec_8b_10b_compatibility_mode               : STRING := "true";
      dec_8b_10b_mode                             : STRING := "none";		-- <normal/cascaded/none>;
      dec_8b_10b_polarity_inv_enable              : STRING := "false";		
      deskew_pattern                              : STRING := "1100111100";	-- K28.3
      disable_auto_idle_insertion                 : STRING := "false";  
      disable_running_disp_in_word_align          : STRING := "false"; 
      disallow_kchar_after_pattern_ordered_set    : STRING := "false";
      dprio_config_mode                           : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      elec_idle_eios_detect_priority_over_eidle_disable : STRING := "false";
      elec_idle_gen1_sigdet_enable                : STRING := "false";		
      elec_idle_infer_enable                      : STRING := "false";		
      elec_idle_k_detect                          : STRING := "false";		
      elec_idle_num_com_detect                    : INTEGER := 0;		
      enable_bit_reversal                         : STRING := "false";
      enable_deep_align                           : STRING := "false";                          
      enable_deep_align_byte_swap                 : STRING := "false";
      enable_self_test_mode                       : STRING := "false";
      enable_true_complement_match_in_word_align  : STRING := "true"; 
      error_from_wa_or_8b_10b_select               : STRING := "false"; 
      force_signal_detect_dig                     : STRING := "false";
      hip_enable                                  : STRING := "false";		
      infiniband_invalid_code                     : INTEGER := 0;			-- <integer 0-3>;
      insert_pad_on_underflow                     : STRING := "false";
      iqp_bypass                                  : STRING := "false";		
      iqp_ph_fifo_xn_select                       : INTEGER := 9999;		
      logical_channel_address                     : INTEGER := 0;		
      migrated_from_prev_family                   : STRING := "false";		-- b165
      num_align_code_groups_in_ordered_set        : INTEGER := 1;			-- <integer 0-3>;   
      num_align_cons_good_data                    : INTEGER := 3;			-- wordalign<Integer 1-256>;
      num_align_cons_pat                          : INTEGER := 4;			-- <Integer 1-256>;
      num_align_loss_sync_error                   : INTEGER := 1;			--NEW_PARAM_replace align_loss_sync_error_num
      ph_fifo_disable                             : STRING := "false";		
      ph_fifo_low_latency_enable                  : STRING := "false";		
      ph_fifo_reg_mode                            : STRING := "false";		
      ph_fifo_reset_enable                        : STRING := "false";		
      ph_fifo_user_ctrl_enable                    : STRING := "false";		
      ph_fifo_xn_mapping0                         : STRING := "none";		--ww47_cram_p1
      ph_fifo_xn_mapping1                         : STRING := "none";		--ww47_cram_p1
      ph_fifo_xn_mapping2                         : STRING := "none";		--ww47_cram_p1
      ph_fifo_xn_select                           : INTEGER := 9999;		
      phystatus_delay                             : INTEGER := 0;		
      phystatus_reset_toggle                      : STRING := "false";
      pipe_auto_speed_nego_enable                 : STRING := "false";		
      pipe_freq_scale_mode                        : STRING := "Data width";	
      pipe_hip_enable                             : STRING := "false";		--NEW_PARAM  todo: remove
      pma_done_count                              : INTEGER := 53392;		--ww47_cram_p1
      prbs_all_one_detect                         : STRING := "false";
      prbs_cid_pattern                            : STRING := "false";		
      prbs_cid_pattern_length                     : INTEGER := 0;		
      protocol_hint                               : STRING := "basic";
      rate_match_almost_empty_threshold           : INTEGER := 11;			-- <integer 0-15>;           
      rate_match_almost_full_threshold            : INTEGER := 13;			-- <integer 0-15>;           
      rate_match_back_to_back                     : STRING := "false";           
      rate_match_delete_threshold                 : INTEGER := 13;		
      rate_match_empty_threshold                  : INTEGER := 5;		
      rate_match_fifo_mode                        : STRING := "false";		-- <normal/cascaded/generic/cascaded_generic/none> in s2gx, bool in s4gx;
      rate_match_full_threshold                   : INTEGER := 20;		
      rate_match_insert_threshold                 : INTEGER := 11;		
      rate_match_ordered_set_based                : STRING := "false";		-- <integer 10 or 20>;
      rate_match_pattern1                         : STRING := "00000000000010111100";		-- <20-bit binary string>;           
      rate_match_pattern2                         : STRING := "00000000000010111100";		-- <20-bit binary string>;           
      rate_match_pattern_size                     : INTEGER := 10;			-- <integer 10 or 20>;
      rate_match_pipe_enable                      : STRING := "false";  	
      rate_match_reset_enable                     : STRING := "true";		--NEW_PARAM - default diff from atom
      rate_match_skip_set_based                   : STRING := "false";
      rate_match_start_threshold                  : INTEGER := 7;			
      rd_clk_mux_select                           : STRING := "int_clk";	-- <INT_CLK, CORE_CLK>;
      recovered_clk_mux_select                    : STRING := "recvd_clk";	-- <RECVD_CLK, LOCAL_REFCLK, DIGITAL_REFCLK>; 
      reset_clock_output_during_digital_reset     : STRING := "false";	
      run_length                                  : INTEGER := 200;			-- <5-320 or 4-254 depending on the deserialization factor>; 
      run_length_enable                           : STRING := "false";	 
      rx_detect_bypass                            : STRING := "false";
      rx_phfifo_wait_cnt                          : INTEGER := 32;		
      rxstatus_error_report_mode                  : INTEGER := 0;		
      self_test_mode                              : STRING := "incremental"; -- <PRBS_7,PRBS_8,PRBS_10,PRBS_23,low_freq,mixed_freq,high_freq,incremental,cjpat,crpat>;
      test_bus_sel                                : INTEGER := 0;		
      use_alignment_state_machine                 : STRING := "false";	
      use_deserializer_double_data_mode           : STRING := "false";	
      use_deskew_fifo                             : STRING := "false";	                                                 
      use_double_data_mode                        : STRING := "false";	 
      use_parallel_loopback                       : STRING := "false";	
      use_rising_edge_triggered_pattern_align     : STRING := "false";		-- <true/false>;    //83 para: new=23 rem=40
      enable_phfifo_bypass                        : STRING := "false"
   );
   PORT (
      a1a2size                                    : IN STD_LOGIC := '0';
      alignstatus                                 : IN STD_LOGIC := '0';
      alignstatussync                             : IN STD_LOGIC := '0';
      autospdxnconfigsel                          : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- config_sel_centrl, quad_up, quad_down
      autospdxnspdchg                             : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- From CMU.spped-change_centrl, rx3(up), rx0(down)
      bitslip                                     : IN STD_LOGIC := '0';
      cdrctrllocktorefcl                          : IN STD_LOGIC := '0';		-- pld_ltr
      coreclk                                     : IN STD_LOGIC := '0';
      datain                                      : IN STD_LOGIC_VECTOR(19 DOWNTO 0) := (others => '0');		--NEW: updated width
      digitalreset                                : IN STD_LOGIC := '0';
      disablefifordin                             : IN STD_LOGIC := '0';
      disablefifowrin                             : IN STD_LOGIC := '0';
      dpriodisable                                : IN STD_LOGIC := '1';
      dprioin                                     : IN STD_LOGIC_VECTOR(399 DOWNTO 0) := (others => '0');
      elecidleinfersel                            : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
      enabledeskew                                : IN STD_LOGIC := '0';
      enabyteord                                  : IN STD_LOGIC := '0';
      enapatternalign                             : IN STD_LOGIC := '0';
      fifordin                                    : IN STD_LOGIC := '0';
      fiforesetrd                                 : IN STD_LOGIC := '0';
      grayelecidleinferselfromtx                  : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0'); 
      hip8b10binvpolarity                         : IN STD_LOGIC := '0';		-- hip_rxpolarity
      hipelecidleinfersel                         : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- hip_eidleinfersel_ch
      hippowerdown                                : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- hip_powerdown_ch
      hiprateswitch                               : IN STD_LOGIC := '0';		-- hip_rate
      invpol                                      : IN STD_LOGIC := '0';
      iqpautospdxnspgchg                          : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- speed_change_in_pipe_quad_up, down
      iqpphfifoxnbytesel                          : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- wr_enable_ptrs_in_pipe_quad_up, down
      iqpphfifoxnptrsreset                        : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- reset_pc_ptrs_in_pipe_quad_up, down
      iqpphfifoxnrdenable                         : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- rd_enable_ptrs_in_pipe_quad_up, down
      iqpphfifoxnwrclk                            : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- rx_div2_sync_in_pipe_quad_up, down
      iqpphfifoxnwrenable                         : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');		-- wr_enable_ptrs_in_pipe_quad_up, down
      localrefclk                                 : IN STD_LOGIC := '0';
      masterclk                                   : IN STD_LOGIC := '0';
      parallelfdbk                                : IN STD_LOGIC_VECTOR(19 DOWNTO 0) := (others => '0');
      phfifordenable                              : IN STD_LOGIC := '1';
      phfiforeset                                 : IN STD_LOGIC := '0';
      phfifowrdisable                             : IN STD_LOGIC := '0';
      phfifox4bytesel                             : IN STD_LOGIC := '0';
      phfifox4rdenable                            : IN STD_LOGIC := '0';
      phfifox4wrclk                               : IN STD_LOGIC := '0';
      phfifox4wrenable                            : IN STD_LOGIC := '0';
      phfifox8bytesel                             : IN STD_LOGIC := '0';
      phfifox8rdenable                            : IN STD_LOGIC := '0';
      phfifox8wrclk                               : IN STD_LOGIC := '0';
      phfifox8wrenable                            : IN STD_LOGIC := '0';
      phfifoxnbytesel                             : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- rx_we_in_centrl, quad_up, quad_down
      phfifoxnptrsreset                           : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- ph fifo. From CMU to both RX & TX.
      phfifoxnrdenable                            : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- rd_enable_in_centrl, quad_up, quad_down
      phfifoxnwrclk                               : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- ph fifo. From CMU to RX.
      phfifoxnwrenable                            : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');		-- wr_enable_in_centrl, quad_up, quad_down
      pipe8b10binvpolarity                        : IN STD_LOGIC := '0';
      pipeenrevparallellpbkfromtx                 : IN STD_LOGIC := '0';  
      pipepowerdown                               : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
      pipepowerstate                              : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      pmatestbusin                                : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
      powerdn                                     : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
      ppmdetectdividedclk                         : IN STD_LOGIC := '0';
      ppmdetectrefclk                             : IN STD_LOGIC := '0';
      prbscidenable                               : IN STD_LOGIC := '0';		-- prbs_cid_en
      quadreset                                   : IN STD_LOGIC := '0';
      rateswitch                                  : IN STD_LOGIC := '0';
      rateswitchisdone                            : IN STD_LOGIC := '0';
      rateswitchxndone                            : IN STD_LOGIC := '0';
      recoveredclk                                : IN STD_LOGIC := '0';
      refclk                                      : IN STD_LOGIC := '0';
      revbitorderwa                               : IN STD_LOGIC := '0';
      revbyteorderwa                              : IN STD_LOGIC := '0';
      rmfifordena                                 : IN STD_LOGIC := '0';
      rmfiforeset                                 : IN STD_LOGIC := '0';
      rmfifowrena                                 : IN STD_LOGIC := '0';
      rxdetectvalid                               : IN STD_LOGIC := '0';
      rxelecidlerateswitch                        : IN STD_LOGIC := '0';	
      rxfound                                     : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
      signaldetected                              : IN STD_LOGIC := '0';	
      wareset                                     : IN STD_LOGIC := '0';	-- new in 9.1
      xauidelcondmet                              : IN STD_LOGIC := '0';  
      xauififoovr                                 : IN STD_LOGIC := '0';  
      xauiinsertincomplete                        : IN STD_LOGIC := '0';  
      xauilatencycomp                             : IN STD_LOGIC := '0';  
      xgmctrlin                                   : IN STD_LOGIC := '0';
      xgmdatain                                   : IN STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');		--54 ins ---
      a1a2sizeout                                 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      a1detect                                    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      a2detect                                    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      adetectdeskew                               : OUT STD_LOGIC;
      alignstatussyncout                          : OUT STD_LOGIC;
      autospdrateswitchout                        : OUT STD_LOGIC;
      autospdspdchgout                            : OUT STD_LOGIC;		--ww47_out speed_chang_out_pipe
      bistdone                                    : OUT STD_LOGIC;
      bisterr                                     : OUT STD_LOGIC;
      bitslipboundaryselectout                    : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		--ww47_out wa_boundary
      byteorderalignstatus                        : OUT STD_LOGIC;
      cdrctrlearlyeios                            : OUT STD_LOGIC;		--ww47_out Asserted when K_I or K_X_I is detected on the incoming data. To PMA and/or PLD?
      cdrctrllocktorefclkout                      : OUT STD_LOGIC;		--ww47_out Force CDR(RX PLL) to LTR.
      clkout                                      : OUT STD_LOGIC;
      coreclkout                                  : OUT STD_LOGIC;		--ww47_out Sim Only. From RX Ch0 to CMU
      ctrldetect                                  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      dataout                                     : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
      dataoutfull                                 : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);		-- new in 6.1
      digitaltestout                              : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);	      
      disablefifordout                            : OUT STD_LOGIC;
      disablefifowrout                            : OUT STD_LOGIC;
      disperr                                     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      dprioout                                    : OUT STD_LOGIC_VECTOR(399 DOWNTO 0);
      errdetect                                   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      fifordout                                   : OUT STD_LOGIC;
      hipdataout                                  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);		--ww47_out hip_rxd_ch(8:0)
      hipdatavalid                                : OUT STD_LOGIC;		--ww47_out hip_rxvalid
      hipelecidle                                 : OUT STD_LOGIC;		--ww47_out hip_rxelecidle
      hipphydonestatus                            : OUT STD_LOGIC;		--ww47_out hip_phystatus
      hipstatus                                   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);		--ww47_out hip_rxstatus_ch(2:0)
      iqpphfifobyteselout                         : OUT STD_LOGIC;		--ww47_out rx_we_out_pipe
      iqpphfifoptrsresetout                       : OUT STD_LOGIC;		--ww47_out reset_pc_pters_out_pipe
      iqpphfifordenableout                        : OUT STD_LOGIC;		--ww47_out rd_enable_pipe_out
      iqpphfifowrclkout                           : OUT STD_LOGIC;		--ww47_out rx_div2_sync_out_pipe
      iqpphfifowrenableout                        : OUT STD_LOGIC;		--ww47_out wr_enable_out_pipe
      k1detect                                    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      k2detect                                    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      patterndetect                               : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      phfifobyteselout                            : OUT STD_LOGIC;
      phfifobyteserdisableout                     : OUT STD_LOGIC;		--ww47_out From Auto Speed Neg to TX
      phfifooverflow                              : OUT STD_LOGIC;
      phfifoptrsresetout                          : OUT STD_LOGIC;		--ww47_out From Auto Speed Neg to TX
      phfifordenableout                           : OUT STD_LOGIC;
      phfiforesetout                              : OUT STD_LOGIC;		--ww47_out Sim Only. From RX Ch0 to CMU
      phfifounderflow                             : OUT STD_LOGIC;
      phfifowrclkout                              : OUT STD_LOGIC;
      phfifowrdisableout                          : OUT STD_LOGIC;		--ww47_out Sim Only. From RX Ch0 to CMU
      phfifowrenableout                           : OUT STD_LOGIC;
      pipebufferstat                              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      pipedatavalid                               : OUT STD_LOGIC;
      pipeelecidle                                : OUT STD_LOGIC;
      pipephydonestatus                           : OUT STD_LOGIC;
      pipestatus                                  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      pipestatetransdoneout                       : OUT STD_LOGIC;
      rateswitchout                               : OUT STD_LOGIC;
      rdalign                                     : OUT STD_LOGIC;
      revparallelfdbkdata                         : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
      rlv                                         : OUT STD_LOGIC;
      rmfifoalmostempty                           : OUT STD_LOGIC;
      rmfifoalmostfull                            : OUT STD_LOGIC;
      rmfifodatadeleted                           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rmfifodatainserted                          : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rmfifoempty                                 : OUT STD_LOGIC;
      rmfifofull                                  : OUT STD_LOGIC;
      runningdisp                                 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      signaldetect                                : OUT STD_LOGIC;
      syncstatus                                  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      syncstatusdeskew                            : OUT STD_LOGIC; 
      xauidelcondmetout                           : OUT STD_LOGIC; 
      xauififoovrout                              : OUT STD_LOGIC; 
      xauiinsertincompleteout                     : OUT STD_LOGIC; 
      xauilatencycompout                          : OUT STD_LOGIC; 
      xgmctrldet                                  : OUT STD_LOGIC;
      xgmdataout                                  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      xgmdatavalid                                : OUT STD_LOGIC;
      xgmrunningdisp                              : OUT STD_LOGIC	
    );
END COMPONENT;

--
-- arriaii_hssi_cmu
--

COMPONENT arriaii_hssi_cmu
   GENERIC (
       MsgOn                       : Boolean := DefGlitchMsgOn;
       XOn                         : Boolean := DefGlitchXOn;
       MsgOnChecks                 : Boolean := DefMsgOnChecks;
       XOnChecks                   : Boolean := DefXOnChecks;
       InstancePath                : String := "*";
       TimingChecksOn              : Boolean := True;
      tipd_txphfiforddisable       : VitalDelayType01 := DefpropDelay01;
      tipd_txctrl                  : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxdatain                : VitalDelayArrayType01(31 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txclk                   : VitalDelayType01 := DefpropDelay01;
      tipd_syncstatus              : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxpcsdprioin            : VitalDelayArrayType01(1599 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txdigitalreset          : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txdatain                : VitalDelayArrayType01(31 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_scanclk                 : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitchdonein        : VitalDelayType01 := DefpropDelay01;
      tipd_rdenablesync            : VitalDelayType01 := DefpropDelay01;
      tipd_dpclk                   : VitalDelayType01 := DefpropDelay01;
      tipd_rxphfiforeset           : VitalDelayType01 := DefpropDelay01;
      tipd_testin                  : VitalDelayArrayType01(9999 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txpllreset              : VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxrunningdisp           : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxdatavalid             : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_refclkdividerdprioin    : VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txpcsdprioin            : VitalDelayArrayType01(599 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_dprioin                 : VitalDelayType01 := DefpropDelay01;
      tipd_rateswitch              : VitalDelayType01 := DefpropDelay01;
      tipd_rxctrl                  : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxanalogreset           : VitalDelayArrayType01(5 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxclk                   : VitalDelayType01 := DefpropDelay01;
      tipd_txphfifowrenable        : VitalDelayType01 := DefpropDelay01;
      tipd_rxphfifowrdisable       : VitalDelayType01 := DefpropDelay01;
      tipd_rdalign                 : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_fixedclk                : VitalDelayArrayType01(5 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_dpriodisable            : VitalDelayType01 := DefpropDelay01;
      tipd_scanmode                : VitalDelayType01 := DefpropDelay01;
      tipd_rxphfifordenable        : VitalDelayType01 := DefpropDelay01;
      tipd_cmuplldprioin           : VitalDelayArrayType01(1799 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_txphfiforeset           : VitalDelayType01 := DefpropDelay01;
      tipd_txcoreclk               : VitalDelayType01 := DefpropDelay01;
      tipd_adet                    : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxdigitalreset          : VitalDelayArrayType01(3 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxpmadprioin            : VitalDelayArrayType01(1799 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_cmudividerdprioin       : VitalDelayArrayType01(599 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_rxcoreclk               : VitalDelayType01 := DefpropDelay01;
      tipd_dprioload               : VitalDelayType01 := DefpropDelay01;
      tipd_scanin                  : VitalDelayArrayType01(22 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_quadreset               : VitalDelayType01 := DefpropDelay01;
      tipd_nonuserfromcal          : VitalDelayType01 := DefpropDelay01;
      tipd_scanshift               : VitalDelayType01 := DefpropDelay01;
      tipd_txpmadprioin            : VitalDelayArrayType01(1799 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_recovclk                : VitalDelayType01 := DefpropDelay01;
      tipd_rxpowerdown             : VitalDelayArrayType01(5 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tsetup_dprioin_dpclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_dprioin_dpclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpd_dpclk_dprioout_posedge : VitalDelayType01 := DefPropDelay01;
      tpd_dpclk_dpriooe_posedge : VitalDelayType01 := DefPropDelay01;
      lpm_type                                     : STRING := "arriaii_hssi_cmu";
      analog_test_bus_enable                       : STRING := "false";       
      auto_spd_deassert_ph_fifo_rst_count          : INTEGER := 0;       
      auto_spd_phystatus_notify_count              : INTEGER := 0;        
      bonded_quad_mode                             : STRING := "none";
      bypass_bandgap                               : STRING := "false";     
      central_test_bus_select                      : INTEGER := 0;        
      cmu_type                                     : STRING := "regular";
      devaddr                                      : INTEGER := 1;
      dprio_config_mode               			   : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
      in_xaui_mode                                 : STRING := "false";
      migrated_from_prev_family                    : STRING := "false";
      num_con_align_chars_for_align                : INTEGER := 4;
      num_con_errors_for_align_loss                : INTEGER := 2;
      num_con_good_data_for_align_approach         : INTEGER := 3;
      offset_all_errors_align                      : STRING := "false";
      pipe_auto_speed_nego_enable                  : STRING := "false";      
      pipe_freq_scale_mode                         : STRING := "Data width"; 
      pma_done_count                               : INTEGER := 0;        
      portaddr                                     : INTEGER := 1;
      rx0_auto_spd_self_switch_enable              : STRING := "false";   
      rx0_channel_bonding                          : STRING := "none";    
      rx0_clk1_mux_select                          : STRING := "recovered clock";        
      rx0_clk2_mux_select                          : STRING := "recovered clock";        
      rx0_clk_pd_enable                            : STRING := "false";        
      rx0_ph_fifo_reg_mode                         : STRING := "false";        
      rx0_ph_fifo_reset_enable                     : STRING := "false";        
      rx0_ph_fifo_user_ctrl_enable                 : STRING := "false";        
      rx0_phfifo_wait_cnt                          : INTEGER := 0;          
      rx0_rd_clk_mux_select                        : STRING := "int clock";        
      rx0_recovered_clk_mux_select                 : STRING := "recovered clock";  
      rx0_reset_clock_output_during_digital_reset  : STRING := "false";        
      rx0_use_double_data_mode                     : STRING := "false";        
      rx_master_direction                          : STRING := "none";        
      rx_xaui_sm_backward_compatible_enable        : STRING := "false";       
      test_mode                                    : STRING := "false";
      tx0_auto_spd_self_switch_enable              : STRING := "false";       
      tx0_channel_bonding                          : STRING := "none";        
      tx0_clk_pd_enable                            : STRING := "false";       
      tx0_ph_fifo_reg_mode                         : STRING := "false";       
      tx0_ph_fifo_reset_enable                     : STRING := "false";       
      tx0_ph_fifo_user_ctrl_enable                 : STRING := "false";       
      tx0_rd_clk_mux_select                        : STRING := "int clock";   
      tx0_reset_clock_output_during_digital_reset  : STRING := "false";       
      tx0_use_double_data_mode                     : STRING := "false";       
      tx0_wr_clk_mux_select                        : STRING := "int_clk";     
      tx_master_direction                          : STRING := "none";        
      tx_pll0_used_as_rx_cdr                       : STRING := "false";       
      tx_pll1_used_as_rx_cdr                       : STRING := "false";       
      tx_xaui_sm_backward_compatible_enable        : STRING := "false";       
      use_deskew_fifo                              : STRING := "false";       
      vcceh_voltage                                : STRING := "3.0V";
      vcceh_voltage_user_specified_auto            : STRING := "true";
      protocol_hint                                : STRING := "basic";
      clkdiv0_inclk0_logical_to_physical_mapping   : STRING := "pll0";
      clkdiv0_inclk1_logical_to_physical_mapping   : STRING := "pll1";
      clkdiv1_inclk0_logical_to_physical_mapping   : STRING := "pll0";
      clkdiv1_inclk1_logical_to_physical_mapping   : STRING := "pll1";
      clkdiv2_inclk0_logical_to_physical_mapping   : STRING := "pll0";
      clkdiv2_inclk1_logical_to_physical_mapping   : STRING := "pll1";
      clkdiv3_inclk0_logical_to_physical_mapping   : STRING := "pll0";
      clkdiv3_inclk1_logical_to_physical_mapping   : STRING := "pll1";
      clkdiv4_inclk0_logical_to_physical_mapping   : STRING := "pll0";
      clkdiv4_inclk1_logical_to_physical_mapping   : STRING := "pll1";
      clkdiv5_inclk0_logical_to_physical_mapping   : STRING := "pll0";
      clkdiv5_inclk1_logical_to_physical_mapping   : STRING := "pll1";
      cmu_divider0_inclk0_physical_mapping      :   STRING := "pll0";
      cmu_divider0_inclk1_physical_mapping      :   STRING := "pll1";
      cmu_divider0_inclk2_physical_mapping      :   STRING := "x4";
      cmu_divider0_inclk3_physical_mapping      :   STRING := "xn_t";
      cmu_divider0_inclk4_physical_mapping      :   STRING := "xn_b";
      cmu_divider1_inclk0_physical_mapping      :   STRING := "pll0";
      cmu_divider1_inclk1_physical_mapping      :   STRING := "pll1";
      cmu_divider1_inclk2_physical_mapping      :   STRING := "x4";
      cmu_divider1_inclk3_physical_mapping      :   STRING := "xn_t";
      cmu_divider1_inclk4_physical_mapping      :   STRING := "xn_b";
      cmu_divider2_inclk0_physical_mapping      :   STRING := "pll0";
      cmu_divider2_inclk1_physical_mapping      :   STRING := "pll1";
      cmu_divider2_inclk2_physical_mapping      :   STRING := "x4";
      cmu_divider2_inclk3_physical_mapping      :   STRING := "xn_t";
      cmu_divider2_inclk4_physical_mapping      :   STRING := "xn_b";
      cmu_divider3_inclk0_physical_mapping      :   STRING := "pll0";
      cmu_divider3_inclk1_physical_mapping      :   STRING := "pll1";
      cmu_divider3_inclk2_physical_mapping      :   STRING := "x4";
      cmu_divider3_inclk3_physical_mapping      :   STRING := "xn_t";
      cmu_divider3_inclk4_physical_mapping      :   STRING := "xn_b";
      cmu_divider4_inclk0_physical_mapping      :   STRING := "pll0";
      cmu_divider4_inclk1_physical_mapping      :   STRING := "pll1";
      cmu_divider4_inclk2_physical_mapping      :   STRING := "x4";
      cmu_divider4_inclk3_physical_mapping      :   STRING := "xn_t";
      cmu_divider4_inclk4_physical_mapping      :   STRING := "xn_b";
      cmu_divider5_inclk0_physical_mapping      :   STRING := "pll0";
      cmu_divider5_inclk1_physical_mapping      :   STRING := "pll1";
      cmu_divider5_inclk2_physical_mapping      :   STRING := "x4";
      cmu_divider5_inclk3_physical_mapping      :   STRING := "xn_t";
      cmu_divider5_inclk4_physical_mapping      :   STRING := "xn_b";
      pll0_inclk0_logical_to_physical_mapping    :    STRING := "clkrefclk0";
      pll0_inclk1_logical_to_physical_mapping    :    STRING := "clkrefclk1";
      pll0_inclk2_logical_to_physical_mapping    :    STRING := "iq2";
      pll0_inclk3_logical_to_physical_mapping    :    STRING := "iq3";
      pll0_inclk4_logical_to_physical_mapping    :    STRING := "iq4";
      pll0_inclk5_logical_to_physical_mapping    :    STRING := "iq5";
      pll0_inclk6_logical_to_physical_mapping    :    STRING := "iq6";
      pll0_inclk7_logical_to_physical_mapping    :    STRING := "iq7";
      pll0_inclk8_logical_to_physical_mapping    :    STRING := "pld_clk";
      pll0_inclk9_logical_to_physical_mapping    :    STRING := "gpll_clk";
      pll1_inclk0_logical_to_physical_mapping    :    STRING := "clkrefclk0";
      pll1_inclk1_logical_to_physical_mapping    :    STRING := "clkrefclk1";
      pll1_inclk2_logical_to_physical_mapping    :    STRING := "iq2";
      pll1_inclk3_logical_to_physical_mapping    :    STRING := "iq3";
      pll1_inclk4_logical_to_physical_mapping    :    STRING := "iq4";
      pll1_inclk5_logical_to_physical_mapping    :    STRING := "iq5";
      pll1_inclk6_logical_to_physical_mapping    :    STRING := "iq6";
      pll1_inclk7_logical_to_physical_mapping    :    STRING := "iq7";
      pll1_inclk8_logical_to_physical_mapping    :    STRING := "pld_clk";
      pll1_inclk9_logical_to_physical_mapping    :    STRING := "gpll_clk";
      pll2_inclk0_logical_to_physical_mapping    :    STRING := "clkrefclk0";
      pll2_inclk1_logical_to_physical_mapping    :    STRING := "clkrefclk1";
      pll2_inclk2_logical_to_physical_mapping    :    STRING := "iq2";
      pll2_inclk3_logical_to_physical_mapping    :    STRING := "iq3";
      pll2_inclk4_logical_to_physical_mapping    :    STRING := "iq4";
      pll2_inclk5_logical_to_physical_mapping    :    STRING := "iq5";
      pll2_inclk6_logical_to_physical_mapping    :    STRING := "iq6";
      pll2_inclk7_logical_to_physical_mapping    :    STRING := "iq7";
      pll2_inclk8_logical_to_physical_mapping    :    STRING := "pld_clk";
      pll2_inclk9_logical_to_physical_mapping    :    STRING := "gpll_clk";
      pll3_inclk0_logical_to_physical_mapping    :    STRING := "clkrefclk0";
      pll3_inclk1_logical_to_physical_mapping    :    STRING := "clkrefclk1";
      pll3_inclk2_logical_to_physical_mapping    :    STRING := "iq2";
      pll3_inclk3_logical_to_physical_mapping    :    STRING := "iq3";
      pll3_inclk4_logical_to_physical_mapping    :    STRING := "iq4";
      pll3_inclk5_logical_to_physical_mapping    :    STRING := "iq5";
      pll3_inclk6_logical_to_physical_mapping    :    STRING := "iq6";
      pll3_inclk7_logical_to_physical_mapping    :    STRING := "iq7";
      pll3_inclk8_logical_to_physical_mapping    :    STRING := "pld_clk";
      pll3_inclk9_logical_to_physical_mapping    :    STRING := "gpll_clk";
      pll4_inclk0_logical_to_physical_mapping    :    STRING := "clkrefclk0";
      pll4_inclk1_logical_to_physical_mapping    :    STRING := "clkrefclk1";
      pll4_inclk2_logical_to_physical_mapping    :    STRING := "iq2";
      pll4_inclk3_logical_to_physical_mapping    :    STRING := "iq3";
      pll4_inclk4_logical_to_physical_mapping    :    STRING := "iq4";
      pll4_inclk5_logical_to_physical_mapping    :    STRING := "iq5";
      pll4_inclk6_logical_to_physical_mapping    :    STRING := "iq6";
      pll4_inclk7_logical_to_physical_mapping    :    STRING := "iq7";
      pll4_inclk8_logical_to_physical_mapping    :    STRING := "pld_clk";
      pll4_inclk9_logical_to_physical_mapping    :    STRING := "gpll_clk";
      pll5_inclk0_logical_to_physical_mapping    :    STRING := "clkrefclk0";
      pll5_inclk1_logical_to_physical_mapping    :    STRING := "clkrefclk1";
      pll5_inclk2_logical_to_physical_mapping    :    STRING := "iq2";
      pll5_inclk3_logical_to_physical_mapping    :    STRING := "iq3";
      pll5_inclk4_logical_to_physical_mapping    :    STRING := "iq4";
      pll5_inclk5_logical_to_physical_mapping    :    STRING := "iq5";
      pll5_inclk6_logical_to_physical_mapping    :    STRING := "iq6";
      pll5_inclk7_logical_to_physical_mapping    :    STRING := "iq7";
      pll5_inclk8_logical_to_physical_mapping    :    STRING := "pld_clk";
      pll5_inclk9_logical_to_physical_mapping    :    STRING := "gpll_clk";
      pll0_logical_to_physical_mapping    :    INTEGER := 0;
      pll1_logical_to_physical_mapping    :    INTEGER := 1;
      pll2_logical_to_physical_mapping    :    INTEGER := 2;
      pll3_logical_to_physical_mapping    :    INTEGER := 3;
      pll4_logical_to_physical_mapping    :    INTEGER := 4;
      pll5_logical_to_physical_mapping    :    INTEGER := 5;
      refclk_divider0_logical_to_physical_mapping    :    INTEGER := 0;
      refclk_divider1_logical_to_physical_mapping    :    INTEGER := 1;
      rx0_logical_to_physical_mapping    :    INTEGER := 0;
      rx1_logical_to_physical_mapping    :    INTEGER := 1;
      rx2_logical_to_physical_mapping    :    INTEGER := 2;
      rx3_logical_to_physical_mapping    :    INTEGER := 3;
      rx4_logical_to_physical_mapping    :    INTEGER := 4;
      rx5_logical_to_physical_mapping    :    INTEGER := 5;
      tx0_logical_to_physical_mapping    :    INTEGER := 0;
      tx1_logical_to_physical_mapping    :    INTEGER := 1;
      tx2_logical_to_physical_mapping    :    INTEGER := 2;
      tx3_logical_to_physical_mapping    :    INTEGER := 3;
      tx4_logical_to_physical_mapping    :    INTEGER := 4;
      tx5_logical_to_physical_mapping    :    INTEGER := 5;
      tx0_pma_inclk0_logical_to_physical_mapping : STRING := "x1";
      tx0_pma_inclk1_logical_to_physical_mapping : STRING := "x4";
      tx0_pma_inclk2_logical_to_physical_mapping : STRING := "xn_top";
      tx0_pma_inclk3_logical_to_physical_mapping : STRING := "xn_bottom";
      tx0_pma_inclk4_logical_to_physical_mapping : STRING := "hypertransport";
      tx1_pma_inclk0_logical_to_physical_mapping : STRING := "x1";
      tx1_pma_inclk1_logical_to_physical_mapping : STRING := "x4";
      tx1_pma_inclk2_logical_to_physical_mapping : STRING := "xn_top";
      tx1_pma_inclk3_logical_to_physical_mapping : STRING := "xn_bottom";
      tx1_pma_inclk4_logical_to_physical_mapping : STRING := "hypertransport";
      tx2_pma_inclk0_logical_to_physical_mapping : STRING := "x1";
      tx2_pma_inclk1_logical_to_physical_mapping : STRING := "x4";
      tx2_pma_inclk2_logical_to_physical_mapping : STRING := "xn_top";
      tx2_pma_inclk3_logical_to_physical_mapping : STRING := "xn_bottom";
      tx2_pma_inclk4_logical_to_physical_mapping : STRING := "hypertransport";
      tx3_pma_inclk0_logical_to_physical_mapping : STRING := "x1";
      tx3_pma_inclk1_logical_to_physical_mapping : STRING := "x4";
      tx3_pma_inclk2_logical_to_physical_mapping : STRING := "xn_top";
      tx3_pma_inclk3_logical_to_physical_mapping : STRING := "xn_bottom";
      tx3_pma_inclk4_logical_to_physical_mapping : STRING := "hypertransport";
      tx4_pma_inclk0_logical_to_physical_mapping : STRING := "x1";
      tx4_pma_inclk1_logical_to_physical_mapping : STRING := "x4";
      tx4_pma_inclk2_logical_to_physical_mapping : STRING := "xn_top";
      tx4_pma_inclk3_logical_to_physical_mapping : STRING := "xn_bottom";
      tx4_pma_inclk4_logical_to_physical_mapping : STRING := "hypertransport";
      tx5_pma_inclk0_logical_to_physical_mapping : STRING := "x1";
      tx5_pma_inclk1_logical_to_physical_mapping : STRING := "x4";
      tx5_pma_inclk2_logical_to_physical_mapping : STRING := "xn_top";
      tx5_pma_inclk3_logical_to_physical_mapping : STRING := "xn_bottom";
      tx5_pma_inclk4_logical_to_physical_mapping : STRING := "hypertransport";
      sim_dump_dprio_internal_reg_at_time          : INTEGER := 0;        -- in ps
      sim_dump_filename                            : STRING := "sim_dprio_dump.txt"        -- over-write when multiple CMUs
   );
   PORT (
      adet                                         : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      cmudividerdprioin                            : IN STD_LOGIC_VECTOR(599 DOWNTO 0) := (others => '0');
      cmuplldprioin                                : IN STD_LOGIC_VECTOR(1799 DOWNTO 0) := (others => '0');
      dpclk                                        : IN STD_LOGIC := '0';
      dpriodisable                                 : IN STD_LOGIC := '1';
      dprioin                                      : IN STD_LOGIC := '0';
      dprioload                                    : IN STD_LOGIC := '0';
      extra10gin                                   : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0');
      fixedclk                                     : IN STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
      lccmurtestbussel                             : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
      nonuserfromcal                               : IN STD_LOGIC := '0';
      pmacramtest                                  : IN STD_LOGIC := '0';    -- new 9.0 ww47
      quadreset                                    : IN STD_LOGIC := '0';
      rateswitch                                   : IN STD_LOGIC := '0';
      rateswitchdonein                             : IN STD_LOGIC := '0';
      rdalign                                      : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      rdenablesync                                 : IN STD_LOGIC := '0';
      recovclk                                     : IN STD_LOGIC := '0';
      refclkdividerdprioin                         : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
      rxanalogreset                                : IN STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
      rxclk                                        : IN STD_LOGIC := '0';
      rxcoreclk                                    : IN STD_LOGIC := '0';
      rxctrl                                       : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      rxdatain                                     : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
      rxdatavalid                                  : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      rxdigitalreset                               : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      rxpcsdprioin                                 : IN STD_LOGIC_VECTOR(1599 DOWNTO 0) := (others => '0');
      rxphfifordenable                             : IN STD_LOGIC := '0';
      rxphfiforeset                                : IN STD_LOGIC := '0';
      rxphfifowrdisable                            : IN STD_LOGIC := '0';
      rxpmadprioin                                 : IN STD_LOGIC_VECTOR(1799 DOWNTO 0) := (others => '0');
      rxpowerdown                                  : IN STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
      rxrunningdisp                                : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      scanclk                                      : IN STD_LOGIC := '0';
      scanin                                       : IN STD_LOGIC_VECTOR(22 DOWNTO 0) := (others => '0');
      scanmode                                     : IN STD_LOGIC := '0';
      scanshift                                    : IN STD_LOGIC := '0';
      syncstatus                                   : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      testin                                       : IN STD_LOGIC_VECTOR(9999 DOWNTO 0) := (others => '0');
      txclk                                        : IN STD_LOGIC := '0';
      txcoreclk                                    : IN STD_LOGIC := '0';
      txctrl                                       : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      txdatain                                     : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
      txdigitalreset                               : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
      txpcsdprioin                                 : IN STD_LOGIC_VECTOR(599 DOWNTO 0) := (others => '0');
      txphfiforddisable                            : IN STD_LOGIC := '0';
      txphfiforeset                                : IN STD_LOGIC := '0';
      txphfifowrenable                             : IN STD_LOGIC := '0';
      txpllreset                                   : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
      txpmadprioin                                 : IN STD_LOGIC_VECTOR(1799 DOWNTO 0) := (others => '0');
      alignstatus                                  : OUT STD_LOGIC;
      autospdx4configsel                           : OUT STD_LOGIC;
      autospdx4rateswitchout                       : OUT STD_LOGIC;
      autospdx4spdchg                              : OUT STD_LOGIC;
      clkdivpowerdn                                : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      cmudividerdprioout                           : OUT STD_LOGIC_VECTOR(599 DOWNTO 0);
      cmuplldprioout                               : OUT STD_LOGIC_VECTOR(1799 DOWNTO 0);
      digitaltestout                               : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      dpriodisableout                              : OUT STD_LOGIC;
      dpriooe                                      : OUT STD_LOGIC;
      dprioout                                     : OUT STD_LOGIC;
      enabledeskew                                 : OUT STD_LOGIC;
      extra10gout                                  : OUT STD_LOGIC;
      fiforesetrd                                  : OUT STD_LOGIC;
      lccmutestbus                                 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      phfifiox4ptrsreset                           : OUT STD_LOGIC;
      pllpowerdn                                   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      pllresetout                                  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      quadresetout                                 : OUT STD_LOGIC;
      refclkdividerdprioout                        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxadcepowerdown                              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rxadceresetout                               : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rxanalogresetout                             : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      rxcrupowerdown                               : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      rxcruresetout                                : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      rxctrlout                                    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rxdataout                                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rxdigitalresetout                            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      rxibpowerdown                                : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      rxpcsdprioout                                : OUT STD_LOGIC_VECTOR(1599 DOWNTO 0);
      rxphfifox4byteselout                         : OUT STD_LOGIC;
      rxphfifox4wrclkout                           : OUT STD_LOGIC;
      rxphfifox4rdenableout                        : OUT STD_LOGIC;
      rxphfifox4wrenableout                        : OUT STD_LOGIC;
      rxpmadprioout                                : OUT STD_LOGIC_VECTOR(1799 DOWNTO 0);
      scanout                                      : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
      testout                                      : OUT STD_LOGIC_VECTOR(6999 DOWNTO 0);
      txanalogresetout                             : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      txctrlout                                    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      txdataout                                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      txdetectrxpowerdown                          : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      txdigitalresetout                            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      txdividerpowerdown                           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      txobpowerdown                                : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      txpcsdprioout                                : OUT STD_LOGIC_VECTOR(599 DOWNTO 0);
      txphfifox4byteselout                         : OUT STD_LOGIC;
      txphfifox4rdclkout                           : OUT STD_LOGIC;
      txphfifox4rdenableout                        : OUT STD_LOGIC;
      txphfifox4wrenableout                        : OUT STD_LOGIC;
      txpmadprioout                                : OUT STD_LOGIC_VECTOR(1799 DOWNTO 0)
   );
END COMPONENT;

--
-- arriaii_hssi_calibration_block
--

COMPONENT arriaii_hssi_calibration_block
    GENERIC (    
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_clk                : VitalDelayType01 := DefpropDelay01;
        lpm_type                       :  string  := "arriaii_hssi_calibration_block";    
        cont_cal_mode                  :  string  := "false";    
        enable_rx_cal_tw               :  string  := "false";    
        enable_tx_cal_tw               :  string  := "false";
        migrated_from_prev_family      :  string  := "false";
        rtest                          :  string  := "false";            
        rx_cal_wt_value                :  integer := 0;    
        send_rx_cal_status             :  string  := "true";
        tx_cal_wt_value                :  integer := 1);   
    PORT (
        clk                            : IN std_logic := '0';   
        enabletestbus                  : IN std_logic := '0';   
        powerdn                        : IN std_logic := '0'; 
        testctrl                       : IN std_logic := '0';           
        calibrationstatus              : OUT std_logic_vector(4 DOWNTO 0);
        nonusertocmu                   : OUT std_logic);   
END COMPONENT;

--
-- arriaii_hssi_refclk_divider
--

COMPONENT arriaii_hssi_refclk_divider
    GENERIC (
        divider_number : INTEGER := 0;  -- 0 or 1 for logical numbering
        enable_divider : STRING  := "false";
        lpm_type       : STRING  := "arriaii_hssi_refclk_divider";
        refclk_coupling_termination : STRING := "dc_coupling_external_termination";
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        tipd_dpriodisable : VitalDelayType01 := DefPropDelay01;
        tipd_dprioin      : VitalDelayType01 := DefPropDelay01;
        tipd_inclk        : VitalDelayType01 := DefPropDelay01;
        tpd_inclk_clkout  : VitalDelayType01 := DefPropDelay01
    );
    PORT (
        dpriodisable            : IN STD_LOGIC := '1';   
        dprioin                 : IN STD_LOGIC := '0';   
        inclk                   : IN STD_LOGIC:= '0';   
        clkout                  : OUT STD_LOGIC;   
        dprioout                : OUT STD_LOGIC);   
END COMPONENT;

end arriaii_hssi_components;

package body ARRIAII_HSSI_COMPONENTS is


function bin2int (s : std_logic_vector) return integer is

      constant temp      : std_logic_vector(s'high-s'low DOWNTO 0) := s;      
      variable result      : integer := 0;
   begin
      for i in temp'range loop
         if (temp(i) = '1') then
            result := result + (2**i);
         end if;
      end loop;
      return(result);
   end bin2int;
                  
function bin2int (s : std_logic) return integer is
      constant temp      : std_logic := s;      
      variable result      : integer := 0;
   begin
         if (temp = '1') then
            result := 1;
         else
         	result := 0;
     	 end if;
      return(result);
	end bin2int;
	
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
    
function int2bin (arg : boolean; size : integer) return std_logic_vector is
    variable result : std_logic_vector(size-1 downto 0);
    begin
		if(arg)then
			result := (OTHERS => '1');
		else
			result := (OTHERS => '0');
		end if;
        return result;
    end int2bin;

function int2bit (arg : integer) return std_logic is
    variable int_val : integer := arg;
    variable result : std_logic;
    begin
        
            if (int_val  = 0) then
                result := '0';
            else
                result := '1';
            end if;
            
        return result;
end int2bit;

function int2bit (arg : boolean) return std_logic is
    variable int_val : boolean := arg;
    variable result : std_logic;
    begin
        
            if (int_val ) then
                result := '1';
            else
                result := '0';
            end if;
            
        return result;
end int2bit;

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

function mux_select (sel : boolean; data1 : std_logic_vector; data2 : std_logic_vector) return std_logic_vector is
variable dataout      : std_logic_vector(data1'range);
   begin
      if(sel) then
         dataout := data1;
      else
         dataout := data2;
      end if;
      
      return (dataout);
   end mux_select;

function mux_select (sel : boolean; data1 : std_logic; data2 : std_logic) return std_logic is
variable dataout      : std_logic;
   begin
      if(sel) then
         dataout := data1;
      else
         dataout := data2;
      end if;
      
      return (dataout);
   end mux_select;
   
function mux_select (sel : bit; data1 : std_logic_vector; data2 : std_logic_vector) return std_logic_vector is
variable dataout      : std_logic_vector(data1'range);
   begin
      if(sel = '1') then
         dataout := data1;
      else
         dataout := data2;
      end if;
      
      return (dataout);
   end mux_select;
  
function mux_select (sel : bit; data1 : std_logic; data2 : std_logic) return std_logic is
variable dataout      : std_logic;
   begin
      if(sel = '1') then
         dataout := data1;
      else
         dataout := data2;
      end if;
      
      return (dataout);
   end mux_select;
   
function rx_top_basic_width (channel_width : integer) return integer is
variable basic_width :  integer;
begin
	 if (channel_width mod 10 = 0) then 
            basic_width := 10;
        else
            basic_width := 8;
        end if;
        return(basic_width);
end rx_top_basic_width;

function rx_top_num_of_basic (channel_width : integer) return integer is 
variable num_of_basic : integer;
begin
	 if (channel_width mod 10 = 0) then 
            num_of_basic := channel_width/10;
        else
            num_of_basic := channel_width/8;
        end if;
        return(num_of_basic);
end rx_top_num_of_basic;

function reduction_or (
      val : std_logic_vector) return std_logic is

      variable result : std_logic := '0';
   begin
      for i in val'range loop
         result := result or val(i);
      end loop;
      return(result);
end reduction_or;

function reduction_nor (
      val : std_logic_vector) return std_logic is

      variable result : std_logic := '0';
   begin
      for i in val'range loop
         result := result or val(i);
      end loop;
      return(not result);
end reduction_nor;

function reduction_xor (
      val : std_logic_vector) return std_logic is

      variable result : std_logic := '0';
   begin
      for i in val'range loop
         result := result xor val(i);
      end loop;
      return(result);
end reduction_xor;

function reduction_and (
      val : std_logic_vector) return std_logic is

      variable result : std_logic := '1';
   begin
      for i in val'range loop
         result := result and val(i);
      end loop;
      return(result);
end reduction_and;

function reduction_nand (
      val : std_logic_vector) return std_logic is

      variable result : std_logic := '1';
   begin
      for i in val'range loop
         result := result and val(i);
      end loop;
      return(not result);
end reduction_nand;

function alpha_tolower (given_string : string) return string is      
   -- VARIABLE DECLARATION                                           
   variable string_length : integer := given_string'length;          
   variable result_string : string(1 to 25) := "                         ";
                                                                     
begin                                                                
   for i in 1 to string_length loop                                  
       case given_string(i) is                                       
           when 'A' => result_string(i) := 'a';                      
           when 'B' => result_string(i) := 'b';                      
           when 'C' => result_string(i) := 'c';                      
           when 'D' => result_string(i) := 'd';                      
           when 'E' => result_string(i) := 'e';                      
           when 'F' => result_string(i) := 'f';                      
           when 'G' => result_string(i) := 'g';                      
           when 'H' => result_string(i) := 'h';                      
           when 'I' => result_string(i) := 'i';                      
           when 'J' => result_string(i) := 'j';                      
           when 'K' => result_string(i) := 'k';                      
           when 'L' => result_string(i) := 'l';                      
           when 'M' => result_string(i) := 'm';                      
           when 'N' => result_string(i) := 'n';                      
           when 'O' => result_string(i) := 'o';                      
           when 'P' => result_string(i) := 'p';                      
           when 'Q' => result_string(i) := 'q';                      
           when 'R' => result_string(i) := 'r';                      
           when 'S' => result_string(i) := 's';                      
           when 'T' => result_string(i) := 't';                      
           when 'U' => result_string(i) := 'u';                      
           when 'V' => result_string(i) := 'v';                      
           when 'W' => result_string(i) := 'w';                      
           when 'X' => result_string(i) := 'x';                      
           when 'Y' => result_string(i) := 'y';                      
           when 'Z' => result_string(i) := 'z';                      
           when others => result_string(i) := given_string(i);       
       end case;                                                     
   end loop;                                                         
   return (result_string(1 to string_length));                       
end alpha_tolower;     


function arriaii_tx_pcs_mph_fifo_xn_mapping (ph_fifo_xn_select : integer; ph_fifo_xn_mapping0 : string; ph_fifo_xn_mapping1 : string; ph_fifo_xn_mapping2 : string) return string is 
begin
        CASE ph_fifo_xn_select IS
            WHEN 0      => RETURN ph_fifo_xn_mapping0;
            WHEN 1      => RETURN ph_fifo_xn_mapping1;
            WHEN 2      => RETURN ph_fifo_xn_mapping2;
            WHEN OTHERS => RETURN "none";
        END CASE;
end arriaii_tx_pcs_mph_fifo_xn_mapping;  


function arriaii_tx_pcs_mphfifo_index ( ph_fifo_xn_select : integer) return integer is
variable fifo_index : integer;
begin
      if ((ph_fifo_xn_select = 0) OR (ph_fifo_xn_select = 1) or (ph_fifo_xn_select = 2)) then    
      	fifo_index :=   ph_fifo_xn_select;
      else
      	fifo_index :=   0;
      end if;
      return(fifo_index);
end arriaii_tx_pcs_mphfifo_index;

function arriaii_tx_pcs_miqp_phfifo_index ( ph_fifo_xn_select : integer) return integer is
variable fifo_index : integer;
begin
      if ((ph_fifo_xn_select = 0) OR (ph_fifo_xn_select = 1)) then    
      	fifo_index :=   ph_fifo_xn_select;
      else
      	fifo_index :=   0;
      end if;
      return(fifo_index);
end arriaii_tx_pcs_miqp_phfifo_index;



     
                               
end ARRIAII_HSSI_COMPONENTS;
