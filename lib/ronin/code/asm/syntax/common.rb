# frozen_string_literal: true
#
# ronin-code-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-code-asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-code-asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-code-asm.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/code/asm/register'
require 'ronin/code/asm/immediate_operand'
require 'ronin/code/asm/memory_operand'

module Ronin
  module Code
    module ASM
      module Syntax
        #
        # Abstract base-class for all Assembly Syntax classes.
        #
        class Common

          # Bit sizes for various architectures
          BITS = {
            x86:   32,
            amd64: 64,
          }

          #
          # Emits a keyword.
          #
          # @param [Symbol] name
          #   Name of the keyword.
          #
          # @return [String]
          #   The formatted keyword.
          #
          def self.emit_keyword(name)
            name.to_s
          end

          #
          # Emits a register.
          #
          # @param [Register] reg
          #
          # @return [String]
          #   The formatted register.
          #
          # @abstract
          #
          def self.emit_register(reg)
          end

          #
          # Emits an integer.
          #
          # @param [Integer] value
          #   The integer.
          #
          # @return [String]
          #   The formatted integer.
          #
          def self.emit_integer(value)
            if value >= 0 then "0x%x" % value
            else               "-0x%x" % value.abs
            end
          end

          #
          # Emits a floating point number.
          #
          # @param [Float] value
          #   The number.
          #
          # @return [String]
          #   The formatted float.
          #
          # @abstract
          #
          def self.emit_float(value)
          end

          #
          # Emits an immediate operand.
          #
          # @param [ImmediateOperand] op
          #   The immediate operand.
          #
          # @return [String]
          #   The formatted immediate operand.
          #
          # @abstract
          #
          def self.emit_immediate_operand(op)
          end

          #
          # Emits an memory operand.
          #
          # @param [MemoryOperand] op
          #   The memory operand.
          #
          # @return [String]
          #   The formatted memory operand.
          #
          # @abstract
          #
          def self.emit_memory_operand(op)
          end

          #
          # Emits an operand.
          #
          # @param [ImmediateOperand, MemoryOperand, Register, Symbol] op
          #   The operand.
          #
          # @return [String]
          #   The formatted operand.
          #
          def self.emit_operand(op)
            case op
            when ImmediateOperand then emit_immediate_operand(op)
            when MemoryOperand    then emit_memory_operand(op)
            when Register         then emit_register(op)
            when Symbol           then emit_keyword(op)
            end
          end

          #
          # Emits multiple operands.
          #
          # @param [Array<ImmediateOperand, MemoryOperand, Register, Symbol>] ops
          #   The Array of operands.
          #
          # @return [String]
          #   The formatted operands.
          #
          def self.emit_operands(ops)
            ops.map { |op| emit_operand(op) }.join(",\t")
          end

          #
          # Emits a label.
          #
          # @param [Symbol] name
          #   The name of the label.
          #
          # @return [String]
          #   The formatted label.
          #
          def self.emit_label(name)
            "#{name}:"
          end

          #
          # Emits an instruction.
          #
          # @param [Instruction] ins
          #   The instruction.
          #
          # @return [String]
          #   The formatted instruction.
          #
          # @abstract
          #
          def self.emit_instruction(ins)
          end

          #
          # Emits a section name.
          #
          # @param [Symbol] name
          #   The section name.
          #
          # @return [String]
          #   The formatted section name.
          #
          # @since 0.2.0
          #
          def self.emit_section(name)
          end

          #
          # Emits the program's prologue.
          #
          # @param [Program] program
          #   The program.
          #
          # @return [String]
          #   The formatted prologue.
          #
          # @since 0.2.0
          #
          def self.emit_prologue(program)
          end

          #
          # Emits a program.
          #
          # @param [Program] program
          #   The program.
          #
          # @return [String]
          #   The formatted program.
          #
          def self.emit_program(program)
            lines = [
              emit_prologue(program),
              emit_section(:text),
              emit_label(:_start)
            ].compact

            program.instructions.each do |ins|
              case ins
              when Symbol      then lines << emit_label(ins)
              when Instruction then lines << "\t#{emit_instruction(ins)}"
              end
            end

            lines << ''

            return lines.join($/)
          end

        end
      end
    end
  end
end
