# -*- coding: utf-8 -*-
require 'spec_helper'

describe ChunksHelper do

  let(:chunk) { Factory(:chunk) }

  describe "#link_to_download_chunk" do

    context "when the Chunk is completed" do

      before(:each) do
        chunk.stub :status => ActiveSupport::StringInquirer.new("completed")
      end

      describe "the link" do

        subject { helper.link_to_download_chunk(chunk) }

        it "should have link 'Télécharger' go to download chunk wav" do
          subject.should have_selector("a[href='#{source_chunk_path(chunk.source, chunk, :format => "wav")}']",  :text => "Télécharger")
        end

      end

    end

    context "when the Chunk isn't completed" do

      before(:each) do
        chunk.stub :status => ActiveSupport::StringInquirer.new("not completed")
      end

      describe "the link" do

        subject { helper.link_to_download_chunk(chunk) }

        it "should have chunk pending status as name" do
          subject.should have_selector("a", :text => I18n.translate("chunks.status.pending"))
        end

        it "should go to source_chunk_path" do
          subject.should have_selector("a[href='#{source_chunk_path(chunk.source, chunk)}']")
        end

        it "should have class 'download-pending'" do
          subject.should have_selector('a.download-pending')
        end

      end

    end

  end

end
