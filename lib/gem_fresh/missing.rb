module GemFresh
  class Missing

    def initialize
      parse_gemfile
      parse_package_json
    end

    def check_for_missing_dependencies!
      check_for_missing_gems!
      check_for_missing_node!
      check_for_missing_bower!
    end

    def check_for_missing_gems!
      if missing_gems.any?
        message = "The following gems are in your Gemfile but not in your gem_fresh.rb file:\n"
        missing_gems.each do |gem_name|
          message << "  #{gem_name}\n"
        end
        raise message
      end
    end

    def check_for_missing_node!
      if missing_node.any?
        message = "The following npm modules are in your package.json but not in your dep_fresh.rb file:\n"
      end
      missing_node.each do |module_name|
        message << " #{module_name}\n"
      end
      raise message
    end

    def check_for_missing_bower!
      if missing_bower.any?
        message = "The following bower components are in your bower.json but not in your dep_fresh.rb file:\n"
      end
      missing_bower.each do |component_name|
        message << " #{component_name}\n"
      end
      raise message
    end

  private

    def missing_gems
      missing_gems = []
      gems_from_gemfresh = gemfresh.all_gems
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

    #TODO: we shouldn't be so tied to Rails in future
    def parse_gemfile
      gemfile = File.join(Rails.root, 'Gemfile')
      @gem_lines = IO.readlines(gemfile).select{|line| line =~ /\A\s*gem/ }
    end

    def gemfresh
      GemFresh::Config.config
    end
  end
end
