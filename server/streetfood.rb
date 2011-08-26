#!/usr/bin/ruby

require 'sinatra'
require 'haml'
require 'compass'
require 'active_support/core_ext/integer/inflections'

require './model/stop.rb'
require './model/truck.rb'
require './model/location.rb'

configure do

   Compass.configuration do |config|
      config.project_path = File.dirname(__FILE__)
      config.sass_dir = '/../static/sass'
   end

   set :sass, Compass.sass_engine_options
   set :views, File.dirname(__FILE__) + '/../static'
   set :public, File.dirname(__FILE__) + '/../static'

end

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


### Miscellaneous Routes ###

get '/' do
   redirect '/today'
end

get '/stylesheets/:name.css' do
   content_type 'text/css', :charset => 'utf-8'
   scss( :"sass/#{params[:name]}", Compass.sass_engine_options )
end

get '/about' do 
   haml :about
end

# test page for Blueprint CSS grids 
get '/test' do
   haml :test, :layout => false
end


### By Neighborhood / Location / Stop ###

get '/neighborhoods' do
   haml :neighborhoods
end

get '/neighborhood/:neighborhood' do | hood |
   @neighborhood = hood
   haml :neighborhood
end

get '/location/:name/edit' do | name |
   @location = Location.find_by_name(name)
   @selected_hood = @location.neighborhood
   @neighborhoods = Neighborhood.all
   haml :edit_location
end

post '/location/:name/edit' do | name |

   @location = Location.find_by_name(name)
   @neighborhood = Neighborhood.find_by_name(params[ :location_hood ])

   @location.name = params[ :location_name ]
   @location.notes = params[ :location_notes ]
   @location.neighborhood = @neighborhood

   @location.save

   redirect "/neighborhood/#{@neighborhood.name}"

end


### By Truck ###

get '/trucks' do 
   haml :trucks
end

get '/truck/:truck_name' do | name |
   @truck = Truck.find_by_name(name)
   @object = @truck
   haml :truck	
end


### By Schedule / Date ###

get '/today' do
   @day = Date.today
   unsorted_stops = Stop.by_date(@day)
   @stops = unsorted_stops.sort_by{ |a| [ a.location.neighborhood.distance, a.location.neighborhood.name, a.location.name ] }
   haml :today
end

get '/today\s:num' do | num |
   @day = Date.today + num.to_i
   unsorted_stops = Stop.by_date(@day)
   @stops = unsorted_stops.sort_by{ |a| [ a.location.neighborhood.distance, a.location.neighborhood.name ] }
   haml :today
end

get '/this_week' do
   @num = 0
   haml :this_week
end

get '/this_week\s:num' do | num |
   @num = num
   haml :this_week
end

get '/tomorrow' do 
   redirect '/today+1'
end


