require 'spec_helper'

require 'ronin/code/asm/instruction'
require 'ronin/code/asm/register'
require 'ronin/code/asm/immediate_operand'
require 'ronin/code/asm/memory_operand'

describe Ronin::Code::ASM::Instruction do
  let(:register)  { Ronin::Code::ASM::Register.new(:eax, 4) }
  let(:immediate) { Ronin::Code::ASM::ImmediateOperand.new(0xff, 1) }

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

      it "must wrap the operand to in a Ronin::Code::ASM::ImmediateOperand" do
        expect(subject.operands[0]).to be_kind_of(Ronin::Code::ASM::ImmediateOperand)
        expect(subject.operands[0].value).to eq(integer)
      end
    end

    context "when given a nil operand" do
      subject { described_class.new(name, [nil, register]) }

      it "must wrap the operand to in a Ronin::Code::ASM::ImmediateOperand" do
        expect(subject.operands[0]).to be_kind_of(Ronin::Code::ASM::ImmediateOperand)
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
