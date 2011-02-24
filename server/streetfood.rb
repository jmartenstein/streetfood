#!/usr/bin/ruby

require 'sinatra'
require 'haml'

require './model/stops.rb'
require './model/trucks.rb'
require './model/locations.rb'

set :views, File.dirname(__FILE__) + '/../static'
set :public, File.dirname(__FILE__) + '/../static'

get '/' do
   haml :this_week
end

get '/truck/:truck_name' do | name |
	@name = name
	haml :truck	
end
