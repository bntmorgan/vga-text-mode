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

module system (
  // System
  input sys_clk,
  input sys_rst,
  // VGA
  output [2:0] vga_red,
  output [2:0] vga_grn,
  output [1:0] vga_blu,
  output vga_hsync,
  output vga_vsync
);

reg vga_clk0;
reg vga_clk;

task init_sys;
begin
  vga_clk <= 1'b1;
  vga_clk0 <= 1'b1;
end
endtask

// Divide sys_clk @ 100 MHz to 25 MHz

always @(posedge sys_clk) begin
  vga_clk0 <= vga_clk0 + 1'b1;
end

always @(posedge vga_clk0) begin
  vga_clk <= vga_clk + 1'b1;
end

initial begin
  init_sys;
end

vga_top vga (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .vga_clk(vga_clk),
  .vga_rst(sys_rst),
  .vga_red(vga_red),
  .vga_grn(vga_grn),
  .vga_blu(vga_blu),
  .vga_hsync(vga_hsync),
  .vga_vsync(vga_vsync)
);

endmodule
