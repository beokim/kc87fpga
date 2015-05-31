onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ctc_tb/clk
add wave -noupdate /ctc_tb/testVect
add wave -noupdate /ctc_tb/ctc_d
add wave -noupdate /ctc_tb/ctcClkTrg
add wave -noupdate /ctc_tb/ctcTcTo
add wave -noupdate /ctc_tb/int
add wave -noupdate /ctc_tb/kcSysClk
add wave -noupdate /ctc_tb/res_n
add wave -noupdate /ctc_tb/ctc/clk
add wave -noupdate /ctc_tb/ctc/dIn
add wave -noupdate -radix hexadecimal /ctc_tb/ctc/dOut
add wave -noupdate -radix binary /ctc_tb/ctc/intAck
add wave -noupdate /ctc_tb/ctc/setTC
add wave -noupdate /ctc_tb/ctc/irqVect
add wave -noupdate -radix binary -childformat {{/ctc_tb/ctc/int(3) -radix hexadecimal} {/ctc_tb/ctc/int(2) -radix hexadecimal} {/ctc_tb/ctc/int(1) -radix hexadecimal} {/ctc_tb/ctc/int(0) -radix hexadecimal}} -subitemconfig {/ctc_tb/ctc/int(3) {-radix hexadecimal} /ctc_tb/ctc/int(2) {-radix hexadecimal} /ctc_tb/ctc/int(1) {-radix hexadecimal} /ctc_tb/ctc/int(0) {-radix hexadecimal}} /ctc_tb/ctc/int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40000923 ps} 0}
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
WaveRestoreZoom {0 ps} {7925052 ps}
