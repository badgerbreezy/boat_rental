require 'minitest/autorun'
require 'minitest/pride'
require 'Pry'
require './lib/renter'
require './lib/dock'
require './lib/boat'

class DockTest < Minitest::Test
  def test_it_exists_and_has_attributes
    dock = Dock.new("The Rowing Dock", 3)

    assert_instance_of Dock, dock
    assert_equal "The Rowing Dock", dock.name
    assert_equal 3, dock.max_rental_time
  end

  def test_it_can_rent
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)

    assert_equal ({kayak_1 => patrick, kayak_2 => patrick, sup_1 => eugene}), dock.rental_log
  end

  def test_charge
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    kayak_1.add_hour
    kayak_1.add_hour

    assert_equal ({
      :card_number => "4242424242424242",
      :amount => 40
    }), dock.charge(kayak_1)
  end

  def test_it_can_calculate_total_amount
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    kayak_1.add_hour
    kayak_1.add_hour

    assert_equal 40, dock.total_amount(kayak_1)
  end

  def test_it_cannot_overcharge
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    kayak_1.add_hour
    kayak_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour

    assert_equal ({
      :card_number => "1313131313131313",
      :amount => 45
    }), dock.charge(sup_1)
  end

  def test_it_can_calculate_revenue
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1,patrick)
    dock.rent(kayak_2,patrick)
    dock.log_hour
    dock.rent(canoe, patrick)
    dock.log_hour
    # binding.pry
    assert_equal 0, dock.revenue

    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)
    assert_equal 105, dock.revenue

    dock.rent(sup_1, eugene)

    dock.rent(sup_2, eugene)

    dock.log_hour

    dock.log_hour

    dock.log_hour

    dock.log_hour

    dock.log_hour

    dock.return(sup_1)

    dock.return(sup_2)

    # Total revenue
    assert_equal 195, dock.revenue

  end

end
