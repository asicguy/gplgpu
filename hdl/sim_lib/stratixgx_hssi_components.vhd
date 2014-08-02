


library IEEE, stratixgx_gxb;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use stratixgx_gxb.hssi_pack.all;

package STRATIXGX_HSSI_COMPONENTS is

-- Beginning of testing section 
-- these components are added for testing

component stratixgx_comp_fifo
   GENERIC (
     use_rate_match_fifo     : string  := "true";
     rate_matching_fifo_mode : string  := "xaui";
     use_channel_align       : string  := "true";
    for_engineering_sample_device    : string := "true"; -- new in 3.0 SP2 
     channel_num             : integer := 0
     );
   PORT (
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      datainpre               : IN std_logic_vector(9 DOWNTO 0);   
      reset                   : IN std_logic;   
      errdetectin             : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      errdetectinpre          : IN std_logic;   
      syncstatusinpre         : IN std_logic;   
      disperrinpre            : IN std_logic;   
      patterndetectinpre      : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      re                      : IN std_logic;   
      we                      : IN std_logic;   
      fifordin                : IN std_logic;   
      disablefifordin         : IN std_logic;   
      disablefifowrin         : IN std_logic;   
      alignstatus             : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      errdetectout            : OUT std_logic;   
      syncstatus              : OUT std_logic;   
      disperr                 : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      codevalid               : OUT std_logic;   
      fifofull                : OUT std_logic;   
      fifoalmostful           : OUT std_logic;   
      fifoempty               : OUT std_logic;   
      fifoalmostempty         : OUT std_logic;   
      disablefifordout        : OUT std_logic;   
      disablefifowrout        : OUT std_logic;   
      fifordout               : OUT std_logic);   
end component;

component stratixgx_deskew_fifo
  PORT (
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      errdetectin             : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      writeclock              : IN std_logic;   
      readclock               : IN std_logic;   
      adetectdeskew           : OUT std_logic;   
      fiforesetrd             : IN std_logic;   
      enabledeskew            : IN std_logic;   
      reset                   : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      dataoutpre              : OUT std_logic_vector(9 DOWNTO 0);   
      errdetect               : OUT std_logic;   
      syncstatus              : OUT std_logic;   
      disperr                 : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      errdetectpre            : OUT std_logic;   
      syncstatuspre           : OUT std_logic;   
      disperrpre              : OUT std_logic;   
      patterndetectpre        : OUT std_logic;   
      rdalign                 : OUT std_logic);   
END component;

component stratixgx_rx_core
   GENERIC (
      channel_width                  :  integer := 10;    
      use_double_data_mode           :  string  := "false";    
      use_channel_align              :  string  := "false";    
      use_8b_10b_mode                :  string  := "true";    
      synchronization_mode           :  string  := "none";
      align_pattern            	: string := "0000000101111100");
   PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      errdetectin             : IN std_logic;   
      patterndetectin         : IN std_logic;   
      decdatavalid            : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      post8b10b               : IN std_logic_vector(9 DOWNTO 0);   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      xgmctrlin               : IN std_logic;   
      ctrldetectin            : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disparityerrin          : IN std_logic;   
      syncstatus              : OUT std_logic_vector(1 DOWNTO 0);   
      errdetect               : OUT std_logic_vector(1 DOWNTO 0);   
      ctrldetect              : OUT std_logic_vector(1 DOWNTO 0);   
      disparityerr            : OUT std_logic_vector(1 DOWNTO 0);   
      patterndetect           : OUT std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(19 DOWNTO 0);   
      a1a2sizeout             : OUT std_logic_vector(1 DOWNTO 0);   
      clkout                  : OUT std_logic);   
END component;

component stratixgx_tx_core
   GENERIC (
    use_double_data_mode           :  string := "false";    
    use_fifo_mode                  :  string := "true";    
    transmit_protocol              :  string := "none";
    channel_width                  :  integer := 10;
    KCHAR                          :  std_logic := '0';    
    ECHAR                          :  std_logic := '0');
   PORT (
      reset                   : IN std_logic;   
      datain                  : IN std_logic_vector(19 DOWNTO 0);   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      ctrlena                 : IN std_logic_vector(1 DOWNTO 0);   
      forcedisp               : IN std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      forcedispout            : OUT std_logic;   
      ctrlenaout              : OUT std_logic;   
      rdenasync               : OUT std_logic;   
      xgmctrlena              : OUT std_logic;   
      xgmdataout              : OUT std_logic_vector(7 DOWNTO 0);   
      pre8b10bdataout         : OUT std_logic_vector(7 DOWNTO 0));   
END component;

component stratixgx_8b10b_encoder
   GENERIC (
      transmit_protocol              :  string := "none";    
      use_8b_10b_mode                :  string := "true";    
      force_disparity_mode           :  string := "false");
   PORT (
      clk                     : IN std_logic;   
      reset                   : IN std_logic;   
      xgmctrl                 : IN std_logic;   
      kin                     : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      datain                  : IN std_logic_vector(7 DOWNTO 0);   
      forcedisparity          : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      parafbkdataout          : OUT std_logic_vector(9 DOWNTO 0));   
END component;

component stratixgx_8b10b_decoder
  PORT (
    clk                     : IN std_logic;   
    reset                   : IN std_logic;   
    errdetectin             : IN std_logic;   
    syncstatusin            : IN std_logic;   
    disperrin               : IN std_logic;   
    patterndetectin         : IN std_logic;   
    datainvalid             : IN std_logic;   
    datain                  : IN std_logic_vector(9 DOWNTO 0);   
    valid                   : OUT std_logic;   
    dataout                 : OUT std_logic_vector(7 DOWNTO 0);   
    tenBdata                : OUT std_logic_vector(9 DOWNTO 0);   
    errdetect               : OUT std_logic;   
    syncstatus              : OUT std_logic;   
    disperr                 : OUT std_logic;   
    patterndetect           : OUT std_logic;   
    kout                    : OUT std_logic;   
    rderr                   : OUT std_logic;   
    decdatavalid            : OUT std_logic;   
    xgmdatavalid            : OUT std_logic;   
    xgmrunningdisp          : OUT std_logic;   
    xgmctrldet              : OUT std_logic;   
    xgmdataout              : OUT std_logic_vector(7 DOWNTO 0));   
end component;

component stratixgx_hssi_rx_serdes 
  generic (
    channel_width	: integer := 10;
    rlv_length		: integer := 1;
    run_length_enable	: String := "false";
    cruclk_period	: integer :=5000; 
    cruclk_multiplier	: integer :=4; 
    use_cruclk_divider	: String := "false";
    use_double_data_mode	: String  := "false";
    tipd_0					: VitalDelayType01 := DefpropDelay01
    );
  port (
    datain		: in std_logic := '0';
    cruclk		: in std_logic := '0';
    areset		: in std_logic := '0';
    feedback		: in std_logic := '0';
    fbkcntl		: in std_logic := '0';
    dataout		: out std_logic_vector(9 downto 0);
    clkout		: out std_logic;
    rlv			: out std_logic;
    lock		: out std_logic;
    freqlock		: out std_logic;
    signaldetect: out std_logic
    );
end component;

component stratixgx_hssi_tx_serdes 
  generic (
    channel_width       : integer := 10
    );
  port (
    clk                 : in std_logic := '0';
    clk1                : in std_logic := '0';
    datain              : in std_logic_vector(9 downto 0) := "0000000000";
    serialdatain	: in std_logic := '0';
    srlpbk		: in std_logic := '0';
    areset              : in std_logic := '0';
    dataout             : out std_logic
    );

end component;

component stratixgx_hssi_word_aligner 
  generic	(
    channel_width       : integer := 10;
    align_pattern_length: integer := 10;
    align_pattern 	: string := "0000000101111100";
    synchronization_mode: string := "XAUI";
    use_8b_10b_mode	: string := "true";
    use_auto_bit_slip   : string := "true"
    );
  port	(
    datain		: in std_logic_vector(9 downto 0) := "0000000000"; 
    clk			: in std_logic := '0';
    softreset		: in std_logic := '0'; 
    enacdet		: in std_logic := '0'; 
    bitslip		: in std_logic := '0'; 
    a1a2size		: in std_logic := '0'; 
    aligneddata		: out std_logic_vector(9 downto 0); 
    aligneddatapre	: out std_logic_vector(9 downto 0); 
    invalidcode		: out std_logic;
    invalidcodepre	: out std_logic;
    syncstatus		: out std_logic;
    syncstatusdeskew	: out std_logic;
    disperr		: out std_logic;
    disperrpre		: out std_logic;
    patterndetect	: out std_logic;
    patterndetectpre	: out std_logic 
    );
end component;

component stratixgx_xgm_rx_sm 
   port (
     rxdatain	    : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";   
     rxctrl         : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxrunningdisp  : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxdatavalid    : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxclk          : IN std_logic := '0';   
     resetall       : IN std_logic := '0';   
     rxdataout      : OUT std_logic_vector(31 DOWNTO 0);   
     rxctrlout      : OUT std_logic_vector(3 DOWNTO 0)
     );   
end component;

component stratixgx_xgm_tx_sm 
   port (
			txdatain			: IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      	txctrl         : IN std_logic_vector(3 DOWNTO 0) := "0000";
      	rdenablesync   : IN std_logic := '0';   
      	txclk          : IN std_logic := '0';   
      	resetall       : IN std_logic := '0';   
      	txdataout      : OUT std_logic_vector(31 DOWNTO 0);   
      	txctrlout      : OUT std_logic_vector(3 DOWNTO 0));   
end component;

component stratixgx_xgm_dskw_sm 
   port (
      	resetall       : IN std_logic := '0';   
	      adet           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
	      syncstatus     : IN std_logic_vector(3 DOWNTO 0) := "0000";   
	      rdalign        : IN std_logic_vector(3 DOWNTO 0) := "0000";   
	      recovclk       : IN std_logic := '0';   
	      alignstatus    : OUT std_logic;   
	      enabledeskew   : OUT std_logic;   
	      fiforesetrd    : OUT std_logic);   
end component;

-- End of testing section

component stratixgx_hssi_receiver 
  generic (
    channel_num                 : integer := 1;
    channel_width		: integer := 20;
    deserialization_factor	: integer := 10;
    run_length			: integer := 4;
    run_length_enable		: String  := "false";
    use_8b_10b_mode		: String  := "false";
    use_double_data_mode	: String  := "false";
    use_rate_match_fifo		: String  := "false";
    rate_matching_fifo_mode	: String  := "none";
    use_channel_align		: String  := "false";
    use_symbol_align		: String  := "true";
    use_auto_bit_slip		: String  := "false";
    use_parallel_feedback       : String  := "false";
    use_post8b10b_feedback      : String  := "false";
    send_reverse_parallel_feedback : String := "false";
    synchronization_mode	: String  := "none";
    align_pattern		: String  := "0000000000000000";
    align_pattern_length	: integer  := 7;
    infiniband_invalid_code	: integer  := 0;
    disparity_mode		: String  := "false";
    clk_out_mode_reference	: String  := "false";
    cruclk_period		: integer := 5000;
    cruclk_multiplier 		: integer := 4;
    use_cruclk_divider		: String  := "false";
    use_self_test_mode          : String  := "false";
    self_test_mode          : integer  := 0;
    use_equalizer_ctrl_signal   : String  := "false";
    enable_dc_coupling          : String  := "false";
    equalizer_ctrl_setting      : integer := 20;
    signal_threshold_select     : integer := 2;
    vco_bypass                  : String  := "false";
    force_signal_detect         : String  := "false";
    bandwidth_type         : String  := "low";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    TimingChecksOn		: Boolean := True;
    MsgOn			: Boolean := DefGlitchMsgOn;
    XOn				: Boolean := DefGlitchXOn;
    MsgOnChecks			: Boolean := DefMsgOnChecks;
    XOnChecks			: Boolean := DefXOnChecks;
    InstancePath		: String  := "*";
    tipd_datain			: VitalDelayType01 := DefpropDelay01;
    tipd_cruclk			: VitalDelayType01 := DefpropDelay01;
    tipd_pllclk			: VitalDelayType01 := DefpropDelay01;
    tipd_masterclk		: VitalDelayType01 := DefpropDelay01;
    tipd_coreclk		: VitalDelayType01 := DefpropDelay01;
    tipd_softreset		: VitalDelayType01 := DefpropDelay01;
    tipd_serialfdbk		: VitalDelayType01 := DefpropDelay01;
    tipd_parallelfdbk           : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
    tipd_post8b10b              : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
    tipd_slpbk                  : VitalDelayType01 := DefpropDelay01;
    tipd_bitslip		: VitalDelayType01 := DefpropDelay01;
    tipd_a1a2size		: VitalDelayType01 := DefpropDelay01;
    tipd_enacdet		: VitalDelayType01 := DefpropDelay01;
    tipd_we			: VitalDelayType01 := DefpropDelay01;
    tipd_re			: VitalDelayType01 := DefpropDelay01;
    tipd_alignstatus		: VitalDelayType01 := DefpropDelay01;
    tipd_disablefifordin	: VitalDelayType01 := DefpropDelay01;
    tipd_disablefifowrin	: VitalDelayType01 := DefpropDelay01;
    tipd_fifordin		: VitalDelayType01 := DefpropDelay01;
    tipd_enabledeskew		: VitalDelayType01 := DefpropDelay01;
    tipd_fiforesetrd		: VitalDelayType01 := DefpropDelay01;
    tipd_xgmdatain              : VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
    tipd_xgmctrlin		: VitalDelayType01 := DefpropDelay01;
    tsetup_re_coreclk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
    thold_re_coreclk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
    tpd_coreclk_dataout_posedge : VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_syncstatus_posedge      : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_patterndetect_posedge   : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_ctrldetect_posedge      : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_errdetect_posedge       : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_disperr_posedge         : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_a1a2sizeout_posedge     : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_fifofull_posedge        : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoempty_posedge       : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoalmostfull_posedge  : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoalmostempty_posedge : VitalDelayType01 := DefPropDelay01
    );

  port (
    datain		: in std_logic := '0';
    cruclk		: in std_logic := '0';
    pllclk		: in std_logic := '0';
    masterclk		: in std_logic := '0';
    coreclk		: in std_logic := '0';
    softreset		: in std_logic := '0';
    serialfdbk		: in std_logic := '0';
    parallelfdbk	: in std_logic_vector(9 downto 0) := "0000000000";
    post8b10b		: in std_logic_vector(9 downto 0) := "0000000000";
    slpbk		: in std_logic := '0';
    bitslip		: in std_logic := '0';
    enacdet		: in std_logic := '0';
    we			: in std_logic := '0';
    re			: in std_logic := '0';
    alignstatus		: in std_logic := '0';
    disablefifordin	: in std_logic := '0';
    disablefifowrin	: in std_logic := '0';
    fifordin		: in std_logic := '0';
    enabledeskew	: in std_logic := '0';
    fiforesetrd		: in std_logic := '0';
    xgmdatain		: in std_logic_vector(7 downto 0) := "00000000";
    xgmctrlin		: in std_logic := '0';
    devclrn		: in std_logic := '1';
    devpor		: in std_logic := '1';
    analogreset		: in std_logic := '0';
    a1a2size		: in std_logic := '0';
    locktorefclk	: in std_logic := '0';
    locktodata		: in std_logic := '0';
    equalizerctrl	: in std_logic_vector(2 downto 0) := "000";
    syncstatus		: out std_logic_vector(1 downto 0);
    patterndetect	: out std_logic_vector(1 downto 0);
    ctrldetect		: out std_logic_vector(1 downto 0);
    errdetect		: out std_logic_vector(1 downto 0);
    disperr		: out std_logic_vector(1 downto 0);
    syncstatusdeskew	: out std_logic;
    adetectdeskew	: out std_logic;
    rdalign		: out std_logic;
    dataout		: out std_logic_vector(19 downto 0);
    xgmdataout		: out std_logic_vector(7 downto 0);
    xgmctrldet		: out std_logic;
    xgmrunningdisp	: out std_logic;
    xgmdatavalid	: out std_logic;
    fifofull		: out std_logic;
    fifoalmostfull	: out std_logic;
    fifoempty		: out std_logic;
    fifoalmostempty	: out std_logic;
    disablefifordout	: out std_logic;
    disablefifowrout	: out std_logic;
    fifordout		: out std_logic;
    signaldetect	: out std_logic;
    lock		: out std_logic;
    freqlock		: out std_logic;
    rlv			: out std_logic;
    clkout		: out std_logic;
    recovclkout		: out std_logic;
    bisterr             : out std_logic := '0';
    bistdone            : out std_logic := '1';
    a1a2sizeout         : out std_logic_vector(1 downto 0) 
    );
end component;

component stratixgx_hssi_transmitter 
  generic (
    channel_num		: integer := 1;
    channel_width	: integer := 20;
    serialization_factor: integer := 10;
    use_8b_10b_mode	: String  := "false";
    use_double_data_mode: String  := "false";
    use_fifo_mode	: String  := "false";
    use_reverse_parallel_feedback : String := "false";
    force_disparity_mode: String  := "false";
    transmit_protocol	: String  := "none";
    use_vod_ctrl_signal : String := "false";
    use_preemphasis_ctrl_signal : String := "false";
    use_self_test_mode          : String := "false";
    self_test_mode          : integer  := 0;
    vod_ctrl_setting            : integer := 4;  
    preemphasis_ctrl_setting    : integer := 5;
    termination                 : integer := 0;
    TimingChecksOn	: Boolean := True;
    MsgOn		: Boolean := DefGlitchMsgOn;
    XOn			: Boolean := DefGlitchXOn;
    MsgOnChecks		: Boolean := DefMsgOnChecks;
    XOnChecks		: Boolean := DefXOnChecks;
    InstancePath	: String  := "*";
    tipd_datain         : VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
    tipd_pllclk		: VitalDelayType01 := DefpropDelay01;
    tipd_fastpllclk	: VitalDelayType01 := DefpropDelay01;
    tipd_coreclk	: VitalDelayType01 := DefpropDelay01;
    tipd_softreset	: VitalDelayType01 := DefpropDelay01;
    tipd_ctrlenable     : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tipd_forcedisparity : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tipd_serialdatain	: VitalDelayType01 := DefpropDelay01;
    tipd_xgmdatain	: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
    tipd_xgmctrl	: VitalDelayType01 := DefpropDelay01;
    tipd_srlpbk		: VitalDelayType01 := DefpropDelay01;
    tsetup_datain_coreclk_noedge_posedge        : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_datain_coreclk_noedge_posedge         : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_ctrlenable_coreclk_noedge_posedge    : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_ctrlenable_coreclk_noedge_posedge     : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_forcedisparity_coreclk_noedge_posedge: VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_forcedisparity_coreclk_noedge_posedge : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst)    
    );
  port (
    datain      : in std_logic_vector(19 downto 0);
    pllclk	: in std_logic := '0';
    fastpllclk	: in std_logic := '0';
    coreclk	: in std_logic := '0';
    softreset	: in std_logic := '0';
    ctrlenable	: in std_logic_vector(1 downto 0) := "00";
    forcedisparity : in std_logic_vector(1 downto 0) := "00";
    serialdatain   : in std_logic := '0';
    xgmdatain	: in std_logic_vector(7 downto 0) := "00000000";
    xgmctrl	: in std_logic := '0';
    srlpbk      : in std_logic := '0';
    devclrn	: in std_logic := '1';
    devpor	: in std_logic := '1';
    analogreset	: in std_logic := '0'; 
    vodctrl	: in std_logic_vector(2 downto 0) := "000";
    preemphasisctrl : in std_logic_vector(2 downto 0) := "000";
    dataout	: out std_logic;
    xgmdataout	: out std_logic_vector(7 downto 0);
    xgmctrlenable : out std_logic;
    rdenablesync  : out std_logic;
    parallelfdbkdata : out std_logic_vector(9 downto 0);
    pre8b10bdata     : out std_logic_vector(9 downto 0)
    );
end component;

component stratixgx_xgm_interface
  generic (
    use_continuous_calibration_mode : String := "false";
    mode_is_xaui : String := "false";
    rx_ppm_setting_0 : integer := 0;
    rx_ppm_setting_1 : integer := 0;
    digital_test_output_select          : integer := 0;
    analog_test_output_signal_select    : integer := 0;
    analog_test_output_channel_select   : integer := 0;
    use_rx_calibration_status           : String  := "false";
    use_global_serial_loopback          : String  := "false";
    rx_calibration_test_write_value     : integer := 0;
    enable_rx_calibration_test_write    : String  := "false";
    tx_calibration_test_write_value     : integer := 0;
    enable_tx_calibration_test_write    : String  := "false";
    TimingChecksOn      : Boolean := True;
    MsgOn               : Boolean := DefGlitchMsgOn;
    XOn                 : Boolean := DefGlitchXOn;
    MsgOnChecks		: Boolean := DefMsgOnChecks;
    XOnChecks		: Boolean := DefXOnChecks;
    InstancePath	: String  := "*";
    tipd_txdatain       : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
    tipd_txctrl		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rdenablesync	: VitalDelayType01 := DefpropDelay01;
    tipd_txclk		: VitalDelayType01 := DefpropDelay01;
    tipd_rxdatain       : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxctrl		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxclk		: VitalDelayType01 := DefpropDelay01;
    tipd_rxrunningdisp  : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxdatavalid	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_resetall	: VitalDelayType01 := DefpropDelay01;
    tipd_adet		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_syncstatus	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rdalign	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_recovclk	: VitalDelayType01 := DefpropDelay01
    );

    PORT (
      txdatain                : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      txctrl                  : IN std_logic_vector(3 DOWNTO 0) := "0000";
      rdenablesync            : IN std_logic := '0';
      txclk                   : IN std_logic := '0';   
      rxdatain                : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      rxctrl                  : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxrunningdisp           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxdatavalid             : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxclk                   : IN std_logic := '0';   
      resetall                : IN std_logic := '0';   
      adet                    : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      syncstatus              : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rdalign                 : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      recovclk                : IN std_logic := '0';   
      devpor                  : IN std_logic := '0';   
      devclrn                 : IN std_logic := '0';   
      txdataout               : OUT std_logic_vector(31 DOWNTO 0);   
      txctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
      rxdataout               : OUT std_logic_vector(31 DOWNTO 0);   
      rxctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
      resetout                : OUT std_logic;   
      alignstatus             : OUT std_logic;   
      enabledeskew            : OUT std_logic;   
      fiforesetrd             : OUT std_logic;
      -- NEW MDIO/PE ONLY PORTS
      mdioclk                 : IN std_logic := '0';
      mdiodisable             : IN std_logic := '0';
      mdioin                  : IN std_logic := '0';
      rxppmselect             : IN std_logic := '0';
      scanclk                 : IN std_logic := '0';
      scanin                  : IN std_logic := '0';
      scanmode                : IN std_logic := '0';
      scanshift               : IN std_logic := '0';
      -- NEW MDIO/PE ONLY PORTS
      calibrationstatus       : OUT std_logic_vector(4 DOWNTO 0);
      digitalsmtest           : OUT std_logic_vector(3 DOWNTO 0);
      mdiooe                  : OUT std_logic;
      mdioout                 : OUT std_logic;
      scanout                 : OUT std_logic;
      test                    : OUT std_logic;
      -- RESET PORTS
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      pllreset                : IN std_logic := '0';   
      pllenable               : IN std_logic := '1';   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic
    ); 
end component;


end stratixgx_hssi_components;
