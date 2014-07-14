require 'spec_helper'

describe SiteHelper do

  describe "site_information_tag" do

    it "should be nil when Site.default.information is nil" do
      helper.site_information_tag.should be_nil
    end

    it "should wrap the Site.default.information in p tag" do
      Site.default.information = "dummy"
      helper.site_information_tag.should have_selector("p", :text => "dummy")
    end

    before(:each) do
      Site.default.information = nil
    end

  end

end
