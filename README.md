# ronin-asm

[![CI](https://github.com/ronin-rb/ronin-asm/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-asm/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-asm.svg)](https://codeclimate.com/github/ronin-rb/ronin-asm)

* [Source](https://github.com/ronin-rb/ronin-asm)
* [Issues](https://github.com/ronin-rb/ronin-asm/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-asm/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb)

## Description

{Ronin::ASM} is a Ruby DSL for crafting Assmebly programs and Shellcode.

## Features

* Provides a Ruby DSL for writing Assembly programs.
  * Supports X86 and AMD64 instruction sets.
  * Supports ATT and Intel syntax.
* Uses [yasm] to assemble the programs.
* Supports assembling Shellcode.

## Examples

Create a program:

```ruby
asm = ASM.new do
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
#	movl	%ebx,	%eax
#	popl	%ebx
#	hlt
```

Create shellcode:

```ruby
shellcode = ASM::Shellcode.new(arch: :x86) do
  xor   eax,  eax
  push  eax
  push  0x68732f2f
  push  0x6e69622f
  mov   esp,  ebx
  push  eax
  push  ebx
  mov   esp,  ecx
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

Memory operands can be expressed as arithmatic on registers:

```ruby
mov ebx, eax+8
mov ebx, eax-8
mov ebx, eax+esi
mov ebx, eax+(esi*4)
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
ASM.new(os: 'Linux') do
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

```shell
$ gem install ronin-asm
```

## License

ronin-asm - A Ruby DSL for crafting Assmebly programs and Shellcode.

Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of ronin-asm.

ronin-asm is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-asm is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-asm.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[yasm]: https://yasm.tortall.net/
[ruby-yasm]: https://github.com/sophsec/ruby-yasm#readme
