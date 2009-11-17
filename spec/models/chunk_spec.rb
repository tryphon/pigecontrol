require 'spec_helper'

describe Chunk do

  before(:each) do
    @chunk = Factory(:chunk)
  end

  it { should validate_presence_of(:begin) }
  it { should validate_presence_of(:end) }

  it { should belong_to(:source) }

  describe "records" do

    before(:each) do
      @chunk.stub!(:source).and_return(mock(Source, :records => mock("source records")))
      @records = Array.new(3) { mock Record }
    end
    
    it "should retrieve source recordings including chunck begin and end" do
      @chunk.source.records.should_receive(:including).with(@chunk.begin, @chunk.end).and_return(@records)
      @chunk.records.should == @records
    end

    it "should return an empty array when begin is not defined" do
      @chunk.begin = nil
      @chunk.records.should be_empty
    end

    it "should return an empty array when end is not defined" do
      @chunk.end = nil
      @chunk.records.should be_empty
    end
    
  end

  describe "filename" do

    it "should be :storage_directory/:id.wav" do
      Chunk.stub!(:storage_directory).and_return("storage_directory")
      @chunk.id = 1

      @chunk.filename.should == "storage_directory/1.wav"
    end

  end

  describe "file" do

    it "should return the file containing chunk content if exists" do
      File.should_receive(:exist?).with(@chunk.filename).and_return(true)
      @chunk.file.should == @chunk.filename
    end

    it "should be nil if file doesn't exist" do
      File.stub!(:exist?).and_return(false)
      @chunk.file.should be_nil
    end

  end

  describe "create_file!" do

    before(:each) do
      @sox = mock(Sox::Command, :input => nil, :output => nil)
      Sox.stub!(:command).and_yield(@sox)
      
      @records = Array.new(3) do |n| 
        mock(Record, :filename => "file#{n}")
      end
      @chunk.stub!(:records).and_return(@records)
    end

    it "should use record files as sox inputs" do
      @records.each do |record|
        @sox.should_receive(:input).with(record.filename)
      end
      @chunk.create_file!
    end

    it "should use chunk filename as sox output" do
      @sox.should_receive(:output).with(@chunk.filename)
      @chunk.create_file!
    end

  end

end
