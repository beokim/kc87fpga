onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /intcontroller_cpu_tb/clk
add wave -noupdate /intcontroller_cpu_tb/reset_n
add wave -noupdate /intcontroller_cpu_tb/int_n
add wave -noupdate /intcontroller_cpu_tb/m1_n
add wave -noupdate /intcontroller_cpu_tb/mreq_n
add wave -noupdate /intcontroller_cpu_tb/iorq_n
add wave -noupdate /intcontroller_cpu_tb/rd_n
add wave -noupdate /intcontroller_cpu_tb/wr_n
add wave -noupdate -radix hexadecimal /intcontroller_cpu_tb/cpu_addr
add wave -noupdate -radix hexadecimal /intcontroller_cpu_tb/cpu_di
add wave -noupdate -radix hexadecimal /intcontroller_cpu_tb/cpu_do
add wave -noupdate /intcontroller_cpu_tb/intAckV
add wave -noupdate /intcontroller_cpu_tb/intAck
add wave -noupdate /intcontroller_cpu_tb/int
add wave -noupdate /intcontroller_cpu_tb/Mirror_OS
add wave -noupdate -radix hexadecimal /intcontroller_cpu_tb/osRom_d
add wave -noupdate -radix hexadecimal /intcontroller_cpu_tb/ram_d
add wave -noupdate /intcontroller_cpu_tb/ram_cs_n
add wave -noupdate /intcontroller_cpu_tb/osRom_cs_n
add wave -noupdate /intcontroller_cpu_tb/memSel
add wave -noupdate /intcontroller_cpu_tb/clk
add wave -noupdate -radix hexadecimal /intcontroller_cpu_tb/intController/cpuDIn
add wave -noupdate /intcontroller_cpu_tb/intController/intPeriph
add wave -noupdate /intcontroller_cpu_tb/intController/intInternal
add wave -noupdate /intcontroller_cpu_tb/intController/intMask
add wave -noupdate /intcontroller_cpu_tb/intController/intAck
add wave -noupdate /intcontroller_cpu_tb/intController/intReti
add wave -noupdate /intcontroller_cpu_tb/intController/intRetiMask
add wave -noupdate -radix unsigned /intcontroller_cpu_tb/ram/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {173270000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 261
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
WaveRestoreZoom {143561946 ps} {144131214 ps}
