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

module vga_mem_text (
  // System
  input sys_clk,
  input sys_rst,
  // Memory interface
  input [15:0] sys_dw,
  input [10:0] sys_a,
  input sys_we,
  output [15:0] sys_dr,
  // Memory interface
  input [15:0] vga_dw,
  input [10:0] vga_a,
  input vga_we,
  output [15:0] vga_dr
);

/**
 * Block ram address decoding
 */
reg sys_a_msb;
wire [31:0] sys_dr0 [1:0];
wire sys_we0 [1:0];
assign sys_dr = sys_dr0[sys_a_msb][15:0];
assign sys_we0[0] = sys_we & ~sys_a[10]; // From 0x0 to 0x7ff
assign sys_we0[1] = sys_we & sys_a[10]; // From 0x800 0xfff

reg vga_a_msb;
wire [31:0] vga_dr0 [1:0];
wire vga_we0 [1:0];
assign vga_dr = vga_dr0[vga_a_msb][15:0];
assign vga_we0[0] = vga_we & ~vga_a[10]; // From 0x0 to 0x7ff
assign vga_we0[1] = vga_we & vga_a[10]; // From 0x800 0xfff

task init_sys;
begin
  sys_a_msb <= 1'b0;
  vga_a_msb <= 1'b0;
end
endtask

initial begin
  init_sys;
end

always @(posedge sys_clk) begin
  sys_a_msb <= sys_a[10];
  vga_a_msb <= vga_a[10];
end

/**
 * Block ram generation
 * For addressing see Xilinx ug383 Table 4
 * This ram block is 2048 bytes big see ug383
 * We need 80 * 25 * 2 = 4000 bytes to store the caracters
 * This is why we need two ram blocks
 */
`include "text.v"

genvar ram_index;
generate for (ram_index=0; ram_index < 2; ram_index=ram_index+1)
begin: gen_ram

RAMB16BWER #(
  .DATA_WIDTH_A(18),
  .DATA_WIDTH_B(18),
  .DOA_REG(0),
  .DOB_REG(0),
  .INIT_A(9'h000),
  .INIT_B(9'h000),
  .INIT_00(INIT[(256 * 'h01 - 1 + ram_index * 64 * 256): 256 * 'h00 + ram_index * 64 * 256]),
  .INIT_01(INIT[(256 * 'h02 - 1 + ram_index * 64 * 256): 256 * 'h01 + ram_index * 64 * 256]),
  .INIT_02(INIT[(256 * 'h03 - 1 + ram_index * 64 * 256): 256 * 'h02 + ram_index * 64 * 256]),
  .INIT_03(INIT[(256 * 'h04 - 1 + ram_index * 64 * 256): 256 * 'h03 + ram_index * 64 * 256]),
  .INIT_04(INIT[(256 * 'h05 - 1 + ram_index * 64 * 256): 256 * 'h04 + ram_index * 64 * 256]),
  .INIT_05(INIT[(256 * 'h06 - 1 + ram_index * 64 * 256): 256 * 'h05 + ram_index * 64 * 256]),
  .INIT_06(INIT[(256 * 'h07 - 1 + ram_index * 64 * 256): 256 * 'h06 + ram_index * 64 * 256]),
  .INIT_07(INIT[(256 * 'h08 - 1 + ram_index * 64 * 256): 256 * 'h07 + ram_index * 64 * 256]),
  .INIT_08(INIT[(256 * 'h09 - 1 + ram_index * 64 * 256): 256 * 'h08 + ram_index * 64 * 256]),
  .INIT_09(INIT[(256 * 'h0a - 1 + ram_index * 64 * 256): 256 * 'h09 + ram_index * 64 * 256]),
  .INIT_0A(INIT[(256 * 'h0b - 1 + ram_index * 64 * 256): 256 * 'h0a + ram_index * 64 * 256]),
  .INIT_0B(INIT[(256 * 'h0c - 1 + ram_index * 64 * 256): 256 * 'h0b + ram_index * 64 * 256]),
  .INIT_0C(INIT[(256 * 'h0d - 1 + ram_index * 64 * 256): 256 * 'h0c + ram_index * 64 * 256]),
  .INIT_0D(INIT[(256 * 'h0e - 1 + ram_index * 64 * 256): 256 * 'h0d + ram_index * 64 * 256]),
  .INIT_0E(INIT[(256 * 'h0f - 1 + ram_index * 64 * 256): 256 * 'h0e + ram_index * 64 * 256]),
  .INIT_0F(INIT[(256 * 'h10 - 1 + ram_index * 64 * 256): 256 * 'h0f + ram_index * 64 * 256]),
  .INIT_10(INIT[(256 * 'h11 - 1 + ram_index * 64 * 256): 256 * 'h10 + ram_index * 64 * 256]),
  .INIT_11(INIT[(256 * 'h12 - 1 + ram_index * 64 * 256): 256 * 'h11 + ram_index * 64 * 256]),
  .INIT_12(INIT[(256 * 'h13 - 1 + ram_index * 64 * 256): 256 * 'h12 + ram_index * 64 * 256]),
  .INIT_13(INIT[(256 * 'h14 - 1 + ram_index * 64 * 256): 256 * 'h13 + ram_index * 64 * 256]),
  .INIT_14(INIT[(256 * 'h15 - 1 + ram_index * 64 * 256): 256 * 'h14 + ram_index * 64 * 256]),
  .INIT_15(INIT[(256 * 'h16 - 1 + ram_index * 64 * 256): 256 * 'h15 + ram_index * 64 * 256]),
  .INIT_16(INIT[(256 * 'h17 - 1 + ram_index * 64 * 256): 256 * 'h16 + ram_index * 64 * 256]),
  .INIT_17(INIT[(256 * 'h18 - 1 + ram_index * 64 * 256): 256 * 'h17 + ram_index * 64 * 256]),
  .INIT_18(INIT[(256 * 'h19 - 1 + ram_index * 64 * 256): 256 * 'h18 + ram_index * 64 * 256]),
  .INIT_19(INIT[(256 * 'h1a - 1 + ram_index * 64 * 256): 256 * 'h19 + ram_index * 64 * 256]),
  .INIT_1A(INIT[(256 * 'h1b - 1 + ram_index * 64 * 256): 256 * 'h1a + ram_index * 64 * 256]),
  .INIT_1B(INIT[(256 * 'h1c - 1 + ram_index * 64 * 256): 256 * 'h1b + ram_index * 64 * 256]),
  .INIT_1C(INIT[(256 * 'h1d - 1 + ram_index * 64 * 256): 256 * 'h1c + ram_index * 64 * 256]),
  .INIT_1D(INIT[(256 * 'h1e - 1 + ram_index * 64 * 256): 256 * 'h1d + ram_index * 64 * 256]),
  .INIT_1E(INIT[(256 * 'h1f - 1 + ram_index * 64 * 256): 256 * 'h1e + ram_index * 64 * 256]),
  .INIT_1F(INIT[(256 * 'h20 - 1 + ram_index * 64 * 256): 256 * 'h1f + ram_index * 64 * 256]),
  .INIT_20(INIT[(256 * 'h21 - 1 + ram_index * 64 * 256): 256 * 'h20 + ram_index * 64 * 256]),
  .INIT_21(INIT[(256 * 'h22 - 1 + ram_index * 64 * 256): 256 * 'h21 + ram_index * 64 * 256]),
  .INIT_22(INIT[(256 * 'h23 - 1 + ram_index * 64 * 256): 256 * 'h22 + ram_index * 64 * 256]),
  .INIT_23(INIT[(256 * 'h24 - 1 + ram_index * 64 * 256): 256 * 'h23 + ram_index * 64 * 256]),
  .INIT_24(INIT[(256 * 'h25 - 1 + ram_index * 64 * 256): 256 * 'h24 + ram_index * 64 * 256]),
  .INIT_25(INIT[(256 * 'h26 - 1 + ram_index * 64 * 256): 256 * 'h25 + ram_index * 64 * 256]),
  .INIT_26(INIT[(256 * 'h27 - 1 + ram_index * 64 * 256): 256 * 'h26 + ram_index * 64 * 256]),
  .INIT_27(INIT[(256 * 'h28 - 1 + ram_index * 64 * 256): 256 * 'h27 + ram_index * 64 * 256]),
  .INIT_28(INIT[(256 * 'h29 - 1 + ram_index * 64 * 256): 256 * 'h28 + ram_index * 64 * 256]),
  .INIT_29(INIT[(256 * 'h2a - 1 + ram_index * 64 * 256): 256 * 'h29 + ram_index * 64 * 256]),
  .INIT_2A(INIT[(256 * 'h2b - 1 + ram_index * 64 * 256): 256 * 'h2a + ram_index * 64 * 256]),
  .INIT_2B(INIT[(256 * 'h2c - 1 + ram_index * 64 * 256): 256 * 'h2b + ram_index * 64 * 256]),
  .INIT_2C(INIT[(256 * 'h2d - 1 + ram_index * 64 * 256): 256 * 'h2c + ram_index * 64 * 256]),
  .INIT_2D(INIT[(256 * 'h2e - 1 + ram_index * 64 * 256): 256 * 'h2d + ram_index * 64 * 256]),
  .INIT_2E(INIT[(256 * 'h2f - 1 + ram_index * 64 * 256): 256 * 'h2e + ram_index * 64 * 256]),
  .INIT_2F(INIT[(256 * 'h30 - 1 + ram_index * 64 * 256): 256 * 'h2f + ram_index * 64 * 256]),
  .INIT_30(INIT[(256 * 'h31 - 1 + ram_index * 64 * 256): 256 * 'h30 + ram_index * 64 * 256]),
  .INIT_31(INIT[(256 * 'h32 - 1 + ram_index * 64 * 256): 256 * 'h31 + ram_index * 64 * 256]),
  .INIT_32(INIT[(256 * 'h33 - 1 + ram_index * 64 * 256): 256 * 'h32 + ram_index * 64 * 256]),
  .INIT_33(INIT[(256 * 'h34 - 1 + ram_index * 64 * 256): 256 * 'h33 + ram_index * 64 * 256]),
  .INIT_34(INIT[(256 * 'h35 - 1 + ram_index * 64 * 256): 256 * 'h34 + ram_index * 64 * 256]),
  .INIT_35(INIT[(256 * 'h36 - 1 + ram_index * 64 * 256): 256 * 'h35 + ram_index * 64 * 256]),
  .INIT_36(INIT[(256 * 'h37 - 1 + ram_index * 64 * 256): 256 * 'h36 + ram_index * 64 * 256]),
  .INIT_37(INIT[(256 * 'h38 - 1 + ram_index * 64 * 256): 256 * 'h37 + ram_index * 64 * 256]),
  .INIT_38(INIT[(256 * 'h39 - 1 + ram_index * 64 * 256): 256 * 'h38 + ram_index * 64 * 256]),
  .INIT_39(INIT[(256 * 'h3a - 1 + ram_index * 64 * 256): 256 * 'h39 + ram_index * 64 * 256]),
  .INIT_3A(INIT[(256 * 'h3b - 1 + ram_index * 64 * 256): 256 * 'h3a + ram_index * 64 * 256]),
  .INIT_3B(INIT[(256 * 'h3c - 1 + ram_index * 64 * 256): 256 * 'h3b + ram_index * 64 * 256]),
  .INIT_3C(INIT[(256 * 'h3d - 1 + ram_index * 64 * 256): 256 * 'h3c + ram_index * 64 * 256]),
  .INIT_3D(INIT[(256 * 'h3e - 1 + ram_index * 64 * 256): 256 * 'h3d + ram_index * 64 * 256]),
  .INIT_3E(INIT[(256 * 'h3f - 1 + ram_index * 64 * 256): 256 * 'h3e + ram_index * 64 * 256]),
  .INIT_3F(INIT[(256 * 'h40 - 1 + ram_index * 64 * 256): 256 * 'h3f + ram_index * 64 * 256]),
  .WRITE_MODE_A("WRITE_FIRST"),
  .WRITE_MODE_B("WRITE_FIRST")
) mem (
  // Processor interface
  .CLKA(sys_clk),
  .ENA(1'b1),
  .WEA({2'b0, sys_we0[ram_index], sys_we0[ram_index]}),
  .RSTA(sys_rst),
  .ADDRA({sys_a[9:0],4'b0}), // 8 bits addressed
  .DIPA(4'b0),
  .DIA({16'b0, sys_dw}),
  .DOA(sys_dr0[ram_index]),
  .DOPA(),

  // VGA video interface
  .CLKB(sys_clk),
  .ENB(1'b1),
  .WEB({3'b0, vga_we0[ram_index]}),
  .RSTB(sys_rst),
  .ADDRB({vga_a[9:0],4'b0}), // 8 bits addressed
  .DIPB(4'b0),
  .DIB({16'b0, vga_dw}),
  .DOB(vga_dr0[ram_index]),
  .DOPB(),

  .REGCEA(1'b0),
  .REGCEB(1'b0)
);
end
endgenerate

endmodule
