require 'spec_helper'
require 'ronin/asm'

describe Ronin::ASM do
  it "should have a version" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end

  describe ".new" do
    it "must return a new Ronin::ASM::Program" do
      expect(subject.new(arch: :x86)).to be_kind_of(Ronin::ASM::Program)
    end
  end
end
