#
# ronin-asm - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/asm/version'

module Ronin
  module ASM
    #
    # Creates a new Assembly Program.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for {Program#initialize}.
    #
    # @option kwargs [String, Symbol] :arch (:x86)
    #   The architecture of the Program.
    #
    # @option kwargs [Hash{Symbol => Object}] :variables
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
    def ASM.new(**kwargs,&block)
      Program.new(**kwargs,&block)
    end
  end
end
