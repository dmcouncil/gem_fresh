$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gem_fresh'
Dir["./spec/contexts/*.rb"].each {|f| require f }
