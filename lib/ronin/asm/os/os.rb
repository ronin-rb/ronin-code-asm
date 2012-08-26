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

require 'ronin/asm/config'

module Ronin
  module ASM
    module OS
      #
      # Collection of all known syscalls, grouped by OS and Arch.
      #
      # @return [Hash{Symbol => Hash{Symbol => Hash{Symbol => Integer}}}]
      #   Syscall names and numbers, organized by OS then Arch.
      #
      SYSCALLS = Hash.new do |hash,os|
        hash[os] = Hash.new do |subhash,arch|
          subhash[arch] = Config.load_yaml_file(File.join(Config::DATA_DIR,os.to_s.downcase,arch.to_s,'syscalls.yml'))
        end
      end
    end
  end
end
