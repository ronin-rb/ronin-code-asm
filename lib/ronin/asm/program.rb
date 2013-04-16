#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/asm/archs'
require 'ronin/asm/os'
require 'ronin/asm/register'
require 'ronin/asm/instruction'
require 'ronin/asm/immediate_operand'
require 'ronin/asm/syntax'

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

      # The Assembly Parsers
      PARSERS = {
        att:   :gas,
        intel: :nasm
      }

      # The targeted architecture
      attr_reader :arch
      
      # The syntax withwhich to use during assembly of the asm source code
      attr_reader :syntax

      # The targeted Operating System
      attr_reader :os

      # The default word size
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
      attr_reader :allocated_registers

      # The instructions of the program
      attr_reader :instructions

      #
      # Initializes a new Assembly Program.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String, Symbol] :arch (:x86)
      #   The Architecture to target.
      #
      # @option options [String, Symbol] :os
      #   The Operating System to target.
      #
      # @option options [Hash{Symbol => Object}] :define
      #   Constants to define in the program.
      #
      # @yield []
      #   The given block will be evaluated within the program.
      #
      # @example
      #   Program.new(arch: :amd64) do
      #     push  rax
      #     push  rbx
      #
      #     mov   rsp,     rax
      #     mov   rax[8],  rbx
      #   end
      #
      def initialize(options={},&block)
        @arch = options.fetch(:arch,:x86).to_sym
        @syntax = options.fetch(:syntax,:intel).to_sym

        arch = Archs.const_get(@arch.to_s.upcase)

        @word_size = arch::WORD_SIZE
        @registers = arch::REGISTERS

        extend Archs.const_get(@arch.to_s.upcase)

        @syscalls = {}

        if options.has_key?(:os)
          @os       = options[:os].to_s
          @syscalls = OS::SYSCALLS[@os][@arch]

          extend OS.const_get(@os)
        end

        if options[:define]
          options[:define].each do |name,value|
            instance_variable_set("@#{name}",value)
          end
        end

        @allocated_registers = []
        @instructions = []

        instance_eval(&block) if block
      end

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
      # @return [Instruction]
      #   The newly created instruction.
      #
      def instruction(name,*operands)
        ordered_operands = @syntax == :intel ? operands.reverse : operands
        insn = Instruction.new(name.to_sym, ordered_operands)

        @instructions << insn
        return insn
      end

      #
      # Creates an operand of size 1 (byte).
      #
      # @param [Integer] number
      #   The value of the operand.
      #
      # @return [ImmediateOperand]
      #   The new operand value.
      #
      def byte(number)
        ImmediateOperand.new(number,1)
      end

      #
      # Creates a operand of size 2 (bytes).
      #
      # @param [Integer] number
      #   The value of the operand.
      #
      # @return [ImmediateOperand]
      #   The new operand value.
      #
      def word(number)
        ImmediateOperand.new(number,2)
      end

      #
      # Creates a operand of size 4 (bytes).
      #
      # @param [Integer] number
      #   The value of the operand.
      #
      # @return [ImmediateOperand]
      #   The new operand value.
      #
      def dword(number)
        ImmediateOperand.new(number,4)
      end

      #
      # Creates a operand of size 8 (bytes).
      #
      # @param [Integer] number
      #   The value of the operand.
      #
      # @return [ImmediateOperand]
      #   The new operand.
      #
      def qword(number)
        ImmediateOperand.new(number,8)
      end

      #
      # Adds a label to the program.
      #
      # @param [Symbol, String] name
      #   The name of the label.
      #
      # @yield []
      #   The given block will be evaluated after the label has been
      #   added.
      #
      # @return [Symbol]
      #   The label name.
      #
      def label(name,&block)
        name = name.to_sym

        @instructions << name
        instance_eval(&block)
        return name
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
      #   The name of the reigster.
      #
      # @abstract
      #
      def stack_pop(name)
      end

      #
      # Generic method for clearing a register.
      #
      # @param [Symbol] name
      #   The name of the reigster.
      #
      # @abstract
      #
      def register_clear(name)
      end

      #
      # Generic method for setting a register.
      #
      # @param [Register, Immediate, Integer] value
      #   The new value for the register.
      #
      # @param [Symbol] name
      #   The name of the reigster.
      #
      # @abstract
      #
      def register_set(value,name)
      end

      #
      # Generic method for saving a register.
      #
      # @param [Symbol] name
      #   The name of the reigster.
      #
      # @abstract
      #
      def register_save(name)
      end

      #
      # Generic method for loading a register.
      #
      # @param [Symbol] name
      #   The name of the reigster.
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
      # Assembles the program.
      #
      # @param [String] output
      #   The path for the assembled program.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Symbol, String] :syntax (:intel)
      #   The syntax to compile the program to.
      #
      # @option options [Symbol] :format (:bin)
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
      def assemble(output,options={})
        syntax  = options.fetch(:syntax,:intel)
        format  = options.fetch(:format,:bin)
        parser  = PARSERS[syntax]

        source = Tempfile.new(['ronin-asm', '.s'])
        source.write(to_asm(syntax))
        source.close

        YASM::Program.assemble(
          file:          source.path,
          parser:        PARSERS[syntax],
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
      def method_missing(name,*arguments,&block)
        if (block && arguments.empty?)
          label(name,&block)
        elsif block.nil?
          if (arguments.empty? && register?(name))
            register(name)
          else
            instruction(name,*arguments)
          end
        else
          super(name,*arguments,&block)
        end
      end

    end
  end
end
