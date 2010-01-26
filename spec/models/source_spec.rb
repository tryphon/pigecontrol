require 'spec_helper'

describe Source do

  before(:each) do
    @source = Factory(:source)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_many(:chunks, :dependent => :destroy) }
  it { should have_many(:records, :dependent => :destroy) }
  it { should have_many(:labels, :dependent => :destroy) }

  describe "default" do

    it "should find or create a Source with id 1" do
      Source.should_receive(:find_or_create_by_name).with('default').and_return(@source)
      Source.default.should == @source
    end

    it "should not be a new record" do
      Source.default.should_not be_new_record
    end

  end

  describe "default_chunk" do
    
    it "should be nil when no records exist" do
      @source.default_chunk.should be_nil
    end

    it "should end at the end of the last record" do
      last_record = Factory(:record, :source => @source).reload
      @source.default_chunk.end.should == last_record.end
    end

    def t(time)
      Time.parse(time)
    end

    it "should start at the begin of the last record hour (if possible)" do
      last_record = Factory(:record, :source => @source, :begin => t("09h30"), :end => t("10h30")).reload
      @source.default_chunk.begin.should == t("10h")
    end

    it "should start at the begin of the first record (if less than 1 hour is recorded)" do
      record = Factory(:record, :source => @source, :begin => t("09h15"), :end => t("09h30")).reload
      @source.default_chunk.begin.should == record.begin
    end

  end

end
