onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /kc87_tb/kc87/CLOCK_50
add wave -noupdate /kc87_tb/kc87/vgaclock
add wave -noupdate /kc87_tb/VGA_R
add wave -noupdate /kc87_tb/VGA_G
add wave -noupdate /kc87_tb/VGA_B
add wave -noupdate -radix hexadecimal /kc87_tb/kc87/vram/ram
add wave -noupdate -radix ascii /kc87_tb/kc87/cram/ram
add wave -noupdate /kc87_tb/kc87/PIO1_CS_n
add wave -noupdate /kc87_tb/kc87/PIO2_CS_n
add wave -noupdate /kc87_tb/kc87/RAM_CS_n
add wave -noupdate /kc87_tb/kc87/RESET_s
add wave -noupdate -radix hexadecimal /kc87_tb/kc87/A
add wave -noupdate -radix hexadecimal /kc87_tb/kc87/CPU_D
add wave -noupdate /kc87_tb/kc87/cpu/RESET_n
add wave -noupdate /kc87_tb/kc87/cpu/CLK_n
add wave -noupdate /kc87_tb/kc87/cpu/WAIT_n
add wave -noupdate /kc87_tb/kc87/cpu/INT_n
add wave -noupdate /kc87_tb/kc87/cpu/NMI_n
add wave -noupdate /kc87_tb/kc87/cpu/BUSRQ_n
add wave -noupdate /kc87_tb/kc87/cpu/M1_n
add wave -noupdate /kc87_tb/kc87/cpu/MREQ_n
add wave -noupdate /kc87_tb/kc87/cpu/IORQ_n
add wave -noupdate /kc87_tb/kc87/cpu/RD_n
add wave -noupdate /kc87_tb/kc87/cpu/WR_n
add wave -noupdate /kc87_tb/kc87/cpu/RFSH_n
add wave -noupdate /kc87_tb/kc87/cpu/HALT_n
add wave -noupdate /kc87_tb/kc87/cpu/BUSAK_n
add wave -noupdate /kc87_tb/kc87/cpu/A
add wave -noupdate /kc87_tb/kc87/cpu/DI
add wave -noupdate /kc87_tb/kc87/cpu/DO
add wave -noupdate /kc87_tb/kc87/cpu/CEN
add wave -noupdate /kc87_tb/kc87/cpu/IntCycle_n
add wave -noupdate /kc87_tb/kc87/cpu/NoRead
add wave -noupdate /kc87_tb/kc87/cpu/Write
add wave -noupdate /kc87_tb/kc87/cpu/IORQ
add wave -noupdate /kc87_tb/kc87/cpu/DI_Reg
add wave -noupdate /kc87_tb/kc87/cpu/MCycle
add wave -noupdate /kc87_tb/kc87/cpu/TState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {111525 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {10219815 ps} {10464551 ps}
