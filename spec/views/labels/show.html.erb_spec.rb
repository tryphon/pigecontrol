require 'spec_helper'

describe "/labels/show.html.erb" do

  let(:source) { assign :source, Factory(:source) }
  let!(:label) { assign :label, Factory(:label, :source => source) }

  it "should display label name" do
    render
    response.body.should include(label.name)
  end

end
