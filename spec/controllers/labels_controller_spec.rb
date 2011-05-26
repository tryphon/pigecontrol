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

  describe "POST /create" do
    
    it "should redirect to source labels path when label is created" do
      post :create, :source_id => Source.default, :label => Factory.attributes_for(:label)
      response.should redirect_to(source_labels_path(Source.default))
    end

    it "should render new template when label is not created" do
      post :create, :source_id => Source.default
      controller.should render_template('create')
    end

  end

  describe "GET /select" do

    before(:each) do
      @label = Factory(:label)
      request.env["HTTP_REFERER"] = '/dummy' 
    end

    describe "when a first label is selected" do

      it "should add label to UserSession label_selection" do
        get :select, :source_id => @label.source, :id => @label
        controller.send(:user_session).label_selection.should == [@label]
      end

      it "should redirect back" do
        get :select, :source_id => @label.source, :id => @label
        response.should redirect_to(request.env["HTTP_REFERER"])
      end
      
    end

    describe "when a second label is selected" do

      before(:each) do
        @first_label = Factory(:label, :timestamp => @label.timestamp - 5)
      end

      it "should add label to UserSession label_selection" do
        get :select, {:source_id => @label.source, :id => @label}, :label_selection => [@first_label.id]
        controller.send(:user_session).label_selection.should == [@first_label, @label]
      end
      
      it "should redirect to new_source_chunk_path" do
        get :select, {:source_id => @label.source, :id => @label}, :label_selection => [@first_label.id]
        response.should redirect_to(new_source_chunk_path(@label.source))
      end
      
    end

  end

  describe "DELETE /destroy" do

    let(:label) { Factory(:label) }
    
    it "should clear LabelSelection if destroyed label is selected" do
      delete :destroy, {:id => label.id, :source_id => label.source}, :label_selection => [label.id]
      controller.send(:user_session).label_selection.should be_empty
    end

  end

end
