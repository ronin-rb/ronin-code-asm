#
#--
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/code/asm/compiliable'

module Ronin
  module Code
    module ASM
      class Instruction

        include Compiliable

        # The instruction name
        attr_reader :name

        # The instruction suffix
        attr_accessor :suffix

        # The arguments associated with the instruction
        attr_accessor :args

        def initialize(style,name,opts={:suffix => nil, :args => *args})
          @style = style
          @name = name.to_sym
          @suffix = opts[:suffix]
          @args = opts[:args]
        end

        def ==(ins)
          return false unless @name==ins.name
          return false unless @suffix==ins.suffix

          return @args==ins.args
        end

        def compile
          unless @args.empty
            return "#{@name}#{@suffix}\t#{@args.join(', ')}"
          else
            return @name.to_s
          end
        end

      end
    end
  end
end
