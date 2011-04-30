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

require 'ronin/code/asm/syntax/common'

module Ronin
  module Code
    module ASM
      module Syntax
        class ATT < Common

          WIDTHS = {
            8 => 'q',
            4 => 'l',
            2 => 'w',
            1 => 'b',
            nil => ''
          }

          def self.operand_width(op)
            case op
            when Array
              op.map { |v| operand_width(v) }.max
            when Register, Immediate
              op.width
            when Integer
              if (op >= (2 ** 32))
                8
              elsif (op >= (2 ** 16))
                4
              elsif (op >= (2 ** 8))
                2
              else
                1
              end
            end
          end

          def self.emit_register(reg)
            "%#{reg.name}"
          end

          def self.emit_integer(value)
            if value >= 0
              "0x%x" % value
            else
              "%d" % value
            end
          end

          def self.emit_immediate(imm)
            base, offset, scale = *imm

            if (offset && scale)
              '(' + emit(base) + ',' + emit(offset) + ',' + emit(scale) + ')'
            elsif scale
              '(,' + emit(base) + ',' + emit(scale) + ')'
            elsif offset
              emit(offset) + '(' + emit(base) + ')'
            else
              '(' + emit(base) + ')'
            end
          end

          def self.emit_operand(op)
            case op
            when Integer
              "$#{super(op)}"
            else
              super(op)
            end
          end

          def self.emit_instruction(ins)
            line = emit_keyword(ins.name)
            
            if ins.operands
              width = ins.operands.map { |op| operand_width(op) }.max

              line << WIDTHS[width] << "\t" << emit_operands(ins.operands)
            end

            return line
          end

        end
      end
    end
  end
end
