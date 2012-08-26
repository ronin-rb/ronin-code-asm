require 'spec_helper'

require 'ronin/asm/register'

describe Register do
  let(:register) { described_class.new(:eax, 4) }

  subject { register }

  describe "#+" do
    context "when given an Immediate" do
      let(:immediate) { Immediate.new(nil,10,register,2) }

      subject { register + immediate }

      it { should be_kind_of(Immediate) }

      it "should set the base" do
        subject.base.should == register
      end

      it "should preserve the offset, index and scale" do
        subject.offset.should == immediate.offset
        subject.index.should  == immediate.index
        subject.scale.should  == immediate.scale
      end
    end

    context "when given a Register" do
      subject { register + register }

      it { should be_kind_of(Immediate) }

      it "should set the base" do
        subject.base.should == register
      end

      its(:offset) { should == 0 }

      it "should set the index" do
        subject.index.should == register
      end
    end

    context "when given an Integer" do
      let(:offset) { 10 }

      subject { register + offset }

      it { should be_kind_of(Immediate) }

      it "should set the base" do
        subject.base.should == register
      end

      it "should set the offset" do
        subject.offset.should == offset
      end
    end

    context "otherwise" do
      it "should raise a TypeError" do
        lambda {
          register + Object.new
        }.should raise_error(TypeError)
      end
    end
  end

  describe "#-" do
    let(:offset) { 10 }

    subject { register - offset }

    it { should be_kind_of(Immediate) }

    it "should set the base" do
      subject.base.should == register
    end

    it "should set a negative offset" do
      subject.offset.should == -offset
    end
  end

  describe "#*" do
    let(:scale) { 2 }

    subject { register * scale }

    it { should be_kind_of(Immediate) }

    its(:base)   { should be_nil }
    its(:offset) { should == 0 }

    it "should set the index" do
      subject.index.should == register
    end

    it "should set the scale" do
      subject.scale.should == scale
    end
  end

  describe "#to_s" do
    it "should return the register name" do
      subject.to_s.should == subject.name.to_s
    end
  end
end
