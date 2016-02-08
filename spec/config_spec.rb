require 'spec_helper'

describe GemFresh::Config do
  context "when there is a config file" do
    include_context "with config"
    describe ".configure" do
      it "initializes @@config" do
        expect(config).to be_an_instance_of(GemFresh::Config)
      end

      it "sets @system_wide_gems" do
        expect(config.system_wide_gems).to contain_exactly("resque", "rspec")
      end

      it "sets @local_gems" do
        expect(config.local_gems).to contain_exactly("fog", "tabulous")
      end

      it "sets @minimal_gems" do
        expect(config.minimal_gems).to contain_exactly("airbrake", "bullet")
      end

      it "sets @private_gems" do
        expect(config.private_gems).to contain_exactly("dmc_server_admin")
      end
    end

    describe ".config" do
      it "returns @@config" do
        expect(GemFresh::Config.config).to eq(config)
      end
    end
  end

  context "without a config file" do
    before(:all) { @@config = nil }
    it { expect(GemFresh::Config.config).to be_an_instance_of(GemFresh::Config) }
    it { expect(GemFresh::Config.config.system_wide_gems).to eq([]) }
    it { expect(GemFresh::Config.config.local_gems).to eq([]) }
    it { expect(GemFresh::Config.config.minimal_gems).to eq([]) }
    it { expect(GemFresh::Config.config.private_gems).to eq([]) }
    it { expect(GemFresh::Config.config.all_gems).to eq([]) }
  end
end
