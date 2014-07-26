require 'spec_helper'

describe FtpUploadDecorator do

  let(:ftp_upload) { FtpUpload.new }
  subject { ftp_upload.decorate }

  describe "#target" do

    it "should return target url when length is less than 20" do
      ftp_upload.stub :target_uri => URI("ftp:/small/file.wav")
      subject.target.should == ftp_upload.target_uri.to_s
    end

    it "should truncate target url when length is more than 20" do
      ftp_upload.stub :target_uri => URI("ftp://rivendellallbox.vbx1.tryphon.priv/dropboxes/sine.flac")
      subject.target.should == ".../dropboxes/sine.flac"
    end

  end

end
