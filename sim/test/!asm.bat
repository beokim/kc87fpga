z80asm asm/ctc_test.asm -o ctc_test.bin
z80asm asm/ftest13_test.asm -o ftest13_test.bin
z80asm asm/int_controller.asm -o int_controller.bin
z80asm asm/kc_test.asm -o kc_test.bin

rem \cygwin64\bin\tclsh8.5.exe bin2vhdl.tcl ctc_test.bin os_ctc >ctc_test.vhd
