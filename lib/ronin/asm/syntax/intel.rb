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
      class Intel < Common

        # Data sizes and their identifiers
        WIDTHS = {
          1 => 'BYTE',
          2 => 'WORD',
          4 => 'DWORD',
          8 => 'QWORD'
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
          reg.name.to_s
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
          "#{WIDTHS[op.width]} #{emit_integer(op.value)}"
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
            asm << '+' << emit_register(op.index)
            asm << '*' << emit_integer(op.scale) if op.scale > 1
          end

          if op.offset != 0
            sign = if op.offset >= 0 then '+'
                   else                   '-'
                   end

            asm << sign << emit_integer(op.offset)
          end

          return "[#{asm}]"
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
            [ops[-1], *ops[0..-2]].map { |op| emit_operand(op) }.join(",\t")
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
            line << "\t" << emit_operands(ins.operands)
          end

          return line
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
          asm = super(program)

          # prepend the `BITS 64` directive for YASM
          if program.arch == :amd64
            asm = ["BITS 64", '', asm].join($/)
          end

          return asm
        end

      end
    end
  end
end
