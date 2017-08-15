require 'gem_fresh/missing/base'
require 'gem_fresh/missing/gems'

module GemFresh
  class MissingChecker

    def initialize
      @gem_missing = GemFresh::Missing::Gems.new(gemfresh)
      # @bower_missing = GemFresh::Missing::Modules.new(gemfresh)
      # @package_missing = GemFresh::Missing::Components.new(gemfresh)
      parse_manifests
    end

    def check_for_missing_dependencies!
      @gem_missing.check_for_missing! if gemfresh.using_gems?
      # @bower_missing.check_for_missing! if gemfresh.using_npm?
      # @package_missing.check_for_missing! if gemfresh.using_bower?
    end

  private

    def parse_manifests
      @gem_missing.parse_manifest if gemfresh.using_gems?
      # @bower_missing.parse_manifest if gemfresh.using_bower?
      # @package_missing.parse_manifest if gemfresh.using_npm?
    end

    def gemfresh
      GemFresh::Config.config
    end
  end
end
