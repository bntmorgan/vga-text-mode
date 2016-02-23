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

sp 		:= $(sp).x
dirstack_$(sp)	:= $(d)
d		:= $(dir)

# dir	:= $(d)/core
# include	$(dir)/rules.mk

dir	:= $(d)/vga
include	$(dir)/rules.mk

d		:= $(dirstack_$(sp))
sp		:= $(basename $(sp))
