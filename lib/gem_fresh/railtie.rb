require 'gem_fresh'
require 'rails'

module GemFresh
  class Railtie < Rails::Railtie
    railtie_name :gem_fresh

    rake_tasks do
      namespace :gem_fresh do
        desc "Report on all outdated libraries"
        task :outdated => ['gems']
        # TODO: When subtasks are specific, run them all
        # plus a summary score

        desc "Report on outdated gems"
        task :gems => :environment do
          # TODO: Pass argument to Reporter init describing reports to run
          GemFresh::Reporter.new.report
        end

        desc "Report on outdated npm modules"
        task :modules => :environment do
          # TODO: Pass argument to Reporter init describing reports to run
          GemFresh::Reporter.new.report
        end

        desc "Report on outdated bower components"
        task :components => :environment do
          # TODO: Pass argument to Reporter init describing reports to run
          GemFresh::Reporter.new.report
        end
      end

      task :gem_fresh => ['gem_fresh:outdated']
    end
  end
end
