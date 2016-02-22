/*
Copyright (C) 2015  Benoît Morgan

This file is part of vga-text-mode.

vga-text-mode is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

vga-text-mode is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with vga-text-mode.  If not, see <http://www.gnu.org/licenses/>.
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

reg [25:0] bc;
reg beo;

reg [7:0] colors [15:0];

wire pixel;
wire [7:0] color_fg;
wire [7:0] color_bg;
wire blink;

task init_sys;
begin
  bc <= 26'b0;
  beo <= 1'b0;
  /** Init color palette
   * 32-bit RGB to 8-bit color
   * print(hex(int((r*6/256)*36 + (g*6/256)*6 + (b*6/256))))
   * http://wiki.osdev.org/Text_UI
   */
  colors[0] <= 8'h00; // Black
  colors[1] <= 8'h03; // Blue
  colors[2] <= 8'h17; // Green
  colors[3] <= 8'h1b; // Cyan
  colors[4] <= 8'h8f; // Red
  colors[5] <= 8'h93; // Magenta
  colors[6] <= 8'h9b; // Brown
  colors[7] <= 8'haa; // Light gray
  colors[8] <= 8'h55; // Dark gray
  colors[9] <= 8'h59; // Light blue
  colors[10] <= 8'h6d; // Light green
  colors[11] <= 8'h71; // Light cyan
  colors[12] <= 8'he5; // Light red
  colors[13] <= 8'he9; // Light magenta
  colors[14] <= 8'hfc; // Yellow
  colors[15] <= 8'hff; // White
end
endtask

initial begin
  init_sys;
end

// Blink counter
always @(posedge sys_clk) begin
  if (sys_rst) begin
    init_sys;
  end else begin
    if (bc < 49999999) begin
      bc <= bc + 1'b1;
    end else begin
      bc <= 26'b0;
      beo <= (beo) ? 1'b0 : 1'b1;
    end
  end
end

// default write wires
assign text_we = 1'b0;
assign text_dw = 8'b0;
assign font_we = 1'b0;
assign font_dw = 16'b0;

assign text_a = ca;

assign font_a = (text_dr[7:0] * 13'd14) + (pa >> 3);

// Colors
assign color_fg = colors[text_dr[11:8]];
assign color_bg = colors[text_dr[14:12]];
assign blink = text_dr[15];

// Pixel present : display foreground color or background color
assign pixel = ((font_dr >> (pa & 7)) & 1);

// Assign the computed color
// assign p = (pixel & ~(blink & beo)) ? color_fg : color_bg;
assign p = (pixel & ~(blink & beo)) ? color_fg : color_bg;

endmodule
