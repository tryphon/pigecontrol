require 'spec_helper'

describe Source do

  before(:each) do
    @source = Factory(:source)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_many(:chunks, :dependent => :destroy) }
  it { should have_many(:records, :dependent => :destroy) }
  it { should have_many(:labels, :dependent => :destroy) }

  describe "default" do

    it "should find or create a Source with id 1" do
      Source.should_receive(:find_or_create_by_name).with('default').and_return(@source)
      Source.default.should == @source
    end

    it "should not be a new record" do
      Source.default.should_not be_new_record
    end

  end

end
