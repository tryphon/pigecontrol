require 'spec_helper'

describe "/chunks/index.html.erb" do
  include ChunksHelper

  before(:each) do
    assigns[:chunks] = @chunks = Array.new(2) {
      Factory(:chunk, :completion_rate => 0.8)
    }
  end

  it "renders a list of chunks" do
    render
    response.should have_tag("tr>td", 0.8.to_s, 2)
  end

  it "should render a Download link when chunck is completed" do
    completed_chunk = @chunks.first
    completed_chunk.completion_rate = 1

    render
    response.should have_tag("a[href=?]", source_chunk_path(completed_chunk.source, completed_chunk, :format => "wav"))
  end
end
