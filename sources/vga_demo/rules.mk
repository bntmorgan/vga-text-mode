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

sp              	:= $(sp).x
dirstack_$(sp)  	:= $(d)
d               	:= $(dir)

# Synthesis sources definition
SRC_VHDL_$(d)		 	:= 
SRC_VERILOG_$(d) 	:= 

# Board specific definitions
PKG_$(d) 				 	:= xc6slx16-3-csg324

# Top module
TOP_$(d)				 	:= system

include $(d)/sources.mk

# Constraints
CONSTRAINTS_$(d) 	:= $(d)/synthesis/common.ucf

# Target path
TARGET           	:= $(call SRC_2_BIN, $(d)/$(TOP_$(d)))

# Synthesis rules
TARGETS 				 	+= $(call GEN_TARGETS, $(TARGET))

$(TARGET).prj						: $(d)/sources.mk $(SRC_VHDL_$(d)) $(SRC_VERILOG_$(d))
$(TARGET).prj						: VHDL 		:= $(SRC_VHDL_$(d))
$(TARGET).prj						: VERILOG := $(SRC_VERILOG_$(d))
$(TARGET).ucf						: $(CONSTRAINTS_$(d))

$(TARGET).xst						: PKG := $(PKG_$(d))
$(TARGET).xst						: TOP := $(TOP_$(d))

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
