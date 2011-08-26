#!/usr/bin/ruby

# Rakefile
# Justin Martenstein, December 2010

# import standard libraries
require 'rake'
require 'rake/testtask'
require 'date'

# import custom library
require './model/stop.rb'
require './model/food_truck.rb'
#require './model/location.rb'
#require './model/truck.rb'

namespace "db" do

desc "dummy function"
task :test do
   puts "test"
end

desc "re-create the database with data"
task :reload do

   # delete each of the tables
   Stop.down            if Stop.table_exists?
   FoodsTrucks.down     if FoodsTrucks.table_exists?
   Location.down        if Location.table_exists?
   Truck.down           if Truck.table_exists?
   Neighborhood.down    if Neighborhood.table_exists?
   Food.down            if Food.table_exists?

   # bring up Neighborhoods
   Neighborhood.up
   Neighborhood.import

   # bring up food next
   Food.up
   Food.import

   # bring up the Locations first
   Location.up
   Location.import

   # bring up the Trucks second
   Truck.up
   Truck.import

   # bring up the Stops close to last, since it's dependant on the other two
   Stop.up
   Stop.import

   # bring up the Foods / Trucks join last
   FoodsTrucks.up
   FoodsTrucks.import

end # task :reload

desc "Backup the heroku database"
task :remote_backup do

   # pull info from the remote database and save to a dated file

end # remote_backup

desc "populate the database"
task :dummy do

    date1 = Date.strptime("12/22/2010", "%m/%d/%Y")
    stop1 = Stops.create( :truckname => "Street Treats", :location => "9th and Cherry", 
              :notes => "One block north of Harborview", :date => date1, 
              :hours => "12pm - 2pm" )

end

desc "list stops on a particular date"
task :liststops, [ :arg1 ] do | t, args |

    # initialize the date object we want to search on
    #date1 = Date.strptime("12/21/2010", "%m/%d/%Y")
    #if (args != '')
    #   puts args.arg1
    #else
    #   puts "empty"
    #end

    # set the default value to today's date, in string format
    args.with_defaults( :arg1 => Date.today.strftime("%m/%d") )
    
    # convert the line back to a date
    date = Date.strptime(args.arg1, '%m/%d')

    # grab the list
    stops = Stops.where( :date => date )

    # iterate over the list and print out the info
    stops.each do | stop | 
       puts "#{stop.truckname}, #{stop.location}, #{stop.date}"
    end 

end

desc "list a set of dates"
task :listdates do
end

desc "display the database"
task :show do
end

end # db namespace


namespace "test" do

desc "Setup data structures for the unit test"
task :setup do

   Food.up
   Truck.up
   Neighborhood.up
   Location.up
   Stop.up
   FoodsTrucks.up

   today_days = Date.today.strftime("%A") + "s"
   tomorrow_days = Date.tomorrow.strftime("%A") + "s"

   truck1         = Truck.new( :name => "truck foo" )
   truck2         = Truck.new( :name => "truck bar" )

   neighborhood1  = Neighborhood.new( :name => "neighborhood foo" )
   neighborhood2  = Neighborhood.new( :name => "neighborhood bar" )
   
   location1      = Location.new( :name => "location foo", :neighborhood_id => 1 )
   location2      = Location.new( :name => "location bar", :neighborhood_id => 1 )
   location3      = Location.new( :name => "location foobar", :neighborhood_id => 2 )

   today_stop1    = Stop.new( :truck_id => 1, :location_id => 2, :date => today_days, :hours => "11am-2:30pm" )
   today_stop2    = Stop.new( :truck_id => 1, :location_id => 1, :date => Date.today, :hours => "3pm-7pm" )

   tomorrow_stop1 = Stop.new( :truck_id => 1, :location_id => 3, :date => Date.tomorrow )
   tomorrow_stop2 = Stop.new( :truck_id => 2, :location_id => 3, :date => Date.tomorrow, :suppressed => true )
   
   truck1.save
   truck2.save

   neighborhood1.save
   neighborhood2.save

   location1.save
   location2.save
   location3.save

   today_stop1.save
   today_stop2.save
   tomorrow_stop1.save
   tomorrow_stop2.save

end # task :setup

desc "Delete the database tables"
task :teardown do

   FoodsTrucks.down
   Stop.down
   Location.down
   Neighborhood.down
   Truck.down
   Food.down

end

desc "Run the unit tests"
Rake::TestTask.new("run") do | t |
   t.libs << "test"
   t.test_files = FileList['test/test_*.rb']
   t.verbose = true
end

desc ""
task :all do
end

end # test namespace


desc "dummy function"
task :test2 do
   puts "test 2"
end
