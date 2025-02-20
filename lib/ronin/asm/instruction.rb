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

require_relative 'immediate'

module Ronin
  module ASM
    #
    # Represents an instruction.
    #
    class Instruction

      # The instruction mnemonic name.
      #
      # @return [Symbol]
      attr_reader :name

      # The operands of the instruction.
      #
      # @return [Array<Memory, Register, Symbol, Integer>]
      attr_reader :operands

      # Optional comment for the instruction.
      #
      # @return [String, nil]
      attr_reader :comment

      #
      # Initializes the instruction.
      #
      # @param [Symbol] name
      #   The instruction name.
      #
      # @param [Array<Memory, Register, Symbol, Integer>] operands
      #   Operands for the instruction.
      #
      # @param [String, nil] comment
      #   Optional comment for the instruction.
      #
      def initialize(name,operands, comment: nil)
        @name     = name
        @operands = operands.map do |value|
          case value
          when Integer, nil then Immediate.new(value)
          else                   value
          end
        end

        @comment = comment
      end

      #
      # The word size of the instruction.
      #
      # @return [Integer, nil]
      #   The word size in bytes.
      #
      def width
        @operands.map { |op|
          op.width if op.respond_to?(:width)
        }.compact.max
      end

    end
  end
end
