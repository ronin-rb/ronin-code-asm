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

module Ronin
  module ASM
    class Literal < Struct.new(:value, :width)

      def initialize(value,width=nil)
        value   = value.to_i
        width ||= case value
                  when (0x100000000..0xffffffffffffffff),
                       (-0x7fffffffffffffff..-0x800000000) then 8
                  when (0x10000..0xffffffff),
                       (-0x7fffffff..-0x80000)             then 4
                  when (0x100..0xffff), (-0x7fff..-0x80)   then 2
                  when (0..0xff), (-0x7f..0)               then 1
                  end

        super(value,width)
      end

      def to_i
        self.value
      end

      def to_s
        self.value.to_s
      end

    end
  end
end
