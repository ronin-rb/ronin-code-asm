require 'spec_helper'
require 'ronin/asm/program'

describe ASM::Program do
  describe "#arch" do
    it "should default to :x86" do
      expect(subject.arch).to eq(:x86)
    end
  end

  context "when :arch is :x86" do
    subject { described_class.new(arch: :x86) }

    it { expect(subject.word_size).to eq(4) }

    describe "#stask_base" do
      it "should be ebp" do
        expect(subject.stack_base.name).to eq(:ebp)
      end
    end

    describe "#stask_pointer" do
      it "should be esp" do
        expect(subject.stack_pointer.name).to eq(:esp)
      end
    end

    describe "#stack_push" do
      let(:value) { 0xff }

      before { subject.stack_push(value) }

      it "should add a 'push' instruction with a value" do
        expect(subject.instructions[-1].name).to eq(:push)
        expect(subject.instructions[-1].operands[0].value).to eq(value)
      end
    end

    describe "#stack_pop" do
      let(:register) { subject.register(:eax) }

      before { subject.stack_pop(register) }

      it "should add a 'pop' instruction with a register" do
        expect(subject.instructions[-1].name).to eq(:pop)
        expect(subject.instructions[-1].operands[0]).to eq(register)
      end
    end

    describe "#register_clear" do
      let(:name) { :eax }

      before { subject.register_clear(name) }

      it "should add a 'xor' instruction with a registers" do
        expect(subject.instructions[-1].name).to eq(:xor)
        expect(subject.instructions[-1].operands[0].name).to eq(name)
        expect(subject.instructions[-1].operands[1].name).to eq(name)
      end
    end

    describe "#register_set" do
      let(:name)  { :eax }
      let(:value) { 0xff }

      before { subject.register_set(name,value) }

      it "should add a 'xor' instruction with a registers" do
        expect(subject.instructions[-1].name).to eq(:mov)
        expect(subject.instructions[-1].operands[0].value).to eq(value)
        expect(subject.instructions[-1].operands[1].name).to eq(name)
      end
    end

    describe "#register_save" do
      let(:name)  { :eax }

      before { subject.register_save(name) }

      it "should add a 'xor' instruction with a registers" do
        expect(subject.instructions[-1].name).to eq(:push)
        expect(subject.instructions[-1].operands[0].name).to eq(name)
      end
    end

    describe "#register_save" do
      let(:name)  { :eax }

      before { subject.register_load(name) }

      it "should add a 'xor' instruction with a registers" do
        expect(subject.instructions[-1].name).to eq(:pop)
        expect(subject.instructions[-1].operands[0].name).to eq(name)
      end
    end

    describe "#interrupt" do
      let(:number) { 0x0a }

      before { subject.interrupt(number) }

      it "should add an 'int' instruction with the interrupt number" do
        expect(subject.instructions[-1].name).to eq(:int)
        expect(subject.instructions[-1].operands[0].value).to eq(number)
      end
    end

    describe "#syscall" do
      before { subject.syscall }

      it "should add an 'int 0x80' instruction" do
        expect(subject.instructions[-1].name).to eq(:int)
        expect(subject.instructions[-1].operands[0].value).to eq(0x80)
      end
    end

    context "when :os is 'Linux'" do
      subject { described_class.new(arch: :x86, os: 'Linux') }

      it { expect(subject.syscalls).to_not be_empty }
    end

    context "when :os is 'FreeBSD'" do
      subject { described_class.new(arch: :x86, os: 'FreeBSD') }

      it { expect(subject.syscalls).to_not be_empty }
    end
  end

  context "when :arch is :amd64" do
    subject { described_class.new(arch: :amd64) }

    it { expect(subject.word_size).to eq(8) }

    describe "#syscall" do
      before { subject.syscall }

      it "should add a 'syscall' instruction" do
        expect(subject.instructions[-1].name).to eq(:syscall)
      end
    end

    context "when :os is 'Linux'" do
      subject { described_class.new(arch: :amd64, os: 'Linux') }

      it { expect(subject.syscalls).to_not be_empty }
    end

    context "when :os is 'FreeBSD'" do
      subject { described_class.new(arch: :amd64, os: 'FreeBSD') }

      it { expect(subject.syscalls).to_not be_empty }
    end
  end

  describe "#register?" do
    it "should return true for existing registers" do
      expect(subject.register?(:eax)).to be(true)
    end

    it "should return false for unknown registers" do
      expect(subject.register?(:foo)).to be(false)
    end
  end

  describe "#register" do
    it "should return a Register" do
      expect(subject.register(:eax)).to be_kind_of(ASM::Register)
    end

    it "should allocate the register" do
      subject.register(:ebx)

      expect(subject.allocated_registers).to include(:ebx)
    end

    context "when given an unknown register name" do
      it "should raise an ArgumentError" do
        expect {
          subject.register(:foo)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#instruction" do
    it "should return an Instruction" do
      expect(subject.instruction(:hlt)).to be_kind_of(ASM::Instruction)
    end

    it "should append the new Instruction" do
      subject.instruction(:push, 1)

      expect(subject.instructions.last.name).to eq(:push)
    end
  end

  describe "#byte" do
    it "should return a ImmedateOperand" do
      expect(subject.byte(1)).to be_kind_of(ImmediateOperand)
    end

    it "should have width of 1" do
      expect(subject.byte(1).width).to eq(1)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Register.new(:eax, 4)       }
      let(:memory_operand) { MemoryOperand.new(register) }

      it "should return a MemoryOperand" do
        expect(subject.byte(memory_operand)).to be_kind_of(MemoryOperand)
      end

      it "should have a width of 1" do
        expect(subject.byte(memory_operand).width).to eq(1)
      end
    end
  end

  describe "#word" do
    it "should return a ImmediateOperand" do
      expect(subject.word(1)).to be_kind_of(ImmediateOperand)
    end

    it "should have width of 2" do
      expect(subject.word(1).width).to eq(2)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Register.new(:eax, 4)       }
      let(:memory_operand) { MemoryOperand.new(register) }

      it "should return a MemoryOperand" do
        expect(subject.word(memory_operand)).to be_kind_of(MemoryOperand)
      end

      it "should have a width of 2" do
        expect(subject.word(memory_operand).width).to eq(2)
      end
    end
  end

  describe "#dword" do
    it "should return a ImmediateOperand" do
      expect(subject.dword(1)).to be_kind_of(ImmediateOperand)
    end

    it "should have width of 4" do
      expect(subject.dword(1).width).to eq(4)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Register.new(:eax, 4)       }
      let(:memory_operand) { MemoryOperand.new(register) }

      it "should return a MemoryOperand" do
        expect(subject.dword(memory_operand)).to be_kind_of(MemoryOperand)
      end

      it "should have a width of 4" do
        expect(subject.dword(memory_operand).width).to eq(4)
      end
    end
  end

  describe "#qword" do
    it "should return a ImmediateOperand" do
      expect(subject.qword(1)).to be_kind_of(ImmediateOperand)
    end

    it "should have width of 8" do
      expect(subject.qword(1).width).to eq(8)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Register.new(:eax, 4)       }
      let(:memory_operand) { MemoryOperand.new(register) }

      it "should return a MemoryOperand" do
        expect(subject.qword(memory_operand)).to be_kind_of(MemoryOperand)
      end

      it "should have a width of 8" do
        expect(subject.qword(memory_operand).width).to eq(8)
      end
    end
  end

  describe "#label" do
    let(:name) { :_start }

    it "should return the label name" do
      label = subject.label(name) { }
      
      expect(label).to eq(name)
    end

    it "should add the label to the instructions" do
      subject.label(name) { }

      expect(subject.instructions.last).to eq(name)
    end

    it "should accept a block" do
      subject.label(name) { push 2 }

      expect(subject.instructions[-1].name).to eq(:push)
      expect(subject.instructions[-2]).to eq(name)
    end
  end

  describe "#method_missing" do
    context "when called without a block" do
      it "should add a new instruction" do
        subject.pop

        expect(subject.instructions[-1].name).to eq(:pop)
      end
    end

    context "when called with one argument and a block" do
      it "should add a new label" do
        subject._loop { mov eax, ebx }

        expect(subject.instructions[-2]).to      eq(:_loop)
        expect(subject.instructions[-1].name).to eq(:mov)
      end
    end
  end

  describe "#to_asm" do
    subject do
      described_class.new do
        push eax
        push ebx
        push ecx

        mov ebx, eax
        mov ebx, eax+0
        mov ebx, eax+4
        mov ebx, eax+esi
        mov ebx, eax+(esi*4)
        mov ebx, eax+(esi*4)+10
      end
    end

    it "should convert the program to Intel syntax" do
      expect(subject.to_asm).to eq([
        "BITS 32",
        "section .text",
        "_start:",
        "\tpush\teax",
        "\tpush\tebx",
        "\tpush\tecx",
        "\tmov\tebx,\teax",
        "\tmov\tebx,\t[eax]",
        "\tmov\tebx,\t[eax+0x4]",
        "\tmov\tebx,\t[eax+esi]",
        "\tmov\tebx,\t[eax+esi*0x4]",
        "\tmov\tebx,\t[eax+esi*0x4+0xa]",
        ""
      ].join($/))
    end

    context "when given :att" do
      it "should convert the program to ATT syntax" do
        expect(subject.to_asm(:att)).to eq([
          ".code32",
          ".text",
          "_start:",
          "\tpushl\t%eax",
          "\tpushl\t%ebx",
          "\tpushl\t%ecx",
          "\tmovl\t%eax,\t%ebx",
          "\tmovl\t(%eax),\t%ebx",
          "\tmovl\t0x4(%eax),\t%ebx",
          "\tmovl\t(%eax,%esi),\t%ebx",
          "\tmovl\t(%eax,%esi,4),\t%ebx",
          "\tmovl\t0xa(%eax,%esi,4),\t%ebx",
          ""
        ].join($/))
      end
    end
  end

  describe "#assemble", integration: true do
    subject do
      described_class.new do
        push eax
        push ebx
        push ecx

        mov ebx, eax
        mov ebx, eax+0
        mov ebx, eax+4
        mov ebx, eax+esi
        mov ebx, eax+(esi*4)
        mov ebx, eax+(esi*4)+10
      end
    end

    let(:output) { Tempfile.new(['ronin-asm', '.o']).path }

    before { subject.assemble(output) }

    it "should write to the output file" do
      expect(File.size(output)).to be > 0
    end

    context "with :syntax is :intel" do
      let(:output) { Tempfile.new(['ronin-asm', '.o']).path }

      before { subject.assemble(output, syntax: :intel) }

      it "should write to the output file" do
        expect(File.size(output)).to be > 0
      end
    end
  end
end
