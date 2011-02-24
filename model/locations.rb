#!/usr/bin/ruby

# locations.rb
# Justin Martenstein, February 2011

require 'active_record'
require 'logger'
require 'date'
require 'csv'

# set looging options
ActiveRecord::Base.logger = Logger.new(STDERR)

# create the connection to the database
ActiveRecord::Base.establish_connection(
	:adapter   => "sqlite3",
	:database  => "./data/streetfood.db"
)

class Locations < ActiveRecord::Base

# create the table
def self.up

	# define the schema for the Locations table
	ActiveRecord::Schema.define do
		create_table :locations do | table |
			table.column :location, 		:string
			table.column :neighborhood,	:string
			table.column :notes,				:string
		end
	end

end

# destroy the table
def self.down
	ActiveRecord::Schema.drop_table :locations
end

# import the data from the csv file
def self.import

	# import the data from the associated csv file
	CSV.foreach("./data/locations.csv") do | line |

		#create a record for each line in the file
		record = self.create(
			:location		=> line[0],
			:neighborhood 	=> line[1],
			:notes			=> line[2]
		)	

   end  # CSV.foreach

end

end  # class Locations
