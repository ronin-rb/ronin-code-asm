# frozen_string_literal: true
#
# ronin-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative 'arch'
require_relative 'os'
require_relative 'register'
require_relative 'instruction'
require_relative 'immediate_operand'
require_relative 'label'
require_relative 'syntax'

require 'tempfile'
require 'yasm/program'

module Ronin
  module ASM
    #
    # Represents a full Assembly program.
    #
    class Program

      # Supported Assembly Syntaxs
      SYNTAX = {
        att:   Syntax::ATT,
        intel: Syntax::Intel
      }

      # Mapping of architecture IDs to modules.
      ARCHES = {
        x86:    Arch::X86,
        x86_64: Arch::X86_64,
        amd64:  Arch::X86_64
      }

      # Mapping of Operating System names and modules.
      OSES = {
        linux:   OS::Linux,
        freebsd: OS::FreeBSD
      }

      # The Assembly Parsers
      PARSERS = {
        att:   :gas,
        intel: :nasm
      }

      # The targeted architecture
      #
      # @return [Symbol]
      attr_reader :arch

      # The targeted Operating System
      #
      # @return [Symbol, nil]
      attr_reader :os

      # The default word size
      #
      # @return [Integer]
      attr_reader :word_size

      # The registers available to the program
      #
      # @return [Hash{Symbol => Register}]
      #   The names and registers.
      attr_reader :registers

      # The syscalls available to the program
      #
      # @return [Hash{Symbol => Integer}]
      #   The syscall names and numbers.
      attr_reader :syscalls

      # The registers used by the program
      #
      # @return [Array<Symbol>]
      attr_reader :allocated_registers

      # The instructions of the program
      #
      # @return [Array<Instruction>]
      attr_reader :instructions

      #
      # Initializes a new Assembly Program.
      #
      # @param [Symbol] arch
      #   The Architecture to target.
      #
      # @param [Symbol, nil] os
      #   The Operating System to target.
      #
      # @param [Hash{Symbol => Object}] define
      #   Constants to define in the program.
      #
      # @yield []
      #   The given block will be evaluated within the program.
      #
      # @raise [ArgumentError]
      #   An invalid `arch:` or `os:` keyword argument value was given.
      #
      # @example
      #   Program.new(arch: :x86) do
      #     push  rax
      #     push  rbx
      #
      #     mov   rsp,     rax
      #     mov   rax[8],  rbx
      #   end
      #
      def initialize(arch: :x86_64, os: nil, define: {}, &block)
        initialize_arch(arch)

        if os
          initialize_os(os)
        else
          @syscalls = {}
        end

        define.each do |name,value|
          instance_variable_set("@#{name}",value)
        end

        @allocated_registers = []
        @instructions = []

        instance_eval(&block) if block
      end

      private

      #
      # Initializes the architecture metadata for the program.
      #
      # @param [:x86, :x86_64, :amd64] arch
      #   The architecture name.
      #
      # @api private
      #
      def initialize_arch(arch)
        @arch = arch

        arch_module = ARCHES.fetch(arch) do
          raise(ArgumentError,"unknown architecture: #{arch.inspect}")
        end

        @word_size = arch_module::WORD_SIZE
        @registers = arch_module::REGISTERS

        extend arch_module
      end

      #
      # Initializes the Operating System metadata for the program.
      #
      # @param [:linux, :freebsd] os
      #   The OS name.
      #
      # @api private
      #
      def initialize_os(os)
        @os = os

        os_module = OSES.fetch(os) do
          raise(ArgumentError,"unknown OS: #{os.inspect}")
        end

        @syscalls = os_module::SYSCALLS

        extend os_module
      end

      public

      #
      # Determines if a register exists.
      #
      # @param [Symbol] name
      #   The name of the register.
      #
      # @return [Boolean]
      #   Specifies whether the register exists.
      #
      def register?(name)
        @registers.has_key?(name.to_sym)
      end

      #
      # Accesses a register.
      #
      # @param [String, Symbol] name
      #   The name of the register.
      #
      # @return [Register]
      #   The register.
      #
      # @raise [ArgumentError]
      #   The register could not be found.
      #
      def register(name)
        name = name.to_sym

        unless register?(name)
          raise(ArgumentError,"unknown register: #{name}")
        end

        unless @allocated_registers.include?(name)
          # mark the register as being used, when it was first accessed
          @allocated_registers << name
        end

        return @registers[name]
      end

      #
      # Adds a new instruction to the program.
      #
      # @param [String, Symbol] name
      #
      # @param [Array] operands
      #
      # @param [String, nil] comment
      #   Optional comment for the instruction.
      #
      # @return [Instruction]
      #   The newly created instruction.
      #
      def instruction(name,*operands, comment: nil)
        insn = Instruction.new(name.to_sym,operands, comment: comment)

        @instructions << insn
        return insn
      end

      #
      # Creates an operand of size 1 (byte).
      #
      # @param [MemoryOperand, Integer] op
      #   The value of the operand.
      #
      # @return [MemoryOperand, ImmediateOperand]
      #   The new operand value.
      #
      def byte(op)
        case op
        when MemoryOperand
          MemoryOperand.new(op.base,op.offset,op.index,op.scale,1)
        else
          ImmediateOperand.new(op,1)
        end
      end

      #
      # Creates a operand of size 2 (bytes).
      #
      # @param [MemoryOperand, Integer] op
      #   The value of the operand.
      #
      # @return [MemoryOperand, ImmediateOperand]
      #   The new operand value.
      #
      def word(op)
        case op
        when MemoryOperand
          MemoryOperand.new(op.base,op.offset,op.index,op.scale,2)
        else
          ImmediateOperand.new(op,2)
        end
      end

      #
      # Creates a operand of size 4 (bytes).
      #
      # @param [MemoryOperand, Integer] op
      #   The value of the operand.
      #
      # @return [ImmediateOperand]
      #   The new operand value.
      #
      def dword(op)
        case op
        when MemoryOperand
          MemoryOperand.new(op.base,op.offset,op.index,op.scale,4)
        else
          ImmediateOperand.new(op,4)
        end
      end

      #
      # Creates a operand of size 8 (bytes).
      #
      # @param [MemoryOperand, Integer] op
      #   The value of the operand.
      #
      # @return [MemoryOperand, ImmediateOperand]
      #   The new operand.
      #
      def qword(op)
        case op
        when MemoryOperand
          MemoryOperand.new(op.base,op.offset,op.index,op.scale,8)
        else
          ImmediateOperand.new(op,8)
        end
      end

      #
      # Adds a label to the program.
      #
      # @param [Symbol, String] name
      #   The name of the label.
      #
      # @yield []
      #   If a block is given, it will be evaluated after the label has been
      #   added.
      #
      # @return [Label]
      #   The new label.
      #
      def label(name,&block)
        new_label = Label.new(name.to_s)

        @instructions << new_label
        instance_eval(&block) if block
        return new_label
      end

      #
      # Generic method for generating the instruction for causing an interrupt.
      #
      # @param [Integer] number
      #   The interrupt number to call.
      #
      # @abstract
      #
      def interrupt(number)
      end

      #
      # Generic method for generating the instruction for invoking a syscall.
      #
      # @abstract
      #
      def syscall
      end

      #
      # Generic method for pushing onto the stack.
      #
      # @param [Register, Integer] value
      #   The value to push.
      #
      # @abstract
      #
      def stack_push(value)
      end

      #
      # Generic method for popping off the stack.
      #
      # @param [Symbol] name
      #   The name of the register.
      #
      # @abstract
      #
      def stack_pop(name)
      end

      #
      # Generic method for clearing a register.
      #
      # @param [Symbol] name
      #   The name of the register.
      #
      # @abstract
      #
      def register_clear(name)
      end

      #
      # Generic method for setting a register.
      #
      # @param [Symbol] name
      #   The name of the register.
      #
      # @param [Register, ImmediateOperand, Integer] value
      #   The new value for the register.
      #
      # @abstract
      #
      def register_set(name,value)
      end

      #
      # Generic method for saving a register.
      #
      # @param [Symbol] name
      #   The name of the register.
      #
      # @abstract
      #
      def register_save(name)
      end

      #
      # Generic method for loading a register.
      #
      # @param [Symbol] name
      #   The name of the register.
      #
      # @abstract
      #
      def register_load(name)
      end

      #
      # Defines a critical region, where the specified Registers
      # should be saved and then reloaded.
      #
      # @param [Array<Symbol>] regs
      #   The registers to save and reload.
      #
      # @yield []
      #   The given block will be evaluated after the registers
      #   have been saved.
      #
      def critical(*regs,&block)
        regs.each { |name| register_save(name) }

        instance_eval(&block)

        regs.reverse_each { |name| register_load(name) }
      end

      #
      # Evaluates code within the Program.
      #
      # @yield []
      #   The code to evaluate.
      #
      def eval(&block)
        instance_eval(&block)
      end

      #
      # Converts the program to Assembly Source Code.
      #
      # @param [Symbol] syntax
      #   The syntax to compile the program to.
      #
      def to_asm(syntax=:intel)
        SYNTAX[syntax].emit_program(self)
      end

      #
      # @see #to_s
      #
      def to_s
        to_asm
      end

      #
      # Assembles the program.
      #
      # @param [String] output
      #   The path for the assembled program.
      #
      # @param [Symbol, String] syntax
      #   The syntax to compile the program to.
      #
      # @param [Symbol] format
      #   The format of the assembled executable. May be one of:
      #
      #   * `:dbg` - Trace of all info passed to object format module.
      #   * `:bin` - Flat format binary.
      #   * `:dosexe` - DOS .EXE format binary.
      #   * `:elf` - ELF.
      #   * `:elf32` - ELF (32-bit).
      #   * `:elf64` - ELF (64-bit).
      #   * `:coff` - COFF (DJGPP).
      #   * `:macho` - Mac OS X ABI Mach-O File Format.
      #   * `:macho32` - Mac OS X ABI Mach-O File Format (32-bit).
      #   * `:macho64` - Mac OS X ABI Mach-O File Format (64-bit).
      #   * `:rdf` - Relocatable Dynamic Object File Format (RDOFF) v2.0.
      #   * `:win32` - Win32.
      #   * `:win64` / `:x64` - Win64.
      #   * `:xdf` - Extended Dynamic Object.
      #
      # @return [String]
      #   The path to the assembled program.
      #
      # @raise [ArgumentError]
      #   The given syntax was not `:intel` or `:att`.
      #
      def assemble(output, syntax: :intel, format: :bin)
        parser = PARSERS.fetch(syntax) do
          raise(ArgumentError,"unknown ASM syntax: #{syntax.inspect}")
        end

        source = Tempfile.new(['ronin-asm', '.s'])
        source.write(to_asm(syntax))
        source.close

        YASM::Command.run(
          file:          source.path,
          parser:        parser,
          target:        @arch,
          output_format: format,
          output:        output
        )

        return output
      end

      protected

      # undefine the syscall method, so method_missing handles it
      undef syscall

      #
      # Allows adding unknown instructions to the program.
      #
      # @param [Symbol] name
      #   The name of the instruction.
      #
      # @param [Array] arguments
      #   Additional operands.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def method_missing(name,*arguments,**kwargs,&block)
        if (block && arguments.empty? && kwargs.empty?)
          label(name,&block)
        elsif block.nil?
          if (arguments.empty? && register?(name))
            register(name)
          else
            instruction(name,*arguments,**kwargs)
          end
        else
          super(name,*arguments,&block)
        end
      end

    end
  end
end
