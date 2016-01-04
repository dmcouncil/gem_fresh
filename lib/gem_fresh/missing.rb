module GemFresh
  class Missing

    def initialize
      parse_gemfile
    end

    def check_for_missing_gems!
      if missing_gems.any?
        message = "The following gems are in your Gemfile but not in your GemFresh.rb file:\n"
        missing_gems.each do |gem_name|
          message << "  #{gem_name}\n"
        end
        raise message
      end
    end

  private

    def missing_gems
      missing_gems = []
      gems_from_gemfresh = GemFresh::Config.config.all_gems
      gem_names.each do |gem_from_gemfile|
        if not gems_from_gemfresh.include?(gem_from_gemfile)
          missing_gems << gem_from_gemfile
        end
      end
      missing_gems.reject!{|g| g == 'rails'}
      missing_gems
    end

    def gem_names
      @gem_lines.map do |gem_line|
        gem_line.split.second.gsub(/[^A-Za-z0-9\-_]/, '')
      end
    end

    def parse_gemfile
      gemfile = File.join(Rails.root, 'Gemfile')
      @gem_lines = IO.readlines(gemfile).select{|line| line =~ /\A\s*gem/ }
    end

  end
end
