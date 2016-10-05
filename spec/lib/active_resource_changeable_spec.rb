require_relative "./../spec_helper"

class User < ActiveResource::Base
  self.site = ""

  include ActiveResourceChangeable

end

describe ActiveResourceChangeable do
  before(:all) do
    mocked_response = {
      firstname: "Neeraj",
      lastname: "Kumar",
      username: "neeraj",
      email: "neeraj.kumar@gmail.com"
    }

    User.stubs(:find).returns(User.new(mocked_response))

    mocked_response_after_save = {
      firstname: "Neeraj1",
      lastname: "Kumar1",
      username: "neeraj1",
      email: "neeraj1.kumar1@gmail.com"
    }

    User.any_instance.stubs(:save).returns(User.new(mocked_response_after_save))
  end
  
  it "should return the changes of object" do
    expect(true).to eq(true)
    user = User.find(1)
    puts user.inspect

    expect(user.firstname).to eq("Neeraj")
    expect(user.lastname).to eq("Kumar")
    expect(user.username).to eq("neeraj")
    expect(user.email).to eq("neeraj.kumar@gmail.com")

    user.firstname = "Neeraj1"
    user.lastname = "Kumar1"
    user.email = "neeraj1.kumar1@gmail.com"
    user.username = "neeraj1"

    user.save

    expect(user.changes[:firstname]).to eq(["Neeraj", "Neeraj1"])
    expect(user.changes[:lastname]).to eq(["Kumar", "Kumar1"])
    expect(user.changes[:username]).to eq(["neeraj", "neeraj1"])
    expect(user.changes[:email]).to eq(["neeraj.kumar@gmail.com", "neeraj1.kumar1@gmail.com"])
  end

end
