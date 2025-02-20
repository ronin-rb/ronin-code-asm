require 'spec_helper'
require 'ronin/asm/syntax/intel'

require 'ronin/asm/register'
require 'ronin/asm/immediate'
require 'ronin/asm/memory_operand'
require 'ronin/asm/instruction'
require 'ronin/asm/program'

describe Ronin::ASM::Syntax::Intel do
  subject { described_class }

  describe ".emit_register" do
    let(:register) { Ronin::ASM::Register.new(:eax, 4) }

    it "must return the register name" do
      expect(subject.emit_register(register)).to eq("eax")
    end
  end

  describe ".emit_immediate_operand" do
    let(:operand) { Ronin::ASM::Immediate.new(255, 1) }

    it "must prepend a size specifier" do
      expect(subject.emit_immediate_operand(operand)).to eq("BYTE 0xff")
    end
  end

  describe ".emit_memory_operand" do
    let(:register) { Ronin::ASM::Register.new(:eax, 4)   }
    let(:operand)  { Ronin::ASM::MemoryOperand.new(register) }

    it "must enclose the memory in brackets" do
      expect(subject.emit_memory_operand(operand)).to eq("[eax]")
    end

    context "when operand width does not match the base width" do
      let(:width) { 2 }
      let(:operand) do
        Ronin::ASM::MemoryOperand.new(register,0,nil,1,width)
      end

      it "must specify the width" do
        expect(subject.emit_memory_operand(operand)).to eq("WORD [eax]")
      end
    end

    context "with an offset" do
      let(:offset)  { 255 }
      let(:operand) { Ronin::ASM::MemoryOperand.new(register,offset) }

      it "must add the offset to the base" do
        expect(subject.emit_memory_operand(operand)).to eq("[eax+0xff]")
      end

      context "when 0" do
        let(:operand) { Ronin::ASM::MemoryOperand.new(register,0) }

        it "must omit the offset" do
          expect(subject.emit_memory_operand(operand)).to eq("[eax]")
        end
      end
    end

    context "with an index" do
      let(:index)   { Ronin::ASM::Register.new(:esi, 4) }
      let(:operand) { Ronin::ASM::MemoryOperand.new(register,0,index) }

      it "must add the index to the base" do
        expect(subject.emit_memory_operand(operand)).to eq("[eax+esi]")
      end

      context "with a scale" do
        let(:scale)   { 4 }
        let(:operand) { Ronin::ASM::MemoryOperand.new(register,0,index,scale) }

        it "must multiple the index by the scale" do
          expect(subject.emit_memory_operand(operand)).to eq("[eax+esi*0x4]")
        end
      end
    end
  end

  describe ".emit_instruction" do
    context "with no operands" do
      let(:instruction) { Ronin::ASM::Instruction.new(:ret, []) }

      it "must emit the instruction name" do
        expect(subject.emit_instruction(instruction)).to eq('ret')
      end
    end

    context "with multiple operands" do
      let(:register)    { Ronin::ASM::Register.new(:eax, 4) }
      let(:immediate)   { Ronin::ASM::Immediate.new(0xff, 1)  }
      let(:instruction) { Ronin::ASM::Instruction.new(:mov, [register, immediate]) }

      it "must emit the operands" do
        expect(subject.emit_instruction(instruction)).to eq("mov\teax,\tBYTE 0xff")
      end
    end
  end

  describe ".emit_section" do
    it "must emit the section name" do
      expect(subject.emit_section(:text)).to eq("section .text")
    end
  end

  describe ".emit_program" do
    let(:program) do
      Ronin::ASM::Program.new(arch: :x86) do
        mov eax, 0xff
        ret
      end
    end

    it "must output the _start label and the program" do
      asm = subject.emit_program(program)

      expect(asm).to eq([
        "BITS 32",
        "section .text",
        "_start:",
        "\tmov\teax,\tBYTE 0xff",
        "\tret",
        ""
      ].join($/))
    end

    context "when emitting labels" do
      let(:program) do
        Ronin::ASM::Program.new(arch: :x86) do
          mov eax, 0

          _loop do
            inc eax
            cmp eax, 10
            jl  :_loop
          end

          ret
        end
      end

      it "must emit both labels and instructions" do
        expect(subject.emit_program(program)).to eq([
          "BITS 32",
          "section .text",
          "_start:",
          "\tmov\teax,\tBYTE 0x0",
          "_loop:",
          "\tinc\teax",
          "\tcmp\teax,\tBYTE 0xa",
          "\tjl\t_loop",
          "\tret",
          ""
        ].join($/))
      end
    end

    context "when the program arch is :amd64" do
      let(:program) do
        Ronin::ASM::Program.new(arch: :amd64) do
          push rax
          push rbx
          mov  rax, 0xff
          ret
        end
      end

      it "must include start with the '.code64' directive" do
        expect(subject.emit_program(program)).to match(/^BITS 64$/)
      end
    end
  end
end
