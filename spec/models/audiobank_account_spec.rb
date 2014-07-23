require 'spec_helper'

describe AudiobankAccount do

  describe "#remote_account" do
    it "should use the credential as token" do
      subject.credential = "dummy"
      subject.remote_account.token.should == subject.credential
    end
  end

end
