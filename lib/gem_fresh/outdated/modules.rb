module GemFresh
  class Outdated::Modules
    # This is npm-specific methods for getting outdated data

    def self.figure_out_outdated_modules(module_info={})
      raw_info_from_npm.each do |line|
        # name current wanted latest location
        line =~ /^(\S+)\s+([\d\.]+.*)/
        module_name = $1
        version_data = $2
        module_info[module_name] = extract_npm_data(version_data)
      end
      module_info
    end

    private

    def extract_npm_data(version_data)
      return false if version_data.nil? || version_data.strip.blank?
      versions = version_data.split.map(&:strip) # ['2.12.2', '2.12.2', '2.16.3', 'quokka']
      return { available_version: GemVersion.new(versions[2]),
                current_version: GemVersion.new(versions[0]) }
    end

    def raw_info_from_npm
      # First a name, then a number - otherwise it's a header line
      %x{ npm outdated }.split("\n").map(&:strip).select { |line| line =~ /^\S+\s+\d+/ }
    end
  end
end
