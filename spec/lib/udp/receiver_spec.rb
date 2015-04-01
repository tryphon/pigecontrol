# -*- coding: utf-8 -*-
require 'spec_helper'

describe UDP::Receiver do

  class TestReceiver
    include UDP::Receiver

    def send_data(data)
      Rails.logger.debug "TestReceiver send #{data}"
    end

  end

  subject { TestReceiver.new }

  describe "receive_data" do

    let(:message) { mock :create_label => true }

    before(:each) do
      UDP::Receiver::Message.stub :new => message
    end

    it "should create a Message" do
      UDP::Receiver::Message.should_receive(:new).with("dummy").and_return(message)
      subject.receive_data("dummy")
    end

    it "should create a label with message" do
      message.should_receive(:create_label)
      subject.receive_data("dummy")
    end

    it "should send 'ACK' when label is created" do
      message.stub :create_label => true
      subject.should_receive(:send_data).with("ACK")
      subject.receive_data("dummy")
    end

    it "should not send 'ACK' when label isn't created" do
      message.stub :create_label => false
      subject.should_not_receive(:send_data)
      subject.receive_data("dummy")
    end

    it "should log an error when exception is raised" do
      message.stub!(:create_label).and_raise("error")
      Rails.logger.should_receive(:error)
      subject.receive_data("dummy")
    end

  end

end

describe UDP::Receiver::Message do

  def message(attributes = {})
    attributes = { :data => attributes } if String === attributes
    attributes = { :data => "label: dummy" }.merge(attributes)

    UDP::Receiver::Message.new(attributes.delete(:data)).tap do |message|
      message.stub attributes
    end
  end

  subject { message }

  describe "raw_name" do

    it "should return text after 'label: '" do
      message("label: dummy").raw_name.should == "dummy"
    end

    it "should be nil if 'label: ' is not found" do
      message("dummy").raw_name.should be_nil
    end

    it "should strip label text" do
      message("label:   dummy  ").raw_name.should == "dummy"
    end

  end

  describe "name" do

    it "should be nil if raw_name is blank" do
      message(:raw_name => "").name.should be_nil
    end

    it "should be 'Manual - Begin' if raw_name is 'program_started'" do
      message(:raw_name => "program_started").name.should == "Manual - Begin"
    end

    it "should be 'Manual - End' if raw_name is 'program_stopped'" do
      message(:raw_name => "program_stopped").name.should == "Manual - End"
    end

    it "should be raw_name if not a predefined code" do
      message(:raw_name => "dummy").name.should == "dummy"
    end

  end

  describe "label" do

    it "should return a label with name" do
      message(:name => "dummy").label.name.should == "dummy"
    end

    it "should use default Source" do
      message.label.source.should == Source.default
    end

    it "should be a new record" do
      message.label.should be_new_record
    end

  end

  describe "create_label" do

    let(:label) { mock :save => true }

    before(:each) do
      subject.stub :label => label
    end

    it "should save label" do
      label.should_receive(:save)
      subject.create_label
    end

    it "should return true if label is saved" do
      label.stub :save => true
      subject.create_label.should be_true
    end

    it "should return false if label can't be saved" do
      label.stub :save => false
      subject.create_label.should be_false
    end

  end

end
