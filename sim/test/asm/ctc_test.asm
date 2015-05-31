CTC0:       equ 80h
CTC1:       equ 81h
CTC2:       equ 82h
CTC3:       equ 83h

testval1:   equ 4000h
testval2:   equ 4002h
testval3:   equ 4004h
testval4:   equ 4006h
count:      equ 4008h
sp1:        equ 400ah

stack:      equ 4200h


        jp  start
      
        ds  5
        
ivtab:  dw  itest1
        dw  itest2
        dw  itest3
        dw  itest4
start:
        ld  sp,stack

        ld  a,0h
        ld	i,a
        im	2

        ld  a, ivtab
        out (CTC0), a
        ld  a, 10010111b
        out (CTC0), a
        out (CTC1), a
        out (CTC2), a
        out (CTC3), a
        
        ld  a, 2
        out (CTC0), a
        inc a
        out (CTC1), a
        inc a
        out (CTC2), a
        inc a
        out (CTC3), a
        ei
        
        ld  hl, count

wloop:  
        ld  (sp1), sp
        inc (hl) 
        jp  wloop

itest1:
        push af
        push hl
        ld  hl, testval1
        inc (hl)
        pop hl
        pop af
        ei
        reti
itest2:
        push af
        push hl
        ld  hl, testval2
        inc (hl)
        pop hl
        pop af
        ei
        reti
itest3:
        push af
        push hl
        ld  hl, testval3
        inc (hl)
        pop hl
        pop af
        ei
        reti
itest4:
        push af
        push hl
        ld  hl, testval4
        inc (hl)
        pop hl
        pop af
        ei
        reti
