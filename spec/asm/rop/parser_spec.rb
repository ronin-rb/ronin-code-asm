require 'ronin/asm/rop/parser'

require 'spec_helper'

describe ASM::ROP::Parser do
  it "should parse the first fragment" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123")
    fragments = parser.to_a

    fragments.first.source.should == "abc"
  end

  it "should parse the middle fragment" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123\xc3xyz")
    fragments = parser.to_a

    fragments[1].source.should == "123"
  end

  it "should parse the tailing fragment" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123")
    fragments = parser.to_a

    fragments.last.source.should == "123"
  end

  it "should parse the tailing fragment, if there is none" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123\xc3")
    fragments = parser.to_a

    fragments.last.source.should_not be_empty
  end

  it "should parse the whole source as a fragment, if there are no rets" do
    parser = ASM::ROP::Parser.new(:source => "abc123")
    fragments = parser.to_a

    fragments.length.should == 1
    fragments.first.source.should == 'abc123'
  end

  it "should not parse empty fragments" do
    parser = ASM::ROP::Parser.new(:source => "\xc3\xc3")

    parser.to_a.should be_empty
  end

  it "should not parse empty Strings" do
    parser = ASM::ROP::Parser.new

    parser.to_a.should be_empty
  end
end
