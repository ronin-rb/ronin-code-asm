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

require 'ronin/ui/command_line/command'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Rop < Command

          desc "Parses code for Return Orientated Programming (ROP) Gadgets"
          class_option :file, :type => :string, :aliases => '-f'
          class_option :max_fragments, :type => :integer, :banner => 'MAX', :aliases => '-F'
          class_option :max_gadgets, :type => :integer, :banner => 'MAX', :aliases => '-G'
          class_option :base, :type => :integer, :banner => '0xdeadface', :aliases => '-b'
          class_option :verbose, :type => :boolean, :aliases => '-v'

          def execute
          end

        end
      end
    end
  end
end
