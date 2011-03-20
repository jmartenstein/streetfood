#!/usr/bin/ruby

# location.rb
# Justin Martenstein, February 2011

require 'active_record'
require 'logger'
require 'date'
require 'csv'

require './model/neighborhood.rb'

# set looging options
ActiveRecord::Base.logger = Logger.new(STDERR)

# create the connection to the database
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection(
	dbconfig['production']
)

class Location < ActiveRecord::Base
	has_many 	:stops
	belongs_to	:neighborhood

# create the table
def self.up

	# define the schema for the Locations table
	ActiveRecord::Schema.define do
		create_table :locations do | table |
			table.string 		:name
			table.references	:neighborhood
			table.string		:notes
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

		# look up neighborhood
		neighborhood = Neighborhood.where('name LIKE ?', line[1]).first

		#create a record for each line in the file
		record = self.create(
			:name					=> line[0],
			:neighborhood_id 	=> neighborhood.id,
			:notes				=> line[2]
		)	

   end  # CSV.foreach

end

end  # class Location
