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

end
