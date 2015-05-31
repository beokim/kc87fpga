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
// routinen für uart

// ports für uart
__sfr __at(0x00) uart_txd;
__sfr __at(0x01) uart_rxd;


// zeichen ausgeben
void putchar(char c) {
    while(uart_txd); // busy?
    uart_txd = c;
}

// zeichen einlesen
// 0x00 = kein zeichen
char readchar() {
    char c = uart_rxd;
    if(c != 0) {
        uart_rxd = c; // clear rx-buff
    }
    return c;
}

// String ausgeben
void printStr(char* s) {
    while(*s != 0) {
        putchar(*s++);
    }
}

// hex-zeichen ausgeben
void printHexChar(unsigned char c) {
    if(c < 10) {
        putchar(c + '0');
    } else {
        putchar(c + '7');
    }
}

// byte als hex ausgeben
void printHex(unsigned char c) {
    printHexChar(c >> 4);
    printHexChar(c & 0xF);
}

// uint als hex ausgeben
void printHexUInt(unsigned int u) {
    printHex(u>>8);
    printHex(u);
}


                        
                        