require 'spec_helper'
require 'ronin/asm/syntax/common'

require 'ronin/asm/label'

describe Ronin::ASM::Syntax::Common do
  subject { described_class }

  describe ".emit_keyword" do
    let(:name) { :_start }

    it "must convert a keyword to a String" do
      expect(subject.emit_keyword(name)).to eq(name.to_s)
    end
  end

  describe ".emit_integer" do
    let(:int) { 255 }

    it "must convert it into a hexadecimal value" do
      expect(subject.emit_integer(int)).to eq("0xff")
    end

    context "when given a negative number" do
      let(:int) { -255 }

      it "must convert it into a hexadecimal value" do
        expect(subject.emit_integer(int)).to eq("-0xff")
      end
    end
  end

  describe ".emit_label" do
    let(:name)  { :_start  }
    let(:label) { Ronin::ASM::Label.new(name) }

    it "must append a ':' to the name" do
      expect(subject.emit_label(label)).to eq('_start:')
    end
  end
end
