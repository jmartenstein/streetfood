#!/usr/bin/ruby

require 'sinatra'
require 'haml'

require './model/stop.rb'
require './model/truck.rb'
require './model/location.rb'

set :views, File.dirname(__FILE__) + '/../static'
set :public, File.dirname(__FILE__) + '/../static'

get '/' do
   haml :this_week
end

get '/truck/:truck_name' do | name |
	@name = name
	haml :truck	
end

get '/trucks' do 
	haml :trucks
end

get '/neighborhood/:neighborhood' do | hood |
	@neighborhood = hood
	haml :neighborhood
end
