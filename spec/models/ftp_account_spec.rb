require 'spec_helper'

describe FtpAccount do

  describe "#user" do
    it "should return nil if no credential is defined" do
      expect(subject.user).to be_nil
    end

    it "should return the first part of credential (before ':')" do
      subject.credential = 'username:secret'
      expect(subject.user).to eq('username')
    end
  end

  describe "#password" do
    it "should return nil if no credential is defined" do
      expect(subject.password).to be_nil
    end

    it "should return the first part of credential (before ':')" do
      subject.credential = 'username:secret'
      expect(subject.password).to eq('secret')
    end
  end

end
