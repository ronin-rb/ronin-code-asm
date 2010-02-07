# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('ronin-asm') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_title = 'Ronin ASM Documentation'
  self.yard_options += ['--markup', 'markdown', '--protected']
  self.remote_yard_dir = 'docs/ronin-asm'

  self.extra_deps = [
    ['ronin', '>= 0.4.0'],
    ['ruby-yasm', '>=0.1.1']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.3.0'],
    ['yard', '>=0.5.3']
  ]
end

# vim: syntax=Ruby
