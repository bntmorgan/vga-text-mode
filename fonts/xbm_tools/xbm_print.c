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

/*
  gcc -O2 -Wall -o xbm_print xbm_print.c

# 1. rebuild C header (razors.ttf/xbm/razors.ttf.h)
# ./genXBMfonts.sh

# 2. use generated XBM fonts, hardcode in xbm_print
# cp razors.ttf/xbm/razors.ttf.h xbm_font.h

# 3. rebuild xbm_tools
# make clean && make


xbm_tools # ./xbm_print mz
109 [m]
*****    *****  
******  ******  
**************  
**** **** ****  
****  **  ****  
****      ****  
*****     ****  
******    ****  
******    ****  
******    ****  
******    ****  
******    ****  
******    ****  
******    ****  
                
                
122 [z]
**************  
**************  
          ****  
          ****  
          ****  
          ****  
  ***********   
 ***********    
*****           
*****           
**************  
**************  
**************  
**************  
                
                

*/

#include <stdio.h>

/* generate with genXBMfonts, https://github.com/masterzorag/xbm_tools */
#include "xbm_font.h"

void xbm_print(const int x, const int y, const char *text, unsigned int *buffer) {
    short i, j, tx = 0;
    char c;

    while(*text != '\0') {
        c = *text;

        if(c < LOWER_ASCII_CODE || c > UPPER_ASCII_CODE) c = 180;
        printf("%d [%c]\n", c, c);

        // font indexing by current char
        char *bit = xbmFont[c - LOWER_ASCII_CODE];

        // dump bits map:
        for(i = 0; i < (FONT_W * FONT_H) / BITS_IN_BYTE; i++) {
            for(j = 0; j < BITS_IN_BYTE; j++) {
            //    printf("%c", (data[i] & (1 << j)) ? ' ' : '0' );  // least significant bit first
            //    printf("%d", (data[i] & (0x80 >> j)) ? 1 : 0);    // right shifting the value will print bits in reverse.                
                if(bit[i] & (1 << j)){        // least significant bit first
                    printf("*");    // paint FG
                } else {
                    printf(" ");    // paint BG pixel
                }
            }
            tx++;

            if(tx == (FONT_W / BITS_IN_BYTE)) {
                tx = 0;
                puts("");
            }
        }

        // glyph painted, move one char right on text
        ++text;
    }
}


int main(int argc, char **argv) {
    if(argv[1]){
        xbm_print(0, 0, argv[1], NULL);
        return 0;
    } else {
        return -1;
    }
}
