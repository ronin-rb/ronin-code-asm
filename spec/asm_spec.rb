require 'spec_helper'
require 'ronin/asm/version'

describe ASM do
  it "should have a version" do
    subject.const_defined?('VERSION').should == true
  end
end
