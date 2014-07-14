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
    response.body.should_not have_selector("div.label_selection")
  end

  describe "when a label is selected" do

    before(:each) do
      @label_selection << @label
    end

    it "should use a div label_selection" do
      render_partial
      response.body.should have_selector("div.label_selection")
    end

    it "should have a link to clear the selection" do
      render_partial
      response.body.should have_selector("a[href='#{label_selection_path}']")
    end

    it "should have a link to create a new chunk" do
      render_partial
      response.body.should have_selector("a[href='#{new_source_chunk_path(@label.source)}']", )
    end

    it "should display selected label timestamp" do
      @label.timestamp = Time.parse("19:00:00")
      render_partial
      response.body.should have_selector("li", :text => /19:00:00/)
    end

    it "should display label name (first 40 characters)" do
      @label.name = "a very long name" * 3
      render_partial
      response.body.should have_selector("li", :text => /#{@label.name.first(37)}.../)
    end

  end

end
