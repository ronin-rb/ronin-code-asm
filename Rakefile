# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('ronin-asm') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_title = 'Ronin ASM Documentation'
  self.yard_options += ['--protected']

  self.extra_deps = [
    ['ronin', '>= 0.4.0']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.2.8'],
  ]
end

# vim: syntax=Ruby
