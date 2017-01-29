# Copyright (C) 2015  Benoît Morgan
#
# This file is part of vga-text-mode.
#
# vga-text-mode is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# vga-text-mode is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with vga-text-mode.  If not, see <http://www.gnu.org/licenses/>.

sp              := $(sp).x
dirstack_$(sp)  := $(d)
d               := $(dir)

# Synthesis

SRC_$(d)				:= $(wildcard $(d)/rtl/vga_*.v)

# Isim simulations

# SIM 			      := $(call SRC_2_BIN, $(d)/sim_vga_top)
# SRC_SIM_$(d)		:= $(SRC_$(d)) $(d)/rtl/sim_vga_top.v
# $(SIM).prj			: $(SRC_SIM_$(d))
# $(SIM).isim			: SIM_CFLAGS := --include $(abspath $(d)/rtl) \
# 		--include $(abspath $(CORES_DIR)/sim/rtl/)
# SIMS						+= $(SIM).isim

# Icarus simulation

XILINX_SRC_$(d)	= $(XILINX_SRC)/unisims/RAMB16BWER.v $(XILINX_SRC)/glbl.v

SIM 			      := $(call SRC_2_BIN, $(d)/vga_top.sim)
SRC_SIM_$(d)		:= $(SRC_$(d)) $(d)/rtl/sim_vga_top.v $(XILINX_SRC_$(d))
$(SIM)					: $(SRC_SIM_$(d))
$(SIM)					: SIM_CFLAGS := -I$(d)/rtl -I$(CORES_DIR)/sim/rtl/
# SIMS						+= $(SIM)

# Fixed
# TARGETS 				+= $(TARGET)

# $(TARGET)				: $(SRC_$(d))

d               := $(dirstack_$(sp))
sp              := $(basename $(sp))
