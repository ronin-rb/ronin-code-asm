source 'https://rubygems.org'

RONIN = 'http://github.com/ronin-ruby'
SOPHSEC = 'http://github.com/sophsec'

gem 'data_paths',	'~> 0.2.1'
gem 'ffi-udis86',	'~> 0.1.0', :git => "#{SOPHSEC}/ffi-udis86.git"
gem 'ruby-yasm',	'~> 0.1.1', :require => 'yasm'
gem 'ronin',		'~> 0.4.0', :git => "#{RONIN}/ronin.git"
gem 'ronin-gen',	'~> 0.3.0', :git => "#{RONIN}/ronin-gen.git"

group(:edge) do
  gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"
end

group(:development) do
  gem 'rake',		'~> 0.8.7'
  gem 'jeweler',	'~> 1.5.0.pre'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.6.0'
end

gem 'rspec',	'~> 2.0.0.beta.20', :group => [:development, :test]
