require 'spec_helper'

require 'ronin/asm/memory_operand'
require 'ronin/asm/register'

describe MemoryOperand do
  let(:register) { Register.new(:eax, 4) }

  describe "#initialize" do
    its(:base)   { should be_nil  }
    its(:offset) { should == 0    }
    its(:index)  { should be_nil  }
    its(:scale)  { should == 1    }

    it "should only accept nil and a Register for base" do
      lambda {
        described_class.new(Object.new)
      }.should raise_error(TypeError)
    end

    it "should only accept Integers for offset" do
      lambda {
        described_class.new(register,2.0)
      }.should raise_error(TypeError)
    end

    it "should only accept nil and a Register for index" do
      lambda {
        described_class.new(register,0,Object.new)
      }.should raise_error(TypeError)
    end

    it "should only accept Integers for offset" do
      lambda {
        described_class.new(register,0,nil,2.0)
      }.should raise_error(TypeError)
    end

  end

  describe "#+" do
    let(:operand) { described_class.new(register,4,register,2) }

    subject { operand + 4 }

    it "should add to offset" do
      subject.offset.should == 8
    end

    it "should not change base, index or scale" do
      subject.base.should  == operand.base
      subject.index.should == operand.index
      subject.scale.should == operand.scale
    end
  end

  describe "#-" do
    let(:operand) { described_class.new(register,4,register,2) }

    subject { operand - 2 }

    it "should subtract from offset" do
      subject.offset.should == 2
    end

    it "should not change base, index or scale" do
      subject.base.should  == operand.base
      subject.index.should == operand.index
      subject.scale.should == operand.scale
    end
  end

  describe "#width" do
    subject { described_class.new(register,10) }

    it "should return the width of base" do
      subject.width.should == register.width
    end
  end
end
