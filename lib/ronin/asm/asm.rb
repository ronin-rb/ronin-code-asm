#
# ronin-asm - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-asm.
#
# ronin-asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-asm.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/asm/program'
require 'ronin/asm/shellcode'

module Ronin
  module ASM
    #
    # Creates a new Assembly Program.
    #
    # @param [Hash{Symbol => Object}] options
    #   Additional options.
    #
    # @option options [String, Symbol] :arch (:x86)
    #   The architecture of the Program.
    #
    # @option options [Hash{Symbol => Object}] :variables
    #   Variables to set in the program.
    #
    # @yield []
    #   The given block will be evaluated within the program.
    #
    # @return [Program]
    #   The new Assembly Program.
    #
    # @example
    #   ASM.new do
    #     mov  1, eax
    #     mov  1, ebx
    #     mov  2, ecx
    #
    #     _loop do
    #       push  ecx
    #       imul  ebx, ecx
    #       pop   ebx
    #
    #       inc eax
    #       cmp ebx, 10
    #       jl  :_loop
    #     end
    #   end
    #
    def ASM.new(options={},&block)
      Program.new(options,&block)
    end
  end
end
