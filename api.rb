require 'rubygems'
require 'bundler'
require 'json'
Bundler.require

require_relative 'ad_action'
require_relative 'ad_statistic'
require_relative 'statistics'

set :logging, true
set :debug, true

configure do
  enable :logging, :dump_errors, :raise_errors
  DataMapper.setup(:default, 'postgres://test:test@localhost:5432/api_test')
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.auto_upgrade!
  DataMapper.finalize
end

get '/api/stats' do
  statistics = Statistics.calculate(ad_ids: params[:ad_ids], start_time: params[:start_time], end_time: params[:end_time])
  statistics.to_json
end