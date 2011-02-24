#!/usr/bin/ruby

# Rakefile
# Justin Martenstein, December 2010

# import standard libraries
require 'rake'
require 'date'

# import custom library
require './model/stops.rb'
require './model/locations.rb'
require './model/trucks.rb'

namespace "db" do

desc "dummy function"
task :test do
   puts "test"
end

desc "re-create the database with data"
task :reload do

	# delete each of the tables
   Stops.down
	Locations.down
	Trucks.down

	# recreate each of the tables, define their schemas
   Stops.up
	Locations.up
	Trucks.up

	# import data from the csv file into each table
	Stops.import
	Locations.import
	Trucks.import

end

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

desc "dummy function"
task :test2 do
   puts "test 2"
end
