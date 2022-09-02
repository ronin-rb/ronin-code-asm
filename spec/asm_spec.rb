require 'spec_helper'
require 'ronin/code/asm'

describe Ronin::Code::ASM do
  it "must have a version" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end

  describe ".new" do
    it "must return a new Ronin::Code::ASM::Program" do
      expect(subject.new(arch: :x86)).to be_kind_of(Ronin::Code::ASM::Program)
    end
  end
end
