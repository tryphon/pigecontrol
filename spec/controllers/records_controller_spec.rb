require 'spec_helper'

describe RecordsController do

  let(:source) { Factory(:source) }

  describe "POST /create" do
    
    it "should accept a json request" do
      post :create, :source_id => source.to_param, :record => { :filename => test_file }, :format => :json
      response.should be_success
    end

  end

end
