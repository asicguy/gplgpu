//#mw_delete ("")
/* Legal Notice: (C)2006 Altera Corporation. All rights reserved.  Your
   use of Altera Corporation's design tools, logic functions and other
   software and tools, and its AMPP partner logic functions, and any
   output files any of the foregoing (including device programming or
   simulation files), and any associated documentation or information are
   expressly subject to the terms and conditions of the Altera Program
   License Subscription Agreement or other applicable license agreement,
   including, without limitation, that your use is for the sole purpose
   of programming logic devices manufactured by Altera and sold by Altera
   or its authorized distributors.  Please refer to the applicable
   agreement for further details. */


/*-----------------------------------------------------------------------------
  Title           : Defines

  File:  $RCSfile : alt_mem_phy_defines.v,v $

  Last Modified   : $Date: 2011/08/15 $

  Revision        : $Revision: #1 $

  Abstract        : Defines file for the ALTMEMPHY.  This provides one file in
                    which all constant definitions can be contained, thus
                    ensuring continuity of naming and correct port widths
                    between blocks.
-----------------------------------------------------------------------------*/
//#end

// Set timescale to prevent warnings in simulation.
`timescale 1 ps / 1 ps

// These defines are constant values used in the PHY RTL :

// Check to see whether alt_mem_phy_defines is already defined.  If it is,
// then this define file has already been loaded, and so it is not necessary
// to set the defines.  Otherwise set the defines.

`ifdef ALT_MEM_PHY_DEFINES
`else

`define ALT_MEM_PHY_DEFINES

// Address and command defines :
`define ADC_NUM_PIN_GROUPS  8

`define ADC_ADDR_PERIOD_SEL  0
`define ADC_BA_PERIOD_SEL    1
`define ADC_CAS_N_PERIOD_SEL 2
`define ADC_CKE_PERIOD_SEL   3
`define ADC_ODT_PERIOD_SEL   4
`define ADC_RAS_N_PERIOD_SEL 5
`define ADC_WE_N_PERIOD_SEL  6
`define ADC_CS_N_PERIOD_SEL  7

// Clk and reset defines :

// PLL reconfiguration constants :

`define CLK_PLL_STEP_FORWARD 9'b000000011
`define CLK_PLL_STEP_BACK    9'b000000001
`define CLK_PLL_STEP_CANCEL  9'b000000000

`define CLK_PLL_RECONFIG_SELECT_PHASE_STEP 3'h2
`define CLK_PLL_INITIALISED   1'b1
`define CLK_PLL_UNINITIALISED 1'b0


`define CLK_PLL_RECONFIG_FSM_WIDTH               3
`define CLK_PLL_RECONFIG_IDLE                 3'h0
`define CLK_PLL_CLEAR_OLD_PHASE               3'h1
`define CLK_PLL_CLEAR_OLD_PHASE_WAIT_ON_BUSY  3'h2
`define CLK_PLL_SET_NEW_DIR                   3'h3
`define CLK_PLL_SET_NEW_DIR_WAIT_ON_BUSY      3'h4
`define CLK_PLL_REQUEST_UPDATE                3'h5
`define CLK_PLL_REQUEST_UPDATE_WAIT_ON_BUSY   3'h6
`define CLK_PLL_ILLEGAL_STATE                 3'h7



// Postamble defines
`define POA_OVERRIDE_VAL 2'b11
`define POA_OVERRIDE_VAL_FULL_RATE 1'b1


// Mimic path state machine defines
`define        MIMIC_FSM_WIDTH 3
`define        MIMIC_IDLE      3'b000
`define        MIMIC_SAMPLE    3'b001
`define        MIMIC_SEND      3'b010
`define        MIMIC_SEND1     3'b011
`define        MIMIC_SEND2     3'b100


// SIII DDR2/3 DQS Config atom defines :

`define     DQSCONFIG_DQS_OUTPUT_PHASE_SETTING_WIDTH      4
`define     DQSCONFIG_DQS_BUSOUT_DELAY_SETTING_WIDTH      4
`define     DQSCONFIG_DQS_INPUT_PHASE_SETTING_WIDTH       3
`define     DQSCONFIG_DQS_EN_CTRL_PHASE_SETTING_WIDTH     4
`define     DQSCONFIG_DQS_EN_DELAY_SETTING_WIDTH          3
`define     DQSCONFIG_DQS_OCT_DELAY_SETTING1_WIDTH        4
`define     DQSCONFIG_DQS_OCT_DELAY_SETTING2_WIDTH        3
                                                          
`define     DQSCONFIG_RESYNC_IP_PHASE_SETTING_WIDTH       4
`define     DQSCONFIG_DQ_OP_PHASE_SETTING_WIDTH           4

// SIII DDR2/3 IO Config atom defines :
`define     IOCONFIG_DQ_PAD_TO_IP_REG_DELAY_SETTING_WIDTH 4
`define     IOCONFIG_DQ_OUTPUT_DELAY_SETTING1_WIDTH       4
`define     IOCONFIG_DQ_OUTPUT_DELAY_SETTING2_WIDTH       3

`define     OCT_SERIES_TERM_CONTROL_WIDTH                 14
`define     OCT_PARALLEL_TERM_CONTROL_WIDTH               14

`define     SIII_ATOM_DELAY_DQ_T9                         0
`define     SIII_ATOM_DELAY_DQ_T10                        0
`define     SIII_ATOM_DELAY_DQOE_T9                       0
`define     SIII_ATOM_DELAY_DQOE_T10                      0
`define     SIII_ATOM_DELAY_OCT_T9                        0
`define     SIII_ATOM_DELAY_OCT_T10                       0

`define     SIII_ATOM_DELAY_DQ_T1                         0

`define     SIII_ATOM_DELAY_DQS_T9                        0
`define     SIII_ATOM_DELAY_DQS_T10                       0

`define     SIII_ATOM_DELAY_DQSOE_T9                      0
`define     SIII_ATOM_DELAY_DQSOE_T10                     0

`define     SIII_ATOM_DELAY_DQSOCT_T9                     0
`define     SIII_ATOM_DELAY_DQSOCT_T10                    0

`define     SIII_ATOM_DELAY_DQS_T7                        0
`define     SIII_ATOM_DELAY_DQSN_T7                       0

`define     SIII_ATOM_DELAY_DQS_T11                       0

`define     SIII_ATOM_DELAY_DM_T9                         0
`define     SIII_ATOM_DELAY_DM_T10                        0


`endif
