require 'gem_fresh'
require 'rails'

module GemFresh
  class Railtie < Rails::Railtie
    railtie_name :gem_fresh

    puts "Woohoo, a GemFresh Railtie"
    puts "env? #{Rails.env}"
    puts GemFresh::Config.config

    rake_tasks do
      namespace :gem_fresh do
        desc "outdated"
        task :outdated => :environment do
          GemFresh::Reporter.new.report
        end
      end
    end
  end
end
