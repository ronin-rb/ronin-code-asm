require 'rubygems'
require 'rake'
require './lib/ronin/asm/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ronin-asm'
    gem.version = Ronin::ASM::VERSION
    gem.summary = %Q{A Ruby library for Ronin that provides dynamic Assembly (ASM) generation of programs or shellcode.}
    gem.description = %Q{Ronin ASM is a Ruby library for Ronin that provides dynamic Assembly (ASM) generation of programs or shellcode.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/ronin-ruby/ronin-asm'
    gem.authors = ['Postmodern']
    gem.add_dependency 'ruby-yasm', '>= 0.1.0'
    gem.add_dependency 'ronin-ext', '>= 0.1.0'
    gem.add_development_dependency 'rspec', '>= 1.3.0'
    gem.add_development_dependency 'yard', '>= 0.5.3'
    gem.has_rdoc = 'yard'
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
