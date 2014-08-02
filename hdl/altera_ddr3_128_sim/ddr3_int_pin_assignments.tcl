# -------------------------------------------------------------------------
#
# ALTMEMPHY v10.0 DDR3 SDRAM pin constraints script for ddr3_int
#
# Please run this script before compiling your design
#
# Directions: If your top level pin names do not match the default names, 
#             you should change the variables below to make the constraints 
#             match the specific pin names in your top level design.
#
#
# Make your changes below this line
# --------------------------------------------------------------------------

# Change sopc_mode value from NO to YES to create assignments that match the
# SOPC Builder top level pin names
if {![info exists sopc_mode]} {set sopc_mode NO}

# This is the name of your controller instance
set instance_name ""

# This is the prefix for all pin names. Change it if you wish to choose
# a prefix other than mem_
if {![info exists pin_prefix]} {set pin_prefix "mem_"}


# In SOPC builder, the pin names will be expanded as follow:
#    Example: mem_cs_n_from_the_<your instance name>
#
# In standalone mode, the pin names will be expanded as follow:
#    Example: mem_cs_n[0]

set mem_odt_pin_name ${pin_prefix}odt
set mem_odt_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_odt_IO_STANDARD "SSTL-15 CLASS I"

set mem_clk_pin_name ${pin_prefix}clk
set mem_clk_IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I"
set mem_clk_OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"

set mem_clk_n_pin_name ${pin_prefix}clk_n
set mem_clk_n_IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I"
set mem_clk_n_OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"

set mem_cs_n_pin_name ${pin_prefix}cs_n
set mem_cs_n_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_cs_n_IO_STANDARD "SSTL-15 CLASS I"

set mem_cke_pin_name ${pin_prefix}cke
set mem_cke_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_cke_IO_STANDARD "SSTL-15 CLASS I"

set mem_addr_pin_name ${pin_prefix}addr
set mem_addr_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_addr_IO_STANDARD "SSTL-15 CLASS I"

set mem_ba_pin_name ${pin_prefix}ba
set mem_ba_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_ba_IO_STANDARD "SSTL-15 CLASS I"

set mem_ras_n_pin_name ${pin_prefix}ras_n
set mem_ras_n_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_ras_n_IO_STANDARD "SSTL-15 CLASS I"

set mem_cas_n_pin_name ${pin_prefix}cas_n
set mem_cas_n_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_cas_n_IO_STANDARD "SSTL-15 CLASS I"

set mem_we_n_pin_name ${pin_prefix}we_n
set mem_we_n_CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"
set mem_we_n_IO_STANDARD "SSTL-15 CLASS I"

set mem_dq_pin_name ${pin_prefix}dq
set mem_dq_IO_STANDARD "SSTL-15 CLASS I"
set mem_dq_OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"

set mem_dqs_pin_name ${pin_prefix}dqs
set mem_dqs_IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I"
set mem_dqs_OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"

set mem_dqsn_pin_name ${pin_prefix}dqsn
set mem_dqsn_IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I"
set mem_dqsn_OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"

set mem_dm_pin_name ${pin_prefix}dm
set mem_dm_IO_STANDARD "SSTL-15 CLASS I"
set mem_dm_OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"


# Do not make any changes after this line
# ------------------------------------------------

# This single_bit variable is to define whether a [0] index will be added at the end of a single-bit bus pin name
# To not have indexing, replace [0] by "".
set single_bit {[0]}

switch $sopc_mode {
  YES {
    set output_suffix _from_the_${instance_name}
    set bidir_suffix _to_and_from_the_${instance_name}
    set input_suffix _to_the_${instance_name}
  }
  default {
    set output_suffix ""
    set bidir_suffix ""
    set input_suffix ""
  }
}

set delay_chain_config "Flexible_timing"

if {![info exists ::ppl_instance_name]} {set ::ppl_instance_name {}}

set mem_odt_pin_name ${::ppl_instance_name}${mem_odt_pin_name}${output_suffix}
set mem_clk_pin_name ${::ppl_instance_name}${mem_clk_pin_name}${bidir_suffix}
set mem_clk_n_pin_name ${::ppl_instance_name}${mem_clk_n_pin_name}${bidir_suffix}
set mem_cs_n_pin_name ${::ppl_instance_name}${mem_cs_n_pin_name}${output_suffix}
set mem_cke_pin_name ${::ppl_instance_name}${mem_cke_pin_name}${output_suffix}
set mem_addr_pin_name ${::ppl_instance_name}${mem_addr_pin_name}${output_suffix}
set mem_ba_pin_name ${::ppl_instance_name}${mem_ba_pin_name}${output_suffix}
set mem_ras_n_pin_name ${::ppl_instance_name}${mem_ras_n_pin_name}${output_suffix}
set mem_cas_n_pin_name ${::ppl_instance_name}${mem_cas_n_pin_name}${output_suffix}
set mem_we_n_pin_name ${::ppl_instance_name}${mem_we_n_pin_name}${output_suffix}
set mem_dq_pin_name ${::ppl_instance_name}${mem_dq_pin_name}${bidir_suffix}
set mem_dqs_pin_name ${::ppl_instance_name}${mem_dqs_pin_name}${bidir_suffix}
set mem_dqsn_pin_name ${::ppl_instance_name}${mem_dqsn_pin_name}${bidir_suffix}
set mem_dm_pin_name ${::ppl_instance_name}${mem_dm_pin_name}${output_suffix}

set_instance_assignment -name IO_STANDARD "${mem_odt_IO_STANDARD}" -to ${mem_odt_pin_name}${single_bit}
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_odt_CURRENT_STRENGTH_NEW}" -to ${mem_odt_pin_name}${single_bit}
set_instance_assignment -name IO_STANDARD "${mem_clk_IO_STANDARD}" -to ${mem_clk_pin_name}${single_bit}
set_instance_assignment -name OUTPUT_TERMINATION "${mem_clk_OUTPUT_TERMINATION}" -to ${mem_clk_pin_name}${single_bit}
set_instance_assignment -name IO_STANDARD "${mem_clk_n_IO_STANDARD}" -to ${mem_clk_n_pin_name}${single_bit}
set_instance_assignment -name OUTPUT_TERMINATION "${mem_clk_n_OUTPUT_TERMINATION}" -to ${mem_clk_n_pin_name}${single_bit}
set_instance_assignment -name IO_STANDARD "${mem_cs_n_IO_STANDARD}" -to ${mem_cs_n_pin_name}${single_bit}
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_cs_n_CURRENT_STRENGTH_NEW}" -to ${mem_cs_n_pin_name}${single_bit}
set_instance_assignment -name IO_STANDARD "${mem_cke_IO_STANDARD}" -to ${mem_cke_pin_name}${single_bit}
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_cke_CURRENT_STRENGTH_NEW}" -to ${mem_cke_pin_name}${single_bit}
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[0]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[1]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[2]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[3]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[4]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[4]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[5]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[5]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[6]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[6]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[7]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[7]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[8]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[8]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[9]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[9]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[10]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[10]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[11]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[11]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[12]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[12]
set_instance_assignment -name IO_STANDARD "${mem_addr_IO_STANDARD}" -to ${mem_addr_pin_name}[13]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_addr_CURRENT_STRENGTH_NEW}" -to ${mem_addr_pin_name}[13]
set_instance_assignment -name IO_STANDARD "${mem_ba_IO_STANDARD}" -to ${mem_ba_pin_name}[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_ba_CURRENT_STRENGTH_NEW}" -to ${mem_ba_pin_name}[0]
set_instance_assignment -name IO_STANDARD "${mem_ba_IO_STANDARD}" -to ${mem_ba_pin_name}[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_ba_CURRENT_STRENGTH_NEW}" -to ${mem_ba_pin_name}[1]
set_instance_assignment -name IO_STANDARD "${mem_ba_IO_STANDARD}" -to ${mem_ba_pin_name}[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_ba_CURRENT_STRENGTH_NEW}" -to ${mem_ba_pin_name}[2]
set_instance_assignment -name IO_STANDARD "${mem_ras_n_IO_STANDARD}" -to ${mem_ras_n_pin_name}
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_ras_n_CURRENT_STRENGTH_NEW}" -to ${mem_ras_n_pin_name}
set_instance_assignment -name IO_STANDARD "${mem_cas_n_IO_STANDARD}" -to ${mem_cas_n_pin_name}
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_cas_n_CURRENT_STRENGTH_NEW}" -to ${mem_cas_n_pin_name}
set_instance_assignment -name IO_STANDARD "${mem_we_n_IO_STANDARD}" -to ${mem_we_n_pin_name}
set_instance_assignment -name CURRENT_STRENGTH_NEW "${mem_we_n_CURRENT_STRENGTH_NEW}" -to ${mem_we_n_pin_name}
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[0]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[0]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[1]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[1]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[2]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[2]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[3]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[3]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[4]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[4]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[5]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[5]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[6]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[6]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[7]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[7]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[8]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[8]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[9]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[9]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[10]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[10]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[11]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[11]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[12]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[12]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[13]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[13]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[14]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[14]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[15]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[15]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[16]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[16]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[17]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[17]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[18]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[18]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[19]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[19]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[20]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[20]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[21]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[21]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[22]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[22]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[23]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[23]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[24]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[24]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[25]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[25]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[26]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[26]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[27]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[27]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[28]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[28]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[29]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[29]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[30]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[30]
set_instance_assignment -name IO_STANDARD "${mem_dq_IO_STANDARD}" -to ${mem_dq_pin_name}[31]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dq_OUTPUT_TERMINATION}" -to ${mem_dq_pin_name}[31]
set_instance_assignment -name IO_STANDARD "${mem_dqs_IO_STANDARD}" -to ${mem_dqs_pin_name}[0]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqs_OUTPUT_TERMINATION}" -to ${mem_dqs_pin_name}[0]
set_instance_assignment -name IO_STANDARD "${mem_dqs_IO_STANDARD}" -to ${mem_dqs_pin_name}[1]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqs_OUTPUT_TERMINATION}" -to ${mem_dqs_pin_name}[1]
set_instance_assignment -name IO_STANDARD "${mem_dqs_IO_STANDARD}" -to ${mem_dqs_pin_name}[2]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqs_OUTPUT_TERMINATION}" -to ${mem_dqs_pin_name}[2]
set_instance_assignment -name IO_STANDARD "${mem_dqs_IO_STANDARD}" -to ${mem_dqs_pin_name}[3]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqs_OUTPUT_TERMINATION}" -to ${mem_dqs_pin_name}[3]
set_instance_assignment -name IO_STANDARD "${mem_dqsn_IO_STANDARD}" -to ${mem_dqsn_pin_name}[0]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqsn_OUTPUT_TERMINATION}" -to ${mem_dqsn_pin_name}[0]
set_instance_assignment -name IO_STANDARD "${mem_dqsn_IO_STANDARD}" -to ${mem_dqsn_pin_name}[1]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqsn_OUTPUT_TERMINATION}" -to ${mem_dqsn_pin_name}[1]
set_instance_assignment -name IO_STANDARD "${mem_dqsn_IO_STANDARD}" -to ${mem_dqsn_pin_name}[2]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqsn_OUTPUT_TERMINATION}" -to ${mem_dqsn_pin_name}[2]
set_instance_assignment -name IO_STANDARD "${mem_dqsn_IO_STANDARD}" -to ${mem_dqsn_pin_name}[3]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dqsn_OUTPUT_TERMINATION}" -to ${mem_dqsn_pin_name}[3]
set_instance_assignment -name IO_STANDARD "${mem_dm_IO_STANDARD}" -to ${mem_dm_pin_name}[0]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dm_OUTPUT_TERMINATION}" -to ${mem_dm_pin_name}[0]
set_instance_assignment -name IO_STANDARD "${mem_dm_IO_STANDARD}" -to ${mem_dm_pin_name}[1]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dm_OUTPUT_TERMINATION}" -to ${mem_dm_pin_name}[1]
set_instance_assignment -name IO_STANDARD "${mem_dm_IO_STANDARD}" -to ${mem_dm_pin_name}[2]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dm_OUTPUT_TERMINATION}" -to ${mem_dm_pin_name}[2]
set_instance_assignment -name IO_STANDARD "${mem_dm_IO_STANDARD}" -to ${mem_dm_pin_name}[3]
set_instance_assignment -name OUTPUT_TERMINATION "${mem_dm_OUTPUT_TERMINATION}" -to ${mem_dm_pin_name}[3]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[0]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[1]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[2]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[3]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[4]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[5]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[6]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[7]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[8]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[9]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[10]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[11]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[12]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[13]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[14]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[15]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[16]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[17]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[18]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[19]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[20]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[21]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[22]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[23]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[24]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[25]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[26]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[27]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[28]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[29]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[30]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dq_pin_name}[31]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[0]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[1]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[2]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[3]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[4]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[5]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[6]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[7]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[8]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[9]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[10]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[11]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[12]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[13]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[14]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[15]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[16]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[17]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[18]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[19]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[20]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[21]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[22]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[23]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[24]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[25]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[26]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[27]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[28]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[29]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[30]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dq_pin_name}[31]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqs_pin_name}[0]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqs_pin_name}[1]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqs_pin_name}[2]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqs_pin_name}[3]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqs_pin_name}[0]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqs_pin_name}[1]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqs_pin_name}[2]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqs_pin_name}[3]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqsn_pin_name}[0]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqsn_pin_name}[1]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqsn_pin_name}[2]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dqsn_pin_name}[3]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqsn_pin_name}[0]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqsn_pin_name}[1]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqsn_pin_name}[2]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dqsn_pin_name}[3]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dm_pin_name}[0]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dm_pin_name}[1]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dm_pin_name}[2]
set_instance_assignment -name MEM_INTERFACE_DELAY_CHAIN_CONFIG "${delay_chain_config}" -to ${mem_dm_pin_name}[3]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dm_pin_name}[0]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dm_pin_name}[1]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dm_pin_name}[2]
set_instance_assignment -name OUTPUT_ENABLE_GROUP "57186609" -to ${mem_dm_pin_name}[3]

unset pin_prefix
