require 'spec_helper'

describe "/labels/index.html.erb" do

  before(:each) do
    assigns[:source] = @source = Factory(:source)
    @labels = Array.new(2) {
      Factory(:label, :source => @source)
    }
    assigns[:labels] = @labels.paginate
  end

  it "should be a strict xhtml document" do
    render :layout => "application"
    response.body.should be_xhtml_strict
  end

end
