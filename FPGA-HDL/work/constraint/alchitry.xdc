# clk => 100000000Hz
#create_clock -period 10.0 -name clk_0 -waveform {0.000 5.000} [get_ports clk]
create_clock -period 10.0 [get_ports clk]

#Peripherals
set_property PACKAGE_PIN N14 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
#set_property PACKAGE_PIN P6 [get_ports {rst}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

#LED Stuff
set_property PACKAGE_PIN K13 [get_ports led[0]]
set_property IOSTANDARD LVCMOS33 [get_ports led[0]]

set_property PACKAGE_PIN K12 [get_ports led[1]]
set_property IOSTANDARD LVCMOS33 [get_ports led[1]]

set_property PACKAGE_PIN L14 [get_ports led[2]]
set_property IOSTANDARD LVCMOS33 [get_ports led[2]]

set_property PACKAGE_PIN L13 [get_ports led[3]]
set_property IOSTANDARD LVCMOS33 [get_ports led[3]]

set_property PACKAGE_PIN M16 [get_ports led[4]]
set_property IOSTANDARD LVCMOS33 [get_ports led[4]]

set_property PACKAGE_PIN M14 [get_ports led[5]]
set_property IOSTANDARD LVCMOS33 [get_ports led[5]]

set_property PACKAGE_PIN M12 [get_ports led[6]]
set_property IOSTANDARD LVCMOS33 [get_ports led[6]]

set_property PACKAGE_PIN N16 [get_ports led[7]]
set_property IOSTANDARD LVCMOS33 [get_ports led[7]]

set_property PACKAGE_PIN P15 [get_ports {usb_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_rx}]
set_property PACKAGE_PIN P16 [get_ports {usb_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_tx}]

#VGA Outputs
#orange BR C14
set_property PACKAGE_PIN P3 [get_ports {hSync}] 
set_property IOSTANDARD LVCMOS33 [get_ports {hSync}] 
#yellow BR C15
set_property PACKAGE_PIN P4 [get_ports {vSync}] 
set_property IOSTANDARD LVCMOS33 [get_ports {vSync}]

#red BR C34
set_property PACKAGE_PIN R1 [get_ports {red}]
set_property IOSTANDARD LVCMOS33 [get_ports {red}]
#green BR C33
set_property PACKAGE_PIN R2 [get_ports {green}]
set_property IOSTANDARD LVCMOS33 [get_ports {green}]
#blue BR C30
set_property PACKAGE_PIN R3 [get_ports {blue}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue}]

#Bitstream Settings
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
