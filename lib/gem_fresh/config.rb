module GemFresh
  class Config

    # App-specific configuration files will use these methods
    # to define the lists we're checking

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

    def with_system_wide_impact(gems, type)
      case type
      when :gem 
        @system_wide_gems = clean_gems(gems)
      when :npm
        @system_wide_modules = gems
      when :bower
        @system_wide_components = gems
      end
    end

    def with_local_impact(gems, type=:gem)
      case type
      when :gem
        @local_gems = clean_gems(gems)
      when :npm
        @local_modules = gems
      when :bower
        @local_components = gems
      end
    end

    def with_minimal_impact(gems, type=:gem)
      case type
      when :gem
        @minimal_gems = clean_gems(gems)
      when :npm
        @minimal_modules = gems
      when :bower
        @minimal_components = gems
      end
    end

    def that_are_private(gems, type=:gem)
      case type
      when :gem
        @private_gems = clean_gems(gems)
      when :npm
        @private_modules = gems
      when :bower
        @private_components = gems
      end
    end

    def all_gems
      @system_wide_gems + @local_gems + @minimal_gems + @private_gems
    end

    def all_modules
      @system_wide_modules + @local_modules + @minimal_modules + @private_modules
    end

    def all_components
      @system_wide_components + @local_components + @local_modules + @private_components
    end

    def all_dependencies
      all_gems + all_modules + all_components
    end

  private

    def clean_gems(gems)
      if gems.include?('rails')
        raise "Do not explicitly specify the rails gem in gem_fresh.rb. It is handled separately by the calculator."
      end
      gems
    end

  end
end
