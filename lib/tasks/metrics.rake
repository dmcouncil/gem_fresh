namespace :gem_fresh do
  task :outdated do
    GemFresh::Reporter.new.report
  end
end
