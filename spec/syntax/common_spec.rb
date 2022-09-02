require 'spec_helper'

require 'ronin/asm/syntax/common'

describe Ronin::ASM::Syntax::Common do
  subject { described_class }

  describe "emit_keyword" do
    let(:name) { :_start }

    it "should convert a keyword to a String" do
      expect(subject.emit_keyword(name)).to eq(name.to_s)
    end
  end

  describe "emit_integer" do
    let(:integer)     { 255    }
    let(:hexadecimal) { "0xff" }

    it "should convert it into a hexadecimal value" do
      expect(subject.emit_integer(integer)).to eq(hexadecimal)
    end

    context "when given a negative number" do
      let(:negative)    { -255    }
      let(:hexadecimal) { "-0xff" }

      it "should convert it into a hexadecimal value" do
        expect(subject.emit_integer(negative)).to eq(hexadecimal)
      end
    end
  end

  describe "emit_label" do
    let(:name)  { :_start   }
    let(:label) { '_start:' }

    it "should append a ':' to the name" do
      expect(subject.emit_label(name)).to eq(label)
    end
  end
end
