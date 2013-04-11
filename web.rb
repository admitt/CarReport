require 'rubygems'
require 'sinatra'

require File.expand_path(File.dirname(__FILE__) + '/cars.rb')

get('/car_count/*') do
  criteria = to_params(params[:splat].to_s)
  return 404 unless valid?(criteria)
  car_count(criteria).to_s
end

private

  def to_params(criteria)
    pairs = criteria.split('/')
    pairs.pop if pairs.size.odd?
    Hash[*pairs]
  end