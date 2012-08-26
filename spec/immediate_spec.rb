require 'spec_helper'

require 'ronin/asm/immediate'
require 'ronin/asm/register'

describe Immediate do
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

    it "should only accept nil and a Register for index" do
      lambda {
        described_class.new(nil,0,Object.new)
      }.should raise_error(TypeError)
    end
  end

  describe "#+" do
    let(:immediate) { described_class.new(register,4,register,2) }

    subject { immediate + 4 }

    it "should add to offset" do
      subject.offset.should == 8
    end

    it "should not change base, index or scale" do
      subject.base.should  == immediate.base
      subject.index.should == immediate.index
      subject.scale.should == immediate.scale
    end
  end

  describe "#-" do
    let(:immediate) { described_class.new(register,4,register,2) }

    subject { immediate - 2 }

    it "should subtract from offset" do
      subject.offset.should == 2
    end

    it "should not change base, index or scale" do
      subject.base.should  == immediate.base
      subject.index.should == immediate.index
      subject.scale.should == immediate.scale
    end
  end

  describe "#width" do
    subject { described_class.new(register,10) }

    it "should return the width of base" do
      subject.width.should == register.width
    end
  end
end
