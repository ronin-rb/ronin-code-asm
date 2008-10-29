#
#--
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/code/asm/instruction'
require 'ronin/code/asm/unary_instruction'
require 'ronin/code/asm/binary_instruction'
require 'ronin/code/asm/register'
require 'ronin/extensions/meta'

module Ronin
  module Code
    module ASM
      class Dialect

        # Symbol Table for the dialect
        attr_reader :symbols

        # Defined labels
        attr_reader :labels

        # Mapping of register names
        attr_reader :register_map

        # Defined registers
        attr_reader :registers

        def initialize(options={},&block)
          @symbols = SymbolTable.new

          @register_map = Hash.new { |hash,key| hash[key] = key }
          @registers = Hash.new { |hash,key| hash[key] = Register.new(key) }

          @instructions = []
          @labels = Hash.new { |hash,key| hash[key] = [] }
          @current_label = nil

          if options[:symbols]
            @symbols.symbols = options[:symbols]
          end

          if options[:registers]
            options[:registers].each do |name,mapped_name|
              @register_map[name] = mapped_name
            end
          end

          instance_eval(&block) if block
        end

        def Dialect.dialects
          @@dialects ||= {}
        end

        def Dialect.has_dialect?(name)
          Dialect.dialects.has_key?(name)
        end

        protected

        def self.asm_dialect(name)
          name = name.to_sym

          class_def(:name) { name }

          Dialect.dialects[name] = self
          return self
        end

        def self.instructions
          @@instructions ||= {}
        end

        def self.has_instruction?(name)
          self.instructions.has_key?(name.to_sym)
        end

        def self.instruction(name,instruction_type,options={})
          name = name.to_sym

          self.instructions[name] = instruction_type

          if instruction_type.kind_of?(UnaryInstruction)
            class_def(name) do |arg|
              self << instruction_type.new(arg)
            end
          elsif instruction_type.kind_of?(BinaryInstruction)
            class_def(name) do |left,right|
              self << instruction_type.new(left,right)
            end
          else
            class_def(name) do |*args|
              self << instruction_type.new(*args)
            end
          end

          if options[:aliases]
            options[:aliases].each do |alternant|
              alias_method(alternant,name)
            end
          end
        end

        def self.register(*names)
          names.each do |name|
            name = name.to_sym
            class_def(name) { reg(name) }
          end
        end

        def reg(name)
          registers[register_map[name]]
        end

        def deref(base,index=0,scale=1)
          Deref.new(base,index,scale)
        end

        def label(name)
          name = name.to_s

          @current_label = name
          return self
        end
      end
    end
  end
end
