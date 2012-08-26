#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin ASM.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>
#

require 'ronin/asm/register'

module Ronin
  module ASM
    #
    # Represents immediate memory.
    #
    # @see http://asm.sourceforge.net/articles/linasm.html#Memory
    #
    class Immediate < Struct.new(:base, :offset, :index, :scale)

      #
      # Creates a new Immediate value.
      #
      # @param [Register, nil] base
      #   The base of the value.
      #
      # @param [Integer] offset
      #   The fixed offset to add to the `base`.
      #
      # @param [Register, nil] index
      #   The variable index to multiple by `scale`, then add to `base.
      #
      # @param [Integer] scale
      #   The scale to multiple `index` by.
      #
      # @raise [TypeError]
      #   `base` or `index` was not a {Register} or `nil`.
      #
      def initialize(base=nil,offset=0,index=nil,scale=1)
        unless (base.nil? || base.kind_of?(Register))
          raise(TypeError,"base must be a Register or nil")
        end

        unless offset.kind_of?(Integer)
          raise(TypeError,"offset must be an Integer")
        end

        unless (index.nil? || index.kind_of?(Register))
          raise(TypeError,"index must be a Register or nil")
        end

        unless scale.kind_of?(Integer)
          raise(TypeError,"scale must be an Integer")
        end

        super(base,offset,index,scale)
      end

      #
      # Adds to the offset of the Immediate value.
      #
      # @param [Integer] offset
      #   The offset to add to the immediate value.
      #
      # @return [Immeidate]
      #   The new Immediate object.
      #
      def +(offset)
        Immediate.new(self.base,self.offset+offset,self.index,self.scale)
      end

      #
      # Subtracts from the offset of the Immediate value.
      #
      # @param [Integer] offset
      #   The offset to subject from the immediate value.
      #
      # @return [Immeidate]
      #   The new Immediate object.
      #
      def -(offset)
        Immediate.new(self.base,self.offset-offset,self.index,self.scale)
      end

      #
      # The width of the immediate value.
      #
      # @return [Integer]
      #   The width taken from the base {Register}.
      #
      def width
        base.width
      end

    end
  end
end
