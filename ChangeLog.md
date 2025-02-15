### 1.0.1 / 2025-02-14

* Use `require_relative` to improve load times.
* Documentation improvements.

### 1.0.0 / 2023-02-01

* Require `ruby` >= 3.0.0.
* Renamed the gem to `ronin-code-asm`.
* Require `ruby-yasm` ~> 0.3.
* Added {Ronin::Code::ASM::OS.[]}.
* Removed the `data_paths` gem dependency.

### 0.2.0 / 2013-06-17

* Require [Ruby] >= 1.9.1.
* Added `Ronin::ASM::Syntax::ATT.emit_section` and
  `Ronin::ASM::Syntax::Intel.emit_section`.
* Added `Ronin::ASM::Syntax::ATT.emit_prologue` and
  `Ronin::ASM::Syntax::Intel.emit_prologue`.
* `Ronin::ASM::Instruction` now assumes Intel operand order:

      mov eax, 0x41

* `Ronin::ASM::Program#byte`, `Ronin::ASM::Program#word`,
  `Ronin::ASM::Program#dword` and `Ronin::ASM::Program#qword` methods can now
  accept `Ronin::ASM::MemoryOperand`s.

      mov bx, word(ebp+8)

* `Ronin::ASM::Program#to_asm` now emits Intel syntax by default.
* `Ronin::ASM::Program#assemble` now uses Intel syntax by default.
* `Ronin::ASM::Syntax::ATT` emit `.code32` directive to forcibly enable 32-bit
  mode for the x86 architecture. [YASM][yasm] apparently defaults to 16-bit
  mode.
* `Ronin::ASM::Syntax::Intel` emit `BITS 32` directive to forcibly enable
  32-bit mode for the x86 architecture.

### 0.1.0 / 2012-08-26

* Initial release:
  * Provides a Ruby DSL for writing Assembly programs.
    * Supports X86 and AMD64 instruction sets.
    * Supports ATT and Intel syntax.
  * Uses [yasm] to assemble the programs.
  * Supports assembling Shellcode.

[Ruby]: http://www.ruby-lang.org
[yasm]: http://yasm.tortall.net/
