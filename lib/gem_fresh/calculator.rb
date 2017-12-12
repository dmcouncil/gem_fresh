# require 'gem_fresh/outdated/components'
require 'gem_fresh/outdated/gems'
# require 'gem_fresh/outdated/modules'

module GemFresh
  class Calculator

    # If a gem is behind by a major version, it's worth more points
    # than a minor version.
    POINTS_FOR_MAJOR = 100
    POINTS_FOR_MINOR = 10
    POINTS_FOR_PATCH = 1

    # Point multipliers based on how central the gem is to the application code.
    MINIMAL_MULTIPLIER = 0.1
    LOCAL_MULTIPLIER  = 1
    SYSTEM_MULTIPLIER = 10
    FRAMEWORK_MULTIPLIER = 100

    def initialize
      @freshness_scores = {}
    end

    def calculate!
      @gem_freshness_info = GemFresh::Outdated::Gems.new.figure_out_outdated_gems
      calculate_freshness_scores_for_each_gem
    end

    def total_score
      @freshness_scores.values.sum.round(1)
    end

    def all_scores
      @freshness_scores
    end

  private

    def calculate_freshness_scores_for_each_gem
      calculate_for_gems(['rails'], FRAMEWORK_MULTIPLIER)
      calculate_for_gems(Config.config.system_wide_gems, SYSTEM_MULTIPLIER)
      calculate_for_gems(Config.config.local_gems, LOCAL_MULTIPLIER)
      calculate_for_gems(Config.config.minimal_gems, MINIMAL_MULTIPLIER)
    end

    def calculate_for_gems(gems, multiplier)
      gems.each do |gem_name|
        @freshness_scores[gem_name] =
         (calculate_freshness_score_for(gem_name) * multiplier).round(1)
      end
    end

    def calculate_freshness_score_for(gem_name)
      info = @gem_freshness_info[gem_name]
      return 0 if info.nil?  # no outdated info means it's fresh
      major_diff = (info[:available_version].major - info[:current_version].major)
      minor_diff = (info[:available_version].minor - info[:current_version].minor)
      patch_diff = (info[:available_version].patch - info[:current_version].patch)
      score = 0
      if major_diff > 0
        score += major_diff * POINTS_FOR_MAJOR
      elsif minor_diff > 0
        score += minor_diff * POINTS_FOR_MINOR
      elsif patch_diff > 0
        score += patch_diff * POINTS_FOR_PATCH
      end
      score
    end

  end
end
