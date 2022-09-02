require 'spec_helper'
require 'ronin/code/asm/os'

describe Ronin::Code::ASM::OS do
  describe "SYSCALLS" do
    subject { described_class::SYSCALLS }

    let(:data_dir) { Ronin::Code::ASM::Config::DATA_DIR }

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
end
