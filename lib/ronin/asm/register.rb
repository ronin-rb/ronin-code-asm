#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin ASM.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>
#

require 'ronin/asm/memory_operand'

module Ronin
  module ASM
    #
    # Represents a Register.
    #
    class Register < Struct.new(:name, :width, :general)

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
        super(name,width,general)
      end

      #
      # Adds an offset to the value within the register and dereferences the
      # address.
      #
      # @param [MemoryOperand, Register, Integer] offset
      #   The offset to add to the value of the register.
      #
      # @return [MemoryOperand]
      #   The new Memory Operand.
      #
      # @raise [TypeError]
      #   the `offset` was not an {MemoryOperand}, {Register} or Integer.
      #
      def +(offset)
        case offset
        when MemoryOperand
          MemoryOperand.new(self,offset.offset,offset.index,offset.scale)
        when Register
          MemoryOperand.new(self,0,offset)
        when Integer
          MemoryOperand.new(self,offset)
        else
          raise(TypeError,"offset was not an MemoryOperand, Register or Integer")
        end
      end

      #
      # Substracts from the value within the register and dereferences the
      # address.
      #
      # @param [Integer] offset
      #   The value to subtract from the value of the register.
      #
      # @return [MemoryOperand]
      #   The new Memory Operand.
      #
      def -(offset)
        MemoryOperand.new(self,-offset)
      end

      #
      # Multiples the value within the register.
      #
      # @param [Integer] scale
      #   The scale to multiply the value within register by.
      #
      # @return [MemoryOperand]
      #   The new Memory Operand.
      #
      def *(scale)
        MemoryOperand.new(nil,0,self,scale)
      end

      #
      # @return [String]
      #   The register's name.
      #
      def to_s
        self.name.to_s
      end

    end
  end
end
