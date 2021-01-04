require 'rspec'
require 'ronin/asm/version'

include Ronin
include Ronin::ASM

RSpec.configure do |specs|
  specs.filter_run_excluding :yasm
end
