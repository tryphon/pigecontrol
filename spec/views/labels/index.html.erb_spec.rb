require 'spec_helper'

describe "/labels/index.html.erb" do

  let(:source) { assign :source, Factory(:source) }
  let!(:labels)    { Array.new(2) { Factory(:label, :source => source) } }

  before(:each) do
    assign :labels, labels.paginate
  end

  it "should be a strict xhtml document" do
    pending "Markup validity not compatible for Rspec 2.x ..."

    view.stub :user_session => UserSession.new({})
    with_markup_validity do
      render # :layout => "application"
      response.body.should be_xhtml_strict
    end
  end

end
