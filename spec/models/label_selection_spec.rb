require 'spec_helper'

describe LabelSelection do

  before(:each) do
    @selection = LabelSelection.new

    @first_label = Factory(:label)
    @second_label = Factory(:label, :timestamp => @first_label.timestamp + 5)
  end

  it "should retrieve labels with given identifiers" do
    identifiers = [1,2]
    Label.should_receive(:find).with(identifiers)
    LabelSelection.new identifiers
  end

  it "should be empty at creation" do
    @selection.should be_empty
  end

  it "should add first label to selection" do
    @selection << @first_label
    @selection.should == [ @first_label ]
  end

  it "should notify change when label is added" do
    @selection.on_change &Proc.new{}
    @selection.should_receive(:notify_on_change)
    @selection << @first_label
  end

  it "should add second label to selection and sort them" do
    @selection << @second_label
    @selection << @first_label
    @selection.should == [ @first_label, @second_label ]
  end

  it "should keep two newest labels" do
    @selection << @first_label
    @selection << @second_label
    @selection << Factory(:label, :timestamp => @first_label.timestamp - 5)
    @selection.should == [ @first_label, @second_label ]
  end

  it "should be an Enumerable" do
    @selection.should == Enumerable::Enumerator.new(@selection).to_a
  end

  describe "clear" do
    
    it "should remove current selected labels" do
      @selection << @first_label
      @selection.clear
      @selection.should be_empty
    end

    it "should notify change" do
      @selection.on_change &Proc.new{}
      @selection.should_receive(:notify_on_change)
      @selection.clear
    end

  end

  describe "source" do

    it "should be nil if selection is empty" do
      @selection.source.should be_nil
    end

    it "should be the source of selected labels" do
      @selection << @first_label 
      @selection.source.should == @first_label.source
    end
    
  end

  describe "same_source?" do

    before(:each) do
      @selection.stub!(:source).and_return(Factory(:source))
    end
    
    it "should be true with LabelSelection source" do
      @selection.should be_same_source(@selection.source)
    end

    it "should be true with LabelSelection" do
      @selection.should be_same_source(@selection)
    end

    it "should be true with an argument which has the same source" do
      @selection.should be_same_source(mock("argument", :source => @selection.source))
    end

    it "should be false with nil" do
      @selection.should_not be_same_source(nil)      
    end

    it "should be false with nil" do
      @selection.stub!(:source) 
      @selection.should_not be_same_source(nil)      
    end

  end

  it "should clear selection if the label has a different source" do
    @selection << Factory(:label, :source => Factory(:source))
    @selection << @first_label
    @selection.should == [ @first_label ]
  end

  it "should not return a chunk when selection is empty" do
    @selection.chunk.should be_nil
  end

  it "should be completed when two labels are selected" do
    @selection << @first_label
    @selection << @second_label
    @selection.should be_completed
  end

  it "should not be completed when less than two labels are selected" do
    @selection << @first_label
    @selection.should_not be_completed
  end

  describe "built chunck" do

    before(:each) do
      @selection << @first_label
    end

    it "should begin at first label's timestamp" do
      @selection.chunk.begin.should == @first_label.timestamp
    end

    it "should end at second label's timestamp" do
      @selection << @second_label
      @selection.chunk.end.should == @second_label.timestamp
    end

    it "should end at first label timestamp when no second label is selected" do
      @selection.chunk.end.should == @first_label.timestamp
    end

  end

  describe "on_change" do
    
    it "should notify given block when selection changes" do
      @selection << @first_label

      notified_labels = []
      @selection.on_change do |labels|
        notified_labels.push *labels
      end

      @selection.notify_on_change

      @selection.should == notified_labels
    end

  end

  describe "can_begin?" do
    
    it "should be false when selection is completed" do
      @selection.stub!(:completed?).and_return(true)
      @selection.can_begin?(@first_label).should be_false
    end

    it "should be true when selection is empty" do
      @selection.can_begin?(@first_label).should be_true
    end

    it "should be true when label is before the selected one" do
      @selection << @second_label
      @selection.can_begin?(@first_label).should be_true
    end
    
  end

  describe "can_end?" do
    
    it "should be false when selection is completed" do
      @selection.stub!(:completed?).and_return(true)
      @selection.can_end?(@first_label).should be_false
    end

    it "should be true when selection is empty" do
      @selection.can_end?(@first_label).should be_true
    end

    it "should be true when label is before the selected one" do
      @selection << @first_label
      @selection.can_end?(@second_label).should be_true
    end
    
  end
  
end
