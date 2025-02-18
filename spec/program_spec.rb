require 'spec_helper'
require 'ronin/asm/program'

describe Ronin::ASM::Program do
  describe "#arch" do
    it "must return the architecture name" do
      expect(subject.arch).to eq(:x86_64)
    end
  end

  describe "#initialize" do
    it "must default the architecture to :x86_64" do
      expect(subject.arch).to eq(:x86_64)
    end

    context "when the arch: keyword argument is :x86" do
      subject { described_class.new(arch: :x86) }

      it { expect(subject.word_size).to eq(4) }

      describe "#stask_base" do
        it "must be ebp" do
          expect(subject.stack_base.name).to eq(:ebp)
        end
      end

      describe "#stask_pointer" do
        it "must be esp" do
          expect(subject.stack_pointer.name).to eq(:esp)
        end
      end

      describe "#stack_push" do
        let(:value) { 0xff }

        before { subject.stack_push(value) }

        it "must add a 'push' instruction with a value" do
          expect(subject.instructions[-1].name).to eq(:push)
          expect(subject.instructions[-1].operands[0].value).to eq(value)
        end
      end

      describe "#stack_pop" do
        let(:register) { subject.register(:eax) }

        before { subject.stack_pop(register) }

        it "must add a 'pop' instruction with a register" do
          expect(subject.instructions[-1].name).to eq(:pop)
          expect(subject.instructions[-1].operands[0]).to eq(register)
        end
      end

      describe "#register_clear" do
        let(:name) { :eax }

        before { subject.register_clear(name) }

        it "must add a 'xor' instruction with a registers" do
          expect(subject.instructions[-1].name).to eq(:xor)
          expect(subject.instructions[-1].operands[0].name).to eq(name)
          expect(subject.instructions[-1].operands[1].name).to eq(name)
        end
      end

      describe "#register_set" do
        let(:name)  { :eax }
        let(:value) { 0xff }

        before { subject.register_set(name,value) }

        it "must add a 'xor' instruction with a registers" do
          expect(subject.instructions[-1].name).to eq(:mov)
          expect(subject.instructions[-1].operands[0].value).to eq(value)
          expect(subject.instructions[-1].operands[1].name).to eq(name)
        end
      end

      describe "#register_save" do
        let(:name)  { :eax }

        before { subject.register_save(name) }

        it "must add a 'xor' instruction with a registers" do
          expect(subject.instructions[-1].name).to eq(:push)
          expect(subject.instructions[-1].operands[0].name).to eq(name)
        end
      end

      describe "#register_save" do
        let(:name)  { :eax }

        before { subject.register_load(name) }

        it "must add a 'xor' instruction with a registers" do
          expect(subject.instructions[-1].name).to eq(:pop)
          expect(subject.instructions[-1].operands[0].name).to eq(name)
        end
      end

      describe "#interrupt" do
        let(:number) { 0x0a }

        before { subject.interrupt(number) }

        it "must add an 'int' instruction with the interrupt number" do
          expect(subject.instructions[-1].name).to eq(:int)
          expect(subject.instructions[-1].operands[0].value).to eq(number)
        end
      end

      describe "#syscall" do
        before { subject.syscall }

        it "must add an 'int 0x80' instruction" do
          expect(subject.instructions[-1].name).to eq(:int)
          expect(subject.instructions[-1].operands[0].value).to eq(0x80)
        end
      end

      context "and when the os: keyword argument is :linux" do
        subject { described_class.new(arch: :x86, os: :linux) }

        it { expect(subject.syscalls).to_not be_empty }
      end

      context "and when the os: keyword argument is :freebsd" do
        subject { described_class.new(arch: :x86, os: :freebsd) }

        it { expect(subject.syscalls).to_not be_empty }
      end
    end

    context "when the arch: keyword argument is :amd64" do
      subject { described_class.new(arch: :amd64) }

      it { expect(subject.word_size).to eq(8) }

      describe "#syscall" do
        before { subject.syscall }

        it "must add a 'syscall' instruction" do
          expect(subject.instructions[-1].name).to eq(:syscall)
        end
      end

      context "and when the os: keyword argument is :linux" do
        subject { described_class.new(arch: :amd64, os: :linux) }

        it { expect(subject.syscalls).to_not be_empty }
      end

      context "and when the os: keyword argument is :freebsd" do
        subject { described_class.new(arch: :amd64, os: :freebsd) }

        it { expect(subject.syscalls).to_not be_empty }
      end
    end

    context "when given an unknown arch: keyword argument value" do
      let(:arch) { :foo }

      it do
        expect {
          described_class.new(arch: arch)
        }.to raise_error(ArgumentError,"unknown architecture: #{arch.inspect}")
      end
    end
  end

  describe "#register?" do
    it "must return true for existing registers" do
      expect(subject.register?(:eax)).to be(true)
    end

    it "must return false for unknown registers" do
      expect(subject.register?(:foo)).to be(false)
    end
  end

  describe "#register" do
    it "must return a Register" do
      expect(subject.register(:eax)).to be_kind_of(Ronin::ASM::Register)
    end

    it "must allocate the register" do
      subject.register(:ebx)

      expect(subject.allocated_registers).to include(:ebx)
    end

    context "when given an unknown register name" do
      it "must raise an ArgumentError" do
        expect {
          subject.register(:foo)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#instruction" do
    it "must return an Instruction" do
      expect(subject.instruction(:hlt)).to be_kind_of(Ronin::ASM::Instruction)
    end

    it "must append the new Instruction" do
      subject.instruction(:push, 1)

      expect(subject.instructions.last.name).to eq(:push)
    end
  end

  describe "#byte" do
    it "must return a ImmedateOperand" do
      expect(subject.byte(1)).to be_kind_of(Ronin::ASM::ImmediateOperand)
    end

    it "must have width of 1" do
      expect(subject.byte(1).width).to eq(1)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Ronin::ASM::Register.new(:eax, 4)       }
      let(:memory_operand) { Ronin::ASM::MemoryOperand.new(register) }

      it "must return a MemoryOperand" do
        expect(subject.byte(memory_operand)).to be_kind_of(
          Ronin::ASM::MemoryOperand
        )
      end

      it "must have a width of 1" do
        expect(subject.byte(memory_operand).width).to eq(1)
      end
    end
  end

  describe "#word" do
    it "must return a Ronin::ASM::ImmediateOperand" do
      expect(subject.word(1)).to be_kind_of(Ronin::ASM::ImmediateOperand)
    end

    it "must have width of 2" do
      expect(subject.word(1).width).to eq(2)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Ronin::ASM::Register.new(:eax, 4)       }
      let(:memory_operand) { Ronin::ASM::MemoryOperand.new(register) }

      it "must return a MemoryOperand" do
        expect(subject.word(memory_operand)).to be_kind_of(
          Ronin::ASM::MemoryOperand
        )
      end

      it "must have a width of 2" do
        expect(subject.word(memory_operand).width).to eq(2)
      end
    end
  end

  describe "#dword" do
    it "must return a Ronin::ASM::ImmediateOperand" do
      expect(subject.dword(1)).to be_kind_of(Ronin::ASM::ImmediateOperand)
    end

    it "must have width of 4" do
      expect(subject.dword(1).width).to eq(4)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Ronin::ASM::Register.new(:eax, 4)       }
      let(:memory_operand) { Ronin::ASM::MemoryOperand.new(register) }

      it "must return a MemoryOperand" do
        expect(subject.dword(memory_operand)).to be_kind_of(
          Ronin::ASM::MemoryOperand
        )
      end

      it "must have a width of 4" do
        expect(subject.dword(memory_operand).width).to eq(4)
      end
    end
  end

  describe "#qword" do
    it "must return a Ronin::ASM::ImmediateOperand" do
      expect(subject.qword(1)).to be_kind_of(Ronin::ASM::ImmediateOperand)
    end

    it "must have width of 8" do
      expect(subject.qword(1).width).to eq(8)
    end

    context "when given a MemoryOperand" do
      let(:register)       { Ronin::ASM::Register.new(:eax, 4)       }
      let(:memory_operand) { Ronin::ASM::MemoryOperand.new(register) }

      it "must return a MemoryOperand" do
        expect(subject.qword(memory_operand)).to be_kind_of(
          Ronin::ASM::MemoryOperand
        )
      end

      it "must have a width of 8" do
        expect(subject.qword(memory_operand).width).to eq(8)
      end
    end
  end

  describe "#label" do
    let(:name) { '_start' }

    it "must return the new Label object" do
      new_label = subject.label(name) { }

      expect(new_label).to be_kind_of(Ronin::ASM::Label)
      expect(new_label.name).to eq(name)
    end

    context "when a Symbol is given for the name" do
      it "must convert the Symbol to a String" do
        new_label = subject.label(:_start) { }

        expect(new_label).to be_kind_of(Ronin::ASM::Label)
        expect(new_label.name).to eq('_start')
      end
    end

    it "must add the label to the instructions" do
      subject.label(name) { }

      expect(subject.instructions.last).to be_kind_of(Ronin::ASM::Label)
      expect(subject.instructions.last.name).to eq(name)
    end

    it "must accept a block" do
      subject.label(name) { push 2 }

      expect(subject.instructions[-2]).to      be_kind_of(Ronin::ASM::Label)
      expect(subject.instructions[-2].name).to eq(name)
      expect(subject.instructions[-1].name).to eq(:push)
    end
  end

  describe "#method_missing" do
    context "when called without a block" do
      it "must add a new instruction" do
        subject.pop

        expect(subject.instructions[-1].name).to eq(:pop)
      end
    end

    context "when called with one argument and a block" do
      it "must add a new label" do
        subject._loop { mov eax, ebx }

        expect(subject.instructions[-2]).to      be_kind_of(Ronin::ASM::Label)
        expect(subject.instructions[-2].name).to eq('_loop')
        expect(subject.instructions[-1].name).to eq(:mov)
      end
    end
  end

  describe "#to_asm" do
    subject do
      described_class.new(arch: :x86) do
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

    it "must convert the program to Intel syntax" do
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
      it "must convert the program to ATT syntax" do
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
      described_class.new(arch: :x86) do
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

    it "must write to the output file" do
      expect(File.size(output)).to be > 0
    end

    context "when syntax: :intel is given" do
      let(:output) { Tempfile.new(['ronin-asm', '.o']).path }

      before { subject.assemble(output, syntax: :intel) }

      it "must write to the output file" do
        expect(File.size(output)).to be > 0
      end
    end

    context "when syntax is unknown" do
      let(:syntax) { :foo }

      it do
        expect {
          subject.assemble(output, syntax: syntax)
        }.to raise_error(ArgumentError,"unknown ASM syntax: #{syntax.inspect}")
      end
    end
  end
end
