require 'spec_helper'

describe Source do

  before(:each) do
    @source = Factory(:source)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_many(:chunks) }
  it { should have_many(:records) }

end
