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


entity    stratixv_hssi_gen3_pcie_hip    is
    generic    (
        func_mode    :    string    :=    "disable";
        in_cvp_mode  : string := "not_cvp_mode";
        bonding_mode    :    string    :=    "bond_disable";
        prot_mode    :    string    :=    "disabled_prot_mode";
        pcie_spec_1p0_compliance    :    string    :=    "spec_1p1";
        vc_enable    :    string    :=    "single_vc";
        enable_slot_register    :    string    :=    "false";
        pcie_mode    :    string    :=    "shared_mode";
        bypass_cdc    :    string    :=    "false";
        enable_rx_reordering    :    string    :=    "true";
        enable_rx_buffer_checking    :    string    :=    "false";
        single_rx_detect_data    :    bit_vector    :=    B"0000";
        single_rx_detect    :    string    :=    "single_rx_detect";
        use_crc_forwarding    :    string    :=    "false";
        bypass_tl    :    string    :=    "false";
        gen123_lane_rate_mode    :    string    :=    "gen1";
        lane_mask    :    string    :=    "x4";
        disable_link_x2_support    :    string    :=    "false";
        national_inst_thru_enhance    :    string    :=    "true";
        hip_hard_reset    :    string    :=    "enable";
        dis_paritychk    :    string    :=    "enable";
        wrong_device_id    :    string    :=    "disable";
        data_pack_rx    :    string    :=    "disable";
        ast_width    :    string    :=    "rx_tx_64";
        rx_sop_ctrl    :    string    :=    "boundary_64";
        rx_ast_parity    :    string    :=    "disable";
        tx_ast_parity    :    string    :=    "disable";
        ltssm_1ms_timeout    :    string    :=    "disable";
        ltssm_freqlocked_check    :    string    :=    "disable";
        deskew_comma    :    string    :=    "skp_eieos_deskw";
        dl_tx_check_parity_edb    :    string    :=    "disable";
        tl_tx_check_parity_msg    :    string    :=    "disable";
        port_link_number_data    :    bit_vector    :=    B"00000001";
        port_link_number    :    string    :=    "port_link_number";
        device_number_data    :    bit_vector    :=    B"00000";
        device_number    :    string    :=    "device_number";
        bypass_clk_switch    :    string    :=    "false";
        core_clk_out_sel    :    string    :=    "div_1";
        core_clk_divider    :    string    :=    "div_1";
        core_clk_source    :    string    :=    "pll_fixed_clk";
        core_clk_sel    :    string    :=    "pld_clk";
        enable_ch0_pclk_out    :    string    :=    "true";
        enable_ch01_pclk_out    :    string    :=    "pclk_ch0";
        pipex1_debug_sel    :    string    :=    "disable";
        pclk_out_sel    :    string    :=    "pclk";
        vendor_id_data    :    bit_vector    :=    B"1000101110010";
        vendor_id    :    string    :=    "vendor_id";
        device_id_data    :    bit_vector    :=    B"0000000000000001";
        device_id    :    string    :=    "device_id";
        revision_id_data    :    bit_vector    :=    B"00000001";
        revision_id    :    string    :=    "revision_id";
        class_code_data    :    bit_vector    :=    B"111111110000000000000000";
        class_code    :    string    :=    "class_code";
        subsystem_vendor_id_data    :    bit_vector    :=    B"0001000101110010";
        subsystem_vendor_id    :    string    :=    "subsystem_vendor_id";
        subsystem_device_id_data    :    bit_vector    :=    B"0000000000000001";
        subsystem_device_id    :    string    :=    "subsystem_device_id";
        no_soft_reset    :    string    :=    "false";
        maximum_current_data    :    bit_vector    :=    B"000";
        maximum_current    :    string    :=    "maximum_current";
        d1_support    :    string    :=    "false";
        d2_support    :    string    :=    "false";
        d0_pme    :    string    :=    "false";
        d1_pme    :    string    :=    "false";
        d2_pme    :    string    :=    "false";
        d3_hot_pme    :    string    :=    "false";
        d3_cold_pme    :    string    :=    "false";
        use_aer    :    string    :=    "false";
        low_priority_vc    :    string    :=    "single_vc";
        vc_arbitration    :    string    :=    "single_vc";
        disable_snoop_packet    :    string    :=    "false";
        max_payload_size    :    string    :=    "payload_512";
        surprise_down_error_support    :    string    :=    "false";
        dll_active_report_support    :    string    :=    "false";
        extend_tag_field    :    string    :=    "false";
        endpoint_l0_latency_data    :    bit_vector    :=    B"000";
        endpoint_l0_latency    :    string    :=    "endpoint_l0_latency";
        endpoint_l1_latency_data    :    bit_vector    :=    B"000";
        endpoint_l1_latency    :    string    :=    "endpoint_l1_latency";
        indicator_data    :    bit_vector    :=    B"111";
        indicator    :    string    :=    "indicator";
        role_based_error_reporting    :    string    :=    "false";
        slot_power_scale_data    :    bit_vector    :=    B"00";
        slot_power_scale    :    string    :=    "slot_power_scale";
        max_link_width    :    string    :=    "x4";
        enable_l1_aspm    :    string    :=    "false";
        enable_l0s_aspm    :    string    :=    "false";
        l1_exit_latency_sameclock_data    :    bit_vector    :=    B"000";
        l1_exit_latency_sameclock    :    string    :=    "l1_exit_latency_sameclock";
        l1_exit_latency_diffclock_data    :    bit_vector    :=    B"000";
        l1_exit_latency_diffclock    :    string    :=    "l1_exit_latency_diffclock";
        hot_plug_support_data    :    bit_vector    :=    B"0000000";
        hot_plug_support    :    string    :=    "hot_plug_support";
        slot_power_limit_data    :    bit_vector    :=    B"00000000";
        slot_power_limit    :    string    :=    "slot_power_limit";
        slot_number_data    :    bit_vector    :=    B"0000000000000";
        slot_number    :    string    :=    "slot_number";
        diffclock_nfts_count_data    :    bit_vector    :=    B"00000000";
        diffclock_nfts_count    :    string    :=    "diffclock_nfts_count";
        sameclock_nfts_count_data    :    bit_vector    :=    B"00000000";
        sameclock_nfts_count    :    string    :=    "sameclock_nfts_count";
        completion_timeout    :    string    :=    "abcd";
        enable_completion_timeout_disable    :    string    :=    "true";
        extended_tag_reset    :    string    :=    "false";
        ecrc_check_capable    :    string    :=    "true";
        ecrc_gen_capable    :    string    :=    "true";
        no_command_completed    :    string    :=    "true";
        msi_multi_message_capable    :    string    :=    "count_4";
        msi_64bit_addressing_capable    :    string    :=    "true";
        msi_masking_capable    :    string    :=    "false";
        msi_support    :    string    :=    "true";
        interrupt_pin    :    string    :=    "inta";
        ena_ido_req    :    string    :=    "false";
        ena_ido_cpl    :    string    :=    "false";
        enable_function_msix_support    :    string    :=    "true";
        msix_table_size_data    :    bit_vector    :=    B"00000000000";
        msix_table_size    :    string    :=    "msix_table_size";
        msix_table_bir_data    :    bit_vector    :=    B"000";
        msix_table_bir    :    string    :=    "msix_table_bir";
        msix_table_offset_data    :    bit_vector    :=    B"00000000000000000000000000000";
        msix_table_offset    :    string    :=    "msix_table_offset";
        msix_pba_bir_data    :    bit_vector    :=    B"000";
        msix_pba_bir    :    string    :=    "msix_pba_bir";
        msix_pba_offset_data    :    bit_vector    :=    B"00000000000000000000000000000";
        msix_pba_offset    :    string    :=    "msix_pba_offset";
        bridge_port_vga_enable    :    string    :=    "false";
        bridge_port_ssid_support    :    string    :=    "false";
        ssvid_data    :    bit_vector    :=    B"0000000000000000";
        ssvid    :    string    :=    "ssvid";
        ssid_data    :    bit_vector    :=    B"0000000000000000";
        ssid    :    string    :=    "ssid";
        eie_before_nfts_count_data    :    bit_vector    :=    B"0100";
        eie_before_nfts_count    :    string    :=    "eie_before_nfts_count";
        gen2_diffclock_nfts_count_data    :    bit_vector    :=    B"11111111";
        gen2_diffclock_nfts_count    :    string    :=    "gen2_diffclock_nfts_count";
        gen2_sameclock_nfts_count_data    :    bit_vector    :=    B"11111111";
        gen2_sameclock_nfts_count    :    string    :=    "gen2_sameclock_nfts_count";
        deemphasis_enable    :    string    :=    "false";
        pcie_spec_version    :    string    :=    "v2";
        l0_exit_latency_sameclock_data    :    bit_vector    :=    B"110";
        l0_exit_latency_sameclock    :    string    :=    "l0_exit_latency_sameclock";
        l0_exit_latency_diffclock_data    :    bit_vector    :=    B"110";
        l0_exit_latency_diffclock    :    string    :=    "l0_exit_latency_diffclock";
        rx_ei_l0s    :    string    :=    "disable";
        l2_async_logic    :    string    :=    "enable";
        aspm_config_management    :    string    :=    "true";
        atomic_op_routing    :    string    :=    "false";
        atomic_op_completer_32bit    :    string    :=    "false";
        atomic_op_completer_64bit    :    string    :=    "false";
        cas_completer_128bit    :    string    :=    "false";
        ltr_mechanism    :    string    :=    "false";
        tph_completer    :    string    :=    "false";
        extended_format_field    :    string    :=    "true";
        atomic_malformed    :    string    :=    "false";
        flr_capability    :    string    :=    "true";
        enable_adapter_half_rate_mode    :    string    :=    "false";
        vc0_clk_enable    :    string    :=    "true";
        vc1_clk_enable    :    string    :=    "false";
        register_pipe_signals    :    string    :=    "false";
        bar0_io_space    :    string    :=    "false";
        bar0_64bit_mem_space    :    string    :=    "true";
        bar0_prefetchable    :    string    :=    "true";
        bar0_size_mask_data    :    bit_vector    :=    B"1111111111111111111111111111";
        bar0_size_mask    :    string    :=    "bar0_size_mask";
        bar1_io_space    :    string    :=    "false";
        bar1_64bit_mem_space    :    string    :=    "false";
        bar1_prefetchable    :    string    :=    "false";
        bar1_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar1_size_mask    :    string    :=    "bar1_size_mask";
        bar2_io_space    :    string    :=    "false";
        bar2_64bit_mem_space    :    string    :=    "false";
        bar2_prefetchable    :    string    :=    "false";
        bar2_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar2_size_mask    :    string    :=    "bar2_size_mask";
        bar3_io_space    :    string    :=    "false";
        bar3_64bit_mem_space    :    string    :=    "false";
        bar3_prefetchable    :    string    :=    "false";
        bar3_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar3_size_mask    :    string    :=    "bar3_size_mask";
        bar4_io_space    :    string    :=    "false";
        bar4_64bit_mem_space    :    string    :=    "false";
        bar4_prefetchable    :    string    :=    "false";
        bar4_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar4_size_mask    :    string    :=    "bar4_size_mask";
        bar5_io_space    :    string    :=    "false";
        bar5_64bit_mem_space    :    string    :=    "false";
        bar5_prefetchable    :    string    :=    "false";
        bar5_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar5_size_mask    :    string    :=    "bar5_size_mask";
        expansion_base_address_register_data    :    bit_vector    :=    B"00000000000000000000000000000000";
        expansion_base_address_register    :    string    :=    "expansion_base_address_register";
        io_window_addr_width    :    string    :=    "window_32_bit";
        prefetchable_mem_window_addr_width    :    string    :=    "prefetch_32";
        skp_os_gen3_count_data    :    bit_vector    :=    B"00000000000";
        skp_os_gen3_count    :    string    :=    "skp_os_gen3_count";
        rx_cdc_almost_empty_data    :    bit_vector    :=    B"0000";
        rx_cdc_almost_empty    :    string    :=    "rx_cdc_almost_empty";
        tx_cdc_almost_empty_data    :    bit_vector    :=    B"0000";
        tx_cdc_almost_empty    :    string    :=    "tx_cdc_almost_empty";
        rx_cdc_almost_full_data    :    bit_vector    :=    B"0000";
        rx_cdc_almost_full    :    string    :=    "rx_cdc_almost_full";
        tx_cdc_almost_full_data    :    bit_vector    :=    B"0000";
        tx_cdc_almost_full    :    string    :=    "tx_cdc_almost_full";
        rx_l0s_count_idl_data    :    bit_vector    :=    B"00000000";
        rx_l0s_count_idl    :    string    :=    "rx_l0s_count_idl";
        cdc_dummy_insert_limit_data    :    bit_vector    :=    B"0000";
        cdc_dummy_insert_limit    :    string    :=    "cdc_dummy_insert_limit";
        ei_delay_powerdown_count_data    :    bit_vector    :=    B"00001010";
        ei_delay_powerdown_count    :    string    :=    "ei_delay_powerdown_count";
        millisecond_cycle_count_data    :    bit_vector    :=    B"00000000000000000000";
        millisecond_cycle_count    :    string    :=    "millisecond_cycle_count";
        skp_os_schedule_count_data    :    bit_vector    :=    B"00000000000";
        skp_os_schedule_count    :    string    :=    "skp_os_schedule_count";
        fc_init_timer_data    :    bit_vector    :=    B"10000000000";
        fc_init_timer    :    string    :=    "fc_init_timer";
        l01_entry_latency_data    :    bit_vector    :=    B"11111";
        l01_entry_latency    :    string    :=    "l01_entry_latency";
        flow_control_update_count_data    :    bit_vector    :=    B"11110";
        flow_control_update_count    :    string    :=    "flow_control_update_count";
        flow_control_timeout_count_data    :    bit_vector    :=    B"11001000";
        flow_control_timeout_count    :    string    :=    "flow_control_timeout_count";
        vc0_rx_flow_ctrl_posted_header_data    :    bit_vector    :=    B"00110010";
        vc0_rx_flow_ctrl_posted_header    :    string    :=    "vc0_rx_flow_ctrl_posted_header";
        vc0_rx_flow_ctrl_posted_data_data    :    bit_vector    :=    B"000101101000";
        vc0_rx_flow_ctrl_posted_data    :    string    :=    "vc0_rx_flow_ctrl_posted_data";
        vc0_rx_flow_ctrl_nonposted_header_data    :    bit_vector    :=    B"00110110";
        vc0_rx_flow_ctrl_nonposted_header    :    string    :=    "vc0_rx_flow_ctrl_nonposted_header";
        vc0_rx_flow_ctrl_nonposted_data_data    :    bit_vector    :=    B"00000000";
        vc0_rx_flow_ctrl_nonposted_data    :    string    :=    "vc0_rx_flow_ctrl_nonposted_data";
        vc0_rx_flow_ctrl_compl_header_data    :    bit_vector    :=    B"01110000";
        vc0_rx_flow_ctrl_compl_header    :    string    :=    "vc0_rx_flow_ctrl_compl_header";
        vc0_rx_flow_ctrl_compl_data_data    :    bit_vector    :=    B"000111000000";
        vc0_rx_flow_ctrl_compl_data    :    string    :=    "vc0_rx_flow_ctrl_compl_data";
        rx_ptr0_posted_dpram_min_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_posted_dpram_min    :    string    :=    "rx_ptr0_posted_dpram_min";
        rx_ptr0_posted_dpram_max_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_posted_dpram_max    :    string    :=    "rx_ptr0_posted_dpram_max";
        rx_ptr0_nonposted_dpram_min_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_nonposted_dpram_min    :    string    :=    "rx_ptr0_nonposted_dpram_min";
        rx_ptr0_nonposted_dpram_max_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_nonposted_dpram_max    :    string    :=    "rx_ptr0_nonposted_dpram_max";
        retry_buffer_last_active_address_data    :    bit_vector    :=    B"1111111111";
        retry_buffer_last_active_address    :    string    :=    "retry_buffer_last_active_address";
        retry_buffer_memory_settings_data    :    bit_vector    :=    B"000000000000000000000000000000";
        retry_buffer_memory_settings    :    string    :=    "retry_buffer_memory_settings";
        vc0_rx_buffer_memory_settings_data    :    bit_vector    :=    B"000000000000000000000000000000";
        vc0_rx_buffer_memory_settings    :    string    :=    "vc0_rx_buffer_memory_settings";
        bist_memory_settings_data    :    bit_vector    :=    B"000000000000000000000000000000000000000000000000000000000000000000000000000";
        bist_memory_settings    :    string    :=    "bist_memory_settings";
        credit_buffer_allocation_aux    :    string    :=    "balanced";
        iei_enable_settings    :    string    :=    "gen2_infei_infsd_gen1_infei_sd";
        vsec_id_data    :    bit_vector    :=    B"0001000101110010";
        vsec_id    :    string    :=    "vsec_id";
        cvp_rate_sel    :    string    :=    "full_rate";
        hard_reset_bypass    :    string    :=    "false";
        cvp_data_compressed    :    string    :=    "false";
        cvp_data_encrypted    :    string    :=    "false";
        cvp_mode_reset    :    string    :=    "false";
        cvp_clk_reset    :    string    :=    "false";
        vsec_cap_data    :    bit_vector    :=    B"0000";
        vsec_cap    :    string    :=    "vsec_cap";
        jtag_id_data    :    bit_vector    :=    B"00000000000000000000000000000000";
        jtag_id    :    string    :=    "jtag_id";
        user_id_data    :    bit_vector    :=    B"0000000000000000";
        user_id    :    string    :=    "user_id";
        cseb_extend_pci    :    string    :=    "false";
        cseb_extend_pcie    :    string    :=    "false";
        cseb_cpl_status_during_cvp    :    string    :=    "config_retry_status";
        cseb_route_to_avl_rx_st    :    string    :=    "cseb";
        cseb_config_bypass    :    string    :=    "disable";
        cseb_cpl_tag_checking    :    string    :=    "enable";
        cseb_bar_match_checking    :    string    :=    "enable";
        cseb_min_error_checking    :    string    :=    "false";
        cseb_temp_busy_crs    :    string    :=    "completer_abort";
        cseb_disable_auto_crs    :    string    :=    "false";
        gen3_diffclock_nfts_count_data    :    bit_vector    :=    B"10000000";
        gen3_diffclock_nfts_count    :    string    :=    "g3_diffclock_nfts_count";
        gen3_sameclock_nfts_count_data    :    bit_vector    :=    B"10000000";
        gen3_sameclock_nfts_count    :    string    :=    "g3_sameclock_nfts_count";
        gen3_coeff_errchk    :    string    :=    "enable";
        gen3_paritychk    :    string    :=    "enable";
        gen3_coeff_delay_count_data    :    bit_vector    :=    B"1111101";
        gen3_coeff_delay_count    :    string    :=    "g3_coeff_dly_count";
        gen3_coeff_1_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_1    :    string    :=    "g3_coeff_1";
        gen3_coeff_1_sel    :    string    :=    "coeff_1";
        gen3_coeff_1_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_1_preset_hint    :    string    :=    "g3_coeff_1_prst_hint";
        gen3_coeff_1_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_1_nxtber_more    :    string    :=    "g3_coeff_1_nxtber_more";
        gen3_coeff_1_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_1_nxtber_less    :    string    :=    "g3_coeff_1_nxtber_less";
        gen3_coeff_1_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_1_reqber    :    string    :=    "g3_coeff_1_reqber";
        gen3_coeff_1_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_1_ber_meas    :    string    :=    "g3_coeff_1_ber_meas";
        gen3_coeff_2_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_2    :    string    :=    "g3_coeff_2";
        gen3_coeff_2_sel    :    string    :=    "coeff_2";
        gen3_coeff_2_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_2_preset_hint    :    string    :=    "g3_coeff_2_prst_hint";
        gen3_coeff_2_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_2_nxtber_more    :    string    :=    "g3_coeff_2_nxtber_more";
        gen3_coeff_2_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_2_nxtber_less    :    string    :=    "g3_coeff_2_nxtber_less";
        gen3_coeff_2_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_2_reqber    :    string    :=    "g3_coeff_2_reqber";
        gen3_coeff_2_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_2_ber_meas    :    string    :=    "g3_coeff_1_ber_meas";
        gen3_coeff_3_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_3    :    string    :=    "g3_coeff_3";
        gen3_coeff_3_sel    :    string    :=    "coeff_3";
        gen3_coeff_3_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_3_preset_hint    :    string    :=    "g3_coeff_3_prst_hint";
        gen3_coeff_3_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_3_nxtber_more    :    string    :=    "g3_coeff_3_nxtber_more";
        gen3_coeff_3_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_3_nxtber_less    :    string    :=    "g3_coeff_3_nxtber_less";
        gen3_coeff_3_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_3_reqber    :    string    :=    "g3_coeff_3_reqber";
        gen3_coeff_3_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_3_ber_meas    :    string    :=    "g3_coeff_3_ber_meas";
        gen3_coeff_4_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_4    :    string    :=    "g3_coeff_4";
        gen3_coeff_4_sel    :    string    :=    "coeff_4";
        gen3_coeff_4_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_4_preset_hint    :    string    :=    "g3_coeff_4_prst_hint";
        gen3_coeff_4_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_4_nxtber_more    :    string    :=    "g3_coeff_4_nxtber_more";
        gen3_coeff_4_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_4_nxtber_less    :    string    :=    "g3_coeff_4_nxtber_less";
        gen3_coeff_4_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_4_reqber    :    string    :=    "g3_coeff_4_reqber";
        gen3_coeff_4_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_4_ber_meas    :    string    :=    "g3_coeff_4_ber_meas";
        gen3_coeff_5_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_5    :    string    :=    "g3_coeff_5";
        gen3_coeff_5_sel    :    string    :=    "coeff_5";
        gen3_coeff_5_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_5_preset_hint    :    string    :=    "g3_coeff_5_prst_hint";
        gen3_coeff_5_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_5_nxtber_more    :    string    :=    "g3_coeff_5_nxtber_more";
        gen3_coeff_5_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_5_nxtber_less    :    string    :=    "g3_coeff_5_nxtber_less";
        gen3_coeff_5_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_5_reqber    :    string    :=    "g3_coeff_5_reqber";
        gen3_coeff_5_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_5_ber_meas    :    string    :=    "g3_coeff_5_ber_meas";
        gen3_coeff_6_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_6    :    string    :=    "g3_coeff_6";
        gen3_coeff_6_sel    :    string    :=    "coeff_6";
        gen3_coeff_6_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_6_preset_hint    :    string    :=    "g3_coeff_6_prst_hint";
        gen3_coeff_6_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_6_nxtber_more    :    string    :=    "g3_coeff_6_nxtber_more";
        gen3_coeff_6_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_6_nxtber_less    :    string    :=    "g3_coeff_6_nxtber_less";
        gen3_coeff_6_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_6_reqber    :    string    :=    "g3_coeff_6_reqber";
        gen3_coeff_6_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_6_ber_meas    :    string    :=    "g3_coeff_6_ber_meas";
        gen3_coeff_7_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_7    :    string    :=    "g3_coeff_7";
        gen3_coeff_7_sel    :    string    :=    "coeff_7";
        gen3_coeff_7_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_7_preset_hint    :    string    :=    "g3_coeff_7_prst_hint";
        gen3_coeff_7_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_7_nxtber_more    :    string    :=    "g3_coeff_7_nxtber_more";
        gen3_coeff_7_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_7_nxtber_less    :    string    :=    "g3_coeff_7_nxtber_less";
        gen3_coeff_7_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_7_reqber    :    string    :=    "g3_coeff_7_reqber";
        gen3_coeff_7_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_7_ber_meas    :    string    :=    "g3_coeff_7_ber_meas";
        gen3_coeff_8_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_8    :    string    :=    "g3_coeff_8";
        gen3_coeff_8_sel    :    string    :=    "coeff_8";
        gen3_coeff_8_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_8_preset_hint    :    string    :=    "g3_coeff_8_prst_hint";
        gen3_coeff_8_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_8_nxtber_more    :    string    :=    "g3_coeff_8_nxtber_more";
        gen3_coeff_8_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_8_nxtber_less    :    string    :=    "g3_coeff_8_nxtber_less";
        gen3_coeff_8_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_8_reqber    :    string    :=    "g3_coeff_8_reqber";
        gen3_coeff_8_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_8_ber_meas    :    string    :=    "g3_coeff_8_ber_meas";
        gen3_coeff_9_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_9    :    string    :=    "g3_coeff_9";
        gen3_coeff_9_sel    :    string    :=    "coeff_9";
        gen3_coeff_9_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_9_preset_hint    :    string    :=    "g3_coeff_9_prst_hint";
        gen3_coeff_9_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_9_nxtber_more    :    string    :=    "g3_coeff_9_nxtber_more";
        gen3_coeff_9_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_9_nxtber_less    :    string    :=    "g3_coeff_9_nxtber_less";
        gen3_coeff_9_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_9_reqber    :    string    :=    "g3_coeff_9_reqber";
        gen3_coeff_9_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_9_ber_meas    :    string    :=    "g3_coeff_9_ber_meas";
        gen3_coeff_10_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_10    :    string    :=    "g3_coeff_10";
        gen3_coeff_10_sel    :    string    :=    "coeff_10";
        gen3_coeff_10_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_10_preset_hint    :    string    :=    "g3_coeff_10_prst_hint";
        gen3_coeff_10_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_10_nxtber_more    :    string    :=    "g3_coeff_10_nxtber_more";
        gen3_coeff_10_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_10_nxtber_less    :    string    :=    "g3_coeff_10_nxtber_less";
        gen3_coeff_10_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_10_reqber    :    string    :=    "g3_coeff_10_reqber";
        gen3_coeff_10_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_10_ber_meas    :    string    :=    "g3_coeff_10_ber_meas";
        gen3_coeff_11_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_11    :    string    :=    "g3_coeff_11";
        gen3_coeff_11_sel    :    string    :=    "coeff_11";
        gen3_coeff_11_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_11_preset_hint    :    string    :=    "g3_coeff_11_prst_hint";
        gen3_coeff_11_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_11_nxtber_more    :    string    :=    "g3_coeff_11_nxtber_more";
        gen3_coeff_11_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_11_nxtber_less    :    string    :=    "g3_coeff_11_nxtber_less";
        gen3_coeff_11_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_11_reqber    :    string    :=    "g3_coeff_11_reqber";
        gen3_coeff_11_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_11_ber_meas    :    string    :=    "g3_coeff_11_ber_meas";
        gen3_coeff_12_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_12    :    string    :=    "g3_coeff_12";
        gen3_coeff_12_sel    :    string    :=    "coeff_12";
        gen3_coeff_12_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_12_preset_hint    :    string    :=    "g3_coeff_12_prst_hint";
        gen3_coeff_12_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_12_nxtber_more    :    string    :=    "g3_coeff_12_nxtber_more";
        gen3_coeff_12_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_12_nxtber_less    :    string    :=    "g3_coeff_12_nxtber_less";
        gen3_coeff_12_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_12_reqber    :    string    :=    "g3_coeff_12_reqber";
        gen3_coeff_12_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_12_ber_meas    :    string    :=    "g3_coeff_12_ber_meas";
        gen3_coeff_13_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_13    :    string    :=    "g3_coeff_13";
        gen3_coeff_13_sel    :    string    :=    "coeff_13";
        gen3_coeff_13_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_13_preset_hint    :    string    :=    "g3_coeff_13_prst_hint";
        gen3_coeff_13_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_13_nxtber_more    :    string    :=    "g3_coeff_13_nxtber_more";
        gen3_coeff_13_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_13_nxtber_less    :    string    :=    "g3_coeff_13_nxtber_less";
        gen3_coeff_13_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_13_reqber    :    string    :=    "g3_coeff_13_reqber";
        gen3_coeff_13_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_13_ber_meas    :    string    :=    "g3_coeff_13_ber_meas";
        gen3_coeff_14_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_14    :    string    :=    "g3_coeff_14";
        gen3_coeff_14_sel    :    string    :=    "coeff_14";
        gen3_coeff_14_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_14_preset_hint    :    string    :=    "g3_coeff_14_prst_hint";
        gen3_coeff_14_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_14_nxtber_more    :    string    :=    "g3_coeff_14_nxtber_more";
        gen3_coeff_14_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_14_nxtber_less    :    string    :=    "g3_coeff_14_nxtber_less";
        gen3_coeff_14_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_14_reqber    :    string    :=    "g3_coeff_14_reqber";
        gen3_coeff_14_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_14_ber_meas    :    string    :=    "g3_coeff_14_ber_meas";
        gen3_coeff_15_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_15    :    string    :=    "g3_coeff_15";
        gen3_coeff_15_sel    :    string    :=    "coeff_15";
        gen3_coeff_15_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_15_preset_hint    :    string    :=    "g3_coeff_15_prst_hint";
        gen3_coeff_15_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_15_nxtber_more    :    string    :=    "g3_coeff_15_nxtber_more";
        gen3_coeff_15_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_15_nxtber_less    :    string    :=    "g3_coeff_15_nxtber_less";
        gen3_coeff_15_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_15_reqber    :    string    :=    "g3_coeff_15_reqber";
        gen3_coeff_15_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_15_ber_meas    :    string    :=    "g3_coeff_15_ber_meas";
        gen3_coeff_16_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_16    :    string    :=    "g3_coeff_16";
        gen3_coeff_16_sel    :    string    :=    "coeff_16";
        gen3_coeff_16_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_16_preset_hint    :    string    :=    "g3_coeff_16_prst_hint";
        gen3_coeff_16_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_16_nxtber_more    :    string    :=    "g3_coeff_16_nxtber_more";
        gen3_coeff_16_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_16_nxtber_less    :    string    :=    "g3_coeff_16_nxtber_less";
        gen3_coeff_16_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_16_reqber    :    string    :=    "g3_coeff_16_reqber";
        gen3_coeff_16_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_16_ber_meas    :    string    :=    "g3_coeff_16_ber_meas";
        gen3_preset_coeff_1_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_1    :    string    :=    "g3_prst_coeff_1";
        gen3_preset_coeff_2_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_2    :    string    :=    "g3_prst_coeff_2";
        gen3_preset_coeff_3_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_3    :    string    :=    "g3_prst_coeff_3";
        gen3_preset_coeff_4_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_4    :    string    :=    "g3_prst_coeff_4";
        gen3_preset_coeff_5_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_5    :    string    :=    "g3_prst_coeff_5";
        gen3_preset_coeff_6_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_6    :    string    :=    "g3_prst_coeff_6";
        gen3_preset_coeff_7_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_7    :    string    :=    "g3_prst_coeff_7";
        gen3_preset_coeff_8_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_8    :    string    :=    "g3_prst_coeff_8";
        gen3_preset_coeff_9_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_9    :    string    :=    "g3_prst_coeff_9";
        gen3_preset_coeff_10_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_10    :    string    :=    "g3_prst_coeff_10";
        gen3_rxfreqlock_counter_data    :    bit_vector    :=    "00000000000000000000";
        gen3_rxfreqlock_counter    :    string    :=    "g3_rxfreqlock_count";
        rstctrl_pld_clr                    : string := "false";-- "false", "true".
        rstctrl_debug_en                   : string := "false";-- "false", "true".
        rstctrl_force_inactive_rst         : string := "false";-- "false", "true".
        rstctrl_perst_enable               : string := "level";-- "level", "neg_edge", "not_used".
        hrdrstctrl_en                      : string := "hrdrstctrl_dis";--"hrdrstctrl_dis", "hrdrstctrl_en".
        rstctrl_hip_ep                     : string := "hip_ep";      --"hip_ep", "hip_not_ep".
        rstctrl_hard_block_enable          : string := "hard_rst_ctl";--"hard_rst_ctl", "pld_rst_ctl".
        rstctrl_rx_pma_rstb_inv            : string := "false";--"false", "true".
        rstctrl_tx_pma_rstb_inv            : string := "false";--"false", "true".
        rstctrl_rx_pcs_rst_n_inv           : string := "false";--"false", "true".
        rstctrl_tx_pcs_rst_n_inv           : string := "false";--"false", "true".
        rstctrl_altpe3_crst_n_inv          : string := "false";--"false", "true".
        rstctrl_altpe3_srst_n_inv          : string := "false";--"false", "true".
        rstctrl_altpe3_rst_n_inv           : string := "false";--"false", "true".
        rstctrl_tx_pma_syncp_inv           : string := "false";--"false", "true".
        rstctrl_1us_count_fref_clk         : string := "rstctrl_1us_cnt";--
        rstctrl_1us_count_fref_clk_value   : bit_vector := B"00000000000000111111";--
        rstctrl_1ms_count_fref_clk         : string := "rstctrl_1ms_cnt";--
        rstctrl_1ms_count_fref_clk_value   : bit_vector := B"00001111010000100100";--
        rstctrl_off_cal_done_select        : string := "not_active";-- "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active".
        rstctrl_rx_pma_rstb_cmu_select     : string := "not_active";-- "ch1cmu_sel", "ch4cmu_sel", "ch4_10cmu_sel", "not_active".
        rstctrl_rx_pll_freq_lock_select    : string := "not_active";-- "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active", "ch0_phs_sel", "ch01_phs_sel", "ch0123_phs_sel", "ch0123_5678_phs_sel".
        rstctrl_mask_tx_pll_lock_select    : string := "not_active";-- "ch1_sel", "ch4_sel", "ch4_10_sel", "not_active".
        rstctrl_rx_pll_lock_select         : string := "not_active";-- "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active".
        rstctrl_perstn_select              : string := "perstn_pin";-- "perstn_pin", "perstn_pld".
        rstctrl_tx_lc_pll_rstb_select      : string := "not_active";-- "ch1_out", "ch7_out", "not_active".
        rstctrl_fref_clk_select            : string := "ch0_sel";-- "ch0_sel", "ch1_sel", "ch2_sel", "ch3_sel", "ch4_sel", "ch5_sel", "ch6_sel", "ch7_sel", "ch8_sel", "ch9_sel", "ch10_sel", "ch11_sel".
        rstctrl_off_cal_en_select          : string := "not_active";-- "ch0_out", "ch01_out", "ch0123_out", "ch0123_5678_out", "not_active".
        rstctrl_tx_pma_syncp_select        : string := "not_active";-- "ch1_out", "ch4_out", "ch4_10_out", "not_active".
        rstctrl_rx_pcs_rst_n_select        : string := "not_active";-- "ch0_out", "ch01_out", "ch0123_out", "ch012345678_out", "ch012345678_10_out", "not_active".
        rstctrl_tx_cmu_pll_lock_select     : string := "not_active";-- "ch1_sel", "ch4_sel", "ch4_10_sel", "not_active".
        rstctrl_tx_pcs_rst_n_select        : string := "not_active";-- "ch0_out", "ch01_out", "ch0123_out", "ch012345678_out", "ch012345678_10_out", "not_active".
        rstctrl_tx_lc_pll_lock_select      : string := "not_active";-- "ch1_sel", "ch7_sel", "not_active".
        rstctrl_timer_a                    : string :=  "rstctrl_timer_a";
        rstctrl_timer_a_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_a_value              : bit_vector := B"00000001" ;
        rstctrl_timer_b                    : string :=  "rstctrl_timer_b";
        rstctrl_timer_b_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_b_value              : bit_vector := B"00000001";
        rstctrl_timer_c                    : string :=  "rstctrl_timer_c";
        rstctrl_timer_c_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_c_value              : bit_vector := B"00000001";
        rstctrl_timer_d                    : string :=  "rstctrl_timer_d";
        rstctrl_timer_d_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_d_value              : bit_vector := B"00000001";
        rstctrl_timer_e                    : string :=  "rstctrl_timer_e";
        rstctrl_timer_e_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_e_value              : bit_vector := B"00000001";
        rstctrl_timer_f                    : string :=  "rstctrl_timer_f";
        rstctrl_timer_f_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_f_value              : bit_vector := B"00000001";
        rstctrl_timer_g                    : string :=  "rstctrl_timer_g";
        rstctrl_timer_g_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_g_value              : bit_vector := B"00000001";
        rstctrl_timer_h                    : string :=  "rstctrl_timer_h";
        rstctrl_timer_h_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_h_value              : bit_vector := B"00000001";
        rstctrl_timer_i                    : string :=  "rstctrl_timer_i";
        rstctrl_timer_i_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_i_value              : bit_vector := B"00000001";
        rstctrl_timer_j                    : string :=  "rstctrl_timer_j";
        rstctrl_timer_j_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_j_value              : bit_vector := B"00000001"
    );
    port    (
        dpriostatus    :    out    std_logic_vector(15 downto 0);
        lmidout    :    out    std_logic_vector(31 downto 0);
        lmiack    :    out    std_logic_vector(0 downto 0);
        lmirden    :    in    std_logic_vector(0 downto 0);
        lmiwren    :    in    std_logic_vector(0 downto 0);
        lmiaddr    :    in    std_logic_vector(11 downto 0);
        lmidin    :    in    std_logic_vector(31 downto 0);
        flrreset    :    in    std_logic_vector(0 downto 0);
        flrsts    :    out    std_logic_vector(0 downto 0);
        resetstatus    :    out    std_logic_vector(0 downto 0);
        l2exit    :    out    std_logic_vector(0 downto 0);
        hotrstexit    :    out    std_logic_vector(0 downto 0);
        hiphardreset  :  in std_logic_vector(0 downto 0);
        dlupexit    :    out    std_logic_vector(0 downto 0);
        coreclkout    :    out    std_logic_vector(0 downto 0);
        pldclk    :    in    std_logic_vector(0 downto 0);
        pldsrst    :    in    std_logic_vector(0 downto 0);
        pldrst    :    in    std_logic_vector(0 downto 0);
        pclkch0    :    in    std_logic_vector(0 downto 0);
        pclkch1    :    in    std_logic_vector(0 downto 0);
        pclkcentral    :    in    std_logic_vector(0 downto 0);
        pllfixedclkch0    :    in    std_logic_vector(0 downto 0);
        pllfixedclkch1    :    in    std_logic_vector(0 downto 0);
        pllfixedclkcentral    :    in    std_logic_vector(0 downto 0);
        phyrst    :    in    std_logic_vector(0 downto 0);
        physrst    :    in    std_logic_vector(0 downto 0);
        coreclkin    :    in    std_logic_vector(0 downto 0);
        corerst    :    in    std_logic_vector(0 downto 0);
        corepor    :    in    std_logic_vector(0 downto 0);
        corecrst    :    in    std_logic_vector(0 downto 0);
        coresrst    :    in    std_logic_vector(0 downto 0);
        swdnout    :    out    std_logic_vector(6 downto 0);
        swupout    :    out    std_logic_vector(2 downto 0);
        swdnin    :    in    std_logic_vector(2 downto 0);
        swupin    :    in    std_logic_vector(6 downto 0);
        swctmod    :    in    std_logic_vector(1 downto 0);
        rxstdata    :    out    std_logic_vector(255 downto 0);
        rxstparity    :    out    std_logic_vector(31 downto 0);
        rxstbe    :    out    std_logic_vector(31 downto 0);
        rxsterr    :    out    std_logic_vector(3 downto 0);
        rxstsop    :    out    std_logic_vector(3 downto 0);
        rxsteop    :    out    std_logic_vector(3 downto 0);
        rxstempty    :    out    std_logic_vector(1 downto 0);
        rxstvalid    :    out    std_logic_vector(3 downto 0);
        rxstbardec1    :    out    std_logic_vector(7 downto 0);
        rxstbardec2    :    out    std_logic_vector(7 downto 0);
        rxstmask    :    in    std_logic_vector(0 downto 0);
        rxstready    :    in    std_logic_vector(0 downto 0);
        txstready    :    out    std_logic_vector(0 downto 0);
        txcredfchipcons    :    out    std_logic_vector(5 downto 0);
        txcredfcinfinite    :    out    std_logic_vector(5 downto 0);
        txcredhdrfcp    :    out    std_logic_vector(7 downto 0);
        txcreddatafcp    :    out    std_logic_vector(11 downto 0);
        txcredhdrfcnp    :    out    std_logic_vector(7 downto 0);
        txcreddatafcnp    :    out    std_logic_vector(11 downto 0);
        txcredhdrfccp    :    out    std_logic_vector(7 downto 0);
        txcreddatafccp    :    out    std_logic_vector(11 downto 0);
        txstdata    :    in    std_logic_vector(255 downto 0);
        txstparity    :    in    std_logic_vector(31 downto 0);
        txsterr    :    in    std_logic_vector(3 downto 0);
        txstsop    :    in    std_logic_vector(3 downto 0);
        txsteop    :    in    std_logic_vector(3 downto 0);
        txstempty    :    in    std_logic_vector(1 downto 0);
        txstvalid    :    in    std_logic_vector(0 downto 0);
        r2cuncecc    :    out    std_logic_vector(0 downto 0);
        rxcorrecc    :    out    std_logic_vector(0 downto 0);
        retryuncecc    :    out    std_logic_vector(0 downto 0);
        retrycorrecc    :    out    std_logic_vector(0 downto 0);
        rxparerr    :    out    std_logic_vector(0 downto 0);
        txparerr    :    out    std_logic_vector(1 downto 0);
        r2cparerr    :    out    std_logic_vector(0 downto 0);
        pmetosr    :    out    std_logic_vector(0 downto 0);
        pmetocr    :    in    std_logic_vector(0 downto 0);
        pmevent    :    in    std_logic_vector(0 downto 0);
        pmdata    :    in    std_logic_vector(9 downto 0);
        pmauxpwr    :    in    std_logic_vector(0 downto 0);
        tlcfgsts    :    out    std_logic_vector(52 downto 0);
        tlcfgctl    :    out    std_logic_vector(31 downto 0);
        tlcfgadd    :    out    std_logic_vector(3 downto 0);
        appintaack    :    out    std_logic_vector(0 downto 0);
        appintasts    :    in    std_logic_vector(0 downto 0);
        intstatus    :    out    std_logic_vector(3 downto 0);
        appmsiack    :    out    std_logic_vector(0 downto 0);
        appmsireq    :    in    std_logic_vector(0 downto 0);
        appmsitc    :    in    std_logic_vector(2 downto 0);
        appmsinum    :    in    std_logic_vector(4 downto 0);
        aermsinum    :    in    std_logic_vector(4 downto 0);
        pexmsinum    :    in    std_logic_vector(4 downto 0);
        hpgctrler    :    in    std_logic_vector(4 downto 0);
        cfglink2csrpld    :    in    std_logic_vector(12 downto 0);
        cfgprmbuspld    :    in    std_logic_vector(7 downto 0);
        csebisshadow    :    out    std_logic_vector(0 downto 0);
        csebwrdata    :    out    std_logic_vector(31 downto 0);
        csebwrdataparity    :    out    std_logic_vector(3 downto 0);
        csebbe    :    out    std_logic_vector(3 downto 0);
        csebaddr    :    out    std_logic_vector(32 downto 0);
        csebaddrparity    :    out    std_logic_vector(4 downto 0);
        csebwren    :    out    std_logic_vector(0 downto 0);
        csebrden    :    out    std_logic_vector(0 downto 0);
        csebwrrespreq    :    out    std_logic_vector(0 downto 0);
        csebrddata    :    in    std_logic_vector(31 downto 0);
        csebrddataparity    :    in    std_logic_vector(3 downto 0);
        csebwaitrequest    :    in    std_logic_vector(0 downto 0);
        csebwrrespvalid    :    in    std_logic_vector(0 downto 0);
        csebwrresponse    :    in    std_logic_vector(4 downto 0);
        csebrdresponse    :    in    std_logic_vector(4 downto 0);
        dlup    :    out    std_logic_vector(0 downto 0);
        testouthip    :    out    std_logic_vector(255 downto 0);
        testout1hip    :    out    std_logic_vector(63 downto 0);
        ev1us    :    out    std_logic_vector(0 downto 0);
        ev128ns    :    out    std_logic_vector(0 downto 0);
        wakeoen    :    out    std_logic_vector(0 downto 0);
        serrout    :    out    std_logic_vector(0 downto 0);
        ltssmstate    :    out    std_logic_vector(4 downto 0);
        laneact    :    out    std_logic_vector(3 downto 0);
        currentspeed    :    out    std_logic_vector(1 downto 0);
        slotclkcfg    :    in    std_logic_vector(0 downto 0);
        mode    :    in    std_logic_vector(1 downto 0);
        testinhip    :    in    std_logic_vector(31 downto 0);
        testin1hip    :    in    std_logic_vector(31 downto 0);
        cplpending    :    in    std_logic_vector(0 downto 0);
        cplerr    :    in    std_logic_vector(6 downto 0);
        appinterr    :    in    std_logic_vector(1 downto 0);
        egressblkerr    :    in    std_logic_vector(0 downto 0);
        pmexitd0ack    :    in    std_logic_vector(0 downto 0);
        pmexitd0req    :    out    std_logic_vector(0 downto 0);
        currentcoeff0    :    out    std_logic_vector(17 downto 0);
        currentcoeff1    :    out    std_logic_vector(17 downto 0);
        currentcoeff2    :    out    std_logic_vector(17 downto 0);
        currentcoeff3    :    out    std_logic_vector(17 downto 0);
        currentcoeff4    :    out    std_logic_vector(17 downto 0);
        currentcoeff5    :    out    std_logic_vector(17 downto 0);
        currentcoeff6    :    out    std_logic_vector(17 downto 0);
        currentcoeff7    :    out    std_logic_vector(17 downto 0);
        currentrxpreset0    :    out    std_logic_vector(2 downto 0);
        currentrxpreset1    :    out    std_logic_vector(2 downto 0);
        currentrxpreset2    :    out    std_logic_vector(2 downto 0);
        currentrxpreset3    :    out    std_logic_vector(2 downto 0);
        currentrxpreset4    :    out    std_logic_vector(2 downto 0);
        currentrxpreset5    :    out    std_logic_vector(2 downto 0);
        currentrxpreset6    :    out    std_logic_vector(2 downto 0);
        currentrxpreset7    :    out    std_logic_vector(2 downto 0);
        rate0    :    out    std_logic_vector(1 downto 0);
        rate1    :    out    std_logic_vector(1 downto 0);
        rate2    :    out    std_logic_vector(1 downto 0);
        rate3    :    out    std_logic_vector(1 downto 0);
        rate4    :    out    std_logic_vector(1 downto 0);
        rate5    :    out    std_logic_vector(1 downto 0);
        rate6    :    out    std_logic_vector(1 downto 0);
        rate7    :    out    std_logic_vector(1 downto 0);
        ratectrl    :    out    std_logic_vector(1 downto 0);
        ratetiedtognd    :    out    std_logic_vector(0 downto 0);
        eidleinfersel0    :    out    std_logic_vector(2 downto 0);
        eidleinfersel1    :    out    std_logic_vector(2 downto 0);
        eidleinfersel2    :    out    std_logic_vector(2 downto 0);
        eidleinfersel3    :    out    std_logic_vector(2 downto 0);
        eidleinfersel4    :    out    std_logic_vector(2 downto 0);
        eidleinfersel5    :    out    std_logic_vector(2 downto 0);
        eidleinfersel6    :    out    std_logic_vector(2 downto 0);
        eidleinfersel7    :    out    std_logic_vector(2 downto 0);
        txdata0    :    out    std_logic_vector(31 downto 0);
        txdatak0    :    out    std_logic_vector(3 downto 0);
        txdetectrx0    :    out    std_logic_vector(0 downto 0);
        txelecidle0    :    out    std_logic_vector(0 downto 0);
        txcompl0    :    out    std_logic_vector(0 downto 0);
        rxpolarity0    :    out    std_logic_vector(0 downto 0);
        powerdown0    :    out    std_logic_vector(1 downto 0);
        txdataskip0    :    out    std_logic_vector(0 downto 0);
        txblkst0    :    out    std_logic_vector(0 downto 0);
        txsynchd0    :    out    std_logic_vector(1 downto 0);
        txdeemph0    :    out    std_logic_vector(0 downto 0);
        txmargin0    :    out    std_logic_vector(2 downto 0);
        rxdata0    :    in    std_logic_vector(31 downto 0);
        rxdatak0    :    in    std_logic_vector(3 downto 0);
        rxvalid0    :    in    std_logic_vector(0 downto 0);
        phystatus0    :    in    std_logic_vector(0 downto 0);
        rxelecidle0    :    in    std_logic_vector(0 downto 0);
        rxstatus0    :    in    std_logic_vector(2 downto 0);
        rxdataskip0    :    in    std_logic_vector(0 downto 0);
        rxblkst0    :    in    std_logic_vector(0 downto 0);
        rxsynchd0    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked0    :    in    std_logic_vector(0 downto 0);
        txdata1    :    out    std_logic_vector(31 downto 0);
        txdatak1    :    out    std_logic_vector(3 downto 0);
        txdetectrx1    :    out    std_logic_vector(0 downto 0);
        txelecidle1    :    out    std_logic_vector(0 downto 0);
        txcompl1    :    out    std_logic_vector(0 downto 0);
        rxpolarity1    :    out    std_logic_vector(0 downto 0);
        powerdown1    :    out    std_logic_vector(1 downto 0);
        txdataskip1    :    out    std_logic_vector(0 downto 0);
        txblkst1    :    out    std_logic_vector(0 downto 0);
        txsynchd1    :    out    std_logic_vector(1 downto 0);
        txdeemph1    :    out    std_logic_vector(0 downto 0);
        txmargin1    :    out    std_logic_vector(2 downto 0);
        rxdata1    :    in    std_logic_vector(31 downto 0);
        rxdatak1    :    in    std_logic_vector(3 downto 0);
        rxvalid1    :    in    std_logic_vector(0 downto 0);
        phystatus1    :    in    std_logic_vector(0 downto 0);
        rxelecidle1    :    in    std_logic_vector(0 downto 0);
        rxstatus1    :    in    std_logic_vector(2 downto 0);
        rxdataskip1    :    in    std_logic_vector(0 downto 0);
        rxblkst1    :    in    std_logic_vector(0 downto 0);
        rxsynchd1    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked1    :    in    std_logic_vector(0 downto 0);
        txdata2    :    out    std_logic_vector(31 downto 0);
        txdatak2    :    out    std_logic_vector(3 downto 0);
        txdetectrx2    :    out    std_logic_vector(0 downto 0);
        txelecidle2    :    out    std_logic_vector(0 downto 0);
        txcompl2    :    out    std_logic_vector(0 downto 0);
        rxpolarity2    :    out    std_logic_vector(0 downto 0);
        powerdown2    :    out    std_logic_vector(1 downto 0);
        txdataskip2    :    out    std_logic_vector(0 downto 0);
        txblkst2    :    out    std_logic_vector(0 downto 0);
        txsynchd2    :    out    std_logic_vector(1 downto 0);
        txdeemph2    :    out    std_logic_vector(0 downto 0);
        txmargin2    :    out    std_logic_vector(2 downto 0);
        rxdata2    :    in    std_logic_vector(31 downto 0);
        rxdatak2    :    in    std_logic_vector(3 downto 0);
        rxvalid2    :    in    std_logic_vector(0 downto 0);
        phystatus2    :    in    std_logic_vector(0 downto 0);
        rxelecidle2    :    in    std_logic_vector(0 downto 0);
        rxstatus2    :    in    std_logic_vector(2 downto 0);
        rxdataskip2    :    in    std_logic_vector(0 downto 0);
        rxblkst2    :    in    std_logic_vector(0 downto 0);
        rxsynchd2    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked2    :    in    std_logic_vector(0 downto 0);
        txdata3    :    out    std_logic_vector(31 downto 0);
        txdatak3    :    out    std_logic_vector(3 downto 0);
        txdetectrx3    :    out    std_logic_vector(0 downto 0);
        txelecidle3    :    out    std_logic_vector(0 downto 0);
        txcompl3    :    out    std_logic_vector(0 downto 0);
        rxpolarity3    :    out    std_logic_vector(0 downto 0);
        powerdown3    :    out    std_logic_vector(1 downto 0);
        txdataskip3    :    out    std_logic_vector(0 downto 0);
        txblkst3    :    out    std_logic_vector(0 downto 0);
        txsynchd3    :    out    std_logic_vector(1 downto 0);
        txdeemph3    :    out    std_logic_vector(0 downto 0);
        txmargin3    :    out    std_logic_vector(2 downto 0);
        rxdata3    :    in    std_logic_vector(31 downto 0);
        rxdatak3    :    in    std_logic_vector(3 downto 0);
        rxvalid3    :    in    std_logic_vector(0 downto 0);
        phystatus3    :    in    std_logic_vector(0 downto 0);
        rxelecidle3    :    in    std_logic_vector(0 downto 0);
        rxstatus3    :    in    std_logic_vector(2 downto 0);
        rxdataskip3    :    in    std_logic_vector(0 downto 0);
        rxblkst3    :    in    std_logic_vector(0 downto 0);
        rxsynchd3    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked3    :    in    std_logic_vector(0 downto 0);
        txdata4    :    out    std_logic_vector(31 downto 0);
        txdatak4    :    out    std_logic_vector(3 downto 0);
        txdetectrx4    :    out    std_logic_vector(0 downto 0);
        txelecidle4    :    out    std_logic_vector(0 downto 0);
        txcompl4    :    out    std_logic_vector(0 downto 0);
        rxpolarity4    :    out    std_logic_vector(0 downto 0);
        powerdown4    :    out    std_logic_vector(1 downto 0);
        txdataskip4    :    out    std_logic_vector(0 downto 0);
        txblkst4    :    out    std_logic_vector(0 downto 0);
        txsynchd4    :    out    std_logic_vector(1 downto 0);
        txdeemph4    :    out    std_logic_vector(0 downto 0);
        txmargin4    :    out    std_logic_vector(2 downto 0);
        rxdata4    :    in    std_logic_vector(31 downto 0);
        rxdatak4    :    in    std_logic_vector(3 downto 0);
        rxvalid4    :    in    std_logic_vector(0 downto 0);
        phystatus4    :    in    std_logic_vector(0 downto 0);
        rxelecidle4    :    in    std_logic_vector(0 downto 0);
        rxstatus4    :    in    std_logic_vector(2 downto 0);
        rxdataskip4    :    in    std_logic_vector(0 downto 0);
        rxblkst4    :    in    std_logic_vector(0 downto 0);
        rxsynchd4    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked4    :    in    std_logic_vector(0 downto 0);
        txdata5    :    out    std_logic_vector(31 downto 0);
        txdatak5    :    out    std_logic_vector(3 downto 0);
        txdetectrx5    :    out    std_logic_vector(0 downto 0);
        txelecidle5    :    out    std_logic_vector(0 downto 0);
        txcompl5    :    out    std_logic_vector(0 downto 0);
        rxpolarity5    :    out    std_logic_vector(0 downto 0);
        powerdown5    :    out    std_logic_vector(1 downto 0);
        txdataskip5    :    out    std_logic_vector(0 downto 0);
        txblkst5    :    out    std_logic_vector(0 downto 0);
        txsynchd5    :    out    std_logic_vector(1 downto 0);
        txdeemph5    :    out    std_logic_vector(0 downto 0);
        txmargin5    :    out    std_logic_vector(2 downto 0);
        rxdata5    :    in    std_logic_vector(31 downto 0);
        rxdatak5    :    in    std_logic_vector(3 downto 0);
        rxvalid5    :    in    std_logic_vector(0 downto 0);
        phystatus5    :    in    std_logic_vector(0 downto 0);
        rxelecidle5    :    in    std_logic_vector(0 downto 0);
        rxstatus5    :    in    std_logic_vector(2 downto 0);
        rxdataskip5    :    in    std_logic_vector(0 downto 0);
        rxblkst5    :    in    std_logic_vector(0 downto 0);
        rxsynchd5    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked5    :    in    std_logic_vector(0 downto 0);
        txdata6    :    out    std_logic_vector(31 downto 0);
        txdatak6    :    out    std_logic_vector(3 downto 0);
        txdetectrx6    :    out    std_logic_vector(0 downto 0);
        txelecidle6    :    out    std_logic_vector(0 downto 0);
        txcompl6    :    out    std_logic_vector(0 downto 0);
        rxpolarity6    :    out    std_logic_vector(0 downto 0);
        powerdown6    :    out    std_logic_vector(1 downto 0);
        txdataskip6    :    out    std_logic_vector(0 downto 0);
        txblkst6    :    out    std_logic_vector(0 downto 0);
        txsynchd6    :    out    std_logic_vector(1 downto 0);
        txdeemph6    :    out    std_logic_vector(0 downto 0);
        txmargin6    :    out    std_logic_vector(2 downto 0);
        rxdata6    :    in    std_logic_vector(31 downto 0);
        rxdatak6    :    in    std_logic_vector(3 downto 0);
        rxvalid6    :    in    std_logic_vector(0 downto 0);
        phystatus6    :    in    std_logic_vector(0 downto 0);
        rxelecidle6    :    in    std_logic_vector(0 downto 0);
        rxstatus6    :    in    std_logic_vector(2 downto 0);
        rxdataskip6    :    in    std_logic_vector(0 downto 0);
        rxblkst6    :    in    std_logic_vector(0 downto 0);
        rxsynchd6    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked6    :    in    std_logic_vector(0 downto 0);
        txdata7    :    out    std_logic_vector(31 downto 0);
        txdatak7    :    out    std_logic_vector(3 downto 0);
        txdetectrx7    :    out    std_logic_vector(0 downto 0);
        txelecidle7    :    out    std_logic_vector(0 downto 0);
        txcompl7    :    out    std_logic_vector(0 downto 0);
        rxpolarity7    :    out    std_logic_vector(0 downto 0);
        powerdown7    :    out    std_logic_vector(1 downto 0);
        txdataskip7    :    out    std_logic_vector(0 downto 0);
        txblkst7    :    out    std_logic_vector(0 downto 0);
        txsynchd7    :    out    std_logic_vector(1 downto 0);
        txdeemph7    :    out    std_logic_vector(0 downto 0);
        txmargin7    :    out    std_logic_vector(2 downto 0);
        rxdata7    :    in    std_logic_vector(31 downto 0);
        rxdatak7    :    in    std_logic_vector(3 downto 0);
        rxvalid7    :    in    std_logic_vector(0 downto 0);
        phystatus7    :    in    std_logic_vector(0 downto 0);
        rxelecidle7    :    in    std_logic_vector(0 downto 0);
        rxstatus7    :    in    std_logic_vector(2 downto 0);
        rxdataskip7    :    in    std_logic_vector(0 downto 0);
        rxblkst7    :    in    std_logic_vector(0 downto 0);
        rxsynchd7    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked7    :    in    std_logic_vector(0 downto 0);
        dbgpipex1rx    :    in    std_logic_vector(43 downto 0);
        memredsclk    :    in    std_logic_vector(0 downto 0);
        memredenscan    :    in    std_logic_vector(0 downto 0);
        memredscen    :    in    std_logic_vector(0 downto 0);
        memredscin    :    in    std_logic_vector(0 downto 0);
        memredscsel    :    in    std_logic_vector(0 downto 0);
        memredscrst    :    in    std_logic_vector(0 downto 0);
        memredscout    :    out    std_logic_vector(0 downto 0);
        memregscanen    :    in    std_logic_vector(0 downto 0);
        memregscanin    :    in    std_logic_vector(0 downto 0);
        memhiptestenable    :    in    std_logic_vector(0 downto 0);
        memregscanout    :    out    std_logic_vector(0 downto 0);
        bisttesten    :    in    std_logic_vector(0 downto 0);
        bistenrpl    :    in    std_logic_vector(0 downto 0);
        bistscanin    :    in    std_logic_vector(0 downto 0);
        bistscanen    :    in    std_logic_vector(0 downto 0);
        bistenrcv    :    in    std_logic_vector(0 downto 0);
        bistscanoutrpl    :    out    std_logic_vector(0 downto 0);
        bistdonearpl    :    out    std_logic_vector(0 downto 0);
        bistdonebrpl    :    out    std_logic_vector(0 downto 0);
        bistpassrpl    :    out    std_logic_vector(0 downto 0);
        derrrpl    :    out    std_logic_vector(0 downto 0);
        derrcorextrpl    :    out    std_logic_vector(0 downto 0);
        bistscanoutrcv    :    out    std_logic_vector(0 downto 0);
        bistdonearcv    :    out    std_logic_vector(0 downto 0);
        bistdonebrcv    :    out    std_logic_vector(0 downto 0);
        bistpassrcv    :    out    std_logic_vector(0 downto 0);
        derrcorextrcv    :    out    std_logic_vector(0 downto 0);
        bistscanoutrcv1    :    out    std_logic_vector(0 downto 0);
        bistdonearcv1    :    out    std_logic_vector(0 downto 0);
        bistdonebrcv1    :    out    std_logic_vector(0 downto 0);
        bistpassrcv1    :    out    std_logic_vector(0 downto 0);
        derrcorextrcv1    :    out    std_logic_vector(0 downto 0);
        scanmoden    :    in    std_logic_vector(0 downto 0);
        scanshiftn    :    in    std_logic_vector(0 downto 0);
        nfrzdrv    :    in    std_logic_vector(0 downto 0);
        frzreg    :    in    std_logic_vector(0 downto 0);
        frzlogic    :    in    std_logic_vector(0 downto 0);
        idrpl    :    in    std_logic_vector(7 downto 0);
        idrcv    :    in    std_logic_vector(7 downto 0);
        plniotri    :    in    std_logic_vector(0 downto 0);
        entest    :    in    std_logic_vector(0 downto 0);
        npor    :    in    std_logic_vector(0 downto 0);
        usermode    :    in    std_logic_vector(0 downto 0);
        cvpclk    :    out    std_logic_vector(0 downto 0);
        cvpdata    :    out    std_logic_vector(31 downto 0);
        cvpstartxfer    :    out    std_logic_vector(0 downto 0);
        cvpconfig    :    out    std_logic_vector(0 downto 0);
        cvpfullconfig    :    out    std_logic_vector(0 downto 0);
        cvpconfigready    :    in    std_logic_vector(0 downto 0);
        cvpen    :    in    std_logic_vector(0 downto 0);
        cvpconfigerror    :    in    std_logic_vector(0 downto 0);
        cvpconfigdone    :    in    std_logic_vector(0 downto 0);
        pinperstn    :    in    std_logic_vector(0 downto 0);
        pldperstn    :    in    std_logic_vector(0 downto 0);
        iocsrrdydly    :    in    std_logic_vector(0 downto 0);
        softaltpe3rstn    :    in    std_logic_vector(0 downto 0);
        softaltpe3srstn    :    in    std_logic_vector(0 downto 0);
        softaltpe3crstn    :    in    std_logic_vector(0 downto 0);
        pldclrpmapcshipn    :    in    std_logic_vector(0 downto 0);
        pldclrpcshipn    :    in    std_logic_vector(0 downto 0);
        pldclrhipn    :    in    std_logic_vector(0 downto 0);
        s0ch0emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s0ch1emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s0ch2emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s1ch0emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s1ch1emsiptieoff    :    out    std_logic_vector(188 downto 0);
        s1ch2emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s2ch0emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s2ch1emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s2ch2emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s3ch0emsiptieoff    :    out    std_logic_vector(188 downto 0);
        s3ch1emsiptieoff    :    out    std_logic_vector(188 downto 0);
        s3ch2emsiptieoff    :    out    std_logic_vector(188 downto 0);
        emsiptieofftop    :    out    std_logic_vector(299 downto 0);
        emsiptieoffbot    :    out    std_logic_vector(299 downto 0);

        txpcsrstn0                 : out std_logic_vector(0 downto 0);
        rxpcsrstn0                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn0               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn0               : out std_logic_vector(0 downto 0);
        txpmasyncp0                : out std_logic_vector(0 downto 0);
        rxpmarstb0                 : out std_logic_vector(0 downto 0);
        txlcpllrstb0               : out std_logic_vector(0 downto 0);
        offcalen0                  : out std_logic_vector(0 downto 0);
        frefclk0                   : in  std_logic_vector(0 downto 0);
        offcaldone0                : in  std_logic_vector(0 downto 0);
        txlcplllock0               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock0        : in  std_logic_vector(0 downto 0);
        rxpllphaselock0            : in  std_logic_vector(0 downto 0);
        masktxplllock0             : in  std_logic_vector(0 downto 0);
        txpcsrstn1                 : out std_logic_vector(0 downto 0);
        rxpcsrstn1                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn1               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn1               : out std_logic_vector(0 downto 0);
        txpmasyncp1                : out std_logic_vector(0 downto 0);
        rxpmarstb1                 : out std_logic_vector(0 downto 0);
        txlcpllrstb1               : out std_logic_vector(0 downto 0);
        offcalen1                  : out std_logic_vector(0 downto 0);
        frefclk1                   : in  std_logic_vector(0 downto 0);
        offcaldone1                : in  std_logic_vector(0 downto 0);
        txlcplllock1               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock1        : in  std_logic_vector(0 downto 0);
        rxpllphaselock1            : in  std_logic_vector(0 downto 0);
        masktxplllock1             : in  std_logic_vector(0 downto 0);
        txpcsrstn2                 : out std_logic_vector(0 downto 0);
        rxpcsrstn2                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn2               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn2               : out std_logic_vector(0 downto 0);
        txpmasyncp2                : out std_logic_vector(0 downto 0);
        rxpmarstb2                 : out std_logic_vector(0 downto 0);
        txlcpllrstb2               : out std_logic_vector(0 downto 0);
        offcalen2                  : out std_logic_vector(0 downto 0);
        frefclk2                   : in  std_logic_vector(0 downto 0);
        offcaldone2                : in  std_logic_vector(0 downto 0);
        txlcplllock2               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock2        : in  std_logic_vector(0 downto 0);
        rxpllphaselock2            : in  std_logic_vector(0 downto 0);
        masktxplllock2             : in  std_logic_vector(0 downto 0);
        txpcsrstn3                 : out std_logic_vector(0 downto 0);
        rxpcsrstn3                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn3               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn3               : out std_logic_vector(0 downto 0);
        txpmasyncp3                : out std_logic_vector(0 downto 0);
        rxpmarstb3                 : out std_logic_vector(0 downto 0);
        txlcpllrstb3               : out std_logic_vector(0 downto 0);
        offcalen3                  : out std_logic_vector(0 downto 0);
        frefclk3                   : in  std_logic_vector(0 downto 0);
        offcaldone3                : in  std_logic_vector(0 downto 0);
        txlcplllock3               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock3        : in  std_logic_vector(0 downto 0);
        rxpllphaselock3            : in  std_logic_vector(0 downto 0);
        masktxplllock3             : in  std_logic_vector(0 downto 0);
        txpcsrstn4                 : out std_logic_vector(0 downto 0);
        rxpcsrstn4                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn4               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn4               : out std_logic_vector(0 downto 0);
        txpmasyncp4                : out std_logic_vector(0 downto 0);
        rxpmarstb4                 : out std_logic_vector(0 downto 0);
        txlcpllrstb4               : out std_logic_vector(0 downto 0);
        offcalen4                  : out std_logic_vector(0 downto 0);
        frefclk4                   : in  std_logic_vector(0 downto 0);
        offcaldone4                : in  std_logic_vector(0 downto 0);
        txlcplllock4               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock4        : in  std_logic_vector(0 downto 0);
        rxpllphaselock4            : in  std_logic_vector(0 downto 0);
        masktxplllock4             : in  std_logic_vector(0 downto 0);
        txpcsrstn5                 : out std_logic_vector(0 downto 0);
        rxpcsrstn5                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn5               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn5               : out std_logic_vector(0 downto 0);
        txpmasyncp5                : out std_logic_vector(0 downto 0);
        rxpmarstb5                 : out std_logic_vector(0 downto 0);
        txlcpllrstb5               : out std_logic_vector(0 downto 0);
        offcalen5                  : out std_logic_vector(0 downto 0);
        frefclk5                   : in  std_logic_vector(0 downto 0);
        offcaldone5                : in  std_logic_vector(0 downto 0);
        txlcplllock5               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock5        : in  std_logic_vector(0 downto 0);
        rxpllphaselock5            : in  std_logic_vector(0 downto 0);
        masktxplllock5             : in  std_logic_vector(0 downto 0);
        txpcsrstn6                 : out std_logic_vector(0 downto 0);
        rxpcsrstn6                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn6               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn6               : out std_logic_vector(0 downto 0);
        txpmasyncp6                : out std_logic_vector(0 downto 0);
        rxpmarstb6                 : out std_logic_vector(0 downto 0);
        txlcpllrstb6               : out std_logic_vector(0 downto 0);
        offcalen6                  : out std_logic_vector(0 downto 0);
        frefclk6                   : in  std_logic_vector(0 downto 0);
        offcaldone6                : in  std_logic_vector(0 downto 0);
        txlcplllock6               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock6        : in  std_logic_vector(0 downto 0);
        rxpllphaselock6            : in  std_logic_vector(0 downto 0);
        masktxplllock6             : in  std_logic_vector(0 downto 0);
        txpcsrstn7                 : out std_logic_vector(0 downto 0);
        rxpcsrstn7                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn7               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn7               : out std_logic_vector(0 downto 0);
        txpmasyncp7                : out std_logic_vector(0 downto 0);
        rxpmarstb7                 : out std_logic_vector(0 downto 0);
        txlcpllrstb7               : out std_logic_vector(0 downto 0);
        offcalen7                  : out std_logic_vector(0 downto 0);
        frefclk7                   : in  std_logic_vector(0 downto 0);
        offcaldone7                : in  std_logic_vector(0 downto 0);
        txlcplllock7               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock7        : in  std_logic_vector(0 downto 0);
        rxpllphaselock7            : in  std_logic_vector(0 downto 0);
        masktxplllock7             : in  std_logic_vector(0 downto 0);
        txpcsrstn8                 : out std_logic_vector(0 downto 0);
        rxpcsrstn8                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn8               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn8               : out std_logic_vector(0 downto 0);
        txpmasyncp8                : out std_logic_vector(0 downto 0);
        rxpmarstb8                 : out std_logic_vector(0 downto 0);
        txlcpllrstb8               : out std_logic_vector(0 downto 0);
        offcalen8                  : out std_logic_vector(0 downto 0);
        frefclk8                   : in  std_logic_vector(0 downto 0);
        offcaldone8                : in  std_logic_vector(0 downto 0);
        txlcplllock8               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock8        : in  std_logic_vector(0 downto 0);
        rxpllphaselock8            : in  std_logic_vector(0 downto 0);
        masktxplllock8             : in  std_logic_vector(0 downto 0);
        txpcsrstn9                 : out std_logic_vector(0 downto 0);
        rxpcsrstn9                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn9               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn9               : out std_logic_vector(0 downto 0);
        txpmasyncp9                : out std_logic_vector(0 downto 0);
        rxpmarstb9                 : out std_logic_vector(0 downto 0);
        txlcpllrstb9               : out std_logic_vector(0 downto 0);
        offcalen9                  : out std_logic_vector(0 downto 0);
        frefclk9                   : in  std_logic_vector(0 downto 0);
        offcaldone9                : in  std_logic_vector(0 downto 0);
        txlcplllock9               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock9        : in  std_logic_vector(0 downto 0);
        rxpllphaselock9            : in  std_logic_vector(0 downto 0);
        masktxplllock9             : in  std_logic_vector(0 downto 0);
        txpcsrstn10                : out std_logic_vector(0 downto 0);
        rxpcsrstn10                : out std_logic_vector(0 downto 0);
        g3txpcsrstn10              : out std_logic_vector(0 downto 0);
        g3rxpcsrstn10              : out std_logic_vector(0 downto 0);
        txpmasyncp10               : out std_logic_vector(0 downto 0);
        rxpmarstb10                : out std_logic_vector(0 downto 0);
        txlcpllrstb10              : out std_logic_vector(0 downto 0);
        offcalen10                 : out std_logic_vector(0 downto 0);
        frefclk10                  : in  std_logic_vector(0 downto 0);
        offcaldone10               : in  std_logic_vector(0 downto 0);
        txlcplllock10              : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock10       : in  std_logic_vector(0 downto 0);
        rxpllphaselock10           : in  std_logic_vector(0 downto 0);
        masktxplllock10            : in  std_logic_vector(0 downto 0);
        txpcsrstn11                : out std_logic_vector(0 downto 0);
        rxpcsrstn11                : out std_logic_vector(0 downto 0);
        g3txpcsrstn11              : out std_logic_vector(0 downto 0);
        g3rxpcsrstn11              : out std_logic_vector(0 downto 0);
        txpmasyncp11               : out std_logic_vector(0 downto 0);
        rxpmarstb11                : out std_logic_vector(0 downto 0);
        txlcpllrstb11              : out std_logic_vector(0 downto 0);
        offcalen11                 : out std_logic_vector(0 downto 0);
        frefclk11                  : in  std_logic_vector(0 downto 0);
        offcaldone11               : in  std_logic_vector(0 downto 0);
        txlcplllock11              : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock11       : in  std_logic_vector(0 downto 0);
        rxpllphaselock11           : in  std_logic_vector(0 downto 0);
        masktxplllock11            : in  std_logic_vector(0 downto 0);

        reservedin    :    in    std_logic_vector(31 downto 0);
        reservedclkin    :    in    std_logic_vector(0 downto 0);
        reservedout    :    out    std_logic_vector(31 downto 0);
        reservedclkout    :    out    std_logic_vector(0 downto 0)
    );
end stratixv_hssi_gen3_pcie_hip;

architecture behavior of stratixv_hssi_gen3_pcie_hip is

component    stratixv_hssi_gen3_pcie_hip_encrypted
    generic    (
        func_mode    :    string    :=    "disable";
        in_cvp_mode  : string := "not_cvp_mode";
        bonding_mode    :    string    :=    "bond_disable";
        prot_mode    :    string    :=    "disabled_prot_mode";
        pcie_spec_1p0_compliance    :    string    :=    "spec_1p1";
        vc_enable    :    string    :=    "single_vc";
        enable_slot_register    :    string    :=    "false";
        pcie_mode    :    string    :=    "shared_mode";
        bypass_cdc    :    string    :=    "false";
        enable_rx_reordering    :    string    :=    "true";
        enable_rx_buffer_checking    :    string    :=    "false";
        single_rx_detect_data    :    bit_vector    :=    B"0000";
        single_rx_detect    :    string    :=    "single_rx_detect";
        use_crc_forwarding    :    string    :=    "false";
        bypass_tl    :    string    :=    "false";
        gen123_lane_rate_mode    :    string    :=    "gen1";
        lane_mask    :    string    :=    "x4";
        disable_link_x2_support    :    string    :=    "false";
        national_inst_thru_enhance    :    string    :=    "true";
        hip_hard_reset    :    string    :=    "enable";
        dis_paritychk    :    string    :=    "enable";
        wrong_device_id    :    string    :=    "disable";
        data_pack_rx    :    string    :=    "disable";
        ast_width    :    string    :=    "rx_tx_64";
        rx_sop_ctrl    :    string    :=    "boundary_64";
        rx_ast_parity    :    string    :=    "disable";
        tx_ast_parity    :    string    :=    "disable";
        ltssm_1ms_timeout    :    string    :=    "disable";
        ltssm_freqlocked_check    :    string    :=    "disable";
        deskew_comma    :    string    :=    "skp_eieos_deskw";
        dl_tx_check_parity_edb    :    string    :=    "disable";
        tl_tx_check_parity_msg    :    string    :=    "disable";
        port_link_number_data    :    bit_vector    :=    B"00000001";
        port_link_number    :    string    :=    "port_link_number";
        device_number_data    :    bit_vector    :=    B"00000";
        device_number    :    string    :=    "device_number";
        bypass_clk_switch    :    string    :=    "false";
        core_clk_out_sel    :    string    :=    "div_1";
        core_clk_divider    :    string    :=    "div_1";
        core_clk_source    :    string    :=    "pll_fixed_clk";
        core_clk_sel    :    string    :=    "pld_clk";
        enable_ch0_pclk_out    :    string    :=    "true";
        enable_ch01_pclk_out    :    string    :=    "pclk_ch0";
        pipex1_debug_sel    :    string    :=    "disable";
        pclk_out_sel    :    string    :=    "pclk";
        vendor_id_data    :    bit_vector    :=    B"1000101110010";
        vendor_id    :    string    :=    "vendor_id";
        device_id_data    :    bit_vector    :=    B"0000000000000001";
        device_id    :    string    :=    "device_id";
        revision_id_data    :    bit_vector    :=    B"00000001";
        revision_id    :    string    :=    "revision_id";
        class_code_data    :    bit_vector    :=    B"111111110000000000000000";
        class_code    :    string    :=    "class_code";
        subsystem_vendor_id_data    :    bit_vector    :=    B"0001000101110010";
        subsystem_vendor_id    :    string    :=    "subsystem_vendor_id";
        subsystem_device_id_data    :    bit_vector    :=    B"0000000000000001";
        subsystem_device_id    :    string    :=    "subsystem_device_id";
        no_soft_reset    :    string    :=    "false";
        maximum_current_data    :    bit_vector    :=    B"000";
        maximum_current    :    string    :=    "maximum_current";
        d1_support    :    string    :=    "false";
        d2_support    :    string    :=    "false";
        d0_pme    :    string    :=    "false";
        d1_pme    :    string    :=    "false";
        d2_pme    :    string    :=    "false";
        d3_hot_pme    :    string    :=    "false";
        d3_cold_pme    :    string    :=    "false";
        use_aer    :    string    :=    "false";
        low_priority_vc    :    string    :=    "single_vc";
        vc_arbitration    :    string    :=    "single_vc";
        disable_snoop_packet    :    string    :=    "false";
        max_payload_size    :    string    :=    "payload_512";
        surprise_down_error_support    :    string    :=    "false";
        dll_active_report_support    :    string    :=    "false";
        extend_tag_field    :    string    :=    "false";
        endpoint_l0_latency_data    :    bit_vector    :=    B"000";
        endpoint_l0_latency    :    string    :=    "endpoint_l0_latency";
        endpoint_l1_latency_data    :    bit_vector    :=    B"000";
        endpoint_l1_latency    :    string    :=    "endpoint_l1_latency";
        indicator_data    :    bit_vector    :=    B"111";
        indicator    :    string    :=    "indicator";
        role_based_error_reporting    :    string    :=    "false";
        slot_power_scale_data    :    bit_vector    :=    B"00";
        slot_power_scale    :    string    :=    "slot_power_scale";
        max_link_width    :    string    :=    "x4";
        enable_l1_aspm    :    string    :=    "false";
        enable_l0s_aspm    :    string    :=    "false";
        l1_exit_latency_sameclock_data    :    bit_vector    :=    B"000";
        l1_exit_latency_sameclock    :    string    :=    "l1_exit_latency_sameclock";
        l1_exit_latency_diffclock_data    :    bit_vector    :=    B"000";
        l1_exit_latency_diffclock    :    string    :=    "l1_exit_latency_diffclock";
        hot_plug_support_data    :    bit_vector    :=    B"0000000";
        hot_plug_support    :    string    :=    "hot_plug_support";
        slot_power_limit_data    :    bit_vector    :=    B"00000000";
        slot_power_limit    :    string    :=    "slot_power_limit";
        slot_number_data    :    bit_vector    :=    B"0000000000000";
        slot_number    :    string    :=    "slot_number";
        diffclock_nfts_count_data    :    bit_vector    :=    B"00000000";
        diffclock_nfts_count    :    string    :=    "diffclock_nfts_count";
        sameclock_nfts_count_data    :    bit_vector    :=    B"00000000";
        sameclock_nfts_count    :    string    :=    "sameclock_nfts_count";
        completion_timeout    :    string    :=    "abcd";
        enable_completion_timeout_disable    :    string    :=    "true";
        extended_tag_reset    :    string    :=    "false";
        ecrc_check_capable    :    string    :=    "true";
        ecrc_gen_capable    :    string    :=    "true";
        no_command_completed    :    string    :=    "true";
        msi_multi_message_capable    :    string    :=    "count_4";
        msi_64bit_addressing_capable    :    string    :=    "true";
        msi_masking_capable    :    string    :=    "false";
        msi_support    :    string    :=    "true";
        interrupt_pin    :    string    :=    "inta";
        ena_ido_req    :    string    :=    "false";
        ena_ido_cpl    :    string    :=    "false";
        enable_function_msix_support    :    string    :=    "true";
        msix_table_size_data    :    bit_vector    :=    B"00000000000";
        msix_table_size    :    string    :=    "msix_table_size";
        msix_table_bir_data    :    bit_vector    :=    B"000";
        msix_table_bir    :    string    :=    "msix_table_bir";
        msix_table_offset_data    :    bit_vector    :=    B"00000000000000000000000000000";
        msix_table_offset    :    string    :=    "msix_table_offset";
        msix_pba_bir_data    :    bit_vector    :=    B"000";
        msix_pba_bir    :    string    :=    "msix_pba_bir";
        msix_pba_offset_data    :    bit_vector    :=    B"00000000000000000000000000000";
        msix_pba_offset    :    string    :=    "msix_pba_offset";
        bridge_port_vga_enable    :    string    :=    "false";
        bridge_port_ssid_support    :    string    :=    "false";
        ssvid_data    :    bit_vector    :=    B"0000000000000000";
        ssvid    :    string    :=    "ssvid";
        ssid_data    :    bit_vector    :=    B"0000000000000000";
        ssid    :    string    :=    "ssid";
        eie_before_nfts_count_data    :    bit_vector    :=    B"0100";
        eie_before_nfts_count    :    string    :=    "eie_before_nfts_count";
        gen2_diffclock_nfts_count_data    :    bit_vector    :=    B"11111111";
        gen2_diffclock_nfts_count    :    string    :=    "gen2_diffclock_nfts_count";
        gen2_sameclock_nfts_count_data    :    bit_vector    :=    B"11111111";
        gen2_sameclock_nfts_count    :    string    :=    "gen2_sameclock_nfts_count";
        deemphasis_enable    :    string    :=    "false";
        pcie_spec_version    :    string    :=    "v2";
        l0_exit_latency_sameclock_data    :    bit_vector    :=    B"110";
        l0_exit_latency_sameclock    :    string    :=    "l0_exit_latency_sameclock";
        l0_exit_latency_diffclock_data    :    bit_vector    :=    B"110";
        l0_exit_latency_diffclock    :    string    :=    "l0_exit_latency_diffclock";
        rx_ei_l0s    :    string    :=    "disable";
        l2_async_logic    :    string    :=    "enable";
        aspm_config_management    :    string    :=    "true";
        atomic_op_routing    :    string    :=    "false";
        atomic_op_completer_32bit    :    string    :=    "false";
        atomic_op_completer_64bit    :    string    :=    "false";
        cas_completer_128bit    :    string    :=    "false";
        ltr_mechanism    :    string    :=    "false";
        tph_completer    :    string    :=    "false";
        extended_format_field    :    string    :=    "true";
        atomic_malformed    :    string    :=    "false";
        flr_capability    :    string    :=    "true";
        enable_adapter_half_rate_mode    :    string    :=    "false";
        vc0_clk_enable    :    string    :=    "true";
        vc1_clk_enable    :    string    :=    "false";
        register_pipe_signals    :    string    :=    "false";
        bar0_io_space    :    string    :=    "false";
        bar0_64bit_mem_space    :    string    :=    "true";
        bar0_prefetchable    :    string    :=    "true";
        bar0_size_mask_data    :    bit_vector    :=    B"1111111111111111111111111111";
        bar0_size_mask    :    string    :=    "bar0_size_mask";
        bar1_io_space    :    string    :=    "false";
        bar1_64bit_mem_space    :    string    :=    "false";
        bar1_prefetchable    :    string    :=    "false";
        bar1_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar1_size_mask    :    string    :=    "bar1_size_mask";
        bar2_io_space    :    string    :=    "false";
        bar2_64bit_mem_space    :    string    :=    "false";
        bar2_prefetchable    :    string    :=    "false";
        bar2_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar2_size_mask    :    string    :=    "bar2_size_mask";
        bar3_io_space    :    string    :=    "false";
        bar3_64bit_mem_space    :    string    :=    "false";
        bar3_prefetchable    :    string    :=    "false";
        bar3_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar3_size_mask    :    string    :=    "bar3_size_mask";
        bar4_io_space    :    string    :=    "false";
        bar4_64bit_mem_space    :    string    :=    "false";
        bar4_prefetchable    :    string    :=    "false";
        bar4_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar4_size_mask    :    string    :=    "bar4_size_mask";
        bar5_io_space    :    string    :=    "false";
        bar5_64bit_mem_space    :    string    :=    "false";
        bar5_prefetchable    :    string    :=    "false";
        bar5_size_mask_data    :    bit_vector    :=    B"0000000000000000000000000000";
        bar5_size_mask    :    string    :=    "bar5_size_mask";
        expansion_base_address_register_data    :    bit_vector    :=    B"00000000000000000000000000000000";
        expansion_base_address_register    :    string    :=    "expansion_base_address_register";
        io_window_addr_width    :    string    :=    "window_32_bit";
        prefetchable_mem_window_addr_width    :    string    :=    "prefetch_32";
        skp_os_gen3_count_data    :    bit_vector    :=    B"00000000000";
        skp_os_gen3_count    :    string    :=    "skp_os_gen3_count";
        rx_cdc_almost_empty_data    :    bit_vector    :=    B"0000";
        rx_cdc_almost_empty    :    string    :=    "rx_cdc_almost_empty";
        tx_cdc_almost_empty_data    :    bit_vector    :=    B"0000";
        tx_cdc_almost_empty    :    string    :=    "tx_cdc_almost_empty";
        rx_cdc_almost_full_data    :    bit_vector    :=    B"0000";
        rx_cdc_almost_full    :    string    :=    "rx_cdc_almost_full";
        tx_cdc_almost_full_data    :    bit_vector    :=    B"0000";
        tx_cdc_almost_full    :    string    :=    "tx_cdc_almost_full";
        rx_l0s_count_idl_data    :    bit_vector    :=    B"00000000";
        rx_l0s_count_idl    :    string    :=    "rx_l0s_count_idl";
        cdc_dummy_insert_limit_data    :    bit_vector    :=    B"0000";
        cdc_dummy_insert_limit    :    string    :=    "cdc_dummy_insert_limit";
        ei_delay_powerdown_count_data    :    bit_vector    :=    B"00001010";
        ei_delay_powerdown_count    :    string    :=    "ei_delay_powerdown_count";
        millisecond_cycle_count_data    :    bit_vector    :=    B"00000000000000000000";
        millisecond_cycle_count    :    string    :=    "millisecond_cycle_count";
        skp_os_schedule_count_data    :    bit_vector    :=    B"00000000000";
        skp_os_schedule_count    :    string    :=    "skp_os_schedule_count";
        fc_init_timer_data    :    bit_vector    :=    B"10000000000";
        fc_init_timer    :    string    :=    "fc_init_timer";
        l01_entry_latency_data    :    bit_vector    :=    B"11111";
        l01_entry_latency    :    string    :=    "l01_entry_latency";
        flow_control_update_count_data    :    bit_vector    :=    B"11110";
        flow_control_update_count    :    string    :=    "flow_control_update_count";
        flow_control_timeout_count_data    :    bit_vector    :=    B"11001000";
        flow_control_timeout_count    :    string    :=    "flow_control_timeout_count";
        vc0_rx_flow_ctrl_posted_header_data    :    bit_vector    :=    B"00110010";
        vc0_rx_flow_ctrl_posted_header    :    string    :=    "vc0_rx_flow_ctrl_posted_header";
        vc0_rx_flow_ctrl_posted_data_data    :    bit_vector    :=    B"000101101000";
        vc0_rx_flow_ctrl_posted_data    :    string    :=    "vc0_rx_flow_ctrl_posted_data";
        vc0_rx_flow_ctrl_nonposted_header_data    :    bit_vector    :=    B"00110110";
        vc0_rx_flow_ctrl_nonposted_header    :    string    :=    "vc0_rx_flow_ctrl_nonposted_header";
        vc0_rx_flow_ctrl_nonposted_data_data    :    bit_vector    :=    B"00000000";
        vc0_rx_flow_ctrl_nonposted_data    :    string    :=    "vc0_rx_flow_ctrl_nonposted_data";
        vc0_rx_flow_ctrl_compl_header_data    :    bit_vector    :=    B"01110000";
        vc0_rx_flow_ctrl_compl_header    :    string    :=    "vc0_rx_flow_ctrl_compl_header";
        vc0_rx_flow_ctrl_compl_data_data    :    bit_vector    :=    B"000111000000";
        vc0_rx_flow_ctrl_compl_data    :    string    :=    "vc0_rx_flow_ctrl_compl_data";
        rx_ptr0_posted_dpram_min_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_posted_dpram_min    :    string    :=    "rx_ptr0_posted_dpram_min";
        rx_ptr0_posted_dpram_max_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_posted_dpram_max    :    string    :=    "rx_ptr0_posted_dpram_max";
        rx_ptr0_nonposted_dpram_min_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_nonposted_dpram_min    :    string    :=    "rx_ptr0_nonposted_dpram_min";
        rx_ptr0_nonposted_dpram_max_data    :    bit_vector    :=    B"00000000000";
        rx_ptr0_nonposted_dpram_max    :    string    :=    "rx_ptr0_nonposted_dpram_max";
        retry_buffer_last_active_address_data    :    bit_vector    :=    B"1111111111";
        retry_buffer_last_active_address    :    string    :=    "retry_buffer_last_active_address";
        retry_buffer_memory_settings_data    :    bit_vector    :=    B"000000000000000000000000000000";
        retry_buffer_memory_settings    :    string    :=    "retry_buffer_memory_settings";
        vc0_rx_buffer_memory_settings_data    :    bit_vector    :=    B"000000000000000000000000000000";
        vc0_rx_buffer_memory_settings    :    string    :=    "vc0_rx_buffer_memory_settings";
        bist_memory_settings_data    :    bit_vector    :=    B"000000000000000000000000000000000000000000000000000000000000000000000000000";
        bist_memory_settings    :    string    :=    "bist_memory_settings";
        credit_buffer_allocation_aux    :    string    :=    "balanced";
        iei_enable_settings    :    string    :=    "gen2_infei_infsd_gen1_infei_sd";
        vsec_id_data    :    bit_vector    :=    B"0001000101110010";
        vsec_id    :    string    :=    "vsec_id";
        cvp_rate_sel    :    string    :=    "full_rate";
        hard_reset_bypass    :    string    :=    "false";
        cvp_data_compressed    :    string    :=    "false";
        cvp_data_encrypted    :    string    :=    "false";
        cvp_mode_reset    :    string    :=    "false";
        cvp_clk_reset    :    string    :=    "false";
        vsec_cap_data    :    bit_vector    :=    B"0000";
        vsec_cap    :    string    :=    "vsec_cap";
        jtag_id_data    :    bit_vector    :=    B"00000000000000000000000000000000";
        jtag_id    :    string    :=    "jtag_id";
        user_id_data    :    bit_vector    :=    B"0000000000000000";
        user_id    :    string    :=    "user_id";
        cseb_extend_pci    :    string    :=    "false";
        cseb_extend_pcie    :    string    :=    "false";
        cseb_cpl_status_during_cvp    :    string    :=    "config_retry_status";
        cseb_route_to_avl_rx_st    :    string    :=    "cseb";
        cseb_config_bypass    :    string    :=    "disable";
        cseb_cpl_tag_checking    :    string    :=    "enable";
        cseb_bar_match_checking    :    string    :=    "enable";
        cseb_min_error_checking    :    string    :=    "false";
        cseb_temp_busy_crs    :    string    :=    "completer_abort";
        cseb_disable_auto_crs    :    string    :=    "false";
        gen3_diffclock_nfts_count_data    :    bit_vector    :=    B"10000000";
        gen3_diffclock_nfts_count    :    string    :=    "g3_diffclock_nfts_count";
        gen3_sameclock_nfts_count_data    :    bit_vector    :=    B"10000000";
        gen3_sameclock_nfts_count    :    string    :=    "g3_sameclock_nfts_count";
        gen3_coeff_errchk    :    string    :=    "enable";
        gen3_paritychk    :    string    :=    "enable";
        gen3_coeff_delay_count_data    :    bit_vector    :=    B"1111101";
        gen3_coeff_delay_count    :    string    :=    "g3_coeff_dly_count";
        gen3_coeff_1_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_1    :    string    :=    "g3_coeff_1";
        gen3_coeff_1_sel    :    string    :=    "coeff_1";
        gen3_coeff_1_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_1_preset_hint    :    string    :=    "g3_coeff_1_prst_hint";
        gen3_coeff_1_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_1_nxtber_more    :    string    :=    "g3_coeff_1_nxtber_more";
        gen3_coeff_1_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_1_nxtber_less    :    string    :=    "g3_coeff_1_nxtber_less";
        gen3_coeff_1_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_1_reqber    :    string    :=    "g3_coeff_1_reqber";
        gen3_coeff_1_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_1_ber_meas    :    string    :=    "g3_coeff_1_ber_meas";
        gen3_coeff_2_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_2    :    string    :=    "g3_coeff_2";
        gen3_coeff_2_sel    :    string    :=    "coeff_2";
        gen3_coeff_2_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_2_preset_hint    :    string    :=    "g3_coeff_2_prst_hint";
        gen3_coeff_2_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_2_nxtber_more    :    string    :=    "g3_coeff_2_nxtber_more";
        gen3_coeff_2_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_2_nxtber_less    :    string    :=    "g3_coeff_2_nxtber_less";
        gen3_coeff_2_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_2_reqber    :    string    :=    "g3_coeff_2_reqber";
        gen3_coeff_2_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_2_ber_meas    :    string    :=    "g3_coeff_1_ber_meas";
        gen3_coeff_3_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_3    :    string    :=    "g3_coeff_3";
        gen3_coeff_3_sel    :    string    :=    "coeff_3";
        gen3_coeff_3_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_3_preset_hint    :    string    :=    "g3_coeff_3_prst_hint";
        gen3_coeff_3_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_3_nxtber_more    :    string    :=    "g3_coeff_3_nxtber_more";
        gen3_coeff_3_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_3_nxtber_less    :    string    :=    "g3_coeff_3_nxtber_less";
        gen3_coeff_3_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_3_reqber    :    string    :=    "g3_coeff_3_reqber";
        gen3_coeff_3_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_3_ber_meas    :    string    :=    "g3_coeff_3_ber_meas";
        gen3_coeff_4_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_4    :    string    :=    "g3_coeff_4";
        gen3_coeff_4_sel    :    string    :=    "coeff_4";
        gen3_coeff_4_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_4_preset_hint    :    string    :=    "g3_coeff_4_prst_hint";
        gen3_coeff_4_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_4_nxtber_more    :    string    :=    "g3_coeff_4_nxtber_more";
        gen3_coeff_4_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_4_nxtber_less    :    string    :=    "g3_coeff_4_nxtber_less";
        gen3_coeff_4_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_4_reqber    :    string    :=    "g3_coeff_4_reqber";
        gen3_coeff_4_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_4_ber_meas    :    string    :=    "g3_coeff_4_ber_meas";
        gen3_coeff_5_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_5    :    string    :=    "g3_coeff_5";
        gen3_coeff_5_sel    :    string    :=    "coeff_5";
        gen3_coeff_5_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_5_preset_hint    :    string    :=    "g3_coeff_5_prst_hint";
        gen3_coeff_5_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_5_nxtber_more    :    string    :=    "g3_coeff_5_nxtber_more";
        gen3_coeff_5_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_5_nxtber_less    :    string    :=    "g3_coeff_5_nxtber_less";
        gen3_coeff_5_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_5_reqber    :    string    :=    "g3_coeff_5_reqber";
        gen3_coeff_5_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_5_ber_meas    :    string    :=    "g3_coeff_5_ber_meas";
        gen3_coeff_6_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_6    :    string    :=    "g3_coeff_6";
        gen3_coeff_6_sel    :    string    :=    "coeff_6";
        gen3_coeff_6_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_6_preset_hint    :    string    :=    "g3_coeff_6_prst_hint";
        gen3_coeff_6_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_6_nxtber_more    :    string    :=    "g3_coeff_6_nxtber_more";
        gen3_coeff_6_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_6_nxtber_less    :    string    :=    "g3_coeff_6_nxtber_less";
        gen3_coeff_6_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_6_reqber    :    string    :=    "g3_coeff_6_reqber";
        gen3_coeff_6_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_6_ber_meas    :    string    :=    "g3_coeff_6_ber_meas";
        gen3_coeff_7_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_7    :    string    :=    "g3_coeff_7";
        gen3_coeff_7_sel    :    string    :=    "coeff_7";
        gen3_coeff_7_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_7_preset_hint    :    string    :=    "g3_coeff_7_prst_hint";
        gen3_coeff_7_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_7_nxtber_more    :    string    :=    "g3_coeff_7_nxtber_more";
        gen3_coeff_7_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_7_nxtber_less    :    string    :=    "g3_coeff_7_nxtber_less";
        gen3_coeff_7_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_7_reqber    :    string    :=    "g3_coeff_7_reqber";
        gen3_coeff_7_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_7_ber_meas    :    string    :=    "g3_coeff_7_ber_meas";
        gen3_coeff_8_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_8    :    string    :=    "g3_coeff_8";
        gen3_coeff_8_sel    :    string    :=    "coeff_8";
        gen3_coeff_8_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_8_preset_hint    :    string    :=    "g3_coeff_8_prst_hint";
        gen3_coeff_8_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_8_nxtber_more    :    string    :=    "g3_coeff_8_nxtber_more";
        gen3_coeff_8_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_8_nxtber_less    :    string    :=    "g3_coeff_8_nxtber_less";
        gen3_coeff_8_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_8_reqber    :    string    :=    "g3_coeff_8_reqber";
        gen3_coeff_8_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_8_ber_meas    :    string    :=    "g3_coeff_8_ber_meas";
        gen3_coeff_9_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_9    :    string    :=    "g3_coeff_9";
        gen3_coeff_9_sel    :    string    :=    "coeff_9";
        gen3_coeff_9_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_9_preset_hint    :    string    :=    "g3_coeff_9_prst_hint";
        gen3_coeff_9_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_9_nxtber_more    :    string    :=    "g3_coeff_9_nxtber_more";
        gen3_coeff_9_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_9_nxtber_less    :    string    :=    "g3_coeff_9_nxtber_less";
        gen3_coeff_9_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_9_reqber    :    string    :=    "g3_coeff_9_reqber";
        gen3_coeff_9_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_9_ber_meas    :    string    :=    "g3_coeff_9_ber_meas";
        gen3_coeff_10_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_10    :    string    :=    "g3_coeff_10";
        gen3_coeff_10_sel    :    string    :=    "coeff_10";
        gen3_coeff_10_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_10_preset_hint    :    string    :=    "g3_coeff_10_prst_hint";
        gen3_coeff_10_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_10_nxtber_more    :    string    :=    "g3_coeff_10_nxtber_more";
        gen3_coeff_10_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_10_nxtber_less    :    string    :=    "g3_coeff_10_nxtber_less";
        gen3_coeff_10_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_10_reqber    :    string    :=    "g3_coeff_10_reqber";
        gen3_coeff_10_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_10_ber_meas    :    string    :=    "g3_coeff_10_ber_meas";
        gen3_coeff_11_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_11    :    string    :=    "g3_coeff_11";
        gen3_coeff_11_sel    :    string    :=    "coeff_11";
        gen3_coeff_11_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_11_preset_hint    :    string    :=    "g3_coeff_11_prst_hint";
        gen3_coeff_11_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_11_nxtber_more    :    string    :=    "g3_coeff_11_nxtber_more";
        gen3_coeff_11_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_11_nxtber_less    :    string    :=    "g3_coeff_11_nxtber_less";
        gen3_coeff_11_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_11_reqber    :    string    :=    "g3_coeff_11_reqber";
        gen3_coeff_11_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_11_ber_meas    :    string    :=    "g3_coeff_11_ber_meas";
        gen3_coeff_12_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_12    :    string    :=    "g3_coeff_12";
        gen3_coeff_12_sel    :    string    :=    "coeff_12";
        gen3_coeff_12_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_12_preset_hint    :    string    :=    "g3_coeff_12_prst_hint";
        gen3_coeff_12_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_12_nxtber_more    :    string    :=    "g3_coeff_12_nxtber_more";
        gen3_coeff_12_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_12_nxtber_less    :    string    :=    "g3_coeff_12_nxtber_less";
        gen3_coeff_12_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_12_reqber    :    string    :=    "g3_coeff_12_reqber";
        gen3_coeff_12_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_12_ber_meas    :    string    :=    "g3_coeff_12_ber_meas";
        gen3_coeff_13_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_13    :    string    :=    "g3_coeff_13";
        gen3_coeff_13_sel    :    string    :=    "coeff_13";
        gen3_coeff_13_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_13_preset_hint    :    string    :=    "g3_coeff_13_prst_hint";
        gen3_coeff_13_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_13_nxtber_more    :    string    :=    "g3_coeff_13_nxtber_more";
        gen3_coeff_13_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_13_nxtber_less    :    string    :=    "g3_coeff_13_nxtber_less";
        gen3_coeff_13_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_13_reqber    :    string    :=    "g3_coeff_13_reqber";
        gen3_coeff_13_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_13_ber_meas    :    string    :=    "g3_coeff_13_ber_meas";
        gen3_coeff_14_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_14    :    string    :=    "g3_coeff_14";
        gen3_coeff_14_sel    :    string    :=    "coeff_14";
        gen3_coeff_14_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_14_preset_hint    :    string    :=    "g3_coeff_14_prst_hint";
        gen3_coeff_14_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_14_nxtber_more    :    string    :=    "g3_coeff_14_nxtber_more";
        gen3_coeff_14_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_14_nxtber_less    :    string    :=    "g3_coeff_14_nxtber_less";
        gen3_coeff_14_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_14_reqber    :    string    :=    "g3_coeff_14_reqber";
        gen3_coeff_14_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_14_ber_meas    :    string    :=    "g3_coeff_14_ber_meas";
        gen3_coeff_15_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_15    :    string    :=    "g3_coeff_15";
        gen3_coeff_15_sel    :    string    :=    "coeff_15";
        gen3_coeff_15_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_15_preset_hint    :    string    :=    "g3_coeff_15_prst_hint";
        gen3_coeff_15_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_15_nxtber_more    :    string    :=    "g3_coeff_15_nxtber_more";
        gen3_coeff_15_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_15_nxtber_less    :    string    :=    "g3_coeff_15_nxtber_less";
        gen3_coeff_15_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_15_reqber    :    string    :=    "g3_coeff_15_reqber";
        gen3_coeff_15_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_15_ber_meas    :    string    :=    "g3_coeff_15_ber_meas";
        gen3_coeff_16_data    :    bit_vector    :=    B"000000000000000000";
        gen3_coeff_16    :    string    :=    "g3_coeff_16";
        gen3_coeff_16_sel    :    string    :=    "coeff_16";
        gen3_coeff_16_preset_hint_data    :    bit_vector    :=    B"000";
        gen3_coeff_16_preset_hint    :    string    :=    "g3_coeff_16_prst_hint";
        gen3_coeff_16_nxtber_more_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_16_nxtber_more    :    string    :=    "g3_coeff_16_nxtber_more";
        gen3_coeff_16_nxtber_less_ptr    :    bit_vector    :=    B"0000";
        gen3_coeff_16_nxtber_less    :    string    :=    "g3_coeff_16_nxtber_less";
        gen3_coeff_16_reqber_data    :    bit_vector    :=    B"00000";
        gen3_coeff_16_reqber    :    string    :=    "g3_coeff_16_reqber";
        gen3_coeff_16_ber_meas_data    :    bit_vector    :=    B"000000";
        gen3_coeff_16_ber_meas    :    string    :=    "g3_coeff_16_ber_meas";
        gen3_preset_coeff_1_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_1    :    string    :=    "g3_prst_coeff_1";
        gen3_preset_coeff_2_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_2    :    string    :=    "g3_prst_coeff_2";
        gen3_preset_coeff_3_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_3    :    string    :=    "g3_prst_coeff_3";
        gen3_preset_coeff_4_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_4    :    string    :=    "g3_prst_coeff_4";
        gen3_preset_coeff_5_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_5    :    string    :=    "g3_prst_coeff_5";
        gen3_preset_coeff_6_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_6    :    string    :=    "g3_prst_coeff_6";
        gen3_preset_coeff_7_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_7    :    string    :=    "g3_prst_coeff_7";
        gen3_preset_coeff_8_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_8    :    string    :=    "g3_prst_coeff_8";
        gen3_preset_coeff_9_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_9    :    string    :=    "g3_prst_coeff_9";
        gen3_preset_coeff_10_data    :    bit_vector    :=    B"000000000000000000";
        gen3_preset_coeff_10    :    string    :=    "g3_prst_coeff_10";
        gen3_rxfreqlock_counter_data    :    bit_vector    :=    "00000000000000000000";
        gen3_rxfreqlock_counter    :    string    :=    "g3_rxfreqlock_count";
        rstctrl_pld_clr                    : string := "false";-- "false", "true".
        rstctrl_debug_en                   : string := "false";-- "false", "true".
        rstctrl_force_inactive_rst         : string := "false";-- "false", "true".
        rstctrl_perst_enable               : string := "level";-- "level", "neg_edge", "not_used".
        hrdrstctrl_en                      : string := "hrdrstctrl_dis";--"hrdrstctrl_dis", "hrdrstctrl_en".
        rstctrl_hip_ep                     : string := "hip_ep";      --"hip_ep", "hip_not_ep".
        rstctrl_hard_block_enable          : string := "hard_rst_ctl";--"hard_rst_ctl", "pld_rst_ctl".
        rstctrl_rx_pma_rstb_inv            : string := "false";--"false", "true".
        rstctrl_tx_pma_rstb_inv            : string := "false";--"false", "true".
        rstctrl_rx_pcs_rst_n_inv           : string := "false";--"false", "true".
        rstctrl_tx_pcs_rst_n_inv           : string := "false";--"false", "true".
        rstctrl_altpe3_crst_n_inv          : string := "false";--"false", "true".
        rstctrl_altpe3_srst_n_inv          : string := "false";--"false", "true".
        rstctrl_altpe3_rst_n_inv           : string := "false";--"false", "true".
        rstctrl_tx_pma_syncp_inv           : string := "false";--"false", "true".
        rstctrl_1us_count_fref_clk         : string := "rstctrl_1us_cnt";--
        rstctrl_1us_count_fref_clk_value   : bit_vector := B"00000000000000111111";--
        rstctrl_1ms_count_fref_clk         : string := "rstctrl_1ms_cnt";--
        rstctrl_1ms_count_fref_clk_value   : bit_vector := B"00001111010000100100";--
        rstctrl_off_cal_done_select        : string := "not_active";-- "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active".
        rstctrl_rx_pma_rstb_cmu_select     : string := "not_active";-- "ch1cmu_sel", "ch4cmu_sel", "ch4_10cmu_sel", "not_active".
        rstctrl_rx_pll_freq_lock_select    : string := "not_active";-- "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active", "ch0_phs_sel", "ch01_phs_sel", "ch0123_phs_sel", "ch0123_5678_phs_sel".
        rstctrl_mask_tx_pll_lock_select    : string := "not_active";-- "ch1_sel", "ch4_sel", "ch4_10_sel", "not_active".
        rstctrl_rx_pll_lock_select         : string := "not_active";-- "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active".
        rstctrl_perstn_select              : string := "perstn_pin";-- "perstn_pin", "perstn_pld".
        rstctrl_tx_lc_pll_rstb_select      : string := "not_active";-- "ch1_out", "ch7_out", "not_active".
        rstctrl_fref_clk_select            : string := "not_active";-- "ch0_sel", "ch1_sel", "ch2_sel", "ch3_sel", "ch4_sel", "ch5_sel", "ch6_sel", "ch7_sel", "ch8_sel", "ch9_sel", "ch10_sel", "ch11_sel".
        rstctrl_off_cal_en_select          : string := "not_active";-- "ch0_out", "ch01_out", "ch0123_out", "ch0123_5678_out", "not_active".
        rstctrl_tx_pma_syncp_select        : string := "not_active";-- "ch1_out", "ch4_out", "ch4_10_out", "not_active".
        rstctrl_rx_pcs_rst_n_select        : string := "not_active";-- "ch0_out", "ch01_out", "ch0123_out", "ch012345678_out", "ch012345678_10_out", "not_active".
        rstctrl_tx_cmu_pll_lock_select     : string := "not_active";-- "ch1_sel", "ch4_sel", "ch4_10_sel", "not_active".
        rstctrl_tx_pcs_rst_n_select        : string := "not_active";-- "ch0_out", "ch01_out", "ch0123_out", "ch012345678_out", "ch012345678_10_out", "not_active".
        rstctrl_tx_lc_pll_lock_select      : string := "not_active";-- "ch1_sel", "ch7_sel", "not_active".
        rstctrl_timer_a                    : string :=  "rstctrl_timer_a";
        rstctrl_timer_a_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_a_value              : bit_vector := B"00000001" ;
        rstctrl_timer_b                    : string :=  "rstctrl_timer_b";
        rstctrl_timer_b_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_b_value              : bit_vector := B"00000001";
        rstctrl_timer_c                    : string :=  "rstctrl_timer_c";
        rstctrl_timer_c_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_c_value              : bit_vector := B"00000001";
        rstctrl_timer_d                    : string :=  "rstctrl_timer_d";
        rstctrl_timer_d_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_d_value              : bit_vector := B"00000001";
        rstctrl_timer_e                    : string :=  "rstctrl_timer_e";
        rstctrl_timer_e_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_e_value              : bit_vector := B"00000001";
        rstctrl_timer_f                    : string :=  "rstctrl_timer_f";
        rstctrl_timer_f_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_f_value              : bit_vector := B"00000001";
        rstctrl_timer_g                    : string :=  "rstctrl_timer_g";
        rstctrl_timer_g_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_g_value              : bit_vector := B"00000001";
        rstctrl_timer_h                    : string :=  "rstctrl_timer_h";
        rstctrl_timer_h_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_h_value              : bit_vector := B"00000001";
        rstctrl_timer_i                    : string :=  "rstctrl_timer_i";
        rstctrl_timer_i_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_i_value              : bit_vector := B"00000001";
        rstctrl_timer_j                    : string :=  "rstctrl_timer_j";
        rstctrl_timer_j_type               : string :=  "milli_secs";--possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
        rstctrl_timer_j_value              : bit_vector := B"00000001"

    );
    port    (
        dpriostatus    :    out    std_logic_vector(15 downto 0);
        lmidout    :    out    std_logic_vector(31 downto 0);
        lmiack    :    out    std_logic_vector(0 downto 0);
        lmirden    :    in    std_logic_vector(0 downto 0);
        lmiwren    :    in    std_logic_vector(0 downto 0);
        lmiaddr    :    in    std_logic_vector(11 downto 0);
        lmidin    :    in    std_logic_vector(31 downto 0);
        flrreset    :    in    std_logic_vector(0 downto 0);
        flrsts    :    out    std_logic_vector(0 downto 0);
        resetstatus    :    out    std_logic_vector(0 downto 0);
        l2exit    :    out    std_logic_vector(0 downto 0);
        hotrstexit    :    out    std_logic_vector(0 downto 0);
        hiphardreset  :  in std_logic_vector(0 downto 0);
        dlupexit    :    out    std_logic_vector(0 downto 0);
        coreclkout    :    out    std_logic_vector(0 downto 0);
        pldclk    :    in    std_logic_vector(0 downto 0);
        pldsrst    :    in    std_logic_vector(0 downto 0);
        pldrst    :    in    std_logic_vector(0 downto 0);
        pclkch0    :    in    std_logic_vector(0 downto 0);
        pclkch1    :    in    std_logic_vector(0 downto 0);
        pclkcentral    :    in    std_logic_vector(0 downto 0);
        pllfixedclkch0    :    in    std_logic_vector(0 downto 0);
        pllfixedclkch1    :    in    std_logic_vector(0 downto 0);
        pllfixedclkcentral    :    in    std_logic_vector(0 downto 0);
        phyrst    :    in    std_logic_vector(0 downto 0);
        physrst    :    in    std_logic_vector(0 downto 0);
        coreclkin    :    in    std_logic_vector(0 downto 0);
        corerst    :    in    std_logic_vector(0 downto 0);
        corepor    :    in    std_logic_vector(0 downto 0);
        corecrst    :    in    std_logic_vector(0 downto 0);
        coresrst    :    in    std_logic_vector(0 downto 0);
        swdnout    :    out    std_logic_vector(6 downto 0);
        swupout    :    out    std_logic_vector(2 downto 0);
        swdnin    :    in    std_logic_vector(2 downto 0);
        swupin    :    in    std_logic_vector(6 downto 0);
        swctmod    :    in    std_logic_vector(1 downto 0);
        rxstdata    :    out    std_logic_vector(255 downto 0);
        rxstparity    :    out    std_logic_vector(31 downto 0);
        rxstbe    :    out    std_logic_vector(31 downto 0);
        rxsterr    :    out    std_logic_vector(3 downto 0);
        rxstsop    :    out    std_logic_vector(3 downto 0);
        rxsteop    :    out    std_logic_vector(3 downto 0);
        rxstempty    :    out    std_logic_vector(1 downto 0);
        rxstvalid    :    out    std_logic_vector(3 downto 0);
        rxstbardec1    :    out    std_logic_vector(7 downto 0);
        rxstbardec2    :    out    std_logic_vector(7 downto 0);
        rxstmask    :    in    std_logic_vector(0 downto 0);
        rxstready    :    in    std_logic_vector(0 downto 0);
        txstready    :    out    std_logic_vector(0 downto 0);
        txcredfchipcons    :    out    std_logic_vector(5 downto 0);
        txcredfcinfinite    :    out    std_logic_vector(5 downto 0);
        txcredhdrfcp    :    out    std_logic_vector(7 downto 0);
        txcreddatafcp    :    out    std_logic_vector(11 downto 0);
        txcredhdrfcnp    :    out    std_logic_vector(7 downto 0);
        txcreddatafcnp    :    out    std_logic_vector(11 downto 0);
        txcredhdrfccp    :    out    std_logic_vector(7 downto 0);
        txcreddatafccp    :    out    std_logic_vector(11 downto 0);
        txstdata    :    in    std_logic_vector(255 downto 0);
        txstparity    :    in    std_logic_vector(31 downto 0);
        txsterr    :    in    std_logic_vector(3 downto 0);
        txstsop    :    in    std_logic_vector(3 downto 0);
        txsteop    :    in    std_logic_vector(3 downto 0);
        txstempty    :    in    std_logic_vector(1 downto 0);
        txstvalid    :    in    std_logic_vector(0 downto 0);
        r2cuncecc    :    out    std_logic_vector(0 downto 0);
        rxcorrecc    :    out    std_logic_vector(0 downto 0);
        retryuncecc    :    out    std_logic_vector(0 downto 0);
        retrycorrecc    :    out    std_logic_vector(0 downto 0);
        rxparerr    :    out    std_logic_vector(0 downto 0);
        txparerr    :    out    std_logic_vector(1 downto 0);
        r2cparerr    :    out    std_logic_vector(0 downto 0);
        pmetosr    :    out    std_logic_vector(0 downto 0);
        pmetocr    :    in    std_logic_vector(0 downto 0);
        pmevent    :    in    std_logic_vector(0 downto 0);
        pmdata    :    in    std_logic_vector(9 downto 0);
        pmauxpwr    :    in    std_logic_vector(0 downto 0);
        tlcfgsts    :    out    std_logic_vector(52 downto 0);
        tlcfgctl    :    out    std_logic_vector(31 downto 0);
        tlcfgadd    :    out    std_logic_vector(3 downto 0);
        appintaack    :    out    std_logic_vector(0 downto 0);
        appintasts    :    in    std_logic_vector(0 downto 0);
        intstatus    :    out    std_logic_vector(3 downto 0);
        appmsiack    :    out    std_logic_vector(0 downto 0);
        appmsireq    :    in    std_logic_vector(0 downto 0);
        appmsitc    :    in    std_logic_vector(2 downto 0);
        appmsinum    :    in    std_logic_vector(4 downto 0);
        aermsinum    :    in    std_logic_vector(4 downto 0);
        pexmsinum    :    in    std_logic_vector(4 downto 0);
        hpgctrler    :    in    std_logic_vector(4 downto 0);
        cfglink2csrpld    :    in    std_logic_vector(12 downto 0);
        cfgprmbuspld    :    in    std_logic_vector(7 downto 0);
        csebisshadow    :    out    std_logic_vector(0 downto 0);
        csebwrdata    :    out    std_logic_vector(31 downto 0);
        csebwrdataparity    :    out    std_logic_vector(3 downto 0);
        csebbe    :    out    std_logic_vector(3 downto 0);
        csebaddr    :    out    std_logic_vector(32 downto 0);
        csebaddrparity    :    out    std_logic_vector(4 downto 0);
        csebwren    :    out    std_logic_vector(0 downto 0);
        csebrden    :    out    std_logic_vector(0 downto 0);
        csebwrrespreq    :    out    std_logic_vector(0 downto 0);
        csebrddata    :    in    std_logic_vector(31 downto 0);
        csebrddataparity    :    in    std_logic_vector(3 downto 0);
        csebwaitrequest    :    in    std_logic_vector(0 downto 0);
        csebwrrespvalid    :    in    std_logic_vector(0 downto 0);
        csebwrresponse    :    in    std_logic_vector(4 downto 0);
        csebrdresponse    :    in    std_logic_vector(4 downto 0);
        dlup    :    out    std_logic_vector(0 downto 0);
        testouthip    :    out    std_logic_vector(255 downto 0);
        testout1hip    :    out    std_logic_vector(63 downto 0);
        ev1us    :    out    std_logic_vector(0 downto 0);
        ev128ns    :    out    std_logic_vector(0 downto 0);
        wakeoen    :    out    std_logic_vector(0 downto 0);
        serrout    :    out    std_logic_vector(0 downto 0);
        ltssmstate    :    out    std_logic_vector(4 downto 0);
        laneact    :    out    std_logic_vector(3 downto 0);
        currentspeed    :    out    std_logic_vector(1 downto 0);
        slotclkcfg    :    in    std_logic_vector(0 downto 0);
        mode    :    in    std_logic_vector(1 downto 0);
        testinhip    :    in    std_logic_vector(31 downto 0);
        testin1hip    :    in    std_logic_vector(31 downto 0);
        cplpending    :    in    std_logic_vector(0 downto 0);
        cplerr    :    in    std_logic_vector(6 downto 0);
        appinterr    :    in    std_logic_vector(1 downto 0);
        egressblkerr    :    in    std_logic_vector(0 downto 0);
        pmexitd0ack    :    in    std_logic_vector(0 downto 0);
        pmexitd0req    :    out    std_logic_vector(0 downto 0);
        currentcoeff0    :    out    std_logic_vector(17 downto 0);
        currentcoeff1    :    out    std_logic_vector(17 downto 0);
        currentcoeff2    :    out    std_logic_vector(17 downto 0);
        currentcoeff3    :    out    std_logic_vector(17 downto 0);
        currentcoeff4    :    out    std_logic_vector(17 downto 0);
        currentcoeff5    :    out    std_logic_vector(17 downto 0);
        currentcoeff6    :    out    std_logic_vector(17 downto 0);
        currentcoeff7    :    out    std_logic_vector(17 downto 0);
        currentrxpreset0    :    out    std_logic_vector(2 downto 0);
        currentrxpreset1    :    out    std_logic_vector(2 downto 0);
        currentrxpreset2    :    out    std_logic_vector(2 downto 0);
        currentrxpreset3    :    out    std_logic_vector(2 downto 0);
        currentrxpreset4    :    out    std_logic_vector(2 downto 0);
        currentrxpreset5    :    out    std_logic_vector(2 downto 0);
        currentrxpreset6    :    out    std_logic_vector(2 downto 0);
        currentrxpreset7    :    out    std_logic_vector(2 downto 0);
        rate0    :    out    std_logic_vector(1 downto 0);
        rate1    :    out    std_logic_vector(1 downto 0);
        rate2    :    out    std_logic_vector(1 downto 0);
        rate3    :    out    std_logic_vector(1 downto 0);
        rate4    :    out    std_logic_vector(1 downto 0);
        rate5    :    out    std_logic_vector(1 downto 0);
        rate6    :    out    std_logic_vector(1 downto 0);
        rate7    :    out    std_logic_vector(1 downto 0);
        ratectrl    :    out    std_logic_vector(1 downto 0);
        ratetiedtognd    :    out    std_logic_vector(0 downto 0);
        eidleinfersel0    :    out    std_logic_vector(2 downto 0);
        eidleinfersel1    :    out    std_logic_vector(2 downto 0);
        eidleinfersel2    :    out    std_logic_vector(2 downto 0);
        eidleinfersel3    :    out    std_logic_vector(2 downto 0);
        eidleinfersel4    :    out    std_logic_vector(2 downto 0);
        eidleinfersel5    :    out    std_logic_vector(2 downto 0);
        eidleinfersel6    :    out    std_logic_vector(2 downto 0);
        eidleinfersel7    :    out    std_logic_vector(2 downto 0);
        txdata0    :    out    std_logic_vector(31 downto 0);
        txdatak0    :    out    std_logic_vector(3 downto 0);
        txdetectrx0    :    out    std_logic_vector(0 downto 0);
        txelecidle0    :    out    std_logic_vector(0 downto 0);
        txcompl0    :    out    std_logic_vector(0 downto 0);
        rxpolarity0    :    out    std_logic_vector(0 downto 0);
        powerdown0    :    out    std_logic_vector(1 downto 0);
        txdataskip0    :    out    std_logic_vector(0 downto 0);
        txblkst0    :    out    std_logic_vector(0 downto 0);
        txsynchd0    :    out    std_logic_vector(1 downto 0);
        txdeemph0    :    out    std_logic_vector(0 downto 0);
        txmargin0    :    out    std_logic_vector(2 downto 0);
        rxdata0    :    in    std_logic_vector(31 downto 0);
        rxdatak0    :    in    std_logic_vector(3 downto 0);
        rxvalid0    :    in    std_logic_vector(0 downto 0);
        phystatus0    :    in    std_logic_vector(0 downto 0);
        rxelecidle0    :    in    std_logic_vector(0 downto 0);
        rxstatus0    :    in    std_logic_vector(2 downto 0);
        rxdataskip0    :    in    std_logic_vector(0 downto 0);
        rxblkst0    :    in    std_logic_vector(0 downto 0);
        rxsynchd0    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked0    :    in    std_logic_vector(0 downto 0);
        txdata1    :    out    std_logic_vector(31 downto 0);
        txdatak1    :    out    std_logic_vector(3 downto 0);
        txdetectrx1    :    out    std_logic_vector(0 downto 0);
        txelecidle1    :    out    std_logic_vector(0 downto 0);
        txcompl1    :    out    std_logic_vector(0 downto 0);
        rxpolarity1    :    out    std_logic_vector(0 downto 0);
        powerdown1    :    out    std_logic_vector(1 downto 0);
        txdataskip1    :    out    std_logic_vector(0 downto 0);
        txblkst1    :    out    std_logic_vector(0 downto 0);
        txsynchd1    :    out    std_logic_vector(1 downto 0);
        txdeemph1    :    out    std_logic_vector(0 downto 0);
        txmargin1    :    out    std_logic_vector(2 downto 0);
        rxdata1    :    in    std_logic_vector(31 downto 0);
        rxdatak1    :    in    std_logic_vector(3 downto 0);
        rxvalid1    :    in    std_logic_vector(0 downto 0);
        phystatus1    :    in    std_logic_vector(0 downto 0);
        rxelecidle1    :    in    std_logic_vector(0 downto 0);
        rxstatus1    :    in    std_logic_vector(2 downto 0);
        rxdataskip1    :    in    std_logic_vector(0 downto 0);
        rxblkst1    :    in    std_logic_vector(0 downto 0);
        rxsynchd1    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked1    :    in    std_logic_vector(0 downto 0);
        txdata2    :    out    std_logic_vector(31 downto 0);
        txdatak2    :    out    std_logic_vector(3 downto 0);
        txdetectrx2    :    out    std_logic_vector(0 downto 0);
        txelecidle2    :    out    std_logic_vector(0 downto 0);
        txcompl2    :    out    std_logic_vector(0 downto 0);
        rxpolarity2    :    out    std_logic_vector(0 downto 0);
        powerdown2    :    out    std_logic_vector(1 downto 0);
        txdataskip2    :    out    std_logic_vector(0 downto 0);
        txblkst2    :    out    std_logic_vector(0 downto 0);
        txsynchd2    :    out    std_logic_vector(1 downto 0);
        txdeemph2    :    out    std_logic_vector(0 downto 0);
        txmargin2    :    out    std_logic_vector(2 downto 0);
        rxdata2    :    in    std_logic_vector(31 downto 0);
        rxdatak2    :    in    std_logic_vector(3 downto 0);
        rxvalid2    :    in    std_logic_vector(0 downto 0);
        phystatus2    :    in    std_logic_vector(0 downto 0);
        rxelecidle2    :    in    std_logic_vector(0 downto 0);
        rxstatus2    :    in    std_logic_vector(2 downto 0);
        rxdataskip2    :    in    std_logic_vector(0 downto 0);
        rxblkst2    :    in    std_logic_vector(0 downto 0);
        rxsynchd2    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked2    :    in    std_logic_vector(0 downto 0);
        txdata3    :    out    std_logic_vector(31 downto 0);
        txdatak3    :    out    std_logic_vector(3 downto 0);
        txdetectrx3    :    out    std_logic_vector(0 downto 0);
        txelecidle3    :    out    std_logic_vector(0 downto 0);
        txcompl3    :    out    std_logic_vector(0 downto 0);
        rxpolarity3    :    out    std_logic_vector(0 downto 0);
        powerdown3    :    out    std_logic_vector(1 downto 0);
        txdataskip3    :    out    std_logic_vector(0 downto 0);
        txblkst3    :    out    std_logic_vector(0 downto 0);
        txsynchd3    :    out    std_logic_vector(1 downto 0);
        txdeemph3    :    out    std_logic_vector(0 downto 0);
        txmargin3    :    out    std_logic_vector(2 downto 0);
        rxdata3    :    in    std_logic_vector(31 downto 0);
        rxdatak3    :    in    std_logic_vector(3 downto 0);
        rxvalid3    :    in    std_logic_vector(0 downto 0);
        phystatus3    :    in    std_logic_vector(0 downto 0);
        rxelecidle3    :    in    std_logic_vector(0 downto 0);
        rxstatus3    :    in    std_logic_vector(2 downto 0);
        rxdataskip3    :    in    std_logic_vector(0 downto 0);
        rxblkst3    :    in    std_logic_vector(0 downto 0);
        rxsynchd3    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked3    :    in    std_logic_vector(0 downto 0);
        txdata4    :    out    std_logic_vector(31 downto 0);
        txdatak4    :    out    std_logic_vector(3 downto 0);
        txdetectrx4    :    out    std_logic_vector(0 downto 0);
        txelecidle4    :    out    std_logic_vector(0 downto 0);
        txcompl4    :    out    std_logic_vector(0 downto 0);
        rxpolarity4    :    out    std_logic_vector(0 downto 0);
        powerdown4    :    out    std_logic_vector(1 downto 0);
        txdataskip4    :    out    std_logic_vector(0 downto 0);
        txblkst4    :    out    std_logic_vector(0 downto 0);
        txsynchd4    :    out    std_logic_vector(1 downto 0);
        txdeemph4    :    out    std_logic_vector(0 downto 0);
        txmargin4    :    out    std_logic_vector(2 downto 0);
        rxdata4    :    in    std_logic_vector(31 downto 0);
        rxdatak4    :    in    std_logic_vector(3 downto 0);
        rxvalid4    :    in    std_logic_vector(0 downto 0);
        phystatus4    :    in    std_logic_vector(0 downto 0);
        rxelecidle4    :    in    std_logic_vector(0 downto 0);
        rxstatus4    :    in    std_logic_vector(2 downto 0);
        rxdataskip4    :    in    std_logic_vector(0 downto 0);
        rxblkst4    :    in    std_logic_vector(0 downto 0);
        rxsynchd4    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked4    :    in    std_logic_vector(0 downto 0);
        txdata5    :    out    std_logic_vector(31 downto 0);
        txdatak5    :    out    std_logic_vector(3 downto 0);
        txdetectrx5    :    out    std_logic_vector(0 downto 0);
        txelecidle5    :    out    std_logic_vector(0 downto 0);
        txcompl5    :    out    std_logic_vector(0 downto 0);
        rxpolarity5    :    out    std_logic_vector(0 downto 0);
        powerdown5    :    out    std_logic_vector(1 downto 0);
        txdataskip5    :    out    std_logic_vector(0 downto 0);
        txblkst5    :    out    std_logic_vector(0 downto 0);
        txsynchd5    :    out    std_logic_vector(1 downto 0);
        txdeemph5    :    out    std_logic_vector(0 downto 0);
        txmargin5    :    out    std_logic_vector(2 downto 0);
        rxdata5    :    in    std_logic_vector(31 downto 0);
        rxdatak5    :    in    std_logic_vector(3 downto 0);
        rxvalid5    :    in    std_logic_vector(0 downto 0);
        phystatus5    :    in    std_logic_vector(0 downto 0);
        rxelecidle5    :    in    std_logic_vector(0 downto 0);
        rxstatus5    :    in    std_logic_vector(2 downto 0);
        rxdataskip5    :    in    std_logic_vector(0 downto 0);
        rxblkst5    :    in    std_logic_vector(0 downto 0);
        rxsynchd5    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked5    :    in    std_logic_vector(0 downto 0);
        txdata6    :    out    std_logic_vector(31 downto 0);
        txdatak6    :    out    std_logic_vector(3 downto 0);
        txdetectrx6    :    out    std_logic_vector(0 downto 0);
        txelecidle6    :    out    std_logic_vector(0 downto 0);
        txcompl6    :    out    std_logic_vector(0 downto 0);
        rxpolarity6    :    out    std_logic_vector(0 downto 0);
        powerdown6    :    out    std_logic_vector(1 downto 0);
        txdataskip6    :    out    std_logic_vector(0 downto 0);
        txblkst6    :    out    std_logic_vector(0 downto 0);
        txsynchd6    :    out    std_logic_vector(1 downto 0);
        txdeemph6    :    out    std_logic_vector(0 downto 0);
        txmargin6    :    out    std_logic_vector(2 downto 0);
        rxdata6    :    in    std_logic_vector(31 downto 0);
        rxdatak6    :    in    std_logic_vector(3 downto 0);
        rxvalid6    :    in    std_logic_vector(0 downto 0);
        phystatus6    :    in    std_logic_vector(0 downto 0);
        rxelecidle6    :    in    std_logic_vector(0 downto 0);
        rxstatus6    :    in    std_logic_vector(2 downto 0);
        rxdataskip6    :    in    std_logic_vector(0 downto 0);
        rxblkst6    :    in    std_logic_vector(0 downto 0);
        rxsynchd6    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked6    :    in    std_logic_vector(0 downto 0);
        txdata7    :    out    std_logic_vector(31 downto 0);
        txdatak7    :    out    std_logic_vector(3 downto 0);
        txdetectrx7    :    out    std_logic_vector(0 downto 0);
        txelecidle7    :    out    std_logic_vector(0 downto 0);
        txcompl7    :    out    std_logic_vector(0 downto 0);
        rxpolarity7    :    out    std_logic_vector(0 downto 0);
        powerdown7    :    out    std_logic_vector(1 downto 0);
        txdataskip7    :    out    std_logic_vector(0 downto 0);
        txblkst7    :    out    std_logic_vector(0 downto 0);
        txsynchd7    :    out    std_logic_vector(1 downto 0);
        txdeemph7    :    out    std_logic_vector(0 downto 0);
        txmargin7    :    out    std_logic_vector(2 downto 0);
        rxdata7    :    in    std_logic_vector(31 downto 0);
        rxdatak7    :    in    std_logic_vector(3 downto 0);
        rxvalid7    :    in    std_logic_vector(0 downto 0);
        phystatus7    :    in    std_logic_vector(0 downto 0);
        rxelecidle7    :    in    std_logic_vector(0 downto 0);
        rxstatus7    :    in    std_logic_vector(2 downto 0);
        rxdataskip7    :    in    std_logic_vector(0 downto 0);
        rxblkst7    :    in    std_logic_vector(0 downto 0);
        rxsynchd7    :    in    std_logic_vector(1 downto 0);
        rxfreqlocked7    :    in    std_logic_vector(0 downto 0);
        dbgpipex1rx    :    in    std_logic_vector(43 downto 0);
        memredsclk    :    in    std_logic_vector(0 downto 0);
        memredenscan    :    in    std_logic_vector(0 downto 0);
        memredscen    :    in    std_logic_vector(0 downto 0);
        memredscin    :    in    std_logic_vector(0 downto 0);
        memredscsel    :    in    std_logic_vector(0 downto 0);
        memredscrst    :    in    std_logic_vector(0 downto 0);
        memredscout    :    out    std_logic_vector(0 downto 0);
        memregscanen    :    in    std_logic_vector(0 downto 0);
        memregscanin    :    in    std_logic_vector(0 downto 0);
        memhiptestenable    :    in    std_logic_vector(0 downto 0);
        memregscanout    :    out    std_logic_vector(0 downto 0);
        bisttesten    :    in    std_logic_vector(0 downto 0);
        bistenrpl    :    in    std_logic_vector(0 downto 0);
        bistscanin    :    in    std_logic_vector(0 downto 0);
        bistscanen    :    in    std_logic_vector(0 downto 0);
        bistenrcv    :    in    std_logic_vector(0 downto 0);
        bistscanoutrpl    :    out    std_logic_vector(0 downto 0);
        bistdonearpl    :    out    std_logic_vector(0 downto 0);
        bistdonebrpl    :    out    std_logic_vector(0 downto 0);
        bistpassrpl    :    out    std_logic_vector(0 downto 0);
        derrrpl    :    out    std_logic_vector(0 downto 0);
        derrcorextrpl    :    out    std_logic_vector(0 downto 0);
        bistscanoutrcv    :    out    std_logic_vector(0 downto 0);
        bistdonearcv    :    out    std_logic_vector(0 downto 0);
        bistdonebrcv    :    out    std_logic_vector(0 downto 0);
        bistpassrcv    :    out    std_logic_vector(0 downto 0);
        derrcorextrcv    :    out    std_logic_vector(0 downto 0);
        bistscanoutrcv1    :    out    std_logic_vector(0 downto 0);
        bistdonearcv1    :    out    std_logic_vector(0 downto 0);
        bistdonebrcv1    :    out    std_logic_vector(0 downto 0);
        bistpassrcv1    :    out    std_logic_vector(0 downto 0);
        derrcorextrcv1    :    out    std_logic_vector(0 downto 0);
        scanmoden    :    in    std_logic_vector(0 downto 0);
        scanshiftn    :    in    std_logic_vector(0 downto 0);
        nfrzdrv    :    in    std_logic_vector(0 downto 0);
        frzreg    :    in    std_logic_vector(0 downto 0);
        frzlogic    :    in    std_logic_vector(0 downto 0);
        idrpl    :    in    std_logic_vector(7 downto 0);
        idrcv    :    in    std_logic_vector(7 downto 0);
        plniotri    :    in    std_logic_vector(0 downto 0);
        entest    :    in    std_logic_vector(0 downto 0);
        npor    :    in    std_logic_vector(0 downto 0);
        usermode    :    in    std_logic_vector(0 downto 0);
        cvpclk    :    out    std_logic_vector(0 downto 0);
        cvpdata    :    out    std_logic_vector(31 downto 0);
        cvpstartxfer    :    out    std_logic_vector(0 downto 0);
        cvpconfig    :    out    std_logic_vector(0 downto 0);
        cvpfullconfig    :    out    std_logic_vector(0 downto 0);
        cvpconfigready    :    in    std_logic_vector(0 downto 0);
        cvpen    :    in    std_logic_vector(0 downto 0);
        cvpconfigerror    :    in    std_logic_vector(0 downto 0);
        cvpconfigdone    :    in    std_logic_vector(0 downto 0);
        pinperstn    :    in    std_logic_vector(0 downto 0);
        pldperstn    :    in    std_logic_vector(0 downto 0);
        iocsrrdydly    :    in    std_logic_vector(0 downto 0);
        softaltpe3rstn    :    in    std_logic_vector(0 downto 0);
        softaltpe3srstn    :    in    std_logic_vector(0 downto 0);
        softaltpe3crstn    :    in    std_logic_vector(0 downto 0);
        pldclrpmapcshipn    :    in    std_logic_vector(0 downto 0);
        pldclrpcshipn    :    in    std_logic_vector(0 downto 0);
        pldclrhipn    :    in    std_logic_vector(0 downto 0);
        s0ch0emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s0ch1emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s0ch2emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s1ch0emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s1ch1emsiptieoff    :    out    std_logic_vector(188 downto 0);
        s1ch2emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s2ch0emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s2ch1emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s2ch2emsiptieoff    :    out    std_logic_vector(100 downto 0);
        s3ch0emsiptieoff    :    out    std_logic_vector(188 downto 0);
        s3ch1emsiptieoff    :    out    std_logic_vector(188 downto 0);
        s3ch2emsiptieoff    :    out    std_logic_vector(188 downto 0);
        emsiptieofftop    :    out    std_logic_vector(299 downto 0);
        emsiptieoffbot    :    out    std_logic_vector(299 downto 0);

        txpcsrstn0                 : out std_logic_vector(0 downto 0);
        rxpcsrstn0                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn0               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn0               : out std_logic_vector(0 downto 0);
        txpmasyncp0                : out std_logic_vector(0 downto 0);
        rxpmarstb0                 : out std_logic_vector(0 downto 0);
        txlcpllrstb0               : out std_logic_vector(0 downto 0);
        offcalen0                  : out std_logic_vector(0 downto 0);
        frefclk0                   : in  std_logic_vector(0 downto 0);
        offcaldone0                : in  std_logic_vector(0 downto 0);
        txlcplllock0               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock0        : in  std_logic_vector(0 downto 0);
        rxpllphaselock0            : in  std_logic_vector(0 downto 0);
        masktxplllock0             : in  std_logic_vector(0 downto 0);
        txpcsrstn1                 : out std_logic_vector(0 downto 0);
        rxpcsrstn1                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn1               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn1               : out std_logic_vector(0 downto 0);
        txpmasyncp1                : out std_logic_vector(0 downto 0);
        rxpmarstb1                 : out std_logic_vector(0 downto 0);
        txlcpllrstb1               : out std_logic_vector(0 downto 0);
        offcalen1                  : out std_logic_vector(0 downto 0);
        frefclk1                   : in  std_logic_vector(0 downto 0);
        offcaldone1                : in  std_logic_vector(0 downto 0);
        txlcplllock1               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock1        : in  std_logic_vector(0 downto 0);
        rxpllphaselock1            : in  std_logic_vector(0 downto 0);
        masktxplllock1             : in  std_logic_vector(0 downto 0);
        txpcsrstn2                 : out std_logic_vector(0 downto 0);
        rxpcsrstn2                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn2               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn2               : out std_logic_vector(0 downto 0);
        txpmasyncp2                : out std_logic_vector(0 downto 0);
        rxpmarstb2                 : out std_logic_vector(0 downto 0);
        txlcpllrstb2               : out std_logic_vector(0 downto 0);
        offcalen2                  : out std_logic_vector(0 downto 0);
        frefclk2                   : in  std_logic_vector(0 downto 0);
        offcaldone2                : in  std_logic_vector(0 downto 0);
        txlcplllock2               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock2        : in  std_logic_vector(0 downto 0);
        rxpllphaselock2            : in  std_logic_vector(0 downto 0);
        masktxplllock2             : in  std_logic_vector(0 downto 0);
        txpcsrstn3                 : out std_logic_vector(0 downto 0);
        rxpcsrstn3                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn3               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn3               : out std_logic_vector(0 downto 0);
        txpmasyncp3                : out std_logic_vector(0 downto 0);
        rxpmarstb3                 : out std_logic_vector(0 downto 0);
        txlcpllrstb3               : out std_logic_vector(0 downto 0);
        offcalen3                  : out std_logic_vector(0 downto 0);
        frefclk3                   : in  std_logic_vector(0 downto 0);
        offcaldone3                : in  std_logic_vector(0 downto 0);
        txlcplllock3               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock3        : in  std_logic_vector(0 downto 0);
        rxpllphaselock3            : in  std_logic_vector(0 downto 0);
        masktxplllock3             : in  std_logic_vector(0 downto 0);
        txpcsrstn4                 : out std_logic_vector(0 downto 0);
        rxpcsrstn4                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn4               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn4               : out std_logic_vector(0 downto 0);
        txpmasyncp4                : out std_logic_vector(0 downto 0);
        rxpmarstb4                 : out std_logic_vector(0 downto 0);
        txlcpllrstb4               : out std_logic_vector(0 downto 0);
        offcalen4                  : out std_logic_vector(0 downto 0);
        frefclk4                   : in  std_logic_vector(0 downto 0);
        offcaldone4                : in  std_logic_vector(0 downto 0);
        txlcplllock4               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock4        : in  std_logic_vector(0 downto 0);
        rxpllphaselock4            : in  std_logic_vector(0 downto 0);
        masktxplllock4             : in  std_logic_vector(0 downto 0);
        txpcsrstn5                 : out std_logic_vector(0 downto 0);
        rxpcsrstn5                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn5               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn5               : out std_logic_vector(0 downto 0);
        txpmasyncp5                : out std_logic_vector(0 downto 0);
        rxpmarstb5                 : out std_logic_vector(0 downto 0);
        txlcpllrstb5               : out std_logic_vector(0 downto 0);
        offcalen5                  : out std_logic_vector(0 downto 0);
        frefclk5                   : in  std_logic_vector(0 downto 0);
        offcaldone5                : in  std_logic_vector(0 downto 0);
        txlcplllock5               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock5        : in  std_logic_vector(0 downto 0);
        rxpllphaselock5            : in  std_logic_vector(0 downto 0);
        masktxplllock5             : in  std_logic_vector(0 downto 0);
        txpcsrstn6                 : out std_logic_vector(0 downto 0);
        rxpcsrstn6                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn6               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn6               : out std_logic_vector(0 downto 0);
        txpmasyncp6                : out std_logic_vector(0 downto 0);
        rxpmarstb6                 : out std_logic_vector(0 downto 0);
        txlcpllrstb6               : out std_logic_vector(0 downto 0);
        offcalen6                  : out std_logic_vector(0 downto 0);
        frefclk6                   : in  std_logic_vector(0 downto 0);
        offcaldone6                : in  std_logic_vector(0 downto 0);
        txlcplllock6               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock6        : in  std_logic_vector(0 downto 0);
        rxpllphaselock6            : in  std_logic_vector(0 downto 0);
        masktxplllock6             : in  std_logic_vector(0 downto 0);
        txpcsrstn7                 : out std_logic_vector(0 downto 0);
        rxpcsrstn7                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn7               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn7               : out std_logic_vector(0 downto 0);
        txpmasyncp7                : out std_logic_vector(0 downto 0);
        rxpmarstb7                 : out std_logic_vector(0 downto 0);
        txlcpllrstb7               : out std_logic_vector(0 downto 0);
        offcalen7                  : out std_logic_vector(0 downto 0);
        frefclk7                   : in  std_logic_vector(0 downto 0);
        offcaldone7                : in  std_logic_vector(0 downto 0);
        txlcplllock7               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock7        : in  std_logic_vector(0 downto 0);
        rxpllphaselock7            : in  std_logic_vector(0 downto 0);
        masktxplllock7             : in  std_logic_vector(0 downto 0);
        txpcsrstn8                 : out std_logic_vector(0 downto 0);
        rxpcsrstn8                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn8               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn8               : out std_logic_vector(0 downto 0);
        txpmasyncp8                : out std_logic_vector(0 downto 0);
        rxpmarstb8                 : out std_logic_vector(0 downto 0);
        txlcpllrstb8               : out std_logic_vector(0 downto 0);
        offcalen8                  : out std_logic_vector(0 downto 0);
        frefclk8                   : in  std_logic_vector(0 downto 0);
        offcaldone8                : in  std_logic_vector(0 downto 0);
        txlcplllock8               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock8        : in  std_logic_vector(0 downto 0);
        rxpllphaselock8            : in  std_logic_vector(0 downto 0);
        masktxplllock8             : in  std_logic_vector(0 downto 0);
        txpcsrstn9                 : out std_logic_vector(0 downto 0);
        rxpcsrstn9                 : out std_logic_vector(0 downto 0);
        g3txpcsrstn9               : out std_logic_vector(0 downto 0);
        g3rxpcsrstn9               : out std_logic_vector(0 downto 0);
        txpmasyncp9                : out std_logic_vector(0 downto 0);
        rxpmarstb9                 : out std_logic_vector(0 downto 0);
        txlcpllrstb9               : out std_logic_vector(0 downto 0);
        offcalen9                  : out std_logic_vector(0 downto 0);
        frefclk9                   : in  std_logic_vector(0 downto 0);
        offcaldone9                : in  std_logic_vector(0 downto 0);
        txlcplllock9               : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock9        : in  std_logic_vector(0 downto 0);
        rxpllphaselock9            : in  std_logic_vector(0 downto 0);
        masktxplllock9             : in  std_logic_vector(0 downto 0);
        txpcsrstn10                : out std_logic_vector(0 downto 0);
        rxpcsrstn10                : out std_logic_vector(0 downto 0);
        g3txpcsrstn10              : out std_logic_vector(0 downto 0);
        g3rxpcsrstn10              : out std_logic_vector(0 downto 0);
        txpmasyncp10               : out std_logic_vector(0 downto 0);
        rxpmarstb10                : out std_logic_vector(0 downto 0);
        txlcpllrstb10              : out std_logic_vector(0 downto 0);
        offcalen10                 : out std_logic_vector(0 downto 0);
        frefclk10                  : in  std_logic_vector(0 downto 0);
        offcaldone10               : in  std_logic_vector(0 downto 0);
        txlcplllock10              : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock10       : in  std_logic_vector(0 downto 0);
        rxpllphaselock10           : in  std_logic_vector(0 downto 0);
        masktxplllock10            : in  std_logic_vector(0 downto 0);
        txpcsrstn11                : out std_logic_vector(0 downto 0);
        rxpcsrstn11                : out std_logic_vector(0 downto 0);
        g3txpcsrstn11              : out std_logic_vector(0 downto 0);
        g3rxpcsrstn11              : out std_logic_vector(0 downto 0);
        txpmasyncp11               : out std_logic_vector(0 downto 0);
        rxpmarstb11                : out std_logic_vector(0 downto 0);
        txlcpllrstb11              : out std_logic_vector(0 downto 0);
        offcalen11                 : out std_logic_vector(0 downto 0);
        frefclk11                  : in  std_logic_vector(0 downto 0);
        offcaldone11               : in  std_logic_vector(0 downto 0);
        txlcplllock11              : in  std_logic_vector(0 downto 0);
        rxfreqtxcmuplllock11       : in  std_logic_vector(0 downto 0);
        rxpllphaselock11           : in  std_logic_vector(0 downto 0);
        masktxplllock11            : in  std_logic_vector(0 downto 0);

        reservedin    :    in    std_logic_vector(31 downto 0);
        reservedclkin    :    in    std_logic_vector(0 downto 0);
        reservedout    :    out    std_logic_vector(31 downto 0);
        reservedclkout    :    out    std_logic_vector(0 downto 0)
    );
end component;

begin


inst : stratixv_hssi_gen3_pcie_hip_encrypted
    generic  map  (
        func_mode    =>   func_mode,
        in_cvp_mode    => in_cvp_mode,
        bonding_mode    =>   bonding_mode,
        prot_mode    =>   prot_mode,
        pcie_spec_1p0_compliance    =>   pcie_spec_1p0_compliance,
        vc_enable    =>   vc_enable,
        enable_slot_register    =>   enable_slot_register,
        pcie_mode    =>   pcie_mode,
        bypass_cdc    =>   bypass_cdc,
        enable_rx_reordering    =>   enable_rx_reordering,
        enable_rx_buffer_checking    =>   enable_rx_buffer_checking,
        single_rx_detect_data    =>   single_rx_detect_data,
        single_rx_detect    =>   single_rx_detect,
        use_crc_forwarding    =>   use_crc_forwarding,
        bypass_tl    =>   bypass_tl,
        gen123_lane_rate_mode    =>   gen123_lane_rate_mode,
        lane_mask    =>   lane_mask,
        disable_link_x2_support    =>   disable_link_x2_support,
        national_inst_thru_enhance    =>   national_inst_thru_enhance,
        hip_hard_reset    =>   hip_hard_reset,
        dis_paritychk    =>   dis_paritychk,
        wrong_device_id    =>   wrong_device_id,
        data_pack_rx    =>   data_pack_rx,
        ast_width    =>   ast_width,
        rx_sop_ctrl    =>   rx_sop_ctrl,
        rx_ast_parity    =>   rx_ast_parity,
        tx_ast_parity    =>   tx_ast_parity,
        ltssm_1ms_timeout    =>   ltssm_1ms_timeout,
        ltssm_freqlocked_check    =>   ltssm_freqlocked_check,
        deskew_comma    =>   deskew_comma,
        dl_tx_check_parity_edb    =>   dl_tx_check_parity_edb,
        tl_tx_check_parity_msg    =>   tl_tx_check_parity_msg,
        port_link_number_data    =>   port_link_number_data,
        port_link_number    =>   port_link_number,
        device_number_data    =>   device_number_data,
        device_number    =>   device_number,
        bypass_clk_switch    =>   bypass_clk_switch,
        core_clk_out_sel    =>   core_clk_out_sel,
        core_clk_divider    =>   core_clk_divider,
        core_clk_source    =>   core_clk_source,
        core_clk_sel    =>   core_clk_sel,
        enable_ch0_pclk_out    =>   enable_ch0_pclk_out,
        enable_ch01_pclk_out    =>   enable_ch01_pclk_out,
        pipex1_debug_sel    =>   pipex1_debug_sel,
        pclk_out_sel    =>   pclk_out_sel,
        vendor_id_data    =>   vendor_id_data,
        vendor_id    =>   vendor_id,
        device_id_data    =>   device_id_data,
        device_id    =>   device_id,
        revision_id_data    =>   revision_id_data,
        revision_id    =>   revision_id,
        class_code_data    =>   class_code_data,
        class_code    =>   class_code,
        subsystem_vendor_id_data    =>   subsystem_vendor_id_data,
        subsystem_vendor_id    =>   subsystem_vendor_id,
        subsystem_device_id_data    =>   subsystem_device_id_data,
        subsystem_device_id    =>   subsystem_device_id,
        no_soft_reset    =>   no_soft_reset,
        maximum_current_data    =>   maximum_current_data,
        maximum_current    =>   maximum_current,
        d1_support    =>   d1_support,
        d2_support    =>   d2_support,
        d0_pme    =>   d0_pme,
        d1_pme    =>   d1_pme,
        d2_pme    =>   d2_pme,
        d3_hot_pme    =>   d3_hot_pme,
        d3_cold_pme    =>   d3_cold_pme,
        use_aer    =>   use_aer,
        low_priority_vc    =>   low_priority_vc,
        vc_arbitration    =>   vc_arbitration,
        disable_snoop_packet    =>   disable_snoop_packet,
        max_payload_size    =>   max_payload_size,
        surprise_down_error_support    =>   surprise_down_error_support,
        dll_active_report_support    =>   dll_active_report_support,
        extend_tag_field    =>   extend_tag_field,
        endpoint_l0_latency_data    =>   endpoint_l0_latency_data,
        endpoint_l0_latency    =>   endpoint_l0_latency,
        endpoint_l1_latency_data    =>   endpoint_l1_latency_data,
        endpoint_l1_latency    =>   endpoint_l1_latency,
        indicator_data    =>   indicator_data,
        indicator    =>   indicator,
        role_based_error_reporting    =>   role_based_error_reporting,
        slot_power_scale_data    =>   slot_power_scale_data,
        slot_power_scale    =>   slot_power_scale,
        max_link_width    =>   max_link_width,
        enable_l1_aspm    =>   enable_l1_aspm,
        enable_l0s_aspm    =>   enable_l0s_aspm,
        l1_exit_latency_sameclock_data    =>   l1_exit_latency_sameclock_data,
        l1_exit_latency_sameclock    =>   l1_exit_latency_sameclock,
        l1_exit_latency_diffclock_data    =>   l1_exit_latency_diffclock_data,
        l1_exit_latency_diffclock    =>   l1_exit_latency_diffclock,
        hot_plug_support_data    =>   hot_plug_support_data,
        hot_plug_support    =>   hot_plug_support,
        slot_power_limit_data    =>   slot_power_limit_data,
        slot_power_limit    =>   slot_power_limit,
        slot_number_data    =>   slot_number_data,
        slot_number    =>   slot_number,
        diffclock_nfts_count_data    =>   diffclock_nfts_count_data,
        diffclock_nfts_count    =>   diffclock_nfts_count,
        sameclock_nfts_count_data    =>   sameclock_nfts_count_data,
        sameclock_nfts_count    =>   sameclock_nfts_count,
        completion_timeout    =>   completion_timeout,
        enable_completion_timeout_disable    =>   enable_completion_timeout_disable,
        extended_tag_reset    =>   extended_tag_reset,
        ecrc_check_capable    =>   ecrc_check_capable,
        ecrc_gen_capable    =>   ecrc_gen_capable,
        no_command_completed    =>   no_command_completed,
        msi_multi_message_capable    =>   msi_multi_message_capable,
        msi_64bit_addressing_capable    =>   msi_64bit_addressing_capable,
        msi_masking_capable    =>   msi_masking_capable,
        msi_support    =>   msi_support,
        interrupt_pin    =>   interrupt_pin,
        ena_ido_req    =>   ena_ido_req,
        ena_ido_cpl    =>   ena_ido_cpl,
        enable_function_msix_support    =>   enable_function_msix_support,
        msix_table_size_data    =>   msix_table_size_data,
        msix_table_size    =>   msix_table_size,
        msix_table_bir_data    =>   msix_table_bir_data,
        msix_table_bir    =>   msix_table_bir,
        msix_table_offset_data    =>   msix_table_offset_data,
        msix_table_offset    =>   msix_table_offset,
        msix_pba_bir_data    =>   msix_pba_bir_data,
        msix_pba_bir    =>   msix_pba_bir,
        msix_pba_offset_data    =>   msix_pba_offset_data,
        msix_pba_offset    =>   msix_pba_offset,
        bridge_port_vga_enable    =>   bridge_port_vga_enable,
        bridge_port_ssid_support    =>   bridge_port_ssid_support,
        ssvid_data    =>   ssvid_data,
        ssvid    =>   ssvid,
        ssid_data    =>   ssid_data,
        ssid    =>   ssid,
        eie_before_nfts_count_data    =>   eie_before_nfts_count_data,
        eie_before_nfts_count    =>   eie_before_nfts_count,
        gen2_diffclock_nfts_count_data    =>   gen2_diffclock_nfts_count_data,
        gen2_diffclock_nfts_count    =>   gen2_diffclock_nfts_count,
        gen2_sameclock_nfts_count_data    =>   gen2_sameclock_nfts_count_data,
        gen2_sameclock_nfts_count    =>   gen2_sameclock_nfts_count,
        deemphasis_enable    =>   deemphasis_enable,
        pcie_spec_version    =>   pcie_spec_version,
        l0_exit_latency_sameclock_data    =>   l0_exit_latency_sameclock_data,
        l0_exit_latency_sameclock    =>   l0_exit_latency_sameclock,
        l0_exit_latency_diffclock_data    =>   l0_exit_latency_diffclock_data,
        l0_exit_latency_diffclock    =>   l0_exit_latency_diffclock,
        rx_ei_l0s    =>   rx_ei_l0s,
        l2_async_logic    =>   l2_async_logic,
        aspm_config_management    =>   aspm_config_management,
        atomic_op_routing    =>   atomic_op_routing,
        atomic_op_completer_32bit    =>   atomic_op_completer_32bit,
        atomic_op_completer_64bit    =>   atomic_op_completer_64bit,
        cas_completer_128bit    =>   cas_completer_128bit,
        ltr_mechanism    =>   ltr_mechanism,
        tph_completer    =>   tph_completer,
        extended_format_field    =>   extended_format_field,
        atomic_malformed    =>   atomic_malformed,
        flr_capability    =>   flr_capability,
        enable_adapter_half_rate_mode    =>   enable_adapter_half_rate_mode,
        vc0_clk_enable    =>   vc0_clk_enable,
        vc1_clk_enable    =>   vc1_clk_enable,
        register_pipe_signals    =>   register_pipe_signals,
        bar0_io_space    =>   bar0_io_space,
        bar0_64bit_mem_space    =>   bar0_64bit_mem_space,
        bar0_prefetchable    =>   bar0_prefetchable,
        bar0_size_mask_data    =>   bar0_size_mask_data,
        bar0_size_mask    =>   bar0_size_mask,
        bar1_io_space    =>   bar1_io_space,
        bar1_64bit_mem_space    =>   bar1_64bit_mem_space,
        bar1_prefetchable    =>   bar1_prefetchable,
        bar1_size_mask_data    =>   bar1_size_mask_data,
        bar1_size_mask    =>   bar1_size_mask,
        bar2_io_space    =>   bar2_io_space,
        bar2_64bit_mem_space    =>   bar2_64bit_mem_space,
        bar2_prefetchable    =>   bar2_prefetchable,
        bar2_size_mask_data    =>   bar2_size_mask_data,
        bar2_size_mask    =>   bar2_size_mask,
        bar3_io_space    =>   bar3_io_space,
        bar3_64bit_mem_space    =>   bar3_64bit_mem_space,
        bar3_prefetchable    =>   bar3_prefetchable,
        bar3_size_mask_data    =>   bar3_size_mask_data,
        bar3_size_mask    =>   bar3_size_mask,
        bar4_io_space    =>   bar4_io_space,
        bar4_64bit_mem_space    =>   bar4_64bit_mem_space,
        bar4_prefetchable    =>   bar4_prefetchable,
        bar4_size_mask_data    =>   bar4_size_mask_data,
        bar4_size_mask    =>   bar4_size_mask,
        bar5_io_space    =>   bar5_io_space,
        bar5_64bit_mem_space    =>   bar5_64bit_mem_space,
        bar5_prefetchable    =>   bar5_prefetchable,
        bar5_size_mask_data    =>   bar5_size_mask_data,
        bar5_size_mask    =>   bar5_size_mask,
        expansion_base_address_register_data    =>   expansion_base_address_register_data,
        expansion_base_address_register    =>   expansion_base_address_register,
        io_window_addr_width    =>   io_window_addr_width,
        prefetchable_mem_window_addr_width    =>   prefetchable_mem_window_addr_width,
        skp_os_gen3_count_data    =>   skp_os_gen3_count_data,
        skp_os_gen3_count    =>   skp_os_gen3_count,
        rx_cdc_almost_empty_data    =>   rx_cdc_almost_empty_data,
        rx_cdc_almost_empty    =>   rx_cdc_almost_empty,
        tx_cdc_almost_empty_data    =>   tx_cdc_almost_empty_data,
        tx_cdc_almost_empty    =>   tx_cdc_almost_empty,
        rx_cdc_almost_full_data    =>   rx_cdc_almost_full_data,
        rx_cdc_almost_full    =>   rx_cdc_almost_full,
        tx_cdc_almost_full_data    =>   tx_cdc_almost_full_data,
        tx_cdc_almost_full    =>   tx_cdc_almost_full,
        rx_l0s_count_idl_data    =>   rx_l0s_count_idl_data,
        rx_l0s_count_idl    =>   rx_l0s_count_idl,
        cdc_dummy_insert_limit_data    =>   cdc_dummy_insert_limit_data,
        cdc_dummy_insert_limit    =>   cdc_dummy_insert_limit,
        ei_delay_powerdown_count_data    =>   ei_delay_powerdown_count_data,
        ei_delay_powerdown_count    =>   ei_delay_powerdown_count,
        millisecond_cycle_count_data    =>   millisecond_cycle_count_data,
        millisecond_cycle_count    =>   millisecond_cycle_count,
        skp_os_schedule_count_data    =>   skp_os_schedule_count_data,
        skp_os_schedule_count    =>   skp_os_schedule_count,
        fc_init_timer_data    =>   fc_init_timer_data,
        fc_init_timer    =>   fc_init_timer,
        l01_entry_latency_data    =>   l01_entry_latency_data,
        l01_entry_latency    =>   l01_entry_latency,
        flow_control_update_count_data    =>   flow_control_update_count_data,
        flow_control_update_count    =>   flow_control_update_count,
        flow_control_timeout_count_data    =>   flow_control_timeout_count_data,
        flow_control_timeout_count    =>   flow_control_timeout_count,
        vc0_rx_flow_ctrl_posted_header_data    =>   vc0_rx_flow_ctrl_posted_header_data,
        vc0_rx_flow_ctrl_posted_header    =>   vc0_rx_flow_ctrl_posted_header,
        vc0_rx_flow_ctrl_posted_data_data    =>   vc0_rx_flow_ctrl_posted_data_data,
        vc0_rx_flow_ctrl_posted_data    =>   vc0_rx_flow_ctrl_posted_data,
        vc0_rx_flow_ctrl_nonposted_header_data    =>   vc0_rx_flow_ctrl_nonposted_header_data,
        vc0_rx_flow_ctrl_nonposted_header    =>   vc0_rx_flow_ctrl_nonposted_header,
        vc0_rx_flow_ctrl_nonposted_data_data    =>   vc0_rx_flow_ctrl_nonposted_data_data,
        vc0_rx_flow_ctrl_nonposted_data    =>   vc0_rx_flow_ctrl_nonposted_data,
        vc0_rx_flow_ctrl_compl_header_data    =>   vc0_rx_flow_ctrl_compl_header_data,
        vc0_rx_flow_ctrl_compl_header    =>   vc0_rx_flow_ctrl_compl_header,
        vc0_rx_flow_ctrl_compl_data_data    =>   vc0_rx_flow_ctrl_compl_data_data,
        vc0_rx_flow_ctrl_compl_data    =>   vc0_rx_flow_ctrl_compl_data,
        rx_ptr0_posted_dpram_min_data    =>   rx_ptr0_posted_dpram_min_data,
        rx_ptr0_posted_dpram_min    =>   rx_ptr0_posted_dpram_min,
        rx_ptr0_posted_dpram_max_data    =>   rx_ptr0_posted_dpram_max_data,
        rx_ptr0_posted_dpram_max    =>   rx_ptr0_posted_dpram_max,
        rx_ptr0_nonposted_dpram_min_data    =>   rx_ptr0_nonposted_dpram_min_data,
        rx_ptr0_nonposted_dpram_min    =>   rx_ptr0_nonposted_dpram_min,
        rx_ptr0_nonposted_dpram_max_data    =>   rx_ptr0_nonposted_dpram_max_data,
        rx_ptr0_nonposted_dpram_max    =>   rx_ptr0_nonposted_dpram_max,
        retry_buffer_last_active_address_data    =>   retry_buffer_last_active_address_data,
        retry_buffer_last_active_address    =>   retry_buffer_last_active_address,
        retry_buffer_memory_settings_data    =>   retry_buffer_memory_settings_data,
        retry_buffer_memory_settings    =>   retry_buffer_memory_settings,
        vc0_rx_buffer_memory_settings_data    =>   vc0_rx_buffer_memory_settings_data,
        vc0_rx_buffer_memory_settings    =>   vc0_rx_buffer_memory_settings,
        bist_memory_settings_data    =>   bist_memory_settings_data,
        bist_memory_settings    =>   bist_memory_settings,
        credit_buffer_allocation_aux    =>   credit_buffer_allocation_aux,
        iei_enable_settings    =>   iei_enable_settings,
        vsec_id_data    =>   vsec_id_data,
        vsec_id    =>   vsec_id,
        cvp_rate_sel    =>   cvp_rate_sel,
        hard_reset_bypass    =>   hard_reset_bypass,
        cvp_data_compressed    =>   cvp_data_compressed,
        cvp_data_encrypted    =>   cvp_data_encrypted,
        cvp_mode_reset    =>   cvp_mode_reset,
        cvp_clk_reset    =>   cvp_clk_reset,
        vsec_cap_data    =>   vsec_cap_data,
        vsec_cap    =>   vsec_cap,
        jtag_id_data    =>   jtag_id_data,
        jtag_id    =>   jtag_id,
        user_id_data    =>   user_id_data,
        user_id    =>   user_id,
        cseb_extend_pci    =>   cseb_extend_pci,
        cseb_extend_pcie    =>   cseb_extend_pcie,
        cseb_cpl_status_during_cvp    =>   cseb_cpl_status_during_cvp,
        cseb_route_to_avl_rx_st    =>   cseb_route_to_avl_rx_st,
        cseb_config_bypass    =>   cseb_config_bypass,
        cseb_cpl_tag_checking    =>   cseb_cpl_tag_checking,
        cseb_bar_match_checking    =>   cseb_bar_match_checking,
        cseb_min_error_checking    =>   cseb_min_error_checking,
        cseb_temp_busy_crs    =>   cseb_temp_busy_crs,
        cseb_disable_auto_crs    =>   cseb_disable_auto_crs,
        gen3_diffclock_nfts_count_data    =>   gen3_diffclock_nfts_count_data,
        gen3_diffclock_nfts_count    =>   gen3_diffclock_nfts_count,
        gen3_sameclock_nfts_count_data    =>   gen3_sameclock_nfts_count_data,
        gen3_sameclock_nfts_count    =>   gen3_sameclock_nfts_count,
        gen3_coeff_errchk    =>   gen3_coeff_errchk,
        gen3_paritychk    =>   gen3_paritychk,
        gen3_coeff_delay_count_data    =>   gen3_coeff_delay_count_data,
        gen3_coeff_delay_count    =>   gen3_coeff_delay_count,
        gen3_coeff_1_data    =>   gen3_coeff_1_data,
        gen3_coeff_1    =>   gen3_coeff_1,
        gen3_coeff_1_sel    =>   gen3_coeff_1_sel,
        gen3_coeff_1_preset_hint_data    =>   gen3_coeff_1_preset_hint_data,
        gen3_coeff_1_preset_hint    =>   gen3_coeff_1_preset_hint,
        gen3_coeff_1_nxtber_more_ptr    =>   gen3_coeff_1_nxtber_more_ptr,
        gen3_coeff_1_nxtber_more    =>   gen3_coeff_1_nxtber_more,
        gen3_coeff_1_nxtber_less_ptr    =>   gen3_coeff_1_nxtber_less_ptr,
        gen3_coeff_1_nxtber_less    =>   gen3_coeff_1_nxtber_less,
        gen3_coeff_1_reqber_data    =>   gen3_coeff_1_reqber_data,
        gen3_coeff_1_reqber    =>   gen3_coeff_1_reqber,
        gen3_coeff_1_ber_meas_data    =>   gen3_coeff_1_ber_meas_data,
        gen3_coeff_1_ber_meas    =>   gen3_coeff_1_ber_meas,
        gen3_coeff_2_data    =>   gen3_coeff_2_data,
        gen3_coeff_2    =>   gen3_coeff_2,
        gen3_coeff_2_sel    =>   gen3_coeff_2_sel,
        gen3_coeff_2_preset_hint_data    =>   gen3_coeff_2_preset_hint_data,
        gen3_coeff_2_preset_hint    =>   gen3_coeff_2_preset_hint,
        gen3_coeff_2_nxtber_more_ptr    =>   gen3_coeff_2_nxtber_more_ptr,
        gen3_coeff_2_nxtber_more    =>   gen3_coeff_2_nxtber_more,
        gen3_coeff_2_nxtber_less_ptr    =>   gen3_coeff_2_nxtber_less_ptr,
        gen3_coeff_2_nxtber_less    =>   gen3_coeff_2_nxtber_less,
        gen3_coeff_2_reqber_data    =>   gen3_coeff_2_reqber_data,
        gen3_coeff_2_reqber    =>   gen3_coeff_2_reqber,
        gen3_coeff_2_ber_meas_data    =>   gen3_coeff_2_ber_meas_data,
        gen3_coeff_2_ber_meas    =>   gen3_coeff_2_ber_meas,
        gen3_coeff_3_data    =>   gen3_coeff_3_data,
        gen3_coeff_3    =>   gen3_coeff_3,
        gen3_coeff_3_sel    =>   gen3_coeff_3_sel,
        gen3_coeff_3_preset_hint_data    =>   gen3_coeff_3_preset_hint_data,
        gen3_coeff_3_preset_hint    =>   gen3_coeff_3_preset_hint,
        gen3_coeff_3_nxtber_more_ptr    =>   gen3_coeff_3_nxtber_more_ptr,
        gen3_coeff_3_nxtber_more    =>   gen3_coeff_3_nxtber_more,
        gen3_coeff_3_nxtber_less_ptr    =>   gen3_coeff_3_nxtber_less_ptr,
        gen3_coeff_3_nxtber_less    =>   gen3_coeff_3_nxtber_less,
        gen3_coeff_3_reqber_data    =>   gen3_coeff_3_reqber_data,
        gen3_coeff_3_reqber    =>   gen3_coeff_3_reqber,
        gen3_coeff_3_ber_meas_data    =>   gen3_coeff_3_ber_meas_data,
        gen3_coeff_3_ber_meas    =>   gen3_coeff_3_ber_meas,
        gen3_coeff_4_data    =>   gen3_coeff_4_data,
        gen3_coeff_4    =>   gen3_coeff_4,
        gen3_coeff_4_sel    =>   gen3_coeff_4_sel,
        gen3_coeff_4_preset_hint_data    =>   gen3_coeff_4_preset_hint_data,
        gen3_coeff_4_preset_hint    =>   gen3_coeff_4_preset_hint,
        gen3_coeff_4_nxtber_more_ptr    =>   gen3_coeff_4_nxtber_more_ptr,
        gen3_coeff_4_nxtber_more    =>   gen3_coeff_4_nxtber_more,
        gen3_coeff_4_nxtber_less_ptr    =>   gen3_coeff_4_nxtber_less_ptr,
        gen3_coeff_4_nxtber_less    =>   gen3_coeff_4_nxtber_less,
        gen3_coeff_4_reqber_data    =>   gen3_coeff_4_reqber_data,
        gen3_coeff_4_reqber    =>   gen3_coeff_4_reqber,
        gen3_coeff_4_ber_meas_data    =>   gen3_coeff_4_ber_meas_data,
        gen3_coeff_4_ber_meas    =>   gen3_coeff_4_ber_meas,
        gen3_coeff_5_data    =>   gen3_coeff_5_data,
        gen3_coeff_5    =>   gen3_coeff_5,
        gen3_coeff_5_sel    =>   gen3_coeff_5_sel,
        gen3_coeff_5_preset_hint_data    =>   gen3_coeff_5_preset_hint_data,
        gen3_coeff_5_preset_hint    =>   gen3_coeff_5_preset_hint,
        gen3_coeff_5_nxtber_more_ptr    =>   gen3_coeff_5_nxtber_more_ptr,
        gen3_coeff_5_nxtber_more    =>   gen3_coeff_5_nxtber_more,
        gen3_coeff_5_nxtber_less_ptr    =>   gen3_coeff_5_nxtber_less_ptr,
        gen3_coeff_5_nxtber_less    =>   gen3_coeff_5_nxtber_less,
        gen3_coeff_5_reqber_data    =>   gen3_coeff_5_reqber_data,
        gen3_coeff_5_reqber    =>   gen3_coeff_5_reqber,
        gen3_coeff_5_ber_meas_data    =>   gen3_coeff_5_ber_meas_data,
        gen3_coeff_5_ber_meas    =>   gen3_coeff_5_ber_meas,
        gen3_coeff_6_data    =>   gen3_coeff_6_data,
        gen3_coeff_6    =>   gen3_coeff_6,
        gen3_coeff_6_sel    =>   gen3_coeff_6_sel,
        gen3_coeff_6_preset_hint_data    =>   gen3_coeff_6_preset_hint_data,
        gen3_coeff_6_preset_hint    =>   gen3_coeff_6_preset_hint,
        gen3_coeff_6_nxtber_more_ptr    =>   gen3_coeff_6_nxtber_more_ptr,
        gen3_coeff_6_nxtber_more    =>   gen3_coeff_6_nxtber_more,
        gen3_coeff_6_nxtber_less_ptr    =>   gen3_coeff_6_nxtber_less_ptr,
        gen3_coeff_6_nxtber_less    =>   gen3_coeff_6_nxtber_less,
        gen3_coeff_6_reqber_data    =>   gen3_coeff_6_reqber_data,
        gen3_coeff_6_reqber    =>   gen3_coeff_6_reqber,
        gen3_coeff_6_ber_meas_data    =>   gen3_coeff_6_ber_meas_data,
        gen3_coeff_6_ber_meas    =>   gen3_coeff_6_ber_meas,
        gen3_coeff_7_data    =>   gen3_coeff_7_data,
        gen3_coeff_7    =>   gen3_coeff_7,
        gen3_coeff_7_sel    =>   gen3_coeff_7_sel,
        gen3_coeff_7_preset_hint_data    =>   gen3_coeff_7_preset_hint_data,
        gen3_coeff_7_preset_hint    =>   gen3_coeff_7_preset_hint,
        gen3_coeff_7_nxtber_more_ptr    =>   gen3_coeff_7_nxtber_more_ptr,
        gen3_coeff_7_nxtber_more    =>   gen3_coeff_7_nxtber_more,
        gen3_coeff_7_nxtber_less_ptr    =>   gen3_coeff_7_nxtber_less_ptr,
        gen3_coeff_7_nxtber_less    =>   gen3_coeff_7_nxtber_less,
        gen3_coeff_7_reqber_data    =>   gen3_coeff_7_reqber_data,
        gen3_coeff_7_reqber    =>   gen3_coeff_7_reqber,
        gen3_coeff_7_ber_meas_data    =>   gen3_coeff_7_ber_meas_data,
        gen3_coeff_7_ber_meas    =>   gen3_coeff_7_ber_meas,
        gen3_coeff_8_data    =>   gen3_coeff_8_data,
        gen3_coeff_8    =>   gen3_coeff_8,
        gen3_coeff_8_sel    =>   gen3_coeff_8_sel,
        gen3_coeff_8_preset_hint_data    =>   gen3_coeff_8_preset_hint_data,
        gen3_coeff_8_preset_hint    =>   gen3_coeff_8_preset_hint,
        gen3_coeff_8_nxtber_more_ptr    =>   gen3_coeff_8_nxtber_more_ptr,
        gen3_coeff_8_nxtber_more    =>   gen3_coeff_8_nxtber_more,
        gen3_coeff_8_nxtber_less_ptr    =>   gen3_coeff_8_nxtber_less_ptr,
        gen3_coeff_8_nxtber_less    =>   gen3_coeff_8_nxtber_less,
        gen3_coeff_8_reqber_data    =>   gen3_coeff_8_reqber_data,
        gen3_coeff_8_reqber    =>   gen3_coeff_8_reqber,
        gen3_coeff_8_ber_meas_data    =>   gen3_coeff_8_ber_meas_data,
        gen3_coeff_8_ber_meas    =>   gen3_coeff_8_ber_meas,
        gen3_coeff_9_data    =>   gen3_coeff_9_data,
        gen3_coeff_9    =>   gen3_coeff_9,
        gen3_coeff_9_sel    =>   gen3_coeff_9_sel,
        gen3_coeff_9_preset_hint_data    =>   gen3_coeff_9_preset_hint_data,
        gen3_coeff_9_preset_hint    =>   gen3_coeff_9_preset_hint,
        gen3_coeff_9_nxtber_more_ptr    =>   gen3_coeff_9_nxtber_more_ptr,
        gen3_coeff_9_nxtber_more    =>   gen3_coeff_9_nxtber_more,
        gen3_coeff_9_nxtber_less_ptr    =>   gen3_coeff_9_nxtber_less_ptr,
        gen3_coeff_9_nxtber_less    =>   gen3_coeff_9_nxtber_less,
        gen3_coeff_9_reqber_data    =>   gen3_coeff_9_reqber_data,
        gen3_coeff_9_reqber    =>   gen3_coeff_9_reqber,
        gen3_coeff_9_ber_meas_data    =>   gen3_coeff_9_ber_meas_data,
        gen3_coeff_9_ber_meas    =>   gen3_coeff_9_ber_meas,
        gen3_coeff_10_data    =>   gen3_coeff_10_data,
        gen3_coeff_10    =>   gen3_coeff_10,
        gen3_coeff_10_sel    =>   gen3_coeff_10_sel,
        gen3_coeff_10_preset_hint_data    =>   gen3_coeff_10_preset_hint_data,
        gen3_coeff_10_preset_hint    =>   gen3_coeff_10_preset_hint,
        gen3_coeff_10_nxtber_more_ptr    =>   gen3_coeff_10_nxtber_more_ptr,
        gen3_coeff_10_nxtber_more    =>   gen3_coeff_10_nxtber_more,
        gen3_coeff_10_nxtber_less_ptr    =>   gen3_coeff_10_nxtber_less_ptr,
        gen3_coeff_10_nxtber_less    =>   gen3_coeff_10_nxtber_less,
        gen3_coeff_10_reqber_data    =>   gen3_coeff_10_reqber_data,
        gen3_coeff_10_reqber    =>   gen3_coeff_10_reqber,
        gen3_coeff_10_ber_meas_data    =>   gen3_coeff_10_ber_meas_data,
        gen3_coeff_10_ber_meas    =>   gen3_coeff_10_ber_meas,
        gen3_coeff_11_data    =>   gen3_coeff_11_data,
        gen3_coeff_11    =>   gen3_coeff_11,
        gen3_coeff_11_sel    =>   gen3_coeff_11_sel,
        gen3_coeff_11_preset_hint_data    =>   gen3_coeff_11_preset_hint_data,
        gen3_coeff_11_preset_hint    =>   gen3_coeff_11_preset_hint,
        gen3_coeff_11_nxtber_more_ptr    =>   gen3_coeff_11_nxtber_more_ptr,
        gen3_coeff_11_nxtber_more    =>   gen3_coeff_11_nxtber_more,
        gen3_coeff_11_nxtber_less_ptr    =>   gen3_coeff_11_nxtber_less_ptr,
        gen3_coeff_11_nxtber_less    =>   gen3_coeff_11_nxtber_less,
        gen3_coeff_11_reqber_data    =>   gen3_coeff_11_reqber_data,
        gen3_coeff_11_reqber    =>   gen3_coeff_11_reqber,
        gen3_coeff_11_ber_meas_data    =>   gen3_coeff_11_ber_meas_data,
        gen3_coeff_11_ber_meas    =>   gen3_coeff_11_ber_meas,
        gen3_coeff_12_data    =>   gen3_coeff_12_data,
        gen3_coeff_12    =>   gen3_coeff_12,
        gen3_coeff_12_sel    =>   gen3_coeff_12_sel,
        gen3_coeff_12_preset_hint_data    =>   gen3_coeff_12_preset_hint_data,
        gen3_coeff_12_preset_hint    =>   gen3_coeff_12_preset_hint,
        gen3_coeff_12_nxtber_more_ptr    =>   gen3_coeff_12_nxtber_more_ptr,
        gen3_coeff_12_nxtber_more    =>   gen3_coeff_12_nxtber_more,
        gen3_coeff_12_nxtber_less_ptr    =>   gen3_coeff_12_nxtber_less_ptr,
        gen3_coeff_12_nxtber_less    =>   gen3_coeff_12_nxtber_less,
        gen3_coeff_12_reqber_data    =>   gen3_coeff_12_reqber_data,
        gen3_coeff_12_reqber    =>   gen3_coeff_12_reqber,
        gen3_coeff_12_ber_meas_data    =>   gen3_coeff_12_ber_meas_data,
        gen3_coeff_12_ber_meas    =>   gen3_coeff_12_ber_meas,
        gen3_coeff_13_data    =>   gen3_coeff_13_data,
        gen3_coeff_13    =>   gen3_coeff_13,
        gen3_coeff_13_sel    =>   gen3_coeff_13_sel,
        gen3_coeff_13_preset_hint_data    =>   gen3_coeff_13_preset_hint_data,
        gen3_coeff_13_preset_hint    =>   gen3_coeff_13_preset_hint,
        gen3_coeff_13_nxtber_more_ptr    =>   gen3_coeff_13_nxtber_more_ptr,
        gen3_coeff_13_nxtber_more    =>   gen3_coeff_13_nxtber_more,
        gen3_coeff_13_nxtber_less_ptr    =>   gen3_coeff_13_nxtber_less_ptr,
        gen3_coeff_13_nxtber_less    =>   gen3_coeff_13_nxtber_less,
        gen3_coeff_13_reqber_data    =>   gen3_coeff_13_reqber_data,
        gen3_coeff_13_reqber    =>   gen3_coeff_13_reqber,
        gen3_coeff_13_ber_meas_data    =>   gen3_coeff_13_ber_meas_data,
        gen3_coeff_13_ber_meas    =>   gen3_coeff_13_ber_meas,
        gen3_coeff_14_data    =>   gen3_coeff_14_data,
        gen3_coeff_14    =>   gen3_coeff_14,
        gen3_coeff_14_sel    =>   gen3_coeff_14_sel,
        gen3_coeff_14_preset_hint_data    =>   gen3_coeff_14_preset_hint_data,
        gen3_coeff_14_preset_hint    =>   gen3_coeff_14_preset_hint,
        gen3_coeff_14_nxtber_more_ptr    =>   gen3_coeff_14_nxtber_more_ptr,
        gen3_coeff_14_nxtber_more    =>   gen3_coeff_14_nxtber_more,
        gen3_coeff_14_nxtber_less_ptr    =>   gen3_coeff_14_nxtber_less_ptr,
        gen3_coeff_14_nxtber_less    =>   gen3_coeff_14_nxtber_less,
        gen3_coeff_14_reqber_data    =>   gen3_coeff_14_reqber_data,
        gen3_coeff_14_reqber    =>   gen3_coeff_14_reqber,
        gen3_coeff_14_ber_meas_data    =>   gen3_coeff_14_ber_meas_data,
        gen3_coeff_14_ber_meas    =>   gen3_coeff_14_ber_meas,
        gen3_coeff_15_data    =>   gen3_coeff_15_data,
        gen3_coeff_15    =>   gen3_coeff_15,
        gen3_coeff_15_sel    =>   gen3_coeff_15_sel,
        gen3_coeff_15_preset_hint_data    =>   gen3_coeff_15_preset_hint_data,
        gen3_coeff_15_preset_hint    =>   gen3_coeff_15_preset_hint,
        gen3_coeff_15_nxtber_more_ptr    =>   gen3_coeff_15_nxtber_more_ptr,
        gen3_coeff_15_nxtber_more    =>   gen3_coeff_15_nxtber_more,
        gen3_coeff_15_nxtber_less_ptr    =>   gen3_coeff_15_nxtber_less_ptr,
        gen3_coeff_15_nxtber_less    =>   gen3_coeff_15_nxtber_less,
        gen3_coeff_15_reqber_data    =>   gen3_coeff_15_reqber_data,
        gen3_coeff_15_reqber    =>   gen3_coeff_15_reqber,
        gen3_coeff_15_ber_meas_data    =>   gen3_coeff_15_ber_meas_data,
        gen3_coeff_15_ber_meas    =>   gen3_coeff_15_ber_meas,
        gen3_coeff_16_data    =>   gen3_coeff_16_data,
        gen3_coeff_16    =>   gen3_coeff_16,
        gen3_coeff_16_sel    =>   gen3_coeff_16_sel,
        gen3_coeff_16_preset_hint_data    =>   gen3_coeff_16_preset_hint_data,
        gen3_coeff_16_preset_hint    =>   gen3_coeff_16_preset_hint,
        gen3_coeff_16_nxtber_more_ptr    =>   gen3_coeff_16_nxtber_more_ptr,
        gen3_coeff_16_nxtber_more    =>   gen3_coeff_16_nxtber_more,
        gen3_coeff_16_nxtber_less_ptr    =>   gen3_coeff_16_nxtber_less_ptr,
        gen3_coeff_16_nxtber_less    =>   gen3_coeff_16_nxtber_less,
        gen3_coeff_16_reqber_data    =>   gen3_coeff_16_reqber_data,
        gen3_coeff_16_reqber    =>   gen3_coeff_16_reqber,
        gen3_coeff_16_ber_meas_data    =>   gen3_coeff_16_ber_meas_data,
        gen3_coeff_16_ber_meas    =>   gen3_coeff_16_ber_meas,
        gen3_preset_coeff_1_data    =>   gen3_preset_coeff_1_data,
        gen3_preset_coeff_1    =>   gen3_preset_coeff_1,
        gen3_preset_coeff_2_data    =>   gen3_preset_coeff_2_data,
        gen3_preset_coeff_2    =>   gen3_preset_coeff_2,
        gen3_preset_coeff_3_data    =>   gen3_preset_coeff_3_data,
        gen3_preset_coeff_3    =>   gen3_preset_coeff_3,
        gen3_preset_coeff_4_data    =>   gen3_preset_coeff_4_data,
        gen3_preset_coeff_4    =>   gen3_preset_coeff_4,
        gen3_preset_coeff_5_data    =>   gen3_preset_coeff_5_data,
        gen3_preset_coeff_5    =>   gen3_preset_coeff_5,
        gen3_preset_coeff_6_data    =>   gen3_preset_coeff_6_data,
        gen3_preset_coeff_6    =>   gen3_preset_coeff_6,
        gen3_preset_coeff_7_data    =>   gen3_preset_coeff_7_data,
        gen3_preset_coeff_7    =>   gen3_preset_coeff_7,
        gen3_preset_coeff_8_data    =>   gen3_preset_coeff_8_data,
        gen3_preset_coeff_8    =>   gen3_preset_coeff_8,
        gen3_preset_coeff_9_data    =>   gen3_preset_coeff_9_data,
        gen3_preset_coeff_9    =>   gen3_preset_coeff_9,
        gen3_preset_coeff_10_data    =>   gen3_preset_coeff_10_data,
        gen3_preset_coeff_10    =>   gen3_preset_coeff_10,
        gen3_rxfreqlock_counter_data    =>   gen3_rxfreqlock_counter_data,
        gen3_rxfreqlock_counter    =>   gen3_rxfreqlock_counter,
        rstctrl_pld_clr                    => rstctrl_pld_clr                    ,
        rstctrl_debug_en                   => rstctrl_debug_en                   ,
        rstctrl_force_inactive_rst         => rstctrl_force_inactive_rst         ,
        rstctrl_perst_enable               => rstctrl_perst_enable               ,
        hrdrstctrl_en                      => hrdrstctrl_en                      ,
        rstctrl_hip_ep                     => rstctrl_hip_ep                     ,
        rstctrl_hard_block_enable          => rstctrl_hard_block_enable          ,
        rstctrl_rx_pma_rstb_inv            => rstctrl_rx_pma_rstb_inv            ,
        rstctrl_tx_pma_rstb_inv            => rstctrl_tx_pma_rstb_inv            ,
        rstctrl_rx_pcs_rst_n_inv           => rstctrl_rx_pcs_rst_n_inv           ,
        rstctrl_tx_pcs_rst_n_inv           => rstctrl_tx_pcs_rst_n_inv           ,
        rstctrl_altpe3_crst_n_inv          => rstctrl_altpe3_crst_n_inv          ,
        rstctrl_altpe3_srst_n_inv          => rstctrl_altpe3_srst_n_inv          ,
        rstctrl_altpe3_rst_n_inv           => rstctrl_altpe3_rst_n_inv           ,
        rstctrl_tx_pma_syncp_inv           => rstctrl_tx_pma_syncp_inv           ,
        rstctrl_1us_count_fref_clk         => rstctrl_1us_count_fref_clk         ,
        rstctrl_1us_count_fref_clk_value   => rstctrl_1us_count_fref_clk_value   ,
        rstctrl_1ms_count_fref_clk         => rstctrl_1ms_count_fref_clk         ,
        rstctrl_1ms_count_fref_clk_value   => rstctrl_1ms_count_fref_clk_value   ,
        rstctrl_off_cal_done_select        => rstctrl_off_cal_done_select        ,
        rstctrl_rx_pma_rstb_cmu_select     => rstctrl_rx_pma_rstb_cmu_select     ,
        rstctrl_rx_pll_freq_lock_select    => rstctrl_rx_pll_freq_lock_select    ,
        rstctrl_mask_tx_pll_lock_select    => rstctrl_mask_tx_pll_lock_select    ,
        rstctrl_rx_pll_lock_select         => rstctrl_rx_pll_lock_select         ,
        rstctrl_perstn_select              => rstctrl_perstn_select              ,
        rstctrl_tx_lc_pll_rstb_select      => rstctrl_tx_lc_pll_rstb_select      ,
        rstctrl_fref_clk_select            => rstctrl_fref_clk_select            ,
        rstctrl_off_cal_en_select          => rstctrl_off_cal_en_select          ,
        rstctrl_tx_pma_syncp_select        => rstctrl_tx_pma_syncp_select        ,
        rstctrl_rx_pcs_rst_n_select        => rstctrl_rx_pcs_rst_n_select        ,
        rstctrl_tx_cmu_pll_lock_select     => rstctrl_tx_cmu_pll_lock_select     ,
        rstctrl_tx_pcs_rst_n_select        => rstctrl_tx_pcs_rst_n_select        ,
        rstctrl_tx_lc_pll_lock_select      => rstctrl_tx_lc_pll_lock_select      ,
        rstctrl_timer_a                    => rstctrl_timer_a                    ,
        rstctrl_timer_a_type               => rstctrl_timer_a_type               ,
        rstctrl_timer_a_value              => rstctrl_timer_a_value              ,
        rstctrl_timer_b                    => rstctrl_timer_b                    ,
        rstctrl_timer_b_type               => rstctrl_timer_b_type               ,
        rstctrl_timer_b_value              => rstctrl_timer_b_value              ,
        rstctrl_timer_c                    => rstctrl_timer_c                    ,
        rstctrl_timer_c_type               => rstctrl_timer_c_type               ,
        rstctrl_timer_c_value              => rstctrl_timer_c_value              ,
        rstctrl_timer_d                    => rstctrl_timer_d                    ,
        rstctrl_timer_d_type               => rstctrl_timer_d_type               ,
        rstctrl_timer_d_value              => rstctrl_timer_d_value              ,
        rstctrl_timer_e                    => rstctrl_timer_e                    ,
        rstctrl_timer_e_type               => rstctrl_timer_e_type               ,
        rstctrl_timer_e_value              => rstctrl_timer_e_value              ,
        rstctrl_timer_f                    => rstctrl_timer_f                    ,
        rstctrl_timer_f_type               => rstctrl_timer_f_type               ,
        rstctrl_timer_f_value              => rstctrl_timer_f_value              ,
        rstctrl_timer_g                    => rstctrl_timer_g                    ,
        rstctrl_timer_g_type               => rstctrl_timer_g_type               ,
        rstctrl_timer_g_value              => rstctrl_timer_g_value              ,
        rstctrl_timer_h                    => rstctrl_timer_h                    ,
        rstctrl_timer_h_type               => rstctrl_timer_h_type               ,
        rstctrl_timer_h_value              => rstctrl_timer_h_value              ,
        rstctrl_timer_i                    => rstctrl_timer_i                    ,
        rstctrl_timer_i_type               => rstctrl_timer_i_type               ,
        rstctrl_timer_i_value              => rstctrl_timer_i_value              ,
        rstctrl_timer_j                    => rstctrl_timer_j                    ,
        rstctrl_timer_j_type               => rstctrl_timer_j_type               ,
        rstctrl_timer_j_value              => rstctrl_timer_j_value
    )
    port  map  (
        dpriostatus    =>    dpriostatus,
        lmidout    =>    lmidout,
        lmiack    =>    lmiack,
        lmirden    =>    lmirden,
        lmiwren    =>    lmiwren,
        lmiaddr    =>    lmiaddr,
        lmidin    =>    lmidin,
        flrreset    =>    flrreset,
        flrsts    =>    flrsts,
        resetstatus    =>    resetstatus,
        l2exit    =>    l2exit,
        hotrstexit    =>    hotrstexit,
        hiphardreset  => hiphardreset,
        dlupexit    =>    dlupexit,
        coreclkout    =>    coreclkout,
        pldclk    =>    pldclk,
        pldsrst    =>    pldsrst,
        pldrst    =>    pldrst,
        pclkch0    =>    pclkch0,
        pclkch1    =>    pclkch1,
        pclkcentral    =>    pclkcentral,
        pllfixedclkch0    =>    pllfixedclkch0,
        pllfixedclkch1    =>    pllfixedclkch1,
        pllfixedclkcentral    =>    pllfixedclkcentral,
        phyrst    =>    phyrst,
        physrst    =>    physrst,
        coreclkin    =>    coreclkin,
        corerst    =>    corerst,
        corepor    =>    corepor,
        corecrst    =>    corecrst,
        coresrst    =>    coresrst,
        swdnout    =>    swdnout,
        swupout    =>    swupout,
        swdnin    =>    swdnin,
        swupin    =>    swupin,
        swctmod    =>    swctmod,
        rxstdata    =>    rxstdata,
        rxstparity    =>    rxstparity,
        rxstbe    =>    rxstbe,
        rxsterr    =>    rxsterr,
        rxstsop    =>    rxstsop,
        rxsteop    =>    rxsteop,
        rxstempty    =>    rxstempty,
        rxstvalid    =>    rxstvalid,
        rxstbardec1    =>    rxstbardec1,
        rxstbardec2    =>    rxstbardec2,
        rxstmask    =>    rxstmask,
        rxstready    =>    rxstready,
        txstready    =>    txstready,
        txcredfchipcons    =>    txcredfchipcons,
        txcredfcinfinite    =>    txcredfcinfinite,
        txcredhdrfcp    =>    txcredhdrfcp,
        txcreddatafcp    =>    txcreddatafcp,
        txcredhdrfcnp    =>    txcredhdrfcnp,
        txcreddatafcnp    =>    txcreddatafcnp,
        txcredhdrfccp    =>    txcredhdrfccp,
        txcreddatafccp    =>    txcreddatafccp,
        txstdata    =>    txstdata,
        txstparity    =>    txstparity,
        txsterr    =>    txsterr,
        txstsop    =>    txstsop,
        txsteop    =>    txsteop,
        txstempty    =>    txstempty,
        txstvalid    =>    txstvalid,
        r2cuncecc    =>    r2cuncecc,
        rxcorrecc    =>    rxcorrecc,
        retryuncecc    =>    retryuncecc,
        retrycorrecc    =>    retrycorrecc,
        rxparerr    =>    rxparerr,
        txparerr    =>    txparerr,
        r2cparerr    =>    r2cparerr,
        pmetosr    =>    pmetosr,
        pmetocr    =>    pmetocr,
        pmevent    =>    pmevent,
        pmdata    =>    pmdata,
        pmauxpwr    =>    pmauxpwr,
        tlcfgsts    =>    tlcfgsts,
        tlcfgctl    =>    tlcfgctl,
        tlcfgadd    =>    tlcfgadd,
        appintaack    =>    appintaack,
        appintasts    =>    appintasts,
        intstatus    =>    intstatus,
        appmsiack    =>    appmsiack,
        appmsireq    =>    appmsireq,
        appmsitc    =>    appmsitc,
        appmsinum    =>    appmsinum,
        aermsinum    =>    aermsinum,
        pexmsinum    =>    pexmsinum,
        hpgctrler    =>    hpgctrler,
        cfglink2csrpld    =>    cfglink2csrpld,
        cfgprmbuspld    =>    cfgprmbuspld,
        csebisshadow    =>    csebisshadow,
        csebwrdata    =>    csebwrdata,
        csebwrdataparity    =>    csebwrdataparity,
        csebbe    =>    csebbe,
        csebaddr    =>    csebaddr,
        csebaddrparity    =>    csebaddrparity,
        csebwren    =>    csebwren,
        csebrden    =>    csebrden,
        csebwrrespreq    =>    csebwrrespreq,
        csebrddata    =>    csebrddata,
        csebrddataparity    =>    csebrddataparity,
        csebwaitrequest    =>    csebwaitrequest,
        csebwrrespvalid    =>    csebwrrespvalid,
        csebwrresponse    =>    csebwrresponse,
        csebrdresponse    =>    csebrdresponse,
        dlup    =>    dlup,
        testouthip    =>    testouthip,
        testout1hip    =>    testout1hip,
        ev1us    =>    ev1us,
        ev128ns    =>    ev128ns,
        wakeoen    =>    wakeoen,
        serrout    =>    serrout,
        ltssmstate    =>    ltssmstate,
        laneact    =>    laneact,
        currentspeed    =>    currentspeed,
        slotclkcfg    =>    slotclkcfg,
        mode    =>    mode,
        testinhip    =>    testinhip,
        testin1hip    =>    testin1hip,
        cplpending    =>    cplpending,
        cplerr    =>    cplerr,
        appinterr    =>    appinterr,
        egressblkerr    =>    egressblkerr,
        pmexitd0ack    =>    pmexitd0ack,
        pmexitd0req    =>    pmexitd0req,
        currentcoeff0    =>    currentcoeff0,
        currentcoeff1    =>    currentcoeff1,
        currentcoeff2    =>    currentcoeff2,
        currentcoeff3    =>    currentcoeff3,
        currentcoeff4    =>    currentcoeff4,
        currentcoeff5    =>    currentcoeff5,
        currentcoeff6    =>    currentcoeff6,
        currentcoeff7    =>    currentcoeff7,
        currentrxpreset0    =>    currentrxpreset0,
        currentrxpreset1    =>    currentrxpreset1,
        currentrxpreset2    =>    currentrxpreset2,
        currentrxpreset3    =>    currentrxpreset3,
        currentrxpreset4    =>    currentrxpreset4,
        currentrxpreset5    =>    currentrxpreset5,
        currentrxpreset6    =>    currentrxpreset6,
        currentrxpreset7    =>    currentrxpreset7,
        rate0    =>    rate0,
        rate1    =>    rate1,
        rate2    =>    rate2,
        rate3    =>    rate3,
        rate4    =>    rate4,
        rate5    =>    rate5,
        rate6    =>    rate6,
        rate7    =>    rate7,
        ratectrl    =>    ratectrl,
        ratetiedtognd    =>    ratetiedtognd,
        eidleinfersel0    =>    eidleinfersel0,
        eidleinfersel1    =>    eidleinfersel1,
        eidleinfersel2    =>    eidleinfersel2,
        eidleinfersel3    =>    eidleinfersel3,
        eidleinfersel4    =>    eidleinfersel4,
        eidleinfersel5    =>    eidleinfersel5,
        eidleinfersel6    =>    eidleinfersel6,
        eidleinfersel7    =>    eidleinfersel7,
        txdata0    =>    txdata0,
        txdatak0    =>    txdatak0,
        txdetectrx0    =>    txdetectrx0,
        txelecidle0    =>    txelecidle0,
        txcompl0    =>    txcompl0,
        rxpolarity0    =>    rxpolarity0,
        powerdown0    =>    powerdown0,
        txdataskip0    =>    txdataskip0,
        txblkst0    =>    txblkst0,
        txsynchd0    =>    txsynchd0,
        txdeemph0    =>    txdeemph0,
        txmargin0    =>    txmargin0,
        rxdata0    =>    rxdata0,
        rxdatak0    =>    rxdatak0,
        rxvalid0    =>    rxvalid0,
        phystatus0    =>    phystatus0,
        rxelecidle0    =>    rxelecidle0,
        rxstatus0    =>    rxstatus0,
        rxdataskip0    =>    rxdataskip0,
        rxblkst0    =>    rxblkst0,
        rxsynchd0    =>    rxsynchd0,
        rxfreqlocked0    =>    rxfreqlocked0,
        txdata1    =>    txdata1,
        txdatak1    =>    txdatak1,
        txdetectrx1    =>    txdetectrx1,
        txelecidle1    =>    txelecidle1,
        txcompl1    =>    txcompl1,
        rxpolarity1    =>    rxpolarity1,
        powerdown1    =>    powerdown1,
        txdataskip1    =>    txdataskip1,
        txblkst1    =>    txblkst1,
        txsynchd1    =>    txsynchd1,
        txdeemph1    =>    txdeemph1,
        txmargin1    =>    txmargin1,
        rxdata1    =>    rxdata1,
        rxdatak1    =>    rxdatak1,
        rxvalid1    =>    rxvalid1,
        phystatus1    =>    phystatus1,
        rxelecidle1    =>    rxelecidle1,
        rxstatus1    =>    rxstatus1,
        rxdataskip1    =>    rxdataskip1,
        rxblkst1    =>    rxblkst1,
        rxsynchd1    =>    rxsynchd1,
        rxfreqlocked1    =>    rxfreqlocked1,
        txdata2    =>    txdata2,
        txdatak2    =>    txdatak2,
        txdetectrx2    =>    txdetectrx2,
        txelecidle2    =>    txelecidle2,
        txcompl2    =>    txcompl2,
        rxpolarity2    =>    rxpolarity2,
        powerdown2    =>    powerdown2,
        txdataskip2    =>    txdataskip2,
        txblkst2    =>    txblkst2,
        txsynchd2    =>    txsynchd2,
        txdeemph2    =>    txdeemph2,
        txmargin2    =>    txmargin2,
        rxdata2    =>    rxdata2,
        rxdatak2    =>    rxdatak2,
        rxvalid2    =>    rxvalid2,
        phystatus2    =>    phystatus2,
        rxelecidle2    =>    rxelecidle2,
        rxstatus2    =>    rxstatus2,
        rxdataskip2    =>    rxdataskip2,
        rxblkst2    =>    rxblkst2,
        rxsynchd2    =>    rxsynchd2,
        rxfreqlocked2    =>    rxfreqlocked2,
        txdata3    =>    txdata3,
        txdatak3    =>    txdatak3,
        txdetectrx3    =>    txdetectrx3,
        txelecidle3    =>    txelecidle3,
        txcompl3    =>    txcompl3,
        rxpolarity3    =>    rxpolarity3,
        powerdown3    =>    powerdown3,
        txdataskip3    =>    txdataskip3,
        txblkst3    =>    txblkst3,
        txsynchd3    =>    txsynchd3,
        txdeemph3    =>    txdeemph3,
        txmargin3    =>    txmargin3,
        rxdata3    =>    rxdata3,
        rxdatak3    =>    rxdatak3,
        rxvalid3    =>    rxvalid3,
        phystatus3    =>    phystatus3,
        rxelecidle3    =>    rxelecidle3,
        rxstatus3    =>    rxstatus3,
        rxdataskip3    =>    rxdataskip3,
        rxblkst3    =>    rxblkst3,
        rxsynchd3    =>    rxsynchd3,
        rxfreqlocked3    =>    rxfreqlocked3,
        txdata4    =>    txdata4,
        txdatak4    =>    txdatak4,
        txdetectrx4    =>    txdetectrx4,
        txelecidle4    =>    txelecidle4,
        txcompl4    =>    txcompl4,
        rxpolarity4    =>    rxpolarity4,
        powerdown4    =>    powerdown4,
        txdataskip4    =>    txdataskip4,
        txblkst4    =>    txblkst4,
        txsynchd4    =>    txsynchd4,
        txdeemph4    =>    txdeemph4,
        txmargin4    =>    txmargin4,
        rxdata4    =>    rxdata4,
        rxdatak4    =>    rxdatak4,
        rxvalid4    =>    rxvalid4,
        phystatus4    =>    phystatus4,
        rxelecidle4    =>    rxelecidle4,
        rxstatus4    =>    rxstatus4,
        rxdataskip4    =>    rxdataskip4,
        rxblkst4    =>    rxblkst4,
        rxsynchd4    =>    rxsynchd4,
        rxfreqlocked4    =>    rxfreqlocked4,
        txdata5    =>    txdata5,
        txdatak5    =>    txdatak5,
        txdetectrx5    =>    txdetectrx5,
        txelecidle5    =>    txelecidle5,
        txcompl5    =>    txcompl5,
        rxpolarity5    =>    rxpolarity5,
        powerdown5    =>    powerdown5,
        txdataskip5    =>    txdataskip5,
        txblkst5    =>    txblkst5,
        txsynchd5    =>    txsynchd5,
        txdeemph5    =>    txdeemph5,
        txmargin5    =>    txmargin5,
        rxdata5    =>    rxdata5,
        rxdatak5    =>    rxdatak5,
        rxvalid5    =>    rxvalid5,
        phystatus5    =>    phystatus5,
        rxelecidle5    =>    rxelecidle5,
        rxstatus5    =>    rxstatus5,
        rxdataskip5    =>    rxdataskip5,
        rxblkst5    =>    rxblkst5,
        rxsynchd5    =>    rxsynchd5,
        rxfreqlocked5    =>    rxfreqlocked5,
        txdata6    =>    txdata6,
        txdatak6    =>    txdatak6,
        txdetectrx6    =>    txdetectrx6,
        txelecidle6    =>    txelecidle6,
        txcompl6    =>    txcompl6,
        rxpolarity6    =>    rxpolarity6,
        powerdown6    =>    powerdown6,
        txdataskip6    =>    txdataskip6,
        txblkst6    =>    txblkst6,
        txsynchd6    =>    txsynchd6,
        txdeemph6    =>    txdeemph6,
        txmargin6    =>    txmargin6,
        rxdata6    =>    rxdata6,
        rxdatak6    =>    rxdatak6,
        rxvalid6    =>    rxvalid6,
        phystatus6    =>    phystatus6,
        rxelecidle6    =>    rxelecidle6,
        rxstatus6    =>    rxstatus6,
        rxdataskip6    =>    rxdataskip6,
        rxblkst6    =>    rxblkst6,
        rxsynchd6    =>    rxsynchd6,
        rxfreqlocked6    =>    rxfreqlocked6,
        txdata7    =>    txdata7,
        txdatak7    =>    txdatak7,
        txdetectrx7    =>    txdetectrx7,
        txelecidle7    =>    txelecidle7,
        txcompl7    =>    txcompl7,
        rxpolarity7    =>    rxpolarity7,
        powerdown7    =>    powerdown7,
        txdataskip7    =>    txdataskip7,
        txblkst7    =>    txblkst7,
        txsynchd7    =>    txsynchd7,
        txdeemph7    =>    txdeemph7,
        txmargin7    =>    txmargin7,
        rxdata7    =>    rxdata7,
        rxdatak7    =>    rxdatak7,
        rxvalid7    =>    rxvalid7,
        phystatus7    =>    phystatus7,
        rxelecidle7    =>    rxelecidle7,
        rxstatus7    =>    rxstatus7,
        rxdataskip7    =>    rxdataskip7,
        rxblkst7    =>    rxblkst7,
        rxsynchd7    =>    rxsynchd7,
        rxfreqlocked7    =>    rxfreqlocked7,
        dbgpipex1rx    =>    dbgpipex1rx,
        memredsclk    =>    memredsclk,
        memredenscan    =>    memredenscan,
        memredscen    =>    memredscen,
        memredscin    =>    memredscin,
        memredscsel    =>    memredscsel,
        memredscrst    =>    memredscrst,
        memredscout    =>    memredscout,
        memregscanen    =>    memregscanen,
        memregscanin    =>    memregscanin,
        memhiptestenable    =>    memhiptestenable,
        memregscanout    =>    memregscanout,
        bisttesten    =>    bisttesten,
        bistenrpl    =>    bistenrpl,
        bistscanin    =>    bistscanin,
        bistscanen    =>    bistscanen,
        bistenrcv    =>    bistenrcv,
        bistscanoutrpl    =>    bistscanoutrpl,
        bistdonearpl    =>    bistdonearpl,
        bistdonebrpl    =>    bistdonebrpl,
        bistpassrpl    =>    bistpassrpl,
        derrrpl    =>    derrrpl,
        derrcorextrpl    =>    derrcorextrpl,
        bistscanoutrcv    =>    bistscanoutrcv,
        bistdonearcv    =>    bistdonearcv,
        bistdonebrcv    =>    bistdonebrcv,
        bistpassrcv    =>    bistpassrcv,
        derrcorextrcv    =>    derrcorextrcv,
        bistscanoutrcv1    =>    bistscanoutrcv1,
        bistdonearcv1    =>    bistdonearcv1,
        bistdonebrcv1    =>    bistdonebrcv1,
        bistpassrcv1    =>    bistpassrcv1,
        derrcorextrcv1    =>    derrcorextrcv1,
        scanmoden    =>    scanmoden,
        scanshiftn    =>    scanshiftn,
        nfrzdrv    =>    nfrzdrv,
        frzreg    =>    frzreg,
        frzlogic    =>    frzlogic,
        idrpl    =>    idrpl,
        idrcv    =>    idrcv,
        plniotri    =>    plniotri,
        entest    =>    entest,
        npor    =>    npor,
        usermode    =>    usermode,
        cvpclk    =>    cvpclk,
        cvpdata    =>    cvpdata,
        cvpstartxfer    =>    cvpstartxfer,
        cvpconfig    =>    cvpconfig,
        cvpfullconfig    =>    cvpfullconfig,
        cvpconfigready    =>    cvpconfigready,
        cvpen    =>    cvpen,
        cvpconfigerror    =>    cvpconfigerror,
        cvpconfigdone    =>    cvpconfigdone,
        pinperstn    =>    pinperstn,
        pldperstn    =>    pldperstn,
        iocsrrdydly    =>    iocsrrdydly,
        softaltpe3rstn    =>    softaltpe3rstn,
        softaltpe3srstn    =>    softaltpe3srstn,
        softaltpe3crstn    =>    softaltpe3crstn,
        pldclrpmapcshipn    =>    pldclrpmapcshipn,
        pldclrpcshipn    =>    pldclrpcshipn,
        pldclrhipn    =>    pldclrhipn,
        s0ch0emsiptieoff    =>    s0ch0emsiptieoff,
        s0ch1emsiptieoff    =>    s0ch1emsiptieoff,
        s0ch2emsiptieoff    =>    s0ch2emsiptieoff,
        s1ch0emsiptieoff    =>    s1ch0emsiptieoff,
        s1ch1emsiptieoff    =>    s1ch1emsiptieoff,
        s1ch2emsiptieoff    =>    s1ch2emsiptieoff,
        s2ch0emsiptieoff    =>    s2ch0emsiptieoff,
        s2ch1emsiptieoff    =>    s2ch1emsiptieoff,
        s2ch2emsiptieoff    =>    s2ch2emsiptieoff,
        s3ch0emsiptieoff    =>    s3ch0emsiptieoff,
        s3ch1emsiptieoff    =>    s3ch1emsiptieoff,
        s3ch2emsiptieoff    =>    s3ch2emsiptieoff,
        emsiptieofftop    =>    emsiptieofftop,
        emsiptieoffbot    =>    emsiptieoffbot,


        txpcsrstn0           => txpcsrstn0           ,
        rxpcsrstn0           => rxpcsrstn0           ,
        g3txpcsrstn0         => g3txpcsrstn0         ,
        g3rxpcsrstn0         => g3rxpcsrstn0         ,
        txpmasyncp0          => txpmasyncp0          ,
        rxpmarstb0           => rxpmarstb0           ,
        txlcpllrstb0         => txlcpllrstb0         ,
        offcalen0            => offcalen0            ,
        frefclk0             => frefclk0             ,
        offcaldone0          => offcaldone0          ,
        txlcplllock0         => txlcplllock0         ,
        rxfreqtxcmuplllock0  => rxfreqtxcmuplllock0  ,
        rxpllphaselock0      => rxpllphaselock0      ,
        masktxplllock0       => masktxplllock0       ,
        txpcsrstn1           => txpcsrstn1           ,
        rxpcsrstn1           => rxpcsrstn1           ,
        g3txpcsrstn1         => g3txpcsrstn1         ,
        g3rxpcsrstn1         => g3rxpcsrstn1         ,
        txpmasyncp1          => txpmasyncp1          ,
        rxpmarstb1           => rxpmarstb1           ,
        txlcpllrstb1         => txlcpllrstb1         ,
        offcalen1            => offcalen1            ,
        frefclk1             => frefclk1             ,
        offcaldone1          => offcaldone1          ,
        txlcplllock1         => txlcplllock1         ,
        rxfreqtxcmuplllock1  => rxfreqtxcmuplllock1  ,
        rxpllphaselock1      => rxpllphaselock1      ,
        masktxplllock1       => masktxplllock1       ,
        txpcsrstn2           => txpcsrstn2           ,
        rxpcsrstn2           => rxpcsrstn2           ,
        g3txpcsrstn2         => g3txpcsrstn2         ,
        g3rxpcsrstn2         => g3rxpcsrstn2         ,
        txpmasyncp2          => txpmasyncp2          ,
        rxpmarstb2           => rxpmarstb2           ,
        txlcpllrstb2         => txlcpllrstb2         ,
        offcalen2            => offcalen2            ,
        frefclk2             => frefclk2             ,
        offcaldone2          => offcaldone2          ,
        txlcplllock2         => txlcplllock2         ,
        rxfreqtxcmuplllock2  => rxfreqtxcmuplllock2  ,
        rxpllphaselock2      => rxpllphaselock2      ,
        masktxplllock2       => masktxplllock2       ,
        txpcsrstn3           => txpcsrstn3           ,
        rxpcsrstn3           => rxpcsrstn3           ,
        g3txpcsrstn3         => g3txpcsrstn3         ,
        g3rxpcsrstn3         => g3rxpcsrstn3         ,
        txpmasyncp3          => txpmasyncp3          ,
        rxpmarstb3           => rxpmarstb3           ,
        txlcpllrstb3         => txlcpllrstb3         ,
        offcalen3            => offcalen3            ,
        frefclk3             => frefclk3             ,
        offcaldone3          => offcaldone3          ,
        txlcplllock3         => txlcplllock3         ,
        rxfreqtxcmuplllock3  => rxfreqtxcmuplllock3  ,
        rxpllphaselock3      => rxpllphaselock3      ,
        masktxplllock3       => masktxplllock3       ,
        txpcsrstn4           => txpcsrstn4           ,
        rxpcsrstn4           => rxpcsrstn4           ,
        g3txpcsrstn4         => g3txpcsrstn4         ,
        g3rxpcsrstn4         => g3rxpcsrstn4         ,
        txpmasyncp4          => txpmasyncp4          ,
        rxpmarstb4           => rxpmarstb4           ,
        txlcpllrstb4         => txlcpllrstb4         ,
        offcalen4            => offcalen4            ,
        frefclk4             => frefclk4             ,
        offcaldone4          => offcaldone4          ,
        txlcplllock4         => txlcplllock4         ,
        rxfreqtxcmuplllock4  => rxfreqtxcmuplllock4  ,
        rxpllphaselock4      => rxpllphaselock4      ,
        masktxplllock4       => masktxplllock4       ,
        txpcsrstn5           => txpcsrstn5           ,
        rxpcsrstn5           => rxpcsrstn5           ,
        g3txpcsrstn5         => g3txpcsrstn5         ,
        g3rxpcsrstn5         => g3rxpcsrstn5         ,
        txpmasyncp5          => txpmasyncp5          ,
        rxpmarstb5           => rxpmarstb5           ,
        txlcpllrstb5         => txlcpllrstb5         ,
        offcalen5            => offcalen5            ,
        frefclk5             => frefclk5             ,
        offcaldone5          => offcaldone5          ,
        txlcplllock5         => txlcplllock5         ,
        rxfreqtxcmuplllock5  => rxfreqtxcmuplllock5  ,
        rxpllphaselock5      => rxpllphaselock5      ,
        masktxplllock5       => masktxplllock5       ,
        txpcsrstn6           => txpcsrstn6           ,
        rxpcsrstn6           => rxpcsrstn6           ,
        g3txpcsrstn6         => g3txpcsrstn6         ,
        g3rxpcsrstn6         => g3rxpcsrstn6         ,
        txpmasyncp6          => txpmasyncp6          ,
        rxpmarstb6           => rxpmarstb6           ,
        txlcpllrstb6         => txlcpllrstb6         ,
        offcalen6            => offcalen6            ,
        frefclk6             => frefclk6             ,
        offcaldone6          => offcaldone6          ,
        txlcplllock6         => txlcplllock6         ,
        rxfreqtxcmuplllock6  => rxfreqtxcmuplllock6  ,
        rxpllphaselock6      => rxpllphaselock6      ,
        masktxplllock6       => masktxplllock6       ,
        txpcsrstn7           => txpcsrstn7           ,
        rxpcsrstn7           => rxpcsrstn7           ,
        g3txpcsrstn7         => g3txpcsrstn7         ,
        g3rxpcsrstn7         => g3rxpcsrstn7         ,
        txpmasyncp7          => txpmasyncp7          ,
        rxpmarstb7           => rxpmarstb7           ,
        txlcpllrstb7         => txlcpllrstb7         ,
        offcalen7            => offcalen7            ,
        frefclk7             => frefclk7             ,
        offcaldone7          => offcaldone7          ,
        txlcplllock7         => txlcplllock7         ,
        rxfreqtxcmuplllock7  => rxfreqtxcmuplllock7  ,
        rxpllphaselock7      => rxpllphaselock7      ,
        masktxplllock7       => masktxplllock7       ,
        txpcsrstn8           => txpcsrstn8           ,
        rxpcsrstn8           => rxpcsrstn8           ,
        g3txpcsrstn8         => g3txpcsrstn8         ,
        g3rxpcsrstn8         => g3rxpcsrstn8         ,
        txpmasyncp8          => txpmasyncp8          ,
        rxpmarstb8           => rxpmarstb8           ,
        txlcpllrstb8         => txlcpllrstb8         ,
        offcalen8            => offcalen8            ,
        frefclk8             => frefclk8             ,
        offcaldone8          => offcaldone8          ,
        txlcplllock8         => txlcplllock8         ,
        rxfreqtxcmuplllock8  => rxfreqtxcmuplllock8  ,
        rxpllphaselock8      => rxpllphaselock8      ,
        masktxplllock8       => masktxplllock8       ,
        txpcsrstn9           => txpcsrstn9           ,
        rxpcsrstn9           => rxpcsrstn9           ,
        g3txpcsrstn9         => g3txpcsrstn9         ,
        g3rxpcsrstn9         => g3rxpcsrstn9         ,
        txpmasyncp9          => txpmasyncp9          ,
        rxpmarstb9           => rxpmarstb9           ,
        txlcpllrstb9         => txlcpllrstb9         ,
        offcalen9            => offcalen9            ,
        frefclk9             => frefclk9             ,
        offcaldone9          => offcaldone9          ,
        txlcplllock9         => txlcplllock9         ,
        rxfreqtxcmuplllock9  => rxfreqtxcmuplllock9  ,
        rxpllphaselock9      => rxpllphaselock9      ,
        masktxplllock9       => masktxplllock9       ,
        txpcsrstn10          => txpcsrstn10          ,
        rxpcsrstn10          => rxpcsrstn10          ,
        g3txpcsrstn10        => g3txpcsrstn10        ,
        g3rxpcsrstn10        => g3rxpcsrstn10        ,
        txpmasyncp10         => txpmasyncp10         ,
        rxpmarstb10          => rxpmarstb10          ,
        txlcpllrstb10        => txlcpllrstb10        ,
        offcalen10           => offcalen10           ,
        frefclk10            => frefclk10            ,
        offcaldone10         => offcaldone10         ,
        txlcplllock10        => txlcplllock10        ,
        rxfreqtxcmuplllock10 => rxfreqtxcmuplllock10 ,
        rxpllphaselock10     => rxpllphaselock10     ,
        masktxplllock10      => masktxplllock10      ,
        txpcsrstn11          => txpcsrstn11          ,
        rxpcsrstn11          => rxpcsrstn11          ,
        g3txpcsrstn11        => g3txpcsrstn11        ,
        g3rxpcsrstn11        => g3rxpcsrstn11        ,
        txpmasyncp11         => txpmasyncp11         ,
        rxpmarstb11          => rxpmarstb11          ,
        txlcpllrstb11        => txlcpllrstb11        ,
        offcalen11           => offcalen11           ,
        frefclk11            => frefclk11            ,
        offcaldone11         => offcaldone11         ,
        txlcplllock11        => txlcplllock11        ,
        rxfreqtxcmuplllock11 => rxfreqtxcmuplllock11 ,
        rxpllphaselock11     => rxpllphaselock11     ,
        masktxplllock11      => masktxplllock11      ,


        reservedin    =>    reservedin,
        reservedclkin    =>    reservedclkin,
        reservedout    =>    reservedout,
        reservedclkout    =>    reservedclkout
    );


end behavior;

