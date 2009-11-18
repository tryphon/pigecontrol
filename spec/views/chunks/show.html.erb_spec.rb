require 'spec_helper'

describe "/chunks/show.html.erb" do
  include ChunksHelper
  before(:each) do
    assigns[:chunk] = @chunk = Factory(:chunk, :completion_rate => 0.8)
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/0.8/)
  end

  it "should render a Download link when chunck is completed" do
    @chunk.completion_rate = 1

    render
    response.should have_tag("a[href=?]", source_chunk_path(@chunk.source, @chunk, :format => "wav"))
  end
end
