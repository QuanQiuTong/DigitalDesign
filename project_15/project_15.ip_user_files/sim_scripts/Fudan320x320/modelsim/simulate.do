onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L blk_mem_gen_v8_4_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.Fudan320x320 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {Fudan320x320.udo}

run 1000ns

quit -force
