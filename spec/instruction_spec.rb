require 'spec_helper'
require 'ronin/asm/instruction'

require 'ronin/asm/register'
require 'ronin/asm/immediate'
require 'ronin/asm/memory_operand'

describe Ronin::ASM::Instruction do
  let(:register)  { Ronin::ASM::Register.new(:eax, 4) }
  let(:immediate) { Ronin::ASM::Immediate.new(0xff, 1) }

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

    it "must default #comment to nil" do
      expect(subject.comment).to be(nil)
    end

    context "when given an Integer operand" do
      let(:integer) { 0xff }

      subject { described_class.new(name, [integer, register]) }

      it "must wrap the operand to in a Ronin::ASM::Immediate" do
        expect(subject.operands[0]).to be_kind_of(Ronin::ASM::Immediate)
        expect(subject.operands[0].value).to eq(integer)
      end
    end

    context "when given a nil operand" do
      subject { described_class.new(name, [nil, register]) }

      it "must wrap the operand to in a Ronin::ASM::Immediate" do
        expect(subject.operands[0]).to be_kind_of(Ronin::ASM::Immediate)
        expect(subject.operands[0].value).to eq(0)
      end
    end

    context "when given the comment: keyword argument" do
      let(:comment) { 'Foo bar' }

      subject { described_class.new(name,operands, comment: comment) }

      it "must set #comment" do
        expect(subject.comment).to eq(comment)
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
