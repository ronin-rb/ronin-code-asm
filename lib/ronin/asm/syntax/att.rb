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

require 'ronin/asm/syntax/common'

module Ronin
  module ASM
    module Syntax
      #
      # Handles emitting Assembly source code in ATT syntax.
      #
      class ATT < Common

        # Data sizes and their instruction mnemonics
        WIDTHS = {
          8 => 'q',
          4 => 'l',
          2 => 'w',
          1 => 'b',
          nil => ''
        }

        #
        # Emits a register.
        #
        # @param [Register] reg
        #   The register.
        #
        # @return [String]
        #   The register name.
        #
        def self.emit_register(reg)
          "%#{reg.name}"
        end

        #
        # Emits an immediate operand.
        #
        # @param [ImmediateOperand] op
        #   The operand.
        #
        # @return [String]
        #   The formatted immediate operand.
        #
        def self.emit_immediate_operand(op)
          "$#{emit_integer(op.value)}"
        end

        #
        # Emits a memory operand.
        #
        # @param [MemoryOperand] op
        #   The operand.
        #
        # @return [String]
        #   The formatted memory operand.
        #
        def self.emit_memory_operand(op)
          asm = emit_register(op.base)

          if op.index
            asm << ',' << emit_register(op.index)
            asm << ',' << op.scale.to_s if op.scale > 1
          end

          asm = "(#{asm})"
          asm = emit_integer(op.offset) + asm if op.offset != 0

          return asm
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
          if ops.length > 1
            [*ops[1..-1], ops[0]].map { |op| emit_operand(op) }.join(",\t")
          else
            super(ops)
          end
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
        def self.emit_instruction(ins)
          line = emit_keyword(ins.name)

          unless ins.operands.empty?
            unless (ins.operands.length == 1 && ins.width == 1)
              line << WIDTHS[ins.width]
            end

            line << "\t" << emit_operands(ins.operands)
          end

          return line
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
          ".#{name}"
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
          ".code#{BITS[program.arch]}"
        end

      end
    end
  end
end
