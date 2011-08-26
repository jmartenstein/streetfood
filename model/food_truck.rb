#!/usr/bin/ruby

# food_truck.rb
# Justin Martenstein, March 2011

require 'active_record'
require 'logger'
require 'date'
require 'csv'

require './model/food.rb'
require './model/truck.rb'

# set our logging options
ActiveRecord::Base.logger = Logger.new(STDERR)
#ActiveRecord::Base.colorize_logging = false

# create the connection to our database
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection(
   dbconfig[ENV['RACK_ENV'] || 'test']
)

class FoodsTrucks < ActiveRecord::Base

def self.up

   # define the table schema, create it
   ActiveRecord::Schema.define do
      create_table :foods_trucks, :id => false do | table |
         table.integer :food_id
         table.integer :truck_id
      end
   end

end  # self.up

def self.down
   ActiveRecord::Schema.drop_table :foods_trucks
end  # self.down

def self.import

   CSV.foreach("./data/trucks.csv") do | line |
      truck = Truck.where('name LIKE ?', line[0]).first

      # assume that everything on the end of the line is a food
      line[5..-1].each do | food |
         food = Food.where('name LIKE ?', food).first

         record = self.create(
            :truck_id   => truck.id,
            :food_id    => food.id
         )

      end
   end

end

end  # class Food_Truck
