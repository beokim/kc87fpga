onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /kc87_min_tb/clk
add wave -noupdate /kc87_min_tb/reset_n
add wave -noupdate /kc87_min_tb/int_n
add wave -noupdate /kc87_min_tb/int
add wave -noupdate /kc87_min_tb/m1_n
add wave -noupdate /kc87_min_tb/mreq_n
add wave -noupdate /kc87_min_tb/iorq_n
add wave -noupdate -radix hexadecimal /kc87_min_tb/cpu_addr
add wave -noupdate -radix hexadecimal /kc87_min_tb/cpu_di
add wave -noupdate -radix hexadecimal /kc87_min_tb/cpu_do
add wave -noupdate /kc87_min_tb/test1
add wave -noupdate /kc87_min_tb/test2
add wave -noupdate /kc87_min_tb/test3
add wave -noupdate /kc87_min_tb/ram_cs_n
add wave -noupdate /kc87_min_tb/cram_cs_n
add wave -noupdate /kc87_min_tb/vram_cs_n
add wave -noupdate /kc87_min_tb/osRom_cs_n
add wave -noupdate /kc87_min_tb/ctc_cs_n
add wave -noupdate /kc87_min_tb/pio1_cs_n
add wave -noupdate /kc87_min_tb/pio2_cs_n
add wave -noupdate /kc87_min_tb/ctc/clk
add wave -noupdate /kc87_min_tb/ctc/res_n
add wave -noupdate /kc87_min_tb/ctc/en
add wave -noupdate /kc87_min_tb/ctc/dIn
add wave -noupdate -radix hexadecimal /kc87_min_tb/ctc/cpuDIn
add wave -noupdate /kc87_min_tb/ctc/dOut
add wave -noupdate /kc87_min_tb/ctc/cs
add wave -noupdate /kc87_min_tb/ctc/m1
add wave -noupdate /kc87_min_tb/ctc/iorq
add wave -noupdate /kc87_min_tb/ctc/rd
add wave -noupdate /kc87_min_tb/ctc/ieo
add wave -noupdate /kc87_min_tb/ctc/iei
add wave -noupdate /kc87_min_tb/ctc/int
add wave -noupdate /kc87_min_tb/ctc/intAck
add wave -noupdate /kc87_min_tb/ctc/clk_trg
add wave -noupdate /kc87_min_tb/ctc/zc_to
add wave -noupdate /kc87_min_tb/ctc/kcSysClk
add wave -noupdate /kc87_min_tb/ctc/clkCounter
add wave -noupdate /kc87_min_tb/ctc/ctcClkEn
add wave -noupdate /kc87_min_tb/ctc/cEn
add wave -noupdate -radix hexadecimal -childformat {{/kc87_min_tb/ctc/cDOut(3) -radix hexadecimal} {/kc87_min_tb/ctc/cDOut(2) -radix hexadecimal} {/kc87_min_tb/ctc/cDOut(1) -radix hexadecimal} {/kc87_min_tb/ctc/cDOut(0) -radix hexadecimal}} -subitemconfig {/kc87_min_tb/ctc/cDOut(3) {-radix hexadecimal} /kc87_min_tb/ctc/cDOut(2) {-radix hexadecimal} /kc87_min_tb/ctc/cDOut(1) {-radix hexadecimal} /kc87_min_tb/ctc/cDOut(0) {-radix hexadecimal}} /kc87_min_tb/ctc/cDOut
add wave -noupdate /kc87_min_tb/ctc/cInt
add wave -noupdate /kc87_min_tb/ctc/cIntTrig
add wave -noupdate /kc87_min_tb/ctc/cIntMask
add wave -noupdate /kc87_min_tb/ctc/currentInt
add wave -noupdate /kc87_min_tb/ctc/cSetTC
add wave -noupdate /kc87_min_tb/ctc/setTC
add wave -noupdate /kc87_min_tb/ctc/cClk_trg
add wave -noupdate /kc87_min_tb/ctc/cZc_to
add wave -noupdate /kc87_min_tb/ctc/irqVect
add wave -noupdate /kc87_min_tb/ctc/reti
add wave -noupdate /kc87_min_tb/ctc/intIeo
add wave -noupdate /kc87_min_tb/ctc/irqServiced
add wave -noupdate /kc87_min_tb/ctc/intIntAck
add wave -noupdate /kc87_min_tb/ctc/currentIrqChannel
add wave -noupdate /kc87_min_tb/ctc/ctcIrqLevel
add wave -noupdate /kc87_min_tb/ctc/actIrqLevel
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/clk
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/res_n
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/en
add wave -noupdate -radix hexadecimal /kc87_min_tb/ctc/channels(2)/channel/dIn
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/dOut
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/m1
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/iorq
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/rd
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/int
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/setTC
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/ctcClkEn
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/clk_trg
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/zc_to
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/state
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/nextState
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/control
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/preDivider
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/edgeDet
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/dCounter
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/timeConstant
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/triggerIrq
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/running
add wave -noupdate /kc87_min_tb/ctc/channels(2)/channel/startUp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {158678296 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 280
configure wave -valuecolwidth 76
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
WaveRestoreZoom {158150130 ps} {158989870 ps}
