onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /video_tb/clk
add wave -noupdate -radix unsigned -childformat {{/video_tb/ramaddr(9) -radix unsigned} {/video_tb/ramaddr(8) -radix unsigned} {/video_tb/ramaddr(7) -radix unsigned} {/video_tb/ramaddr(6) -radix unsigned} {/video_tb/ramaddr(5) -radix unsigned} {/video_tb/ramaddr(4) -radix unsigned} {/video_tb/ramaddr(3) -radix unsigned} {/video_tb/ramaddr(2) -radix unsigned} {/video_tb/ramaddr(1) -radix unsigned} {/video_tb/ramaddr(0) -radix unsigned}} -subitemconfig {/video_tb/ramaddr(9) {-height 15 -radix unsigned} /video_tb/ramaddr(8) {-height 15 -radix unsigned} /video_tb/ramaddr(7) {-height 15 -radix unsigned} /video_tb/ramaddr(6) {-height 15 -radix unsigned} /video_tb/ramaddr(5) {-height 15 -radix unsigned} /video_tb/ramaddr(4) {-height 15 -radix unsigned} /video_tb/ramaddr(3) {-height 15 -radix unsigned} /video_tb/ramaddr(2) {-height 15 -radix unsigned} /video_tb/ramaddr(1) {-height 15 -radix unsigned} /video_tb/ramaddr(0) {-height 15 -radix unsigned}} /video_tb/ramaddr
add wave -noupdate /video_tb/charData
add wave -noupdate /video_tb/colData
add wave -noupdate /video_tb/video/countH
add wave -noupdate /video_tb/video/countV
add wave -noupdate /video_tb/video/output
add wave -noupdate /video_tb/video/color
add wave -noupdate /video_tb/video/display
add wave -noupdate /video_tb/hsync
add wave -noupdate /video_tb/vsync
add wave -noupdate /video_tb/red
add wave -noupdate /video_tb/green
add wave -noupdate /video_tb/blue
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16437500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
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
WaveRestoreZoom {15361051 ps} {16813949 ps}
