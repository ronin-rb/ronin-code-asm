require 'ronin/asm/rop/parser'

require 'spec_helper'

describe ASM::ROP::Parser do
  describe "x86" do
    before(:each) do
      @parser = ASM::ROP::Parser.new(:arch => :x86)
    end

    it "should parse fragments ending in 'ret' instructions" do
      @parser.source = "abc\xc3"

      @parser.first.source.should == "abc\xc3"
    end

    it "should parse fragments ending in 'retf' instructions" do
      @parser.source = "abc\xcb"

      @parser.first.source.should == "abc\xcb"
    end

    it "should parse fragments ending in 'jmp (eax)' instructions" do
      @parser.source = "abc\xff\xe0"

      @parser.first.source.should == "abc\xff\xe0"
    end

    it "should parse fragments ending in 'jmp (ebx)' instructions" do
      @parser.source = "abc\xff\xe3"

      @parser.first.source.should == "abc\xff\xe3"
    end

    it "should parse fragments ending in 'jmp (ecx)' instructions" do
      @parser.source = "abc\xff\xe1"

      @parser.first.source.should == "abc\xff\xe1"
    end

    it "should parse fragments ending in 'jmp (edx)' instructions" do
      @parser.source = "abc\xff\xe2"

      @parser.first.source.should == "abc\xff\xe2"
    end

    it "should parse fragments ending in 'jmp (esi)' instructions" do
      @parser.source = "abc\xff\xe6"

      @parser.first.source.should == "abc\xff\xe6"
    end

    it "should parse fragments ending in 'jmp (edi)' instructions" do
      @parser.source = "abc\xff\xe7"

      @parser.first.source.should == "abc\xff\xe7"
    end

    it "should parse fragments ending in 'jmp (esp)' instructions" do
      @parser.source = "abc\xff\xe4"

      @parser.first.source.should == "abc\xff\xe4"
    end

    it "should parse fragments ending in 'jmp (ebp)' instructions" do
      @parser.source = "abc\xff\xe5"

      @parser.first.source.should == "abc\xff\xe5"
    end

    it "should parse fragments ending in 'jmp [eax]' instructions" do
      @parser.source = "abc\xff\x20"

      @parser.first.source.should == "abc\xff\x20"
    end

    it "should parse fragments ending in 'jmp [ebx]' instructions" do
      @parser.source = "abc\xff\x23"

      @parser.first.source.should == "abc\xff\x23"
    end

    it "should parse fragments ending in 'jmp [ecx]' instructions" do
      @parser.source = "abc\xff\x21"

      @parser.first.source.should == "abc\xff\x21"
    end

    it "should parse fragments ending in 'jmp [edx]' instructions" do
      @parser.source = "abc\xff\x22"

      @parser.first.source.should == "abc\xff\x22"
    end

    it "should parse fragments ending in 'jmp [esi]' instructions" do
      @parser.source = "abc\xff\x26"

      @parser.first.source.should == "abc\xff\x26"
    end

    it "should parse fragments ending in 'jmp [edi]' instructions" do
      @parser.source = "abc\xff\x27"

      @parser.first.source.should == "abc\xff\x27"
    end

    it "should parse fragments ending in 'jmp [esp]' instructions" do
      @parser.source = "abc\xff\x24\x24"

      @parser.first.source.should == "abc\xff\x24\x24"
    end

    it "should parse fragments ending in 'jmp [ebp]' instructions" do
      @parser.source = "abc\xff\x65\x00"

      @parser.first.source.should == "abc\xff\x65\x00"
    end
  end

  describe "amd64" do
    before(:each) do
      @parser = ASM::ROP::Parser.new(:arch => :amd64)
    end

    it "should parse fragments ending in 'ret' instructions" do
      @parser.source = "abc\xc3"

      @parser.first.source.should == "abc\xc3"
    end

    it "should parse fragments ending in 'retf' instructions" do
      @parser.source = "abc\x48\xcb"

      @parser.first.source.should == "abc\x48\xcb"
    end

    it "should parse fragments ending in 'jmp (rax)' instructions" do
      @parser.source = "abc\xff\xe0"

      @parser.first.source.should == "abc\xff\xe0"
    end

    it "should parse fragments ending in 'jmp (rbx)' instructions" do
      @parser.source = "abc\xff\xe3"

      @parser.first.source.should == "abc\xff\xe3"
    end

    it "should parse fragments ending in 'jmp (rcx)' instructions" do
      @parser.source = "abc\xff\xe1"

      @parser.first.source.should == "abc\xff\xe1"
    end

    it "should parse fragments ending in 'jmp (rdx)' instructions" do
      @parser.source = "abc\xff\xe2"

      @parser.first.source.should == "abc\xff\xe2"
    end

    it "should parse fragments ending in 'jmp (rsi)' instructions" do
      @parser.source = "abc\xff\xe6"

      @parser.first.source.should == "abc\xff\xe6"
    end

    it "should parse fragments ending in 'jmp (rdi)' instructions" do
      @parser.source = "abc\xff\xe7"

      @parser.first.source.should == "abc\xff\xe7"
    end

    it "should parse fragments ending in 'jmp (rsp)' instructions" do
      @parser.source = "abc\xff\xe4"

      @parser.first.source.should == "abc\xff\xe4"
    end

    it "should parse fragments ending in 'jmp (rbp)' instructions" do
      @parser.source = "abc\xff\xe5"

      @parser.first.source.should == "abc\xff\xe5"
    end

    it "should parse fragments ending in 'jmp (r8)' instructions" do
      @parser.source = "abc\x41\xff\xe0"

      @parser.first.source.should == "abc\x41\xff\xe0"
    end

    it "should parse fragments ending in 'jmp (r9)' instructions" do
      @parser.source = "abc\x41\xff\xe1"

      @parser.first.source.should == "abc\x41\xff\xe1"
    end

    it "should parse fragments ending in 'jmp (r10)' instructions" do
      @parser.source = "abc\x41\xff\xe2"

      @parser.first.source.should == "abc\x41\xff\xe2"
    end

    it "should parse fragments ending in 'jmp (r11)' instructions" do
      @parser.source = "abc\x41\xff\xe3"

      @parser.first.source.should == "abc\x41\xff\xe3"
    end

    it "should parse fragments ending in 'jmp (r12)' instructions" do
      @parser.source = "abc\x41\xff\xe4"

      @parser.first.source.should == "abc\x41\xff\xe4"
    end

    it "should parse fragments ending in 'jmp (r13)' instructions" do
      @parser.source = "abc\x41\xff\xe5"

      @parser.first.source.should == "abc\x41\xff\xe5"
    end

    it "should parse fragments ending in 'jmp (r14)' instructions" do
      @parser.source = "abc\x41\xff\xe6"

      @parser.first.source.should == "abc\x41\xff\xe6"
    end

    it "should parse fragments ending in 'jmp (r15)' instructions" do
      @parser.source = "abc\x41\xff\xe7"

      @parser.first.source.should == "abc\x41\xff\xe7"
    end

    it "should parse fragments ending in 'jmp [rax]' instructions" do
      @parser.source = "abc\xff\x20"

      @parser.first.source.should == "abc\xff\x20"
    end

    it "should parse fragments ending in 'jmp [rbx]' instructions" do
      @parser.source = "abc\xff\x23"

      @parser.first.source.should == "abc\xff\x23"
    end

    it "should parse fragments ending in 'jmp [rcx]' instructions" do
      @parser.source = "abc\xff\x21"

      @parser.first.source.should == "abc\xff\x21"
    end

    it "should parse fragments ending in 'jmp [rdx]' instructions" do
      @parser.source = "abc\xff\x22"

      @parser.first.source.should == "abc\xff\x22"
    end

    it "should parse fragments ending in 'jmp [rsi]' instructions" do
      @parser.source = "abc\xff\x26"

      @parser.first.source.should == "abc\xff\x26"
    end

    it "should parse fragments ending in 'jmp [rdi]' instructions" do
      @parser.source = "abc\xff\x27"

      @parser.first.source.should == "abc\xff\x27"
    end

    it "should parse fragments ending in 'jmp [rsp]' instructions" do
      @parser.source = "abc\xff\x24\x24"

      @parser.first.source.should == "abc\xff\x24\x24"
    end

    it "should parse fragments ending in 'jmp [rbp]' instructions" do
      @parser.source = "abc\xff\x65\x00"

      @parser.first.source.should == "abc\xff\x65\x00"
    end

    it "should parse fragments ending in 'jmp [r8]' instructions" do
      @parser.source = "abc\x41\xff\x20"

      @parser.first.source.should == "abc\x41\xff\x20"
    end

    it "should parse fragments ending in 'jmp [r9]' instructions" do
      @parser.source = "abc\x41\xff\x21"

      @parser.first.source.should == "abc\x41\xff\x21"
    end

    it "should parse fragments ending in 'jmp [r10]' instructions" do
      @parser.source = "abc\x41\xff\x22"

      @parser.first.source.should == "abc\x41\xff\x22"
    end

    it "should parse fragments ending in 'jmp [r11]' instructions" do
      @parser.source = "abc\x41\xff\x23"

      @parser.first.source.should == "abc\x41\xff\x23"
    end

    it "should parse fragments ending in 'jmp [r12]' instructions" do
      @parser.source = "abc\x41\xff\x24\x24"

      @parser.first.source.should == "abc\x41\xff\x24\x24"
    end

    it "should parse fragments ending in 'jmp [r13]' instructions" do
      @parser.source = "abc\x41\xff\x65\x00"

      @parser.first.source.should == "abc\x41\xff\x65\x00"
    end

    it "should parse fragments ending in 'jmp [r14]' instructions" do
      @parser.source = "abc\x41\xff\x26"

      @parser.first.source.should == "abc\x41\xff\x26"
    end

    it "should parse fragments ending in 'jmp [r15]' instructions" do
      @parser.source = "abc\x41\xff\x27"

      @parser.first.source.should == "abc\x41\xff\x27"
    end
  end

  it "should raise an exception when using an unsupported arch" do
    lambda {
      ASM::ROP::Parser.new(:arch => :raiders_of_the_lost_arch)
    }.should raise_error(StandardError)
  end

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
