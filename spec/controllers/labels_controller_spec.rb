require 'spec_helper'

describe LabelsController do

  describe "GET /index.html" do

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

end
