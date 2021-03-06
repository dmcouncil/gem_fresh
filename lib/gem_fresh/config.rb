module GemFresh
  class Config

    attr_reader :system_wide_gems, :local_gems, :minimal_gems, :private_gems

    def self.configure(&block)
      @@config ||= Config.new
      block.call(@@config)
    end

    def self.config
      @@config ||= begin
        config = Config.new
        config.with_system_wide_impact([])
        config.with_local_impact([])
        config.with_minimal_impact([])
        config.that_are_private([])
        config
      end
    end

    def with_system_wide_impact(gems)
      @system_wide_gems = clean_gems(gems)
    end

    def with_local_impact(gems)
      @local_gems = clean_gems(gems)
    end

    def with_minimal_impact(gems)
      @minimal_gems = clean_gems(gems)
    end

    def that_are_private(gems)
      @private_gems = clean_gems(gems)
    end

    def all_gems
      @system_wide_gems + @local_gems + @minimal_gems + @private_gems
    end

  private

    def clean_gems(gems)
      if gems.include?('rails')
        raise "Do not explicitly specify the rails gem in gem_fresh.rb." #TODO: why not?
      end
      gems
    end

  end
end
