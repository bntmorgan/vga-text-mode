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

/**
 * Get the color of a pixel on the 640x350 screen, 80x25 text mode, using the
 * font size is 8×14
 * text memory and the font bitmap memory
 */
module vga_text_mode (
  // System
  input sys_clk,
  input sys_rst,
  // Pixel interface
  input [6:0] pa,
  input [10:0] ca,
  output [7:0] p,
  // Text memory interface
  output [15:0] text_dw,
  output /*reg*/ [10:0] text_a,
  output text_we,
  input [15:0] text_dr,
  // Font memory interface
  output [7:0] font_dw,
  output /*reg*/ [12:0] font_a,
  output font_we,
  input [7:0] font_dr
);

// default write wires
assign text_we = 1'b0;
assign text_dw = 8'b0;
assign font_we = 1'b0;
assign font_dw = 16'b0;

assign text_a = ca;

assign font_a = (text_dr[7:0] * 13'd14) + (pa >> 3);

// Assign pixel color
assign p = ((font_dr >> (pa & 7)) & 1) ? 8'hff : 8'h00;

endmodule 
