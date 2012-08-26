require 'spec_helper'

require 'ronin/asm/archs/amd64'
require 'ronin/asm/program'

describe Archs::AMD64 do
  let(:program) { Program.new(:arch => :amd64) }

  subject { program }

  describe "#syscall" do
    before { subject.syscall }

    it "should add a 'syscall' instruction" do
      subject.instructions[-1].name.should == :syscall
    end
  end
end
