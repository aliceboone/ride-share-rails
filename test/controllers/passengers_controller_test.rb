require "test_helper"

describe PassengersController do

  let (:passenger) {
    Passenger.create  name: "Passenger",
                      phone_num: "999.999.9999"
  }

  let (:passenger_hash) {
    {
        passenger: {
          name: "Abigayle Rau Jr.",
          phone_num: "1-761-352-4516 x63527"
        }
    }
  }

  let (:invalid_params) {
    {
        passenger: {
            name: nil,
            phone_num: "560.815.3059"
        }
    }
  }

  describe "index" do
    it "can get the index path" do
      # Act
      get passengers_path

      # Assert
      must_respond_with :success
    end

    it "responds with success when there are passengers saved" do
      passenger
      get passengers_path
      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      get passengers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid passenger" do
      passenger

      # Act
      get passenger_path(passenger.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid passenger" do
      # Act
      get passenger_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new passenger page" do
      # Act
      get new_passenger_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      # Arrange

      # Act-Assert
      expect {
        post passengers_path, params: passenger_hash
      }.must_change "Passenger.count", 1

      new_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])
      expect(new_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]

      must_respond_with :redirect
      must_redirect_to passenger_path(new_passenger.id)
    end

    it "does not create a passenger if the form data violates passenger validations" do
      # Arrange
      passenger

      expect {
        post passengers_path, params: invalid_params
      }.wont_change "Passenger.count"
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid passenger" do
      passenger

      # Act
      get edit_passenger_path(passenger.id)

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      # Act
      get edit_passenger_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "Does not change count and redirects to passenger_path when passenger id is valid" do

      # Arrange
      Passenger.create(name: "Yvonne Okuneva IV", phone_num: "(215) 056-6568 x5330")

      passenger = Passenger.first

      # Act-Assert
      expect {
        patch passenger_path(passenger.id), params: passenger_hash
      }.wont_change "Passenger.count"

      must_respond_with :redirect
      must_redirect_to passenger_path

      passenger.reload
      expect(passenger.name).must_equal passenger_hash[:passenger][:name]
      expect(passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]
    end

    it "does not update passenger if given an invalid id and redirects" do
      # Act-Assert
      expect {
        patch passenger_path(-1), params: passenger_hash
      }.wont_change "Passenger.count"

      must_respond_with :redirect
    end

    it "does not patch a passenger if the form data violates passenger validations" do
      original_name = passenger.name
      original_phone_num = passenger.phone_num

      # Act-Assert
      expect {
        patch passenger_path(passenger.id), params: invalid_params
      }.wont_change "Passenger.count"

      passenger.reload

      expect(passenger.name).must_equal original_name
      expect(passenger.phone_num).must_equal original_phone_num
    end
  end

  describe "destroy" do
    it "Should delete an existing passenger and redirect to the page" do
      # Arrange
      passenger

      # Act
      expect {
        delete passenger_path(passenger.id)
      }.must_change 'Passenger.count', -1

      must_respond_with :redirect
      must_redirect_to passengers_path
    end

    it "does not change the db when the passenger does not exist, then redirects" do
      # Act-Assert
      expect {
        delete passenger_path(-1)
      }.wont_change 'Passenger.count'
      # Assert
      must_respond_with :redirect
    end
  end
end
