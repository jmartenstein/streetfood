#!/usr/bin/ruby

require 'sinatra'
require 'haml'
require 'active_support/core_ext/integer/inflections'

require './model/stop.rb'
require './model/truck.rb'
require './model/location.rb'

set :views, File.dirname(__FILE__) + '/../static'
set :public, File.dirname(__FILE__) + '/../static'

#if (settings.environment = "development") {
#	root_url = "http://localhost:4567"
#}
#else {
#	root_url = "http://www.lunchonfourwheels.com"
#}

#root_url = "http://" + request.host + ":" + request.port

helpers do
 	def base_url
		@base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
	end
	def page_text
		@page_text = {
			'title' => 'Lunch on Four Wheels',
			'sub-title' 		=> 'a seattle street food directory',
			'footer-text' 		=> '(c) Justin Martenstein, 2011',
			'footer-links' 	=> {
				'about'	=> 'about',
			}
		}
	end
	def global_helper
		base_url; page_text
	end
end

get '/' do
	global_helper
	haml :today
end

get '/neighborhoods' do
	global_helper
	haml :neighborhoods
end

get '/trucks' do 
	global_helper
	haml :trucks
end

get '/truck/:truck_name' do | name |
	@truck = Truck.find_by_name(name)
	@object = @truck
	global_helper
	haml :truck	
end

get '/neighborhood/:neighborhood' do | hood |
	@neighborhood = hood
	global_helper
	haml :neighborhood
end

get '/today' do
	@num = 0
	global_helper
	haml :today
end

get '/this_week' do
	@num = 0
	global_helper
	haml :this_week
end

get '/today\s:num' do | num |
	@num = num
	global_helper
	haml :today
end

get '/tomorrow' do 
	redirect '/today+1'
end

get '/this_week\s:num' do | num |
	@num = num
	global_helper
	haml :this_week
end

get '/about' do 
	global_helper
	haml :about
end

