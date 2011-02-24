#!/usr/bin/ruby

# stops.rb
# Justin Martenstein, December 2010

require 'active_record'
require 'logger'
require 'date'
require 'csv'

require './model/locations.rb'

# set our logging options
ActiveRecord::Base.logger = Logger.new(STDERR)
#ActiveRecord::Base.colorize_logging = false

# create the connection to our database
ActiveRecord::Base.establish_connection(
   :adapter => "sqlite3",
   :database => "./data/streetfood.db"
) 

class Stops < ActiveRecord::Base

def self.up

   ActiveRecord::Schema.define do
      create_table :stops do |table|
         table.column :truck_name,  	:string
         table.column :location,    	:string
         table.column :date,        	:string
         table.column :hours,       	:string
         table.column :suppressed,  	:boolean
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

      # now create records for every line in the csv
      record = self.create(
         :truck_name  	=> line[0],
         :location    	=> line[1],
         :date        	=> line[2],
         :hours       	=> line[3]
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
	locations = Locations.where( 'neighborhood LIKE ?', hood )
	stops = []

	# for each location, list out the stops
	locations.each do | location |
		stops.push(self.where( 'location LIKE ?', location.location))
	end

	return stops

end

#def self.to_s 
   #return "#{truckname}, #{location}, #{date}"
#end

end  # class Stop
