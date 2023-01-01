# frozen_string_literal: true
#
# ronin-code-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-code-asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-code-asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-code-asm.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/code/asm/program'

require 'tempfile'

module Ronin
  module Code
    module ASM
      #
      # Represents Shellcode. Shellcode is like an Assembly {Program}, but
      # assembles into raw machine code which can be injected into a process.
      #
      #     ASM::Shellcode.new do
      #       xor   eax,  eax
      #       push  eax
      #       push  0x68732f2f
      #       push  0x6e69622f
      #       mov   ebx, esp
      #       push  eax
      #       push  ebx
      #       mov   ecx,  esp
      #       xor   edx,  edx
      #       mov   al,   0xb
      #       int   0x80
      #     end
      # 
      #
      class Shellcode < Program

        #
        # Assembles the Shellcode.
        #
        # @param [String] output
        #   The optional output to write the shellcode to. If no `:output` is
        #   given a tempfile will be used.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Program#assemble}.
        #
        # @return [String]
        #   The raw object-code of the Shellcode.
        #
        # @see Program#assemble
        #
        def assemble(output: nil, **kwargs)
          output ||= Tempfile.new(['ronin-shellcode', '.bin']).path

          super(output, format: :bin, **kwargs)

          return File.binread(output)
        end

      end
    end
  end
end
