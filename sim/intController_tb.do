onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /intcontroller_tb/intController/clk
add wave -noupdate /intcontroller_tb/intController/res
add wave -noupdate /intcontroller_tb/intController/int
add wave -noupdate /intcontroller_tb/intController/intPeriph
add wave -noupdate /intcontroller_tb/intController/intAck
add wave -noupdate /intcontroller_tb/intController/cpuDIn
add wave -noupdate /intcontroller_tb/intController/m1
add wave -noupdate /intcontroller_tb/intController/iorq
add wave -noupdate /intcontroller_tb/intController/rd
add wave -noupdate /intcontroller_tb/intController/intInternal
add wave -noupdate /intcontroller_tb/intController/intMask
add wave -noupdate /intcontroller_tb/intController/currentInt
add wave -noupdate /intcontroller_tb/intController/intReti
add wave -noupdate /intcontroller_tb/intController/intRetiMask
add wave -noupdate /intcontroller_tb/intController/reti
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1049460 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
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
WaveRestoreZoom {173396490 ps} {175084396 ps}
