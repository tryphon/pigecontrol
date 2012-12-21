require 'spec_helper'

describe Chunk do

  before(:each) do
    @chunk = Factory(:chunk)
  end

  let(:record) { Factory :record }

  it { should validate_presence_of(:begin) }
  it { should validate_presence_of(:end) }

  it { should belong_to(:source) }

  it "should have a nil completion rate" do
    Chunk.new.completion_rate.should be_nil
  end

  it "should validate that end is after begin" do
    @chunk.end = @chunk.begin - 1
    @chunk.should have(1).error_on(:end)
  end

  it "should have available records when using past records (no way they appear)" do
    @chunk.begin = record.begin - 1
    @chunk.end = record.end

    @chunk.should have(1).error_on(:begin)
    @chunk.should have(1).error_on(:end)
  end

  it "should not end after the latest record (chunk scheduling not available for the moment)" do
    @chunk.begin = record.begin
    @chunk.end = record.end + 1

    @chunk.should have(1).error_on(:end)
  end

  it "should accept to end at the latest record end" do
    @chunk.begin = record.begin
    @chunk.end = @chunk.source.record_index.last_record.end
    @chunk.should be_valid
  end

  describe "format" do

    it "should support symbols" do
      @chunk.format = :mp3
      @chunk.format.should == :mp3
    end

    it { should allow_values_for(:format, :wav, :vorbis, :mp3) }
    it { should_not allow_values_for(:format, :wma) }

  end

  describe "file extension" do

    it "should give .ogg ext when format is :vorbis" do
      @chunk.format = :vorbis
      @chunk.file_extension.should == "ogg"
    end
    it "should give .mp3 ext when format is :mp3" do
      @chunk.format = :mp3
      @chunk.file_extension.should == "mp3"
    end
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

  describe "record_set" do
    
    it "should retrieve set from source record_index" do
      record_index = mock(:set => true)
      # stub_chain refused to work ??
      @chunk.stub(:source => mock(:record_index => record_index))

      record_index.should_receive(:set).with(@chunk.begin, @chunk.end)
      @chunk.record_set
    end

  end

  describe "title" do

    it { should validate_uniqueness_of(:title) }
    it { should_not validate_presence_of(:title) }

    it "should not accept a title giving an existing filename" do
      Factory.build(:chunk, :title => File.basename(@chunk.filename, ".#{@chunk.file_extension}")).should_not be_valid
    end
    
  end

  describe "filename" do

    it "should be :storage_directory/:sanitized_title.:format if :title defined" do
      Chunk.stub!(:storage_directory).and_return("storage_directory")
      @chunk.title = "Toto et Titi"
      @chunk.stub :file_extension => "ext"

      @chunk.filename.should == "storage_directory/toto_et_titi.ext"
    end

  end

  describe "storage_directory" do

    before(:each) do
      @dummy_dir = "#{Rails.root}/tmp/dummy"
      reset
    end

    it "should be configurable" do
      Chunk.storage_directory = @dummy_dir
      Chunk.storage_directory.should == @dummy_dir
    end

    Spec::Matchers.define :exist do 
      match do |file|
        File.exists? file
      end
    end

    it "should create the directory" do
      Chunk.storage_directory = @dummy_dir
      Chunk.storage_directory.should exist
    end

    def reset
      Dir.rmdir @dummy_dir if File.exists?(@dummy_dir)
      Chunk.storage_directory = nil
    end

    after(:each) do
      reset
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

  describe "size" do

    it "should return the File size if exists" do
      @chunk.stub!(:file).and_return("dummy")
      File.should_receive(:size).with(@chunk.file).and_return(file_size = 10)
      @chunk.size.should == file_size
    end

    it "should return estimated size if file doesn't exist" do
      @chunk.stub!(:file)
      @chunk.stub!(:estimated_size).and_return(1.megabyte)
      @chunk.size.should == @chunk.estimated_size
    end

  end

  describe "estimated_size" do
    
    it "should be 10584000 bytes for a chunk of 1 minute" do
      @chunk.stub!(:duration).and_return(1.minute)
      @chunk.estimated_size.should == 10584000
    end

    it "should be nil if duration is unknown" do
      @chunk.stub!(:duration)      
      @chunk.estimated_size.should be_nil
    end

  end

  it "should remove file when destroyed" do
    FileUtils.touch(@chunk.filename)
    @chunk.destroy
    File.exist?(@chunk.filename).should be_false
  end

  describe "time_range" do
    
    it "should be nil if begin is nil" do
      @chunk.begin = nil
      @chunk.time_range.should be_nil
    end

    it "should be nil if end is nil" do
      @chunk.end = nil
      @chunk.time_range.should be_nil
    end

    it "should be nil if begin is after end" do
      @chunk.begin = @chunk.end + 5
      @chunk.time_range.should be_nil
    end

    it "should be chunk's begin..end when available" do
      @chunk.time_range.should == (@chunk.begin..@chunk.end)
    end

  end

  describe "#export_command" do

    before(:each) do
      @chunk.stub(:record_set => mock(:export_command => Sox::Command.new, :begin => 3.minutes.ago))
    end

    it "should use chunk filename as sox output" do
      @chunk.export_command.output.filename.should == @chunk.filename
    end

    it "should specify file_compression in sox output" do
      @chunk.export_command.output.options[:compression].should == @chunk.file_compression
    end

    it "should trim the output file when chunk duration is shorter than record files" do
      @chunk.begin = @chunk.record_set.begin + 3.minutes
      @chunk.end = @chunk.begin + 5.minutes

      @chunk.export_command.effects.first.should == Sox::Command::Effect.new(:trim, 3.minutes, @chunk.duration)
    end
    
  end

  describe "create_file!" do

    let(:export_command) { mock :run => true }

    before(:each) do
      @chunk.stub :export_command => export_command
    end

    it "should be completed when file is created" do
      @chunk.create_file!
      @chunk.status.should be_completed
    end

    it "should be pending while sox is running" do
      export_command.stub(:run).and_return do
        @chunk.status.should be_pending
        true
      end
      @chunk.create_file!
    end

    it "should be created when file creation fails" do
      export_command.stub :run => false
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

  it "should validate that source can store it" do
    @chunk.source.stub!(:can_store?).and_return(false)
    @chunk.should have(1).error_on(:base)
  end

end
