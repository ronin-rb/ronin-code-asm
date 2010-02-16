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

require 'ronin/asm/rop/fragment'

module Ronin
  module ASM
    module ROP
      class Parser

        include Enumerable

        RET_BYTES = [0xc3, 0xcb]

        attr_accessor :source

        def initialize(source='',&block)
          @source = source

          block.call(self) if block
        end

        def each(&block)
          last_index = 0
          fragment = ''

          pass_fragment = lambda {
            unless fragment.empty?
              block.call(Fragment.new(last_index,fragment))
            end
          }

          Enumerator.new(@source,:each_byte).each_with_index do |b,index|
            if RET_BYTES.include?(b)
              pass_fragment.call()

              last_index = index + 1
              fragment = ''
            else
              fragment << b.chr
            end
          end

          pass_fragment.call()
          return self
        end

        def to_a
          Enumerator.new(self,:each).to_a
        end

      end
    end
  end
end
