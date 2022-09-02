require 'spec_helper'
require 'ronin/code/asm/config'

describe Ronin::Code::ASM::Config do
  describe "DATA_DIR" do
    it "must be a directory" do
      expect(File.directory?(subject::DATA_DIR)).to be(true)
    end
  end
end
