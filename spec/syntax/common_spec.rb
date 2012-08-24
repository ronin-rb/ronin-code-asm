require 'spec_helper'

require 'ronin/asm/syntax/common'

describe ASM::Syntax::Common do
  subject { described_class }

  describe "emit_keyword" do
    let(:name) { :_start }

    it "should convert a keyword to a String" do
      subject.emit_keyword(name).should == name.to_s
    end
  end

  describe "emit_integer" do
    let(:integer)     { 255    }
    let(:hexadecimal) { "0xff" }

    it "should convert it into a hexadecimal value" do
      subject.emit_integer(integer).should == hexadecimal
    end

    context "when given a negative number" do
      let(:negative)    { -255    }
      let(:hexadecimal) { "-0xff" }

      it "should convert it into a hexadecimal value" do
        subject.emit_integer(negative).should == hexadecimal
      end
    end
  end
end
