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

        # Binary source of the fragment
        attr_reader :source

        #
        # Creates a new {Fragment} object.
        #
        # @param [Integer] offset
        #   The offset address the fragment exists at.
        #
        # @param [String] source
        #   The binary source of the fragment.
        #
        def initialize(offset,source)
          @offset = offset
          @source = source
        end

        #
        # Enumerates over each valid gadget of the fragment.
        #
        # @yield [gadget]
        #   The given block will be passed each valid gadget found within
        #   the fragment.
        #
        # @yieldparam [Gadget] gadget
        #   A valid gadget from the fragment.
        #
        # @return [Fragment]
        #   The fragment.
        #
        def each(&block)
          (@source.length - 1).downto(0) do |index|
            if (gadget = self[index])
              block.call(gadget)
            end
          end

          return self
        end

        #
        # Attempts to create a valid gadget at the given index from within
        # the fragment.
        #
        # @param [Integer] index
        #   The index within the fragments binary source, to create the
        #   gadget at.
        #
        # @return [Gadget, nil]
        #   Returns the valid {Gadget} object at the given index, or `nil`
        #   if the gadget was found to be invalid.
        #
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

        #
        # Converts the fragment to an `Integer`.
        #
        # @return [Integer]
        #   The offset of the fragment.
        #
        def to_i
          @offset.to_i
        end

        #
        # Converts the fragment to a `String`.
        #
        # @return [String]
        #   The binary source of the fragment.
        #
        def to_s
          @source.to_s
        end

        #
        # Converts the fragment to an `Array`.
        #
        # @return [Array<Gadget>]
        #   The valid gadgets found within the fragment.
        #
        def to_a
          Enumerator.new(self,:each).to_a
        end

      end
    end
  end
end