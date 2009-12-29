require 'spec_helper'

describe Source do

  before(:each) do
    @source = Factory(:source)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_many(:chunks) }
  it { should have_many(:records) }

  describe "default" do
    
    it "should return Source with id 1" do
      Source.should_receive(:find).with(1).and_return(@source)
      Source.default.should == @source
    end

  end

end
