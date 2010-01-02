require 'spec_helper'

describe UserSession do

  before(:each) do
    @user_session = UserSession.new(@http_session = {})
  end

  describe "label_selection" do
    
    it "should create a LabelSelection with http session :label_selection" do
      @http_session[:label_selection] = [1,2]
      LabelSelection.should_receive(:new).with(@http_session[:label_selection]).and_return(selection = mock(LabelSelection, :null_object => true))

      @user_session.label_selection.should == selection
    end

    it "should update http session :label_selection when LabelSelection changes" do
      label = Factory(:label)
      @user_session.label_selection << label
      @http_session[:label_selection].should == [label.id]
    end

  end

end
