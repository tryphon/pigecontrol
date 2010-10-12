require 'spec_helper'

describe WelcomeController do
  describe "GET 'index'" do
    it "should redirect to default source chunks" do
      get 'index'
      response.should redirect_to(source_chunks_path(Source.default))
    end
  end
end
