require 'spec_helper'

describe FtpUpload do

  describe "#target_uri" do

    it "should join FtpAccount url and upload target" do
      FtpUpload.new(:target => "to/dummy.flac", :account => FtpAccount.new(:url => "ftp://example.com/path")).target_uri.to_s.should == "ftp://example.com/path/to/dummy.flac"
    end

  end

  describe "#upload" do

    let(:ftp_server) { FakeFtp::Server.new(21212, 21213, :debug => true) }
    around(:each) do |example|
      ftp_server.start
      example.run
      ftp_server.stop
    end

    let(:local_file) { "tmp/uploaded_file" }
    let(:local_file_content) { SecureRandom.hex }

    it "should put local_file on target_url" do
      File.write local_file, local_file_content, :mode => "wb"
      upload = FtpUpload.new(:file => local_file, :target => "dummy.flac", :account => FtpAccount.new(:url => "ftp://localhost:21212"))
      upload.upload
      ftp_server.file("dummy.flac").data.should == local_file_content
    end

  end

end
