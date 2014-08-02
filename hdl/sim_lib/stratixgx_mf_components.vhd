--
-- Copyright (C) 1988-2005 Altera Corporation
--
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any
-- other associated documentation or information provided by Altera or a
-- partner under Altera's Megafunction Partnership Program may be used only
-- to program PLD devices (but not masked PLD devices) from Altera.  Any
-- other use of such megafunction design, net list, support information,
-- device programming or simulation file, or any other related
-- documentation or information is prohibited for any other purpose,
-- including, but not limited to modification, reverse engineering, de-
-- compiling, or use with any other silicon devices, unless such use is
-- explicitly licensed under a separate agreement with Altera or a
-- megafunction partner.  Title to the intellectual property, including
-- patents, copyrights, trademarks, trade secrets, or maskworks, embodied
-- in any such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information provided by Altera or a megafunction partner, remains with
-- Altera, the megafunction partner, or their respective licensors.  No
-- other licenses, including any licenses needed under any third party's
-- intellectual property, are provided herein.
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- ALtera Stratix GX Altgxb Megafunction Component Declaration File
--

library ieee;
use ieee.std_logic_1164.all;
use work.pllpack1.all;

package stratixgx_mf_components is
component altgxb
        generic (
                operation_mode               : string := "DUPLEX";
                loopback_mode                : string := "NONE";
                reverse_loopback_mode        : string := "NONE";
                protocol                     : string := "CUSTOM";
                number_of_channels           : integer := 20;
                number_of_quads              : integer := 1;
                channel_width                : positive := 20;
                pll_inclock_period           : integer  := 20000;
                data_rate                    : integer := 0;
                data_rate_remainder          : integer := 0; 

                rx_data_rate                 : integer := 0;
                rx_data_rate_remainder       : integer := 0; 

                use_8b_10b_mode              : string := "OFF";
                use_double_data_mode         : string := "OFF";
                dwidth_factor                : integer := 1;
                
                -- RX Mode
                disparity_mode               : string := "OFF";
                cru_inclock_period           : integer := 0;             -- Units in ps
                run_length                   : integer := 128;
                run_length_enable            : string := "OFF";
                use_channel_align            : string := "OFF";
                use_auto_bit_slip            : string := "OFF";
                use_rate_match_fifo          : string := "OFF";
                use_symbol_align             : string := "OFF";
                align_pattern                : string := "X";
                align_pattern_length         : integer := 0;
                infiniband_invalid_code      : integer := 0;
                clk_out_mode_reference       : string := "ON";
                -- TX Mode
                use_fifo_mode                : string := "ON";
                intended_device_family       : string := "STRATIXGX";
                force_disparity_mode         : string := "OFF";
                lpm_type                     : string := "altgxb";
                tx_termination               : integer := 0;
                -- Quartus 2.2 New Parameters
                -- common
                use_self_test_mode           : string := "OFF";
                self_test_mode               : integer := 0;

                -- Quartus 5.0 New Parameters
                allow_gxb_merging            : string := "OFF";   
    
                -- Receiver
                use_equalizer_ctrl_signal    : string := "OFF";
                equalizer_ctrl_setting       : integer := 0;
                signal_threshold_select      : integer := 80;
                rx_bandwidth_type            : string := "NEW_MEDIUM";
                rx_enable_dc_coupling        : string := "OFF";
                use_vod_ctrl_signal          : string := "OFF";
                vod_ctrl_setting             : integer := 1000;
                use_preemphasis_ctrl_signal  : string := "OFF";
                preemphasis_ctrl_setting     : integer := 0;
                use_phase_shift              : string := "ON";
                pll_bandwidth_type           : string := "LOW";
                pll_use_dc_coupling          : string := "OFF";
                rx_ppm_setting               : integer := 1000;
                use_generic_fifo             : string := "OFF";
                use_rx_cruclk                : string := "OFF";
                use_rx_clkout                : string := "OFF";
                use_rx_coreclk               : string := "OFF";
                use_tx_coreclk               : string := "OFF";
                instantiate_transmitter_pll  : string := "OFF";
                consider_instantiate_transmitter_pll_param : string := "OFF";
                rx_force_signal_detect       : string := "OFF";
                flip_rx_out                  : string := "OFF";
                flip_tx_in                   : string := "OFF";
                add_generic_fifo_we_synch_register : string := "OFF";
                consider_enable_tx_8b_10b_i1i2_generation  : string := "OFF";
                enable_tx_8b_10b_i1i2_generation  : string := "OFF";
                for_engineering_sample_device : string := "ON";    
                device_family                : string := "" 

              );

        port (  
                inclk             : in std_logic_vector(number_of_quads-1 downto 0) := (others => '0');
                rx_coreclk        : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                pll_areset        : in std_logic_vector(number_of_quads-1 downto 0):= (others => '0');
                rx_cruclk         : in std_logic_vector(number_of_quads - 1 downto 0)  := (others => '0');
                rx_in             : in std_logic_vector(number_of_channels-1 downto 0)  := (others => '0');
                rx_aclr           : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                rx_bitslip        : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
                rx_enacdet        : in std_logic_vector(number_of_channels-1 downto 0):= (others => '0');
                rx_we             : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
                rx_re             : in std_logic_vector(number_of_channels-1 downto 0):= (others => '0');
                rx_slpbk          : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
                rx_a1a2size       : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
                rx_equalizerctrl  : in std_logic_vector(number_of_channels * 3 -1 downto 0) := (others => '0');
                rx_locktorefclk   : in std_logic_vector(number_of_channels  -1 downto 0) := (others => '0');
                rx_locktodata     : in std_logic_vector(number_of_channels  -1 downto 0) := (others => '0');

                tx_in             : in std_logic_vector(channel_width * number_of_channels-1 downto 0) := (others => '0');
                tx_coreclk        : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                tx_aclr           : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                tx_ctrlenable     : in std_logic_vector(dwidth_factor * number_of_channels-1 downto 0) := (others => '0');
                tx_forcedisparity : in std_logic_vector(dwidth_factor * number_of_channels-1 downto 0) := (others => '0');
                tx_srlpbk         : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
                tx_vodctrl        : in std_logic_vector(number_of_channels * 3-1 downto 0) := (others => '0');
                tx_preemphasisctrl: in std_logic_vector(number_of_channels * 3-1 downto 0) := (others => '0');

        
                -- XGM Input ports, common for Both Rx and Tx Mode

                txdigitalreset    : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                rxdigitalreset    : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                rxanalogreset     : in std_logic_vector(number_of_channels - 1 downto 0) := (others => '0');
                pllenable         : in std_logic_vector(number_of_quads - 1 downto 0) := (others => '1');


                pll_locked        : out std_logic_vector(number_of_quads-1 downto 0);
                coreclk_out       : out std_logic_vector(number_of_quads-1 downto 0);
                rx_out            : out std_logic_vector(get_rx_channel_width(use_generic_fifo, 
                                     clk_out_mode_reference, channel_width) * number_of_channels-1 downto 0);
                rx_clkout         : out std_logic_vector(number_of_channels-1 downto 0);
                rx_locked         : out std_logic_vector(number_of_channels-1 downto 0);
                rx_freqlocked     : out std_logic_vector(number_of_channels-1 downto 0);
                rx_rlv            : out std_logic_vector(number_of_channels-1 downto 0);
                rx_syncstatus     : out std_logic_vector(get_rx_dwidth_factor(use_generic_fifo, 
                                     clk_out_mode_reference, dwidth_factor) * number_of_channels-1 downto 0);


                rx_patterndetect  : out std_logic_vector(get_rx_dwidth_factor(use_generic_fifo, 
                                     clk_out_mode_reference, dwidth_factor) * number_of_channels-1 downto 0);
                rx_ctrldetect     : out std_logic_vector(get_rx_dwidth_factor(use_generic_fifo, 
                                     clk_out_mode_reference, dwidth_factor) * number_of_channels-1 downto 0);
                rx_errdetect      : out std_logic_vector(get_rx_dwidth_factor(use_generic_fifo, 
                                     clk_out_mode_reference, dwidth_factor) * number_of_channels-1 downto 0);
                rx_disperr        : out std_logic_vector(get_rx_dwidth_factor(use_generic_fifo, 
                                     clk_out_mode_reference, dwidth_factor) * number_of_channels-1 downto 0);
                rx_signaldetect   : out std_logic_vector(number_of_channels-1 downto 0);
--                rx_fifoempty      : out std_logic_vector(number_of_channels-1 downto 0);
--                rx_fifofull       : out std_logic_vector(number_of_channels-1 downto 0);
                rx_fifoalmostempty: out std_logic_vector(number_of_channels-1 downto 0);
                rx_fifoalmostfull : out std_logic_vector(number_of_channels-1 downto 0);
                rx_channelaligned : out std_logic_vector(number_of_quads-1 downto 0);
                rx_bisterr        : out std_logic_vector(number_of_channels-1 downto 0);
                rx_bistdone       : out std_logic_vector(number_of_channels-1 downto 0);
                rx_a1a2sizeout    : out std_logic_vector(get_rx_dwidth_factor(use_generic_fifo, 
                                     clk_out_mode_reference, dwidth_factor) * number_of_channels-1 downto 0);
                tx_out            : out std_logic_vector(number_of_channels-1 downto 0)
             );

                
end component;



end stratixgx_mf_components;






