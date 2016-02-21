CC = gcc
CFLAGS = -O2 -Wall

all: xbm_dump xbm_print gen_verilog_parameter

gen_verilog_parameter.o: xbm_font.h

gen_verilog_parameter: gen_verilog_parameter.o
	$(CC) $(CFLAGS) $^ -o $@

xbm_dump: xbm_dump.o
	$(CC) $(CFLAGS) xbm_dump.c -o xbm_dump

xbm_print: xbm_print.o
	$(CC) $(CFLAGS) xbm_print.c -o xbm_print

xbm_font.h:
	./genXBMfonts.sh Razor_1911 8 14
	cp Razor_1911/xbm/xbm_font.h xbm_font.h

gen: xbm_dump gen_verilog_parameter
	./gen_verilog_parameter text > text.v
	./gen_verilog_parameter font > font_razor_8_14.v
	cp font_razor_8_14.v text.v ../../sources/cores/vga/rtl

.PHONY: clean
clean:
	rm -rf *o xbm_dump xbm_print gen_verilog_parameter xbm_font.h Razor_1911/xbm
