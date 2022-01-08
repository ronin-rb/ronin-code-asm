require 'spec_helper'
require 'ronin/asm/version'

describe ASM do
  it "should have a version" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end
end
