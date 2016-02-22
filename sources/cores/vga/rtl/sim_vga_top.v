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

`timescale 1ns/10ps

module main();

`include "sim.v"
`include "sim_vga.v"

// Inputs
reg [7:0] mem_dw;
reg [11:0] mem_a;
reg mem_we;

// Outputs
wire [7:0] mem_dr;

initial begin
  mem_dw <= 8'b0;
  mem_a <= 12'b0;
  mem_we <= 1'b0;
end

/**
 * Tested component
 */
vga_top vga (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .vga_clk(vga_clk),
  .vga_rst(vga_rst),
  .vga_red(vga_red),
  .vga_grn(vga_grn),
  .vga_blu(vga_blu),
  .vga_hsync(vga_hsync),
  .vga_vsync(vga_vsync),
  .mem_dw(mem_dw),
  .mem_a(mem_a),
  .mem_we(mem_we),
  .mem_dr(mem_dr)
);

task read;
input [11:0] a;
begin
  mem_we <= 1'b0;
  mem_a <= a;
  mem_dw <= 8'h00;
  waitclock;
end
endtask

task write;
input [11:0] a;
input [7:0] d;
begin
  mem_we <= 1'b1;
  mem_a <= a;
  mem_dw <= d;
  waitclock;
end
endtask

integer i;
initial begin
  for (i = 0; i < 'h7ff; i = i + 1)
  begin
    $dumpvars(0,vga.mem_font.gen_ram[0].mem.mem[i]);
  end
  for (i = 0; i < 'h7ff; i = i + 1)
  begin
    $dumpvars(0,vga.mem_font.gen_ram[1].mem.mem[i]);
  end
  for (i = 0; i < 'h7ff; i = i + 1)
  begin
    $dumpvars(0,vga.mem_font.gen_ram[2].mem.mem[i]);
  end
  for (i = 0; i < 'h7ff; i = i + 1)
  begin
    $dumpvars(0,vga.mem_font.gen_ram[3].mem.mem[i]);
  end

  for (i = 0; i < 'h3ff; i = i + 1)
  begin
    $dumpvars(0,vga.mem_text.gen_ram[0].mem.mem[i]);
  end
  for (i = 0; i < 'h3ff; i = i + 1)
  begin
    $dumpvars(0,vga.mem_text.gen_ram[1].mem.mem[i]);
  end

  // Reset
  sys_rst <= 1'b1;
  vga_rst <= 1'b1;
  waitnclock(8);
  sys_rst <= 1'b0;
  vga_rst <= 1'b0;
  waitnclock(1);

//  // Write
//  write(0, 0);
//  // Write
//  write(1, 1);
//  // Write
//  write(2, 2);
//  // Write
//  write(3, 3);
//  // Write
//  write(4, 4);
//  // Write
//  write('h800, 'hff);
//
//  // Read
//  read(0);
//  // Read
//  read(1);
//  // Read
//  read(2);
//  // Read
//  read(3);
//  // Read
//  read('h800);

  waitnvgaclck(1600);
  #2500000;

  $finish();
end

endmodule
