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
use work.hardcopyii_atom_pack.all;

package hardcopyii_components is


--
-- hardcopyii_ram_block
--

COMPONENT hardcopyii_ram_block
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
        lpm_type                  : string := "hardcopyii_ram_block";
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
-- hardcopyii_routing_wire
--

COMPONENT hardcopyii_routing_wire
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
-- hardcopyii_jtag
--

COMPONENT hardcopyii_jtag
    generic (
        lpm_type : string := "hardcopyii_jtag"
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
-- hardcopyii_lcell_ff
--

COMPONENT hardcopyii_lcell_ff
    generic (
             x_on_violation : string := "on";
             lpm_type : string := "hardcopyii_lcell_ff";
             tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_adatasdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_adatasdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aload_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_adatasdata_regout: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01;
             tipd_adatasdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01; 
             tipd_aload : VitalDelayType01 := DefPropDelay01; 
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
          aload : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          adatasdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          regout : out std_logic
         );
END COMPONENT;

--
-- hardcopyii_lcell_comb
--

COMPONENT hardcopyii_lcell_comb
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
             lpm_type : string := "hardcopyii_lcell_comb";
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
             tpd_datae_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datag_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_sharein_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tpd_sharein_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_shareout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_datae : VitalDelayType01 := DefPropDelay01; 
             tipd_dataf : VitalDelayType01 := DefPropDelay01; 
             tipd_datag : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01; 
             tipd_sharein : VitalDelayType01 := DefPropDelay01
            );
    port (
          dataa : in std_logic := '0';
          datab : in std_logic := '0';
          datac : in std_logic := '0';
          datad : in std_logic := '0';
          datae : in std_logic := '0';
          dataf : in std_logic := '0';
          datag : in std_logic := '0';
          cin : in std_logic := '0';
          sharein : in std_logic := '0';
          combout : out std_logic;
          sumout : out std_logic;
          cout : out std_logic;
          shareout : out std_logic
         );
END COMPONENT;

--
-- hardcopyii_clkctrl
--

COMPONENT hardcopyii_clkctrl
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "hardcopyii_clkctrl";
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

--
-- hardcopyii_io
--

COMPONENT hardcopyii_io
    generic (
        operation_mode : string := "input";
        ddio_mode : string := "none";
        open_drain_output : string := "false";
        bus_hold : string := "false";
        output_register_mode : string := "none";
        output_async_reset : string := "none";
        output_power_up : string := "low";
        output_sync_reset : string := "none";
        tie_off_output_clock_enable : string := "false";
        oe_register_mode : string := "none";
        oe_async_reset : string := "none";
        oe_power_up : string := "low";
        oe_sync_reset : string := "none";
        tie_off_oe_clock_enable : string := "false";
        input_register_mode : string := "none";
        input_async_reset : string := "none";
        input_power_up : string := "low";
        input_sync_reset : string := "none";
        extend_oe_disable : string := "false";
        dqs_input_frequency : string := "10000 ps";
        dqs_out_mode : string := "none";
        dqs_delay_buffer_mode : string := "low";
        dqs_phase_shift : integer := 0;
        inclk_input : string := "normal";
        ddioinclk_input : string := "negated_inclk";
        dqs_offsetctrl_enable : string := "false";
        dqs_ctrl_latches_enable : string := "false";
        dqs_edge_detect_enable : string := "false";
        gated_dqs : string := "false";
        sim_dqs_intrinsic_delay : integer := 0;
        sim_dqs_delay_increment : integer := 0;
        sim_dqs_offset_increment : integer := 0;
        lpm_type : string := "hardcopyii_io"
        );
    port (
        datain          : in std_logic := '0';
        ddiodatain      : in std_logic := '0';
        oe              : in std_logic := '1';
        outclk          : in std_logic := '0';
        outclkena       : in std_logic := '1';
        inclk           : in std_logic := '0';
        inclkena        : in std_logic := '1';
        areset          : in std_logic := '0';
        sreset          : in std_logic := '0';
        ddioinclk       : in std_logic := '0';
        delayctrlin     : in std_logic_vector(5 downto 0) := "000000";
        offsetctrlin    : in std_logic_vector(5 downto 0) := "000000";
        dqsupdateen     : in std_logic := '0';
        linkin		  : in std_logic := '0';
        terminationcontrol : in std_logic_vector(13 downto 0) := "00000000000000";      
        devclrn         : in std_logic := '1';
        devpor          : in std_logic := '1';
        devoe           : in std_logic := '0';
        padio           : inout std_logic;
        combout         : out std_logic;
        regout          : out std_logic;
        ddioregout      : out std_logic;
        dqsbusout		  : out std_logic;
        linkout		  : out std_logic
        );
END COMPONENT;

--
-- hardcopyii_pll
--

COMPONENT hardcopyii_pll
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
        switch_over_type            : string := "auto";
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
        common_rx_tx                : string := "off";
        use_vco_bypass              : string := "false";
        use_dc_coupling             : string := "false";
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        lpm_type                    : string := "hardcopyii_pll";
        family_name                 : string  := "StratixII";
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
        scan_chain_mif_file         : string := "";
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
        tipd_fbin                   : VitalDelayType01 := DefPropDelay01;
        tipd_scanclk                : VitalDelayType01 := DefPropDelay01;
        tipd_scanread               : VitalDelayType01 := DefPropDelay01;
        tipd_scandata               : VitalDelayType01 := DefPropDelay01;
        tipd_scanwrite              : VitalDelayType01 := DefPropDelay01;
        tipd_clkswitch              : VitalDelayType01 := DefPropDelay01;
        tsetup_scandata_scanclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_scandata_scanclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_scanread_scanclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_scanread_scanclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_scanwrite_scanclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_scanwrite_scanclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst
    );
    PORT
    (
        inclk                       : in std_logic_vector(1 downto 0);
        fbin                        : in std_logic := '0';
        ena                         : in std_logic := '1';
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        scanread                    : in std_logic := '0';
        scanwrite                   : in std_logic := '0';
        scandata                    : in std_logic := '0';
        scanclk                     : in std_logic := '0';
        testin                      : in std_logic_vector(3 downto 0) := "0000";
        clk                         : out std_logic_vector(5 downto 0);
        clkbad                      : out std_logic_vector(1 downto 0);
        activeclock                 : out std_logic;
        locked                      : out std_logic;
        clkloss                     : out std_logic;
        scandataout                 : out std_logic;
        scandone                    : out std_logic;
        testupout                   : out std_logic;
        testdownout                 : out std_logic;
        enable0                     : out std_logic;
        enable1                     : out std_logic;
        sclkout                     : out std_logic_vector(1 downto 0)
    );
END COMPONENT;

--
-- hardcopyii_mac_mult
--

COMPONENT hardcopyii_mac_mult
   GENERIC (
      dataa_width                    :  integer := 18;    
      datab_width                    :  integer := 18;
      dataa_clock                    :  string := "none";    
      datab_clock                    :  string := "none";    
      signa_clock                    :  string := "none";    
      signb_clock                    :  string := "none";    
      round_clock                    :  string := "none";    
      saturate_clock                 :  string := "none";    
      output_clock                   :  string := "none";    
      round_clear                    :  string := "none";    
      saturate_clear                 :  string := "none";    
      dataa_clear                    :  string := "none";    
      datab_clear                    :  string := "none";    
      signa_clear                    :  string := "none";    
      signb_clear                    :  string := "none";    
      output_clear                   :  string := "none";    
      bypass_multiplier              :  string := "no";    
      mode_clock                     :  string := "none";    
      zeroacc_clock                  :  string := "none";
      mode_clear                     :  string := "none";
      zeroacc_clear                  :  string := "none";    
      signa_internally_grounded      :  string := "false";    
      signb_internally_grounded      :  string := "false";    
      lpm_hint                       :  string := "true";    
      lpm_type                       :  string := "hardcopyii_mac_mult";
      dynamic_mode                   :  string := "no");
   PORT (
      dataa                   : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '1');
      datab                   : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '1');
      scanina                 : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
      scaninb                 : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
      sourcea                 : IN std_logic := '0';   
      sourceb                 : IN std_logic := '0';   
      signa                   : IN std_logic := '1';   
      signb                   : IN std_logic := '1';   
      round                   : IN std_logic := '0';   
      saturate                : IN std_logic := '0';   
      clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');   
      dataout                 : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0) := (others => '0');   
      scanouta                : OUT std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
      scanoutb                : OUT std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
      devclrn                 : IN std_logic := '1';
      devpor                  : IN std_logic := '1'
      );   
END COMPONENT;

--
-- hardcopyii_mac_out
--

COMPONENT hardcopyii_mac_out
   GENERIC (
      operation_mode                 :  string := "output_only";    
      dataa_width                    :  integer := 1;    
      datab_width                    :  integer := 1;    
      datac_width                    :  integer := 1;    
      datad_width                    :  integer := 1;    
      dataout_width                  :  integer := 144;
      tmp_width                      :  integer := 144;
      addnsub0_clock                 :  string := "none";    
      addnsub1_clock                 :  string := "none";    
      zeroacc_clock                  :  string := "none";    
      round0_clock                   :  string := "none";    
      round1_clock                   :  string := "none";    
      saturate_clock                 :  string := "none";    
      multabsaturate_clock           :  string := "none";    
      multcdsaturate_clock           :  string := "none";    
      signa_clock                    :  string := "none";    
      signb_clock                    :  string := "none";    
      output_clock                   :  string := "none";    
      addnsub0_clear                 :  string := "none";    
      addnsub1_clear                 :  string := "none";    
      zeroacc_clear                  :  string := "none";    
      round0_clear                   :  string := "none";    
      round1_clear                   :  string := "none";    
      saturate_clear                 :  string := "none";    
      multabsaturate_clear           :  string := "none";    
      multcdsaturate_clear           :  string := "none";    
      signa_clear                    :  string := "none";    
      signb_clear                    :  string := "none";    
      output_clear                   :  string := "none";    
      addnsub0_pipeline_clock        :  string := "none";    
      addnsub1_pipeline_clock        :  string := "none";    
      round0_pipeline_clock          :  string := "none";    
      round1_pipeline_clock          :  string := "none";    
      saturate_pipeline_clock        :  string := "none";    
      multabsaturate_pipeline_clock  :  string := "none";    
      multcdsaturate_pipeline_clock  :  string := "none";    
      zeroacc_pipeline_clock         :  string := "none";    
      signa_pipeline_clock           :  string := "none";    
      signb_pipeline_clock           :  string := "none";    
      addnsub0_pipeline_clear        :  string := "none";    
      addnsub1_pipeline_clear        :  string := "none";    
      round0_pipeline_clear          :  string := "none";    
      round1_pipeline_clear          :  string := "none";    
      saturate_pipeline_clear        :  string := "none";    
      multabsaturate_pipeline_clear  :  string := "none";    
      multcdsaturate_pipeline_clear  :  string := "none";    
      zeroacc_pipeline_clear         :  string := "none";    
      signa_pipeline_clear           :  string := "none";    
      signb_pipeline_clear           :  string := "none";    
      mode0_clock                    :  string := "none";    
      mode1_clock                    :  string := "none";    
      zeroacc1_clock                 :  string := "none";    
      saturate1_clock                :  string := "none";    
      output1_clock                  :  string := "none";    
      output2_clock                  :  string := "none";    
      output3_clock                  :  string := "none";    
      output4_clock                  :  string := "none";    
      output5_clock                  :  string := "none";    
      output6_clock                  :  string := "none";    
      output7_clock                  :  string := "none";    
      mode0_clear                    :  string := "none";    
      mode1_clear                    :  string := "none";    
      zeroacc1_clear                 :  string := "none";    
      saturate1_clear                :  string := "none";    
      output1_clear                  :  string := "none";    
      output2_clear                  :  string := "none";    
      output3_clear                  :  string := "none";    
      output4_clear                  :  string := "none";    
      output5_clear                  :  string := "none";    
      output6_clear                  :  string := "none";    
      output7_clear                  :  string := "none";    
      mode0_pipeline_clock           :  string := "none";    
      mode1_pipeline_clock           :  string := "none";    
      zeroacc1_pipeline_clock        :  string := "none";    
      saturate1_pipeline_clock       :  string := "none";    
      mode0_pipeline_clear           :  string := "none";    
      mode1_pipeline_clear           :  string := "none";    
      zeroacc1_pipeline_clear        :  string := "none";    
      saturate1_pipeline_clear       :  string := "none";    
      dataa_forced_to_zero           :  string := "no";    
      datac_forced_to_zero           :  string := "no";    
      lpm_hint                       :  string := "true";    
      lpm_type                       :  string := "hardcopyii_mac_out");
   PORT (
      dataa                   : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '1');
      datab                   : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '1');
      datac                   : IN std_logic_vector(datac_width-1 DOWNTO 0) := (others => '1');
      datad                   : IN std_logic_vector(datad_width-1 DOWNTO 0) := (others => '1');
      zeroacc                 : IN std_logic := '0';
      addnsub0                : IN std_logic := '1';   
      addnsub1                : IN std_logic := '1';   
      round0                  : IN std_logic := '0';   
      round1                  : IN std_logic := '0';   
      saturate                : IN std_logic := '0';   
      multabsaturate          : IN std_logic := '0';   
      multcdsaturate          : IN std_logic := '0';   
      signa                   : IN std_logic := '1';   
      signb                   : IN std_logic := '1';   
      clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');   
      dataout                 : OUT std_logic_vector(dataout_width -1 DOWNTO 0) := (others => '0');   
      accoverflow             : OUT std_logic := '0';   
      devclrn                 : IN std_logic := '1';   
      devpor                  : IN std_logic := '1'
      );   
END COMPONENT;

--
-- hardcopyii_lvds_transmitter
--

COMPONENT hardcopyii_lvds_transmitter
    GENERIC ( channel_width                    : integer := 10;
              bypass_serializer                : String  := "false";
              invert_clock                     : String  := "false";
              use_falling_clock_edge           : String  := "false";
              use_serial_data_input            : String  := "false";
              use_post_dpa_serial_data_input   : String  := "false";
              preemphasis_setting              : integer := 0;
              vod_setting                      : integer := 0;
              differential_drive               : integer := 0;
              lpm_type                         : string  := "hardcopyii_lvds_transmitter";
              TimingChecksOn                   : Boolean := True;
              MsgOn                            : Boolean := DefGlitchMsgOn;
              XOn                              : Boolean := DefGlitchXOn;
              MsgOnChecks                      : Boolean := DefMsgOnChecks;
              XOnChecks                        : Boolean := DefXOnChecks;
              InstancePath                     : String := "*";
              tpd_clk0_dataout_posedge         : VitalDelayType01 := DefPropDelay01;
              tpd_clk0_dataout_negedge         : VitalDelayType01 := DefPropDelay01;
              tpd_serialdatain_dataout         : VitalDelayType01 := DefPropDelay01;
              tpd_postdpaserialdatain_dataout  : VitalDelayType01 := DefPropDelay01;
              tipd_clk0                        : VitalDelayType01 := DefpropDelay01;
              tipd_enable0                     : VitalDelayType01 := DefpropDelay01;
              tipd_datain                      : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01);
              tipd_serialdatain                : VitalDelayType01 := DefpropDelay01;
              tipd_postdpaserialdatain         : VitalDelayType01 := DefpropDelay01
            );
    PORT    ( clk0                     : in std_logic;
              enable0                  : in std_logic := '0';
              datain                   : in std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
              serialdatain             : in std_logic := '0';
              postdpaserialdatain      : in std_logic := '0';
              devclrn                  : in std_logic := '1';
              devpor                   : in std_logic := '1';
              dataout                  : out std_logic;
              serialfdbkout            : out std_logic
            );
END COMPONENT;

--
-- hardcopyii_lvds_receiver
--

COMPONENT hardcopyii_lvds_receiver
    GENERIC ( channel_width                  :  integer := 10;    
              data_align_rollover            :  integer := 2;    
              enable_dpa                     :  string := "off";    
              lose_lock_on_one_change        :  string := "off";    
              reset_fifo_at_first_lock       :  string := "on";    
              align_to_rising_edge_only      :  string := "on";    
              use_serial_feedback_input      :  string := "off";    
              dpa_debug                      :  string := "off";
              x_on_bitslip                   :  string := "on";
              lpm_type                       :  string := "hardcopyii_lvds_receiver";
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tipd_clk0                : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayType01 := DefpropDelay01;
              tipd_enable0             : VitalDelayType01 := DefpropDelay01;
              tipd_dpareset            : VitalDelayType01 := DefpropDelay01;
              tipd_dpahold             : VitalDelayType01 := DefpropDelay01;
              tipd_dpaswitch           : VitalDelayType01 := DefpropDelay01;
              tipd_fiforeset           : VitalDelayType01 := DefpropDelay01;
              tipd_bitslip             : VitalDelayType01 := DefpropDelay01;
              tipd_bitslipreset        : VitalDelayType01 := DefpropDelay01;
              tipd_serialfbk           : VitalDelayType01 := DefpropDelay01;
              tpd_clk0_dpalock_posedge : VitalDelayType01 := DefPropDelay01
            );
    PORT    ( clk0                    : IN std_logic;   
              datain                  : IN std_logic := '0';   
              enable0                 : IN std_logic := '0';   
              dpareset                : IN std_logic := '0';   
              dpahold                 : IN std_logic := '0';   
              dpaswitch               : IN std_logic := '0';   
              fiforeset               : IN std_logic := '0';   
              bitslip                 : IN std_logic := '0';   
              bitslipreset            : IN std_logic := '0';   
              serialfbk               : IN std_logic := '0';   
              dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);   
              dpalock                 : OUT std_logic;   
              bitslipmax              : OUT std_logic;   
              serialdataout           : OUT std_logic;   
              postdpaserialdataout    : OUT std_logic;
              devclrn                 : IN std_logic := '1';   
              devpor                  : IN std_logic := '1'
            );
END COMPONENT;

--
-- hardcopyii_dll
--

COMPONENT hardcopyii_dll
    GENERIC ( 
    input_frequency          : string := "10000 ps";
    delay_chain_length       : integer := 16;
    delay_buffer_mode        : string := "low";
    delayctrlout_mode        : string := "normal";
    static_delay_ctrl        : integer := 0;
    offsetctrlout_mode       : string := "static";
    static_offset            : string := "0";
    jitter_reduction         : string := "false";
    use_upndnin              : string := "false";
    use_upndninclkena        : string := "false";
    sim_valid_lock           : integer := 1;
    sim_loop_intrinsic_delay : integer := 1000;
    sim_loop_delay_increment : integer := 100;
    sim_valid_lockcount      : integer := 90;  -- 10000 = 1000 + 100*dllcounter
    lpm_type                 : string := "hardcopyii_dll";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_offset              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_upndnin             : VitalDelayType01 := DefpropDelay01;
    tipd_upndninclkena       : VitalDelayType01 := DefpropDelay01;
    tipd_addnsub             : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tpd_offset_delayctrlout  : VitalDelayType01 := DefPropDelay01;
    tpd_clk_upndnout_posedge : VitalDelayType01 := DefPropDelay01;
    tsetup_offset_clk_noedge_posedge        : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_offset_clk_noedge_posedge         : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_upndnin_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_upndnin_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tsetup_upndninclkena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
    thold_upndninclkena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    tsetup_addnsub_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_addnsub_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_delayctrlout_posedge            : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );
    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              offset                   : IN std_logic_vector(5 DOWNTO 0) := "000000";
              upndnin                  : IN std_logic := '1';
              upndninclkena            : IN std_logic := '1';
              addnsub                  : IN std_logic := '1';
              delayctrlout             : OUT std_logic_vector(5 DOWNTO 0);
              offsetctrlout            : OUT std_logic_vector(5 DOWNTO 0);
              dqsupdate                : OUT std_logic;
              upndnout                 : OUT std_logic;	
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '1'
            );
END COMPONENT;

--
-- hardcopyii_termination
--

COMPONENT hardcopyii_termination
    GENERIC (
    runtime_control           : string := "false";
    use_core_control          : string := "false";
    pullup_control_to_core    : string := "true";
    use_high_voltage_compare  : string := "true";
    use_both_compares         : string := "false";
    pullup_adder              : integer := 0;
    pulldown_adder            : integer := 0;
    half_rate_clock           : string := "false";
    power_down : string       := "true";
    left_shift : string       := "false";
    test_mode : string        := "false";
    lpm_type : string         := "hardcopyii_termination";
    tipd_rup                  : VitalDelayType01 := DefpropDelay01;
    tipd_rdn                  : VitalDelayType01 := DefpropDelay01;
    tipd_terminationclock     : VitalDelayType01 := DefpropDelay01;
    tipd_terminationclear     : VitalDelayType01 := DefpropDelay01;
    tipd_terminationenable    : VitalDelayType01 := DefpropDelay01;
    tipd_terminationpullup    : VitalDelayArrayType01(6 downto 0) := (OTHERS => DefPropDelay01);
    tipd_terminationpulldown  : VitalDelayArrayType01(6 downto 0) := (OTHERS => DefPropDelay01);
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tpd_terminationclock_terminationcontrol_posedge       : VitalDelayArrayType01(13 downto 0) := (OTHERS => DefPropDelay01);
    tpd_terminationclock_terminationcontrolprobe_posedge  : VitalDelayArrayType01(6 downto 0)  := (OTHERS => DefPropDelay01)
    );
    PORT ( 
    rup                      : IN std_logic := '0';
    rdn                      : IN std_logic := '0';
    terminationclock         : IN std_logic := '0';
    terminationclear         : IN std_logic := '0';
    terminationenable        : IN std_logic := '1';
    terminationpullup        : IN std_logic_vector(6 DOWNTO 0) := "0000000";
    terminationpulldown      : IN std_logic_vector(6 DOWNTO 0) := "0000000";
    devclrn                  : IN std_logic := '1';
    devpor                   : IN std_logic := '0';
    incrup                   : OUT std_logic;
    incrdn                   : OUT std_logic;
    terminationcontrol       : OUT std_logic_vector(13 DOWNTO 0);
    terminationcontrolprobe  : OUT std_logic_vector(6 DOWNTO 0)
    );
END COMPONENT;

--
-- hardcopyii_lcell_hsadder
--

COMPONENT hardcopyii_lcell_hsadder
    generic (
             use_cin1_for_sumout : string := "on";
             lpm_type : string := "hardcopyii_lcell_hsadder";
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
             tpd_dataa_sumout0 : VitalDelayType01 := DefPropDelay01;
             tpd_datab_sumout0 : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_sumout0 : VitalDelayType01 := DefPropDelay01;
             tpd_cin1_sumout0 : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_sumout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datab_sumout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datac_sumout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datad_sumout1 : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_sumout1 : VitalDelayType01 := DefPropDelay01;
             tpd_cin1_sumout1 : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_cout1 : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_cin0 : VitalDelayType01 := DefPropDelay01;
             tipd_cin1 : VitalDelayType01 := DefPropDelay01
            );
    port (
          dataa : in std_logic := '0';
          datab : in std_logic := '0';
          datac : in std_logic := '0';
          datad : in std_logic := '0';
          cin0 : in std_logic := '0';
          cin1 : in std_logic := '0';
          sumout0 : out std_logic;
          sumout1 : out std_logic;
          cout0 : out std_logic;
          cout1 : out std_logic
         );
END COMPONENT;

end hardcopyii_components;
