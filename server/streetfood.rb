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
#  root_url = "http://localhost:4567"
#}
#else {
#  root_url = "http://www.lunchonfourwheels.com"
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

before do
   global_helper
end

get '/' do
   redirect '/today'
end

get '/neighborhoods' do
   haml :neighborhoods
end

get '/trucks' do 
   haml :trucks
end

get '/truck/:truck_name' do | name |
   @truck = Truck.find_by_name(name)
   @object = @truck
   haml :truck	
end

get '/neighborhood/:neighborhood' do | hood |
   @neighborhood = hood
   haml :neighborhood
end

get '/today' do
   @day = Date.today
   unsorted_stops = Stop.by_date(@day)
   @stops = unsorted_stops.sort_by{ |a| [ a.location.neighborhood.distance, a.location.neighborhood.name, a.location.name ] }
   haml :today
end

get '/this_week' do
   @num = 0
   haml :this_week
end

get '/today\s:num' do | num |
   @day = Date.today + num.to_i
   unsorted_stops = Stop.by_date(@day)
   @stops = unsorted_stops.sort_by{ |a| [ a.location.neighborhood.distance, a.location.neighborhood.name ] }
   haml :today
end

get '/tomorrow' do 
   redirect '/today+1'
end

get '/this_week\s:num' do | num |
   @num = num
   haml :this_week
end

get '/about' do 
   haml :about
end

