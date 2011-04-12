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

require 'ronin/code/asm/source_file'
require 'ronin/gen/file_generator'
require 'ronin/asm/config'

require 'yaml'

module Ronin
  module Gen
    module Generators
      module Asm
        #
        # Generates an empty assembly source-file.
        #
        class SourceFile < FileGenerator

          # The default ASM syntax to use
          DEFAULT_SYNTAX = Code::ASM::SourceFile::DEFAULT_SYNTAX

          # The default preprocessor to use with `yasm`
          DEFAULT_PREPROC = Code::ASM::SourceFile::DEFAULT_PREPROC

          # The default architecture to assemble for
          DEFAULT_ARCH = Code::ASM::SourceFile::DEFAULT_ARCH

          # The default machine to assemble against
          DEFAULT_MACHINE = Code::ASM::SourceFile::DEFAULT_MACHINE

          # The assembly source-file template
          FILE_TEMPLATE = File.join('ronin','gen','asm','source_file.s.erb')

          class_option :syntax, :default => DEFAULT_SYNTAX
          class_option :preproc, :default => DEFAULT_PREPROC
          class_option :arch, :default => DEFAULT_ARCH
          class_option :machine, :default => DEFAULT_MACHINE

          #
          # Sets various defaults.
          #
          def setup
            @comment = case options[:syntax]
                      when 'intel'
                        ';'
                      when 'att'
                        '#'
                      end

            @metadata = YAML.dump({
              'arch' => options[:arch],
              'machine' => options[:machine],
              'syntax' => options[:syntax],
              'preproc' => options[:preproc]
            })
          end

          #
          # Generates the assembly source-file.
          #
          def generate
            erb FILE_TEMPLATE, self.path
          end

          protected

          #
          # Generates a assembly comment.
          #
          # @param [String] text
          #   The text for the assembly comment.
          #
          # @return [String]
          #   The comment.
          #
          def comment(text)
            "#{@comment} #{text.rstrip}"
          end

          #
          # Generates an assembly comment-block.
          #
          # @param [String] text
          #   The text of the assembly comment-block.
          #
          # @return [String]
          #   The comment-block.
          #
          def comment_block(text)
            output = [comment('')]
            text.each_line { |line| output << comment(line) }
            output << comment('')

            return output.join($/)
          end

          #
          # Generates indented assembly source-code.
          #
          # @param [String] code
          #   The assembly code to indent.
          #
          # @return [String]
          #   The indented assembly source-code.
          #
          def indent(code='')
            "\t#{code}"
          end

        end
      end
    end
  end
end
