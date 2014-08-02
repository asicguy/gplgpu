-- Copyright (C) 1991-2011 Altera Corporation
-- This simulation model contains highly confidential and
-- proprietary information of Altera and is being provided
-- in accordance with and subject to the protections of the
-- applicable Altera Program License Subscription Agreement
-- which governs its use and disclosure. Your use of Altera
-- Corporation's design tools, logic functions and other
-- software and tools, and its AMPP partner logic functions,
-- and any output files any of the foregoing (including device
-- programming or simulation files), and any associated
-- documentation or information are expressly subject to the
-- terms and conditions of the Altera Program License Subscription
-- Agreement, Altera MegaCore Function License Agreement, or other
-- applicable license agreement, including, without limitation,
-- that your use is for the sole purpose of simulating designs for
-- use exclusively in logic devices manufactured by Altera and sold
-- by Altera or its authorized distributors. Please refer to the
-- applicable agreement for further details. Altera products and
-- services are protected under numerous U.S. and foreign patents,
-- maskwork rights, copyrights and other intellectual property laws.
-- Altera assumes no responsibility or liability arising out of the
-- application or use of this simulation model.
-- Quartus II 11.0 Build 157 04/27/2011

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixv_atom_pack.all;

package stratixv_components is


--
-- stratixv_ff
--

COMPONENT stratixv_ff
    generic (
             power_up : string := "low";
             x_on_violation : string := "on";
             lpm_type : string := "stratixv_ff";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clrn_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_asdata_q: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_asdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_clrn : VitalDelayType01 := DefPropDelay01; 
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
          d : in std_logic := '0';
          clk : in std_logic := '0';
          clrn : in std_logic := '1';
          aload : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          asdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          q : out std_logic
         );
END COMPONENT;

--
-- stratixv_pseudo_diff_out
--

COMPONENT stratixv_pseudo_diff_out
 GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             tipd_oein                        : VitalDelayType01 := DefPropDelay01;
             tpd_oein_oeout                   : VitalDelayType01 := DefPropDelay01;
             tpd_oein_oebout                  : VitalDelayType01 := DefPropDelay01;
             tipd_dtcin                       : VitalDelayType01 := DefPropDelay01;
             tpd_dtcin_dtc                    : VitalDelayType01 := DefPropDelay01;
             tpd_dtcin_dtcbar                 : VitalDelayType01 := DefPropDelay01;             
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             lpm_type                         :  string := "stratuxv_pseudo_diff_out"
            );
 PORT (
           i                       : IN std_logic := '0';
           o                       : OUT std_logic;
           obar                    : OUT std_logic;
           dtcin                   : in std_logic := '0';
           oein                    : in std_logic := '0';
           dtc                     : OUT std_logic;
           dtcbar                  : OUT std_logic;
           oeout                   : OUT std_logic;
           oebout                  : OUT std_logic                      
           );
END COMPONENT;

--
-- stratixv_lcell_comb
--

COMPONENT stratixv_lcell_comb
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
             dont_touch : string := "off";
             lpm_type : string := "stratixv_lcell_comb";
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
-- stratixv_routing_wire
--

COMPONENT stratixv_routing_wire
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
-- stratixv_ram_block
--

COMPONENT stratixv_ram_block
    GENERIC (
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
        ecc_pipeline_stage_enabled     :  STRING := "false";
        enable_ecc                     :  STRING := "false";
	width_eccstatus		       :  INTEGER := 2;   
        data_interleave_width_in_bits  :  INTEGER := 1;    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        port_a_logical_ram_depth       :  INTEGER := 0;    
        port_a_logical_ram_width       :  INTEGER := 0;    
        port_a_first_address           :  INTEGER := 0;    
        port_a_last_address            :  INTEGER := 0;    
        port_a_first_bit_number        :  INTEGER := 0;    
        bist_ena                       :  STRING := "false";
        port_a_address_clear           :  STRING := "none";    
        port_a_data_out_clear          :  STRING := "none";    
        port_a_data_in_clock           :  STRING := "clock0";    
        port_a_address_clock           :  STRING := "clock0";    
        port_a_write_enable_clock      :  STRING := "clock0";    
        port_a_read_enable_clock     :  STRING := "clock0";           
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
        port_b_address_clear           :  STRING := "none";    
        port_b_data_out_clear          :  STRING := "none";    
        port_b_data_in_clock           :  STRING := "clock1";    
        port_b_address_clock           :  STRING := "clock1";    
        port_b_write_enable_clock: STRING := "clock1";    
        port_b_read_enable_clock: STRING := "clock1";    
        port_b_byte_enable_clock       :  STRING := "clock1";    
        port_b_data_out_clock          :  STRING := "none";    
        port_b_data_width              :  INTEGER := 1;    
        port_b_address_width           :  INTEGER := 1;    
        port_b_byte_enable_mask_width  :  INTEGER := 1;    
        port_a_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
        port_b_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";    
        power_up_uninitialized         :  STRING := "false";  
        port_b_byte_size : INTEGER := 0;
        port_a_byte_size : INTEGER := 0;  
        lpm_type                  : string := "stratixv_ram_block";
        lpm_hint                  : string := "true";
        clk0_input_clock_enable  : STRING := "none"; -- ena0,ena2,none
        clk0_core_clock_enable   : STRING := "none"; -- ena0,ena2,none
        clk0_output_clock_enable : STRING := "none"; -- ena0,none
        clk1_input_clock_enable  : STRING := "none"; -- ena1,ena3,none
        clk1_core_clock_enable   : STRING := "none"; -- ena1,ena3,none
        clk1_output_clock_enable : STRING := "none"; -- ena1,none
        mem_init0 : STRING := "";
        mem_init1 : STRING := "";
        mem_init2 : STRING := "";
        mem_init3 : STRING := "";
        mem_init4 : STRING := "";
        mem_init5 : STRING := "";
        mem_init6 : STRING := "";
        mem_init7 : STRING := "";
        mem_init8 : STRING := "";
        mem_init9 : STRING := "";
        connectivity_checking     : string := "off"
        );    
    PORT (
        portadatain             : IN STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portaaddr               : IN STD_LOGIC_VECTOR(port_a_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portawe                 : IN STD_LOGIC := '0';   
        portare                 : IN STD_LOGIC := '1';   
        portbdatain             : IN STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portbaddr               : IN STD_LOGIC_VECTOR(port_b_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portbwe                 : IN STD_LOGIC := '0';   
        portbre                 : IN STD_LOGIC := '1';   
        clk0                    : IN STD_LOGIC := '0';   
        clk1                    : IN STD_LOGIC := '0';   
        ena0                    : IN STD_LOGIC := '1';   
        ena1                    : IN STD_LOGIC := '1';   
        ena2                    : IN STD_LOGIC := '1';   
        ena3                    : IN STD_LOGIC := '1';   
        clr0                    : IN STD_LOGIC := '0';   
        clr1                    : IN STD_LOGIC := '0';   
        nerror                  : IN STD_LOGIC := '1';   
        portabyteenamasks       : IN STD_LOGIC_VECTOR(port_a_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        portbbyteenamasks       : IN STD_LOGIC_VECTOR(port_b_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        devclrn                 : IN STD_LOGIC := '1';   
        devpor                  : IN STD_LOGIC := '1';   
        portaaddrstall : IN STD_LOGIC := '0';
        portbaddrstall : IN STD_LOGIC := '0';
        eccstatus : OUT STD_LOGIC_VECTOR(width_eccstatus - 1 DOWNTO 0) := (OTHERS => '0');
        dftout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );
END COMPONENT;

--
-- stratixv_mlab_cell
--

COMPONENT stratixv_mlab_cell
   GENERIC (
      logical_ram_name                  : STRING := "lutram";
      logical_ram_depth                 : INTEGER := 0;
      logical_ram_width                 : INTEGER := 0;
      first_address                 : INTEGER := 0;
      last_address                  : INTEGER := 0;
      first_bit_number              : INTEGER := 0;
      init_file                  : STRING := "NONE";
      data_width                    : INTEGER := 20;
      address_width                 : INTEGER := 6;
      byte_enable_mask_width           : INTEGER := 1;
      byte_size                     : INTEGER := 1;
      port_b_data_out_clock         : STRING := "none";
      port_b_data_out_clear         : STRING := "none";
      lpm_type                      : STRING := "stratixv_mlab_cell";
      lpm_hint                      : STRING := "true";
      mem_init0                     : STRING := "";
      mixed_port_feed_through_mode  : STRING := "new"
   );
   PORT (
      portadatain                   : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0) := (others => '0');
      portaaddr                     : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := (others => '0');
      portabyteenamasks             : IN STD_LOGIC_VECTOR(byte_enable_mask_width - 1 DOWNTO 0) := (others => '1');
      portbaddr                     : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := (others => '0');
      clk0                          : IN STD_LOGIC := '0';
      clk1                          : IN STD_LOGIC := '0';
      ena0                          : IN STD_LOGIC := '1';
      ena1                          : IN STD_LOGIC := '1';
      ena2                          : IN STD_LOGIC := '1';
      clr                          : IN STD_LOGIC := '0';
      devclrn                       : IN STD_LOGIC := '1';
      devpor                        : IN STD_LOGIC := '1';
      portbdataout                  : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
   );
END COMPONENT;

--
-- stratixv_io_ibuf
--

COMPONENT stratixv_io_ibuf
    GENERIC (
             tipd_i                  : VitalDelayType01 := DefPropDelay01;
             tipd_ibar               : VitalDelayType01 := DefPropDelay01;
             tipd_dynamicterminationcontrol   : VitalDelayType01 := DefPropDelay01;  
             tpd_i_o                 : VitalDelayType01 := DefPropDelay01;
             tpd_ibar_o              : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             differential_mode       :  string := "false";
             bus_hold                :  string := "false";
             simulate_z_as          : string    := "Z";
             lpm_type                :  string := "stratixv_io_ibuf"
            );    
    PORT (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          dynamicterminationcontrol   : IN std_logic := '0';                                 
          o                       : OUT std_logic
         );       
END COMPONENT;

--
-- stratixv_io_obuf
--

COMPONENT stratixv_io_obuf
    GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tipd_oe                          : VitalDelayType01 := DefPropDelay01;
             tipd_dynamicterminationcontrol   : VitalDelayType01 := DefPropDelay01;  
             tipd_seriesterminationcontrol    : VitalDelayArrayType01(15 DOWNTO 0) := (others => DefPropDelay01 ); 
             tipd_parallelterminationcontrol  : VitalDelayArrayType01(15 DOWNTO 0) := (others => DefPropDelay01 ); 
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_oe_o                         : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             tpd_oe_obar                      : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;  
             open_drain_output                :  string := "false";              
             shift_series_termination_control :  string := "false";  
             sim_dynamic_termination_control_is_connected :  string := "false";                
             bus_hold                         :  string := "false";              
             lpm_type                         :  string := "stratixv_io_obuf"
            );               
    PORT (
           i                       : IN std_logic := '0';                                                 
           oe                      : IN std_logic := '1';                                                 
           dynamicterminationcontrol   : IN std_logic := '0';                                 
           seriesterminationcontrol    : IN std_logic_vector(15 DOWNTO 0) := (others => '0'); 
           parallelterminationcontrol  : IN std_logic_vector(15 DOWNTO 0) := (others => '0'); 
           devoe                       : IN std_logic := '1';
           o                       : OUT std_logic;                                                       
           obar                    : OUT std_logic
         );                                                      
END COMPONENT;

--
-- stratixv_ddio_in
--

COMPONENT stratixv_ddio_in
    generic(                                                                                                  
            tipd_datain                        : VitalDelayType01 := DefPropDelay01;                          
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;                          
            tipd_clkn                          : VitalDelayType01 := DefPropDelay01;                          
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;                          
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;                          
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;                          
            XOn                                : Boolean := DefGlitchXOn;                                     
            MsgOn                              : Boolean := DefGlitchMsgOn;                                   
            power_up                           :  string := "low";                                            
            async_mode                         :  string := "none";                                           
            sync_mode                          :  string := "none";                                           
            use_clkn                           :  string := "false";                                          
            lpm_type                           :  string := "stratixv_ddio_in"                                   
           );                                                                                                 
    PORT (                                                                                                    
           datain                  : IN std_logic := '0';                                                     
           clk                     : IN std_logic := '0';                                                     
           clkn                    : IN std_logic := '0';                                                     
           ena                     : IN std_logic := '1';                                                     
           areset                  : IN std_logic := '0';                                                     
           sreset                  : IN std_logic := '0';                                                     
           regoutlo                : OUT std_logic;                                                           
           regouthi                : OUT std_logic;                                                           
           dfflo                   : OUT std_logic;                                                           
           devclrn                 : IN std_logic := '1';                                                     
           devpor                  : IN std_logic := '1'                                                      
        );                                                                                                    
END COMPONENT;

--
-- stratixv_ddio_oe
--

COMPONENT stratixv_ddio_oe
    generic(
            tipd_oe                            : VitalDelayType01 := DefPropDelay01;
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;
            XOn                                : Boolean := DefGlitchXOn;           
            MsgOn                              : Boolean := DefGlitchMsgOn;         
            power_up              :  string := "low";    
            async_mode            :  string := "none";    
            sync_mode             :  string := "none";
            lpm_type              :  string := "stratixv_ddio_oe"
           );    
    PORT (
          oe                      : IN std_logic := '1';   
          clk                     : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic;         
          devclrn                 : IN std_logic := '1';               
          devpor                  : IN std_logic := '1'
         );             
END COMPONENT;

--
-- stratixv_ddio_out
--

COMPONENT stratixv_ddio_out
    generic(
            tipd_datainlo                      : VitalDelayType01 := DefPropDelay01;
            tipd_datainhi                      : VitalDelayType01 := DefPropDelay01;
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;
            tipd_clkhi                         : VitalDelayType01 := DefPropDelay01;
            tipd_clklo                         : VitalDelayType01 := DefPropDelay01;
            tipd_muxsel                        : VitalDelayType01 := DefPropDelay01;
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;
            XOn                                : Boolean := DefGlitchXOn;           
            MsgOn                              : Boolean := DefGlitchMsgOn;         
            power_up                           :  string := "low";          
            async_mode                         :  string := "none";       
            sync_mode                          :  string := "none";
            half_rate_mode                     :  string := "false";       
            use_new_clocking_model             :  string := "false";
            lpm_type                           :  string := "stratixv_ddio_out"
           );
    PORT (
          datainlo                : IN std_logic := '0';   
          datainhi                : IN std_logic := '0';   
          clk                     : IN std_logic := '0'; 
          clkhi                   : IN std_logic := '0'; 
          clklo                   : IN std_logic := '0'; 
          muxsel                  : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic_vector(1 downto 0) ;      
          devclrn                 : IN std_logic := '1';   
          devpor                  : IN std_logic := '1'   
        );   
END COMPONENT;

--
-- stratixv_io_pad
--

COMPONENT stratixv_io_pad
    GENERIC (
        lpm_type                       :  string := "stratixv_io_pad");    
    PORT (
        padin                   : IN std_logic := '0';   -- Input Pad
        padout                  : OUT std_logic);   -- Output Pad
END COMPONENT;

--
-- stratixv_bias_block
--

COMPONENT stratixv_bias_block
    GENERIC (
        lpm_type : string := "stratixv_bias_block";
        tipd_clk : VitalDelayType01 := DefPropDelay01;
        tipd_shiftnld : VitalDelayType01 := DefPropDelay01;
        tipd_captnupdt : VitalDelayType01 := DefPropDelay01;
        tipd_din : VitalDelayType01 := DefPropDelay01;
        tsetup_din_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_shiftnld_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_captnupdt_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_din_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_shiftnld_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_captnupdt_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_dout_posedge : VitalDelayType01 := DefPropDelay01;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks
        );
    PORT (
        clk : in std_logic := '0';
        shiftnld : in std_logic := '0';
        captnupdt : in std_logic := '0';
        din : in std_logic := '0';
        dout : out std_logic := '0'
        );
END COMPONENT;

--
-- stratixv_mac
--

COMPONENT stratixv_mac
    generic    (
        lpm_type    :    string    :=    "stratixv_mac";
        ax_width    :    integer    :=    16;
        ay_scan_in_width    :    integer    :=    16;
        az_width    :    integer    :=    1;
        bx_width    :    integer    :=    16;
        by_width    :    integer    :=    16;
        scan_out_width    :    integer    :=    1;
        result_a_width    :    integer    :=    33;
        result_b_width    :    integer    :=    1;
        operation_mode    :    string    :=    "m18x18_sumof2";
        mode_sub_location    :    integer    :=    0;
        operand_source_max    :    string    :=    "input";
        operand_source_may    :    string    :=    "input";
        operand_source_mbx    :    string    :=    "input";
        operand_source_mby    :    string    :=    "input";
        preadder_subtract_a    :    string    :=    "false";
        preadder_subtract_b    :    string    :=    "false";
        signed_max    :    string    :=    "false";
        signed_may    :    string    :=    "false";
        signed_mbx    :    string    :=    "false";
        signed_mby    :    string    :=    "false";
        ay_use_scan_in    :    string    :=    "false";
        by_use_scan_in    :    string    :=    "false";
        delay_scan_out_ay    :    string    :=    "false";
        delay_scan_out_by    :    string    :=    "false";
        use_chainadder    :    string    :=    "false";
        load_const_value    :    integer    :=    0;
        coef_a_0    :    integer    :=    0;
        coef_a_1    :    integer    :=    0;
        coef_a_2    :    integer    :=    0;
        coef_a_3    :    integer    :=    0;
        coef_a_4    :    integer    :=    0;
        coef_a_5    :    integer    :=    0;
        coef_a_6    :    integer    :=    0;
        coef_a_7    :    integer    :=    0;
        coef_b_0    :    integer    :=    0;
        coef_b_1    :    integer    :=    0;
        coef_b_2    :    integer    :=    0;
        coef_b_3    :    integer    :=    0;
        coef_b_4    :    integer    :=    0;
        coef_b_5    :    integer    :=    0;
        coef_b_6    :    integer    :=    0;
        coef_b_7    :    integer    :=    0;
        ax_clock    :    string    :=    "none";
        ay_scan_in_clock    :    string    :=    "none";
        az_clock    :    string    :=    "none";
        bx_clock    :    string    :=    "none";
        by_clock    :    string    :=    "none";
        coef_sel_a_clock    :    string    :=    "none";
        coef_sel_b_clock    :    string    :=    "none";
        sub_clock    :    string    :=    "none";
        negate_clock    :    string    :=    "none";
        accumulate_clock    :    string    :=    "none";
        load_const_clock    :    string    :=    "none";
        complex_clock    :    string    :=    "none";
        output_clock    :    string    :=    "none"
    );
    port    (
        sub    :    in    std_logic := '0';
        negate    :    in    std_logic := '0';
        accumulate    :    in    std_logic := '0';
        loadconst    :    in    std_logic := '0';
        complex    :    in    std_logic := '0';
        cin    :    in    std_logic := '0';
        ax    :    in    std_logic_vector(ax_width-1 downto 0) := (others => '0');
        ay    :    in    std_logic_vector(ay_scan_in_width-1 downto 0) := (others => '0');
        scanin    :    in    std_logic_vector(ay_scan_in_width-1 downto 0) := (others => '0');
        az    :    in    std_logic_vector(az_width-1 downto 0) := (others => '0');
        bx    :    in    std_logic_vector(bx_width-1 downto 0) := (others => '0');
        by    :    in    std_logic_vector(by_width-1 downto 0) := (others => '0');
        coefsela    :    in    std_logic_vector(2 downto 0) := (others => '0');
        coefselb    :    in    std_logic_vector(2 downto 0) := (others => '0');
        clk    :    in    std_logic_vector(2 downto 0) := (others => '0');
        aclr    :    in    std_logic_vector(1 downto 0) := (others => '0');
        ena    :    in    std_logic_vector(2 downto 0) := (others => '1');
        chainin    :    in    std_logic_vector(63 downto 0) := (others => '0');
        cout    :    out    std_logic;
        dftout    :    out    std_logic;
        resulta    :    out    std_logic_vector(result_a_width-1 downto 0);
        resultb    :    out    std_logic_vector(result_b_width-1 downto 0);
        scanout    :    out    std_logic_vector(scan_out_width-1 downto 0);
        chainout    :    out    std_logic_vector(63 downto 0)
    );
END COMPONENT;

--
-- stratixv_clk_phase_select
--

COMPONENT stratixv_clk_phase_select
    generic    (
        use_phasectrlin    :    string    :=    "true";
        phase_setting    :    integer    :=    0;
        invert_phase    :    string    :=    "false";
        physical_clock_source	:	string	:=	"auto"
    );
    port    (
        clkin    :    in    std_logic_vector(3 downto 0)	:= (OTHERS => '0');
        phasectrlin    :    in    std_logic_vector(1 downto 0)	:= (OTHERS => '0');
        phaseinvertctrl    :    in    std_logic	:= '0';
        powerdown    :    in    std_logic	:= '0';
        clkout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_clkena
--

COMPONENT stratixv_clkena
    generic    (
        clock_type    :    string    :=    "auto";
        ena_register_mode    :    string    :=    "always enabled";
        lpm_type    :    string    :=    "stratixv_clkena";
        ena_register_power_up    :    string    :=    "high";
        disable_mode    :    string    :=    "low";
        test_syn    :    string    :=    "high"
    );
    port    (
        inclk    :    in    std_logic    :=    '1';
        ena    :    in    std_logic    :=    '1';
        enaout    :    out    std_logic;
        outclk    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_clkselect
--

COMPONENT stratixv_clkselect
    generic    (
        lpm_type    :    string    :=    "stratixv_clkselect";
        test_cff    :    string    :=    "low"
    );
    port    (
        inclk    :    in    std_logic_vector(3 downto 0)    :=    "0000";
        clkselect    :    in    std_logic_vector(1 downto 0)    :=    "00";
        outclk    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_delay_chain
--

COMPONENT stratixv_delay_chain
    generic    (
        sim_intrinsic_rising_delay    :    integer    :=    200;
        sim_intrinsic_falling_delay    :    integer    :=    200;
        sim_rising_delay_increment    :    integer    :=    10;
        sim_falling_delay_increment    :    integer    :=    10;
        lpm_type    :    string    :=    "stratixv_delay_chain"
    );
    port    (
        datain    :    in    std_logic	:= '0';
        delayctrlin    :    in    std_logic_vector(7 downto 0)	:= (OTHERS => '0');
        dataout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_dll_offset_ctrl
--

COMPONENT stratixv_dll_offset_ctrl
    generic    (
        use_offset    :    string    :=    "false";
        static_offset    :    integer    :=    0;
        use_pvt_compensation    :    string    :=    "false"
    );
    port    (
        clk    :    in    std_logic	:= '0';
        offsetdelayctrlin    :    in    std_logic_vector(6 downto 0)	:= (OTHERS => '0');
        offset    :    in    std_logic_vector(6 downto 0)	:= (OTHERS => '0');
        addnsub    :    in    std_logic	:= '0';
        aload    :    in    std_logic	:= '0';
        offsetctrlout    :    out    std_logic_vector(6 downto 0);
        offsettestout    :    out    std_logic_vector(6 downto 0)
    );
END COMPONENT;

--
-- stratixv_dll
--

COMPONENT stratixv_dll
    generic    (
        input_frequency    :    string    :=    "0 MHz";
        delayctrlout_mode    :    string    :=    "normal";
        jitter_reduction    :    string    :=    "false";
        use_upndnin    :    string    :=    "false";
        use_upndninclkena    :    string    :=    "false";
        dual_phase_comparators    :    string    :=    "true";
        sim_valid_lock    :    integer    :=    16;
        sim_valid_lockcount    :    integer    :=    0;
        sim_buffer_intrinsic_delay    :    integer    :=    175;
        sim_buffer_delay_increment    :    integer    :=    10;
        static_delay_ctrl    :    integer    :=    0;
        lpm_type    :    string    :=    "stratixv_dll";
        delay_chain_length    :    integer    :=    8
    );
    port    (
        aload    :    in    std_logic	:= '0';
        clk    :    in    std_logic	:= '0';
        upndnin    :    in    std_logic	:= '0';
        upndninclkena    :    in    std_logic	:= '0';
        delayctrlout    :    out    std_logic_vector(6 downto 0);
        dqsupdate    :    out    std_logic;
        offsetdelayctrlout    :    out    std_logic_vector(6 downto 0);
        offsetdelayctrlclkout    :    out    std_logic;
        upndnout    :    out    std_logic;
        dffin    :    out    std_logic;
        locked    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_dqs_config
--

COMPONENT stratixv_dqs_config
    generic    (
        lpm_type    :    string    :=    "stratixv_dqs_config"
    );
    port    (
        datain    :    in    std_logic	:= '0';
        clk    :    in    std_logic	:= '0';
        ena    :    in    std_logic	:= '0';
        update    :    in    std_logic	:= '0';
        dqsbusoutdelaysetting    :    out    std_logic_vector(5 downto 0);
        dqsbusoutdelaysetting2    :    out    std_logic_vector(5 downto 0);
        dqsinputphasesetting    :    out    std_logic_vector(1 downto 0);
        dqsoutputphasesetting    :    out    std_logic_vector(1 downto 0);
        dqoutputphasesetting    :    out    std_logic_vector(1 downto 0);
        resyncinputphasesetting    :    out    std_logic_vector(1 downto 0);
        enaoctcycledelaysetting    :    out    std_logic_vector(2 downto 0);
        enainputcycledelaysetting    :    out    std_logic;
        enaoutputcycledelaysetting    :    out    std_logic_vector(2 downto 0);
        dqsenabledelaysetting    :    out    std_logic_vector(7 downto 0);
        octdelaysetting1    :    out    std_logic_vector(4 downto 0);
        octdelaysetting2    :    out    std_logic_vector(4 downto 0);
        enadqsenablephasetransferreg    :    out    std_logic;
        enaoctphasetransferreg    :    out    std_logic;
        enaoutputphasetransferreg    :    out    std_logic;
        enainputphasetransferreg    :    out    std_logic;
		resyncinputphaseinvert    :    out    std_logic;
        dqoutputphaseinvert    :    out    std_logic;
        dqsoutputphaseinvert    :    out    std_logic;
        dataout    :    out    std_logic;
        resyncinputzerophaseinvert    :    out    std_logic;
        dqs2xoutputphasesetting    :    out    std_logic_vector(1 downto 0);
        dqs2xoutputphaseinvert    :    out    std_logic;
        ck2xoutputphasesetting    :    out    std_logic_vector(1 downto 0);
        ck2xoutputphaseinvert    :    out    std_logic;
        dq2xoutputphasesetting    :    out    std_logic_vector(1 downto 0);
        dq2xoutputphaseinvert    :    out    std_logic;
        postamblephasesetting    :    out    std_logic_vector(1 downto 0);
        postamblephaseinvert    :    out    std_logic;  
        dividerphaseinvert    :    out    std_logic;
        addrphasesetting    :    out    std_logic_vector(1 downto 0);
        addrphaseinvert    :    out    std_logic;
        enadqscycledelaysetting	:    out    std_logic_vector(2 downto 0);
        enadqsphasetransferreg    :    out    std_logic;	
        dqoutputzerophasesetting    :    out    std_logic_vector(1 downto 0);
        postamblezerophasesetting    :    out    std_logic_vector(2 downto 0);                               
		dividerioehratephaseinvert    :    out    std_logic;
		dqsdisablendelaysetting    :    out    std_logic_vector(7 downto 0);
		addrpowerdown    :    out    std_logic;
		dqsoutputpowerdown    :    out    std_logic;
		dqoutputpowerdown    :    out    std_logic;
		resyncinputpowerdown    :    out    std_logic;
		dqs2xoutputpowerdown    :    out    std_logic;
		ck2xoutputpowerdown    :    out    std_logic;
		dq2xoutputpowerdown    :    out    std_logic;
		postamblepowerdown    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_dqs_delay_chain
--

COMPONENT stratixv_dqs_delay_chain
    generic    (
        dqs_input_frequency    :    string    :=    "unused";
        dqs_phase_shift    :    integer    :=    0;
        use_phasectrlin    :    string    :=    "false";
        phase_setting    :    integer    :=    0;
        dqs_offsetctrl_enable    :    string    :=    "false";
        dqs_ctrl_latches_enable    :    string    :=    "false";
        use_alternate_input_for_first_stage_delayctrl    :    string    :=    "false";
        sim_buffer_intrinsic_delay    :    integer    :=    175;
        sim_buffer_delay_increment    :    integer    :=    10;
        test_enable    :    string    :=    "false"
    );
    port    (
        dqsin    :    in    std_logic	:= '0';
        dqsenable    :    in    std_logic	:= '1';
        dqsdisablen    :    in    std_logic	:= '0';
        delayctrlin    :    in    std_logic_vector(6 downto 0)	:= (OTHERS => '0');
        offsetctrlin    :    in    std_logic_vector(6 downto 0)	:= (OTHERS => '0');
        dqsupdateen    :    in    std_logic	:= '1';
        phasectrlin    :    in    std_logic_vector(1 downto 0)	:= (OTHERS => '0');
        testin    :    in    std_logic	:= '0';
        dffin    :    out    std_logic;
        dqsbusout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_dqs_enable_ctrl
--

COMPONENT stratixv_dqs_enable_ctrl
    generic    (
        delay_dqs_enable_by_half_cycle    :    string    :=    "false";
        add_phase_transfer_reg    :    string    :=    "false";
        sim_dqsenablein_pre_delay :    integer   := 0;
        bypass_output_register    :    string    :=    "false";
        ext_delay_chain_setting :    integer   := 0;
		int_delay_chain_setting :    integer   := 0;
		use_enable_tracking    :    string    :=    "false";
		use_on_die_variation_tracking    :    string    :=    "false";
		use_pvt_compensation    :    string    :=    "false"
    );
    port    (
        dqsenablein    :    in    std_logic	:= '1';
        zerophaseclk    :    in    std_logic	:= '1';
        enaphasetransferreg    :    in    std_logic	:= '0';
        levelingclk    :    in    std_logic	:= '1';
        dffin    :    out    std_logic;
        dffphasetransfer    :    out    std_logic;
        dffextenddqsenable    :    out    std_logic;
        dqsenableout    :    out    std_logic;
        prevphasevalid    :    out    std_logic;
        enatrackingreset    :    in    std_logic	:= '0';
        enatrackingevent    :    out    std_logic;
        enatrackingupdwn    :    out    std_logic;
        nextphasealign    :    out    std_logic;
        prevphasealign    :    out    std_logic;
        prevphasedelaysetting    :    out    std_logic_vector(5 downto 0)
    );
END COMPONENT;

--
-- stratixv_duty_cycle_adjustment
--

COMPONENT stratixv_duty_cycle_adjustment
    generic    (
        duty_cycle_delay_mode    :    string    :=    "none";
        lpm_type    :    string    :=    "stratixv_duty_cycle_adjustment"
    );
    port    (
        clkin    :    in    std_logic	:= '0';
        delaymode    :    in    std_logic	:= '0';
        delayctrlin    :    in    std_logic_vector(3 downto 0)	:= (OTHERS => '0');
        clkout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_fractional_pll
--

COMPONENT stratixv_fractional_pll
    generic    (
        lpm_type    :    string    :=    "stratixv_fractional_pll";
        output_clock_frequency    :    string    :=    "0 ps";
        pll_chg_pump_crnt    :    integer    :=    10;
        pll_clkin_cmp_path    :    string    :=    "nrm";
        pll_cmp_buf_dly    :    string    :=    "0 ps";
        pll_dnm_phsf_cnt_sel    :    string    :=    "all_c";
        pll_dsm_k    :    integer    :=    1;
        pll_dsm_out_sel    :    string    :=    "cram";
        pll_enable    :    string    :=    "true";
        pll_fbclk_cmp_path    :    string    :=    "nrm";
        pll_fbclk_mux_1    :    string    :=    "glb";
        pll_fbclk_mux_2    :    string    :=    "fb_1";
        pll_lock_fltr_cfg    :    integer    :=    0;
        pll_lock_fltr_test    :    string    :=    "false";
        pll_lock_win    :    string    :=    "nrm";
        pll_lp_fltr_cs    :    integer    :=    0;
        pll_lp_fltr_rp    :    integer    :=    20;
        pll_m_cnt_bypass_en    :    string    :=    "false";
        pll_m_cnt_coarse_dly    :    string    :=    "0 ps";
        pll_m_cnt_fine_dly    :    string    :=    "0 ps";
        pll_m_cnt_hi_div    :    integer    :=    0;
        pll_m_cnt_in_src    :    string    :=    "ph_mux_clk";
        pll_m_cnt_lo_div    :    integer    :=    0;
        pll_m_cnt_odd_div_duty_en    :    string    :=    "false";
        pll_m_cnt_ph_mux_prst    :    integer    :=    0;
        pll_m_cnt_prst    :    integer    :=    0;
        pll_mmd_div_sel    :    integer    :=    2;
        pll_n_cnt_bypass_en    :    string    :=    "false";
        pll_n_cnt_coarse_dly    :    string    :=    "0 ps";
        pll_n_cnt_fine_dly    :    string    :=    "0 ps";
        pll_n_cnt_hi_div    :    integer    :=    1;
        pll_n_cnt_lo_div    :    integer    :=    1;
        pll_n_cnt_odd_div_duty_en    :    string    :=    "false";
        pll_p_cnt_set    :    integer    :=    1;
        pll_pfd_pulse_width_min    :    string    :=    "0 ps";
        pll_ref_vco_over    :    integer    :=    1300;
        pll_ref_vco_under    :    integer    :=    500;
        pll_s_cnt_set    :    integer    :=    1;
        pll_slf_rst    :    string    :=    "true";
        pll_tclk_mux_en    :    string    :=    "false";
        pll_unlock_fltr_cfg    :    integer    :=    0;
        pll_vco_div    :    integer    :=    600;
        pll_vco_ph0_en    :    string    :=    "false";
        pll_vco_ph1_en    :    string    :=    "false";
        pll_vco_ph2_en    :    string    :=    "false";
        pll_vco_ph3_en    :    string    :=    "false";
        pll_vco_ph4_en    :    string    :=    "false";
        pll_vco_ph5_en    :    string    :=    "false";
        pll_vco_ph6_en    :    string    :=    "false";
        pll_vco_ph7_en    :    string    :=    "false";
        pll_vco_rng_dt    :    string    :=    "dis_en";
        pll_vt_bp_reg_div    :    integer    :=    1700;
        pll_vt_out    :    integer    :=    1650;
        pll_vt_rg_mode    :    string    :=    "nrm_mode";
        pll_vt_test    :    string    :=    "false";
        reference_clock_frequency    :    string    :=    "0 ps"
    );
    port    (
        analogtest    :    in    std_logic;
        cntnen    :    in    std_logic;
        coreclkfb    :    in    std_logic;
        crcm    :    in    std_logic_vector(1 downto 0);
        crcp    :    in    std_logic_vector(2 downto 0);
        crdltasgma    :    in    std_logic_vector(23 downto 0);
        crdsmen    :    in    std_logic;
        crfbclkdly    :    in    std_logic_vector(2 downto 0);
        crfbclksel    :    in    std_logic_vector(1 downto 0);
        crlckf    :    in    std_logic_vector(11 downto 0);
        crlcktest    :    in    std_logic;
        crlfc    :    in    std_logic_vector(1 downto 0);
        crlfr    :    in    std_logic_vector(4 downto 0);
        crlfrd    :    in    std_logic_vector(5 downto 0);
        crlock    :    in    std_logic_vector(3 downto 0);
        crmdirectfb    :    in    std_logic;
        crmhi    :    in    std_logic_vector(8 downto 0);
        crmlo    :    in    std_logic_vector(8 downto 0);
        crmmddiv    :    in    std_logic_vector(1 downto 0);
        crmprst    :    in    std_logic_vector(10 downto 0);
        crmrdly    :    in    std_logic_vector(4 downto 0);
        crmsel    :    in    std_logic_vector(1 downto 0);
        crnhi    :    in    std_logic_vector(8 downto 0);
        crnlckf    :    in    std_logic_vector(2 downto 0);
        crnlo    :    in    std_logic_vector(8 downto 0);
        crnrdly    :    in    std_logic_vector(4 downto 0);
        crpcnt    :    in    std_logic_vector(3 downto 0);
        crpfdpulsewidth    :    in    std_logic;
        crrefclkdly    :    in    std_logic_vector(2 downto 0);
        crrefclksel    :    in    std_logic_vector(1 downto 0);
        crscnt    :    in    std_logic_vector(3 downto 0);
        crselfrst    :    in    std_logic_vector(1 downto 0);
        crtclk    :    in    std_logic_vector(1 downto 0);
        crtest    :    in    std_logic_vector(1 downto 0);
        crvcop    :    in    std_logic_vector(7 downto 0);
        crvcophbyps    :    in    std_logic;
        crvr    :    in    std_logic_vector(6 downto 0);
        enpfd    :    in    std_logic;
        lfreset    :    in    std_logic;
        lvdsfbin    :    in    std_logic;
        niotricntr    :    in    std_logic;
        pdbvr    :    in    std_logic;
        pfden    :    in    std_logic;
        pllpd    :    in    std_logic;
        refclkin    :    in    std_logic;
        reset0    :    in    std_logic;
        roc    :    in    std_logic;
        shift    :    in    std_logic;
        shiftdonein    :    in    std_logic;
        shiften    :    in    std_logic;
        up    :    in    std_logic;
        vcopen    :    in    std_logic;
        zdbinput    :    in    std_logic;
        fbclk    :    out    std_logic;
        fblvdsout    :    out    std_logic;
        lock    :    out    std_logic;
        mcntout    :    out    std_logic;
        selfrst    :    out    std_logic;
        shiftdoneout    :    out    std_logic;
        tclk    :    out    std_logic;
        vcoover    :    out    std_logic;
        vcoph    :    out    std_logic_vector(7 downto 0);
        vcounder    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_half_rate_input
--

COMPONENT stratixv_half_rate_input
    generic    (
        power_up    :    string    :=    "low";
        async_mode    :    string    :=    "no_reset";
        use_dataoutbypass    :    string    :=    "false"
    );
    port    (
        datain    :    in    std_logic_vector(1 downto 0)	:= (OTHERS => '1');
        directin    :    in    std_logic	:= '1';
        clk    :    in    std_logic	:= '0';
        areset    :    in    std_logic	:= '0';
        dataoutbypass    :    in    std_logic	:= '0';
        dataout    :    out    std_logic_vector(3 downto 0);
        dffin    :    out    std_logic_vector(1 downto 0)
    );
END COMPONENT;

--
-- stratixv_input_phase_alignment
--

COMPONENT stratixv_input_phase_alignment
    generic    (
        power_up    :    string    :=    "low";
        async_mode    :    string    :=    "no_reset";
        add_input_cycle_delay    :    string    :=    "false";
        bypass_output_register    :    string    :=    "false";
        add_phase_transfer_reg    :    string    :=    "false";
        lpm_type    :    string    :=    "stratixv_input_phase_alignment"
    );
    port    (
        datain    :    in    std_logic	:= '1';
        levelingclk    :    in    std_logic	:= '0';
        zerophaseclk    :    in    std_logic	:= '0';
        areset    :    in    std_logic	:= '0';
        enainputcycledelay    :    in    std_logic	:= '0';
        enaphasetransferreg    :    in    std_logic	:= '0';
        dataout    :    out    std_logic;
        dffin    :    out    std_logic;
        dff1t    :    out    std_logic;
        dffphasetransfer    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_io_clock_divider
--

COMPONENT stratixv_io_clock_divider
    generic    (
        power_up    :    string    :=    "low";
        invert_phase    :    string    :=    "false";
        use_masterin    :    string    :=    "false";
        lpm_type    :    string    :=    "stratixv_io_clock_divider"
    );
    port    (
        clk    :    in    std_logic	:= '0';
        phaseinvertctrl    :    in    std_logic	:= '0';
        masterin    :    in    std_logic	:= '0';
        clkout    :    out    std_logic;
        slaveout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_io_config
--

COMPONENT stratixv_io_config
    generic    (
        lpm_type    :    string    :=    "stratixv_io_config"
    );
    port    (
        datain    :    in    std_logic	:= '0';
        clk    :    in    std_logic	:= '0';
        ena    :    in    std_logic	:= '1';	
        update    :    in    std_logic	:= '0';
        outputdelaysetting1    :    out    std_logic_vector(5 downto 0);
        outputdelaysetting2    :    out    std_logic_vector(5 downto 0);
        padtoinputregisterdelaysetting    :    out    std_logic_vector(5 downto 0);
        padtoinputregisterrisefalldelaysetting    :    out    std_logic_vector(5 downto 0);
        inputclkdelaysetting    :    out    std_logic_vector(1 downto 0);
        inputclkndelaysetting    :    out    std_logic_vector(1 downto 0);
        dutycycledelaymode    :    out    std_logic;
        dutycycledelaysetting    :    out    std_logic_vector(3 downto 0);
        dataout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_leveling_delay_chain
--

COMPONENT stratixv_leveling_delay_chain
    generic    (
        physical_clock_source    :    string    :=    "dqs";
        sim_buffer_intrinsic_delay    :    integer    :=    175;
        sim_buffer_delay_increment    :    integer    :=    10
    );
    port    (
        clkin    :    in    std_logic	:= '0';
        delayctrlin    :    in    std_logic_vector(6 downto 0)	:= (OTHERS => '0');
        clkout    :    out    std_logic_vector(3 downto 0)
    );
END COMPONENT;

--
-- stratixv_lvds_rx
--

COMPONENT stratixv_lvds_rx
    generic    (
        data_align_rollover    :    integer    :=    2;
        enable_dpa    :    string    :=    "false";
        lose_lock_on_one_change    :    string    :=    "false";
        reset_fifo_at_first_lock    :    string    :=    "true";
        align_to_rising_edge_only    :    string    :=    "true";
        use_serial_feedback_input    :    string    :=    "off";
        dpa_debug    :    string    :=    "false";
        x_on_bitslip    :    string    :=    "true";
        enable_soft_cdr    :    string    :=    "false";
        dpa_clock_output_phase_shift    :    integer    :=    0;
        enable_dpa_initial_phase_selection    :    string    :=    "false";
        dpa_initial_phase_value    :    integer    :=    0;
        enable_dpa_align_to_rising_edge_only    :    string    :=    "false";
        net_ppm_variation    :    integer    :=    0;
        is_negative_ppm_drift    :    string    :=    "false";
        rx_input_path_delay_engineering_bits    :    integer    :=    2;
        lpm_type    :    string    :=    "stratixv_lvds_rx";
        data_width    :    integer    :=    10
    );
    port    (
        clock0    :    in    std_logic	:= '0';
        datain    :    in    std_logic	:= '0';
        enable0    :    in    std_logic	:= '0';
        dpareset    :    in    std_logic	:= '0';
        dpahold    :    in    std_logic	:= '0';
        dpaswitch    :    in    std_logic	:= '0';
        fiforeset    :    in    std_logic	:= '0';
        bitslip    :    in    std_logic	:= '0';
        bitslipreset    :    in    std_logic	:= '0';
        serialfbk    :    in    std_logic	:= '0';
        devclrn    :    in    std_logic	:= '1';
        devpor    :    in    std_logic	:= '1';
        dpaclkin    :    in    std_logic_vector(7 downto 0)	:= (OTHERS => '0');
        dataout    :    out    std_logic_vector(data_width-1 downto 0);
        dpalock    :    out    std_logic;
        bitslipmax    :    out    std_logic;
        serialdataout    :    out    std_logic;
        postdpaserialdataout    :    out    std_logic;
        divfwdclk    :    out    std_logic;
        dpaclkout    :    out    std_logic;
        observableout    :    out    std_logic_vector(3 downto 0)
    );
END COMPONENT;

--
-- stratixv_lvds_tx
--

COMPONENT stratixv_lvds_tx
    generic    (
        bypass_serializer    :    string    :=    "false";
        invert_clock    :    string    :=    "false";
        use_falling_clock_edge    :    string    :=    "false";
        use_serial_data_input    :    string    :=    "false";
        use_post_dpa_serial_data_input    :    string    :=    "false";
        is_used_as_outclk    :    string    :=    "false";
        tx_output_path_delay_engineering_bits    :    integer    :=    -1;
        enable_dpaclk_to_lvdsout    :    string    :=    "false";
        lpm_type    :    string    :=    "stratixv_lvds_tx";
        data_width    :    integer    :=    10
    );
    port    (
        datain    :    in    std_logic_vector(data_width-1 downto 0)	:= (OTHERS => '0');
        clock0    :    in    std_logic	:= '0';
        enable0    :    in    std_logic	:= '0';
        serialdatain    :    in    std_logic	:= '0';
        postdpaserialdatain    :    in    std_logic	:= '0';
        devclrn    :    in    std_logic	:= '1';
        devpor    :    in    std_logic	:= '1';
        dpaclkin    :    in    std_logic	:= '0';
        dataout    :    out    std_logic;
        serialfdbkout    :    out    std_logic;
        observableout    :    out    std_logic_vector(2 downto 0)
    );
END COMPONENT;

--
-- stratixv_output_alignment
--

COMPONENT stratixv_output_alignment
    generic    (
        power_up    :    string    :=    "low";
        async_mode    :    string    :=    "none";
        sync_mode    :    string    :=    "none";
        add_output_cycle_delay    :    string    :=    "false";
        add_phase_transfer_reg    :    string    :=    "false"
    );
    port    (
        datain    :    in    std_logic	:= '1';
        clk    :    in    std_logic	:= '0';
        areset    :    in    std_logic	:= '0';
        sreset    :    in    std_logic	:= '0';
        enaoutputcycledelay    :    in    std_logic_vector(2 downto 0)	:= (OTHERS => '0');
        enaphasetransferreg    :    in    std_logic	:= '0';
        dataout    :    out    std_logic;
        dffin    :    out    std_logic;
        dff1t    :    out    std_logic;
        dff2t    :    out    std_logic;
        dffphasetransfer    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_pll_dll_output
--

COMPONENT stratixv_pll_dll_output
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_dll_output";
        pll_dll_src    :    string    :=    "c_0_cnt"
    );
    port    (
        cclk    :    in    std_logic_vector(17 downto 0);
        clkin    :    in    std_logic_vector(3 downto 0);
        crsel    :    in    std_logic_vector(4 downto 0);
        mout    :    in    std_logic;
        clkout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_pll_dpa_output
--

COMPONENT stratixv_pll_dpa_output
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_dpa_output";
        pll_vcoph_div_en    :    integer    :=    1
    );
    port    (
        crdpaen    :    in    std_logic_vector(1 downto 0);
        pd    :    in    std_logic;
        phin    :    in    std_logic_vector(7 downto 0);
        phout    :    out    std_logic_vector(7 downto 0)
    );
END COMPONENT;

--
-- stratixv_pll_extclk_output
--

COMPONENT stratixv_pll_extclk_output
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_extclk_output";
        pll_extclk_cnt_src    :    string    :=    "m0_cnt";
        pll_extclk_enable    :    string    :=    "true";
        pll_extclk_invert    :    string    :=    "false";
        pll_extclken_invert    :    string    :=    "false"
    );
    port    (
        cclk    :    in    std_logic_vector(17 downto 0);
        clken    :    in    std_logic;
        crenable    :    in    std_logic;
        crextclkeninv    :    in    std_logic;
        crinv    :    in    std_logic;
        crsel    :    in    std_logic_vector(4 downto 0);
        mcnt    :    in    std_logic;
        niotri    :    in    std_logic;
        extclk    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_pll_lvds_output
--

COMPONENT stratixv_pll_lvds_output
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_lvds_output";
        pll_loaden_coarse_dly    :    string    :=    "0 ps";
        pll_loaden_fine_dly    :    string    :=    "0 ps";
        pll_lvdsclk_coarse_dly    :    string    :=    "0 ps";
        pll_lvdsclk_fine_dly    :    string    :=    "0 ps"
    );
    port    (
        ccout    :    in    std_logic_vector(1 downto 0);
        crdly    :    in    std_logic_vector(9 downto 0);
        loaden    :    out    std_logic;
        lvdsclk    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_pll_output_counter
--

COMPONENT stratixv_pll_output_counter
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_output_counter";
        duty_cycle    :    integer    :=    50;
        output_clock_frequency    :    string    :=    "0 ps";
        phase_shift    :    string    :=    "0 ps";
        pll_c_cnt_bypass_en    :    string    :=    "false";
        pll_c_cnt_coarse_dly    :    string    :=    "0 ps";
        pll_c_cnt_fine_dly    :    string    :=    "0 ps";
        pll_c_cnt_hi_div    :    integer    :=    3;
        pll_c_cnt_in_src    :    string    :=    "ph_mux_clk";
        pll_c_cnt_lo_div    :    integer    :=    3;
        pll_c_cnt_odd_div_even_duty_en    :    string    :=    "false";
        pll_c_cnt_ph_mux_prst    :    integer    :=    0;
        pll_c_cnt_prst    :    integer    :=    1
    );
    port    (
        cascadein    :    in    std_logic;
        crhi    :    in    std_logic_vector(8 downto 0);
        crlo    :    in    std_logic_vector(8 downto 0);
        nen    :    in    std_logic;
        shift    :    in    std_logic;
        shiftdonei    :    in    std_logic;
        shiften    :    in    std_logic;
        tclk    :    in    std_logic;
        up    :    in    std_logic;
        vcoph    :    in    std_logic_vector(7 downto 0);
        divclk    :    out    std_logic;
        shiftdoneo    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_pll_reconfig
--

COMPONENT stratixv_pll_reconfig
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_reconfig"
    );
    port    (
        cntsel0    :    in    std_logic_vector(4 downto 0);
        cr3lo    :    out    std_logic_vector(10 downto 0);
        cr3prst    :    out    std_logic_vector(10 downto 0);
        cr3sel    :    out    std_logic_vector(1 downto 0);
        cr4dly    :    out    std_logic_vector(10 downto 0);
        cr4hi    :    out    std_logic_vector(10 downto 0);
        cr4lo    :    out    std_logic_vector(10 downto 0);
        cr4prst    :    out    std_logic_vector(10 downto 0);
        cr4sel    :    out    std_logic_vector(1 downto 0);
        cr5dly    :    out    std_logic_vector(10 downto 0);
        cr5hi    :    out    std_logic_vector(10 downto 0);
        cntsel1    :    in    std_logic_vector(4 downto 0);
        cr5lo    :    out    std_logic_vector(10 downto 0);
        cr5prst    :    out    std_logic_vector(10 downto 0);
        cr5sel    :    out    std_logic_vector(1 downto 0);
        cr6dly    :    out    std_logic_vector(10 downto 0);
        cr6hi    :    out    std_logic_vector(10 downto 0);
        cr6lo    :    out    std_logic_vector(10 downto 0);
        cr6prst    :    out    std_logic_vector(10 downto 0);
        cr6sel    :    out    std_logic_vector(1 downto 0);
        cr7dly    :    out    std_logic_vector(10 downto 0);
        cr7hi    :    out    std_logic_vector(10 downto 0);
        dprio0addr    :    in    std_logic_vector(6 downto 0);
        cr7lo    :    out    std_logic_vector(10 downto 0);
        cr7prst    :    out    std_logic_vector(10 downto 0);
        cr7sel    :    out    std_logic_vector(1 downto 0);
        cr8dly    :    out    std_logic_vector(10 downto 0);
        cr8hi    :    out    std_logic_vector(10 downto 0);
        cr8lo    :    out    std_logic_vector(10 downto 0);
        cr8prst    :    out    std_logic_vector(10 downto 0);
        cr8sel    :    out    std_logic_vector(1 downto 0);
        cr9dly    :    out    std_logic_vector(10 downto 0);
        cr9hi    :    out    std_logic_vector(10 downto 0);
        dprio0byteen    :    in    std_logic_vector(1 downto 0);
        cr9lo    :    out    std_logic_vector(10 downto 0);
        cr9prst    :    out    std_logic_vector(10 downto 0);
        cr9sel    :    out    std_logic_vector(1 downto 0);
        crclkenen    :    out    std_logic_vector(3 downto 0);
        crdll    :    out    std_logic_vector(9 downto 0);
        crext    :    out    std_logic_vector(19 downto 0);
        crextclkeninv    :    out    std_logic_vector(3 downto 0);
        crextclkinv    :    out    std_logic_vector(10 downto 0);
        crfpll0cp    :    out    std_logic_vector(2 downto 0);
        crfpll0dpadiv    :    out    std_logic_vector(1 downto 0);
        dprio0clk    :    in    std_logic;
        crfpll0lckbypass    :    out    std_logic;
        crfpll0lfc    :    out    std_logic_vector(1 downto 0);
        crfpll0lfr    :    out    std_logic_vector(4 downto 0);
        crfpll0lfrd    :    out    std_logic_vector(5 downto 0);
        crfpll0lockc    :    out    std_logic_vector(3 downto 0);
        crfpll0lockf    :    out    std_logic_vector(11 downto 0);
        crfpll0mdirectfb    :    out    std_logic;
        crfpll0mdly    :    out    std_logic_vector(4 downto 0);
        crfpll0mhi    :    out    std_logic_vector(8 downto 0);
        crfpll0mlo    :    out    std_logic_vector(8 downto 0);
        dprio0din    :    in    std_logic_vector(15 downto 0);
        crfpll0mprst    :    out    std_logic_vector(10 downto 0);
        crfpll0msel    :    out    std_logic_vector(1 downto 0);
        crfpll0ndly    :    out    std_logic_vector(4 downto 0);
        crfpll0nhi    :    out    std_logic_vector(8 downto 0);
        crfpll0nlo    :    out    std_logic_vector(8 downto 0);
        crfpll0pfdpulsewidth    :    out    std_logic;
        crfpll0selfrst    :    out    std_logic_vector(1 downto 0);
        crfpll0tclk    :    out    std_logic_vector(1 downto 0);
        crfpll0test    :    out    std_logic_vector(1 downto 0);
        crfpll0unlockf    :    out    std_logic_vector(2 downto 0);
        dprio0mdiodis    :    in    std_logic;
        crfpll0vcop    :    out    std_logic_vector(7 downto 0);
        crfpll0vcophbyps    :    out    std_logic;
        crfpll0vcorangeen    :    out    std_logic;
        crfpll0vr    :    out    std_logic_vector(6 downto 0);
        crfpll1cp    :    out    std_logic_vector(2 downto 0);
        crfpll1dpadiv    :    out    std_logic_vector(1 downto 0);
        crfpll1lckbypass    :    out    std_logic;
        crfpll1lfc    :    out    std_logic_vector(1 downto 0);
        crfpll1lfr    :    out    std_logic_vector(4 downto 0);
        crfpll1lfrd    :    out    std_logic_vector(5 downto 0);
        dprio0read    :    in    std_logic;
        crfpll1lockc    :    out    std_logic_vector(3 downto 0);
        crfpll1lockf    :    out    std_logic_vector(11 downto 0);
        crfpll1mdirectfb    :    out    std_logic;
        crfpll1mdly    :    out    std_logic_vector(4 downto 0);
        crfpll1mhi    :    out    std_logic_vector(8 downto 0);
        crfpll1mlo    :    out    std_logic_vector(8 downto 0);
        crfpll1mprst    :    out    std_logic_vector(10 downto 0);
        crfpll1msel    :    out    std_logic_vector(1 downto 0);
        crfpll1ndly    :    out    std_logic_vector(4 downto 0);
        crfpll1nhi    :    out    std_logic_vector(8 downto 0);
        dprio0rstn    :    in    std_logic;
        crfpll1nlo    :    out    std_logic_vector(8 downto 0);
        crfpll1pfdpulsewidth    :    out    std_logic;
        crfpll1selfrst    :    out    std_logic_vector(1 downto 0);
        crfpll1tclk    :    out    std_logic_vector(1 downto 0);
        crfpll1test    :    out    std_logic_vector(1 downto 0);
        crfpll1unlockf    :    out    std_logic_vector(2 downto 0);
        crfpll1vcop    :    out    std_logic_vector(7 downto 0);
        crfpll1vcophbyps    :    out    std_logic;
        crfpll1vcorangeen    :    out    std_logic;
        crfpll1vr    :    out    std_logic_vector(6 downto 0);
        dprio0sershiftload    :    in    std_logic;
        crinv    :    out    std_logic_vector(85 downto 0);
        crlvds    :    out    std_logic_vector(39 downto 0);
        crphaseshiftsel    :    out    std_logic_vector(17 downto 0);
        crvcosel    :    out    std_logic_vector(17 downto 0);
        crwrapback    :    out    std_logic;
        crwrapbackmux    :    out    std_logic;
        dprio0blockselect    :    out    std_logic;
        dprio0dout    :    out    std_logic_vector(15 downto 0);
        dprio1blockselect    :    out    std_logic;
        dprio1dout    :    out    std_logic_vector(15 downto 0);
        dprio0write    :    in    std_logic;
        fpll0cntnen    :    out    std_logic;
        fpll0enpfd    :    out    std_logic;
        fpll0lfreset    :    out    std_logic;
        fpll0niotricntr    :    out    std_logic;
        fpll0pdbvr    :    out    std_logic;
        fpll0pllpd    :    out    std_logic;
        fpll0reset0    :    out    std_logic;
        fpll0vcopen    :    out    std_logic;
        fpll1cntnen    :    out    std_logic;
        fpll1enpfd    :    out    std_logic;
        dprio1addr    :    in    std_logic_vector(6 downto 0);
        fpll1lfreset    :    out    std_logic;
        fpll1niotricntr    :    out    std_logic;
        fpll1pdbvr    :    out    std_logic;
        fpll1pllpd    :    out    std_logic;
        fpll1reset0    :    out    std_logic;
        fpll1vcopen    :    out    std_logic;
        iocsrdataout    :    out    std_logic;
        phasedone    :    out    std_logic_vector(1 downto 0);
        shift0    :    out    std_logic;
        shift1    :    out    std_logic;
        dprio1byteen    :    in    std_logic_vector(1 downto 0);
        shiftdone0o    :    out    std_logic;
        shiftdone1o    :    out    std_logic;
        shiften    :    out    std_logic_vector(17 downto 0);
        up0    :    out    std_logic;
        up1    :    out    std_logic;
        dprio1clk    :    in    std_logic;
        dprio1din    :    in    std_logic_vector(15 downto 0);
        dprio1mdiodis    :    in    std_logic;
        dprio1read    :    in    std_logic;
        dprio1rstn    :    in    std_logic;
        dprio1sershiftload    :    in    std_logic;
        dprio1write    :    in    std_logic;
        fpll0selfrst    :    in    std_logic;
        fpll1selfrst    :    in    std_logic;
        iocsrclkin    :    in    std_logic;
        iocsrdatain    :    in    std_logic;
        ioplniotri    :    in    std_logic;
        nfrzdrv    :    in    std_logic;
        nreset    :    in    std_logic_vector(1 downto 0);
        pfden    :    in    std_logic;
        phaseen0    :    in    std_logic;
        phaseen1    :    in    std_logic;
        pllbias    :    in    std_logic;
        updn0    :    in    std_logic;
        updn1    :    in    std_logic;
        cr0dly    :    out    std_logic_vector(10 downto 0);
        cr0hi    :    out    std_logic_vector(10 downto 0);
        cr0lo    :    out    std_logic_vector(10 downto 0);
        cr0prst    :    out    std_logic_vector(10 downto 0);
        cr0sel    :    out    std_logic_vector(1 downto 0);
        cr10dly    :    out    std_logic_vector(10 downto 0);
        cr10hi    :    out    std_logic_vector(10 downto 0);
        cr10lo    :    out    std_logic_vector(10 downto 0);
        cr10prst    :    out    std_logic_vector(10 downto 0);
        cr10sel    :    out    std_logic_vector(1 downto 0);
        cr11dly    :    out    std_logic_vector(10 downto 0);
        cr11hi    :    out    std_logic_vector(10 downto 0);
        cr11lo    :    out    std_logic_vector(10 downto 0);
        cr11prst    :    out    std_logic_vector(10 downto 0);
        cr11sel    :    out    std_logic_vector(1 downto 0);
        cr12dly    :    out    std_logic_vector(10 downto 0);
        cr12hi    :    out    std_logic_vector(10 downto 0);
        cr12lo    :    out    std_logic_vector(10 downto 0);
        cr12prst    :    out    std_logic_vector(10 downto 0);
        cr12sel    :    out    std_logic_vector(1 downto 0);
        cr13dly    :    out    std_logic_vector(10 downto 0);
        cr13hi    :    out    std_logic_vector(10 downto 0);
        cr13lo    :    out    std_logic_vector(10 downto 0);
        cr13prst    :    out    std_logic_vector(10 downto 0);
        cr13sel    :    out    std_logic_vector(1 downto 0);
        cr14dly    :    out    std_logic_vector(10 downto 0);
        cr14hi    :    out    std_logic_vector(10 downto 0);
        cr14lo    :    out    std_logic_vector(10 downto 0);
        cr14prst    :    out    std_logic_vector(10 downto 0);
        cr14sel    :    out    std_logic_vector(1 downto 0);
        cr15dly    :    out    std_logic_vector(10 downto 0);
        cr15hi    :    out    std_logic_vector(10 downto 0);
        cr15lo    :    out    std_logic_vector(10 downto 0);
        cr15prst    :    out    std_logic_vector(10 downto 0);
        cr15sel    :    out    std_logic_vector(1 downto 0);
        cr16dly    :    out    std_logic_vector(10 downto 0);
        cr16hi    :    out    std_logic_vector(10 downto 0);
        cr16lo    :    out    std_logic_vector(10 downto 0);
        cr16prst    :    out    std_logic_vector(10 downto 0);
        cr16sel    :    out    std_logic_vector(1 downto 0);
        cr17dly    :    out    std_logic_vector(10 downto 0);
        cr17hi    :    out    std_logic_vector(10 downto 0);
        cr17lo    :    out    std_logic_vector(10 downto 0);
        cr17prst    :    out    std_logic_vector(10 downto 0);
        cr17sel    :    out    std_logic_vector(1 downto 0);
        cr1dly    :    out    std_logic_vector(10 downto 0);
        cr1hi    :    out    std_logic_vector(10 downto 0);
        cr1lo    :    out    std_logic_vector(10 downto 0);
        cr1prst    :    out    std_logic_vector(10 downto 0);
        cr1sel    :    out    std_logic_vector(1 downto 0);
        cr2dly    :    out    std_logic_vector(10 downto 0);
        cr2hi    :    out    std_logic_vector(10 downto 0);
        cr2lo    :    out    std_logic_vector(10 downto 0);
        cr2prst    :    out    std_logic_vector(10 downto 0);
        cr2sel    :    out    std_logic_vector(1 downto 0);
        cr3dly    :    out    std_logic_vector(10 downto 0);
        cr3hi    :    out    std_logic_vector(10 downto 0)
    );
END COMPONENT;

--
-- stratixv_pll_refclk_select
--

COMPONENT stratixv_pll_refclk_select
    generic    (
        lpm_type    :    string    :=    "stratixv_pll_refclk_select";
        pll_auto_clk_sw_en    :    string    :=    "false";
        pll_clk_loss_edge    :    string    :=    "pll_clk_loss_both_edges";
        pll_clk_loss_sw_en    :    string    :=    "false";
        pll_clk_sw_dly    :    string    :=    "0 ps";
        pll_manu_clk_sw_en    :    string    :=    "false";
        pll_sw_refclk_src    :    string    :=    "clk_0";
        reference_clock_frequency_0    :    string    :=    "0 ps";
        reference_clock_frequency_1    :    string    :=    "0 ps"
    );
    port    (
        extswitch    :    in    std_logic;
        pllen    :    in    std_logic;
        refclk    :    in    std_logic_vector(1 downto 0);
        clk0bad    :    out    std_logic;
        clk1bad    :    out    std_logic;
        clkout    :    out    std_logic;
        pllclksel    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_termination_logic
--

COMPONENT stratixv_termination_logic
    generic    (
        lpm_type    :    string    :=    "stratixv_termination_logic";
		a_iob_oct_test : string := "a_iob_oct_test_off"
    );
    port    (
        s2pload : in std_logic := '0';
        serdata : in std_logic := '0';
        scanenable : in std_logic := '0';
        scanclk : in std_logic := '0';
        enser : in std_logic := '0';
        seriesterminationcontrol : out std_logic_vector(15 downto 0);
        parallelterminationcontrol : out std_logic_vector(15 downto 0)
    );
END COMPONENT;

--
-- stratixv_termination
--

COMPONENT stratixv_termination
    generic    (
        lpm_type    :    string    :=    "stratixv_termination";
			a_oct_cal_mode : string := "a_oct_cal_mode_none";
			a_oct_user_oct : string := "a_oct_user_oct_off";
			a_oct_nclrusr_inv : string := "a_oct_nclrusr_inv_off";
			a_oct_pwrdn : string := "a_oct_pwrdn_on";
			a_oct_intosc : string := "a_oct_intosc_none";
			a_oct_test_0 : string := "a_oct_test_0_off";
			a_oct_test_1 : string := "a_oct_test_1_off";
			a_oct_test_4 : string := "a_oct_test_4_off";
			a_oct_test_5 : string := "a_oct_test_5_off";
			a_oct_pllbiasen : string := "a_oct_pllbiasen_dis";
			a_oct_clkenusr_inv : string := "a_oct_clkenusr_inv_off";
			a_oct_enserusr_inv : string := "a_oct_enserusr_inv_off";
			a_oct_scanen_inv : string := "a_oct_scanen_inv_off";
			a_oct_vrefl : string := "a_oct_vrefl_m";
			a_oct_vrefh : string := "a_oct_vrefh_m";
			a_oct_rsmult : string := "a_oct_rsmult_1";
			a_oct_rsadjust : string := "a_oct_rsadjust_none";
			a_oct_calclr : string := "a_oct_calclr_off";
			a_oct_rshft_rup : string := "a_oct_rshft_rup_enable";
			a_oct_rshft_rdn : string := "a_oct_rshft_rdn_enable";
			a_oct_usermode : string := "false"
    );
    port    (
        rzqin : in std_logic := '0';
        enserusr : in std_logic := '0';
        nclrusr : in std_logic := '0';
        clkenusr : in std_logic := '0';
        clkusr : in std_logic := '0';
        scanen : in std_logic := '0';
        serdatafromcore : in std_logic := '0';
        scanclk : in std_logic := '0';
        otherenser : in std_logic_vector(9 downto 0) := (OTHERS => '0');
        serdatain : in std_logic := '0';
        serdataout : out std_logic;
        enserout : out std_logic;
        compoutrup : out std_logic;
        compoutrdn : out std_logic;
        serdatatocore : out std_logic;
        scanin  : in std_logic := '0';
        scanout : out std_logic;
        clkusrdftout : out std_logic
    );
END COMPONENT;

--
-- stratixv_asmiblock
--

COMPONENT stratixv_asmiblock
    generic    (
        lpm_type    :    string    :=    "stratixv_asmiblock"
    );
    port    (
        dclk    :    in    std_logic;
        sce    :    in    std_logic;
        oe    :    in    std_logic;
        data0out    :    in    std_logic;
        data1out    :    in    std_logic;
        data2out    :    in    std_logic;
        data3out    :    in    std_logic;
        data0oe    :    in    std_logic;
        data1oe    :    in    std_logic;
        data2oe    :    in    std_logic;
        data3oe    :    in    std_logic;
        data0in    :    out    std_logic;
        data1in    :    out    std_logic;
        data2in    :    out    std_logic;
        data3in    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_chipidblock
--

COMPONENT stratixv_chipidblock
    generic    (
        lpm_type    :    string    :=    "stratixv_chipidblock"
    );
    port    (
        clk    :    in    std_logic;
        shiftnld    :    in    std_logic;
        regout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_controller
--

COMPONENT stratixv_controller
    generic    (
        lpm_type    :    string    :=    "stratixv_controller"
    );
    port    (
        nceout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_crcblock
--

COMPONENT stratixv_crcblock
    generic    (
        oscillator_divider    :    integer    :=    256;
        lpm_type    :    string    :=    "stratixv_crcblock"
    );
    port    (
        clk    :    in    std_logic;
        shiftnld    :    in    std_logic;
        crcerror    :    out    std_logic;
        regout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_jtag
--

COMPONENT stratixv_jtag
    generic    (
        lpm_type    :    string    :=    "stratixv_jtag"
    );
    port    (
        tms    :    in    std_logic;
        tck    :    in    std_logic;
        tdi    :    in    std_logic;
        ntrst    :    in    std_logic;
        tdoutap    :    in    std_logic;
        tdouser    :    in    std_logic;
        tdo    :    out    std_logic;
        tmsutap    :    out    std_logic;
        tckutap    :    out    std_logic;
        tdiutap    :    out    std_logic;
        shiftuser    :    out    std_logic;
        clkdruser    :    out    std_logic;
        updateuser    :    out    std_logic;
        runidleuser    :    out    std_logic;
        usr1user    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_prblock
--

COMPONENT stratixv_prblock
    generic    (
        lpm_type    :    string    :=    "stratixv_prblock"
    );
    port    (
        clk    :    in    std_logic;
        corectl    :    in    std_logic;
        prrequest    :    in    std_logic;
        data    :    in    std_logic_vector(15 downto 0);
        externalrequest    :    out    std_logic;
        error    :    out    std_logic;
        ready    :    out    std_logic;
        done    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_rublock
--

COMPONENT stratixv_rublock
    generic    (
        sim_init_watchdog_value    :    integer    :=    0;
        sim_init_status    :    integer    :=    0;
        sim_init_config_is_application    :    string    :=    "false";
        sim_init_watchdog_enabled    :    string    :=    "false";
        lpm_type    :    string    :=    "stratixv_rublock"
    );
    port    (
        clk    :    in    std_logic;
        shiftnld    :    in    std_logic;
        captnupdt    :    in    std_logic;
        regin    :    in    std_logic;
        rsttimer    :    in    std_logic;
        rconfig    :    in    std_logic;
        regout    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_tsdblock
--

COMPONENT stratixv_tsdblock
    generic    (
        clock_divider_enable    :    string    :=    "on";
        clock_divider_value    :    integer    :=    40;
        sim_tsdcalo    :    integer    :=    0;
        lpm_type    :    string    :=    "stratixv_tsdblock"
    );
    port    (
        clk    :    in    std_logic;
        ce    :    in    std_logic;
        clr    :    in    std_logic;
        tsdcalo    :    out    std_logic_vector(7 downto 0);
        tsdcaldone    :    out    std_logic
    );
END COMPONENT;

--
-- stratixv_read_fifo
--

COMPONENT stratixv_read_fifo
    generic    (
        use_half_rate_read    :    string    :=    "false";
        sim_wclk_pre_delay    :    integer   :=    0
    );
    port    (
    	datain	:	in std_logic_vector(1 downto 0)	:= (OTHERS => '0');
        wclk	: in std_logic	:= '0';
        we	: in std_logic	:= '0';
        rclk : in std_logic	:= '0';
        re : in std_logic	:= '0';
        areset : in std_logic	:= '0';
        plus2 : in std_logic	:= '0';
        dataout : out std_logic_vector(3 downto 0)
    );
END COMPONENT;

--
-- stratixv_read_fifo_read_enable
--

COMPONENT stratixv_read_fifo_read_enable
    generic    (
        use_stalled_read_enable    :    string    :=    "false"
    );
    port    (
    	re	:	in std_logic	:= '1';
    	rclk	:	in std_logic	:= '0';
        plus2	:	in std_logic	:= '0';
        areset	:	in std_logic	:= '0';
        reout	: 	out std_logic;
        plus2out	:	out std_logic
    );
END COMPONENT;

--
-- stratixv_phy_clkbuf
--

COMPONENT stratixv_phy_clkbuf
    generic    (
        level1_mux    :    string    :=    "VALUE_FAST";
        level2_mux    :    string    :=    "VALUE_FAST"
    );
    port    (
        inclk    :    in    std_logic_vector(3 downto 0)	:= (OTHERS => '1');
        outclk    :    out    std_logic_vector(3 downto 0)
    );
END COMPONENT;

end stratixv_components;
