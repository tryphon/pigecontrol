require 'spec_helper'

describe LabelSearch do

  subject { LabelSearch.new(Source.default.labels) }

  describe "#per_page" do

    it "should be 20 per default" do
      subject.per_page.should == 20
    end

    it "should not exceed LabelSearch.max_per_page" do
      subject.per_page = LabelSearch.max_per_page + 1
      subject.per_page.should == LabelSearch.max_per_page
    end

    it "should not be zero or negative" do
      subject.per_page = 0
      subject.per_page.should == 1

      subject.per_page = -1
      subject.per_page.should == 1
    end

    it "should accept String value" do
      subject.per_page = "42"
      subject.per_page.should == 42
    end

  end

  describe "#order" do

    it "should be 'timestamp desc'" do
      subject.order.should == 'timestamp desc'
    end

  end

  describe "#before" do

    it "should accept a String value" do
      subject.before = "2014-09-13 10:30"
      subject.before.should == Time.new(2014,9,13,10,30)
    end

    it "should ignore a time in the future" do
      subject.before = 1.minute.from_now
      subject.before.should be_nil
    end

  end

  describe "#after" do

    it "should accept a String value" do
      subject.after = "2014-09-13 10:30"
      subject.after.should == Time.new(2014,9,13,10,30)
    end

  end

  describe "#on" do

    before do
      subject.now = Time.parse("2014-09-13 14:30")
    end

    context "today" do

      it "should define after at midnight this morning" do
        subject.on = :today
        subject.after.should be_at("2014-09-13 00:00")
      end

    end

    context "yesterday" do

      before do
        subject.on = :yesterday
      end

      it "should define 'after' at midnight yesterday" do
        subject.after.should be_at("2014-09-12 00:00")
      end

      it "should define 'before' at 23:59:59 yestarday" do
        subject.before.should be_at("2014-09-12 23:59:59")
      end

    end

  end

  describe "#search" do

    before do
      Factory.create_list :label, 20, :timestamp => 5.minutes.ago
    end

    it "should limit page size according per_page" do
      subject.search.size.should == subject.per_page
    end

    it "should return only Labels with specified term (if given)" do
      label = Factory :label, :name => "Dummy"
      subject.term = "dummy"
      subject.search.should == [ label ]
    end

    it "should return only Labels before specified time (if given)" do
      label = Factory :label, :timestamp => (3.days + 1.minute).ago
      subject.before = 3.days.ago
      subject.search.should == [ label ]
    end

    it "should return only Labels after specified time (if given)" do
      label = Factory :label
      subject.after = 1.minute.ago
      subject.search.should == [ label ]
    end

  end

end
