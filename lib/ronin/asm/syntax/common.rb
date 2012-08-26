#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/asm/register'
require 'ronin/asm/immediate_operand'
require 'ronin/asm/memory_operand'

module Ronin
  module ASM
    module Syntax
      class Common

        def self.emit_keyword(name)
          name.to_s
        end

        def self.emit_register(reg)
        end

        def self.emit_integer(value)
          if value >= 0 then "0x%x" % value
          else               "-0x%x" % value.abs
          end
        end

        def self.emit_float(value)
        end

        def self.emit_immediate_operand(op)
        end

        def self.emit_memory_operand(op)
        end

        def self.emit_operand(op)
          case op
          when ImmediateOperand then emit_immediate_operand(op)
          when MemoryOperand    then emit_memory_operand(op)
          when Register         then emit_register(op)
          when Symbol           then emit_keyword(op)
          end
        end

        def self.emit_operands(operands)
          operands.map { |op| emit_operand(op) }.join(",\t")
        end

        def self.emit_label(name)
          "#{name}:"
        end

        def self.emit_instruction(ins)
        end

        def self.emit_program(program)
          lines = [emit_label('_start')]

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
