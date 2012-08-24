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

module Ronin
  module ASM
    module Syntax
      class Common

        def self.emit_keyword(name)
          name.to_s
        end

        def self.emit_register(reg)
        end

        def self.emit_literal(literal)
        end

        def self.emit_integer(value)
          if value >= 0 then "0x%x" % value
          else               "-0x%x" % value.abs
          end
        end

        def self.emit_float(value)
        end

        def self.emit(value)
          case value
          when Register then emit_register(value)
          when Literal  then emit_literal(value)
          when Symbol   then emit_keyword(value)
          when Float    then emit_float(value)
          when nil      then emit_literal(0)
          end
        end

        def self.emit_operand(value)
          case value
          when Immediate then emit_immediate(value)
          else                emit(value)
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
