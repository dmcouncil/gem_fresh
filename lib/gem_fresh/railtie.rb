require 'gem_fresh'
require 'rails'

module GemFresh
  class Railtie < Rails::Railtie
    railtie_name :gem_fresh

    rake_tasks do
      namespace :gem_fresh do
        desc "outdated"
        task :outdated => :environment do
          GemFresh::Reporter.new.report
        end
      end

      task :gem_fresh => ['gem_fresh:outdated']
    end
  end
end
