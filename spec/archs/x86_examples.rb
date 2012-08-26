require 'spec_helper'

shared_examples_for "Archs::X86" do
  its(:general_registers) { should include(:eax, :ebx, :ecx, :edx, :esi, :edi) }

  describe "registers" do
    subject { program.registers.keys }

    it do
      should include(
        :al,
        :ah,
        :ax,
        :eax,

        :bl,
        :bh,
        :bx,
        :ebx,

        :cl,
        :ch,
        :cx,
        :ecx,

        :dl,
        :dh,
        :dx,
        :edx,

        :sil,
        :si,
        :esi,

        :dil,
        :di,
        :edi,

        :bpl,
        :bp,
        :ebp,

        :spl,
        :sp,
        :esp,

        :cs,
        :ds,
        :es,
        :fs,
        :gs,
        :ss,

        :eip
      )
    end
  end
end
