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

require 'udis86'

module Ronin
  module ASM
    #
    # Creates a new `FFI::UDis86::UD` disassembler object.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Integer] :mode (32)
    #   The mode of disassembly, can either 16, 32 or 64.
    #
    # @option options [Integer] :syntax (:intel)
    #   The assembly syntax the disassembler will emit, can be either
    #   `:att` or `:intel`.
    #
    # @option options [String] :buffer
    #   A buffer to disassemble.
    #
    # @option options [Symbol] :vendor
    #   Sets the vendor of whose instructions to choose from. Can be
    #   either `:amd` or `:intel`.
    #
    # @option options [Integer] :pc
    #   Initial value of the Program Counter (PC).
    #
    # @yield [ud]
    #   If a block is given, it will be used as an input callback to
    #   return the next byte to disassemble. When the block returns
    #   -1, the disassembler will stop processing input.
    #
    # @yieldparam [FFI::UDis86::UD] ud
    #   The disassembler.
    #
    # @return [FFI::UDis86::UD]
    #   The newly created disassembler.
    #
    # @see http://yardoc.org/docs/sophsec-ffi-udis86/FFI/UDis86/UD
    #
    def ASM.disas(options={},&block)
      FFI::UDis86::UD.create(options,&block)
    end

    #
    # Opens a file and disassembles it.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @param [Hash] options
    #   Additional dissaembly options.
    #
    # @option options [Integer] :mode (32)
    #   The mode of disassembly, can either 16, 32 or 64.
    #
    # @option options [Integer] :syntax (:intel)
    #   The assembly syntax the disassembler will emit, can be either
    #   `:att` or `:intel`.
    #
    # @option options [String] :buffer
    #   A buffer to disassemble.
    #
    # @option options [Symbol] :vendor
    #   Sets the vendor of whose instructions to choose from. Can be
    #   either `:amd` or `:intel`.
    #
    # @option options [Integer] :pc
    #   Initial value of the Program Counter (PC).
    #
    # @yield [ud]
    #   If a block is given, it will be passed the newly created
    #   UD object, configured to disassembler the file.
    #
    # @yieldparam [FFI::UDis86::UD] ud
    #   The newly created disassembler.
    #
    # @see http://yardoc.org/docs/sophsec-ffi-udis86/FFI/UDis86/UD
    #
    def ASM.disas_file(path,options={},&block)
      FFI::UDis86::UD.open(path,options,&block)
    end
  end
end
