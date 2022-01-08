require 'spec_helper'

require 'ronin/asm/syntax/att'
require 'ronin/asm/register'
require 'ronin/asm/immediate_operand'
require 'ronin/asm/memory_operand'
require 'ronin/asm/instruction'
require 'ronin/asm/program'

describe ASM::Syntax::ATT do
  subject { described_class }

  describe "emit_register" do
    let(:register) { Register.new(:eax, 4) }

    it "should prepend a '%' to the register name" do
      expect(subject.emit_register(register)).to eq("%eax")
    end
  end

  describe "emit_immediate_operand" do
    let(:operand) { ImmediateOperand.new(255, 1) }

    it "should prepend a '$' to the immediate" do
      expect(subject.emit_immediate_operand(operand)).to eq("$0xff")
    end
  end

  describe "emit_memory_operand" do
    let(:register) { Register.new(:eax, 4)   }
    let(:operand)  { MemoryOperand.new(register) }

    it "should enclose the memory in parenthesis" do
      expect(subject.emit_memory_operand(operand)).to eq("(%eax)")
    end

    context "with an offset" do
      let(:offset)  { 255 }
      let(:operand) { MemoryOperand.new(register,offset) }

      it "should prepend the offset as an integer" do
        expect(subject.emit_memory_operand(operand)).to eq("0xff(%eax)")
      end

      context "when 0" do
        let(:operand) { MemoryOperand.new(register,0) }

        it "should omit the offset" do
          expect(subject.emit_memory_operand(operand)).to eq("(%eax)")
        end
      end
    end

    context "with an index" do
      let(:index)   { Register.new(:esi, 4) }
      let(:operand) { MemoryOperand.new(register,0,index) }

      it "should include the index argument" do
        expect(subject.emit_memory_operand(operand)).to eq("(%eax,%esi)")
      end

      context "with a scale" do
        let(:scale)   { 4 }
        let(:operand) { MemoryOperand.new(register,0,index,scale) }

        it "should prepend the scale argument as a decimal" do
          expect(subject.emit_memory_operand(operand)).to eq("(%eax,%esi,#{scale})")
        end
      end
    end
  end

  describe "emit_instruction" do
    context "with no operands" do
      let(:instruction) { Instruction.new(:ret, []) }

      it "should emit the instruction name" do
        expect(subject.emit_instruction(instruction)).to eq('ret')
      end
    end

    context "with one operand" do
      context "with width of 1" do
        let(:immediate)   { ImmediateOperand.new(0x80, 1) }
        let(:instruction) { Instruction.new(:int, [immediate]) }

        it "should not append a size specifier to the instruction name" do
          expect(subject.emit_instruction(instruction)).to eq("int\t$0x80")
        end
      end
    end

    context "with multiple operands" do
      let(:register)    { Register.new(:eax, 4) }
      let(:immediate)   { ImmediateOperand.new(0xff, 1)  }
      let(:instruction) { Instruction.new(:mov, [register, immediate]) }

      it "should add a size specifier to the instruction name" do
        expect(subject.emit_instruction(instruction)).to match(/^movl/)
      end

      it "should emit the operands" do
        expect(subject.emit_instruction(instruction)).to eq("movl\t$0xff,\t%eax")
      end
    end
  end

  describe "emit_section" do
    it "should emit the section name" do
      expect(subject.emit_section(:text)).to eq(".text")
    end
  end

  describe "emit_program" do
    let(:program) do
      Program.new do
        mov eax, 0xff
        ret
      end
    end

    it "should output the _start label and the program" do
      asm = subject.emit_program(program)

      expect(asm).to eq([
        ".code32",
        ".text",
        "_start:",
        "\tmovl\t$0xff,\t%eax",
        "\tret",
        ""
      ].join($/))
    end

    context "when emitting labels" do
      let(:program) do
        Program.new do
          mov eax, 0

          _loop do
            inc eax
            cmp eax, 10
            jl  :_loop
          end

          ret
        end
      end

      it "should emit both labels and instructions" do
        expect(subject.emit_program(program)).to eq([
          ".code32",
          ".text",
          "_start:",
          "\tmovl\t$0x0,\t%eax",
          "_loop:",
          "\tincl\t%eax",
          "\tcmpl\t$0xa,\t%eax",
          "\tjl\t_loop",
          "\tret",
          ""
        ].join($/))
      end
    end

    context "when the program arch is :amd64" do
      let(:program) do
        Program.new(arch: :amd64) do
          push rax
          push rbx
          mov 0xff, rax
          ret
        end
      end

      it "should include start with the '.code64' directive" do
        expect(subject.emit_program(program)).to match(/^\.code64$/)
      end
    end
  end
end
