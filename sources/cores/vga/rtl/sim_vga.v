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

reg vga_clk;
reg vga_rst;
wire [2:0] vga_red;
wire [2:0] vga_grn;
wire [1:0] vga_blu;
wire vga_hsync;
wire vga_vsync;

always #20.00 vga_clk = !vga_clk; // @25 MHz

initial begin
  vga_clk = 1'b1;
  vga_rst = 1'b0;
end

/* Wishbone Helpers */
task waitvgaclck;
begin
	@(posedge vga_clk);
end
endtask

task waitnvgaclck;
input [15:0] n;
integer i;
begin
	for(i=0;i<n;i=i+1)
		waitvgaclck;
	end
endtask
