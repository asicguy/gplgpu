// Copyright (C) 1991-2011 Altera Corporation
// This simulation model contains highly confidential and
// proprietary information of Altera and is being provided
// in accordance with and subject to the protections of the
// applicable Altera Program License Subscription Agreement
// which governs its use and disclosure. Your use of Altera
// Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions,
// and any output files any of the foregoing (including device
// programming or simulation files), and any associated
// documentation or information are expressly subject to the
// terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other
// applicable license agreement, including, without limitation,
// that your use is for the sole purpose of simulating designs for
// use exclusively in logic devices manufactured by Altera and sold
// by Altera or its authorized distributors. Please refer to the
// applicable agreement for further details. Altera products and
// services are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
// Altera assumes no responsibility or liability arising out of the
// application or use of this simulation model.
// Quartus II 11.0 Build 157 04/27/2011
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_atx_pll_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_atx_pll
#(
	// parameter declaration and default value assignemnt

	parameter avmm_group_channel_index = 0,
	parameter output_clock_frequency = "",
	parameter reference_clock_frequency = "",
	parameter use_default_base_address = "true",
	parameter user_base_address0 = 0,
	parameter user_base_address1 = 0,
	parameter user_base_address2 = 0,
	parameter cp_current_ctrl = 300,
	parameter cp_current_test = "enable_ch_pump_normal",
	parameter cp_hs_levshift_power_supply_setting = 1,
	parameter cp_replica_bias_ctrl = "disable_replica_bias_ctrl",
	parameter cp_rgla_bypass = "false",
	parameter cp_rgla_volt_inc = "boost_30pct",
	parameter l_counter = 1,
	parameter lcpll_atb_select = "atb_disable",
	parameter lcpll_d2a_sel = "volt_1p02v",
	parameter lcpll_hclk_driver_enable = "driver_off",
	parameter lcvco_gear_sel = "high_gear",
	parameter lcvco_sel = "high_freq_14g",
	parameter lpf_ripple_cap_ctrl = "none",
	parameter lpf_rxpll_pfd_bw_ctrl = 2400,
	parameter m_counter = 4,
	parameter ref_clk_div = 1,
	parameter refclk_sel = "refclk",
	parameter vreg1_lcvco_volt_inc = "volt_1p1v",
	parameter vreg1_vccehlow = "normal_operation",
	parameter vreg2_lcpll_volt_sel = "vreg2_volt_1p0v",
	parameter vreg3_lcpll_volt_sel = "vreg3_volt_1p0v"
)
(
//input and output port declaration
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 31:0 ] ch0rcsrlc,
	input [ 31:0 ] ch1rcsrlc,
	input [ 31:0 ] ch2rcsrlc,
	input [ 0:0 ] cmurstn,
	input [ 0:0 ] cmurstnlpf,
	input [ 0:0 ] extfbclk,
	input [ 0:0 ] iqclklc,
	input [ 0:0 ] pldclklc,
	input [ 0:0 ] pllfbswblc,
	input [ 0:0 ] pllfbswtlc,
	input [ 0:0 ] refclklc,
	output [ 0:0 ] clk010g,
	output [ 0:0 ] clk025g,
	output [ 0:0 ] clk18010g,
	output [ 0:0 ] clk18025g,
	output [ 0:0 ] clk33cmu,
	output [ 0:0 ] clklowcmu,
	output [ 0:0 ] frefcmu,
	output [ 0:0 ] iqclkatt,
	output [ 0:0 ] pfdmodelockcmu,
	output [ 0:0 ] pldclkatt,
	output [ 0:0 ] refclkatt,
	output [ 0:0 ] txpllhclk
); 

	stratixv_atx_pll_encrypted 
	#(

		.avmm_group_channel_index(avmm_group_channel_index),
		.output_clock_frequency(output_clock_frequency),
		.reference_clock_frequency(reference_clock_frequency),
		.use_default_base_address(use_default_base_address),
		.user_base_address0(user_base_address0),
		.user_base_address1(user_base_address1),
		.user_base_address2(user_base_address2),
		.cp_current_ctrl(cp_current_ctrl),
		.cp_current_test(cp_current_test),
		.cp_hs_levshift_power_supply_setting(cp_hs_levshift_power_supply_setting),
		.cp_replica_bias_ctrl(cp_replica_bias_ctrl),
		.cp_rgla_bypass(cp_rgla_bypass),
		.cp_rgla_volt_inc(cp_rgla_volt_inc),
		.l_counter(l_counter),
		.lcpll_atb_select(lcpll_atb_select),
		.lcpll_d2a_sel(lcpll_d2a_sel),
		.lcpll_hclk_driver_enable(lcpll_hclk_driver_enable),
		.lcvco_gear_sel(lcvco_gear_sel),
		.lcvco_sel(lcvco_sel),
		.lpf_ripple_cap_ctrl(lpf_ripple_cap_ctrl),
		.lpf_rxpll_pfd_bw_ctrl(lpf_rxpll_pfd_bw_ctrl),
		.m_counter(m_counter),
		.ref_clk_div(ref_clk_div),
		.refclk_sel(refclk_sel),
		.vreg1_lcvco_volt_inc(vreg1_lcvco_volt_inc),
		.vreg1_vccehlow(vreg1_vccehlow),
		.vreg2_lcpll_volt_sel(vreg2_lcpll_volt_sel),
		.vreg3_lcpll_volt_sel(vreg3_lcpll_volt_sel)

	)
	stratixv_atx_pll_encrypted_inst	(
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.ch0rcsrlc(ch0rcsrlc),
		.ch1rcsrlc(ch1rcsrlc),
		.ch2rcsrlc(ch2rcsrlc),
		.cmurstn(cmurstn),
		.cmurstnlpf(cmurstnlpf),
		.extfbclk(extfbclk),
		.iqclklc(iqclklc),
		.pldclklc(pldclklc),
		.pllfbswblc(pllfbswblc),
		.pllfbswtlc(pllfbswtlc),
		.refclklc(refclklc),
		.clk010g(clk010g),
		.clk025g(clk025g),
		.clk18010g(clk18010g),
		.clk18025g(clk18025g),
		.clk33cmu(clk33cmu),
		.clklowcmu(clklowcmu),
		.frefcmu(frefcmu),
		.iqclkatt(iqclkatt),
		.pfdmodelockcmu(pfdmodelockcmu),
		.pldclkatt(pldclkatt),
		.refclkatt(refclkatt),
		.txpllhclk(txpllhclk)
	);


endmodule
////////////////////////////////////////////////////////////////////////////////
// Module: stratixv_channel_pll
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixv_channel_pll
#(
	// Parameter declarations and default value assignments
	parameter avmm_group_channel_index = 0,
	parameter output_clock_frequency = "0 ps",
	parameter reference_clock_frequency = "0 ps",
	parameter sim_use_fast_model = "true",
	parameter use_default_base_address = "true",
	parameter user_base_address = 0,
	parameter bbpd_salatch_offset_ctrl_clk0 = "offset_0mv",
	parameter bbpd_salatch_offset_ctrl_clk180 = "offset_0mv",
	parameter bbpd_salatch_offset_ctrl_clk270 = "offset_0mv",
	parameter bbpd_salatch_offset_ctrl_clk90 = "offset_0mv",
	parameter bbpd_salatch_sel = "normal",
	parameter bypass_cp_rgla = "false",
	parameter cdr_atb_select = "atb_disable",
	parameter cgb_clk_enable = "false",
	parameter charge_pump_current_test = "enable_ch_pump_normal",
	parameter clklow_fref_to_ppm_div_sel = 1,
	parameter clock_monitor = "lpbk_data",
	parameter diag_rev_lpbk = "false",
	parameter eye_monitor_bbpd_data_ctrl = "cdr_data",
	parameter fast_lock_mode = "false",
	parameter fb_sel = "vcoclk",
	parameter gpon_lock2ref_ctrl = "lck2ref",
	parameter hs_levshift_power_supply_setting = 1,
	parameter ignore_phslock = "false",
	parameter l_counter_pd_clock_disable = "false",
	parameter m_counter = 4,
	parameter pcie_freq_control = "pcie_100mhz",
	parameter pd_charge_pump_current_ctrl = 5,
	parameter pd_l_counter = 1,
	parameter pfd_charge_pump_current_ctrl = 20,
	parameter pfd_l_counter = 1,
	parameter powerdown = "false",
	parameter ref_clk_div = 1,
	parameter regulator_volt_inc = "0",
	parameter replica_bias_ctrl = "true",
	parameter reverse_serial_lpbk = "false",
	parameter ripple_cap_ctrl = "none",
	parameter rxpll_pd_bw_ctrl = 300,
	parameter rxpll_pfd_bw_ctrl = 3200,
	parameter txpll_hclk_driver_enable = "false",
	parameter vco_overange_ref = "off",
	parameter vco_range_ctrl_en = "false"
)
(
	// Input port declarations
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	input [ 0:0 ] clk270beyerm,
	input [ 0:0 ] clk270eye,
	input [ 0:0 ] clk90beyerm,
	input [ 0:0 ] clk90eye,
	input [ 0:0 ] clkindeser,
	input [ 0:0 ] crurstb,
	input [ 0:0 ] deeye,
	input [ 0:0 ] deeyerm,
	input [ 0:0 ] doeye,
	input [ 0:0 ] doeyerm,
	input [ 0:0 ] earlyeios,
	input [ 0:0 ] extclk,
	input [ 0:0 ] extfbctrla,
	input [ 0:0 ] extfbctrlb,
	input [ 0:0 ] gpblck2refb,
	input [ 0:0 ] lpbkpreen,
	input [ 0:0 ] ltd,
	input [ 0:0 ] ltr,
	input [ 0:0 ] occalen,
	input [ 0:0 ] pciel,
	input [ 0:0 ] pciem,
	input [ 1:0 ] pciesw,
	input [ 0:0 ] ppmlock,
	input [ 0:0 ] refclk,
	input [ 0:0 ] rstn,
	input [ 0:0 ] rxp,
	input [ 0:0 ] sd,
	
	// Output port declarations
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] ck0pd,
	output [ 0:0 ] ck180pd,
	output [ 0:0 ] ck270pd,
	output [ 0:0 ] ck90pd,
	output [ 0:0 ] clk270bcdr,
	output [ 0:0 ] clk270bdes,
	output [ 0:0 ] clk90bcdr,
	output [ 0:0 ] clk90bdes,
	output [ 0:0 ] clkcdr,
	output [ 0:0 ] clklow,
	output [ 0:0 ] decdr,
	output [ 0:0 ] deven,
	output [ 0:0 ] docdr,
	output [ 0:0 ] dodd,
	output [ 0:0 ] fref,
	output [ 3:0 ] pdof,
	output [ 0:0 ] pfdmodelock,
	output [ 0:0 ] rxlpbdp,
	output [ 0:0 ] rxlpbp,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] txpllhclk,
	output [ 0:0 ] txrlpbk,
	output [ 0:0 ] vctrloverrange
); 

	stratixv_channel_pll_encrypted 
	#(
		.avmm_group_channel_index(avmm_group_channel_index),
		.output_clock_frequency(output_clock_frequency),
		.reference_clock_frequency(reference_clock_frequency),
		.sim_use_fast_model(sim_use_fast_model),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.bbpd_salatch_offset_ctrl_clk0(bbpd_salatch_offset_ctrl_clk0),
		.bbpd_salatch_offset_ctrl_clk180(bbpd_salatch_offset_ctrl_clk180),
		.bbpd_salatch_offset_ctrl_clk270(bbpd_salatch_offset_ctrl_clk270),
		.bbpd_salatch_offset_ctrl_clk90(bbpd_salatch_offset_ctrl_clk90),
		.bbpd_salatch_sel(bbpd_salatch_sel),
		.bypass_cp_rgla(bypass_cp_rgla),
		.cdr_atb_select(cdr_atb_select),
		.cgb_clk_enable(cgb_clk_enable),
		.charge_pump_current_test(charge_pump_current_test),
		.clklow_fref_to_ppm_div_sel(clklow_fref_to_ppm_div_sel),
		.clock_monitor(clock_monitor),
		.diag_rev_lpbk(diag_rev_lpbk),
		.eye_monitor_bbpd_data_ctrl(eye_monitor_bbpd_data_ctrl),
		.fast_lock_mode(fast_lock_mode),
		.fb_sel(fb_sel),
		.gpon_lock2ref_ctrl(gpon_lock2ref_ctrl),
		.hs_levshift_power_supply_setting(hs_levshift_power_supply_setting),
		.ignore_phslock(ignore_phslock),
		.l_counter_pd_clock_disable(l_counter_pd_clock_disable),
		.m_counter(m_counter),
		.pcie_freq_control(pcie_freq_control),
		.pd_charge_pump_current_ctrl(pd_charge_pump_current_ctrl),
		.pd_l_counter(pd_l_counter),
		.pfd_charge_pump_current_ctrl(pfd_charge_pump_current_ctrl),
		.pfd_l_counter(pfd_l_counter),
		.powerdown(powerdown),
		.ref_clk_div(ref_clk_div),
		.regulator_volt_inc(regulator_volt_inc),
		.replica_bias_ctrl(replica_bias_ctrl),
		.reverse_serial_lpbk(reverse_serial_lpbk),
		.ripple_cap_ctrl(ripple_cap_ctrl),
		.rxpll_pd_bw_ctrl(rxpll_pd_bw_ctrl),
		.rxpll_pfd_bw_ctrl(rxpll_pfd_bw_ctrl),
		.txpll_hclk_driver_enable(txpll_hclk_driver_enable),
		.vco_overange_ref(vco_overange_ref),
		.vco_range_ctrl_en(vco_range_ctrl_en)
	)
	stratixv_channel_pll_encrypted_inst	(
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.clk270beyerm(clk270beyerm),
		.clk270eye(clk270eye),
		.clk90beyerm(clk90beyerm),
		.clk90eye(clk90eye),
		.clkindeser(clkindeser),
		.crurstb(crurstb),
		.deeye(deeye),
		.deeyerm(deeyerm),
		.doeye(doeye),
		.doeyerm(doeyerm),
		.earlyeios(earlyeios),
		.extclk(extclk),
		.extfbctrla(extfbctrla),
		.extfbctrlb(extfbctrlb),
		.gpblck2refb(gpblck2refb),
		.lpbkpreen(lpbkpreen),
		.ltd(ltd),
		.ltr(ltr),
		.occalen(occalen),
		.pciel(pciel),
		.pciem(pciem),
		.pciesw(pciesw),
		.ppmlock(ppmlock),
		.refclk(refclk),
		.rstn(rstn),
		.rxp(rxp),
		.sd(sd),
		.ck0pd(ck0pd),
		.ck180pd(ck180pd),
		.ck270pd(ck270pd),
		.ck90pd(ck90pd),
		.clk270bcdr(clk270bcdr),
		.clk270bdes(clk270bdes),
		.clk90bcdr(clk90bcdr),
		.clk90bdes(clk90bdes),
		.clkcdr(clkcdr),
		.clklow(clklow),
		.decdr(decdr),
		.deven(deven),
		.docdr(docdr),
		.dodd(dodd),
		.fref(fref),
		.pdof(pdof),
		.pfdmodelock(pfdmodelock),
		.rxlpbdp(rxlpbdp),
		.rxlpbp(rxlpbp),
		.rxplllock(rxplllock),
		.txpllhclk(txpllhclk),
		.txrlpbk(txrlpbk),
		.vctrloverrange(vctrloverrange)
	);

endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_8g_pcs_aggregate_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_8g_pcs_aggregate
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter xaui_sm_operation = "en_xaui_sm",	//Valid values: dis_xaui_sm|en_xaui_sm|en_xaui_legacy_sm
	parameter dskw_sm_operation = "dskw_xaui_sm",	//Valid values: dskw_xaui_sm|dskw_srio_sm
	parameter data_agg_bonding = "agg_disable",	//Valid values: agg_disable|x4_cmu1|x4_cmu2|x4_cmu3|x4_lc1|x4_lc2|x4_lc3|x2_cmu1|x2_lc1
	parameter prot_mode_tx = "pipe_g1_tx",	//Valid values: pipe_g1_tx|pipe_g2_tx|pipe_g3_tx|cpri_tx|cpri_rx_tx_tx|gige_tx|xaui_tx|srio_2p1_tx|test_tx|basic_tx|disabled_prot_mode_tx
	parameter pcs_dw_datapath = "sw_data_path",	//Valid values: sw_data_path|dw_data_path
	parameter dskw_control = "dskw_write_control",	//Valid values: dskw_write_control|dskw_read_control
	parameter refclkdig_sel = "dis_refclk_dig_sel",	//Valid values: dis_refclk_dig_sel|en_refclk_dig_sel
	parameter agg_pwdn = "dis_agg_pwdn",	//Valid values: dis_agg_pwdn|en_agg_pwdn
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] scanmoden,
	input [ 0:0 ] scanshiftn,
	input [ 0:0 ] txpmaclk,
	input [ 0:0 ] rcvdclkch0,
	input [ 0:0 ] rcvdclkch1,
	input [ 63:0 ] dprioagg,
	output [ 0:0 ] rcvdclkout,
	output [ 0:0 ] rcvdclkouttop,
	output [ 0:0 ] rcvdclkoutbot,
	input [ 0:0 ] rdenablesynctopch1,
	input [ 7:0 ] txdatatctopch1,
	input [ 0:0 ] txctltctopch1,
	input [ 0:0 ] syncstatustopch1,
	input [ 1:0 ] rdaligntopch1,
	input [ 1:0 ] aligndetsynctopch1,
	input [ 0:0 ] fifordintopch1,
	input [ 0:0 ] alignstatussynctopch1,
	input [ 1:0 ] cgcomprddintopch1,
	input [ 1:0 ] cgcompwrintopch1,
	input [ 0:0 ] delcondmetintopch1,
	input [ 0:0 ] fifoovrintopch1,
	input [ 0:0 ] latencycompintopch1,
	input [ 0:0 ] insertincompleteintopch1,
	input [ 7:0 ] decdatatopch1,
	input [ 0:0 ] decctltopch1,
	input [ 0:0 ] decdatavalidtopch1,
	input [ 1:0 ] runningdisptopch1,
	output [ 7:0 ] txdatatstopch1,
	output [ 0:0 ] txctltstopch1,
	output [ 0:0 ] fiforstrdqdtopch1,
	output [ 0:0 ] endskwqdtopch1,
	output [ 0:0 ] endskwrdptrstopch1,
	output [ 0:0 ] alignstatustopch1,
	output [ 0:0 ] alignstatussync0topch1,
	output [ 0:0 ] fifordoutcomp0topch1,
	output [ 0:0 ] cgcomprddalltopch1,
	output [ 0:0 ] cgcompwralltopch1,
	output [ 0:0 ] delcondmet0topch1,
	output [ 0:0 ] insertincomplete0topch1,
	output [ 0:0 ] fifoovr0topch1,
	output [ 0:0 ] latencycomp0topch1,
	output [ 7:0 ] rxdatarstopch1,
	output [ 0:0 ] rxctlrstopch1,
	input [ 0:0 ] rdenablesynctopch0,
	input [ 7:0 ] txdatatctopch0,
	input [ 0:0 ] txctltctopch0,
	input [ 0:0 ] syncstatustopch0,
	input [ 1:0 ] rdaligntopch0,
	input [ 1:0 ] aligndetsynctopch0,
	input [ 0:0 ] fifordintopch0,
	input [ 0:0 ] alignstatussynctopch0,
	input [ 1:0 ] cgcomprddintopch0,
	input [ 1:0 ] cgcompwrintopch0,
	input [ 0:0 ] delcondmetintopch0,
	input [ 0:0 ] fifoovrintopch0,
	input [ 0:0 ] latencycompintopch0,
	input [ 0:0 ] insertincompleteintopch0,
	input [ 7:0 ] decdatatopch0,
	input [ 0:0 ] decctltopch0,
	input [ 0:0 ] decdatavalidtopch0,
	input [ 1:0 ] runningdisptopch0,
	output [ 7:0 ] txdatatstopch0,
	output [ 0:0 ] txctltstopch0,
	output [ 0:0 ] fiforstrdqdtopch0,
	output [ 0:0 ] endskwqdtopch0,
	output [ 0:0 ] endskwrdptrstopch0,
	output [ 0:0 ] alignstatustopch0,
	output [ 0:0 ] alignstatussync0topch0,
	output [ 0:0 ] fifordoutcomp0topch0,
	output [ 0:0 ] cgcomprddalltopch0,
	output [ 0:0 ] cgcompwralltopch0,
	output [ 0:0 ] delcondmet0topch0,
	output [ 0:0 ] insertincomplete0topch0,
	output [ 0:0 ] fifoovr0topch0,
	output [ 0:0 ] latencycomp0topch0,
	output [ 7:0 ] rxdatarstopch0,
	output [ 0:0 ] rxctlrstopch0,
	input [ 0:0 ] rdenablesyncch2,
	input [ 7:0 ] txdatatcch2,
	input [ 0:0 ] txctltcch2,
	input [ 0:0 ] syncstatusch2,
	input [ 1:0 ] rdalignch2,
	input [ 1:0 ] aligndetsyncch2,
	input [ 0:0 ] fifordinch2,
	input [ 0:0 ] alignstatussyncch2,
	input [ 1:0 ] cgcomprddinch2,
	input [ 1:0 ] cgcompwrinch2,
	input [ 0:0 ] delcondmetinch2,
	input [ 0:0 ] fifoovrinch2,
	input [ 0:0 ] latencycompinch2,
	input [ 0:0 ] insertincompleteinch2,
	input [ 7:0 ] decdatach2,
	input [ 0:0 ] decctlch2,
	input [ 0:0 ] decdatavalidch2,
	input [ 1:0 ] runningdispch2,
	output [ 7:0 ] txdatatsch2,
	output [ 0:0 ] txctltsch2,
	output [ 0:0 ] fiforstrdqdch2,
	output [ 0:0 ] endskwqdch2,
	output [ 0:0 ] endskwrdptrsch2,
	output [ 0:0 ] alignstatusch2,
	output [ 0:0 ] alignstatussync0ch2,
	output [ 0:0 ] fifordoutcomp0ch2,
	output [ 0:0 ] cgcomprddallch2,
	output [ 0:0 ] cgcompwrallch2,
	output [ 0:0 ] delcondmet0ch2,
	output [ 0:0 ] insertincomplete0ch2,
	output [ 0:0 ] fifoovr0ch2,
	output [ 0:0 ] latencycomp0ch2,
	output [ 7:0 ] rxdatarsch2,
	output [ 0:0 ] rxctlrsch2,
	input [ 0:0 ] rdenablesyncch1,
	input [ 7:0 ] txdatatcch1,
	input [ 0:0 ] txctltcch1,
	input [ 0:0 ] syncstatusch1,
	input [ 1:0 ] rdalignch1,
	input [ 1:0 ] aligndetsyncch1,
	input [ 0:0 ] fifordinch1,
	input [ 0:0 ] alignstatussyncch1,
	input [ 1:0 ] cgcomprddinch1,
	input [ 1:0 ] cgcompwrinch1,
	input [ 0:0 ] delcondmetinch1,
	input [ 0:0 ] fifoovrinch1,
	input [ 0:0 ] latencycompinch1,
	input [ 0:0 ] insertincompleteinch1,
	input [ 7:0 ] decdatach1,
	input [ 0:0 ] decctlch1,
	input [ 0:0 ] decdatavalidch1,
	input [ 1:0 ] runningdispch1,
	output [ 7:0 ] txdatatsch1,
	output [ 0:0 ] txctltsch1,
	output [ 0:0 ] fiforstrdqdch1,
	output [ 0:0 ] endskwqdch1,
	output [ 0:0 ] endskwrdptrsch1,
	output [ 0:0 ] alignstatusch1,
	output [ 0:0 ] alignstatussync0ch1,
	output [ 0:0 ] fifordoutcomp0ch1,
	output [ 0:0 ] cgcomprddallch1,
	output [ 0:0 ] cgcompwrallch1,
	output [ 0:0 ] delcondmet0ch1,
	output [ 0:0 ] insertincomplete0ch1,
	output [ 0:0 ] fifoovr0ch1,
	output [ 0:0 ] latencycomp0ch1,
	output [ 7:0 ] rxdatarsch1,
	output [ 0:0 ] rxctlrsch1,
	input [ 0:0 ] rdenablesyncch0,
	input [ 7:0 ] txdatatcch0,
	input [ 0:0 ] txctltcch0,
	input [ 0:0 ] syncstatusch0,
	input [ 1:0 ] rdalignch0,
	input [ 1:0 ] aligndetsyncch0,
	input [ 0:0 ] fifordinch0,
	input [ 0:0 ] alignstatussyncch0,
	input [ 1:0 ] cgcomprddinch0,
	input [ 1:0 ] cgcompwrinch0,
	input [ 0:0 ] delcondmetinch0,
	input [ 0:0 ] fifoovrinch0,
	input [ 0:0 ] latencycompinch0,
	input [ 0:0 ] insertincompleteinch0,
	input [ 7:0 ] decdatach0,
	input [ 0:0 ] decctlch0,
	input [ 0:0 ] decdatavalidch0,
	input [ 1:0 ] runningdispch0,
	output [ 7:0 ] txdatatsch0,
	output [ 0:0 ] txctltsch0,
	output [ 0:0 ] fiforstrdqdch0,
	output [ 0:0 ] endskwqdch0,
	output [ 0:0 ] endskwrdptrsch0,
	output [ 0:0 ] alignstatusch0,
	output [ 0:0 ] alignstatussync0ch0,
	output [ 0:0 ] fifordoutcomp0ch0,
	output [ 0:0 ] cgcomprddallch0,
	output [ 0:0 ] cgcompwrallch0,
	output [ 0:0 ] delcondmet0ch0,
	output [ 0:0 ] insertincomplete0ch0,
	output [ 0:0 ] fifoovr0ch0,
	output [ 0:0 ] latencycomp0ch0,
	output [ 7:0 ] rxdatarsch0,
	output [ 0:0 ] rxctlrsch0,
	input [ 0:0 ] rdenablesyncbotch2,
	input [ 7:0 ] txdatatcbotch2,
	input [ 0:0 ] txctltcbotch2,
	input [ 0:0 ] syncstatusbotch2,
	input [ 1:0 ] rdalignbotch2,
	input [ 1:0 ] aligndetsyncbotch2,
	input [ 0:0 ] fifordinbotch2,
	input [ 0:0 ] alignstatussyncbotch2,
	input [ 1:0 ] cgcomprddinbotch2,
	input [ 1:0 ] cgcompwrinbotch2,
	input [ 0:0 ] delcondmetinbotch2,
	input [ 0:0 ] fifoovrinbotch2,
	input [ 0:0 ] latencycompinbotch2,
	input [ 0:0 ] insertincompleteinbotch2,
	input [ 7:0 ] decdatabotch2,
	input [ 0:0 ] decctlbotch2,
	input [ 0:0 ] decdatavalidbotch2,
	input [ 1:0 ] runningdispbotch2,
	output [ 7:0 ] txdatatsbotch2,
	output [ 0:0 ] txctltsbotch2,
	output [ 0:0 ] fiforstrdqdbotch2,
	output [ 0:0 ] endskwqdbotch2,
	output [ 0:0 ] endskwrdptrsbotch2,
	output [ 0:0 ] alignstatusbotch2,
	output [ 0:0 ] alignstatussync0botch2,
	output [ 0:0 ] fifordoutcomp0botch2,
	output [ 0:0 ] cgcomprddallbotch2,
	output [ 0:0 ] cgcompwrallbotch2,
	output [ 0:0 ] delcondmet0botch2,
	output [ 0:0 ] insertincomplete0botch2,
	output [ 0:0 ] fifoovr0botch2,
	output [ 0:0 ] latencycomp0botch2,
	output [ 7:0 ] rxdatarsbotch2,
	output [ 0:0 ] rxctlrsbotch2,
	output [ 15:0 ] aggtestbusch0,
	input [ 0:0 ] txpcsrstn,
	output [ 0:0 ] dedicatedaggscanoutch2tieoff,
	input [ 0:0 ] dedicatedaggscaninch1,
	output [ 0:0 ] dedicatedaggscanoutch0tieoff,
	input [ 0:0 ] rxpcsrstn,
	output [ 15:0 ] aggtestbusch1,
	output [ 0:0 ] dedicatedaggscanoutch1,
	output [ 15:0 ] aggtestbusch2
); 

	stratixv_hssi_8g_pcs_aggregate_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.xaui_sm_operation(xaui_sm_operation),
		.dskw_sm_operation(dskw_sm_operation),
		.data_agg_bonding(data_agg_bonding),
		.prot_mode_tx(prot_mode_tx),
		.pcs_dw_datapath(pcs_dw_datapath),
		.dskw_control(dskw_control),
		.refclkdig_sel(refclkdig_sel),
		.agg_pwdn(agg_pwdn),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_8g_pcs_aggregate_encrypted_inst	(
		.refclkdig(refclkdig),
		.scanmoden(scanmoden),
		.scanshiftn(scanshiftn),
		.txpmaclk(txpmaclk),
		.rcvdclkch0(rcvdclkch0),
		.rcvdclkch1(rcvdclkch1),
		.dprioagg(dprioagg),
		.rcvdclkout(rcvdclkout),
		.rcvdclkouttop(rcvdclkouttop),
		.rcvdclkoutbot(rcvdclkoutbot),
		.rdenablesynctopch1(rdenablesynctopch1),
		.txdatatctopch1(txdatatctopch1),
		.txctltctopch1(txctltctopch1),
		.syncstatustopch1(syncstatustopch1),
		.rdaligntopch1(rdaligntopch1),
		.aligndetsynctopch1(aligndetsynctopch1),
		.fifordintopch1(fifordintopch1),
		.alignstatussynctopch1(alignstatussynctopch1),
		.cgcomprddintopch1(cgcomprddintopch1),
		.cgcompwrintopch1(cgcompwrintopch1),
		.delcondmetintopch1(delcondmetintopch1),
		.fifoovrintopch1(fifoovrintopch1),
		.latencycompintopch1(latencycompintopch1),
		.insertincompleteintopch1(insertincompleteintopch1),
		.decdatatopch1(decdatatopch1),
		.decctltopch1(decctltopch1),
		.decdatavalidtopch1(decdatavalidtopch1),
		.runningdisptopch1(runningdisptopch1),
		.txdatatstopch1(txdatatstopch1),
		.txctltstopch1(txctltstopch1),
		.fiforstrdqdtopch1(fiforstrdqdtopch1),
		.endskwqdtopch1(endskwqdtopch1),
		.endskwrdptrstopch1(endskwrdptrstopch1),
		.alignstatustopch1(alignstatustopch1),
		.alignstatussync0topch1(alignstatussync0topch1),
		.fifordoutcomp0topch1(fifordoutcomp0topch1),
		.cgcomprddalltopch1(cgcomprddalltopch1),
		.cgcompwralltopch1(cgcompwralltopch1),
		.delcondmet0topch1(delcondmet0topch1),
		.insertincomplete0topch1(insertincomplete0topch1),
		.fifoovr0topch1(fifoovr0topch1),
		.latencycomp0topch1(latencycomp0topch1),
		.rxdatarstopch1(rxdatarstopch1),
		.rxctlrstopch1(rxctlrstopch1),
		.rdenablesynctopch0(rdenablesynctopch0),
		.txdatatctopch0(txdatatctopch0),
		.txctltctopch0(txctltctopch0),
		.syncstatustopch0(syncstatustopch0),
		.rdaligntopch0(rdaligntopch0),
		.aligndetsynctopch0(aligndetsynctopch0),
		.fifordintopch0(fifordintopch0),
		.alignstatussynctopch0(alignstatussynctopch0),
		.cgcomprddintopch0(cgcomprddintopch0),
		.cgcompwrintopch0(cgcompwrintopch0),
		.delcondmetintopch0(delcondmetintopch0),
		.fifoovrintopch0(fifoovrintopch0),
		.latencycompintopch0(latencycompintopch0),
		.insertincompleteintopch0(insertincompleteintopch0),
		.decdatatopch0(decdatatopch0),
		.decctltopch0(decctltopch0),
		.decdatavalidtopch0(decdatavalidtopch0),
		.runningdisptopch0(runningdisptopch0),
		.txdatatstopch0(txdatatstopch0),
		.txctltstopch0(txctltstopch0),
		.fiforstrdqdtopch0(fiforstrdqdtopch0),
		.endskwqdtopch0(endskwqdtopch0),
		.endskwrdptrstopch0(endskwrdptrstopch0),
		.alignstatustopch0(alignstatustopch0),
		.alignstatussync0topch0(alignstatussync0topch0),
		.fifordoutcomp0topch0(fifordoutcomp0topch0),
		.cgcomprddalltopch0(cgcomprddalltopch0),
		.cgcompwralltopch0(cgcompwralltopch0),
		.delcondmet0topch0(delcondmet0topch0),
		.insertincomplete0topch0(insertincomplete0topch0),
		.fifoovr0topch0(fifoovr0topch0),
		.latencycomp0topch0(latencycomp0topch0),
		.rxdatarstopch0(rxdatarstopch0),
		.rxctlrstopch0(rxctlrstopch0),
		.rdenablesyncch2(rdenablesyncch2),
		.txdatatcch2(txdatatcch2),
		.txctltcch2(txctltcch2),
		.syncstatusch2(syncstatusch2),
		.rdalignch2(rdalignch2),
		.aligndetsyncch2(aligndetsyncch2),
		.fifordinch2(fifordinch2),
		.alignstatussyncch2(alignstatussyncch2),
		.cgcomprddinch2(cgcomprddinch2),
		.cgcompwrinch2(cgcompwrinch2),
		.delcondmetinch2(delcondmetinch2),
		.fifoovrinch2(fifoovrinch2),
		.latencycompinch2(latencycompinch2),
		.insertincompleteinch2(insertincompleteinch2),
		.decdatach2(decdatach2),
		.decctlch2(decctlch2),
		.decdatavalidch2(decdatavalidch2),
		.runningdispch2(runningdispch2),
		.txdatatsch2(txdatatsch2),
		.txctltsch2(txctltsch2),
		.fiforstrdqdch2(fiforstrdqdch2),
		.endskwqdch2(endskwqdch2),
		.endskwrdptrsch2(endskwrdptrsch2),
		.alignstatusch2(alignstatusch2),
		.alignstatussync0ch2(alignstatussync0ch2),
		.fifordoutcomp0ch2(fifordoutcomp0ch2),
		.cgcomprddallch2(cgcomprddallch2),
		.cgcompwrallch2(cgcompwrallch2),
		.delcondmet0ch2(delcondmet0ch2),
		.insertincomplete0ch2(insertincomplete0ch2),
		.fifoovr0ch2(fifoovr0ch2),
		.latencycomp0ch2(latencycomp0ch2),
		.rxdatarsch2(rxdatarsch2),
		.rxctlrsch2(rxctlrsch2),
		.rdenablesyncch1(rdenablesyncch1),
		.txdatatcch1(txdatatcch1),
		.txctltcch1(txctltcch1),
		.syncstatusch1(syncstatusch1),
		.rdalignch1(rdalignch1),
		.aligndetsyncch1(aligndetsyncch1),
		.fifordinch1(fifordinch1),
		.alignstatussyncch1(alignstatussyncch1),
		.cgcomprddinch1(cgcomprddinch1),
		.cgcompwrinch1(cgcompwrinch1),
		.delcondmetinch1(delcondmetinch1),
		.fifoovrinch1(fifoovrinch1),
		.latencycompinch1(latencycompinch1),
		.insertincompleteinch1(insertincompleteinch1),
		.decdatach1(decdatach1),
		.decctlch1(decctlch1),
		.decdatavalidch1(decdatavalidch1),
		.runningdispch1(runningdispch1),
		.txdatatsch1(txdatatsch1),
		.txctltsch1(txctltsch1),
		.fiforstrdqdch1(fiforstrdqdch1),
		.endskwqdch1(endskwqdch1),
		.endskwrdptrsch1(endskwrdptrsch1),
		.alignstatusch1(alignstatusch1),
		.alignstatussync0ch1(alignstatussync0ch1),
		.fifordoutcomp0ch1(fifordoutcomp0ch1),
		.cgcomprddallch1(cgcomprddallch1),
		.cgcompwrallch1(cgcompwrallch1),
		.delcondmet0ch1(delcondmet0ch1),
		.insertincomplete0ch1(insertincomplete0ch1),
		.fifoovr0ch1(fifoovr0ch1),
		.latencycomp0ch1(latencycomp0ch1),
		.rxdatarsch1(rxdatarsch1),
		.rxctlrsch1(rxctlrsch1),
		.rdenablesyncch0(rdenablesyncch0),
		.txdatatcch0(txdatatcch0),
		.txctltcch0(txctltcch0),
		.syncstatusch0(syncstatusch0),
		.rdalignch0(rdalignch0),
		.aligndetsyncch0(aligndetsyncch0),
		.fifordinch0(fifordinch0),
		.alignstatussyncch0(alignstatussyncch0),
		.cgcomprddinch0(cgcomprddinch0),
		.cgcompwrinch0(cgcompwrinch0),
		.delcondmetinch0(delcondmetinch0),
		.fifoovrinch0(fifoovrinch0),
		.latencycompinch0(latencycompinch0),
		.insertincompleteinch0(insertincompleteinch0),
		.decdatach0(decdatach0),
		.decctlch0(decctlch0),
		.decdatavalidch0(decdatavalidch0),
		.runningdispch0(runningdispch0),
		.txdatatsch0(txdatatsch0),
		.txctltsch0(txctltsch0),
		.fiforstrdqdch0(fiforstrdqdch0),
		.endskwqdch0(endskwqdch0),
		.endskwrdptrsch0(endskwrdptrsch0),
		.alignstatusch0(alignstatusch0),
		.alignstatussync0ch0(alignstatussync0ch0),
		.fifordoutcomp0ch0(fifordoutcomp0ch0),
		.cgcomprddallch0(cgcomprddallch0),
		.cgcompwrallch0(cgcompwrallch0),
		.delcondmet0ch0(delcondmet0ch0),
		.insertincomplete0ch0(insertincomplete0ch0),
		.fifoovr0ch0(fifoovr0ch0),
		.latencycomp0ch0(latencycomp0ch0),
		.rxdatarsch0(rxdatarsch0),
		.rxctlrsch0(rxctlrsch0),
		.rdenablesyncbotch2(rdenablesyncbotch2),
		.txdatatcbotch2(txdatatcbotch2),
		.txctltcbotch2(txctltcbotch2),
		.syncstatusbotch2(syncstatusbotch2),
		.rdalignbotch2(rdalignbotch2),
		.aligndetsyncbotch2(aligndetsyncbotch2),
		.fifordinbotch2(fifordinbotch2),
		.alignstatussyncbotch2(alignstatussyncbotch2),
		.cgcomprddinbotch2(cgcomprddinbotch2),
		.cgcompwrinbotch2(cgcompwrinbotch2),
		.delcondmetinbotch2(delcondmetinbotch2),
		.fifoovrinbotch2(fifoovrinbotch2),
		.latencycompinbotch2(latencycompinbotch2),
		.insertincompleteinbotch2(insertincompleteinbotch2),
		.decdatabotch2(decdatabotch2),
		.decctlbotch2(decctlbotch2),
		.decdatavalidbotch2(decdatavalidbotch2),
		.runningdispbotch2(runningdispbotch2),
		.txdatatsbotch2(txdatatsbotch2),
		.txctltsbotch2(txctltsbotch2),
		.fiforstrdqdbotch2(fiforstrdqdbotch2),
		.endskwqdbotch2(endskwqdbotch2),
		.endskwrdptrsbotch2(endskwrdptrsbotch2),
		.alignstatusbotch2(alignstatusbotch2),
		.alignstatussync0botch2(alignstatussync0botch2),
		.fifordoutcomp0botch2(fifordoutcomp0botch2),
		.cgcomprddallbotch2(cgcomprddallbotch2),
		.cgcompwrallbotch2(cgcompwrallbotch2),
		.delcondmet0botch2(delcondmet0botch2),
		.insertincomplete0botch2(insertincomplete0botch2),
		.fifoovr0botch2(fifoovr0botch2),
		.latencycomp0botch2(latencycomp0botch2),
		.rxdatarsbotch2(rxdatarsbotch2),
		.rxctlrsbotch2(rxctlrsbotch2),
		.aggtestbusch0(aggtestbusch0),
		.txpcsrstn(txpcsrstn),
		.dedicatedaggscanoutch2tieoff(dedicatedaggscanoutch2tieoff),
		.dedicatedaggscaninch1(dedicatedaggscaninch1),
		.dedicatedaggscanoutch0tieoff(dedicatedaggscanoutch0tieoff),
		.rxpcsrstn(rxpcsrstn),
		.aggtestbusch1(aggtestbusch1),
		.dedicatedaggscanoutch1(dedicatedaggscanoutch1),
		.aggtestbusch2(aggtestbusch2)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_8g_rx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_8g_rx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "basic",	//Valid values: pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter tx_rx_parallel_loopback = "dis_plpbk",	//Valid values: dis_plpbk|en_plpbk
	parameter pma_dw = "eight_bit",	//Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter pcs_bypass = "dis_pcs_bypass",	//Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter polarity_inversion = "dis_pol_inv",	//Valid values: dis_pol_inv|en_pol_inv
	parameter wa_pd = "wa_pd_10",	//Valid values: dont_care_wa_pd_0|dont_care_wa_pd_1|wa_pd_7|wa_pd_10|wa_pd_20|wa_pd_40|wa_pd_8_sw|wa_pd_8_dw|wa_pd_16_sw|wa_pd_16_dw|wa_pd_32|wa_pd_fixed_7_k28p5|wa_pd_fixed_10_k28p5|wa_pd_fixed_16_a1a2_sw|wa_pd_fixed_16_a1a2_dw|wa_pd_fixed_32_a1a1a2a2|prbs15_fixed_wa_pd_16_sw|prbs15_fixed_wa_pd_16_dw|prbs15_fixed_wa_pd_20_dw|prbs31_fixed_wa_pd_16_sw|prbs31_fixed_wa_pd_16_dw|prbs31_fixed_wa_pd_10_sw|prbs31_fixed_wa_pd_40_dw|prbs8_fixed_wa|prbs10_fixed_wa|prbs7_fixed_wa_pd_16_sw|prbs7_fixed_wa_pd_16_dw|prbs7_fixed_wa_pd_20_dw|prbs23_fixed_wa_pd_16_sw|prbs23_fixed_wa_pd_32_dw|prbs23_fixed_wa_pd_40_dw
	parameter wa_pd_data = 40'b0,	//Valid values: 40
	parameter wa_boundary_lock_ctrl = "bit_slip",	//Valid values: bit_slip|sync_sm|deterministic_latency|auto_align_pld_ctrl
	parameter wa_pld_controlled = "dis_pld_ctrl",	//Valid values: dis_pld_ctrl|pld_ctrl_sw|rising_edge_sensitive_dw|level_sensitive_dw
	parameter wa_sync_sm_ctrl = "gige_sync_sm",	//Valid values: gige_sync_sm|pipe_sync_sm|xaui_sync_sm|srio1p3_sync_sm|srio2p1_sync_sm|sw_basic_sync_sm|dw_basic_sync_sm|fibre_channel_sync_sm
	parameter wa_rknumber_data = 8'b0,	//Valid values: 8
	parameter wa_renumber_data = 6'b0,	//Valid values: 6
	parameter wa_rgnumber_data = 8'b0,	//Valid values: 8
	parameter wa_rosnumber_data = 2'b0,	//Valid values: 2
	parameter wa_kchar = "dis_kchar",	//Valid values: dis_kchar|en_kchar
	parameter wa_det_latency_sync_status_beh = "assert_sync_status_non_imm",	//Valid values: assert_sync_status_imm|assert_sync_status_non_imm|dont_care_assert_sync
	parameter wa_clk_slip_spacing = "min_clk_slip_spacing",	//Valid values: min_clk_slip_spacing|user_programmable_clk_slip_spacing
	parameter wa_clk_slip_spacing_data = 10'b10000,	//Valid values: 10
	parameter bit_reversal = "dis_bit_reversal",	//Valid values: dis_bit_reversal|en_bit_reversal
	parameter symbol_swap = "dis_symbol_swap",	//Valid values: dis_symbol_swap|en_symbol_swap
	parameter deskew_pattern = 10'b1101101000,	//Valid values: 10
	parameter deskew_prog_pattern_only = "en_deskew_prog_pat_only",	//Valid values: dis_deskew_prog_pat_only|en_deskew_prog_pat_only
	parameter rate_match = "dis_rm",	//Valid values: dis_rm|xaui_rm|gige_rm|pipe_rm|pipe_rm_0ppm|sw_basic_rm|srio_v2p1_rm|srio_v2p1_rm_0ppm|dw_basic_rm
	parameter eightb_tenb_decoder = "dis_8b10b",	//Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter err_flags_sel = "err_flags_wa",	//Valid values: err_flags_wa|err_flags_8b10b
	parameter polinv_8b10b_dec = "dis_polinv_8b10b_dec",	//Valid values: dis_polinv_8b10b_dec|en_polinv_8b10b_dec
	parameter eightbtenb_decoder_output_sel = "data_8b10b_decoder",	//Valid values: data_8b10b_decoder|data_xaui_sm
	parameter invalid_code_flag_only = "dis_invalid_code_only",	//Valid values: dis_invalid_code_only|en_invalid_code_only
	parameter auto_error_replacement = "dis_err_replace",	//Valid values: dis_err_replace|en_err_replace
	parameter pad_or_edb_error_replace = "replace_edb",	//Valid values: replace_edb|replace_pad|replace_edb_dynamic
	parameter byte_deserializer = "dis_bds",	//Valid values: dis_bds|en_bds_by_2|en_bds_by_4|en_bds_by_2_det
	parameter byte_order = "dis_bo",	//Valid values: dis_bo|en_pcs_ctrl_eight_bit_bo|en_pcs_ctrl_nine_bit_bo|en_pcs_ctrl_ten_bit_bo|en_pld_ctrl_eight_bit_bo|en_pld_ctrl_nine_bit_bo|en_pld_ctrl_ten_bit_bo
	parameter re_bo_on_wa = "dis_re_bo_on_wa",	//Valid values: dis_re_bo_on_wa|en_re_bo_on_wa
	parameter bo_pattern = 20'b0,	//Valid values: 20
	parameter bo_pad = 10'b0,	//Valid values: 10
	parameter phase_compensation_fifo = "low_latency",	//Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter prbs_ver = "dis_prbs",	//Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter cid_pattern = "cid_pattern_0",	//Valid values: cid_pattern_0|cid_pattern_1
	parameter cid_pattern_len = 8'b0,	//Valid values: 8
	parameter bist_ver = "dis_bist",	//Valid values: dis_bist|incremental|cjpat|crpat
	parameter cdr_ctrl = "dis_cdr_ctrl",	//Valid values: dis_cdr_ctrl|en_cdr_ctrl|en_cdr_ctrl_w_cid
	parameter cdr_ctrl_rxvalid_mask = "dis_rxvalid_mask",	//Valid values: dis_rxvalid_mask|en_rxvalid_mask
	parameter wait_cnt = 8'b0,	//Valid values: 8
	parameter mask_cnt = 10'h3ff,	//Valid values: 10
	parameter auto_deassert_pc_rst_cnt_data = 5'b0,	//Valid values: 5
	parameter auto_pc_en_cnt_data = 7'b0,	//Valid values: 7
	parameter eidle_entry_sd = "dis_eidle_sd",	//Valid values: dis_eidle_sd|en_eidle_sd
	parameter eidle_entry_eios = "dis_eidle_eios",	//Valid values: dis_eidle_eios|en_eidle_eios
	parameter eidle_entry_iei = "dis_eidle_iei",	//Valid values: dis_eidle_iei|en_eidle_iei
	parameter rx_rcvd_clk = "rcvd_clk_rcvd_clk",	//Valid values: rcvd_clk_rcvd_clk|tx_pma_clock_rcvd_clk
	parameter rx_clk1 = "rcvd_clk_clk1",	//Valid values: rcvd_clk_clk1|tx_pma_clock_clk1|rcvd_clk_agg_clk1|rcvd_clk_agg_top_or_bottom_clk1
	parameter rx_clk2 = "rcvd_clk_clk2",	//Valid values: rcvd_clk_clk2|tx_pma_clock_clk2|refclk_dig2_clk2
	parameter rx_rd_clk = "pld_rx_clk",	//Valid values: pld_rx_clk|rx_clk
	parameter dw_one_or_two_symbol_bo = "donot_care_one_two_bo",	//Valid values: donot_care_one_two_bo|one_symbol_bo|two_symbol_bo_eight_bit|two_symbol_bo_nine_bit|two_symbol_bo_ten_bit
	parameter comp_fifo_rst_pld_ctrl = "dis_comp_fifo_rst_pld_ctrl",	//Valid values: dis_comp_fifo_rst_pld_ctrl|en_comp_fifo_rst_pld_ctrl
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",	//Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter agg_block_sel = "same_smrt_pack",	//Valid values: same_smrt_pack|other_smrt_pack
	parameter test_bus_sel = "prbs_bist_testbus",	//Valid values: prbs_bist_testbus|tx_testbus|tx_ctrl_plane_testbus|wa_testbus|deskew_testbus|rm_testbus|rx_ctrl_testbus|pcie_ctrl_testbus|rx_ctrl_plane_testbus|agg_testbus
	parameter wa_rvnumber_data = 13'b0,	//Valid values: 13
	parameter ctrl_plane_bonding_compensation = "dis_compensation",	//Valid values: dis_compensation|en_compensation
	parameter prbs_ver_clr_flag = "dis_prbs_clr_flag",	//Valid values: dis_prbs_clr_flag|en_prbs_clr_flag
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",	//Valid values: master_chnl_distr|not_master_chnl_distr
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter pma_done_count = 18'b0,	//Valid values: 18
	parameter test_mode = "prbs",	//Valid values: dont_care_test|prbs|bist
	parameter bist_ver_clr_flag = "dis_bist_clr_flag",	//Valid values: dis_bist_clr_flag|en_bist_clr_flag
	parameter wa_disp_err_flag = "dis_disp_err_flag",	//Valid values: dis_disp_err_flag|en_disp_err_flag
	parameter wait_for_phfifo_cnt_data = 6'b0,	//Valid values: 6
	parameter runlength_check = "en_runlength_sw",	//Valid values: dis_runlength|en_runlength_sw|en_runlength_dw
	parameter runlength_val = 6'b0,	//Valid values: 6
	parameter force_signal_detect = "en_force_signal_detect",	//Valid values: en_force_signal_detect|dis_force_signal_detect
	parameter deskew = "dis_deskew",	//Valid values: dis_deskew|en_srio_v2p1|en_xaui
	parameter rx_wr_clk = "rx_clk2_div_1_2_4",	//Valid values: rx_clk2_div_1_2_4|txfifo_rd_clk
	parameter rx_clk_free_running = "en_rx_clk_free_run",	//Valid values: dis_rx_clk_free_run|en_rx_clk_free_run
	parameter rx_pcs_urst = "en_rx_pcs_urst",	//Valid values: dis_rx_pcs_urst|en_rx_pcs_urst
	parameter pipe_if_enable = "dis_pipe_rx",	//Valid values: dis_pipe_rx|en_pipe_rx|en_pipe3_rx
	parameter pc_fifo_rst_pld_ctrl = "dis_pc_fifo_rst_pld_ctrl",	//Valid values: dis_pc_fifo_rst_pld_ctrl|en_pc_fifo_rst_pld_ctrl
	parameter ibm_invalid_code = "dis_ibm_invalid_code",	//Valid values: dis_ibm_invalid_code|en_ibm_invalid_code
	parameter channel_number = 0,	//Valid values: 0..65
	parameter rx_refclk = "dis_refclk_sel",	//Valid values: dis_refclk_sel|en_refclk_sel
	parameter clock_gate_dw_rm_wr = "dis_dw_rm_wrclk_gating",	//Valid values: dis_dw_rm_wrclk_gating|en_dw_rm_wrclk_gating
	parameter clock_gate_bds_dec_asn = "dis_bds_dec_asn_clk_gating",	//Valid values: dis_bds_dec_asn_clk_gating|en_bds_dec_asn_clk_gating
	parameter fixed_pat_det = "dis_fixed_patdet",	//Valid values: dis_fixed_patdet|en_fixed_patdet
	parameter clock_gate_bist = "dis_bist_clk_gating",	//Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_cdr_eidle = "dis_cdr_eidle_clk_gating",	//Valid values: dis_cdr_eidle_clk_gating|en_cdr_eidle_clk_gating
	parameter clkcmp_pattern_p = 20'b0,	//Valid values: 20
	parameter clkcmp_pattern_n = 20'b0,	//Valid values: 20
	parameter clock_gate_prbs = "dis_prbs_clk_gating",	//Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter clock_gate_pc_rdclk = "dis_pc_rdclk_gating",	//Valid values: dis_pc_rdclk_gating|en_pc_rdclk_gating
	parameter wa_pd_polarity = "dis_pd_both_pol",	//Valid values: dis_pd_both_pol|en_pd_both_pol|dont_care_both_pol
	parameter clock_gate_dskw_rd = "dis_dskw_rdclk_gating",	//Valid values: dis_dskw_rdclk_gating|en_dskw_rdclk_gating
	parameter clock_gate_byteorder = "dis_byteorder_clk_gating",	//Valid values: dis_byteorder_clk_gating|en_byteorder_clk_gating
	parameter clock_gate_dw_pc_wrclk = "dis_dw_pc_wrclk_gating",	//Valid values: dis_dw_pc_wrclk_gating|en_dw_pc_wrclk_gating
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter clock_gate_sw_wa = "dis_sw_wa_clk_gating",	//Valid values: dis_sw_wa_clk_gating|en_sw_wa_clk_gating
	parameter clock_gate_dw_dskw_wr = "dis_dw_dskw_wrclk_gating",	//Valid values: dis_dw_dskw_wrclk_gating|en_dw_dskw_wrclk_gating
	parameter clock_gate_sw_pc_wrclk = "dis_sw_pc_wrclk_gating",	//Valid values: dis_sw_pc_wrclk_gating|en_sw_pc_wrclk_gating
	parameter clock_gate_sw_rm_rd = "dis_sw_rm_rdclk_gating",	//Valid values: dis_sw_rm_rdclk_gating|en_sw_rm_rdclk_gating
	parameter clock_gate_sw_rm_wr = "dis_sw_rm_wrclk_gating",	//Valid values: dis_sw_rm_wrclk_gating|en_sw_rm_wrclk_gating
	parameter auto_speed_nego = "dis_asn",	//Valid values: dis_asn|en_asn_g2_freq_scal|en_asn_g3
	parameter fixed_pat_num = 4'b1111,	//Valid values: 4
	parameter clock_gate_sw_dskw_wr = "dis_sw_dskw_wrclk_gating",	//Valid values: dis_sw_dskw_wrclk_gating|en_sw_dskw_wrclk_gating
	parameter clock_gate_dw_rm_rd = "dis_dw_rm_rdclk_gating",	//Valid values: dis_dw_rm_rdclk_gating|en_dw_rm_rdclk_gating
	parameter clock_gate_dw_wa = "dis_dw_wa_clk_gating",	//Valid values: dis_dw_wa_clk_gating|en_dw_wa_clk_gating
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] enablecommadetect,
	input [ 0:0 ] a1a2size,
	input [ 0:0 ] bitslip,
	input [ 0:0 ] rmfiforeadenable,
	input [ 0:0 ] rmfifowriteenable,
	input [ 0:0 ] pldrxclk,
	input [ 0:0 ] polinvrx,
	input [ 0:0 ] bitreversalenable,
	input [ 0:0 ] bytereversalenable,
	input [ 0:0 ] rcvdclkpma,
	input [ 19:0 ] datain,
	input [ 0:0 ] sigdetfrompma,
	input [ 0:0 ] fiforstrdqd,
	input [ 0:0 ] endskwqd,
	input [ 0:0 ] endskwrdptrs,
	input [ 0:0 ] alignstatus,
	input [ 0:0 ] fiforstrdqdtoporbot,
	input [ 0:0 ] endskwqdtoporbot,
	input [ 0:0 ] endskwrdptrstoporbot,
	input [ 0:0 ] alignstatustoporbot,
	input [ 7:0 ] datafrinaggblock,
	input [ 0:0 ] ctrlfromaggblock,
	input [ 7:0 ] rxdatarstoporbot,
	input [ 0:0 ] rxcontrolrstoporbot,
	input [ 19:0 ] parallelloopback,
	input [ 0:0 ] txpmaclk,
	input [ 0:0 ] byteorder,
	input [ 0:0 ] pxfifowrdisable,
	input [ 0:0 ] pcfifordenable,
	input [ 0:0 ] phystatusinternal,
	input [ 0:0 ] rxvalidinternal,
	input [ 2:0 ] rxstatusinternal,
	input [ 0:0 ] phystatuspcsgen3,
	input [ 0:0 ] rxvalidpcsgen3,
	input [ 2:0 ] rxstatuspcsgen3,
	input [ 3:0 ] rxdatavalidpcsgen3,
	input [ 3:0 ] rxblkstartpcsgen3,
	input [ 1:0 ] rxsynchdrpcsgen3,
	input [ 63:0 ] rxdatapcsgen3,
	input [ 0:0 ] rateswitchcontrol,
	input [ 0:0 ] gen2ngen1,
	input [ 2:0 ] eidleinfersel,
	input [ 0:0 ] pipeloopbk,
	input [ 0:0 ] pldltr,
	input [ 0:0 ] prbscidenable,
	input [ 0:0 ] alignstatussync0,
	input [ 0:0 ] rmfifordincomp0,
	input [ 0:0 ] cgcomprddall,
	input [ 0:0 ] cgcompwrall,
	input [ 0:0 ] delcondmet0,
	input [ 0:0 ] fifoovr0,
	input [ 0:0 ] latencycomp0,
	input [ 0:0 ] insertincomplete0,
	input [ 0:0 ] alignstatussync0toporbot,
	input [ 0:0 ] fifordincomp0toporbot,
	input [ 0:0 ] cgcomprddalltoporbot,
	input [ 0:0 ] cgcompwralltoporbot,
	input [ 0:0 ] delcondmet0toporbot,
	input [ 0:0 ] fifoovr0toporbot,
	input [ 0:0 ] latencycomp0toporbot,
	input [ 0:0 ] insertincomplete0toporbot,
	output [ 0:0 ] alignstatussync,
	output [ 0:0 ] fifordoutcomp,
	output [ 1:0 ] cgcomprddout,
	output [ 1:0 ] cgcompwrout,
	output [ 0:0 ] delcondmetout,
	output [ 0:0 ] fifoovrout,
	output [ 0:0 ] latencycompout,
	output [ 0:0 ] insertincompleteout,
	output [ 63:0 ] dataout,
	output [ 19:0 ] parallelrevloopback,
	output [ 0:0 ] clocktopld,
	output [ 0:0 ] bisterr,
	output [ 0:0 ] syncstatus,
	output [ 0:0 ] decoderdatavalid,
	output [ 7:0 ] decoderdata,
	output [ 0:0 ] decoderctrl,
	output [ 1:0 ] runningdisparity,
	output [ 0:0 ] selftestdone,
	output [ 0:0 ] selftesterr,
	output [ 15:0 ] errdata,
	output [ 1:0 ] errctrl,
	output [ 0:0 ] prbsdone,
	output [ 0:0 ] prbserrlt,
	output [ 0:0 ] signaldetectout,
	output [ 1:0 ] aligndetsync,
	output [ 1:0 ] rdalign,
	output [ 0:0 ] bistdone,
	output [ 0:0 ] runlengthviolation,
	output [ 0:0 ] rlvlt,
	output [ 0:0 ] rmfifopartialfull,
	output [ 0:0 ] rmfifofull,
	output [ 0:0 ] rmfifopartialempty,
	output [ 0:0 ] rmfifoempty,
	output [ 0:0 ] pcfifofull,
	output [ 0:0 ] pcfifoempty,
	output [ 3:0 ] a1a2k1k2flag,
	output [ 0:0 ] byteordflag,
	output [ 0:0 ] rxpipeclk,
	output [ 19:0 ] channeltestbusout,
	output [ 0:0 ] rxpipesoftreset,
	output [ 0:0 ] phystatus,
	output [ 0:0 ] rxvalid,
	output [ 2:0 ] rxstatus,
	output [ 63:0 ] pipedata,
	output [ 3:0 ] rxdatavalid,
	output [ 3:0 ] rxblkstart,
	output [ 1:0 ] rxsynchdr,
	output [ 0:0 ] speedchange,
	output [ 0:0 ] eidledetected,
	output [ 4:0 ] wordalignboundary,
	output [ 0:0 ] rxclkslip,
	output [ 0:0 ] eidleexit,
	output [ 0:0 ] earlyeios,
	output [ 0:0 ] ltr,
	input [ 1:0 ] rxdivsyncinchnlup,
	input [ 1:0 ] rxdivsyncinchnldown,
	input [ 0:0 ] wrenableinchnlup,
	input [ 0:0 ] wrenableinchnldown,
	input [ 0:0 ] rdenableinchnlup,
	input [ 0:0 ] rdenableinchnldown,
	input [ 1:0 ] rxweinchnlup,
	input [ 1:0 ] rxweinchnldown,
	input [ 0:0 ] resetpcptrsinchnlup,
	input [ 0:0 ] resetpcptrsinchnldown,
	input [ 0:0 ] configselinchnlup,
	input [ 0:0 ] configselinchnldown,
	input [ 0:0 ] speedchangeinchnlup,
	input [ 0:0 ] speedchangeinchnldown,
	output [ 0:0 ] pcieswitch,
	output [ 1:0 ] rxdivsyncoutchnlup,
	output [ 1:0 ] rxweoutchnlup,
	output [ 0:0 ] wrenableoutchnlup,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] resetpcptrsoutchnlup,
	output [ 0:0 ] speedchangeoutchnlup,
	output [ 0:0 ] configseloutchnlup,
	output [ 1:0 ] rxdivsyncoutchnldown,
	output [ 1:0 ] rxweoutchnldown,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] resetpcptrsoutchnldown,
	output [ 0:0 ] speedchangeoutchnldown,
	output [ 0:0 ] configseloutchnldown,
	output [ 0:0 ] resetpcptrsinchnluppipe,
	output [ 0:0 ] resetpcptrsinchnldownpipe,
	output [ 0:0 ] speedchangeinchnluppipe,
	output [ 0:0 ] speedchangeinchnldownpipe,
	output [ 0:0 ] disablepcfifobyteserdes,
	output [ 0:0 ] resetpcptrs,
	input [ 0:0 ] rcvdclkagg,
	input [ 0:0 ] rcvdclkaggtoporbot,
	input [ 0:0 ] dispcbytegen3,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] resetpcptrsgen3,
	output [ 0:0 ] syncdatain,
	output [ 0:0 ] observablebyteserdesclock,
	input [ 0:0 ] dynclkswitchn,
	output [ 0:0 ] resetppmcntrsoutchnldown,
	input [ 15:0 ] aggtestbus,
	input [ 0:0 ] refclkdig2,
	input [ 19:0 ] txtestbus,
	output [ 0:0 ] aggrxpcsrst,
	input [ 0:0 ] resetppmcntrsinchnlup,
	input [ 1:0 ] txdivsync,
	input [ 0:0 ] resetppmcntrsinchnldown,
	input [ 0:0 ] pcieswitchgen3,
	input [ 19:0 ] txctrlplanetestbus,
	input [ 0:0 ] phfifouserrst,
	output [ 0:0 ] rxclkoutgen3,
	input [ 0:0 ] hrdrst,
	input [ 0:0 ] rmfifouserrst,
	output [ 0:0 ] alignstatuspld,
	input [ 0:0 ] resetppmcntrsgen3,
	input [ 0:0 ] syncsmen,
	output [ 0:0 ] resetppmcntrsoutchnlup,
	input [ 0:0 ] rxpcsrst,
	output [ 0:0 ] resetppmcntrspcspma,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 0:0 ] scanmode
); 

	stratixv_hssi_8g_rx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.tx_rx_parallel_loopback(tx_rx_parallel_loopback),
		.pma_dw(pma_dw),
		.pcs_bypass(pcs_bypass),
		.polarity_inversion(polarity_inversion),
		.wa_pd(wa_pd),
		.wa_pd_data(wa_pd_data),
		.wa_boundary_lock_ctrl(wa_boundary_lock_ctrl),
		.wa_pld_controlled(wa_pld_controlled),
		.wa_sync_sm_ctrl(wa_sync_sm_ctrl),
		.wa_rknumber_data(wa_rknumber_data),
		.wa_renumber_data(wa_renumber_data),
		.wa_rgnumber_data(wa_rgnumber_data),
		.wa_rosnumber_data(wa_rosnumber_data),
		.wa_kchar(wa_kchar),
		.wa_det_latency_sync_status_beh(wa_det_latency_sync_status_beh),
		.wa_clk_slip_spacing(wa_clk_slip_spacing),
		.wa_clk_slip_spacing_data(wa_clk_slip_spacing_data),
		.bit_reversal(bit_reversal),
		.symbol_swap(symbol_swap),
		.deskew_pattern(deskew_pattern),
		.deskew_prog_pattern_only(deskew_prog_pattern_only),
		.rate_match(rate_match),
		.eightb_tenb_decoder(eightb_tenb_decoder),
		.err_flags_sel(err_flags_sel),
		.polinv_8b10b_dec(polinv_8b10b_dec),
		.eightbtenb_decoder_output_sel(eightbtenb_decoder_output_sel),
		.invalid_code_flag_only(invalid_code_flag_only),
		.auto_error_replacement(auto_error_replacement),
		.pad_or_edb_error_replace(pad_or_edb_error_replace),
		.byte_deserializer(byte_deserializer),
		.byte_order(byte_order),
		.re_bo_on_wa(re_bo_on_wa),
		.bo_pattern(bo_pattern),
		.bo_pad(bo_pad),
		.phase_compensation_fifo(phase_compensation_fifo),
		.prbs_ver(prbs_ver),
		.cid_pattern(cid_pattern),
		.cid_pattern_len(cid_pattern_len),
		.bist_ver(bist_ver),
		.cdr_ctrl(cdr_ctrl),
		.cdr_ctrl_rxvalid_mask(cdr_ctrl_rxvalid_mask),
		.wait_cnt(wait_cnt),
		.mask_cnt(mask_cnt),
		.auto_deassert_pc_rst_cnt_data(auto_deassert_pc_rst_cnt_data),
		.auto_pc_en_cnt_data(auto_pc_en_cnt_data),
		.eidle_entry_sd(eidle_entry_sd),
		.eidle_entry_eios(eidle_entry_eios),
		.eidle_entry_iei(eidle_entry_iei),
		.rx_rcvd_clk(rx_rcvd_clk),
		.rx_clk1(rx_clk1),
		.rx_clk2(rx_clk2),
		.rx_rd_clk(rx_rd_clk),
		.dw_one_or_two_symbol_bo(dw_one_or_two_symbol_bo),
		.comp_fifo_rst_pld_ctrl(comp_fifo_rst_pld_ctrl),
		.bypass_pipeline_reg(bypass_pipeline_reg),
		.agg_block_sel(agg_block_sel),
		.test_bus_sel(test_bus_sel),
		.wa_rvnumber_data(wa_rvnumber_data),
		.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
		.prbs_ver_clr_flag(prbs_ver_clr_flag),
		.hip_mode(hip_mode),
		.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.pma_done_count(pma_done_count),
		.test_mode(test_mode),
		.bist_ver_clr_flag(bist_ver_clr_flag),
		.wa_disp_err_flag(wa_disp_err_flag),
		.wait_for_phfifo_cnt_data(wait_for_phfifo_cnt_data),
		.runlength_check(runlength_check),
		.runlength_val(runlength_val),
		.force_signal_detect(force_signal_detect),
		.deskew(deskew),
		.rx_wr_clk(rx_wr_clk),
		.rx_clk_free_running(rx_clk_free_running),
		.rx_pcs_urst(rx_pcs_urst),
		.pipe_if_enable(pipe_if_enable),
		.pc_fifo_rst_pld_ctrl(pc_fifo_rst_pld_ctrl),
		.ibm_invalid_code(ibm_invalid_code),
		.channel_number(channel_number),
		.rx_refclk(rx_refclk),
		.clock_gate_dw_rm_wr(clock_gate_dw_rm_wr),
		.clock_gate_bds_dec_asn(clock_gate_bds_dec_asn),
		.fixed_pat_det(fixed_pat_det),
		.clock_gate_bist(clock_gate_bist),
		.clock_gate_cdr_eidle(clock_gate_cdr_eidle),
		.clkcmp_pattern_p(clkcmp_pattern_p),
		.clkcmp_pattern_n(clkcmp_pattern_n),
		.clock_gate_prbs(clock_gate_prbs),
		.clock_gate_pc_rdclk(clock_gate_pc_rdclk),
		.wa_pd_polarity(wa_pd_polarity),
		.clock_gate_dskw_rd(clock_gate_dskw_rd),
		.clock_gate_byteorder(clock_gate_byteorder),
		.clock_gate_dw_pc_wrclk(clock_gate_dw_pc_wrclk),
		.sup_mode(sup_mode),
		.clock_gate_sw_wa(clock_gate_sw_wa),
		.clock_gate_dw_dskw_wr(clock_gate_dw_dskw_wr),
		.clock_gate_sw_pc_wrclk(clock_gate_sw_pc_wrclk),
		.clock_gate_sw_rm_rd(clock_gate_sw_rm_rd),
		.clock_gate_sw_rm_wr(clock_gate_sw_rm_wr),
		.auto_speed_nego(auto_speed_nego),
		.fixed_pat_num(fixed_pat_num),
		.clock_gate_sw_dskw_wr(clock_gate_sw_dskw_wr),
		.clock_gate_dw_rm_rd(clock_gate_dw_rm_rd),
		.clock_gate_dw_wa(clock_gate_dw_wa),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_8g_rx_pcs_encrypted_inst	(
		.enablecommadetect(enablecommadetect),
		.a1a2size(a1a2size),
		.bitslip(bitslip),
		.rmfiforeadenable(rmfiforeadenable),
		.rmfifowriteenable(rmfifowriteenable),
		.pldrxclk(pldrxclk),
		.polinvrx(polinvrx),
		.bitreversalenable(bitreversalenable),
		.bytereversalenable(bytereversalenable),
		.rcvdclkpma(rcvdclkpma),
		.datain(datain),
		.sigdetfrompma(sigdetfrompma),
		.fiforstrdqd(fiforstrdqd),
		.endskwqd(endskwqd),
		.endskwrdptrs(endskwrdptrs),
		.alignstatus(alignstatus),
		.fiforstrdqdtoporbot(fiforstrdqdtoporbot),
		.endskwqdtoporbot(endskwqdtoporbot),
		.endskwrdptrstoporbot(endskwrdptrstoporbot),
		.alignstatustoporbot(alignstatustoporbot),
		.datafrinaggblock(datafrinaggblock),
		.ctrlfromaggblock(ctrlfromaggblock),
		.rxdatarstoporbot(rxdatarstoporbot),
		.rxcontrolrstoporbot(rxcontrolrstoporbot),
		.parallelloopback(parallelloopback),
		.txpmaclk(txpmaclk),
		.byteorder(byteorder),
		.pxfifowrdisable(pxfifowrdisable),
		.pcfifordenable(pcfifordenable),
		.phystatusinternal(phystatusinternal),
		.rxvalidinternal(rxvalidinternal),
		.rxstatusinternal(rxstatusinternal),
		.phystatuspcsgen3(phystatuspcsgen3),
		.rxvalidpcsgen3(rxvalidpcsgen3),
		.rxstatuspcsgen3(rxstatuspcsgen3),
		.rxdatavalidpcsgen3(rxdatavalidpcsgen3),
		.rxblkstartpcsgen3(rxblkstartpcsgen3),
		.rxsynchdrpcsgen3(rxsynchdrpcsgen3),
		.rxdatapcsgen3(rxdatapcsgen3),
		.rateswitchcontrol(rateswitchcontrol),
		.gen2ngen1(gen2ngen1),
		.eidleinfersel(eidleinfersel),
		.pipeloopbk(pipeloopbk),
		.pldltr(pldltr),
		.prbscidenable(prbscidenable),
		.alignstatussync0(alignstatussync0),
		.rmfifordincomp0(rmfifordincomp0),
		.cgcomprddall(cgcomprddall),
		.cgcompwrall(cgcompwrall),
		.delcondmet0(delcondmet0),
		.fifoovr0(fifoovr0),
		.latencycomp0(latencycomp0),
		.insertincomplete0(insertincomplete0),
		.alignstatussync0toporbot(alignstatussync0toporbot),
		.fifordincomp0toporbot(fifordincomp0toporbot),
		.cgcomprddalltoporbot(cgcomprddalltoporbot),
		.cgcompwralltoporbot(cgcompwralltoporbot),
		.delcondmet0toporbot(delcondmet0toporbot),
		.fifoovr0toporbot(fifoovr0toporbot),
		.latencycomp0toporbot(latencycomp0toporbot),
		.insertincomplete0toporbot(insertincomplete0toporbot),
		.alignstatussync(alignstatussync),
		.fifordoutcomp(fifordoutcomp),
		.cgcomprddout(cgcomprddout),
		.cgcompwrout(cgcompwrout),
		.delcondmetout(delcondmetout),
		.fifoovrout(fifoovrout),
		.latencycompout(latencycompout),
		.insertincompleteout(insertincompleteout),
		.dataout(dataout),
		.parallelrevloopback(parallelrevloopback),
		.clocktopld(clocktopld),
		.bisterr(bisterr),
		.syncstatus(syncstatus),
		.decoderdatavalid(decoderdatavalid),
		.decoderdata(decoderdata),
		.decoderctrl(decoderctrl),
		.runningdisparity(runningdisparity),
		.selftestdone(selftestdone),
		.selftesterr(selftesterr),
		.errdata(errdata),
		.errctrl(errctrl),
		.prbsdone(prbsdone),
		.prbserrlt(prbserrlt),
		.signaldetectout(signaldetectout),
		.aligndetsync(aligndetsync),
		.rdalign(rdalign),
		.bistdone(bistdone),
		.runlengthviolation(runlengthviolation),
		.rlvlt(rlvlt),
		.rmfifopartialfull(rmfifopartialfull),
		.rmfifofull(rmfifofull),
		.rmfifopartialempty(rmfifopartialempty),
		.rmfifoempty(rmfifoempty),
		.pcfifofull(pcfifofull),
		.pcfifoempty(pcfifoempty),
		.a1a2k1k2flag(a1a2k1k2flag),
		.byteordflag(byteordflag),
		.rxpipeclk(rxpipeclk),
		.channeltestbusout(channeltestbusout),
		.rxpipesoftreset(rxpipesoftreset),
		.phystatus(phystatus),
		.rxvalid(rxvalid),
		.rxstatus(rxstatus),
		.pipedata(pipedata),
		.rxdatavalid(rxdatavalid),
		.rxblkstart(rxblkstart),
		.rxsynchdr(rxsynchdr),
		.speedchange(speedchange),
		.eidledetected(eidledetected),
		.wordalignboundary(wordalignboundary),
		.rxclkslip(rxclkslip),
		.eidleexit(eidleexit),
		.earlyeios(earlyeios),
		.ltr(ltr),
		.rxdivsyncinchnlup(rxdivsyncinchnlup),
		.rxdivsyncinchnldown(rxdivsyncinchnldown),
		.wrenableinchnlup(wrenableinchnlup),
		.wrenableinchnldown(wrenableinchnldown),
		.rdenableinchnlup(rdenableinchnlup),
		.rdenableinchnldown(rdenableinchnldown),
		.rxweinchnlup(rxweinchnlup),
		.rxweinchnldown(rxweinchnldown),
		.resetpcptrsinchnlup(resetpcptrsinchnlup),
		.resetpcptrsinchnldown(resetpcptrsinchnldown),
		.configselinchnlup(configselinchnlup),
		.configselinchnldown(configselinchnldown),
		.speedchangeinchnlup(speedchangeinchnlup),
		.speedchangeinchnldown(speedchangeinchnldown),
		.pcieswitch(pcieswitch),
		.rxdivsyncoutchnlup(rxdivsyncoutchnlup),
		.rxweoutchnlup(rxweoutchnlup),
		.wrenableoutchnlup(wrenableoutchnlup),
		.rdenableoutchnlup(rdenableoutchnlup),
		.resetpcptrsoutchnlup(resetpcptrsoutchnlup),
		.speedchangeoutchnlup(speedchangeoutchnlup),
		.configseloutchnlup(configseloutchnlup),
		.rxdivsyncoutchnldown(rxdivsyncoutchnldown),
		.rxweoutchnldown(rxweoutchnldown),
		.wrenableoutchnldown(wrenableoutchnldown),
		.rdenableoutchnldown(rdenableoutchnldown),
		.resetpcptrsoutchnldown(resetpcptrsoutchnldown),
		.speedchangeoutchnldown(speedchangeoutchnldown),
		.configseloutchnldown(configseloutchnldown),
		.resetpcptrsinchnluppipe(resetpcptrsinchnluppipe),
		.resetpcptrsinchnldownpipe(resetpcptrsinchnldownpipe),
		.speedchangeinchnluppipe(speedchangeinchnluppipe),
		.speedchangeinchnldownpipe(speedchangeinchnldownpipe),
		.disablepcfifobyteserdes(disablepcfifobyteserdes),
		.resetpcptrs(resetpcptrs),
		.rcvdclkagg(rcvdclkagg),
		.rcvdclkaggtoporbot(rcvdclkaggtoporbot),
		.dispcbytegen3(dispcbytegen3),
		.refclkdig(refclkdig),
		.resetpcptrsgen3(resetpcptrsgen3),
		.syncdatain(syncdatain),
		.observablebyteserdesclock(observablebyteserdesclock),
		.dynclkswitchn(dynclkswitchn),
		.resetppmcntrsoutchnldown(resetppmcntrsoutchnldown),
		.aggtestbus(aggtestbus),
		.refclkdig2(refclkdig2),
		.txtestbus(txtestbus),
		.aggrxpcsrst(aggrxpcsrst),
		.resetppmcntrsinchnlup(resetppmcntrsinchnlup),
		.txdivsync(txdivsync),
		.resetppmcntrsinchnldown(resetppmcntrsinchnldown),
		.pcieswitchgen3(pcieswitchgen3),
		.txctrlplanetestbus(txctrlplanetestbus),
		.phfifouserrst(phfifouserrst),
		.rxclkoutgen3(rxclkoutgen3),
		.hrdrst(hrdrst),
		.rmfifouserrst(rmfifouserrst),
		.alignstatuspld(alignstatuspld),
		.resetppmcntrsgen3(resetppmcntrsgen3),
		.syncsmen(syncsmen),
		.resetppmcntrsoutchnlup(resetppmcntrsoutchnlup),
		.rxpcsrst(rxpcsrst),
		.resetppmcntrspcspma(resetppmcntrspcspma),
		.avmmclk(avmmclk),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.scanmode(scanmode)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_8g_tx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_8g_tx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "basic",	//Valid values: pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter pma_dw = "eight_bit",	//Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter pcs_bypass = "dis_pcs_bypass",	//Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter phase_compensation_fifo = "low_latency",	//Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter tx_compliance_controlled_disparity = "dis_txcompliance",	//Valid values: dis_txcompliance|en_txcompliance_pipe2p0|en_txcompliance_pipe3p0
	parameter force_kchar = "dis_force_kchar",	//Valid values: dis_force_kchar|en_force_kchar
	parameter force_echar = "dis_force_echar",	//Valid values: dis_force_echar|en_force_echar
	parameter byte_serializer = "dis_bs",	//Valid values: dis_bs|en_bs_by_2|en_bs_by_4
	parameter data_selection_8b10b_encoder_input = "normal_data_path",	//Valid values: normal_data_path|xaui_sm|gige_idle_conversion
	parameter eightb_tenb_disp_ctrl = "dis_disp_ctrl",	//Valid values: dis_disp_ctrl|en_disp_ctrl|en_ib_disp_ctrl
	parameter eightb_tenb_encoder = "dis_8b10b",	//Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter prbs_gen = "dis_prbs",	//Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter cid_pattern = "cid_pattern_0",	//Valid values: cid_pattern_0|cid_pattern_1
	parameter cid_pattern_len = 8'b0,	//Valid values: 8
	parameter bist_gen = "dis_bist",	//Valid values: dis_bist|incremental|cjpat|crpat
	parameter bit_reversal = "dis_bit_reversal",	//Valid values: dis_bit_reversal|en_bit_reversal
	parameter symbol_swap = "dis_symbol_swap",	//Valid values: dis_symbol_swap|en_symbol_swap
	parameter polarity_inversion = "dis_polinv",	//Valid values: dis_polinv|enable_polinv
	parameter tx_bitslip = "dis_tx_bitslip",	//Valid values: dis_tx_bitslip|en_tx_bitslip
	parameter agg_block_sel = "same_smrt_pack",	//Valid values: same_smrt_pack|other_smrt_pack
	parameter revloop_back_rm = "dis_rev_loopback_rx_rm",	//Valid values: dis_rev_loopback_rx_rm|en_rev_loopback_rx_rm
	parameter phfifo_write_clk_sel = "pld_tx_clk",	//Valid values: pld_tx_clk|tx_clk
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",	//Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",	//Valid values: master_chnl_distr|not_master_chnl_distr
	parameter test_mode = "prbs",	//Valid values: dont_care_test|prbs|bist
	parameter ctrl_plane_bonding_compensation = "dis_compensation",	//Valid values: dis_compensation|en_compensation
	parameter refclk_b_clk_sel = "tx_pma_clock",	//Valid values: tx_pma_clock|refclk_dig
	parameter auto_speed_nego_gen2 = "dis_auto_speed_nego_g2",	//Valid values: dis_asn_g2|en_asn_g2_freq_scal|dis_auto_speed_nego_g2|en_freq_scaling_g2|en_data_width_scaling_g2
	parameter channel_number = 0,	//Valid values: 0..65
	parameter txpcs_urst = "en_txpcs_urst",	//Valid values: dis_txpcs_urst|en_txpcs_urst
	parameter clock_gate_dw_fifowr = "dis_dw_fifowr_clk_gating",	//Valid values: dis_dw_fifowr_clk_gating|en_dw_fifowr_clk_gating
	parameter clock_gate_prbs = "dis_prbs_clk_gating",	//Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter txclk_freerun = "en_freerun_tx",	//Valid values: dis_freerun_tx|en_freerun_tx
	parameter clock_gate_bs_enc = "dis_bs_enc_clk_gating",	//Valid values: dis_bs_enc_clk_gating|en_bs_enc_clk_gating
	parameter clock_gate_bist = "dis_bist_clk_gating",	//Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_fiford = "dis_fiford_clk_gating",	//Valid values: dis_fiford_clk_gating|en_fiford_clk_gating
	parameter pcfifo_urst = "dis_pcfifourst",	//Valid values: dis_pcfifourst|en_pcfifourst
	parameter clock_gate_sw_fifowr = "dis_sw_fifowr_clk_gating",	//Valid values: dis_sw_fifowr_clk_gating|en_sw_fifowr_clk_gating
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter dynamic_clk_switch = "dis_dyn_clk_switch",	//Valid values: dis_dyn_clk_switch|en_dyn_clk_switch
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] refclkdig,
	input [ 43:0 ] datain,
	input [ 0:0 ] coreclk,
	input [ 0:0 ] invpol,
	input [ 7:0 ] xgmdatain,
	input [ 0:0 ] xgmctrl,
	input [ 7:0 ] xgmdataintoporbottom,
	input [ 0:0 ] xgmctrltoporbottom,
	input [ 0:0 ] txpmalocalclk,
	input [ 0:0 ] enrevparallellpbk,
	input [ 19:0 ] revparallellpbkdata,
	input [ 0:0 ] phfifowrenable,
	input [ 0:0 ] phfiforddisable,
	input [ 0:0 ] detectrxloopin,
	input [ 1:0 ] powerdn,
	input [ 0:0 ] pipeenrevparallellpbkin,
	input [ 0:0 ] pipetxswing,
	input [ 0:0 ] pipetxdeemph,
	input [ 2:0 ] pipetxmargin,
	input [ 0:0 ] rxpolarityin,
	input [ 0:0 ] polinvrxin,
	input [ 2:0 ] elecidleinfersel,
	input [ 0:0 ] rateswitch,
	input [ 0:0 ] prbscidenable,
	input [ 4:0 ] bitslipboundaryselect,
	output [ 0:0 ] phfifooverflow,
	output [ 0:0 ] phfifounderflow,
	output [ 0:0 ] clkout,
	output [ 0:0 ] clkoutgen3,
	output [ 7:0 ] xgmdataout,
	output [ 0:0 ] xgmctrlenable,
	output [ 19:0 ] dataout,
	output [ 0:0 ] rdenablesync,
	output [ 0:0 ] refclkb,
	output [ 19:0 ] parallelfdbkout,
	output [ 0:0 ] txpipeclk,
	output [ 0:0 ] txpipesoftreset,
	output [ 0:0 ] txpipeelectidle,
	output [ 0:0 ] detectrxloopout,
	output [ 1:0 ] pipepowerdownout,
	output [ 0:0 ] pipeenrevparallellpbkout,
	output [ 0:0 ] phfifotxswing,
	output [ 0:0 ] phfifotxdeemph,
	output [ 2:0 ] phfifotxmargin,
	output [ 31:0 ] txdataouttogen3,
	output [ 3:0 ] txdatakouttogen3,
	output [ 3:0 ] txdatavalidouttogen3,
	output [ 3:0 ] txblkstartout,
	output [ 1:0 ] txsynchdrout,
	output [ 0:0 ] txcomplianceout,
	output [ 0:0 ] txelecidleout,
	output [ 0:0 ] rxpolarityout,
	output [ 0:0 ] polinvrxout,
	output [ 2:0 ] grayelecidleinferselout,
	input [ 1:0 ] txdivsyncinchnlup,
	input [ 1:0 ] txdivsyncinchnldown,
	input [ 0:0 ] wrenableinchnlup,
	input [ 0:0 ] wrenableinchnldown,
	input [ 0:0 ] rdenableinchnlup,
	input [ 0:0 ] rdenableinchnldown,
	input [ 1:0 ] fifoselectinchnlup,
	input [ 1:0 ] fifoselectinchnldown,
	input [ 0:0 ] resetpcptrs,
	input [ 0:0 ] resetpcptrsinchnlup,
	input [ 0:0 ] resetpcptrsinchnldown,
	input [ 0:0 ] dispcbyte,
	output [ 1:0 ] txdivsyncoutchnlup,
	output [ 1:0 ] txdivsyncoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 1:0 ] fifoselectoutchnlup,
	output [ 1:0 ] fifoselectoutchnldown,
	output [ 0:0 ] syncdatain,
	output [ 0:0 ] observablebyteserdesclock,
	input [ 3:0 ] txblkstart,
	input [ 0:0 ] phfiforeset,
	input [ 0:0 ] txpcsreset,
	output [ 0:0 ] dynclkswitchn,
	input [ 3:0 ] txdatavalid,
	output [ 19:0 ] txctrlplanetestbus,
	output [ 0:0 ] refclkbreset,
	input [ 0:0 ] clkselgen3,
	output [ 0:0 ] aggtxpcsrst,
	input [ 0:0 ] hrdrst,
	output [ 1:0 ] txdivsync,
	output [ 19:0 ] txtestbus,
	input [ 1:0 ] txsynchdr,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 0:0 ] scanmode
); 

	stratixv_hssi_8g_tx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.hip_mode(hip_mode),
		.pma_dw(pma_dw),
		.pcs_bypass(pcs_bypass),
		.phase_compensation_fifo(phase_compensation_fifo),
		.tx_compliance_controlled_disparity(tx_compliance_controlled_disparity),
		.force_kchar(force_kchar),
		.force_echar(force_echar),
		.byte_serializer(byte_serializer),
		.data_selection_8b10b_encoder_input(data_selection_8b10b_encoder_input),
		.eightb_tenb_disp_ctrl(eightb_tenb_disp_ctrl),
		.eightb_tenb_encoder(eightb_tenb_encoder),
		.prbs_gen(prbs_gen),
		.cid_pattern(cid_pattern),
		.cid_pattern_len(cid_pattern_len),
		.bist_gen(bist_gen),
		.bit_reversal(bit_reversal),
		.symbol_swap(symbol_swap),
		.polarity_inversion(polarity_inversion),
		.tx_bitslip(tx_bitslip),
		.agg_block_sel(agg_block_sel),
		.revloop_back_rm(revloop_back_rm),
		.phfifo_write_clk_sel(phfifo_write_clk_sel),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.bypass_pipeline_reg(bypass_pipeline_reg),
		.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
		.test_mode(test_mode),
		.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
		.refclk_b_clk_sel(refclk_b_clk_sel),
		.auto_speed_nego_gen2(auto_speed_nego_gen2),
		.channel_number(channel_number),
		.txpcs_urst(txpcs_urst),
		.clock_gate_dw_fifowr(clock_gate_dw_fifowr),
		.clock_gate_prbs(clock_gate_prbs),
		.txclk_freerun(txclk_freerun),
		.clock_gate_bs_enc(clock_gate_bs_enc),
		.clock_gate_bist(clock_gate_bist),
		.clock_gate_fiford(clock_gate_fiford),
		.pcfifo_urst(pcfifo_urst),
		.clock_gate_sw_fifowr(clock_gate_sw_fifowr),
		.sup_mode(sup_mode),
		.dynamic_clk_switch(dynamic_clk_switch),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_8g_tx_pcs_encrypted_inst	(
		.refclkdig(refclkdig),
		.datain(datain),
		.coreclk(coreclk),
		.invpol(invpol),
		.xgmdatain(xgmdatain),
		.xgmctrl(xgmctrl),
		.xgmdataintoporbottom(xgmdataintoporbottom),
		.xgmctrltoporbottom(xgmctrltoporbottom),
		.txpmalocalclk(txpmalocalclk),
		.enrevparallellpbk(enrevparallellpbk),
		.revparallellpbkdata(revparallellpbkdata),
		.phfifowrenable(phfifowrenable),
		.phfiforddisable(phfiforddisable),
		.detectrxloopin(detectrxloopin),
		.powerdn(powerdn),
		.pipeenrevparallellpbkin(pipeenrevparallellpbkin),
		.pipetxswing(pipetxswing),
		.pipetxdeemph(pipetxdeemph),
		.pipetxmargin(pipetxmargin),
		.rxpolarityin(rxpolarityin),
		.polinvrxin(polinvrxin),
		.elecidleinfersel(elecidleinfersel),
		.rateswitch(rateswitch),
		.prbscidenable(prbscidenable),
		.bitslipboundaryselect(bitslipboundaryselect),
		.phfifooverflow(phfifooverflow),
		.phfifounderflow(phfifounderflow),
		.clkout(clkout),
		.clkoutgen3(clkoutgen3),
		.xgmdataout(xgmdataout),
		.xgmctrlenable(xgmctrlenable),
		.dataout(dataout),
		.rdenablesync(rdenablesync),
		.refclkb(refclkb),
		.parallelfdbkout(parallelfdbkout),
		.txpipeclk(txpipeclk),
		.txpipesoftreset(txpipesoftreset),
		.txpipeelectidle(txpipeelectidle),
		.detectrxloopout(detectrxloopout),
		.pipepowerdownout(pipepowerdownout),
		.pipeenrevparallellpbkout(pipeenrevparallellpbkout),
		.phfifotxswing(phfifotxswing),
		.phfifotxdeemph(phfifotxdeemph),
		.phfifotxmargin(phfifotxmargin),
		.txdataouttogen3(txdataouttogen3),
		.txdatakouttogen3(txdatakouttogen3),
		.txdatavalidouttogen3(txdatavalidouttogen3),
		.txblkstartout(txblkstartout),
		.txsynchdrout(txsynchdrout),
		.txcomplianceout(txcomplianceout),
		.txelecidleout(txelecidleout),
		.rxpolarityout(rxpolarityout),
		.polinvrxout(polinvrxout),
		.grayelecidleinferselout(grayelecidleinferselout),
		.txdivsyncinchnlup(txdivsyncinchnlup),
		.txdivsyncinchnldown(txdivsyncinchnldown),
		.wrenableinchnlup(wrenableinchnlup),
		.wrenableinchnldown(wrenableinchnldown),
		.rdenableinchnlup(rdenableinchnlup),
		.rdenableinchnldown(rdenableinchnldown),
		.fifoselectinchnlup(fifoselectinchnlup),
		.fifoselectinchnldown(fifoselectinchnldown),
		.resetpcptrs(resetpcptrs),
		.resetpcptrsinchnlup(resetpcptrsinchnlup),
		.resetpcptrsinchnldown(resetpcptrsinchnldown),
		.dispcbyte(dispcbyte),
		.txdivsyncoutchnlup(txdivsyncoutchnlup),
		.txdivsyncoutchnldown(txdivsyncoutchnldown),
		.rdenableoutchnlup(rdenableoutchnlup),
		.rdenableoutchnldown(rdenableoutchnldown),
		.wrenableoutchnlup(wrenableoutchnlup),
		.wrenableoutchnldown(wrenableoutchnldown),
		.fifoselectoutchnlup(fifoselectoutchnlup),
		.fifoselectoutchnldown(fifoselectoutchnldown),
		.syncdatain(syncdatain),
		.observablebyteserdesclock(observablebyteserdesclock),
		.txblkstart(txblkstart),
		.phfiforeset(phfiforeset),
		.txpcsreset(txpcsreset),
		.dynclkswitchn(dynclkswitchn),
		.txdatavalid(txdatavalid),
		.txctrlplanetestbus(txctrlplanetestbus),
		.refclkbreset(refclkbreset),
		.clkselgen3(clkselgen3),
		.aggtxpcsrst(aggtxpcsrst),
		.hrdrst(hrdrst),
		.txdivsync(txdivsync),
		.txtestbus(txtestbus),
		.txsynchdr(txsynchdr),
		.avmmclk(avmmclk),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.scanmode(scanmode)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pipe_gen1_2_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pipe_gen1_2
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "pipe_g1",	//Valid values: pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter tx_pipe_enable = "dis_pipe_tx",	//Valid values: dis_pipe_tx|en_pipe_tx|en_pipe3_tx
	parameter rx_pipe_enable = "dis_pipe_rx",	//Valid values: dis_pipe_rx|en_pipe_rx|en_pipe3_rx
	parameter pipe_byte_de_serializer_en = "dont_care_bds",	//Valid values: dis_bds|en_bds_by_2|dont_care_bds
	parameter txswing = "dis_txswing",	//Valid values: dis_txswing|en_txswing
	parameter rxdetect_bypass = "dis_rxdetect_bypass",	//Valid values: dis_rxdetect_bypass|en_rxdetect_bypass
	parameter error_replace_pad = "replace_edb",	//Valid values: replace_edb|replace_pad
	parameter ind_error_reporting = "dis_ind_error_reporting",	//Valid values: dis_ind_error_reporting|en_ind_error_reporting
	parameter phystatus_rst_toggle = "dis_phystatus_rst_toggle",	//Valid values: dis_phystatus_rst_toggle|en_phystatus_rst_toggle
	parameter elecidle_delay = "elec_idle_delay",	//Valid values: elec_idle_delay
	parameter elec_idle_delay_val = 3'b0,	//Valid values: 3
	parameter phy_status_delay = "phystatus_delay",	//Valid values: phystatus_delay
	parameter phystatus_delay_val = 3'b0,	//Valid values: 3
	parameter rvod_sel_d_val = 6'b0,	//Valid values: 6
	parameter rpre_emph_b_val = 6'b0,	//Valid values: 6
	parameter rvod_sel_c_val = 6'b0,	//Valid values: 6
	parameter rpre_emph_c_val = 6'b0,	//Valid values: 6
	parameter rpre_emph_settings = 6'b0,	//Valid values: 6
	parameter rvod_sel_a_val = 6'b0,	//Valid values: 6
	parameter rpre_emph_d_val = 6'b0,	//Valid values: 6
	parameter rvod_sel_settings = 6'b0,	//Valid values: 6
	parameter rvod_sel_b_val = 6'b0,	//Valid values: 6
	parameter rpre_emph_e_val = 6'b0,	//Valid values: 6
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter rvod_sel_e_val = 6'b0,	//Valid values: 6
	parameter rpre_emph_a_val = 6'b0,	//Valid values: 6
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] pipetxclk,
	input [ 0:0 ] piperxclk,
	input [ 0:0 ] refclkb,
	input [ 0:0 ] txpipereset,
	input [ 0:0 ] rxpipereset,
	input [ 0:0 ] refclkbreset,
	input [ 0:0 ] txdetectrxloopback,
	input [ 0:0 ] txelecidlein,
	input [ 1:0 ] powerdown,
	input [ 0:0 ] txdeemph,
	input [ 2:0 ] txmargin,
	input [ 0:0 ] txswingport,
	input [ 43:0 ] txdch,
	input [ 0:0 ] rxpolarity,
	input [ 0:0 ] sigdetni,
	output [ 0:0 ] rxvalid,
	output [ 0:0 ] rxelecidle,
	output [ 2:0 ] rxstatus,
	output [ 63:0 ] rxdch,
	output [ 0:0 ] phystatus,
	input [ 0:0 ] revloopback,
	input [ 0:0 ] polinvrx,
	output [ 43:0 ] txd,
	output [ 0:0 ] revloopbk,
	input [ 0:0 ] revloopbkpcsgen3,
	input [ 0:0 ] rxelectricalidlepcsgen3,
	input [ 0:0 ] txelecidlecomp,
	input [ 0:0 ] speedchange,
	input [ 0:0 ] speedchangechnlup,
	input [ 0:0 ] speedchangechnldown,
	input [ 63:0 ] rxd,
	output [ 0:0 ] txelecidleout,
	output [ 0:0 ] txdetectrx,
	input [ 0:0 ] rxfound,
	input [ 0:0 ] rxdetectvalid,
	input [ 0:0 ] rxelectricalidle,
	input [ 0:0 ] powerstatetransitiondone,
	input [ 0:0 ] powerstatetransitiondoneena,
	output [ 0:0 ] rxelectricalidleout,
	input [ 0:0 ] rxpolaritypcsgen3,
	output [ 0:0 ] polinvrxint,
	output [ 0:0 ] speedchangeout,
	output [ 17:0 ] currentcoeff,
	input [ 0:0 ] pcieswitch,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pipe_gen1_2_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.hip_mode(hip_mode),
		.tx_pipe_enable(tx_pipe_enable),
		.rx_pipe_enable(rx_pipe_enable),
		.pipe_byte_de_serializer_en(pipe_byte_de_serializer_en),
		.txswing(txswing),
		.rxdetect_bypass(rxdetect_bypass),
		.error_replace_pad(error_replace_pad),
		.ind_error_reporting(ind_error_reporting),
		.phystatus_rst_toggle(phystatus_rst_toggle),
		.elecidle_delay(elecidle_delay),
		.elec_idle_delay_val(elec_idle_delay_val),
		.phy_status_delay(phy_status_delay),
		.phystatus_delay_val(phystatus_delay_val),
		.rvod_sel_d_val(rvod_sel_d_val),
		.rpre_emph_b_val(rpre_emph_b_val),
		.rvod_sel_c_val(rvod_sel_c_val),
		.rpre_emph_c_val(rpre_emph_c_val),
		.rpre_emph_settings(rpre_emph_settings),
		.rvod_sel_a_val(rvod_sel_a_val),
		.rpre_emph_d_val(rpre_emph_d_val),
		.rvod_sel_settings(rvod_sel_settings),
		.rvod_sel_b_val(rvod_sel_b_val),
		.rpre_emph_e_val(rpre_emph_e_val),
		.sup_mode(sup_mode),
		.rvod_sel_e_val(rvod_sel_e_val),
		.rpre_emph_a_val(rpre_emph_a_val),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pipe_gen1_2_encrypted_inst	(
		.pipetxclk(pipetxclk),
		.piperxclk(piperxclk),
		.refclkb(refclkb),
		.txpipereset(txpipereset),
		.rxpipereset(rxpipereset),
		.refclkbreset(refclkbreset),
		.txdetectrxloopback(txdetectrxloopback),
		.txelecidlein(txelecidlein),
		.powerdown(powerdown),
		.txdeemph(txdeemph),
		.txmargin(txmargin),
		.txswingport(txswingport),
		.txdch(txdch),
		.rxpolarity(rxpolarity),
		.sigdetni(sigdetni),
		.rxvalid(rxvalid),
		.rxelecidle(rxelecidle),
		.rxstatus(rxstatus),
		.rxdch(rxdch),
		.phystatus(phystatus),
		.revloopback(revloopback),
		.polinvrx(polinvrx),
		.txd(txd),
		.revloopbk(revloopbk),
		.revloopbkpcsgen3(revloopbkpcsgen3),
		.rxelectricalidlepcsgen3(rxelectricalidlepcsgen3),
		.txelecidlecomp(txelecidlecomp),
		.speedchange(speedchange),
		.speedchangechnlup(speedchangechnlup),
		.speedchangechnldown(speedchangechnldown),
		.rxd(rxd),
		.txelecidleout(txelecidleout),
		.txdetectrx(txdetectrx),
		.rxfound(rxfound),
		.rxdetectvalid(rxdetectvalid),
		.rxelectricalidle(rxelectricalidle),
		.powerstatetransitiondone(powerstatetransitiondone),
		.powerstatetransitiondoneena(powerstatetransitiondoneena),
		.rxelectricalidleout(rxelectricalidleout),
		.rxpolaritypcsgen3(rxpolaritypcsgen3),
		.polinvrxint(polinvrxint),
		.speedchangeout(speedchangeout),
		.currentcoeff(currentcoeff),
		.pcieswitch(pcieswitch),
		.avmmclk(avmmclk),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pipe_gen3_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pipe_gen3
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter mode = "pipe_g1",	//Valid values: pipe_g1|pipe_g2|pipe_g3|par_lpbk|disable_pcs
	parameter ctrl_plane_bonding = "individual",	//Valid values: individual|ctrl_master|ctrl_slave_blw|ctrl_slave_abv
	parameter pipe_clk_sel = "func_clk",	//Valid values: disable_clk|dig_clk1_8g|func_clk
	parameter rate_match_pad_insertion = "dis_rm_fifo_pad_ins",	//Valid values: dis_rm_fifo_pad_ins|en_rm_fifo_pad_ins
	parameter ind_error_reporting = "dis_ind_error_reporting",	//Valid values: dis_ind_error_reporting|en_ind_error_reporting
	parameter phystatus_rst_toggle_g3 = "dis_phystatus_rst_toggle_g3",	//Valid values: dis_phystatus_rst_toggle_g3|en_phystatus_rst_toggle_g3
	parameter phystatus_rst_toggle_g12 = "dis_phystatus_rst_toggle",	//Valid values: dis_phystatus_rst_toggle|en_phystatus_rst_toggle
	parameter cdr_control = "en_cdr_ctrl",	//Valid values: dis_cdr_ctrl|en_cdr_ctrl
	parameter cid_enable = "en_cid_mode",	//Valid values: dis_cid_mode|en_cid_mode
	parameter parity_chk_ts1 = "en_ts1_parity_chk",	//Valid values: en_ts1_parity_chk|dis_ts1_parity_chk
	parameter rxvalid_mask = "rxvalid_mask_en",	//Valid values: rxvalid_mask_dis|rxvalid_mask_en
	parameter ph_fifo_reg_mode = "phfifo_reg_mode_dis",	//Valid values: phfifo_reg_mode_dis|phfifo_reg_mode_en
	parameter test_mode_timers = "dis_test_mode_timers",	//Valid values: dis_test_mode_timers|en_test_mode_timers
	parameter inf_ei_enable = "dis_inf_ei",	//Valid values: dis_inf_ei|en_inf_ei
	parameter spd_chnge_g2_sel = "false",	//Valid values: false|true
	parameter cp_up_mstr = "false",	//Valid values: false|true
	parameter cp_dwn_mstr = "false",	//Valid values: false|true
	parameter cp_cons_sel = "cp_cons_default",	//Valid values: cp_cons_master|cp_cons_slave_abv|cp_cons_slave_blw|cp_cons_default
	parameter elecidle_delay_g3_data = 3'b0,	//Valid values: 3
	parameter elecidle_delay_g3 = "elecidle_delay_g3",	//Valid values: elecidle_delay_g3
	parameter phy_status_delay_g12_data = 3'b0,	//Valid values: 3
	parameter phy_status_delay_g12 = "phy_status_delay_g12",	//Valid values: phy_status_delay_g12
	parameter phy_status_delay_g3_data = 3'b0,	//Valid values: 3
	parameter phy_status_delay_g3 = "phy_status_delay_g3",	//Valid values: phy_status_delay_g3
	parameter sigdet_wait_counter_data = 8'b0,	//Valid values: 8
	parameter sigdet_wait_counter = "sigdet_wait_counter",	//Valid values: sigdet_wait_counter
	parameter data_mask_count_val = 10'b0,	//Valid values: 10
	parameter data_mask_count = "data_mask_count",	//Valid values: data_mask_count
	parameter pma_done_counter_data = 18'b0,	//Valid values: 18
	parameter pma_done_counter = "pma_done_count",	//Valid values: pma_done_count
	parameter pc_en_counter_data = 5'b0,	//Valid values: 5
	parameter pc_en_counter = "pc_en_count",	//Valid values: pc_en_count
	parameter pc_rst_counter_data = 4'b0,	//Valid values: 4
	parameter pc_rst_counter = "pc_rst_count",	//Valid values: pc_rst_count
	parameter phfifo_flush_wait_data = 6'b0,	//Valid values: 6
	parameter phfifo_flush_wait = "phfifo_flush_wait",	//Valid values: phfifo_flush_wait
	parameter asn_clk_enable = "false",	//Valid values: false|true
	parameter free_run_clk_enable = "true",	//Valid values: false|true
	parameter asn_enable = "dis_asn",	//Valid values: dis_asn|en_asn
	parameter bypass_send_syncp_fbkp = "false",	//Valid values: false|true
	parameter wait_send_syncp_fbkp_data = 11'b11111010,	//Valid values: 11
	parameter wait_clk_on_off_timer_data = 4'b100,	//Valid values: 4
	parameter wait_clk_on_off_timer = "wait_clk_on_off_timer",	//Valid values: wait_clk_on_off_timer
	parameter wait_send_syncp_fbkp = "wait_send_syncp_fbkp",	//Valid values: wait_send_syncp_fbkp
	parameter wait_pipe_synchronizing = "wait_pipe_sync",	//Valid values: wait_pipe_sync
	parameter bypass_pma_sw_done = "false",	//Valid values: false|true
	parameter test_out_sel = "disable",	//Valid values: tx_test_out|rx_test_out|pipe_test_out1|pipe_test_out2|pipe_test_out3|pipe_test_out4|pipe_ctrl_test_out1|pipe_ctrl_test_out2|pipe_ctrl_test_out3|disable
	parameter wait_pipe_synchronizing_data = 5'b10111,	//Valid values: 5
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engr_mode
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 19:0 ] rxtestout,
	output [ 0:0 ] txpmasyncp,
	output [ 0:0 ] ppmcntrst8gpcsout,
	input [ 0:0 ] txpmasyncphip,
	input [ 0:0 ] hardresetn,
	input [ 10:0 ] bundlingindown,
	output [ 10:0 ] bundlingoutdown,
	output [ 10:0 ] bundlingoutup,
	input [ 10:0 ] bundlinginup,
	input [ 0:0 ] rcvdclk,
	input [ 0:0 ] txpmaclk,
	input [ 0:0 ] pllfixedclk,
	input [ 0:0 ] rtxgen3capen,
	input [ 0:0 ] rrxgen3capen,
	input [ 0:0 ] rtxdigclksel,
	input [ 0:0 ] rrxdigclksel,
	input [ 0:0 ] rxrstn,
	input [ 0:0 ] txrstn,
	input [ 0:0 ] scanmoden,
	output [ 19:0 ] testout,
	output [ 0:0 ] gen3datasel,
	output [ 0:0 ] gen3clksel,
	output [ 0:0 ] pcsrst,
	output [ 0:0 ] dispcbyte,
	output [ 0:0 ] resetpcprts,
	output [ 0:0 ] shutdownclk,
	input [ 31:0 ] txdata,
	input [ 3:0 ] txdatak,
	input [ 0:0 ] txdataskip,
	input [ 1:0 ] txsynchdr,
	input [ 0:0 ] txblkstart,
	input [ 0:0 ] txelecidle,
	input [ 0:0 ] txdetectrxloopback,
	input [ 0:0 ] txcompliance,
	input [ 0:0 ] rxpolarity,
	input [ 1:0 ] powerdown,
	input [ 1:0 ] rate,
	input [ 2:0 ] txmargin,
	input [ 0:0 ] txdeemph,
	input [ 0:0 ] txswing,
	input [ 2:0 ] eidleinfersel,
	input [ 17:0 ] currentcoeff,
	input [ 2:0 ] currentrxpreset,
	input [ 0:0 ] rxupdatefc,
	output [ 3:0 ] rxdataskip,
	output [ 1:0 ] rxsynchdr,
	output [ 3:0 ] rxblkstart,
	output [ 0:0 ] rxvalid,
	output [ 0:0 ] phystatus,
	output [ 0:0 ] rxelecidle,
	output [ 2:0 ] rxstatus,
	input [ 31:0 ] rxdataint,
	input [ 3:0 ] rxdatakint,
	input [ 0:0 ] rxdataskipint,
	input [ 1:0 ] rxsynchdrint,
	input [ 0:0 ] rxblkstartint,
	output [ 31:0 ] txdataint,
	output [ 3:0 ] txdatakint,
	output [ 0:0 ] txdataskipint,
	output [ 1:0 ] txsynchdrint,
	output [ 0:0 ] txblkstartint,
	output [ 18:0 ] testinfei,
	input [ 0:0 ] eidetint,
	input [ 0:0 ] eipartialdetint,
	input [ 0:0 ] idetint,
	input [ 0:0 ] blkalgndint,
	input [ 0:0 ] clkcompinsertint,
	input [ 0:0 ] clkcompdeleteint,
	input [ 0:0 ] clkcompoverflint,
	input [ 0:0 ] clkcompundflint,
	input [ 0:0 ] errdecodeint,
	input [ 0:0 ] rcvlfsrchkint,
	input [ 0:0 ] errencodeint,
	output [ 0:0 ] rxpolarityint,
	output [ 0:0 ] revlpbkint,
	output [ 0:0 ] inferredrxvalidint,
	input [ 63:0 ] rxd8gpcsin,
	input [ 0:0 ] rxelecidle8gpcsin,
	input [ 0:0 ] pldltr,
	output [ 63:0 ] rxd8gpcsout,
	output [ 0:0 ] revlpbk8gpcsout,
	input [ 0:0 ] pmarxdetectvalid,
	input [ 0:0 ] pmarxfound,
	input [ 0:0 ] pmasignaldet,
	input [ 1:0 ] pmapcieswdone,
	output [ 1:0 ] pmapcieswitch,
	output [ 2:0 ] pmatxmargin,
	output [ 0:0 ] pmatxdeemph,
	output [ 0:0 ] pmatxswing,
	output [ 17:0 ] pmacurrentcoeff,
	output [ 2:0 ] pmacurrentrxpreset,
	output [ 0:0 ] pmatxelecidle,
	output [ 0:0 ] pmatxdetectrx,
	output [ 0:0 ] ppmeidleexit,
	output [ 0:0 ] pmaltr,
	output [ 0:0 ] pmaearlyeios,
	output [ 0:0 ] pmarxdetpd,
	output [ 0:0 ] rxpolarity8gpcsout,
	input [ 0:0 ] speedchangeg2,
	output [ 0:0 ] masktxpll,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pipe_gen3_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.mode(mode),
		.ctrl_plane_bonding(ctrl_plane_bonding),
		.pipe_clk_sel(pipe_clk_sel),
		.rate_match_pad_insertion(rate_match_pad_insertion),
		.ind_error_reporting(ind_error_reporting),
		.phystatus_rst_toggle_g3(phystatus_rst_toggle_g3),
		.phystatus_rst_toggle_g12(phystatus_rst_toggle_g12),
		.cdr_control(cdr_control),
		.cid_enable(cid_enable),
		.parity_chk_ts1(parity_chk_ts1),
		.rxvalid_mask(rxvalid_mask),
		.ph_fifo_reg_mode(ph_fifo_reg_mode),
		.test_mode_timers(test_mode_timers),
		.inf_ei_enable(inf_ei_enable),
		.spd_chnge_g2_sel(spd_chnge_g2_sel),
		.cp_up_mstr(cp_up_mstr),
		.cp_dwn_mstr(cp_dwn_mstr),
		.cp_cons_sel(cp_cons_sel),
		.elecidle_delay_g3_data(elecidle_delay_g3_data),
		.elecidle_delay_g3(elecidle_delay_g3),
		.phy_status_delay_g12_data(phy_status_delay_g12_data),
		.phy_status_delay_g12(phy_status_delay_g12),
		.phy_status_delay_g3_data(phy_status_delay_g3_data),
		.phy_status_delay_g3(phy_status_delay_g3),
		.sigdet_wait_counter_data(sigdet_wait_counter_data),
		.sigdet_wait_counter(sigdet_wait_counter),
		.data_mask_count_val(data_mask_count_val),
		.data_mask_count(data_mask_count),
		.pma_done_counter_data(pma_done_counter_data),
		.pma_done_counter(pma_done_counter),
		.pc_en_counter_data(pc_en_counter_data),
		.pc_en_counter(pc_en_counter),
		.pc_rst_counter_data(pc_rst_counter_data),
		.pc_rst_counter(pc_rst_counter),
		.phfifo_flush_wait_data(phfifo_flush_wait_data),
		.phfifo_flush_wait(phfifo_flush_wait),
		.asn_clk_enable(asn_clk_enable),
		.free_run_clk_enable(free_run_clk_enable),
		.asn_enable(asn_enable),
		.bypass_send_syncp_fbkp(bypass_send_syncp_fbkp),
		.wait_send_syncp_fbkp_data(wait_send_syncp_fbkp_data),
		.wait_clk_on_off_timer_data(wait_clk_on_off_timer_data),
		.wait_clk_on_off_timer(wait_clk_on_off_timer),
		.wait_send_syncp_fbkp(wait_send_syncp_fbkp),
		.wait_pipe_synchronizing(wait_pipe_synchronizing),
		.bypass_pma_sw_done(bypass_pma_sw_done),
		.test_out_sel(test_out_sel),
		.wait_pipe_synchronizing_data(wait_pipe_synchronizing_data),
		.sup_mode(sup_mode),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pipe_gen3_encrypted_inst	(
		.rxtestout(rxtestout),
		.txpmasyncp(txpmasyncp),
		.ppmcntrst8gpcsout(ppmcntrst8gpcsout),
		.txpmasyncphip(txpmasyncphip),
		.hardresetn(hardresetn),
		.bundlingindown(bundlingindown),
		.bundlingoutdown(bundlingoutdown),
		.bundlingoutup(bundlingoutup),
		.bundlinginup(bundlinginup),
		.rcvdclk(rcvdclk),
		.txpmaclk(txpmaclk),
		.pllfixedclk(pllfixedclk),
		.rtxgen3capen(rtxgen3capen),
		.rrxgen3capen(rrxgen3capen),
		.rtxdigclksel(rtxdigclksel),
		.rrxdigclksel(rrxdigclksel),
		.rxrstn(rxrstn),
		.txrstn(txrstn),
		.scanmoden(scanmoden),
		.testout(testout),
		.gen3datasel(gen3datasel),
		.gen3clksel(gen3clksel),
		.pcsrst(pcsrst),
		.dispcbyte(dispcbyte),
		.resetpcprts(resetpcprts),
		.shutdownclk(shutdownclk),
		.txdata(txdata),
		.txdatak(txdatak),
		.txdataskip(txdataskip),
		.txsynchdr(txsynchdr),
		.txblkstart(txblkstart),
		.txelecidle(txelecidle),
		.txdetectrxloopback(txdetectrxloopback),
		.txcompliance(txcompliance),
		.rxpolarity(rxpolarity),
		.powerdown(powerdown),
		.rate(rate),
		.txmargin(txmargin),
		.txdeemph(txdeemph),
		.txswing(txswing),
		.eidleinfersel(eidleinfersel),
		.currentcoeff(currentcoeff),
		.currentrxpreset(currentrxpreset),
		.rxupdatefc(rxupdatefc),
		.rxdataskip(rxdataskip),
		.rxsynchdr(rxsynchdr),
		.rxblkstart(rxblkstart),
		.rxvalid(rxvalid),
		.phystatus(phystatus),
		.rxelecidle(rxelecidle),
		.rxstatus(rxstatus),
		.rxdataint(rxdataint),
		.rxdatakint(rxdatakint),
		.rxdataskipint(rxdataskipint),
		.rxsynchdrint(rxsynchdrint),
		.rxblkstartint(rxblkstartint),
		.txdataint(txdataint),
		.txdatakint(txdatakint),
		.txdataskipint(txdataskipint),
		.txsynchdrint(txsynchdrint),
		.txblkstartint(txblkstartint),
		.testinfei(testinfei),
		.eidetint(eidetint),
		.eipartialdetint(eipartialdetint),
		.idetint(idetint),
		.blkalgndint(blkalgndint),
		.clkcompinsertint(clkcompinsertint),
		.clkcompdeleteint(clkcompdeleteint),
		.clkcompoverflint(clkcompoverflint),
		.clkcompundflint(clkcompundflint),
		.errdecodeint(errdecodeint),
		.rcvlfsrchkint(rcvlfsrchkint),
		.errencodeint(errencodeint),
		.rxpolarityint(rxpolarityint),
		.revlpbkint(revlpbkint),
		.inferredrxvalidint(inferredrxvalidint),
		.rxd8gpcsin(rxd8gpcsin),
		.rxelecidle8gpcsin(rxelecidle8gpcsin),
		.pldltr(pldltr),
		.rxd8gpcsout(rxd8gpcsout),
		.revlpbk8gpcsout(revlpbk8gpcsout),
		.pmarxdetectvalid(pmarxdetectvalid),
		.pmarxfound(pmarxfound),
		.pmasignaldet(pmasignaldet),
		.pmapcieswdone(pmapcieswdone),
		.pmapcieswitch(pmapcieswitch),
		.pmatxmargin(pmatxmargin),
		.pmatxdeemph(pmatxdeemph),
		.pmatxswing(pmatxswing),
		.pmacurrentcoeff(pmacurrentcoeff),
		.pmacurrentrxpreset(pmacurrentrxpreset),
		.pmatxelecidle(pmatxelecidle),
		.pmatxdetectrx(pmatxdetectrx),
		.ppmeidleexit(ppmeidleexit),
		.pmaltr(pmaltr),
		.pmaearlyeios(pmaearlyeios),
		.pmarxdetpd(pmarxdetpd),
		.rxpolarity8gpcsout(rxpolarity8gpcsout),
		.speedchangeg2(speedchangeg2),
		.masktxpll(masktxpll),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_aux_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_aux
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter continuous_calibration = "false",	//Valid values: false|true
	parameter rx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter rx_cal_override_value = 0,	//Valid values: 0..31
	parameter tx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter tx_cal_override_value = 0,	//Valid values: 0..31
	parameter cal_result_status = "pm_aux_result_status_tx",	//Valid values: pm_aux_result_status_tx|pm_aux_result_status_rx
	parameter rx_imp = "cal_imp_46_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter tx_imp = "cal_imp_46_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter test_counter_enable = "false",	//Valid values: false|true
	parameter cal_clk_sel = "pm_aux_iqclk_cal_clk_sel_cal_clk",	//Valid values: pm_aux_iqclk_cal_clk_sel_cal_clk|pm_aux_iqclk_cal_clk_sel_iqclk0|pm_aux_iqclk_cal_clk_sel_iqclk1|pm_aux_iqclk_cal_clk_sel_iqclk2|pm_aux_iqclk_cal_clk_sel_iqclk3|pm_aux_iqclk_cal_clk_sel_iqclk4|pm_aux_iqclk_cal_clk_sel_iqclk5|pm_aux_iqclk_cal_clk_sel_iqclk6|pm_aux_iqclk_cal_clk_sel_iqclk7|pm_aux_iqclk_cal_clk_sel_iqclk8|pm_aux_iqclk_cal_clk_sel_iqclk9|pm_aux_iqclk_cal_clk_sel_iqclk10
	parameter pm_aux_cal_clk_test_sel = 1'b0,	//Valid values: 1
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] calpdb,
	input [ 0:0 ] calclk,
	input [ 0:0 ] testcntl,
	input [ 10:0 ] refiqclk,
	output [ 0:0 ] nonusertoio,
	output [ 4:0 ] zrxtx50
); 

	stratixv_hssi_pma_aux_encrypted 
	#(
		.enable_debug_info(enable_debug_info),
		.continuous_calibration(continuous_calibration),
		.rx_cal_override_value_enable(rx_cal_override_value_enable),
		.rx_cal_override_value(rx_cal_override_value),
		.tx_cal_override_value_enable(tx_cal_override_value_enable),
		.tx_cal_override_value(tx_cal_override_value),
		.cal_result_status(cal_result_status),
		.rx_imp(rx_imp),
		.tx_imp(tx_imp),
		.test_counter_enable(test_counter_enable),
		.cal_clk_sel(cal_clk_sel),
		.pm_aux_cal_clk_test_sel(pm_aux_cal_clk_test_sel),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pma_aux_encrypted_inst	(
		.calpdb(calpdb),
		.calclk(calclk),
		.testcntl(testcntl),
		.refiqclk(refiqclk),
		.nonusertoio(nonusertoio),
		.zrxtx50(zrxtx50)
	);


endmodule
`timescale 1 ps/1 ps

module    stratixv_hssi_pma_cdr_refclk_select_mux    (
    calclk,
    ffplloutbot,
    ffpllouttop,
    pldclk,
    refiqclk0,
    refiqclk1,
    refiqclk10,
    refiqclk2,
    refiqclk3,
    refiqclk4,
    refiqclk5,
    refiqclk6,
    refiqclk7,
    refiqclk8,
    refiqclk9,
    rxiqclk0,
    rxiqclk1,
    rxiqclk10,
    rxiqclk2,
    rxiqclk3,
    rxiqclk4,
    rxiqclk5,
    rxiqclk6,
    rxiqclk7,
    rxiqclk8,
    rxiqclk9,
    avmmclk,
    avmmrstn,
    avmmwrite,
    avmmread,
    avmmbyteen,
    avmmaddress,
    avmmwritedata,
    avmmreaddata,
    blockselect,
    clkout);

    parameter    lpm_type    =    "stratixv_hssi_pma_cdr_refclk_select_mux";
    parameter    channel_number    =    0;
      // the mux_type parameter is used for dynamic reconfiguration
   // support. It specifies whethter this mux should listen to the
   // DPRIO memory space for the CDR REF CLK mux or for the LC REF CLK
   // mux
parameter mux_type = "cdr_refclk_select_mux"; // cdr_refclk_select_mux|lc_refclk_select_mux

    parameter    refclk_select    =    "ref_iqclk0";
    parameter    reference_clock_frequency    =    "0 ps";
    parameter    avmm_group_channel_index = 0;
    parameter    use_default_base_address = "true";
    parameter    user_base_address = 0;


    input         calclk;
    input         ffplloutbot;
    input         ffpllouttop;
    input         pldclk;
    input         refiqclk0;
    input         refiqclk1;
    input         refiqclk10;
    input         refiqclk2;
    input         refiqclk3;
    input         refiqclk4;
    input         refiqclk5;
    input         refiqclk6;
    input         refiqclk7;
    input         refiqclk8;
    input         refiqclk9;
    input         rxiqclk0;
    input         rxiqclk1;
    input         rxiqclk10;
    input         rxiqclk2;
    input         rxiqclk3;
    input         rxiqclk4;
    input         rxiqclk5;
    input         rxiqclk6;
    input         rxiqclk7;
    input         rxiqclk8;
    input         rxiqclk9;
    input         avmmclk;
    input         avmmrstn;
    input         avmmwrite;
    input         avmmread;
    input  [ 1:0] avmmbyteen;
    input  [10:0] avmmaddress;
    input  [15:0] avmmwritedata;
    output [15:0] avmmreaddata;
    output        blockselect;
    output        clkout;

    stratixv_hssi_pma_cdr_refclk_select_mux_encrypted inst (
        .calclk(calclk),
        .ffplloutbot(ffplloutbot),
        .ffpllouttop(ffpllouttop),
        .pldclk(pldclk),
        .refiqclk0(refiqclk0),
        .refiqclk1(refiqclk1),
        .refiqclk10(refiqclk10),
        .refiqclk2(refiqclk2),
        .refiqclk3(refiqclk3),
        .refiqclk4(refiqclk4),
        .refiqclk5(refiqclk5),
        .refiqclk6(refiqclk6),
        .refiqclk7(refiqclk7),
        .refiqclk8(refiqclk8),
        .refiqclk9(refiqclk9),
        .rxiqclk0(rxiqclk0),
        .rxiqclk1(rxiqclk1),
        .rxiqclk10(rxiqclk10),
        .rxiqclk2(rxiqclk2),
        .rxiqclk3(rxiqclk3),
        .rxiqclk4(rxiqclk4),
        .rxiqclk5(rxiqclk5),
        .rxiqclk6(rxiqclk6),
        .rxiqclk7(rxiqclk7),
        .rxiqclk8(rxiqclk8),
        .rxiqclk9(rxiqclk9),
	.avmmclk(avmmclk),
	.avmmrstn(avmmrstn),
	.avmmwrite(avmmwrite),
	.avmmread(avmmread),
	.avmmbyteen(avmmbyteen),
	.avmmaddress(avmmaddress),
	.avmmwritedata(avmmwritedata),
	.avmmreaddata(avmmreaddata),
	.blockselect(blockselect),
        .clkout(clkout) );
    defparam inst.lpm_type = lpm_type;
    defparam inst.channel_number = channel_number;
    defparam inst.refclk_select = refclk_select;
    defparam inst.reference_clock_frequency = reference_clock_frequency;
    defparam inst.avmm_group_channel_index = avmm_group_channel_index;
    defparam inst.use_default_base_address = use_default_base_address;
    defparam inst.user_base_address = user_base_address;

endmodule //stratixv_hssi_pma_cdr_refclk_select_mux

`timescale 1 ps/1 ps

module stratixv_hssi_pma_hi_pmaif
  #(
    parameter lpm_type = "stratixv_hssi_pma_hi_pmaif",
    parameter tx_pma_direction_sel = "pcs"    // valid values pcs|core
  )    
  (
   input [79:0] datainfromcore,
   input [79:0] datainfrompcs,
   output [79:0] dataouttopma

   // ... avmm and block select ports go here ...

   );

    stratixv_hssi_pma_hi_pmaif_encrypted 
    # (
    .tx_pma_direction_sel("pcs")    // valid values pcs|core
    )
    inst (
   .datainfromcore(datainfromcore),
   .datainfrompcs(datainfrompcs),
   .dataouttopma(dataouttopma)
   );

endmodule // hi_pmaif
`timescale 1 ps/1 ps

module stratixv_hssi_pma_hi_xcvrif
  #(
    parameter lpm_type = "stratixv_hssi_pma_hi_xcvrif",
    parameter rx_pma_direction_sel = "pcs"    // valid values pcs|core
    )
  (
   input  [79:0] datainfrompma,
   input  [79:0] datainfrompcs,
   output [79:0] dataouttopld

   // ... avmm and block select ports go here ...

   );

    stratixv_hssi_pma_hi_xcvrif_encrypted 
    # (
    .tx_pma_direction_sel("pcs")    // valid values pcs|core
    )
    inst (
   .datainfrompma(datainfrompma),
   .datainfrompcs(datainfrompcs),
   .dataouttopld(dataouttopld)
   );

endmodule // hi_pmaif
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_rx_buf_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_rx_buf
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..65
	parameter eq_bw_sel = "bw_full_12p5",	//Valid values: bw_full_12p5|bw_half_6p5
	parameter input_vcm_sel = "high_vcm",	//Valid values: low_vcm|high_vcm
	parameter pdb_sd = "false",	//Valid values: false|true
	parameter qpi_enable = "false",	//Valid values: false|true
	parameter rx_dc_gain = 0,	//Valid values: 0..4
	parameter rx_sel_bias_source = "bias_vcmdrv",	//Valid values: bias_vcmdrv|bias_int
	parameter sd_off = 0,	//Valid values: 0..29
	parameter sd_on = 0,	//Valid values: 0..16
	parameter sd_threshold = 0,	//Valid values: 0..7
	parameter serial_loopback = "lpbkp_dis",	//Valid values: lpbkp_dis|lpbkp_en_sel_data_slew1|lpbkp_en_sel_data_slew2|lpbkp_en_sel_data_slew3|lpbkp_en_sel_data_slew4|lpbkp_en_sel_refclk|lpbkp_unused
	parameter term_sel = "int_100ohm",	//Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter vccela_supply_voltage = "vccela_1p0v",	//Valid values: vccela_1p0v|vccela_0p85v
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter bypass_eqz_stages_234 = "all_stages_enabled",	//Valid values: all_stages_enabled|byypass_stages_234
	parameter cdrclk_to_cgb = "cdrclk_2cgb_dis",	//Valid values: cdrclk_2cgb_dis|cdrclk_2cgb_en
	parameter diagnostic_loopback = "diag_lpbk_off",	//Valid values: diag_lpbk_on|diag_lpbk_off
	parameter pmos_gain_peak = "eqzp_en_peaking",	//Valid values: eqzp_dis_peaking|eqzp_en_peaking
	parameter vcm_current_add = "vcm_current_default",	//Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter vcm_sel = "vtt_0p70v",	//Valid values: vtt_0p80v|vtt_0p75v|vtt_0p70v|vtt_0p65v|vtt_0p60v|vtt_0p55v|vtt_0p50v|vtt_0p35v|vtt_pup_weak|vtt_pdn_weak|tristate1|vtt_pdn_strong|vtt_pup_strong|tristate2|tristate3|tristate4
	parameter cdr_clock_enable = "true",	//Valid values: false|true
	parameter ct_equalizer_setting = 1,	//Valid values: 1..16
	parameter enable_rx_gainctrl_pciemode = "false"	//Valid values: false|true
)
(
//input and output port declaration
	input [ 0:0 ] voplp,
	input [ 0:0 ] vonlp,
	output [ 0:0 ] dataout,
	input [ 0:0 ] ck0sigdet,
	input [ 0:0 ] lpbkp,
	input [ 0:0 ] rstn,
	input [ 0:0 ] hardoccalen,
	input [ 0:0 ] datain,
	input [ 0:0 ] slpbk,
	input [ 0:0 ] rxqpipulldn,
	output [ 0:0 ] rdlpbkp,
	output [ 0:0 ] sd,
	input [ 0:0 ] nonuserfrompmaux,
	input [ 0:0 ] adaptcapture,
	output [ 0:0 ] adaptdone,
	input [ 0:0 ] adcestandby,
	output [ 0:0 ] hardoccaldone,
	input [ 4:0 ] eyemonitor,
	input [ 0:0 ] lpbkn,
	output [ 0:0 ] rxrefclk,
	output [ 0:0 ] rdlpbkn,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pma_rx_buf_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.eq_bw_sel(eq_bw_sel),
		.input_vcm_sel(input_vcm_sel),
		.pdb_sd(pdb_sd),
		.qpi_enable(qpi_enable),
		.rx_dc_gain(rx_dc_gain),
		.rx_sel_bias_source(rx_sel_bias_source),
		.sd_off(sd_off),
		.sd_on(sd_on),
		.sd_threshold(sd_threshold),
		.serial_loopback(serial_loopback),
		.term_sel(term_sel),
		.vccela_supply_voltage(vccela_supply_voltage),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.bypass_eqz_stages_234(bypass_eqz_stages_234),
		.cdrclk_to_cgb(cdrclk_to_cgb),
		.diagnostic_loopback(diagnostic_loopback),
		.pmos_gain_peak(pmos_gain_peak),
		.vcm_current_add(vcm_current_add),
		.vcm_sel(vcm_sel),
		.cdr_clock_enable(cdr_clock_enable),
		.ct_equalizer_setting(ct_equalizer_setting),
		.enable_rx_gainctrl_pciemode(enable_rx_gainctrl_pciemode)

	)
	stratixv_hssi_pma_rx_buf_encrypted_inst	(
		.voplp(voplp),
		.vonlp(vonlp),
		.dataout(dataout),
		.ck0sigdet(ck0sigdet),
		.lpbkp(lpbkp),
		.rstn(rstn),
		.hardoccalen(hardoccalen),
		.datain(datain),
		.slpbk(slpbk),
		.rxqpipulldn(rxqpipulldn),
		.rdlpbkp(rdlpbkp),
		.sd(sd),
		.nonuserfrompmaux(nonuserfrompmaux),
		.adaptcapture(adaptcapture),
		.adaptdone(adaptdone),
		.adcestandby(adcestandby),
		.hardoccaldone(hardoccaldone),
		.eyemonitor(eyemonitor),
		.lpbkn(lpbkn),
		.rxrefclk(rxrefclk),
		.rdlpbkn(rdlpbkn),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_rx_deser_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_rx_deser
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter mode = 8,	//Valid values: 8|10|16|20|32|40|64|80
	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter enable_bit_slip = "false",	//Valid values: false|true
	parameter vco_bypass = "vco_bypass_normal",	//Valid values: vco_bypass_normal|clklow_to_clkdivrx|fref_to_clkdivrx
	parameter sdclk_enable = "true",	//Valid values: false|true
	parameter channel_number = 0,	//Valid values: 0..65
	parameter clk_forward_only_mode = "false",	//Valid values: false|true
	parameter deser_div33_enable = "true",	//Valid values: true|false
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] bslip,
	input [ 0:0 ] deven,
	input [ 0:0 ] dodd,
	input [ 1:0 ] pciesw,
	input [ 0:0 ] clk90b,
	input [ 0:0 ] clk270b,
	input [ 0:0 ] pfdmodelock,
	input [ 0:0 ] fref,
	input [ 0:0 ] clklow,
	input [ 0:0 ] rstn,
	output [ 0:0 ] clk33pcs,
	output [ 0:0 ] clkdivrx,
	output [ 0:0 ] pciel,
	output [ 0:0 ] pciem,
	output [ 0:0 ] clkdivrxrx,
	output [ 79:0 ] dout,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pma_rx_deser_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.mode(mode),
		.auto_negotiation(auto_negotiation),
		.enable_bit_slip(enable_bit_slip),
		.vco_bypass(vco_bypass),
		.sdclk_enable(sdclk_enable),
		.channel_number(channel_number),
		.clk_forward_only_mode(clk_forward_only_mode),
		.deser_div33_enable(deser_div33_enable),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pma_rx_deser_encrypted_inst	(
		.bslip(bslip),
		.deven(deven),
		.dodd(dodd),
		.pciesw(pciesw),
		.clk90b(clk90b),
		.clk270b(clk270b),
		.pfdmodelock(pfdmodelock),
		.fref(fref),
		.clklow(clklow),
		.rstn(rstn),
		.clk33pcs(clk33pcs),
		.clkdivrx(clkdivrx),
		.pciel(pciel),
		.pciem(pciem),
		.clkdivrxrx(clkdivrxrx),
		.dout(dout),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_tx_buf_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_buf
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter pre_emp_switching_ctrl_1st_post_tap = 0,	//Valid values: 0..31
	parameter pre_emp_switching_ctrl_2nd_post_tap = 0,	//Valid values: 0..15
	parameter pre_emp_switching_ctrl_pre_tap = 0,	//Valid values: 0..15
	parameter qpi_en = "false",	//Valid values: false|true
	parameter rx_det = 0,	//Valid values: 0..15
	parameter rx_det_pdb = "true",	//Valid values: false|true
	parameter sig_inv_2nd_tap = "false",	//Valid values: false|true
	parameter sig_inv_pre_tap = "false",	//Valid values: false|true
	parameter term_sel = "int_100ohm",	//Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter vod_switching_ctrl_main_tap = 0,	//Valid values: 0..63
	parameter channel_number = 0,	//Valid values: 0..65
	parameter dft_sel = "disabled",	//Valid values: vod_en_lsb|vod_en_msb|po1_en|disabled|pre_en_po2_en
	parameter common_mode_driver_sel = "volt_0p65v",	//Valid values: volt_0p80v|volt_0p75v|volt_0p70v|volt_0p65v|volt_0p60v|volt_0p55v|volt_0p50v|volt_0p35v|pull_up|pull_dn|tristated1|grounded|pull_up_to_vccela|tristated2|tristated3|tristated4
	parameter driver_resolution_ctrl = "disabled",	//Valid values: offset_main|offset_po1|conbination1|disabled|offset_pre|conbination2|conbination3|conbination4|half_resolution|conbination5|conbination6|conbination7|conbination8|conbination9|conbination10|conbination11
	parameter local_ib_ctl = "ib_29ohm",	//Valid values: ib_49ohm|ib_29ohm|ib_42ohm|ib_22ohm
	parameter rx_det_output_sel = "rx_det_pcie_out",	//Valid values: rx_det_qpi_out|rx_det_pcie_out
	parameter slew_rate_ctrl = 1,	//Valid values: 1..5
	parameter swing_boost = "not_boost",	//Valid values: not_boost|boost
	parameter vcm_ctrl_sel = "ram_ctl",	//Valid values: ram_ctl|dynamic_ctl
	parameter vcm_current_addl = "vcm_current_default",	//Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter vod_boost = "not_boost",	//Valid values: not_boost|boost
	parameter fir_coeff_ctrl_sel = "ram_ctl"	//Valid values: dynamic_ctl|ram_ctl
)
(
//input and output port declaration
	input [ 0:0 ] nonuserfrompmaux,
	input [ 0:0 ] rxdetclk,
	input [ 0:0 ] txdetrx,
	input [ 0:0 ] txelecidl,
	input [ 0:0 ] datain,
	input [ 0:0 ] txqpipullup,
	input [ 0:0 ] txqpipulldn,
	output [ 0:0 ] fixedclkout,
	output [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxfound,
	output [ 0:0 ] dataout,
	input [ 0:0 ] vrlpbkn,
	input [ 0:0 ] vrlpbkp,
	input [ 0:0 ] vrlpbkp1t,
	input [ 0:0 ] vrlpbkn1t,
	input [ 17:0 ] icoeff,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pma_tx_buf_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.pre_emp_switching_ctrl_1st_post_tap(pre_emp_switching_ctrl_1st_post_tap),
		.pre_emp_switching_ctrl_2nd_post_tap(pre_emp_switching_ctrl_2nd_post_tap),
		.pre_emp_switching_ctrl_pre_tap(pre_emp_switching_ctrl_pre_tap),
		.qpi_en(qpi_en),
		.rx_det(rx_det),
		.rx_det_pdb(rx_det_pdb),
		.sig_inv_2nd_tap(sig_inv_2nd_tap),
		.sig_inv_pre_tap(sig_inv_pre_tap),
		.term_sel(term_sel),
		.vod_switching_ctrl_main_tap(vod_switching_ctrl_main_tap),
		.channel_number(channel_number),
		.dft_sel(dft_sel),
		.common_mode_driver_sel(common_mode_driver_sel),
		.driver_resolution_ctrl(driver_resolution_ctrl),
		.local_ib_ctl(local_ib_ctl),
		.rx_det_output_sel(rx_det_output_sel),
		.slew_rate_ctrl(slew_rate_ctrl),
		.swing_boost(swing_boost),
		.vcm_ctrl_sel(vcm_ctrl_sel),
		.vcm_current_addl(vcm_current_addl),
		.vod_boost(vod_boost),
		.fir_coeff_ctrl_sel(fir_coeff_ctrl_sel)

	)
	stratixv_hssi_pma_tx_buf_encrypted_inst	(
		.nonuserfrompmaux(nonuserfrompmaux),
		.rxdetclk(rxdetclk),
		.txdetrx(txdetrx),
		.txelecidl(txelecidl),
		.datain(datain),
		.txqpipullup(txqpipullup),
		.txqpipulldn(txqpipulldn),
		.fixedclkout(fixedclkout),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.dataout(dataout),
		.vrlpbkn(vrlpbkn),
		.vrlpbkp(vrlpbkp),
		.vrlpbkp1t(vrlpbkp1t),
		.vrlpbkn1t(vrlpbkn1t),
		.icoeff(icoeff),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_tx_cgb_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_cgb
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter mode = 8,	//Valid values: 8|10|16|20|32|40|64|80
	parameter x1_clock_source_sel = "x1_clk_unused",	//Valid values: up_segmented|down_segmented|ffpll|ch1_txpll_t|ch1_txpll_b|same_ch_txpll|hfclk_xn_up|hfclk_ch1_x6_dn|hfclk_xn_dn|hfclk_ch1_x6_up|lcpll_top|lcpll_bottom|up_segmented_g2_ch1_txpll_b_g3|up_segmented_g2_same_ch_txpll_g3|up_segmented_g2_lcpll_top_g3|up_segmented_g2_lcpll_bottom_g3|down_segmented_g2_ch1_txpll_b_g3|down_segmented_g2_same_ch_txpll_g3|down_segmented_g2_lcpll_top_g3|down_segmented_g2_lcpll_bottom_g3|ch1_txpll_t_g2_ch1_txpll_b_g3|ch1_txpll_t_g2_same_ch_txpll_g3|ch1_txpll_t_g2_lcpll_top_g3|ch1_txpll_t_g2_lcpll_bottom_g3|ch1_txpll_b_g2_ch1_txpll_t_g3|ch1_txpll_b_g2_lcpll_top_g3|ch1_txpll_b_g2_lcpll_bottom_g3|hfclk_xn_up_g2_ch1_txpll_t_g3|hfclk_xn_up_g2_lcpll_top_g3|hfclk_xn_up_g2_lcpll_bottom_g3|hfclk_ch1_x6_dn_g2_ch1_txpll_t_g3|hfclk_ch1_x6_dn_g2_lcpll_top_g3|hfclk_ch1_x6_dn_g2_lcpll_bottom_g3|hfclk_xn_dn_g2_ch1_txpll_t_g3|hfclk_xn_dn_g2_lcpll_top_g3|hfclk_xn_dn_g2_lcpll_bottom_g3|hfclk_ch1_x6_up_g2_ch1_txpll_t_g3|hfclk_ch1_x6_up_g2_lcpll_top_g3|hfclk_ch1_x6_up_g2_lcpll_bottom_g3|same_ch_txpll_g2_ch1_txpll_t_g3|same_ch_txpll_g2_lcpll_top_g3|same_ch_txpll_g2_lcpll_bottom_g3|lcpll_top_g2_ch1_txpll_t_g3|lcpll_top_g2_ch1_txpll_b_g3|lcpll_top_g2_same_ch_txpll_g3|lcpll_top_g2_lcpll_bottom_g3|lcpll_bottom_g2_ch1_txpll_t_g3|lcpll_bottom_g2_ch1_txpll_b_g3|lcpll_bottom_g2_same_ch_txpll_g3|lcpll_bottom_g2_lcpll_top_g3|x1_clk_unused
	parameter x1_div_m_sel = 1,	//Valid values: 1|2|4|8
	parameter xn_clock_source_sel = "cgb_xn_unused",	//Valid values: xn_up|ch1_x6_dn|xn_dn|ch1_x6_up|cgb_x1_m_div|cgb_ht|cgb_xn_unused
	parameter channel_number = 0,	//Valid values: 0..255
	parameter data_rate = "",	//Valid values: 
	parameter tx_mux_power_down = "normal",	//Valid values: power_down|normal
	parameter cgb_iqclk_sel = "cgb_x1_n_div",	//Valid values: rx_output|cgb_x1_n_div
	parameter clk_mute = "disable_clockmute",	//Valid values: disable_clockmute|enable_clock_mute|enable_clock_mute_master_channel
	parameter cgb_sync = "normal",	//Valid values: pcs_sync_rst|normal|sync_rst
	parameter reset_scheme = "non_reset_bonding_scheme",	//Valid values: non_reset_bonding_scheme|reset_bonding_scheme
	parameter pll_feedback = "non_pll_feedback",	//Valid values: non_pll_feedback|pll_feedback
	parameter pcie_g3_x8 = "non_pcie_g3_x8",	//Valid values: non_pcie_g3_x8|pcie_g3_x8
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 1:0 ] pciesw,
	input [ 0:0 ] rxclk,
	output [ 0:0 ] rxiqclk,
	input [ 0:0 ] rstn,
	output [ 1:0 ] pcieswdone,
	input [ 0:0 ] txpmasyncp,
	output [ 0:0 ] pllfbsw,
	output [ 0:0 ] pciesyncp,
	output [ 0:0 ] pciefbclk,
	input [ 0:0 ] clklct,
	input [ 0:0 ] clkblct,
	input [ 0:0 ] clklcb,
	input [ 0:0 ] clkblcb,
	input [ 0:0 ] clkcdrloc,
	input [ 0:0 ] clkbcdrloc,
	input [ 0:0 ] clkffpll,
	input [ 0:0 ] clkbffpll,
	input [ 0:0 ] clkupseg,
	input [ 0:0 ] clkbupseg,
	input [ 0:0 ] clkdnseg,
	input [ 0:0 ] clkbdnseg,
	input [ 0:0 ] clkbcdr1b,
	input [ 0:0 ] clkbcdr1t,
	input [ 0:0 ] clkcdr1b,
	input [ 0:0 ] clkcdr1t,
	output [ 0:0 ] cpulseout,
	output [ 0:0 ] hfclkpout,
	output [ 0:0 ] hfclknout,
	output [ 0:0 ] lfclkpout,
	output [ 0:0 ] lfclknout,
	output [ 2:0 ] pclkout,
	output [ 0:0 ] cpulse,
	output [ 0:0 ] hfclkp,
	output [ 0:0 ] hfclkn,
	output [ 0:0 ] lfclkp,
	output [ 0:0 ] lfclkn,
	output [ 2:0 ] pclk,
	input [ 0:0 ] cpulsex6dn,
	input [ 0:0 ] cpulsex6up,
	input [ 0:0 ] cpulsexndn,
	input [ 0:0 ] cpulsexnup,
	input [ 0:0 ] hfclknx6dn,
	input [ 0:0 ] hfclknx6up,
	input [ 0:0 ] hfclknxndn,
	input [ 0:0 ] hfclknxnup,
	input [ 0:0 ] hfclkpx6dn,
	input [ 0:0 ] hfclkpx6up,
	input [ 0:0 ] hfclkpxndn,
	input [ 0:0 ] hfclkpxnup,
	input [ 0:0 ] lfclknx6dn,
	input [ 0:0 ] lfclknx6up,
	input [ 0:0 ] lfclknxndn,
	input [ 0:0 ] lfclknxnup,
	input [ 0:0 ] lfclkpx6dn,
	input [ 0:0 ] lfclkpx6up,
	input [ 0:0 ] lfclkpxndn,
	input [ 0:0 ] lfclkpxnup,
	input [ 2:0 ] pclkx6dn,
	input [ 2:0 ] pclkx6up,
	input [ 2:0 ] pclkxndn,
	input [ 2:0 ] pclkxnup,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pma_tx_cgb_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.mode(mode),
		.x1_clock_source_sel(x1_clock_source_sel),
		.x1_div_m_sel(x1_div_m_sel),
		.xn_clock_source_sel(xn_clock_source_sel),
		.channel_number(channel_number),
		.data_rate(data_rate),
		.tx_mux_power_down(tx_mux_power_down),
		.cgb_iqclk_sel(cgb_iqclk_sel),
		.clk_mute(clk_mute),
		.cgb_sync(cgb_sync),
		.reset_scheme(reset_scheme),
		.pll_feedback(pll_feedback),
		.pcie_g3_x8(pcie_g3_x8),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pma_tx_cgb_encrypted_inst	(
		.pciesw(pciesw),
		.rxclk(rxclk),
		.rxiqclk(rxiqclk),
		.rstn(rstn),
		.pcieswdone(pcieswdone),
		.txpmasyncp(txpmasyncp),
		.pllfbsw(pllfbsw),
		.pciesyncp(pciesyncp),
		.pciefbclk(pciefbclk),
		.clklct(clklct),
		.clkblct(clkblct),
		.clklcb(clklcb),
		.clkblcb(clkblcb),
		.clkcdrloc(clkcdrloc),
		.clkbcdrloc(clkbcdrloc),
		.clkffpll(clkffpll),
		.clkbffpll(clkbffpll),
		.clkupseg(clkupseg),
		.clkbupseg(clkbupseg),
		.clkdnseg(clkdnseg),
		.clkbdnseg(clkbdnseg),
		.clkbcdr1b(clkbcdr1b),
		.clkbcdr1t(clkbcdr1t),
		.clkcdr1b(clkcdr1b),
		.clkcdr1t(clkcdr1t),
		.cpulseout(cpulseout),
		.hfclkpout(hfclkpout),
		.hfclknout(hfclknout),
		.lfclkpout(lfclkpout),
		.lfclknout(lfclknout),
		.pclkout(pclkout),
		.cpulse(cpulse),
		.hfclkp(hfclkp),
		.hfclkn(hfclkn),
		.lfclkp(lfclkp),
		.lfclkn(lfclkn),
		.pclk(pclk),
		.cpulsex6dn(cpulsex6dn),
		.cpulsex6up(cpulsex6up),
		.cpulsexndn(cpulsexndn),
		.cpulsexnup(cpulsexnup),
		.hfclknx6dn(hfclknx6dn),
		.hfclknx6up(hfclknx6up),
		.hfclknxndn(hfclknxndn),
		.hfclknxnup(hfclknxnup),
		.hfclkpx6dn(hfclkpx6dn),
		.hfclkpx6up(hfclkpx6up),
		.hfclkpxndn(hfclkpxndn),
		.hfclkpxnup(hfclkpxnup),
		.lfclknx6dn(lfclknx6dn),
		.lfclknx6up(lfclknx6up),
		.lfclknxndn(lfclknxndn),
		.lfclknxnup(lfclknxnup),
		.lfclkpx6dn(lfclkpx6dn),
		.lfclkpx6up(lfclkpx6up),
		.lfclkpxndn(lfclkpxndn),
		.lfclkpxnup(lfclkpxnup),
		.pclkx6dn(pclkx6dn),
		.pclkx6up(pclkx6up),
		.pclkxndn(pclkxndn),
		.pclkxnup(pclkxnup),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_tx_ser_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_ser
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter ser_loopback = "false",	//Valid values: false|true
	parameter pre_tap_en = "false",	//Valid values: false|true
	parameter post_tap_1_en = "false",	//Valid values: false|true
	parameter post_tap_2_en = "false",	//Valid values: false|true
	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter mode = 8,	//Valid values: 8|10|16|20|32|40|64|80
	parameter clk_divtx_deskew = 0,	//Valid values: 0..15
	parameter channel_number = 0,	//Valid values: 0..65
	parameter clk_forward_only_mode = "false",	//Valid values: false|true
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	output [ 0:0 ] lbvon,
	input [ 79:0 ] datain,
	output [ 0:0 ] preenout,
	input [ 0:0 ] slpbk,
	input [ 0:0 ] pciesyncp,
	input [ 0:0 ] cpulse,
	input [ 0:0 ] hfclkn,
	input [ 0:0 ] hfclk,
	input [ 0:0 ] lfclkn,
	input [ 0:0 ] lfclk,
	input [ 0:0 ] rstn,
	output [ 0:0 ] clkdivtx,
	output [ 0:0 ] lbvop,
	output [ 0:0 ] dataout,
	input [ 1:0 ] pciesw,
	input [ 2:0 ] pclk,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pma_tx_ser_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.ser_loopback(ser_loopback),
		.pre_tap_en(pre_tap_en),
		.post_tap_1_en(post_tap_1_en),
		.post_tap_2_en(post_tap_2_en),
		.auto_negotiation(auto_negotiation),
		.mode(mode),
		.clk_divtx_deskew(clk_divtx_deskew),
		.channel_number(channel_number),
		.clk_forward_only_mode(clk_forward_only_mode),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pma_tx_ser_encrypted_inst	(
		.lbvon(lbvon),
		.datain(datain),
		.preenout(preenout),
		.slpbk(slpbk),
		.pciesyncp(pciesyncp),
		.cpulse(cpulse),
		.hfclkn(hfclkn),
		.hfclk(hfclk),
		.lfclkn(lfclkn),
		.lfclk(lfclk),
		.rstn(rstn),
		.clkdivtx(clkdivtx),
		.lbvop(lbvop),
		.dataout(dataout),
		.pciesw(pciesw),
		.pclk(pclk),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_int_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_int
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter early_eios_sel = "pcs_early_eios",	//Valid values: pcs_early_eios|core_early_eios
	parameter ltr_sel = "pcs_ltr",	//Valid values: pcs_ltr|core_ltr
	parameter pcie_switch_sel = "pcs_pcie_switch_sw",	//Valid values: pcs_pcie_switch_sw|core_pcie_switch_sw
	parameter ppm_lock_sel = "pcs_ppm_lock",	//Valid values: pcs_ppm_lock|core_ppm_lock
	parameter lc_in_sel = "pcs_lc_in",	//Valid values: pcs_lc_in|core_lc_in
	parameter txdetectrx_sel = "pcs_txdetectrx",	//Valid values: pcs_txdetectrx|core_txdetectrx
	parameter tx_elec_idle_sel = "pcs_tx_elec_idle",	//Valid values: pcs_tx_elec_idle|core_tx_elec_idle
	parameter pclk_0_clk_sel = "pclk_0_power_down",	//Valid values: pclk_0_pma_rx_clk|pclk_0_pcs_rx_clk|pclk_0_clkdiv_att|pclk_0_pma_tx_clk|pclk_0_pcs_tx_clk|pclk_0_power_down
	parameter pclk_1_clk_sel = "pclk_1_power_down",	//Valid values: pclk_1_pma_rx_clk|pclk_1_pcs_rx_clk|pclk_1_clkdiv_att|pclk_1_pma_tx_clk|pclk_1_pcs_tx_clk|pclk_1_power_down
	parameter iqtxrxclk_a_sel = "tristage_outa",	//Valid values: iqtxrxclk_a_pma_rx_clk|iqtxrxclk_a_pcs_rx_clk|iqtxrxclk_a_pcie_fb_clk|iqtxrxclk_a_pma_tx_clk|iqtxrxclk_a_pcs_tx_clk|tristage_outa
	parameter iqtxrxclk_b_sel = "tristage_outb",	//Valid values: iqtxrxclk_b_pma_rx_clk|iqtxrxclk_b_pcs_rx_clk|iqtxrxclk_b_pcie_fb_clk|iqtxrxclk_b_pma_tx_clk|iqtxrxclk_b_pcs_tx_clk|tristage_outb
	parameter rx_data_out_sel = "teng_mode",	//Valid values: teng_mode|teng_direct_mode|att_direct_mode
	parameter rx_bbpd_cal_en = "pcs_cal_en",	//Valid values: pcs_cal_en|core_cal_en
	parameter dft_switch = "dft_switch_off",	//Valid values: dft_switch_off|dft_switch_on
	parameter cvp_mode = "cvp_mode_off",	//Valid values: cvp_mode_off|cvp_mode_on
	parameter channel_number = 0,	//Valid values: 0..255
	parameter ffclk_enable = "ffclk_off"	//Valid values: ffclk_off|ffclk_on
)
(
//input and output port declaration
	output [ 0:0 ] fref,
	input [ 0:0 ] frefatti,
	input [ 0:0 ] frefi,
	output [ 0:0 ] hclkpcs,
	input [ 0:0 ] hclkpcsi,
	input [ 17:0 ] icoeff,
	output [ 17:0 ] icoeffo,
	input [ 2:0 ] irxpreset,
	output [ 2:0 ] irxpreseto,
	output [ 0:0 ] iqtxrxclka,
	output [ 0:0 ] iqtxrxclkb,
	input [ 0:0 ] lcin,
	output [ 0:0 ] lcino,
	output [ 1:0 ] lcout,
	input [ 1:0 ] lcouti,
	output [ 0:0 ] ltdo,
	input [ 0:0 ] ltr,
	output [ 0:0 ] ltro,
	output [ 0:0 ] occaldone,
	input [ 0:0 ] occaldoneatti,
	input [ 0:0 ] occaldonei,
	input [ 0:0 ] occalen,
	output [ 0:0 ] occaleno,
	input [ 0:0 ] pciefbclk,
	output [ 1:0 ] pcieswdone,
	input [ 1:0 ] pcieswdonei,
	input [ 1:0 ] pcieswitch,
	output [ 1:0 ] pcieswitcho,
	input [ 0:0 ] pcsrxclkout,
	input [ 0:0 ] pcstxclkout,
	output [ 0:0 ] pfdmodelock,
	input [ 0:0 ] pfdmodelockatti,
	input [ 0:0 ] pfdmodelocki,
	output [ 0:0 ] adaptdone,
	input [ 0:0 ] adaptdonei,
	input [ 0:0 ] adcecapture,
	output [ 0:0 ] adcecaptureo,
	input [ 0:0 ] adcestandby,
	output [ 0:0 ] adcestandbyo,
	input [ 0:0 ] bslip,
	output [ 0:0 ] bslipo,
	input [ 1:0 ] byteen,
	output [ 1:0 ] byteeno,
	input [ 0:0 ] ccrurstb,
	input [ 0:0 ] cearlyeios,
	input [ 0:0 ] clcin,
	output [ 1:0 ] clcout,
	input [ 0:0 ] cltd,
	input [ 0:0 ] cltr,
	output [ 0:0 ] coccaldone,
	input [ 0:0 ] coccalen,
	output [ 1:0 ] cpcieswdone,
	input [ 1:0 ] cpcieswitch,
	output [ 1:0 ] cpclk,
	output [ 0:0 ] cpfdmodelock,
	input [ 0:0 ] cppmlock,
	input [ 0:0 ] crslpbk,
	output [ 0:0 ] crxdetectvalid,
	output [ 0:0 ] crxfound,
	output [ 0:0 ] crxplllock,
	output [ 0:0 ] csd,
	input [ 0:0 ] ctxelecidle,
	input [ 0:0 ] ctxdetectrx,
	input [ 0:0 ] ctxpmarstb,
	output [ 0:0 ] clk33pcs,
	input [ 0:0 ] clk33pcsi,
	input [ 0:0 ] clkdivatti,
	output [ 0:0 ] clkdivrx,
	input [ 0:0 ] clkdivrxatti,
	input [ 0:0 ] clkdivrxi,
	output [ 0:0 ] clkdivtx,
	input [ 0:0 ] clkdivtxatti,
	input [ 0:0 ] clkdivtxi,
	output [ 0:0 ] clklow,
	input [ 0:0 ] clklowatti,
	input [ 0:0 ] clklowi,
	output [ 0:0 ] crurstbo,
	input [ 0:0 ] dprioclk,
	output [ 0:0 ] dprioclko,
	input [ 0:0 ] dpriorstn,
	output [ 0:0 ] dpriorstno,
	input [ 0:0 ] earlyeios,
	output [ 0:0 ] earlyeioso,
	input [ 0:0 ] pldclk,
	output [ 0:0 ] pldclko,
	input [ 0:0 ] ppmlock,
	output [ 0:0 ] ppmlocko,
	output [ 79:0 ] rxdata,
	input [ 63:0 ] rxdataatti,
	input [ 79:0 ] rxdatacorei,
	input [ 39:0 ] rxdatai,
	input [ 0:0 ] rxdetclk,
	output [ 0:0 ] rxdetclko,
	output [ 0:0 ] rxdetectvalid,
	input [ 0:0 ] rxdetectvalidi,
	output [ 0:0 ] rxfound,
	input [ 0:0 ] rxfoundi,
	input [ 0:0 ] rxqpipulldn,
	output [ 0:0 ] rxqpipulldno,
	output [ 0:0 ] rxplllock,
	input [ 0:0 ] rxplllockatti,
	input [ 0:0 ] rxplllocki,
	input [ 0:0 ] rxpmarstb,
	output [ 0:0 ] rxpmarstbo,
	output [ 0:0 ] slpbko,
	output [ 0:0 ] sd,
	input [ 0:0 ] sdi,
	input [ 0:0 ] sershiftload,
	output [ 0:0 ] sershiftloado,
	output [ 0:0 ] signalok,
	output [ 7:0 ] testbus,
	input [ 7:0 ] testbusi,
	input [ 3:0 ] testsel,
	output [ 3:0 ] testselo,
	input [ 79:0 ] txdata,
	output [ 79:0 ] txdatao,
	input [ 0:0 ] txelecidle,
	output [ 0:0 ] txelecidleo,
	input [ 0:0 ] txpmasyncp,
	output [ 0:0 ] txpmasyncpo,
	input [ 0:0 ] txqpipulldn,
	output [ 0:0 ] txqpipulldno,
	input [ 0:0 ] txqpipullup,
	output [ 0:0 ] txqpipullupo,
	input [ 0:0 ] txdetectrx,
	output [ 0:0 ] txdetectrxo,
	output [ 0:0 ] txpmarstbo,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_pma_int_encrypted 
	#(
		.enable_debug_info(enable_debug_info),
		.early_eios_sel(early_eios_sel),
		.ltr_sel(ltr_sel),
		.pcie_switch_sel(pcie_switch_sel),
		.ppm_lock_sel(ppm_lock_sel),
		.lc_in_sel(lc_in_sel),
		.txdetectrx_sel(txdetectrx_sel),
		.tx_elec_idle_sel(tx_elec_idle_sel),
		.pclk_0_clk_sel(pclk_0_clk_sel),
		.pclk_1_clk_sel(pclk_1_clk_sel),
		.iqtxrxclk_a_sel(iqtxrxclk_a_sel),
		.iqtxrxclk_b_sel(iqtxrxclk_b_sel),
		.rx_data_out_sel(rx_data_out_sel),
		.rx_bbpd_cal_en(rx_bbpd_cal_en),
		.dft_switch(dft_switch),
		.cvp_mode(cvp_mode),
		.channel_number(channel_number),
		.ffclk_enable(ffclk_enable)

	)
	stratixv_hssi_pma_int_encrypted_inst	(
		.fref(fref),
		.frefatti(frefatti),
		.frefi(frefi),
		.hclkpcs(hclkpcs),
		.hclkpcsi(hclkpcsi),
		.icoeff(icoeff),
		.icoeffo(icoeffo),
		.irxpreset(irxpreset),
		.irxpreseto(irxpreseto),
		.iqtxrxclka(iqtxrxclka),
		.iqtxrxclkb(iqtxrxclkb),
		.lcin(lcin),
		.lcino(lcino),
		.lcout(lcout),
		.lcouti(lcouti),
		.ltdo(ltdo),
		.ltr(ltr),
		.ltro(ltro),
		.occaldone(occaldone),
		.occaldoneatti(occaldoneatti),
		.occaldonei(occaldonei),
		.occalen(occalen),
		.occaleno(occaleno),
		.pciefbclk(pciefbclk),
		.pcieswdone(pcieswdone),
		.pcieswdonei(pcieswdonei),
		.pcieswitch(pcieswitch),
		.pcieswitcho(pcieswitcho),
		.pcsrxclkout(pcsrxclkout),
		.pcstxclkout(pcstxclkout),
		.pfdmodelock(pfdmodelock),
		.pfdmodelockatti(pfdmodelockatti),
		.pfdmodelocki(pfdmodelocki),
		.adaptdone(adaptdone),
		.adaptdonei(adaptdonei),
		.adcecapture(adcecapture),
		.adcecaptureo(adcecaptureo),
		.adcestandby(adcestandby),
		.adcestandbyo(adcestandbyo),
		.bslip(bslip),
		.bslipo(bslipo),
		.byteen(byteen),
		.byteeno(byteeno),
		.ccrurstb(ccrurstb),
		.cearlyeios(cearlyeios),
		.clcin(clcin),
		.clcout(clcout),
		.cltd(cltd),
		.cltr(cltr),
		.coccaldone(coccaldone),
		.coccalen(coccalen),
		.cpcieswdone(cpcieswdone),
		.cpcieswitch(cpcieswitch),
		.cpclk(cpclk),
		.cpfdmodelock(cpfdmodelock),
		.cppmlock(cppmlock),
		.crslpbk(crslpbk),
		.crxdetectvalid(crxdetectvalid),
		.crxfound(crxfound),
		.crxplllock(crxplllock),
		.csd(csd),
		.ctxelecidle(ctxelecidle),
		.ctxdetectrx(ctxdetectrx),
		.ctxpmarstb(ctxpmarstb),
		.clk33pcs(clk33pcs),
		.clk33pcsi(clk33pcsi),
		.clkdivatti(clkdivatti),
		.clkdivrx(clkdivrx),
		.clkdivrxatti(clkdivrxatti),
		.clkdivrxi(clkdivrxi),
		.clkdivtx(clkdivtx),
		.clkdivtxatti(clkdivtxatti),
		.clkdivtxi(clkdivtxi),
		.clklow(clklow),
		.clklowatti(clklowatti),
		.clklowi(clklowi),
		.crurstbo(crurstbo),
		.dprioclk(dprioclk),
		.dprioclko(dprioclko),
		.dpriorstn(dpriorstn),
		.dpriorstno(dpriorstno),
		.earlyeios(earlyeios),
		.earlyeioso(earlyeioso),
		.pldclk(pldclk),
		.pldclko(pldclko),
		.ppmlock(ppmlock),
		.ppmlocko(ppmlocko),
		.rxdata(rxdata),
		.rxdataatti(rxdataatti),
		.rxdatacorei(rxdatacorei),
		.rxdatai(rxdatai),
		.rxdetclk(rxdetclk),
		.rxdetclko(rxdetclko),
		.rxdetectvalid(rxdetectvalid),
		.rxdetectvalidi(rxdetectvalidi),
		.rxfound(rxfound),
		.rxfoundi(rxfoundi),
		.rxqpipulldn(rxqpipulldn),
		.rxqpipulldno(rxqpipulldno),
		.rxplllock(rxplllock),
		.rxplllockatti(rxplllockatti),
		.rxplllocki(rxplllocki),
		.rxpmarstb(rxpmarstb),
		.rxpmarstbo(rxpmarstbo),
		.slpbko(slpbko),
		.sd(sd),
		.sdi(sdi),
		.sershiftload(sershiftload),
		.sershiftloado(sershiftloado),
		.signalok(signalok),
		.testbus(testbus),
		.testbusi(testbusi),
		.testsel(testsel),
		.testselo(testselo),
		.txdata(txdata),
		.txdatao(txdatao),
		.txelecidle(txelecidle),
		.txelecidleo(txelecidleo),
		.txpmasyncp(txpmasyncp),
		.txpmasyncpo(txpmasyncpo),
		.txqpipulldn(txqpipulldn),
		.txqpipulldno(txqpipulldno),
		.txqpipullup(txqpipullup),
		.txqpipullupo(txqpipullupo),
		.txdetectrx(txdetectrx),
		.txdetectrxo(txdetectrxo),
		.txpmarstbo(txpmarstbo),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_common_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_common_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "disabled_prot_mode",	//Valid values: disabled_prot_mode|pipe_g1|pipe_g2|pipe_g3|other_protocols
	parameter pcie_gen3_cap = "non_pcie_gen3_cap",	//Valid values: pcie_gen3_cap|non_pcie_gen3_cap
	parameter refclk_dig_sel = "refclk_dig_dis",	//Valid values: refclk_dig_dis|refclk_dig_en
	parameter force_freqdet = "force_freqdet_dis",	//Valid values: force_freqdet_dis|force1_freqdet_en|force0_freqdet_en
	parameter ppmsel = "ppmsel_default",	//Valid values: ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other
	parameter ppm_cnt_rst = "ppm_cnt_rst_dis",	//Valid values: ppm_cnt_rst_dis|ppm_cnt_rst_en
	parameter auto_speed_ena = "dis_auto_speed_ena",	//Valid values: dis_auto_speed_ena|en_auto_speed_ena
	parameter ppm_gen1_2_cnt = "cnt_32k",	//Valid values: cnt_32k|cnt_64k
	parameter ppm_post_eidle_delay = "cnt_200_cycles",	//Valid values: cnt_200_cycles|cnt_400_cycles
	parameter func_mode = "disable",	//Valid values: disable|pma_direct|hrdrstctrl_cmu|eightg_only_pld|eightg_and_g3|eightg_only_emsip|teng_only|eightgtx_and_tengrx|eightgrx_and_tengtx
	parameter pma_if_dft_val = "dft_0",	//Valid values: dft_0
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode|stretch_mode
	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|pcie_gen3
	parameter ppm_deassert_early = "deassert_early_dis",	//Valid values: deassert_early_dis|deassert_early_en
	parameter pipe_if_g3pcs = "pipe_if_8gpcs",	//Valid values: pipe_if_g3pcs|pipe_if_8gpcs
	parameter pma_if_dft_en = "dft_dis",	//Valid values: dft_dis
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] fref,
	input [ 0:0 ] clklow,
	output [ 0:0 ] freqlock,
	input [ 1:0 ] pmapcieswdone,
	output [ 1:0 ] pmapcieswitch,
	input [ 0:0 ] pmarxfound,
	input [ 0:0 ] pmarxdetectvalid,
	output [ 0:0 ] pmaearlyeios,
	output [ 0:0 ] pmatxdetectrx,
	output [ 0:0 ] pmatxelecidle,
	output [ 17:0 ] pmacurrentcoeff,
	output [ 2:0 ] pmacurrentrxpreset,
	input [ 0:0 ] pmahclk,
	input [ 0:0 ] pmaoffcalenin,
	output [ 0:0 ] pmaoffcaldone,
	output [ 0:0 ] pmalccmurstb,
	output [ 0:0 ] pmaltr,
	input [ 0:0 ] aggrcvdclkagg,
	input [ 7:0 ] aggtxdatats,
	input [ 0:0 ] aggtxctlts,
	input [ 0:0 ] aggfiforstrdqd,
	input [ 0:0 ] aggendskwqd,
	input [ 0:0 ] aggendskwrdptrs,
	input [ 0:0 ] aggalignstatus,
	input [ 0:0 ] aggalignstatussync0,
	input [ 0:0 ] aggcgcomprddall,
	input [ 0:0 ] aggcgcompwrall,
	input [ 0:0 ] aggfifordincomp0,
	input [ 0:0 ] aggdelcondmet0,
	input [ 0:0 ] agginsertincomplete0,
	input [ 0:0 ] aggfifoovr0,
	input [ 0:0 ] agglatencycomp0,
	input [ 7:0 ] aggrxdatars,
	input [ 0:0 ] aggrxcontrolrs,
	input [ 0:0 ] aggrcvdclkaggtoporbot,
	input [ 7:0 ] aggtxdatatstoporbot,
	input [ 0:0 ] aggtxctltstoporbot,
	input [ 0:0 ] aggfiforstrdqdtoporbot,
	input [ 0:0 ] aggendskwqdtoporbot,
	input [ 0:0 ] aggendskwrdptrstoporbot,
	input [ 0:0 ] aggalignstatustoporbot,
	input [ 0:0 ] aggalignstatussync0toporbot,
	input [ 0:0 ] aggcgcomprddalltoporbot,
	input [ 0:0 ] aggcgcompwralltoporbot,
	input [ 0:0 ] aggfifordincomp0toporbot,
	input [ 0:0 ] aggdelcondmet0toporbot,
	input [ 0:0 ] agginsertincomplete0toporbot,
	input [ 0:0 ] aggfifoovr0toporbot,
	input [ 0:0 ] agglatencycomp0toporbot,
	input [ 7:0 ] aggrxdatarstoporbot,
	input [ 0:0 ] aggrxcontrolrstoporbot,
	output [ 0:0 ] aggtxpcsrst,
	output [ 0:0 ] aggrxpcsrst,
	output [ 7:0 ] aggtxdatatc,
	output [ 0:0 ] aggtxctltc,
	output [ 0:0 ] aggrdenablesync,
	output [ 0:0 ] aggsyncstatus,
	output [ 1:0 ] aggaligndetsync,
	output [ 1:0 ] aggrdalign,
	output [ 0:0 ] aggalignstatussync,
	output [ 0:0 ] aggfifordoutcomp,
	output [ 1:0 ] aggcgcomprddout,
	output [ 1:0 ] aggcgcompwrout,
	output [ 0:0 ] aggdelcondmetout,
	output [ 0:0 ] aggfifoovrout,
	output [ 0:0 ] agglatencycompout,
	output [ 0:0 ] agginsertincompleteout,
	output [ 0:0 ] aggdecdatavalid,
	output [ 7:0 ] aggdecdata,
	output [ 0:0 ] aggdecctl,
	output [ 1:0 ] aggrunningdisp,
	output [ 0:0 ] pcsgen3pmarxdetectvalid,
	output [ 0:0 ] pcsgen3pmarxfound,
	output [ 1:0 ] pcsgen3pmapcieswdone,
	input [ 1:0 ] pcsgen3pmapcieswitch,
	input [ 17:0 ] pcsgen3pmacurrentcoeff,
	input [ 2:0 ] pcsgen3pmacurrentrxpreset,
	input [ 0:0 ] pcsgen3pmatxelecidle,
	input [ 0:0 ] pcsgen3pmatxdetectrx,
	input [ 0:0 ] pcsgen3ppmeidleexit,
	input [ 0:0 ] pcsgen3pmaltr,
	input [ 0:0 ] pcsgen3pmaearlyeios,
	input [ 0:0 ] pcs8gpcieswitch,
	input [ 0:0 ] pcs8gtxelecidle,
	input [ 0:0 ] pcs8gtxdetectrx,
	input [ 0:0 ] pcs8gearlyeios,
	input [ 0:0 ] pcs8gltrpma,
	input [ 0:0 ] pcs8geidleexit,
	output [ 0:0 ] pcsgen3pllfixedclk,
	output [ 0:0 ] pcsaggrcvdclkagg,
	output [ 7:0 ] pcsaggtxdatats,
	output [ 0:0 ] pcsaggtxctlts,
	output [ 0:0 ] pcsaggfiforstrdqd,
	output [ 0:0 ] pcsaggendskwqd,
	output [ 0:0 ] pcsaggendskwrdptrs,
	output [ 0:0 ] pcsaggalignstatus,
	output [ 0:0 ] pcsaggalignstatussync0,
	output [ 0:0 ] pcsaggcgcomprddall,
	output [ 0:0 ] pcsaggcgcompwrall,
	output [ 0:0 ] pcsaggfifordincomp0,
	output [ 0:0 ] pcsaggdelcondmet0,
	output [ 0:0 ] pcsagginsertincomplete0,
	output [ 0:0 ] pcsaggfifoovr0,
	output [ 0:0 ] pcsagglatencycomp0,
	output [ 7:0 ] pcsaggrxdatars,
	output [ 0:0 ] pcsaggrxcontrolrs,
	output [ 0:0 ] pcsaggrcvdclkaggtoporbot,
	output [ 7:0 ] pcsaggtxdatatstoporbot,
	output [ 0:0 ] pcsaggtxctltstoporbot,
	output [ 0:0 ] pcsaggfiforstrdqdtoporbot,
	output [ 0:0 ] pcsaggendskwqdtoporbot,
	output [ 0:0 ] pcsaggendskwrdptrstoporbot,
	output [ 0:0 ] pcsaggalignstatustoporbot,
	output [ 0:0 ] pcsaggalignstatussync0toporbot,
	output [ 0:0 ] pcsaggcgcomprddalltoporbot,
	output [ 0:0 ] pcsaggcgcompwralltoporbot,
	output [ 0:0 ] pcsaggfifordincomp0toporbot,
	output [ 0:0 ] pcsaggdelcondmet0toporbot,
	output [ 0:0 ] pcsagginsertincomplete0toporbot,
	output [ 0:0 ] pcsaggfifoovr0toporbot,
	output [ 0:0 ] pcsagglatencycomp0toporbot,
	output [ 7:0 ] pcsaggrxdatarstoporbot,
	output [ 0:0 ] pcsaggrxcontrolrstoporbot,
	input [ 0:0 ] pcsaggtxpcsrst,
	input [ 0:0 ] pcsaggrxpcsrst,
	input [ 7:0 ] pcsaggtxdatatc,
	input [ 0:0 ] pcsaggtxctltc,
	input [ 0:0 ] pcsaggrdenablesync,
	input [ 0:0 ] pcsaggsyncstatus,
	input [ 1:0 ] pcsaggaligndetsync,
	input [ 1:0 ] pcsaggrdalign,
	input [ 0:0 ] pcsaggalignstatussync,
	input [ 0:0 ] pcsaggfifordoutcomp,
	input [ 1:0 ] pcsaggcgcomprddout,
	input [ 1:0 ] pcsaggcgcompwrout,
	input [ 0:0 ] pcsaggdelcondmetout,
	input [ 0:0 ] pcsaggfifoovrout,
	input [ 0:0 ] pcsagglatencycompout,
	input [ 0:0 ] pcsagginsertincompleteout,
	input [ 0:0 ] pcsaggdecdatavalid,
	input [ 7:0 ] pcsaggdecdata,
	input [ 0:0 ] pcsaggdecctl,
	input [ 1:0 ] pcsaggrunningdisp,
	output [ 0:0 ] pcs8grxdetectvalid,
	output [ 0:0 ] pcs8gpmarxfound,
	output [ 0:0 ] pcs8ggen2ngen1,
	output [ 0:0 ] pcs8gpowerstatetransitiondone,
	output [ 0:0 ] pldhclkout,
	input [ 0:0 ] pcsscanmoden,
	input [ 0:0 ] pcsscanshiftn,
	input [ 0:0 ] pcsrefclkdig,
	input [ 0:0 ] pcsaggscanmoden,
	input [ 0:0 ] pcsaggscanshiftn,
	input [ 0:0 ] pcsaggrefclkdig,
	output [ 0:0 ] aggscanmoden,
	output [ 0:0 ] aggscanshiftn,
	output [ 0:0 ] aggrefclkdig,
	input [ 0:0 ] pcsgen3gen3datasel,
	input [ 0:0 ] pldlccmurstb,
	output [ 0:0 ] pmafrefout,
	output [ 0:0 ] pmaclklowout,
	input [ 0:0 ] pmarxpmarstb,
	output [ 0:0 ] asynchdatain,
	input [ 0:0 ] pldtestsitoaggin,
	input [ 0:0 ] resetppmcntrs,
	input [ 0:0 ] pldpartialreconfig,
	output [ 0:0 ] aggtestsotopldout,
	input [ 15:0 ] aggtestbus,
	input [ 0:0 ] pldnfrzdrv,
	input [ 0:0 ] hardreset,
	output [ 15:0 ] pcsaggtestbus,
	output [ 9:0 ] pmaiftestbus,
	output [ 0:0 ] pmanfrzdrv,
	input [ 17:0 ] pcs8gpmacurrentcoeff,
	output [ 0:0 ] pldtestsitoaggout,
	input [ 0:0 ] aggtestsotopldin,
	output [ 0:0 ] pmapartialreconfig,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_common_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.pcie_gen3_cap(pcie_gen3_cap),
		.refclk_dig_sel(refclk_dig_sel),
		.force_freqdet(force_freqdet),
		.ppmsel(ppmsel),
		.ppm_cnt_rst(ppm_cnt_rst),
		.auto_speed_ena(auto_speed_ena),
		.ppm_gen1_2_cnt(ppm_gen1_2_cnt),
		.ppm_post_eidle_delay(ppm_post_eidle_delay),
		.func_mode(func_mode),
		.pma_if_dft_val(pma_if_dft_val),
		.sup_mode(sup_mode),
		.selectpcs(selectpcs),
		.ppm_deassert_early(ppm_deassert_early),
		.pipe_if_g3pcs(pipe_if_g3pcs),
		.pma_if_dft_en(pma_if_dft_en),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_common_pcs_pma_interface_encrypted_inst	(
		.fref(fref),
		.clklow(clklow),
		.freqlock(freqlock),
		.pmapcieswdone(pmapcieswdone),
		.pmapcieswitch(pmapcieswitch),
		.pmarxfound(pmarxfound),
		.pmarxdetectvalid(pmarxdetectvalid),
		.pmaearlyeios(pmaearlyeios),
		.pmatxdetectrx(pmatxdetectrx),
		.pmatxelecidle(pmatxelecidle),
		.pmacurrentcoeff(pmacurrentcoeff),
		.pmacurrentrxpreset(pmacurrentrxpreset),
		.pmahclk(pmahclk),
		.pmaoffcalenin(pmaoffcalenin),
		.pmaoffcaldone(pmaoffcaldone),
		.pmalccmurstb(pmalccmurstb),
		.pmaltr(pmaltr),
		.aggrcvdclkagg(aggrcvdclkagg),
		.aggtxdatats(aggtxdatats),
		.aggtxctlts(aggtxctlts),
		.aggfiforstrdqd(aggfiforstrdqd),
		.aggendskwqd(aggendskwqd),
		.aggendskwrdptrs(aggendskwrdptrs),
		.aggalignstatus(aggalignstatus),
		.aggalignstatussync0(aggalignstatussync0),
		.aggcgcomprddall(aggcgcomprddall),
		.aggcgcompwrall(aggcgcompwrall),
		.aggfifordincomp0(aggfifordincomp0),
		.aggdelcondmet0(aggdelcondmet0),
		.agginsertincomplete0(agginsertincomplete0),
		.aggfifoovr0(aggfifoovr0),
		.agglatencycomp0(agglatencycomp0),
		.aggrxdatars(aggrxdatars),
		.aggrxcontrolrs(aggrxcontrolrs),
		.aggrcvdclkaggtoporbot(aggrcvdclkaggtoporbot),
		.aggtxdatatstoporbot(aggtxdatatstoporbot),
		.aggtxctltstoporbot(aggtxctltstoporbot),
		.aggfiforstrdqdtoporbot(aggfiforstrdqdtoporbot),
		.aggendskwqdtoporbot(aggendskwqdtoporbot),
		.aggendskwrdptrstoporbot(aggendskwrdptrstoporbot),
		.aggalignstatustoporbot(aggalignstatustoporbot),
		.aggalignstatussync0toporbot(aggalignstatussync0toporbot),
		.aggcgcomprddalltoporbot(aggcgcomprddalltoporbot),
		.aggcgcompwralltoporbot(aggcgcompwralltoporbot),
		.aggfifordincomp0toporbot(aggfifordincomp0toporbot),
		.aggdelcondmet0toporbot(aggdelcondmet0toporbot),
		.agginsertincomplete0toporbot(agginsertincomplete0toporbot),
		.aggfifoovr0toporbot(aggfifoovr0toporbot),
		.agglatencycomp0toporbot(agglatencycomp0toporbot),
		.aggrxdatarstoporbot(aggrxdatarstoporbot),
		.aggrxcontrolrstoporbot(aggrxcontrolrstoporbot),
		.aggtxpcsrst(aggtxpcsrst),
		.aggrxpcsrst(aggrxpcsrst),
		.aggtxdatatc(aggtxdatatc),
		.aggtxctltc(aggtxctltc),
		.aggrdenablesync(aggrdenablesync),
		.aggsyncstatus(aggsyncstatus),
		.aggaligndetsync(aggaligndetsync),
		.aggrdalign(aggrdalign),
		.aggalignstatussync(aggalignstatussync),
		.aggfifordoutcomp(aggfifordoutcomp),
		.aggcgcomprddout(aggcgcomprddout),
		.aggcgcompwrout(aggcgcompwrout),
		.aggdelcondmetout(aggdelcondmetout),
		.aggfifoovrout(aggfifoovrout),
		.agglatencycompout(agglatencycompout),
		.agginsertincompleteout(agginsertincompleteout),
		.aggdecdatavalid(aggdecdatavalid),
		.aggdecdata(aggdecdata),
		.aggdecctl(aggdecctl),
		.aggrunningdisp(aggrunningdisp),
		.pcsgen3pmarxdetectvalid(pcsgen3pmarxdetectvalid),
		.pcsgen3pmarxfound(pcsgen3pmarxfound),
		.pcsgen3pmapcieswdone(pcsgen3pmapcieswdone),
		.pcsgen3pmapcieswitch(pcsgen3pmapcieswitch),
		.pcsgen3pmacurrentcoeff(pcsgen3pmacurrentcoeff),
		.pcsgen3pmacurrentrxpreset(pcsgen3pmacurrentrxpreset),
		.pcsgen3pmatxelecidle(pcsgen3pmatxelecidle),
		.pcsgen3pmatxdetectrx(pcsgen3pmatxdetectrx),
		.pcsgen3ppmeidleexit(pcsgen3ppmeidleexit),
		.pcsgen3pmaltr(pcsgen3pmaltr),
		.pcsgen3pmaearlyeios(pcsgen3pmaearlyeios),
		.pcs8gpcieswitch(pcs8gpcieswitch),
		.pcs8gtxelecidle(pcs8gtxelecidle),
		.pcs8gtxdetectrx(pcs8gtxdetectrx),
		.pcs8gearlyeios(pcs8gearlyeios),
		.pcs8gltrpma(pcs8gltrpma),
		.pcs8geidleexit(pcs8geidleexit),
		.pcsgen3pllfixedclk(pcsgen3pllfixedclk),
		.pcsaggrcvdclkagg(pcsaggrcvdclkagg),
		.pcsaggtxdatats(pcsaggtxdatats),
		.pcsaggtxctlts(pcsaggtxctlts),
		.pcsaggfiforstrdqd(pcsaggfiforstrdqd),
		.pcsaggendskwqd(pcsaggendskwqd),
		.pcsaggendskwrdptrs(pcsaggendskwrdptrs),
		.pcsaggalignstatus(pcsaggalignstatus),
		.pcsaggalignstatussync0(pcsaggalignstatussync0),
		.pcsaggcgcomprddall(pcsaggcgcomprddall),
		.pcsaggcgcompwrall(pcsaggcgcompwrall),
		.pcsaggfifordincomp0(pcsaggfifordincomp0),
		.pcsaggdelcondmet0(pcsaggdelcondmet0),
		.pcsagginsertincomplete0(pcsagginsertincomplete0),
		.pcsaggfifoovr0(pcsaggfifoovr0),
		.pcsagglatencycomp0(pcsagglatencycomp0),
		.pcsaggrxdatars(pcsaggrxdatars),
		.pcsaggrxcontrolrs(pcsaggrxcontrolrs),
		.pcsaggrcvdclkaggtoporbot(pcsaggrcvdclkaggtoporbot),
		.pcsaggtxdatatstoporbot(pcsaggtxdatatstoporbot),
		.pcsaggtxctltstoporbot(pcsaggtxctltstoporbot),
		.pcsaggfiforstrdqdtoporbot(pcsaggfiforstrdqdtoporbot),
		.pcsaggendskwqdtoporbot(pcsaggendskwqdtoporbot),
		.pcsaggendskwrdptrstoporbot(pcsaggendskwrdptrstoporbot),
		.pcsaggalignstatustoporbot(pcsaggalignstatustoporbot),
		.pcsaggalignstatussync0toporbot(pcsaggalignstatussync0toporbot),
		.pcsaggcgcomprddalltoporbot(pcsaggcgcomprddalltoporbot),
		.pcsaggcgcompwralltoporbot(pcsaggcgcompwralltoporbot),
		.pcsaggfifordincomp0toporbot(pcsaggfifordincomp0toporbot),
		.pcsaggdelcondmet0toporbot(pcsaggdelcondmet0toporbot),
		.pcsagginsertincomplete0toporbot(pcsagginsertincomplete0toporbot),
		.pcsaggfifoovr0toporbot(pcsaggfifoovr0toporbot),
		.pcsagglatencycomp0toporbot(pcsagglatencycomp0toporbot),
		.pcsaggrxdatarstoporbot(pcsaggrxdatarstoporbot),
		.pcsaggrxcontrolrstoporbot(pcsaggrxcontrolrstoporbot),
		.pcsaggtxpcsrst(pcsaggtxpcsrst),
		.pcsaggrxpcsrst(pcsaggrxpcsrst),
		.pcsaggtxdatatc(pcsaggtxdatatc),
		.pcsaggtxctltc(pcsaggtxctltc),
		.pcsaggrdenablesync(pcsaggrdenablesync),
		.pcsaggsyncstatus(pcsaggsyncstatus),
		.pcsaggaligndetsync(pcsaggaligndetsync),
		.pcsaggrdalign(pcsaggrdalign),
		.pcsaggalignstatussync(pcsaggalignstatussync),
		.pcsaggfifordoutcomp(pcsaggfifordoutcomp),
		.pcsaggcgcomprddout(pcsaggcgcomprddout),
		.pcsaggcgcompwrout(pcsaggcgcompwrout),
		.pcsaggdelcondmetout(pcsaggdelcondmetout),
		.pcsaggfifoovrout(pcsaggfifoovrout),
		.pcsagglatencycompout(pcsagglatencycompout),
		.pcsagginsertincompleteout(pcsagginsertincompleteout),
		.pcsaggdecdatavalid(pcsaggdecdatavalid),
		.pcsaggdecdata(pcsaggdecdata),
		.pcsaggdecctl(pcsaggdecctl),
		.pcsaggrunningdisp(pcsaggrunningdisp),
		.pcs8grxdetectvalid(pcs8grxdetectvalid),
		.pcs8gpmarxfound(pcs8gpmarxfound),
		.pcs8ggen2ngen1(pcs8ggen2ngen1),
		.pcs8gpowerstatetransitiondone(pcs8gpowerstatetransitiondone),
		.pldhclkout(pldhclkout),
		.pcsscanmoden(pcsscanmoden),
		.pcsscanshiftn(pcsscanshiftn),
		.pcsrefclkdig(pcsrefclkdig),
		.pcsaggscanmoden(pcsaggscanmoden),
		.pcsaggscanshiftn(pcsaggscanshiftn),
		.pcsaggrefclkdig(pcsaggrefclkdig),
		.aggscanmoden(aggscanmoden),
		.aggscanshiftn(aggscanshiftn),
		.aggrefclkdig(aggrefclkdig),
		.pcsgen3gen3datasel(pcsgen3gen3datasel),
		.pldlccmurstb(pldlccmurstb),
		.pmafrefout(pmafrefout),
		.pmaclklowout(pmaclklowout),
		.pmarxpmarstb(pmarxpmarstb),
		.asynchdatain(asynchdatain),
		.pldtestsitoaggin(pldtestsitoaggin),
		.resetppmcntrs(resetppmcntrs),
		.pldpartialreconfig(pldpartialreconfig),
		.aggtestsotopldout(aggtestsotopldout),
		.aggtestbus(aggtestbus),
		.pldnfrzdrv(pldnfrzdrv),
		.hardreset(hardreset),
		.pcsaggtestbus(pcsaggtestbus),
		.pmaiftestbus(pmaiftestbus),
		.pmanfrzdrv(pmanfrzdrv),
		.pcs8gpmacurrentcoeff(pcs8gpmacurrentcoeff),
		.pldtestsitoaggout(pldtestsitoaggout),
		.aggtestsotopldin(aggtestsotopldin),
		.pmapartialreconfig(pmapartialreconfig),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_common_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_common_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter emsip_enable = "emsip_disable",	//Valid values: emsip_enable|emsip_disable
	parameter pld_side_reserved_source0 = "pld_res0",	//Valid values: pld_res0|emsip_res0
	parameter hrdrstctrl_en_cfgusr = "hrst_dis_cfgusr",	//Valid values: hrst_dis_cfgusr|hrst_en_cfgusr
	parameter pld_side_reserved_source10 = "pld_res10",	//Valid values: pld_res10|emsip_res10
	parameter data_source = "pld",	//Valid values: emsip|pld
	parameter pld_side_reserved_source1 = "pld_res1",	//Valid values: pld_res1|emsip_res1
	parameter pld_side_reserved_source2 = "pld_res2",	//Valid values: pld_res2|emsip_res2
	parameter pld_side_reserved_source3 = "pld_res3",	//Valid values: pld_res3|emsip_res3
	parameter pld_side_reserved_source4 = "pld_res4",	//Valid values: pld_res4|emsip_res4
	parameter pld_side_reserved_source5 = "pld_res5",	//Valid values: pld_res5|emsip_res5
	parameter pld_side_reserved_source6 = "pld_res6",	//Valid values: pld_res6|emsip_res6
	parameter pld_side_reserved_source7 = "pld_res7",	//Valid values: pld_res7|emsip_res7
	parameter pld_side_reserved_source8 = "pld_res8",	//Valid values: pld_res8|emsip_res8
	parameter pld_side_reserved_source9 = "pld_res9",	//Valid values: pld_res9|emsip_res9
	parameter hrdrstctrl_en_cfg = "hrst_dis_cfg",	//Valid values: hrst_dis_cfg|hrst_en_cfg
	parameter testbus_sel = "eight_g_pcs",	//Valid values: eight_g_pcs|g3_pcs|ten_g_pcs|pma_if
	parameter usrmode_sel4rst = "usermode",	//Valid values: usermode|last_frz
	parameter pld_side_reserved_source11 = "pld_res11",	//Valid values: pld_res11|emsip_res11
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	output [ 19:0 ] pldtestdata,
	input [ 0:0 ] pldscanmoden,
	input [ 0:0 ] pldscanshiftn,
	input [ 0:0 ] pld10grefclkdig,
	input [ 0:0 ] pld8grefclkdig,
	input [ 0:0 ] pldaggrefclkdig,
	input [ 0:0 ] pldpcspmaifrefclkdig,
	input [ 1:0 ] pldrate,
	input [ 2:0 ] pldeidleinfersel,
	input [ 0:0 ] pld8gprbsciden,
	input [ 0:0 ] pld8gtxelecidle,
	input [ 0:0 ] pld8gtxdetectrxloopback,
	input [ 0:0 ] pld8gtxdeemph,
	input [ 2:0 ] pld8gtxmargin,
	input [ 0:0 ] pld8gtxswing,
	input [ 0:0 ] pld8grxpolarity,
	input [ 1:0 ] pld8gpowerdown,
	output [ 0:0 ] pld8grxvalid,
	output [ 0:0 ] pld8grxelecidle,
	output [ 2:0 ] pld8grxstatus,
	output [ 0:0 ] pld8gphystatus,
	input [ 17:0 ] pldgen3currentcoeff,
	input [ 2:0 ] pldgen3currentrxpreset,
	input [ 0:0 ] pldoffcaldonein,
	output [ 0:0 ] pldoffcalen,
	output [ 0:0 ] pcs10ghardreset,
	output [ 0:0 ] pcs10ghardresetn,
	output [ 0:0 ] pcs10grefclkdig,
	input [ 19:0 ] pcs10gtestdata,
	output [ 0:0 ] pcs8gscanmoden,
	output [ 0:0 ] pcs8grefclkdig,
	output [ 0:0 ] pcs8gprbsciden,
	output [ 0:0 ] pcs8gltr,
	output [ 0:0 ] pcs8gtxelecidle,
	output [ 0:0 ] pcs8gtxdetectrxloopback,
	output [ 0:0 ] pcs8gtxdeemph,
	output [ 2:0 ] pcs8gtxmargin,
	output [ 0:0 ] pcs8gtxswing,
	output [ 0:0 ] pcs8grxpolarity,
	output [ 0:0 ] pcs8grate,
	output [ 1:0 ] pcs8gpowerdown,
	output [ 2:0 ] pcs8geidleinfersel,
	input [ 19:0 ] pcs8gchnltestbusout,
	input [ 0:0 ] pcs8grxvalid,
	input [ 0:0 ] pcs8grxelecidle,
	input [ 2:0 ] pcs8grxstatus,
	input [ 0:0 ] pcs8gphystatus,
	output [ 1:0 ] pcsgen3rate,
	output [ 2:0 ] pcsgen3eidleinfersel,
	output [ 0:0 ] pcsgen3scanmoden,
	output [ 0:0 ] pcsgen3pldltr,
	output [ 17:0 ] pcsgen3currentcoeff,
	output [ 2:0 ] pcsgen3currentrxpreset,
	input [ 0:0 ] pldhclkin,
	output [ 0:0 ] pcsaggrefclkdig,
	output [ 0:0 ] pcspcspmaifrefclkdig,
	output [ 0:0 ] pcspcspmaifscanmoden,
	output [ 0:0 ] pcspcspmaifscanshiftn,
	input [ 19:0 ] pcsgen3testout,
	input [ 0:0 ] pmaoffcalen,
	output [ 0:0 ] pldoffcaldoneout,
	input [ 0:0 ] pmafref,
	input [ 0:0 ] pmaclklow,
	output [ 0:0 ] pldfref,
	output [ 0:0 ] pldclklow,
	input [ 0:0 ] pldoffcaldone,
	input [ 0:0 ] pcsgen3masktxpll,
	output [ 0:0 ] pldgen3masktxpll,
	output [ 0:0 ] asynchdatain,
	output [ 10:0 ] pldreservedout,
	output [ 26:0 ] emsipcomout,
	input [ 0:0 ] pcsaggtestso,
	output [ 0:0 ] pcsaggtestsi,
	output [ 0:0 ] emsipenablediocsrrdydly,
	input [ 0:0 ] pldltr,
	input [ 0:0 ] pld8grefclkdig2,
	input [ 1:0 ] pcsgen3rxeqctrl,
	output [ 3:0 ] pcs10gextrain,
	output [ 0:0 ] rstsel,
	output [ 8:0 ] pcs10gtestsi,
	input [ 2:0 ] pcs8gpldextraout,
	input [ 11:0 ] pldreservedin,
	input [ 0:0 ] plniotri,
	input [ 8:0 ] pcs10gtestso,
	input [ 0:0 ] nfrzdrv,
	output [ 2:0 ] emsipcomclkout,
	input [ 3:0 ] pcs10gextraout,
	output [ 0:0 ] pcs8grefclkdig2,
	output [ 1:0 ] pldgen3rxeqctrl,
	output [ 0:0 ] pcs8ghardresetn,
	output [ 0:0 ] pcs8ghardreset,
	input [ 0:0 ] pldpartialreconfigin,
	output [ 3:0 ] pcs8gpldextrain,
	input [ 19:0 ] emsipcomspecialin,
	input [ 3:0 ] pcsgen3extraout,
	output [ 5:0 ] pcs8gtestsi,
	input [ 5:0 ] pcs8gtestso,
	output [ 3:0 ] pcsgen3extrain,
	input [ 0:0 ] usermode,
	input [ 17:0 ] pcsgen3rxdeemph,
	output [ 0:0 ] usrrstsel,
	output [ 0:0 ] pldnfrzdrv,
	output [ 17:0 ] pldgen3rxdeemph,
	input [ 0:0 ] iocsrrdydly,
	output [ 0:0 ] pcspmaifhardreset,
	input [ 0:0 ] pcspmaiftestso,
	output [ 0:0 ] pcspmaiftestsi,
	input [ 9:0 ] pcspmaiftestbusout,
	output [ 0:0 ] pldpartialreconfigout,
	input [ 0:0 ] entest,
	output [ 19:0 ] emsipcomspecialout,
	output [ 0:0 ] pcsgen3hardreset,
	input [ 37:0 ] emsipcomin,
	input [ 0:0 ] frzreg,
	input [ 0:0 ] npor,
	output [ 2:0 ] pcsgen3testsi,
	input [ 2:0 ] pcsgen3testso,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_common_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.emsip_enable(emsip_enable),
		.pld_side_reserved_source0(pld_side_reserved_source0),
		.hrdrstctrl_en_cfgusr(hrdrstctrl_en_cfgusr),
		.pld_side_reserved_source10(pld_side_reserved_source10),
		.data_source(data_source),
		.pld_side_reserved_source1(pld_side_reserved_source1),
		.pld_side_reserved_source2(pld_side_reserved_source2),
		.pld_side_reserved_source3(pld_side_reserved_source3),
		.pld_side_reserved_source4(pld_side_reserved_source4),
		.pld_side_reserved_source5(pld_side_reserved_source5),
		.pld_side_reserved_source6(pld_side_reserved_source6),
		.pld_side_reserved_source7(pld_side_reserved_source7),
		.pld_side_reserved_source8(pld_side_reserved_source8),
		.pld_side_reserved_source9(pld_side_reserved_source9),
		.hrdrstctrl_en_cfg(hrdrstctrl_en_cfg),
		.testbus_sel(testbus_sel),
		.usrmode_sel4rst(usrmode_sel4rst),
		.pld_side_reserved_source11(pld_side_reserved_source11),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_common_pld_pcs_interface_encrypted_inst	(
		.pldtestdata(pldtestdata),
		.pldscanmoden(pldscanmoden),
		.pldscanshiftn(pldscanshiftn),
		.pld10grefclkdig(pld10grefclkdig),
		.pld8grefclkdig(pld8grefclkdig),
		.pldaggrefclkdig(pldaggrefclkdig),
		.pldpcspmaifrefclkdig(pldpcspmaifrefclkdig),
		.pldrate(pldrate),
		.pldeidleinfersel(pldeidleinfersel),
		.pld8gprbsciden(pld8gprbsciden),
		.pld8gtxelecidle(pld8gtxelecidle),
		.pld8gtxdetectrxloopback(pld8gtxdetectrxloopback),
		.pld8gtxdeemph(pld8gtxdeemph),
		.pld8gtxmargin(pld8gtxmargin),
		.pld8gtxswing(pld8gtxswing),
		.pld8grxpolarity(pld8grxpolarity),
		.pld8gpowerdown(pld8gpowerdown),
		.pld8grxvalid(pld8grxvalid),
		.pld8grxelecidle(pld8grxelecidle),
		.pld8grxstatus(pld8grxstatus),
		.pld8gphystatus(pld8gphystatus),
		.pldgen3currentcoeff(pldgen3currentcoeff),
		.pldgen3currentrxpreset(pldgen3currentrxpreset),
		.pldoffcaldonein(pldoffcaldonein),
		.pldoffcalen(pldoffcalen),
		.pcs10ghardreset(pcs10ghardreset),
		.pcs10ghardresetn(pcs10ghardresetn),
		.pcs10grefclkdig(pcs10grefclkdig),
		.pcs10gtestdata(pcs10gtestdata),
		.pcs8gscanmoden(pcs8gscanmoden),
		.pcs8grefclkdig(pcs8grefclkdig),
		.pcs8gprbsciden(pcs8gprbsciden),
		.pcs8gltr(pcs8gltr),
		.pcs8gtxelecidle(pcs8gtxelecidle),
		.pcs8gtxdetectrxloopback(pcs8gtxdetectrxloopback),
		.pcs8gtxdeemph(pcs8gtxdeemph),
		.pcs8gtxmargin(pcs8gtxmargin),
		.pcs8gtxswing(pcs8gtxswing),
		.pcs8grxpolarity(pcs8grxpolarity),
		.pcs8grate(pcs8grate),
		.pcs8gpowerdown(pcs8gpowerdown),
		.pcs8geidleinfersel(pcs8geidleinfersel),
		.pcs8gchnltestbusout(pcs8gchnltestbusout),
		.pcs8grxvalid(pcs8grxvalid),
		.pcs8grxelecidle(pcs8grxelecidle),
		.pcs8grxstatus(pcs8grxstatus),
		.pcs8gphystatus(pcs8gphystatus),
		.pcsgen3rate(pcsgen3rate),
		.pcsgen3eidleinfersel(pcsgen3eidleinfersel),
		.pcsgen3scanmoden(pcsgen3scanmoden),
		.pcsgen3pldltr(pcsgen3pldltr),
		.pcsgen3currentcoeff(pcsgen3currentcoeff),
		.pcsgen3currentrxpreset(pcsgen3currentrxpreset),
		.pldhclkin(pldhclkin),
		.pcsaggrefclkdig(pcsaggrefclkdig),
		.pcspcspmaifrefclkdig(pcspcspmaifrefclkdig),
		.pcspcspmaifscanmoden(pcspcspmaifscanmoden),
		.pcspcspmaifscanshiftn(pcspcspmaifscanshiftn),
		.pcsgen3testout(pcsgen3testout),
		.pmaoffcalen(pmaoffcalen),
		.pldoffcaldoneout(pldoffcaldoneout),
		.pmafref(pmafref),
		.pmaclklow(pmaclklow),
		.pldfref(pldfref),
		.pldclklow(pldclklow),
		.pldoffcaldone(pldoffcaldone),
		.pcsgen3masktxpll(pcsgen3masktxpll),
		.pldgen3masktxpll(pldgen3masktxpll),
		.asynchdatain(asynchdatain),
		.pldreservedout(pldreservedout),
		.emsipcomout(emsipcomout),
		.pcsaggtestso(pcsaggtestso),
		.pcsaggtestsi(pcsaggtestsi),
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.pldltr(pldltr),
		.pld8grefclkdig2(pld8grefclkdig2),
		.pcsgen3rxeqctrl(pcsgen3rxeqctrl),
		.pcs10gextrain(pcs10gextrain),
		.rstsel(rstsel),
		.pcs10gtestsi(pcs10gtestsi),
		.pcs8gpldextraout(pcs8gpldextraout),
		.pldreservedin(pldreservedin),
		.plniotri(plniotri),
		.pcs10gtestso(pcs10gtestso),
		.nfrzdrv(nfrzdrv),
		.emsipcomclkout(emsipcomclkout),
		.pcs10gextraout(pcs10gextraout),
		.pcs8grefclkdig2(pcs8grefclkdig2),
		.pldgen3rxeqctrl(pldgen3rxeqctrl),
		.pcs8ghardresetn(pcs8ghardresetn),
		.pcs8ghardreset(pcs8ghardreset),
		.pldpartialreconfigin(pldpartialreconfigin),
		.pcs8gpldextrain(pcs8gpldextrain),
		.emsipcomspecialin(emsipcomspecialin),
		.pcsgen3extraout(pcsgen3extraout),
		.pcs8gtestsi(pcs8gtestsi),
		.pcs8gtestso(pcs8gtestso),
		.pcsgen3extrain(pcsgen3extrain),
		.usermode(usermode),
		.pcsgen3rxdeemph(pcsgen3rxdeemph),
		.usrrstsel(usrrstsel),
		.pldnfrzdrv(pldnfrzdrv),
		.pldgen3rxdeemph(pldgen3rxdeemph),
		.iocsrrdydly(iocsrrdydly),
		.pcspmaifhardreset(pcspmaifhardreset),
		.pcspmaiftestso(pcspmaiftestso),
		.pcspmaiftestsi(pcspmaiftestsi),
		.pcspmaiftestbusout(pcspmaiftestbusout),
		.pldpartialreconfigout(pldpartialreconfigout),
		.entest(entest),
		.emsipcomspecialout(emsipcomspecialout),
		.pcsgen3hardreset(pcsgen3hardreset),
		.emsipcomin(emsipcomin),
		.frzreg(frzreg),
		.npor(npor),
		.pcsgen3testsi(pcsgen3testsi),
		.pcsgen3testso(pcsgen3testso),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_rx_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_rx_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|ten_g_pcs|pcie_gen3|default
	parameter clkslip_sel = "pld",	//Valid values: pld|slip_eight_g_pcs
	parameter prot_mode = "other_protocols",	//Valid values: other_protocols|cpri_8g
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] clockinfrompma,
	input [ 79:0 ] datainfrompma,
	input [ 0:0 ] pmasigdet,
	output [ 0:0 ] pmarxclkslip,
	input [ 0:0 ] pmasignalok,
	output [ 0:0 ] pmarxclkout,
	output [ 0:0 ] clkoutto10gpcs,
	output [ 79:0 ] dataoutto10gpcs,
	output [ 0:0 ] pcs10gsignalok,
	input [ 0:0 ] pcs10grxclkiqout,
	output [ 0:0 ] clockouttogen3pcs,
	output [ 31:0 ] dataouttogen3pcs,
	output [ 0:0 ] pcsgen3pmasignaldet,
	input [ 0:0 ] pcs8grxclkiqout,
	input [ 0:0 ] pcs8grxclkslip,
	output [ 0:0 ] clockoutto8gpcs,
	output [ 19:0 ] dataoutto8gpcs,
	output [ 0:0 ] pcs8gsigdetni,
	input [ 0:0 ] pmaclkdiv33txorrxin,
	output [ 0:0 ] pmaclkdiv33txorrxout,
	output [ 0:0 ] pcs10gclkdiv33txorrx,
	output [ 0:0 ] pmarxpmarstb,
	input [ 0:0 ] pldrxpmarstb,
	input [ 0:0 ] pldrxclkslip,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	output [ 1:0 ] pcsgen3eyemonitorin,
	input [ 1:0 ] pmaeyemonitorin,
	output [ 0:0 ] pmarxpllphaselockout,
	input [ 7:0 ] pcsgen3eyemonitorout,
	input [ 0:0 ] pmarxpllphaselockin,
	output [ 4:0 ] pmareservedout,
	output [ 7:0 ] pmaeyemonitorout,
	input [ 0:0 ] pcsemsiprxclkiqout,
	input [ 4:0 ] pmareservedin,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_rx_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.selectpcs(selectpcs),
		.clkslip_sel(clkslip_sel),
		.prot_mode(prot_mode),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_rx_pcs_pma_interface_encrypted_inst	(
		.clockinfrompma(clockinfrompma),
		.datainfrompma(datainfrompma),
		.pmasigdet(pmasigdet),
		.pmarxclkslip(pmarxclkslip),
		.pmasignalok(pmasignalok),
		.pmarxclkout(pmarxclkout),
		.clkoutto10gpcs(clkoutto10gpcs),
		.dataoutto10gpcs(dataoutto10gpcs),
		.pcs10gsignalok(pcs10gsignalok),
		.pcs10grxclkiqout(pcs10grxclkiqout),
		.clockouttogen3pcs(clockouttogen3pcs),
		.dataouttogen3pcs(dataouttogen3pcs),
		.pcsgen3pmasignaldet(pcsgen3pmasignaldet),
		.pcs8grxclkiqout(pcs8grxclkiqout),
		.pcs8grxclkslip(pcs8grxclkslip),
		.clockoutto8gpcs(clockoutto8gpcs),
		.dataoutto8gpcs(dataoutto8gpcs),
		.pcs8gsigdetni(pcs8gsigdetni),
		.pmaclkdiv33txorrxin(pmaclkdiv33txorrxin),
		.pmaclkdiv33txorrxout(pmaclkdiv33txorrxout),
		.pcs10gclkdiv33txorrx(pcs10gclkdiv33txorrx),
		.pmarxpmarstb(pmarxpmarstb),
		.pldrxpmarstb(pldrxpmarstb),
		.pldrxclkslip(pldrxclkslip),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.pcsgen3eyemonitorin(pcsgen3eyemonitorin),
		.pmaeyemonitorin(pmaeyemonitorin),
		.pmarxpllphaselockout(pmarxpllphaselockout),
		.pcsgen3eyemonitorout(pcsgen3eyemonitorout),
		.pmarxpllphaselockin(pmarxpllphaselockin),
		.pmareservedout(pmareservedout),
		.pmaeyemonitorout(pmaeyemonitorout),
		.pcsemsiprxclkiqout(pcsemsiprxclkiqout),
		.pmareservedin(pmareservedin),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_rx_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_rx_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter is_10g_0ppm = "false",	//Valid values: false|true
	parameter is_8g_0ppm = "false",	//Valid values: false|true
	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|ten_g_pcs|default
	parameter data_source = "pld",	//Valid values: emsip|pld
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	output [ 63:0 ] dataouttopld,
	input [ 0:0 ] pld10grxpldclk,
	input [ 0:0 ] pld10grxalignen,
	input [ 0:0 ] pld10grxalignclr,
	input [ 0:0 ] pld10grxrden,
	input [ 0:0 ] pld10grxdispclr,
	input [ 0:0 ] pld10grxclrerrblkcnt,
	input [ 0:0 ] pld10grxclrbercount,
	input [ 0:0 ] pld10grxprbserrclr,
	input [ 0:0 ] pld10grxbitslip,
	output [ 0:0 ] pld10grxclkout,
	output [ 0:0 ] pld10grxdatavalid,
	output [ 9:0 ] pld10grxcontrol,
	output [ 0:0 ] pld10grxempty,
	output [ 0:0 ] pld10grxpempty,
	output [ 0:0 ] pld10grxpfull,
	output [ 0:0 ] pld10grxoflwerr,
	output [ 0:0 ] pld10grxalignval,
	output [ 0:0 ] pld10grxblklock,
	output [ 0:0 ] pld10grxhiber,
	output [ 0:0 ] pld10grxframelock,
	output [ 0:0 ] pld10grxrdpossts,
	output [ 0:0 ] pld10grxrdnegsts,
	output [ 0:0 ] pld10grxskipins,
	output [ 0:0 ] pld10grxrxframe,
	output [ 0:0 ] pld10grxpyldins,
	output [ 0:0 ] pld10grxsyncerr,
	output [ 0:0 ] pld10grxscrmerr,
	output [ 0:0 ] pld10grxskiperr,
	output [ 0:0 ] pld10grxdiagerr,
	output [ 0:0 ] pld10grxsherr,
	output [ 0:0 ] pld10grxmfrmerr,
	output [ 0:0 ] pld10grxcrc32err,
	output [ 1:0 ] pld10grxdiagstatus,
	input [ 0:0 ] pld8gencdt,
	input [ 0:0 ] pld8ga1a2size,
	input [ 0:0 ] pld8gbitslip,
	input [ 0:0 ] pld8grdenablermf,
	input [ 0:0 ] pld8gwrenablermf,
	input [ 0:0 ] pld8gpldrxclk,
	input [ 0:0 ] pld8gpolinvrx,
	input [ 0:0 ] pld8gbitlocreven,
	input [ 0:0 ] pld8gbytereven,
	input [ 0:0 ] pld8gbytordpld,
	input [ 0:0 ] pld8gwrdisablerx,
	input [ 0:0 ] pld8grdenablerx,
	output [ 0:0 ] pld8grxclkout,
	output [ 0:0 ] pld8gbisterr,
	output [ 0:0 ] pld8gsignaldetectout,
	output [ 0:0 ] pld8gbistdone,
	output [ 0:0 ] pld8grlvlt,
	output [ 0:0 ] pld8gfullrmf,
	output [ 0:0 ] pld8gemptyrmf,
	output [ 0:0 ] pld8gfullrx,
	output [ 0:0 ] pld8gemptyrx,
	output [ 3:0 ] pld8ga1a2k1k2flag,
	output [ 0:0 ] pld8gbyteordflag,
	output [ 4:0 ] pld8gwaboundary,
	output [ 3:0 ] pld8grxdatavalid,
	output [ 1:0 ] pld8grxsynchdr,
	output [ 3:0 ] pld8grxblkstart,
	input [ 0:0 ] pldgen3rxrstn,
	input [ 0:0 ] pldgen3rxupdatefc,
	input [ 0:0 ] pldrxclkslipin,
	output [ 0:0 ] pcs10grxpldclk,
	output [ 0:0 ] pcs10grxalignen,
	output [ 0:0 ] pcs10grxalignclr,
	output [ 0:0 ] pcs10grxrden,
	output [ 0:0 ] pcs10grxdispclr,
	output [ 0:0 ] pcs10grxclrerrblkcnt,
	output [ 0:0 ] pcs10grxclrbercount,
	output [ 0:0 ] pcs10grxprbserrclr,
	output [ 0:0 ] pcs10grxbitslip,
	input [ 0:0 ] clockinfrom10gpcs,
	input [ 0:0 ] pcs10grxdatavalid,
	input [ 63:0 ] datainfrom10gpcs,
	input [ 9:0 ] pcs10grxcontrol,
	input [ 0:0 ] pcs10grxempty,
	input [ 0:0 ] pcs10grxpempty,
	input [ 0:0 ] pcs10grxpfull,
	input [ 0:0 ] pcs10grxoflwerr,
	input [ 0:0 ] pcs10grxalignval,
	input [ 0:0 ] pcs10grxblklock,
	input [ 0:0 ] pcs10grxhiber,
	input [ 0:0 ] pcs10grxframelock,
	input [ 0:0 ] pcs10grxrdpossts,
	input [ 0:0 ] pcs10grxrdnegsts,
	input [ 0:0 ] pcs10grxskipins,
	input [ 0:0 ] pcs10grxrxframe,
	input [ 0:0 ] pcs10grxpyldins,
	input [ 0:0 ] pcs10grxsyncerr,
	input [ 0:0 ] pcs10grxscrmerr,
	input [ 0:0 ] pcs10grxskiperr,
	input [ 0:0 ] pcs10grxdiagerr,
	input [ 0:0 ] pcs10grxsherr,
	input [ 0:0 ] pcs10grxmfrmerr,
	input [ 0:0 ] pcs10grxcrc32err,
	input [ 1:0 ] pcs10grxdiagstatus,
	output [ 0:0 ] pcs8gencdt,
	output [ 0:0 ] pcs8ga1a2size,
	output [ 0:0 ] pcs8gbitslip,
	output [ 0:0 ] pcs8grdenablermf,
	output [ 0:0 ] pcs8gwrenablermf,
	output [ 0:0 ] pcs8gpldrxclk,
	output [ 0:0 ] pcs8gpolinvrx,
	output [ 0:0 ] pcs8gbitlocreven,
	output [ 0:0 ] pcs8gbytereven,
	output [ 0:0 ] pcs8gbytordpld,
	output [ 0:0 ] pcs8gwrdisablerx,
	output [ 0:0 ] pcs8grdenablerx,
	input [ 63:0 ] datainfrom8gpcs,
	input [ 0:0 ] pcs8gbisterr,
	input [ 0:0 ] pcs8gsignaldetectout,
	input [ 0:0 ] pcs8gbistdone,
	input [ 0:0 ] pcs8grlvlt,
	input [ 0:0 ] pcs8gfullrmf,
	input [ 0:0 ] pcs8gemptyrmf,
	input [ 0:0 ] pcs8gfullrx,
	input [ 0:0 ] pcs8gemptyrx,
	input [ 3:0 ] pcs8ga1a2k1k2flag,
	input [ 0:0 ] pcs8gbyteordflag,
	input [ 4:0 ] pcs8gwaboundary,
	input [ 0:0 ] pcs8grxvalid,
	input [ 0:0 ] pcs8grxelecidle,
	input [ 2:0 ] pcs8grxstatus,
	input [ 0:0 ] pcs8gphystatus,
	input [ 3:0 ] pcs8grxdatavalid,
	input [ 1:0 ] pcs8grxsynchdr,
	input [ 3:0 ] pcs8grxblkstart,
	output [ 0:0 ] pcsgen3rxrstn,
	output [ 0:0 ] pcsgen3rxrst,
	output [ 0:0 ] pcsgen3rxupdatefc,
	output [ 0:0 ] pldrxclkslipout,
	input [ 0:0 ] pmaclkdiv33txorrx,
	output [ 0:0 ] pldclkdiv33txorrx,
	output [ 0:0 ] pldrxpmarstbout,
	input [ 0:0 ] pldrxpmarstbin,
	input [ 0:0 ] pcs10grxfifoinsert,
	input [ 0:0 ] pcs10grxfifodel,
	output [ 0:0 ] pld10grxfifodel,
	output [ 0:0 ] pldrxiqclkout,
	output [ 0:0 ] pld10grxfifoinsert,
	output [ 0:0 ] pcs8gsyncsmenoutput,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	output [ 2:0 ] emsiprxclkout,
	output [ 0:0 ] pcs8gphfifourstrx,
	input [ 0:0 ] pld10grxpldrstn,
	input [ 0:0 ] emsipenablediocsrrdydly,
	output [ 0:0 ] pld10grxprbserr,
	output [ 0:0 ] pcs8grxurstpcs,
	input [ 0:0 ] rstsel,
	input [ 12:0 ] emsiprxspecialin,
	output [ 128:0 ] emsiprxout,
	output [ 0:0 ] pld8galignstatus,
	output [ 0:0 ] pcsgen3syncsmen,
	output [ 15:0 ] emsiprxspecialout,
	input [ 0:0 ] clockinfrom8gpcs,
	input [ 0:0 ] pmarxplllock,
	input [ 0:0 ] pld8gphfifourstrxn,
	output [ 0:0 ] pcs10grxpldrstn,
	output [ 0:0 ] pcs8gcmpfifourst,
	input [ 0:0 ] pld8gcmpfifourstn,
	input [ 0:0 ] usrrstsel,
	input [ 2:0 ] emsiprxclkin,
	input [ 0:0 ] pld8grxurstpcsn,
	input [ 19:0 ] emsiprxin,
	input [ 0:0 ] pcs8galignstatus,
	input [ 0:0 ] pcs10grxprbserr,
	input [ 0:0 ] pld8gsyncsmeninput,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_rx_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.is_10g_0ppm(is_10g_0ppm),
		.is_8g_0ppm(is_8g_0ppm),
		.selectpcs(selectpcs),
		.data_source(data_source),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_rx_pld_pcs_interface_encrypted_inst	(
		.dataouttopld(dataouttopld),
		.pld10grxpldclk(pld10grxpldclk),
		.pld10grxalignen(pld10grxalignen),
		.pld10grxalignclr(pld10grxalignclr),
		.pld10grxrden(pld10grxrden),
		.pld10grxdispclr(pld10grxdispclr),
		.pld10grxclrerrblkcnt(pld10grxclrerrblkcnt),
		.pld10grxclrbercount(pld10grxclrbercount),
		.pld10grxprbserrclr(pld10grxprbserrclr),
		.pld10grxbitslip(pld10grxbitslip),
		.pld10grxclkout(pld10grxclkout),
		.pld10grxdatavalid(pld10grxdatavalid),
		.pld10grxcontrol(pld10grxcontrol),
		.pld10grxempty(pld10grxempty),
		.pld10grxpempty(pld10grxpempty),
		.pld10grxpfull(pld10grxpfull),
		.pld10grxoflwerr(pld10grxoflwerr),
		.pld10grxalignval(pld10grxalignval),
		.pld10grxblklock(pld10grxblklock),
		.pld10grxhiber(pld10grxhiber),
		.pld10grxframelock(pld10grxframelock),
		.pld10grxrdpossts(pld10grxrdpossts),
		.pld10grxrdnegsts(pld10grxrdnegsts),
		.pld10grxskipins(pld10grxskipins),
		.pld10grxrxframe(pld10grxrxframe),
		.pld10grxpyldins(pld10grxpyldins),
		.pld10grxsyncerr(pld10grxsyncerr),
		.pld10grxscrmerr(pld10grxscrmerr),
		.pld10grxskiperr(pld10grxskiperr),
		.pld10grxdiagerr(pld10grxdiagerr),
		.pld10grxsherr(pld10grxsherr),
		.pld10grxmfrmerr(pld10grxmfrmerr),
		.pld10grxcrc32err(pld10grxcrc32err),
		.pld10grxdiagstatus(pld10grxdiagstatus),
		.pld8gencdt(pld8gencdt),
		.pld8ga1a2size(pld8ga1a2size),
		.pld8gbitslip(pld8gbitslip),
		.pld8grdenablermf(pld8grdenablermf),
		.pld8gwrenablermf(pld8gwrenablermf),
		.pld8gpldrxclk(pld8gpldrxclk),
		.pld8gpolinvrx(pld8gpolinvrx),
		.pld8gbitlocreven(pld8gbitlocreven),
		.pld8gbytereven(pld8gbytereven),
		.pld8gbytordpld(pld8gbytordpld),
		.pld8gwrdisablerx(pld8gwrdisablerx),
		.pld8grdenablerx(pld8grdenablerx),
		.pld8grxclkout(pld8grxclkout),
		.pld8gbisterr(pld8gbisterr),
		.pld8gsignaldetectout(pld8gsignaldetectout),
		.pld8gbistdone(pld8gbistdone),
		.pld8grlvlt(pld8grlvlt),
		.pld8gfullrmf(pld8gfullrmf),
		.pld8gemptyrmf(pld8gemptyrmf),
		.pld8gfullrx(pld8gfullrx),
		.pld8gemptyrx(pld8gemptyrx),
		.pld8ga1a2k1k2flag(pld8ga1a2k1k2flag),
		.pld8gbyteordflag(pld8gbyteordflag),
		.pld8gwaboundary(pld8gwaboundary),
		.pld8grxdatavalid(pld8grxdatavalid),
		.pld8grxsynchdr(pld8grxsynchdr),
		.pld8grxblkstart(pld8grxblkstart),
		.pldgen3rxrstn(pldgen3rxrstn),
		.pldgen3rxupdatefc(pldgen3rxupdatefc),
		.pldrxclkslipin(pldrxclkslipin),
		.pcs10grxpldclk(pcs10grxpldclk),
		.pcs10grxalignen(pcs10grxalignen),
		.pcs10grxalignclr(pcs10grxalignclr),
		.pcs10grxrden(pcs10grxrden),
		.pcs10grxdispclr(pcs10grxdispclr),
		.pcs10grxclrerrblkcnt(pcs10grxclrerrblkcnt),
		.pcs10grxclrbercount(pcs10grxclrbercount),
		.pcs10grxprbserrclr(pcs10grxprbserrclr),
		.pcs10grxbitslip(pcs10grxbitslip),
		.clockinfrom10gpcs(clockinfrom10gpcs),
		.pcs10grxdatavalid(pcs10grxdatavalid),
		.datainfrom10gpcs(datainfrom10gpcs),
		.pcs10grxcontrol(pcs10grxcontrol),
		.pcs10grxempty(pcs10grxempty),
		.pcs10grxpempty(pcs10grxpempty),
		.pcs10grxpfull(pcs10grxpfull),
		.pcs10grxoflwerr(pcs10grxoflwerr),
		.pcs10grxalignval(pcs10grxalignval),
		.pcs10grxblklock(pcs10grxblklock),
		.pcs10grxhiber(pcs10grxhiber),
		.pcs10grxframelock(pcs10grxframelock),
		.pcs10grxrdpossts(pcs10grxrdpossts),
		.pcs10grxrdnegsts(pcs10grxrdnegsts),
		.pcs10grxskipins(pcs10grxskipins),
		.pcs10grxrxframe(pcs10grxrxframe),
		.pcs10grxpyldins(pcs10grxpyldins),
		.pcs10grxsyncerr(pcs10grxsyncerr),
		.pcs10grxscrmerr(pcs10grxscrmerr),
		.pcs10grxskiperr(pcs10grxskiperr),
		.pcs10grxdiagerr(pcs10grxdiagerr),
		.pcs10grxsherr(pcs10grxsherr),
		.pcs10grxmfrmerr(pcs10grxmfrmerr),
		.pcs10grxcrc32err(pcs10grxcrc32err),
		.pcs10grxdiagstatus(pcs10grxdiagstatus),
		.pcs8gencdt(pcs8gencdt),
		.pcs8ga1a2size(pcs8ga1a2size),
		.pcs8gbitslip(pcs8gbitslip),
		.pcs8grdenablermf(pcs8grdenablermf),
		.pcs8gwrenablermf(pcs8gwrenablermf),
		.pcs8gpldrxclk(pcs8gpldrxclk),
		.pcs8gpolinvrx(pcs8gpolinvrx),
		.pcs8gbitlocreven(pcs8gbitlocreven),
		.pcs8gbytereven(pcs8gbytereven),
		.pcs8gbytordpld(pcs8gbytordpld),
		.pcs8gwrdisablerx(pcs8gwrdisablerx),
		.pcs8grdenablerx(pcs8grdenablerx),
		.datainfrom8gpcs(datainfrom8gpcs),
		.pcs8gbisterr(pcs8gbisterr),
		.pcs8gsignaldetectout(pcs8gsignaldetectout),
		.pcs8gbistdone(pcs8gbistdone),
		.pcs8grlvlt(pcs8grlvlt),
		.pcs8gfullrmf(pcs8gfullrmf),
		.pcs8gemptyrmf(pcs8gemptyrmf),
		.pcs8gfullrx(pcs8gfullrx),
		.pcs8gemptyrx(pcs8gemptyrx),
		.pcs8ga1a2k1k2flag(pcs8ga1a2k1k2flag),
		.pcs8gbyteordflag(pcs8gbyteordflag),
		.pcs8gwaboundary(pcs8gwaboundary),
		.pcs8grxvalid(pcs8grxvalid),
		.pcs8grxelecidle(pcs8grxelecidle),
		.pcs8grxstatus(pcs8grxstatus),
		.pcs8gphystatus(pcs8gphystatus),
		.pcs8grxdatavalid(pcs8grxdatavalid),
		.pcs8grxsynchdr(pcs8grxsynchdr),
		.pcs8grxblkstart(pcs8grxblkstart),
		.pcsgen3rxrstn(pcsgen3rxrstn),
		.pcsgen3rxrst(pcsgen3rxrst),
		.pcsgen3rxupdatefc(pcsgen3rxupdatefc),
		.pldrxclkslipout(pldrxclkslipout),
		.pmaclkdiv33txorrx(pmaclkdiv33txorrx),
		.pldclkdiv33txorrx(pldclkdiv33txorrx),
		.pldrxpmarstbout(pldrxpmarstbout),
		.pldrxpmarstbin(pldrxpmarstbin),
		.pcs10grxfifoinsert(pcs10grxfifoinsert),
		.pcs10grxfifodel(pcs10grxfifodel),
		.pld10grxfifodel(pld10grxfifodel),
		.pldrxiqclkout(pldrxiqclkout),
		.pld10grxfifoinsert(pld10grxfifoinsert),
		.pcs8gsyncsmenoutput(pcs8gsyncsmenoutput),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.emsiprxclkout(emsiprxclkout),
		.pcs8gphfifourstrx(pcs8gphfifourstrx),
		.pld10grxpldrstn(pld10grxpldrstn),
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.pld10grxprbserr(pld10grxprbserr),
		.pcs8grxurstpcs(pcs8grxurstpcs),
		.rstsel(rstsel),
		.emsiprxspecialin(emsiprxspecialin),
		.emsiprxout(emsiprxout),
		.pld8galignstatus(pld8galignstatus),
		.pcsgen3syncsmen(pcsgen3syncsmen),
		.emsiprxspecialout(emsiprxspecialout),
		.clockinfrom8gpcs(clockinfrom8gpcs),
		.pmarxplllock(pmarxplllock),
		.pld8gphfifourstrxn(pld8gphfifourstrxn),
		.pcs10grxpldrstn(pcs10grxpldrstn),
		.pcs8gcmpfifourst(pcs8gcmpfifourst),
		.pld8gcmpfifourstn(pld8gcmpfifourstn),
		.usrrstsel(usrrstsel),
		.emsiprxclkin(emsiprxclkin),
		.pld8grxurstpcsn(pld8grxurstpcsn),
		.emsiprxin(emsiprxin),
		.pcs8galignstatus(pcs8galignstatus),
		.pcs10grxprbserr(pcs10grxprbserr),
		.pld8gsyncsmeninput(pld8gsyncsmeninput),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_tx_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_tx_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|ten_g_pcs|pcie_gen3|default
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] clockinfrompma,
	output [ 79:0 ] dataouttopma,
	output [ 0:0 ] pmatxclkout,
	output [ 0:0 ] clockoutto10gpcs,
	input [ 79:0 ] datainfrom10gpcs,
	input [ 0:0 ] pcs10gtxclkiqout,
	input [ 31:0 ] datainfromgen3pcs,
	input [ 0:0 ] pcs8gtxclkiqout,
	output [ 0:0 ] clockoutto8gpcs,
	input [ 19:0 ] datainfrom8gpcs,
	input [ 0:0 ] pmaclkdiv33lcin,
	output [ 0:0 ] pmaclkdiv33lcout,
	output [ 0:0 ] pcs10gclkdiv33lc,
	input [ 0:0 ] pmatxlcplllockin,
	output [ 0:0 ] pmatxlcplllockout,
	input [ 0:0 ] pcsgen3gen3datasel,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	output [ 0:0 ] pmatxpmasyncpfbkp,
	input [ 0:0 ] pmarxfreqtxcmuplllockin,
	output [ 0:0 ] pmarxfreqtxcmuplllockout,
	input [ 0:0 ] pldtxpmasyncpfbkp,
	input [ 0:0 ] pcsemsiptxclkiqout,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_tx_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.selectpcs(selectpcs),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_tx_pcs_pma_interface_encrypted_inst	(
		.clockinfrompma(clockinfrompma),
		.dataouttopma(dataouttopma),
		.pmatxclkout(pmatxclkout),
		.clockoutto10gpcs(clockoutto10gpcs),
		.datainfrom10gpcs(datainfrom10gpcs),
		.pcs10gtxclkiqout(pcs10gtxclkiqout),
		.datainfromgen3pcs(datainfromgen3pcs),
		.pcs8gtxclkiqout(pcs8gtxclkiqout),
		.clockoutto8gpcs(clockoutto8gpcs),
		.datainfrom8gpcs(datainfrom8gpcs),
		.pmaclkdiv33lcin(pmaclkdiv33lcin),
		.pmaclkdiv33lcout(pmaclkdiv33lcout),
		.pcs10gclkdiv33lc(pcs10gclkdiv33lc),
		.pmatxlcplllockin(pmatxlcplllockin),
		.pmatxlcplllockout(pmatxlcplllockout),
		.pcsgen3gen3datasel(pcsgen3gen3datasel),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.pmatxpmasyncpfbkp(pmatxpmasyncpfbkp),
		.pmarxfreqtxcmuplllockin(pmarxfreqtxcmuplllockin),
		.pmarxfreqtxcmuplllockout(pmarxfreqtxcmuplllockout),
		.pldtxpmasyncpfbkp(pldtxpmasyncpfbkp),
		.pcsemsiptxclkiqout(pcsemsiptxclkiqout),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_tx_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_tx_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter is_10g_0ppm = "false",	//Valid values: false|true
	parameter is_8g_0ppm = "false",	//Valid values: false|true
	parameter data_source = "pld",	//Valid values: emsip|pld
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 63:0 ] datainfrompld,
	input [ 0:0 ] pld10gtxpldclk,
	input [ 0:0 ] pld10gtxdatavalid,
	input [ 8:0 ] pld10gtxcontrol,
	input [ 6:0 ] pld10gtxbitslip,
	input [ 1:0 ] pld10gtxdiagstatus,
	input [ 0:0 ] pld10gtxwordslip,
	input [ 0:0 ] pld10gtxbursten,
	output [ 0:0 ] pld10gtxclkout,
	output [ 0:0 ] pld10gtxempty,
	output [ 0:0 ] pld10gtxpempty,
	output [ 0:0 ] pld10gtxpfull,
	output [ 0:0 ] pld10gtxfull,
	output [ 0:0 ] pld10gtxframe,
	output [ 0:0 ] pld10gtxburstenexe,
	output [ 0:0 ] pld10gtxwordslipexe,
	input [ 0:0 ] pld8gpldtxclk,
	input [ 0:0 ] pld8gpolinvtx,
	input [ 0:0 ] pld8grevloopbk,
	input [ 0:0 ] pld8gwrenabletx,
	input [ 0:0 ] pld8grddisabletx,
	input [ 4:0 ] pld8gtxboundarysel,
	input [ 3:0 ] pld8gtxdatavalid,
	input [ 1:0 ] pld8gtxsynchdr,
	input [ 3:0 ] pld8gtxblkstart,
	output [ 0:0 ] pld8gfulltx,
	output [ 0:0 ] pld8gemptytx,
	output [ 0:0 ] pld8gtxclkout,
	input [ 0:0 ] pldgen3txrstn,
	output [ 0:0 ] pcs10gtxpldclk,
	output [ 0:0 ] pcs10gtxdatavalid,
	output [ 63:0 ] dataoutto10gpcs,
	output [ 8:0 ] pcs10gtxcontrol,
	output [ 6:0 ] pcs10gtxbitslip,
	output [ 1:0 ] pcs10gtxdiagstatus,
	output [ 0:0 ] pcs10gtxwordslip,
	output [ 0:0 ] pcs10gtxbursten,
	input [ 0:0 ] clockinfrom10gpcs,
	input [ 0:0 ] pcs10gtxempty,
	input [ 0:0 ] pcs10gtxpempty,
	input [ 0:0 ] pcs10gtxpfull,
	input [ 0:0 ] pcs10gtxfull,
	input [ 0:0 ] pcs10gtxframe,
	input [ 0:0 ] pcs10gtxburstenexe,
	input [ 0:0 ] pcs10gtxwordslipexe,
	output [ 43:0 ] dataoutto8gpcs,
	output [ 0:0 ] pcs8gpldtxclk,
	output [ 0:0 ] pcs8gpolinvtx,
	output [ 0:0 ] pcs8grevloopbk,
	output [ 0:0 ] pcs8gwrenabletx,
	output [ 0:0 ] pcs8grddisabletx,
	output [ 4:0 ] pcs8gtxboundarysel,
	output [ 3:0 ] pcs8gtxdatavalid,
	output [ 1:0 ] pcs8gtxsynchdr,
	output [ 3:0 ] pcs8gtxblkstart,
	input [ 0:0 ] pcs8gfulltx,
	input [ 0:0 ] pcs8gemptytx,
	input [ 0:0 ] clockinfrom8gpcs,
	output [ 0:0 ] pcsgen3txrstn,
	output [ 0:0 ] pcsgen3txrst,
	input [ 0:0 ] pmaclkdiv33lc,
	output [ 0:0 ] pldclkdiv33lc,
	input [ 0:0 ] pmatxlcplllock,
	output [ 0:0 ] pldlccmurstbout,
	output [ 0:0 ] pldtxiqclkout,
	input [ 0:0 ] pcs10gtxfifoinsert,
	output [ 0:0 ] pld10gtxfifodel,
	output [ 0:0 ] pld10gtxfifoinsert,
	input [ 0:0 ] pcs10gtxfifodel,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	output [ 0:0 ] pcs8gphfifoursttx,
	output [ 0:0 ] pcs10gtxpldrstn,
	input [ 0:0 ] emsipenablediocsrrdydly,
	input [ 103:0 ] emsiptxin,
	output [ 0:0 ] pldtxpmasyncpfbkpout,
	input [ 2:0 ] emsippcstxclkin,
	input [ 0:0 ] rstsel,
	input [ 12:0 ] emsiptxspecialin,
	output [ 2:0 ] emsippcstxclkout,
	output [ 15:0 ] emsiptxspecialout,
	input [ 0:0 ] pld10gtxpldrstn,
	output [ 11:0 ] emsiptxout,
	input [ 0:0 ] pmatxcmuplllock,
	input [ 0:0 ] pld8gphfifoursttxn,
	input [ 0:0 ] usrrstsel,
	output [ 0:0 ] pcs8gtxurstpcs,
	input [ 0:0 ] pld8gtxurstpcsn,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect
); 

	stratixv_hssi_tx_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.is_10g_0ppm(is_10g_0ppm),
		.is_8g_0ppm(is_8g_0ppm),
		.data_source(data_source),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_tx_pld_pcs_interface_encrypted_inst	(
		.datainfrompld(datainfrompld),
		.pld10gtxpldclk(pld10gtxpldclk),
		.pld10gtxdatavalid(pld10gtxdatavalid),
		.pld10gtxcontrol(pld10gtxcontrol),
		.pld10gtxbitslip(pld10gtxbitslip),
		.pld10gtxdiagstatus(pld10gtxdiagstatus),
		.pld10gtxwordslip(pld10gtxwordslip),
		.pld10gtxbursten(pld10gtxbursten),
		.pld10gtxclkout(pld10gtxclkout),
		.pld10gtxempty(pld10gtxempty),
		.pld10gtxpempty(pld10gtxpempty),
		.pld10gtxpfull(pld10gtxpfull),
		.pld10gtxfull(pld10gtxfull),
		.pld10gtxframe(pld10gtxframe),
		.pld10gtxburstenexe(pld10gtxburstenexe),
		.pld10gtxwordslipexe(pld10gtxwordslipexe),
		.pld8gpldtxclk(pld8gpldtxclk),
		.pld8gpolinvtx(pld8gpolinvtx),
		.pld8grevloopbk(pld8grevloopbk),
		.pld8gwrenabletx(pld8gwrenabletx),
		.pld8grddisabletx(pld8grddisabletx),
		.pld8gtxboundarysel(pld8gtxboundarysel),
		.pld8gtxdatavalid(pld8gtxdatavalid),
		.pld8gtxsynchdr(pld8gtxsynchdr),
		.pld8gtxblkstart(pld8gtxblkstart),
		.pld8gfulltx(pld8gfulltx),
		.pld8gemptytx(pld8gemptytx),
		.pld8gtxclkout(pld8gtxclkout),
		.pldgen3txrstn(pldgen3txrstn),
		.pcs10gtxpldclk(pcs10gtxpldclk),
		.pcs10gtxdatavalid(pcs10gtxdatavalid),
		.dataoutto10gpcs(dataoutto10gpcs),
		.pcs10gtxcontrol(pcs10gtxcontrol),
		.pcs10gtxbitslip(pcs10gtxbitslip),
		.pcs10gtxdiagstatus(pcs10gtxdiagstatus),
		.pcs10gtxwordslip(pcs10gtxwordslip),
		.pcs10gtxbursten(pcs10gtxbursten),
		.clockinfrom10gpcs(clockinfrom10gpcs),
		.pcs10gtxempty(pcs10gtxempty),
		.pcs10gtxpempty(pcs10gtxpempty),
		.pcs10gtxpfull(pcs10gtxpfull),
		.pcs10gtxfull(pcs10gtxfull),
		.pcs10gtxframe(pcs10gtxframe),
		.pcs10gtxburstenexe(pcs10gtxburstenexe),
		.pcs10gtxwordslipexe(pcs10gtxwordslipexe),
		.dataoutto8gpcs(dataoutto8gpcs),
		.pcs8gpldtxclk(pcs8gpldtxclk),
		.pcs8gpolinvtx(pcs8gpolinvtx),
		.pcs8grevloopbk(pcs8grevloopbk),
		.pcs8gwrenabletx(pcs8gwrenabletx),
		.pcs8grddisabletx(pcs8grddisabletx),
		.pcs8gtxboundarysel(pcs8gtxboundarysel),
		.pcs8gtxdatavalid(pcs8gtxdatavalid),
		.pcs8gtxsynchdr(pcs8gtxsynchdr),
		.pcs8gtxblkstart(pcs8gtxblkstart),
		.pcs8gfulltx(pcs8gfulltx),
		.pcs8gemptytx(pcs8gemptytx),
		.clockinfrom8gpcs(clockinfrom8gpcs),
		.pcsgen3txrstn(pcsgen3txrstn),
		.pcsgen3txrst(pcsgen3txrst),
		.pmaclkdiv33lc(pmaclkdiv33lc),
		.pldclkdiv33lc(pldclkdiv33lc),
		.pmatxlcplllock(pmatxlcplllock),
		.pldlccmurstbout(pldlccmurstbout),
		.pldtxiqclkout(pldtxiqclkout),
		.pcs10gtxfifoinsert(pcs10gtxfifoinsert),
		.pld10gtxfifodel(pld10gtxfifodel),
		.pld10gtxfifoinsert(pld10gtxfifoinsert),
		.pcs10gtxfifodel(pcs10gtxfifodel),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.pcs8gphfifoursttx(pcs8gphfifoursttx),
		.pcs10gtxpldrstn(pcs10gtxpldrstn),
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.emsiptxin(emsiptxin),
		.pldtxpmasyncpfbkpout(pldtxpmasyncpfbkpout),
		.emsippcstxclkin(emsippcstxclkin),
		.rstsel(rstsel),
		.emsiptxspecialin(emsiptxspecialin),
		.emsippcstxclkout(emsippcstxclkout),
		.emsiptxspecialout(emsiptxspecialout),
		.pld10gtxpldrstn(pld10gtxpldrstn),
		.emsiptxout(emsiptxout),
		.pmatxcmuplllock(pmatxcmuplllock),
		.pld8gphfifoursttxn(pld8gphfifoursttxn),
		.usrrstsel(usrrstsel),
		.pcs8gtxurstpcs(pcs8gtxurstpcs),
		.pld8gtxurstpcsn(pld8gtxurstpcsn),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule

//******************************************************************************
//
//  Description:
//      This module is intended to provide a functional simulation model for the
//    stratixv_hssi_refclk_divider atom.
//
//  Special Notes:
//      Does not currently model all possible parameters. An error is thrown
//    for unhandled cases.
//
//******************************************************************************

`timescale 1 ps/1 ps

module stratixv_hssi_refclk_divider 
  #(  
      parameter divide_by                   =  1,
      parameter enabled                     = "false",
      parameter refclk_coupling_termination = "normal_100_ohm_termination",
      parameter reference_clock_frequency   = "0 ps",
      parameter avmm_group_channel_index    = 0,
      parameter use_default_base_address    = "true",
      parameter user_base_address           = 0
  ) (
  input           avmmrstn,
  input           avmmclk,
  input           avmmwrite,
  input           avmmread,
  input   [ 1:0]  avmmbyteen,
  input   [10:0]  avmmaddress,
  input   [15:0]  avmmwritedata,
  output  [15:0]  avmmreaddata,
  output          blockselect,

  input           refclkin,
  output          refclkout,

  input           nonuserfrompmaux
);


reg   rxp_div2;     // Clock divided by 2
wire  rxp_div2_180; // Clock divided by 2 with 180 degree phase shift

// Currently unused
assign  blockselect   = 1'b0;
assign  avmmreaddata  = 16'd0;

// Reference clock output
assign refclkout  = ( enabled == "false") && ( divide_by == 1 ) ? refclkin : 
                    ( enabled == "false") && ( divide_by == 2 ) ? rxp_div2_180 :
                    1'bx; // Drive unknown as we are not properly handling case where "enabled == true"


// Clock divider
initial begin
  rxp_div2  = 1'b1;

  if (enabled != "false")
    $display("[stratixv_hssi_refclk_divider] - ERROR! - Parameter \"enabled\" does not support value $s", enabled);
end

assign  rxp_div2_180 = ~rxp_div2; // mimic 180 degree phase shift as in ICD RTL

always @(posedge refclkin)
  rxp_div2  <= ~rxp_div2;

endmodule

`timescale 1 ps / 1 ps
module stratixv_hssi_aux_clock_div (
    clk,     // input clock
    reset,   // reset
    enable_d, // enable DPRIO
    d,        // division factor for DPRIO support
    clkout   // divided clock
);
input clk,reset;
input enable_d;
input [7:0] d;
output clkout;


parameter clk_divide_by  = 1;
parameter extra_latency  = 0;

integer clk_edges,m;
reg [2*extra_latency:0] div_n_register;
reg [7:0] d_factor_dly;
reg [31:0] clk_divide_value;

wire [7:0] d_factor;
wire int_reset;

initial
begin
    div_n_register = 'b0;
    clk_edges = -1;
    m = 0;
    d_factor_dly =  'b0;
    clk_divide_value = clk_divide_by;
end

assign d_factor = (enable_d === 1'b1) ? d : clk_divide_value[7:0];

always @(d_factor)
begin
    d_factor_dly <= d_factor;
end


// create a reset pulse when there is a change in the d_factor value
assign int_reset = (d_factor !== d_factor_dly) ? 1'b1 : 1'b0;

always @(posedge clk or negedge clk or posedge reset or posedge int_reset)
begin
    div_n_register <= {div_n_register, div_n_register[0]};

    if ((reset === 1'b1) || (int_reset === 1'b1)) 
    begin
        clk_edges = -1;
        div_n_register <= 'b0;
    end
    else
    begin
        if (clk_edges == -1) 
        begin
            div_n_register[0] <= clk;
            if (clk == 1'b1) clk_edges = 0;
        end
        else if (clk_edges % d_factor == 0) 
                div_n_register[0] <= ~div_n_register[0];
        if (clk_edges >= 0 || clk == 1'b1)
            clk_edges = (clk_edges + 1) % (2*d_factor) ;
    end
end

assign clkout = div_n_register[2*extra_latency];

endmodule

// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_10g_rx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_10g_rx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..65
	parameter frmgen_sync_word = 64'h78f678f678f678f6,	//Valid values: 
	parameter frmgen_scrm_word = 64'h2800000000000000,	//Valid values: 
	parameter frmgen_skip_word = 64'h1e1e1e1e1e1e1e1e,	//Valid values: 
	parameter frmgen_diag_word = 64'h6400000000000000,	//Valid values: 
	parameter test_bus_mode = "tx",	//Valid values: tx|rx
	parameter skip_ctrl = "skip_ctrl_default",	//Valid values: skip_ctrl_default
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter prot_mode = "disable_mode",	//Valid values: disable_mode|teng_baser_mode|interlaken_mode|sfis_mode|teng_sdi_mode|basic_mode|test_prbs_mode|test_prp_mode
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode|stretch_mode|engr_mode
	parameter dis_signal_ok = "dis_signal_ok_dis",	//Valid values: dis_signal_ok_dis|dis_signal_ok_en
	parameter gb_rx_idwidth = "width_32",	//Valid values: width_40|width_32|width_64|width_32_default
	parameter gb_rx_odwidth = "width_66",	//Valid values: width_32|width_40|width_50|width_67|width_64|width_66
	parameter bit_reverse = "bit_reverse_dis",	//Valid values: bit_reverse_dis|bit_reverse_en
	parameter gb_sel_mode = "internal",	//Valid values: internal|external
	parameter lpbk_mode = "lpbk_dis",	//Valid values: lpbk_dis|lpbk_en
	parameter test_mode = "test_off",	//Valid values: test_off|pseudo_random|prbs_31|prbs_23|prbs_9|prbs_7
	parameter blksync_bypass = "blksync_bypass_dis",	//Valid values: blksync_bypass_dis|blksync_bypass_en
	parameter blksync_pipeln = "blksync_pipeln_dis",	//Valid values: blksync_pipeln_dis|blksync_pipeln_en
	parameter blksync_knum_sh_cnt_prelock = "knum_sh_cnt_prelock_10g",	//Valid values: knum_sh_cnt_prelock_10g|knum_sh_cnt_prelock_40g100g
	parameter blksync_knum_sh_cnt_postlock = "knum_sh_cnt_postlock_10g",	//Valid values: knum_sh_cnt_postlock_10g|knum_sh_cnt_postlock_40g100g
	parameter blksync_enum_invalid_sh_cnt = "enum_invalid_sh_cnt_10g",	//Valid values: enum_invalid_sh_cnt_10g|enum_invalid_sh_cnt_40g100g
	parameter blksync_bitslip_wait_cnt = "bitslip_wait_cnt_min",	//Valid values: bitslip_wait_cnt_min|bitslip_wait_cnt_max|bitslip_wait_cnt_user_setting
	parameter bitslip_wait_cnt_user = 1,	//Valid values: 0..7
	parameter blksync_bitslip_type = "bitslip_comb",	//Valid values: bitslip_comb|bitslip_reg
	parameter blksync_bitslip_wait_type = "bitslip_match",	//Valid values: bitslip_match|bitslip_cnt
	parameter dispchk_bypass = "dispchk_bypass_dis",	//Valid values: dispchk_bypass_dis|dispchk_bypass_en
	parameter dispchk_rd_level = "dispchk_rd_level_min",	//Valid values: dispchk_rd_level_min|dispchk_rd_level_max|dispchk_rd_level_user_setting
	parameter dispchk_rd_level_user = 8'b1100000,	//Valid values: 8
	parameter dispchk_pipeln = "dispchk_pipeln_dis",	//Valid values: dispchk_pipeln_dis|dispchk_pipeln_en
	parameter descrm_bypass = "descrm_bypass_en",	//Valid values: descrm_bypass_dis|descrm_bypass_en
	parameter descrm_mode = "async",	//Valid values: async|sync
	parameter frmsync_bypass = "frmsync_bypass_dis",	//Valid values: frmsync_bypass_dis|frmsync_bypass_en
	parameter frmsync_pipeln = "frmsync_pipeln_dis",	//Valid values: frmsync_pipeln_dis|frmsync_pipeln_en
	parameter frmsync_mfrm_length = "frmsync_mfrm_length_min",	//Valid values: frmsync_mfrm_length_min|frmsync_mfrm_length_max|frmsync_mfrm_length_user_setting
	parameter frmsync_mfrm_length_user = 2048,	//Valid values: 0..8191
	parameter frmsync_knum_sync = "knum_sync_default",	//Valid values: knum_sync_default
	parameter frmsync_enum_sync = "enum_sync_default",	//Valid values: enum_sync_default
	parameter frmsync_enum_scrm = "enum_scrm_default",	//Valid values: enum_scrm_default
	parameter frmsync_flag_type = "all_framing_words",	//Valid values: all_framing_words|location_only
	parameter dec_64b66b_rxsm_bypass = "dec_64b66b_rxsm_bypass_dis",	//Valid values: dec_64b66b_rxsm_bypass_dis|dec_64b66b_rxsm_bypass_en
	parameter rx_sm_bypass = "rx_sm_bypass_dis",	//Valid values: rx_sm_bypass_dis|rx_sm_bypass_en
	parameter rx_sm_pipeln = "rx_sm_pipeln_dis",	//Valid values: rx_sm_pipeln_dis|rx_sm_pipeln_en
	parameter rx_sm_hiber = "rx_sm_hiber_en",	//Valid values: rx_sm_hiber_en|rx_sm_hiber_dis
	parameter ber_xus_timer_window = "xus_timer_window_10g",	//Valid values: xus_timer_window_10g|xus_timer_window_user_setting
	parameter ber_bit_err_total_cnt = "bit_err_total_cnt_10g",	//Valid values: bit_err_total_cnt_10g
	parameter crcchk_bypass = "crcchk_bypass_dis",	//Valid values: crcchk_bypass_dis|crcchk_bypass_en
	parameter crcchk_pipeln = "crcchk_pipeln_dis",	//Valid values: crcchk_pipeln_dis|crcchk_pipeln_en
	parameter crcflag_pipeln = "crcflag_pipeln_dis",	//Valid values: crcflag_pipeln_dis|crcflag_pipeln_en
	parameter crcchk_init = "crcchk_init_user_setting",	//Valid values: crcchk_init_user_setting
	parameter crcchk_init_user = 32'b11111111111111111111111111111111,	//Valid values: 
	parameter crcchk_inv = "crcchk_inv_dis",	//Valid values: crcchk_inv_dis|crcchk_inv_en
	parameter force_align = "force_align_dis",	//Valid values: force_align_dis|force_align_en
	parameter align_del = "align_del_en",	//Valid values: align_del_dis|align_del_en
	parameter control_del = "control_del_all",	//Valid values: control_del_all|control_del_none
	parameter rxfifo_mode = "phase_comp",	//Valid values: register_mode|clk_comp_10g|clk_comp_basic|generic_interlaken|generic_basic|phase_comp|phase_comp_dv|clk_comp|generic
	parameter master_clk_sel = "master_rx_pma_clk",	//Valid values: master_rx_pma_clk|master_tx_pma_clk|master_refclk_dig
	parameter rd_clk_sel = "rd_rx_pma_clk",	//Valid values: rd_rx_pld_clk|rd_rx_pma_clk|rd_refclk_dig
	parameter gbexp_clken = "gbexp_clk_dis",	//Valid values: gbexp_clk_dis|gbexp_clk_en
	parameter prbs_clken = "prbs_clk_dis",	//Valid values: prbs_clk_dis|prbs_clk_en
	parameter blksync_clken = "blksync_clk_dis",	//Valid values: blksync_clk_dis|blksync_clk_en
	parameter dispchk_clken = "dispchk_clk_dis",	//Valid values: dispchk_clk_dis|dispchk_clk_en
	parameter descrm_clken = "descrm_clk_dis",	//Valid values: descrm_clk_dis|descrm_clk_en
	parameter frmsync_clken = "frmsync_clk_dis",	//Valid values: frmsync_clk_dis|frmsync_clk_en
	parameter dec64b66b_clken = "dec64b66b_clk_dis",	//Valid values: dec64b66b_clk_dis|dec64b66b_clk_en
	parameter ber_clken = "ber_clk_dis",	//Valid values: ber_clk_dis|ber_clk_en
	parameter rand_clken = "rand_clk_dis",	//Valid values: rand_clk_dis|rand_clk_en
	parameter crcchk_clken = "crcchk_clk_dis",	//Valid values: crcchk_clk_dis|crcchk_clk_en
	parameter wrfifo_clken = "wrfifo_clk_dis",	//Valid values: wrfifo_clk_dis|wrfifo_clk_en
	parameter rdfifo_clken = "rdfifo_clk_dis",	//Valid values: rdfifo_clk_dis|rdfifo_clk_en
	parameter rxfifo_pempty = 7,	//Valid values: 
	parameter rxfifo_pfull = 23,	//Valid values: 
	parameter rxfifo_full = 31,	//Valid values: 
	parameter rxfifo_empty = 0,	//Valid values: 
	parameter bitslip_mode = "bitslip_dis",	//Valid values: bitslip_dis|bitslip_en
	parameter fast_path = "fast_path_dis",	//Valid values: fast_path_dis|fast_path_en
	parameter stretch_num_stages = "zero_stage",	//Valid values: zero_stage|one_stage|two_stage|three_stage
	parameter stretch_en = "stretch_en",	//Valid values: stretch_en|stretch_dis
	parameter iqtxrx_clkout_sel = "iq_rx_clk_out",	//Valid values: iq_rx_clk_out|iq_rx_pma_clk_div33
	parameter rx_dfx_lpbk = "dfx_lpbk_dis",	//Valid values: dfx_lpbk_dis|dfx_lpbk_en
	parameter rx_polarity_inv = "invert_disable",	//Valid values: invert_disable|invert_enable
	parameter rx_scrm_width = "bit64",	//Valid values: bit64|bit66|bit67
	parameter rx_true_b2b = "b2b",	//Valid values: single|b2b
	parameter rx_sh_location = "lsb",	//Valid values: lsb|msb
	parameter rx_fifo_write_ctrl = "blklock_stops",	//Valid values: blklock_stops|blklock_ignore
	parameter rx_testbus_sel = "crc32_chk_testbus1",	//Valid values: crc32_chk_testbus1|crc32_chk_testbus2|disp_chk_testbus1|disp_chk_testbus2|frame_sync_testbus1|frame_sync_testbus2|dec64b66b_testbus|rxsm_testbus|ber_testbus|blksync_testbus1|blksync_testbus2|gearbox_exp_testbus1|gearbox_exp_testbus2|prbs_ver_xg_testbus|descramble_testbus1|descramble_testbus2|rx_fifo_testbus1|rx_fifo_testbus2
	parameter rx_signal_ok_sel = "synchronized_ver",	//Valid values: synchronized_ver|nonsync_ver
	parameter rx_prbs_mask = "prbsmask128",	//Valid values: prbsmask128|prbsmask256|prbsmask512|prbsmask1024
	parameter ber_xus_timer_window_user = 21'b100110001001010	//Valid values: 21
)
(
//input and output port declaration
	input [ 0:0 ] txpmaclk,
	input [ 0:0 ] rxpmaclk,
	input [ 0:0 ] pmaclkdiv33txorrx,
	input [ 0:0 ] rxpmadatavalid,
	input [ 0:0 ] hardresetn,
	input [ 0:0 ] rxpldclk,
	input [ 0:0 ] rxpldrstn,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] rxalignen,
	input [ 0:0 ] rxalignclr,
	input [ 0:0 ] rxrden,
	input [ 0:0 ] rxdisparityclr,
	input [ 0:0 ] rxclrerrorblockcount,
	input [ 0:0 ] rxclrbercount,
	input [ 0:0 ] rxbitslip,
	input [ 0:0 ] rxprbserrorclr,
	output [ 0:0 ] rxclkout,
	output [ 0:0 ] rxclkiqout,
	output [ 0:0 ] rxdatavalid,
	output [ 63:0 ] rxdata,
	output [ 9:0 ] rxcontrol,
	output [ 0:0 ] rxfifoempty,
	output [ 0:0 ] rxfifopartialempty,
	output [ 0:0 ] rxfifopartialfull,
	output [ 0:0 ] rxfifofull,
	output [ 0:0 ] rxalignval,
	output [ 0:0 ] rxblocklock,
	output [ 0:0 ] rxsyncheadererror,
	output [ 0:0 ] rxhighber,
	output [ 0:0 ] rxframelock,
	output [ 0:0 ] rxrdpossts,
	output [ 0:0 ] rxrdnegsts,
	output [ 0:0 ] rxskipinserted,
	output [ 0:0 ] rxrxframe,
	output [ 0:0 ] rxpayloadinserted,
	output [ 0:0 ] rxsyncworderror,
	output [ 0:0 ] rxscramblererror,
	output [ 0:0 ] rxskipworderror,
	output [ 0:0 ] rxdiagnosticerror,
	output [ 0:0 ] rxmetaframeerror,
	output [ 0:0 ] rxcrc32error,
	output [ 1:0 ] rxdiagnosticstatus,
	output [ 19:0 ] rxtestdata,
	output [ 0:0 ] rxfifoinsert,
	output [ 0:0 ] rxfifodel,
	output [ 0:0 ] syncdatain,
	input [ 9:0 ] dfxlpbkcontrolin,
	output [ 0:0 ] rxprbserr,
	input [ 0:0 ] dfxlpbkdatavalidin,
	input [ 63:0 ] dfxlpbkdatain,
	output [ 0:0 ] rxprbsdone,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 79:0 ] lpbkdatain,
	input [ 79:0 ] rxpmadata
); 

	stratixv_hssi_10g_rx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.frmgen_sync_word(frmgen_sync_word),
		.frmgen_scrm_word(frmgen_scrm_word),
		.frmgen_skip_word(frmgen_skip_word),
		.frmgen_diag_word(frmgen_diag_word),
		.test_bus_mode(test_bus_mode),
		.skip_ctrl(skip_ctrl),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.prot_mode(prot_mode),
		.sup_mode(sup_mode),
		.dis_signal_ok(dis_signal_ok),
		.gb_rx_idwidth(gb_rx_idwidth),
		.gb_rx_odwidth(gb_rx_odwidth),
		.bit_reverse(bit_reverse),
		.gb_sel_mode(gb_sel_mode),
		.lpbk_mode(lpbk_mode),
		.test_mode(test_mode),
		.blksync_bypass(blksync_bypass),
		.blksync_pipeln(blksync_pipeln),
		.blksync_knum_sh_cnt_prelock(blksync_knum_sh_cnt_prelock),
		.blksync_knum_sh_cnt_postlock(blksync_knum_sh_cnt_postlock),
		.blksync_enum_invalid_sh_cnt(blksync_enum_invalid_sh_cnt),
		.blksync_bitslip_wait_cnt(blksync_bitslip_wait_cnt),
		.bitslip_wait_cnt_user(bitslip_wait_cnt_user),
		.blksync_bitslip_type(blksync_bitslip_type),
		.blksync_bitslip_wait_type(blksync_bitslip_wait_type),
		.dispchk_bypass(dispchk_bypass),
		.dispchk_rd_level(dispchk_rd_level),
		.dispchk_rd_level_user(dispchk_rd_level_user),
		.dispchk_pipeln(dispchk_pipeln),
		.descrm_bypass(descrm_bypass),
		.descrm_mode(descrm_mode),
		.frmsync_bypass(frmsync_bypass),
		.frmsync_pipeln(frmsync_pipeln),
		.frmsync_mfrm_length(frmsync_mfrm_length),
		.frmsync_mfrm_length_user(frmsync_mfrm_length_user),
		.frmsync_knum_sync(frmsync_knum_sync),
		.frmsync_enum_sync(frmsync_enum_sync),
		.frmsync_enum_scrm(frmsync_enum_scrm),
		.frmsync_flag_type(frmsync_flag_type),
		.dec_64b66b_rxsm_bypass(dec_64b66b_rxsm_bypass),
		.rx_sm_bypass(rx_sm_bypass),
		.rx_sm_pipeln(rx_sm_pipeln),
		.rx_sm_hiber(rx_sm_hiber),
		.ber_xus_timer_window(ber_xus_timer_window),
		.ber_bit_err_total_cnt(ber_bit_err_total_cnt),
		.crcchk_bypass(crcchk_bypass),
		.crcchk_pipeln(crcchk_pipeln),
		.crcflag_pipeln(crcflag_pipeln),
		.crcchk_init(crcchk_init),
		.crcchk_init_user(crcchk_init_user),
		.crcchk_inv(crcchk_inv),
		.force_align(force_align),
		.align_del(align_del),
		.control_del(control_del),
		.rxfifo_mode(rxfifo_mode),
		.master_clk_sel(master_clk_sel),
		.rd_clk_sel(rd_clk_sel),
		.gbexp_clken(gbexp_clken),
		.prbs_clken(prbs_clken),
		.blksync_clken(blksync_clken),
		.dispchk_clken(dispchk_clken),
		.descrm_clken(descrm_clken),
		.frmsync_clken(frmsync_clken),
		.dec64b66b_clken(dec64b66b_clken),
		.ber_clken(ber_clken),
		.rand_clken(rand_clken),
		.crcchk_clken(crcchk_clken),
		.wrfifo_clken(wrfifo_clken),
		.rdfifo_clken(rdfifo_clken),
		.rxfifo_pempty(rxfifo_pempty),
		.rxfifo_pfull(rxfifo_pfull),
		.rxfifo_full(rxfifo_full),
		.rxfifo_empty(rxfifo_empty),
		.bitslip_mode(bitslip_mode),
		.fast_path(fast_path),
		.stretch_num_stages(stretch_num_stages),
		.stretch_en(stretch_en),
		.iqtxrx_clkout_sel(iqtxrx_clkout_sel),
		.rx_dfx_lpbk(rx_dfx_lpbk),
		.rx_polarity_inv(rx_polarity_inv),
		.rx_scrm_width(rx_scrm_width),
		.rx_true_b2b(rx_true_b2b),
		.rx_sh_location(rx_sh_location),
		.rx_fifo_write_ctrl(rx_fifo_write_ctrl),
		.rx_testbus_sel(rx_testbus_sel),
		.rx_signal_ok_sel(rx_signal_ok_sel),
		.rx_prbs_mask(rx_prbs_mask),
		.ber_xus_timer_window_user(ber_xus_timer_window_user)

	)
	stratixv_hssi_10g_rx_pcs_encrypted_inst	(
		.txpmaclk(txpmaclk),
		.rxpmaclk(rxpmaclk),
		.pmaclkdiv33txorrx(pmaclkdiv33txorrx),
		.rxpmadatavalid(rxpmadatavalid),
		.hardresetn(hardresetn),
		.rxpldclk(rxpldclk),
		.rxpldrstn(rxpldrstn),
		.refclkdig(refclkdig),
		.rxalignen(rxalignen),
		.rxalignclr(rxalignclr),
		.rxrden(rxrden),
		.rxdisparityclr(rxdisparityclr),
		.rxclrerrorblockcount(rxclrerrorblockcount),
		.rxclrbercount(rxclrbercount),
		.rxbitslip(rxbitslip),
		.rxprbserrorclr(rxprbserrorclr),
		.rxclkout(rxclkout),
		.rxclkiqout(rxclkiqout),
		.rxdatavalid(rxdatavalid),
		.rxdata(rxdata),
		.rxcontrol(rxcontrol),
		.rxfifoempty(rxfifoempty),
		.rxfifopartialempty(rxfifopartialempty),
		.rxfifopartialfull(rxfifopartialfull),
		.rxfifofull(rxfifofull),
		.rxalignval(rxalignval),
		.rxblocklock(rxblocklock),
		.rxsyncheadererror(rxsyncheadererror),
		.rxhighber(rxhighber),
		.rxframelock(rxframelock),
		.rxrdpossts(rxrdpossts),
		.rxrdnegsts(rxrdnegsts),
		.rxskipinserted(rxskipinserted),
		.rxrxframe(rxrxframe),
		.rxpayloadinserted(rxpayloadinserted),
		.rxsyncworderror(rxsyncworderror),
		.rxscramblererror(rxscramblererror),
		.rxskipworderror(rxskipworderror),
		.rxdiagnosticerror(rxdiagnosticerror),
		.rxmetaframeerror(rxmetaframeerror),
		.rxcrc32error(rxcrc32error),
		.rxdiagnosticstatus(rxdiagnosticstatus),
		.rxtestdata(rxtestdata),
		.rxfifoinsert(rxfifoinsert),
		.rxfifodel(rxfifodel),
		.syncdatain(syncdatain),
		.dfxlpbkcontrolin(dfxlpbkcontrolin),
		.rxprbserr(rxprbserr),
		.dfxlpbkdatavalidin(dfxlpbkdatavalidin),
		.dfxlpbkdatain(dfxlpbkdatain),
		.rxprbsdone(rxprbsdone),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.lpbkdatain(lpbkdatain),
		.rxpmadata(rxpmadata)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_10g_tx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_10g_tx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..65
	parameter frmgen_sync_word = 64'h78f678f678f678f6,	//Valid values: 
	parameter frmgen_scrm_word = 64'h2800000000000000,	//Valid values: 
	parameter frmgen_skip_word = 64'h1e1e1e1e1e1e1e1e,	//Valid values: 
	parameter frmgen_diag_word = 64'h6400000000000000,	//Valid values: 
	parameter test_bus_mode = "tx",	//Valid values: tx|rx
	parameter skip_ctrl = "skip_ctrl_default",	//Valid values: skip_ctrl_default
	parameter prot_mode = "disable_mode",	//Valid values: disable_mode|teng_baser_mode|interlaken_mode|sfis_mode|teng_sdi_mode|basic_mode|test_prbs_mode|test_prp_mode|test_rpg_mode
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode|stretch_mode|engr_mode
	parameter ctrl_plane_bonding = "individual",	//Valid values: individual|ctrl_master|ctrl_slave_abv|ctrl_slave_blw
	parameter master_clk_sel = "master_tx_pma_clk",	//Valid values: master_tx_pma_clk|master_refclk_dig
	parameter wr_clk_sel = "wr_tx_pma_clk",	//Valid values: wr_tx_pld_clk|wr_tx_pma_clk|wr_refclk_dig
	parameter wrfifo_clken = "wrfifo_clk_dis",	//Valid values: wrfifo_clk_dis|wrfifo_clk_en
	parameter rdfifo_clken = "rdfifo_clk_dis",	//Valid values: rdfifo_clk_dis|rdfifo_clk_en
	parameter frmgen_clken = "frmgen_clk_dis",	//Valid values: frmgen_clk_dis|frmgen_clk_en
	parameter crcgen_clken = "crcgen_clk_dis",	//Valid values: crcgen_clk_dis|crcgen_clk_en
	parameter enc64b66b_txsm_clken = "enc64b66b_txsm_clk_dis",	//Valid values: enc64b66b_txsm_clk_dis|enc64b66b_txsm_clk_en
	parameter scrm_clken = "scrm_clk_dis",	//Valid values: scrm_clk_dis|scrm_clk_en
	parameter dispgen_clken = "dispgen_clk_dis",	//Valid values: dispgen_clk_dis|dispgen_clk_en
	parameter prbs_clken = "prbs_clk_dis",	//Valid values: prbs_clk_dis|prbs_clk_en
	parameter sqwgen_clken = "sqwgen_clk_dis",	//Valid values: sqwgen_clk_dis|sqwgen_clk_en
	parameter gbred_clken = "gbred_clk_dis",	//Valid values: gbred_clk_dis|gbred_clk_en
	parameter gb_tx_idwidth = "width_50",	//Valid values: width_32|width_40|width_50|width_67|width_64|width_66
	parameter gb_tx_odwidth = "width_32",	//Valid values: width_32|width_40|width_64|width_32_default
	parameter txfifo_mode = "phase_comp",	//Valid values: register_mode|clk_comp|interlaken_generic|basic_generic|phase_comp|generic
	parameter txfifo_pempty = 7,	//Valid values: 
	parameter txfifo_pfull = 23,	//Valid values: 
	parameter txfifo_empty = 0,	//Valid values: 
	parameter txfifo_full = 31,	//Valid values: 
	parameter frmgen_bypass = "frmgen_bypass_dis",	//Valid values: frmgen_bypass_dis|frmgen_bypass_en
	parameter frmgen_pipeln = "frmgen_pipeln_dis",	//Valid values: frmgen_pipeln_dis|frmgen_pipeln_en
	parameter frmgen_mfrm_length = "frmgen_mfrm_length_min",	//Valid values: frmgen_mfrm_length_min|frmgen_mfrm_length_max|frmgen_mfrm_length_user_setting
	parameter frmgen_mfrm_length_user = 5,	//Valid values: 
	parameter frmgen_pyld_ins = "frmgen_pyld_ins_dis",	//Valid values: frmgen_pyld_ins_dis|frmgen_pyld_ins_en
	parameter sh_err = "sh_err_dis",	//Valid values: sh_err_dis|sh_err_en
	parameter frmgen_burst = "frmgen_burst_dis",	//Valid values: frmgen_burst_dis|frmgen_burst_en
	parameter frmgen_wordslip = "frmgen_wordslip_dis",	//Valid values: frmgen_wordslip_dis|frmgen_wordslip_en
	parameter crcgen_bypass = "crcgen_bypass_dis",	//Valid values: crcgen_bypass_dis|crcgen_bypass_en
	parameter crcgen_init = "crcgen_init_user_setting",	//Valid values: crcgen_init_user_setting
	parameter crcgen_init_user = 32'b11111111111111111111111111111111,	//Valid values: 
	parameter crcgen_inv = "crcgen_inv_dis",	//Valid values: crcgen_inv_dis|crcgen_inv_en
	parameter crcgen_err = "crcgen_err_dis",	//Valid values: crcgen_err_dis|crcgen_err_en
	parameter enc_64b66b_txsm_bypass = "enc_64b66b_txsm_bypass_dis",	//Valid values: enc_64b66b_txsm_bypass_dis|enc_64b66b_txsm_bypass_en
	parameter tx_sm_bypass = "tx_sm_bypass_dis",	//Valid values: tx_sm_bypass_dis|tx_sm_bypass_en
	parameter tx_sm_pipeln = "tx_sm_pipeln_dis",	//Valid values: tx_sm_pipeln_dis|tx_sm_pipeln_en
	parameter scrm_bypass = "scrm_bypass_dis",	//Valid values: scrm_bypass_dis|scrm_bypass_en
	parameter test_mode = "test_off",	//Valid values: test_off|pseudo_random|sq_wave|prbs_31|prbs_23|prbs_9|prbs_7
	parameter pseudo_random = "all_0",	//Valid values: all_0|two_lf
	parameter pseudo_seed_a = "pseudo_seed_a_user_setting",	//Valid values: pseudo_seed_a_user_setting
	parameter pseudo_seed_a_user = 58'b1111111111111111111111111111111111111111111111111111111111,	//Valid values: 
	parameter pseudo_seed_b = "pseudo_seed_b_user_setting",	//Valid values: pseudo_seed_b_user_setting
	parameter pseudo_seed_b_user = 58'b1111111111111111111111111111111111111111111111111111111111,	//Valid values: 
	parameter bit_reverse = "bit_reverse_dis",	//Valid values: bit_reverse_dis|bit_reverse_en
	parameter scrm_seed = "scram_seed_user_setting",	//Valid values: scram_seed_min|scram_seed_max|scram_seed_user_setting
	parameter scrm_seed_user = 58'b1111111111111111111111111111111111111111111111111111111111,	//Valid values: 58
	parameter scrm_mode = "async",	//Valid values: async|sync
	parameter dispgen_bypass = "dispgen_bypass_dis",	//Valid values: dispgen_bypass_dis|dispgen_bypass_en
	parameter dispgen_err = "dispgen_err_dis",	//Valid values: dispgen_err_dis|dispgen_err_en
	parameter dispgen_pipeln = "dispgen_pipeln_dis",	//Valid values: dispgen_pipeln_dis|dispgen_pipeln_en
	parameter gb_sel_mode = "internal",	//Valid values: internal|external
	parameter sq_wave = "sq_wave_4",	//Valid values: sq_wave_1|sq_wave_4|sq_wave_5|sq_wave_6|sq_wave_8|sq_wave_10
	parameter bitslip_en = "bitslip_dis",	//Valid values: bitslip_dis|bitslip_en
	parameter fastpath = "fastpath_dis",	//Valid values: fastpath_dis|fastpath_en
	parameter distup_bypass_pipeln = "distup_bypass_pipeln_dis",	//Valid values: distup_bypass_pipeln_dis|distup_bypass_pipeln_en
	parameter distup_master = "distup_master_en",	//Valid values: distup_master_en|distup_master_dis
	parameter distdwn_bypass_pipeln = "distdwn_bypass_pipeln_dis",	//Valid values: distdwn_bypass_pipeln_dis|distdwn_bypass_pipeln_en
	parameter distdwn_master = "distdwn_master_en",	//Valid values: distdwn_master_en|distdwn_master_dis
	parameter compin_sel = "compin_master",	//Valid values: compin_master|compin_slave_top|compin_slave_bot|compin_default
	parameter comp_cnt = "comp_cnt_00",	//Valid values: comp_cnt_00|comp_cnt_02|comp_cnt_04|comp_cnt_06|comp_cnt_08|comp_cnt_0a|comp_cnt_0c|comp_cnt_0e|comp_cnt_10|comp_cnt_12|comp_cnt_14|comp_cnt_16|comp_cnt_18
	parameter indv = "indv_en",	//Valid values: indv_en|indv_dis
	parameter stretch_num_stages = "zero_stage",	//Valid values: zero_stage|one_stage|two_stage|three_stage
	parameter stretch_en = "stretch_en",	//Valid values: stretch_en|stretch_dis
	parameter iqtxrx_clkout_sel = "iq_tx_pma_clk",	//Valid values: iq_tx_pma_clk|iq_tx_pma_clk_div33
	parameter tx_testbus_sel = "crc32_gen_testbus1",	//Valid values: crc32_gen_testbus1|crc32_gen_testbus2|disp_gen_testbus1|disp_gen_testbus2|frame_gen_testbus1|frame_gen_testbus2|enc64b66b_testbus|txsm_testbus|tx_cp_bond_testbus|prbs_gen_xg_testbus|gearbox_red_testbus1|gearbox_red_testbus2|scramble_testbus1|scramble_testbus2|tx_fifo_testbus1|tx_fifo_testbus2
	parameter tx_true_b2b = "b2b",	//Valid values: single|b2b
	parameter tx_scrm_width = "bit64",	//Valid values: bit64|bit66|bit67
	parameter pmagate_en = "pmagate_dis",	//Valid values: pmagate_dis|pmagate_en
	parameter tx_polarity_inv = "invert_disable",	//Valid values: invert_disable|invert_enable
	parameter comp_del_sel_agg = "data_agg_del0",	//Valid values: data_agg_del0|data_agg_del1|data_agg_del2|data_agg_del3|data_agg_del4|data_agg_del5|data_agg_del6|data_agg_del7|data_agg_del8
	parameter distup_bypass_pipeln_agg = "distup_bypass_pipeln_agg_dis",	//Valid values: distup_bypass_pipeln_agg_dis|distup_bypass_pipeln_agg_en
	parameter distdwn_bypass_pipeln_agg = "distdwn_bypass_pipeln_agg_dis",	//Valid values: distdwn_bypass_pipeln_agg_dis|distdwn_bypass_pipeln_agg_en
	parameter tx_sh_location = "lsb",	//Valid values: lsb|msb
	parameter tx_scrm_err = "scrm_err_dis",	//Valid values: scrm_err_dis|scrm_err_en
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter phcomp_rd_del = "phcomp_rd_del1"	//Valid values: phcomp_rd_del5|phcomp_rd_del4|phcomp_rd_del3|phcomp_rd_del2|phcomp_rd_del1
)
(
//input and output port declaration
	input [ 0:0 ] txpmaclk,
	input [ 0:0 ] pmaclkdiv33lc,
	input [ 0:0 ] hardresetn,
	input [ 0:0 ] txpldclk,
	input [ 0:0 ] txpldrstn,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] txdatavalid,
	input [ 63:0 ] txdata,
	input [ 8:0 ] txcontrol,
	input [ 6:0 ] txbitslip,
	input [ 1:0 ] txdiagnosticstatus,
	input [ 0:0 ] txwordslip,
	input [ 0:0 ] txbursten,
	input [ 0:0 ] txdisparityclr,
	output [ 0:0 ] txclkout,
	output [ 0:0 ] txclkiqout,
	output [ 0:0 ] txfifoempty,
	output [ 0:0 ] txfifopartialempty,
	output [ 0:0 ] txfifopartialfull,
	output [ 0:0 ] txfifofull,
	output [ 0:0 ] txframe,
	output [ 0:0 ] txburstenexe,
	output [ 0:0 ] txwordslipexe,
	input [ 0:0 ] distupindv,
	input [ 0:0 ] distdwnindv,
	input [ 0:0 ] distupinwren,
	input [ 0:0 ] distdwninwren,
	input [ 0:0 ] distupinrden,
	input [ 0:0 ] distdwninrden,
	output [ 0:0 ] distupoutdv,
	output [ 0:0 ] distdwnoutdv,
	output [ 0:0 ] distupoutwren,
	output [ 0:0 ] distdwnoutwren,
	output [ 0:0 ] distupoutrden,
	output [ 0:0 ] distdwnoutrden,
	output [ 0:0 ] txfifoinsert,
	output [ 0:0 ] txfifodel,
	output [ 0:0 ] syncdatain,
	output [ 79:0 ] txpmadata,
	input [ 0:0 ] distdwninintlknrden,
	output [ 79:0 ] lpbkdataout,
	output [ 0:0 ] distdwnoutintlknrden,
	output [ 0:0 ] dfxlpbkdatavalidout,
	output [ 0:0 ] distupoutintlknrden,
	output [ 63:0 ] dfxlpbkdataout,
	output [ 8:0 ] dfxlpbkcontrolout,
	input [ 0:0 ] distupinintlknrden,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 0:0 ] distupinrdpfull,
	output [ 0:0 ] distupoutrdpfull,
	output [ 0:0 ] distdwnoutrdpfull,
	input [ 0:0 ] distdwninrdpfull
); 

	stratixv_hssi_10g_tx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.frmgen_sync_word(frmgen_sync_word),
		.frmgen_scrm_word(frmgen_scrm_word),
		.frmgen_skip_word(frmgen_skip_word),
		.frmgen_diag_word(frmgen_diag_word),
		.test_bus_mode(test_bus_mode),
		.skip_ctrl(skip_ctrl),
		.prot_mode(prot_mode),
		.sup_mode(sup_mode),
		.ctrl_plane_bonding(ctrl_plane_bonding),
		.master_clk_sel(master_clk_sel),
		.wr_clk_sel(wr_clk_sel),
		.wrfifo_clken(wrfifo_clken),
		.rdfifo_clken(rdfifo_clken),
		.frmgen_clken(frmgen_clken),
		.crcgen_clken(crcgen_clken),
		.enc64b66b_txsm_clken(enc64b66b_txsm_clken),
		.scrm_clken(scrm_clken),
		.dispgen_clken(dispgen_clken),
		.prbs_clken(prbs_clken),
		.sqwgen_clken(sqwgen_clken),
		.gbred_clken(gbred_clken),
		.gb_tx_idwidth(gb_tx_idwidth),
		.gb_tx_odwidth(gb_tx_odwidth),
		.txfifo_mode(txfifo_mode),
		.txfifo_pempty(txfifo_pempty),
		.txfifo_pfull(txfifo_pfull),
		.txfifo_empty(txfifo_empty),
		.txfifo_full(txfifo_full),
		.frmgen_bypass(frmgen_bypass),
		.frmgen_pipeln(frmgen_pipeln),
		.frmgen_mfrm_length(frmgen_mfrm_length),
		.frmgen_mfrm_length_user(frmgen_mfrm_length_user),
		.frmgen_pyld_ins(frmgen_pyld_ins),
		.sh_err(sh_err),
		.frmgen_burst(frmgen_burst),
		.frmgen_wordslip(frmgen_wordslip),
		.crcgen_bypass(crcgen_bypass),
		.crcgen_init(crcgen_init),
		.crcgen_init_user(crcgen_init_user),
		.crcgen_inv(crcgen_inv),
		.crcgen_err(crcgen_err),
		.enc_64b66b_txsm_bypass(enc_64b66b_txsm_bypass),
		.tx_sm_bypass(tx_sm_bypass),
		.tx_sm_pipeln(tx_sm_pipeln),
		.scrm_bypass(scrm_bypass),
		.test_mode(test_mode),
		.pseudo_random(pseudo_random),
		.pseudo_seed_a(pseudo_seed_a),
		.pseudo_seed_a_user(pseudo_seed_a_user),
		.pseudo_seed_b(pseudo_seed_b),
		.pseudo_seed_b_user(pseudo_seed_b_user),
		.bit_reverse(bit_reverse),
		.scrm_seed(scrm_seed),
		.scrm_seed_user(scrm_seed_user),
		.scrm_mode(scrm_mode),
		.dispgen_bypass(dispgen_bypass),
		.dispgen_err(dispgen_err),
		.dispgen_pipeln(dispgen_pipeln),
		.gb_sel_mode(gb_sel_mode),
		.sq_wave(sq_wave),
		.bitslip_en(bitslip_en),
		.fastpath(fastpath),
		.distup_bypass_pipeln(distup_bypass_pipeln),
		.distup_master(distup_master),
		.distdwn_bypass_pipeln(distdwn_bypass_pipeln),
		.distdwn_master(distdwn_master),
		.compin_sel(compin_sel),
		.comp_cnt(comp_cnt),
		.indv(indv),
		.stretch_num_stages(stretch_num_stages),
		.stretch_en(stretch_en),
		.iqtxrx_clkout_sel(iqtxrx_clkout_sel),
		.tx_testbus_sel(tx_testbus_sel),
		.tx_true_b2b(tx_true_b2b),
		.tx_scrm_width(tx_scrm_width),
		.pmagate_en(pmagate_en),
		.tx_polarity_inv(tx_polarity_inv),
		.comp_del_sel_agg(comp_del_sel_agg),
		.distup_bypass_pipeln_agg(distup_bypass_pipeln_agg),
		.distdwn_bypass_pipeln_agg(distdwn_bypass_pipeln_agg),
		.tx_sh_location(tx_sh_location),
		.tx_scrm_err(tx_scrm_err),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.phcomp_rd_del(phcomp_rd_del)

	)
	stratixv_hssi_10g_tx_pcs_encrypted_inst	(
		.txpmaclk(txpmaclk),
		.pmaclkdiv33lc(pmaclkdiv33lc),
		.hardresetn(hardresetn),
		.txpldclk(txpldclk),
		.txpldrstn(txpldrstn),
		.refclkdig(refclkdig),
		.txdatavalid(txdatavalid),
		.txdata(txdata),
		.txcontrol(txcontrol),
		.txbitslip(txbitslip),
		.txdiagnosticstatus(txdiagnosticstatus),
		.txwordslip(txwordslip),
		.txbursten(txbursten),
		.txdisparityclr(txdisparityclr),
		.txclkout(txclkout),
		.txclkiqout(txclkiqout),
		.txfifoempty(txfifoempty),
		.txfifopartialempty(txfifopartialempty),
		.txfifopartialfull(txfifopartialfull),
		.txfifofull(txfifofull),
		.txframe(txframe),
		.txburstenexe(txburstenexe),
		.txwordslipexe(txwordslipexe),
		.distupindv(distupindv),
		.distdwnindv(distdwnindv),
		.distupinwren(distupinwren),
		.distdwninwren(distdwninwren),
		.distupinrden(distupinrden),
		.distdwninrden(distdwninrden),
		.distupoutdv(distupoutdv),
		.distdwnoutdv(distdwnoutdv),
		.distupoutwren(distupoutwren),
		.distdwnoutwren(distdwnoutwren),
		.distupoutrden(distupoutrden),
		.distdwnoutrden(distdwnoutrden),
		.txfifoinsert(txfifoinsert),
		.txfifodel(txfifodel),
		.syncdatain(syncdatain),
		.txpmadata(txpmadata),
		.distdwninintlknrden(distdwninintlknrden),
		.lpbkdataout(lpbkdataout),
		.distdwnoutintlknrden(distdwnoutintlknrden),
		.dfxlpbkdatavalidout(dfxlpbkdatavalidout),
		.distupoutintlknrden(distupoutintlknrden),
		.dfxlpbkdataout(dfxlpbkdataout),
		.dfxlpbkcontrolout(dfxlpbkcontrolout),
		.distupinintlknrden(distupinintlknrden),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.distupinrdpfull(distupinrdpfull),
		.distupoutrdpfull(distupoutrdpfull),
		.distdwnoutrdpfull(distdwnoutrdpfull),
		.distdwninrdpfull(distdwninrdpfull)
	);


endmodule
// ----------------------------------------------------------------------------------
// This is the HSSI Simulation Atom Model Encryption wrapper for the AVMM Interface
// Module Name : stratixv_hssi_avmm_interface
// ----------------------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_avmm_interface
  #(
    parameter num_ch0_atoms = 0,
    parameter num_ch1_atoms = 0,
    parameter num_ch2_atoms = 0
    )
(
//input and output port declaration
    input  wire                 avmmrstn,
    input  wire                 avmmclk,
    input  wire                 avmmwrite,
    input  wire                 avmmread,
    input  wire  [ 1:0 ]        avmmbyteen,
    input  wire  [ 10:0 ]       avmmaddress,
    input  wire  [ 15:0 ]       avmmwritedata,
    input  wire  [ 90-1:0 ]     blockselect,
    input  wire  [ 90*16 -1:0 ] readdatachnl,

    output wire  [ 15:0 ]       avmmreaddata,

    output wire                 clkchnl,
    output wire                 rstnchnl,
    output wire  [ 15:0 ]       writedatachnl,
    output wire  [ 10:0 ]       regaddrchnl,
    output wire                 writechnl,
    output wire                 readchnl,
    output wire  [ 1:0 ]        byteenchnl,

    //The following ports are not modelled. They exist to match the avmm interface atom interface
    input  wire                 refclkdig,
    input  wire                 avmmreservedin,
    
    output wire                 avmmreservedout,
    output wire                 dpriorstntop,
    output wire                 dprioclktop,
    output wire                 mdiodistopchnl,
    output wire                 dpriorstnmid,
    output wire                 dprioclkmid,
    output wire                 mdiodismidchnl,
    output wire                 dpriorstnbot,
    output wire                 dprioclkbot,
    output wire                 mdiodisbotchnl,
    output wire  [ 3:0 ]        dpriotestsitopchnl,
    output wire  [ 3:0 ]        dpriotestsimidchnl,
    output wire  [ 3:0 ]        dpriotestsibotchnl,
 
    //The following ports belong to pm_adce and pm_tst_mux blocks in the PMA
    input  wire  [ 11:0 ]       pmatestbussel,
    output wire  [ 23:0 ]       pmatestbus,
  
    //
    input  wire                 scanmoden,
    input  wire                 scanshiftn,
    input  wire                 interfacesel,
    input  wire                 sershiftload
); 

  stratixv_hssi_avmm_interface_encrypted
  #(
    .num_ch0_atoms(num_ch0_atoms),
    .num_ch1_atoms(num_ch1_atoms),
    .num_ch2_atoms(num_ch2_atoms)
  ) stratixv_hssi_avmm_interface_encrypted_inst (
    .avmmrstn          (avmmrstn),
    .avmmclk           (avmmclk),
    .avmmwrite         (avmmwrite),
    .avmmread          (avmmread),
    .avmmbyteen        (avmmbyteen),
    .avmmaddress       (avmmaddress),
    .avmmwritedata     (avmmwritedata),
    .blockselect       (blockselect),
    .readdatachnl      (readdatachnl),
    .avmmreaddata      (avmmreaddata),
    .clkchnl           (clkchnl),
    .rstnchnl          (rstnchnl),
    .writedatachnl     (writedatachnl),
    .regaddrchnl       (regaddrchnl),
    .writechnl         (writechnl),
    .readchnl          (readchnl),
    .byteenchnl        (byteenchnl),
    .refclkdig         (refclkdig),
    .avmmreservedin    (avmmreservedin),
    .avmmreservedout   (avmmreservedout),
    .dpriorstntop      (dpriorstntop),
    .dprioclktop       (dprioclktop),
    .mdiodistopchnl    (mdiodistopchnl),
    .dpriorstnmid      (dpriorstnmid),
    .dprioclkmid       (dprioclkmid),
    .mdiodismidchnl    (mdiodismidchnl),
    .dpriorstnbot      (dpriorstnbot),
    .dprioclkbot       (dprioclkbot),
    .mdiodisbotchnl    (mdiodisbotchnl),
    .dpriotestsitopchnl(dpriotestsitopchnl),
    .dpriotestsimidchnl(dpriotestsimidchnl),
    .dpriotestsibotchnl(dpriotestsibotchnl),
    .pmatestbus        (pmatestbus),
    .pmatestbussel     (pmatestbussel),
    .scanmoden         (scanmoden),
    .scanshiftn        (scanshiftn),
    .interfacesel      (interfacesel),
    .sershiftload      (sershiftload)
  );

endmodule
