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
----------------------------------------------------------------------------
-- ALtera Megafunction Component Declaration File
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package altera_mf_components is
type altera_mf_logic_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;

component lcell
    port (
        a_in : in std_logic;
        a_out : out std_logic);
end component;


component altclklock
    generic (
        inclock_period          : natural := 10000;   -- units in ps
        inclock_settings        : string := "UNUSED";
        valid_lock_cycles       : natural := 5;
        invalid_lock_cycles     : natural := 5;
        valid_lock_multiplier   : natural := 5;
        invalid_lock_multiplier : natural := 5;
        operation_mode          : string := "NORMAL";
        clock0_boost            : natural := 1;
        clock0_divide           : natural := 1;
        clock0_settings         : string := "UNUSED";
        clock0_time_delay       : string := "0";
        clock1_boost            : natural := 1;
        clock1_divide           : natural := 1;
        clock1_settings         : string := "UNUSED";
        clock1_time_delay       : string := "0";
        clock2_boost            : natural := 1;
        clock2_divide           : natural := 1;
        clock2_settings         : string := "UNUSED";
        clock2_time_delay       : string := "0";
        clock_ext_boost         : natural := 1;
        clock_ext_divide        : natural := 1;
        clock_ext_settings      : string := "UNUSED";
        clock_ext_time_delay    : string := "0";
        outclock_phase_shift    : natural := 0;   -- units in ps
        intended_device_family  : string := "Stratix" ;
        lpm_hint                : string  := "UNUSED";
        lpm_type                : string := "altclklock" );
    port(
        inclock   : in std_logic;  -- required port, input reference clock
        inclocken : in std_logic := '1';  -- PLL enable signal
        fbin      : in std_logic := '1';  -- feedback input for the PLL
        clock0    : out std_logic;  -- clock0 output
        clock1    : out std_logic;  -- clock1 output
        clock2    : out std_logic;  -- clock2 output
        clock_ext : out std_logic;  -- external clock output
        locked    : out std_logic );  -- PLL lock signal
end component;

component altlvds_rx
    generic (
        number_of_channels          : natural;
        deserialization_factor      : natural;
        inclock_boost               : natural:= 0;
        registered_output           : string := "ON";
        inclock_period              : natural;
        cds_mode                    : string := "UNUSED";
        intended_device_family      : string := "Stratix";
        input_data_rate             : natural:= 0;
        inclock_data_alignment      : string := "UNUSED";
        registered_data_align_input : string :="ON";
        common_rx_tx_pll            : string :="ON";
        enable_dpa_mode             : string := "OFF";
        enable_dpa_pll_calibration  : string  := "OFF";
        enable_dpa_calibration      : string := "ON";
        enable_dpa_fifo             : string := "ON";
        use_dpll_rawperror          : string := "OFF";
        use_coreclock_input         : string := "OFF";
        dpll_lock_count             : natural:= 0;
        dpll_lock_window            : natural:= 0;
        outclock_resource           : string := "AUTO";
        data_align_rollover         : natural := 10;
        lose_lock_on_one_change     : string  := "OFF";
        reset_fifo_at_first_lock    : string  := "ON";
        use_external_pll            : string  := "OFF";
        implement_in_les            : string  := "OFF";
        buffer_implementation       : string  := "RAM";
        port_rx_data_align          : string  := "PORT_CONNECTIVITY";
        port_rx_channel_data_align  : string  := "PORT_CONNECTIVITY";
        pll_operation_mode          : string  := "NORMAL";
        x_on_bitslip                : string  := "ON";
        use_no_phase_shift          : string  := "ON";
        rx_align_data_reg           : string  := "RISING_EDGE";
        inclock_phase_shift         : integer := 0;
        enable_soft_cdr_mode        : string  := "OFF";
        sim_dpa_output_clock_phase_shift : integer := 0;
        sim_dpa_is_negative_ppm_drift    : string  := "OFF";
        sim_dpa_net_ppm_variation        : natural := 0;
        enable_dpa_align_to_rising_edge_only  : string  := "OFF";
        enable_dpa_initial_phase_selection    : string  := "OFF";
        dpa_initial_phase_value     :natural  := 0;
        pll_self_reset_on_loss_lock : string  := "OFF";
        refclk_frequency           : string := "UNUSED";
        data_rate                 : string := "UNUSED";
        lpm_hint                    : string := "UNUSED";
        lpm_type                    : string := "altlvds_rx";
        clk_src_is_pll              : string := "off" );
    port (
        rx_in                 : in std_logic_vector(number_of_channels-1 downto 0);
        rx_inclock            : in std_logic := '0';
        rx_syncclock          : in std_logic := '0';
        rx_dpaclock           : in std_logic_vector(0 downto 0) := (others => '0');
        rx_readclock          : in std_logic := '0';
        rx_enable             : in std_logic := '1';
        rx_deskew             : in std_logic := '0';
        rx_pll_enable         : in std_logic := '1';
        rx_data_align         : in std_logic := '0';
        rx_data_align_reset   : in std_logic := '0';
        rx_reset              : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_dpll_reset         : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_dpll_hold          : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_dpll_enable        : in std_logic_vector(number_of_channels-1 downto 0) := (others => '1');
        rx_fifo_reset         : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_channel_data_align : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_cda_reset          : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_coreclk            : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        pll_areset            : in std_logic := '0';
        rx_data_reset         : in std_logic := '0';
        dpa_pll_recal         : in std_logic := '0';
        pll_phasedone         : in std_logic := '1';
        rx_dpa_lock_reset     : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_out                : out std_logic_vector(deserialization_factor*number_of_channels -1 downto 0);
        rx_outclock           : out std_logic;
        rx_locked             : out std_logic;
        rx_dpa_locked         : out std_logic_vector(number_of_channels-1 downto 0);
        rx_cda_max            : out std_logic_vector(number_of_channels-1 downto 0);
        rx_divfwdclk          : out std_logic_vector(number_of_channels-1 downto 0);
        dpa_pll_cal_busy      : out std_logic;
        pll_phasestep         : out std_logic;
        pll_phaseupdown       : out std_logic;
        pll_phasecounterselect: out std_logic_Vector(3 downto 0);
        pll_scanclk           : out std_logic);
end component;

component altlvds_tx
    generic (
        number_of_channels     : natural;
        deserialization_factor : natural:= 4;
        inclock_boost          : natural := 0;
        outclock_divide_by     : positive:= 1;
        registered_input       : string := "ON";
        multi_clock            : string := "OFF";
        inclock_period         : natural;
        center_align_msb       : string := "UNUSED";
        intended_device_family : string := "Stratix";
        output_data_rate       : natural:= 0;
        outclock_resource      : string := "AUTO";
        common_rx_tx_pll       : string := "ON";
        inclock_data_alignment : string := "EDGE_ALIGNED";
        outclock_alignment     : string := "EDGE_ALIGNED";
        use_external_pll       : string := "OFF";
        implement_in_les       : STRING  := "OFF";
        preemphasis_setting    : natural := 0;
        vod_setting            : natural := 0;
        differential_drive     : natural := 0;
        outclock_multiply_by   : natural := 1;
        coreclock_divide_by    : natural := 2;
        outclock_duty_cycle    : natural := 50;
        inclock_phase_shift    : integer := 0;
        outclock_phase_shift   : integer := 0;
        use_no_phase_shift     : string  := "ON";
        pll_self_reset_on_loss_lock : string  := "OFF";
        refclk_frequency      : string := "UNUSED";
        data_rate           : string := "UNUSED";
        lpm_hint               : string  := "UNUSED";
        lpm_type               : string := "altlvds_tx";
        clk_src_is_pll         : string := "off" );
    port (
        tx_in           : in std_logic_vector(deserialization_factor*number_of_channels -1 downto 0);
        tx_inclock      : in std_logic := '0';
        tx_syncclock    : in std_logic := '0';
        tx_enable       : in std_logic := '1';
        sync_inclock    : in std_logic := '0';
        tx_pll_enable   : in std_logic := '1';
        pll_areset      : in std_logic := '0';
        tx_data_reset   : in std_logic := '0';
        tx_out          : out std_logic_vector(number_of_channels-1 downto 0);
        tx_outclock     : out std_logic;
        tx_coreclock    : out std_logic;
        tx_locked       : out std_logic );
end component;

component altdpram
    generic (
        width                               : natural;
        widthad                             : natural;
        numwords                            : natural := 0;
        lpm_file                            : string := "UNUSED";
        lpm_hint                            : string := "USE_EAB=ON";
        use_eab                             : string := "ON";
        indata_reg                          : string := "INCLOCK";
        indata_aclr                         : string := "ON";
        wraddress_reg                       : string := "INCLOCK";
        wraddress_aclr                      : string := "ON";
        wrcontrol_reg                       : string := "INCLOCK";
        wrcontrol_aclr                      : string := "ON";
        rdaddress_reg                       : string := "OUTCLOCK";
        rdaddress_aclr                      : string := "ON";
        rdcontrol_reg                       : string := "OUTCLOCK";
        rdcontrol_aclr                      : string := "ON";
        outdata_reg                         : string := "UNREGISTERED";
        outdata_aclr                        : string := "ON";
        ram_block_type                      : string := "AUTO";
        width_byteena                       : natural := 1;
        byte_size                           : natural := 5;
        read_during_write_mode_mixed_ports  : string := "DONT_CARE";
        intended_device_family              : string := "Stratix";
        lpm_type                            : string := "altdpram" );
    port(
        wren            : in std_logic := '0';
        data            : in std_logic_vector(width-1 downto 0);
        wraddress       : in std_logic_vector(widthad-1 downto 0);
        wraddressstall  : in std_logic := '0';
        inclock         : in std_logic := '1';
        inclocken       : in std_logic := '1';
        rden            : in std_logic := '1';
        rdaddress       : in std_logic_vector(widthad-1 downto 0);
        rdaddressstall  : in std_logic := '0';
        byteena         : in std_logic_vector(width_byteena-1 downto 0) := (others => '1');
        outclock        : in std_logic := '1';
        outclocken      : in std_logic := '1';
        aclr            : in std_logic := '0';
        q               : out std_logic_vector(width-1 downto 0) );
end component;


component alt3pram
    generic (
        width                  : natural;
        widthad                : natural;
        numwords               : natural := 0;
        lpm_file               : string := "UNUSED";
        lpm_hint               : string := "USE_EAB=ON";
        indata_reg             : string := "UNREGISTERED";
        indata_aclr            : string := "OFF";
        write_reg              : string := "UNREGISTERED";
        write_aclr             : string := "OFF";
        rdaddress_reg_a        : string := "UNREGISTERED";
        rdaddress_aclr_a       : string := "OFF";
        rdaddress_reg_b        : string := "UNREGISTERED";
        rdaddress_aclr_b       : string := "OFF";
        rdcontrol_reg_a        : string := "UNREGISTERED";
        rdcontrol_aclr_a       : string := "OFF";
        rdcontrol_reg_b        : string := "UNREGISTERED";
        rdcontrol_aclr_b       : string := "OFF";
        outdata_reg_a          : string := "UNREGISTERED";
        outdata_aclr_a         : string := "OFF";
        outdata_reg_b          : string := "UNREGISTERED";
        outdata_aclr_b         : string := "OFF";
        intended_device_family : string := "Stratix";
        ram_block_type         : string  := "AUTO";
        maximum_depth          : integer := 0;
        lpm_type : string      := "alt3pram" );
    port (
        wren        : in std_logic := '0';
        data        : in std_logic_vector(width-1 downto 0);
        wraddress   : in std_logic_vector(widthad-1 downto 0);
        inclock     : in std_logic := '0';
        inclocken   : in std_logic := '1';
        rden_a      : in std_logic := '1';
        rden_b      : in std_logic := '1';
        rdaddress_a : in std_logic_vector(widthad-1 downto 0);
        rdaddress_b : in std_logic_vector(widthad-1 downto 0);
        outclock    : in std_logic := '0';
        outclocken  : in std_logic := '1';
        aclr        : in std_logic := '0';
        qa          : out std_logic_vector(width-1 downto 0);
        qb          : out std_logic_vector(width-1 downto 0) );
end component;


component scfifo
    generic (
        lpm_width               : natural;
        lpm_widthu              : natural;
        lpm_numwords            : natural;
        lpm_showahead           : string := "OFF";
        lpm_hint                : string := "USE_EAB=ON";
        intended_device_family  : string := "NON_STRATIX";
        almost_full_value       : natural := 0;
        almost_empty_value      : natural := 0;
        overflow_checking       : string := "ON";
        underflow_checking      : string := "ON";
        allow_rwcycle_when_full : string := "OFF";
        add_ram_output_register : string  := "OFF";
        use_eab                 : string := "ON";
        lpm_type                : string := "scfifo";
        maximum_depth           : natural := 0 );
    port (
        data         : in std_logic_vector(lpm_width-1 downto 0);
        clock        : in std_logic;
        wrreq        : in std_logic;
        rdreq        : in std_logic;
        aclr         : in std_logic := '0';
        sclr         : in std_logic := '0';
        full         : out std_logic;
        almost_full  : out std_logic;
        empty        : out std_logic;
        almost_empty : out std_logic;
        q            : out std_logic_vector(lpm_width-1 downto 0);
        usedw        : out std_logic_vector(lpm_widthu-1 downto 0) );
end component;

component dcfifo_mixed_widths
    generic (
        lpm_width               : natural;
        lpm_widthu              : natural;
        lpm_width_r             : natural := 0;
        lpm_widthu_r            : natural := 0;
        lpm_numwords            : natural;
        lpm_showahead           : string := "OFF";
        lpm_hint                : string := "USE_EAB=ON";
        overflow_checking       : string := "ON";
        underflow_checking      : string := "ON";
        delay_rdusedw           : natural := 1;
        delay_wrusedw           : natural := 1;
        rdsync_delaypipe        : natural := 0;
        wrsync_delaypipe        : natural := 0;
        use_eab                 : string := "ON";
        add_ram_output_register : string := "OFF";
        add_width               : natural := 1;
        clocks_are_synchronized : string := "FALSE";
        ram_block_type          : string := "AUTO";
        add_usedw_msb_bit       : string := "OFF";
        write_aclr_synch        : string := "OFF";
        lpm_type                : string := "dcfifo_mixed_widths";
        intended_device_family  : string := "NON_STRATIX" );
    port (
        data    : in std_logic_vector(lpm_width-1 downto 0);
        rdclk   : in std_logic;
        wrclk   : in std_logic;
        wrreq   : in std_logic;
        rdreq   : in std_logic;
        aclr    : in std_logic := '0';
        rdfull  : out std_logic;
        wrfull  : out std_logic;
        wrempty : out std_logic;
        rdempty : out std_logic;
        q       : out std_logic_vector(lpm_width_r-1 downto 0);
        rdusedw : out std_logic_vector(lpm_widthu_r-1 downto 0);
        wrusedw : out std_logic_vector(lpm_widthu-1 downto 0) );
end component;

component dcfifo
    generic (
        lpm_width               : natural;
        lpm_widthu              : natural;
        lpm_numwords            : natural;
        lpm_showahead           : string := "OFF";
        lpm_hint                : string := "USE_EAB=ON";
        overflow_checking       : string := "ON";
        underflow_checking      : string := "ON";
        delay_rdusedw           : natural := 1;
        delay_wrusedw           : natural := 1;
        rdsync_delaypipe        : natural := 0;
        wrsync_delaypipe        : natural := 0;
        use_eab                 : string := "ON";
        add_ram_output_register : string := "OFF";
        add_width               : natural := 1;
        clocks_are_synchronized : string := "FALSE";
        ram_block_type          : string := "AUTO";
        add_usedw_msb_bit       : string := "OFF";
        write_aclr_synch        : string := "OFF";
        lpm_type                : string := "dcfifo";
        intended_device_family  : string := "NON_STRATIX" );
    port (
        data    : in std_logic_vector(lpm_width-1 downto 0);
        rdclk   : in std_logic;
        wrclk   : in std_logic;
        wrreq   : in std_logic;
        rdreq   : in std_logic;
        aclr    : in std_logic := '0';
        rdfull  : out std_logic;
        wrfull  : out std_logic;
        wrempty : out std_logic;
        rdempty : out std_logic;
        q       : out std_logic_vector(lpm_width-1 downto 0);
        rdusedw : out std_logic_vector(lpm_widthu-1 downto 0);
        wrusedw : out std_logic_vector(lpm_widthu-1 downto 0) );
end component;

component altddio_in
    generic (
        width                  : positive; -- required parameter
        invert_input_clocks    : string := "OFF";
        intended_device_family : string := "Stratix";
        power_up_high          : string := "OFF";
        lpm_hint               : string := "UNUSED";
        lpm_type               : string := "altddio_in" );
    port (
        datain    : in std_logic_vector(width-1 downto 0);
        inclock   : in std_logic;
        inclocken : in std_logic := '1';
        aset      : in std_logic := '0';
        aclr      : in std_logic := '0';
        sset      : in std_logic := '0';
        sclr      : in std_logic := '0';
        dataout_h : out std_logic_vector(width-1 downto 0);
        dataout_l : out std_logic_vector(width-1 downto 0) );
end component;

component altddio_out
    generic (
        width                  : positive;  -- required parameter
        power_up_high          : string := "OFF";
        oe_reg                 : string := "UNUSED";
        extend_oe_disable      : string := "UNUSED";
        invert_output          : string := "OFF";
        intended_device_family : string := "Stratix";
        lpm_hint               : string := "UNUSED";
        lpm_type               : string := "altddio_out" );
    port (
        datain_h   : in std_logic_vector(width-1 downto 0);
        datain_l   : in std_logic_vector(width-1 downto 0);
        outclock   : in std_logic;
        outclocken : in std_logic := '1';
        aset       : in std_logic := '0';
        aclr       : in std_logic := '0';
        sset       : in std_logic := '0';
        sclr       : in std_logic := '0';
        hrbypass   : in std_logic := '0';
        oe         : in std_logic := '1';
        dataout    : out std_logic_vector(width-1 downto 0);
        oe_out    : out std_logic_vector(width-1 downto 0) );
end component;

component altddio_bidir
    generic(
        width                    : positive; -- required parameter
        power_up_high            : string := "OFF";
        oe_reg                   : string := "UNUSED";
        extend_oe_disable        : string := "UNUSED";
        implement_input_in_lcell : string := "UNUSED";
        invert_output            : string := "OFF";
        intended_device_family   : string := "Stratix";
        lpm_hint                 : string := "UNUSED";
        lpm_type                 : string := "altddio_bidir" );
    port (
        datain_h   : in std_logic_vector(width-1 downto 0);
        datain_l   : in std_logic_vector(width-1 downto 0);
        inclock    : in std_logic := '0';
        inclocken  : in std_logic := '1';
        outclock   : in std_logic;
        outclocken : in std_logic := '1';
        aset       : in std_logic := '0';
        aclr       : in std_logic := '0';
        sset       : in std_logic := '0';
        sclr       : in std_logic := '0';
        oe         : in std_logic := '1';
        dataout_h  : out std_logic_vector(width-1 downto 0);
        dataout_l  : out std_logic_vector(width-1 downto 0);
        combout    : out std_logic_vector(width-1 downto 0);
        oe_out     : out std_logic_vector(width-1 downto 0);
        dqsundelayedout : out std_logic_vector(width-1 downto 0);
        padio      : inout std_logic_vector(width-1 downto 0) );
end component;

component altshift_taps
    generic (
        number_of_taps    : integer := 4;
        tap_distance      : integer := 3;
        width             : integer := 8;
        power_up_state : string := "CLEARED";
        lpm_hint          : string := "UNUSED";
        lpm_type          : string := "altshift_taps";
        intended_device_family       : string := "Stratix" );
    port (
        shiftin  : in std_logic_vector (width-1 downto 0);
        clock    : in std_logic;
        clken    : in std_logic := '1';
        aclr     : in std_logic := '0';
        shiftout : out std_logic_vector (width-1 downto 0);
        taps     : out std_logic_vector ((width*number_of_taps)-1 downto 0));
end component;

component altmult_add
    generic (
        WIDTH_A                      : integer := 1;
        WIDTH_B                      : integer := 1;
        WIDTH_RESULT                 : integer := 1;
        NUMBER_OF_MULTIPLIERS        : integer := 1;

    -- A inputs
        INPUT_REGISTER_A0            : string := "CLOCK0";
        INPUT_ACLR_A0                : string := "ACLR3";
        INPUT_SOURCE_A0              : string := "DATAA";

        INPUT_REGISTER_A1            : string := "CLOCK0";
        INPUT_ACLR_A1                : string := "ACLR3";
        INPUT_SOURCE_A1              : string := "DATAA";

        INPUT_REGISTER_A2            : string := "CLOCK0";
        INPUT_ACLR_A2                : string := "ACLR3";
        INPUT_SOURCE_A2              : string := "DATAA";

        INPUT_REGISTER_A3            : string := "CLOCK0";
        INPUT_ACLR_A3                : string := "ACLR3";
        INPUT_SOURCE_A3              : string := "DATAA";

        PORT_SIGNA                   : string := "PORT_CONNECTIVITY";
        REPRESENTATION_A             : string := "UNSIGNED";
        SIGNED_REGISTER_A            : string := "CLOCK0";
        SIGNED_ACLR_A                : string := "ACLR3";
        SIGNED_PIPELINE_REGISTER_A   : string := "CLOCK0";
        SIGNED_PIPELINE_ACLR_A       : string := "ACLR3";

    -- B inputs
        INPUT_REGISTER_B0            : string := "CLOCK0";
        INPUT_ACLR_B0                : string := "ACLR3";
        INPUT_SOURCE_B0              : string := "DATAB";

        INPUT_REGISTER_B1            : string := "CLOCK0";
        INPUT_ACLR_B1                : string := "ACLR3";
        INPUT_SOURCE_B1              : string := "DATAB";

        INPUT_REGISTER_B2            : string := "CLOCK0";
        INPUT_ACLR_B2                : string := "ACLR3";
        INPUT_SOURCE_B2              : string := "DATAB";

        INPUT_REGISTER_B3            : string := "CLOCK0";
        INPUT_ACLR_B3                : string := "ACLR3";
        INPUT_SOURCE_B3              : string := "DATAB";

        PORT_SIGNB                   : string := "PORT_CONNECTIVITY";
        REPRESENTATION_B             : string := "UNSIGNED";
        SIGNED_REGISTER_B            : string := "CLOCK0";
        SIGNED_ACLR_B                : string := "ACLR3";
        SIGNED_PIPELINE_REGISTER_B   : string := "CLOCK0";
        SIGNED_PIPELINE_ACLR_B       : string := "ACLR3";

        MULTIPLIER_REGISTER0         : string := "CLOCK0";
        MULTIPLIER_ACLR0             : string := "ACLR3";
        MULTIPLIER_REGISTER1         : string := "CLOCK0";
        MULTIPLIER_ACLR1             : string := "ACLR3";
        MULTIPLIER_REGISTER2         : string := "CLOCK0";
        MULTIPLIER_ACLR2             : string := "ACLR3";
        MULTIPLIER_REGISTER3         : string := "CLOCK0";
        MULTIPLIER_ACLR3             : string := "ACLR3";

        PORT_ADDNSUB1                : string := "PORT_CONNECTIVITY";
        ADDNSUB_MULTIPLIER_REGISTER1 : string := "CLOCK0";
        ADDNSUB_MULTIPLIER_ACLR1     : string := "ACLR3";
        ADDNSUB_MULTIPLIER_PIPELINE_REGISTER1 : string := "CLOCK0";
        ADDNSUB_MULTIPLIER_PIPELINE_ACLR1 : string := "ACLR3";

        PORT_ADDNSUB3                : string := "PORT_CONNECTIVITY";
        ADDNSUB_MULTIPLIER_REGISTER3 : string := "CLOCK0";
        ADDNSUB_MULTIPLIER_ACLR3     : string := "ACLR3";
        ADDNSUB_MULTIPLIER_PIPELINE_REGISTER3: string := "CLOCK0";
        ADDNSUB_MULTIPLIER_PIPELINE_ACLR3 : string := "ACLR3";

        ADDNSUB1_ROUND_ACLR                   : string := "ACLR3";
        ADDNSUB1_ROUND_PIPELINE_ACLR          : string := "ACLR3";
        ADDNSUB1_ROUND_REGISTER               : string := "CLOCK0";
        ADDNSUB1_ROUND_PIPELINE_REGISTER      : string := "CLOCK0";
        ADDNSUB3_ROUND_ACLR                   : string := "ACLR3";
        ADDNSUB3_ROUND_PIPELINE_ACLR          : string := "ACLR3";
        ADDNSUB3_ROUND_REGISTER               : string := "CLOCK0";
        ADDNSUB3_ROUND_PIPELINE_REGISTER      : string := "CLOCK0";

        MULT01_ROUND_ACLR                     : string := "ACLR3";
        MULT01_ROUND_REGISTER                 : string := "CLOCK0";
        MULT01_SATURATION_REGISTER            : string := "CLOCK0";
        MULT01_SATURATION_ACLR                : string := "ACLR3";
        MULT23_ROUND_REGISTER                 : string := "CLOCK0";
        MULT23_ROUND_ACLR                     : string := "ACLR3";
        MULT23_SATURATION_REGISTER            : string := "CLOCK0";
        MULT23_SATURATION_ACLR                : string := "ACLR3";

        multiplier1_direction        : string := "ADD";
        multiplier3_direction        : string := "ADD";

        OUTPUT_REGISTER              : string := "CLOCK0";
        OUTPUT_ACLR                  : string := "ACLR0";

        -- StratixII parameters
        multiplier01_rounding    : string := "NO";
        multiplier01_saturation : string := "NO";
        multiplier23_rounding    : string := "NO";
        multiplier23_saturation : string := "NO";
        adder1_rounding         : string := "NO";
        adder3_rounding         : string := "NO";
        port_mult0_is_saturated : string := "UNUSED";
        port_mult1_is_saturated : string := "UNUSED";
        port_mult2_is_saturated : string := "UNUSED";
        port_mult3_is_saturated : string := "UNUSED";

        -- Stratix III parameters
        scanouta_register : string := "UNREGISTERED";
        scanouta_aclr     : string := "NONE";

        -- Rounding parameters
        output_rounding : string := "NO";
        output_round_type : string := "NEAREST_INTEGER";
        width_msb : integer := 17;
        output_round_register : string := "UNREGISTERED";
        output_round_aclr : string := "NONE";
        output_round_pipeline_register : string := "UNREGISTERED";
        output_round_pipeline_aclr : string := "NONE";

        chainout_rounding : string := "NO";
        chainout_round_register : string := "UNREGISTERED";
        chainout_round_aclr : string := "NONE";
        chainout_round_pipeline_register : string := "UNREGISTERED";
        chainout_round_pipeline_aclr : string := "NONE";
        chainout_round_output_register : string := "UNREGISTERED";
        chainout_round_output_aclr : string := "NONE";

        -- saturation parameters
        port_output_is_overflow : string := "PORT_UNUSED";
        port_chainout_sat_is_overflow : string := "PORT_UNUSED";
        output_saturation : string := "NO";
        output_saturate_type : string := "ASYMMETRIC";
        width_saturate_sign : integer := 1;
        output_saturate_register : string := "UNREGISTERED";
        output_saturate_aclr : string := "NONE";
        output_saturate_pipeline_register : string := "UNREGISTERED";
        output_saturate_pipeline_aclr : string := "NONE";

        chainout_saturation : string := "NO";
        chainout_saturate_register : string := "UNREGISTERED";
        chainout_saturate_aclr : string := "NONE";
        chainout_saturate_pipeline_register : string := "UNREGISTERED";
        chainout_saturate_pipeline_aclr : string := "NONE";
        chainout_saturate_output_register : string := "UNREGISTERED";
        chainout_saturate_output_aclr : string := "NONE";

        -- chainout parameters
        chainout_adder : string := "NO";
        chainout_register : string := "UNREGISTERED";
        chainout_aclr : string := "NONE";
        width_chainin : integer := 1;
        zero_chainout_output_register : string := "UNREGISTERED";
        zero_chainout_output_aclr : string := "NONE";

        -- rotate & shift parameters
        shift_mode : string := "NO";
        rotate_aclr : string := "NONE";
        rotate_register : string := "UNREGISTERED";
        rotate_pipeline_register : string := "UNREGISTERED";
        rotate_pipeline_aclr : string := "NONE";
        rotate_output_register : string := "UNREGISTERED";
        rotate_output_aclr : string := "NONE";
        shift_right_register : string := "UNREGISTERED";
        shift_right_aclr : string := "NONE";
        shift_right_pipeline_register : string := "UNREGISTERED";
        shift_right_pipeline_aclr : string := "NONE";
        shift_right_output_register : string := "UNREGISTERED";
        shift_right_output_aclr : string := "NONE";

        -- loopback parameters
        zero_loopback_register : string := "UNREGISTERED";
        zero_loopback_aclr : string := "NONE";
        zero_loopback_pipeline_register : string := "UNREGISTERED";
        zero_loopback_pipeline_aclr : string := "NONE";
        zero_loopback_output_register : string := "UNREGISTERED";
        zero_loopback_output_aclr : string := "NONE";

        -- accumulator parameters
        accum_sload_register : string := "UNREGISTERED";
        accum_sload_aclr : string := "NONE";
        accum_sload_pipeline_register : string := "UNREGISTERED";
        accum_sload_pipeline_aclr : string := "NONE";
        accum_direction : string := "ADD";
        accumulator : string := "NO";
		
		-- Stratix V parameters
		width_c : integer := 22;
		loadconst_value : integer := 64;
		preadder_mode : string := "SIMPLE";
		preadder_direction_0 : string := "ADD";
		preadder_direction_1 : string := "ADD";
		preadder_direction_2 : string := "ADD";
		preadder_direction_3 : string := "ADD";
		input_register_c0 : string := "CLOCK0";
		input_aclr_c0 : string := "ACLR0";
		coefsel0_register : string := "CLOCK0";
		coefsel1_register : string := "CLOCK0";
		coefsel2_register : string := "CLOCK0";
		coefsel3_register : string := "CLOCK0";
		coefsel0_aclr : string := "ACLR0";
		coefsel1_aclr : string := "ACLR0";
		coefsel2_aclr : string := "ACLR0";
		coefsel3_aclr : string := "ACLR0";
		systolic_delay1 : string := "UNREGISTERED";
		systolic_delay3 : string := "UNREGISTERED";
		systolic_aclr1 : string := "NONE";
		systolic_aclr3 : string := "NONE";
		coef0_0 : integer := 0;
		coef0_1 : integer := 0;
		coef0_2 : integer := 0;
		coef0_3 : integer := 0;
		coef0_4 : integer := 0;
		coef0_5 : integer := 0;
		coef0_6 : integer := 0;
		coef0_7 : integer := 0;
		coef1_0 : integer := 0;
		coef1_1 : integer := 0;
		coef1_2 : integer := 0;
		coef1_3 : integer := 0;
		coef1_4 : integer := 0;
		coef1_5 : integer := 0;
		coef1_6 : integer := 0;
		coef1_7 : integer := 0;
		coef2_0 : integer := 0;
		coef2_1 : integer := 0;
		coef2_2 : integer := 0;
		coef2_3 : integer := 0;
		coef2_4 : integer := 0;
		coef2_5 : integer := 0;
		coef2_6 : integer := 0;
		coef2_7 : integer := 0;
		coef3_0 : integer := 0;
		coef3_1 : integer := 0;
		coef3_2 : integer := 0;
		coef3_3 : integer := 0;
		coef3_4 : integer := 0;
		coef3_5 : integer := 0;
		coef3_6 : integer := 0;
		coef3_7 : integer := 0;
		width_coef : integer := 18;

        EXTRA_LATENCY                : integer :=0;
        DEDICATED_MULTIPLIER_CIRCUITRY:string  := "AUTO";
        DSP_BLOCK_BALANCING          : string := "AUTO";
        lpm_hint                     : string := "UNUSED";
        lpm_type                     : string := "altmult_add";
        intended_device_family       : string := "Stratix" );
    port (
        dataa : in std_logic_vector(NUMBER_OF_MULTIPLIERS * WIDTH_A -1 downto 0);
        datab : in std_logic_vector(NUMBER_OF_MULTIPLIERS * WIDTH_B -1 downto 0);

        scanina : in std_logic_vector(width_a -1 downto 0) := (others => '0');
        scaninb : in std_logic_vector(width_b -1 downto 0) := (others => '0');

        sourcea : in std_logic_vector(NUMBER_OF_MULTIPLIERS -1 downto 0) := (others => '0');
        sourceb : in std_logic_vector(NUMBER_OF_MULTIPLIERS -1 downto 0) := (others => '0');


        -- clock ports
        clock3     : in std_logic := '1';
        clock2     : in std_logic := '1';
        clock1     : in std_logic := '1';
        clock0     : in std_logic := '1';
        aclr3      : in std_logic := '0';
        aclr2      : in std_logic := '0';
        aclr1      : in std_logic := '0';
        aclr0      : in std_logic := '0';
        ena3       : in std_logic := '1';
        ena2       : in std_logic := '1';
        ena1       : in std_logic := '1';
        ena0       : in std_logic := '1';

        -- control signals
        signa      : in std_logic := 'Z';
        signb      : in std_logic := 'Z';
        addnsub1   : in std_logic := 'Z';
        addnsub3   : in std_logic := 'Z';

        -- StratixII only input ports
        mult01_round        : in std_logic := '0';
        mult23_round        : in std_logic := '0';
        mult01_saturation   : in std_logic := '0';
        mult23_saturation   : in std_logic := '0';
        addnsub1_round      : in std_logic := '0';
        addnsub3_round      : in std_logic := '0';

        -- Stratix III only input ports
        output_round : in std_logic := '0';
        chainout_round : in std_logic := '0';
        output_saturate : in std_logic := '0';
        chainout_saturate : in std_logic := '0';
        chainin : in std_logic_vector (width_chainin - 1 downto 0) := (others => '0');
        zero_chainout : in std_logic := '0';
        rotate : in std_logic := '0';
        shift_right : in std_logic := '0';
        zero_loopback : in std_logic := '0';
        accum_sload : in std_logic := '0';
		
		-- Stratix V only input ports
		coefsel0 : in std_logic_vector (2 downto 0) := (others => '0');
		coefsel1 : in std_logic_vector (2 downto 0) := (others => '0');
		coefsel2 : in std_logic_vector (2 downto 0) := (others => '0');
		coefsel3 : in std_logic_vector (2 downto 0) := (others => '0');
		datac : in std_logic_vector (width_c -1 downto 0) := (others => '0');

        -- output ports
        result     : out std_logic_vector(WIDTH_RESULT -1 downto 0);
        scanouta   : out std_logic_vector (WIDTH_A -1 downto 0);
        scanoutb   : out std_logic_vector (WIDTH_B -1 downto 0);

        -- StratixII only output ports
        mult0_is_saturated : out std_logic := '0';
        mult1_is_saturated : out std_logic := '0';
        mult2_is_saturated : out std_logic := '0';
        mult3_is_saturated : out std_logic := '0';

        -- Stratix III only output ports
        overflow : out std_logic := '0';
        chainout_sat_overflow : out std_logic := '0');
end component;

component altmult_accum
    generic (
        width_a                        : integer := 1;
        width_b                        : integer := 1;
		width_c                        : natural := 1;
        width_result                   : integer := 2;
        width_upper_data               : integer := 1;
        input_source_a                 : string  := "DATAA";
        input_source_b                 : string  := "DATAB";
        input_reg_a                    : string := "CLOCK0";
        input_aclr_a                   : string := "ACLR3";
        input_reg_b                    : string := "CLOCK0";
        input_aclr_b                   : string := "ACLR3";
        port_addnsub                   : string := "PORT_CONNECTIVITY";
        addnsub_reg                    : string := "CLOCK0";
        addnsub_aclr                   : string := "ACLR3";
        addnsub_pipeline_reg           : string := "CLOCK0";
        addnsub_pipeline_aclr          : string := "ACLR3";
        accum_direction                : string := "ADD";
        accum_sload_reg                : string := "CLOCK0";
        accum_sload_aclr               : string := "ACLR3";
        accum_sload_pipeline_reg       : string := "CLOCK0";
        accum_sload_pipeline_aclr      : string := "ACLR3";
        representation_a               : string := "UNSIGNED";
        port_signa                     : string := "PORT_CONNECTIVITY";
        sign_reg_a                     : string := "CLOCK0";
        sign_aclr_a                    : string := "ACLR3";
        sign_pipeline_reg_a            : string := "CLOCK0";
        sign_pipeline_aclr_a           : string := "ACLR3";
        representation_b               : string := "UNSIGNED";
        port_signb                     : string := "PORT_CONNECTIVITY";
        sign_reg_b                     : string := "CLOCK0";
        sign_aclr_b                    : string := "ACLR3";
        sign_pipeline_reg_b            : string := "CLOCK0";
        sign_pipeline_aclr_b           : string := "ACLR3";
        multiplier_reg                 : string := "CLOCK0";
        multiplier_aclr                : string := "ACLR3";
        output_reg                     : string := "CLOCK0";
        output_aclr                    : string := "ACLR0";
        extra_multiplier_latency       : integer := 0;
        extra_accumulator_latency      : integer := 0;
        dedicated_multiplier_circuitry : string  := "AUTO";
        dsp_block_balancing            : string := "AUTO";
        lpm_hint                       : string := "UNUSED";
        lpm_type                       : string  := "altmult_accum";
        intended_device_family         : string  := "Stratix";
        multiplier_rounding            : string  := "NO";
        multiplier_saturation          : string  := "NO";
        accumulator_rounding           : string  := "NO";
        accumulator_saturation         : string  := "NO";
        port_mult_is_saturated         : string  := "UNUSED";
        port_accum_is_saturated        : string  := "UNUSED";
        mult_round_aclr                : string  := "ACLR3";
        mult_round_reg                 : string  := "CLOCK0";
        mult_saturation_aclr           : string  := "ACLR3";
        mult_saturation_reg            : string  := "CLOCK0";
        accum_round_aclr               : string  := "ACLR3";
        accum_round_reg                : string  := "CLOCK3";
        accum_round_pipeline_aclr      : string  := "ACLR3";
        accum_round_pipeline_reg       : string  := "CLOCK0";
        accum_saturation_aclr          : string  := "ACLR3";
        accum_saturation_reg           : string  := "CLOCK0";
        accum_saturation_pipeline_aclr : string  := "ACLR3";
        accum_saturation_pipeline_reg  : string  := "CLOCK0";
        accum_sload_upper_data_aclr    : string  := "ACLR3";
        accum_sload_upper_data_pipeline_aclr : string  := "ACLR3";
        accum_sload_upper_data_pipeline_reg  : string  := "CLOCK0";
        accum_sload_upper_data_reg     : string  := "CLOCK0";
		-- StratixV parameters
		preadder_mode                  : string  := "SIMPLE";
		loadconst_value                : integer := 0;
		width_coef                     : integer := 0;

		loadconst_control_register     : string  := "CLOCK0";
		loadconst_control_aclr         : string  := "ACLR0";

		coefsel0_register              : string  := "CLOCK0";
		coefsel1_register              : string  := "CLOCK0";
		coefsel2_register              : string  := "CLOCK0";
		coefsel3_register              : string  := "CLOCK0";
		coefsel0_aclr                  : string  := "ACLR0";
		coefsel1_aclr                  : string  := "ACLR0";
		coefsel2_aclr                  : string  := "ACLR0";
		coefsel3_aclr                  : string  := "ACLR0";

		preadder_direction_0           : string  := "ADD";
		preadder_direction_1           : string  := "ADD";
		preadder_direction_2           : string  := "ADD";
		preadder_direction_3           : string  := "ADD";

		systolic_delay1                : string  := "UNREGISTERED";
		systolic_delay3                : string  := "UNREGISTERED";
		systolic_aclr1                 : string  := "NONE";
		systolic_aclr3                 : string  := "NONE";
		-- coefficient storage
		coef0_0                        : integer := 0;
		coef0_1                        : integer := 0;
		coef0_2                        : integer := 0;
		coef0_3                        : integer := 0;
		coef0_4                        : integer := 0;
		coef0_5                        : integer := 0;
		coef0_6                        : integer := 0;
		coef0_7                        : integer := 0;

		coef1_0                        : integer := 0;
		coef1_1                        : integer := 0;
		coef1_2                        : integer := 0;
		coef1_3                        : integer := 0;
		coef1_4                        : integer := 0;
		coef1_5                        : integer := 0;
		coef1_6                        : integer := 0;
		coef1_7                        : integer := 0;

		coef2_0                        : integer := 0;
		coef2_1                        : integer := 0;
		coef2_2                        : integer := 0;
		coef2_3                        : integer := 0;
		coef2_4                        : integer := 0;
		coef2_5                        : integer := 0;
		coef2_6                        : integer := 0;
		coef2_7                        : integer := 0;

		coef3_0                        : integer := 0;
		coef3_1                        : integer := 0;
		coef3_2                        : integer := 0;
		coef3_3                        : integer := 0;
		coef3_4                        : integer := 0;
		coef3_5                        : integer := 0;
		coef3_6                        : integer := 0;
		coef3_7                        : integer := 0 );

    port (
        dataa        : in std_logic_vector(width_a -1 downto 0) := (others => '0');
        datab        : in std_logic_vector(width_b -1 downto 0) := (others => '0');
        scanina      : in std_logic_vector(width_a -1 downto 0) := (others => 'Z');
        scaninb      : in std_logic_vector(width_b -1 downto 0) := (others => 'Z');
        accum_sload_upper_data : in std_logic_vector(width_result -1 downto width_result - width_upper_data) := (others => '0');
        sourcea      : in std_logic := '1';
        sourceb      : in std_logic := '1';
        -- control signals
        addnsub      : in std_logic := 'Z';
        accum_sload  : in std_logic := '0';
        signa        : in std_logic := 'Z';
        signb        : in std_logic := 'Z';
        -- clock ports
        clock0       : in std_logic := '1';
        clock1       : in std_logic := '1';
        clock2       : in std_logic := '1';
        clock3       : in std_logic := '1';
        ena0         : in std_logic := '1';
        ena1         : in std_logic := '1';
        ena2         : in std_logic := '1';
        ena3         : in std_logic := '1';
        aclr0        : in std_logic := '0';
        aclr1        : in std_logic := '0';
        aclr2        : in std_logic := '0';
        aclr3        : in std_logic := '0';
        -- round and saturation ports
        mult_round       : in std_logic := '0';
        mult_saturation  : in std_logic := '0';
        accum_round      : in std_logic := '0';
        accum_saturation : in std_logic := '0';
		-- StratixV only input ports
		coefsel0    :   in std_logic_vector(2 downto 0) := (others => '0');
		coefsel1    :   in std_logic_vector(2 downto 0) := (others => '0');
		coefsel2    :   in std_logic_vector(2 downto 0) := (others => '0');
		coefsel3    :   in std_logic_vector(2 downto 0) := (others => '0');
        -- output ports
        result       : out std_logic_vector(width_result -1 downto 0);
        overflow     : out std_logic;
        scanouta     : out std_logic_vector (width_a -1 downto 0);
        scanoutb     : out std_logic_vector (width_b -1 downto 0);
        mult_is_saturated  : out std_logic := '0';
        accum_is_saturated : out std_logic := '0' );
end component;

component altaccumulate
    generic (
        width_in           : integer:= 4;
        width_out          : integer:= 8;
        lpm_representation : string := "UNSIGNED";
        extra_latency      : integer:= 0;
        use_wys            : string := "ON";
        lpm_hint           : string := "UNUSED";
        lpm_type           : string := "altaccumulate" );

    port (
        -- Input ports
        cin       : in std_logic := 'Z';
        data      : in std_logic_vector(width_in -1 downto 0);  -- Required port
        add_sub   : in std_logic := '1';
        clock     : in std_logic;   -- Required port
        sload     : in std_logic := '0';
        clken     : in std_logic := '1';
        sign_data : in std_logic := '0';
        aclr      : in std_logic := '0';

        -- Output ports
        result    : out std_logic_vector(width_out -1 downto 0) := (others => '0');
        cout      : out std_logic := '0';
        overflow  : out std_logic := '0' );
end component;

component altsyncram
    generic (
        operation_mode                 : string := "BIDIR_DUAL_PORT";
        -- port a parameters
        width_a                        : integer := 1;
        widthad_a                      : integer := 1;
        numwords_a                     : integer := 0;
        -- registering parameters
        -- port a read parameters
        outdata_reg_a                  : string := "UNREGISTERED";
        -- clearing parameters
        address_aclr_a                 : string := "NONE";
        outdata_aclr_a                 : string := "NONE";
        -- clearing parameters
        -- port a write parameters
        indata_aclr_a                  : string := "NONE";
        wrcontrol_aclr_a               : string := "NONE";
        -- clear for the byte enable port reigsters which are clocked by clk0
        byteena_aclr_a                 : string := "NONE";
        -- width of the byte enable ports. if it is used, must be WIDTH_WRITE_A/8 or /9
        width_byteena_a                : integer := 1;
        -- port b parameters
        width_b                        : integer := 1;
        widthad_b                      : integer := 1;
        numwords_b                     : integer := 0;
        -- registering parameters
        -- port b read parameters
        rdcontrol_reg_b                : string := "CLOCK1";
        address_reg_b                  : string := "CLOCK1";
        outdata_reg_b                  : string := "UNREGISTERED";
        -- clearing parameters
        outdata_aclr_b                 : string := "NONE";
        rdcontrol_aclr_b               : string := "NONE";
        -- registering parameters
        -- port b write parameters
        indata_reg_b                   : string := "CLOCK1";
        wrcontrol_wraddress_reg_b      : string := "CLOCK1";
        -- registering parameter for the byte enable reister for port b
        byteena_reg_b                  : string := "CLOCK1";
        -- clearing parameters
        indata_aclr_b                  : string := "NONE";
        wrcontrol_aclr_b               : string := "NONE";
        address_aclr_b                 : string := "NONE";
        -- clear parameter for byte enable port register
        byteena_aclr_b                 : string := "NONE";
        -- StratixII only : to bypass clock enable or using clock enable
        clock_enable_input_a           : string := "NORMAL";
        clock_enable_output_a          : string := "NORMAL";
        clock_enable_input_b           : string := "NORMAL";
        clock_enable_output_b          : string := "NORMAL";
        -- width of the byte enable ports. if it is used, must be WIDTH_WRITE_A/8 or /9
        width_byteena_b                : integer := 1;
        -- clock enable setting for the core
        clock_enable_core_a            : string := "USE_INPUT_CLKEN";
        clock_enable_core_b            : string := "USE_INPUT_CLKEN";
        -- read-during-write-same-port setting
        read_during_write_mode_port_a  : string := "NEW_DATA_NO_NBE_READ";
        read_during_write_mode_port_b  : string := "NEW_DATA_NO_NBE_READ";
        -- ECC status ports setting
        enable_ecc                     : string := "FALSE";
	width_eccstatus                : integer := 3;
        -- global parameters
        -- width of a byte for byte enables
        byte_size                      : integer := 0;
        read_during_write_mode_mixed_ports: string := "DONT_CARE";
        -- ram block type choices are "AUTO", "M512", "M4K" and "MEGARAM"
        ram_block_type                 : string := "AUTO";
        -- determine whether LE support is turned on or off for altsyncram
        implement_in_les               : string := "OFF";
        -- determine whether RAM would be power up to uninitialized or not
        power_up_uninitialized         : string := "FALSE";

        sim_show_memory_data_in_port_b_layout :  string  := "OFF";

        -- general operation parameters
        init_file                      : string := "UNUSED";
        init_file_layout               : string := "UNUSED";
        maximum_depth                  : integer := 0;
        intended_device_family         : string := "Stratix";
        lpm_hint                       : string := "UNUSED";
        lpm_type                       : string := "altsyncram" );
    port (
        wren_a    : in std_logic := '0';
        wren_b    : in std_logic := '0';
        rden_a    : in std_logic := '1';
        rden_b    : in std_logic := '1';
        data_a    : in std_logic_vector(width_a - 1 downto 0):= (others => '1');
        data_b    : in std_logic_vector(width_b - 1 downto 0):= (others => '1');
        address_a : in std_logic_vector(widthad_a - 1 downto 0);
        address_b : in std_logic_vector(widthad_b - 1 downto 0) := (others => '1');

        clock0    : in std_logic := '1';
        clock1    : in std_logic := 'Z';
        clocken0  : in std_logic := '1';
        clocken1  : in std_logic := '1';
        clocken2  : in std_logic := '1';
        clocken3  : in std_logic := '1';
        aclr0     : in std_logic := '0';
        aclr1     : in std_logic := '0';
        byteena_a : in std_logic_vector( (width_byteena_a - 1) downto 0) := (others => '1');
        byteena_b : in std_logic_vector( (width_byteena_b - 1) downto 0) := (others => 'Z');

        addressstall_a : in std_logic := '0';
        addressstall_b : in std_logic := '0';

        q_a            : out std_logic_vector(width_a - 1 downto 0);
        q_b            : out std_logic_vector(width_b - 1 downto 0);

        eccstatus      : out std_logic_vector(width_eccstatus-1 downto 0) := (others => '0') );
end component;

component altpll
    generic (
        intended_device_family     : string := "Stratix" ;
        operation_mode             : string := "NORMAL" ;
        pll_type                   : string := "AUTO" ;
        qualify_conf_done          : string := "OFF" ;
        compensate_clock           : string := "CLK0" ;
        scan_chain                 : string := "LONG";
        primary_clock              : string := "inclk0" ;
        inclk0_input_frequency     : natural;   -- required parameter
        inclk1_input_frequency     : natural := 0;
        gate_lock_signal           : string := "NO";
        gate_lock_counter          : integer := 0;
        lock_high                  : natural := 1;
        lock_low                   : natural := 0;
        valid_lock_multiplier      : natural := 1;
        invalid_lock_multiplier    : natural := 5;
        switch_over_type           : string := "AUTO";
        switch_over_on_lossclk     : string := "OFF" ;
        switch_over_on_gated_lock  : string := "OFF" ;
        enable_switch_over_counter : string := "OFF";
        switch_over_counter        : natural := 0;
        feedback_source            : string := "EXTCLK0" ;
        bandwidth                  : natural := 0;
        bandwidth_type             : string := "UNUSED";
        spread_frequency           : natural := 0;
        down_spread                : string := "0.0";
        self_reset_on_gated_loss_lock : string := "OFF";
        self_reset_on_loss_lock      : string := "OFF";
        lock_window_ui             : string := "0.05";
        width_clock                : natural := 6;
        width_phasecounterselect   : natural := 4;
        charge_pump_current_bits   : natural := 9999;
        loop_filter_c_bits         : natural := 9999;
        loop_filter_r_bits         : natural := 9999;
        scan_chain_mif_file        : string  := "UNUSED";

        -- simulation-only parameters
        simulation_type            : string := "functional";
        source_is_pll              : string := "off";
        skip_vco                   : string := "off";

        -- internal clock specifications
        clk9_multiply_by           : natural := 1;
        clk8_multiply_by           : natural := 1;
        clk7_multiply_by           : natural := 1;
        clk6_multiply_by           : natural := 1;
        clk5_multiply_by           : natural := 1;
        clk4_multiply_by           : natural := 1;
        clk3_multiply_by           : natural := 1;
        clk2_multiply_by           : natural := 1;
        clk1_multiply_by           : natural := 1;
        clk0_multiply_by           : natural := 1;
        clk9_divide_by             : natural := 1;
        clk8_divide_by             : natural := 1;
        clk7_divide_by             : natural := 1;
        clk6_divide_by             : natural := 1;
        clk5_divide_by             : natural := 1;
        clk4_divide_by             : natural := 1;
        clk3_divide_by             : natural := 1;
        clk2_divide_by             : natural := 1;
        clk1_divide_by             : natural := 1;
        clk0_divide_by             : natural := 1;
        clk9_phase_shift           : string := "0";
        clk8_phase_shift           : string := "0";
        clk7_phase_shift           : string := "0";
        clk6_phase_shift           : string := "0";
        clk5_phase_shift           : string := "0";
        clk4_phase_shift           : string := "0";
        clk3_phase_shift           : string := "0";
        clk2_phase_shift           : string := "0";
        clk1_phase_shift           : string := "0";
        clk0_phase_shift           : string := "0";
        clk5_time_delay            : string := "0";
        clk4_time_delay            : string := "0";
        clk3_time_delay            : string := "0";
        clk2_time_delay            : string := "0";
        clk1_time_delay            : string := "0";
        clk0_time_delay            : string := "0";
        clk9_duty_cycle            : natural := 50;
        clk8_duty_cycle            : natural := 50;
        clk7_duty_cycle            : natural := 50;
        clk6_duty_cycle            : natural := 50;
        clk5_duty_cycle            : natural := 50;
        clk4_duty_cycle            : natural := 50;
        clk3_duty_cycle            : natural := 50;
        clk2_duty_cycle            : natural := 50;
        clk1_duty_cycle            : natural := 50;
        clk0_duty_cycle            : natural := 50;
        clk2_output_frequency      : natural := 0;
        clk1_output_frequency      : natural := 0;
        clk0_output_frequency      : natural := 0;
        clk9_use_even_counter_mode : string := "OFF";
        clk8_use_even_counter_mode : string := "OFF";
        clk7_use_even_counter_mode : string := "OFF";
        clk6_use_even_counter_mode : string := "OFF";
        clk5_use_even_counter_mode : string := "OFF";
        clk4_use_even_counter_mode : string := "OFF";
        clk3_use_even_counter_mode : string := "OFF";
        clk2_use_even_counter_mode : string := "OFF";
        clk1_use_even_counter_mode : string := "OFF";
        clk0_use_even_counter_mode : string := "OFF";
        clk9_use_even_counter_value  : string := "OFF";
        clk8_use_even_counter_value  : string := "OFF";
        clk7_use_even_counter_value  : string := "OFF";
        clk6_use_even_counter_value  : string := "OFF";
        clk5_use_even_counter_value  : string := "OFF";
        clk4_use_even_counter_value  : string := "OFF";
        clk3_use_even_counter_value  : string := "OFF";
        clk2_use_even_counter_value  : string := "OFF";
        clk1_use_even_counter_value  : string := "OFF";
        clk0_use_even_counter_value  : string := "OFF";

        -- external clock specifications
        extclk3_multiply_by        : natural := 1;
        extclk2_multiply_by        : natural := 1;
        extclk1_multiply_by        : natural := 1;
        extclk0_multiply_by        : natural := 1;
        extclk3_divide_by          : natural := 1;
        extclk2_divide_by          : natural := 1;
        extclk1_divide_by          : natural := 1;
        extclk0_divide_by          : natural := 1;
        extclk3_phase_shift        : string := "0";
        extclk2_phase_shift        : string := "0";
        extclk1_phase_shift        : string := "0";
        extclk0_phase_shift        : string := "0";
        extclk3_time_delay         : string := "0";
        extclk2_time_delay         : string := "0";
        extclk1_time_delay         : string := "0";
        extclk0_time_delay         : string := "0";
        extclk3_duty_cycle         : natural := 50;
        extclk2_duty_cycle         : natural := 50;
        extclk1_duty_cycle         : natural := 50;
        extclk0_duty_cycle         : natural := 50;
        vco_multiply_by            : integer := 0;
        vco_divide_by              : integer := 0;
        sclkout0_phase_shift       : string := "0";
        sclkout1_phase_shift       : string := "0";

        dpa_multiply_by            : integer := 0;
        dpa_divide_by              : integer := 0;
        dpa_divider                : integer := 0;

        -- advanced user parameters
        vco_min                    : natural := 0;
        vco_max                    : natural := 0;
        vco_center                 : natural := 0;
        pfd_min                    : natural := 0;
        pfd_max                    : natural := 0;
        m_initial                  : natural := 1;
        m                          : natural := 0; -- m must default to 0 to force altpll to calculate the internal parameters for itself
        n                          : natural := 1;
        m2                         : natural := 1;
        n2                         : natural := 1;
        ss                         : natural := 0;
        c0_high                    : natural := 1;
        c1_high                    : natural := 1;
        c2_high                    : natural := 1;
        c3_high                    : natural := 1;
        c4_high                    : natural := 1;
        c5_high                    : natural := 1;
        c6_high                    : natural := 1;
        c7_high                    : natural := 1;
        c8_high                    : natural := 1;
        c9_high                    : natural := 1;
        l0_high                    : natural := 1;
        l1_high                    : natural := 1;
        g0_high                    : natural := 1;
        g1_high                    : natural := 1;
        g2_high                    : natural := 1;
        g3_high                    : natural := 1;
        e0_high                    : natural := 1;
        e1_high                    : natural := 1;
        e2_high                    : natural := 1;
        e3_high                    : natural := 1;
        c0_low                     : natural := 1;
        c1_low                     : natural := 1;
        c2_low                     : natural := 1;
        c3_low                     : natural := 1;
        c4_low                     : natural := 1;
        c5_low                     : natural := 1;
        c6_low                     : natural := 1;
        c7_low                     : natural := 1;
        c8_low                     : natural := 1;
        c9_low                     : natural := 1;
        l0_low                     : natural := 1;
        l1_low                     : natural := 1;
        g0_low                     : natural := 1;
        g1_low                     : natural := 1;
        g2_low                     : natural := 1;
        g3_low                     : natural := 1;
        e0_low                     : natural := 1;
        e1_low                     : natural := 1;
        e2_low                     : natural := 1;
        e3_low                     : natural := 1;
        c0_initial                 : natural := 1;
        c1_initial                 : natural := 1;
        c2_initial                 : natural := 1;
        c3_initial                 : natural := 1;
        c4_initial                 : natural := 1;
        c5_initial                 : natural := 1;
        c6_initial                 : natural := 1;
        c7_initial                 : natural := 1;
        c8_initial                 : natural := 1;
        c9_initial                 : natural := 1;
        l0_initial                 : natural := 1;
        l1_initial                 : natural := 1;
        g0_initial                 : natural := 1;
        g1_initial                 : natural := 1;
        g2_initial                 : natural := 1;
        g3_initial                 : natural := 1;
        e0_initial                 : natural := 1;
        e1_initial                 : natural := 1;
        e2_initial                 : natural := 1;
        e3_initial                 : natural := 1;
        c0_mode                    : string := "bypass" ;
        c1_mode                    : string := "bypass" ;
        c2_mode                    : string := "bypass" ;
        c3_mode                    : string := "bypass" ;
        c4_mode                    : string := "bypass" ;
        c5_mode                    : string := "bypass" ;
        c6_mode                    : string := "bypass" ;
        c7_mode                    : string := "bypass" ;
        c8_mode                    : string := "bypass" ;
        c9_mode                    : string := "bypass" ;
        l0_mode                    : string := "bypass" ;
        l1_mode                    : string := "bypass" ;
        g0_mode                    : string := "bypass" ;
        g1_mode                    : string := "bypass" ;
        g2_mode                    : string := "bypass" ;
        g3_mode                    : string := "bypass" ;
        e0_mode                    : string := "bypass" ;
        e1_mode                    : string := "bypass" ;
        e2_mode                    : string := "bypass" ;
        e3_mode                    : string := "bypass" ;
        c0_ph                      : natural := 0;
        c1_ph                      : natural := 0;
        c2_ph                      : natural := 0;
        c3_ph                      : natural := 0;
        c4_ph                      : natural := 0;
        c5_ph                      : natural := 0;
        c6_ph                      : natural := 0;
        c7_ph                      : natural := 0;
        c8_ph                      : natural := 0;
        c9_ph                      : natural := 0;
        l0_ph                      : natural := 0;
        l1_ph                      : natural := 0;
        g0_ph                      : natural := 0;
        g1_ph                      : natural := 0;
        g2_ph                      : natural := 0;
        g3_ph                      : natural := 0;
        e0_ph                      : natural := 0;
        e1_ph                      : natural := 0;
        e2_ph                      : natural := 0;
        e3_ph                      : natural := 0;
        m_ph                       : natural := 0;
        l0_time_delay              : natural := 0;
        l1_time_delay              : natural := 0;
        g0_time_delay              : natural := 0;
        g1_time_delay              : natural := 0;
        g2_time_delay              : natural := 0;
        g3_time_delay              : natural := 0;
        e0_time_delay              : natural := 0;
        e1_time_delay              : natural := 0;
        e2_time_delay              : natural := 0;
        e3_time_delay              : natural := 0;
        m_time_delay               : natural := 0;
        n_time_delay               : natural := 0;
        c1_use_casc_in             : string := "off";
        c2_use_casc_in             : string := "off";
        c3_use_casc_in             : string := "off";
        c4_use_casc_in             : string := "off";
        c5_use_casc_in             : string := "off";
        c6_use_casc_in             : string := "off";
        c7_use_casc_in             : string := "off";
        c8_use_casc_in             : string := "off";
        c9_use_casc_in             : string := "off";
        m_test_source              : integer := 5;
        c0_test_source             : integer := 5;
        c1_test_source             : integer := 5;
        c2_test_source             : integer := 5;
        c3_test_source             : integer := 5;
        c4_test_source             : integer := 5;
        c5_test_source             : integer := 5;
        c6_test_source             : integer := 5;
        c7_test_source             : integer := 5;
        c8_test_source             : integer := 5;
        c9_test_source             : integer := 5;
        extclk3_counter            : string := "e3" ;
        extclk2_counter            : string := "e2" ;
        extclk1_counter            : string := "e1" ;
        extclk0_counter            : string := "e0" ;
        clk9_counter               : string := "c9" ;
        clk8_counter               : string := "c8" ;
        clk7_counter               : string := "c7" ;
        clk6_counter               : string := "c6" ;
        clk5_counter               : string := "l1" ;
        clk4_counter               : string := "l0" ;
        clk3_counter               : string := "g3" ;
        clk2_counter               : string := "g2" ;
        clk1_counter               : string := "g1" ;
        clk0_counter               : string := "g0" ;
        enable0_counter            : string := "l0";
        enable1_counter            : string := "l0";
        charge_pump_current        : natural := 2;
        loop_filter_r              : string := " 1.000000";
        loop_filter_c              : natural := 5;
        vco_post_scale             : natural := 0;
        vco_frequency_control      : string := "AUTO";
        vco_phase_shift_step       : natural := 0;
        lpm_hint                   : string := "UNUSED";
        lpm_type                   : string := "altpll";
        port_clkena0 : string := "PORT_CONNECTIVITY";
        port_clkena1 : string := "PORT_CONNECTIVITY";
        port_clkena2 : string := "PORT_CONNECTIVITY";
        port_clkena3 : string := "PORT_CONNECTIVITY";
        port_clkena4 : string := "PORT_CONNECTIVITY";
        port_clkena5 : string := "PORT_CONNECTIVITY";
        port_extclkena0 : string := "PORT_CONNECTIVITY";
        port_extclkena1 : string := "PORT_CONNECTIVITY";
        port_extclkena2 : string := "PORT_CONNECTIVITY";
        port_extclkena3 : string := "PORT_CONNECTIVITY";
        port_extclk0 : string := "PORT_CONNECTIVITY";
        port_extclk1 : string := "PORT_CONNECTIVITY";
        port_extclk2 : string := "PORT_CONNECTIVITY";
        port_extclk3 : string := "PORT_CONNECTIVITY";
        port_clkbad0 : string := "PORT_CONNECTIVITY";
        port_clkbad1 : string := "PORT_CONNECTIVITY";
        port_clk0 : string := "PORT_CONNECTIVITY";
        port_clk1 : string := "PORT_CONNECTIVITY";
        port_clk2 : string := "PORT_CONNECTIVITY";
        port_clk3 : string := "PORT_CONNECTIVITY";
        port_clk4 : string := "PORT_CONNECTIVITY";
        port_clk5 : string := "PORT_CONNECTIVITY";
        port_clk6 : string := "PORT_CONNECTIVITY";
        port_clk7 : string := "PORT_CONNECTIVITY";
        port_clk8 : string := "PORT_CONNECTIVITY";
        port_clk9 : string := "PORT_CONNECTIVITY";
        port_scandata : string := "PORT_CONNECTIVITY";
        port_scandataout : string := "PORT_CONNECTIVITY";
        port_scandone : string := "PORT_CONNECTIVITY";
        port_sclkout1 : string := "PORT_CONNECTIVITY";
        port_sclkout0 : string := "PORT_CONNECTIVITY";
        port_activeclock : string := "PORT_CONNECTIVITY";
        port_clkloss : string := "PORT_CONNECTIVITY";
        port_inclk1 : string := "PORT_CONNECTIVITY";
        port_inclk0 : string := "PORT_CONNECTIVITY";
        port_fbin : string := "PORT_CONNECTIVITY";
        port_fbout : string := "PORT_CONNECTIVITY";
        port_pllena : string := "PORT_CONNECTIVITY";
        port_clkswitch : string := "PORT_CONNECTIVITY";
        port_areset : string := "PORT_CONNECTIVITY";
        port_pfdena : string := "PORT_CONNECTIVITY";
        port_scanclk : string := "PORT_CONNECTIVITY";
        port_scanaclr : string := "PORT_CONNECTIVITY";
        port_scanread : string := "PORT_CONNECTIVITY";
        port_scanwrite : string := "PORT_CONNECTIVITY";
        port_enable0 : string := "PORT_CONNECTIVITY";
        port_enable1 : string := "PORT_CONNECTIVITY";
        port_locked : string := "PORT_CONNECTIVITY";
        port_configupdate : string := "PORT_CONNECTIVITY";
        port_phasecounterselect : string := "PORT_CONNECTIVITY";
        port_phasedone : string := "PORT_CONNECTIVITY";
        port_phasestep : string := "PORT_CONNECTIVITY";
        port_phaseupdown : string := "PORT_CONNECTIVITY";
        port_vcooverrange : string := "PORT_CONNECTIVITY";
        port_vcounderrange : string := "PORT_CONNECTIVITY";
        port_scanclkena : string := "PORT_CONNECTIVITY";
        using_fbmimicbidir_port : string := "ON";
        sim_gate_lock_device_behavior : string := "OFF" );
    port (
        inclk       : in std_logic_vector(1 downto 0) := (others => '0');
        fbin        : in std_logic := '0';
        pllena      : in std_logic := '1';
        clkswitch   : in std_logic := '0';
        areset      : in std_logic := '0';
        pfdena      : in std_logic := '1';
        clkena      : in std_logic_vector(5 downto 0) := (others => '1');
        extclkena   : in std_logic_vector(3 downto 0) := (others => '1');
        scanclk     : in std_logic := '0';
        scanclkena  : in std_logic := '1';
        scanaclr    : in std_logic := '0';
        scanread    : in std_logic := '0';
        scanwrite   : in std_logic := '0';
        scandata    : in std_logic := '0';
        phasecounterselect : in std_logic_vector(width_phasecounterselect-1 downto 0) := (others => '0');
        phaseupdown  : in std_logic := '0';
        phasestep    : in std_logic := '0';
        configupdate : in std_logic := '0';
        fbmimicbidir : inout std_logic := '1';
        clk         : out std_logic_vector(width_clock-1 downto 0);
        extclk      : out std_logic_vector(3 downto 0);
        clkbad      : out std_logic_vector(1 downto 0);
        enable0     : out std_logic;
        enable1     : out std_logic;
        activeclock : out std_logic;
        clkloss     : out std_logic;
        locked      : out std_logic;
        scandataout : out std_logic;
        scandone    : out std_logic;
        sclkout0    : out std_logic;
        sclkout1    : out std_logic;
        phasedone     : out std_logic;
        vcooverrange  : out std_logic;
        vcounderrange : out std_logic;
        fbout         : out std_logic;
        fref          : out std_logic;
        icdrclk       : out std_logic );
end component;

component altfp_mult
    generic (
        width_exp               : integer := 11;
        width_man               : integer := 31;
        dedicated_multiplier_circuitry  : string := "AUTO";
        reduced_functionality           : string := "NO";
        pipeline                        : natural := 5;
        denormal_support                : string := "YES";
        exception_handling              : string := "YES";
        lpm_hint                        : string := "UNUSED";
        lpm_type                        : string := "altfp_mult" );
    port (
        clock       : in std_logic;
        clk_en      : in std_logic := '1';
        aclr        : in std_logic := '0';
        dataa       : in std_logic_vector(WIDTH_EXP + WIDTH_MAN downto 0) ;
        datab       : in std_logic_vector(WIDTH_EXP + WIDTH_MAN downto 0) ;
        result      : out std_logic_vector(WIDTH_EXP + WIDTH_MAN downto 0) ;
        overflow    : out std_logic ;
        underflow   : out std_logic ;
        zero        : out std_logic ;
        denormal    : out std_logic ;
        indefinite  : out std_logic ;
        nan         : out std_logic );
end component;

component altsqrt
    generic (
        q_port_width  : integer := 1;
        r_port_width  : integer := 1;
        width       : integer := 1;
        pipeline    : integer := 0;
        lpm_hint    : string := "UNUSED";
        lpm_type    : string := "altsqrt" );
    port (
        radical     : in std_logic_vector(width - 1 downto 0) ;
        clk         : in std_logic := '1';
        ena         : in std_logic := '1';
        aclr        : in std_logic := '0';
        q           : out std_logic_vector( q_port_width - 1 downto 0) ;
        remainder   : out std_logic_vector( r_port_width - 1 downto 0) );
end component;

component parallel_add
    generic (
        width             : natural := 4;
        size              : natural := 2;
        widthr            : natural := 4;
        shift             : natural := 0;
        msw_subtract      : string  := "NO";
        representation    : string  := "UNSIGNED";
        pipeline          : natural := 0;
        result_alignment  : string  := "LSB";
        lpm_hint          : string  := "UNUSED";
        lpm_type          : string  := "parallel_add" );
    port (
        data   : in altera_mf_logic_2D(size - 1 downto 0, width - 1 downto 0);
        clock  : in std_logic := '1';
        aclr   : in std_logic := '0';
        clken  : in std_logic := '1';
        result : out std_logic_vector(widthr - 1 downto 0) );
end component;

component a_graycounter
    generic (
        width     : natural;
        pvalue    : natural;
        lpm_hint  : string := "UNUSED";
        lpm_type  : string := "a_graycounter" );
    port (
        clock   : in std_logic;
        clk_en  : in std_logic := '1';
        cnt_en  : in std_logic := '1';
        updown  : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr    : in std_logic := '0';
        qbin    : out std_logic_vector(width-1 downto 0);
        q       : out std_logic_vector(width-1 downto 0) );
end component;

component altsquare
    generic (
        data_width     :    natural;
        pipeline       :    natural;
        representation :    string := "UNSIGNED";
        result_alignment :  string := "LSB";
        result_width   :    natural;
        lpm_hint       :    string := "UNUSED";
        lpm_type       :    string := "altsquare"
    );
    port(
        aclr    :   in std_logic := '0';
        clock   :   in std_logic := '1';
        data    :   in std_logic_vector(data_width-1 downto 0);
        ena     :   in std_logic := '1';
        result  :   out std_logic_vector(result_width-1 downto 0)
    );
end component;

component sld_virtual_jtag
    generic (
        lpm_type                : string;
        lpm_hint                : string;
        sld_auto_instance_index : string;
        sld_instance_index      : integer;
        sld_ir_width            : integer;
        sld_sim_n_scan          : integer;
        sld_sim_total_length    : integer;
        sld_sim_action          : string);
    port (
        tdo   : in  std_logic := '0';
        ir_out : in  std_logic_vector(sld_ir_width - 1 downto 0) := (others => '0');
        tck                : out std_logic;
        tdi                : out std_logic;
        ir_in              : out std_logic_vector(sld_ir_width - 1 downto 0);
        virtual_state_cdr  : out std_logic;
        virtual_state_sdr  : out std_logic;
        virtual_state_e1dr : out std_logic;
        virtual_state_pdr  : out std_logic;
        virtual_state_e2dr : out std_logic;
        virtual_state_udr  : out std_logic;
        virtual_state_cir  : out std_logic;
        virtual_state_uir  : out std_logic;
        jtag_state_tlr     : out std_logic;
        jtag_state_rti     : out std_logic;
        jtag_state_sdrs    : out std_logic;
        jtag_state_cdr     : out std_logic;
        jtag_state_sdr     : out std_logic;
        jtag_state_e1dr    : out std_logic;
        jtag_state_pdr     : out std_logic;
        jtag_state_e2dr    : out std_logic;
        jtag_state_udr     : out std_logic;
        jtag_state_sirs    : out std_logic;
        jtag_state_cir     : out std_logic;
        jtag_state_sir     : out std_logic;
        jtag_state_e1ir    : out std_logic;
        jtag_state_pir     : out std_logic;
        jtag_state_e2ir    : out std_logic;
        jtag_state_uir     : out std_logic;
        tms                : out std_logic);
end component;


component altera_std_synchronizer
    generic
    (
            depth : integer := 3
    );

    port
    (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            din     : in  std_logic;
            dout    : out std_logic
    );
end component;

component altera_std_synchronizer_bundle
    generic
    (
            depth : integer := 3;
            width : integer := 1
    );

    port
    (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            din     : in  std_logic_vector(width-1 downto 0);
            dout    : out std_logic_vector(width-1 downto 0)
    );
end component;

component alt_cal
        generic (
            number_of_channels          :  integer := 1;
            channel_address_width       :  integer := 1;
            sim_model_mode              :  string  := "TRUE";
            lpm_hint                    :  string  := "UNUSED";
            lpm_type                    :  string  := "alt_cal"
        );
        PORT
        (
            busy   :       OUT  STD_LOGIC;
            cal_error      :       OUT  STD_LOGIC_VECTOR (0 DOWNTO 0);
            clock  :       IN  STD_LOGIC;
            dprio_addr     :       OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
            dprio_busy     :       IN  STD_LOGIC;
            dprio_datain   :       IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
            dprio_dataout  :       OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
            dprio_rden     :       OUT  STD_LOGIC;
            dprio_wren     :       OUT  STD_LOGIC;
            quad_addr      :       OUT  STD_LOGIC_VECTOR (6 DOWNTO 0);
            remap_addr     :       IN  STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '0');
            reset  :       IN  STD_LOGIC := '0';
            retain_addr    :       OUT  STD_LOGIC_VECTOR (0 DOWNTO 0);
            start  :       IN  STD_LOGIC := '0';
            testbuses      :       IN  STD_LOGIC_VECTOR (4 * number_of_channels - 1 DOWNTO 0) := (OTHERS => '0')
        );
end component;

component alt_cal_c3gxb
        generic (
            number_of_channels          :  integer := 1;
            channel_address_width       :  integer := 1;
            sim_model_mode              :  string  := "TRUE";
            lpm_hint                    :  string  := "UNUSED";
            lpm_type                    :  string  := "alt_cal_c3gxb"
        );
        PORT
        (
            busy   :       OUT  STD_LOGIC;
            cal_error      :       OUT  STD_LOGIC_VECTOR (0 DOWNTO 0);
            clock  :       IN  STD_LOGIC;
            dprio_addr     :       OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
            dprio_busy     :       IN  STD_LOGIC;
            dprio_datain   :       IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
            dprio_dataout  :       OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
            dprio_rden     :       OUT  STD_LOGIC;
            dprio_wren     :       OUT  STD_LOGIC;
            quad_addr      :       OUT  STD_LOGIC_VECTOR (6 DOWNTO 0);
            remap_addr     :       IN  STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '0');
            reset  :       IN  STD_LOGIC := '0';
            retain_addr    :       OUT  STD_LOGIC_VECTOR (0 DOWNTO 0);
            start  :       IN  STD_LOGIC := '0';
            testbuses      :       IN  STD_LOGIC_VECTOR (number_of_channels - 1 DOWNTO 0) := (OTHERS => '0')
        );
end component;

component  alt_cal_mm 
        generic (
                       number_of_channels          :  integer := 1;
            channel_address_width       :  integer := 1;
            sim_model_mode              :  string  := "TRUE";
   	    CAL_PD_WR			:  string  := "00101";
	    CAL_RX_RD			:  string  := "00110";
	    CAL_RX_WR			:  string  := "00111";
	    CH_ADV			:  string  := "01100";
	    CH_WAIT			:  string  := "00001";
	    DPRIO_READ			:  string  := "01110";
	    DPRIO_WAIT			:  string  := "01000";
	    DPRIO_WRITE			:  string  := "01111";
	    IDLE			:  string  := "00000";
	    KICK_DELAY_OC		:  integer  := 10010;
	    KICK_PAUSE			:  integer  := 10001;
	    KICK_START_RD		:  string  := "01101";
	    KICK_START_WR		:  integer  := 10000;
	    OFFSETS_PDEN_RD		:  string  := "00011";
	    OFFSETS_PDEN_WR		:  string  := "00100";
	    sample_length		:  string  := "01100100";
	    SAMPLE_TB			:  string  := "01001";
	    TEST_INPUT			:  string  := "01010";
	    TESTBUS_SET			:  string  := "00010";
            lpm_hint                    :  string  := "UNUSED";
            lpm_type                    :  string  := "alt_cal_mm"
        );
        PORT 
        ( 
                busy   :       OUT  STD_LOGIC;
                cal_error      :       OUT  STD_LOGIC_VECTOR (number_of_channels - 1 DOWNTO 0);
                clock  :       IN  STD_LOGIC;
                dprio_addr     :       OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
                dprio_busy     :       IN  STD_LOGIC;
                dprio_datain   :       IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
                dprio_dataout  :       OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
                dprio_rden     :       OUT  STD_LOGIC;
                dprio_wren     :       OUT  STD_LOGIC;
                quad_addr      :       OUT  STD_LOGIC_VECTOR (8 DOWNTO 0);
                remap_addr     :       IN  STD_LOGIC_VECTOR (11 DOWNTO 0) := (OTHERS => '0');
                reset  :       IN  STD_LOGIC := '0';
                retain_addr    :       OUT  STD_LOGIC;
                start  :       IN  STD_LOGIC := '0';
                transceiver_init  :       IN  STD_LOGIC := '0';
                testbuses      :       IN  STD_LOGIC_VECTOR (4 * number_of_channels - 1 DOWNTO 0) := (OTHERS => '0')
        ); 
END component;







    constant    ELA_STATUS_BITS    :    natural    :=    4;
    constant    N_ELA_INSTRS    :    natural    :=    8;
    constant    SLD_IR_BITS    :    natural    :=    N_ELA_INSTRS;

component    sld_signaltap
    generic    (
        SLD_CURRENT_RESOURCE_WIDTH    :    natural    :=    0;
        SLD_INVERSION_MASK    :    std_logic_vector    :=    "0";
        SLD_POWER_UP_TRIGGER    :    natural    :=    0;
        SLD_ADVANCED_TRIGGER_6    :    string    :=    "NONE";
        SLD_ADVANCED_TRIGGER_9    :    string    :=    "NONE";
        SLD_ADVANCED_TRIGGER_7    :    string    :=    "NONE";
        SLD_STORAGE_QUALIFIER_ADVANCED_CONDITION_ENTITY    :    string    :=    "basic";
        SLD_STORAGE_QUALIFIER_GAP_RECORD    :    natural    :=    0;
        SLD_INCREMENTAL_ROUTING    :    natural    :=    0;
        SLD_STORAGE_QUALIFIER_PIPELINE    :    natural    :=    0;
        SLD_TRIGGER_IN_ENABLED    :    natural    :=    0;
        SLD_STATE_BITS    :    natural    :=    11;
        SLD_STATE_FLOW_USE_GENERATED    :    natural    :=    0;
        SLD_INVERSION_MASK_LENGTH    :    integer    :=    1;
        SLD_DATA_BITS    :    natural    :=    1;
        SLD_BUFFER_FULL_STOP    :    natural    :=    1;
        SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH    :    natural    :=    0;
        SLD_ATTRIBUTE_MEM_MODE    :    string    :=    "OFF";
        SLD_STORAGE_QUALIFIER_MODE    :    string    :=    "OFF";
        SLD_STATE_FLOW_MGR_ENTITY    :    string    :=    "state_flow_mgr_entity.vhd";
        SLD_NODE_CRC_LOWORD    :    natural    :=    50132;
        SLD_ADVANCED_TRIGGER_5    :    string    :=    "NONE";
        SLD_TRIGGER_BITS    :    natural    :=    1;
        SLD_STORAGE_QUALIFIER_BITS    :    natural    :=    1;
        SLD_ADVANCED_TRIGGER_10    :    string    :=    "NONE";
        SLD_MEM_ADDRESS_BITS    :    natural    :=    7;
        SLD_ADVANCED_TRIGGER_ENTITY    :    string    :=    "basic";
        SLD_ADVANCED_TRIGGER_4    :    string    :=    "NONE";
        SLD_TRIGGER_LEVEL    :    natural    :=    10;
        SLD_ADVANCED_TRIGGER_8    :    string    :=    "NONE";
        SLD_RAM_BLOCK_TYPE    :    string    :=    "AUTO";
        SLD_ADVANCED_TRIGGER_2    :    string    :=    "NONE";
        SLD_ADVANCED_TRIGGER_1    :    string    :=    "NONE";
        SLD_DATA_BIT_CNTR_BITS    :    natural    :=    4;
        lpm_type    :    string    :=    "sld_signaltap";
        SLD_NODE_CRC_BITS    :    natural    :=    32;
        SLD_SAMPLE_DEPTH    :    natural    :=    16;
        SLD_ENABLE_ADVANCED_TRIGGER    :    natural    :=    0;
        SLD_SEGMENT_SIZE    :    natural    :=    0;
        SLD_NODE_INFO    :    natural    :=    0;
        SLD_STORAGE_QUALIFIER_ENABLE_ADVANCED_CONDITION    :    natural    :=    0;
        SLD_NODE_CRC_HIWORD    :    natural    :=    41394;
        SLD_TRIGGER_LEVEL_PIPELINE    :    natural    :=    1;
        SLD_ADVANCED_TRIGGER_3    :    string    :=    "NONE"
    );
    port    (
        jtag_state_sdr    :    in    std_logic    :=    '0';
        ir_out    :    out    std_logic_vector(SLD_IR_BITS-1 downto 0);
        jtag_state_cdr    :    in    std_logic    :=    '0';
        ir_in    :    in    std_logic_vector(SLD_IR_BITS-1 downto 0)   :=   (others => '0');
        tdi    :    in    std_logic    :=    '0';
        acq_trigger_out    :    out    std_logic_vector(SLD_TRIGGER_BITS-1 downto 0);
        jtag_state_uir    :    in    std_logic    :=    '0';
        acq_trigger_in    :    in    std_logic_vector(SLD_TRIGGER_BITS-1 downto 0)   :=   (others => '0');
        trigger_out    :    out    std_logic;
        storage_enable    :    in    std_logic    :=    '0';
        acq_data_out    :    out    std_logic_vector(SLD_DATA_BITS-1 downto 0);
        acq_data_in    :    in    std_logic_vector(SLD_DATA_BITS-1 downto 0)   :=   (others => '0');
        acq_storage_qualifier_in    :    in    std_logic_vector(SLD_STORAGE_QUALIFIER_BITS-1 downto 0)   :=   (others => '0');
        jtag_state_udr    :    in    std_logic    :=    '0';
        tdo    :    out    std_logic;
        crc    :    in    std_logic_vector(SLD_NODE_CRC_BITS-1 downto 0)   :=   (others => '0');
        jtag_state_e1dr    :    in    std_logic    :=    '0';
        raw_tck    :    in    std_logic    :=    '0';
        usr1    :    in    std_logic    :=    '0';
        acq_clk    :    in    std_logic;
        shift    :    in    std_logic    :=    '0';
        ena    :    in    std_logic    :=    '0';
        clr    :    in    std_logic    :=    '0';
        trigger_in    :    in    std_logic    :=    '0';
        update    :    in    std_logic    :=    '0';
        rti    :    in    std_logic    :=    '0'
    );
end component; --sld_signaltap


component    altstratixii_oct
    generic    (
        lpm_type    :    string    :=    "altstratixii_oct"
    );
    port    (
        terminationenable    :    in    std_logic;
        terminationclock    :    in    std_logic;
        rdn    :    in    std_logic;
        rup    :    in    std_logic
    );
end component; --altstratixii_oct

    constant    PFL_QUAD_IO_FLASH_IR_BITS    :    NATURAL    :=    8;
    constant    PFL_CFI_FLASH_IR_BITS    :    NATURAL    :=    5;
    constant    PFL_NAND_FLASH_IR_BITS    :    NATURAL    :=    4;
    constant    N_FLASH_BITS    :    NATURAL    :=    4;

component    altparallel_flash_loader
    generic    (
        EXTRA_ADDR_BYTE    :    NATURAL    :=    0;
        FEATURES_CFG    :    NATURAL    :=    1;
        PAGE_CLK_DIVISOR    :    NATURAL    :=    1;
        BURST_MODE_SPANSION    :    NATURAL    :=    0;
        ENHANCED_FLASH_PROGRAMMING    :    NATURAL    :=    0;
        FLASH_ECC_CHECKBOX    :    NATURAL    :=    0;
        FLASH_NRESET_COUNTER    :    NATURAL    :=    1;
        PAGE_MODE    :    NATURAL    :=    0;
        NRB_ADDR    :    NATURAL    :=    65667072;
        BURST_MODE    :    NATURAL    :=    0;
        SAFE_MODE_REVERT_ADDR    :    NATURAL    :=    0;
        US_UNIT_COUNTER    :    NATURAL    :=    1;
        FIFO_SIZE    :    NATURAL    :=    16;
        CONF_DATA_WIDTH    :    NATURAL    :=    1;
        CONF_WAIT_TIMER_WIDTH    :    NATURAL    :=    14;
        NFLASH_MFC    :    STRING    :=    "NUMONYX";
        OPTION_BITS_START_ADDRESS    :    NATURAL    :=    0;
        SAFE_MODE_RETRY    :    NATURAL    :=    1;
        DCLK_DIVISOR    :    NATURAL    :=    1;
        FLASH_TYPE    :    STRING    :=    "CFI_FLASH";
        N_FLASH    :    NATURAL    :=    1;
        TRISTATE_CHECKBOX    :    NATURAL    :=    0;
        QFLASH_MFC    :    STRING    :=    "ALTERA";
        FEATURES_PGM    :    NATURAL    :=    1;
        DISABLE_CRC_CHECKBOX    :    NATURAL    :=    0;
        FLASH_DATA_WIDTH    :    NATURAL    :=    16;
        RSU_WATCHDOG_COUNTER    :    NATURAL    :=    100000000;
        PFL_RSU_WATCHDOG_ENABLED    :    NATURAL    :=    0;
        SAFE_MODE_HALT    :    NATURAL    :=    0;
        ADDR_WIDTH    :    NATURAL    :=    20;
        NAND_SIZE    :    NATURAL    :=    67108864;
        NORMAL_MODE    :    NATURAL    :=    1;
        FLASH_NRESET_CHECKBOX    :    NATURAL    :=    0;
        SAFE_MODE_REVERT    :    NATURAL    :=    0;
        LPM_TYPE    :    STRING    :=    "ALTPARALLEL_FLASH_LOADER";
        AUTO_RESTART    :    STRING    :=    "OFF";
        CLK_DIVISOR    :    NATURAL    :=    1;
        BURST_MODE_INTEL    :    NATURAL    :=    0;
        BURST_MODE_NUMONYX    :    NATURAL    :=    0;
        DECOMPRESSOR_MODE    :    STRING    :=    "NONE"
    );
    port    (
        flash_nce    :    out    std_logic_vector(N_FLASH-1 downto 0);
        fpga_data    :    out    std_logic_vector(CONF_DATA_WIDTH-1 downto 0);
        fpga_dclk    :    out    std_logic;
        fpga_nstatus    :    in    std_logic    :=    '0';
        flash_ale    :    out    std_logic;
        pfl_clk    :    in    std_logic    :=    '0';
        fpga_nconfig    :    out    std_logic;
        flash_io2    :    inout    std_logic_vector(N_FLASH-1 downto 0);
        flash_sck    :    out    std_logic_vector(N_FLASH-1 downto 0);
        flash_noe    :    out    std_logic;
        flash_nwe    :    out    std_logic;
        pfl_watchdog_error    :    out    std_logic;
        pfl_reset_watchdog    :    in    std_logic    :=    '0';
        fpga_conf_done    :    in    std_logic    :=    '0';
        flash_rdy    :    in    std_logic    :=    '1';
        pfl_flash_access_granted    :    in    std_logic    :=    '0';
        pfl_nreconfigure    :    in    std_logic    :=    '1';
        flash_cle    :    out    std_logic;
        flash_nreset    :    out    std_logic;
        flash_io0    :    inout    std_logic_vector(N_FLASH-1 downto 0);
        pfl_nreset    :    in    std_logic    :=    '0';
        flash_data    :    inout    std_logic_vector(FLASH_DATA_WIDTH-1 downto 0);
        flash_io1    :    inout    std_logic_vector(N_FLASH-1 downto 0);
        flash_nadv    :    out    std_logic;
        flash_clk    :    out    std_logic;
        flash_io3    :    inout    std_logic_vector(N_FLASH-1 downto 0);
        flash_io    :    inout    std_logic_vector(7 downto 0);
        flash_addr    :    out    std_logic_vector(ADDR_WIDTH-1 downto 0);
        pfl_flash_access_request    :    out    std_logic;
        flash_ncs    :    out    std_logic_vector(N_FLASH-1 downto 0);
        fpga_pgm    :    in    std_logic_vector(2 downto 0)   :=   (others => '0')
    );
end component; --altparallel_flash_loader


component    altserial_flash_loader
    generic    (
        enhanced_mode    :    natural    :=    0;
        intended_device_family    :    STRING    :=    "Cyclone";
        enable_shared_access    :    STRING    :=    "OFF";
        enable_quad_spi_support    :    natural    :=    0;
        lpm_type    :    STRING    :=    "ALTSERIAL_FLASH_LOADER"
    );
    port    (
        data_in    :    in    std_logic_vector(3 downto 0)   :=   (others => '0');
        noe    :    in    std_logic    :=    '0';
        asmi_access_granted    :    in    std_logic    :=    '1';
        data_out    :    out    std_logic_vector(3 downto 0);
        data_oe    :    in    std_logic_vector(3 downto 0)   :=   (others => '0');
        sdoin    :    in    std_logic    :=    '0';
        asmi_access_request    :    out    std_logic;
        data0out    :    out    std_logic;
        scein    :    in    std_logic    :=    '0';
        dclkin    :    in    std_logic    :=    '0'
    );
end component; --altserial_flash_loader


component    sld_virtual_jtag_basic
    generic    (
        lpm_hint    :    string    :=    "UNUSED";
        sld_sim_action    :    string    :=    "UNUSED";
        sld_instance_index    :    natural    :=    0;
        sld_ir_width    :    natural    :=    1;
        sld_sim_n_scan    :    natural    :=    0;
        sld_mfg_id    :    natural    :=    0;
        sld_version    :    natural    :=    0;
        sld_type_id    :    natural    :=    0;
        lpm_type    :    string    :=    "sld_virtual_jtag_basic";
        sld_auto_instance_index    :    string    :=    "NO";
        sld_sim_total_length    :    natural    :=    0
    );
    port    (
        jtag_state_sdr    :    out    std_logic;
        jtag_state_sirs    :    out    std_logic;
        ir_out    :    in    std_logic_vector(sld_ir_width-1 downto 0);
        jtag_state_sir    :    out    std_logic;
        jtag_state_cdr    :    out    std_logic;
        jtag_state_e2dr    :    out    std_logic;
        tms    :    out    std_logic;
        jtag_state_sdrs    :    out    std_logic;
        jtag_state_tlr    :    out    std_logic;
        ir_in    :    out    std_logic_vector(sld_ir_width-1 downto 0);
        virtual_state_sdr    :    out    std_logic;
        tdi    :    out    std_logic;
        jtag_state_uir    :    out    std_logic;
        jtag_state_cir    :    out    std_logic;
        virtual_state_cdr    :    out    std_logic;
        virtual_state_uir    :    out    std_logic;
        virtual_state_e2dr    :    out    std_logic;
        jtag_state_e2ir    :    out    std_logic;
        virtual_state_cir    :    out    std_logic;
        jtag_state_pir    :    out    std_logic;
        jtag_state_udr    :    out    std_logic;
        virtual_state_udr    :    out    std_logic;
        tdo    :    in    std_logic;
        jtag_state_e1dr    :    out    std_logic;
        jtag_state_rti    :    out    std_logic;
        virtual_state_pdr    :    out    std_logic;
        virtual_state_e1dr    :    out    std_logic;
        jtag_state_e1ir    :    out    std_logic;
        jtag_state_pdr    :    out    std_logic;
        tck    :    out    std_logic
    );
end component; --sld_virtual_jtag_basic


component    altsource_probe
    generic    (
        lpm_hint    :    string    :=    "UNUSED";
        sld_instance_index    :    natural    :=    0;
        source_initial_value    :    string    :=    "0";
        sld_ir_width    :    natural    :=    4;
        probe_width    :    natural    :=    1;
        source_width    :    natural    :=    1;
        instance_id    :    string    :=    "UNUSED";
        lpm_type    :    string    :=    "altsource_probe";
        sld_auto_instance_index    :    string    :=    "YES";
        SLD_NODE_INFO    :    natural    :=    4746752;
        enable_metastability    :    string    :=    "NO"
    );
    port    (
        source_clk    :    in    std_logic;
        probe    :    in    std_logic_vector(probe_width-1 downto 0);
        source    :    out    std_logic_vector(source_width-1 downto 0);
        source_ena    :    in    std_logic
    );
end component; --altsource_probe

end altera_mf_components;
