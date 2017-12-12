module GemFresh
  class Outdated::Components
    # This is bower-specific methods for getting outdated data

    def self.figure_out_outdated_components(component_info={})
      raw_info_from_bower.each do |dependency|
        component_name = dependency[0]
        current_version = dependency[1]['pkgMeta']['version']
        latest_version = dependency[1]['update']['latest']
        component_info[component_name] = { available_version: GemVersion.new(latest_version),
                                           current_version: GemVersion.new(current_version)}
      end
      component_info
    end

    private

    def raw_info_from_bower
      # The -j option makes bower return JSON data
      bower_hash = JSON.parse(%x{ bower list -j })
      bower_hash['dependencies']
    end
  end
end
