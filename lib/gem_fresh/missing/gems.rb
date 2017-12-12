module GemFresh::Missing
  class Gems < Base
    def package_type
      'gems'
    end

    def manifest_file
      'Gemfile'
    end

    # TODO: we shouldn't be so tied to Rails in future
    # Reducing that dependency would mean finding the Gemfile another way
    def parse_manifest
      gemfile = File.join(Rails.root, 'Gemfile')
      @gem_lines = IO.readlines(gemfile).select{|line| line =~ /\A\s*gem/ }
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
