require 'ronin/code/asm'

require 'spec_helper'
require 'code/asm/helpers/files'

require 'tempfile'

describe Code do
  include Helpers::Files

  it "should be able to assemble a file" do
    Tempfile.open('ronin-asm') do |output|
      Code.asm do |yasm|
        yasm.parser = :nasm
        yasm.output = output.path
        yasm.file = assembly_file('simple')
      end

      output.size.should > 0
    end
  end

  it "should be able to assemble a file and return the output" do
    output = Code.asm_inline do |yasm|
      yasm.parser = :nasm
      yasm.file = assembly_file('simple')
    end

    output.should_not be_empty
  end
end
