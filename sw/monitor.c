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

#include <stdio.h>
#include "uart/uart.h"
#include "kc/kc87.h"

const char hello[] = "*** Monitor V0.001 ***\n";

void startPrg(unsigned char* addr) {
    addr;
    __asm
        POP BC
        POP HL
        LD SP, #0X0200
        JP  (HL)
    __endasm;
}

unsigned char decodeChar(unsigned char c) {
    unsigned char ch = c;
    if(ch >= '0' && ch <= '9') {
        return ch - '0';
    } else if(ch >= 'A' && ch <= 'F') {
        return ch - 'A' + 10;
    } else if(ch >= 'a' && ch <= 'f') {
        return ch - 'a' + 10;
    }
    return 255;
}

void printAddr(unsigned char * addr) {
    putchar('>');
    printHex((unsigned char)((unsigned int)addr >> 8));
    printHex((unsigned char)addr);
    putchar('\n');
}

void lfsr15(unsigned int * n) {
    unsigned int num = *n;
    unsigned char tnum=num&3;

    if (tnum==0 || tnum==3) {
        num = num | 0x8000;
    }

    (*n) = num >> 1;
}

void main(void) {
    unsigned int lfsrState1 = 1234;
    unsigned int lfsrState2 = lfsrState1;
    
    unsigned int rounds = 0;
    
    unsigned char * memPtr = 0;
    unsigned char c;
    unsigned char n = 1;

    unsigned char dataVal = 0;

    enum monStates {none, addr, ihexCount, ihexAddr, ihexType, ihexData, ihexSkip };
    unsigned char monState = none;
    unsigned char iState = none;
    unsigned char iType = 0;
    unsigned char ihexN = 0;

    syscontrol = SYSCONTROL_TURBO;
    
//    printf("%s", hello);
    printStr(hello);

    
//    memPtr = (char*) &memPtr;
    while(1) {
        do {
            c = readchar();
        } while(c == 0);

        switch(c) {
            // t -> set address
            case 't':
                monState = addr;
                n = 1;
                break;
            // s -> show ram-data
            case 's':
                printHex(*memPtr++);
                break;
            // r -> run from address
            case 'r':
                syscontrol = SYSCONTROL_DEFAULT;
                startPrg(memPtr);
                break;
            // p -> print current address
            case 'p':
                printAddr(memPtr);
                break;
            // start console
            case 'g':
                syscontrol = SYSCONTROL_DEFAULT;
                __asm
                    ld sp,#0x0200
                    jp 0xF089
                __endasm;
                break;
            // k -> basic kaltstart
            case 'k':
                startBasic(memPtr);
                break;
            case '\r':
            case '\n':
                iState = none;
                monState = none;
                ihexN = 0;

                putchar(c);
                break;
            // : -> intel hex start
            case ':':
                iState = ihexCount;
                break;
            case 'm': // memtest mit lfsr
                __asm
                    di
                __endasm;
                
                while (1) {
                    memPtr = 0;
                    
                    while ((unsigned int)memPtr < 0x8000) {
    //                    printAddr(memPtr);
                        lfsr15(&lfsrState1);
                        *memPtr++ = lfsrState1;
                    }
                    
                    memPtr = 0;
                    
                    while ((unsigned int)memPtr < 0x8000) {
                        lfsr15(&lfsrState2);
                        if ((unsigned char)*memPtr != (unsigned char)lfsrState2) {
                            printAddr(memPtr);
                            putchar(' ');
                            printHex(*memPtr);
                            putchar(' ');
                            printHex(lfsrState2);
                            putchar('\n');
                        }
                        
                        memPtr++;
                    }
                    
                    printHex((unsigned char)((unsigned int)rounds >> 8));
                    printHex((unsigned char)rounds);
                    rounds++;
                    
                    printStr(" Ok\n");
                }
                break;
            default:
                c = decodeChar(c);
                if(c != 255) {
                    dataVal = (dataVal << 4) + c;
                    if(monState == addr) {
                        // printHex(n);
                        if(n == 2) {
                            memPtr = (unsigned char*)(dataVal * 256);
                        } else if(n == 4) {
                            n = 0;

                            memPtr += dataVal;
                            // printAddr(memPtr);
                            putchar('>');

                            monState = none;

                            if (iState == ihexAddr) {
                                iState = ihexType;
                            }
                        }
                    } else {
                        if(n == 2) {
                            n = 0;

                            switch (iState) {
                                case ihexCount:
                                    putchar('*');
                                    ihexN = dataVal;
                                    monState = addr;
                                    iState = ihexAddr;
                                    break;
                                case ihexType:
                                    iState = ihexData;
                                    if (dataVal > 0) {
                                        iState = ihexSkip;
                                    }
                                    break;
                                case ihexSkip:
                                    putchar(':');
                                    break;
                                case ihexData:
                                    if (ihexN == 0) {
                                        putchar('-');
                                        break;
                                    }
                                    ihexN--;
                                default:
                                    *memPtr++ = dataVal;
                                    putchar('.');
                                    break;
                            }
                        }
                    }
                    n++;
                }
                break;
        }
    }
}
