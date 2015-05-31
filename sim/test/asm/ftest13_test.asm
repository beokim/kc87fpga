CTC0:		equ	80h		; System CTC0 Kassette, Beeper
CTC1:		equ	81h		; System CTC1 Anwenderport
CTC2:		equ	82h		; System CTC2 Systemuhr
CTC3:		equ	83h		; System CTC3 Systemuhr

PIO1AD:		EQU	88H		; PIO1 A Daten Beeper, Border, 20Z
PIO1BD:		EQU	89H		; PIO1 B Daten Anwenderport
PIO1AS:		EQU	8AH		; PIO1 A Kommando
PIO1BS:		EQU	8BH		; PIO1 B Kommando Anwenderport

PIO2AD:		EQU	90H		; Tastatur-PIO2 A Daten
PIO2BD:		EQU	91H		; Tastatur-PIO2 B Daten
PIO2AS:		EQU	92H		; Tastatur-PIO2 A Kommando
PIO2BS:		EQU	93H		; Tastatur-PIO2 B Kommando

; Interruptvektoren

iv_ctc0:	equ 240			; Interruptvekor CTC0
iv_ctc1:	equ 242			; Interruptvekor CTC1
iv_ctc2:    equ 244			; Interruptvekor CTC2
iv_ctc3:	equ 246			; Interruptvekor CTC3
iv_pio1a:	equ 248			; Interruptvekor PIO1A
iv_pio1b:	equ 250			; Interruptvekor PIO1B
iv_pio2a:	equ 252			; Interruptvekor PIO2A
iv_pio2b:	equ 254			; Interruptvekor PIO2B

; Arbeitsspeicher
unk_310:	equ	310h		; bitweise sind	die abzuarbeitenden Tests markiert
;default:	1	0	1	0	1	0	1	1	b
;		TPROM1	|TPROM2	|TPRAM1	|TPRAM2	|TPRAMB	|TPRAMF	|TPCEA	|TPTAST
unk_311:	equ	311h		; 0, nicht verwendet? (nur main)
unk_312:	equ	312h		; 2 Byte Zwischenspeicher für SP in sub_839B
unk_316:	equ	316h		; 1 = ROM-Test, 2 = RAM-Test, sonst Null
unk_317:	equ	317h		; '$' - Merker für Fehler bei ROM-Test
unk_318:	equ	318h		; '$' - Merker für Fehler bei RAM-Test
unk_320:	equ	320h		; Gesamtzanzahl der Fehler (3 Byte)
unk_322:	equ	322h		; Gesamtzanzahl der Fehler Teil 2
unk_323:	equ	323h		; Anzahl der Testdurchläufe (main5)
unk_324:	equ	324h		; 2 Byte (sub_82D3)
unk_326:	equ	326h		; (IR_CTC3)
unk_32A:	equ	32Ah		; wird in IR_PIO1B auf 1 gesetzt
unk_330:	equ	330h		; Ende Arbeitsspeicher

org 0f000h

		jp	main
		db	"#       ",0
		db    0
     
inttab:		
        jp	IR_CTC0		; Interruptroutinen
		jp	IR_CTC1		; Interruptroutine CTC1
		jp	IR_CTC3		; Interruptroutine CTC3
		jp	IR_PIO1A	; Interruptroutine PIO1A (?)
		jp	IR_PIO1B	; Interruptroutine PIO1	B Anwenderport
		jp	IR_PIO2A	; Interruptroutine Tastatur-PIO2 A, setzt D:=1
		jp	IR_PIO2B	; Interruptroutine Tastatur-PIO2 B, setzt E:=1
        
main:
        ld  sp,200h
        xor	a
        ld	i,a
        im	2
        
        call build_ivtab
        call tptast

        jp  main
        
build_ivtab:
        ld	de, 3
		ld	hl, inttab	; Interruptroutinen
		ld	(iv_ctc0), hl	; Interruptvekor CTC0
		add	hl, de
		ld	(iv_ctc1), hl	; Interruptvekor CTC1
		add	hl, de
		ld	(iv_ctc3), hl	; Interruptvekor CTC3
		add	hl, de
		ld	(iv_pio1a), hl	; Interruptvekor PIO1A
		add	hl, de
		ld	(iv_pio1b), hl	; Interruptvekor PIO1B
		add	hl, de
		ld	(iv_pio2a), hl	; Interruptvekor PIO2A
		add	hl, de
		ld	(iv_pio2b), hl	; Interruptvekor PIO2B
		ret
        
tptast:		
        di			; Testprogramm Tastatur
		ld	a, lo(iv_pio2a) ; Interruptvektor
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		ld	a, 11001111b	; Bit-E/A-Modus
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		xor	a		; alle Leitungen Ausgabe
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		ld	a, 00010111b	; DI, OR, LOW, Maske folgt
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		xor	a		; Interruptmaske 0 (alle Leitungen können Int. auslösen)
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		ld	a, lo(iv_pio2b) ; Interruptvektor
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		ld	a, 11001111b	; Bit-E/A-Modus
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		ld	a, 11111111b	; alle Leitungen Eingabe
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		ld	a, 10010111b	; EI, OR, LOW, Maske folgt
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		xor	a		; Interruptmaske 0 (alle Leitungen können Int. auslösen)
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		ld	a, 11111111b	; alle Tastatur-Spalten	auf High
		out	(PIO2AD), a	; Tastatur-PIO2	A Daten
		ei
		ld	c, 11111110b	; Spalte 8 aktivieren
		ld	b, 8
;
tptast1:	ld	de, 0
		ld	a, c		; Spalte aktivieren
		out	(PIO2AD), a	; Tastatur-PIO2	A Daten
		push	bc
		ld	c, 0Ah		; kurze	Pause
;
tptast2:	dec	c
		ld	a, c
		cp	0
		jr	nz, tptast2
		pop	bc
		ld	a, d		; PIO2A-Interrupt? (Spalte)
		cp	0		; wird von Interruptroutine auf	1 gesetzt
		jr	nz, tptast4	; Interupt von Spalte ist ein Fehler
		ld	a, e		; PIO2B-Interrupt? (Zeile)
		cp	0		; wird von Interruptroutine auf	1 gesetzt
		jr	z, tptast4	; keine	Taste gedrückt -> Fehler
		rlc	c		; nächste Spalte (nach links)
		djnz	tptast1		; bis 8	Spalten	fertig
		di
		ld	a, 11001111b	; Bit-E/A-Modus
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		ld	a, 11111111b	; alle Leitungen Eingabe
		out	(PIO2AS), a	; Tastatur-PIO2	A Kommando
		ld	a, 11001111b	; Bit-E/A-Modus
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		xor	a		; alle Leitungen Ausgabe
		out	(PIO2BS), a	; Tastatur-PIO2	B Kommando
		ei
		ld	bc, 801h	; 8 Zeilen, Beginn mit oberster	Zeile
;
tptast3:	ld	a, c		; Zeile	aktivieren
		out	(PIO2BD), a	; Tastatur-PIO2	B Daten
		call	wait14		; kurze	Warteschleife
		in	a, (PIO2AD)	; Tastatur-PIO2	A Daten
		cp	c
		jr	nz, tptast4
		rlc	c
		djnz	tptast3
		jp	loc_833D
;
tptast4:	call	print_errorcnt	; Anzeige der Fehleranzahl
		jp	loc_833D

print_errorcnt:
        ret

loc_833D:
        ret
        
; kurze	Warteschleife
wait14:		push	bc
		ld	b, 14h
wait141:	dec	b
		ld	a, b
		cp	0
		jr	nz, wait141
		pop	bc
		ret
; Interruptroutine CTC0
IR_CTC0:	exx			
		ld	d, 0
		inc	b
		exx
		ld	a, 10000011b	; Interrupt ein
		out	(PIO1AS), a	; PIO1 A Kommando
		ei
		reti

; Interruptroutine CTC1		
IR_CTC1:	push	af		
		ld	a, 00000011b	; DI, RESET
		out	(CTC1), a	; CTC 1
		pop	af
		ei
		reti
 
; Interruptroutine PIO1A (?) CTC2 (?)
IR_PIO1A:	exx			
		inc	c
		ld	d, 1
		exx
		ld	a, 00000011b	; Interrupt aus
		out	(PIO1AS), a	; PIO1 A Kommando
		ei
		reti

; Interruptroutine CTC3
IR_CTC3:	di			
		push	af
		push	hl
		ld	hl, unk_326
		inc	(hl)
		ld	hl, unk_320
		xor	a
		cp	(hl)
		jr	nz, IR_CTC32
		inc	hl
		cp	(hl)
		jr	nz, IR_CTC32
		inc	hl
		cp	(hl)
		jr	nz, IR_CTC32
		ld	a, 10000111b
		out	(CTC1), a	; CTC 1
		ld	a, 00000101b
		out	(CTC1), a	; CTC 1
IR_CTC31:	pop	hl
		pop	af
		ei
		reti

IR_CTC32:	ld	a, 00000011b
		out	(CTC1), a	; CTC 1
		jr	IR_CTC31
 

; Interruptroutine PIO1	B Anwenderport
IR_PIO1B:	ld	a, 1		
		ld	(unk_32A), a
		ei
		reti
        
IR_PIO2B:	ld	e, 1		; Interruptroutine Tastatur-PIO2 B, setzt E:=1
		ei
		reti

IR_PIO2A:	ld	d, 1		; Interruptroutine Tastatur-PIO2 A, setzt D:=1
		ei
		reti
