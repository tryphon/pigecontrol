require 'spec_helper'

describe ChunksController do

  describe "GET show in wav" do

    before(:each) do
      @chunk = Factory(:chunk)
    end

    it "assigns the requested chunk as @chunk" do
      File.stub!(:exists?).and_return(true)
      controller.should_receive(:send_file).with(@chunk.file, :type => :wav)

      get :show, :id => @chunk, :source_id => @chunk.source, :format => "wav"
    end

  end

end
