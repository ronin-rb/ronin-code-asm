require 'ronin/code/asm/source_file'

require 'spec_helper'
require 'code/asm/helpers/files'

describe Code::ASM::SourceFile do
  include Helpers::Files

  describe "parse_metadata" do
    it "should not be loaded if there is no top comment" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.arch.should == Code::ASM::SourceFile::DEFAULT_ARCH
      file.machine.should == Code::ASM::SourceFile::DEFAULT_MACHINE
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

      file.syntax.should == :intel
      file.arch.should == :x86
      file.machine.should == :x86
      file.os.should == 'Linux'
    end

    it "should ignore comment-blocks lacking a YAML header" do
      file = Code::ASM::SourceFile.new(assembly_file(:no_yaml_header))

      file.arch.should == Code::ASM::SourceFile::DEFAULT_ARCH
      file.machine.should == Code::ASM::SourceFile::DEFAULT_MACHINE
      file.os.should == nil
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
    it "should default the syntax" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.syntax.should == Code::ASM::SourceFile::DEFAULT_SYNTAX
    end

    it "should default the preproc" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.preproc.should == Code::ASM::SourceFile::DEFAULT_PREPROC
    end

    it "should default the arch" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.arch.should == Code::ASM::SourceFile::DEFAULT_ARCH
    end

    it "should default the machine" do
      file = Code::ASM::SourceFile.new(assembly_file(:blank))

      file.machine.should == Code::ASM::SourceFile::DEFAULT_MACHINE
    end
  end
end
