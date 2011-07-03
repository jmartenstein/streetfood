# test_stop.rb

require './model/stop'
require 'test/unit'

class StopTest < Test::Unit::TestCase

def setup

   #Location.up
   #Truck.up
   #Stop.up
   #Neighborhood.up

   @location_name1       = "location foo"
   @truck_name1          = "truck foo"
   @neighborhood_name1   = "neighborhood foo"

   # create some data in the database; this isn't technicall a "pure" unit
   # test, but it'll do for now
   #neighborhood1 = Neighborhood.new( :name => neighborhood_name1 ).save
   #location1 = Location.new( :name => location_name1, :neighborhood_id => 1 ).save
   #truck1 = Truck.new( :name => truck_name1 ).save
   #stop1 = Stop.new( :truck_id => 1, :location_id => 1, :date => Date.today ).save


end # def setup

def teardown

   #Stop.down
   #Truck.down
   #Location.down
   #Neighborhood.down

end # def teardown

def test_location1

   stop1 = Stop.find(2)
   assert_equal( @location_name1, stop1.location.name ) 

end # def test_location1

def test_truck1

   stop1 = Stop.find(1)
   assert_equal( @truck_name1, stop1.truck.name )

end # def test_truck1

def test_neighborhood1

   stop1 = Stop.find(1)
   assert_equal( @neighborhood_name1, stop1.location.neighborhood.name )

end # def test_neighborhood1

def test_by_neighborhood1

   expected_stop_list = Stop.by_neighborhood( @neighborhood_name1 )
   actual_stop_list = [ Stop.find(2), Stop.find(1) ]

   assert_equal(expected_stop_list, actual_stop_list)

end

def test_by_date1

   expected_stop_list = [ Stop.find(1), Stop.find(2) ]
   actual_stop_list = Stop.by_date( Date.today )

   assert_equal(expected_stop_list, actual_stop_list)

end # def test_by_date1

end   # class StopTest
