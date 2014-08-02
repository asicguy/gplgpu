--

-- -----------------------------------------------------------------------------
--  Abstract        : constants package for the non-levelling AFI PHY sequencer
--                    The constant package (alt_mem_phy_constants_pkg) contains global
--                    'constants' which are fixed thoughout the sequencer and will not
--                    change (for constants which may change between sequencer
--                    instances generics are used)
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
package ddr3_int_phy_alt_mem_phy_constants_pkg is

    -- -------------------------------
    -- Register number definitions
    -- -------------------------------


    constant c_max_mode_reg_index          : natural := 13;   -- number of MR bits..

    -- Top bit of vector (i.e. width -1) used for address decoding :
    constant c_debug_reg_addr_top          : natural := 3;


    constant c_mmi_access_codeword         : std_logic_vector(31 downto 0) := X"00D0_0DEB";  -- to check for legal Avalon interface accesses
    -- Register addresses.
    constant c_regofst_cal_status          : natural := 0;
    constant c_regofst_debug_access        : natural := 1;
    constant c_regofst_hl_css              : natural := 2;
    constant c_regofst_mr_register_a       : natural := 5;
    constant c_regofst_mr_register_b       : natural := 6;
    constant c_regofst_codvw_status        : natural := 12;
    constant c_regofst_if_param            : natural := 13;
    constant c_regofst_if_test             : natural := 14;   -- pll_phs_shft, ac_1t, extra stuff
    constant c_regofst_test_status         : natural := 15;


    constant c_hl_css_reg_cal_dis_bit                    : natural := 0;
    constant c_hl_css_reg_phy_initialise_dis_bit         : natural := 1;
    constant c_hl_css_reg_init_dram_dis_bit              : natural := 2;
    constant c_hl_css_reg_write_ihi_dis_bit              : natural := 3;
    constant c_hl_css_reg_write_btp_dis_bit              : natural := 4;
    constant c_hl_css_reg_write_mtp_dis_bit              : natural := 5;
    constant c_hl_css_reg_read_mtp_dis_bit               : natural := 6;
    constant c_hl_css_reg_rrp_reset_dis_bit              : natural := 7;
    constant c_hl_css_reg_rrp_sweep_dis_bit              : natural := 8;
    constant c_hl_css_reg_rrp_seek_dis_bit               : natural := 9;
    constant c_hl_css_reg_rdv_dis_bit                    : natural := 10;
    constant c_hl_css_reg_poa_dis_bit                    : natural := 11;
    constant c_hl_css_reg_was_dis_bit                    : natural := 12;
    constant c_hl_css_reg_adv_rd_lat_dis_bit             : natural := 13;
    constant c_hl_css_reg_adv_wr_lat_dis_bit             : natural := 14;
    constant c_hl_css_reg_prep_customer_mr_setup_dis_bit : natural := 15;
    constant c_hl_css_reg_tracking_dis_bit               : natural := 16;

    constant c_hl_ccs_num_stages                         : natural := 17;


    -- -----------------------------------------------------
    -- Constants for DRAM addresses used during calibration:
    -- -----------------------------------------------------

    -- the mtp training pattern is x30F5
    -- 1. write 0011 0000 and 1100 0000 such that one location will contains 0011 0000
    -- 2. write in 1111 0101
    -- also require locations containing all ones and all zeros

    -- default choice of calibration burst length (overriden to 8 for reads for DDR3 devices)
    constant c_cal_burst_len        : natural := 4;

    constant c_cal_ofs_step_size    : natural := 8;

    constant c_cal_ofs_zeros        : natural := 0 * c_cal_ofs_step_size;
    constant c_cal_ofs_ones         : natural := 1 * c_cal_ofs_step_size;

    constant c_cal_ofs_x30_almt_0   : natural := 2 * c_cal_ofs_step_size;
    constant c_cal_ofs_x30_almt_1   : natural := 3 * c_cal_ofs_step_size;

    constant c_cal_ofs_xF5          : natural := 5 * c_cal_ofs_step_size;

    constant c_cal_ofs_wd_lat       : natural := 6 * c_cal_ofs_step_size;

    constant c_cal_data_len         : natural := c_cal_ofs_wd_lat + c_cal_ofs_step_size;

    constant c_cal_ofs_mtp	        : natural := 6*c_cal_ofs_step_size;
    constant c_cal_ofs_mtp_len      : natural := 4*4;
    constant c_cal_ofs_01_pairs     : natural := 2 * c_cal_burst_len;
    constant c_cal_ofs_10_pairs     : natural := 3 * c_cal_burst_len;
    constant c_cal_ofs_1100_step    : natural := 4 * c_cal_burst_len;
    constant c_cal_ofs_0011_step    : natural := 5 * c_cal_burst_len;


    -- -----------------------------------------------------
    -- Reset values. - These are chosen as default values for one PHY variation
    --                 with DDR2 memory and CAS latency 6, however in each calibration
    --                 mode these values will be set for a given PHY configuration.
    -- -----------------------------------------------------
    constant c_default_rd_lat : natural := 20;
    constant c_default_wr_lat : natural := 5;


    -- -----------------------------------------------------
    -- Errorcodes
    -- -----------------------------------------------------
    -- implemented
    constant C_SUCCESS                             : natural := 0;
    constant C_ERR_RESYNC_NO_VALID_PHASES          : natural := 5;  -- No valid data-valid windows found
    constant C_ERR_RESYNC_MULTIPLE_EQUAL_WINDOWS   : natural := 6;  -- Multiple equally-sized data valid windows
    constant C_ERR_RESYNC_NO_INVALID_PHASES        : natural := 7;  -- No invalid data-valid windows found.  Training patterns are designed so that there should always be at least one invalid phase.
    constant C_ERR_CRITICAL                        : natural := 15; -- A condition that can't happen just happened.

    constant C_ERR_READ_MTP_NO_VALID_ALMT          : natural := 23;
    constant C_ERR_READ_MTP_BOTH_ALMT_PASS         : natural := 24;

	constant C_ERR_WD_LAT_DISAGREEMENT			   : natural := 22; -- MEM_IF_DWIDTH/MEM_IF_DQ_PER_DQS copies of write-latency are written to memory.  If all of these are not the same this error is generated.
    constant C_ERR_MAX_RD_LAT_EXCEEDED             : natural := 25;

    constant C_ERR_MAX_TRK_SHFT_EXCEEDED           : natural := 26;

    -- not implemented yet
    constant c_err_ac_lat_some_beats_are_different : natural := 1;    -- implies DQ_1T setup failure or earlier.
    constant c_err_could_not_find_read_lat         : natural := 2;    -- dodgy RDP setup
    constant c_err_could_not_find_write_lat        : natural := 3;    -- dodgy WDP setup

    constant c_err_clock_cycle_iteration_timeout   : natural :=  8;    -- depends on srate calling error  -- GENERIC
    constant c_err_clock_cycle_it_timeout_rdp      : natural :=  9;
    constant c_err_clock_cycle_it_timeout_rdv      : natural := 10;
    constant c_err_clock_cycle_it_timeout_poa      : natural := 11;

    constant c_err_pll_ack_timeout                 : natural := 13;

    constant c_err_WindowProc_multiple_rsc_windows : natural := 16;
    constant c_err_WindowProc_window_det_no_ones   : natural := 17;
    constant c_err_WindowProc_window_det_no_zeros  : natural := 18;
    constant c_err_WindowProc_undefined            : natural := 19;   -- catch all

    constant c_err_tracked_mmc_offset_overflow     : natural := 20;
    constant c_err_no_mimic_feedback               : natural := 21;

    constant c_err_ctrl_ack_timeout                : natural := 32;
    constant c_err_ctrl_done_timeout               : natural := 33;

    -- -----------------------------------------------------
    -- PLL phase locations per device family
    -- (unused but a limited set is maintained here for reference)
    -- -----------------------------------------------------

    constant c_pll_resync_phs_select_ciii : natural := 5;
    constant c_pll_mimic_phs_select_ciii  : natural := 4;

    constant c_pll_resync_phs_select_siii : natural := 5;
    constant c_pll_mimic_phs_select_siii  : natural := 7;

    -- -----------------------------------------------------
    -- Maximum sizing constraints
    -- -----------------------------------------------------
    constant C_MAX_NUM_PLL_RSC_PHASES : natural := 32;

    -- -----------------------------------------------------
    -- IO control Params
    -- -----------------------------------------------------
    constant c_set_oct_to_rs : std_logic := '0';
    constant c_set_oct_to_rt : std_logic := '1';

    constant c_set_odt_rt    : std_logic := '1';
    constant c_set_odt_off   : std_logic := '0';

--
end ddr3_int_phy_alt_mem_phy_constants_pkg;
--

-- -----------------------------------------------------------------------------
--  Abstract        : record package for the non-levelling AFI sequencer
--                    The record package (alt_mem_phy_record_pkg) is used to combine
--                    command and status signals (into records) to be passed between
--                    sequencer blocks. It also contains type and record definitions
--                    for the stages of DRAM memory calibration.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
package ddr3_int_phy_alt_mem_phy_record_pkg is

    -- set some maximum constraints to bound natural numbers below
    constant c_max_num_dqs_groups : natural := 24;
    constant c_max_num_pins       : natural := 8;
    constant c_max_ranks          : natural := 16;
    constant c_max_pll_steps      : natural := 80;

-- a prefix for all report signals to identify phy and sequencer block
--
    constant record_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_record_pkg : ";


    type t_family is (
        cyclone3,
        stratix2,
        stratix3
    );

-- -----------------------------------------------------------------------
--  the following are required for the non-levelling AFI PHY sequencer block interfaces
-- -----------------------------------------------------------------------

    -- admin mode register settings (from mmi block)
    type t_admin_ctrl is record
        mr0 : std_logic_vector(12 downto 0);
        mr1 : std_logic_vector(12 downto 0);
        mr2 : std_logic_vector(12 downto 0);
        mr3 : std_logic_vector(12 downto 0);
    end record;

    function defaults return t_admin_ctrl;

    -- current admin status
    type t_admin_stat is record
        mr0       : std_logic_vector(12 downto 0);
        mr1       : std_logic_vector(12 downto 0);
        mr2       : std_logic_vector(12 downto 0);
        mr3       : std_logic_vector(12 downto 0);
        init_done : std_logic;
    end record;

    function defaults return t_admin_stat;

    -- mmi to iram ctrl signals
    type t_iram_ctrl is record
        addr    : natural range 0 to 1023;
        wdata   : std_logic_vector(31 downto 0);
        write   : std_logic;
        read    : std_logic;
    end record;

    function defaults return t_iram_ctrl;

   -- broadcast iram status to mmi and dgrb
    type t_iram_stat is record
        rdata            : std_logic_vector(31 downto 0);
        done             : std_logic;
        err              : std_logic;
        err_code         : std_logic_vector(3 downto 0);
        init_done        : std_logic;
        out_of_mem       : std_logic;
        contested_access : std_logic;
    end record;

    function defaults return t_iram_stat;

    -- codvw status signals from dgrb to mmi block
    type t_dgrb_mmi is record
        cal_codvw_phase   : std_logic_vector(7 downto 0);
        cal_codvw_size    : std_logic_vector(7 downto 0);
        codvw_trk_shift   : std_logic_vector(11 downto 0);
        codvw_grt_one_dvw : std_logic;
    end record;

    function defaults return t_dgrb_mmi;

    -- signal to id which block is active
    type t_ctrl_active_block is (
                                    idle,
                                    admin,
                                    dgwb,
                                    dgrb,
                                    proc,  -- unused in non-levelling AFI sequencer
                                    setup, -- unused in non-levelling AFI sequencer
                                    iram
                              );
    function ret_proc return t_ctrl_active_block;
    function ret_dgrb return t_ctrl_active_block;

    -- control record for dgwb, dgrb, iram and admin blocks:

    -- the possible commands
    type t_ctrl_cmd_id is (
                            cmd_idle,

                            -- initialisation stages
                            cmd_phy_initialise,
                            cmd_init_dram,
                            cmd_prog_cal_mr,
                            cmd_write_ihi,

                            -- calibration stages
                            cmd_write_btp,
                            cmd_write_mtp,
                            cmd_read_mtp,
                            cmd_rrp_reset,
                            cmd_rrp_sweep,
                            cmd_rrp_seek,
                            cmd_rdv,
                            cmd_poa,
                            cmd_was,

                            -- advertise controller settings and re-configure for customer operation mode.
                            cmd_prep_adv_rd_lat,
                            cmd_prep_adv_wr_lat,
                            cmd_prep_customer_mr_setup,
                            cmd_tr_due

                          );

    -- which block should execute each command
    function curr_active_block (
        ctrl_cmd_id : t_ctrl_cmd_id
       ) return  t_ctrl_active_block;

    -- specify command operands as a record
    type t_command_op is record
        current_cs : natural range 0 to c_max_ranks-1; -- which chip select is being calibrated
        single_bit : std_logic;                        -- current operation should be single bit
        mtp_almt   : natural range 0 to 1;             -- signals mtp alignment to be used for operation
    end record;

    function defaults return t_command_op;

    -- command request record (sent to each block)
    type t_ctrl_command is record
        command       : t_ctrl_cmd_id;
        command_op    : t_command_op;
        command_req   : std_logic;
    end record;

    function defaults return t_ctrl_command;

    -- a generic status record for each block
    type t_ctrl_stat is record
        command_ack    : std_logic;
        command_done   : std_logic;
        command_result : std_logic_vector(7 downto 0 );
        command_err    : std_logic;
    end record;

    function defaults return t_ctrl_stat;

    -- push interface for dgwb / dgrb blocks (only the dgrb uses this interface at present)
    type t_iram_push is record
        iram_done     : std_logic;
        iram_write    : std_logic;
        iram_wordnum  : natural range 0 to 511;        -- acts as an offset to current location (max = 80 pll steps *2 sweeps and 80 pins)
        iram_bitnum   : natural range 0 to 31;         -- for bitwise packing modes
        iram_pushdata : std_logic_vector(31 downto 0); -- only bit zero used for bitwise packing_mode
    end record;

    function defaults return t_iram_push;

    -- control block "master" state machine
    type t_master_sm_state is
    (
        s_reset,
        s_phy_initialise,         -- wait for dll lock and init done flag from iram
        s_init_dram,              -- dram initialisation - reset sequence
        s_prog_cal_mr,            -- dram initialisation - programming mode registers (once per chip select)
        s_write_ihi,              -- write header information in iRAM
        s_cal,                    -- check if calibration to be executed
        s_write_btp,              -- write burst training pattern
        s_write_mtp,              -- write more training pattern
        s_read_mtp,               -- read training patterns to find correct alignment for 1100 burst
                                  -- (this is a special case of s_rrp_seek with no resych phase setting)
        s_rrp_reset,              -- read resync phase setup - reset initial conditions
        s_rrp_sweep,              -- read resync phase setup - sweep phases per chip select
        s_rrp_seek,               -- read resync phase setup - seek correct phase
        s_rdv,                    -- read data valid setup
        s_was,                    -- write datapath setup (ac to write data timing)
        s_adv_rd_lat,             -- advertise read latency
        s_adv_wr_lat,             -- advertise write latency
        s_poa,                    -- calibrate the postamble (dqs based capture only)
        s_tracking_setup,         -- perform tracking (1st pass to setup mimic window)
        s_prep_customer_mr_setup, -- apply user mode register settings (in admin block)
        s_tracking,               -- perform tracking (subsequent passes in user mode)
        s_operational,            -- calibration successful and in user mode
        s_non_operational         -- calibration unsuccessful and in user mode
    );

    -- record (set in mmi block) to disable calibration states
    type t_hl_css_reg is record

        phy_initialise_dis         : std_logic;
        init_dram_dis              : std_logic;
        write_ihi_dis              : std_logic;
        cal_dis                    : std_logic;
        write_btp_dis              : std_logic;
        write_mtp_dis              : std_logic;
        read_mtp_dis               : std_logic;
        rrp_reset_dis              : std_logic;
        rrp_sweep_dis              : std_logic;
        rrp_seek_dis               : std_logic;
        rdv_dis                    : std_logic;
        poa_dis                    : std_logic;
        was_dis                    : std_logic;
        adv_rd_lat_dis             : std_logic;
        adv_wr_lat_dis             : std_logic;
        prep_customer_mr_setup_dis : std_logic;
        tracking_dis               : std_logic;
    end record;

    function defaults return t_hl_css_reg;

    -- record (set in ctrl block) to identify when a command has been acknowledged
    type t_cal_stage_ack_seen is record

        cal                    : std_logic;
        phy_initialise         : std_logic;
        init_dram              : std_logic;
        write_ihi              : std_logic;
        write_btp              : std_logic;
        write_mtp              : std_logic;
        read_mtp               : std_logic;
        rrp_reset              : std_logic;
        rrp_sweep              : std_logic;
        rrp_seek               : std_logic;
        rdv                    : std_logic;
        poa                    : std_logic;
        was                    : std_logic;
        adv_rd_lat             : std_logic;
        adv_wr_lat             : std_logic;
        prep_customer_mr_setup : std_logic;
        tracking_setup         : std_logic;
    end record;

    function defaults return t_cal_stage_ack_seen;

    -- ctrl to mmi block interface (calibration status)
    type t_ctrl_mmi is record
        master_state_r             : t_master_sm_state;
        ctrl_calibration_success   : std_logic;
        ctrl_calibration_fail      : std_logic;
        ctrl_current_stage_done    : std_logic;
        ctrl_current_stage         : t_ctrl_cmd_id;
        ctrl_current_active_block  : t_ctrl_active_block;
        ctrl_cal_stage_ack_seen    : t_cal_stage_ack_seen;
        ctrl_err_code              : std_logic_vector(7 downto 0);
    end record;

    function defaults return t_ctrl_mmi;

    -- mmi to ctrl block interface (calibration control signals)
    type t_mmi_ctrl is record
        hl_css                   : t_hl_css_reg;
        calibration_start        : std_logic;
        tracking_period_ms       : natural range 0 to 255;
        tracking_orvd_to_10ms    : std_logic;
    end record;

    function defaults return t_mmi_ctrl;

    -- algorithm parameterisation (generated in mmi block)
    type t_algm_paramaterisation is record
         num_phases_per_tck_pll : natural range 1 to c_max_pll_steps;
         nominal_dqs_delay      : natural range 0 to 4;
         pll_360_sweeps         : natural range 0 to 15;
         nominal_poa_phase_lead : natural range 0 to 7;
         maximum_poa_delay      : natural range 0 to 15;
         odt_enabled            : boolean;
         extend_octrt_by        : natural range 0 to 15;
         delay_octrt_by         : natural range 0 to 15;
         tracking_period_ms     : natural range 0 to 255;
    end record;

    -- interface between mmi and pll to control phase shifting
    type t_mmi_pll_reconfig is record
        pll_phs_shft_phase_sel : natural range 0 to 15;
        pll_phs_shft_up_wc     : std_logic;
        pll_phs_shft_dn_wc     : std_logic;
    end record;

    type t_pll_mmi is record
        pll_busy : std_logic;
        err      : std_logic_vector(1 downto 0);
    end record;

    -- specify the iram configuration this is default
    -- currently always dq_bitwise packing and a write mode of overwrite_ram

    type t_iram_packing_mode is (
                                    dq_bitwise,
                                    dq_wordwise
                                );

    type t_iram_write_mode is (
                                    overwrite_ram,
                                    or_into_ram,
                                    and_into_ram
                              );

    type t_ctrl_iram is record
        packing_mode : t_iram_packing_mode;
        write_mode   : t_iram_write_mode;
        active_block : t_ctrl_active_block;
    end record;

    function defaults return t_ctrl_iram;

-- -----------------------------------------------------------------------
--  the following are required for compliance to levelling AFI PHY interface but
--  are non-functional for non-levelling AFI PHY sequencer
-- -----------------------------------------------------------------------

    type t_sc_ctrl_if is record
        read             : std_logic;
        write            : std_logic;
        dqs_group_sel    : std_logic_vector( 4 downto 0);
        sc_in_group_sel  : std_logic_vector( 5 downto 0);
        wdata            : std_logic_vector(45 downto 0);
        op_type          : std_logic_vector( 1 downto 0);
    end record;

    function defaults return t_sc_ctrl_if;

    type t_sc_stat is record
        rdata           : std_logic_vector(45 downto 0);
        busy            : std_logic;
        error_det       : std_logic;
        err_code        : std_logic_vector(1 downto 0);
        sc_cap          : std_logic_vector(7 downto 0);
    end record;

    function defaults return t_sc_stat;

    type t_element_to_reconfigure is (
                                       pp_t9,
                                       pp_t10,
                                       pp_t1,
                                       dqslb_rsc_phs,
                                       dqslb_poa_phs_ofst,
                                       dqslb_dqs_phs,
                                       dqslb_dq_phs_ofst,
                                       dqslb_dq_1t,
                                       dqslb_dqs_1t,
                                       dqslb_rsc_1t,
                                       dqslb_div2_phs,
                                       dqslb_oct_t9,
                                       dqslb_oct_t10,
                                       dqslb_poa_t7,
                                       dqslb_poa_t11,
                                       dqslb_dqs_dly,
                                       dqslb_lvlng_byps
                                     );

    type t_sc_type is (
                        DQS_LB,
                        DQS_DQ_DM_PINS,
                        DQ_DM_PINS,
                        dqs_dqsn_pins,
                        dq_pin,
                        dqs_pin,
                        dm_pin,
                        dq_pins
                       );

    type t_sc_int_ctrl is record
        group_num  : natural range 0 to c_max_num_dqs_groups;
        group_type : t_sc_type;
        pin_num    : natural range 0 to c_max_num_pins;
        sc_element : t_element_to_reconfigure;
        prog_val   : std_logic_vector(3 downto 0);
        ram_set    : std_logic;
        sc_update  : std_logic;
    end record;

    function defaults return t_sc_int_ctrl;

-- -----------------------------------------------------------------------
-- record and functions for instant on mode
-- -----------------------------------------------------------------------

    -- ranges on the below are not important because this logic is not synthesised
    type t_preset_cal is record
        codvw_phase  : natural range 0 to 2*c_max_pll_steps;-- rsc phase
        codvw_size   : natural range 0 to c_max_pll_steps;  -- rsc size (unused but reported)
        rlat         : natural;                             -- advertised read latency ctl_rlat (in phy clock cycles)
        rdv_lat      : natural;                             -- read data valid latency decrements needed (in memory clock cycles)
        wlat         : natural;                             -- advertised write latency ctl_wlat (in phy clock cycles)
        ac_1t        : std_logic;                           -- address / command 1t delay setting (HR only)
        poa_lat      : natural;                             -- poa latency decrements needed (in memory clock cycles)
    end record;

    -- the below are hardcoded (do not change)
    constant c_ddr_default_cl   : natural := 3;
    constant c_ddr2_default_cl  : natural := 6;
    constant c_ddr3_default_cl  : natural := 6;
    constant c_ddr2_default_cwl : natural := 5;
    constant c_ddr3_default_cwl : natural := 5;
    constant c_ddr2_default_al  : natural := 0;
    constant c_ddr3_default_al  : natural := 0;

    constant c_ddr_default_rl   : integer := c_ddr_default_cl;
    constant c_ddr2_default_rl  : integer := c_ddr2_default_cl + c_ddr2_default_al;
    constant c_ddr3_default_rl  : integer := c_ddr3_default_cl + c_ddr3_default_al;

    constant c_ddr_default_wl   : integer := 1;
    constant c_ddr2_default_wl  : integer := c_ddr2_default_cwl + c_ddr2_default_al;
    constant c_ddr3_default_wl  : integer := c_ddr3_default_cwl + c_ddr3_default_al;

    function defaults return t_preset_cal;

    function setup_instant_on (sim_time_red : natural;
                               family_id    : natural;
                               memory_type  : string;
                               dwidth_ratio : natural;
                               pll_steps    : natural;
                               mr0          : std_logic_vector(15 downto 0);
                               mr1          : std_logic_vector(15 downto 0);
                               mr2          : std_logic_vector(15 downto 0)) return t_preset_cal;



--
end ddr3_int_phy_alt_mem_phy_record_pkg;

--
package body ddr3_int_phy_alt_mem_phy_record_pkg IS

-- -----------------------------------------------------------------------
--  function implementations for the above declarations
--  these are mainly default conditions for records
-- -----------------------------------------------------------------------

    function defaults return t_admin_ctrl is
        variable output : t_admin_ctrl;
    begin
        output.mr0 := (others => '0');
        output.mr1 := (others => '0');
        output.mr2 := (others => '0');
        output.mr3 := (others => '0');
        return output;
    end function;

    function defaults return t_admin_stat is
        variable output : t_admin_stat;
    begin
        output.mr0 := (others => '0');
        output.mr1 := (others => '0');
        output.mr2 := (others => '0');
        output.mr3 := (others => '0');
        return output;
    end function;


    function defaults return t_iram_ctrl is
        variable output : t_iram_ctrl;
    begin
        output.addr    := 0;
        output.wdata   := (others => '0');
        output.write   := '0';
        output.read    := '0';
        return output;
    end function;

    function defaults return t_iram_stat is
        variable output : t_iram_stat;
    begin
        output.rdata            := (others => '0');
        output.done             := '0';
        output.err              := '0';
        output.err_code         := (others => '0');
        output.init_done        := '0';
        output.out_of_mem       := '0';
        output.contested_access := '0';
        return output;
    end function;

    function defaults return t_dgrb_mmi is
        variable output : t_dgrb_mmi;
    begin
        output.cal_codvw_phase   := (others => '0');
        output.cal_codvw_size    := (others => '0');
        output.codvw_trk_shift   := (others => '0');
        output.codvw_grt_one_dvw := '0';
        return output;
    end function;

    function ret_proc return t_ctrl_active_block is
        variable output : t_ctrl_active_block;
    begin
        output := proc;
        return output;
    end function;

    function ret_dgrb return t_ctrl_active_block is
        variable output : t_ctrl_active_block;
    begin
        output := dgrb;
        return output;
    end function;

    function defaults return t_ctrl_iram is
        variable output : t_ctrl_iram;
    begin
        output.packing_mode := dq_bitwise;
        output.write_mode   := overwrite_ram;
        output.active_block := idle;
        return output;
    end function;

    function defaults return t_command_op is
        variable output : t_command_op;
    begin
        output.current_cs := 0;
        output.single_bit := '0';
        output.mtp_almt   := 0;
        return output;
    end function;

    function defaults return t_ctrl_command is
        variable output : t_ctrl_command;
    begin
        output.command     := cmd_idle;
        output.command_req := '0';
        output.command_op  := defaults;
        return output;
    end function;

    -- decode which block is associated with which command
    function curr_active_block (
        ctrl_cmd_id : t_ctrl_cmd_id
       ) return  t_ctrl_active_block is
    begin
        case ctrl_cmd_id is
            when cmd_idle                   => return idle;
            when cmd_phy_initialise         => return idle;
            when cmd_init_dram              => return admin;
            when cmd_prog_cal_mr            => return admin;
            when cmd_write_ihi              => return iram;
            when cmd_write_btp              => return dgwb;
            when cmd_write_mtp              => return dgwb;
            when cmd_read_mtp               => return dgrb;
            when cmd_rrp_reset              => return dgrb;
            when cmd_rrp_sweep              => return dgrb;
            when cmd_rrp_seek               => return dgrb;
            when cmd_rdv                    => return dgrb;
            when cmd_poa                    => return dgrb;
            when cmd_was                    => return dgwb;
            when cmd_prep_adv_rd_lat        => return dgrb;
            when cmd_prep_adv_wr_lat        => return dgrb;
            when cmd_prep_customer_mr_setup => return admin;
            when cmd_tr_due                 => return dgrb;
            when others                     => return idle;
        end case;
    end function;

    function defaults return t_ctrl_stat is
        variable output : t_ctrl_stat;
    begin
        output.command_ack    := '0';
        output.command_done   := '0';
        output.command_err    := '0';
        output.command_result := (others => '0');
        return output;
    end function;

    function defaults return t_iram_push is
        variable output : t_iram_push;
    begin
        output.iram_done     := '0';
        output.iram_write    := '0';
        output.iram_wordnum  := 0;
        output.iram_bitnum   := 0;
        output.iram_pushdata := (others => '0');
        return output;
    end function;

    function defaults return t_hl_css_reg is
        variable output  : t_hl_css_reg;
    begin
        output.phy_initialise_dis         := '0';
        output.init_dram_dis              := '0';
        output.write_ihi_dis              := '0';
        output.cal_dis                    := '0';
        output.write_btp_dis              := '0';
        output.write_mtp_dis              := '0';
        output.read_mtp_dis               := '0';
        output.rrp_reset_dis              := '0';
        output.rrp_sweep_dis              := '0';
        output.rrp_seek_dis               := '0';
        output.rdv_dis                    := '0';
        output.poa_dis                    := '0';
        output.was_dis                    := '0';
        output.adv_rd_lat_dis             := '0';
        output.adv_wr_lat_dis             := '0';
        output.prep_customer_mr_setup_dis := '0';
        output.tracking_dis               := '0';
        return output;

    end function;

    function defaults return t_cal_stage_ack_seen is
        variable output : t_cal_stage_ack_seen;
    begin

       output.cal                    := '0';
       output.phy_initialise         := '0';
       output.init_dram              := '0';
       output.write_ihi              := '0';
       output.write_btp              := '0';
       output.write_mtp              := '0';
       output.read_mtp               := '0';
       output.rrp_reset              := '0';
       output.rrp_sweep              := '0';
       output.rrp_seek               := '0';
       output.rdv                    := '0';
       output.poa                    := '0';
       output.was                    := '0';
       output.adv_rd_lat             := '0';
       output.adv_wr_lat             := '0';
       output.prep_customer_mr_setup := '0';
       output.tracking_setup         := '0';

       return output;
    end function;


    function defaults return t_mmi_ctrl is
        variable output : t_mmi_ctrl;
    begin
        output.hl_css                                  := defaults;
        output.calibration_start                       := '0';
        output.tracking_period_ms                      := 0;
        output.tracking_orvd_to_10ms                   := '0';
        return output;
    end function;



    function defaults return t_ctrl_mmi is
        variable output : t_ctrl_mmi;
    begin
        output.master_state_r              := s_reset;
        output.ctrl_calibration_success    := '0';
        output.ctrl_calibration_fail       := '0';
        output.ctrl_current_stage_done     := '0';
        output.ctrl_current_stage          := cmd_idle;
        output.ctrl_current_active_block   := idle;
        output.ctrl_cal_stage_ack_seen     := defaults;
        output.ctrl_err_code               := (others => '0');
        return output;
    end function;

-------------------------------------------------------------------------
-- the following are required for compliance to levelling AFI PHY interface but
-- are non-functional for non-levelling AFi PHY sequencer
-------------------------------------------------------------------------

    function defaults return t_sc_ctrl_if is
        variable output : t_sc_ctrl_if;
    begin
        output.read            := '0';
        output.write           := '0';
        output.dqs_group_sel   := (others => '0');
        output.sc_in_group_sel := (others => '0');
        output.wdata           := (others => '0');
        output.op_type         := (others => '0');
        return output;
    end function;

    function defaults return t_sc_stat is
        variable output : t_sc_stat;
    begin
        output.rdata := (others => '0');
        output.busy      := '0';
        output.error_det := '0';
        output.err_code  := (others => '0');
        output.sc_cap    := (others => '0');
        return output;
    end function;

    function defaults return t_sc_int_ctrl is
        variable output : t_sc_int_ctrl;
    begin
        output.group_num  := 0;
        output.group_type := DQ_PIN;
        output.pin_num    := 0;
        output.sc_element := pp_t9;
        output.prog_val   := (others => '0');
        output.ram_set    := '0';
        output.sc_update  := '0';
        return output;
    end function;

-- -----------------------------------------------------------------------
-- functions for instant on mode
--
--
-- Guide on how to use:
--
-- The following factors effect the setup of the PHY:
-- - AC Phase - phase at which address/command signals launched wrt PHY clock
--            - this effects the read/write latency
-- - MR settings - CL, CWL, AL
-- - Data rate - HR or FR (DDR/DDR2 only)
-- - Family - datapaths are subtly different for each
-- - Memory type - DDR/DDR2/DDR3 (different latency behaviour - see specs)
--
-- Instant on mode is designed to work for the following subset of the
-- above factors:
-- - AC Phase - out of the box defaults, which is 240 degrees for SIII type
--              families (includes SIV, HCIII, HCIV), else 90 degrees
-- - MR Settings - DDR - CL 3 only
--               - DDR2 - CL 3,4,5,6, AL 0
--               - DDR3 - CL 5,6 CWL 5, AL 0
-- - Data rate - All
-- - Families - All
-- - Memory type - All
--
-- Hints on bespoke setup for parameters outside the above or if the
-- datapath is modified (only for VHDL sim mode):
--
-- Step 1 - Run simulation with REDUCE_SIM_TIME mode 2 (FAST)
--
-- Step 2 - From the output log find the following text:
-- # -----------------------------------------------------------------------
-- **** ALTMEMPHY CALIBRATION has completed ****
-- Status:
-- calibration has  : PASSED
-- PHY read latency (ctl_rlat) is  : 14
-- address/command to PHY write latency (ctl_wlat) is : 2
-- read resynch phase calibration report:
-- calibrated centre of data valid window phase : 32
-- calibrated centre of data valid window size  : 24
-- chosen address and command 1T delay: no 1T delay
-- poa 'dec' adjustments = 27
-- rdv 'dec' adjustments = 25
-- # -----------------------------------------------------------------------
--
-- Step 3 - Convert the text to bespoke instant on settings at the end of the
--          setup_instant_on function using the
--          override_instant_on function, note type is t_preset_cal
--
-- The mapping is as follows:
--
-- PHY read latency (ctl_rlat) is  : 14                   => rlat := 14
-- address/command to PHY write latency (ctl_wlat) is : 2 => wlat := 2
-- read resynch phase calibration report:
-- calibrated centre of data valid window phase : 32      => codvw_phase := 32
-- calibrated centre of data valid window size  : 24      => codvw_size  := 24
-- chosen address and command 1T delay: no 1T delay       => ac_1t := '0'
-- poa 'dec' adjustments = 27                             => poa_lat := 27
-- rdv 'dec' adjustments = 25                             => rdv_lat := 25
--
-- Step 4 - Try running in REDUCE_SIM_TIME mode 1 (SUPERFAST mode)
--
-- Step 5 - If still fails observe the behaviour of the controller, for the
--          following symptoms:
--    - If first 2 beats of read data lost (POA enable too late) - inc poa_lat by 1 (poa_lat is number of POA decrements not actual latency)
--    - If last 2 beats of read data lost (POA enable too early) - dec poa_lat by 1
--    - If ctl_rdata_valid misaligned to ctl_rdata then alter number of RDV adjustments (rdv_lat)
--    - If write data is not 4-beat aligned (when written into memory) toggle ac_1t (HR only)
--    - If read data is not 4-beat aligned (but write data is) add 360 degrees to phase (PLL_STEPS_PER_CYCLE) mod 2*PLL_STEPS_PER_CYCLE (HR only)
--
-- Step 6 - If the above fails revert to REDUCE_SIM_TIME = 2 (FAST) mode
--
-- --------------------------------------------------------------------------
    -- defaults
    function defaults return t_preset_cal is
        variable output : t_preset_cal;
    begin
        output.codvw_phase  := 0;
        output.codvw_size   := 0;
        output.wlat         := 0;
        output.rlat         := 0;
        output.rdv_lat      := 0;
        output.ac_1t        := '1'; -- default on for FR
        output.poa_lat      := 0;
        return output;
    end function;

    -- Functions to extract values from MR

    -- return cl (for DDR memory 2*cl because of 1/2 cycle latencies)
    procedure mr0_to_cl (memory_type : string;
                        mr0         : std_logic_vector(15 downto 0);
                        cl          : out natural;
                        half_cl     : out std_logic) is
        variable v_cl : natural;
    begin

        half_cl := '0';

        if memory_type = "DDR" then  -- DDR memories

            -- returns cl*2 because of 1/2 latencies
            v_cl := to_integer(unsigned(mr0(5 downto 4)));

            -- integer values of cl
            if mr0(6) = '0' then
                assert v_cl > 1 report record_report_prefix & "invalid cas latency for DDR memory, should be in range 1.5-3" severity failure;
            end if;

            if mr0(6) = '1' then
                assert (v_cl = 1 or v_cl = 2) report record_report_prefix & "invalid cas latency for DDR memory, should be in range 1.5-3" severity failure;
                half_cl := '1';
            end if;

        elsif memory_type = "DDR2" then -- DDR2 memories

            v_cl := to_integer(unsigned(mr0(6 downto 4)));
            -- sanity checks
            assert (v_cl > 1 and v_cl < 7) report record_report_prefix & "invalid cas latency for DDR2 memory, should be in range 2-6 but equals " & integer'image(v_cl) severity failure;

        elsif memory_type = "DDR3" then -- DDR3 memories

            v_cl := to_integer(unsigned(mr0(6 downto 4)))+4;
            --sanity checks
            assert mr0(2) = '0' report record_report_prefix & "invalid cas latency for DDR3 memory, bit a2 in mr0 is set"  severity failure;
            assert v_cl /= 4      report record_report_prefix & "invalid cas latency for DDR3 memory, bits a6:4 set to zero" severity failure;

        else
                report record_report_prefix & "Undefined memory type " & memory_type severity failure;
        end if;

        cl := v_cl;

    end procedure;

    function mr1_to_al (memory_type : string;
                        mr1         : std_logic_vector(15 downto 0);
                        cl          : natural) return natural is
        variable al : natural;
    begin

        if memory_type = "DDR" then  -- DDR memories

            -- unsupported so return zero
            al := 0;

        elsif memory_type = "DDR2" then -- DDR2 memories

            al := to_integer(unsigned(mr1(5 downto 3)));
            assert al < 6 report record_report_prefix & "invalid additive latency for DDR2 memory, should be in range 0-5 but equals " & integer'image(al) severity failure;

        elsif memory_type = "DDR3" then -- DDR3 memories

            al := to_integer(unsigned(mr1(4 downto 3)));
            assert al /= 3 report record_report_prefix & "invalid additive latency for DDR2 memory, should be in range 0-5 but equals " & integer'image(al) severity failure;

            if al /= 0 then -- CL-1 or CL-2
                al := cl - al;
            end if;

        else
                report record_report_prefix & "Undefined memory type " & memory_type severity failure;
        end if;

        return al;

    end function;

    -- return cwl
    function mr2_to_cwl (memory_type : string;
                         mr2         : std_logic_vector(15 downto 0);
                         cl          : natural) return natural is
        variable cwl : natural;
    begin

        if memory_type = "DDR" then  -- DDR memories

            cwl := 1;

        elsif memory_type = "DDR2" then -- DDR2 memories

            cwl := cl - 1;

        elsif memory_type = "DDR3" then -- DDR3 memories

            cwl := to_integer(unsigned(mr2(5 downto 3))) + 5;
            --sanity checks
            assert cwl < 9 report record_report_prefix & "invalid cas write latency for DDR3 memory, should be in range 5-8 but equals " & integer'image(cwl) severity failure;

        else
            report record_report_prefix & "Undefined memory type " & memory_type severity failure;
        end if;

        return cwl;

    end function;

    -- -----------------------------------
    -- Functions to determine which family group
    -- Include any family alias here
    -- -----------------------------------

    function is_siii(family_id : natural) return boolean is
    begin
        if family_id = 3 or family_id = 5 then

           return true;

        else

            return false;

        end if;

    end function;

    function is_ciii(family_id : natural) return boolean is
    begin
        if family_id = 2 then

           return true;

        else

            return false;

        end if;

    end function;

    function is_aii(family_id : natural) return boolean is
    begin
        if family_id = 4 then

           return true;

        else

            return false;

        end if;

    end function;

    function is_sii(family_id : natural) return boolean is
    begin
        if family_id = 1 then

           return true;

        else

            return false;

        end if;

    end function;

    -- -----------------------------------
    -- Functions to lookup hardcoded values
    -- on per family basis
    -- DDR: CL = 3
    -- DDR2: CL = 6, CWL = 5, AL = 0
    -- DDR3: CL = 6, CWL = 5, AL = 0
    -- -----------------------------------

    -- default ac phase = 240
    function siii_family_settings (dwidth_ratio : integer;
                                   memory_type  : string;
                                   pll_steps    : natural
                                  ) return t_preset_cal is
        variable v_output : t_preset_cal;
    begin

        v_output := defaults;

        if memory_type = "DDR" then  -- CAS = 3

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 15;
                v_output.rdv_lat      := 11;
                v_output.poa_lat      := 11;
            else
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 15;
                v_output.rdv_lat      := 23;
                v_output.ac_1t        := '0';
                v_output.poa_lat      := 24;
            end if;

        elsif memory_type = "DDR2" then -- CAS = 6

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 5;
                v_output.rlat         := 16;
                v_output.rdv_lat      := 10;
                v_output.poa_lat      := 8;
            else
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 3;
                v_output.rlat         := 16;
                v_output.rdv_lat      := 21;
                v_output.ac_1t        := '0';
                v_output.poa_lat      := 22;
            end if;

        elsif memory_type = "DDR3" then -- HR only, CAS = 6

            v_output.codvw_phase  := pll_steps/4;
            v_output.wlat         := 2;
            v_output.rlat         := 15;
            v_output.rdv_lat      := 23;
            v_output.ac_1t        := '0';
            v_output.poa_lat      := 24;

        end if;

        -- adapt settings for ac_phase (default 240 degrees so leave commented)
        -- if dwidth_ratio = 2 then

            -- v_output.wlat := v_output.wlat - 1;
            -- v_output.rlat := v_output.rlat - 1;
            -- v_output.rdv_lat := v_output.rdv_lat + 1;
            -- v_output.poa_lat := v_output.poa_lat + 1;

        -- else

            -- v_output.ac_1t := not v_output.ac_1t;

        -- end if;

        v_output.codvw_size := pll_steps;

        return v_output;

    end function;

    -- default ac phase = 90
    function ciii_family_settings (dwidth_ratio : integer;
                                   memory_type  : string;
                                   pll_steps    : natural) return t_preset_cal is
        variable v_output : t_preset_cal;
    begin

        v_output := defaults;

        if memory_type = "DDR" then  -- CAS = 3

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := 3*pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 15;
                v_output.rdv_lat      := 11;
                v_output.poa_lat      := 11; --unused
            else
                v_output.codvw_phase  := 3*pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 13;
                v_output.rdv_lat      := 27;
                v_output.ac_1t        := '1';
                v_output.poa_lat      := 27; --unused
            end if;

        elsif memory_type = "DDR2" then  -- CAS = 6

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := 3*pll_steps/4;
                v_output.wlat         := 5;
                v_output.rlat         := 18;
                v_output.rdv_lat      := 8;
                v_output.poa_lat      := 8; --unused
            else
                v_output.codvw_phase  := pll_steps + 3*pll_steps/4;
                v_output.wlat         := 3;
                v_output.rlat         := 14;
                v_output.rdv_lat      := 25;
                v_output.ac_1t        := '1';
                v_output.poa_lat      := 25; --unused
            end if;

        end if;

        -- adapt settings for ac_phase (hardcode for 90 degrees)
        if dwidth_ratio = 2 then

            v_output.wlat := v_output.wlat + 1;
            v_output.rlat := v_output.rlat + 1;
            v_output.rdv_lat := v_output.rdv_lat - 1;
            v_output.poa_lat := v_output.poa_lat - 1;

        else

            v_output.ac_1t := not v_output.ac_1t;

        end if;

        v_output.codvw_size   := pll_steps/2;

        return v_output;

    end function;


    -- default ac phase = 90
    function sii_family_settings (dwidth_ratio : integer;
                                   memory_type  : string;
                                   pll_steps    : natural) return t_preset_cal is
        variable v_output : t_preset_cal;
    begin

        v_output := defaults;

        if memory_type = "DDR" then  -- CAS = 3

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 15;
                v_output.rdv_lat      := 11;
                v_output.poa_lat      := 13;
            else
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 13;
                v_output.rdv_lat      := 27;
                v_output.ac_1t        := '1';
                v_output.poa_lat      := 22;
            end if;

        elsif memory_type = "DDR2" then

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 5;
                v_output.rlat         := 18;
                v_output.rdv_lat      := 8;
                v_output.poa_lat      := 10;
            else
                v_output.codvw_phase  := pll_steps + pll_steps/4;
                v_output.wlat         := 3;
                v_output.rlat         := 14;
                v_output.rdv_lat      := 25;
                v_output.ac_1t        := '1';
                v_output.poa_lat      := 20;
            end if;

        end if;

        -- adapt settings for ac_phase (hardcode for 90 degrees)
        if dwidth_ratio = 2 then

            v_output.wlat := v_output.wlat + 1;
            v_output.rlat := v_output.rlat + 1;
            v_output.rdv_lat := v_output.rdv_lat - 1;
            v_output.poa_lat := v_output.poa_lat - 1;

        else

            v_output.ac_1t := not v_output.ac_1t;

        end if;

        v_output.codvw_size := pll_steps;

        return v_output;

    end function;

    -- default ac phase = 90
    function aii_family_settings (dwidth_ratio : integer;
                                  memory_type  : string;
                                  pll_steps    : natural) return t_preset_cal is
        variable v_output : t_preset_cal;
    begin

        v_output := defaults;

        if memory_type = "DDR" then  -- CAS = 3

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 16;
                v_output.rdv_lat      := 10;
                v_output.poa_lat      := 15;
            else
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 1;
                v_output.rlat         := 13;
                v_output.rdv_lat      := 27;
                v_output.ac_1t        := '1';
                v_output.poa_lat      := 24;
            end if;

        elsif memory_type = "DDR2" then

            if dwidth_ratio = 2 then
                v_output.codvw_phase  := pll_steps/4;
                v_output.wlat         := 5;
                v_output.rlat         := 19;
                v_output.rdv_lat      := 9;
                v_output.poa_lat      := 12;
            else
                v_output.codvw_phase  := pll_steps + pll_steps/4;
                v_output.wlat         := 3;
                v_output.rlat         := 14;
                v_output.rdv_lat      := 25;
                v_output.ac_1t        := '1';
                v_output.poa_lat      := 22;
            end if;

        elsif memory_type = "DDR3" then -- HR only, CAS = 6

            v_output.codvw_phase  := pll_steps + pll_steps/4;
            v_output.wlat         := 3;
            v_output.rlat         := 14;
            v_output.rdv_lat      := 25;
            v_output.ac_1t        := '1';
            v_output.poa_lat      := 22;

        end if;

        -- adapt settings for ac_phase (hardcode for 90 degrees)
        if dwidth_ratio = 2 then

            v_output.wlat := v_output.wlat + 1;
            v_output.rlat := v_output.rlat + 1;
            v_output.rdv_lat := v_output.rdv_lat - 1;
            v_output.poa_lat := v_output.poa_lat - 1;

        else

            v_output.ac_1t := not v_output.ac_1t;

        end if;

        v_output.codvw_size := pll_steps;

        return v_output;

    end function;


    function is_odd(num : integer) return boolean is
        variable v_num : integer;
    begin
        v_num := num;
        if v_num - (v_num/2)*2 = 0 then
            return false;
        else
            return true;
        end if;
    end function;

    ------------------------------------------------
    -- top level function to setup instant on mode
    ------------------------------------------------

    function override_instant_on return t_preset_cal is
        variable v_output : t_preset_cal;
    begin

        v_output := defaults;

        -- add in overrides here

        return v_output;

    end function;

    function setup_instant_on (sim_time_red : natural;
                               family_id    : natural;
                               memory_type  : string;
                               dwidth_ratio : natural;
                               pll_steps    : natural;
                               mr0          : std_logic_vector(15 downto 0);
                               mr1          : std_logic_vector(15 downto 0);
                               mr2          : std_logic_vector(15 downto 0)) return t_preset_cal is

        variable v_output : t_preset_cal;

        variable v_cl      : natural; -- cas latency
        variable v_half_cl : std_logic; -- + 0.5 cycles (DDR only)
        variable v_al      : natural; -- additive latency (ddr2/ddr3 only)
        variable v_cwl     : natural; -- cas write latency (ddr3 only)

        variable v_rl       : integer range 0 to 15;
        variable v_wl       : integer;
        variable v_delta_rl : integer range -10 to 10;  -- from given defaults
        variable v_delta_wl : integer;  -- from given defaults

        variable v_debug : boolean;

    begin

        v_debug := true;

        v_output := defaults;

        if sim_time_red = 1 then  -- only set if STR equals 1

            -- ----------------------------------------
            -- extract required parameters from MRs
            -- ----------------------------------------
            mr0_to_cl(memory_type, mr0, v_cl, v_half_cl);
            v_al  := mr1_to_al(memory_type, mr1, v_cl);
            v_cwl := mr2_to_cwl(memory_type, mr2, v_cl);

            v_rl  := v_cl + v_al;
            v_wl  := v_cwl + v_al;

            if v_debug then
                report record_report_prefix & "Extracted MR parameters" & LF &
                                              "CAS = " & integer'image(v_cl) & LF &
                                              "CWL = " & integer'image(v_cwl) & LF &
                                              "AL  = " & integer'image(v_al) & LF;
            end if;

            -- ----------------------------------------
            -- apply per family, memory type and dwidth_ratio static setup
            -- ----------------------------------------
            if is_siii(family_id) then
                v_output := siii_family_settings(dwidth_ratio, memory_type, pll_steps);
            elsif is_ciii(family_id) then
                v_output := ciii_family_settings(dwidth_ratio, memory_type, pll_steps);
            elsif is_aii(family_id) then
                v_output := aii_family_settings(dwidth_ratio, memory_type, pll_steps);
            elsif is_sii(family_id) then
                v_output := sii_family_settings(dwidth_ratio, memory_type, pll_steps);
            end if;

            -- ----------------------------------------
            -- correct for different cwl, cl and al settings
            -- ----------------------------------------

            if memory_type = "DDR" then
                v_delta_rl := v_rl - c_ddr_default_rl;
                v_delta_wl := v_wl - c_ddr_default_wl;
            elsif memory_type = "DDR2" then
                v_delta_rl := v_rl - c_ddr2_default_rl;
                v_delta_wl := v_wl - c_ddr2_default_wl;
            else -- DDR3
                v_delta_rl := v_rl - c_ddr3_default_rl;
                v_delta_wl := v_wl - c_ddr3_default_wl;
            end if;

            if v_debug then
                report record_report_prefix & "Extracted memory latency (and delta from default)" & LF &
                                              "RL = " & integer'image(v_rl) & LF &
                                              "WL = " & integer'image(v_wl) & LF &
                                              "delta RL = " & integer'image(v_delta_rl) & LF &
                                              "delta WL = " & integer'image(v_delta_wl) & LF;
            end if;

            if dwidth_ratio = 2 then

                -- adjust rdp settings
                v_output.rlat    := v_output.rlat    + v_delta_rl;
                v_output.rdv_lat := v_output.rdv_lat - v_delta_rl;
                v_output.poa_lat := v_output.poa_lat - v_delta_rl;

                -- adjust wdp settings
                v_output.wlat    := v_output.wlat + v_delta_wl;

            elsif dwidth_ratio = 4 then

                -- adjust wdp settings
                v_output.wlat := v_output.wlat + v_delta_wl/2;

                if is_odd(v_delta_wl) then  -- add / sub 1t write latency

                    -- toggle ac_1t in all cases
                    v_output.ac_1t := not v_output.ac_1t;

                    if v_delta_wl < 0 then -- sub 1 from latency

                        if v_output.ac_1t = '0' then  -- phy_clk cc boundary
                            v_output.wlat := v_output.wlat - 1;
                        end if;

                    else -- add 1 to latency

                        if v_output.ac_1t = '1' then -- phy_clk cc boundary
                            v_output.wlat := v_output.wlat + 1;
                        end if;

                    end if;

                    -- update read latency
                    if v_output.ac_1t = '1' then  -- added 1t to address/command so inc read_lat
                        v_delta_rl := v_delta_rl + 1;
                    else -- subtracted 1t from address/command so dec read_lat
                        v_delta_rl := v_delta_rl - 1;
                    end if;

                end if;


                -- adjust rdp settings
                v_output.rlat    := v_output.rlat    + v_delta_rl/2;

                v_output.rdv_lat := v_output.rdv_lat - v_delta_rl;
                v_output.poa_lat := v_output.poa_lat - v_delta_rl;

                if memory_type = "DDR3" then
                    if is_odd(v_delta_rl) xor is_odd(v_delta_wl) then

                        if is_aii(family_id) then
                            v_output.rdv_lat := v_output.rdv_lat - 1;
                            v_output.poa_lat := v_output.poa_lat - 1;
                        else
                            v_output.rdv_lat := v_output.rdv_lat + 1;
                            v_output.poa_lat := v_output.poa_lat + 1;
                        end if;

                    end if;

                end if;

                if is_odd(v_delta_rl) then

                    if v_delta_rl > 0 then -- add 1t

                        if v_output.codvw_phase < pll_steps then
                            v_output.codvw_phase := v_output.codvw_phase + pll_steps;
                        else
                            v_output.codvw_phase := v_output.codvw_phase - pll_steps;
                            v_output.rlat        := v_output.rlat + 1;
                        end if;

                    else -- subtract 1t

                        if v_output.codvw_phase < pll_steps then
                            v_output.codvw_phase := v_output.codvw_phase + pll_steps;
                            v_output.rlat        := v_output.rlat - 1;
                        else
                            v_output.codvw_phase := v_output.codvw_phase - pll_steps;
                        end if;

                    end if;

                end if;

            end if;

            if v_half_cl = '1' and is_ciii(family_id) then
                v_output.codvw_phase := v_output.codvw_phase - pll_steps/2;
            end if;

        end if;

        return v_output;

    end function;

    --
END ddr3_int_phy_alt_mem_phy_record_pkg;
--/* Legal Notice: (C)2006 Altera Corporation. All rights reserved.  Your
--   use of Altera Corporation's design tools, logic functions and other
--   software and tools, and its AMPP partner logic functions, and any
--   output files any of the foregoing (including device programming or
--   simulation files), and any associated documentation or information are
--   expressly subject to the terms and conditions of the Altera Program
--   License Subscription Agreement or other applicable license agreement,
--   including, without limitation, that your use is for the sole purpose
--   of programming logic devices manufactured by Altera and sold by Altera
--   or its authorized distributors.  Please refer to the applicable
--   agreement for further details. */

--

-- -----------------------------------------------------------------------------
--  Abstract        : address and command package, shared between all variations of
--                    the AFI sequencer
--                    The address and command package (alt_mem_phy_addr_cmd_pkg) is
--                    used to combine DRAM address and command signals in one record
--                    and unify the functions operating on this record.
--
--
-- -----------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

--
package ddr3_int_phy_alt_mem_phy_addr_cmd_pkg is

    -- the following are bounds on the maximum range of address and command signals
    constant c_max_addr_bits      : natural := 15;
    constant c_max_ba_bits        : natural := 3;
    constant c_max_ranks          : natural := 16;
    constant c_max_mode_reg_bit   : natural := 12;
    constant c_max_cmds_per_clk   : natural := 4;  -- quarter rate

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant ac_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (addr_cmd_pkg) : ";

-- -------------------------------------------------------------
-- this record represents a single mem_clk command cycle
-- -------------------------------------------------------------
    type t_addr_cmd is record
        addr  : natural range 0 to 2**c_max_addr_bits - 1;
        ba    : natural range 0 to 2**c_max_ba_bits   - 1;
        cas_n : boolean;
        ras_n : boolean;
        we_n  : boolean;
        cke   : natural range 0 to 2**c_max_ranks - 1;     -- bounded max of 8 ranks
        cs_n  : natural range 2**c_max_ranks - 1 downto 0; -- bounded max of 8 ranks
        odt   : natural range 0 to 2**c_max_ranks - 1;     -- bounded max of 8 ranks
        rst_n : boolean;
    end record t_addr_cmd;

-- -------------------------------------------------------------
-- this vector is used to describe the fact that for slower clock domains
-- mutiple commands per clock can be issued and encapsulates all these options in a
-- type which can scale with rate
-- -------------------------------------------------------------
    type t_addr_cmd_vector is array (natural range <>) of t_addr_cmd;

-- -------------------------------------------------------------
-- this record is used to define the memory interface type and allow packing and checking
-- (it should be used as a generic to a entity or from a poject level constant)
-- -------------------------------------------------------------

    -- enumeration for mem_type
    type t_mem_type is
        (
            DDR,
            DDR2,
            DDR3
        );

    -- memory interface configuration parameters
    type t_addr_cmd_config_rec is record
        num_addr_bits : natural;
        num_ba_bits   : natural;
        num_cs_bits   : natural;
        num_ranks     : natural;
        cmds_per_clk  : natural range 1 to c_max_cmds_per_clk;  -- commands per clock cycle (equal to DWIDTH_RATIO/2)
        mem_type      : t_mem_type;
    end record;

-- -----------------------------------
-- the following type is used to switch between signals
-- (for example, in the mask function below)
-- -----------------------------------
    type t_addr_cmd_signals is
        (
           addr,
           ba,
           cas_n,
           ras_n,
           we_n,
           cke,
           cs_n,
           odt,
           rst_n
        );

-- -----------------------------------
-- odt record
-- to hold the odt settings
-- (an odt_record) per rank (in odt_array)
-- -----------------------------------
    type t_odt_record is record
        write : natural;
        read  : natural;
    end record t_odt_record;
    type t_odt_array is array (natural range <>) of t_odt_record;

-- -------------------------------------------------------------
-- exposed functions and procedures
--
-- these functions cover the following memory types:
-- DDR3, DDR2, DDR
--
-- and the following operations:
-- MRS, REF, PRE, PREA, ACT,
-- WR, WRS8, WRS4, WRA, WRAS8, WRAS4,
-- RD, RDS8, RDS4, RDA, RDAS8, RDAS4,
--
-- for DDR3 on the fly burst length setting for reads/writes
-- is supported
-- -------------------------------------------------------------

    function defaults               ( config_rec           : in    t_addr_cmd_config_rec
                                    ) return                       t_addr_cmd_vector;

    function reset                  ( config_rec           : in    t_addr_cmd_config_rec
                                    ) return                       t_addr_cmd_vector;

    function int_pup_reset          ( config_rec           : in    t_addr_cmd_config_rec
                                    ) return                       t_addr_cmd_vector;

    function deselect               ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector
                                    ) return                       t_addr_cmd_vector;

    function precharge_all          ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function precharge_all          ( config_rec           : in    t_addr_cmd_config_rec;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function precharge_bank         ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1;
                                      bank                 : in    natural range 0 to 2**c_max_ba_bits -1
                                    ) return                       t_addr_cmd_vector;

    function activate               ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      bank                 : in    natural range 0 to 2**c_max_ba_bits -1;
                                      row                  : in    natural range 0 to 2**c_max_addr_bits -1;
                                      ranks                : in    natural range 0 to 2**c_max_ranks - 1
                                    ) return                       t_addr_cmd_vector;

    function write                  ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      bank                 : in    natural range 0 to 2**c_max_ba_bits -1;
                                      col                  : in    natural range 0 to 2**c_max_addr_bits -1;
                                      ranks                : in    natural range 0 to 2**c_max_ranks - 1;
                                      op_length            : in    natural range 1 to 8;
                                      auto_prech           : in    boolean
                                    ) return                       t_addr_cmd_vector;

    function read                   ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      bank                 : in    natural range 0 to 2**c_max_ba_bits -1;
                                      col                  : in    natural range 0 to 2**c_max_addr_bits -1;
                                      ranks                : in    natural range 0 to 2**c_max_ranks - 1;
                                      op_length            : in    natural range 1 to 8;
                                      auto_prech           : in    boolean
                                    ) return                       t_addr_cmd_vector;

    function refresh                ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function self_refresh_entry     ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function load_mode              ( config_rec           : in    t_addr_cmd_config_rec;
                                      mode_register_num    : in    natural range 0 to 3;
                                      mode_reg_value       : in    std_logic_vector(c_max_mode_reg_bit downto 0);
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1;
                                      remap_addr_and_ba    : in    boolean
                                    ) return                       t_addr_cmd_vector;

    function dll_reset              ( config_rec           : in    t_addr_cmd_config_rec;
                                      mode_reg_val         : in    std_logic_vector;
                                      rank_num             : in    natural range 0 to 2**c_max_ranks - 1;
                                      reorder_addr_bits    : in    boolean
                                    ) return                       t_addr_cmd_vector;

    function enter_sr_pd_mode       ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function maintain_pd_or_sr      ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function exit_sr_pd_mode        ( config_rec           : in    t_addr_cmd_config_rec;
                                      previous             : in    t_addr_cmd_vector;
                                      ranks                : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function ZQCS                   ( config_rec           : in    t_addr_cmd_config_rec;
                                      rank                 : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function ZQCL                   ( config_rec           : in    t_addr_cmd_config_rec;
                                      rank                 : in    natural range 0 to 2**c_max_ranks -1
                                    ) return                       t_addr_cmd_vector;

    function all_unreversed_ranks   ( config_rec           : in    t_addr_cmd_config_rec;
                                      record_to_mask       : in    t_addr_cmd_vector;
                                      mem_ac_swapped_ranks : in    std_logic_vector
                                    ) return                       t_addr_cmd_vector;

    function all_reversed_ranks     ( config_rec           : in    t_addr_cmd_config_rec;
                                      record_to_mask       : in    t_addr_cmd_vector;
                                      mem_ac_swapped_ranks : in    std_logic_vector
                                    ) return                       t_addr_cmd_vector;
    
    function program_rdimm_register ( config_rec           : in    t_addr_cmd_config_rec;
                                      control_word_addr		 : in std_logic_vector(3 downto 0);
                                      control_word_data  	 : in std_logic_vector(3 downto 0)
                                    ) return                       t_addr_cmd_vector;

-- -------------------------------------------------------------
-- the following function sets up the odt settings
-- NOTES: currently only supports DDR/DDR2 memories
-- -------------------------------------------------------------

    -- odt setting as implemented in the altera high-performance controller for ddr2 memories
    function set_odt_values (ranks          : natural;
                             ranks_per_slot : natural;
                             mem_type      : in string
                            ) return          t_odt_array;

-- -------------------------------------------------------------
-- the following function enables assignment to the constant config_rec
-- -------------------------------------------------------------
    function set_config_rec ( num_addr_bits     : in    natural;
                              num_ba_bits       : in    natural;
                              num_cs_bits       : in    natural;
                              num_ranks         : in    natural;
                              dwidth_ratio      : in    natural range 1 to c_max_cmds_per_clk;
                              mem_type          : in    string
                              ) return                  t_addr_cmd_config_rec;
                              

-- The non-levelled sequencer doesn't make a distinction between CS_WIDTH and NUM_RANKS. In this case,
-- just set the two to be the same.
    function set_config_rec ( num_addr_bits     : in    natural;
                              num_ba_bits       : in    natural;
                              num_cs_bits       : in    natural;
                              dwidth_ratio      : in    natural range 1 to c_max_cmds_per_clk;
                              mem_type          : in    string
                              ) return                  t_addr_cmd_config_rec;


-- -------------------------------------------------------------
-- the following function and procedure unpack address and
-- command signals from the t_addr_cmd_vector format
-- -------------------------------------------------------------

    procedure unpack_addr_cmd_vector( addr_cmd_vector : in t_addr_cmd_vector;
                                      config_rec      : in t_addr_cmd_config_rec;
                                      addr            : out std_logic_vector;
                                      ba              : out std_logic_vector;
                                      cas_n           : out std_logic_vector;
                                      ras_n           : out std_logic_vector;
                                      we_n            : out std_logic_vector;
                                      cke             : out std_logic_vector;
                                      cs_n            : out std_logic_vector;
                                      odt             : out std_logic_vector;
                                      rst_n           : out std_logic_vector);


    procedure unpack_addr_cmd_vector( config_rec      : in t_addr_cmd_config_rec;
                                      addr_cmd_vector : in t_addr_cmd_vector;
                               signal addr            : out std_logic_vector;
                               signal ba              : out std_logic_vector;
                               signal cas_n           : out std_logic_vector;
                               signal ras_n           : out std_logic_vector;
                               signal we_n            : out std_logic_vector;
                               signal cke             : out std_logic_vector;
                               signal cs_n            : out std_logic_vector;
                               signal odt             : out std_logic_vector;
                               signal rst_n           : out std_logic_vector);

-- -------------------------------------------------------------
-- the following functions perform bit masking to 0 or 1 (as
-- specified by mask_value) to a chosen address/command signal (signal_name)
-- across all signal bits or to a selected bit (mask_bit)
-- -------------------------------------------------------------

    -- mask all signal bits procedure
    function mask  ( config_rec            : in    t_addr_cmd_config_rec;
                     addr_cmd_vector       : in    t_addr_cmd_vector;
                     signal_name           : in    t_addr_cmd_signals;
                     mask_value            : in    std_logic) return t_addr_cmd_vector;

    procedure mask(        config_rec      : in    t_addr_cmd_config_rec;
                    signal addr_cmd_vector : inout t_addr_cmd_vector;
                           signal_name     : in    t_addr_cmd_signals;
                           mask_value      : in    std_logic);

    -- mask signal bit (mask_bit) procedure
    function mask  ( config_rec            : in    t_addr_cmd_config_rec;
                     addr_cmd_vector       : in    t_addr_cmd_vector;
                     signal_name           : in    t_addr_cmd_signals;
                     mask_value            : in    std_logic;
                     mask_bit              : in    natural) return t_addr_cmd_vector;

--
end ddr3_int_phy_alt_mem_phy_addr_cmd_pkg;


--
package body ddr3_int_phy_alt_mem_phy_addr_cmd_pkg IS

-- -------------------------------------------------------------
-- Basic functions for a single command
-- -------------------------------------------------------------

    -- -------------------------------------------------------------
    -- defaults the bus                   no JEDEC abbreviated name
    -- -------------------------------------------------------------
    function defaults ( config_rec : in    t_addr_cmd_config_rec
                      ) return             t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin

        v_retval.addr  := 0;
        v_retval.ba    := 0;
        v_retval.cas_n := false;
        v_retval.ras_n := false;
        v_retval.we_n  := false;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1;
        v_retval.odt   := 0;
        v_retval.rst_n := false;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- resets the addr/cmd signal         (Same as default with cke and rst_n 0 )
    -- -------------------------------------------------------------
    function reset    ( config_rec : in    t_addr_cmd_config_rec
                      ) return             t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin

        v_retval       := defaults(config_rec);
        v_retval.cke   := 0;
        if config_rec.mem_type = DDR3 then
            v_retval.rst_n := true;
        end if;
        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues deselect (command)         JEDEC abbreviated name: DES
    -- -------------------------------------------------------------
    function deselect ( config_rec : in    t_addr_cmd_config_rec;
                        previous   : in    t_addr_cmd
                      ) return             t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin

        v_retval := previous;

        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.rst_n := false;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a precharge all command     JEDEC abbreviated name: PREA
    -- -------------------------------------------------------------
    function precharge_all( config_rec : in    t_addr_cmd_config_rec;
                            previous   : in    t_addr_cmd;
                            ranks      : in    natural range 0 to 2**c_max_ranks -1
                          ) return             t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
        variable v_addr     : unsigned( c_max_addr_bits -1 downto 0);
    begin

        v_retval       := previous;

        v_addr         := to_unsigned(previous.addr, c_max_addr_bits);
        v_addr(10)     := '1'; -- set AP bit high
        v_retval.addr  := to_integer(v_addr);

        v_retval.ras_n := true;
        v_retval.cas_n := false;
        v_retval.we_n  := true;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) - 1 - ranks;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.rst_n := false;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- precharge (close) a bank           JEDEC abbreviated name: PRE
    -- -------------------------------------------------------------
    function precharge_bank( config_rec : in    t_addr_cmd_config_rec;
                             previous   : in    t_addr_cmd;
                             ranks      : in    natural range 0 to 2**c_max_ranks -1;
                             bank       : in    natural range 0 to 2**c_max_ba_bits -1
                           ) return             t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
        variable v_addr     : unsigned( c_max_addr_bits -1 downto 0);
    begin

        v_retval       := previous;

        v_addr         := to_unsigned(previous.addr, c_max_addr_bits);
        v_addr(10)     := '0'; -- set AP bit low
        v_retval.addr  := to_integer(v_addr);

        v_retval.ba    := bank;

        v_retval.ras_n := true;
        v_retval.cas_n := false;
        v_retval.we_n  := true;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) - ranks;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.rst_n := false;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- Issues a activate (open row)       JEDEC abbreviated name: ACT
    -- -------------------------------------------------------------
    function activate (config_rec : in    t_addr_cmd_config_rec;
                       previous   : in    t_addr_cmd;
                       bank       : in    natural range 0 to 2**c_max_ba_bits - 1;
                       row        : in    natural range 0 to 2**c_max_addr_bits - 1;
                       ranks      : in    natural range 0 to 2**c_max_ranks - 1
                      ) return            t_addr_cmd
    is
        variable v_retval : t_addr_cmd;
    begin

        v_retval.addr  := row;
        v_retval.ba    := bank;
        v_retval.cas_n := false;
        v_retval.ras_n := true;
        v_retval.we_n  := false;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - ranks;
        v_retval.odt   := previous.odt;
        v_retval.rst_n := false;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- issues a write command     JEDEC abbreviated name:WR,   WRA
    --                                                   WRS4, WRAS4
    --                                                   WRS8, WRAS8
    -- has the ability to support:
    --   DDR3:
    --      BL4, BL8, fixed BL
    --      Auto Precharge (AP)
    --   DDR2, DDR:
    --      fixed BL
    --      Auto Precharge (AP)
    -- -------------------------------------------------------------
    function write    (config_rec : in    t_addr_cmd_config_rec;
                       previous   : in    t_addr_cmd;
                       bank       : in    natural range 0 to 2**c_max_ba_bits -1;
                       col        : in    natural range 0 to 2**c_max_addr_bits -1;
                       ranks      : in    natural range 0 to 2**c_max_ranks -1;
                       op_length  : in    natural range 1 to 8;
                       auto_prech : in    boolean
                      ) return            t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
        variable v_addr     : unsigned(c_max_addr_bits-1 downto 0);
    begin

        -- calculate correct address signal
        v_addr := to_unsigned(col, c_max_addr_bits);

        -- note pin A10 is used for AP, therfore shift the value from A10 onto A11.
        v_retval.addr  := to_integer(v_addr(9 downto 0));

        if v_addr(10) = '1' then
            v_retval.addr := v_retval.addr + 2**11;
        end if;

        if auto_prech = true then  -- set AP bit (A10)
            v_retval.addr := v_retval.addr + 2**10;
        end if;

        if config_rec.mem_type = DDR3 then

            if    op_length = 8 then  -- set BL_OTF sel bit (A12)
                v_retval.addr  := v_retval.addr + 2**12;
            elsif op_length = 4 then
                null;
            else
                report ac_report_prefix & "DDR3 DRAM only supports writes of burst length 4 or 8, the requested length was: " & integer'image(op_length) severity failure;
            end if;

        elsif config_rec.mem_type = DDR2 or config_rec.mem_type = DDR then

           null;

        else
            report ac_report_prefix & "only DDR memories are supported for memory writes" severity failure;
        end if;

        -- set a/c signal assignments for write
        v_retval.ba    := bank;
        v_retval.cas_n := true;
        v_retval.ras_n := false;
        v_retval.we_n  := true;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - ranks;
        v_retval.odt   := ranks;
        v_retval.rst_n := false;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a read command    JEDEC abbreviated name: RD,   RDA
    --                                                  RDS4, RDAS4
    --                                                  RDS8, RDAS8
    -- has the ability to support:
    --   DDR3:
    --      BL4, BL8, fixed BL
    --      Auto Precharge (AP)
    --   DDR2, DDR:
    --      fixed BL, Auto Precharge (AP)
    -- -------------------------------------------------------------
    function read     (config_rec : in    t_addr_cmd_config_rec;
                       previous   : in    t_addr_cmd;
                       bank       : in    natural range 0 to 2**c_max_ba_bits -1;
                       col        : in    natural range 0 to 2**c_max_addr_bits -1;
                       ranks      : in    natural range 0 to 2**c_max_ranks -1;
                       op_length  : in    natural range 1 to 8;
                       auto_prech : in    boolean
                      ) return            t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
        variable v_addr     : unsigned(c_max_addr_bits-1 downto 0);
    begin

        -- calculate correct address signal
        v_addr := to_unsigned(col, c_max_addr_bits);

        -- note pin A10 is used for AP, therfore shift the value from A10 onto A11.
        v_retval.addr  := to_integer(v_addr(9 downto 0));

        if v_addr(10) = '1' then
            v_retval.addr := v_retval.addr + 2**11;
        end if;

        if auto_prech = true then  -- set AP bit (A10)
            v_retval.addr := v_retval.addr + 2**10;
        end if;

        if config_rec.mem_type = DDR3 then

            if    op_length = 8 then  -- set BL_OTF sel bit (A12)
                v_retval.addr  := v_retval.addr + 2**12;
            elsif op_length = 4 then
                null;
            else
                report ac_report_prefix & "DDR3 DRAM only supports reads of burst length 4 or 8" severity failure;
            end if;

        elsif config_rec.mem_type = DDR2 or config_rec.mem_type = DDR then

           null;

        else
            report ac_report_prefix & "only DDR memories are supported for memory reads" severity failure;
        end if;

        -- set a/c signals for read command
        v_retval.ba    := bank;
        v_retval.cas_n := true;
        v_retval.ras_n := false;
        v_retval.we_n  := false;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - ranks;
        v_retval.odt   := 0;
        v_retval.rst_n := false;
        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a refresh command           JEDEC abbreviated name: REF
    -- -------------------------------------------------------------
    function refresh (config_rec : in    t_addr_cmd_config_rec;
                      previous   : in    t_addr_cmd;
                      ranks      : in    natural range 0 to 2**c_max_ranks -1
                     )
                     return              t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin

        v_retval := previous;

        v_retval.cas_n := true;
        v_retval.ras_n := true;
        v_retval.we_n  := false;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - ranks;
        v_retval.rst_n := false;

        -- addr, BA and ODT are don't care therfore leave as previous value

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- issues a mode register set command JEDEC abbreviated name: MRS
    -- -------------------------------------------------------------
    function load_mode ( config_rec        : in    t_addr_cmd_config_rec;
                         mode_register_num : in    natural range 0 to 3;
                         mode_reg_value    : in    std_logic_vector(c_max_mode_reg_bit downto 0);
                         ranks             : in    natural range 0 to 2**c_max_ranks -1;
                         remap_addr_and_ba : in    boolean
                       ) return                    t_addr_cmd
    is
        variable v_retval     : t_addr_cmd;
        variable v_addr_remap : unsigned(c_max_mode_reg_bit downto 0);
    begin

        v_retval.cas_n := true;
        v_retval.ras_n := true;
        v_retval.we_n  := true;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - ranks;
        v_retval.odt   := 0;
        v_retval.rst_n := false;

        v_retval.ba    := mode_register_num;
        v_retval.addr  := to_integer(unsigned(mode_reg_value));

        if remap_addr_and_ba = true then
            v_addr_remap             := unsigned(mode_reg_value);
            v_addr_remap(8 downto 7) := v_addr_remap(7) & v_addr_remap(8);
            v_addr_remap(6 downto 5) := v_addr_remap(5) & v_addr_remap(6);
            v_addr_remap(4 downto 3) := v_addr_remap(3) & v_addr_remap(4);

            v_retval.addr            := to_integer(v_addr_remap);

            v_addr_remap             := to_unsigned(mode_register_num, c_max_mode_reg_bit + 1);
            v_addr_remap(1 downto 0) := v_addr_remap(0) & v_addr_remap(1);

            v_retval.ba              := to_integer(v_addr_remap);

        end if;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- maintains SR or PD mode on slected ranks.
    -- -------------------------------------------------------------
    function maintain_pd_or_sr  (config_rec : in    t_addr_cmd_config_rec;
                                 previous   : in    t_addr_cmd;
                                 ranks      : in    natural range 0 to 2**c_max_ranks -1
                                )
                                return              t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin
        v_retval     := previous;
        v_retval.cke := (2 ** config_rec.num_ranks) - 1 - ranks;
        return v_retval;
    end function;


    -- -------------------------------------------------------------
    -- issues a ZQ cal (short)          JEDEC abbreviated name: ZQCS
    -- NOTE - can only be issued to a single RANK at a time.
    -- -------------------------------------------------------------
    function ZQCS (config_rec : in    t_addr_cmd_config_rec;
                   rank       : in    natural range 0 to 2**c_max_ranks -1
                  )
                  return              t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin


        v_retval.cas_n := false;
        v_retval.ras_n := false;
        v_retval.we_n  := true;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - rank;
        v_retval.rst_n := false;

        v_retval.addr  := 0; -- clear bit 10
        v_retval.ba    := 0;
        v_retval.odt   := 0;
        return v_retval;

    end function;



    -- -------------------------------------------------------------
    -- issues a ZQ cal (long)           JEDEC abbreviated name: ZQCL
    -- NOTE - can only be issued to a single RANK at a time.
    -- -------------------------------------------------------------
    function ZQCL (config_rec : in    t_addr_cmd_config_rec;
                   rank       : in    natural range 0 to 2**c_max_ranks -1
                  )
                  return              t_addr_cmd
    is
        variable v_retval   : t_addr_cmd;
    begin

        v_retval.cas_n := false;
        v_retval.ras_n := false;
        v_retval.we_n  := true;
        v_retval.cke   := (2 ** config_rec.num_ranks) -1;
        v_retval.cs_n  := (2 ** config_rec.num_cs_bits) -1 - rank;
        v_retval.rst_n := false;

        v_retval.addr  := 1024; -- set bit 10
        v_retval.ba    := 0;
        v_retval.odt   := 0;
        return v_retval;

    end function;


-- -------------------------------------------------------------
-- functions acting on all clock cycles from whatever rate
--  in halfrate clock domain issues 1 command per clock
--  in quarter rate issues 1 command per clock
--     In the above cases they will be correctly aligned using the
--       ALTMEMPHY 2T and 4T SDC
-- -------------------------------------------------------------

    -- -------------------------------------------------------------
    -- defaults the bus                   no JEDEC abbreviated name
    -- -------------------------------------------------------------
    function defaults (config_rec : in    t_addr_cmd_config_rec
                      ) return            t_addr_cmd_vector
    is
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        v_retval := (others => defaults(config_rec));

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- resets the addr/cmd signal         (same as default with cke 0)
    -- -------------------------------------------------------------
    function reset    (config_rec : in    t_addr_cmd_config_rec
                      ) return            t_addr_cmd_vector
    is
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        v_retval := (others => reset(config_rec));

        return v_retval;

    end function;

    function int_pup_reset (config_rec : in    t_addr_cmd_config_rec
                      ) return            t_addr_cmd_vector
    is
        variable v_addr_cmd_config_rst : t_addr_cmd_config_rec;
    begin

        v_addr_cmd_config_rst           := config_rec;
        v_addr_cmd_config_rst.num_ranks := c_max_ranks;

        return reset(v_addr_cmd_config_rst);

    end function;

    -- -------------------------------------------------------------
    -- issues a deselect command          JEDEC abbreviated name: DES
    -- -------------------------------------------------------------
    function deselect ( config_rec : in    t_addr_cmd_config_rec;
                        previous   : in    t_addr_cmd_vector
                      ) return             t_addr_cmd_vector
    is
        alias    a_previous : t_addr_cmd_vector(previous'range) is previous;
        variable v_retval   : t_addr_cmd_vector(a_previous'range);
    begin

        for rate in a_previous'range loop
            v_retval(rate) := deselect(config_rec, a_previous(a_previous'high));
        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a precharge all command     JEDEC abbreviated name: PREA
    -- -------------------------------------------------------------
    function precharge_all ( config_rec : in    t_addr_cmd_config_rec;
                             previous   : in    t_addr_cmd_vector;
                             ranks      : in    natural range 0 to 2**c_max_ranks -1
                           ) return             t_addr_cmd_vector
    is
        alias    a_previous : t_addr_cmd_vector(previous'range) is previous;
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for rate in  a_previous'range loop

            v_retval(rate)  := precharge_all(config_rec, previous(a_previous'high), ranks);

            -- use dwidth_ratio/2 as in FR = 0 , HR = 1, and in future QR = 2 tCK setup + 1 tCK hold
            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;

        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- precharge (close) a bank           JEDEC abbreviated name: PRE
    -- -------------------------------------------------------------
    function precharge_bank ( config_rec : in    t_addr_cmd_config_rec;
                              previous   : in    t_addr_cmd_vector;
                              ranks      : in    natural range 0 to 2**c_max_ranks -1;
                              bank       : in    natural range 0 to 2**c_max_ba_bits -1
                            ) return             t_addr_cmd_vector
    is
        alias    a_previous : t_addr_cmd_vector(previous'range) is previous;
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for rate in  a_previous'range loop

            v_retval(rate)  := precharge_bank(config_rec, previous(a_previous'high), ranks, bank);

            -- use dwidth_ratio/2 as in FR = 0 , HR = 1, and in future QR = 2 tCK setup + 1 tCK hold
            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;

        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a activate (open row)       JEDEC abbreviated name: ACT
    -- -------------------------------------------------------------
    function activate ( config_rec : in    t_addr_cmd_config_rec;
                        previous   : in    t_addr_cmd_vector;
                        bank       : in    natural range 0 to 2**c_max_ba_bits -1;
                        row        : in    natural range 0 to 2**c_max_addr_bits -1;
                        ranks      : in    natural range 0 to 2**c_max_ranks - 1
                      ) return             t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for rate in previous'range loop
            v_retval(rate)  := activate(config_rec, previous(previous'high), bank, row, ranks);

            -- use dwidth_ratio/2 as in FR = 0 , HR = 1, and in future QR = 2 tCK setup + 1 tCK hold
            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;

        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a write command     JEDEC abbreviated name:WR,   WRA
    --                                                   WRS4, WRAS4
    --                                                   WRS8, WRAS8
    --
    -- has the ability to support:
    --   DDR3:
    --      BL4, BL8, fixed BL
    --      Auto Precharge (AP)
    --   DDR2, DDR:
    --      fixed BL
    --      Auto Precharge (AP)
    -- -------------------------------------------------------------
    function write ( config_rec : in    t_addr_cmd_config_rec;
                     previous   : in    t_addr_cmd_vector;
                     bank       : in    natural range 0 to 2**c_max_ba_bits -1;
                     col        : in    natural range 0 to 2**c_max_addr_bits -1;
                     ranks      : in    natural range 0 to 2**c_max_ranks - 1;
                     op_length  : in    natural range 1 to 8;
                     auto_prech : in    boolean
                   ) return             t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for rate in previous'range loop
            v_retval(rate)  := write(config_rec, previous(previous'high), bank, col, ranks, op_length, auto_prech);

            -- use dwidth_ratio/2 as in FR = 0 , HR = 1, and in future QR = 2 tCK setup + 1 tCK hold
            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;

        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a read command    JEDEC abbreviated name: RD,   RDA
    --                                                  RDS4, RDAS4
    --                                                  RDS8, RDAS8
    -- has the ability to support:
    --   DDR3:
    --      BL4, BL8, fixed BL
    --      Auto Precharge (AP)
    --   DDR2, DDR:
    --      fixed BL, Auto Precharge (AP)
    -- -------------------------------------------------------------
    function read  ( config_rec : in    t_addr_cmd_config_rec;
                     previous   : in    t_addr_cmd_vector;
                     bank       : in    natural range 0 to 2**c_max_ba_bits -1;
                     col        : in    natural range 0 to 2**c_max_addr_bits -1;
                     ranks      : in    natural range 0 to 2**c_max_ranks - 1;
                     op_length  : in    natural range 1 to 8;
                     auto_prech : in    boolean
                   ) return             t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for rate in previous'range loop
            v_retval(rate)  := read(config_rec, previous(previous'high), bank, col, ranks, op_length, auto_prech);

            -- use dwidth_ratio/2 as in FR = 0 , HR = 1, and in future QR = 2 tCK setup + 1 tCK hold
            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;

        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a refresh command           JEDEC abbreviated name: REF
    -- -------------------------------------------------------------
    function refresh (config_rec : in    t_addr_cmd_config_rec;
                      previous   : in    t_addr_cmd_vector;
                      ranks      : in    natural range 0 to 2**c_max_ranks -1
                     )return             t_addr_cmd_vector
    is
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for rate in previous'range loop
            v_retval(rate) := refresh(config_rec, previous(previous'high), ranks);

            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;

        end loop;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- issues a self_refresh_entry command  JEDEC abbreviated name: SRE
    -- -------------------------------------------------------------
    function self_refresh_entry (config_rec : in    t_addr_cmd_config_rec;
                                 previous   : in    t_addr_cmd_vector;
                                 ranks      : in    natural range 0 to 2**c_max_ranks -1
                                )return             t_addr_cmd_vector
    is
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin
        v_retval := enter_sr_pd_mode(config_rec, refresh(config_rec, previous, ranks), ranks);
        return v_retval;
    end function;



    -- -------------------------------------------------------------
    -- issues a self_refresh exit or power_down exit command
    --  JEDEC abbreviated names: SRX, PDX
    -- -------------------------------------------------------------
    function exit_sr_pd_mode    ( config_rec : in    t_addr_cmd_config_rec;
                                  previous   : in    t_addr_cmd_vector;
                                  ranks      : in    natural range 0 to 2**c_max_ranks -1
                                ) return             t_addr_cmd_vector
    is
        variable v_retval          : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
        variable v_mask_workings   : std_logic_vector(config_rec.num_ranks -1 downto 0);
        variable v_mask_workings_b : std_logic_vector(config_rec.num_ranks -1 downto 0);
    begin

        v_retval := maintain_pd_or_sr(config_rec, previous, ranks);
        v_mask_workings_b := std_logic_vector(to_unsigned(ranks, config_rec.num_ranks));

        for rate in 0 to config_rec.cmds_per_clk - 1 loop

            v_mask_workings   := std_logic_vector(to_unsigned(v_retval(rate).cke, config_rec.num_ranks));

            for i in v_mask_workings_b'range loop
                v_mask_workings(i) := v_mask_workings(i) or v_mask_workings_b(i);
            end loop;

            if rate >= config_rec.cmds_per_clk / 2 then    -- maintain command but clear CS of subsequenct command slots
                v_retval(rate).cke  := to_integer(unsigned(v_mask_workings));  -- almost irrelevant. but optimises logic slightly for Quater rate
            end if;
        end loop;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- cause the selected ranks to enter Self-refresh or Powerdown mode
    --  JEDEC abbreviated names: PDE,
    --                           SRE  (if a refresh is concurrently issued to the same ranks)
    -- -------------------------------------------------------------
    function enter_sr_pd_mode   ( config_rec : in    t_addr_cmd_config_rec;
                                  previous   : in    t_addr_cmd_vector;
                                  ranks      : in    natural range 0 to 2**c_max_ranks -1
                                ) return             t_addr_cmd_vector
    is
        variable v_retval          : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
        variable v_mask_workings   : std_logic_vector(config_rec.num_ranks -1 downto 0);
        variable v_mask_workings_b : std_logic_vector(config_rec.num_ranks -1 downto 0);
    begin

        v_retval          := previous;
        v_mask_workings_b := std_logic_vector(to_unsigned(ranks, config_rec.num_ranks));

        for rate in 0 to config_rec.cmds_per_clk - 1 loop

            if rate >= config_rec.cmds_per_clk / 2 then    -- maintain command but clear CS of subsequenct command slots
                v_mask_workings   := std_logic_vector(to_unsigned(v_retval(rate).cke, config_rec.num_ranks));

                for i in v_mask_workings_b'range loop
                    v_mask_workings(i) := v_mask_workings(i) and not v_mask_workings_b(i);
                end loop;

                v_retval(rate).cke  := to_integer(unsigned(v_mask_workings));  -- almost irrelevant. but optimises logic slightly for Quater rate

            end if;

        end loop;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- Issues a mode register set command   JEDEC abbreviated name: MRS
    -- -------------------------------------------------------------
    function load_mode ( config_rec        : in    t_addr_cmd_config_rec;
                         mode_register_num : in    natural range 0 to 3;
                         mode_reg_value    : in    std_logic_vector(c_max_mode_reg_bit downto 0);
                         ranks             : in    natural range 0 to 2**c_max_ranks -1;
                         remap_addr_and_ba : in    boolean
                       ) return                    t_addr_cmd_vector
    is
        variable v_retval     : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        v_retval := (others => load_mode(config_rec, mode_register_num, mode_reg_value, ranks, remap_addr_and_ba));

        for rate in v_retval'range loop
            if rate /= config_rec.cmds_per_clk/2 then
                v_retval(rate).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;
        end loop;

        return v_retval;

    end function;


    -- -------------------------------------------------------------
    -- maintains SR or PD mode on slected ranks.
    --    NOTE: does not affect previous command
    -- -------------------------------------------------------------
    function maintain_pd_or_sr  ( config_rec : in    t_addr_cmd_config_rec;
                                  previous   : in    t_addr_cmd_vector;
                                  ranks      : in    natural range 0 to 2**c_max_ranks -1
                                ) return             t_addr_cmd_vector
    is
        variable v_retval   : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        for command in v_retval'range loop
            v_retval(command) := maintain_pd_or_sr(config_rec, previous(command), ranks);
        end loop;
        return v_retval;
    end function;


    -- -------------------------------------------------------------
    -- issues a ZQ cal (long)           JEDEC abbreviated name: ZQCL
    -- NOTE - can only be issued to a single RANK ata a time.
    -- -------------------------------------------------------------
    function ZQCL ( config_rec : in    t_addr_cmd_config_rec;
                    rank       : in    natural range 0 to 2**c_max_ranks -1
                  ) return             t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1) := defaults(config_rec);
    begin

        for command in v_retval'range loop
            v_retval(command) := ZQCL(config_rec, rank);
            if command * 2 /= config_rec.cmds_per_clk then
                v_retval(command).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;
        end loop;

        return v_retval;

    end function;

    -- -------------------------------------------------------------
    -- issues a ZQ cal (short)          JEDEC abbreviated name: ZQCS
    -- NOTE - can only be issued to a single RANK ata a time.
    -- -------------------------------------------------------------
    function ZQCS ( config_rec : in    t_addr_cmd_config_rec;
                    rank       : in    natural range 0 to 2**c_max_ranks -1
                  ) return             t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1) := defaults(config_rec);
    begin

        for command in v_retval'range loop
            v_retval(command) := ZQCS(config_rec, rank);
            if command * 2 /= config_rec.cmds_per_clk then
                v_retval(command).cs_n  := (2 ** config_rec.num_cs_bits) -1;
            end if;
        end loop;

        return v_retval;

    end function;


-- ----------------------
-- Additional Rank manipulation functions (main use DDR3)
-- -------------

    -- -----------------------------------
    -- set the chip select for a group of ranks
    -- -----------------------------------
    function all_reversed_ranks    ( config_rec           : in    t_addr_cmd_config_rec;
                                     record_to_mask       : in    t_addr_cmd;
                                     mem_ac_swapped_ranks : in    std_logic_vector
                                   ) return                       t_addr_cmd
    is
        variable v_retval        : t_addr_cmd;
        variable v_mask_workings : std_logic_vector(config_rec.num_cs_bits-1 downto 0);
    begin
        v_retval        := record_to_mask;
        v_mask_workings := std_logic_vector(to_unsigned(record_to_mask.cs_n, config_rec.num_cs_bits));

        for i in mem_ac_swapped_ranks'range loop
            v_mask_workings(i):= v_mask_workings(i) or not mem_ac_swapped_ranks(i);
        end loop;

        v_retval.cs_n   := to_integer(unsigned(v_mask_workings));
        return v_retval;
    end function;

    -- -----------------------------------
    -- inverse of the above
    -- -----------------------------------
    function all_unreversed_ranks  ( config_rec           : in    t_addr_cmd_config_rec;
                                     record_to_mask       : in    t_addr_cmd;
                                     mem_ac_swapped_ranks : in    std_logic_vector
                                   ) return                       t_addr_cmd
    is
        variable v_retval        : t_addr_cmd;
        variable v_mask_workings : std_logic_vector(config_rec.num_cs_bits-1 downto 0);
    begin
        v_retval        := record_to_mask;
        v_mask_workings := std_logic_vector(to_unsigned(record_to_mask.cs_n, config_rec.num_cs_bits));

        for i in mem_ac_swapped_ranks'range loop
            v_mask_workings(i):= v_mask_workings(i) or mem_ac_swapped_ranks(i);
        end loop;

        v_retval.cs_n := to_integer(unsigned(v_mask_workings));
        return v_retval;
    end function;

    -- -----------------------------------
    -- set the chip select for a group of ranks in a way which handles diffrent rates
    -- -----------------------------------
    function all_unreversed_ranks   ( config_rec           : in    t_addr_cmd_config_rec;
                                      record_to_mask       : in    t_addr_cmd_vector;
                                      mem_ac_swapped_ranks : in    std_logic_vector
                                    ) return                       t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1) := defaults(config_rec);
    begin

        for command in record_to_mask'range loop
            v_retval(command) := all_unreversed_ranks(config_rec, record_to_mask(command), mem_ac_swapped_ranks);
        end loop;

        return v_retval;

    end function;

    -- -----------------------------------
    -- inverse of the above handling ranks
    -- -----------------------------------
    function all_reversed_ranks     ( config_rec           : in    t_addr_cmd_config_rec;
                                      record_to_mask       : in    t_addr_cmd_vector;
                                      mem_ac_swapped_ranks : in    std_logic_vector
                                    ) return                       t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1) := defaults(config_rec);
    begin

        for command in record_to_mask'range loop
            v_retval(command) := all_reversed_ranks(config_rec, record_to_mask(command), mem_ac_swapped_ranks);
        end loop;

        return v_retval;

    end function;
    
	-- --------------------------------------------------
	-- Program a single control word onto RDIMM.
	-- This is accomplished rather goofily by asserting all chip selects
	-- and then writing out both the addr/data of the word onto the addr/ba bus
	-- --------------------------------------------------
    
    function program_rdimm_register ( config_rec           : in    t_addr_cmd_config_rec;
                                      control_word_addr		 : in std_logic_vector(3 downto 0);
                                      control_word_data 	 : in std_logic_vector(3 downto 0)
                                    ) return                       t_addr_cmd
    is
    	variable v_retval : t_addr_cmd;
    	variable ba : std_logic_vector(2 downto 0);
    	variable addr : std_logic_vector(4 downto 0);
    begin
			v_retval := defaults(config_rec);
			v_retval.cs_n := 0;
      ba := control_word_addr(3) & control_word_data(3) & control_word_data(2);
			v_retval.ba := to_integer(unsigned(ba));
			addr := control_word_data(1) & control_word_data(0) & control_word_addr(2) &
			                 control_word_addr(1) & control_word_addr(0);
    		v_retval.addr := to_integer(unsigned(addr));		
			return v_retval;
		end function;
		
		function program_rdimm_register ( config_rec           : in    t_addr_cmd_config_rec;
                                      control_word_addr		 : in std_logic_vector(3 downto 0);
                                      control_word_data 	 : in std_logic_vector(3 downto 0)
                                    ) return                       t_addr_cmd_vector
    is
    	variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin
    	v_retval := (others => program_rdimm_register(config_rec, control_word_addr, control_word_data));
    	return v_retval;
    end function;
-- --------------------------------------------------
-- overloaded functions, to simplify use, or provide simplified functionality
-- --------------------------------------------------

    -- ----------------------------------------------------
    -- Precharge all, defaulting all bits.
    -- ----------------------------------------------------
    function precharge_all ( config_rec : in    t_addr_cmd_config_rec;
                             ranks      : in    natural range 0 to 2**c_max_ranks -1
                           ) return             t_addr_cmd_vector
    is
        variable v_retval : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1) := defaults(config_rec);
    begin

        v_retval := precharge_all(config_rec, v_retval, ranks);

        return v_retval;

    end function;


    -- ----------------------------------------------------
    -- perform DLL reset through mode registers
    -- ----------------------------------------------------
    function dll_reset (  config_rec        : in t_addr_cmd_config_rec;
                          mode_reg_val      : in std_logic_vector;
                          rank_num          : in natural range 0 to 2**c_max_ranks - 1;
                          reorder_addr_bits : in boolean
                         ) return t_addr_cmd_vector is
        variable int_mode_reg : std_logic_vector(mode_reg_val'range);
        variable output       : t_addr_cmd_vector(0 to config_rec.cmds_per_clk - 1);
    begin
        int_mode_reg    := mode_reg_val;
        int_mode_reg(8) := '1';   -- set DLL reset bit.
        output          := load_mode(config_rec, 0, int_mode_reg, rank_num, reorder_addr_bits);
        return output;
    end function;


-- -------------------------------------------------------------
-- package configuration functions
-- -------------------------------------------------------------

    -- -------------------------------------------------------------
    -- the following function sets up the odt settings
    -- NOTES: supports DDR/DDR2/DDR3 SDRAM memories
    -- -------------------------------------------------------------
    function set_odt_values (ranks          : natural;
                             ranks_per_slot : natural;
                             mem_type       : in string
                            ) return t_odt_array is

    variable v_num_slots  : natural;
    variable v_cs         : natural range 0 to ranks-1;
    variable v_odt_values : t_odt_array(0 to ranks-1);
    variable v_cs_addr    : unsigned(ranks-1 downto 0);

    begin

        if mem_type = "DDR" then

            -- ODT not supported for DDR memory so set default off
            for v_cs in 0 to ranks-1 loop
                v_odt_values(v_cs).write := 0;
                v_odt_values(v_cs).read  := 0;
            end loop;

        elsif mem_type = "DDR2" then

            -- odt setting as implemented in the altera high-performance controller for ddr2 memories
            assert (ranks rem ranks_per_slot = 0) report ac_report_prefix & "number of ranks per slot must be a multiple of number of ranks" severity failure;
            v_num_slots := ranks/ranks_per_slot;

            if v_num_slots = 1 then
                -- special condition for 1 slot (i.e. DIMM) (2^n, n=0,1,2,... ranks only)
                -- set odt on one chip for writes and no odt for reads
                for v_cs in 0 to ranks-1 loop
                    v_odt_values(v_cs).write := 2**v_cs;  -- on on the rank being written to
                    v_odt_values(v_cs).read  := 0;
                end loop;
            else
                -- if > 1 slot, set 1 odt enable on neighbouring slot for read and write
                -- as an example consider the below for 4 slots with 2 ranks per slot
                -- access to CS[0] or CS[1], enable ODT[2] or ODT[3]
                -- access to CS[2] or CS[3], enable ODT[0] or ODT[1]
                -- access to CS[4] or CS[5], enable ODT[6] or ODT[7]
                -- access to CS[6] or CS[7], enable ODT[4] or ODT[5]

                -- the logic below implements the above for varying ranks and ranks_per slot
                -- under the condition that ranks/ranks_per_slot is integer
                for v_cs in 0 to ranks-1 loop
                    v_cs_addr                    := to_unsigned(v_cs, ranks);
                    v_cs_addr(ranks_per_slot-1)  := not v_cs_addr(ranks_per_slot-1);
                    v_odt_values(v_cs).write     := 2**to_integer(v_cs_addr);
                    v_odt_values(v_cs).read      := v_odt_values(v_cs).write;
                end loop;

            end if;

        elsif mem_type = "DDR3" then

            assert (ranks rem ranks_per_slot = 0) report ac_report_prefix & "number of ranks per slot must be a multiple of number of ranks" severity failure;
            v_num_slots := ranks/ranks_per_slot;

            if v_num_slots = 1 then
                -- special condition for 1 slot (i.e. DIMM) (2^n, n=0,1,2,... ranks only)
                -- set odt on one chip for writes and no odt for reads
                for v_cs in 0 to ranks-1 loop
                    v_odt_values(v_cs).write := 2**v_cs;  -- on on the rank being written to
                    v_odt_values(v_cs).read  := 0;
                end loop;
            else
                -- if > 1 slot, set 1 odt enable on neighbouring slot for read and write
                -- as an example consider the below for 4 slots with 2 ranks per slot
                -- access to CS[0] or CS[1], enable ODT[2] or ODT[3]
                -- access to CS[2] or CS[3], enable ODT[0] or ODT[1]
                -- access to CS[4] or CS[5], enable ODT[6] or ODT[7]
                -- access to CS[6] or CS[7], enable ODT[4] or ODT[5]

                -- the logic below implements the above for varying ranks and ranks_per slot
                -- under the condition that ranks/ranks_per_slot is integer
                for v_cs in 0 to ranks-1 loop
                    v_cs_addr                    := to_unsigned(v_cs, ranks);
                    v_cs_addr(ranks_per_slot-1)  := not v_cs_addr(ranks_per_slot-1);
                    v_odt_values(v_cs).write     := 2**to_integer(v_cs_addr) + 2**(v_cs);  -- turn on a neighbouring slots cs and current rank being written to
                    v_odt_values(v_cs).read      := 2**to_integer(v_cs_addr);
                end loop;

            end if;

       else
            report ac_report_prefix & "unknown mem_type specified in the set_odt_values function in addr_cmd_pkg package" severity failure;
        end if;

        return v_odt_values;

    end function;



    -- -----------------------------------------------------------
    -- set constant values to config_rec
    -- ----------------------------------------------------------
    function set_config_rec ( num_addr_bits : in natural;
                              num_ba_bits   : in natural;
                              num_cs_bits   : in natural;
                              num_ranks     : in natural;
                              dwidth_ratio  : in natural range 1 to c_max_cmds_per_clk;
                              mem_type      : in string
                            ) return             t_addr_cmd_config_rec
    is
        variable v_config_rec : t_addr_cmd_config_rec;
    begin

        v_config_rec.num_addr_bits := num_addr_bits;
        v_config_rec.num_ba_bits   := num_ba_bits;
        v_config_rec.num_cs_bits   := num_cs_bits;
        v_config_rec.num_ranks     := num_ranks;
        v_config_rec.cmds_per_clk  := dwidth_ratio/2;

        if mem_type = "DDR" then
            v_config_rec.mem_type := DDR;
        elsif mem_type = "DDR2" then
            v_config_rec.mem_type := DDR2;
        elsif mem_type = "DDR3" then
            v_config_rec.mem_type := DDR3;
        else
            report ac_report_prefix & "unknown mem_type specified in the set_config_rec function in addr_cmd_pkg package" severity failure;
        end if;

        return v_config_rec;

    end function;
    
-- The non-levelled sequencer doesn't make a distinction between CS_WIDTH and NUM_RANKS. In this case,
-- just set the two to be the same.
    function set_config_rec ( num_addr_bits : in natural;
                              num_ba_bits   : in natural;
                              num_cs_bits   : in natural;
                              dwidth_ratio  : in natural range 1 to c_max_cmds_per_clk;
                              mem_type      : in string
                            ) return             t_addr_cmd_config_rec
    is
    begin

        return set_config_rec(num_addr_bits, num_ba_bits, num_cs_bits, num_cs_bits, dwidth_ratio, mem_type);

    end function;
-- -----------------------------------------------------------
-- unpack and pack address and command signals from and to t_addr_cmd_vector
-- -----------------------------------------------------------

    -- -------------------------------------------------------------
    -- convert from t_addr_cmd_vector to expanded addr/cmd signals
    -- -------------------------------------------------------------

    procedure unpack_addr_cmd_vector( addr_cmd_vector : in t_addr_cmd_vector;
                                      config_rec      : in t_addr_cmd_config_rec;
                                      addr            : out std_logic_vector;
                                      ba              : out std_logic_vector;
                                      cas_n           : out std_logic_vector;
                                      ras_n           : out std_logic_vector;
                                      we_n            : out std_logic_vector;
                                      cke             : out std_logic_vector;
                                      cs_n            : out std_logic_vector;
                                      odt             : out std_logic_vector;
                                      rst_n           : out std_logic_vector
                                    )
    is
        variable v_mem_if_ranks : natural range 0 to 2**c_max_ranks - 1;
        variable v_vec_len      : natural range 1 to 4;

        variable v_addr  : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_addr_bits - 1 downto 0);
        variable v_ba    : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_ba_bits   - 1 downto 0);
        variable v_odt   : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_ranks     - 1 downto 0);
        variable v_cs_n  : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_cs_bits   - 1 downto 0);
        variable v_cke   : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_ranks     - 1 downto 0);
        variable v_cas_n : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);
        variable v_ras_n : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);
        variable v_we_n  : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);
        variable v_rst_n : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);

    begin

        v_vec_len := config_rec.cmds_per_clk;
        v_mem_if_ranks := config_rec.num_ranks;

        for v_i in 0 to v_vec_len-1 loop

            assert addr_cmd_vector(v_i).addr < 2**config_rec.num_addr_bits report ac_report_prefix &
                   "value of addr exceeds range of number of address bits in unpack_addr_cmd_vector procedure"    severity failure;
            assert addr_cmd_vector(v_i).ba   < 2**config_rec.num_ba_bits   report ac_report_prefix &
                   "value of ba exceeds range of number of bank address bits in unpack_addr_cmd_vector procedure" severity failure;
            assert addr_cmd_vector(v_i).odt  < 2**v_mem_if_ranks report ac_report_prefix &
                   "value of odt exceeds range of number of ranks in unpack_addr_cmd_vector procedure"            severity failure;
            assert addr_cmd_vector(v_i).cs_n < 2**config_rec.num_cs_bits report ac_report_prefix &
                   "value of cs_n exceeds range of number of ranks in unpack_addr_cmd_vector procedure"           severity failure;
            assert addr_cmd_vector(v_i).cke  < 2**v_mem_if_ranks report ac_report_prefix &
                   "value of cke exceeds range of number of ranks in unpack_addr_cmd_vector procedure"            severity failure;

            v_addr((v_i+1)*config_rec.num_addr_bits - 1 downto v_i*config_rec.num_addr_bits) := std_logic_vector(to_unsigned(addr_cmd_vector(v_i).addr,config_rec.num_addr_bits));
            v_ba((v_i+1)*config_rec.num_ba_bits     - 1 downto v_i*config_rec.num_ba_bits)   := std_logic_vector(to_unsigned(addr_cmd_vector(v_i).ba,config_rec.num_ba_bits));
            v_cke((v_i+1)*v_mem_if_ranks            - 1 downto v_i*v_mem_if_ranks)           := std_logic_vector(to_unsigned(addr_cmd_vector(v_i).cke,v_mem_if_ranks));
            v_cs_n((v_i+1)*config_rec.num_cs_bits   - 1 downto v_i*config_rec.num_cs_bits)   := std_logic_vector(to_unsigned(addr_cmd_vector(v_i).cs_n,config_rec.num_cs_bits));
            v_odt((v_i+1)*v_mem_if_ranks            - 1 downto v_i*v_mem_if_ranks)           := std_logic_vector(to_unsigned(addr_cmd_vector(v_i).odt,v_mem_if_ranks));

            if (addr_cmd_vector(v_i).cas_n) then v_cas_n(v_i) := '0'; else v_cas_n(v_i) := '1'; end if;
            if (addr_cmd_vector(v_i).ras_n) then v_ras_n(v_i) := '0'; else v_ras_n(v_i) := '1'; end if;
            if (addr_cmd_vector(v_i).we_n)  then  v_we_n(v_i) := '0'; else  v_we_n(v_i) := '1'; end if;
            if (addr_cmd_vector(v_i).rst_n) then v_rst_n(v_i) := '0'; else v_rst_n(v_i) := '1'; end if;

        end loop;

        addr  := v_addr;
        ba    := v_ba;
        cke   := v_cke;
        cs_n  := v_cs_n;
        odt   := v_odt;
        cas_n := v_cas_n;
        ras_n := v_ras_n;
        we_n  := v_we_n;
        rst_n := v_rst_n;

    end procedure;


    procedure unpack_addr_cmd_vector( config_rec      : in t_addr_cmd_config_rec;
                                      addr_cmd_vector : in t_addr_cmd_vector;
                               signal addr            : out std_logic_vector;
                               signal ba              : out std_logic_vector;
                               signal cas_n           : out std_logic_vector;
                               signal ras_n           : out std_logic_vector;
                               signal we_n            : out std_logic_vector;
                               signal cke             : out std_logic_vector;
                               signal cs_n            : out std_logic_vector;
                               signal odt             : out std_logic_vector;
                               signal rst_n           : out std_logic_vector
                                    )
    is
        variable v_mem_if_ranks : natural range 0 to 2**c_max_ranks - 1;
        variable v_vec_len      : natural range 1 to 4;
        variable v_seq_ac_addr  : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_addr_bits - 1 downto 0);
        variable v_seq_ac_ba    : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_ba_bits   - 1 downto 0);
        variable v_seq_ac_cas_n : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);
        variable v_seq_ac_ras_n : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);
        variable v_seq_ac_we_n  : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);
        variable v_seq_ac_cke   : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_ranks     - 1 downto 0);
        variable v_seq_ac_cs_n  : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_cs_bits   - 1 downto 0);
        variable v_seq_ac_odt   : std_logic_vector(config_rec.cmds_per_clk * config_rec.num_ranks     - 1 downto 0);
        variable v_seq_ac_rst_n : std_logic_vector(config_rec.cmds_per_clk                            - 1 downto 0);

    begin

        unpack_addr_cmd_vector (
            addr_cmd_vector,
            config_rec,
            v_seq_ac_addr,
            v_seq_ac_ba,
            v_seq_ac_cas_n,
            v_seq_ac_ras_n,
            v_seq_ac_we_n,
            v_seq_ac_cke,
            v_seq_ac_cs_n,
            v_seq_ac_odt,
            v_seq_ac_rst_n);

        addr  <= v_seq_ac_addr;
        ba    <= v_seq_ac_ba;
        cas_n <= v_seq_ac_cas_n;
        ras_n <= v_seq_ac_ras_n;
        we_n  <= v_seq_ac_we_n;
        cke   <= v_seq_ac_cke;
        cs_n  <= v_seq_ac_cs_n;
        odt   <= v_seq_ac_odt;
        rst_n <= v_seq_ac_rst_n;

    end procedure;

-- -----------------------------------------------------------
-- function to mask each bit of signal signal_name in addr_cmd_
-- -----------------------------------------------------------
    -- -----------------------------------------------------------
    -- function to mask each bit of signal signal_name in addr_cmd_vector with mask_value
    -- -----------------------------------------------------------
    function mask ( config_rec         : in    t_addr_cmd_config_rec;
                    addr_cmd_vector    : in    t_addr_cmd_vector;
                    signal_name        : in    t_addr_cmd_signals;
                    mask_value         : in    std_logic
                  ) return t_addr_cmd_vector
    is
        variable v_i : integer;
    variable v_addr_cmd_vector :  t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        v_addr_cmd_vector := addr_cmd_vector;

        for v_i in 0 to (config_rec.cmds_per_clk)-1 loop

            case signal_name is

                when addr  => if (mask_value = '0') then v_addr_cmd_vector(v_i).addr  := 0;    else v_addr_cmd_vector(v_i).addr  := (2 ** config_rec.num_addr_bits) - 1; end if;
                when ba    => if (mask_value = '0') then v_addr_cmd_vector(v_i).ba    := 0;    else v_addr_cmd_vector(v_i).ba    := (2 ** config_rec.num_ba_bits) - 1;   end if;
                when cas_n => if (mask_value = '0') then v_addr_cmd_vector(v_i).cas_n := true; else v_addr_cmd_vector(v_i).cas_n := false;                               end if;
                when ras_n => if (mask_value = '0') then v_addr_cmd_vector(v_i).ras_n := true; else v_addr_cmd_vector(v_i).ras_n := false;                               end if;
                when we_n  => if (mask_value = '0') then v_addr_cmd_vector(v_i).we_n  := true; else v_addr_cmd_vector(v_i).we_n  := false;                               end if;
                when cke   => if (mask_value = '0') then v_addr_cmd_vector(v_i).cke   := 0;    else v_addr_cmd_vector(v_i).cke   := (2**config_rec.num_ranks) -1;        end if;
                when cs_n  => if (mask_value = '0') then v_addr_cmd_vector(v_i).cs_n  := 0;    else v_addr_cmd_vector(v_i).cs_n  := (2**config_rec.num_cs_bits) -1;      end if;
                when odt   => if (mask_value = '0') then v_addr_cmd_vector(v_i).odt   := 0;    else v_addr_cmd_vector(v_i).odt   := (2**config_rec.num_ranks) -1;        end if;
                when rst_n => if (mask_value = '0') then v_addr_cmd_vector(v_i).rst_n := true; else v_addr_cmd_vector(v_i).rst_n := false;                               end if;

                when others => report ac_report_prefix & "bit masking not supported for the given signal name" severity failure;

            end case;

        end loop;

        return v_addr_cmd_vector;

    end function;

    -- -----------------------------------------------------------
    -- procedure to mask each bit of signal signal_name in addr_cmd_vector with mask_value
    -- -----------------------------------------------------------
    procedure mask(        config_rec      : in    t_addr_cmd_config_rec;
                    signal addr_cmd_vector : inout t_addr_cmd_vector;
                           signal_name     : in    t_addr_cmd_signals;
                           mask_value      : in    std_logic
                  )
    is
        variable v_i : integer;
    begin

        for v_i in 0 to (config_rec.cmds_per_clk)-1 loop

            case signal_name is

                when addr  => if (mask_value = '0') then addr_cmd_vector(v_i).addr  <= 0;    else addr_cmd_vector(v_i).addr  <= (2 ** config_rec.num_addr_bits) - 1; end if;
                when ba    => if (mask_value = '0') then addr_cmd_vector(v_i).ba    <= 0;    else addr_cmd_vector(v_i).ba    <= (2 ** config_rec.num_ba_bits) - 1;   end if;
                when cas_n => if (mask_value = '0') then addr_cmd_vector(v_i).cas_n <= true; else addr_cmd_vector(v_i).cas_n <= false;                               end if;
                when ras_n => if (mask_value = '0') then addr_cmd_vector(v_i).ras_n <= true; else addr_cmd_vector(v_i).ras_n <= false;                               end if;
                when we_n  => if (mask_value = '0') then addr_cmd_vector(v_i).we_n  <= true; else addr_cmd_vector(v_i).we_n  <= false;                               end if;
                when cke   => if (mask_value = '0') then addr_cmd_vector(v_i).cke   <= 0;    else addr_cmd_vector(v_i).cke   <= (2**config_rec.num_ranks) -1;        end if;
                when cs_n  => if (mask_value = '0') then addr_cmd_vector(v_i).cs_n  <= 0;    else addr_cmd_vector(v_i).cs_n  <= (2**config_rec.num_cs_bits) -1;        end if;
                when odt   => if (mask_value = '0') then addr_cmd_vector(v_i).odt   <= 0;    else addr_cmd_vector(v_i).odt   <= (2**config_rec.num_ranks) -1;        end if;
                when rst_n => if (mask_value = '0') then addr_cmd_vector(v_i).rst_n <= true; else addr_cmd_vector(v_i).rst_n <= false;                               end if;

                when others => report ac_report_prefix & "masking not supported for the given signal name" severity failure;

            end case;

        end loop;

    end procedure;


    -- -----------------------------------------------------------
    -- function to mask a given bit (mask_bit) of signal signal_name in addr_cmd_vector with mask_value
    -- -----------------------------------------------------------
    function mask  ( config_rec        : in    t_addr_cmd_config_rec;
                     addr_cmd_vector   : in    t_addr_cmd_vector;
                     signal_name       : in    t_addr_cmd_signals;
                     mask_value        : in    std_logic;
                     mask_bit          : in    natural
                   ) return t_addr_cmd_vector
    is
        variable v_i       : integer;
        variable v_addr    : std_logic_vector(config_rec.num_addr_bits-1 downto 0); -- v_addr is bit vector of address
        variable v_ba      : std_logic_vector(config_rec.num_ba_bits-1 downto 0); -- v_addr is bit vector of bank address
        variable v_vec_len : natural range 0 to 4;
    variable v_addr_cmd_vector : t_addr_cmd_vector(0 to config_rec.cmds_per_clk -1);
    begin

        v_addr_cmd_vector := addr_cmd_vector;
        v_vec_len         := config_rec.cmds_per_clk;

        for v_i in 0 to v_vec_len-1 loop

            case signal_name is

                when addr =>
                    v_addr                      := std_logic_vector(to_unsigned(v_addr_cmd_vector(v_i).addr,v_addr'length));
                    v_addr(mask_bit)            := mask_value;
                    v_addr_cmd_vector(v_i).addr := to_integer(unsigned(v_addr));

                when ba =>
                    v_ba                        := std_logic_vector(to_unsigned(v_addr_cmd_vector(v_i).ba,v_ba'length));
                    v_ba(mask_bit)              := mask_value;
                    v_addr_cmd_vector(v_i).ba   := to_integer(unsigned(v_ba));

                when others =>
                    report ac_report_prefix & "bit masking not supported for the given signal name" severity failure;

            end case;

        end loop;

        return v_addr_cmd_vector;

    end function;

--
end ddr3_int_phy_alt_mem_phy_addr_cmd_pkg;

--

-- -----------------------------------------------------------------------------
--  Abstract        : iram addressing package for the non-levelling AFI PHY sequencer
--                    The iram address package (alt_mem_phy_iram_addr_pkg) is
--                    used to define the base addresses used for iram writes
--                    during calibration.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
package ddr3_int_phy_alt_mem_phy_iram_addr_pkg IS

    constant c_ihi_size           : natural := 8;

    type t_base_hdr_addresses is record
        base_hdr           : natural;
        rrp                : natural;
        safe_dummy         : natural;
        required_addr_bits : natural;
    end record;

    function defaults return t_base_hdr_addresses;

    function rrp_pll_phase_mult (dwidth_ratio : in natural;
                                 dqs_capture  : in natural
                                )
                                return natural;

    function iram_wd_for_full_rrp ( dwidth_ratio  : in natural;
                                    pll_phases    : in natural;
                                    dq_pins       : in natural;
                                    dqs_capture   : in natural
                                  )
                                  return natural;

    function iram_wd_for_one_pin_rrp ( dwidth_ratio  : in natural;
                                       pll_phases    : in natural;
                                       dq_pins       : in natural;
                                       dqs_capture   : in natural
                                     )
                                     return natural;

    function calc_iram_addresses ( dwidth_ratio : in natural;
                                   pll_phases   : in natural;
                                   dq_pins      : in natural;
                                   num_ranks    : in natural;
                                   dqs_capture  : in natural
                                 )
                                 return t_base_hdr_addresses;

--
end ddr3_int_phy_alt_mem_phy_iram_addr_pkg;

--
package body ddr3_int_phy_alt_mem_phy_iram_addr_pkg IS

    -- set some safe default values
    function defaults return t_base_hdr_addresses is
        variable temp : t_base_hdr_addresses;
    begin
        temp.base_hdr           := 0;
        temp.rrp                := 0;
        temp.safe_dummy         := 0;
        temp.required_addr_bits := 1;
        return temp;
    end function;

    -- this function determines now many times the PLL phases are swept through per pin
    -- i.e. an n * 360 degree phase sweep
    function rrp_pll_phase_mult (dwidth_ratio : in natural;
                                 dqs_capture  : in natural
                                )
                                return natural
    is
        variable v_output : natural;
    begin

        if dwidth_ratio = 2 and dqs_capture = 1 then

            v_output := 2;  -- if dqs_capture then a 720 degree sweep needed in FR

        else

            v_output := (dwidth_ratio/2);

        end if;

        return v_output;

    end function;

    -- function to calculate how many words are required for a rrp sweep over all pins
    function iram_wd_for_full_rrp ( dwidth_ratio  : in natural;
                                    pll_phases    : in natural;
                                    dq_pins       : in natural;
                                    dqs_capture   : in natural
                                  )
                                  return natural
    is
        variable v_output    : natural;
        variable v_phase_mul : natural;
    begin
        -- determine the n * 360 degrees of sweep required
        v_phase_mul := rrp_pll_phase_mult(dwidth_ratio, dqs_capture);

        -- calculate output size
        v_output := dq_pins * (((v_phase_mul * pll_phases) + 31) / 32);

        return v_output;

    end function;

    -- function to calculate how many words are required for a rrp sweep over all pins
    function iram_wd_for_one_pin_rrp ( dwidth_ratio  : in natural;
                                       pll_phases    : in natural;
                                       dq_pins       : in natural;
                                       dqs_capture   : in natural
                                     )
                                     return natural
    is
        variable v_output : natural;
        variable v_phase_mul : natural;
    begin
        -- determine the n * 360 degrees of sweep required
        v_phase_mul := rrp_pll_phase_mult(dwidth_ratio, dqs_capture);

        -- calculate output size
        v_output := ((v_phase_mul * pll_phases) + 31) / 32;

        return v_output;

    end function;

    -- return iram addresses
    function calc_iram_addresses ( dwidth_ratio : in natural;
                                   pll_phases   : in natural;
                                   dq_pins      : in natural;
                                   num_ranks    : in natural;
                                   dqs_capture  : in natural
                                 )
                                 return t_base_hdr_addresses
    is
        variable working               : t_base_hdr_addresses;
        variable temp                  : natural;

        variable v_required_words      : natural;

    begin

        working.base_hdr               := 0;
        working.rrp                    := working.base_hdr + c_ihi_size;

        -- work out required number of address bits

        -- + for 1 full rrp calibration
        v_required_words               := iram_wd_for_full_rrp(dwidth_ratio, pll_phases, dq_pins, dqs_capture) + 2; -- +2 for header + footer

        -- * loop per cs
        v_required_words               := v_required_words * num_ranks;

        -- + for 1 rrp_seek result
        v_required_words               := v_required_words + 3; -- 1 header, 1 word result, 1 footer

        -- + 2 mtp_almt passes
        v_required_words               := v_required_words + 2 * (iram_wd_for_one_pin_rrp(dwidth_ratio, pll_phases, dq_pins, dqs_capture) + 2);

        -- + for 2 read_mtp result calculation
        v_required_words               := v_required_words + 3*2; -- 1 header, 1 word result, 1 footer

        -- * possible dwidth_ratio/2 iterations for different ac_nt settings
        v_required_words               := v_required_words * (dwidth_ratio / 2);

        working.safe_dummy             := working.rrp + v_required_words;

        temp                           := working.safe_dummy;
        working.required_addr_bits     := 0;

        while (temp >= 1) loop
            working.required_addr_bits := working.required_addr_bits + 1;
            temp                       := temp /2;
        end loop;

        return working;

    end function calc_iram_addresses;

--
END ddr3_int_phy_alt_mem_phy_iram_addr_pkg;
--

-- -----------------------------------------------------------------------------
--  Abstract        : register package for the non-levelling AFI PHY sequencer
--                    The registers package (alt_mem_phy_regs_pkg) is used to
--                    combine the definition of the registers for the mmi status
--                    registers and functions/procedures applied to the registers
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;

--
package ddr3_int_phy_alt_mem_phy_regs_pkg is

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant regs_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (register package) : ";

-- ---------------------------------------------------------------
-- register declarations with associated functions of:
-- default     - assign default values
-- write       - write data into the reg (from avalon i/f)
-- read        - read data from the reg (sent to the avalon i/f)
-- write_clear - clear reg to all zeros
-- ---------------------------------------------------------------

    -- TYPE DECLARATIONS

    -- >>>>>>>>>>>>>>>>>>>>>>>>
    -- Read Only Registers
    -- >>>>>>>>>>>>>>>>>>>>>>>>

    -- cal_status
    type t_cal_status is record
        iram_addr_width  : std_logic_vector(3 downto 0);
        out_of_mem       : std_logic;
        contested_access : std_logic;
        cal_fail         : std_logic;
        cal_success      : std_logic;
        ctrl_err_code    : std_logic_vector(7 downto 0);
        trefi_failure    : std_logic;
        int_ac_1t        : std_logic;
        dqs_capture      : std_logic;
        iram_present     : std_logic;
        active_block     : std_logic_vector(3 downto 0);
        current_stage    : std_logic_vector(7 downto 0);
    end record;

    -- codvw status
    type t_codvw_status is record
        cal_codvw_phase   : std_logic_vector(7  downto 0);
        cal_codvw_size    : std_logic_vector(7  downto 0);
        codvw_trk_shift   : std_logic_vector(11 downto 0);
        codvw_grt_one_dvw : std_logic;
    end record t_codvw_status;

    -- test status report
    type t_test_status is record
        ack_seen    : std_logic_vector(c_hl_ccs_num_stages-1 downto 0);
        pll_mmi_err : std_logic_vector(1 downto 0);
        pll_busy    : std_logic;
    end record;

    -- define all the read only registers :
    type t_ro_regs is record
        cal_status    : t_cal_status;
        codvw_status  : t_codvw_status;
        test_status   : t_test_status;
    end record;

    -- >>>>>>>>>>>>>>>>>>>>>>>>
    -- Read / Write Registers
    -- >>>>>>>>>>>>>>>>>>>>>>>>

    -- Calibration control register
    type t_hl_css is record
        hl_css             : std_logic_vector(c_hl_ccs_num_stages-1 downto 0);
        cal_start          : std_logic;
    end record t_hl_css;

    -- Mode register A
    type t_mr_register_a is record
        mr0 : std_logic_vector(c_max_mode_reg_index -1 downto 0);
        mr1 : std_logic_vector(c_max_mode_reg_index -1 downto 0);
    end record t_mr_register_a;

    -- Mode register B
    type t_mr_register_b is record
        mr2 : std_logic_vector(c_max_mode_reg_index -1 downto 0);
        mr3 : std_logic_vector(c_max_mode_reg_index -1 downto 0);
    end record t_mr_register_b;

    -- algorithm parameterisation register
    type t_parameterisation_reg_a is record
        nominal_poa_phase_lead : std_logic_vector(3 downto 0);
        maximum_poa_delay      : std_logic_vector(3 downto 0);
        num_phases_per_tck_pll : std_logic_vector(3 downto 0);
        pll_360_sweeps         : std_logic_vector(3 downto 0);
        nominal_dqs_delay      : std_logic_vector(2 downto 0);
        extend_octrt_by        : std_logic_vector(3 downto 0);
        delay_octrt_by         : std_logic_vector(3 downto 0);
    end record;

    -- test signal register
    type t_if_test_reg is record
        pll_phs_shft_phase_sel  : natural range 0 to 15;
        pll_phs_shft_up_wc      : std_logic;
        pll_phs_shft_dn_wc      : std_logic;
        ac_1t_toggle            : std_logic;                     -- unused
        tracking_period_ms      : std_logic_vector(7 downto 0);  -- 0 = as fast as possible approx in ms
        tracking_units_are_10us : std_logic;
    end record;

    -- define all the read/write registers
    type t_rw_regs is record
        mr_reg_a       : t_mr_register_a;
        mr_reg_b       : t_mr_register_b;
        rw_hl_css      : t_hl_css;
        rw_param_reg   : t_parameterisation_reg_a;
        rw_if_test     : t_if_test_reg;
    end record;

    -- >>>>>>>>>>>>>>>>>>>>>>>
    -- Group all registers
    -- >>>>>>>>>>>>>>>>>>>>>>>

    type t_mmi_regs is record
        rw_regs       : t_rw_regs;
        ro_regs       : t_ro_regs;
        enable_writes : std_logic;
    end record;


    -- FUNCTION DECLARATIONS

    -- >>>>>>>>>>>>>>>>>>>>>>>>
    -- Read Only Registers
    -- >>>>>>>>>>>>>>>>>>>>>>>>

    -- cal_status
    function defaults return t_cal_status;
    function defaults   ( ctrl_mmi      : in t_ctrl_mmi;
                          USE_IRAM      : in std_logic;
                          dqs_capture   : in natural;
                          int_ac_1t     : in std_logic;
                          trefi_failure : in std_logic;
                          iram_status   : in t_iram_stat;
                          IRAM_AWIDTH   : in natural
                        ) return t_cal_status;

    function read (reg : t_cal_status) return std_logic_vector;

    -- codvw status
    function defaults return t_codvw_status;
    function defaults ( dgrb_mmi : t_dgrb_mmi
                      ) return t_codvw_status;

    function read (reg : in t_codvw_status) return std_logic_vector;


    -- test status report

    function defaults return t_test_status;

    function defaults   ( ctrl_mmi     : in t_ctrl_mmi;
                          pll_mmi      : in t_pll_mmi;
                          rw_if_test   : t_if_test_reg
                        ) return t_test_status;

    function read       (reg : t_test_status) return std_logic_vector;

    -- define all the read only registers

    function defaults return t_ro_regs;

    function defaults (dgrb_mmi        : t_dgrb_mmi;
                       ctrl_mmi        : t_ctrl_mmi;
                       pll_mmi         : t_pll_mmi;
                       rw_if_test      : t_if_test_reg;
                       USE_IRAM        : std_logic;
                       dqs_capture     : natural;
                       int_ac_1t       : std_logic;
                       trefi_failure   : std_logic;
                       iram_status     : t_iram_stat;
                       IRAM_AWIDTH     : natural
                      ) return t_ro_regs;

    -- >>>>>>>>>>>>>>>>>>>>>>>>
    -- Read / Write Registers
    -- >>>>>>>>>>>>>>>>>>>>>>>>

    -- Calibration control register
    -- high level calibration stage set register comprises a bit vector for
    -- the calibration stage coding and the 1 control bit.

    function defaults return t_hl_css;
    function write (wdata_in : std_logic_vector(31 downto 0)) return t_hl_css;
    function read  (reg : in t_hl_css)                        return std_logic_vector;
    procedure write_clear (signal reg : inout t_hl_css);

    -- Mode register A
    -- mode registers 0 and 1 (mr and emr1)

    function defaults return t_mr_register_a;
    function defaults ( mr0     : in    std_logic_vector;
                        mr1     : in    std_logic_vector
                       ) return t_mr_register_a;

    function write (wdata_in : std_logic_vector(31 downto 0)) return t_mr_register_a;
    function read (reg : in t_mr_register_a) return std_logic_vector;

    -- Mode register B
    -- mode registers 2 and 3 (emr2 and emr3) - not present in ddr DRAM

    function defaults return t_mr_register_b;
    function defaults ( mr2     : in    std_logic_vector;
                        mr3     : in    std_logic_vector
                       ) return t_mr_register_b;

    function write (wdata_in : std_logic_vector(31 downto 0)) return t_mr_register_b;
    function read (reg : in t_mr_register_b) return std_logic_vector;

    -- algorithm parameterisation register

    function defaults return t_parameterisation_reg_a;
    function defaults ( NOM_DQS_PHASE_SETTING   : in natural;
                        PLL_STEPS_PER_CYCLE     : in natural;
                        pll_360_sweeps          : in natural
                      ) return t_parameterisation_reg_a;
    function read ( reg : in t_parameterisation_reg_a) return std_logic_vector;
    function write (wdata_in : std_logic_vector(31 downto 0)) return t_parameterisation_reg_a;

    -- test signal register

    function defaults return t_if_test_reg;
    function defaults ( TRACKING_INTERVAL_IN_MS : in natural
                      ) return t_if_test_reg;
    function read ( reg : in t_if_test_reg) return std_logic_vector;
    function write (wdata_in : std_logic_vector(31 downto 0)) return t_if_test_reg;
    procedure write_clear (signal reg : inout t_if_test_reg);


    -- define all the read/write registers

    function defaults return t_rw_regs;

    function defaults(
                        mr0                     : in std_logic_vector;
                        mr1                     : in std_logic_vector;
                        mr2                     : in std_logic_vector;
                        mr3                     : in std_logic_vector;
                        NOM_DQS_PHASE_SETTING   : in natural;
                        PLL_STEPS_PER_CYCLE     : in natural;
                        pll_360_sweeps          : in natural;
                        TRACKING_INTERVAL_IN_MS : in natural;
                        C_HL_STAGE_ENABLE       : in std_logic_vector(c_hl_ccs_num_stages-1 downto 0)
                      )return t_rw_regs;

    procedure write_clear (signal regs    : inout t_rw_regs);

    -- >>>>>>>>>>>>>>>>>>>>>>>
    -- Group all registers
    -- >>>>>>>>>>>>>>>>>>>>>>>

    function defaults return t_mmi_regs;

    function v_read       (mmi_regs : in t_mmi_regs;
                           address  : in natural
                          ) return std_logic_vector;

    function read         (signal mmi_regs : in t_mmi_regs;
                                  address  : in natural
                          ) return std_logic_vector;

    procedure write       (mmi_regs : inout t_mmi_regs;
                           address  : in natural;
                           wdata    : in std_logic_vector(31 downto 0));

    -- >>>>>>>>>>>>>>>>>>>>>>>
    -- functions to communicate register settings to other sequencer blocks
    -- >>>>>>>>>>>>>>>>>>>>>>>
    function pack_record (ip_regs : t_rw_regs) return t_mmi_pll_reconfig;
    function pack_record (ip_regs : t_rw_regs) return t_admin_ctrl;
    function pack_record (ip_regs : t_rw_regs) return t_mmi_ctrl;

    function pack_record ( ip_regs : t_rw_regs) return t_algm_paramaterisation;


    -- >>>>>>>>>>>>>>>>>>>>>>>
    -- helper functions
    -- >>>>>>>>>>>>>>>>>>>>>>>

    function to_t_hl_css_reg (hl_css    : t_hl_css ) return t_hl_css_reg;

    function pack_ack_seen ( cal_stage_ack_seen : in t_cal_stage_ack_seen
                           ) return std_logic_vector;

    -- encoding of stage and active block for register setting
    function encode_current_stage (ctrl_cmd_id  : t_ctrl_cmd_id)       return std_logic_vector;
    function encode_active_block  (active_block : t_ctrl_active_block) return std_logic_vector;

--
end ddr3_int_phy_alt_mem_phy_regs_pkg;

--
package body ddr3_int_phy_alt_mem_phy_regs_pkg is

    -- >>>>>>>>>>>>>>>>>>>>
    -- Read Only Registers
    -- >>>>>>>>>>>>>>>>>>>

-- ---------------------------------------------------------------
-- CODVW status report
-- ---------------------------------------------------------------

    function defaults return t_codvw_status is
        variable temp: t_codvw_status;
    begin
        temp.cal_codvw_phase   := (others => '0');
        temp.cal_codvw_size    := (others => '0');
        temp.codvw_trk_shift   := (others => '0');
        temp.codvw_grt_one_dvw := '0';
        return temp;
    end function;

    function defaults ( dgrb_mmi : t_dgrb_mmi
                      ) return t_codvw_status is
        variable temp: t_codvw_status;
    begin
        temp                   := defaults;
        temp.cal_codvw_phase   := dgrb_mmi.cal_codvw_phase;
        temp.cal_codvw_size    := dgrb_mmi.cal_codvw_size;
        temp.codvw_trk_shift   := dgrb_mmi.codvw_trk_shift;
        temp.codvw_grt_one_dvw := dgrb_mmi.codvw_grt_one_dvw;
        return temp;
    end function;

    function read (reg : in t_codvw_status) return std_logic_vector is
        variable temp : std_logic_vector(31 downto 0);
    begin
        temp               := (others => '0');
        temp(31 downto 24) := reg.cal_codvw_phase;
        temp(23 downto 16) := reg.cal_codvw_size;
        temp(15 downto 4)  := reg.codvw_trk_shift;
        temp(0)            := reg.codvw_grt_one_dvw;
        return temp;
    end function;

-- ---------------------------------------------------------------
-- Calibration status report
-- ---------------------------------------------------------------

    function defaults return t_cal_status is
        variable temp: t_cal_status;
    begin
        temp.iram_addr_width  := (others => '0');
        temp.out_of_mem       := '0';
        temp.contested_access := '0';
        temp.cal_fail         := '0';
        temp.cal_success      := '0';
        temp.ctrl_err_code    := (others => '0');
        temp.trefi_failure    := '0';
        temp.int_ac_1t        := '0';
        temp.dqs_capture      := '0';
        temp.iram_present     := '0';
        temp.active_block     := (others => '0');
        temp.current_stage    := (others => '0');
        return temp;
    end function;

    function defaults   ( ctrl_mmi      : in t_ctrl_mmi;
                          USE_IRAM      : in std_logic;
                          dqs_capture   : in natural;
                          int_ac_1t     : in std_logic;
                          trefi_failure : in std_logic;
                          iram_status   : in t_iram_stat;
                          IRAM_AWIDTH   : in natural
                        ) return t_cal_status is
        variable temp : t_cal_status;
    begin
        temp                  := defaults;
        temp.iram_addr_width  := std_logic_vector(to_unsigned(IRAM_AWIDTH, temp.iram_addr_width'length));
        temp.out_of_mem       := iram_status.out_of_mem;
        temp.contested_access := iram_status.contested_access;
        temp.cal_fail         := ctrl_mmi.ctrl_calibration_fail;
        temp.cal_success      := ctrl_mmi.ctrl_calibration_success;
        temp.ctrl_err_code    := ctrl_mmi.ctrl_err_code;
        temp.trefi_failure    := trefi_failure;
        temp.int_ac_1t        := int_ac_1t;

        if dqs_capture = 1 then
            temp.dqs_capture      := '1';
        elsif dqs_capture = 0 then
            temp.dqs_capture      := '0';
        else
            report regs_report_prefix & " invalid value for dqs_capture constant of " & integer'image(dqs_capture) severity failure;
        end if;

        temp.iram_present     := USE_IRAM;
        temp.active_block     := encode_active_block(ctrl_mmi.ctrl_current_active_block);
        temp.current_stage    := encode_current_stage(ctrl_mmi.ctrl_current_stage);
        return temp;
    end function;

    -- read for mmi status register
    function read       ( reg : t_cal_status
                        ) return std_logic_vector is
        variable output : std_logic_vector(31 downto 0);
    begin

        output               := (others => '0');
        output( 7 downto  0) := reg.current_stage;
        output(11 downto  8) := reg.active_block;
        output(12)           := reg.iram_present;
        output(13)           := reg.dqs_capture;
        output(14)           := reg.int_ac_1t;
        output(15)           := reg.trefi_failure;
        output(23 downto 16) := reg.ctrl_err_code;
        output(24)           := reg.cal_success;
        output(25)           := reg.cal_fail;
        output(26)           := reg.contested_access;
        output(27)           := reg.out_of_mem;
        output(31 downto 28) := reg.iram_addr_width;

        return output;
    end function;

-- ---------------------------------------------------------------
-- Test status report
-- ---------------------------------------------------------------

    function defaults return t_test_status is
        variable temp: t_test_status;
    begin
        temp.ack_seen         := (others => '0');
        temp.pll_mmi_err      := (others => '0');
        temp.pll_busy         := '0';
        return temp;
    end function;

    function defaults   ( ctrl_mmi     : in t_ctrl_mmi;
                          pll_mmi      : in t_pll_mmi;
                          rw_if_test   : t_if_test_reg
                        ) return t_test_status is
        variable temp : t_test_status;
    begin
        temp             := defaults;
        temp.ack_seen    := pack_ack_seen(ctrl_mmi.ctrl_cal_stage_ack_seen);
        temp.pll_mmi_err := pll_mmi.err;
        temp.pll_busy    := pll_mmi.pll_busy or rw_if_test.pll_phs_shft_up_wc or rw_if_test.pll_phs_shft_dn_wc;
        return temp;
    end function;

    -- read for mmi status register
    function read       ( reg : t_test_status
                        ) return std_logic_vector is
        variable output : std_logic_vector(31 downto 0);
    begin

        output                                   := (others => '0');
        output(31 downto 32-c_hl_ccs_num_stages) := reg.ack_seen;
        output( 5 downto  4)                     := reg.pll_mmi_err;
        output(0)                                := reg.pll_busy;

        return output;
    end function;

-------------------------------------------------
-- FOR ALL RO REGS:
-------------------------------------------------

    function defaults return t_ro_regs is
        variable temp: t_ro_regs;
    begin
        temp.cal_status   := defaults;
        temp.codvw_status := defaults;
        return temp;
    end function;

    function defaults (dgrb_mmi        : t_dgrb_mmi;
                       ctrl_mmi        : t_ctrl_mmi;
                       pll_mmi         : t_pll_mmi;
                       rw_if_test      : t_if_test_reg;
                       USE_IRAM        : std_logic;
                       dqs_capture     : natural;
                       int_ac_1t       : std_logic;
                       trefi_failure   : std_logic;
                       iram_status     : t_iram_stat;
                       IRAM_AWIDTH     : natural
                      ) return t_ro_regs is
        variable output : t_ro_regs;
    begin
        output              := defaults;
        output.cal_status   := defaults(ctrl_mmi, USE_IRAM, dqs_capture, int_ac_1t, trefi_failure, iram_status, IRAM_AWIDTH);
        output.codvw_status := defaults(dgrb_mmi);
        output.test_status  := defaults(ctrl_mmi, pll_mmi, rw_if_test);
        return output;
    end function;


-- >>>>>>>>>>>>>>>>>>>>>>>>
-- Read / Write registers
-- >>>>>>>>>>>>>>>>>>>>>>>>

-- ---------------------------------------------------------------
-- mode register set A
-- ---------------------------------------------------------------
    function defaults return t_mr_register_a is
        variable temp :t_mr_register_a;
    begin
        temp.mr0 := (others => '0');
        temp.mr1 := (others => '0');
        return temp;
    end function;

    -- apply default mode register settings to register
    function defaults ( mr0     : in    std_logic_vector;
                        mr1     : in    std_logic_vector
                      ) return t_mr_register_a is
        variable temp :t_mr_register_a;
    begin
        temp     := defaults;
        temp.mr0 := mr0(temp.mr0'range);
        temp.mr1 := mr1(temp.mr1'range);
        return temp;
    end function;

    function write (wdata_in : std_logic_vector(31 downto 0)) return t_mr_register_a is
        variable temp :t_mr_register_a;
    begin
        temp.mr0 := wdata_in(c_max_mode_reg_index -1     downto 0);
        temp.mr1 := wdata_in(c_max_mode_reg_index -1 + 16 downto 16);
        return temp;
    end function;

    function read (reg : in t_mr_register_a) return std_logic_vector is
        variable temp : std_logic_vector(31 downto 0) := (others => '0');
    begin
        temp(c_max_mode_reg_index -1      downto  0) := reg.mr0;
        temp(c_max_mode_reg_index -1 + 16 downto 16) := reg.mr1;
        return temp;
    end function;

-- ---------------------------------------------------------------
-- mode register set B
-- ---------------------------------------------------------------
    function defaults return t_mr_register_b is
        variable temp :t_mr_register_b;
    begin
        temp.mr2 := (others => '0');
        temp.mr3 := (others => '0');
        return temp;
    end function;

    -- apply default mode register settings to register
    function defaults ( mr2     : in    std_logic_vector;
                        mr3     : in    std_logic_vector
                       ) return t_mr_register_b is
        variable temp :t_mr_register_b;
    begin
        temp     := defaults;
        temp.mr2 := mr2(temp.mr2'range);
        temp.mr3 := mr3(temp.mr3'range);
        return temp;
    end function;

    function write (wdata_in : std_logic_vector(31 downto 0)) return t_mr_register_b is
        variable temp :t_mr_register_b;
    begin
        temp.mr2 := wdata_in(c_max_mode_reg_index -1      downto 0);
        temp.mr3 := wdata_in(c_max_mode_reg_index -1 + 16 downto 16);
        return temp;
    end function;

    function read (reg : in t_mr_register_b) return std_logic_vector is
        variable temp : std_logic_vector(31 downto 0) := (others => '0');
    begin
        temp(c_max_mode_reg_index -1      downto  0) := reg.mr2;
        temp(c_max_mode_reg_index -1 + 16 downto 16) := reg.mr3;
        return temp;
    end function;


-- ---------------------------------------------------------------
-- HL CSS (high level calibration state status)
-- ---------------------------------------------------------------
    function defaults return t_hl_css is
        variable temp : t_hl_css;
    begin
        temp.hl_css             := (others => '0');
        temp.cal_start          := '0';
        return temp;
    end function;

    function defaults ( C_HL_STAGE_ENABLE : in std_logic_vector(c_hl_ccs_num_stages-1 downto 0)
                      ) return t_hl_css is
        variable temp: t_hl_css;
    begin
        temp        := defaults;
        temp.hl_css := temp.hl_css OR C_HL_STAGE_ENABLE;
        return temp;
    end function;

    function read ( reg : in t_hl_css) return std_logic_vector is
        variable temp : std_logic_vector (31 downto 0) := (others => '0');
    begin
        temp(30 downto 30-c_hl_ccs_num_stages+1) := reg.hl_css;
        temp(0)                                  := reg.cal_start;
        return temp;
    end function;

    function write (wdata_in : std_logic_vector(31 downto 0) )return t_hl_css is
       variable reg : t_hl_css;
    begin
        reg.hl_css             := wdata_in(30 downto 30-c_hl_ccs_num_stages+1);
        reg.cal_start          := wdata_in(0);
        return reg;
    end function;

    procedure write_clear (signal reg : inout t_hl_css) is
    begin
        reg.cal_start <= '0';
    end procedure;

-- ---------------------------------------------------------------
-- paramaterisation of sequencer through Avalon interface
-- ---------------------------------------------------------------
    function defaults return t_parameterisation_reg_a is
        variable temp : t_parameterisation_reg_a;
    begin
        temp.nominal_poa_phase_lead  := (others => '0');
        temp.maximum_poa_delay       := (others => '0');
        temp.pll_360_sweeps          := "0000";
        temp.num_phases_per_tck_pll  := "0011";
        temp.nominal_dqs_delay       := (others => '0');
        temp.extend_octrt_by         := "0100";
        temp.delay_octrt_by          := "0000";
        return temp;
    end function;

    -- reset the paramterisation reg to given values
    function defaults ( NOM_DQS_PHASE_SETTING   : in natural;
                        PLL_STEPS_PER_CYCLE     : in natural;
                        pll_360_sweeps          : in natural
                      ) return t_parameterisation_reg_a is
        variable temp: t_parameterisation_reg_a;
    begin
        temp                        := defaults;
        temp.num_phases_per_tck_pll := std_logic_vector(to_unsigned(PLL_STEPS_PER_CYCLE /8 , temp.num_phases_per_tck_pll'high + 1 ));
        temp.pll_360_sweeps         := std_logic_vector(to_unsigned(pll_360_sweeps         , temp.pll_360_sweeps'high + 1         ));
        temp.nominal_dqs_delay      := std_logic_vector(to_unsigned(NOM_DQS_PHASE_SETTING  , temp.nominal_dqs_delay'high + 1      ));
        temp.extend_octrt_by        := std_logic_vector(to_unsigned(5                      , temp.extend_octrt_by'high + 1        ));
        temp.delay_octrt_by         := std_logic_vector(to_unsigned(6                      , temp.delay_octrt_by'high + 1         ));
        return temp;
    end function;

    function read ( reg : in t_parameterisation_reg_a) return std_logic_vector is
        variable temp : std_logic_vector (31 downto 0) := (others => '0');
    begin
        temp( 3 downto  0) := reg.pll_360_sweeps;
        temp( 7 downto  4) := reg.num_phases_per_tck_pll;
        temp(10 downto  8) := reg.nominal_dqs_delay;
        temp(19 downto 16) := reg.nominal_poa_phase_lead;
        temp(23 downto 20) := reg.maximum_poa_delay;
        temp(27 downto 24) := reg.extend_octrt_by;
        temp(31 downto 28) := reg.delay_octrt_by;
        return temp;
    end function;

    function write (wdata_in : std_logic_vector(31 downto 0)) return t_parameterisation_reg_a is
        variable reg : t_parameterisation_reg_a;
    begin
        reg.pll_360_sweeps         := wdata_in( 3 downto  0);
        reg.num_phases_per_tck_pll := wdata_in( 7 downto  4);
        reg.nominal_dqs_delay      := wdata_in(10 downto  8);
        reg.nominal_poa_phase_lead := wdata_in(19 downto 16);
        reg.maximum_poa_delay      := wdata_in(23 downto 20);
        reg.extend_octrt_by        := wdata_in(27 downto 24);
        reg.delay_octrt_by         := wdata_in(31 downto 28);
        return reg;
    end function;

-- ---------------------------------------------------------------
-- t_if_test_reg - additional test support register
-- ---------------------------------------------------------------
    function defaults return t_if_test_reg is
        variable temp : t_if_test_reg;
    begin
        temp.pll_phs_shft_phase_sel  := 0;
        temp.pll_phs_shft_up_wc      := '0';
        temp.pll_phs_shft_dn_wc      := '0';
        temp.ac_1t_toggle            := '0';
        temp.tracking_period_ms      := "10000000"; -- 127 ms interval
        temp.tracking_units_are_10us := '0';
        return temp;
    end function;

    -- reset the paramterisation reg to given values
    function defaults ( TRACKING_INTERVAL_IN_MS : in natural
                      ) return t_if_test_reg is
        variable temp: t_if_test_reg;
    begin
        temp := defaults;
        temp.tracking_period_ms      := std_logic_vector(to_unsigned(TRACKING_INTERVAL_IN_MS, temp.tracking_period_ms'length));
        return temp;
    end function;

    function read ( reg : in t_if_test_reg) return std_logic_vector is
        variable temp : std_logic_vector (31 downto 0) := (others => '0');
    begin
        temp( 3 downto  0) := std_logic_vector(to_unsigned(reg.pll_phs_shft_phase_sel,4));
        temp(4)            := reg.pll_phs_shft_up_wc;
        temp(5)            := reg.pll_phs_shft_dn_wc;
        temp(16)           := reg.ac_1t_toggle;
        temp(15 downto  8) := reg.tracking_period_ms;
        temp(20)           := reg.tracking_units_are_10us;
        return temp;
    end function;

    function write (wdata_in : std_logic_vector(31 downto 0)) return t_if_test_reg is
        variable reg : t_if_test_reg;
    begin
        reg.pll_phs_shft_phase_sel  := to_integer(unsigned(wdata_in( 3 downto  0)));
        reg.pll_phs_shft_up_wc      := wdata_in(4);
        reg.pll_phs_shft_dn_wc      := wdata_in(5);
        reg.ac_1t_toggle            := wdata_in(16);
        reg.tracking_period_ms      := wdata_in(15 downto  8);
        reg.tracking_units_are_10us := wdata_in(20);
        return reg;
    end function;

    procedure write_clear (signal reg : inout t_if_test_reg) is
    begin
        reg.ac_1t_toggle       <= '0';
        reg.pll_phs_shft_up_wc <= '0';
        reg.pll_phs_shft_dn_wc <= '0';
    end procedure;

-- ---------------------------------------------------------------
-- RW Regs, record of read/write register records (to simplify handling)
-- ---------------------------------------------------------------
    function defaults return t_rw_regs is
        variable temp : t_rw_regs;
    begin
        temp.mr_reg_a     := defaults;
        temp.mr_reg_b     := defaults;
        temp.rw_hl_css    := defaults;
        temp.rw_param_reg := defaults;
        temp.rw_if_test   := defaults;
        return temp;
    end function;

    function defaults(
                       mr0                     : in std_logic_vector;
                       mr1                     : in std_logic_vector;
                       mr2                     : in std_logic_vector;
                       mr3                     : in std_logic_vector;
                       NOM_DQS_PHASE_SETTING   : in natural;
                       PLL_STEPS_PER_CYCLE     : in natural;
                       pll_360_sweeps          : in natural;
                       TRACKING_INTERVAL_IN_MS : in natural;
                       C_HL_STAGE_ENABLE       : in std_logic_vector(c_hl_ccs_num_stages-1 downto 0)
                      )return t_rw_regs is
        variable temp : t_rw_regs;
    begin
        temp              := defaults;
        temp.mr_reg_a     := defaults(mr0, mr1);
        temp.mr_reg_b     := defaults(mr2, mr3);
        temp.rw_param_reg := defaults(NOM_DQS_PHASE_SETTING,
                                      PLL_STEPS_PER_CYCLE,
                                      pll_360_sweeps);
        temp.rw_if_test   := defaults(TRACKING_INTERVAL_IN_MS);
        temp.rw_hl_css    := defaults(C_HL_STAGE_ENABLE);
        return temp;
    end function;

    procedure write_clear (signal regs : inout t_rw_regs) is
    begin
        write_clear(regs.rw_if_test);
        write_clear(regs.rw_hl_css);
    end procedure;


    -- >>>>>>>>>>>>>>>>>>>>>>>>>>
    -- All mmi registers:
    -- >>>>>>>>>>>>>>>>>>>>>>>>>>

    function defaults return t_mmi_regs is
        variable v_mmi_regs : t_mmi_regs;
    begin
        v_mmi_regs.rw_regs       := defaults;
        v_mmi_regs.ro_regs       := defaults;
        v_mmi_regs.enable_writes := '0';
        return v_mmi_regs;
    end function;

    function v_read       (mmi_regs     : in t_mmi_regs;
                           address      : in natural
                          ) return std_logic_vector is
        variable output : std_logic_vector(31 downto 0);
    begin

        output := (others => '0');

        case address is

            -- status register
            when  c_regofst_cal_status     => output := read (mmi_regs.ro_regs.cal_status);

            -- debug access register
            when  c_regofst_debug_access   =>
                if (mmi_regs.enable_writes = '1') then
                    output := c_mmi_access_codeword;
                else
                    output := (others => '0');
                end if;

            -- test i/f to check which stages have acknowledged a command and pll checks
            when c_regofst_test_status     => output := read(mmi_regs.ro_regs.test_status);

            -- mode registers
            when c_regofst_mr_register_a   => output := read(mmi_regs.rw_regs.mr_reg_a);
            when c_regofst_mr_register_b   => output := read(mmi_regs.rw_regs.mr_reg_b);

            -- codvw r/o status register
            when c_regofst_codvw_status    => output := read(mmi_regs.ro_regs.codvw_status);

            -- read/write registers
            when  c_regofst_hl_css         => output := read(mmi_regs.rw_regs.rw_hl_css);
            when  c_regofst_if_param       => output := read(mmi_regs.rw_regs.rw_param_reg);
            when  c_regofst_if_test        => output := read(mmi_regs.rw_regs.rw_if_test);

            when others                    => report regs_report_prefix & "MMI registers detected an attempt to read to non-existant register location" severity warning;
                                                                            -- set illegal addr interrupt.
        end case;

        return output;

    end function;


    function read         (signal mmi_regs       : in t_mmi_regs;
                                  address        : in natural
                          ) return std_logic_vector is
        variable output     : std_logic_vector(31 downto 0);
        variable v_mmi_regs : t_mmi_regs;
    begin
        v_mmi_regs := mmi_regs;
        output     := v_read(v_mmi_regs, address);
        return output;
    end function;

    procedure write       (mmi_regs : inout t_mmi_regs;
                           address  : in natural;
                           wdata    : in std_logic_vector(31 downto 0)) is

    begin

        -- intercept writes to codeword.  This needs to be set for iRAM access :
        if address = c_regofst_debug_access then
            if wdata = c_mmi_access_codeword then
                mmi_regs.enable_writes := '1';
            else
                mmi_regs.enable_writes := '0';
            end if;

        else 

            case address is

                -- read only registers
                when  c_regofst_cal_status |
                      c_regofst_codvw_status |
                      c_regofst_test_status =>

                      report regs_report_prefix & "MMI registers detected an attempt to write to read only register number" & integer'image(address) severity failure;

                -- read/write registers
                when c_regofst_mr_register_a  => mmi_regs.rw_regs.mr_reg_a     := write(wdata);
                when c_regofst_mr_register_b  => mmi_regs.rw_regs.mr_reg_b     := write(wdata);
                when c_regofst_hl_css         => mmi_regs.rw_regs.rw_hl_css    := write(wdata);
                when c_regofst_if_param       => mmi_regs.rw_regs.rw_param_reg := write(wdata);
                when c_regofst_if_test        => mmi_regs.rw_regs.rw_if_test   := write(wdata);

                when others  => -- set illegal addr interrupt.

                    report regs_report_prefix & "MMI registers detected an attempt to write to non existant register, with expected number" & integer'image(address) severity failure;

            end case;

        end if;

    end procedure;

    -- >>>>>>>>>>>>>>>>>>>>>>>>>>
    -- the following functions enable register data to be communicated to other sequencer blocks
    -- >>>>>>>>>>>>>>>>>>>>>>>>>>

    function pack_record ( ip_regs : t_rw_regs
                         ) return t_algm_paramaterisation is
        variable output : t_algm_paramaterisation;
    begin
        -- default assignments
        output.num_phases_per_tck_pll := 16;
        output.pll_360_sweeps         := 1;
        output.nominal_dqs_delay      := 2;
        output.nominal_poa_phase_lead := 1;
        output.maximum_poa_delay      := 5;
        output.odt_enabled            := false;

		output.num_phases_per_tck_pll := to_integer(unsigned(ip_regs.rw_param_reg.num_phases_per_tck_pll)) * 8;

        case ip_regs.rw_param_reg.nominal_dqs_delay      is
            when "010" => output.nominal_dqs_delay := 2;
            when "001" => output.nominal_dqs_delay := 1;
            when "000" => output.nominal_dqs_delay := 0;
            when "011" => output.nominal_dqs_delay := 3;
            when others => report regs_report_prefix &
                                  "there is a unsupported number of DQS taps (" &
                                  natural'image(to_integer(unsigned(ip_regs.rw_param_reg.nominal_dqs_delay))) &
                                  ") being advertised as the standard value" severity error;
        end case;

       case ip_regs.rw_param_reg.nominal_poa_phase_lead  is
            when "0001" => output.nominal_poa_phase_lead := 1;
            when "0010" => output.nominal_poa_phase_lead := 2;
            when "0011" => output.nominal_poa_phase_lead := 3;
            when "0000" => output.nominal_poa_phase_lead := 0;
            when others => report regs_report_prefix &
                                  "there is an unsupported nominal postamble phase lead paramater set (" &
                                  natural'image(to_integer(unsigned(ip_regs.rw_param_reg.nominal_poa_phase_lead))) &
                                  ")" severity error;
       end case;

       if (    (ip_regs.mr_reg_a.mr1(2) = '1')
            or (ip_regs.mr_reg_a.mr1(6) = '1')
            or (ip_regs.mr_reg_a.mr1(9) = '1')
          ) then
          output.odt_enabled            := true;
       end if;

       output.pll_360_sweeps     := to_integer(unsigned(ip_regs.rw_param_reg.pll_360_sweeps));
       output.maximum_poa_delay  := to_integer(unsigned(ip_regs.rw_param_reg.maximum_poa_delay));
       output.extend_octrt_by    := to_integer(unsigned(ip_regs.rw_param_reg.extend_octrt_by));
       output.delay_octrt_by     := to_integer(unsigned(ip_regs.rw_param_reg.delay_octrt_by));
       output.tracking_period_ms := to_integer(unsigned(ip_regs.rw_if_test.tracking_period_ms));
        return output;
    end function;


    function pack_record (ip_regs : t_rw_regs) return t_mmi_pll_reconfig is
        variable output : t_mmi_pll_reconfig;
    begin
        output.pll_phs_shft_phase_sel := ip_regs.rw_if_test.pll_phs_shft_phase_sel;
        output.pll_phs_shft_up_wc     := ip_regs.rw_if_test.pll_phs_shft_up_wc;
        output.pll_phs_shft_dn_wc     := ip_regs.rw_if_test.pll_phs_shft_dn_wc;
        return output;
    end function;


    function pack_record (ip_regs : t_rw_regs) return t_admin_ctrl is
        variable output : t_admin_ctrl := defaults;
    begin
        output.mr0          := ip_regs.mr_reg_a.mr0;
        output.mr1          := ip_regs.mr_reg_a.mr1;
        output.mr2          := ip_regs.mr_reg_b.mr2;
        output.mr3          := ip_regs.mr_reg_b.mr3;
        return output;
    end function;

    function pack_record (ip_regs : t_rw_regs) return t_mmi_ctrl is
        variable output : t_mmi_ctrl := defaults;
    begin
        output.hl_css                := to_t_hl_css_reg (ip_regs.rw_hl_css);
        output.calibration_start     := ip_regs.rw_hl_css.cal_start;
        output.tracking_period_ms    := to_integer(unsigned(ip_regs.rw_if_test.tracking_period_ms));
        output.tracking_orvd_to_10ms := ip_regs.rw_if_test.tracking_units_are_10us;
        return output;
    end function;

    -- >>>>>>>>>>>>>>>>>>>>>>>>>>
    -- Helper functions :
    -- >>>>>>>>>>>>>>>>>>>>>>>>>>

    function to_t_hl_css_reg (hl_css    : t_hl_css
                         ) return t_hl_css_reg is
        variable output : t_hl_css_reg := defaults;
    begin

        output.phy_initialise_dis           := hl_css.hl_css(c_hl_css_reg_phy_initialise_dis_bit);
        output.init_dram_dis                := hl_css.hl_css(c_hl_css_reg_init_dram_dis_bit);
        output.write_ihi_dis                := hl_css.hl_css(c_hl_css_reg_write_ihi_dis_bit);
        output.cal_dis                      := hl_css.hl_css(c_hl_css_reg_cal_dis_bit);
        output.write_btp_dis                := hl_css.hl_css(c_hl_css_reg_write_btp_dis_bit);
        output.write_mtp_dis                := hl_css.hl_css(c_hl_css_reg_write_mtp_dis_bit);
        output.read_mtp_dis                 := hl_css.hl_css(c_hl_css_reg_read_mtp_dis_bit);
        output.rrp_reset_dis                := hl_css.hl_css(c_hl_css_reg_rrp_reset_dis_bit);
        output.rrp_sweep_dis                := hl_css.hl_css(c_hl_css_reg_rrp_sweep_dis_bit);
        output.rrp_seek_dis                 := hl_css.hl_css(c_hl_css_reg_rrp_seek_dis_bit);
        output.rdv_dis                      := hl_css.hl_css(c_hl_css_reg_rdv_dis_bit);
        output.poa_dis                      := hl_css.hl_css(c_hl_css_reg_poa_dis_bit);
        output.was_dis                      := hl_css.hl_css(c_hl_css_reg_was_dis_bit);
        output.adv_rd_lat_dis               := hl_css.hl_css(c_hl_css_reg_adv_rd_lat_dis_bit);
        output.adv_wr_lat_dis               := hl_css.hl_css(c_hl_css_reg_adv_wr_lat_dis_bit);
        output.prep_customer_mr_setup_dis   := hl_css.hl_css(c_hl_css_reg_prep_customer_mr_setup_dis_bit);
        output.tracking_dis                 := hl_css.hl_css(c_hl_css_reg_tracking_dis_bit);
        return output;
    end function;

    -- pack the ack seen record element into a std_logic_vector
    function pack_ack_seen ( cal_stage_ack_seen : in t_cal_stage_ack_seen
                        )    return std_logic_vector is
        variable v_output: std_logic_vector(c_hl_ccs_num_stages-1 downto 0);
        variable v_start : natural range 0 to c_hl_ccs_num_stages-1;
    begin
        v_output := (others => '0');

        v_output(c_hl_css_reg_cal_dis_bit                   ) := cal_stage_ack_seen.cal;
        v_output(c_hl_css_reg_phy_initialise_dis_bit        ) := cal_stage_ack_seen.phy_initialise;
        v_output(c_hl_css_reg_init_dram_dis_bit             ) := cal_stage_ack_seen.init_dram;
        v_output(c_hl_css_reg_write_ihi_dis_bit             ) := cal_stage_ack_seen.write_ihi;
        v_output(c_hl_css_reg_write_btp_dis_bit             ) := cal_stage_ack_seen.write_btp;
        v_output(c_hl_css_reg_write_mtp_dis_bit             ) := cal_stage_ack_seen.write_mtp;
        v_output(c_hl_css_reg_read_mtp_dis_bit              ) := cal_stage_ack_seen.read_mtp;
        v_output(c_hl_css_reg_rrp_reset_dis_bit             ) := cal_stage_ack_seen.rrp_reset;
        v_output(c_hl_css_reg_rrp_sweep_dis_bit             ) := cal_stage_ack_seen.rrp_sweep;
        v_output(c_hl_css_reg_rrp_seek_dis_bit              ) := cal_stage_ack_seen.rrp_seek;
        v_output(c_hl_css_reg_rdv_dis_bit                   ) := cal_stage_ack_seen.rdv;
        v_output(c_hl_css_reg_poa_dis_bit                   ) := cal_stage_ack_seen.poa;
        v_output(c_hl_css_reg_was_dis_bit                   ) := cal_stage_ack_seen.was;
        v_output(c_hl_css_reg_adv_rd_lat_dis_bit            ) := cal_stage_ack_seen.adv_rd_lat;
        v_output(c_hl_css_reg_adv_wr_lat_dis_bit            ) := cal_stage_ack_seen.adv_wr_lat;
        v_output(c_hl_css_reg_prep_customer_mr_setup_dis_bit) := cal_stage_ack_seen.prep_customer_mr_setup;
        v_output(c_hl_css_reg_tracking_dis_bit              ) := cal_stage_ack_seen.tracking_setup;

        return v_output;

    end function;

    -- reg encoding of current stage
    function encode_current_stage (ctrl_cmd_id    : t_ctrl_cmd_id
                         ) return std_logic_vector  is
        variable output :  std_logic_vector(7 downto 0);
    begin

       case ctrl_cmd_id is

           when cmd_idle                         => output := X"00";
           when cmd_phy_initialise               => output := X"01";
           when cmd_init_dram |
                cmd_prog_cal_mr                  => output := X"02";
           when cmd_write_ihi                    => output := X"03";
           when cmd_write_btp                    => output := X"04";
           when cmd_write_mtp                    => output := X"05";
           when cmd_read_mtp                     => output := X"06";
           when cmd_rrp_reset                    => output := X"07";
           when cmd_rrp_sweep                    => output := X"08";
           when cmd_rrp_seek                     => output := X"09";
           when cmd_rdv                          => output := X"0A";
           when cmd_poa                          => output := X"0B";
           when cmd_was                          => output := X"0C";
           when cmd_prep_adv_rd_lat              => output := X"0D";
           when cmd_prep_adv_wr_lat              => output := X"0E";
           when cmd_prep_customer_mr_setup       => output := X"0F";
           when cmd_tr_due                       => output := X"10";

           when others =>
                 null;
                 report regs_report_prefix & "unknown cal command (" & t_ctrl_cmd_id'image(ctrl_cmd_id) & ") seen in encode_current_stage function" severity failure;

        end case;

        return output;

    end function;

    -- reg encoding of current active block
    function encode_active_block (active_block    : t_ctrl_active_block
                         ) return std_logic_vector  is
        variable output :  std_logic_vector(3 downto 0);
    begin

       case active_block is

           when idle   => output := X"0";
           when admin  => output := X"1";
           when dgwb   => output := X"2";
           when dgrb   => output := X"3";
           when proc   => output := X"4";
           when setup  => output := X"5";
           when iram   => output := X"6";

           when others =>
                 output := X"7";
                 report regs_report_prefix & "unknown active_block seen in encode_active_block function" severity failure;

        end case;

        return output;

    end function;

--
end ddr3_int_phy_alt_mem_phy_regs_pkg;
--

-- -----------------------------------------------------------------------------
--  Abstract        : mmi block for the non-levelling AFI PHY sequencer
--                    This is an optional block with an Avalon interface and status
--                    register instantiations to enhance the debug capabilities of
--                    the sequencer. The format of the block is:
--                    a) an Avalon interface which supports different avalon and
--                       sequencer clock sources
--                    b) mmi status registers (which hold information about the
--                       successof the calibration)
--                    c) a read interface to the iram to enable debug through the
--                       avalon interface.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

--
entity ddr3_int_phy_alt_mem_phy_mmi is
    generic (
        -- physical interface width definitions
        MEM_IF_DQS_WIDTH               : natural;
        MEM_IF_DWIDTH                  : natural;
        MEM_IF_DM_WIDTH                : natural;
        MEM_IF_DQ_PER_DQS              : natural;
        MEM_IF_DQS_CAPTURE             : natural;
        DWIDTH_RATIO                   : natural;
        CLOCK_INDEX_WIDTH              : natural;
        MEM_IF_CLK_PAIR_COUNT          : natural;
        MEM_IF_ADDR_WIDTH              : natural;
        MEM_IF_BANKADDR_WIDTH          : natural;
        MEM_IF_NUM_RANKS               : natural;
        ADV_LAT_WIDTH                  : natural;
        RESYNCHRONISE_AVALON_DBG       : natural;
        AV_IF_ADDR_WIDTH               : natural;
        MEM_IF_MEMTYPE                 : string;

        -- setup / algorithm information
        NOM_DQS_PHASE_SETTING          : natural;
        SCAN_CLK_DIVIDE_BY             : natural;
        RDP_ADDR_WIDTH                 : natural;
        PLL_STEPS_PER_CYCLE            : natural;
        IOE_PHASES_PER_TCK             : natural;
        IOE_DELAYS_PER_PHS             : natural;
        MEM_IF_CLK_PS                  : natural;

        -- initial mode register settings
        PHY_DEF_MR_1ST                 : std_logic_vector(15 downto 0);
        PHY_DEF_MR_2ND                 : std_logic_vector(15 downto 0);
        PHY_DEF_MR_3RD                 : std_logic_vector(15 downto 0);
        PHY_DEF_MR_4TH                 : std_logic_vector(15 downto 0);

        PRESET_RLAT                    : natural;  -- read latency preset value
        CAPABILITIES                   : natural;  -- sequencer capabilities flags

        USE_IRAM                       : std_logic; -- RFU

        IRAM_AWIDTH                    : natural;
        TRACKING_INTERVAL_IN_MS        : natural;

        READ_LAT_WIDTH                 : natural
    );
    port (
        -- clk / reset
        clk                            : in    std_logic;
        rst_n                          : in    std_logic;

        --synchronous Avalon debug interface  (internally re-synchronised to input clock)
        dbg_seq_clk                    : in    std_logic;
        dbg_seq_rst_n                  : in    std_logic;
        dbg_seq_addr                   : in    std_logic_vector(AV_IF_ADDR_WIDTH -1 downto 0);
        dbg_seq_wr                     : in    std_logic;
        dbg_seq_rd                     : in    std_logic;
        dbg_seq_cs                     : in    std_logic;
        dbg_seq_wr_data                : in    std_logic_vector(31 downto 0);
        seq_dbg_rd_data                : out   std_logic_vector(31 downto 0);
        seq_dbg_waitrequest            : out   std_logic;

        -- mmi to admin interface
        regs_admin_ctrl                : out  t_admin_ctrl;
        admin_regs_status              : in   t_admin_stat;
        trefi_failure                  : in    std_logic;

        -- mmi to iram interface
        mmi_iram                       : out  t_iram_ctrl;
        mmi_iram_enable_writes         : out  std_logic;

        iram_status                    : in   t_iram_stat;

        -- mmi to control interface
        mmi_ctrl                       : out   t_mmi_ctrl;
        ctrl_mmi                       : in    t_ctrl_mmi;
        int_ac_1t                      : in    std_logic;
        invert_ac_1t                   : out   std_logic;

        -- global parameterisation record
        parameterisation_rec           : out   t_algm_paramaterisation;

        -- mmi pll interface
        pll_mmi                        : in    t_pll_mmi;
        mmi_pll                        : out   t_mmi_pll_reconfig;

        -- codvw status signals
        dgrb_mmi                       : in    t_dgrb_mmi
    );
end entity;

library work;

-- The registers package (alt_mem_phy_regs_pkg) is used to combine the definition of the
-- registers for the mmi status registers and functions/procedures applied to the registers
--
use work.ddr3_int_phy_alt_mem_phy_regs_pkg.all;

-- The iram address package (alt_mem_phy_iram_addr_pkg) is used to define the base addresses used
-- for iram writes during calibration
--
use work.ddr3_int_phy_alt_mem_phy_iram_addr_pkg.all;

-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;

--
architecture struct of ddr3_int_phy_alt_mem_phy_mmi IS

    -- maximum function
    function max (a, b : natural) return natural is
    begin
        if a > b then
            return a;
        else
            return b;
        end if;
    end function;

-- -------------------------------------------
-- constant definitions
-- -------------------------------------------

    constant c_pll_360_sweeps        : natural                       := rrp_pll_phase_mult(DWIDTH_RATIO, MEM_IF_DQS_CAPTURE);

    constant c_response_lat          : natural                       := 6;
    constant c_codeword              : std_logic_vector(31 downto 0) := c_mmi_access_codeword;
    constant c_int_iram_start_size   : natural                       := max(IRAM_AWIDTH, 4);

    -- enable for ctrl state machine states
    constant c_slv_hl_stage_enable   : std_logic_vector(31 downto 0)                    := std_logic_vector(to_unsigned(CAPABILITIES, 32));
    constant c_hl_stage_enable       : std_logic_vector(c_hl_ccs_num_stages-1 downto 0) := c_slv_hl_stage_enable(c_hl_ccs_num_stages-1 downto 0);

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant mmi_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (mmi) : ";

-- --------------------------------------------
-- internal signals
-- --------------------------------------------

    -- internal clock domain register interface signals
    signal int_wdata         : std_logic_vector(31                 downto 0);
    signal int_rdata         : std_logic_vector(31                 downto 0);
    signal int_address       : std_logic_vector(AV_IF_ADDR_WIDTH-1 downto 0);
    signal int_read          : std_logic;
    signal int_cs            : std_logic;
    signal int_write         : std_logic;
    signal waitreq_int       : std_logic;

    -- register storage
    -- contains:
       --  read only (ro_regs)
       -- read/write (rw_regs)
       -- enable_writes flag
    signal mmi_regs                   : t_mmi_regs := defaults;
    signal mmi_rw_regs_initialised    : std_logic;

    -- this counter ensures that the mmi waits for c_response_lat clocks before
    -- responding to a new Avalon request
    signal waitreq_count              : natural range 0 to 15;
    signal waitreq_count_is_zero      : std_logic;

    -- register error signals
    signal int_ac_1t_r                : std_logic;
    signal trefi_failure_r            : std_logic;

    -- iram ready - calibration complete and USE_IRAM high
    signal iram_ready                 : std_logic;

begin  -- architecture struct

   -- the following signals are reserved for future use
    invert_ac_1t <= '0';


-- --------------------------------------------------------------
-- generate for synchronous avalon interface
-- --------------------------------------------------------------
    simply_registered_avalon : if RESYNCHRONISE_AVALON_DBG = 0 generate
    begin

        process (rst_n, clk)
        begin
            if rst_n = '0' then
                int_wdata           <= (others => '0');
                int_address         <= (others => '0');
                int_read            <= '0';
                int_write           <= '0';
                int_cs              <= '0';
            elsif rising_edge(clk) then
                int_wdata           <= dbg_seq_wr_data;
                int_address         <= dbg_seq_addr;
                int_read            <= dbg_seq_rd;
                int_write           <= dbg_seq_wr;
                int_cs              <= dbg_seq_cs;
            end if;
        end process;

        seq_dbg_rd_data     <= int_rdata;
        seq_dbg_waitrequest <= waitreq_int and (dbg_seq_rd or dbg_seq_wr) and dbg_seq_cs;

    end generate simply_registered_avalon;

-- --------------------------------------------------------------
-- clock domain crossing for asynchronous mmi interface
-- --------------------------------------------------------------
    re_synchronise_avalon : if RESYNCHRONISE_AVALON_DBG = 1 generate

        --clock domain crossing signals
        signal ccd_new_cmd            : std_logic;
        signal ccd_new_cmd_ack        : std_logic;
        signal ccd_cmd_done           : std_logic;
        signal ccd_cmd_done_ack       : std_logic;
        signal ccd_rd_data            : std_logic_vector(dbg_seq_wr_data'range);

        signal ccd_cmd_done_ack_t     : std_logic;
        signal ccd_cmd_done_ack_2t    : std_logic;
        signal ccd_cmd_done_ack_3t    : std_logic;
        signal ccd_cmd_done_t         : std_logic;
        signal ccd_cmd_done_2t        : std_logic;
        signal ccd_cmd_done_3t        : std_logic;

        signal ccd_new_cmd_t       : std_logic;
        signal ccd_new_cmd_2t      : std_logic;
        signal ccd_new_cmd_3t      : std_logic;
        signal ccd_new_cmd_ack_t   : std_logic;
        signal ccd_new_cmd_ack_2t  : std_logic;
        signal ccd_new_cmd_ack_3t  : std_logic;

        signal cmd_pending         : std_logic;

        signal seq_clk_waitreq_int : std_logic;

    begin

        process (rst_n, clk)
        begin
            if rst_n = '0' then
                int_wdata           <= (others => '0');
                int_address         <= (others => '0');
                int_read            <= '0';
                int_write           <= '0';
                int_cs              <= '0';
                ccd_new_cmd_ack     <= '0';
                ccd_new_cmd_t       <= '0';
                ccd_new_cmd_2t      <= '0';
                ccd_new_cmd_3t      <= '0';
            elsif rising_edge(clk) then

                ccd_new_cmd_t       <= ccd_new_cmd;
                ccd_new_cmd_2t      <= ccd_new_cmd_t;
                ccd_new_cmd_3t      <= ccd_new_cmd_2t;

                if ccd_new_cmd_3t = '0' and ccd_new_cmd_2t = '1' then
                    int_wdata           <= dbg_seq_wr_data;
                    int_address         <= dbg_seq_addr;
                    int_read            <= dbg_seq_rd;
                    int_write           <= dbg_seq_wr;
                    int_cs              <= '1';
                    ccd_new_cmd_ack     <= '1';

                elsif ccd_new_cmd_3t = '1' and ccd_new_cmd_2t = '0' then
                    ccd_new_cmd_ack     <= '0';
                end if;

                if int_cs = '1' and waitreq_int= '0' then
                    int_cs    <= '0';
                    int_read  <= '0';
                    int_write <= '0';
                end if;
            end if;

        end process;

        -- process to generate new cmd
        process (dbg_seq_rst_n, dbg_seq_clk)
        begin
            if dbg_seq_rst_n = '0' then
                ccd_new_cmd        <= '0';
                ccd_new_cmd_ack_t  <= '0';
                ccd_new_cmd_ack_2t <= '0';
                ccd_new_cmd_ack_3t <= '0';
                cmd_pending        <= '0';
            elsif rising_edge(dbg_seq_clk) then

                ccd_new_cmd_ack_t   <= ccd_new_cmd_ack;
                ccd_new_cmd_ack_2t  <= ccd_new_cmd_ack_t;
                ccd_new_cmd_ack_3t  <= ccd_new_cmd_ack_2t;

                if ccd_new_cmd = '0' and dbg_seq_cs = '1'  and cmd_pending = '0' then
                    ccd_new_cmd <= '1';
                    cmd_pending <= '1';
                elsif ccd_new_cmd_ack_2t = '1' and ccd_new_cmd_ack_3t = '0' then
                    ccd_new_cmd <= '0';
                end if;

                -- use falling edge of cmd_done
                if cmd_pending = '1' and ccd_cmd_done_2t = '0' and ccd_cmd_done_3t = '1' then
                    cmd_pending <= '0';
                end if;
            end if;
        end process;


        -- process to take read data back and transfer it across the clock domains
        process (rst_n, clk)
        begin
            if rst_n = '0' then
                ccd_cmd_done        <= '0';
                ccd_rd_data         <= (others => '0');
                ccd_cmd_done_ack_3t <= '0';
                ccd_cmd_done_ack_2t <= '0';
                ccd_cmd_done_ack_t  <= '0';

            elsif rising_edge(clk) then

                if ccd_cmd_done_ack_2t = '1' and ccd_cmd_done_ack_3t = '0' then
                    ccd_cmd_done <= '0';
                elsif waitreq_int = '0' then
                    ccd_cmd_done <= '1';
                    ccd_rd_data  <= int_rdata;
                end if;

                ccd_cmd_done_ack_3t <= ccd_cmd_done_ack_2t;
                ccd_cmd_done_ack_2t <= ccd_cmd_done_ack_t;
                ccd_cmd_done_ack_t  <= ccd_cmd_done_ack;
            end if;
        end process;


        process (dbg_seq_rst_n, dbg_seq_clk)
        begin
            if dbg_seq_rst_n = '0' then
                ccd_cmd_done_ack    <= '0';
                ccd_cmd_done_3t     <= '0';
                ccd_cmd_done_2t     <= '0';
                ccd_cmd_done_t      <= '0';
                seq_dbg_rd_data     <= (others => '0');
                seq_clk_waitreq_int <= '1';

            elsif rising_edge(dbg_seq_clk) then
                seq_clk_waitreq_int <= '1';

                if ccd_cmd_done_2t = '1' and ccd_cmd_done_3t = '0' then
                    seq_clk_waitreq_int <= '0';
                    ccd_cmd_done_ack    <= '1';
                    seq_dbg_rd_data     <= ccd_rd_data;  -- if read
                elsif ccd_cmd_done_2t = '0' and ccd_cmd_done_3t = '1' then
                    ccd_cmd_done_ack    <= '0';
                end if;

                ccd_cmd_done_3t <= ccd_cmd_done_2t;
                ccd_cmd_done_2t <= ccd_cmd_done_t;
                ccd_cmd_done_t  <= ccd_cmd_done;
            end if;
        end process;

        seq_dbg_waitrequest <= seq_clk_waitreq_int and (dbg_seq_rd or dbg_seq_wr) and dbg_seq_cs;

    end generate re_synchronise_avalon;


    -- register some inputs for speed.
    process (rst_n, clk)
    begin
        if rst_n = '0' then
            int_ac_1t_r     <= '0';
            trefi_failure_r <= '0';
        elsif rising_edge(clk) then
            int_ac_1t_r     <= int_ac_1t;
            trefi_failure_r <= trefi_failure;
        end if;
    end process;

    -- mmi not able to write to iram in current instance of mmi block
    mmi_iram_enable_writes <= '0';

    -- check if iram ready
    process (rst_n, clk)
    begin
        if rst_n = '0' then
            iram_ready <= '0';
        elsif rising_edge(clk) then
            if USE_IRAM = '0' then
                iram_ready <= '0';
            else
                if ctrl_mmi.ctrl_calibration_success = '1' or ctrl_mmi.ctrl_calibration_fail = '1' then
                    iram_ready <= '1';
                else
                    iram_ready <= '0';
                end if;
            end if;
        end if;
    end process;

-- --------------------------------------------------------------
--  single registered process for mmi access.
-- --------------------------------------------------------------
    process (rst_n, clk)
        variable v_mmi_regs : t_mmi_regs;
    begin
        if rst_n = '0' then

            mmi_regs                <= defaults;
            mmi_rw_regs_initialised <= '0';

            -- this register records whether the c_codeword has been written to address 0x0001
            -- once it has, then other writes are accepted.
            mmi_regs.enable_writes <= '0';

            int_rdata   <= (others => '0');
            waitreq_int <= '1';

            -- clear wait request counter
            waitreq_count <= 0;
            waitreq_count_is_zero <= '1';

            -- iram interface defaults
            mmi_iram <= defaults;

        elsif rising_edge(clk) then
            -- default assignment
            waitreq_int <= '1';

            write_clear(mmi_regs.rw_regs);

            -- only initialise rw_regs once after hard reset
            if mmi_rw_regs_initialised = '0' then

                mmi_rw_regs_initialised <= '1';

                --reset all read/write regs and read path ouput registers and apply default MRS Settings.
                mmi_regs.rw_regs <= defaults(PHY_DEF_MR_1ST,
                                             PHY_DEF_MR_2ND,
                                             PHY_DEF_MR_3RD,
                                             PHY_DEF_MR_4TH,
                                             NOM_DQS_PHASE_SETTING,
                                             PLL_STEPS_PER_CYCLE,
                                             c_pll_360_sweeps,      -- number of times 360 degrees is swept
                                             TRACKING_INTERVAL_IN_MS,
                                             c_hl_stage_enable);

            end if;

            -- bit packing input data structures into the ro_regs structure, for reading
            mmi_regs.ro_regs  <= defaults(dgrb_mmi,
                                          ctrl_mmi,
                                          pll_mmi,
                                          mmi_regs.rw_regs.rw_if_test,
                                          USE_IRAM,
                                          MEM_IF_DQS_CAPTURE,
                                          int_ac_1t_r,
                                          trefi_failure_r,
                                          iram_status,
                                          IRAM_AWIDTH);

            -- write has priority over read
            if int_write = '1' and int_cs = '1' and waitreq_count_is_zero = '1' and waitreq_int = '1' then

                -- mmi local register write
                if to_integer(unsigned(int_address(int_address'high downto 4))) = 0 then

                    v_mmi_regs := mmi_regs;

                    write(v_mmi_regs, to_integer(unsigned(int_address(3 downto 0))), int_wdata);

                    if mmi_regs.enable_writes = '1' then
                        v_mmi_regs.rw_regs.rw_hl_css.hl_css := c_hl_stage_enable or v_mmi_regs.rw_regs.rw_hl_css.hl_css;
                    end if;

                    mmi_regs <= v_mmi_regs;

                    -- handshake for safe transactions
                    waitreq_int   <= '0';
                    waitreq_count <= c_response_lat;

                -- iram write just handshake back (no write supported)
                else

                    waitreq_int   <= '0';
                    waitreq_count <= c_response_lat;

                end if;

            elsif int_read = '1' and int_cs = '1' and waitreq_count_is_zero = '1' and waitreq_int = '1' then

                -- mmi local register read
                if to_integer(unsigned(int_address(int_address'high downto 4))) = 0 then

                    int_rdata <= read(mmi_regs, to_integer(unsigned(int_address(3 downto 0))));

                    waitreq_count <= c_response_lat;
                    waitreq_int   <= '0';  -- acknowledge read command regardless.


                -- iram being addressed
                elsif     to_integer(unsigned(int_address(int_address'high downto c_int_iram_start_size))) = 1
                      and iram_ready = '1'
                      then
                    mmi_iram.read  <= '1';
                    mmi_iram.addr  <= to_integer(unsigned(int_address(IRAM_AWIDTH -1 downto 0)));

                    if iram_status.done = '1' then
                        waitreq_int   <= '0';
                        mmi_iram.read <= '0';
                        waitreq_count <= c_response_lat;
                        int_rdata     <= iram_status.rdata;
                    end if;

                else -- respond and keep the interface from hanging
                    int_rdata     <= x"DEADBEEF";
                    waitreq_int   <= '0';
                    waitreq_count <= c_response_lat;

                end if;

            elsif waitreq_count /= 0 then
                waitreq_count <= waitreq_count -1;

                -- if performing a write, set back to defaults.  If not, default anyway
                mmi_iram <= defaults;

            end if;

            if waitreq_count = 1 or waitreq_count = 0 then
                waitreq_count_is_zero <= '1';   -- as it will be next clock cycle
            else
                waitreq_count_is_zero <= '0';
            end if;

            -- supply iram read data when ready
            if iram_status.done = '1' then
                int_rdata <= iram_status.rdata;
            end if;

        end if;

    end process;

    -- pack the registers into the output data structures
    regs_admin_ctrl                  <= pack_record(mmi_regs.rw_regs);
    parameterisation_rec             <= pack_record(mmi_regs.rw_regs);
    mmi_pll                          <= pack_record(mmi_regs.rw_regs);
    mmi_ctrl                         <= pack_record(mmi_regs.rw_regs);

end architecture struct;
--

-- -----------------------------------------------------------------------------
--  Abstract        : admin block for the non-levelling AFI PHY sequencer
--                    The admin block supports the autonomy of the sequencer from
--                    the memory interface controller. In this task admin handles
--                    memory initialisation (incl. the setting of mode registers)
--                    and memory refresh, bank activation and pre-charge commands
--                    (during memory interface calibration). Once calibration is
--                    complete admin is 'idle' and control of the memory device is
--                    passed to the users chosen memory interface controller. The
--                    supported memory types are exclusively DDR, DDR2 and DDR3.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
    use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The address and command package (alt_mem_phy_addr_cmd_pkg) is used to combine DRAM address
-- and command signals in one record and unify the functions operating on this record.
--
    use work.ddr3_int_phy_alt_mem_phy_addr_cmd_pkg.all;

--
entity ddr3_int_phy_alt_mem_phy_admin is
    generic (
        -- physical interface width definitions
        MEM_IF_DQS_WIDTH      : natural;
        MEM_IF_DWIDTH         : natural;
        MEM_IF_DM_WIDTH       : natural;
        MEM_IF_DQ_PER_DQS     : natural;
        DWIDTH_RATIO          : natural;
        CLOCK_INDEX_WIDTH     : natural;
        MEM_IF_CLK_PAIR_COUNT : natural;
        MEM_IF_ADDR_WIDTH     : natural;
        MEM_IF_BANKADDR_WIDTH : natural;
        MEM_IF_NUM_RANKS      : natural;
        ADV_LAT_WIDTH         : natural;
        MEM_IF_DQSN_EN        : natural;
        MEM_IF_MEMTYPE        : string;

        -- calibration address information
        MEM_IF_CAL_BANK       : natural; -- Bank to which calibration data is written
        MEM_IF_CAL_BASE_ROW   : natural;

        GENERATE_ADDITIONAL_DBG_RTL : natural;
        NON_OP_EVAL_MD              : string;  -- non_operational evaluation mode (used when GENERATE_ADDITIONAL_DBG_RTL = 1)

        -- timing parameters
        MEM_IF_CLK_PS         : natural;
        TINIT_TCK             : natural;  -- initial delay
        TINIT_RST             : natural   -- used for DDR3 device support
    );
    port (
        -- clk / reset
        clk                   : in  std_logic;
        rst_n                 : in  std_logic;

        -- the 2 signals below are unused for non-levelled sequencer (maintained for equivalent interface to levelled sequencer)
        mem_ac_swapped_ranks  : in  std_logic_vector(MEM_IF_NUM_RANKS - 1                     downto 0);
        ctl_cal_byte_lanes    : in  std_logic_vector(MEM_IF_NUM_RANKS * MEM_IF_DQS_WIDTH  - 1 downto 0);

        -- addr/cmd interface
        seq_ac                : out t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);
        seq_ac_sel            : out std_logic;

        -- determined from MR settings
        enable_odt            : out std_logic;

        -- interface to the mmi block
        regs_admin_ctrl_rec   : in  t_admin_ctrl;
        admin_regs_status_rec : out t_admin_stat;
        trefi_failure         : out std_logic;

        -- interface to the ctrl block
        ctrl_admin            : in  t_ctrl_command;
        admin_ctrl            : out t_ctrl_stat;

        -- interface with dgrb/dgwb blocks
        ac_access_req         : in  std_logic;
        ac_access_gnt         : out std_logic;

        -- calibration status signals (from ctrl block)
        cal_fail              : in  std_logic;
        cal_success           : in  std_logic;

        -- recalibrate request issued
        ctl_recalibrate_req   : in std_logic

    );
end entity;

library work;

-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
    use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;

--
architecture struct of ddr3_int_phy_alt_mem_phy_admin is

    constant c_max_mode_reg_index        : natural := 12;

    -- timing below is safe for range 80-400MHz operation - taken from worst case DDR2 (JEDEC JESD79-2E) / DDR3 (JESD79-3B)
    -- Note: timings account for worst case use for both full rate and half rate ALTMEMPHY interfaces
    constant c_init_prech_delay          : natural := 162;  -- precharge delay (360ns = tRFC+10ns) (TXPR for DDR3)
    constant c_trp_in_clks               : natural := 8;    -- set equal to trp / tck (trp = 15ns)
    constant c_tmrd_in_clks              : natural := 4;    -- maximum 4 clock cycles (DDR3)
    constant c_tmod_in_clks              : natural := 8;    -- ODT update from MRS command (tmod = 12ns (DDR2))

    constant c_trrd_min_in_clks          : natural := 4;    -- minimum clk cycles between bank activate cmds (10ns)
    constant c_trcd_min_in_clks          : natural := 8;    -- minimum bank activate to read/write cmd (15ns)

        -- the 2 constants below are parameterised to MEM_IF_CLK_PS due to the large range of possible clock frequency
    constant c_trfc_min_in_clks          : natural := (350000/MEM_IF_CLK_PS)/(DWIDTH_RATIO/2) + 2;  -- refresh-refresh timing (worst case trfc = 350 ns (DDR3))
    constant c_trefi_min_in_clks         : natural := (3900000/MEM_IF_CLK_PS)/(DWIDTH_RATIO/2) - 2; -- average refresh interval worst case trefi = 3.9 us (industrial grade devices)

    constant c_max_num_stacked_refreshes : natural := 8;   -- max no. of stacked refreshes allowed
    constant c_max_wait_value            : natural := 4;   -- delay before moving from s_idle to s_refresh_state

    -- DDR3 specific:
    constant c_zq_init_duration_clks     : natural := 514;  -- full rate (worst case) cycle count for tZQCL init
    constant c_tzqcs                     : natural := 66;   -- number of full rate clock cycles

    -- below is a record which is used to parameterise the address and command signals (addr_cmd) used in this block
    constant c_seq_addr_cmd_config       : t_addr_cmd_config_rec := set_config_rec(MEM_IF_ADDR_WIDTH, MEM_IF_BANKADDR_WIDTH, MEM_IF_NUM_RANKS, DWIDTH_RATIO, MEM_IF_MEMTYPE);

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant admin_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (admin) : ";

    -- state type for admin_state (main state machine of admin block)
    type t_admin_state is
    (
        s_reset,                -- reset state
        s_run_init_seq,         -- run the initialisation sequence (up to but not including MR setting)
        s_program_cal_mrs,      -- program the mode registers ready for calibration (this is the user settings
                                -- with some overloads and extra init functionality)

        s_idle,                 -- idle (i.e. maintaining refresh to max)

        s_topup_refresh,        -- make sure refreshes are maxed out before going on.
        s_topup_refresh_done,   -- wait for tRFC after refresh command

        s_zq_cal_short,         -- ZQCAL short command (issued prior to activate) - DDR3 only

        s_access_act,           -- activate
        s_access,               -- dgrb, dgwb accesses,
        s_access_precharge,     -- precharge all memory banks

        s_prog_user_mrs,        -- program user mode register settings

        s_dummy_wait,           -- wait before going to s_refresh state
        s_refresh,              -- issue a memory refresh command
        s_refresh_done,         -- wait for trfc after refresh command
        s_non_operational       -- special debug state to toggle interface if calibration fails
    );

    signal state : t_admin_state; -- admin block state machine

    -- state type for ac_state
    type t_ac_state  is
    (   s_0 ,
        s_1 ,
        s_2 ,
        s_3 ,
        s_4 ,
        s_5 ,
        s_6 ,
        s_7 ,
        s_8 ,
        s_9 ,
        s_10,
        s_11,
        s_12,
        s_13,
        s_14);

    -- enforce one-hot fsm encoding
    attribute syn_encoding : string;
    attribute syn_encoding of t_ac_state : TYPE is "one-hot";

    signal ac_state               : t_ac_state;                   -- state machine for sub-states of t_admin_state states

    signal stage_counter          : natural range 0 to 2**18 - 1; -- counter to support memory timing delays
    signal stage_counter_zero     : std_logic;

    signal addr_cmd               : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1); -- internal copy of output DRAM addr/cmd signals

    signal mem_init_complete      : std_logic; -- signifies memory initialisation is complete
    signal cal_complete           : std_logic; -- calibration complete (equals: cal_success OR cal_fail)

    signal int_mr0                : std_logic_vector(regs_admin_ctrl_rec.mr0'range); -- an internal copy of mode register settings
    signal int_mr1                : std_logic_vector(regs_admin_ctrl_rec.mr0'range);
    signal int_mr2                : std_logic_vector(regs_admin_ctrl_rec.mr0'range);
    signal int_mr3                : std_logic_vector(regs_admin_ctrl_rec.mr0'range);

    signal refresh_count          : natural range c_trefi_min_in_clks downto 0;            -- determine when refresh is due
    signal refresh_due            : std_logic;                                             -- need to do a refresh now
    signal refresh_done           : std_logic;                                             -- pulse when refresh complete
    signal num_stacked_refreshes  : natural range 0 to c_max_num_stacked_refreshes - 1;    -- can stack upto 8 refreshes (for DDR2)
    signal refreshes_maxed        : std_logic;                                             -- signal refreshes are maxed out
    signal initial_refresh_issued : std_logic;                                             -- to start the refresh counter off

    signal ctrl_rec               : t_ctrl_command;
    -- last state logic
    signal command_started        : std_logic;    -- provides a pulse when admin starts processing a command
    signal command_done           : std_logic;    -- provides a pulse when admin completes processing a command is completed
    signal finished_state         : std_logic;    -- finished current t_admin_state state

    signal admin_req_extended     : std_logic;                               -- keep requests for this block asserted until it is an ack is asserted
    signal current_cs             : natural range 0 to MEM_IF_NUM_RANKS - 1; -- which chip select being programmed at this instance
    signal per_cs_init_seen       : std_logic_vector(MEM_IF_NUM_RANKS - 1 downto 0);

    -- some signals to enable non_operational debug (optimised away if GENERATE_ADDITIONAL_DBG_RTL = 0)
    signal nop_toggle_signal      : t_addr_cmd_signals;
    signal nop_toggle_pin         : natural range 0 to MEM_IF_ADDR_WIDTH - 1;  -- track which pin in a signal to toggle
    signal nop_toggle_value       : std_logic;

begin  -- architecture struct

-- concurrent assignment of internal addr_cmd to output port seq_ac
    process (addr_cmd)
    begin
        seq_ac  <= addr_cmd;
    end process;

-- generate calibration complete signal
   process (cal_success, cal_fail)
   begin
       cal_complete <= cal_success or cal_fail;
   end process;

   -- register the control command record
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            ctrl_rec <= defaults;
        elsif rising_edge(clk) then
            ctrl_rec <= ctrl_admin;
        end if;
    end process;

-- extend the admin block request until ack is asserted
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            admin_req_extended <= '0';
        elsif rising_edge(clk) then
            if ( (ctrl_rec.command_req = '1') and ( curr_active_block(ctrl_rec.command) = admin) ) then
                admin_req_extended <= '1';
            elsif command_started = '1' then  -- this is effectively a copy of command_ack generation
                admin_req_extended <= '0';
            end if;
        end if;
    end process;

-- generate the current_cs signal to track which cs accessed by PHY at any instance
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            current_cs <= 0;
        elsif rising_edge(clk) then
            if ctrl_rec.command_req = '1' then
                current_cs <= ctrl_rec.command_op.current_cs;
            end if;
        end if;
    end process;


-- -----------------------------------------------------------------------------
--  refresh logic: DDR/DDR2/DDR3 allows upto 8 refreshes to be "stacked" or queued up.
--  In the idle state, will ensure refreshes are issued when necessary. Then,
--  when an access_request is received, 7 topup refreshes will be done to max out
--  the number of queued refreshes. That way, we know we have the maximum time
--  available before another refresh is due.
-- -----------------------------------------------------------------------------

-- initial_refresh_issued flag: used to sync refresh_count
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            initial_refresh_issued <= '0';
        elsif rising_edge(clk) then
            if cal_complete = '1' then
                initial_refresh_issued <= '0';
            else
                if state = s_refresh_done or
                   state = s_topup_refresh_done then
                    initial_refresh_issued <= '1';
                end if;
            end if;
        end if;
    end process;

-- refresh timer: used to work out when a refresh is due
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            refresh_count <= c_trefi_min_in_clks;
        elsif rising_edge(clk) then
            if cal_complete = '1' then
                refresh_count <= c_trefi_min_in_clks;
            else
                if refresh_count = 0 or
                  initial_refresh_issued = '0' or
                  (refreshes_maxed = '1' and refresh_done = '1') then -- if refresh issued when already maxed
                    refresh_count <= c_trefi_min_in_clks;
                else
                    refresh_count <= refresh_count - 1;
                end if;
            end if;
        end if;
    end process;

-- refresh_due generation: 1 cycle pulse to indicate that c_trefi_min_in_clks has elapsed, and
-- therefore a refresh is due
    process (clk, rst_n)
    begin
      if rst_n = '0' then
          refresh_due      <= '0';
      elsif rising_edge(clk) then
          if refresh_count = 0 and cal_complete = '0' then
              refresh_due <= '1';
          else
              refresh_due <= '0';
          end if;
      end if;
    end process;


-- counter to keep track of number of refreshes "stacked". NB: Up to 8
-- refreshes can be stacked.
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            num_stacked_refreshes <= 0;
            trefi_failure <= '0'; -- default no trefi failure

        elsif rising_edge (clk) then

            if state = s_reset then
                trefi_failure <= '0'; -- default no trefi failure (in restart)
            end if;

            if cal_complete = '1' then
                num_stacked_refreshes <= 0;
            else
                if refresh_due = '1' and num_stacked_refreshes /= 0 then
                    num_stacked_refreshes <= num_stacked_refreshes - 1;
                elsif refresh_done = '1' and num_stacked_refreshes /= c_max_num_stacked_refreshes - 1 then
                    num_stacked_refreshes <= num_stacked_refreshes + 1;
                end if;

                -- debug message if stacked refreshes are depleted and refresh is due
                if refresh_due = '1' and num_stacked_refreshes = 0 and initial_refresh_issued = '1' then
                    report admin_report_prefix & "error refresh is due and num_stacked_refreshes is zero" severity error;
                    trefi_failure <= '1';  -- persist
                end if;
            end if;

        end if;
    end process;

-- generate signal to state if refreshes are maxed out
    process (clk, rst_n)
    begin
        if rst_n = '0' then

            refreshes_maxed <= '0';

        elsif rising_edge (clk) then

            if num_stacked_refreshes < c_max_num_stacked_refreshes - 1 then
                refreshes_maxed <= '0';
            else
                refreshes_maxed <= '1';
            end if;

        end if;

    end process;

-- ----------------------------------------------------
--  Mode register selection
-- -----------------------------------------------------

    int_mr0(regs_admin_ctrl_rec.mr0'range) <= regs_admin_ctrl_rec.mr0;
    int_mr1(regs_admin_ctrl_rec.mr1'range) <= regs_admin_ctrl_rec.mr1;
    int_mr2(regs_admin_ctrl_rec.mr2'range) <= regs_admin_ctrl_rec.mr2;
    int_mr3(regs_admin_ctrl_rec.mr3'range) <= regs_admin_ctrl_rec.mr3;

-- -------------------------------------------------------
-- State machine
-- -------------------------------------------------------
    process(rst_n, clk)
    begin
        if rst_n = '0' then
            state           <= s_reset;
            command_done    <= '0';
            command_started <= '0';

        elsif rising_edge(clk) then

            -- Last state logic
            command_done    <= '0';
            command_started <= '0';

            case state is

                when s_reset |
                     s_non_operational =>

                    if ctrl_rec.command = cmd_init_dram and admin_req_extended = '1' then
                        state <= s_run_init_seq;
                        command_started <= '1';
                    end if;

                when s_run_init_seq =>

                    if finished_state = '1' then
                          state        <= s_idle;
                          command_done <= '1';
                    end if;

                when s_program_cal_mrs =>

                    if finished_state = '1' then
                        if refreshes_maxed = '0' and mem_init_complete = '1' then  -- only refresh if all ranks initialised
                            state <= s_topup_refresh;
                        else
                            state <= s_idle;
                       end if;
                       command_done <= '1';
                    end if;

                when s_idle =>

                    if ac_access_req = '1' then
                        state           <= s_topup_refresh;

                    elsif ctrl_rec.command = cmd_init_dram and admin_req_extended = '1' then  -- start initialisation sequence
                        state           <= s_run_init_seq;
                        command_started <= '1';

                    elsif ctrl_rec.command = cmd_prog_cal_mr and admin_req_extended = '1' then  -- program mode registers (used for >1 chip select)
                        state           <= s_program_cal_mrs;
                        command_started <= '1';

                    -- always enter s_prog_user_mrs via topup refresh
                    elsif ctrl_rec.command = cmd_prep_customer_mr_setup and admin_req_extended = '1' then
                        state           <=  s_topup_refresh;

                    elsif refreshes_maxed = '0' and mem_init_complete = '1' then  -- only refresh once all ranks initialised
                        state <= s_dummy_wait;
                    end if;

                when s_dummy_wait =>

                    if finished_state = '1' then
                        state <= s_refresh;
                    end if;

                when s_topup_refresh =>

                    if finished_state = '1' then
                        state <= s_topup_refresh_done;
                    end if;

                when s_topup_refresh_done =>

                    if finished_state = '1' then -- to ensure trfc is not violated
                        if refreshes_maxed = '0' then
                            state <= s_topup_refresh;

                        elsif ctrl_rec.command = cmd_prep_customer_mr_setup and admin_req_extended = '1' then
                            state           <=  s_prog_user_mrs;
                            command_started <= '1';

                        elsif ac_access_req = '1' then

                            if MEM_IF_MEMTYPE = "DDR3" then
                                state <= s_zq_cal_short;
                            else
                                state <= s_access_act;
                            end if;

                        else
                            state <= s_idle;
                        end if;
                    end if;

                when s_zq_cal_short =>  -- DDR3 only

                    if finished_state = '1' then
                        state <= s_access_act;
                    end if;

                when s_access_act =>

                    if finished_state = '1' then
                        state <= s_access;
                    end if;

                when s_access =>

                    if ac_access_req = '0' then
                        state <= s_access_precharge;
                    end if;

                when s_access_precharge =>

                    -- ensure precharge all timer has elapsed.
                    if finished_state = '1' then
                        state <= s_idle;
                    end if;

                when s_prog_user_mrs =>

                    if finished_state = '1' then
                        state        <= s_idle;
                        command_done <= '1';
                    end if;

                when s_refresh =>

                    if finished_state = '1' then
                        state <= s_refresh_done;
                    end if;

                when s_refresh_done =>

                    if finished_state = '1' then  -- to ensure trfc is not violated
                        if refreshes_maxed = '0' then
                            state <= s_refresh;
                        else
                            state <= s_idle;
                        end if;
                    end if;

                when others =>

                    state <= s_reset;

            end case;

            if cal_complete = '1' then
                state <= s_idle;
                if GENERATE_ADDITIONAL_DBG_RTL = 1 and cal_success = '0' then
                    state <= s_non_operational; -- if calibration failed and debug enabled then toggle pins in pre-defined pattern
                end if;
            end if;

            -- if recalibrating then put admin in reset state to
            -- avoid issuing refresh commands when not needed
            if ctl_recalibrate_req = '1' then
                state <= s_reset;
            end if;

        end if;
    end process;

-- --------------------------------------------------
-- process to generate initialisation complete
-- --------------------------------------------------
    process (rst_n, clk)

    begin
        if rst_n = '0' then

            mem_init_complete <= '0';

        elsif rising_edge(clk) then

            if to_integer(unsigned(per_cs_init_seen)) = 2**MEM_IF_NUM_RANKS - 1 then
                mem_init_complete <= '1';
            else
                mem_init_complete <= '0';
            end if;

        end if;

    end process;

-- --------------------------------------------------
-- process to generate addr/cmd.
-- --------------------------------------------------
    process(rst_n, clk)

        variable v_mr_overload : std_logic_vector(regs_admin_ctrl_rec.mr0'range);

        -- required for non_operational state only
        variable v_nop_ac_0    : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);
        variable v_nop_ac_1    : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);

    begin
        if rst_n = '0' then

            ac_state           <= s_0;
            stage_counter      <= 0;
            stage_counter_zero <= '1';
            finished_state     <= '0';
            seq_ac_sel         <= '1';
            refresh_done       <= '0';
            per_cs_init_seen   <= (others => '0');

            addr_cmd           <= int_pup_reset(c_seq_addr_cmd_config);

            if GENERATE_ADDITIONAL_DBG_RTL = 1 then
                nop_toggle_signal <= addr;
                nop_toggle_pin    <= 0;
                nop_toggle_value  <= '0';
            end if;

        elsif rising_edge(clk) then

            finished_state <= '0';
            refresh_done   <= '0';


            -- address / command path control
            -- if seq_ac_sel = 1 then sequencer has control of a/c
            -- if seq_ac_sel = 0 then memory controller has control of a/c
            seq_ac_sel        <= '1';

            if cal_complete = '1' then

                if cal_success = '1' or
                   GENERATE_ADDITIONAL_DBG_RTL = 0 then  -- hand over interface if cal successful or no debug enabled

                    seq_ac_sel    <= '0';

                end if;
            end if;

            -- if recalibration request then take control of a/c path
            if ctl_recalibrate_req = '1' then

                seq_ac_sel <= '1';

            end if;

            if state = s_reset then

                addr_cmd      <= reset(c_seq_addr_cmd_config);
                stage_counter <= 0;

            elsif state /= s_run_init_seq and
                  state /= s_non_operational then

                addr_cmd      <= deselect(c_seq_addr_cmd_config, -- configuration
                                          addr_cmd);             -- previous value

            end if;

            if (stage_counter = 1 or stage_counter = 0) then
                stage_counter_zero <= '1';
            else
                stage_counter_zero <= '0';
            end if;

            if stage_counter_zero /= '1' and state /= s_reset then
                stage_counter      <= stage_counter -1;
            else
                stage_counter_zero <= '0';
                case state is

                    when s_run_init_seq =>

                        per_cs_init_seen       <= (others => '0');  -- per cs test

                        if MEM_IF_MEMTYPE = "DDR" or MEM_IF_MEMTYPE = "DDR2" then

                            case ac_state is

                                -- JEDEC (JESD79-2E) stage c
                                when s_0 to s_9 =>
                                    ac_state      <= t_ac_state'succ(ac_state);
                                    stage_counter <= (TINIT_TCK/10)+1;
                                    addr_cmd      <= maintain_pd_or_sr(c_seq_addr_cmd_config,
                                                                       deselect(c_seq_addr_cmd_config, addr_cmd),
                                                                       2**MEM_IF_NUM_RANKS -1);

                                -- JEDEC (JESD79-2E) stage d
                                when s_10   =>
                                    ac_state      <= s_11;
                                    stage_counter <= c_init_prech_delay;
                                    addr_cmd      <= deselect(c_seq_addr_cmd_config, -- configuration
                                                              addr_cmd);             -- previous value

                                when s_11   =>
                                    ac_state       <= s_0;
                                    stage_counter  <= 1;
                                    finished_state <= '1';
                                -- finish sequence by going into s_program_cal_mrs state

                                when others =>
                                    ac_state <= s_0;
                            end case;

                        elsif MEM_IF_MEMTYPE = "DDR3" then  -- DDR3 specific initialisation sequence

                            case ac_state is

                                when s_0    =>
                                    ac_state       <= s_1;
                                    stage_counter  <= TINIT_RST + 1;
                                    addr_cmd       <= reset(c_seq_addr_cmd_config);

                                when s_1 to s_10 =>
                                    ac_state       <= t_ac_state'succ(ac_state);
                                    stage_counter  <= (TINIT_TCK/10) + 1;
                                    addr_cmd       <= maintain_pd_or_sr(c_seq_addr_cmd_config,
                                                                        deselect(c_seq_addr_cmd_config, addr_cmd),
                                                                        2**MEM_IF_NUM_RANKS -1);

                                when s_11   =>
                                    ac_state       <= s_12;
                                    stage_counter  <= c_init_prech_delay;
                                    addr_cmd       <= deselect(c_seq_addr_cmd_config, addr_cmd);

                                when s_12   =>
                                    ac_state       <= s_0;
                                    stage_counter  <= 1;
                                    finished_state <= '1';
                                -- finish sequence by going into s_program_cal_mrs state

                                when others =>
                                    ac_state       <= s_0;

                            end case;

                        else

                            report admin_report_prefix & "unsupported memory type specified" severity error;

                        end if;
                        -- end of initialisation sequence

                    when s_program_cal_mrs =>

                        if MEM_IF_MEMTYPE = "DDR2" then  -- DDR2 style mode register settings
                            case ac_state is
                                when s_0 =>
                                    ac_state      <= s_1;
                                    stage_counter <= 1;
                                    addr_cmd      <= deselect(c_seq_addr_cmd_config,                   -- configuration
                                                              addr_cmd);                               -- previous value

                                -- JEDEC (JESD79-2E) stage d
                                when s_1 =>
                                    ac_state      <= s_2;
                                    stage_counter <= c_trp_in_clks;
                                    addr_cmd      <= precharge_all(c_seq_addr_cmd_config,              -- configuration
                                                                   2**current_cs);                     -- rank

                                -- JEDEC (JESD79-2E) stage e
                                when s_2 =>
                                    ac_state      <= s_3;
                                    stage_counter <= c_tmrd_in_clks;
                                    addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                               2,                                      -- mode register number
                                                               int_mr2(c_max_mode_reg_index downto 0), -- mode register value
                                                               2**current_cs,                          -- rank
                                                               false);                                 -- remap address and bank address

                                -- JEDEC (JESD79-2E) stage f
                                when s_3 =>
                                    ac_state      <= s_4;
                                    stage_counter <= c_tmrd_in_clks;
                                    addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                               3,                                      -- mode register number
                                                               int_mr3(c_max_mode_reg_index downto 0), -- mode register value
                                                               2**current_cs,                          -- rank
                                                               false);                                 -- remap address and bank address

                                -- JEDEC (JESD79-2E) stage g
                                when s_4 =>
                                    ac_state                  <= s_5;
                                    stage_counter             <= c_tmrd_in_clks;
                                    v_mr_overload             := int_mr1(c_max_mode_reg_index downto 0);
                                    v_mr_overload(0)          := '0';    -- override DLL enable
                                    v_mr_overload(9 downto 7) := "000";  -- required in JESD79-2E (but not in JESD79-2B)
                                    addr_cmd                  <= load_mode(c_seq_addr_cmd_config,              -- configuration
                                                                           1,                                  -- mode register number
                                                                           v_mr_overload ,                     -- mode register value
                                                                           2**current_cs,                      -- rank
                                                                           false);                             -- remap address and bank address

                                -- JEDEC (JESD79-2E) stage h
                                when s_5 =>
                                    ac_state      <= s_6;
                                    stage_counter <= c_tmod_in_clks;
                                    addr_cmd      <= dll_reset(c_seq_addr_cmd_config,                  -- configuration
                                                               int_mr0(c_max_mode_reg_index downto 0), -- mode register value
                                                               2**current_cs,                          -- rank
                                                               false);                                 -- remap address and bank address

                                -- JEDEC (JESD79-2E) stage i
                                when s_6 =>
                                    ac_state      <= s_7;
                                    stage_counter <= c_trp_in_clks;
                                    addr_cmd      <= precharge_all(c_seq_addr_cmd_config,              -- configuration
                                                                   2**MEM_IF_NUM_RANKS - 1);           -- rank(s)

                                -- JEDEC (JESD79-2E) stage j
                                when s_7 =>
                                    ac_state      <= s_8;
                                    stage_counter <= c_trfc_min_in_clks;
                                    addr_cmd      <= refresh(c_seq_addr_cmd_config,                    -- configuration
                                                             addr_cmd,                                 -- previous value
                                                             2**current_cs);                           -- rank

                                -- JEDEC (JESD79-2E) stage j - second refresh
                                when s_8 =>
                                    ac_state      <= s_9;
                                    stage_counter <= c_trfc_min_in_clks;
                                    addr_cmd      <= refresh(c_seq_addr_cmd_config,                    -- configuration
                                                             addr_cmd,                                 -- previous value
                                                             2**current_cs);                           -- rank

                                -- JEDEC (JESD79-2E) stage k
                                when s_9 =>
                                    ac_state         <= s_10;
                                    stage_counter    <= c_tmrd_in_clks;

                                    v_mr_overload    := int_mr0(c_max_mode_reg_index downto 3) & "010";   -- override to burst length 4
                                    v_mr_overload(8) := '0';                                              -- required in JESD79-2E
                                    addr_cmd         <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                                  0,                                      -- mode register number
                                                                  v_mr_overload,                          -- mode register value
                                                                  2**current_cs,                          -- rank
                                                                  false);                                 -- remap address and bank address

                                -- JEDEC (JESD79-2E) stage l - wait 200 cycles
                                when s_10 =>
                                    ac_state      <= s_11;
                                    stage_counter <= 200;
                                    addr_cmd      <= deselect(c_seq_addr_cmd_config,                   -- configuration
                                                              addr_cmd);                               -- previous value

                                -- JEDEC (JESD79-2E) stage l - OCD default
                                when s_11 =>
                                    ac_state                  <= s_12;
                                    stage_counter             <= c_tmrd_in_clks;
                                    v_mr_overload             := int_mr1(c_max_mode_reg_index downto 0);
                                    v_mr_overload(9 downto 7) := "111"; -- OCD calibration default (i.e. OCD unused)
                                    v_mr_overload(0)          := '0';   -- override for DLL enable
                                    addr_cmd                  <= load_mode(c_seq_addr_cmd_config,      -- configuration
                                                                           1,                          -- mode register number
                                                                           v_mr_overload ,             -- mode register value
                                                                           2**current_cs,              -- rank
                                                                           false);                     -- remap address and bank address

                                -- JEDEC (JESD79-2E) stage l - OCD cal exit
                                when s_12   =>
                                    ac_state                  <= s_13;
                                    stage_counter             <= c_tmod_in_clks;
                                    v_mr_overload             := int_mr1(c_max_mode_reg_index downto 0);
                                    v_mr_overload(9 downto 7) := "000"; -- OCD calibration exit
                                    v_mr_overload(0)          := '0';   -- override for DLL enable
                                    addr_cmd                  <= load_mode(c_seq_addr_cmd_config,      -- configuration
                                                                           1,                          -- mode register number
                                                                           v_mr_overload ,             -- mode register value
                                                                           2**current_cs,              -- rank
                                                                           false);                     -- remap address and bank address

                                    per_cs_init_seen(current_cs) <= '1';

                                -- JEDEC (JESD79-2E) stage m - cal finished
                                when s_13   =>
                                    ac_state          <= s_0;
                                    stage_counter     <= 1;
                                    finished_state    <= '1';

                                when others =>
                                    null;
                            end case;

                        elsif MEM_IF_MEMTYPE = "DDR" then  -- DDR style mode register setting following JEDEC (JESD79E)

                            case ac_state is
                                when s_0 =>
                                    ac_state      <= s_1;
                                    stage_counter <= 1;
                                    addr_cmd      <= deselect(c_seq_addr_cmd_config,                   -- configuration
                                                              addr_cmd);                               -- previous value

                                when s_1 =>
                                    ac_state      <= s_2;
                                    stage_counter <= c_trp_in_clks;
                                    addr_cmd      <= precharge_all(c_seq_addr_cmd_config,              -- configuration
                                                                   2**current_cs);                     -- rank(s)

                                when s_2 =>
                                    ac_state          <= s_3;
                                    stage_counter     <= c_tmrd_in_clks;
                                    v_mr_overload     := int_mr1(c_max_mode_reg_index downto 0);
                                    v_mr_overload(0)  := '0'; -- override DLL enable
                                    addr_cmd          <= load_mode(c_seq_addr_cmd_config,              -- configuration
                                                                   1,                                  -- mode register number
                                                                   v_mr_overload ,                     -- mode register value
                                                                   2**current_cs,                      -- rank
                                                                   false);                             -- remap address and bank address

                                when s_3 =>
                                    ac_state      <= s_4;
                                    stage_counter <= c_tmod_in_clks;
                                    addr_cmd      <= dll_reset(c_seq_addr_cmd_config,                  -- configuration
                                                               int_mr0(c_max_mode_reg_index downto 0), -- mode register value
                                                               2**current_cs,                          -- rank
                                                               false);                                 -- remap address and bank address

                                when s_4 =>
                                    ac_state      <= s_5;
                                    stage_counter <= c_trp_in_clks;
                                    addr_cmd      <= precharge_all(c_seq_addr_cmd_config,              -- configuration
                                                                   2**MEM_IF_NUM_RANKS - 1);           -- rank(s)

                                when s_5 =>
                                    ac_state      <= s_6;
                                    stage_counter <= c_trfc_min_in_clks;
                                    addr_cmd      <= refresh(c_seq_addr_cmd_config,                    -- configuration
                                                             addr_cmd,                                 -- previous value
                                                             2**current_cs);                           -- rank

                                when s_6 =>
                                    ac_state      <= s_7;
                                    stage_counter <= c_trfc_min_in_clks;
                                    addr_cmd      <= refresh(c_seq_addr_cmd_config,                    -- configuration
                                                             addr_cmd,                                 -- previous value
                                                             2**current_cs);                           -- rank

                                when s_7 =>
                                    ac_state      <= s_8;
                                    stage_counter <= c_tmrd_in_clks;

                                    v_mr_overload    := int_mr0(c_max_mode_reg_index downto 3) & "010";   -- override to burst length 4

                                    addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                               0,                                      -- mode register number
                                                               v_mr_overload,                          -- mode register value
                                                               2**current_cs,                          -- rank
                                                               false);                                 -- remap address and bank address

                                when s_8 =>
                                    ac_state      <= s_9;
                                    stage_counter <= 200;
                                    addr_cmd      <= deselect(c_seq_addr_cmd_config,                   -- configuration
                                                              addr_cmd);                               -- previous value

                                    per_cs_init_seen(current_cs) <= '1';

                                when s_9 =>
                                    ac_state          <= s_0;
                                    stage_counter     <= 1;
                                    finished_state    <= '1';

                                when others =>
                                    null;
                            end case;

                        elsif MEM_IF_MEMTYPE = "DDR3" then

                            case ac_state is

                                when s_0    =>
                                    ac_state      <= s_1;
                                    stage_counter <= c_trp_in_clks;
                                    addr_cmd      <= deselect(c_seq_addr_cmd_config,                    -- configuration
                                                              addr_cmd);                                -- previous value

                                when s_1    =>
                                    ac_state      <= s_2;
                                    stage_counter <= c_tmrd_in_clks;
                                    addr_cmd      <= load_mode(c_seq_addr_cmd_config,                   -- configuration
                                                               2,                                       -- mode register number
                                                               int_mr2(c_max_mode_reg_index downto 0),  -- mode register value
                                                               2**current_cs,                           -- rank
                                                               false);                                  -- remap address and bank address

                                when s_2    =>
                                    ac_state      <= s_3;
                                    stage_counter <= c_tmrd_in_clks;
                                    addr_cmd      <= load_mode(c_seq_addr_cmd_config,                   -- configuration
                                                               3,                                       -- mode register number
                                                               int_mr3(c_max_mode_reg_index downto 0),  -- mode register value
                                                               2**current_cs,                           -- rank
                                                               false);                                  -- remap address and bank address

                                when s_3    =>
                                    ac_state          <= s_4;
                                    stage_counter     <= c_tmrd_in_clks;

                                    v_mr_overload     := int_mr1(c_max_mode_reg_index downto 0);
                                    v_mr_overload(0)  := '0'; -- Override for DLL enable
                                    v_mr_overload(12) := '0'; -- output buffer enable.
                                    v_mr_overload(7)  := '0'; -- Disable Write levelling

                                    addr_cmd          <= load_mode(c_seq_addr_cmd_config,               -- configuration
                                                                   1,                                   -- mode register number
                                                                   v_mr_overload,                       -- mode register value
                                                                   2**current_cs,                       -- rank
                                                                   false);                              -- remap address and bank address

                                when s_4    =>
                                    ac_state                  <= s_5;
                                    stage_counter             <= c_tmod_in_clks;

                                    v_mr_overload             := int_mr0(c_max_mode_reg_index downto 0);

                                    v_mr_overload(1 downto 0) := "01"; -- override to on the fly burst length choice
                                    v_mr_overload(7)          := '0';  -- test mode not enabled
                                    v_mr_overload(8)          := '1';  -- DLL reset

                                    addr_cmd                  <= load_mode(c_seq_addr_cmd_config,       -- configuration
                                                                           0,                           -- mode register number
                                                                           v_mr_overload,               -- mode register value
                                                                           2**current_cs,               -- rank
                                                                           false);                      -- remap address and bank address


                                when s_5    =>
                                    ac_state      <= s_6;
                                    stage_counter <= c_zq_init_duration_clks;
                                    addr_cmd      <= ZQCL(c_seq_addr_cmd_config,                        -- configuration
                                                          2**current_cs);                               -- rank

                                    per_cs_init_seen(current_cs) <= '1';

                                when s_6          =>
                                    ac_state       <= s_0;
                                    stage_counter  <= 1;
                                    finished_state <= '1';

                                when others =>
                                    ac_state <= s_0;

                            end case;

                        else

                            report admin_report_prefix & "unsupported memory type specified" severity error;

                        end if;

                        -- end of s_program_cal_mrs case

                    when s_prog_user_mrs =>

                        case ac_state is
                            when s_0 =>
                                ac_state      <= s_1;
                                stage_counter <= 1;
                                addr_cmd      <= deselect(c_seq_addr_cmd_config,                   -- configuration
                                                              addr_cmd);                           -- previous value

                            when s_1 =>

                                if MEM_IF_MEMTYPE = "DDR" then -- for DDR memory skip MR2/3 because not present
                                    ac_state      <= s_4;
                                else                           -- for DDR2/DDR3 all MRs programmed
                                    ac_state      <= s_2;
                                end if;

                                stage_counter <= c_trp_in_clks;
                                addr_cmd      <= precharge_all(c_seq_addr_cmd_config,              -- configuration
                                                               2**MEM_IF_NUM_RANKS - 1);           -- rank(s)

                            when s_2 =>
                                ac_state      <= s_3;
                                stage_counter <= c_tmrd_in_clks;
                                addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                           2,                                      -- mode register number
                                                           int_mr2(c_max_mode_reg_index downto 0), -- mode register value
                                                           2**current_cs,                          -- rank
                                                           false);                                 -- remap address and bank address

                            when s_3 =>
                                ac_state      <= s_4;
                                stage_counter <= c_tmrd_in_clks;
                                addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                           3,                                      -- mode register number
                                                           int_mr3(c_max_mode_reg_index downto 0), -- mode register value
                                                           2**current_cs,                          -- rank
                                                           false);                                 -- remap address and bank address

                                if to_integer(unsigned(int_mr3)) /= 0 then
                                    report admin_report_prefix & " mode register 3 is expected to have a value of 0 but has a value of : " &
                                                                 integer'image(to_integer(unsigned(int_mr3))) severity warning;
                                end if;

                            when s_4 =>
                                ac_state      <= s_5;
                                stage_counter <= c_tmrd_in_clks;
                                addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                           1,                                      -- mode register number
                                                           int_mr1(c_max_mode_reg_index downto 0), -- mode register value
                                                           2**current_cs,                          -- rank
                                                           false);                                 -- remap address and bank address

                                if (MEM_IF_DQSN_EN = 0) and (int_mr1(10) = '0') and (MEM_IF_MEMTYPE = "DDR2") then
                                    report admin_report_prefix & "mode register and generic conflict:" & LF &
                                                                 "* generic MEM_IF_DQSN_EN is set to 'disable' DQSN" & LF &
                                                                 "* user mode register MEM_IF_MR1 bit 10 is set to 'enable' DQSN" severity warning;
                                end if;

                            when s_5 =>
                                ac_state      <= s_6;
                                stage_counter <= c_tmod_in_clks;
                                addr_cmd      <= load_mode(c_seq_addr_cmd_config,                  -- configuration
                                                           0,                                      -- mode register number
                                                           int_mr0(c_max_mode_reg_index downto 0), -- mode register value
                                                           2**current_cs,                          -- rank
                                                           false);                                 -- remap address and bank address

                            when s_6 =>
                                ac_state      <= s_7;
                                stage_counter <= 1;

                            when s_7 =>
                                ac_state       <= s_0;
                                stage_counter  <= 1;
                                finished_state <= '1';

                            when others =>
                                ac_state <= s_0;

                        end case;

                        -- end of s_prog_user_mr case

                     when s_access_precharge =>

                         case ac_state is
                             when s_0 =>
                                 ac_state      <= s_1;
                                 stage_counter <= 8;
                                 addr_cmd      <= deselect(c_seq_addr_cmd_config,                      -- configuration
                                                           addr_cmd);                                  -- previous value

                             when s_1 =>
                                 ac_state      <= s_2;
                                 stage_counter <= c_trp_in_clks;
                                 addr_cmd      <= precharge_all(c_seq_addr_cmd_config,                 -- configuration
                                                                2**MEM_IF_NUM_RANKS - 1);              -- rank(s)

                             when s_2 =>
                                 ac_state       <= s_0;
                                 stage_counter  <= 1;
                                 finished_state <= '1';

                             when others =>
                                 ac_state <= s_0;
                         end case;

                    when s_topup_refresh | s_refresh =>

                        case ac_state is
                            when s_0 =>
                                ac_state      <= s_1;
                                stage_counter <= 1;

                            when s_1 =>
                                ac_state      <= s_2;
                                stage_counter <= 1;
                                addr_cmd      <= refresh(c_seq_addr_cmd_config,                        -- configuration
                                                         addr_cmd,                                     -- previous value
                                                         2**MEM_IF_NUM_RANKS - 1);                     -- rank

                            when s_2 =>
                                ac_state       <= s_0;
                                stage_counter  <= 1;
                                finished_state <= '1';

                            when others =>
                                ac_state <= s_0;
                        end case;

                    when s_topup_refresh_done | s_refresh_done =>

                        case ac_state is
                            when s_0 =>
                                ac_state      <= s_1;
                                stage_counter <= c_trfc_min_in_clks;
                                refresh_done  <= '1';      -- ensure trfc not violated
                            when s_1 =>
                                ac_state       <= s_0;
                                stage_counter  <= 1;
                                finished_state <= '1';

                            when others =>
                                ac_state <= s_0;
                        end case;

                    when s_zq_cal_short     =>

                        case ac_state is
                            when s_0    =>
                                ac_state      <= s_1;
                                stage_counter <= 1;

                            when s_1    =>
                                ac_state      <= s_2;
                                stage_counter <= c_tzqcs;
                                addr_cmd      <= ZQCS(c_seq_addr_cmd_config,                  -- configuration
                                                      2**current_cs);                         -- all ranks

                            when s_2    =>
                                ac_state       <= s_0;
                                stage_counter  <= 1;
                                finished_state <= '1';

                            when others =>
                                ac_state <= s_0;

                        end case;

                    when s_access_act =>

                        case ac_state is
                            when s_0 =>
                                ac_state      <= s_1;
                                stage_counter <= c_trrd_min_in_clks;

                            when s_1 =>
                                ac_state      <= s_2;
                                stage_counter <= c_trcd_min_in_clks;
                                addr_cmd      <= activate(c_seq_addr_cmd_config,                       -- configuration
                                                          addr_cmd,                                    -- previous value
                                                          MEM_IF_CAL_BANK,                             -- bank
                                                          MEM_IF_CAL_BASE_ROW,                         -- row address
                                                          2**current_cs);                              -- rank

                            when s_2 =>
                                ac_state       <= s_0;
                                stage_counter  <= 1;
                                finished_state <= '1';

                            when others =>
                                ac_state <= s_0;
                        end case;

                    -- counter to delay transition from s_idle to s_refresh - this is to ensure a refresh command is not sent
                    -- just as we enter operational state (could cause a trfc violation)
                    when s_dummy_wait =>

                        case ac_state is
                            when s_0 =>
                                ac_state      <= s_1;
                                stage_counter <= c_max_wait_value;

                            when s_1 =>
                                ac_state       <= s_0;
                                stage_counter  <= 1;
                                finished_state <= '1';

                            when others =>
                                ac_state <= s_0;
                        end case;

                    when s_reset =>

                        stage_counter <= 1;

                        -- default some s_non_operational signals
                        if GENERATE_ADDITIONAL_DBG_RTL = 1 then
                            nop_toggle_signal <= addr;
                            nop_toggle_pin    <= 0;
                            nop_toggle_value  <= '0';
                        end if;

                    when s_non_operational =>  -- if failed then output a recognised pattern to the memory (Only executes if GENERATE_ADDITIONAL_DBG_RTL set)

                        addr_cmd      <= deselect(c_seq_addr_cmd_config,                               -- configuration
                                                  addr_cmd);                                           -- previous value

                        if NON_OP_EVAL_MD = "PIN_FINDER" then  -- toggle pins in turn for 200 memory clk cycles

                            stage_counter  <= 200/(DWIDTH_RATIO/2);  -- 200 mem_clk cycles

                            case nop_toggle_signal is

                                when addr =>

                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, addr,  '0');
                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, addr,  nop_toggle_value, nop_toggle_pin);

                                    nop_toggle_value <= not nop_toggle_value;

                                    if nop_toggle_value = '1' then
                                        if nop_toggle_pin = MEM_IF_ADDR_WIDTH-1 then
                                            nop_toggle_signal <= ba;
                                            nop_toggle_pin    <= 0;
                                        else
                                            nop_toggle_pin    <= nop_toggle_pin + 1;
                                        end if;
                                    end if;

                                when ba =>

                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, ba,  '0');
                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, ba,  nop_toggle_value, nop_toggle_pin);

                                    nop_toggle_value <= not nop_toggle_value;

                                    if nop_toggle_value = '1' then
                                        if nop_toggle_pin = MEM_IF_BANKADDR_WIDTH-1 then
                                            nop_toggle_signal <= cas_n;
                                            nop_toggle_pin    <= 0;
                                        else
                                            nop_toggle_pin    <= nop_toggle_pin + 1;
                                        end if;
                                    end if;

                                when cas_n =>

                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, cas_n, nop_toggle_value);

                                    nop_toggle_value <= not nop_toggle_value;

                                    if nop_toggle_value = '1' then
                                        nop_toggle_signal <= ras_n;
                                    end if;

                                when ras_n =>

                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, ras_n, nop_toggle_value);

                                    nop_toggle_value <= not nop_toggle_value;

                                    if nop_toggle_value = '1' then
                                        nop_toggle_signal <= we_n;
                                    end if;

                                when we_n =>

                                    addr_cmd <= mask (c_seq_addr_cmd_config, addr_cmd, we_n, nop_toggle_value);

                                    nop_toggle_value <= not nop_toggle_value;

                                    if nop_toggle_value = '1' then
                                        nop_toggle_signal <= addr;
                                    end if;

                                when others =>

                                    report admin_report_prefix & " an attempt to toggle a non addr/cmd pin detected" severity failure;

                            end case;

                        elsif NON_OP_EVAL_MD = "SI_EVALUATOR" then  -- toggle all addr/cmd pins at fmax

                            stage_counter      <= 0;  -- every mem_clk cycle
                            stage_counter_zero <= '1';

                            v_nop_ac_0 := mask (c_seq_addr_cmd_config, addr_cmd,   addr,  nop_toggle_value);
                            v_nop_ac_0 := mask (c_seq_addr_cmd_config, v_nop_ac_0, ba,    nop_toggle_value);
                            v_nop_ac_0 := mask (c_seq_addr_cmd_config, v_nop_ac_0, we_n,  nop_toggle_value);
                            v_nop_ac_0 := mask (c_seq_addr_cmd_config, v_nop_ac_0, ras_n, nop_toggle_value);
                            v_nop_ac_0 := mask (c_seq_addr_cmd_config, v_nop_ac_0, cas_n, nop_toggle_value);

                            v_nop_ac_1 := mask (c_seq_addr_cmd_config, addr_cmd,   addr,  not nop_toggle_value);
                            v_nop_ac_1 := mask (c_seq_addr_cmd_config, v_nop_ac_1, ba,    not nop_toggle_value);
                            v_nop_ac_1 := mask (c_seq_addr_cmd_config, v_nop_ac_1, we_n,  not nop_toggle_value);
                            v_nop_ac_1 := mask (c_seq_addr_cmd_config, v_nop_ac_1, ras_n, not nop_toggle_value);
                            v_nop_ac_1 := mask (c_seq_addr_cmd_config, v_nop_ac_1, cas_n, not nop_toggle_value);

                            for i in 0 to DWIDTH_RATIO/2 - 1 loop
                                if i mod 2 = 0 then
                                    addr_cmd(i) <= v_nop_ac_0(i);
                                else
                                    addr_cmd(i) <= v_nop_ac_1(i);
                                end if;
                            end loop;

                            if DWIDTH_RATIO = 2 then
                                nop_toggle_value <= not nop_toggle_value;
                            end if;

                        else

                            report admin_report_prefix & "unknown non-operational evaluation mode " & NON_OP_EVAL_MD severity failure;

                        end if;

                    when others =>

                        addr_cmd      <= deselect(c_seq_addr_cmd_config,                               -- configuration
                                                  addr_cmd);                                           -- previous value
                        stage_counter <= 1;

                end case;
            end if;

        end if;
    end process;

-- -------------------------------------------------------------------
-- output packing of mode register settings and enabling of ODT
-- -------------------------------------------------------------------
    process (int_mr0, int_mr1, int_mr2, int_mr3, mem_init_complete)
    begin
        admin_regs_status_rec.mr0       <= int_mr0;
        admin_regs_status_rec.mr1       <= int_mr1;
        admin_regs_status_rec.mr2       <= int_mr2;
        admin_regs_status_rec.mr3       <= int_mr3;
        admin_regs_status_rec.init_done <= mem_init_complete;
        enable_odt                      <= int_mr1(2) or int_mr1(6); -- if ODT enabled in MR settings (i.e. MR1 bits 2 or 6 /= 0)
    end process;

-- --------------------------------------------------------------------------------
-- generation of handshake signals with ctrl, dgrb and dgwb blocks (this includes
-- command ack, command done for ctrl and access grant for dgrb/dgwb)
-- --------------------------------------------------------------------------------
    process (rst_n, clk)
    begin
        if rst_n = '0' then

            admin_ctrl    <= defaults;
            ac_access_gnt <= '0';

        elsif rising_edge(clk) then

            admin_ctrl    <= defaults;
            ac_access_gnt <= '0';

            admin_ctrl.command_ack  <= command_started;
            admin_ctrl.command_done <= command_done;

            if state = s_access then
                ac_access_gnt <= '1';
            end if;

        end if;

    end process;

end architecture struct;
--

-- -----------------------------------------------------------------------------
--  Abstract        : inferred ram for the non-levelling AFI PHY sequencer
--                    The inferred ram is used in the iram block to store
--                    debug information about the sequencer. It is variable in
--                    size based on the IRAM_AWIDTH generic and is of size
--                    32 * (2 ** IRAM_ADDR_WIDTH) bits
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

--
entity ddr3_int_phy_alt_mem_phy_iram_ram IS
    generic (
        IRAM_AWIDTH     : natural
   );
    port (
        clk              :  in   std_logic;
        rst_n            :  in   std_logic;

        -- ram ports
        addr             :  in   unsigned(IRAM_AWIDTH-1 downto 0);
        wdata            :  in   std_logic_vector(31 downto 0);
        write            :  in   std_logic;
        rdata            : out   std_logic_vector(31 downto 0)
    );
end entity;

--
architecture struct of ddr3_int_phy_alt_mem_phy_iram_ram is

-- infer ram

    constant c_max_ram_address : natural := 2**IRAM_AWIDTH -1;

    -- registered ram signals
    signal addr_r  : unsigned(IRAM_AWIDTH-1 downto 0);
    signal wdata_r : std_logic_vector(31 downto 0);
    signal write_r : std_logic;
    signal rdata_r : std_logic_vector(31 downto 0);

    -- ram storage array
    type   t_iram is array (0 to c_max_ram_address) of std_logic_vector(31 downto 0);
    signal iram_ram            : t_iram;
    attribute altera_attribute : string;
    attribute altera_attribute of iram_ram : signal is "-name ADD_PASS_THROUGH_LOGIC_TO_INFERRED_RAMS ""OFF""";

begin  -- architecture struct

    -- inferred ram instance - standard ram logic
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            rdata_r <= (others => '0');

        elsif rising_edge(clk) then
            if write_r = '1' then
                iram_ram(to_integer(addr_r)) <= wdata_r;
            end if;

            rdata_r  <= iram_ram(to_integer(addr_r));
        end if;

    end process;

    -- register i/o for speed
    process (clk, rst_n)
    begin
        if rst_n = '0' then

            rdata   <= (others => '0');
            write_r <= '0';
            addr_r  <= (others => '0');
            wdata_r <= (others => '0');

        elsif rising_edge(clk) then

            rdata   <= rdata_r;
            write_r <= write;
            addr_r  <= addr;
            wdata_r <= wdata;

        end if;
    end process;

end architecture struct;
--

-- -----------------------------------------------------------------------------
--  Abstract        : iram block for the non-levelling AFI PHY sequencer
--                    This block is an optional storage of debug information for
--                    the sequencer. In the current form the iram stores header
--                    information about the arrangement of the sequencer and pass/
--                    fail information for per-delay/phase/pin sweeps for the
--                    read resynch phase calibration stage. Support for debug of
--                    additional commands can be added at a later date
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The altmemphy iram ram (alt_mem_phy_iram_ram) is an inferred ram memory to implement the debug
-- iram ram block
--
use work.ddr3_int_phy_alt_mem_phy_iram_ram;

--
entity ddr3_int_phy_alt_mem_phy_iram is
    generic (
        -- physical interface width definitions
        MEM_IF_MEMTYPE                 : string;
        FAMILYGROUP_ID                 : natural;
        MEM_IF_DQS_WIDTH               : natural;
        MEM_IF_DQ_PER_DQS              : natural;
        MEM_IF_DWIDTH                  : natural;
        MEM_IF_DM_WIDTH                : natural;
        MEM_IF_NUM_RANKS               : natural;
        IRAM_AWIDTH                    : natural;
        REFRESH_COUNT_INIT             : natural;
        PRESET_RLAT                    : natural;
        PLL_STEPS_PER_CYCLE            : natural;
        CAPABILITIES                   : natural;
        IP_BUILDNUM                    : natural
   );
    port (
        -- clk / reset
        clk                            : in    std_logic;
        rst_n                          : in    std_logic;

        -- read interface from mmi block:
        mmi_iram                       : in    t_iram_ctrl;
        mmi_iram_enable_writes         : in    std_logic;

        --iram status signal (includes read data from iram)
        iram_status                    : out   t_iram_stat;
        iram_push_done                 : out   std_logic;

        -- from ctrl block
        ctrl_iram                      : in    t_ctrl_command;

        -- from dgrb block
        dgrb_iram                      : in    t_iram_push;

        -- from admin block
        admin_regs_status_rec          : in    t_admin_stat;

        -- current write position in the iram
        ctrl_idib_top                  : in    natural range 0 to 2 ** IRAM_AWIDTH - 1;

        ctrl_iram_push                 : in    t_ctrl_iram;

        -- the following signals are unused and reserved for future use
        dgwb_iram                      : in    t_iram_push
    );
end entity;

library work;

-- The registers package (alt_mem_phy_regs_pkg) is used to combine the definition of the
-- registers for the mmi status registers and functions/procedures applied to the registers
--
use work.ddr3_int_phy_alt_mem_phy_regs_pkg.all;

--
architecture struct of ddr3_int_phy_alt_mem_phy_iram is

-- -------------------------------------------
-- IHI fields
-- -------------------------------------------

    -- memory type , Quartus Build No., Quartus release, sequencer architecture version :
    signal   memtype                : std_logic_vector(7 downto 0);
    signal   ihi_self_description   : std_logic_vector(31 downto 0);

    signal   ihi_self_description_extra : std_logic_vector(31 downto 0);

    -- for iram address generation:
    signal   curr_iram_offset       : natural range 0 to 2 ** IRAM_AWIDTH - 1;

    -- set read latency for iram_rdata_valid signal control:
    constant c_iram_rlat            : natural := 3; -- iram read latency (increment if read pipelining added

    -- for rdata valid generation:
    signal   read_valid_ctr         : natural range 0 to c_iram_rlat;
    signal   iram_addr_r            : unsigned(IRAM_AWIDTH downto 0);

    constant c_ihi_phys_if_desc     : std_logic_vector(31 downto 0) := std_logic_vector (to_unsigned(MEM_IF_NUM_RANKS,8) & to_unsigned(MEM_IF_DM_WIDTH,8) & to_unsigned(MEM_IF_DQS_WIDTH,8) & to_unsigned(MEM_IF_DWIDTH,8));
    constant c_ihi_timing_info      : std_logic_vector(31 downto 0) := X"DEADDEAD";

    constant c_ihi_ctrl_ss_word2    : std_logic_vector(31 downto 0) := std_logic_vector (to_unsigned(PRESET_RLAT,16) & X"0000");

    -- IDIB header codes
    constant c_idib_header_code0    : std_logic_vector(7 downto 0)  := X"4A";
    constant c_idib_footer_code     : std_logic_vector(7 downto 0)  := X"5A";

    -- encoded Quartus version
    -- constant c_quartus_version : natural := 0;  -- Quartus 7.2
    -- constant c_quartus_version : natural := 1;  -- Quartus 8.0
    --constant c_quartus_version  : natural := 2;  -- Quartus 8.1
    --constant c_quartus_version  : natural := 3;  -- Quartus 9.0
    --constant c_quartus_version  : natural := 4;  -- Quartus 9.0sp2
    --constant c_quartus_version  : natural := 5;  -- Quartus 9.1
    --constant c_quartus_version  : natural := 6;  -- Quartus 9.1sp1?
    --constant c_quartus_version  : natural := 7;  -- Quartus 9.1sp2?
    constant c_quartus_version  : natural := 8;  -- Quartus 10.0
    -- constant c_quartus_version : natural := 114;   -- reserved

    -- allow for different variants for debug i/f
    constant c_dbg_if_version   : natural := 2;

    -- sequencer type 1 for levelling, 2 for non-levelling
    constant c_sequencer_type   : natural := 2;
    -- a prefix for all report signals to identify phy and sequencer block
--
    constant iram_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (iram) : ";

-- -------------------------------------------
-- signal and type declarations
-- -------------------------------------------

    type t_iram_state is ( s_reset,                 -- system reset
                           s_pre_init_ram,          -- identify pre-initialisation
                           s_init_ram,              -- zero all locations
                           s_idle,                  -- default state
                           s_word_access_ram,       -- mmi access to the iram (post-calibration)
                           s_word_fetch_ram_rdata,  -- sample read data from RAM
                           s_word_fetch_ram_rdata_r,-- register the sampling of data from RAM (to improve timing)
                           s_word_complete,         -- finalise iram ram write
                           s_idib_header_write,     -- when starting a command
                           s_idib_header_inc_addr,  -- address increment
                           s_idib_footer_write,     -- unique footer to indicate end of data
                           s_cal_data_read,         -- read RAM location (read occurs continuously from idle state)
                           s_cal_data_read_r,
                           s_cal_data_modify,       -- modify RAM location (read occurs continuously)
                           s_cal_data_write,        -- write modified value back to RAM
                           s_ihi_header_word0_wr,   -- from 0 to 6 writing iram header info
                           s_ihi_header_word1_wr,
                           s_ihi_header_word2_wr,
                           s_ihi_header_word3_wr,
                           s_ihi_header_word4_wr,
                           s_ihi_header_word5_wr,
                           s_ihi_header_word6_wr,
                           s_ihi_header_word7_wr-- end writing iram header info
                           );

    signal state              : t_iram_state;

    signal contested_access   : std_logic;
    signal idib_header_count  : std_logic_vector(7 downto 0);

    -- register a new cmd request
    signal new_cmd            : std_logic;
    signal cmd_processed      : std_logic;

    -- signals to control dgrb writes
    signal iram_modified_data : std_logic_vector(31 downto 0);          -- scratchpad memory for read-modify-write

-- -------------------------------------------
-- physical ram connections
-- -------------------------------------------

-- Note that the iram_addr here is created IRAM_AWIDTH downto 0, and not
-- IRAM_AWIDTH-1 downto 0.  This means that the MSB is outside the addressable
-- area of the RAM.  The purpose of this is that this shall be our memory
-- overflow bit. It shall be directly connected to the iram_out_of_memory flag

    -- 32-bit interface port (read and write)
    signal iram_addr   : unsigned(IRAM_AWIDTH downto 0);
    signal iram_wdata  : std_logic_vector(31 downto 0);
    signal iram_rdata  : std_logic_vector(31 downto 0);
    signal iram_write  : std_logic;

    -- signal generated external to the iram to say when read data is valid
    signal iram_rdata_valid : std_logic;

    -- The FSM owns local storage that is loaded with the wdata/addr from the
    -- requesting sub-block, which is then fed to the iram's wdata/addr in turn
    -- until all data has gone across
    signal fsm_read    : std_logic;

-- -------------------------------------------
-- multiplexed push data
-- -------------------------------------------
    signal iram_done     : std_logic;                     -- unused
    signal iram_pushdata : std_logic_vector(31 downto 0);
    signal pending_push  : std_logic;                     -- push data to RAM
    signal iram_wordnum  : natural range 0 to 511;
    signal iram_bitnum   : natural range 0 to 31;

begin  -- architecture struct

-- -------------------------------------------
-- iram ram instantiation
-- -------------------------------------------
-- Note that the IRAM_AWIDTH is the physical number of address bits that the RAM has.
-- However, for out of range access detection purposes, an additional bit is added to
-- the various address signals. The iRAM does not register any of its inputs as the addr,
-- wdata etc are registered directly before being driven to it.

-- The dgrb accesses are of format read-modify-write to a single bit of a 32-bit word, the
-- mmi reads and header writes are in 32-bit words

    --
    ram : entity ddr3_int_phy_alt_mem_phy_iram_ram
        generic map (
        IRAM_AWIDTH => IRAM_AWIDTH
    )
    port map (
        clk   => clk,
        rst_n => rst_n,
        addr  => iram_addr(IRAM_AWIDTH-1 downto 0),
        wdata => iram_wdata,
        write => iram_write,
        rdata => iram_rdata
    );

-- -------------------------------------------
-- IHI fields
-- asynchronously
-- -------------------------------------------

    -- this field identifies the type of memory
    memtype <= X"03" when (MEM_IF_MEMTYPE =  "DDR3") else
               X"02" when (MEM_IF_MEMTYPE =  "DDR2") else
               X"01" when (MEM_IF_MEMTYPE =   "DDR") else
               X"10" when (MEM_IF_MEMTYPE = "QDRII") else
               X"00" ;

    -- this field indentifies the gross level description of the sequencer
    ihi_self_description <=   memtype
                            & std_logic_vector(to_unsigned(IP_BUILDNUM,8))
                            & std_logic_vector(to_unsigned(c_quartus_version,8))
                            & std_logic_vector(to_unsigned(c_dbg_if_version,8));

    -- some extra information for the debug gui - sequencer type and familygroup
    ihi_self_description_extra <=       std_logic_vector(to_unsigned(FAMILYGROUP_ID,4))
                                    &   std_logic_vector(to_unsigned(c_sequencer_type,4))
                                    & x"000000";


-- -------------------------------------------
-- check for contested memory accesses
-- -------------------------------------------

    process(clk,rst_n)
    begin
        if rst_n = '0' then
            contested_access <= '0';
        elsif rising_edge(clk) then
            contested_access <= '0';

            if mmi_iram.read = '1' and pending_push = '1' then
                report iram_report_prefix & "contested memory accesses to the iram" severity failure;
                contested_access <= '1';
            end if;

            -- sanity checks
            if mmi_iram.write = '1' then
                report iram_report_prefix & "mmi writes to the iram unsupported for non-levelling AFI PHY sequencer" severity failure;
            end if;
            if dgwb_iram.iram_write = '1' then
                report iram_report_prefix & "dgwb writes to the iram unsupported for non-levelling AFI PHY sequencer" severity failure;
            end if;
        end if;
    end process;

-- -------------------------------------------
-- mux push data and associated signals
-- note: single bit taken for iram_pushdata because 1-bit read-modify-write to
--       a 32-bit word in the ram. This interface style is maintained for future
--       scalability / wider application of the iram block.
-- -------------------------------------------

    process(clk,rst_n)
    begin

        if rst_n = '0' then

            iram_done     <= '0';
            iram_pushdata <= (others => '0');
            pending_push  <= '0';
            iram_wordnum  <= 0;
            iram_bitnum   <= 0;

        elsif rising_edge(clk) then

            case curr_active_block(ctrl_iram.command) is

                when dgrb =>
                    iram_done        <= dgrb_iram.iram_done;
                    iram_pushdata    <= dgrb_iram.iram_pushdata;
                    pending_push     <= dgrb_iram.iram_write;
                    iram_wordnum     <= dgrb_iram.iram_wordnum;
                    iram_bitnum      <= dgrb_iram.iram_bitnum;

                when others => -- default dgrb
                    iram_done        <= dgrb_iram.iram_done;
                    iram_pushdata    <= dgrb_iram.iram_pushdata;
                    pending_push     <= dgrb_iram.iram_write;
                    iram_wordnum     <= dgrb_iram.iram_wordnum;
                    iram_bitnum      <= dgrb_iram.iram_bitnum;

                end case;
        end if;

    end process;

-- -------------------------------------------
-- generate write signal for the ram
-- -------------------------------------------

    process(clk, rst_n)
    begin

        if rst_n = '0' then
            iram_write  <= '0';

        elsif rising_edge(clk) then

            case state is

            when s_idle =>
                iram_write <= '0';

            when s_pre_init_ram |
                 s_init_ram =>
                iram_write <= '1';

            when s_ihi_header_word0_wr |
                 s_ihi_header_word1_wr |
                 s_ihi_header_word2_wr |
                 s_ihi_header_word3_wr |
                 s_ihi_header_word4_wr |
                 s_ihi_header_word5_wr |
                 s_ihi_header_word6_wr |
                 s_ihi_header_word7_wr =>
                iram_write <= '1';

            when s_idib_header_write =>
                iram_write <= '1';

            when s_idib_footer_write =>
                iram_write <= '1';

            when s_cal_data_write =>
                iram_write <= '1';

            when others =>
                iram_write <= '0'; -- default

            end case;

        end if;

    end process;

-- -------------------------------------------
-- generate wdata for the ram
-- -------------------------------------------

    process(clk, rst_n)
    variable v_current_cs    : std_logic_vector(3 downto 0);
    variable v_mtp_alignment : std_logic_vector(0 downto 0);
    variable v_single_bit    : std_logic;

    begin

        if rst_n = '0' then
            iram_wdata  <= (others => '0');

        elsif rising_edge(clk) then

            case state is

                when s_pre_init_ram |
                     s_init_ram     =>
                    iram_wdata <= (others => '0');

                when s_ihi_header_word0_wr =>
                    iram_wdata <= ihi_self_description;

                when s_ihi_header_word1_wr =>
                    iram_wdata <= c_ihi_phys_if_desc;

                when s_ihi_header_word2_wr =>
                    iram_wdata <= c_ihi_timing_info;

                when s_ihi_header_word3_wr =>
                    iram_wdata                                                <= ( others => '0');
                    iram_wdata(admin_regs_status_rec.mr0'range)               <= admin_regs_status_rec.mr0;
                    iram_wdata(admin_regs_status_rec.mr1'high + 16 downto 16) <= admin_regs_status_rec.mr1;

                when s_ihi_header_word4_wr =>
                    iram_wdata                                                <= ( others => '0');
                    iram_wdata(admin_regs_status_rec.mr2'range)               <= admin_regs_status_rec.mr2;
                    iram_wdata(admin_regs_status_rec.mr3'high + 16 downto 16) <= admin_regs_status_rec.mr3;

                when s_ihi_header_word5_wr =>
                    iram_wdata <= c_ihi_ctrl_ss_word2;

                when s_ihi_header_word6_wr =>
                    iram_wdata <= std_logic_vector(to_unsigned(IRAM_AWIDTH,32)); -- tbd write the occupancy at end of cal

                when s_ihi_header_word7_wr =>
                    iram_wdata <= ihi_self_description_extra;

                when s_idib_header_write   =>

                    -- encode command_op for current operation
                    v_current_cs    := std_logic_vector(to_unsigned(ctrl_iram.command_op.current_cs, 4));
                    v_mtp_alignment := std_logic_vector(to_unsigned(ctrl_iram.command_op.mtp_almt, 1));
                    v_single_bit    := ctrl_iram.command_op.single_bit;

                    iram_wdata <= encode_current_stage(ctrl_iram.command) & -- which command being executed (currently this should only be cmd_rrp_sweep (8 bits)
                                                             v_current_cs & -- which chip select being processed (4 bits)
                                                          v_mtp_alignment & -- currently used MTP alignment (1 bit)
                                                             v_single_bit & -- is single bit calibration selected (1 bit) - used during MTP alignment
                                                                     "00" & -- RFU
                                                        idib_header_count & -- unique ID to how many headers have been written (8 bits)
                                                       c_idib_header_code0; -- unique ID for headers (8 bits)

                when s_idib_footer_write =>

                    iram_wdata <= c_idib_footer_code & c_idib_footer_code & c_idib_footer_code & c_idib_footer_code;

                when s_cal_data_modify     =>

                    -- default don't overwrite
                    iram_modified_data <= iram_rdata;

                    -- update iram data based on packing and write modes
                    if ctrl_iram_push.packing_mode = dq_bitwise then

                        case ctrl_iram_push.write_mode is
                            when overwrite_ram =>
                                iram_modified_data(iram_bitnum) <= iram_pushdata(0);
                            when or_into_ram =>
                                iram_modified_data(iram_bitnum) <= iram_pushdata(0) or iram_rdata(0);
                            when and_into_ram =>
                                iram_modified_data(iram_bitnum) <= iram_pushdata(0) and iram_rdata(0);
                            when others =>
                                report iram_report_prefix & "unidentified write mode of " & t_iram_write_mode'image(ctrl_iram_push.write_mode) &
                                       " specified when generating iram write data" severity failure;
                        end case;

                    elsif ctrl_iram_push.packing_mode = dq_wordwise then

                        case ctrl_iram_push.write_mode is
                            when overwrite_ram =>
                                iram_modified_data <= iram_pushdata;
                            when or_into_ram =>
                                iram_modified_data <= iram_pushdata or iram_rdata;
                            when and_into_ram =>
                                iram_modified_data <= iram_pushdata and iram_rdata;
                            when others =>
                                report iram_report_prefix & "unidentified write mode of " & t_iram_write_mode'image(ctrl_iram_push.write_mode) &
                                       " specified when generating iram write data" severity failure;
                        end case;
                    else
                        report iram_report_prefix & "unidentified packing mode of " & t_iram_packing_mode'image(ctrl_iram_push.packing_mode) &
                               " specified when generating iram write data" severity failure;
                    end if;


                when s_cal_data_write      =>
                    iram_wdata <= iram_modified_data;

                when others                =>
                    iram_wdata <= (others => '0');

            end case;

        end if;

    end process;

-- -------------------------------------------
-- generate addr for the ram
-- -------------------------------------------

    process(clk, rst_n)
    begin

       if rst_n = '0' then
          iram_addr          <= (others => '0');
          curr_iram_offset   <= 0;

       elsif rising_edge(clk) then

           case (state) is

               when s_idle    =>
                   if mmi_iram.read = '1' then  -- pre-set mmi read location address

                       iram_addr  <= ('0' & to_unsigned(mmi_iram.addr,IRAM_AWIDTH)); -- Pad MSB

                   else  -- default get next push data location from iram

                       iram_addr  <= to_unsigned(curr_iram_offset + iram_wordnum, IRAM_AWIDTH+1);

                   end if;

               when s_word_access_ram =>

                   -- calculate the address
                   if mmi_iram.read = '1' then  -- mmi access
                       iram_addr  <= ('0' & to_unsigned(mmi_iram.addr,IRAM_AWIDTH)); -- Pad MSB
                   end if;


               when s_ihi_header_word0_wr =>
                   iram_addr  <= (others => '0');

               -- increment address for IHI word writes :
               when s_ihi_header_word1_wr |
                    s_ihi_header_word2_wr |
                    s_ihi_header_word3_wr |
                    s_ihi_header_word4_wr |
                    s_ihi_header_word5_wr |
                    s_ihi_header_word6_wr |
                    s_ihi_header_word7_wr =>
                   iram_addr  <=  iram_addr + 1;

               when s_idib_header_write =>
                   iram_addr  <= '0' & to_unsigned(ctrl_idib_top, IRAM_AWIDTH); -- Always write header at idib_top location

               when s_idib_footer_write =>
                   iram_addr  <= to_unsigned(curr_iram_offset + iram_wordnum, IRAM_AWIDTH+1);  -- active block communicates where to put the footer with done signal

               when s_idib_header_inc_addr =>
                   iram_addr        <= iram_addr + 1;
                   curr_iram_offset <= to_integer('0' & iram_addr) + 1;

               when s_init_ram =>

                   if iram_addr(IRAM_AWIDTH) = '1' then
                       iram_addr  <= (others => '0');  -- this prevents erroneous out-of-mem flag after initialisation
                   else
                       iram_addr  <= iram_addr + 1;
                   end if;

               when others =>
                   iram_addr  <= iram_addr;

           end case;

       end if;

    end process;

-- -------------------------------------------
-- generate new cmd signal to register the command_req signal
-- -------------------------------------------

    process(clk, rst_n)
    begin

        if rst_n = '0' then
            new_cmd <= '0';

        elsif rising_edge(clk) then

            if ctrl_iram.command_req = '1' then

                case ctrl_iram.command is

                    when cmd_rrp_sweep |  -- only prompt new_cmd for commands we wish to write headers for
                         cmd_rrp_seek  |
                         cmd_read_mtp  |
                         cmd_write_ihi =>

                        new_cmd <= '1';

                    when others =>

                        new_cmd <= '0';

                end case;

            end if;

            if cmd_processed = '1' then
                new_cmd <= '0';
            end if;

        end if;
    end process;

-- -------------------------------------------
-- generate read valid signal which takes account of pipelining of reads
-- -------------------------------------------

    process(clk, rst_n)
    begin

        if rst_n = '0' then
            iram_rdata_valid <= '0';
            read_valid_ctr   <= 0;
            iram_addr_r      <= (others => '0');

        elsif rising_edge(clk) then

            if read_valid_ctr < c_iram_rlat then
                iram_rdata_valid <= '0';
                read_valid_ctr   <= read_valid_ctr + 1;
            else
                iram_rdata_valid <= '1';
            end if;

            if to_integer(iram_addr) /= to_integer(iram_addr_r) or
               iram_write = '1' then
                read_valid_ctr   <= 0;
                iram_rdata_valid <= '0';
            end if;

            -- register iram address
            iram_addr_r  <= iram_addr;

        end if;
    end process;


-- -------------------------------------------
-- state machine
-- -------------------------------------------

    process(clk, rst_n)
    begin

        if rst_n = '0' then
           state  <= s_reset;
           cmd_processed <= '0';

        elsif rising_edge(clk) then

            cmd_processed <= '0';

            case state is

                when s_reset =>
                    state <= s_pre_init_ram;

                when s_pre_init_ram =>
                    state <= s_init_ram;

                -- remain in the init_ram state until all the ram locations have been zero'ed
                when s_init_ram =>

                    if iram_addr(IRAM_AWIDTH) = '1' then
                        state <= s_idle;
                    end if;

                -- default state after reset
                when s_idle =>

                    if pending_push = '1' then

                        state <= s_cal_data_read;

                    elsif iram_done = '1' then

                        state <= s_idib_footer_write;

                    elsif new_cmd = '1' then

                        case ctrl_iram.command is

                            when cmd_rrp_sweep |
                                 cmd_rrp_seek  |
                                 cmd_read_mtp     => state <= s_idib_header_write;

                            when cmd_write_ihi    => state <= s_ihi_header_word0_wr;

                            when others           => state <= state;

                        end case;

                        cmd_processed <= '1';

                    elsif mmi_iram.read = '1' then

                        state <= s_word_access_ram;

                    end if;

                -- mmi read accesses
                when s_word_access_ram            => state <= s_word_fetch_ram_rdata;
                when s_word_fetch_ram_rdata       => state <= s_word_fetch_ram_rdata_r;

                when s_word_fetch_ram_rdata_r     => if iram_rdata_valid = '1' then
                                                         state <= s_word_complete;
                                                     end if;

                when s_word_complete              => if iram_rdata_valid = '1' then  -- return to idle when iram_rdata stable
                                                         state <= s_idle;
                                                     end if;

                -- header write (currently only for cmp_rrp stage)
                when s_idib_header_write          => state <= s_idib_header_inc_addr;
                when s_idib_header_inc_addr       => state <= s_idle;  -- return to idle to wait for push

                when s_idib_footer_write          => state <= s_word_complete;

                -- push data accesses (only used by the dgrb block at present)
                when s_cal_data_read              => state <= s_cal_data_read_r;

                when s_cal_data_read_r            => if iram_rdata_valid = '1' then
                                                         state <= s_cal_data_modify;
                                                     end if;

                when s_cal_data_modify            => state <= s_cal_data_write;
                when s_cal_data_write             => state <= s_word_complete;

                -- IHI Header write accesses
                when s_ihi_header_word0_wr        => state <= s_ihi_header_word1_wr;
                when s_ihi_header_word1_wr        => state <= s_ihi_header_word2_wr;
                when s_ihi_header_word2_wr        => state <= s_ihi_header_word3_wr;
                when s_ihi_header_word3_wr        => state <= s_ihi_header_word4_wr;
                when s_ihi_header_word4_wr        => state <= s_ihi_header_word5_wr;
                when s_ihi_header_word5_wr        => state <= s_ihi_header_word6_wr;
                when s_ihi_header_word6_wr        => state <= s_ihi_header_word7_wr;
                when s_ihi_header_word7_wr        => state <= s_idle;

                when others => state <= state;

            end case;

        end if;

    end process;

-- -------------------------------------------
-- drive read data and responses back.
-- -------------------------------------------

    process(clk, rst_n)
    begin

        if rst_n = '0' then
            iram_status           <= defaults;
            iram_push_done        <= '0';
            idib_header_count     <= (others => '0');
            fsm_read              <= '0';

        elsif rising_edge(clk) then

            -- defaults
            iram_status       <= defaults;
            iram_status.done  <= '0';
            iram_status.rdata <= (others => '0');
            iram_push_done    <= '0';


            if state = s_init_ram then
                iram_status.out_of_mem <= '0';
            else
                iram_status.out_of_mem <= iram_addr(IRAM_AWIDTH);
            end if;

            -- register read flag for 32 bit accesses
            if state = s_idle then

                fsm_read  <= mmi_iram.read;

            end if;

            if state = s_word_complete then

                iram_status.done  <= '1';

                if fsm_read = '1' then
                    iram_status.rdata <= iram_rdata;
                else
                    iram_status.rdata <= (others => '0');
                end if;

            end if;

            -- if another access is ever presented while the FSM is busy, set the contested flag
            if contested_access = '1' then
                iram_status.contested_access <= '1';
            end if;

            -- set (and keep set) the iram_init_done output once initialisation of the RAM is complete
            if (state /= s_init_ram) and (state /= s_pre_init_ram) and (state /= s_reset) then
                iram_status.init_done <= '1';
            end if;

            if state = s_ihi_header_word7_wr then
                iram_push_done <= '1';
            end if;

            -- if completing push or footer write then acknowledge
            if state = s_cal_data_modify or state = s_idib_footer_write then
                iram_push_done <= '1';
            end if;

            -- increment IDIB header count each time a header is written
            if state = s_idib_header_write then
                idib_header_count <=  std_logic_vector(unsigned(idib_header_count) + to_unsigned(1,idib_header_count'high +1));
            end if;

        end if;

    end process;

end architecture struct;
--

-- -----------------------------------------------------------------------------
--  Abstract        : data gatherer (read bias) [dgrb] block for the non-levelling
--                    AFI PHY sequencer
--                    This block handles all calibration commands which require
--                    memory read operations.
--
--            These include:
--                    Resync phase calibration - sweep of phases, calculation of
--                                             result and optional storage to iram
--                    Postamble calibration - clock cycle calibration of the postamble
--                                            enable signal
--                    Read data valid signal alignment
--                    Calculation of advertised read and write latencies
-- -----------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;


-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
    use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The address and command package (alt_mem_phy_addr_cmd_pkg) is used to combine DRAM address
-- and command signals in one record and unify the functions operating on this record.
--
   use work.ddr3_int_phy_alt_mem_phy_addr_cmd_pkg.all;

-- The iram address package (alt_mem_phy_iram_addr_pkg) is used to define the base addresses used
-- for iram writes during calibration
--
    use work.ddr3_int_phy_alt_mem_phy_iram_addr_pkg.all;

-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
    use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;

--
entity ddr3_int_phy_alt_mem_phy_dgrb is
    generic (
        MEM_IF_DQS_WIDTH               : natural;
        MEM_IF_DQ_PER_DQS              : natural;
        MEM_IF_DWIDTH                  : natural;
        MEM_IF_DM_WIDTH                : natural;
        MEM_IF_DQS_CAPTURE             : natural;
        MEM_IF_ADDR_WIDTH              : natural;
        MEM_IF_BANKADDR_WIDTH          : natural;
        MEM_IF_NUM_RANKS               : natural;
        MEM_IF_MEMTYPE                 : string;

        ADV_LAT_WIDTH                  : natural;

        CLOCK_INDEX_WIDTH              : natural;

        DWIDTH_RATIO                   : natural;
        PRESET_RLAT                    : natural;

        PLL_STEPS_PER_CYCLE            : natural; -- number of PLL phase steps per PHY clock cycle

        SIM_TIME_REDUCTIONS            : natural;
        GENERATE_ADDITIONAL_DBG_RTL    : natural;

        PRESET_CODVW_PHASE             : natural;
        PRESET_CODVW_SIZE              : natural;

        -- base column address to which calibration data is written
        -- memory at MEM_IF_CAL_BASE_COL - MEM_IF_CAL_BASE_COL + C_CAL_DATA_LEN - 1
        -- is assumed to contain the proper data
        MEM_IF_CAL_BANK                : natural; -- bank to which calibration data is written
        MEM_IF_CAL_BASE_COL            : natural;
        EN_OCT                         : natural
    );
    port (
        -- clk / reset
        clk                            : in    std_logic;
        rst_n                          : in    std_logic;

        -- control interface
        dgrb_ctrl                      : out   t_ctrl_stat;
        ctrl_dgrb                      : in    t_ctrl_command;
        parameterisation_rec           : in    t_algm_paramaterisation;

        -- PLL reconfig interface
        phs_shft_busy                  : in    std_logic;
        seq_pll_inc_dec_n              : out   std_logic;
        seq_pll_select                 : out   std_logic_vector(CLOCK_INDEX_WIDTH - 1 DOWNTO 0);
        seq_pll_start_reconfig         : out   std_logic;
        pll_resync_clk_index           : in    std_logic_vector(CLOCK_INDEX_WIDTH - 1 downto 0); -- PLL phase used to select resync clock
        pll_measure_clk_index          : in    std_logic_vector(CLOCK_INDEX_WIDTH - 1 downto 0); -- PLL phase used to select mimic / aka measure clock

        -- iram 'push' interface
        dgrb_iram                      : out   t_iram_push;
        iram_push_done                 : in    std_logic;

        -- addr/cmd output for write commands
        dgrb_ac                        : out t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);

        -- admin block req/gnt interface
        dgrb_ac_access_req             : out   std_logic;
        dgrb_ac_access_gnt             : in    std_logic;

        -- RDV latency controls
        seq_rdata_valid_lat_inc        : out   std_logic;
        seq_rdata_valid_lat_dec        : out   std_logic;

        -- POA latency controls
        seq_poa_lat_dec_1x             : out   std_logic_vector(MEM_IF_DQS_WIDTH - 1 downto 0);
        seq_poa_lat_inc_1x             : out   std_logic_vector(MEM_IF_DQS_WIDTH - 1 downto 0);

        -- read datapath interface
        rdata_valid                    : in    std_logic_vector(DWIDTH_RATIO/2 - 1 downto 0);
        rdata                          : in    std_logic_vector(DWIDTH_RATIO * MEM_IF_DWIDTH - 1 downto 0);
        doing_rd                       : out   std_logic_vector(MEM_IF_DQS_WIDTH * DWIDTH_RATIO/2 - 1 downto 0);
        rd_lat                         : out   std_logic_vector(ADV_LAT_WIDTH - 1 downto 0);

        -- advertised write latency
        wd_lat                         : out   std_logic_vector(ADV_LAT_WIDTH - 1 downto 0);

        -- OCT control
        seq_oct_value                  : out   std_logic;
        dgrb_wdp_ovride                : out   std_logic;

        -- mimic path interface
        seq_mmc_start                  : out   std_logic;
        mmc_seq_done                   : in    std_logic;
        mmc_seq_value                  : in    std_logic;

        -- calibration byte lane select (reserved for future use - RFU)
        ctl_cal_byte_lanes             : in    std_logic_vector(MEM_IF_NUM_RANKS * MEM_IF_DQS_WIDTH  - 1 downto 0);

        -- odt settings per chip select
        odt_settings                   : in    t_odt_array(0 to MEM_IF_NUM_RANKS-1);

        -- signal to identify if a/c nt setting is correct (set after wr_lat calculation)
        -- NOTE: labelled nt for future scalability to quarter rate interfaces
        dgrb_ctrl_ac_nt_good           : out   std_logic;

        -- status signals on calibrated cdvw
        dgrb_mmi                       : out   t_dgrb_mmi
    );

end entity;

--
architecture struct of ddr3_int_phy_alt_mem_phy_dgrb is

-- ------------------------------------------------------------------
--  constant declarations
-- ------------------------------------------------------------------

    constant c_seq_addr_cmd_config      : t_addr_cmd_config_rec := set_config_rec(MEM_IF_ADDR_WIDTH, MEM_IF_BANKADDR_WIDTH, MEM_IF_NUM_RANKS, DWIDTH_RATIO, MEM_IF_MEMTYPE);

    -- command/result length
    constant c_command_result_len       : natural := 8;

    -- burst characteristics and latency characteristics
    constant c_max_read_lat             : natural := 2**rd_lat'length - 1;  -- maximum read latency in phy clock-cycles

    -- training pattern characteristics
    constant c_cal_mtp_len              : natural := 16;
    constant c_cal_mtp                  : std_logic_vector(c_cal_mtp_len - 1 downto 0) := x"30F5";
    constant c_cal_mtp_t                : natural := c_cal_mtp_len / DWIDTH_RATIO; -- number of phy-clk cycles required to read BTP

    -- read/write latency defaults
    constant c_default_rd_lat_slv       : std_logic_vector(ADV_LAT_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(c_default_rd_lat, ADV_LAT_WIDTH));
    constant c_default_wd_lat_slv       : std_logic_vector(ADV_LAT_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(c_default_wr_lat, ADV_LAT_WIDTH));

    -- tracking reporting parameters
    constant c_max_rsc_drift_in_phases    : natural := 127;  -- this must be a value of < 2^10 - 1 because of the range of signal codvw_trk_shift


    -- Returns '1' when boolean b is True; '0' otherwise.
    function active_high(b : in boolean) return std_logic is
        variable r : std_logic;
    begin
        if b then
            r := '1';
        else
            r := '0';
        end if;

        return r;
    end function;

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant dgrb_report_prefix        : string  := "ddr3_int_phy_alt_mem_phy_seq (dgrb) : ";

    -- Return the number of clock periods the resync clock should sweep.
    --
    -- On half-rate systems and in DQS-capture based systems a 720
    -- to guarantee the resync window can be properly observed.
    function rsc_sweep_clk_periods return natural is
        variable v_num_periods : natural;
    begin
        if DWIDTH_RATIO = 2 then
            if MEM_IF_DQS_CAPTURE = 1 then  -- families which use DQS capture require a 720 degree sweep for FR to show a window
                v_num_periods := 2;
            else
                v_num_periods := 1;
            end if;
        elsif DWIDTH_RATIO = 4 then
            v_num_periods := 2;
        else
            report dgrb_report_prefix & "unsupported DWIDTH_RATIO." severity failure;
        end if;

        return v_num_periods;
    end function;


    -- window for PLL sweep
    constant c_max_phase_shifts        : natural := rsc_sweep_clk_periods*PLL_STEPS_PER_CYCLE;

    constant c_pll_phs_inc              : std_logic := '1';
    constant c_pll_phs_dec              : std_logic := not c_pll_phs_inc;

-- ------------------------------------------------------------------
--  type declarations
-- ------------------------------------------------------------------

    -- dgrb main state machine
    type t_dgrb_state is (
        -- idle state
        s_idle,
        -- request access to memory address/command bus from the admin block
        s_wait_admin,
        -- relinquish address/command bus access
        s_release_admin,
        -- wind back resync phase to a 'zero' point
        s_reset_cdvw,
        -- perform resync phase sweep (used for MTP alignment checking and actual RRP sweep)
        s_test_phases,
        -- processing to when checking MTP alignment
        s_read_mtp,
        -- processing for RRP (read resync phase) sweep
        s_seek_cdvw,
        -- clock cycle alignment of read data valid signal
        s_rdata_valid_align,
        -- calculate advertised read latency
        s_adv_rd_lat_setup,
        s_adv_rd_lat,
        -- calculate advertised write latency
        s_adv_wd_lat,
        -- postamble clock cycle calibration
        s_poa_cal,
        -- tracking - setup and periodic update
        s_track
    );

    -- dgrb slave state machine for addr/cmd signals
    type t_ac_state is (
        -- idle state
        s_ac_idle,
        -- wait X cycles (issuing NOP command) to flush address/command and DQ buses
        s_ac_relax,
        -- read MTP pattern
        s_ac_read_mtp,
        -- read pattern for read data valid alignment
        s_ac_read_rdv,
        -- read pattern for POA calibration
        s_ac_read_poa_mtp,
        -- read pattern to calculate advertised write latency
        s_ac_read_wd_lat
    );

    -- dgrb slave state machine for read resync phase calibration
    type t_resync_state is (
        -- idle state
        s_rsc_idle,
        -- shift resync phase by one
        s_rsc_next_phase,
        -- start test sequence for current pin and current phase
        s_rsc_test_phase,
        -- flush the read datapath
        s_rsc_wait_for_idle_dimm,  -- wait until no longer driving
        s_rsc_flush_datapath,      -- flush a/c path
        -- sample DQ data to test phase
        s_rsc_test_dq,
        -- reset rsc phase to a zero position
        s_rsc_reset_cdvw,
        s_rsc_rewind_phase,
        -- calculate the centre of resync window
        s_rsc_cdvw_calc,
        s_rsc_cdvw_wait,  -- wait for calc result
        -- set rsc clock phase to centre of data valid window
        s_rsc_seek_cdvw,
        -- wait until all results written to iram
        s_rsc_wait_iram  -- only entered if GENERATE_ADDITIONAL_DBG_RTL = 1
    );

    -- record definitions for window processing
    type t_win_processing_status is ( calculating,
                                      valid_result,
                                      no_invalid_phases,
                                      multiple_equal_windows,
                                      no_valid_phases
                                    );

    type t_window_processing is record
        working_window        : std_logic_vector(  c_max_phase_shifts - 1 downto 0);
        first_good_edge       : natural range 0 to c_max_phase_shifts - 1;             -- pointer to first detected good edge
        current_window_start  : natural range 0 to c_max_phase_shifts - 1;
        current_window_size   : natural range 0 to c_max_phase_shifts - 1;
        current_window_centre : natural range 0 to c_max_phase_shifts - 1;
        largest_window_start  : natural range 0 to c_max_phase_shifts - 1;
        largest_window_size   : natural range 0 to c_max_phase_shifts - 1;
        largest_window_centre : natural range 0 to c_max_phase_shifts - 1;
        current_bit           : natural range 0 to c_max_phase_shifts - 1;
        window_centre_update  : std_logic;
        last_bit_value        : std_logic;
        valid_phase_seen      : boolean;
        invalid_phase_seen    : boolean;
        first_cycle           : boolean;
        multiple_eq_windows   : boolean;
        found_a_good_edge     : boolean;
        status                : t_win_processing_status;
        windows_seen          : natural range 0 to c_max_phase_shifts/2 - 1;
    end record;

-- ------------------------------------------------------------------
--  function and procedure definitions
-- ------------------------------------------------------------------

    -- Returns a string representation of a std_logic_vector.
    -- Not synthesizable.
    function str(v: std_logic_vector) return string is
        variable str_value : string (1 to v'length);
        variable str_len   : integer;
        variable c         : character;
    begin
        str_len := 1;
        for i in v'range loop
            case v(i) is
                when '0'    => c := '0';
                when '1'    => c := '1';
                when others => c := '?';
            end case;

            str_value(str_len) := c;
            str_len            := str_len + 1;
        end loop;
        return str_value;
    end str;


    --  functions and procedures for window processing

    function defaults return t_window_processing is
        variable output : t_window_processing;
    begin
        output.working_window        := (others => '1');
        output.last_bit_value        := '1';
        output.first_good_edge       := 0;
        output.current_window_start  := 0;
        output.current_window_size   := 0;
        output.current_window_centre := 0;
        output.largest_window_start  := 0;
        output.largest_window_size   := 0;
        output.largest_window_centre := 0;
        output.window_centre_update  := '1';
        output.current_bit           := 0;
        output.multiple_eq_windows   := false;
        output.valid_phase_seen      := false;
        output.invalid_phase_seen    := false;
        output.found_a_good_edge     := false;
        output.status                := no_valid_phases;
        output.first_cycle           := false;
        output.windows_seen          := 0;
        return output;
    end function defaults;


    procedure initialise_window_for_proc ( working : inout t_window_processing ) is
        variable v_working_window : std_logic_vector(  c_max_phase_shifts - 1 downto 0);
    begin
        v_working_window             := working.working_window;
        working                      := defaults;
        working.working_window       := v_working_window;
        working.status               := calculating;
        working.first_cycle          := true;
        working.window_centre_update := '1';
        working.windows_seen         := 0;
    end procedure initialise_window_for_proc;


    procedure shift_window (working    : inout t_window_processing;
                            num_phases : in    natural range 1 to c_max_phase_shifts
                           )
    is
    begin
        if working.working_window(0) = '0' then
            working.invalid_phase_seen   := true;
        else
            working.valid_phase_seen     := true;
        end if;

        -- general bit serial shifting of window and incrementing of current bit counter.
        if working.current_bit < num_phases - 1 then
            working.current_bit := working.current_bit + 1;
        else
            working.current_bit := 0;
        end if;

        working.last_bit_value  := working.working_window(0);
        working.working_window  := working.working_window(0) & working.working_window(working.working_window'high downto 1);

        --synopsis translate_off
        -- for simulation to make it simpler to see IF we are not using all the bits in the window
        working.working_window(working.working_window'high) := 'H';  -- for visual debug
        --synopsis translate_on
        working.working_window(num_phases -1) := working.last_bit_value;

        working.first_cycle    := false;
    end procedure shift_window;


    procedure find_centre_of_largest_data_valid_window
                             ( working    : inout t_window_processing;
                               num_phases : in    natural range 1 to c_max_phase_shifts
                              ) is
    begin
        if working.first_cycle = false then  -- not first call to procedure, then handle end conditions
            if working.current_bit = 0 and working.found_a_good_edge = false then  -- have been all way arround window  (circular)
                if working.valid_phase_seen = false then
                    working.status := no_valid_phases;
                elsif working.invalid_phase_seen = false then
                      working.status := no_invalid_phases;
                end if;
            elsif working.current_bit = working.first_good_edge then  -- if have found a good edge then complete a circular sweep to that edge
                if working.multiple_eq_windows = true then
                    working.status := multiple_equal_windows;
                else
                    working.status := valid_result;
                end if;
            end if;
        end if;

        -- start of a window condition
        if working.last_bit_value = '0' and working.working_window(0) = '1' then
            working.current_window_start  := working.current_bit;
            working.current_window_size   := working.current_window_size + 1;   -- equivalent to assigning to one because if not in a window then it is set to 0
            working.window_centre_update  := not working.window_centre_update;
            working.current_window_centre := working.current_bit;

            if working.found_a_good_edge /= true then                          -- if have not yet found a good edge then store this value
                working.first_good_edge   := working.current_bit;
                working.found_a_good_edge := true;
            end if;

        -- end of window conditions
        elsif working.last_bit_value = '1' and working.working_window(0) = '0' then

            if working.current_window_size > working.largest_window_size then

                working.largest_window_size   := working.current_window_size;
                working.largest_window_start  := working.current_window_start;
                working.largest_window_centre := working.current_window_centre;
                working.multiple_eq_windows   := false;

            elsif working.current_window_size = working.largest_window_size then

                working.multiple_eq_windows   := true;

            end if;

            -- put counter in here because start of window 1 is observed twice
            if working.found_a_good_edge = true then
                working.windows_seen := working.windows_seen + 1;
            end if;

            working.current_window_size  := 0;

        elsif working.last_bit_value = '1' and working.working_window(0) = '1' and (working.found_a_good_edge = true) then  --note operand in brackets is excessive but for may provide power savings and makes visual inspection of simulatuion easier

            if working.window_centre_update = '1' then
                if working.current_window_centre < num_phases -1 then
                    working.current_window_centre := working.current_window_centre + 1;
                else
                    working.current_window_centre := 0;
                end if;
            end if;

            working.window_centre_update := not working.window_centre_update;

            working.current_window_size  := working.current_window_size + 1;
        end if;

        shift_window(working,num_phases);
    end procedure find_centre_of_largest_data_valid_window;


    procedure find_last_failing_phase
                             ( working    : inout t_window_processing;
                               num_phases : in    natural range 1 to c_max_phase_shifts + 1
                              ) is
    begin
        if working.first_cycle = false then  -- not first call to procedure
            if working.current_bit = 0 then --     and working.found_a_good_edge = false then
                if working.valid_phase_seen = false then
                    working.status := no_valid_phases;
                elsif working.invalid_phase_seen = false then
                    working.status := no_invalid_phases;
                else
                    working.status := valid_result;
                end if;
            end if;
        end if;

        if working.working_window(1) = '1' and working.working_window(0) = '0' and working.status = calculating then
            working.current_window_start := working.current_bit;
        end if;

        shift_window(working, num_phases);  -- shifts window and sets first_cycle = false
    end procedure find_last_failing_phase;


    procedure find_first_passing_phase
                             ( working    : inout t_window_processing;
                               num_phases : in    natural range 1 to c_max_phase_shifts
                              ) is
    begin
        if working.first_cycle = false then  -- not first call to procedure
            if working.current_bit = 0 then --     and working.found_a_good_edge = false then
                if working.valid_phase_seen = false then
                    working.status := no_valid_phases;
                elsif working.invalid_phase_seen = false then
                    working.status := no_invalid_phases;
                else
                    working.status := valid_result;
                end if;
            end if;
        end if;

        if working.working_window(0) = '1' and working.last_bit_value = '0' and working.status = calculating then
            working.current_window_start := working.current_bit;
        end if;

        shift_window(working, num_phases);  -- shifts window and sets first_cycle = false
    end procedure find_first_passing_phase;


    -- shift in current pass/fail result to the working window
    procedure shift_in(
                    working    : inout t_window_processing;
                    status     : in    std_logic;
                    num_phases : in    natural range 1 to c_max_phase_shifts
                ) is
    begin
        working.last_bit_value                        := working.working_window(0);
        working.working_window(num_phases-1 downto 0) := (working.working_window(0) and status) & working.working_window(num_phases-1 downto 1);
    end procedure;

    -- The following function sets the width over which
    -- write latency should be repeated on the dq bus
    -- the default value is MEM_IF_DQ_PER_DQS
    function set_wlat_dq_rep_width return natural is
    begin
        for i in 1 to MEM_IF_DWIDTH/MEM_IF_DQ_PER_DQS loop
            if (i*MEM_IF_DQ_PER_DQS) >= ADV_LAT_WIDTH then
                return i*MEM_IF_DQ_PER_DQS;
            end if;
        end loop;
        report dgrb_report_prefix & "the specified maximum write latency cannot be fully represented in the given number of DQ pins" & LF &
                                    "** NOTE: This may cause overflow when setting ctl_wlat signal" severity warning;
        return MEM_IF_DQ_PER_DQS;
    end function;

    -- extract PHY 'addr/cmd' to 'wdata_valid' write latency from current read data
    function wd_lat_from_rdata(signal rdata : in std_logic_vector(DWIDTH_RATIO * MEM_IF_DWIDTH - 1 downto 0))
            return std_logic_vector is
        variable v_wd_lat : std_logic_vector(ADV_LAT_WIDTH - 1 downto 0);
    begin
        v_wd_lat := (others => '0');

        if set_wlat_dq_rep_width >= ADV_LAT_WIDTH then
            v_wd_lat := rdata(v_wd_lat'high downto 0);
        else
            v_wd_lat                                   := (others => '0');
            v_wd_lat(set_wlat_dq_rep_width - 1 downto 0) := rdata(set_wlat_dq_rep_width - 1 downto 0);
        end if;

        return v_wd_lat;
    end function;

    -- check if rdata_valid is correctly aligned
    function rdata_valid_aligned(
                signal rdata       : in std_logic_vector(DWIDTH_RATIO * MEM_IF_DWIDTH - 1 downto 0);
                signal rdata_valid : in std_logic_vector(DWIDTH_RATIO/2 - 1 downto 0)
            ) return std_logic is

        variable v_dq_rdata    : std_logic_vector(DWIDTH_RATIO - 1 downto 0);
        variable v_aligned     : std_logic;
    begin
        -- Look at data from a single DQ pin 0 (DWIDTH_RATIO data bits)
        for i in 0 to DWIDTH_RATIO - 1 loop
            v_dq_rdata(i) := rdata(i*MEM_IF_DWIDTH);
        end loop;

        -- Check each alignment (necessary because in the HR case rdata can be in any alignment)
        v_aligned := '0';
        for i in 0 to DWIDTH_RATIO/2 - 1 loop
            if rdata_valid(i) = '1' then
                if v_dq_rdata(2*i + 1 downto 2*i) = "00" then
                    v_aligned := '1';
                end if;
            end if;
        end loop;

        return v_aligned;
    end function;


    -- set severity level for calibration failures
    function set_cal_fail_sev_level (
        generate_additional_debug_rtl : natural
        ) return severity_level is
    begin
        if generate_additional_debug_rtl = 1 then
            return warning;
        else
            return failure;
        end if;
    end function;

    constant cal_fail_sev_level : severity_level := set_cal_fail_sev_level(GENERATE_ADDITIONAL_DBG_RTL);

-- ------------------------------------------------------------------
--  signal declarations
-- rsc = resync - the mechanism of capturing DQ pin data onto a local clock domain
-- trk = tracking - a mechanism to track rsc clock phase with PVT variations
-- poa = postamble - protection circuitry from postamble glitched on DQS
-- ac  = memory address / command signals
-- ------------------------------------------------------------------

    -- main state machine
    signal sig_dgrb_state             : t_dgrb_state;
    signal sig_dgrb_last_state        : t_dgrb_state;

    signal sig_rsc_req                : t_resync_state; -- tells resync block which state to transition to.

    -- centre of data-valid window process
    signal sig_cdvw_state             : t_window_processing;

    -- control signals for the address/command process
    signal sig_addr_cmd               : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);
    signal sig_ac_req                 : t_ac_state;
    signal sig_dimm_driving_dq        : std_logic;
    signal sig_doing_rd               : std_logic_vector(MEM_IF_DQS_WIDTH * DWIDTH_RATIO/2 - 1 downto 0);
    signal sig_ac_even                : std_logic; -- odd/even count of PHY clock cycles.
        --
        --  sig_ac_even behaviour
        --
        --  sig_ac_even is always '1' on the cycle a command is issued.  It will
        -- be '1' on even clock cycles thereafter and '0' otherwise.
        --
        --                    ;         ;         ;         ;         ;         ;
        --                    ; _______ ;         ;         ;         ;         ;
        --               XXXXX /       \ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        --      addr/cmd XXXXXX   CMD   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        --               XXXXX \_______/ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        --                    ;         ;         ;         ;         ;         ;
        --                    ;         ;         ;         ;         ;         ;
        --                     _________           _________           _________
        --   sig_ac_even  ____|         |_________|         |_________|         |__________
        --                    ;         ;         ;         ;         ;         ;
        --                    ;         ;         ;         ;         ;         ;
        --   phy clk
        --    count               (0)       (1)       (2)       (3)       (4)
        --
        --

    -- resync related signals
    signal sig_rsc_ack                : std_logic;
    signal sig_rsc_err                : std_logic;
    signal sig_rsc_result             : std_logic_vector(c_command_result_len - 1 downto 0 );

    signal sig_rsc_cdvw_phase         : std_logic;
    signal sig_rsc_cdvw_shift_in      : std_logic;
    signal sig_rsc_cdvw_calc          : std_logic;

    signal sig_rsc_pll_start_reconfig : std_logic;
    signal sig_rsc_pll_inc_dec_n      : std_logic;

    signal sig_rsc_ac_access_req      : std_logic; -- High when the resync block requires a training pattern to be read.

    -- tracking related signals
    signal sig_trk_ack                : std_logic;
    signal sig_trk_err                : std_logic;
    signal sig_trk_result             : std_logic_vector(c_command_result_len - 1 downto 0 );

    signal sig_trk_cdvw_phase         : std_logic;
    signal sig_trk_cdvw_shift_in      : std_logic;
    signal sig_trk_cdvw_calc          : std_logic;

    signal sig_trk_pll_start_reconfig : std_logic;
    signal sig_trk_pll_select         : std_logic_vector(CLOCK_INDEX_WIDTH - 1 DOWNTO 0);
    signal sig_trk_pll_inc_dec_n      : std_logic;

    signal sig_trk_rsc_drift          : integer range -c_max_rsc_drift_in_phases to c_max_rsc_drift_in_phases;  -- stores total change in rsc phase from first calibration

    -- phs_shft_busy could (potentially) be asynchronous
    -- triple register it for metastability hardening
    -- these signals are the taps on the shift register
    signal sig_phs_shft_busy          : std_logic;
    signal sig_phs_shft_busy_1t       : std_logic;
    signal sig_phs_shft_start         : std_logic;
    signal sig_phs_shft_end           : std_logic;

    -- locally register crl_dgrb to minimise fan out
    signal ctrl_dgrb_r                : t_ctrl_command;

    -- command_op signals
    signal current_cs                 : natural range 0 to MEM_IF_NUM_RANKS - 1;
    signal current_mtp_almt           : natural range 0 to 1;
    signal single_bit_cal             : std_logic;

    -- codvw status signals (packed into record and sent to mmi block)
    signal cal_codvw_phase            : std_logic_vector(7 downto 0);
    signal codvw_trk_shift            : std_logic_vector(11 downto 0);
    signal cal_codvw_size             : std_logic_vector(7 downto 0);

    -- error signal and result from main state machine (operations other than rsc or tracking)
    signal sig_cmd_err                : std_logic;
    signal sig_cmd_result             : std_logic_vector(c_command_result_len - 1 downto 0 );


    -- signals that the training pattern matched correctly on the last clock
    -- cycle.
    signal sig_dq_pin_ctr             : natural range 0 to MEM_IF_DWIDTH - 1;
    signal sig_mtp_match              : std_logic;

    -- controls postamble match and timing.
    signal sig_poa_match_en           : std_logic;
    signal sig_poa_match              : std_logic;

    -- postamble signals
    signal sig_poa_ack                : std_logic;  -- '1' for postamble block to acknowledge.

    -- calibration byte lane select
    signal cal_byte_lanes             : std_logic_vector(MEM_IF_DQS_WIDTH  - 1 downto 0);

    signal codvw_grt_one_dvw          : std_logic;

begin


    doing_rd  <= sig_doing_rd;

    -- pack record of codvw status signals
    dgrb_mmi.cal_codvw_phase   <= cal_codvw_phase;
    dgrb_mmi.codvw_trk_shift   <= codvw_trk_shift;
    dgrb_mmi.cal_codvw_size    <= cal_codvw_size;
    dgrb_mmi.codvw_grt_one_dvw <= codvw_grt_one_dvw;

    -- map some internal signals to outputs
    dgrb_ac <= sig_addr_cmd;

    -- locally register crl_dgrb to minimise fan out
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            ctrl_dgrb_r <= defaults;
        elsif rising_edge(clk) then
            ctrl_dgrb_r <= ctrl_dgrb;
        end if;
    end process;

    -- generate the current_cs signal to track which cs accessed by PHY at any instance
    current_cs_proc : process (clk, rst_n)
    begin
        if rst_n = '0' then
            current_cs       <= 0;
            current_mtp_almt <= 0;
            single_bit_cal   <= '0';

            cal_byte_lanes   <= (others => '0');

        elsif rising_edge(clk) then
            if ctrl_dgrb_r.command_req = '1' then
                current_cs       <= ctrl_dgrb_r.command_op.current_cs;
                current_mtp_almt <= ctrl_dgrb_r.command_op.mtp_almt;
                single_bit_cal   <= ctrl_dgrb_r.command_op.single_bit;
            end if;

            -- mux byte lane select for given chip select
            for i in 0 to MEM_IF_DQS_WIDTH - 1 loop
                cal_byte_lanes(i) <= ctl_cal_byte_lanes((current_cs * MEM_IF_DQS_WIDTH) + i);
            end loop;

            assert ctl_cal_byte_lanes(0) = '1' report dgrb_report_prefix & " Byte lane 0 (chip select 0) disable is not supported - ending simulation" severity failure;
        end if;
    end process;


    -- ------------------------------------------------------------------
    -- main state machine for dgrb architecture
    --
    -- process of commands from control (ctrl) block and overall control of
    -- the subsequent calibration processing functions
    -- also communicates completion and any errors back to the ctrl block
    -- read data valid alignment and advertised latency calculations are
    -- included in this block
    -- ------------------------------------------------------------------

    dgrb_main_block : block
        signal sig_count    : natural range 0 to 2**8 - 1;
        signal sig_wd_lat   : std_logic_vector(ADV_LAT_WIDTH - 1 downto 0);
    begin
        dgrb_state_proc : process(rst_n, clk)
        begin
            if rst_n = '0' then
                -- initialise state
                sig_dgrb_state          <= s_idle;
                sig_dgrb_last_state     <= s_idle;

                sig_ac_req              <= s_ac_idle;
                sig_rsc_req             <= s_rsc_idle;

                -- set up rd_lat defaults
                rd_lat                  <= c_default_rd_lat_slv;
                wd_lat                  <= c_default_wd_lat_slv;

                -- set up rdata_valid latency control defaults
                seq_rdata_valid_lat_inc <= '0';
                seq_rdata_valid_lat_dec <= '0';

                -- reset counter
                sig_count               <= 0;

                -- error signals
                sig_cmd_err             <= '0';
                sig_cmd_result          <= (others => '0');

                -- sig_wd_lat
                sig_wd_lat              <= (others => '0');

                -- status of the ac_nt alignment
                dgrb_ctrl_ac_nt_good    <= '1';

            elsif rising_edge(clk) then
                sig_dgrb_last_state     <= sig_dgrb_state;
                sig_rsc_req             <= s_rsc_idle;

                -- set up rdata_valid latency control defaults
                seq_rdata_valid_lat_inc <= '0';
                seq_rdata_valid_lat_dec <= '0';

                -- error signals
                sig_cmd_err             <= '0';
                sig_cmd_result          <= (others => '0');

                -- register wd_lat output.
                wd_lat                  <= sig_wd_lat;

                case sig_dgrb_state is
                    when s_idle =>
                        sig_count <= 0;

                        if ctrl_dgrb_r.command_req = '1' then
                            if curr_active_block(ctrl_dgrb_r.command) = dgrb then
                                sig_dgrb_state <= s_wait_admin;
                            end if;
                        end if;

                        sig_ac_req <= s_ac_idle;


                    when s_wait_admin =>
                        sig_dgrb_state <= s_wait_admin;

                        case ctrl_dgrb_r.command is

                            when cmd_read_mtp        => sig_dgrb_state <= s_read_mtp;
                            when cmd_rrp_reset       => sig_dgrb_state <= s_reset_cdvw;
                            when cmd_rrp_sweep       => sig_dgrb_state <= s_test_phases;
                            when cmd_rrp_seek        => sig_dgrb_state <= s_seek_cdvw;
                            when cmd_rdv             => sig_dgrb_state <= s_rdata_valid_align;
                            when cmd_prep_adv_rd_lat => sig_dgrb_state <= s_adv_rd_lat_setup;
                            when cmd_prep_adv_wr_lat => sig_dgrb_state <= s_adv_wd_lat;
                            when cmd_tr_due          => sig_dgrb_state <= s_track;
                            when cmd_poa             => sig_dgrb_state <= s_poa_cal;

                            when others              =>
                                report dgrb_report_prefix & "unknown command" severity failure;
                                sig_dgrb_state <= s_idle;
                        end case;


                    when s_reset_cdvw =>
                        -- the cdvw proc watches for this state and resets the cdvw
                        -- state block.
                        if sig_rsc_ack = '1' then
                            sig_dgrb_state <= s_release_admin;
                        else
                            sig_rsc_req <= s_rsc_reset_cdvw;
                        end if;


                    when s_test_phases =>
                        if sig_rsc_ack = '1' then
                            sig_dgrb_state <= s_release_admin;
                        else
                            sig_rsc_req <= s_rsc_test_phase;
                            if sig_rsc_ac_access_req = '1' then
                                sig_ac_req <= s_ac_read_mtp;
                            else
                                sig_ac_req <= s_ac_idle;
                            end if;
                        end if;


                    when s_seek_cdvw | s_read_mtp =>
                        if sig_rsc_ack = '1' then
                            sig_dgrb_state <= s_release_admin;
                        else
                            sig_rsc_req <= s_rsc_cdvw_calc;
                        end if;


                    when s_release_admin =>
                        sig_ac_req     <= s_ac_idle;

                        if dgrb_ac_access_gnt = '0' and sig_dimm_driving_dq = '0' then
                            sig_dgrb_state <= s_idle;
                        end if;


                    when s_rdata_valid_align =>
                        sig_ac_req <= s_ac_read_rdv;

                        seq_rdata_valid_lat_dec <= '0';
                        seq_rdata_valid_lat_inc <= '0';

                        if sig_dimm_driving_dq = '1' then
                            -- only do comparison if rdata_valid is all 'ones'
                            if rdata_valid /= std_logic_vector(to_unsigned(0, DWIDTH_RATIO/2)) then
                                -- rdata_valid is all ones
                                if rdata_valid_aligned(rdata, rdata_valid) = '1' then
                                    -- success: rdata_valid and rdata are properly aligned
                                    sig_dgrb_state <= s_release_admin;
                                else
                                    -- misaligned: bring in rdata_valid by a clock cycle
                                    seq_rdata_valid_lat_dec <= '1';
                                end if;
                            end if;
                        end if;


                    when s_adv_rd_lat_setup =>
                        -- wait for sig_doing_rd to go high
                        sig_ac_req <= s_ac_read_rdv;

                        if sig_dgrb_state /= sig_dgrb_last_state then
                            rd_lat    <= (others => '0');
                            sig_count <= 0;
                        elsif sig_dimm_driving_dq = '1' and sig_doing_rd(MEM_IF_DQS_WIDTH*(DWIDTH_RATIO/2-1)) = '1' then
                            -- a read has started: start counter
                            sig_dgrb_state <= s_adv_rd_lat;
                        end if;


                    when s_adv_rd_lat =>
                        sig_ac_req <= s_ac_read_rdv;

                        if sig_dimm_driving_dq = '1' then
                            if sig_count >= 2**rd_lat'length then
                                report dgrb_report_prefix & "maximum read latency exceeded while waiting for rdata_valid" severity cal_fail_sev_level;
                                sig_cmd_err             <= '1';
                                sig_cmd_result          <= std_logic_vector(to_unsigned(C_ERR_MAX_RD_LAT_EXCEEDED,sig_cmd_result'length));
                            end if;

                            if rdata_valid /= std_logic_vector(to_unsigned(0, rdata_valid'length)) then
                                -- have found the read latency
                                sig_dgrb_state <= s_release_admin;
                            else
                                sig_count <= sig_count + 1;
                            end if;

                            rd_lat <= std_logic_vector(to_unsigned(sig_count, rd_lat'length));
                        end if;


                    when s_adv_wd_lat =>
                        sig_ac_req <= s_ac_read_wd_lat;

                        if sig_dgrb_state /= sig_dgrb_last_state then
                            sig_wd_lat <= (others => '0');
                        else
                            if sig_dimm_driving_dq = '1' and rdata_valid /= std_logic_vector(to_unsigned(0, rdata_valid'length)) then
                                -- construct wd_lat using data from the lowest addresses
                                -- wd_lat <= rdata(MEM_IF_DQ_PER_DQS - 1 downto 0);
                                sig_wd_lat     <= wd_lat_from_rdata(rdata);
                                sig_dgrb_state <= s_release_admin;

                                -- check data integrity
                                for i in 1 to MEM_IF_DWIDTH/set_wlat_dq_rep_width - 1 loop
                                    -- wd_lat is copied across MEM_IF_DWIDTH bits in fields of width MEM_IF_DQ_PER_DQS.
                                    -- All of these fields must have the same value or it is an error.

                                    -- only check if byte lane not disabled
                                    if cal_byte_lanes((i*set_wlat_dq_rep_width)/MEM_IF_DQ_PER_DQS) = '1' then

                                        if rdata(set_wlat_dq_rep_width - 1 downto 0) /= rdata((i+1)*set_wlat_dq_rep_width - 1 downto i*set_wlat_dq_rep_width) then
                                            -- signal write latency different between DQS groups
                                            report dgrb_report_prefix & "the write latency read from memory is different accross dqs groups" severity cal_fail_sev_level;
                                            sig_cmd_err             <= '1';
                                            sig_cmd_result          <= std_logic_vector(to_unsigned(C_ERR_WD_LAT_DISAGREEMENT, sig_cmd_result'length));
                                        end if;
                                    end if;

                                end loop;

                                -- check if ac_nt alignment is ok
                                -- in this condition all DWIDTH_RATIO copies of rdata should be identical
                                dgrb_ctrl_ac_nt_good <= '1';
                                if DWIDTH_RATIO /= 2 then
                                    for j in 0 to DWIDTH_RATIO/2 - 1 loop
                                        if rdata(j*MEM_IF_DWIDTH + MEM_IF_DQ_PER_DQS - 1 downto j*MEM_IF_DWIDTH) /= rdata((j+2)*MEM_IF_DWIDTH + MEM_IF_DQ_PER_DQS - 1 downto (j+2)*MEM_IF_DWIDTH) then
                                            dgrb_ctrl_ac_nt_good <= '0';
                                        end if;
                                    end loop;
                                end if;

                            end if;
                        end if;


                    when s_poa_cal =>
                        -- Request the address/command block begins reading the "M"
                        -- training pattern here.  There is no provision for doing
                        -- refreshes so this limits the time spent in this state
                        -- to 9 x tREFI (by the DDR2 JEDEC spec).  Instead of the
                        -- maximum value, a maximum "safe" time in this postamble
                        -- state is chosen to be tpoamax = 5 x tREFI = 5 x 3.9us.
                        -- When entering this s_poa_cal state it must be guaranteed
                        -- that the number of stacked refreshes is at maximum.
                        --
                        -- Minimum clock freq supported by DRAM is fck,min=125MHz.
                        -- Each adjustment to postamble latency requires 16*clock
                        -- cycles (time to read "M" training pattern twice) so
                        -- maximum number of adjustments to POA latency (n) is:
                        --
                        --   n = (5 x trefi x fck,min) / 16
                        --     = (5 x 3.9us x 125MHz) / 16
                        --     ~ 152
                        --
                        -- Postamble latency must be adjusted less than 152 cycles
                        -- to meet this requirement.
                        --

                        sig_ac_req <= s_ac_read_poa_mtp;

                        if sig_poa_ack = '1' then
                            sig_dgrb_state <= s_release_admin;
                        end if;

                    when s_track =>
                        if sig_trk_ack = '1' then
                            sig_dgrb_state <= s_release_admin;
                        end if;


                    when others => null;
                        report dgrb_report_prefix & "undefined state" severity failure;
                        sig_dgrb_state <= s_idle;
                end case;


                -- default if not calibrating go to idle state via s_release_admin
                if ctrl_dgrb_r.command = cmd_idle and
                   sig_dgrb_state /= s_idle and
                   sig_dgrb_state /= s_release_admin then

                    sig_dgrb_state <= s_release_admin;
                end if;

            end if;
        end process;
    end block;

    -- ------------------------------------------------------------------
    -- metastability hardening of potentially async phs_shift_busy signal
    --
    -- Triple register it for metastability hardening.  This process
    -- creates the shift register.  Also add a sig_phs_shft_busy and
    -- an sig_phs_shft_busy_1t echo because various other processes find
    -- this useful.
    -- ------------------------------------------------------------------
    phs_shft_busy_reg: block
            signal phs_shft_busy_1r : std_logic;
            signal phs_shft_busy_2r : std_logic;
            signal phs_shft_busy_3r : std_logic;
    begin
        phs_shift_busy_sync : process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_phs_shft_busy    <= '0';
                sig_phs_shft_busy_1t <= '0';

                phs_shft_busy_1r     <= '0';
                phs_shft_busy_2r     <= '0';
                phs_shft_busy_3r     <= '0';

                sig_phs_shft_start   <= '0';
                sig_phs_shft_end     <= '0';

            elsif rising_edge(clk) then
                sig_phs_shft_busy_1t <= phs_shft_busy_3r;
                sig_phs_shft_busy    <= phs_shft_busy_2r;

                -- register the below to reduce fan out on sig_phs_shft_busy and sig_phs_shft_busy_1t
                sig_phs_shft_start   <= phs_shft_busy_3r or  phs_shft_busy_2r;
                sig_phs_shft_end     <= phs_shft_busy_3r and not(phs_shft_busy_2r);

                phs_shft_busy_3r     <= phs_shft_busy_2r;
                phs_shft_busy_2r     <= phs_shft_busy_1r;
                phs_shft_busy_1r     <= phs_shft_busy;
            end if;
        end process;
    end block;

    -- ------------------------------------------------------------------
    -- PLL reconfig MUX
    --
    -- switches PLL Reconfig input between tracking and resync blocks
    -- ------------------------------------------------------------------
    pll_reconf_mux : process (clk, rst_n)
    begin
        if rst_n = '0' then
            seq_pll_inc_dec_n       <= '0';
            seq_pll_select          <= (others => '0');
            seq_pll_start_reconfig  <= '0';
        elsif rising_edge(clk) then
            if sig_dgrb_state = s_seek_cdvw or
               sig_dgrb_state = s_test_phases or
               sig_dgrb_state = s_reset_cdvw then
                seq_pll_select         <= pll_resync_clk_index;
                seq_pll_inc_dec_n      <= sig_rsc_pll_inc_dec_n;
                seq_pll_start_reconfig <= sig_rsc_pll_start_reconfig;
            elsif sig_dgrb_state = s_track then
                seq_pll_select         <= sig_trk_pll_select;
                seq_pll_inc_dec_n      <= sig_trk_pll_inc_dec_n;
                seq_pll_start_reconfig <= sig_trk_pll_start_reconfig;
            else
                seq_pll_select         <= pll_measure_clk_index;
                seq_pll_inc_dec_n      <= '0';
                seq_pll_start_reconfig <= '0';
            end if;
        end if;
    end process;

    -- ------------------------------------------------------------------
    -- Centre of data valid window calculation block
    --
    -- This block handles the sharing of the centre of window calculation
    -- logic between the rsc and trk operations. Functions defined in the
    -- header of this entity are called to do this.
    -- ------------------------------------------------------------------
    cdvw_block : block
        signal sig_cdvw_calc_1t : std_logic;
    begin
        -- purpose: manages centre of data valid window calculations
        -- type   : sequential
        -- inputs : clk, rst_n
        -- outputs: sig_cdvw_state
        cdvw_proc: process (clk, rst_n)
            variable v_cdvw_state  : t_window_processing;
            variable v_start_calc  : std_logic;
            variable v_shift_in    : std_logic;
            variable v_phase       : std_logic;
        begin  -- process cdvw_proc
            if rst_n = '0' then             -- asynchronous reset (active low)

                sig_cdvw_state   <= defaults;
                sig_cdvw_calc_1t <= '0';

            elsif rising_edge(clk) then  -- rising clock edge
                v_cdvw_state := sig_cdvw_state;

                case sig_dgrb_state is
                when s_track =>
                    v_start_calc := sig_trk_cdvw_calc;
                    v_phase := sig_trk_cdvw_phase;
                    v_shift_in := sig_trk_cdvw_shift_in;

                when s_read_mtp | s_seek_cdvw | s_test_phases =>
                    v_start_calc := sig_rsc_cdvw_calc;
                    v_phase      := sig_rsc_cdvw_phase;
                    v_shift_in   := sig_rsc_cdvw_shift_in;

                when others =>
                    v_start_calc := '0';
                    v_phase := '0';
                    v_shift_in := '0';
                end case;

                if sig_dgrb_state = s_reset_cdvw or (sig_dgrb_state = s_track and sig_dgrb_last_state /= s_track) then
                    -- reset *C*entre of *D*ata *V*alid *W*indow
                    v_cdvw_state := defaults;
                elsif sig_cdvw_calc_1t /= '1' and v_start_calc = '1' then
                    initialise_window_for_proc(v_cdvw_state);
                elsif v_cdvw_state.status = calculating then
                    if sig_dgrb_state = s_track then  -- ensure 360 degrees sweep
                        find_centre_of_largest_data_valid_window(v_cdvw_state, PLL_STEPS_PER_CYCLE);
                    else -- can be a 720 degrees sweep
                        find_centre_of_largest_data_valid_window(v_cdvw_state, c_max_phase_shifts);
                    end if;
                elsif v_shift_in = '1' then
                    if sig_dgrb_state = s_track then  -- ensure 360 degrees sweep
                        shift_in(v_cdvw_state, v_phase, PLL_STEPS_PER_CYCLE);
                    else
                        shift_in(v_cdvw_state, v_phase, c_max_phase_shifts);
                    end if;
                end if;

                sig_cdvw_calc_1t <= v_start_calc;
                sig_cdvw_state <= v_cdvw_state;
            end if;
        end process cdvw_proc;
    end block;


    -- ------------------------------------------------------------------
    -- block for resync calculation.
    --
    -- This block implements the following:
    -- 1) Control logic for the rsc slave state machine
    -- 2) Processing of resync operations - through reports form cdvw block and
    --    test pattern match blocks
    -- 3) Shifting of the resync phase for rsc sweeps
    -- 4) Writing of results to iram (optional)
    -- ------------------------------------------------------------------
    rsc_block : block

        signal sig_rsc_state             : t_resync_state;
        signal sig_rsc_last_state        : t_resync_state;

        signal sig_num_phase_shifts      : natural range c_max_phase_shifts - 1 downto 0;

        signal sig_rewind_direction      : std_logic;
        signal sig_count                 : natural range 0 to 2**8 - 1;
        signal sig_test_dq_expired       : std_logic;
        signal sig_chkd_all_dq_pins      : std_logic;

        -- prompts to write data to iram
        signal sig_dgrb_iram             : t_iram_push;                               -- internal copy of dgrb to iram control signals
        signal sig_rsc_push_rrp_sweep    : std_logic;                                 -- push result of a rrp sweep pass (for cmd_rrp_sweep)
        signal sig_rsc_push_rrp_pass     : std_logic;                                 -- result of a rrp sweep result (for cmd_rrp_sweep)
        signal sig_rsc_push_rrp_seek     : std_logic;                                 -- write seek results (for cmd_rrp_seek / cmd_read_mtp states)
        signal sig_rsc_push_footer       : std_logic;                                 -- write a footer
        signal sig_dq_pin_ctr_r          : natural range 0 to MEM_IF_DWIDTH - 1;      -- registered version of dq_pin_ctr
        signal sig_rsc_curr_phase        : natural range 0 to c_max_phase_shifts - 1; -- which phase is being processed
        signal sig_iram_idle             : std_logic;                                 -- track if iram currently writing data
        signal sig_mtp_match_en          : std_logic;

        -- current byte lane disabled?
        signal sig_curr_byte_ln_dis      : std_logic;

        signal sig_iram_wds_req          : integer;  -- words required for a given iram dump (used to locate where to write footer)

    begin
        -- When using DQS capture or not at full-rate only match on "even" clock cycles.
        sig_mtp_match_en <= active_high(sig_ac_even = '1' or MEM_IF_DQS_CAPTURE = 0 or DWIDTH_RATIO /= 2);

        -- register current byte lane disable mux for speed
        byte_lane_dis: process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_curr_byte_ln_dis <= '0';
            elsif rising_edge(clk) then
                sig_curr_byte_ln_dis <= cal_byte_lanes(sig_dq_pin_ctr/MEM_IF_DQ_PER_DQS);
            end if;
        end process;

        -- check if all dq pins checked in rsc sweep
        chkd_dq : process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_chkd_all_dq_pins  <= '0';
            elsif rising_edge(clk) then
                if sig_dq_pin_ctr = 0 then
                    sig_chkd_all_dq_pins <= '1';
                else
                    sig_chkd_all_dq_pins <= '0';
                end if;
            end if;
        end process;

        -- main rsc process
        rsc_proc : process (clk, rst_n)
            -- these are temporary variables which should not infer FFs and
            -- are not guaranteed to be initialized by s_rsc_idle.
            variable v_rdata_correct     : std_logic;
            variable v_phase_works       : std_logic;

        begin
            if rst_n = '0' then
                -- initialise signals
                sig_rsc_state         <= s_rsc_idle;
                sig_rsc_last_state    <= s_rsc_idle;

                sig_dq_pin_ctr        <= 0;
                sig_num_phase_shifts  <= c_max_phase_shifts - 1;  -- want c_max_phase_shifts-1 inc / decs of phase

                sig_count             <= 0;
                sig_test_dq_expired   <= '0';

                v_phase_works         := '0';

                -- interface to other processes to tell them when we are done.
                sig_rsc_ack           <= '0';
                sig_rsc_err           <= '0';
                sig_rsc_result        <= std_logic_vector(to_unsigned(C_SUCCESS, c_command_result_len));

                -- centre of data valid window functions
                sig_rsc_cdvw_phase    <= '0';
                sig_rsc_cdvw_shift_in <= '0';
                sig_rsc_cdvw_calc     <= '0';

                -- set up PLL reconfig interface controls
                sig_rsc_pll_start_reconfig <= '0';
                sig_rsc_pll_inc_dec_n      <= c_pll_phs_inc;
                sig_rewind_direction       <= c_pll_phs_dec;

                -- True when access to the ac_block is required.
                sig_rsc_ac_access_req      <= '0';

                -- default values on centre and size of data valid window
                if SIM_TIME_REDUCTIONS = 1 then
                    cal_codvw_phase        <= std_logic_vector(to_unsigned(PRESET_CODVW_PHASE, 8));
                    cal_codvw_size         <= std_logic_vector(to_unsigned(PRESET_CODVW_SIZE,  8));
                else
                    cal_codvw_phase        <= (others => '0');
                    cal_codvw_size         <= (others => '0');
                end if;

                sig_rsc_push_rrp_sweep     <= '0';
                sig_rsc_push_rrp_seek      <= '0';
                sig_rsc_push_rrp_pass      <= '0';
                sig_rsc_push_footer        <= '0';

                codvw_grt_one_dvw          <= '0';

            elsif rising_edge(clk) then
                -- default values assigned to some signals
                sig_rsc_ack                <= '0';

                sig_rsc_cdvw_phase         <= '0';
                sig_rsc_cdvw_shift_in      <= '0';
                sig_rsc_cdvw_calc          <= '0';

                sig_rsc_pll_start_reconfig <= '0';
                sig_rsc_pll_inc_dec_n      <= c_pll_phs_inc;
                sig_rewind_direction       <= c_pll_phs_dec;

                -- by default don't ask the resync block to read anything
                sig_rsc_ac_access_req      <= '0';

                sig_rsc_push_rrp_sweep     <= '0';
                sig_rsc_push_rrp_seek      <= '0';
                sig_rsc_push_rrp_pass      <= '0';
                sig_rsc_push_footer        <= '0';

                sig_test_dq_expired        <= '0';

                -- resync state machine
                case sig_rsc_state is
                    when s_rsc_idle =>
                        -- initialize those signals we are ready to use.
                        sig_dq_pin_ctr        <= 0;

                        sig_count             <= 0;

                        if sig_rsc_state = sig_rsc_last_state then  -- avoid transition when acknowledging a command has finished
                            if sig_rsc_req = s_rsc_test_phase then
                                sig_rsc_state <= s_rsc_test_phase;
                            elsif sig_rsc_req = s_rsc_cdvw_calc then
                                sig_rsc_state <= s_rsc_cdvw_calc;
                            elsif sig_rsc_req = s_rsc_seek_cdvw then
                                sig_rsc_state <= s_rsc_seek_cdvw;
                            elsif sig_rsc_req = s_rsc_reset_cdvw then
                                sig_rsc_state <= s_rsc_reset_cdvw;
                            else
                                sig_rsc_state <= s_rsc_idle;
                            end if;
                        end if;


                    when s_rsc_next_phase =>
                        sig_rsc_pll_inc_dec_n      <= c_pll_phs_inc;
                        sig_rsc_pll_start_reconfig <= '1';
                        if sig_phs_shft_start = '1' then
                            -- PLL phase shift started - so stop requesting a shift
                            sig_rsc_pll_start_reconfig <= '0';
                        end if;

                        if sig_phs_shft_end = '1' then
                            -- PLL phase shift finished - so proceed to flush the datapath
                            sig_num_phase_shifts <= sig_num_phase_shifts - 1;
                            sig_rsc_state <= s_rsc_test_phase;
                        end if;

                    when s_rsc_test_phase  =>
                        v_phase_works   := '1';
                        -- Note: For single pin single CS calibration set sig_dq_pin_ctr to 0 to
                        --       ensure that only 1 pin calibrated

                        sig_rsc_state   <= s_rsc_wait_for_idle_dimm;

                        if single_bit_cal = '1' then
                            sig_dq_pin_ctr      <= 0;
                        else
                            sig_dq_pin_ctr      <= MEM_IF_DWIDTH-1;
                        end if;

                    when s_rsc_wait_for_idle_dimm  =>
                        if sig_dimm_driving_dq = '0' then
                            sig_rsc_state <= s_rsc_flush_datapath;
                        end if;


                    when s_rsc_flush_datapath =>
                        sig_rsc_ac_access_req <= '1';
                        if sig_rsc_state /= sig_rsc_last_state then
                            -- reset variables we are interested in when we first arrive in this state.
                            sig_count <= c_max_read_lat - 1;
                        else
                            if sig_dimm_driving_dq = '1' then
                                if sig_count = 0 then
                                    sig_rsc_state <= s_rsc_test_dq;
                                else
                                    sig_count <= sig_count - 1;
                                end if;
                            end if;
                        end if;


                    when s_rsc_test_dq =>
                        sig_rsc_ac_access_req <= '1';

                        if sig_rsc_state  /= sig_rsc_last_state then
                            -- reset variables we are interested in when we first arrive in this state.
                            sig_count             <= 2*c_cal_mtp_t;

                        else

                            if sig_dimm_driving_dq = '1' then

                                if (
                                    (sig_mtp_match = '1' and sig_mtp_match_en = '1') or -- have a pattern match
                                    (sig_test_dq_expired = '1') or -- time in this phase has expired.
                                    sig_curr_byte_ln_dis = '0'  -- byte lane disabled
                                ) then

                                    v_phase_works := v_phase_works and ((sig_mtp_match and sig_mtp_match_en) or (not sig_curr_byte_ln_dis));

                                    sig_rsc_push_rrp_sweep <= '1';
                                    sig_rsc_push_rrp_pass <= (sig_mtp_match and sig_mtp_match_en) or (not sig_curr_byte_ln_dis);

                                    if sig_chkd_all_dq_pins = '1' then
                                        -- finished checking all dq pins.
                                        -- done checking this phase.

                                        -- shift phase status into
                                        sig_rsc_cdvw_phase    <= v_phase_works;
                                        sig_rsc_cdvw_shift_in <= '1';

                                        if sig_num_phase_shifts /= 0 then
                                            -- there are more phases to test so shift to next phase
                                            sig_rsc_state        <= s_rsc_next_phase;
                                        else
                                            -- no more phases to check.
                                            -- clean up after ourselves by
                                            -- going into s_rsc_rewind_phase
                                            sig_rsc_state        <= s_rsc_rewind_phase;
                                            sig_rewind_direction <= c_pll_phs_dec;
                                            sig_num_phase_shifts <= c_max_phase_shifts - 1;
                                        end if;
                                    else
                                        -- shift to next dq pin
                                        if MEM_IF_DWIDTH > 71 and             -- if >= 72 pins then:
                                           (sig_dq_pin_ctr mod 64) = 0 then   -- ensure refreshes at least once every 64 pins

                                            sig_rsc_state <= s_rsc_wait_for_idle_dimm;

                                        else -- otherwise continue sweep

                                            sig_rsc_state <= s_rsc_flush_datapath;
                                        end if;

                                        sig_dq_pin_ctr <= sig_dq_pin_ctr - 1;

                                    end if;

                                else

                                    sig_count <= sig_count - 1;

                                    if sig_count = 1 then
                                        sig_test_dq_expired <= '1';
                                    end if;

                                end if;
                            end if;
                       end if;

                    when s_rsc_reset_cdvw =>
                        sig_rsc_state        <= s_rsc_rewind_phase;

                        -- determine the amount to rewind by (may be wind forward depending on tracking behaviour)
                        if to_integer(unsigned(cal_codvw_phase)) + sig_trk_rsc_drift < 0 then
                            sig_num_phase_shifts <= - (to_integer(unsigned(cal_codvw_phase)) + sig_trk_rsc_drift);
                            sig_rewind_direction <= c_pll_phs_inc;
                        else
                            sig_num_phase_shifts <= (to_integer(unsigned(cal_codvw_phase)) + sig_trk_rsc_drift);
                            sig_rewind_direction <= c_pll_phs_dec;
                        end if;

                        -- reset the calibrated phase and size to zero (because un-doing prior calibration here)
                        cal_codvw_phase      <= (others => '0');
                        cal_codvw_size       <= (others => '0');

                    when s_rsc_rewind_phase =>
                        -- rewinds the resync PLL by sig_num_phase_shifts steps and returns to idle state
                        if sig_num_phase_shifts = 0 then
                            -- no more steps to take off, go to next state
                            sig_num_phase_shifts       <= c_max_phase_shifts - 1;

                            if GENERATE_ADDITIONAL_DBG_RTL = 1 then  -- if iram present hold off until access finished
                                sig_rsc_state <= s_rsc_wait_iram;
                            else
                                sig_rsc_ack   <= '1';
                                sig_rsc_state <= s_rsc_idle;
                            end if;

                        else
                            sig_rsc_pll_inc_dec_n <= sig_rewind_direction;

                            -- request a phase shift
                            sig_rsc_pll_start_reconfig <= '1';
                            if sig_phs_shft_busy = '1' then
                                -- inhibit a phase shift if phase shift is busy.
                                sig_rsc_pll_start_reconfig <= '0';
                            end if;

                            if sig_phs_shft_busy_1t = '1' and sig_phs_shft_busy /= '1' then
                                -- we've just successfully removed a phase step
                                -- decrement counter
                                sig_num_phase_shifts <= sig_num_phase_shifts - 1;
                                sig_rsc_pll_start_reconfig <= '0';
                            end if;
                        end if;


                    when s_rsc_cdvw_calc =>
                        if sig_rsc_state /= sig_rsc_last_state then
                            if sig_dgrb_state = s_read_mtp then
                                report dgrb_report_prefix & "gathered resync phase samples (for mtp alignment " & natural'image(current_mtp_almt) & ") is DGRB_PHASE_SAMPLES: " & str(sig_cdvw_state.working_window) severity note;
                            else
                                report dgrb_report_prefix & "gathered resync phase samples DGRB_PHASE_SAMPLES: " & str(sig_cdvw_state.working_window) severity note;
                            end if;
                            sig_rsc_cdvw_calc <= '1';  -- begin calculating result
                        else
                            sig_rsc_state <= s_rsc_cdvw_wait;
                        end if;


                    when s_rsc_cdvw_wait =>
                        if sig_cdvw_state.status /= calculating then
                            -- a result has been reached.
                            if sig_dgrb_state = s_read_mtp then  -- if doing mtp alignment then skip setting phase

                                if GENERATE_ADDITIONAL_DBG_RTL = 1 then  -- if iram present hold off until access finished
                                    sig_rsc_state <= s_rsc_wait_iram;
                                else
                                    sig_rsc_ack   <= '1';
                                    sig_rsc_state <= s_rsc_idle;
                                end if;

                            else
                                if sig_cdvw_state.status = valid_result then
                                    -- calculation successfully found a
                                    -- data-valid window to seek to.
                                    sig_rsc_state <= s_rsc_seek_cdvw;

				    sig_rsc_result <= std_logic_vector(to_unsigned(C_SUCCESS, sig_rsc_result'length));

				    -- If more than one data valid window was seen, then set the result code :
				    if (sig_cdvw_state.windows_seen > 1) then
                                        report dgrb_report_prefix & "Warning : multiple data-valid windows found, largest chosen." severity note;
					codvw_grt_one_dvw <= '1';
                                    else
                                        report dgrb_report_prefix & "data-valid window found successfully." severity note;
				    end if;

                                else
                                    -- calculation failed to find a data-valid window.

                                    report dgrb_report_prefix & "couldn't find a data-valid window in resync." severity warning;
                                    sig_rsc_ack  <= '1';
                                    sig_rsc_err  <= '1';
                                    sig_rsc_state <= s_rsc_idle;

                                    -- set resync result code
                                    case sig_cdvw_state.status is
                                        when no_invalid_phases =>
                                            sig_rsc_result <= std_logic_vector(to_unsigned(C_ERR_RESYNC_NO_VALID_PHASES, sig_rsc_result'length));
                                        when multiple_equal_windows =>
                                            sig_rsc_result <= std_logic_vector(to_unsigned(C_ERR_RESYNC_MULTIPLE_EQUAL_WINDOWS, sig_rsc_result'length));
                                        when no_valid_phases =>
                                            sig_rsc_result <= std_logic_vector(to_unsigned(C_ERR_RESYNC_NO_VALID_PHASES, sig_rsc_result'length));
                                        when others =>
                                            sig_rsc_result <= std_logic_vector(to_unsigned(C_ERR_CRITICAL, sig_rsc_result'length));
                                    end case;
                                end if;
                            end if;

                            -- signal to write a rrp_sweep result to iram
                            if GENERATE_ADDITIONAL_DBG_RTL = 1 then
                                sig_rsc_push_rrp_seek <= '1';
                            end if;

                        end if;


                    when s_rsc_seek_cdvw =>
                        if sig_rsc_state /= sig_rsc_last_state then
                            -- reset variables we are interested in when we first arrive in this state
                            sig_count <= sig_cdvw_state.largest_window_centre;
                        else
                            if sig_count = 0 or
                            ((MEM_IF_DQS_CAPTURE = 1 and DWIDTH_RATIO = 2) and
                             sig_count = PLL_STEPS_PER_CYCLE) -- if FR and DQS capture ensure within 0-360 degrees phase

                            then
                                -- ready to transition to next state
                                if GENERATE_ADDITIONAL_DBG_RTL = 1 then  -- if iram present hold off until access finished
                                    sig_rsc_state <= s_rsc_wait_iram;
                                else
                                    sig_rsc_ack   <= '1';
                                    sig_rsc_state <= s_rsc_idle;
                                end if;

                                -- return largest window centre and size in the result

                                -- perform cal_codvw phase / size update only if a valid result is found
                                if sig_cdvw_state.status = valid_result then

                                    cal_codvw_phase <= std_logic_vector(to_unsigned(sig_cdvw_state.largest_window_centre, 8));
                                    cal_codvw_size  <= std_logic_vector(to_unsigned(sig_cdvw_state.largest_window_size,   8));

                                end if;

                                -- leaving sig_rsc_err or sig_rsc_result at
                                -- their default values (of success)
                            else
                                sig_rsc_pll_inc_dec_n <= c_pll_phs_inc;

                                -- request a phase shift
                                sig_rsc_pll_start_reconfig <= '1';
                                if sig_phs_shft_start = '1' then
                                    -- inhibit a phase shift if phase shift is busy
                                    sig_rsc_pll_start_reconfig <= '0';
                                end if;

                                if sig_phs_shft_end = '1'  then
                                    -- we've just successfully removed a phase step
                                    -- decrement counter
                                    sig_count <= sig_count - 1;
                                end if;
                            end if;
                        end if;

                    when s_rsc_wait_iram =>

                        -- hold off check 1 clock cycle to enable last rsc push operations to start
                        if sig_rsc_state = sig_rsc_last_state then

                            if sig_iram_idle = '1' then

                                sig_rsc_ack         <= '1';
                                sig_rsc_state       <= s_rsc_idle;
                                if sig_dgrb_state = s_test_phases or
                                   sig_dgrb_state = s_seek_cdvw or
                                   sig_dgrb_state = s_read_mtp then

                                    sig_rsc_push_footer <= '1';

                                end if;

                            end if;

                        end if;

                    when others =>
                        null;
                end case;

                sig_rsc_last_state <= sig_rsc_state;
            end if;

        end process;


        -- write results to the iram

        iram_push: process (clk, rst_n)

        begin

            if rst_n = '0' then

                sig_dgrb_iram      <= defaults;
                sig_iram_idle      <= '0';
                sig_dq_pin_ctr_r   <= 0;
                sig_rsc_curr_phase <= 0;

                sig_iram_wds_req   <= 0;


            elsif rising_edge(clk) then

                if GENERATE_ADDITIONAL_DBG_RTL = 1 then

                    if sig_dgrb_iram.iram_write = '1' and sig_dgrb_iram.iram_done = '1' then
                        report dgrb_report_prefix & "iram_done and iram_write signals concurrently set - iram contents may be corrupted" severity failure;
                    end if;

                    if sig_dgrb_iram.iram_write = '0' and sig_dgrb_iram.iram_done = '0' then
                        sig_iram_idle            <= '1';
                    else
                        sig_iram_idle            <= '0';
                    end if;

                    -- registered sig_dq_pin_ctr to align with rrp_sweep result
                    sig_dq_pin_ctr_r   <= sig_dq_pin_ctr;

                    -- calculate current phase (registered to align with rrp_sweep result)
                    sig_rsc_curr_phase <= (c_max_phase_shifts - 1) - sig_num_phase_shifts;

                    -- serial push of rrp_sweep results into memory
                    if sig_rsc_push_rrp_sweep = '1' then

                        -- signal an iram write and track a write pending
                        sig_dgrb_iram.iram_write <= '1';
                        sig_iram_idle            <= '0';

                        -- if not single_bit_cal then pack pin phase results in MEM_IF_DWIDTH word blocks
                        if single_bit_cal = '1' then
                            sig_dgrb_iram.iram_wordnum <= sig_dq_pin_ctr_r + (sig_rsc_curr_phase/32);
                            sig_iram_wds_req           <= iram_wd_for_one_pin_rrp( DWIDTH_RATIO, PLL_STEPS_PER_CYCLE, MEM_IF_DWIDTH, MEM_IF_DQS_CAPTURE);  -- note total word requirement
                        else
                            sig_dgrb_iram.iram_wordnum <= sig_dq_pin_ctr_r + (sig_rsc_curr_phase/32) * MEM_IF_DWIDTH;
                            sig_iram_wds_req           <= iram_wd_for_full_rrp( DWIDTH_RATIO, PLL_STEPS_PER_CYCLE, MEM_IF_DWIDTH, MEM_IF_DQS_CAPTURE);     -- note total word requirement
                        end if;

                        -- check if current pin and phase passed:
                        sig_dgrb_iram.iram_pushdata(0) <= sig_rsc_push_rrp_pass;

                        -- bit offset is modulo phase
                        sig_dgrb_iram.iram_bitnum  <= sig_rsc_curr_phase mod 32;

                    end if;

                    -- write result of rrp_calc to iram when completed
                    if sig_rsc_push_rrp_seek = '1' then  -- a result found

                        sig_dgrb_iram.iram_write <= '1';
                        sig_iram_idle            <= '0';

                        sig_dgrb_iram.iram_wordnum <= 0;
                        sig_iram_wds_req           <= 1; -- note total word requirement

                        if sig_cdvw_state.status = valid_result then  -- result is valid

                            sig_dgrb_iram.iram_pushdata <= x"0000" &
                                                           std_logic_vector(to_unsigned(sig_cdvw_state.largest_window_centre, 8)) &
                                                           std_logic_vector(to_unsigned(sig_cdvw_state.largest_window_size, 8));

                        else  -- invalid result (error code communicated elsewhere)

                            sig_dgrb_iram.iram_pushdata <= x"FFFF" & -- signals an error condition
                                                           x"0000";

                        end if;

                    end if;

                    -- when stage finished write footer
                    if sig_rsc_push_footer = '1' then

                        sig_dgrb_iram.iram_done <= '1';
                        sig_iram_idle           <= '0';

                        -- set address location of footer
                        sig_dgrb_iram.iram_wordnum <= sig_iram_wds_req;

                    end if;

                    -- if write completed deassert iram_write and done signals
                    if iram_push_done = '1' then

                        sig_dgrb_iram.iram_write <= '0';
                        sig_dgrb_iram.iram_done  <= '0';

                    end if;

                else

                    sig_iram_idle      <= '0';
                    sig_dq_pin_ctr_r   <= 0;
                    sig_rsc_curr_phase <= 0;

                    sig_dgrb_iram      <= defaults;

                end if;

            end if;

        end process;

        -- concurrently assign sig_dgrb_iram to dgrb_iram
        dgrb_iram <= sig_dgrb_iram;

    end block; -- resync calculation

    -- ------------------------------------------------------------------
    -- test pattern match block
    --
    -- This block handles the sharing of logic for test pattern matching
    -- which is used in resync and postamble calibration / code blocks
    -- ------------------------------------------------------------------
    tp_match_block : block
    --
    --  Ascii Waveforms:
    --
    --                    ;         ;         ;         ;         ;         ;
    --                     ____      ____      ____      ____      ____      ____
    --   delayed_dqs |____|    |____|    |____|    |____|    |____|    |____|    |____|
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                    ; _______ ; _______ ; _______ ; _______ ; _______   _______
    --               XXXXX /       \ /       \ /       \ /       \ /       \ /       \
    --         c0,c1 XXXXXX   A B   X   C D   X   E F   X   G H   X   I J   X   L M   X  captured data
    --               XXXXX \_______/ \_______/ \_______/ \_______/ \_______/ \_______/
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                ____;     ____;     ____      ____      ____      ____      ____
    -- 180-resync_clk     |____|    |____|    |____|    |____|    |____|    |____|    |  180deg shift from delayed dqs
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                    ;      _______   _______   _______   _______   _______   ____
    --               XXXXXXXXXX /       \ /       \ /       \ /       \ /       \ /
    --     180-r0,r1 XXXXXXXXXXX   A B   X   C D   X   E F   X   G H   X   I J   X   L   resync data
    --               XXXXXXXXXX \_______/ \_______/ \_______/ \_______/ \_______/ \____
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                     ____      ____      ____      ____      ____      ____
    -- 360-resync_clk ____|    |____|    |____|    |____|    |____|    |____|    |____|
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ; _______ ; _______ ; _______ ; _______ ; _______
    --               XXXXXXXXXXXXXXX /       \ /       \ /       \ /       \ /       \
    --     360-r0,r1 XXXXXXXXXXXXXXXX   A B   X   C D   X   E F   X   G H   X   I J   X resync data
    --               XXXXXXXXXXXXXXX \_______/ \_______/ \_______/ \_______/ \_______/
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                ____      ____      ____      ____      ____      ____      ____
    -- 540-resync_clk     |____|    |____|    |____|    |____|    |____|    |____|    |
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;      _______   _______   _______   _______   ____
    --                XXXXXXXXXXXXXXXXXXX /       \ /       \ /       \ /       \ /
    --      540-r0,r1 XXXXXXXXXXXXXXXXXXXX   A B   X   C D   X   E F   X   G H   X   I  resync data
    --                XXXXXXXXXXXXXXXXXXX \_______/ \_______/ \_______/ \_______/ \____
    --                    ;         ;         ;         ;         ;         ;
    --                    ;         ;         ;         ;         ;         ;
    --                    ;____      ____      ____      ____      ____      ____
    --       phy_clk |____|    |____|    |____|    |____|    |____|    |____|    |____|
    --
    --                    0         1         2         3         4         5         6
    --
    --
    --              |<- Aligned Data ->|
    --      phy_clk 180-r0,r1  540-r0,r1  sig_mtp_match_en (generated from sig_ac_even)
    --            0  XXXXXXXX   XXXXXXXX  '1'
    --            1  XXXXXXAB   XXXXXXXX  '0'
    --            2  XXXXABCD   XXXXXXAB  '1'
    --            3  XXABCDEF   XXXXABCD  '0'
    --            4  ABCDEFGH   XXABCDEF  '1'
    --            5  CDEFGHAB   ABCDEFGH  '0'
    --
    --  In DQS-based capture, sweeping resync_clk from 180 degrees to 360
    --  does not necessarily result in a failure because the setup/hold
    --  requirements are so small.  The data comparison needs to fail when
    --  the resync_clk is shifted more than 360 degrees.  The
    --  sig_mtp_match_en signal allows the sequencer to blind itself
    --  training pattern matches that occur above 360 degrees.
    --
    --
    --
    --
    --
    --  Asserts sig_mtp_match.
    --
    --  Data comes in from rdata and is pushed into a two-bit wide shift register.
    --  It is a critical assumption that the rdata comes back byte aligned.
    --
    --
    --sig_mtp_match_valid
    --   rdata_valid  (shift-enable)
    --      |
    --      |
    --      +-----------------------+-----------+------------------+
    --                 ___          |           |                  |
    --     dq(0)  >---|   \         |     Shift Register           |
    --     dq(1)  >---|    \     +------+    +------+           +------------------+
    --     dq(2)  >---|     )--->| D(0) |-+->| D(1) |-+->...-+->| D(c_cal_mtp_len - 1) |
    --     ...        |    /     +------+ |  +------+ |      |  +------------------+
    --   dq(n-1)  >---|___/               +-----------++-...-+
    --                  |                             ||                                 +---+
    --                  |                            (==)--------> sig_mtp_match_0t ---->|   |-->sig_mtp_match_1t-->sig_mtp_match
    --                  |                             ||                                 +---+
    --                  |                 +-----------++...-+
    -- sig_dq_pin_ctr >-+        +------+ |  +------+ |     |  +------------------+
    --                           | P(0) |-+  | P(1) |-+ ...-+->| P(c_cal_mtp_len - 1) |
    --                           +------+    +------+          +------------------+
    --
    --
    --
    --
        signal sig_rdata_current_pin : std_logic_vector(c_cal_mtp_len - 1 downto 0);

        -- A fundamental assumption here is that rdata_valid is all
        -- ones or all zeros - not both.
        signal sig_rdata_valid_1t : std_logic; -- rdata_valid delayed by 1 clock period.
        signal sig_rdata_valid_2t : std_logic; -- rdata_valid delayed by 2 clock periods.

    begin
        rdata_valid_1t_proc : process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_rdata_valid_1t <= '0';
                sig_rdata_valid_2t <= '0';
            elsif rising_edge(clk) then
                sig_rdata_valid_2t <= sig_rdata_valid_1t;
                sig_rdata_valid_1t <= rdata_valid(0);
            end if;
        end process;


        -- MUX data into sig_rdata_current_pin shift register.
        rdata_current_pin_proc: process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_rdata_current_pin <= (others => '0');
            elsif rising_edge(clk) then
                -- shift old data down the shift register
                sig_rdata_current_pin(sig_rdata_current_pin'high - DWIDTH_RATIO downto 0) <=
                    sig_rdata_current_pin(sig_rdata_current_pin'high downto DWIDTH_RATIO);

                -- shift new data into the bottom of the shift register.
                for i in 0 to DWIDTH_RATIO - 1 loop
                    sig_rdata_current_pin(sig_rdata_current_pin'high - DWIDTH_RATIO + 1 + i) <= rdata(i*MEM_IF_DWIDTH + sig_dq_pin_ctr);
                end loop;
           end if;
        end process;



        mtp_match_proc : process (clk, rst_n)
        begin
            if rst_n = '0' then --  * when at least c_max_read_lat clock cycles have passed
                sig_mtp_match <= '0';
            elsif rising_edge(clk) then
                sig_mtp_match <= '0';

                if sig_rdata_current_pin = c_cal_mtp then
                    sig_mtp_match <= '1';
                end if;
            end if;
        end process;


        poa_match_proc : process (clk, rst_n)
        -- poa_match_Calibration Strategy
        --
        --  Ascii Waveforms:
        --
        --                   __    __    __    __    __    __    __    __    __
        --            clk __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |
        --
        --                                          ;     ;     ;     ;
        --                         _________________
        --    rdata_valid ________|                 |___________________________
        --
        --                                          ;     ;     ;     ;
        --                                                       _____
        --   poa_match_en ______________________________________|     |_______________
        --
        --                                          ;     ;     ;     ;
        --                                                       _____
        --      poa_match XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXXXXXXXXXXX
        --
        --
        -- Notes:
        --   -poa_match is only valid while poa_match_en is asserted.
        --
        --
        --
        --
        --
        --
        begin
            if rst_n = '0' then

                sig_poa_match_en <= '0';
                sig_poa_match    <= '0';

            elsif rising_edge(clk) then
                sig_poa_match <= '0';

                sig_poa_match_en <= '0';
                if sig_rdata_valid_2t = '1' and sig_rdata_valid_1t = '0' then
                    sig_poa_match_en <= '1';
                end if;

                if DWIDTH_RATIO = 2 then
                    if sig_rdata_current_pin(sig_rdata_current_pin'high downto sig_rdata_current_pin'length - 6) = "111100" then
                        sig_poa_match <= '1';
                    end if;
                elsif DWIDTH_RATIO = 4 then
                    if sig_rdata_current_pin(sig_rdata_current_pin'high downto sig_rdata_current_pin'length - 8) = "11111100" then
                        sig_poa_match <= '1';
                    end if;
                else
                    report dgrb_report_prefix & "unsupported DWIDTH_RATIO" severity failure;
                end if;

            end if;
        end process;
    end block;

    -- ------------------------------------------------------------------
    -- Postamble calibration
    --
    -- Implements the postamble slave state machine and collates the
    -- processing data from the test pattern match block.
    -- ------------------------------------------------------------------
    poa_block : block
    -- Postamble Calibration Strategy
    --
    --  Ascii Waveforms:
    --
    --                   c_read_burst_t      c_read_burst_t
    --                    ;<------->;         ;<------->;
    --                    ;         ;         ;         ;
    --                            __      / /         __
    --      mem_dq[0] ___________|  |_____\ \________|  |___
    --
    --                    ;         ;         ;         ;
    --                    ;         ;         ;         ;
    --                       _________    / /  _________
    --     poa_enable ______|         |___\ \_|         |___
    --                    ;         ;         ;         ;
    --                    ;         ;         ;         ;
    --                            __       / /        ______
    --       rdata[0] ___________|  |______\ \_______|
    --                    ;         ;         ;         ;
    --                    ;         ;         ;         ;
    --                    ;         ;         ;         ;
    --                               _    / /            _
    --    poa_match_en _____________| |___\ \___________| |_
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --                                    / /            _
    --       poa_match ___________________\ \___________| |_
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --                                 _  / /
    -- seq_poa_lat_dec _______________| |_\ \_______________
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --                                    / /
    -- seq_poa_lat_inc ___________________\ \_______________
    --                    ;         ; ;       ;         ; ;
    --                    ;         ; ;       ;         ; ;
    --
    --                             (1)                 (2)
    --
    --
    -- (1) poa_enable signal is late, and the zeros on mem_dq after (1)
    --    are captured.
    -- (2) poa_enable signal is aligned.  Zeros following (2) are not
    --    captured rdata remains at '1'.
    --
    --   The DQS capture circuit wth the dqs enable asynchronous set.
    --
    --
    --
    --  dqs_en_async_preset ----------+
    --                                |
    --                                v
    --                           +---------+
    --                        +--|Q  SET  D|----------- gnd
    --                        |  |        <O---+
    --                        |  +---------+   |
    --                        |                |
    --                        |                |
    --                        +--+---.         |
    --                           |AND )--------+------- dqs_bus
    --          delayed_dqs -----+---^
    --
    --
    --
    --                     _____       _____       _____       _____
    --           dqs  ____|     |_____|     |_____|     |_____|     |_____XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    --                    ;  ;           ;           ;           ;
    --                       ;           ;           ;           ;
    --                        _____       _____       _____       _____
    --   delayed_dqs  _______|     |_____|     |_____|     |_____|     |_____XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    --
    --                       ;           ;           ;           ;           ;
    --                       ;                      ______________________________________________________________
    -- dqs_en_async_  _____________________________|                                                              |_____
    --        preset
    --                       ;           ;           ;           ;           ;
    --                       ;           ;           ;           ;           ;
    --                        _____                   _____       _____
    --       dqs_bus  _______|     |_________________|     |_____|     |_____XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    --
    --                       ;                       ;
    --                      (1)                     (2)
    --
    --
    -- Notes:
    --    (1) The dqs_bus pulse here comes because the last value of Q
    --       is '1' until the first DQS pulse clocks gnd into the FF,
    --       brings low the AND gate, and disables dqs_bus.  A training
    --       pattern could potentially match at this point even though
    --       between (1) and (2) there are no dqs_bus triggers.  Data
    --       is frozen on rdata while awaiting the dqs_bus pulses at
    --       (2).  For this reason, wait until the first match of the
    --       training pattern, and continue reducing latency until it
    --       TP no longer matches, then increase latency by one.  In
    --       this case, dqs_en_async_preset will have its latency
    --       reduced by three until the training pattern is not matched,
    --       then latency is increased by one.
    --
    --
    --
    --

        -- Postamble calibration state
        type t_poa_state is (
            -- decrease poa enable latency by 1 cycle iteratively until 'correct' position found
            s_poa_rewind_to_pass,
            -- poa cal complete
            s_poa_done
        );

        constant c_poa_lat_cmd_wait : natural := 10; -- Number of clock cycles to wait for lat_inc/lat_dec signal to take effect.
        constant c_poa_max_lat : natural := 100; -- Maximum number of allowable latency changes.
        signal sig_poa_adjust_count : integer range 0 to 2**8 - 1;

        signal sig_poa_state : t_poa_state;


    begin

        poa_proc : process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_poa_ack <= '0';
                seq_poa_lat_dec_1x <= (others => '0');
                seq_poa_lat_inc_1x <= (others => '0');
                sig_poa_adjust_count <= 0;

                sig_poa_state <= s_poa_rewind_to_pass;

            elsif rising_edge(clk) then
                sig_poa_ack        <= '0';
                seq_poa_lat_inc_1x <= (others => '0');
                seq_poa_lat_dec_1x <= (others => '0');

                if sig_dgrb_state = s_poa_cal then
                    case sig_poa_state is
                        when s_poa_rewind_to_pass =>
                            -- In postamble calibration
                            --
                            -- Normally, must wait for sig_dimm_driving_dq to be '1'
                            -- before reading, but by this point in calibration
                            -- rdata_valid is assumed to be set up properly.  The
                            -- sig_poa_match_en (derived from rdata_valid) is used
                            -- here rather than sig_dimm_driving_dq.
                            if sig_poa_match_en = '1' then
                                if sig_poa_match = '1' then
                                    sig_poa_state <= s_poa_done;
                                else
                                    seq_poa_lat_dec_1x <= (others => '1');
                                end if;

                                sig_poa_adjust_count <= sig_poa_adjust_count + 1;
                            end if;


                        when s_poa_done =>
                            sig_poa_ack <= '1';
                    end case;
                else
                    sig_poa_state        <= s_poa_rewind_to_pass;
                    sig_poa_adjust_count <= 0;
                end if;


                assert sig_poa_adjust_count <= c_poa_max_lat
                    report dgrb_report_prefix & "Maximum number of postamble latency adjustments exceeded."
                    severity failure;
            end if;
        end process;

    end block;

    -- ------------------------------------------------------------------
    -- code block for tracking signal generation
    --
    -- this is used for initial tracking setup (finding a reference window)
    -- and periodic tracking operations (PVT compensation on rsc phase)
    --
    -- A slave trk state machine is described and implemented within the block
    -- The mimic path is controlled within this block
    -- ------------------------------------------------------------------
    trk_block : block

        type t_tracking_state is (
            -- initialise variables out of reset
            s_trk_init,
            -- idle state
            s_trk_idle,
            -- sample data from the mimic path (build window)
            s_trk_mimic_sample,
            -- 'shift' mimic path phase
            s_trk_next_phase,
            -- calculate mimic window
            s_trk_cdvw_calc,
            s_trk_cdvw_wait, -- for results
            -- calculate how much mimic window has moved (only entered in periodic tracking)
            s_trk_cdvw_drift,
            -- track rsc phase (only entered in periodic tracking)
            s_trk_adjust_resync,
            -- communicate command complete to the master state machine
            s_trk_complete
        );

        signal sig_mmc_seq_done              : std_logic;
        signal sig_mmc_seq_done_1t           : std_logic;
        signal mmc_seq_value_r               : std_logic;

        signal sig_mmc_start                 : std_logic;

        signal sig_trk_state                 : t_tracking_state;
        signal sig_trk_last_state            : t_tracking_state;

        signal sig_rsc_drift                 : integer range -c_max_rsc_drift_in_phases to c_max_rsc_drift_in_phases;  -- stores total change in rsc phase from first calibration
        signal sig_req_rsc_shift             : integer range -c_max_rsc_drift_in_phases to c_max_rsc_drift_in_phases;  -- stores required shift in rsc phase instantaneously
        signal sig_mimic_cdv_found           : std_logic;
        signal sig_mimic_cdv                 : integer range 0 to PLL_STEPS_PER_CYCLE;  -- centre of data valid window calculated from first mimic-cycle
        signal sig_mimic_delta               : integer range -PLL_STEPS_PER_CYCLE to PLL_STEPS_PER_CYCLE;
        signal sig_large_drift_seen          : std_logic;

        signal sig_remaining_samples         : natural range 0 to 2**8 - 1;

    begin

        -- advertise the codvw phase shift
        process (clk, rst_n)
            variable v_length : integer;
        begin

            if rst_n = '0' then

                codvw_trk_shift <= (others => '0');

            elsif rising_edge(clk) then

                if sig_mimic_cdv_found = '1' then

                    -- check range
                    v_length := codvw_trk_shift'length;

                    codvw_trk_shift <= std_logic_vector(to_signed(sig_rsc_drift, v_length));

                else

                    codvw_trk_shift <= (others => '0');

                end if;

            end if;
        end process;

        -- request a mimic sample
        mimic_sample_req : process (clk, rst_n)
            variable seq_mmc_start_r : std_logic_vector(3 downto 0);
        begin
            if rst_n = '0' then
                seq_mmc_start   <= '0';
                seq_mmc_start_r := "0000";
           elsif rising_edge(clk) then

                seq_mmc_start_r(3) := seq_mmc_start_r(2);
                seq_mmc_start_r(2) := seq_mmc_start_r(1);
                seq_mmc_start_r(1) := seq_mmc_start_r(0);

                -- extend sig_mmc_start by one clock cycle
                if sig_mmc_start = '1' then
                    seq_mmc_start <= '1';
                    seq_mmc_start_r(0) := '1';

                elsif ( (seq_mmc_start_r(3) = '1') or (seq_mmc_start_r(2) = '1') or (seq_mmc_start_r(1) = '1') or (seq_mmc_start_r(0) = '1') ) then
                    seq_mmc_start <= '1';
                    seq_mmc_start_r(0) := '0';

                else
                    seq_mmc_start <= '0';

                end if;

            end if;
        end process;

        -- metastability hardening of async mmc_seq_done signal
        mmc_seq_req_sync : process (clk, rst_n)
            variable v_mmc_seq_done_1r           : std_logic;
            variable v_mmc_seq_done_2r           : std_logic;
            variable v_mmc_seq_done_3r           : std_logic;
        begin
            if rst_n = '0' then
                sig_mmc_seq_done    <= '0';
                sig_mmc_seq_done_1t <= '0';

                v_mmc_seq_done_1r   := '0';
                v_mmc_seq_done_2r   := '0';
                v_mmc_seq_done_3r   := '0';
            elsif rising_edge(clk) then
                sig_mmc_seq_done_1t <= v_mmc_seq_done_3r;
                sig_mmc_seq_done    <= v_mmc_seq_done_2r;

                mmc_seq_value_r     <= mmc_seq_value;

                v_mmc_seq_done_3r   := v_mmc_seq_done_2r;
                v_mmc_seq_done_2r   := v_mmc_seq_done_1r;
                v_mmc_seq_done_1r   := mmc_seq_done;

            end if;
        end process;


        -- collect mimic samples as they arrive
        shift_in_mmc_seq_value : process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_trk_cdvw_shift_in <= '0';
                sig_trk_cdvw_phase    <= '0';
            elsif rising_edge(clk) then
                sig_trk_cdvw_shift_in <= '0';
                sig_trk_cdvw_phase    <= '0';
                if sig_mmc_seq_done_1t = '1' and sig_mmc_seq_done = '0' then
                    sig_trk_cdvw_shift_in <= '1';
                    sig_trk_cdvw_phase <= mmc_seq_value_r;
                end if;
            end if;
        end process;


        -- main tracking state machine
        trk_proc : process (clk, rst_n)
        begin
            if rst_n = '0' then
                sig_trk_state      <= s_trk_init;
                sig_trk_last_state <= s_trk_init;

                sig_trk_result          <= (others => '0');
                sig_trk_err             <= '0';
                sig_mmc_start           <= '0';

                sig_trk_pll_select      <= (others => '0');

                sig_req_rsc_shift       <= -c_max_rsc_drift_in_phases;
                sig_rsc_drift           <= -c_max_rsc_drift_in_phases;
                sig_mimic_delta         <= -PLL_STEPS_PER_CYCLE;

                sig_mimic_cdv_found     <= '0';
                sig_mimic_cdv           <= 0;

                sig_large_drift_seen    <= '0';

                sig_trk_cdvw_calc       <= '0';

                sig_remaining_samples   <= 0;

                sig_trk_pll_start_reconfig <= '0';
                sig_trk_pll_inc_dec_n      <= c_pll_phs_inc;

                sig_trk_ack                <= '0';

            elsif rising_edge(clk) then
                sig_trk_pll_select         <= pll_measure_clk_index;
                sig_trk_pll_start_reconfig <= '0';
                sig_trk_pll_inc_dec_n      <= c_pll_phs_inc;
                sig_large_drift_seen       <= '0';

                sig_trk_cdvw_calc  <= '0';

                sig_trk_ack        <= '0';
                sig_trk_err        <= '0';
                sig_trk_result     <= (others => '0');

                sig_mmc_start      <= '0';

                -- if no cdv found then reset tracking results
                if sig_mimic_cdv_found = '0' then
                    sig_rsc_drift       <= 0;
                    sig_req_rsc_shift   <= 0;
                    sig_mimic_delta     <= 0;
                end if;

                if sig_dgrb_state = s_track then

                    -- resync state machine
                    case sig_trk_state is
                        when s_trk_init =>
                            sig_trk_state       <= s_trk_idle;
                            sig_mimic_cdv_found <= '0';
                            sig_rsc_drift       <= 0;
                            sig_req_rsc_shift   <= 0;
                            sig_mimic_delta     <= 0;


                        when s_trk_idle =>
                            sig_remaining_samples <= PLL_STEPS_PER_CYCLE;  -- ensure a 360 degrees sweep
                            sig_trk_state         <= s_trk_mimic_sample;


                        when s_trk_mimic_sample =>
                            if sig_remaining_samples = 0 then
                                sig_trk_state  <= s_trk_cdvw_calc;
                            else
                                if sig_trk_state /= sig_trk_last_state then
                                    -- request a sample as soon as we arrive in this state.
                                    -- the default value of sig_mmc_start is zero!
                                    sig_mmc_start <= '1';
                                end if;

                                if sig_mmc_seq_done_1t = '1' and sig_mmc_seq_done = '0' then
                                    -- a sample has been collected, go to next PLL phase
                                    sig_remaining_samples <= sig_remaining_samples - 1;
                                    sig_trk_state         <= s_trk_next_phase;
                                end if;
                            end if;


                        when s_trk_next_phase =>
                            sig_trk_pll_start_reconfig <= '1';
                            sig_trk_pll_inc_dec_n      <= c_pll_phs_inc;

                            if sig_phs_shft_start = '1' then
                                sig_trk_pll_start_reconfig <= '0';
                            end if;

                            if sig_phs_shft_end = '1' then
                                sig_trk_state <= s_trk_mimic_sample;
                            end if;


                        when s_trk_cdvw_calc =>
                            if sig_trk_state /= sig_trk_last_state then
                                -- reset variables we are interested in when we first arrive in this state
                                sig_trk_cdvw_calc <= '1';
                                report dgrb_report_prefix & "gathered mimic phase samples DGRB_MIMIC_SAMPLES: " & str(sig_cdvw_state.working_window(sig_cdvw_state.working_window'high downto sig_cdvw_state.working_window'length - PLL_STEPS_PER_CYCLE)) severity note;
                            else
                                sig_trk_state <= s_trk_cdvw_wait;
                            end if;


                        when s_trk_cdvw_wait =>
                            if sig_cdvw_state.status /= calculating then
                                if sig_cdvw_state.status = valid_result then
                                    report dgrb_report_prefix & "mimic window successfully found." severity note;
                                    if sig_mimic_cdv_found = '0' then  -- first run of tracking operation
                                        sig_mimic_cdv_found <= '1';
                                        sig_mimic_cdv       <= sig_cdvw_state.largest_window_centre;
                                        sig_trk_state       <= s_trk_complete;
                                    else  -- subsequent tracking operation runs
                                        sig_mimic_delta     <= sig_mimic_cdv - sig_cdvw_state.largest_window_centre;
                                        sig_mimic_cdv       <= sig_cdvw_state.largest_window_centre;
                                        sig_trk_state       <= s_trk_cdvw_drift;
                                    end if;
                                else
                                    report dgrb_report_prefix & "couldn't find a data-valid window for tracking." severity cal_fail_sev_level;
                                    sig_trk_ack   <= '1';
                                    sig_trk_err   <= '1';
                                    sig_trk_state <= s_trk_idle;

                                    -- set resync result code
                                    case sig_cdvw_state.status is
                                        when no_invalid_phases =>
                                            sig_trk_result <= std_logic_vector(to_unsigned(C_ERR_RESYNC_NO_INVALID_PHASES, sig_trk_result'length));
                                        when multiple_equal_windows =>
                                            sig_trk_result <= std_logic_vector(to_unsigned(C_ERR_RESYNC_MULTIPLE_EQUAL_WINDOWS, sig_trk_result'length));
                                        when no_valid_phases =>
                                            sig_trk_result <= std_logic_vector(to_unsigned(C_ERR_RESYNC_NO_VALID_PHASES, sig_trk_result'length));
                                        when others =>
                                            sig_trk_result <= std_logic_vector(to_unsigned(C_ERR_CRITICAL, sig_trk_result'length));
                                    end case;
                                end if;
                            end if;

                        when s_trk_cdvw_drift =>  -- calculate the drift in rsc phase
                            -- pipeline stage 1
                            if abs(sig_mimic_delta) > PLL_STEPS_PER_CYCLE/2 then
                                sig_large_drift_seen <= '1';
                            else
                                sig_large_drift_seen <= '0';
                            end if;

                            --pipeline stage 2
                            if sig_trk_state = sig_trk_last_state then
                                if sig_large_drift_seen = '1' then
                                    if sig_mimic_delta < 0 then -- anti-clockwise movement
                                        sig_req_rsc_shift <= sig_req_rsc_shift + sig_mimic_delta + PLL_STEPS_PER_CYCLE;
                                    else  -- clockwise movement
                                        sig_req_rsc_shift <= sig_req_rsc_shift + sig_mimic_delta - PLL_STEPS_PER_CYCLE;
                                    end if;
                                else
                                    sig_req_rsc_shift <= sig_req_rsc_shift + sig_mimic_delta;
                                end if;
                                sig_trk_state <= s_trk_adjust_resync;
                            end if;

                        when s_trk_adjust_resync =>
                            sig_trk_pll_select <= pll_resync_clk_index;

                            sig_trk_pll_start_reconfig <= '1';

                            if sig_trk_state /= sig_trk_last_state then
                                if sig_req_rsc_shift < 0 then
                                    sig_trk_pll_inc_dec_n <= c_pll_phs_inc;
                                    sig_req_rsc_shift <= sig_req_rsc_shift + 1;
                                    sig_rsc_drift     <= sig_rsc_drift + 1;
                                elsif sig_req_rsc_shift > 0 then
                                    sig_trk_pll_inc_dec_n <= c_pll_phs_dec;
                                    sig_req_rsc_shift <= sig_req_rsc_shift - 1;
                                    sig_rsc_drift     <= sig_rsc_drift - 1;
                                else
                                    sig_trk_state <= s_trk_complete;
                                    sig_trk_pll_start_reconfig <= '0';
                                end if;
                            else
                                sig_trk_pll_inc_dec_n <= sig_trk_pll_inc_dec_n; -- maintain current value
                            end if;

                            if abs(sig_rsc_drift) = c_max_rsc_drift_in_phases then
                                report dgrb_report_prefix & " a maximum absolute change in resync_clk of " & integer'image(sig_rsc_drift) & " phases has " & LF &
                                                            " occurred (since read resynch phase calibration) during tracking" severity cal_fail_sev_level;
                                sig_trk_err    <= '1';
                                sig_trk_result <= std_logic_vector(to_unsigned(C_ERR_MAX_TRK_SHFT_EXCEEDED, sig_trk_result'length));
                            end if;

                            if sig_phs_shft_start = '1' then
                                sig_trk_pll_start_reconfig <= '0';
                            end if;

                            if sig_phs_shft_end = '1' then
                                sig_trk_state <= s_trk_complete;
                            end if;


                        when s_trk_complete =>
                            sig_trk_ack <= '1';

                    end case;

                    sig_trk_last_state <= sig_trk_state;
                else
                    sig_trk_state      <= s_trk_idle;
                    sig_trk_last_state <= s_trk_idle;
                end if;
            end if;

        end process;


        rsc_drift: process (sig_rsc_drift)
        begin
            sig_trk_rsc_drift <= sig_rsc_drift;  -- communicate tracking shift to rsc process
        end process;


    end block;  -- tracking signals

    -- ------------------------------------------------------------------
    -- write-datapath (WDP) ` and on-chip-termination (OCT) signal
    -- ------------------------------------------------------------------
    wdp_oct : process(clk,rst_n)
    begin
        if rst_n = '0' then
            seq_oct_value   <= c_set_oct_to_rs;
            dgrb_wdp_ovride <= '0';
        elsif rising_edge(clk) then
            if ((sig_dgrb_state = s_idle) or (EN_OCT = 0)) then
                seq_oct_value   <= c_set_oct_to_rs;
                dgrb_wdp_ovride <= '0';
            else
                seq_oct_value   <= c_set_oct_to_rt;
                dgrb_wdp_ovride <= '1';
            end if;
        end if;
    end process;


    -- ------------------------------------------------------------------
    -- handles muxing of error codes to the control block
    -- ------------------------------------------------------------------
    ac_handshake_proc : process(rst_n, clk)
    begin
        if rst_n = '0' then
            dgrb_ctrl          <= defaults;
        elsif rising_edge(clk) then
            dgrb_ctrl          <= defaults;

            if sig_dgrb_state = s_wait_admin and sig_dgrb_last_state = s_idle then
                dgrb_ctrl.command_ack <= '1';
            end if;


            case sig_dgrb_state is
                when s_seek_cdvw =>
                    dgrb_ctrl.command_err       <= sig_rsc_err;
                    dgrb_ctrl.command_result    <= sig_rsc_result;
                when s_track =>
                    dgrb_ctrl.command_err       <= sig_trk_err;
                    dgrb_ctrl.command_result    <= sig_trk_result;
                when others =>  -- from main state machine
                    dgrb_ctrl.command_err       <= sig_cmd_err;
                    dgrb_ctrl.command_result    <= sig_cmd_result;
            end case;

            if ctrl_dgrb_r.command = cmd_read_mtp then  -- check against command because aligned with command done not command_err
                dgrb_ctrl.command_err       <= '0';
                dgrb_ctrl.command_result    <= std_logic_vector(to_unsigned(sig_cdvw_state.largest_window_size,dgrb_ctrl.command_result'length));
            end if;

            if sig_dgrb_state = s_idle and sig_dgrb_last_state = s_release_admin then
                dgrb_ctrl.command_done <= '1';
            end if;
        end if;
    end process;


    -- ------------------------------------------------------------------
    -- address/command state machine
    -- process is commanded to begin reading training patterns.
    --
    -- implements the address/command slave state machine
    -- issues read commands to the memory relative to given calibration
    -- stage being implemented
    -- burst length is dependent on memory type
    -- ------------------------------------------------------------------
    ac_block : block

        -- override the calibration burst length for DDR3 device support
        -- (requires BL8 / on the fly setting in MR in admin block)
        function set_read_bl ( memtype: in string ) return natural is
        begin

            if memtype = "DDR3" then
                return 8;
            elsif memtype = "DDR" or memtype = "DDR2" then
                return c_cal_burst_len;
            else
                report dgrb_report_prefix & " a calibration burst length choice has not been set for memory type " & memtype severity failure;
            end if;

            return 0;

        end function;

        -- parameterisation of the read algorithm by burst length
        constant c_poa_addr_width      : natural := 6;
        constant c_cal_read_burst_len  : natural := set_read_bl(MEM_IF_MEMTYPE);
        constant c_bursts_per_btp      : natural := c_cal_mtp_len / c_cal_read_burst_len;
        constant c_read_burst_t        : natural := c_cal_read_burst_len / DWIDTH_RATIO;
        constant c_max_rdata_valid_lat : natural := 50*(c_cal_read_burst_len / DWIDTH_RATIO); -- maximum latency that rdata_valid can ever have with respect to doing_rd
        constant c_rdv_ones_rd_clks    : natural := (c_max_rdata_valid_lat + c_read_burst_t) / c_read_burst_t;  -- number of cycles to read ones for before a pulse of zeros

        -- array of burst training pattern addresses
        -- here the MTP is used in this addressing
        subtype t_btp_addr    is natural range 0 to 2 ** MEM_IF_ADDR_WIDTH - 1;
        type t_btp_addr_array is array (0 to c_bursts_per_btp - 1) of t_btp_addr;

        -- default values
        function defaults return t_btp_addr_array is
            variable v_btp_array : t_btp_addr_array;
        begin
            for i in 0 to c_bursts_per_btp - 1 loop
                v_btp_array(i) := 0;
            end loop;
            return v_btp_array;
        end function;

        -- load btp array addresses
        -- Note: this scales to burst lengths of 2, 4 and 8
        --       the settings here are specific to the choice of training pattern and need updating if the pattern changes
        function set_btp_addr (mtp_almt : natural ) return t_btp_addr_array is
            variable v_addr_array : t_btp_addr_array;
        begin
            for i in 0 to 8/c_cal_read_burst_len - 1 loop

                -- set addresses for xF5 data
                v_addr_array((c_bursts_per_btp - 1) - i) := MEM_IF_CAL_BASE_COL + c_cal_ofs_xF5 + i*c_cal_read_burst_len;

                -- set addresses for x30 data (based on mtp alignment)
                if mtp_almt = 0 then
                    v_addr_array((c_bursts_per_btp - 1) - (8/c_cal_read_burst_len + i)) := MEM_IF_CAL_BASE_COL + c_cal_ofs_x30_almt_0 + i*c_cal_read_burst_len;
                else
                    v_addr_array((c_bursts_per_btp - 1) - (8/c_cal_read_burst_len + i)) := MEM_IF_CAL_BASE_COL + c_cal_ofs_x30_almt_1 + i*c_cal_read_burst_len;
                end if;

            end loop;

            return v_addr_array;

        end function;


        function find_poa_cycle_period return natural is
            -- Returns the period over which the postamble reads
            -- repeat in c_read_burst_t units.
            variable v_num_bursts : natural;
        begin
            v_num_bursts := 2 ** c_poa_addr_width / c_read_burst_t;
            if v_num_bursts * c_read_burst_t < 2**c_poa_addr_width then
                v_num_bursts := v_num_bursts + 1;
            end if;

            v_num_bursts := v_num_bursts + c_bursts_per_btp + 1;

            return v_num_bursts;
        end function;


        function get_poa_burst_addr(burst_count : in natural; mtp_almt : in natural) return t_btp_addr is
            variable v_addr : t_btp_addr;
        begin
            if burst_count = 0 then
                if mtp_almt = 0 then
                    v_addr := c_cal_ofs_x30_almt_1;
                elsif mtp_almt = 1 then
                    v_addr := c_cal_ofs_x30_almt_0;
                else
                    report "Unsupported mtp_almt " & natural'image(mtp_almt) severity failure;
                end if;

                -- address gets incremented by four if in burst-length four.
                v_addr := v_addr + (8 - c_cal_read_burst_len);
            else
                v_addr := c_cal_ofs_zeros;
            end if;

            return v_addr;
        end function;


        signal btp_addr_array          : t_btp_addr_array;  -- burst training pattern addresses

        signal sig_addr_cmd_state      : t_ac_state;
        signal sig_addr_cmd_last_state : t_ac_state;

        signal sig_doing_rd_count : integer range 0 to c_read_burst_t - 1;
        signal sig_count       : integer range 0 to 2**8 - 1;
        signal sig_setup       : integer range c_max_read_lat downto 0;
        signal sig_burst_count : integer range 0 to c_read_burst_t;

    begin
        -- handles counts for when to begin burst-reads (sig_burst_count)
        -- sets sig_dimm_driving_dq
        -- sets dgrb_ac_access_req
        dimm_driving_dq_proc : process(rst_n, clk)
        begin
            if rst_n = '0' then
                sig_dimm_driving_dq <= '1';
                sig_setup           <= c_max_read_lat;
                sig_burst_count     <= 0;
                dgrb_ac_access_req  <= '0';
                sig_ac_even         <= '0';
            elsif rising_edge(clk) then
                sig_dimm_driving_dq <= '0';

                if sig_addr_cmd_state /= s_ac_idle and sig_addr_cmd_state /= s_ac_relax then
                    dgrb_ac_access_req <= '1';
                else
                    dgrb_ac_access_req <= '0';
                end if;

                case sig_addr_cmd_state is
                    when s_ac_read_mtp | s_ac_read_rdv | s_ac_read_wd_lat | s_ac_read_poa_mtp =>
                        sig_ac_even <= not sig_ac_even;

                        -- a counter that keeps track of when we are ready
                        -- to issue a burst read.  Issue burst read eigvery
                        -- time we are at zero.
                        if sig_burst_count = 0 then
                            sig_burst_count <= c_read_burst_t - 1;
                        else
                            sig_burst_count <= sig_burst_count - 1;
                        end if;


                        if dgrb_ac_access_gnt /= '1' then
                            sig_setup <= c_max_read_lat;
                        else
                            -- primes reads
                            -- signal that dimms are driving dq pins after
                            -- at least c_max_read_lat clock cycles have passed.
                            --
                            if sig_setup = 0 then
                                sig_dimm_driving_dq <= '1';
                            elsif dgrb_ac_access_gnt = '1' then
                                sig_setup <= sig_setup - 1;
                            end if;
                        end if;


                    when s_ac_relax =>
                        sig_dimm_driving_dq <= '1';
                        sig_burst_count <= 0;
                        sig_ac_even <= '0';


                    when others =>
                        sig_burst_count <= 0;
                        sig_ac_even <= '0';

                end case;
            end if;
        end process;


        ac_proc : process(rst_n, clk)
        begin
            if rst_n = '0' then
                sig_count               <= 0;
                sig_addr_cmd_state      <= s_ac_idle;
                sig_addr_cmd_last_state <= s_ac_idle;
                sig_doing_rd_count      <= 0;

                sig_addr_cmd            <= reset(c_seq_addr_cmd_config);

                btp_addr_array           <= defaults;
                sig_doing_rd             <= (others => '0');

            elsif rising_edge(clk) then
                assert c_cal_mtp_len mod c_cal_read_burst_len = 0 report dgrb_report_prefix & "burst-training pattern length must be a multiple of burst-length." severity failure;
                assert MEM_IF_CAL_BANK < 2**MEM_IF_BANKADDR_WIDTH report dgrb_report_prefix & "MEM_IF_CAL_BANK out of range." severity failure;
                assert MEM_IF_CAL_BASE_COL < 2**MEM_IF_ADDR_WIDTH - 1 - C_CAL_DATA_LEN report dgrb_report_prefix & "MEM_IF_CAL_BASE_COL out of range." severity failure;

                sig_addr_cmd   <= deselect(c_seq_addr_cmd_config, sig_addr_cmd);

                if sig_ac_req /= sig_addr_cmd_state and sig_addr_cmd_state /= s_ac_idle then
                -- and dgrb_ac_access_gnt = '1'
                    sig_addr_cmd_state <= s_ac_relax;
                else
                    sig_addr_cmd_state <= sig_ac_req;
                end if;

                if sig_doing_rd_count /= 0 then
                    sig_doing_rd <= (others => '1');
                    sig_doing_rd_count <= sig_doing_rd_count - 1;
                else
                    sig_doing_rd <= (others => '0');
                end if;

                case sig_addr_cmd_state is
                    when s_ac_idle =>
                        sig_addr_cmd   <= defaults(c_seq_addr_cmd_config);


                    when s_ac_relax =>
                        -- waits at least c_max_read_lat before returning to s_ac_idle state
                        if sig_addr_cmd_state /= sig_addr_cmd_last_state then
                            sig_count <= c_max_read_lat;
                        else
                            if sig_count = 0 then
                                sig_addr_cmd_state <= s_ac_idle;
                            else
                                sig_count <= sig_count - 1;
                            end if;
                        end if;

                    when s_ac_read_mtp =>
                        -- reads 'more'-training pattern
                        -- issue read commands for proper addresses

                        -- set burst training pattern (mtp in this case) addresses
                        btp_addr_array <= set_btp_addr(current_mtp_almt);

                        if sig_addr_cmd_state /= sig_addr_cmd_last_state then
                            sig_count <= c_bursts_per_btp - 1;  -- counts number of bursts in a training pattern
                        else
                            sig_doing_rd <= (others => '1');

                            -- issue a read command every c_read_burst_t clock cycles
                            if sig_burst_count = 0 then

                                -- decide which read command to issue
                                for i in 0 to c_bursts_per_btp - 1 loop

                                    if sig_count = i then

                                        sig_addr_cmd <= read(c_seq_addr_cmd_config, -- configuration
                                            sig_addr_cmd,                           -- previous value
                                            MEM_IF_CAL_BANK,                        -- bank
                                            btp_addr_array(i),                      -- column address
                                            2**current_cs,                          -- rank
                                            c_cal_read_burst_len,                   -- burst length
                                            false);
                                    end if;

                                end loop;

                                -- Set next value of count
                                if sig_count = 0 then
                                    sig_count <= c_bursts_per_btp - 1;
                                else
                                    sig_count <= sig_count - 1;
                                end if;

                            end if;

                        end if;

                    when s_ac_read_poa_mtp =>
                        -- Postamble rdata/rdata_valid Activity:
                        --
                        --
                        --                   (0)       (1)                           (2)
                        --                    ;         ;                             ;         ;
                        --               _________   __   ____________  _____________   _______   _________
                        --                        \ /  \ /            \ \            \ /       \ /
                        -- (a)  rdata[0] 00000000  X 11 X  0000000000 / / 0000000000  X   MTP   X  00000000
                        --               _________/ \__/ \____________\ \____________/ \_______/ \_________
                        --                    ;         ;                             ;         ;
                        --                    ;         ;                             ;         ;
                        --                     _________              / /              _________
                        --   rdata_valid  ____|         |_____________\ \_____________|         |__________
                        --
                        --                    ;<- (b) ->;<------------(c)------------>;         ;
                        --                    ;         ;                             ;         ;
                        --
                        --
                        --   This block must issue reads and drive doing_rd to place the above pattern on
                        -- the rdata and rdata_valid ports.  MTP will most likely come back corrupted but
                        -- the postamble block (poa_block) will make the necessary adjustments to improve
                        -- matters.
                        --
                        --   (a) Read zeros followed by two ones.  The two will be at the end of a burst.
                        --      Assert rdata_valid only during the burst containing the ones.
                        --   (b) c_read_burst_t clock cycles.
                        --   (c) Must be greater than but NOT equal to maximum postamble latency clock
                        --      cycles. Another way: c_min = (max_poa_lat + 1) phy clock cycles.  This
                        --      must also be long enough to allow the postamble block to respond to a
                        --      the seq_poa_lat_dec_1x signal, but this requirement is less stringent
                        --      than the first so that we can ignore it.
                        --
                        --   The find_poa_cycle_period function should return (b+c)/c_read_burst_t
                        -- rounded up to the next largest integer.
                        --
                        --

                        -- set burst training pattern (mtp in this case) addresses
                        btp_addr_array <= set_btp_addr(current_mtp_almt);

                        -- issue read commands for proper addresses
                        if sig_addr_cmd_state /= sig_addr_cmd_last_state then
                            sig_count <= find_poa_cycle_period - 1; -- length of read patter in bursts.
                        elsif dgrb_ac_access_gnt = '1' then
                            -- only begin operation once dgrb_ac_access_gnt has been issued
                            -- otherwise rdata_valid may be asserted when rdasta is not
                            -- valid.
                            --
                            -- *** WARNING: BE SAFE.  DON'T LET THIS HAPPEN TO YOU: ***
                            --
                            --                    ;         ;         ;         ;         ;         ;
                            --                    ; _______ ;         ; _______ ;         ; _______
                            --               XXXXX /       \ XXXXXXXXX /       \ XXXXXXXXX /       \ XXXXXXXXX
                            --      addr/cmd XXXXXX   READ  XXXXXXXXXXX   READ  XXXXXXXXXXX   READ  XXXXXXXXXXX
                            --               XXXXX \_______/ XXXXXXXXX \_______/ XXXXXXXXX \_______/ XXXXXXXXX
                            --                    ;         ;         ;         ;         ;         ;
                            --                    ;         ;         ;         ;         ;         ;
                            --                    ;         ;         ;         ;         ;         ; _______
                            --               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX /       \
                            --         rdata XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   MTP   X
                            --               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \_______/
                            --                    ;         ;         ;         ;         ;         ;
                            --                    ;         ;         ;         ;         ;         ;
                            --                     _________           _________           _________
                            --      doing_rd  ____|         |_________|         |_________|         |__________
                            --                    ;         ;         ;         ;         ;         ;
                            --                    ;         ;         ;         ;         ;         ;
                            --                               __________________________________________________
                            -- ac_accesss_gnt ______________|
                            --                    ;         ;         ;         ;         ;         ;
                            --                    ;         ;         ;         ;         ;         ;
                            --                                                   _________           _________
                            --    rdata_valid __________________________________|         |_________|         |
                            --                    ;         ;         ;         ;         ;         ;
                            --
                            --                   (0)       (1)                 (2)
                            --
                            --
                            --   Cmmand and doing_rd issued at (0).  The doing_rd signal enters the
                            -- rdata_valid pipe here so that it will return on rdata_valid with the
                            -- expected latency (at this point in calibration, rdata_valid and adv_rd_lat
                            -- should be properly calibrated).  Unlike doing_rd, since ac_access_gnt is not
                            -- asserted the READ command at (0) is never actually issued.  This results
                            -- in the situation at (2) where rdata is undefined yet rdata_valid indicates
                            -- valid data.  The moral of this story is to wait for ac_access_gnt = '1'
                            -- before issuing commands when it is important that rdata_valid be accurate.
                            --
                            --
                            --
                            --

                            if sig_burst_count = 0 then
                                sig_addr_cmd <= read(c_seq_addr_cmd_config, -- configuration
                                    sig_addr_cmd,                           -- previous value
                                    MEM_IF_CAL_BANK,                        -- bank
                                    get_poa_burst_addr(sig_count, current_mtp_almt),-- column address
                                    2**current_cs,                          -- rank
                                    c_cal_read_burst_len,                   -- burst length
                                    false);


                                -- Set doing_rd
                                if sig_count = 0 then
                                    sig_doing_rd <= (others => '1');
                                    sig_doing_rd_count <= c_read_burst_t - 1; -- Extend doing_rd pulse by this many phy_clk cycles.
                                end if;


                                -- Set next value of count
                                if sig_count = 0 then
                                    sig_count <= find_poa_cycle_period - 1;  -- read for one period then relax (no read) for same time period
                                else
                                    sig_count <= sig_count - 1;
                                end if;
                            end if;
                        end if;


                    when s_ac_read_rdv =>
                        assert c_max_rdata_valid_lat mod c_read_burst_t = 0 report dgrb_report_prefix & "c_max_rdata_valid_lat must be a multiple of c_read_burst_t." severity failure;

                        if sig_addr_cmd_state /= sig_addr_cmd_last_state then
                            sig_count <= c_rdv_ones_rd_clks - 1;
                        else
                            if sig_burst_count = 0 then
                                if sig_count = 0 then
                                    -- expecting to read ZEROS
                                    sig_addr_cmd <= read(c_seq_addr_cmd_config, -- configuration
                                        sig_addr_cmd,                           -- previous valid
                                        MEM_IF_CAL_BANK,                        -- bank
                                        MEM_IF_CAL_BASE_COL + C_CAL_OFS_ZEROS,  -- column
                                        2**current_cs,                          -- rank
                                        c_cal_read_burst_len,                   -- burst length
                                        false);

                                else
                                    -- expecting to read ONES
                                    sig_addr_cmd <= read(c_seq_addr_cmd_config, -- configuration
                                        sig_addr_cmd,                           -- previous value
                                        MEM_IF_CAL_BANK,                        -- bank
                                        MEM_IF_CAL_BASE_COL + C_CAL_OFS_ONES,   -- column address
                                        2**current_cs,                          -- rank
                                        c_cal_read_burst_len,                   -- op length
                                        false);
                                end if;

                                if sig_count = 0 then
                                    sig_count <= c_rdv_ones_rd_clks - 1;
                                else
                                    sig_count <= sig_count - 1;
                                end if;
                            end if;

                            if (sig_count = c_rdv_ones_rd_clks - 1 and sig_burst_count = 1) or
                               (sig_count = 0 and c_read_burst_t = 1) then
                                -- the last burst read- that was issued was supposed to read only zeros
                                -- a burst read command will be issued on the next clock cycle
                                --
                                -- A long (>= maximim rdata_valid latency) series of burst reads are
                                -- issued for ONES.
                                -- Into this stream a single burst read for ZEROs is issued.  After
                                -- the ZERO read command is issued, rdata_valid needs to come back
                                -- high one clock cycle before the next read command (reading ONES
                                -- again) is issued.  Since the rdata_valid is just a delayed
                                -- version of doing_rd, doing_rd needs to exhibit the same behaviour.
                                --
                                -- for FR (burst length 4): require that doing_rd high 1 clock cycle after cs_n is low
                                --               ____      ____      ____      ____      ____      ____      ____      ____      ____
                                -- clk      ____|    |____|    |____|    |____|    |____|    |____|    |____|    |____|    |____|
                                --
                                --          ___             _______             _______             _______             _______
                                --             \ XXXXXXXXX /       \ XXXXXXXXX /       \ XXXXXXXXX /       \ XXXXXXXXX /       \ XXXX
                                -- addr         XXXXXXXXXXX  ONES   XXXXXXXXXXX  ONES   XXXXXXXXXXX  ZEROS  XXXXXXXXXXX  ONES   XXXXX--> Repeat
                                --          ___/ XXXXXXXXX \_______/ XXXXXXXXX \_______/ XXXXXXXXX \_______/ XXXXXXXXX \_______/ XXXX
                                --
                                --               _________           _________           _________           _________           ____
                                -- cs_n     ____|         |_________|         |_________|         |_________|         |_________|
                                --
                                --                                                                           _________
                                -- doing_rd ________________________________________________________________|         |______________
                                --
                                --
                                -- for HR: require that doing_rd high in the same clock cycle as cs_n is low
                                --

                                sig_doing_rd(MEM_IF_DQS_WIDTH*(DWIDTH_RATIO/2-1)) <= '1';

                            end if;
                        end if;


                    when s_ac_read_wd_lat =>
                        -- continuously issues reads on the memory locations
                        -- containing write latency addr=[2*c_cal_burst_len - (3*c_cal_burst_len - 1)]

                        if sig_addr_cmd_state /= sig_addr_cmd_last_state then
                            -- no initialization required here.  Must still wait
                            -- a clock cycle before beginning operations so that
                            -- we are properly synchronized with
                            -- dimm_driving_dq_proc.
                        else
                            if sig_burst_count = 0 then
                                if sig_dimm_driving_dq = '1' then
                                    sig_doing_rd <= (others => '1');
                                end if;

                                sig_addr_cmd <= read(c_seq_addr_cmd_config,     -- configuration
                                    sig_addr_cmd,                               -- previous value
                                    MEM_IF_CAL_BANK,                            -- bank
                                    MEM_IF_CAL_BASE_COL + c_cal_ofs_wd_lat,     -- column
                                    2**current_cs,                              -- rank
                                    c_cal_read_burst_len,
                                    false);
                            end if;
                        end if;


                    when others =>
                        report dgrb_report_prefix & "undefined state in addr_cmd_proc" severity error;
                        sig_addr_cmd_state <= s_ac_idle;
                end case;

                -- mask odt signal
                for i in 0 to (DWIDTH_RATIO/2)-1 loop
                    sig_addr_cmd(i).odt <= odt_settings(current_cs).read;
                end loop;

                sig_addr_cmd_last_state <= sig_addr_cmd_state;
            end if;

        end process;

    end block ac_block;

end architecture struct;

--

-- -----------------------------------------------------------------------------
--  Abstract        : data gatherer (write bias) [dgwb] block for the non-levelling
--                    AFI PHY sequencer
-- -----------------------------------------------------------------------------


library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
    use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The address and command package (alt_mem_phy_addr_cmd_pkg) is used to combine DRAM address
-- and command signals in one record and unify the functions operating on this record.
--
    use work.ddr3_int_phy_alt_mem_phy_addr_cmd_pkg.all;

--
entity ddr3_int_phy_alt_mem_phy_dgwb is
    generic (
        -- Physical IF width definitions
        MEM_IF_DQS_WIDTH               : natural;
        MEM_IF_DQ_PER_DQS              : natural;
        MEM_IF_DWIDTH                  : natural;
        MEM_IF_DM_WIDTH                : natural;
        DWIDTH_RATIO                   : natural;
        MEM_IF_ADDR_WIDTH              : natural;
        MEM_IF_BANKADDR_WIDTH          : natural;
        MEM_IF_NUM_RANKS               : natural; -- The sequencer outputs memory control signals of width num_ranks
        MEM_IF_MEMTYPE                 : string;
        ADV_LAT_WIDTH                  : natural;
        MEM_IF_CAL_BANK                : natural; -- Bank to which calibration data is written
        -- Base column address to which calibration data is written.
        -- Memory at MEM_IF_CAL_BASE_COL - MEM_IF_CAL_BASE_COL + C_CAL_DATA_LEN - 1
        -- is assumed to contain the proper data.
        MEM_IF_CAL_BASE_COL            : natural
    );
    port (
        -- CLK Reset
        clk                            : in    std_logic;
        rst_n                          : in    std_logic;

        parameterisation_rec           : in    t_algm_paramaterisation;

        -- Control interface :
        dgwb_ctrl                      : out   t_ctrl_stat;
        ctrl_dgwb                      : in    t_ctrl_command;

        -- iRAM 'push' interface :
        dgwb_iram                      : out   t_iram_push;
        iram_push_done                 : in    std_logic;

        -- Admin block req/gnt interface.
        dgwb_ac_access_req             : out   std_logic;
        dgwb_ac_access_gnt             : in    std_logic;

        -- WDP interface
        dgwb_dqs_burst                 : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_DQS_WIDTH      - 1 downto 0);
        dgwb_wdata_valid               : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_DQS_WIDTH      - 1 downto 0);
        dgwb_wdata                     : out   std_logic_vector( DWIDTH_RATIO    * MEM_IF_DWIDTH         - 1 downto 0);
        dgwb_dm                        : out   std_logic_vector( DWIDTH_RATIO    * MEM_IF_DM_WIDTH       - 1 downto 0);
        dgwb_dqs                       : out   std_logic_vector( DWIDTH_RATIO                            - 1 downto 0);
        dgwb_wdp_ovride                : out   std_logic;

        -- addr/cmd output for write commands.
        dgwb_ac                        : out t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);

        bypassed_rdata                 : in    std_logic_vector(MEM_IF_DWIDTH-1 downto 0);

        -- odt settings per chip select
        odt_settings                   : in    t_odt_array(0 to MEM_IF_NUM_RANKS-1)

    );

end entity;

library work;

-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
    use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;

--
architecture rtl of ddr3_int_phy_alt_mem_phy_dgwb is

    type t_dgwb_state is (
        s_idle,
        s_wait_admin,

        s_write_btp,      -- Writes bit-training pattern
        s_write_ones,     -- Writes ones
        s_write_zeros,    -- Writes zeros
        s_write_mtp,      -- Write more training patterns (requires read to check allignment)
        s_write_01_pairs, -- Writes 01 pairs
        s_write_1100_step,-- Write step function (half zeros, half ones)
        s_write_0011_step,-- Write reversed step function (half ones, half zeros)
        s_write_wlat,     -- Writes the write latency into a memory address.

        s_release_admin
    );

    constant c_seq_addr_cmd_config  : t_addr_cmd_config_rec        := set_config_rec(MEM_IF_ADDR_WIDTH, MEM_IF_BANKADDR_WIDTH, MEM_IF_NUM_RANKS, DWIDTH_RATIO, MEM_IF_MEMTYPE);

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant dgwb_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (dgwb) : ";

    function dqs_pattern return std_logic_vector is
        variable dqs : std_logic_vector( DWIDTH_RATIO - 1 downto 0);
    begin
        if DWIDTH_RATIO = 2 then
            dqs := "10";
        elsif DWIDTH_RATIO = 4 then
            dqs := "1100";
        else
            report dgwb_report_prefix & "unsupported DWIDTH_RATIO in function dqs_pattern." severity failure;
        end if;
        return dqs;
    end;

    signal sig_addr_cmd             : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);

    signal sig_dgwb_state           : t_dgwb_state;
    signal sig_dgwb_last_state      : t_dgwb_state;
    signal access_complete          : std_logic;

    signal generate_wdata           : std_logic;  -- for s_write_wlat only

    -- current chip select being processed
    signal current_cs               : natural range 0 to MEM_IF_NUM_RANKS-1;

begin
    dgwb_ac <= sig_addr_cmd;

    -- Set IRAM interface to defaults
    dgwb_iram <= defaults;

    -- Master state machine.  Generates state transitions.
    master_dgwb_state_block : if True generate
        signal sig_ctrl_dgwb : t_ctrl_command; -- registers ctrl_dgwb input.
    begin
	    -- generate the current_cs signal to track which cs accessed by PHY at any instance
	    current_cs_proc : process (clk, rst_n)
	    begin
	        if rst_n = '0' then
	            current_cs <= 0;
	        elsif rising_edge(clk) then
	            if sig_ctrl_dgwb.command_req = '1' then
	                current_cs <= sig_ctrl_dgwb.command_op.current_cs;
	            end if;
	        end if;
	    end process;


        master_dgwb_state_proc : process(rst_n, clk)
        begin
            if rst_n = '0' then
                sig_dgwb_state      <= s_idle;
                sig_dgwb_last_state <= s_idle;
                sig_ctrl_dgwb       <= defaults;
            elsif rising_edge(clk) then
                case sig_dgwb_state is
                    when s_idle =>
                        if sig_ctrl_dgwb.command_req = '1' then
                            if (curr_active_block(sig_ctrl_dgwb.command) = dgwb) then
                                sig_dgwb_state <= s_wait_admin;
                            end if;
                        end if;


                    when s_wait_admin =>
                        case sig_ctrl_dgwb.command is
                            when cmd_write_btp => sig_dgwb_state <= s_write_btp;
                            when cmd_write_mtp => sig_dgwb_state <= s_write_mtp;
                            when cmd_was       => sig_dgwb_state <= s_write_wlat;

                            when others        =>
                                report dgwb_report_prefix & "unknown command" severity error;
                        end case;

                        if dgwb_ac_access_gnt /= '1' then
                            sig_dgwb_state <= s_wait_admin;
                        end if;


                    when s_write_btp =>
                        sig_dgwb_state <= s_write_zeros;


                    when s_write_zeros =>
                        if sig_dgwb_state = sig_dgwb_last_state and access_complete = '1' then
                            sig_dgwb_state <= s_write_ones;
                        end if;


                    when s_write_ones =>
                        if sig_dgwb_state = sig_dgwb_last_state and access_complete = '1' then
                            sig_dgwb_state <= s_release_admin;
                        end if;


                    when s_write_mtp =>
                        sig_dgwb_state <= s_write_01_pairs;


                    when s_write_01_pairs =>
                        if sig_dgwb_state = sig_dgwb_last_state and access_complete = '1' then
                            sig_dgwb_state <= s_write_1100_step;
                        end if;

                    when s_write_1100_step =>
                        if sig_dgwb_state = sig_dgwb_last_state and access_complete = '1' then
                            sig_dgwb_state <= s_write_0011_step;
                        end if;


                    when s_write_0011_step =>
                        if sig_dgwb_state = sig_dgwb_last_state and access_complete = '1' then
                            sig_dgwb_state <= s_release_admin;
                        end if;


                    when s_write_wlat =>
                        if sig_dgwb_state = sig_dgwb_last_state and access_complete = '1' then
                            sig_dgwb_state <= s_release_admin;
                        end if;


                    when s_release_admin =>
                        if dgwb_ac_access_gnt = '0' then
                            sig_dgwb_state <= s_idle;
                        end if;


                    when others =>
                        report dgwb_report_prefix & "undefined state in addr_cmd_proc" severity error;
                        sig_dgwb_state <= s_idle;
                end case;

                sig_dgwb_last_state <= sig_dgwb_state;
                sig_ctrl_dgwb       <= ctrl_dgwb;
            end if;
        end process;
    end generate;


    -- Generates writes
    ac_write_block : if True generate

        constant C_BURST_T    : natural := C_CAL_BURST_LEN / DWIDTH_RATIO;  -- Number of phy-clock cycles per burst
        constant C_MAX_WLAT   : natural := 2**ADV_LAT_WIDTH-1;  -- Maximum latency in clock cycles
        constant C_MAX_COUNT  : natural := C_MAX_WLAT + C_BURST_T + 4*12 - 1;  -- up to 12 consecutive writes at 4 cycle intervals

        -- The following function sets the width over which
        -- write latency should be repeated on the dq bus
        -- the default value is MEM_IF_DQ_PER_DQS
        function set_wlat_dq_rep_width return natural is
        begin
            for i in 1 to MEM_IF_DWIDTH/MEM_IF_DQ_PER_DQS loop
                if (i*MEM_IF_DQ_PER_DQS) >= ADV_LAT_WIDTH then
                    return i*MEM_IF_DQ_PER_DQS;
                end if;
            end loop;
            report dgwb_report_prefix & "the specified maximum write latency cannot be fully represented in the given number of DQ pins" & LF &
                                        "** NOTE: This may cause overflow when setting ctl_wlat signal" severity warning;
            return MEM_IF_DQ_PER_DQS;
        end function;

        constant C_WLAT_DQ_REP_WIDTH : natural := set_wlat_dq_rep_width;

        signal sig_count      : natural range 0 to 2**8 - 1;
    begin
        ac_write_proc : process(rst_n, clk)
        begin
            if rst_n = '0' then
                dgwb_wdp_ovride  <= '0';
                dgwb_dqs         <= (others => '0');
                dgwb_dm          <= (others => '1');
                dgwb_wdata       <= (others => '0');
                dgwb_dqs_burst   <= (others => '0');
                dgwb_wdata_valid <= (others => '0');
                generate_wdata   <= '0';  -- for s_write_wlat only
                sig_count        <= 0;
                sig_addr_cmd     <= int_pup_reset(c_seq_addr_cmd_config);
                access_complete  <= '0';

            elsif rising_edge(clk) then
                dgwb_wdp_ovride  <= '0';
                dgwb_dqs         <= (others => '0');
                dgwb_dm          <= (others => '1');
                dgwb_wdata       <= (others => '0');
                dgwb_dqs_burst   <= (others => '0');
                dgwb_wdata_valid <= (others => '0');
                sig_addr_cmd     <= deselect(c_seq_addr_cmd_config, sig_addr_cmd);
                access_complete  <= '0';
                generate_wdata   <= '0';  -- for s_write_wlat only

                case sig_dgwb_state is

                    when s_idle =>
                        sig_addr_cmd     <= defaults(c_seq_addr_cmd_config);

                    -- require ones in locations:
                    --  1. c_cal_ofs_ones (8 locations)
                    --  2. 2nd half of location c_cal_ofs_xF5 (4 locations)
                    when s_write_ones =>
                        dgwb_wdp_ovride  <= '1';
                        dgwb_dqs         <= dqs_pattern;
                        dgwb_dm          <= (others => '0');
                        dgwb_dqs_burst   <= (others => '1');

                        -- Write ONES to DQ pins
                        dgwb_wdata       <= (others => '1');
                        dgwb_wdata_valid <= (others => '1');

                        -- Issue write command
                        if sig_dgwb_state /= sig_dgwb_last_state then
                            sig_count <= 0;
                        else

                            -- ensure safe intervals for DDRx memory writes (min 4 mem clk cycles between writes for BC4 DDR3)
                            if sig_count = 0 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                sig_addr_cmd,
                                                MEM_IF_CAL_BANK,                        -- bank
                                                MEM_IF_CAL_BASE_COL + c_cal_ofs_ones,   -- address
                                                2**current_cs,                          -- rank
                                                4,                                      -- burst length (fixed at BC4)
                                                false);                                 -- auto-precharge
                            elsif sig_count = 4 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                sig_addr_cmd,
                                                MEM_IF_CAL_BANK,                          -- bank
                                                MEM_IF_CAL_BASE_COL + c_cal_ofs_ones + 4, -- address
                                                2**current_cs,                            -- rank
                                                4,                                        -- burst length (fixed at BC4)
                                                false);                                   -- auto-precharge
                            elsif sig_count = 8 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                sig_addr_cmd,
                                                MEM_IF_CAL_BANK,                          -- bank
                                                MEM_IF_CAL_BASE_COL + c_cal_ofs_xF5 + 4,  -- address
                                                2**current_cs,                            -- rank
                                                4,                                        -- burst length (fixed at BC4)
                                                false);                                   -- auto-precharge
                            end if;
                            sig_count <= sig_count + 1;
                        end if;

                        if sig_count = C_MAX_COUNT - 1 then
                            access_complete <= '1';
                        end if;

                    -- require zeros in locations:
                    --  1. c_cal_ofs_zeros (8 locations)
                    --  2. 1st half of c_cal_ofs_x30_almt_0 (4 locations)
                    --  3. 1st half of c_cal_ofs_x30_almt_1 (4 locations)
                    when s_write_zeros =>
                        dgwb_wdp_ovride  <= '1';
                        dgwb_dqs         <= dqs_pattern;
                        dgwb_dm          <= (others => '0');
                        dgwb_dqs_burst   <= (others => '1');

                        -- Write ZEROS to DQ pins
                        dgwb_wdata       <= (others => '0');
                        dgwb_wdata_valid <= (others => '1');

                        -- Issue write command
                        if sig_dgwb_state /= sig_dgwb_last_state then
                            sig_count <= 0;
                        else

                            if sig_count = 0 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                    sig_addr_cmd,
                                                    MEM_IF_CAL_BANK,                            -- bank
                                                    MEM_IF_CAL_BASE_COL + c_cal_ofs_zeros,      -- address
                                                    2**current_cs,                              -- rank
                                                    4,                                          -- burst length (fixed at BC4)
                                                    false);                                     -- auto-precharge
                            elsif sig_count = 4 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                    sig_addr_cmd,
                                                    MEM_IF_CAL_BANK,                            -- bank
                                                    MEM_IF_CAL_BASE_COL + c_cal_ofs_zeros + 4,  -- address
                                                    2**current_cs,                              -- rank
                                                    4,                                          -- burst length (fixed at BC4)
                                                    false);                                     -- auto-precharge
                            elsif sig_count = 8 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                    sig_addr_cmd,
                                                    MEM_IF_CAL_BANK,                            -- bank
                                                    MEM_IF_CAL_BASE_COL + c_cal_ofs_x30_almt_0, -- address
                                                    2**current_cs,                              -- rank
                                                    4,                                          -- burst length (fixed at BC4)
                                                    false);                                     -- auto-precharge
                            elsif sig_count = 12 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                    sig_addr_cmd,
                                                    MEM_IF_CAL_BANK,                            -- bank
                                                    MEM_IF_CAL_BASE_COL + c_cal_ofs_x30_almt_1, -- address
                                                    2**current_cs,                              -- rank
                                                    4,                                          -- burst length (fixed at BC4)
                                                    false);                                     -- auto-precharge
                            end if;
                            sig_count <= sig_count + 1;
                        end if;


                        if sig_count = C_MAX_COUNT - 1 then
                            access_complete <= '1';
                        end if;

                    -- require 0101 pattern in locations:
                    --  1. 1st half of location c_cal_ofs_xF5 (4 locations)
                    when s_write_01_pairs =>
                        dgwb_wdp_ovride  <= '1';
                        dgwb_dqs         <= dqs_pattern;
                        dgwb_dm          <= (others => '0');
                        dgwb_dqs_burst   <= (others => '1');

                        dgwb_wdata_valid <= (others => '1');

                        -- Issue write command
                        if sig_dgwb_state /= sig_dgwb_last_state then
                            sig_count <= 0;
                        else
                            if sig_count = 0 then
                                sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                sig_addr_cmd,
                                                MEM_IF_CAL_BANK,                       -- bank
                                                MEM_IF_CAL_BASE_COL + c_cal_ofs_xF5,   -- address
                                                2**current_cs,                         -- rank
                                                4,                                     -- burst length
                                                false);                                -- auto-precharge
                            end if;
                            sig_count <= sig_count + 1;
                        end if;


                        if sig_count = C_MAX_COUNT - 1 then
                            access_complete <= '1';
                        end if;

                        -- Write 01 to pairs of memory addresses
                        for i in 0 to dgwb_wdata'length / MEM_IF_DWIDTH - 1 loop
                            if i mod 2 = 0 then
                                dgwb_wdata((i+1)*MEM_IF_DWIDTH - 1 downto i*MEM_IF_DWIDTH) <= (others => '1');
                            else
                                dgwb_wdata((i+1)*MEM_IF_DWIDTH - 1 downto i*MEM_IF_DWIDTH) <= (others => '0');
                            end if;
                        end loop;

                    -- require pattern "0011" (or "1100") in locations:
                    --  1. 2nd half of c_cal_ofs_x30_almt_0 (4 locations)
                    when s_write_0011_step =>
                        dgwb_wdp_ovride  <= '1';
                        dgwb_dqs         <= dqs_pattern;
                        dgwb_dm          <= (others => '0');
                        dgwb_dqs_burst   <= (others => '1');

                        dgwb_wdata_valid <= (others => '1');

                        -- Issue write command
                        if sig_dgwb_state /= sig_dgwb_last_state then
                            sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                sig_addr_cmd,
                                                MEM_IF_CAL_BANK,                                -- bank
                                                MEM_IF_CAL_BASE_COL + c_cal_ofs_x30_almt_0 + 4, -- address
                                                2**current_cs,                                  -- rank
                                                4,                                              -- burst length
                                                false);                                         -- auto-precharge
                            sig_count <= 0;
                        else
                            sig_count <= sig_count + 1;
                        end if;


                        if sig_count = C_MAX_COUNT - 1 then
                            access_complete <= '1';
                        end if;

                        -- Write 0011 step to column addresses.  Note that
                        -- it cannot be determined which at this point.  The
                        -- strategy is to write both alignments and see which
                        -- one is correct later on.

                        -- this calculation has 2 parts:
                        -- a) sig_count mod C_BURST_T is a timewise iterator of repetition of the pattern
                        -- b) i represents the temporal iterator of the pattern
                        -- it is required to sum a and b and switch the pattern between 0 and 1 every 2 locations in each dimension
                        -- Note: the same formulae is used below for the 1100 pattern

                        for i in 0 to dgwb_wdata'length / MEM_IF_DWIDTH - 1 loop
                            if ((sig_count mod C_BURST_T) + (i/2)) mod 2 = 0 then
                                dgwb_wdata((i+1)*MEM_IF_DWIDTH - 1 downto i*MEM_IF_DWIDTH) <= (others => '0');
                            else
                                dgwb_wdata((i+1)*MEM_IF_DWIDTH - 1 downto i*MEM_IF_DWIDTH) <= (others => '1');
                            end if;
                        end loop;

                    -- require pattern "1100" (or "0011") in locations:
                    --  1. 2nd half of c_cal_ofs_x30_almt_1 (4 locations)
                    when s_write_1100_step =>
                        dgwb_wdp_ovride  <= '1';
                        dgwb_dqs         <= dqs_pattern;
                        dgwb_dm          <= (others => '0');
                        dgwb_dqs_burst   <= (others => '1');

                        dgwb_wdata_valid <= (others => '1');

                        -- Issue write command
                        if sig_dgwb_state /= sig_dgwb_last_state then
                            sig_addr_cmd <= write(c_seq_addr_cmd_config,
                                                sig_addr_cmd,
                                                MEM_IF_CAL_BANK,                                -- bank
                                                MEM_IF_CAL_BASE_COL + c_cal_ofs_x30_almt_1 + 4, -- address
                                                2**current_cs,                                  -- rank
                                                4,                                              -- burst length
                                                false);                                         -- auto-precharge
                            sig_count <= 0;
                        else
                            sig_count <= sig_count + 1;
                        end if;


                        if sig_count = C_MAX_COUNT - 1 then
                            access_complete <= '1';
                        end if;

                        -- Write 1100 step to column addresses.  Note that
                        -- it cannot be determined which at this point.  The
                        -- strategy is to write both alignments and see which
                        -- one is correct later on.
                        for i in 0 to dgwb_wdata'length / MEM_IF_DWIDTH - 1 loop
                            if ((sig_count mod C_BURST_T) + (i/2)) mod 2 = 0 then
                                dgwb_wdata((i+1)*MEM_IF_DWIDTH - 1 downto i*MEM_IF_DWIDTH) <= (others => '1');
                            else
                                dgwb_wdata((i+1)*MEM_IF_DWIDTH - 1 downto i*MEM_IF_DWIDTH) <= (others => '0');
                            end if;
                        end loop;


                    when s_write_wlat =>
                        -- Effect:
                        --   *Writes the memory latency to an array formed
                        --   from memory addr=[2*C_CAL_BURST_LEN-(3*C_CAL_BURST_LEN-1)].
                        --   The write latency is written to pairs of addresses
                        --   across the given range.
                        --
                        --   Example
                        --   C_CAL_BURST_LEN = 4
                        --   addr 8  -  9 [WLAT]  size = 2*MEM_IF_DWIDTH bits
                        --   addr 10 - 11 [WLAT]  size = 2*MEM_IF_DWIDTH bits
                        --

                        dgwb_wdp_ovride  <= '1';
                        dgwb_dqs         <= dqs_pattern;
                        dgwb_dm          <= (others => '0');
                        dgwb_wdata       <= (others => '0');
                        dgwb_dqs_burst   <= (others => '1');
                        dgwb_wdata_valid <= (others => '1');

                        if sig_dgwb_state /= sig_dgwb_last_state then
                            sig_addr_cmd <= write(c_seq_addr_cmd_config,    -- A/C configuration
                                sig_addr_cmd,
                                MEM_IF_CAL_BANK,                            -- bank
                                MEM_IF_CAL_BASE_COL + c_cal_ofs_wd_lat,     -- address
                                2**current_cs,                              -- rank
                                8,                                          -- burst length (8 for DDR3 and 4 for DDR/DDR2)
                                false);                                     -- auto-precharge
                            sig_count <= 0;
                        else
                            -- hold wdata_valid and wdata 2 clock cycles
                            -- 1 - because ac signal registered at top level of sequencer
                            -- 2 - because want time to dqs_burst edge which occurs 1 cycle earlier
                            --     than wdata_valid in an AFI compliant controller
                            generate_wdata <= '1';
                        end if;

                        if generate_wdata = '1' then
                            for i in 0 to dgwb_wdata'length/C_WLAT_DQ_REP_WIDTH - 1 loop
                                dgwb_wdata((i+1)*C_WLAT_DQ_REP_WIDTH - 1 downto i*C_WLAT_DQ_REP_WIDTH) <= std_logic_vector(to_unsigned(sig_count, C_WLAT_DQ_REP_WIDTH));
                            end loop;

                            -- delay by 1 clock cycle to account for 1 cycle discrepancy
                            -- between dqs_burst and wdata_valid
                            if sig_count = C_MAX_COUNT then
                                access_complete   <= '1';
                            end if;

                            sig_count <= sig_count + 1;
                        end if;

                    when others =>
                        null;
                end case;

                -- mask odt signal
                for i in 0 to (DWIDTH_RATIO/2)-1 loop
                    sig_addr_cmd(i).odt <= odt_settings(current_cs).write;
                end loop;

            end if;
        end process;
    end generate;


    -- Handles handshaking for access to address/command
    ac_handshake_proc : process(rst_n, clk)
    begin
        if rst_n = '0' then
            dgwb_ctrl          <= defaults;
            dgwb_ac_access_req <= '0';
        elsif rising_edge(clk) then
            dgwb_ctrl          <= defaults;
            dgwb_ac_access_req <= '0';

            if sig_dgwb_state /= s_idle and sig_dgwb_state /= s_release_admin then
                dgwb_ac_access_req <= '1';
            elsif sig_dgwb_state = s_idle or sig_dgwb_state = s_release_admin then
                dgwb_ac_access_req <= '0';
            else
                report dgwb_report_prefix & "unexpected state in ac_handshake_proc so haven't requested access to address/command." severity warning;
            end if;

            if sig_dgwb_state = s_wait_admin and sig_dgwb_last_state = s_idle then
                dgwb_ctrl.command_ack <= '1';
            end if;

            if sig_dgwb_state = s_idle and sig_dgwb_last_state = s_release_admin then
                dgwb_ctrl.command_done <= '1';
            end if;
        end if;
    end process;

end architecture rtl;
--

-- -----------------------------------------------------------------------------
-- Abstract : ctrl block for the non-levelling AFI PHY sequencer
--            This block is the central control unit for the sequencer. The method
--            of control is to issue commands (prefixed cmd_) to each of the other
--            sequencer blocks to execute. Each command corresponds to a stage of
--            the AFI PHY calibaration stage, and in turn each state represents a
--            command or a supplimentary flow control operation. In addition to
--            controlling the sequencer this block also checks for time out
--            conditions which occur when a different system block is faulty.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
    use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The iram address package (alt_mem_phy_iram_addr_pkg) is used to define the base addresses used
-- for iram writes during calibration
--
    use work.ddr3_int_phy_alt_mem_phy_iram_addr_pkg.all;

--
entity ddr3_int_phy_alt_mem_phy_ctrl is
    generic (
        FAMILYGROUP_ID                 : natural;
        MEM_IF_DLL_LOCK_COUNT          : natural;
        MEM_IF_MEMTYPE                 : string;
        DWIDTH_RATIO                   : natural;
        IRAM_ADDRESSING                : t_base_hdr_addresses;
        MEM_IF_CLK_PS                  : natural;
        TRACKING_INTERVAL_IN_MS        : natural;
        MEM_IF_NUM_RANKS               : natural;
        MEM_IF_DQS_WIDTH               : natural;

        GENERATE_ADDITIONAL_DBG_RTL    : natural;
        SIM_TIME_REDUCTIONS            : natural; -- if 0 null, if 1 skip rrp, if 2 rrp for 1 dqs group and 1 cs

        ACK_SEVERITY                   : severity_level
    );
    port (
        -- clk / reset
        clk                            : in    std_logic;
        rst_n                          : in    std_logic;

        -- calibration status and redo request
        ctl_init_success               : out   std_logic;
        ctl_init_fail                  : out   std_logic;
        ctl_recalibrate_req            : in    std_logic;    -- acts as a synchronous reset

        -- status signals from iram
        iram_status                    : in    t_iram_stat;
        iram_push_done                 : in    std_logic;

        -- standard control signal to all blocks
        ctrl_op_rec                    : out   t_ctrl_command;

        -- standardised response from all system blocks
        admin_ctrl                     : in    t_ctrl_stat;
        dgrb_ctrl                      : in    t_ctrl_stat;
        dgwb_ctrl                      : in    t_ctrl_stat;

        -- mmi to ctrl interface
        mmi_ctrl                       : in   t_mmi_ctrl;
        ctrl_mmi                       : out  t_ctrl_mmi;

        -- byte lane select
        ctl_cal_byte_lanes             : in    std_logic_vector(MEM_IF_NUM_RANKS * MEM_IF_DQS_WIDTH  - 1 downto 0);

        -- signals to control the ac_nt setting
        dgrb_ctrl_ac_nt_good           : in   std_logic;
        int_ac_nt                      : out  std_logic_vector(((DWIDTH_RATIO+2)/4) - 1 downto 0);  -- width of 1 for DWIDTH_RATIO =2,4 and 2 for DWIDTH_RATIO = 8

        -- the following signals are reserved for future use
        ctrl_iram_push                 : out   t_ctrl_iram

    );
end entity;

library work;
-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
    use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;


--
architecture struct of ddr3_int_phy_alt_mem_phy_ctrl is

        -- a prefix for all report signals to identify phy and sequencer block
--
    constant ctrl_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (ctrl) : ";

    -- decoder to find the relevant disable bit (from mmi registers) for a given state
    function find_dis_bit
        (
         state    : t_master_sm_state;
         mmi_ctrl : t_mmi_ctrl
        ) return std_logic is
        variable v_dis : std_logic;
    begin
        case state is
            when s_phy_initialise         => v_dis := mmi_ctrl.hl_css.phy_initialise_dis;
            when s_init_dram |
                 s_prog_cal_mr            => v_dis := mmi_ctrl.hl_css.init_dram_dis;
            when s_write_ihi              => v_dis := mmi_ctrl.hl_css.write_ihi_dis;
            when s_cal                    => v_dis := mmi_ctrl.hl_css.cal_dis;
            when s_write_btp              => v_dis := mmi_ctrl.hl_css.write_btp_dis;
            when s_write_mtp              => v_dis := mmi_ctrl.hl_css.write_mtp_dis;
            when s_read_mtp               => v_dis := mmi_ctrl.hl_css.read_mtp_dis;
            when s_rrp_reset              => v_dis := mmi_ctrl.hl_css.rrp_reset_dis;
            when s_rrp_sweep              => v_dis := mmi_ctrl.hl_css.rrp_sweep_dis;
            when s_rrp_seek               => v_dis := mmi_ctrl.hl_css.rrp_seek_dis;
            when s_rdv                    => v_dis := mmi_ctrl.hl_css.rdv_dis;
            when s_poa                    => v_dis := mmi_ctrl.hl_css.poa_dis;
            when s_was                    => v_dis := mmi_ctrl.hl_css.was_dis;
            when s_adv_rd_lat             => v_dis := mmi_ctrl.hl_css.adv_rd_lat_dis;
            when s_adv_wr_lat             => v_dis := mmi_ctrl.hl_css.adv_wr_lat_dis;
            when s_prep_customer_mr_setup => v_dis := mmi_ctrl.hl_css.prep_customer_mr_setup_dis;
            when s_tracking_setup |
                 s_tracking               => v_dis := mmi_ctrl.hl_css.tracking_dis;
            when others                   => v_dis := '1'; -- default change stage
        end case;
        return v_dis;
    end function;

    -- decoder to find the relevant command for a given state
    function find_cmd
       (
        state : t_master_sm_state
       ) return t_ctrl_cmd_id is
    begin
        case state is
            when s_phy_initialise         => return cmd_phy_initialise;
            when s_init_dram              => return cmd_init_dram;
            when s_prog_cal_mr            => return cmd_prog_cal_mr;
            when s_write_ihi              => return cmd_write_ihi;
            when s_cal                    => return cmd_idle;
            when s_write_btp              => return cmd_write_btp;
            when s_write_mtp              => return cmd_write_mtp;
            when s_read_mtp               => return cmd_read_mtp;
            when s_rrp_reset              => return cmd_rrp_reset;
            when s_rrp_sweep              => return cmd_rrp_sweep;
            when s_rrp_seek               => return cmd_rrp_seek;
            when s_rdv                    => return cmd_rdv;
            when s_poa                    => return cmd_poa;
            when s_was                    => return cmd_was;
            when s_adv_rd_lat             => return cmd_prep_adv_rd_lat;
            when s_adv_wr_lat             => return cmd_prep_adv_wr_lat;
            when s_prep_customer_mr_setup => return cmd_prep_customer_mr_setup;
            when s_tracking_setup |
                 s_tracking               => return cmd_tr_due;
            when others                   => return cmd_idle;
        end case;
    end function;

    function mcs_rw_state -- returns true for multiple cs read/write states
        (
         state : t_master_sm_state
        ) return boolean is
    begin
        case state is

            when s_write_btp | s_write_mtp | s_rrp_sweep =>
                return true;

            when s_reset | s_phy_initialise | s_init_dram | s_prog_cal_mr | s_write_ihi | s_cal |
                 s_read_mtp | s_rrp_reset | s_rrp_seek | s_rdv | s_poa |
                 s_was | s_adv_rd_lat | s_adv_wr_lat | s_prep_customer_mr_setup |
                 s_tracking_setup | s_tracking | s_operational | s_non_operational =>

                return false;

            when others =>
--
                return false;

        end case;

    end function;

    -- timing parameters
    constant c_done_timeout_count     : natural := 32768;
    constant c_ack_timeout_count      : natural := 1000;
    constant c_ticks_per_ms           : natural := 1000000000/(MEM_IF_CLK_PS*(DWIDTH_RATIO/2));
    constant c_ticks_per_10us         : natural := 10000000  /(MEM_IF_CLK_PS*(DWIDTH_RATIO/2));

    -- local copy of calibration fail/success signals
    signal int_ctl_init_fail          : std_logic;
    signal int_ctl_init_success       : std_logic;

    -- state machine (master for sequencer)
    signal state                      : t_master_sm_state;
    signal last_state                 : t_master_sm_state;

    -- flow control signals for state machine
    signal dis_state                  : std_logic;   -- disable state
    signal hold_state                 : std_logic;   -- hold in state for 1 clock cycle

    signal master_ctrl_op_rec         : t_ctrl_command; -- master command record to all sequencer blocks
    signal master_ctrl_iram_push      : t_ctrl_iram;    -- record indicating control details for pushes

    signal dll_lock_counter           : natural range MEM_IF_DLL_LOCK_COUNT - 1 downto 0;  -- to wait for dll to lock
    signal iram_init_complete         : std_logic;

    -- timeout signals to check if a block has 'hung'
    signal timeout_counter            : natural range c_done_timeout_count - 1 downto 0;
    signal timeout_counter_stop       : std_logic;
    signal timeout_counter_enable     : std_logic;
    signal timeout_counter_clear      : std_logic;

    signal cmd_req_asserted           : std_logic;     -- a command has been issued

    signal flag_ack_timeout           : std_logic;     -- req -> ack timed out
    signal flag_done_timeout          : std_logic;     -- reg -> done timed out

    signal waiting_for_ack            : std_logic;     -- command issued
    signal cmd_ack_seen               : std_logic;     -- command completed

    signal curr_ctrl                  : t_ctrl_stat;   -- response for current active block
    signal curr_cmd                   : t_ctrl_cmd_id;

    -- store state information based on issued command
    signal int_ctrl_prev_stage        : t_ctrl_cmd_id;
    signal int_ctrl_current_stage     : t_ctrl_cmd_id;

    -- multiple chip select counter
    signal cs_counter                 : natural range 0 to MEM_IF_NUM_RANKS - 1;
    signal reissue_cmd_req            : std_logic; -- reissue command request for multiple cs

    signal cal_cs_enabled             : std_logic_vector(MEM_IF_NUM_RANKS - 1 downto 0);

    -- signals to check the ac_nt setting
    signal ac_nt_almts_checked        : natural range 0 to DWIDTH_RATIO/2-1;
    signal ac_nt                      : std_logic_vector(((DWIDTH_RATIO+2)/4) - 1 downto 0);

    -- track the mtp alignment setting
    signal mtp_almts_checked          : natural range 0 to 2;
    signal mtp_correct_almt           : natural range 0 to 1;
    signal mtp_no_valid_almt          : std_logic;
    signal mtp_both_valid_almt        : std_logic;
    signal mtp_err                    : std_logic;

    -- tracking timing
    signal milisecond_tick_gen_count  : natural range 0 to c_ticks_per_ms -1 := c_ticks_per_ms -1;
    signal tracking_ms_counter        : natural range 0 to 255;
    signal tracking_update_due        : std_logic;

begin  -- architecture struct

-------------------------------------------------------------------------------
-- check if chip selects are enabled
-- this only effects reactive stages (i,e, those requiring memory reads)
-------------------------------------------------------------------------------

    process(ctl_cal_byte_lanes)
        variable v_cs_enabled : std_logic;
    begin

        for i in 0 to MEM_IF_NUM_RANKS - 1 loop

            -- check if any bytes enabled
            v_cs_enabled := '0';
            for j in 0 to MEM_IF_DQS_WIDTH - 1 loop
                v_cs_enabled := v_cs_enabled or ctl_cal_byte_lanes(i*MEM_IF_DQS_WIDTH + j);
            end loop;

            -- if any byte enabled set cs as enabled else not
            cal_cs_enabled(i) <= v_cs_enabled;

            -- sanity checking:
            if i = 0 and v_cs_enabled = '0' then
                report ctrl_report_prefix & " disabling of chip select 0 is unsupported by the sequencer," & LF &
                       "-> if this is your intention then please remap CS pins such that CS 0 is not disabled" severity failure;
            end if;

        end loop;

    end process;

-- -----------------------------------------------------------------------------
--  dll lock counter
-- -----------------------------------------------------------------------------

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            dll_lock_counter   <= MEM_IF_DLL_LOCK_COUNT -1;

        elsif rising_edge(clk) then
            if ctl_recalibrate_req = '1' then
                dll_lock_counter <= MEM_IF_DLL_LOCK_COUNT -1;

            elsif dll_lock_counter /= 0 then
                dll_lock_counter <= dll_lock_counter - 1;
            end if;
        end if;
    end process;

-- -----------------------------------------------------------------------------
--  timeout counter : this counter is used to determine if an ack, or done has
--  not been received within the expected number of clock cycles of a req being
--  asserted.
-- -----------------------------------------------------------------------------

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            timeout_counter <= c_done_timeout_count - 1;

        elsif rising_edge(clk) then
          if timeout_counter_clear = '1' then
              timeout_counter <= c_done_timeout_count - 1;

          elsif timeout_counter_enable = '1' and state /= s_init_dram then
              if timeout_counter /= 0 then
                  timeout_counter <= timeout_counter - 1;
              end if;
          end if;
        end if;

    end process;

-- -----------------------------------------------------------------------------
--  register current ctrl signal based on current command
-- -----------------------------------------------------------------------------

    process(clk, rst_n)
    begin
        if rst_n = '0' then

            curr_ctrl <= defaults;
            curr_cmd  <= cmd_idle;

        elsif rising_edge(clk) then

            case curr_active_block(curr_cmd) is
                when admin  => curr_ctrl <= admin_ctrl;
                when dgrb   => curr_ctrl <= dgrb_ctrl;
                when dgwb   => curr_ctrl <= dgwb_ctrl;
                when others => curr_ctrl <= defaults;
            end case;

            curr_cmd <= master_ctrl_op_rec.command;

        end if;

    end process;

-- -----------------------------------------------------------------------------
--  generation of cmd_ack_seen
-- -----------------------------------------------------------------------------

    process (curr_ctrl)
    begin
        cmd_ack_seen <= curr_ctrl.command_ack;
    end process;

-------------------------------------------------------------------------------
-- generation of waiting_for_ack flag (to determine whether ack has timed out)
-------------------------------------------------------------------------------

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            waiting_for_ack <= '0';

        elsif rising_edge(clk) then
            if cmd_req_asserted = '1' then
                waiting_for_ack <= '1';

            elsif cmd_ack_seen = '1' then
                waiting_for_ack <= '0';
            end if;
        end if;

    end process;

-- -----------------------------------------------------------------------------
--  generation of timeout flags
-- -----------------------------------------------------------------------------

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            flag_ack_timeout  <= '0';
            flag_done_timeout <= '0';

        elsif rising_edge(clk) then
            if mmi_ctrl.calibration_start = '1' or ctl_recalibrate_req = '1' then
                flag_ack_timeout <= '0';

            elsif timeout_counter = 0 and waiting_for_ack = '1' then
                flag_ack_timeout <= '1';
            end if;

            if mmi_ctrl.calibration_start = '1' or ctl_recalibrate_req = '1' then
                flag_done_timeout <= '0';

            elsif timeout_counter = 0 and
                  state /= s_rrp_sweep and          -- rrp can take enough cycles to overflow counter so don't timeout
                  state /= s_init_dram and          -- init_dram takes about 200 us, so don't timeout
                  timeout_counter_clear /= '1' then -- check if currently clearing the timeout (i.e. command_done asserted for s_init_dram or s_rrp_sweep)

                flag_done_timeout <= '1';
            end if;
        end if;

    end process;

    -- generation of timeout_counter_stop
    timeout_counter_stop <= curr_ctrl.command_done;

-- -----------------------------------------------------------------------------
--  generation of timeout_counter_enable and timeout_counter_clear
-- -----------------------------------------------------------------------------

    process(clk, rst_n)
    begin
        if rst_n = '0' then

            timeout_counter_enable <= '0';
            timeout_counter_clear  <= '0';

        elsif rising_edge(clk) then
            if cmd_req_asserted = '1' then
                timeout_counter_enable <= '1';
                timeout_counter_clear  <= '0';

            elsif timeout_counter_stop = '1'
               or state = s_operational
               or state = s_non_operational
               or state = s_reset then
                timeout_counter_enable <= '0';
                timeout_counter_clear  <= '1';
            end if;
        end if;

    end process;

-------------------------------------------------------------------------------
-- assignment to ctrl_mmi record
-------------------------------------------------------------------------------

    process (clk, rst_n)
    variable v_ctrl_mmi : t_ctrl_mmi;
    begin
        if rst_n = '0' then

            v_ctrl_mmi             := defaults;
            ctrl_mmi               <= defaults;
            int_ctrl_prev_stage    <= cmd_idle;
            int_ctrl_current_stage <= cmd_idle;

        elsif rising_edge(clk) then

            ctrl_mmi <= v_ctrl_mmi;

            v_ctrl_mmi.ctrl_calibration_success := '0';
            v_ctrl_mmi.ctrl_calibration_fail    := '0';

            if (curr_ctrl.command_ack = '1') then
                case state is
                    when s_init_dram              => v_ctrl_mmi.ctrl_cal_stage_ack_seen.init_dram              := '1';
                    when s_write_btp              => v_ctrl_mmi.ctrl_cal_stage_ack_seen.write_btp              := '1';
                    when s_write_mtp              => v_ctrl_mmi.ctrl_cal_stage_ack_seen.write_mtp              := '1';
                    when s_read_mtp               => v_ctrl_mmi.ctrl_cal_stage_ack_seen.read_mtp               := '1';
                    when s_rrp_reset              => v_ctrl_mmi.ctrl_cal_stage_ack_seen.rrp_reset              := '1';
                    when s_rrp_sweep              => v_ctrl_mmi.ctrl_cal_stage_ack_seen.rrp_sweep              := '1';
                    when s_rrp_seek               => v_ctrl_mmi.ctrl_cal_stage_ack_seen.rrp_seek               := '1';
                    when s_rdv                    => v_ctrl_mmi.ctrl_cal_stage_ack_seen.rdv                    := '1';
                    when s_poa                    => v_ctrl_mmi.ctrl_cal_stage_ack_seen.poa                    := '1';
                    when s_was                    => v_ctrl_mmi.ctrl_cal_stage_ack_seen.was                    := '1';
                    when s_adv_rd_lat             => v_ctrl_mmi.ctrl_cal_stage_ack_seen.adv_rd_lat             := '1';
                    when s_adv_wr_lat             => v_ctrl_mmi.ctrl_cal_stage_ack_seen.adv_wr_lat             := '1';
                    when s_prep_customer_mr_setup => v_ctrl_mmi.ctrl_cal_stage_ack_seen.prep_customer_mr_setup := '1';
                    when s_tracking_setup |
                         s_tracking               => v_ctrl_mmi.ctrl_cal_stage_ack_seen.tracking_setup         := '1';
                    when others => null;
                end case;
            end if;

            -- special 'ack' (actually finished) triggers for phy_initialise, writing iram header info and s_cal
            if state = s_phy_initialise then
                if iram_status.init_done = '1' and dll_lock_counter = 0 then
                    v_ctrl_mmi.ctrl_cal_stage_ack_seen.phy_initialise := '1';
                end if;
            end if;

            if state = s_write_ihi then
                if iram_push_done = '1' then
                    v_ctrl_mmi.ctrl_cal_stage_ack_seen.write_ihi := '1';
                end if;
            end if;

            if state = s_cal and find_dis_bit(state, mmi_ctrl) = '0' then  -- if cal state and calibration not disabled acknowledge
                v_ctrl_mmi.ctrl_cal_stage_ack_seen.cal := '1';
            end if;


            if state = s_operational then
                v_ctrl_mmi.ctrl_calibration_success := '1';
            end if;

            if state = s_non_operational then
                v_ctrl_mmi.ctrl_calibration_fail := '1';
            end if;

            if state /= s_non_operational then
                v_ctrl_mmi.ctrl_current_active_block := master_ctrl_iram_push.active_block;
                v_ctrl_mmi.ctrl_current_stage        := master_ctrl_op_rec.command;
            else
                v_ctrl_mmi.ctrl_current_active_block := v_ctrl_mmi.ctrl_current_active_block;
                v_ctrl_mmi.ctrl_current_stage        := v_ctrl_mmi.ctrl_current_stage;
            end if;

            int_ctrl_prev_stage    <= int_ctrl_current_stage;
            int_ctrl_current_stage <= v_ctrl_mmi.ctrl_current_stage;

            if int_ctrl_prev_stage /= int_ctrl_current_stage then
                v_ctrl_mmi.ctrl_current_stage_done := '0';

            else
                if curr_ctrl.command_done  = '1' then
                    v_ctrl_mmi.ctrl_current_stage_done   := '1';
                end if;
            end if;

            v_ctrl_mmi.master_state_r := last_state;

            if mmi_ctrl.calibration_start = '1' or ctl_recalibrate_req = '1' then
                v_ctrl_mmi := defaults;
                ctrl_mmi   <= defaults;
            end if;

            -- assert error codes here
            if curr_ctrl.command_err = '1' then
                v_ctrl_mmi.ctrl_err_code := curr_ctrl.command_result;
            elsif flag_ack_timeout = '1' then
                v_ctrl_mmi.ctrl_err_code := std_logic_vector(to_unsigned(c_err_ctrl_ack_timeout, v_ctrl_mmi.ctrl_err_code'length));
            elsif flag_done_timeout = '1' then
                v_ctrl_mmi.ctrl_err_code := std_logic_vector(to_unsigned(c_err_ctrl_done_timeout, v_ctrl_mmi.ctrl_err_code'length));
            elsif mtp_err = '1' then
                if mtp_no_valid_almt = '1' then
                    v_ctrl_mmi.ctrl_err_code := std_logic_vector(to_unsigned(C_ERR_READ_MTP_NO_VALID_ALMT, v_ctrl_mmi.ctrl_err_code'length));
                elsif mtp_both_valid_almt = '1' then
                    v_ctrl_mmi.ctrl_err_code := std_logic_vector(to_unsigned(C_ERR_READ_MTP_BOTH_ALMT_PASS, v_ctrl_mmi.ctrl_err_code'length));
                end if;
            end if;

        end if;

    end process;

    -- check if iram finished init
    process(iram_status)
    begin
        if GENERATE_ADDITIONAL_DBG_RTL = 0 then
            iram_init_complete <= '1';
        else
            iram_init_complete <= iram_status.init_done;
        end if;
    end process;

-- -----------------------------------------------------------------------------
--  master state machine
--  (this controls the operation of the entire sequencer)
--  the states are summarised as follows:
--     s_reset
--     s_phy_initialise          - wait for dll lock and init done flag from iram
--     s_init_dram,              -- dram initialisation - reset sequence
--     s_prog_cal_mr,            -- dram initialisation - programming mode registers (once per chip select)
--     s_write_ihi               - write header information in iRAM
--     s_cal                     - check if calibration to be executed
--     s_write_btp               - write burst training pattern
--     s_write_mtp               - write more training pattern
--     s_rrp_reset               - read resync phase setup - reset initial conditions
--     s_rrp_sweep               - read resync phase setup - sweep phases per chip select
--     s_read_mtp                - read training patterns to find correct alignment for 1100 burst
--                                 (this is a special case of s_rrp_seek with no resych phase setting)
--     s_rrp_seek                - read resync phase setup - seek correct alignment
--     s_rdv                     - read data valid setup
--     s_poa                     - calibrate the postamble
--     s_was                     - write datapath setup (ac to write data timing)
--     s_adv_rd_lat              - advertise read latency
--     s_adv_wr_lat              - advertise write latency
--     s_tracking_setup          - perform tracking (1st pass to setup mimic window)
--     s_prep_customer_mr_setup  - apply user mode register settings (in admin block)
--     s_tracking                - perform tracking (subsequent passes in user mode)
--     s_operational             - calibration successful and in user mode
--     s_non_operational         - calibration unsuccessful and in user mode
-- -----------------------------------------------------------------------------

    process(clk, rst_n)
        variable v_seen_ack : boolean;
        variable v_dis      : std_logic; -- disable bit
    begin
        if rst_n = '0' then

            state                <= s_reset;
            last_state           <= s_reset;
            int_ctl_init_success <= '0';
            int_ctl_init_fail    <= '0';
            v_seen_ack           := false;
            hold_state           <= '0';
            cs_counter           <= 0;
            mtp_almts_checked    <= 0;
            ac_nt                <= (others => '1');
            ac_nt_almts_checked  <= 0;
            reissue_cmd_req      <= '0';

            dis_state            <= '0';

        elsif rising_edge(clk) then
            last_state           <= state;

            -- check if state_tx required
            if curr_ctrl.command_ack = '1' then
                v_seen_ack := true;
            end if;

            -- find disable bit for current state (do once to avoid exit mid-state)
            if state /= last_state then
                dis_state <= find_dis_bit(state, mmi_ctrl);
            end if;

            -- Set special conditions:

            if state = s_reset or
               state = s_operational or
               state = s_non_operational then
                dis_state <= '1';
            end if;

            -- override to ensure execution of next state logic
            if (state = s_cal) then
                dis_state <= '1';
            end if;

            -- if header writing in iram check finished
            if (state = s_write_ihi) then
                if iram_push_done = '1' or mmi_ctrl.hl_css.write_ihi_dis = '1' then
                    dis_state <= '1';
                else
                    dis_state <= '0';
                end if;
            end if;

            -- Special condition for initialisation
            if (state = s_phy_initialise) then
                if ((dll_lock_counter = 0) and (iram_init_complete = '1')) or
                   (mmi_ctrl.hl_css.phy_initialise_dis = '1') then
                    dis_state <= '1';
                else
                    dis_state <= '0';
                end if;
            end if;

            if dis_state = '1' then
                v_seen_ack := false;
            elsif curr_ctrl.command_done = '1' then
                if v_seen_ack = false then
                    report ctrl_report_prefix & "have not seen ack but have seen command done from " & t_ctrl_active_block'image(curr_active_block(master_ctrl_op_rec.command)) & "_block in state " & t_master_sm_state'image(state) severity warning;
                end if;
                v_seen_ack := false;
            end if;

            -- default do not reissue command request
            reissue_cmd_req <= '0';

            if (hold_state = '1') then
                hold_state <= '0';
            else
                if ((dis_state = '1') or
                   (curr_ctrl.command_done = '1') or
                   ((cal_cs_enabled(cs_counter) = '0') and (mcs_rw_state(state) = True))) then  -- current chip select is disabled and read/write

                    hold_state <= '1';

                    -- Only reset the below if making state change
                    int_ctl_init_success <= '0';
                    int_ctl_init_fail    <= '0';

                    -- default chip select counter gets reset to zero
                    cs_counter <= 0;

                    case state is
                        when s_reset =>                  state               <= s_phy_initialise;
                                                         ac_nt               <= (others => '1');
                                                         mtp_almts_checked   <= 0;
                                                         ac_nt_almts_checked <= 0;

                        when s_phy_initialise =>         state      <= s_init_dram;

                        when s_init_dram =>              state <= s_prog_cal_mr;

                        when s_prog_cal_mr =>            if cs_counter = MEM_IF_NUM_RANKS - 1 then

                                                             -- if no debug interface don't write iram header
                                                             if GENERATE_ADDITIONAL_DBG_RTL = 1 then
                                                                 state <= s_write_ihi;
                                                             else
                                                                 state <= s_cal;
                                                             end if;

                                                         else

                                                             cs_counter      <= cs_counter + 1;
                                                             reissue_cmd_req <= '1';

                                                         end if;

                        when s_write_ihi =>              state <= s_cal;

                        when s_cal =>                    if mmi_ctrl.hl_css.cal_dis = '0' then
                                                             state <= s_write_btp;
                                                         else
                                                             state <= s_tracking_setup;
                                                         end if;

                                                         -- always enter s_cal before calibration so reset some variables here
                                                         mtp_almts_checked   <= 0;
                                                         ac_nt_almts_checked <= 0;

                        when s_write_btp =>              if cs_counter = MEM_IF_NUM_RANKS-1 or
                                                            SIM_TIME_REDUCTIONS = 2 then

                                                             state      <= s_write_mtp;

                                                         else
                                                             cs_counter <= cs_counter + 1;

                                                             -- only reissue command if current chip select enabled
                                                             if cal_cs_enabled(cs_counter + 1) = '1' then
                                                                reissue_cmd_req <= '1';
                                                             end if;

                                                         end if;

                        when s_write_mtp =>              if cs_counter = MEM_IF_NUM_RANKS - 1 or
                                                            SIM_TIME_REDUCTIONS = 2 then

                                                             if SIM_TIME_REDUCTIONS = 1 then
                                                                 state      <= s_rdv;
                                                             else
                                                                 state      <= s_rrp_reset;
                                                             end if;

                                                         else
                                                             cs_counter      <= cs_counter + 1;

                                                             -- only reissue command if current chip select enabled
                                                             if cal_cs_enabled(cs_counter + 1) = '1' then
                                                                reissue_cmd_req <= '1';
                                                             end if;

                                                         end if;

                        when s_rrp_reset =>              state      <= s_rrp_sweep;

                        when s_rrp_sweep =>              if cs_counter = MEM_IF_NUM_RANKS - 1 or
                                                            mtp_almts_checked /= 2 or
                                                            SIM_TIME_REDUCTIONS = 2 then

                                                             if mtp_almts_checked /= 2 then
                                                                 state <= s_read_mtp;
                                                             else
                                                                 state <= s_rrp_seek;
                                                             end if;

                                                         else
                                                             cs_counter      <= cs_counter + 1;

                                                             -- only reissue command if current chip select enabled
                                                             if cal_cs_enabled(cs_counter + 1) = '1' then
                                                                reissue_cmd_req <= '1';
                                                             end if;

                                                         end if;

                        when s_read_mtp =>               if mtp_almts_checked /= 2 then
                                                             mtp_almts_checked <= mtp_almts_checked + 1;
                                                         end if;
                                                         state      <= s_rrp_reset;

                        when s_rrp_seek =>               state      <= s_rdv;

                        when s_rdv =>                    state <= s_was;
                        when s_was =>                    state <= s_adv_rd_lat;
                        when s_adv_rd_lat =>             state <= s_adv_wr_lat;

                        when s_adv_wr_lat =>             if dgrb_ctrl_ac_nt_good = '1' then
                                                             state <= s_poa;
                                                         else
                                                             if ac_nt_almts_checked = (DWIDTH_RATIO/2 - 1) then
                                                                 state <= s_non_operational;
                                                             else
                                                                 -- switch alignment and restart calibration
                                                                 ac_nt               <= std_logic_vector(unsigned(ac_nt) + 1);
                                                                 ac_nt_almts_checked <= ac_nt_almts_checked + 1;

                                                                if SIM_TIME_REDUCTIONS = 1 then
                                                                    state               <= s_rdv;
                                                                else
                                                                    state               <= s_rrp_reset;
                                                                end if;

                                                                mtp_almts_checked   <= 0;
                                                             end if;
                                                         end if;

                        when s_poa =>                    state <= s_tracking_setup;

                        when s_tracking_setup =>         state      <= s_prep_customer_mr_setup;

                        when s_prep_customer_mr_setup => if cs_counter = MEM_IF_NUM_RANKS - 1 then  -- s_prep_customer_mr_setup is always performed over all cs
                                                             state      <= s_operational;
                                                         else
                                                             cs_counter      <= cs_counter + 1;
                                                             reissue_cmd_req <= '1';
                                                         end if;

                        when s_tracking =>               state                <= s_operational;
                                                         int_ctl_init_success <= int_ctl_init_success;
                                                         int_ctl_init_fail    <= int_ctl_init_fail;

                        when s_operational =>            int_ctl_init_success <= '1';
                                                         int_ctl_init_fail    <= '0';
                                                         hold_state           <= '0';
                                                         if tracking_update_due = '1' and mmi_ctrl.hl_css.tracking_dis = '0' then
                                                             state      <= s_tracking;
                                                             hold_state <= '1';
                                                         end if;

                        when s_non_operational =>        int_ctl_init_success <= '0';
                                                         int_ctl_init_fail    <= '1';
                                                         hold_state           <= '0';
                                                         if last_state /= s_non_operational then -- print a warning on entering this state
                                                             report ctrl_report_prefix & "memory calibration has failed (output from ctrl block)" severity WARNING;
                                                         end if;

                        when others =>                   state <= t_master_sm_state'succ(state);
                    end case;
                end if;
            end if;

        if   flag_done_timeout = '1'            -- no done signal from current active block
          or flag_ack_timeout = '1'             -- or no ack signal from current active block
          or curr_ctrl.command_err = '1'         -- or an error from current active block
          or mtp_err = '1' then                  -- or an error due to mtp alignment
            state <= s_non_operational;
        end if;

        if mmi_ctrl.calibration_start = '1' then  -- restart calibration process
            state <= s_cal;
        end if;

        if ctl_recalibrate_req = '1' then  -- restart all incl. initialisation
            state <= s_reset;
        end if;

      end if;

    end process;

    -- generate output calibration fail/success signals
    process(clk, rst_n)
    begin
        if rst_n = '0' then

            ctl_init_fail    <= '0';
            ctl_init_success <= '0';

        elsif rising_edge(clk) then

            ctl_init_fail    <= int_ctl_init_fail;
            ctl_init_success <= int_ctl_init_success;

        end if;
    end process;

    -- assign ac_nt to the output int_ac_nt
    process(ac_nt)
    begin
        int_ac_nt <= ac_nt;
    end process;

-- ------------------------------------------------------------------------------
-- find correct mtp_almt from returned data
-- ------------------------------------------------------------------------------

    mtp_almt: block

        signal dvw_size_a0 : natural range 0 to 255;  -- maximum size of command result
        signal dvw_size_a1 : natural range 0 to 255;

    begin

        process (clk, rst_n)

            variable v_dvw_a0_small : boolean;
            variable v_dvw_a1_small : boolean;

        begin
            if rst_n = '0' then

               mtp_correct_almt    <= 0;
               dvw_size_a0         <= 0;
               dvw_size_a1         <= 0;
               mtp_no_valid_almt   <= '0';
               mtp_both_valid_almt <= '0';
               mtp_err             <= '0';

            elsif rising_edge(clk) then

                -- update the dvw sizes
                if state = s_read_mtp then
                    if curr_ctrl.command_done = '1' then
                        if mtp_almts_checked = 0 then
                            dvw_size_a0 <= to_integer(unsigned(curr_ctrl.command_result));
                        else
                            dvw_size_a1 <= to_integer(unsigned(curr_ctrl.command_result));
                        end if;
                    end if;
                end if;

                -- check dvw size and set mtp almt
                if dvw_size_a0 < dvw_size_a1 then
                    mtp_correct_almt <= 1;
                else
                    mtp_correct_almt <= 0;
                end if;

                -- error conditions
                if mtp_almts_checked = 2 and GENERATE_ADDITIONAL_DBG_RTL = 1 then  -- if finished alignment checking (and GENERATE_ADDITIONAL_DBG_RTL set)

                    -- perform size checks once per dvw
                    if dvw_size_a0 < 3 then
                        v_dvw_a0_small := true;
                    else
                        v_dvw_a0_small := false;
                    end if;

                    if dvw_size_a1 < 3 then
                        v_dvw_a1_small := true;
                    else
                        v_dvw_a1_small := false;
                    end if;

                    if v_dvw_a0_small = true and v_dvw_a1_small = true then
                        mtp_no_valid_almt   <= '1';
                        mtp_err             <= '1';
                    end if;

                    if v_dvw_a0_small = false and v_dvw_a1_small = false then
                        mtp_both_valid_almt <= '1';
                        mtp_err             <= '1';
                    end if;

                else

                    mtp_no_valid_almt   <= '0';
                    mtp_both_valid_almt <= '0';
                    mtp_err             <= '0';

                end if;

            end if;

        end process;

    end block;

-- ------------------------------------------------------------------------------
-- process to generate command outputs, based on state, last_state and mmi_ctrl.
-- asynchronously
-- ------------------------------------------------------------------------------

    process (state, last_state, mmi_ctrl, reissue_cmd_req, cs_counter, mtp_almts_checked, mtp_correct_almt)
    begin
        master_ctrl_op_rec         <= defaults;
        master_ctrl_iram_push      <= defaults;

        case state is

            -- special condition states
            when s_reset | s_phy_initialise | s_cal =>
                null;

            when s_write_ihi =>
                if mmi_ctrl.hl_css.write_ihi_dis = '0' then
                    master_ctrl_op_rec.command <= find_cmd(state);
                    if state /= last_state then
                        master_ctrl_op_rec.command_req <= '1';
                    end if;
                end if;

            when s_operational | s_non_operational =>
                master_ctrl_op_rec.command <= find_cmd(state);

            when others =>  -- default condition for most states
                if find_dis_bit(state, mmi_ctrl) = '0' then
                    master_ctrl_op_rec.command <= find_cmd(state);
                    if state /= last_state or reissue_cmd_req = '1' then
                        master_ctrl_op_rec.command_req <= '1';
                    end if;
                else
                    if state = last_state then  -- safe state exit if state disabled mid-calibration
                        master_ctrl_op_rec.command <= find_cmd(state);
                    end if;
                end if;

        end case;

        -- for multiple chip select commands assign operand to cs_counter
        master_ctrl_op_rec.command_op            <= defaults;
        master_ctrl_op_rec.command_op.current_cs <= cs_counter;
        if state = s_rrp_sweep or state = s_read_mtp or state = s_poa then
           if mtp_almts_checked /= 2 or SIM_TIME_REDUCTIONS = 2 then
               master_ctrl_op_rec.command_op.single_bit <= '1';
           end if;
           if mtp_almts_checked /= 2 then
               master_ctrl_op_rec.command_op.mtp_almt <= mtp_almts_checked;
           else
               master_ctrl_op_rec.command_op.mtp_almt <= mtp_correct_almt;
           end if;
        end if;

        -- set write mode and packing mode for iram
        if GENERATE_ADDITIONAL_DBG_RTL = 1 then

            case state is
                when s_rrp_sweep =>
                    master_ctrl_iram_push.write_mode   <= overwrite_ram;
                    master_ctrl_iram_push.packing_mode <= dq_bitwise;

                when s_rrp_seek |
                     s_read_mtp =>

                    master_ctrl_iram_push.write_mode   <= overwrite_ram;
                    master_ctrl_iram_push.packing_mode <= dq_wordwise;

                when others =>

                    null;

            end case;
        end if;

        -- set current active block
        master_ctrl_iram_push.active_block <= curr_active_block(find_cmd(state));

    end process;

    -- some concurc_read_burst_trent assignments to outputs
    process (master_ctrl_iram_push, master_ctrl_op_rec)
    begin
        ctrl_iram_push      <= master_ctrl_iram_push;
        ctrl_op_rec         <= master_ctrl_op_rec;
        cmd_req_asserted    <= master_ctrl_op_rec.command_req;
    end process;

-- -----------------------------------------------------------------------------
--  tracking interval counter
-- -----------------------------------------------------------------------------
    process(clk, rst_n)
    begin
       if rst_n = '0' then
           milisecond_tick_gen_count <= c_ticks_per_ms -1;
           tracking_ms_counter       <= 0;
           tracking_update_due       <= '0';

       elsif rising_edge(clk) then
           if state = s_operational and last_state/= s_operational then

               if mmi_ctrl.tracking_orvd_to_10ms = '1' then
                   milisecond_tick_gen_count <= c_ticks_per_10us -1;
               else
                   milisecond_tick_gen_count <= c_ticks_per_ms -1;
               end if;

               tracking_ms_counter <= mmi_ctrl.tracking_period_ms;

           elsif state = s_operational then
               if milisecond_tick_gen_count = 0  and tracking_update_due /= '1' then

                   if tracking_ms_counter = 0 then
                       tracking_update_due <= '1';
                   else
                       tracking_ms_counter <= tracking_ms_counter -1;
                   end if;

                   if mmi_ctrl.tracking_orvd_to_10ms = '1' then
                       milisecond_tick_gen_count <= c_ticks_per_10us -1;
                   else
                       milisecond_tick_gen_count <= c_ticks_per_ms -1;
                   end if;

                elsif milisecond_tick_gen_count /= 0 then
                   milisecond_tick_gen_count <= milisecond_tick_gen_count -1;
                end if;

           else

               tracking_update_due <= '0';
           end if;
       end if;

    end process;

end architecture struct;
--

-- -----------------------------------------------------------------------------
--  Abstract        : top level for the non-levelling AFI PHY sequencer
--                    The top level instances the sub-blocks of the AFI PHY
--                    sequencer. In addition a number of multiplexing and high-
--                    level control operations are performed. This includes the
--                    multiplexing and generation of control signals for: the
--                    address and command DRAM interface and pll, oct and datapath
--                    latency control signals.
-- -----------------------------------------------------------------------------

--altera message_off 10036

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
entity ddr3_int_phy_alt_mem_phy_seq IS
    generic (
        -- choice of FPGA device family and DRAM type
        FAMILY                         : string;
        MEM_IF_MEMTYPE                 : string;
        SPEED_GRADE                    : string;
        FAMILYGROUP_ID                 : natural;

        -- physical interface width definitions
        MEM_IF_DQS_WIDTH               : natural;
        MEM_IF_DWIDTH                  : natural;
        MEM_IF_DM_WIDTH                : natural;
        MEM_IF_DQ_PER_DQS              : natural;
        DWIDTH_RATIO                   : natural;
        CLOCK_INDEX_WIDTH              : natural;
        MEM_IF_CLK_PAIR_COUNT          : natural;
        MEM_IF_ADDR_WIDTH              : natural;
        MEM_IF_BANKADDR_WIDTH          : natural;
        MEM_IF_CS_WIDTH                : natural;
        MEM_IF_NUM_RANKS               : natural;
        MEM_IF_RANKS_PER_SLOT          : natural;
        ADV_LAT_WIDTH                  : natural;
        RESYNCHRONISE_AVALON_DBG       : natural;  -- 0 = false, 1 = true
        AV_IF_ADDR_WIDTH               : natural;

        -- Not used for non-levelled seq
        CHIP_OR_DIMM                    : string;
        RDIMM_CONFIG_BITS               : string;

        -- setup / algorithm information
        NOM_DQS_PHASE_SETTING          : natural;
        SCAN_CLK_DIVIDE_BY             : natural;
        RDP_ADDR_WIDTH                 : natural;
        PLL_STEPS_PER_CYCLE            : natural;
        IOE_PHASES_PER_TCK             : natural;
        IOE_DELAYS_PER_PHS             : natural;
        MEM_IF_CLK_PS                  : natural;

        WRITE_DESKEW_T10               : natural;
        WRITE_DESKEW_HC_T10            : natural;
        WRITE_DESKEW_T9NI              : natural;
        WRITE_DESKEW_HC_T9NI           : natural;
        WRITE_DESKEW_T9I               : natural;
        WRITE_DESKEW_HC_T9I            : natural;
        WRITE_DESKEW_RANGE             : natural;

        -- initial mode register settings
        PHY_DEF_MR_1ST                 : natural;
        PHY_DEF_MR_2ND                 : natural;
        PHY_DEF_MR_3RD                 : natural;
        PHY_DEF_MR_4TH                 : natural;

        MEM_IF_DQSN_EN                 : natural;      -- default off for Cyclone-III
        MEM_IF_DQS_CAPTURE_EN          : natural;

        GENERATE_ADDITIONAL_DBG_RTL    : natural;      -- 1 signals to include iram and mmi blocks and 0 not to include

        SINGLE_DQS_DELAY_CONTROL_CODE  : natural;      -- reserved for future use
        PRESET_RLAT                    : natural;      -- reserved for future use
        EN_OCT                         : natural;      -- Does the sequencer use OCT during calibration.
        OCT_LAT_WIDTH                  : natural;
        SIM_TIME_REDUCTIONS            : natural;      -- if 0 null, if 2 rrp for 1 dqs group and 1 cs
        FORCE_HC                       : natural;      -- Use to force HardCopy in simulation.
        CAPABILITIES                   : natural;       -- advertise capabilities i.e. which ctrl block states to execute (default all on)
        TINIT_TCK                      : natural;
        TINIT_RST                      : natural;
        GENERATE_TRACKING_PHASE_STORE  : natural;      -- reserved for future use
        IP_BUILDNUM                    : natural
    );
    port (
        -- clk / reset
        clk                            : in    std_logic;
        rst_n                          : in    std_logic;

        -- calibration status and prompt
        ctl_init_success               : out   std_logic;
        ctl_init_fail                  : out   std_logic;
        ctl_init_warning               : out   std_logic;  -- unused
        ctl_recalibrate_req            : in    std_logic;

        -- the following two signals are reserved for future use
        mem_ac_swapped_ranks           : in    std_logic_vector(MEM_IF_NUM_RANKS                         - 1  downto 0);
        ctl_cal_byte_lanes             : in    std_logic_vector(MEM_IF_NUM_RANKS * MEM_IF_DQS_WIDTH      - 1 downto 0);

        -- pll reconfiguration
        seq_pll_inc_dec_n              : out   std_logic;
        seq_pll_start_reconfig         : out   std_logic;
        seq_pll_select                 : out   std_logic_vector(CLOCK_INDEX_WIDTH                        - 1 downto 0);
        seq_pll_phs_shift_busy         : in    std_logic;
        pll_resync_clk_index           : in    std_logic_vector(CLOCK_INDEX_WIDTH                        - 1 downto 0); -- PLL phase used to select resync clock
        pll_measure_clk_index          : in    std_logic_vector(CLOCK_INDEX_WIDTH                        - 1 downto 0); -- PLL phase used to select mimic/measure clock


        -- scanchain associated signals (reserved for future use)
        seq_scan_clk                   : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_scan_enable_dqs_config     : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_scan_update                : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_scan_din                   : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_scan_enable_ck             : out   std_logic_vector(MEM_IF_CLK_PAIR_COUNT                    - 1 downto 0);
        seq_scan_enable_dqs            : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_scan_enable_dqsn           : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_scan_enable_dq             : out   std_logic_vector(MEM_IF_DWIDTH                            - 1 downto 0);
        seq_scan_enable_dm             : out   std_logic_vector(MEM_IF_DM_WIDTH                          - 1 downto 0);
        hr_rsc_clk                     : in    std_logic;

        -- address / command interface (note these are mapped internally to the seq_ac record)
        seq_ac_addr                    : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_ADDR_WIDTH     - 1 downto 0);
        seq_ac_ba                      : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_BANKADDR_WIDTH - 1 downto 0);
        seq_ac_cas_n                   : out   std_logic_vector((DWIDTH_RATIO/2)                         - 1 downto 0);
        seq_ac_ras_n                   : out   std_logic_vector((DWIDTH_RATIO/2)                         - 1 downto 0);
        seq_ac_we_n                    : out   std_logic_vector((DWIDTH_RATIO/2)                         - 1 downto 0);
        seq_ac_cke                     : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_NUM_RANKS      - 1 downto 0);
        seq_ac_cs_n                    : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_NUM_RANKS      - 1 downto 0);
        seq_ac_odt                     : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_NUM_RANKS      - 1 downto 0);
        seq_ac_rst_n                   : out   std_logic_vector((DWIDTH_RATIO/2)                         - 1 downto 0);
        seq_ac_sel                     : out   std_logic;
        seq_mem_clk_disable            : out   std_logic;

        -- additional datapath latency (reserved for future use)
        seq_ac_add_1t_ac_lat_internal  : out   std_logic;
        seq_ac_add_1t_odt_lat_internal : out   std_logic;
        seq_ac_add_2t                  : out   std_logic;

        -- read datapath interface
        seq_rdp_reset_req_n            : out   std_logic;
        seq_rdp_inc_read_lat_1x        : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_rdp_dec_read_lat_1x        : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        rdata                          : in    std_logic_vector( DWIDTH_RATIO    * MEM_IF_DWIDTH         - 1 downto 0);

        -- read data valid (associated signals) interface
        seq_rdv_doing_rd               : out   std_logic_vector(MEM_IF_DQS_WIDTH * DWIDTH_RATIO/2        - 1 downto 0);
        rdata_valid                    : in    std_logic_vector( DWIDTH_RATIO/2                          - 1 downto 0);
        seq_rdata_valid_lat_inc        : out   std_logic;
        seq_rdata_valid_lat_dec        : out   std_logic;
        seq_ctl_rlat                   : out   std_logic_vector(ADV_LAT_WIDTH                            - 1 downto 0);

        -- postamble interface (unused for Cyclone-III)
        seq_poa_lat_dec_1x             : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_poa_lat_inc_1x             : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_poa_protection_override_1x : out   std_logic;

        -- OCT path control
        seq_oct_oct_delay              : out   std_logic_vector(OCT_LAT_WIDTH - 1 downto 0);
        seq_oct_oct_extend             : out   std_logic_vector(OCT_LAT_WIDTH - 1 downto 0);
        seq_oct_value                  : out   std_logic;

        -- write data path interface
        seq_wdp_dqs_burst              : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_DQS_WIDTH      - 1 downto 0);
        seq_wdp_wdata_valid            : out   std_logic_vector((DWIDTH_RATIO/2) * MEM_IF_DQS_WIDTH      - 1 downto 0);
        seq_wdp_wdata                  : out   std_logic_vector( DWIDTH_RATIO    * MEM_IF_DWIDTH         - 1 downto 0);
        seq_wdp_dm                     : out   std_logic_vector( DWIDTH_RATIO    * MEM_IF_DM_WIDTH       - 1 downto 0);
        seq_wdp_dqs                    : out   std_logic_vector( DWIDTH_RATIO                            - 1 downto 0);
        seq_wdp_ovride                 : out   std_logic;
        seq_dqs_add_2t_delay           : out   std_logic_vector(MEM_IF_DQS_WIDTH                         - 1 downto 0);
        seq_ctl_wlat                   : out   std_logic_vector(ADV_LAT_WIDTH                            - 1 downto 0);

        -- mimic path interface
        seq_mmc_start                  : out   std_logic;
        mmc_seq_done                   : in    std_logic;
        mmc_seq_value                  : in    std_logic;

        -- parity signals (not used for non-levelled PHY)
        mem_err_out_n                  : in    std_logic;
        parity_error_n                 : out   std_logic;

        --synchronous Avalon debug interface  (internally re-synchronised to input clock (a generic option))
        dbg_seq_clk                    : in    std_logic;
        dbg_seq_rst_n                  : in    std_logic;
        dbg_seq_addr                   : in    std_logic_vector(AV_IF_ADDR_WIDTH                         - 1 downto 0);
        dbg_seq_wr                     : in    std_logic;
        dbg_seq_rd                     : in    std_logic;
        dbg_seq_cs                     : in    std_logic;
        dbg_seq_wr_data                : in    std_logic_vector(31                                           downto 0);
        seq_dbg_rd_data                : out   std_logic_vector(31                                           downto 0);
        seq_dbg_waitrequest            : out   std_logic
    );
end entity;

library work;

-- The record package (alt_mem_phy_record_pkg) is used to combine command and status signals
-- (into records) to be passed between sequencer blocks. It also contains type and record definitions
-- for the stages of DRAM memory calibration.
--
use work.ddr3_int_phy_alt_mem_phy_record_pkg.all;

-- The registers package (alt_mem_phy_regs_pkg) is used to combine the definition of the
-- registers for the mmi status registers and functions/procedures applied to the registers
--
use work.ddr3_int_phy_alt_mem_phy_regs_pkg.all;

-- The constant package (alt_mem_phy_constants_pkg) contains global 'constants' which are fixed
-- thoughout the sequencer and will not change (for constants which may change between sequencer
-- instances generics are used)
--
use work.ddr3_int_phy_alt_mem_phy_constants_pkg.all;

-- The iram address package (alt_mem_phy_iram_addr_pkg) is used to define the base addresses used
-- for iram writes during calibration
--
use work.ddr3_int_phy_alt_mem_phy_iram_addr_pkg.all;

-- The address and command package (alt_mem_phy_addr_cmd_pkg) is used to combine DRAM address
-- and command signals in one record and unify the functions operating on this record.
--
use work.ddr3_int_phy_alt_mem_phy_addr_cmd_pkg.all;


-- Individually include each of library files for the sub-blocks of the sequencer:
--
use work.ddr3_int_phy_alt_mem_phy_admin;
--
use work.ddr3_int_phy_alt_mem_phy_mmi;
--
use work.ddr3_int_phy_alt_mem_phy_iram;
--
use work.ddr3_int_phy_alt_mem_phy_dgrb;
--
use work.ddr3_int_phy_alt_mem_phy_dgwb;
--
use work.ddr3_int_phy_alt_mem_phy_ctrl;

--
architecture struct of ddr3_int_phy_alt_mem_phy_seq IS

    attribute altera_attribute : string;
    attribute altera_attribute of struct : architecture is "-name MESSAGE_DISABLE 18010";

    -- debug signals (similar to those seen in the Quartus v8.0 DDR/DDR2 sequencer)
    signal rsu_multiple_valid_latencies_err : std_logic;                                     -- true if >2 valid latency values are detected
    signal rsu_grt_one_dvw_err              : std_logic;                                     -- true if >1 data valid window is detected
    signal rsu_no_dvw_err                   : std_logic;                                     -- true if no data valid window is detected
    signal rsu_codvw_phase                  : std_logic_vector(11                downto 0);  -- set to the phase of the DVW detected if calibration is successful
    signal rsu_codvw_size                   : std_logic_vector(11                downto 0);  -- set to the phase of the DVW detected if calibration is successful
    signal rsu_read_latency                 : std_logic_vector(ADV_LAT_WIDTH - 1 downto 0);   -- set to the correct read latency if calibration is successful

    -- outputs from the dgrb to generate the above rsu_codvw_* signals and report status to the mmi
    signal dgrb_mmi                         : t_dgrb_mmi;

    -- admin to mmi interface
    signal regs_admin_ctrl_rec            : t_admin_ctrl;  -- mmi register settings information
    signal admin_regs_status_rec          : t_admin_stat;  -- admin status information

    -- odt enable from the admin block based on mr settings
    signal enable_odt                     : std_logic;

    -- iram status information (sent to the ctrl block)
    signal iram_status                    : t_iram_stat;

    -- dgrb iram write interface
    signal dgrb_iram                      : t_iram_push;

    -- ctrl to iram interface
    signal ctrl_idib_top                  : natural;              -- current write location in the iram
    signal ctrl_active_block              : t_ctrl_active_block;
    signal ctrl_iram_push                 : t_ctrl_iram;
    signal iram_push_done                 : std_logic;
    signal ctrl_iram_ihi_write            : std_logic;

    -- local copies of calibration status
    signal ctl_init_success_int           : std_logic;
    signal ctl_init_fail_int              : std_logic;

    -- refresh period failure flag
    signal trefi_failure                  : std_logic;

    -- unified ctrl signal broadcast to all blocks from the ctrl block
    signal ctrl_broadcast                 : t_ctrl_command;

    -- standardised status report per block to control block
    signal admin_ctrl                     : t_ctrl_stat;
    signal dgwb_ctrl                      : t_ctrl_stat;
    signal dgrb_ctrl                      : t_ctrl_stat;

    -- mmi and ctrl block interface
    signal mmi_ctrl                       : t_mmi_ctrl;
    signal ctrl_mmi                       : t_ctrl_mmi;

    -- write datapath override signals
    signal dgwb_wdp_override              : std_logic;
    signal dgrb_wdp_override              : std_logic;

    -- address/command access request and grant between the dgrb/dgwb blocks and the admin block
    signal dgb_ac_access_gnt              : std_logic;
    signal dgb_ac_access_gnt_r            : std_logic;
    signal dgb_ac_access_req              : std_logic;
    signal dgwb_ac_access_req             : std_logic;
    signal dgrb_ac_access_req             : std_logic;

    -- per block address/command record (multiplexed in this entity)
    signal admin_ac                       : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);
    signal dgwb_ac                        : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);
    signal dgrb_ac                        : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);

    -- doing read signal
    signal seq_rdv_doing_rd_int           : std_logic_vector(seq_rdv_doing_rd'range);

    -- local copy of interface to inc/dec latency on rdata_valid and postamble
    signal seq_rdata_valid_lat_dec_int    : std_logic;
    signal seq_rdata_valid_lat_inc_int    : std_logic;
    signal seq_poa_lat_inc_1x_int         : std_logic_vector(MEM_IF_DQS_WIDTH -1 downto 0);
    signal seq_poa_lat_dec_1x_int         : std_logic_vector(MEM_IF_DQS_WIDTH -1 downto 0);

    -- local copy of write/read latency
    signal seq_ctl_wlat_int               : std_logic_vector(seq_ctl_wlat'range);
    signal seq_ctl_rlat_int               : std_logic_vector(seq_ctl_rlat'range);

    -- parameterisation of dgrb / dgwb / admin blocks from mmi register settings
    signal parameterisation_rec           : t_algm_paramaterisation;

    -- PLL reconfig
    signal seq_pll_phs_shift_busy_r       : std_logic;
    signal seq_pll_phs_shift_busy_ccd     : std_logic;
    signal dgrb_pll_inc_dec_n             : std_logic;
    signal dgrb_pll_start_reconfig        : std_logic;
    signal dgrb_pll_select                : std_logic_vector(CLOCK_INDEX_WIDTH - 1 downto 0);
    signal dgrb_phs_shft_busy             : std_logic;
    signal mmi_pll_inc_dec_n              : std_logic;
    signal mmi_pll_start_reconfig         : std_logic;
    signal mmi_pll_select                 : std_logic_vector(CLOCK_INDEX_WIDTH - 1 downto 0);
    signal pll_mmi                        : t_pll_mmi;
    signal mmi_pll                        : t_mmi_pll_reconfig;


    -- address and command 1t setting (unused for Full Rate)
    signal int_ac_nt                      : std_logic_vector(((DWIDTH_RATIO+2)/4) - 1 downto 0);
    signal dgrb_ctrl_ac_nt_good           : std_logic;

    -- the following signals are reserved for future use
    signal ctl_cal_byte_lanes_r           : std_logic_vector(ctl_cal_byte_lanes'range);
    signal mmi_setup                      : t_ctrl_cmd_id;
    signal dgwb_iram                      : t_iram_push;

    -- track number of poa / rdv adjustments (reporting only)
    signal poa_adjustments                : natural;
    signal rdv_adjustments                : natural;

    -- convert input generics from natural to std_logic_vector
    constant c_phy_def_mr_1st_sl_vector   : std_logic_vector(15 downto 0)   := std_logic_vector(to_unsigned(PHY_DEF_MR_1ST, 16));
    constant c_phy_def_mr_2nd_sl_vector   : std_logic_vector(15 downto 0)   := std_logic_vector(to_unsigned(PHY_DEF_MR_2ND, 16));
    constant c_phy_def_mr_3rd_sl_vector   : std_logic_vector(15 downto 0)   := std_logic_vector(to_unsigned(PHY_DEF_MR_3RD, 16));
    constant c_phy_def_mr_4th_sl_vector   : std_logic_vector(15 downto 0)   := std_logic_vector(to_unsigned(PHY_DEF_MR_4TH, 16));

    -- overrride on capabilities to speed up simulation time
    function capabilities_override(capabilities        : natural;
                                   sim_time_reductions : natural) return natural is
    begin
        if sim_time_reductions = 1 then
            return 2**c_hl_css_reg_cal_dis_bit; -- disable calibration completely
        else
            return capabilities;
        end if;
    end function;

    -- set sequencer capabilities
    constant c_capabilities_override      : natural                         := capabilities_override(CAPABILITIES, SIM_TIME_REDUCTIONS);
    constant c_capabilities               : std_logic_vector(31 downto 0)   := std_logic_vector(to_unsigned(c_capabilities_override,32));

    -- setup for address/command interface
    constant c_seq_addr_cmd_config        : t_addr_cmd_config_rec           := set_config_rec(MEM_IF_ADDR_WIDTH, MEM_IF_BANKADDR_WIDTH, MEM_IF_NUM_RANKS, DWIDTH_RATIO, MEM_IF_MEMTYPE);

    -- setup for odt signals
    -- odt setting as implemented in the altera high-performance controller for ddrx memories
    constant c_odt_settings               : t_odt_array(0 to MEM_IF_NUM_RANKS-1) := set_odt_values(MEM_IF_NUM_RANKS, MEM_IF_RANKS_PER_SLOT, MEM_IF_MEMTYPE);

    -- a prefix for all report signals to identify phy and sequencer block
--
    constant seq_report_prefix     : string  := "ddr3_int_phy_alt_mem_phy_seq (top) : ";

    -- setup iram configuration
    constant c_iram_addresses             : t_base_hdr_addresses            := calc_iram_addresses(DWIDTH_RATIO, PLL_STEPS_PER_CYCLE, MEM_IF_DWIDTH, MEM_IF_NUM_RANKS, MEM_IF_DQS_CAPTURE_EN);
    constant c_int_iram_awidth            : natural                         := c_iram_addresses.required_addr_bits;

    constant c_preset_cal_setup   : t_preset_cal := setup_instant_on(SIM_TIME_REDUCTIONS, FAMILYGROUP_ID, MEM_IF_MEMTYPE, DWIDTH_RATIO, PLL_STEPS_PER_CYCLE, c_phy_def_mr_1st_sl_vector, c_phy_def_mr_2nd_sl_vector, c_phy_def_mr_3rd_sl_vector);
    constant c_preset_codvw_phase : natural := c_preset_cal_setup.codvw_phase;
    constant c_preset_codvw_size  : natural := c_preset_cal_setup.codvw_size;

    constant c_tracking_interval_in_ms : natural := 128;
    constant c_mem_if_cal_bank         : natural := 0;      -- location to calibrate to
    constant c_mem_if_cal_base_col     : natural := 0;      -- default all zeros
    constant c_mem_if_cal_base_row     : natural := 0;
    constant c_non_op_eval_md          : string  := "PIN_FINDER";  -- non_operational evaluation mode (used when GENERATE_ADDITIONAL_DBG_RTL = 1)

begin  -- architecture struct

-- ---------------------------------------------------------------
-- tie off unused signals to default values
-- ---------------------------------------------------------------

    -- scan chain associated signals
    seq_scan_clk               <= (others => '0');
    seq_scan_enable_dqs_config <= (others => '0');
    seq_scan_update            <= (others => '0');
    seq_scan_din               <= (others => '0');
    seq_scan_enable_ck         <= (others => '0');
    seq_scan_enable_dqs        <= (others => '0');
    seq_scan_enable_dqsn       <= (others => '0');
    seq_scan_enable_dq         <= (others => '0');
    seq_scan_enable_dm         <= (others => '0');

    seq_dqs_add_2t_delay       <= (others => '0');

    seq_rdp_inc_read_lat_1x    <= (others => '0');
    seq_rdp_dec_read_lat_1x    <= (others => '0');

    -- warning flag (not used in non-levelled sequencer)
    ctl_init_warning           <= '0';

    -- parity error flag (not used in non-levelled sequencer)
    parity_error_n             <= '1';

    --
    admin: entity ddr3_int_phy_alt_mem_phy_admin
        generic map
    (
        MEM_IF_DQS_WIDTH             => MEM_IF_DQS_WIDTH,
        MEM_IF_DWIDTH                => MEM_IF_DWIDTH,
        MEM_IF_DM_WIDTH              => MEM_IF_DM_WIDTH,
        MEM_IF_DQ_PER_DQS            => MEM_IF_DQ_PER_DQS,
        DWIDTH_RATIO                 => DWIDTH_RATIO,
        CLOCK_INDEX_WIDTH            => CLOCK_INDEX_WIDTH,
        MEM_IF_CLK_PAIR_COUNT        => MEM_IF_CLK_PAIR_COUNT,
        MEM_IF_ADDR_WIDTH            => MEM_IF_ADDR_WIDTH,
        MEM_IF_BANKADDR_WIDTH        => MEM_IF_BANKADDR_WIDTH,
        MEM_IF_NUM_RANKS             => MEM_IF_NUM_RANKS,
        ADV_LAT_WIDTH                => ADV_LAT_WIDTH,
        MEM_IF_DQSN_EN               => MEM_IF_DQSN_EN,
        MEM_IF_MEMTYPE               => MEM_IF_MEMTYPE,
        MEM_IF_CAL_BANK              => c_mem_if_cal_bank,
        MEM_IF_CAL_BASE_ROW          => c_mem_if_cal_base_row,
        GENERATE_ADDITIONAL_DBG_RTL  => GENERATE_ADDITIONAL_DBG_RTL,
        NON_OP_EVAL_MD               => c_non_op_eval_md,
        MEM_IF_CLK_PS                => MEM_IF_CLK_PS,
        TINIT_TCK                    => TINIT_TCK,
        TINIT_RST                    => TINIT_RST
    )
    port map
    (
        clk                          => clk,
        rst_n                        => rst_n,
        mem_ac_swapped_ranks         => mem_ac_swapped_ranks,
        ctl_cal_byte_lanes           => ctl_cal_byte_lanes_r,
        seq_ac                       => admin_ac,
        seq_ac_sel                   => seq_ac_sel,
        enable_odt                   => enable_odt,
        regs_admin_ctrl_rec          => regs_admin_ctrl_rec,
        admin_regs_status_rec        => admin_regs_status_rec,
        trefi_failure                => trefi_failure,
        ctrl_admin                   => ctrl_broadcast,
        admin_ctrl                   => admin_ctrl,
        ac_access_req                => dgb_ac_access_req,
        ac_access_gnt                => dgb_ac_access_gnt,
        cal_fail                     => ctl_init_fail_int,
        cal_success                  => ctl_init_success_int,
        ctl_recalibrate_req          => ctl_recalibrate_req
    );

    -- selectively include the debug i/f (iram and mmi blocks)
    with_debug_if : if GENERATE_ADDITIONAL_DBG_RTL = 1 generate

    signal mmi_iram                       : t_iram_ctrl;
    signal mmi_iram_enable_writes         : std_logic;
    signal rrp_mem_loc                    : natural range 0 to 2 ** c_int_iram_awidth - 1;
    signal command_req_r                  : std_logic;

    signal ctrl_broadcast_r               : t_ctrl_command;

    begin

        -- register ctrl_broadcast locally
         process (clk, rst_n)
         begin
            if rst_n = '0' then
                ctrl_broadcast_r <= defaults;
            elsif rising_edge(clk) then
                ctrl_broadcast_r <= ctrl_broadcast;
            end if;
         end process;

        --
        mmi : entity ddr3_int_phy_alt_mem_phy_mmi
                generic map (
            MEM_IF_DQS_WIDTH           => MEM_IF_DQS_WIDTH,
            MEM_IF_DWIDTH              => MEM_IF_DWIDTH,
            MEM_IF_DM_WIDTH            => MEM_IF_DM_WIDTH,
            MEM_IF_DQ_PER_DQS          => MEM_IF_DQ_PER_DQS,
            DWIDTH_RATIO               => DWIDTH_RATIO,
            CLOCK_INDEX_WIDTH          => CLOCK_INDEX_WIDTH,
            MEM_IF_CLK_PAIR_COUNT      => MEM_IF_CLK_PAIR_COUNT,
            MEM_IF_ADDR_WIDTH          => MEM_IF_ADDR_WIDTH,
            MEM_IF_BANKADDR_WIDTH      => MEM_IF_BANKADDR_WIDTH,
            MEM_IF_NUM_RANKS           => MEM_IF_NUM_RANKS,
            MEM_IF_DQS_CAPTURE         => MEM_IF_DQS_CAPTURE_EN,
            ADV_LAT_WIDTH              => ADV_LAT_WIDTH,
            RESYNCHRONISE_AVALON_DBG   => RESYNCHRONISE_AVALON_DBG,
            AV_IF_ADDR_WIDTH           => AV_IF_ADDR_WIDTH,
            NOM_DQS_PHASE_SETTING      => NOM_DQS_PHASE_SETTING,
            SCAN_CLK_DIVIDE_BY         => SCAN_CLK_DIVIDE_BY,
            RDP_ADDR_WIDTH             => RDP_ADDR_WIDTH,
            PLL_STEPS_PER_CYCLE        => PLL_STEPS_PER_CYCLE,
            IOE_PHASES_PER_TCK         => IOE_PHASES_PER_TCK,
            IOE_DELAYS_PER_PHS         => IOE_DELAYS_PER_PHS,
            MEM_IF_CLK_PS              => MEM_IF_CLK_PS,
            PHY_DEF_MR_1ST             => c_phy_def_mr_1st_sl_vector,
            PHY_DEF_MR_2ND             => c_phy_def_mr_2nd_sl_vector,
            PHY_DEF_MR_3RD             => c_phy_def_mr_3rd_sl_vector,
            PHY_DEF_MR_4TH             => c_phy_def_mr_4th_sl_vector,
            MEM_IF_MEMTYPE             => MEM_IF_MEMTYPE,
            PRESET_RLAT                => PRESET_RLAT,
            CAPABILITIES               => c_capabilities_override,
            USE_IRAM                   => '1',  -- always use iram (generic is rfu)
            IRAM_AWIDTH                => c_int_iram_awidth,
            TRACKING_INTERVAL_IN_MS    => c_tracking_interval_in_ms,
            READ_LAT_WIDTH             => ADV_LAT_WIDTH
        )
        port map(
            clk                        => clk,
            rst_n                      => rst_n,
            dbg_seq_clk                => dbg_seq_clk,
            dbg_seq_rst_n              => dbg_seq_rst_n,
            dbg_seq_addr               => dbg_seq_addr,
            dbg_seq_wr                 => dbg_seq_wr,
            dbg_seq_rd                 => dbg_seq_rd,
            dbg_seq_cs                 => dbg_seq_cs,
            dbg_seq_wr_data            => dbg_seq_wr_data,
            seq_dbg_rd_data            => seq_dbg_rd_data,
            seq_dbg_waitrequest        => seq_dbg_waitrequest,
            regs_admin_ctrl            => regs_admin_ctrl_rec,
            admin_regs_status          => admin_regs_status_rec,
            mmi_iram                   => mmi_iram,
            mmi_iram_enable_writes     => mmi_iram_enable_writes,
            iram_status                => iram_status,
            mmi_ctrl                   => mmi_ctrl,
            ctrl_mmi                   => ctrl_mmi,
            int_ac_1t                  => int_ac_nt(0),
            invert_ac_1t               => open,
            trefi_failure              => trefi_failure,
            parameterisation_rec       => parameterisation_rec,
            pll_mmi                    => pll_mmi,
            mmi_pll                    => mmi_pll,
            dgrb_mmi                   => dgrb_mmi
        );


    --
     iram : entity ddr3_int_phy_alt_mem_phy_iram
              generic map(
             MEM_IF_MEMTYPE          => MEM_IF_MEMTYPE,
             FAMILYGROUP_ID          => FAMILYGROUP_ID,
             MEM_IF_DQS_WIDTH        => MEM_IF_DQS_WIDTH,
             MEM_IF_DQ_PER_DQS       => MEM_IF_DQ_PER_DQS,
             MEM_IF_DWIDTH           => MEM_IF_DWIDTH,
             MEM_IF_DM_WIDTH         => MEM_IF_DM_WIDTH,
             MEM_IF_NUM_RANKS        => MEM_IF_NUM_RANKS,
             IRAM_AWIDTH             => c_int_iram_awidth,
             REFRESH_COUNT_INIT      => 12,
             PRESET_RLAT             => PRESET_RLAT,
             PLL_STEPS_PER_CYCLE     => PLL_STEPS_PER_CYCLE,
             CAPABILITIES            => c_capabilities_override,
             IP_BUILDNUM             => IP_BUILDNUM
        )
         port map(
             clk                     => clk,
             rst_n                   => rst_n,
             mmi_iram                => mmi_iram,
             mmi_iram_enable_writes  => mmi_iram_enable_writes,
             iram_status             => iram_status,
             iram_push_done          => iram_push_done,
             ctrl_iram               => ctrl_broadcast_r,
             dgrb_iram               => dgrb_iram,
             admin_regs_status_rec   => admin_regs_status_rec,
             ctrl_idib_top           => ctrl_idib_top,
             ctrl_iram_push          => ctrl_iram_push,
             dgwb_iram               => dgwb_iram
         );

         -- calculate where current data should go in the iram
         process (clk, rst_n)

             variable v_words_req     : natural range 0 to 2 * MEM_IF_DWIDTH * PLL_STEPS_PER_CYCLE * DWIDTH_RATIO - 1;  -- how many words are required

         begin
             if rst_n = '0' then

                 ctrl_idib_top <= 0;
                 command_req_r <= '0';
                 rrp_mem_loc   <= 0;

             elsif rising_edge(clk) then

                 if command_req_r = '0' and ctrl_broadcast_r.command_req = '1' then  -- execute once on each command_req assertion

                     -- default a 'safe location'
                     ctrl_idib_top <= c_iram_addresses.safe_dummy;

                     case ctrl_broadcast_r.command is

                         when cmd_write_ihi =>  -- reset pointers

                             rrp_mem_loc <= c_iram_addresses.rrp;
                             ctrl_idib_top <= 0; -- write header to zero location always

                         when cmd_rrp_sweep =>

                             -- add previous space requirement onto the current address
                             ctrl_idib_top <= rrp_mem_loc;

                             -- add the current space requirement to v_rrp_mem_loc
                             -- there are (DWIDTH_RATIO/2) * PLL_STEPS_PER_CYCLE phases swept packed into 32 bit words per pin
                             -- note: special case for single_bit calibration stages (e.g. read_mtp alignment)

                             if ctrl_broadcast_r.command_op.single_bit = '1' then
                                 v_words_req := iram_wd_for_one_pin_rrp(DWIDTH_RATIO, PLL_STEPS_PER_CYCLE, MEM_IF_DWIDTH, MEM_IF_DQS_CAPTURE_EN);
                             else
                                 v_words_req := iram_wd_for_full_rrp(DWIDTH_RATIO, PLL_STEPS_PER_CYCLE, MEM_IF_DWIDTH, MEM_IF_DQS_CAPTURE_EN);
                             end if;

                             v_words_req := v_words_req + 2; -- add 1 word location for header / footer information

                             rrp_mem_loc <= rrp_mem_loc + v_words_req;

                         when cmd_rrp_seek |
                              cmd_read_mtp =>

                            -- add previous space requirement onto the current address
                             ctrl_idib_top <= rrp_mem_loc;

                             -- require 3 words - header, result and footer
                             v_words_req := 3;

                             rrp_mem_loc <= rrp_mem_loc + v_words_req;

                         when others =>
                             null;

                     end case;

                 end if;

                 command_req_r <= ctrl_broadcast_r.command_req;

                 -- if recalibration request then reset iram address
                 if ctl_recalibrate_req = '1' or mmi_ctrl.calibration_start = '1' then

                    rrp_mem_loc <= c_iram_addresses.rrp;

                 end if;

             end if;

         end process;

    end generate;  -- with debug interface

    -- if no debug interface (iram/mmi block) tie off relevant signals
    without_debug_if : if GENERATE_ADDITIONAL_DBG_RTL = 0 generate

    constant c_slv_hl_stage_enable   : std_logic_vector(31 downto 0)                    := std_logic_vector(to_unsigned(c_capabilities_override, 32));
    constant c_hl_stage_enable       : std_logic_vector(c_hl_ccs_num_stages-1 downto 0) := c_slv_hl_stage_enable(c_hl_ccs_num_stages-1 downto 0);
    constant c_pll_360_sweeps        : natural                       := rrp_pll_phase_mult(DWIDTH_RATIO, MEM_IF_DQS_CAPTURE_EN);

    signal mmi_regs                  : t_mmi_regs := defaults;

    begin

        -- avalon interface signals
        seq_dbg_rd_data     <= (others => '0');
        seq_dbg_waitrequest <= '0';

        -- The following registers are generated to simplify the assignments which follow
        -- but will be optimised away in synthesis
        mmi_regs.rw_regs    <= defaults(c_phy_def_mr_1st_sl_vector,
                                        c_phy_def_mr_2nd_sl_vector,
                                        c_phy_def_mr_3rd_sl_vector,
                                        c_phy_def_mr_4th_sl_vector,
                                        NOM_DQS_PHASE_SETTING,
                                        PLL_STEPS_PER_CYCLE,
                                        c_pll_360_sweeps,
                                        c_tracking_interval_in_ms,
                                        c_hl_stage_enable);

        mmi_regs.ro_regs    <= defaults(dgrb_mmi,
                                        ctrl_mmi,
                                        pll_mmi,
                                        mmi_regs.rw_regs.rw_if_test,
                                        '0',  -- do not use iram
                                        MEM_IF_DQS_CAPTURE_EN,
                                        int_ac_nt(0),
                                        trefi_failure,
                                        iram_status,
                                        c_int_iram_awidth);

        process(mmi_regs)
        begin
            --  debug parameterisation signals
            regs_admin_ctrl_rec          <= pack_record(mmi_regs.rw_regs);
            parameterisation_rec         <= pack_record(mmi_regs.rw_regs);
            mmi_pll                      <= pack_record(mmi_regs.rw_regs);
            mmi_ctrl                     <= pack_record(mmi_regs.rw_regs);
        end process;

        -- from the iram
        iram_status                      <= defaults;
        iram_push_done                   <= '0';

    end generate; -- without debug interface

    --
    dgrb : entity ddr3_int_phy_alt_mem_phy_dgrb
        generic map(
        MEM_IF_DQS_WIDTH                 => MEM_IF_DQS_WIDTH,
        MEM_IF_DQ_PER_DQS			     => MEM_IF_DQ_PER_DQS,
        MEM_IF_DWIDTH                    => MEM_IF_DWIDTH,
        MEM_IF_DM_WIDTH                  => MEM_IF_DM_WIDTH,
        MEM_IF_DQS_CAPTURE               => MEM_IF_DQS_CAPTURE_EN,
        DWIDTH_RATIO                     => DWIDTH_RATIO,
        CLOCK_INDEX_WIDTH                => CLOCK_INDEX_WIDTH,
        MEM_IF_ADDR_WIDTH                => MEM_IF_ADDR_WIDTH,
        MEM_IF_BANKADDR_WIDTH            => MEM_IF_BANKADDR_WIDTH,
        MEM_IF_NUM_RANKS                 => MEM_IF_NUM_RANKS,
        MEM_IF_MEMTYPE                   => MEM_IF_MEMTYPE,
        ADV_LAT_WIDTH                    => ADV_LAT_WIDTH,
        PRESET_RLAT                      => PRESET_RLAT,
        PLL_STEPS_PER_CYCLE              => PLL_STEPS_PER_CYCLE,
        SIM_TIME_REDUCTIONS              => SIM_TIME_REDUCTIONS,
        GENERATE_ADDITIONAL_DBG_RTL      => GENERATE_ADDITIONAL_DBG_RTL,
        PRESET_CODVW_PHASE               => c_preset_codvw_phase,
        PRESET_CODVW_SIZE                => c_preset_codvw_size,
        MEM_IF_CAL_BANK                  => c_mem_if_cal_bank,
        MEM_IF_CAL_BASE_COL              => c_mem_if_cal_base_col,
        EN_OCT                           => EN_OCT
   )
    port map(
        clk                              => clk,
        rst_n                            => rst_n,
        dgrb_ctrl                        => dgrb_ctrl,
        ctrl_dgrb                        => ctrl_broadcast,
        parameterisation_rec             => parameterisation_rec,
        phs_shft_busy                    => dgrb_phs_shft_busy,
        seq_pll_inc_dec_n                => dgrb_pll_inc_dec_n,
        seq_pll_select                   => dgrb_pll_select,
        seq_pll_start_reconfig           => dgrb_pll_start_reconfig,
        pll_resync_clk_index             => pll_resync_clk_index,
        pll_measure_clk_index            => pll_measure_clk_index,
        dgrb_iram                        => dgrb_iram,
        iram_push_done                   => iram_push_done,
        dgrb_ac                          => dgrb_ac,
        dgrb_ac_access_req               => dgrb_ac_access_req,
        dgrb_ac_access_gnt               => dgb_ac_access_gnt_r,
        seq_rdata_valid_lat_inc          => seq_rdata_valid_lat_inc_int,
        seq_rdata_valid_lat_dec          => seq_rdata_valid_lat_dec_int,
        seq_poa_lat_dec_1x               => seq_poa_lat_dec_1x_int,
        seq_poa_lat_inc_1x               => seq_poa_lat_inc_1x_int,
        rdata_valid                      => rdata_valid,
        rdata                            => rdata,
        doing_rd                         => seq_rdv_doing_rd_int,
        rd_lat                           => seq_ctl_rlat_int,
        wd_lat                           => seq_ctl_wlat_int,
        dgrb_wdp_ovride                  => dgrb_wdp_override,
        seq_oct_value                    => seq_oct_value,
        seq_mmc_start                    => seq_mmc_start,
        mmc_seq_done                     => mmc_seq_done,
        mmc_seq_value                    => mmc_seq_value,
        ctl_cal_byte_lanes               => ctl_cal_byte_lanes_r,
        odt_settings                     => c_odt_settings,
        dgrb_ctrl_ac_nt_good             => dgrb_ctrl_ac_nt_good,
        dgrb_mmi                         => dgrb_mmi
    );

    --
    dgwb : entity ddr3_int_phy_alt_mem_phy_dgwb
        generic map(
        -- Physical IF width definitions
        MEM_IF_DQS_WIDTH             => MEM_IF_DQS_WIDTH,
        MEM_IF_DQ_PER_DQS			 => MEM_IF_DQ_PER_DQS,
        MEM_IF_DWIDTH                => MEM_IF_DWIDTH,
        MEM_IF_DM_WIDTH              => MEM_IF_DM_WIDTH,
        DWIDTH_RATIO                 => DWIDTH_RATIO,
        MEM_IF_ADDR_WIDTH            => MEM_IF_ADDR_WIDTH,
        MEM_IF_BANKADDR_WIDTH        => MEM_IF_BANKADDR_WIDTH,
        MEM_IF_NUM_RANKS             => MEM_IF_NUM_RANKS,
        MEM_IF_MEMTYPE               => MEM_IF_MEMTYPE,
        ADV_LAT_WIDTH                => ADV_LAT_WIDTH,
        MEM_IF_CAL_BANK              => c_mem_if_cal_bank,
        MEM_IF_CAL_BASE_COL          => c_mem_if_cal_base_col
   )
    port map(
        clk                          => clk,
        rst_n                        => rst_n,
        parameterisation_rec         => parameterisation_rec,
        dgwb_ctrl                    => dgwb_ctrl,
        ctrl_dgwb                    => ctrl_broadcast,
        dgwb_iram                    => dgwb_iram,
        iram_push_done               => iram_push_done,
        dgwb_ac_access_req           => dgwb_ac_access_req,
        dgwb_ac_access_gnt           => dgb_ac_access_gnt_r,
        dgwb_dqs_burst               => seq_wdp_dqs_burst,
        dgwb_wdata_valid             => seq_wdp_wdata_valid,
        dgwb_wdata                   => seq_wdp_wdata,
        dgwb_dm                      => seq_wdp_dm,
        dgwb_dqs                     => seq_wdp_dqs,
        dgwb_wdp_ovride              => dgwb_wdp_override,
        dgwb_ac                      => dgwb_ac,
        bypassed_rdata               => rdata(DWIDTH_RATIO * MEM_IF_DWIDTH -1 downto (DWIDTH_RATIO-1) * MEM_IF_DWIDTH),
        odt_settings                 => c_odt_settings
    );

    --
    ctrl: entity ddr3_int_phy_alt_mem_phy_ctrl
        generic map(
        FAMILYGROUP_ID               => FAMILYGROUP_ID,
        MEM_IF_DLL_LOCK_COUNT        => 1280/(DWIDTH_RATIO/2),
        MEM_IF_MEMTYPE               => MEM_IF_MEMTYPE,
        DWIDTH_RATIO                 => DWIDTH_RATIO,
        IRAM_ADDRESSING              => c_iram_addresses,
        MEM_IF_CLK_PS                => MEM_IF_CLK_PS,
        TRACKING_INTERVAL_IN_MS      => c_tracking_interval_in_ms,
        GENERATE_ADDITIONAL_DBG_RTL  => GENERATE_ADDITIONAL_DBG_RTL,
        MEM_IF_NUM_RANKS             => MEM_IF_NUM_RANKS,
        MEM_IF_DQS_WIDTH             => MEM_IF_DQS_WIDTH,
        SIM_TIME_REDUCTIONS          => SIM_TIME_REDUCTIONS,
        ACK_SEVERITY                 => warning
    )
    port map(
        clk                          => clk,
        rst_n                        => rst_n,
        ctl_init_success             => ctl_init_success_int,
        ctl_init_fail                => ctl_init_fail_int,
        ctl_recalibrate_req          => ctl_recalibrate_req,
        iram_status                  => iram_status,
        iram_push_done               => iram_push_done,
        ctrl_op_rec                  => ctrl_broadcast,
        admin_ctrl                   => admin_ctrl,
        dgrb_ctrl                    => dgrb_ctrl,
        dgwb_ctrl                    => dgwb_ctrl,
        ctrl_iram_push               => ctrl_iram_push,
        ctl_cal_byte_lanes           => ctl_cal_byte_lanes_r,
        dgrb_ctrl_ac_nt_good         => dgrb_ctrl_ac_nt_good,
        int_ac_nt                    => int_ac_nt,
        mmi_ctrl                     => mmi_ctrl,
        ctrl_mmi                     => ctrl_mmi
    );


-- ------------------------------------------------------------------
-- generate legacy rsu signals
-- ------------------------------------------------------------------
    process(rst_n, clk)
    begin
        if rst_n = '0' then
            rsu_multiple_valid_latencies_err <= '0';
            rsu_grt_one_dvw_err              <= '0';
            rsu_no_dvw_err                   <= '0';
            rsu_codvw_phase                  <= (others => '0');
            rsu_codvw_size                   <= (others => '0');
            rsu_read_latency                 <= (others => '0');
        elsif rising_edge(clk) then

            if dgrb_ctrl.command_err = '1' then
                case to_integer(unsigned(dgrb_ctrl.command_result)) is
                    when C_ERR_RESYNC_NO_VALID_PHASES =>
                        rsu_no_dvw_err      <= '1';
                    when C_ERR_RESYNC_MULTIPLE_EQUAL_WINDOWS =>
                        rsu_multiple_valid_latencies_err <= '1';
                    when others => null;
                end case;
            end if;

            rsu_codvw_phase(dgrb_mmi.cal_codvw_phase'range)  <= dgrb_mmi.cal_codvw_phase;
            rsu_codvw_size(dgrb_mmi.cal_codvw_size'range)    <= dgrb_mmi.cal_codvw_size;
            rsu_read_latency                                 <= seq_ctl_rlat_int;
	    rsu_grt_one_dvw_err                              <= dgrb_mmi.codvw_grt_one_dvw;

	    -- Reset the flag on a recal request :
	    if ( ctl_recalibrate_req = '1') then
	        rsu_grt_one_dvw_err <= '0';
                rsu_no_dvw_err      <= '0';
                rsu_multiple_valid_latencies_err <= '0';
	    end if;

        end if;
    end process;

-- ---------------------------------------------------------------
-- top level multiplexing and ctrl functionality
-- ---------------------------------------------------------------

    oct_delay_block : block
        constant DEFAULT_OCT_DELAY_CONST : integer := - 2; -- higher increases delay by one mem_clk cycle, lower decreases delay by one mem_clk cycle.
        constant DEFAULT_OCT_EXTEND      : natural := 3;

        -- Returns additive latency extracted from mr0 as a natural number.
        function decode_cl(mr0 : in std_logic_vector(12 downto 0))
                return natural is
            variable v_cl : natural range 0 to 2**4 - 1;
        begin
            if MEM_IF_MEMTYPE = "DDR" or MEM_IF_MEMTYPE = "DDR2" then
                v_cl := to_integer(unsigned(mr0(6 downto 4)));
            elsif MEM_IF_MEMTYPE = "DDR3" then
                v_cl := to_integer(unsigned(mr0(6 downto 4))) + 4;
            else
                report "Unsupported memory type " & MEM_IF_MEMTYPE severity failure;
            end if;

            return v_cl;
        end function;


        -- Returns additive latency extracted from mr1 as a natural number.
        function decode_al(mr1 : in std_logic_vector(12 downto 0))
                return natural is
            variable v_al : natural range 0 to 2**4 - 1;
        begin
            if MEM_IF_MEMTYPE = "DDR" or MEM_IF_MEMTYPE = "DDR2" then
                v_al := to_integer(unsigned(mr1(5 downto 3)));
            elsif MEM_IF_MEMTYPE = "DDR3" then
                v_al := to_integer(unsigned(mr1(4 downto 3)));
            else
                report "Unsupported memory type " & MEM_IF_MEMTYPE severity failure;
            end if;

            return v_al;
        end function;


        -- Returns cas write latency extracted from mr2 as a natural number.
        function decode_cwl(
                mr0 : in std_logic_vector(12 downto 0);
                mr2 : in std_logic_vector(12 downto 0)
            )
                return natural is
            variable v_cwl : natural range 0 to 2**4 - 1;
        begin
            if MEM_IF_MEMTYPE = "DDR" then
                v_cwl := 1;
            elsif MEM_IF_MEMTYPE = "DDR2" then
                v_cwl := decode_cl(mr0) - 1;
            elsif MEM_IF_MEMTYPE = "DDR3" then
                v_cwl := to_integer(unsigned(mr2(4 downto 3))) + 5;
            else
                report "Unsupported memory type " & MEM_IF_MEMTYPE severity failure;
            end if;

            return v_cwl;
        end function;

    begin
        -- Process to work out timings for OCT extension and delay with respect to doing_read. NOTE that it is calculated on the basis of CL, CWL, ctl_wlat
        oct_delay_proc : process(clk, rst_n)
            variable v_cl : natural range 0 to 2**4 - 1; -- Total read latency.
            variable v_cwl : natural range 0 to 2**4 - 1; -- Total write latency
            variable oct_delay : natural range 0 to 2**OCT_LAT_WIDTH - 1;

            variable v_wlat : natural range 0 to 2**ADV_LAT_WIDTH - 1;

        begin
            if rst_n = '0' then
                seq_oct_oct_delay <= (others => '0');
                seq_oct_oct_extend <= std_logic_vector(to_unsigned(DEFAULT_OCT_EXTEND, OCT_LAT_WIDTH));
            elsif rising_edge(clk) then
                if ctl_init_success_int = '1' then
                    seq_oct_oct_extend <= std_logic_vector(to_unsigned(DEFAULT_OCT_EXTEND, OCT_LAT_WIDTH));

                    v_cl := decode_cl(admin_regs_status_rec.mr0);
                    v_cwl := decode_cwl(admin_regs_status_rec.mr0, admin_regs_status_rec.mr2);

                    if SIM_TIME_REDUCTIONS = 1 then
                        v_wlat := c_preset_cal_setup.wlat;
                    else
                        v_wlat := to_integer(unsigned(seq_ctl_wlat_int));
                    end if;

                    oct_delay := DWIDTH_RATIO * v_wlat / 2 +  (v_cl - v_cwl) + DEFAULT_OCT_DELAY_CONST;

                    if not (FAMILYGROUP_ID = 2) then  -- CIII doesn't support OCT
                        seq_oct_oct_delay <= std_logic_vector(to_unsigned(oct_delay, OCT_LAT_WIDTH));
                    end if;
                else
                    seq_oct_oct_delay <= (others => '0');
                    seq_oct_oct_extend <= std_logic_vector(to_unsigned(DEFAULT_OCT_EXTEND, OCT_LAT_WIDTH));
                end if;
            end if;
        end process;
    end block;


    -- control postamble protection override signal (seq_poa_protection_override_1x)
    process(clk, rst_n)
        variable v_warning_given : std_logic;
    begin
        if rst_n = '0' then
            seq_poa_protection_override_1x <= '0';

            v_warning_given := '0';
        elsif rising_edge(clk) then

            case ctrl_broadcast.command is
                when cmd_rdv             |
                     cmd_rrp_sweep       |
                     cmd_rrp_seek        |
                     cmd_prep_adv_rd_lat |
                     cmd_prep_adv_wr_lat => seq_poa_protection_override_1x <= '1';
                when others              => seq_poa_protection_override_1x <= '0';
            end case;

        end if;
    end process;

    ac_mux : block

        constant c_mem_clk_disable_pipe_len : natural := 3;


        signal seen_phy_init_complete  : std_logic;
        signal mem_clk_disable         : std_logic_vector(c_mem_clk_disable_pipe_len - 1 downto 0);

        signal ctrl_broadcast_r        : t_ctrl_command;

    begin

        -- register ctrl_broadcast locally
        -- #for speed and to reduce fan out
        process (clk, rst_n)
         begin
            if rst_n = '0' then
                ctrl_broadcast_r <= defaults;
            elsif rising_edge(clk) then
                ctrl_broadcast_r <= ctrl_broadcast;
            end if;
         end process;

        -- multiplex mem interface control between admin, dgrb and dgwb
        process(clk, rst_n)
            variable v_seq_ac_mux : t_addr_cmd_vector(0 to (DWIDTH_RATIO/2)-1);
        begin
            if rst_n = '0' then

                seq_rdv_doing_rd    <= (others => '0');

                seq_mem_clk_disable     <= '1';
                mem_clk_disable         <= (others => '1');
                seen_phy_init_complete  <= '0';

                seq_ac_addr      <= (others => '0');
                seq_ac_ba        <= (others => '0');
                seq_ac_cas_n     <= (others => '1');
                seq_ac_ras_n     <= (others => '1');
                seq_ac_we_n      <= (others => '1');
                seq_ac_cke       <= (others => '0');
                seq_ac_cs_n      <= (others => '1');
                seq_ac_odt       <= (others => '0');
                seq_ac_rst_n     <= (others => '0');

            elsif rising_edge(clk) then

                seq_rdv_doing_rd                                       <= seq_rdv_doing_rd_int;
                seq_mem_clk_disable                                    <= mem_clk_disable(c_mem_clk_disable_pipe_len-1);
                mem_clk_disable(c_mem_clk_disable_pipe_len-1 downto 1) <= mem_clk_disable(c_mem_clk_disable_pipe_len-2 downto 0);

                if dgwb_ac_access_req = '1' and dgb_ac_access_gnt = '1' then
                   v_seq_ac_mux := dgwb_ac;
                elsif dgrb_ac_access_req = '1' and dgb_ac_access_gnt = '1' then
                   v_seq_ac_mux := dgrb_ac;
                else
                   v_seq_ac_mux := admin_ac;
                end if;

                if ctl_recalibrate_req = '1' then
                    mem_clk_disable(0)     <= '1';
                    seen_phy_init_complete <= '0';
                elsif ctrl_broadcast_r.command = cmd_init_dram and ctrl_broadcast_r.command_req = '1' then
                    mem_clk_disable(0)     <= '0';
                    seen_phy_init_complete <= '1';
                end if;

                if seen_phy_init_complete /= '1' then -- if not initialised the phy hold in reset

                    seq_ac_addr      <= (others => '0');
                    seq_ac_ba        <= (others => '0');
                    seq_ac_cas_n     <= (others => '1');
                    seq_ac_ras_n     <= (others => '1');
                    seq_ac_we_n      <= (others => '1');
                    seq_ac_cke       <= (others => '0');
                    seq_ac_cs_n      <= (others => '1');
                    seq_ac_odt       <= (others => '0');
                    seq_ac_rst_n     <= (others => '0');

                else

                    if enable_odt = '0' then
                        v_seq_ac_mux := mask(c_seq_addr_cmd_config, v_seq_ac_mux, odt, '0');
                    end if;

                    unpack_addr_cmd_vector (
                        c_seq_addr_cmd_config,
                        v_seq_ac_mux,
                        seq_ac_addr,
                        seq_ac_ba,
                        seq_ac_cas_n,
                        seq_ac_ras_n,
                        seq_ac_we_n,
                        seq_ac_cke,
                        seq_ac_cs_n,
                        seq_ac_odt,
                        seq_ac_rst_n);

                end if;

            end if;
        end process;

    end block;

    -- register dgb_ac_access_gnt signal to ensure ODT set correctly in dgrb and dgwb prior to a read or write operation
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            dgb_ac_access_gnt_r <= '0';
        elsif rising_edge(clk) then
            dgb_ac_access_gnt_r <= dgb_ac_access_gnt;
        end if;
    end process;

    -- multiplex access request from dgrb/dgwb to admin block with checking for multiple accesses
    process (dgrb_ac_access_req, dgwb_ac_access_req)
    begin
        dgb_ac_access_req <= '0';
        if dgwb_ac_access_req = '1' and dgrb_ac_access_req = '1' then
            report seq_report_prefix & "multiple accesses attempted from DGRB and DGWB to admin block via signals dg.b_ac_access_reg " severity failure;
        elsif dgwb_ac_access_req = '1' or dgrb_ac_access_req = '1' then
            dgb_ac_access_req <= '1';
        end if;
    end process;


    rdv_poa_blk : block

        -- signals to control static setup of ctl_rdata_valid signal for instant on mode:
        constant c_static_rdv_offset : integer := c_preset_cal_setup.rdv_lat;                     -- required change in RDV latency (should always be > 0)
        signal static_rdv_offset     : natural range 0 to abs(c_static_rdv_offset);               -- signal to count # RDV shifts
        constant c_dly_rdv_set       : natural := 7;                                              -- delay between RDV shifts
        signal dly_rdv_inc_dec       : std_logic;                                                 -- 1 = inc, 0 = dec
        signal rdv_set_delay         : natural range 0 to c_dly_rdv_set;                          -- signal to delay RDV shifts

        -- same for poa protection
        constant c_static_poa_offset : integer := c_preset_cal_setup.poa_lat;
        signal static_poa_offset     : natural range 0 to abs(c_static_poa_offset);
        constant c_dly_poa_set       : natural := 7;
        signal dly_poa_inc_dec       : std_logic;
        signal poa_set_delay         : natural range 0 to c_dly_poa_set;

        -- function to abstract increment or decrement checking
        function set_inc_dec(offset : integer) return std_logic is
        begin
            if offset < 0 then
                return '1';
            else
                return '0';
            end if;
        end function;

    begin

        -- register postamble and rdata_valid latencies
        -- note: postamble unused for Cyclone-III

        -- RDV
        process(clk, rst_n)
        begin
            if rst_n = '0' then

                if SIM_TIME_REDUCTIONS = 1 then

                    -- setup offset calc
                    static_rdv_offset <= abs(c_static_rdv_offset);
                    dly_rdv_inc_dec   <= set_inc_dec(c_static_rdv_offset);
                    rdv_set_delay     <= c_dly_rdv_set;

                end if;

                seq_rdata_valid_lat_dec <= '0';
                seq_rdata_valid_lat_inc <= '0';

            elsif rising_edge(clk) then

                if SIM_TIME_REDUCTIONS = 1 then  -- perform static setup of RDV signal

                    if ctl_recalibrate_req = '1' then -- second reset condition

                        -- setup offset calc
                        static_rdv_offset <= abs(c_static_rdv_offset);
                        dly_rdv_inc_dec   <= set_inc_dec(c_static_rdv_offset);
                        rdv_set_delay     <= c_dly_rdv_set;

                    else

                        if static_rdv_offset /= 0 and
                           rdv_set_delay = 0 then

                            seq_rdata_valid_lat_dec <= not dly_rdv_inc_dec;
                            seq_rdata_valid_lat_inc <= dly_rdv_inc_dec;

                            static_rdv_offset       <= static_rdv_offset - 1;
                            rdv_set_delay           <= c_dly_rdv_set;

                        else  -- once conplete pass through internal signals

                            seq_rdata_valid_lat_dec <= seq_rdata_valid_lat_dec_int;
                            seq_rdata_valid_lat_inc <= seq_rdata_valid_lat_inc_int;

                        end if;

                        if rdv_set_delay /= 0 then
                            rdv_set_delay <= rdv_set_delay - 1;
                        end if;

                    end if;

                else  -- no static setup

                    seq_rdata_valid_lat_dec <= seq_rdata_valid_lat_dec_int;
                    seq_rdata_valid_lat_inc <= seq_rdata_valid_lat_inc_int;

                end if;

            end if;

        end process;

        -- count number of RDV adjustments for debug
        process(clk, rst_n)
        begin

            if rst_n = '0' then
                rdv_adjustments <= 0;
            elsif rising_edge(clk) then
                if seq_rdata_valid_lat_dec_int = '1' then
                    rdv_adjustments <= rdv_adjustments + 1;
                end if;
                if seq_rdata_valid_lat_inc_int = '1' then
                    if rdv_adjustments = 0 then
                        report seq_report_prefix & " read data valid adjustment wrap around detected - more increments than decrements" severity failure;
                    else
                        rdv_adjustments <= rdv_adjustments - 1;
                    end if;
                end if;

            end if;

        end process;

        -- POA protection
        process(clk, rst_n)
        begin
            if rst_n = '0' then

                if SIM_TIME_REDUCTIONS = 1 then

                    -- setup offset calc
                    static_poa_offset <= abs(c_static_poa_offset);
                    dly_poa_inc_dec   <= set_inc_dec(c_static_poa_offset);
                    poa_set_delay     <= c_dly_poa_set;

                end if;

                seq_poa_lat_dec_1x      <= (others => '0');
                seq_poa_lat_inc_1x      <= (others => '0');

            elsif rising_edge(clk) then

                if SIM_TIME_REDUCTIONS = 1 then  -- static setup

                    if ctl_recalibrate_req = '1' then  -- second reset condition

                        -- setup offset calc
                        static_poa_offset <= abs(c_static_poa_offset);
                        dly_poa_inc_dec   <= set_inc_dec(c_static_poa_offset);
                        poa_set_delay     <= c_dly_poa_set;

                    else

                        if static_poa_offset /= 0 and
                           poa_set_delay = 0 then

                            seq_poa_lat_dec_1x <= (others => not(dly_poa_inc_dec));
                            seq_poa_lat_inc_1x <= (others => dly_poa_inc_dec);

                            static_poa_offset  <= static_poa_offset - 1;
                            poa_set_delay      <= c_dly_poa_set;

                        else

                            seq_poa_lat_inc_1x <= seq_poa_lat_inc_1x_int;
                            seq_poa_lat_dec_1x <= seq_poa_lat_dec_1x_int;

                        end if;

                        if poa_set_delay /= 0 then
                            poa_set_delay <= poa_set_delay - 1;
                        end if;

                    end if;

                else  -- no static setup

                    seq_poa_lat_inc_1x      <= seq_poa_lat_inc_1x_int;
                    seq_poa_lat_dec_1x      <= seq_poa_lat_dec_1x_int;

                end if;

            end if;

        end process;

        -- count POA protection adjustments for debug
        process(clk, rst_n)
        begin

            if rst_n = '0' then
                poa_adjustments <= 0;
            elsif rising_edge(clk) then
                if seq_poa_lat_dec_1x_int(0) = '1' then
                    poa_adjustments <= poa_adjustments + 1;
                end if;
                if seq_poa_lat_inc_1x_int(0) = '1' then
                    if poa_adjustments = 0 then
                        report seq_report_prefix & " postamble adjustment wrap around detected - more increments than decrements" severity failure;
                    else
                        poa_adjustments <= poa_adjustments - 1;
                    end if;
                end if;
            end if;

        end process;

    end block;

    -- register output fail/success signals - avoiding optimisation out
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            ctl_init_fail    <= '0';
            ctl_init_success <= '0';
        elsif rising_edge(clk) then
            ctl_init_fail    <= ctl_init_fail_int;
            ctl_init_success <= ctl_init_success_int;
        end if;
    end process;

    -- ctl_cal_byte_lanes register
    -- seq_rdp_reset_req_n - when ctl_recalibrate_req issued
    process(clk,rst_n)
    begin
        if rst_n = '0' then
            seq_rdp_reset_req_n  <= '0';
            ctl_cal_byte_lanes_r <= (others => '1');
        elsif rising_edge(clk) then
            ctl_cal_byte_lanes_r <= not ctl_cal_byte_lanes;

            if ctl_recalibrate_req = '1' then
                seq_rdp_reset_req_n <= '0';
            else

                if ctrl_broadcast.command = cmd_rrp_sweep or
                   SIM_TIME_REDUCTIONS = 1 then
                    seq_rdp_reset_req_n <= '1';
                end if;

            end if;

        end if;
    end process;

    -- register 1t addr/cmd and odt latency outputs
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            seq_ac_add_1t_ac_lat_internal  <= '0';
            seq_ac_add_1t_odt_lat_internal <= '0';
            seq_ac_add_2t                  <= '0';
        elsif rising_edge(clk) then
            if SIM_TIME_REDUCTIONS = 1 then
                seq_ac_add_1t_ac_lat_internal  <= c_preset_cal_setup.ac_1t;
                seq_ac_add_1t_odt_lat_internal <= c_preset_cal_setup.ac_1t;
            else
                seq_ac_add_1t_ac_lat_internal  <= int_ac_nt(0);
                seq_ac_add_1t_odt_lat_internal <= int_ac_nt(0);
            end if;
            seq_ac_add_2t                  <= '0';
        end if;
    end process;

    -- override write datapath signal generation
    process(dgwb_wdp_override, dgrb_wdp_override, ctl_init_success_int, ctl_init_fail_int)
    begin
        if ctl_init_success_int = '0' and ctl_init_fail_int = '0' then -- if calibrating
            seq_wdp_ovride <= dgwb_wdp_override or dgrb_wdp_override;
        else
            seq_wdp_ovride <= '0';
        end if;
    end process;

    -- output write/read latency (override with preset values when sim time reductions equals 1
    seq_ctl_wlat <= std_logic_vector(to_unsigned(c_preset_cal_setup.wlat,ADV_LAT_WIDTH)) when SIM_TIME_REDUCTIONS = 1 else seq_ctl_wlat_int;
    seq_ctl_rlat <= std_logic_vector(to_unsigned(c_preset_cal_setup.rlat,ADV_LAT_WIDTH)) when SIM_TIME_REDUCTIONS = 1 else seq_ctl_rlat_int;

    process (clk, rst_n)
    begin
        if rst_n = '0' then
            seq_pll_phs_shift_busy_r   <= '0';
            seq_pll_phs_shift_busy_ccd <= '0';
        elsif rising_edge(clk) then
            seq_pll_phs_shift_busy_r   <= seq_pll_phs_shift_busy;
            seq_pll_phs_shift_busy_ccd <= seq_pll_phs_shift_busy_r;
        end if;
    end process;


    pll_ctrl: block

        -- static resync setup variables for sim time reductions
        signal static_rst_offset  : natural range 0 to 2*PLL_STEPS_PER_CYCLE;
        signal phs_shft_busy_1r   : std_logic;
        signal pll_set_delay      : natural range 100 downto 0; -- wait 100 clock cycles for clk to be stable before setting resync phase

        -- pll signal generation
        signal mmi_pll_active                : boolean;
        signal seq_pll_phs_shift_busy_ccd_1t : std_logic;

    begin

        -- multiplex ppl interface between dgrb and mmi blocks
        -- plus static setup of rsc phase to a known 'good' condition
        process(clk,rst_n)

        begin
            if rst_n = '0' then

                seq_pll_inc_dec_n      <= '0';
                seq_pll_start_reconfig <= '0';
                seq_pll_select         <= (others => '0');

                dgrb_phs_shft_busy     <= '0';

                -- static resync setup variables for sim time reductions
                if SIM_TIME_REDUCTIONS = 1 then
                    static_rst_offset    <= c_preset_codvw_phase;
                else
                    static_rst_offset    <= 0;
                end if;

                phs_shft_busy_1r     <= '0';
                pll_set_delay        <= 100;

            elsif rising_edge(clk) then

                dgrb_phs_shft_busy         <= '0';

                if static_rst_offset /= 0 and   -- not finished decrementing
                   pll_set_delay = 0 and        -- initial reset period over
                   SIM_TIME_REDUCTIONS = 1 then -- in reduce sim time mode (optimse logic away when not in this mode)

                            seq_pll_inc_dec_n      <= '1';
                            seq_pll_start_reconfig <= '1';
                            seq_pll_select         <= pll_resync_clk_index;

                            if seq_pll_phs_shift_busy_ccd = '1' then -- no metastability hardening needed in simulation
                                -- PLL phase shift started - so stop requesting a shift
                                seq_pll_start_reconfig <= '0';
                            end if;

                            if seq_pll_phs_shift_busy_ccd = '0' and phs_shft_busy_1r = '1' then
                                -- PLL phase shift finished - so proceed to flush the datapath
                                static_rst_offset    <= static_rst_offset - 1;
                                seq_pll_start_reconfig <= '0';
                            end if;

                            phs_shft_busy_1r <= seq_pll_phs_shift_busy_ccd;

                else

                    if ctrl_iram_push.active_block = ret_dgrb then
                        seq_pll_inc_dec_n      <= dgrb_pll_inc_dec_n;
                        seq_pll_start_reconfig <= dgrb_pll_start_reconfig;
                        seq_pll_select         <= dgrb_pll_select;
                        dgrb_phs_shft_busy     <= seq_pll_phs_shift_busy_ccd;
                    else
                        seq_pll_inc_dec_n      <= mmi_pll_inc_dec_n;
                        seq_pll_start_reconfig <= mmi_pll_start_reconfig;
                        seq_pll_select         <= mmi_pll_select;
                    end if;

                end if;

                if pll_set_delay /= 0 then
                    pll_set_delay <= pll_set_delay - 1;
                end if;

                if ctl_recalibrate_req = '1' then
                    pll_set_delay <= 100;
                end if;

            end if;
        end process;



        -- generate mmi pll signals
        process (clk, rst_n)

        begin
          if rst_n = '0' then

              pll_mmi.pll_busy              <= '0';
              pll_mmi.err                   <= (others => '0');
              mmi_pll_inc_dec_n             <= '0';
              mmi_pll_start_reconfig        <= '0';
              mmi_pll_select                <= (others => '0');
              mmi_pll_active                <= false;
              seq_pll_phs_shift_busy_ccd_1t <= '0';

          elsif rising_edge(clk) then

              if mmi_pll_active = true then
                  pll_mmi.pll_busy <= '1';
              else
                  pll_mmi.pll_busy <= mmi_pll.pll_phs_shft_up_wc or mmi_pll.pll_phs_shft_dn_wc;
              end if;

              if    pll_mmi.err = "00" and dgrb_pll_start_reconfig = '1' then
                pll_mmi.err <= "01";
              elsif pll_mmi.err = "00" and mmi_pll_active = true then
                pll_mmi.err <= "10";
              elsif pll_mmi.err = "00" and dgrb_pll_start_reconfig = '1' and mmi_pll_active = true then
                pll_mmi.err <= "11";
              end if;

              if mmi_pll.pll_phs_shft_up_wc = '1' and mmi_pll_active = false then
                  mmi_pll_inc_dec_n <= '1';
                  mmi_pll_select    <= std_logic_vector(to_unsigned(mmi_pll.pll_phs_shft_phase_sel,mmi_pll_select'length));
                  mmi_pll_active    <= true;

              elsif mmi_pll.pll_phs_shft_dn_wc = '1' and mmi_pll_active = false  then
                  mmi_pll_inc_dec_n <= '0';
                  mmi_pll_select    <= std_logic_vector(to_unsigned(mmi_pll.pll_phs_shft_phase_sel,mmi_pll_select'length));
                  mmi_pll_active    <= true;

              elsif seq_pll_phs_shift_busy_ccd_1t = '1' and seq_pll_phs_shift_busy_ccd = '0' then
                  mmi_pll_start_reconfig <= '0';
                  mmi_pll_active         <= false;

              elsif mmi_pll_active = true and mmi_pll_start_reconfig = '0' and seq_pll_phs_shift_busy_ccd = '0' then
                  mmi_pll_start_reconfig <= '1';

              elsif seq_pll_phs_shift_busy_ccd_1t = '0' and seq_pll_phs_shift_busy_ccd = '1' then
                  mmi_pll_start_reconfig <= '0';

              end if;

              seq_pll_phs_shift_busy_ccd_1t <= seq_pll_phs_shift_busy_ccd;

          end if;
        end process;

    end block; -- pll_ctrl

--synopsys synthesis_off

    reporting : block

        function pass_or_fail_report( cal_success : in std_logic;
                                      cal_fail    : in std_logic
                                    ) return string is
        begin
            if cal_success = '1' and cal_fail = '1' then
                return "unknown state cal_fail and cal_success both high";
            end if;
            if cal_success = '1' then
                return "PASSED";
            end if;
            if cal_fail = '1' then
                return "FAILED";
            end if;
            return "calibration report run whilst sequencer is still calibrating";
        end function;

        function is_stage_disabled ( stage_name : in string;
                                     stage_dis  : in std_logic
                                   ) return string is
        begin
            if stage_dis = '0' then
                return "";
            else
                return stage_name & " stage is disabled" & LF;
            end if;
        end function;

        function disabled_stages ( capabilities : in std_logic_vector
                                 ) return string is
        begin
            return is_stage_disabled("all calibration",                              c_capabilities(c_hl_css_reg_cal_dis_bit)) &
                   is_stage_disabled("initialisation",                               c_capabilities(c_hl_css_reg_phy_initialise_dis_bit)) &
                   is_stage_disabled("DRAM initialisation",                          c_capabilities(c_hl_css_reg_init_dram_dis_bit)) &
                   is_stage_disabled("iram header write",                            c_capabilities(c_hl_css_reg_write_ihi_dis_bit)) &
                   is_stage_disabled("burst training pattern write",                 c_capabilities(c_hl_css_reg_write_btp_dis_bit)) &
                   is_stage_disabled("more training pattern (MTP) write",            c_capabilities(c_hl_css_reg_write_mtp_dis_bit)) &
                   is_stage_disabled("check MTP pattern alignment calculation",      c_capabilities(c_hl_css_reg_read_mtp_dis_bit)) &
                   is_stage_disabled("read resynch phase reset stage",               c_capabilities(c_hl_css_reg_rrp_reset_dis_bit)) &
                   is_stage_disabled("read resynch phase sweep stage",               c_capabilities(c_hl_css_reg_rrp_sweep_dis_bit)) &
                   is_stage_disabled("read resynch phase seek stage (set phase)",    c_capabilities(c_hl_css_reg_rrp_seek_dis_bit)) &
                   is_stage_disabled("read data valid window setup",                 c_capabilities(c_hl_css_reg_rdv_dis_bit)) &
                   is_stage_disabled("postamble calibration",                        c_capabilities(c_hl_css_reg_poa_dis_bit)) &
                   is_stage_disabled("write latency timing calc",                    c_capabilities(c_hl_css_reg_was_dis_bit)) &
                   is_stage_disabled("advertise read latency",                       c_capabilities(c_hl_css_reg_adv_rd_lat_dis_bit)) &
                   is_stage_disabled("advertise write latency",                      c_capabilities(c_hl_css_reg_adv_wr_lat_dis_bit)) &
                   is_stage_disabled("write customer mode register settings",        c_capabilities(c_hl_css_reg_prep_customer_mr_setup_dis_bit)) &
                   is_stage_disabled("tracking",                                     c_capabilities(c_hl_css_reg_tracking_dis_bit));
        end function;

        function ac_nt_report(  ac_nt                : in std_logic_vector;
                                dgrb_ctrl_ac_nt_good : in std_logic;
                                preset_cal_setup     : in t_preset_cal) return string
        is
            variable v_ac_nt : std_logic_vector(0 downto 0);
        begin
            if SIM_TIME_REDUCTIONS = 1 then
                v_ac_nt(0) := preset_cal_setup.ac_1t;

                if v_ac_nt(0) = '1' then
                    return "-- statically set address and command 1T delay: add 1T delay" & LF;
                else
                    return "-- statically set address and command 1T delay: no 1T delay" & LF;
                end if;

            else
                v_ac_nt(0) := ac_nt(0);

                if dgrb_ctrl_ac_nt_good = '1' then
                    if v_ac_nt(0) = '1' then
                        return "-- chosen address and command 1T delay: add 1T delay" & LF;
                    else
                        return "-- chosen address and command 1T delay: no 1T delay" & LF;
                    end if;
                else
                    return "-- no valid address and command phase chosen (calibration FAILED)" & LF;
                end if;

            end if;

        end function;

        function read_resync_report ( codvw_phase      : in std_logic_vector;
                                      codvw_size       : in std_logic_vector;
                                      ctl_rlat         : in std_logic_vector;
                                      ctl_wlat         : in std_logic_vector;
                                      preset_cal_setup : in t_preset_cal) return string
        is
        begin
            if SIM_TIME_REDUCTIONS = 1 then
                return "-- read resynch phase static setup (no calibration run) report:" & LF &
                       "    -- statically set centre of data valid window phase : " & natural'image(preset_cal_setup.codvw_phase) & LF &
                       "    -- statically set centre of data valid window size  : " & natural'image(preset_cal_setup.codvw_size) & LF &
                       "    -- statically set read latency (ctl_rlat)           : " & natural'image(preset_cal_setup.rlat) & LF &
                       "    -- statically set write latency (ctl_wlat)          : " & natural'image(preset_cal_setup.wlat) & LF &
                       "    -- note: this mode only works for simulation and sets resync phase" & LF &
                       "             to a known good operating condition for no test bench" & LF &
                       "             delays on mem_dq signal" & LF;
            else
                return "-- PHY read latency (ctl_rlat) is  : " & natural'image(to_integer(unsigned(ctl_rlat))) & LF &
                       "-- address/command to PHY write latency (ctl_wlat) is : " & natural'image(to_integer(unsigned(ctl_wlat))) & LF &
                       "-- read resynch phase calibration report:" & LF &
                       "    -- calibrated centre of data valid window phase : " & natural'image(to_integer(unsigned(codvw_phase))) & LF &
                       "    -- calibrated centre of data valid window size  : " & natural'image(to_integer(unsigned(codvw_size))) & LF;
            end if;
        end function;

        function poa_rdv_adjust_report( poa_adjust : in natural;
                                        rdv_adjust : in natural;
                                        preset_cal_setup : in t_preset_cal) return string
        is
        begin
            if SIM_TIME_REDUCTIONS = 1 then
                return "Statically set poa and rdv (adjustments from reset value):" & LF &
                       "poa 'dec' adjustments = " & natural'image(preset_cal_setup.poa_lat) & LF &
                       "rdv 'dec' adjustments = " & natural'image(preset_cal_setup.rdv_lat) & LF;
            else
                return "poa 'dec' adjustments = " & natural'image(poa_adjust) & LF &
                       "rdv 'dec' adjustments = " & natural'image(rdv_adjust) & LF;

            end if;
        end function;

        function calibration_report ( capabilities : in std_logic_vector;
                                      cal_success  : in std_logic;
                                      cal_fail     : in std_logic;
                                      ctl_rlat     : in std_logic_vector;
                                      ctl_wlat     : in std_logic_vector;
                                      codvw_phase  : in std_logic_vector;
                                      codvw_size   : in std_logic_vector;
                                      ac_nt        : in std_logic_vector;
                                      dgrb_ctrl_ac_nt_good : in std_logic;
                                      preset_cal_setup : in t_preset_cal;
                                      poa_adjust : in natural;
                                      rdv_adjust : in natural) return string
        is

        begin
            return seq_report_prefix & " report..." & LF &
                   "-----------------------------------------------------------------------" & LF &
                   "-- **** ALTMEMPHY CALIBRATION has completed ****" & LF &
                   "-- Status:"  & LF &
                   "-- calibration has  : " & pass_or_fail_report(cal_success, cal_fail) & LF &
                   read_resync_report(codvw_phase, codvw_size, ctl_rlat, ctl_wlat, preset_cal_setup) &
                   ac_nt_report(ac_nt, dgrb_ctrl_ac_nt_good, preset_cal_setup) &
                   poa_rdv_adjust_report(poa_adjust, rdv_adjust, preset_cal_setup) &
                   disabled_stages(capabilities) &
                   "-----------------------------------------------------------------------";
        end function;

    begin

        -- -------------------------------------------------------
        -- calibration result reporting
        -- -------------------------------------------------------
        process(rst_n, clk)
        variable v_reports_written : std_logic;
        variable v_cal_request_r   : std_logic;
        variable v_rewrite_report  : std_logic;

        begin
            if rst_n = '0' then
                v_reports_written := '0';
                v_cal_request_r   := '0';
                v_rewrite_report  := '0';

            elsif Rising_Edge(clk) then
                if v_reports_written = '0' then
                    if ctl_init_success_int = '1' or ctl_init_fail_int = '1' then
                        v_reports_written := '1';

                        report calibration_report(c_capabilities,
                                                  ctl_init_success_int,
                                                  ctl_init_fail_int,
                                                  seq_ctl_rlat_int,
                                                  seq_ctl_wlat_int,
                                                  dgrb_mmi.cal_codvw_phase,
                                                  dgrb_mmi.cal_codvw_size,
                                                  int_ac_nt,
                                                  dgrb_ctrl_ac_nt_good,
                                                  c_preset_cal_setup,
                                                  poa_adjustments,
                                                  rdv_adjustments
                                                 ) severity note;

                    end if;
                end if;

                -- if recalibrate request triggered watch for cal success / fail going low and re-trigger report writing
                if ctl_recalibrate_req = '1' and v_cal_request_r = '0' then
                    v_rewrite_report := '1';
                end if;
                if v_rewrite_report = '1' and ctl_init_success_int = '0' and ctl_init_fail_int = '0' then
                    v_reports_written := '0';
                    v_rewrite_report  := '0';
                end if;

                v_cal_request_r := ctl_recalibrate_req;
            end if;
        end process;

        -- -------------------------------------------------------
        -- capabilities vector reporting and coarse PHY setup sanity checks
        -- -------------------------------------------------------

        process(rst_n, clk)
        variable reports_written : std_logic;
        begin
            if rst_n = '0' then
                reports_written := '0';

            elsif Rising_Edge(clk) then

                if reports_written = '0' then
                    reports_written := '1';
                    if MEM_IF_MEMTYPE="DDR" or MEM_IF_MEMTYPE="DDR2" or MEM_IF_MEMTYPE="DDR3" then
                        if DWIDTH_RATIO = 2 or DWIDTH_RATIO = 4 then
                            report disabled_stages(c_capabilities) severity note;
                        else
                            report seq_report_prefix & "unsupported rate for non-levelling AFI PHY sequencer - only full- or half-rate supported" severity warning;
                        end if;
                    else
                        report seq_report_prefix & "memory type " & MEM_IF_MEMTYPE & " is not supported in non-levelling AFI PHY sequencer" severity failure;
                    end if;
                end if;
            end if;

        end process;

    end block;  -- reporting

--synopsys synthesis_on

end architecture struct;
