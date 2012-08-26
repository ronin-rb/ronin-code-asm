require 'spec_helper'
require 'archs/x86_examples'

require 'ronin/asm/archs/x86'
require 'ronin/asm/program'

describe Archs::X86 do
  let(:program) { Program.new(:arch => :x86) }

  subject { program }

  it_should_behave_like "Archs::X86"
end
