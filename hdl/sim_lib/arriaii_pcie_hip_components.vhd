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


package ARRIAII_PCIE_HIP_COMPONENTS is



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

-- GENERIC utility functions BEGIN
function bin2int (s : std_logic_vector) return integer;
function bin2int (s : std_logic) return integer;
function int2bit (arg : boolean) return std_logic;
function int2bin (arg : boolean; size : integer) return std_logic_vector;
function int2bit (arg : integer) return std_logic;
function mux_select (sel : boolean; data1 : std_logic_vector; data2 : std_logic_vector) return std_logic_vector;
function mux_select (sel : bit; data1 : std_logic_vector; data2 : std_logic_vector) return std_logic_vector;
function mux_select (sel : boolean; data1 : std_logic; data2 : std_logic) return std_logic;
function mux_select (sel : bit; data1 : std_logic; data2 : std_logic) return std_logic;
function reduction_or (val : std_logic_vector) return std_logic;
function reduction_nor (val : std_logic_vector) return std_logic;
function reduction_xor (val : std_logic_vector) return std_logic;
function reduction_and (val : std_logic_vector) return std_logic;
function reduction_nand (val : std_logic_vector) return std_logic;

function hssiSelectDelay (CONSTANT Paths: IN  VitalPathArray01Type) return TIME;
function alpha_tolower (given_string : string) return string;

-- GENERIC utility functions END


--
-- arriaii_pciehip_pciexp_dcfiforam
--

COMPONENT arriaii_pciehip_pciexp_dcfiforam
   GENERIC (
      addr_width  : INTEGER := 4;
      data_width  : INTEGER := 32
   );
   PORT (
      data        : IN STD_LOGIC_VECTOR((data_width - 1) DOWNTO 0);
      wren        : IN STD_LOGIC;
      wraddress   : IN STD_LOGIC_VECTOR((addr_width - 1) DOWNTO 0);
      rdaddress   : IN STD_LOGIC_VECTOR((addr_width - 1) DOWNTO 0);
      wrclock     : IN STD_LOGIC;
      rdclock     : IN STD_LOGIC;
      q           : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
   );
END COMPONENT;

--
-- arriaii_hssi_pcie_hip
--

COMPONENT arriaii_hssi_pcie_hip
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
        tipd_bistenrcv0               : VitalDelayType01 := DefpropDelay01;
        tipd_bistenrcv1               : VitalDelayType01 := DefpropDelay01;
        tipd_bistenrpl                : VitalDelayType01 := DefpropDelay01;
        tipd_bistscanen               : VitalDelayType01 := DefpropDelay01;
        tipd_bistscanin               : VitalDelayType01 := DefpropDelay01;
        tipd_bisttesten               : VitalDelayType01 := DefpropDelay01;
        tipd_coreclkin                : VitalDelayType01 := DefpropDelay01;
        tipd_corecrst                 : VitalDelayType01 := DefpropDelay01;
        tipd_corepor                  : VitalDelayType01 := DefpropDelay01;
        tipd_corerst                  : VitalDelayType01 := DefpropDelay01;
        tipd_coresrst                 : VitalDelayType01 := DefpropDelay01;
        tipd_cplerr                   : VitalDelayArrayType01(7 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_cplpending               : VitalDelayType01 := DefpropDelay01;
        tipd_dbgpipex1rx              : VitalDelayArrayType01(15 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlaspmcr0                : VitalDelayType01 := DefpropDelay01;
        tipd_dlcomclkreg              : VitalDelayType01 := DefpropDelay01;
        tipd_dlctrllink2              : VitalDelayArrayType01(13 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dldataupfc               : VitalDelayArrayType01(12 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlhdrupfc                : VitalDelayArrayType01(8 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlinhdllp                : VitalDelayType01 := DefpropDelay01;
        tipd_dlmaxploaddcr            : VitalDelayArrayType01(3 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlreqphycfg              : VitalDelayArrayType01(4 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlreqphypm               : VitalDelayArrayType01(4 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlrequpfc                : VitalDelayType01 := DefpropDelay01;
        tipd_dlreqwake                : VitalDelayType01 := DefpropDelay01;
        tipd_dlrxecrcchk              : VitalDelayType01 := DefpropDelay01;
        tipd_dlsndupfc                : VitalDelayType01 := DefpropDelay01;
        tipd_dltxcfgextsy             : VitalDelayType01 := DefpropDelay01;
        tipd_dltxreqpm                : VitalDelayType01 := DefpropDelay01;
        tipd_dltxtyppm                : VitalDelayArrayType01(3 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dltypupfc                : VitalDelayArrayType01(2 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlvcctrl                 : VitalDelayArrayType01(8 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlvcidmap                : VitalDelayArrayType01(24 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dlvcidupfc               : VitalDelayArrayType01(3 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_dpclk                    : VitalDelayType01 := DefpropDelay01;
        tipd_dpriodisable             : VitalDelayType01 := DefpropDelay01;
        tipd_dprioin                  : VitalDelayType01 := DefpropDelay01;
        tipd_dprioload                : VitalDelayType01 := DefpropDelay01;
        tipd_extrain                  : VitalDelayArrayType01(12 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_lmiaddr                  : VitalDelayArrayType01(12 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_lmidin                   : VitalDelayArrayType01(32 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_lmirden                  : VitalDelayType01 := DefpropDelay01;
        tipd_lmiwren                  : VitalDelayType01 := DefpropDelay01;
        tipd_mode                     : VitalDelayArrayType01(2 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_mramhiptestenable        : VitalDelayType01 := DefpropDelay01;
        tipd_mramregscanen            : VitalDelayType01 := DefpropDelay01;
        tipd_mramregscanin            : VitalDelayType01 := DefpropDelay01;
        tipd_pclkcentral              : VitalDelayType01 := DefpropDelay01;
        tipd_pclkch0                  : VitalDelayType01 := DefpropDelay01;
        tipd_phyrst                   : VitalDelayType01 := DefpropDelay01;
        tipd_physrst                  : VitalDelayType01 := DefpropDelay01;
        tipd_phystatus                : VitalDelayArrayType01(8 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_pldclk                   : VitalDelayType01 := DefpropDelay01;
        tipd_pldrst                   : VitalDelayType01 := DefpropDelay01;
        tipd_pldsrst                  : VitalDelayType01 := DefpropDelay01;
        tipd_pllfixedclk              : VitalDelayType01 := DefpropDelay01;
        tipd_rxdata                   : VitalDelayArrayType01(64 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_rxdatak                  : VitalDelayArrayType01(8 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_rxelecidle               : VitalDelayArrayType01(8 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_rxmaskvc0                : VitalDelayType01 := DefpropDelay01;
        tipd_rxmaskvc1                : VitalDelayType01 := DefpropDelay01;
        tipd_rxreadyvc0               : VitalDelayType01 := DefpropDelay01;
        tipd_rxreadyvc1               : VitalDelayType01 := DefpropDelay01;
        tipd_rxstatus                 : VitalDelayArrayType01(24 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_rxvalid                  : VitalDelayArrayType01(8 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_scanen                   : VitalDelayType01 := DefpropDelay01;
        tipd_scanmoden                : VitalDelayType01 := DefpropDelay01;
        tipd_swdnin                   : VitalDelayArrayType01(3 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_swupin                   : VitalDelayArrayType01(7 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_testin                   : VitalDelayArrayType01(40 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlaermsinum              : VitalDelayArrayType01(5 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlappintasts             : VitalDelayType01 := DefpropDelay01;
        tipd_tlappmsinum              : VitalDelayArrayType01(5 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlappmsireq              : VitalDelayType01 := DefpropDelay01;
        tipd_tlappmsitc               : VitalDelayArrayType01(3 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlhpgctrler              : VitalDelayArrayType01(5 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlpexmsinum              : VitalDelayArrayType01(5 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlpmauxpwr               : VitalDelayType01 := DefpropDelay01;
        tipd_tlpmdata                 : VitalDelayArrayType01(10 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_tlpmetocr                : VitalDelayType01 := DefpropDelay01;
        tipd_tlpmevent                : VitalDelayType01 := DefpropDelay01;
        tipd_tlslotclkcfg             : VitalDelayType01 := DefpropDelay01;
        tipd_txdatavc00               : VitalDelayArrayType01(64 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_txdatavc01               : VitalDelayArrayType01(64 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_txdatavc10               : VitalDelayArrayType01(64 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_txdatavc11               : VitalDelayArrayType01(64 - 1 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_txeopvc00                : VitalDelayType01 := DefpropDelay01;
        tipd_txeopvc01                : VitalDelayType01 := DefpropDelay01;
        tipd_txeopvc10                : VitalDelayType01 := DefpropDelay01;
        tipd_txeopvc11                : VitalDelayType01 := DefpropDelay01;
        tipd_txerrvc0                 : VitalDelayType01 := DefpropDelay01;
        tipd_txerrvc1                 : VitalDelayType01 := DefpropDelay01;
        tipd_txsopvc00                : VitalDelayType01 := DefpropDelay01;
        tipd_txsopvc01                : VitalDelayType01 := DefpropDelay01;
        tipd_txsopvc10                : VitalDelayType01 := DefpropDelay01;
        tipd_txsopvc11                : VitalDelayType01 := DefpropDelay01;
        tipd_txvalidvc0               : VitalDelayType01 := DefpropDelay01;
        tipd_txvalidvc1               : VitalDelayType01 := DefpropDelay01;
        tpd_pldclk_clrrxpath_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlackphypm_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlackrequpfc_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlacksndupfc_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlcurrentdeemp_posedge                 : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlcurrentspeed_posedge                 : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dldllreq_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlerrdll_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlerrphy_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dllinkautobdwstatus_posedge            : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dllinkbdwmngstatus_posedge             : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlltssm_posedge                        : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlrpbufemp_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlrstentercompbit_posedge              : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlrsttxmarginfield_posedge             : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlrxtyppm_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlrxvalpm_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dltxackpm_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlup_posedge                           : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlupexit_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_dlvcstatus_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_ev128ns_posedge                        : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_ev1us_posedge                          : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_extraclkout_posedge                    : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_hotrstexit_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_intstatus_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_l2exit_posedge                         : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_laneact_posedge                        : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_linkup_posedge                         : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_lmiack_posedge                         : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_lmidout_posedge                        : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_resetstatus_posedge                    : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxbardecvc0_posedge                    : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxbardecvc1_posedge                    : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxbevc00_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxbevc01_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxbevc10_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxbevc11_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxdatavc00_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxdatavc01_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxdatavc10_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxdatavc11_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxeopvc00_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxeopvc01_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxeopvc10_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxeopvc11_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxerrvc0_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxerrvc1_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxfifoemptyvc0_posedge                 : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxfifoemptyvc1_posedge                 : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxfifofullvc0_posedge                  : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxfifofullvc1_posedge                  : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxsopvc00_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxsopvc01_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxsopvc10_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxsopvc11_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxvalidvc0_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_rxvalidvc1_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_r2cerr0ext_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_serrout_posedge                        : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_successspeednegoint_posedge            : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_swdnwake_posedge                       : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_swuphotrst_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_tlappintaack_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_tlappmsiack_posedge                    : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_tlpmetosr_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txcredvc0_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txcredvc1_posedge                      : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifoemptyvc0_posedge                 : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifoemptyvc1_posedge                 : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifofullvc0_posedge                  : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifofullvc1_posedge                  : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifordpvc0_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifordpvc1_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifowrpvc0_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txfifowrpvc1_posedge                   : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txreadyvc0_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_pldclk_txreadyvc1_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_dpclk_dataenablen_posedge                     : VitalDelayType01 := DefPropDelay01;
        tpd_dpclk_dprioout_posedge                        : VitalDelayType01 := DefPropDelay01;
        tpd_dpclk_dpriostate_posedge                      : VitalDelayType01 := DefPropDelay01;
        tsetup_corecrst_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        tsetup_coresrst_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        tsetup_cplerr_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        tsetup_cplpending_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlctrllink2_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_dldataupfc_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlhdrupfc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlinhdllp_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlmaxploaddcr_pldclk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlreqphycfg_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlreqphypm_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlrequpfc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlreqwake_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlrxecrcchk_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlsndupfc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dltxcfgextsy_pldclk_noedge_posedge         : VitalDelayType := DefSetupHoldCnst;
        tsetup_dltxreqpm_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dltxtyppm_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dltypupfc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlvcctrl_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlvcidmap_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dlvcidupfc_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_lmiaddr_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        tsetup_lmidin_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        tsetup_lmirden_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        tsetup_lmiwren_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        tsetup_physrst_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        tsetup_pldsrst_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        tsetup_rxmaskvc0_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_rxmaskvc1_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_rxreadyvc0_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_rxreadyvc1_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_swdnin_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        tsetup_swupin_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlaermsinum_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlappintasts_pldclk_noedge_posedge         : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlappmsinum_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlappmsireq_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlappmsitc_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlhpgctrler_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlpexmsinum_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlpmauxpwr_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlpmdata_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlpmetocr_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_tlpmevent_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txdatavc00_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_txdatavc01_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_txdatavc10_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_txdatavc11_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_txeopvc00_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txeopvc01_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txeopvc10_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txeopvc11_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txerrvc0_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        tsetup_txerrvc1_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        tsetup_txsopvc00_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txsopvc01_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txsopvc10_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txsopvc11_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_txvalidvc0_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        tsetup_txvalidvc1_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_corecrst_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        thold_coresrst_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        thold_cplerr_pldclk_noedge_posedge                : VitalDelayType := DefSetupHoldCnst;
        thold_cplpending_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_dlctrllink2_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_dldataupfc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_dlhdrupfc_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dlinhdllp_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dlmaxploaddcr_pldclk_noedge_posedge         : VitalDelayType := DefSetupHoldCnst;
        thold_dlreqphycfg_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_dlreqphypm_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_dlrequpfc_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dlreqwake_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dlrxecrcchk_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_dlsndupfc_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dltxcfgextsy_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        thold_dltxreqpm_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dltxtyppm_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dltypupfc_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dlvcctrl_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        thold_dlvcidmap_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_dlvcidupfc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_lmiaddr_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        thold_lmidin_pldclk_noedge_posedge                : VitalDelayType := DefSetupHoldCnst;
        thold_lmirden_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        thold_lmiwren_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        thold_physrst_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        thold_pldsrst_pldclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        thold_rxmaskvc0_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_rxmaskvc1_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_rxreadyvc0_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_rxreadyvc1_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_swdnin_pldclk_noedge_posedge                : VitalDelayType := DefSetupHoldCnst;
        thold_swupin_pldclk_noedge_posedge                : VitalDelayType := DefSetupHoldCnst;
        thold_tlaermsinum_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_tlappintasts_pldclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        thold_tlappmsinum_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_tlappmsireq_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_tlappmsitc_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_tlhpgctrler_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_tlpexmsinum_pldclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_tlpmauxpwr_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_tlpmdata_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        thold_tlpmetocr_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_tlpmevent_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txdatavc00_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_txdatavc01_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_txdatavc10_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_txdatavc11_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_txeopvc00_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txeopvc01_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txeopvc10_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txeopvc11_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txerrvc0_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        thold_txerrvc1_pldclk_noedge_posedge              : VitalDelayType := DefSetupHoldCnst;
        thold_txsopvc00_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txsopvc01_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txsopvc10_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txsopvc11_pldclk_noedge_posedge             : VitalDelayType := DefSetupHoldCnst;
        thold_txvalidvc0_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        thold_txvalidvc1_pldclk_noedge_posedge            : VitalDelayType := DefSetupHoldCnst;
        tsetup_dpriodisable_dpclk_noedge_posedge          : VitalDelayType := DefSetupHoldCnst;
        tsetup_dprioin_dpclk_noedge_posedge               : VitalDelayType := DefSetupHoldCnst;
        thold_dpriodisable_dpclk_noedge_posedge           : VitalDelayType := DefSetupHoldCnst;
        thold_dprioin_dpclk_noedge_posedge                : VitalDelayType := DefSetupHoldCnst;
      lpm_type                           : STRING := "arriaii_hssi_pcie_hip";
      advanced_errors                    : STRING := "false";
      allow_rx_valid_empty               : STRING := "false";   -- july3,2008
      bar0_64bit_mem_space               : STRING := "true";
      bar0_io_space                      : STRING := "false";
      bar0_prefetchable                  : STRING := "true";
      bar0_size_mask                     : INTEGER := 32;
      bar1_64bit_mem_space               : STRING := "false";
      bar1_io_space                      : STRING := "false";
      bar1_prefetchable                  : STRING := "false";
      bar1_size_mask                     : INTEGER := 4;
      bar2_64bit_mem_space               : STRING := "false";
      bar2_io_space                      : STRING := "false";
      bar2_prefetchable                  : STRING := "false";
      bar2_size_mask                     : INTEGER := 4;
      bar3_64bit_mem_space               : STRING := "false";
      bar3_io_space                      : STRING := "false";
      bar3_prefetchable                  : STRING := "false";
      bar3_size_mask                     : INTEGER := 4;
      bar4_64bit_mem_space               : STRING := "false";
      bar4_io_space                      : STRING := "false";
      bar4_prefetchable                  : STRING := "false";
      bar4_size_mask                     : INTEGER := 4;
      bar5_64bit_mem_space               : STRING := "false";
      bar5_io_space                      : STRING := "false";
      bar5_prefetchable                  : STRING := "false";
      bar5_size_mask                     : INTEGER := 4;
      bar_io_window_size                 : STRING := "NONE";
      bar_prefetchable                   : INTEGER := 0;
      base_address                       : INTEGER := 0;
      bridge_port_ssid_support           : STRING := "false";
      bridge_port_vga_enable             : STRING := "false";
      bypass_cdc                         : STRING := "false";
      bypass_tl                          : STRING := "false";
      class_code                         : INTEGER := 16711680;
      completion_timeout                 : STRING := "ABCD";
      core_clk_divider                   : INTEGER := 1;
      core_clk_source                    : STRING := "PLL_FIXED_CLK";
      credit_buffer_allocation_aux       : STRING := "BALANCED";
      deemphasis_enable                  : STRING := "false";
      device_address                     : INTEGER := 0;
      device_id                          : INTEGER := 1;
      device_number                      : INTEGER := 0;
      diffclock_nfts_count               : INTEGER := 128;
      disable_async_l2_logic             : STRING := "false";    -- july2,2008
      disable_cdc_clk_ppm                : STRING := "true";
      disable_device_number_mismatch     : STRING := "false";
      disable_link_x2_support            : STRING := "false";
      disable_snoop_packet               : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
      dll_active_report_support          : STRING := "false";
      ei_delay_powerdown_count           : INTEGER := 10;
      eie_before_nfts_count              : INTEGER := 4;
      enable_adapter_half_rate_mode      : STRING := "false";
      enable_ch0_pclk_out                : STRING := "false";
      enable_completion_timeout_disable  : STRING := "true";
      enable_coreclk_out_half_rate       : STRING := "false";
      enable_d1pm_support                : STRING := "false";
      enable_d2pm_support                : STRING := "false";
      enable_ecrc_check                  : STRING := "false";
      enable_ecrc_gen                    : STRING := "false";
      enable_function_msi_support        : STRING := "true";
      enable_function_msix_support       : STRING := "false";
      enable_gen2_core                   : STRING := "true";
      enable_hip_x1_loopback             : STRING := "false";
      enable_l1_aspm                     : STRING := "false";
      enable_msi_64bit_addressing        : STRING := "true";
      enable_msi_masking                 : STRING := "false";
      enable_rcv0buf_a_we                : STRING := "true";
      enable_rcv0buf_b_re                : STRING := "true";
      enable_rcv0buf_output_regs         : STRING := "false";
      enable_rcv1buf_a_we                : STRING := "true";
      enable_rcv1buf_b_re                : STRING := "true";
      enable_rcv1buf_output_regs         : STRING := "false";
      enable_retrybuf_a_we               : STRING := "true";
      enable_retrybuf_b_re               : STRING := "true";
      enable_retrybuf_ecc                : STRING := "false";		-- ww12
      enable_retrybuf_output_regs        : STRING := "false";
      enable_retrybuf_x8_clk_stealing    : INTEGER := 0;		-- ww12
      enable_rx0buf_ecc                  : STRING := "false";		-- ww12
      enable_rx0buf_x8_clk_stealing      : INTEGER := 0;		-- ww12
      enable_rx1buf_ecc                  : STRING := "false";		-- ww12
      enable_rx1buf_x8_clk_stealing      : INTEGER := 0;		-- ww12
      enable_rx_buffer_checking          : STRING := "false";
      enable_rx_ei_l0s_exit_refined      : STRING := "false";
      enable_rx_reordering               : STRING := "true";
      enable_slot_register               : STRING := "false";
      endpoint_l0_latency                : INTEGER := 0;
      endpoint_l1_latency                : INTEGER := 0;
      expansion_base_address_register    : INTEGER := 0;
      extend_tag_field                   : STRING := "false";
      fc_init_timer                      : INTEGER := 1024;
      flow_control_timeout_count         : INTEGER := 200;
      flow_control_update_count          : INTEGER := 30;
      gen2_diffclock_nfts_count          : INTEGER := 255;
      gen2_lane_rate_mode                : STRING := "false";
      gen2_sameclock_nfts_count          : INTEGER := 255;
      hot_plug_support                   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
      iei_logic                          : STRING := "IEI_IIIS";
      indicator                          : INTEGER := 7;
      l01_entry_latency                  : INTEGER := 31;
      l0_exit_latency_diffclock          : INTEGER := 6;
      l0_exit_latency_sameclock          : INTEGER := 6;
      l1_exit_latency_diffclock          : INTEGER := 0;
      l1_exit_latency_sameclock          : INTEGER := 0;
      lane_mask                          : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11110000";
      low_priority_vc                    : INTEGER := 0;
      max_link_width                     : INTEGER := 4;
      max_payload_size                   : INTEGER := 2;
      maximum_current                    : INTEGER := 0;
      migrated_from_prev_family          : STRING := "false";
      millisecond_cycle_count            : INTEGER := 0;
      mram_bist_settings                 : STRING := "";
      msi_function_count                 : INTEGER := 2;
      msix_pba_bir                       : INTEGER := 0;
      msix_pba_offset                    : INTEGER := 0;
      msix_table_bir                     : INTEGER := 0;
      msix_table_offset                  : INTEGER := 0;
      msix_table_size                    : INTEGER := 0;
      no_command_completed               : STRING := "true";
      no_soft_reset                      : STRING := "false";
      pcie_mode                          : STRING := "SHARED_MODE";
      pme_state_enable                   : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
      port_link_number                   : INTEGER := 1;
      port_address                       : INTEGER := 0;
      register_pipe_signals              : STRING := "false";
      retry_buffer_last_active_address   : INTEGER := 2047;
      retry_buffer_memory_settings       : INTEGER := 0;
      revision_id                        : INTEGER := 1;
      rx0_adap_fifo_full_value           : INTEGER := 9;
      rx1_adap_fifo_full_value           : INTEGER := 9;
      rx_cdc_full_value                  : INTEGER := 12;
      rx_idl_os_count                    : INTEGER := 0;
      rx_ptr0_nonposted_dpram_max        : INTEGER := 0;
      rx_ptr0_nonposted_dpram_min        : INTEGER := 0;
      rx_ptr0_posted_dpram_max           : INTEGER := 0;
      rx_ptr0_posted_dpram_min           : INTEGER := 0;
      rx_ptr1_nonposted_dpram_max        : INTEGER := 0;
      rx_ptr1_nonposted_dpram_min        : INTEGER := 0;
      rx_ptr1_posted_dpram_max           : INTEGER := 0;
      rx_ptr1_posted_dpram_min           : INTEGER := 0;
      sameclock_nfts_count               : INTEGER := 128;
      single_rx_detect                   : INTEGER := 0;
      skp_os_schedule_count              : INTEGER := 0;
      slot_number                        : INTEGER := 0;
      slot_power_limit                   : INTEGER := 0;
      slot_power_scale                   : INTEGER := 0;
      ssid                               : INTEGER := 0;
      ssvid                              : INTEGER := 0;
      subsystem_device_id                : INTEGER := 1;
      subsystem_vendor_id                : INTEGER := 4466;
      surprise_down_error_support        : STRING := "false";
      tx0_adap_fifo_full_value           : INTEGER := 11;
      tx1_adap_fifo_full_value           : INTEGER := 11;
      tx_cdc_full_value                  : INTEGER := 12;
      tx_cdc_stop_dummy_full_value       : INTEGER := 11;
      use_crc_forwarding                 : STRING := "false";
      vc0_clk_enable                     : STRING := "true";
      vc0_rx_buffer_memory_settings      : INTEGER := 0;
      vc0_rx_flow_ctrl_compl_data        : INTEGER := 448;
      vc0_rx_flow_ctrl_compl_header      : INTEGER := 112;
      vc0_rx_flow_ctrl_nonposted_data    : INTEGER := 0;
      vc0_rx_flow_ctrl_nonposted_header  : INTEGER := 54;
      vc0_rx_flow_ctrl_posted_data       : INTEGER := 360;
      vc0_rx_flow_ctrl_posted_header     : INTEGER := 50;
      vc1_clk_enable                     : STRING := "false";
      vc1_rx_buffer_memory_settings      : INTEGER := 0;
      vc1_rx_flow_ctrl_compl_data        : INTEGER := 448;
      vc1_rx_flow_ctrl_compl_header      : INTEGER := 112;
      vc1_rx_flow_ctrl_nonposted_data    : INTEGER := 0;
      vc1_rx_flow_ctrl_nonposted_header  : INTEGER := 54;
      vc1_rx_flow_ctrl_posted_data       : INTEGER := 360;
      vc1_rx_flow_ctrl_posted_header     : INTEGER := 50;
      vc_arbitration                     : INTEGER := 1;
      vc_enable                          : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
      vendor_id                          : INTEGER := 4466
   );
   PORT (
      bistenrcv0                         : IN STD_LOGIC := '0';
      bistenrcv1                         : IN STD_LOGIC := '0';
      bistenrpl                          : IN STD_LOGIC := '0';
      bistscanen                         : IN STD_LOGIC := '0';
      bistscanin                         : IN STD_LOGIC := '0';
      bisttesten                         : IN STD_LOGIC := '0';
      coreclkin                          : IN STD_LOGIC := '0';
      corecrst                           : IN STD_LOGIC := '0';
      corepor                            : IN STD_LOGIC := '0';
      corerst                            : IN STD_LOGIC := '0';
      coresrst                           : IN STD_LOGIC := '0';
      cplerr                             : IN STD_LOGIC_VECTOR(7 - 1 DOWNTO 0) := (others => '0');
      cplpending                         : IN STD_LOGIC := '0';
      dbgpipex1rx                        : IN STD_LOGIC_VECTOR(15 - 1 DOWNTO 0) := (others => '0');
      dlaspmcr0                          : IN STD_LOGIC := '0';
      dlcomclkreg                        : IN STD_LOGIC := '0';
      dlctrllink2                        : IN STD_LOGIC_VECTOR(13 - 1 DOWNTO 0) := (others => '0');
      dldataupfc                         : IN STD_LOGIC_VECTOR(12 - 1 DOWNTO 0) := (others => '0');
      dlhdrupfc                          : IN STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (others => '0');
      dlinhdllp                          : IN STD_LOGIC := '1';
      dlmaxploaddcr                      : IN STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (others => '0');
      dlreqphycfg                        : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (others => '0');
      dlreqphypm                         : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (others => '0');
      dlrequpfc                          : IN STD_LOGIC := '0';
      dlreqwake                          : IN STD_LOGIC := '0';
      dlrxecrcchk                        : IN STD_LOGIC := '0';
      dlsndupfc                          : IN STD_LOGIC := '0';
      dltxcfgextsy                       : IN STD_LOGIC := '0';
      dltxreqpm                          : IN STD_LOGIC := '0';
      dltxtyppm                          : IN STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (others => '0');
      dltypupfc                          : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      dlvcctrl                           : IN STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (others => '0');
      dlvcidmap                          : IN STD_LOGIC_VECTOR(24 - 1 DOWNTO 0) := (others => '0');
      dlvcidupfc                         : IN STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (others => '0');
      dpclk                              : IN STD_LOGIC := '0';
      dpriodisable                       : IN STD_LOGIC := '1';
      dprioin                            : IN STD_LOGIC := '0';
      dprioload                          : IN STD_LOGIC := '0';
      extrain                            : IN STD_LOGIC_VECTOR(12 - 1 DOWNTO 0) := (others => '0');
      lmiaddr                            : IN STD_LOGIC_VECTOR(12 - 1 DOWNTO 0) := (others => '0');
      lmidin                             : IN STD_LOGIC_VECTOR(32 - 1 DOWNTO 0) := (others => '0');
      lmirden                            : IN STD_LOGIC := '0';
      lmiwren                            : IN STD_LOGIC := '0';
      mode                               : IN STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (others => '0');
      mramhiptestenable                  : IN STD_LOGIC := '0';
      mramregscanen                      : IN STD_LOGIC := '0';
      mramregscanin                      : IN STD_LOGIC := '0';
      pclkcentral                        : IN STD_LOGIC := '0';
      pclkch0                            : IN STD_LOGIC := '0';
      phyrst                             : IN STD_LOGIC := '0';
      physrst                            : IN STD_LOGIC := '0';
      phystatus                          : IN STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (others => '0');
      pldclk                             : IN STD_LOGIC := '0';
      pldrst                             : IN STD_LOGIC := '0';
      pldsrst                            : IN STD_LOGIC := '0';
      pllfixedclk                        : IN STD_LOGIC := '0';
      rxdata                             : IN STD_LOGIC_VECTOR(64 - 1 DOWNTO 0) := (others => '0');
      rxdatak                            : IN STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (others => '0');
      rxelecidle                         : IN STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (others => '0');
      rxmaskvc0                          : IN STD_LOGIC := '0';
      rxmaskvc1                          : IN STD_LOGIC := '0';
      rxreadyvc0                         : IN STD_LOGIC := '0';
      rxreadyvc1                         : IN STD_LOGIC := '0';
      rxstatus                           : IN STD_LOGIC_VECTOR(24 - 1 DOWNTO 0) := (others => '0');
      rxvalid                            : IN STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (others => '0');
      scanen                             : IN STD_LOGIC := '0';
      scanmoden                          : IN STD_LOGIC := '0';
      swdnin                             : IN STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (others => '0');
      swupin                             : IN STD_LOGIC_VECTOR(7 - 1 DOWNTO 0) := (others => '0');
      testin                             : IN STD_LOGIC_VECTOR(40 - 1 DOWNTO 0) := (others => '0');
      tlaermsinum                        : IN STD_LOGIC_VECTOR(5 - 1 DOWNTO 0) := (others => '0');
      tlappintasts                       : IN STD_LOGIC := '0';
      tlappmsinum                        : IN STD_LOGIC_VECTOR(5 - 1 DOWNTO 0) := (others => '0');
      tlappmsireq                        : IN STD_LOGIC := '0';
      tlappmsitc                         : IN STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (others => '0');
      tlhpgctrler                        : IN STD_LOGIC_VECTOR(5 - 1 DOWNTO 0) := (others => '0');
      tlpexmsinum                        : IN STD_LOGIC_VECTOR(5 - 1 DOWNTO 0) := (others => '0');
      tlpmauxpwr                         : IN STD_LOGIC := '0';
      tlpmdata                           : IN STD_LOGIC_VECTOR(10 - 1 DOWNTO 0) := (others => '0');
      tlpmetocr                          : IN STD_LOGIC := '0';
      tlpmevent                          : IN STD_LOGIC := '0';
      tlslotclkcfg                       : IN STD_LOGIC := '0';
      txdatavc00                         : IN STD_LOGIC_VECTOR(64 - 1 DOWNTO 0) := (others => '0');
      txdatavc01                         : IN STD_LOGIC_VECTOR(64 - 1 DOWNTO 0) := (others => '0');
      txdatavc10                         : IN STD_LOGIC_VECTOR(64 - 1 DOWNTO 0) := (others => '0');
      txdatavc11                         : IN STD_LOGIC_VECTOR(64 - 1 DOWNTO 0) := (others => '0');
      txeopvc00                          : IN STD_LOGIC := '0';
      txeopvc01                          : IN STD_LOGIC := '0';
      txeopvc10                          : IN STD_LOGIC := '0';
      txeopvc11                          : IN STD_LOGIC := '0';
      txerrvc0                           : IN STD_LOGIC := '0';
      txerrvc1                           : IN STD_LOGIC := '0';
      txsopvc00                          : IN STD_LOGIC := '0';
      txsopvc01                          : IN STD_LOGIC := '0';
      txsopvc10                          : IN STD_LOGIC := '0';
      txsopvc11                          : IN STD_LOGIC := '0';
      txvalidvc0                         : IN STD_LOGIC := '0';
      txvalidvc1                         : IN STD_LOGIC := '0';
      bistdonearcv0                      : OUT STD_LOGIC;
      bistdonearcv1                      : OUT STD_LOGIC;
      bistdonearpl                       : OUT STD_LOGIC;
      bistdonebrcv0                      : OUT STD_LOGIC;
      bistdonebrcv1                      : OUT STD_LOGIC;
      bistdonebrpl                       : OUT STD_LOGIC;
      bistpassrcv0                       : OUT STD_LOGIC;
      bistpassrcv1                       : OUT STD_LOGIC;
      bistpassrpl                        : OUT STD_LOGIC;
      bistscanoutrcv0                    : OUT STD_LOGIC;
      bistscanoutrcv1                    : OUT STD_LOGIC;
      bistscanoutrpl                     : OUT STD_LOGIC;
      clrrxpath                          : OUT STD_LOGIC;
      coreclkout                         : OUT STD_LOGIC;
      dataenablen                        : OUT STD_LOGIC;
      derrcorextrcv0                     : OUT STD_LOGIC;
      derrcorextrcv1                     : OUT STD_LOGIC;
      derrcorextrpl                      : OUT STD_LOGIC;
      derrrpl                            : OUT STD_LOGIC;
      dlackphypm                         : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      dlackrequpfc                       : OUT STD_LOGIC;
      dlacksndupfc                       : OUT STD_LOGIC;
      dlcurrentdeemp                     : OUT STD_LOGIC;
      dlcurrentspeed                     : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
      dldllreq                           : OUT STD_LOGIC;
      dlerrdll                           : OUT STD_LOGIC_VECTOR(5 - 1 DOWNTO 0);
      dlerrphy                           : OUT STD_LOGIC;
      dllinkautobdwstatus                : OUT STD_LOGIC;
      dllinkbdwmngstatus                 : OUT STD_LOGIC;
      dlltssm                            : OUT STD_LOGIC_VECTOR(5 - 1 DOWNTO 0);
      dlrpbufemp                         : OUT STD_LOGIC;
      dlrstentercompbit                  : OUT STD_LOGIC;
      dlrsttxmarginfield                 : OUT STD_LOGIC;
      dlrxtyppm                          : OUT STD_LOGIC_VECTOR(3 - 1 DOWNTO 0);
      dlrxvalpm                          : OUT STD_LOGIC;
      dltxackpm                          : OUT STD_LOGIC;
      dlup                               : OUT STD_LOGIC;
      dlupexit                           : OUT STD_LOGIC;
      dlvcstatus                         : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      dprioout                           : OUT STD_LOGIC;
      dpriostate                         : OUT STD_LOGIC_VECTOR(3 - 1 DOWNTO 0);
      eidleinfersel                      : OUT STD_LOGIC_VECTOR(24 - 1 DOWNTO 0);
      ev128ns                            : OUT STD_LOGIC;
      ev1us                              : OUT STD_LOGIC;
      extraclkout						 : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);					
      extraout                           : OUT STD_LOGIC_VECTOR(15 - 1 DOWNTO 0);
      gen2rate                           : OUT STD_LOGIC;
      gen2rategnd                        : OUT STD_LOGIC;
      hotrstexit                         : OUT STD_LOGIC;
      intstatus                          : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      l2exit                             : OUT STD_LOGIC;
      laneact                            : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      linkup                             : OUT STD_LOGIC;
      lmiack                             : OUT STD_LOGIC;
      lmidout                            : OUT STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
      ltssml0state                       : OUT STD_LOGIC;
      mramregscanout                     : OUT STD_LOGIC;
      powerdown                          : OUT STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
      resetstatus                        : OUT STD_LOGIC;
      rxbardecvc0                        : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxbardecvc1                        : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxbevc00                           : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxbevc01                           : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxbevc10                           : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxbevc11                           : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxdatavc00                         : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      rxdatavc01                         : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      rxdatavc10                         : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      rxdatavc11                         : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      rxeopvc00                          : OUT STD_LOGIC;
      rxeopvc01                          : OUT STD_LOGIC;
      rxeopvc10                          : OUT STD_LOGIC;
      rxeopvc11                          : OUT STD_LOGIC;
      rxerrvc0                           : OUT STD_LOGIC;
      rxerrvc1                           : OUT STD_LOGIC;
      rxfifoemptyvc0                     : OUT STD_LOGIC;
      rxfifoemptyvc1                     : OUT STD_LOGIC;
      rxfifofullvc0                      : OUT STD_LOGIC;
      rxfifofullvc1                      : OUT STD_LOGIC;
      rxfifordpvc0                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      rxfifordpvc1                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      rxfifowrpvc0                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      rxfifowrpvc1                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      rxpolarity                         : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      rxsopvc00                          : OUT STD_LOGIC;
      rxsopvc01                          : OUT STD_LOGIC;
      rxsopvc10                          : OUT STD_LOGIC;
      rxsopvc11                          : OUT STD_LOGIC;
      rxvalidvc0                         : OUT STD_LOGIC;
      rxvalidvc1                         : OUT STD_LOGIC;
      r2cerr0ext						 : OUT STD_LOGIC;
      serrout                            : OUT STD_LOGIC;
      successspeednegoint				 : OUT STD_LOGIC;
      swdnwake                           : OUT STD_LOGIC;
      swuphotrst                         : OUT STD_LOGIC;
      testout                            : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      tlappintaack                       : OUT STD_LOGIC;
      tlappmsiack                        : OUT STD_LOGIC;
      tlcfgadd                           : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      tlcfgctl                           : OUT STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
      tlcfgctlwr                         : OUT STD_LOGIC;
      tlcfgsts                           : OUT STD_LOGIC_VECTOR(53 - 1 DOWNTO 0);
      tlcfgstswr                         : OUT STD_LOGIC;
      tlpmetosr                          : OUT STD_LOGIC;
      txcompl                            : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      txcredvc0                          : OUT STD_LOGIC_VECTOR(36 - 1 DOWNTO 0);
      txcredvc1                          : OUT STD_LOGIC_VECTOR(36 - 1 DOWNTO 0);
      txdata                             : OUT STD_LOGIC_VECTOR(64 - 1 DOWNTO 0);
      txdatak                            : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      txdeemph                           : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      txdetectrx                         : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      txelecidle                         : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      txfifoemptyvc0                     : OUT STD_LOGIC;
      txfifoemptyvc1                     : OUT STD_LOGIC;
      txfifofullvc0                      : OUT STD_LOGIC;
      txfifofullvc1                      : OUT STD_LOGIC;
      txfifordpvc0                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      txfifordpvc1                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      txfifowrpvc0                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      txfifowrpvc1                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
      txmargin                           : OUT STD_LOGIC_VECTOR(24 - 1 DOWNTO 0);
      txreadyvc0                         : OUT STD_LOGIC;
      txreadyvc1                         : OUT STD_LOGIC;
      wakeoen                            : OUT STD_LOGIC
   );
END COMPONENT;

end arriaii_pcie_hip_components;

package body ARRIAII_PCIE_HIP_COMPONENTS is




function str2bin (s : string) return std_logic_vector is
variable len : integer := s'length;
variable result : std_logic_vector(len -1 DOWNTO 0) := (OTHERS => '0');
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

end ARRIAII_PCIE_HIP_COMPONENTS;
