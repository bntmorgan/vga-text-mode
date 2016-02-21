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
SIMS						+= $(SIM)

# Fixed
# TARGETS 				+= $(TARGET)

# $(TARGET)				: $(SRC_$(d))

d               := $(dirstack_$(sp))
sp              := $(basename $(sp))
