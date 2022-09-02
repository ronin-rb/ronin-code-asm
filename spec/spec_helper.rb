require 'rspec'
require 'ronin/asm/version'

RSpec.configure do |specs|
  specs.filter_run_excluding :yasm
end
