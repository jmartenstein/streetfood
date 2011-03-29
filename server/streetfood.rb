#!/usr/bin/ruby

require 'sinatra'
require 'haml'
require 'active_support/core_ext/integer/inflections'

require './model/stop.rb'
require './model/truck.rb'
require './model/location.rb'

set :views, File.dirname(__FILE__) + '/../static'
set :public, File.dirname(__FILE__) + '/../static'

page_text = {
	'title' => 'Lunch on Four Wheels',
	'sub-title' => 'a seattle streetfood directory',
	'footer-text' => '(c) Justin Martenstein, 2011',
	'footer-links' => {
		'about' => 'about',
		'feedback' => 'feedback'
	}
}

get '/' do
	@page_text = page_text
   haml :today
end

get '/neighborhoods' do
	@page_text = page_text
   haml :neighborhoods
end

get '/trucks' do 
	@page_text = page_text
	haml :trucks
end

get '/truck/:truck_name' do | name |
	@name = name
	@page_text = page_text
	haml :truck	
end

get '/neighborhood/:neighborhood' do | hood |
	@neighborhood = hood
	@page_text = page_text
	haml :neighborhood
end

get '/today' do
	@num = 0
	@page_text  = page_text
	haml :today
end

get '/this_week' do
	@num = 0
	@page_text = page_text
	haml :this_week
end

get '/today\s:num' do | num |
	@num = num
	@page_text = page_text
	haml :today
end

get '/this_week\s:num' do | num |
	@num = num
	@page_text = page_text
	haml :this_week
end


