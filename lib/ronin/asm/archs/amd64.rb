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

require 'ronin/asm/archs/x86'

module Ronin
  module ASM
    module Archs
      module AMD64
        include X86

        #
        # The `rax` 64bit register.
        #
        # @return [Register]
        #
        def rax; reg(:rax); end

        #
        # The `rbx` 64bit register.
        #
        # @return [Register]
        #
        def rbx; reg(:rbx); end

        #
        # The `rcx` 64bit register.
        #
        # @return [Register]
        #
        def rcx; reg(:rcx); end

        #
        # The `rdx` 64bit register.
        #
        # @return [Register]
        #
        def rdx; reg(:rdx); end

        #
        # The `rsp` 64bit register.
        #
        # @return [Register]
        #
        def rbp; reg(:rbp); end

        #
        # The `rsp` 64bit register.
        #
        # @return [Register]
        #
        def rsp; reg(:rsp); end

        #
        # The `rsi` 64bit register.
        #
        # @return [Register]
        #
        def rsi; reg(:rsi); end

        #
        # The `rdi` 64bit register.
        #
        # @return [Register]
        #
        def rdi; reg(:rdi); end

        #
        # The `r8` 64bit register.
        #
        # @return [Register]
        #
        def r8;  reg(:r8); end

        #
        # The `r9` 64bit register.
        #
        # @return [Register]
        #
        def r9;  reg(:r9); end

        #
        # The `r10` 64bit register.
        #
        # @return [Register]
        #
        def r10; reg(:r10); end

        #
        # The `r11` 64bit register.
        #
        # @return [Register]
        #
        def r11; reg(:r11); end

        #
        # The `r12` 64bit register.
        #
        # @return [Register]
        #
        def r12; reg(:r12); end

        #
        # The `r13` 64bit register.
        #
        # @return [Register]
        #
        def r13; reg(:r13); end

        #
        # The `r14` 64bit register.
        #
        # @return [Register]
        #
        def r14; reg(:r14); end

        #
        # The `r15` 64bit register.
        #
        # @return [Register]
        #
        def r15; reg(:r15); end

        #
        # Generates the instruction to invoke a syscall.
        #
        def syscall_int; instruction(:syscall); end

        protected

        #
        # Initializes the program for the amd64 architecture.
        #
        def initialize_arch
          super

          general_purpose = lambda { |name|
            define_register "#{name}b", 1, true
            define_register "#{name}w", 2, true
            define_register "#{name}d", 4, true
            define_register name,       8, true
          }

          define_register :rax, 8, true
          define_register :rbx, 8, true
          define_register :rcx, 8, true
          define_register :rdx, 8, true

          define_register :rsi, 8, true
          define_register :rdi, 8, true

          define_register :rsp, 8
          define_register :rbp, 8

          general_purpose[:r8]
          general_purpose[:r9]

          general_purpose[:r10]
          general_purpose[:r11]
          general_purpose[:r12]
          general_purpose[:r13]
          general_purpose[:r14]
          general_purpose[:r15]

          define_register :rip, 8
        end
      end
    end
  end
end
