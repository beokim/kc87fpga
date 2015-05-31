; bootloader fuer serial rom
sysctl:  equ 2

    org $0000
    
    ; sp in den farbram verlegen
    ld  sp,$EBC0
    
    ld  hl,os_data
    ld  de,$f000
    call dzx7_standard
    
    ld  hl,basic_data
    ld  de,$c000
    call dzx7_standard
    
    ld  hl,monitor_data
    ld  de,$8000
    call dzx7_standard
    
    ; routine zum ausblenden des rom kopieren
    ld  bc,os_data-start
    ld  de,$ec00
    ld  hl,start
    ldir

    ; und starten
    jp  $ec00

    include "asm/dzx7_standard.asm"

start:
    ; rom ausblenden+turbo aus+schreibschutz an
    ld  a,1+4
    out (sysctl),a
    jp  $f000
;    jp  $8000
    
os_data:
    incbin "asm/os____f0.87b.zx7"
basic_data:
    incbin "asm/basic_c0.87b.zx7"
monitor_data:
    incbin "monitor.bin.zx7"
;    incbin "ftest13.com.pck"
;    incbin  "ramtest8.bin.pck"
monitor_end:
