# sdcc.exe -mz80 --opt-code-size -Id:\prog\SDCC\include -c monitor.c -o obj\Release\monitor.rel
# sdcc.exe -o SDCC-Test.ihx -mz80 --opt-code-size --data-loc 0xF800 obj\Release\monitor.rel
# yazd.exe -html -lst -xref test.bin>test.html

BOOTLOADER_HEAD=0x8000
BOOTLOADER_CODE=0x8020

CC     =sdcc
OBJCOPY=avr-objcopy
PACKER =zx7
ASM    =z80asm

CFLAGS =-mz80 --opt-code-size --max-allocs-per-node 100000 --std-sdcc99
# LDFLAGS=--data-loc 0x7000 --no-std-crt0
LDFLAGS=--data-loc 0xB000 --no-std-crt0 -Wl-b_HEADER=${BOOTLOADER_HEAD} -Wl-b_CODE=${BOOTLOADER_CODE}

SOURCE   =monitor.c uart/uart.c kc/kc87.c
SOURCESD =sdcard.c uart/uart.c kc/kc87.c pff/hardware.c pff/mmcbbp.c pff/pff.c
OBJECTS  =obj/crt0_mon.rel $(patsubst %.c,obj/%.rel,$(SOURCE))
OBJECTSSD=obj/crt0_sd.rel $(patsubst %.c,obj/%.rel,$(SOURCESD))
HEX    =monitor.ihx
HEXSD  =sdcard.ihx
BIN    =$(HEX:.ihx=.bin)
BINSD  =$(HEXSD:.ihx=.bin)
PORT   =COM1

all: $(OBJECTS) $(HEX) $(HEXSD)

obj/%.rel: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(HEX): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(HEX) $(OBJECTS)

$(HEXSD): $(OBJECTSSD)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(HEXSD) $(OBJECTSSD)

dis:
	$(OBJCOPY) --input-target=ihex --output-target=binary $(HEX) $(BIN)
	yazd.exe -html -lst --addr:${BOOTLOADER_HEAD} -xref $(BIN)>dis.html
	$(OBJCOPY) --input-target=ihex --output-target=binary $(HEXSD) $(BINSD)
	yazd.exe -html -lst --addr:${BOOTLOADER_HEAD} -xref $(BIN)>dissd.html

upload:
# updload hex
	more $(HEX) >$(PORT)
# reset
	echo r >$(PORT)

sdrom: $(HEXSD)
	$(OBJCOPY) --input-target=ihex --output-target=binary $(HEXSD) $(BINSD)
	rm -f $(BINSD).zx7
	$(PACKER) $(BINSD)
	$(ASM) asm/bootloader_sdcard.asm -o bootloader_sdcard.bin
	tclsh bin2vhdl.tcl bootloader_sdcard.bin monitor >../rtl/roms/bootloader_sdcard.vhd

monrom: $(HEX)
	$(OBJCOPY) --input-target=ihex --output-target=binary $(HEX) $(BIN)
	rm -f $(BIN).zx7
	$(PACKER) $(BIN)
	$(ASM) asm/bootloader_mon.asm -o bootloader_mon.bin
	tclsh bin2vhdl.tcl bootloader_mon.bin monitor >../rtl/roms/bootloader.vhdl
    
vhdl:
	tclsh ihx2vhdl.tcl monitor <monitor.ihx >../rtl/roms/monitor.vhd
	tclsh ihx2vhdl.tcl bootrom <sdcard.ihx >../rtl/roms/bootloader_sdcard.vhd

obj/crt0_mon.rel: crt/crt0_mon.s
	sdasz80 -plogff $@ $<

obj/crt0_sd.rel: crt/crt0_sd.s
	sdasz80 -plogff $@ $<

clean:
	rm -f *.lk
	rm -f *.map
	rm -f *.noi
	rm -f *.ihx
	rm -f *.zx7
	rm -f *.bin
	rm -f obj/*.*
	rm -f obj/pff/*.*
	rm -f obj/uart/*.*
	rm -f obj/kc/*.*