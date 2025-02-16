require 'spec_helper'
require 'ronin/asm/os'

describe Ronin::ASM::OS do
  describe "SYSCALLS" do
    subject { described_class::SYSCALLS }

    let(:data_dir) { Ronin::ASM::Config::DATA_DIR }

    it { expect(subject).to be_kind_of(Hash) }

    it "must load syscalls for :freebsd and :amd64" do
      expect(subject[:freebsd][:amd64]).to eq(
        YAML.load_file(
          File.join(data_dir,'os','freebsd','amd64','syscalls.yml')
        )
      )
    end

    it "must load syscalls for :freebsd and :x86" do
      expect(subject[:freebsd][:amd64]).to eq(
        YAML.load_file(
          File.join(data_dir,'os','freebsd','x86','syscalls.yml')
        )
      )
    end

    it "must load syscalls for :linux and :amd64" do
      expect(subject[:linux][:amd64]).to eq(
        YAML.load_file(
          File.join(data_dir,'os','linux','amd64','syscalls.yml')
        )
      )
    end

    it "must load syscalls for :linux and :x86" do
      expect(subject[:linux][:x86]).to eq(
        YAML.load_file(
          File.join(data_dir,'os','linux','x86','syscalls.yml')
        )
      )
    end
  end

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
