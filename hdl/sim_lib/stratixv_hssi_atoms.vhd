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
library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_atx_pll    is
    generic    (
         avmm_group_channel_index                :  integer  := 0 ;
         output_clock_frequency                  :  string   := "" ;
         reference_clock_frequency               :  string   := "" ;
         use_default_base_address                :  string   := "true" ;
         user_base_address0                      :  integer  := 0 ;
         user_base_address1                      :  integer  := 0 ;
         user_base_address2                      :  integer  := 0 ;
         cp_current_ctrl                         :  integer  := 300 ;
         cp_current_test                         :  string   := "enable_ch_pump_normal" ;
         cp_hs_levshift_power_supply_setting     :  integer  := 1 ;
         cp_replica_bias_ctrl                    :  string   := "disable_replica_bias_ctrl" ;
         cp_rgla_bypass                          :  string   := "false" ;
         cp_rgla_volt_inc                        :  string   := "boost_30pct" ;
         l_counter                               :  integer  := 1 ;
         lcpll_atb_select                        :  string   := "atb_disable" ;
         lcpll_d2a_sel                           :  string   := "volt_1p02v" ;
         lcpll_hclk_driver_enable                :  string   := "driver_off" ;
         lcvco_gear_sel                          :  string   := "high_gear" ;
         lcvco_sel                               :  string   := "high_freq_14g" ;
         lpf_ripple_cap_ctrl                     :  string   := "none" ;
         lpf_rxpll_pfd_bw_ctrl                   :  integer  := 2400 ;
         m_counter                               :  integer  := 4 ;
         ref_clk_div                             :  integer  := 1 ;
         refclk_sel                              :  string   := "refclk" ;
         vreg1_lcvco_volt_inc                    :  string   := "volt_1p1v" ;
         vreg1_vccehlow                          :  string   := "normal_operation" ;
         vreg2_lcpll_volt_sel                    :  string   := "vreg2_volt_1p0v" ;
         vreg3_lcpll_volt_sel                    :  string   := "vreg3_volt_1p0v"
    );
    port    (
           avmmaddress        :     in   std_logic_vector( 10 downto 0 );
           avmmbyteen         :     in   std_logic_vector( 1 downto 0 );
           avmmclk            :     in   std_logic;
           avmmread           :     in   std_logic;
           avmmrstn           :     in   std_logic;
           avmmwrite          :     in   std_logic;
           avmmwritedata      :     in   std_logic_vector( 15 downto 0 );
           avmmreaddata       :     out  std_logic_vector( 15 downto 0 );
           blockselect        :     out  std_logic;
           ch0rcsrlc          :     in   std_logic_vector( 31 downto 0 );
           ch1rcsrlc          :     in   std_logic_vector( 31 downto 0 );
           ch2rcsrlc          :     in   std_logic_vector( 31 downto 0 );
           cmurstn            :     in   std_logic;
           cmurstnlpf         :     in   std_logic;
           extfbclk           :     in   std_logic;
           iqclklc            :     in   std_logic;
           pldclklc           :     in   std_logic;
           pllfbswblc         :     in   std_logic;
           pllfbswtlc         :     in   std_logic;
           refclklc           :     in   std_logic;
           clk010g            :     out  std_logic;
           clk025g            :     out  std_logic;
           clk18010g          :     out  std_logic;
           clk18025g          :     out  std_logic;
           clk33cmu           :     out  std_logic;
           clklowcmu          :     out  std_logic;
           frefcmu            :     out  std_logic;
           iqclkatt           :     out  std_logic;
           pfdmodelockcmu     :     out  std_logic;
           pldclkatt          :     out  std_logic;
           refclkatt          :     out  std_logic;
           txpllhclk          :     out  std_logic
    );
end stratixv_atx_pll;

architecture behavior of stratixv_atx_pll is

component    stratixv_atx_pll_encrypted
    generic    (
         avmm_group_channel_index                :  integer  := 0 ;
         output_clock_frequency                  :  string   := "" ;
         reference_clock_frequency               :  string   := "" ;
         use_default_base_address                :  string   := "true" ;
         user_base_address0                      :  integer  := 0 ;
         user_base_address1                      :  integer  := 0 ;
         user_base_address2                      :  integer  := 0 ;
         cp_current_ctrl                         :  integer  := 300 ;
         cp_current_test                         :  string   := "enable_ch_pump_normal" ;
         cp_hs_levshift_power_supply_setting     :  integer  := 1 ;
         cp_replica_bias_ctrl                    :  string   := "disable_replica_bias_ctrl" ;
         cp_rgla_bypass                          :  string   := "false" ;
         cp_rgla_volt_inc                        :  string   := "boost_30pct" ;
         l_counter                               :  integer  := 1 ;
         lcpll_atb_select                        :  string   := "atb_disable" ;
         lcpll_d2a_sel                           :  string   := "volt_1p02v" ;
         lcpll_hclk_driver_enable                :  string   := "driver_off" ;
         lcvco_gear_sel                          :  string   := "high_gear" ;
         lcvco_sel                               :  string   := "high_freq_14g" ;
         lpf_ripple_cap_ctrl                     :  string   := "none" ;
         lpf_rxpll_pfd_bw_ctrl                   :  integer  := 2400 ;
         m_counter                               :  integer  := 4 ;
         ref_clk_div                             :  integer  := 1 ;
         refclk_sel                              :  string   := "refclk" ;
         vreg1_lcvco_volt_inc                    :  string   := "volt_1p1v" ;
         vreg1_vccehlow                          :  string   := "normal_operation" ;
         vreg2_lcpll_volt_sel                    :  string   := "vreg2_volt_1p0v" ;
         vreg3_lcpll_volt_sel                    :  string   := "vreg3_volt_1p0v"
    );
    port    (
           avmmaddress        :     in   std_logic_vector( 10 downto 0 );
           avmmbyteen         :     in   std_logic_vector( 1 downto 0 );
           avmmclk            :     in   std_logic;
           avmmread           :     in   std_logic;
           avmmrstn           :     in   std_logic;
           avmmwrite          :     in   std_logic;
           avmmwritedata      :     in   std_logic_vector( 15 downto 0 );
           avmmreaddata       :     out  std_logic_vector( 15 downto 0 );
           blockselect        :     out  std_logic;
           ch0rcsrlc          :     in   std_logic_vector( 31 downto 0 );
           ch1rcsrlc          :     in   std_logic_vector( 31 downto 0 );
           ch2rcsrlc          :     in   std_logic_vector( 31 downto 0 );
           cmurstn            :     in   std_logic;
           cmurstnlpf         :     in   std_logic;
           extfbclk           :     in   std_logic;
           iqclklc            :     in   std_logic;
           pldclklc           :     in   std_logic;
           pllfbswblc         :     in   std_logic;
           pllfbswtlc         :     in   std_logic;
           refclklc           :     in   std_logic;
           clk010g            :     out  std_logic;
           clk025g            :     out  std_logic;
           clk18010g          :     out  std_logic;
           clk18025g          :     out  std_logic;
           clk33cmu           :     out  std_logic;
           clklowcmu          :     out  std_logic;
           frefcmu            :     out  std_logic;
           iqclkatt           :     out  std_logic;
           pfdmodelockcmu     :     out  std_logic;
           pldclkatt          :     out  std_logic;
           refclkatt          :     out  std_logic;
           txpllhclk          :     out  std_logic
    );
end component;

begin


inst : stratixv_atx_pll_encrypted
    generic  map  (
         avmm_group_channel_index                 =>    avmm_group_channel_index                ,
         output_clock_frequency                   =>    output_clock_frequency                  ,
         reference_clock_frequency                =>    reference_clock_frequency               ,
         use_default_base_address                 =>    use_default_base_address                ,
         user_base_address0                       =>    user_base_address0                      ,
         user_base_address1                       =>    user_base_address1                      ,
         user_base_address2                       =>    user_base_address2                      ,
         cp_current_ctrl                          =>    cp_current_ctrl                         ,
         cp_current_test                          =>    cp_current_test                         ,
         cp_hs_levshift_power_supply_setting      =>    cp_hs_levshift_power_supply_setting     ,
         cp_replica_bias_ctrl                     =>    cp_replica_bias_ctrl                    ,
         cp_rgla_bypass                           =>    cp_rgla_bypass                          ,
         cp_rgla_volt_inc                         =>    cp_rgla_volt_inc                        ,
         l_counter                                =>    l_counter                               ,
         lcpll_atb_select                         =>    lcpll_atb_select                        ,
         lcpll_d2a_sel                            =>    lcpll_d2a_sel                           ,
         lcpll_hclk_driver_enable                 =>    lcpll_hclk_driver_enable                ,
         lcvco_gear_sel                           =>    lcvco_gear_sel                          ,
         lcvco_sel                                =>    lcvco_sel                               ,
         lpf_ripple_cap_ctrl                      =>    lpf_ripple_cap_ctrl                     ,
         lpf_rxpll_pfd_bw_ctrl                    =>    lpf_rxpll_pfd_bw_ctrl                   ,
         m_counter                                =>    m_counter                               ,
         ref_clk_div                              =>    ref_clk_div                             ,
         refclk_sel                               =>    refclk_sel                              ,
         vreg1_lcvco_volt_inc                     =>    vreg1_lcvco_volt_inc                    ,
         vreg1_vccehlow                           =>    vreg1_vccehlow                          ,
         vreg2_lcpll_volt_sel                     =>    vreg2_lcpll_volt_sel                    ,
         vreg3_lcpll_volt_sel                     =>    vreg3_lcpll_volt_sel                    
    )
    port  map  (
           avmmaddress          =>  avmmaddress        ,
           avmmbyteen           =>  avmmbyteen         ,
           avmmclk              =>  avmmclk            ,
           avmmread             =>  avmmread           ,
           avmmrstn             =>  avmmrstn           ,
           avmmwrite            =>  avmmwrite          ,
           avmmwritedata        =>  avmmwritedata      ,
           avmmreaddata         =>  avmmreaddata       ,
           blockselect          =>  blockselect        ,
           ch0rcsrlc            =>  ch0rcsrlc          ,
           ch1rcsrlc            =>  ch1rcsrlc          ,
           ch2rcsrlc            =>  ch2rcsrlc          ,
           cmurstn              =>  cmurstn            ,
           cmurstnlpf           =>  cmurstnlpf         ,
           extfbclk             =>  extfbclk           ,
           iqclklc              =>  iqclklc            ,
           pldclklc             =>  pldclklc           ,
           pllfbswblc           =>  pllfbswblc         ,
           pllfbswtlc           =>  pllfbswtlc         ,
           refclklc             =>  refclklc           ,
           clk010g              =>  clk010g            ,
           clk025g              =>  clk025g            ,
           clk18010g            =>  clk18010g          ,
           clk18025g            =>  clk18025g          ,
           clk33cmu             =>  clk33cmu           ,
           clklowcmu            =>  clklowcmu          ,
           frefcmu              =>  frefcmu            ,
           iqclkatt             =>  iqclkatt           ,
           pfdmodelockcmu       =>  pfdmodelockcmu     ,
           pldclkatt            =>  pldclkatt          ,
           refclkatt            =>  refclkatt          ,
           txpllhclk            =>  txpllhclk         
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;

entity stratixv_channel_pll is
	generic
	(
		avmm_group_channel_index			:	integer	:= 0;
		output_clock_frequency				:	string	:= "0 ps";
		reference_clock_frequency			:	string	:= "0 ps";
		sim_use_fast_model					:	string	:= "true";
		use_default_base_address			:	string	:= "true";
		user_base_address					:	integer	:= 0;
		bbpd_salatch_offset_ctrl_clk0		:	string	:= "clk0_offset_0mv";
		bbpd_salatch_offset_ctrl_clk180		:	string	:= "clk180_offset_0mv";
		bbpd_salatch_offset_ctrl_clk270		:	string	:= "clk270_offset_0mv";
		bbpd_salatch_offset_ctrl_clk90		:	string	:= "clk90_offset_0mv";
		bbpd_salatch_sel					:	string	:= "normal";
		bypass_cp_rgla						:	string	:= "false";
		cdr_atb_select						:	string	:= "atb_disable";
		cgb_clk_enable						:	string	:= "false";
		charge_pump_current_test			:	string	:= "enable_ch_pump_normal";
		clklow_fref_to_ppm_div_sel			:	integer	:= 1;
		clock_monitor						:	string	:= "lpbk_data";
		diag_rev_lpbk						:	string	:= "false";
		eye_monitor_bbpd_data_ctrl			:	string	:= "cdr_data";
		fast_lock_mode						:	string	:= "false";
		fb_sel								:	string	:= "vcoclk";
		gpon_lock2ref_ctrl					:	string	:= "lck2ref";
		hs_levshift_power_supply_setting	:	integer	:= 1;
		ignore_phslock						:	string	:= "false";
		l_counter_pd_clock_disable			:	string	:= "false";
		m_counter							:	integer	:= 25;
		pcie_freq_control					:	string	:= "pcie_100mhz";
		pd_charge_pump_current_ctrl			:	integer	:= 5;
		pd_l_counter						:	integer	:= 1;
		pfd_charge_pump_current_ctrl		:	integer	:= 20;
		pfd_l_counter						:	integer	:= 1;
		powerdown							:	string	:= "false";
		ref_clk_div							:	integer	:= 1;
		regulator_volt_inc					:	string	:= "volt_inc_0pct";
		replica_bias_ctrl					:	string	:= "true";
		reverse_serial_lpbk					:	string	:= "false";
		ripple_cap_ctrl						:	string	:= "none";
		rxpll_pd_bw_ctrl					:	integer	:= 300;
		rxpll_pfd_bw_ctrl					:	integer	:= 3200;
		txpll_hclk_driver_enable			:	string	:= "false";
		vco_overange_ref					:	string	:= "off";
		vco_range_ctrl_en					:	string	:= "false"
	);
	port
	(
		avmmaddress							:	in		std_logic_vector(10 downto 0);
		avmmbyteen							:	in		std_logic;
		avmmclk								:	in		std_logic;
		avmmread							:	in		std_logic;
		avmmrstn							:	in		std_logic;
		avmmwrite							:	in		std_logic;
		avmmwritedata						:	in		std_logic_vector(15 downto 0);
		clk270eye							:   in		std_logic;
		clk270beyerm						:	in		std_logic;
		clk90eye							:   in		std_logic;
		clk90beyerm							:	in		std_logic;
		clkindeser							:	in		std_logic;
		crurstb								:   in		std_logic;
		deeye								:   in		std_logic;
		deeyerm								:   in		std_logic;
		doeye								:   in		std_logic;
		doeyerm								:   in		std_logic;
		earlyeios							:   in		std_logic;
		extclk								:	in		std_logic;
		extfbctrla							:	in		std_logic;
		extfbctrlb							:	in		std_logic;
		gpblck2refb							:	in		std_logic;
		lpbkpreen							:	in		std_logic;
		ltd									:	in		std_logic;
		ltr									:	in		std_logic;
		occalen								:	in		std_logic;
		pciel								:	in		std_logic;
		pciem								:	in		std_logic;
		pciesw								:	in		std_logic_vector(1 downto 0);
		ppmlock								:	in		std_logic;
		refclk								:	in		std_logic;
		rstn								:	in		std_logic;
		rxp									:	in		std_logic;
		sd									:	in		std_logic;
		avmmreaddata						:	out		std_logic_vector(15 downto 0);
		blockselect							:	out		std_logic;
		ck0pd								:	out		std_logic;
		ck180pd								:	out		std_logic;
		ck270pd								:	out		std_logic;
		ck90pd								:	out		std_logic;
		clk270bcdr							:	out		std_logic;
		clk270bdes							:	out		std_logic;
		clk90bcdr							:	out		std_logic;
		clk90bdes							:	out		std_logic;
		clkcdr								:	out		std_logic;
		clklow								:	out		std_logic;
		decdr								:	out		std_logic;
		deven								:	out		std_logic;
		docdr								:	out		std_logic;
		dodd								:	out		std_logic;
		fref								:	out		std_logic;
		pdof								:	out		std_logic_vector(3 downto 0);
		pfdmodelock							:	out		std_logic;
		rxlpbdp								:	out		std_logic;
		rxlpbp								:	out		std_logic;
		rxplllock							:	out		std_logic;
		txpllhclk							:	out		std_logic;
		txrlpbk								:	out		std_logic;
		vctrloverrange						:	out		std_logic
	);
end stratixv_channel_pll;

architecture behavior of stratixv_channel_pll is

component    stratixv_channel_pll_encrypted
    generic    (
		avmm_group_channel_index			:	integer	:= 0;
		output_clock_frequency				:	string	:= "0 ps";
		reference_clock_frequency			:	string	:= "0 ps";
		sim_use_fast_model					:	string	:= "true";
		use_default_base_address			:	string	:= "true";
		user_base_address					:	integer	:= 0;
		bbpd_salatch_offset_ctrl_clk0		:	string	:= "clk0_offset_0mv";
		bbpd_salatch_offset_ctrl_clk180		:	string	:= "clk180_offset_0mv";
		bbpd_salatch_offset_ctrl_clk270		:	string	:= "clk270_offset_0mv";
		bbpd_salatch_offset_ctrl_clk90		:	string	:= "clk90_offset_0mv";
		bbpd_salatch_sel					:	string	:= "normal";
		bypass_cp_rgla						:	string	:= "false";
		cdr_atb_select						:	string	:= "atb_disable";
		cgb_clk_enable						:	string	:= "false";
		charge_pump_current_test			:	string	:= "enable_ch_pump_normal";
		clklow_fref_to_ppm_div_sel			:	integer	:= 1;
		clock_monitor						:	string	:= "lpbk_data";
		diag_rev_lpbk						:	string	:= "false";
		eye_monitor_bbpd_data_ctrl			:	string	:= "cdr_data";
		fast_lock_mode						:	string	:= "false";
		fb_sel								:	string	:= "vcoclk";
		gpon_lock2ref_ctrl					:	string	:= "lck2ref";
		hs_levshift_power_supply_setting	:	integer	:= 1;
		ignore_phslock						:	string	:= "false";
		l_counter_pd_clock_disable			:	string	:= "false";
		m_counter							:	integer	:= 25;
		pcie_freq_control					:	string	:= "pcie_100mhz";
		pd_charge_pump_current_ctrl			:	integer	:= 5;
		pd_l_counter						:	integer	:= 1;
		pfd_charge_pump_current_ctrl		:	integer	:= 20;
		pfd_l_counter						:	integer	:= 1;
		powerdown							:	string	:= "false";
		ref_clk_div							:	integer	:= 1;
		regulator_volt_inc					:	string	:= "volt_inc_0pct";
		replica_bias_ctrl					:	string	:= "true";
		reverse_serial_lpbk					:	string	:= "false";
		ripple_cap_ctrl						:	string	:= "none";
		rxpll_pd_bw_ctrl					:	integer	:= 300;
		rxpll_pfd_bw_ctrl					:	integer	:= 3200;
		txpll_hclk_driver_enable			:	string	:= "false";
		vco_overange_ref					:	string	:= "off";
		vco_range_ctrl_en					:	string	:= "false"
    );
    port    (
		avmmaddress							:	in		std_logic_vector(10 downto 0);
		avmmbyteen							:	in		std_logic;
		avmmclk								:	in		std_logic;
		avmmread							:	in		std_logic;
		avmmrstn							:	in		std_logic;
		avmmwrite							:	in		std_logic;
		avmmwritedata						:	in		std_logic_vector(15 downto 0);
		clk270eye							:   in		std_logic;
		clk270beyerm						:	in		std_logic;
		clk90eye							:   in		std_logic;
		clk90beyerm							:	in		std_logic;
		clkindeser							:	in		std_logic;
		crurstb								:   in		std_logic;
		deeye								:   in		std_logic;
		deeyerm								:   in		std_logic;
		doeye								:   in		std_logic;
		doeyerm								:   in		std_logic;
		earlyeios							:   in		std_logic;
		extclk								:	in		std_logic;
		extfbctrla							:	in		std_logic;
		extfbctrlb							:	in		std_logic;
		gpblck2refb							:	in		std_logic;
		lpbkpreen							:	in		std_logic;
		ltd									:	in		std_logic;
		ltr									:	in		std_logic;
		occalen								:	in		std_logic;
		pciel								:	in		std_logic;
		pciem								:	in		std_logic;
		pciesw								:	in		std_logic_vector(1 downto 0);
		ppmlock								:	in		std_logic;
		refclk								:	in		std_logic;
		rstn								:	in		std_logic;
		rxp									:	in		std_logic;
		sd									:	in		std_logic;
		avmmreaddata						:	out		std_logic_vector(15 downto 0);
		blockselect							:	out		std_logic;
		ck0pd								:	out		std_logic;
		ck180pd								:	out		std_logic;
		ck270pd								:	out		std_logic;
		ck90pd								:	out		std_logic;
		clk270bcdr							:	out		std_logic;
		clk270bdes							:	out		std_logic;
		clk90bcdr							:	out		std_logic;
		clk90bdes							:	out		std_logic;
		clkcdr								:	out		std_logic;
		clklow								:	out		std_logic;
		decdr								:	out		std_logic;
		deven								:	out		std_logic;
		docdr								:	out		std_logic;
		dodd								:	out		std_logic;
		fref								:	out		std_logic;
		pdof								:	out		std_logic_vector(3 downto 0);
		pfdmodelock							:	out		std_logic;
		rxlpbdp								:	out		std_logic;
		rxlpbp								:	out		std_logic;
		rxplllock							:	out		std_logic;
		txpllhclk							:	out		std_logic;
		txrlpbk								:	out		std_logic;
		vctrloverrange						:	out		std_logic
	);
end component;

begin

inst : stratixv_channel_pll_encrypted
    generic map
    (
		avmm_group_channel_index			=>	avmm_group_channel_index,
		output_clock_frequency				=>	output_clock_frequency,
		reference_clock_frequency			=>	reference_clock_frequency,
		sim_use_fast_model					=>	sim_use_fast_model,
		use_default_base_address			=>	use_default_base_address,
		user_base_address					=>	user_base_address,
		bbpd_salatch_offset_ctrl_clk0		=>	bbpd_salatch_offset_ctrl_clk0,
		bbpd_salatch_offset_ctrl_clk180		=>	bbpd_salatch_offset_ctrl_clk180,
		bbpd_salatch_offset_ctrl_clk270		=>	bbpd_salatch_offset_ctrl_clk270,
		bbpd_salatch_offset_ctrl_clk90		=>	bbpd_salatch_offset_ctrl_clk90,
		bbpd_salatch_sel					=>	bbpd_salatch_sel,
		bypass_cp_rgla						=>	bypass_cp_rgla,
		cdr_atb_select						=>	cdr_atb_select,
		cgb_clk_enable						=>	cgb_clk_enable,
		charge_pump_current_test			=>	charge_pump_current_test,
		clklow_fref_to_ppm_div_sel			=>	clklow_fref_to_ppm_div_sel,
		clock_monitor						=>	clock_monitor,
		diag_rev_lpbk						=>	diag_rev_lpbk,
		eye_monitor_bbpd_data_ctrl			=>	eye_monitor_bbpd_data_ctrl,
		fast_lock_mode						=>	fast_lock_mode,
		fb_sel								=>	fb_sel,
		gpon_lock2ref_ctrl					=>	gpon_lock2ref_ctrl,
		hs_levshift_power_supply_setting	=>	hs_levshift_power_supply_setting,
		ignore_phslock						=>	ignore_phslock,
		l_counter_pd_clock_disable			=>	l_counter_pd_clock_disable,
		m_counter							=>	m_counter,
		pcie_freq_control					=>	pcie_freq_control,
		pd_charge_pump_current_ctrl			=>	pd_charge_pump_current_ctrl,
		pd_l_counter						=>	pd_l_counter,
		pfd_charge_pump_current_ctrl		=>	pfd_charge_pump_current_ctrl,
		pfd_l_counter						=>	pfd_l_counter,
		powerdown							=>	powerdown,
		ref_clk_div							=>	ref_clk_div,
		regulator_volt_inc					=>	regulator_volt_inc,
		replica_bias_ctrl					=>	replica_bias_ctrl,
		reverse_serial_lpbk					=>	reverse_serial_lpbk,
		ripple_cap_ctrl						=>	ripple_cap_ctrl,
		rxpll_pd_bw_ctrl					=>	rxpll_pd_bw_ctrl,
		rxpll_pfd_bw_ctrl					=>	rxpll_pfd_bw_ctrl,
		txpll_hclk_driver_enable			=>	txpll_hclk_driver_enable,
		vco_overange_ref					=>	vco_overange_ref,
		vco_range_ctrl_en					=>	vco_range_ctrl_en
    )
    port map
    (   
		avmmaddress		=>	avmmaddress,
		avmmbyteen		=>	avmmbyteen,
		avmmclk			=>	avmmclk,
		avmmread		=>	avmmread,
		avmmrstn		=>	avmmrstn,
		avmmwrite		=>	avmmwrite,
		avmmwritedata	=>	avmmwritedata,
		clk270eye		=>	clk270eye,
		clk270beyerm	=>	clk270beyerm,
		clk90eye		=>	clk90eye,
		clk90beyerm		=>	clk90beyerm,
		clkindeser		=>	clkindeser,
		crurstb			=>	crurstb,
		deeye			=>	deeye,
		deeyerm			=>	deeyerm,
		doeye			=>	doeye,
		doeyerm			=>	doeyerm,
		earlyeios		=>	earlyeios,
		extclk			=>	extclk,
		extfbctrla		=>	extfbctrla,
		extfbctrlb		=>	extfbctrlb,
		gpblck2refb		=>	gpblck2refb,
		lpbkpreen		=>	lpbkpreen,
		ltd				=>	ltd,
		ltr				=>	ltr,
		occalen			=>	occalen,
		pciel			=>	pciel,
		pciem			=>	pciem,
		pciesw			=>	pciesw,
		ppmlock			=>	ppmlock,
		refclk			=>	refclk,
		rstn			=>	rstn,
		rxp				=>	rxp,
		sd				=>	sd,

		avmmreaddata	=>	avmmreaddata,
		blockselect		=>	blockselect,
		ck0pd			=>	ck0pd,
		ck180pd			=>	ck180pd,
		ck270pd			=>	ck270pd,
		ck90pd			=>	ck90pd,
		clk270bcdr		=>	clk270bcdr,
		clk270bdes		=>	clk270bdes,
		clk90bcdr		=>	clk90bcdr,
		clk90bdes		=>	clk90bdes,
		clkcdr			=>	clkcdr,
		clklow			=>	clklow,
		decdr			=>	decdr,
		deven			=>	deven,
		docdr			=>	docdr,
		dodd			=>	dodd,
		fref			=>	fref,
		pdof			=>	pdof,
		pfdmodelock		=>	pfdmodelock,
		rxlpbdp			=>	rxlpbdp,
		rxlpbp			=>	rxlpbp,
		rxplllock		=>	rxplllock,
		txpllhclk		=>	txpllhclk,
		txrlpbk			=>	txrlpbk,
		vctrloverrange	=>	vctrloverrange
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_8g_pcs_aggregate    is
    generic    (
        xaui_sm_operation    :    string    :=    "en_xaui_sm";
        dskw_sm_operation    :    string    :=    "dskw_xaui_sm";
        data_agg_bonding    :    string    :=    "agg_disable";
        prot_mode_tx    :    string    :=    "pipe_g1_tx";
        pcs_dw_datapath    :    string    :=    "sw_data_path";
        dskw_control    :    string    :=    "dskw_write_control";
        refclkdig_sel    :    string    :=    "dis_refclk_dig_sel"
    );
    port    (
        refclkdig    :    in    std_logic_vector(0 downto 0);
        scanmoden    :    in    std_logic_vector(0 downto 0);
        scanshiftn    :    in    std_logic_vector(0 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        rcvdclkch0    :    in    std_logic_vector(0 downto 0);
        rcvdclkch1    :    in    std_logic_vector(0 downto 0);
        hardrst    :    in    std_logic_vector(0 downto 0);
        txpcsrst    :    in    std_logic_vector(0 downto 0);
        rxpcsrst    :    in    std_logic_vector(0 downto 0);
        dprioagg    :    in    std_logic_vector(63 downto 0);
        rcvdclkout    :    out    std_logic_vector(0 downto 0);
        rcvdclkouttop    :    out    std_logic_vector(0 downto 0);
        rcvdclkoutbot    :    out    std_logic_vector(0 downto 0);
        rdenablesynctopch1    :    in    std_logic_vector(0 downto 0);
        txdatatctopch1    :    in    std_logic_vector(7 downto 0);
        txctltctopch1    :    in    std_logic_vector(0 downto 0);
        syncstatustopch1    :    in    std_logic_vector(0 downto 0);
        rdaligntopch1    :    in    std_logic_vector(1 downto 0);
        aligndetsynctopch1    :    in    std_logic_vector(1 downto 0);
        fifordintopch1    :    in    std_logic_vector(0 downto 0);
        alignstatussynctopch1    :    in    std_logic_vector(0 downto 0);
        cgcomprddintopch1    :    in    std_logic_vector(1 downto 0);
        cgcompwrintopch1    :    in    std_logic_vector(1 downto 0);
        delcondmetintopch1    :    in    std_logic_vector(0 downto 0);
        fifoovrintopch1    :    in    std_logic_vector(0 downto 0);
        latencycompintopch1    :    in    std_logic_vector(0 downto 0);
        insertincompleteintopch1    :    in    std_logic_vector(0 downto 0);
        decdatatopch1    :    in    std_logic_vector(7 downto 0);
        decctltopch1    :    in    std_logic_vector(0 downto 0);
        decdatavalidtopch1    :    in    std_logic_vector(0 downto 0);
        runningdisptopch1    :    in    std_logic_vector(1 downto 0);
        txdatatstopch1    :    out    std_logic_vector(7 downto 0);
        txctltstopch1    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdtopch1    :    out    std_logic_vector(0 downto 0);
        endskwqdtopch1    :    out    std_logic_vector(0 downto 0);
        endskwrdptrstopch1    :    out    std_logic_vector(0 downto 0);
        alignstatustopch1    :    out    std_logic_vector(0 downto 0);
        alignstatussync0topch1    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0topch1    :    out    std_logic_vector(0 downto 0);
        cgcomprddalltopch1    :    out    std_logic_vector(0 downto 0);
        cgcompwralltopch1    :    out    std_logic_vector(0 downto 0);
        delcondmet0topch1    :    out    std_logic_vector(0 downto 0);
        insertincomplete0topch1    :    out    std_logic_vector(0 downto 0);
        fifoovr0topch1    :    out    std_logic_vector(0 downto 0);
        latencycomp0topch1    :    out    std_logic_vector(0 downto 0);
        rxdatarstopch1    :    out    std_logic_vector(7 downto 0);
        rxctlrstopch1    :    out    std_logic_vector(0 downto 0);
        rdenablesynctopch0    :    in    std_logic_vector(0 downto 0);
        txdatatctopch0    :    in    std_logic_vector(7 downto 0);
        txctltctopch0    :    in    std_logic_vector(0 downto 0);
        syncstatustopch0    :    in    std_logic_vector(0 downto 0);
        rdaligntopch0    :    in    std_logic_vector(1 downto 0);
        aligndetsynctopch0    :    in    std_logic_vector(1 downto 0);
        fifordintopch0    :    in    std_logic_vector(0 downto 0);
        alignstatussynctopch0    :    in    std_logic_vector(0 downto 0);
        cgcomprddintopch0    :    in    std_logic_vector(1 downto 0);
        cgcompwrintopch0    :    in    std_logic_vector(1 downto 0);
        delcondmetintopch0    :    in    std_logic_vector(0 downto 0);
        fifoovrintopch0    :    in    std_logic_vector(0 downto 0);
        latencycompintopch0    :    in    std_logic_vector(0 downto 0);
        insertincompleteintopch0    :    in    std_logic_vector(0 downto 0);
        decdatatopch0    :    in    std_logic_vector(7 downto 0);
        decctltopch0    :    in    std_logic_vector(0 downto 0);
        decdatavalidtopch0    :    in    std_logic_vector(0 downto 0);
        runningdisptopch0    :    in    std_logic_vector(1 downto 0);
        txdatatstopch0    :    out    std_logic_vector(7 downto 0);
        txctltstopch0    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdtopch0    :    out    std_logic_vector(0 downto 0);
        endskwqdtopch0    :    out    std_logic_vector(0 downto 0);
        endskwrdptrstopch0    :    out    std_logic_vector(0 downto 0);
        alignstatustopch0    :    out    std_logic_vector(0 downto 0);
        alignstatussync0topch0    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0topch0    :    out    std_logic_vector(0 downto 0);
        cgcomprddalltopch0    :    out    std_logic_vector(0 downto 0);
        cgcompwralltopch0    :    out    std_logic_vector(0 downto 0);
        delcondmet0topch0    :    out    std_logic_vector(0 downto 0);
        insertincomplete0topch0    :    out    std_logic_vector(0 downto 0);
        fifoovr0topch0    :    out    std_logic_vector(0 downto 0);
        latencycomp0topch0    :    out    std_logic_vector(0 downto 0);
        rxdatarstopch0    :    out    std_logic_vector(7 downto 0);
        rxctlrstopch0    :    out    std_logic_vector(0 downto 0);
        rdenablesyncch2    :    in    std_logic_vector(0 downto 0);
        txdatatcch2    :    in    std_logic_vector(7 downto 0);
        txctltcch2    :    in    std_logic_vector(0 downto 0);
        syncstatusch2    :    in    std_logic_vector(0 downto 0);
        rdalignch2    :    in    std_logic_vector(1 downto 0);
        aligndetsyncch2    :    in    std_logic_vector(1 downto 0);
        fifordinch2    :    in    std_logic_vector(0 downto 0);
        alignstatussyncch2    :    in    std_logic_vector(0 downto 0);
        cgcomprddinch2    :    in    std_logic_vector(1 downto 0);
        cgcompwrinch2    :    in    std_logic_vector(1 downto 0);
        delcondmetinch2    :    in    std_logic_vector(0 downto 0);
        fifoovrinch2    :    in    std_logic_vector(0 downto 0);
        latencycompinch2    :    in    std_logic_vector(0 downto 0);
        insertincompleteinch2    :    in    std_logic_vector(0 downto 0);
        decdatach2    :    in    std_logic_vector(7 downto 0);
        decctlch2    :    in    std_logic_vector(0 downto 0);
        decdatavalidch2    :    in    std_logic_vector(0 downto 0);
        runningdispch2    :    in    std_logic_vector(1 downto 0);
        txdatatsch2    :    out    std_logic_vector(7 downto 0);
        txctltsch2    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdch2    :    out    std_logic_vector(0 downto 0);
        endskwqdch2    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsch2    :    out    std_logic_vector(0 downto 0);
        alignstatusch2    :    out    std_logic_vector(0 downto 0);
        alignstatussync0ch2    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0ch2    :    out    std_logic_vector(0 downto 0);
        cgcomprddallch2    :    out    std_logic_vector(0 downto 0);
        cgcompwrallch2    :    out    std_logic_vector(0 downto 0);
        delcondmet0ch2    :    out    std_logic_vector(0 downto 0);
        insertincomplete0ch2    :    out    std_logic_vector(0 downto 0);
        fifoovr0ch2    :    out    std_logic_vector(0 downto 0);
        latencycomp0ch2    :    out    std_logic_vector(0 downto 0);
        rxdatarsch2    :    out    std_logic_vector(7 downto 0);
        rxctlrsch2    :    out    std_logic_vector(0 downto 0);
        rdenablesyncch1    :    in    std_logic_vector(0 downto 0);
        txdatatcch1    :    in    std_logic_vector(7 downto 0);
        txctltcch1    :    in    std_logic_vector(0 downto 0);
        syncstatusch1    :    in    std_logic_vector(0 downto 0);
        rdalignch1    :    in    std_logic_vector(1 downto 0);
        aligndetsyncch1    :    in    std_logic_vector(1 downto 0);
        fifordinch1    :    in    std_logic_vector(0 downto 0);
        alignstatussyncch1    :    in    std_logic_vector(0 downto 0);
        cgcomprddinch1    :    in    std_logic_vector(1 downto 0);
        cgcompwrinch1    :    in    std_logic_vector(1 downto 0);
        delcondmetinch1    :    in    std_logic_vector(0 downto 0);
        fifoovrinch1    :    in    std_logic_vector(0 downto 0);
        latencycompinch1    :    in    std_logic_vector(0 downto 0);
        insertincompleteinch1    :    in    std_logic_vector(0 downto 0);
        decdatach1    :    in    std_logic_vector(7 downto 0);
        decctlch1    :    in    std_logic_vector(0 downto 0);
        decdatavalidch1    :    in    std_logic_vector(0 downto 0);
        runningdispch1    :    in    std_logic_vector(1 downto 0);
        txdatatsch1    :    out    std_logic_vector(7 downto 0);
        txctltsch1    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdch1    :    out    std_logic_vector(0 downto 0);
        endskwqdch1    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsch1    :    out    std_logic_vector(0 downto 0);
        alignstatusch1    :    out    std_logic_vector(0 downto 0);
        alignstatussync0ch1    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0ch1    :    out    std_logic_vector(0 downto 0);
        cgcomprddallch1    :    out    std_logic_vector(0 downto 0);
        cgcompwrallch1    :    out    std_logic_vector(0 downto 0);
        delcondmet0ch1    :    out    std_logic_vector(0 downto 0);
        insertincomplete0ch1    :    out    std_logic_vector(0 downto 0);
        fifoovr0ch1    :    out    std_logic_vector(0 downto 0);
        latencycomp0ch1    :    out    std_logic_vector(0 downto 0);
        rxdatarsch1    :    out    std_logic_vector(7 downto 0);
        rxctlrsch1    :    out    std_logic_vector(0 downto 0);
        rdenablesyncch0    :    in    std_logic_vector(0 downto 0);
        txdatatcch0    :    in    std_logic_vector(7 downto 0);
        txctltcch0    :    in    std_logic_vector(0 downto 0);
        syncstatusch0    :    in    std_logic_vector(0 downto 0);
        rdalignch0    :    in    std_logic_vector(1 downto 0);
        aligndetsyncch0    :    in    std_logic_vector(1 downto 0);
        fifordinch0    :    in    std_logic_vector(0 downto 0);
        alignstatussyncch0    :    in    std_logic_vector(0 downto 0);
        cgcomprddinch0    :    in    std_logic_vector(1 downto 0);
        cgcompwrinch0    :    in    std_logic_vector(1 downto 0);
        delcondmetinch0    :    in    std_logic_vector(0 downto 0);
        fifoovrinch0    :    in    std_logic_vector(0 downto 0);
        latencycompinch0    :    in    std_logic_vector(0 downto 0);
        insertincompleteinch0    :    in    std_logic_vector(0 downto 0);
        decdatach0    :    in    std_logic_vector(7 downto 0);
        decctlch0    :    in    std_logic_vector(0 downto 0);
        decdatavalidch0    :    in    std_logic_vector(0 downto 0);
        runningdispch0    :    in    std_logic_vector(1 downto 0);
        txdatatsch0    :    out    std_logic_vector(7 downto 0);
        txctltsch0    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdch0    :    out    std_logic_vector(0 downto 0);
        endskwqdch0    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsch0    :    out    std_logic_vector(0 downto 0);
        alignstatusch0    :    out    std_logic_vector(0 downto 0);
        alignstatussync0ch0    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0ch0    :    out    std_logic_vector(0 downto 0);
        cgcomprddallch0    :    out    std_logic_vector(0 downto 0);
        cgcompwrallch0    :    out    std_logic_vector(0 downto 0);
        delcondmet0ch0    :    out    std_logic_vector(0 downto 0);
        insertincomplete0ch0    :    out    std_logic_vector(0 downto 0);
        fifoovr0ch0    :    out    std_logic_vector(0 downto 0);
        latencycomp0ch0    :    out    std_logic_vector(0 downto 0);
        rxdatarsch0    :    out    std_logic_vector(7 downto 0);
        rxctlrsch0    :    out    std_logic_vector(0 downto 0);
        rdenablesyncbotch2    :    in    std_logic_vector(0 downto 0);
        txdatatcbotch2    :    in    std_logic_vector(7 downto 0);
        txctltcbotch2    :    in    std_logic_vector(0 downto 0);
        syncstatusbotch2    :    in    std_logic_vector(0 downto 0);
        rdalignbotch2    :    in    std_logic_vector(1 downto 0);
        aligndetsyncbotch2    :    in    std_logic_vector(1 downto 0);
        fifordinbotch2    :    in    std_logic_vector(0 downto 0);
        alignstatussyncbotch2    :    in    std_logic_vector(0 downto 0);
        cgcomprddinbotch2    :    in    std_logic_vector(1 downto 0);
        cgcompwrinbotch2    :    in    std_logic_vector(1 downto 0);
        delcondmetinbotch2    :    in    std_logic_vector(0 downto 0);
        fifoovrinbotch2    :    in    std_logic_vector(0 downto 0);
        latencycompinbotch2    :    in    std_logic_vector(0 downto 0);
        insertincompleteinbotch2    :    in    std_logic_vector(0 downto 0);
        decdatabotch2    :    in    std_logic_vector(7 downto 0);
        decctlbotch2    :    in    std_logic_vector(0 downto 0);
        decdatavalidbotch2    :    in    std_logic_vector(0 downto 0);
        runningdispbotch2    :    in    std_logic_vector(1 downto 0);
        txdatatsbotch2    :    out    std_logic_vector(7 downto 0);
        txctltsbotch2    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdbotch2    :    out    std_logic_vector(0 downto 0);
        endskwqdbotch2    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsbotch2    :    out    std_logic_vector(0 downto 0);
        alignstatusbotch2    :    out    std_logic_vector(0 downto 0);
        alignstatussync0botch2    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0botch2    :    out    std_logic_vector(0 downto 0);
        cgcomprddallbotch2    :    out    std_logic_vector(0 downto 0);
        cgcompwrallbotch2    :    out    std_logic_vector(0 downto 0);
        delcondmet0botch2    :    out    std_logic_vector(0 downto 0);
        insertincomplete0botch2    :    out    std_logic_vector(0 downto 0);
        fifoovr0botch2    :    out    std_logic_vector(0 downto 0);
        latencycomp0botch2    :    out    std_logic_vector(0 downto 0);
        rxdatarsbotch2    :    out    std_logic_vector(7 downto 0);
        rxctlrsbotch2    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_8g_pcs_aggregate;

architecture behavior of stratixv_hssi_8g_pcs_aggregate is

component    stratixv_hssi_8g_pcs_aggregate_encrypted
    generic    (
        xaui_sm_operation    :    string    :=    "en_xaui_sm";
        dskw_sm_operation    :    string    :=    "dskw_xaui_sm";
        data_agg_bonding    :    string    :=    "agg_disable";
        prot_mode_tx    :    string    :=    "pipe_g1_tx";
        pcs_dw_datapath    :    string    :=    "sw_data_path";
        dskw_control    :    string    :=    "dskw_write_control";
        refclkdig_sel    :    string    :=    "dis_refclk_dig_sel"
    );
    port    (
        refclkdig    :    in    std_logic_vector(0 downto 0);
        scanmoden    :    in    std_logic_vector(0 downto 0);
        scanshiftn    :    in    std_logic_vector(0 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        rcvdclkch0    :    in    std_logic_vector(0 downto 0);
        rcvdclkch1    :    in    std_logic_vector(0 downto 0);
        hardrst    :    in    std_logic_vector(0 downto 0);
        txpcsrst    :    in    std_logic_vector(0 downto 0);
        rxpcsrst    :    in    std_logic_vector(0 downto 0);
        dprioagg    :    in    std_logic_vector(63 downto 0);
        rcvdclkout    :    out    std_logic_vector(0 downto 0);
        rcvdclkouttop    :    out    std_logic_vector(0 downto 0);
        rcvdclkoutbot    :    out    std_logic_vector(0 downto 0);
        rdenablesynctopch1    :    in    std_logic_vector(0 downto 0);
        txdatatctopch1    :    in    std_logic_vector(7 downto 0);
        txctltctopch1    :    in    std_logic_vector(0 downto 0);
        syncstatustopch1    :    in    std_logic_vector(0 downto 0);
        rdaligntopch1    :    in    std_logic_vector(1 downto 0);
        aligndetsynctopch1    :    in    std_logic_vector(1 downto 0);
        fifordintopch1    :    in    std_logic_vector(0 downto 0);
        alignstatussynctopch1    :    in    std_logic_vector(0 downto 0);
        cgcomprddintopch1    :    in    std_logic_vector(1 downto 0);
        cgcompwrintopch1    :    in    std_logic_vector(1 downto 0);
        delcondmetintopch1    :    in    std_logic_vector(0 downto 0);
        fifoovrintopch1    :    in    std_logic_vector(0 downto 0);
        latencycompintopch1    :    in    std_logic_vector(0 downto 0);
        insertincompleteintopch1    :    in    std_logic_vector(0 downto 0);
        decdatatopch1    :    in    std_logic_vector(7 downto 0);
        decctltopch1    :    in    std_logic_vector(0 downto 0);
        decdatavalidtopch1    :    in    std_logic_vector(0 downto 0);
        runningdisptopch1    :    in    std_logic_vector(1 downto 0);
        txdatatstopch1    :    out    std_logic_vector(7 downto 0);
        txctltstopch1    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdtopch1    :    out    std_logic_vector(0 downto 0);
        endskwqdtopch1    :    out    std_logic_vector(0 downto 0);
        endskwrdptrstopch1    :    out    std_logic_vector(0 downto 0);
        alignstatustopch1    :    out    std_logic_vector(0 downto 0);
        alignstatussync0topch1    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0topch1    :    out    std_logic_vector(0 downto 0);
        cgcomprddalltopch1    :    out    std_logic_vector(0 downto 0);
        cgcompwralltopch1    :    out    std_logic_vector(0 downto 0);
        delcondmet0topch1    :    out    std_logic_vector(0 downto 0);
        insertincomplete0topch1    :    out    std_logic_vector(0 downto 0);
        fifoovr0topch1    :    out    std_logic_vector(0 downto 0);
        latencycomp0topch1    :    out    std_logic_vector(0 downto 0);
        rxdatarstopch1    :    out    std_logic_vector(7 downto 0);
        rxctlrstopch1    :    out    std_logic_vector(0 downto 0);
        rdenablesynctopch0    :    in    std_logic_vector(0 downto 0);
        txdatatctopch0    :    in    std_logic_vector(7 downto 0);
        txctltctopch0    :    in    std_logic_vector(0 downto 0);
        syncstatustopch0    :    in    std_logic_vector(0 downto 0);
        rdaligntopch0    :    in    std_logic_vector(1 downto 0);
        aligndetsynctopch0    :    in    std_logic_vector(1 downto 0);
        fifordintopch0    :    in    std_logic_vector(0 downto 0);
        alignstatussynctopch0    :    in    std_logic_vector(0 downto 0);
        cgcomprddintopch0    :    in    std_logic_vector(1 downto 0);
        cgcompwrintopch0    :    in    std_logic_vector(1 downto 0);
        delcondmetintopch0    :    in    std_logic_vector(0 downto 0);
        fifoovrintopch0    :    in    std_logic_vector(0 downto 0);
        latencycompintopch0    :    in    std_logic_vector(0 downto 0);
        insertincompleteintopch0    :    in    std_logic_vector(0 downto 0);
        decdatatopch0    :    in    std_logic_vector(7 downto 0);
        decctltopch0    :    in    std_logic_vector(0 downto 0);
        decdatavalidtopch0    :    in    std_logic_vector(0 downto 0);
        runningdisptopch0    :    in    std_logic_vector(1 downto 0);
        txdatatstopch0    :    out    std_logic_vector(7 downto 0);
        txctltstopch0    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdtopch0    :    out    std_logic_vector(0 downto 0);
        endskwqdtopch0    :    out    std_logic_vector(0 downto 0);
        endskwrdptrstopch0    :    out    std_logic_vector(0 downto 0);
        alignstatustopch0    :    out    std_logic_vector(0 downto 0);
        alignstatussync0topch0    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0topch0    :    out    std_logic_vector(0 downto 0);
        cgcomprddalltopch0    :    out    std_logic_vector(0 downto 0);
        cgcompwralltopch0    :    out    std_logic_vector(0 downto 0);
        delcondmet0topch0    :    out    std_logic_vector(0 downto 0);
        insertincomplete0topch0    :    out    std_logic_vector(0 downto 0);
        fifoovr0topch0    :    out    std_logic_vector(0 downto 0);
        latencycomp0topch0    :    out    std_logic_vector(0 downto 0);
        rxdatarstopch0    :    out    std_logic_vector(7 downto 0);
        rxctlrstopch0    :    out    std_logic_vector(0 downto 0);
        rdenablesyncch2    :    in    std_logic_vector(0 downto 0);
        txdatatcch2    :    in    std_logic_vector(7 downto 0);
        txctltcch2    :    in    std_logic_vector(0 downto 0);
        syncstatusch2    :    in    std_logic_vector(0 downto 0);
        rdalignch2    :    in    std_logic_vector(1 downto 0);
        aligndetsyncch2    :    in    std_logic_vector(1 downto 0);
        fifordinch2    :    in    std_logic_vector(0 downto 0);
        alignstatussyncch2    :    in    std_logic_vector(0 downto 0);
        cgcomprddinch2    :    in    std_logic_vector(1 downto 0);
        cgcompwrinch2    :    in    std_logic_vector(1 downto 0);
        delcondmetinch2    :    in    std_logic_vector(0 downto 0);
        fifoovrinch2    :    in    std_logic_vector(0 downto 0);
        latencycompinch2    :    in    std_logic_vector(0 downto 0);
        insertincompleteinch2    :    in    std_logic_vector(0 downto 0);
        decdatach2    :    in    std_logic_vector(7 downto 0);
        decctlch2    :    in    std_logic_vector(0 downto 0);
        decdatavalidch2    :    in    std_logic_vector(0 downto 0);
        runningdispch2    :    in    std_logic_vector(1 downto 0);
        txdatatsch2    :    out    std_logic_vector(7 downto 0);
        txctltsch2    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdch2    :    out    std_logic_vector(0 downto 0);
        endskwqdch2    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsch2    :    out    std_logic_vector(0 downto 0);
        alignstatusch2    :    out    std_logic_vector(0 downto 0);
        alignstatussync0ch2    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0ch2    :    out    std_logic_vector(0 downto 0);
        cgcomprddallch2    :    out    std_logic_vector(0 downto 0);
        cgcompwrallch2    :    out    std_logic_vector(0 downto 0);
        delcondmet0ch2    :    out    std_logic_vector(0 downto 0);
        insertincomplete0ch2    :    out    std_logic_vector(0 downto 0);
        fifoovr0ch2    :    out    std_logic_vector(0 downto 0);
        latencycomp0ch2    :    out    std_logic_vector(0 downto 0);
        rxdatarsch2    :    out    std_logic_vector(7 downto 0);
        rxctlrsch2    :    out    std_logic_vector(0 downto 0);
        rdenablesyncch1    :    in    std_logic_vector(0 downto 0);
        txdatatcch1    :    in    std_logic_vector(7 downto 0);
        txctltcch1    :    in    std_logic_vector(0 downto 0);
        syncstatusch1    :    in    std_logic_vector(0 downto 0);
        rdalignch1    :    in    std_logic_vector(1 downto 0);
        aligndetsyncch1    :    in    std_logic_vector(1 downto 0);
        fifordinch1    :    in    std_logic_vector(0 downto 0);
        alignstatussyncch1    :    in    std_logic_vector(0 downto 0);
        cgcomprddinch1    :    in    std_logic_vector(1 downto 0);
        cgcompwrinch1    :    in    std_logic_vector(1 downto 0);
        delcondmetinch1    :    in    std_logic_vector(0 downto 0);
        fifoovrinch1    :    in    std_logic_vector(0 downto 0);
        latencycompinch1    :    in    std_logic_vector(0 downto 0);
        insertincompleteinch1    :    in    std_logic_vector(0 downto 0);
        decdatach1    :    in    std_logic_vector(7 downto 0);
        decctlch1    :    in    std_logic_vector(0 downto 0);
        decdatavalidch1    :    in    std_logic_vector(0 downto 0);
        runningdispch1    :    in    std_logic_vector(1 downto 0);
        txdatatsch1    :    out    std_logic_vector(7 downto 0);
        txctltsch1    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdch1    :    out    std_logic_vector(0 downto 0);
        endskwqdch1    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsch1    :    out    std_logic_vector(0 downto 0);
        alignstatusch1    :    out    std_logic_vector(0 downto 0);
        alignstatussync0ch1    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0ch1    :    out    std_logic_vector(0 downto 0);
        cgcomprddallch1    :    out    std_logic_vector(0 downto 0);
        cgcompwrallch1    :    out    std_logic_vector(0 downto 0);
        delcondmet0ch1    :    out    std_logic_vector(0 downto 0);
        insertincomplete0ch1    :    out    std_logic_vector(0 downto 0);
        fifoovr0ch1    :    out    std_logic_vector(0 downto 0);
        latencycomp0ch1    :    out    std_logic_vector(0 downto 0);
        rxdatarsch1    :    out    std_logic_vector(7 downto 0);
        rxctlrsch1    :    out    std_logic_vector(0 downto 0);
        rdenablesyncch0    :    in    std_logic_vector(0 downto 0);
        txdatatcch0    :    in    std_logic_vector(7 downto 0);
        txctltcch0    :    in    std_logic_vector(0 downto 0);
        syncstatusch0    :    in    std_logic_vector(0 downto 0);
        rdalignch0    :    in    std_logic_vector(1 downto 0);
        aligndetsyncch0    :    in    std_logic_vector(1 downto 0);
        fifordinch0    :    in    std_logic_vector(0 downto 0);
        alignstatussyncch0    :    in    std_logic_vector(0 downto 0);
        cgcomprddinch0    :    in    std_logic_vector(1 downto 0);
        cgcompwrinch0    :    in    std_logic_vector(1 downto 0);
        delcondmetinch0    :    in    std_logic_vector(0 downto 0);
        fifoovrinch0    :    in    std_logic_vector(0 downto 0);
        latencycompinch0    :    in    std_logic_vector(0 downto 0);
        insertincompleteinch0    :    in    std_logic_vector(0 downto 0);
        decdatach0    :    in    std_logic_vector(7 downto 0);
        decctlch0    :    in    std_logic_vector(0 downto 0);
        decdatavalidch0    :    in    std_logic_vector(0 downto 0);
        runningdispch0    :    in    std_logic_vector(1 downto 0);
        txdatatsch0    :    out    std_logic_vector(7 downto 0);
        txctltsch0    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdch0    :    out    std_logic_vector(0 downto 0);
        endskwqdch0    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsch0    :    out    std_logic_vector(0 downto 0);
        alignstatusch0    :    out    std_logic_vector(0 downto 0);
        alignstatussync0ch0    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0ch0    :    out    std_logic_vector(0 downto 0);
        cgcomprddallch0    :    out    std_logic_vector(0 downto 0);
        cgcompwrallch0    :    out    std_logic_vector(0 downto 0);
        delcondmet0ch0    :    out    std_logic_vector(0 downto 0);
        insertincomplete0ch0    :    out    std_logic_vector(0 downto 0);
        fifoovr0ch0    :    out    std_logic_vector(0 downto 0);
        latencycomp0ch0    :    out    std_logic_vector(0 downto 0);
        rxdatarsch0    :    out    std_logic_vector(7 downto 0);
        rxctlrsch0    :    out    std_logic_vector(0 downto 0);
        rdenablesyncbotch2    :    in    std_logic_vector(0 downto 0);
        txdatatcbotch2    :    in    std_logic_vector(7 downto 0);
        txctltcbotch2    :    in    std_logic_vector(0 downto 0);
        syncstatusbotch2    :    in    std_logic_vector(0 downto 0);
        rdalignbotch2    :    in    std_logic_vector(1 downto 0);
        aligndetsyncbotch2    :    in    std_logic_vector(1 downto 0);
        fifordinbotch2    :    in    std_logic_vector(0 downto 0);
        alignstatussyncbotch2    :    in    std_logic_vector(0 downto 0);
        cgcomprddinbotch2    :    in    std_logic_vector(1 downto 0);
        cgcompwrinbotch2    :    in    std_logic_vector(1 downto 0);
        delcondmetinbotch2    :    in    std_logic_vector(0 downto 0);
        fifoovrinbotch2    :    in    std_logic_vector(0 downto 0);
        latencycompinbotch2    :    in    std_logic_vector(0 downto 0);
        insertincompleteinbotch2    :    in    std_logic_vector(0 downto 0);
        decdatabotch2    :    in    std_logic_vector(7 downto 0);
        decctlbotch2    :    in    std_logic_vector(0 downto 0);
        decdatavalidbotch2    :    in    std_logic_vector(0 downto 0);
        runningdispbotch2    :    in    std_logic_vector(1 downto 0);
        txdatatsbotch2    :    out    std_logic_vector(7 downto 0);
        txctltsbotch2    :    out    std_logic_vector(0 downto 0);
        fiforstrdqdbotch2    :    out    std_logic_vector(0 downto 0);
        endskwqdbotch2    :    out    std_logic_vector(0 downto 0);
        endskwrdptrsbotch2    :    out    std_logic_vector(0 downto 0);
        alignstatusbotch2    :    out    std_logic_vector(0 downto 0);
        alignstatussync0botch2    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp0botch2    :    out    std_logic_vector(0 downto 0);
        cgcomprddallbotch2    :    out    std_logic_vector(0 downto 0);
        cgcompwrallbotch2    :    out    std_logic_vector(0 downto 0);
        delcondmet0botch2    :    out    std_logic_vector(0 downto 0);
        insertincomplete0botch2    :    out    std_logic_vector(0 downto 0);
        fifoovr0botch2    :    out    std_logic_vector(0 downto 0);
        latencycomp0botch2    :    out    std_logic_vector(0 downto 0);
        rxdatarsbotch2    :    out    std_logic_vector(7 downto 0);
        rxctlrsbotch2    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_8g_pcs_aggregate_encrypted
    generic  map  (
        xaui_sm_operation    =>   xaui_sm_operation,
        dskw_sm_operation    =>   dskw_sm_operation,
        data_agg_bonding    =>   data_agg_bonding,
        prot_mode_tx    =>   prot_mode_tx,
        pcs_dw_datapath    =>   pcs_dw_datapath,
        dskw_control    =>   dskw_control,
        refclkdig_sel    =>   refclkdig_sel
    )
    port  map  (
        refclkdig    =>    refclkdig,
        scanmoden    =>    scanmoden,
        scanshiftn    =>    scanshiftn,
        txpmaclk    =>    txpmaclk,
        rcvdclkch0    =>    rcvdclkch0,
        rcvdclkch1    =>    rcvdclkch1,
        hardrst    =>    hardrst,
        txpcsrst    =>    txpcsrst,
        rxpcsrst    =>    rxpcsrst,
        dprioagg    =>    dprioagg,
        rcvdclkout    =>    rcvdclkout,
        rcvdclkouttop    =>    rcvdclkouttop,
        rcvdclkoutbot    =>    rcvdclkoutbot,
        rdenablesynctopch1    =>    rdenablesynctopch1,
        txdatatctopch1    =>    txdatatctopch1,
        txctltctopch1    =>    txctltctopch1,
        syncstatustopch1    =>    syncstatustopch1,
        rdaligntopch1    =>    rdaligntopch1,
        aligndetsynctopch1    =>    aligndetsynctopch1,
        fifordintopch1    =>    fifordintopch1,
        alignstatussynctopch1    =>    alignstatussynctopch1,
        cgcomprddintopch1    =>    cgcomprddintopch1,
        cgcompwrintopch1    =>    cgcompwrintopch1,
        delcondmetintopch1    =>    delcondmetintopch1,
        fifoovrintopch1    =>    fifoovrintopch1,
        latencycompintopch1    =>    latencycompintopch1,
        insertincompleteintopch1    =>    insertincompleteintopch1,
        decdatatopch1    =>    decdatatopch1,
        decctltopch1    =>    decctltopch1,
        decdatavalidtopch1    =>    decdatavalidtopch1,
        runningdisptopch1    =>    runningdisptopch1,
        txdatatstopch1    =>    txdatatstopch1,
        txctltstopch1    =>    txctltstopch1,
        fiforstrdqdtopch1    =>    fiforstrdqdtopch1,
        endskwqdtopch1    =>    endskwqdtopch1,
        endskwrdptrstopch1    =>    endskwrdptrstopch1,
        alignstatustopch1    =>    alignstatustopch1,
        alignstatussync0topch1    =>    alignstatussync0topch1,
        fifordoutcomp0topch1    =>    fifordoutcomp0topch1,
        cgcomprddalltopch1    =>    cgcomprddalltopch1,
        cgcompwralltopch1    =>    cgcompwralltopch1,
        delcondmet0topch1    =>    delcondmet0topch1,
        insertincomplete0topch1    =>    insertincomplete0topch1,
        fifoovr0topch1    =>    fifoovr0topch1,
        latencycomp0topch1    =>    latencycomp0topch1,
        rxdatarstopch1    =>    rxdatarstopch1,
        rxctlrstopch1    =>    rxctlrstopch1,
        rdenablesynctopch0    =>    rdenablesynctopch0,
        txdatatctopch0    =>    txdatatctopch0,
        txctltctopch0    =>    txctltctopch0,
        syncstatustopch0    =>    syncstatustopch0,
        rdaligntopch0    =>    rdaligntopch0,
        aligndetsynctopch0    =>    aligndetsynctopch0,
        fifordintopch0    =>    fifordintopch0,
        alignstatussynctopch0    =>    alignstatussynctopch0,
        cgcomprddintopch0    =>    cgcomprddintopch0,
        cgcompwrintopch0    =>    cgcompwrintopch0,
        delcondmetintopch0    =>    delcondmetintopch0,
        fifoovrintopch0    =>    fifoovrintopch0,
        latencycompintopch0    =>    latencycompintopch0,
        insertincompleteintopch0    =>    insertincompleteintopch0,
        decdatatopch0    =>    decdatatopch0,
        decctltopch0    =>    decctltopch0,
        decdatavalidtopch0    =>    decdatavalidtopch0,
        runningdisptopch0    =>    runningdisptopch0,
        txdatatstopch0    =>    txdatatstopch0,
        txctltstopch0    =>    txctltstopch0,
        fiforstrdqdtopch0    =>    fiforstrdqdtopch0,
        endskwqdtopch0    =>    endskwqdtopch0,
        endskwrdptrstopch0    =>    endskwrdptrstopch0,
        alignstatustopch0    =>    alignstatustopch0,
        alignstatussync0topch0    =>    alignstatussync0topch0,
        fifordoutcomp0topch0    =>    fifordoutcomp0topch0,
        cgcomprddalltopch0    =>    cgcomprddalltopch0,
        cgcompwralltopch0    =>    cgcompwralltopch0,
        delcondmet0topch0    =>    delcondmet0topch0,
        insertincomplete0topch0    =>    insertincomplete0topch0,
        fifoovr0topch0    =>    fifoovr0topch0,
        latencycomp0topch0    =>    latencycomp0topch0,
        rxdatarstopch0    =>    rxdatarstopch0,
        rxctlrstopch0    =>    rxctlrstopch0,
        rdenablesyncch2    =>    rdenablesyncch2,
        txdatatcch2    =>    txdatatcch2,
        txctltcch2    =>    txctltcch2,
        syncstatusch2    =>    syncstatusch2,
        rdalignch2    =>    rdalignch2,
        aligndetsyncch2    =>    aligndetsyncch2,
        fifordinch2    =>    fifordinch2,
        alignstatussyncch2    =>    alignstatussyncch2,
        cgcomprddinch2    =>    cgcomprddinch2,
        cgcompwrinch2    =>    cgcompwrinch2,
        delcondmetinch2    =>    delcondmetinch2,
        fifoovrinch2    =>    fifoovrinch2,
        latencycompinch2    =>    latencycompinch2,
        insertincompleteinch2    =>    insertincompleteinch2,
        decdatach2    =>    decdatach2,
        decctlch2    =>    decctlch2,
        decdatavalidch2    =>    decdatavalidch2,
        runningdispch2    =>    runningdispch2,
        txdatatsch2    =>    txdatatsch2,
        txctltsch2    =>    txctltsch2,
        fiforstrdqdch2    =>    fiforstrdqdch2,
        endskwqdch2    =>    endskwqdch2,
        endskwrdptrsch2    =>    endskwrdptrsch2,
        alignstatusch2    =>    alignstatusch2,
        alignstatussync0ch2    =>    alignstatussync0ch2,
        fifordoutcomp0ch2    =>    fifordoutcomp0ch2,
        cgcomprddallch2    =>    cgcomprddallch2,
        cgcompwrallch2    =>    cgcompwrallch2,
        delcondmet0ch2    =>    delcondmet0ch2,
        insertincomplete0ch2    =>    insertincomplete0ch2,
        fifoovr0ch2    =>    fifoovr0ch2,
        latencycomp0ch2    =>    latencycomp0ch2,
        rxdatarsch2    =>    rxdatarsch2,
        rxctlrsch2    =>    rxctlrsch2,
        rdenablesyncch1    =>    rdenablesyncch1,
        txdatatcch1    =>    txdatatcch1,
        txctltcch1    =>    txctltcch1,
        syncstatusch1    =>    syncstatusch1,
        rdalignch1    =>    rdalignch1,
        aligndetsyncch1    =>    aligndetsyncch1,
        fifordinch1    =>    fifordinch1,
        alignstatussyncch1    =>    alignstatussyncch1,
        cgcomprddinch1    =>    cgcomprddinch1,
        cgcompwrinch1    =>    cgcompwrinch1,
        delcondmetinch1    =>    delcondmetinch1,
        fifoovrinch1    =>    fifoovrinch1,
        latencycompinch1    =>    latencycompinch1,
        insertincompleteinch1    =>    insertincompleteinch1,
        decdatach1    =>    decdatach1,
        decctlch1    =>    decctlch1,
        decdatavalidch1    =>    decdatavalidch1,
        runningdispch1    =>    runningdispch1,
        txdatatsch1    =>    txdatatsch1,
        txctltsch1    =>    txctltsch1,
        fiforstrdqdch1    =>    fiforstrdqdch1,
        endskwqdch1    =>    endskwqdch1,
        endskwrdptrsch1    =>    endskwrdptrsch1,
        alignstatusch1    =>    alignstatusch1,
        alignstatussync0ch1    =>    alignstatussync0ch1,
        fifordoutcomp0ch1    =>    fifordoutcomp0ch1,
        cgcomprddallch1    =>    cgcomprddallch1,
        cgcompwrallch1    =>    cgcompwrallch1,
        delcondmet0ch1    =>    delcondmet0ch1,
        insertincomplete0ch1    =>    insertincomplete0ch1,
        fifoovr0ch1    =>    fifoovr0ch1,
        latencycomp0ch1    =>    latencycomp0ch1,
        rxdatarsch1    =>    rxdatarsch1,
        rxctlrsch1    =>    rxctlrsch1,
        rdenablesyncch0    =>    rdenablesyncch0,
        txdatatcch0    =>    txdatatcch0,
        txctltcch0    =>    txctltcch0,
        syncstatusch0    =>    syncstatusch0,
        rdalignch0    =>    rdalignch0,
        aligndetsyncch0    =>    aligndetsyncch0,
        fifordinch0    =>    fifordinch0,
        alignstatussyncch0    =>    alignstatussyncch0,
        cgcomprddinch0    =>    cgcomprddinch0,
        cgcompwrinch0    =>    cgcompwrinch0,
        delcondmetinch0    =>    delcondmetinch0,
        fifoovrinch0    =>    fifoovrinch0,
        latencycompinch0    =>    latencycompinch0,
        insertincompleteinch0    =>    insertincompleteinch0,
        decdatach0    =>    decdatach0,
        decctlch0    =>    decctlch0,
        decdatavalidch0    =>    decdatavalidch0,
        runningdispch0    =>    runningdispch0,
        txdatatsch0    =>    txdatatsch0,
        txctltsch0    =>    txctltsch0,
        fiforstrdqdch0    =>    fiforstrdqdch0,
        endskwqdch0    =>    endskwqdch0,
        endskwrdptrsch0    =>    endskwrdptrsch0,
        alignstatusch0    =>    alignstatusch0,
        alignstatussync0ch0    =>    alignstatussync0ch0,
        fifordoutcomp0ch0    =>    fifordoutcomp0ch0,
        cgcomprddallch0    =>    cgcomprddallch0,
        cgcompwrallch0    =>    cgcompwrallch0,
        delcondmet0ch0    =>    delcondmet0ch0,
        insertincomplete0ch0    =>    insertincomplete0ch0,
        fifoovr0ch0    =>    fifoovr0ch0,
        latencycomp0ch0    =>    latencycomp0ch0,
        rxdatarsch0    =>    rxdatarsch0,
        rxctlrsch0    =>    rxctlrsch0,
        rdenablesyncbotch2    =>    rdenablesyncbotch2,
        txdatatcbotch2    =>    txdatatcbotch2,
        txctltcbotch2    =>    txctltcbotch2,
        syncstatusbotch2    =>    syncstatusbotch2,
        rdalignbotch2    =>    rdalignbotch2,
        aligndetsyncbotch2    =>    aligndetsyncbotch2,
        fifordinbotch2    =>    fifordinbotch2,
        alignstatussyncbotch2    =>    alignstatussyncbotch2,
        cgcomprddinbotch2    =>    cgcomprddinbotch2,
        cgcompwrinbotch2    =>    cgcompwrinbotch2,
        delcondmetinbotch2    =>    delcondmetinbotch2,
        fifoovrinbotch2    =>    fifoovrinbotch2,
        latencycompinbotch2    =>    latencycompinbotch2,
        insertincompleteinbotch2    =>    insertincompleteinbotch2,
        decdatabotch2    =>    decdatabotch2,
        decctlbotch2    =>    decctlbotch2,
        decdatavalidbotch2    =>    decdatavalidbotch2,
        runningdispbotch2    =>    runningdispbotch2,
        txdatatsbotch2    =>    txdatatsbotch2,
        txctltsbotch2    =>    txctltsbotch2,
        fiforstrdqdbotch2    =>    fiforstrdqdbotch2,
        endskwqdbotch2    =>    endskwqdbotch2,
        endskwrdptrsbotch2    =>    endskwrdptrsbotch2,
        alignstatusbotch2    =>    alignstatusbotch2,
        alignstatussync0botch2    =>    alignstatussync0botch2,
        fifordoutcomp0botch2    =>    fifordoutcomp0botch2,
        cgcomprddallbotch2    =>    cgcomprddallbotch2,
        cgcompwrallbotch2    =>    cgcompwrallbotch2,
        delcondmet0botch2    =>    delcondmet0botch2,
        insertincomplete0botch2    =>    insertincomplete0botch2,
        fifoovr0botch2    =>    fifoovr0botch2,
        latencycomp0botch2    =>    latencycomp0botch2,
        rxdatarsbotch2    =>    rxdatarsbotch2,
        rxctlrsbotch2    =>    rxctlrsbotch2
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_8g_rx_pcs    is
    generic    (
        prot_mode    :    string    :=    "gige";
        tx_rx_parallel_loopback    :    string    :=    "dis_plpbk";
        pma_dw    :    string    :=    "eight_bit";
        pcs_bypass    :    string    :=    "dis_pcs_bypass";
        polarity_inversion    :    string    :=    "dis_pol_inv";
        wa_pd    :    string    :=    "wa_pd_10";
        wa_pd_data    :    bit_vector    :=    B"0000000000000000000000000000000000000000";
        wa_boundary_lock_ctrl    :    string    :=    "bit_slip";
        wa_pld_controlled    :    string    :=    "dis_pld_ctrl";
        wa_sync_sm_ctrl    :    string    :=    "gige_sync_sm";
        wa_rknumber_data    :    bit_vector    :=    B"00000000";
        wa_renumber_data    :    bit_vector    :=    B"000000";
        wa_rgnumber_data    :    bit_vector    :=    B"00000000";
        wa_rosnumber_data    :    bit_vector    :=    B"00";
        wa_kchar    :    string    :=    "dis_kchar";
        wa_det_latency_sync_status_beh    :    string    :=    "assert_sync_status_non_imm";
        wa_clk_slip_spacing    :    string    :=    "min_clk_slip_spacing";
        wa_clk_slip_spacing_data    :    bit_vector    :=    B"0000010000";
        bit_reversal    :    string    :=    "dis_bit_reversal";
        symbol_swap    :    string    :=    "dis_symbol_swap";
        deskew_pattern    :    bit_vector    :=    B"1101101000";
        deskew_prog_pattern_only    :    string    :=    "en_deskew_prog_pat_only";
        rate_match    :    string    :=    "dis_rm";
        eightb_tenb_decoder    :    string    :=    "dis_8b10b";
        err_flags_sel    :    string    :=    "err_flags_wa";
        polinv_8b10b_dec    :    string    :=    "dis_polinv_8b10b_dec";
        eightbtenb_decoder_output_sel    :    string    :=    "data_8b10b_decoder";
        invalid_code_flag_only    :    string    :=    "dis_invalid_code_only";
        auto_error_replacement    :    string    :=    "dis_err_replace";
        pad_or_edb_error_replace    :    string    :=    "replace_edb";
        byte_deserializer    :    string    :=    "dis_bds";
        byte_order    :    string    :=    "dis_bo";
        re_bo_on_wa    :    string    :=    "dis_re_bo_on_wa";
        bo_pattern    :    bit_vector    :=    B"00000000000000000000";
        bo_pad    :    bit_vector    :=    B"0000000000";
        phase_compensation_fifo    :    string    :=    "low_latency";
        prbs_ver    :    string    :=    "dis_prbs";
        cid_pattern    :    string    :=    "cid_pattern_0";
        cid_pattern_len    :    bit_vector    :=    B"00000000";
        bist_ver    :    string    :=    "dis_bist";
        cdr_ctrl    :    string    :=    "dis_cdr_ctrl";
        cdr_ctrl_rxvalid_mask    :    string    :=    "dis_rxvalid_mask";
        wait_cnt    :    bit_vector    :=    B"00000000";
        mask_cnt    :    bit_vector    :=    B"1111111111";
        auto_deassert_pc_rst_cnt_data    :    bit_vector    :=    B"00000";
        auto_pc_en_cnt_data    :    bit_vector    :=    B"0000000";
        eidle_entry_sd    :    string    :=    "dis_eidle_sd";
        eidle_entry_eios    :    string    :=    "dis_eidle_eios";
        eidle_entry_iei    :    string    :=    "dis_eidle_iei";
        rx_rcvd_clk    :    string    :=    "rcvd_clk_rcvd_clk";
        rx_clk1    :    string    :=    "rcvd_clk_clk1";
        rx_clk2    :    string    :=    "rcvd_clk_clk2";
        rx_rd_clk    :    string    :=    "pld_rx_clk";
        dw_one_or_two_symbol_bo    :    string    :=    "donot_care_one_two_bo";
        comp_fifo_rst_pld_ctrl    :    string    :=    "dis_comp_fifo_rst_pld_ctrl";
        bypass_pipeline_reg    :    string    :=    "dis_bypass_pipeline";
        agg_block_sel    :    string    :=    "same_smrt_pack";
        test_bus_sel    :    string    :=    "test_bus_sel";
        wa_rvnumber_data    :    bit_vector    :=    B"0000000000000";
        ctrl_plane_bonding_compensation    :    string    :=    "dis_compensation";
        clock_gate_rx    :    string    :=    "dis_clk_gating";
        prbs_ver_clr_flag    :    string    :=    "dis_prbs_clr_flag";
        hip_mode    :    string    :=    "dis_hip";
        ctrl_plane_bonding_distribution    :    string    :=    "not_master_chnl_distr";
        ctrl_plane_bonding_consumption    :    string    :=    "individual";
        pma_done_count    :    bit_vector    :=    B"000000000000000000";
        test_mode    :    string    :=    "prbs";
        bist_ver_clr_flag    :    string    :=    "dis_bist_clr_flag";
        wa_disp_err_flag    :    string    :=    "dis_disp_err_flag";
        wait_for_phfifo_cnt_data    :    bit_vector    :=    B"000000";
        runlength_check    :    string    :=    "en_runlength_sw";
        test_bus_sel_val    :    bit_vector    :=    B"0000";
        runlength_val    :    bit_vector    :=    B"000000";
        force_signal_detect    :    string    :=    "en_force_signal_detect";
        deskew    :    string    :=    "dis_deskew";
        rx_wr_clk    :    string    :=    "rx_clk2_div_1_2_4";
        rx_clk_free_running    :    string    :=    "en_rx_clk_free_run";
        rx_pcs_urst    :    string    :=    "en_rx_pcs_urst";
        self_switch_dw_scaling    :    string    :=    "dis_self_switch_dw_scaling";
        pipe_if_enable    :    string    :=    "dis_pipe_rx";
        pc_fifo_rst_pld_ctrl    :    string    :=    "dis_pc_fifo_rst_pld_ctrl";
        auto_speed_nego_gen2    :    string    :=    "dis_auto_speed_nego_g2";
        auto_speed_nego_gen3    :    string    :=    "dis_auto_speed_nego_g3";
        ibm_invalid_code    :    string    :=    "dis_ibm_invalid_code";
        channel_number    :    string    :=    "int";
        rx_refclk    :    string    :=    "dis_refclk_sel"
    );
    port    (
        hrdrst    :    in    std_logic_vector(0 downto 0);
        rxpcsrst    :    in    std_logic_vector(0 downto 0);
        rmfifouserrst    :    in    std_logic_vector(0 downto 0);
        phfifouserrst    :    in    std_logic_vector(0 downto 0);
        scanmode    :    in    std_logic_vector(0 downto 0);
        enablecommadetect    :    in    std_logic_vector(0 downto 0);
        a1a2size    :    in    std_logic_vector(0 downto 0);
        bitslip    :    in    std_logic_vector(0 downto 0);
        rmfiforeadenable    :    in    std_logic_vector(0 downto 0);
        rmfifowriteenable    :    in    std_logic_vector(0 downto 0);
        pldrxclk    :    in    std_logic_vector(0 downto 0);
        softresetrclk1    :    out    std_logic_vector(0 downto 0);
        polinvrx    :    in    std_logic_vector(0 downto 0);
        bitreversalenable    :    in    std_logic_vector(0 downto 0);
        bytereversalenable    :    in    std_logic_vector(0 downto 0);
        rcvdclkpma    :    in    std_logic_vector(0 downto 0);
        datain    :    in    std_logic_vector(19 downto 0);
        sigdetfrompma    :    in    std_logic_vector(0 downto 0);
        fiforstrdqd    :    in    std_logic_vector(0 downto 0);
        endskwqd    :    in    std_logic_vector(0 downto 0);
        endskwrdptrs    :    in    std_logic_vector(0 downto 0);
        alignstatus    :    in    std_logic_vector(0 downto 0);
        fiforstrdqdtoporbot    :    in    std_logic_vector(0 downto 0);
        endskwqdtoporbot    :    in    std_logic_vector(0 downto 0);
        endskwrdptrstoporbot    :    in    std_logic_vector(0 downto 0);
        alignstatustoporbot    :    in    std_logic_vector(0 downto 0);
        datafrinaggblock    :    in    std_logic_vector(7 downto 0);
        ctrlfromaggblock    :    in    std_logic_vector(0 downto 0);
        rxdatarstoporbot    :    in    std_logic_vector(7 downto 0);
        rxcontrolrstoporbot    :    in    std_logic_vector(0 downto 0);
        rcvdclk0pma    :    in    std_logic_vector(0 downto 0);
        parallelloopback    :    in    std_logic_vector(19 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        byteorder    :    in    std_logic_vector(0 downto 0);
        pxfifowrdisable    :    in    std_logic_vector(0 downto 0);
        pcfifordenable    :    in    std_logic_vector(0 downto 0);
        pmatestbus    :    in    std_logic_vector(7 downto 0);
        encodertestbus    :    in    std_logic_vector(9 downto 0);
        txctrltestbus    :    in    std_logic_vector(9 downto 0);
        phystatusinternal    :    in    std_logic_vector(0 downto 0);
        rxvalidinternal    :    in    std_logic_vector(0 downto 0);
        rxstatusinternal    :    in    std_logic_vector(2 downto 0);
        phystatuspcsgen3    :    in    std_logic_vector(0 downto 0);
        rxvalidpcsgen3    :    in    std_logic_vector(0 downto 0);
        rxstatuspcsgen3    :    in    std_logic_vector(2 downto 0);
        rxdatavalidpcsgen3    :    in    std_logic_vector(3 downto 0);
        rxblkstartpcsgen3    :    in    std_logic_vector(3 downto 0);
        rxsynchdrpcsgen3    :    in    std_logic_vector(1 downto 0);
        rxdatapcsgen3    :    in    std_logic_vector(63 downto 0);
        pipepowerdown    :    in    std_logic_vector(1 downto 0);
        rateswitchcontrol    :    in    std_logic_vector(0 downto 0);
        gen2ngen1    :    in    std_logic_vector(0 downto 0);
        gen2ngen1bundle    :    in    std_logic_vector(0 downto 0);
        eidleinfersel    :    in    std_logic_vector(2 downto 0);
        pipeloopbk    :    in    std_logic_vector(0 downto 0);
        pldltr    :    in    std_logic_vector(0 downto 0);
        prbscidenable    :    in    std_logic_vector(0 downto 0);
        txdiv2syncoutpipeup    :    in    std_logic_vector(0 downto 0);
        fifoselectoutpipeup    :    in    std_logic_vector(0 downto 0);
        txwrenableoutpipeup    :    in    std_logic_vector(0 downto 0);
        txrdenableoutpipeup    :    in    std_logic_vector(0 downto 0);
        txdiv2syncoutpipedown    :    in    std_logic_vector(0 downto 0);
        fifoselectoutpipedown    :    in    std_logic_vector(0 downto 0);
        txwrenableoutpipedown    :    in    std_logic_vector(0 downto 0);
        txrdenableoutpipedown    :    in    std_logic_vector(0 downto 0);
        alignstatussync0    :    in    std_logic_vector(0 downto 0);
        rmfifordincomp0    :    in    std_logic_vector(0 downto 0);
        cgcomprddall    :    in    std_logic_vector(0 downto 0);
        cgcompwrall    :    in    std_logic_vector(0 downto 0);
        delcondmet0    :    in    std_logic_vector(0 downto 0);
        fifoovr0    :    in    std_logic_vector(0 downto 0);
        latencycomp0    :    in    std_logic_vector(0 downto 0);
        insertincomplete0    :    in    std_logic_vector(0 downto 0);
        alignstatussync0toporbot    :    in    std_logic_vector(0 downto 0);
        fifordincomp0toporbot    :    in    std_logic_vector(0 downto 0);
        cgcomprddalltoporbot    :    in    std_logic_vector(0 downto 0);
        cgcompwralltoporbot    :    in    std_logic_vector(0 downto 0);
        delcondmet0toporbot    :    in    std_logic_vector(0 downto 0);
        fifoovr0toporbot    :    in    std_logic_vector(0 downto 0);
        latencycomp0toporbot    :    in    std_logic_vector(0 downto 0);
        insertincomplete0toporbot    :    in    std_logic_vector(0 downto 0);
        alignstatussync    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp    :    out    std_logic_vector(0 downto 0);
        cgcomprddout    :    out    std_logic_vector(1 downto 0);
        cgcompwrout    :    out    std_logic_vector(1 downto 0);
        delcondmetout    :    out    std_logic_vector(0 downto 0);
        fifoovrout    :    out    std_logic_vector(0 downto 0);
        latencycompout    :    out    std_logic_vector(0 downto 0);
        insertincompleteout    :    out    std_logic_vector(0 downto 0);
        dataout    :    out    std_logic_vector(63 downto 0);
        parallelrevloopback    :    out    std_logic_vector(19 downto 0);
        clocktopld    :    out    std_logic_vector(0 downto 0);
        bisterr    :    out    std_logic_vector(0 downto 0);
        clk2b    :    out    std_logic_vector(0 downto 0);
        rcvdclkpmab    :    out    std_logic_vector(0 downto 0);
        syncstatus    :    out    std_logic_vector(0 downto 0);
        decoderdatavalid    :    out    std_logic_vector(0 downto 0);
        decoderdata    :    out    std_logic_vector(7 downto 0);
        decoderctrl    :    out    std_logic_vector(0 downto 0);
        runningdisparity    :    out    std_logic_vector(1 downto 0);
        selftestdone    :    out    std_logic_vector(0 downto 0);
        selftesterr    :    out    std_logic_vector(0 downto 0);
        errdata    :    out    std_logic_vector(15 downto 0);
        errctrl    :    out    std_logic_vector(1 downto 0);
        prbsdone    :    out    std_logic_vector(0 downto 0);
        prbserrlt    :    out    std_logic_vector(0 downto 0);
        signaldetectout    :    out    std_logic_vector(0 downto 0);
        aligndetsync    :    out    std_logic_vector(1 downto 0);
        rdalign    :    out    std_logic_vector(1 downto 0);
        bistdone    :    out    std_logic_vector(0 downto 0);
        runlengthviolation    :    out    std_logic_vector(0 downto 0);
        rlvlt    :    out    std_logic_vector(0 downto 0);
        rmfifopartialfull    :    out    std_logic_vector(0 downto 0);
        rmfifofull    :    out    std_logic_vector(0 downto 0);
        rmfifopartialempty    :    out    std_logic_vector(0 downto 0);
        rmfifoempty    :    out    std_logic_vector(0 downto 0);
        pcfifofull    :    out    std_logic_vector(0 downto 0);
        pcfifoempty    :    out    std_logic_vector(0 downto 0);
        a1a2k1k2flag    :    out    std_logic_vector(3 downto 0);
        byteordflag    :    out    std_logic_vector(0 downto 0);
        rxpipeclk    :    out    std_logic_vector(0 downto 0);
        channeltestbusout    :    out    std_logic_vector(9 downto 0);
        rxpipesoftreset    :    out    std_logic_vector(0 downto 0);
        phystatus    :    out    std_logic_vector(0 downto 0);
        rxvalid    :    out    std_logic_vector(0 downto 0);
        rxstatus    :    out    std_logic_vector(2 downto 0);
        pipedata    :    out    std_logic_vector(63 downto 0);
        rxdatavalid    :    out    std_logic_vector(3 downto 0);
        rxblkstart    :    out    std_logic_vector(3 downto 0);
        rxsynchdr    :    out    std_logic_vector(1 downto 0);
        speedchange    :    out    std_logic_vector(0 downto 0);
        eidledetected    :    out    std_logic_vector(0 downto 0);
        wordalignboundary    :    out    std_logic_vector(4 downto 0);
        rxclkslip    :    out    std_logic_vector(0 downto 0);
        eidleexit    :    out    std_logic_vector(0 downto 0);
        earlyeios    :    out    std_logic_vector(0 downto 0);
        ltr    :    out    std_logic_vector(0 downto 0);
        pcswrapbackin    :    in    std_logic_vector(69 downto 0);
        rxdivsyncinchnlup    :    in    std_logic_vector(1 downto 0);
        rxdivsyncinchnldown    :    in    std_logic_vector(1 downto 0);
        wrenableinchnlup    :    in    std_logic_vector(0 downto 0);
        wrenableinchnldown    :    in    std_logic_vector(0 downto 0);
        rdenableinchnlup    :    in    std_logic_vector(0 downto 0);
        rdenableinchnldown    :    in    std_logic_vector(0 downto 0);
        rxweinchnlup    :    in    std_logic_vector(1 downto 0);
        rxweinchnldown    :    in    std_logic_vector(1 downto 0);
        resetpcptrsinchnlup    :    in    std_logic_vector(0 downto 0);
        resetpcptrsinchnldown    :    in    std_logic_vector(0 downto 0);
        configselinchnlup    :    in    std_logic_vector(0 downto 0);
        configselinchnldown    :    in    std_logic_vector(0 downto 0);
        speedchangeinchnlup    :    in    std_logic_vector(0 downto 0);
        speedchangeinchnldown    :    in    std_logic_vector(0 downto 0);
        pcieswitch    :    out    std_logic_vector(0 downto 0);
        rxdivsyncoutchnlup    :    out    std_logic_vector(1 downto 0);
        rxweoutchnlup    :    out    std_logic_vector(1 downto 0);
        wrenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        rdenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        resetpcptrsoutchnlup    :    out    std_logic_vector(0 downto 0);
        speedchangeoutchnlup    :    out    std_logic_vector(0 downto 0);
        configseloutchnlup    :    out    std_logic_vector(0 downto 0);
        rxdivsyncoutchnldown    :    out    std_logic_vector(1 downto 0);
        rxweoutchnldown    :    out    std_logic_vector(1 downto 0);
        wrenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        rdenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        resetpcptrsoutchnldown    :    out    std_logic_vector(0 downto 0);
        speedchangeoutchnldown    :    out    std_logic_vector(0 downto 0);
        configseloutchnldown    :    out    std_logic_vector(0 downto 0);
        resetpcptrsinchnluppipe    :    out    std_logic_vector(0 downto 0);
        resetpcptrsinchnldownpipe    :    out    std_logic_vector(0 downto 0);
        speedchangeinchnluppipe    :    out    std_logic_vector(0 downto 0);
        speedchangeinchnldownpipe    :    out    std_logic_vector(0 downto 0);
        disablepcfifobyteserdes    :    out    std_logic_vector(0 downto 0);
        resetpcptrs    :    out    std_logic_vector(0 downto 0);
        rcvdclkagg    :    in    std_logic_vector(0 downto 0);
        rcvdclkaggtoporbot    :    in    std_logic_vector(0 downto 0);
        dispcbytegen3    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        txfifordclkraw    :    in    std_logic_vector(0 downto 0);
        resetpcptrsgen3    :    in    std_logic_vector(0 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0);
        observablebyteserdesclock    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_8g_rx_pcs;

architecture behavior of stratixv_hssi_8g_rx_pcs is

component    stratixv_hssi_8g_rx_pcs_encrypted
    generic    (
        prot_mode    :    string    :=    "gige";
        tx_rx_parallel_loopback    :    string    :=    "dis_plpbk";
        pma_dw    :    string    :=    "eight_bit";
        pcs_bypass    :    string    :=    "dis_pcs_bypass";
        polarity_inversion    :    string    :=    "dis_pol_inv";
        wa_pd    :    string    :=    "wa_pd_10";
        wa_pd_data    :    bit_vector    :=    B"0000000000000000000000000000000000000000";
        wa_boundary_lock_ctrl    :    string    :=    "bit_slip";
        wa_pld_controlled    :    string    :=    "dis_pld_ctrl";
        wa_sync_sm_ctrl    :    string    :=    "gige_sync_sm";
        wa_rknumber_data    :    bit_vector    :=    B"00000000";
        wa_renumber_data    :    bit_vector    :=    B"000000";
        wa_rgnumber_data    :    bit_vector    :=    B"00000000";
        wa_rosnumber_data    :    bit_vector    :=    B"00";
        wa_kchar    :    string    :=    "dis_kchar";
        wa_det_latency_sync_status_beh    :    string    :=    "assert_sync_status_non_imm";
        wa_clk_slip_spacing    :    string    :=    "min_clk_slip_spacing";
        wa_clk_slip_spacing_data    :    bit_vector    :=    B"0000010000";
        bit_reversal    :    string    :=    "dis_bit_reversal";
        symbol_swap    :    string    :=    "dis_symbol_swap";
        deskew_pattern    :    bit_vector    :=    B"1101101000";
        deskew_prog_pattern_only    :    string    :=    "en_deskew_prog_pat_only";
        rate_match    :    string    :=    "dis_rm";
        eightb_tenb_decoder    :    string    :=    "dis_8b10b";
        err_flags_sel    :    string    :=    "err_flags_wa";
        polinv_8b10b_dec    :    string    :=    "dis_polinv_8b10b_dec";
        eightbtenb_decoder_output_sel    :    string    :=    "data_8b10b_decoder";
        invalid_code_flag_only    :    string    :=    "dis_invalid_code_only";
        auto_error_replacement    :    string    :=    "dis_err_replace";
        pad_or_edb_error_replace    :    string    :=    "replace_edb";
        byte_deserializer    :    string    :=    "dis_bds";
        byte_order    :    string    :=    "dis_bo";
        re_bo_on_wa    :    string    :=    "dis_re_bo_on_wa";
        bo_pattern    :    bit_vector    :=    B"00000000000000000000";
        bo_pad    :    bit_vector    :=    B"0000000000";
        phase_compensation_fifo    :    string    :=    "low_latency";
        prbs_ver    :    string    :=    "dis_prbs";
        cid_pattern    :    string    :=    "cid_pattern_0";
        cid_pattern_len    :    bit_vector    :=    B"00000000";
        bist_ver    :    string    :=    "dis_bist";
        cdr_ctrl    :    string    :=    "dis_cdr_ctrl";
        cdr_ctrl_rxvalid_mask    :    string    :=    "dis_rxvalid_mask";
        wait_cnt    :    bit_vector    :=    B"00000000";
        mask_cnt    :    bit_vector    :=    B"1111111111";
        auto_deassert_pc_rst_cnt_data    :    bit_vector    :=    B"00000";
        auto_pc_en_cnt_data    :    bit_vector    :=    B"0000000";
        eidle_entry_sd    :    string    :=    "dis_eidle_sd";
        eidle_entry_eios    :    string    :=    "dis_eidle_eios";
        eidle_entry_iei    :    string    :=    "dis_eidle_iei";
        rx_rcvd_clk    :    string    :=    "rcvd_clk_rcvd_clk";
        rx_clk1    :    string    :=    "rcvd_clk_clk1";
        rx_clk2    :    string    :=    "rcvd_clk_clk2";
        rx_rd_clk    :    string    :=    "pld_rx_clk";
        dw_one_or_two_symbol_bo    :    string    :=    "donot_care_one_two_bo";
        comp_fifo_rst_pld_ctrl    :    string    :=    "dis_comp_fifo_rst_pld_ctrl";
        bypass_pipeline_reg    :    string    :=    "dis_bypass_pipeline";
        agg_block_sel    :    string    :=    "same_smrt_pack";
        test_bus_sel    :    string    :=    "test_bus_sel";
        wa_rvnumber_data    :    bit_vector    :=    B"0000000000000";
        ctrl_plane_bonding_compensation    :    string    :=    "dis_compensation";
        clock_gate_rx    :    string    :=    "dis_clk_gating";
        prbs_ver_clr_flag    :    string    :=    "dis_prbs_clr_flag";
        hip_mode    :    string    :=    "dis_hip";
        ctrl_plane_bonding_distribution    :    string    :=    "not_master_chnl_distr";
        ctrl_plane_bonding_consumption    :    string    :=    "individual";
        pma_done_count    :    bit_vector    :=    B"000000000000000000";
        test_mode    :    string    :=    "prbs";
        bist_ver_clr_flag    :    string    :=    "dis_bist_clr_flag";
        wa_disp_err_flag    :    string    :=    "dis_disp_err_flag";
        wait_for_phfifo_cnt_data    :    bit_vector    :=    B"000000";
        runlength_check    :    string    :=    "en_runlength_sw";
        test_bus_sel_val    :    bit_vector    :=    B"0000";
        runlength_val    :    bit_vector    :=    B"000000";
        force_signal_detect    :    string    :=    "en_force_signal_detect";
        deskew    :    string    :=    "dis_deskew";
        rx_wr_clk    :    string    :=    "rx_clk2_div_1_2_4";
        rx_clk_free_running    :    string    :=    "en_rx_clk_free_run";
        rx_pcs_urst    :    string    :=    "en_rx_pcs_urst";
        self_switch_dw_scaling    :    string    :=    "dis_self_switch_dw_scaling";
        pipe_if_enable    :    string    :=    "dis_pipe_rx";
        pc_fifo_rst_pld_ctrl    :    string    :=    "dis_pc_fifo_rst_pld_ctrl";
        auto_speed_nego_gen2    :    string    :=    "dis_auto_speed_nego_g2";
        auto_speed_nego_gen3    :    string    :=    "dis_auto_speed_nego_g3";
        ibm_invalid_code    :    string    :=    "dis_ibm_invalid_code";
        channel_number    :    string    :=    "int";
        rx_refclk    :    string    :=    "dis_refclk_sel"
    );
    port    (
        hrdrst    :    in    std_logic_vector(0 downto 0);
        rxpcsrst    :    in    std_logic_vector(0 downto 0);
        rmfifouserrst    :    in    std_logic_vector(0 downto 0);
        phfifouserrst    :    in    std_logic_vector(0 downto 0);
        scanmode    :    in    std_logic_vector(0 downto 0);
        enablecommadetect    :    in    std_logic_vector(0 downto 0);
        a1a2size    :    in    std_logic_vector(0 downto 0);
        bitslip    :    in    std_logic_vector(0 downto 0);
        rmfiforeadenable    :    in    std_logic_vector(0 downto 0);
        rmfifowriteenable    :    in    std_logic_vector(0 downto 0);
        pldrxclk    :    in    std_logic_vector(0 downto 0);
        softresetrclk1    :    out    std_logic_vector(0 downto 0);
        polinvrx    :    in    std_logic_vector(0 downto 0);
        bitreversalenable    :    in    std_logic_vector(0 downto 0);
        bytereversalenable    :    in    std_logic_vector(0 downto 0);
        rcvdclkpma    :    in    std_logic_vector(0 downto 0);
        datain    :    in    std_logic_vector(19 downto 0);
        sigdetfrompma    :    in    std_logic_vector(0 downto 0);
        fiforstrdqd    :    in    std_logic_vector(0 downto 0);
        endskwqd    :    in    std_logic_vector(0 downto 0);
        endskwrdptrs    :    in    std_logic_vector(0 downto 0);
        alignstatus    :    in    std_logic_vector(0 downto 0);
        fiforstrdqdtoporbot    :    in    std_logic_vector(0 downto 0);
        endskwqdtoporbot    :    in    std_logic_vector(0 downto 0);
        endskwrdptrstoporbot    :    in    std_logic_vector(0 downto 0);
        alignstatustoporbot    :    in    std_logic_vector(0 downto 0);
        datafrinaggblock    :    in    std_logic_vector(7 downto 0);
        ctrlfromaggblock    :    in    std_logic_vector(0 downto 0);
        rxdatarstoporbot    :    in    std_logic_vector(7 downto 0);
        rxcontrolrstoporbot    :    in    std_logic_vector(0 downto 0);
        rcvdclk0pma    :    in    std_logic_vector(0 downto 0);
        parallelloopback    :    in    std_logic_vector(19 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        byteorder    :    in    std_logic_vector(0 downto 0);
        pxfifowrdisable    :    in    std_logic_vector(0 downto 0);
        pcfifordenable    :    in    std_logic_vector(0 downto 0);
        pmatestbus    :    in    std_logic_vector(7 downto 0);
        encodertestbus    :    in    std_logic_vector(9 downto 0);
        txctrltestbus    :    in    std_logic_vector(9 downto 0);
        phystatusinternal    :    in    std_logic_vector(0 downto 0);
        rxvalidinternal    :    in    std_logic_vector(0 downto 0);
        rxstatusinternal    :    in    std_logic_vector(2 downto 0);
        phystatuspcsgen3    :    in    std_logic_vector(0 downto 0);
        rxvalidpcsgen3    :    in    std_logic_vector(0 downto 0);
        rxstatuspcsgen3    :    in    std_logic_vector(2 downto 0);
        rxdatavalidpcsgen3    :    in    std_logic_vector(3 downto 0);
        rxblkstartpcsgen3    :    in    std_logic_vector(3 downto 0);
        rxsynchdrpcsgen3    :    in    std_logic_vector(1 downto 0);
        rxdatapcsgen3    :    in    std_logic_vector(63 downto 0);
        pipepowerdown    :    in    std_logic_vector(1 downto 0);
        rateswitchcontrol    :    in    std_logic_vector(0 downto 0);
        gen2ngen1    :    in    std_logic_vector(0 downto 0);
        gen2ngen1bundle    :    in    std_logic_vector(0 downto 0);
        eidleinfersel    :    in    std_logic_vector(2 downto 0);
        pipeloopbk    :    in    std_logic_vector(0 downto 0);
        pldltr    :    in    std_logic_vector(0 downto 0);
        prbscidenable    :    in    std_logic_vector(0 downto 0);
        txdiv2syncoutpipeup    :    in    std_logic_vector(0 downto 0);
        fifoselectoutpipeup    :    in    std_logic_vector(0 downto 0);
        txwrenableoutpipeup    :    in    std_logic_vector(0 downto 0);
        txrdenableoutpipeup    :    in    std_logic_vector(0 downto 0);
        txdiv2syncoutpipedown    :    in    std_logic_vector(0 downto 0);
        fifoselectoutpipedown    :    in    std_logic_vector(0 downto 0);
        txwrenableoutpipedown    :    in    std_logic_vector(0 downto 0);
        txrdenableoutpipedown    :    in    std_logic_vector(0 downto 0);
        alignstatussync0    :    in    std_logic_vector(0 downto 0);
        rmfifordincomp0    :    in    std_logic_vector(0 downto 0);
        cgcomprddall    :    in    std_logic_vector(0 downto 0);
        cgcompwrall    :    in    std_logic_vector(0 downto 0);
        delcondmet0    :    in    std_logic_vector(0 downto 0);
        fifoovr0    :    in    std_logic_vector(0 downto 0);
        latencycomp0    :    in    std_logic_vector(0 downto 0);
        insertincomplete0    :    in    std_logic_vector(0 downto 0);
        alignstatussync0toporbot    :    in    std_logic_vector(0 downto 0);
        fifordincomp0toporbot    :    in    std_logic_vector(0 downto 0);
        cgcomprddalltoporbot    :    in    std_logic_vector(0 downto 0);
        cgcompwralltoporbot    :    in    std_logic_vector(0 downto 0);
        delcondmet0toporbot    :    in    std_logic_vector(0 downto 0);
        fifoovr0toporbot    :    in    std_logic_vector(0 downto 0);
        latencycomp0toporbot    :    in    std_logic_vector(0 downto 0);
        insertincomplete0toporbot    :    in    std_logic_vector(0 downto 0);
        alignstatussync    :    out    std_logic_vector(0 downto 0);
        fifordoutcomp    :    out    std_logic_vector(0 downto 0);
        cgcomprddout    :    out    std_logic_vector(1 downto 0);
        cgcompwrout    :    out    std_logic_vector(1 downto 0);
        delcondmetout    :    out    std_logic_vector(0 downto 0);
        fifoovrout    :    out    std_logic_vector(0 downto 0);
        latencycompout    :    out    std_logic_vector(0 downto 0);
        insertincompleteout    :    out    std_logic_vector(0 downto 0);
        dataout    :    out    std_logic_vector(63 downto 0);
        parallelrevloopback    :    out    std_logic_vector(19 downto 0);
        clocktopld    :    out    std_logic_vector(0 downto 0);
        bisterr    :    out    std_logic_vector(0 downto 0);
        clk2b    :    out    std_logic_vector(0 downto 0);
        rcvdclkpmab    :    out    std_logic_vector(0 downto 0);
        syncstatus    :    out    std_logic_vector(0 downto 0);
        decoderdatavalid    :    out    std_logic_vector(0 downto 0);
        decoderdata    :    out    std_logic_vector(7 downto 0);
        decoderctrl    :    out    std_logic_vector(0 downto 0);
        runningdisparity    :    out    std_logic_vector(1 downto 0);
        selftestdone    :    out    std_logic_vector(0 downto 0);
        selftesterr    :    out    std_logic_vector(0 downto 0);
        errdata    :    out    std_logic_vector(15 downto 0);
        errctrl    :    out    std_logic_vector(1 downto 0);
        prbsdone    :    out    std_logic_vector(0 downto 0);
        prbserrlt    :    out    std_logic_vector(0 downto 0);
        signaldetectout    :    out    std_logic_vector(0 downto 0);
        aligndetsync    :    out    std_logic_vector(1 downto 0);
        rdalign    :    out    std_logic_vector(1 downto 0);
        bistdone    :    out    std_logic_vector(0 downto 0);
        runlengthviolation    :    out    std_logic_vector(0 downto 0);
        rlvlt    :    out    std_logic_vector(0 downto 0);
        rmfifopartialfull    :    out    std_logic_vector(0 downto 0);
        rmfifofull    :    out    std_logic_vector(0 downto 0);
        rmfifopartialempty    :    out    std_logic_vector(0 downto 0);
        rmfifoempty    :    out    std_logic_vector(0 downto 0);
        pcfifofull    :    out    std_logic_vector(0 downto 0);
        pcfifoempty    :    out    std_logic_vector(0 downto 0);
        a1a2k1k2flag    :    out    std_logic_vector(3 downto 0);
        byteordflag    :    out    std_logic_vector(0 downto 0);
        rxpipeclk    :    out    std_logic_vector(0 downto 0);
        channeltestbusout    :    out    std_logic_vector(9 downto 0);
        rxpipesoftreset    :    out    std_logic_vector(0 downto 0);
        phystatus    :    out    std_logic_vector(0 downto 0);
        rxvalid    :    out    std_logic_vector(0 downto 0);
        rxstatus    :    out    std_logic_vector(2 downto 0);
        pipedata    :    out    std_logic_vector(63 downto 0);
        rxdatavalid    :    out    std_logic_vector(3 downto 0);
        rxblkstart    :    out    std_logic_vector(3 downto 0);
        rxsynchdr    :    out    std_logic_vector(1 downto 0);
        speedchange    :    out    std_logic_vector(0 downto 0);
        eidledetected    :    out    std_logic_vector(0 downto 0);
        wordalignboundary    :    out    std_logic_vector(4 downto 0);
        rxclkslip    :    out    std_logic_vector(0 downto 0);
        eidleexit    :    out    std_logic_vector(0 downto 0);
        earlyeios    :    out    std_logic_vector(0 downto 0);
        ltr    :    out    std_logic_vector(0 downto 0);
        pcswrapbackin    :    in    std_logic_vector(69 downto 0);
        rxdivsyncinchnlup    :    in    std_logic_vector(1 downto 0);
        rxdivsyncinchnldown    :    in    std_logic_vector(1 downto 0);
        wrenableinchnlup    :    in    std_logic_vector(0 downto 0);
        wrenableinchnldown    :    in    std_logic_vector(0 downto 0);
        rdenableinchnlup    :    in    std_logic_vector(0 downto 0);
        rdenableinchnldown    :    in    std_logic_vector(0 downto 0);
        rxweinchnlup    :    in    std_logic_vector(1 downto 0);
        rxweinchnldown    :    in    std_logic_vector(1 downto 0);
        resetpcptrsinchnlup    :    in    std_logic_vector(0 downto 0);
        resetpcptrsinchnldown    :    in    std_logic_vector(0 downto 0);
        configselinchnlup    :    in    std_logic_vector(0 downto 0);
        configselinchnldown    :    in    std_logic_vector(0 downto 0);
        speedchangeinchnlup    :    in    std_logic_vector(0 downto 0);
        speedchangeinchnldown    :    in    std_logic_vector(0 downto 0);
        pcieswitch    :    out    std_logic_vector(0 downto 0);
        rxdivsyncoutchnlup    :    out    std_logic_vector(1 downto 0);
        rxweoutchnlup    :    out    std_logic_vector(1 downto 0);
        wrenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        rdenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        resetpcptrsoutchnlup    :    out    std_logic_vector(0 downto 0);
        speedchangeoutchnlup    :    out    std_logic_vector(0 downto 0);
        configseloutchnlup    :    out    std_logic_vector(0 downto 0);
        rxdivsyncoutchnldown    :    out    std_logic_vector(1 downto 0);
        rxweoutchnldown    :    out    std_logic_vector(1 downto 0);
        wrenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        rdenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        resetpcptrsoutchnldown    :    out    std_logic_vector(0 downto 0);
        speedchangeoutchnldown    :    out    std_logic_vector(0 downto 0);
        configseloutchnldown    :    out    std_logic_vector(0 downto 0);
        resetpcptrsinchnluppipe    :    out    std_logic_vector(0 downto 0);
        resetpcptrsinchnldownpipe    :    out    std_logic_vector(0 downto 0);
        speedchangeinchnluppipe    :    out    std_logic_vector(0 downto 0);
        speedchangeinchnldownpipe    :    out    std_logic_vector(0 downto 0);
        disablepcfifobyteserdes    :    out    std_logic_vector(0 downto 0);
        resetpcptrs    :    out    std_logic_vector(0 downto 0);
        rcvdclkagg    :    in    std_logic_vector(0 downto 0);
        rcvdclkaggtoporbot    :    in    std_logic_vector(0 downto 0);
        dispcbytegen3    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        txfifordclkraw    :    in    std_logic_vector(0 downto 0);
        resetpcptrsgen3    :    in    std_logic_vector(0 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0);
        observablebyteserdesclock    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_8g_rx_pcs_encrypted
    generic  map  (
        prot_mode    =>   prot_mode,
        tx_rx_parallel_loopback    =>   tx_rx_parallel_loopback,
        pma_dw    =>   pma_dw,
        pcs_bypass    =>   pcs_bypass,
        polarity_inversion    =>   polarity_inversion,
        wa_pd    =>   wa_pd,
        wa_pd_data    =>   wa_pd_data,
        wa_boundary_lock_ctrl    =>   wa_boundary_lock_ctrl,
        wa_pld_controlled    =>   wa_pld_controlled,
        wa_sync_sm_ctrl    =>   wa_sync_sm_ctrl,
        wa_rknumber_data    =>   wa_rknumber_data,
        wa_renumber_data    =>   wa_renumber_data,
        wa_rgnumber_data    =>   wa_rgnumber_data,
        wa_rosnumber_data    =>   wa_rosnumber_data,
        wa_kchar    =>   wa_kchar,
        wa_det_latency_sync_status_beh    =>   wa_det_latency_sync_status_beh,
        wa_clk_slip_spacing    =>   wa_clk_slip_spacing,
        wa_clk_slip_spacing_data    =>   wa_clk_slip_spacing_data,
        bit_reversal    =>   bit_reversal,
        symbol_swap    =>   symbol_swap,
        deskew_pattern    =>   deskew_pattern,
        deskew_prog_pattern_only    =>   deskew_prog_pattern_only,
        rate_match    =>   rate_match,
        eightb_tenb_decoder    =>   eightb_tenb_decoder,
        err_flags_sel    =>   err_flags_sel,
        polinv_8b10b_dec    =>   polinv_8b10b_dec,
        eightbtenb_decoder_output_sel    =>   eightbtenb_decoder_output_sel,
        invalid_code_flag_only    =>   invalid_code_flag_only,
        auto_error_replacement    =>   auto_error_replacement,
        pad_or_edb_error_replace    =>   pad_or_edb_error_replace,
        byte_deserializer    =>   byte_deserializer,
        byte_order    =>   byte_order,
        re_bo_on_wa    =>   re_bo_on_wa,
        bo_pattern    =>   bo_pattern,
        bo_pad    =>   bo_pad,
        phase_compensation_fifo    =>   phase_compensation_fifo,
        prbs_ver    =>   prbs_ver,
        cid_pattern    =>   cid_pattern,
        cid_pattern_len    =>   cid_pattern_len,
        bist_ver    =>   bist_ver,
        cdr_ctrl    =>   cdr_ctrl,
        cdr_ctrl_rxvalid_mask    =>   cdr_ctrl_rxvalid_mask,
        wait_cnt    =>   wait_cnt,
        mask_cnt    =>   mask_cnt,
        auto_deassert_pc_rst_cnt_data    =>   auto_deassert_pc_rst_cnt_data,
        auto_pc_en_cnt_data    =>   auto_pc_en_cnt_data,
        eidle_entry_sd    =>   eidle_entry_sd,
        eidle_entry_eios    =>   eidle_entry_eios,
        eidle_entry_iei    =>   eidle_entry_iei,
        rx_rcvd_clk    =>   rx_rcvd_clk,
        rx_clk1    =>   rx_clk1,
        rx_clk2    =>   rx_clk2,
        rx_rd_clk    =>   rx_rd_clk,
        dw_one_or_two_symbol_bo    =>   dw_one_or_two_symbol_bo,
        comp_fifo_rst_pld_ctrl    =>   comp_fifo_rst_pld_ctrl,
        bypass_pipeline_reg    =>   bypass_pipeline_reg,
        agg_block_sel    =>   agg_block_sel,
        test_bus_sel    =>   test_bus_sel,
        wa_rvnumber_data    =>   wa_rvnumber_data,
        ctrl_plane_bonding_compensation    =>   ctrl_plane_bonding_compensation,
        clock_gate_rx    =>   clock_gate_rx,
        prbs_ver_clr_flag    =>   prbs_ver_clr_flag,
        hip_mode    =>   hip_mode,
        ctrl_plane_bonding_distribution    =>   ctrl_plane_bonding_distribution,
        ctrl_plane_bonding_consumption    =>   ctrl_plane_bonding_consumption,
        pma_done_count    =>   pma_done_count,
        test_mode    =>   test_mode,
        bist_ver_clr_flag    =>   bist_ver_clr_flag,
        wa_disp_err_flag    =>   wa_disp_err_flag,
        wait_for_phfifo_cnt_data    =>   wait_for_phfifo_cnt_data,
        runlength_check    =>   runlength_check,
        test_bus_sel_val    =>   test_bus_sel_val,
        runlength_val    =>   runlength_val,
        force_signal_detect    =>   force_signal_detect,
        deskew    =>   deskew,
        rx_wr_clk    =>   rx_wr_clk,
        rx_clk_free_running    =>   rx_clk_free_running,
        rx_pcs_urst    =>   rx_pcs_urst,
        self_switch_dw_scaling    =>   self_switch_dw_scaling,
        pipe_if_enable    =>   pipe_if_enable,
        pc_fifo_rst_pld_ctrl    =>   pc_fifo_rst_pld_ctrl,
        auto_speed_nego_gen2    =>   auto_speed_nego_gen2,
        auto_speed_nego_gen3    =>   auto_speed_nego_gen3,
        ibm_invalid_code    =>   ibm_invalid_code,
        channel_number    =>   channel_number,
        rx_refclk    =>   rx_refclk
    )
    port  map  (
        hrdrst    =>    hrdrst,
        rxpcsrst    =>    rxpcsrst,
        rmfifouserrst    =>    rmfifouserrst,
        phfifouserrst    =>    phfifouserrst,
        scanmode    =>    scanmode,
        enablecommadetect    =>    enablecommadetect,
        a1a2size    =>    a1a2size,
        bitslip    =>    bitslip,
        rmfiforeadenable    =>    rmfiforeadenable,
        rmfifowriteenable    =>    rmfifowriteenable,
        pldrxclk    =>    pldrxclk,
        softresetrclk1    =>    softresetrclk1,
        polinvrx    =>    polinvrx,
        bitreversalenable    =>    bitreversalenable,
        bytereversalenable    =>    bytereversalenable,
        rcvdclkpma    =>    rcvdclkpma,
        datain    =>    datain,
        sigdetfrompma    =>    sigdetfrompma,
        fiforstrdqd    =>    fiforstrdqd,
        endskwqd    =>    endskwqd,
        endskwrdptrs    =>    endskwrdptrs,
        alignstatus    =>    alignstatus,
        fiforstrdqdtoporbot    =>    fiforstrdqdtoporbot,
        endskwqdtoporbot    =>    endskwqdtoporbot,
        endskwrdptrstoporbot    =>    endskwrdptrstoporbot,
        alignstatustoporbot    =>    alignstatustoporbot,
        datafrinaggblock    =>    datafrinaggblock,
        ctrlfromaggblock    =>    ctrlfromaggblock,
        rxdatarstoporbot    =>    rxdatarstoporbot,
        rxcontrolrstoporbot    =>    rxcontrolrstoporbot,
        rcvdclk0pma    =>    rcvdclk0pma,
        parallelloopback    =>    parallelloopback,
        txpmaclk    =>    txpmaclk,
        byteorder    =>    byteorder,
        pxfifowrdisable    =>    pxfifowrdisable,
        pcfifordenable    =>    pcfifordenable,
        pmatestbus    =>    pmatestbus,
        encodertestbus    =>    encodertestbus,
        txctrltestbus    =>    txctrltestbus,
        phystatusinternal    =>    phystatusinternal,
        rxvalidinternal    =>    rxvalidinternal,
        rxstatusinternal    =>    rxstatusinternal,
        phystatuspcsgen3    =>    phystatuspcsgen3,
        rxvalidpcsgen3    =>    rxvalidpcsgen3,
        rxstatuspcsgen3    =>    rxstatuspcsgen3,
        rxdatavalidpcsgen3    =>    rxdatavalidpcsgen3,
        rxblkstartpcsgen3    =>    rxblkstartpcsgen3,
        rxsynchdrpcsgen3    =>    rxsynchdrpcsgen3,
        rxdatapcsgen3    =>    rxdatapcsgen3,
        pipepowerdown    =>    pipepowerdown,
        rateswitchcontrol    =>    rateswitchcontrol,
        gen2ngen1    =>    gen2ngen1,
        gen2ngen1bundle    =>    gen2ngen1bundle,
        eidleinfersel    =>    eidleinfersel,
        pipeloopbk    =>    pipeloopbk,
        pldltr    =>    pldltr,
        prbscidenable    =>    prbscidenable,
        txdiv2syncoutpipeup    =>    txdiv2syncoutpipeup,
        fifoselectoutpipeup    =>    fifoselectoutpipeup,
        txwrenableoutpipeup    =>    txwrenableoutpipeup,
        txrdenableoutpipeup    =>    txrdenableoutpipeup,
        txdiv2syncoutpipedown    =>    txdiv2syncoutpipedown,
        fifoselectoutpipedown    =>    fifoselectoutpipedown,
        txwrenableoutpipedown    =>    txwrenableoutpipedown,
        txrdenableoutpipedown    =>    txrdenableoutpipedown,
        alignstatussync0    =>    alignstatussync0,
        rmfifordincomp0    =>    rmfifordincomp0,
        cgcomprddall    =>    cgcomprddall,
        cgcompwrall    =>    cgcompwrall,
        delcondmet0    =>    delcondmet0,
        fifoovr0    =>    fifoovr0,
        latencycomp0    =>    latencycomp0,
        insertincomplete0    =>    insertincomplete0,
        alignstatussync0toporbot    =>    alignstatussync0toporbot,
        fifordincomp0toporbot    =>    fifordincomp0toporbot,
        cgcomprddalltoporbot    =>    cgcomprddalltoporbot,
        cgcompwralltoporbot    =>    cgcompwralltoporbot,
        delcondmet0toporbot    =>    delcondmet0toporbot,
        fifoovr0toporbot    =>    fifoovr0toporbot,
        latencycomp0toporbot    =>    latencycomp0toporbot,
        insertincomplete0toporbot    =>    insertincomplete0toporbot,
        alignstatussync    =>    alignstatussync,
        fifordoutcomp    =>    fifordoutcomp,
        cgcomprddout    =>    cgcomprddout,
        cgcompwrout    =>    cgcompwrout,
        delcondmetout    =>    delcondmetout,
        fifoovrout    =>    fifoovrout,
        latencycompout    =>    latencycompout,
        insertincompleteout    =>    insertincompleteout,
        dataout    =>    dataout,
        parallelrevloopback    =>    parallelrevloopback,
        clocktopld    =>    clocktopld,
        bisterr    =>    bisterr,
        clk2b    =>    clk2b,
        rcvdclkpmab    =>    rcvdclkpmab,
        syncstatus    =>    syncstatus,
        decoderdatavalid    =>    decoderdatavalid,
        decoderdata    =>    decoderdata,
        decoderctrl    =>    decoderctrl,
        runningdisparity    =>    runningdisparity,
        selftestdone    =>    selftestdone,
        selftesterr    =>    selftesterr,
        errdata    =>    errdata,
        errctrl    =>    errctrl,
        prbsdone    =>    prbsdone,
        prbserrlt    =>    prbserrlt,
        signaldetectout    =>    signaldetectout,
        aligndetsync    =>    aligndetsync,
        rdalign    =>    rdalign,
        bistdone    =>    bistdone,
        runlengthviolation    =>    runlengthviolation,
        rlvlt    =>    rlvlt,
        rmfifopartialfull    =>    rmfifopartialfull,
        rmfifofull    =>    rmfifofull,
        rmfifopartialempty    =>    rmfifopartialempty,
        rmfifoempty    =>    rmfifoempty,
        pcfifofull    =>    pcfifofull,
        pcfifoempty    =>    pcfifoempty,
        a1a2k1k2flag    =>    a1a2k1k2flag,
        byteordflag    =>    byteordflag,
        rxpipeclk    =>    rxpipeclk,
        channeltestbusout    =>    channeltestbusout,
        rxpipesoftreset    =>    rxpipesoftreset,
        phystatus    =>    phystatus,
        rxvalid    =>    rxvalid,
        rxstatus    =>    rxstatus,
        pipedata    =>    pipedata,
        rxdatavalid    =>    rxdatavalid,
        rxblkstart    =>    rxblkstart,
        rxsynchdr    =>    rxsynchdr,
        speedchange    =>    speedchange,
        eidledetected    =>    eidledetected,
        wordalignboundary    =>    wordalignboundary,
        rxclkslip    =>    rxclkslip,
        eidleexit    =>    eidleexit,
        earlyeios    =>    earlyeios,
        ltr    =>    ltr,
        pcswrapbackin    =>    pcswrapbackin,
        rxdivsyncinchnlup    =>    rxdivsyncinchnlup,
        rxdivsyncinchnldown    =>    rxdivsyncinchnldown,
        wrenableinchnlup    =>    wrenableinchnlup,
        wrenableinchnldown    =>    wrenableinchnldown,
        rdenableinchnlup    =>    rdenableinchnlup,
        rdenableinchnldown    =>    rdenableinchnldown,
        rxweinchnlup    =>    rxweinchnlup,
        rxweinchnldown    =>    rxweinchnldown,
        resetpcptrsinchnlup    =>    resetpcptrsinchnlup,
        resetpcptrsinchnldown    =>    resetpcptrsinchnldown,
        configselinchnlup    =>    configselinchnlup,
        configselinchnldown    =>    configselinchnldown,
        speedchangeinchnlup    =>    speedchangeinchnlup,
        speedchangeinchnldown    =>    speedchangeinchnldown,
        pcieswitch    =>    pcieswitch,
        rxdivsyncoutchnlup    =>    rxdivsyncoutchnlup,
        rxweoutchnlup    =>    rxweoutchnlup,
        wrenableoutchnlup    =>    wrenableoutchnlup,
        rdenableoutchnlup    =>    rdenableoutchnlup,
        resetpcptrsoutchnlup    =>    resetpcptrsoutchnlup,
        speedchangeoutchnlup    =>    speedchangeoutchnlup,
        configseloutchnlup    =>    configseloutchnlup,
        rxdivsyncoutchnldown    =>    rxdivsyncoutchnldown,
        rxweoutchnldown    =>    rxweoutchnldown,
        wrenableoutchnldown    =>    wrenableoutchnldown,
        rdenableoutchnldown    =>    rdenableoutchnldown,
        resetpcptrsoutchnldown    =>    resetpcptrsoutchnldown,
        speedchangeoutchnldown    =>    speedchangeoutchnldown,
        configseloutchnldown    =>    configseloutchnldown,
        resetpcptrsinchnluppipe    =>    resetpcptrsinchnluppipe,
        resetpcptrsinchnldownpipe    =>    resetpcptrsinchnldownpipe,
        speedchangeinchnluppipe    =>    speedchangeinchnluppipe,
        speedchangeinchnldownpipe    =>    speedchangeinchnldownpipe,
        disablepcfifobyteserdes    =>    disablepcfifobyteserdes,
        resetpcptrs    =>    resetpcptrs,
        rcvdclkagg    =>    rcvdclkagg,
        rcvdclkaggtoporbot    =>    rcvdclkaggtoporbot,
        dispcbytegen3    =>    dispcbytegen3,
        refclkdig    =>    refclkdig,
        txfifordclkraw    =>    txfifordclkraw,
        resetpcptrsgen3    =>    resetpcptrsgen3,
        syncdatain    =>    syncdatain,
        observablebyteserdesclock    =>    observablebyteserdesclock
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_8g_tx_pcs    is
    generic    (
        prot_mode    :    string    :=    "basic";
        hip_mode    :    string    :=    "dis_hip";
        pma_dw    :    string    :=    "eight_bit";
        pcs_bypass    :    string    :=    "dis_pcs_bypass";
        phase_compensation_fifo    :    string    :=    "low_latency";
        tx_compliance_controlled_disparity    :    string    :=    "dis_txcompliance";
        force_kchar    :    string    :=    "dis_force_kchar";
        force_echar    :    string    :=    "dis_force_echar";
        byte_serializer    :    string    :=    "dis_bs";
        data_selection_8b10b_encoder_input    :    string    :=    "normal_data_path";
        eightb_tenb_disp_ctrl    :    string    :=    "dis_disp_ctrl";
        eightb_tenb_encoder    :    string    :=    "dis_8b10b";
        prbs_gen    :    string    :=    "dis_prbs";
        cid_pattern    :    string    :=    "cid_pattern_0";
        cid_pattern_len    :    bit_vector    :=    B"00000000";
        bist_gen    :    string    :=    "dis_bist";
        bit_reversal    :    string    :=    "dis_bit_reversal";
        symbol_swap    :    string    :=    "dis_symbol_swap";
        polarity_inversion    :    string    :=    "dis_polinv";
        tx_bitslip    :    string    :=    "dis_tx_bitslip";
        agg_block_sel    :    string    :=    "same_smrt_pack";
        revloop_back_rm    :    string    :=    "dis_rev_loopback_rx_rm";
        phfifo_write_clk_sel    :    string    :=    "pld_tx_clk";
        ctrl_plane_bonding_consumption    :    string    :=    "individual";
        bypass_pipeline_reg    :    string    :=    "dis_bypass_pipeline";
        ctrl_plane_bonding_distribution    :    string    :=    "not_master_chnl_distr";
        test_mode    :    string    :=    "prbs";
        clock_gate_tx    :    string    :=    "dis_clk_gating";
        self_switch_dw_scaling    :    string    :=    "dis_self_switch_dw_scaling";
        ctrl_plane_bonding_compensation    :    string    :=    "dis_compensation";
        refclk_b_clk_sel    :    string    :=    "tx_pma_clock";
        auto_speed_nego_gen2    :    string    :=    "dis_auto_speed_nego_g2";
        auto_speed_nego_gen3    :    string    :=    "dis_auto_speed_nego_g3";
        channel_number    :    string    :=    "int"
    );
    port    (
        txpcsreset    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        scanmode    :    in    std_logic_vector(0 downto 0);
        datain    :    in    std_logic_vector(43 downto 0);
        coreclk    :    in    std_logic_vector(0 downto 0);
        invpol    :    in    std_logic_vector(0 downto 0);
        xgmdatain    :    in    std_logic_vector(7 downto 0);
        xgmctrl    :    in    std_logic_vector(0 downto 0);
        xgmdataintoporbottom    :    in    std_logic_vector(7 downto 0);
        xgmctrltoporbottom    :    in    std_logic_vector(0 downto 0);
        txpmalocalclk    :    in    std_logic_vector(0 downto 0);
        enrevparallellpbk    :    in    std_logic_vector(0 downto 0);
        revparallellpbkdata    :    in    std_logic_vector(19 downto 0);
        phfifowrenable    :    in    std_logic_vector(0 downto 0);
        phfiforddisable    :    in    std_logic_vector(0 downto 0);
        phfiforeset    :    in    std_logic_vector(0 downto 0);
        detectrxloopin    :    in    std_logic_vector(0 downto 0);
        powerdn    :    in    std_logic_vector(1 downto 0);
        pipeenrevparallellpbkin    :    in    std_logic_vector(0 downto 0);
        pipetxswing    :    in    std_logic_vector(0 downto 0);
        pipetxdeemph    :    in    std_logic_vector(0 downto 0);
        pipetxmargin    :    in    std_logic_vector(2 downto 0);
        rxpolarityin    :    in    std_logic_vector(0 downto 0);
        polinvrxin    :    in    std_logic_vector(0 downto 0);
        elecidleinfersel    :    in    std_logic_vector(2 downto 0);
        rateswitch    :    in    std_logic_vector(0 downto 0);
        rateswitchbundle    :    in    std_logic_vector(0 downto 0);
        prbscidenable    :    in    std_logic_vector(0 downto 0);
        bitslipboundaryselect    :    in    std_logic_vector(4 downto 0);
        phfifooverflow    :    out    std_logic_vector(0 downto 0);
        phfifounderflow    :    out    std_logic_vector(0 downto 0);
        clkout    :    out    std_logic_vector(0 downto 0);
        clkoutgen3    :    out    std_logic_vector(0 downto 0);
        xgmdataout    :    out    std_logic_vector(7 downto 0);
        xgmctrlenable    :    out    std_logic_vector(0 downto 0);
        dataout    :    out    std_logic_vector(19 downto 0);
        rdenablesync    :    out    std_logic_vector(0 downto 0);
        refclkb    :    out    std_logic_vector(0 downto 0);
        parallelfdbkout    :    out    std_logic_vector(19 downto 0);
        txpipeclk    :    out    std_logic_vector(0 downto 0);
        encodertestbus    :    out    std_logic_vector(9 downto 0);
        txctrltestbus    :    out    std_logic_vector(9 downto 0);
        txpipesoftreset    :    out    std_logic_vector(0 downto 0);
        txpipeelectidle    :    out    std_logic_vector(0 downto 0);
        detectrxloopout    :    out    std_logic_vector(0 downto 0);
        pipepowerdownout    :    out    std_logic_vector(1 downto 0);
        pipeenrevparallellpbkout    :    out    std_logic_vector(0 downto 0);
        phfifotxswing    :    out    std_logic_vector(0 downto 0);
        phfifotxdeemph    :    out    std_logic_vector(0 downto 0);
        phfifotxmargin    :    out    std_logic_vector(2 downto 0);
        txdataouttogen3    :    out    std_logic_vector(31 downto 0);
        txdatakouttogen3    :    out    std_logic_vector(3 downto 0);
        txdatavalidouttogen3    :    out    std_logic_vector(3 downto 0);
        txblkstartout    :    out    std_logic_vector(3 downto 0);
        txsynchdrout    :    out    std_logic_vector(1 downto 0);
        txcomplianceout    :    out    std_logic_vector(0 downto 0);
        txelecidleout    :    out    std_logic_vector(0 downto 0);
        rxpolarityout    :    out    std_logic_vector(0 downto 0);
        polinvrxout    :    out    std_logic_vector(0 downto 0);
        grayelecidleinferselout    :    out    std_logic_vector(2 downto 0);
        txdivsyncinchnlup    :    in    std_logic_vector(1 downto 0);
        txdivsyncinchnldown    :    in    std_logic_vector(1 downto 0);
        wrenableinchnlup    :    in    std_logic_vector(0 downto 0);
        wrenableinchnldown    :    in    std_logic_vector(0 downto 0);
        rdenableinchnlup    :    in    std_logic_vector(0 downto 0);
        rdenableinchnldown    :    in    std_logic_vector(0 downto 0);
        fifoselectinchnlup    :    in    std_logic_vector(1 downto 0);
        fifoselectinchnldown    :    in    std_logic_vector(1 downto 0);
        resetpcptrs    :    in    std_logic_vector(0 downto 0);
        resetpcptrsinchnlup    :    in    std_logic_vector(0 downto 0);
        resetpcptrsinchnldown    :    in    std_logic_vector(0 downto 0);
        dispcbyte    :    in    std_logic_vector(0 downto 0);
        txdivsyncoutchnlup    :    out    std_logic_vector(1 downto 0);
        txdivsyncoutchnldown    :    out    std_logic_vector(1 downto 0);
        rdenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        rdenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        wrenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        wrenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        fifoselectoutchnlup    :    out    std_logic_vector(1 downto 0);
        fifoselectoutchnldown    :    out    std_logic_vector(1 downto 0);
        txfifordclkraw    :    out    std_logic_vector(0 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0);
        observablebyteserdesclock    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_8g_tx_pcs;

architecture behavior of stratixv_hssi_8g_tx_pcs is

component    stratixv_hssi_8g_tx_pcs_encrypted
    generic    (
        prot_mode    :    string    :=    "basic";
        hip_mode    :    string    :=    "dis_hip";
        pma_dw    :    string    :=    "eight_bit";
        pcs_bypass    :    string    :=    "dis_pcs_bypass";
        phase_compensation_fifo    :    string    :=    "low_latency";
        tx_compliance_controlled_disparity    :    string    :=    "dis_txcompliance";
        force_kchar    :    string    :=    "dis_force_kchar";
        force_echar    :    string    :=    "dis_force_echar";
        byte_serializer    :    string    :=    "dis_bs";
        data_selection_8b10b_encoder_input    :    string    :=    "normal_data_path";
        eightb_tenb_disp_ctrl    :    string    :=    "dis_disp_ctrl";
        eightb_tenb_encoder    :    string    :=    "dis_8b10b";
        prbs_gen    :    string    :=    "dis_prbs";
        cid_pattern    :    string    :=    "cid_pattern_0";
        cid_pattern_len    :    bit_vector    :=    B"00000000";
        bist_gen    :    string    :=    "dis_bist";
        bit_reversal    :    string    :=    "dis_bit_reversal";
        symbol_swap    :    string    :=    "dis_symbol_swap";
        polarity_inversion    :    string    :=    "dis_polinv";
        tx_bitslip    :    string    :=    "dis_tx_bitslip";
        agg_block_sel    :    string    :=    "same_smrt_pack";
        revloop_back_rm    :    string    :=    "dis_rev_loopback_rx_rm";
        phfifo_write_clk_sel    :    string    :=    "pld_tx_clk";
        ctrl_plane_bonding_consumption    :    string    :=    "individual";
        bypass_pipeline_reg    :    string    :=    "dis_bypass_pipeline";
        ctrl_plane_bonding_distribution    :    string    :=    "not_master_chnl_distr";
        test_mode    :    string    :=    "prbs";
        clock_gate_tx    :    string    :=    "dis_clk_gating";
        self_switch_dw_scaling    :    string    :=    "dis_self_switch_dw_scaling";
        ctrl_plane_bonding_compensation    :    string    :=    "dis_compensation";
        refclk_b_clk_sel    :    string    :=    "tx_pma_clock";
        auto_speed_nego_gen2    :    string    :=    "dis_auto_speed_nego_g2";
        auto_speed_nego_gen3    :    string    :=    "dis_auto_speed_nego_g3";
        channel_number    :    string    :=    "int"
    );
    port    (
        txpcsreset    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        scanmode    :    in    std_logic_vector(0 downto 0);
        datain    :    in    std_logic_vector(43 downto 0);
        coreclk    :    in    std_logic_vector(0 downto 0);
        invpol    :    in    std_logic_vector(0 downto 0);
        xgmdatain    :    in    std_logic_vector(7 downto 0);
        xgmctrl    :    in    std_logic_vector(0 downto 0);
        xgmdataintoporbottom    :    in    std_logic_vector(7 downto 0);
        xgmctrltoporbottom    :    in    std_logic_vector(0 downto 0);
        txpmalocalclk    :    in    std_logic_vector(0 downto 0);
        enrevparallellpbk    :    in    std_logic_vector(0 downto 0);
        revparallellpbkdata    :    in    std_logic_vector(19 downto 0);
        phfifowrenable    :    in    std_logic_vector(0 downto 0);
        phfiforddisable    :    in    std_logic_vector(0 downto 0);
        phfiforeset    :    in    std_logic_vector(0 downto 0);
        detectrxloopin    :    in    std_logic_vector(0 downto 0);
        powerdn    :    in    std_logic_vector(1 downto 0);
        pipeenrevparallellpbkin    :    in    std_logic_vector(0 downto 0);
        pipetxswing    :    in    std_logic_vector(0 downto 0);
        pipetxdeemph    :    in    std_logic_vector(0 downto 0);
        pipetxmargin    :    in    std_logic_vector(2 downto 0);
        rxpolarityin    :    in    std_logic_vector(0 downto 0);
        polinvrxin    :    in    std_logic_vector(0 downto 0);
        elecidleinfersel    :    in    std_logic_vector(2 downto 0);
        rateswitch    :    in    std_logic_vector(0 downto 0);
        rateswitchbundle    :    in    std_logic_vector(0 downto 0);
        prbscidenable    :    in    std_logic_vector(0 downto 0);
        bitslipboundaryselect    :    in    std_logic_vector(4 downto 0);
        phfifooverflow    :    out    std_logic_vector(0 downto 0);
        phfifounderflow    :    out    std_logic_vector(0 downto 0);
        clkout    :    out    std_logic_vector(0 downto 0);
        clkoutgen3    :    out    std_logic_vector(0 downto 0);
        xgmdataout    :    out    std_logic_vector(7 downto 0);
        xgmctrlenable    :    out    std_logic_vector(0 downto 0);
        dataout    :    out    std_logic_vector(19 downto 0);
        rdenablesync    :    out    std_logic_vector(0 downto 0);
        refclkb    :    out    std_logic_vector(0 downto 0);
        parallelfdbkout    :    out    std_logic_vector(19 downto 0);
        txpipeclk    :    out    std_logic_vector(0 downto 0);
        encodertestbus    :    out    std_logic_vector(9 downto 0);
        txctrltestbus    :    out    std_logic_vector(9 downto 0);
        txpipesoftreset    :    out    std_logic_vector(0 downto 0);
        txpipeelectidle    :    out    std_logic_vector(0 downto 0);
        detectrxloopout    :    out    std_logic_vector(0 downto 0);
        pipepowerdownout    :    out    std_logic_vector(1 downto 0);
        pipeenrevparallellpbkout    :    out    std_logic_vector(0 downto 0);
        phfifotxswing    :    out    std_logic_vector(0 downto 0);
        phfifotxdeemph    :    out    std_logic_vector(0 downto 0);
        phfifotxmargin    :    out    std_logic_vector(2 downto 0);
        txdataouttogen3    :    out    std_logic_vector(31 downto 0);
        txdatakouttogen3    :    out    std_logic_vector(3 downto 0);
        txdatavalidouttogen3    :    out    std_logic_vector(3 downto 0);
        txblkstartout    :    out    std_logic_vector(3 downto 0);
        txsynchdrout    :    out    std_logic_vector(1 downto 0);
        txcomplianceout    :    out    std_logic_vector(0 downto 0);
        txelecidleout    :    out    std_logic_vector(0 downto 0);
        rxpolarityout    :    out    std_logic_vector(0 downto 0);
        polinvrxout    :    out    std_logic_vector(0 downto 0);
        grayelecidleinferselout    :    out    std_logic_vector(2 downto 0);
        txdivsyncinchnlup    :    in    std_logic_vector(1 downto 0);
        txdivsyncinchnldown    :    in    std_logic_vector(1 downto 0);
        wrenableinchnlup    :    in    std_logic_vector(0 downto 0);
        wrenableinchnldown    :    in    std_logic_vector(0 downto 0);
        rdenableinchnlup    :    in    std_logic_vector(0 downto 0);
        rdenableinchnldown    :    in    std_logic_vector(0 downto 0);
        fifoselectinchnlup    :    in    std_logic_vector(1 downto 0);
        fifoselectinchnldown    :    in    std_logic_vector(1 downto 0);
        resetpcptrs    :    in    std_logic_vector(0 downto 0);
        resetpcptrsinchnlup    :    in    std_logic_vector(0 downto 0);
        resetpcptrsinchnldown    :    in    std_logic_vector(0 downto 0);
        dispcbyte    :    in    std_logic_vector(0 downto 0);
        txdivsyncoutchnlup    :    out    std_logic_vector(1 downto 0);
        txdivsyncoutchnldown    :    out    std_logic_vector(1 downto 0);
        rdenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        rdenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        wrenableoutchnlup    :    out    std_logic_vector(0 downto 0);
        wrenableoutchnldown    :    out    std_logic_vector(0 downto 0);
        fifoselectoutchnlup    :    out    std_logic_vector(1 downto 0);
        fifoselectoutchnldown    :    out    std_logic_vector(1 downto 0);
        txfifordclkraw    :    out    std_logic_vector(0 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0);
        observablebyteserdesclock    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_8g_tx_pcs_encrypted
    generic  map  (
        prot_mode    =>   prot_mode,
        hip_mode    =>   hip_mode,
        pma_dw    =>   pma_dw,
        pcs_bypass    =>   pcs_bypass,
        phase_compensation_fifo    =>   phase_compensation_fifo,
        tx_compliance_controlled_disparity    =>   tx_compliance_controlled_disparity,
        force_kchar    =>   force_kchar,
        force_echar    =>   force_echar,
        byte_serializer    =>   byte_serializer,
        data_selection_8b10b_encoder_input    =>   data_selection_8b10b_encoder_input,
        eightb_tenb_disp_ctrl    =>   eightb_tenb_disp_ctrl,
        eightb_tenb_encoder    =>   eightb_tenb_encoder,
        prbs_gen    =>   prbs_gen,
        cid_pattern    =>   cid_pattern,
        cid_pattern_len    =>   cid_pattern_len,
        bist_gen    =>   bist_gen,
        bit_reversal    =>   bit_reversal,
        symbol_swap    =>   symbol_swap,
        polarity_inversion    =>   polarity_inversion,
        tx_bitslip    =>   tx_bitslip,
        agg_block_sel    =>   agg_block_sel,
        revloop_back_rm    =>   revloop_back_rm,
        phfifo_write_clk_sel    =>   phfifo_write_clk_sel,
        ctrl_plane_bonding_consumption    =>   ctrl_plane_bonding_consumption,
        bypass_pipeline_reg    =>   bypass_pipeline_reg,
        ctrl_plane_bonding_distribution    =>   ctrl_plane_bonding_distribution,
        test_mode    =>   test_mode,
        clock_gate_tx    =>   clock_gate_tx,
        self_switch_dw_scaling    =>   self_switch_dw_scaling,
        ctrl_plane_bonding_compensation    =>   ctrl_plane_bonding_compensation,
        refclk_b_clk_sel    =>   refclk_b_clk_sel,
        auto_speed_nego_gen2    =>   auto_speed_nego_gen2,
        auto_speed_nego_gen3    =>   auto_speed_nego_gen3,
        channel_number    =>   channel_number
    )
    port  map  (
        txpcsreset    =>    txpcsreset,
        refclkdig    =>    refclkdig,
        scanmode    =>    scanmode,
        datain    =>    datain,
        coreclk    =>    coreclk,
        invpol    =>    invpol,
        xgmdatain    =>    xgmdatain,
        xgmctrl    =>    xgmctrl,
        xgmdataintoporbottom    =>    xgmdataintoporbottom,
        xgmctrltoporbottom    =>    xgmctrltoporbottom,
        txpmalocalclk    =>    txpmalocalclk,
        enrevparallellpbk    =>    enrevparallellpbk,
        revparallellpbkdata    =>    revparallellpbkdata,
        phfifowrenable    =>    phfifowrenable,
        phfiforddisable    =>    phfiforddisable,
        phfiforeset    =>    phfiforeset,
        detectrxloopin    =>    detectrxloopin,
        powerdn    =>    powerdn,
        pipeenrevparallellpbkin    =>    pipeenrevparallellpbkin,
        pipetxswing    =>    pipetxswing,
        pipetxdeemph    =>    pipetxdeemph,
        pipetxmargin    =>    pipetxmargin,
        rxpolarityin    =>    rxpolarityin,
        polinvrxin    =>    polinvrxin,
        elecidleinfersel    =>    elecidleinfersel,
        rateswitch    =>    rateswitch,
        rateswitchbundle    =>    rateswitchbundle,
        prbscidenable    =>    prbscidenable,
        bitslipboundaryselect    =>    bitslipboundaryselect,
        phfifooverflow    =>    phfifooverflow,
        phfifounderflow    =>    phfifounderflow,
        clkout    =>    clkout,
        clkoutgen3    =>    clkoutgen3,
        xgmdataout    =>    xgmdataout,
        xgmctrlenable    =>    xgmctrlenable,
        dataout    =>    dataout,
        rdenablesync    =>    rdenablesync,
        refclkb    =>    refclkb,
        parallelfdbkout    =>    parallelfdbkout,
        txpipeclk    =>    txpipeclk,
        encodertestbus    =>    encodertestbus,
        txctrltestbus    =>    txctrltestbus,
        txpipesoftreset    =>    txpipesoftreset,
        txpipeelectidle    =>    txpipeelectidle,
        detectrxloopout    =>    detectrxloopout,
        pipepowerdownout    =>    pipepowerdownout,
        pipeenrevparallellpbkout    =>    pipeenrevparallellpbkout,
        phfifotxswing    =>    phfifotxswing,
        phfifotxdeemph    =>    phfifotxdeemph,
        phfifotxmargin    =>    phfifotxmargin,
        txdataouttogen3    =>    txdataouttogen3,
        txdatakouttogen3    =>    txdatakouttogen3,
        txdatavalidouttogen3    =>    txdatavalidouttogen3,
        txblkstartout    =>    txblkstartout,
        txsynchdrout    =>    txsynchdrout,
        txcomplianceout    =>    txcomplianceout,
        txelecidleout    =>    txelecidleout,
        rxpolarityout    =>    rxpolarityout,
        polinvrxout    =>    polinvrxout,
        grayelecidleinferselout    =>    grayelecidleinferselout,
        txdivsyncinchnlup    =>    txdivsyncinchnlup,
        txdivsyncinchnldown    =>    txdivsyncinchnldown,
        wrenableinchnlup    =>    wrenableinchnlup,
        wrenableinchnldown    =>    wrenableinchnldown,
        rdenableinchnlup    =>    rdenableinchnlup,
        rdenableinchnldown    =>    rdenableinchnldown,
        fifoselectinchnlup    =>    fifoselectinchnlup,
        fifoselectinchnldown    =>    fifoselectinchnldown,
        resetpcptrs    =>    resetpcptrs,
        resetpcptrsinchnlup    =>    resetpcptrsinchnlup,
        resetpcptrsinchnldown    =>    resetpcptrsinchnldown,
        dispcbyte    =>    dispcbyte,
        txdivsyncoutchnlup    =>    txdivsyncoutchnlup,
        txdivsyncoutchnldown    =>    txdivsyncoutchnldown,
        rdenableoutchnlup    =>    rdenableoutchnlup,
        rdenableoutchnldown    =>    rdenableoutchnldown,
        wrenableoutchnlup    =>    wrenableoutchnlup,
        wrenableoutchnldown    =>    wrenableoutchnldown,
        fifoselectoutchnlup    =>    fifoselectoutchnlup,
        fifoselectoutchnldown    =>    fifoselectoutchnldown,
        txfifordclkraw    =>    txfifordclkraw,
        syncdatain    =>    syncdatain,
        observablebyteserdesclock    =>    observablebyteserdesclock
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pipe_gen1_2    is
    generic    (
        prot_mode    :    string    :=    "pipe_g1";
        hip_mode    :    string    :=    "dis_hip";
        tx_pipe_enable    :    string    :=    "dis_pipe_tx";
        rx_pipe_enable    :    string    :=    "dis_pipe_rx";
        pipe_byte_de_serializer_en    :    string    :=    "dont_care_bds";
        txswing    :    string    :=    "dis_txswing";
        rxdetect_bypass    :    string    :=    "dis_rxdetect_bypass";
        error_replace_pad    :    string    :=    "replace_edb";
        ind_error_reporting    :    string    :=    "dis_ind_error_reporting";
        phystatus_rst_toggle    :    string    :=    "dis_phystatus_rst_toggle";
        elecidle_delay    :    string    :=    "elec_idle_delay";
        elec_idle_delay_val    :    bit_vector    :=    B"000";
        phy_status_delay    :    string    :=    "phystatus_delay";
        phystatus_delay_val    :    bit_vector    :=    B"000";
        ctrl_plane_bonding_consumption    :    string    :=    "individual";
        byte_deserializer    :    string    :=    "dis_bds"
    );
    port    (
        pipetxclk    :    in    std_logic_vector(0 downto 0);
        piperxclk    :    in    std_logic_vector(0 downto 0);
        refclkb    :    in    std_logic_vector(0 downto 0);
        txpipereset    :    in    std_logic_vector(0 downto 0);
        rxpipereset    :    in    std_logic_vector(0 downto 0);
        refclkbreset    :    in    std_logic_vector(0 downto 0);
        rrdwidthrx    :    in    std_logic_vector(0 downto 0);
        txdetectrxloopback    :    in    std_logic_vector(0 downto 0);
        txelecidlein    :    in    std_logic_vector(0 downto 0);
        powerdown    :    in    std_logic_vector(1 downto 0);
        txdeemph    :    in    std_logic_vector(0 downto 0);
        txmargin    :    in    std_logic_vector(2 downto 0);
        txswingport    :    in    std_logic_vector(0 downto 0);
        txdch    :    in    std_logic_vector(43 downto 0);
        rxpolarity    :    in    std_logic_vector(0 downto 0);
        sigdetni    :    in    std_logic_vector(0 downto 0);
        rxvalid    :    out    std_logic_vector(0 downto 0);
        rxelecidle    :    out    std_logic_vector(0 downto 0);
        rxstatus    :    out    std_logic_vector(2 downto 0);
        rxdch    :    out    std_logic_vector(63 downto 0);
        phystatus    :    out    std_logic_vector(0 downto 0);
        revloopback    :    in    std_logic_vector(0 downto 0);
        polinvrx    :    in    std_logic_vector(0 downto 0);
        txd    :    out    std_logic_vector(43 downto 0);
        revloopbk    :    out    std_logic_vector(0 downto 0);
        revloopbkpcsgen3    :    in    std_logic_vector(0 downto 0);
        rxelectricalidlepcsgen3    :    in    std_logic_vector(0 downto 0);
        txelecidlecomp    :    in    std_logic_vector(0 downto 0);
        rindvrx    :    in    std_logic_vector(0 downto 0);
        rmasterrx    :    in    std_logic_vector(1 downto 0);
        speedchange    :    in    std_logic_vector(0 downto 0);
        speedchangechnlup    :    in    std_logic_vector(0 downto 0);
        speedchangechnldown    :    in    std_logic_vector(0 downto 0);
        rxd    :    in    std_logic_vector(63 downto 0);
        txelecidleout    :    out    std_logic_vector(0 downto 0);
        txdetectrx    :    out    std_logic_vector(0 downto 0);
        powerstate    :    out    std_logic_vector(3 downto 0);
        rxfound    :    in    std_logic_vector(0 downto 0);
        rxdetectvalid    :    in    std_logic_vector(0 downto 0);
        rxelectricalidle    :    in    std_logic_vector(0 downto 0);
        powerstatetransitiondone    :    in    std_logic_vector(0 downto 0);
        powerstatetransitiondoneena    :    in    std_logic_vector(0 downto 0);
        txdeemphint    :    out    std_logic_vector(0 downto 0);
        txmarginint    :    out    std_logic_vector(2 downto 0);
        txswingint    :    out    std_logic_vector(0 downto 0);
        rxelectricalidleout    :    out    std_logic_vector(0 downto 0);
        rxpolaritypcsgen3    :    in    std_logic_vector(0 downto 0);
        polinvrxint    :    out    std_logic_vector(0 downto 0);
        speedchangeout    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_pipe_gen1_2;

architecture behavior of stratixv_hssi_pipe_gen1_2 is

component    stratixv_hssi_pipe_gen1_2_encrypted
    generic    (
        prot_mode    :    string    :=    "pipe_g1";
        hip_mode    :    string    :=    "dis_hip";
        tx_pipe_enable    :    string    :=    "dis_pipe_tx";
        rx_pipe_enable    :    string    :=    "dis_pipe_rx";
        pipe_byte_de_serializer_en    :    string    :=    "dont_care_bds";
        txswing    :    string    :=    "dis_txswing";
        rxdetect_bypass    :    string    :=    "dis_rxdetect_bypass";
        error_replace_pad    :    string    :=    "replace_edb";
        ind_error_reporting    :    string    :=    "dis_ind_error_reporting";
        phystatus_rst_toggle    :    string    :=    "dis_phystatus_rst_toggle";
        elecidle_delay    :    string    :=    "elec_idle_delay";
        elec_idle_delay_val    :    bit_vector    :=    B"000";
        phy_status_delay    :    string    :=    "phystatus_delay";
        phystatus_delay_val    :    bit_vector    :=    B"000";
        ctrl_plane_bonding_consumption    :    string    :=    "individual";
        byte_deserializer    :    string    :=    "dis_bds"
    );
    port    (
        pipetxclk    :    in    std_logic_vector(0 downto 0);
        piperxclk    :    in    std_logic_vector(0 downto 0);
        refclkb    :    in    std_logic_vector(0 downto 0);
        txpipereset    :    in    std_logic_vector(0 downto 0);
        rxpipereset    :    in    std_logic_vector(0 downto 0);
        refclkbreset    :    in    std_logic_vector(0 downto 0);
        rrdwidthrx    :    in    std_logic_vector(0 downto 0);
        txdetectrxloopback    :    in    std_logic_vector(0 downto 0);
        txelecidlein    :    in    std_logic_vector(0 downto 0);
        powerdown    :    in    std_logic_vector(1 downto 0);
        txdeemph    :    in    std_logic_vector(0 downto 0);
        txmargin    :    in    std_logic_vector(2 downto 0);
        txswingport    :    in    std_logic_vector(0 downto 0);
        txdch    :    in    std_logic_vector(43 downto 0);
        rxpolarity    :    in    std_logic_vector(0 downto 0);
        sigdetni    :    in    std_logic_vector(0 downto 0);
        rxvalid    :    out    std_logic_vector(0 downto 0);
        rxelecidle    :    out    std_logic_vector(0 downto 0);
        rxstatus    :    out    std_logic_vector(2 downto 0);
        rxdch    :    out    std_logic_vector(63 downto 0);
        phystatus    :    out    std_logic_vector(0 downto 0);
        revloopback    :    in    std_logic_vector(0 downto 0);
        polinvrx    :    in    std_logic_vector(0 downto 0);
        txd    :    out    std_logic_vector(43 downto 0);
        revloopbk    :    out    std_logic_vector(0 downto 0);
        revloopbkpcsgen3    :    in    std_logic_vector(0 downto 0);
        rxelectricalidlepcsgen3    :    in    std_logic_vector(0 downto 0);
        txelecidlecomp    :    in    std_logic_vector(0 downto 0);
        rindvrx    :    in    std_logic_vector(0 downto 0);
        rmasterrx    :    in    std_logic_vector(1 downto 0);
        speedchange    :    in    std_logic_vector(0 downto 0);
        speedchangechnlup    :    in    std_logic_vector(0 downto 0);
        speedchangechnldown    :    in    std_logic_vector(0 downto 0);
        rxd    :    in    std_logic_vector(63 downto 0);
        txelecidleout    :    out    std_logic_vector(0 downto 0);
        txdetectrx    :    out    std_logic_vector(0 downto 0);
        powerstate    :    out    std_logic_vector(3 downto 0);
        rxfound    :    in    std_logic_vector(0 downto 0);
        rxdetectvalid    :    in    std_logic_vector(0 downto 0);
        rxelectricalidle    :    in    std_logic_vector(0 downto 0);
        powerstatetransitiondone    :    in    std_logic_vector(0 downto 0);
        powerstatetransitiondoneena    :    in    std_logic_vector(0 downto 0);
        txdeemphint    :    out    std_logic_vector(0 downto 0);
        txmarginint    :    out    std_logic_vector(2 downto 0);
        txswingint    :    out    std_logic_vector(0 downto 0);
        rxelectricalidleout    :    out    std_logic_vector(0 downto 0);
        rxpolaritypcsgen3    :    in    std_logic_vector(0 downto 0);
        polinvrxint    :    out    std_logic_vector(0 downto 0);
        speedchangeout    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_pipe_gen1_2_encrypted
    generic  map  (
        prot_mode    =>   prot_mode,
        hip_mode    =>   hip_mode,
        tx_pipe_enable    =>   tx_pipe_enable,
        rx_pipe_enable    =>   rx_pipe_enable,
        pipe_byte_de_serializer_en    =>   pipe_byte_de_serializer_en,
        txswing    =>   txswing,
        rxdetect_bypass    =>   rxdetect_bypass,
        error_replace_pad    =>   error_replace_pad,
        ind_error_reporting    =>   ind_error_reporting,
        phystatus_rst_toggle    =>   phystatus_rst_toggle,
        elecidle_delay    =>   elecidle_delay,
        elec_idle_delay_val    =>   elec_idle_delay_val,
        phy_status_delay    =>   phy_status_delay,
        phystatus_delay_val    =>   phystatus_delay_val,
        ctrl_plane_bonding_consumption    =>   ctrl_plane_bonding_consumption,
        byte_deserializer    =>   byte_deserializer
    )
    port  map  (
        pipetxclk    =>    pipetxclk,
        piperxclk    =>    piperxclk,
        refclkb    =>    refclkb,
        txpipereset    =>    txpipereset,
        rxpipereset    =>    rxpipereset,
        refclkbreset    =>    refclkbreset,
        rrdwidthrx    =>    rrdwidthrx,
        txdetectrxloopback    =>    txdetectrxloopback,
        txelecidlein    =>    txelecidlein,
        powerdown    =>    powerdown,
        txdeemph    =>    txdeemph,
        txmargin    =>    txmargin,
        txswingport    =>    txswingport,
        txdch    =>    txdch,
        rxpolarity    =>    rxpolarity,
        sigdetni    =>    sigdetni,
        rxvalid    =>    rxvalid,
        rxelecidle    =>    rxelecidle,
        rxstatus    =>    rxstatus,
        rxdch    =>    rxdch,
        phystatus    =>    phystatus,
        revloopback    =>    revloopback,
        polinvrx    =>    polinvrx,
        txd    =>    txd,
        revloopbk    =>    revloopbk,
        revloopbkpcsgen3    =>    revloopbkpcsgen3,
        rxelectricalidlepcsgen3    =>    rxelectricalidlepcsgen3,
        txelecidlecomp    =>    txelecidlecomp,
        rindvrx    =>    rindvrx,
        rmasterrx    =>    rmasterrx,
        speedchange    =>    speedchange,
        speedchangechnlup    =>    speedchangechnlup,
        speedchangechnldown    =>    speedchangechnldown,
        rxd    =>    rxd,
        txelecidleout    =>    txelecidleout,
        txdetectrx    =>    txdetectrx,
        powerstate    =>    powerstate,
        rxfound    =>    rxfound,
        rxdetectvalid    =>    rxdetectvalid,
        rxelectricalidle    =>    rxelectricalidle,
        powerstatetransitiondone    =>    powerstatetransitiondone,
        powerstatetransitiondoneena    =>    powerstatetransitiondoneena,
        txdeemphint    =>    txdeemphint,
        txmarginint    =>    txmarginint,
        txswingint    =>    txswingint,
        rxelectricalidleout    =>    rxelectricalidleout,
        rxpolaritypcsgen3    =>    rxpolaritypcsgen3,
        polinvrxint    =>    polinvrxint,
        speedchangeout    =>    speedchangeout
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pipe_gen3    is
    generic    (
        mode    :    string    :=    "pipe_g1";
        ctrl_plane_bonding    :    string    :=    "individual";
        pipe_clk_sel    :    string    :=    "func_clk";
        rate_match_pad_insertion    :    string    :=    "dis_rm_fifo_pad_ins";
        ind_error_reporting    :    string    :=    "dis_ind_error_reporting";
        phystatus_rst_toggle_g3    :    string    :=    "dis_phystatus_rst_toggle_g3";
        phystatus_rst_toggle_g12    :    string    :=    "dis_phystatus_rst_toggle";
        cdr_control    :    string    :=    "en_cdr_ctrl";
        cid_enable    :    string    :=    "en_cid_mode";
        parity_chk_ts1    :    string    :=    "en_ts1_parity_chk";
        rxvalid_mask    :    string    :=    "rxvalid_mask_en";
        ph_fifo_reg_mode    :    string    :=    "phfifo_reg_mode_dis";
        test_mode_timers    :    string    :=    "dis_test_mode_timers";
        inf_ei_enable    :    string    :=    "dis_inf_ei";
        spd_chnge_g2_sel    :    string    :=    "false";
        cp_up_mstr    :    string    :=    "false";
        cp_dwn_mstr    :    string    :=    "false";
        cp_cons_sel    :    string    :=    "cp_cons_default";
        elecidle_delay_g12_data    :    bit_vector    :=    B"000";
        elecidle_delay_g12    :    string    :=    "elecidle_delay_g12";
        elecidle_delay_g3_data    :    bit_vector    :=    B"000";
        elecidle_delay_g3    :    string    :=    "elecidle_delay_g3";
        phy_status_delay_g12_data    :    bit_vector    :=    B"000";
        phy_status_delay_g12    :    string    :=    "phy_status_delay_g12";
        phy_status_delay_g3_data    :    bit_vector    :=    B"000";
        phy_status_delay_g3    :    string    :=    "phy_status_delay_g3";
        sigdet_wait_counter_data    :    bit_vector    :=    B"00000000";
        sigdet_wait_counter    :    string    :=    "sigdet_wait_counter";
        data_mask_count_val    :    bit_vector    :=    B"0000000000";
        data_mask_count    :    string    :=    "data_mask_count";
        pma_done_counter_data    :    bit_vector    :=    B"000000000000000000";
        pma_done_counter    :    string    :=    "pma_done_count";
        pc_en_counter_data    :    bit_vector    :=    B"00000";
        pc_en_counter    :    string    :=    "pc_en_count";
        pc_rst_counter_data    :    bit_vector    :=    B"0000";
        pc_rst_counter    :    string    :=    "pc_rst_count";
        phfifo_flush_wait_data    :    bit_vector    :=    B"000000";
        phfifo_flush_wait    :    string    :=    "phfifo_flush_wait";
        asn_clk_enable    :    string    :=    "false";
        free_run_clk_enable    :    string    :=    "true";
        asn_enable    :    string    :=    "dis_asn"
    );
    port    (
        rcvdclk    :    in    std_logic_vector(0 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        pcsdigclk    :    in    std_logic_vector(0 downto 0);
        pllfixedclk    :    in    std_logic_vector(0 downto 0);
        rtxgen3capen    :    in    std_logic_vector(0 downto 0);
        rrxgen3capen    :    in    std_logic_vector(0 downto 0);
        rtxdigclksel    :    in    std_logic_vector(0 downto 0);
        rrxdigclksel    :    in    std_logic_vector(0 downto 0);
        rxrstn    :    in    std_logic_vector(0 downto 0);
        txrstn    :    in    std_logic_vector(0 downto 0);
        scanmoden    :    in    std_logic_vector(0 downto 0);
        pldasyncstatus    :    out    std_logic_vector(5 downto 0);
        testout    :    out    std_logic_vector(19 downto 0);
        gen3datasel    :    out    std_logic_vector(0 downto 0);
        gen3clksel    :    out    std_logic_vector(0 downto 0);
        pcsrst    :    out    std_logic_vector(0 downto 0);
        dispcbyte    :    out    std_logic_vector(0 downto 0);
        resetpcprts    :    out    std_logic_vector(0 downto 0);
        shutdownclk    :    out    std_logic_vector(0 downto 0);
        txdata    :    in    std_logic_vector(31 downto 0);
        txdatak    :    in    std_logic_vector(3 downto 0);
        txdataskip    :    in    std_logic_vector(0 downto 0);
        txsynchdr    :    in    std_logic_vector(1 downto 0);
        txblkstart    :    in    std_logic_vector(0 downto 0);
        txelecidle    :    in    std_logic_vector(0 downto 0);
        txdetectrxloopback    :    in    std_logic_vector(0 downto 0);
        txcompliance    :    in    std_logic_vector(0 downto 0);
        rxpolarity    :    in    std_logic_vector(0 downto 0);
        powerdown    :    in    std_logic_vector(1 downto 0);
        rate    :    in    std_logic_vector(1 downto 0);
        txmargin    :    in    std_logic_vector(2 downto 0);
        txdeemph    :    in    std_logic_vector(0 downto 0);
        txswing    :    in    std_logic_vector(0 downto 0);
        eidleinfersel    :    in    std_logic_vector(2 downto 0);
        currentcoeff    :    in    std_logic_vector(17 downto 0);
        currentrxpreset    :    in    std_logic_vector(2 downto 0);
        rxupdatefc    :    in    std_logic_vector(0 downto 0);
        rxdataskip    :    out    std_logic_vector(3 downto 0);
        rxsynchdr    :    out    std_logic_vector(1 downto 0);
        rxblkstart    :    out    std_logic_vector(3 downto 0);
        rxvalid    :    out    std_logic_vector(0 downto 0);
        phystatus    :    out    std_logic_vector(0 downto 0);
        rxelecidle    :    out    std_logic_vector(0 downto 0);
        rxstatus    :    out    std_logic_vector(2 downto 0);
        rxdataint    :    in    std_logic_vector(31 downto 0);
        rxdatakint    :    in    std_logic_vector(3 downto 0);
        rxdataskipint    :    in    std_logic_vector(0 downto 0);
        rxsynchdrint    :    in    std_logic_vector(1 downto 0);
        rxblkstartint    :    in    std_logic_vector(0 downto 0);
        txdataint    :    out    std_logic_vector(31 downto 0);
        txdatakint    :    out    std_logic_vector(3 downto 0);
        txdataskipint    :    out    std_logic_vector(0 downto 0);
        txsynchdrint    :    out    std_logic_vector(1 downto 0);
        txblkstartint    :    out    std_logic_vector(0 downto 0);
        testinfei    :    out    std_logic_vector(18 downto 0);
        eidetint    :    in    std_logic_vector(0 downto 0);
        eipartialdetint    :    in    std_logic_vector(0 downto 0);
        idetint    :    in    std_logic_vector(0 downto 0);
        blkalgndint    :    in    std_logic_vector(0 downto 0);
        clkcompinsertint    :    in    std_logic_vector(0 downto 0);
        clkcompdeleteint    :    in    std_logic_vector(0 downto 0);
        clkcompoverflint    :    in    std_logic_vector(0 downto 0);
        clkcompundflint    :    in    std_logic_vector(0 downto 0);
        errdecodeint    :    in    std_logic_vector(0 downto 0);
        rcvlfsrchkint    :    in    std_logic_vector(0 downto 0);
        errencodeint    :    in    std_logic_vector(0 downto 0);
        rxpolarityint    :    out    std_logic_vector(0 downto 0);
        revlpbkint    :    out    std_logic_vector(0 downto 0);
        inferredrxvalidint    :    out    std_logic_vector(0 downto 0);
        rxd8gpcsin    :    in    std_logic_vector(63 downto 0);
        rxelecidle8gpcsin    :    in    std_logic_vector(0 downto 0);
        pldltr    :    in    std_logic_vector(0 downto 0);
        rxd8gpcsout    :    out    std_logic_vector(63 downto 0);
        revlpbk8gpcsout    :    out    std_logic_vector(0 downto 0);
        pmarxdetectvalid    :    in    std_logic_vector(0 downto 0);
        pmarxfound    :    in    std_logic_vector(0 downto 0);
        pmasignaldet    :    in    std_logic_vector(0 downto 0);
        pmapcieswdone    :    in    std_logic_vector(1 downto 0);
        pmapcieswitch    :    out    std_logic_vector(1 downto 0);
        pmatxmargin    :    out    std_logic_vector(2 downto 0);
        pmatxdeemph    :    out    std_logic_vector(0 downto 0);
        pmatxswing    :    out    std_logic_vector(0 downto 0);
        pmacurrentcoeff    :    out    std_logic_vector(17 downto 0);
        pmacurrentrxpreset    :    out    std_logic_vector(2 downto 0);
        pmatxelecidle    :    out    std_logic_vector(0 downto 0);
        pmatxdetectrx    :    out    std_logic_vector(0 downto 0);
        ppmeidleexit    :    out    std_logic_vector(0 downto 0);
        pmaltr    :    out    std_logic_vector(0 downto 0);
        pmaearlyeios    :    out    std_logic_vector(0 downto 0);
        pmarxdetpd    :    out    std_logic_vector(0 downto 0);
        bundlingindown    :    in    std_logic_vector(9 downto 0);
        bundlingoutdown    :    out    std_logic_vector(9 downto 0);
        rxpolarity8gpcsout    :    out    std_logic_vector(0 downto 0);
        speedchangeg2    :    in    std_logic_vector(0 downto 0);
        bundlingoutup    :    out    std_logic_vector(9 downto 0);
        bundlinginup    :    in    std_logic_vector(9 downto 0);
        masktxpll    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_pipe_gen3;

architecture behavior of stratixv_hssi_pipe_gen3 is

component    stratixv_hssi_pipe_gen3_encrypted
    generic    (
        mode    :    string    :=    "pipe_g1";
        ctrl_plane_bonding    :    string    :=    "individual";
        pipe_clk_sel    :    string    :=    "func_clk";
        rate_match_pad_insertion    :    string    :=    "dis_rm_fifo_pad_ins";
        ind_error_reporting    :    string    :=    "dis_ind_error_reporting";
        phystatus_rst_toggle_g3    :    string    :=    "dis_phystatus_rst_toggle_g3";
        phystatus_rst_toggle_g12    :    string    :=    "dis_phystatus_rst_toggle";
        cdr_control    :    string    :=    "en_cdr_ctrl";
        cid_enable    :    string    :=    "en_cid_mode";
        parity_chk_ts1    :    string    :=    "en_ts1_parity_chk";
        rxvalid_mask    :    string    :=    "rxvalid_mask_en";
        ph_fifo_reg_mode    :    string    :=    "phfifo_reg_mode_dis";
        test_mode_timers    :    string    :=    "dis_test_mode_timers";
        inf_ei_enable    :    string    :=    "dis_inf_ei";
        spd_chnge_g2_sel    :    string    :=    "false";
        cp_up_mstr    :    string    :=    "false";
        cp_dwn_mstr    :    string    :=    "false";
        cp_cons_sel    :    string    :=    "cp_cons_default";
        elecidle_delay_g12_data    :    bit_vector    :=    B"000";
        elecidle_delay_g12    :    string    :=    "elecidle_delay_g12";
        elecidle_delay_g3_data    :    bit_vector    :=    B"000";
        elecidle_delay_g3    :    string    :=    "elecidle_delay_g3";
        phy_status_delay_g12_data    :    bit_vector    :=    B"000";
        phy_status_delay_g12    :    string    :=    "phy_status_delay_g12";
        phy_status_delay_g3_data    :    bit_vector    :=    B"000";
        phy_status_delay_g3    :    string    :=    "phy_status_delay_g3";
        sigdet_wait_counter_data    :    bit_vector    :=    B"00000000";
        sigdet_wait_counter    :    string    :=    "sigdet_wait_counter";
        data_mask_count_val    :    bit_vector    :=    B"0000000000";
        data_mask_count    :    string    :=    "data_mask_count";
        pma_done_counter_data    :    bit_vector    :=    B"000000000000000000";
        pma_done_counter    :    string    :=    "pma_done_count";
        pc_en_counter_data    :    bit_vector    :=    B"00000";
        pc_en_counter    :    string    :=    "pc_en_count";
        pc_rst_counter_data    :    bit_vector    :=    B"0000";
        pc_rst_counter    :    string    :=    "pc_rst_count";
        phfifo_flush_wait_data    :    bit_vector    :=    B"000000";
        phfifo_flush_wait    :    string    :=    "phfifo_flush_wait";
        asn_clk_enable    :    string    :=    "false";
        free_run_clk_enable    :    string    :=    "true";
        asn_enable    :    string    :=    "dis_asn"
    );
    port    (
        rcvdclk    :    in    std_logic_vector(0 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        pcsdigclk    :    in    std_logic_vector(0 downto 0);
        pllfixedclk    :    in    std_logic_vector(0 downto 0);
        rtxgen3capen    :    in    std_logic_vector(0 downto 0);
        rrxgen3capen    :    in    std_logic_vector(0 downto 0);
        rtxdigclksel    :    in    std_logic_vector(0 downto 0);
        rrxdigclksel    :    in    std_logic_vector(0 downto 0);
        rxrstn    :    in    std_logic_vector(0 downto 0);
        txrstn    :    in    std_logic_vector(0 downto 0);
        scanmoden    :    in    std_logic_vector(0 downto 0);
        pldasyncstatus    :    out    std_logic_vector(5 downto 0);
        testout    :    out    std_logic_vector(19 downto 0);
        gen3datasel    :    out    std_logic_vector(0 downto 0);
        gen3clksel    :    out    std_logic_vector(0 downto 0);
        pcsrst    :    out    std_logic_vector(0 downto 0);
        dispcbyte    :    out    std_logic_vector(0 downto 0);
        resetpcprts    :    out    std_logic_vector(0 downto 0);
        shutdownclk    :    out    std_logic_vector(0 downto 0);
        txdata    :    in    std_logic_vector(31 downto 0);
        txdatak    :    in    std_logic_vector(3 downto 0);
        txdataskip    :    in    std_logic_vector(0 downto 0);
        txsynchdr    :    in    std_logic_vector(1 downto 0);
        txblkstart    :    in    std_logic_vector(0 downto 0);
        txelecidle    :    in    std_logic_vector(0 downto 0);
        txdetectrxloopback    :    in    std_logic_vector(0 downto 0);
        txcompliance    :    in    std_logic_vector(0 downto 0);
        rxpolarity    :    in    std_logic_vector(0 downto 0);
        powerdown    :    in    std_logic_vector(1 downto 0);
        rate    :    in    std_logic_vector(1 downto 0);
        txmargin    :    in    std_logic_vector(2 downto 0);
        txdeemph    :    in    std_logic_vector(0 downto 0);
        txswing    :    in    std_logic_vector(0 downto 0);
        eidleinfersel    :    in    std_logic_vector(2 downto 0);
        currentcoeff    :    in    std_logic_vector(17 downto 0);
        currentrxpreset    :    in    std_logic_vector(2 downto 0);
        rxupdatefc    :    in    std_logic_vector(0 downto 0);
        rxdataskip    :    out    std_logic_vector(3 downto 0);
        rxsynchdr    :    out    std_logic_vector(1 downto 0);
        rxblkstart    :    out    std_logic_vector(3 downto 0);
        rxvalid    :    out    std_logic_vector(0 downto 0);
        phystatus    :    out    std_logic_vector(0 downto 0);
        rxelecidle    :    out    std_logic_vector(0 downto 0);
        rxstatus    :    out    std_logic_vector(2 downto 0);
        rxdataint    :    in    std_logic_vector(31 downto 0);
        rxdatakint    :    in    std_logic_vector(3 downto 0);
        rxdataskipint    :    in    std_logic_vector(0 downto 0);
        rxsynchdrint    :    in    std_logic_vector(1 downto 0);
        rxblkstartint    :    in    std_logic_vector(0 downto 0);
        txdataint    :    out    std_logic_vector(31 downto 0);
        txdatakint    :    out    std_logic_vector(3 downto 0);
        txdataskipint    :    out    std_logic_vector(0 downto 0);
        txsynchdrint    :    out    std_logic_vector(1 downto 0);
        txblkstartint    :    out    std_logic_vector(0 downto 0);
        testinfei    :    out    std_logic_vector(18 downto 0);
        eidetint    :    in    std_logic_vector(0 downto 0);
        eipartialdetint    :    in    std_logic_vector(0 downto 0);
        idetint    :    in    std_logic_vector(0 downto 0);
        blkalgndint    :    in    std_logic_vector(0 downto 0);
        clkcompinsertint    :    in    std_logic_vector(0 downto 0);
        clkcompdeleteint    :    in    std_logic_vector(0 downto 0);
        clkcompoverflint    :    in    std_logic_vector(0 downto 0);
        clkcompundflint    :    in    std_logic_vector(0 downto 0);
        errdecodeint    :    in    std_logic_vector(0 downto 0);
        rcvlfsrchkint    :    in    std_logic_vector(0 downto 0);
        errencodeint    :    in    std_logic_vector(0 downto 0);
        rxpolarityint    :    out    std_logic_vector(0 downto 0);
        revlpbkint    :    out    std_logic_vector(0 downto 0);
        inferredrxvalidint    :    out    std_logic_vector(0 downto 0);
        rxd8gpcsin    :    in    std_logic_vector(63 downto 0);
        rxelecidle8gpcsin    :    in    std_logic_vector(0 downto 0);
        pldltr    :    in    std_logic_vector(0 downto 0);
        rxd8gpcsout    :    out    std_logic_vector(63 downto 0);
        revlpbk8gpcsout    :    out    std_logic_vector(0 downto 0);
        pmarxdetectvalid    :    in    std_logic_vector(0 downto 0);
        pmarxfound    :    in    std_logic_vector(0 downto 0);
        pmasignaldet    :    in    std_logic_vector(0 downto 0);
        pmapcieswdone    :    in    std_logic_vector(1 downto 0);
        pmapcieswitch    :    out    std_logic_vector(1 downto 0);
        pmatxmargin    :    out    std_logic_vector(2 downto 0);
        pmatxdeemph    :    out    std_logic_vector(0 downto 0);
        pmatxswing    :    out    std_logic_vector(0 downto 0);
        pmacurrentcoeff    :    out    std_logic_vector(17 downto 0);
        pmacurrentrxpreset    :    out    std_logic_vector(2 downto 0);
        pmatxelecidle    :    out    std_logic_vector(0 downto 0);
        pmatxdetectrx    :    out    std_logic_vector(0 downto 0);
        ppmeidleexit    :    out    std_logic_vector(0 downto 0);
        pmaltr    :    out    std_logic_vector(0 downto 0);
        pmaearlyeios    :    out    std_logic_vector(0 downto 0);
        pmarxdetpd    :    out    std_logic_vector(0 downto 0);
        bundlingindown    :    in    std_logic_vector(9 downto 0);
        bundlingoutdown    :    out    std_logic_vector(9 downto 0);
        rxpolarity8gpcsout    :    out    std_logic_vector(0 downto 0);
        speedchangeg2    :    in    std_logic_vector(0 downto 0);
        bundlingoutup    :    out    std_logic_vector(9 downto 0);
        bundlinginup    :    in    std_logic_vector(9 downto 0);
        masktxpll    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_pipe_gen3_encrypted
    generic  map  (
        mode    =>   mode,
        ctrl_plane_bonding    =>   ctrl_plane_bonding,
        pipe_clk_sel    =>   pipe_clk_sel,
        rate_match_pad_insertion    =>   rate_match_pad_insertion,
        ind_error_reporting    =>   ind_error_reporting,
        phystatus_rst_toggle_g3    =>   phystatus_rst_toggle_g3,
        phystatus_rst_toggle_g12    =>   phystatus_rst_toggle_g12,
        cdr_control    =>   cdr_control,
        cid_enable    =>   cid_enable,
        parity_chk_ts1    =>   parity_chk_ts1,
        rxvalid_mask    =>   rxvalid_mask,
        ph_fifo_reg_mode    =>   ph_fifo_reg_mode,
        test_mode_timers    =>   test_mode_timers,
        inf_ei_enable    =>   inf_ei_enable,
        spd_chnge_g2_sel    =>   spd_chnge_g2_sel,
        cp_up_mstr    =>   cp_up_mstr,
        cp_dwn_mstr    =>   cp_dwn_mstr,
        cp_cons_sel    =>   cp_cons_sel,
        elecidle_delay_g12_data    =>   elecidle_delay_g12_data,
        elecidle_delay_g12    =>   elecidle_delay_g12,
        elecidle_delay_g3_data    =>   elecidle_delay_g3_data,
        elecidle_delay_g3    =>   elecidle_delay_g3,
        phy_status_delay_g12_data    =>   phy_status_delay_g12_data,
        phy_status_delay_g12    =>   phy_status_delay_g12,
        phy_status_delay_g3_data    =>   phy_status_delay_g3_data,
        phy_status_delay_g3    =>   phy_status_delay_g3,
        sigdet_wait_counter_data    =>   sigdet_wait_counter_data,
        sigdet_wait_counter    =>   sigdet_wait_counter,
        data_mask_count_val    =>   data_mask_count_val,
        data_mask_count    =>   data_mask_count,
        pma_done_counter_data    =>   pma_done_counter_data,
        pma_done_counter    =>   pma_done_counter,
        pc_en_counter_data    =>   pc_en_counter_data,
        pc_en_counter    =>   pc_en_counter,
        pc_rst_counter_data    =>   pc_rst_counter_data,
        pc_rst_counter    =>   pc_rst_counter,
        phfifo_flush_wait_data    =>   phfifo_flush_wait_data,
        phfifo_flush_wait    =>   phfifo_flush_wait,
        asn_clk_enable    =>   asn_clk_enable,
        free_run_clk_enable    =>   free_run_clk_enable,
        asn_enable    =>   asn_enable
    )
    port  map  (
        rcvdclk    =>    rcvdclk,
        txpmaclk    =>    txpmaclk,
        pcsdigclk    =>    pcsdigclk,
        pllfixedclk    =>    pllfixedclk,
        rtxgen3capen    =>    rtxgen3capen,
        rrxgen3capen    =>    rrxgen3capen,
        rtxdigclksel    =>    rtxdigclksel,
        rrxdigclksel    =>    rrxdigclksel,
        rxrstn    =>    rxrstn,
        txrstn    =>    txrstn,
        scanmoden    =>    scanmoden,
        pldasyncstatus    =>    pldasyncstatus,
        testout    =>    testout,
        gen3datasel    =>    gen3datasel,
        gen3clksel    =>    gen3clksel,
        pcsrst    =>    pcsrst,
        dispcbyte    =>    dispcbyte,
        resetpcprts    =>    resetpcprts,
        shutdownclk    =>    shutdownclk,
        txdata    =>    txdata,
        txdatak    =>    txdatak,
        txdataskip    =>    txdataskip,
        txsynchdr    =>    txsynchdr,
        txblkstart    =>    txblkstart,
        txelecidle    =>    txelecidle,
        txdetectrxloopback    =>    txdetectrxloopback,
        txcompliance    =>    txcompliance,
        rxpolarity    =>    rxpolarity,
        powerdown    =>    powerdown,
        rate    =>    rate,
        txmargin    =>    txmargin,
        txdeemph    =>    txdeemph,
        txswing    =>    txswing,
        eidleinfersel    =>    eidleinfersel,
        currentcoeff    =>    currentcoeff,
        currentrxpreset    =>    currentrxpreset,
        rxupdatefc    =>    rxupdatefc,
        rxdataskip    =>    rxdataskip,
        rxsynchdr    =>    rxsynchdr,
        rxblkstart    =>    rxblkstart,
        rxvalid    =>    rxvalid,
        phystatus    =>    phystatus,
        rxelecidle    =>    rxelecidle,
        rxstatus    =>    rxstatus,
        rxdataint    =>    rxdataint,
        rxdatakint    =>    rxdatakint,
        rxdataskipint    =>    rxdataskipint,
        rxsynchdrint    =>    rxsynchdrint,
        rxblkstartint    =>    rxblkstartint,
        txdataint    =>    txdataint,
        txdatakint    =>    txdatakint,
        txdataskipint    =>    txdataskipint,
        txsynchdrint    =>    txsynchdrint,
        txblkstartint    =>    txblkstartint,
        testinfei    =>    testinfei,
        eidetint    =>    eidetint,
        eipartialdetint    =>    eipartialdetint,
        idetint    =>    idetint,
        blkalgndint    =>    blkalgndint,
        clkcompinsertint    =>    clkcompinsertint,
        clkcompdeleteint    =>    clkcompdeleteint,
        clkcompoverflint    =>    clkcompoverflint,
        clkcompundflint    =>    clkcompundflint,
        errdecodeint    =>    errdecodeint,
        rcvlfsrchkint    =>    rcvlfsrchkint,
        errencodeint    =>    errencodeint,
        rxpolarityint    =>    rxpolarityint,
        revlpbkint    =>    revlpbkint,
        inferredrxvalidint    =>    inferredrxvalidint,
        rxd8gpcsin    =>    rxd8gpcsin,
        rxelecidle8gpcsin    =>    rxelecidle8gpcsin,
        pldltr    =>    pldltr,
        rxd8gpcsout    =>    rxd8gpcsout,
        revlpbk8gpcsout    =>    revlpbk8gpcsout,
        pmarxdetectvalid    =>    pmarxdetectvalid,
        pmarxfound    =>    pmarxfound,
        pmasignaldet    =>    pmasignaldet,
        pmapcieswdone    =>    pmapcieswdone,
        pmapcieswitch    =>    pmapcieswitch,
        pmatxmargin    =>    pmatxmargin,
        pmatxdeemph    =>    pmatxdeemph,
        pmatxswing    =>    pmatxswing,
        pmacurrentcoeff    =>    pmacurrentcoeff,
        pmacurrentrxpreset    =>    pmacurrentrxpreset,
        pmatxelecidle    =>    pmatxelecidle,
        pmatxdetectrx    =>    pmatxdetectrx,
        ppmeidleexit    =>    ppmeidleexit,
        pmaltr    =>    pmaltr,
        pmaearlyeios    =>    pmaearlyeios,
        pmarxdetpd    =>    pmarxdetpd,
        bundlingindown    =>    bundlingindown,
        bundlingoutdown    =>    bundlingoutdown,
        rxpolarity8gpcsout    =>    rxpolarity8gpcsout,
        speedchangeg2    =>    speedchangeg2,
        bundlingoutup    =>    bundlingoutup,
        bundlinginup    =>    bundlinginup,
        masktxpll    =>    masktxpll
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pma_cdr_refclk_select_mux    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_cdr_refclk_select_mux";
        channel_number    :    integer    :=    0;
        refclk_select    :    string    :=    "ref_iqclk0";

      mux_type : string :=  "cdr_refclk_select_mux"; 
        
        reference_clock_frequency    :    string    :=    "0 ps"
    );
    port    (
        calclk    :    in    std_logic;
        ffplloutbot    :    in    std_logic;
        ffpllouttop    :    in    std_logic;
        pldclk    :    in    std_logic;
        refiqclk0    :    in    std_logic;
        refiqclk1    :    in    std_logic;
        refiqclk10    :    in    std_logic;
        refiqclk2    :    in    std_logic;
        refiqclk3    :    in    std_logic;
        refiqclk4    :    in    std_logic;
        refiqclk5    :    in    std_logic;
        refiqclk6    :    in    std_logic;
        refiqclk7    :    in    std_logic;
        refiqclk8    :    in    std_logic;
        refiqclk9    :    in    std_logic;
        rxiqclk0    :    in    std_logic;
        rxiqclk1    :    in    std_logic;
        rxiqclk10    :    in    std_logic;
        rxiqclk2    :    in    std_logic;
        rxiqclk3    :    in    std_logic;
        rxiqclk4    :    in    std_logic;
        rxiqclk5    :    in    std_logic;
        rxiqclk6    :    in    std_logic;
        rxiqclk7    :    in    std_logic;
        rxiqclk8    :    in    std_logic;
        rxiqclk9    :    in    std_logic;
        clkout    :    out    std_logic
    );
end stratixv_hssi_pma_cdr_refclk_select_mux;

architecture behavior of stratixv_hssi_pma_cdr_refclk_select_mux is

component    stratixv_hssi_pma_cdr_refclk_select_mux_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_cdr_refclk_select_mux";
        channel_number    :    integer    :=    0;
        refclk_select    :    string    :=    "ref_iqclk0";
        reference_clock_frequency    :    string    :=    "0 ps"
    );
    port    (
        calclk    :    in    std_logic;
        ffplloutbot    :    in    std_logic;
        ffpllouttop    :    in    std_logic;
        pldclk    :    in    std_logic;
        refiqclk0    :    in    std_logic;
        refiqclk1    :    in    std_logic;
        refiqclk10    :    in    std_logic;
        refiqclk2    :    in    std_logic;
        refiqclk3    :    in    std_logic;
        refiqclk4    :    in    std_logic;
        refiqclk5    :    in    std_logic;
        refiqclk6    :    in    std_logic;
        refiqclk7    :    in    std_logic;
        refiqclk8    :    in    std_logic;
        refiqclk9    :    in    std_logic;
        rxiqclk0    :    in    std_logic;
        rxiqclk1    :    in    std_logic;
        rxiqclk10    :    in    std_logic;
        rxiqclk2    :    in    std_logic;
        rxiqclk3    :    in    std_logic;
        rxiqclk4    :    in    std_logic;
        rxiqclk5    :    in    std_logic;
        rxiqclk6    :    in    std_logic;
        rxiqclk7    :    in    std_logic;
        rxiqclk8    :    in    std_logic;
        rxiqclk9    :    in    std_logic;
        clkout    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_pma_cdr_refclk_select_mux_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        channel_number    =>   channel_number,
        refclk_select    =>   refclk_select,
        reference_clock_frequency    =>   reference_clock_frequency
    )
    port  map  (
        calclk    =>    calclk,
        ffplloutbot    =>    ffplloutbot,
        ffpllouttop    =>    ffpllouttop,
        pldclk    =>    pldclk,
        refiqclk0    =>    refiqclk0,
        refiqclk1    =>    refiqclk1,
        refiqclk10    =>    refiqclk10,
        refiqclk2    =>    refiqclk2,
        refiqclk3    =>    refiqclk3,
        refiqclk4    =>    refiqclk4,
        refiqclk5    =>    refiqclk5,
        refiqclk6    =>    refiqclk6,
        refiqclk7    =>    refiqclk7,
        refiqclk8    =>    refiqclk8,
        refiqclk9    =>    refiqclk9,
        rxiqclk0    =>    rxiqclk0,
        rxiqclk1    =>    rxiqclk1,
        rxiqclk10    =>    rxiqclk10,
        rxiqclk2    =>    rxiqclk2,
        rxiqclk3    =>    rxiqclk3,
        rxiqclk4    =>    rxiqclk4,
        rxiqclk5    =>    rxiqclk5,
        rxiqclk6    =>    rxiqclk6,
        rxiqclk7    =>    rxiqclk7,
        rxiqclk8    =>    rxiqclk8,
        rxiqclk9    =>    rxiqclk9,
        clkout    =>    clkout
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pma_rx_buf    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_rx_buf";
        adce_pd    :    string    :=    "false";
        bypass_eqz_stages_123    :    string    :=    "all_stages_enabled";
        eq_bw_sel    :    string    :=    "bw_full_12p5";
        input_vcm_sel    :    string    :=    "high_vcm";
        pdb_dfe    :    string    :=    "false";
        pdb_sd    :    string    :=    "false";
        qpi_enable    :    string    :=    "false";
        rx_dc_gain    :    string    :=    "dc_gain_0db";
        rx_sel_bias_source    :    string    :=    "bias_vcmdrv";
        sd_off    :    string    :=    "clk_divrx_2";
        sd_on    :    string    :=    "data_pulse_6";
        sd_threshold    :    string    :=    "sdlv_30mv";
        serial_loopback    :    string    :=    "lpbkp_dis";
        term_sel    :    string    :=    "r_100ohm";
        vccela_supply_voltage    :    string    :=    "vccela_1p0v";
        vcm_sel    :    string    :=    "vtt_0p7v";
        channel_number    :    integer    :=    0
    );
    port    (
        adaptcapture   : in std_logic;
        adaptdone      : out std_logic;
        adcestandby     : in std_logic;
        hardoccaldone      : out std_logic;
        hardoccalen        : in std_logic;
        eyemonitor     : in std_logic_vector(4 downto 0);
        ck0sigdet    :    in    std_logic;
        datain    :    in    std_logic;
        fined2aout    :    in    std_logic;
        lpbkp    :    in    std_logic;
        refclklpbk    :    in    std_logic;
        rstn    :    in    std_logic;
        rxqpipulldn    :    in    std_logic;
        slpbk    :    in    std_logic;
        dataout    :    out    std_logic;
        nonuserfrompmaux    :    out    std_logic;
        rdlpbkp    :    out    std_logic;
        rxpadce    :    out    std_logic;
        sd    :    out    std_logic
    );
end stratixv_hssi_pma_rx_buf;

architecture behavior of stratixv_hssi_pma_rx_buf is

component    stratixv_hssi_pma_rx_buf_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_rx_buf";
        adce_pd    :    string    :=    "false";
        bypass_eqz_stages_123    :    string    :=    "all_stages_enabled";
        eq_bw_sel    :    string    :=    "bw_full_12p5";
        input_vcm_sel    :    string    :=    "high_vcm";
        pdb_dfe    :    string    :=    "false";
        pdb_sd    :    string    :=    "false";
        qpi_enable    :    string    :=    "false";
        rx_dc_gain    :    string    :=    "dc_gain_0db";
        rx_sel_bias_source    :    string    :=    "bias_vcmdrv";
        sd_off    :    string    :=    "clk_divrx_2";
        sd_on    :    string    :=    "data_pulse_6";
        sd_threshold    :    string    :=    "sdlv_30mv";
        serial_loopback    :    string    :=    "lpbkp_dis";
        term_sel    :    string    :=    "r_100ohm";
        vccela_supply_voltage    :    string    :=    "vccela_1p0v";
        vcm_sel    :    string    :=    "vtt_0p7v";
        channel_number    :    integer    :=    0
    );
    port    (
        ck0sigdet    :    in    std_logic;
        datain    :    in    std_logic;
        fined2aout    :    in    std_logic;
        lpbkp    :    in    std_logic;
        adaptcapture   : in std_logic;
        adaptdone      : out std_logic;
        adcestandby     : in std_logic;
        hardoccaldone      : out std_logic;
        hardoccalen        : in std_logic;
                eyemonitor     : in std_logic_vector(4 downto 0);
        refclklpbk    :    in    std_logic;
        rstn    :    in    std_logic;
        rxqpipulldn    :    in    std_logic;
        slpbk    :    in    std_logic;
        dataout    :    out    std_logic;
        nonuserfrompmaux    :    out    std_logic;
        rdlpbkp    :    out    std_logic;
        rxpadce    :    out    std_logic;
        sd    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_pma_rx_buf_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        adce_pd    =>   adce_pd,
        bypass_eqz_stages_123    =>   bypass_eqz_stages_123,
        eq_bw_sel    =>   eq_bw_sel,
        input_vcm_sel    =>   input_vcm_sel,
        pdb_dfe    =>   pdb_dfe,
        pdb_sd    =>   pdb_sd,
        qpi_enable    =>   qpi_enable,
        rx_dc_gain    =>   rx_dc_gain,
        rx_sel_bias_source    =>   rx_sel_bias_source,
        sd_off    =>   sd_off,
        sd_on    =>   sd_on,
        sd_threshold    =>   sd_threshold,
        serial_loopback    =>   serial_loopback,
        term_sel    =>   term_sel,
        vccela_supply_voltage    =>   vccela_supply_voltage,
        vcm_sel    =>   vcm_sel,
        channel_number    =>   channel_number
    )
    port  map  (
        ck0sigdet    =>    ck0sigdet,
        datain    =>    datain,
        fined2aout    =>    fined2aout,
        lpbkp    =>    lpbkp,
        hardoccalen    =>    hardoccalen,
        refclklpbk    =>    refclklpbk,
        rstn    =>    rstn,
        rxqpipulldn    =>    rxqpipulldn,
        slpbk    =>    slpbk,
        dataout    =>    dataout,
        nonuserfrompmaux    =>    nonuserfrompmaux,
        rdlpbkp    =>    rdlpbkp,
        rxpadce    =>    rxpadce,
        sd    =>    sd,

        adaptcapture  => adaptcapture,
        adaptdone     => adaptdone,
        adcestandby   => adcestandby,
        hardoccaldone  => hardoccaldone,
        eyemonitor     => eyemonitor
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pma_rx_deser    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_rx_deser";
        auto_negotiation    :    string    :=    "false";
        bit_slip_bypass    :    string    :=    "false";
        mode    :    integer    :=    8;
        sdclk_enable    :    string    :=    "false";
        vco_bypass    :    string    :=    "vco_bypass_normal";
        channel_number    :    integer    :=    0;
        clk_forward_only_mode    :    string    :=    "false"
    );
    port    (
        bslip    :    in    std_logic;
        clk90b    :    in    std_logic;
        clk270b    :    in    std_logic;
        deven    :    in    std_logic;
        dodd    :    in    std_logic;
        pciesw    :    in    std_logic_vector(1 downto 0);
        pfdmodelock    :    in    std_logic;
        rstn    :    in    std_logic;
        clk33pcs    :    out    std_logic;
        clkdivrx    :    out    std_logic;
        clkdivrxrx    :    out    std_logic;
        dout    :    out    std_logic_vector(39 downto 0);
        pciel    :    out    std_logic;
        pciem    :    out    std_logic
    );
end stratixv_hssi_pma_rx_deser;

architecture behavior of stratixv_hssi_pma_rx_deser is

component    stratixv_hssi_pma_rx_deser_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_rx_deser";
        auto_negotiation    :    string    :=    "false";
        bit_slip_bypass    :    string    :=    "false";
        mode    :    integer    :=    8;
        sdclk_enable    :    string    :=    "false";
        vco_bypass    :    string    :=    "vco_bypass_normal";
        channel_number    :    integer    :=    0;
        clk_forward_only_mode    :    string    :=    "false"
    );
    port    (
        bslip    :    in    std_logic;
        clk90b    :    in    std_logic;
        clk270b    :    in    std_logic;
        deven    :    in    std_logic;
        dodd    :    in    std_logic;
        pciesw    :    in    std_logic_vector(1 downto 0);
        pfdmodelock    :    in    std_logic;
        rstn    :    in    std_logic;
        clk33pcs    :    out    std_logic;
        clkdivrx    :    out    std_logic;
        clkdivrxrx    :    out    std_logic;
        dout    :    out    std_logic_vector(39 downto 0);
        pciel    :    out    std_logic;
        pciem    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_pma_rx_deser_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        auto_negotiation    =>   auto_negotiation,
        bit_slip_bypass    =>   bit_slip_bypass,
        mode    =>   mode,
        sdclk_enable    =>   sdclk_enable,
        vco_bypass    =>   vco_bypass,
        channel_number    =>   channel_number,
        clk_forward_only_mode    =>   clk_forward_only_mode
    )
    port  map  (
        bslip    =>    bslip,
        clk90b    =>    clk90b,
        clk270b    =>    clk270b,
        deven    =>    deven,
        dodd    =>    dodd,
        pciesw    =>    pciesw,
        pfdmodelock    =>    pfdmodelock,
        rstn    =>    rstn,
        clk33pcs    =>    clk33pcs,
        clkdivrx    =>    clkdivrx,
        clkdivrxrx    =>    clkdivrxrx,
        dout    =>    dout,
        pciel    =>    pciel,
        pciem    =>    pciem
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pma_tx_buf    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_tx_buf";
        elec_idl_gate_ctrl    :    string    :=    "true";
        pre_emp_switching_ctrl_1st_post_tap    :    string    :=    "fir_1pt_disabled";
        pre_emp_switching_ctrl_2nd_post_tap    :    string    :=    "fir_2pt_disabled";
        pre_emp_switching_ctrl_pre_tap    :    string    :=    "fir_pre_disabled";
        qpi_en    :    string    :=    "false";
        rx_det    :    string    :=    "mode_0";
        rx_det_output_sel    :    string    :=    "rx_det_pcie_out";
        rx_det_pdb    :    string    :=    "true";
        sig_inv_2nd_tap    :    string    :=    "false";
        sig_inv_pre_tap    :    string    :=    "false";
        slew_rate_ctrl    :    string    :=    "slew_30ps";
        term_sel    :    string    :=    "r_100ohm";
        vod_switching_ctrl_main_tap    :    string    :=    "fir_main_2p0ma";
        channel_number    :    integer    :=    0
    );
    port    (
        datain    :    in    std_logic;
        rxdetclk    :    in    std_logic;
        txdetrx    :    in    std_logic;
        txelecidl    :    in    std_logic;
        txqpipulldn    :    in    std_logic;
        txqpipullup    :    in    std_logic;
        compass    :    out    std_logic;
        dataout    :    out    std_logic;
        detecton    :    out    std_logic_vector(1 downto 0);
        fixedclkout    :    out    std_logic;
        nonuserfrompmaux    :    out    std_logic;
        probepass    :    out    std_logic;
        rxdetectvalid    :    out    std_logic;
        rxfound    :    out    std_logic
    );
end stratixv_hssi_pma_tx_buf;

architecture behavior of stratixv_hssi_pma_tx_buf is

component    stratixv_hssi_pma_tx_buf_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_tx_buf";
        elec_idl_gate_ctrl    :    string    :=    "true";
        pre_emp_switching_ctrl_1st_post_tap    :    string    :=    "fir_1pt_disabled";
        pre_emp_switching_ctrl_2nd_post_tap    :    string    :=    "fir_2pt_disabled";
        pre_emp_switching_ctrl_pre_tap    :    string    :=    "fir_pre_disabled";
        qpi_en    :    string    :=    "false";
        rx_det    :    string    :=    "mode_0";
        rx_det_output_sel    :    string    :=    "rx_det_pcie_out";
        rx_det_pdb    :    string    :=    "true";
        sig_inv_2nd_tap    :    string    :=    "false";
        sig_inv_pre_tap    :    string    :=    "false";
        slew_rate_ctrl    :    string    :=    "slew_30ps";
        term_sel    :    string    :=    "r_100ohm";
        vod_switching_ctrl_main_tap    :    string    :=    "fir_main_2p0ma";
        channel_number    :    integer    :=    0
    );
    port    (
        datain    :    in    std_logic;
        rxdetclk    :    in    std_logic;
        txdetrx    :    in    std_logic;
        txelecidl    :    in    std_logic;
        txqpipulldn    :    in    std_logic;
        txqpipullup    :    in    std_logic;
        compass    :    out    std_logic;
        dataout    :    out    std_logic;
        detecton    :    out    std_logic_vector(1 downto 0);
        fixedclkout    :    out    std_logic;
        nonuserfrompmaux    :    out    std_logic;
        probepass    :    out    std_logic;
        rxdetectvalid    :    out    std_logic;
        rxfound    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_pma_tx_buf_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        elec_idl_gate_ctrl    =>   elec_idl_gate_ctrl,
        pre_emp_switching_ctrl_1st_post_tap    =>   pre_emp_switching_ctrl_1st_post_tap,
        pre_emp_switching_ctrl_2nd_post_tap    =>   pre_emp_switching_ctrl_2nd_post_tap,
        pre_emp_switching_ctrl_pre_tap    =>   pre_emp_switching_ctrl_pre_tap,
        qpi_en    =>   qpi_en,
        rx_det    =>   rx_det,
        rx_det_output_sel    =>   rx_det_output_sel,
        rx_det_pdb    =>   rx_det_pdb,
        sig_inv_2nd_tap    =>   sig_inv_2nd_tap,
        sig_inv_pre_tap    =>   sig_inv_pre_tap,
        slew_rate_ctrl    =>   slew_rate_ctrl,
        term_sel    =>   term_sel,
        vod_switching_ctrl_main_tap    =>   vod_switching_ctrl_main_tap,
        channel_number    =>   channel_number
    )
    port  map  (
        datain    =>    datain,
        rxdetclk    =>    rxdetclk,
        txdetrx    =>    txdetrx,
        txelecidl    =>    txelecidl,
        txqpipulldn    =>    txqpipulldn,
        txqpipullup    =>    txqpipullup,
        compass    =>    compass,
        dataout    =>    dataout,
        detecton    =>    detecton,
        fixedclkout    =>    fixedclkout,
        nonuserfrompmaux    =>    nonuserfrompmaux,
        probepass    =>    probepass,
        rxdetectvalid    =>    rxdetectvalid,
        rxfound    =>    rxfound
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pma_tx_cgb    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_tx_cgb";
        auto_negotiation    :    string    :=    "false";
        x1_div_m_sel    :    integer    :=    1;
        channel_number    :    integer    :=    0;
        data_rate    :    string    :=    "";
        mode    :    integer    :=    8;
        rx_iqclk_sel    :    string    :=    "cgb_x1_n_div";
        tx_mux_power_down    :    string    :=    "normal";
        x1_clock_source_sel    :    string    :=    "x1_clk_unused";
        xn_clock_source_sel    :    string    :=    "cgb_xn_unused";
        xn_network_driver    :    string    :=    "enable_clock_entwork_driver";
        cgb_iqclk_sel    :    string    :=    "cgb_x1_n_div";
        ht_delay_enable    :    string    :=    "false"
    );
    port    (
        clkbcdr1adj    :    in    std_logic;
        clkbcdr1loc    :    in    std_logic;
        clkbcdrloc    :    in    std_logic;
        clkbdnseg    :    in    std_logic;
        clkbffpll    :    in    std_logic;
        clkblcb    :    in    std_logic;
        clkblct    :    in    std_logic;
        clkbupseg    :    in    std_logic;
        clkcdr1adj    :    in    std_logic;
        clkcdr1loc    :    in    std_logic;
        clkcdrloc    :    in    std_logic;
        clkdnseg    :    in    std_logic;
        clkffpll    :    in    std_logic;
        clklcb    :    in    std_logic;
        clklct    :    in    std_logic;
        clkupseg    :    in    std_logic;
        cpulsex6adj    :    in    std_logic;
        cpulsex6loc    :    in    std_logic;
        cpulsexndn    :    in    std_logic;
        cpulsexnup    :    in    std_logic;
        hfclknx6adj    :    in    std_logic;
        hfclknx6loc    :    in    std_logic;
        hfclknxndn    :    in    std_logic;
        hfclknxnup    :    in    std_logic;
        hfclkpx6adj    :    in    std_logic;
        hfclkpx6loc    :    in    std_logic;
        hfclkpxndn    :    in    std_logic;
        hfclkpxnup    :    in    std_logic;
        lfclknx6adj    :    in    std_logic;
        lfclknx6loc    :    in    std_logic;
        lfclknxndn    :    in    std_logic;
        lfclknxnup    :    in    std_logic;
        lfclkpx6adj    :    in    std_logic;
        lfclkpx6loc    :    in    std_logic;
        lfclkpxndn    :    in    std_logic;
        lfclkpxnup    :    in    std_logic;
        pciesw    :    in    std_logic_vector(1 downto 0);
        pclk0x6adj    :    in    std_logic;
        pclk0x6loc    :    in    std_logic;
        pclk0xndn    :    in    std_logic;
        pclk0xnup    :    in    std_logic;
        pclk1x6adj    :    in    std_logic;
        pclk1x6loc    :    in    std_logic;
        pclk1xndn    :    in    std_logic;
        pclk1xnup    :    in    std_logic;
        pclkx6adj    :    in    std_logic_vector(2 downto 0);
        pclkx6loc    :    in    std_logic_vector(2 downto 0);
        pclkxndn    :    in    std_logic_vector(2 downto 0);
        pclkxnup    :    in    std_logic_vector(2 downto 0);
        rxclk    :    in    std_logic;
        txpmarstb    :    in    std_logic;
        txpmasyncp    :    in    std_logic;
        xnresetin    :    in    std_logic;
        cpulse    :    out    std_logic;
        cpulseout    :    out    std_logic;
        hfclkn    :    out    std_logic;
        hfclknout    :    out    std_logic;
        hfclkp    :    out    std_logic;
        hfclkpout    :    out    std_logic;
        lfclkn    :    out    std_logic;
        lfclknout    :    out    std_logic;
        lfclkp    :    out    std_logic;
        lfclkpout    :    out    std_logic;
        pcieswdone    :    out    std_logic_vector(1 downto 0);
        pclk0    :    out    std_logic;
        pclk0out    :    out    std_logic;
        pclk1    :    out    std_logic;
        pclk1out    :    out    std_logic;
        pclk    :    out    std_logic_vector(2 downto 0);
        pclkout    :    out    std_logic_vector(2 downto 0);
        rxiqclk    :    out    std_logic;
        xnresetout    :    out    std_logic
    );
end stratixv_hssi_pma_tx_cgb;

architecture behavior of stratixv_hssi_pma_tx_cgb is

component    stratixv_hssi_pma_tx_cgb_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_tx_cgb";
        auto_negotiation    :    string    :=    "false";
        x1_div_m_sel    :    integer    :=    1;
        channel_number    :    integer    :=    0;
        data_rate    :    string    :=    "";
        mode    :    integer    :=    8;
        rx_iqclk_sel    :    string    :=    "cgb_x1_n_div";
        tx_mux_power_down    :    string    :=    "normal";
        x1_clock_source_sel    :    string    :=    "x1_clk_unused";
        xn_clock_source_sel    :    string    :=    "cgb_xn_unused";
        xn_network_driver    :    string    :=    "enable_clock_entwork_driver";
        cgb_iqclk_sel    :    string    :=    "cgb_x1_n_div";
        ht_delay_enable    :    string    :=    "false"
    );
    port    (
        clkbcdr1adj    :    in    std_logic;
        clkbcdr1loc    :    in    std_logic;
        clkbcdrloc    :    in    std_logic;
        clkbdnseg    :    in    std_logic;
        clkbffpll    :    in    std_logic;
        clkblcb    :    in    std_logic;
        clkblct    :    in    std_logic;
        clkbupseg    :    in    std_logic;
        clkcdr1adj    :    in    std_logic;
        clkcdr1loc    :    in    std_logic;
        clkcdrloc    :    in    std_logic;
        clkdnseg    :    in    std_logic;
        clkffpll    :    in    std_logic;
        clklcb    :    in    std_logic;
        clklct    :    in    std_logic;
        clkupseg    :    in    std_logic;
        cpulsex6adj    :    in    std_logic;
        cpulsex6loc    :    in    std_logic;
        cpulsexndn    :    in    std_logic;
        cpulsexnup    :    in    std_logic;
        hfclknx6adj    :    in    std_logic;
        hfclknx6loc    :    in    std_logic;
        hfclknxndn    :    in    std_logic;
        hfclknxnup    :    in    std_logic;
        hfclkpx6adj    :    in    std_logic;
        hfclkpx6loc    :    in    std_logic;
        hfclkpxndn    :    in    std_logic;
        hfclkpxnup    :    in    std_logic;
        lfclknx6adj    :    in    std_logic;
        lfclknx6loc    :    in    std_logic;
        lfclknxndn    :    in    std_logic;
        lfclknxnup    :    in    std_logic;
        lfclkpx6adj    :    in    std_logic;
        lfclkpx6loc    :    in    std_logic;
        lfclkpxndn    :    in    std_logic;
        lfclkpxnup    :    in    std_logic;
        pciesw    :    in    std_logic_vector(1 downto 0);
        pclk0x6adj    :    in    std_logic;
        pclk0x6loc    :    in    std_logic;
        pclk0xndn    :    in    std_logic;
        pclk0xnup    :    in    std_logic;
        pclk1x6adj    :    in    std_logic;
        pclk1x6loc    :    in    std_logic;
        pclk1xndn    :    in    std_logic;
        pclk1xnup    :    in    std_logic;
        pclkx6adj    :    in    std_logic_vector(2 downto 0);
        pclkx6loc    :    in    std_logic_vector(2 downto 0);
        pclkxndn    :    in    std_logic_vector(2 downto 0);
        pclkxnup    :    in    std_logic_vector(2 downto 0);
        rxclk    :    in    std_logic;
        txpmarstb    :    in    std_logic;
        txpmasyncp    :    in    std_logic;
        xnresetin    :    in    std_logic;
        cpulse    :    out    std_logic;
        cpulseout    :    out    std_logic;
        hfclkn    :    out    std_logic;
        hfclknout    :    out    std_logic;
        hfclkp    :    out    std_logic;
        hfclkpout    :    out    std_logic;
        lfclkn    :    out    std_logic;
        lfclknout    :    out    std_logic;
        lfclkp    :    out    std_logic;
        lfclkpout    :    out    std_logic;
        pcieswdone    :    out    std_logic_vector(1 downto 0);
        pclk0    :    out    std_logic;
        pclk0out    :    out    std_logic;
        pclk1    :    out    std_logic;
        pclk1out    :    out    std_logic;
        pclk    :    out    std_logic_vector(2 downto 0);
        pclkout    :    out    std_logic_vector(2 downto 0);
        rxiqclk    :    out    std_logic;
        xnresetout    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_pma_tx_cgb_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        auto_negotiation    =>   auto_negotiation,
        x1_div_m_sel    =>   x1_div_m_sel,
        channel_number    =>   channel_number,
        data_rate    =>   data_rate,
        mode    =>   mode,
        rx_iqclk_sel    =>   rx_iqclk_sel,
        tx_mux_power_down    =>   tx_mux_power_down,
        x1_clock_source_sel    =>   x1_clock_source_sel,
        xn_clock_source_sel    =>   xn_clock_source_sel,
        xn_network_driver    =>   xn_network_driver,
        cgb_iqclk_sel    =>   cgb_iqclk_sel,
        ht_delay_enable    =>   ht_delay_enable
    )
    port  map  (
        clkbcdr1adj    =>    clkbcdr1adj,
        clkbcdr1loc    =>    clkbcdr1loc,
        clkbcdrloc    =>    clkbcdrloc,
        clkbdnseg    =>    clkbdnseg,
        clkbffpll    =>    clkbffpll,
        clkblcb    =>    clkblcb,
        clkblct    =>    clkblct,
        clkbupseg    =>    clkbupseg,
        clkcdr1adj    =>    clkcdr1adj,
        clkcdr1loc    =>    clkcdr1loc,
        clkcdrloc    =>    clkcdrloc,
        clkdnseg    =>    clkdnseg,
        clkffpll    =>    clkffpll,
        clklcb    =>    clklcb,
        clklct    =>    clklct,
        clkupseg    =>    clkupseg,
        cpulsex6adj    =>    cpulsex6adj,
        cpulsex6loc    =>    cpulsex6loc,
        cpulsexndn    =>    cpulsexndn,
        cpulsexnup    =>    cpulsexnup,
        hfclknx6adj    =>    hfclknx6adj,
        hfclknx6loc    =>    hfclknx6loc,
        hfclknxndn    =>    hfclknxndn,
        hfclknxnup    =>    hfclknxnup,
        hfclkpx6adj    =>    hfclkpx6adj,
        hfclkpx6loc    =>    hfclkpx6loc,
        hfclkpxndn    =>    hfclkpxndn,
        hfclkpxnup    =>    hfclkpxnup,
        lfclknx6adj    =>    lfclknx6adj,
        lfclknx6loc    =>    lfclknx6loc,
        lfclknxndn    =>    lfclknxndn,
        lfclknxnup    =>    lfclknxnup,
        lfclkpx6adj    =>    lfclkpx6adj,
        lfclkpx6loc    =>    lfclkpx6loc,
        lfclkpxndn    =>    lfclkpxndn,
        lfclkpxnup    =>    lfclkpxnup,
        pciesw    =>    pciesw,
        pclk0x6adj    =>    pclk0x6adj,
        pclk0x6loc    =>    pclk0x6loc,
        pclk0xndn    =>    pclk0xndn,
        pclk0xnup    =>    pclk0xnup,
        pclk1x6adj    =>    pclk1x6adj,
        pclk1x6loc    =>    pclk1x6loc,
        pclk1xndn    =>    pclk1xndn,
        pclk1xnup    =>    pclk1xnup,
        pclkx6adj    =>    pclkx6adj,
        pclkx6loc    =>    pclkx6loc,
        pclkxndn    =>    pclkxndn,
        pclkxnup    =>    pclkxnup,
        rxclk    =>    rxclk,
        txpmarstb    =>    txpmarstb,
        txpmasyncp    =>    txpmasyncp,
        xnresetin    =>    xnresetin,
        cpulse    =>    cpulse,
        cpulseout    =>    cpulseout,
        hfclkn    =>    hfclkn,
        hfclknout    =>    hfclknout,
        hfclkp    =>    hfclkp,
        hfclkpout    =>    hfclkpout,
        lfclkn    =>    lfclkn,
        lfclknout    =>    lfclknout,
        lfclkp    =>    lfclkp,
        lfclkpout    =>    lfclkpout,
        pcieswdone    =>    pcieswdone,
        pclk0    =>    pclk0,
        pclk0out    =>    pclk0out,
        pclk1    =>    pclk1,
        pclk1out    =>    pclk1out,
        pclk    =>    pclk,
        pclkout    =>    pclkout,
        rxiqclk    =>    rxiqclk,
        xnresetout    =>    xnresetout
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_pma_tx_ser    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_tx_ser";
        auto_negotiation    :    string    :=    "false";
        clk_divtx_deskew    :    string    :=    "deskew_delay1";
        mode    :    integer    :=    8;
        post_tap_1_en    :    string    :=    "false";
        post_tap_2_en    :    string    :=    "false";
        pre_tap_en    :    string    :=    "false";
        ser_loopback    :    string    :=    "false";
        pclksel    :    string    :=    "local_pclk";
        channel_number    :    integer    :=    0;
        clk_forward_only_mode    :    string    :=    "false"
    );
    port    (
        cpulse    :    in    std_logic;
        datain    :    in    std_logic_vector(39 downto 0);
        hfclk    :    in    std_logic;
        hfclkn    :    in    std_logic;
        lfclk    :    in    std_logic;
        lfclkn    :    in    std_logic;
        pciesw    :    in    std_logic_vector(1 downto 0);
        pclk0    :    in    std_logic;
        pclk1    :    in    std_logic;
        pclk2    :    in    std_logic;
        pclk    :    in    std_logic_vector(2 downto 0);
        rstn    :    in    std_logic;
        clkdivtx    :    out    std_logic;
        dataout    :    out    std_logic;
        div5    :    out    std_logic;
        lbvop    :    out    std_logic
    );
end stratixv_hssi_pma_tx_ser;

architecture behavior of stratixv_hssi_pma_tx_ser is

component    stratixv_hssi_pma_tx_ser_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_pma_tx_ser";
        auto_negotiation    :    string    :=    "false";
        clk_divtx_deskew    :    string    :=    "deskew_delay1";
        mode    :    integer    :=    8;
        post_tap_1_en    :    string    :=    "false";
        post_tap_2_en    :    string    :=    "false";
        pre_tap_en    :    string    :=    "false";
        ser_loopback    :    string    :=    "false";
        pclksel    :    string    :=    "local_pclk";
        channel_number    :    integer    :=    0;
        clk_forward_only_mode    :    string    :=    "false"
    );
    port    (
        cpulse    :    in    std_logic;
        datain    :    in    std_logic_vector(39 downto 0);
        hfclk    :    in    std_logic;
        hfclkn    :    in    std_logic;
        lfclk    :    in    std_logic;
        lfclkn    :    in    std_logic;
        pciesw    :    in    std_logic_vector(1 downto 0);
        pclk0    :    in    std_logic;
        pclk1    :    in    std_logic;
        pclk2    :    in    std_logic;
        pclk    :    in    std_logic_vector(2 downto 0);
        rstn    :    in    std_logic;
        clkdivtx    :    out    std_logic;
        dataout    :    out    std_logic;
        div5    :    out    std_logic;
        lbvop    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_pma_tx_ser_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        auto_negotiation    =>   auto_negotiation,
        clk_divtx_deskew    =>   clk_divtx_deskew,
        mode    =>   mode,
        post_tap_1_en    =>   post_tap_1_en,
        post_tap_2_en    =>   post_tap_2_en,
        pre_tap_en    =>   pre_tap_en,
        ser_loopback    =>   ser_loopback,
        pclksel    =>   pclksel,
        channel_number    =>   channel_number,
        clk_forward_only_mode    =>   clk_forward_only_mode
    )
    port  map  (
        cpulse    =>    cpulse,
        datain    =>    datain,
        hfclk    =>    hfclk,
        hfclkn    =>    hfclkn,
        lfclk    =>    lfclk,
        lfclkn    =>    lfclkn,
        pciesw    =>    pciesw,
        pclk0    =>    pclk0,
        pclk1    =>    pclk1,
        pclk2    =>    pclk2,
        pclk    =>    pclk,
        rstn    =>    rstn,
        clkdivtx    =>    clkdivtx,
        dataout    =>    dataout,
        div5    =>    div5,
        lbvop    =>    lbvop
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_common_pcs_pma_interface    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_common_pcs_pma_interface";
        auto_speed_ena    :    string    :=    "dis_auto_speed_ena";
        force_freqdet    :    string    :=    "force_freqdet_dis";
        func_mode    :    string    :=    "disable";
        pcie_gen3_cap    :    string    :=    "non_pcie_gen3_cap";
        pipe_if_g3pcs    :    string    :=    "pipe_if_8gpcs";
        pma_if_dft_en    :    string    :=    "dft_dis";
        pma_if_dft_val    :    string    :=    "dft_0";
        ppm_cnt_rst    :    string    :=    "ppm_cnt_rst_dis";
        ppm_deassert_early    :    string    :=    "deassert_early_dis";
        ppm_gen1_2_cnt    :    string    :=    "cnt_32k";
        ppm_post_eidle_delay    :    string    :=    "cnt_200_cycles";
        ppmsel    :    string    :=    "ppmsel_default";
        prot_mode    :    string    :=    "disabled_prot_mode";
        refclk_dig_sel    :    string    :=    "refclk_dig_dis";
        selectpcs    :    string    :=    "eight_g_pcs";
        sup_mode    :    string    :=    "full_mode"
    );
    port    (
        fref    :    in    std_logic;
        clklow    :    in    std_logic;
        pmapcieswdone    :    in    std_logic_vector(1 downto 0);
        pmarxfound    :    in    std_logic;
        pmarxdetectvalid    :    in    std_logic;
        pmahclk    :    in    std_logic;
        pldoffcalen    :    in    std_logic;
        aggrcvdclkagg    :    in    std_logic;
        aggtxdatats    :    in    std_logic_vector(7 downto 0);
        aggtxctlts    :    in    std_logic;
        aggfiforstrdqd    :    in    std_logic;
        aggendskwqd    :    in    std_logic;
        aggendskwrdptrs    :    in    std_logic;
        aggalignstatus    :    in    std_logic;
        aggalignstatussync0    :    in    std_logic;
        aggcgcomprddall    :    in    std_logic;
        aggcgcompwrall    :    in    std_logic;
        aggfifordincomp0    :    in    std_logic;
        aggdelcondmet0    :    in    std_logic;
        agginsertincomplete0    :    in    std_logic;
        aggfifoovr0    :    in    std_logic;
        agglatencycomp0    :    in    std_logic;
        aggrxdatars    :    in    std_logic_vector(7 downto 0);
        aggrxcontrolrs    :    in    std_logic;
        aggrcvdclkaggtoporbot    :    in    std_logic;
        aggtxdatatstoporbot    :    in    std_logic_vector(7 downto 0);
        aggtxctltstoporbot    :    in    std_logic;
        aggfiforstrdqdtoporbot    :    in    std_logic;
        aggendskwqdtoporbot    :    in    std_logic;
        aggendskwrdptrstoporbot    :    in    std_logic;
        aggalignstatustoporbot    :    in    std_logic;
        aggalignstatussync0toporbot    :    in    std_logic;
        aggcgcomprddalltoporbot    :    in    std_logic;
        aggcgcompwralltoporbot    :    in    std_logic;
        aggfifordincomp0toporbot    :    in    std_logic;
        aggdelcondmet0toporbot    :    in    std_logic;
        agginsertincomplete0toporbot    :    in    std_logic;
        aggfifoovr0toporbot    :    in    std_logic;
        agglatencycomp0toporbot    :    in    std_logic;
        aggrxdatarstoporbot    :    in    std_logic_vector(7 downto 0);
        aggrxcontrolrstoporbot    :    in    std_logic;
        pcsgen3pmapcieswitch    :    in    std_logic_vector(1 downto 0);
        pcsgen3pmatxmargin    :    in    std_logic_vector(2 downto 0);
        pcsgen3pmatxdeemph    :    in    std_logic;
        pcsgen3pmatxswing    :    in    std_logic;
        pcsgen3pmacurrentcoeff    :    in    std_logic_vector(17 downto 0);
        pcsgen3pmacurrentrxpreset    :    in    std_logic_vector(2 downto 0);
        pcsgen3pmatxelecidle    :    in    std_logic;
        pcsgen3pmatxdetectrx    :    in    std_logic;
        pcsgen3ppmeidleexit    :    in    std_logic;
        pcsgen3pmaltr    :    in    std_logic;
        pcsgen3pmaearlyeios    :    in    std_logic;
        pcs8gpcieswitch    :    in    std_logic;
        pcs8gtxelecidle    :    in    std_logic;
        pcs8gtxdetectrx    :    in    std_logic;
        pcs8gearlyeios    :    in    std_logic;
        pcs8gtxdeemphpma    :    in    std_logic;
        pcs8gtxmarginpma    :    in    std_logic_vector(2 downto 0);
        pcs8gtxswingpma    :    in    std_logic;
        pcs8gltrpma    :    in    std_logic;
        pcs8geidleexit    :    in    std_logic;
        pcsaggtxpcsrst    :    in    std_logic;
        pcsaggrxpcsrst    :    in    std_logic;
        pcsaggtxdatatc    :    in    std_logic_vector(7 downto 0);
        pcsaggtxctltc    :    in    std_logic;
        pcsaggrdenablesync    :    in    std_logic;
        pcsaggsyncstatus    :    in    std_logic;
        pcsaggaligndetsync    :    in    std_logic_vector(1 downto 0);
        pcsaggrdalign    :    in    std_logic_vector(1 downto 0);
        pcsaggalignstatussync    :    in    std_logic;
        pcsaggfifordoutcomp    :    in    std_logic;
        pcsaggcgcomprddout    :    in    std_logic_vector(1 downto 0);
        pcsaggcgcompwrout    :    in    std_logic_vector(1 downto 0);
        pcsaggdelcondmetout    :    in    std_logic;
        pcsaggfifoovrout    :    in    std_logic;
        pcsagglatencycompout    :    in    std_logic;
        pcsagginsertincompleteout    :    in    std_logic;
        pcsaggdecdatavalid    :    in    std_logic;
        pcsaggdecdata    :    in    std_logic_vector(7 downto 0);
        pcsaggdecctl    :    in    std_logic;
        pcsaggrunningdisp    :    in    std_logic_vector(1 downto 0);
        pldrxclkslip    :    in    std_logic;
        pldhardreset    :    in    std_logic;
        pcsscanmoden    :    in    std_logic;
        pcsscanshiftn    :    in    std_logic;
        pcsrefclkdig    :    in    std_logic;
        pcsaggscanmoden    :    in    std_logic;
        pcsaggscanshiftn    :    in    std_logic;
        pcsaggrefclkdig    :    in    std_logic;
        pcsgen3gen3datasel    :    in    std_logic;
        pldlccmurstb    :    in    std_logic;
        pmaoffcaldonein    :    in    std_logic;
        pmarxpmarstb    :    in    std_logic;
        pmahardreset    :    out    std_logic;
        freqlock    :    out    std_logic;
        pmapcieswitch    :    out    std_logic_vector(1 downto 0);
        pmaearlyeios    :    out    std_logic;
        pmatxdetectrx    :    out    std_logic;
        pmatxelecidle    :    out    std_logic;
        pmatxdeemph    :    out    std_logic;
        pmatxswing    :    out    std_logic;
        pmatxmargin    :    out    std_logic_vector(2 downto 0);
        pmacurrentcoeff    :    out    std_logic_vector(17 downto 0);
        pmacurrentrxpreset    :    out    std_logic_vector(2 downto 0);
        pmaoffcaldoneout    :    out    std_logic;
        pmalccmurstb    :    out    std_logic;
        pmaltr    :    out    std_logic;
        aggtxpcsrst    :    out    std_logic;
        aggrxpcsrst    :    out    std_logic;
        aggtxdatatc    :    out    std_logic_vector(7 downto 0);
        aggtxctltc    :    out    std_logic;
        aggrdenablesync    :    out    std_logic;
        aggsyncstatus    :    out    std_logic;
        aggaligndetsync    :    out    std_logic_vector(1 downto 0);
        aggrdalign    :    out    std_logic_vector(1 downto 0);
        aggalignstatussync    :    out    std_logic;
        aggfifordoutcomp    :    out    std_logic;
        aggcgcomprddout    :    out    std_logic_vector(1 downto 0);
        aggcgcompwrout    :    out    std_logic_vector(1 downto 0);
        aggdelcondmetout    :    out    std_logic;
        aggfifoovrout    :    out    std_logic;
        agglatencycompout    :    out    std_logic;
        agginsertincompleteout    :    out    std_logic;
        aggdecdatavalid    :    out    std_logic;
        aggdecdata    :    out    std_logic_vector(7 downto 0);
        aggdecctl    :    out    std_logic;
        aggrunningdisp    :    out    std_logic_vector(1 downto 0);
        pcsgen3pmarxdetectvalid    :    out    std_logic;
        pcsgen3pmarxfound    :    out    std_logic;
        pcsgen3pmapcieswdone    :    out    std_logic_vector(1 downto 0);
        pcsgen3pllfixedclk    :    out    std_logic;
        pcsaggrcvdclkagg    :    out    std_logic;
        pcsaggtxdatats    :    out    std_logic_vector(7 downto 0);
        pcsaggtxctlts    :    out    std_logic;
        pcsaggfiforstrdqd    :    out    std_logic;
        pcsaggendskwqd    :    out    std_logic;
        pcsaggendskwrdptrs    :    out    std_logic;
        pcsaggalignstatus    :    out    std_logic;
        pcsaggalignstatussync0    :    out    std_logic;
        pcsaggcgcomprddall    :    out    std_logic;
        pcsaggcgcompwrall    :    out    std_logic;
        pcsaggfifordincomp0    :    out    std_logic;
        pcsaggdelcondmet0    :    out    std_logic;
        pcsagginsertincomplete0    :    out    std_logic;
        pcsaggfifoovr0    :    out    std_logic;
        pcsagglatencycomp0    :    out    std_logic;
        pcsaggrxdatars    :    out    std_logic_vector(7 downto 0);
        pcsaggrxcontrolrs    :    out    std_logic;
        pcsaggrcvdclkaggtoporbot    :    out    std_logic;
        pcsaggtxdatatstoporbot    :    out    std_logic_vector(7 downto 0);
        pcsaggtxctltstoporbot    :    out    std_logic;
        pcsaggfiforstrdqdtoporbot    :    out    std_logic;
        pcsaggendskwqdtoporbot    :    out    std_logic;
        pcsaggendskwrdptrstoporbot    :    out    std_logic;
        pcsaggalignstatustoporbot    :    out    std_logic;
        pcsaggalignstatussync0toporbot    :    out    std_logic;
        pcsaggcgcomprddalltoporbot    :    out    std_logic;
        pcsaggcgcompwralltoporbot    :    out    std_logic;
        pcsaggfifordincomp0toporbot    :    out    std_logic;
        pcsaggdelcondmet0toporbot    :    out    std_logic;
        pcsagginsertincomplete0toporbot    :    out    std_logic;
        pcsaggfifoovr0toporbot    :    out    std_logic;
        pcsagglatencycomp0toporbot    :    out    std_logic;
        pcsaggrxdatarstoporbot    :    out    std_logic_vector(7 downto 0);
        pcsaggrxcontrolrstoporbot    :    out    std_logic;
        pcs8grxdetectvalid    :    out    std_logic;
        pcs8gpmarxfound    :    out    std_logic;
        pcs8ggen2ngen1    :    out    std_logic;
        pcs8gpowerstatetransitiondone    :    out    std_logic;
        ppmcntlatch    :    out    std_logic_vector(7 downto 0);
        pldhclkout    :    out    std_logic;
        aggscanmoden    :    out    std_logic;
        aggscanshiftn    :    out    std_logic;
        aggrefclkdig    :    out    std_logic;
        pmaoffcalen    :    out    std_logic;
        pmafrefout    :    out    std_logic;
        pmaclklowout    :    out    std_logic
    );
end stratixv_hssi_common_pcs_pma_interface;

architecture behavior of stratixv_hssi_common_pcs_pma_interface is

component    stratixv_hssi_common_pcs_pma_interface_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_common_pcs_pma_interface";
        auto_speed_ena    :    string    :=    "dis_auto_speed_ena";
        force_freqdet    :    string    :=    "force_freqdet_dis";
        func_mode    :    string    :=    "disable";
        pcie_gen3_cap    :    string    :=    "non_pcie_gen3_cap";
        pipe_if_g3pcs    :    string    :=    "pipe_if_8gpcs";
        pma_if_dft_en    :    string    :=    "dft_dis";
        pma_if_dft_val    :    string    :=    "dft_0";
        ppm_cnt_rst    :    string    :=    "ppm_cnt_rst_dis";
        ppm_deassert_early    :    string    :=    "deassert_early_dis";
        ppm_gen1_2_cnt    :    string    :=    "cnt_32k";
        ppm_post_eidle_delay    :    string    :=    "cnt_200_cycles";
        ppmsel    :    string    :=    "ppmsel_default";
        prot_mode    :    string    :=    "disabled_prot_mode";
        refclk_dig_sel    :    string    :=    "refclk_dig_dis";
        selectpcs    :    string    :=    "eight_g_pcs";
        sup_mode    :    string    :=    "full_mode"
    );
    port    (
        fref    :    in    std_logic;
        clklow    :    in    std_logic;
        pmapcieswdone    :    in    std_logic_vector(1 downto 0);
        pmarxfound    :    in    std_logic;
        pmarxdetectvalid    :    in    std_logic;
        pmahclk    :    in    std_logic;
        pldoffcalen    :    in    std_logic;
        aggrcvdclkagg    :    in    std_logic;
        aggtxdatats    :    in    std_logic_vector(7 downto 0);
        aggtxctlts    :    in    std_logic;
        aggfiforstrdqd    :    in    std_logic;
        aggendskwqd    :    in    std_logic;
        aggendskwrdptrs    :    in    std_logic;
        aggalignstatus    :    in    std_logic;
        aggalignstatussync0    :    in    std_logic;
        aggcgcomprddall    :    in    std_logic;
        aggcgcompwrall    :    in    std_logic;
        aggfifordincomp0    :    in    std_logic;
        aggdelcondmet0    :    in    std_logic;
        agginsertincomplete0    :    in    std_logic;
        aggfifoovr0    :    in    std_logic;
        agglatencycomp0    :    in    std_logic;
        aggrxdatars    :    in    std_logic_vector(7 downto 0);
        aggrxcontrolrs    :    in    std_logic;
        aggrcvdclkaggtoporbot    :    in    std_logic;
        aggtxdatatstoporbot    :    in    std_logic_vector(7 downto 0);
        aggtxctltstoporbot    :    in    std_logic;
        aggfiforstrdqdtoporbot    :    in    std_logic;
        aggendskwqdtoporbot    :    in    std_logic;
        aggendskwrdptrstoporbot    :    in    std_logic;
        aggalignstatustoporbot    :    in    std_logic;
        aggalignstatussync0toporbot    :    in    std_logic;
        aggcgcomprddalltoporbot    :    in    std_logic;
        aggcgcompwralltoporbot    :    in    std_logic;
        aggfifordincomp0toporbot    :    in    std_logic;
        aggdelcondmet0toporbot    :    in    std_logic;
        agginsertincomplete0toporbot    :    in    std_logic;
        aggfifoovr0toporbot    :    in    std_logic;
        agglatencycomp0toporbot    :    in    std_logic;
        aggrxdatarstoporbot    :    in    std_logic_vector(7 downto 0);
        aggrxcontrolrstoporbot    :    in    std_logic;
        pcsgen3pmapcieswitch    :    in    std_logic_vector(1 downto 0);
        pcsgen3pmatxmargin    :    in    std_logic_vector(2 downto 0);
        pcsgen3pmatxdeemph    :    in    std_logic;
        pcsgen3pmatxswing    :    in    std_logic;
        pcsgen3pmacurrentcoeff    :    in    std_logic_vector(17 downto 0);
        pcsgen3pmacurrentrxpreset    :    in    std_logic_vector(2 downto 0);
        pcsgen3pmatxelecidle    :    in    std_logic;
        pcsgen3pmatxdetectrx    :    in    std_logic;
        pcsgen3ppmeidleexit    :    in    std_logic;
        pcsgen3pmaltr    :    in    std_logic;
        pcsgen3pmaearlyeios    :    in    std_logic;
        pcs8gpcieswitch    :    in    std_logic;
        pcs8gtxelecidle    :    in    std_logic;
        pcs8gtxdetectrx    :    in    std_logic;
        pcs8gearlyeios    :    in    std_logic;
        pcs8gtxdeemphpma    :    in    std_logic;
        pcs8gtxmarginpma    :    in    std_logic_vector(2 downto 0);
        pcs8gtxswingpma    :    in    std_logic;
        pcs8gltrpma    :    in    std_logic;
        pcs8geidleexit    :    in    std_logic;
        pcsaggtxpcsrst    :    in    std_logic;
        pcsaggrxpcsrst    :    in    std_logic;
        pcsaggtxdatatc    :    in    std_logic_vector(7 downto 0);
        pcsaggtxctltc    :    in    std_logic;
        pcsaggrdenablesync    :    in    std_logic;
        pcsaggsyncstatus    :    in    std_logic;
        pcsaggaligndetsync    :    in    std_logic_vector(1 downto 0);
        pcsaggrdalign    :    in    std_logic_vector(1 downto 0);
        pcsaggalignstatussync    :    in    std_logic;
        pcsaggfifordoutcomp    :    in    std_logic;
        pcsaggcgcomprddout    :    in    std_logic_vector(1 downto 0);
        pcsaggcgcompwrout    :    in    std_logic_vector(1 downto 0);
        pcsaggdelcondmetout    :    in    std_logic;
        pcsaggfifoovrout    :    in    std_logic;
        pcsagglatencycompout    :    in    std_logic;
        pcsagginsertincompleteout    :    in    std_logic;
        pcsaggdecdatavalid    :    in    std_logic;
        pcsaggdecdata    :    in    std_logic_vector(7 downto 0);
        pcsaggdecctl    :    in    std_logic;
        pcsaggrunningdisp    :    in    std_logic_vector(1 downto 0);
        pldrxclkslip    :    in    std_logic;
        pldhardreset    :    in    std_logic;
        pcsscanmoden    :    in    std_logic;
        pcsscanshiftn    :    in    std_logic;
        pcsrefclkdig    :    in    std_logic;
        pcsaggscanmoden    :    in    std_logic;
        pcsaggscanshiftn    :    in    std_logic;
        pcsaggrefclkdig    :    in    std_logic;
        pcsgen3gen3datasel    :    in    std_logic;
        pldlccmurstb    :    in    std_logic;
        pmaoffcaldonein    :    in    std_logic;
        pmarxpmarstb    :    in    std_logic;
        pmahardreset    :    out    std_logic;
        freqlock    :    out    std_logic;
        pmapcieswitch    :    out    std_logic_vector(1 downto 0);
        pmaearlyeios    :    out    std_logic;
        pmatxdetectrx    :    out    std_logic;
        pmatxelecidle    :    out    std_logic;
        pmatxdeemph    :    out    std_logic;
        pmatxswing    :    out    std_logic;
        pmatxmargin    :    out    std_logic_vector(2 downto 0);
        pmacurrentcoeff    :    out    std_logic_vector(17 downto 0);
        pmacurrentrxpreset    :    out    std_logic_vector(2 downto 0);
        pmaoffcaldoneout    :    out    std_logic;
        pmalccmurstb    :    out    std_logic;
        pmaltr    :    out    std_logic;
        aggtxpcsrst    :    out    std_logic;
        aggrxpcsrst    :    out    std_logic;
        aggtxdatatc    :    out    std_logic_vector(7 downto 0);
        aggtxctltc    :    out    std_logic;
        aggrdenablesync    :    out    std_logic;
        aggsyncstatus    :    out    std_logic;
        aggaligndetsync    :    out    std_logic_vector(1 downto 0);
        aggrdalign    :    out    std_logic_vector(1 downto 0);
        aggalignstatussync    :    out    std_logic;
        aggfifordoutcomp    :    out    std_logic;
        aggcgcomprddout    :    out    std_logic_vector(1 downto 0);
        aggcgcompwrout    :    out    std_logic_vector(1 downto 0);
        aggdelcondmetout    :    out    std_logic;
        aggfifoovrout    :    out    std_logic;
        agglatencycompout    :    out    std_logic;
        agginsertincompleteout    :    out    std_logic;
        aggdecdatavalid    :    out    std_logic;
        aggdecdata    :    out    std_logic_vector(7 downto 0);
        aggdecctl    :    out    std_logic;
        aggrunningdisp    :    out    std_logic_vector(1 downto 0);
        pcsgen3pmarxdetectvalid    :    out    std_logic;
        pcsgen3pmarxfound    :    out    std_logic;
        pcsgen3pmapcieswdone    :    out    std_logic_vector(1 downto 0);
        pcsgen3pllfixedclk    :    out    std_logic;
        pcsaggrcvdclkagg    :    out    std_logic;
        pcsaggtxdatats    :    out    std_logic_vector(7 downto 0);
        pcsaggtxctlts    :    out    std_logic;
        pcsaggfiforstrdqd    :    out    std_logic;
        pcsaggendskwqd    :    out    std_logic;
        pcsaggendskwrdptrs    :    out    std_logic;
        pcsaggalignstatus    :    out    std_logic;
        pcsaggalignstatussync0    :    out    std_logic;
        pcsaggcgcomprddall    :    out    std_logic;
        pcsaggcgcompwrall    :    out    std_logic;
        pcsaggfifordincomp0    :    out    std_logic;
        pcsaggdelcondmet0    :    out    std_logic;
        pcsagginsertincomplete0    :    out    std_logic;
        pcsaggfifoovr0    :    out    std_logic;
        pcsagglatencycomp0    :    out    std_logic;
        pcsaggrxdatars    :    out    std_logic_vector(7 downto 0);
        pcsaggrxcontrolrs    :    out    std_logic;
        pcsaggrcvdclkaggtoporbot    :    out    std_logic;
        pcsaggtxdatatstoporbot    :    out    std_logic_vector(7 downto 0);
        pcsaggtxctltstoporbot    :    out    std_logic;
        pcsaggfiforstrdqdtoporbot    :    out    std_logic;
        pcsaggendskwqdtoporbot    :    out    std_logic;
        pcsaggendskwrdptrstoporbot    :    out    std_logic;
        pcsaggalignstatustoporbot    :    out    std_logic;
        pcsaggalignstatussync0toporbot    :    out    std_logic;
        pcsaggcgcomprddalltoporbot    :    out    std_logic;
        pcsaggcgcompwralltoporbot    :    out    std_logic;
        pcsaggfifordincomp0toporbot    :    out    std_logic;
        pcsaggdelcondmet0toporbot    :    out    std_logic;
        pcsagginsertincomplete0toporbot    :    out    std_logic;
        pcsaggfifoovr0toporbot    :    out    std_logic;
        pcsagglatencycomp0toporbot    :    out    std_logic;
        pcsaggrxdatarstoporbot    :    out    std_logic_vector(7 downto 0);
        pcsaggrxcontrolrstoporbot    :    out    std_logic;
        pcs8grxdetectvalid    :    out    std_logic;
        pcs8gpmarxfound    :    out    std_logic;
        pcs8ggen2ngen1    :    out    std_logic;
        pcs8gpowerstatetransitiondone    :    out    std_logic;
        ppmcntlatch    :    out    std_logic_vector(7 downto 0);
        pldhclkout    :    out    std_logic;
        aggscanmoden    :    out    std_logic;
        aggscanshiftn    :    out    std_logic;
        aggrefclkdig    :    out    std_logic;
        pmaoffcalen    :    out    std_logic;
        pmafrefout    :    out    std_logic;
        pmaclklowout    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_common_pcs_pma_interface_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        auto_speed_ena    =>   auto_speed_ena,
        force_freqdet    =>   force_freqdet,
        func_mode    =>   func_mode,
        pcie_gen3_cap    =>   pcie_gen3_cap,
        pipe_if_g3pcs    =>   pipe_if_g3pcs,
        pma_if_dft_en    =>   pma_if_dft_en,
        pma_if_dft_val    =>   pma_if_dft_val,
        ppm_cnt_rst    =>   ppm_cnt_rst,
        ppm_deassert_early    =>   ppm_deassert_early,
        ppm_gen1_2_cnt    =>   ppm_gen1_2_cnt,
        ppm_post_eidle_delay    =>   ppm_post_eidle_delay,
        ppmsel    =>   ppmsel,
        prot_mode    =>   prot_mode,
        refclk_dig_sel    =>   refclk_dig_sel,
        selectpcs    =>   selectpcs,
        sup_mode    =>   sup_mode
    )
    port  map  (
        fref    =>    fref,
        clklow    =>    clklow,
        pmapcieswdone    =>    pmapcieswdone,
        pmarxfound    =>    pmarxfound,
        pmarxdetectvalid    =>    pmarxdetectvalid,
        pmahclk    =>    pmahclk,
        pldoffcalen    =>    pldoffcalen,
        aggrcvdclkagg    =>    aggrcvdclkagg,
        aggtxdatats    =>    aggtxdatats,
        aggtxctlts    =>    aggtxctlts,
        aggfiforstrdqd    =>    aggfiforstrdqd,
        aggendskwqd    =>    aggendskwqd,
        aggendskwrdptrs    =>    aggendskwrdptrs,
        aggalignstatus    =>    aggalignstatus,
        aggalignstatussync0    =>    aggalignstatussync0,
        aggcgcomprddall    =>    aggcgcomprddall,
        aggcgcompwrall    =>    aggcgcompwrall,
        aggfifordincomp0    =>    aggfifordincomp0,
        aggdelcondmet0    =>    aggdelcondmet0,
        agginsertincomplete0    =>    agginsertincomplete0,
        aggfifoovr0    =>    aggfifoovr0,
        agglatencycomp0    =>    agglatencycomp0,
        aggrxdatars    =>    aggrxdatars,
        aggrxcontrolrs    =>    aggrxcontrolrs,
        aggrcvdclkaggtoporbot    =>    aggrcvdclkaggtoporbot,
        aggtxdatatstoporbot    =>    aggtxdatatstoporbot,
        aggtxctltstoporbot    =>    aggtxctltstoporbot,
        aggfiforstrdqdtoporbot    =>    aggfiforstrdqdtoporbot,
        aggendskwqdtoporbot    =>    aggendskwqdtoporbot,
        aggendskwrdptrstoporbot    =>    aggendskwrdptrstoporbot,
        aggalignstatustoporbot    =>    aggalignstatustoporbot,
        aggalignstatussync0toporbot    =>    aggalignstatussync0toporbot,
        aggcgcomprddalltoporbot    =>    aggcgcomprddalltoporbot,
        aggcgcompwralltoporbot    =>    aggcgcompwralltoporbot,
        aggfifordincomp0toporbot    =>    aggfifordincomp0toporbot,
        aggdelcondmet0toporbot    =>    aggdelcondmet0toporbot,
        agginsertincomplete0toporbot    =>    agginsertincomplete0toporbot,
        aggfifoovr0toporbot    =>    aggfifoovr0toporbot,
        agglatencycomp0toporbot    =>    agglatencycomp0toporbot,
        aggrxdatarstoporbot    =>    aggrxdatarstoporbot,
        aggrxcontrolrstoporbot    =>    aggrxcontrolrstoporbot,
        pcsgen3pmapcieswitch    =>    pcsgen3pmapcieswitch,
        pcsgen3pmatxmargin    =>    pcsgen3pmatxmargin,
        pcsgen3pmatxdeemph    =>    pcsgen3pmatxdeemph,
        pcsgen3pmatxswing    =>    pcsgen3pmatxswing,
        pcsgen3pmacurrentcoeff    =>    pcsgen3pmacurrentcoeff,
        pcsgen3pmacurrentrxpreset    =>    pcsgen3pmacurrentrxpreset,
        pcsgen3pmatxelecidle    =>    pcsgen3pmatxelecidle,
        pcsgen3pmatxdetectrx    =>    pcsgen3pmatxdetectrx,
        pcsgen3ppmeidleexit    =>    pcsgen3ppmeidleexit,
        pcsgen3pmaltr    =>    pcsgen3pmaltr,
        pcsgen3pmaearlyeios    =>    pcsgen3pmaearlyeios,
        pcs8gpcieswitch    =>    pcs8gpcieswitch,
        pcs8gtxelecidle    =>    pcs8gtxelecidle,
        pcs8gtxdetectrx    =>    pcs8gtxdetectrx,
        pcs8gearlyeios    =>    pcs8gearlyeios,
        pcs8gtxdeemphpma    =>    pcs8gtxdeemphpma,
        pcs8gtxmarginpma    =>    pcs8gtxmarginpma,
        pcs8gtxswingpma    =>    pcs8gtxswingpma,
        pcs8gltrpma    =>    pcs8gltrpma,
        pcs8geidleexit    =>    pcs8geidleexit,
        pcsaggtxpcsrst    =>    pcsaggtxpcsrst,
        pcsaggrxpcsrst    =>    pcsaggrxpcsrst,
        pcsaggtxdatatc    =>    pcsaggtxdatatc,
        pcsaggtxctltc    =>    pcsaggtxctltc,
        pcsaggrdenablesync    =>    pcsaggrdenablesync,
        pcsaggsyncstatus    =>    pcsaggsyncstatus,
        pcsaggaligndetsync    =>    pcsaggaligndetsync,
        pcsaggrdalign    =>    pcsaggrdalign,
        pcsaggalignstatussync    =>    pcsaggalignstatussync,
        pcsaggfifordoutcomp    =>    pcsaggfifordoutcomp,
        pcsaggcgcomprddout    =>    pcsaggcgcomprddout,
        pcsaggcgcompwrout    =>    pcsaggcgcompwrout,
        pcsaggdelcondmetout    =>    pcsaggdelcondmetout,
        pcsaggfifoovrout    =>    pcsaggfifoovrout,
        pcsagglatencycompout    =>    pcsagglatencycompout,
        pcsagginsertincompleteout    =>    pcsagginsertincompleteout,
        pcsaggdecdatavalid    =>    pcsaggdecdatavalid,
        pcsaggdecdata    =>    pcsaggdecdata,
        pcsaggdecctl    =>    pcsaggdecctl,
        pcsaggrunningdisp    =>    pcsaggrunningdisp,
        pldrxclkslip    =>    pldrxclkslip,
        pldhardreset    =>    pldhardreset,
        pcsscanmoden    =>    pcsscanmoden,
        pcsscanshiftn    =>    pcsscanshiftn,
        pcsrefclkdig    =>    pcsrefclkdig,
        pcsaggscanmoden    =>    pcsaggscanmoden,
        pcsaggscanshiftn    =>    pcsaggscanshiftn,
        pcsaggrefclkdig    =>    pcsaggrefclkdig,
        pcsgen3gen3datasel    =>    pcsgen3gen3datasel,
        pldlccmurstb    =>    pldlccmurstb,
        pmaoffcaldonein    =>    pmaoffcaldonein,
        pmarxpmarstb    =>    pmarxpmarstb,
        pmahardreset    =>    pmahardreset,
        freqlock    =>    freqlock,
        pmapcieswitch    =>    pmapcieswitch,
        pmaearlyeios    =>    pmaearlyeios,
        pmatxdetectrx    =>    pmatxdetectrx,
        pmatxelecidle    =>    pmatxelecidle,
        pmatxdeemph    =>    pmatxdeemph,
        pmatxswing    =>    pmatxswing,
        pmatxmargin    =>    pmatxmargin,
        pmacurrentcoeff    =>    pmacurrentcoeff,
        pmacurrentrxpreset    =>    pmacurrentrxpreset,
        pmaoffcaldoneout    =>    pmaoffcaldoneout,
        pmalccmurstb    =>    pmalccmurstb,
        pmaltr    =>    pmaltr,
        aggtxpcsrst    =>    aggtxpcsrst,
        aggrxpcsrst    =>    aggrxpcsrst,
        aggtxdatatc    =>    aggtxdatatc,
        aggtxctltc    =>    aggtxctltc,
        aggrdenablesync    =>    aggrdenablesync,
        aggsyncstatus    =>    aggsyncstatus,
        aggaligndetsync    =>    aggaligndetsync,
        aggrdalign    =>    aggrdalign,
        aggalignstatussync    =>    aggalignstatussync,
        aggfifordoutcomp    =>    aggfifordoutcomp,
        aggcgcomprddout    =>    aggcgcomprddout,
        aggcgcompwrout    =>    aggcgcompwrout,
        aggdelcondmetout    =>    aggdelcondmetout,
        aggfifoovrout    =>    aggfifoovrout,
        agglatencycompout    =>    agglatencycompout,
        agginsertincompleteout    =>    agginsertincompleteout,
        aggdecdatavalid    =>    aggdecdatavalid,
        aggdecdata    =>    aggdecdata,
        aggdecctl    =>    aggdecctl,
        aggrunningdisp    =>    aggrunningdisp,
        pcsgen3pmarxdetectvalid    =>    pcsgen3pmarxdetectvalid,
        pcsgen3pmarxfound    =>    pcsgen3pmarxfound,
        pcsgen3pmapcieswdone    =>    pcsgen3pmapcieswdone,
        pcsgen3pllfixedclk    =>    pcsgen3pllfixedclk,
        pcsaggrcvdclkagg    =>    pcsaggrcvdclkagg,
        pcsaggtxdatats    =>    pcsaggtxdatats,
        pcsaggtxctlts    =>    pcsaggtxctlts,
        pcsaggfiforstrdqd    =>    pcsaggfiforstrdqd,
        pcsaggendskwqd    =>    pcsaggendskwqd,
        pcsaggendskwrdptrs    =>    pcsaggendskwrdptrs,
        pcsaggalignstatus    =>    pcsaggalignstatus,
        pcsaggalignstatussync0    =>    pcsaggalignstatussync0,
        pcsaggcgcomprddall    =>    pcsaggcgcomprddall,
        pcsaggcgcompwrall    =>    pcsaggcgcompwrall,
        pcsaggfifordincomp0    =>    pcsaggfifordincomp0,
        pcsaggdelcondmet0    =>    pcsaggdelcondmet0,
        pcsagginsertincomplete0    =>    pcsagginsertincomplete0,
        pcsaggfifoovr0    =>    pcsaggfifoovr0,
        pcsagglatencycomp0    =>    pcsagglatencycomp0,
        pcsaggrxdatars    =>    pcsaggrxdatars,
        pcsaggrxcontrolrs    =>    pcsaggrxcontrolrs,
        pcsaggrcvdclkaggtoporbot    =>    pcsaggrcvdclkaggtoporbot,
        pcsaggtxdatatstoporbot    =>    pcsaggtxdatatstoporbot,
        pcsaggtxctltstoporbot    =>    pcsaggtxctltstoporbot,
        pcsaggfiforstrdqdtoporbot    =>    pcsaggfiforstrdqdtoporbot,
        pcsaggendskwqdtoporbot    =>    pcsaggendskwqdtoporbot,
        pcsaggendskwrdptrstoporbot    =>    pcsaggendskwrdptrstoporbot,
        pcsaggalignstatustoporbot    =>    pcsaggalignstatustoporbot,
        pcsaggalignstatussync0toporbot    =>    pcsaggalignstatussync0toporbot,
        pcsaggcgcomprddalltoporbot    =>    pcsaggcgcomprddalltoporbot,
        pcsaggcgcompwralltoporbot    =>    pcsaggcgcompwralltoporbot,
        pcsaggfifordincomp0toporbot    =>    pcsaggfifordincomp0toporbot,
        pcsaggdelcondmet0toporbot    =>    pcsaggdelcondmet0toporbot,
        pcsagginsertincomplete0toporbot    =>    pcsagginsertincomplete0toporbot,
        pcsaggfifoovr0toporbot    =>    pcsaggfifoovr0toporbot,
        pcsagglatencycomp0toporbot    =>    pcsagglatencycomp0toporbot,
        pcsaggrxdatarstoporbot    =>    pcsaggrxdatarstoporbot,
        pcsaggrxcontrolrstoporbot    =>    pcsaggrxcontrolrstoporbot,
        pcs8grxdetectvalid    =>    pcs8grxdetectvalid,
        pcs8gpmarxfound    =>    pcs8gpmarxfound,
        pcs8ggen2ngen1    =>    pcs8ggen2ngen1,
        pcs8gpowerstatetransitiondone    =>    pcs8gpowerstatetransitiondone,
        ppmcntlatch    =>    ppmcntlatch,
        pldhclkout    =>    pldhclkout,
        aggscanmoden    =>    aggscanmoden,
        aggscanshiftn    =>    aggscanshiftn,
        aggrefclkdig    =>    aggrefclkdig,
        pmaoffcalen    =>    pmaoffcalen,
        pmafrefout    =>    pmafrefout,
        pmaclklowout    =>    pmaclklowout
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_common_pld_pcs_interface    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_common_pld_pcs_interface";
        data_source    :    string    :=    "pld";
        emsip_enable    :    string    :=    "emsip_disable";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        pldhardresetin    :    in    std_logic;
        pldscanmoden    :    in    std_logic;
        pldscanshiftn    :    in    std_logic;
        pldgen3refclkdig    :    in    std_logic;
        pld10grefclkdig    :    in    std_logic;
        pld8grefclkdig    :    in    std_logic;
        pldaggrefclkdig    :    in    std_logic;
        pldpcspmaifrefclkdig    :    in    std_logic;
        pldrate    :    in    std_logic_vector(1 downto 0);
        pldeidleinfersel    :    in    std_logic_vector(2 downto 0);
        pld8gsoftresetallhssi    :    in    std_logic;
        pld8gplniotri    :    in    std_logic;
        pld8gprbsciden    :    in    std_logic;
        pld8gltr    :    in    std_logic;
        pld8gtxelecidle    :    in    std_logic;
        pld8gtxdetectrxloopback    :    in    std_logic;
        pld8gtxdeemph    :    in    std_logic;
        pld8gtxmargin    :    in    std_logic_vector(2 downto 0);
        pld8gtxswing    :    in    std_logic;
        pld8grxpolarity    :    in    std_logic;
        pld8gpowerdown    :    in    std_logic_vector(1 downto 0);
        pldgen3currentcoeff    :    in    std_logic_vector(17 downto 0);
        pldgen3currentrxpreset    :    in    std_logic_vector(2 downto 0);
        pcs10gtestdata    :    in    std_logic_vector(19 downto 0);
        pcs8gchnltestbusout    :    in    std_logic_vector(9 downto 0);
        pcs8grxvalid    :    in    std_logic;
        pcs8grxelecidle    :    in    std_logic;
        pcs8grxstatus    :    in    std_logic_vector(2 downto 0);
        pcs8gphystatus    :    in    std_logic;
        pldhclkin    :    in    std_logic;
        pcsgen3pldasyncstatus    :    in    std_logic_vector(5 downto 0);
        pcsgen3testout    :    in    std_logic_vector(19 downto 0);
        emsippcsreset    :    in    std_logic_vector(2 downto 0);
        emsippcsctrl    :    in    std_logic_vector(38 downto 0);
        pmafref    :    in    std_logic;
        pmaclklow    :    in    std_logic;
        pmaoffcaldone    :    in    std_logic;
        pldoffcalenin    :    in    std_logic;
        pcsgen3masktxpll    :    in    std_logic;
        rcomemsip    :    in    std_logic;
        rcomhipena    :    in    std_logic;
        rcomblocksel    :    in    std_logic_vector(1 downto 0);
        pldtestdata    :    out    std_logic_vector(19 downto 0);
        pld8grxvalid    :    out    std_logic;
        pld8grxelecidle    :    out    std_logic;
        pld8grxstatus    :    out    std_logic_vector(2 downto 0);
        pld8gphystatus    :    out    std_logic;
        pldgen3pldasyncstatus    :    out    std_logic_vector(5 downto 0);
        pcs10ghardresetn    :    out    std_logic;
        pcs10gscanmoden    :    out    std_logic;
        pcs10gscanshiftn    :    out    std_logic;
        pcs10grefclkdig    :    out    std_logic;
        pcs8ghardreset    :    out    std_logic;
        pcs8gsoftresetallhssi    :    out    std_logic;
        pcs8gplniotri    :    out    std_logic;
        pcs8gscanmoden    :    out    std_logic;
        pcs8gscanshiftn    :    out    std_logic;
        pcs8grefclkdig    :    out    std_logic;
        pcs8gprbsciden    :    out    std_logic;
        pcs8gltr    :    out    std_logic;
        pcs8gtxelecidle    :    out    std_logic;
        pcs8gtxdetectrxloopback    :    out    std_logic;
        pcs8gtxdeemph    :    out    std_logic;
        pcs8gtxmargin    :    out    std_logic_vector(2 downto 0);
        pcs8gtxswing    :    out    std_logic;
        pcs8grxpolarity    :    out    std_logic;
        pcs8grate    :    out    std_logic;
        pcs8gpowerdown    :    out    std_logic_vector(1 downto 0);
        pcs8geidleinfersel    :    out    std_logic_vector(2 downto 0);
        pcsgen3pcsdigclk    :    out    std_logic;
        pcsgen3rate    :    out    std_logic_vector(1 downto 0);
        pcsgen3eidleinfersel    :    out    std_logic_vector(2 downto 0);
        pcsgen3scanmoden    :    out    std_logic;
        pcsgen3scanshiftn    :    out    std_logic;
        pcsgen3pldltr    :    out    std_logic;
        pldhardresetout    :    out    std_logic;
        pcsgen3currentcoeff    :    out    std_logic_vector(17 downto 0);
        pcsgen3currentrxpreset    :    out    std_logic_vector(2 downto 0);
        pcsaggrefclkdig    :    out    std_logic;
        pcspcspmaifrefclkdig    :    out    std_logic;
        pcsaggscanmoden    :    out    std_logic;
        pcsaggscanshiftn    :    out    std_logic;
        pcspcspmaifscanmoden    :    out    std_logic;
        pcspcspmaifscanshiftn    :    out    std_logic;
        emsippcsclkout    :    out    std_logic_vector(2 downto 0);
        emsippcsstatus    :    out    std_logic_vector(13 downto 0);
        pldfref    :    out    std_logic;
        pldclklow    :    out    std_logic;
        emsipenabledusermode    :    out    std_logic;
        pldoffcalenout    :    out    std_logic;
        pldoffcaldone    :    out    std_logic;
        pldgen3masktxpll    :    out    std_logic
    );
end stratixv_hssi_common_pld_pcs_interface;

architecture behavior of stratixv_hssi_common_pld_pcs_interface is

component    stratixv_hssi_common_pld_pcs_interface_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_common_pld_pcs_interface";
        data_source    :    string    :=    "pld";
        emsip_enable    :    string    :=    "emsip_disable";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        pldhardresetin    :    in    std_logic;
        pldscanmoden    :    in    std_logic;
        pldscanshiftn    :    in    std_logic;
        pldgen3refclkdig    :    in    std_logic;
        pld10grefclkdig    :    in    std_logic;
        pld8grefclkdig    :    in    std_logic;
        pldaggrefclkdig    :    in    std_logic;
        pldpcspmaifrefclkdig    :    in    std_logic;
        pldrate    :    in    std_logic_vector(1 downto 0);
        pldeidleinfersel    :    in    std_logic_vector(2 downto 0);
        pld8gsoftresetallhssi    :    in    std_logic;
        pld8gplniotri    :    in    std_logic;
        pld8gprbsciden    :    in    std_logic;
        pld8gltr    :    in    std_logic;
        pld8gtxelecidle    :    in    std_logic;
        pld8gtxdetectrxloopback    :    in    std_logic;
        pld8gtxdeemph    :    in    std_logic;
        pld8gtxmargin    :    in    std_logic_vector(2 downto 0);
        pld8gtxswing    :    in    std_logic;
        pld8grxpolarity    :    in    std_logic;
        pld8gpowerdown    :    in    std_logic_vector(1 downto 0);
        pldgen3currentcoeff    :    in    std_logic_vector(17 downto 0);
        pldgen3currentrxpreset    :    in    std_logic_vector(2 downto 0);
        pcs10gtestdata    :    in    std_logic_vector(19 downto 0);
        pcs8gchnltestbusout    :    in    std_logic_vector(9 downto 0);
        pcs8grxvalid    :    in    std_logic;
        pcs8grxelecidle    :    in    std_logic;
        pcs8grxstatus    :    in    std_logic_vector(2 downto 0);
        pcs8gphystatus    :    in    std_logic;
        pldhclkin    :    in    std_logic;
        pcsgen3pldasyncstatus    :    in    std_logic_vector(5 downto 0);
        pcsgen3testout    :    in    std_logic_vector(19 downto 0);
        emsippcsreset    :    in    std_logic_vector(2 downto 0);
        emsippcsctrl    :    in    std_logic_vector(38 downto 0);
        pmafref    :    in    std_logic;
        pmaclklow    :    in    std_logic;
        pmaoffcaldone    :    in    std_logic;
        pldoffcalenin    :    in    std_logic;
        pcsgen3masktxpll    :    in    std_logic;
        rcomemsip    :    in    std_logic;
        rcomhipena    :    in    std_logic;
        rcomblocksel    :    in    std_logic_vector(1 downto 0);
        pldtestdata    :    out    std_logic_vector(19 downto 0);
        pld8grxvalid    :    out    std_logic;
        pld8grxelecidle    :    out    std_logic;
        pld8grxstatus    :    out    std_logic_vector(2 downto 0);
        pld8gphystatus    :    out    std_logic;
        pldgen3pldasyncstatus    :    out    std_logic_vector(5 downto 0);
        pcs10ghardresetn    :    out    std_logic;
        pcs10gscanmoden    :    out    std_logic;
        pcs10gscanshiftn    :    out    std_logic;
        pcs10grefclkdig    :    out    std_logic;
        pcs8ghardreset    :    out    std_logic;
        pcs8gsoftresetallhssi    :    out    std_logic;
        pcs8gplniotri    :    out    std_logic;
        pcs8gscanmoden    :    out    std_logic;
        pcs8gscanshiftn    :    out    std_logic;
        pcs8grefclkdig    :    out    std_logic;
        pcs8gprbsciden    :    out    std_logic;
        pcs8gltr    :    out    std_logic;
        pcs8gtxelecidle    :    out    std_logic;
        pcs8gtxdetectrxloopback    :    out    std_logic;
        pcs8gtxdeemph    :    out    std_logic;
        pcs8gtxmargin    :    out    std_logic_vector(2 downto 0);
        pcs8gtxswing    :    out    std_logic;
        pcs8grxpolarity    :    out    std_logic;
        pcs8grate    :    out    std_logic;
        pcs8gpowerdown    :    out    std_logic_vector(1 downto 0);
        pcs8geidleinfersel    :    out    std_logic_vector(2 downto 0);
        pcsgen3pcsdigclk    :    out    std_logic;
        pcsgen3rate    :    out    std_logic_vector(1 downto 0);
        pcsgen3eidleinfersel    :    out    std_logic_vector(2 downto 0);
        pcsgen3scanmoden    :    out    std_logic;
        pcsgen3scanshiftn    :    out    std_logic;
        pcsgen3pldltr    :    out    std_logic;
        pldhardresetout    :    out    std_logic;
        pcsgen3currentcoeff    :    out    std_logic_vector(17 downto 0);
        pcsgen3currentrxpreset    :    out    std_logic_vector(2 downto 0);
        pcsaggrefclkdig    :    out    std_logic;
        pcspcspmaifrefclkdig    :    out    std_logic;
        pcsaggscanmoden    :    out    std_logic;
        pcsaggscanshiftn    :    out    std_logic;
        pcspcspmaifscanmoden    :    out    std_logic;
        pcspcspmaifscanshiftn    :    out    std_logic;
        emsippcsclkout    :    out    std_logic_vector(2 downto 0);
        emsippcsstatus    :    out    std_logic_vector(13 downto 0);
        pldfref    :    out    std_logic;
        pldclklow    :    out    std_logic;
        emsipenabledusermode    :    out    std_logic;
        pldoffcalenout    :    out    std_logic;
        pldoffcaldone    :    out    std_logic;
        pldgen3masktxpll    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_common_pld_pcs_interface_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        data_source    =>   data_source,
        emsip_enable    =>   emsip_enable,
        selectpcs    =>   selectpcs
    )
    port  map  (
        pldhardresetin    =>    pldhardresetin,
        pldscanmoden    =>    pldscanmoden,
        pldscanshiftn    =>    pldscanshiftn,
        pldgen3refclkdig    =>    pldgen3refclkdig,
        pld10grefclkdig    =>    pld10grefclkdig,
        pld8grefclkdig    =>    pld8grefclkdig,
        pldaggrefclkdig    =>    pldaggrefclkdig,
        pldpcspmaifrefclkdig    =>    pldpcspmaifrefclkdig,
        pldrate    =>    pldrate,
        pldeidleinfersel    =>    pldeidleinfersel,
        pld8gsoftresetallhssi    =>    pld8gsoftresetallhssi,
        pld8gplniotri    =>    pld8gplniotri,
        pld8gprbsciden    =>    pld8gprbsciden,
        pld8gltr    =>    pld8gltr,
        pld8gtxelecidle    =>    pld8gtxelecidle,
        pld8gtxdetectrxloopback    =>    pld8gtxdetectrxloopback,
        pld8gtxdeemph    =>    pld8gtxdeemph,
        pld8gtxmargin    =>    pld8gtxmargin,
        pld8gtxswing    =>    pld8gtxswing,
        pld8grxpolarity    =>    pld8grxpolarity,
        pld8gpowerdown    =>    pld8gpowerdown,
        pldgen3currentcoeff    =>    pldgen3currentcoeff,
        pldgen3currentrxpreset    =>    pldgen3currentrxpreset,
        pcs10gtestdata    =>    pcs10gtestdata,
        pcs8gchnltestbusout    =>    pcs8gchnltestbusout,
        pcs8grxvalid    =>    pcs8grxvalid,
        pcs8grxelecidle    =>    pcs8grxelecidle,
        pcs8grxstatus    =>    pcs8grxstatus,
        pcs8gphystatus    =>    pcs8gphystatus,
        pldhclkin    =>    pldhclkin,
        pcsgen3pldasyncstatus    =>    pcsgen3pldasyncstatus,
        pcsgen3testout    =>    pcsgen3testout,
        emsippcsreset    =>    emsippcsreset,
        emsippcsctrl    =>    emsippcsctrl,
        pmafref    =>    pmafref,
        pmaclklow    =>    pmaclklow,
        pmaoffcaldone    =>    pmaoffcaldone,
        pldoffcalenin    =>    pldoffcalenin,
        pcsgen3masktxpll    =>    pcsgen3masktxpll,
        rcomemsip    =>    rcomemsip,
        rcomhipena    =>    rcomhipena,
        rcomblocksel    =>    rcomblocksel,
        pldtestdata    =>    pldtestdata,
        pld8grxvalid    =>    pld8grxvalid,
        pld8grxelecidle    =>    pld8grxelecidle,
        pld8grxstatus    =>    pld8grxstatus,
        pld8gphystatus    =>    pld8gphystatus,
        pldgen3pldasyncstatus    =>    pldgen3pldasyncstatus,
        pcs10ghardresetn    =>    pcs10ghardresetn,
        pcs10gscanmoden    =>    pcs10gscanmoden,
        pcs10gscanshiftn    =>    pcs10gscanshiftn,
        pcs10grefclkdig    =>    pcs10grefclkdig,
        pcs8ghardreset    =>    pcs8ghardreset,
        pcs8gsoftresetallhssi    =>    pcs8gsoftresetallhssi,
        pcs8gplniotri    =>    pcs8gplniotri,
        pcs8gscanmoden    =>    pcs8gscanmoden,
        pcs8gscanshiftn    =>    pcs8gscanshiftn,
        pcs8grefclkdig    =>    pcs8grefclkdig,
        pcs8gprbsciden    =>    pcs8gprbsciden,
        pcs8gltr    =>    pcs8gltr,
        pcs8gtxelecidle    =>    pcs8gtxelecidle,
        pcs8gtxdetectrxloopback    =>    pcs8gtxdetectrxloopback,
        pcs8gtxdeemph    =>    pcs8gtxdeemph,
        pcs8gtxmargin    =>    pcs8gtxmargin,
        pcs8gtxswing    =>    pcs8gtxswing,
        pcs8grxpolarity    =>    pcs8grxpolarity,
        pcs8grate    =>    pcs8grate,
        pcs8gpowerdown    =>    pcs8gpowerdown,
        pcs8geidleinfersel    =>    pcs8geidleinfersel,
        pcsgen3pcsdigclk    =>    pcsgen3pcsdigclk,
        pcsgen3rate    =>    pcsgen3rate,
        pcsgen3eidleinfersel    =>    pcsgen3eidleinfersel,
        pcsgen3scanmoden    =>    pcsgen3scanmoden,
        pcsgen3scanshiftn    =>    pcsgen3scanshiftn,
        pcsgen3pldltr    =>    pcsgen3pldltr,
        pldhardresetout    =>    pldhardresetout,
        pcsgen3currentcoeff    =>    pcsgen3currentcoeff,
        pcsgen3currentrxpreset    =>    pcsgen3currentrxpreset,
        pcsaggrefclkdig    =>    pcsaggrefclkdig,
        pcspcspmaifrefclkdig    =>    pcspcspmaifrefclkdig,
        pcsaggscanmoden    =>    pcsaggscanmoden,
        pcsaggscanshiftn    =>    pcsaggscanshiftn,
        pcspcspmaifscanmoden    =>    pcspcspmaifscanmoden,
        pcspcspmaifscanshiftn    =>    pcspcspmaifscanshiftn,
        emsippcsclkout    =>    emsippcsclkout,
        emsippcsstatus    =>    emsippcsstatus,
        pldfref    =>    pldfref,
        pldclklow    =>    pldclklow,
        emsipenabledusermode    =>    emsipenabledusermode,
        pldoffcalenout    =>    pldoffcalenout,
        pldoffcaldone    =>    pldoffcaldone,
        pldgen3masktxpll    =>    pldgen3masktxpll
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_rx_pcs_pma_interface    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_rx_pcs_pma_interface";
        clkslip_sel    :    string    :=    "pld";
        prot_mode    :    string    :=    "other_protocols";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        clockinfrompma    :    in    std_logic;
        datainfrompma    :    in    std_logic_vector(39 downto 0);
        pmasigdet    :    in    std_logic;
        pmasignalok    :    in    std_logic;
        pcs10grxclkiqout    :    in    std_logic;
        pcsgen3rxclkiqout    :    in    std_logic;
        pcs8grxclkiqout    :    in    std_logic;
        pcs8grxclkslip    :    in    std_logic;
        pmaclkdiv33txorrxin    :    in    std_logic;
        pmarxplllockin    :    in    std_logic;
        pldrxpmarstb    :    in    std_logic;
        pldrxclkslip    :    in    std_logic;
        rrxblocksel    :    in    std_logic_vector(1 downto 0);
        rrxclkslipsel    :    in    std_logic;
        pmarxclkslip    :    out    std_logic;
        pmarxclkout    :    out    std_logic;
        clkoutto10gpcs    :    out    std_logic;
        dataoutto10gpcs    :    out    std_logic_vector(39 downto 0);
        pcs10gsignalok    :    out    std_logic;
        clockouttogen3pcs    :    out    std_logic;
        dataouttogen3pcs    :    out    std_logic_vector(31 downto 0);
        pcsgen3pmasignaldet    :    out    std_logic;
        clockoutto8gpcs    :    out    std_logic;
        dataoutto8gpcs    :    out    std_logic_vector(19 downto 0);
        pcs8gsigdetni    :    out    std_logic;
        pmaclkdiv33txorrxout    :    out    std_logic;
        pcs10gclkdiv33txorrx    :    out    std_logic;
        pmarxpmarstb    :    out    std_logic;
        pmarxplllockout    :    out    std_logic
    );
end stratixv_hssi_rx_pcs_pma_interface;

architecture behavior of stratixv_hssi_rx_pcs_pma_interface is

component    stratixv_hssi_rx_pcs_pma_interface_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_rx_pcs_pma_interface";
        clkslip_sel    :    string    :=    "pld";
        prot_mode    :    string    :=    "other_protocols";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        clockinfrompma    :    in    std_logic;
        datainfrompma    :    in    std_logic_vector(39 downto 0);
        pmasigdet    :    in    std_logic;
        pmasignalok    :    in    std_logic;
        pcs10grxclkiqout    :    in    std_logic;
        pcsgen3rxclkiqout    :    in    std_logic;
        pcs8grxclkiqout    :    in    std_logic;
        pcs8grxclkslip    :    in    std_logic;
        pmaclkdiv33txorrxin    :    in    std_logic;
        pmarxplllockin    :    in    std_logic;
        pldrxpmarstb    :    in    std_logic;
        pldrxclkslip    :    in    std_logic;
        rrxblocksel    :    in    std_logic_vector(1 downto 0);
        rrxclkslipsel    :    in    std_logic;
        pmarxclkslip    :    out    std_logic;
        pmarxclkout    :    out    std_logic;
        clkoutto10gpcs    :    out    std_logic;
        dataoutto10gpcs    :    out    std_logic_vector(39 downto 0);
        pcs10gsignalok    :    out    std_logic;
        clockouttogen3pcs    :    out    std_logic;
        dataouttogen3pcs    :    out    std_logic_vector(31 downto 0);
        pcsgen3pmasignaldet    :    out    std_logic;
        clockoutto8gpcs    :    out    std_logic;
        dataoutto8gpcs    :    out    std_logic_vector(19 downto 0);
        pcs8gsigdetni    :    out    std_logic;
        pmaclkdiv33txorrxout    :    out    std_logic;
        pcs10gclkdiv33txorrx    :    out    std_logic;
        pmarxpmarstb    :    out    std_logic;
        pmarxplllockout    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_rx_pcs_pma_interface_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        clkslip_sel    =>   clkslip_sel,
        prot_mode    =>   prot_mode,
        selectpcs    =>   selectpcs
    )
    port  map  (
        clockinfrompma    =>    clockinfrompma,
        datainfrompma    =>    datainfrompma,
        pmasigdet    =>    pmasigdet,
        pmasignalok    =>    pmasignalok,
        pcs10grxclkiqout    =>    pcs10grxclkiqout,
        pcsgen3rxclkiqout    =>    pcsgen3rxclkiqout,
        pcs8grxclkiqout    =>    pcs8grxclkiqout,
        pcs8grxclkslip    =>    pcs8grxclkslip,
        pmaclkdiv33txorrxin    =>    pmaclkdiv33txorrxin,
        pmarxplllockin    =>    pmarxplllockin,
        pldrxpmarstb    =>    pldrxpmarstb,
        pldrxclkslip    =>    pldrxclkslip,
        rrxblocksel    =>    rrxblocksel,
        rrxclkslipsel    =>    rrxclkslipsel,
        pmarxclkslip    =>    pmarxclkslip,
        pmarxclkout    =>    pmarxclkout,
        clkoutto10gpcs    =>    clkoutto10gpcs,
        dataoutto10gpcs    =>    dataoutto10gpcs,
        pcs10gsignalok    =>    pcs10gsignalok,
        clockouttogen3pcs    =>    clockouttogen3pcs,
        dataouttogen3pcs    =>    dataouttogen3pcs,
        pcsgen3pmasignaldet    =>    pcsgen3pmasignaldet,
        clockoutto8gpcs    =>    clockoutto8gpcs,
        dataoutto8gpcs    =>    dataoutto8gpcs,
        pcs8gsigdetni    =>    pcs8gsigdetni,
        pmaclkdiv33txorrxout    =>    pmaclkdiv33txorrxout,
        pcs10gclkdiv33txorrx    =>    pcs10gclkdiv33txorrx,
        pmarxpmarstb    =>    pmarxpmarstb,
        pmarxplllockout    =>    pmarxplllockout
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_rx_pld_pcs_interface    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_rx_pld_pcs_interface";
        data_source    :    string    :=    "pld";
        is_10g_0ppm    :    string    :=    "false";
        is_8g_0ppm    :    string    :=    "false";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        pld10grxpldclk    :    in    std_logic;
        pld10grxpldrstn    :    in    std_logic;
        pld10grxalignen    :    in    std_logic;
        pld10grxalignclr    :    in    std_logic;
        pld10grxrden    :    in    std_logic;
        pld10grxdispclr    :    in    std_logic;
        pld10grxclrerrblkcnt    :    in    std_logic;
        pld10grxclrbercount    :    in    std_logic;
        pld10grxprbserrclr    :    in    std_logic;
        pld10grxbitslip    :    in    std_logic;
        pld8grxurstpma    :    in    std_logic;
        pld8grxurstpcs    :    in    std_logic;
        pld8gcmpfifourst    :    in    std_logic;
        pld8gphfifourstrx    :    in    std_logic;
        pld8gencdt    :    in    std_logic;
        pld8ga1a2size    :    in    std_logic;
        pld8gbitslip    :    in    std_logic;
        pld8grdenablermf    :    in    std_logic;
        pld8gwrenablermf    :    in    std_logic;
        pld8gpldrxclk    :    in    std_logic;
        pld8gpolinvrx    :    in    std_logic;
        pld8gbitlocreven    :    in    std_logic;
        pld8gbytereven    :    in    std_logic;
        pld8gbytordpld    :    in    std_logic;
        pld8gwrdisablerx    :    in    std_logic;
        pld8grdenablerx    :    in    std_logic;
        pldgen3rxrstn    :    in    std_logic;
        pldrxclkslipin    :    in    std_logic;
        pld8gpldextrain    :    in    std_logic_vector(3 downto 0);
        clockinfrom10gpcs    :    in    std_logic;
        pcs10grxdatavalid    :    in    std_logic;
        datainfrom10gpcs    :    in    std_logic_vector(63 downto 0);
        pcs10grxcontrol    :    in    std_logic_vector(9 downto 0);
        pcs10grxempty    :    in    std_logic;
        pcs10grxpempty    :    in    std_logic;
        pcs10grxpfull    :    in    std_logic;
        pcs10grxoflwerr    :    in    std_logic;
        pcs10grxalignval    :    in    std_logic;
        pcs10grxblklock    :    in    std_logic;
        pcs10grxhiber    :    in    std_logic;
        pcs10grxframelock    :    in    std_logic;
        pcs10grxrdpossts    :    in    std_logic;
        pcs10grxrdnegsts    :    in    std_logic;
        pcs10grxskipins    :    in    std_logic;
        pcs10grxrxframe    :    in    std_logic;
        pcs10grxpyldins    :    in    std_logic;
        pcs10grxsyncerr    :    in    std_logic;
        pcs10grxscrmerr    :    in    std_logic;
        pcs10grxskiperr    :    in    std_logic;
        pcs10grxdiagerr    :    in    std_logic;
        pcs10grxsherr    :    in    std_logic;
        pcs10grxmfrmerr    :    in    std_logic;
        pcs10grxcrc32err    :    in    std_logic;
        pcs10grxdiagstatus    :    in    std_logic_vector(1 downto 0);
        datainfrom8gpcs    :    in    std_logic_vector(63 downto 0);
        clockinfrom8gpcs    :    in    std_logic;
        pcs8gbisterr    :    in    std_logic;
        pcs8grcvdclkpmab    :    in    std_logic;
        pcs8gsignaldetectout    :    in    std_logic;
        pcs8gbistdone    :    in    std_logic;
        pcs8grlvlt    :    in    std_logic;
        pcs8gfullrmf    :    in    std_logic;
        pcs8gemptyrmf    :    in    std_logic;
        pcs8gfullrx    :    in    std_logic;
        pcs8gemptyrx    :    in    std_logic;
        pcs8ga1a2k1k2flag    :    in    std_logic_vector(3 downto 0);
        pcs8gbyteordflag    :    in    std_logic;
        pcs8gwaboundary    :    in    std_logic_vector(4 downto 0);
        pcs8grxdatavalid    :    in    std_logic_vector(3 downto 0);
        pcs8grxsynchdr    :    in    std_logic_vector(1 downto 0);
        pcs8grxblkstart    :    in    std_logic_vector(3 downto 0);
        pmaclkdiv33txorrx    :    in    std_logic;
        emsippcsrxclkin    :    in    std_logic_vector(2 downto 0);
        emsippcsrxreset    :    in    std_logic_vector(6 downto 0);
        emsippcsrxctrl    :    in    std_logic_vector(24 downto 0);
        pmarxplllock    :    in    std_logic;
        pldrxpmarstbin    :    in    std_logic;
        rrxblocksel    :    in    std_logic_vector(1 downto 0);
        rrxemsip    :    in    std_logic;
        emsipenabledusermode    :    in    std_logic;
        pcs10grxfifoinsert    :    in    std_logic;
        pld8gsyncsmeninput    :    in    std_logic;
        pcs10grxfifodel    :    in    std_logic;
        dataouttopld    :    out    std_logic_vector(63 downto 0);
        pld10grxclkout    :    out    std_logic;
        pld10grxdatavalid    :    out    std_logic;
        pld10grxcontrol    :    out    std_logic_vector(9 downto 0);
        pld10grxempty    :    out    std_logic;
        pld10grxpempty    :    out    std_logic;
        pld10grxpfull    :    out    std_logic;
        pld10grxoflwerr    :    out    std_logic;
        pld10grxalignval    :    out    std_logic;
        pld10grxblklock    :    out    std_logic;
        pld10grxhiber    :    out    std_logic;
        pld10grxframelock    :    out    std_logic;
        pld10grxrdpossts    :    out    std_logic;
        pld10grxrdnegsts    :    out    std_logic;
        pld10grxskipins    :    out    std_logic;
        pld10grxrxframe    :    out    std_logic;
        pld10grxpyldins    :    out    std_logic;
        pld10grxsyncerr    :    out    std_logic;
        pld10grxscrmerr    :    out    std_logic;
        pld10grxskiperr    :    out    std_logic;
        pld10grxdiagerr    :    out    std_logic;
        pld10grxsherr    :    out    std_logic;
        pld10grxmfrmerr    :    out    std_logic;
        pld10grxcrc32err    :    out    std_logic;
        pld10grxdiagstatus    :    out    std_logic_vector(1 downto 0);
        pld8grxclkout    :    out    std_logic;
        pld8gbisterr    :    out    std_logic;
        pld8grcvdclkpmab    :    out    std_logic;
        pld8gsignaldetectout    :    out    std_logic;
        pld8gbistdone    :    out    std_logic;
        pld8grlvlt    :    out    std_logic;
        pld8gfullrmf    :    out    std_logic;
        pld8gemptyrmf    :    out    std_logic;
        pld8gfullrx    :    out    std_logic;
        pld8gemptyrx    :    out    std_logic;
        pld8ga1a2k1k2flag    :    out    std_logic_vector(3 downto 0);
        pld8gbyteordflag    :    out    std_logic;
        pld8gwaboundary    :    out    std_logic_vector(4 downto 0);
        pld8grxdatavalid    :    out    std_logic_vector(3 downto 0);
        pld8grxsynchdr    :    out    std_logic_vector(1 downto 0);
        pld8grxblkstart    :    out    std_logic_vector(3 downto 0);
        pcs10grxpldclk    :    out    std_logic;
        pcs10grxpldrstn    :    out    std_logic;
        pcs10grxalignen    :    out    std_logic;
        pcs10grxalignclr    :    out    std_logic;
        pcs10grxrden    :    out    std_logic;
        pcs10grxdispclr    :    out    std_logic;
        pcs10grxclrerrblkcnt    :    out    std_logic;
        pcs10grxclrbercount    :    out    std_logic;
        pcs10grxprbserrclr    :    out    std_logic;
        pcs10grxbitslip    :    out    std_logic;
        pcs8grxurstpma    :    out    std_logic;
        pcs8grxurstpcs    :    out    std_logic;
        pcs8gcmpfifourst    :    out    std_logic;
        pcs8gphfifourstrx    :    out    std_logic;
        pcs8gencdt    :    out    std_logic;
        pcs8ga1a2size    :    out    std_logic;
        pcs8gbitslip    :    out    std_logic;
        pcs8grdenablermf    :    out    std_logic;
        pcs8gwrenablermf    :    out    std_logic;
        pcs8gpldrxclk    :    out    std_logic;
        pcs8gpolinvrx    :    out    std_logic;
        pcs8gbitlocreven    :    out    std_logic;
        pcs8gbytereven    :    out    std_logic;
        pcs8gbytordpld    :    out    std_logic;
        pcs8gwrdisablerx    :    out    std_logic;
        pcs8grdenablerx    :    out    std_logic;
        pcs8gpldextrain    :    out    std_logic_vector(3 downto 0);
        pcsgen3rxrstn    :    out    std_logic;
        pldrxclkslipout    :    out    std_logic;
        pldclkdiv33txorrx    :    out    std_logic;
        emsiprxdata    :    out    std_logic_vector(63 downto 0);
        emsippcsrxclkout    :    out    std_logic_vector(3 downto 0);
        emsippcsrxstatus    :    out    std_logic_vector(63 downto 0);
        pldrxpmarstbout    :    out    std_logic;
        pldrxplllock    :    out    std_logic;
        pld10grxfifodel    :    out    std_logic;
        pldrxiqclkout    :    out    std_logic;
        pld10grxfifoinsert    :    out    std_logic;
        pcs8gsyncsmenoutput    :    out    std_logic
    );
end stratixv_hssi_rx_pld_pcs_interface;

architecture behavior of stratixv_hssi_rx_pld_pcs_interface is

component    stratixv_hssi_rx_pld_pcs_interface_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_rx_pld_pcs_interface";
        data_source    :    string    :=    "pld";
        is_10g_0ppm    :    string    :=    "false";
        is_8g_0ppm    :    string    :=    "false";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        pld10grxpldclk    :    in    std_logic;
        pld10grxpldrstn    :    in    std_logic;
        pld10grxalignen    :    in    std_logic;
        pld10grxalignclr    :    in    std_logic;
        pld10grxrden    :    in    std_logic;
        pld10grxdispclr    :    in    std_logic;
        pld10grxclrerrblkcnt    :    in    std_logic;
        pld10grxclrbercount    :    in    std_logic;
        pld10grxprbserrclr    :    in    std_logic;
        pld10grxbitslip    :    in    std_logic;
        pld8grxurstpma    :    in    std_logic;
        pld8grxurstpcs    :    in    std_logic;
        pld8gcmpfifourst    :    in    std_logic;
        pld8gphfifourstrx    :    in    std_logic;
        pld8gencdt    :    in    std_logic;
        pld8ga1a2size    :    in    std_logic;
        pld8gbitslip    :    in    std_logic;
        pld8grdenablermf    :    in    std_logic;
        pld8gwrenablermf    :    in    std_logic;
        pld8gpldrxclk    :    in    std_logic;
        pld8gpolinvrx    :    in    std_logic;
        pld8gbitlocreven    :    in    std_logic;
        pld8gbytereven    :    in    std_logic;
        pld8gbytordpld    :    in    std_logic;
        pld8gwrdisablerx    :    in    std_logic;
        pld8grdenablerx    :    in    std_logic;
        pldgen3rxrstn    :    in    std_logic;
        pldrxclkslipin    :    in    std_logic;
        pld8gpldextrain    :    in    std_logic_vector(3 downto 0);
        clockinfrom10gpcs    :    in    std_logic;
        pcs10grxdatavalid    :    in    std_logic;
        datainfrom10gpcs    :    in    std_logic_vector(63 downto 0);
        pcs10grxcontrol    :    in    std_logic_vector(9 downto 0);
        pcs10grxempty    :    in    std_logic;
        pcs10grxpempty    :    in    std_logic;
        pcs10grxpfull    :    in    std_logic;
        pcs10grxoflwerr    :    in    std_logic;
        pcs10grxalignval    :    in    std_logic;
        pcs10grxblklock    :    in    std_logic;
        pcs10grxhiber    :    in    std_logic;
        pcs10grxframelock    :    in    std_logic;
        pcs10grxrdpossts    :    in    std_logic;
        pcs10grxrdnegsts    :    in    std_logic;
        pcs10grxskipins    :    in    std_logic;
        pcs10grxrxframe    :    in    std_logic;
        pcs10grxpyldins    :    in    std_logic;
        pcs10grxsyncerr    :    in    std_logic;
        pcs10grxscrmerr    :    in    std_logic;
        pcs10grxskiperr    :    in    std_logic;
        pcs10grxdiagerr    :    in    std_logic;
        pcs10grxsherr    :    in    std_logic;
        pcs10grxmfrmerr    :    in    std_logic;
        pcs10grxcrc32err    :    in    std_logic;
        pcs10grxdiagstatus    :    in    std_logic_vector(1 downto 0);
        datainfrom8gpcs    :    in    std_logic_vector(63 downto 0);
        clockinfrom8gpcs    :    in    std_logic;
        pcs8gbisterr    :    in    std_logic;
        pcs8grcvdclkpmab    :    in    std_logic;
        pcs8gsignaldetectout    :    in    std_logic;
        pcs8gbistdone    :    in    std_logic;
        pcs8grlvlt    :    in    std_logic;
        pcs8gfullrmf    :    in    std_logic;
        pcs8gemptyrmf    :    in    std_logic;
        pcs8gfullrx    :    in    std_logic;
        pcs8gemptyrx    :    in    std_logic;
        pcs8ga1a2k1k2flag    :    in    std_logic_vector(3 downto 0);
        pcs8gbyteordflag    :    in    std_logic;
        pcs8gwaboundary    :    in    std_logic_vector(4 downto 0);
        pcs8grxdatavalid    :    in    std_logic_vector(3 downto 0);
        pcs8grxsynchdr    :    in    std_logic_vector(1 downto 0);
        pcs8grxblkstart    :    in    std_logic_vector(3 downto 0);
        pmaclkdiv33txorrx    :    in    std_logic;
        emsippcsrxclkin    :    in    std_logic_vector(2 downto 0);
        emsippcsrxreset    :    in    std_logic_vector(6 downto 0);
        emsippcsrxctrl    :    in    std_logic_vector(24 downto 0);
        pmarxplllock    :    in    std_logic;
        pldrxpmarstbin    :    in    std_logic;
        rrxblocksel    :    in    std_logic_vector(1 downto 0);
        rrxemsip    :    in    std_logic;
        emsipenabledusermode    :    in    std_logic;
        pcs10grxfifoinsert    :    in    std_logic;
        pld8gsyncsmeninput    :    in    std_logic;
        pcs10grxfifodel    :    in    std_logic;
        dataouttopld    :    out    std_logic_vector(63 downto 0);
        pld10grxclkout    :    out    std_logic;
        pld10grxdatavalid    :    out    std_logic;
        pld10grxcontrol    :    out    std_logic_vector(9 downto 0);
        pld10grxempty    :    out    std_logic;
        pld10grxpempty    :    out    std_logic;
        pld10grxpfull    :    out    std_logic;
        pld10grxoflwerr    :    out    std_logic;
        pld10grxalignval    :    out    std_logic;
        pld10grxblklock    :    out    std_logic;
        pld10grxhiber    :    out    std_logic;
        pld10grxframelock    :    out    std_logic;
        pld10grxrdpossts    :    out    std_logic;
        pld10grxrdnegsts    :    out    std_logic;
        pld10grxskipins    :    out    std_logic;
        pld10grxrxframe    :    out    std_logic;
        pld10grxpyldins    :    out    std_logic;
        pld10grxsyncerr    :    out    std_logic;
        pld10grxscrmerr    :    out    std_logic;
        pld10grxskiperr    :    out    std_logic;
        pld10grxdiagerr    :    out    std_logic;
        pld10grxsherr    :    out    std_logic;
        pld10grxmfrmerr    :    out    std_logic;
        pld10grxcrc32err    :    out    std_logic;
        pld10grxdiagstatus    :    out    std_logic_vector(1 downto 0);
        pld8grxclkout    :    out    std_logic;
        pld8gbisterr    :    out    std_logic;
        pld8grcvdclkpmab    :    out    std_logic;
        pld8gsignaldetectout    :    out    std_logic;
        pld8gbistdone    :    out    std_logic;
        pld8grlvlt    :    out    std_logic;
        pld8gfullrmf    :    out    std_logic;
        pld8gemptyrmf    :    out    std_logic;
        pld8gfullrx    :    out    std_logic;
        pld8gemptyrx    :    out    std_logic;
        pld8ga1a2k1k2flag    :    out    std_logic_vector(3 downto 0);
        pld8gbyteordflag    :    out    std_logic;
        pld8gwaboundary    :    out    std_logic_vector(4 downto 0);
        pld8grxdatavalid    :    out    std_logic_vector(3 downto 0);
        pld8grxsynchdr    :    out    std_logic_vector(1 downto 0);
        pld8grxblkstart    :    out    std_logic_vector(3 downto 0);
        pcs10grxpldclk    :    out    std_logic;
        pcs10grxpldrstn    :    out    std_logic;
        pcs10grxalignen    :    out    std_logic;
        pcs10grxalignclr    :    out    std_logic;
        pcs10grxrden    :    out    std_logic;
        pcs10grxdispclr    :    out    std_logic;
        pcs10grxclrerrblkcnt    :    out    std_logic;
        pcs10grxclrbercount    :    out    std_logic;
        pcs10grxprbserrclr    :    out    std_logic;
        pcs10grxbitslip    :    out    std_logic;
        pcs8grxurstpma    :    out    std_logic;
        pcs8grxurstpcs    :    out    std_logic;
        pcs8gcmpfifourst    :    out    std_logic;
        pcs8gphfifourstrx    :    out    std_logic;
        pcs8gencdt    :    out    std_logic;
        pcs8ga1a2size    :    out    std_logic;
        pcs8gbitslip    :    out    std_logic;
        pcs8grdenablermf    :    out    std_logic;
        pcs8gwrenablermf    :    out    std_logic;
        pcs8gpldrxclk    :    out    std_logic;
        pcs8gpolinvrx    :    out    std_logic;
        pcs8gbitlocreven    :    out    std_logic;
        pcs8gbytereven    :    out    std_logic;
        pcs8gbytordpld    :    out    std_logic;
        pcs8gwrdisablerx    :    out    std_logic;
        pcs8grdenablerx    :    out    std_logic;
        pcs8gpldextrain    :    out    std_logic_vector(3 downto 0);
        pcsgen3rxrstn    :    out    std_logic;
        pldrxclkslipout    :    out    std_logic;
        pldclkdiv33txorrx    :    out    std_logic;
        emsiprxdata    :    out    std_logic_vector(63 downto 0);
        emsippcsrxclkout    :    out    std_logic_vector(3 downto 0);
        emsippcsrxstatus    :    out    std_logic_vector(63 downto 0);
        pldrxpmarstbout    :    out    std_logic;
        pldrxplllock    :    out    std_logic;
        pld10grxfifodel    :    out    std_logic;
        pldrxiqclkout    :    out    std_logic;
        pld10grxfifoinsert    :    out    std_logic;
        pcs8gsyncsmenoutput    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_rx_pld_pcs_interface_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        data_source    =>   data_source,
        is_10g_0ppm    =>   is_10g_0ppm,
        is_8g_0ppm    =>   is_8g_0ppm,
        selectpcs    =>   selectpcs
    )
    port  map  (
        pld10grxpldclk    =>    pld10grxpldclk,
        pld10grxpldrstn    =>    pld10grxpldrstn,
        pld10grxalignen    =>    pld10grxalignen,
        pld10grxalignclr    =>    pld10grxalignclr,
        pld10grxrden    =>    pld10grxrden,
        pld10grxdispclr    =>    pld10grxdispclr,
        pld10grxclrerrblkcnt    =>    pld10grxclrerrblkcnt,
        pld10grxclrbercount    =>    pld10grxclrbercount,
        pld10grxprbserrclr    =>    pld10grxprbserrclr,
        pld10grxbitslip    =>    pld10grxbitslip,
        pld8grxurstpma    =>    pld8grxurstpma,
        pld8grxurstpcs    =>    pld8grxurstpcs,
        pld8gcmpfifourst    =>    pld8gcmpfifourst,
        pld8gphfifourstrx    =>    pld8gphfifourstrx,
        pld8gencdt    =>    pld8gencdt,
        pld8ga1a2size    =>    pld8ga1a2size,
        pld8gbitslip    =>    pld8gbitslip,
        pld8grdenablermf    =>    pld8grdenablermf,
        pld8gwrenablermf    =>    pld8gwrenablermf,
        pld8gpldrxclk    =>    pld8gpldrxclk,
        pld8gpolinvrx    =>    pld8gpolinvrx,
        pld8gbitlocreven    =>    pld8gbitlocreven,
        pld8gbytereven    =>    pld8gbytereven,
        pld8gbytordpld    =>    pld8gbytordpld,
        pld8gwrdisablerx    =>    pld8gwrdisablerx,
        pld8grdenablerx    =>    pld8grdenablerx,
        pldgen3rxrstn    =>    pldgen3rxrstn,
        pldrxclkslipin    =>    pldrxclkslipin,
        pld8gpldextrain    =>    pld8gpldextrain,
        clockinfrom10gpcs    =>    clockinfrom10gpcs,
        pcs10grxdatavalid    =>    pcs10grxdatavalid,
        datainfrom10gpcs    =>    datainfrom10gpcs,
        pcs10grxcontrol    =>    pcs10grxcontrol,
        pcs10grxempty    =>    pcs10grxempty,
        pcs10grxpempty    =>    pcs10grxpempty,
        pcs10grxpfull    =>    pcs10grxpfull,
        pcs10grxoflwerr    =>    pcs10grxoflwerr,
        pcs10grxalignval    =>    pcs10grxalignval,
        pcs10grxblklock    =>    pcs10grxblklock,
        pcs10grxhiber    =>    pcs10grxhiber,
        pcs10grxframelock    =>    pcs10grxframelock,
        pcs10grxrdpossts    =>    pcs10grxrdpossts,
        pcs10grxrdnegsts    =>    pcs10grxrdnegsts,
        pcs10grxskipins    =>    pcs10grxskipins,
        pcs10grxrxframe    =>    pcs10grxrxframe,
        pcs10grxpyldins    =>    pcs10grxpyldins,
        pcs10grxsyncerr    =>    pcs10grxsyncerr,
        pcs10grxscrmerr    =>    pcs10grxscrmerr,
        pcs10grxskiperr    =>    pcs10grxskiperr,
        pcs10grxdiagerr    =>    pcs10grxdiagerr,
        pcs10grxsherr    =>    pcs10grxsherr,
        pcs10grxmfrmerr    =>    pcs10grxmfrmerr,
        pcs10grxcrc32err    =>    pcs10grxcrc32err,
        pcs10grxdiagstatus    =>    pcs10grxdiagstatus,
        datainfrom8gpcs    =>    datainfrom8gpcs,
        clockinfrom8gpcs    =>    clockinfrom8gpcs,
        pcs8gbisterr    =>    pcs8gbisterr,
        pcs8grcvdclkpmab    =>    pcs8grcvdclkpmab,
        pcs8gsignaldetectout    =>    pcs8gsignaldetectout,
        pcs8gbistdone    =>    pcs8gbistdone,
        pcs8grlvlt    =>    pcs8grlvlt,
        pcs8gfullrmf    =>    pcs8gfullrmf,
        pcs8gemptyrmf    =>    pcs8gemptyrmf,
        pcs8gfullrx    =>    pcs8gfullrx,
        pcs8gemptyrx    =>    pcs8gemptyrx,
        pcs8ga1a2k1k2flag    =>    pcs8ga1a2k1k2flag,
        pcs8gbyteordflag    =>    pcs8gbyteordflag,
        pcs8gwaboundary    =>    pcs8gwaboundary,
        pcs8grxdatavalid    =>    pcs8grxdatavalid,
        pcs8grxsynchdr    =>    pcs8grxsynchdr,
        pcs8grxblkstart    =>    pcs8grxblkstart,
        pmaclkdiv33txorrx    =>    pmaclkdiv33txorrx,
        emsippcsrxclkin    =>    emsippcsrxclkin,
        emsippcsrxreset    =>    emsippcsrxreset,
        emsippcsrxctrl    =>    emsippcsrxctrl,
        pmarxplllock    =>    pmarxplllock,
        pldrxpmarstbin    =>    pldrxpmarstbin,
        rrxblocksel    =>    rrxblocksel,
        rrxemsip    =>    rrxemsip,
        emsipenabledusermode    =>    emsipenabledusermode,
        pcs10grxfifoinsert    =>    pcs10grxfifoinsert,
        pld8gsyncsmeninput    =>    pld8gsyncsmeninput,
        pcs10grxfifodel    =>    pcs10grxfifodel,
        dataouttopld    =>    dataouttopld,
        pld10grxclkout    =>    pld10grxclkout,
        pld10grxdatavalid    =>    pld10grxdatavalid,
        pld10grxcontrol    =>    pld10grxcontrol,
        pld10grxempty    =>    pld10grxempty,
        pld10grxpempty    =>    pld10grxpempty,
        pld10grxpfull    =>    pld10grxpfull,
        pld10grxoflwerr    =>    pld10grxoflwerr,
        pld10grxalignval    =>    pld10grxalignval,
        pld10grxblklock    =>    pld10grxblklock,
        pld10grxhiber    =>    pld10grxhiber,
        pld10grxframelock    =>    pld10grxframelock,
        pld10grxrdpossts    =>    pld10grxrdpossts,
        pld10grxrdnegsts    =>    pld10grxrdnegsts,
        pld10grxskipins    =>    pld10grxskipins,
        pld10grxrxframe    =>    pld10grxrxframe,
        pld10grxpyldins    =>    pld10grxpyldins,
        pld10grxsyncerr    =>    pld10grxsyncerr,
        pld10grxscrmerr    =>    pld10grxscrmerr,
        pld10grxskiperr    =>    pld10grxskiperr,
        pld10grxdiagerr    =>    pld10grxdiagerr,
        pld10grxsherr    =>    pld10grxsherr,
        pld10grxmfrmerr    =>    pld10grxmfrmerr,
        pld10grxcrc32err    =>    pld10grxcrc32err,
        pld10grxdiagstatus    =>    pld10grxdiagstatus,
        pld8grxclkout    =>    pld8grxclkout,
        pld8gbisterr    =>    pld8gbisterr,
        pld8grcvdclkpmab    =>    pld8grcvdclkpmab,
        pld8gsignaldetectout    =>    pld8gsignaldetectout,
        pld8gbistdone    =>    pld8gbistdone,
        pld8grlvlt    =>    pld8grlvlt,
        pld8gfullrmf    =>    pld8gfullrmf,
        pld8gemptyrmf    =>    pld8gemptyrmf,
        pld8gfullrx    =>    pld8gfullrx,
        pld8gemptyrx    =>    pld8gemptyrx,
        pld8ga1a2k1k2flag    =>    pld8ga1a2k1k2flag,
        pld8gbyteordflag    =>    pld8gbyteordflag,
        pld8gwaboundary    =>    pld8gwaboundary,
        pld8grxdatavalid    =>    pld8grxdatavalid,
        pld8grxsynchdr    =>    pld8grxsynchdr,
        pld8grxblkstart    =>    pld8grxblkstart,
        pcs10grxpldclk    =>    pcs10grxpldclk,
        pcs10grxpldrstn    =>    pcs10grxpldrstn,
        pcs10grxalignen    =>    pcs10grxalignen,
        pcs10grxalignclr    =>    pcs10grxalignclr,
        pcs10grxrden    =>    pcs10grxrden,
        pcs10grxdispclr    =>    pcs10grxdispclr,
        pcs10grxclrerrblkcnt    =>    pcs10grxclrerrblkcnt,
        pcs10grxclrbercount    =>    pcs10grxclrbercount,
        pcs10grxprbserrclr    =>    pcs10grxprbserrclr,
        pcs10grxbitslip    =>    pcs10grxbitslip,
        pcs8grxurstpma    =>    pcs8grxurstpma,
        pcs8grxurstpcs    =>    pcs8grxurstpcs,
        pcs8gcmpfifourst    =>    pcs8gcmpfifourst,
        pcs8gphfifourstrx    =>    pcs8gphfifourstrx,
        pcs8gencdt    =>    pcs8gencdt,
        pcs8ga1a2size    =>    pcs8ga1a2size,
        pcs8gbitslip    =>    pcs8gbitslip,
        pcs8grdenablermf    =>    pcs8grdenablermf,
        pcs8gwrenablermf    =>    pcs8gwrenablermf,
        pcs8gpldrxclk    =>    pcs8gpldrxclk,
        pcs8gpolinvrx    =>    pcs8gpolinvrx,
        pcs8gbitlocreven    =>    pcs8gbitlocreven,
        pcs8gbytereven    =>    pcs8gbytereven,
        pcs8gbytordpld    =>    pcs8gbytordpld,
        pcs8gwrdisablerx    =>    pcs8gwrdisablerx,
        pcs8grdenablerx    =>    pcs8grdenablerx,
        pcs8gpldextrain    =>    pcs8gpldextrain,
        pcsgen3rxrstn    =>    pcsgen3rxrstn,
        pldrxclkslipout    =>    pldrxclkslipout,
        pldclkdiv33txorrx    =>    pldclkdiv33txorrx,
        emsiprxdata    =>    emsiprxdata,
        emsippcsrxclkout    =>    emsippcsrxclkout,
        emsippcsrxstatus    =>    emsippcsrxstatus,
        pldrxpmarstbout    =>    pldrxpmarstbout,
        pldrxplllock    =>    pldrxplllock,
        pld10grxfifodel    =>    pld10grxfifodel,
        pldrxiqclkout    =>    pldrxiqclkout,
        pld10grxfifoinsert    =>    pld10grxfifoinsert,
        pcs8gsyncsmenoutput    =>    pcs8gsyncsmenoutput
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_tx_pcs_pma_interface    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_tx_pcs_pma_interface";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        clockinfrompma    :    in    std_logic;
        datainfrom10gpcs    :    in    std_logic_vector(39 downto 0);
        pcs10gtxclkiqout    :    in    std_logic;
        pcsgen3txclkiqout    :    in    std_logic;
        datainfromgen3pcs    :    in    std_logic_vector(31 downto 0);
        pcs8gtxclkiqout    :    in    std_logic;
        datainfrom8gpcs    :    in    std_logic_vector(19 downto 0);
        pmaclkdiv33lcin    :    in    std_logic;
        pmatxlcplllockin    :    in    std_logic;
        pmatxcmuplllockin    :    in    std_logic;
        rtxblocksel    :    in    std_logic_vector(1 downto 0);
        pcsgen3gen3datasel    :    in    std_logic;
        pldtxpmasyncp    :    in    std_logic;
        dataouttopma    :    out    std_logic_vector(39 downto 0);
        pmatxclkout    :    out    std_logic;
        clockoutto10gpcs    :    out    std_logic;
        clockoutto8gpcs    :    out    std_logic;
        pmaclkdiv33lcout    :    out    std_logic;
        pcs10gclkdiv33lc    :    out    std_logic;
        pmatxlcplllockout    :    out    std_logic;
        pmatxcmuplllockout    :    out    std_logic;
        pmatxpmasyncp    :    out    std_logic
    );
end stratixv_hssi_tx_pcs_pma_interface;

architecture behavior of stratixv_hssi_tx_pcs_pma_interface is

component    stratixv_hssi_tx_pcs_pma_interface_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_tx_pcs_pma_interface";
        selectpcs    :    string    :=    "eight_g_pcs"
    );
    port    (
        clockinfrompma    :    in    std_logic;
        datainfrom10gpcs    :    in    std_logic_vector(39 downto 0);
        pcs10gtxclkiqout    :    in    std_logic;
        pcsgen3txclkiqout    :    in    std_logic;
        datainfromgen3pcs    :    in    std_logic_vector(31 downto 0);
        pcs8gtxclkiqout    :    in    std_logic;
        datainfrom8gpcs    :    in    std_logic_vector(19 downto 0);
        pmaclkdiv33lcin    :    in    std_logic;
        pmatxlcplllockin    :    in    std_logic;
        pmatxcmuplllockin    :    in    std_logic;
        rtxblocksel    :    in    std_logic_vector(1 downto 0);
        pcsgen3gen3datasel    :    in    std_logic;
        pldtxpmasyncp    :    in    std_logic;
        dataouttopma    :    out    std_logic_vector(39 downto 0);
        pmatxclkout    :    out    std_logic;
        clockoutto10gpcs    :    out    std_logic;
        clockoutto8gpcs    :    out    std_logic;
        pmaclkdiv33lcout    :    out    std_logic;
        pcs10gclkdiv33lc    :    out    std_logic;
        pmatxlcplllockout    :    out    std_logic;
        pmatxcmuplllockout    :    out    std_logic;
        pmatxpmasyncp    :    out    std_logic
    );
end component;

begin


inst : stratixv_hssi_tx_pcs_pma_interface_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        selectpcs    =>   selectpcs
    )
    port  map  (
        clockinfrompma    =>    clockinfrompma,
        datainfrom10gpcs    =>    datainfrom10gpcs,
        pcs10gtxclkiqout    =>    pcs10gtxclkiqout,
        pcsgen3txclkiqout    =>    pcsgen3txclkiqout,
        datainfromgen3pcs    =>    datainfromgen3pcs,
        pcs8gtxclkiqout    =>    pcs8gtxclkiqout,
        datainfrom8gpcs    =>    datainfrom8gpcs,
        pmaclkdiv33lcin    =>    pmaclkdiv33lcin,
        pmatxlcplllockin    =>    pmatxlcplllockin,
        pmatxcmuplllockin    =>    pmatxcmuplllockin,
        rtxblocksel    =>    rtxblocksel,
        pcsgen3gen3datasel    =>    pcsgen3gen3datasel,
        pldtxpmasyncp    =>    pldtxpmasyncp,
        dataouttopma    =>    dataouttopma,
        pmatxclkout    =>    pmatxclkout,
        clockoutto10gpcs    =>    clockoutto10gpcs,
        clockoutto8gpcs    =>    clockoutto8gpcs,
        pmaclkdiv33lcout    =>    pmaclkdiv33lcout,
        pcs10gclkdiv33lc    =>    pcs10gclkdiv33lc,
        pmatxlcplllockout    =>    pmatxlcplllockout,
        pmatxcmuplllockout    =>    pmatxcmuplllockout,
        pmatxpmasyncp    =>    pmatxpmasyncp
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_tx_pld_pcs_interface    is
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_tx_pld_pcs_interface";
        data_source    :    string    :=    "pld";
        is_10g_0ppm    :    string    :=    "false";
        is_8g_0ppm    :    string    :=    "false"
    );
    port    (
        datainfrompld    :    in    std_logic_vector(63 downto 0);
        pld10gtxpldclk    :    in    std_logic;
        pld10gtxpldrstn    :    in    std_logic;
        pld10gtxdatavalid    :    in    std_logic;
        pld10gtxcontrol    :    in    std_logic_vector(8 downto 0);
        pld10gtxbitslip    :    in    std_logic_vector(6 downto 0);
        pld10gtxdiagstatus    :    in    std_logic_vector(1 downto 0);
        pld10gtxwordslip    :    in    std_logic;
        pld10gtxbursten    :    in    std_logic;
        pld8gpldtxclk    :    in    std_logic;
        pld8gpolinvtx    :    in    std_logic;
        pld8grevloopbk    :    in    std_logic;
        pld8gwrenabletx    :    in    std_logic;
        pld8grddisabletx    :    in    std_logic;
        pld8gphfifoursttx    :    in    std_logic;
        pld8gtxboundarysel    :    in    std_logic_vector(4 downto 0);
        pld8gtxdatavalid    :    in    std_logic_vector(3 downto 0);
        pld8gtxsynchdr    :    in    std_logic_vector(1 downto 0);
        pld8gtxblkstart    :    in    std_logic_vector(3 downto 0);
        pldgen3txrstn    :    in    std_logic;
        pld8gtxurstpcs    :    in    std_logic;
        clockinfrom10gpcs    :    in    std_logic;
        pcs10gtxempty    :    in    std_logic;
        pcs10gtxpempty    :    in    std_logic;
        pcs10gtxpfull    :    in    std_logic;
        pcs10gtxfull    :    in    std_logic;
        pcs10gtxframe    :    in    std_logic;
        pcs10gtxburstenexe    :    in    std_logic;
        pcs10gtxwordslipexe    :    in    std_logic;
        pcs8gfulltx    :    in    std_logic;
        pcs8gemptytx    :    in    std_logic;
        clockinfrom8gpcs    :    in    std_logic;
        pmaclkdiv33lc    :    in    std_logic;
        emsiptxdata    :    in    std_logic_vector(63 downto 0);
        emsippcstxclkin    :    in    std_logic_vector(2 downto 0);
        emsippcstxreset    :    in    std_logic_vector(5 downto 0);
        emsippcstxctrl    :    in    std_logic_vector(43 downto 0);
        pmatxlcplllock    :    in    std_logic;
        pmatxcmuplllock    :    in    std_logic;
        pldtxpmarstbin    :    in    std_logic;
        pldlccmurstbin    :    in    std_logic;
        rtxemsip    :    in    std_logic;
        emsipenabledusermode    :    in    std_logic;
        pcs10gextraout    :    in    std_logic_vector(3 downto 0);
        pldtxpmasyncpin    :    in    std_logic;
        pcs10gtxfifoinsert    :    in    std_logic;
        pcs10gtxfifodel    :    in    std_logic;
        pld10gextrain    :    in    std_logic_vector(3 downto 0);
        pld10gtxclkout    :    out    std_logic;
        pld10gtxempty    :    out    std_logic;
        pld10gtxpempty    :    out    std_logic;
        pld10gtxpfull    :    out    std_logic;
        pld10gtxfull    :    out    std_logic;
        pld10gtxframe    :    out    std_logic;
        pld10gtxburstenexe    :    out    std_logic;
        pld10gtxwordslipexe    :    out    std_logic;
        pld8gfulltx    :    out    std_logic;
        pld8gemptytx    :    out    std_logic;
        pld8gtxclkout    :    out    std_logic;
        pcs10gtxpldclk    :    out    std_logic;
        pcs10gtxpldrstn    :    out    std_logic;
        pcs10gtxdatavalid    :    out    std_logic;
        dataoutto10gpcs    :    out    std_logic_vector(63 downto 0);
        pcs10gtxcontrol    :    out    std_logic_vector(8 downto 0);
        pcs10gtxbitslip    :    out    std_logic_vector(6 downto 0);
        pcs10gtxdiagstatus    :    out    std_logic_vector(1 downto 0);
        pcs10gtxwordslip    :    out    std_logic;
        pcs10gtxbursten    :    out    std_logic;
        pcs8gtxurstpcs    :    out    std_logic;
        dataoutto8gpcs    :    out    std_logic_vector(43 downto 0);
        pcs8gpldtxclk    :    out    std_logic;
        pcs8gpolinvtx    :    out    std_logic;
        pcs8grevloopbk    :    out    std_logic;
        pcs8gwrenabletx    :    out    std_logic;
        pcs8grddisabletx    :    out    std_logic;
        pcs8gphfifoursttx    :    out    std_logic;
        pcs8gtxboundarysel    :    out    std_logic_vector(4 downto 0);
        pcs8gtxdatavalid    :    out    std_logic_vector(3 downto 0);
        pcs8gtxsynchdr    :    out    std_logic_vector(1 downto 0);
        pcs8gtxblkstart    :    out    std_logic_vector(3 downto 0);
        pcsgen3txrstn    :    out    std_logic;
        pldclkdiv33lc    :    out    std_logic;
        emsippcstxclkout    :    out    std_logic_vector(2 downto 0);
        emsippcstxstatus    :    out    std_logic_vector(16 downto 0);
        pldtxpmarstbout    :    out    std_logic;
        pldlccmurstbout    :    out    std_logic;
        pldtxlcplllock    :    out    std_logic;
        pldtxcmuplllock    :    out    std_logic;
        pldtxiqclkout    :    out    std_logic;
        pcs10gextrain    :    out    std_logic_vector(3 downto 0);
        pld10gtxfifodel    :    out    std_logic;
        pldtxpmasyncpout    :    out    std_logic;
        pld10gtxfifoinsert    :    out    std_logic;
        pld10gextraout    :    out    std_logic_vector(3 downto 0)
    );
end stratixv_hssi_tx_pld_pcs_interface;

architecture behavior of stratixv_hssi_tx_pld_pcs_interface is

component    stratixv_hssi_tx_pld_pcs_interface_encrypted
    generic    (
        lpm_type    :    string    :=    "stratixv_hssi_tx_pld_pcs_interface";
        data_source    :    string    :=    "pld";
        is_10g_0ppm    :    string    :=    "false";
        is_8g_0ppm    :    string    :=    "false"
    );
    port    (
        datainfrompld    :    in    std_logic_vector(63 downto 0);
        pld10gtxpldclk    :    in    std_logic;
        pld10gtxpldrstn    :    in    std_logic;
        pld10gtxdatavalid    :    in    std_logic;
        pld10gtxcontrol    :    in    std_logic_vector(8 downto 0);
        pld10gtxbitslip    :    in    std_logic_vector(6 downto 0);
        pld10gtxdiagstatus    :    in    std_logic_vector(1 downto 0);
        pld10gtxwordslip    :    in    std_logic;
        pld10gtxbursten    :    in    std_logic;
        pld8gpldtxclk    :    in    std_logic;
        pld8gpolinvtx    :    in    std_logic;
        pld8grevloopbk    :    in    std_logic;
        pld8gwrenabletx    :    in    std_logic;
        pld8grddisabletx    :    in    std_logic;
        pld8gphfifoursttx    :    in    std_logic;
        pld8gtxboundarysel    :    in    std_logic_vector(4 downto 0);
        pld8gtxdatavalid    :    in    std_logic_vector(3 downto 0);
        pld8gtxsynchdr    :    in    std_logic_vector(1 downto 0);
        pld8gtxblkstart    :    in    std_logic_vector(3 downto 0);
        pldgen3txrstn    :    in    std_logic;
        pld8gtxurstpcs    :    in    std_logic;
        clockinfrom10gpcs    :    in    std_logic;
        pcs10gtxempty    :    in    std_logic;
        pcs10gtxpempty    :    in    std_logic;
        pcs10gtxpfull    :    in    std_logic;
        pcs10gtxfull    :    in    std_logic;
        pcs10gtxframe    :    in    std_logic;
        pcs10gtxburstenexe    :    in    std_logic;
        pcs10gtxwordslipexe    :    in    std_logic;
        pcs8gfulltx    :    in    std_logic;
        pcs8gemptytx    :    in    std_logic;
        clockinfrom8gpcs    :    in    std_logic;
        pmaclkdiv33lc    :    in    std_logic;
        emsiptxdata    :    in    std_logic_vector(63 downto 0);
        emsippcstxclkin    :    in    std_logic_vector(2 downto 0);
        emsippcstxreset    :    in    std_logic_vector(5 downto 0);
        emsippcstxctrl    :    in    std_logic_vector(43 downto 0);
        pmatxlcplllock    :    in    std_logic;
        pmatxcmuplllock    :    in    std_logic;
        pldtxpmarstbin    :    in    std_logic;
        pldlccmurstbin    :    in    std_logic;
        rtxemsip    :    in    std_logic;
        emsipenabledusermode    :    in    std_logic;
        pcs10gextraout    :    in    std_logic_vector(3 downto 0);
        pldtxpmasyncpin    :    in    std_logic;
        pcs10gtxfifoinsert    :    in    std_logic;
        pcs10gtxfifodel    :    in    std_logic;
        pld10gextrain    :    in    std_logic_vector(3 downto 0);
        pld10gtxclkout    :    out    std_logic;
        pld10gtxempty    :    out    std_logic;
        pld10gtxpempty    :    out    std_logic;
        pld10gtxpfull    :    out    std_logic;
        pld10gtxfull    :    out    std_logic;
        pld10gtxframe    :    out    std_logic;
        pld10gtxburstenexe    :    out    std_logic;
        pld10gtxwordslipexe    :    out    std_logic;
        pld8gfulltx    :    out    std_logic;
        pld8gemptytx    :    out    std_logic;
        pld8gtxclkout    :    out    std_logic;
        pcs10gtxpldclk    :    out    std_logic;
        pcs10gtxpldrstn    :    out    std_logic;
        pcs10gtxdatavalid    :    out    std_logic;
        dataoutto10gpcs    :    out    std_logic_vector(63 downto 0);
        pcs10gtxcontrol    :    out    std_logic_vector(8 downto 0);
        pcs10gtxbitslip    :    out    std_logic_vector(6 downto 0);
        pcs10gtxdiagstatus    :    out    std_logic_vector(1 downto 0);
        pcs10gtxwordslip    :    out    std_logic;
        pcs10gtxbursten    :    out    std_logic;
        pcs8gtxurstpcs    :    out    std_logic;
        dataoutto8gpcs    :    out    std_logic_vector(43 downto 0);
        pcs8gpldtxclk    :    out    std_logic;
        pcs8gpolinvtx    :    out    std_logic;
        pcs8grevloopbk    :    out    std_logic;
        pcs8gwrenabletx    :    out    std_logic;
        pcs8grddisabletx    :    out    std_logic;
        pcs8gphfifoursttx    :    out    std_logic;
        pcs8gtxboundarysel    :    out    std_logic_vector(4 downto 0);
        pcs8gtxdatavalid    :    out    std_logic_vector(3 downto 0);
        pcs8gtxsynchdr    :    out    std_logic_vector(1 downto 0);
        pcs8gtxblkstart    :    out    std_logic_vector(3 downto 0);
        pcsgen3txrstn    :    out    std_logic;
        pldclkdiv33lc    :    out    std_logic;
        emsippcstxclkout    :    out    std_logic_vector(2 downto 0);
        emsippcstxstatus    :    out    std_logic_vector(16 downto 0);
        pldtxpmarstbout    :    out    std_logic;
        pldlccmurstbout    :    out    std_logic;
        pldtxlcplllock    :    out    std_logic;
        pldtxcmuplllock    :    out    std_logic;
        pldtxiqclkout    :    out    std_logic;
        pcs10gextrain    :    out    std_logic_vector(3 downto 0);
        pld10gtxfifodel    :    out    std_logic;
        pldtxpmasyncpout    :    out    std_logic;
        pld10gtxfifoinsert    :    out    std_logic;
        pld10gextraout    :    out    std_logic_vector(3 downto 0)
    );
end component;

begin


inst : stratixv_hssi_tx_pld_pcs_interface_encrypted
    generic  map  (
        lpm_type    =>   lpm_type,
        data_source    =>   data_source,
        is_10g_0ppm    =>   is_10g_0ppm,
        is_8g_0ppm    =>   is_8g_0ppm
    )
    port  map  (
        datainfrompld    =>    datainfrompld,
        pld10gtxpldclk    =>    pld10gtxpldclk,
        pld10gtxpldrstn    =>    pld10gtxpldrstn,
        pld10gtxdatavalid    =>    pld10gtxdatavalid,
        pld10gtxcontrol    =>    pld10gtxcontrol,
        pld10gtxbitslip    =>    pld10gtxbitslip,
        pld10gtxdiagstatus    =>    pld10gtxdiagstatus,
        pld10gtxwordslip    =>    pld10gtxwordslip,
        pld10gtxbursten    =>    pld10gtxbursten,
        pld8gpldtxclk    =>    pld8gpldtxclk,
        pld8gpolinvtx    =>    pld8gpolinvtx,
        pld8grevloopbk    =>    pld8grevloopbk,
        pld8gwrenabletx    =>    pld8gwrenabletx,
        pld8grddisabletx    =>    pld8grddisabletx,
        pld8gphfifoursttx    =>    pld8gphfifoursttx,
        pld8gtxboundarysel    =>    pld8gtxboundarysel,
        pld8gtxdatavalid    =>    pld8gtxdatavalid,
        pld8gtxsynchdr    =>    pld8gtxsynchdr,
        pld8gtxblkstart    =>    pld8gtxblkstart,
        pldgen3txrstn    =>    pldgen3txrstn,
        pld8gtxurstpcs    =>    pld8gtxurstpcs,
        clockinfrom10gpcs    =>    clockinfrom10gpcs,
        pcs10gtxempty    =>    pcs10gtxempty,
        pcs10gtxpempty    =>    pcs10gtxpempty,
        pcs10gtxpfull    =>    pcs10gtxpfull,
        pcs10gtxfull    =>    pcs10gtxfull,
        pcs10gtxframe    =>    pcs10gtxframe,
        pcs10gtxburstenexe    =>    pcs10gtxburstenexe,
        pcs10gtxwordslipexe    =>    pcs10gtxwordslipexe,
        pcs8gfulltx    =>    pcs8gfulltx,
        pcs8gemptytx    =>    pcs8gemptytx,
        clockinfrom8gpcs    =>    clockinfrom8gpcs,
        pmaclkdiv33lc    =>    pmaclkdiv33lc,
        emsiptxdata    =>    emsiptxdata,
        emsippcstxclkin    =>    emsippcstxclkin,
        emsippcstxreset    =>    emsippcstxreset,
        emsippcstxctrl    =>    emsippcstxctrl,
        pmatxlcplllock    =>    pmatxlcplllock,
        pmatxcmuplllock    =>    pmatxcmuplllock,
        pldtxpmarstbin    =>    pldtxpmarstbin,
        pldlccmurstbin    =>    pldlccmurstbin,
        rtxemsip    =>    rtxemsip,
        emsipenabledusermode    =>    emsipenabledusermode,
        pcs10gextraout    =>    pcs10gextraout,
        pldtxpmasyncpin    =>    pldtxpmasyncpin,
        pcs10gtxfifoinsert    =>    pcs10gtxfifoinsert,
        pcs10gtxfifodel    =>    pcs10gtxfifodel,
        pld10gextrain    =>    pld10gextrain,
        pld10gtxclkout    =>    pld10gtxclkout,
        pld10gtxempty    =>    pld10gtxempty,
        pld10gtxpempty    =>    pld10gtxpempty,
        pld10gtxpfull    =>    pld10gtxpfull,
        pld10gtxfull    =>    pld10gtxfull,
        pld10gtxframe    =>    pld10gtxframe,
        pld10gtxburstenexe    =>    pld10gtxburstenexe,
        pld10gtxwordslipexe    =>    pld10gtxwordslipexe,
        pld8gfulltx    =>    pld8gfulltx,
        pld8gemptytx    =>    pld8gemptytx,
        pld8gtxclkout    =>    pld8gtxclkout,
        pcs10gtxpldclk    =>    pcs10gtxpldclk,
        pcs10gtxpldrstn    =>    pcs10gtxpldrstn,
        pcs10gtxdatavalid    =>    pcs10gtxdatavalid,
        dataoutto10gpcs    =>    dataoutto10gpcs,
        pcs10gtxcontrol    =>    pcs10gtxcontrol,
        pcs10gtxbitslip    =>    pcs10gtxbitslip,
        pcs10gtxdiagstatus    =>    pcs10gtxdiagstatus,
        pcs10gtxwordslip    =>    pcs10gtxwordslip,
        pcs10gtxbursten    =>    pcs10gtxbursten,
        pcs8gtxurstpcs    =>    pcs8gtxurstpcs,
        dataoutto8gpcs    =>    dataoutto8gpcs,
        pcs8gpldtxclk    =>    pcs8gpldtxclk,
        pcs8gpolinvtx    =>    pcs8gpolinvtx,
        pcs8grevloopbk    =>    pcs8grevloopbk,
        pcs8gwrenabletx    =>    pcs8gwrenabletx,
        pcs8grddisabletx    =>    pcs8grddisabletx,
        pcs8gphfifoursttx    =>    pcs8gphfifoursttx,
        pcs8gtxboundarysel    =>    pcs8gtxboundarysel,
        pcs8gtxdatavalid    =>    pcs8gtxdatavalid,
        pcs8gtxsynchdr    =>    pcs8gtxsynchdr,
        pcs8gtxblkstart    =>    pcs8gtxblkstart,
        pcsgen3txrstn    =>    pcsgen3txrstn,
        pldclkdiv33lc    =>    pldclkdiv33lc,
        emsippcstxclkout    =>    emsippcstxclkout,
        emsippcstxstatus    =>    emsippcstxstatus,
        pldtxpmarstbout    =>    pldtxpmarstbout,
        pldlccmurstbout    =>    pldlccmurstbout,
        pldtxlcplllock    =>    pldtxlcplllock,
        pldtxcmuplllock    =>    pldtxcmuplllock,
        pldtxiqclkout    =>    pldtxiqclkout,
        pcs10gextrain    =>    pcs10gextrain,
        pld10gtxfifodel    =>    pld10gtxfifodel,
        pldtxpmasyncpout    =>    pldtxpmasyncpout,
        pld10gtxfifoinsert    =>    pld10gtxfifoinsert,
        pld10gextraout    =>    pld10gextraout
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_10g_rx_pcs    is
    generic    (
        prot_mode    :    string    :=    "disable_mode";
        sup_mode    :    string    :=    "full_mode";
        dis_signal_ok    :    string    :=    "dis_signal_ok_dis";
        gb_rx_idwidth    :    string    :=    "idwidth_32";
        gb_rx_odwidth    :    string    :=    "odwidth_66";
        bit_reverse    :    string    :=    "bit_reverse_dis";
        gb_sel_mode    :    string    :=    "internal";
        lpbk_mode    :    string    :=    "lpbk_dis";
        test_mode    :    string    :=    "test_off";
        blksync_bypass    :    string    :=    "blksync_bypass_dis";
        blksync_pipeln    :    string    :=    "blksync_pipeln_dis";
        blksync_knum_sh_cnt_prelock    :    string    :=    "int";
        blksync_knum_sh_cnt_postlock    :    string    :=    "int";
        blksync_enum_invalid_sh_cnt    :    string    :=    "int";
        blksync_bitslip_wait_cnt    :    string    :=    "int";
        bitslip_wait_cnt_user    :    string    :=    "int";
        blksync_bitslip_type    :    string    :=    "bitslip_comb";
        blksync_bitslip_wait_type    :    string    :=    "bitslip_match";
        dispchk_bypass    :    string    :=    "dispchk_bypass_dis";
        dispchk_rd_level    :    string    :=    "dispchk_rd_level_min";
        dispchk_rd_level_user    :    string    :=    "int";
        dispchk_pipeln    :    string    :=    "dispchk_pipeln_dis";
        descrm_bypass    :    string    :=    "descrm_bypass_en";
        descrm_mode    :    string    :=    "async";
        frmsync_bypass    :    string    :=    "frmsync_bypass_dis";
        frmsync_pipeln    :    string    :=    "frmsync_pipeln_dis";
        frmsync_mfrm_length    :    string    :=    "int";
        frmsync_mfrm_length_user    :    string    :=    "int";
        frmsync_knum_sync    :    string    :=    "int";
        frmsync_enum_sync    :    string    :=    "int";
        frmsync_enum_scrm    :    string    :=    "int";
        frmsync_flag_type    :    string    :=    "all_framing_words";
        dec_64b66b_10g_mode    :    string    :=    "dec_64b66b_10g_mode_en";
        dec_64b66b_rxsm_bypass    :    string    :=    "dec_64b66b_rxsm_bypass_dis";
        rx_sm_bypass    :    string    :=    "rx_sm_bypass_dis";
        rx_sm_pipeln    :    string    :=    "rx_sm_pipeln_dis";
        rx_sm_hiber    :    string    :=    "rx_sm_hiber_en";
        ber_xus_timer_window    :    string    :=    "int";
        ber_bit_err_total_cnt    :    string    :=    "int";
        crcchk_bypass    :    string    :=    "crcchk_bypass_dis";
        crcchk_pipeln    :    string    :=    "crcchk_pipeln_dis";
        crcflag_pipeln    :    string    :=    "crcflag_pipeln_dis";
        crcchk_init    :    string    :=    "crcchk_init_user_setting";
        crcchk_init_user    :    bit_vector    :=    B"11111111111111111111111111111111";
        crcchk_inv    :    string    :=    "crcchk_inv_dis";
        force_align    :    string    :=    "force_align_dis";
        align_del    :    string    :=    "align_del_en";
        control_del    :    bit_vector    :=    B"11110000";
        rxfifo_mode    :    string    :=    "phase_comp";
        master_clk_sel    :    string    :=    "master_rx_pma_clk";
        rd_clk_sel    :    string    :=    "rd_rx_pma_clk";
        gbexp_clken    :    string    :=    "gbexp_clk_dis";
        prbs_clken    :    string    :=    "prbs_clk_dis";
        blksync_clken    :    string    :=    "blksync_clk_dis";
        dispchk_clken    :    string    :=    "dispchk_clk_dis";
        descrm_clken    :    string    :=    "descrm_clk_dis";
        frmsync_clken    :    string    :=    "frmsync_clk_dis";
        dec64b66b_clken    :    string    :=    "dec64b66b_clk_dis";
        ber_clken    :    string    :=    "ber_clk_dis";
        rand_clken    :    string    :=    "rand_clk_dis";
        crcchk_clken    :    string    :=    "crcchk_clk_dis";
        wrfifo_clken    :    string    :=    "wrfifo_clk_dis";
        rdfifo_clken    :    string    :=    "rdfifo_clk_dis";
        rxfifo_pempty    :    string    :=    "pempty_default";
        rxfifo_pfull    :    string    :=    "pfull_default";
        rxfifo_full    :    string    :=    "full_default";
        rxfifo_empty    :    string    :=    "pempty_default";
        bitslip_mode    :    string    :=    "bitslip_dis";
        fast_path    :    string    :=    "fast_path_dis";
        stretch_num_stages    :    string    :=    "zero_stage";
        stretch_en    :    string    :=    "stretch_en";
        iqtxrx_clkout_sel    :    string    :=    "iq_rx_clk_out";
        channel_number    :    integer    :=    0;
        frmgen_diag_word    :    bit_vector    :=    B"0000000000000000011001000000000000000000000000000000000000000000";
        frmgen_scrm_word    :    bit_vector    :=    B"0000000000000000001010000000000000000000000000000000000000000000";
        frmgen_skip_word    :    bit_vector    :=    B"0000000000000000000111100001111000011110000111100001111000011110";
        frmgen_sync_word    :    bit_vector    :=    B"0000000000000000011110001111011001111000111101100111100011110110";
        test_bus_mode    :    string    :=    "tx"
    );
    port    (
        bercount    :    out    std_logic_vector(5 downto 0);
        errorblockcount    :    out    std_logic_vector(7 downto 0);
        pcsstatus    :    out    std_logic_vector(0 downto 0);
        randomerrorcount    :    out    std_logic_vector(15 downto 0);
        prbserrorlatch    :    out    std_logic_vector(0 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        rxpmaclk    :    in    std_logic_vector(0 downto 0);
        pmaclkdiv33txorrx    :    in    std_logic_vector(0 downto 0);
        rxpmadatavalid    :    in    std_logic_vector(0 downto 0);
        hardresetn    :    in    std_logic_vector(0 downto 0);
        rxpldclk    :    in    std_logic_vector(0 downto 0);
        rxpldrstn    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        rxalignen    :    in    std_logic_vector(0 downto 0);
        rxalignclr    :    in    std_logic_vector(0 downto 0);
        rxrden    :    in    std_logic_vector(0 downto 0);
        rxdisparityclr    :    in    std_logic_vector(0 downto 0);
        rxclrerrorblockcount    :    in    std_logic_vector(0 downto 0);
        rxclrbercount    :    in    std_logic_vector(0 downto 0);
        rxbitslip    :    in    std_logic_vector(0 downto 0);
        rxprbserrorclr    :    in    std_logic_vector(0 downto 0);
        rxclkout    :    out    std_logic_vector(0 downto 0);
        rxclkiqout    :    out    std_logic_vector(0 downto 0);
        rxdatavalid    :    out    std_logic_vector(0 downto 0);
        rxfifoempty    :    out    std_logic_vector(0 downto 0);
        rxfifopartialempty    :    out    std_logic_vector(0 downto 0);
        rxfifopartialfull    :    out    std_logic_vector(0 downto 0);
        rxfifofull    :    out    std_logic_vector(0 downto 0);
        rxalignval    :    out    std_logic_vector(0 downto 0);
        rxblocklock    :    out    std_logic_vector(0 downto 0);
        rxsyncheadererror    :    out    std_logic_vector(0 downto 0);
        rxhighber    :    out    std_logic_vector(0 downto 0);
        rxframelock    :    out    std_logic_vector(0 downto 0);
        rxrdpossts    :    out    std_logic_vector(0 downto 0);
        rxrdnegsts    :    out    std_logic_vector(0 downto 0);
        rxskipinserted    :    out    std_logic_vector(0 downto 0);
        rxrxframe    :    out    std_logic_vector(0 downto 0);
        rxpayloadinserted    :    out    std_logic_vector(0 downto 0);
        rxsyncworderror    :    out    std_logic_vector(0 downto 0);
        rxscramblererror    :    out    std_logic_vector(0 downto 0);
        rxskipworderror    :    out    std_logic_vector(0 downto 0);
        rxdiagnosticerror    :    out    std_logic_vector(0 downto 0);
        rxmetaframeerror    :    out    std_logic_vector(0 downto 0);
        rxcrc32error    :    out    std_logic_vector(0 downto 0);
        rxdiagnosticstatus    :    out    std_logic_vector(1 downto 0);
        rxdata    :    out    std_logic_vector(63 downto 0);
        rxcontrol    :    out    std_logic_vector(9 downto 0);
        accumdisparity    :    out    std_logic_vector(8 downto 0);
        loopbackdatain    :    in    std_logic_vector(39 downto 0);
        rxpmadata    :    in    std_logic_vector(39 downto 0);
        rxtestdata    :    out    std_logic_vector(19 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_10g_rx_pcs;

architecture behavior of stratixv_hssi_10g_rx_pcs is

component    stratixv_hssi_10g_rx_pcs_encrypted
    generic    (
        prot_mode    :    string    :=    "disable_mode";
        sup_mode    :    string    :=    "full_mode";
        dis_signal_ok    :    string    :=    "dis_signal_ok_dis";
        gb_rx_idwidth    :    string    :=    "idwidth_32";
        gb_rx_odwidth    :    string    :=    "odwidth_66";
        bit_reverse    :    string    :=    "bit_reverse_dis";
        gb_sel_mode    :    string    :=    "internal";
        lpbk_mode    :    string    :=    "lpbk_dis";
        test_mode    :    string    :=    "test_off";
        blksync_bypass    :    string    :=    "blksync_bypass_dis";
        blksync_pipeln    :    string    :=    "blksync_pipeln_dis";
        blksync_knum_sh_cnt_prelock    :    string    :=    "int";
        blksync_knum_sh_cnt_postlock    :    string    :=    "int";
        blksync_enum_invalid_sh_cnt    :    string    :=    "int";
        blksync_bitslip_wait_cnt    :    string    :=    "int";
        bitslip_wait_cnt_user    :    string    :=    "int";
        blksync_bitslip_type    :    string    :=    "bitslip_comb";
        blksync_bitslip_wait_type    :    string    :=    "bitslip_match";
        dispchk_bypass    :    string    :=    "dispchk_bypass_dis";
        dispchk_rd_level    :    string    :=    "dispchk_rd_level_min";
        dispchk_rd_level_user    :    string    :=    "int";
        dispchk_pipeln    :    string    :=    "dispchk_pipeln_dis";
        descrm_bypass    :    string    :=    "descrm_bypass_en";
        descrm_mode    :    string    :=    "async";
        frmsync_bypass    :    string    :=    "frmsync_bypass_dis";
        frmsync_pipeln    :    string    :=    "frmsync_pipeln_dis";
        frmsync_mfrm_length    :    string    :=    "int";
        frmsync_mfrm_length_user    :    string    :=    "int";
        frmsync_knum_sync    :    string    :=    "int";
        frmsync_enum_sync    :    string    :=    "int";
        frmsync_enum_scrm    :    string    :=    "int";
        frmsync_flag_type    :    string    :=    "all_framing_words";
        dec_64b66b_10g_mode    :    string    :=    "dec_64b66b_10g_mode_en";
        dec_64b66b_rxsm_bypass    :    string    :=    "dec_64b66b_rxsm_bypass_dis";
        rx_sm_bypass    :    string    :=    "rx_sm_bypass_dis";
        rx_sm_pipeln    :    string    :=    "rx_sm_pipeln_dis";
        rx_sm_hiber    :    string    :=    "rx_sm_hiber_en";
        ber_xus_timer_window    :    string    :=    "int";
        ber_bit_err_total_cnt    :    string    :=    "int";
        crcchk_bypass    :    string    :=    "crcchk_bypass_dis";
        crcchk_pipeln    :    string    :=    "crcchk_pipeln_dis";
        crcflag_pipeln    :    string    :=    "crcflag_pipeln_dis";
        crcchk_init    :    string    :=    "crcchk_init_user_setting";
        crcchk_init_user    :    bit_vector    :=    B"11111111111111111111111111111111";
        crcchk_inv    :    string    :=    "crcchk_inv_dis";
        force_align    :    string    :=    "force_align_dis";
        align_del    :    string    :=    "align_del_en";
        control_del    :    bit_vector    :=    B"11110000";
        rxfifo_mode    :    string    :=    "phase_comp";
        master_clk_sel    :    string    :=    "master_rx_pma_clk";
        rd_clk_sel    :    string    :=    "rd_rx_pma_clk";
        gbexp_clken    :    string    :=    "gbexp_clk_dis";
        prbs_clken    :    string    :=    "prbs_clk_dis";
        blksync_clken    :    string    :=    "blksync_clk_dis";
        dispchk_clken    :    string    :=    "dispchk_clk_dis";
        descrm_clken    :    string    :=    "descrm_clk_dis";
        frmsync_clken    :    string    :=    "frmsync_clk_dis";
        dec64b66b_clken    :    string    :=    "dec64b66b_clk_dis";
        ber_clken    :    string    :=    "ber_clk_dis";
        rand_clken    :    string    :=    "rand_clk_dis";
        crcchk_clken    :    string    :=    "crcchk_clk_dis";
        wrfifo_clken    :    string    :=    "wrfifo_clk_dis";
        rdfifo_clken    :    string    :=    "rdfifo_clk_dis";
        rxfifo_pempty    :    string    :=    "pempty_default";
        rxfifo_pfull    :    string    :=    "pfull_default";
        rxfifo_full    :    string    :=    "full_default";
        rxfifo_empty    :    string    :=    "pempty_default";
        bitslip_mode    :    string    :=    "bitslip_dis";
        fast_path    :    string    :=    "fast_path_dis";
        stretch_num_stages    :    string    :=    "zero_stage";
        stretch_en    :    string    :=    "stretch_en";
        iqtxrx_clkout_sel    :    string    :=    "iq_rx_clk_out";
        channel_number    :    integer    :=    0;
        frmgen_diag_word    :    bit_vector    :=    B"0000000000000000011001000000000000000000000000000000000000000000";
        frmgen_scrm_word    :    bit_vector    :=    B"0000000000000000001010000000000000000000000000000000000000000000";
        frmgen_skip_word    :    bit_vector    :=    B"0000000000000000000111100001111000011110000111100001111000011110";
        frmgen_sync_word    :    bit_vector    :=    B"0000000000000000011110001111011001111000111101100111100011110110";
        test_bus_mode    :    string    :=    "tx"
    );
    port    (
        bercount    :    out    std_logic_vector(5 downto 0);
        errorblockcount    :    out    std_logic_vector(7 downto 0);
        pcsstatus    :    out    std_logic_vector(0 downto 0);
        randomerrorcount    :    out    std_logic_vector(15 downto 0);
        prbserrorlatch    :    out    std_logic_vector(0 downto 0);
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        rxpmaclk    :    in    std_logic_vector(0 downto 0);
        pmaclkdiv33txorrx    :    in    std_logic_vector(0 downto 0);
        rxpmadatavalid    :    in    std_logic_vector(0 downto 0);
        hardresetn    :    in    std_logic_vector(0 downto 0);
        rxpldclk    :    in    std_logic_vector(0 downto 0);
        rxpldrstn    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        rxalignen    :    in    std_logic_vector(0 downto 0);
        rxalignclr    :    in    std_logic_vector(0 downto 0);
        rxrden    :    in    std_logic_vector(0 downto 0);
        rxdisparityclr    :    in    std_logic_vector(0 downto 0);
        rxclrerrorblockcount    :    in    std_logic_vector(0 downto 0);
        rxclrbercount    :    in    std_logic_vector(0 downto 0);
        rxbitslip    :    in    std_logic_vector(0 downto 0);
        rxprbserrorclr    :    in    std_logic_vector(0 downto 0);
        rxclkout    :    out    std_logic_vector(0 downto 0);
        rxclkiqout    :    out    std_logic_vector(0 downto 0);
        rxdatavalid    :    out    std_logic_vector(0 downto 0);
        rxfifoempty    :    out    std_logic_vector(0 downto 0);
        rxfifopartialempty    :    out    std_logic_vector(0 downto 0);
        rxfifopartialfull    :    out    std_logic_vector(0 downto 0);
        rxfifofull    :    out    std_logic_vector(0 downto 0);
        rxalignval    :    out    std_logic_vector(0 downto 0);
        rxblocklock    :    out    std_logic_vector(0 downto 0);
        rxsyncheadererror    :    out    std_logic_vector(0 downto 0);
        rxhighber    :    out    std_logic_vector(0 downto 0);
        rxframelock    :    out    std_logic_vector(0 downto 0);
        rxrdpossts    :    out    std_logic_vector(0 downto 0);
        rxrdnegsts    :    out    std_logic_vector(0 downto 0);
        rxskipinserted    :    out    std_logic_vector(0 downto 0);
        rxrxframe    :    out    std_logic_vector(0 downto 0);
        rxpayloadinserted    :    out    std_logic_vector(0 downto 0);
        rxsyncworderror    :    out    std_logic_vector(0 downto 0);
        rxscramblererror    :    out    std_logic_vector(0 downto 0);
        rxskipworderror    :    out    std_logic_vector(0 downto 0);
        rxdiagnosticerror    :    out    std_logic_vector(0 downto 0);
        rxmetaframeerror    :    out    std_logic_vector(0 downto 0);
        rxcrc32error    :    out    std_logic_vector(0 downto 0);
        rxdiagnosticstatus    :    out    std_logic_vector(1 downto 0);
        rxdata    :    out    std_logic_vector(63 downto 0);
        rxcontrol    :    out    std_logic_vector(9 downto 0);
        accumdisparity    :    out    std_logic_vector(8 downto 0);
        loopbackdatain    :    in    std_logic_vector(39 downto 0);
        rxpmadata    :    in    std_logic_vector(39 downto 0);
        rxtestdata    :    out    std_logic_vector(19 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_10g_rx_pcs_encrypted
    generic  map  (
        prot_mode    =>   prot_mode,
        sup_mode    =>   sup_mode,
        dis_signal_ok    =>   dis_signal_ok,
        gb_rx_idwidth    =>   gb_rx_idwidth,
        gb_rx_odwidth    =>   gb_rx_odwidth,
        bit_reverse    =>   bit_reverse,
        gb_sel_mode    =>   gb_sel_mode,
        lpbk_mode    =>   lpbk_mode,
        test_mode    =>   test_mode,
        blksync_bypass    =>   blksync_bypass,
        blksync_pipeln    =>   blksync_pipeln,
        blksync_knum_sh_cnt_prelock    =>   blksync_knum_sh_cnt_prelock,
        blksync_knum_sh_cnt_postlock    =>   blksync_knum_sh_cnt_postlock,
        blksync_enum_invalid_sh_cnt    =>   blksync_enum_invalid_sh_cnt,
        blksync_bitslip_wait_cnt    =>   blksync_bitslip_wait_cnt,
        bitslip_wait_cnt_user    =>   bitslip_wait_cnt_user,
        blksync_bitslip_type    =>   blksync_bitslip_type,
        blksync_bitslip_wait_type    =>   blksync_bitslip_wait_type,
        dispchk_bypass    =>   dispchk_bypass,
        dispchk_rd_level    =>   dispchk_rd_level,
        dispchk_rd_level_user    =>   dispchk_rd_level_user,
        dispchk_pipeln    =>   dispchk_pipeln,
        descrm_bypass    =>   descrm_bypass,
        descrm_mode    =>   descrm_mode,
        frmsync_bypass    =>   frmsync_bypass,
        frmsync_pipeln    =>   frmsync_pipeln,
        frmsync_mfrm_length    =>   frmsync_mfrm_length,
        frmsync_mfrm_length_user    =>   frmsync_mfrm_length_user,
        frmsync_knum_sync    =>   frmsync_knum_sync,
        frmsync_enum_sync    =>   frmsync_enum_sync,
        frmsync_enum_scrm    =>   frmsync_enum_scrm,
        frmsync_flag_type    =>   frmsync_flag_type,
        dec_64b66b_10g_mode    =>   dec_64b66b_10g_mode,
        dec_64b66b_rxsm_bypass    =>   dec_64b66b_rxsm_bypass,
        rx_sm_bypass    =>   rx_sm_bypass,
        rx_sm_pipeln    =>   rx_sm_pipeln,
        rx_sm_hiber    =>   rx_sm_hiber,
        ber_xus_timer_window    =>   ber_xus_timer_window,
        ber_bit_err_total_cnt    =>   ber_bit_err_total_cnt,
        crcchk_bypass    =>   crcchk_bypass,
        crcchk_pipeln    =>   crcchk_pipeln,
        crcflag_pipeln    =>   crcflag_pipeln,
        crcchk_init    =>   crcchk_init,
        crcchk_init_user    =>   crcchk_init_user,
        crcchk_inv    =>   crcchk_inv,
        force_align    =>   force_align,
        align_del    =>   align_del,
        control_del    =>   control_del,
        rxfifo_mode    =>   rxfifo_mode,
        master_clk_sel    =>   master_clk_sel,
        rd_clk_sel    =>   rd_clk_sel,
        gbexp_clken    =>   gbexp_clken,
        prbs_clken    =>   prbs_clken,
        blksync_clken    =>   blksync_clken,
        dispchk_clken    =>   dispchk_clken,
        descrm_clken    =>   descrm_clken,
        frmsync_clken    =>   frmsync_clken,
        dec64b66b_clken    =>   dec64b66b_clken,
        ber_clken    =>   ber_clken,
        rand_clken    =>   rand_clken,
        crcchk_clken    =>   crcchk_clken,
        wrfifo_clken    =>   wrfifo_clken,
        rdfifo_clken    =>   rdfifo_clken,
        rxfifo_pempty    =>   rxfifo_pempty,
        rxfifo_pfull    =>   rxfifo_pfull,
        rxfifo_full    =>   rxfifo_full,
        rxfifo_empty    =>   rxfifo_empty,
        bitslip_mode    =>   bitslip_mode,
        fast_path    =>   fast_path,
        stretch_num_stages    =>   stretch_num_stages,
        stretch_en    =>   stretch_en,
        iqtxrx_clkout_sel    =>   iqtxrx_clkout_sel,
        channel_number    =>   channel_number,
        frmgen_diag_word    =>   frmgen_diag_word,
        frmgen_scrm_word    =>   frmgen_scrm_word,
        frmgen_skip_word    =>   frmgen_skip_word,
        frmgen_sync_word    =>   frmgen_sync_word,
        test_bus_mode    =>   test_bus_mode
    )
    port  map  (
        bercount    =>    bercount,
        errorblockcount    =>    errorblockcount,
        pcsstatus    =>    pcsstatus,
        randomerrorcount    =>    randomerrorcount,
        prbserrorlatch    =>    prbserrorlatch,
        txpmaclk    =>    txpmaclk,
        rxpmaclk    =>    rxpmaclk,
        pmaclkdiv33txorrx    =>    pmaclkdiv33txorrx,
        rxpmadatavalid    =>    rxpmadatavalid,
        hardresetn    =>    hardresetn,
        rxpldclk    =>    rxpldclk,
        rxpldrstn    =>    rxpldrstn,
        refclkdig    =>    refclkdig,
        rxalignen    =>    rxalignen,
        rxalignclr    =>    rxalignclr,
        rxrden    =>    rxrden,
        rxdisparityclr    =>    rxdisparityclr,
        rxclrerrorblockcount    =>    rxclrerrorblockcount,
        rxclrbercount    =>    rxclrbercount,
        rxbitslip    =>    rxbitslip,
        rxprbserrorclr    =>    rxprbserrorclr,
        rxclkout    =>    rxclkout,
        rxclkiqout    =>    rxclkiqout,
        rxdatavalid    =>    rxdatavalid,
        rxfifoempty    =>    rxfifoempty,
        rxfifopartialempty    =>    rxfifopartialempty,
        rxfifopartialfull    =>    rxfifopartialfull,
        rxfifofull    =>    rxfifofull,
        rxalignval    =>    rxalignval,
        rxblocklock    =>    rxblocklock,
        rxsyncheadererror    =>    rxsyncheadererror,
        rxhighber    =>    rxhighber,
        rxframelock    =>    rxframelock,
        rxrdpossts    =>    rxrdpossts,
        rxrdnegsts    =>    rxrdnegsts,
        rxskipinserted    =>    rxskipinserted,
        rxrxframe    =>    rxrxframe,
        rxpayloadinserted    =>    rxpayloadinserted,
        rxsyncworderror    =>    rxsyncworderror,
        rxscramblererror    =>    rxscramblererror,
        rxskipworderror    =>    rxskipworderror,
        rxdiagnosticerror    =>    rxdiagnosticerror,
        rxmetaframeerror    =>    rxmetaframeerror,
        rxcrc32error    =>    rxcrc32error,
        rxdiagnosticstatus    =>    rxdiagnosticstatus,
        rxdata    =>    rxdata,
        rxcontrol    =>    rxcontrol,
        accumdisparity    =>    accumdisparity,
        loopbackdatain    =>    loopbackdatain,
        rxpmadata    =>    rxpmadata,
        rxtestdata    =>    rxtestdata,
        syncdatain    =>    syncdatain
    );


end behavior;

library IEEE;
use IEEE.std_logic_1164.all;


entity    stratixv_hssi_10g_tx_pcs    is
    generic    (
        prot_mode    :    string    :=    "disable_mode";
        sup_mode    :    string    :=    "full_mode";
        ctrl_plane_bonding    :    string    :=    "individual";
        master_clk_sel    :    string    :=    "master_tx_pma_clk";
        wr_clk_sel    :    string    :=    "wr_tx_pma_clk";
        wrfifo_clken    :    string    :=    "wrfifo_clk_dis";
        rdfifo_clken    :    string    :=    "rdfifo_clk_dis";
        frmgen_clken    :    string    :=    "frmgen_clk_dis";
        crcgen_clken    :    string    :=    "crcgen_clk_dis";
        enc64b66b_txsm_clken    :    string    :=    "enc64b66b_txsm_clk_dis";
        scrm_clken    :    string    :=    "scrm_clk_dis";
        dispgen_clken    :    string    :=    "dispgen_clk_dis";
        prbs_clken    :    string    :=    "prbs_clk_dis";
        sqwgen_clken    :    string    :=    "sqwgen_clk_dis";
        gbred_clken    :    string    :=    "gbred_clk_dis";
        gb_tx_idwidth    :    string    :=    "idwidth_50";
        gb_tx_odwidth    :    string    :=    "odwidth_32";
        txfifo_mode    :    string    :=    "phase_comp";
        txfifo_pempty    :    string    :=    "pempty_default";
        txfifo_pfull    :    string    :=    "pfull_default";
        txfifo_empty    :    string    :=    "empty_default";
        txfifo_full    :    string    :=    "full_default";
        frmgen_bypass    :    string    :=    "frmgen_bypass_dis";
        frmgen_pipeln    :    string    :=    "frmgen_pipeln_dis";
        frmgen_mfrm_length    :    string    :=    "frmgen_mfrm_length_min";
        frmgen_mfrm_length_user    :    string    :=    "int";
        frmgen_pyld_ins    :    string    :=    "frmgen_pyld_ins_dis";
        sh_err    :    string    :=    "sh_err_dis";
        frmgen_burst    :    string    :=    "frmgen_burst_dis";
        frmgen_wordslip    :    string    :=    "frmgen_wordslip_dis";
        crcgen_bypass    :    string    :=    "crcgen_bypass_dis";
        crcgen_init    :    string    :=    "crcgen_init_user_setting";
        crcgen_init_user    :    bit_vector    :=    B"11111111111111111111111111111111";
        crcgen_inv    :    string    :=    "crcgen_inv_dis";
        crcgen_err    :    string    :=    "crcgen_err_dis";
        enc_64b66b_10g_mode    :    string    :=    "enc_64b66b_10g_mode_en";
        enc_64b66b_txsm_bypass    :    string    :=    "enc_64b66b_txsm_bypass_dis";
        tx_sm_bypass    :    string    :=    "tx_sm_bypass_dis";
        tx_sm_pipeln    :    string    :=    "tx_sm_pipeln_dis";
        scrm_bypass    :    string    :=    "scrm_bypass_dis";
        test_mode    :    string    :=    "test_off";
        pseudo_random    :    string    :=    "all_0";
        pseudo_seed_a    :    string    :=    "pseudo_seed_a_user_setting";
        pseudo_seed_a_user    :    bit_vector    :=    B"1111111111111111111111111111111111111111111111111111111111";
        pseudo_seed_b    :    string    :=    "pseudo_seed_b_user_setting";
        pseudo_seed_b_user    :    bit_vector    :=    B"1111111111111111111111111111111111111111111111111111111111";
        bit_reverse    :    string    :=    "bit_reverse_dis";
        scrm_seed    :    string    :=    "scram_seed_user_setting";
        scrm_seed_user    :    bit_vector    :=    B"1111111111111111111111111111111111111111111111111111111111";
        scrm_mode    :    string    :=    "async";
        dispgen_bypass    :    string    :=    "dispgen_bypass_dis";
        dispgen_err    :    string    :=    "dispgen_err_dis";
        dispgen_pipeln    :    string    :=    "dispgen_pipeln_dis";
        gb_sel_mode    :    string    :=    "internal";
        sq_wave    :    string    :=    "sq_wave_4";
        bitslip_en    :    string    :=    "bitslip_dis";
        fastpath    :    string    :=    "fastpath_dis";
        distup_bypass_pipeln    :    string    :=    "distup_bypass_pipeln_dis";
        distup_master    :    string    :=    "distup_master_en";
        distdwn_bypass_pipeln    :    string    :=    "distdwn_bypass_pipeln_dis";
        distdwn_master    :    string    :=    "distdwn_master_en";
        compin_sel    :    string    :=    "compin_master";
        comp_cnt    :    string    :=    "comp_cnt_00";
        indv    :    string    :=    "indv_en";
        stretch_num_stages    :    string    :=    "zero_stage";
        stretch_en    :    string    :=    "stretch_en";
        iqtxrx_clkout_sel    :    string    :=    "iq_tx_pma_clk";
        channel_number    :    integer    :=    0;
        frmgen_sync_word    :    bit_vector    :=    B"0000000000000000011110001111011001111000111101100111100011110110";
        frmgen_scrm_word    :    bit_vector    :=    B"0000000000000000001010000000000000000000000000000000000000000000";
        frmgen_skip_word    :    bit_vector    :=    B"0000000000000000000111100001111000011110000111100001111000011110";
        frmgen_diag_word    :    bit_vector    :=    B"0000000000000000011001000000000000000000000000000000000000000000";
        test_bus_mode    :    string    :=    "tx";
        lpm_type    :    string    :=    "stratixv_hssi_10g_tx_pcs"
    );
    port    (
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        pmaclkdiv33lc    :    in    std_logic_vector(0 downto 0);
        hardresetn    :    in    std_logic_vector(0 downto 0);
        txpldclk    :    in    std_logic_vector(0 downto 0);
        txpldrstn    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        txdatavalid    :    in    std_logic_vector(0 downto 0);
        txbitslip    :    in    std_logic_vector(6 downto 0);
        txdiagnosticstatus    :    in    std_logic_vector(1 downto 0);
        txwordslip    :    in    std_logic_vector(0 downto 0);
        txbursten    :    in    std_logic_vector(0 downto 0);
        txdisparityclr    :    in    std_logic_vector(0 downto 0);
        txclkout    :    out    std_logic_vector(0 downto 0);
        txclkiqout    :    out    std_logic_vector(0 downto 0);
        txfifoempty    :    out    std_logic_vector(0 downto 0);
        txfifopartialempty    :    out    std_logic_vector(0 downto 0);
        txfifopartialfull    :    out    std_logic_vector(0 downto 0);
        txfifofull    :    out    std_logic_vector(0 downto 0);
        txframe    :    out    std_logic_vector(0 downto 0);
        txburstenexe    :    out    std_logic_vector(0 downto 0);
        txwordslipexe    :    out    std_logic_vector(0 downto 0);
        distupindv    :    in    std_logic_vector(0 downto 0);
        distdwnindv    :    in    std_logic_vector(0 downto 0);
        distupinwren    :    in    std_logic_vector(0 downto 0);
        distdwninwren    :    in    std_logic_vector(0 downto 0);
        distupinrden    :    in    std_logic_vector(0 downto 0);
        distdwninrden    :    in    std_logic_vector(0 downto 0);
        distupoutdv    :    out    std_logic_vector(0 downto 0);
        distdwnoutdv    :    out    std_logic_vector(0 downto 0);
        distupoutwren    :    out    std_logic_vector(0 downto 0);
        distdwnoutwren    :    out    std_logic_vector(0 downto 0);
        distupoutrden    :    out    std_logic_vector(0 downto 0);
        distdwnoutrden    :    out    std_logic_vector(0 downto 0);
        txtestdata    :    out    std_logic_vector(19 downto 0);
        txdata    :    in    std_logic_vector(63 downto 0);
        txcontrol    :    in    std_logic_vector(8 downto 0);
        loopbackdataout    :    out    std_logic_vector(39 downto 0);
        txpmadata    :    out    std_logic_vector(39 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_10g_tx_pcs;

architecture behavior of stratixv_hssi_10g_tx_pcs is

component    stratixv_hssi_10g_tx_pcs_encrypted
    generic    (
        prot_mode    :    string    :=    "disable_mode";
        sup_mode    :    string    :=    "full_mode";
        ctrl_plane_bonding    :    string    :=    "individual";
        master_clk_sel    :    string    :=    "master_tx_pma_clk";
        wr_clk_sel    :    string    :=    "wr_tx_pma_clk";
        wrfifo_clken    :    string    :=    "wrfifo_clk_dis";
        rdfifo_clken    :    string    :=    "rdfifo_clk_dis";
        frmgen_clken    :    string    :=    "frmgen_clk_dis";
        crcgen_clken    :    string    :=    "crcgen_clk_dis";
        enc64b66b_txsm_clken    :    string    :=    "enc64b66b_txsm_clk_dis";
        scrm_clken    :    string    :=    "scrm_clk_dis";
        dispgen_clken    :    string    :=    "dispgen_clk_dis";
        prbs_clken    :    string    :=    "prbs_clk_dis";
        sqwgen_clken    :    string    :=    "sqwgen_clk_dis";
        gbred_clken    :    string    :=    "gbred_clk_dis";
        gb_tx_idwidth    :    string    :=    "idwidth_50";
        gb_tx_odwidth    :    string    :=    "odwidth_32";
        txfifo_mode    :    string    :=    "phase_comp";
        txfifo_pempty    :    string    :=    "pempty_default";
        txfifo_pfull    :    string    :=    "pfull_default";
        txfifo_empty    :    string    :=    "empty_default";
        txfifo_full    :    string    :=    "full_default";
        frmgen_bypass    :    string    :=    "frmgen_bypass_dis";
        frmgen_pipeln    :    string    :=    "frmgen_pipeln_dis";
        frmgen_mfrm_length    :    string    :=    "frmgen_mfrm_length_min";
        frmgen_mfrm_length_user    :    string    :=    "int";
        frmgen_pyld_ins    :    string    :=    "frmgen_pyld_ins_dis";
        sh_err    :    string    :=    "sh_err_dis";
        frmgen_burst    :    string    :=    "frmgen_burst_dis";
        frmgen_wordslip    :    string    :=    "frmgen_wordslip_dis";
        crcgen_bypass    :    string    :=    "crcgen_bypass_dis";
        crcgen_init    :    string    :=    "crcgen_init_user_setting";
        crcgen_init_user    :    bit_vector    :=    B"11111111111111111111111111111111";
        crcgen_inv    :    string    :=    "crcgen_inv_dis";
        crcgen_err    :    string    :=    "crcgen_err_dis";
        enc_64b66b_10g_mode    :    string    :=    "enc_64b66b_10g_mode_en";
        enc_64b66b_txsm_bypass    :    string    :=    "enc_64b66b_txsm_bypass_dis";
        tx_sm_bypass    :    string    :=    "tx_sm_bypass_dis";
        tx_sm_pipeln    :    string    :=    "tx_sm_pipeln_dis";
        scrm_bypass    :    string    :=    "scrm_bypass_dis";
        test_mode    :    string    :=    "test_off";
        pseudo_random    :    string    :=    "all_0";
        pseudo_seed_a    :    string    :=    "pseudo_seed_a_user_setting";
        pseudo_seed_a_user    :    bit_vector    :=    B"1111111111111111111111111111111111111111111111111111111111";
        pseudo_seed_b    :    string    :=    "pseudo_seed_b_user_setting";
        pseudo_seed_b_user    :    bit_vector    :=    B"1111111111111111111111111111111111111111111111111111111111";
        bit_reverse    :    string    :=    "bit_reverse_dis";
        scrm_seed    :    string    :=    "scram_seed_user_setting";
        scrm_seed_user    :    bit_vector    :=    B"1111111111111111111111111111111111111111111111111111111111";
        scrm_mode    :    string    :=    "async";
        dispgen_bypass    :    string    :=    "dispgen_bypass_dis";
        dispgen_err    :    string    :=    "dispgen_err_dis";
        dispgen_pipeln    :    string    :=    "dispgen_pipeln_dis";
        gb_sel_mode    :    string    :=    "internal";
        sq_wave    :    string    :=    "sq_wave_4";
        bitslip_en    :    string    :=    "bitslip_dis";
        fastpath    :    string    :=    "fastpath_dis";
        distup_bypass_pipeln    :    string    :=    "distup_bypass_pipeln_dis";
        distup_master    :    string    :=    "distup_master_en";
        distdwn_bypass_pipeln    :    string    :=    "distdwn_bypass_pipeln_dis";
        distdwn_master    :    string    :=    "distdwn_master_en";
        compin_sel    :    string    :=    "compin_master";
        comp_cnt    :    string    :=    "comp_cnt_00";
        indv    :    string    :=    "indv_en";
        stretch_num_stages    :    string    :=    "zero_stage";
        stretch_en    :    string    :=    "stretch_en";
        iqtxrx_clkout_sel    :    string    :=    "iq_tx_pma_clk";
        channel_number    :    integer    :=    0;
        frmgen_sync_word    :    bit_vector    :=    B"0000000000000000011110001111011001111000111101100111100011110110";
        frmgen_scrm_word    :    bit_vector    :=    B"0000000000000000001010000000000000000000000000000000000000000000";
        frmgen_skip_word    :    bit_vector    :=    B"0000000000000000000111100001111000011110000111100001111000011110";
        frmgen_diag_word    :    bit_vector    :=    B"0000000000000000011001000000000000000000000000000000000000000000";
        test_bus_mode    :    string    :=    "tx";
        lpm_type    :    string    :=    "stratixv_hssi_10g_tx_pcs"
    );
    port    (
        txpmaclk    :    in    std_logic_vector(0 downto 0);
        pmaclkdiv33lc    :    in    std_logic_vector(0 downto 0);
        hardresetn    :    in    std_logic_vector(0 downto 0);
        txpldclk    :    in    std_logic_vector(0 downto 0);
        txpldrstn    :    in    std_logic_vector(0 downto 0);
        refclkdig    :    in    std_logic_vector(0 downto 0);
        txdatavalid    :    in    std_logic_vector(0 downto 0);
        txbitslip    :    in    std_logic_vector(6 downto 0);
        txdiagnosticstatus    :    in    std_logic_vector(1 downto 0);
        txwordslip    :    in    std_logic_vector(0 downto 0);
        txbursten    :    in    std_logic_vector(0 downto 0);
        txdisparityclr    :    in    std_logic_vector(0 downto 0);
        txclkout    :    out    std_logic_vector(0 downto 0);
        txclkiqout    :    out    std_logic_vector(0 downto 0);
        txfifoempty    :    out    std_logic_vector(0 downto 0);
        txfifopartialempty    :    out    std_logic_vector(0 downto 0);
        txfifopartialfull    :    out    std_logic_vector(0 downto 0);
        txfifofull    :    out    std_logic_vector(0 downto 0);
        txframe    :    out    std_logic_vector(0 downto 0);
        txburstenexe    :    out    std_logic_vector(0 downto 0);
        txwordslipexe    :    out    std_logic_vector(0 downto 0);
        distupindv    :    in    std_logic_vector(0 downto 0);
        distdwnindv    :    in    std_logic_vector(0 downto 0);
        distupinwren    :    in    std_logic_vector(0 downto 0);
        distdwninwren    :    in    std_logic_vector(0 downto 0);
        distupinrden    :    in    std_logic_vector(0 downto 0);
        distdwninrden    :    in    std_logic_vector(0 downto 0);
        distupoutdv    :    out    std_logic_vector(0 downto 0);
        distdwnoutdv    :    out    std_logic_vector(0 downto 0);
        distupoutwren    :    out    std_logic_vector(0 downto 0);
        distdwnoutwren    :    out    std_logic_vector(0 downto 0);
        distupoutrden    :    out    std_logic_vector(0 downto 0);
        distdwnoutrden    :    out    std_logic_vector(0 downto 0);
        txtestdata    :    out    std_logic_vector(19 downto 0);
        txdata    :    in    std_logic_vector(63 downto 0);
        txcontrol    :    in    std_logic_vector(8 downto 0);
        loopbackdataout    :    out    std_logic_vector(39 downto 0);
        txpmadata    :    out    std_logic_vector(39 downto 0);
        syncdatain    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_10g_tx_pcs_encrypted
    generic  map  (
        prot_mode    =>   prot_mode,
        sup_mode    =>   sup_mode,
        ctrl_plane_bonding    =>   ctrl_plane_bonding,
        master_clk_sel    =>   master_clk_sel,
        wr_clk_sel    =>   wr_clk_sel,
        wrfifo_clken    =>   wrfifo_clken,
        rdfifo_clken    =>   rdfifo_clken,
        frmgen_clken    =>   frmgen_clken,
        crcgen_clken    =>   crcgen_clken,
        enc64b66b_txsm_clken    =>   enc64b66b_txsm_clken,
        scrm_clken    =>   scrm_clken,
        dispgen_clken    =>   dispgen_clken,
        prbs_clken    =>   prbs_clken,
        sqwgen_clken    =>   sqwgen_clken,
        gbred_clken    =>   gbred_clken,
        gb_tx_idwidth    =>   gb_tx_idwidth,
        gb_tx_odwidth    =>   gb_tx_odwidth,
        txfifo_mode    =>   txfifo_mode,
        txfifo_pempty    =>   txfifo_pempty,
        txfifo_pfull    =>   txfifo_pfull,
        txfifo_empty    =>   txfifo_empty,
        txfifo_full    =>   txfifo_full,
        frmgen_bypass    =>   frmgen_bypass,
        frmgen_pipeln    =>   frmgen_pipeln,
        frmgen_mfrm_length    =>   frmgen_mfrm_length,
        frmgen_mfrm_length_user    =>   frmgen_mfrm_length_user,
        frmgen_pyld_ins    =>   frmgen_pyld_ins,
        sh_err    =>   sh_err,
        frmgen_burst    =>   frmgen_burst,
        frmgen_wordslip    =>   frmgen_wordslip,
        crcgen_bypass    =>   crcgen_bypass,
        crcgen_init    =>   crcgen_init,
        crcgen_init_user    =>   crcgen_init_user,
        crcgen_inv    =>   crcgen_inv,
        crcgen_err    =>   crcgen_err,
        enc_64b66b_10g_mode    =>   enc_64b66b_10g_mode,
        enc_64b66b_txsm_bypass    =>   enc_64b66b_txsm_bypass,
        tx_sm_bypass    =>   tx_sm_bypass,
        tx_sm_pipeln    =>   tx_sm_pipeln,
        scrm_bypass    =>   scrm_bypass,
        test_mode    =>   test_mode,
        pseudo_random    =>   pseudo_random,
        pseudo_seed_a    =>   pseudo_seed_a,
        pseudo_seed_a_user    =>   pseudo_seed_a_user,
        pseudo_seed_b    =>   pseudo_seed_b,
        pseudo_seed_b_user    =>   pseudo_seed_b_user,
        bit_reverse    =>   bit_reverse,
        scrm_seed    =>   scrm_seed,
        scrm_seed_user    =>   scrm_seed_user,
        scrm_mode    =>   scrm_mode,
        dispgen_bypass    =>   dispgen_bypass,
        dispgen_err    =>   dispgen_err,
        dispgen_pipeln    =>   dispgen_pipeln,
        gb_sel_mode    =>   gb_sel_mode,
        sq_wave    =>   sq_wave,
        bitslip_en    =>   bitslip_en,
        fastpath    =>   fastpath,
        distup_bypass_pipeln    =>   distup_bypass_pipeln,
        distup_master    =>   distup_master,
        distdwn_bypass_pipeln    =>   distdwn_bypass_pipeln,
        distdwn_master    =>   distdwn_master,
        compin_sel    =>   compin_sel,
        comp_cnt    =>   comp_cnt,
        indv    =>   indv,
        stretch_num_stages    =>   stretch_num_stages,
        stretch_en    =>   stretch_en,
        iqtxrx_clkout_sel    =>   iqtxrx_clkout_sel,
        channel_number    =>   channel_number,
        frmgen_sync_word    =>   frmgen_sync_word,
        frmgen_scrm_word    =>   frmgen_scrm_word,
        frmgen_skip_word    =>   frmgen_skip_word,
        frmgen_diag_word    =>   frmgen_diag_word,
        test_bus_mode    =>   test_bus_mode,
        lpm_type    =>   lpm_type
    )
    port  map  (
        txpmaclk    =>    txpmaclk,
        pmaclkdiv33lc    =>    pmaclkdiv33lc,
        hardresetn    =>    hardresetn,
        txpldclk    =>    txpldclk,
        txpldrstn    =>    txpldrstn,
        refclkdig    =>    refclkdig,
        txdatavalid    =>    txdatavalid,
        txbitslip    =>    txbitslip,
        txdiagnosticstatus    =>    txdiagnosticstatus,
        txwordslip    =>    txwordslip,
        txbursten    =>    txbursten,
        txdisparityclr    =>    txdisparityclr,
        txclkout    =>    txclkout,
        txclkiqout    =>    txclkiqout,
        txfifoempty    =>    txfifoempty,
        txfifopartialempty    =>    txfifopartialempty,
        txfifopartialfull    =>    txfifopartialfull,
        txfifofull    =>    txfifofull,
        txframe    =>    txframe,
        txburstenexe    =>    txburstenexe,
        txwordslipexe    =>    txwordslipexe,
        distupindv    =>    distupindv,
        distdwnindv    =>    distdwnindv,
        distupinwren    =>    distupinwren,
        distdwninwren    =>    distdwninwren,
        distupinrden    =>    distupinrden,
        distdwninrden    =>    distdwninrden,
        distupoutdv    =>    distupoutdv,
        distdwnoutdv    =>    distdwnoutdv,
        distupoutwren    =>    distupoutwren,
        distdwnoutwren    =>    distdwnoutwren,
        distupoutrden    =>    distupoutrden,
        distdwnoutrden    =>    distdwnoutrden,
        txtestdata    =>    txtestdata,
        txdata    =>    txdata,
        txcontrol    =>    txcontrol,
        loopbackdataout    =>    loopbackdataout,
        txpmadata    =>    txpmadata,
        syncdatain    =>    syncdatain
    );


end behavior;

------------------------------------------------------------------------------------
-- This is the HSSI Simulation Atom Model Encryption wrapper for the AVMM Interface
-- Entity Name : stratixv_hssi_avmm_interface
------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


entity stratixv_hssi_avmm_interface is
      generic    (
        num_ch0_atoms    :    integer    :=    0;
        num_ch1_atoms    :    integer    :=    0;
        num_ch2_atoms    :    integer    :=    0
    );

    port    (
    avmmrstn           : in  std_logic_vector(0 downto 0);
    avmmclk            : in  std_logic_vector(0 downto 0);
    avmmwrite          : in  std_logic_vector(0 downto 0);
    avmmread           : in  std_logic_vector(0 downto 0);
    avmmbyteen         : in  std_logic_vector(1 downto 0);
    avmmaddress        : in  std_logic_vector(10 downto 0);
    avmmwritedata      : in  std_logic_vector(15 downto 0);
    blockselect        : in  std_logic_vector(90-1 downto 0);
    readdatachnl       : in  std_logic_vector(90*16-1 downto 0);

    avmmreaddata       : out std_logic_vector(15 downto 0);

    clkchnl            : out std_logic_vector(0 downto 0);
    rstnchnl           : out std_logic_vector(0 downto 0);
    writedatachnl      : out std_logic_vector(15 downto 0);
    regaddrchnl        : out std_logic_vector(10 downto 0);
    writechnl          : out std_logic_vector(0 downto 0);
    readchnl           : out std_logic_vector(0 downto 0);
    byteenchnl         : out std_logic_vector(1 downto 0);

    -- The following ports are not modelled. They exist to match the avmm interface atom interface
    refclkdig          : in  std_logic_vector(0 downto 0);
    avmmreservedin     : in  std_logic_vector(0 downto 0);
    
    avmmreservedout    : out std_logic_vector(0 downto 0);
    dpriorstntop       : out std_logic_vector(0 downto 0);
    dprioclktop        : out std_logic_vector(0 downto 0);
    mdiodistopchnl     : out std_logic_vector(0 downto 0);
    dpriorstnmid       : out std_logic_vector(0 downto 0);
    dprioclkmid        : out std_logic_vector(0 downto 0);
    mdiodismidchnl     : out std_logic_vector(0 downto 0);
    dpriorstnbot       : out std_logic_vector(0 downto 0);
    dprioclkbot        : out std_logic_vector(0 downto 0);
    mdiodisbotchnl     : out std_logic_vector(0 downto 0);
    dpriotestsitopchnl : out std_logic_vector(3 downto 0);
    dpriotestsimidchnl : out std_logic_vector(3 downto 0);
    dpriotestsibotchnl : out std_logic_vector(3 downto 0);
 
    -- The following ports belong to pm_adce and pm_tst_mux blocks in the PMA
    pmatestbus         : out std_logic_vector(23 downto 0);
    pmatestbussel      : in  std_logic_vector(11 downto 0);

    scanmoden          : in  std_logic_vector(0 downto 0);
    scanshiftn         : in  std_logic_vector(0 downto 0);
    interfacesel       : in  std_logic_vector(0 downto 0);
    sershiftload       : in  std_logic_vector(0 downto 0)
    );
end stratixv_hssi_avmm_interface;

architecture behavior of stratixv_hssi_avmm_interface is

component stratixv_hssi_avmm_interface_encrypted
    generic    (
        num_ch0_atoms    :    integer    :=    0;
        num_ch1_atoms    :    integer    :=    0;
        num_ch2_atoms    :    integer    :=    0
    );


    port (
      avmmrstn           : in  std_logic_vector(0 downto 0);
      avmmclk            : in  std_logic_vector(0 downto 0);
      avmmwrite          : in  std_logic_vector(0 downto 0);
      avmmread           : in  std_logic_vector(0 downto 0);
      avmmbyteen         : in  std_logic_vector(1 downto 0);
      avmmaddress        : in  std_logic_vector(10 downto 0);
      avmmwritedata      : in  std_logic_vector(15 downto 0);
      blockselect        : in  std_logic_vector(90-1 downto 0);
      readdatachnl       : in  std_logic_vector(90*16-1 downto 0);
      avmmreaddata       : out std_logic_vector(15 downto 0);
      clkchnl            : out std_logic_vector(0 downto 0);
      rstnchnl           : out std_logic_vector(0 downto 0);
      writedatachnl      : out std_logic_vector(15 downto 0);
      regaddrchnl        : out std_logic_vector(10 downto 0);
      writechnl          : out std_logic_vector(0 downto 0);
      readchnl           : out std_logic_vector(0 downto 0);
      byteenchnl         : out std_logic_vector(1 downto 0);
      refclkdig          : in  std_logic_vector(0 downto 0);
      avmmreservedin     : in  std_logic_vector(0 downto 0);
      avmmreservedout    : out std_logic_vector(0 downto 0);
      dpriorstntop       : out std_logic_vector(0 downto 0);
      dprioclktop        : out std_logic_vector(0 downto 0);
      mdiodistopchnl     : out std_logic_vector(0 downto 0);
      dpriorstnmid       : out std_logic_vector(0 downto 0);
      dprioclkmid        : out std_logic_vector(0 downto 0);
      mdiodismidchnl     : out std_logic_vector(0 downto 0);
      dpriorstnbot       : out std_logic_vector(0 downto 0);
      dprioclkbot        : out std_logic_vector(0 downto 0);
      mdiodisbotchnl     : out std_logic_vector(0 downto 0);
      dpriotestsitopchnl : out std_logic_vector(3 downto 0);
      dpriotestsimidchnl : out std_logic_vector(3 downto 0);
      dpriotestsibotchnl : out std_logic_vector(3 downto 0);
      pmatestbus         : out std_logic_vector(23 downto 0);
      pmatestbussel      : in  std_logic_vector(11 downto 0);
      scanmoden          : in  std_logic_vector(0 downto 0);
      scanshiftn         : in  std_logic_vector(0 downto 0);
      interfacesel       : in  std_logic_vector(0 downto 0);
      sershiftload       : in  std_logic_vector(0 downto 0)
    );
end component;

begin
inst : stratixv_hssi_avmm_interface_encrypted
    generic  map  (
        num_ch0_atoms => num_ch0_atoms,
        num_ch1_atoms => num_ch1_atoms,
        num_ch2_atoms => num_ch2_atoms
    )  
   port  map  (
   avmmrstn           => avmmrstn           ,
   avmmclk            => avmmclk            ,
   avmmwrite          => avmmwrite          ,
   avmmread           => avmmread           ,
   avmmbyteen         => avmmbyteen         ,
   avmmaddress        => avmmaddress        ,
   avmmwritedata      => avmmwritedata      ,
   blockselect        => blockselect        ,
   readdatachnl       => readdatachnl       ,
   avmmreaddata       => avmmreaddata       ,
   clkchnl            => clkchnl            ,
   rstnchnl           => rstnchnl           ,
   writedatachnl      => writedatachnl      ,
   regaddrchnl        => regaddrchnl        ,
   writechnl          => writechnl          ,
   readchnl           => readchnl           ,
   byteenchnl         => byteenchnl         ,
   refclkdig          => refclkdig          ,
   avmmreservedin     => avmmreservedin     ,
   avmmreservedout    => avmmreservedout    ,
   dpriorstntop       => dpriorstntop       ,
   dprioclktop        => dprioclktop        ,
   mdiodistopchnl     => mdiodistopchnl     ,
   dpriorstnmid       => dpriorstnmid       ,
   dprioclkmid        => dprioclkmid        ,
   mdiodismidchnl     => mdiodismidchnl     ,
   dpriorstnbot       => dpriorstnbot       ,
   dprioclkbot        => dprioclkbot        ,
   mdiodisbotchnl     => mdiodisbotchnl     ,
   dpriotestsitopchnl => dpriotestsitopchnl ,
   dpriotestsimidchnl => dpriotestsimidchnl ,
   dpriotestsibotchnl => dpriotestsibotchnl ,
   pmatestbus         => pmatestbus         ,
   pmatestbussel      => pmatestbussel      ,
   scanmoden          => scanmoden          ,
   scanshiftn         => scanshiftn         ,
   interfacesel       => interfacesel       ,
   sershiftload       => sershiftload
  );

end behavior;

