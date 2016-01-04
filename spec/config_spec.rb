require 'spec_helper'

describe Gemfresh::Config do
  let(:config) { Gemfresh::Config.class_variable_get(:@@config) }
  before do
    Gemfresh::Config.configure do |gems|
      gems.with_system_wide_impact %w(
        resque
        rspec
      )
      gems.with_local_impact %w(
        fog
        tabulous
      )
      gems.with_minimal_impact %w(
        airbrake
        bullet
      )
      gems.that_are_private %w(
        dmc_server_admin
      )
    end
  end

  describe ".configure" do
    it "initializes @@config" do
      expect(config).to be_an_instance_of(Gemfresh::Config)
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
      expect(Gemfresh::Config.config).to eq(config)
    end
  end
end
