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
            "\xc3",           # ret
            "\xcb",           # retf
            "\xff\xe0",       # jmp (eax)
            "\xff\xe3",       # jmp (ebx)
            "\xff\xe1",       # jmp (ecx)
            "\xff\xe2",       # jmp (edx)
            "\xff\xe6",       # jmp (esi)
            "\xff\xe7",       # jmp (edi)
            "\xff\xe4",       # jmp (esp)
            "\xff\xe5",       # jmp (ebp)
            "\xff\x20",       # jmp [eax]
            "\xff\x23",       # jmp [ebx]
            "\xff\x21",       # jmp [ecx]
            "\xff\x22",       # jmp [edx]
            "\xff\x26",       # jmp [esi]
            "\xff\x27",       # jmp [edi]
            "\xff\x24\x24",   # jmp [esp]
            "\xff\x65\x00"    # jmp [ebp]
          ],

          :amd64 => [
            "\xc3",               # ret
            "\x48\xcb",           # retf
            "\xff\xe0",           # jmp (rax)
            "\xff\xe3",           # jmp (rbx)
            "\xff\xe1",           # jmp (rcx)
            "\xff\xe2",           # jmp (rdx)
            "\xff\xe6",           # jmp (rsi)
            "\xff\xe7",           # jmp (rdi)
            "\xff\xe4",           # jmp (rsp)
            "\xff\xe5",           # jmp (rbp)
            "\x41\xff\xe0",       # jmp (r8)
            "\x41\xff\xe1",       # jmp (r9)
            "\x41\xff\xe2",       # jmp (r10)
            "\x41\xff\xe3",       # jmp (r11)
            "\x41\xff\xe4",       # jmp (r12)
            "\x41\xff\xe5",       # jmp (r13)
            "\x41\xff\xe6",       # jmp (r14)
            "\x41\xff\xe7",       # jmp (r15)
            "\xff\x20",           # jmp [rax]
            "\xff\x23",           # jmp [rbx]
            "\xff\x21",           # jmp [rcx]
            "\xff\x22",           # jmp [rdx]
            "\xff\x26",           # jmp [rsi]
            "\xff\x27",           # jmp [rdi]
            "\xff\x24\x24",       # jmp [rsp]
            "\xff\x65\x00",       # jmp [rbp]
            "\x41\xff\x20",       # jmp [r8]
            "\x41\xff\x21",       # jmp [r9]
            "\x41\xff\x22",       # jmp [r10]
            "\x41\xff\x23",       # jmp [r11]
            "\x41\xff\x24\x24",   # jmp [r12]
            "\x41\xff\x65\x00",   # jmp [r13]
            "\x41\xff\x26",       # jmp [r14]
            "\x41\xff\x27"        # jmp [r15]
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

          Enumerator.new(@source,:each_byte).each_with_index do |b,index|
            fragment << b.chr

            @ret_bytes.each do |bytes|
              if fragment[-(bytes.length)..-1] == bytes
                block.call(Fragment.new(last_index,fragment))

                last_index = index + 1
                fragment = ''
                break
              end
            end
          end

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
