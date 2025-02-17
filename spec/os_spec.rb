require 'spec_helper'
require 'ronin/asm/os'

describe Ronin::ASM::OS do
  describe ".[]" do
    context "when given :linux" do
      it "must return #{described_class}::Linux" do
        expect(subject[:linux]).to be(described_class::Linux)
      end
    end

    context "when given :freebsd" do
      it "must return #{described_class}::FreeBSD" do
        expect(subject[:freebsd]).to be(described_class::FreeBSD)
      end
    end

    context "when given an unknown Symbol" do
      let(:name) { :foo }

      it do
        expect {
          subject[name]
        }.to raise_error(ArgumentError,"unknown OS name: #{name.inspect}")
      end
    end
  end
end
