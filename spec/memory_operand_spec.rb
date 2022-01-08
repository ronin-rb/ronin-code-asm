require 'spec_helper'

require 'ronin/asm/memory_operand'
require 'ronin/asm/register'

describe MemoryOperand do
  let(:register) { Register.new(:eax, 4) }

  describe "#initialize" do
    it { expect(subject.base).to   be_nil }
    it { expect(subject.offset).to eq(0)  }
    it { expect(subject.index).to  be_nil }
    it { expect(subject.scale).to  eq(1)  }

    it "should only accept nil and a Register for base" do
      expect {
        described_class.new(Object.new)
      }.to raise_error(TypeError)
    end

    it "should only accept Integers for offset" do
      expect {
        described_class.new(register,2.0)
      }.to raise_error(TypeError)
    end

    it "should only accept nil and a Register for index" do
      expect {
        described_class.new(register,0,Object.new)
      }.to raise_error(TypeError)
    end

    it "should only accept Integers for offset" do
      expect {
        described_class.new(register,0,nil,2.0)
      }.to raise_error(TypeError)
    end

  end

  describe "#+" do
    let(:operand) { described_class.new(register,4,register,2) }

    subject { operand + 4 }

    it "should add to offset" do
      expect(subject.offset).to eq(8)
    end

    it "should not change base, index or scale" do
      expect(subject.base).to  eq(operand.base)
      expect(subject.index).to eq(operand.index)
      expect(subject.scale).to eq(operand.scale)
    end
  end

  describe "#-" do
    let(:operand) { described_class.new(register,4,register,2) }

    subject { operand - 2 }

    it "should subtract from offset" do
      expect(subject.offset).to eq(2)
    end

    it "should not change base, index or scale" do
      expect(subject.base).to  eq(operand.base)
      expect(subject.index).to eq(operand.index)
      expect(subject.scale).to eq(operand.scale)
    end
  end

  describe "#width" do
    subject { described_class.new(register,10) }

    it "should return the width of base" do
      expect(subject.width).to eq(register.width)
    end
  end
end
