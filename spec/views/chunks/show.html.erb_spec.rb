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

  it "should render a Download link when chunck is completed" do
    @chunk.completion_rate = 1

    render
    response.should have_tag("a[href=?]", source_chunk_path(@chunk.source, @chunk, :format => "wav"))
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
