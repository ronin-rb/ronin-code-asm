source 'https://rubygems.org'

gemspec

gem 'jruby-openssl',	'~> 0.7', platform: :jruby

# gem 'ruby-yasm', '~> 0.3', github: 'postmodern/ruby-yasm',
#                            branch: 'main'

# Ronin dependencies
# gem 'ronin-core',            '~> 0.2', github: 'ronin-rb/ronin-core',
#                                        branch: 'main'

group :development do
  gem 'rake'
  gem 'rubygems-tasks',  '~> 0.1'

  gem 'rspec',           '~> 3.0'
  gem 'simplecov',       '~> 0.20'

  gem 'kramdown',        '~> 2.3'
  gem 'kramdown-man',    '~> 1.0'

  gem 'redcarpet',       platform: :mri
  gem 'yard',            '~> 0.9'
  gem 'yard-spellcheck', require: false

  gem 'dead_end',        require: false
  gem 'sord',            require: false, platform: :mri
  gem 'stackprof',       require: false, platform: :mri

  gem 'command_kit-completion', '~> 0.2', require: false
end
