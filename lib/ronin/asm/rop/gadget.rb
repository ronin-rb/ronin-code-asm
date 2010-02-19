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

        # Assembly source-code of the gadget
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

        #
        # Creates a new {Gadget} object.
        #
        # @param [Integer] offset
        #   The offset address the gadget exists at.
        #
        def initialize(offset)
          @offset = offset
          @source = []

          @reg_map = Hash.new { |hash,key| hash[key] ||= Set[] }
          @dirty = Set[]

          @pushes = []
          @pops = []

          @stack_drift = 0
        end

        #
        # Defines a transfer of value from a source register to a
        # destination register.
        #
        # @param [Symbol] src
        #   The source register.
        #
        # @param [Symbol] dest
        #   The destination register.
        #
        # @return [Symbol]
        #   The destination register.
        #
        def map_reg!(src,dest)
          @reg_map[src] << dest
          return dest
        end

        #
        # The registers used within the gadget.
        #
        # @return [Array<Symbol>]
        #   The register names.
        #
        def regs
          @reg_map.keys
        end

        #
        # Marks a register as dirty, meaning it's value has changed
        # within the gadget.
        #
        # @param [Symbol] reg
        #   The register to mark as dirty.
        #
        # @return [Symbol]
        #   The marked register.
        #
        def dirty!(reg)
          @dirty << reg
          return reg
        end

        #
        # Indicates that a register is pushed onto the stack,
        # from within the gadget.
        #
        # @param [Symbol] reg
        #   The register that will be pushed onto the stack.
        #
        # @return [Symbol]
        #   The name of the pushed register.
        #
        def push!(reg)
          @pushes << reg
          return reg
        end

        #
        # Indicates that a register is popped from the stack,
        # from within the gadget.
        #
        # @param [Symbol] reg
        #   The register that will be pushed onto the stack.
        #
        # @return [Symbol]
        #   The name of the pushed register.
        #
        def pop!(reg)
          @pops << reg
          return reg
        end

        #
        # Determines whether the gadget actually changes the state of
        # the program.
        #
        # @return [Boolean]
        #   Specifies whether the gadget changes the state of the program
        #   it will be executed within.
        #
        def volitile?
          !(@dirty.empty? && @pushes.empty? && @pops.empty?)
        end

        #
        # Converts the gadget to an `Integer`.
        #
        # @return [Integer]
        #   The offset of the gadget.
        #
        def to_i
          @offset.to_i
        end

        #
        # Converts the gadget to a `String`.
        #
        # @return [String]
        #   The assembly source-code of the gadget.
        #
        def to_s
          @source.join($/)
        end

      end
    end
  end
end
