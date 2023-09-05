# ronin-code-asm

[![CI](https://github.com/ronin-rb/ronin-code-asm/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-asm/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-code-asm.svg)](https://codeclimate.com/github/ronin-rb/ronin-asm)
[![Gem Version](https://badge.fury.io/rb/ronin-code-asm.svg)](https://badge.fury.io/rb/ronin-code-asm)

* [Source](https://github.com/ronin-rb/ronin-code-asm)
* [Issues](https://github.com/ronin-rb/ronin-code-asm/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-code-asm/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

{Ronin::Code::ASM} is a Ruby DSL for crafting Assembly programs and Shellcode.

## Features

* Provides a Ruby DSL for writing Assembly programs.
  * Supports X86 and AMD64 instruction sets.
  * Supports ATT and Intel syntax.
* Uses [yasm] to assemble the programs.
* Supports assembling Shellcode.
* Has 95% documentation coverage.
* Has 99% test coverage.

## Examples

Create a program:

```ruby
asm = Ronin::Code::ASM.new do
  push ebx
  mov  eax, 0xc0ffee
  pop  ebx
  hlt
end

puts asm.to_asm
# BITS 32
# section .text
# _start:
#	push	ebx
#	mov	eax,	WORD 0xc0ffee
#	pop	ebx
#	hlt

puts asm.to_asm(:att)
# .code32
# .text
# _start:
#	pushl	%ebx
#	movl	$0xc0ffee,      %eax
#	popl	%ebx
#	hlt
```

Create shellcode:

```ruby
shellcode = Ronin::Code::ASM::Shellcode.new(arch: :x86) do
  xor   eax,  eax
  push  eax
  push  0x68732f2f
  push  0x6e69622f
  mov   ebx,  esp
  push  eax
  push  ebx
  mov   ecx,  esp
  xor   edx,  edx
  mov   al,   0xb
  int   0x80
end

shellcode.assemble
# => "1\xC0Ph//shh/bin\x89\xDCPS\x89\xCC1\xD2\xB0\v\xCD\x80"
```

### Immediate Operands

Immediate operands can be Integers or `nil`:

```ruby
mov eax, 0xff
mov ebx, nil
```

The size of the operand can also be specified explicitly:

```ruby
push byte(0xff)
push word(0xffff)
push dword(0xffffffff)
push qword(0xffffffffffffffff)
```

### Memory Operands

Memory operands can be expressed as arithmetic on registers:

```ruby
mov ebx, esp+8
mov ebx, esp-8
mov ebx, esp+esi
mov ebx, esp+(esi*4)
```

### Labels

Labels can be expressed with blocks:

```ruby
_loop do
  inc eax
  cmp eax, 10
  jl :_loop
end
```

### Syscalls

If the `:os` option is specified, then syscall numbers can be looked up via the
`syscalls` Hash:

```ruby
Ronin::Code::ASM.new(os: 'Linux') do
  # ...
  mov al, syscalls[:execve]
  int 0x80
end
```

## Requirements

* [Ruby] >= 3.0.0
* [yasm] >= 0.6.0
* [ruby-yasm] ~> 0.3

## Install

### Ubuntu

```shell
sudo apt install -y yasm
gem install ronin-code-asm
```

### Fedora

```shell
sudo dnf install -y yasm
gem install ronin-code-asm
```

### OpenSUSE

```shell
sudo zypper -n in -l yasm
gem install ronin-code-asm
```

### Arch

```shell
sudo pacman -Sy yasm
gem install ronin-code-asm
```

### macOS

```shell
brew install yasm
gem install ronin-code-asm
```

### FreeBSD

```shell
sudo pkg install -y yasm
gem install ronin-code-asm
```

### Gemfile

```ruby
gem 'ronin-code-asm', '~> 1.0'
```

### gemspec

```ruby
gem.add_dependency 'ronin-code-asm', '~> 1.0'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-code-asm/fork)
2. Clone It!
3. `cd ronin-code-asm/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

ronin-code-asm - A Ruby DSL for crafting Assembly programs and shellcode.

Copyright (c) 2007-2023 Hal Brodigan (postmodern.mod3 at gmail.com)

ronin-code-asm is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-code-asm is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-code-asm.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[yasm]: https://yasm.tortall.net/
[ruby-yasm]: https://github.com/sophsec/ruby-yasm#readme
