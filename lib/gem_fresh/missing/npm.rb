module GemFresh::Missing
  class Npm < Base
    def package_type
      'node modules'
    end

    def manifest_file
      'package.json'
    end

    # TODO: we shouldn't be so tied to Rails in future
    # Reducing that dependency would mean finding the Gemfile another way
    def parse_manifest
      package_file = File.join(Rails.root, manifest_file)
      @gem_lines = IO.readlines(package_file).select{|line| line =~ /\A\s*gem/ }
    end

    private

    def get_libs_from_gemfresh
      @gemfresh.all_gems
    end

    def lib_names
      @gem_lines.map do |gem_line|
        gem_line.split.second.gsub(/[^A-Za-z0-9\-_]/, '')
      end
    end
  end
end
