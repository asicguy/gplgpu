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
use work.cycloneii_atom_pack.all;

package cycloneii_components is


--
-- cycloneii_ram_block
--

COMPONENT cycloneii_ram_block
    GENERIC (
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
        data_interleave_width_in_bits  :  INTEGER := 1;    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        port_a_logical_ram_depth       :  INTEGER := 0;    
        port_a_logical_ram_width       :  INTEGER := 0;    
        port_a_first_address           :  INTEGER := 0;    
        port_a_last_address            :  INTEGER := 0;    
        port_a_first_bit_number        :  INTEGER := 0;    
        port_a_data_in_clear           :  STRING := "none";    
        port_a_address_clear           :  STRING := "none";    
        port_a_write_enable_clear      :  STRING := "none";    
        port_a_data_out_clear          :  STRING := "none";    
        port_a_byte_enable_clear       :  STRING := "none";    
        port_a_data_in_clock           :  STRING := "clock0";    
        port_a_address_clock           :  STRING := "clock0";    
        port_a_write_enable_clock      :  STRING := "clock0";    
        port_a_byte_enable_clock       :  STRING := "clock0";    
        port_a_data_out_clock          :  STRING := "none";    
        port_a_data_width              :  INTEGER := 1;    
        port_a_address_width           :  INTEGER := 1;    
        port_a_byte_enable_mask_width  :  INTEGER := 1;    
        port_b_logical_ram_depth       :  INTEGER := 0;    
        port_b_logical_ram_width       :  INTEGER := 0;    
        port_b_first_address           :  INTEGER := 0;    
        port_b_last_address            :  INTEGER := 0;    
        port_b_first_bit_number        :  INTEGER := 0;    
        port_b_data_in_clear           :  STRING := "none";    
        port_b_address_clear           :  STRING := "none";    
        port_b_read_enable_write_enable_clear: STRING := "none";    
        port_b_byte_enable_clear       :  STRING := "none";    
        port_b_data_out_clear          :  STRING := "none";    
        port_b_data_in_clock           :  STRING := "clock1";    
        port_b_address_clock           :  STRING := "clock1";    
        port_b_read_enable_write_enable_clock: STRING := "clock1";    
        port_b_byte_enable_clock       :  STRING := "clock1";    
        port_b_data_out_clock          :  STRING := "none";    
        port_b_data_width              :  INTEGER := 1;    
        port_b_address_width           :  INTEGER := 1;    
        port_b_byte_enable_mask_width  :  INTEGER := 1;    
        power_up_uninitialized         :  STRING := "false";  
        port_b_disable_ce_on_output_registers : STRING := "off";
        port_b_disable_ce_on_input_registers : STRING := "off";
        port_b_byte_size : INTEGER := 0;
        port_a_disable_ce_on_output_registers : STRING := "off";
        port_a_disable_ce_on_input_registers : STRING := "off";
        port_a_byte_size : INTEGER := 0;  
        safe_write : STRING := "err_on_2clk";  
        init_file_restructured : STRING := "unused";  
        lpm_type                  : string := "cycloneii_ram_block";
        lpm_hint                  : string := "true";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        connectivity_checking     : string := "off"
        );    
    PORT (
        portadatain             : IN STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portaaddr               : IN STD_LOGIC_VECTOR(port_a_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portawe                 : IN STD_LOGIC := '0';   
        portbdatain             : IN STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portbaddr               : IN STD_LOGIC_VECTOR(port_b_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portbrewe               : IN STD_LOGIC := '0';   
        clk0                    : IN STD_LOGIC := '0';   
        clk1                    : IN STD_LOGIC := '0';   
        ena0                    : IN STD_LOGIC := '1';   
        ena1                    : IN STD_LOGIC := '1';   
        clr0                    : IN STD_LOGIC := '0';   
        clr1                    : IN STD_LOGIC := '0';   
        portabyteenamasks       : IN STD_LOGIC_VECTOR(port_a_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        portbbyteenamasks       : IN STD_LOGIC_VECTOR(port_b_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        devclrn                 : IN STD_LOGIC := '1';   
        devpor                  : IN STD_LOGIC := '1';   
         portaaddrstall : IN STD_LOGIC := '0';
         portbaddrstall : IN STD_LOGIC := '0';
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );
END COMPONENT;

--
-- cycloneii_jtag
--

COMPONENT cycloneii_jtag
    generic (
        lpm_type : string := "cycloneii_jtag"
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
-- cycloneii_crcblock
--

COMPONENT cycloneii_crcblock
    generic  (
        oscillator_divider : integer := 1;
        lpm_type : string := "cycloneii_crcblock"
        );	
    port (
        clk : in std_logic := '0'; 
        shiftnld : in std_logic := '0'; 
           ldsrc : in std_logic := '0'; 
        crcerror : out std_logic; 
        regout : out std_logic
        ); 
END COMPONENT;

--
-- cycloneii_asmiblock
--

COMPONENT cycloneii_asmiblock
	 generic (
					lpm_type	: string := "cycloneii_asmiblock"
				);	
    port (dclkin : in std_logic; 
    		 scein : in std_logic; 
    		 sdoin : in std_logic; 
    		 oe : in std_logic; 
          data0out: out std_logic);
END COMPONENT;

--
-- cycloneii_pll
--

COMPONENT cycloneii_pll
    GENERIC (
        operation_mode              : string := "normal";
        pll_type                    : string := "auto";  -- EGPP/FAST/AUTO
        compensate_clock            : string := "clk0";
        feedback_source             : string := "clk0";
        qualify_conf_done           : string := "off";
        test_input_comp_delay       : integer := 0;
        test_feedback_comp_delay    : integer := 0;
        inclk0_input_frequency      : integer := 10000;
        inclk1_input_frequency      : integer := 10000;
        gate_lock_signal            : string := "no";
        gate_lock_counter           : integer := 1;
        self_reset_on_gated_loss_lock : string := "off";
        valid_lock_multiplier       : integer := 1;
        invalid_lock_multiplier     : integer := 5;
        sim_gate_lock_device_behavior : string := "off";
        switch_over_type            : string := "manual";
        switch_over_on_lossclk      : string := "off";
        switch_over_on_gated_lock   : string := "off";
        switch_over_counter         : integer := 1;
        enable_switch_over_counter  : string := "on";
        bandwidth                   : integer := 0;
        bandwidth_type              : string := "auto";
        down_spread                 : string := "0.0";
        spread_frequency            : integer := 0;
        clk0_output_frequency       : integer := 0;
        clk0_multiply_by            : integer := 1;
        clk0_divide_by              : integer := 1;
        clk0_phase_shift            : string := "0";
        clk0_duty_cycle             : integer := 50;
        clk1_output_frequency       : integer := 0;
        clk1_multiply_by            : integer := 1;
        clk1_divide_by              : integer := 1;
        clk1_phase_shift            : string := "0";
        clk1_duty_cycle             : integer := 50;
        clk2_output_frequency       : integer := 0;
        clk2_multiply_by            : integer := 1;
        clk2_divide_by              : integer := 1;
        clk2_phase_shift            : string := "0";
        clk2_duty_cycle             : integer := 50;
        clk3_output_frequency       : integer := 0;
        clk3_multiply_by            : integer := 1;
        clk3_divide_by              : integer := 1;
        clk3_phase_shift            : string := "0";
        clk3_duty_cycle             : integer := 50;
        clk4_output_frequency       : integer := 0;
        clk4_multiply_by            : integer := 1;
        clk4_divide_by              : integer := 1;
        clk4_phase_shift            : string := "0";
        clk4_duty_cycle             : integer := 50;
        clk5_output_frequency       : integer := 0;
        clk5_multiply_by            : integer := 1;
        clk5_divide_by              : integer := 1;
        clk5_phase_shift            : string := "0";
        clk5_duty_cycle             : integer := 50;
        pfd_min                     : integer := 0;
        pfd_max                     : integer := 0;
        vco_min                     : integer := 0;
        vco_max                     : integer := 0;
        vco_center                  : integer := 0;
        m_initial                   : integer := 1;
        m                           : integer := 0;
        n                           : integer := 1;
        m2                          : integer := 1;
        n2                          : integer := 1;
        ss                          : integer := 0;
        c0_high                     : integer := 1;
        c0_low                      : integer := 1;
        c0_initial                  : integer := 1; 
        c0_mode                     : string := "bypass";
        c0_ph                       : integer := 0;
        c1_high                     : integer := 1;
        c1_low                      : integer := 1;
        c1_initial                  : integer := 1;
        c1_mode                     : string := "bypass";
        c1_ph                       : integer := 0;
        c2_high                     : integer := 1;
        c2_low                      : integer := 1;
        c2_initial                  : integer := 1;
        c2_mode                     : string := "bypass";
        c2_ph                       : integer := 0;
        c3_high                     : integer := 1;
        c3_low                      : integer := 1;
        c3_initial                  : integer := 1;
        c3_mode                     : string := "bypass";
        c3_ph                       : integer := 0;
        c4_high                     : integer := 1;
        c4_low                      : integer := 1;
        c4_initial                  : integer := 1;
        c4_mode                     : string := "bypass";
        c4_ph                       : integer := 0;
        c5_high                     : integer := 1;
        c5_low                      : integer := 1;
        c5_initial                  : integer := 1;
        c5_mode                     : string := "bypass";
        c5_ph                       : integer := 0;
        m_ph                        : integer := 0;
        clk0_counter                : string := "c0";
        clk1_counter                : string := "c1";
        clk2_counter                : string := "c2";
        clk3_counter                : string := "c3";
        clk4_counter                : string := "c4";
        clk5_counter                : string := "c5";
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
        c5_use_casc_in              : string := "off";
        m_test_source               : integer := 5;
        c0_test_source              : integer := 5;
        c1_test_source              : integer := 5;
        c2_test_source              : integer := 5;
        c3_test_source              : integer := 5;
        c4_test_source              : integer := 5;
        c5_test_source              : integer := 5;
        enable0_counter             : string := "c0";
        enable1_counter             : string := "c1";
        sclkout0_phase_shift        : string := "0";
        sclkout1_phase_shift        : string := "0";
        charge_pump_current         : integer := 52;
        loop_filter_r               : string := " 1.000000";
        loop_filter_c               : integer := 16;
        use_vco_bypass              : string := "false";
        use_dc_coupling             : string := "false";
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        lpm_type                    : string := "cycloneii_pll";
        family_name                 : string  := "CycloneII";
        clk0_use_even_counter_mode  : string := "off";
        clk1_use_even_counter_mode  : string := "off";
        clk2_use_even_counter_mode  : string := "off";
        clk3_use_even_counter_mode  : string := "off";
        clk4_use_even_counter_mode  : string := "off";
        clk5_use_even_counter_mode  : string := "off";
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
        clk5_use_even_counter_value : string := "off";
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        vco_post_scale              : integer := 1;
        XOn                         : Boolean := DefGlitchXOn;
        MsgOn                       : Boolean := DefGlitchMsgOn;
        MsgOnChecks                 : Boolean := DefMsgOnChecks;
        XOnChecks                   : Boolean := DefXOnChecks;
        TimingChecksOn              : Boolean := true;
        InstancePath                : STRING := "*";
        tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
        tipd_ena                    : VitalDelayType01 := DefPropDelay01;
        tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
        tipd_areset                 : VitalDelayType01 := DefPropDelay01;
        tipd_clkswitch              : VitalDelayType01 := DefPropDelay01
    );
    PORT
    (
        inclk                       : in std_logic_vector(1 downto 0);
        ena                         : in std_logic := '1';
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        testclearlock               : in std_logic := '0';
        sbdin                       : in std_logic := '0';
        clk                         : out std_logic_vector(2 downto 0);
        locked                      : out std_logic;
        testupout                   : out std_logic;
        testdownout                 : out std_logic;
        sbdout                      : out std_logic
    );
END COMPONENT;

--
-- cycloneii_routing_wire
--

COMPONENT cycloneii_routing_wire
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

--
-- cycloneii_lcell_ff
--

COMPONENT cycloneii_lcell_ff
    generic (
             x_on_violation : string := "on";
             lpm_type : string := "cycloneii_lcell_ff";
             tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_sdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_sdata_regout: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01;
             tipd_sdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01; 
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*"
            );
    port (
          datain : in std_logic := '0';
          clk : in std_logic := '0';
          aclr : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          sdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          regout : out std_logic
         );
END COMPONENT;

--
-- cycloneii_lcell_comb
--

COMPONENT cycloneii_lcell_comb
    generic (
             lut_mask : std_logic_vector(15 downto 0) := (OTHERS => '1');
             sum_lutc_input : string := "datac";
             lpm_type : string := "cycloneii_lcell_comb";
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
             tpd_dataa_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_combout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01
            );
    port (
          dataa : in std_logic := '1';
          datab : in std_logic := '1';
          datac : in std_logic := '1';
          datad : in std_logic := '1';
          cin : in std_logic := '0';
          combout : out std_logic;
          cout : out std_logic
         );
END COMPONENT;

--
-- cycloneii_io
--

COMPONENT cycloneii_io
    generic (
		operation_mode : string := "input";
		open_drain_output : string := "false";
		bus_hold : string := "false";
		output_register_mode : string := "none";
		output_async_reset : string := "none";
		output_sync_reset : string := "none";
		output_power_up : string := "low";
		tie_off_output_clock_enable : string := "false";
		oe_register_mode : string := "none";
		oe_async_reset : string := "none";
		oe_sync_reset : string := "none";
		oe_power_up : string := "low";
		tie_off_oe_clock_enable : string := "false";
		input_register_mode : string := "none";
		input_async_reset : string := "none";
		input_sync_reset : string := "none";
		use_differential_input  : string := "false";
		lpm_type : string    := "cycloneii_io";
		input_power_up : string := "low");
	port (
		datain          : in std_logic := '0';
		oe              : in std_logic := '1';
		outclk          : in std_logic := '0';
		outclkena       : in std_logic := '1';
		inclk           : in std_logic := '0';
		inclkena        : in std_logic := '1';
		areset          : in std_logic := '0';
		sreset          : in std_logic := '0';
		devclrn         : in std_logic := '1';
		devpor          : in std_logic := '1';
		devoe           : in std_logic := '1';
		linkin          : in std_logic := '0';
		differentialin  : in std_logic := '0';
		differentialout : out std_logic;
		linkout         : out std_logic;
		combout         : out std_logic;
		regout          : out std_logic;
		padio           : inout std_logic
    );
END COMPONENT;

--
-- cycloneii_clk_delay_ctrl
--

COMPONENT cycloneii_clk_delay_ctrl
    generic (
             behavioral_sim_delay : integer := 0;
             delay_chain          : STRING := "54";
             delay_chain_mode     : STRING := "static";
             uses_calibration     : STRING := "false";
             use_new_style_dq_detection : STRING := "false";
             tan_delay_under_delay_ctrl_signal :    STRING := "unused";
             delay_ctrl_sim_delay_15_0  : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             delay_ctrl_sim_delay_31_16 : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             delay_ctrl_sim_delay_47_32 : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             delay_ctrl_sim_delay_63_48 : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             lpm_type : STRING    := "cycloneii_clk_delay_ctrl";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tpd_clk_clkout                : VitalDelayType01 := DefPropDelay01;
             tpd_disablecalibration_clkout : VitalDelayType01 := DefPropDelay01;
             tpd_pllcalibrateclkdelayedin_clkout : VitalDelayType01 := DefPropDelay01;
             tipd_clk                      : VitalDelayType01 := DefPropDelay01;
             tipd_delayctrlin              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
             tipd_disablecalibration       : VitalDelayType01 := DefPropDelay01;
             tipd_pllcalibrateclkdelayedin : VitalDelayType01 := DefPropDelay01
             );
    port (
             clk                : in std_logic := '0'; 
             delayctrlin        : in std_logic_vector(5 downto 0) := "000000";
             disablecalibration : in std_logic := '1';
             pllcalibrateclkdelayedin: in std_logic := '0';
             devclrn     : in std_logic := '1';
             devpor      : in std_logic := '1';
             clkout      : out std_logic
		 );
END COMPONENT;

--
-- cycloneii_clk_delay_cal_ctrl
--

COMPONENT cycloneii_clk_delay_cal_ctrl
    generic (
             delay_ctrl_sim_delay_15_0  : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             delay_ctrl_sim_delay_31_16 : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             delay_ctrl_sim_delay_47_32 : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             delay_ctrl_sim_delay_63_48 : STD_LOGIC_VECTOR(511 downto 0) := (OTHERS => '0');
             lpm_type : STRING    := "cycloneii_clk_delay_cal_ctrl";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tpd_plldataclk_calibratedata                     : VitalDelayType01 := DefPropDelay01;
             tpd_disablecalibration_calibratedata             : VitalDelayType01 := DefPropDelay01;
             tpd_pllcalibrateclk_pllcalibrateclkdelayedout    : VitalDelayType01 := DefPropDelay01;
             tpd_disablecalibration_pllcalibrateclkdelayedout : VitalDelayType01 := DefPropDelay01;
             tipd_plldataclk             : VitalDelayType01 := DefPropDelay01;
             tipd_pllcalibrateclk        : VitalDelayType01 := DefPropDelay01;
             tipd_delayctrlin            : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
             tipd_disablecalibration     : VitalDelayType01 := DefPropDelay01
             );
    port (
             plldataclk                  : in std_logic := '0'; 
             pllcalibrateclk             : in std_logic := '0';
             disablecalibration          : in std_logic := '1';
             delayctrlin                 : in std_logic_vector(5 downto 0) := "000000";
             devclrn                     : in std_logic := '1';
             devpor                      : in std_logic := '1';
             calibratedata               : out std_logic;
             pllcalibrateclkdelayedout   : out std_logic
		 );
END COMPONENT;

--
-- cycloneii_mac_mult
--

COMPONENT cycloneii_mac_mult
    GENERIC (
             dataa_width : integer := 18;    
             datab_width : integer := 18;
             dataa_clock : string := "none";    
             datab_clock : string := "none";    
             signa_clock : string := "none";    
             signb_clock : string := "none";    
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneii_mac_mult"
            );
    PORT (
          dataa : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (OTHERS => '0');
          datab : IN std_logic_vector(datab_width-1 DOWNTO 0) := (OTHERS => '0');
          signa : IN std_logic := '1';
          signb : IN std_logic := '1';
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '0';
          dataout : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
END COMPONENT;

--
-- cycloneii_mac_out
--

COMPONENT cycloneii_mac_out
    GENERIC (
             dataa_width : integer := 1;
             output_clock : string := "none";    
			 TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_dataa : VitalDelayArrayType01(35 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_dataout :VitalDelayArrayType01(36*36 -1 downto 0) :=(others => DefPropDelay01);
             tpd_aclr_dataout_posedge : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
             tpd_clk_dataout_posedge :VitalDelayArrayType01(35  downto 0) :=(others => DefPropDelay01);
             tsetup_dataa_clk_noedge_posedge : VitalDelayArrayType(35 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_dataa_clk_noedge_posedge :  VitalDelayArrayType(35 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneii_mac_out");    
    PORT (
          dataa : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (OTHERS => '0');
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector(dataa_width-1 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
END COMPONENT;

--
-- cycloneii_clkctrl
--

COMPONENT cycloneii_clkctrl
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "cycloneii_clkctrl";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_ena : VitalDelayType01 := DefPropDelay01
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          ena : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          outclk : out std_logic
          );    
END COMPONENT;

end cycloneii_components;
