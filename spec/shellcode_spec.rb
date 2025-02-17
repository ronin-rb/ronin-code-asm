# encoding: US-ASCII
require 'spec_helper'
require 'ronin/asm/shellcode'

describe Ronin::ASM::Shellcode do
  describe "#assemble", integration: true do
    subject do
      described_class.new do
        xor   eax,  eax
        push  eax
        push  0x68732f2f
        push  0x6e69622f
        mov   ebx, esp
        push  eax
        push  ebx
        mov   ecx,  esp
        xor   edx,  edx
        mov   al,   0xb
        int   0x80
      end
    end

    let(:shellcode) { "1\xC0Ph//shh/bin\x89\xE3PS\x89\xE11\xD2\xB0\v\xCD\x80" }

    it "must assemble down to raw machine code" do
      expect(subject.assemble).to eq(shellcode)
    end

    it "must return an ASCII-8bit encoded String" do
      expect(subject.assemble.encoding).to eq(Encoding::ASCII_8BIT)
    end

    context "with :output" do
      let(:tempfile) do
        Tempfile.new(['ronin-shellcode-custom-path', '.bin'])
      end
      let(:output) { tempfile.path }

      it "must write to the custom path" do
        expect(subject.assemble(output: output)).to eq(shellcode)

        File.binread(output)
      end
    end

    context "with :syntax is :intel" do
      it "assemble down to raw machine code" do
        expect(subject.assemble(syntax: :intel)).to eq(shellcode)
      end
    end

    context "with :syntax is :att" do
      it "assemble down to raw machine code" do
        expect(subject.assemble(syntax: :att)).to eq(shellcode)
      end
    end
  end
end
