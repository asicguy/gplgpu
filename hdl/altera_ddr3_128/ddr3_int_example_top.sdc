set_false_path -from * -to [get_ports "pnf"]
set_false_path -from * -to [get_ports "test_complete"]
set_false_path -from * -to [get_ports "pnf_per_byte\[*\]"]
set_false_path -from * -to [get_ports "mem_reset_n"]
