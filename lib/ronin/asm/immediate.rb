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

      def initialize(base,offset=0,index=nil,scale=1)
        super(base,offset.to_i,index,scale.to_i)
      end

      def +(offset)
        Immediate.new(self.base,self.offset+offset,self.index,self.scale)
      end

      def -(offset)
        Immediate.new(self.base,self.offset-offset,self.index,self.scale)
      end

      def width
        base.width if base.kind_of?(Register)
      end

    end
  end
end
