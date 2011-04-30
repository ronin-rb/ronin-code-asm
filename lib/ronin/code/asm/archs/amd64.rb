#
# Ronin ASM - a Ruby library for Ronin that provides dynamic Assembly (ASM)
# generation of programs or shellcode.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/asm/archs/x86'

module Ronin
  module Code
    module ASM
      module Archs
        module AMD64
          include X84

          def rax; register(:rax, 8); end
          def rbx; register(:rbx, 8); end
          def rcx; register(:rcx, 8); end
          def rdx; register(:rdx, 8); end

          def rsb; register(:rsb, 8); end
          def rsp; register(:rsp, 8); end

          def rsi; register(:rsi, 8); end
          def rdi; register(:rdi, 8); end

          def r8;  register(:r8,  8); end
          def r9;  register(:r9,  8); end
          def r10; register(:r10, 8); end
          def r11; register(:r11, 8); end
          def r12; register(:r12, 8); end
          def r13; register(:r13, 8); end
          def r14; register(:r14, 8); end
          def r15; register(:r15, 8); end

          def pushq(op); instruction(:push,8,op); end
          def popq(op);  instruction(:pop,8,op); end
          def movq(op);  instruction(:mov,8,op);  end
        end
      end
    end
  end
end
