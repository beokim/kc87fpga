/*
    Copyright (c) 2015, $ME
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted 
    provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this list of conditions
       and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions 
       and the following disclaimer in the documentation and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
    WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
    TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
#include "kc87.h"
#include <string.h>

volatile __at(0x0024) char LAKEY;
volatile __at(0x0025) char KEYBU;

__at(0xEC00) char screenRam[25][40];
__at(0xE800) char colRam[25][40];

unsigned char line = 0;

// kc-taste lesen - funktioniert nur nach kaltstart!
char readKey() {
    char key;
    key = KEYBU;
    if (key) {
        KEYBU = 0;
    }
    return key;
}

// bildschirm löschen
void kcCls() {
    line = 0;
    memset(screenRam,' ',24*40);
    memset(colRam,0x20,24*40);
}

// aktuelle zeile setzen
void kcSetLine(unsigned char l) {
    line = l;
}

// hintergrund/vordergrund-farbe für x zeichen vertauschen
void kcColorBar(unsigned char n) {
    memset(colRam[line],0x02, n);
}

// farben wieder herstellen
void kcClearColorBar(unsigned char n) {
    memset(colRam[line],0x20, n);
}

// string ausgeben
void kcPrint(char* s) {
    char *linePtr = screenRam[line];
    char c;

    while(*s != 0) {
        c = *s++;
        switch (c) {
            case '\n':   
                linePtr = screenRam[++line];
                break;
            case '\t':
                linePtr = screenRam[line]+15;
                break;
            default:
                *linePtr++ = c;
        }
    }
    
    if (line>23) {
        line = 0;
    }
}

// unsigned int an tab-position ausgeben
void kcPrintUInt(unsigned int num) {
    char *linePtr = screenRam[line]+18;
    unsigned char i,c;
    
    for(i=0;i<4;i++) {
        c = num & 0xf;
        if(c < 10) {
            *linePtr-- = c + '0';
        } else {
            *linePtr-- = c + '7';
        }
        num = num>>4;
    }
}

// Zeile löschen
void kcClearLine() {
    memset(screenRam[line],' ',40);
}

// kaltstart
void coldBoot() {
    __asm
    ; kaststartroutine in den bildschirmspeicher kopieren
        ld  bc,#00002$-#00001$
        ld  de,#0xec00
        ld  hl,#00001$
        ldir
    
    ; und starten
        jp  0xec00
        
    00001$:
        ld  a,#SYSCONTROL_DEFAULT
        out (_syscontrol),a
        jp  0xf000
    00002$:
    __endasm;
}

// zur kommandozeile zurück
void warmBoot() {
    readKey();
    syscontrol = SYSCONTROL_DEFAULT;
    __asm
        LD SP,#0x0200
        JP 0xF089
    __endasm;
}

// basic starten v1 (nach vp)
void startBasic(unsigned char* addr) {
    addr;
    syscontrol = SYSCONTROL_DEFAULT;
    __asm
        POP BC
        POP DE
; Basic-Kaltstart (c) 09.10.2011 vp
; Programm ab (SVARPT)-2 laden (Std. 0401h)
; am Ende SVARPT := auf erstes Byte hinter Programm setzen

; DE = Adr. hinter Programm
        LD  (0x03D7), DE    ; SVARPT setzen

; Kaltstart
        LD  HL,#0x0C0BD ; RAMST
        LD  DE,#0x00300 ; WSP
        LD  BC,#0x67
        LDIR
        EX  DE,HL
        LD  SP,HL
        XOR A
        LD  (0x03AB),A  ; EOINPB
        LD  (0x0400),A  ; PRAM-1
        
;Reserviere Arbeitsrambereich
        LD  HL, (0x0036)    ; EOR   oberes RAM-Ende
        LD  DE,#-256
        LD  (0x03B0),HL ; MEMSIZ
        ADD HL,DE
        LD  (0x0356),HL ; STDPTR
        LD  A, #0xAF
        LD  (0x03FC),A  ; EXTFLG

; Zeilenanfangsadressen korrigieren
        CALL 0x0C64F    ; NEW2
        INC HL
        EX  DE,HL
        CALL 0x0C493    ; LIN11

; und starten
        CALL 0X0C669    ; INITR ; SP SETZEN
        JP   0X0C854     ; RUNMOD
    __endasm;
}

// basic starten v2 (nach tp)
void startBasic2(unsigned char* addr) {
    addr;
    __asm
        POP BC
        POP DE

; DE = Adr. hinter Programm
        LD  (0x03D7), DE    ; SVARPT setzen

; Kaltstart
        LD  HL,#0x0C0BD ; RAMST
        LD  DE,#0x00300 ; WSP
        LD  BC,#0x67
        LDIR
        EX  DE,HL
        LD  SP,HL
        
        LD  HL,#0x01C0
        LD  (0x0356),HL
        CALL 0x0C669    ; INITR
        LD  (0x03AB),A  ; EOINPB
        LD  (0x0400),A  ; PRAM-1
        
;Reserviere Arbeitsrambereich
        LD  HL, (0x0036)    ; EOR   oberes RAM-Ende
        LD  DE,#-256
        LD  (0x03B0),HL ; MEMSIZ
        ADD HL,DE
        LD  (0x0356),HL ; STDPTR
        XOR A
        LD  (0x035E),A
        CALL 0x0C64F    ; NEW2
        
        LD  A, #0xAF
        LD  (0x03FC),A  ; EXTFLG

        LD  SP,#0x0367
        CALL 0x0C669    ; INITR
; und starten

        CALL 0x0C64F    ; NEW2
        JP  0x0C854     ; RUNMOD
    __endasm;
}