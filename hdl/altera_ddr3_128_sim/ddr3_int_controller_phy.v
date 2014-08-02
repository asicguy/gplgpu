//Legal Notice: (C)2011 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ps / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ddr3_int_controller_phy (
                                 // inputs:
                                  dqs_delay_ctrl_import,
                                  dqs_offset_delay_ctrl,
                                  global_reset_n,
                                  hc_scan_ck,
                                  hc_scan_din,
                                  hc_scan_enable_access,
                                  hc_scan_enable_dm,
                                  hc_scan_enable_dq,
                                  hc_scan_enable_dqs,
                                  hc_scan_enable_dqs_config,
                                  hc_scan_update,
                                  local_address,
                                  local_autopch_req,
                                  local_be,
                                  local_burstbegin,
                                  local_multicast_req,
                                  local_read_req,
                                  local_refresh_chip,
                                  local_refresh_req,
                                  local_self_rfsh_req,
                                  local_size,
                                  local_wdata,
                                  local_write_req,
                                  oct_ctl_rs_value,
                                  oct_ctl_rt_value,
                                  pll_phasecounterselect,
                                  pll_phasestep,
                                  pll_phaseupdown,
                                  pll_reconfig,
                                  pll_reconfig_counter_param,
                                  pll_reconfig_counter_type,
                                  pll_reconfig_data_in,
                                  pll_reconfig_enable,
                                  pll_reconfig_read_param,
                                  pll_reconfig_soft_reset_en_n,
                                  pll_reconfig_write_param,
                                  pll_ref_clk,
                                  soft_reset_n,

                                 // outputs:
                                  aux_full_rate_clk,
                                  aux_half_rate_clk,
                                  aux_scan_clk,
                                  aux_scan_clk_reset_n,
                                  dll_reference_clk,
                                  dqs_delay_ctrl_export,
                                  ecc_interrupt,
                                  hc_scan_dout,
                                  local_init_done,
                                  local_power_down_ack,
                                  local_rdata,
                                  local_rdata_error,
                                  local_rdata_valid,
                                  local_ready,
                                  local_refresh_ack,
                                  local_self_rfsh_ack,
                                  local_wdata_req,
                                  mem_addr,
                                  mem_ba,
                                  mem_cas_n,
                                  mem_cke,
                                  mem_clk,
                                  mem_clk_n,
                                  mem_cs_n,
                                  mem_dm,
                                  mem_dq,
                                  mem_dqs,
                                  mem_dqsn,
                                  mem_odt,
                                  mem_ras_n,
                                  mem_reset_n,
                                  mem_we_n,
                                  phy_clk,
                                  pll_phase_done,
                                  pll_reconfig_busy,
                                  pll_reconfig_clk,
                                  pll_reconfig_data_out,
                                  pll_reconfig_reset,
                                  reset_phy_clk_n,
                                  reset_request_n
                               )
;

  output           aux_full_rate_clk;
  output           aux_half_rate_clk;
  output           aux_scan_clk;
  output           aux_scan_clk_reset_n;
  output           dll_reference_clk;
  output  [  5: 0] dqs_delay_ctrl_export;
  output           ecc_interrupt;
  output  [ 31: 0] hc_scan_dout;
  output           local_init_done;
  output           local_power_down_ack;
  output  [127: 0] local_rdata;
  output           local_rdata_error;
  output           local_rdata_valid;
  output           local_ready;
  output           local_refresh_ack;
  output           local_self_rfsh_ack;
  output           local_wdata_req;
  output  [ 13: 0] mem_addr;
  output  [  2: 0] mem_ba;
  output           mem_cas_n;
  output  [  0: 0] mem_cke;
  inout   [  0: 0] mem_clk;
  inout   [  0: 0] mem_clk_n;
  output  [  0: 0] mem_cs_n;
  output  [  3: 0] mem_dm;
  inout   [ 31: 0] mem_dq;
  inout   [  3: 0] mem_dqs;
  inout   [  3: 0] mem_dqsn;
  output  [  0: 0] mem_odt;
  output           mem_ras_n;
  output           mem_reset_n;
  output           mem_we_n;
  output           phy_clk;
  output           pll_phase_done;
  output           pll_reconfig_busy;
  output           pll_reconfig_clk;
  output  [  8: 0] pll_reconfig_data_out;
  output           pll_reconfig_reset;
  output           reset_phy_clk_n;
  output           reset_request_n;
  input   [  5: 0] dqs_delay_ctrl_import;
  input   [  5: 0] dqs_offset_delay_ctrl;
  input            global_reset_n;
  input            hc_scan_ck;
  input   [  3: 0] hc_scan_din;
  input            hc_scan_enable_access;
  input   [  3: 0] hc_scan_enable_dm;
  input   [ 31: 0] hc_scan_enable_dq;
  input   [  3: 0] hc_scan_enable_dqs;
  input   [  3: 0] hc_scan_enable_dqs_config;
  input   [  3: 0] hc_scan_update;
  input   [ 24: 0] local_address;
  input            local_autopch_req;
  input   [ 15: 0] local_be;
  input            local_burstbegin;
  input            local_multicast_req;
  input            local_read_req;
  input            local_refresh_chip;
  input            local_refresh_req;
  input            local_self_rfsh_req;
  input   [  5: 0] local_size;
  input   [127: 0] local_wdata;
  input            local_write_req;
  input   [ 13: 0] oct_ctl_rs_value;
  input   [ 13: 0] oct_ctl_rt_value;
  input   [  3: 0] pll_phasecounterselect;
  input            pll_phasestep;
  input            pll_phaseupdown;
  input            pll_reconfig;
  input   [  2: 0] pll_reconfig_counter_param;
  input   [  3: 0] pll_reconfig_counter_type;
  input   [  8: 0] pll_reconfig_data_in;
  input            pll_reconfig_enable;
  input            pll_reconfig_read_param;
  input            pll_reconfig_soft_reset_en_n;
  input            pll_reconfig_write_param;
  input            pll_ref_clk;
  input            soft_reset_n;

  wire    [ 27: 0] afi_addr;
  wire    [  5: 0] afi_ba;
  wire    [  1: 0] afi_cas_n;
  wire    [  1: 0] afi_cke;
  wire    [  1: 0] afi_cs_n;
  wire    [ 15: 0] afi_dm;
  wire    [  7: 0] afi_doing_rd;
  wire    [  7: 0] afi_dqs_burst;
  wire    [  1: 0] afi_odt;
  wire    [  1: 0] afi_ras_n;
  wire    [127: 0] afi_rdata;
  wire    [  1: 0] afi_rdata_valid;
  wire    [  1: 0] afi_rst_n;
  wire    [127: 0] afi_wdata;
  wire    [  7: 0] afi_wdata_valid;
  wire    [  1: 0] afi_we_n;
  wire    [  4: 0] afi_wlat;
  wire             aux_full_rate_clk;
  wire             aux_half_rate_clk;
  wire             aux_scan_clk;
  wire             aux_scan_clk_reset_n;
  wire    [ 31: 0] csr_rdata_sig;
  wire             csr_rdata_valid_sig;
  wire             csr_waitrequest_sig;
  wire    [  3: 0] ctl_cal_byte_lane_sel_n;
  wire             ctl_cal_fail;
  wire             ctl_cal_req;
  wire             ctl_cal_success;
  wire             ctl_clk;
  wire             ctl_mem_clk_disable;
  wire    [  4: 0] ctl_rlat;
  wire    [ 31: 0] dbg_rd_data_sig;
  wire             dbg_waitrequest_sig;
  wire             dll_reference_clk;
  wire    [  5: 0] dqs_delay_ctrl_export;
  wire             ecc_interrupt;
  wire    [ 31: 0] hc_scan_dout;
  wire             local_init_done;
  wire             local_power_down_ack;
  wire    [127: 0] local_rdata;
  wire             local_rdata_error;
  wire             local_rdata_valid;
  wire             local_ready;
  wire             local_refresh_ack;
  wire             local_self_rfsh_ack;
  wire             local_wdata_req;
  wire    [ 13: 0] mem_addr;
  wire    [  2: 0] mem_ba;
  wire             mem_cas_n;
  wire    [  0: 0] mem_cke;
  wire    [  0: 0] mem_clk;
  wire    [  0: 0] mem_clk_n;
  wire    [  0: 0] mem_cs_n;
  wire    [  3: 0] mem_dm;
  wire    [ 31: 0] mem_dq;
  wire    [  3: 0] mem_dqs;
  wire    [  3: 0] mem_dqsn;
  wire    [  0: 0] mem_odt;
  wire             mem_ras_n;
  wire             mem_reset_n;
  wire             mem_we_n;
  wire             phy_clk;
  wire             pll_phase_done;
  wire             pll_reconfig_busy;
  wire             pll_reconfig_clk;
  wire    [  8: 0] pll_reconfig_data_out;
  wire             pll_reconfig_reset;
  wire             reset_ctl_clk_n;
  wire             reset_phy_clk_n;
  wire             reset_request_n;
  assign phy_clk = ctl_clk;
  assign reset_phy_clk_n = reset_ctl_clk_n;
  ddr3_int_alt_ddrx_controller_wrapper ddr3_int_alt_ddrx_controller_wrapper_inst
    (
      .afi_addr (afi_addr),
      .afi_ba (afi_ba),
      .afi_cas_n (afi_cas_n),
      .afi_cke (afi_cke),
      .afi_cs_n (afi_cs_n),
      .afi_dm (afi_dm),
      .afi_doing_read (afi_doing_rd),
      .afi_dqs_burst (afi_dqs_burst),
      .afi_odt (afi_odt),
      .afi_ras_n (afi_ras_n),
      .afi_rdata (afi_rdata),
      .afi_rdata_valid (afi_rdata_valid),
      .afi_rst_n (afi_rst_n),
      .afi_wdata (afi_wdata),
      .afi_wdata_valid (afi_wdata_valid),
      .afi_we_n (afi_we_n),
      .afi_wlat (afi_wlat),
      .csr_addr (16'b0),
      .csr_be (4'b0),
      .csr_rdata (csr_rdata_sig),
      .csr_rdata_valid (csr_rdata_valid_sig),
      .csr_read_req (1'b0),
      .csr_waitrequest (csr_waitrequest_sig),
      .csr_wdata (32'b0),
      .csr_write_req (1'b0),
      .ctl_cal_byte_lane_sel_n (ctl_cal_byte_lane_sel_n),
      .ctl_cal_fail (ctl_cal_fail),
      .ctl_cal_req (ctl_cal_req),
      .ctl_cal_success (ctl_cal_success),
      .ctl_clk (ctl_clk),
      .ctl_half_clk (aux_half_rate_clk),
      .ctl_half_clk_reset_n (reset_ctl_clk_n),
      .ctl_mem_clk_disable (ctl_mem_clk_disable),
      .ctl_reset_n (reset_ctl_clk_n),
      .ecc_interrupt (ecc_interrupt),
      .local_addr (local_address),
      .local_autopch_req (local_autopch_req),
      .local_be (local_be),
      .local_burstbegin (local_burstbegin),
      .local_init_done (local_init_done),
      .local_multicast (local_multicast_req),
      .local_power_down_ack (local_power_down_ack),
      .local_rdata (local_rdata),
      .local_rdata_error (local_rdata_error),
      .local_rdata_valid (local_rdata_valid),
      .local_read_req (local_read_req),
      .local_ready (local_ready),
      .local_refresh_ack (local_refresh_ack),
      .local_refresh_chip (local_refresh_chip),
      .local_refresh_req (local_refresh_req),
      .local_self_rfsh_ack (local_self_rfsh_ack),
      .local_self_rfsh_chip ({1{1'b1}}),
      .local_self_rfsh_req (local_self_rfsh_req),
      .local_size (local_size),
      .local_wdata (local_wdata),
      .local_wdata_req (local_wdata_req),
      .local_write_req (local_write_req)
    );


  ddr3_int_phy ddr3_int_phy_inst
    (
      .aux_full_rate_clk (aux_full_rate_clk),
      .aux_half_rate_clk (aux_half_rate_clk),
      .ctl_addr (afi_addr),
      .ctl_ba (afi_ba),
      .ctl_cal_byte_lane_sel_n (ctl_cal_byte_lane_sel_n),
      .ctl_cal_fail (ctl_cal_fail),
      .ctl_cal_req (ctl_cal_req),
      .ctl_cal_success (ctl_cal_success),
      .ctl_cas_n (afi_cas_n),
      .ctl_cke (afi_cke),
      .ctl_clk (ctl_clk),
      .ctl_cs_n (afi_cs_n),
      .ctl_dm (afi_dm),
      .ctl_doing_rd (afi_doing_rd),
      .ctl_dqs_burst (afi_dqs_burst),
      .ctl_mem_clk_disable (ctl_mem_clk_disable),
      .ctl_odt (afi_odt),
      .ctl_ras_n (afi_ras_n),
      .ctl_rdata (afi_rdata),
      .ctl_rdata_valid (afi_rdata_valid),
      .ctl_reset_n (reset_ctl_clk_n),
      .ctl_rlat (ctl_rlat),
      .ctl_rst_n (afi_rst_n),
      .ctl_wdata (afi_wdata),
      .ctl_wdata_valid (afi_wdata_valid),
      .ctl_we_n (afi_we_n),
      .ctl_wlat (afi_wlat),
      .dbg_addr (13'b0),
      .dbg_clk (ctl_clk),
      .dbg_cs (1'b0),
      .dbg_rd (1'b0),
      .dbg_rd_data (dbg_rd_data_sig),
      .dbg_reset_n (reset_ctl_clk_n),
      .dbg_waitrequest (dbg_waitrequest_sig),
      .dbg_wr (1'b0),
      .dbg_wr_data (32'b0),
      .dll_reference_clk (dll_reference_clk),
      .dqs_delay_ctrl_export (dqs_delay_ctrl_export),
      .dqs_delay_ctrl_import (dqs_delay_ctrl_import),
      .dqs_offset_delay_ctrl (dqs_offset_delay_ctrl),
      .global_reset_n (global_reset_n),
      .mem_addr (mem_addr),
      .mem_ba (mem_ba),
      .mem_cas_n (mem_cas_n),
      .mem_cke (mem_cke),
      .mem_clk (mem_clk),
      .mem_clk_n (mem_clk_n),
      .mem_cs_n (mem_cs_n),
      .mem_dm (mem_dm[3 : 0]),
      .mem_dq (mem_dq),
      .mem_dqs (mem_dqs[3 : 0]),
      .mem_dqs_n (mem_dqsn[3 : 0]),
      .mem_odt (mem_odt),
      .mem_ras_n (mem_ras_n),
      .mem_reset_n (mem_reset_n),
      .mem_we_n (mem_we_n),
      .oct_ctl_rs_value (oct_ctl_rs_value),
      .oct_ctl_rt_value (oct_ctl_rt_value),
      .pll_ref_clk (pll_ref_clk),
      .reset_request_n (reset_request_n),
      .soft_reset_n (soft_reset_n)
    );


  //<< start europa

endmodule

