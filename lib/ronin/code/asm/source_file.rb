#
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
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

require 'ronin/code/asm/source_code'

require 'yaml'

module Ronin
  module Code
    module ASM
      class SourceFile

        include SourceCode

        # The default ASM syntax to use
        DEFAULT_SYNTAX = :att

        # The default preprocessor to use with `yasm`
        DEFAULT_PREPROC = :nasm

        # The default architecture to assemble for
        DEFAULT_ARCH = :x86

        # The default machine to assemble against
        DEFAULT_MACHINE = :x86

        # The path to the assembly source-file
        attr_reader :path

        # The parser used in the assembly source-file
        # (`:att` or `:intel`)
        attr_reader :syntax

        # The pre-processor to run on the assembly source-file
        # (`:nasm`, `:tasm`, `:raw` or `:cpp`)
        attr_reader :preproc

        # The architecture to assemble against
        # (`:x86` or `:lc3b`)
        attr_reader :arch

        # The machine to assemble against
        # (`:x86` or `:amd64`)
        attr_reader :machine

        # The Operating System to assemble for
        # (`'Linux'`, `'FreeBSD'` or `'Windows'`)
        attr_reader :os

        #
        # Creates a new {SourceFile} object.
        #
        # @param [String] path
        #   The path to the assemble source-file.
        #
        # @param [Hash] options
        #   The options for the new source-file.
        #
        # @option options [Symbol] :syntax (DEFAULT_SYNTAX)
        #   The assembly syntax to choose the parser for.
        #
        # @option options [Symbol] :preprocessor (DEFAULT_PREPROC)
        #   The pre-processor to run on the assembly source-file,
        #   before assembling it.
        #
        # @option options [Symbol] :arch
        #   The architecture to assemble for.
        #
        # @option options [Symbol] :machine
        #   The specific machine to assemble against.
        #
        # @option options [String] :os
        #   The Operating System to assemble for.
        #
        def initialize(path,options={})
          @path = File.expand_path(path)

          @syntax = DEFAULT_SYNTAX
          @preproc = DEFAULT_PREPROC

          @arch = DEFAULT_ARCH
          @machine = DEFAULT_MACHINE
          @os = nil

          set_options = lambda { |options|
            @syntax = options[:syntax].to_sym if options[:syntax]
            @preproc = options[:preproc].to_sym if options[:preproc]

            @arch = options[:arch].to_sym if options[:arch]
            @machine = options[:machine].to_sym if options[:machine]
            @os = options[:os].to_s if options[:os]
          }

          if (metadata = parse_metadata)
            # set the options using the metadata first
            set_options.call(metadata)
          end

          # set the options based on any additional user options
          set_options.call(options)
        end

        #
        # Assembles a file using `yasm`.
        #
        # @param [Hash{Symbol => Object}] options
        #   Additional assembly options.
        #
        # @yield [yasm]
        #   If a block is given, it will be passed a task object used to
        #   specify options for yasm. 
        #
        # @yieldparam [YASM::Task] yasm
        #   The yasm task.
        #
        # @return [Boolean]
        #   Specifies whether the command exited normally. 
        #
        # @example
        #   assemble(:output => 'code.o')
        #
        # @example
        #   assemble do |yasm|
        #     yasm.output = 'code.o'
        #   end
        #
        # @see http://ruby-yasm.rubyforge.org/YASM/Program.html#assmeble-class_method
        # @see http://ruby-yasm.rubyforge.org/YASM/Task.html
        #
        def assemble(options={},&block)
          parser = case @syntax
                   when :att
                     :gas
                   when :intel
                     :nasm
                   end

          options = options.merge(
            :preprocessor => @preproc,
            :parser => parser,
            :file => @path
          )

          options[:arch] = @arch if @arch
          options[:machine] = @machine if @machine

          super(options,&block)
        end

        protected

        #
        # Parses the metadata from the first comment-block in the 
        # assembly file.
        #
        # @return [Hash]
        #   The metadata information.
        #
        def parse_metadata
          yaml_pattern = /(([;#]|\/\/)\s+)---/
          data_pattern = nil
          data_lines = []

          File.open(@path) do |file|
            file.each_line do |line|
              unless data_pattern
                if (yaml_header = line.match(yaml_pattern))
                  data_pattern = /#{yaml_header[1]}(.+)/
                end
              end

              if data_pattern
                if (data = line.match(data_pattern))
                  data_lines << data[1]
                else
                  break
                end
              end
            end
          end

          metadata = YAML.load(data_lines.join("\n"))

          if metadata.kind_of?(Hash)
            normalized_hash = {}

            # normalize the hash so all keys are Symbols
            metadata.each do |key,value|
              normalized_hash[key.to_sym] = value
            end

            return normalized_hash
          else
            return nil
          end
        end

      end
    end
  end
end
