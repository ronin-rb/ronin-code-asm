require 'ronin/code/asm/source_file'

require 'spec_helper'
require 'code/asm/helpers/files'

describe Code::ASM::SourceFile do
  include Helpers::Files

  describe "parse_metadata" do
    it "should not be loaded if there is no top comment" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.arch.should == nil
      file.machine.should == nil
      file.os.should == nil
    end

    it "should parse GAS comments" do
      file = Code::ASM::SourceFile.new(assembly_file(:simple))

      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should parse NASM comments" do
      file = Code::ASM::SourceFile.new(assembly_file(:simple_nasm))

      file.parser.should == :nasm
      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should parse the YAML hash out of the first comment block" do
      file = Code::ASM::SourceFile.new(assembly_file(:simple))

      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should ignore leading and trailing padding comment-lines" do
      file = Code::ASM::SourceFile.new(assembly_file(:padding_comments))

      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should ignore leading and trailing empty-space" do
      file = Code::ASM::SourceFile.new(assembly_file(:empty_space))

      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should ignore leading and trailing white-space" do
      file = Code::ASM::SourceFile.new(assembly_file(:white_space))

      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should accept both String and Symbol keys" do
      file = Code::ASM::SourceFile.new(assembly_file(:symbol_keys))

      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end
  end

  describe "initialize" do
    it "should default the parser" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.parser.should == Code::ASM::SourceFile::DEFAULT_PARSER
    end

    it "should default the preproc" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.preproc.should == Code::ASM::SourceFile::DEFAULT_PREPROCESSOR
    end

    it "should infer the parser from the :syntax option" do
      file = Code::ASM::SourceFile.new(
        assembly_file(:blank),
        :syntax => :att
      )

      file.parser.should == :gas

      file = Code::ASM::SourceFile.new(
        assembly_file(:blank),
        :syntax => :intel
      )

      file.parser.should == :nasm
    end

    it "should infer the arch from the :machine option" do
      file = Code::ASM::SourceFile.new(
        assembly_file(:blank),
        :machine => :amd64
      )

      file.arch.should == :x86
    end
  end
end
