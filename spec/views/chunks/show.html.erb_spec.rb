require 'spec_helper'

describe "/chunks/show.html.erb" do
  include ChunksHelper
  before(:each) do
    assigns[:chunk] = @chunk = Factory(:chunk, :completion_rate => 0.8)
  end

  it "renders attributes in description" do
    render
    response.should have_tag("div[class=description]", /#{I18n.localize(@chunk.begin)}/)
  end

  context "when chunk is completed" do

    before(:each) do
      @chunk.completion_rate = 1
    end

    it "should render a download link" do
      render
      response.should have_tag("a[href=?][class=download]", source_chunk_path(@chunk.source, @chunk, :format => "wav"))
    end

    it "should not display a download pending link" do
      render
      response.should_not have_tag("a[href=?][class=download-pending]")
    end
  
  end


  context "when chunck isn't completed" do
    
    before(:each) do
      @chunk.completion_rate = 0
    end
    
    it "should not render a download link" do
      render
      response.should_not have_tag("a[class=download]")
    end

    it "should display a donwload pending link" do
      render
      response.should have_tag("a[href=?][class=download-pending]", source_chunk_path(@chunk.source, @chunk))
    end
          
  end

  it "should display Chunk#begin with seconds" do
    @chunk.begin = Time.zone.parse("20:30:17")
    render
    response.should have_text(/20:30:17/)
  end

  it "should display Chunk#end with seconds" do
    @chunk.end = Time.zone.parse("20:30:17")
    render
    response.should have_text(/20:30:17/)
  end

end
