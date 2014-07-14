require 'spec_helper'

describe "/chunks/index.html.erb" do
  include ChunksHelper

  let(:source) { assign(:source, Factory(:source)) }
  let!(:chunks) { assign(:chunks, Array.new(2) { Factory(:chunk, :completion_rate => 0.8, :source => source) }) }

  it "renders a list of chunks" do
    render
    response.should have_selector("h3", :text => chunks.first.title)
  end

  it "should use link_to_download_chunk for each Chunk" do
    chunks.each do |chunk|
      template.should_receive(:link_to_download_chunk).with(chunk).and_return("<a href='/chunks/#{chunk.id}'></a>")
    end

    render

    chunks.each do |chunk|
      response.should have_selector("div[class=actions]") do |actions|
        actions.should have_selector("a[href='/chunks/#{chunk.id}']")
      end
    end
  end
end
