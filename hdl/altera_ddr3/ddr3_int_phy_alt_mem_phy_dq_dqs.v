//altdq_dqs CBX_SINGLE_OUTPUT_FILE="ON" DELAY_BUFFER_MODE="HIGH" DELAY_DQS_ENABLE_BY_HALF_CYCLE="TRUE" device_family="arriaii" DQ_HALF_RATE_USE_DATAOUTBYPASS="FALSE" DQ_INPUT_REG_ASYNC_MODE="NONE" DQ_INPUT_REG_CLK_SOURCE="INVERTED_DQS_BUS" DQ_INPUT_REG_MODE="DDIO" DQ_INPUT_REG_POWER_UP="HIGH" DQ_INPUT_REG_SYNC_MODE="NONE" DQ_INPUT_REG_USE_CLKN="FALSE" DQ_IPA_ADD_INPUT_CYCLE_DELAY="FALSE" DQ_IPA_ADD_PHASE_TRANSFER_REG="FALSE" DQ_IPA_BYPASS_OUTPUT_REGISTER="FALSE" DQ_IPA_INVERT_PHASE="FALSE" DQ_IPA_PHASE_SETTING=0 DQ_OE_REG_ASYNC_MODE="NONE" DQ_OE_REG_MODE="FF" DQ_OE_REG_POWER_UP="LOW" DQ_OE_REG_SYNC_MODE="NONE" DQ_OUTPUT_REG_ASYNC_MODE="CLEAR" DQ_OUTPUT_REG_MODE="DDIO" DQ_OUTPUT_REG_POWER_UP="LOW" DQ_OUTPUT_REG_SYNC_MODE="NONE" DQS_CTRL_LATCHES_ENABLE="FALSE" DQS_DELAY_CHAIN_DELAYCTRLIN_SOURCE="DLL" DQS_DELAY_CHAIN_PHASE_SETTING=2 DQS_DQSN_MODE="DIFFERENTIAL" DQS_ENABLE_CTRL_ADD_PHASE_TRANSFER_REG="FALSE" DQS_ENABLE_CTRL_INVERT_PHASE="FALSE" DQS_ENABLE_CTRL_PHASE_SETTING=0 DQS_INPUT_FREQUENCY="300.0 MHz" DQS_OE_REG_ASYNC_MODE="NONE" DQS_OE_REG_MODE="FF" DQS_OE_REG_POWER_UP="LOW" DQS_OE_REG_SYNC_MODE="NONE" DQS_OFFSETCTRL_ENABLE="FALSE" DQS_OUTPUT_REG_ASYNC_MODE="NONE" DQS_OUTPUT_REG_MODE="DDIO" DQS_OUTPUT_REG_POWER_UP="LOW" DQS_OUTPUT_REG_SYNC_MODE="NONE" DQS_PHASE_SHIFT=7200 IO_CLOCK_DIVIDER_CLK_SOURCE="CORE" IO_CLOCK_DIVIDER_INVERT_PHASE="FALSE" IO_CLOCK_DIVIDER_PHASE_SETTING=0 LEVEL_DQS_ENABLE="FALSE" NUMBER_OF_BIDIR_DQ=8 NUMBER_OF_CLK_DIVIDER=0 NUMBER_OF_INPUT_DQ=0 NUMBER_OF_OUTPUT_DQ=1 OCT_REG_MODE="NONE" USE_DQ_INPUT_DELAY_CHAIN="FALSE" USE_DQ_IPA="FALSE" USE_DQ_IPA_PHASECTRLIN="FALSE" USE_DQ_OE_DELAY_CHAIN1="FALSE" USE_DQ_OE_DELAY_CHAIN2="FALSE" USE_DQ_OE_PATH="TRUE" USE_DQ_OUTPUT_DELAY_CHAIN1="FALSE" USE_DQ_OUTPUT_DELAY_CHAIN2="FALSE" USE_DQS="TRUE" USE_DQS_DELAY_CHAIN="TRUE" USE_DQS_DELAY_CHAIN_PHASECTRLIN="FALSE" USE_DQS_ENABLE="TRUE" USE_DQS_ENABLE_CTRL="TRUE" USE_DQS_ENABLE_CTRL_PHASECTRLIN="FALSE" USE_DQS_INPUT_DELAY_CHAIN="FALSE" USE_DQS_INPUT_PATH="TRUE" USE_DQS_OE_DELAY_CHAIN1="FALSE" USE_DQS_OE_DELAY_CHAIN2="FALSE" USE_DQS_OE_PATH="TRUE" USE_DQS_OUTPUT_DELAY_CHAIN1="FALSE" USE_DQS_OUTPUT_DELAY_CHAIN2="FALSE" USE_DQS_OUTPUT_PATH="TRUE" USE_DQSBUSOUT_DELAY_CHAIN="FALSE" USE_DQSENABLE_DELAY_CHAIN="FALSE" USE_DYNAMIC_OCT="FALSE" USE_HALF_RATE="FALSE" USE_IO_CLOCK_DIVIDER_MASTERIN="FALSE" USE_IO_CLOCK_DIVIDER_PHASECTRLIN="FALSE" USE_OCT_DELAY_CHAIN1="FALSE" USE_OCT_DELAY_CHAIN2="FALSE" bidir_dq_areset bidir_dq_input_data_in bidir_dq_input_data_out_high bidir_dq_input_data_out_low bidir_dq_oe_in bidir_dq_oe_out bidir_dq_output_data_in_high bidir_dq_output_data_in_low bidir_dq_output_data_out dll_delayctrlin dq_input_reg_clk dq_output_reg_clk dqs_enable_ctrl_clk dqs_enable_ctrl_in dqs_input_data_in dqs_oe_in dqs_oe_out dqs_output_data_in_high dqs_output_data_in_low dqs_output_data_out dqs_output_reg_clk dqsn_oe_in dqsn_oe_out output_dq_oe_in output_dq_oe_out output_dq_output_data_in_high output_dq_output_data_in_low output_dq_output_data_out
//VERSION_BEGIN 10.0SP1 cbx_altdq_dqs 2010:08:18:21:16:35:SJ cbx_mgl 2010:08:18:21:20:44:SJ cbx_stratixiii 2010:08:18:21:16:35:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2010 Altera Corporation
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, Altera MegaCore Function License 
//  Agreement, or other applicable license agreement, including, 
//  without limitation, that your use is for the sole purpose of 
//  programming logic devices manufactured by Altera and sold by 
//  Altera or its authorized distributors.  Please refer to the 
//  applicable agreement for further details.



//synthesis_resources = arriaii_ddio_in 8 arriaii_ddio_out 10 arriaii_dqs_delay_chain 1 arriaii_dqs_enable 1 arriaii_dqs_enable_ctrl 1 reg 11 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_0_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_1_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_2_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_3_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_4_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_5_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_6_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to bidir_dq_7_output_ddio_out_inst;-name DQ_GROUP 9 -from dqs_0_delay_chain_inst -to output_dq_0_output_ddio_out_inst"} *)
module  ddr3_int_phy_alt_mem_phy_dq_dqs
	( 
	bidir_dq_areset,
	bidir_dq_input_data_in,
	bidir_dq_input_data_out_high,
	bidir_dq_input_data_out_low,
	bidir_dq_oe_in,
	bidir_dq_oe_out,
	bidir_dq_output_data_in_high,
	bidir_dq_output_data_in_low,
	bidir_dq_output_data_out,
	dll_delayctrlin,
	dq_input_reg_clk,
	dq_output_reg_clk,
	dqs_enable_ctrl_clk,
	dqs_enable_ctrl_in,
	dqs_input_data_in,
	dqs_oe_in,
	dqs_oe_out,
	dqs_output_data_in_high,
	dqs_output_data_in_low,
	dqs_output_data_out,
	dqs_output_reg_clk,
	dqsn_oe_in,
	dqsn_oe_out,
	output_dq_oe_in,
	output_dq_oe_out,
	output_dq_output_data_in_high,
	output_dq_output_data_in_low,
	output_dq_output_data_out) /* synthesis synthesis_clearbox=1 */;
	input   [7:0]  bidir_dq_areset;
	input   [7:0]  bidir_dq_input_data_in;
	output   [7:0]  bidir_dq_input_data_out_high;
	output   [7:0]  bidir_dq_input_data_out_low;
	input   [7:0]  bidir_dq_oe_in;
	output   [7:0]  bidir_dq_oe_out;
	input   [7:0]  bidir_dq_output_data_in_high;
	input   [7:0]  bidir_dq_output_data_in_low;
	output   [7:0]  bidir_dq_output_data_out;
	input   [5:0]  dll_delayctrlin;
	input   dq_input_reg_clk;
	input   dq_output_reg_clk;
	input   dqs_enable_ctrl_clk;
	input   dqs_enable_ctrl_in;
	input   [0:0]  dqs_input_data_in;
	input   [0:0]  dqs_oe_in;
	output   [0:0]  dqs_oe_out;
	input   [0:0]  dqs_output_data_in_high;
	input   [0:0]  dqs_output_data_in_low;
	output   [0:0]  dqs_output_data_out;
	input   dqs_output_reg_clk;
	input   [0:0]  dqsn_oe_in;
	output   [0:0]  dqsn_oe_out;
	input   [0:0]  output_dq_oe_in;
	output   [0:0]  output_dq_oe_out;
	input   [0:0]  output_dq_output_data_in_high;
	input   [0:0]  output_dq_output_data_in_low;
	output   [0:0]  output_dq_output_data_out;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [7:0]  bidir_dq_areset;
	tri0   [7:0]  bidir_dq_input_data_in;
	tri0   [7:0]  bidir_dq_oe_in;
	tri0   [7:0]  bidir_dq_output_data_in_high;
	tri0   [7:0]  bidir_dq_output_data_in_low;
	tri0   [5:0]  dll_delayctrlin;
	tri0   dq_input_reg_clk;
	tri0   dq_output_reg_clk;
	tri1   dqs_enable_ctrl_clk;
	tri1   dqs_enable_ctrl_in;
	tri0   [0:0]  dqs_input_data_in;
	tri0   [0:0]  dqs_oe_in;
	tri0   [0:0]  dqs_output_data_in_high;
	tri0   [0:0]  dqs_output_data_in_low;
	tri0   dqs_output_reg_clk;
	tri0   [0:0]  dqsn_oe_in;
	tri0   [0:0]  output_dq_oe_in;
	tri0   [0:0]  output_dq_output_data_in_high;
	tri0   [0:0]  output_dq_output_data_in_low;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_0_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_1_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_2_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_3_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_4_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_5_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_6_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	bidir_dq_7_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	dqs_0_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	dqsn_0_oe_ff_inst;
	(* ALTERA_ATTRIBUTE = {"FAST_OUTPUT_ENABLE_REGISTER=ON"} *)
	reg	output_dq_0_oe_ff_inst;
	wire  wire_bidir_dq_0_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_0_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_1_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_1_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_2_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_2_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_3_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_3_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_4_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_4_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_5_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_5_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_6_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_6_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_7_ddio_in_inst_regouthi;
	wire  wire_bidir_dq_7_ddio_in_inst_regoutlo;
	wire  wire_bidir_dq_0_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_1_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_2_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_3_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_4_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_5_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_6_output_ddio_out_inst_dataout;
	wire  wire_bidir_dq_7_output_ddio_out_inst_dataout;
	wire  wire_dqs_0_output_ddio_out_inst_dataout;
	wire  wire_output_dq_0_output_ddio_out_inst_dataout;
	wire  wire_dqs_0_delay_chain_inst_dqsbusout;
	wire  wire_dqs_0_enable_inst_dqsbusout;
	wire  wire_dqs_0_enable_ctrl_inst_dqsenableout;
	wire  [0:0]  dqs_bus_wire;

	// synopsys translate_off
	initial
		bidir_dq_0_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_0_oe_ff_inst <= (~ bidir_dq_oe_in[0]);
	// synopsys translate_off
	initial
		bidir_dq_1_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_1_oe_ff_inst <= (~ bidir_dq_oe_in[1]);
	// synopsys translate_off
	initial
		bidir_dq_2_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_2_oe_ff_inst <= (~ bidir_dq_oe_in[2]);
	// synopsys translate_off
	initial
		bidir_dq_3_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_3_oe_ff_inst <= (~ bidir_dq_oe_in[3]);
	// synopsys translate_off
	initial
		bidir_dq_4_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_4_oe_ff_inst <= (~ bidir_dq_oe_in[4]);
	// synopsys translate_off
	initial
		bidir_dq_5_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_5_oe_ff_inst <= (~ bidir_dq_oe_in[5]);
	// synopsys translate_off
	initial
		bidir_dq_6_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_6_oe_ff_inst <= (~ bidir_dq_oe_in[6]);
	// synopsys translate_off
	initial
		bidir_dq_7_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  bidir_dq_7_oe_ff_inst <= (~ bidir_dq_oe_in[7]);
	// synopsys translate_off
	initial
		dqs_0_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dqs_output_reg_clk)
		  dqs_0_oe_ff_inst <= (~ dqs_oe_in[0]);
	// synopsys translate_off
	initial
		dqsn_0_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dqs_output_reg_clk)
		  dqsn_0_oe_ff_inst <= (~ dqsn_oe_in[0]);
	// synopsys translate_off
	initial
		output_dq_0_oe_ff_inst = 0;
	// synopsys translate_on
	always @ ( posedge dq_output_reg_clk)
		  output_dq_0_oe_ff_inst <= (~ output_dq_oe_in[0]);
	arriaii_ddio_in   bidir_dq_0_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[0]),
	.regouthi(wire_bidir_dq_0_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_0_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_0_ddio_in_inst.async_mode = "none",
		bidir_dq_0_ddio_in_inst.sync_mode = "none",
		bidir_dq_0_ddio_in_inst.use_clkn = "false",
		bidir_dq_0_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_1_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[1]),
	.regouthi(wire_bidir_dq_1_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_1_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_1_ddio_in_inst.async_mode = "none",
		bidir_dq_1_ddio_in_inst.sync_mode = "none",
		bidir_dq_1_ddio_in_inst.use_clkn = "false",
		bidir_dq_1_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_2_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[2]),
	.regouthi(wire_bidir_dq_2_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_2_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_2_ddio_in_inst.async_mode = "none",
		bidir_dq_2_ddio_in_inst.sync_mode = "none",
		bidir_dq_2_ddio_in_inst.use_clkn = "false",
		bidir_dq_2_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_3_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[3]),
	.regouthi(wire_bidir_dq_3_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_3_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_3_ddio_in_inst.async_mode = "none",
		bidir_dq_3_ddio_in_inst.sync_mode = "none",
		bidir_dq_3_ddio_in_inst.use_clkn = "false",
		bidir_dq_3_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_4_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[4]),
	.regouthi(wire_bidir_dq_4_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_4_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_4_ddio_in_inst.async_mode = "none",
		bidir_dq_4_ddio_in_inst.sync_mode = "none",
		bidir_dq_4_ddio_in_inst.use_clkn = "false",
		bidir_dq_4_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_5_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[5]),
	.regouthi(wire_bidir_dq_5_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_5_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_5_ddio_in_inst.async_mode = "none",
		bidir_dq_5_ddio_in_inst.sync_mode = "none",
		bidir_dq_5_ddio_in_inst.use_clkn = "false",
		bidir_dq_5_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_6_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[6]),
	.regouthi(wire_bidir_dq_6_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_6_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_6_ddio_in_inst.async_mode = "none",
		bidir_dq_6_ddio_in_inst.sync_mode = "none",
		bidir_dq_6_ddio_in_inst.use_clkn = "false",
		bidir_dq_6_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_in   bidir_dq_7_ddio_in_inst
	( 
	.clk((~ dqs_bus_wire[0])),
	.datain(bidir_dq_input_data_in[7]),
	.regouthi(wire_bidir_dq_7_ddio_in_inst_regouthi),
	.regoutlo(wire_bidir_dq_7_ddio_in_inst_regoutlo)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkn(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_7_ddio_in_inst.async_mode = "none",
		bidir_dq_7_ddio_in_inst.sync_mode = "none",
		bidir_dq_7_ddio_in_inst.use_clkn = "false",
		bidir_dq_7_ddio_in_inst.lpm_type = "arriaii_ddio_in";
	arriaii_ddio_out   bidir_dq_0_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[0]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[0]),
	.datainlo(bidir_dq_output_data_in_low[0]),
	.dataout(wire_bidir_dq_0_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_0_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_0_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_0_output_ddio_out_inst.power_up = "low",
		bidir_dq_0_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_0_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_0_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_1_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[1]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[1]),
	.datainlo(bidir_dq_output_data_in_low[1]),
	.dataout(wire_bidir_dq_1_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_1_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_1_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_1_output_ddio_out_inst.power_up = "low",
		bidir_dq_1_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_1_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_1_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_2_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[2]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[2]),
	.datainlo(bidir_dq_output_data_in_low[2]),
	.dataout(wire_bidir_dq_2_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_2_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_2_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_2_output_ddio_out_inst.power_up = "low",
		bidir_dq_2_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_2_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_2_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_3_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[3]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[3]),
	.datainlo(bidir_dq_output_data_in_low[3]),
	.dataout(wire_bidir_dq_3_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_3_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_3_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_3_output_ddio_out_inst.power_up = "low",
		bidir_dq_3_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_3_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_3_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_4_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[4]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[4]),
	.datainlo(bidir_dq_output_data_in_low[4]),
	.dataout(wire_bidir_dq_4_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_4_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_4_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_4_output_ddio_out_inst.power_up = "low",
		bidir_dq_4_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_4_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_4_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_5_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[5]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[5]),
	.datainlo(bidir_dq_output_data_in_low[5]),
	.dataout(wire_bidir_dq_5_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_5_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_5_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_5_output_ddio_out_inst.power_up = "low",
		bidir_dq_5_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_5_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_5_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_6_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[6]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[6]),
	.datainlo(bidir_dq_output_data_in_low[6]),
	.dataout(wire_bidir_dq_6_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_6_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_6_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_6_output_ddio_out_inst.power_up = "low",
		bidir_dq_6_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_6_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_6_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   bidir_dq_7_output_ddio_out_inst
	( 
	.areset(bidir_dq_areset[7]),
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(bidir_dq_output_data_in_high[7]),
	.datainlo(bidir_dq_output_data_in_low[7]),
	.dataout(wire_bidir_dq_7_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		bidir_dq_7_output_ddio_out_inst.async_mode = "clear",
		bidir_dq_7_output_ddio_out_inst.half_rate_mode = "false",
		bidir_dq_7_output_ddio_out_inst.power_up = "low",
		bidir_dq_7_output_ddio_out_inst.sync_mode = "none",
		bidir_dq_7_output_ddio_out_inst.use_new_clocking_model = "true",
		bidir_dq_7_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   dqs_0_output_ddio_out_inst
	( 
	.clkhi(dqs_output_reg_clk),
	.clklo(dqs_output_reg_clk),
	.datainhi(dqs_output_data_in_high[0]),
	.datainlo(dqs_output_data_in_low[0]),
	.dataout(wire_dqs_0_output_ddio_out_inst_dataout),
	.muxsel(dqs_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		dqs_0_output_ddio_out_inst.async_mode = "none",
		dqs_0_output_ddio_out_inst.half_rate_mode = "false",
		dqs_0_output_ddio_out_inst.sync_mode = "none",
		dqs_0_output_ddio_out_inst.use_new_clocking_model = "true",
		dqs_0_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_ddio_out   output_dq_0_output_ddio_out_inst
	( 
	.clkhi(dq_output_reg_clk),
	.clklo(dq_output_reg_clk),
	.datainhi(output_dq_output_data_in_high[0]),
	.datainlo(output_dq_output_data_in_low[0]),
	.dataout(wire_output_dq_0_output_ddio_out_inst_dataout),
	.muxsel(dq_output_reg_clk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clk(1'b0),
	.ena(1'b1),
	.sreset(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1),
	.dffhi(),
	.dfflo()
	// synopsys translate_on
	);
	defparam
		output_dq_0_output_ddio_out_inst.async_mode = "clear",
		output_dq_0_output_ddio_out_inst.half_rate_mode = "false",
		output_dq_0_output_ddio_out_inst.sync_mode = "none",
		output_dq_0_output_ddio_out_inst.use_new_clocking_model = "true",
		output_dq_0_output_ddio_out_inst.lpm_type = "arriaii_ddio_out";
	arriaii_dqs_delay_chain   dqs_0_delay_chain_inst
	( 
	.delayctrlin(dll_delayctrlin),
	.dqsbusout(wire_dqs_0_delay_chain_inst_dqsbusout),
	.dqsin(dqs_input_data_in[0])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.dqsupdateen(1'b0),
	.offsetctrlin({6{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		dqs_0_delay_chain_inst.delay_buffer_mode = "high",
		dqs_0_delay_chain_inst.dqs_ctrl_latches_enable = "false",
		dqs_0_delay_chain_inst.dqs_input_frequency = "300.0 MHz",
		dqs_0_delay_chain_inst.dqs_offsetctrl_enable = "false",
		dqs_0_delay_chain_inst.dqs_phase_shift = 7200,
		dqs_0_delay_chain_inst.phase_setting = 2,
		dqs_0_delay_chain_inst.lpm_type = "arriaii_dqs_delay_chain";
	arriaii_dqs_enable   dqs_0_enable_inst
	( 
	.dqsbusout(wire_dqs_0_enable_inst_dqsbusout),
	.dqsenable(wire_dqs_0_enable_ctrl_inst_dqsenableout),
	.dqsin(wire_dqs_0_delay_chain_inst_dqsbusout)
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	arriaii_dqs_enable_ctrl   dqs_0_enable_ctrl_inst
	( 
	.clk(dqs_enable_ctrl_clk),
	.dqsenablein(dqs_enable_ctrl_in),
	.dqsenableout(wire_dqs_0_enable_ctrl_inst_dqsenableout)
	// synopsys translate_off
	,
	.devclrn(1'b1),
	.devpor(1'b1)
	// synopsys translate_on
	);
	defparam
		dqs_0_enable_ctrl_inst.delay_dqs_enable_by_half_cycle = "true",
		dqs_0_enable_ctrl_inst.lpm_type = "arriaii_dqs_enable_ctrl";
	assign
		bidir_dq_input_data_out_high = {wire_bidir_dq_7_ddio_in_inst_regouthi, wire_bidir_dq_6_ddio_in_inst_regouthi, wire_bidir_dq_5_ddio_in_inst_regouthi, wire_bidir_dq_4_ddio_in_inst_regouthi, wire_bidir_dq_3_ddio_in_inst_regouthi, wire_bidir_dq_2_ddio_in_inst_regouthi, wire_bidir_dq_1_ddio_in_inst_regouthi, wire_bidir_dq_0_ddio_in_inst_regouthi},
		bidir_dq_input_data_out_low = {wire_bidir_dq_7_ddio_in_inst_regoutlo, wire_bidir_dq_6_ddio_in_inst_regoutlo, wire_bidir_dq_5_ddio_in_inst_regoutlo, wire_bidir_dq_4_ddio_in_inst_regoutlo, wire_bidir_dq_3_ddio_in_inst_regoutlo, wire_bidir_dq_2_ddio_in_inst_regoutlo, wire_bidir_dq_1_ddio_in_inst_regoutlo, wire_bidir_dq_0_ddio_in_inst_regoutlo},
		bidir_dq_oe_out = {(~ bidir_dq_7_oe_ff_inst), (~ bidir_dq_6_oe_ff_inst), (~ bidir_dq_5_oe_ff_inst), (~ bidir_dq_4_oe_ff_inst), (~ bidir_dq_3_oe_ff_inst), (~ bidir_dq_2_oe_ff_inst), (~ bidir_dq_1_oe_ff_inst), (~ bidir_dq_0_oe_ff_inst)},
		bidir_dq_output_data_out = {wire_bidir_dq_7_output_ddio_out_inst_dataout, wire_bidir_dq_6_output_ddio_out_inst_dataout, wire_bidir_dq_5_output_ddio_out_inst_dataout, wire_bidir_dq_4_output_ddio_out_inst_dataout, wire_bidir_dq_3_output_ddio_out_inst_dataout, wire_bidir_dq_2_output_ddio_out_inst_dataout, wire_bidir_dq_1_output_ddio_out_inst_dataout, wire_bidir_dq_0_output_ddio_out_inst_dataout},
		dqs_bus_wire = {wire_dqs_0_enable_inst_dqsbusout},
		dqs_oe_out = {(~ dqs_0_oe_ff_inst)},
		dqs_output_data_out = {wire_dqs_0_output_ddio_out_inst_dataout},
		dqsn_oe_out = {(~ dqsn_0_oe_ff_inst)},
		output_dq_oe_out = {(~ output_dq_0_oe_ff_inst)},
		output_dq_output_data_out = {wire_output_dq_0_output_ddio_out_inst_dataout};
endmodule //ddr3_int_phy_alt_mem_phy_dq_dqs
//VALID FILE
