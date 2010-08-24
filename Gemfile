source 'https://rubygems.org'

RONIN = 'git://github.com/ronin-ruby'
SOPHSEC = 'git://github.com/sophsec'

gem 'data_paths',	'~> 0.2.1'
gem 'ffi-udis86',	'~> 0.1.0', :require => 'udis86'
gem 'ruby-yasm',	'~> 0.1.1', :require => 'yasm'
gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"
gem 'ronin-gen',	'~> 0.3.0', :git => "#{RONIN}/ronin-gen.git"
gem 'ronin',		'~> 0.4.0', :git => "#{RONIN}/ronin.git"

group(:development) do
  gem 'bundler',	'~> 1.0.0'
  gem 'rake',		'~> 0.8.7'
  gem 'jeweler',	'~> 1.5.0', :git => 'git://github.com/technicalpickles/jeweler.git'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.5.3'
end

gem 'rspec',	'~> 2.0.0.beta.20', :group => [:development, :test]
