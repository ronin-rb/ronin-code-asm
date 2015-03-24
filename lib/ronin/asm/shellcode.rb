#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin ASM.
#
# Ronin Asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin Asm.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/asm/program'

require 'tempfile'

module Ronin
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
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :output
      #   The optional output to write the shellcode to. If no `:output` is
      #   given a tempfile will be used.
      #
      # @return [String]
      #   The raw object-code of the Shellcode.
      #
      # @see Program#assemble
      #
      def assemble(options={})
        output = options.fetch(:output) do
          Tempfile.new(['ronin-shellcode', '.bin']).path
        end

        super(output,options.merge(format: :bin))

        return File.new(output,'rb').read
      end

    end
  end
end
