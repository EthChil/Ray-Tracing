set_property PACKAGE_PIN P6 [get_ports button]
set_property PACKAGE_PIN K13 [get_ports led1]
set_property PACKAGE_PIN K12 [get_ports led2]
set_property PACKAGE_PIN L14 [get_ports led3]
set_property PACKAGE_PIN N14 [get_ports clk]

create_clock -period 10.000 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports button]

set_property DRIVE 12 [get_ports led1]
set_property SLEW SLOW [get_ports led1]
set_property PULLDOWN true [get_ports led1]
set_property IOSTANDARD LVCMOS33 [get_ports led1]

set_property DRIVE 12 [get_ports led2]
set_property SLEW SLOW [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led2]

set_property DRIVE 12 [get_ports led3]
set_property SLEW SLOW [get_ports led3]
set_property PULLDOWN true [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led3]


create_clock -period 10.000 -name mig/u_mig_7series_0_mig/u_ddr3_infrastructure/mmcm_clk -waveform {0.000 5.000} [get_pins mig/u_mig_7series_0_mig/u_ddr3_infrastructure/plle2_i/CLKIN1]
