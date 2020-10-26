onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+fifo_generator_1 -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_generator_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {fifo_generator_1.udo}

run -all

endsim

quit -force
