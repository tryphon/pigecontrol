require 'spec_helper'

describe Source do

  before(:each) do
    @source = Factory(:source)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_numericality_of(:storage_limit, :greater_than_or_equal => 0) }

  it { should have_many(:chunks, :dependent => :destroy) }
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

  describe ".find_or_default" do
    
    it "should return default Source if id is 1" do
      Source.should_receive(:default).and_return(@source)
      Source.find_or_default(1).should == @source
    end

    it "should return default Source if id is '1'" do
      Source.should_receive(:default).and_return(@source)
      Source.find_or_default("1").should == @source
    end

    it "should find Source when id isn't 1" do
      Source.should_receive(:find).and_return(@source)
      Source.find_or_default(2).should == @source
    end

  end

  describe "default_chunk" do

    let(:last_record) { mock :end => 5.minutes.ago }
    let(:record_index) { mock :last_record => last_record }

    before(:each) do
      @source.stub :record_index => record_index
    end
    
    it "should be nil when no records exist" do
      @source.record_index.stub :last_record
      @source.default_chunk.should be_nil
    end

    it "should end at the end of the last record" do
      @source.default_chunk.end.should == last_record.end
    end

    def t(time)
      Time.parse(time)
    end

    it "should start at the begin of the last record hour (if possible)" do
      last_record.stub :end => t("10h30")
      @source.default_chunk.begin.should == t("10h")
    end

  end

  describe "remaining_storage_space" do

    before(:each) do
      @chunk = Factory(:chunk, :source => @source)
    end

    it "should be free space when storage limit is nil" do
      @source.stub!(:free_space).and_return(1.gigabyte)
      @source.remaining_storage_space.should == @source.free_space
    end

    it "should be free space when it's low than the storage limit" do
      @source.stub!(:free_space).and_return(1.megabyte)
      @source.storage_limit = 1.gigabyte
      @source.remaining_storage_space.should == @source.free_space
    end

    it "should be the difference between the storage limit and the actual stored chunks" do
      @source.storage_limit = 1.gigabyte
      @source.remaining_storage_space.should == @source.storage_limit - @chunk.size
    end

  end

  describe "can_store? " do

    before(:each) do
      @source.stub!(:remaining_storage_space).and_return(10.megabytes)
    end

    Spec::Matchers.define :be_able_to_store do |chunk|
      match do |source|
        source.can_store?(chunk)
      end
    end

    it "should return true if the given chunk doesn't exceed the remaining storage space" do
      @chunk.stub!(:size).and_return(@source.remaining_storage_space - 1)
      @source.should be_able_to_store(@chunk)
    end

    it "should return false if the given chunk exceeds the remaining storage space" do
      @chunk.stub!(:size).and_return(@source.remaining_storage_space)
      @source.should_not be_able_to_store(@chunk)
    end

  end

end
