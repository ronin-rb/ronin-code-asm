# Ronin ASM

* [Source](https://github.com/ronin-ruby/ronin-asm)
* [Issues](https://github.com/ronin-ruby/ronin-asm/issues)
* [Documentation](http://rubydoc.info/github/ronin-ruby/ronin-asm/frames)
* [Mailing List](https://groups.google.com/group/ronin-ruby)
* [irc.freenode.net #ronin](http://ronin-ruby.github.com/irc/)

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

    asm = ASM.new do
      push ebx
      mov  eax, 0xc0ffee
      pop  ebx
      hlt
    end

    puts asm.to_asm
    # _start:
    #	push	ebx
    #	mov	eax,	WORD 0xc0ffee
    #	pop	ebx
    #	hlt

    puts asm.to_asm(:att)
    # _start:
    #	pushl	%ebx
    #	movl	%ebx,	%eax
    #	popl	%ebx
    #	hlt

Create shellcode:

    shellcode = ASM::Shellcode.new(:arch => :x86) do
      xor   eax,  eax
      push  eax
      push  0x68732f2f
      push  0x6e69622f
      mov   esp,  ebx
      push  eax
      push  ebx
      mov   esp,  ecx
      xor   edx,  edx
      mov   0xb,  al
      int   0x80
    end
    
    shellcode.assemble
    # => "f1\xC0fPfh//shfh/binf\x89\xE3fPfSf\x89\xE1f1\xD2\xB0\v\xCD\x80"

### Immediate Operands

Immediate operands can be Integers or `nil`:

    mov eax, 0xff
    mov ebx, nil

The size of the operand can also be specified explicitly:

    push byte(0xff)
    push word(0xffff)
    push dword(0xffffffff)
    push qword(0xffffffffffffffff)

### Memory Operands

Memory operands can be expressed as arithmatic on registers:

    mov ebx, eax+8
    mov ebx, eax-8
    mov ebx, eax+esi
    mov ebx, eax+(esi*4)

### Labels

Labels can be expressed with blocks:

    _loop do
      inc eax
      cmp eax, 10
      jl :_loop
    end

### Syscalls

If the `:os` option is specified, then syscall numbers can be looked up via the 
`syscalls` Hash:

    ASM.new(:os => 'Linux') do
      # ...
      mov syscalls[:execve], al
      int 0x80
    end

## Requirements

* [Ruby] >= 1.9.1
* [data\_paths] ~> 0.3
* [yasm] >= 0.6.0
* [ruby-yasm] ~> 0.2

## Install

    $ gem install ronin-asm

## License

Ronin::ASM - A Ruby DSL for crafting Assmebly programs and Shellcode.

Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of Ronin ASM.

Ronin Asm is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin Asm is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin Asm.  If not, see <http://www.gnu.org/licenses/>.

[Ruby]: http://www.ruby-lang.org
[yasm]: http://yasm.tortall.net/
[data_paths]: https://github.com/postmodern/data_paths#readme
[ruby-yasm]: https://github.com/sophsec/ruby-yasm#readme
