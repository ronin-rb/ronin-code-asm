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
    module Archs
      module X86
        #
        # The `al` 8bit Accumulator register.
        #
        # @return [Register]
        #
        def al;  reg(:al);  end

        #
        # The `ah` 8bit Accumulator register.
        #
        # @return [Register]
        #
        def ah;  reg(:ah);  end

        #
        # The `ax` 16bit Accumulator register.
        #
        # @return [Register]
        #
        def ax;  reg(:ax);  end

        #
        # The `eax` 32bit Accumulator register.
        #
        # @return [Register]
        #
        def eax; reg(:eax); end

        #
        # The `bl` 8bit Base register.
        #
        # @return [Register]
        #
        def bl;  reg(:bl);  end

        #
        # The `bh` 8bit Base register.
        #
        # @return [Register]
        #
        def bh;  reg(:bh);  end

        #
        # The `bx` 16bit Base register.
        #
        # @return [Register]
        #
        def bx;  reg(:bx);  end

        #
        # The `ebx` 32bit Base register.
        #
        # @return [Register]
        #
        def ebx; reg(:ebx); end

        #
        # The `cl` 8bit Counter register.
        #
        # @return [Register]
        #
        def cl;  reg(:cl);  end

        #
        # The `ch` 8bit Counter register.
        #
        # @return [Register]
        #
        def ch;  reg(:ch);  end

        #
        # The `cx` 16bit Counter register.
        #
        # @return [Register]
        #
        def cx;  reg(:cx);  end

        #
        # The `ecx` 32bit Counter register.
        #
        # @return [Register]
        #
        def ecx; reg(:ecx); end

        #
        # The `dl` 8bit Data register.
        #
        # @return [Register]
        #
        def dl;  reg(:dl);  end

        #
        # The `dh` 8bit Data register.
        #
        # @return [Register]
        #
        def dh;  reg(:dh);  end

        #
        # The `dx` 16bit Data register.
        #
        # @return [Register]
        #
        def dx;  reg(:dx);  end

        #
        # The `edx` 32bit Data register.
        #
        # @return [Register]
        #
        def edx; reg(:edx); end

        #
        # The `sb` 16bit Stack Base Pointer register.
        #
        # @return [Register]
        #
        def sb;  reg(:sb); end

        #
        # The `esb` 32bit Stack Base Pointer register.
        #
        # @return [Register]
        #
        def esb; reg(:esb); end

        #
        # The `sp` 16bit Stack Pointer register.
        #
        # @return [Register]
        #
        def sp;  reg(:sp); end

        #
        # The `esp` 32bit Stack Pointer register.
        #
        # @return [Register]
        #
        def esp; reg(:esp); end

        #
        # The `ip` 16bit Instruction Pointer register.
        #
        # @return [Register]
        #
        def ip;  reg(:ip); end

        #
        # The `eip` 32bit Instruction Pointer register.
        #
        # @return [Register]
        #
        def eip; reg(:eip); end

        #
        # The `sil` 8bit Source Index register.
        #
        # @return [Register]
        #
        def sil; reg(:sil); end

        #
        # The `si` 16bit Source Index register.
        #
        # @return [Register]
        #
        def si;  reg(:si); end

        #
        # The `esi` 32bit Source Index register.
        #
        # @return [Register]
        #
        def esi; reg(:esi); end

        #
        # The `dil` 8bit Destination Index register.
        #
        # @return [Register]
        #
        def dil; reg(:dil); end

        #
        # The `di` 16bit Destination Index register.
        #
        # @return [Register]
        #
        def di;  reg(:di); end

        #
        # The `edi` 32bit Destination Index register.
        #
        # @return [Register]
        #
        def edi; reg(:edi); end

        #
        # The `cs` 16bit Code Segment register.
        #
        # @return [Register]
        #
        def cs; reg(:cs); end

        #
        # The `ds` 16bit Data Segment register.
        #
        # @return [Register]
        #
        def ds; reg(:ds); end

        #
        # The `es` 16bit Auxiliary Segment register.
        #
        # @return [Register]
        #
        def es; reg(:es); end

        #
        # The `fs` 16bit Auxiliary Segment register.
        #
        # @return [Register]
        #
        def fs; reg(:fs); end

        #
        # The `fs` 16bit Auxiliary Segment register.
        #
        # @return [Register]
        #
        def gs; reg(:gs); end

        #
        # The `ss` 16bit Stack Segment register.
        #
        # @return [Register]
        #
        def ss; reg(:ss); end

        #
        # Generates the instruction to invoke a syscall.
        #
        def syscall; instruction(:int, 0x80); end

        #
        # The Stack Base Pointer register.
        #
        # @see ebp
        #
        def stack_base; ebp; end

        #
        # The Stack Pointer register.
        #
        # @see esp
        #
        def stack_pointer; esp; end

        #
        # Generates the instruction to push a value onto the Stack.
        #
        # @param [ImmediateOperand, MemoryOperate, Register, Integer, Symbol] op
        #   The value.
        #
        def stack_push(op); instruction(:push,op); end

        #
        # Generates the instruction to pop a value off of the Stack.
        #
        # @param [Register] op
        #   The register operand to store the value.
        #
        def stack_pop(op); instruction(:pop,op); end

        #
        # Generates the instruction to clear a register.
        #
        # @param [Symbol] name
        #   The name of the register.
        #
        def reg_clear(name); instruction(:xor,reg(name),reg(name)); end

        #
        # Generates the instruction to set a register.
        # 
        # @param [ImmediateOperand, MemoryOperate, Register, Integer, Symbol] value
        #   The value to set.
        #
        # @param [Symbol] name
        #   The name of the register.
        #
        def reg_set(value,name); instruction(:mov,value,reg(name)); end

        #
        # Generates the instruction to save a register.
        # 
        # @param [Symbol] name
        #   The name of the register.
        #
        def reg_save(name); stack_push(reg(name)); end

        #
        # Generates the instruction to restore a register.
        # 
        # @param [Symbol] name
        #   The name of the register.
        #
        def reg_load(name); stack_pop(reg(name)); end

        protected

        #
        # Initializes the program for the x86 architecture.
        #
        def initialize_arch
          general_purpose = lambda { |name|
            define_register "#{name}l",  1
            define_register "#{name}h",  1
            define_register "#{name}x",  2
            define_register "e#{name}x", 4, true
          }

          general_purpose[:a]
          general_purpose[:b]
          general_purpose[:c]
          general_purpose[:d]

          define_register :sil, 1
          define_register :si,  2
          define_register :esi, 4, true

          define_register :dil, 1
          define_register :di,  2
          define_register :edi, 4, true

          define_register :bpl, 1
          define_register :bp,  2
          define_register :ebp, 4

          define_register :spl, 1
          define_register :sp,  2
          define_register :esp, 4

          define_register :cs, 2
          define_register :ds, 2
          define_register :es, 2
          define_register :fs, 2
          define_register :gs, 2
          define_register :ss, 2

          define_register :eip, 4
        end

      end
    end
  end
end
