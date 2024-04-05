onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib ASCII_ROM_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {ASCII_ROM.udo}

run 1000ns

quit -force
