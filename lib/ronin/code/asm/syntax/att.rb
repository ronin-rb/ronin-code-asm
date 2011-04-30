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

          def self.emit_width(value)
            case value
            when Register, Immediate
              value.width
            when Integer
              if (value >= (2 ** 32))
                8
              elsif (value >= (2 ** 16))
                4
              elsif (value >= (2 ** 8))
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
              "$0x%x" % value
            else
              "$%d" % value
            end
          end

          def self.emit_immediate(value)
            if (value.width && value.index)
              '(' + emit(value.base) + ',' + emit(value.width) + ',' + emit(value.index) + ')'
            elsif value.index
              '(,' + emit(value.width) + ',' + emit(value.index) + ')'
            elsif value.width
              if value.width >= 0
                '(' + emit(value.base) + ',' + emit(value.width) + ')'
              else
                emit(value.width) + '(' + emit(value.base) + ')'
              end
            else
              '(' + emit(value.base) + ')'
            end
          end

          def self.emit_instruction(ins)
            line = emit_keyword(ins.name)
            
            if ins.operands
              width = ins.operands.map { |op| emit_width(op) }.max

              line << WIDTHS[width] << "\t" << emit_operands(ins.operands)
            end

            return line
          end

        end
      end
    end
  end
end
