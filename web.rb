require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/cars.rb')

queries = %w(/brand/:brand /model/:model /make/:make /power_kw/:power_kw)
paths = []
(1..queries.size).each { |i| paths << queries.combination(i).map {|item| item.join} } #TODO permutation for each item
paths.flatten!

paths.each do |path|
  get(path) { car_count(params).to_s }
end