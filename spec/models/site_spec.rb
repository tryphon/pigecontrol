require 'spec_helper'

describe Site do

  describe "default instance" do

    it { Site.default.should_not be_nil }

    it "should have a blank information" do
      Site.new.information.should be_blank
    end
    
  end

  describe "class method config" do
    
    it "should configure the default instance" do
      Site.config do |site|
        site.information = "dummy"
      end

      Site.default.information.should == "dummy"
    end

    before(:each) do
      Site.default = Site.new
    end

  end

end 
