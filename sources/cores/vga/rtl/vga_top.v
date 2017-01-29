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
 * VGA compatible text mode
 * https://en.wikipedia.org/wiki/VGA-compatible_text_mode
 * https://eewiki.net/pages/viewpage.action?pageId=15925278
 *
 * Generate fonts
 * convert -resize 7x13\! -font FreeMono -pointsize 10 label:A A.xbm
 *
 * Only supported mode 80x25 VGA compatible text mode
 */

module vga_top (
  // System
  input sys_clk,
  input sys_rst,
  // VGA
  input vga_clk,
  input vga_rst,
  output [2:0] vga_red,
  output [2:0] vga_grn,
  output [1:0] vga_blu,
  output vga_hsync,
  output vga_vsync,
  // Memory interface
  input [15:0] mem_dw,
  input [10:0] mem_a,
  input mem_we,
  output [15:0] mem_dr
);

wire [6:0] pa;
wire [10:0] ca;
wire [7:0] p;
wire [15:0] text_dw;
wire [10:0] text_a;
wire text_we;
wire [15:0] text_dr;
wire [7:0] font_dw;
wire [12:0] font_a;
wire font_we;
wire [7:0] font_dr;

// VGA video controller
vga_video video (
  .vga_clk(vga_clk),
  .vga_rst(vga_rst),
  .vga_red(vga_red),
  .vga_grn(vga_grn),
  .vga_blu(vga_blu),
  .vga_hsync(vga_hsync),
  .vga_vsync(vga_vsync),
  .pa(pa),
  .ca(ca),
  .p(p)
);

// VGA compatible mode text memory
vga_mem_text mem_text (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .sys_dw(mem_dw),
  .sys_a(mem_a),
  .sys_we(mem_we),
  .sys_dr(mem_dr),
  .vga_dw(text_dw),
  .vga_a(text_a),
  .vga_we(text_we),
  .vga_dr(text_dr)
);

// 256 Caracters font 8x14 binary color
vga_mem_font mem_font (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .vga_dw(font_dw),
  .vga_a(font_a),
  .vga_we(font_we),
  .vga_dr(font_dr)
);

// VGA text mode logic
vga_text_mode text_mode (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .pa(pa),
  .ca(ca),
  .p(p),
  .text_dw(text_dw),
  .text_a(text_a),
  .text_we(text_we),
  .text_dr(text_dr),
  .font_dw(font_dw),
  .font_a(font_a),
  .font_we(font_we),
  .font_dr(font_dr)
);

endmodule
