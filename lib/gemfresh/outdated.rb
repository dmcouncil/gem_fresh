module Gemfresh
  class Outdated

    attr_reader :gem_info

    def initialize
      figure_out_outdated_gems
    end

  private

    def figure_out_outdated_gems
      @gem_info ={}
      raw_gem_info_from_bundler.each do |line|
        #
        # Sample lines from `bundle outdated` look like this:
        #
        #   * airbrake (4.1.0 > 3.1.3)
        #   * annotate (2.6.5 > 2.6.0.beta2) Gemfile specifies "= 2.6.0.beta2"
        #   * bootstrap-multiselect-rails (0.9.5 > 0.0.4)
        #   * byebug (3.5.1 > 2.5.0)
        #   * enum_field (0.2.0 bff7873 > 0.2.0)
        # or this:
        #   * responders (newest 2.1.0, installed 1.1.2) in group "default"
        #   * resque-retry (newest 1.4.0, installed 1.3.2) in group "default"
        #   * resque-status (newest 0.5.0, installed 0.4.1, requested = 0.4.1) in group "default"
        #   * rspec (newest 3.3.0, installed 3.2.0, requested ~> 3.2.0) in groups "development, test"
        #
        words = line.split
        words_that_contain_version_numbers = words.select {|word| word =~ /\d+\.\d+/ }
        version_numbers = words_that_contain_version_numbers.map {|word| word.gsub(/[\(\),]/, '') }
        line =~ /\A\s*\*\s+(\S+)/
        gem_name = $1
        @gem_info[gem_name] = { available_version: GemVersion.new(version_numbers[0]),
                                current_version: GemVersion.new(version_numbers[1]) }
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
