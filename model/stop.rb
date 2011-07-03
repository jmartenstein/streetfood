#!/usr/bin/ruby

# stops.rb
# Justin Martenstein, December 2010

require 'active_record'
require 'logger'
require 'date'
require 'csv'

require './model/location.rb'
require './model/truck.rb'

# set our logging options
ActiveRecord::Base.logger = Logger.new(STDERR)
#ActiveRecord::Base.colorize_logging = false

# create the connection to our database
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection(
   dbconfig[ENV['RACK_ENV'] || 'test']
)

class Stop < ActiveRecord::Base
   belongs_to 	:truck
   belongs_to	:location

def self.up

   ActiveRecord::Schema.define do
      create_table :stops do | table |
         table.references  :truck
         table.references  :location
         table.string      :date    
         table.string      :hours     
         table.boolean     :suppressed  
      end
   end

end

def self.down
   ActiveRecord::Schema.drop_table :stops
end

def self.import

   CSV.foreach("./data/stops.csv") do | line |

      # make sure the line isn't just whitespace or a comment

      # check to see if we are importing a day of the week, otherwise
      # assume it's a date
      #if (line[3] =~ /(Sun|Mon|Tues|Wed|Thurs|Fri|Sat)/)
      #   date = Date.strptime(line[3], "%A")
      #else
      #   date = Date.strptime(line[3], "%m/%d/%Y")
      #end

      # make it first, because we're assuming that 'name' is unique;
      # should put some sort of architecture in to back that up
      truck = Truck.where('name LIKE ?', line[0]).first
      location = Location.where('name LIKE ?', line[1]).first

      # now create records for every line in the csv
      record = self.create(
         :truck_id      => truck.id,
         :location_id   => location.id,
         :date          => line[2],
         :hours         => line[3]
      )

   end

end

def self.by_date( date=Date.today )

   wday_string = date.strftime("%A") + "s"
   date_string = date.to_s

   return self.where( 'date LIKE ? OR date LIKE ?', wday_string, date_string )
   
end

def self.by_neighborhood( hood )

   # grab the list of locations for a particular neighborhood
   neighborhood = Neighborhood.find_by_name(hood)
   locations = Location.where( 'neighborhood_id LIKE ?', neighborhood.id )
   stops = []

   # for each location, list out the stops
   locations.each do | location |
      location_stops = self.where( 'location_id LIKE ?', location.id )
      location_stops.each do | stop |
         stops.push(stop)
      end
   end

   return stops

end

#def self.to_s 
   #return "#{truckname}, #{location}, #{date}"
#end

end  # class Stop
