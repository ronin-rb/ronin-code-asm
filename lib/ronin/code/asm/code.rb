#
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/asm/program'

module Ronin
  module Code
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
    #   Code.asm do
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
    def Code.asm(options={},&block)
      ASM::Program.new(options,&block)
    end

    #
    # Assembles a Program using `yasm`.
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
    # @return [String]
    #   The Object Code of the Program.
    #
    # @example
    #   Code.assemble do
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
    #   # => "..."
    #
    # @see ASM::Program#assemble
    #
    def Code.assemble(options={},&block)
      Code.asm(options,&block).assemble
    end
  end
end
