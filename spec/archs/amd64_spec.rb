require 'spec_helper'
require 'archs/x86_examples'

require 'ronin/asm/archs/amd64'
require 'ronin/asm/program'

describe Archs::AMD64 do
  let(:program) { Program.new(:arch => :amd64) }

  subject { program }

  it_should_behave_like "Archs::X86"

  its(:general_registers) { should include(:rax, :rbx, :rcx, :rdx, :rsi, :rdi) }

  describe "registers" do
    subject { program.registers.keys }

    it do
      should include(
        :rax,
        :rbx,
        :rcx,
        :rdx,

        :rsi,
        :rdi,

        :rbp,
        :rsp,

        :r8b,
        :r8w,
        :r8d,
        :r8,

        :r9b,
        :r9w,
        :r9d,
        :r9,

        :r10b,
        :r10w,
        :r10d,
        :r10,

        :r11b,
        :r11w,
        :r11d,
        :r11,

        :r12b,
        :r12w,
        :r12d,
        :r12,

        :r13b,
        :r13w,
        :r13d,
        :r13,

        :r14b,
        :r14w,
        :r14d,
        :r14,

        :r15b,
        :r15w,
        :r15d,
        :r15,

        :rip
      )
    end
  end

  describe "#syscall" do
    before { subject.syscall }

    it "should add a 'syscall' instruction" do
      subject.instructions[-1].name.should == :syscall
    end
  end
end
