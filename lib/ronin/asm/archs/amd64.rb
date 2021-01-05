#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-asm.
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>
#

require 'ronin/asm/archs/x86'

module Ronin
  module ASM
    module Archs
      #
      # Contains AMD64 Archtecture information.
      #
      module AMD64
        include X86

        # Default word size
        WORD_SIZE = 8

        # AMD64 registers
        REGISTERS = X86::REGISTERS.merge(
          rax: Register.new(:rax, 8, true),
          rbx: Register.new(:rbx, 8, true),
          rcx: Register.new(:rcx, 8, true),
          rdx: Register.new(:rdx, 8, true),

          rsi: Register.new(:rsi, 8, true),
          rdi: Register.new(:rdi, 8, true),

          rsp: Register.new(:rsp, 8, true),
          rbp: Register.new(:rbp, 8, true),

          r8b: Register.new(:r8b, 1, true),
          r8w: Register.new(:r8w, 2, true),
          r8d: Register.new(:r8d, 4, true),
          r8:  Register.new(:r8, 8, true),

          r9b: Register.new(:r9b, 1, true),
          r9w: Register.new(:r9w, 2, true),
          r9d: Register.new(:r9d, 4, true),
          r9:  Register.new(:r9, 8, true),

          r10b: Register.new(:r10b, 1, true),
          r10w: Register.new(:r10w, 2, true),
          r10d: Register.new(:r10d, 4, true),
          r10:  Register.new(:r10, 8, true),

          r11b: Register.new(:r11b, 1, true),
          r11w: Register.new(:r11w, 2, true),
          r11d: Register.new(:r11d, 4, true),
          r11:  Register.new(:r11, 8, true),

          r12b: Register.new(:r12b, 1, true),
          r12w: Register.new(:r12w, 2, true),
          r12d: Register.new(:r12d, 4, true),
          r12:  Register.new(:r12, 8, true),

          r13b: Register.new(:r13b, 1, true),
          r13w: Register.new(:r13w, 2, true),
          r13d: Register.new(:r13d, 4, true),
          r13:  Register.new(:r13, 8, true),

          r14b: Register.new(:r14b, 1, true),
          r14w: Register.new(:r14w, 2, true),
          r14d: Register.new(:r14d, 4, true),
          r14:  Register.new(:r14, 8, true),

          r15b: Register.new(:r15b, 1, true),
          r15w: Register.new(:r15w, 2, true),
          r15d: Register.new(:r15d, 4, true),
          r15:  Register.new(:r15, 8, true),

          rip: Register.new(:rip, 8, true)
        )

        #
        # Generates the instruction to invoke a syscall.
        #
        def syscall; instruction(:syscall); end
      end
    end
  end
end
