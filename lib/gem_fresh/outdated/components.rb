module GemFresh
  module Outdated::Components
    # This is npm-specific methods for getting outdated data

    private

    def figure_out_outdated_components
      @gem_info ={}
      raw_gem_info_from_npm.each do |line|
        line =~ /\A\s*\*\s+(\S+)\s+\((.+)\).*\Z/
        gem_name = $1
        version_data = $2
        @gem_info[gem_name] = extract_npm_data(version_data)
      end
    end

    def extract_npm_data(version_data)
      return false if version_data.nil? || version_data.strip.blank?
      versions = version_data.split(', ').map(&:strip).map(&:split) # [["newest", "4.2.5"], ["installed", "3.2.22"], ["requested", "=", "3.2.22"]]
      version_hash = {}
      versions.each { |v| version_hash[v.first.to_sym] = v.last unless v.size > 2 }
      return { available_version: GemVersion.new(version_hash[:newest]),
                current_version: GemVersion.new(version_hash[:installed]) }
    end

    def raw_gem_info_from_npm
      # return %x{ bundle outdated --porcelain }.split("\n").map(&:strip)
      just_the_gem_lines = %x{ bundle outdated }.split("\n").map(&:strip).select do |line|
        line =~ /\A\s*\*\s+\w/
      end
      just_the_gem_lines
    end
  end
end