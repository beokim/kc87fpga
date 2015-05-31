
STUND:	EQU	1DH		;PUFFER STUNDEN
MIN:	EQU	1EH		;PUFFER MINUTEN
SEK:	EQU	1FH		;PUFFER SEKUNDEN
COUNT:	EQU	23H		;ZAEHLER CTC2 - INTERRUPTS
LAKEY:	EQU	24H		;LETZTES GUELTIGES ZEICHEN
KEYBU:	EQU	25H		;TASTATURPUFFER
ARB:	EQU	6AH		;ARBEITSZELLE

; System-PIO ist PIO1
DPIO1A:	equ	88H		;Daten Kanal A		Video     
DPIO1B:	equ	89H		;Daten Kanal B		User-E/A     
SPIO1A:	equ	8aH		;Steuerung Kanal A     
SPIO1B:	equ	8bH		;Steuerung Kanal B     
     
; Tastatur-PIO ist PIO2     
DPIOA:	EQU	90H		;TASTATUR-PIO A DATEN     
DPIOB:	EQU	91H		;TASTATUR-PIO B DATEN     
SPIOA:	EQU	92H		;TASTATUR-PIO A KOMMANDO     
SPIOB:	EQU	93H		;TASTATUR-PIO B KOMMANDO     
CTC0:	EQU	80H     
CTC2:	EQU	82H     
CTC3:	EQU	83H     

    org 0F000H
    
    jp  start
    
start:
    LD	SP,200H
    
    LD	DE,200H    
    LD	HL,INTV    
    LD	BC,12    
    LDIR			;INTERRUPTADRESSEN LADEN    
    
    LD	A,2
    LD	I,A
    IM	2

    INC	A
    OUT	(SPIO1A), A
    LD	A,0CFH
    OUT	(SPIO1A), A	;PIO 1  PORT A  IN BYTEAUSGABE
    XOR	A
    OUT	(SPIO1A), A
    OUT	(DPIO1A), A

    call INITA
ende:
    jp ende

INTV:
	DW	IKACT		;KASSETTE SCHREIBEN	CTC0    
	DW	0		;			CTC1    
	DW	ICTC		;VORTEILER UHR		CTC2    
	DW	INUHR		;SEKUNDENTAKT UHR	CTC3    
	DW	INTP		;TASTATUR		PIOB    
	DW	IKEP		;KASSETTE LESEN		PIO1AS    
;    
  
INITA:	
    DI  
  	PUSH	AF  
  	CALL	INICT		;CTC INITIALISIEREN  
  	POP	AF  
  ;INITIALISIERUNG TASTATUR-PIO  DATEN A  AUF 0  
INPIO:	PUSH	AF  
  	CALL	INITT		;INIT. PIO DATEN A AUF FFH  
  	LD	A,83H		;INTERRUPT  
  	OUT	(SPIOB), A	;Interrupt ein  
  	XOR	A		;A=0  
  	OUT	(DPIOA), A	;SPIOA alle Leitungen auf 0  
  ;bei Tastendruck wird jetzt ein LOW-Pegel von PIOA auf PIOB durchgeleitet  
  ;dieser löst einen Interrupt aus --> INTP  
  	POP	AF  
  	EI  
  	RET  

;INITIALISIERUNG CTC
INICT:
    LD	A,3		;Steuerwort CTC: Reset
	OUT	(CTC0), A
	OUT	(CTC2), A
	OUT	($8A), A		;Steuerung PIO1 Kanal A, Interrupt aus
	XOR	A
	OUT	(CTC0), A		;INTERRUPT-VEKTOR = 00h
	LD	A,0C7H		;ZAEHLERINTERRUPT (Steuerwort CTC3: EI, Reset, Zeitkonstante folgt)
	OUT	(CTC3), A
	LD	A,01H		;Zeitkonstante 64, zusammen mit CTC2 ergibt das einen Takt von 1 sek = 1 Hz
;	LD	A,40H		;Zeitkonstante 64, zusammen mit CTC2 ergibt das einen Takt von 1 sek = 1 Hz
	OUT	(CTC3), A

INIC1:
    LD	A,27H		;ZEITGEBER KEIN INTERRUPT (Steuerwort CTC2: Vorteiler 256, Reset, Zeitkonstante folgt)
	OUT	(CTC2), A
	LD	A,01H		;Zeitkonstante: 2,4576 Mhz / 256 / 96h = 64 Hz
;	LD	A,96H		;Zeitkonstante: 2,4576 Mhz / 256 / 96h = 64 Hz
	OUT	(CTC2), A
	LD	A,3
	RET
    
INITT:	LD	A,0CFH		;BIT E/A
	OUT	(SPIOA), A
	XOR	A		;ALLES AUSGAENGE
	OUT	(SPIOA), A
	LD	A,8		;Interruptvektor
	OUT	(SPIOB), A
	LD	A,$0CF		;BIT E/A
	OUT	(SPIOB), A
	LD	A,0FFH		;ALLES EINGAENGE
	OUT	(SPIOB), A
	LD	A,17H		;Interruptsteuerwort, OR, LOW-aktiv, Maske folgt
	OUT	(SPIOB), A
	XOR	A		;A=0, Interrupt-Maske
	OUT	(SPIOB), A	;alle Eingänge mit Interrupt
	DEC	A		;A=FF
	OUT	(DPIOA), A	;mit FF init.
	RET

;TASTATURINTERRUPTROUTINE
;wird durch PIOB aktiv, wenn ein Eingang auf LOW geht
;weiter geht es mit einem Interrupt durch CTC2 --> ICTC
;
INTP:	PUSH	AF
	LD	A,10
	LD	(COUNT),A	;INTERRUPTZAEHLER LADEN
	LD	A,7FH		;FUER ENTPRELLEN
	LD	(LAKEY),A	;LETZES ZEICHEN LOESCHEN
	LD	A,0A5H		;CTC 2  INTERRUPT ERLAUBEN
	OUT	(CTC2), A		;EI, Zeitgeber, Vorteiler 256, Zeitkonstantenstart, Zeitkonstante folgt
	LD	A,01H		;Zeitkonstante: 2,4576 Mhz / 256 / 96h = 64 Hz
;	LD	A,96H		;Zeitkonstante: 2,4576 Mhz / 256 / 96h = 64 Hz
	OUT	(CTC2), A
	POP	AF
	EI
	RETI
    
;
;INTERRUPTROUTINE ZUM TASTATUR ENTPRELLEN/REPEAT - FUNKTION
;wird durch CTC2 aktiv
;
ICTC:	EI
	PUSH	AF
	PUSH	HL
	LD	HL,COUNT
	DEC	(HL)
	JR	Z, ICTC2	;TASTATUR ABFRAGEN
	LD	A,7
	AND	A, (HL)
	JR	NZ, ENDI	;NOCH NICHT WIEDER ABFRAGEN
	INC	HL		;(HL)=ADR. LAKEY
	CALL	DECO		;TASTATUR ABFRAGEN WENN LAKEY <>0
	JR	Z, ENDI		;KEIN GUELTIGER TASTENCODE
	CP	A, (HL)		;VERGLEICH MIT LETZTEM CODE
	JR	Z, ENDI
	DEC	HL
	LD	(HL),40		;NACH 1. ZEICHEN LANGE PAUSE
	JR	ICTC3
ICTC2:	LD	(HL),6		;SCHNELLES REPEAT
	CALL	DECO0		;TASTATUR ABFRAGEN
	JR	Z, ENDI		;KEIN GUELTIGER CODE
ICTC3:	INC	HL
	LD	(HL),A
	LD	A,(KEYBU)
	CP	A, 3		;STOP
	JR	Z, ENDI		;NICHT UEBERSCHREIBEN
	LD	A,(HL)
	LD	(KEYBU),A	;ZEICHEN IN TASTATURPUFFER
ENDI:	POP	HL
	POP	AF
	EI
	RETI

DECO:
DECO0:
    LD  A,20h
    ret
    
IKACT:	PUSH	AF
	LD	A,3		;Steuerwort CTC (Reset)
	OUT	(CTC0), A		;CTC0
	LD	A,85H		;Steuerwort CTC (EI, Zeitkonstante folgt)
	OUT	(CTC0), A		;CTC0
	LD	A,(ARB)		;Zeitkonstante holen
	OUT	(CTC0), A		;ZAEHLERWERT ENTSPR. ZEICHEN
	XOR	A
	LD	(ARB),A		;Arbeitszelle auf 0 setzen als Fertigmarkierung
	POP	AF
	EI
	RETI
;

IKEP:	PUSH	AF
	IN	A, (CTC0)
	PUSH	AF
	LD	A,7
	OUT	(CTC0), A
	LD	A,0B0H		;NEUE ZEITMESSUNG
	OUT	(CTC0), A
	POP	AF
	LD	(ARB),A
	POP	AF
	EI
	RETI
;
;
;UHRINTERRUPTROUTINE
;
INUHR:	EI
	PUSH	HL
	PUSH	BC
	PUSH	AF
	LD	HL,SEK+1
	LD	B,2
	LD	A,60
INUH1:	DEC	HL
	INC	(HL)
	CP	A, (HL)
	JR	NZ, INUH3
	LD	(HL),0
	DJNZ	INUH1
	LD	A,24
	DEC	HL
	INC	(HL)
	CP	A, (HL)
	JR	NZ, INUH3
	LD	(HL),0
INUH3:	POP	AF
	POP	BC
	POP	HL
	RETI
;