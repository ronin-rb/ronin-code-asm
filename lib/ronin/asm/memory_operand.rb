#
# ronin-asm - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-asm.
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

require 'ronin/asm/register'

module Ronin
  module ASM
    #
    # Represents a Memory Operand.
    #
    # @see http://asm.sourceforge.net/articles/linasm.html#Memory
    #
    class MemoryOperand < Struct.new(:base, :offset, :index, :scale, :width)

      #
      # Creates a new Memory Operand.
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
      def initialize(base=nil,offset=0,index=nil,scale=1,width=nil)
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

        if base
          width ||= base.width
        end

        super(base,offset,index,scale,width)
      end

      #
      # Adds to the offset of the Memory Operand.
      #
      # @param [Integer] offset
      #   The offset to add to the Memory Operand.
      #
      # @return [MemoryOperand]
      #   The new Memory Operand.
      #
      def +(offset)
        MemoryOperand.new(
          self.base,
          self.offset + offset,
          self.index,
          self.scale,
          self.width
        )
      end

      #
      # Subtracts from the offset of the Memory Operand.
      #
      # @param [Integer] offset
      #   The offset to subject from the Memory Operand.
      #
      # @return [Memoryoperand]
      #   The new Memory Operand.
      #
      def -(offset)
        MemoryOperand.new(
          self.base,
          self.offset - offset,
          self.index,
          self.scale,
          self.width
        )
      end

    end
  end
end
