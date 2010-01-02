require 'spec_helper'

describe LabelsController do

  describe "GET /index" do

    it "should paginate labels per 10" do
      get :index, :source_id => Source.default
      assigns[:labels].per_page.should == 10
    end

    it "should order labels, newer first" do
      newest_label = Factory :label
      older_label = Factory :label, :timestamp => newest_label.timestamp - 10

      get :index, :source_id => Source.default
      assigns[:labels] == [ newest_label, older_label ]
    end

  end

  describe "GET /select" do

    before(:each) do
      @label = Factory(:label)
      request.env["HTTP_REFERER"] = '/dummy' 
    end
    
    it "should add label to UserSession label_selection" do
      get :select, :source_id => @label.source, :id => @label
      controller.send(:user_session).label_selection.should == [@label]
    end

    it "should redirect back" do
      get :select, :source_id => @label.source, :id => @label
      response.should redirect_to(request.env["HTTP_REFERER"])
    end

  end

end
