require 'spec_helper'

describe Chunk do

  before(:each) do
    @chunk = Factory(:chunk)
  end

  it { should validate_presence_of(:begin) }
  it { should validate_presence_of(:end) }

  it { should belong_to(:source) }

  it "should have a nil completion rate" do
    Chunk.new.completion_rate.should be_nil
  end

  describe "status" do
    
    it "should be created when completion_rate is nil" do
      @chunk.completion_rate = nil
      @chunk.status.should be_created
    end

    it "should be pending when completion rate is between 0 and 1.0" do
      @chunk.completion_rate = 0
      @chunk.status.should be_pending
    end
    
    it "should not completed when completion rate is 1.0" do
      @chunk.completion_rate = 1.0
      @chunk.status.should be_completed
    end

  end

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

  it "should remove fil when destroyed" do
    FileUtils.touch(@chunk.filename)
    @chunk.destroy
    File.exist?(@chunk.filename).should be_false
  end

  describe "create_file!" do

    before(:each) do
      @sox = mock(Sox::Command, :input => nil, :output => nil)
      Sox.stub!(:command).and_yield(@sox).and_return(true)
      
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

    it "should be completed when file is created" do
      @chunk.create_file!
      @chunk.status.should be_completed
    end

    it "should be pending while sox is running" do
      @sox.stub!(:command).and_return do
        @chunk.status.should be_pending
        true
      end
      @chunk.create_file!
    end

    it "should be created when file creation fails" do
      Sox.stub!(:command).and_return(false)
      @chunk.create_file!
      @chunk.status.should be_created
    end

  end

  it "should check_file_status when Chunk is created" do
    @chunk = Factory.build(:chunk)
    @chunk.should_receive(:check_file_status)
    @chunk.save!
  end

  describe "delete_file" do
    
    it "should delete file if file exists" do
      @chunk.stub!(:file).and_return("file")

      File.should_receive(:delete).with(@chunk.file)
      @chunk.delete_file
    end

    it "should not delete file if file doesn't exist" do
      @chunk.stub!(:file)

      File.should_not_receive(:delete)
      @chunk.delete_file
    end

  end

  describe "check_file_status" do

    def status(string_value)
      ActiveSupport::StringInquirer.new(string_value)
    end
    
    it "should create_file later if status is created" do
      @chunk.stub!(:status).and_return(status("created"))
      @chunk.should_receive(:send_later).with(:create_file!)
      @chunk.check_file_status
    end

    it "should create_file if status is pending" do
      @chunk.stub!(:status).and_return(status("pending"))
      @chunk.should_not_receive(:send_later)
      @chunk.check_file_status
    end

  end

end
