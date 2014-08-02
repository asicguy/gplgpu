##
##Legal Notice: (C)2007 Altera Corporation. All rights reserved. Your
##use of Altera Corporation's design tools, logic functions and other
##software and tools, and its AMPP partner logic functions, and any
##output files any of the foregoing (including device programming or
##simulation files), and any associated documentation or information are
##expressly subject to the terms and conditions of the Altera Program
##License Subscription Agreement or other applicable license agreement,
##including, without limitation, that your use is for the sole purpose
##of programming logic devices manufactured by Altera and sold by Altera
##or its authorized distributors. Please refer to the applicable
##agreement for further details.

##############################################################
## This report_timing script performs the timing analysis for
## all memory interfaces in the design.  In particular, this
## script will loop over all memory interface cores and
## instances and will timing analyze a range of paths that
## are applicable for each instance.  These include the
## timing analysis for the read capture, write, PHY
## address/command, and resynchronization paths among others.
##
## In performing the above timing analysis, the script
## calls procedures that are found in a separate file (report_timing_core.tcl)
## that has all the details of the timing analysis, and this
## file only serves as the top-level timing analysis flow.
##
## To reduce data lookups in all the procuedures that perform
## the individual timing analysis, data that is needed for
## multiple procedures is lookup up in this file and passed
## to the various parameters.  These data include both values
## that are applicable over all operating conditions, and those
## that are applicable to only one operating condition.
##
## In addition to the data that is looked up, the script
## and the underlying procedures use various other data
## that are stored in TCL sets and include the following:
##
##   t(.)     : Holds the memory timing parameters
##   board(.) : Holds the board skews and propagation delays
##   SSN(.)   : Holds the SSN pushout and pullin delays
##   IP(.)    : Holds the configuration of the memory interface
##              that was generated
##   ISI(.)   : Holds any intersymbol interference when the
##              memory interface is generated in a multirank
##              topology
##   MP(.)    : Holds some process variation data for the memory
##              See below for more information
##   pins(.)  : Holds the pin names for the memory interface
##
##############################################################

set corename "ddr3_int_phy"

##############################################################
## Some useful functions
##############################################################
source "[list [file join [file dirname [info script]] ${corename}_ddr_timing.tcl]]"
source "[list [file join [file dirname [info script]] ${corename}_ddr_pins.tcl]]"
source "[list [file join [file dirname [info script]] ${corename}_report_timing_core.tcl]]"

################################################################################
## When the ALTMEMPHY is targeted for the HardCopy device family, additional
## clock uncertainties need to be added. These uncertainties will be provided by
## the HardCopy Design Centre in a file called <variation name>_cu.tcl. They are
## not needed for the FPGA device families, and are set to zero in that case.
################################################################################

set ::fpga_tREAD_CAPTURE_SETUP_ERROR 0
set ::fpga_tREAD_CAPTURE_HOLD_ERROR 0
set ::fpga_RESYNC_SETUP_ERROR 0
set ::fpga_RESYNC_HOLD_ERROR 0
set ::fpga_PA_DQS_SETUP_ERROR 0
set ::fpga_PA_DQS_HOLD_ERROR 0
set ::WR_DQS_DQ_SETUP_ERROR 0
set ::WR_DQS_DQ_HOLD_ERROR 0
set ::fpga_tCK_ADDR_CTRL_SETUP_ERROR 0
set ::fpga_tCK_ADDR_CTRL_HOLD_ERROR 0
set ::fpga_tDQSS_SETUP_ERROR 0
set ::fpga_tDQSS_HOLD_ERROR 0
set ::fpga_tDSSH_SETUP_ERROR 0
set ::fpga_tDSSH_HOLD_ERROR 0

##############################################################
## IP Calibration options
##############################################################

# Can be either dynamic or static
set ::IP(write_deskew_mode) "static"
set ::IP(read_deskew_mode) "none"
set ::IP(write_dcc) "static"
set ::IP(write_deskew_t10) 6
set ::IP(write_deskew_t9i) 0
set ::IP(write_deskew_t9ni) 6
set ::IP(write_deskew_range) 0
set ::IP(read_deskew_range) 0
set ::IP(mem_if_memtype) "DDR3 SDRAM"
set ::IP(mp_calibration) 1
set ::IP(quantization_T9) 0.050
set ::IP(quantization_T1) 0.050
set ::IP(quantization_DCC) 0.050
set ::IP(quantization_T7) 0.050
set ::IP(discrete_device) 1
set ::IP(num_ranks) 1

##############################################################
## Memory Specification Process Variation Information
##############################################################

## The percentage of the JEDEC specification that is due
## to process variation 

set ::MP(DSS) 0.60
set ::MP(DSH) 0.60
set ::MP(DQSS) 0.50

set ::MP(QH) 0.50
set ::MP(QHS) 0.50
set ::MP(DS) 0.60
set ::MP(DH) 0.50
set ::MP(IS) 0.70
set ::MP(IH) 0.60
set ::MP(WLH) 0.60
set ::MP(WLS) 0.70

set ::MP(DQSQ) 0.65
set ::MP(DQSCK) 0.50

##############################################################
## Load packages
##############################################################
package require ::quartus::ddr_timing_model
load_package atoms
load_package report

##############################################################
## Initialize the runtime environment
##############################################################

set scriptname [info script]
if { ! [regexp (.*)_report_timing.tcl $scriptname _ corename] } {
	error "Couldn't determine corename from $scriptname"
}

if {[namespace which -variable ::argv] != "" && [lindex $::argv 0] == "batch" } {
	post_message -type info "Running in batch mode"

	set batch_mode_en 1
	set proj_name [glob *.qpf]
	if { ! [is_project_open] } {
		project_open -revision [get_current_revision $proj_name] $proj_name
	}

	catch {delete_timing_netlist }
	create_timing_netlist
	read_sdc

	set opcs [list]
	foreach_in_collection op [get_available_operating_conditions] {
		lappend opcs $op
	}

	update_timing_netlist
} else {
	set batch_mode_en 0
	set opcs [list ""]
}

##############################################################
## Load the timing netlist
##############################################################

read_atom_netlist
load_report
set old_active_clocks [get_active_clocks]
set_active_clocks [all_clocks]

if { ! [timing_netlist_exist] } {
	post_message -type error "Timing Netlist has not been created. Run the 'Update Timing Netlist' task first."
	return
}

##############################################################
## This is the main timing analysis function
##   It performs the timing analysis over all of the
##   various Memory Interface instances and timing corners
##############################################################

set corename [file tail $corename]
set instance_names [get_core_full_instance_list $corename]
set ::family [get_family_string]
set ::family [string tolower $::family]
if {$::family == "arria ii gx"} {
	set ::family "arria ii"
}
if {$::family == "stratix iv gx"} {
	set ::family "stratix iv"
}
if {$::family == "hardcopy iv gx"} {
	set ::family "hardcopy iv"
}
if {$::family == "cyclone iv gx"} {
	set ::family "cyclone iv"
}
if {$::family == "cyclone iv e"} {
	set ::family "cyclone iv"
}

########################################
## Check Memory Interface support
if {!(($::IP(mem_if_memtype) == "DDR SDRAM") || ($::IP(mem_if_memtype) == "DDR2 SDRAM") || ($::IP(mem_if_memtype) == "DDR3 SDRAM"))} {
	puts "The report_timing script does not support the $::IP(mem_if_memtype) memory interfaces."
	return
}

################################################
# Go over the various Memory Interface instances
for {set inst_index 0} {$inst_index != [llength $instance_names]} {incr inst_index} {

	# Get the instance name
	set ::full_instance_name [lindex $instance_names $inst_index]
	set ::instance_name [get_timequest_name $::full_instance_name]
	set ::instname "${::instance_name}|${corename}"

	# Copy the use_flexible_timing value for this instance into a more generic name
	set use_flexible_timing [set ${corename}_use_flexible_timing]

	# Find all the pins associated with this instance
	set pins(ck_p) [list]
	set pins(ck_n) [list]
	set pins(addrcmd) [list]
	set pins(addrcmd_2t) [list]
	set pins(dqsgroup) [list]
	set pins(dgroup) [list]

	global pins_cache
	if { [array exists pins_cache] &&  [info exists pins_cache($corename-$::instance_name)] } {
		array set pins $pins_cache($corename-$::instance_name)
	} else {
		get_ddr_pins $instname pins $corename
		set pins_cache($corename-$::instance_name) [array get pins]
	}

	# Find all the DQ pins
	set ::alldqpins [list]
	set ::alldqdmpins [list]
	set ::alldqspins [list]
	foreach dqsgroup $pins(dqsgroup) {
		set ::alldqpins [concat $::alldqpins [lindex $dqsgroup 2]]
		set ::alldqdmpins [concat $::alldqdmpins [lindex $dqsgroup 2] [lindex $dqsgroup 1]]
		lappend ::alldqspins [lindex $dqsgroup 0]
	}
	set all_read_dqs_list [get_all_dqs_pins $pins(dqsgroup)]
	set all_write_dqs_list $all_read_dqs_list
	set all_d_list [get_all_dq_pins $pins(dqsgroup)]

	##################################################################################
	# Find some design values and parameters that will used during the timing analysis
	# that do not change accross the operating conditions
	set ::period $::t(period)

	# Get the number of PLL steps
	set clk_to_write_d [traverse_to_ddio_out_pll_clock [lindex $all_d_list 0] msg_list $::family]
	set ::pll_steps [expr {int([get_vco_freq -clk $clk_to_write_d ]*8.0*$::period/1000.0)}]

	# Package skew
	[catch {get_max_package_skew} ::max_package_skew]
	if { (($::max_package_skew != 0) || ($::max_package_skew == "")) } {
		set ::max_package_skew 0
	}

	# DLL length
	set ::dll_length 0
	set dqs0 [lindex $::alldqspins 0]
	if {$dqs0 != ""} {
		set dll_id [traverse_to_dll_id $dqs0 msg_list]
		if {$dll_id != -1} {
			set ::dll_length [get_atom_node_info -key UINT_DELAY_CHAIN_LENGTH -node $dll_id]
		}
	}
	if {$::dll_length == 0} {
		set ::dll_length 8
		post_message -type critical_warning "Unable to determine DLL delay chain length.  Assuming default setting of $::dll_length"
	}

	# DQS_phase offset
	set ::dqs_phase_setting 0
	set dqs0 [lindex $::alldqspins 0]
	if {$dqs0 != ""} {
		set dqs_delay_chain_id [traverse_to_dqs_delaychain_id $dqs0 msg_list]
		if {$dqs_delay_chain_id != -1} {
			set ::dqs_phase_setting [get_atom_node_info -key UINT_PHASE_SETTING -node $dqs_delay_chain_id]
		}
	}
	if {$::dqs_phase_setting == 0} {
		set ::dqs_phase_setting 2
		post_message -type critical_warning "Unable to determine DQS delay chain phase setting.  Assuming default setting of $::dqs_phase_setting"
	}
	set ::dqs_phase [expr 360/$::dll_length * $::dqs_phase_setting]

	# Get the interface type (HPAD or VPAD)
	set ::interface_type [get_io_interface_type $all_read_dqs_list]

	# Treat the VHPAD interface as the same as a HPAD interface
	if {($::interface_type == "VHPAD") || ($::interface_type == "HYBRID")} {
		set ::interface_type "HPAD"
	}

	# Get the IO standard which helps us determine the Memory type
	set ::io_std [get_io_standard [lindex $all_read_dqs_list 0]]

	if {$::interface_type == "" || $::interface_type == "UNKNOWN" || $::io_std == "" || $::io_std == "UNKNOWN"} {
		set result 0
	}

	# Get some of the FPGA jitter and DCD specs
	# When not specified all jitter values are peak-to-peak jitters in ns
	set ::tJITper [expr [get_io_standard_node_delay -dst MEM_CK_PERIOD_JITTER -io_standard $::io_std -parameters [list IO $::interface_type] -period $::period]/1000.0]
	set ::tJITdty [expr [get_io_standard_node_delay -dst MEM_CK_DC_JITTER -io_standard $::io_std -parameters [list IO $::interface_type]]/1000.0]
	# DCD value that is looked up is in %, and thus needs to be divided by 100
	set ::tDCD [expr [get_io_standard_node_delay -dst MEM_CK_DCD -io_standard $::io_std -parameters [list IO $::interface_type]]/100.0]
	# This is the peak-to-peak jitter on the whole DQ-DQS read capture path
	set ::DQSpathjitter [expr [get_io_standard_node_delay -dst DQDQS_JITTER -io_standard $::io_std -parameters [list IO $::interface_type]]/1000.0]
	# This is the proportion of the DQ-DQS read capture path jitter that applies to setup (looed up value is in %, and thus needs to be divided by 100)
	set ::DQSpathjitter_setup_prop [expr [get_io_standard_node_delay -dst DQDQS_JITTER_DIVISION -io_standard $::io_std -parameters [list IO $::interface_type]]/100.0]

	global assumptions_cache
	set in_gui [regexp "TimeQuest Timing Analyzer GUI" [get_current_timequest_report_folder]]
	if {!$in_gui && [array exists assumptions_cache] &&  [info exists assumptions_cache($corename-$::instance_name)] } {
		set assumptions_valid $assumptions_cache($corename-$::instance_name)
		if {!$assumptions_valid} {
			post_message -type critical_warning "Read Capture and Write timing analyses may not be valid due to violated timing model assumptions"
			post_message -type critical_warning "See violated timing model assumptions in previous timing analysis above"
		}
	} else {
		if {($::IP(mem_if_memtype) == "DDR2 SDRAM") || ($::IP(mem_if_memtype) == "DDR SDRAM")} {
			set assumptions_valid [verify_high_performance_timing_assumptions_ddr2 $::instname pins $::IP(write_deskew_t10) $use_flexible_timing $::family $::IP(mem_if_memtype)]
		} elseif {$::IP(mem_if_memtype) == "DDR3 SDRAM"} {
			set assumptions_valid [verify_high_performance_timing_assumptions $::instname pins $::IP(write_deskew_t10) $::IP(discrete_device) $use_flexible_timing $::family]
		}
		set assumptions_cache($corename-$::instance_name) $assumptions_valid
	}

	##################################################################################
	# Now loop the timing analysis over the various operating conditions
	set summary [list]
	foreach opc $opcs {
		if {$opc != "" } {
			set_operating_conditions $opc
			update_timing_netlist
		}

		set opcname [get_operating_conditions_info [get_operating_conditions] -display_name]
		set opcname [string trim $opcname]

		########################################
		## Determine parameters and values that are valid only for this operating condition

		# Min/Max scaling factor
		[catch {get_float_table_node_delay -src {SCALE_FACTOR} -dst {MEM_INTERFACE_SCALE_FACTOR} -parameters {IO}} DQS_max_scale_factor]
		[catch {get_float_table_node_delay -src {SCALE_FACTOR} -dst {MEM_INTERFACE_SCALE_FACTOR} -parameters {IO MIN}} DQS_min_scale_factor]
		if {  (($DQS_max_scale_factor != 0) || ($DQS_max_scale_factor == "")) && (($DQS_min_scale_factor != 0) || ($DQS_min_scale_factor == "")) } {
			set ::DQS_min_max [expr $DQS_max_scale_factor - $DQS_min_scale_factor]
		} else {
			set ::DQS_min_max 0
		}

		########################################
		## Write Analysis

		if {$use_flexible_timing} {
			perform_flexible_write_launch_timing_analysis $opcs $opcname pins t summary MP IP
		} else {
			perform_macro_write_launch_timing_analysis $opcs $opcname pins t summary IP ISI
		}

		########################################
		## PHY and Address/command Analyses

		perform_phy_analyses $opcs $opcname pins t summary IP
		perform_ac_analyses  $opcs $opcname pins t summary IP

		########################################
		## Read Analysis
		if {$use_flexible_timing} {
			perform_flexible_read_capture_timing_analysis $opcs $opcname pins t summary MP IP
		} else {
			perform_macro_read_capture_timing_analysis $opcs $opcname pins t summary IP
		}

	}

	##################################################
	# Now perform analysis of some of the calibrated paths that consider
	# Worst-case conditions

	set opcname "All Conditions"

	########################################
	## Resynchronization Analysis (For non Cyclone device families)
	if {$::family != "cyclone iv"} {
		if {$use_flexible_timing} {
			perform_flexible_resync_timing_analysis $opcs $opcname pins t summary MP IP SSN board
		} else {
			perform_macro_resync_timing_analysis $opcs $opcname pins t summary MP IP board
		}
	}

	########################################
	## Write Levelling Analysis (For DDR3 only)
	if {($::IP(mem_if_memtype) == "DDR3 SDRAM") && ($::IP(discrete_device) == 0)} {
		if {$use_flexible_timing} {
			perform_flexible_write_levelling_timing_analysis $opcs $opcname pins t summary MP IP SSN board ISI
		} else {
			perform_macro_write_levelling_timing_analysis $opcs $opcname pins t summary MP IP board ISI
		}
	}

	########################################
	## Print out the Summary Panel for this instance

	set summary [lsort -command sort_proc $summary]
	set fname ""
	if {[llength $instance_names] <= 1} {
		set fname "${corename}_summary.csv"
	} else {
		set fname "${corename}${inst_index}_summary.csv"
	}

	set f -1
	if { [get_operating_conditions_number] == 0 } {
		set f [open $fname w]
		puts $f "#Core: ${corename} - Instance: $::instance_name"
		puts $f "#Path, Setup Margin, Hold Margin"
	} else {
		set f [open $fname a]
		puts $f " "
	}

	post_message -type info "                                                         setup  hold"
	set panel_name "$::instname"
	set root_folder_name [get_current_timequest_report_folder]
	if { ! [string match "${root_folder_name}*" $panel_name] } {
		set panel_name "${root_folder_name}||$panel_name"
	}
	# Create the root if it doesn't yet exist
	if {[get_report_panel_id $root_folder_name] == -1} {
		set panel_id [create_report_panel -folder $root_folder_name]
	}

	# Delete any pre-existing summary panel
	set panel_id [get_report_panel_id $panel_name]
	if {$panel_id != -1} {
		delete_report_panel -id $panel_id
	}

	# Create summary panel
	set panel_id [create_report_panel -table $panel_name]
	add_row_to_table -id $panel_id [list "Path" "Operating Condition" "Setup Slack" "Hold Slack"] 
	set total_failures 0
	foreach summary_line $summary {
		foreach {corner order path su hold} $summary_line { }
		if { $su < 0 || ($hold!="" && $hold < 0) } {
			set type warning
			set offset 50
			incr total_failures
		} else {
			set type info
			set offset 53
		}
		set su [format %.3f $su]
		if {$hold != ""} {
			set hold [format %.3f $hold]
		}
		post_message -type $type [format "%-${offset}s | %6s %6s" $path $su $hold]
		puts $f [format "\"%s\",%s,%s" $path $su $hold]
		set fg_colours [list black black]
		if { $su < 0 } {
			lappend fg_colours red
		} else {
			lappend fg_colours black
		}
		if { $hold != "" && $hold < 0 } {
			lappend fg_colours red
		} else {
			lappend fg_colours black
		}
		add_row_to_table -id $panel_id -fcolors $fg_colours [list $path $corner $su $hold] 
	}
	close $f
	if {$total_failures > 0} {
		post_message -type critical_warning "DDR Timing requirements not met"
	}
}
write_timing_report
set_active_clocks $old_active_clocks
if {$batch_mode_en == 1} {
	catch {delete_timing_netlist}
}
