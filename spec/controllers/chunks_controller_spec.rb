require 'spec_helper'

describe ChunksController do

  before(:each) do
    @chunk = Factory(:chunk)
  end

  def mock_label_selection
    LabelSelection.new.tap do |selection|
      selection.stub!(:source).and_return(@chunk.source)
      selection.stub!(:chunk).and_return(@chunk)

      user_session = mock(UserSession, :label_selection => selection)
      controller.stub!(:user_session).and_return(user_session)
    end
  end

  describe "GET show in wav" do

    it "assigns the requested chunk as @chunk" do
      File.stub!(:exists?).and_return(true)
      controller.should_receive(:send_file).with(@chunk.file, :type => :wav)

      get :show, :id => @chunk, :source_id => @chunk.source, :format => "wav"
    end

  end

  describe "GET new" do
    
    before(:each) do
      @label_selection = mock_label_selection
    end

    it "should use the LabelSelection to create Chunk" do
      get :new, :source_id => @label_selection.source
      assigns[:chunk].should == @label_selection.chunk
    end

    it "should not use the LabelSelection to create Chunk when nil" do
      @label_selection.stub!(:chunk)
      get :new, :source_id => @label_selection.source
      assigns[:chunk].should_not be_nil
    end

    it "should not use the LabelSelection when sources miss-match" do
      @label_selection.should_not_receive(:chunk)
      get :new, :source_id => Factory(:source)
    end
    
  end

  describe "POST create" do

    before(:each) do
      @label_selection = mock_label_selection
    end
    
    it "should not use the LabelSelection to create Chunk" do
      @label_selection.should_not_receive(:chunk)
      post :create, :source_id => @chunk.source
    end

  end

end
