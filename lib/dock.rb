class Dock
  attr_reader :name, :max_rental_time, :rental_log, :potential_revenue
  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = Hash.new
    @potential_revenue = []
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    card_number = {:card_number => @rental_log[boat].credit_card_number, :amount => total_amount(boat)}
  end

  def total_amount(boat)
    boat.hours_rented * boat.price_per_hour
  end

  def log_hour
    @rental_log.each do |entry|
      entry[0].add_hour
    end
  end

  def return(boat)
    @potential_revenue << charge(boat)[:amount]
  end

  def revenue
    potential_revenue.sum
  end
end
