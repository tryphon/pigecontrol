require 'spec_helper'

describe "/chunks/index.html.erb" do
  include ChunksHelper

  before(:each) do
    assigns[:chunks] = Array.new(2) {
      Factory(:chunk, :completion_rate => 0.8)
    }
  end

  it "renders a list of chunks" do
    render
    response.should have_tag("tr>td", 0.8.to_s, 2)
  end
end
