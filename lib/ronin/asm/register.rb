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

require 'ronin/asm/immediate'

module Ronin
  module ASM
    class Register < Struct.new(:name, :width)

      #
      # Adds an offset to the value within the register and dereferences the
      # address.
      #
      # @param [Immediate, Register, Integer] offset
      #   The offset to add to the value of the register.
      #
      # @return [Immediate]
      #   The new Immediate value.
      #
      def +(offset)
        case offset
        when Immediate
          Immediate.new(self,offset.offset,offset.index,offset.scale)
        when Register
          Immediate.new(self,0,offset)
        else
          Immediate.new(self,offset)
        end
      end

      #
      # Substracts from the value within the register and dereferences the
      # address.
      #
      # @param [Integer] offset
      #   The value to subtract from the value of the register.
      #
      # @return [Immediate]
      #   The new Immediate value.
      #
      def -(offset)
        Immediate.new(self,-offset)
      end

      #
      # Multiples the value within the register.
      #
      # @param [Integer] scale
      #   The scale to multiply the value within register by.
      #
      # @return [Immediate]
      #   The new Immediate value.
      #
      def *(scale)
        Immediate.new(nil,0,self,scale)
      end

      #
      # @return [String]
      #   The register's name.
      #
      def to_s
        self.name.to_s
      end

    end
  end
end
