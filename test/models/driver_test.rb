require "test_helper"

describe Driver do
  let (:new_driver) {
    Driver.new(name: "Kari", vin: "123", available: "true")
  }

  let (:new_passenger) {
    Passenger.create(name: "Kari", phone_num: "111-111-1211")
  }

  let (:trip_1) {
    Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 12.34)
  }

  let (:trip_2) {
    Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 63.34)
  }

  it "can be instantiated" do
    # Assert
    expect(new_driver.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_driver.save
    driver = Driver.first
    [:name, :vin, :available].each do |field|

      # Assert
      expect(driver).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_driver.save
      trip_1
      trip_2

      # Assert
      expect(new_driver.trips.count).must_equal 2
      new_driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_driver.name = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :name
      expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a VIN number" do
      # Arrange
      new_driver.vin = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :vin
      expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    it "average rating: will return nil if there were no trips or ratings recorded" do
      new_driver.save
      assert_nil(new_driver.average_rating)
    end

    it "average rating: will return an average rating for recorded trips and ratings" do
      new_driver.save
      trip_1
      trip_2

      expect(new_driver.average_rating).must_equal 4
    end

    it "total earnings: returns 0 if no driven trips" do
      new_driver.save
      expect(new_driver.total_earnings).must_equal 0
    end

    it "total earnings: returns proper net earnings if valid trips" do
      new_driver.save
      trip_1
      trip_2
      expect(new_driver.total_earnings).must_be_within_delta (12.34 + 63.34 - 2 * 1.65) * 0.8, 0.01
    end

    it "can go online and offline" do
      new_driver.save
      new_driver.toggle_availability
      new_driver.reload
      expect(new_driver.available).must_equal 'false'

      new_driver.toggle_availability
      new_driver.reload
      expect(new_driver.available).must_equal 'true'
    end
  end
end
