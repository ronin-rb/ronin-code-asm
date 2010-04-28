require 'spec_helper'
require 'ronin/asm/version'

describe ASM do
  it "should have a version" do
    ASM.const_defined?('VERSION').should == true
  end
end
