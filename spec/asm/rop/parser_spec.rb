require 'ronin/asm/rop/parser'

require 'spec_helper'

describe ASM::ROP::Parser do
  it "should parse the first fragment" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123")
    fragments = parser.to_a

    fragments.first.source.should == "abc\xc3"
  end

  it "should parse the middle fragment" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123\xc3xyz")
    fragments = parser.to_a

    fragments[1].source.should == "123\xc3"
  end

  it "should parse the tailing fragment" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123\xc3")
    fragments = parser.to_a

    fragments.last.source.should == "123\xc3"
  end

  it "should not parse tailing fragments, if they do not end in rets" do
    parser = ASM::ROP::Parser.new(:source => "abc\xc3123")
    fragments = parser.to_a

    fragments.last.source.should == "abc\xc3"
  end

  it "should not parse a whole fragment, if there are no rets" do
    parser = ASM::ROP::Parser.new(:source => "abc123")
    fragments = parser.to_a

    fragments.should be_empty
  end

  it "should parse empty fragments" do
    parser = ASM::ROP::Parser.new(:source => "\xc3\xc3")
    fragments = parser.to_a

    fragments.length.should == 2
    fragments[0].source.should == "\xc3"
    fragments[1].source.should == "\xc3"
  end

  it "should not parse empty Strings" do
    parser = ASM::ROP::Parser.new

    parser.to_a.should be_empty
  end
end
