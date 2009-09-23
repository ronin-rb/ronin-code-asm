# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './tasks/yard.rb'

Hoe.spec('ronin-asm') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern','postmodern.mod3@gmail.com')
  self.extra_deps = [
    ['ronin', '>= 0.3.0']
  ]

  self.extra_dev_deps = [
    ['yard', '>=0.2.3.5'],
    ['rspec', '>=1.1.12']
  ]

  self.spec_extras = {:has_rdoc => 'yard'}
end

# vim: syntax=Ruby
