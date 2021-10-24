# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]

set_property PACKAGE_PIN U16 [get_ports {data_show[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[0]}]
set_property PACKAGE_PIN E19 [get_ports {data_show[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[1]}]
set_property PACKAGE_PIN U19 [get_ports {data_show[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[2]}]
set_property PACKAGE_PIN V19 [get_ports {data_show[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[3]}]
set_property PACKAGE_PIN W18 [get_ports {data_show[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[4]}]
set_property PACKAGE_PIN U15 [get_ports {data_show[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[5]}]
set_property PACKAGE_PIN U14 [get_ports {data_show[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[6]}]
set_property PACKAGE_PIN V14 [get_ports {data_show[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_show[7]}]

#USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx]						
	set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]
    set_property IOSTANDARD LVCMOS33 [get_ports tx]

set_property CFGBVS GND [current_design];
set_property CONFIG_VOLTAGE 1.8 [current_design];