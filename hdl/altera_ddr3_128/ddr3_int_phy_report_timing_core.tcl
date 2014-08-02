##############################################################
## Write Timing Analysis
##############################################################

proc perform_flexible_write_launch_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name MP_name IP_name} {

	################################################################################
	# This timing analysis covers the write timing constraints.  It includes support 
	# for uncalibrated and calibrated write paths.  The analysis starts by running a 
	# conventional timing analysis for the write paths and then adds support for 
	# topologies and IP options which are unique to source-synchronous data transfers.  
	# The support for further topologies includes common clock paths in DDR3 as well as 
	# correlation between DQ and DQS.  The support for further IP includes support for 
	# write-deskew calibration.
	# 
	# During write deskew calibration, the IP will adjust delay chain settings along 
	# each signal path to reduce the skew between DQ pins and to centre align the DQS 
	# strobe within the DVW.  This operation has the benefit of increasing margin on the 
	# setup and hold, as well as removing some of the unknown process variation on each 
	# signal path.  This timing analysis emulates the IP process by deskewing each pin as 
	# well as accounting for the elimination of the unknown process variation.  Once the 
	# deskew emulation is complete, the analysis further considers the effect of changing 
	# the delay chain settings to the operation of the device after calibration: these 
	# effects include changes in voltage and temperature which may affect the optimality 
	# of the deskew process.
	# 
	# The timing analysis creates a write summary report indicating how the timing analysis 
	# was performed starting with a typical timing analysis before calibration.
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$MP_name MP
	upvar 1 ::$IP_name IP
	global instname
	global ::DQS_min_max
	global ::WR_DQS_DQ_SETUP_ERROR
	global ::WR_DQS_DQ_HOLD_ERROR
	global ::interface_type
	global ::max_package_skew
	global ::alldqdmpins
	global ::family
	
	########################################
	## Check family support
	if {!(($::family == "arria ii") || ($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv") || ($::family == "cyclone iv"))} {
		puts "The report_timing script does not support the $::family device family"
		return
	}	
	
	# Debug switch. Change to 1 to get more run-time debug information
	set debug 0

	set result 1
	
	########################################
	## Initialize the write analysis panel	
	set panel_name "$::instname Write"
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

	set panel_id [create_report_panel -table $panel_name]
	add_row_to_table -id $panel_id [list "Operation" "Setup Slack" "Hold Slack"] 
	
	##################################
	# Find the clock output of the PLL
	set dqs_pll_clock_id [get_output_clock_id [get_all_dqs_pins $pins(dqsgroup)] "DQS output" msg_list]
	if {$dqs_pll_clock_id == -1} {
		foreach {msg_type msg} $msg_list {
			post_message -type $msg_type "$msg"
		}
		post_message -type warning "Failed to find PLL clock for pins [join [get_all_dqs_pins $pins(dqsgroup)]]"
		set result 0
	} else {
		set dqsclksource [get_node_info -name $dqs_pll_clock_id]
	}
	
	if {($IP(write_deskew_mode) == "dynamic") && ($IP(num_ranks) == 1)} {
		set panel_name_setup  "Before Calibration \u0028Negative slacks are OK\u0029||$::instname Write \u0028Before Calibration\u0029 \u0028setup\u0029"
		set panel_name_hold   "Before Calibration \u0028Negative slacks are OK\u0029||$::instname Write \u0028Before Calibration\u0029 \u0028hold\u0029"
	} else {
		set panel_name_setup  "Before Spatial Pessimism Removal \u0028Negative slacks are OK\u0029||$::instname Write (setup)"
		set panel_name_hold   "Before Spatial Pessimism Removal \u0028Negative slacks are OK\u0029||$::instname Write (hold)"
	}	
	
	######################################################################		
	## Default Write Analysis
	set before_calibration_reporting [get_ini_var -name "qsta_enable_before_calibration_ddr_reporting"]
	if {![string equal -nocase $before_calibration_reporting off]}  {
		set res_0 [report_timing -detail full_path -to [get_ports $::alldqdmpins] -npaths 100 -panel_name $panel_name_setup -setup -quiet -disable_panel_color]
		set res_1 [report_timing -detail full_path -to [get_ports $::alldqdmpins] -npaths 100 -panel_name $panel_name_hold  -hold  -quiet -disable_panel_color]
	}
	
	# Perform the default timing analysis to get required and arrival times
	set paths_setup [get_timing_paths -to [get_ports $::alldqdmpins] -npaths 400 -setup]
	set paths_hold  [get_timing_paths -to [get_ports $::alldqdmpins] -npaths 400 -hold]
	
	######################################
	## Find Memory Calibration Improvement 
	######################################				
	
	set mp_setup_slack 0
	set mp_hold_slack  0
	if {($IP(write_deskew_mode) == "dynamic") && ($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		# Reduce the effect of tDS on the setup slack
		set mp_setup_slack [expr $MP(DS)*$t(DS)]
		
		# Reduce the effect of tDH on the hold slack
		set mp_hold_slack  [expr $MP(DH)*$t(DH)]
	}	

	#########################################
	# Go over each pin and compute its slack
	# Then include any effects that are unique
	# to source synchronous designs including
	# common clocks, signal correlation, and
	# IP calibration options to compute the
	# total slack of the instance

	set setup_slack 1000000000
	set hold_slack  1000000000
	set default_setup_slack 1000000000
	set default_hold_slack  1000000000
	set DQDQSpessimismremoval 1000000000
	
	set dqsgroup_number -1
	if {($result == 1)} {

		#Go over each DQS pin
		foreach dqsgroup $pins(dqsgroup) {

			set dqspin [lindex $dqsgroup 0]
			set dqpins [lindex $dqsgroup 2]
			set dqmpins [lindex $dqsgroup 1]
			set dqdqmpins [concat $dqpins $dqmpins]
			set dqs_in_clockname "${::instname}_ddr_dqsin_${dqspin}"
			if {[regexp {\[\d+\]} $dqspin temp] == 1} {
				regexp {\d+} $temp dqsgroup_number
			} else {
				incr dqsgroup_number
			}

			# Find DQS clock node before the periphery 
			if {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 0)} {
				set dqs_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dqs_op_gen.dqs_op|dqs_ddio_out_gen.ddr3_opa_phase_align_gen.o_phase_align|clk
			} else {
				if {$::family == "arria ii"} {
					set dqs_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq_dqs|dqs_*_output_ddio_out_inst|muxsel
				} elseif {$::family == "cyclone iv"} {
					set dqs_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs[${dqsgroup_number}].dqs_ddio_out|muxsel
				} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
					set dqs_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dqs_op_gen.dqs_op|dqs_ddio_out_gen.ddr_ddio_phase_align_gen.dqs_ddio_inst|muxsel
				}
			}

			# Find paths from PLL to DQS clock periphery node
			set DQSpaths_max [get_path -from $dqsclksource -to $dqs_periphery_node -nworst 100]
			set DQSpaths_min [get_path -from $dqsclksource -to $dqs_periphery_node -nworst 100 -min_path]
			set DQSmin_of_max [min_in_collection $DQSpaths_max "arrival_time"]
			set DQSmax_of_min [max_in_collection $DQSpaths_min "arrival_time"]
			set DQSmax_of_max [max_in_collection $DQSpaths_max "arrival_time"]
			set DQSmin_of_min [min_in_collection $DQSpaths_min "arrival_time"]		
			
			##############################################
			## Find extra DQS pessimism due to correlation
			##############################################
			
			# Find paths from DQS clock periphery node to beginning of output buffer
			if {$::family == "arria ii"} {
				set output_buffer_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].ddr*_dqsn_*buf_gen.dqs_obuf|i
			} elseif {$::family == "cyclone iv"} {
				set output_buffer_node ${::instname}_alt_mem_phy_inst|dpio|dqs[${dqsgroup_number}].dqs_obuf|i		
			} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
				set output_buffer_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dqs_op_gen.dqs_op|obuf|i
			}
			set DQSperiphery_min [get_path -from $dqs_periphery_node -to $output_buffer_node -min_path -nworst 100]
			set DQSperiphery_delay [min_in_collection $DQSperiphery_min "arrival_time"]
			set DQSpath_pessimism [expr $DQSperiphery_delay*$::DQS_min_max]
			
			# Go over each DQ pin in group
			set dq_index 0
			set dqm_index 0
			foreach dqpin $dqdqmpins {	
			
				if {[lsearch -exact $dqmpins $dqpin] >= 0} {
					set isdqmpin 1
				} else {
					set isdqmpin 0
				}
				
				# Get the setup and hold slacks from the default timing analysis 
				set pin_setup_slack [min_in_collection_to_name $paths_setup "slack" $dqpin]
				set pin_hold_slack  [min_in_collection_to_name $paths_hold "slack" $dqpin]
				
				set default_setup_slack [min $default_setup_slack $pin_setup_slack]
				set default_hold_slack  [min $default_hold_slack  $pin_hold_slack]				
				
				if { $debug } {
					puts "$dqsgroup_number $dqspin $dqpin $pin_setup_slack $pin_hold_slack"	
				}
				
				################################
				## Extra common clock pessimism removal that is not caught by STA
				################################
				
				# Find the DQ clock node before the periphery
				if {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 0)} {
					if {$isdqmpin == 0} {
						set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_pad|ddr3_dq_opa_gen.dq_opa_inst|clk
					} else {
						set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dm_gen.dm_pad_gen[${dqm_index}].dm_pad|ddr3_dm_opa_gen.dm_opa_inst|clk
					}
				} else {
					if {$::family == "arria ii"} {
						if {$isdqmpin == 0} {
							set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq_dqs|bidir_dq_${dq_index}_output_ddio_out_inst|muxsel
						} else {
							set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq_dqs|output_dq_${dqm_index}_output_ddio_out_inst|muxsel
						}				
					} elseif {$::family == "cyclone iv"} {
						if {$isdqmpin == 0} {
							set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_ddio_out|muxsel
						} else {
							set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dm[${dqsgroup_number}].dm_ddio_out|muxsel
						}	
					} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
						if {$isdqmpin == 0} {
							set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_pad|ddr_qdr_dq_ddio_out_gen.dq_ddio_inst|muxsel
						} else {
							set dq_periphery_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dm_gen.dm_pad_gen[${dqm_index}].dm_pad|ddr_qdr_dm_ddio_gen.dm_ddio_inst|muxsel
						}				
					}
				}
				
				# Find paths from PLL to DQ clock periphery node
				set DQpaths_max [get_path -from $dqsclksource -to $dq_periphery_node -nworst 1]
				set DQpaths_min [get_path -from $dqsclksource -to $dq_periphery_node -nworst 1 -min_path]
				set DQmin_of_max [min_in_collection $DQpaths_max "arrival_time"]
				set DQmax_of_min [max_in_collection $DQpaths_min "arrival_time"]
				set DQmax_of_max [max_in_collection $DQpaths_max "arrival_time"]
				set DQmin_of_min [min_in_collection $DQpaths_min "arrival_time"]			
				if {([expr abs($DQSmin_of_max - $DQmin_of_max)] < 0.002) && ([expr abs($DQSmax_of_min - $DQmax_of_min)] < 0.002)} {
					set extra_ccpp_max [expr $DQSmax_of_max - $DQSmax_of_min]
					set extra_ccpp_min [expr $DQSmin_of_max - $DQSmin_of_min]
					set extra_ccpp [min $extra_ccpp_max $extra_ccpp_min]
				} else {
					set extra_ccpp 0
				}
				
				# Add the extra ccpp to both setup and hold slacks
				if {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 0)} {
					set pin_setup_slack [expr $pin_setup_slack + $extra_ccpp]
					set pin_hold_slack [expr $pin_hold_slack + $extra_ccpp]
				}
				
				#########################################
				## Add the memory calibration improvement
				#########################################
				
				set pin_setup_slack [expr $pin_setup_slack + $mp_setup_slack]
				set pin_hold_slack [expr $pin_hold_slack + $mp_hold_slack]				
				
				#############################################
				## Find extra DQ pessimism due to correlation
				#############################################
				
				# Find paths from DQS clock periphery node to beginning of output buffer
				if {$::family == "arria ii"} {
					if {$isdqmpin == 0} {
						set output_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_obuf|i
					} else {
						set output_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].gen_dm.dm_obuf|i
					}
				} elseif {$::family == "cyclone iv"} {
					if {$isdqmpin == 0} {
						set output_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_obuf|i
					} else {
						set output_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dm[${dqsgroup_number}].dm_obuf|i
					}			
				} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
					if {$isdqmpin == 0} {
						set output_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_pad|gen_ddr_obuf.dq_obuf_inst|i
					} else {
						set output_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dm_gen.dm_pad_gen[${dqm_index}].dm_pad|dq_obuf_inst|i
					}
				}

				set DQperiphery_min [get_path -from $dq_periphery_node -to $output_buffer_node_dq -min_path -nworst 1]
				set DQperiphery_delay [min_in_collection $DQperiphery_min "arrival_time"]
				set DQpath_pessimism [expr $DQperiphery_delay*$::DQS_min_max]		
				
				##########################################
				## Merge current slacks with other slacks
				##########################################		
				
				# If write deskew is available, the setup and hold slacks for this pin will be equal
				#   and can also remove the extra DQS and DQ pessimism removal
				if {($IP(write_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
				
					# Consider the maximum range of the deskew when deskewing
					set shift_setup_slack [expr ($pin_setup_slack + $pin_hold_slack)/2 - $pin_setup_slack]
					set max_write_deskew [expr $IP(write_deskew_range)*$IP(quantization_T9)]
					if {$shift_setup_slack >= $max_write_deskew} {
						if { $debug } {
							puts "limited setup"
						}
						set pin_setup_slack [expr $pin_setup_slack + $max_write_deskew]
						set pin_hold_slack [expr $pin_hold_slack - $max_write_deskew]
					} elseif {$shift_setup_slack <= -$max_write_deskew} {
						if { $debug } {
							puts "limited hold"
						}
						set pin_setup_slack [expr $pin_setup_slack - $max_write_deskew]
						set pin_hold_slack [expr $pin_hold_slack + $max_write_deskew]
					} else {
						# In this case we can also consider the DQS/DQpath pessimism since we can guarantee we have enough delay chain settings to align it
						set pin_setup_slack [expr $pin_setup_slack + $shift_setup_slack + $DQSpath_pessimism/2 + $DQpath_pessimism/2]
						set pin_hold_slack [expr $pin_hold_slack - $shift_setup_slack + $DQSpath_pessimism/2 + $DQpath_pessimism/2]						
					}
				} else {
					# For uncalibrated calls, there is some spatial correlation between DQ and DQS signals, so remove
					# some of the pessimism
					set total_DQ_DQS_pessimism [expr $DQSpath_pessimism + $DQpath_pessimism]
					set dqs_width [llength $dqpins]
					if {$dqs_width <= 9} {
						set DQDQSpessimismremoval [min $DQDQSpessimismremoval [expr 0.45*$total_DQ_DQS_pessimism]]
						set pin_setup_slack [expr $pin_setup_slack + 0.45*$total_DQ_DQS_pessimism]
					    set pin_hold_slack  [expr $pin_hold_slack  + 0.45*$total_DQ_DQS_pessimism]
					} 
				}
				
				set setup_slack [min $setup_slack $pin_setup_slack]
				set hold_slack  [min $hold_slack $pin_hold_slack]
				
				if { $debug } {
					puts "                                $extra_ccpp $DQSpath_pessimism $DQpath_pessimism ($pin_setup_slack $pin_hold_slack $setup_slack $hold_slack)" 
				}
				if {$isdqmpin == 0} {
					set dq_index [expr $dq_index + 1]
				} else {
					set dqm_index [expr $dqm_index + 1]
				}
			}
		}
	} 
	
	################################
	## Consider some post calibration effects on calibration
	##  and output the write summary report
	################################
	set positive_fcolour [list "black" "blue" "blue"]
	set negative_fcolour [list "black" "red"  "red"]	
	
	set wr_summary [list]
	
	if {($IP(write_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
		lappend wr_summary [list "  Before Calibration Write" [format_3dp $default_setup_slack] [format_3dp $default_hold_slack]]
	} else {
		lappend wr_summary [list "  Standard Write" [format_3dp $default_setup_slack] [format_3dp $default_hold_slack]]
	}
	
	if {($IP(write_deskew_mode) == "dynamic") && ($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		lappend wr_summary [list "  Memory Calibration" [format_3dp $mp_setup_slack] [format_3dp $mp_hold_slack]]
	}		

	if {($IP(write_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		# Remove external delays (add slack) that are fixed by the dynamic deskew
		if { $IP(discrete_device) == 1 } {
			set t(WL_PSE) 0
		}
		set setup_slack [expr $setup_slack + $t(board_skew) + $t(WL_PSE) + $::WR_DQS_DQ_SETUP_ERROR]
		set hold_slack [expr $hold_slack + $t(board_skew) + $t(WL_PSE) + $::WR_DQS_DQ_HOLD_ERROR]
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		set deskew_setup [expr $setup_slack - $default_setup_slack -$mp_setup_slack]
		set deskew_hold  [expr $hold_slack - $default_hold_slack - $mp_hold_slack]
		lappend wr_summary [list "  Deskew Write and/or more clock pessimism removal" [format_3dp $deskew_setup] [format_3dp $deskew_hold]]
		
		# Consider errors in the dynamic deskew
		set t9_quantization $IP(quantization_T9)
		set setup_slack [expr $setup_slack - $t9_quantization/2]
		set hold_slack  [expr $hold_slack - $t9_quantization/2]
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend wr_summary [list "  Quantization error" [format_3dp [expr 0-$t9_quantization/2]] [format_3dp [expr 0-$t9_quantization/2]]]
		
		# Consider variation in the delay chains used during dynamic deksew
		[catch {get_float_table_node_delay -src {DELAYCHAIN_T9} -dst {VTVARIATION} -parameters [list IO $::interface_type]} t9_vt_variation_percent]
		set t9_variation [expr (2*$t(board_skew) + 2*$::max_package_skew + $t(WL_PSE))*2*$t9_vt_variation_percent]
		set setup_slack [expr $setup_slack - $t9_variation]
		set hold_slack  [expr $hold_slack - $t9_variation]	
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend wr_summary [list "  Calibration uncertainty" [format_3dp [expr 0-$t9_variation]] [format_3dp [expr 0-$t9_variation]]] 
	} elseif {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 0)} {
		set pessimism 0
		if {$DQDQSpessimismremoval != 1000000000} {
			set pessimism $DQDQSpessimismremoval 
		}
		lappend wr_summary [list "  Spatial correlation pessimism removal" [format_3dp $pessimism] [format_3dp $pessimism]]
		lappend wr_summary [list "  More clock pessimism removal" [format_3dp [expr $setup_slack - $default_setup_slack - $mp_setup_slack - $pessimism]] [format_3dp [expr $hold_slack - $default_hold_slack - $mp_hold_slack - $pessimism]]]
	} else {
		set pessimism_setup [expr $setup_slack - $default_setup_slack - $mp_setup_slack]
		set pessimism_hold  [expr $hold_slack - $default_hold_slack - $mp_hold_slack]
		lappend wr_summary [list "  Spatial correlation pessimism removal" [format_3dp $pessimism_setup] [format_3dp $pessimism_hold]]
	}	
	
	################################
	## Consider Duty Cycle Calibration if enabled
	################################	

	if {($IP(write_dcc) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM")} {
		#First remove the Systematic DCD
		set setup_slack [expr $setup_slack + $t(WL_DCD)]
		set hold_slack  [expr $hold_slack + $t(WL_DCD)]
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend wr_summary [list "  Duty cycle correction" $t(WL_DCD) $t(WL_DCD)]
		
		#Add errors in the DCC
		set DCC_quantization $IP(quantization_DCC)
		set setup_slack [expr $setup_slack - $DCC_quantization]
		set hold_slack  [expr $hold_slack - $DCC_quantization]
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend wr_summary [list "  Duty cycle correction quantization error" [format_3dp [expr 0-$DCC_quantization]] [format_3dp [expr 0-$DCC_quantization]]]
		
		# Consider variation in the DCC 
		[catch {get_float_table_node_delay -src {DELAYCHAIN_DUTY_CYCLE} -dst {VTVARIATION} -parameters [list IO $::interface_type]} dcc_vt_variation_percent]
		set dcc_variation [expr $t(WL_DCD)*2*$dcc_vt_variation_percent]
		set setup_slack [expr $setup_slack - $dcc_variation]
		set hold_slack  [expr $hold_slack - $dcc_variation]		
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend wr_summary [list "  Duty cycle correction calibration uncertainity" [format_3dp [expr 0-$dcc_variation]] [format_3dp [expr 0-$dcc_variation]]]
	}
	
	if {($IP(write_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
		set fcolour [get_colours $setup_slack $hold_slack]
		add_row_to_table -id $panel_id [list "After Calibration Write" [format_3dp $setup_slack] [format_3dp $hold_slack]] -fcolor $fcolour
		lappend summary [list $opcname 0 "Write ($opcname)" $setup_slack $hold_slack]
	} else {
		set fcolour [get_colours $setup_slack $hold_slack]
		add_row_to_table -id $panel_id [list "Write" [format_3dp $setup_slack] [format_3dp $hold_slack]] -fcolor $fcolour
		lappend summary [list $opcname 0 "Write ($opcname)" [format_3dp $setup_slack] [format_3dp $hold_slack]]
	}
	
	foreach summary_line $wr_summary {
		add_row_to_table -id $panel_id $summary_line -fcolors $positive_fcolour
	}
}

proc perform_macro_write_launch_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name IP_name ISI_name} {

	################################################################################
	# This timing analysis covers the write timing constraints using the Altera 
	# characterized values.  Altera performs characterization on its devices and IP 
	# to determine all the FPGA uncertainties, and uses these values to provide accurate 
	# timing analysis.  
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 ::$IP_name IP
	upvar 1 $pin_array_name pins
	upvar 1 ::$ISI_name ISI
	global ::instname
	global ::dll_length
	global ::period
	global ::family
	
	set board_skew $t(board_skew)
	set tDS $t(DS)
	set tDH $t(DH)
	set tAC $t(AC)
	# Cyclone IV-E 1.0V have TCCS values stored with the DCD within them, like other non-Cyclone families
	if {$::family == "cyclone iv"} {
		set speedgrade [string tolower [get_speedgrade_string]]
		if {$speedgrade == "8l" || $speedgrade == "9l"} {
			set tDCD_total 0
		} else {
			set tDCD_total $t(DCD_total)
		}
	} else {
		set tDCD_total 0
	}
	set all_read_dqs_list [get_all_dqs_pins $pins(dqsgroup)]
	set all_write_dqs_list $all_read_dqs_list
	set all_d_list [get_all_dq_pins $pins(dqsgroup)]

	# Write capture
	
	# First find the phase offset between DQ and DQS
	if {$IP(mem_if_memtype) == "DDR3 SDRAM"} {
		set dq2dqs_output_phase_offset [expr 360.0/$::dll_length * 2]
	} elseif {($IP(mem_if_memtype) == "DDR2 SDRAM") || ($IP(mem_if_memtype) == "DDR SDRAM")} {
		set msg_list [list]
		set dqs_pll_output_id [get_output_clock_id $all_write_dqs_list "DQS output" msg_list]
		set dqs_pll_clock ""
		sett_collection dqs_pll_clock_id [get_clocks [get_pin_info -name $dqs_pll_output_id]]
		set dqs_output_phase [get_clock_info -phase $dqs_pll_clock_id]
		set dq_pll_output_id [get_output_clock_id $all_d_list "DQ output" msg_list]
		set dq_pll_clock ""
		sett_collection dq_pll_clock_id [get_clocks [get_pin_info -name $dq_pll_output_id]]
		set dq_output_phase [get_clock_info -phase $dq_pll_clock_id]
		set dq2dqs_output_phase_offset [expr $dqs_output_phase - $dq_output_phase]
		if {$dq2dqs_output_phase_offset < 0} {
			set dq2dqs_output_phase_offset [expr $dq2dqs_output_phase_offset + 360.0]
		}	
	}
	
	set tccs [get_tccs $IP(mem_if_memtype) $all_write_dqs_list $::period -write_deskew $IP(write_deskew_mode) -dll_length $::dll_length -config_period $::period -ddr3_discrete $IP(discrete_device)] 	
	set write_board_skew $board_skew
	
	if {($IP(write_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM")} {
		if {[catch {get_micro_node_delay -micro EXTERNAL_SKEW_THRESHOLD -parameters [list IO]} compensated_skew] != 0 || $compensated_skew == ""} {
		  # No skew compensation
		} else {
		  set compensated_skew [expr $compensated_skew / 1000.0]
		  if {$board_skew > $compensated_skew} {
			set write_board_skew [expr $board_skew - $compensated_skew]
		  } else {
			set write_board_skew 0
		  }
		}
	}

	set su   [round_3dp [expr {$::period*$dq2dqs_output_phase_offset/360.0 - $write_board_skew - [lindex $tccs 0]/1000.0 - $tDS - $ISI(DQ)/2 - $ISI(DQS)/2}]]
	set hold [round_3dp [expr {$::period*(0.5 - $dq2dqs_output_phase_offset/360.0) - $tDCD_total - $write_board_skew - [lindex $tccs 1]/1000.0 - $tDH - $ISI(DQ)/2 - $ISI(DQS)/2}]]
	lappend summary [list "All Conditions" 0 "Write (All Conditions)" $su $hold]
}
	
##############################################################
## Read Timing Analysis
##############################################################

proc perform_flexible_read_capture_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name MP_name IP_name} {

	################################################################################
	# This timing analysis covers the read timing constraints.  It includes support 
	# for uncalibrated and calibrated read paths.  The analysis starts by running a 
	# conventional timing analysis for the read paths and then adds support for 
	# topologies and IP options which are unique to source-synchronous data transfers.  
	# The support for further topologies includes correlation between DQ and DQS signals
	# The support for further IP includes support for read-deskew calibration.
	# 
	# During read deskew calibration, the IP will adjust delay chain settings along 
	# each signal path to reduce the skew between DQ pins and to centre align the DQS 
	# strobe within the DVW.  This operation has the benefit of increasing margin on the 
	# setup and hold, as well as removing some of the unknown process variation on each 
	# signal path.  This timing analysis emulates the IP process by deskewing each pin as 
	# well as accounting for the elimination of the unknown process variation.  Once the 
	# deskew emulation is complete, the analysis further considers the effect of changing 
	# the delay chain settings to the operation of the device after calibration: these 
	# effects include changes in voltage and temperature which may affect the optimality 
	# of the deskew process.
	# 
	# The timing analysis creates a read summary report indicating how the timing analysis 
	# was performed starting with a typical timing analysis before calibration.
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$MP_name MP
	upvar 1 ::$IP_name IP
	global ::instname
	global ::full_instance_name
	global ::DQS_min_max
	global ::fpga_tREAD_CAPTURE_SETUP_ERROR
	global ::fpga_tREAD_CAPTURE_HOLD_ERROR
	global ::interface_type
	global ::max_package_skew
	global ::alldqpins
	global ::dqs_phase
	global ::period
	global ::tDCD
	global ::DQSpathjitter 
	global ::DQSpathjitter_setup_prop
	global ::tJITper
	global ::family
	
	########################################
	## Check family support
	if {!(($::family == "arria ii") || ($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv"))} {
		puts "The report_timing script does not support the $::family device family"
		return
	}	
	
	# Debug switch. Change to 1 to get more run-time debug information
	set debug 0	
	
	set result 1
	
	########################################
	## Initialize the read analysis panel	
	set panel_name "$::instname Read Capture"
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

	set panel_id [create_report_panel -table $panel_name]
	add_row_to_table -id $panel_id [list "Operation" "Setup Slack" "Hold Slack"]
	
	# Convert from DDR2 type specs to DDR3 type specs to keep the analysis below simple and concise
	if {($IP(mem_if_memtype) == "DDR2 SDRAM") || ($IP(mem_if_memtype) == "DDR SDRAM")} {
		#Comment, this should really be tHP -tQHS, but leave this for backward compatbility
		set t(QH) [expr $::period*(0.5 - $::tDCD) - $t(QHS)]
		set MP(QH) $MP(QHS)
	}
	
	if {($IP(read_deskew_mode) == "dynamic") && ($IP(num_ranks) == 1)} {
		set panel_name_setup  "Before Calibration \u0028Negative slacks are OK\u0029||$::instname Read Capture \u0028Before Calibration\u0029 \u0028setup\u0029"
		set panel_name_hold   "Before Calibration \u0028Negative slacks are OK\u0029||$::instname Read Capture \u0028Before Calibration\u0029 \u0028hold\u0029"
	} else {
		set panel_name_setup  "Before Spatial Pessimism Removal \u0028Negative slacks are OK\u0029||$::instname Read Capture (setup)"
		set panel_name_hold   "Before Spatial Pessimism Removal \u0028Negative slacks are OK\u0029||$::instname Read Capture (hold)"
	}	
	
	
	######################################################################		
	## Default Read Analysis
	set before_calibration_reporting [get_ini_var -name "qsta_enable_before_calibration_ddr_reporting"]
	if {![string equal -nocase $before_calibration_reporting off]}  {
		set res_0 [report_timing -detail full_path -from [get_ports $::alldqpins] -to_clock [get_clocks "${::instname}_ddr_dqsin_*"] -npaths 100 -panel_name $panel_name_setup -setup -quiet -disable_panel_color]
		set res_1 [report_timing -detail full_path -from [get_ports $::alldqpins] -to_clock [get_clocks "${::instname}_ddr_dqsin_*"] -npaths 100 -panel_name $panel_name_hold  -hold -quiet -disable_panel_color]
	}
		
	set paths_setup [get_timing_paths -from [get_ports $::alldqpins] -to_clock [get_clocks "${::instname}_ddr_dqsin_*"] -npaths 400 -setup]
	set paths_hold  [get_timing_paths -from [get_ports $::alldqpins] -to_clock [get_clocks "${::instname}_ddr_dqsin_*"] -npaths 400 -hold]		
		
	######################################
	## Find Memory Calibration Improvement
	######################################				
	
	set mp_setup_slack 0
	set mp_hold_slack  0
	if {($IP(read_deskew_mode) == "dynamic") && ($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		# Reduce the effect of tDQSQ on the setup slack
		set mp_setup_slack [expr $MP(DQSQ)*$t(DQSQ)]

		# Reduce the effect of tQH on the hold slack
		set mp_hold_slack  [expr $MP(QH)*(0.5*$::period-$t(QH))]
	}	

	#########################################
	# Go over each pin and compute its slack
	# Then include any effects that are unique
	# to source synchronous designs including
	# common clocks, signal correlation, and
	# IP calibration options to compute the
	# total slack of the instance	
	
	set setup_slack 1000000000
	set hold_slack  1000000000
	set default_setup_slack 1000000000
	set default_hold_slack  1000000000	
	
	# Find quiet jitter values during calibration
	set quiet_setup_jitter [expr 0.8*$::DQSpathjitter*$::DQSpathjitter_setup_prop]
	set quiet_hold_jitter  [expr 0.8*$::DQSpathjitter*(1-$::DQSpathjitter_setup_prop) + 0.8*$::tJITper/2]
	
	set dqsgroup_number -1
	if {($result == 1)} {

		#Go over each DQS pin
		foreach dqsgroup $pins(dqsgroup) {
		
			set dqspin [lindex $dqsgroup 0]
			set dqpins [lindex $dqsgroup 2]
			set dqmpins [lindex $dqsgroup 1]
			set dqdqmpins [concat $dqpins $dqmpins]	
			set dqs_in_clockname "${::instname}_ddr_dqsin_${dqspin}"
			if {[regexp {\[\d+\]} $dqspin temp] == 1} {
				regexp {\d+} $temp dqsgroup_number
			} else {
				incr dqsgroup_number
			}
			
			##############################################
			## Find extra DQS pessimism due to correlation
			##############################################

			# Find paths from output of the input buffer to the end of the DQS periphery
			if {$::family == "arria ii"} {	
				set input_buffer_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].ddr*_dqsn_*buf_gen.dqs_inpt_ibuf|i
				set DQScapture_node [list "${full_instance_name}*dqs_group[${dqsgroup_number}].dq_dqs|wire_bidir_dq_*_ddio_in_inst_regouthi" \
				                         "${full_instance_name}*dqs_group[${dqsgroup_number}].dq_dqs|bidir_dq_*_ddio_in_inst~DFFLO" ]
			} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
				set input_buffer_node ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dqs_ip|ddr*_dqsn_ibuf_gen.dqs_inpt_io_ibuf|o
				set DQScapture_node [list "${full_instance_name}*dqs_group[${dqsgroup_number}].dq*dqi_captured_h" \
				                         "${full_instance_name}*dqs_group[${dqsgroup_number}].dq*ddr_dq_ddio_in_gen.dqi_ddio_in~DFFLO" ]
			}
			set DQSperiphery_min [get_path -from $input_buffer_node -to $DQScapture_node]
			set DQSperiphery_delay [max_in_collection $DQSperiphery_min "arrival_time"]
			set DQSpath_pessimism [expr ($DQSperiphery_delay-$::dqs_phase/360.0*$::period)*$::DQS_min_max]
			
			# Go over each DQ pin in group
			set dq_index 0
			foreach dqpin $dqpins {	
			
				# Get the setup and hold slacks from the default timing analysis 
				set pin_setup_slack [min_in_collection_from_name $paths_setup "slack" $dqpin]
				set pin_hold_slack  [min_in_collection_from_name $paths_hold "slack" $dqpin]
				
				set default_setup_slack [min $default_setup_slack $pin_setup_slack]
				set default_hold_slack  [min $default_hold_slack  $pin_hold_slack]		

				if { $debug } {
					puts "READ: $dqsgroup_number $dqspin $dqpin $pin_setup_slack $pin_hold_slack (MP: $mp_setup_slack $mp_hold_slack)"
				}
				
				################################
				## Add the memory calibration improvement
				################################
				
				set pin_setup_slack [expr $pin_setup_slack + $mp_setup_slack]
				set pin_hold_slack [expr $pin_hold_slack + $mp_hold_slack]
				
				#############################################
				## Find extra DQ pessimism due to correlation
				#############################################
				
				# Find paths from output of the input buffer to the end of the DQ periphery
				if {$::family == "arria ii"} {
					set input_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_ibuf|i
					set DQcapture_node [list "${full_instance_name}*dqs_group[${dqsgroup_number}].dq_dqs|wire_bidir_dq_${dq_index}_ddio_in_inst_regouthi" \
					                         "${full_instance_name}*dqs_group[${dqsgroup_number}].dq_dqs|bidir_dq_${dq_index}_ddio_in_inst~DFFLO" ]

				} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
					set input_buffer_node_dq ${::instname}_alt_mem_phy_inst|dpio|dqs_group[${dqsgroup_number}].dq[${dq_index}].dq_pad|dqi_io_ibuf|o
					set DQcapture_node [list "${full_instance_name}*dqs_group[${dqsgroup_number}].dq[${dq_index}]*dqi_captured_h" \
					                         "${full_instance_name}*dqs_group[${dqsgroup_number}].dq[${dq_index}]*ddr_dq_ddio_in_gen.dqi_ddio_in~DFFLO" ]
				}
				set DQperiphery_min [get_path -from $input_buffer_node_dq -to $DQcapture_node -min_path -nworst 10]
				set DQperiphery_delay [min_in_collection $DQperiphery_min "arrival_time"]
				set DQpath_pessimism [expr $DQperiphery_delay*$::DQS_min_max]
				
				#########################################
				## Merge current slacks with other slacks
				#########################################			

				# If read deskew is available, the setup and hold slacks for this pin will be equal
				#   and can also remove the extra DQS pessimism removal
				if {($IP(read_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
				
					# Consider the maximum range of the deskew when deskewing
					set shift_setup_slack [expr (($pin_setup_slack + $quiet_setup_jitter) + ($pin_hold_slack + $quiet_hold_jitter))/2 - $pin_setup_slack - $quiet_setup_jitter]
					set max_read_deskew [expr $IP(read_deskew_range)*$IP(quantization_T1)]
					if {$shift_setup_slack >= $max_read_deskew} {
						if { $debug } {
							puts "limited setup"
						}
						set pin_setup_slack [expr $pin_setup_slack + $max_read_deskew]
						set pin_hold_slack [expr $pin_hold_slack - $max_read_deskew]
					} elseif {$shift_setup_slack <= -$max_read_deskew} {
						if { $debug } {
							puts "limited hold"
						}
						set pin_setup_slack [expr $pin_setup_slack - $max_read_deskew]
						set pin_hold_slack [expr $pin_hold_slack + $max_read_deskew]
					} else {
						# In this case we can also consider the DQSpath pessimism since we can guarantee we have enough delay chain settings to align it
						set pin_setup_slack [expr $pin_setup_slack + $shift_setup_slack + $DQSpath_pessimism/2 + $DQpath_pessimism/2]
						set pin_hold_slack [expr $pin_hold_slack - $shift_setup_slack + $DQSpath_pessimism/2 + $DQpath_pessimism/2]
					}
				} else {
					# For uncalibrated calls, there is some spatial correlation between DQ and DQS signals, so remove
					# some of the pessimism
					set total_DQ_DQS_pessimism [expr $DQSpath_pessimism + $DQpath_pessimism]
					set dqs_width [llength $dqpins]
					if {$dqs_width <= 9} {
						set pin_setup_slack [expr $pin_setup_slack + 0.45*$total_DQ_DQS_pessimism]
					    set pin_hold_slack  [expr $pin_hold_slack  + 0.45*$total_DQ_DQS_pessimism]
					} 
				
				}

				set setup_slack [min $setup_slack $pin_setup_slack]
				set hold_slack  [min $hold_slack $pin_hold_slack]
				
				if { $debug } {
					puts "READ:               $DQSpath_pessimism $DQpath_pessimism ($pin_setup_slack $pin_hold_slack $setup_slack $hold_slack)" 
				}
				set dq_index [expr $dq_index + 1]
			}
		}
	}
	
	#########################################################
	## Consider some post calibration effects on calibration
	##  and output the read summary report
	#########################################################	
	
	set positive_fcolour [list "black" "blue" "blue"]
	set negative_fcolour [list "black" "red"  "red"]	

	set rc_summary [list]

	if {($IP(read_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
		lappend rc_summary [list "  Before Calibration Read Capture" [format_3dp $default_setup_slack] [format_3dp $default_hold_slack]]
	} else {
		lappend rc_summary [list "  Standard Read Capture" [format_3dp $default_setup_slack] [format_3dp $default_hold_slack]]
	}
	
	if {($IP(read_deskew_mode) == "dynamic") && ($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		lappend rc_summary  [list "  Memory Calibration" [format_3dp $mp_setup_slack] [format_3dp $mp_hold_slack]] 
	}
	
	
	if {($IP(read_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		# Remove external delays (add slack) that are fixed by the dynamic deskew
		set setup_slack [expr $setup_slack + $t(board_skew) + $t(DQS_PSERR_max) + $::fpga_tREAD_CAPTURE_SETUP_ERROR + $t(max_additional_dqs_variation)]
		set hold_slack [expr $hold_slack + $t(board_skew) + $t(DQS_PSERR_min) + $::fpga_tREAD_CAPTURE_HOLD_ERROR + $t(max_additional_dqs_variation)]
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		set deskew_setup [expr $setup_slack - $default_setup_slack - $mp_setup_slack]
		set deskew_hold  [expr $hold_slack - $default_hold_slack - $mp_hold_slack]
		
		lappend rc_summary [list "  Deskew Read" [format_3dp $deskew_setup] [format_3dp $deskew_hold]]
		
		# Consider errors in the dynamic deskew
		set t1_quantization $IP(quantization_T1)
		set setup_slack [expr $setup_slack - $t1_quantization/2]
		set hold_slack  [expr $hold_slack - $t1_quantization/2]
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend rc_summary [list "  Quantization error" [format_3dp [expr 0-$t1_quantization/2]] [format_3dp [expr 0-$t1_quantization/2]]]
		
		# Consider variation in the delay chains used during dynamic deksew
		[catch {get_float_table_node_delay -src {DELAYCHAIN_T1} -dst {VTVARIATION} -parameters [list IO $::interface_type]} t1_vt_variation_percent]
		set t1_variation [expr ($MP(DQSQ)*$t(DQSQ) + $MP(QH)*(0.5*$::period - $t(QH)) + 2*$t(board_skew) + 2*$::max_package_skew + $t(DQS_PSERR_max))*2*$t1_vt_variation_percent]
		set setup_slack [expr $setup_slack - $t1_variation]
		set hold_slack  [expr $hold_slack - $t1_variation]	
		if { $debug } {
			puts "	$setup_slack $hold_slack"
		}
		lappend rc_summary [list "  Calibration uncertainty" [format_3dp [expr 0-$t1_variation]] [format_3dp [expr 0-$t1_variation]]]
	} else {
		set pessimism_setup [expr $setup_slack - $default_setup_slack - $mp_setup_slack]
		set pessimism_hold  [expr $hold_slack - $default_hold_slack - $mp_hold_slack]
		lappend rc_summary [list "  Spatial correlation pessimism removal" [format_3dp $pessimism_setup] [format_3dp $pessimism_hold]]
	}
	
	if {($IP(read_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(num_ranks) == 1)} {
		set fcolour [get_colours $setup_slack $hold_slack] 
		add_row_to_table -id $panel_id [list "After Calibration Read Capture" [format_3dp $setup_slack] [format_3dp $hold_slack]] -fcolor $fcolour
		lappend summary [list $opcname 0 "Read Capture ($opcname)" $setup_slack $hold_slack]
	} else {
		set fcolour [get_colours $setup_slack $hold_slack] 
		add_row_to_table -id $panel_id [list "Read Capture" [format_3dp $setup_slack] [format_3dp $hold_slack]] -fcolor $fcolour
		lappend summary [list $opcname 0 "Read Capture ($opcname)" $setup_slack $hold_slack]  
	}
	
		foreach summary_line $rc_summary {
			add_row_to_table -id $panel_id $summary_line -fcolors $positive_fcolour
		}
	
}


proc perform_flexible_read_capture_non_dqs_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name MP_name IP_name board_parameters_name} {

	################################################################################
	# This timing analysis covers the read timing constraints for non-DQS capture
	# which concerns transferring read data from the pins to registers clocked
	# to a clock domain under the control of the ALTMEMPHY. We use a dedicated PLL 
	# phase that is calibrated by the
	# sequencer, and tracks any movements in the data valid window of the captured
	# data. This means that the exact length of the DQS and CK traces don't affect
	# the timing analysis, and the calibration will remove any static offset from
	# the rest of the path too. With static offset removed, the remaining
	# uncertainties with be limited to VT variation, jitter and skew (since one
	# clock phase is chosen for the whole interface).
	# 
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 ::$board_parameters_name board		
	upvar 1 $pin_array_name pins
	upvar 1 ::$MP_name MP
	upvar 1 ::$IP_name IP
	global ::instname
	global ::full_instance_name
	global ::DQS_min_max
	global ::interface_type
	global ::max_package_skew
	global ::alldqpins
	global ::dqs_phase
	global ::period
	global ::tDCD
	global ::DQSpathjitter 
	global ::DQSpathjitter_setup_prop
	global ::tJITper
	global ::family
	global ::alldqpins
	
	########################################
	## Check family support
	if {!($::family == "cyclone iv")} {
		puts "The report_timing script does not support the $::family device family"
		return
	}	
	
	# Debug switch. Change to 1 to get more run-time debug information
	set debug 0	
	
	set result 1
	
	########################################
	## First get the min/max range of DQ and
	## clock signals.  Can be a result of
	## systematic skew or process variations
	
	# DQ variation from the pins to the registers
	# This includes setup and hold times of the register as well as variation in the delay of the clock in the cell
	set DQ_paths_setup [get_timing_paths -from [get_ports $::alldqpins] -to [all_registers] -setup]
	set DQ_paths_hold  [get_timing_paths -from [get_ports $::alldqpins] -to [all_registers] -hold]
	set DQ_max [expr [max_in_collection $DQ_paths_setup "arrival_time"] - [max_in_collection $DQ_paths_setup "launch_time"] - [min_in_collection $DQ_paths_setup "required_time"] + [min_in_collection $DQ_paths_setup "latch_time"]]
	set DQ_min [expr [min_in_collection $DQ_paths_hold  "arrival_time"] - [min_in_collection $DQ_paths_hold  "launch_time"] - [max_in_collection $DQ_paths_hold "required_time"]  + [max_in_collection $DQ_paths_hold  "latch_time"]]
	set minmax_DQ_variation [expr $DQ_max - $DQ_min]

	# Clock variation (from the PLL to the registers
	set read_capture_clock_start ${::instname}_alt_mem_phy_inst|clk|pll|altpll_component|auto_generated|clk[3]~clkctrl|outclk
	set read_capture_clock_end   ${::instname}_alt_mem_phy_inst|dpio|dqs_group\[*\].dq\[*\].dqi|auto_generated|input_cell_*\[0\]|clk
	set clock_max_paths [get_path -from $read_capture_clock_start -to $read_capture_clock_end -npaths 100]
	set clock_min_paths [get_path -from $read_capture_clock_start -to $read_capture_clock_end -npaths 100 -min_path]
	set clock_max [max_in_collection $clock_max_paths "arrival_time"]
	set clock_min [min_in_collection $clock_min_paths "arrival_time"]
	set minmax_clock_variation [expr $clock_max - $clock_min]
		
	#########################################
	## Now compute the margin from the ideal
	## window with uncertainties taken off
	
	# Ideal setup and hold slacks is half of the minimum high time
	set setup_slack [expr 0.5*$t(HP)]
	set hold_slack  [expr 0.5*$t(HP)]
	
	# Remove the variation in the DQ signals coming back from the memory in reference to the clock
	set tAC $t(AC)
	set setup_slack [expr $setup_slack - $tAC]
	set hold_slack  [expr $hold_slack  - $tAC]	
	
	# Remove the variation in the clock and DQ signals inside the FPGA
	set setup_slack [expr $setup_slack - $minmax_DQ_variation/2.0 - $minmax_clock_variation/2.0]
	set hold_slack  [expr $hold_slack  - $minmax_DQ_variation/2.0 - $minmax_clock_variation/2.0]
	
	# Remove the uncertaininty in the path tracking
	set pll_step_size [expr $::period / $::pll_steps]
	set phy_uncertainity_steps [get_micro_node_delay -micro MIMIC_PATH_UNCERTAINTY -parameters [list IO VPAD]]
	set phy_uncertainty [expr $pll_step_size * $phy_uncertainity_steps]
	set setup_slack [expr $setup_slack - $phy_uncertainty]
	set hold_slack  [expr $hold_slack  - $phy_uncertainty]
	
	# Remove the worst-case quantization uncertainty
	set setup_slack [expr $setup_slack - $pll_step_size/2.0]
	set hold_slack  [expr $hold_slack - $pll_step_size/2.0]

	# Remove SSN effects
	set setup_slack [expr $setup_slack - $::SSN(pushout_i)]
	set hold_slack  [expr $hold_slack  - $::SSN(pullin_i)]
	
	# Remove the board skew
	set setup_slack [expr $setup_slack - $::board(intra_DQS_group_skew)/2]
	set hold_slack  [expr $hold_slack  - $::board(intra_DQS_group_skew)/2]

	lappend summary [list $opcname 0 "Read Capture ($opcname)" $setup_slack $hold_slack]
}

proc perform_macro_read_capture_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name IP_name} {

	################################################################################
	# This timing analysis covers the read timing constraints using the Altera 
	# characterized values.  Altera performs characterization on its devices and IP 
	# to determine all the FPGA uncertainties, and uses these values to provide accurate 
	# timing analysis.  
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 ::$IP_name IP
	upvar 1 $pin_array_name pins
	global ::instname
	global ::dll_length
	global ::period
	global ::dqs_phase
	global ::tDCD
	global ::family
	
	# Convert from DDR1/2 type specs to DDR3 type specs to keep the analysis below simple and concise
	if {($IP(mem_if_memtype) == "DDR2 SDRAM") || ($IP(mem_if_memtype) == "DDR SDRAM")} {
		set t(QH) [expr $::period*(0.5 - $::tDCD) - $t(QHS)]
	}	
	
	# Read capture
	set tDQSQ $t(DQSQ)
	set tQH $t(QH)
	set tAC $t(AC)
	if {$::family == "cyclone iv"} {
		set tDCD_total $t(DCD_total)
	} else {
		set tDCD_total 0
	}
	set tmin_additional_dqs_variation $t(min_additional_dqs_variation)
	set tmax_additional_dqs_variation $t(max_additional_dqs_variation)
	set all_read_dqs_list [get_all_dqs_pins $pins(dqsgroup)]
	if {$::family == "arria ii"} {
		set tsw [get_tsw $IP(mem_if_memtype) $all_read_dqs_list $::period -dll_length $::dll_length -ddr3_discrete $IP(discrete_device)]
	} elseif {$::family == "cyclone iv"} {
		set tsw [get_tsw $IP(mem_if_memtype) $all_read_dqs_list $::period ]
	} elseif {($::family == "stratix iii") || ($::family == "hardcopy iii") || ($::family == "stratix iv") || ($::family == "hardcopy iv")} {
		if {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 1)} {
			set tsw [get_tsw $IP(mem_if_memtype) $all_read_dqs_list $::period -read_deskew $IP(read_deskew_mode) -dll_length $::dll_length -config_period $::period -ddr3_discrete 1]  
		} else {
			set tsw [get_tsw $IP(mem_if_memtype) $all_read_dqs_list $::period -read_deskew $IP(read_deskew_mode) -dll_length $::dll_length -config_period $::period]			
		}
	}
	set read_board_skew $t(board_skew)

	if {$::family == "cyclone iv"} {
		set su   [round_3dp [expr {0.25*$::period - 0.5*$tDCD_total - $tAC - [lindex $tsw 0]/1000.0 - 0.5 * $t(board_skew)}]]
		set hold [round_3dp [expr {0.25*$::period - 0.5*$tDCD_total - $tAC - [lindex $tsw 1]/1000.0 - 0.5 * $t(board_skew)}]]
	} else {
		if {($IP(read_deskew_mode) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM")} {
			if {[catch {get_micro_node_delay -micro EXTERNAL_SKEW_THRESHOLD -parameters [list IO]} compensated_skew] != 0 || $compensated_skew == ""} {
			  # No skew compensation
			} else {
			  set compensated_skew [expr $compensated_skew / 1000.0]
			  if {$t(board_skew) > $compensated_skew} {
				set read_board_skew [expr $t(board_skew) - $compensated_skew]
			  } else {
				set read_board_skew 0
			  }
			}
		}

		set su   [round_3dp [expr {$::period*$::dqs_phase/360.0 - [lindex $tsw 0]/1000.0 - $tDQSQ + $tmin_additional_dqs_variation - $read_board_skew}]]
		set hold [round_3dp [expr {$tQH - $tmax_additional_dqs_variation - $::period*$::dqs_phase/360.0 - [lindex $tsw 1]/1000.0 - $read_board_skew}]]
	}
	lappend summary [list "All Conditions" 0 "Read Capture (All Conditions)" $su $hold]
}


##############################################################
## Calibrated Path Analysis
##############################################################

proc perform_macro_resync_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name MP_name IP_name board_parameters_name} {

	################################################################################
	# The resynchronization timing analysis concerns transferring read data that
	# has been captured with a DQS strobe to a clock domain under the control of
	# the ALTMEMPHY. We use a dedicated PLL phase that is calibrated by the
	# sequencer, and tracks any movements in the data valid window of the captured
	# data. This means that the exact length of the DQS and CK traces don't affect
	# the timing analysis, and the calibration will remove any static offset from
	# the rest of the path too. With static offset removed, the remaining
	# uncertainties with be limited to VT variation, jitter and skew (since one
	# clock phase is chosen for the whole interface).
	# 
	################################################################################
	
	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$MP_name MP
	upvar 1 ::$IP_name IP
	upvar 1 ::$board_parameters_name board		
	global ::instname	
	global ::period
	global ::pll_steps
	global ::tJITper
	global ::interface_type
	global ::dqs_phase_setting
	global ::family
	
	set tDQSCK $t(DQSCK)
	set fpga_leveling_step $IP(quantization_T9)
	set fpga_leveling_step_variation [expr $fpga_leveling_step*[get_float_table_node_delay -src {DELAYCHAIN_T1} -dst {VTVARIATION} -parameters [list IO $::interface_type]]*2]
	set DQS_clock_period_jitter [expr [get_integer_node_delay -integer $::dqs_phase_setting -parameters {IO MAX HIGH} -src DQS_JITTER]/1000.0]
	
	if {$::family == "stratix iii"} {
		set ::tJITper 0.160
	}
	
	# Find DQS clock skew
	if {($::family == "arria ii") || ($::family == "stratix iv")} {
		if {$IP(mem_if_memtype) == "DDR3 SDRAM"} {
			if {($::family == "arria ii") || ($::family == "stratix iv")} {
				if {$::family == "arria ii"} {
					set beforeDQSbus ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dq_dqs|dqs_*_inst|dqsbusout
					set afterDQSbus  ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dq_dqs|bidir_dq_*_ddio_in_inst|clk
				} elseif {$::family == "stratix iv"} {
					set beforeDQSbus ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dqs_ip|ddr*_dqs_enable_ctrl_gen.dqs_enable_atom|dqsbusout
					set afterDQSbus  ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dq[*].dq_pad|ddr_dq_ddio_in_gen.dqi_ddio_in|clk
				}
				set maxDQSskew [max_in_collection [get_path -from $beforeDQSbus -to $afterDQSbus] "arrival_time"]
				set minDQSskew [min_in_collection [get_path -from $beforeDQSbus -to $afterDQSbus -min_path]  "arrival_time"]
				set DQS_clock_skew [expr $maxDQSskew - $minDQSskew]
				set resync_clock_skew $DQS_clock_skew
			} else {
				set DQS_clock_skew 0.035
				set resync_clock_skew 0.05		
			}
		} else {
			set DQS_clock_skew 0.035
			set resync_clock_skew 0.05		
		}
	} else {
		set DQS_clock_skew 0.035
		set resync_clock_skew 0.05
	}
	
	if {$family == "stratix iii"} {
		global ::ip_pll_steps
		set pll_step_size [expr $::period / $::ip_pll_steps]
	} else {
		set pll_step_size [expr $::period / $::pll_steps]
	}
	set phy_uncertainity_steps [get_micro_node_delay -micro MIMIC_PATH_UNCERTAINTY -parameters [list IO VPAD]]
	set phy_uncertainty [expr $pll_step_size * $phy_uncertainity_steps * 2]
	set resync_clock_jitter $::tJITper
	if {$::family == "arria ii"} {
		set resync_micro_tsu [expr [get_ff_node_delay -buried FF -micro TSU -parameters [list IO $::interface_type FF RESYNC_FF]]/1000.0]
		set resync_micro_th  [expr [get_ff_node_delay -buried FF -micro TH  -parameters [list IO $::interface_type FF RESYNC_FF]]/1000.0]
	} elseif {$::family == "stratix iv"} {
		set resync_micro_tsu [expr [get_ff_node_delay -buried IN0_DFF -micro TSU -parameters [list INPUT_PHASE_ALIGNMENT $::interface_type]]/1000.0]
		set resync_micro_th [expr [get_ff_node_delay -buried IN0_DFF -micro TH -parameters [list INPUT_PHASE_ALIGNMENT $::interface_type]]/1000.0]
	} elseif {($::family == "stratix iii") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
		set resync_micro_tsu [expr [get_ff_node_delay -buried IN0_DFF -micro TSU -parameters [list INPUT_PHASE_ALIGNMENT]]/1000.0]
		set resync_micro_th [expr [get_ff_node_delay -buried IN0_DFF -micro TH -parameters [list INPUT_PHASE_ALIGNMENT]]/1000.0]
	} else {
		set resync_micro_tsu 0.09
		set resync_micro_th 0.12
	}
	set max_read_leveling_delay_steps [expr floor($pll_step_size / $fpga_leveling_step)]
	
	if {($IP(mem_if_memtype) == "DDR2 SDRAM") || ($IP(mem_if_memtype) == "DDR SDRAM")} {
		# DDR1/2 doesn't have deskew calibration
		set read_leveling_delay_VT_variation 0
	} elseif {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 1)} { 
		set read_leveling_delay_VT_variation 0
	} else {
		set read_leveling_delay_VT_variation [expr $max_read_leveling_delay_steps * $fpga_leveling_step_variation]
	}
	
	
	set resync_window [expr $::period - 2 * $tDQSCK - 2 * $::tJITper/2 - 2 * $DQS_clock_period_jitter - $DQS_clock_skew  - $phy_uncertainty - $resync_clock_skew - 2 * $resync_clock_jitter/2 - 2 * $read_leveling_delay_VT_variation - $resync_micro_tsu - $resync_micro_th]
	set su [round_3dp [expr $resync_window * 0.5]]
	set hold [round_3dp [expr $resync_window * 0.5]]
	lappend summary [list $opcname 0 "Read Resync ($opcname)" $su $hold]

}

proc perform_flexible_resync_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name MP_name IP_name SSN_name board_parameters_name} {

	################################################################################
	# The resynchronization timing analysis concerns transferring read data that
	# has been captured with a DQS strobe to a clock domain under the control of
	# the ALTMEMPHY. We use a dedicated PLL phase that is calibrated by the
	# sequencer, and tracks any movements in the data valid window of the captured
	# data. This means that the exact length of the DQS and CK traces don't affect
	# the timing analysis, and the calibration will remove any static offset from
	# the rest of the path too. With static offset removed, the remaining
	# uncertainties with be limited to VT variation, jitter and skew (since one
	# clock phase is chosen for the whole interface).
	# 
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$MP_name MP
	upvar 1 ::$SSN_name SSN
	upvar 1 ::$board_parameters_name board	
	upvar 1 ::$IP_name IP	
	global ::instname	
	global ::period
	global ::pll_steps
	global ::tJITper
	global ::interface_type
	global ::dqs_phase_setting
	global ::max_package_skew
	global ::io_std
	global ::family
	
	########################################
	## Check family support
	if {!(($::family == "arria ii") || ($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv"))} {
		puts "The report_timing script does not support the $::family device family"
		return
	}
	
	# Arria II resync-register-in-periphery-check
	if {$::family == "arria ii"} {
		set resync_dly [max_in_collection [get_path -from *ddio_in_inst_regout* -to *rdata_*_ams*] "arrival_time"]
		if {$resync_dly > 0.2} {
			post_message -type warning "Resynchronization registers are placed in the FPGA core causing Read Resync timing to fail"
			set setup_slack [expr 0 - $resync_dly]
			set hold_slack $setup_slack
			lappend summary [list $opcname 0 "Read Resync ($opcname)" $setup_slack $hold_slack]
			return
		}
	}		
	
	# Ideal setup and hold slacks is half the period
	set setup_slack [expr 0.5*$::period]
	set hold_slack  [expr 0.5*$::period]
	
	# Remove the variation in the clock coming back from the memory
	set tDQSCK $t(DQSCK)
	if {($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		set tDQSCK [expr (1.0-$MP(DQSCK))*$tDQSCK]
	}
	set setup_slack [expr $setup_slack - $tDQSCK]
	set hold_slack  [expr $hold_slack  - $tDQSCK]	
	
	# Remove setup and hold times of the register
	if {$::family == "arria ii"} {
		set resync_micro_tsu [expr [get_ff_node_delay -buried FF -micro TSU -parameters [list IO $::interface_type FF RESYNC_FF]]/1000.0]
		set resync_micro_th  [expr [get_ff_node_delay -buried FF -micro TH  -parameters [list IO $::interface_type FF RESYNC_FF]]/1000.0]
	} elseif {$::family == "stratix iv"} {
		set resync_micro_tsu [expr [get_ff_node_delay -buried IN0_DFF -micro TSU -parameters [list INPUT_PHASE_ALIGNMENT $::interface_type]]/1000.0]
		set resync_micro_th [expr [get_ff_node_delay -buried IN0_DFF -micro TH -parameters [list INPUT_PHASE_ALIGNMENT $::interface_type]]/1000.0]
	} elseif {($::family == "hardcopy iv") || ($::family == "hardcopy iii")} {
		set resync_micro_tsu [expr [get_ff_node_delay -buried IN0_DFF -micro TSU -parameters [list INPUT_PHASE_ALIGNMENT]]/1000.0]
		set resync_micro_th [expr [get_ff_node_delay -buried IN0_DFF -micro TH -parameters [list INPUT_PHASE_ALIGNMENT]]/1000.0]
	}
	set resync_micro_tsu_th [expr ($resync_micro_tsu + $resync_micro_th)/2]
	set setup_slack [expr $setup_slack - $resync_micro_tsu_th]
	set hold_slack  [expr $hold_slack  - $resync_micro_tsu_th]
	
	# Remove the DQS clock (and resync clock) skew
	if {$IP(mem_if_memtype) == "DDR3 SDRAM"} {
		if {$::family == "arria ii"} {
			set beforeDQSbus ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dq_dqs|dqs_*_inst|dqsbusout
			set afterDQSbus  ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dq_dqs|bidir_dq_*_ddio_in_inst|clk
		} elseif {($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv")} {
			set beforeDQSbus ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dqs_ip|ddr*_dqs_enable_ctrl_gen.dqs_enable_atom|dqsbusout
			set afterDQSbus  ${::instname}_alt_mem_phy_inst|dpio|dqs_group[*].dq[*].dq_pad|ddr_dq_ddio_in_gen.dqi_ddio_in|clk
		}
		set maxDQSskew [max_in_collection [get_path -from $beforeDQSbus -to $afterDQSbus] "arrival_time"]
		set minDQSskew [min_in_collection [get_path -from $beforeDQSbus -to $afterDQSbus -min_path]  "arrival_time"]
		set DQS_clock_skew [expr $maxDQSskew - $minDQSskew]
		set resync_clock_skew $DQS_clock_skew
	} else {
		set DQS_clock_skew 0.035
		set resync_clock_skew 0.05	
	}
	
	set setup_slack [expr $setup_slack - $DQS_clock_skew/2 - $resync_clock_skew/2]
	set hold_slack  [expr $hold_slack  - $DQS_clock_skew/2 - $resync_clock_skew/2]	
	
	# Remove the jitter on the clock out to the memory and the resync clock  
	set resync_clock_jitter $::tJITper
	set setup_slack [expr $setup_slack - $::tJITper/2 - $resync_clock_jitter/2]
	set hold_slack  [expr $hold_slack  - $::tJITper/2 - $resync_clock_jitter/2]
	
	# Remove the jitter on the input path (This is the full peak-to-peak jitter)
	set DQS_delay_chain_period_jitter [expr [get_integer_node_delay -integer $::dqs_phase_setting -parameters {IO MAX HIGH} -src DQS_JITTER]/1000.0]
	set DQS_path_period_jitter        [expr [get_io_standard_node_delay -dst DQDQS_JITTER -io_standard $::io_std -parameters [list IO $::interface_type]]/1000.0]
	set setup_slack [expr $setup_slack - $DQS_delay_chain_period_jitter/2 - $DQS_path_period_jitter/2]
	set hold_slack  [expr $hold_slack  - $DQS_delay_chain_period_jitter/2 - $DQS_path_period_jitter/2]	
	
	# Remove the uncertaininty in the mimic path tracking
	set pll_step_size [expr $::period / $::pll_steps]
	set phy_uncertainity_steps [get_micro_node_delay -micro MIMIC_PATH_UNCERTAINTY -parameters [list IO VPAD]]
	set phy_uncertainty [expr $pll_step_size * $phy_uncertainity_steps]
	set setup_slack [expr $setup_slack - $phy_uncertainty]
	set hold_slack  [expr $hold_slack  - $phy_uncertainty]
	
	# Remove the uncertainty due to VT variations in T7
	if {$IP(mem_if_memtype) == "DDR3 SDRAM"} {
		set max_t7_delay [expr $t(board_skew) + $::max_package_skew + $t(DQS_PSERR_min) + $DQS_clock_skew]
		set t7_vt_variation_percent [get_float_table_node_delay -src {DELAYCHAIN_T1} -dst {VTVARIATION} -parameters [list IO $::interface_type]]
		set t7_vt_variation [expr $max_t7_delay*$t7_vt_variation_percent*2]
		set setup_slack [expr $setup_slack - $t7_vt_variation]
		set hold_slack  [expr $hold_slack  - $t7_vt_variation]	
	}
	
	# Remove the worst-case quantization uncertainty
	if {($IP(mem_if_memtype) == "DDR3 SDRAM") && ($IP(discrete_device) == 0)} {
		set read_levelling_phase_step [get_micro_node_delay -micro RL_PHASE_TAP -parameters [list IO $::interface_type]]
		set quantization_error [expr $read_levelling_phase_step/360.0*$::period]
		set setup_slack [expr $setup_slack - $quantization_error/2.0]
		set hold_slack  [expr $hold_slack  - $quantization_error/2.0]
	} else {
		set setup_slack [expr $setup_slack - $pll_step_size/2]
		set hold_slack  [expr $hold_slack  - $pll_step_size/2]
		#Also consider the inter-DQS skew here (only effects non-levelled cases)
		set setup_slack [expr $setup_slack - $board(inter_DQS_group_skew)/2]
		set hold_slack  [expr $hold_slack  - $board(inter_DQS_group_skew)/2]
	}
	
	# Remove SSN effects
	set setup_slack [expr $setup_slack - $::SSN(pushout_o) - $::SSN(pushout_i)]
	set hold_slack  [expr $hold_slack  - $::SSN(pullin_o)  - $::SSN(pullin_i)]
	# Remove Multirank board skew effects - Calibration will calibrate to the average of multiple ranks
	if {$IP(num_ranks) > 1} {
		set setup_slack [expr $setup_slack - $board(tpd_inter_DIMM)]
		set hold_slack  [expr $hold_slack  - $board(tpd_inter_DIMM)]
	}
	
	lappend summary [list $opcname 0 "Read Resync ($opcname)" $setup_slack $hold_slack]
	
}

proc perform_macro_write_levelling_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name MP_name IP_name board_parameters_name ISI_parameters_name} {

	################################################################################
	# The write levelling analysis concerns meeting the DDR3 requirements between DQS 
	# and CK such as tDQSS and tDSH/tDSS.  The write-levelling is achieved through 
	# calibration by changing the phase of the DQS signal until levelling is complete 
	# at the memory.  Because of this, the exact length of the DQS and CK traces 
	# don't affect the timing analysis, and the calibration will remove any static 
	# offset from the rest of the path too.  With static offset removed, the 
	# remaining uncertainties with be limited to mostly VT variation, and jitter.
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$IP_name IP
	upvar 1 ::$MP_name MP	
	upvar 1 ::$board_parameters_name board	
	upvar 1 ::$ISI_parameters_name ISI
	global ::instname	
	global ::period
	global ::pll_steps
	global ::tJITper
	global ::tJITdty
	global ::tDCD
	global ::interface_type
	global ::dll_length
	global ::family
	
	# The ALTMEMPHY write leveling algorithm increases the DQS output phase and delay until the first 0->1 is found in the write leveling feedback, thus DQS is slightly skewed 1 step to the right of ideal alignment with CK
	set mem_fmax [expr 1.0/$t(period)*1000.0]
	set min_period [round_3dp [expr 1000.0/$mem_fmax]]

	set tWLS $t(WLS)
	set tWLH $t(WLH)
	set tDQSS_CK $t(DQSS)
	set tDQSS [expr $tDQSS_CK * $::period]
	
	set fpga_leveling_step $IP(quantization_T9)
	set fpga_leveling_step_variation [expr $fpga_leveling_step*[get_float_table_node_delay -src {DELAYCHAIN_T9} -dst {VTVARIATION} -parameters [list IO $::interface_type]]*2]

	# tDQSS specification
	set max_write_leveling_delay_steps [expr floor($::period / $::dll_length / $fpga_leveling_step)]
	set write_leveling_delay_VT_variation [expr $max_write_leveling_delay_steps * $fpga_leveling_step_variation]
	set min_write_leveling_inaccuracy [expr $tWLS + $write_leveling_delay_VT_variation]
	set max_write_leveling_inaccuracy [expr $tWLH + $write_leveling_delay_VT_variation + $fpga_leveling_step]
	
	set su [round_3dp [expr $tDQSS - $min_write_leveling_inaccuracy ]]
	set hold [round_3dp [expr $tDQSS - $max_write_leveling_inaccuracy ]]
	lappend summary [list $opcname 0 "Write Leveling tDQSS ($opcname)" $su $hold]
	
	# tDSS/tDSH specification
	set CK_period_jitter $::tJITper
	set tDSS_CK $t(DSS)
	set tDSH_CK $t(DSH)
	set tDSS [expr $tDSS_CK * $::period]
	set tDSH [expr $tDSH_CK * $::period]
	set min_DQS_low [expr $::period*(0.5 - $::tDCD) - $::tJITdty]
	set min_DQS_high [expr $::period*(0.5 - $::tDCD) - $::tJITdty]
	
	set su [round_3dp [expr $min_DQS_low - $max_write_leveling_inaccuracy - $CK_period_jitter/2 - $tDSS ]]
	set hold [round_3dp [expr $min_DQS_high - $min_write_leveling_inaccuracy - $tDSH ]]
	lappend summary [list $opcname 0 "Write Leveling tDSS/tDSH ($opcname)" $su $hold]

}


proc perform_flexible_write_levelling_timing_analysis {opcs opcname pin_array_name timing_parameters_array_name summary_name  MP_name IP_name SSN_name board_parameters_name ISI_parameters_name} {

	################################################################################
	# The write levelling analysis concerns meeting the DDR3 requirements between DQS 
	# and CK such as tDQSS and tDSH/tDSS.  The write-levelling is achieved through 
	# calibration by changing the phase of the DQS signal until levelling is complete 
	# at the memory.  Because of this, the exact length of the DQS and CK traces 
	# don't affect the timing analysis, and the calibration will remove any static 
	# offset from the rest of the path too.  With static offset removed, the 
	# remaining uncertainties with be limited to mostly VT variation, and jitter.
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$MP_name MP
	upvar 1 ::$SSN_name SSN
	upvar 1 ::$IP_name IP
	upvar 1 ::$board_parameters_name board
	upvar 1 ::$ISI_parameters_name ISI	
	global ::instname	
	global ::period
	global ::pll_steps
	global ::tJITper
	global ::tJITdty
	global ::tDCD
	global ::interface_type
	global ::dll_length
	global ::family
	
	########################################
	## Check family support
	if {!(($::family == "stratix iv") || ($::family == "hardcopy iii") || ($::family == "hardcopy iv"))} {
		puts "The report_timing script does not support the $::family device family"
		return
	}		
	
	#################################
	## tDQSS specification
	
	# Ideal setup and hold slacks is the tDQSS specification
	set tDQSS_CK $t(DQSS)
	if {($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		set tDQSS_CK [expr 0.5 - (1-$MP(DQSS))*(0.5-$t(DQSS))]
	} elseif {$IP(mp_calibration) == 1} {
		set tDQSS_CK [expr 0.5 - (1-$MP(DQSS)/2)*(0.5-$t(DQSS))]
	}
	set tDQSS [expr $tDQSS_CK * $::period]
	set setup_slack $tDQSS
	set hold_slack  $tDQSS
	
	# Remove the setup and hold times of the WL register in the memory
	set tWLS $t(WLS)
	set tWLH $t(WLH)
	if {($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		set tWLS [expr (1-$MP(WLS))*$tWLS]
		set tWLH [expr (1-$MP(WLH))*$tWLH]
	}
	set setup_slack [expr $setup_slack - $tWLH]
	set hold_slack  [expr $hold_slack  - $tWLS]	
	
	# Remove the uncertainty due to VT variations in T9
	set write_levelling_phase_step [get_micro_node_delay -micro WL_PHASE_TAP -parameters [list IO $::interface_type]]
	set max_t9_delay [expr $write_levelling_phase_step/360.0*$::period]
	set t9_vt_variation_percent [get_float_table_node_delay -src {DELAYCHAIN_T9} -dst {VTVARIATION} -parameters [list IO $::interface_type]]
	set t9_vt_variation [expr $max_t9_delay*$t9_vt_variation_percent*2]
	set setup_slack [expr $setup_slack - $t9_vt_variation]
	set hold_slack  [expr $hold_slack  - $t9_vt_variation]
	
	# Remove the jitter on the clock out to the memory (CK and DQS could be in worst-case directions) 
	set setup_slack [expr $setup_slack - $::tJITper/2 - $::tJITper/2]
	set hold_slack  [expr $hold_slack  - $::tJITper/2 - $::tJITper/2]
	
	# Remove the jitter on the Write Levelling delay chains (this is peak-to-peak jitter
	set WL_jitter [expr [get_micro_node_delay -micro WL_JITTER -parameters [list IO $::interface_type]]/1000.0]
	set setup_slack [expr $setup_slack - $WL_jitter/2]
	set hold_slack  [expr $hold_slack  - $WL_jitter/2]	
	
	# Remove SSN effects
	set setup_slack [expr $setup_slack - $::SSN(pushout_o) - $::SSN(pullin_o)]
	set hold_slack  [expr $hold_slack  - $::SSN(pushout_o) - $::SSN(pullin_o)]	
	
	# Remove Multirank board skew effects - Calibration will calibrate to the average of multiple ranks
	if {$IP(num_ranks) > 1} {
		set max_calibration_offset [expr abs($board(maxCK_DQS_skew) - $board(minCK_DQS_skew))]
		set setup_slack [expr $setup_slack - $max_calibration_offset - $ISI(DQS)/2]
		set hold_slack  [expr $hold_slack  - $max_calibration_offset - $ISI(DQS)/2]
	}		
	
	# Remove the worst-case quantization uncertainty
	# The ALTMEMPHY write leveling algorithm increases the DQS output phase and delay until the first 0->1 is found in 
	#   the write leveling feedback, thus DQS is slightly skewed 1 step to the right of ideal alignment with CK
	set hold_slack [expr $hold_slack - $IP(quantization_T9)]
	
	lappend summary [list $opcname 0 "Write Leveling tDQSS ($opcname)" $setup_slack $hold_slack]
	
	#################################
	## tDSS/tDSH specification	
	
	# Ideal setup and hold slacks is half the period
	set setup_slack [expr 0.5*$::period]
	set hold_slack  [expr 0.5*$::period]	
	
	# Remove the setup and hold times of the WL register in the memory
	set setup_slack [expr $setup_slack - $tWLS]
	set hold_slack  [expr $hold_slack  - $tWLH]
	
	# Remove the tDSS and tDSH specifications
	set tDSS_CK $t(DSS)
	set tDSH_CK $t(DSH)
	if {($IP(mp_calibration) == 1) && ($IP(num_ranks) == 1)} {
		set tDSS_CK [expr (1.0-$MP(DSS))*$t(DSS)]
		set tDSH_CK [expr (1.0-$MP(DSH))*$t(DSH)]	
	} elseif {$IP(mp_calibration) == 1} {
		set tDSS_CK [expr (1.0-$MP(DSS)/2.5)*$t(DSS)]
		set tDSH_CK [expr (1.0-$MP(DSH)/2.5)*$t(DSH)]	
	}
	set tDSS [expr $tDSS_CK * $::period]
	set tDSH [expr $tDSH_CK * $::period]
	set setup_slack [expr $setup_slack - $tDSS]
	set hold_slack  [expr $hold_slack  - $tDSH]
	
	# Remove the uncertainty due to VT variations in T9
	#set write_levelling_phase_step [get_micro_node_delay -micro WL_PHASE_STEP -parameters [list IO VPAD]]
	set setup_slack [expr $setup_slack - $t9_vt_variation]
	set hold_slack  [expr $hold_slack  - $t9_vt_variation]		
	
	# Remove the jitter on the clock out to the memory (CK and DQS could be in worst-case directions) 
	set setup_slack [expr $setup_slack - $::tJITper/2 - $::tJITper/2]
	set hold_slack  [expr $hold_slack  - $::tJITper/2 - $::tJITper/2]
	
	# Remove the jitter on the Write Levelling delay chains (this is peak-to-peak jitter
	set setup_slack [expr $setup_slack - $WL_jitter/2]
	set hold_slack  [expr $hold_slack  - $WL_jitter/2]	
	
	# Remove SSN effects
	set setup_slack [expr $setup_slack - $::SSN(pushout_o) - $::SSN(pullin_o)]
	set hold_slack  [expr $hold_slack  - $::SSN(pushout_o) - $::SSN(pullin_o)]		
	
	# Multirank derating
	if {$IP(num_ranks) > 1} {
		set max_calibration_offset [expr abs($board(maxCK_DQS_skew) - $board(minCK_DQS_skew))]
		set setup_slack [expr $setup_slack - $max_calibration_offset - $ISI(DQS)/2]
		set hold_slack  [expr $hold_slack  - $max_calibration_offset - $ISI(DQS)/2]
	}		
	
	# Remove the worst-case quantization uncertainty
	# The ALTMEMPHY write leveling algorithm increases the DQS output phase and delay until the first 0->1 is found in 
	#   the write leveling feedback, thus DQS is slightly skewed 1 step to the right of ideal alignment with CK
	set setup_slack [expr $setup_slack - $IP(quantization_T9)]	
	
	# Duty Cycle Effects
	set setup_slack [expr $setup_slack - $t(WL_DCJ) - $t(WL_DCD)]
	set hold_slack  [expr $hold_slack  - $t(WL_DCJ) - $t(WL_DCD)]			
	
	# Duty Cycle Correction
	if {($IP(write_dcc) == "dynamic") && ($IP(mem_if_memtype) == "DDR3 SDRAM")} {
		#First remove the Systematic DCD
		set setup_slack [expr $setup_slack + $t(WL_DCD)]
		set hold_slack  [expr $hold_slack + $t(WL_DCD)]
		
		#Add errors in the DCC
		set DCC_quantization $IP(quantization_DCC)
		set setup_slack [expr $setup_slack - $DCC_quantization]
		set hold_slack  [expr $hold_slack - $DCC_quantization]
		
		# Consider variation in the DCC 
		set dcc_vt_variation_percent [get_float_table_node_delay -src {DELAYCHAIN_DUTY_CYCLE} -dst {VTVARIATION} -parameters [list IO $::interface_type]]
		set dcc_variation [expr $t(WL_DCD)*2*$dcc_vt_variation_percent]
		set setup_slack [expr $setup_slack - $dcc_variation]
		set hold_slack  [expr $hold_slack - $dcc_variation]		
	}	

	lappend summary [list $opcname 0 "Write Leveling tDSS/tDSH ($opcname)" $setup_slack $hold_slack]

}

##############################################################
## Other Timing Analysis
##############################################################

proc perform_phy_analyses {opcs opcname pin_array_name timing_parameters_array_name summary_name IP_name} {

	################################################################################
	# The PHY analysis concerns the timing requirements of the PHY which includes
	# soft registers in the FPGA core as well as some registers in the hard periphery
	# The read capture and write registers are not analyzed here, even though they 
	# are part of the PHY since they are timing analyzed separately. 
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$IP_name IP
	global ::instname	
	global ::alldqspins
	global ::full_instance_name
	global ::family
	
	########################################
	## Check family support
	if {!(($::family == "stratix iii") || ($::family == "hardcopy iii") || ($::family == "arria ii") || ($::family == "stratix iv") || ($::family == "hardcopy iv") || ($::family == "cyclone iv"))} {
		puts "The report_timing script does not support the $::family device family"
		return
	}		

	# Some of the paths that would be analyzed by default in the Phy timing analysis are already report by the Read Capture analysis
	# Do not repeat the timing analysis of those paths
	set all_phy_registers [get_registers  "$::full_instance_name|*" ]
	if {$::family == "arria ii"} {
		set DFF_low_registers [get_registers "$::full_instance_name|*ddio_in_inst~DFFLO"]
		set DFF_high_registers [get_registers "$::full_instance_name|*_ddio_in_inst_regouthi"]
	} elseif {$::family == "cyclone iv"} {
		set DFF_low_registers [get_registers "$::full_instance_name|*input_cell_l[*]"]
		set DFF_high_registers [get_registers "$::full_instance_name|*input_cell_h[*]"]
	} elseif {($::family == "stratix iii") || ($::family == "hardcopy iii") || ($::family == "stratix iv") || ($::family == "hardcopy iv")}  {
		set DFF_low_registers [get_registers "$::full_instance_name|*dq_pad|ddr_dq_ddio_in_gen.dqi_ddio_in~DFFLO"]
		set DFF_high_registers [get_registers "$::full_instance_name|*dq_pad|dqi_captured_h"]
	}
	if {[get_collection_size $DFF_low_registers] != 0} {
		set all_phy_registers [remove_from_collection $all_phy_registers $DFF_low_registers]
	}
	if {[get_collection_size $DFF_high_registers] != 0} {
		set all_phy_registers [remove_from_collection $all_phy_registers $DFF_high_registers]
	}		
	set res_0 [report_timing -detail full_path -to $all_phy_registers -npaths 100 -panel_name "$::instname Phy \u0028setup\u0029" -setup]
	set res_1 [report_timing -detail full_path -to $all_phy_registers -npaths 100 -panel_name "$::instname Phy \u0028hold\u0029" -hold]
	if {$::family == "cyclone iv"} {
		# Need to also report the clock to read capture registers here for Cyclone device families
		set res_00 [report_timing -detail full_path -from [lindex $pins(ck_p) 0] -to $DFF_high_registers -npaths 100 -panel_name "$::instname Phy \u0028setup 2\u0029" -setup]
		set res_11 [report_timing -detail full_path -from [lindex $pins(ck_p) 0] -to $DFF_high_registers -npaths 100 -panel_name "$::instname Phy \u0028hold 2\u0029" -hold]
		lset res_0 1 [min [lindex $res_0 1] [lindex $res_00 1]]
		lset res_1 1 [min [lindex $res_1 1] [lindex $res_11 1]]
	}
	lappend summary [list $opcname 0 "Phy ($opcname)" [lindex $res_0 1] [lindex $res_1 1]]	

	# Phy Reset
	set res_0 [report_timing -detail full_path -to [get_registers  "$::full_instance_name|*" ] -npaths 100 -panel_name "$::instname Phy Reset \u0028recovery\u0029" -recovery]
	set res_1 [report_timing -detail full_path -to [get_registers  "$::full_instance_name|*" ] -npaths 100 -panel_name "$::instname Phy Reset \u0028removal\u0029" -removal]
	lappend summary [list $opcname 0 "Phy Reset ($opcname)" [lindex $res_0 1] [lindex $res_1 1]]	
	
	# Mimic
	if {$::family == "cyclone iv"} {
		set res_1 [list xxx ""]
		set res_0 [report_timing -detail full_path -from $pins(ck_p) -to * -npaths 100 -panel_name "$::instname Mimic \u0028setup\u0029" -setup]
		lappend summary [list $opcname 0 "Mimic ($opcname)" [lindex $res_0 1] [lindex $res_1 1]]
	}
}

proc perform_ac_analyses {opcs opcname pin_array_name timing_parameters_array_name summary_name IP_name} {

	################################################################################
	# The adress/command analysis concerns the timing requirements of the pins (other
	# than the DQ pins) which go to the memory device/DIMM.  These include address/command
	# pins, some of which are runing at Single-Data-Rate (SDR) and some which are 
	# running at Half-Data-Rate (HDR).  The CK vs DQS requirement for DDR1/2 also occurs
	# here.
	################################################################################

	########################################
	## Need access to global variables
	upvar 1 $summary_name summary
	upvar 1 ::$timing_parameters_array_name t
	upvar 1 $pin_array_name pins
	upvar 1 ::$IP_name IP
	global ::instname	
	global ::alldqspins
	global ::full_instance_name
	global ::family

	########################################
	## Address/Command Analysis		

	# Address Command
	if {[llength $pins(addrcmd)] > 0} {
		set res_0 [report_timing -detail full_path -to $pins(addrcmd) -npaths 100 -panel_name "$::instname Address Command \u0028setup\u0029" -setup]
		set res_1 [report_timing -detail full_path -to $pins(addrcmd) -npaths 100 -panel_name "$::instname Address Command \u0028hold\u0029" -hold]
		lappend summary [list $opcname 0 "Address Command ($opcname)" [lindex $res_0 1] [lindex $res_1 1]]
	}
	
	# Half Rate Address/Command
	if {[llength $pins(addrcmd_2t)] > 0} {
		set res_0 [report_timing -detail full_path -to $pins(addrcmd_2t) -npaths 100 -panel_name "$::instname Half Rate Address/Command \u0028setup\u0029" -setup]
		set res_1 [report_timing -detail full_path -to $pins(addrcmd_2t) -npaths 100 -panel_name "$::instname Half Rate Address/Command \u0028hold\u0029" -hold]
		lappend summary [list $opcname 0 "Half Rate Address/Command ($opcname)" [lindex $res_0 1] [lindex $res_1 1]]
	}
	
	########################################
	## DQS vs CK (For DDR1/2 only)
	
	if {($IP(mem_if_memtype) == "DDR2 SDRAM") || ($IP(mem_if_memtype) == "DDR SDRAM")} {
		set res_0 [report_timing -detail full_path -to [get_ports $::alldqspins] -npaths 100 -panel_name "$::instname DQS vs CK \u0028setup\u0029" -setup]
		set res_1 [report_timing -detail full_path -to [get_ports $::alldqspins] -npaths 100 -panel_name "$::instname DQS vs CK \u0028hold\u0029" -hold]
		lappend summary [list $opcname 0 "DQS vs CK ($opcname)" [lindex $res_0 1] [lindex $res_1 1]]
	}
}
