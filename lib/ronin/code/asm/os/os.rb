# frozen_string_literal: true
#
# ronin-code-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../config'

require 'yaml'

module Ronin
  module Code
    module ASM
      module OS
        #
        # Collection of all known syscalls, grouped by OS and Arch.
        #
        # @return [Hash{Symbol => Hash{Symbol => Hash{Symbol => Integer}}}]
        #   Syscall names and numbers, organized by OS then Arch.
        #
        # @api private
        #
        SYSCALLS = Hash.new do |hash,os|
          hash[os] = Hash.new do |subhash,arch|
            subhash[arch] = YAML.load_file(
              File.join(Config::DATA_DIR,'os',os.to_s.downcase,arch.to_s,'syscalls.yml')
            )
          end
        end
      end
    end
  end
end
