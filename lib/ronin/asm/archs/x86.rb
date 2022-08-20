#
# ronin-asm - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-asm.
#
# ronin-asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-asm.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/asm/register'

module Ronin
  module ASM
    module Archs
      #
      # Contains X86 Archtecture information.
      #
      module X86
        # Default word size
        WORD_SIZE = 4

        # X86 registers
        REGISTERS = {
          al:  Register.new(:al, 1),
          ah:  Register.new(:ah, 1),
          ax:  Register.new(:ax, 2),
          eax: Register.new(:eax, 4, true),

          bl:  Register.new(:bl, 1),
          bh:  Register.new(:bh, 1),
          bx:  Register.new(:bx, 2),
          ebx: Register.new(:ebx, 4, true),

          cl:  Register.new(:cl, 1),
          ch:  Register.new(:ch, 1),
          cx:  Register.new(:cx, 2),
          ecx: Register.new(:ecx, 4, true),

          dl:  Register.new(:dl, 1),
          dh:  Register.new(:dh, 1),
          dx:  Register.new(:dx, 2),
          edx: Register.new(:edx, 4, true),

          bp:  Register.new(:bp, 2),
          ebp: Register.new(:ebp, 4),

          sp:  Register.new(:sp, 2),
          esp: Register.new(:esp, 4),

          ip:  Register.new(:ip, 2),
          eip: Register.new(:eip, 4),

          sil: Register.new(:sil, 1),
          si:  Register.new(:si, 2),
          esi: Register.new(:esi, 4, true),

          dil: Register.new(:dil, 1),
          di:  Register.new(:di, 2),
          edi: Register.new(:edi, 4, true),

          cs: Register.new(:cs, 2),
          ds: Register.new(:ds, 2),
          es: Register.new(:es, 2),
          fs: Register.new(:fs, 2),
          gs: Register.new(:gs, 2),
          ss: Register.new(:ss, 2)
        }

        #
        # Generates the instruction to trigger an interrupt.
        #
        # @param [Integer] number
        #   The interrupt number.
        #
        def interrupt(number); instruction(:int,number); end

        #
        # Generates the instruction to invoke a syscall.
        #
        def syscall; interrupt(0x80); end

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
        # @param [ImmediateOperand, MemoryOperand, Register, Integer, Symbol] op
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
        def register_clear(name)
          instruction(:xor,register(name),register(name))
        end

        #
        # Generates the instruction to set a register.
        # 
        # @param [Symbol] name
        #   The name of the register.
        #
        # @param [ImmediateOperand, MemoryOperand, Register, Integer, Symbol] value
        #   The value to set.
        #
        def register_set(name,value)
          instruction(:mov,value,register(name))
        end

        #
        # Generates the instruction to save a register.
        # 
        # @param [Symbol] name
        #   The name of the register.
        #
        def register_save(name)
          stack_push(register(name))
        end

        #
        # Generates the instruction to restore a register.
        # 
        # @param [Symbol] name
        #   The name of the register.
        #
        def register_load(name)
          stack_pop(register(name))
        end
      end
    end
  end
end
