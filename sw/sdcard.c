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
#include <string.h>

#include "pff/pff.h"
#include "uart/uart.h"
#include "kc/kc87.h"

#define MENU_SIZE 14
#define BUFF_SIZE 129
#define INFO_LINE 16

char* hello = "*** SDCard V0.001 ***\n";

char * memPtr = 0;

FATFS Fatfs; /* Petit-FatFs work area */
DIR dir;

typedef struct {
    char entryName[15];
    unsigned char isDir;
} menuEntry;
menuEntry menuEntries[MENU_SIZE];

unsigned char buff[BUFF_SIZE];
char path[120];

unsigned int loadAdr = 0;
unsigned char* loadPtr;
unsigned int endAdr = 0;
unsigned int startAdr = 0;
unsigned char intName[9];
enum fileTypeEnum {
    none, basic, mc
};
unsigned char fileType;

// crc-16 berechnen
void crc16(int * crc, unsigned char data) {
    char i;
    int tmpCrc = *crc ^ data;

    for (i = 0; i < 0; ++i) {
        if ((tmpCrc & 1) != 0) {
            tmpCrc = (tmpCrc >> 1) ^ 0xA001; // IBM CRC16
        } else {
            tmpCrc >>= 1;
        }
    }

    *crc = tmpCrc;
}

// binärfile laden
unsigned char loadFile(char *fname, void* target, unsigned int size) {
    unsigned char res;
    unsigned int fsize;

    res = pf_open(fname);

    if (res == FR_OK) {
        res = pf_read(target, size, &fsize);

        if (fsize != size) {
            res = FR_DISK_ERR;
        }
    }

    return res;
}

// tap-file laden
unsigned char loadTapFile(char *fname, char infoOnly) {
    unsigned char res, i;
    unsigned int fsize;

    loadAdr = 0;
    startAdr = 0;
    endAdr = 0;
    intName[0] = '\0';
    fileType = none;

    res = pf_open(fname);

    // datei gefunden - öffnen
    if (res == FR_OK) {
        res = pf_read(buff, 16, &fsize);

        if (res == FR_OK) { // header ok?
            res = strncmp((char*) buff, "\xc3KC-TAPE by AF. ", 16);

            if (res == 0) { // ersten block lesen
                res = pf_read(buff, BUFF_SIZE, &fsize);

                if (res == FR_OK || fsize != BUFF_SIZE) {

                    // basic?
                    if (buff[0] == 1 && buff[1] == 0xd3 && buff[2] == 0xd3
                            && buff[3] == 0xd3) { 
                        printStr("Basic\n");
                        fileType = basic;

                        for (i = 0; i < 8; i++) {
                            intName[i] = buff[4 + i];
                        }
                        intName[i] = '\0';
                        printStr(intName);

                        putchar('\n');
                        loadAdr = 0x0401;
                        loadPtr = (unsigned char*) loadAdr;

                        endAdr = (buff[13] << 8 | buff[12]) + loadAdr;

                        printStr("\nLadeadresse: ");
                        printHexUInt(loadAdr);

                        printStr("\nEndadresse: ");
                        printHexUInt(endAdr);
                        putchar('\n');

                        if (!infoOnly) {
                            printStr("copy 14-128: ");
                            printHexUInt((unsigned int) loadPtr);
                            memcpy(loadPtr, &buff[14], 128 - 13);
                        }

                        putchar('\n');

                        loadPtr += 128 - 13;

                    } else if (buff[0] == 0) { // oder kc87 mc programm?
                        printStr("System\n");
                        fileType = mc;

                        for (i = 0; i < 8; i++) {
                            intName[i] = buff[1 + i];
                        }
                        intName[i] = '\0';
                        printStr(intName);

                        putchar('\n');

                        for (i = 0; i < 3; ++i) {
                            putchar(buff[9 + i]);
                        }
                        putchar('\n');

                        loadAdr = buff[19] << 8 | buff[18];
                        loadPtr = (unsigned char*) loadAdr;
                        endAdr = (buff[21] << 8 | buff[20]);
                        startAdr = buff[23] << 8 | buff[22];

                        printStr("\nLadeadresse: ");
                        printHexUInt(loadAdr);

                        printStr("\nEndadresse: ");
                        printHexUInt(endAdr);

                        printStr("\nStartadresse: ");
                        printHexUInt(startAdr);
                    }
                }
            }

            putchar('\n');

            // ausgabebereich löschen
            for (i = INFO_LINE; i < 23; ++i) {
                kcSetLine(i);
                kcClearLine();
            }

            kcSetLine(INFO_LINE);

            if (endAdr == 0) { // keine datei
                printStr("\nFehler! Kein Tap-File!\n");
                kcPrint("\nFehler! Kein Tap-File!\n");
            } else { // dateiinformationen ausgeben
                kcPrint(intName);

                if (fileType == basic) {
                    kcPrint("\tBasic");
                }

                if (fileType == mc) {
                    kcPrint("\tSystem");
                }

                kcPrint("\n");

                kcPrint("\nLadeadresse: ");
                kcPrintUInt(loadAdr);

                kcPrint("\nEndadresse: ");
                kcPrintUInt(endAdr);

                kcPrint("\nStartadresse: ");
                kcPrintUInt(startAdr);

                if (!infoOnly) { // datei wirklich laden
                    kcPrint("\n\nLade: ");

                    while (buff[0] != 255) {
                        res = pf_read(buff, BUFF_SIZE, &fsize);

                        if (fsize != BUFF_SIZE || res != FR_OK) {
                            break;
                        }

                        printStr("copy 1-129: ");
                        printHexUInt((unsigned int) loadPtr);
                        kcPrintUInt((unsigned int) loadPtr);
                        memcpy(loadPtr, &buff[1], BUFF_SIZE - 1);

                        putchar('\n');

                        loadPtr += 128;
                    }
                }
            }
        }
    }

    putchar('\n');
    printHex(res);
    putchar('\n');

    return res;
}

// verzeichnis einlesen
unsigned char dirForward() {
    unsigned char i;
    unsigned char maxSize = 0;
    FILINFO finfo;
    kcSetLine(1);

    // MENU_SIZE verzeichniseinträge einlesen und darstellen
    for (i = 0; i < MENU_SIZE; i++) {
        menuEntries[i].entryName[0] = '\0';
        menuEntries[i].isDir = 0;
        kcClearLine();

        if (pf_readdir(&dir, &finfo) == FR_OK && finfo.fname[0] != 0) {
            maxSize = i;
            strcpy(menuEntries[i].entryName, finfo.fname);
            kcPrint(finfo.fname);
            printStr(finfo.fname);
            printStr("\n");
            if (finfo.fattrib & AM_DIR) {
                menuEntries[i].isDir = 1;
                kcPrint("\t<DIR>");
            }
        }

        kcPrint("\n");
    }

    return maxSize;
}

// verzeichnisreinträge zurückspulen
void dirRewind(unsigned char menuPage) {
    unsigned char i;
    unsigned char j = 0;
    FILINFO finfo;

    // verzeichnis zurücksetzen
    pf_opendir(&dir, path);

    // und einträge überspringen
    while (j++ < menuPage) {
        for (i = 0; i < MENU_SIZE; i++) {
            pf_readdir(&dir, &finfo);
        }
    }
}

void loadRoms() {
    unsigned char res;

    printStr("Lade Basic:\n");
    kcPrint("Lade Basic:\n");
    kcPrint("/ROMS/BASIC_C0.87B");

    res = loadFile("/ROMS/BASIC_C0.87B", (void*) 0xC000, 10240);

    if (res) {
        printStr("\nFehler!\n");
        kcPrint("\nFehler!\n");
    } else {
        printStr("\nOk!\n");
        kcPrint("\nOk!\n");
    }
    
    printStr("Lade OS:\n");
    kcPrint("Lade OS:\n");
    kcPrint("/ROMS/OS____F0.87B");
    res = loadFile("/ROMS/OS____F0.87B", (void*) 0xF000, 4096);

    if (res) {
        printStr("\nFehler!\n");
        kcPrint("\nFehler!\n");
    } else {
        printStr("\nOk!\n");
        kcPrint("\nOk!\n");
        coldBoot();
    }
}

void main(void) {
    char c;
    unsigned char res;
    char i;

    unsigned char menuPage = 0;
    unsigned char menuCursor = 1;
    unsigned char menuMaxCursor = 0;

    // memset(0,0,0x7000);
    kcCls();

    kcColorBar(21);
    kcPrint(hello);
    printStr(hello);

    // sdkarte mounten
    res = pf_mount(&Fatfs);
    if (res == FR_OK) {
        printStr("FS gemountet\n");
        kcPrint("FS gemountet\n");
    } else {
        printStr("FS Fehler: ");
        printHex(res);
        putchar('\n');
    }

    // reset gedrückt?
    printStr("Syscontrol: ");
    printHex(syscontrol);
    putchar('\n\n');
    
    if (syscontrol == 0) { // reset wurde gedrückt -> roms laden
        syscontrol = SYSCONTROL_TURBO;
        // Roms laden+reboot
        loadRoms();
    }
    syscontrol = SYSCONTROL_TURBO;

    path[0] = '\0';

            
    kcSetLine(INFO_LINE);
        

    // verzeichnis öffnen und einträge einlesen
    res = pf_opendir(&dir, path);
    if (res == FR_OK) {
        kcSetLine(menuCursor);
        kcColorBar(12);
        menuMaxCursor = dirForward();
    } else {
        kcPrint("\nSDCard konnte nicht geoeffnet werden!\n");
        printHex(res);
        while(1);
    }

    // kurze beschreibung
    kcPrint("\n* Cursortasten: Navigation\n* Enter: Auswahl\n* Space: Information");
    kcPrint("\n* Backspace: Verzeichnis hoch\n* Esc: verlassen\n* B: Basic-Programm starten\n");
        
//    memPtr = (char*) &memPtr;
    while (1) {
        // c = readchar();
        c = readKey();
        if (c) { // taste gedrückt?
            i = 0;
            kcSetLine(menuCursor);
            kcClearColorBar(12);

            switch (c) {
            case 0x1b: // esc -> os prompt
                kcCls();
                warmBoot();
                break;
            case 0x0a: // cursor hoch
                // case 'B':
                if (menuCursor < MENU_SIZE) {
                    if (menuCursor <= menuMaxCursor) {
                        menuCursor++;
                    }
                } else {
                    menuMaxCursor = dirForward();
                    menuCursor = 1;
                    menuPage++;
                }

                break;
            case 0x0b: // cursor nach unten
                // case 'A':
                if (menuCursor > 1) {
                    menuCursor--;
                } else {
                    if (menuPage > 0) {
                        menuCursor = MENU_SIZE;
                        menuPage--;
                        dirRewind(menuPage);
                        menuMaxCursor = dirForward();
                    }
                }
                break;
            case 'B':
            case 'b':   // Basicprogramm starten
                printStr("\nstarte Basic: ");
                printHexUInt(endAdr);
                putchar('\n');
                startBasic((unsigned char*) endAdr);
                break;
            case ' ':   // dateiinformationen anzeigen
                i = 1;
            case '\r':  // laden / Verzeichnis wechseln
                buff[0] = '\0';
                strcat(buff, path);
                strcat(buff, "/");
                strcat(buff, menuEntries[menuCursor - 1].entryName);
                printStr(buff);
                putchar('\n');

                if (menuEntries[menuCursor - 1].isDir) { // verzeichnis?
                    printStr("CD\n");
                    strcpy(path, buff);
                    printStr(path);

                    menuPage = 0;
                    menuCursor = 1;
                    dirRewind(menuPage);
                    menuMaxCursor = dirForward();
                } else { // datei laden
                    loadTapFile(buff, i);
                }
                break;
            case 0x1f: // backspace -> Verzeichnis hoch
                for (i = strlen(path); i >= 0; i--) {
                    if (path[i] == '/') {
                        path[i] = '\0';
                        break;
                    }
                    path[i] = '\0';
                }
                printStr("CD Up: ");
                printStr(path);
                putchar('\n');

                menuPage = 0;
                menuCursor = 1;
                dirRewind(menuPage);
                menuMaxCursor = dirForward();

                break;
            case 'D':
            case 'd':
                loadPtr = (unsigned char*) loadAdr;

                while (loadPtr < (unsigned char*) endAdr) {
                    printHexUInt((unsigned int) loadPtr);
                    putchar(' ');
                    for (i = 0; i < 16; i++) {
                        printHex(*(loadPtr++));
                    }
                    putchar('\n');
                }
                break;
            case 'R':
            case 'r':
                kcCls();
                loadRoms();
                break;
            default:
                // putchar(c);
                // putchar('\n');
                printHex(c);
                putchar('\n');
            }

            kcSetLine(menuCursor);
            kcColorBar(12);
        }
    }
}
