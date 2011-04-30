#
# Ronin ASM - a Ruby library for Ronin that provides dynamic Assembly (ASM)
# generation of programs or shellcode.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Code
    module ASM
      module Syntax
        class Common

          def self.emit_keyword(name)
            name.to_s
          end

          def self.emit_register(reg)
          end

          def self.emit_integer(value)
          end

          def self.emit_float(value)
          end

          def self.emit(value)
            case value
            when Register
              emit_register(value)
            when Symbol
              emit_keyword(value)
            when Integer
              emit_integer(value)
            when Float
              emit_float(value)
            end
          end

          def self.emit_operand(value)
            case value
            when Immediate, Array
              emit_immediate(value)
            else
              emit(value)
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
              when Symbol
                lines << emit_label(ins)
              when Instruction
                lines << "\t#{emit_instruction(ins)}"
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
