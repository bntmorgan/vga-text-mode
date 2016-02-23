# Copyright (C) 2015  Benoît Morgan
#
# This file is part of vga-text-mode.
#
# vga-text-mode is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# vga-text-mode is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with vga-text-mode.  If not, see <http://www.gnu.org/licenses/>.

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
