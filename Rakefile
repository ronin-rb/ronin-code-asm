require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new(sign: {checksum: true, pgp: true})

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec
task :test    => :spec

namespace :spec do
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern    = %w[spec/program_spec.rb spec/shellcode_spec.rb]
    t.rspec_opts = '--tag integration'
  end
end

task :test => 'spec:integration'

require 'yard'
YARD::Rake::YardocTask.new

require 'kramdown/man/task'
Kramdown::Man::Task.new

require 'command_kit/completion/task'
CommandKit::Completion::Task.new(
  class_file:  'ronin/asm/cli',
  class_name:  'Ronin::ASM::CLI',
  output_file: 'data/completions/ronin-asm'
)

task :setup => %w[man command_kit:completion]
