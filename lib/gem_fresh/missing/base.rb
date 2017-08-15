module GemFresh::Missing
  class Base

    def initialize(gemfresh)
      @gemfresh = gemfresh
      parse_manifest
    end

    def check_for_missing!
      if missing.any?
        message = "The following #{package_type} are in your #{manifest_file} but not in your gem_fresh.rb file:\n"
        missing.each do |lib_name|
          message << "  #{lib_name}\n"
        end
        raise message
      end
    end

  private

    def missing
      raise 'Define libs_from_gemfresh in subclass' unless libs_from_gemfresh.defined?
      missing_libs = []
      lib_names.each do |lib_from_manifest|
        unless libs_from_gemfresh.include?(lib_from_manifest)
          missing_libs << lib_from_manifest
        end
      end
      missing_libs.reject!{|g| g == 'rails'}
      missing_libs
    end

    def lib_names
      raise UndefinedMethod '#lib_names should be defined in subclass'
    end

    def parse_manifest
      raise UndefinedMethod '#parse_manifest should be defined in subclass'
    end
  end
end
