# -*- coding: utf-8 -*-
require 'spec_helper'

describe LabelsHelper do

  before(:each) do
    @label = Factory(:label)
    @label_selection = LabelSelection.new
  end

  describe LabelsHelper::EndpointSelector do

    before(:each) do
      @selector = LabelsHelper::EndpointSelector.new @label, @label_selection, :begin, helper
    end
    
    it "should not be a link when label is already in the selection" do
      @label_selection << @label
      @selector.should_not be_link
    end

    it "should not be a link when label can't be an endpoint" do
      @selector.stub!(:can_be_endpoint?).and_return(false)
      @selector.should_not be_link
    end

    it "should use select_source_label_path" do
      helper.should_receive(:select_source_label_path).with(@label.source, @label).and_return("select_source_label_path")
      @selector.path.should == "select_source_label_path"
    end

    it "should can be endpoint if the label selection can begin/end with the label" do
      @label_selection.should_receive(:can_begin?).with(@label).and_return(true)
      @selector.can_be_endpoint?.should be_true
    end

    it "should be endpoint if the label is the begin/end of the selection" do
      @label_selection << @label
      @selector.should be_endpoint
    end

    describe "image_alt" do
      
      it "should be unicode character #8249 when endpoint is begin" do
        @selector.endpoint = :begin
        @selector.image_alt.should == "&#8249;"
      end

      it "should be unicode character #8250 when endpoint is end" do
        @selector.endpoint = :end
        @selector.image_alt.should == "&#8250;"
      end
      
    end

    describe "image_name" do

      before(:each) do
        @selector.endpoint = :endpoint

        @selector.stub!(:endpoint?).and_return(false)
        @selector.stub!(:can_be_endpoint?).and_return(false)
      end
      
      it "should be <endpoint> when selector is endpoint" do
        @selector.stub!(:endpoint?).and_return(true)
        @selector.image_name.should == "endpoint"
      end

      it "should be <endpoint>-gray when selector can be endpoint" do
        @selector.stub!(:can_be_endpoint?).and_return(true)
        @selector.image_name.should == "endpoint-gray"
      end

      it "should be <endpoint>-shadow when selector isn't and can't be endpoint" do
        @selector.image_name.should == "endpoint-shadow"
      end

    end

    it "should create image_tag with image_name and image_alt" do
      @selector.stub!(:image_name).and_return("image_name")
      @selector.stub!(:image_alt).and_return("image_alt")

      helper.should_receive(:image_tag).with("image_name.png", :alt => "image_alt")      
      @selector.image_tag
    end

    it "should create a link if needed" do
      @selector.stub!(:link?).and_return(false)
      @selector.link_to.should_not have_tag("a")
    end

    it "should create a link with image_tag as text" do
      @selector.stub!(:image_tag).and_return("image_tag")
      @selector.link_to.should have_tag("a", "image_tag")
    end

    it "should create a link with path" do
      @selector.link_to.should have_tag("a[href=?]", @selector.path)
    end

    it "should create a link with 'Sélectionner ce repère comme début' as title" do
      @selector.stub :endpoint => :begin
      @selector.link_to.should have_tag("a[title=?]", I18n.translate("label_selection.actions.select_begin"))
    end

    it "should create a link with 'Sélectionner ce repère comme fin' as title" do
      @selector.stub :endpoint => :end
      @selector.link_to.should have_tag("a[title=?]", I18n.translate("label_selection.actions.select_end"))
    end
   
  end

  describe "link_to_select_label" do
    
    before(:each) do
    end

    def mock_endpoint_selector(endpoint)
      LabelsHelper::EndpointSelector.should_receive(:new).with(@label, @label_selection, endpoint, helper).and_return(mock(LabelsHelper::EndpointSelector, :link_to => "#{endpoint}_link"))
    end

    it "should create two EndpointSelectors and concat created links" do
      mock_endpoint_selector :begin
      mock_endpoint_selector :end

      helper.link_to_select_label(@label, @label_selection).should == "begin_link end_link"
    end

  end

end
