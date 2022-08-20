#
# ronin-asm - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-asm.
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

require 'ronin/asm/immediate_operand'

module Ronin
  module ASM
    #
    # Represents an instruction.
    #
    class Instruction < Struct.new(:name, :operands)

      #
      # Initializes the instruction.
      #
      # @param [Symbol] name
      #   The instruction name.
      #
      # @param [Array<MemoryOperand, Register, Symbol, Integer>] operands
      #   Operands for the instruction.
      #
      def initialize(name,operands)
        operands = operands.map do |op|
          case op
          when Integer, nil then ImmediateOperand.new(op)
          else                   op
          end
        end

        super(name,operands)
      end

      #
      # The word size of the instruction.
      #
      # @return [Integer, nil]
      #   The word size in bytes.
      #
      def width
        self.operands.map { |op|
          op.width if op.respond_to?(:width)
        }.compact.max
      end

    end
  end
end
