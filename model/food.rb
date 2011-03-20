#!/usr/bin/ruby

# food.rb
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

class Food < ActiveRecord::Base
	has_and_belongs_to_many :trucks

def self.up

	ActiveRecord::Schema.define do
		create_table :foods do | table |
			table.string :name
		end
	end

end  # self.up

def self.down
	ActiveRecord::Schema.drop_table :foods
end  # self.down

def self.import

	CSV.foreach("./data/foods.csv") do | line |

		record = self.create(
			:name => line[0]
		)

	end  # CSV.foreach

end  # self.import

end # class Food
