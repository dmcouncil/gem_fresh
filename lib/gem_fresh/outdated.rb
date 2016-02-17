module GemFresh
  class Outdated

    attr_reader :gem_info

    def initialize
      figure_out_outdated_gems
    end

    private

    def figure_out_outdated_gems
      @gem_info ={}
      raw_gem_info_from_bundler.each do |line|
        line =~ /\A\s*\*\s+(\S+)\s+\((.+)\).*\Z/
        gem_name = $1
        version_data = $2
        @gem_info[gem_name] = extract_versions(version_data)
      end
    end

    def extract_versions(data_string)
      # It looks like Bundler changed the format of the data
      # returned by `bundle outdated` in version 1.10.
      # Potential future refactor: decide which extraction
      # method to use by actually asking Bundler which version
      # it is and using the appropriate method for that version.
      # Also: Bundler 1.12 will support `bundle outdated --parseable`
      # which looks custom-made for this use case.
      if data_string.include?("newest")
        #
        # Sample lines from `bundle outdated` look like this:
        #
        # * rspec-rails (newest 3.4.0, installed 3.2.3, requested ~> 3.2.3) in groups "development, test"
        # * zeus (newest 0.15.4, installed 0.13.3) in group "test"
        # * websocket-driver (newest 0.6.3, installed 0.5.4)
        #
        versions = data_string.split(', ').map(&:strip).map(&:split) # [["newest", "4.2.5"], ["installed", "3.2.22"], ["requested", "=", "3.2.22"]]
        version_hash = {}
        versions.each { |v| version_hash[v.first.to_sym] = v.last unless v.size > 2 }
        return { available_version: GemVersion.new(version_hash[:newest]),
                  current_version: GemVersion.new(version_hash[:installed]) }
      else
        #
        # Sample lines from `bundle outdated` look like this:
        #
        #   * airbrake (4.1.0 > 3.1.3)
        #   * annotate (2.6.5 > 2.6.0.beta2) Gemfile specifies "= 2.6.0.beta2"
        #   * bootstrap-multiselect-rails (0.9.5 > 0.0.4)
        #   * byebug (3.5.1 > 2.5.0)
        #   * enum_field (0.2.0 bff7873 > 0.2.0)
        #
        versions = data_string.split(" > ").map(&:strip)  # ["0.2.0 bff7873", "0.2.0"]
        versions = versions.map{|v| v.split(/\s/).first} # ["0.2.0", "0.2.0"]
        return { available_version: GemVersion.new(versions.first),
                  current_version: GemVersion.new(versions.last) }
      end
    end

    def raw_gem_info_from_bundler
      output = %x{ bundle outdated }
      just_the_gem_lines = output.split("\n").map(&:strip).select do |line|
        line =~ /\A\s*\*\s+\w/
      end
      just_the_gem_lines
    end

  end
end
