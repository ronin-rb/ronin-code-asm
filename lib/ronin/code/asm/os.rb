# frozen_string_literal: true
#
# ronin-code-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/asm/os/os'
require 'ronin/code/asm/os/freebsd'
require 'ronin/code/asm/os/linux'

module Ronin
  module Code
    module ASM
      module OS
        # The mapping of OS names to modules.
        NAMES = {
          linux:   Linux,
          freebsd: FreeBSD
        }

        #
        # Fetches the OS module with the given name.
        #
        # @param [Symbol] name
        #   The OS name (ex: `:linux`).
        #
        # @return [Linux, FreeBSD]
        #   The OS module.
        #
        # @raise [ArgumentError]
        #   The OS name was unknown.
        #
        # @since 1.0.0
        #
        def self.[](name)
          NAMES.fetch(name) do
            raise(ArgumentError,"unknown OS name: #{name.inspect}")
          end
        end
      end
    end
  end
end
