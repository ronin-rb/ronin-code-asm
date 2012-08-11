require 'spec_helper'
require 'ronin/asm/program'

describe ASM::Program do
  describe "#arch" do
    it "should default to :x86" do
      subject.arch.should == :x86
    end
  end

  describe "#reg" do
    it "should return a Register" do
      subject.reg(:eax).should be_kind_of(ASM::Register)
    end

    it "should allocate the register" do
      subject.reg(:ebx)

      subject.allocated_registers.should include(:ebx)
    end

    context "when given an unknown register name" do
      it "should raise an ArgumentError" do
        lambda {
          subject.reg(:foo)
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#instruction" do
    it "should return an Instruction" do
      subject.instruction(:hlt).should be_kind_of(ASM::Instruction)
    end

    it "should append the new Instruction" do
      subject.instruction(:push, 1)

      subject.instructions.last.name.should == :push
    end
  end

  describe "#byte" do
    it "should return a Literal" do
      subject.byte(1).should be_kind_of(ASM::Literal)
    end

    it "should have width of 1" do
      subject.byte(1).width.should == 1
    end
  end

  describe "#word" do
    it "should return a Literal" do
      subject.word(1).should be_kind_of(ASM::Literal)
    end

    it "should have width of 2" do
      subject.word(1).width.should == 2
    end
  end

  describe "#dword" do
    it "should return a Literal" do
      subject.dword(1).should be_kind_of(ASM::Literal)
    end

    it "should have width of 4" do
      subject.dword(1).width.should == 4
    end
  end

  describe "#qword" do
    it "should return a Literal" do
      subject.qword(1).should be_kind_of(ASM::Literal)
    end

    it "should have width of 8" do
      subject.qword(1).width.should == 8
    end
  end

  describe "#label" do
  end

  describe "#to_asm" do
    context "with intel syntax" do
    end
  end

  describe "#assemble" do
  end
end
