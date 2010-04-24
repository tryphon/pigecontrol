require 'spec_helper'

describe TagLib::File, "open" do

  before(:each) do
    @filename = "filename"

    @taglib_file = mock(TagLib::File, :close => nil)
    TagLib::File.stub!(:new).and_return(@taglib_file)
  end

  it "should create a TagLib::File with given filename" do
    TagLib::File.should_receive(:new).with(@filename)
    TagLib::File.open(@filename) {}
  end

  it "should yield the given block with the TagLib::File and returns the block result" do
    TagLib::File.open(@filename) { |file| file }.should == @taglib_file
  end

  it "should close the TagLib::File" do
    @taglib_file.should_receive(:close)
    TagLib::File.open(@filename) {}
  end

end

describe TagLib::File do

  it "should support wav files" do
    TagLib::File.open(test_file(:wav)) { |f| f.length }.should be_close(15.05,0.01)
  end

end
