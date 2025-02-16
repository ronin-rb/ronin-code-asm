require 'spec_helper'

require 'ronin/asm/instruction'
require 'ronin/asm/register'
require 'ronin/asm/immediate_operand'
require 'ronin/asm/memory_operand'

describe Ronin::ASM::Instruction do
  let(:register)  { Ronin::ASM::Register.new(:eax, 4) }
  let(:immediate) { Ronin::ASM::ImmediateOperand.new(0xff, 1) }

  describe "#initialize" do
    let(:name)     { :mov }
    let(:operands) { [immediate, register] }

    subject { described_class.new(name,operands) }

    it "must set the name" do
      expect(subject.name).to eq(:mov)
    end

    it "must set the operands" do
      expect(subject.operands).to eq(operands)
    end

    context "when given an Integer operand" do
      let(:integer) { 0xff }

      subject { described_class.new(name, [integer, register]) }

      it "must wrap the operand to in a Ronin::ASM::ImmediateOperand" do
        expect(subject.operands[0]).to be_kind_of(Ronin::ASM::ImmediateOperand)
        expect(subject.operands[0].value).to eq(integer)
      end
    end

    context "when given a nil operand" do
      subject { described_class.new(name, [nil, register]) }

      it "must wrap the operand to in a Ronin::ASM::ImmediateOperand" do
        expect(subject.operands[0]).to be_kind_of(Ronin::ASM::ImmediateOperand)
        expect(subject.operands[0].value).to eq(0)
      end
    end
  end

  describe "#width" do
    subject { described_class.new(:mov, [immediate, register]) }

    it "must return the maximum width of the operands" do
      expect(subject.width).to eq(register.width)
    end

    context "when one of the operands does not define #width" do
      subject { described_class.new(:mov, [:label, register]) }

      it "must ignore them" do
        expect(subject.width).to eq(register.width)
      end
    end
  end
end
