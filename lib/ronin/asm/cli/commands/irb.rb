# frozen_string_literal: true
#
# ronin-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../command'
require_relative '../ruby_shell'

module Ronin
  module ASM
    class CLI
      module Commands
        #
        # Starts an interactive Ruby shell with `ronin-asm` loaded.
        #
        # ## Usage
        #
        #     ronin-asm irb [options]
        #
        # ## Options
        #
        #     -h, --help                       Print help information
        #
        # @since 0.2.0
        #
        class Irb < Command

          description "Starts an interactive Ruby shell with ronin-asm loaded"

          man_page 'ronin-asm-irb.1'

          #
          # Runs the `ronin-asm irb` command.
          #
          def run
            require 'ronin/asm'
            CLI::RubyShell.start
          end

        end
      end
    end
  end
end
