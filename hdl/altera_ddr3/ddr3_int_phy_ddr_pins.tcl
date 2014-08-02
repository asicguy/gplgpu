# This is a library of useful functions to include at the top of an SDC file.

proc traverse_atom_path {atom_id atom_oport_id path} {
	# Return list of {atom oterm_id} pairs by tracing the atom netlist starting from the given atom_id through the given path
	# Path consists of list of {atom_type fanin|fanout|end <port_type> <-optional>}
	set result [list]
	if {[llength $path] > 0} {
		set path_point [lindex $path 0]
		set atom_type [lindex $path_point 0]
		set next_direction [lindex $path_point 1]
		set port_type [lindex $path_point 2]
		set atom_optional [lindex $path_point 3]
		if {[get_atom_node_info -key type -node $atom_id] == $atom_type} {
			if {$next_direction == "end"} {
				if {[get_atom_port_info -key type -node $atom_id -port_id $atom_oport_id -type oport] == $port_type} {
					lappend result [list $atom_id $atom_oport_id]
				}
			} elseif {$next_direction == "atom"} {
				lappend result [list $atom_id]
			} elseif {$next_direction == "fanin"} {
				set atom_iport [get_atom_iport_by_type -node $atom_id -type $port_type]
				if {$atom_iport != -1} {
					set iport_fanin [get_atom_port_info -key fanin -node $atom_id -port_id $atom_iport -type iport]
					set source_atom [lindex $iport_fanin 0]
					set source_oterm [lindex $iport_fanin 1]
					set result [traverse_atom_path $source_atom $source_oterm [lrange $path 1 end]]
				}
			} elseif {$next_direction == "fanout"} {
				set atom_oport [get_atom_oport_by_type -node $atom_id -type $port_type]
				if {$atom_oport != -1} {
					set oport_fanout [get_atom_port_info -key fanout -node $atom_id -port_id $atom_oport -type oport]
					foreach dest $oport_fanout {
						set dest_atom [lindex $dest 0]
						set dest_iterm [lindex $dest 1]
						set fanout_result_list [traverse_atom_path $dest_atom -1 [lrange $path 1 end]]
						foreach fanout_result $fanout_result_list {
							if {[lsearch $result $fanout_result] == -1} {
								lappend result $fanout_result
							}
						}
					}
				}
			} else {
				error "Unexpected path"
			}
		} elseif {$atom_optional == "-optional"} {
			set result [traverse_atom_path $atom_id $atom_oport_id [lrange $path 1 end]]
		}
	}
	return $result
}

proc traverse_to_dll_id {dqs_pin msg_list_name} {
	upvar 1 $msg_list_name msg_list
	set dqs_pin_id [get_atom_node_by_name -name $dqs_pin]
	set dqs_to_dll_path [list {IO_PAD fanout PADOUT} {IO_IBUF fanout O} {DQS_DELAY_CHAIN fanin DELAYCTRLIN} {DLL end DELAYCTRLOUT}]
	set dll_id_list [traverse_atom_path $dqs_pin_id -1 $dqs_to_dll_path]
	set dll_id -1
	if {[llength $dll_id_list] == 1} {
		set dll_atom_oterm_pair [lindex $dll_id_list 0]
		set dll_id [lindex $dll_atom_oterm_pair 0]
	} elseif {[llength $dll_id_list] > 1} {
		lappend msg_list "Error: Found more than 1 DLL"
	} else {
		lappend msg_list "Error: DLL not found"
	}
	return $dll_id
}

proc traverse_to_dll {dqs_pin msg_list_name} {
	upvar 1 $msg_list_name msg_list
	set dll_id [traverse_to_dll_id $dqs_pin msg_list]
	if {$dll_id != -1} {
		set result [get_atom_node_info -key name -node $dll_id]
	} else {
		set result ""
	}
	return $result
}

proc traverse_to_dqs_delaychain_id {dqs_pin msg_list_name} {
	upvar 1 $msg_list_name msg_list
	set dqs_pin_id [get_atom_node_by_name -name $dqs_pin]
	set dqs_to_delaychain_path [list {IO_PAD fanout PADOUT} {IO_IBUF fanout O} {DQS_DELAY_CHAIN atom}]
	set delaychain_id_list [traverse_atom_path $dqs_pin_id -1 $dqs_to_delaychain_path]
	set delaychain_id -1
	if {[llength $delaychain_id_list] == 1} {
		set delaychain_atom_oterm_pair [lindex $delaychain_id_list 0]
		set delaychain_id [lindex $delaychain_atom_oterm_pair 0]
	} elseif {[llength $delaychain_id_list] > 1} {
		lappend msg_list "Error: Found more than 1 DQS delaychain"
	} else {
		lappend msg_list "Error: DQS delaychain not found"
	}
	return $delaychain_id
}

# Get the fitter name of the PLL output driving the given pin
proc traverse_to_ddio_out_pll_clock {pin msg_list_name family} {
	upvar 1 $msg_list_name msg_list
	set result ""
	if {$pin != ""} {
		set pin_id [get_atom_node_by_name -name $pin]
		if {($family == "arria ii") || ($family == "cyclone iv")} {
			set pin_to_pll_path [list {IO_PAD fanin PADIN} {IO_OBUF fanin I} {PSEUDO_DIFF_OUT fanin I -optional} {DDIO_OUT fanin CLKHI -optional} {CLKBUF fanin INCLK -optional} {PLL end CLK}]
		} else {
			set pin_to_pll_path [list {IO_PAD fanin PADIN} {IO_OBUF fanin I} {PSEUDO_DIFF_OUT fanin I -optional} {DELAY_CHAIN fanin DATAIN -optional} {DELAY_CHAIN fanin DATAIN -optional} {DDIO_OUT fanin CLKHI -optional} {OUTPUT_PHASE_ALIGNMENT fanin CLK -optional} {CLKBUF fanin INCLK -optional} {PLL end CLK}]
		}
		set pll_id_list [traverse_atom_path $pin_id -1 $pin_to_pll_path]
		if {[llength $pll_id_list] == 1} {
			set atom_oterm_pair [lindex $pll_id_list 0]
			set result [get_atom_port_info -key name -node [lindex $atom_oterm_pair 0] -port_id [lindex $atom_oterm_pair 1] -type oport]
		} else {
			lappend msg_list "Error: PLL clock not found for $pin"
		}
	}
	return $result
}

proc verify_high_performance_timing_assumptions {instname pin_array_name write_deskew_t10 discrete_device flexible_timing family} {
	upvar 1 $pin_array_name pins
	set num_errors 0
	load_package verify_ddr
	set ck_pins [lsort $pins(ck_p)]
	set ckn_pins [lsort $pins(ck_n)]
	set ck_ckn_pairs [list]
	set failed_assumptions [list]

	if {[llength $ck_pins] > 0 && [llength $ck_pins] == [llength $ckn_pins]} {
  		for {set ck_index 0} {$ck_index != [llength $ck_pins]} {incr ck_index} {
    		lappend ck_ckn_pairs [list [lindex $ck_pins $ck_index] [lindex $ckn_pins $ck_index]]
		}
	} else {
		incr num_errors
		lappend failed_assumptions "Error: Could not locate same number of CK pins as CK# pins"
	}

	set read_pins_list [list]
	set write_pins_list [list]
	set read_clock_pairs [list]
	set write_clock_pairs [list]
	foreach dqsgroup $pins(dqsgroup) {
		set dqs [lindex $dqsgroup 0]
		set dq_list [lindex $dqsgroup 2]
		lappend read_pins_list [list $dqs $dq_list]
		set dm_list [lindex $dqsgroup 1]
		lappend write_pins_list [list $dqs [concat $dq_list $dm_list]]
		set dqsn [lindex $dqsgroup 3]
		lappend read_clock_pairs [list $dqs $dqsn]
	}
	set write_clock_pairs $read_clock_pairs
	set all_write_dqs_list [get_all_dqs_pins $pins(dqsgroup)]
	set all_d_list [get_all_dq_pins $pins(dqsgroup)]
	if {[llength $pins(dqsgroup)] == 0} {
		incr num_errors
		lappend failed_assumptions "Error: Could not locate DQS pins"
	}

	if {$num_errors == 0} {
		set msg_list [list]
		set dll_name [traverse_to_dll $dqs msg_list]
		set clk_to_write_d [traverse_to_ddio_out_pll_clock [lindex $all_d_list 0] msg_list $family]
		set clk_to_write_clock [traverse_to_ddio_out_pll_clock [lindex $all_write_dqs_list 0] msg_list $family]
		set clk_to_ck_ckn [traverse_to_ddio_out_pll_clock [lindex $ck_pins 0] msg_list $family]

		foreach msg $msg_list {
			set verify_assumptions_exception 1
			incr num_errors
			lappend failed_assumptions $msg
		}

		if {$num_errors == 0} {
			if {$discrete_device == 1} {
				set mem_var " {write_deskew_t10 $write_deskew_t10} {leveled 0}"
			} else {
				set mem_var " {write_deskew_t10 $write_deskew_t10}"
			}
			#puts "calling verify_assumptions -memory_type ddr3 -mem_var $mem_var -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs"
			set verify_assumptions_exception 0
			set verify_assumptions_result {0}
			if {$flexible_timing} {
				set verify_assumptions_exception [catch {verify_assumptions -memory_type ddr3 -mem_var $mem_var -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs -flexible} verify_assumptions_result]
			} else {
				set verify_assumptions_exception [catch {verify_assumptions -memory_type ddr3 -mem_var $mem_var -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs} verify_assumptions_result]
			}
			if {$verify_assumptions_exception == 0} {
				incr num_errors [lindex $verify_assumptions_result 0]
				set failed_assumptions [concat $failed_assumptions [lrange $verify_assumptions_result 1 end]]
			}
		}
		if {$verify_assumptions_exception != 0} {
			lappend failed_assumptions "Error: Timing assumptions could not be verified"
			incr num_errors
		}
	}

	if {$num_errors != 0} {
		for {set i 0} {$i != [llength $failed_assumptions]} {incr i} {
			set raw_msg [lindex $failed_assumptions $i]
			if {[regexp {^\W*(Info|Extra Info|Warning|Critical Warning|Error): (.*)$} $raw_msg -- msg_type msg]} {
				regsub " " $msg_type _ msg_type
				if {$msg_type == "Error"} {
					set msg_type "critical_warning"
				}
				post_message -type $msg_type $msg
			} else {
				post_message -type info $raw_msg
			}
		}
		post_message -type critical_warning "Read Capture and Write timing analyses may not be valid due to violated timing model assumptions"
	}
	return [expr $num_errors == 0]
}

proc verify_high_performance_timing_assumptions_ddr2 {instname pin_array_name write_deskew_t10 flexible_timing family mem_if_memtype} {
	upvar 1 $pin_array_name pins
	set num_errors 0
	load_package verify_ddr
	set ck_pins [lsort $pins(ck_p)]
	set ckn_pins [lsort $pins(ck_n)]
	set ck_ckn_pairs [list]
	set failed_assumptions [list]

	if {[llength $ck_pins] > 0 && [llength $ck_pins] == [llength $ckn_pins]} {
  		for {set ck_index 0} {$ck_index != [llength $ck_pins]} {incr ck_index} {
    		lappend ck_ckn_pairs [list [lindex $ck_pins $ck_index] [lindex $ckn_pins $ck_index]]
		}
	} else {
		incr num_errors
		lappend failed_assumptions "Error: Could not locate same number of CK pins as CK# pins"
	}

	set has_dqsn [llength [lindex [lindex $pins(dqsgroup) 0] 3]]

	set read_pins_list [list]
	set write_pins_list [list]
	if {$has_dqsn > 0} {
		set read_clock_pairs [list]
		set write_clock_pairs [list]
	}
	foreach dqsgroup $pins(dqsgroup) {
		set dqs [lindex $dqsgroup 0]
		set dq_list [lindex $dqsgroup 2]
		lappend read_pins_list [list $dqs $dq_list]
		set dm_list [lindex $dqsgroup 1]
		lappend write_pins_list [list $dqs [concat $dq_list $dm_list]]
		if {$has_dqsn > 0} {
			set dqsn [lindex $dqsgroup 3]
			lappend read_clock_pairs [list $dqs $dqsn]
		}
	}
	if {$has_dqsn > 0} {
		set write_clock_pairs $read_clock_pairs
	}
	set all_write_dqs_list [get_all_dqs_pins $pins(dqsgroup)]
	set all_d_list [get_all_dq_pins $pins(dqsgroup)]
	if {[llength $pins(dqsgroup)] == 0} {
		incr num_errors
		lappend failed_assumptions "Error: Could not locate DQS pins"
	}

	if {$num_errors == 0} {
		set msg_list [list]
		if {$family == "cyclone iv"} {
			set has_dll 0
		} else {
			set has_dll 1
			set dll_name [traverse_to_dll $dqs msg_list]
		}
		set clk_to_write_d [traverse_to_ddio_out_pll_clock [lindex $all_d_list 0] msg_list $family]
		set clk_to_write_clock [traverse_to_ddio_out_pll_clock [lindex $all_write_dqs_list 0] msg_list $family]
		set clk_to_ck_ckn [traverse_to_ddio_out_pll_clock [lindex $ck_pins 0] msg_list $family]

		foreach msg $msg_list {
			set verify_assumptions_exception 1
			incr num_errors
			lappend failed_assumptions $msg
		}

		if {$num_errors == 0} {
			set verify_assumptions_exception 0
			set verify_assumptions_result {0}
			if {$mem_if_memtype == "DDR2 SDRAM"} {
				set mem_type "ddr2"
			} else {
				set mem_type "ddr"
			}
			if {$has_dll} {
				if {$has_dqsn > 0} {
					if {$flexible_timing} {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs -flexible} verify_assumptions_result]
					} else {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs} verify_assumptions_result]
					}
				} else {
					if {$flexible_timing} {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name -flexible} verify_assumptions_result]
					} else {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -dll $dll_name} verify_assumptions_result]
					}
				}
			} else {
				if {$has_dqsn > 0} {
					if {$flexible_timing} {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs -flexible} verify_assumptions_result]
					} else {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -read_clock_pairs $read_clock_pairs -write_clock_pairs $write_clock_pairs} verify_assumptions_result]
					}
				} else {
					if {$flexible_timing} {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0] -flexible} verify_assumptions_result]
					} else {
						set verify_assumptions_exception [catch {verify_assumptions -memory_type $mem_type -read_pins_list $read_pins_list -write_pins_list $write_pins_list -ck_ckn_pairs $ck_ckn_pairs -clk_to_write_d $clk_to_write_d -clk_to_write_clock $clk_to_write_clock -clk_to_ck_ckn $clk_to_ck_ckn -mimic_pin [lindex $ck_pins 0]} verify_assumptions_result]
					}
				}
			}
			if {$verify_assumptions_exception == 0} {
				incr num_errors [lindex $verify_assumptions_result 0]
				set failed_assumptions [concat $failed_assumptions [lrange $verify_assumptions_result 1 end]]
			}
		}
		if {$verify_assumptions_exception != 0} {
			lappend failed_assumptions "Error: Timing assumptions could not be verified"
			incr num_errors
		}
	}

	if {$num_errors != 0} {
		for {set i 0} {$i != [llength $failed_assumptions]} {incr i} {
			set raw_msg [lindex $failed_assumptions $i]
			if {[regexp {^\W*(Info|Extra Info|Warning|Critical Warning|Error): (.*)$} $raw_msg -- msg_type msg]} {
				regsub " " $msg_type _ msg_type
				if {$msg_type == "Error"} {
					set msg_type "critical_warning"
				}
				post_message -type $msg_type $msg
			} else {
				post_message -type info $raw_msg
			}
		}
		post_message -type critical_warning "Read Capture and Write timing analyses may not be valid due to violated timing model assumptions"
	}
	return [expr $num_errors == 0]
}

proc ddr_pin {n pin pin_array_name} {
	upvar 1 $pin_array_name pins
	lappend pins($n) $pin
}

proc walk_to_pin {type mainnode {depth 100}} {
	if { $type == "fanout" } {
		set edgename "-fanout_edges"
		set srcdst "-dst"
	} elseif { $type == "clock" } {
		set edgename "-clock_edges"
		set srcdst "-src"
	} elseif { $type == "fanin" } {
		set edgename "-synch_edges"
		set srcdst "-src"
	}
	set fanout [get_node_info $edgename $mainnode]
	foreach edge $fanout {
		set node [get_edge_info $srcdst $edge]
		if { [get_node_info -type $node] == "port" } {
			return $node
		}
		set node_type [get_node_info -type $node]
		if {$depth > 0 && ($node_type == "comb" || $node_type == "pin")} {
			#puts "walking down [get_node_info -name $node] [get_node_info -type $node]..."
			set res [walk_to_pin $type $node [expr {$depth - 1}]]
			if { $res != "" } {
				return $res
			}
		} else {
			#puts "ignoring node [get_node_info -name $node] of type [get_node_info -type $node]"
		}
	}
	return ""
}

# Like walk_to_pin, but searches out in a tree if the 
# pin drives multiple ports
proc walk_to_all_pins {type collection {depth 100}} {
	if { $type == "fanout" } {
		set edgename "-fanout_edges"
		set srcdst "-dst"
	} elseif { $type == "clock" } {
		set edgename "-clock_edges"
		set srcdst "-src"
	} elseif { $type == "fanin" } {
		set edgename "-synch_edges"
		set srcdst "-src"
	}
	set res [list]
	foreach_in_collection mainnode $collection {
		set fanout [get_node_info $edgename $mainnode]
		foreach edge $fanout {
			set node [get_edge_info $srcdst $edge]
			if { [get_node_info -type $node] == "port" } {
				lappend res $node
			}
			set node_type [get_node_info -type $node]
			if {$depth > 0 && ($node_type == "comb" || $node_type == "pin")} {
				#puts "walking down [get_node_info -name $node] [get_node_info -type $node]..."
				set r [walk_to_pin $type $node [expr {$depth - 1}]]
				set res [concat $res $r] 
			} else {
				#puts "ignoring node [get_node_info -name $node] of type [get_node_info -type $node]"
			}
		}
	}
	return $res
}


# (map walk_to_pin)
proc walk_to_pins { type collection {depth 100} } {
	set res [list]
	foreach_in_collection c $collection {
		set i [walk_to_pin $type $c $depth]
		if { $i == "" } {
			#puts "Node [get_node_info -name $c] was a dead end"
		} else {
			#puts "Got port for node [get_node_info -name $c]"
			lappend res $i
		}
	}
	#puts "walk_to_pins returning: $res"
	return $res
}

# (map get_node_info -name)
proc map_get_node_name {nodes} {
	set res [list]
	foreach n $nodes {
		lappend res [get_node_info -name $n]
	}
	return $res
}

proc get_all_dqs_pins { dqsgroups} { 
	set res [list]
	foreach dqsgroup $dqsgroups {
		lappend res [lindex $dqsgroup 0]
	}
	return $res
}

proc get_all_dq_pins { dqsgroups} { 
	set res [list]
	foreach dqsgroup $dqsgroups {
		set res [concat $res [lindex $dqsgroup 2]]
	}
	return $res
}

proc get_all_dm_pins { dqsgroups} { 
	set res [list]
	foreach dqsgroup $dqsgroups {
		set res [concat $res [lindex $dqsgroup 1]]
	}
	return $res
}


proc list_collection { col } {
	set res "("
	foreach_in_collection c $col {
		append res "[get_node_info -name $c]\n"
	}
	append res ")"
	return $res
}

proc sett_collection { vlist col } {
	set i 0
	set len [llength $vlist]
	foreach_in_collection c $col {
		if { $i < $len } {
			upvar 1 [lindex $vlist $i] x
			set x $c
			incr i
		} else {
			error "Too many items in collection ([expr {$i+1}]) for list $vlist"
		}
	}
	if { $i != $len } {
		error "Too Few items in collection ($i) for list $vlist"
	}
}

# For static deskew, get the frequency range of the given configuration
# Return triplet {mode min_freq max_freq}
proc get_deskew_freq_range {timing_params period} {
	set mode [list]
	# freq_range list should be sorted from low to high
	if {[lindex $timing_params 2] == "STATIC_DESKEW_8" || [lindex $timing_params 2] == "STATIC_DESKEW_10"}  {
		# These modes have more than 2 freq ranges
		set range_list [list LOW HIGH]
	} else {
		# Just 1 freq range
		set range_list [list [list]]
	}
	set freq_mode [list]
	foreach freq_range $range_list {
		if {[catch {get_micro_node_delay -micro MIN -parameters [concat $timing_params $freq_range]} min_freq] != 0 || $min_freq == "" ||
			[catch {get_micro_node_delay -micro MAX -parameters [concat $timing_params $freq_range]} max_freq] != 0 || $max_freq == ""} {
			# Invalid mode
		} else {
			set max_freq_period [expr 1000.0 / $min_freq]
			set min_freq_period [expr 1000.0 / $max_freq]
			lappend freq_mode [list $freq_range $min_freq $max_freq]
			if {$period >= $min_freq_period && $period <= $max_freq_period} {
				set mode [lindex $freq_mode end]
				break
			}
		}
	}
	if {$mode == [list] && $freq_mode != [list]} {
		if {$period < $min_freq_period} {
			# Fastest mode
			set mode [lindex $freq_mode end]
		} else {
			# Slowest mode
			set mode [lindex $freq_mode 0]
		}
	}
	return $mode
}
# Return a tuple of the tCCS value for a given device
proc get_tccs { mem_if_memtype dqs_list period args} {
	global TimeQuestInfo
	array set options [list "-write_deskew" "none" "-dll_length" 0 "-config_period" 0 "-ddr3_discrete" 0]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown get_tccs option $option (with value $value; args are $args)"
		}
	}

	set interface_type [get_io_interface_type $dqs_list]
	# The tCCS for a VHPAD interface is the same as a HPAD interface
	if {$interface_type == "VHPAD"} {
		set interface_type "HPAD"
	}
	set io_std [get_io_standard [lindex $dqs_list 0]]
  	set result [list 0 0]
	if {$interface_type != "" && $interface_type != "UNKNOWN" && $io_std != "" && $io_std != "UNKNOWN"} {
		package require ::quartus::ddr_timing_model

		set tccs_params [list IO $interface_type]
		if {($mem_if_memtype == "DDR3 SDRAM") && ($options(-ddr3_discrete) == 1)} {
			lappend tccs_params NONLEVELED
		} elseif {$options(-write_deskew) == "static"} {
			if {$options(-dll_length) != 0} {
				lappend tccs_params STATIC_DESKEW_$options(-dll_length)
			} else {
				# No DLL length dependency
				lappend tccs_params STATIC_DESKEW
			}
		} elseif {$options(-write_deskew) == "dynamic"} {
			lappend tccs_params DYNAMIC_DESKEW
		}
		if {$options(-ddr3_discrete) == 0 && $options(-write_deskew) != "none"} {
			set mode [get_deskew_freq_range $tccs_params $period]
			set expected_mode [get_deskew_freq_range $tccs_params $options(-config_period)]
			if {$mode == [list]} {
				post_message -type critical_warning "Memory interface with period $period and write $options(-write_deskew) deskew does not fall in a supported frequency range"
			} elseif {$expected_mode != $mode || $period < [expr 1000.0/[lindex $mode 2]] || $period > [expr 1000.0/[lindex $mode 1]]} {
				post_message -type critical_warning "Memory interface with clock frequency [expr 1000.0/$period] MHz is operating outside the frequency range of the megafunction configuration (expected frequency range is from [lindex $expected_mode 1] MHz to [lindex $expected_mode 2] MHz).  The timing analysis will not be accurate."
			} elseif {[lindex $mode 0] != [list]} {
				lappend tccs_params [lindex $mode 0]
			}
		}
		if {[catch {get_io_standard_node_delay -dst TCCS_LEAD -io_standard $io_std -parameters $tccs_params} tccs_lead] != 0 || $tccs_lead == "" || $tccs_lead == 0 || \
				[catch {get_io_standard_node_delay -dst TCCS_LAG -io_standard $io_std -parameters $tccs_params} tccs_lag] != 0 || $tccs_lag == "" || $tccs_lag == 0 } {
			set family $TimeQuestInfo(family)
			error "Missing $family timing model for tCCS of $io_std $tccs_params"
		} else {
			return [list $tccs_lead $tccs_lag]
		}
	}
}

# Return a tuple of setup,hold time for read capture
proc get_tsw { mem_if_memtype dqs_list period args} {
	global TimeQuestInfo
	array set options [list "-read_deskew" "none" "-dll_length" 0 "-config_period" 0 "-ddr3_discrete" 0]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown get_tsw option $option (with value $value; args are $args)"
		}
	}

	set interface_type [get_io_interface_type $dqs_list]
	if {$interface_type == "VHPAD"} {
		set interface_type "HPAD"
	}
	set io_std [get_io_standard [lindex $dqs_list 0]]

	if {$interface_type != "" && $interface_type != "UNKNOWN" && $io_std != "" && $io_std != "UNKNOWN"} {
		package require ::quartus::ddr_timing_model
		set family $TimeQuestInfo(family)
		set tsw_params [list IO $interface_type]
		if {$options(-ddr3_discrete) == 1} {
			lappend tsw_params NONLEVELED
		} elseif {$options(-read_deskew) == "static"} {
			if {$options(-dll_length) != 0} {
				lappend tsw_params STATIC_DESKEW_$options(-dll_length)
			} else {
				# No DLL length dependency
				lappend tsw_params STATIC_DESKEW
			}
		} elseif {$options(-read_deskew) == "dynamic"} {
			lappend tsw_params DYNAMIC_DESKEW
		}
		if {$options(-ddr3_discrete) == 0 && $options(-read_deskew) != "none"} {
			set mode [get_deskew_freq_range $tsw_params $period]
			if {$mode == [list]} {
				post_message -type critical_warning "Memory interface with period $period and read $options(-read_deskew) deskew does not fall in a supported frequency range"
			} elseif {[lindex $mode 0] != [list]} {
				lappend tsw_params [lindex $mode 0]
			}
		}

		if {[catch {get_io_standard_node_delay -dst TSU -io_standard $io_std -parameters $tsw_params} tsw_setup] != 0 || $tsw_setup == "" || $tsw_setup == 0 || \
				[catch {get_io_standard_node_delay -dst TH -io_standard $io_std -parameters $tsw_params} tsw_hold] != 0 || $tsw_hold == "" || $tsw_hold == 0 } {
			error "Missing $family timing model for tSW of $io_std $tsw_params"
		} else {
			# Derate tSW for DDR2 on VPAD in CIII Q240 parts
			# The tSW for HPADs and for other interface types on C8 devices
			# have a large guardband, so derating for them is not required
			if {[get_part_info -package -pin_count $TimeQuestInfo(part)] == "PQFP 240"} {
				if {[catch {get_io_standard_node_delay -dst TSU -io_standard $io_std -parameters [list IO $interface_type Q240_DERATING]} tsw_setup_derating] != 0 || $tsw_setup_derating == 0 || \
						[catch {get_io_standard_node_delay -dst TH -io_standard $io_std -parameters [list IO $interface_type Q240_DERATING]} tsw_hold_derating] != 0 || $tsw_hold_derating == 0} {
					set f "$io_std/$interface_type/$family"
					switch -glob $f {
						"SSTL_18*/VPAD/Cyclone III"  {
							set tsw_setup_derating 50
							set tsw_hold_derating 135
						}
						"SSTL_18*/VPAD/Cyclone IV E"  {
							set tsw_setup_derating 50
							set tsw_hold_derating 135
						}						
						default {
							set tsw_setup_derating 0
							set tsw_hold_derating 0
						}
					}
				}
				incr tsw_setup $tsw_setup_derating
				incr tsw_hold $tsw_hold_derating
			}
			return [list $tsw_setup $tsw_hold]
		}
	}
}

# Return a pseudo x36 derating tuple of setup,hold time for read capture
proc get_qdr_tsw_derating { dqs_list } { 
	global TimeQuestInfo
	set io_std [get_io_standard [lindex $dqs_list 0]]
	set interface_type [get_io_interface_type [lindex $dqs_list 0]]

	if {[catch {get_io_standard_node_delay -dst TSU -io_standard $io_std -parameters [list IO $interface_type PSEUDOX36]} tsw_setup] != 0 || $tsw_setup == "" || \
			[catch {get_io_standard_node_delay -dst TH -io_standard $io_std -parameters [list IO $interface_type PSEUDOX36]} tsw_hold] != 0 || $tsw_hold == "" || $tsw_hold == 0 } {
		set family $TimeQuestInfo(family)
		error "Missing $family timing model for derated tSW of $io_std $interface_type"
	} else {
		set result [list $tsw_setup $tsw_hold]
	}
	return $result
}

# Return a pseudo x36 derating tuple of setup,hold time for write capture
proc get_qdr_tccs_derating { dqs_list } { 
	set io_std [get_io_standard [lindex $dqs_list 0]]
	set interface_type [get_io_interface_type [lindex $dqs_list 0]]

	if {[catch {get_io_standard_node_delay -dst TCCS_LEAD -io_standard $io_std -parameters [list IO $interface_type PSEUDOX36]} tccs_lead] != 0 || $tccs_lead == "" || $tccs_lead == 0 || \
			[catch {get_io_standard_node_delay -dst TCCS_LAG -io_standard $io_std -parameters [list IO $interface_type PSEUDOX36]} tccs_lag] != 0 || $tccs_lag == "" || $tccs_lag == 0 } {
		set family $TimeQuestInfo(family)
		error "Missing $family timing model for derated tCCS of $io_std $interface_type"
	} else {
		set result [list $tccs_lead $tccs_lag]
	}

	return $result
}

proc round_3dp { x } {
	return [expr { round($x * 1000) / 1000.0  } ]
}

proc format_3dp { x } {
	return [format %.3f $x]
}

proc get_colours { x y } {

	set fcolour [list "black"]
	if {$x < 0} {
		lappend fcolour "red"
	} else {
		lappend fcolour "blue"
	}
	if {$y < 0} {
		lappend fcolour "red"
	} else {
		lappend fcolour "blue"
	}
	
	return $fcolour
}

proc min { a b } {
	if { $a == "" } { 
		return $b
	} elseif { $a < $b } {
		return $a
	} else {
		return $b
	}
}

proc max { a b } {
	if { $a == "" } { 
		return $b
	} elseif { $a > $b } {
		return $a
	} else {
		return $b
	}
}

proc max_in_collection { col attribute } {
	set i 0
	set max 0
	foreach_in_collection path $col {
		if {$i == 0} {
			set max [get_path_info $path -${attribute}]
		} else {
			set temp [get_path_info $path -${attribute}]
			if {$temp > $max} {
				set max $temp
			} 
		}
		set i [expr $i + 1]
	}
	return $max
}

proc min_in_collection { col attribute } {
	set i 0
	set min 0
	foreach_in_collection path $col {
		if {$i == 0} {
			set min [get_path_info $path -${attribute}]
		} else {
			set temp [get_path_info $path -${attribute}]
			if {$temp < $min} {
				set min $temp
			} 
		}
		set i [expr $i + 1]
	}
	return $min
}

proc min_in_collection_to_name { col attribute name } {
	set i 0
	set min 0
	foreach_in_collection path $col {
		if {[get_node_info -name [get_path_info $path -to]] == $name} {
			if {$i == 0} {
				set min [get_path_info $path -${attribute}]
			} else {
				set temp [get_path_info $path -${attribute}]
				if {$temp < $min} {
					set min $temp
				} 
			}
			set i [expr $i + 1]
		}
	}
	return $min
}

proc min_in_collection_from_name { col attribute name } {
	set i 0
	set min 0
	foreach_in_collection path $col {
		if {[get_node_info -name [get_path_info $path -from]] == $name} {
			if {$i == 0} {
				set min [get_path_info $path -${attribute}]
			} else {
				set temp [get_path_info $path -${attribute}]
				if {$temp < $min} {
					set min $temp
				} 
			}
			set i [expr $i + 1]
		}
	}
	return $min
}

proc wrap_to_period {period t} {
	return [expr {fmod(fmod($t,$period) + $period,$period)}]
}

proc get_clock_latency {period clockname risefall } {
	set countclocks 0
	if { $risefall != "rise" && $risefall != "fall" } {
		error "Internal error: get_clock_latency risefall was $risefall expected \"rise\" or \"fall\""
	}
	foreach_in_collection c [get_clocks $clockname] { 
		set clock $c
		incr countclocks
	}
	if { $countclocks == 1 } {
		if { $risefall == "rise" } {
			set edge_index 0
		} elseif { $risefall == "fall" } {
			set edge_index 1
		} else {
			error "Unreachable in get_clock_latency"
		}
	} else {
		error "Internal error: Found $countclocks matching $clockname. Expected 1 in get_clock_latency"
	}
	set waveform [get_clock_info -waveform $clock]
	if {[llength $waveform] != 2 } {
		error "Internal error: Waveform for clock $clockname is \"$waveform\""
	}
	set latency [lindex $waveform $edge_index]
	set res [wrap_to_period $period $latency]
	return $res
}

# Same as get_clock_latency, but returns the clock phase (0<=x<360) normalised instead
proc get_clock_phase {period clockname risefall } {
	set countclocks 0
	if { $risefall != "rise" && $risefall != "fall" } {
		error "Internal error: get_clock_phase risefall was $risefall expected \"rise\" or \"fall\""
	}
	foreach_in_collection c [get_clocks $clockname] { 
		set clock $c
		incr countclocks
	}
	if { $countclocks == 1 } {
		if { $risefall == "rise" } {
			set offset 0
		} elseif { $risefall == "fall" } {
			set offset 180
		} else {
			error "Unreachable in get_clock_phase"
		}
	} else {
		error "Internal error: Found $countclocks matching $clockname. Expected 1 in get_clock_phase"
	}
	set phase [get_clock_info -phase $clock]
	set res [expr {fmod(($phase+$offset+360),360)}]
	return $res
}


proc expr_debug { exp } {
	upvar expr_debug_e expr_debug_e
	set expr_debug_e $exp
	uplevel {
	puts "-----------------"
	puts "[regsub -all {[\n \t]+} $expr_debug_e " "]"
	puts "-----------------"
	puts [regsub -all {[\n \t]+} [subst $expr_debug_e] " "]
	puts "-----------------"
	set expr_debug_temp [expr $expr_debug_e]
	puts "=$expr_debug_temp" 
	puts "-----------------"
	return $expr_debug_temp
	}
}

# Return all the ck output clocks in the current design of a given type and 
# inversion
# type - either tDSS/tDQSS/ac_rise/ac_fall
# pn - either p/n
proc get_output_clocks {type pn} {
	global ck_output_clocks
	return $ck_output_clocks(${type}-${pn})
}

proc add_output_clock {type pn clockname} {
	global ck_output_clocks
	if { ! [info exists ck_output_clocks(${type}-${pn})] } {
		set ck_output_clocks(${type}-${pn}) [list]
	} 
	lappend ck_output_clocks(${type}-${pn}) $clockname
}

# ----------------------------------------------------------------
#
proc get_timequest_name {hier_name} {
#
# Description:  Convert the full hierarchy name into a TimeQuest name
#
# ----------------------------------------------------------------
	set sta_name ""
	for {set inst_start [string first ":" $hier_name]} {$inst_start != -1} {} {
		incr inst_start
		set inst_end [string first "|" $hier_name $inst_start]
		if {$inst_end == -1} {
			append sta_name [string range $hier_name $inst_start end]
			set inst_start -1
		} else {
			append sta_name [string range $hier_name $inst_start $inst_end]
			set inst_start [string first ":" $hier_name $inst_end]
		}
	}
	return $sta_name
}

# ----------------------------------------------------------------
#
proc get_core_instance_list {corename} {
#
# Description:  Get a list of all ALTMEMPHY instances in TimeQuest
#
# ----------------------------------------------------------------
	set full_instance_list [get_core_full_instance_list $corename]
	set instance_list [list]

	foreach inst $full_instance_list {
		set sta_name [get_timequest_name $inst]
		if {[lsearch $instance_list [escape_brackets $sta_name]] == -1} {
			lappend instance_list $sta_name
		}
	}
	return $instance_list
}

# ----------------------------------------------------------------
#
proc get_core_full_instance_list {corename} {
#
# Description:  Get a list of all ALTMEMPHY instances (full hierarchy names)
#               in TimeQuest
#
# ----------------------------------------------------------------
	set instance_list [list]

	# Look for a keeper (register) name
	# Try mem_clk[0] to determine core instances
	set search_list [list "*"]
	set found 0
	for {set i 0} {$found == 0 && $i != [llength $search_list]} {incr i} {
		set pattern [lindex $search_list $i]
		set instance_collection [get_keepers -nowarn "*|${corename}:*|$pattern"]
		if {[get_collection_size $instance_collection] == 0} {
			set instance_collection [get_keepers "${corename}:*|$pattern"]
		}
		if {[get_collection_size $instance_collection] > 0} {
			set found 1
		}
	}
	# regexp to extract the full hierarchy path of an instance name
	set inst_regexp {(^.*}
	append inst_regexp "\\\|${corename}"
	append inst_regexp {:[A-Za-z0-9\.\\_\[\]\-\$():]+)\|}
	foreach_in_collection inst $instance_collection {
		set name [get_node_info -name $inst]
		if {[regexp -- $inst_regexp $name -> hier_name] == 1} {
			if {[lsearch $instance_list [escape_brackets $hier_name]] == -1} {
				lappend instance_list $hier_name
			}
		}
	}
	#Try again if the above search was unsuccessfull
	if {$instance_list == ""} {
		set inst_regexp {(^.*}
		append inst_regexp "${corename}"	
		append inst_regexp {:[A-Za-z0-9\.\\_\[\]\-\$():]+)\|}
		foreach_in_collection inst $instance_collection {
			set name [get_node_info -name $inst]
			if {[regexp -- $inst_regexp $name -> hier_name] == 1} {
				if {[lsearch $instance_list [escape_brackets $hier_name]] == -1} {
					lappend instance_list $hier_name
				}
			}
		}
	}
	return $instance_list
}

# ----------------------------------------------------------------
#
proc traverse_fanin_up_to_depth { node_id match_command edge_type results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id through edges of type edge_type to find nodes
#              satisfying match_command.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set fanin_edges [get_node_info -${edge_type}_edges $node_id]
	set number_of_fanin_edges [llength $fanin_edges]
	for {set i 0} {$i != $number_of_fanin_edges} {incr i} {
		set fanin_edge [lindex $fanin_edges $i]
		set fanin_id [get_edge_info -src $fanin_edge]
		if {$match_command == "" || [eval $match_command $fanin_id] != 0} {
			set results($fanin_id) 1
		} elseif {$depth == 0} {
			# Max recursion depth
		} else {
			traverse_fanin_up_to_depth $fanin_id $match_command $edge_type results [expr "$depth - 1"]
		}
	}
}

# ----------------------------------------------------------------
#
proc is_node_type_pll_inclk { node_id } {
#
# Description: Given a node, tells whether or not it is a PLL clk
#
# ----------------------------------------------------------------
	set cell_id [get_node_info -cell $node_id]
	set atom_type [get_cell_info -atom_type $cell_id]
	if {$atom_type == "PLL"} {
		set node_name [get_node_info -name $node_id]
		set fanin_edges [get_node_info -clock_edges $node_id]
		# The inclk input should have a |inclk or |inclk[0] suffix
		if {([string match "*|inclk" $node_name] || [string match "*|inclk\\\[0\\\]" $node_name]) && [llength $fanin_edges] > 0} {
			set result 1
		} else {
			set result 0
		}
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc is_node_type_pin { node_id } {
#
# Description: Given a node, tells whether or not it is a reg
#
# ----------------------------------------------------------------
	set node_type [get_node_info -type $node_id]
	if {$node_type == "port"} {
		set result 1
	} else {
		set result 0
	}
	return $result
}

# ----------------------------------------------------------------
#
proc get_input_clk_id { pll_output_node_id } {
#
# Description: Given a PLL clock output node, gets the PLL clock input node
#
# ----------------------------------------------------------------
	if {[is_node_type_pll_clk $pll_output_node_id]} {
		array set results_array [list]
		traverse_fanin_up_to_depth $pll_output_node_id is_node_type_pll_inclk clock results_array 1
		if {[array size results_array] == 1} {
			# Found PLL inclk, now find the input pin
			set pll_inclk_id [lindex [array names results_array] 0]
			array unset results_array
			# If fed by a pin, it should be fed by a dedicated input pin,
			# and not a global clock network.  Limit the search depth to
			# prevent finding pins fed by global clock (only allow io_ibuf pins)
			traverse_fanin_up_to_depth $pll_inclk_id is_node_type_pin clock results_array 3
			if {[array size results_array] == 1} {
				# Fed by a dedicated input pin
				set pin_id [lindex [array names results_array] 0]
				set result $pin_id
			} else {
				# Try looking for clocks fed by a pin but gone through
				# the clock routing (possibly because the PLL is placed on a different side)
				# If this is the case output a warning
				traverse_fanin_up_to_depth $pll_inclk_id is_node_type_pin clock results_array 5
				if {[array size results_array] == 1} {
					# Fed by a dedicated input pin through the clock routing
					post_message -type critical_warning "PLL clock [get_node_info -name $pll_output_node_id] driven through clock routing.  To ensure minimum jitter on memory interface clock outputs, the PLL clock source should be a dedicated clock pin on the same side."
					set pin_id [lindex [array names results_array] 0]
					set result $pin_id
				} else {
					traverse_fanin_up_to_depth $pll_inclk_id is_node_type_pll_clk clock pll_clk_results_array 1
					if {[array size pll_clk_results_array] == 1} {
						# Fed by a neighboring PLL via cascade path.
						# Should be okay as long as that PLL has its input clock
						# fed by a dedicated input.  If there isn't, TimeQuest will give its own warning about undefined clocks.
						set source_pll_clk_id [lindex [array names pll_clk_results_array] 0]
						set source_pll_clk [get_node_info -name $source_pll_clk_id]
						if {[get_input_clk_id $source_pll_clk_id] != -1} {
							post_message -type info "Please ensure source clock is defined for PLL with output $source_pll_clk"
						} else {
							# Fed from core
							post_message -type critical_warning "PLL clock $source_pll_clk not driven by a dedicated clock pin.  To ensure minimum jitter on memory interface clock outputs, the PLL clock source should be a dedicated PLL input clock pin."
						}
						set result -1
					} else {
						# Fed from core
						post_message -type critical_warning "PLL clock [get_node_info -name $pll_output_node_id] not driven by a dedicated clock pin or neighboring PLL source.  To ensure minimum jitter on memory interface clock outputs, the PLL clock source should be a dedicated PLL input clock pin or an output of the neighboring PLL."
						set result -1
					}
				}
			}
		} else {
			post_message -type critical_warning "Could not find PLL clock for [get_node_info -name $pll_output_node_id]"
			set result -1
		}
	} else {
		error "Internal error: get_input_clk_id only works on PLL output clocks"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc is_node_type_pll_clk { node_id } {
#
# Description: Given a node, tells whether or not it is a PLL clk
#
# ----------------------------------------------------------------
	set cell_id [get_node_info -cell $node_id]
	set atom_type [get_cell_info -atom_type $cell_id]
	if {$atom_type == "PLL"} {
		set node_name [get_node_info -name $node_id]
		if {[string match "*|clk\\\[*\\\]" $node_name]} {
			set result 1
		} else {
			set result 0
		}
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc get_pll_clock { dest_id_list node_type clock_id_name search_depth} {
#
# Description: Look for the PLL output clocking the given nodes
#
# ----------------------------------------------------------------
	if {$clock_id_name != ""} {
		upvar 1 $clock_id_name clock_id
	}
	set clock_id -1

	array set clk_array [list]
	foreach node_id $dest_id_list {
		traverse_fanin_up_to_depth $node_id is_node_type_pll_clk clock clk_array $search_depth
	}
	if {[array size clk_array] == 1} {
		set clock_id [lindex [array names clk_array] 0]
		set clk [get_node_info -name $clock_id]
	} elseif {[array size clk_array] > 1} {
		puts "Found more than 1 clock driving the $node_type"
		set clk ""
	} else {
		set clk ""
		#puts "Could not find $node_type clock"
	}

	return $clk
}

# ----------------------------------------------------------------
#
proc get_output_clock_id { ddio_output_pin_list pin_type msg_list_name {max_search_depth 13} } {
#
# Description: Look for the PLL output clocks of the given pins
#
# ----------------------------------------------------------------
	upvar 1 $msg_list_name msg_list
	set output_clock_id -1
	
	set output_id_list [list]
	set pin_collection [get_keepers $ddio_output_pin_list]
	if {[get_collection_size $pin_collection] == [llength $ddio_output_pin_list]} {
		foreach_in_collection id $pin_collection {
			lappend output_id_list $id
		}
	} elseif {[get_collection_size $pin_collection] == 0} {
		lappend msg_list "warning" "Could not find any $pin_type pins"
	} else {
		lappend msg_list "warning" "Could not find all $pin_type pins"
	}
	get_pll_clock $output_id_list $pin_type output_clock_id $max_search_depth
	return $output_clock_id
}

# ----------------------------------------------------------------
#
proc is_node_type_io_clock_divider_clkout { node_id } {
#
# Description: Given a node, tells whether or not it is a I/O clock divider clk
#
# ----------------------------------------------------------------
	set cell_id [get_node_info -cell $node_id]
	set atom_type [get_cell_info -atom_type $cell_id]
	if {$atom_type == "IO_CLOCK_DIVIDER"} {
		set node_name [get_node_info -name $node_id]
		set fanout_edges [get_node_info -fanout_edges $node_id]
		if {[string match "*|clkout" $node_name] && [llength $fanout_edges] > 0} {
			set result 1
		} else {
			set result 0
		}
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc post_sdc_message {msg_type msg} {
#
# Description: Posts a message in TimeQuest, but not in Fitter
#              The SDC is read mutliple times during compilation, so we'll wait
#              until final TimeQuest timing analysis to display messages
#
# ----------------------------------------------------------------
	if { $::TimeQuestInfo(nameofexecutable) != "quartus_fit"} {
		post_message -type $msg_type $msg
	}
}

# ----------------------------------------------------------------
#
proc get_report_column { report_id str} {
#
# Description: Gets the report column index with the given header string
#
# ----------------------------------------------------------------
	set target_col [get_report_panel_column_index -id $report_id $str]
	if {$target_col == -1} {
		error "Cannot find $str column"
	}
	return $target_col
}

# ----------------------------------------------------------------
#
proc get_fitter_report_pin_info_from_report {target_pin info_type pin_report_id} {
#
# Description: Gets the report field for the given pin in the given report
#
# ----------------------------------------------------------------
	set pin_name_column [get_report_column $pin_report_id "Name"]
	set info_column [get_report_column $pin_report_id $info_type]
	set result ""

	if {$pin_name_column == 0 && 0} {
		set row_index [get_report_panel_row_index -id $pin_report_id $target_pin]
		if {$row_index != -1} {
			set row [get_report_panel_row -id $pin_report_id -row $row_index]
			set result [lindex $row $info_column]
		}
	} else {
		set report_rows [get_number_of_rows -id $pin_report_id]
		for {set row_index 1} {$row_index < $report_rows && $result == ""} {incr row_index} {
			set row [get_report_panel_row -id $pin_report_id -row $row_index]
			set pin [lindex $row $pin_name_column]
			if {$pin == $target_pin} {
				set result [lindex $row $info_column]
			}
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc get_fitter_report_pin_info {target_pin info_type preferred_report_id {found_report_id_name ""}} {
#
# Description: Gets the report field for the given pin by searching through the
#              input, output and bidir pin reports
#
# ----------------------------------------------------------------
	if {$found_report_id_name != ""} {
		upvar 1 $found_report_id_name found_report_id
	}
	set found_report_id -1
	set result ""
	if {$preferred_report_id == -1} {
		set pin_report_list [list "Fitter||Resource Section||Bidir Pins" "Fitter||Resource Section||Input Pins" "Fitter||Resource Section||Output Pins"]
		for {set pin_report_index 0} {$pin_report_index != [llength $pin_report_list] && $result == ""} {incr pin_report_index} {
			[catch {get_report_panel_id [lindex $pin_report_list $pin_report_index]} pin_report_id]
			if {($pin_report_id != -1) && !([string match -nocase "*invalid*" $pin_report_id] == 1) } {
				set result [get_fitter_report_pin_info_from_report $target_pin $info_type $pin_report_id]
				if {$result != ""} {
					set found_report_id $pin_report_id
				}
			}
		}
	} else {
		set result [get_fitter_report_pin_info_from_report $target_pin $info_type $preferred_report_id]
		if {$result != ""} {
			set found_report_id $preferred_report_id
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc get_io_interface_type {pin_list} {
#
# Description: Gets the type of pin that the given pins are placed on
#              either (HPAD, VPAD, VHPAD, "", or UNKNOWN).
#              "" is returned if pin_list is empty
#              UNKNOWN is returned if an error was encountered
#              This function assumes the fitter has already completed and the
#              compiler report has been loaded.
#
# ----------------------------------------------------------------
	set preferred_report_id -1
	set interface_type ""
	
	# First determine if the Fitter report has been loaded
	set target_pin [lindex $pin_list 0]
	[catch {get_fitter_report_pin_info $target_pin "I/O Standard" -1} io_std]
	if {($io_std == "") || ([string match -nocase "*error*" $io_std] == 1) || ([string match -nocase "*invalid*" $io_std] == 1)} {
		set fitter_report_available 0
	} else {
		set fitter_report_available 1
	}
	
	foreach target_pin $pin_list {
		set pin_interface_type ""
		
		# Find the IO Bank for one pin from the Fitter report and then convert that to an interface type
		if {$fitter_report_available == 1} {
			set io_bank [get_fitter_report_pin_info $target_pin "I/O Bank" $preferred_report_id preferred_report_id]
			if {[regexp -- {^([0-9]+)[A-Z]*} $io_bank -> io_bank_number]} {
				if {$io_bank_number == 1 || $io_bank_number == 2 || $io_bank_number == 5 || $io_bank_number == 6} {
					# Row I/O
					set pin_interface_type "HPAD"
				} elseif {$io_bank_number == 3 || $io_bank_number == 4 || $io_bank_number == 7 || $io_bank_number == 8} {
					set pin_interface_type "VPAD"
				} else {
					post_message -type critical_warning "Unknown I/O bank $io_bank for pin $target_pin"
					# Asuume worst case performance (mixed HPAD/VPAD interface)
					set pin_interface_type "VHPAD"
				}
			}
		} else {
			#Fitter report is not available, use the a worst-case assignment
			set interface_type "VHPAD"			
		}
		
		#Combine interface type for 1 pin with all pins
		if {$interface_type == ""} {
			set interface_type $pin_interface_type
		} elseif {$pin_interface_type == "VHPAD"} {
			set interface_type $pin_interface_type
		} elseif {($interface_type == "VPAD") && ($pin_interface_type == "HPAD")} {
			set interface_type "VHPAD"
		} elseif {($interface_type == "HPAD") && ($pin_interface_type == "VPAD")} {
			set interface_type "VHPAD"
		} 
	}
		
	return $interface_type
}

# ----------------------------------------------------------------
#
proc get_input_oct_termination {target_pin} {
#
# Description: Tells whether or not the given memory interface pin uses OCT
#              This function assumes the fitter has already completed and the
#              compiler report has been loaded.
#
# ----------------------------------------------------------------
	# Look through the pin reports
	set pin_report_id [get_report_panel_id "Fitter||Resource Section||Bidir Pins"]
	# Look through the output and bidir pin reports
	if {$pin_report_id == -1} {
		set termination ""
	} else {
		set termination [get_fitter_report_pin_info $target_pin "Input Termination" $pin_report_id]
	}
	if {$termination == ""} {
		set pin_report_id [get_report_panel_id "Fitter||Resource Section||Input Pins"]
		set termination [get_fitter_report_pin_info $target_pin "Termination" $pin_report_id]
		if {$termination == ""} {
			return "UNKNOWN"
		}
	}
	set result "OCT_OFF"
	switch -exact -glob -- $termination {
		"Off" {set result "OCT_OFF"}
		"OCT*" {set result "OCT_ON"}
		"Parallel *" {set result "OCT_ON"}
		default {
			post_message -type critical_warning "Found unsupported memory pin input termination $termination on pin $target_pin"
			set result "UNKNOWN"
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc get_output_oct_termination {target_pin} {
#
# Description: Tells whether or not the given memory interface pin uses OCT
#              This function assumes the fitter has already completed and the
#              compiler report has been loaded.
#
# ----------------------------------------------------------------
	set pin_report_id [get_report_panel_id "Fitter||Resource Section||Bidir Pins"]
	# Look through the output and bidir pin reports
	if {$pin_report_id == -1} {
		set termination ""
	} else {
		set termination [get_fitter_report_pin_info $target_pin "Output Termination" $pin_report_id]
	}
	if {$termination == ""} {
		set pin_report_id [get_report_panel_id "Fitter||Resource Section||Output Pins"]
		set termination [get_fitter_report_pin_info $target_pin "Termination" $pin_report_id]
		if {$termination == ""} {
			return "UNKNOWN"
		}
	}
	set result "OCT_OFF"
	switch -exact -glob -- $termination {
		"Off" {set result "OCT_OFF"}
		"OCT*" {set result "OCT_ON"}
		"Series *" {set result "OCT_ON"}
		default {
			post_message -type critical_warning "Found unsupported memory pin output termination $termination on pin $target_pin"
			set result "UNKNOWN"
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc get_operating_conditions_number {} {
#
# Description: Returns the index of the operating condition that is 
#              being timed currently in cases where more than one operating
#              condition is being timed in total.
#
# ----------------------------------------------------------------
	set cur_operating_condition [get_operating_conditions]
	set counter 0
	foreach_in_collection op [get_available_operating_conditions] {
		if {[string compare $cur_operating_condition $op] == 0} {
			return $counter
		}
		incr counter
	}
	return $counter
}
# ----------------------------------------------------------------
#
proc get_io_standard {target_pin} {
#
# Description: Gets the I/O standard of the given memory interface pin
#              This function assumes the fitter has already completed and the
#              compiler report has been loaded.
#
# ----------------------------------------------------------------

	# Look through the pin report
	[catch {get_fitter_report_pin_info $target_pin "I/O Standard" -1} io_std]

	if {($io_std == "") || ([string match -nocase "*error*" $io_std] == 1) || ([string match -nocase "*invalid*" $io_std] == 1)} {
		# The Fitter has not run, so read IP set assignment
		set io_std "Differential 1.5-V SSTL Class I"
		set io_std [get_io_standard_from_assignment -assignment $io_std]
	}
	#If at this point the IO standard is not obtained, then return UNKNOWN
	if {$io_std == ""} {
		return "UNKNOWN"
	}
	set result ""
	switch  -exact -- $io_std {
		"SSTL-2 Class I" {set result "SSTL_2_I"}
		"Differential 2.5-V SSTL Class I" {set result "DIFF_SSTL_2_I"}
		"SSTL-2 Class II" {set result "SSTL_2_II"}
		"Differential 2.5-V SSTL Class II" {set result "DIFF_SSTL_2_II"}
		"SSTL-18 Class I" {set result "SSTL_18_I"}
		"Differential 1.8-V SSTL Class I" {set result "DIFF_SSTL_18_I"}
		"SSTL-18 Class II" {set result "SSTL_18_II"}
		"Differential 1.8-V SSTL Class II" {set result "DIFF_SSTL_18_II"}
		"SSTL-15 Class I" {set result "SSTL_15_I"}
		"Differential 1.5-V SSTL Class I" {set result "DIFF_SSTL_15_I"}
		"SSTL-15 Class II" {set result "SSTL_15_II"}
		"Differential 1.5-V SSTL Class II" {set result "DIFF_SSTL_15_II"}
		"1.8-V HSTL Class I" {set result "HSTL_18_I"}
		"Differential 1.8-V HSTL Class I" {set result "DIFF_HSTL_18_I"}
		"1.8-V HSTL Class II" {set result "HSTL_18_II"}
		"Differential 1.8-V HSTL Class II" {set result "DIFF_HSTL_18_II"}
		"1.5-V HSTL Class I" {set result "HSTL_I"}
		"Differential 1.5-V HSTL Class I" {set result "DIFF_HSTL"}
		"1.5-V HSTL Class II" {set result "HSTL_II"}
		"Differential 1.5-V HSTL Class II" {set result "DIFF_HSTL_II"}
		default {
			post_message -type error "Found unsupported Memory I/O standard $io_std on pin $target_pin"
			set result "UNKNOWN"
		}
	}
	return $result
}


# ----------------------------------------------------------------
proc get_ddr_pins {instname pins_array_name corename} {
#
# ----------------------------------------------------------------
	upvar 1 $pins_array_name pins
	array unset pins_t

	set dqsgroups 4

	for {set i 0} {$i < $dqsgroups} {incr i} {
		set dqs ${instname}_alt_mem_phy_inst|dpio|dqs_group\[$i\].*.dqs_obuf|o
		set dqsn ${instname}_alt_mem_phy_inst|dpio|dqs_group\[$i\].*.dqsn_obuf|o
		set dq  ${instname}_alt_mem_phy_inst|dpio|dqs_group\[$i\].dq_dqs|bidir_dq_*_output_ddio_out_inst|dataout
		set dm  ${instname}_alt_mem_phy_inst|dpio|dqs_group\[$i\].dq_dqs|output_dq_0_output_ddio_out_inst|dataout

		set dqs_p [map_get_node_name [walk_to_pins fanout [get_pins -compatibility_mode $dqs]]]
		if { [llength $dqs_p] != 1} { post_sdc_message critical_warning "Could not find DQS pin number $i" } 

		set dqsn_p [map_get_node_name [walk_to_pins fanout [get_pins -compatibility_mode $dqsn]]]
		if { [llength $dqsn_p] != 1} { post_sdc_message critical_warning "Could not find DQSn pin number $i" } 

		set dm_p  [map_get_node_name [walk_to_pins fanout [get_pins -compatibility_mode $dm]]]
		if { [llength $dm_p] != 1} { post_sdc_message critical_warning "Could not find DM pin for DQS pin number $i" } 

		set dq_p  [map_get_node_name [walk_to_pins fanout [get_pins -compatibility_mode $dq]]]
		if { [llength $dq_p] != 8} { post_sdc_message critical_warning "Could not find correct number of DQ pins for DQS pin $i. Found [llength $dq_p] pins. Expecting 8." } 

		set dqsgroup [list [lindex $dqs_p 0] $dm_p [lsort $dq_p] [lindex $dqsn_p 0]]
		lappend pins_t(dqsgroup) $dqsgroup
	}

	set patterns [list]
	lappend patterns addrcmd_2t ${instname}_alt_mem_phy_inst|*adc|*addr\[*\].addr_struct|*addr_pin|auto_generated|ddio_outa\[*\]|dataout
	lappend patterns addrcmd_2t ${instname}_alt_mem_phy_inst|*adc|*ba\[*\].ba_struct|*addr_pin|auto_generated|ddio_outa\[*\]|dataout
	lappend patterns addrcmd_2t ${instname}_alt_mem_phy_inst|*adc|*cas_n_struct|*addr_pin|auto_generated|ddio_outa\[*\]|dataout
	lappend patterns addrcmd_2t ${instname}_alt_mem_phy_inst|*adc|*ras_n_struct|*addr_pin|auto_generated|ddio_outa\[*\]|dataout
	lappend patterns addrcmd_2t ${instname}_alt_mem_phy_inst|*adc|*we_n_struct|*addr_pin|auto_generated|ddio_outa\[*\]|dataout
	lappend patterns addrcmd    ${instname}_alt_mem_phy_inst|*adc|*cke\[*\].cke_struct|*addr_pin|auto_generated|ddio_outa\[0\]|dataout
	lappend patterns addrcmd    ${instname}_alt_mem_phy_inst|*adc|*odt\[*\].odt_struct|*addr_pin|auto_generated|ddio_outa\[0\]|dataout
	lappend patterns addrcmd    ${instname}_alt_mem_phy_inst|*adc|*cs_n\[*\].cs_n_struct|*addr_pin|auto_generated|ddio_outa\[0\]|dataout
	lappend patterns resetn    ${instname}_alt_mem_phy_inst|*adc|*ddr3_rst_struct|*addr_pin|auto_generated|ddio_outa\[0\]|dataout
	lappend patterns ck_p ${instname}_alt_mem_phy_inst|clk|DDR_CLK_OUT\[*\].mem_clk_obuf|o
	lappend patterns ck_n ${instname}_alt_mem_phy_inst|clk|DDR_CLK_OUT\[*\].mem_clk_n_obuf|o

	foreach {pin_type pattern} $patterns { 
		set ports [map_get_node_name [walk_to_pins fanout [get_pins -compatibility_mode $pattern]]]
		if {[llength $ports] == 0} {
			post_message -type critical_warning "Could not find pin of type $pin_type from pattern $pattern"
		} else {
			foreach port [lsort -unique $ports] {
				lappend pins_t($pin_type) $port
			}
		}
	}

	set outputFileName "${corename}_autodetectedpins.tcl"
	set f [open $outputFileName w]

	foreach {k v} [array get pins_t] {
		foreach vi $v {
			ddr_pin $k  $vi pins
			puts $f "ddr_pin [list $k] [list $vi] pins"
		}
	}
	close $f
}

proc sort_proc {a b} {
	set idxs [list 1 2 0]
	foreach i $idxs {
		set ai [lindex $a $i]
		set bi [lindex $b $i]
		if {$ai > $bi} {
			return 1
		} elseif { $ai < $bi } {
			return -1
		}
	}
	return 0
}

