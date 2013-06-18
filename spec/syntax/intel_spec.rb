require 'spec_helper'

require 'ronin/asm/syntax/intel'
require 'ronin/asm/register'
require 'ronin/asm/immediate_operand'
require 'ronin/asm/memory_operand'
require 'ronin/asm/instruction'
require 'ronin/asm/program'

describe ASM::Syntax::Intel do
  subject { described_class }

  describe "emit_register" do
    let(:register) { Register.new(:eax, 4) }

    it "should return the register name" do
      subject.emit_register(register).should == "eax"
    end
  end

  describe "emit_immediate_operand" do
    let(:operand) { ImmediateOperand.new(255, 1) }

    it "should prepend a size specifier" do
      subject.emit_immediate_operand(operand).should == "BYTE 0xff"
    end
  end

  describe "emit_memory_operand" do
    let(:register) { Register.new(:eax, 4)   }
    let(:operand)  { MemoryOperand.new(register) }

    it "should enclose the memory in brackets" do
      subject.emit_memory_operand(operand).should == "[eax]"
    end

    context "when operand width does not match the base width" do
      before { operand.width = 2 }

      it "should specify the width" do
        subject.emit_memory_operand(operand).should == "WORD [eax]"
      end
    end

    context "with an offset" do
      let(:offset)  { 255 }
      let(:operand) { MemoryOperand.new(register,offset) }

      it "should add the offset to the base" do
        subject.emit_memory_operand(operand).should == "[eax+0xff]"
      end

      context "when 0" do
        let(:operand) { MemoryOperand.new(register,0) }

        it "should omit the offset" do
          subject.emit_memory_operand(operand).should == "[eax]"
        end
      end
    end

    context "with an index" do
      let(:index)   { Register.new(:esi, 4) }
      let(:operand) { MemoryOperand.new(register,0,index) }

      it "should add the index to the base" do
        subject.emit_memory_operand(operand).should == "[eax+esi]"
      end

      context "with a scale" do
        let(:scale)   { 4 }
        let(:operand) { MemoryOperand.new(register,0,index,scale) }

        it "should multiple the index by the scale" do
          subject.emit_memory_operand(operand).should == "[eax+esi*0x4]"
        end
      end
    end
  end

  describe "emit_instruction" do
    context "with no operands" do
      let(:instruction) { Instruction.new(:ret, []) }

      it "should emit the instruction name" do
        subject.emit_instruction(instruction).should == 'ret'
      end
    end

    context "with multiple operands" do
      let(:register)    { Register.new(:eax, 4) }
      let(:immediate)   { ImmediateOperand.new(0xff, 1)  }
      let(:instruction) { Instruction.new(:mov, [register, immediate]) }

      it "should emit the operands" do
        subject.emit_instruction(instruction).should == "mov\teax,\tBYTE 0xff"
      end
    end
  end

  describe "emit_section" do
    it "should emit the section name" do
      subject.emit_section(:text).should == "section .text"
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

      asm.should == [
        "BITS 32",
        "section .text",
        "_start:",
        "\tmov\teax,\tBYTE 0xff",
        "\tret",
        ""
      ].join($/)
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
        subject.emit_program(program).should == [
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
        ].join($/)
      end
    end

    context "when the program arch is :amd64" do
      let(:program) do
        Program.new(arch: :amd64) do
          push rax
          push rbx
          mov  rax, 0xff
          ret
        end
      end

      it "should include start with the '.code64' directive" do
        subject.emit_program(program).should =~ /^BITS 64$/
      end
    end
  end
end
