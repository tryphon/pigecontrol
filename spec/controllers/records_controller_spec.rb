require 'spec_helper'

describe RecordsController do

  let(:source) { Factory :source }
  let(:record) { Factory :record, :source => source }

  describe "POST /create" do
    
    it "should accept a json request" do
      post :create, :source_id => source.to_param, :record => { :filename => test_file }, :format => :json
      response.should be_success
    end

    it "should use Source.find_or_default" do
      Source.should_receive(:find_or_default).and_return(source)
      post :create, :source_id => source.to_param, :record => { :filename => test_file }, :format => :json
    end

  end

  describe "DELETE /destroy" do

    it "should accept a json request" do
      delete :destroy, :source_id => source.to_param, :path => record.filename, :format => :json
      response.should be_success
    end

    it "should find the record by filename and remove it" do
      delete :destroy, :source_id => source.to_param, :path => record.filename, :format => :json
      Record.exists?(record).should be_false
    end

    it "should join path parts" do
      delete :destroy, :source_id => source.to_param, :path => record.filename.split("/"), :format => :json
      Record.exists?(record).should be_false
    end

  end

end
