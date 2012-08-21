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
    let(:name) { :_start }

    it "should return the label name" do
      subject.label(name).should == name
    end

    it "should add the label to the instructions" do
      subject.label(name)

      subject.instructions.last.should == name
    end

    it "should accept a block" do
      subject.label(name) do
        subject.instruction :push, 2
      end

      subject.instructions[-1].name.should == :push
      subject.instructions[-2].should == name
    end
  end

  describe "#to_asm" do
    subject do
      described_class.new do
        push eax
        push ebx
        push ecx

        mov eax, ebx
        mov eax[0], ebx
        mov eax[4], ebx
        mov eax[esi], ebx
        mov eax[esi,4], ebx
        mov eax[esi,4]+10, ebx
      end
    end

    it "should convert the program to ATT syntax" do
      subject.to_asm.should == [
        "_start:",
        "\tpushl\t%eax",
        "\tpushl\t%ebx",
        "\tpushl\t%ecx",
        "\tmovl\t%eax,\t%ebx",
        "\tmovl\t(%eax),\t%ebx",
        "\tmovl\t0x4(%eax),\t%ebx",
        "\tmovl\t(%eax,%esi),\t%ebx",
        "\tmovl\t(%eax,%esi,4),\t%ebx",
        "\tmovl\t0xa(%eax,%esi,4),\t%ebx",
        ""
      ].join($/)
    end

    context "when given :intel" do
      it "should convert the program to Intel syntax" do
        subject.to_asm(:intel).should == [
          "_start:",
          "\tpush\teax",
          "\tpush\tebx",
          "\tpush\tecx",
          "\tmov\tebx,\teax",
          "\tmov\tebx,\t[eax]",
          "\tmov\tebx,\t[eax+0x4]",
          "\tmov\tebx,\t[eax+esi]",
          "\tmov\tebx,\t[eax+esi*0x4]",
          "\tmov\tebx,\t[eax+esi*0x4+0xa]",
          ""
        ].join($/)
      end
    end
  end

  describe "#assemble" do
  end
end
