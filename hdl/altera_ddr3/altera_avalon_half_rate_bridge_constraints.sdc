
# Constraint multicycle path for "Altera Avalon MM DDR Memory Half Rate Bridge"
#-------------------------------------------------------------------------------
#    You need to apply constraint below to EVERY INSTANCE of "Altera Avalon MM DDR Memory Half Rate Bridge" in your system
#
# Variable :
# ----------
#   "slow_clk"  : Path of the clock that connect to half_rate_bridge_0's Slave interface.
#                 This should be the path of DDR SDRAM's AuxHalf clock.
#   "instance"  : The instance name of the Altera Avalon MM DDR Memory Half Rate Bridge
#
# Example :
# ---------
#   set     slow_clk    "*|the_ddr2_sdram|ddr2_sdram_controller_phy_inst|alt_mem_phy_inst|ddr2_sdram_phy_alt_mem_phy_inst|clk|pll|altpll_component|auto_generated|pll1|clk\[0\]"
#   set     instance    "half_rate_bridge_0"
#
# To source this SDC file :
# ----------------------
#   Copy this file to your Quartus project directory 
#   and add the line below at the end of the Quartus Setting File
#
#      set_global_assignment -name SDC_FILE altera_avalon_half_rate_bridge_constraints.sdc
#
# Note :
# ------
#   make sure that the clock $slow_clk already created/declared (using derive_pll_clocks / create_clock / create_generated_clock etc) before running constraint below,
#   otherwise, Quartus will complaint that $lslow_clk could not be matched with a clock, and constraint below will be ignored.
#
#
#-----------------------------------------------------------------------------------------------

derive_pll_clocks 
set slow_clk    "*|altpll_component|auto_generated|pll1|clk[1]"
set instance    "HRB_inst"

set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_read]                -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_read]                -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_write]               -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_write]               -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_state*]              -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_state*]              -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_rd_txfers*]          -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_rd_txfers*]          -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_wr_txfers*]          -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_wr_txfers*]          -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_rd_data_txfers*]     -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_rd_data_txfers*]     -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_readdata_r*]         -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_readdata_r*]         -hold   -end 1
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_skid*]               -setup  -end 2
set_multicycle_path -from [get_clocks $slow_clk] -to [get_registers *|altera_avalon_half_rate_bridge:${instance}|avm_skid*]               -hold   -end 1
