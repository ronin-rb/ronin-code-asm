require 'rspec'
require 'ronin/asm/version'

include Ronin
include Ronin::ASM

RSpec.configure do |specs|
  specs.treat_symbols_as_metadata_keys_with_true_values = true
  specs.filter_run_excluding :yasm
end
