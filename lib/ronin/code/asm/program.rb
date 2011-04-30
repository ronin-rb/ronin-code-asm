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

require 'ronin/code/asm/archs'
require 'ronin/code/asm/register'
require 'ronin/code/asm/instruction'
require 'ronin/code/asm/syntax'

require 'tempfile'
require 'yasm/program'

module Ronin
  module Code
    module ASM
      class Program

        # The targeted architecture
        attr_reader :arch

        # The targeted Operating System
        attr_reader :os

        # The registers used by the program
        attr_reader :registers

        # The instructions of the program
        attr_reader :instructions

        # Supported Assembly Syntaxs
        SYNTAX = {
          :att => Syntax::ATT,
          :intel => Syntax::Intel
        }

        PARSERS = {
          :att => :gas,
          :intel => :nasm
        }

        #
        # Initializes a new Assembly Program.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String, Symbol] :arch (:x86)
        #   The architecture of the Program.
        #
        # @option options [Hash{Symbol => Object}] :variables
        #   Variables to set in the program.
        #
        # @yield []
        #   The given block will be evaluated within the program.
        #
        # @example
        #   Program.new(:arch => :amd64) do
        #     push  rax
        #     push  rbx
        #
        #     mov   rsp,     rax
        #     mov   rax[8],  rbx
        #   end
        #
        def initialize(options={},&block)
          @arch = options.fetch(:arch,:x86).to_sym
          @os = options[:os]

          extend Archs.require_const(@arch)

          @register_table = {}
          @instructions = []

          if options[:variables]
            options[:varibles].each do |name,value|
              instance_variable_set("@#{name}",value)
            end
          end

          eval(&block) if block
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
        def register(name,width)
          @register_table[name.to_sym] ||= Register.new(name.to_sym,width)
        end

        #
        # Adds a new instruction to the program.
        #
        # @param [String, Symbol] name
        #
        # @param [Array] operands
        #
        def instruction(name,*operands)
          @instructions << Instruction.new(name.to_sym,operands)
        end

        #
        # Adds a label to the program.
        #
        # @param [Symbol, String] name
        #   The name of the label.
        #
        # @yield []
        #   The given block will be evaluated after the label has been added.
        #
        def label(name)
          @instructions << name.to_sym

          yield if block_given?
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
        # @param [Symbol, String] syntax
        #   The syntax to compile the program to.
        #
        def to_asm(syntax=:att)
          SYNTAX[syntax].emit_program(self)
        end

        #
        # Assembles the program.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Symbol, String] :syntax (:att)
        #   The syntax to compile the program to.
        #
        # @return [String]
        #   The raw Object Code of the program.
        #
        def assemble(options={})
          syntax = options.fetch(:syntax,:att)
          parser = PARSERS[syntax]
          objcode = nil

          Tempfile.open('ronin-asm.S') do |file|
            file.write(to_asm(syntax))

            Tempfile.open('ronin-asm.o') do |output|
              YASM::Program.assemble(:file => file.path,
                                     :parser => PARSERS[syntax],
                                     :target => @arch,
                                     :output_format => :bin,
                                     :output => output.path)

              objcode = output.read
            end
          end

          return objcode
        end

        protected

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
            instruction(name,*arguments)
          else
            super(name,*arguments,&block)
          end
        end

      end
    end
  end
end
