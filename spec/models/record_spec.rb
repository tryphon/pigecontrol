require 'spec_helper'

describe Record do

  before(:each) do
    @record = Factory(:record)
  end

  it { should validate_presence_of(:begin) }
  it { should validate_presence_of(:end) }
  it { should validate_presence_of(:filename) }
  it { should validate_uniqueness_of(:filename) }

  it { should belong_to(:source) }

  it "should validate that end is after begin" do
    @record.end = @record.begin - 1
    @record.should have(1).error_on(:end)
  end

  it "should be created with a begin and a filename" do
    Record.new(:begin => Time.now, :filename => test_file).should be_valid
  end

  describe "file_duration" do
    
    it "should return file duration in seconds" do
      @record.filename = test_file
      @record.file_duration.should == 14
    end

    it "should support ogg file" do
      @record.filename = test_file(:ogg)
      @record.file_duration.should == 14
    end

    it "should support wav file" do
      @record.filename = test_file(:wav)
      @record.file_duration.should == 15
    end

    it "should be nil when file isn't found" do
      @record.filename = "dummy"
      @record.file_duration.should be_nil
    end

    it "should be nil when filename isn't defined" do
      @record.filename = nil
      @record.file_duration.should be_nil
    end

    it "should TagLib to known file duration" do
      taglib_file = mock TagLib::File, :length => 10
      TagLib::File.should_receive(:open).with(@record.filename).and_yield(taglib_file)
      @record.file_duration.should == taglib_file.length
    end

    it "should be nil when TagLib::File fails" do
      TagLib::File.stub!(:open).and_raise("error")
      @record.file_duration.should be_nil
    end
    
  end

  describe "duration" do
    
    it "should be the file duration by default (when begin or end is missing)" do
      @record.begin = @record.end = nil
      @record.stub!(:file_duration).and_return(100)

      @record.duration.should == @record.file_duration
    end

    it "should be the distance between begin and end when both are defined" do
      @record.end = @record.begin + 5.minutes
      @record.duration.should == 5.minutes
    end

    it "should be the specified value if exists" do
      @record.begin = @record.end = nil

      @record.duration = 100
      @record.duration.should == 100
    end

  end

  describe "begin" do
    
    it "should be computated from end and duration when not defined" do
      @record.update_attributes :end => Time.now, :duration => 10.minutes, :begin => nil
      @record.begin.should == @record.end - @record.duration
    end

  end

  describe "end" do
    
    it "should be computated from begin and duration when not defined" do
      @record.update_attributes :begin => Time.now, :duration => 10.minutes, :end => nil
      @record.end.should == @record.begin + @record.duration
    end

  end

  describe "index_directory" do

    before(:each) do
      @directory = "dummy"
      @filenames = 
        [ "2009/11-Nov/16-Mon/18h17.wav", 
          "2009/11-Nov/16-Mon/18h30.wav"]
      Dir.stub!(:chdir).and_yield
      Dir.stub!(:glob).and_return(@filenames)

      File.stub!(:expand_path).and_return do |file|
        "/root/#{file}"
      end
    end

    it "should change directory to given one" do
      Dir.should_receive(:chdir).with(@directory)
      Record.index_directory @directory
    end

    it "should list wav and ogg files into given directory" do
      Dir.should_receive(:glob).with("**/*.{wav,ogg}", File::FNM_CASEFOLD).and_return(@filenames)
      Record.index_directory @directory
    end

    it "should find_or_create Records with found filenames" do
      @filenames.each do |filename|
        Record.should_receive(:find_or_create_by_filename).with hash_including(:filename => "/root/#{filename}")
      end
      Record.index_directory @directory
    end

    it "should return records with begins parsed from filenames (using utc)" do
      Record.index_directory(@directory).collect(&:begin).should == 
        [ Time.utc(2009,11,16,18,17), Time.utc(2009,11,16,18,30) ]
    end

  end

  describe "index_file" do

    before(:each) do
      @filename = "2009/11-Nov/16-Mon/18h17.wav"
      File.stub!(:expand_path).and_return do |file|
        "/root/#{file}"
      end
    end

    it "should find_or_create Records with found filenames" do
      Record.index_file(@filename).filename.should == "/root/#{@filename}"
    end

    it "should return records with begins parsed from filenames (using utc)" do
      Record.index_file(@filename).begin.should == Time.utc(2009,11,16,18,17)
    end

  end

  describe "index" do 

    before(:each) do
      @file = "/path/to/file"
    end

    it "should use Record.index_directory when the file is a directory" do
      File.stub!(:directory?).and_return(true)
      Record.should_receive(:index_directory).with(@file)

      Record.index(@file)
    end

    it "should use Record.index_file when the file isn't a directory" do
      File.stub!(:directory?).and_return(false)
      Record.should_receive(:index_file).with(@file)

      Record.index(@file)
    end

  end
  
end

describe Record, "including" do

  def t(time_definition)
    Time.parse(time_definition).utc
  end
  
  def hour_record(hour)
    Factory :record, :begin => t("#{hour}h"), :duration => 1.hour, :end => nil
  end
  
  before(:each) do
    @records = [ hour_record(8), hour_record(9), hour_record(10) ]
    @before = hour_record(7)
    @after = hour_record(11)
  end

  it "should select Records which ends after range begin and starts before range end" do
    Record.including(t("8h30"), t("10h30")).should == @records
  end

  it "should not include Records ended before the range begin" do
    Record.including(t("8h30"), t("10h30")).should_not include(@before)
  end

  it "should not include Records started after the range end" do
    Record.including(t("8h30"), t("10h30")).should_not include(@after)
  end
  
end
