# frozen_string_literal: true
#
# ronin-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-asm.  If not, see <https://www.gnu.org/licenses/>.
#

require_relative 'memory'

module Ronin
  module ASM
    #
    # Represents a Register.
    #
    class Register

      # The register name.
      #
      # @return [Symbol]
      attr_reader :name

      # The width of the register.
      #
      # @return [Integer]
      attr_reader :width

      #
      # Initializes a register.
      #
      # @param [Symbol] name
      #   The register name.
      #
      # @param [Integer] width
      #   The width of the register.
      #
      # @param [Boolean] general
      #   Specifies whether the register is a General Purpose Register (GPR).
      #
      def initialize(name,width,general=false)
        @name  = name
        @width = width

        @general = general
      end

      #
      # Specifies whether the register is a general purpose register.
      #
      # @return [Boolean]
      #
      # @since 1.0.0
      #
      def general?
        @general
      end

      #
      # Adds an offset to the value within the register and dereferences the
      # address.
      #
      # @param [Memory, Register, Integer] offset
      #   The offset to add to the value of the register.
      #
      # @return [Memory]
      #   The new Memory Operand.
      #
      # @raise [TypeError]
      #   the `offset` was not an {Memory}, {Register} or Integer.
      #
      def +(offset)
        case offset
        when Memory
          Memory.new(self,offset.offset,offset.index,offset.scale)
        when Register
          Memory.new(self,0,offset)
        when Integer
          Memory.new(self,offset)
        else
          raise(TypeError,"offset was not an Memory, Register or Integer")
        end
      end

      #
      # Subtracts from the value within the register and dereferences the
      # address.
      #
      # @param [Integer] offset
      #   The value to subtract from the value of the register.
      #
      # @return [Memory]
      #   The new Memory Operand.
      #
      def -(offset)
        Memory.new(self,-offset)
      end

      #
      # Multiples the value within the register.
      #
      # @param [Integer] scale
      #   The scale to multiply the value within register by.
      #
      # @return [Memory]
      #   The new Memory Operand.
      #
      def *(scale)
        Memory.new(nil,0,self,scale)
      end

      #
      # @return [String]
      #   The register's name.
      #
      def to_s
        @name.to_s
      end

    end
  end
end
