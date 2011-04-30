#
# Ronin ASM - a Ruby library for Ronin that provides dynamic Assembly (ASM)
# generation of programs or shellcode.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

module Ronin
  module Code
    module ASM
      module Archs
        module X86
          def al;  register(:al,  1);  end
          def ah;  register(:ah,  1);  end
          def ax;  register(:ax,  2);  end
          def eax; register(:eax, 4); end

          def bl;  register(:bl,  1);  end
          def bh;  register(:bh,  1);  end
          def bx;  register(:bx,  2);  end
          def ebx; register(:ebx, 4); end

          def cl;  register(:cl,  1);  end
          def ch;  register(:ch,  1);  end
          def cx;  register(:cx,  2);  end
          def ecx; register(:ecx, 4); end

          def dl;  register(:dl,  1);  end
          def dh;  register(:dh,  1);  end
          def dx;  register(:dx,  2);  end
          def edx; register(:edx, 4); end

          def sb;  register(:sb,  2); end
          def esb; register(:esb, 4); end
          def sp;  register(:sp,  2); end
          def esp; register(:esp, 4); end
          def ip;  register(:ip,  2); end
          def eip; register(:eip, 4); end

          def esi; register(:esi, 4); end
          def edi; register(:edi, 4); end

          def cs; register(:cs, 2); end
          def ds; register(:ds, 2); end
          def es; register(:es, 2); end
          def fs; register(:fs, 2); end
          def gs; register(:gs, 2); end
          def ss; register(:ss, 2); end

          def adc(op1,op2); instruction(:adc,op1,op2); end
          def add(op1,op2); instruction(:add,op1,op2); end
          def addpd(op1,op2); instruction(:addpd,op1,op2); end
          def addps(op1,op2); instruction(:addps,op1,op2); end
          def addsd(op1,op2); instruction(:addsd,op1,op2); end
          def addss(op1,op2); instruction(:addss,op1,op2); end
          def addsubpd(op1,op2); instruction(:addsubpd,op1,op2); end
          def addsubps(op1,op2); instruction(:addsubps,op1,op2); end
          def aesdec__(op1,op2); instruction(:aesdec__,op1,op2); end
          def aesdeclast(op1,op2); instruction(:aesdeclast,op1,op2); end
          def aesenc(op1,op2); instruction(:aesenc,op1,op2); end
          def aesenclast(op1,op2); instruction(:aesenclast,op1,op2); end
          def aesimc(op); instruction(:aesimc,op); end
          def aeskeygenassist(op1,op2); instruction(:aeskeygenassist,op1,op2); end
          def and(op1,op2); instruction(:and,op1,op2); end
          def andnpd(op1,op2); instruction(:andnpd,op1,op2); end
          def andnps(op1,op2); instruction(:andnps,op1,op2); end
          def andpd(op1,op2); instruction(:andpd,op1,op2); end
          def andps(op1,op2); instruction(:andps,op1,op2); end
          def blendpd(op1,op2); instruction(:blendpd,op1,op2); end
          def blendps(op1,op2); instruction(:blendps,op1,op2); end
          def blendvpd(op1,op2,op3); instruction(:blendvpd,op1,op2,op3); end
          def blendvps(op1,op2,op3); instruction(:blendvps,op1,op2,op3); end
          def call(op); instruction(:call,op); end
          def clc(); instruction(:clc); end
          def cld(); instruction(:cld); end
          def clflush(op); instruction(:clflush,op); end
          def cli(); instruction(:cli); end
          def cmc(); instruction(:cmc); end
          def cmp(op1,op2); instruction(:cmp,op1,op2); end
          def cmppd(op1,op2); instruction(:cmppd,op1,op2); end
          def cmpps(op1,op2); instruction(:cmpps,op1,op2); end
          def cmpsd(op1,op2); instruction(:cmpsd,op1,op2); end
          def cmpss(op1,op2); instruction(:cmpss,op1,op2); end
          def comisd(op1,op2); instruction(:comisd,op1,op2); end
          def comiss(op1,op2); instruction(:comiss,op1,op2); end
          def crc(op1,op2); instruction(:crc,op1,op2); end
          def cvtdq(op); instruction(:cvtdq,op); end
          def cvtdq(op); instruction(:cvtdq,op); end
          def cvtpd(op); instruction(:cvtpd,op); end
          def cvtpd(op); instruction(:cvtpd,op); end
          def cvtpd(op); instruction(:cvtpd,op); end
          def cvtpi(op); instruction(:cvtpi,op); end
          def cvtpi(op1,op2); instruction(:cvtpi,op1,op2); end
          def cvtps(op); instruction(:cvtps,op); end
          def cvtps(op); instruction(:cvtps,op); end
          def cvtps(op); instruction(:cvtps,op); end
          def cvtsd(op); instruction(:cvtsd,op); end
          def cvtsd(op1,op2); instruction(:cvtsd,op1,op2); end
          def cvtsi(op1,op2); instruction(:cvtsi,op1,op2); end
          def cvtsi(op1,op2); instruction(:cvtsi,op1,op2); end
          def cvtss(op1,op2); instruction(:cvtss,op1,op2); end
          def cvtss(op); instruction(:cvtss,op); end
          def cvttpd(op); instruction(:cvttpd,op); end
          def cvttpd(op); instruction(:cvttpd,op); end
          def cvttps(op); instruction(:cvttps,op); end
          def cvttps(op); instruction(:cvttps,op); end
          def cvttsd(op); instruction(:cvttsd,op); end
          def cvttss(op); instruction(:cvttss,op); end
          def dec(op); instruction(:dec,op); end
          def div(op1,op2); instruction(:div,op1,op2); end
          def divpd(op1,op2); instruction(:divpd,op1,op2); end
          def divps(op1,op2); instruction(:divps,op1,op2); end
          def divsd(op1,op2); instruction(:divsd,op1,op2); end
          def divss(op1,op2); instruction(:divss,op1,op2); end
          def dppd(op1,op2,op3); instruction(:dppd,op1,op2,op3); end
          def dpps(op1,op2,op3); instruction(:dpps,op1,op2,op3); end
          def emms(); instruction(:emms,); end
          def enter(op); instruction(:enter,op); end
          def extractps(op1,op2); instruction(:extractps,op1,op2); end
          def haddpd(op1,op2); instruction(:haddpd,op1,op2); end
          def haddps(op1,op2); instruction(:haddps,op1,op2); end
          def hlt(); instruction(:hlt); end
          def hsubpd(op1,op2); instruction(:hsubpd,op1,op2); end
          def hsubps(op1,op2); instruction(:hsubps,op1,op2); end
          def idiv(op1,op2); instruction(:imul,op1,op2); end
          def imul(op1,op2); instruction(:imul,op1,op2); end
          def in(op1,op2); instruction(:in,op1,op2); end
          def inc(op); instruction(:inc,op); end
          def insertps(op1,op2,op3); instruction(:insertps,op1,op2,op3); end
          def int(op); instruction(:int,op); end
          def jmp(op); instruction(:jmp,op); end
          def je(op); instruction(:je,op); end
          def jne(op); instruction(:jne,op); end
          def jg(op); instruction(:jg,op); end
          def jge(op); instruction(:jge,op); end
          def ja(op); instruction(:ja,op); end
          def jae(op); instruction(:jae,op); end
          def jl(op); instruction(:jl,op); end
          def jle(op); instruction(:jle,op); end
          def jb(op); instruction(:jb,op); end
          def jbe(op); instruction(:jbe,op); end
          def jo(op); instruction(:jo,op); end
          def jnz(op); instruction(:jnz,op); end
          def jz(op); instruction(:jz,op); end
          def lahf(op); instruction(:lahf,op); end
          def lddqu(op); instruction(:lddqu,op); end
          def ldmxcsr(op); instruction(:ldmxcsr,op); end
          def lea(op1,op2); instruction(:lea,op1,op2); end
          def leave(); instruction(:leave); end
          def lfence(); instruction(:lfence); end
          def lock(); instruction(:lock); end
          def loop(op); instruction(:loop,op); end
          def loopx(op); instruction(:loopx,op); end
          def maskmovdqu(op1,op2,op3); instruction(:maskmovdqu,op1,op2,op3); end
          def maskmovq(op1,op2,op3); instruction(:maskmovq,op1,op2,op3); end
          def maxpd(op1,op2); instruction(:maxpd,op1,op2); end
          def maxps(op1,op2); instruction(:maxps,op1,op2); end
          def maxsd(op1,op2); instruction(:maxsd,op1,op2); end
          def maxss(op1,op2); instruction(:maxss,op1,op2); end
          def mfence(); instruction(:mfence,); end
          def minpd(op1,op2); instruction(:minpd,op1,op2); end
          def minps(op1,op2); instruction(:minps,op1,op2); end
          def minsd(op1,op2); instruction(:minsd,op1,op2); end
          def minss(op1,op2); instruction(:minss,op1,op2); end
          def monitor(op1,op2,op3); instruction(:monitor,op1,op2,op3); end
          def mov(op1,op2); instruction(:mov,op1,op2); end
          def movapd(op1,op2=nil); instruction(:movapd,op1,op2); end
          def movaps(op1,op2=nil); instruction(:movaps,op1,op2); end
          def movd(op); instruction(:movd,op); end
          def movddup(op); instruction(:movddup,op); end
          def movdqa(op1,op2=nil); instruction(:movdqa,op1,op2); end
          def movdqu(op); instruction(:movdqu,op); end
          def movdq(op); instruction(:movdq,op); end
          def movhlps(op1,op2); instruction(:movhlps,op1,op2); end
          def movhpd(op1,op2); instruction(:movhpd,op1,op2); end
          def movhps(op1,op2); instruction(:movhps,op1,op2); end
          def movlpd(op1,op2); instruction(:movlpd,op1,op2); end
          def movlps(op1,op2); instruction(:movlps,op1,op2); end
          def movlhps(op1,op2); instruction(:movlhps,op1,op2); end
          def movmskpd(op); instruction(:movmskpd,op); end
          def movmskps(op); instruction(:movmskps,op); end
          def movntdqa(op); instruction(:movntdqa,op); end
          def movntdq(op1,op2); instruction(:movntdq,op1,op2); end
          def movntpd(op1,op2); instruction(:movntpd,op1,op2); end
          def movntps(op1,op2); instruction(:movntps,op1,op2); end
          def movnti(op1,op2); instruction(:movnti,op1,op2); end
          def movntq(op1,op2); instruction(:movntq,op1,op2); end
          def movq(op); instruction(:movq,op); end
          def movq(op); instruction(:movq,op); end
          def movs(op1,op2=nil); instruction(:movs,op1,op2); end
          def movsd(op1,op2=nil); instruction(:movsd,op1,op2); end
          def movsx(op1,op2=nil); instruction(:movsx,op1,op2); end
          def movshdup(op); instruction(:movshdup,op); end
          def movsldup(op); instruction(:movsldup,op); end
          def movss(op1,op2=nil); instruction(:movss,op1,op2); end
          def movupd(op1,op2=nil); instruction(:movupd,op1,op2); end
          def movups(op1,op2=nil); instruction(:movups,op1,op2); end
          def movz(op1,op2); instruction(:movz,op1,op2); end
          def movzx(op1,op2); instruction(:movzx,op1,op2); end
          def mpsadbw(op1,op2,op3); instruction(:mpsadbw,op1,op2,op3); end
          def mul(op1,op2); instruction(:mul,op1,op2); end
          def mulpd(op1,op2); instruction(:mulpd,op1,op2); end
          def mulps(op1,op2); instruction(:mulps,op1,op2); end
          def mulsd(op1,op2); instruction(:mulsd,op1,op2); end
          def mulss(op1,op2); instruction(:mulss,op1,op2); end
          def mwait(op1,op2); instruction(:mwait,op1,op2); end
          def neg(op); instruction(:neg,op); end
          def nop(); instruction(:nop); end
          def out(op1,op2); instruction(:out,op1,op2); end
          def or(op1,op2); instruction(:or,op1,op2); end
          def orpd(op1,op2); instruction(:orpd,op1,op2); end
          def orps(op1,op2); instruction(:orps,op1,op2); end
          def pabsb(op); instruction(:pabsb,op); end
          def pabsd(op); instruction(:pabsd,op); end
          def pabsw(op); instruction(:pabsw,op); end
          def packsswb(op1,op2); instruction(:packsswb,op1,op2); end
          def packssdw(op1,op2); instruction(:packssdw,op1,op2); end
          def packusdw(op1,op2); instruction(:packusdw,op1,op2); end
          def packuswb(op1,op2); instruction(:packuswb,op1,op2); end
          def paddb(op1,op2); instruction(:paddb,op1,op2); end
          def paddw(op1,op2); instruction(:paddw,op1,op2); end
          def paddd(op1,op2); instruction(:paddd,op1,op2); end
          def paddq(op1,op2); instruction(:paddq,op1,op2); end
          def paddsb(op1,op2); instruction(:paddsb,op1,op2); end
          def paddsw(op1,op2); instruction(:paddsw,op1,op2); end
          def paddusb(op1,op2); instruction(:paddusb,op1,op2); end
          def paddusw(op1,op2); instruction(:paddusw,op1,op2); end
          def palignr(op1,op2,op3); instruction(:palignr,op1,op2,op3); end
          def pand(op1,op2); instruction(:pand,op1,op2); end
          def pandn(op1,op2); instruction(:pandn,op1,op2); end
          def pause(); instruction(:pause,); end
          def pavgb(op1,op2); instruction(:pavgb,op1,op2); end
          def pavgw(op1,op2); instruction(:pavgw,op1,op2); end
          def pblendvb(op1,op2,op3); instruction(:pblendvb,op1,op2,op3); end
          def pblendw(op1,op2,op3); instruction(:pblendw,op1,op2,op3); end
          def pclmulqdq(op1,op2,op3); instruction(:pclmulqdq,op1,op2,op3); end
          def pcmpeqb(op1,op2); instruction(:pcmpeqb,op1,op2); end
          def pcmpeqq(op1,op2); instruction(:pcmpeqq,op1,op2); end
          def pcmpeqw(op1,op2); instruction(:pcmpeqw,op1,op2); end
          def pcmpeqd(op1,op2); instruction(:pcmpeqd,op1,op2); end
          def pcmpestri(op1,op2,op3,op4,op5); instruction(:pcmpestri,op1,op2,op3,op4,op5); end
          def pcmpestrm(op1,op2,op3,op4,op5); instruction(:pcmpestrm,op1,op2,op3,op4,op5); end
          def pcmpgtb(op1,op2); instruction(:pcmpgtb,op1,op2); end
          def pcmpgtw(op1,op2); instruction(:pcmpgtw,op1,op2); end
          def pcmpgtw(op1,op2); instruction(:pcmpgtw,op1,op2); end
          def pcmpgtd(op1,op2); instruction(:pcmpgtd,op1,op2); end
          def pcmpistri(op1,op2,op3,op4,op5); instruction(:pcmpistri,op1,op2,op3,op4,op5); end
          def pcmpistrm(op1,op2,op3); instruction(:pcmpistrm,op1,op2,op3); end
          def pcmpgtq(op1,op2); instruction(:pcmpgtq,op1,op2); end
          def pextrb(op1,op2); instruction(:pextrb,op1,op2); end
          def pextrd(op1,op2); instruction(:pextrd,op1,op2); end
          def pextrq(op1,op2); instruction(:pextrq,op1,op2); end
          def pextrw(op1,op2); instruction(:pextrw,op1,op2); end
          def phaddd(op1,op2); instruction(:phaddd,op1,op2); end
          def phaddsw(op1,op2); instruction(:phaddsw,op1,op2); end
          def phaddw(op1,op2); instruction(:phaddw,op1,op2); end
          def phminposuw(op); instruction(:phminposuw,op); end
          def phsubd(op); instruction(:phsubd,op); end
          def phsubsw(op1,op2); instruction(:phsubsw,op1,op2); end
          def phsubw(op1,op2); instruction(:phsubw,op1,op2); end
          def pinsrb(op1,op2,op3); instruction(:pinsrb,op1,op2,op3); end
          def pinsrd(op1,op2,op3); instruction(:pinsrd,op1,op2,op3); end
          def pinsrq(op1,op2,op3); instruction(:pinsrq,op1,op2,op3); end
          def pinsrw(op1,op2,op3); instruction(:pinsrw,op1,op2,op3); end
          def pmaddubsw(op1,op2); instruction(:pmaddubsw,op1,op2); end
          def pmaddwd(op); instruction(:pmaddwd,op); end
          def pmaxsb(op1,op2); instruction(:pmaxsb,op1,op2); end
          def pmaxsd(op1,op2); instruction(:pmaxsd,op1,op2); end
          def pmaxsw(op1,op2); instruction(:pmaxsw,op1,op2); end
          def pmaxub(op1,op2); instruction(:pmaxub,op1,op2); end
          def pmaxud(op1,op2); instruction(:pmaxud,op1,op2); end
          def pmaxuw(op1,op2); instruction(:pmaxuw,op1,op2); end
          def pminsb(op1,op2); instruction(:pminsb,op1,op2); end
          def pminsd(op1,op2); instruction(:pminsd,op1,op2); end
          def pminsw(op1,op2); instruction(:pminsw,op1,op2); end
          def pminub(op1,op2); instruction(:pminub,op1,op2); end
          def pminud(op1,op2); instruction(:pminud,op1,op2); end
          def pminuw(op1,op2); instruction(:pminuw,op1,op2); end
          def pmovmskb(op); instruction(:pmovmskb,op); end
          def pmovsxbw(op); instruction(:pmovsxbw,op); end
          def pmovsxbd(op); instruction(:pmovsxbd,op); end
          def pmovsxbq(op); instruction(:pmovsxbq,op); end
          def pmovsxwd(op); instruction(:pmovsxwd,op); end
          def pmovsxwq(op); instruction(:pmovsxwq,op); end
          def pmovzxbw(op); instruction(:pmovzxbw,op); end
          def pmovzxbd(op); instruction(:pmovzxbd,op); end
          def pmovzxbq(op); instruction(:pmovzxbq,op); end
          def pmovzxwd(op); instruction(:pmovzxwd,op); end
          def pmovzxwq(op); instruction(:pmovzxwq,op); end
          def pmovzxdq(op); instruction(:pmovzxdq,op); end
          def pmuldq(op1,op2); instruction(:pmuldq,op1,op2); end
          def pmulhrsw(op1,op2); instruction(:pmulhrsw,op1,op2); end
          def pmulhuw(op1,op2); instruction(:pmulhuw,op1,op2); end
          def pmulhw(op1,op2); instruction(:pmulhw,op1,op2); end
          def pmullud(op1,op2); instruction(:pmullud,op1,op2); end
          def pmullw(op1,op2); instruction(:pmullw,op1,op2); end
          def pmuludq(op1,op2); instruction(:pmuludq,op1,op2); end
          def popcnt(op); instruction(:popcnt,op); end
          def por(op1,op2); instruction(:por,op1,op2); end
          def prefetchh(op1,op2); instruction(:prefetchh,op1,op2); end
          def psadbw(op1,op2); instruction(:psadbw,op1,op2); end
          def pshufb(op1,op2); instruction(:pshufb,op1,op2); end
          def pshufd(op1,op2); instruction(:pshufd,op1,op2); end
          def pshufhw(op1,op2); instruction(:pshufhw,op1,op2); end
          def pshuflw(op1,op2); instruction(:pshuflw,op1,op2); end
          def pshufw(op1,op2); instruction(:pshufw,op1,op2); end
          def psignb(op1,op2); instruction(:psignb,op1,op2); end
          def psignd(op1,op2); instruction(:psignd,op1,op2); end
          def psignw(op1,op2); instruction(:psignw,op1,op2); end
          def psllw(op1,op2); instruction(:psllw,op1,op2); end
          def pslld(op1,op2); instruction(:pslld,op1,op2); end
          def psllq(op1,op2); instruction(:psllq,op1,op2); end
          def pslldq(op1,op2); instruction(:pslldq,op1,op2); end
          def psraw(op1,op2); instruction(:psraw,op1,op2); end
          def psrad(op1,op2); instruction(:psrad,op1,op2); end
          def psrlw(op1,op2); instruction(:psrlw,op1,op2); end
          def psrld(op1,op2); instruction(:psrld,op1,op2); end
          def psrlq(op1,op2); instruction(:psrlq,op1,op2); end
          def psrldq(op1,op2); instruction(:psrldq,op1,op2); end
          def psubb(op1,op2); instruction(:psubb,op1,op2); end
          def psubw(op1,op2); instruction(:psubw,op1,op2); end
          def psubd(op1,op2); instruction(:psubd,op1,op2); end
          def psubq(op1,op2); instruction(:psubq,op1,op2); end
          def psubsb(op1,op2); instruction(:psubsb,op1,op2); end
          def psubsw(op1,op2); instruction(:psubsw,op1,op2); end
          def psubusb(op1,op2); instruction(:psubusb,op1,op2); end
          def psubusb(op1,op2); instruction(:psubusb,op1,op2); end
          def psubusw(op1,op2); instruction(:psubusw,op1,op2); end
          def ptest(op1,op2); instruction(:ptest,op1,op2); end
          def push(op1); instruction(:push,op1); end
          def pushf(op1); instruction(:pushf,op1); end
          def punpckhbw(op1,op2); instruction(:punpckhbw,op1,op2); end
          def punpckhwd(op1,op2); instruction(:punpckhwd,op1,op2); end
          def punpckhdq(op1,op2); instruction(:punpckhdq,op1,op2); end
          def punpckhqdq(op1,op2); instruction(:punpckhqdq,op1,op2); end
          def punpcklbw(op1,op2); instruction(:punpcklbw,op1,op2); end
          def punpcklwd(op1,op2); instruction(:punpcklwd,op1,op2); end
          def punpckldq(op1,op2); instruction(:punpckldq,op1,op2); end
          def punpcklqdq(op1,op2); instruction(:punpcklqdq,op1,op2); end
          def pxor(op1,op2); instruction(:pxor,op1,op2); end
          def rcpps(op); instruction(:rcpps,op); end
          def rcpss(op); instruction(:rcpss,op); end
          def ret(op); instruction(:ret,op); end
          def ror(op1,op2); instruction(:ror,op1,op2); end
          def rcr(op1,op2); instruction(:rcr,op1,op2); end
          def rcl(op1,op2); instruction(:rcl,op1,op2); end
          def roundpd(op1,op2); instruction(:roundpd,op1,op2); end
          def roundps(op1,op2); instruction(:roundps,op1,op2); end
          def roundsd(op1,op2,op3); instruction(:roundsd,op1,op2,op3); end
          def roundss(op1,op2,op3); instruction(:roundss,op1,op2,op3); end
          def rsqrtps(op); instruction(:rsqrtps,op); end
          def rsqrtss(op); instruction(:rsqrtss,op); end
          def sbb(op1,op2); instruction(:sbb,op1,op2); end
          def sfence(); instruction(:sfence); end
          def sar(op1,op2); instruction(:sar,op1,op2); end
          def sal(op1,op2); instruction(:sal,op1,op2); end
          def scr(op1,op2); instruction(:scr,op1,op2); end
          def sahf(op1,op2); instruction(:sahf,op1,op2); end
          def scl(op1,op2); instruction(:scl,op1,op2); end
          def shr(op1,op2); instruction(:shr,op1,op2); end
          def shl(op1,op2); instruction(:shl,op1,op2); end
          def shufpd(op1,op2,op3); instruction(:shufpd,op1,op2,op3); end
          def shufps(op1,op2,op3); instruction(:shufps,op1,op2,op3); end
          def sqrtpd(op); instruction(:sqrtpd,op); end
          def sqrtps(op); instruction(:sqrtps,op); end
          def sqrtsd(op); instruction(:sqrtsd,op); end
          def sqrtss(op); instruction(:sqrtss,op); end
          def stc(); instruction(:stc); end
          def std(); instruction(:std); end
          def sti(); instruction(:sti); end
          def stmxcsr(); instruction(:stmxcsr); end
          def sub(op1,op2); instruction(:sub,op1,op2); end
          def subpd(op1,op2); instruction(:subpd,op1,op2); end
          def subps(op1,op2); instruction(:subps,op1,op2); end
          def subsd(op1,op2); instruction(:subsd,op1,op2); end
          def subss(op1,op2); instruction(:subss,op1,op2); end
          def sysenter(); instruction(:sysenter); end
          def sysexit(); instruction(:sysexit); end
          def test(op1,op2); instruction(:test,op1,op2); end
          def ucomisd(op1,op2); instruction(:ucomisd,op1,op2); end
          def ucomiss(op1,op2); instruction(:ucomiss,op1,op2); end
          def unpckhpd(op1,op2); instruction(:unpckhpd,op1,op2); end
          def unpckhps(op1,op2); instruction(:unpckhps,op1,op2); end
          def unpcklpd(op1,op2); instruction(:unpcklpd,op1,op2); end
          def unpcklps(op1,op2); instruction(:unpcklps,op1,op2); end
          def wait(); instruction(:wait); end
          def xchg(op1,op2); instruction(:xchg,op1,op2); end
          def xor(op1,op2); instruction(:xor,op1,op2); end
          def xorpd(op1,op2); instruction(:xorpd,op1,op2); end
          def xorps(op1,op2); instruction(:xorps,op1,op2); end
        end
      end
    end
  end
end
