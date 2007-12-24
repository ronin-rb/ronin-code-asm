#
# Ronin ASM - A Ronin library providing support for ASM code generation.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/code/asm/label_block'

module Ronin
  module Code
    module ASM
      class Section < LabelBlock

        # Name of the section
        attr_reader :name

        def initialize(dialect,name,*args,&block)
          @name = name.to_sym

          super(dialect,*args,&block)
        end

        def ==(section)
          return false unless @name==section.name

          return super(section)
        end

      end
    end
  end
end
