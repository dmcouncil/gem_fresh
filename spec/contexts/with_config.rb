shared_context "with config" do
  let(:config) { GemFresh::Config.class_variable_get(:@@config) }
  before do
    GemFresh::Config.configure do |gems|
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


end
