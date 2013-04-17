require 'rubygems'
require 'sinatra'
require 'json'

require File.expand_path(File.dirname(__FILE__) + '/cars.rb')

get('/car_count/*') do
  validate_params_and_execute(Proc.new { |criteria| car_count(criteria).to_s })
end

get('/cars/*') do
  content_type :json
  {:cars => validate_params_and_execute(Proc.new { |criteria| query(criteria).map { |car| car.to_hash } })}.to_json
end

private
def validate_params_and_execute(callback)
  criteria = to_params(params[:splat].to_s)
  return 404 unless valid?(criteria)
  callback.call(criteria)
end

def to_params(criteria)
  pairs = criteria.split('/')
  pairs.pop if pairs.size.odd?
  Hash[*pairs]
end