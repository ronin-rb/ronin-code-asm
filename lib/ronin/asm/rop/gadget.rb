#
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'set'

module Ronin
  module ASM
    module ROP
      class Gadget

        # Offset of the gadget
        attr_reader :offset

        # ASM source code of the gadget
        attr_reader :source

        # Register map of the gadget
        attr_reader :reg_map

        # Registers and data that are pushed
        attr_reader :pushes

        # Registers and data that are popped
        attr_reader :pops

        # Registers dirtied by the gadget
        attr_reader :dirty

        # The number of bytes the stack pointer will change by
        attr_accessor :stack_drift

        def initialize(offset)
          @offset = offset
          @source = []

          @reg_map = Hash.new { |hash,key| hash[key] ||= Set[] }
          @dirty = Set[]

          @pushes = []
          @pops = []

          @stack_drift = 0
        end

        def regs
          @reg_map.keys
        end

        def dirty!(reg)
          @dirty << reg
          return reg
        end

        def push!(reg)
          @pushes << reg
          return reg
        end

        def pop!(reg)
          @pops << reg
          return reg
        end

        def to_i
          @offset.to_i
        end

        def to_s
          @source.join($/)
        end

      end
    end
  end
end
