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
use work.hardcopyiv_atom_pack.all;

package hardcopyiv_components is


--
-- hardcopyiv_jtag
--

COMPONENT hardcopyiv_jtag
    generic (
        lpm_type : string := "hardcopyiv_jtag"
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
-- hardcopyiv_lcell_comb
--

COMPONENT hardcopyiv_lcell_comb
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
             dont_touch : string := "off";
             lpm_type : string := "hardcopyiv_lcell_comb";
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
-- hardcopyiv_routing_wire
--

COMPONENT hardcopyiv_routing_wire
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
-- hardcopyiv_lvds_transmitter
--

COMPONENT hardcopyiv_lvds_transmitter
    GENERIC ( channel_width                    : integer := 10;
              bypass_serializer                : String  := "false";
              invert_clock                     : String  := "false";
              use_falling_clock_edge           : String  := "false";
              use_serial_data_input            : String  := "false";
              use_post_dpa_serial_data_input   : String  := "false";
              is_used_as_outclk              : String  := "false";      -- HARDCOPYIV
              tx_output_path_delay_engineering_bits : Integer  := -1;   -- HARDCOPYIV
              enable_dpaclk_to_lvdsout    : string := "off";    -- HARDCOPYIV
              preemphasis_setting              : integer := 0;
              vod_setting                      : integer := 0;
              differential_drive               : integer := 0;
              lpm_type                         : string  := "hardcopyiv_lvds_transmitter";
              TimingChecksOn                   : Boolean := True;
              MsgOn                            : Boolean := DefGlitchMsgOn;
              XOn                              : Boolean := DefGlitchXOn;
              MsgOnChecks                      : Boolean := DefMsgOnChecks;
              XOnChecks                        : Boolean := DefXOnChecks;
              InstancePath                     : String := "*";
              tpd_clk0_dataout_posedge         : VitalDelayType01 := DefPropDelay01;
              tpd_clk0_dataout_negedge         : VitalDelayType01 := DefPropDelay01;
              tpd_serialdatain_dataout         : VitalDelayType01 := DefPropDelay01;
              tpd_dpaclkin_dataout             : VitalDelayType01 := DefPropDelay01;-- HARDCOPYIV
              tpd_postdpaserialdatain_dataout  : VitalDelayType01 := DefPropDelay01;
              tipd_clk0                        : VitalDelayType01 := DefpropDelay01;
              tipd_enable0                     : VitalDelayType01 := DefpropDelay01;
              tipd_datain                      : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01);
              tipd_serialdatain                : VitalDelayType01 := DefpropDelay01;
              tipd_dpaclkin                    : VitalDelayType01 := DefpropDelay01; -- HARDCOPYIV
              tipd_postdpaserialdatain         : VitalDelayType01 := DefpropDelay01
            );
    PORT    ( clk0                     : in std_logic;
              enable0                  : in std_logic := '0';
              datain                   : in std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
              serialdatain             : in std_logic := '0';
              postdpaserialdatain      : in std_logic := '0';
              dpaclkin                  : in std_logic := '0';-- HARDCOPYIV
              devclrn                  : in std_logic := '1';
              devpor                   : in std_logic := '1';
              dataout                  : out std_logic;
              serialfdbkout            : out std_logic
            );
END COMPONENT;

--
-- hardcopyiv_ram_block
--

COMPONENT hardcopyiv_ram_block
    GENERIC (
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
         enable_ecc               :  STRING := "false";
	 width_eccstatus          :  INTEGER := 3;
        data_interleave_width_in_bits  :  INTEGER := 1;    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        port_a_logical_ram_depth       :  INTEGER := 0;    
        port_a_logical_ram_width       :  INTEGER := 0;    
        port_a_first_address           :  INTEGER := 0;    
        port_a_last_address            :  INTEGER := 0;    
        port_a_first_bit_number        :  INTEGER := 0;    
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
        lpm_type                  : string := "hardcopyiv_ram_block";
        lpm_hint                  : string := "true";
        clk0_input_clock_enable  : STRING := "none"; -- ena0,ena2,none
        clk0_core_clock_enable   : STRING := "none"; -- ena0,ena2,none
        clk0_output_clock_enable : STRING := "none"; -- ena0,none
        clk1_input_clock_enable  : STRING := "none"; -- ena1,ena3,none
        clk1_core_clock_enable   : STRING := "none"; -- ena1,ena3,none
        clk1_output_clock_enable : STRING := "none"; -- ena1,none
	clock_duty_cycle_dependence : STRING := "On";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        mem_init2 : BIT_VECTOR := X"0";
        mem_init3 : BIT_VECTOR := X"0";
        mem_init4 : BIT_VECTOR := X"0";
         mem_init5 : BIT_VECTOR := X"0";
         mem_init6 : BIT_VECTOR := X"0";
         mem_init7 : BIT_VECTOR := X"0";
         mem_init8 : BIT_VECTOR := X"0";
         mem_init9 : BIT_VECTOR := X"0";
         mem_init10 : BIT_VECTOR := X"0";
         mem_init11 : BIT_VECTOR := X"0";
         mem_init12 : BIT_VECTOR := X"0";
         mem_init13 : BIT_VECTOR := X"0";
         mem_init14 : BIT_VECTOR := X"0";
         mem_init15 : BIT_VECTOR := X"0";
         mem_init16 : BIT_VECTOR := X"0";
         mem_init17 : BIT_VECTOR := X"0";
         mem_init18 : BIT_VECTOR := X"0";
         mem_init19 : BIT_VECTOR := X"0";
         mem_init20 : BIT_VECTOR := X"0";
         mem_init21 : BIT_VECTOR := X"0";
         mem_init22 : BIT_VECTOR := X"0";
         mem_init23 : BIT_VECTOR := X"0";
         mem_init24 : BIT_VECTOR := X"0";
         mem_init25 : BIT_VECTOR := X"0";
         mem_init26 : BIT_VECTOR := X"0";
         mem_init27 : BIT_VECTOR := X"0";
         mem_init28 : BIT_VECTOR := X"0";
         mem_init29 : BIT_VECTOR := X"0";
         mem_init30 : BIT_VECTOR := X"0";
         mem_init31 : BIT_VECTOR := X"0";
         mem_init32 : BIT_VECTOR := X"0";
         mem_init33 : BIT_VECTOR := X"0";
         mem_init34 : BIT_VECTOR := X"0";
         mem_init35 : BIT_VECTOR := X"0";
         mem_init36 : BIT_VECTOR := X"0";
         mem_init37 : BIT_VECTOR := X"0";
         mem_init38 : BIT_VECTOR := X"0";
         mem_init39 : BIT_VECTOR := X"0";
         mem_init40 : BIT_VECTOR := X"0";
         mem_init41 : BIT_VECTOR := X"0";
         mem_init42 : BIT_VECTOR := X"0";
         mem_init43 : BIT_VECTOR := X"0";
         mem_init44 : BIT_VECTOR := X"0";
         mem_init45 : BIT_VECTOR := X"0";
         mem_init46 : BIT_VECTOR := X"0";
         mem_init47 : BIT_VECTOR := X"0";
         mem_init48 : BIT_VECTOR := X"0";
         mem_init49 : BIT_VECTOR := X"0";
         mem_init50 : BIT_VECTOR := X"0";
         mem_init51 : BIT_VECTOR := X"0";
         mem_init52 : BIT_VECTOR := X"0";
         mem_init53 : BIT_VECTOR := X"0";
         mem_init54 : BIT_VECTOR := X"0";
         mem_init55 : BIT_VECTOR := X"0";
         mem_init56 : BIT_VECTOR := X"0";
         mem_init57 : BIT_VECTOR := X"0";
         mem_init58 : BIT_VECTOR := X"0";
         mem_init59 : BIT_VECTOR := X"0";
         mem_init60 : BIT_VECTOR := X"0";
         mem_init61 : BIT_VECTOR := X"0";
         mem_init62 : BIT_VECTOR := X"0";
         mem_init63 : BIT_VECTOR := X"0";
         mem_init64 : BIT_VECTOR := X"0";
         mem_init65 : BIT_VECTOR := X"0";
         mem_init66 : BIT_VECTOR := X"0";
         mem_init67 : BIT_VECTOR := X"0";
         mem_init68 : BIT_VECTOR := X"0";
         mem_init69 : BIT_VECTOR := X"0";
         mem_init70 : BIT_VECTOR := X"0";
         mem_init71 : BIT_VECTOR := X"0";
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
-- hardcopyiv_ff
--

COMPONENT hardcopyiv_ff
    generic (
             power_up : string := "low";
             x_on_violation : string := "on";
             lpm_type : string := "hardcopyiv_ff";
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
-- hardcopyiv_clkselect
--

COMPONENT hardcopyiv_clkselect
    generic (
             lpm_type : STRING := "hardcopyiv_clkselect";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
             tpd_inclk_outclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
             tpd_clkselect_outclk : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01)
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          outclk : out std_logic
          );    
END COMPONENT;

--
-- hardcopyiv_clkena
--

COMPONENT hardcopyiv_clkena
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "hardcopyiv_clkena";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01
             );
    port (
          inclk : in std_logic := '0';
          ena : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          enaout : out std_logic;
          outclk : out std_logic
          );    
END COMPONENT;

--
-- hardcopyiv_hram
--

COMPONENT hardcopyiv_hram
   GENERIC (
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
      tipd_ena0                : VitalDelayType01 := DefpropDelay01;
      tipd_clk1                : VitalDelayType01 := DefpropDelay01;
      tipd_devclrn                : VitalDelayType01 := DefpropDelay01;
      tipd_clr0                : VitalDelayType01 := DefpropDelay01;
      tipd_clk0                : VitalDelayType01 := DefpropDelay01;
      tipd_portabyteenamasks               :VitalDelayArrayType01(1 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_portadatain               :VitalDelayArrayType01(19 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_clr1                : VitalDelayType01 := DefpropDelay01;
      tipd_devpor                : VitalDelayType01 := DefpropDelay01;
      tipd_ena1                : VitalDelayType01 := DefpropDelay01;
      tipd_ena2                : VitalDelayType01 := DefpropDelay01;
      tipd_portaaddr               :VitalDelayArrayType01(5 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_portbaddr               :VitalDelayArrayType01(5 DOWNTO 0)   := (OTHERS => DefPropDelay01);
      tipd_ena3                : VitalDelayType01 := DefpropDelay01;
      tpd_portbaddr_portbdataout : VitalDelayType01 := DefPropDelay01;
      logical_ram_name                  : STRING := "hram";
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
      port_b_address_clock          : STRING := "none";
      port_b_address_clear          : STRING := "none";
      port_b_data_out_clock         : STRING := "none";
      port_b_data_out_clear         : STRING := "none";
      lpm_type                      : STRING := "hardcopyiv_hram";
      lpm_hint                      : STRING := "true";
      mem_init0                     : BIT_VECTOR := X"0";
      mixed_port_feed_through_mode  : STRING := "dont_care"
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
      ena3                          : IN STD_LOGIC := '1';
      clr0                          : IN STD_LOGIC := '0';
      clr1                          : IN STD_LOGIC := '0';
      devclrn                       : IN STD_LOGIC := '1';
      devpor                        : IN STD_LOGIC := '1';
      portbdataout                  : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
   );
END COMPONENT;

--
-- hardcopyiv_io_ibuf
--

COMPONENT hardcopyiv_io_ibuf
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
             lpm_type                :  string := "hardcopyiv_io_ibuf"
            );    
    PORT (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          dynamicterminationcontrol   : IN std_logic := '0';                                 
          o                       : OUT std_logic
         );       
END COMPONENT;

--
-- hardcopyiv_io_obuf
--

COMPONENT hardcopyiv_io_obuf
    GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tipd_oe                          : VitalDelayType01 := DefPropDelay01;
             tipd_dynamicterminationcontrol   : VitalDelayType01 := DefPropDelay01;  
             tipd_seriesterminationcontrol    : VitalDelayArrayType01(13 DOWNTO 0) := (others => DefPropDelay01);   
             tipd_parallelterminationcontrol  : VitalDelayArrayType01(13 DOWNTO 0) := (others => DefPropDelay01 );   
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
             lpm_type                         :  string := "hardcopyiv_io_obuf"
            );               
    PORT (
           i                       : IN std_logic := '0';                                                 
           oe                      : IN std_logic := '1';                                                 
           dynamicterminationcontrol   : IN std_logic := '0';                                 
           seriesterminationcontrol    : IN std_logic_vector(13 DOWNTO 0) := (others => '0');     
           parallelterminationcontrol  : IN std_logic_vector(13 DOWNTO 0) := (others => '0');   
           devoe                       : IN std_logic := '1';
           o                       : OUT std_logic;                                                       
           obar                    : OUT std_logic
         );                                                      
END COMPONENT;

--
-- hardcopyiv_ddio_in
--

COMPONENT hardcopyiv_ddio_in
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
            lpm_type                           :  string := "hardcopyiv_ddio_in"                                   
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
-- hardcopyiv_ddio_oe
--

COMPONENT hardcopyiv_ddio_oe
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
            lpm_type              :  string := "hardcopyiv_ddio_oe"
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
-- hardcopyiv_ddio_out
--

COMPONENT hardcopyiv_ddio_out
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
            lpm_type                           :  string := "hardcopyiv_ddio_out"
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
-- hardcopyiv_termination
--

COMPONENT hardcopyiv_termination
    GENERIC (
        runtime_control                :  STRING := "false";    
        allow_serial_data_from_core    :  STRING := "false";    
        power_down                     :  STRING := "true";    
        enable_parallel_termination    :  STRING := "false";    
        test_mode                      :  STRING := "false"; 
        enable_calclk_divider          :  STRING := "false";  -- replaced by below
        clock_divider_enable           :  STRING := "false"; 
        enable_pwrupmode_enser_for_usrmode :  STRING := "false"; 
        bypass_enser_logic             :  STRING := "false"; 
        bypass_rt_calclk               :  STRING := "false"; 
        enable_rt_scan_mode            :  STRING := "false"; 
        enable_loopback                :  STRING := "false";   
        force_rtcalen_for_pllbiasen    :  STRING := "false"; 
        enable_rt_sm_loopback          :  STRING := "false";   
        select_vrefl_values            :  integer := 0;
        select_vrefh_values            :  integer := 0;
        divide_intosc_by               :  integer := 2;
        use_usrmode_clear_for_configmode : STRING := "false"; 
        tipd_rup                       : VitalDelayType01 := DefpropDelay01;
        tipd_rdn                       : VitalDelayType01 := DefpropDelay01;
        tipd_terminationclock          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationclear          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationenable         : VitalDelayType01 := DefpropDelay01;
        tipd_serializerenable          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationcontrolin      : VitalDelayType01 := DefpropDelay01;
        tipd_otherserializerenable     : VitalDelayArrayType01(8 downto 0) := (OTHERS => DefPropDelay01);
        lpm_type                       :  STRING := "hardcopyiv_termination");    
    PORT (
        rup                     : IN std_logic := '0';   
        rdn                     : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        terminationclear        : IN std_logic := '0';   
        terminationenable       : IN std_logic := '1';   
        serializerenable        : IN std_logic := '0';   
        terminationcontrolin    : IN std_logic := '0';   
        scanin                  : IN std_logic := '0';   
        scanen                  : IN std_logic := '0';   
        otherserializerenable   : IN std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');   
        devclrn                 : IN std_logic := '1';   
        devpor                  : IN std_logic := '1';   
        incrup                  : OUT std_logic;   
        incrdn                  : OUT std_logic;   
        serializerenableout     : OUT std_logic;   
        terminationcontrol      : OUT std_logic;   
        terminationcontrolprobe : OUT std_logic;   
        scanout                 : OUT std_logic;   
        shiftregisterprobe      : OUT std_logic);   
END COMPONENT;

--
-- hardcopyiv_termination_logic
--

COMPONENT hardcopyiv_termination_logic
    GENERIC (
        tipd_serialloadenable          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationclock          : VitalDelayType01 := DefpropDelay01;
        tipd_parallelloadenable        : VitalDelayType01 := DefpropDelay01;
        tipd_terminationdata           : VitalDelayType01 := DefpropDelay01;
        test_mode                      : string := "false";    
        lpm_type                       : string := "hardcopyiv_termination_logic");    
    PORT (
        serialloadenable        : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        parallelloadenable      : IN std_logic := '0';   
        terminationdata         : IN std_logic := '0';   
        devclrn                 : IN std_logic := '1';   
        devpor                  : IN std_logic := '1';   
        seriesterminationcontrol   : OUT std_logic_vector(13 DOWNTO 0);   
        parallelterminationcontrol : OUT std_logic_vector(13 DOWNTO 0));   
END COMPONENT;

--
-- hardcopyiv_dll
--

COMPONENT hardcopyiv_dll
    GENERIC ( 
    input_frequency          : string := "0 ps";
    delay_buffer_mode        : string := "low";
    delay_chain_length       : integer := 12;
    delayctrlout_mode        : string := "normal";
    jitter_reduction         : string := "false";
    use_upndnin              : string := "false";
    use_upndninclkena        : string := "false";
    dual_phase_comparators   : string := "true";
    sim_valid_lock           : integer := 16;
    sim_valid_lockcount      : integer := 0;  -- 10000 = 1000 + 100*dllcounter
    sim_low_buffer_intrinsic_delay  : integer := 350;
    sim_high_buffer_intrinsic_delay : integer := 175;
    sim_buffer_delay_increment      : integer := 10;
    static_delay_ctrl        : integer := 0;
    lpm_type                 : string := "hardcopyiv_dll";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_upndnin             : VitalDelayType01 := DefpropDelay01;
    tipd_upndninclkena       : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tsetup_upndnin_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_upndnin_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tsetup_upndninclkena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
    thold_upndninclkena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_upndnout_posedge                : VitalDelayType01 := DefPropDelay01;
    tpd_clk_delayctrlout_posedge            : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );
    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              upndnin                  : IN std_logic := '1';
              upndninclkena            : IN std_logic := '1';
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '0';
              delayctrlout             : OUT std_logic_vector(5 DOWNTO 0);
              dqsupdate                : OUT std_logic;
              offsetdelayctrlout       : OUT std_logic_vector(5 DOWNTO 0);
              offsetdelayctrlclkout    : OUT std_logic;
              upndnout                 : OUT std_logic	
            );
END COMPONENT;

--
-- hardcopyiv_dll_offset_ctrl
--

COMPONENT hardcopyiv_dll_offset_ctrl
    GENERIC ( 
    use_offset               : string := "false";
    static_offset            : string := "0";
    delay_buffer_mode        : string := "low";
    lpm_type                 : string := "hardcopyiv_dll_offset_ctrl";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_offset              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_offsetdelayctrlin   : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_addnsub             : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tsetup_offset_clk_noedge_posedge        : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_offset_clk_noedge_posedge         : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_addnsub_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_addnsub_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_offsetctrlout_posedge           : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );
    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              offsetdelayctrlin        : IN std_logic_vector(5 DOWNTO 0) := "000000";
              offset                   : IN std_logic_vector(5 DOWNTO 0) := "000000";
              addnsub                  : IN std_logic := '1';
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '0';
              offsettestout            : OUT std_logic_vector(5 DOWNTO 0);
              offsetctrlout            : OUT std_logic_vector(5 DOWNTO 0)
            );
END COMPONENT;

--
-- hardcopyiv_dqs_delay_chain
--

COMPONENT hardcopyiv_dqs_delay_chain
     GENERIC ( 
         dqs_input_frequency             : string := "unused" ;
         use_phasectrlin                 : string := "false";
         phase_setting                   : integer := 0;
         delay_buffer_mode               : string := "low";
         dqs_phase_shift                 : integer := 0;
         dqs_offsetctrl_enable           : string := "false";
         dqs_ctrl_latches_enable         : string := "false";
         test_enable                     : string := "false";
         test_select                     : integer := 0;
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;
         lpm_type                        : string := "hardcopyiv_dqs_delay_chain";
         tipd_dqsin               : VitalDelayType01 := DefpropDelay01;
         tipd_aload               : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_offsetctrlin        : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_dqsupdateen         : VitalDelayType01 := DefpropDelay01;
         tipd_phasectrlin         : VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
         tpd_dqsin_dqsbusout      : VitalDelayType01 := DefPropDelay01;
         tsetup_delayctrlin_dqsupdateen_noedge_posedge  : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         thold_delayctrlin_dqsupdateen_noedge_posedge   : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         tsetup_offsetctrlin_dqsupdateen_noedge_posedge : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         thold_offsetctrlin_dqsupdateen_noedge_posedge  : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         dqsin        : IN std_logic := '0';
         delayctrlin  : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         offsetctrlin : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         dqsupdateen  : IN std_logic := '1';
         phasectrlin  : IN std_logic_vector(2 downto 0) := (OTHERS => '0');
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dqsbusout    : OUT std_logic;
         dffin        : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_dqs_enable
--

COMPONENT hardcopyiv_dqs_enable
    GENERIC ( 
        lpm_type               : string := "hardcopyiv_dqs_enable";
        tipd_dqsin               : VitalDelayType01 := DefpropDelay01;
        tipd_dqsenable           : VitalDelayType01 := DefpropDelay01;
        tpd_dqsin_dqsbusout      : VitalDelayType01 := DefPropDelay01;
        tpd_dqsenable_dqsbusout  : VitalDelayType01 := DefPropDelay01;
        TimingChecksOn           : Boolean := True;
        MsgOn                    : Boolean := DefGlitchMsgOn;
        XOn                      : Boolean  := DefGlitchXOn;
        MsgOnChecks              : Boolean := DefMsgOnChecks;
        XOnChecks                : Boolean := DefXOnChecks;
        InstancePath             : String := "*"   
    );
    PORT (
        dqsin        : IN std_logic := '0';
        dqsenable    : IN std_logic := '1';
        devclrn      : IN std_logic := '1';
        devpor       : IN std_logic := '1';
        dqsbusout    : OUT std_logic
    );
END COMPONENT;

--
-- hardcopyiv_dqs_enable_ctrl
--

COMPONENT hardcopyiv_dqs_enable_ctrl
     GENERIC ( 
         use_phasectrlin                 : string := "true";
         phase_setting                   : integer := 0;
         delay_buffer_mode               : string := "high";
         level_dqs_enable                : string := "false";
         delay_dqs_enable_by_half_cycle  : string := "false";
         add_phase_transfer_reg          : string := "false";
         invert_phase                    : string := "false";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;    
         lpm_type                        : string := "hardcopyiv_dqs_enable_ctrl";
         tipd_dqsenablein         : VitalDelayType01 := DefpropDelay01;
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_enaphasetransferreg : VitalDelayType01 := DefpropDelay01;
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         dqsenablein         : IN std_logic := '1';
         clk                 : IN std_logic := '0';
         delayctrlin         : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin         : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         enaphasetransferreg : IN std_logic := '0';
         phaseinvertctrl     : IN std_logic := '0';
         devclrn             : IN std_logic := '1';
         devpor              : IN std_logic := '1';        
         dqsenableout        : OUT std_logic;
         dffin               : OUT std_logic;
         dffextenddqsenable  : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_delay_chain
--

COMPONENT hardcopyiv_delay_chain
     GENERIC ( 
         sim_delayctrlin_rising_delay_0   : integer := 0;
         sim_delayctrlin_rising_delay_1   : integer := 50;
         sim_delayctrlin_rising_delay_2   : integer := 100;
         sim_delayctrlin_rising_delay_3   : integer := 150;
         sim_delayctrlin_rising_delay_4   : integer := 200;
         sim_delayctrlin_rising_delay_5   : integer := 250;
         sim_delayctrlin_rising_delay_6   : integer := 300;
         sim_delayctrlin_rising_delay_7   : integer := 350;
         sim_delayctrlin_rising_delay_8   : integer := 400;
         sim_delayctrlin_rising_delay_9   : integer := 450;
         sim_delayctrlin_rising_delay_10  : integer := 500;
         sim_delayctrlin_rising_delay_11  : integer := 550;
         sim_delayctrlin_rising_delay_12  : integer := 600;
         sim_delayctrlin_rising_delay_13  : integer := 650;
         sim_delayctrlin_rising_delay_14  : integer := 700;
         sim_delayctrlin_rising_delay_15  : integer := 750;
         sim_delayctrlin_falling_delay_0  : integer := 0;
         sim_delayctrlin_falling_delay_1  : integer := 50;
         sim_delayctrlin_falling_delay_2  : integer := 100;
         sim_delayctrlin_falling_delay_3  : integer := 150;
         sim_delayctrlin_falling_delay_4  : integer := 200;
         sim_delayctrlin_falling_delay_5  : integer := 250;
         sim_delayctrlin_falling_delay_6  : integer := 300;
         sim_delayctrlin_falling_delay_7  : integer := 350;
         sim_delayctrlin_falling_delay_8  : integer := 400;
         sim_delayctrlin_falling_delay_9  : integer := 450;
         sim_delayctrlin_falling_delay_10  : integer := 500;
         sim_delayctrlin_falling_delay_11  : integer := 550;
         sim_delayctrlin_falling_delay_12  : integer := 600;
         sim_delayctrlin_falling_delay_13  : integer := 650;
         sim_delayctrlin_falling_delay_14  : integer := 700;
         sim_delayctrlin_falling_delay_15  : integer := 750;
         use_delayctrlin                   : string := "true";
         delay_setting                     : integer := 0;
         sim_finedelayctrlin_falling_delay_0 : integer := 0;
         sim_finedelayctrlin_falling_delay_1 : integer := 25;
         sim_finedelayctrlin_rising_delay_0  : integer := 0;
         sim_finedelayctrlin_rising_delay_1  : integer := 25;
         use_finedelayctrlin                 : string  := "false";
         lpm_type                          : string := "hardcopyiv_delay_chain";
         tipd_datain              : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tpd_datain_dataout       : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         datain       : IN std_logic := '0';
         delayctrlin  : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         finedelayctrlin : IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dataout      : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_io_clock_divider
--

COMPONENT hardcopyiv_io_clock_divider
     GENERIC ( 
         use_phasectrlin                 : string := "true";
         phase_setting                   : integer := 0;     
         delay_buffer_mode               : string := "high";
         use_masterin                    : string := "false";
         invert_phase                    : string := "false";    
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;    
         lpm_type                        : string := "hardcopyiv_io_clock_divider";
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_phaseselect         : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         tipd_masterin            : VitalDelayType01 := DefpropDelay01;
         tpd_clk_clkout           : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         clk             : IN std_logic := '0';
         phaseselect     : IN std_logic := '0';
         delayctrlin     : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin     : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         phaseinvertctrl : IN std_logic := '0';
         masterin        : IN std_logic := '0';
         devclrn         : IN std_logic := '1';
         devpor          : IN std_logic := '1';
         clkout          : OUT std_logic;
         slaveout        : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_output_phase_alignment
--

COMPONENT hardcopyiv_output_phase_alignment
     GENERIC ( 
         operation_mode                   : string := "ddio_out";
         use_phasectrlin                  : string := "true";
         phase_setting                    : integer := 0;      
         delay_buffer_mode                : string := "high";
         power_up                         : string := "low";
         async_mode                       : string := "none";
         sync_mode                        : string := "none";
         add_output_cycle_delay           : string := "false";
         use_delayed_clock                : string := "false";
         add_phase_transfer_reg           : string := "false"; 
         use_phasectrl_clock              : string := "true";   
         use_primary_clock                : string := "true";   
         invert_phase                     : string := "false";  
         bypass_input_register            : string := "false";  
         phase_setting_for_delayed_clock  : integer := 2;           
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;  
         duty_cycle_delay_mode : string := "none";
         sim_dutycycledelayctrlin_falling_delay_0 : integer :=  0 ;
         sim_dutycycledelayctrlin_falling_delay_1 : integer :=  25 ;
         sim_dutycycledelayctrlin_falling_delay_10 : integer :=  250 ;
         sim_dutycycledelayctrlin_falling_delay_11 : integer :=  275 ;
         sim_dutycycledelayctrlin_falling_delay_12 : integer :=  300 ;
         sim_dutycycledelayctrlin_falling_delay_13 : integer :=  325 ;
         sim_dutycycledelayctrlin_falling_delay_14 : integer :=  350 ;
         sim_dutycycledelayctrlin_falling_delay_15 : integer :=  375 ;
         sim_dutycycledelayctrlin_falling_delay_2 : integer :=  50 ;
         sim_dutycycledelayctrlin_falling_delay_3 : integer :=  75 ;
         sim_dutycycledelayctrlin_falling_delay_4 : integer :=  100 ;
         sim_dutycycledelayctrlin_falling_delay_5 : integer :=  125 ;
         sim_dutycycledelayctrlin_falling_delay_6 : integer :=  150 ;
         sim_dutycycledelayctrlin_falling_delay_7 : integer :=  175 ;
         sim_dutycycledelayctrlin_falling_delay_8 : integer :=  200 ;
         sim_dutycycledelayctrlin_falling_delay_9 : integer :=  225 ;
         sim_dutycycledelayctrlin_rising_delay_0 : integer :=  0 ;
         sim_dutycycledelayctrlin_rising_delay_1 : integer :=  25 ;
         sim_dutycycledelayctrlin_rising_delay_10 : integer :=  250 ;
         sim_dutycycledelayctrlin_rising_delay_11 : integer :=  275 ;
         sim_dutycycledelayctrlin_rising_delay_12 : integer :=  300 ;
         sim_dutycycledelayctrlin_rising_delay_13 : integer :=  325 ;
         sim_dutycycledelayctrlin_rising_delay_14 : integer :=  350 ;
         sim_dutycycledelayctrlin_rising_delay_15 : integer :=  375 ;
         sim_dutycycledelayctrlin_rising_delay_2 : integer :=  50 ;
         sim_dutycycledelayctrlin_rising_delay_3 : integer :=  75 ;
         sim_dutycycledelayctrlin_rising_delay_4 : integer :=  100 ;
         sim_dutycycledelayctrlin_rising_delay_5 : integer :=  125 ;
         sim_dutycycledelayctrlin_rising_delay_6 : integer :=  150 ;
         sim_dutycycledelayctrlin_rising_delay_7 : integer :=  175 ;
         sim_dutycycledelayctrlin_rising_delay_8 : integer :=  200 ;
         sim_dutycycledelayctrlin_rising_delay_9 : integer :=  225 ;
         lpm_type                        : string := "hardcopyiv_output_phase_alignment";
         tipd_datain              : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_areset              : VitalDelayType01 := DefpropDelay01;
         tipd_sreset              : VitalDelayType01 := DefpropDelay01;
         tipd_clkena              : VitalDelayType01 := DefpropDelay01;
         tipd_enaoutputcycledelay : VitalDelayType01 := DefpropDelay01;
         tipd_enaphasetransferreg : VitalDelayType01 := DefpropDelay01;
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         datain              : IN std_logic_vector(1 downto 0) := (OTHERS => '0');
         clk                 : IN std_logic := '0';
         delayctrlin         : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin         : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         areset              : IN std_logic := '0';
         sreset              : IN std_logic := '0';
         clkena              : IN std_logic := '1';
         enaoutputcycledelay : IN std_logic := '0';
         enaphasetransferreg : IN std_logic := '0';
         phaseinvertctrl     : IN std_logic := '0';
         devclrn             : IN std_logic := '1';
         devpor              : IN std_logic := '1';    
         delaymode           : IN std_logic := '0'; -- new in STRATIXIV: ww30.2008
         dutycycledelayctrlin: IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         dataout             : OUT std_logic;
         dffin               : OUT std_logic_vector(1 downto 0);
         dff1t               : OUT std_logic_vector(1 downto 0);
         dffddiodataout      : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_input_phase_alignment
--

COMPONENT hardcopyiv_input_phase_alignment
     GENERIC ( 
         use_phasectrlin                 : string := "true";
         phase_setting                   : integer := 0;
         delay_buffer_mode               : string := "high";
         power_up                        : string := "low";
         async_mode                      : string := "none";
         add_input_cycle_delay           : string := "false";
         bypass_output_register          : string := "false";
         add_phase_transfer_reg          : string := "false";
         invert_phase                    : string := "false";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;        
         lpm_type                 : string := "hardcopyiv_input_phase_alignment";
         tipd_datain              : VitalDelayType01 := DefpropDelay01;
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_areset              : VitalDelayType01 := DefpropDelay01;
         tipd_enainputcycledelay  : VitalDelayType01 := DefpropDelay01;
         tipd_enaphasetransferreg : VitalDelayType01 := DefpropDelay01;
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         datain              : IN std_logic := '0';
         clk                 : IN std_logic := '0';
         delayctrlin         : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin         : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         areset              : IN std_logic := '0';
         enainputcycledelay  : IN std_logic := '0';
         enaphasetransferreg : IN std_logic := '0';
         phaseinvertctrl     : IN std_logic := '0';
         devclrn             : IN std_logic := '1';
         devpor              : IN std_logic := '1';
         dataout             : OUT std_logic;
         dffin               : OUT std_logic;
         dff1t               : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_half_rate_input
--

COMPONENT hardcopyiv_half_rate_input
     GENERIC ( 
         power_up           : string := "low";
         async_mode         : string := "none";
         use_dataoutbypass  : string := "false";
         lpm_type           : string := "hardcopyiv_half_rate_input";
         tipd_datain              : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
         tipd_directin            : VitalDelayType01 := DefpropDelay01;
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_areset              : VitalDelayType01 := DefpropDelay01;
         tipd_dataoutbypass       : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         datain       : IN std_logic_vector(1 downto 0) := (OTHERS => '0');
         directin     : IN std_logic := '0';
         clk          : IN std_logic := '0';
         areset       : IN std_logic := '0';
         dataoutbypass: IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dataout      : OUT std_logic_vector(3 downto 0);
         dffin        : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_io_config
--

COMPONENT hardcopyiv_io_config
     GENERIC ( 
         enhanced_mode      : string := "false";
         lpm_type           : string := "hardcopyiv_io_config";
         tipd_datain                       : VitalDelayType01 := DefpropDelay01;
         tipd_clk                          : VitalDelayType01 := DefpropDelay01;
         tipd_ena                          : VitalDelayType01 := DefpropDelay01;
         tipd_update                       : VitalDelayType01 := DefpropDelay01;
         tsetup_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
         thold_datain_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
         tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         datain       : IN std_logic := '0';
         clk          : IN std_logic := '0';
         ena          : IN std_logic := '1';
         update       : IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dutycycledelaymode                 : OUT std_logic;
         dutycycledelaysettings             : OUT std_logic_vector(3 downto 0);
         outputfinedelaysetting1            : OUT std_logic;
         outputfinedelaysetting2            : OUT std_logic;
         outputonlydelaysetting2            : OUT std_logic_vector(2 downto 0);
         outputonlyfinedelaysetting2        : OUT std_logic;
         padtoinputregisterfinedelaysetting : OUT std_logic;
         padtoinputregisterdelaysetting : OUT std_logic_vector(3 downto 0);
         outputdelaysetting1            : OUT std_logic_vector(3 downto 0);
         outputdelaysetting2            : OUT std_logic_vector(2 downto 0);
         dataout                        : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_dqs_config
--

COMPONENT hardcopyiv_dqs_config
     GENERIC ( 
         enhanced_mode            : string := "false";
         lpm_type                 : string := "hardcopyiv_dqs_config";
         tipd_datain                       : VitalDelayType01 := DefpropDelay01;
         tipd_clk                          : VitalDelayType01 := DefpropDelay01;
         tipd_ena                          : VitalDelayType01 := DefpropDelay01;
         tipd_update                       : VitalDelayType01 := DefpropDelay01;
         tsetup_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
         thold_datain_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
         tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     PORT (
         datain       : IN std_logic := '0';
         clk          : IN std_logic := '0';
         ena          : IN std_logic := '0';
         update       : IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dqsbusoutfinedelaysetting   : OUT std_logic;  -- new in STRATIXIV
         dqsenablefinedelaysetting   : OUT std_logic;  -- new in STRATIXIV
         dqsbusoutdelaysetting     : OUT std_logic_vector(3 downto 0);          
         dqsinputphasesetting      : OUT std_logic_vector(2 downto 0);
         dqsenablectrlphasesetting : OUT std_logic_vector(3 downto 0);
         dqsoutputphasesetting     : OUT std_logic_vector(3 downto 0);
         dqoutputphasesetting      : OUT std_logic_vector(3 downto 0);
         resyncinputphasesetting   : OUT std_logic_vector(3 downto 0);
         dividerphasesetting       : OUT std_logic;
         enaoctcycledelaysetting   : OUT std_logic;
         enainputcycledelaysetting : OUT std_logic;
         enaoutputcycledelaysetting: OUT std_logic;
         dqsenabledelaysetting     : OUT std_logic_vector(2 downto 0);
         octdelaysetting1          : OUT std_logic_vector(3 downto 0);
         octdelaysetting2          : OUT std_logic_vector(2 downto 0);
         enadataoutbypass          : OUT std_logic;
         enadqsenablephasetransferreg : OUT std_logic;
         enaoctphasetransferreg    : OUT std_logic;       
         enaoutputphasetransferreg : OUT std_logic;   
         enainputphasetransferreg  : OUT std_logic;
         resyncinputphaseinvert    : OUT std_logic;
         dqsenablectrlphaseinvert  : OUT std_logic;
         dqoutputphaseinvert       : OUT std_logic;        
         dqsoutputphaseinvert      : OUT std_logic; 
         dataout                   : OUT std_logic
     );
END COMPONENT;

--
-- hardcopyiv_mac_mult
--

COMPONENT hardcopyiv_mac_mult
   GENERIC (
            dataa_width                    :  integer := 18;
            datab_width                    :  integer := 18;
            dataa_clock                    :  string := "none";
            datab_clock                    :  string := "none";
            signa_clock                    :  string := "none";
            signb_clock                    :  string := "none";
            scanouta_clock                 :  string := "none";
            dataa_clear                    :  string := "none";
            datab_clear                    :  string := "none";
            signa_clear                    :  string := "none";
            signb_clear                    :  string := "none";
            scanouta_clear                 :  string := "none";
            signa_internally_grounded      :  string := "false";
            signb_internally_grounded      :  string := "false";
            lpm_type                       :  string := "hardcopyiv_mac_mult"
           );
   PORT (
         dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '1');
         datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '1');
         signa                   : IN std_logic := '1';
         signb                   : IN std_logic := '1';
         clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
         aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
         ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');
         dataout                 : OUT std_logic_vector(dataa_width + datab_width - 1 DOWNTO 0);
         scanouta                : OUT std_logic_vector(dataa_width - 1 DOWNTO 0);
         devclrn                 : IN std_logic := '1';
         devpor                  : IN std_logic := '1'
        );
END COMPONENT;

--
-- hardcopyiv_mac_out
--

COMPONENT hardcopyiv_mac_out
    GENERIC (
            operation_mode                 :  string := "output_only";
            dataa_width                    :  integer := 1;
            datab_width                    :  integer := 1;
            datac_width                    :  integer := 1;
            datad_width                    :  integer := 1;
            chainin_width                  :  integer := 1;
            round_width                    :  integer := 15;
            round_chain_out_width          :  integer := 15;
            saturate_width                 :  integer := 15;
            saturate_chain_out_width       :  integer := 15;
            first_adder0_clock             :  string := "none";
            first_adder0_clear             :  string := "none";
            first_adder1_clock             :  string := "none";
            first_adder1_clear             :  string := "none";
            second_adder_clock             :  string := "none";
            second_adder_clear             :  string := "none";
            output_clock                   :  string := "none";
            output_clear                   :  string := "none";
            signa_clock                    :  string := "none";
            signa_clear                    :  string := "none";
            signb_clock                    :  string := "none";
            signb_clear                    :  string := "none";
            round_clock                    :  string := "none";
            round_clear                    :  string := "none";
            roundchainout_clock            :  string := "none";
            roundchainout_clear            :  string := "none";
            saturate_clock                 :  string := "none";
            saturate_clear                 :  string := "none";
            saturatechainout_clock         :  string := "none";
            saturatechainout_clear         :  string := "none";
            zeroacc_clock                  :  string := "none";
            zeroacc_clear                  :  string := "none";
            zeroloopback_clock             :  string := "none";
            zeroloopback_clear             :  string := "none";
            rotate_clock                   :  string := "none";
            rotate_clear                   :  string := "none";
            shiftright_clock               :  string := "none";
            shiftright_clear               :  string := "none";
            signa_pipeline_clock           :  string := "none";
            signa_pipeline_clear           :  string := "none";
            signb_pipeline_clock           :  string := "none";
            signb_pipeline_clear           :  string := "none";
            round_pipeline_clock           :  string := "none";
            round_pipeline_clear           :  string := "none";
            roundchainout_pipeline_clock   :  string := "none";
            roundchainout_pipeline_clear   :  string := "none";
            saturate_pipeline_clock        :  string := "none";
            saturate_pipeline_clear        :  string := "none";
            saturatechainout_pipeline_clock:  string := "none";
            saturatechainout_pipeline_clear:  string := "none";
            zeroacc_pipeline_clock         :  string := "none";
            zeroacc_pipeline_clear         :  string := "none";
            zeroloopback_pipeline_clock    :  string := "none";
            zeroloopback_pipeline_clear    :  string := "none";
            rotate_pipeline_clock          :  string := "none";
            rotate_pipeline_clear          :  string := "none";
            shiftright_pipeline_clock      :  string := "none";
            shiftright_pipeline_clear      :  string := "none";
            roundchainout_output_clock     :  string := "none";
            roundchainout_output_clear     :  string := "none";
            saturatechainout_output_clock  :  string := "none";
            saturatechainout_output_clear  :  string := "none";
            zerochainout_output_clock      :  string := "none";
            zerochainout_output_clear      :  string := "none";
            zeroloopback_output_clock      :  string := "none";
            zeroloopback_output_clear      :  string := "none";
            rotate_output_clock            :  string := "none";
            rotate_output_clear            :  string := "none";
            shiftright_output_clock        :  string := "none";
            shiftright_output_clear        :  string := "none";
            first_adder0_mode              :  string := "add";
            first_adder1_mode              :  string := "add";
            acc_adder_operation            :  string := "add";
            round_mode                     :  string := "nearest_integer";
            round_chain_out_mode           :  string := "nearest_integer";
            saturate_mode                  :  string := "asymmetric";
            saturate_chain_out_mode        :  string := "asymmetric";
            multa_signa_internally_grounded : string := "false";
            multa_signb_internally_grounded : string := "false";
            multb_signa_internally_grounded : string := "false";
            multb_signb_internally_grounded : string := "false";
            multc_signa_internally_grounded : string := "false";
            multc_signb_internally_grounded : string := "false";
            multd_signa_internally_grounded : string := "false";
            multd_signb_internally_grounded : string := "false";
            lpm_type                       :  string := "hardcopyiv_mac_out";
            dataout_width                  :  integer:=72
           );
    PORT (
          dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '1');
          datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '1');
          datac                   : IN std_logic_vector(datac_width - 1 DOWNTO 0):= (others => '1');
          datad                   : IN std_logic_vector(datad_width - 1 DOWNTO 0):= (others => '1');
          signa                   : IN std_logic := '1';
          signb                   : IN std_logic := '1';
          chainin                 : IN std_logic_vector(chainin_width - 1 DOWNTO 0):= (others => '0');
          round                   : IN std_logic := '0';
          saturate                : IN std_logic := '0';
          zeroacc                 : IN std_logic := '0';
          roundchainout           : IN std_logic := '0';
          saturatechainout        : IN std_logic := '0';
          zerochainout            : IN std_logic := '0';
          zeroloopback            : IN std_logic := '0';
          rotate                  : IN std_logic := '0';
          shiftright              : IN std_logic := '0';
          clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
          ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');
          aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
          loopbackout             : OUT std_logic_vector(17 DOWNTO 0):= (others => '0');
          dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
          overflow                : OUT std_logic := '0';
          saturatechainoutoverflow: OUT std_logic := '0';
          dftout                  : OUT std_logic := '0';
          devpor                  : IN std_logic := '1';
          devclrn                 : IN std_logic := '1'
       );
END COMPONENT;

--
-- hardcopyiv_io_pad
--

COMPONENT hardcopyiv_io_pad
    GENERIC (
        lpm_type                       :  string := "hardcopyiv_io_pad");    
    PORT (
        padin                   : IN std_logic := '0';   -- Input Pad
        padout                  : OUT std_logic);   -- Output Pad
END COMPONENT;

--
-- hardcopyiv_pll
--

COMPONENT hardcopyiv_pll
    GENERIC (
        operation_mode              : string := "normal";
        pll_type                    : string := "auto";  -- AUTO/FAST/ENHANCED/LEFT_RIGHT/TOP_BOTTOM
        compensate_clock            : string := "clock0";
        inclk0_input_frequency      : integer := 0;
        inclk1_input_frequency      : integer := 0;
        self_reset_on_loss_lock     : string  := "off";
        switch_over_type            : string  := "auto";
        switch_over_counter         : integer := 1;
        enable_switch_over_counter  : string := "off";
        dpa_multiply_by : integer := 0;
        dpa_divide_by   : integer := 0;
        dpa_divider     : integer := 0;
        bandwidth                    : integer := 0;
        bandwidth_type               : string  := "auto";
        use_dc_coupling              : string  := "false";
        lock_c                      : integer := 4;
        sim_gate_lock_device_behavior : string := "off";
        lock_high                   : integer := 0;
        lock_low                    : integer := 0;
        lock_window_ui              : string := "0.05";
        lock_window                 : time := 5 ps;
        test_bypass_lock_detect     : string := "off";
        clk0_output_frequency       : integer := 0;
        clk0_multiply_by            : integer := 0;
        clk0_divide_by              : integer := 0;
        clk0_phase_shift            : string := "0";
        clk0_duty_cycle             : integer := 50;
        clk1_output_frequency       : integer := 0;
        clk1_multiply_by            : integer := 0;
        clk1_divide_by              : integer := 0;
        clk1_phase_shift            : string := "0";
        clk1_duty_cycle             : integer := 50;
        clk2_output_frequency       : integer := 0;
        clk2_multiply_by            : integer := 0;
        clk2_divide_by              : integer := 0;
        clk2_phase_shift            : string := "0";
        clk2_duty_cycle             : integer := 50;
        clk3_output_frequency       : integer := 0;
        clk3_multiply_by            : integer := 0;
        clk3_divide_by              : integer := 0;
        clk3_phase_shift            : string := "0";
        clk3_duty_cycle             : integer := 50;
        clk4_output_frequency       : integer := 0;
        clk4_multiply_by            : integer := 0;
        clk4_divide_by              : integer := 0;
        clk4_phase_shift            : string := "0";
        clk4_duty_cycle             : integer := 50;
        clk5_output_frequency       : integer := 0;
        clk5_multiply_by            : integer := 0;
        clk5_divide_by              : integer := 0;
        clk5_phase_shift            : string := "0";
        clk5_duty_cycle             : integer := 50;
        clk6_output_frequency       : integer := 0;
        clk6_multiply_by            : integer := 0;
        clk6_divide_by              : integer := 0;
        clk6_phase_shift            : string := "0";
        clk6_duty_cycle             : integer := 50;
        clk7_output_frequency       : integer := 0;
        clk7_multiply_by            : integer := 0;
        clk7_divide_by              : integer := 0;
        clk7_phase_shift            : string := "0";
        clk7_duty_cycle             : integer := 50;
        clk8_output_frequency       : integer := 0;
        clk8_multiply_by            : integer := 0;
        clk8_divide_by              : integer := 0;
        clk8_phase_shift            : string := "0";
        clk8_duty_cycle             : integer := 50;
        clk9_output_frequency       : integer := 0;
        clk9_multiply_by            : integer := 0;
        clk9_divide_by              : integer := 0;
        clk9_phase_shift            : string := "0";
        clk9_duty_cycle             : integer := 50;
        pfd_min                     : integer := 0;
        pfd_max                     : integer := 0;
        vco_min                     : integer := 0;
        vco_max                     : integer := 0;
        vco_center                  : integer := 0;
        m_initial                   : integer := 1;
        m                           : integer := 0;
        n                           : integer := 1;
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
        c6_high                     : integer := 1;
        c6_low                      : integer := 1;
        c6_initial                  : integer := 1;
        c6_mode                     : string := "bypass";
        c6_ph                       : integer := 0;
        c7_high                     : integer := 1;
        c7_low                      : integer := 1;
        c7_initial                  : integer := 1;
        c7_mode                     : string := "bypass";
        c7_ph                       : integer := 0;
        c8_high                     : integer := 1;
        c8_low                      : integer := 1;
        c8_initial                  : integer := 1;
        c8_mode                     : string := "bypass";
        c8_ph                       : integer := 0;
        c9_high                     : integer := 1;
        c9_low                      : integer := 1;
        c9_initial                  : integer := 1;
        c9_mode                     : string := "bypass";
        c9_ph                       : integer := 0;
        m_ph                        : integer := 0;
        clk0_counter                : string := "unused";
        clk1_counter                : string := "unused";
        clk2_counter                : string := "unused";
        clk3_counter                : string := "unused";
        clk4_counter                : string := "unused";
        clk5_counter                : string := "unused";
        clk6_counter                : string := "unused";
        clk7_counter                : string := "unused";
        clk8_counter                : string := "unused";
        clk9_counter                : string := "unused";
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
        c5_use_casc_in              : string := "off";
        c6_use_casc_in              : string := "off";
        c7_use_casc_in              : string := "off";
        c8_use_casc_in              : string := "off";
        c9_use_casc_in              : string := "off";
        m_test_source               : integer := -1;
        c0_test_source              : integer := -1;
        c1_test_source              : integer := -1;
        c2_test_source              : integer := -1;
        c3_test_source              : integer := -1;
        c4_test_source              : integer := -1;
        c5_test_source              : integer := -1;
        c6_test_source              : integer := -1;
        c7_test_source              : integer := -1;
        c8_test_source              : integer := -1;
        c9_test_source              : integer := -1;
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        vco_post_scale              : integer := 1;
        vco_frequency_control       : string  := "auto";
        vco_phase_shift_step        : integer := 0;
        charge_pump_current         : integer := 10;
        loop_filter_r               : string := " 1.0";
        loop_filter_c               : integer := 0;
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        lpm_type                    : string := "hardcopyiv_pll";
        clk0_use_even_counter_mode  : string := "off";
        clk1_use_even_counter_mode  : string := "off";
        clk2_use_even_counter_mode  : string := "off";
        clk3_use_even_counter_mode  : string := "off";
        clk4_use_even_counter_mode  : string := "off";
        clk5_use_even_counter_mode  : string := "off";
        clk6_use_even_counter_mode  : string := "off";
        clk7_use_even_counter_mode  : string := "off";
        clk8_use_even_counter_mode  : string := "off";
        clk9_use_even_counter_mode  : string := "off";
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
        clk5_use_even_counter_value : string := "off";
        clk6_use_even_counter_value : string := "off";
        clk7_use_even_counter_value : string := "off";
        clk8_use_even_counter_value : string := "off";
        clk9_use_even_counter_value : string := "off";
        init_block_reset_a_count    : integer := 1;
        init_block_reset_b_count    : integer := 1;
        charge_pump_current_bits : integer := 0;
        lock_window_ui_bits : integer := 0;
        loop_filter_c_bits : integer := 0;
        loop_filter_r_bits : integer := 0;
        test_counter_c0_delay_chain_bits : integer := 0;
        test_counter_c1_delay_chain_bits : integer := 0;
        test_counter_c2_delay_chain_bits : integer := 0;
        test_counter_c3_delay_chain_bits : integer := 0;
        test_counter_c4_delay_chain_bits : integer := 0;
        test_counter_c5_delay_chain_bits : integer := 0;
        test_counter_c6_delay_chain_bits : integer := 0;
        test_counter_c7_delay_chain_bits : integer := 0;
        test_counter_c8_delay_chain_bits : integer := 0;
        test_counter_c9_delay_chain_bits : integer := 0;
        test_counter_m_delay_chain_bits : integer := 0;
        test_counter_n_delay_chain_bits : integer := 0;
        test_feedback_comp_delay_chain_bits : integer := 0;
        test_input_comp_delay_chain_bits : integer := 0;
        test_volt_reg_output_mode_bits : integer := 0;
        test_volt_reg_output_voltage_bits : integer := 0;
        test_volt_reg_test_mode : string := "false";
        vco_range_detector_high_bits : integer := -1;
        vco_range_detector_low_bits : integer := -1;
        scan_chain_mif_file : string := "";
        dpa_output_clock_phase_shift : integer := 0;
        test_counter_c3_sclk_delay_chain_bits   : integer := -1;
        test_counter_c4_sclk_delay_chain_bits   : integer := -1;
        test_counter_c5_lden_delay_chain_bits   : integer := -1;
        test_counter_c6_lden_delay_chain_bits   : integer := -1;
        auto_settings : string  := "true";     
        family_name                 : string  := "HARDCOPYIV";
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
       tipd_scanclkena             : VitalDelayType01 := DefPropDelay01;
       tipd_scandata               : VitalDelayType01 := DefPropDelay01;
       tipd_configupdate           : VitalDelayType01 := DefPropDelay01;
       tipd_clkswitch              : VitalDelayType01 := DefPropDelay01;
       tipd_phaseupdown            : VitalDelayType01 := DefPropDelay01;
       tipd_phasecounterselect     : VitalDelayArrayType01(3 DOWNTO 0) := (OTHERS => DefPropDelay01);
       tipd_phasestep              : VitalDelayType01 := DefPropDelay01;
       tsetup_scandata_scanclk_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
       thold_scandata_scanclk_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
       tsetup_scanclkena_scanclk_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
       thold_scanclkena_scanclk_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
        use_vco_bypass              : string := "false"
    );
    PORT
    (
        inclk                       : in std_logic_vector(1 downto 0);
        fbin                         : in std_logic := '0';
        fbout                        : out std_logic;
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        scandata                    : in std_logic := '0';
        scanclk                     : in std_logic := '0';
        scanclkena                  : in std_logic := '1';
        configupdate                : in std_logic := '0';
        clk                         : out std_logic_vector(9 downto 0);
        phasecounterselect          : in std_logic_vector(3 downto 0) := "0000";
        phaseupdown                 : in std_logic := '0';
        phasestep                   : in std_logic := '0';
        clkbad                      : out std_logic_vector(1 downto 0);
        activeclock                 : out std_logic;
        locked                      : out std_logic;
        scandataout                 : out std_logic;
        scandone                    : out std_logic;
        phasedone                   : out std_logic;
        vcooverrange                : out std_logic;
        vcounderrange               : out std_logic
    );
END COMPONENT;

--
-- hardcopyiv_asmiblock
--

COMPONENT hardcopyiv_asmiblock
    generic (
        lpm_type : string := "hardcopyiv_asmiblock"
        );	
    port (
        dclkin : in std_logic := '0'; 
        scein : in std_logic := '0'; 
        sdoin : in std_logic := '0'; 
        data0in : in std_logic := '0'; 
        oe : in std_logic := '0'; 
        dclkout : out std_logic; 
        sceout : out std_logic; 
        sdoout : out std_logic; 
        data0out: out std_logic
        );
END COMPONENT;

--
-- hardcopyiv_lvds_receiver
--

COMPONENT hardcopyiv_lvds_receiver
    GENERIC ( channel_width                  :  integer := 10;
              data_align_rollover            :  integer := 2;
              enable_dpa                     :  string := "off";
              lose_lock_on_one_change        :  string := "off";
              reset_fifo_at_first_lock       :  string := "on";
              align_to_rising_edge_only      :  string := "on";
              use_serial_feedback_input      :  string := "off";
              dpa_debug                      :  string := "off";
              enable_soft_cdr                : string := "off";
              dpa_output_clock_phase_shift   : INTEGER := 0 ;
              enable_dpa_initial_phase_selection  : string := "off";
              dpa_initial_phase_value    : INTEGER := 0;
              enable_dpa_align_to_rising_edge_only   : string := "off";
              net_ppm_variation     : INTEGER := 0;
              is_negative_ppm_drift   : string := "off";
                rx_input_path_delay_engineering_bits : INTEGER := 2;
              x_on_bitslip                   :  string := "on";
              lpm_type                       :  string := "hardcopyiv_lvds_receiver";
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
              dpalock                 : OUT std_logic:= '0';
              bitslipmax              : OUT std_logic;
              serialdataout           : OUT std_logic;
              postdpaserialdataout    : OUT std_logic;
              divfwdclk               : OUT std_logic;
              dpaclkout               : OUT std_logic;
              devclrn                 : IN std_logic := '1';
              devpor                  : IN std_logic := '1'
            );
END COMPONENT;

--
-- hardcopyiv_pseudo_diff_out
--

COMPONENT hardcopyiv_pseudo_diff_out
 GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             lpm_type                         :  string := "hardcopyiv_pseudo_diff_out"
            );
 PORT (
           i                       : IN std_logic := '0';
           o                       : OUT std_logic;
           obar                    : OUT std_logic
         );
END COMPONENT;

--
-- hardcopyiv_bias_block
--

COMPONENT hardcopyiv_bias_block
    GENERIC (
        lpm_type : string := "hardcopyiv_bias_block";
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
-- hardcopyiv_tsdblock
--

COMPONENT hardcopyiv_tsdblock
    generic (
        poi_cal_temperature : integer := 85;
        clock_divider_enable : string := "on";
        clock_divider_value : integer := 40;
        sim_tsdcalo : integer := 0;
        user_offset_enable : string := "off";
        lpm_type : string := "hardcopyiv_tsdblock"
        );	
    port (
        offset : in std_logic_vector(5 downto 0) := (OTHERS => '0');
        clk : in std_logic := '0'; 
        ce : in std_logic := '0'; 
        clr : in std_logic := '0'; 
        testin : in std_logic_vector(7 downto 0) := (OTHERS => '0');
        tsdcalo : out std_logic_vector(7 downto 0);
        tsdcaldone : out std_logic; 
        fdbkctrlfromcore : in std_logic := '0';
        compouttest : in std_logic := '0';
        tsdcompout : out std_logic; 
        offsetout : out std_logic_vector(5 downto 0)
        );
END COMPONENT;

--
-- hardcopyiv_lcell_hsadder
--

COMPONENT hardcopyiv_lcell_hsadder
    generic (
             dataa_width : integer := 2;
             datab_width : integer := 2;
             cin_inverted : string := "off";
             lpm_type : string := "hardcopyiv_lcell_hsadder";
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
             tpd_dataa_sumout : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
             tpd_datab_sumout : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
             tpd_cin_sumout : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
             tipd_datab : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
             tipd_cin : VitalDelayType01 := DefPropDelay01
            );
    port (
          dataa : in std_logic_vector(dataa_width - 1 downto 0) := (OTHERS => '0');
          datab : in std_logic_vector(datab_width - 1 downto 0) := (OTHERS => '0');
          cin : in std_logic := '0';
          sumout: out std_logic_vector((calc_sum_len(dataa_width, datab_width)) - 2  downto 0);
          cout : out std_logic
         );
END COMPONENT;

--
-- hardcopyiv_otp
--

COMPONENT hardcopyiv_otp
    GENERIC 
    (
        MsgOn                                      : Boolean := DefGlitchMsgOn;
        XOn                                        : Boolean := DefGlitchXOn;
        MsgOnChecks                                : Boolean := DefMsgOnChecks;
        TimingChecksOn                             : Boolean := True;
        tipd_otpclken                              : VitalDelayType01 := DefpropDelay01;
        tipd_otpclk                                : VitalDelayType01 := DefpropDelay01;
        tipd_otpshiftnld                           : VitalDelayType01 := DefpropDelay01;
        tpd_otpshiftnld_otpdout                    : VitalDelayType01 := DefpropDelay01;
        tsetup_otpshiftnld_otpclk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        thold_otpshiftnld_otpclk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        data_width                                 : INTEGER := 128;
        init_data                                  : STD_LOGIC_VECTOR(127 DOWNTO 0)  := (OTHERS => '0');
        init_file                                  : STRING := "init_file.hex";
        lpm_type                                   : STRING := "hardcopyiv_otp";
        lpm_hint                                   : STRING := "true"
    );
    PORT 
    (
        otpclken    : IN STD_LOGIC := '1';
        otpclk      : IN STD_LOGIC := '0';
        otpshiftnld : IN STD_LOGIC := '0';
        otpdout     : OUT STD_LOGIC
    );
END COMPONENT;

end hardcopyiv_components;
