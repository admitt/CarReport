require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/cars.rb')

get('/car_count/*') do
  validate_params_and_execute(Proc.new {|criteria| car_count(criteria).to_s})
end

get('/cars/*') do
  validate_params_and_execute(Proc.new {|criteria| query(criteria).map {|car| car.values.join(' ')}.join("\n")})
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