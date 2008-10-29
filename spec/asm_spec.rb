require 'ronin/asm/version'

require 'spec_helper'

describe ASM do
  it "should have a version" do
    ASM.const_defined?('VERSION').should == true
  end
end
