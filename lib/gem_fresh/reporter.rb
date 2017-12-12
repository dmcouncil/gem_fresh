module GemFresh
  class Reporter

    def initialize
      MissingChecker.new.check_for_missing_dependencies!
      @calculator = Calculator.new
      @calculator.calculate!
    end

    def report
      puts
      puts "A bounty is calculated for each gem based on how outdated the gem"
      puts "is and the impact the gem has on the application code.  Foundational"
      puts "gems like RSpec get a higher bounty, simple add-on tools like bullet"
      puts "get a lower bounty.  See Gemfresh.rb for details."
      puts
      puts "The total bounty is #{@calculator.total_score} points."
      puts
      puts "These are the outdated gems, sorted by highest bounty:"
      puts
      sorted_scores = @calculator.all_scores.sort_by{|gem_name, score| [-score, gem_name]}
      sorted_scores.each do |gem_name, score|
        name = "  #{gem_name.ljust(25)[0..24]} "
        if score >= 1000
          puts "#{name} #{score}"
        elsif score > 0
          puts "#{name} #{score}"
        else
          puts "#{name} up to date"
        end
      end
      puts
    end

  end
end
