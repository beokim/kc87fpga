; bootloader fuer sdcard-rom
    org $0000
    
    ld  sp,$EBC0
    ld  hl,sdcard_data
    ld  de,$8000
    call dzx7_standard
   
;    jp  $8000
    jp  $8010

    include "asm/dzx7_standard.asm"
    
sdcard_data:
    incbin "sdcard.bin.zx7"
sdcard_end:
