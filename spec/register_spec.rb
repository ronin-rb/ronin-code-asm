require 'spec_helper'

require 'ronin/asm/register'

describe Ronin::ASM::Register do
  let(:register) { described_class.new(:eax, 4) }

  subject { register }

  describe "#+" do
    context "when given an Ronin::ASM::MemoryOperand" do
      let(:operand) do
        Ronin::ASM::MemoryOperand.new(nil,10,register,2)
      end

      subject { register + operand }

      it { expect(subject).to be_kind_of(Ronin::ASM::MemoryOperand) }

      it "must set the base" do
        expect(subject.base).to eq(register)
      end

      it "must preserve the offset, index and scale" do
        expect(subject.offset).to eq(operand.offset)
        expect(subject.index).to  eq(operand.index)
        expect(subject.scale).to  eq(operand.scale)
      end
    end

    context "when given a Register" do
      subject { register + register }

      it { expect(subject).to be_kind_of(Ronin::ASM::MemoryOperand) }

      it "must set the base" do
        expect(subject.base).to eq(register)
      end

      it { expect(subject.offset).to eq(0) }

      it "must set the index" do
        expect(subject.index).to eq(register)
      end
    end

    context "when given an Integer" do
      let(:offset) { 10 }

      subject { register + offset }

      it { expect(subject).to be_kind_of(Ronin::ASM::MemoryOperand) }

      it "must set the base" do
        expect(subject.base).to eq(register)
      end

      it "must set the offset" do
        expect(subject.offset).to eq(offset)
      end
    end

    context "otherwise" do
      it "must raise a TypeError" do
        expect {
          register + Object.new
        }.to raise_error(TypeError)
      end
    end
  end

  describe "#-" do
    let(:offset) { 10 }

    subject { register - offset }

    it { expect(subject).to be_kind_of(Ronin::ASM::MemoryOperand) }

    it "must set the base" do
      expect(subject.base).to eq(register)
    end

    it "must set a negative offset" do
      expect(subject.offset).to eq(-offset)
    end
  end

  describe "#*" do
    let(:scale) { 2 }

    subject { register * scale }

    it { expect(subject).to be_kind_of(Ronin::ASM::MemoryOperand) }

    it { expect(subject.base).to be_nil }
    it { expect(subject.offset).to eq(0) }

    it "must set the index" do
      expect(subject.index).to eq(register)
    end

    it "must set the scale" do
      expect(subject.scale).to eq(scale)
    end
  end

  describe "#to_s" do
    it "must return the register name" do
      expect(subject.to_s).to eq(subject.name.to_s)
    end
  end
end
