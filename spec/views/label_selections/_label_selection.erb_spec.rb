require 'spec_helper'

describe "Partial /label_selections/label_selection" do

  before(:each) do
    @label_selection = LabelSelection.new
    @label = Factory(:label)
  end

  def render_partial
    render :partial => "/label_selections/label_selection", :object => @label_selection
  end

  it "should be empty when LabelSelection is empty" do
    render_partial    
    response.body.should be_empty
  end

  describe "when a label is selected" do

    before(:each) do
      @label_selection << @label
    end

    it "should use a div label_selection" do
      render_partial    
      response.body.should have_tag("div.label_selection")
    end

    it "should have a link to clear the selection" do
      render_partial    
      response.body.should have_tag("a[href=?]", label_selection_path)
    end

    it "should have a link to create a new chunk" do
      render_partial    
      response.body.should have_tag("a[href=?]", new_source_chunk_path(@label.source))
    end

    it "should display selected label timestamp" do
      @label.timestamp = Time.parse("17:00:00 UTC")
      render_partial
      response.body.should have_tag("li", /19:00:00/)
    end

    it "should display label name (first 40 characters)" do
      @label.name = "a very long name" * 3 
      render_partial
      response.body.should have_tag("li", /#{@label.name.first(37)}.../)
    end
    
  end

end
