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

require 'ronin/code/emittable'

module Ronin
  module Code
    module ASM
      module Emittable
        include Code::Emittable

        def initialize(style)
          @style = style
        end

        protected

        def emit_hexidecimal(i)
          if @program.syntax == :intel
            hex = ("%xh" % i)

            if hex[0..0] =~ /[a-f]/
              hex = "0#{hex}"
            end

            return [hex]
          end

          return ["$0x%x" % i]
        end

        def emit_decimal(i)
          if @style.syntax == :intel
            return ["%d" % i]
          end

          return ["$%d" % i]
        end

        def emit_octal(i)
          if @style.syntax == :intel
            return ["0%o" % i]
          end

          return ["$0%o" % i]
        end

        def emit_binary(i)
          if @style.syntax == :intel
            return ["%bb" % i]
          end

          return ["$0b%b" % i]
        end

        def emit_string(text)
          [text.to_s.dump]
        end

      end
    end
  end
end
