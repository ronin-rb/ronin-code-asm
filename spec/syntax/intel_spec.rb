require 'spec_helper'

require 'ronin/asm/syntax/intel'
require 'ronin/asm/register'
require 'ronin/asm/literal'
require 'ronin/asm/immediate'
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

  describe "emit_literal" do
    let(:literal) { Literal.new(255, 1) }

    it "should prepend a size specifier" do
      subject.emit_literal(literal).should == "BYTE 0xff"
    end
  end

  describe "emit_immediate" do
    let(:register)  { Register.new(:eax, 4)   }
    let(:immediate) { Immediate.new(register) }

    it "should enclose the immediate in brackets" do
      subject.emit_immediate(immediate).should == "[eax]"
    end

    context "with an offset" do
      let(:offset)    { 255 }
      let(:immediate) { Immediate.new(register,offset) }

      it "should add the offset to the base" do
        subject.emit_immediate(immediate).should == "[eax+0xff]"
      end

      context "when 0" do
        let(:immediate) { Immediate.new(register,0) }

        it "should omit the offset" do
          subject.emit_immediate(immediate).should == "[eax]"
        end
      end
    end

    context "with an index" do
      let(:index)     { Register.new(:esi, 4) }
      let(:immediate) { Immediate.new(register,0,index) }

      it "should add the index to the base" do
        subject.emit_immediate(immediate).should == "[eax+esi]"
      end

      context "with a scale" do
        let(:scale)     { 4 }
        let(:immediate) { Immediate.new(register,0,index,scale) }

        it "should multiple the index by the scale" do
          subject.emit_immediate(immediate).should == "[eax+esi*0x4]"
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
      let(:literal)     { Literal.new(0xff, 1)  }
      let(:instruction) { Instruction.new(:mov, [literal, register]) }

      it "should emit the operands" do
        subject.emit_instruction(instruction).should == "mov\teax,\tBYTE 0xff"
      end
    end
  end

  describe "emit_program" do
    let(:program) do
      Program.new do
        mov 0xff, eax
        ret
      end
    end

    it "should output the _start label and the program" do
      asm = subject.emit_program(program)

      asm.should == [
        "_start:",
        "\tmov\teax,\tBYTE 0xff",
        "\tret",
        ""
      ].join($/)
    end

    context "when emitting labels" do
      let(:program) do
        Program.new do
          mov 0, eax

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
          "_start:",
          "\tmov\teax,\tBYTE 0x0",
          "_loop:",
          "\tinc\teax",
          "\tcmp\tBYTE 0xa,\teax",
          "\tjl\t_loop",
          "\tret",
          ""
        ].join($/)
      end
    end

    context "when the program arch is :amd64" do
      let(:program) do
        Program.new(:arch => :amd64) do
          push rax
          push rbx
          mov 0xff, rax
          ret
        end
      end

      it "should include start with the '.code64' directive" do
        subject.emit_program(program).should =~ /^BITS 64$/
      end
    end
  end
end
