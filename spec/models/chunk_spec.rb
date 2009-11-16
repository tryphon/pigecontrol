require 'spec_helper'

describe Chunk do
  before(:each) do
    @valid_attributes = {
      :begin => Time.now,
      :end => Time.now,
      :completion_rate => 1.5,
      :source_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Chunk.create!(@valid_attributes)
  end
end
