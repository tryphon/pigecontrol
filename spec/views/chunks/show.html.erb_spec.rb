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
end
