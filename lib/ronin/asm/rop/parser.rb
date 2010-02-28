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

        # Bytes which represent return instructions.
        RET_BYTES = {
          :x86 => [
            [0xc3],             # ret
            [0xcb],             # retf
            [0xff, 0xe0],       # jmp (eax)
            [0xff, 0xe3],       # jmp (ebx)
            [0xff, 0xe1],       # jmp (ecx)
            [0xff, 0xe2],       # jmp (edx)
            [0xff, 0xe6],       # jmp (esi)
            [0xff, 0xe7],       # jmp (edi)
            [0xff, 0xe4],       # jmp (esp)
            [0xff, 0xe5],       # jmp (ebp)
            [0xff, 0x20],       # jmp [eax]
            [0xff, 0x23],       # jmp [ebx]
            [0xff, 0x21],       # jmp [ecx]
            [0xff, 0x22],       # jmp [edx]
            [0xff, 0x26],       # jmp [esi]
            [0xff, 0x27],       # jmp [edi]
            [0xff, 0x24, 0x24], # jmp [esp]
            [0xff, 0x65, 0x00]  # jmp [ebp]
          ],

          :amd64 => [
            [0xc3],                   # ret
            [0x48, 0xcb],             # retf
            [0xff, 0xe0],             # jmp (rax)
            [0xff, 0xe3],             # jmp (rbx)
            [0xff, 0xe1],             # jmp (rcx)
            [0xff, 0xe2],             # jmp (rdx)
            [0xff, 0xe6],             # jmp (rsi)
            [0xff, 0xe7],             # jmp (rdi)
            [0xff, 0xe4],             # jmp (rsp)
            [0xff, 0xe5],             # jmp (rbp)
            [0x41, 0xff, 0xe0],       # jmp (r8)
            [0x41, 0xff, 0xe1],       # jmp (r9)
            [0x41, 0xff, 0xe2],       # jmp (r10)
            [0x41, 0xff, 0xe3],       # jmp (r11)
            [0x41, 0xff, 0xe4],       # jmp (r12)
            [0x41, 0xff, 0xe5],       # jmp (r13)
            [0x41, 0xff, 0xe6],       # jmp (r14)
            [0x41, 0xff, 0xe7],       # jmp (r15)
            [0xff, 0x20],             # jmp [rax]
            [0xff, 0x23],             # jmp [rbx]
            [0xff, 0x21],             # jmp [rcx]
            [0xff, 0x22],             # jmp [rdx]
            [0xff, 0x26],             # jmp [rsi]
            [0xff, 0x27],             # jmp [rdi]
            [0xff, 0x24, 0x24],       # jmp [rsp]
            [0xff, 0x65, 0x00],       # jmp [rbp]
            [0x41, 0xff, 0x20],       # jmp [r8]
            [0x41, 0xff, 0x21],       # jmp [r9]
            [0x41, 0xff, 0x22],       # jmp [r10]
            [0x41, 0xff, 0x23],       # jmp [r11]
            [0x41, 0xff, 0x24, 0x24], # jmp [r12]
            [0x41, 0xff, 0x65, 0x00], # jmp [r13]
            [0x41, 0xff, 0x26],       # jmp [r14]
            [0x41, 0xff, 0x27]        # jmp [r15]
          ]
        }

        # The architecture to parse against
        attr_reader :arch

        # The binary source to parse
        attr_accessor :source

        #
        # Creates a new {Parser} object.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :source
        #   The binary source to parse.
        #
        # @option options [Symbol] :arch (:x86)
        #   The architecture to parse against.
        #
        # @yield [parser]
        #   If a block is given, it will be passed the newly created parser.
        #
        # @yieldparam [Parser] parser
        #   The newly created parser.
        #
        def initialize(options={},&block)
          @source = ''
          @arch = :x86

          if options[:source]
            @source = options[:source]
          end

          if options[:arch]
            @arch = options[:arch]
          end

          unless RET_BYTES.has_key?(@arch)
            raise(StandardError,"unsupported ROP architecture #{@arch}",caller)
          end

          @ret_bytes = RET_BYTES[@arch]
          @ret_look_ahead = @ret_bytes.map { |bytes| bytes.length }.max

          block.call(self) if block
        end

        #
        # Enumerates over every fragment found within the binary source.
        #
        # @yield [fragment]
        #   The given block will be passed each new fragment found within
        #   the binary source.
        #
        # @yieldparam [Fragment] fragment
        #   A fragment bounded by one or more return instructions, found
        #   within the binary source.
        #
        # @return [Parser]
        #   The parser.
        #
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

        #
        # Converts the parser to an `Array`.
        #
        # @return [Array<Fragment>]
        #   The fragments bounded by return instructions, found within
        #   the binary source.
        #
        def to_a
          Enumerator.new(self,:each).to_a
        end

      end
    end
  end
end
