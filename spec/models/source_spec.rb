require 'spec_helper'

describe Source do

  before(:each) do
    @source = Source.new(:name => 'test')
  end

  it "should validate the presence of name" do
    @source.name = nil
    @source.should have(1).error_on(:name)
  end

  it "should validate the uniquess of name" do
    @source.save!
    Source.new(:name => @source.name).should have(1).error_on(:name)
  end

end
