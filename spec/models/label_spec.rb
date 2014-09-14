require 'spec_helper'

describe Label do

  subject { Factory(:label) }

  # it { should validate_presence_of(:name) }
  # it { should validate_presence_of(:timestamp) }
  # it { should belong_to(:source) }

  let(:now) { Time.zone.now }

  it "should use Time.zone.now as default timestamp" do
    Time.zone.stub :now => now
    Label.new.timestamp.should == now
  end

  describe "date" do

    it "should return the date of timestamp" do
      subject.date.should == subject.timestamp.to_date
    end

  end

  describe "check_label_count" do

    before do
      Factory.create_list :label, 30
    end

    it "should remove oldes Labels to achieve 95% of max_label_count" do
      subject.stub max_label_count: 20
      subject.check_label_count
      Label.count.should == 19
    end


  end

end
