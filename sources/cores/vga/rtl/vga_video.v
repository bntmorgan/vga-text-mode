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
 * Video mode VGA 640x350
 * Font size is 8×14
 * vga_clk @ 25MHz
 * http://www.javiervalcarce.eu/html/vga-signal-format-timming-specs-en.html
 */
module vga_video (
  // VGA interface
  input vga_clk,
  input vga_rst,
  output reg [2:0] vga_red,
  output reg [2:0] vga_grn,
  output reg [1:0] vga_blu,
  output vga_hsync,
  output vga_vsync,
  // Pixel interface
  output [6:0] pa,
  output [10:0] ca,
  input [7:0] p
);

reg [9:0] hc;
reg [9:0] vc;

// Caracter counters
reg [6:0] cx;
reg [4:0] cy;

// Pixel counters
reg [9:0] lx;
reg [2:0] px;
reg [3:0] py;

task init_vga;
begin
  hc <= 10'b0;
  vc <= 10'b0;
  cx <= 7'b0;
  cy <= 5'b0;
  px <= 3'b0;
  py <= 4'b0;
  lx <= 10'b0;
  vga_red <= 3'b000;
  vga_grn <= 3'b000;
  vga_blu <= 2'b00;
end
endtask

initial begin
  init_vga;
end

/**
 * Horizontal & vertical counters
 * cf. Nexys3_rm p17
 * see http://embdev.net/topic/296862
 */
always @(posedge vga_clk) begin
  if (vga_rst) begin
    init_vga;
  end else begin
    // Counters
    if (hc < 10'h31f) begin
      hc <= hc + 1'b1; // Increment pixels
    end else begin
      hc <= 10'b0;
      if (vc < 10'h1c0) begin
        vc <= vc + 1'b1; // Increment lines
      end else begin
        vc <= 10'b0;
      end
    end
    // Pixel and carater counters
    if (vc >= 10'h3e && vc < 10'h19c) begin
      // On commence un coup avant pour ne pas oublier la première ligne du
      // premier pixel
      if (hc >= 10'h8f && hc < 10'h30f) begin
        // Pixel counter
        // px
        if (px < 3'h7) begin // 8 - 1
          px <= px + 1'b1;
        end else begin
          px <= 3'b0;
          // cx
          if (cx < 7'h4f) begin // 80 - 1
            cx <= cx + 1'b1;
          end else begin
            cx <= 7'b0;
          end
        end
        if (lx < 10'h27f) begin // 640 - 1
          lx <= lx + 1'b1;
        end else begin
          lx <= 10'b0;
          // py
          if (py < 4'hd) begin // 14 - 1
            py <= py + 1'b1;
          end else begin
            py <= 4'h0;
            // cy
            if (cy < 5'h18) begin // 25 - 1
              cy <= cy + 1'b1;
            end else begin
              cy <= 5'b0;
            end
          end
        end
        // Display pixels
        vga_red <= p[7:5];
        vga_grn <= p[4:2];
        vga_blu <= p[1:0];
      end else begin
        // Reset after a line
        vga_red <= 3'b000;
        vga_grn <= 3'b000;
        vga_blu <= 2'b00;
        px <= 3'b0;
        lx <= 10'b0;
        cx <= 7'b0;
      end
    end else begin
      // Reset for the whole screen
      py <= 4'h0;
      cy <= 5'b0;
      vga_red <= 3'b000;
      vga_grn <= 3'b000;
      vga_blu <= 2'b00;
      px <= 3'b0;
      lx <= 10'b0;
      cx <= 7'b0;
    end
  end
end

// Compute the pixel inside address
assign pa = px + (py << 3); // * 8
// Compute the caracter address
assign ca = cx + (cy << 4) * 5; // * 80

/**
 * Pulse the synchronization signals
 */
assign vga_hsync = (hc < 10'h60) ? 1'b0 : 1'b1;
assign vga_vsync = (vc < 10'h2) ? 1'b0 : 1'b1;

endmodule
