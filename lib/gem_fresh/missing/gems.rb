module GemFresh::Missing
  class Gems < Base

  private

    def missing
      libs_from_gemfresh = @gemfresh.all_gems
      super
    end

    def lib_names
      @gem_lines.map do |gem_line|
        gem_line.split.second.gsub(/[^A-Za-z0-9\-_]/, '')
      end
    end

    # TODO: we shouldn't be so tied to Rails in future
    def parse_manifest
      gemfile = File.join(Rails.root, 'Gemfile')
      @gem_lines = IO.readlines(gemfile).select{|line| line =~ /\A\s*gem/ }
    end


  end
end