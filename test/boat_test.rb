require 'minitest/autorun'
require 'minitest/pride'
require 'Pry'
require './lib/boat'
require './lib/renter'

class BoatTest < Minitest::Test
  def test_it_exists_and_has_attributes
    kayak = Boat.new(:kayak, 20)

    assert_instance_of Boat, kayak
  end
end
