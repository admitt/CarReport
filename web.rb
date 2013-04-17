require 'rubygems'
require 'sinatra'
require 'json'

require File.expand_path(File.dirname(__FILE__) + '/cars.rb')

get('/car_count/*') do
  validate_params_and_execute(Proc.new { |criteria| car_count(criteria).to_s })
end

get('/cars/*') do
  content_type :json
  validate_params_and_execute(Proc.new { |criteria| {:cars => query(criteria).map { |car| car.to_hash } }.to_json})
end

get('/car_counts/by_property/:property') do
  content_type :json
  property = params[:property]
  return 404 unless valid_property?(property)
  counts_by(property).to_json
end

private
def validate_params_and_execute(callback)
  criteria = to_criteria(params[:splat].to_s)
  return 404 unless valid?(criteria)
  callback.call(criteria)
end

def to_criteria(splat)
  pairs = splat.split('/')
  pairs.pop if pairs.size.odd?
  Hash[*pairs]
end