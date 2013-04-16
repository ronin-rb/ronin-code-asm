require 'spec_helper'
require 'ronin/asm/shellcode'
require 'ronin/asm'

describe ASM::Shellcode do
  describe "#assemble", integration: true do
    subject do
      described_class.new({ syntax: :att }) do
        xor   eax,  eax
        push  eax
        push  0x68732f2f
        push  0x6e69622f
        mov   esp,  ebx
        push  eax
        push  ebx
        mov   esp,  ecx
        xor   edx,  edx
        mov   0xb,  al
        int   0x80
      end
    end

    let(:shellcode) { "f1\xC0fPfh//shfh/binf\x89\xE3fPfSf\x89\xE1f1\xD2\xB0\v\xCD\x80" }

    it "assemble down to raw machine code" do
      subject.assemble.should == shellcode
    end

    context "with :syntax is :intel" do
      it "assemble down to raw machine code" do
        subject.assemble(syntax: :intel).should == shellcode
      end
    end
  end
  
  describe "#assemble intel syntax", integration: true do
    subject do
      described_class.new do
        xor   eax,  eax
        push  eax
        push  0x68732f2f
        push  0x6e69622f
        mov   ebx, esp  
        push  eax
        push  ebx
        mov   ecx, esp
        xor   edx, edx
        mov   al, 0xb
        int   0x80
      end
    end

    let(:shellcode) { "f1\xC0fPfh//shfh/binf\x89\xE3fPfSf\x89\xE1f1\xD2\xB0\v\xCD\x80" }

    it "assemble down to raw machine code" do
      subject.assemble.should == shellcode
    end

    context "with :syntax is :intel" do
      it "assemble down to raw machine code" do
        subject.assemble(syntax: :intel).should == shellcode
      end
    end
  end
end
