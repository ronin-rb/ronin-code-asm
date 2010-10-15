# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ronin-asm}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Postmodern"]
  s.date = %q{2010-10-15}
  s.description = %q{Ronin ASM is a Ruby library for Ronin that provides dynamic Assembly (ASM) generation of programs or shellcode.}
  s.email = %q{ronin-ruby@googlegroups.com}
  s.extra_rdoc_files = [
    "ChangeLog.md",
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".yardopts",
    "COPYING.txt",
    "ChangeLog.md",
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "data/ronin/gen/asm/source_file.s.erb",
    "lib/ronin/asm.rb",
    "lib/ronin/asm/asm.rb",
    "lib/ronin/asm/config.rb",
    "lib/ronin/asm/version.rb",
    "lib/ronin/code/asm.rb",
    "lib/ronin/code/asm/code.rb",
    "lib/ronin/code/asm/source_code.rb",
    "lib/ronin/code/asm/source_file.rb",
    "lib/ronin/gen/generators/asm/source_file.rb",
    "ronin-asm.gemspec",
    "spec/asm_spec.rb",
    "spec/code/asm/code_spec.rb",
    "spec/code/asm/helpers/files.rb",
    "spec/code/asm/helpers/files/blank.s",
    "spec/code/asm/helpers/files/empty_space.s",
    "spec/code/asm/helpers/files/macros.s",
    "spec/code/asm/helpers/files/multi_comment.s",
    "spec/code/asm/helpers/files/no_yaml_header.s",
    "spec/code/asm/helpers/files/padding_comments.s",
    "spec/code/asm/helpers/files/simple.s",
    "spec/code/asm/helpers/files/simple_nasm.s",
    "spec/code/asm/helpers/files/symbol_keys.s",
    "spec/code/asm/helpers/files/white_space.s",
    "spec/code/asm/source_file_spec.rb",
    "spec/helpers/database.rb",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = %q{yard}
  s.homepage = %q{http://github.com/ronin-ruby/ronin-asm}
  s.licenses = ["GPL-2"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Ruby library for Ronin that provides dynamic Assembly (ASM) generation of programs or shellcode.}
  s.test_files = [
    "spec/asm_spec.rb",
    "spec/code/asm/code_spec.rb",
    "spec/code/asm/helpers/files.rb",
    "spec/code/asm/source_file_spec.rb",
    "spec/helpers/database.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<data_paths>, ["~> 0.2.1"])
      s.add_runtime_dependency(%q<ffi-udis86>, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<ruby-yasm>, ["~> 0.1.1"])
      s.add_runtime_dependency(%q<ronin>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<ronin-gen>, ["~> 0.3.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0.pre"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0"])
    else
      s.add_dependency(%q<data_paths>, ["~> 0.2.1"])
      s.add_dependency(%q<ffi-udis86>, ["~> 0.1.0"])
      s.add_dependency(%q<ruby-yasm>, ["~> 0.1.1"])
      s.add_dependency(%q<ronin>, ["~> 0.4.0"])
      s.add_dependency(%q<ronin-gen>, ["~> 0.3.0"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre"])
      s.add_dependency(%q<rspec>, ["~> 2.0.0"])
    end
  else
    s.add_dependency(%q<data_paths>, ["~> 0.2.1"])
    s.add_dependency(%q<ffi-udis86>, ["~> 0.1.0"])
    s.add_dependency(%q<ruby-yasm>, ["~> 0.1.1"])
    s.add_dependency(%q<ronin>, ["~> 0.4.0"])
    s.add_dependency(%q<ronin-gen>, ["~> 0.3.0"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre"])
    s.add_dependency(%q<rspec>, ["~> 2.0.0"])
  end
end

