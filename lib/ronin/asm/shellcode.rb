#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    class Shellcode < Program

      #
      # Assembles the Shellcode.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @return [String]
      #   The raw object-code of the Shellcode.
      #
      # @see Program#assemble
      #
      def assemble(options={})
        output = Tempfile.new('ronin-shellcode.bin')

        super(output.path,options.merge(:format => :bin))
        return output.read
      end

    end
  end
end
