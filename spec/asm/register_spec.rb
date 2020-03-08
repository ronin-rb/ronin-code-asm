require 'spec_helper'

require 'ronin/asm/register'

describe Register do
  let(:register) { described_class.new(:eax, 4) }

  subject { register }

  describe "#+" do
    context "when given an MemoryOperand" do
      let(:operand) { MemoryOperand.new(nil,10,register,2) }

      subject { register + operand }

      it { should be_kind_of(MemoryOperand) }

      it "should set the base" do
        expect(subject.base).to eq(register)
      end

      it "should preserve the offset, index and scale" do
        expect(subject.offset).to eq(operand.offset)
        expect(subject.index).to  eq(operand.index)
        expect(subject.scale).to  eq(operand.scale)
      end
    end

    context "when given a Register" do
      subject { register + register }

      it { should be_kind_of(MemoryOperand) }

      it "should set the base" do
        expect(subject.base).to eq(register)
      end

      its(:offset) { should == 0 }

      it "should set the index" do
        expect(subject.index).to eq(register)
      end
    end

    context "when given an Integer" do
      let(:offset) { 10 }

      subject { register + offset }

      it { should be_kind_of(MemoryOperand) }

      it "should set the base" do
        expect(subject.base).to eq(register)
      end

      it "should set the offset" do
        expect(subject.offset).to eq(offset)
      end
    end

    context "otherwise" do
      it "should raise a TypeError" do
        expect {
          register + Object.new
        }.to raise_error(TypeError)
      end
    end
  end

  describe "#-" do
    let(:offset) { 10 }

    subject { register - offset }

    it { should be_kind_of(MemoryOperand) }

    it "should set the base" do
      expect(subject.base).to eq(register)
    end

    it "should set a negative offset" do
      expect(subject.offset).to eq(-offset)
    end
  end

  describe "#*" do
    let(:scale) { 2 }

    subject { register * scale }

    it { should be_kind_of(MemoryOperand) }

    its(:base)   { should be_nil }
    its(:offset) { should == 0 }

    it "should set the index" do
      expect(subject.index).to eq(register)
    end

    it "should set the scale" do
      expect(subject.scale).to eq(scale)
    end
  end

  describe "#to_s" do
    it "should return the register name" do
      expect(subject.to_s).to eq(subject.name.to_s)
    end
  end
end
