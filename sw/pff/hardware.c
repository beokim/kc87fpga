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
// hardwareroutinen für pff
#include "integer.h"

// adressen für spi-schnittstelle
__sfr __at(0x04) spi_data;
__sfr __at(0x05) spi_busy;
__sfr __at(0x06) spi_cs;
__sfr __at(0x07) spi_divider;

/* Send a 0xFF to the MMC and get the received byte (asmfunc.S) */
BYTE rcv_spi(void) {
//    while(spi_busy);
    spi_data = 255;
    while(spi_busy);
    return spi_data;
}

/* Initialize SPI port (asmfunc.S) */
void init_spi(void) {
    spi_divider = 60;
}

void spi_setspeed(BYTE b) {
    spi_divider = b;
}

/* Select MMC (asmfunc.S) */
void deselect(void) {
    while(spi_busy);
    spi_cs = 1;
    rcv_spi();
}

/* Deselect MMC (asmfunc.S) */
void select(void) {
    while(spi_busy);
    spi_cs = 0;
}

/* Send a byte to the MMC (asmfunc.S) */
void xmit_spi(BYTE d) {
    while(spi_busy);
    spi_data = d;
}

/* Delay 100 microseconds (asmfunc.S) */
void dly_100us(void) {
    char i;

    for(i=0;i<90;i++) {
        __asm
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
        __endasm;
    }
    // TODO
}
