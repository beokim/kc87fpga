testval1:   equ 0
testval2:   equ 2
testval3:   equ 4

stack:      equ 200h


org 0f000h
    jp  main
    
main:
    ld  sp,stack

    ld  a,3h
    ld	i,a
    im	2
    ld  hl, intv1
    ld  (300h), hl
    ei
    
    ld  hl, testval2
mloop:
    ld  (testval3), sp
    inc (hl)
    jr  mloop
    
intv1:
    jp  irtest
    
irtest:
    push af
    push hl
    ld  hl, testval1
    inc (hl)
    pop hl
    pop af
    ei
    reti
    
    
    