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
        INSN_BLACKLIST = Set['invalid', 'pop', 'push', 'ret', 'retf']

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
            :pc => @offset + index
          )

          ud.input_buffer = partial

          ud.each do |ud|
            return nil if BLACKLIST.include?(ud.mnemonic)

            gadget << ud.to_asm
          end

          return gadget
        end

        def to_i
          @offset.to_i
        end

        def to_s
          @source.to_s
        end

      end
    end
  end
end
