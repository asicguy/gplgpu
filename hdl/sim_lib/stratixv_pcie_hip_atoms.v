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
`timescale 1 ps/1 ps

module    stratixv_hssi_gen3_pcie_hip    (
    dpriostatus,
    lmidout,
    lmiack,
    lmirden,
    lmiwren,
    lmiaddr,
    lmidin,
    flrreset,
    flrsts,
    resetstatus,
    l2exit,
    hotrstexit,
    hiphardreset,
    dlupexit,
    coreclkout,
    pldclk,
    pldsrst,
    pldrst,
    pclkch0,
    pclkch1,
    pclkcentral,
    pllfixedclkch0,
    pllfixedclkch1,
    pllfixedclkcentral,
    phyrst,
    physrst,
    coreclkin,
    corerst,
    corepor,
    corecrst,
    coresrst,
    swdnout,
    swupout,
    swdnin,
    swupin,
    swctmod,
    rxstdata,
    rxstparity,
    rxstbe,
    rxsterr,
    rxstsop,
    rxsteop,
    rxstempty,
    rxstvalid,
    rxstbardec1,
    rxstbardec2,
    rxstmask,
    rxstready,
    txstready,
    txcredfchipcons,
    txcredfcinfinite,
    txcredhdrfcp,
    txcreddatafcp,
    txcredhdrfcnp,
    txcreddatafcnp,
    txcredhdrfccp,
    txcreddatafccp,
    txstdata,
    txstparity,
    txsterr,
    txstsop,
    txsteop,
    txstempty,
    txstvalid,
    r2cuncecc,
    rxcorrecc,
    retryuncecc,
    retrycorrecc,
    rxparerr,
    txparerr,
    r2cparerr,
    pmetosr,
    pmetocr,
    pmevent,
    pmdata,
    pmauxpwr,
    tlcfgsts,
    tlcfgctl,
    tlcfgadd,
    appintaack,
    appintasts,
    intstatus,
    appmsiack,
    appmsireq,
    appmsitc,
    appmsinum,
    aermsinum,
    pexmsinum,
    hpgctrler,
    cfglink2csrpld,
    cfgprmbuspld,
    csebisshadow,
    csebwrdata,
    csebwrdataparity,
    csebbe,
    csebaddr,
    csebaddrparity,
    csebwren,
    csebrden,
    csebwrrespreq,
    csebrddata,
    csebrddataparity,
    csebwaitrequest,
    csebwrrespvalid,
    csebwrresponse,
    csebrdresponse,
    dlup,
    testouthip,
    testout1hip,
    ev1us,
    ev128ns,
    wakeoen,
    serrout,
    ltssmstate,
    laneact,
    currentspeed,
    slotclkcfg,
    mode,
    testinhip,
    testin1hip,
    cplpending,
    cplerr,
    appinterr,
    egressblkerr,
    pmexitd0ack,
    pmexitd0req,
    currentcoeff0,
    currentcoeff1,
    currentcoeff2,
    currentcoeff3,
    currentcoeff4,
    currentcoeff5,
    currentcoeff6,
    currentcoeff7,
    currentrxpreset0,
    currentrxpreset1,
    currentrxpreset2,
    currentrxpreset3,
    currentrxpreset4,
    currentrxpreset5,
    currentrxpreset6,
    currentrxpreset7,
    rate0,
    rate1,
    rate2,
    rate3,
    rate4,
    rate5,
    rate6,
    rate7,
    ratectrl,
    ratetiedtognd,
    eidleinfersel0,
    eidleinfersel1,
    eidleinfersel2,
    eidleinfersel3,
    eidleinfersel4,
    eidleinfersel5,
    eidleinfersel6,
    eidleinfersel7,
    txdata0,
    txdatak0,
    txdetectrx0,
    txelecidle0,
    txcompl0,
    rxpolarity0,
    powerdown0,
    txdataskip0,
    txblkst0,
    txsynchd0,
    txdeemph0,
    txmargin0,
    rxdata0,
    rxdatak0,
    rxvalid0,
    phystatus0,
    rxelecidle0,
    rxstatus0,
    rxdataskip0,
    rxblkst0,
    rxsynchd0,
    rxfreqlocked0,
    txdata1,
    txdatak1,
    txdetectrx1,
    txelecidle1,
    txcompl1,
    rxpolarity1,
    powerdown1,
    txdataskip1,
    txblkst1,
    txsynchd1,
    txdeemph1,
    txmargin1,
    rxdata1,
    rxdatak1,
    rxvalid1,
    phystatus1,
    rxelecidle1,
    rxstatus1,
    rxdataskip1,
    rxblkst1,
    rxsynchd1,
    rxfreqlocked1,
    txdata2,
    txdatak2,
    txdetectrx2,
    txelecidle2,
    txcompl2,
    rxpolarity2,
    powerdown2,
    txdataskip2,
    txblkst2,
    txsynchd2,
    txdeemph2,
    txmargin2,
    rxdata2,
    rxdatak2,
    rxvalid2,
    phystatus2,
    rxelecidle2,
    rxstatus2,
    rxdataskip2,
    rxblkst2,
    rxsynchd2,
    rxfreqlocked2,
    txdata3,
    txdatak3,
    txdetectrx3,
    txelecidle3,
    txcompl3,
    rxpolarity3,
    powerdown3,
    txdataskip3,
    txblkst3,
    txsynchd3,
    txdeemph3,
    txmargin3,
    rxdata3,
    rxdatak3,
    rxvalid3,
    phystatus3,
    rxelecidle3,
    rxstatus3,
    rxdataskip3,
    rxblkst3,
    rxsynchd3,
    rxfreqlocked3,
    txdata4,
    txdatak4,
    txdetectrx4,
    txelecidle4,
    txcompl4,
    rxpolarity4,
    powerdown4,
    txdataskip4,
    txblkst4,
    txsynchd4,
    txdeemph4,
    txmargin4,
    rxdata4,
    rxdatak4,
    rxvalid4,
    phystatus4,
    rxelecidle4,
    rxstatus4,
    rxdataskip4,
    rxblkst4,
    rxsynchd4,
    rxfreqlocked4,
    txdata5,
    txdatak5,
    txdetectrx5,
    txelecidle5,
    txcompl5,
    rxpolarity5,
    powerdown5,
    txdataskip5,
    txblkst5,
    txsynchd5,
    txdeemph5,
    txmargin5,
    rxdata5,
    rxdatak5,
    rxvalid5,
    phystatus5,
    rxelecidle5,
    rxstatus5,
    rxdataskip5,
    rxblkst5,
    rxsynchd5,
    rxfreqlocked5,
    txdata6,
    txdatak6,
    txdetectrx6,
    txelecidle6,
    txcompl6,
    rxpolarity6,
    powerdown6,
    txdataskip6,
    txblkst6,
    txsynchd6,
    txdeemph6,
    txmargin6,
    rxdata6,
    rxdatak6,
    rxvalid6,
    phystatus6,
    rxelecidle6,
    rxstatus6,
    rxdataskip6,
    rxblkst6,
    rxsynchd6,
    rxfreqlocked6,
    txdata7,
    txdatak7,
    txdetectrx7,
    txelecidle7,
    txcompl7,
    rxpolarity7,
    powerdown7,
    txdataskip7,
    txblkst7,
    txsynchd7,
    txdeemph7,
    txmargin7,
    rxdata7,
    rxdatak7,
    rxvalid7,
    phystatus7,
    rxelecidle7,
    rxstatus7,
    rxdataskip7,
    rxblkst7,
    rxsynchd7,
    rxfreqlocked7,
    dbgpipex1rx,
    memredsclk,
    memredenscan,
    memredscen,
    memredscin,
    memredscsel,
    memredscrst,
    memredscout,
    memregscanen,
    memregscanin,
    memhiptestenable,
    memregscanout,
    bisttesten,
    bistenrpl,
    bistscanin,
    bistscanen,
    bistenrcv,
    bistscanoutrpl,
    bistdonearpl,
    bistdonebrpl,
    bistpassrpl,
    derrrpl,
    derrcorextrpl,
    bistscanoutrcv,
    bistdonearcv,
    bistdonebrcv,
    bistpassrcv,
    derrcorextrcv,
    bistscanoutrcv1,
    bistdonearcv1,
    bistdonebrcv1,
    bistpassrcv1,
    derrcorextrcv1,
    scanmoden,
    scanshiftn,
    nfrzdrv,
    frzreg,
    frzlogic,
    idrpl,
    idrcv,
    plniotri,
    entest,
    npor,
    usermode,
    cvpclk,
    cvpdata,
    cvpstartxfer,
    cvpconfig,
    cvpfullconfig,
    cvpconfigready,
    cvpen,
    cvpconfigerror,
    cvpconfigdone,
    pinperstn,
    pldperstn,
    iocsrrdydly,
    softaltpe3rstn,
    softaltpe3srstn,
    softaltpe3crstn,
    pldclrpmapcshipn,
    pldclrpcshipn,
    pldclrhipn,
    s0ch0emsiptieoff,
    s0ch1emsiptieoff,
    s0ch2emsiptieoff,
    s1ch0emsiptieoff,
    s1ch1emsiptieoff,
    s1ch2emsiptieoff,
    s2ch0emsiptieoff,
    s2ch1emsiptieoff,
    s2ch2emsiptieoff,
    s3ch0emsiptieoff,
    s3ch1emsiptieoff,
    s3ch2emsiptieoff,
    emsiptieofftop,
    emsiptieoffbot,

    txpcsrstn0,
    rxpcsrstn0,
    g3txpcsrstn0,
    g3rxpcsrstn0,
    txpmasyncp0,
    rxpmarstb0,
    txlcpllrstb0,
    offcalen0,
    frefclk0,
    offcaldone0,
    txlcplllock0,
    rxfreqtxcmuplllock0,
    rxpllphaselock0,
    masktxplllock0,
    txpcsrstn1,
    rxpcsrstn1,
    g3txpcsrstn1,
    g3rxpcsrstn1,
    txpmasyncp1,
    rxpmarstb1,
    txlcpllrstb1,
    offcalen1,
    frefclk1,
    offcaldone1,
    txlcplllock1,
    rxfreqtxcmuplllock1,
    rxpllphaselock1,
    masktxplllock1,
    txpcsrstn2,
    rxpcsrstn2,
    g3txpcsrstn2,
    g3rxpcsrstn2,
    txpmasyncp2,
    rxpmarstb2,
    txlcpllrstb2,
    offcalen2,
    frefclk2,
    offcaldone2,
    txlcplllock2,
    rxfreqtxcmuplllock2,
    rxpllphaselock2,
    masktxplllock2,
    txpcsrstn3,
    rxpcsrstn3,
    g3txpcsrstn3,
    g3rxpcsrstn3,
    txpmasyncp3,
    rxpmarstb3,
    txlcpllrstb3,
    offcalen3,
    frefclk3,
    offcaldone3,
    txlcplllock3,
    rxfreqtxcmuplllock3,
    rxpllphaselock3,
    masktxplllock3,
    txpcsrstn4,
    rxpcsrstn4,
    g3txpcsrstn4,
    g3rxpcsrstn4,
    txpmasyncp4,
    rxpmarstb4,
    txlcpllrstb4,
    offcalen4,
    frefclk4,
    offcaldone4,
    txlcplllock4,
    rxfreqtxcmuplllock4,
    rxpllphaselock4,
    masktxplllock4,
    txpcsrstn5,
    rxpcsrstn5,
    g3txpcsrstn5,
    g3rxpcsrstn5,
    txpmasyncp5,
    rxpmarstb5,
    txlcpllrstb5,
    offcalen5,
    frefclk5,
    offcaldone5,
    txlcplllock5,
    rxfreqtxcmuplllock5,
    rxpllphaselock5,
    masktxplllock5,
    txpcsrstn6,
    rxpcsrstn6,
    g3txpcsrstn6,
    g3rxpcsrstn6,
    txpmasyncp6,
    rxpmarstb6,
    txlcpllrstb6,
    offcalen6,
    frefclk6,
    offcaldone6,
    txlcplllock6,
    rxfreqtxcmuplllock6,
    rxpllphaselock6,
    masktxplllock6,
    txpcsrstn7,
    rxpcsrstn7,
    g3txpcsrstn7,
    g3rxpcsrstn7,
    txpmasyncp7,
    rxpmarstb7,
    txlcpllrstb7,
    offcalen7,
    frefclk7,
    offcaldone7,
    txlcplllock7,
    rxfreqtxcmuplllock7,
    rxpllphaselock7,
    masktxplllock7,
    txpcsrstn8,
    rxpcsrstn8,
    g3txpcsrstn8,
    g3rxpcsrstn8,
    txpmasyncp8,
    rxpmarstb8,
    txlcpllrstb8,
    offcalen8,
    frefclk8,
    offcaldone8,
    txlcplllock8,
    rxfreqtxcmuplllock8,
    rxpllphaselock8,
    masktxplllock8,
    txpcsrstn9,
    rxpcsrstn9,
    g3txpcsrstn9,
    g3rxpcsrstn9,
    txpmasyncp9,
    rxpmarstb9,
    txlcpllrstb9,
    offcalen9,
    frefclk9,
    offcaldone9,
    txlcplllock9,
    rxfreqtxcmuplllock9,
    rxpllphaselock9,
    masktxplllock9,
    txpcsrstn10,
    rxpcsrstn10,
    g3txpcsrstn10,
    g3rxpcsrstn10,
    txpmasyncp10,
    rxpmarstb10,
    txlcpllrstb10,
    offcalen10,
    frefclk10,
    offcaldone10,
    txlcplllock10,
    rxfreqtxcmuplllock10,
    rxpllphaselock10,
    masktxplllock10,
    txpcsrstn11,
    rxpcsrstn11,
    g3txpcsrstn11,
    g3rxpcsrstn11,
    txpmasyncp11,
    rxpmarstb11,
    txlcpllrstb11,
    offcalen11,
    frefclk11,
    offcaldone11,
    txlcplllock11,
    rxfreqtxcmuplllock11,
    rxpllphaselock11,
    masktxplllock11,

    reservedin,
    reservedclkin,
    reservedout,
    reservedclkout);

    parameter    func_mode    =    "disable";
    parameter    in_cvp_mode = "not_cvp_mode"; // Enable CVP
    parameter    bonding_mode    =    "bond_disable";
    parameter    prot_mode    =    "disabled_prot_mode";
    parameter    pcie_spec_1p0_compliance    =    "spec_1p1";
    parameter    vc_enable    =    "single_vc";
    parameter    enable_slot_register    =    "false";
    parameter    pcie_mode    =    "shared_mode";
    parameter    bypass_cdc    =    "false";
    parameter    enable_rx_reordering    =    "true";
    parameter    enable_rx_buffer_checking    =    "false";
    parameter    single_rx_detect_data    =    4'b0;
    parameter    single_rx_detect    =    "single_rx_detect";
    parameter    use_crc_forwarding    =    "false";
    parameter    bypass_tl    =    "false";
    parameter    gen123_lane_rate_mode    =    "gen1";
    parameter    lane_mask    =    "x4";
    parameter    disable_link_x2_support    =    "false";
    parameter    national_inst_thru_enhance    =    "true";
    parameter    hip_hard_reset    =    "enable";
    parameter    dis_paritychk    =    "enable";
    parameter    wrong_device_id    =    "disable";
    parameter    data_pack_rx    =    "disable";
    parameter    ast_width    =    "rx_tx_64";
    parameter    rx_sop_ctrl    =    "boundary_64";
    parameter    rx_ast_parity    =    "disable";
    parameter    tx_ast_parity    =    "disable";
    parameter    ltssm_1ms_timeout    =    "disable";
    parameter    ltssm_freqlocked_check    =    "disable";
    parameter    deskew_comma    =    "skp_eieos_deskw";
    parameter    dl_tx_check_parity_edb    =    "disable";
    parameter    tl_tx_check_parity_msg    =    "disable";
    parameter    port_link_number_data    =    8'b1;
    parameter    port_link_number    =    "port_link_number";
    parameter    device_number_data    =    5'b0;
    parameter    device_number    =    "device_number";
    parameter    bypass_clk_switch    =    "false";
    parameter    core_clk_out_sel    =    "div_1";
    parameter    core_clk_divider    =    "div_1";
    parameter    core_clk_source    =    "pll_fixed_clk";
    parameter    core_clk_sel    =    "pld_clk";
    parameter    enable_ch0_pclk_out    =    "pclk_ch01";
    parameter    enable_ch01_pclk_out    =    "pclk_ch0";
    parameter    pipex1_debug_sel    =    "disable";
    parameter    pclk_out_sel    =    "pclk";
    parameter    vendor_id_data    =    16'b1000101110010;
    parameter    vendor_id    =    "vendor_id";
    parameter    device_id_data    =    16'b1;
    parameter    device_id    =    "device_id";
    parameter    revision_id_data    =    8'b1;
    parameter    revision_id    =    "revision_id";
    parameter    class_code_data    =    24'b111111110000000000000000;
    parameter    class_code    =    "class_code";
    parameter    subsystem_vendor_id_data    =    16'b1000101110010;
    parameter    subsystem_vendor_id    =    "subsystem_vendor_id";
    parameter    subsystem_device_id_data    =    16'b1;
    parameter    subsystem_device_id    =    "subsystem_device_id";
    parameter    no_soft_reset    =    "false";
    parameter    maximum_current_data    =    3'b0;
    parameter    maximum_current    =    "maximum_current";
    parameter    d1_support    =    "false";
    parameter    d2_support    =    "false";
    parameter    d0_pme    =    "false";
    parameter    d1_pme    =    "false";
    parameter    d2_pme    =    "false";
    parameter    d3_hot_pme    =    "false";
    parameter    d3_cold_pme    =    "false";
    parameter    use_aer    =    "false";
    parameter    low_priority_vc    =    "single_vc";
    parameter    vc_arbitration    =    "single_vc";
    parameter    disable_snoop_packet    =    "false";
    parameter    max_payload_size    =    "payload_512";
    parameter    surprise_down_error_support    =    "false";
    parameter    dll_active_report_support    =    "false";
    parameter    extend_tag_field    =    "false";
    parameter    endpoint_l0_latency_data    =    3'b0;
    parameter    endpoint_l0_latency    =    "endpoint_l0_latency";
    parameter    endpoint_l1_latency_data    =    3'b0;
    parameter    endpoint_l1_latency    =    "endpoint_l1_latency";
    parameter    indicator_data    =    3'b111;
    parameter    indicator    =    "indicator";
    parameter    role_based_error_reporting    =    "false";
    parameter    slot_power_scale_data    =    2'b0;
    parameter    slot_power_scale    =    "slot_power_scale";
    parameter    max_link_width    =    "x4";
    parameter    enable_l1_aspm    =    "false";
    parameter    enable_l0s_aspm    =    "false";
    parameter    l1_exit_latency_sameclock_data    =    3'b0;
    parameter    l1_exit_latency_sameclock    =    "l1_exit_latency_sameclock";
    parameter    l1_exit_latency_diffclock_data    =    3'b0;
    parameter    l1_exit_latency_diffclock    =    "l1_exit_latency_diffclock";
    parameter    hot_plug_support_data    =    7'b0;
    parameter    hot_plug_support    =    "hot_plug_support";
    parameter    slot_power_limit_data    =    8'b0;
    parameter    slot_power_limit    =    "slot_power_limit";
    parameter    slot_number_data    =    13'b0;
    parameter    slot_number    =    "slot_number";
    parameter    diffclock_nfts_count_data    =    8'b0;
    parameter    diffclock_nfts_count    =    "diffclock_nfts_count";
    parameter    sameclock_nfts_count_data    =    8'b0;
    parameter    sameclock_nfts_count    =    "sameclock_nfts_count";
    parameter    completion_timeout    =    "abcd";
    parameter    enable_completion_timeout_disable    =    "true";
    parameter    extended_tag_reset    =    "false";
    parameter    ecrc_check_capable    =    "true";
    parameter    ecrc_gen_capable    =    "true";
    parameter    no_command_completed    =    "true";
    parameter    msi_multi_message_capable    =    "count_4";
    parameter    msi_64bit_addressing_capable    =    "true";
    parameter    msi_masking_capable    =    "false";
    parameter    msi_support    =    "true";
    parameter    interrupt_pin    =    "inta";
    parameter    ena_ido_req    =    "false";
    parameter    ena_ido_cpl    =    "false";
    parameter    enable_function_msix_support    =    "true";
    parameter    msix_table_size_data    =    11'b0;
    parameter    msix_table_size    =    "msix_table_size";
    parameter    msix_table_bir_data    =    3'b0;
    parameter    msix_table_bir    =    "msix_table_bir";
    parameter    msix_table_offset_data    =    29'b0;
    parameter    msix_table_offset    =    "msix_table_offset";
    parameter    msix_pba_bir_data    =    3'b0;
    parameter    msix_pba_bir    =    "msix_pba_bir";
    parameter    msix_pba_offset_data    =    29'b0;
    parameter    msix_pba_offset    =    "msix_pba_offset";
    parameter    bridge_port_vga_enable    =    "false";
    parameter    bridge_port_ssid_support    =    "false";
    parameter    ssvid_data    =    16'b0;
    parameter    ssvid    =    "ssvid";
    parameter    ssid_data    =    16'b0;
    parameter    ssid    =    "ssid";
    parameter    eie_before_nfts_count_data    =    4'b100;
    parameter    eie_before_nfts_count    =    "eie_before_nfts_count";
    parameter    gen2_diffclock_nfts_count_data    =    8'b11111111;
    parameter    gen2_diffclock_nfts_count    =    "gen2_diffclock_nfts_count";
    parameter    gen2_sameclock_nfts_count_data    =    8'b11111111;
    parameter    gen2_sameclock_nfts_count    =    "gen2_sameclock_nfts_count";
    parameter    deemphasis_enable    =    "false";
    parameter    pcie_spec_version    =    "v2";
    parameter    l0_exit_latency_sameclock_data    =    3'b110;
    parameter    l0_exit_latency_sameclock    =    "l0_exit_latency_sameclock";
    parameter    l0_exit_latency_diffclock_data    =    3'b110;
    parameter    l0_exit_latency_diffclock    =    "l0_exit_latency_diffclock";
    parameter    rx_ei_l0s    =    "disable";
    parameter    l2_async_logic    =    "enable";
    parameter    aspm_config_management    =    "true";
    parameter    atomic_op_routing    =    "false";
    parameter    atomic_op_completer_32bit    =    "false";
    parameter    atomic_op_completer_64bit    =    "false";
    parameter    cas_completer_128bit    =    "false";
    parameter    ltr_mechanism    =    "false";
    parameter    tph_completer    =    "false";
    parameter    extended_format_field    =    "true";
    parameter    atomic_malformed    =    "false";
    parameter    flr_capability    =    "true";
    parameter    enable_adapter_half_rate_mode    =    "false";
    parameter    vc0_clk_enable    =    "true";
    parameter    vc1_clk_enable    =    "false";
    parameter    register_pipe_signals    =    "false";
    parameter    bar0_io_space    =    "false";
    parameter    bar0_64bit_mem_space    =    "true";
    parameter    bar0_prefetchable    =    "true";
    parameter    bar0_size_mask_data    =    28'b1111111111111111111111111111;
    parameter    bar0_size_mask    =    "bar0_size_mask";
    parameter    bar1_io_space    =    "false";
    parameter    bar1_64bit_mem_space    =    "false";
    parameter    bar1_prefetchable    =    "false";
    parameter    bar1_size_mask_data    =    28'b0;
    parameter    bar1_size_mask    =    "bar1_size_mask";
    parameter    bar2_io_space    =    "false";
    parameter    bar2_64bit_mem_space    =    "false";
    parameter    bar2_prefetchable    =    "false";
    parameter    bar2_size_mask_data    =    28'b0;
    parameter    bar2_size_mask    =    "bar2_size_mask";
    parameter    bar3_io_space    =    "false";
    parameter    bar3_64bit_mem_space    =    "false";
    parameter    bar3_prefetchable    =    "false";
    parameter    bar3_size_mask_data    =    28'b0;
    parameter    bar3_size_mask    =    "bar3_size_mask";
    parameter    bar4_io_space    =    "false";
    parameter    bar4_64bit_mem_space    =    "false";
    parameter    bar4_prefetchable    =    "false";
    parameter    bar4_size_mask_data    =    28'b0;
    parameter    bar4_size_mask    =    "bar4_size_mask";
    parameter    bar5_io_space    =    "false";
    parameter    bar5_64bit_mem_space    =    "false";
    parameter    bar5_prefetchable    =    "false";
    parameter    bar5_size_mask_data    =    28'b0;
    parameter    bar5_size_mask    =    "bar5_size_mask";
    parameter    expansion_base_address_register_data    =    32'b0;
    parameter    expansion_base_address_register    =    "expansion_base_address_register";
    parameter    io_window_addr_width    =    "window_32_bit";
    parameter    prefetchable_mem_window_addr_width    =    "prefetch_32";
    parameter    skp_os_gen3_count_data    =    11'b0;
    parameter    skp_os_gen3_count    =    "skp_os_gen3_count";
    parameter    rx_cdc_almost_empty_data    =    4'h0;
    parameter    rx_cdc_almost_empty    =    "rx_cdc_almost_empty";
    parameter    tx_cdc_almost_empty_data    =    4'h0;
    parameter    tx_cdc_almost_empty    =    "tx_cdc_almost_empty";
    parameter    rx_cdc_almost_full_data    =    4'h0;
    parameter    rx_cdc_almost_full    =    "rx_cdc_almost_full";
    parameter    tx_cdc_almost_full_data    =    4'h0;
    parameter    tx_cdc_almost_full    =    "tx_cdc_almost_full";
    parameter    rx_l0s_count_idl_data    =    8'b0;
    parameter    rx_l0s_count_idl    =    "rx_l0s_count_idl";
    parameter    cdc_dummy_insert_limit_data    =    4'h0;
    parameter    cdc_dummy_insert_limit    =    "cdc_dummy_insert_limit";
    parameter    ei_delay_powerdown_count_data    =    8'b1010;
    parameter    ei_delay_powerdown_count    =    "ei_delay_powerdown_count";
    parameter    millisecond_cycle_count_data    =    20'b0;
    parameter    millisecond_cycle_count    =    "millisecond_cycle_count";
    parameter    skp_os_schedule_count_data    =    11'b0;
    parameter    skp_os_schedule_count    =    "skp_os_schedule_count";
    parameter    fc_init_timer_data    =    11'b10000000000;
    parameter    fc_init_timer    =    "fc_init_timer";
    parameter    l01_entry_latency_data    =    5'b11111;
    parameter    l01_entry_latency    =    "l01_entry_latency";
    parameter    flow_control_update_count_data    =    5'b11110;
    parameter    flow_control_update_count    =    "flow_control_update_count";
    parameter    flow_control_timeout_count_data    =    8'b11001000;
    parameter    flow_control_timeout_count    =    "flow_control_timeout_count";
    parameter    vc0_rx_flow_ctrl_posted_header_data    =    8'b110010;
    parameter    vc0_rx_flow_ctrl_posted_header    =    "vc0_rx_flow_ctrl_posted_header";
    parameter    vc0_rx_flow_ctrl_posted_data_data    =    12'b101101000;
    parameter    vc0_rx_flow_ctrl_posted_data    =    "vc0_rx_flow_ctrl_posted_data";
    parameter    vc0_rx_flow_ctrl_nonposted_header_data    =    8'b110110;
    parameter    vc0_rx_flow_ctrl_nonposted_header    =    "vc0_rx_flow_ctrl_nonposted_header";
    parameter    vc0_rx_flow_ctrl_nonposted_data_data    =    8'b0;
    parameter    vc0_rx_flow_ctrl_nonposted_data    =    "vc0_rx_flow_ctrl_nonposted_data";
    parameter    vc0_rx_flow_ctrl_compl_header_data    =    8'b1110000;
    parameter    vc0_rx_flow_ctrl_compl_header    =    "vc0_rx_flow_ctrl_compl_header";
    parameter    vc0_rx_flow_ctrl_compl_data_data    =    12'b111000000;
    parameter    vc0_rx_flow_ctrl_compl_data    =    "vc0_rx_flow_ctrl_compl_data";
    parameter    rx_ptr0_posted_dpram_min_data    =    11'b0;
    parameter    rx_ptr0_posted_dpram_min    =    "rx_ptr0_posted_dpram_min";
    parameter    rx_ptr0_posted_dpram_max_data    =    11'b0;
    parameter    rx_ptr0_posted_dpram_max    =    "rx_ptr0_posted_dpram_max";
    parameter    rx_ptr0_nonposted_dpram_min_data    =    11'b0;
    parameter    rx_ptr0_nonposted_dpram_min    =    "rx_ptr0_nonposted_dpram_min";
    parameter    rx_ptr0_nonposted_dpram_max_data    =    11'b0;
    parameter    rx_ptr0_nonposted_dpram_max    =    "rx_ptr0_nonposted_dpram_max";
    parameter    retry_buffer_last_active_address_data    =    10'b1111111111;
    parameter    retry_buffer_last_active_address    =    "retry_buffer_last_active_address";
    parameter    retry_buffer_memory_settings_data    =    30'b0;
    parameter    retry_buffer_memory_settings    =    "retry_buffer_memory_settings";
    parameter    vc0_rx_buffer_memory_settings_data    =    30'b0;
    parameter    vc0_rx_buffer_memory_settings    =    "vc0_rx_buffer_memory_settings";
    parameter    bist_memory_settings_data    =    75'b0;
    parameter    bist_memory_settings    =    "bist_memory_settings";
    parameter    credit_buffer_allocation_aux    =    "balanced";
    parameter    iei_enable_settings    =    "gen2_infei_infsd_gen1_infei_sd";
    parameter    vsec_id_data    =    16'b1000101110010;
    parameter    vsec_id    =    "vsec_id";
    parameter    cvp_rate_sel    =    "full_rate";
    parameter    hard_reset_bypass    =    "false";
    parameter    cvp_data_compressed    =    "false";
    parameter    cvp_data_encrypted    =    "false";
    parameter    cvp_mode_reset    =    "false";
    parameter    cvp_clk_reset    =    "false";
    parameter    vsec_cap_data    =    4'b0;
    parameter    vsec_cap    =    "vsec_cap";
    parameter    jtag_id_data    =    32'b0;
    parameter    jtag_id    =    "jtag_id";
    parameter    user_id_data    =    16'b0;
    parameter    user_id    =    "user_id";
    parameter    cseb_extend_pci    =    "false";
    parameter    cseb_extend_pcie    =    "false";
    parameter    cseb_cpl_status_during_cvp    =    "config_retry_status";
    parameter    cseb_route_to_avl_rx_st    =    "cseb";
    parameter    cseb_config_bypass    =    "disable";
    parameter    cseb_cpl_tag_checking    =    "enable";
    parameter    cseb_bar_match_checking    =    "enable";
    parameter    cseb_min_error_checking    =    "false";
    parameter    cseb_temp_busy_crs    =    "completer_abort";
    parameter    cseb_disable_auto_crs    =    "false";
    parameter    gen3_diffclock_nfts_count_data    =    8'b10000000;
    parameter    gen3_diffclock_nfts_count    =    "g3_diffclock_nfts_count";
    parameter    gen3_sameclock_nfts_count_data    =    8'b10000000;
    parameter    gen3_sameclock_nfts_count    =    "g3_sameclock_nfts_count";
    parameter    gen3_coeff_errchk    =    "enable";
    parameter    gen3_paritychk    =    "enable";
    parameter    gen3_coeff_delay_count_data    =    7'b1111101;
    parameter    gen3_coeff_delay_count    =    "g3_coeff_dly_count";
    parameter    gen3_coeff_1_data    =    18'b0;
    parameter    gen3_coeff_1    =    "g3_coeff_1";
    parameter    gen3_coeff_1_sel    =    "coeff_1";
    parameter    gen3_coeff_1_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_1_preset_hint    =    "g3_coeff_1_prst_hint";
    parameter    gen3_coeff_1_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_1_nxtber_more    =    "g3_coeff_1_nxtber_more";
    parameter    gen3_coeff_1_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_1_nxtber_less    =    "g3_coeff_1_nxtber_less";
    parameter    gen3_coeff_1_reqber_data    =    5'b0;
    parameter    gen3_coeff_1_reqber    =    "g3_coeff_1_reqber";
    parameter    gen3_coeff_1_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_1_ber_meas    =    "g3_coeff_1_ber_meas";
    parameter    gen3_coeff_2_data    =    18'b0;
    parameter    gen3_coeff_2    =    "g3_coeff_2";
    parameter    gen3_coeff_2_sel    =    "coeff_2";
    parameter    gen3_coeff_2_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_2_preset_hint    =    "g3_coeff_2_prst_hint";
    parameter    gen3_coeff_2_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_2_nxtber_more    =    "g3_coeff_2_nxtber_more";
    parameter    gen3_coeff_2_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_2_nxtber_less    =    "g3_coeff_2_nxtber_less";
    parameter    gen3_coeff_2_reqber_data    =    5'b0;
    parameter    gen3_coeff_2_reqber    =    "g3_coeff_2_reqber";
    parameter    gen3_coeff_2_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_2_ber_meas    =    "g3_coeff_1_ber_meas";
    parameter    gen3_coeff_3_data    =    18'b0;
    parameter    gen3_coeff_3    =    "g3_coeff_3";
    parameter    gen3_coeff_3_sel    =    "coeff_3";
    parameter    gen3_coeff_3_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_3_preset_hint    =    "g3_coeff_3_prst_hint";
    parameter    gen3_coeff_3_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_3_nxtber_more    =    "g3_coeff_3_nxtber_more";
    parameter    gen3_coeff_3_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_3_nxtber_less    =    "g3_coeff_3_nxtber_less";
    parameter    gen3_coeff_3_reqber_data    =    5'b0;
    parameter    gen3_coeff_3_reqber    =    "g3_coeff_3_reqber";
    parameter    gen3_coeff_3_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_3_ber_meas    =    "g3_coeff_3_ber_meas";
    parameter    gen3_coeff_4_data    =    18'b0;
    parameter    gen3_coeff_4    =    "g3_coeff_4";
    parameter    gen3_coeff_4_sel    =    "coeff_4";
    parameter    gen3_coeff_4_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_4_preset_hint    =    "g3_coeff_4_prst_hint";
    parameter    gen3_coeff_4_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_4_nxtber_more    =    "g3_coeff_4_nxtber_more";
    parameter    gen3_coeff_4_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_4_nxtber_less    =    "g3_coeff_4_nxtber_less";
    parameter    gen3_coeff_4_reqber_data    =    5'b0;
    parameter    gen3_coeff_4_reqber    =    "g3_coeff_4_reqber";
    parameter    gen3_coeff_4_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_4_ber_meas    =    "g3_coeff_4_ber_meas";
    parameter    gen3_coeff_5_data    =    18'b0;
    parameter    gen3_coeff_5    =    "g3_coeff_5";
    parameter    gen3_coeff_5_sel    =    "coeff_5";
    parameter    gen3_coeff_5_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_5_preset_hint    =    "g3_coeff_5_prst_hint";
    parameter    gen3_coeff_5_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_5_nxtber_more    =    "g3_coeff_5_nxtber_more";
    parameter    gen3_coeff_5_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_5_nxtber_less    =    "g3_coeff_5_nxtber_less";
    parameter    gen3_coeff_5_reqber_data    =    5'b0;
    parameter    gen3_coeff_5_reqber    =    "g3_coeff_5_reqber";
    parameter    gen3_coeff_5_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_5_ber_meas    =    "g3_coeff_5_ber_meas";
    parameter    gen3_coeff_6_data    =    18'b0;
    parameter    gen3_coeff_6    =    "g3_coeff_6";
    parameter    gen3_coeff_6_sel    =    "coeff_6";
    parameter    gen3_coeff_6_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_6_preset_hint    =    "g3_coeff_6_prst_hint";
    parameter    gen3_coeff_6_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_6_nxtber_more    =    "g3_coeff_6_nxtber_more";
    parameter    gen3_coeff_6_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_6_nxtber_less    =    "g3_coeff_6_nxtber_less";
    parameter    gen3_coeff_6_reqber_data    =    5'b0;
    parameter    gen3_coeff_6_reqber    =    "g3_coeff_6_reqber";
    parameter    gen3_coeff_6_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_6_ber_meas    =    "g3_coeff_6_ber_meas";
    parameter    gen3_coeff_7_data    =    18'b0;
    parameter    gen3_coeff_7    =    "g3_coeff_7";
    parameter    gen3_coeff_7_sel    =    "coeff_7";
    parameter    gen3_coeff_7_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_7_preset_hint    =    "g3_coeff_7_prst_hint";
    parameter    gen3_coeff_7_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_7_nxtber_more    =    "g3_coeff_7_nxtber_more";
    parameter    gen3_coeff_7_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_7_nxtber_less    =    "g3_coeff_7_nxtber_less";
    parameter    gen3_coeff_7_reqber_data    =    5'b0;
    parameter    gen3_coeff_7_reqber    =    "g3_coeff_7_reqber";
    parameter    gen3_coeff_7_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_7_ber_meas    =    "g3_coeff_7_ber_meas";
    parameter    gen3_coeff_8_data    =    18'b0;
    parameter    gen3_coeff_8    =    "g3_coeff_8";
    parameter    gen3_coeff_8_sel    =    "coeff_8";
    parameter    gen3_coeff_8_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_8_preset_hint    =    "g3_coeff_8_prst_hint";
    parameter    gen3_coeff_8_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_8_nxtber_more    =    "g3_coeff_8_nxtber_more";
    parameter    gen3_coeff_8_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_8_nxtber_less    =    "g3_coeff_8_nxtber_less";
    parameter    gen3_coeff_8_reqber_data    =    5'b0;
    parameter    gen3_coeff_8_reqber    =    "g3_coeff_8_reqber";
    parameter    gen3_coeff_8_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_8_ber_meas    =    "g3_coeff_8_ber_meas";
    parameter    gen3_coeff_9_data    =    18'b0;
    parameter    gen3_coeff_9    =    "g3_coeff_9";
    parameter    gen3_coeff_9_sel    =    "coeff_9";
    parameter    gen3_coeff_9_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_9_preset_hint    =    "g3_coeff_9_prst_hint";
    parameter    gen3_coeff_9_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_9_nxtber_more    =    "g3_coeff_9_nxtber_more";
    parameter    gen3_coeff_9_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_9_nxtber_less    =    "g3_coeff_9_nxtber_less";
    parameter    gen3_coeff_9_reqber_data    =    5'b0;
    parameter    gen3_coeff_9_reqber    =    "g3_coeff_9_reqber";
    parameter    gen3_coeff_9_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_9_ber_meas    =    "g3_coeff_9_ber_meas";
    parameter    gen3_coeff_10_data    =    18'b0;
    parameter    gen3_coeff_10    =    "g3_coeff_10";
    parameter    gen3_coeff_10_sel    =    "coeff_10";
    parameter    gen3_coeff_10_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_10_preset_hint    =    "g3_coeff_10_prst_hint";
    parameter    gen3_coeff_10_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_10_nxtber_more    =    "g3_coeff_10_nxtber_more";
    parameter    gen3_coeff_10_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_10_nxtber_less    =    "g3_coeff_10_nxtber_less";
    parameter    gen3_coeff_10_reqber_data    =    5'b0;
    parameter    gen3_coeff_10_reqber    =    "g3_coeff_10_reqber";
    parameter    gen3_coeff_10_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_10_ber_meas    =    "g3_coeff_10_ber_meas";
    parameter    gen3_coeff_11_data    =    18'b0;
    parameter    gen3_coeff_11    =    "g3_coeff_11";
    parameter    gen3_coeff_11_sel    =    "coeff_11";
    parameter    gen3_coeff_11_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_11_preset_hint    =    "g3_coeff_11_prst_hint";
    parameter    gen3_coeff_11_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_11_nxtber_more    =    "g3_coeff_11_nxtber_more";
    parameter    gen3_coeff_11_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_11_nxtber_less    =    "g3_coeff_11_nxtber_less";
    parameter    gen3_coeff_11_reqber_data    =    5'b0;
    parameter    gen3_coeff_11_reqber    =    "g3_coeff_11_reqber";
    parameter    gen3_coeff_11_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_11_ber_meas    =    "g3_coeff_11_ber_meas";
    parameter    gen3_coeff_12_data    =    18'b0;
    parameter    gen3_coeff_12    =    "g3_coeff_12";
    parameter    gen3_coeff_12_sel    =    "coeff_12";
    parameter    gen3_coeff_12_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_12_preset_hint    =    "g3_coeff_12_prst_hint";
    parameter    gen3_coeff_12_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_12_nxtber_more    =    "g3_coeff_12_nxtber_more";
    parameter    gen3_coeff_12_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_12_nxtber_less    =    "g3_coeff_12_nxtber_less";
    parameter    gen3_coeff_12_reqber_data    =    5'b0;
    parameter    gen3_coeff_12_reqber    =    "g3_coeff_12_reqber";
    parameter    gen3_coeff_12_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_12_ber_meas    =    "g3_coeff_12_ber_meas";
    parameter    gen3_coeff_13_data    =    18'b0;
    parameter    gen3_coeff_13    =    "g3_coeff_13";
    parameter    gen3_coeff_13_sel    =    "coeff_13";
    parameter    gen3_coeff_13_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_13_preset_hint    =    "g3_coeff_13_prst_hint";
    parameter    gen3_coeff_13_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_13_nxtber_more    =    "g3_coeff_13_nxtber_more";
    parameter    gen3_coeff_13_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_13_nxtber_less    =    "g3_coeff_13_nxtber_less";
    parameter    gen3_coeff_13_reqber_data    =    5'b0;
    parameter    gen3_coeff_13_reqber    =    "g3_coeff_13_reqber";
    parameter    gen3_coeff_13_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_13_ber_meas    =    "g3_coeff_13_ber_meas";
    parameter    gen3_coeff_14_data    =    18'b0;
    parameter    gen3_coeff_14    =    "g3_coeff_14";
    parameter    gen3_coeff_14_sel    =    "coeff_14";
    parameter    gen3_coeff_14_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_14_preset_hint    =    "g3_coeff_14_prst_hint";
    parameter    gen3_coeff_14_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_14_nxtber_more    =    "g3_coeff_14_nxtber_more";
    parameter    gen3_coeff_14_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_14_nxtber_less    =    "g3_coeff_14_nxtber_less";
    parameter    gen3_coeff_14_reqber_data    =    5'b0;
    parameter    gen3_coeff_14_reqber    =    "g3_coeff_14_reqber";
    parameter    gen3_coeff_14_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_14_ber_meas    =    "g3_coeff_14_ber_meas";
    parameter    gen3_coeff_15_data    =    18'b0;
    parameter    gen3_coeff_15    =    "g3_coeff_15";
    parameter    gen3_coeff_15_sel    =    "coeff_15";
    parameter    gen3_coeff_15_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_15_preset_hint    =    "g3_coeff_15_prst_hint";
    parameter    gen3_coeff_15_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_15_nxtber_more    =    "g3_coeff_15_nxtber_more";
    parameter    gen3_coeff_15_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_15_nxtber_less    =    "g3_coeff_15_nxtber_less";
    parameter    gen3_coeff_15_reqber_data    =    5'b0;
    parameter    gen3_coeff_15_reqber    =    "g3_coeff_15_reqber";
    parameter    gen3_coeff_15_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_15_ber_meas    =    "g3_coeff_15_ber_meas";
    parameter    gen3_coeff_16_data    =    18'b0;
    parameter    gen3_coeff_16    =    "g3_coeff_16";
    parameter    gen3_coeff_16_sel    =    "coeff_16";
    parameter    gen3_coeff_16_preset_hint_data    =    3'b0;
    parameter    gen3_coeff_16_preset_hint    =    "g3_coeff_16_prst_hint";
    parameter    gen3_coeff_16_nxtber_more_ptr    =    4'b0;
    parameter    gen3_coeff_16_nxtber_more    =    "g3_coeff_16_nxtber_more";
    parameter    gen3_coeff_16_nxtber_less_ptr    =    4'b0;
    parameter    gen3_coeff_16_nxtber_less    =    "g3_coeff_16_nxtber_less";
    parameter    gen3_coeff_16_reqber_data    =    5'b0;
    parameter    gen3_coeff_16_reqber    =    "g3_coeff_16_reqber";
    parameter    gen3_coeff_16_ber_meas_data    =    6'b0;
    parameter    gen3_coeff_16_ber_meas    =    "g3_coeff_16_ber_meas";
    parameter    gen3_preset_coeff_1_data    =    18'b0;
    parameter    gen3_preset_coeff_1    =    "g3_prst_coeff_1";
    parameter    gen3_preset_coeff_2_data    =    18'b0;
    parameter    gen3_preset_coeff_2    =    "g3_prst_coeff_2";
    parameter    gen3_preset_coeff_3_data    =    18'b0;
    parameter    gen3_preset_coeff_3    =    "g3_prst_coeff_3";
    parameter    gen3_preset_coeff_4_data    =    18'b0;
    parameter    gen3_preset_coeff_4    =    "g3_prst_coeff_4";
    parameter    gen3_preset_coeff_5_data    =    18'b0;
    parameter    gen3_preset_coeff_5    =    "g3_prst_coeff_5";
    parameter    gen3_preset_coeff_6_data    =    18'b0;
    parameter    gen3_preset_coeff_6    =    "g3_prst_coeff_6";
    parameter    gen3_preset_coeff_7_data    =    18'b0;
    parameter    gen3_preset_coeff_7    =    "g3_prst_coeff_7";
    parameter    gen3_preset_coeff_8_data    =    18'b0;
    parameter    gen3_preset_coeff_8    =    "g3_prst_coeff_8";
    parameter    gen3_preset_coeff_9_data    =    18'b0;
    parameter    gen3_preset_coeff_9    =    "g3_prst_coeff_9";
    parameter    gen3_preset_coeff_10_data    =    18'b0;
    parameter    gen3_preset_coeff_10    =    "g3_prst_coeff_10";
    parameter    gen3_rxfreqlock_counter_data    =    20'b0;
    parameter    gen3_rxfreqlock_counter    =    "g3_rxfreqlock_count";

    parameter rstctrl_pld_clr                    = "false";// "false", "true".
    parameter rstctrl_debug_en                   = "false";// "false", "true".
    parameter rstctrl_force_inactive_rst         = "false";// "false", "true".
    parameter rstctrl_perst_enable               = "level";// "level", "neg_edge", "not_used".
    parameter hrdrstctrl_en                      = "hrdrstctrl_dis";//"hrdrstctrl_dis", "hrdrstctrl_en".
    parameter rstctrl_hip_ep                     = "hip_ep";      //"hip_ep", "hip_not_ep".
    parameter rstctrl_hard_block_enable          = "hard_rst_ctl";//"hard_rst_ctl", "pld_rst_ctl".
    parameter rstctrl_rx_pma_rstb_inv            = "false";//"false", "true".
    parameter rstctrl_tx_pma_rstb_inv            = "false";//"false", "true".
    parameter rstctrl_rx_pcs_rst_n_inv           = "false";//"false", "true".
    parameter rstctrl_tx_pcs_rst_n_inv           = "false";//"false", "true".
    parameter rstctrl_altpe3_crst_n_inv          = "false";//"false", "true".
    parameter rstctrl_altpe3_srst_n_inv          = "false";//"false", "true".
    parameter rstctrl_altpe3_rst_n_inv           = "false";//"false", "true".
    parameter rstctrl_tx_pma_syncp_inv           = "false";//"false", "true".
    parameter rstctrl_1us_count_fref_clk         = "rstctrl_1us_cnt";//
    parameter rstctrl_1us_count_fref_clk_value   = 20'b00000000000000111111;//
    parameter rstctrl_1ms_count_fref_clk         = "rstctrl_1ms_cnt";//
    parameter rstctrl_1ms_count_fref_clk_value   = 20'b00001111010000100100;//

    parameter rstctrl_off_cal_done_select        = "not_active";// "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active".
    parameter rstctrl_rx_pma_rstb_cmu_select     = "not_active";// "ch1cmu_sel", "ch4cmu_sel", "ch4_10cmu_sel", "not_active".
    parameter rstctrl_rx_pll_freq_lock_select    = "not_active";// "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active", "ch0_phs_sel", "ch01_phs_sel", "ch0123_phs_sel", "ch0123_5678_phs_sel".
    parameter rstctrl_mask_tx_pll_lock_select    = "not_active";// "ch1_sel", "ch4_sel", "ch4_10_sel", "not_active".
    parameter rstctrl_rx_pll_lock_select         = "not_active";// "ch0_sel", "ch01_sel", "ch0123_sel", "ch0123_5678_sel", "not_active".
    parameter rstctrl_perstn_select              = "perstn_pin";// "perstn_pin", "perstn_pld".
    parameter rstctrl_tx_lc_pll_rstb_select      = "not_active";// "ch1_out", "ch7_out", "not_active".
    parameter rstctrl_fref_clk_select            = "ch0_sel";// "ch0_sel", "ch1_sel", "ch2_sel", "ch3_sel", "ch4_sel", "ch5_sel", "ch6_sel", "ch7_sel", "ch8_sel", "ch9_sel", "ch10_sel", "ch11_sel".
    parameter rstctrl_off_cal_en_select          = "not_active";// "ch0_out", "ch01_out", "ch0123_out", "ch0123_5678_out", "not_active".
    parameter rstctrl_tx_pma_syncp_select        = "not_active";// "ch1_out", "ch4_out", "ch4_10_out", "not_active".
    parameter rstctrl_rx_pcs_rst_n_select        = "not_active";// "ch0_out", "ch01_out", "ch0123_out", "ch012345678_out", "ch012345678_10_out", "not_active".
    parameter rstctrl_tx_cmu_pll_lock_select     = "not_active";// "ch1_sel", "ch4_sel", "ch4_10_sel", "not_active".
    parameter rstctrl_tx_pcs_rst_n_select        = "not_active";// "ch0_out", "ch01_out", "ch0123_out", "ch012345678_out", "ch012345678_10_out", "not_active".
    parameter rstctrl_tx_lc_pll_lock_select      = "not_active";// "ch1_sel", "ch7_sel", "not_active".

    parameter rstctrl_timer_a        = "rstctrl_timer_a";
    parameter rstctrl_timer_a_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_a_value  = 8'h1;
    parameter rstctrl_timer_b        = "rstctrl_timer_b";
    parameter rstctrl_timer_b_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_b_value  = 8'h1;
    parameter rstctrl_timer_c        = "rstctrl_timer_c";
    parameter rstctrl_timer_c_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_c_value  = 8'h1;
    parameter rstctrl_timer_d        = "rstctrl_timer_d";
    parameter rstctrl_timer_d_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_d_value  = 8'h1;
    parameter rstctrl_timer_e        = "rstctrl_timer_e";
    parameter rstctrl_timer_e_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_e_value  = 8'h1;
    parameter rstctrl_timer_f        = "rstctrl_timer_f";
    parameter rstctrl_timer_f_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_f_value  = 8'h1;
    parameter rstctrl_timer_g        = "rstctrl_timer_g";
    parameter rstctrl_timer_g_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_g_value  = 8'h1;
    parameter rstctrl_timer_h        = "rstctrl_timer_h";
    parameter rstctrl_timer_h_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_h_value  = 8'h1;
    parameter rstctrl_timer_i        = "rstctrl_timer_i";
    parameter rstctrl_timer_i_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_i_value  = 8'h1;
    parameter rstctrl_timer_j        = "rstctrl_timer_j";
    parameter rstctrl_timer_j_type   = "milli_secs";//possible values are: "not_enabled", "milli_secs", "micro_secs", "fref_cycles"
    parameter rstctrl_timer_j_value  = 8'h1;


    output    [15:0]    dpriostatus;
    output    [31:0]    lmidout;
    output    [0:0]    lmiack;
    input    [0:0]    lmirden;
    input    [0:0]    lmiwren;
    input    [11:0]    lmiaddr;
    input    [31:0]    lmidin;
    input    [0:0]    flrreset;
    output    [0:0]    flrsts;
    output    [0:0]    resetstatus;
    output    [0:0]    l2exit;
    output    [0:0]    hotrstexit;
    input    [0:0]    hiphardreset;
    output    [0:0]    dlupexit;
    output    [0:0]    coreclkout;
    input    [0:0]    pldclk;
    input    [0:0]    pldsrst;
    input    [0:0]    pldrst;
    input    [0:0]    pclkch0;
    input    [0:0]    pclkch1;
    input    [0:0]    pclkcentral;
    input    [0:0]    pllfixedclkch0;
    input    [0:0]    pllfixedclkch1;
    input    [0:0]    pllfixedclkcentral;
    input    [0:0]    phyrst;
    input    [0:0]    physrst;
    input    [0:0]    coreclkin;
    input    [0:0]    corerst;
    input    [0:0]    corepor;
    input    [0:0]    corecrst;
    input    [0:0]    coresrst;
    output    [6:0]    swdnout;
    output    [2:0]    swupout;
    input    [2:0]    swdnin;
    input    [6:0]    swupin;
    input    [1:0]    swctmod;
    output    [255:0]    rxstdata;
    output    [31:0]    rxstparity;
    output    [31:0]    rxstbe;
    output    [3:0]    rxsterr;
    output    [3:0]    rxstsop;
    output    [3:0]    rxsteop;
    output    [1:0]    rxstempty;
    output    [3:0]    rxstvalid;
    output    [7:0]    rxstbardec1;
    output    [7:0]    rxstbardec2;
    input    [0:0]    rxstmask;
    input    [0:0]    rxstready;
    output    [0:0]    txstready;
    output    [5:0]    txcredfchipcons;
    output    [5:0]    txcredfcinfinite;
    output    [7:0]    txcredhdrfcp;
    output    [11:0]    txcreddatafcp;
    output    [7:0]    txcredhdrfcnp;
    output    [11:0]    txcreddatafcnp;
    output    [7:0]    txcredhdrfccp;
    output    [11:0]    txcreddatafccp;
    input    [255:0]    txstdata;
    input    [31:0]    txstparity;
    input    [3:0]    txsterr;
    input    [3:0]    txstsop;
    input    [3:0]    txsteop;
    input    [1:0]    txstempty;
    input    [0:0]    txstvalid;
    output    [0:0]    r2cuncecc;
    output    [0:0]    rxcorrecc;
    output    [0:0]    retryuncecc;
    output    [0:0]    retrycorrecc;
    output    [0:0]    rxparerr;
    output    [1:0]    txparerr;
    output    [0:0]    r2cparerr;
    output    [0:0]    pmetosr;
    input    [0:0]    pmetocr;
    input    [0:0]    pmevent;
    input    [9:0]    pmdata;
    input    [0:0]    pmauxpwr;
    output    [52:0]    tlcfgsts;
    output    [31:0]    tlcfgctl;
    output    [3:0]    tlcfgadd;
    output    [0:0]    appintaack;
    input    [0:0]    appintasts;
    output    [3:0]    intstatus;
    output    [0:0]    appmsiack;
    input    [0:0]    appmsireq;
    input    [2:0]    appmsitc;
    input    [4:0]    appmsinum;
    input    [4:0]    aermsinum;
    input    [4:0]    pexmsinum;
    input    [4:0]    hpgctrler;
    input    [12:0]    cfglink2csrpld;
    input    [7:0]    cfgprmbuspld;
    output    [0:0]    csebisshadow;
    output    [31:0]    csebwrdata;
    output    [3:0]    csebwrdataparity;
    output    [3:0]    csebbe;
    output    [32:0]    csebaddr;
    output    [4:0]    csebaddrparity;
    output    [0:0]    csebwren;
    output    [0:0]    csebrden;
    output    [0:0]    csebwrrespreq;
    input    [31:0]    csebrddata;
    input    [3:0]    csebrddataparity;
    input    [0:0]    csebwaitrequest;
    input    [0:0]    csebwrrespvalid;
    input    [4:0]    csebwrresponse;
    input    [4:0]    csebrdresponse;
    output    [0:0]    dlup;
    output    [255:0]    testouthip;
    output    [63:0]    testout1hip;
    output    [0:0]    ev1us;
    output    [0:0]    ev128ns;
    output    [0:0]    wakeoen;
    output    [0:0]    serrout;
    output    [4:0]    ltssmstate;
    output    [3:0]    laneact;
    output    [1:0]    currentspeed;
    input    [0:0]    slotclkcfg;
    input    [1:0]    mode;
    input    [31:0]    testinhip;
    input    [31:0]    testin1hip;
    input    [0:0]    cplpending;
    input    [6:0]    cplerr;
    input    [1:0]    appinterr;
    input    [0:0]    egressblkerr;
    input    [0:0]    pmexitd0ack;
    output    [0:0]    pmexitd0req;
    output    [17:0]    currentcoeff0;
    output    [17:0]    currentcoeff1;
    output    [17:0]    currentcoeff2;
    output    [17:0]    currentcoeff3;
    output    [17:0]    currentcoeff4;
    output    [17:0]    currentcoeff5;
    output    [17:0]    currentcoeff6;
    output    [17:0]    currentcoeff7;
    output    [2:0]    currentrxpreset0;
    output    [2:0]    currentrxpreset1;
    output    [2:0]    currentrxpreset2;
    output    [2:0]    currentrxpreset3;
    output    [2:0]    currentrxpreset4;
    output    [2:0]    currentrxpreset5;
    output    [2:0]    currentrxpreset6;
    output    [2:0]    currentrxpreset7;
    output    [1:0]    rate0;
    output    [1:0]    rate1;
    output    [1:0]    rate2;
    output    [1:0]    rate3;
    output    [1:0]    rate4;
    output    [1:0]    rate5;
    output    [1:0]    rate6;
    output    [1:0]    rate7;
    output    [0:0]    ratetiedtognd;
    output    [1:0]    ratectrl;
    output    [2:0]    eidleinfersel0;
    output    [2:0]    eidleinfersel1;
    output    [2:0]    eidleinfersel2;
    output    [2:0]    eidleinfersel3;
    output    [2:0]    eidleinfersel4;
    output    [2:0]    eidleinfersel5;
    output    [2:0]    eidleinfersel6;
    output    [2:0]    eidleinfersel7;
    output    [31:0]    txdata0;
    output    [3:0]    txdatak0;
    output    [0:0]    txdetectrx0;
    output    [0:0]    txelecidle0;
    output    [0:0]    txcompl0;
    output    [0:0]    rxpolarity0;
    output    [1:0]    powerdown0;
    output    [0:0]    txdataskip0;
    output    [0:0]    txblkst0;
    output    [1:0]    txsynchd0;
    output    [0:0]    txdeemph0;
    output    [2:0]    txmargin0;
    input    [31:0]    rxdata0;
    input    [3:0]    rxdatak0;
    input    [0:0]    rxvalid0;
    input    [0:0]    phystatus0;
    input    [0:0]    rxelecidle0;
    input    [2:0]    rxstatus0;
    input    [0:0]    rxdataskip0;
    input    [0:0]    rxblkst0;
    input    [1:0]    rxsynchd0;
    input    [0:0]    rxfreqlocked0;
    output    [31:0]    txdata1;
    output    [3:0]    txdatak1;
    output    [0:0]    txdetectrx1;
    output    [0:0]    txelecidle1;
    output    [0:0]    txcompl1;
    output    [0:0]    rxpolarity1;
    output    [1:0]    powerdown1;
    output    [0:0]    txdataskip1;
    output    [0:0]    txblkst1;
    output    [1:0]    txsynchd1;
    output    [0:0]    txdeemph1;
    output    [2:0]    txmargin1;
    input    [31:0]    rxdata1;
    input    [3:0]    rxdatak1;
    input    [0:0]    rxvalid1;
    input    [0:0]    phystatus1;
    input    [0:0]    rxelecidle1;
    input    [2:0]    rxstatus1;
    input    [0:0]    rxdataskip1;
    input    [0:0]    rxblkst1;
    input    [1:0]    rxsynchd1;
    input    [0:0]    rxfreqlocked1;
    output    [31:0]    txdata2;
    output    [3:0]    txdatak2;
    output    [0:0]    txdetectrx2;
    output    [0:0]    txelecidle2;
    output    [0:0]    txcompl2;
    output    [0:0]    rxpolarity2;
    output    [1:0]    powerdown2;
    output    [0:0]    txdataskip2;
    output    [0:0]    txblkst2;
    output    [1:0]    txsynchd2;
    output    [0:0]    txdeemph2;
    output    [2:0]    txmargin2;
    input    [31:0]    rxdata2;
    input    [3:0]    rxdatak2;
    input    [0:0]    rxvalid2;
    input    [0:0]    phystatus2;
    input    [0:0]    rxelecidle2;
    input    [2:0]    rxstatus2;
    input    [0:0]    rxdataskip2;
    input    [0:0]    rxblkst2;
    input    [1:0]    rxsynchd2;
    input    [0:0]    rxfreqlocked2;
    output    [31:0]    txdata3;
    output    [3:0]    txdatak3;
    output    [0:0]    txdetectrx3;
    output    [0:0]    txelecidle3;
    output    [0:0]    txcompl3;
    output    [0:0]    rxpolarity3;
    output    [1:0]    powerdown3;
    output    [0:0]    txdataskip3;
    output    [0:0]    txblkst3;
    output    [1:0]    txsynchd3;
    output    [0:0]    txdeemph3;
    output    [2:0]    txmargin3;
    input    [31:0]    rxdata3;
    input    [3:0]    rxdatak3;
    input    [0:0]    rxvalid3;
    input    [0:0]    phystatus3;
    input    [0:0]    rxelecidle3;
    input    [2:0]    rxstatus3;
    input    [0:0]    rxdataskip3;
    input    [0:0]    rxblkst3;
    input    [1:0]    rxsynchd3;
    input    [0:0]    rxfreqlocked3;
    output    [31:0]    txdata4;
    output    [3:0]    txdatak4;
    output    [0:0]    txdetectrx4;
    output    [0:0]    txelecidle4;
    output    [0:0]    txcompl4;
    output    [0:0]    rxpolarity4;
    output    [1:0]    powerdown4;
    output    [0:0]    txdataskip4;
    output    [0:0]    txblkst4;
    output    [1:0]    txsynchd4;
    output    [0:0]    txdeemph4;
    output    [2:0]    txmargin4;
    input    [31:0]    rxdata4;
    input    [3:0]    rxdatak4;
    input    [0:0]    rxvalid4;
    input    [0:0]    phystatus4;
    input    [0:0]    rxelecidle4;
    input    [2:0]    rxstatus4;
    input    [0:0]    rxdataskip4;
    input    [0:0]    rxblkst4;
    input    [1:0]    rxsynchd4;
    input    [0:0]    rxfreqlocked4;
    output    [31:0]    txdata5;
    output    [3:0]    txdatak5;
    output    [0:0]    txdetectrx5;
    output    [0:0]    txelecidle5;
    output    [0:0]    txcompl5;
    output    [0:0]    rxpolarity5;
    output    [1:0]    powerdown5;
    output    [0:0]    txdataskip5;
    output    [0:0]    txblkst5;
    output    [1:0]    txsynchd5;
    output    [0:0]    txdeemph5;
    output    [2:0]    txmargin5;
    input    [31:0]    rxdata5;
    input    [3:0]    rxdatak5;
    input    [0:0]    rxvalid5;
    input    [0:0]    phystatus5;
    input    [0:0]    rxelecidle5;
    input    [2:0]    rxstatus5;
    input    [0:0]    rxdataskip5;
    input    [0:0]    rxblkst5;
    input    [1:0]    rxsynchd5;
    input    [0:0]    rxfreqlocked5;
    output    [31:0]    txdata6;
    output    [3:0]    txdatak6;
    output    [0:0]    txdetectrx6;
    output    [0:0]    txelecidle6;
    output    [0:0]    txcompl6;
    output    [0:0]    rxpolarity6;
    output    [1:0]    powerdown6;
    output    [0:0]    txdataskip6;
    output    [0:0]    txblkst6;
    output    [1:0]    txsynchd6;
    output    [0:0]    txdeemph6;
    output    [2:0]    txmargin6;
    input    [31:0]    rxdata6;
    input    [3:0]    rxdatak6;
    input    [0:0]    rxvalid6;
    input    [0:0]    phystatus6;
    input    [0:0]    rxelecidle6;
    input    [2:0]    rxstatus6;
    input    [0:0]    rxdataskip6;
    input    [0:0]    rxblkst6;
    input    [1:0]    rxsynchd6;
    input    [0:0]    rxfreqlocked6;
    output    [31:0]    txdata7;
    output    [3:0]    txdatak7;
    output    [0:0]    txdetectrx7;
    output    [0:0]    txelecidle7;
    output    [0:0]    txcompl7;
    output    [0:0]    rxpolarity7;
    output    [1:0]    powerdown7;
    output    [0:0]    txdataskip7;
    output    [0:0]    txblkst7;
    output    [1:0]    txsynchd7;
    output    [0:0]    txdeemph7;
    output    [2:0]    txmargin7;
    input    [31:0]    rxdata7;
    input    [3:0]    rxdatak7;
    input    [0:0]    rxvalid7;
    input    [0:0]    phystatus7;
    input    [0:0]    rxelecidle7;
    input    [2:0]    rxstatus7;
    input    [0:0]    rxdataskip7;
    input    [0:0]    rxblkst7;
    input    [1:0]    rxsynchd7;
    input    [0:0]    rxfreqlocked7;
    input    [43:0]    dbgpipex1rx;
    input    [0:0]    memredsclk;
    input    [0:0]    memredenscan;
    input    [0:0]    memredscen;
    input    [0:0]    memredscin;
    input    [0:0]    memredscsel;
    input    [0:0]    memredscrst;
    output    [0:0]    memredscout;
    input    [0:0]    memregscanen;
    input    [0:0]    memregscanin;
    input    [0:0]    memhiptestenable;
    output    [0:0]    memregscanout;
    input    [0:0]    bisttesten;
    input    [0:0]    bistenrpl;
    input    [0:0]    bistscanin;
    input    [0:0]    bistscanen;
    input    [0:0]    bistenrcv;
    output    [0:0]    bistscanoutrpl;
    output    [0:0]    bistdonearpl;
    output    [0:0]    bistdonebrpl;
    output    [0:0]    bistpassrpl;
    output    [0:0]    derrrpl;
    output    [0:0]    derrcorextrpl;
    output    [0:0]    bistscanoutrcv;
    output    [0:0]    bistdonearcv;
    output    [0:0]    bistdonebrcv;
    output    [0:0]    bistpassrcv;
    output    [0:0]    derrcorextrcv;
    output    [0:0]    bistscanoutrcv1;
    output    [0:0]    bistdonearcv1;
    output    [0:0]    bistdonebrcv1;
    output    [0:0]    bistpassrcv1;
    output    [0:0]    derrcorextrcv1;
    input    [0:0]    scanmoden;
    input    [0:0]    scanshiftn;
    input    [0:0]    nfrzdrv;
    input    [0:0]    frzreg;
    input    [0:0]    frzlogic;
    input    [7:0]    idrpl;
    input    [7:0]    idrcv;
    input    [0:0]    plniotri;
    input    [0:0]    entest;
    input    [0:0]    npor;
    input    [0:0]    usermode;
    output    [0:0]    cvpclk;
    output    [31:0]    cvpdata;
    output    [0:0]    cvpstartxfer;
    output    [0:0]    cvpconfig;
    output    [0:0]    cvpfullconfig;
    input    [0:0]    cvpconfigready;
    input    [0:0]    cvpen;
    input    [0:0]    cvpconfigerror;
    input    [0:0]    cvpconfigdone;
    input    [0:0]    pinperstn;
    input    [0:0]    pldperstn;
    input    [0:0]    iocsrrdydly;
    input    [0:0]    softaltpe3rstn;
    input    [0:0]    softaltpe3srstn;
    input    [0:0]    softaltpe3crstn;
    input    [0:0]    pldclrpmapcshipn;
    input    [0:0]    pldclrpcshipn;
    input    [0:0]    pldclrhipn;
    output    [100:0]    s0ch0emsiptieoff;
    output    [100:0]    s0ch1emsiptieoff;
    output    [100:0]    s0ch2emsiptieoff;
    output    [100:0]    s1ch0emsiptieoff;
    output    [188:0]    s1ch1emsiptieoff;
    output    [100:0]    s1ch2emsiptieoff;
    output    [100:0]    s2ch0emsiptieoff;
    output    [100:0]    s2ch1emsiptieoff;
    output    [100:0]    s2ch2emsiptieoff;
    output    [188:0]    s3ch0emsiptieoff;
    output    [188:0]    s3ch1emsiptieoff;
    output    [188:0]    s3ch2emsiptieoff;
    output    [299:0]    emsiptieofftop;
    output    [299:0]    emsiptieoffbot;



    // Reset Control Interface Ch0
    output [0:0] txpcsrstn0;
    output [0:0] rxpcsrstn0;
    output [0:0] g3txpcsrstn0;
    output [0:0] g3rxpcsrstn0;
    output [0:0] txpmasyncp0;
    output [0:0] rxpmarstb0;
    output [0:0] txlcpllrstb0;
    output [0:0] offcalen0;
    input  [0:0] frefclk0;
    input  [0:0] offcaldone0;
    input  [0:0] txlcplllock0;
    input  [0:0] rxfreqtxcmuplllock0;
    input  [0:0] rxpllphaselock0;
    input  [0:0] masktxplllock0;

    // Reset Control Interface Ch1
    output [0:0] txpcsrstn1;
    output [0:0] rxpcsrstn1;
    output [0:0] g3txpcsrstn1;
    output [0:0] g3rxpcsrstn1;
    output [0:0] txpmasyncp1;
    output [0:0] rxpmarstb1;
    output [0:0] txlcpllrstb1;
    output [0:0] offcalen1;
    input  [0:0] frefclk1;
    input  [0:0] offcaldone1;
    input  [0:0] txlcplllock1;
    input  [0:0] rxfreqtxcmuplllock1;
    input  [0:0] rxpllphaselock1;
    input  [0:0] masktxplllock1;

    // Reset Control Interface Ch2
    output [0:0] txpcsrstn2;
    output [0:0] rxpcsrstn2;
    output [0:0] g3txpcsrstn2;
    output [0:0] g3rxpcsrstn2;
    output [0:0] txpmasyncp2;
    output [0:0] rxpmarstb2;
    output [0:0] txlcpllrstb2;
    output [0:0] offcalen2;
    input  [0:0] frefclk2;
    input  [0:0] offcaldone2;
    input  [0:0] txlcplllock2;
    input  [0:0] rxfreqtxcmuplllock2;
    input  [0:0] rxpllphaselock2;
    input  [0:0] masktxplllock2;

    // Reset Control Interface Ch3
    output [0:0] txpcsrstn3;
    output [0:0] rxpcsrstn3;
    output [0:0] g3txpcsrstn3;
    output [0:0] g3rxpcsrstn3;
    output [0:0] txpmasyncp3;
    output [0:0] rxpmarstb3;
    output [0:0] txlcpllrstb3;
    output [0:0] offcalen3;
    input  [0:0] frefclk3;
    input  [0:0] offcaldone3;
    input  [0:0] txlcplllock3;
    input  [0:0] rxfreqtxcmuplllock3;
    input  [0:0] rxpllphaselock3;
    input  [0:0] masktxplllock3;

    // Reset Control Interface Ch4
    output [0:0] txpcsrstn4;
    output [0:0] rxpcsrstn4;
    output [0:0] g3txpcsrstn4;
    output [0:0] g3rxpcsrstn4;
    output [0:0] txpmasyncp4;
    output [0:0] rxpmarstb4;
    output [0:0] txlcpllrstb4;
    output [0:0] offcalen4;
    input  [0:0] frefclk4;
    input  [0:0] offcaldone4;
    input  [0:0] txlcplllock4;
    input  [0:0] rxfreqtxcmuplllock4;
    input  [0:0] rxpllphaselock4;
    input  [0:0] masktxplllock4;

    // Reset Control Interface Ch5
    output [0:0] txpcsrstn5;
    output [0:0] rxpcsrstn5;
    output [0:0] g3txpcsrstn5;
    output [0:0] g3rxpcsrstn5;
    output [0:0] txpmasyncp5;
    output [0:0] rxpmarstb5;
    output [0:0] txlcpllrstb5;
    output [0:0] offcalen5;
    input  [0:0] frefclk5;
    input  [0:0] offcaldone5;
    input  [0:0] txlcplllock5;
    input  [0:0] rxfreqtxcmuplllock5;
    input  [0:0] rxpllphaselock5;
    input  [0:0] masktxplllock5;

    // Reset Control Interface Ch6
    output [0:0] txpcsrstn6;
    output [0:0] rxpcsrstn6;
    output [0:0] g3txpcsrstn6;
    output [0:0] g3rxpcsrstn6;
    output [0:0] txpmasyncp6;
    output [0:0] rxpmarstb6;
    output [0:0] txlcpllrstb6;
    output [0:0] offcalen6;
    input  [0:0] frefclk6;
    input  [0:0] offcaldone6;
    input  [0:0] txlcplllock6;
    input  [0:0] rxfreqtxcmuplllock6;
    input  [0:0] rxpllphaselock6;
    input  [0:0] masktxplllock6;

    // Reset Control Interface Ch7
    output [0:0] txpcsrstn7;
    output [0:0] rxpcsrstn7;
    output [0:0] g3txpcsrstn7;
    output [0:0] g3rxpcsrstn7;
    output [0:0] txpmasyncp7;
    output [0:0] rxpmarstb7;
    output [0:0] txlcpllrstb7;
    output [0:0] offcalen7;
    input  [0:0] frefclk7;
    input  [0:0] offcaldone7;
    input  [0:0] txlcplllock7;
    input  [0:0] rxfreqtxcmuplllock7;
    input  [0:0] rxpllphaselock7;
    input  [0:0] masktxplllock7;

    // Reset Control Interface Ch8
    output [0:0] txpcsrstn8;
    output [0:0] rxpcsrstn8;
    output [0:0] g3txpcsrstn8;
    output [0:0] g3rxpcsrstn8;
    output [0:0] txpmasyncp8;
    output [0:0] rxpmarstb8;
    output [0:0] txlcpllrstb8;
    output [0:0] offcalen8;
    input  [0:0] frefclk8;
    input  [0:0] offcaldone8;
    input  [0:0] txlcplllock8;
    input  [0:0] rxfreqtxcmuplllock8;
    input  [0:0] rxpllphaselock8;
    input  [0:0] masktxplllock8;

    // Reset Control Interface Ch9
    output [0:0] txpcsrstn9;
    output [0:0] rxpcsrstn9;
    output [0:0] g3txpcsrstn9;
    output [0:0] g3rxpcsrstn9;
    output [0:0] txpmasyncp9;
    output [0:0] rxpmarstb9;
    output [0:0] txlcpllrstb9;
    output [0:0] offcalen9;
    input  [0:0] frefclk9;
    input  [0:0] offcaldone9;
    input  [0:0] txlcplllock9;
    input  [0:0] rxfreqtxcmuplllock9;
    input  [0:0] rxpllphaselock9;
    input  [0:0] masktxplllock9;

    // Reset Control Interface Ch10
    output [0:0] txpcsrstn10;
    output [0:0] rxpcsrstn10;
    output [0:0] g3txpcsrstn10;
    output [0:0] g3rxpcsrstn10;
    output [0:0] txpmasyncp10;
    output [0:0] rxpmarstb10;
    output [0:0] txlcpllrstb10;
    output [0:0] offcalen10;
    input  [0:0] frefclk10;
    input  [0:0] offcaldone10;
    input  [0:0] txlcplllock10;
    input  [0:0] rxfreqtxcmuplllock10;
    input  [0:0] rxpllphaselock10;
    input  [0:0] masktxplllock10;

    // Reset Control Interface Ch11
    output [0:0] txpcsrstn11;
    output [0:0] rxpcsrstn11;
    output [0:0] g3txpcsrstn11;
    output [0:0] g3rxpcsrstn11;
    output [0:0] txpmasyncp11;
    output [0:0] rxpmarstb11;
    output [0:0] txlcpllrstb11;
    output [0:0] offcalen11;
    input  [0:0] frefclk11;
    input  [0:0] offcaldone11;
    input  [0:0] txlcplllock11;
    input  [0:0] rxfreqtxcmuplllock11;
    input  [0:0] rxpllphaselock11;
    input  [0:0] masktxplllock11;




    input    [31:0]    reservedin;
    input    [0:0]    reservedclkin;
    output    [31:0]    reservedout;
    output    [0:0]    reservedclkout;

    stratixv_hssi_gen3_pcie_hip_encrypted inst (
        .dpriostatus(dpriostatus),
        .lmidout(lmidout),
        .lmiack(lmiack),
        .lmirden(lmirden),
        .lmiwren(lmiwren),
        .lmiaddr(lmiaddr),
        .lmidin(lmidin),
        .flrreset(flrreset),
        .flrsts(flrsts),
        .resetstatus(resetstatus),
        .l2exit(l2exit),
        .hotrstexit(hotrstexit),
        .dlupexit(dlupexit),
        .coreclkout(coreclkout),
        .pldclk(pldclk),
        .pldsrst(pldsrst),
        .pldrst(pldrst),
        .pclkch0(pclkch0),
        .pclkch1(pclkch1),
        .pclkcentral(pclkcentral),
        .pllfixedclkch0(pllfixedclkch0),
        .pllfixedclkch1(pllfixedclkch1),
        .pllfixedclkcentral(pllfixedclkcentral),
        .phyrst(phyrst),
        .physrst(physrst),
        .coreclkin(coreclkin),
        .corerst(corerst),
        .corepor(corepor),
        .corecrst(corecrst),
        .coresrst(coresrst),
        .swdnout(swdnout),
        .swupout(swupout),
        .swdnin(swdnin),
        .swupin(swupin),
        .swctmod(swctmod),
        .rxstdata(rxstdata),
        .rxstparity(rxstparity),
        .rxstbe(rxstbe),
        .rxsterr(rxsterr),
        .rxstsop(rxstsop),
        .rxsteop(rxsteop),
        .rxstempty(rxstempty),
        .rxstvalid(rxstvalid),
        .rxstbardec1(rxstbardec1),
        .rxstbardec2(rxstbardec2),
        .rxstmask(rxstmask),
        .rxstready(rxstready),
        .txstready(txstready),
        .txcredfchipcons(txcredfchipcons),
        .txcredfcinfinite(txcredfcinfinite),
        .txcredhdrfcp(txcredhdrfcp),
        .txcreddatafcp(txcreddatafcp),
        .txcredhdrfcnp(txcredhdrfcnp),
        .txcreddatafcnp(txcreddatafcnp),
        .txcredhdrfccp(txcredhdrfccp),
        .txcreddatafccp(txcreddatafccp),
        .txstdata(txstdata),
        .txstparity(txstparity),
        .txsterr(txsterr),
        .txstsop(txstsop),
        .txsteop(txsteop),
        .txstempty(txstempty),
        .txstvalid(txstvalid),
        .r2cuncecc(r2cuncecc),
        .rxcorrecc(rxcorrecc),
        .retryuncecc(retryuncecc),
        .retrycorrecc(retrycorrecc),
        .rxparerr(rxparerr),
        .txparerr(txparerr),
        .r2cparerr(r2cparerr),
        .pmetosr(pmetosr),
        .pmetocr(pmetocr),
        .pmevent(pmevent),
        .pmdata(pmdata),
        .pmauxpwr(pmauxpwr),
        .tlcfgsts(tlcfgsts),
        .tlcfgctl(tlcfgctl),
        .tlcfgadd(tlcfgadd),
        .appintaack(appintaack),
        .appintasts(appintasts),
        .intstatus(intstatus),
        .appmsiack(appmsiack),
        .appmsireq(appmsireq),
        .appmsitc(appmsitc),
        .appmsinum(appmsinum),
        .aermsinum(aermsinum),
        .pexmsinum(pexmsinum),
        .hpgctrler(hpgctrler),
        .cfglink2csrpld(cfglink2csrpld),
        .cfgprmbuspld(cfgprmbuspld),
        .csebisshadow(csebisshadow),
        .csebwrdata(csebwrdata),
        .csebwrdataparity(csebwrdataparity),
        .csebbe(csebbe),
        .csebaddr(csebaddr),
        .csebaddrparity(csebaddrparity),
        .csebwren(csebwren),
        .csebrden(csebrden),
        .csebwrrespreq(csebwrrespreq),
        .csebrddata(csebrddata),
        .csebrddataparity(csebrddataparity),
        .csebwaitrequest(csebwaitrequest),
        .csebwrrespvalid(csebwrrespvalid),
        .csebwrresponse(csebwrresponse),
        .csebrdresponse(csebrdresponse),
        .dlup(dlup),
        .testouthip(testouthip),
        .testout1hip(testout1hip),
        .ev1us(ev1us),
        .ev128ns(ev128ns),
        .wakeoen(wakeoen),
        .serrout(serrout),
        .ltssmstate(ltssmstate),
        .laneact(laneact),
        .currentspeed(currentspeed),
        .slotclkcfg(slotclkcfg),
        .mode(mode),
        .testinhip(testinhip),
        .testin1hip(testin1hip),
        .cplpending(cplpending),
        .cplerr(cplerr),
        .appinterr(appinterr),
        .egressblkerr(egressblkerr),
        .pmexitd0ack(pmexitd0ack),
        .pmexitd0req(pmexitd0req),
        .currentcoeff0(currentcoeff0),
        .currentcoeff1(currentcoeff1),
        .currentcoeff2(currentcoeff2),
        .currentcoeff3(currentcoeff3),
        .currentcoeff4(currentcoeff4),
        .currentcoeff5(currentcoeff5),
        .currentcoeff6(currentcoeff6),
        .currentcoeff7(currentcoeff7),
        .currentrxpreset0(currentrxpreset0),
        .currentrxpreset1(currentrxpreset1),
        .currentrxpreset2(currentrxpreset2),
        .currentrxpreset3(currentrxpreset3),
        .currentrxpreset4(currentrxpreset4),
        .currentrxpreset5(currentrxpreset5),
        .currentrxpreset6(currentrxpreset6),
        .currentrxpreset7(currentrxpreset7),
        .rate0(rate0),
        .rate1(rate1),
        .rate2(rate2),
        .rate3(rate3),
        .rate4(rate4),
        .rate5(rate5),
        .rate6(rate6),
        .rate7(rate7),
        .ratectrl(ratectrl),
        .eidleinfersel0(eidleinfersel0),
        .eidleinfersel1(eidleinfersel1),
        .eidleinfersel2(eidleinfersel2),
        .eidleinfersel3(eidleinfersel3),
        .eidleinfersel4(eidleinfersel4),
        .eidleinfersel5(eidleinfersel5),
        .eidleinfersel6(eidleinfersel6),
        .eidleinfersel7(eidleinfersel7),
        .txdata0(txdata0),
        .txdatak0(txdatak0),
        .txdetectrx0(txdetectrx0),
        .txelecidle0(txelecidle0),
        .txcompl0(txcompl0),
        .rxpolarity0(rxpolarity0),
        .powerdown0(powerdown0),
        .txdataskip0(txdataskip0),
        .txblkst0(txblkst0),
        .txsynchd0(txsynchd0),
        .txdeemph0(txdeemph0),
        .txmargin0(txmargin0),
        .rxdata0(rxdata0),
        .rxdatak0(rxdatak0),
        .rxvalid0(rxvalid0),
        .phystatus0(phystatus0),
        .rxelecidle0(rxelecidle0),
        .rxstatus0(rxstatus0),
        .rxdataskip0(rxdataskip0),
        .rxblkst0(rxblkst0),
        .rxsynchd0(rxsynchd0),
        .rxfreqlocked0(rxfreqlocked0),
        .txdata1(txdata1),
        .txdatak1(txdatak1),
        .txdetectrx1(txdetectrx1),
        .txelecidle1(txelecidle1),
        .txcompl1(txcompl1),
        .rxpolarity1(rxpolarity1),
        .powerdown1(powerdown1),
        .txdataskip1(txdataskip1),
        .txblkst1(txblkst1),
        .txsynchd1(txsynchd1),
        .txdeemph1(txdeemph1),
        .txmargin1(txmargin1),
        .rxdata1(rxdata1),
        .rxdatak1(rxdatak1),
        .rxvalid1(rxvalid1),
        .phystatus1(phystatus1),
        .rxelecidle1(rxelecidle1),
        .rxstatus1(rxstatus1),
        .rxdataskip1(rxdataskip1),
        .rxblkst1(rxblkst1),
        .rxsynchd1(rxsynchd1),
        .rxfreqlocked1(rxfreqlocked1),
        .txdata2(txdata2),
        .txdatak2(txdatak2),
        .txdetectrx2(txdetectrx2),
        .txelecidle2(txelecidle2),
        .txcompl2(txcompl2),
        .rxpolarity2(rxpolarity2),
        .powerdown2(powerdown2),
        .txdataskip2(txdataskip2),
        .txblkst2(txblkst2),
        .txsynchd2(txsynchd2),
        .txdeemph2(txdeemph2),
        .txmargin2(txmargin2),
        .rxdata2(rxdata2),
        .rxdatak2(rxdatak2),
        .rxvalid2(rxvalid2),
        .phystatus2(phystatus2),
        .rxelecidle2(rxelecidle2),
        .rxstatus2(rxstatus2),
        .rxdataskip2(rxdataskip2),
        .rxblkst2(rxblkst2),
        .rxsynchd2(rxsynchd2),
        .rxfreqlocked2(rxfreqlocked2),
        .txdata3(txdata3),
        .txdatak3(txdatak3),
        .txdetectrx3(txdetectrx3),
        .txelecidle3(txelecidle3),
        .txcompl3(txcompl3),
        .rxpolarity3(rxpolarity3),
        .powerdown3(powerdown3),
        .txdataskip3(txdataskip3),
        .txblkst3(txblkst3),
        .txsynchd3(txsynchd3),
        .txdeemph3(txdeemph3),
        .txmargin3(txmargin3),
        .rxdata3(rxdata3),
        .rxdatak3(rxdatak3),
        .rxvalid3(rxvalid3),
        .phystatus3(phystatus3),
        .rxelecidle3(rxelecidle3),
        .rxstatus3(rxstatus3),
        .rxdataskip3(rxdataskip3),
        .rxblkst3(rxblkst3),
        .rxsynchd3(rxsynchd3),
        .rxfreqlocked3(rxfreqlocked3),
        .txdata4(txdata4),
        .txdatak4(txdatak4),
        .txdetectrx4(txdetectrx4),
        .txelecidle4(txelecidle4),
        .txcompl4(txcompl4),
        .rxpolarity4(rxpolarity4),
        .powerdown4(powerdown4),
        .txdataskip4(txdataskip4),
        .txblkst4(txblkst4),
        .txsynchd4(txsynchd4),
        .txdeemph4(txdeemph4),
        .txmargin4(txmargin4),
        .rxdata4(rxdata4),
        .rxdatak4(rxdatak4),
        .rxvalid4(rxvalid4),
        .phystatus4(phystatus4),
        .rxelecidle4(rxelecidle4),
        .rxstatus4(rxstatus4),
        .rxdataskip4(rxdataskip4),
        .rxblkst4(rxblkst4),
        .rxsynchd4(rxsynchd4),
        .rxfreqlocked4(rxfreqlocked4),
        .txdata5(txdata5),
        .txdatak5(txdatak5),
        .txdetectrx5(txdetectrx5),
        .txelecidle5(txelecidle5),
        .txcompl5(txcompl5),
        .rxpolarity5(rxpolarity5),
        .powerdown5(powerdown5),
        .txdataskip5(txdataskip5),
        .txblkst5(txblkst5),
        .txsynchd5(txsynchd5),
        .txdeemph5(txdeemph5),
        .txmargin5(txmargin5),
        .rxdata5(rxdata5),
        .rxdatak5(rxdatak5),
        .rxvalid5(rxvalid5),
        .phystatus5(phystatus5),
        .rxelecidle5(rxelecidle5),
        .rxstatus5(rxstatus5),
        .rxdataskip5(rxdataskip5),
        .rxblkst5(rxblkst5),
        .rxsynchd5(rxsynchd5),
        .rxfreqlocked5(rxfreqlocked5),
        .txdata6(txdata6),
        .txdatak6(txdatak6),
        .txdetectrx6(txdetectrx6),
        .txelecidle6(txelecidle6),
        .txcompl6(txcompl6),
        .rxpolarity6(rxpolarity6),
        .powerdown6(powerdown6),
        .txdataskip6(txdataskip6),
        .txblkst6(txblkst6),
        .txsynchd6(txsynchd6),
        .txdeemph6(txdeemph6),
        .txmargin6(txmargin6),
        .rxdata6(rxdata6),
        .rxdatak6(rxdatak6),
        .rxvalid6(rxvalid6),
        .phystatus6(phystatus6),
        .rxelecidle6(rxelecidle6),
        .rxstatus6(rxstatus6),
        .rxdataskip6(rxdataskip6),
        .rxblkst6(rxblkst6),
        .rxsynchd6(rxsynchd6),
        .rxfreqlocked6(rxfreqlocked6),
        .txdata7(txdata7),
        .txdatak7(txdatak7),
        .txdetectrx7(txdetectrx7),
        .txelecidle7(txelecidle7),
        .txcompl7(txcompl7),
        .rxpolarity7(rxpolarity7),
        .powerdown7(powerdown7),
        .txdataskip7(txdataskip7),
        .txblkst7(txblkst7),
        .txsynchd7(txsynchd7),
        .txdeemph7(txdeemph7),
        .txmargin7(txmargin7),
        .rxdata7(rxdata7),
        .rxdatak7(rxdatak7),
        .rxvalid7(rxvalid7),
        .phystatus7(phystatus7),
        .rxelecidle7(rxelecidle7),
        .rxstatus7(rxstatus7),
        .rxdataskip7(rxdataskip7),
        .rxblkst7(rxblkst7),
        .rxsynchd7(rxsynchd7),
        .rxfreqlocked7(rxfreqlocked7),
        .dbgpipex1rx(dbgpipex1rx),
        .memredsclk(memredsclk),
        .memredenscan(memredenscan),
        .memredscen(memredscen),
        .memredscin(memredscin),
        .memredscsel(memredscsel),
        .memredscrst(memredscrst),
        .memredscout(memredscout),
        .memregscanen(memregscanen),
        .memregscanin(memregscanin),
        .memhiptestenable(memhiptestenable),
        .memregscanout(memregscanout),
        .bisttesten(bisttesten),
        .bistenrpl(bistenrpl),
        .bistscanin(bistscanin),
        .bistscanen(bistscanen),
        .bistenrcv(bistenrcv),
        .bistscanoutrpl(bistscanoutrpl),
        .bistdonearpl(bistdonearpl),
        .bistdonebrpl(bistdonebrpl),
        .bistpassrpl(bistpassrpl),
        .derrrpl(derrrpl),
        .derrcorextrpl(derrcorextrpl),
        .bistscanoutrcv(bistscanoutrcv),
        .bistdonearcv(bistdonearcv),
        .bistdonebrcv(bistdonebrcv),
        .bistpassrcv(bistpassrcv),
        .derrcorextrcv(derrcorextrcv),
        .bistscanoutrcv1(bistscanoutrcv1),
        .bistdonearcv1(bistdonearcv1),
        .bistdonebrcv1(bistdonebrcv1),
        .bistpassrcv1(bistpassrcv1),
        .derrcorextrcv1(derrcorextrcv1),
        .scanmoden(scanmoden),
        .scanshiftn(scanshiftn),
        .nfrzdrv(nfrzdrv),
        .frzreg(frzreg),
        .frzlogic(frzlogic),
        .idrpl(idrpl),
        .idrcv(idrcv),
        .plniotri(plniotri),
        .entest(entest),
        .npor(npor),
        .usermode(usermode),
        .cvpclk(cvpclk),
        .cvpdata(cvpdata),
        .cvpstartxfer(cvpstartxfer),
        .cvpconfig(cvpconfig),
        .cvpfullconfig(cvpfullconfig),
        .cvpconfigready(cvpconfigready),
        .cvpen(cvpen),
        .cvpconfigerror(cvpconfigerror),
        .cvpconfigdone(cvpconfigdone),
        .pinperstn(pinperstn),
        .pldperstn(pldperstn),
        .iocsrrdydly(iocsrrdydly),
        .softaltpe3rstn(softaltpe3rstn),
        .softaltpe3srstn(softaltpe3srstn),
        .softaltpe3crstn(softaltpe3crstn),
        .pldclrpmapcshipn(pldclrpmapcshipn),
        .pldclrpcshipn(pldclrpcshipn),
        .pldclrhipn(pldclrhipn),
        .s0ch0emsiptieoff(s0ch0emsiptieoff),
        .s0ch1emsiptieoff(s0ch1emsiptieoff),
        .s0ch2emsiptieoff(s0ch2emsiptieoff),
        .s1ch0emsiptieoff(s1ch0emsiptieoff),
        .s1ch1emsiptieoff(s1ch1emsiptieoff),
        .s1ch2emsiptieoff(s1ch2emsiptieoff),
        .s2ch0emsiptieoff(s2ch0emsiptieoff),
        .s2ch1emsiptieoff(s2ch1emsiptieoff),
        .s2ch2emsiptieoff(s2ch2emsiptieoff),
        .s3ch0emsiptieoff(s3ch0emsiptieoff),
        .s3ch1emsiptieoff(s3ch1emsiptieoff),
        .s3ch2emsiptieoff(s3ch2emsiptieoff),
        .emsiptieofftop(emsiptieofftop),
        .emsiptieoffbot(emsiptieoffbot),

        .txpcsrstn0           (txpcsrstn0           ),
        .rxpcsrstn0           (rxpcsrstn0           ),
        .g3txpcsrstn0         (g3txpcsrstn0         ),
        .g3rxpcsrstn0         (g3rxpcsrstn0         ),
        .txpmasyncp0          (txpmasyncp0          ),
        .rxpmarstb0           (rxpmarstb0           ),
        .txlcpllrstb0         (txlcpllrstb0         ),
        .offcalen0            (offcalen0            ),
        .frefclk0             (frefclk0             ),
        .offcaldone0          (offcaldone0          ),
        .txlcplllock0         (txlcplllock0         ),
        .rxfreqtxcmuplllock0  (rxfreqtxcmuplllock0  ),
        .rxpllphaselock0      (rxpllphaselock0      ),
        .masktxplllock0       (masktxplllock0       ),
        .txpcsrstn1           (txpcsrstn1           ),
        .rxpcsrstn1           (rxpcsrstn1           ),
        .g3txpcsrstn1         (g3txpcsrstn1         ),
        .g3rxpcsrstn1         (g3rxpcsrstn1         ),
        .txpmasyncp1          (txpmasyncp1          ),
        .rxpmarstb1           (rxpmarstb1           ),
        .txlcpllrstb1         (txlcpllrstb1         ),
        .offcalen1            (offcalen1            ),
        .frefclk1             (frefclk1             ),
        .offcaldone1          (offcaldone1          ),
        .txlcplllock1         (txlcplllock1         ),
        .rxfreqtxcmuplllock1  (rxfreqtxcmuplllock1  ),
        .rxpllphaselock1      (rxpllphaselock1      ),
        .masktxplllock1       (masktxplllock1       ),
        .txpcsrstn2           (txpcsrstn2           ),
        .rxpcsrstn2           (rxpcsrstn2           ),
        .g3txpcsrstn2         (g3txpcsrstn2         ),
        .g3rxpcsrstn2         (g3rxpcsrstn2         ),
        .txpmasyncp2          (txpmasyncp2          ),
        .rxpmarstb2           (rxpmarstb2           ),
        .txlcpllrstb2         (txlcpllrstb2         ),
        .offcalen2            (offcalen2            ),
        .frefclk2             (frefclk2             ),
        .offcaldone2          (offcaldone2          ),
        .txlcplllock2         (txlcplllock2         ),
        .rxfreqtxcmuplllock2  (rxfreqtxcmuplllock2  ),
        .rxpllphaselock2      (rxpllphaselock2      ),
        .masktxplllock2       (masktxplllock2       ),
        .txpcsrstn3           (txpcsrstn3           ),
        .rxpcsrstn3           (rxpcsrstn3           ),
        .g3txpcsrstn3         (g3txpcsrstn3         ),
        .g3rxpcsrstn3         (g3rxpcsrstn3         ),
        .txpmasyncp3          (txpmasyncp3          ),
        .rxpmarstb3           (rxpmarstb3           ),
        .txlcpllrstb3         (txlcpllrstb3         ),
        .offcalen3            (offcalen3            ),
        .frefclk3             (frefclk3             ),
        .offcaldone3          (offcaldone3          ),
        .txlcplllock3         (txlcplllock3         ),
        .rxfreqtxcmuplllock3  (rxfreqtxcmuplllock3  ),
        .rxpllphaselock3      (rxpllphaselock3      ),
        .masktxplllock3       (masktxplllock3       ),
        .txpcsrstn4           (txpcsrstn4           ),
        .rxpcsrstn4           (rxpcsrstn4           ),
        .g3txpcsrstn4         (g3txpcsrstn4         ),
        .g3rxpcsrstn4         (g3rxpcsrstn4         ),
        .txpmasyncp4          (txpmasyncp4          ),
        .rxpmarstb4           (rxpmarstb4           ),
        .txlcpllrstb4         (txlcpllrstb4         ),
        .offcalen4            (offcalen4            ),
        .frefclk4             (frefclk4             ),
        .offcaldone4          (offcaldone4          ),
        .txlcplllock4         (txlcplllock4         ),
        .rxfreqtxcmuplllock4  (rxfreqtxcmuplllock4  ),
        .rxpllphaselock4      (rxpllphaselock4      ),
        .masktxplllock4       (masktxplllock4       ),
        .txpcsrstn5           (txpcsrstn5           ),
        .rxpcsrstn5           (rxpcsrstn5           ),
        .g3txpcsrstn5         (g3txpcsrstn5         ),
        .g3rxpcsrstn5         (g3rxpcsrstn5         ),
        .txpmasyncp5          (txpmasyncp5          ),
        .rxpmarstb5           (rxpmarstb5           ),
        .txlcpllrstb5         (txlcpllrstb5         ),
        .offcalen5            (offcalen5            ),
        .frefclk5             (frefclk5             ),
        .offcaldone5          (offcaldone5          ),
        .txlcplllock5         (txlcplllock5         ),
        .rxfreqtxcmuplllock5  (rxfreqtxcmuplllock5  ),
        .rxpllphaselock5      (rxpllphaselock5      ),
        .masktxplllock5       (masktxplllock5       ),
        .txpcsrstn6           (txpcsrstn6           ),
        .rxpcsrstn6           (rxpcsrstn6           ),
        .g3txpcsrstn6         (g3txpcsrstn6         ),
        .g3rxpcsrstn6         (g3rxpcsrstn6         ),
        .txpmasyncp6          (txpmasyncp6          ),
        .rxpmarstb6           (rxpmarstb6           ),
        .txlcpllrstb6         (txlcpllrstb6         ),
        .offcalen6            (offcalen6            ),
        .frefclk6             (frefclk6             ),
        .offcaldone6          (offcaldone6          ),
        .txlcplllock6         (txlcplllock6         ),
        .rxfreqtxcmuplllock6  (rxfreqtxcmuplllock6  ),
        .rxpllphaselock6      (rxpllphaselock6      ),
        .masktxplllock6       (masktxplllock6       ),
        .txpcsrstn7           (txpcsrstn7           ),
        .rxpcsrstn7           (rxpcsrstn7           ),
        .g3txpcsrstn7         (g3txpcsrstn7         ),
        .g3rxpcsrstn7         (g3rxpcsrstn7         ),
        .txpmasyncp7          (txpmasyncp7          ),
        .rxpmarstb7           (rxpmarstb7           ),
        .txlcpllrstb7         (txlcpllrstb7         ),
        .offcalen7            (offcalen7            ),
        .frefclk7             (frefclk7             ),
        .offcaldone7          (offcaldone7          ),
        .txlcplllock7         (txlcplllock7         ),
        .rxfreqtxcmuplllock7  (rxfreqtxcmuplllock7  ),
        .rxpllphaselock7      (rxpllphaselock7      ),
        .masktxplllock7       (masktxplllock7       ),
        .txpcsrstn8           (txpcsrstn8           ),
        .rxpcsrstn8           (rxpcsrstn8           ),
        .g3txpcsrstn8         (g3txpcsrstn8         ),
        .g3rxpcsrstn8         (g3rxpcsrstn8         ),
        .txpmasyncp8          (txpmasyncp8          ),
        .rxpmarstb8           (rxpmarstb8           ),
        .txlcpllrstb8         (txlcpllrstb8         ),
        .offcalen8            (offcalen8            ),
        .frefclk8             (frefclk8             ),
        .offcaldone8          (offcaldone8          ),
        .txlcplllock8         (txlcplllock8         ),
        .rxfreqtxcmuplllock8  (rxfreqtxcmuplllock8  ),
        .rxpllphaselock8      (rxpllphaselock8      ),
        .masktxplllock8       (masktxplllock8       ),
        .txpcsrstn9           (txpcsrstn9           ),
        .rxpcsrstn9           (rxpcsrstn9           ),
        .g3txpcsrstn9         (g3txpcsrstn9         ),
        .g3rxpcsrstn9         (g3rxpcsrstn9         ),
        .txpmasyncp9          (txpmasyncp9          ),
        .rxpmarstb9           (rxpmarstb9           ),
        .txlcpllrstb9         (txlcpllrstb9         ),
        .offcalen9            (offcalen9            ),
        .frefclk9             (frefclk9             ),
        .offcaldone9          (offcaldone9          ),
        .txlcplllock9         (txlcplllock9         ),
        .rxfreqtxcmuplllock9  (rxfreqtxcmuplllock9  ),
        .rxpllphaselock9      (rxpllphaselock9      ),
        .masktxplllock9       (masktxplllock9       ),
        .txpcsrstn10          (txpcsrstn10          ),
        .rxpcsrstn10          (rxpcsrstn10          ),
        .g3txpcsrstn10        (g3txpcsrstn10        ),
        .g3rxpcsrstn10        (g3rxpcsrstn10        ),
        .txpmasyncp10         (txpmasyncp10         ),
        .rxpmarstb10          (rxpmarstb10          ),
        .txlcpllrstb10        (txlcpllrstb10        ),
        .offcalen10           (offcalen10           ),
        .frefclk10            (frefclk10            ),
        .offcaldone10         (offcaldone10         ),
        .txlcplllock10        (txlcplllock10        ),
        .rxfreqtxcmuplllock10 (rxfreqtxcmuplllock10 ),
        .rxpllphaselock10     (rxpllphaselock10     ),
        .masktxplllock10      (masktxplllock10      ),
        .txpcsrstn11          (txpcsrstn11          ),
        .rxpcsrstn11          (rxpcsrstn11          ),
        .g3txpcsrstn11        (g3txpcsrstn11        ),
        .g3rxpcsrstn11        (g3rxpcsrstn11        ),
        .txpmasyncp11         (txpmasyncp11         ),
        .rxpmarstb11          (rxpmarstb11          ),
        .txlcpllrstb11        (txlcpllrstb11        ),
        .offcalen11           (offcalen11           ),
        .frefclk11            (frefclk11            ),
        .offcaldone11         (offcaldone11         ),
        .txlcplllock11        (txlcplllock11        ),
        .rxfreqtxcmuplllock11 (rxfreqtxcmuplllock11 ),
        .rxpllphaselock11     (rxpllphaselock11     ),
        .masktxplllock11      (masktxplllock11      ),

        .reservedin(reservedin),
        .reservedclkin(reservedclkin),
        .reservedout(reservedout),
        .reservedclkout(reservedclkout) );

    defparam inst.func_mode = func_mode;
    defparam inst.bonding_mode = bonding_mode;
    defparam inst.prot_mode = prot_mode;
    defparam inst.pcie_spec_1p0_compliance = pcie_spec_1p0_compliance;
    defparam inst.vc_enable = vc_enable;
    defparam inst.enable_slot_register = enable_slot_register;
    defparam inst.pcie_mode = pcie_mode;
    defparam inst.bypass_cdc = bypass_cdc;
    defparam inst.enable_rx_reordering = enable_rx_reordering;
    defparam inst.enable_rx_buffer_checking = enable_rx_buffer_checking;
    defparam inst.single_rx_detect_data = single_rx_detect_data;
    defparam inst.single_rx_detect = single_rx_detect;
    defparam inst.use_crc_forwarding = use_crc_forwarding;
    defparam inst.bypass_tl = bypass_tl;
    defparam inst.gen123_lane_rate_mode = gen123_lane_rate_mode;
    defparam inst.lane_mask = lane_mask;
    defparam inst.disable_link_x2_support = disable_link_x2_support;
    defparam inst.national_inst_thru_enhance = national_inst_thru_enhance;
    defparam inst.hip_hard_reset = hip_hard_reset;
    defparam inst.dis_paritychk = dis_paritychk;
    defparam inst.wrong_device_id = wrong_device_id;
    defparam inst.data_pack_rx = data_pack_rx;
    defparam inst.ast_width = ast_width;
    defparam inst.rx_sop_ctrl = rx_sop_ctrl;
    defparam inst.rx_ast_parity = rx_ast_parity;
    defparam inst.tx_ast_parity = tx_ast_parity;
    defparam inst.ltssm_1ms_timeout = ltssm_1ms_timeout;
    defparam inst.ltssm_freqlocked_check = ltssm_freqlocked_check;
    defparam inst.deskew_comma = deskew_comma;
    defparam inst.dl_tx_check_parity_edb = dl_tx_check_parity_edb;
    defparam inst.tl_tx_check_parity_msg = tl_tx_check_parity_msg;
    defparam inst.port_link_number_data = port_link_number_data;
    defparam inst.port_link_number = port_link_number;
    defparam inst.device_number_data = device_number_data;
    defparam inst.device_number = device_number;
    defparam inst.bypass_clk_switch = bypass_clk_switch;
    defparam inst.core_clk_out_sel = core_clk_out_sel;
    defparam inst.core_clk_divider = core_clk_divider;
    defparam inst.core_clk_source = core_clk_source;
    defparam inst.core_clk_sel = core_clk_sel;
    defparam inst.enable_ch0_pclk_out = enable_ch0_pclk_out;
    defparam inst.enable_ch01_pclk_out = enable_ch01_pclk_out;
    defparam inst.pipex1_debug_sel = pipex1_debug_sel;
    defparam inst.pclk_out_sel = pclk_out_sel;
    defparam inst.vendor_id_data = vendor_id_data;
    defparam inst.vendor_id = vendor_id;
    defparam inst.device_id_data = device_id_data;
    defparam inst.device_id = device_id;
    defparam inst.revision_id_data = revision_id_data;
    defparam inst.revision_id = revision_id;
    defparam inst.class_code_data = class_code_data;
    defparam inst.class_code = class_code;
    defparam inst.subsystem_vendor_id_data = subsystem_vendor_id_data;
    defparam inst.subsystem_vendor_id = subsystem_vendor_id;
    defparam inst.subsystem_device_id_data = subsystem_device_id_data;
    defparam inst.subsystem_device_id = subsystem_device_id;
    defparam inst.no_soft_reset = no_soft_reset;
    defparam inst.maximum_current_data = maximum_current_data;
    defparam inst.maximum_current = maximum_current;
    defparam inst.d1_support = d1_support;
    defparam inst.d2_support = d2_support;
    defparam inst.d0_pme = d0_pme;
    defparam inst.d1_pme = d1_pme;
    defparam inst.d2_pme = d2_pme;
    defparam inst.d3_hot_pme = d3_hot_pme;
    defparam inst.d3_cold_pme = d3_cold_pme;
    defparam inst.use_aer = use_aer;
    defparam inst.low_priority_vc = low_priority_vc;
    defparam inst.vc_arbitration = vc_arbitration;
    defparam inst.disable_snoop_packet = disable_snoop_packet;
    defparam inst.max_payload_size = max_payload_size;
    defparam inst.surprise_down_error_support = surprise_down_error_support;
    defparam inst.dll_active_report_support = dll_active_report_support;
    defparam inst.extend_tag_field = extend_tag_field;
    defparam inst.endpoint_l0_latency_data = endpoint_l0_latency_data;
    defparam inst.endpoint_l0_latency = endpoint_l0_latency;
    defparam inst.endpoint_l1_latency_data = endpoint_l1_latency_data;
    defparam inst.endpoint_l1_latency = endpoint_l1_latency;
    defparam inst.indicator_data = indicator_data;
    defparam inst.indicator = indicator;
    defparam inst.role_based_error_reporting = role_based_error_reporting;
    defparam inst.slot_power_scale_data = slot_power_scale_data;
    defparam inst.slot_power_scale = slot_power_scale;
    defparam inst.max_link_width = max_link_width;
    defparam inst.enable_l1_aspm = enable_l1_aspm;
    defparam inst.enable_l0s_aspm = enable_l0s_aspm;
    defparam inst.l1_exit_latency_sameclock_data = l1_exit_latency_sameclock_data;
    defparam inst.l1_exit_latency_sameclock = l1_exit_latency_sameclock;
    defparam inst.l1_exit_latency_diffclock_data = l1_exit_latency_diffclock_data;
    defparam inst.l1_exit_latency_diffclock = l1_exit_latency_diffclock;
    defparam inst.hot_plug_support_data = hot_plug_support_data;
    defparam inst.hot_plug_support = hot_plug_support;
    defparam inst.slot_power_limit_data = slot_power_limit_data;
    defparam inst.slot_power_limit = slot_power_limit;
    defparam inst.slot_number_data = slot_number_data;
    defparam inst.slot_number = slot_number;
    defparam inst.diffclock_nfts_count_data = diffclock_nfts_count_data;
    defparam inst.diffclock_nfts_count = diffclock_nfts_count;
    defparam inst.sameclock_nfts_count_data = sameclock_nfts_count_data;
    defparam inst.sameclock_nfts_count = sameclock_nfts_count;
    defparam inst.completion_timeout = completion_timeout;
    defparam inst.enable_completion_timeout_disable = enable_completion_timeout_disable;
    defparam inst.extended_tag_reset = extended_tag_reset;
    defparam inst.ecrc_check_capable = ecrc_check_capable;
    defparam inst.ecrc_gen_capable = ecrc_gen_capable;
    defparam inst.no_command_completed = no_command_completed;
    defparam inst.msi_multi_message_capable = msi_multi_message_capable;
    defparam inst.msi_64bit_addressing_capable = msi_64bit_addressing_capable;
    defparam inst.msi_masking_capable = msi_masking_capable;
    defparam inst.msi_support = msi_support;
    defparam inst.interrupt_pin = interrupt_pin;
    defparam inst.ena_ido_req = ena_ido_req;
    defparam inst.ena_ido_cpl = ena_ido_cpl;
    defparam inst.enable_function_msix_support = enable_function_msix_support;
    defparam inst.msix_table_size_data = msix_table_size_data;
    defparam inst.msix_table_size = msix_table_size;
    defparam inst.msix_table_bir_data = msix_table_bir_data;
    defparam inst.msix_table_bir = msix_table_bir;
    defparam inst.msix_table_offset_data = msix_table_offset_data;
    defparam inst.msix_table_offset = msix_table_offset;
    defparam inst.msix_pba_bir_data = msix_pba_bir_data;
    defparam inst.msix_pba_bir = msix_pba_bir;
    defparam inst.msix_pba_offset_data = msix_pba_offset_data;
    defparam inst.msix_pba_offset = msix_pba_offset;
    defparam inst.bridge_port_vga_enable = bridge_port_vga_enable;
    defparam inst.bridge_port_ssid_support = bridge_port_ssid_support;
    defparam inst.ssvid_data = ssvid_data;
    defparam inst.ssvid = ssvid;
    defparam inst.ssid_data = ssid_data;
    defparam inst.ssid = ssid;
    defparam inst.eie_before_nfts_count_data = eie_before_nfts_count_data;
    defparam inst.eie_before_nfts_count = eie_before_nfts_count;
    defparam inst.gen2_diffclock_nfts_count_data = gen2_diffclock_nfts_count_data;
    defparam inst.gen2_diffclock_nfts_count = gen2_diffclock_nfts_count;
    defparam inst.gen2_sameclock_nfts_count_data = gen2_sameclock_nfts_count_data;
    defparam inst.gen2_sameclock_nfts_count = gen2_sameclock_nfts_count;
    defparam inst.deemphasis_enable = deemphasis_enable;
    defparam inst.pcie_spec_version = pcie_spec_version;
    defparam inst.l0_exit_latency_sameclock_data = l0_exit_latency_sameclock_data;
    defparam inst.l0_exit_latency_sameclock = l0_exit_latency_sameclock;
    defparam inst.l0_exit_latency_diffclock_data = l0_exit_latency_diffclock_data;
    defparam inst.l0_exit_latency_diffclock = l0_exit_latency_diffclock;
    defparam inst.rx_ei_l0s = rx_ei_l0s;
    defparam inst.l2_async_logic = l2_async_logic;
    defparam inst.aspm_config_management = aspm_config_management;
    defparam inst.atomic_op_routing = atomic_op_routing;
    defparam inst.atomic_op_completer_32bit = atomic_op_completer_32bit;
    defparam inst.atomic_op_completer_64bit = atomic_op_completer_64bit;
    defparam inst.cas_completer_128bit = cas_completer_128bit;
    defparam inst.ltr_mechanism = ltr_mechanism;
    defparam inst.tph_completer = tph_completer;
    defparam inst.extended_format_field = extended_format_field;
    defparam inst.atomic_malformed = atomic_malformed;
    defparam inst.flr_capability = flr_capability;
    defparam inst.enable_adapter_half_rate_mode = enable_adapter_half_rate_mode;
    defparam inst.vc0_clk_enable = vc0_clk_enable;
    defparam inst.vc1_clk_enable = vc1_clk_enable;
    defparam inst.register_pipe_signals = register_pipe_signals;
    defparam inst.bar0_io_space = bar0_io_space;
    defparam inst.bar0_64bit_mem_space = bar0_64bit_mem_space;
    defparam inst.bar0_prefetchable = bar0_prefetchable;
    defparam inst.bar0_size_mask_data = bar0_size_mask_data;
    defparam inst.bar0_size_mask = bar0_size_mask;
    defparam inst.bar1_io_space = bar1_io_space;
    defparam inst.bar1_64bit_mem_space = bar1_64bit_mem_space;
    defparam inst.bar1_prefetchable = bar1_prefetchable;
    defparam inst.bar1_size_mask_data = bar1_size_mask_data;
    defparam inst.bar1_size_mask = bar1_size_mask;
    defparam inst.bar2_io_space = bar2_io_space;
    defparam inst.bar2_64bit_mem_space = bar2_64bit_mem_space;
    defparam inst.bar2_prefetchable = bar2_prefetchable;
    defparam inst.bar2_size_mask_data = bar2_size_mask_data;
    defparam inst.bar2_size_mask = bar2_size_mask;
    defparam inst.bar3_io_space = bar3_io_space;
    defparam inst.bar3_64bit_mem_space = bar3_64bit_mem_space;
    defparam inst.bar3_prefetchable = bar3_prefetchable;
    defparam inst.bar3_size_mask_data = bar3_size_mask_data;
    defparam inst.bar3_size_mask = bar3_size_mask;
    defparam inst.bar4_io_space = bar4_io_space;
    defparam inst.bar4_64bit_mem_space = bar4_64bit_mem_space;
    defparam inst.bar4_prefetchable = bar4_prefetchable;
    defparam inst.bar4_size_mask_data = bar4_size_mask_data;
    defparam inst.bar4_size_mask = bar4_size_mask;
    defparam inst.bar5_io_space = bar5_io_space;
    defparam inst.bar5_64bit_mem_space = bar5_64bit_mem_space;
    defparam inst.bar5_prefetchable = bar5_prefetchable;
    defparam inst.bar5_size_mask_data = bar5_size_mask_data;
    defparam inst.bar5_size_mask = bar5_size_mask;
    defparam inst.expansion_base_address_register_data = expansion_base_address_register_data;
    defparam inst.expansion_base_address_register = expansion_base_address_register;
    defparam inst.io_window_addr_width = io_window_addr_width;
    defparam inst.prefetchable_mem_window_addr_width = prefetchable_mem_window_addr_width;
    defparam inst.skp_os_gen3_count_data = skp_os_gen3_count_data;
    defparam inst.skp_os_gen3_count = skp_os_gen3_count;
    defparam inst.rx_cdc_almost_empty_data = rx_cdc_almost_empty_data;
    defparam inst.rx_cdc_almost_empty = rx_cdc_almost_empty;
    defparam inst.tx_cdc_almost_empty_data = tx_cdc_almost_empty_data;
    defparam inst.tx_cdc_almost_empty = tx_cdc_almost_empty;
    defparam inst.rx_cdc_almost_full_data = rx_cdc_almost_full_data;
    defparam inst.rx_cdc_almost_full = rx_cdc_almost_full;
    defparam inst.tx_cdc_almost_full_data = tx_cdc_almost_full_data;
    defparam inst.tx_cdc_almost_full = tx_cdc_almost_full;
    defparam inst.rx_l0s_count_idl_data = rx_l0s_count_idl_data;
    defparam inst.rx_l0s_count_idl = rx_l0s_count_idl;
    defparam inst.cdc_dummy_insert_limit_data = cdc_dummy_insert_limit_data;
    defparam inst.cdc_dummy_insert_limit = cdc_dummy_insert_limit;
    defparam inst.ei_delay_powerdown_count_data = ei_delay_powerdown_count_data;
    defparam inst.ei_delay_powerdown_count = ei_delay_powerdown_count;
    defparam inst.millisecond_cycle_count_data = millisecond_cycle_count_data;
    defparam inst.millisecond_cycle_count = millisecond_cycle_count;
    defparam inst.skp_os_schedule_count_data = skp_os_schedule_count_data;
    defparam inst.skp_os_schedule_count = skp_os_schedule_count;
    defparam inst.fc_init_timer_data = fc_init_timer_data;
    defparam inst.fc_init_timer = fc_init_timer;
    defparam inst.l01_entry_latency_data = l01_entry_latency_data;
    defparam inst.l01_entry_latency = l01_entry_latency;
    defparam inst.flow_control_update_count_data = flow_control_update_count_data;
    defparam inst.flow_control_update_count = flow_control_update_count;
    defparam inst.flow_control_timeout_count_data = flow_control_timeout_count_data;
    defparam inst.flow_control_timeout_count = flow_control_timeout_count;
    defparam inst.vc0_rx_flow_ctrl_posted_header_data = vc0_rx_flow_ctrl_posted_header_data;
    defparam inst.vc0_rx_flow_ctrl_posted_header = vc0_rx_flow_ctrl_posted_header;
    defparam inst.vc0_rx_flow_ctrl_posted_data_data = vc0_rx_flow_ctrl_posted_data_data;
    defparam inst.vc0_rx_flow_ctrl_posted_data = vc0_rx_flow_ctrl_posted_data;
    defparam inst.vc0_rx_flow_ctrl_nonposted_header_data = vc0_rx_flow_ctrl_nonposted_header_data;
    defparam inst.vc0_rx_flow_ctrl_nonposted_header = vc0_rx_flow_ctrl_nonposted_header;
    defparam inst.vc0_rx_flow_ctrl_nonposted_data_data = vc0_rx_flow_ctrl_nonposted_data_data;
    defparam inst.vc0_rx_flow_ctrl_nonposted_data = vc0_rx_flow_ctrl_nonposted_data;
    defparam inst.vc0_rx_flow_ctrl_compl_header_data = vc0_rx_flow_ctrl_compl_header_data;
    defparam inst.vc0_rx_flow_ctrl_compl_header = vc0_rx_flow_ctrl_compl_header;
    defparam inst.vc0_rx_flow_ctrl_compl_data_data = vc0_rx_flow_ctrl_compl_data_data;
    defparam inst.vc0_rx_flow_ctrl_compl_data = vc0_rx_flow_ctrl_compl_data;
    defparam inst.rx_ptr0_posted_dpram_min_data = rx_ptr0_posted_dpram_min_data;
    defparam inst.rx_ptr0_posted_dpram_min = rx_ptr0_posted_dpram_min;
    defparam inst.rx_ptr0_posted_dpram_max_data = rx_ptr0_posted_dpram_max_data;
    defparam inst.rx_ptr0_posted_dpram_max = rx_ptr0_posted_dpram_max;
    defparam inst.rx_ptr0_nonposted_dpram_min_data = rx_ptr0_nonposted_dpram_min_data;
    defparam inst.rx_ptr0_nonposted_dpram_min = rx_ptr0_nonposted_dpram_min;
    defparam inst.rx_ptr0_nonposted_dpram_max_data = rx_ptr0_nonposted_dpram_max_data;
    defparam inst.rx_ptr0_nonposted_dpram_max = rx_ptr0_nonposted_dpram_max;
    defparam inst.retry_buffer_last_active_address_data = retry_buffer_last_active_address_data;
    defparam inst.retry_buffer_last_active_address = retry_buffer_last_active_address;
    defparam inst.retry_buffer_memory_settings_data = retry_buffer_memory_settings_data;
    defparam inst.retry_buffer_memory_settings = retry_buffer_memory_settings;
    defparam inst.vc0_rx_buffer_memory_settings_data = vc0_rx_buffer_memory_settings_data;
    defparam inst.vc0_rx_buffer_memory_settings = vc0_rx_buffer_memory_settings;
    defparam inst.bist_memory_settings_data = bist_memory_settings_data;
    defparam inst.bist_memory_settings = bist_memory_settings;
    defparam inst.credit_buffer_allocation_aux = credit_buffer_allocation_aux;
    defparam inst.iei_enable_settings = iei_enable_settings;
    defparam inst.vsec_id_data = vsec_id_data;
    defparam inst.vsec_id = vsec_id;
    defparam inst.cvp_rate_sel = cvp_rate_sel;
    defparam inst.hard_reset_bypass = hard_reset_bypass;
    defparam inst.cvp_data_compressed = cvp_data_compressed;
    defparam inst.cvp_data_encrypted = cvp_data_encrypted;
    defparam inst.cvp_mode_reset = cvp_mode_reset;
    defparam inst.cvp_clk_reset = cvp_clk_reset;
    defparam inst.vsec_cap_data = vsec_cap_data;
    defparam inst.vsec_cap = vsec_cap;
    defparam inst.jtag_id_data = jtag_id_data;
    defparam inst.jtag_id = jtag_id;
    defparam inst.user_id_data = user_id_data;
    defparam inst.user_id = user_id;
    defparam inst.cseb_extend_pci = cseb_extend_pci;
    defparam inst.cseb_extend_pcie = cseb_extend_pcie;
    defparam inst.cseb_cpl_status_during_cvp = cseb_cpl_status_during_cvp;
    defparam inst.cseb_route_to_avl_rx_st = cseb_route_to_avl_rx_st;
    defparam inst.cseb_config_bypass = cseb_config_bypass;
    defparam inst.cseb_cpl_tag_checking = cseb_cpl_tag_checking;
    defparam inst.cseb_bar_match_checking = cseb_bar_match_checking;
    defparam inst.cseb_min_error_checking = cseb_min_error_checking;
    defparam inst.cseb_temp_busy_crs = cseb_temp_busy_crs;
    defparam inst.cseb_disable_auto_crs = cseb_disable_auto_crs;
    defparam inst.gen3_diffclock_nfts_count_data = gen3_diffclock_nfts_count_data;
    defparam inst.gen3_diffclock_nfts_count = gen3_diffclock_nfts_count;
    defparam inst.gen3_sameclock_nfts_count_data = gen3_sameclock_nfts_count_data;
    defparam inst.gen3_sameclock_nfts_count = gen3_sameclock_nfts_count;
    defparam inst.gen3_coeff_errchk = gen3_coeff_errchk;
    defparam inst.gen3_paritychk = gen3_paritychk;
    defparam inst.gen3_coeff_delay_count_data = gen3_coeff_delay_count_data;
    defparam inst.gen3_coeff_delay_count = gen3_coeff_delay_count;
    defparam inst.gen3_coeff_1_data = gen3_coeff_1_data;
    defparam inst.gen3_coeff_1 = gen3_coeff_1;
    defparam inst.gen3_coeff_1_sel = gen3_coeff_1_sel;
    defparam inst.gen3_coeff_1_preset_hint_data = gen3_coeff_1_preset_hint_data;
    defparam inst.gen3_coeff_1_preset_hint = gen3_coeff_1_preset_hint;
    defparam inst.gen3_coeff_1_nxtber_more_ptr = gen3_coeff_1_nxtber_more_ptr;
    defparam inst.gen3_coeff_1_nxtber_more = gen3_coeff_1_nxtber_more;
    defparam inst.gen3_coeff_1_nxtber_less_ptr = gen3_coeff_1_nxtber_less_ptr;
    defparam inst.gen3_coeff_1_nxtber_less = gen3_coeff_1_nxtber_less;
    defparam inst.gen3_coeff_1_reqber_data = gen3_coeff_1_reqber_data;
    defparam inst.gen3_coeff_1_reqber = gen3_coeff_1_reqber;
    defparam inst.gen3_coeff_1_ber_meas_data = gen3_coeff_1_ber_meas_data;
    defparam inst.gen3_coeff_1_ber_meas = gen3_coeff_1_ber_meas;
    defparam inst.gen3_coeff_2_data = gen3_coeff_2_data;
    defparam inst.gen3_coeff_2 = gen3_coeff_2;
    defparam inst.gen3_coeff_2_sel = gen3_coeff_2_sel;
    defparam inst.gen3_coeff_2_preset_hint_data = gen3_coeff_2_preset_hint_data;
    defparam inst.gen3_coeff_2_preset_hint = gen3_coeff_2_preset_hint;
    defparam inst.gen3_coeff_2_nxtber_more_ptr = gen3_coeff_2_nxtber_more_ptr;
    defparam inst.gen3_coeff_2_nxtber_more = gen3_coeff_2_nxtber_more;
    defparam inst.gen3_coeff_2_nxtber_less_ptr = gen3_coeff_2_nxtber_less_ptr;
    defparam inst.gen3_coeff_2_nxtber_less = gen3_coeff_2_nxtber_less;
    defparam inst.gen3_coeff_2_reqber_data = gen3_coeff_2_reqber_data;
    defparam inst.gen3_coeff_2_reqber = gen3_coeff_2_reqber;
    defparam inst.gen3_coeff_2_ber_meas_data = gen3_coeff_2_ber_meas_data;
    defparam inst.gen3_coeff_2_ber_meas = gen3_coeff_2_ber_meas;
    defparam inst.gen3_coeff_3_data = gen3_coeff_3_data;
    defparam inst.gen3_coeff_3 = gen3_coeff_3;
    defparam inst.gen3_coeff_3_sel = gen3_coeff_3_sel;
    defparam inst.gen3_coeff_3_preset_hint_data = gen3_coeff_3_preset_hint_data;
    defparam inst.gen3_coeff_3_preset_hint = gen3_coeff_3_preset_hint;
    defparam inst.gen3_coeff_3_nxtber_more_ptr = gen3_coeff_3_nxtber_more_ptr;
    defparam inst.gen3_coeff_3_nxtber_more = gen3_coeff_3_nxtber_more;
    defparam inst.gen3_coeff_3_nxtber_less_ptr = gen3_coeff_3_nxtber_less_ptr;
    defparam inst.gen3_coeff_3_nxtber_less = gen3_coeff_3_nxtber_less;
    defparam inst.gen3_coeff_3_reqber_data = gen3_coeff_3_reqber_data;
    defparam inst.gen3_coeff_3_reqber = gen3_coeff_3_reqber;
    defparam inst.gen3_coeff_3_ber_meas_data = gen3_coeff_3_ber_meas_data;
    defparam inst.gen3_coeff_3_ber_meas = gen3_coeff_3_ber_meas;
    defparam inst.gen3_coeff_4_data = gen3_coeff_4_data;
    defparam inst.gen3_coeff_4 = gen3_coeff_4;
    defparam inst.gen3_coeff_4_sel = gen3_coeff_4_sel;
    defparam inst.gen3_coeff_4_preset_hint_data = gen3_coeff_4_preset_hint_data;
    defparam inst.gen3_coeff_4_preset_hint = gen3_coeff_4_preset_hint;
    defparam inst.gen3_coeff_4_nxtber_more_ptr = gen3_coeff_4_nxtber_more_ptr;
    defparam inst.gen3_coeff_4_nxtber_more = gen3_coeff_4_nxtber_more;
    defparam inst.gen3_coeff_4_nxtber_less_ptr = gen3_coeff_4_nxtber_less_ptr;
    defparam inst.gen3_coeff_4_nxtber_less = gen3_coeff_4_nxtber_less;
    defparam inst.gen3_coeff_4_reqber_data = gen3_coeff_4_reqber_data;
    defparam inst.gen3_coeff_4_reqber = gen3_coeff_4_reqber;
    defparam inst.gen3_coeff_4_ber_meas_data = gen3_coeff_4_ber_meas_data;
    defparam inst.gen3_coeff_4_ber_meas = gen3_coeff_4_ber_meas;
    defparam inst.gen3_coeff_5_data = gen3_coeff_5_data;
    defparam inst.gen3_coeff_5 = gen3_coeff_5;
    defparam inst.gen3_coeff_5_sel = gen3_coeff_5_sel;
    defparam inst.gen3_coeff_5_preset_hint_data = gen3_coeff_5_preset_hint_data;
    defparam inst.gen3_coeff_5_preset_hint = gen3_coeff_5_preset_hint;
    defparam inst.gen3_coeff_5_nxtber_more_ptr = gen3_coeff_5_nxtber_more_ptr;
    defparam inst.gen3_coeff_5_nxtber_more = gen3_coeff_5_nxtber_more;
    defparam inst.gen3_coeff_5_nxtber_less_ptr = gen3_coeff_5_nxtber_less_ptr;
    defparam inst.gen3_coeff_5_nxtber_less = gen3_coeff_5_nxtber_less;
    defparam inst.gen3_coeff_5_reqber_data = gen3_coeff_5_reqber_data;
    defparam inst.gen3_coeff_5_reqber = gen3_coeff_5_reqber;
    defparam inst.gen3_coeff_5_ber_meas_data = gen3_coeff_5_ber_meas_data;
    defparam inst.gen3_coeff_5_ber_meas = gen3_coeff_5_ber_meas;
    defparam inst.gen3_coeff_6_data = gen3_coeff_6_data;
    defparam inst.gen3_coeff_6 = gen3_coeff_6;
    defparam inst.gen3_coeff_6_sel = gen3_coeff_6_sel;
    defparam inst.gen3_coeff_6_preset_hint_data = gen3_coeff_6_preset_hint_data;
    defparam inst.gen3_coeff_6_preset_hint = gen3_coeff_6_preset_hint;
    defparam inst.gen3_coeff_6_nxtber_more_ptr = gen3_coeff_6_nxtber_more_ptr;
    defparam inst.gen3_coeff_6_nxtber_more = gen3_coeff_6_nxtber_more;
    defparam inst.gen3_coeff_6_nxtber_less_ptr = gen3_coeff_6_nxtber_less_ptr;
    defparam inst.gen3_coeff_6_nxtber_less = gen3_coeff_6_nxtber_less;
    defparam inst.gen3_coeff_6_reqber_data = gen3_coeff_6_reqber_data;
    defparam inst.gen3_coeff_6_reqber = gen3_coeff_6_reqber;
    defparam inst.gen3_coeff_6_ber_meas_data = gen3_coeff_6_ber_meas_data;
    defparam inst.gen3_coeff_6_ber_meas = gen3_coeff_6_ber_meas;
    defparam inst.gen3_coeff_7_data = gen3_coeff_7_data;
    defparam inst.gen3_coeff_7 = gen3_coeff_7;
    defparam inst.gen3_coeff_7_sel = gen3_coeff_7_sel;
    defparam inst.gen3_coeff_7_preset_hint_data = gen3_coeff_7_preset_hint_data;
    defparam inst.gen3_coeff_7_preset_hint = gen3_coeff_7_preset_hint;
    defparam inst.gen3_coeff_7_nxtber_more_ptr = gen3_coeff_7_nxtber_more_ptr;
    defparam inst.gen3_coeff_7_nxtber_more = gen3_coeff_7_nxtber_more;
    defparam inst.gen3_coeff_7_nxtber_less_ptr = gen3_coeff_7_nxtber_less_ptr;
    defparam inst.gen3_coeff_7_nxtber_less = gen3_coeff_7_nxtber_less;
    defparam inst.gen3_coeff_7_reqber_data = gen3_coeff_7_reqber_data;
    defparam inst.gen3_coeff_7_reqber = gen3_coeff_7_reqber;
    defparam inst.gen3_coeff_7_ber_meas_data = gen3_coeff_7_ber_meas_data;
    defparam inst.gen3_coeff_7_ber_meas = gen3_coeff_7_ber_meas;
    defparam inst.gen3_coeff_8_data = gen3_coeff_8_data;
    defparam inst.gen3_coeff_8 = gen3_coeff_8;
    defparam inst.gen3_coeff_8_sel = gen3_coeff_8_sel;
    defparam inst.gen3_coeff_8_preset_hint_data = gen3_coeff_8_preset_hint_data;
    defparam inst.gen3_coeff_8_preset_hint = gen3_coeff_8_preset_hint;
    defparam inst.gen3_coeff_8_nxtber_more_ptr = gen3_coeff_8_nxtber_more_ptr;
    defparam inst.gen3_coeff_8_nxtber_more = gen3_coeff_8_nxtber_more;
    defparam inst.gen3_coeff_8_nxtber_less_ptr = gen3_coeff_8_nxtber_less_ptr;
    defparam inst.gen3_coeff_8_nxtber_less = gen3_coeff_8_nxtber_less;
    defparam inst.gen3_coeff_8_reqber_data = gen3_coeff_8_reqber_data;
    defparam inst.gen3_coeff_8_reqber = gen3_coeff_8_reqber;
    defparam inst.gen3_coeff_8_ber_meas_data = gen3_coeff_8_ber_meas_data;
    defparam inst.gen3_coeff_8_ber_meas = gen3_coeff_8_ber_meas;
    defparam inst.gen3_coeff_9_data = gen3_coeff_9_data;
    defparam inst.gen3_coeff_9 = gen3_coeff_9;
    defparam inst.gen3_coeff_9_sel = gen3_coeff_9_sel;
    defparam inst.gen3_coeff_9_preset_hint_data = gen3_coeff_9_preset_hint_data;
    defparam inst.gen3_coeff_9_preset_hint = gen3_coeff_9_preset_hint;
    defparam inst.gen3_coeff_9_nxtber_more_ptr = gen3_coeff_9_nxtber_more_ptr;
    defparam inst.gen3_coeff_9_nxtber_more = gen3_coeff_9_nxtber_more;
    defparam inst.gen3_coeff_9_nxtber_less_ptr = gen3_coeff_9_nxtber_less_ptr;
    defparam inst.gen3_coeff_9_nxtber_less = gen3_coeff_9_nxtber_less;
    defparam inst.gen3_coeff_9_reqber_data = gen3_coeff_9_reqber_data;
    defparam inst.gen3_coeff_9_reqber = gen3_coeff_9_reqber;
    defparam inst.gen3_coeff_9_ber_meas_data = gen3_coeff_9_ber_meas_data;
    defparam inst.gen3_coeff_9_ber_meas = gen3_coeff_9_ber_meas;
    defparam inst.gen3_coeff_10_data = gen3_coeff_10_data;
    defparam inst.gen3_coeff_10 = gen3_coeff_10;
    defparam inst.gen3_coeff_10_sel = gen3_coeff_10_sel;
    defparam inst.gen3_coeff_10_preset_hint_data = gen3_coeff_10_preset_hint_data;
    defparam inst.gen3_coeff_10_preset_hint = gen3_coeff_10_preset_hint;
    defparam inst.gen3_coeff_10_nxtber_more_ptr = gen3_coeff_10_nxtber_more_ptr;
    defparam inst.gen3_coeff_10_nxtber_more = gen3_coeff_10_nxtber_more;
    defparam inst.gen3_coeff_10_nxtber_less_ptr = gen3_coeff_10_nxtber_less_ptr;
    defparam inst.gen3_coeff_10_nxtber_less = gen3_coeff_10_nxtber_less;
    defparam inst.gen3_coeff_10_reqber_data = gen3_coeff_10_reqber_data;
    defparam inst.gen3_coeff_10_reqber = gen3_coeff_10_reqber;
    defparam inst.gen3_coeff_10_ber_meas_data = gen3_coeff_10_ber_meas_data;
    defparam inst.gen3_coeff_10_ber_meas = gen3_coeff_10_ber_meas;
    defparam inst.gen3_coeff_11_data = gen3_coeff_11_data;
    defparam inst.gen3_coeff_11 = gen3_coeff_11;
    defparam inst.gen3_coeff_11_sel = gen3_coeff_11_sel;
    defparam inst.gen3_coeff_11_preset_hint_data = gen3_coeff_11_preset_hint_data;
    defparam inst.gen3_coeff_11_preset_hint = gen3_coeff_11_preset_hint;
    defparam inst.gen3_coeff_11_nxtber_more_ptr = gen3_coeff_11_nxtber_more_ptr;
    defparam inst.gen3_coeff_11_nxtber_more = gen3_coeff_11_nxtber_more;
    defparam inst.gen3_coeff_11_nxtber_less_ptr = gen3_coeff_11_nxtber_less_ptr;
    defparam inst.gen3_coeff_11_nxtber_less = gen3_coeff_11_nxtber_less;
    defparam inst.gen3_coeff_11_reqber_data = gen3_coeff_11_reqber_data;
    defparam inst.gen3_coeff_11_reqber = gen3_coeff_11_reqber;
    defparam inst.gen3_coeff_11_ber_meas_data = gen3_coeff_11_ber_meas_data;
    defparam inst.gen3_coeff_11_ber_meas = gen3_coeff_11_ber_meas;
    defparam inst.gen3_coeff_12_data = gen3_coeff_12_data;
    defparam inst.gen3_coeff_12 = gen3_coeff_12;
    defparam inst.gen3_coeff_12_sel = gen3_coeff_12_sel;
    defparam inst.gen3_coeff_12_preset_hint_data = gen3_coeff_12_preset_hint_data;
    defparam inst.gen3_coeff_12_preset_hint = gen3_coeff_12_preset_hint;
    defparam inst.gen3_coeff_12_nxtber_more_ptr = gen3_coeff_12_nxtber_more_ptr;
    defparam inst.gen3_coeff_12_nxtber_more = gen3_coeff_12_nxtber_more;
    defparam inst.gen3_coeff_12_nxtber_less_ptr = gen3_coeff_12_nxtber_less_ptr;
    defparam inst.gen3_coeff_12_nxtber_less = gen3_coeff_12_nxtber_less;
    defparam inst.gen3_coeff_12_reqber_data = gen3_coeff_12_reqber_data;
    defparam inst.gen3_coeff_12_reqber = gen3_coeff_12_reqber;
    defparam inst.gen3_coeff_12_ber_meas_data = gen3_coeff_12_ber_meas_data;
    defparam inst.gen3_coeff_12_ber_meas = gen3_coeff_12_ber_meas;
    defparam inst.gen3_coeff_13_data = gen3_coeff_13_data;
    defparam inst.gen3_coeff_13 = gen3_coeff_13;
    defparam inst.gen3_coeff_13_sel = gen3_coeff_13_sel;
    defparam inst.gen3_coeff_13_preset_hint_data = gen3_coeff_13_preset_hint_data;
    defparam inst.gen3_coeff_13_preset_hint = gen3_coeff_13_preset_hint;
    defparam inst.gen3_coeff_13_nxtber_more_ptr = gen3_coeff_13_nxtber_more_ptr;
    defparam inst.gen3_coeff_13_nxtber_more = gen3_coeff_13_nxtber_more;
    defparam inst.gen3_coeff_13_nxtber_less_ptr = gen3_coeff_13_nxtber_less_ptr;
    defparam inst.gen3_coeff_13_nxtber_less = gen3_coeff_13_nxtber_less;
    defparam inst.gen3_coeff_13_reqber_data = gen3_coeff_13_reqber_data;
    defparam inst.gen3_coeff_13_reqber = gen3_coeff_13_reqber;
    defparam inst.gen3_coeff_13_ber_meas_data = gen3_coeff_13_ber_meas_data;
    defparam inst.gen3_coeff_13_ber_meas = gen3_coeff_13_ber_meas;
    defparam inst.gen3_coeff_14_data = gen3_coeff_14_data;
    defparam inst.gen3_coeff_14 = gen3_coeff_14;
    defparam inst.gen3_coeff_14_sel = gen3_coeff_14_sel;
    defparam inst.gen3_coeff_14_preset_hint_data = gen3_coeff_14_preset_hint_data;
    defparam inst.gen3_coeff_14_preset_hint = gen3_coeff_14_preset_hint;
    defparam inst.gen3_coeff_14_nxtber_more_ptr = gen3_coeff_14_nxtber_more_ptr;
    defparam inst.gen3_coeff_14_nxtber_more = gen3_coeff_14_nxtber_more;
    defparam inst.gen3_coeff_14_nxtber_less_ptr = gen3_coeff_14_nxtber_less_ptr;
    defparam inst.gen3_coeff_14_nxtber_less = gen3_coeff_14_nxtber_less;
    defparam inst.gen3_coeff_14_reqber_data = gen3_coeff_14_reqber_data;
    defparam inst.gen3_coeff_14_reqber = gen3_coeff_14_reqber;
    defparam inst.gen3_coeff_14_ber_meas_data = gen3_coeff_14_ber_meas_data;
    defparam inst.gen3_coeff_14_ber_meas = gen3_coeff_14_ber_meas;
    defparam inst.gen3_coeff_15_data = gen3_coeff_15_data;
    defparam inst.gen3_coeff_15 = gen3_coeff_15;
    defparam inst.gen3_coeff_15_sel = gen3_coeff_15_sel;
    defparam inst.gen3_coeff_15_preset_hint_data = gen3_coeff_15_preset_hint_data;
    defparam inst.gen3_coeff_15_preset_hint = gen3_coeff_15_preset_hint;
    defparam inst.gen3_coeff_15_nxtber_more_ptr = gen3_coeff_15_nxtber_more_ptr;
    defparam inst.gen3_coeff_15_nxtber_more = gen3_coeff_15_nxtber_more;
    defparam inst.gen3_coeff_15_nxtber_less_ptr = gen3_coeff_15_nxtber_less_ptr;
    defparam inst.gen3_coeff_15_nxtber_less = gen3_coeff_15_nxtber_less;
    defparam inst.gen3_coeff_15_reqber_data = gen3_coeff_15_reqber_data;
    defparam inst.gen3_coeff_15_reqber = gen3_coeff_15_reqber;
    defparam inst.gen3_coeff_15_ber_meas_data = gen3_coeff_15_ber_meas_data;
    defparam inst.gen3_coeff_15_ber_meas = gen3_coeff_15_ber_meas;
    defparam inst.gen3_coeff_16_data = gen3_coeff_16_data;
    defparam inst.gen3_coeff_16 = gen3_coeff_16;
    defparam inst.gen3_coeff_16_sel = gen3_coeff_16_sel;
    defparam inst.gen3_coeff_16_preset_hint_data = gen3_coeff_16_preset_hint_data;
    defparam inst.gen3_coeff_16_preset_hint = gen3_coeff_16_preset_hint;
    defparam inst.gen3_coeff_16_nxtber_more_ptr = gen3_coeff_16_nxtber_more_ptr;
    defparam inst.gen3_coeff_16_nxtber_more = gen3_coeff_16_nxtber_more;
    defparam inst.gen3_coeff_16_nxtber_less_ptr = gen3_coeff_16_nxtber_less_ptr;
    defparam inst.gen3_coeff_16_nxtber_less = gen3_coeff_16_nxtber_less;
    defparam inst.gen3_coeff_16_reqber_data = gen3_coeff_16_reqber_data;
    defparam inst.gen3_coeff_16_reqber = gen3_coeff_16_reqber;
    defparam inst.gen3_coeff_16_ber_meas_data = gen3_coeff_16_ber_meas_data;
    defparam inst.gen3_coeff_16_ber_meas = gen3_coeff_16_ber_meas;
    defparam inst.gen3_preset_coeff_1_data = gen3_preset_coeff_1_data;
    defparam inst.gen3_preset_coeff_1 = gen3_preset_coeff_1;
    defparam inst.gen3_preset_coeff_2_data = gen3_preset_coeff_2_data;
    defparam inst.gen3_preset_coeff_2 = gen3_preset_coeff_2;
    defparam inst.gen3_preset_coeff_3_data = gen3_preset_coeff_3_data;
    defparam inst.gen3_preset_coeff_3 = gen3_preset_coeff_3;
    defparam inst.gen3_preset_coeff_4_data = gen3_preset_coeff_4_data;
    defparam inst.gen3_preset_coeff_4 = gen3_preset_coeff_4;
    defparam inst.gen3_preset_coeff_5_data = gen3_preset_coeff_5_data;
    defparam inst.gen3_preset_coeff_5 = gen3_preset_coeff_5;
    defparam inst.gen3_preset_coeff_6_data = gen3_preset_coeff_6_data;
    defparam inst.gen3_preset_coeff_6 = gen3_preset_coeff_6;
    defparam inst.gen3_preset_coeff_7_data = gen3_preset_coeff_7_data;
    defparam inst.gen3_preset_coeff_7 = gen3_preset_coeff_7;
    defparam inst.gen3_preset_coeff_8_data = gen3_preset_coeff_8_data;
    defparam inst.gen3_preset_coeff_8 = gen3_preset_coeff_8;
    defparam inst.gen3_preset_coeff_9_data = gen3_preset_coeff_9_data;
    defparam inst.gen3_preset_coeff_9 = gen3_preset_coeff_9;
    defparam inst.gen3_preset_coeff_10_data = gen3_preset_coeff_10_data;
    defparam inst.gen3_preset_coeff_10 = gen3_preset_coeff_10;
    defparam inst.gen3_rxfreqlock_counter_data = gen3_rxfreqlock_counter_data;
    defparam inst.gen3_rxfreqlock_counter = gen3_rxfreqlock_counter;

    defparam inst.rstctrl_pld_clr                    = rstctrl_pld_clr                    ;
    defparam inst.rstctrl_debug_en                   = rstctrl_debug_en                   ;
    defparam inst.rstctrl_force_inactive_rst         = rstctrl_force_inactive_rst         ;
    defparam inst.rstctrl_perst_enable               = rstctrl_perst_enable               ;
    defparam inst.hrdrstctrl_en                      = hrdrstctrl_en                      ;
    defparam inst.rstctrl_hip_ep                     = rstctrl_hip_ep                     ;
    defparam inst.rstctrl_hard_block_enable          = rstctrl_hard_block_enable          ;
    defparam inst.rstctrl_rx_pma_rstb_inv            = rstctrl_rx_pma_rstb_inv            ;
    defparam inst.rstctrl_tx_pma_rstb_inv            = rstctrl_tx_pma_rstb_inv            ;
    defparam inst.rstctrl_rx_pcs_rst_n_inv           = rstctrl_rx_pcs_rst_n_inv           ;
    defparam inst.rstctrl_tx_pcs_rst_n_inv           = rstctrl_tx_pcs_rst_n_inv           ;
    defparam inst.rstctrl_altpe3_crst_n_inv          = rstctrl_altpe3_crst_n_inv          ;
    defparam inst.rstctrl_altpe3_srst_n_inv          = rstctrl_altpe3_srst_n_inv          ;
    defparam inst.rstctrl_altpe3_rst_n_inv           = rstctrl_altpe3_rst_n_inv           ;
    defparam inst.rstctrl_tx_pma_syncp_inv           = rstctrl_tx_pma_syncp_inv           ;
    defparam inst.rstctrl_1us_count_fref_clk         = rstctrl_1us_count_fref_clk         ;
    defparam inst.rstctrl_1us_count_fref_clk_value   = rstctrl_1us_count_fref_clk_value   ;
    defparam inst.rstctrl_1ms_count_fref_clk         = rstctrl_1ms_count_fref_clk         ;
    defparam inst.rstctrl_1ms_count_fref_clk_value   = rstctrl_1ms_count_fref_clk_value   ;
    defparam inst.rstctrl_off_cal_done_select        = rstctrl_off_cal_done_select        ;
    defparam inst.rstctrl_rx_pma_rstb_cmu_select     = rstctrl_rx_pma_rstb_cmu_select     ;
    defparam inst.rstctrl_rx_pll_freq_lock_select    = rstctrl_rx_pll_freq_lock_select    ;
    defparam inst.rstctrl_mask_tx_pll_lock_select    = rstctrl_mask_tx_pll_lock_select    ;
    defparam inst.rstctrl_rx_pll_lock_select         = rstctrl_rx_pll_lock_select         ;
    defparam inst.rstctrl_perstn_select              = rstctrl_perstn_select              ;
    defparam inst.rstctrl_tx_lc_pll_rstb_select      = rstctrl_tx_lc_pll_rstb_select      ;
    defparam inst.rstctrl_fref_clk_select            = rstctrl_fref_clk_select            ;
    defparam inst.rstctrl_off_cal_en_select          = rstctrl_off_cal_en_select          ;
    defparam inst.rstctrl_tx_pma_syncp_select        = rstctrl_tx_pma_syncp_select        ;
    defparam inst.rstctrl_rx_pcs_rst_n_select        = rstctrl_rx_pcs_rst_n_select        ;
    defparam inst.rstctrl_tx_cmu_pll_lock_select     = rstctrl_tx_cmu_pll_lock_select     ;
    defparam inst.rstctrl_tx_pcs_rst_n_select        = rstctrl_tx_pcs_rst_n_select        ;
    defparam inst.rstctrl_tx_lc_pll_lock_select      = rstctrl_tx_lc_pll_lock_select      ;
    defparam inst.rstctrl_timer_a                    = rstctrl_timer_a                    ;
    defparam inst.rstctrl_timer_a_type               = rstctrl_timer_a_type               ;
    defparam inst.rstctrl_timer_a_value              = rstctrl_timer_a_value              ;
    defparam inst.rstctrl_timer_b                    = rstctrl_timer_b                    ;
    defparam inst.rstctrl_timer_b_type               = rstctrl_timer_b_type               ;
    defparam inst.rstctrl_timer_b_value              = rstctrl_timer_b_value              ;
    defparam inst.rstctrl_timer_c                    = rstctrl_timer_c                    ;
    defparam inst.rstctrl_timer_c_type               = rstctrl_timer_c_type               ;
    defparam inst.rstctrl_timer_c_value              = rstctrl_timer_c_value              ;
    defparam inst.rstctrl_timer_d                    = rstctrl_timer_d                    ;
    defparam inst.rstctrl_timer_d_type               = rstctrl_timer_d_type               ;
    defparam inst.rstctrl_timer_d_value              = rstctrl_timer_d_value              ;
    defparam inst.rstctrl_timer_e                    = rstctrl_timer_e                    ;
    defparam inst.rstctrl_timer_e_type               = rstctrl_timer_e_type               ;
    defparam inst.rstctrl_timer_e_value              = rstctrl_timer_e_value              ;
    defparam inst.rstctrl_timer_f                    = rstctrl_timer_f                    ;
    defparam inst.rstctrl_timer_f_type               = rstctrl_timer_f_type               ;
    defparam inst.rstctrl_timer_f_value              = rstctrl_timer_f_value              ;
    defparam inst.rstctrl_timer_g                    = rstctrl_timer_g                    ;
    defparam inst.rstctrl_timer_g_type               = rstctrl_timer_g_type               ;
    defparam inst.rstctrl_timer_g_value              = rstctrl_timer_g_value              ;
    defparam inst.rstctrl_timer_h                    = rstctrl_timer_h                    ;
    defparam inst.rstctrl_timer_h_type               = rstctrl_timer_h_type               ;
    defparam inst.rstctrl_timer_h_value              = rstctrl_timer_h_value              ;
    defparam inst.rstctrl_timer_i                    = rstctrl_timer_i                    ;
    defparam inst.rstctrl_timer_i_type               = rstctrl_timer_i_type               ;
    defparam inst.rstctrl_timer_i_value              = rstctrl_timer_i_value              ;
    defparam inst.rstctrl_timer_j                    = rstctrl_timer_j                    ;
    defparam inst.rstctrl_timer_j_type               = rstctrl_timer_j_type               ;
    defparam inst.rstctrl_timer_j_value              = rstctrl_timer_j_value              ;
endmodule //stratixv_hssi_gen3_pcie_hip

