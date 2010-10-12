require 'spec_helper'

describe Label do
  before(:each) do
    @label = Factory(:label)
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:timestamp) }
  it { should belong_to(:source) }

  describe "date" do

    it "should return the date of timestamp" do
      @label.date.should == @label.timestamp.to_date
    end

  end
end
