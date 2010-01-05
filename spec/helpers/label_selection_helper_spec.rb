require 'spec_helper'

describe LabelSelectionHelper do

  before(:each) do
    @label = Factory(:label)
    @label_selection = LabelSelection.new
  end

  describe "class_for_label_in_selection" do
    
    it "should be nil when label is neither begin nor end of selection" do
      helper.class_for_label_in_selection(@label_selection, @label)
    end

    it "should be begin when label is selection's begin" do
      @label_selection.stub!(:begin).and_return(@label)
      helper.class_for_label_in_selection(@label_selection, @label).should == "begin"
    end

    it "should be end when label is selection's end" do
      @label_selection.stub!(:end).and_return(@label)
      helper.class_for_label_in_selection(@label_selection, @label).should == "end"
    end

  end
end
