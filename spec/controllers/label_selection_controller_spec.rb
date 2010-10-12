require 'spec_helper'

describe LabelSelectionController do

  describe "DELETE 'destroy'" do

    before(:each) do
      request.env["HTTP_REFERER"] = '/dummy' 
    end

    def label_selection
      controller.send(:user_session).label_selection
    end

    it "should be successful" do
      label_selection << Factory(:label)
      delete :destroy
      label_selection.should be_empty
    end

    it "should redirect back" do
      delete :destroy
      response.should redirect_to(request.env["HTTP_REFERER"])
    end

  end
end
