module GemFresh
  module Outdated
    class Gems
    # This is gem-specific methods for getting outdated data

      def initialize
        @bundler_version = GemVersion.new(::Bundler::VERSION)
      end

      def figure_out_outdated_gems(gem_info={})
        raw_gem_info_from_bundler.each do |line|
          if @bundler_version.major <= 1 && @bundler_version.minor < 12
            line =~ /\A\s*\*\s+(\S+)\s+\((.+)\).*\Z/
            gem_name = $1
            version_data = $2
            if @bundler_version.minor < 10
              gem_info[gem_name] = extract_older_bundler_data(version_data)
            else
              gem_info[gem_name] = extract_newer_bundler_data(version_data)
            end
          else
            # Output from the --porcelain flag is simpler
            line =~ /\A(\S+)\s+\((.+)\).*\Z/
            gem_name = $1
            version_data = $2
            gem_info[gem_name] = extract_newer_bundler_data(version_data)
          end
        end
        gem_info
      end

      private

      def extract_newer_bundler_data(version_data)
        #
        # Sample lines from `bundle outdated` look like this (without the leading * in some versions):
        #
        # * rspec-rails (newest 3.4.0, installed 3.2.3, requested ~> 3.2.3) in groups "development, test"
        # * zeus (newest 0.15.4, installed 0.13.3) in group "test"
        # * websocket-driver (newest 0.6.3, installed 0.5.4)
        #
        return false if version_data.nil? || version_data.strip.blank?
        versions = version_data.split(', ').map(&:strip).map(&:split) # [["newest", "4.2.5"], ["installed", "3.2.22"], ["requested", "=", "3.2.22"]]
        version_hash = {}
        versions.each { |v| version_hash[v.first.to_sym] = v.last unless v.size > 2 }
        return { available_version: GemVersion.new(version_hash[:newest]),
                  current_version: GemVersion.new(version_hash[:installed]) }
      end

      def extract_older_bundler_data(version_data)
        #
        # Sample lines from `bundle outdated` look like this:
        #
        #   * airbrake (4.1.0 > 3.1.3)
        #   * annotate (2.6.5 > 2.6.0.beta2) Gemfile specifies "= 2.6.0.beta2"
        #   * bootstrap-multiselect-rails (0.9.5 > 0.0.4)
        #   * byebug (3.5.1 > 2.5.0)
        #   * enum_field (0.2.0 bff7873 > 0.2.0)
        #
        versions = version_data.split(" > ").map(&:strip)  # ["0.2.0 bff7873", "0.2.0"]
        versions = versions.map{|v| v.split(/\s/).first} # ["0.2.0", "0.2.0"]
        return { available_version: GemVersion.new(versions.first),
                  current_version: GemVersion.new(versions.last) }
      end

      def raw_gem_info_from_bundler
        if @bundler_version.major > 1 || (@bundler_version.major == 1 && @bundler_version.minor >= 12)
          # All lines are useful when using the --porcelain flag
          return %x{ bundle outdated --porcelain }.split("\n").map(&:strip)
        end
        just_the_gem_lines = %x{ bundle outdated }.split("\n").map(&:strip).select do |line|
          line =~ /\A\s*\*\s+\w/
        end
        just_the_gem_lines
      end
    end
  end
end
