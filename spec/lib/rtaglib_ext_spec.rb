require 'spec_helper'

describe TagFile::File, "open" do

  before(:each) do
    @filename = "filename"

    @taglib_file = mock(TagFile::File, :close => nil)
    TagFile::File.stub!(:new).and_return(@taglib_file)
  end

  it "should create a TagFile::File with given filename" do
    TagFile::File.should_receive(:new).with(@filename)
    TagFile::File.open(@filename) {}
  end

  it "should yield the given block with the TagFile::File and returns the block result" do
    TagFile::File.open(@filename) { |file| file }.should == @taglib_file
  end

  it "should close the TagFile::File" do
    @taglib_file.should_receive(:close)
    TagFile::File.open(@filename) {}
  end

end

describe TagFile::File do

  it "should support wav files" do
    TagFile::File.open(test_file(:wav)) { |f| f.length }.should be_close(15,0.1)
  end

end
