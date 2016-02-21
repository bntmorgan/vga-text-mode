# sources here
#
# SRC_VERILOG_$(d) += $(d)/rtl/test.v 
# SRC_VERILOG_$(d) += $(CORES_DIR)/core/rtl/test.v 
#
# SRC_VHDL_$(d) += $(d)/rtl/test.vhd
# SRC_VHDL_$(d) += $(CORES_DIR)/cpt8/rtl/cpt8.vhd

SRC_VERILOG_$(d) += $(d)/rtl/system.v
SRC_VERILOG_$(d) += $(wildcard $(CORES_DIR)/vga/rtl/vga*.v)
