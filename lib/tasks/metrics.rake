namespace :metrics do
  desc "display outdated gem version metrics"
  task :outdated_gems => :environment do
    GemFresh::Reporter.new.report
  end
end
