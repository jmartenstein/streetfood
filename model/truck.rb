#!/usr/bin/ruby

# trucks.rb
# Justin Martenstein, February 2011

require 'active_record'
require 'logger'
require 'date'
require 'csv'

# set our logging options
ActiveRecord::Base.logger = Logger.new(STDERR)
#ActiveRecord::Base.colorize_logging = false

# create the connection to our database
ActiveRecord::Base.establish_connection(
   :adapter => "sqlite3",
	:database => "./data/streetfood.db"
)

class Truck < ActiveRecord::Base
	has_many :stops

def self.up

	# define the table schema, and create it
	ActiveRecord::Schema.define do
		create_table :trucks do | table |
			table.column :name,			:string
			table.column :website, 		:string
			table.column :twitter,		:string
			table.column :facebook,		:string
			table.column :yelp,			:string
		end
	end

end  # self.up

def self.down
	ActiveRecord::Schema.drop_table :trucks
end  # self.down

def self.import

	CSV.foreach("./data/trucks.csv") do | line |

		record = self.create(
			:name				=> line[0],
			:website			=> line[1],
			:twitter			=> line[2],
			:facebook		=> line[3],
			:yelp				=> line[4]
		)

	end

end  # self.import

end  # class Truck

