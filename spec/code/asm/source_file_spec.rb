require 'ronin/code/asm/source_file'

require 'spec_helper'
require 'code/asm/helpers/files'

describe Code::ASM::SourceFile do
  include Helpers::Files

  describe "parse_metadata" do
    it "should not be loaded if there is no top comment" do
      file = Code::ASM::SourceFile.new(assembly_file(:no_comment))

      file.arch.should == nil
      file.machine.should == nil
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
  end
end
