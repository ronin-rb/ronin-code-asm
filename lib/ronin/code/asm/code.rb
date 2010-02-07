#
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'yasm/program'
require 'tempfile'

module Ronin
  module Code
    #
    # Assembles a file using `yasm`.
    #
    # @param [Hash{Symbol => Object}] options
    #   Additional assembly options.
    #
    # @yield [yasm]
    #   If a block is given, it will be passed a task object used to
    #   specify options for yasm. 
    #
    # @yieldparam [YASM::Task] yasm
    #   The yasm task.
    #
    # @return [Boolean]
    #   Specifies whether the command exited normally. 
    #
    # @since 0.1.0
    #
    # @see http://ruby-yasm.rubyforge.org/YASM/Program.html#assmeble-class_method
    # @see http://ruby-yasm.rubyforge.org/YASM/Task.html
    #
    def Code.asm(options={},&block)
      YASM::Program.assemble(options,&block)
    end

    #
    # Assembles inline assembly code using `yasm`.
    #
    # @param [Hash{Symbol => Object}] options
    #   Additional assembly options.
    #
    # @return [String]
    #   The assembled inline code.
    #
    # @since 0.1.0
    #
    # @see http://ruby-yasm.rubyforge.org/YASM/Program.html#assmeble-class_method
    # @see http://ruby-yasm.rubyforge.org/YASM/Task.html
    #
    def Code.asm_inline(options={},&block)
      Tempfile.open('ronin-asm') do |temp_file|
        options = options.merge(
          :output_format => :bin,
          :output => temp_file.path
        )

        YASM::Program.assemble(options,&block)
        return temp_file.read
      end
    end
  end
end
