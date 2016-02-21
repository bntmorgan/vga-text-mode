/*
Copyright (C) 2015  Benoît Morgan

This file is part of vga-text-mode.

L2 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

L2 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with L2.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <string.h>

#include "xbm_font.h"

void print_font(void) {
  int i;
  printf("parameter [65535:0] INIT = {");
  for (i = 8191; i >= 0; i--) {
    if (i >= LOWER_ASCII_CODE * 14 && i < (UPPER_ASCII_CODE + 1) * 14) {
      printf("8'h%02x", (unsigned char) xbmFont[i / 14 - 32][i % 14]);
    } else {
      printf("8'h00");
    }
    if (i > 0) {
      printf(",\n");
    }
  }
  printf("};");
}

const char gilles[] = {
  'H',
  'e',
  'l',
  'l',
  'o',
  ' ',
  'W',
  'o',
  'r',
  'l',
  'd',
  ' ',
  '!',
  ' '
};

void print_text(void) {
  int i, j = sizeof(gilles) - 1;
  printf("parameter [32767:0] INIT = {");
  for (i = 4095; i >= 0; i--) {
    if (i % 2) {
      printf("8'h00");
    } else {
      printf("8'h%02x", gilles[j]);
      if (j >= 0) {
        j--;
      } else {
        j = sizeof(gilles) - 1;
      }
    }
    if (i > 0) {
      printf(",\n");
    }
  }
  printf("};");
}

int main (int argc, char *argv[]) {
  if (argc < 2) {
    printf("gen text|font\n");
    return 1;
  }
  if (!strcmp(argv[1], "font")) {
    print_font();
  }
  if (!strcmp(argv[1], "text")) {
    print_text();
  }
  return 0;
}
