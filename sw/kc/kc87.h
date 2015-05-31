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
// kc87 spezifischen routinen
#ifndef _KC
#define _KC

// Syscontrol port:
// 0: 0 Bootrom einblenden
// 0: 1 Bootrom aus
// 1: 0 Turbo aus
// 1: 1 Turbo an
// 2: 0 Schreibschutz Ram ab 8000 aus
// 2: 1 Schreibschutz Ram ab 8000 an
__sfr __at(0x02) syscontrol;
// Turbo und Bootrom aus + WP an
#define SYSCONTROL_DEFAULT 1+4
// Bootrom und WP aus
#define SYSCONTROL_WPOFF 1
// Turbo an + Rom und WP aus
#define SYSCONTROL_TURBO 1+2
// Turbo und Rom an + WP aus
#define SYSCONTROL_TURBO_ROM 2

// kc-taste lesen - funktioniert nur nach kaltstart!
char readKey();

// bildschirm routinen
// bildschirm löschen
void kcCls();
// Zeile löschen
void kcClearLine();
// string ausgeben
void kcPrint(char* s);
// unsigned int an tab-position ausgeben
void kcPrintUInt(unsigned int num);
// aktuelle zeile setzen
void kcSetLine(unsigned char l);
// hintergrund/vordergrund-farbe für x zeichen vertauschen
void kcColorBar(unsigned char n);
// farben wieder herstellen
void kcClearColorBar(unsigned char n);

// kaltstart
void coldBoot();
// zur kommandozeile zurück
void warmBoot();
// basic starten v1 (nach vp)
void startBasic(unsigned char* addr);
// basic starten v2 (nach tp)
void startBasic2(unsigned char* addr);

#endif