#
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/asm/rop/gadget'

require 'set'
require 'udis86'

module Ronin
  module ASM
    module ROP
      class Fragment

        include Enumerable

        # Blacklist of instructions not allowed within gadgets
        INSN_BLACKLIST = Set[:invalid, :ret, :retf]

        # Offset of the fragment within the larger source
        attr_reader :offset

        # Source of the fragment
        attr_reader :source

        def initialize(offset,source)
          @offset = offset
          @source = source
        end

        def each(&block)
          (@source.length - 1).downto(0) do |index|
            if (gadget = self[index])
              block.call(gadget)
            end
          end
        end

        def [](index)
          return nil if index >= @source.length

          partial = @source[index..-1]
          gadget = Gadget.new(@offset + index)

          ud = FFI::Udis86::UD.create(
            :syntax => :intel,
            :pc => @offset + index,
            :buffer => partial
          )

          ud.each do |ud|
            return nil if BLACKLIST.include?(ud.mnemonic)

            case ud.mnemonic
            when :push
              if ud.operands[0].is_reg?
                gadget.push!(ud.operands[0].reg)
              end

              gadget.stack_drift -= ud.operands[0].size
            when :pop
              if ud.operands[0].is_reg?
                gadget.pop!(ud.operands[0].reg)
              end

              gadget.stack_drift += ud.operands[0].size
            when :mov
              if ud.operands[0].is_reg?
                dest = ud.operands[0].reg

                if ud.operands[1].is_reg?
                  src = ud.operands[1].reg

                  gadget.map_reg!(src,dest)
                end

                gadget.dirty!(dest)
              end
            when :xchg
              if ud.operands[0].is_reg?
                dest = ud.operands[0].reg

                gadget.dirty!(dest)
              end

              if ud.operands[1].is_reg?
                src = ud.operands[1].reg

                gadget.dirty!(src)
              end

              if (ud.operands[0].is_reg? && ud.operands[1].is_reg?)
                dest = ud.operands[0].reg
                src = ud.operands[1].reg

                gadget.map_reg!(src,dest)
                gadget.map_reg!(dest,src)
              end
            when :jmp
            when :test, :cmp, :sete, :setne, :setg, :setge, :setl, :setle
            when :je, :jne, :jg, :jge, :jl, :jle
            when :call
            when :nop
            else
            end

            gadget.source << ud.to_asm
          end

          return gadget
        end

        def to_i
          @offset.to_i
        end

        def to_s
          @source.to_s
        end

        def to_a
          Enumerator.new(self,:each).to_a
        end

      end
    end
  end
end
