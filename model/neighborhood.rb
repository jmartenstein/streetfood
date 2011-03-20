#!/usr/bin/ruby

# neighborhood.rb
# Justin Martenstein, March 2011

require 'active_record'
require 'logger'
require 'date'
require 'csv'

# set our logging options
ActiveRecord::Base.logger = Logger.new(STDERR)

# create the connection to our database
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection(
	dbconfig['production']
)

class Neighborhood < ActiveRecord::Base
	has_many :locations
	has_many :stops, :through => :locations

def self.up

	ActiveRecord::Schema.define do
		create_table :neighborhoods do | table |
			table.string 	:name
		end
	end

end

def self.down
	ActiveRecord::Schema.drop_table :neighborhoods
end

def self.import
	
	CSV.foreach("./data/neighborhoods.csv") do | line |
		record = self.create(
			:name 	=> line[0]
		)
	end  # CSV.foreach

end

end  # class Neighborhood
