-- Copyright (C) 1991-2010 Altera Corporation
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

library ieee;
use ieee.std_logic_1164.all;

package altera_lnsim_components is

component altera_pll 
    generic(
        reference_clock_frequency: string  := "0 ps";
        pll_type        : string  := "General";
        number_of_clocks: integer := 1;
        operation_mode  : string  := "internal feedback";
        deserialization_factor: integer := 4;
        data_rate       : integer := 0;
        clock_switchover_mode: string  := "Auto";
        clock_switchover_delay: integer := 3;
        sim_additional_refclk_cycles_to_lock: integer := 0;
        output_clock_frequency0: string  := "0 ps";
        phase_shift0    : string  := "0 ps";
        duty_cycle0     : integer := 50;
        output_clock_frequency1: string  := "0 ps";
        phase_shift1    : string  := "0 ps";
        duty_cycle1     : integer := 50;
        output_clock_frequency2: string  := "0 ps";
        phase_shift2    : string  := "0 ps";
        duty_cycle2     : integer := 50;
        output_clock_frequency3: string  := "0 ps";
        phase_shift3    : string  := "0 ps";
        duty_cycle3     : integer := 50;
        output_clock_frequency4: string  := "0 ps";
        phase_shift4    : string  := "0 ps";
        duty_cycle4     : integer := 50;
        output_clock_frequency5: string  := "0 ps";
        phase_shift5    : string  := "0 ps";
        duty_cycle5     : integer := 50;
        output_clock_frequency6: string  := "0 ps";
        phase_shift6    : string  := "0 ps";
        duty_cycle6     : integer := 50;
        output_clock_frequency7: string  := "0 ps";
        phase_shift7    : string  := "0 ps";
        duty_cycle7     : integer := 50;
        output_clock_frequency8: string  := "0 ps";
        phase_shift8    : string  := "0 ps";
        duty_cycle8     : integer := 50;
        output_clock_frequency9: string  := "0 ps";
        phase_shift9    : string  := "0 ps";
        duty_cycle9     : integer := 50;
        output_clock_frequency10: string  := "0 ps";
        phase_shift10   : string  := "0 ps";
        duty_cycle10    : integer := 50;
        output_clock_frequency11: string  := "0 ps";
        phase_shift11   : string  := "0 ps";
        duty_cycle11    : integer := 50;
        output_clock_frequency12: string  := "0 ps";
        phase_shift12   : string  := "0 ps";
        duty_cycle12    : integer := 50;
        output_clock_frequency13: string  := "0 ps";
        phase_shift13   : string  := "0 ps";
        duty_cycle13    : integer := 50;
        output_clock_frequency14: string  := "0 ps";
        phase_shift14   : string  := "0 ps";
        duty_cycle14    : integer := 50;
        output_clock_frequency15: string  := "0 ps";
        phase_shift15   : string  := "0 ps";
        duty_cycle15    : integer := 50;
        output_clock_frequency16: string  := "0 ps";
        phase_shift16   : string  := "0 ps";
        duty_cycle16    : integer := 50;
        output_clock_frequency17: string  := "0 ps";
        phase_shift17   : string  := "0 ps";
        duty_cycle17    : integer := 50
    );
    port(
        refclk          : in    std_logic;
        fbclk           : in    std_logic;
        rst             : in    std_logic;
        outclk          : out   std_logic_vector(number_of_clocks - 1 downto 0);
        fboutclk        : out   std_logic;
        locked          : out   std_logic;
        zdbfbclk        : inout std_logic
    );
end component;

component generic_pll 
    generic(
        lpm_type        : string  := "generic_pll";
        duty_cycle      : integer := 50;
        output_clock_frequency: string  := "0 ps";
        phase_shift     : string  := "0 ps";
        reference_clock_frequency: string  := "0 ps";
        sim_additional_refclk_cycles_to_lock: integer := 0
    );
    port(
        refclk				:	in	std_logic;
        rst					:	in	std_logic := '0';
        fbclk				:	in	std_logic;
		writerefclkdata		:	in	std_logic_vector(63 downto 0) := (others => '0');
		writeoutclkdata		:	in	std_logic_vector(63 downto 0) := (others => '0');
		writephaseshiftdata	:	in	std_logic_vector(63 downto 0) := (others => '0');
		writedutycycledata	:	in	std_logic_vector(63 downto 0) := (others => '0'); 

        outclk				:	out	std_logic;
        locked				:	out	std_logic;
        fboutclk			:	out	std_logic;
		readrefclkdata		:	out	std_logic_vector(63 downto 0); 
		readoutclkdata		:	out	std_logic_vector(63 downto 0); 
		readphaseshiftdata	:	out	std_logic_vector(63 downto 0);
		readdutycycledata	:	out	std_logic_vector(63 downto 0)
    );
end component;

component generic_cdr 
    generic(
        reference_clock_frequency: string  := "0 ps";
        output_clock_frequency: string  := "0 ps"
    );
    port(
        extclk          : in    std_logic;
        ltd             : in    std_logic;
        ltr             : in    std_logic;
        ppmlock         : in    std_logic;
        refclk          : in    std_logic;
        rst             : in    std_logic;
        sd              : in    std_logic;
        rxp             : in    std_logic;
        clk90bdes       : out   std_logic;
        clk270bdes      : out   std_logic;
        clklow          : out   std_logic;
        deven           : out   std_logic;
        dodd            : out   std_logic;
        fref            : out   std_logic;
        pfdmodelock     : out   std_logic;
        rxplllock       : out   std_logic
    );
end component;

COMPONENT generic_m20k
    GENERIC (
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
        ecc_pipeline_stage_enabled     :  STRING := "false";
        enable_ecc                     :  STRING := "false";
        width_eccstatus                :  INTEGER := 2;   
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
        port_a_read_enable_clock       :  STRING := "clock0";           
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
        port_b_write_enable_clock      :  STRING := "clock1";    
        port_b_read_enable_clock       :  STRING := "clock1";    
        port_b_byte_enable_clock       :  STRING := "clock1";    
        port_b_data_out_clock          :  STRING := "none";    
        port_b_data_width              :  INTEGER := 1;    
        port_b_address_width           :  INTEGER := 1;    
        port_b_byte_enable_mask_width  :  INTEGER := 1;    
        port_a_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
        port_b_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";    
        power_up_uninitialized         :  STRING := "false";  
        port_b_byte_size               :  INTEGER := 0;
        port_a_byte_size               :  INTEGER := 0;  
        lpm_type                       :  STRING := "stratixv_ram_block";
        lpm_hint                       :  STRING := "true";
        clk0_input_clock_enable        :  STRING := "none"; -- ena0,ena2,none
        clk0_core_clock_enable         :  STRING := "none"; -- ena0,ena2,none
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
        portaaddrstall          : IN STD_LOGIC := '0';
        portbaddrstall          : IN STD_LOGIC := '0';
        eccstatus               : OUT STD_LOGIC_VECTOR(width_eccstatus - 1 DOWNTO 0) := (OTHERS => '0');
        dftout                  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );
END COMPONENT;

COMPONENT generic_m10k
    GENERIC (
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
        ecc_pipeline_stage_enabled     :  STRING := "false";
        enable_ecc                     :  STRING := "false";
        width_eccstatus                :  INTEGER := 2;   
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
        port_a_read_enable_clock       :  STRING := "clock0";           
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
        port_b_write_enable_clock      :  STRING := "clock1";    
        port_b_read_enable_clock       :  STRING := "clock1";    
        port_b_byte_enable_clock       :  STRING := "clock1";    
        port_b_data_out_clock          :  STRING := "none";    
        port_b_data_width              :  INTEGER := 1;    
        port_b_address_width           :  INTEGER := 1;    
        port_b_byte_enable_mask_width  :  INTEGER := 1;    
        port_a_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
        port_b_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";    
        power_up_uninitialized         :  STRING := "false";  
        port_b_byte_size               :  INTEGER := 0;
        port_a_byte_size               :  INTEGER := 0;  
        lpm_type                       :  STRING := "arriav_ram_block";
        lpm_hint                       :  STRING := "true";
        clk0_input_clock_enable        :  STRING := "none"; -- ena0,ena2,none
        clk0_core_clock_enable         :  STRING := "none"; -- ena0,ena2,none
        clk0_output_clock_enable       :  STRING := "none"; -- ena0,none
        clk1_input_clock_enable        :  STRING := "none"; -- ena1,ena3,none
        clk1_core_clock_enable         :  STRING := "none"; -- ena1,ena3,none
        clk1_output_clock_enable       :  STRING := "none"; -- ena1,none
        mem_init0                      :  STRING := "";
        mem_init1                      :  STRING := "";
        mem_init2                      :  STRING := "";
        mem_init3                      :  STRING := "";
        mem_init4                      :  STRING := "";
        connectivity_checking          :  STRING := "off"
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
        portaaddrstall          : IN STD_LOGIC := '0';
        portbaddrstall          : IN STD_LOGIC := '0';
        eccstatus               : OUT STD_LOGIC_VECTOR(width_eccstatus - 1 DOWNTO 0) := (OTHERS => '0');
        dftout                  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );
END COMPONENT;

COMPONENT generic_mlab_cell
   GENERIC (
      logical_ram_name              : STRING := "lutram";
      logical_ram_depth             : INTEGER := 0;
      logical_ram_width             : INTEGER := 0;
      first_address                 : INTEGER := 0;
      last_address                  : INTEGER := 0;
      first_bit_number              : INTEGER := 0;
      init_file                     : STRING := "NONE";
      data_width                    : INTEGER := 20;
      address_width                 : INTEGER := 6;
      byte_enable_mask_width        : INTEGER := 1;
      byte_size                     : INTEGER := 1;
      port_b_data_out_clock         : STRING := "none";
      port_b_data_out_clear         : STRING := "none";
      lpm_type                      : STRING := "stratixv_lutram";
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
      clr                           : IN STD_LOGIC := '0';
      devclrn                       : IN STD_LOGIC := '1';
      devpor                        : IN STD_LOGIC := '1';
      portbdataout                  : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
   );
END COMPONENT;

component altera_functions 
end component;

component generic_mux
    port(
        din				: in    std_logic_vector(63 downto 0);
        sel				: in    std_logic_vector(5 downto 0);
        dout			: out   std_logic_vector
    );
end component;

component generic_device_pll
    generic(
		reference_clock_frequency	: string	:= "0 ps";
		output_clock_frequency		: string	:= "0 ps";
		forcelock					: string	:= "false";
		nreset_invert				: string	:= "false";
		pll_enable					: string	:= "true";
		pll_fbclk_mux_1				: string	:= "glb";
		pll_fbclk_mux_2				: string	:= "fb_1";
		pll_m_cnt_bypass_en			: string	:= "false";
		pll_m_cnt_hi_div			: integer	:= 1;
		pll_m_cnt_in_src			: string	:= "ph_mux_clk";
		pll_m_cnt_lo_div			: integer	:= 1;
		pll_n_cnt_bypass_en			: string	:= "false";
		pll_n_cnt_hi_div			: integer	:= 1;
		pll_n_cnt_lo_div			: integer	:= 1;
		pll_vco_ph0_en				: string	:= "false";
		pll_vco_ph1_en				: string	:= "false";
		pll_vco_ph2_en				: string	:= "false";
		pll_vco_ph3_en				: string	:= "false";
		pll_vco_ph4_en				: string	:= "false";
		pll_vco_ph5_en				: string	:= "false";
		pll_vco_ph6_en				: string	:= "false";
		pll_vco_ph7_en				: string	:= "false"
    );
    port(
		coreclkfb		: in	std_logic;
		fbclkfpll		: in	std_logic;
		lvdsfbin		: in	std_logic;
		nresync			: in	std_logic;
		pfden			: in	std_logic;
		refclkin		: in	std_logic;
		zdb				: in	std_logic;

		fbclk			: out	std_logic;
		fblvdsout		: out	std_logic;
		lock			: out	std_logic;
		vcoph			: out	std_logic_vector(7 downto 0)
    );
end component;



component altera_mult_add 
   GENERIC (
	   	extra_latency							: INTEGER :=  0;
		dedicated_multiplier_circuitry			: STRING :=  "AUTO";
		dsp_block_balancing						: STRING :=  "AUTO";
		selected_device_family					: STRING :=  "Stratix V";
		lpm_type								: STRING :=  "altmult_add";
		lpm_hint								: STRING :=  "UNUSED";
		width_a									: INTEGER :=  1;
		input_register_a0						: STRING :=  "CLOCK0";
		input_aclr_a0							: STRING :=  "ACLR0";
		input_source_a0							: STRING :=  "DATAA";
		input_register_a1						: STRING :=  "CLOCK0";
		input_aclr_a1							: STRING :=  "ACLR0";
		input_source_a1							: STRING :=  "DATAA";
		input_register_a2						: STRING :=  "CLOCK0";
		input_aclr_a2							: STRING :=  "ACLR0";
		input_source_a2							: STRING :=  "DATAA";
		input_register_a3						: STRING :=  "CLOCK0";
		input_aclr_a3							: STRING :=  "ACLR0";
		input_source_a3							: STRING :=  "DATAA";
		width_b									: INTEGER :=  1;
		input_register_b0						: STRING :=  "CLOCK0";
		input_aclr_b0							: STRING :=  "ACLR0";
		input_source_b0							: STRING :=  "DATAB";
		input_register_b1						: STRING :=  "CLOCK0";
		input_aclr_b1							: STRING :=  "ACLR0";
		input_source_b1							: STRING :=  "DATAB";
		input_register_b2						: STRING :=  "CLOCK0";
		input_aclr_b2							: STRING :=  "ACLR0";
		input_source_b2							: STRING :=  "DATAB";
		input_register_b3						: STRING :=  "CLOCK0";
		input_aclr_b3							: STRING :=  "ACLR0";
		input_source_b3							: STRING :=  "DATAB";
		width_c									: INTEGER :=  1;
		input_register_c0						: STRING :=  "CLOCK0";
		input_aclr_c0							: STRING :=  "ACLR0";
		input_register_c1						: STRING :=  "CLOCK0";
		input_aclr_c1							: STRING :=  "ACLR0";
		input_register_c2						: STRING :=  "CLOCK0";
		input_aclr_c2							: STRING :=  "ACLR0";
		input_register_c3						: STRING :=  "CLOCK0";
		input_aclr_c3							: STRING :=  "ACLR0";
		width_result							: INTEGER :=  34;
		output_register							: STRING :=  "CLOCK0";
		output_aclr								: STRING :=  "ACLR3";
		port_signa								: STRING :=  "PORT_CONNECTIVITY";
		representation_a						: STRING :=  "UNSIGNED";
		signed_register_a						: STRING :=  "CLOCK0";
		signed_aclr_a							: STRING :=  "ACLR0";
		signed_pipeline_register_a				: STRING :=  "CLOCK0";
		signed_pipeline_aclr_a					: STRING :=  "ACLR3";
		port_signb								: STRING :=  "PORT_CONNECTIVITY";
		representation_b						: STRING :=  "UNSIGNED";
		signed_register_b						: STRING :=  "CLOCK0";
		signed_aclr_b							: STRING :=  "ACLR0";
		signed_pipeline_register_b				: STRING :=  "CLOCK0";
		signed_pipeline_aclr_b					: STRING :=  "ACLR3";
		number_of_multipliers					: INTEGER :=  1;
		multiplier1_direction					: STRING :=  "UNUSED";
		multiplier3_direction					: STRING :=  "UNUSED";
		multiplier_register0					: STRING :=  "CLOCK0";
		multiplier_aclr0						: STRING :=  "ACLR3";
		multiplier_register1					: STRING :=  "CLOCK0";
		multiplier_aclr1						: STRING :=  "ACLR3";
		multiplier_register2					: STRING :=  "CLOCK0";
		multiplier_aclr2						: STRING :=  "ACLR3";
		multiplier_register3					: STRING :=  "CLOCK0";
		multiplier_aclr3						: STRING :=  "ACLR3";
		port_addnsub1							: STRING :=  "PORT_CONNECTIVITY";
		addnsub_multiplier_register1			: STRING :=  "CLOCK0";
		addnsub_multiplier_aclr1				: STRING :=  "ACLR3";
		addnsub_multiplier_pipeline_register1	: STRING :=  "CLOCK0";
		addnsub_multiplier_pipeline_aclr1		: STRING :=  "ACLR3";
		port_addnsub3							: STRING :=  "PORT_CONNECTIVITY";
		addnsub_multiplier_register3			: STRING :=  "CLOCK0";
		addnsub_multiplier_aclr3				: STRING :=  "ACLR3";
		addnsub_multiplier_pipeline_register3	: STRING :=  "CLOCK0";
		addnsub_multiplier_pipeline_aclr3		: STRING :=  "ACLR3";
		adder1_rounding							: STRING :=  "NO";
		addnsub1_round_register					: STRING :=  "CLOCK0";
		addnsub1_round_aclr						: STRING :=  "ACLR3";
		addnsub1_round_pipeline_register		: STRING :=  "CLOCK0";
		addnsub1_round_pipeline_aclr			: STRING :=  "ACLR3";
		adder3_rounding							: STRING :=  "NO";
		addnsub3_round_register					: STRING :=  "CLOCK0";
		addnsub3_round_aclr						: STRING :=  "ACLR3";
		addnsub3_round_pipeline_register		: STRING :=  "CLOCK0";
		addnsub3_round_pipeline_aclr			: STRING :=  "ACLR3";
		multiplier01_rounding					: STRING :=  "NO";
		mult01_round_register					: STRING :=  "CLOCK0";
		mult01_round_aclr						: STRING :=  "ACLR3";
		multiplier23_rounding					: STRING :=  "NO";
		mult23_round_register					: STRING :=  "CLOCK0";
		mult23_round_aclr						: STRING :=  "ACLR3";
		width_msb								: INTEGER :=  17;
		output_rounding							: STRING :=  "NO";
		output_round_type						: STRING :=  "NEAREST_INTEGER";
		output_round_register					: STRING :=  "UNREGISTERED";
		output_round_aclr						: STRING :=  "NONE";
		output_round_pipeline_register			: STRING :=  "UNREGISTERED";
		output_round_pipeline_aclr				: STRING :=  "NONE";
		chainout_rounding						: STRING :=  "NO";
		chainout_round_register					: STRING :=  "UNREGISTERED";
		chainout_round_aclr						: STRING :=  "NONE";
		chainout_round_pipeline_register		: STRING :=  "UNREGISTERED";
		chainout_round_pipeline_aclr			: STRING :=  "NONE";
		chainout_round_output_register			: STRING :=  "UNREGISTERED";
		chainout_round_output_aclr				: STRING :=  "NONE";
		multiplier01_saturation					: STRING :=  "NO";
		mult01_saturation_register				: STRING :=  "CLOCK0";
		mult01_saturation_aclr					: STRING :=  "ACLR3";
		multiplier23_saturation					: STRING :=  "NO";
		mult23_saturation_register				: STRING :=  "CLOCK0";
		mult23_saturation_aclr					: STRING :=  "ACLR3";
		port_mult0_is_saturated					: STRING :=  "UNUSED";
		port_mult1_is_saturated					: STRING :=  "UNUSED";
		port_mult2_is_saturated					: STRING :=  "UNUSED";
		port_mult3_is_saturated					: STRING :=  "UNUSED";
		width_saturate_sign						: INTEGER :=  1;
		output_saturation						: STRING :=  "NO";
		port_output_is_overflow					: STRING :=  "PORT_UNUSED";
		output_saturate_type					: STRING :=  "ASYMMETRIC";
		output_saturate_register				: STRING :=  "UNREGISTERED";
		output_saturate_aclr					: STRING :=  "NONE";
		output_saturate_pipeline_register		: STRING :=  "UNREGISTERED";
		output_saturate_pipeline_aclr			: STRING :=  "NONE";
		chainout_saturation						: STRING :=  "NO";
		port_chainout_sat_is_overflow			: STRING :=  "PORT_UNUSED";
		chainout_saturate_register				: STRING :=  "UNREGISTERED";
		chainout_saturate_aclr					: STRING :=  "NONE";
		chainout_saturate_pipeline_register		: STRING :=  "UNREGISTERED";
		chainout_saturate_pipeline_aclr			: STRING :=  "NONE";
		chainout_saturate_output_register		: STRING :=  "UNREGISTERED";
		chainout_saturate_output_aclr			: STRING :=  "NONE";
		scanouta_register						: STRING :=  "UNREGISTERED";
		scanouta_aclr							: STRING :=  "NONE";
		width_chainin							: INTEGER :=  1;
		chainout_adder							: STRING :=  "NO";
		chainout_register						: STRING :=  "UNREGISTERED";
		chainout_aclr							: STRING :=  "ACLR3";
		zero_chainout_output_register			: STRING :=  "UNREGISTERED";
		zero_chainout_output_aclr				: STRING :=  "NONE";
		shift_mode								: STRING :=  "NO";
		rotate_register							: STRING :=  "UNREGISTERED";
		rotate_aclr								: STRING :=  "NONE";
		rotate_pipeline_register				: STRING :=  "UNREGISTERED";
		rotate_pipeline_aclr					: STRING :=  "NONE";
		rotate_output_register					: STRING :=  "UNREGISTERED";
		rotate_output_aclr						: STRING :=  "NONE";
		shift_right_register					: STRING :=  "UNREGISTERED";
		shift_right_aclr						: STRING :=  "NONE";
		shift_right_pipeline_register			: STRING :=  "UNREGISTERED";
		shift_right_pipeline_aclr				: STRING :=  "NONE";
		shift_right_output_register				: STRING :=  "UNREGISTERED";
		shift_right_output_aclr					: STRING :=  "NONE";
		zero_loopback_register					: STRING :=  "UNREGISTERED";
		zero_loopback_aclr						: STRING :=  "NONE";
		zero_loopback_pipeline_register			: STRING :=  "UNREGISTERED";
		zero_loopback_pipeline_aclr				: STRING :=  "NONE";
		zero_loopback_output_register			: STRING :=  "UNREGISTERED";
		zero_loopback_output_aclr				: STRING :=  "NONE";
		accumulator								: STRING :=  "NO";
		accum_direction							: STRING :=  "ADD";
		loadconst_value							: INTEGER :=  0;
		accum_sload_register					: STRING :=  "UNREGISTERED";
		accum_sload_aclr						: STRING :=  "NONE";
		accum_sload_pipeline_register			: STRING :=  "UNREGISTERED";
		accum_sload_pipeline_aclr				: STRING :=  "NONE";
		loadconst_control_register				: STRING :=  "CLOCK0";
		loadconst_control_aclr					: STRING :=  "ACLR0";
		systolic_delay1							: STRING :=  "UNREGISTERED";
		systolic_delay3							: STRING :=  "UNREGISTERED";
		systolic_aclr1							: STRING :=  "NONE";
		systolic_aclr3							: STRING :=  "NONE";
		preadder_mode							: STRING :=  "SIMPLE";
		preadder_direction_0					: STRING :=  "ADD";
		preadder_direction_1					: STRING :=  "ADD";
		preadder_direction_2					: STRING :=  "ADD";
		preadder_direction_3					: STRING :=  "ADD";
		width_coef								: INTEGER :=  1;
		coefsel0_register						: STRING :=  "CLOCK0";
		coefsel0_aclr							: STRING :=  "ACLR0";
		coefsel1_register						: STRING :=  "CLOCK0";
		coefsel1_aclr							: STRING :=  "ACLR0";
		coefsel2_register						: STRING :=  "CLOCK0";
		coefsel2_aclr							: STRING :=  "ACLR0";
		coefsel3_register						: STRING :=  "CLOCK0";
		coefsel3_aclr							: STRING :=  "ACLR0";
		coef0_0									: INTEGER :=  0;
		coef0_1									: INTEGER :=  0;
		coef0_2									: INTEGER :=  0;
		coef0_3									: INTEGER :=  0;
		coef0_4									: INTEGER :=  0;
		coef0_5									: INTEGER :=  0;
		coef0_6									: INTEGER :=  0;
		coef0_7									: INTEGER :=  0;
		coef1_0									: INTEGER :=  0;
		coef1_1									: INTEGER :=  0;
		coef1_2									: INTEGER :=  0;
		coef1_3									: INTEGER :=  0;
		coef1_4									: INTEGER :=  0;
		coef1_5									: INTEGER :=  0;
		coef1_6									: INTEGER :=  0;
		coef1_7									: INTEGER :=  0;
		coef2_0									: INTEGER :=  0;
		coef2_1									: INTEGER :=  0;
		coef2_2									: INTEGER :=  0;
		coef2_3									: INTEGER :=  0;
		coef2_4									: INTEGER :=  0;
		coef2_5									: INTEGER :=  0;
		coef2_6									: INTEGER :=  0;
		coef2_7									: INTEGER :=  0;
		coef3_0									: INTEGER :=  0;
		coef3_1									: INTEGER :=  0;
		coef3_2									: INTEGER :=  0;
		coef3_3									: INTEGER :=  0;
		coef3_4									: INTEGER :=  0;
		coef3_5									: INTEGER :=  0;
		coef3_6									: INTEGER :=  0;
		coef3_7									: INTEGER :=  0
    );
   PORT (
		dataa						: IN    STD_LOGIC_VECTOR(width_a * number_of_multipliers - 1 downto 0);
		datab						: IN    STD_LOGIC_VECTOR(width_b * number_of_multipliers - 1 downto 0);
		datac						: IN    STD_LOGIC_VECTOR(width_c - 1 downto 0);
		scanina						: IN    STD_LOGIC_VECTOR(width_a - 1 downto 0);
		scaninb						: IN    STD_LOGIC_VECTOR(width_b - 1 downto 0);
		sourcea						: IN    STD_LOGIC_VECTOR(number_of_multipliers - 1 downto 0);
		sourceb						: IN    STD_LOGIC_VECTOR(number_of_multipliers - 1 downto 0);
		clock3						: IN    STD_LOGIC;
		clock2 						: IN    STD_LOGIC;
		clock1 						: IN    STD_LOGIC;
		clock0 						: IN    STD_LOGIC;
		aclr3 						: IN    STD_LOGIC;
		aclr2 						: IN    STD_LOGIC;
		aclr1 						: IN    STD_LOGIC;
		aclr0 						: IN    STD_LOGIC;
		ena3 						: IN    STD_LOGIC;
		ena2 						: IN    STD_LOGIC;
		ena1 						: IN    STD_LOGIC;
		ena0 						: IN    STD_LOGIC;
		signa 						: IN    STD_LOGIC; 
		signb 						: IN    STD_LOGIC; 
		addnsub1 					: IN    STD_LOGIC; 
		addnsub3 					: IN    STD_LOGIC; 
		result 						: OUT    STD_LOGIC_VECTOR(width_result - 1 downto 0);
		scanouta					: OUT    STD_LOGIC_VECTOR(width_a - 1 downto 0);
		scanoutb					: OUT    STD_LOGIC_VECTOR(width_b - 1 downto 0);
		mult01_round 				: IN    STD_LOGIC;
		mult23_round 				: IN    STD_LOGIC;
		mult01_saturation 			: IN    STD_LOGIC;
		mult23_saturation 			: IN    STD_LOGIC;
		addnsub1_round 				: IN    STD_LOGIC;
		addnsub3_round 				: IN    STD_LOGIC;
		mult0_is_saturated 			: OUT    STD_LOGIC;
		mult1_is_saturated 			: OUT    STD_LOGIC;
		mult2_is_saturated 			: OUT    STD_LOGIC;
		mult3_is_saturated 			: OUT    STD_LOGIC;
		output_round 				: IN    STD_LOGIC;
		chainout_round 				: IN    STD_LOGIC;
		output_saturate 			: IN    STD_LOGIC;
		chainout_saturate 			: IN    STD_LOGIC;
		overflow 					: OUT    STD_LOGIC;
		chainout_sat_overflow 		: OUT    STD_LOGIC;
		chainin						: IN    STD_LOGIC_VECTOR(width_chainin - 1 downto 0);
		zero_chainout 				: IN    STD_LOGIC;
		rotate 						: IN    STD_LOGIC;
		shift_right 				: IN    STD_LOGIC;
		zero_loopback 				: IN    STD_LOGIC;
		accum_sload 				: IN    STD_LOGIC;
		coefsel0					: IN    STD_LOGIC_VECTOR(2 downto 0);
		coefsel1					: IN    STD_LOGIC_VECTOR(2 downto 0);
		coefsel2					: IN    STD_LOGIC_VECTOR(2 downto 0);
		coefsel3					: IN    STD_LOGIC_VECTOR(2 downto 0)
    );
end component;
	
	
end altera_lnsim_components;
