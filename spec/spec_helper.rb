require 'rspec'
require 'ronin/code/asm/version'

RSpec.configure do |specs|
  specs.filter_run_excluding :yasm
end
